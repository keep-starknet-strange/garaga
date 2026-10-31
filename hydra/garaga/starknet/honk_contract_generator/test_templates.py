def release_tests(public_inputs: list[int], zero_commitments: tuple[int, ...]) -> str:
    """Exercise public outputs and encoding guards through the generated contract interface."""
    expected = ", ".join(f"{value}_u256" for value in public_inputs)
    code = r"""
use garaga::apps::noir::{ZKHonkProof, G1Point256};
use garaga::apps::noir::zk_honk_transcript::Fr;

fn fixture_words() -> Array<felt252> {
    read_txt(@FileTrait::new("tests/proof_calldata.txt"))
}

fn verify_words(words: Span<felt252>) -> Result<Span<u256>, felt252> {
    declare_contract("UniversalECIP");
    let class_hash = declare_contract("UltraKeccakZKHonkVerifier");
    let dispatcher = IUltraKeccakZKHonkVerifierLibraryDispatcher { class_hash };
    dispatcher.verify_ultra_keccak_zk_honk_proof(words)
}

fn decoded_fixture() -> (ZKHonkProof, Span<felt252>) {
    let mut words = fixture_words().span();
    let proof = Serde::<ZKHonkProof>::deserialize(ref words).unwrap();
    (proof, words)
}

fn encode_fixture(proof: ZKHonkProof, tail: Span<felt252>) -> Array<felt252> {
    let mut words = array![];
    proof.serialize(ref words);
    for value in tail { words.append(*value); };
    words
}

#[test]
fn test_public_outputs() {
    assert_eq!(verify_words(fixture_words().span()).unwrap(), array![EXPECTED_PUBLIC_INPUTS].span());
}

#[test]
fn reject_noncanonical_public_input() {
    let (proof, tail) = decoded_fixture();
    let proof = ZKHonkProof { public_inputs: array![Fr].span(), ..proof };
    assert_eq!(verify_words(encode_fixture(proof, tail).span()), Result::Err('Invalid Honk proof encoding'));
}

#[test]
fn reject_wrong_public_input_count() {
    let (proof, tail) = decoded_fixture();
    let proof = ZKHonkProof { public_inputs: array![0, 0].span(), ..proof };
    assert_eq!(verify_words(encode_fixture(proof, tail).span()), Result::Err('Invalid Honk proof encoding'));
}

#[test]
fn reject_noncanonical_point_coordinate() {
    let (proof, tail) = decoded_fixture();
    let proof = ZKHonkProof {
        w1: G1Point256 { x: 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47, y: proof.w1.y },
        ..proof
    };
    assert_eq!(verify_words(encode_fixture(proof, tail).span()), Result::Err('Invalid Honk proof encoding'));
}

#[test]
fn reject_noncanonical_sumcheck_scalar() {
    let (proof, tail) = decoded_fixture();
    let proof = ZKHonkProof { libra_sum: Fr, ..proof };
    assert_eq!(verify_words(encode_fixture(proof, tail).span()), Result::Err('Invalid Honk proof encoding'));
}

#[test]
fn reject_noncanonical_accumulator_limb() {
    let (proof, tail) = decoded_fixture();
    let proof = ZKHonkProof { pairing_point_object: array![0x10000000000000000000000000000000000, 0, 0, 0, 0, 0, 0, 0].span(), ..proof };
    assert_eq!(verify_words(encode_fixture(proof, tail).span()), Result::Err('Invalid Honk proof encoding'));
}

#[test]
fn reject_trailing_calldata() {
    let mut words = fixture_words();
    words.append(1);
    assert_eq!(verify_words(words.span()), Result::Err('Invalid Honk proof encoding'));
}

#[test]
#[should_panic]
fn reject_changed_public_input() {
    let (proof, tail) = decoded_fixture();
    let mut changed = array![];
    for index in 0_usize..proof.public_inputs.len() {
        changed.append(*proof.public_inputs.at(index) + if index == 0 { 1 } else { 0 });
    };
    let proof = ZKHonkProof { public_inputs: changed.span(), ..proof };
    verify_words(encode_fixture(proof, tail).span()).unwrap();
}
""".replace("EXPECTED_PUBLIC_INPUTS", expected)

    if zero_commitments:
        code += f"""
#[test]
fn reject_nonzero_evaluation_for_identity_commitment() {{
    let (proof, tail) = decoded_fixture();
    let mut evaluations = array![];
    for index in 0_usize..proof.sumcheck_evaluations.len() {{
        evaluations.append(if index == {zero_commitments[0]} {{ 1 }} else {{ *proof.sumcheck_evaluations.at(index) }});
    }};
    let proof = ZKHonkProof {{ sumcheck_evaluations: evaluations.span(), ..proof }};
    assert_eq!(verify_words(encode_fixture(proof, tail).span()), Result::Err('Invalid zero selector eval'));
}}
"""
    return code
