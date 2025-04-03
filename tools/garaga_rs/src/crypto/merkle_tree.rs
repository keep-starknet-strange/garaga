use crate::crypto::digest::{Digest, HashFunction};
use arbitrary::{Arbitrary, Unstructured};
use itertools::Itertools;
use lazy_static::lazy_static;
// use rayon::prelude::*;
use std::collections::hash_map::Entry::*;
use std::collections::*;
use std::fmt::Debug;
use std::result;
use thiserror::Error; // Add this import

// use crate::prelude::*;

const DEFAULT_PARALLELIZATION_CUTOFF: usize = 512;
lazy_static! {
    static ref PARALLELIZATION_CUTOFF: usize =
        std::env::var("TWENTY_FIRST_MERKLE_TREE_PARALLELIZATION_CUTOFF")
            .ok()
            .and_then(|v| v.parse().ok())
            .unwrap_or(DEFAULT_PARALLELIZATION_CUTOFF);
}

/// Enforces that all compilation targets have a consistent [`MAX_TREE_HEIGHT`].
/// In particular, if `usize` has more than 32 bits, the maximum height of a
/// Merkle tree is limited as if only 32 bits were available. If `usize` has
/// less than 32 bits, compilation will fail.
///
/// Using a type other than `usize` could enable a higher maximum height, but
/// would require a different storage mechanism for the Merkle tree's nodes:
/// indexing into a `Vec<_>` can only be done with `usize`.
const MAX_NUM_NODES: usize = 1 << (32 - 1);
const MAX_NUM_LEAFS: usize = MAX_NUM_NODES / 2;

/// The maximum height of a Merkle tree.
pub const MAX_TREE_HEIGHT: usize = MAX_NUM_LEAFS.ilog2() as usize;

type Result<T> = result::Result<T, MerkleTreeError>;

/// A [Merkle tree][merkle_tree] is a binary tree of [digests](Digest) that is
/// used to efficiently prove the inclusion of items in a set. Set inclusion can
/// be verified through an [inclusion proof](MerkleTreeInclusionProof).
///
/// The used hash function is [`Tip5`].
///
/// [merkle_tree]: https://en.wikipedia.org/wiki/Merkle_tree
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct MerkleTree<H: HashFunction> {
    nodes: Vec<Digest<H>>,
}

/// A full inclusion proof for the leafs at the supplied indices, including the
/// leafs themselves. The proof is relative to some [Merkle tree](MerkleTree),
/// which is not necessarily (and generally cannot be) known in its entirety by
/// the verifier.
#[derive(Debug, Clone, PartialEq, Eq, Default)]
pub struct MerkleTreeInclusionProof<H: HashFunction> {
    /// The stated height of the Merkle tree this proof is relative to.
    pub tree_height: usize,

    /// The leafs the proof is about, _i.e._, the revealed leafs.
    ///
    /// Purposefully not a [`HashMap`] to preserve order of the keys, which is
    /// relevant for [`into_authentication_paths`][paths].
    ///
    /// [paths]: MerkleTreeInclusionProof::into_authentication_paths
    pub indexed_leafs: Vec<(usize, Digest<H>)>,

    /// The proof's witness: de-duplicated authentication structure for the
    /// leafs this proof is about. See [`authentication_structure`][auth_structure]
    /// for details.
    ///
    /// [auth_structure]: MerkleTree::authentication_structure
    pub authentication_structure: Vec<Digest<H>>,
}

/// Helper struct for verifying inclusion of items in a Merkle tree.
///
/// Continuing the example from [`authentication_structure`][auth_structure],
/// the partial tree for leafs 0 and 2, _i.e._, nodes 8 and 10 respectively,
/// with nodes [11, 9, 3] from the authentication structure is:
///
/// ```markdown
///         ──── _ ────
///        ╱           ╲
///       _             3
///      ╱  ╲
///     ╱    ╲
///    _      _
///   ╱ ╲    ╱ ╲
///  8   9  10 11
/// ```
///
/// [auth_structure]: MerkleTree::authentication_structure
#[derive(Debug, Clone, PartialEq, Eq, Default)]
pub(crate) struct PartialMerkleTree<H: HashFunction> {
    tree_height: usize,
    leaf_indices: Vec<usize>,
    nodes: HashMap<usize, Digest<H>>,
}

impl<H: HashFunction> MerkleTree<H> {
    /// The index of the root node.
    ///
    /// If you need to read the root, try [`root()`](Self::root) instead.
    pub(crate) const ROOT_INDEX: usize = 1;

    /// Build a MerkleTree with the given leafs.
    ///
    /// [`MerkleTree::par_new`] is equivalent and usually faster.
    ///
    /// # Errors
    ///
    /// - If the number of leafs is zero.
    /// - If the number of leafs is not a power of two.
    pub fn sequential_new(leafs: &[Digest<H>]) -> Result<Self> {
        let mut nodes = Self::initialize_merkle_tree_nodes(leafs)?;

        for i in (MerkleTree::<H>::ROOT_INDEX..leafs.len()).rev() {
            nodes[i] =
                Digest::<H>::from_element(H::hash_pair(&nodes[i * 2].data, &nodes[i * 2 + 1].data));
        }

        Ok(MerkleTree { nodes })
    }

