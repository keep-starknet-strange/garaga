// use arbitrary::Arbitrary;

use super::mmr_accumulator::MmrAccumulator;
use super::mmr_trait::Mmr;
use super::shared_basic::leaf_index_to_mt_index_and_peak_index;
// use crate::error::USIZE_TO_U64_ERR;
// use crate::prelude::*;
use super::super::digest::{Digest, HashFunction};
use crate::crypto::merkle_tree::MerkleTree;

/// Asserts that one [MMR Accumulator] is the descendant of another, *i.e.*,
/// that the second can be obtained by appending a set of leafs to the first. It
/// consists of an authentication path connecting the relevant old peaks to the
/// new peaks.
///
/// [MMR Accumulator]: MmrAccumulator
#[derive(Debug, Clone)]
pub struct MmrSuccessorProof<H: HashFunction> {
    pub paths: Vec<Digest<H>>,
}

impl<H: HashFunction> MmrSuccessorProof<H> {
    /// Compute a new `MmrSuccessorProof` given the starting MMR accumulator (MMRA)
    /// and a list of digests to be appended.
    ///
    /// # Panics
    ///
    /// This function will panic if the number of leafs in the MMRA is greater than
    /// or equal to 2^63.
    ///
    /// This function may panic if the passed-in MMRA is inconsistent, that is, has
    /// fewer peaks than is possible for its claimed number of leafs.
    //
    // For an introduction to the inner workings of this function, see
    // [`Self::verify_internal`].
    pub fn new_from_batch_append(mmra: &MmrAccumulator<H>, new_leafs: &[Digest<H>]) -> Self {
        if mmra.num_leafs() == 0 {
            // any MMR is a successor to the empty MMR – nothing to check, nothing to prove
            return Self { paths: vec![] };
        }

        let height_of_lowest_peak = mmra.num_leafs().trailing_zeros();
        let num_leafs_in_lowest_peak = 1 << height_of_lowest_peak;
        if new_leafs.len() < num_leafs_in_lowest_peak {
            // the new leafs do not affect the old peaks
            return Self { paths: vec![] };
        }

        let leafs_in_initial_right_tree = &new_leafs[..num_leafs_in_lowest_peak];
        let initial_right_tree = MerkleTree::par_new(leafs_in_initial_right_tree)
            .expect("internal error: should be able to build Merkle tree");

        let num_total_leafs =
            mmra.num_leafs() + u64::try_from(new_leafs.len()).expect("USIZE_TO_U64_ERR");
        let first_new_leaf_index = mmra.num_leafs();
        let (mut merkle_tree_index, _) =
            leaf_index_to_mt_index_and_peak_index(first_new_leaf_index, num_total_leafs);
        let height_of_new_peak = merkle_tree_index.ilog2();
        merkle_tree_index >>= height_of_lowest_peak;

        let mut current_node = initial_right_tree.root();
        let mut paths = vec![current_node];
        let mut old_peaks = mmra.peaks().into_iter();
        let mut first_unused_new_leaf_idx = num_leafs_in_lowest_peak;

        let merkle_tree_root_index =
            u64::try_from(MerkleTree::<H>::ROOT_INDEX).expect("USIZE_TO_U64_ERR");

        while merkle_tree_index > merkle_tree_root_index {
            let current_node_is_left_sibling = merkle_tree_index % 2 == 0;
            current_node = if current_node_is_left_sibling {
                let current_height = height_of_new_peak - merkle_tree_index.ilog2();
                let num_leafs_in_right_tree = 1 << current_height;
                let indices_of_leafs_in_right_tree =
                    first_unused_new_leaf_idx..first_unused_new_leaf_idx + num_leafs_in_right_tree;
                let leafs_in_right_tree = &new_leafs[indices_of_leafs_in_right_tree];
                let right_tree = MerkleTree::par_new(leafs_in_right_tree)
                    .expect("internal error: should be able to build Merkle tree");
                first_unused_new_leaf_idx += num_leafs_in_right_tree;

                paths.push(right_tree.root());
                Digest::<H>::from_element(H::hash_pair(
                    &current_node.to_element(),
                    &right_tree.root().to_element(),
                ))
            } else {
                let left_sibling = old_peaks
                    .next_back()
                    .expect("Merkle Mountain Range Accumulator should be consistent");
                Digest::<H>::from_element(H::hash_pair(
                    &left_sibling.to_element(),
                    &current_node.to_element(),
                ))
            };
            merkle_tree_index /= 2;
        }
        debug_assert_eq!(merkle_tree_root_index, merkle_tree_index);

        Self { paths }
    }

