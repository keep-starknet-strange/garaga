// Verifies an inner UltraHonk ZK proof in-circuit. The resulting outer proof carries a
// non-default pairing point accumulator in its public inputs, which the verifier must aggregate.
use bb_proof_verification::{UltraHonkVerificationKey, UltraHonkZKProof, verify_honk_proof};

fn main(
    verification_key: UltraHonkVerificationKey,
    proof: UltraHonkZKProof,
    public_inputs: pub [Field; 1],
    key_hash: Field,
) {
    verify_honk_proof(verification_key, proof, public_inputs, key_hash);
}