    /// Build a MerkleTree with the given leafs.
    ///
    /// Uses [`rayon`] to parallelize Merkle tree construction. If the use of
    /// [`rayon`] is not an option in your context, use
    /// [`MerkleTree::sequential_new`], which is equivalent but usually slower.
    ///
    /// # Errors
    ///
    /// - If the number of leafs is zero.
    /// - If the number of leafs is not a power of two.
    pub fn par_new(leafs: &[Digest<H>]) -> Result<Self> {
        let mut nodes = Self::initialize_merkle_tree_nodes(leafs)?;

        // (not) parallel
        let mut num_nodes_on_this_level = leafs.len();
        while num_nodes_on_this_level >= *PARALLELIZATION_CUTOFF {
            num_nodes_on_this_level /= 2;
            let node_indices_on_this_level = num_nodes_on_this_level..2 * num_nodes_on_this_level;
            let nodes_on_this_level = node_indices_on_this_level
                .clone()
                .map(|i| {
                    Digest::<H>::from_element(H::hash_pair(
                        &nodes[i * 2].data,
                        &nodes[i * 2 + 1].data,
                    ))
                })
                .collect::<Vec<_>>();
            nodes[node_indices_on_this_level].copy_from_slice(&nodes_on_this_level);
        }

        // sequential
        let num_remaining_nodes = num_nodes_on_this_level;
        for i in (MerkleTree::<H>::ROOT_INDEX..num_remaining_nodes).rev() {
            nodes[i] =
                Digest::<H>::from_element(H::hash_pair(&nodes[i * 2].data, &nodes[i * 2 + 1].data));
        }

        Ok(MerkleTree { nodes })
    }

    /// Helps to kick off Merkle tree construction. Sets up the Merkle tree's
    /// internal nodes if (and only if) it is possible to construct a Merkle
    /// tree with the given leafs.
    fn initialize_merkle_tree_nodes(leafs: &[Digest<H>]) -> Result<Vec<Digest<H>>> {
        if leafs.is_empty() {
            return Err(MerkleTreeError::TooFewLeafs);
        }

        let num_leafs = leafs.len();
        if !num_leafs.is_power_of_two() {
            return Err(MerkleTreeError::IncorrectNumberOfLeafs);
        }
        if num_leafs > MAX_NUM_LEAFS {
            return Err(MerkleTreeError::TreeTooHigh);
        }

        let mut nodes = vec![Digest::<H>::default(); 2 * num_leafs];
        nodes[num_leafs..].copy_from_slice(leafs);

        Ok(nodes)
    }

    /// Given a list of leaf indices, return the indices of exactly those nodes that
    /// are needed to prove (or verify) that the indicated leafs are in the Merkle
    /// tree.
    // This function is not defined as a method (taking self as argument) since it's
    // needed by the verifier, who does not have access to the Merkle tree.
    fn authentication_structure_node_indices(
        num_leafs: usize,
        leaf_indices: &[usize],
    ) -> Result<impl ExactSizeIterator<Item = usize>> {
        // The set of indices of nodes that need to be included in the authentications
        // structure. In principle, every node of every authentication path is needed.
        // The root is never needed. Hence, it is not considered below.
        let mut node_is_needed = HashSet::new();

        // The set of indices of nodes that can be computed from other nodes in the
        // authentication structure or the leafs that are explicitly supplied during
        // verification. Every node on the direct path from the leaf to the root can
        // be computed by the very nature of "authentication path".
        let mut node_can_be_computed = HashSet::new();

        for &leaf_index in leaf_indices {
            if leaf_index >= num_leafs {
                return Err(MerkleTreeError::LeafIndexInvalid { num_leafs });
            }

            let mut node_index = leaf_index + num_leafs;
            while node_index > Self::ROOT_INDEX {
                let sibling_index = node_index ^ 1;
                node_can_be_computed.insert(node_index);
                node_is_needed.insert(sibling_index);
                node_index /= 2;
            }
        }

        let set_difference = node_is_needed.difference(&node_can_be_computed).copied();
        Ok(set_difference.sorted_unstable().rev())
    }

    /// Generate a de-duplicated authentication structure for the given leaf indices.
    /// If a single index is supplied, the authentication structure is the
    /// authentication path for the indicated leaf.
    ///
    /// For example, consider the following Merkle tree.
    ///
    /// ```markdown
    ///         ──── 1 ────          ╮
    ///        ╱           ╲         │
    ///       2             3        │
    ///      ╱  ╲          ╱  ╲      ├╴ node indices
    ///     ╱    ╲        ╱    ╲     │
    ///    4      5      6      7    │
    ///   ╱ ╲    ╱ ╲    ╱ ╲    ╱ ╲   │
    ///  8   9  10 11  12 13  14 15  ╯
    ///
    ///  0   1  2   3  4   5  6   7  ←── leaf indices
    /// ```
    ///
    /// The authentication path for leaf 2, _i.e._, node 10, is nodes [11, 4, 3].
    ///
    /// The authentication structure for leafs 0 and 2, _i.e._, nodes 8 and 10
    /// respectively, is nodes [11, 9, 3].
    /// Note how:
    /// - Node 3 is included only once, even though the individual authentication
    ///   paths for leafs 0 and 2 both include node 3. This is one part of the
    ///   de-duplication.
    /// - Node 4 is not included at all, even though the authentication path for
    ///   leaf 2 requires the node: node 4 can be computed from nodes 8 and 9;
    ///   the former is supplied explicitly during [verification][verify],
    ///   the latter is included in the authentication structure.
    ///   This is the other part of the de-duplication.
    ///
    /// [verify]: MerkleTreeInclusionProof::verify
    pub fn authentication_structure(&self, leaf_indices: &[usize]) -> Result<Vec<Digest<H>>> {
        let num_leafs = self.num_leafs();
        let indices = Self::authentication_structure_node_indices(num_leafs, leaf_indices)?;
        let auth_structure = indices.map(|idx| self.nodes[idx]).collect();
        Ok(auth_structure)
    }

