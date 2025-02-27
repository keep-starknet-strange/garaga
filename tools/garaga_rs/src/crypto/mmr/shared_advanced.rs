use super::shared_basic::*;

/// Get (index, height) of leftmost ancestor
/// This ancestor does *not* have to be in the MMR
/// This algorithm finds the closest $2^n - 1$ that's bigger than
/// or equal to `node_index`.
#[inline]
pub fn leftmost_ancestor(node_index: u64) -> (u64, u32) {
    if node_index.leading_zeros() == 0 {
        return (u64::MAX, 63);
    }

    let height = node_index.ilog2();
    let index = (1 << (height + 1)) - 1;

    (index, height)
}

/// Traversing from this node upwards, count how many of the ancestor (including itself)
/// is a right child. Also returns node's height.
pub fn right_lineage_length_and_own_height(node_index: u64) -> (u32, u32) {
    let (mut candidate, mut candidate_height) = leftmost_ancestor(node_index);

    // leftmost ancestor is always a left node, so count starts at 0.
    let mut right_ancestor_count = 0;

    loop {
        if candidate == node_index {
            return (right_ancestor_count, candidate_height);
        }

        let left_child = left_child(candidate, candidate_height);
        let candidate_is_right_child = left_child < node_index;
        if candidate_is_right_child {
            candidate = right_child(candidate);
            right_ancestor_count += 1;
        } else {
            candidate = left_child;
            right_ancestor_count = 0;
        };

        candidate_height -= 1;
    }
}

pub fn right_lineage_length_from_node_index(node_index: u64) -> u32 {
    let bit_width = u64::BITS - node_index.leading_zeros();
    let npo2 = 1u128 << bit_width;

    let dist = (npo2 - (node_index as u128)) as u64;

    if (bit_width as u64) < dist {
        right_lineage_length_from_node_index(node_index - (1 << (bit_width - 1)) + 1)
    } else {
        (dist - 1) as u32
    }
}

/// Convert from leaf index to node index.
///
/// Crashes if `leaf_index` exceeds 63 bits.
pub fn leaf_index_to_node_index(leaf_index: u64) -> u64 {
    let hamming_weight = leaf_index.count_ones() as u64;
    2 * leaf_index - hamming_weight + 1
}

/// Get the node_index of the parent
#[inline]
pub fn parent(node_index: u64) -> u64 {
    let (right_ancestor_count, height) = right_lineage_length_and_own_height(node_index);

    if right_ancestor_count != 0 {
        node_index + 1
    } else {
        node_index + (1 << (height + 1))
    }
}

/// Get the node index of the left sibling, given the right sibling's node index
/// and the height of the layer on which it lives.
#[inline]
pub fn left_sibling(node_index: u64, height: u32) -> u64 {
    node_index - (1 << (height + 1)) + 1
}

/// Get the node index of the right sibling, given the left sibling's node index
/// and the height of the layer on which it lives.
#[inline]
pub fn right_sibling(node_index: u64, height: u32) -> u64 {
    node_index + (1 << (height + 1)) - 1
}

/// The number of nodes in an MMR with `leaf_count` leafs.
pub fn num_leafs_to_num_nodes(num_leafs: u64) -> u64 {
    let hamming_weight = num_leafs.count_ones() as u64;
    2 * num_leafs - hamming_weight
}

/// Return the indices of the nodes added by an append, including the (node index
/// of the) peak that this append gave rise to and (that of) the new leaf.
pub fn node_indices_added_by_append(old_leaf_count: u64) -> Vec<u64> {
    let mut node_index = leaf_index_to_node_index(old_leaf_count);
    let mut added_node_indices = vec![node_index];
    let mut right_count = right_lineage_length_from_node_index(node_index);
    while right_count != 0 {
        // a right child's parent is found by adding 1 to the node index
        node_index += 1;
        added_node_indices.push(node_index);
        right_count -= 1;
    }

    added_node_indices
}

