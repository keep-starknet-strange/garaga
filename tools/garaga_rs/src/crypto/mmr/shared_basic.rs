// use crate::prelude::*;

use crate::crypto::digest::{Digest, HashFunction};
use crate::crypto::merkle_tree::MerkleTree;
use crate::crypto::mmr::mmr_membership_proof::MmrMembershipProof;

pub(crate) const USIZE_TO_U64_ERR: &str =
    "internal error: type `usize` should have at most 64 bits";
pub(crate) const U32_TO_USIZE_ERR: &str =
    "internal error: type `usize` should have at least 32 bits";

#[inline]
pub fn left_child(node_index: u64, height: u32) -> u64 {
    node_index - (1 << height)
}

#[inline]
pub fn right_child(node_index: u64) -> u64 {
    node_index - 1
}

/// Given the leaf index in the MMR as well as the number of leafs in the MMR,
/// compute that leaf's Merkle tree index and its peak index.
///
/// For an explanation of the terminology, see [`Mmr`].
///
/// # Panics
///
/// - if the leaf index is larger than or equal to the number of leafs
#[inline]
pub fn leaf_index_to_mt_index_and_peak_index(leaf_index: u64, num_leafs: u64) -> (u64, u32) {
    // This algorithm works by first identifying how high the local Merkle tree is. This is
    // the Merkle tree that the leaf with `leaf_index` is part of. Then it finds the peak
    // index which identifies which of the N Merkle trees the leaf is part of.
    //
    // The height of local tree is the lowest index (from least significant) of the bits where
    // there is a discrepancy between `leaf_index` and `num_leafs`. The discrepant bits can
    // be identified with a xor.
    //
    // The bit-decomposition of `num_leafs` shows the height of the involved Merkle trees.
    // The number of ones in this bit-decomposition is the number of Merkle trees in the MMR;
    // the index of each one (counting from least-significant bit) is the height of that
    // Merkle tree. So counting the ones before and after the discrepancy bit reveals which
    // Merkle tree the leaf is in. This value is called "peak index" since we have a list
    // of digests that are the peaks of the MMR, and the peak index shows which element of
    // that list is the Merkle root that its authentication path refers to.
    assert!(
        leaf_index < num_leafs,
        "Leaf index must be strictly smaller than the number of leafs"
    );

    // get node index, as if this was a Merkle tree
    let discrepancies = leaf_index ^ num_leafs;
    let local_mt_height = discrepancies.ilog2();
    let local_mt_num_leafs = 1 << local_mt_height;
    let remainder_bitmask = local_mt_num_leafs - 1;
    let local_leaf_index = remainder_bitmask & leaf_index;
    let mt_node_index = local_leaf_index + local_mt_num_leafs;

    // peak index
    let num_peaks = num_leafs.count_ones();
    let num_peaks_smaller_or_equal_own_peak = (num_leafs & remainder_bitmask).count_ones();

    // subtract one to go from cardinal to ordinal
    let peak_index = num_peaks - num_peaks_smaller_or_equal_own_peak - 1;

    (mt_node_index, peak_index)
}

#[inline]
/// The number of parents that need to be added when a new leaf is inserted.
pub fn right_lineage_length_from_leaf_index(leaf_index: u64) -> u32 {
    leaf_index.trailing_ones()
}

/// Return the new peaks of the MMR after adding `new_leaf` as well as the membership
/// proof for the added leaf.
///
/// # Panics
///
/// - if the `old_peaks` and the `old_num_leafs` are inconsistent
pub fn calculate_new_peaks_from_append<H: HashFunction>(
    old_num_leafs: u64,
    old_peaks: Vec<Digest<H>>,
    new_leaf: Digest<H>,
) -> (Vec<Digest<H>>, MmrMembershipProof<H>) {
    assert_eq!(
        old_peaks.len(),
        usize::try_from(old_num_leafs.count_ones()).expect(U32_TO_USIZE_ERR)
    );

    let mut peaks = old_peaks;
    peaks.push(new_leaf);
    let mut authentication_path = vec![];
    for _ in 0..right_lineage_length_from_leaf_index(old_num_leafs) {
        let in_progress_peak = peaks.pop().unwrap();
        let previous_peak = peaks.pop().unwrap();
        authentication_path.push(previous_peak);
        peaks.push(Digest::<H>::from_element(H::hash_pair(
            &previous_peak.data,
            &in_progress_peak.data,
        )));
    }

    (peaks, MmrMembershipProof::new(authentication_path))
}