    pub fn root(&self) -> Digest<H> {
        self.nodes[Self::ROOT_INDEX]
    }

    pub fn num_leafs(&self) -> usize {
        let node_count = self.nodes.len();
        debug_assert!(node_count.is_power_of_two());
        node_count / 2
    }

    pub fn height(&self) -> usize {
        let leaf_count = self.num_leafs();
        debug_assert!(leaf_count.is_power_of_two());
        leaf_count.ilog2() as usize
    }

    /// All nodes of the Merkle tree.
    pub fn nodes(&self) -> &[Digest<H>] {
        &self.nodes
    }

    /// The node at the given node index, if it exists.
    pub fn node(&self, index: usize) -> Option<Digest<H>> {
        self.nodes.get(index).copied()
    }

    /// All leafs of the Merkle tree.
    pub fn leafs(&self) -> &[Digest<H>] {
        let first_leaf = self.nodes.len() / 2;
        &self.nodes[first_leaf..]
    }

    /// The leaf at the given index, if it exists.
    pub fn leaf(&self, index: usize) -> Option<Digest<H>> {
        let first_leaf_index = self.nodes.len() / 2;
        self.nodes.get(first_leaf_index + index).copied()
    }

    pub fn indexed_leafs(&self, indices: &[usize]) -> Result<Vec<(usize, Digest<H>)>> {
        let num_leafs = self.num_leafs();
        let invalid_index = MerkleTreeError::LeafIndexInvalid { num_leafs };
        let maybe_indexed_leaf = |&i| self.leaf(i).ok_or(invalid_index).map(|leaf| (i, leaf));

        indices.iter().map(maybe_indexed_leaf).collect()
    }

    /// A full inclusion proof for the leafs at the supplied indices, including the
    /// leafs. Generally, using [`authentication_structure`][auth_structure] is
    /// preferable. Use this method only if the verifier needs explicit access to the
    /// leafs, _i.e._, cannot compute them from other information.
    ///
    /// [auth_structure]: Self::authentication_structure
    pub fn inclusion_proof_for_leaf_indices(
        &self,
        indices: &[usize],
    ) -> Result<MerkleTreeInclusionProof<H>> {
        let proof = MerkleTreeInclusionProof {
            tree_height: self.height(),
            indexed_leafs: self.indexed_leafs(indices)?,
            authentication_structure: self.authentication_structure(indices)?,
        };
        Ok(proof)
    }

    // fn test_tree_of_height(tree_height: usize) -> Self {
    //     let num_leafs = 1 << tree_height;
    //     let leafs = (0..num_leafs)
    //         .map(|i| Digest::new(H::random()))
    //         .collect_vec();
    //     let tree = Self::par_new(&leafs).unwrap();
    //     assert!(leafs.iter().all_unique());
    //     tree
    // }
}

impl<'a, H: HashFunction> Arbitrary<'a> for MerkleTree<H> {
    fn arbitrary(u: &mut Unstructured<'a>) -> arbitrary::Result<Self> {
        let height = u.int_in_range(0..=13)?;
        let num_leafs = 1 << height;
        let leaf_digests: arbitrary::Result<Vec<_>> =
            (0..num_leafs).map(|_| u.arbitrary()).collect();

        let tree = Self::par_new(&leaf_digests?).unwrap();
        Ok(tree)
    }
}

impl<H: HashFunction> MerkleTreeInclusionProof<H> {
    fn leaf_indices(&self) -> impl Iterator<Item = &usize> {
        self.indexed_leafs.iter().map(|(index, _)| index)
    }

    fn is_trivial(&self) -> bool {
        self.indexed_leafs.is_empty() && self.authentication_structure.is_empty()
    }

    /// Verify that the given root digest is the root of a Merkle tree that contains
    /// the indicated leafs.
    pub fn verify(self, expected_root: Digest<H>) -> bool {
        if self.is_trivial() {
            return true;
        }
        let Ok(partial_tree) = PartialMerkleTree::try_from(self) else {
            return false;
        };
        let Ok(computed_root) = partial_tree.root() else {
            return false;
        };
        computed_root == expected_root
    }

    /// Transform the inclusion proof into a list of authentication paths.
    ///
    /// This corresponds to a decompression of the authentication structure.
    /// In some contexts, it is easier to deal with individual authentication paths
    /// than with the de-duplicated authentication structure.
    ///
    /// Continuing the example from [`authentication_structure`][auth_structure],
    /// the authentication structure for leafs 0 and 2, _i.e._, nodes 8 and 10
    /// respectively, is nodes [11, 9, 3].
    ///
    /// The authentication path
    /// - for leaf 0 is [9, 5, 3], and
    /// - for leaf 2 is [11, 4, 3].
    ///
    /// ```markdown
    ///         ──── 1 ────
    ///        ╱           ╲
    ///       2             3
    ///      ╱  ╲          ╱  ╲
    ///     ╱    ╲        ╱    ╲
    ///    4      5      6      7
    ///   ╱ ╲    ╱ ╲    ╱ ╲    ╱ ╲
    ///  8   9  10 11  12 13  14 15
    /// ```
    ///
    /// [auth_structure]: MerkleTree::authentication_structure
    pub fn into_authentication_paths(self) -> Result<Vec<Vec<Digest<H>>>> {
        let partial_tree = PartialMerkleTree::try_from(self)?;
        partial_tree.into_authentication_paths()
    }
}

impl<H: HashFunction> PartialMerkleTree<H> {
    pub fn root(&self) -> Result<Digest<H>> {
        self.nodes
            .get(&MerkleTree::<H>::ROOT_INDEX)
            .copied()
            .ok_or(MerkleTreeError::RootNotFound)
    }