/// Get the node indices of the authentication path starting from the specified
/// leaf, to its peak.
///
/// # Panics
///
/// Panics if the leaf index is out-of-bounds.
pub fn auth_path_node_indices(num_leafs: u64, leaf_index: u64) -> Vec<u64> {
    assert!(
        leaf_index < num_leafs,
        "Leaf index out-of-bounds: {leaf_index}/{num_leafs}"
    );

    let (mut merkle_tree_index, _) = leaf_index_to_mt_index_and_peak_index(leaf_index, num_leafs);
    let mut node_index = leaf_index_to_node_index(leaf_index);
    let mut height = 0;
    let tree_height = u64::BITS - merkle_tree_index.leading_zeros() - 1;
    let mut ret = Vec::with_capacity(tree_height as usize);
    while merkle_tree_index > 1 {
        let is_left_sibling = merkle_tree_index & 1 == 0;
        let height_pow = 1u64 << (height + 1);
        let as_1_or_minus_1: u64 = (2 * (is_left_sibling as i64) - 1) as u64;
        let signed_height_pow = height_pow.wrapping_mul(as_1_or_minus_1);
        let sibling = node_index
            .wrapping_add(signed_height_pow)
            .wrapping_sub(as_1_or_minus_1);

        node_index += 1 << ((height + 1) * is_left_sibling as u32);

        ret.push(sibling);
        merkle_tree_index >>= 1;
        height += 1;
    }

    debug_assert_eq!(tree_height, ret.len() as u32, "Allocation must be optimal");

    ret
}

/// Get the node indices of the authentication path hash digest needed
/// to calculate the digest of `peak_node_index` from `start_node_index`
pub fn get_authentication_path_node_indices(
    start_node_index: u64,
    peak_node_index: u64,
    node_count: u64,
) -> Option<Vec<u64>> {
    let mut authentication_path_node_indices = vec![];
    let mut node_index = start_node_index;
    while node_index <= node_count && node_index != peak_node_index {
        // TODO: Consider if this function can be written better, or discard
        // it entirely.
        let (right_ancestor_count, height) = right_lineage_length_and_own_height(node_index);
        let sibling_node_index: u64;
        if right_ancestor_count != 0 {
            sibling_node_index = left_sibling(node_index, height);

            // parent of right child is +1
            node_index += 1;
        } else {
            sibling_node_index = right_sibling(node_index, height);

            // parent of left child:
            node_index += 1 << (height + 1);
        }

        authentication_path_node_indices.push(sibling_node_index);
    }

    if node_index == peak_node_index {
        Some(authentication_path_node_indices)
    } else {
        None
    }
}

/// Return a list of the peak heights for a given leaf count.
///
/// # Examples
///
/// ```
// /// use twenty_first::util_types::mmr::shared_advanced::get_peak_heights;
// /// assert_eq!(get_peak_heights(0b1010), vec![3, 1]);
// /// assert_eq!(get_peak_heights(0b1011), vec![3, 1, 0]);
// /// ```
pub fn get_peak_heights(leaf_count: u64) -> Vec<u32> {
    // In an MMR, the peak heights directly correspond the leaf count's bit decomposition. That is,
    // the indices of the bits that are set in the binary representation of the leaf count are the
    // peaks' heights.
    let Some(num_bits_in_leaf_count) = leaf_count.checked_ilog2() else {
        return vec![];
    };

    let mut indices_of_set_bits = vec![];
    for bit_index in 0..=num_bits_in_leaf_count {
        let bit_mask = 1 << bit_index;
        let is_set_bit_in_leaf_count = bit_mask & leaf_count != 0;
        if is_set_bit_in_leaf_count {
            indices_of_set_bits.push(bit_index);
        }
    }

    // put highest index first
    indices_of_set_bits.reverse();
    indices_of_set_bits
}

/// Given the number of leafs in the MMR, return one vector representing the heights
/// of the peaks, and another vector representing their MMR node indices.
pub fn get_peak_heights_and_peak_node_indices(leaf_count: u64) -> (Vec<u32>, Vec<u64>) {
    if leaf_count == 0 {
        return (vec![], vec![]);
    }

    let node_index_of_rightmost_leaf = leaf_index_to_node_index(leaf_count - 1);
    let node_count = num_leafs_to_num_nodes(leaf_count);
    let (mut top_peak, mut top_height) = leftmost_ancestor(node_index_of_rightmost_leaf);
    if top_peak > node_count {
        top_peak = left_child(top_peak, top_height);
        top_height -= 1;
    }

    let mut heights: Vec<u32> = vec![top_height];
    let mut node_indices: Vec<u64> = vec![top_peak];
    let mut height = top_height;
    let mut candidate = right_sibling(top_peak, height);
    'outer: while height > 0 {
        '_inner: while candidate > node_count && height > 0 {
            candidate = left_child(candidate, height);
            height -= 1;
            if candidate <= node_count {
                heights.push(height);
                node_indices.push(candidate);
                candidate = right_sibling(candidate, height);
                continue 'outer;
            }
        }
    }

    (heights, node_indices)
}

