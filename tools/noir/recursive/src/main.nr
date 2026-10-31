mod inner_key;

fn main(verification_key: [Field; 115], proof: [Field; 458], public_inputs: pub [Field; 1], key_hash: Field) {
    assert(key_hash == inner_key::VK_HASH);
    std::verify_proof_with_type(verification_key, proof, public_inputs, key_hash, 6);
}
