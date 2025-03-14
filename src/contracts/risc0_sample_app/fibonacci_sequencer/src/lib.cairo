#[starknet::interface]
pub trait IFibonacciSequencer<TContractState> {
    fn verify_and_submit_fibonacci_number(
        ref self: TContractState, full_proof_with_hints: Span<felt252>,
    );
}

#[starknet::contract]
mod FibonacciSequencer {
    use core::starknet::ClassHash;
    use core::starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    pub const RISC_ZERO_VERIFIER_CLASS_HASH: felt252 =
    0x42c6d76fdaa080c3bb00cbc3cf7401a1fd189d36c22ba72ad11208dd2f2f3a7;

    #[storage]
    struct Storage {
        lower_bound: u32,
    }

    #[abi(embed_v0)]
    impl FibonacciSequencerImpl of super::IFibonacciSequencer<ContractState> {
        fn verify_and_submit_fibonacci_number(
            ref self: ContractState, full_proof_with_hints: Span<felt252>,
        ) {
            // sets the class hash for the RiscZero verifier already declared on-chain
            // by the Garaga team
            let class_hash: ClassHash = RISC_ZERO_VERIFIER_CLASS_HASH.try_into().unwrap();

            // instantiate a library dispatcher to perform the library call
            // to the RiscZero verifier class, given that verifying a proof is
            // a read-only operation
            let dispatcher = IRisc0Groth16VerifierBN254LibraryDispatcher { class_hash };

            // calls the RiscZero verifier passing along the proof artifact and
            // checks whether the proof is valid or not, aborting the transaction if not
            let optional_journal = dispatcher.verify_groth16_proof_bn254(full_proof_with_hints);
            assert(optional_journal != Option::None, 'Invalid proof');

            // parses the public inputs and output from the journal
            let mut journal = optional_journal.unwrap();
            let l = pop_front_u32_le(ref journal);
            let u = pop_front_u32_le(ref journal);
            let fib_n = pop_front_u32_le(ref journal);

            // performs the necessary state update check, updates the state,
            // and emits an event with the new fibnoacci number submitted
            // the smart contract invariant guarantees that every fiboacci number
            // accepted comes later in the fibonacci sequence without revealing
            // its index, which is trivial for monotonic sequences like fibnacci,
            // but would also work as expected also for non-monotonic ones
            let b = self.lower_bound.read();
            assert(l >= b, 'Invalid lower bound');
            self.lower_bound.write(u);
            self.emit(FibonnacciNumberSubmitted { n: fib_n });
            self.emit(LowerBoundUpdated { n: u });
        }
    }

    fn pop_front_u32_le(ref bytes: Span<u8>) -> u32 {
        let [b0, b1, b2, b3] = (*bytes.multi_pop_front::<4>().unwrap()).unbox();
        let b0: u32 = b0.into();
        let b1: u32 = b1.into();
        let b2: u32 = b2.into();
        let b3: u32 = b3.into();
        b0 + 256 * (b1 + 256 * (b2 + 256 * b3))
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        FibonnacciNumberSubmitted: FibonnacciNumberSubmitted,
        LowerBoundUpdated: LowerBoundUpdated,
    }

    #[derive(Drop, starknet::Event)]
    struct FibonnacciNumberSubmitted {
        #[key]
        n: u32,
    }

    #[derive(Drop, starknet::Event)]
    struct LowerBoundUpdated {
        #[key]
        n: u32,
    }

    #[starknet::interface]
    trait IRisc0Groth16VerifierBN254<TContractState> {
        fn verify_groth16_proof_bn254(
            self: @TContractState, full_proof_with_hints: Span<felt252>,
        ) -> Option<Span<u8>>;
    }
}