/// Convert from node index to leaf index in log(size) time
pub fn node_index_to_leaf_index(node_index: u64) -> Option<u64> {
    let (_right, own_height) = right_lineage_length_and_own_height(node_index);
    if own_height != 0 {
        return None;
    }

    let (mut node, mut node_height) = leftmost_ancestor(node_index);
    let mut leaf_index = 0;
    while node_height > 0 {
        let left_child = left_child(node, node_height);
        if node_index <= left_child {
            node = left_child;
            node_height -= 1;
        } else {
            node = right_child(node);
            node_height -= 1;
            leaf_index += 1 << node_height;
        }
    }

    Some(leaf_index)
}

// #[cfg(test)]
// mod mmr_test {
//     use proptest::prelude::Just;
//     use proptest::prop_assert_eq;
//     use rand::RngCore;
//     use test_strategy::proptest;

//     use super::*;
//     use crate::prelude::Digest;
//     use crate::prelude::MmrMembershipProof;

//     #[test]
//     fn leaf_index_to_node_index_test() {
//         assert_eq!(1, leaf_index_to_node_index(0));
//         assert_eq!(2, leaf_index_to_node_index(1));
//         assert_eq!(4, leaf_index_to_node_index(2));
//         assert_eq!(5, leaf_index_to_node_index(3));
//         assert_eq!(8, leaf_index_to_node_index(4));
//         assert_eq!(9, leaf_index_to_node_index(5));
//         assert_eq!(11, leaf_index_to_node_index(6));
//         assert_eq!(12, leaf_index_to_node_index(7));
//         assert_eq!(16, leaf_index_to_node_index(8));
//         assert_eq!(17, leaf_index_to_node_index(9));
//         assert_eq!(19, leaf_index_to_node_index(10));
//         assert_eq!(20, leaf_index_to_node_index(11));
//         assert_eq!(23, leaf_index_to_node_index(12));
//         assert_eq!(24, leaf_index_to_node_index(13));
//         assert_eq!(26, leaf_index_to_node_index(14));
//         assert_eq!(27, leaf_index_to_node_index(15));
//         assert_eq!(32, leaf_index_to_node_index(16));
//         assert_eq!(33, leaf_index_to_node_index(17));
//         assert_eq!(35, leaf_index_to_node_index(18));
//         assert_eq!(36, leaf_index_to_node_index(19));
//         assert_eq!(39, leaf_index_to_node_index(20));
//         assert_eq!(40, leaf_index_to_node_index(21));
//     }

//     #[test]
//     fn node_indices_added_by_append_test() {
//         assert_eq!(vec![1], node_indices_added_by_append(0));
//         assert_eq!(vec![2, 3], node_indices_added_by_append(1));
//         assert_eq!(vec![4], node_indices_added_by_append(2));
//         assert_eq!(vec![5, 6, 7], node_indices_added_by_append(3));
//         assert_eq!(vec![8], node_indices_added_by_append(4));
//         assert_eq!(vec![9, 10], node_indices_added_by_append(5));
//         assert_eq!(vec![11], node_indices_added_by_append(6));
//         assert_eq!(vec![12, 13, 14, 15], node_indices_added_by_append(7));
//         assert_eq!(vec![16], node_indices_added_by_append(8));
//         assert_eq!(vec![17, 18], node_indices_added_by_append(9));
//         assert_eq!(vec![19], node_indices_added_by_append(10));
//         assert_eq!(vec![20, 21, 22], node_indices_added_by_append(11));
//         assert_eq!(vec![23], node_indices_added_by_append(12));
//         assert_eq!(vec![24, 25], node_indices_added_by_append(13));
//         assert_eq!(vec![26], node_indices_added_by_append(14));
//         assert_eq!(vec![27, 28, 29, 30, 31], node_indices_added_by_append(15));
//         assert_eq!(vec![32], node_indices_added_by_append(16));
//         assert_eq!(vec![33, 34], node_indices_added_by_append(17));
//         assert_eq!(vec![35], node_indices_added_by_append(18));
//         assert_eq!(vec![36, 37, 38], node_indices_added_by_append(19));
//         assert_eq!(
//             vec![58, 59, 60, 61, 62, 63],
//             node_indices_added_by_append(31)
//         );
//         assert_eq!(vec![64], node_indices_added_by_append(32));
//     }

