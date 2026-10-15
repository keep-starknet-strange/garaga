use dep::std;

fn main(
    prev_tally: pub Field,
    new_votes: pub Field,

    // Control flag for recursive verification
    is_first_run: pub Field,

    // Recursive verification elements
    verification_key: [Field; 128], //verification key size should always be 128 (as fas as i can tell)
    proof: [Field; 459], // proof size without public inputs is 459, every additonal pub input adds 1 to the proof size e.g. 460, 461, etc. However, the proof size will always remain 459. We manually remove the public inputs from the proof in the prover.toml
    public_inputs: [Field; 4],
    key_hash: Field
) -> pub Field {

// Add full recursive verification
    if is_first_run == 0 {
        // Verify the previous proof
        std::verify_proof(
            verification_key,
            proof,
            public_inputs,
            key_hash
        );
    }

    let new_tally = prev_tally + new_votes;
    new_tally
}