    /// Verify that the `old` [`MmrAccumulator`] is a predecessor of the `new` one.
    pub fn verify(&self, old: &MmrAccumulator<H>, new: &MmrAccumulator<H>) -> bool {
        self.verify_internal(old, new).is_ok()
    }

    /// Like [`Self::verify`], but with failure reasons instead of a `bool` to
    /// increase testability.
    //
    // An explanation of the algorithm follows. As an example, take the following
    // Merkle Mountain Range with 42 = 101010₂ leafs. Peaks are marked with `·`s.
    //
    //                                ·
    //                ╭───────────────┴───────────────╮
    //        ╭───────┴───────╮               ╭───────┴───────╮               ·
    //    ╭───┴───╮       ╭───┴───╮       ╭───┴───╮       ╭───┴───╮       ╭───┴───╮
    //  ╭─┴─╮   ╭─┴─╮   ╭─┴─╮   ╭─┴─╮   ╭─┴─╮   ╭─┴─╮   ╭─┴─╮   ╭─┴─╮   ╭─┴─╮   ╭─┴─╮   ·
    // ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮
    //
    // Adding 8 leafs to it results in the following new Merkle Mountain Range with
    // 50 = 110010₂ leafs. The addition is drawn boxy and bold. The elements of the
    // required authentication path are marked with `x`es. The new peaks are marked
    // with `○`. The one peak that's both old and new is marked `⊙`.
    //
    //             ⊙
    //   ╭─────────┴─────────╮                               ○
    // ┄┄┴┄┄         ╭───────┴───────╮               ·━━━━━━━┻━━━━━━━┓
    //           ╭───┴───╮       ╭───┴───╮       ╭───┴───╮       ┏━━━┻━━━x
    //         ╭─┴─╮   ╭─┴─╮   ╭─┴─╮   ╭─┴─╮   ╭─┴─╮   ╭─┴─╮   ·━┻━x   ┏━┻━┓   ○
    //        ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ┏┻┓ ┏┻┓ ┏┻┓ ┏┻┓
    //
    // The new MMR Accumulator (the one with 50 leafs) is a successor to the old
    // MMR Accumulator (the one with 42 leafs) if all of the following are true:
    // - Both MMR Accumulators are self-consistent.
    // - The new MMR Accumulator has more or equal the number of leafs as the old
    //   one.
    // - All “shared peaks” are identical. In the example, only the highest peak is
    //   shared.
    // - The first unshared peak in the new MMR Accumulator is a Merkle tree that
    //   contains all remaining old peaks. In the example, the second new peak
    //   contains the second and third old peaks.
    //
    // All subsequent new peaks are irrelevant for verification. In the example,
    // this is only the smallest peak of the new MMR Accumulator.
    //
    // To re-compute the first unshared peak in the new MMR Accumulator,
    // - start the Merkle tree authentication from the correct height, that is, from
    //   the height of the smallest old peak;
    // - for any left sibling, use an old peak; and
    // - for any right sibling, use an element of the authentication path.
    fn verify_internal(
        &self,
        old: &MmrAccumulator<H>,
        new: &MmrAccumulator<H>,
    ) -> Result<(), Error> {
        if !old.is_consistent() {
            return Err(Error::InconsistentOldMmr);
        }

        if !new.is_consistent() {
            return Err(Error::InconsistentNewMmr);
        }

        let verify_auth_path_is_empty = || {
            if self.paths.is_empty() {
                Ok(())
            } else {
                Err(Error::AuthenticationPathTooLong)
            }
        };

        match old.num_leafs() {
            0 => return verify_auth_path_is_empty(), // any MMR is a successor to the empty MMR
            n if n < new.num_leafs() => (),          // nominal case, continued below
            n if n == new.num_leafs() => {
                // treated separately to simplify logic in nominal case
                return if old.peaks() == new.peaks() {
                    verify_auth_path_is_empty()
                } else {
                    Err(Error::DifferentSharedPeak)
                };
            }
            _ => return Err(Error::OldHasMoreLeafsThanNew),
        };

        let index_of_first_unverified_leaf = old.num_leafs();
        let (merkle_tree_index, num_unchanged_peaks) =
            leaf_index_to_mt_index_and_peak_index(index_of_first_unverified_leaf, new.num_leafs());

        let mut old_peaks = old.peaks().into_iter();
        let mut new_peaks = new.peaks().into_iter();
        for _ in 0..num_unchanged_peaks {
            let old_peak = old_peaks.next().ok_or(Error::MissingOldPeak)?;
            let new_peak = new_peaks.next().ok_or(Error::MissingNewPeak)?;
            if old_peak != new_peak {
                return Err(Error::DifferentSharedPeak);
            }
        }

        let height_of_lowest_old_peak = old.num_leafs().trailing_zeros();
        let num_leafs_in_lowest_old_peak = 1 << height_of_lowest_old_peak;
        let num_new_leafs = new.num_leafs() - old.num_leafs();
        if num_new_leafs < num_leafs_in_lowest_old_peak {
            // the new leafs don't affect the old peaks
            return verify_auth_path_is_empty();
        }

        let mut auth_path = self.paths.iter();
        let mut current_node = *auth_path.next().ok_or(Error::AuthenticationPathTooShort)?;
        let mut merkle_tree_index = merkle_tree_index >> height_of_lowest_old_peak;

        let merkle_tree_root_index =
            u64::try_from(MerkleTree::<H>::ROOT_INDEX).expect("USIZE_TO_U64_ERR");
        while merkle_tree_index > merkle_tree_root_index {
            let current_node_is_left_sibling = merkle_tree_index % 2 == 0;
            current_node = if current_node_is_left_sibling {
                let &right_sibling = auth_path.next().ok_or(Error::AuthenticationPathTooShort)?;
                Digest::<H>::from_element(H::hash_pair(
                    &current_node.to_element(),
                    &right_sibling.to_element(),
                ))
            } else {
                let left_sibling = old_peaks.next_back().ok_or(Error::MissingOldPeak)?;
                Digest::<H>::from_element(H::hash_pair(
                    &left_sibling.to_element(),
                    &current_node.to_element(),
                ))
            };
            merkle_tree_index /= 2;
        }

        debug_assert_eq!(0, old_peaks.len());
        if auth_path.len() > 0 {
            return Err(Error::AuthenticationPathTooLong);
        }

        let first_unshared_peak = new_peaks.next().ok_or(Error::MissingNewPeak)?;
        if current_node != first_unshared_peak {
            return Err(Error::DifferentUnsharedPeak);
        }

        Ok(())
    }
}

