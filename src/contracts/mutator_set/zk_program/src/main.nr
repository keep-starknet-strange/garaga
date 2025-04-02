pub mod mmr;
pub mod mmr_tests;

// use dep::std::hash::poseidon::bn254::hash_2;
use mmr::{MMRProofElement, verify_mmr_inclusion};

fn main(
    // MMR verification inputs
    leaf_premiage: Field,
    root_hash: pub Field,
    num_leafs: pub u64,
    leaf_index: pub u64,
    proof: BoundedVec<MMRProofElement, 32>,
    peaks: [Field; 32],
) {
    // Prove knowledge of pre-image
    // let leaf_hash = hash_2([leaf_premiage, 0]);
    let leaf_hash = leaf_premiage;

    // Verify MMR inclusion

    verify_mmr_inclusion(leaf_hash, root_hash, leaf_index, num_leafs, proof, peaks);

    // Todo derive bloom filter bits from pre-image.

}

#[test]
fn test_main() {
    // Test data for MMR verification
    let leaf1 = 0;

    // Create proof for leaf1 (padding with empty elements to match size 32)
    let mut proof = BoundedVec::new();
    proof.push(MMRProofElement { hash: 0 }); // Sibling of leaf1
    proof.push(
        MMRProofElement {
            hash: 0x2098f5fb9e239eab3ceac3f27b81e481dc3124d55ffed523a839ee8446b64864,
        },
    ); // Sibling of hash12

    let mut peaks = [0; 32];
    peaks[0] = 0x1069673dcdb12263df301a6ff584a7ec261a44cb9dc68df067a4774460b1f1e1;
    peaks[1] = 0;

    let root = 0x1ba30aaf15c7694786a1f118ca39fcc6c997b48da9dfa62e9ec3e83ac7d6304d;

    // Test the main function
    main(leaf1, root, 5, 2, proof, peaks);
}