/// Calculate a new peak list given the mutation of a leaf
/// The new peak list will only (max) have *one* element different
/// from `old_peaks`
///
/// # Panics
///
/// Panics if the `membership_proof`'s authentication path is of insufficient
/// length. This can only happen if the `membership_proof` is invalid (but
/// there are other ways in which it can be invalid, too).
pub fn calculate_new_peaks_from_leaf_mutation<H: HashFunction>(
    old_peaks: &[Digest<H>],
    num_leafs: u64,
    new_leaf: Digest<H>,
    leaf_index: u64,
    membership_proof: &MmrMembershipProof<H>,
) -> Vec<Digest<H>> {
    let merkle_tree_root_index =
        u64::try_from(MerkleTree::<H>::ROOT_INDEX).expect(USIZE_TO_U64_ERR);

    let (mut acc_mt_index, peak_index) =
        leaf_index_to_mt_index_and_peak_index(leaf_index, num_leafs);

    let mut acc_hash = new_leaf;
    let mut authentication_path = membership_proof.authentication_path.iter();
    while acc_mt_index > merkle_tree_root_index {
        let &ap_element = authentication_path.next().unwrap();
        let accumulator_is_left_child = acc_mt_index % 2 == 0;
        if accumulator_is_left_child {
            acc_hash = Digest::<H>::from_element(H::hash_pair(&acc_hash.data, &ap_element.data));
        } else {
            acc_hash = Digest::<H>::from_element(H::hash_pair(&ap_element.data, &acc_hash.data));
        }

        acc_mt_index /= 2;
    }
    debug_assert_eq!(merkle_tree_root_index, acc_mt_index);

    let mut calculated_peaks: Vec<Digest<H>> = old_peaks.to_vec();
    calculated_peaks[peak_index as usize] = acc_hash;

    calculated_peaks
}

// #[cfg(test)]
// mod mmr_test {
//     use proptest::collection::vec;
//     use proptest_arbitrary_interop::arb;
//     use test_strategy::proptest;

//     use super::*;

//     #[test]
//     fn right_lineage_length_from_leaf_index_test() {
//         assert_eq!(0, right_lineage_length_from_leaf_index(0));
//         assert_eq!(1, right_lineage_length_from_leaf_index(1));
//         assert_eq!(0, right_lineage_length_from_leaf_index(2));
//         assert_eq!(2, right_lineage_length_from_leaf_index(3));
//         assert_eq!(0, right_lineage_length_from_leaf_index(4));
//         assert_eq!(1, right_lineage_length_from_leaf_index(5));
//         assert_eq!(0, right_lineage_length_from_leaf_index(6));
//         assert_eq!(3, right_lineage_length_from_leaf_index(7));
//         assert_eq!(0, right_lineage_length_from_leaf_index(8));
//         assert_eq!(1, right_lineage_length_from_leaf_index(9));
//         assert_eq!(0, right_lineage_length_from_leaf_index(10));
//         assert_eq!(32, right_lineage_length_from_leaf_index((1 << 32) - 1));
//         assert_eq!(63, right_lineage_length_from_leaf_index((1 << 63) - 1));
//     }

//     #[test]
//     fn leaf_index_to_mt_index_test() {
//         // 1 leaf
//         assert_eq!((1, 0), leaf_index_to_mt_index_and_peak_index(0, 1));

//         // 2 leafs
//         assert_eq!((2, 0), leaf_index_to_mt_index_and_peak_index(0, 2));
//         assert_eq!((3, 0), leaf_index_to_mt_index_and_peak_index(1, 2));

//         // 3 leafs
//         assert_eq!((2, 0), leaf_index_to_mt_index_and_peak_index(0, 3));
//         assert_eq!((3, 0), leaf_index_to_mt_index_and_peak_index(1, 3));
//         assert_eq!((1, 1), leaf_index_to_mt_index_and_peak_index(2, 3));

//         // 4 leafs
//         assert_eq!((4, 0), leaf_index_to_mt_index_and_peak_index(0, 4));
//         assert_eq!((5, 0), leaf_index_to_mt_index_and_peak_index(1, 4));
//         assert_eq!((6, 0), leaf_index_to_mt_index_and_peak_index(2, 4));
//         assert_eq!((7, 0), leaf_index_to_mt_index_and_peak_index(3, 4));