    fn node(&self, index: usize) -> Result<Digest<H>> {
        self.nodes
            .get(&index)
            .copied()
            .ok_or(MerkleTreeError::MissingNodeIndex(index))
    }

    fn num_leafs(&self) -> Result<usize> {
        if self.tree_height > MAX_TREE_HEIGHT {
            return Err(MerkleTreeError::TreeTooHigh);
        }
        Ok(1 << self.tree_height)
    }

    /// Compute all computable digests of the partial Merkle tree, modifying self.
    /// Returns an error if self is either
    /// - incomplete, _i.e._, does not contain all the nodes required to compute
    ///   the root, or
    /// - not minimal, _i.e._, if it contains nodes that can be computed from other
    ///   nodes.
    pub fn fill(&mut self) -> Result<()> {
        let mut parent_node_indices = self.first_layer_parent_node_indices()?;

        for _ in 0..self.tree_height {
            for &parent_node_index in &parent_node_indices {
                self.insert_digest_for_index(parent_node_index)?;
            }
            parent_node_indices = Self::move_indices_one_layer_up(parent_node_indices);
        }

        Ok(())
    }

    /// Any parent node index is included only once. This guarantees that the number
    /// of hash operations is minimal.
    fn first_layer_parent_node_indices(&self) -> Result<Vec<usize>> {
        let num_leafs = self.num_leafs()?;
        let leaf_to_parent_node_index = |&leaf_index| (leaf_index + num_leafs) / 2;

        let parent_node_indices = self.leaf_indices.iter().map(leaf_to_parent_node_index);
        let mut parent_node_indices = parent_node_indices.collect_vec();
        parent_node_indices.sort_unstable();
        parent_node_indices.dedup();
        Ok(parent_node_indices)
    }

    fn insert_digest_for_index(&mut self, parent_index: usize) -> Result<()> {
        let (left_child, right_child) = self.children_of_node(parent_index)?;
        let parent_digest =
            Digest::<H>::from_element(H::hash_pair(&left_child.data, &right_child.data));

        match self.nodes.insert(parent_index, parent_digest) {
            Some(_) => Err(MerkleTreeError::SpuriousNodeIndex(parent_index)),
            None => Ok(()),
        }
    }

    fn children_of_node(&self, parent_index: usize) -> Result<(Digest<H>, Digest<H>)> {
        let left_child_index = parent_index * 2;
        let right_child_index = left_child_index ^ 1;

        let left_child = self.node(left_child_index)?;
        let right_child = self.node(right_child_index)?;
        Ok((left_child, right_child))
    }

    /// Indices are deduplicated to guarantee minimal number of hash operations.
    fn move_indices_one_layer_up(mut indices: Vec<usize>) -> Vec<usize> {
        indices.iter_mut().for_each(|i| *i /= 2);
        indices.dedup();
        indices
    }

    /// Collect all individual authentication paths for the indicated leafs.
    fn into_authentication_paths(self) -> Result<Vec<Vec<Digest<H>>>> {
        self.leaf_indices
            .iter()
            .map(|&i| self.authentication_path_for_index(i))
            .collect()
    }

    /// Given a single leaf index and a partial Merkle tree, collect the
    /// authentication path for the indicated leaf.
    ///
    /// Fails if the partial Merkle tree does not contain the entire
    /// authentication path.
    fn authentication_path_for_index(&self, leaf_index: usize) -> Result<Vec<Digest<H>>> {
        let num_leafs = self.num_leafs()?;
        let mut authentication_path = vec![];
        let mut node_index = leaf_index + num_leafs;
        while node_index > MerkleTree::<H>::ROOT_INDEX {
            let sibling_index = node_index ^ 1;
            let sibling = self.node(sibling_index)?;
            authentication_path.push(sibling);
            node_index /= 2;
        }
        Ok(authentication_path)
    }
}

impl<H: HashFunction> TryFrom<MerkleTreeInclusionProof<H>> for PartialMerkleTree<H> {
    type Error = MerkleTreeError;

    fn try_from(proof: MerkleTreeInclusionProof<H>) -> Result<Self> {
        let leaf_indices = proof.leaf_indices().copied().collect();
        let mut partial_tree = PartialMerkleTree {
            tree_height: proof.tree_height,
            leaf_indices,
            nodes: HashMap::new(),
        };

        let num_leafs = partial_tree.num_leafs()?;
        if partial_tree.leaf_indices.iter().any(|&i| i >= num_leafs) {
            return Err(MerkleTreeError::LeafIndexInvalid { num_leafs });
        }

        let node_indices = MerkleTree::<H>::authentication_structure_node_indices(
            num_leafs,
            &partial_tree.leaf_indices,
        )?;
        if proof.authentication_structure.len() != node_indices.len() {
            return Err(MerkleTreeError::AuthenticationStructureLengthMismatch);
        }

        let mut nodes: HashMap<_, _> = node_indices
            .zip_eq(proof.authentication_structure)
            .collect();

        for (leaf_index, leaf_digest) in proof.indexed_leafs {
            let node_index = leaf_index + num_leafs;
            if let Vacant(entry) = nodes.entry(node_index) {
                entry.insert(leaf_digest);
            } else if nodes[&node_index] != leaf_digest {
                return Err(MerkleTreeError::RepeatedLeafDigestMismatch);
            }
        }

        partial_tree.nodes = nodes;
        partial_tree.fill()?;
        Ok(partial_tree)
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Error)]
pub enum MerkleTreeError {
    #[error("All leaf indices must be valid, i.e., less than {num_leafs}.")]
    LeafIndexInvalid { num_leafs: usize },

