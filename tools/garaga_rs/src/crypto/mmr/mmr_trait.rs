use super::mmr_accumulator::MmrAccumulator;
use super::mmr_membership_proof::MmrMembershipProof;
use crate::crypto::digest::{Digest, HashFunction};

/// A wrapper for the data needed to change the value of a leaf in an MMR when
/// only the MMR-accumulator is known, i.e., only the peaks and the leaf-count
/// are known.
#[derive(Debug, Clone)]
pub struct LeafMutation<H: HashFunction> {
    /// The leaf-index of the leaf being mutated. If the MMR is viewed as a
    /// commitment to a list, then this is simply the (0-indexed) list-index
    /// into that list.
    pub leaf_index: u64,

    /// The new leaf value, after the mutation has been applied.
    pub new_leaf: Digest<H>,

    /// MMR membership proof (authentication path) both before *and* after the
    /// leaf has been mutated. An authentication path is a commitment to all
    /// other leafs in the Merkle tree than the one it is a membership proof
    /// for.
    pub membership_proof: MmrMembershipProof<H>,
}

impl<H: HashFunction> LeafMutation<H> {
    pub fn new(
        leaf_index: u64,
        new_leaf: Digest<H>,
        membership_proof: MmrMembershipProof<H>,
    ) -> Self {
        Self {
            leaf_index,
            new_leaf,
            membership_proof,
        }
    }

    /// Returns the node indices into the MMR of the nodes that are mutated by
    /// this leaf-mutation.
    pub fn affected_node_indices(&self) -> Vec<u64> {
        self.membership_proof
            .get_direct_path_indices(self.leaf_index)
    }
}

/// A “Merkle Mountain Range” (MMR) is a data structure for storing lists of
/// hashes. Similar to [Merkle trees](crate::prelude::MerkleTree), they enable
/// efficient set inclusion proofs. Unlike Merkle trees, the number of leafs of
/// an MMR is not required to be a power of 2.
///
/// One valid perspective of this data structure is to see it as a list of
/// Merkle trees. Each of the Merkle tree's roots is one peak of the MMR.
/// In order to keep the number of peaks to a minimum, any two Merkle trees of
/// the same height are merged, which results in a single tree that has one
/// additional “tier”, _i.e._, it's height is one more than that of the two
/// trees that got merged.
///
/// # Example
///
/// The following is a Merkle Mountain Range, annotated with both node and leaf
/// indices:
///
/// ```markdown
///         ──── 15 ───                           ╮
///        ╱           ╲                          │
///       7             14            22          │
///      ╱  ╲          ╱  ╲          ╱  ╲         ├╴ node indices
///     ╱    ╲        ╱    ╲        ╱    ╲        │
///    3      6     10      13     18     21      │
///   ╱ ╲    ╱ ╲    ╱ ╲    ╱ ╲    ╱ ╲    ╱ ╲      │
///  1   2  4   5  8   9  11 12  16 17  19 20 21  ╯
///
///  0   1  2   3  4   5  6   7  8   9  10 11 12  ←── leaf indices
/// ```
///
/// Adding another leaf to the above MMR will result in the following MMR:
///
/// ```markdown
///         ──── 15 ───
///        ╱           ╲
///       7             14            22
///      ╱  ╲          ╱  ╲          ╱  ╲
///     ╱    ╲        ╱    ╲        ╱    ╲
///    3      6     10      13     18     21       25
///   ╱ ╲    ╱ ╲    ╱ ╲    ╱ ╲    ╱ ╲    ╱ ╲      ╱ ╲
///  1   2  4   5  8   9  11 12  16 17  19 20 21 23 24
///
///  0   1  2   3  4   5  6   7  8   9  10 11 12 13 14
/// ```
///
/// Note how the new leaf with index 13, which by itself is a Merkle tree of
/// height 0, was merged with its neighboring Merkle tree of equal height,
/// resulting in a new Merkle tree of height 1 (the nodes 23, 24, and 25).
///
/// Adding two more leafs to this MMR results in a single Merkle tree of height
/// four.
///
/// # Counterexample
///
/// The following is **not** a valid Merkle Mountain Range, since it contains
/// trees of equal height.
///
/// ```markdown
///       _                        _
///      ╱  ╲                     ╱  ╲
///     ╱    ╲                   ╱    ╲
///    _      _     _     _     _      _
///   ╱ ╲    ╱ ╲   ╱ ╲   ╱ ╲   ╱ ╲    ╱ ╲
///  _   _  _   _ _   _ _   _ _   _  _   _
/// ```
///
/// # Terminology
///
/// Similar to Merkle trees, Merkle Mountain Ranges have “leafs” and “nodes”.
/// Any leaf is a node, but the reverse is not true. Note that the indexing
/// scheme for the nodes does not follow that of a Merkle tree – see
/// [this][mt_proof] explanation for Merkle tree indexing.
///
/// A single Merkle tree's root is one “peak” of the MMR. The number of peaks in
/// the MMR equals the number of Merkle trees it is made out of. Because of the
/// 1-to-1 mapping between peaks and Merkle trees, the “peak index” uniquely
/// identifies any one Merkle tree.
///
/// When selecting for a single Merkle tree within a Merkle Mountain Range, the
/// usual Merkel tree indexing is used to identify nodes. This is called the
/// “Merkle tree index” and is usually only meaningful in combination with a
/// peak index, for example like [here][mt_peak_idx].
///
/// [mt_proof]: crate::util_types::merkle_tree::MerkleTree::authentication_structure
/// [mt_peak_idx]: crate::util_types::mmr::shared_basic::leaf_index_to_mt_index_and_peak_index
pub trait Mmr<H: HashFunction> {
    /// A single digest committing to the entire MMR.
    fn bag_peaks(&self) -> Digest<H>;

    /// The peaks of the MMR, _i.e._, the roots of the Merkle trees that constitute
    /// the MMR.
    fn peaks(&self) -> Vec<Digest<H>>;

    /// `true` iff the MMR has no leafs.
    fn is_empty(&self) -> bool;

    /// The number of leafs in the MMR.
    fn num_leafs(&self) -> u64;

    /// Append a hash digest to the MMR.
    fn append(&mut self, new_leaf: Digest<H>) -> MmrMembershipProof<H>;

    /// Mutate an existing leaf. It is the caller's responsibility that the
    /// membership proof is valid. If the membership proof is wrong, the MMR
    /// will end up in a broken state.
    fn mutate_leaf(&mut self, leaf_mutation: LeafMutation<H>);

    /// Batch mutate an MMR while updating a list of membership proofs. Returns the
    /// indices of the membership proofs that have changed as a result of this
    /// operation.
    fn batch_mutate_leaf_and_update_mps(
        &mut self,
        membership_proofs: &mut [&mut MmrMembershipProof<H>],
        membership_proof_leaf_indices: &[u64],
        mutation_data: Vec<LeafMutation<H>>,
    ) -> Vec<usize>;

    /// `true` iff a list of leaf mutations and a list of appends results in the expected
    /// `new_peaks`.
    fn verify_batch_update(
        &self,
        new_peaks: &[Digest<H>],
        appended_leafs: &[Digest<H>],
        leaf_mutations: Vec<LeafMutation<H>>,
    ) -> bool;

    /// Derive an MMR accumulator, which contains only peaks and the number of
    /// leafs.
    fn to_accumulator(&self) -> MmrAccumulator<H>;
}
