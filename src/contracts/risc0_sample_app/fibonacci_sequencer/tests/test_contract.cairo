use fibonacci_sequencer::FibonacciSequencer::RISC_ZERO_VERIFIER_CLASS_HASH;
use fibonacci_sequencer::{IFibonacciSequencerDispatcher, IFibonacciSequencerDispatcherTrait};
use snforge_std::fs::{FileTrait, read_txt};
use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};

#[test]
fn test_current_risc0_receipt_through_sequencer() {
    declare("UniversalECIP").unwrap();
    let verifier = declare("Risc0Groth16VerifierBN254").unwrap().contract_class();
    let verifier_hash: felt252 = (*verifier.class_hash).into();
    assert_eq!(verifier_hash, RISC_ZERO_VERIFIER_CLASS_HASH);

    let contract = declare("FibonacciSequencer").unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@array![]).unwrap();
    let dispatcher = IFibonacciSequencerDispatcher { contract_address };
    let file = FileTrait::new("tests/proof_calldata.txt");
    let calldata = read_txt(@file);
    dispatcher.verify_and_submit_fibonacci_number(calldata.span());
}