    #[error("The length of the supplied authentication structure must match the expected length.")]
    AuthenticationStructureLengthMismatch,

    #[error("Leaf digests of repeated indices must be identical.")]
    RepeatedLeafDigestMismatch,

    #[error("The partial tree must be minimal. Node {0} was supplied but can be computed.")]
    SpuriousNodeIndex(usize),

    #[error("The partial tree must contain all necessary information. Node {0} is missing.")]
    MissingNodeIndex(usize),

    #[error("Could not compute the root. Maybe no leaf indices were supplied?")]
    RootNotFound,

    #[error("Too few leafs to build a Merkle tree.")]
    TooFewLeafs,

    #[error("The number of leafs must be a power of two.")]
    IncorrectNumberOfLeafs,

    #[error("Tree height must not exceed {MAX_TREE_HEIGHT}.")]
    TreeTooHigh,
}

// #[cfg(test)]
// pub mod merkle_tree_test {
//     use crate::crypto::digest::*;
//     use crate::definitions::{FieldElement, GrumpkinPrimeField};
//     use proptest::collection::vec;
//     use proptest::prelude::*;
//     use proptest_arbitrary_interop::arb;
//     use test_strategy::proptest;

//     use super::*;
//     use crate::crypto::digest::digest_tests::DigestCorruptor;

//     impl MerkleTree<PoseidonBn254Hash> {
//         fn test_tree_of_height(tree_height: usize) -> Self {
//             let num_leafs = 1 << tree_height;
//             let leafs = (0..num_leafs)
//                 .map(|i| Digest::new(FieldElement::<GrumpkinPrimeField>::from(i)))
//                 .collect_vec();
//             let tree = Self::par_new(&leafs).unwrap();
//             assert!(leafs.iter().all_unique());
//             tree
//         }
//     }

//     impl PartialMerkleTree<PoseidonBn254Hash> {
//         fn dummy_nodes_for_indices(
//             node_indices: &[usize],
//         ) -> HashMap<usize, Digest<PoseidonBn254Hash>> {
//             node_indices
//                 .iter()
//                 .map(|&i| (i, FieldElement::<GrumpkinPrimeField>::from(i as u64)))
//                 .map(|(i, leaf)| (i, Digest::new(PoseidonBn254Hash::hash_single(&leaf))))
//                 .collect()
//         }
//     }

//     /// Test helper to deduplicate generation of Merkle trees.
//     #[derive(Debug, Clone, test_strategy::Arbitrary)]
//     pub(crate) struct MerkleTreeToTest {
//         #[strategy(arb())]
//         pub tree: MerkleTree<PoseidonBn254Hash>,

//         #[strategy(vec(0..#tree.num_leafs(), 0..#tree.num_leafs()))]
//         pub selected_indices: Vec<usize>,
//     }

//     impl MerkleTreeToTest {
//         fn has_non_trivial_proof(&self) -> bool {
//             !self.selected_indices.is_empty()
//         }

//         fn proof(&self) -> MerkleTreeInclusionProof<PoseidonBn254Hash> {
//             // test helper – unwrap is fine
//             self.tree
//                 .inclusion_proof_for_leaf_indices(&self.selected_indices)
//                 .unwrap()
//         }
//     }

//     #[test]
//     fn building_merkle_tree_from_empty_list_of_digests_fails_with_expected_error() {
//         let maybe_tree = MerkleTree::<PoseidonBn254Hash>::par_new(&[]);
//         let err = maybe_tree.unwrap_err();
//         assert_eq!(MerkleTreeError::TooFewLeafs, err);
//     }

//     #[test]
//     fn merkle_tree_with_one_leaf_has_expected_height_and_number_of_leafs() {
//         let digest = Digest::<PoseidonBn254Hash>::default();
//         let tree = MerkleTree::<PoseidonBn254Hash>::par_new(&[digest]).unwrap();
//         assert_eq!(1, tree.num_leafs());
//         assert_eq!(0, tree.height());
//     }

//     #[proptest]
//     fn building_merkle_tree_from_one_digest_makes_that_digest_the_root(
//         digest: Digest<PoseidonBn254Hash>,
//     ) {
//         let tree = MerkleTree::par_new(&[digest]).unwrap();
//         assert_eq!(digest, tree.root());
//     }

//     #[proptest]
//     fn building_merkle_tree_from_list_of_digests_with_incorrect_number_of_leafs_fails(
//         #[filter(!#num_leafs.is_power_of_two())]
//         #[strategy(1_usize..1 << 13)]
//         num_leafs: usize,
//     ) {
//         let digest = Digest::<PoseidonBn254Hash>::default();
//         let digests = vec![digest; num_leafs];
//         let maybe_tree = MerkleTree::<PoseidonBn254Hash>::par_new(&digests);
//         let err = maybe_tree.unwrap_err();
//         assert_eq!(MerkleTreeError::IncorrectNumberOfLeafs, err);
//     }

//     #[proptest]
//     fn merkle_tree_construction_strategies_behave_identically_on_random_input(
//         leafs: Vec<Digest<PoseidonBn254Hash>>,
//     ) {
//         let sequential = MerkleTree::sequential_new(&leafs);
//         let parallel = MerkleTree::par_new(&leafs);
//         prop_assert_eq!(sequential, parallel);
//     }

