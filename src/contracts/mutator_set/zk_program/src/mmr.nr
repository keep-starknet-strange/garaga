use poseidon::poseidon::bn254::hash_2;

// Represents a Merkle Mountain Range proof element
pub struct MMRProofElement {
    // The sibling hash at this level
    pub hash: Field,
}

// Helper function to calculate the number of ones in a Field value
fn count_ones(value: u64) -> u32 {
    let mut count = 0;
    let mut v = value;
    for _ in 0..64 {
        let bit = (v & 1) as u32;
        count = count + bit;
        v = v / 2;
    }
    count
}

// Helper function to calculate log2 of a Field value
fn log2(value: u64) -> u32 {
    let mut result = 0;
    let mut v = value;
    for _ in 0..64 {
        let should_continue = v > 1;
        result = if should_continue { result + 1 } else { result };
        v = if should_continue { v / 2 } else { v };
    }
    result
}

// Helper function to calculate leaf_index_to_mt_index_and_peak_index
pub fn leaf_index_to_mt_index_and_peak_index(leaf_index: u64, num_leafs: u64) -> (u64, u32) {
    // Check if leaf_index is out of bounds
    let is_valid = leaf_index < num_leafs;
    assert(is_valid, "Leaf index must be strictly smaller than the number of leafs");

    // Calculate discrepancies to find local Merkle tree height
    let discrepancies = leaf_index ^ num_leafs;
    let local_mt_height = log2(discrepancies);
    let local_mt_num_leafs = 1 << (local_mt_height as u8);
    let remainder_bitmask = (local_mt_num_leafs - 1) as u64;
    let local_leaf_index = leaf_index & (remainder_bitmask as u64);
    let mt_node_index = local_leaf_index + (local_mt_num_leafs as u64);

    // Calculate peak index
    let num_peaks = count_ones(num_leafs);
    let num_peaks_smaller_or_equal_own_peak =
        count_ones(((num_leafs as u64) & remainder_bitmask) as u64);
    let peak_index = num_peaks - num_peaks_smaller_or_equal_own_peak - 1;

    (mt_node_index, peak_index)
}

// Verifies that a leaf exists in an MMR using an inclusion proof
pub fn verify_mmr_inclusion(
    // The leaf hash to verify
    leaf_hash: Field,
    // The MMR root hash
    root_hash: Field,
    // The position of the leaf in the MMR (0-based)
    leaf_index: u64,
    // The number of leafs in the MMR
    num_leafs: u64,
    // The array of proof elements
    authentication_path: BoundedVec<MMRProofElement, 32>,
    // peaks of the MMR
    peaks: [Field; 32],
) {
    // Check if leaf index is out of bounds
    assert(leaf_index < num_leafs, "Leaf index must be strictly smaller than the number of leafs");

    // Get Merkle tree index and peak index
    let (mut mt_index, peak_index) = leaf_index_to_mt_index_and_peak_index(leaf_index, num_leafs);

    // Verify peak count matches
    let expected_peak_count = count_ones(num_leafs);

    // assert(peaks.len() == expected_peak_count, "Invalid peaks length");

    // Verify authentication path length matches Merkle tree height
    let merkle_tree_height = log2(mt_index);

    assert(authentication_path.len() == merkle_tree_height, "Invalid authentication path length");

    // Process the authentication path
    let mut current_node = leaf_hash;
    for i in 0..32 {
        // print(i);
        // Compute the hash of the current node with its sibling
        if i < merkle_tree_height {
            let proof_element = authentication_path.get(i);
            let current_node_is_left_sibling = ((mt_index as u64) % 2) == 0;
            if current_node_is_left_sibling {
                // println("current_node_is_left_sibling");
                current_node = hash_2([current_node, proof_element.hash]);
            } else {
                // println("current_node_is_right_sibling");
                current_node = hash_2([proof_element.hash, current_node]);
            }
            // Move up one level in the tree
            mt_index = mt_index / 2;
        }
    }

    assert(mt_index == 1, "Invalid mt_index");

    // Verify against the root hash
    assert(peaks[peak_index] == current_node, "Invalid inclusion proof");

    let bag = bag_peaks(peaks, expected_peak_count);

    assert(bag == root_hash, "Invalid root hash");
}

pub fn bag_peaks(mut peaks: [Field; 32], n_peaks: u32) -> Field {
    let mut bag = peaks[n_peaks - 1];

    for i in 1..31 {
        if i < n_peaks {
            bag = hash_2([peaks[n_peaks - i - 1], bag]);
        }
    }
    bag
}
