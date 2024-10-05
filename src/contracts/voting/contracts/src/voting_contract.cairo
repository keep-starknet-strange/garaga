#[starknet::interface]
trait IVotingContract<TContractState> {
    fn create_voting(
        ref self: TContractState, question: ByteArray, reveal_date: u64, choices: Array<ByteArray>
    ) -> u64;
    fn vote(ref self: TContractState, voting_id: u64, choice: u64);
    // fn get_all_votings(ref self: TContractState) -> Array<Voting>;
    fn solve_voting(ref self: TContractState, voting_id: u64) -> u64;


    //View functions
    fn get_voting_results(self: @TContractState, voting_id: u64) -> Array<u64>;
    fn get_voting_choices(self: @TContractState, voting_id: u64) -> Array<ByteArray>;
    fn get_voting_winner_choice_id(self: @TContractState, voting_id: u64) -> u64;
}


#[starknet::contract]
mod VotingContract {
    use starknet::event::EventEmitter;
    use core::dict::Felt252Dict;
    use starknet::storage::{
        Map, StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Vec, VecTrait,
        MutableVecTrait
    };

    use core::starknet::{ContractAddress, get_caller_address, get_block_timestamp};

    #[derive(Drop, Serde, starknet::Store)]
    struct Choice {
        label: ByteArray,
    }

    #[derive(Drop, Serde, starknet::Store)]
    struct Voting {
        id: u64,
        question: ByteArray,
        reveal_date: u64, // seconds unix epoch time
        creator: ContractAddress,
        is_solved: bool,
    }

    // TODO: add encrypted choice here, this struct will change
    #[derive(Drop, Serde, starknet::Store)]
    struct Vote {
        choice: u64, // id of the choice == index in the choices array
    }


    #[storage]
    struct Storage {
        votings: Map<u64, Voting>,
        votings_count: u64,
        voting_to_choices: Map<u64, Vec<Choice>>, //mapping of a voting id to its choices
        voting_to_voters_addresses: Map<
            u64, Vec<ContractAddress>
        >, //mapping of a voting id to its voters
        voting_to_voters_bool: Map<
            u64, Map<ContractAddress, bool>
        >, //mapping of a voting id to its voters and a bool indicating if they have voted => used to prevent double voting but making it possible to voters change their vote
        voting_to_votes: Map<u64, Map<ContractAddress, Vote>>, //mapping of a voting id to its votes
        voting_to_choice_id_winner: Map<
            u64, u64
        >, //mapping of a voting id to the id of the choice that won (only makes sense after the voting is solved)
        voting_to_results: Map<
            u64, Map<u64, u64>
        >, //mapping of a voting id to a mapping of a choice id to the number of votes it had (only makes sense after the voting is solved)
    }

