use garaga::apps::sp1::{deserialize_full_proof_with_hints_sp1, verify_groth16_sp1};
use snforge_std::fs::{FileTrait, read_txt};

#[test]
fn test_verify_sp1_groth16_proof_bn254() {
    let file = FileTrait::new("src/tests/proof_calldata.txt");
    let calldata = read_txt(@file).span();
    assert(main(calldata).is_ok(), 'Proof verification failed');
}

#[executable]
pub fn main(full_proof_with_hints: Span<felt252>) -> Result<Span<u256>, felt252> {
    let fph = deserialize_full_proof_with_hints_sp1(full_proof_with_hints);
    return verify_groth16_sp1(fph);
}

#[test]
fn test_sp1_library_rejects_invalid_headers() {
    let file = FileTrait::new("src/tests/proof_calldata.txt");
    let original = read_txt(@file);
    for field in array![34, 36, 39] {
        let mut changed = array![];
        for i in 0..original.len() {
            let value = if field == 39 {
                0xffffffffffffffffffffffffffffffff
            } else {
                1
            };
            changed.append(if i == field {
                value
            } else {
                *original.at(i)
            });
        }
        assert(main(changed.span()).is_err(), 'Invalid SP1 header accepted');
    }
}