//     #[test]
//     fn leaf_index_node_index_pbt() {
//         let mut rng = rand::rng();
//         for _ in 0..10_000 {
//             let rand = rng.next_u32();
//             let inversion_result = node_index_to_leaf_index(leaf_index_to_node_index(rand as u64));
//             let inversion = inversion_result.unwrap();
//             assert_eq!(rand, inversion as u32);
//         }
//     }

//     #[test]
//     fn right_ancestor_count_test() {
//         assert_eq!((0, 0), right_lineage_length_and_own_height(1)); // 0b1 => 0
//         assert_eq!((1, 0), right_lineage_length_and_own_height(2)); // 0b10 => 1
//         assert_eq!((0, 1), right_lineage_length_and_own_height(3)); // 0b11 => 0
//         assert_eq!((0, 0), right_lineage_length_and_own_height(4)); // 0b100 => 0
//         assert_eq!((2, 0), right_lineage_length_and_own_height(5)); // 0b101 => 2
//         assert_eq!((1, 1), right_lineage_length_and_own_height(6)); // 0b110 => 1
//         assert_eq!((0, 2), right_lineage_length_and_own_height(7)); // 0b111 => 0
//         assert_eq!((0, 0), right_lineage_length_and_own_height(8)); // 0b1000 => 0
//         assert_eq!((1, 0), right_lineage_length_and_own_height(9)); // 0b1001 => 1
//         assert_eq!((0, 1), right_lineage_length_and_own_height(10)); // 0b1010 => 0
//         assert_eq!((0, 0), right_lineage_length_and_own_height(11)); // 0b1011 => 0
//         assert_eq!((3, 0), right_lineage_length_and_own_height(12)); // 0b1100 => 3
//         assert_eq!((2, 1), right_lineage_length_and_own_height(13)); // 0b1101 => 2
//         assert_eq!((1, 2), right_lineage_length_and_own_height(14)); // 0b1110 => 1
//         assert_eq!((0, 3), right_lineage_length_and_own_height(15)); // 0b1111 => 0
//         assert_eq!((0, 0), right_lineage_length_and_own_height(16)); // 0b10000 => 0
//         assert_eq!((1, 0), right_lineage_length_and_own_height(17)); // 0b10001 => 1
//         assert_eq!((0, 1), right_lineage_length_and_own_height(18)); // 0b10010 => 0
//         assert_eq!((0, 0), right_lineage_length_and_own_height(19)); // 0b10011 => 0
//         assert_eq!((2, 0), right_lineage_length_and_own_height(20)); // 0b10100 => 2
//         assert_eq!((1, 1), right_lineage_length_and_own_height(21)); // 0b10101 => 1
//         assert_eq!((0, 2), right_lineage_length_and_own_height(22)); // 0b10110 => 0
//         assert_eq!((0, 0), right_lineage_length_and_own_height(23)); // 0b10111 => 0
//         assert_eq!((1, 0), right_lineage_length_and_own_height(24)); // 0b11000 => 1
//         assert_eq!((0, 1), right_lineage_length_and_own_height(25)); // 0b11001 => 0
//         assert_eq!((0, 0), right_lineage_length_and_own_height(26)); // 0b11010 => 0
//         assert_eq!((4, 0), right_lineage_length_and_own_height(27)); // 0b11011 => 4
//         assert_eq!((3, 1), right_lineage_length_and_own_height(28)); // 0b11100 => 3
//         assert_eq!((2, 2), right_lineage_length_and_own_height(29)); // 0b11101 => 2
//         assert_eq!((1, 3), right_lineage_length_and_own_height(30)); // 0b11110 => 1
//         assert_eq!((0, 4), right_lineage_length_and_own_height(31)); // 0b11111 => 0
//         assert_eq!((0, 0), right_lineage_length_and_own_height(32)); // 0b100000 => 0
//         assert_eq!((1, 0), right_lineage_length_and_own_height(33)); // 0b100001 => 1
//         assert_eq!((0, 1), right_lineage_length_and_own_height(34)); // 0b100010 => 0
//         assert_eq!((0, 0), right_lineage_length_and_own_height(35)); // 0b100011 => 0
//         assert_eq!((2, 0), right_lineage_length_and_own_height(36)); // 0b100100 => 2
//         assert_eq!((1, 1), right_lineage_length_and_own_height(37)); // 0b100101 => 1
//         assert_eq!((0, 2), right_lineage_length_and_own_height(38)); // 0b100110 => 0
//         assert_eq!((0, 0), right_lineage_length_and_own_height(39)); // 0b100111 => 0
//         assert_eq!((1, 0), right_lineage_length_and_own_height(40)); // 0b101000 => 1
//         assert_eq!((0, 1), right_lineage_length_and_own_height(41)); // 0b101001 => 0