    // Events
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        VotingCreated: VotingCreated,
        VotingSolved: VotingSolved,
        VoterAddressAdded: VoterAddressAdded,
        VoteCast: VoteCast
    }


    #[derive(Drop, starknet::Event)]
    struct VotingCreated {
        id: u64,
        reveal_date: u64,
        creator: ContractAddress,
        question: ByteArray,
    }

    #[derive(Drop, starknet::Event)]
    struct VotingSolved {
        #[key]
        id: u64,
        winner_choice_id: u64,
    }

    #[derive(Drop, starknet::Event)]
    struct VoterAddressAdded {
        #[key]
        voting_id: u64,
        voter: ContractAddress,
    }

    #[derive(Drop, starknet::Event)]
    struct VoteCast {
        #[key]
        voting_id: u64,
        voter: ContractAddress
    }


    #[constructor]
    fn constructor(ref self: ContractState) {}


    #[abi(embed_v0)]
    impl VotingContractImpl of super::IVotingContract<ContractState> {
        fn create_voting(
            ref self: ContractState,
            question: ByteArray,
            reveal_date: u64,
            choices: Array<ByteArray>
        ) -> u64 {
            let id: u64 = self.votings_count.read() + 1;
            let creator: ContractAddress = get_caller_address();

            self
                .votings
                .entry(id)
                .write(
                    Voting {
                        id: id,
                        question: question.clone(),
                        reveal_date: reveal_date,
                        creator: creator,
                        is_solved: false
                    }
                );

            for choice in choices {
                self.voting_to_choices.entry(id).append().write(Choice { label: choice });
            };

            self
                .emit(
                    VotingCreated {
                        id: id, reveal_date: reveal_date, creator: creator, question: question
                    }
                );

            id
        }

        fn vote(ref self: ContractState, voting_id: u64, choice: u64) {
            let current_time: u64 = get_block_timestamp();

            assert(
                current_time < self.votings.entry(voting_id).read().reveal_date,
                'Voting is not open'
            );
            assert(choice < self.voting_to_choices.entry(voting_id).len(), 'Choice does not exist');

            let caller_address: ContractAddress = get_caller_address();

            if !self.voting_to_voters_bool.entry(voting_id).entry(caller_address).read() {
                self.voting_to_voters_addresses.entry(voting_id).append().write(caller_address);
                self.emit(VoterAddressAdded { voting_id: voting_id, voter: caller_address });
            }

            // TODO: change the vote struct to add encrypted choice here
            self
                .voting_to_votes
                .entry(voting_id)
                .entry(caller_address)
                .write(Vote { choice: choice });

            self.emit(VoteCast { voting_id: voting_id, voter: caller_address });
        }

        fn solve_voting(ref self: ContractState, voting_id: u64) -> u64 {
            let current_time: u64 = get_block_timestamp();
            assert(
                current_time > self.votings.entry(voting_id).read().reveal_date,
                'Voting is not closed yet'
            );

            let number_voters: u64 = self.voting_to_voters_addresses.entry(voting_id).len();

            let number_choices: u64 = self.voting_to_choices.entry(voting_id).len();
            let mut votes_count: Felt252Dict<u64> = Default::default();

            for i in 0..number_choices {
                votes_count.insert(i.into(), 0);
            };

            for i in 0
                ..number_voters {
                    let voter: ContractAddress = self
                        .voting_to_voters_addresses
                        .entry(voting_id)
                        .at(i)
                        .read();

                    //TODO: add decryption here
                    let choice: u64 = self
                        .voting_to_votes
                        .entry(voting_id)
                        .entry(voter)
                        .read()
                        .choice;

                    votes_count.insert(choice.into(), votes_count.get(choice.into()) + 1);
                };

            let mut choice_winner: u64 = 0;

            for i in 0
                ..number_choices {
                    if votes_count.get(i.into()) > votes_count.get(choice_winner.into()) {
                        choice_winner = i;
                    }
                    self
                        .voting_to_results
                        .entry(voting_id)
                        .entry(i)
                        .write(votes_count.get(i.into()));
                };

            self.voting_to_choice_id_winner.entry(voting_id).write(choice_winner);

            self.emit(VotingSolved { id: voting_id, winner_choice_id: choice_winner });

            choice_winner
        }

        // View functions
        fn get_voting_choices(self: @ContractState, voting_id: u64) -> Array<ByteArray> {
            let mut choices: Array<ByteArray> = array![];

            let number_choices: u64 = self.voting_to_choices.entry(voting_id).len();

            for i in 0
                ..number_choices {
                    choices.append(self.voting_to_choices.entry(voting_id).at(i).read().label);
                };

            choices
        }

        fn get_voting_results(self: @ContractState, voting_id: u64) -> Array<u64> {
            let current_time: u64 = get_block_timestamp();
            assert(
                current_time > self.votings.entry(voting_id).read().reveal_date,
                'Voting is not closed yet'
            );

            let number_choices: u64 = self.voting_to_choices.entry(voting_id).len();
            let mut results: Array<u64> = array![];

            for i in 0
                ..number_choices {
                    results.append(self.voting_to_results.entry(voting_id).entry(i).read());
                };

            results
        }

        fn get_voting_winner_choice_id(self: @ContractState, voting_id: u64) -> u64 {
            let current_time: u64 = get_block_timestamp();
            assert(
                current_time > self.votings.entry(voting_id).read().reveal_date,
                'Voting is not closed yet'
            );

            self.voting_to_choice_id_winner.entry(voting_id).read()
        }
    }
}