#[derive(Debug, Copy, Clone, Eq, PartialEq, Hash, thiserror::Error)] // , Arbitrary)]
enum Error {
    #[error("the new MMRA must not take away any leafs")]
    OldHasMoreLeafsThanNew,

    #[error("the old MMRA must be self-consistent")]
    InconsistentOldMmr,

    #[error("the new MMRA must be self-consistent")]
    InconsistentNewMmr,

    #[error("the old MMRA has too few peaks – is it consistent?")]
    MissingOldPeak,

    #[error("the new MMRA has too few peaks – is it consistent?")]
    MissingNewPeak,

    #[error("the authentication path contains too few elements")]
    AuthenticationPathTooShort,

    #[error("the authentication path contains spurious elements")]
    AuthenticationPathTooLong,

    #[error("a peak that should be shared between old and new MMRA is unequal")]
    DifferentSharedPeak,

    #[error("the first peak that's unshared between old and new MMRA is not as claimed")]
    DifferentUnsharedPeak,
}

// #[cfg(test)]
// mod test {
//     use std::ops::Range;

//     use itertools::Itertools;
//     use proptest::prelude::*;
//     use proptest_arbitrary_interop::arb;
//     use test_strategy::proptest;

//     use super::*;
//     use crate::math::digest::digest_tests::DigestCorruptor;

//     /// A type exclusive to testing. Simplifies construction and verification of
//     /// [`MmrSuccessorProof`]s.
//     #[derive(Debug, Clone)]
//     struct MmrSuccessorRelation {
//         old: MmrAccumulator,
//         new: MmrAccumulator,
//         proof: MmrSuccessorProof,
//     }

//     impl MmrSuccessorRelation {
//         fn new(old_leafs: Vec<Digest>, new_leafs: Vec<Digest>) -> Self {
//             let old = MmrAccumulator::new_from_leafs(old_leafs.clone());
//             let proof = MmrSuccessorProof::new_from_batch_append(&old, &new_leafs);
//             let new = MmrAccumulator::new_from_leafs([old_leafs, new_leafs].concat());

//             Self { old, new, proof }
//         }

//         fn new_with_numbered_leafs(num_old_leafs: u64, num_new_leafs: u64) -> Self {
//             let numbered_leafs = |r: Range<_>| r.map(|leaf| Tip5::hash(&leaf)).collect();

//             let old_leafs = numbered_leafs(0..num_old_leafs);
//             let new_leafs = numbered_leafs(num_old_leafs..num_old_leafs + num_new_leafs);