//         // 14 leafs
//         assert_eq!((8, 0), leaf_index_to_mt_index_and_peak_index(0, 14));
//         assert_eq!((9, 0), leaf_index_to_mt_index_and_peak_index(1, 14));
//         assert_eq!((10, 0), leaf_index_to_mt_index_and_peak_index(2, 14));
//         assert_eq!((11, 0), leaf_index_to_mt_index_and_peak_index(3, 14));
//         assert_eq!((12, 0), leaf_index_to_mt_index_and_peak_index(4, 14));
//         assert_eq!((13, 0), leaf_index_to_mt_index_and_peak_index(5, 14));
//         assert_eq!((14, 0), leaf_index_to_mt_index_and_peak_index(6, 14));
//         assert_eq!((15, 0), leaf_index_to_mt_index_and_peak_index(7, 14));
//         assert_eq!((4, 1), leaf_index_to_mt_index_and_peak_index(8, 14));
//         assert_eq!((5, 1), leaf_index_to_mt_index_and_peak_index(9, 14));
//         assert_eq!((6, 1), leaf_index_to_mt_index_and_peak_index(10, 14));
//         assert_eq!((7, 1), leaf_index_to_mt_index_and_peak_index(11, 14));
//         assert_eq!((7, 1), leaf_index_to_mt_index_and_peak_index(11, 14));

//         // 22 leafs
//         assert_eq!((16, 0), leaf_index_to_mt_index_and_peak_index(0, 23));
//         assert_eq!((17, 0), leaf_index_to_mt_index_and_peak_index(1, 23));
//         assert_eq!((18, 0), leaf_index_to_mt_index_and_peak_index(2, 23));
//         assert_eq!((19, 0), leaf_index_to_mt_index_and_peak_index(3, 23));
//         assert_eq!((30, 0), leaf_index_to_mt_index_and_peak_index(14, 23));
//         assert_eq!((31, 0), leaf_index_to_mt_index_and_peak_index(15, 23));
//         assert_eq!((4, 1), leaf_index_to_mt_index_and_peak_index(16, 23));
//         assert_eq!((5, 1), leaf_index_to_mt_index_and_peak_index(17, 23));
//         assert_eq!((6, 1), leaf_index_to_mt_index_and_peak_index(18, 23));
//         assert_eq!((7, 1), leaf_index_to_mt_index_and_peak_index(19, 23));
//         assert_eq!((2, 2), leaf_index_to_mt_index_and_peak_index(20, 23));
//         assert_eq!((3, 2), leaf_index_to_mt_index_and_peak_index(21, 23));
//         assert_eq!((1, 3), leaf_index_to_mt_index_and_peak_index(22, 23));

//         // 32 leafs
//         for i in 0..32 {
//             assert_eq!((32 + i, 0), leaf_index_to_mt_index_and_peak_index(i, 32));
//         }

//         // 33 leafs
//         for i in 0..32 {
//             assert_eq!((32 + i, 0), leaf_index_to_mt_index_and_peak_index(i, 33));
//         }
//         assert_eq!((1, 1), leaf_index_to_mt_index_and_peak_index(32, 33));

//         // 34 leafs
//         for i in 0..32 {
//             assert_eq!((32 + i, 0), leaf_index_to_mt_index_and_peak_index(i, 34));
//         }
//         assert_eq!((2, 1), leaf_index_to_mt_index_and_peak_index(32, 34));
//         assert_eq!((3, 1), leaf_index_to_mt_index_and_peak_index(33, 34));

//         // 35 leafs
//         for i in 0..32 {
//             assert_eq!((32 + i, 0), leaf_index_to_mt_index_and_peak_index(i, 35));
//         }
//         assert_eq!((2, 1), leaf_index_to_mt_index_and_peak_index(32, 35));
//         assert_eq!((3, 1), leaf_index_to_mt_index_and_peak_index(33, 35));
//         assert_eq!((1, 2), leaf_index_to_mt_index_and_peak_index(34, 35));

//         // 36 leafs
//         for i in 0..32 {
//             assert_eq!((32 + i, 0), leaf_index_to_mt_index_and_peak_index(i, 36));
//         }
//         assert_eq!((4, 1), leaf_index_to_mt_index_and_peak_index(32, 36));
//         assert_eq!((5, 1), leaf_index_to_mt_index_and_peak_index(33, 36));
//         assert_eq!((6, 1), leaf_index_to_mt_index_and_peak_index(34, 36));
//         assert_eq!((7, 1), leaf_index_to_mt_index_and_peak_index(35, 36));