//         assert_eq!(
//             (61, 1),
//             right_lineage_length_and_own_height(u64::MAX / 2 - 61)
//         ); // 0b111...11 => 0
//         assert_eq!(
//             (3, 59),
//             right_lineage_length_and_own_height(u64::MAX / 2 - 3)
//         ); // 0b111...11 => 0
//         assert_eq!(
//             (2, 60),
//             right_lineage_length_and_own_height(u64::MAX / 2 - 2)
//         ); // 0b111...11 => 0
//         assert_eq!(
//             (1, 61),
//             right_lineage_length_and_own_height(u64::MAX / 2 - 1)
//         ); // 0b111...11 => 0
//         assert_eq!((0, 62), right_lineage_length_and_own_height(u64::MAX / 2)); // 0b111...11 => 0
//     }

//     #[proptest]
//     fn right_lineage_length_property(#[strategy(0u64..(1<<63))] leaf_index: u64) {
//         let rll = right_lineage_length_from_leaf_index(leaf_index);
//         let rac = right_lineage_length_and_own_height(leaf_index_to_node_index(leaf_index)).0;
//         prop_assert_eq!(rac, rll);
//     }

//     #[test]
//     fn leftmost_ancestor_test() {
//         assert_eq!((1, 0), leftmost_ancestor(1));
//         assert_eq!((3, 1), leftmost_ancestor(2));
//         assert_eq!((3, 1), leftmost_ancestor(3));
//         assert_eq!((7, 2), leftmost_ancestor(4));
//         assert_eq!((7, 2), leftmost_ancestor(5));
//         assert_eq!((7, 2), leftmost_ancestor(6));
//         assert_eq!((7, 2), leftmost_ancestor(7));
//         assert_eq!((15, 3), leftmost_ancestor(8));
//         assert_eq!((15, 3), leftmost_ancestor(9));
//         assert_eq!((15, 3), leftmost_ancestor(10));
//         assert_eq!((15, 3), leftmost_ancestor(11));
//         assert_eq!((15, 3), leftmost_ancestor(12));
//         assert_eq!((15, 3), leftmost_ancestor(13));
//         assert_eq!((15, 3), leftmost_ancestor(14));
//         assert_eq!((15, 3), leftmost_ancestor(15));
//         assert_eq!((31, 4), leftmost_ancestor(16));
//     }

//     #[test]
//     fn left_sibling_test() {
//         assert_eq!(3, left_sibling(6, 1));
//         assert_eq!(1, left_sibling(2, 0));
//         assert_eq!(4, left_sibling(5, 0));
//         assert_eq!(15, left_sibling(30, 3));
//         assert_eq!(22, left_sibling(29, 2));
//         assert_eq!(7, left_sibling(14, 2));
//     }

