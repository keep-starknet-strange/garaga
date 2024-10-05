use core::starknet::{ContractAddress};
use voting::contracts;

use snforge_std::{
    EventSpyAssertionsTrait, spy_events, declare, DeclareResultTrait, ContractClassTrait,
    start_cheat_caller_address, stop_cheat_caller_address, test_address,
    start_cheat_block_timestamp_global
};

fn setup_voting_contract() -> ContractAddress {
    let voting_contract_class = declare("VotingContract").unwrap().contract_class();

    let mut calldata = array![];

    let (voting_contract_address, _) = voting_contract_class.deploy(@calldata).unwrap();

    voting_contract_address
}

#[test]
fn test_create_voting() {
    let voting_contract_address = setup_voting_contract();
}