//     #[proptest]
//     fn merkle_tree_construction_strategies_produce_identical_trees(
//         #[strategy(0_usize..10)] _tree_height: usize,
//         #[strategy(vec(arb(), 1 << #_tree_height))] leafs: Vec<Digest<PoseidonBn254Hash>>,
//     ) {
//         let sequential = MerkleTree::sequential_new(&leafs)?;
//         let parallel = MerkleTree::par_new(&leafs)?;
//         prop_assert_eq!(sequential, parallel);
//     }

//     #[proptest(cases = 100)]
//     fn accessing_number_of_leafs_and_height_never_panics(
//         #[strategy(arb())] merkle_tree: MerkleTree<PoseidonBn254Hash>,
//     ) {
//         let _ = merkle_tree.num_leafs();
//         let _ = merkle_tree.height();
//     }

//     #[proptest(cases = 50)]
//     fn trivial_proof_can_be_verified(
//         #[strategy(arb())] merkle_tree: MerkleTree<PoseidonBn254Hash>,
//     ) {
//         let proof = merkle_tree.inclusion_proof_for_leaf_indices(&[]).unwrap();
//         prop_assert!(proof.authentication_structure.is_empty());
//         let verdict = proof.verify(merkle_tree.root());
//         prop_assert!(verdict);
//     }

//     #[proptest(cases = 40)]
//     fn honestly_generated_authentication_structure_can_be_verified(test_tree: MerkleTreeToTest) {
//         let proof = test_tree.proof();
//         let verdict = proof.verify(test_tree.tree.root());
//         prop_assert!(verdict);
//     }

//     #[proptest(cases = 30)]
//     fn corrupt_root_leads_to_verification_failure(
//         #[filter(#test_tree.has_non_trivial_proof())] test_tree: MerkleTreeToTest,
//         corruptor: DigestCorruptor,
//     ) {
//         let bad_root = corruptor.corrupt_digest(test_tree.tree.root());
//         let proof = test_tree.proof();
//         let verdict = proof.verify(bad_root);
//         prop_assert!(!verdict);
//     }

//     #[proptest(cases = 20)]
//     fn corrupt_authentication_structure_leads_to_verification_failure(
//         #[filter(!#test_tree.proof().authentication_structure.is_empty())]
//         test_tree: MerkleTreeToTest,
//         #[strategy(Just(#test_tree.proof().authentication_structure.len()))]
//         _num_auth_structure_entries: usize,
//         #[strategy(vec(0..#_num_auth_structure_entries, 1..=#_num_auth_structure_entries))]
//         indices_to_corrupt: Vec<usize>,
//         #[strategy(vec(any::<DigestCorruptor>(),  #indices_to_corrupt.len()))]
//         digest_corruptors: Vec<DigestCorruptor>,
//     ) {
//         let mut proof = test_tree.proof();
//         for (i, digest_corruptor) in indices_to_corrupt.into_iter().zip_eq(digest_corruptors) {
//             proof.authentication_structure[i] =
//                 digest_corruptor.corrupt_digest(proof.authentication_structure[i]);
//         }
//         if proof == test_tree.proof() {
//             let reject_reason = "corruption must change authentication structure".into();
//             return Err(TestCaseError::Reject(reject_reason));
//         }

//         let verdict = proof.verify(test_tree.tree.root());
//         prop_assert!(!verdict);
//     }

//     #[proptest(cases = 30)]
//     fn corrupt_leaf_digests_lead_to_verification_failure(
//         #[filter(#test_tree.has_non_trivial_proof())] test_tree: MerkleTreeToTest,
//         #[strategy(Just(#test_tree.proof().indexed_leafs.len()))] _n_leafs: usize,
//         #[strategy(vec(0..#_n_leafs, 1..=#_n_leafs))] leafs_to_corrupt: Vec<usize>,
//         #[strategy(vec(any::<DigestCorruptor>(), #leafs_to_corrupt.len()))] digest_corruptors: Vec<
//             DigestCorruptor,
//         >,
//     ) {
//         let mut proof = test_tree.proof();
//         for (&i, digest_corruptor) in leafs_to_corrupt.iter().zip_eq(&digest_corruptors) {
//             let (leaf_index, leaf_digest) = proof.indexed_leafs[i];
//             let corrupt_digest = digest_corruptor.corrupt_digest(leaf_digest);
//             proof.indexed_leafs[i] = (leaf_index, corrupt_digest);
//         }
//         if proof == test_tree.proof() {
//             let reject_reason = "corruption must change leaf digests".into();
//             return Err(TestCaseError::Reject(reject_reason));
//         }

//         let verdict = proof.verify(test_tree.tree.root());
//         prop_assert!(!verdict);
//     }

//     #[proptest(cases = 30)]
//     fn removing_leafs_from_proof_leads_to_verification_failure(
//         #[filter(#test_tree.has_non_trivial_proof())] test_tree: MerkleTreeToTest,
//         #[strategy(Just(#test_tree.proof().indexed_leafs.len()))] _n_leafs: usize,
//         #[strategy(vec(0..#_n_leafs, 1..=#_n_leafs))] leaf_indices_to_remove: Vec<usize>,
//     ) {
//         let mut proof = test_tree.proof();
//         let leafs_to_keep = proof
//             .indexed_leafs
//             .iter()
//             .filter(|(i, _)| !leaf_indices_to_remove.contains(i));
//         proof.indexed_leafs = leafs_to_keep.copied().collect();
//         if proof == test_tree.proof() {
//             let reject_reason = "removing leafs must change proof".into();
//             return Err(TestCaseError::Reject(reject_reason));
//         }

//         let verdict = proof.verify(test_tree.tree.root());
//         prop_assert!(!verdict);
//     }