//             Self::new(old_leafs, new_leafs)
//         }

//         fn verify(&self) -> Result<(), Error> {
//             self.proof.verify_internal(&self.old, &self.new)
//         }
//     }

//     impl<'a> arbitrary::Arbitrary<'a> for MmrSuccessorRelation {
//         fn arbitrary(u: &mut arbitrary::Unstructured<'a>) -> arbitrary::Result<Self> {
//             let mut leafs = |upper_bound| -> Result<Vec<_>, _> {
//                 let num_leafs = u.int_in_range(0..=upper_bound)?;
//                 (0..num_leafs).map(|_| u.arbitrary()).collect()
//             };

//             Ok(Self::new(leafs(1 << 8)?, leafs(1 << 8)?))
//         }
//     }

//     impl proptest::arbitrary::Arbitrary for MmrSuccessorRelation {
//         type Parameters = ();

//         fn arbitrary_with(_: Self::Parameters) -> Self::Strategy {
//             arb().boxed()
//         }

//         type Strategy = BoxedStrategy<Self>;
//     }

//     #[test]
//     fn append_nothing_to_empty_mmra() {
//         let relation = MmrSuccessorRelation::new_with_numbered_leafs(0, 0);
//         assert_eq!(0, relation.proof.paths.len());
//         relation.verify().unwrap();
//     }

//     #[test]
//     fn append_one_thing_to_empty_mmra() {
//         let relation = MmrSuccessorRelation::new_with_numbered_leafs(0, 1);
//         assert_eq!(0, relation.proof.paths.len());
//         relation.verify().unwrap();
//     }

//     #[test]
//     fn append_leafs_without_influence_on_existing_peaks() {
//         let relation = MmrSuccessorRelation::new_with_numbered_leafs(1 << 3, 3);
//         assert_eq!(0, relation.proof.paths.len());
//         relation.verify().unwrap();
//     }

//     /// 42 = 101010₂ gives nice gaps between peaks, the additional 8 leafs fill some
//     /// of them nicely and adds a non-trivial new peak that's irrelevant for
//     /// verification.
//     ///
//     /// See the figure below, where the old Merkle Mountain Range is drawn rounded
//     /// and thin, the addition boxy and bold. The elements of the authentication
//     /// path are marked with `x`es, the “old peaks” required for authentication are
//     /// marked with `·`s.
//     ///
//     /// ```markdown
//     ///   ╭─────────┴─────────╮
//     /// ┄┄┴┄┄         ╭───────┴───────╮               ·━━━━━━━┻━━━━━━━┓
//     ///           ╭───┴───╮       ╭───┴───╮       ╭───┴───╮       ┏━━━┻━━━x
//     ///         ╭─┴─╮   ╭─┴─╮   ╭─┴─╮   ╭─┴─╮   ╭─┴─╮   ╭─┴─╮   ·━┻━x   ┏━┻━┓
//     ///        ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ╭┴╮ ┏┻┓ ┏┻┓ ┏┻┓ ┏┻┓
//     /// ```
//     #[test]
//     fn append_8_leafs_to_mmra_with_42_leafs() {
//         let relation = MmrSuccessorRelation::new_with_numbered_leafs(42, 8);
//         assert_eq!(2, relation.proof.paths.len());

//         let first_merkle_tree_leafs = [42_u64, 43].map(|i| Tip5::hash(&i));
//         let first_merkle_tree = MerkleTree::par_new(&first_merkle_tree_leafs).unwrap();
//         assert_eq!(first_merkle_tree.root(), relation.proof.paths[0]);

//         let second_merkle_tree_leafs = [44_u64, 45, 46, 47].map(|i| Tip5::hash(&i));
//         let second_merkle_tree = MerkleTree::par_new(&second_merkle_tree_leafs).unwrap();
//         assert_eq!(second_merkle_tree.root(), relation.proof.paths[1]);

//         relation.verify().unwrap();
//     }

//     #[test]
//     fn unit_tests() {
//         for (n, m) in (0..18).cartesian_product(0..18) {
//             dbg!((n, m));
//             let relation = MmrSuccessorRelation::new_with_numbered_leafs(n, m);
//             relation.verify().unwrap();
//         }
//     }

//     #[proptest]
//     fn arbitrary_mmr_successor_relation_holds(relation: MmrSuccessorRelation) {
//         relation.verify()?;
//     }