//         // 37 leafs
//         for i in 0..32 {
//             assert_eq!((32 + i, 0), leaf_index_to_mt_index_and_peak_index(i, 37));
//         }
//         assert_eq!((4, 1), leaf_index_to_mt_index_and_peak_index(32, 37));
//         assert_eq!((5, 1), leaf_index_to_mt_index_and_peak_index(33, 37));
//         assert_eq!((6, 1), leaf_index_to_mt_index_and_peak_index(34, 37));
//         assert_eq!((7, 1), leaf_index_to_mt_index_and_peak_index(35, 37));
//         assert_eq!((1, 2), leaf_index_to_mt_index_and_peak_index(36, 37));

//         for i in (10..63).map(|x| 1 << x) {
//             assert_eq!((14 + i, 0), leaf_index_to_mt_index_and_peak_index(14, i));
//             assert_eq!((3, 2), leaf_index_to_mt_index_and_peak_index(i + 9, i + 11));
//             assert_eq!(
//                 (1, 3),
//                 leaf_index_to_mt_index_and_peak_index(i + 10, i + 11)
//             );
//         }
//     }

//     #[test]
//     fn peak_index_test() {
//         let peak_index = |leaf_index, num_leafs| {
//             let (_, peak_index) = leaf_index_to_mt_index_and_peak_index(leaf_index, num_leafs);
//             peak_index
//         };

//         assert_eq!(0, peak_index(0, 1));

//         assert_eq!(0, peak_index(0, 2));
//         assert_eq!(0, peak_index(1, 2));

//         assert_eq!(0, peak_index(0, 3));
//         assert_eq!(0, peak_index(1, 3));
//         assert_eq!(1, peak_index(2, 3));

//         assert_eq!(0, peak_index(0, 4));
//         assert_eq!(0, peak_index(1, 4));
//         assert_eq!(0, peak_index(2, 4));
//         assert_eq!(0, peak_index(3, 4));

//         assert_eq!(0, peak_index(0, 5));
//         assert_eq!(0, peak_index(1, 5));
//         assert_eq!(0, peak_index(2, 5));
//         assert_eq!(0, peak_index(3, 5));
//         assert_eq!(1, peak_index(4, 5));

//         assert_eq!(0, peak_index(0, 7));
//         assert_eq!(0, peak_index(1, 7));
//         assert_eq!(0, peak_index(2, 7));
//         assert_eq!(0, peak_index(3, 7));
//         assert_eq!(1, peak_index(4, 7));
//         assert_eq!(1, peak_index(5, 7));
//         assert_eq!(2, peak_index(6, 7));

//         assert_eq!(0, peak_index(0, (1 << 32) - 1));
//         assert_eq!(0, peak_index(1, (1 << 32) - 1));

//         assert_eq!(0, peak_index((0b01 << 31) - 1, (0b10 << 31) - 1));
//         assert_eq!(1, peak_index(0b01 << 31, (0b10 << 31) - 1));

//         assert_eq!(1, peak_index((0b011 << 30) - 1, (0b100 << 30) - 1));
//         assert_eq!(2, peak_index(0b011 << 30, (0b100 << 30) - 1));

//         assert_eq!(1, peak_index((0b0101 << 29) - 1, (0b1000 << 29) - 1));
//         assert_eq!(2, peak_index((0b0111 << 29) - 1, (0b1000 << 29) - 1));
//     }

//     #[test]
//     fn merkle_tree_and_peak_indices_can_be_computed_for_large_mmrs() {
//         leaf_index_to_mt_index_and_peak_index(0, u64::MAX);
//         leaf_index_to_mt_index_and_peak_index(u64::MAX - 1, u64::MAX);
//     }

//     #[proptest]
//     fn right_lineage_length_from_leaf_index_does_not_crash(
//         #[strategy(0..=u64::MAX >> 1)] leaf_index: u64,
//     ) {
//         right_lineage_length_from_leaf_index(leaf_index);
//     }

//     #[proptest]
//     fn calculate_new_peaks_from_append_does_not_crash(
//         #[strategy(0..u64::MAX >> 1)] old_num_leafs: u64,
//         #[strategy(vec(arb(), #old_num_leafs.count_ones() as usize))] old_peaks: Vec<Digest>,
//         #[strategy(arb())] new_leaf: Digest,
//     ) {
//         calculate_new_peaks_from_append(old_num_leafs, old_peaks, new_leaf);
//     }

//     #[test]
//     fn calculate_new_peaks_from_append_to_empty_mmra_does_not_crash() {
//         calculate_new_peaks_from_append(0, vec![], rand::random());
//     }
// }