//     #[test]
//     fn node_index_to_leaf_index_test() {
//         assert_eq!(Some(0), node_index_to_leaf_index(1));
//         assert_eq!(Some(1), node_index_to_leaf_index(2));
//         assert_eq!(None, node_index_to_leaf_index(3));
//         assert_eq!(Some(2), node_index_to_leaf_index(4));
//         assert_eq!(Some(3), node_index_to_leaf_index(5));
//         assert_eq!(None, node_index_to_leaf_index(6));
//         assert_eq!(None, node_index_to_leaf_index(7));
//         assert_eq!(Some(4), node_index_to_leaf_index(8));
//         assert_eq!(Some(5), node_index_to_leaf_index(9));
//         assert_eq!(None, node_index_to_leaf_index(10));
//         assert_eq!(Some(6), node_index_to_leaf_index(11));
//         assert_eq!(Some(7), node_index_to_leaf_index(12));
//         assert_eq!(None, node_index_to_leaf_index(13));
//         assert_eq!(None, node_index_to_leaf_index(14));
//         assert_eq!(None, node_index_to_leaf_index(15));
//         assert_eq!(Some(8), node_index_to_leaf_index(16));
//         assert_eq!(Some(9), node_index_to_leaf_index(17));
//         assert_eq!(None, node_index_to_leaf_index(18));
//         assert_eq!(Some(10), node_index_to_leaf_index(19));
//         assert_eq!(Some(11), node_index_to_leaf_index(20));
//         assert_eq!(None, node_index_to_leaf_index(21));
//         assert_eq!(None, node_index_to_leaf_index(22));
//     }

//     #[test]
//     fn leaf_count_to_node_count_test() {
//         let node_counts: Vec<u64> = vec![
//             0, 1, 3, 4, 7, 8, 10, 11, 15, 16, 18, 19, 22, 23, 25, 26, 31, 32, 34, 35, 38, 39, 41,
//             42, 46, 47, 49, 50, 53, 54, 56, 57, 63, 64,
//         ];
//         for (i, node_count) in node_counts.iter().enumerate() {
//             assert_eq!(*node_count, num_leafs_to_num_nodes(i as u64));
//         }
//     }

//     #[test]
//     fn get_peak_heights_and_peak_node_indices_test() {
//         type TestCase = (u64, (Vec<u32>, Vec<u64>));
//         let leaf_count_and_expected: Vec<TestCase> = vec![
//             (0, (vec![], vec![])),
//             (1, (vec![0], vec![1])),
//             (2, (vec![1], vec![3])),
//             (3, (vec![1, 0], vec![3, 4])),
//             (4, (vec![2], vec![7])),
//             (5, (vec![2, 0], vec![7, 8])),
//             (6, (vec![2, 1], vec![7, 10])),
//             (7, (vec![2, 1, 0], vec![7, 10, 11])),
//             (8, (vec![3], vec![15])),
//             (9, (vec![3, 0], vec![15, 16])),
//             (10, (vec![3, 1], vec![15, 18])),
//             (11, (vec![3, 1, 0], vec![15, 18, 19])),
//             (12, (vec![3, 2], vec![15, 22])),
//             (13, (vec![3, 2, 0], vec![15, 22, 23])),
//             (14, (vec![3, 2, 1], vec![15, 22, 25])),
//             (15, (vec![3, 2, 1, 0], vec![15, 22, 25, 26])),
//             (16, (vec![4], vec![31])),
//             (17, (vec![4, 0], vec![31, 32])),
//             (18, (vec![4, 1], vec![31, 34])),
//             (19, (vec![4, 1, 0], vec![31, 34, 35])),
//         ];
//         for (leaf_count, (expected_heights, expected_indices)) in leaf_count_and_expected {
//             assert_eq!(
//                 (expected_heights.clone(), expected_indices),
//                 get_peak_heights_and_peak_node_indices(leaf_count)
//             );

//             assert_eq!(expected_heights, get_peak_heights(leaf_count));
//         }
//     }

