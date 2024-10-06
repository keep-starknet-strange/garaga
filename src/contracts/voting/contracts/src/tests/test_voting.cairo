use voting::contracts::voting_contract::{
    Voting, IVotingContractDispatcher, IVotingContractDispatcherTrait
};

use core::starknet::{get_block_timestamp};

use snforge_std::{declare, DeclareResultTrait, ContractClassTrait};

fn setup_voting_contract() -> IVotingContractDispatcher {
    let voting_contract_class = declare("VotingContract").unwrap().contract_class();

    let mut calldata = array![];

    let (voting_contract_address, _) = voting_contract_class.deploy(@calldata).unwrap();

    IVotingContractDispatcher { contract_address: voting_contract_address }
}

#[test]
fn test_create_voting() {
    let voting_contract = setup_voting_contract();

    let question = "What is the best programming language?";
    let reveal_date = get_block_timestamp() + 1000;
    let choices = array!["Cairo", "Typescript", "Rust"];

    let id = voting_contract.create_voting(question, reveal_date, choices);

    let choices: Array<ByteArray> = voting_contract.get_voting_choices(id);

    let all_votings: Array<Voting> = voting_contract.get_all_votings();

    assert(all_votings.len() == 1, 'Voting not created');
    assert(choices.len() == 3, 'Choices not created');
}

#[test]
fn test_vote() {
    let voting_contract = setup_voting_contract();

    let question = "What is the best programming language?";
    let reveal_date = get_block_timestamp() + 1000;
    let choices = array!["Cairo", "Typescript", "Rust"];

    let id = voting_contract.create_voting(question, reveal_date, choices);

    let choice_index = 1;

    voting_contract.vote(id, choice_index);

    let all_votings: Array<Voting> = voting_contract.get_all_votings();

    assert(all_votings.len() == 1, 'Voting not created');

    let number_voters = voting_contract.get_number_voters(id);

    assert(number_voters == 1, 'Number of voters is not 1');
}