//     #[proptest]
//     fn verification_fails_if_old_mmr_is_inconsistent(
//         mut relation: MmrSuccessorRelation,
//         wrong_num_leafs: u64,
//     ) {
//         prop_assume!(wrong_num_leafs != relation.old.num_leafs());
//         relation.old = MmrAccumulator::init(relation.old.peaks(), wrong_num_leafs);
//         prop_assert_eq!(Err(Error::InconsistentOldMmr), relation.verify());
//     }

//     #[proptest]
//     fn verification_fails_if_new_mmr_is_inconsistent(
//         mut relation: MmrSuccessorRelation,
//         wrong_num_leafs: u64,
//     ) {
//         prop_assume!(wrong_num_leafs != relation.new.num_leafs());
//         relation.new = MmrAccumulator::init(relation.new.peaks(), wrong_num_leafs);
//         prop_assert_eq!(Err(Error::InconsistentNewMmr), relation.verify());
//     }

//     #[proptest]
//     fn verification_fails_if_old_mmra_has_more_leafs_than_new_mmra(
//         #[filter(#relation.old != #relation.new)] mut relation: MmrSuccessorRelation,
//     ) {
//         std::mem::swap(&mut relation.old, &mut relation.new);
//         prop_assert_eq!(Err(Error::OldHasMoreLeafsThanNew), relation.verify());
//     }

//     #[proptest]
//     fn verification_fails_if_old_mmra_has_swapped_peaks(
//         #[filter(#relation.old.peaks().len() >= 2)] mut relation: MmrSuccessorRelation,
//         #[strategy(0..#relation.old.peaks().len())] first_swap_idx: usize,
//         #[strategy(0..#relation.old.peaks().len())] second_swap_idx: usize,
//     ) {
//         prop_assume!(first_swap_idx != second_swap_idx);
//         let mut wrong_peaks = relation.old.peaks();
//         wrong_peaks.swap(first_swap_idx, second_swap_idx);
//         relation.old = MmrAccumulator::init(wrong_peaks, relation.old.num_leafs());

//         prop_assert!(matches!(
//             relation.verify(),
//             Err(Error::DifferentSharedPeak) | Err(Error::DifferentUnsharedPeak)
//         ));
//     }

//     /// Because some peaks of the new MMRA might be irrelevant for the successor
//     /// relation, it is impossible to swap arbitrary peaks and guarantee a
//     /// verification failure. However, if the old MMRA is non-empty, the first
//     /// peak of the new MMRA is always relevant.
//     #[proptest]
//     fn verification_fails_if_new_mmra_has_first_peak_swapped_out(
//         #[filter(#relation.old.num_leafs() > 0)]
//         #[filter(#relation.new.peaks().len() >= 2)]
//         mut relation: MmrSuccessorRelation,
//         #[strategy(1..#relation.new.peaks().len())] swap_idx: usize,
//     ) {
//         let mut wrong_peaks = relation.new.peaks();
//         wrong_peaks.swap(0, swap_idx);
//         relation.new = MmrAccumulator::init(wrong_peaks, relation.new.num_leafs());

//         prop_assert!(matches!(
//             relation.verify(),
//             Err(Error::DifferentSharedPeak) | Err(Error::DifferentUnsharedPeak)
//         ));
//     }

//     #[proptest(cases = 50)]
//     fn verification_fails_if_authentication_path_is_corrupt(
//         #[filter(!#relation.proof.paths.is_empty())] mut relation: MmrSuccessorRelation,
//         #[strategy(0..#relation.proof.paths.len())] corruption_idx: usize,
//         corruptor: DigestCorruptor,
//     ) {
//         let auth_path = &mut relation.proof.paths;
//         auth_path[corruption_idx] = corruptor.corrupt_digest(auth_path[corruption_idx])?;

//         prop_assert!(matches!(
//             relation.verify(),
//             Err(Error::DifferentSharedPeak) | Err(Error::DifferentUnsharedPeak)
//         ));
//     }

//     #[proptest]
//     fn verification_fails_if_authentication_path_has_too_few_elements(
//         #[filter(!#relation.proof.paths.is_empty())] mut relation: MmrSuccessorRelation,
//         #[strategy(0..#relation.proof.paths.len())] deletion_idx: usize,
//     ) {
//         relation.proof.paths.remove(deletion_idx);
//         prop_assert_eq!(Err(Error::AuthenticationPathTooShort), relation.verify());
//     }

//     #[proptest]
//     fn verification_fails_if_authentication_path_has_too_many_elements(
//         mut relation: MmrSuccessorRelation,
//         #[strategy(arb())] spurious_element: Digest,
//     ) {
//         relation.proof.paths.push(spurious_element);
//         prop_assert_eq!(Err(Error::AuthenticationPathTooLong), relation.verify());
//     }
// }