//     #[test]
//     fn get_authentication_path_node_indices_test() {
//         type Interval = (u64, u64, u64);
//         type TestCase = (Interval, Option<Vec<u64>>);
//         let start_end_node_count_expected: Vec<TestCase> = vec![
//             ((1, 31, 31), Some(vec![2, 6, 14, 30])),
//             ((2, 31, 31), Some(vec![1, 6, 14, 30])),
//             ((3, 31, 31), Some(vec![6, 14, 30])),
//             ((4, 31, 31), Some(vec![5, 3, 14, 30])),
//             ((21, 31, 31), Some(vec![18, 29, 15])),
//             ((21, 31, 32), Some(vec![18, 29, 15])),
//             ((32, 32, 32), Some(vec![])),
//             ((1, 32, 32), None),
//         ];
//         for ((start, end, node_count), expected) in start_end_node_count_expected {
//             assert_eq!(
//                 expected,
//                 get_authentication_path_node_indices(start, end, node_count)
//             );
//         }
//     }

//     #[test]
//     #[should_panic(expected = "Leaf index out-of-bounds: 5/5")]
//     fn auth_path_indices_out_of_bounds_unit_test() {
//         auth_path_node_indices(5, 5);
//     }

//     #[proptest]
//     fn auth_path_indices_prop(
//         #[strategy(0u64..(u64::MAX>>1))] _num_leafs: u64,
//         #[strategy(0u64..(#_num_leafs))] leaf_index: u64,
//         #[strategy(Just(auth_path_node_indices(#_num_leafs, #leaf_index)))] node_indices: Vec<u64>,
//     ) {
//         let mp = MmrMembershipProof {
//             authentication_path: vec![Digest::default(); node_indices.len()],
//         };
//         prop_assert_eq!(mp.get_node_indices(leaf_index), node_indices);
//     }

//     #[test]
//     fn auth_path_indices_unit_test() {
//         assert_eq!(vec![2, 6, 14, 30], auth_path_node_indices(16, 0));
//         assert_eq!(vec![1, 6, 14, 30], auth_path_node_indices(16, 1));
//         assert_eq!(vec![5, 3, 14, 30], auth_path_node_indices(16, 2));
//         assert_eq!(vec![4, 3, 14, 30], auth_path_node_indices(16, 3));
//         assert_eq!(vec![9, 13, 7, 30], auth_path_node_indices(16, 4));
//         assert_eq!(vec![8, 13, 7, 30], auth_path_node_indices(16, 5));
//         assert_eq!(vec![12, 10, 7, 30], auth_path_node_indices(16, 6));
//         assert_eq!(vec![11, 10, 7, 30], auth_path_node_indices(16, 7));
//         assert_eq!(vec![17, 21, 29, 15], auth_path_node_indices(16, 8));
//         assert_eq!(vec![16, 21, 29, 15], auth_path_node_indices(16, 9));
//         assert_eq!(vec![20, 18, 29, 15], auth_path_node_indices(16, 10));
//         assert_eq!(vec![19, 18, 29, 15], auth_path_node_indices(16, 11));
//         assert_eq!(vec![24, 28, 22, 15], auth_path_node_indices(16, 12));
//         assert_eq!(vec![23, 28, 22, 15], auth_path_node_indices(16, 13));
//         assert_eq!(vec![27, 25, 22, 15], auth_path_node_indices(16, 14));
//         assert_eq!(vec![26, 25, 22, 15], auth_path_node_indices(16, 15));

//         assert_eq!(Vec::<u64>::new(), auth_path_node_indices(1, 0));
//         assert_eq!(vec![2], auth_path_node_indices(2, 0));
//         assert_eq!(vec![1], auth_path_node_indices(2, 1));

//         let mut expected = vec![];
//         for i in 1..63 {
//             expected.push((1u64 << (i + 1)) - 2);
//             assert_eq!(
//                 expected,
//                 auth_path_node_indices(1 << i, 0),
//                 "must match for i={i}"
//             );
//         }
//     }

//     #[proptest]
//     fn right_lineage_length_from_node_index_does_not_crash(node_index: u64) {
//         right_lineage_length_from_node_index(node_index);
//     }

//     #[proptest]
//     fn leftmost_ancestor_does_not_crash(node_index: u64) {
//         leftmost_ancestor(node_index);
//     }

//     #[proptest]
//     fn right_lineage_length_and_own_height_does_not_crash(node_index: u64) {
//         right_lineage_length_and_own_height(node_index);
//     }
// }