//     #[proptest(cases = 30)]
//     fn checking_set_inclusion_of_items_not_in_set_leads_to_verification_failure(
//         #[filter(#test_tree.has_non_trivial_proof())] test_tree: MerkleTreeToTest,
//         #[strategy(vec(0..#test_tree.tree.num_leafs(), 1..=#test_tree.tree.num_leafs()))]
//         spurious_indices: Vec<usize>,
//         #[strategy(vec(any::<Digest<PoseidonBn254Hash>>(), #spurious_indices.len()))]
//         spurious_digests: Vec<Digest<PoseidonBn254Hash>>,
//     ) {
//         let spurious_leafs = spurious_indices
//             .into_iter()
//             .zip_eq(spurious_digests)
//             .collect_vec();
//         let mut proof = test_tree.proof();
//         proof.indexed_leafs.extend(spurious_leafs);

//         let verdict = proof.verify(test_tree.tree.root());
//         prop_assert!(!verdict);
//     }

//     #[proptest(cases = 30)]
//     fn honestly_generated_proof_with_duplicate_leafs_can_be_verified(
//         #[filter(#test_tree.has_non_trivial_proof())] test_tree: MerkleTreeToTest,
//         #[strategy(Just(#test_tree.proof().indexed_leafs.len()))] _n_leafs: usize,
//         #[strategy(vec(0..#_n_leafs, 1..=#_n_leafs))] indices_to_duplicate: Vec<usize>,
//     ) {
//         let mut proof = test_tree.proof();
//         let duplicate_leafs = indices_to_duplicate
//             .into_iter()
//             .map(|i| proof.indexed_leafs[i])
//             .collect_vec();
//         proof.indexed_leafs.extend(duplicate_leafs);
//         let verdict = proof.verify(test_tree.tree.root());
//         prop_assert!(verdict);
//     }

//     #[proptest(cases = 40)]
//     fn incorrect_tree_height_leads_to_verification_failure(
//         #[filter(#test_tree.has_non_trivial_proof())] test_tree: MerkleTreeToTest,
//         #[strategy(0..=MAX_TREE_HEIGHT)]
//         #[filter(#test_tree.tree.height() != #incorrect_height)]
//         incorrect_height: usize,
//     ) {
//         let mut proof = test_tree.proof();
//         proof.tree_height = incorrect_height;
//         let verdict = proof.verify(test_tree.tree.root());
//         prop_assert!(!verdict);
//     }

//     #[proptest(cases = 20)]
//     fn honestly_generated_proof_with_all_leafs_revealed_can_be_verified(
//         #[strategy(arb())] tree: MerkleTree<PoseidonBn254Hash>,
//     ) {
//         let leaf_indices = (0..tree.num_leafs()).collect_vec();
//         let proof = tree
//             .inclusion_proof_for_leaf_indices(&leaf_indices)
//             .unwrap();
//         let verdict = proof.verify(tree.root());
//         prop_assert!(verdict);
//     }

//     #[proptest(cases = 30)]
//     fn requesting_inclusion_proof_for_nonexistent_leaf_fails_with_expected_error(
//         #[strategy(arb())] tree: MerkleTree<PoseidonBn254Hash>,
//         #[filter(#leaf_indices.iter().any(|&i| i > #tree.num_leafs()))] leaf_indices: Vec<usize>,
//     ) {
//         let maybe_proof = tree.inclusion_proof_for_leaf_indices(&leaf_indices);
//         let err = maybe_proof.unwrap_err();

//         let num_leafs = tree.num_leafs();
//         assert_eq!(MerkleTreeError::LeafIndexInvalid { num_leafs }, err);
//     }

//     #[test]
//     fn authentication_paths_of_extremely_small_tree_use_expected_digests() {
//         //     _ 1_
//         //    /    \
//         //   2      3
//         //  / \    / \
//         // 4   5  6   7
//         //
//         // 0   1  2   3 <- leaf indices

//         let tree = MerkleTree::test_tree_of_height(2);
//         let auth_path_with_nodes = |indices: [usize; 2]| indices.map(|i| tree.nodes[i]).to_vec();
//         let auth_path_for_leaf = |index| tree.authentication_structure(&[index]).unwrap();

//         assert_eq!(auth_path_with_nodes([5, 3]), auth_path_for_leaf(0));
//         assert_eq!(auth_path_with_nodes([4, 3]), auth_path_for_leaf(1));
//         assert_eq!(auth_path_with_nodes([7, 2]), auth_path_for_leaf(2));
//         assert_eq!(auth_path_with_nodes([6, 2]), auth_path_for_leaf(3));
//     }

//     #[test]
//     fn authentication_paths_of_very_small_tree_use_expected_digests() {
//         //         ──── 1 ────
//         //        ╱           ╲
//         //       2             3
//         //      ╱  ╲          ╱  ╲
//         //     ╱    ╲        ╱    ╲
//         //    4      5      6      7
//         //   ╱ ╲    ╱ ╲    ╱ ╲    ╱ ╲
//         //  8   9  10 11  12 13  14 15
//         //
//         //  0   1  2   3  4   5  6   7  <- leaf indices

//         let tree = MerkleTree::test_tree_of_height(3);
//         let auth_path_with_nodes = |indices: [usize; 3]| indices.map(|i| tree.nodes[i]).to_vec();
//         let auth_path_for_leaf = |index| tree.authentication_structure(&[index]).unwrap();

//         assert_eq!(auth_path_with_nodes([9, 5, 3]), auth_path_for_leaf(0));
//         assert_eq!(auth_path_with_nodes([8, 5, 3]), auth_path_for_leaf(1));
//         assert_eq!(auth_path_with_nodes([11, 4, 3]), auth_path_for_leaf(2));
//         assert_eq!(auth_path_with_nodes([10, 4, 3]), auth_path_for_leaf(3));
//         assert_eq!(auth_path_with_nodes([13, 7, 2]), auth_path_for_leaf(4));
//         assert_eq!(auth_path_with_nodes([12, 7, 2]), auth_path_for_leaf(5));
//         assert_eq!(auth_path_with_nodes([15, 6, 2]), auth_path_for_leaf(6));
//         assert_eq!(auth_path_with_nodes([14, 6, 2]), auth_path_for_leaf(7));
//     }

//     #[proptest(cases = 10)]
//     fn each_leaf_can_be_verified_individually(test_tree: MerkleTreeToTest) {
//         let tree = test_tree.tree;
//         for (leaf_index, &leaf) in tree.leafs().iter().enumerate() {
//             let authentication_path = tree.authentication_structure(&[leaf_index]).unwrap();
//             let proof = MerkleTreeInclusionProof {
//                 tree_height: tree.height(),
//                 indexed_leafs: [(leaf_index, leaf)].into(),
//                 authentication_structure: authentication_path,
//             };
//             let verdict = proof.verify(tree.root());
//             prop_assert!(verdict);
//         }
//     }

//     #[test]
//     fn partial_merkle_tree_built_from_authentication_structure_contains_expected_nodes() {
//         let merkle_tree = MerkleTree::test_tree_of_height(3);
//         let proof = merkle_tree
//             .inclusion_proof_for_leaf_indices(&[0, 2])
//             .unwrap();
//         let partial_tree = PartialMerkleTree::try_from(proof).unwrap();

//         //         ──── 1 ────
//         //        ╱           ╲
//         //       2             3
//         //      ╱  ╲
//         //     ╱    ╲
//         //    4      5
//         //   ╱ ╲    ╱ ╲
//         //  8   9  10 11
//         //
//         //  0      2   <-- opened_leaf_indices

//         let expected_node_indices = vec![1, 2, 3, 4, 5, 8, 9, 10, 11];
//         let node_indices = partial_tree.nodes.keys().copied().sorted().collect_vec();
//         assert_eq!(expected_node_indices, node_indices);
//     }

//     #[test]
//     fn manually_constructed_partial_tree_can_be_filled() {
//         //         ──── _ ───
//         //        ╱           ╲
//         //       _             3
//         //      ╱  ╲
//         //     ╱    ╲
//         //    _      _
//         //   ╱ ╲    ╱ ╲
//         //  8   9  10 11
//         //
//         //  0      2   <-- opened_leaf_indices

//         let node_indices = [3, 8, 9, 10, 11];
//         let mut partial_tree = PartialMerkleTree {
//             tree_height: 3,
//             leaf_indices: vec![0, 2],
//             nodes: PartialMerkleTree::dummy_nodes_for_indices(&node_indices),
//         };
//         partial_tree.fill().unwrap();
//     }

//     #[test]
//     fn trying_to_compute_root_of_partial_tree_with_necessary_node_missing_gives_expected_error() {
//         //         ──── _ ────
//         //        ╱           ╲
//         //       _             _ (!)
//         //      ╱  ╲
//         //     ╱    ╲
//         //    _      _
//         //   ╱ ╲    ╱ ╲
//         //  8   9  10 11
//         //
//         //  0      2   <-- opened_leaf_indices

//         let node_indices = [8, 9, 10, 11];
//         let mut partial_tree = PartialMerkleTree {
//             tree_height: 3,
//             leaf_indices: vec![0, 2],
//             nodes: PartialMerkleTree::dummy_nodes_for_indices(&node_indices),
//         };

//         let err = partial_tree.fill().unwrap_err();
//         assert_eq!(MerkleTreeError::MissingNodeIndex(3), err);
//     }

//     #[test]
//     fn trying_to_compute_root_of_partial_tree_with_redundant_node_gives_expected_error() {
//         //         ──── _ ────
//         //        ╱           ╲
//         //       2 (!)         3
//         //      ╱  ╲
//         //     ╱    ╲
//         //    _      _
//         //   ╱ ╲    ╱ ╲
//         //  8   9  10 11
//         //
//         //  0      2   <-- opened_leaf_indices

//         let node_indices = [2, 3, 8, 9, 10, 11];
//         let mut partial_tree = PartialMerkleTree {
//             tree_height: 3,
//             leaf_indices: vec![0, 2],
//             nodes: PartialMerkleTree::dummy_nodes_for_indices(&node_indices),
//         };

//         let err = partial_tree.fill().unwrap_err();
//         assert_eq!(MerkleTreeError::SpuriousNodeIndex(2), err);
//     }

//     #[test]
//     fn converting_authentication_structure_to_authentication_paths_results_in_expected_paths() {
//         const TREE_HEIGHT: usize = 3;
//         let merkle_tree = MerkleTree::test_tree_of_height(TREE_HEIGHT);
//         let proof = merkle_tree
//             .inclusion_proof_for_leaf_indices(&[0, 2])
//             .unwrap();
//         let auth_paths = proof.into_authentication_paths().unwrap();

//         let auth_path_with_nodes =
//             |indices: [usize; TREE_HEIGHT]| indices.map(|i| merkle_tree.nodes[i]).to_vec();
//         let expected_path_0 = auth_path_with_nodes([9, 5, 3]);
//         let expected_path_1 = auth_path_with_nodes([11, 4, 3]);
//         let expected_paths = vec![expected_path_0, expected_path_1];

//         assert_eq!(expected_paths, auth_paths);
//     }
// }
