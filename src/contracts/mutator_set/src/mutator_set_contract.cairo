use mutator_set::zk_verifier::honk_verifier_contract::IUltraKeccakZKHonkVerifier;

#[starknet::interface]
pub trait IMutatorSetContract<TContractState> {
    fn get_n_leaves_aocl(self: @TContractState) -> u64;
    fn get_n_peaks_aocl(self: @TContractState) -> u64;
    fn append_leaf_aocl(ref self: TContractState, leaf: u256);
    fn get_peaks_aocl(self: @TContractState) -> Array<u256>;
    fn verify_inclusion_proof_aocl(
        ref self: TContractState, full_proof_with_hints: Span<felt252>,
    ) -> bool;
}

#[starknet::contract]
mod MutatorSetContract {
    use garaga::crypto::mmr::trailing_ones;
    use garaga::hashes::poseidon_bn254::poseidon_hash_2 as hash_2;
    use mutator_set::VERIFIER_CLASS_HASH;
    use starknet::SyscallResultTrait;
    use starknet::storage::{
        MutableVecTrait, StoragePointerReadAccess, StoragePointerWriteAccess, Vec, VecTrait,
    };
    const BN254_CURVE_ORDER: u256 = u256 {
        low: 0x2833e84879b9709143e1f593f0000001, high: 0x30644e72e131a029b85045b68181585d,
    };
    const AOCL_INIT_VALUE: u256 = 0;
    // Append-only commitment list
    #[starknet::storage_node]
    struct AOCL {
        n_leaves: u64,
        peaks: Vec<u256>,
        last_peak_index: u64,
    }
    #[starknet::storage_node]
    struct AOCLState {
        n_leaves: u64,
        root: u256,
    }

    #[storage]
    struct Storage {
        aocl: AOCL,
        aocl_state: AOCL,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        // Init both AOCLs
        self.aocl.peaks.push(AOCL_INIT_VALUE);
        self.aocl.n_leaves.write(1);
        self.aocl.last_peak_index.write(0);

        self.aocl_state.peaks.push(AOCL_INIT_VALUE);
        self.aocl_state.n_leaves.write(1);
        self.aocl_state.last_peak_index.write(0);
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        LeafAppended: LeafAppended,
    }

    #[derive(Drop, starknet::Event)]
    struct LeafAppended {
        leaf: u256,
        n_leaves: u64,
    }

    #[abi(embed_v0)]
    impl MutatorSetContractImpl of super::IMutatorSetContract<ContractState> {
        fn get_n_leaves_aocl(self: @ContractState) -> u64 {
            self.aocl.n_leaves.read()
        }
        fn get_peaks_aocl(self: @ContractState) -> Array<u256> {
            let n_peaks = self.aocl.last_peak_index.read() + 1;
            let mut peaks = array![];

            for i in 0..n_peaks {
                peaks.append(self.aocl.peaks.get(i).expect('Invalid peak index').read());
            }
            peaks
        }
        fn get_n_peaks_aocl(self: @ContractState) -> u64 {
            self.aocl.last_peak_index.read() + 1
        }

        fn append_leaf_aocl(ref self: ContractState, leaf: u256) {
            assert(leaf < BN254_CURVE_ORDER, 'Invalid leaf value');
            let n_leaves = self.aocl.n_leaves.read();
            let n_parents = trailing_ones(n_leaves);
            let mut last_peak_idx = self.aocl.last_peak_index.read();

            match n_parents {
                0 => {
                    let peaks_vec_last_idx = self.aocl.peaks.len() - 1;
                    let new_peak_idx = last_peak_idx + 1;
                    match new_peak_idx <= peaks_vec_last_idx {
                        true => {
                            self.aocl.peaks.get(new_peak_idx).unwrap().write(leaf);
                            self.aocl.last_peak_index.write(new_peak_idx);
                        },
                        false => {
                            self.aocl.peaks.push(leaf);
                            self.aocl.last_peak_index.write(new_peak_idx);
                        },
                    }
                },
                1 => {
                    let mut last_peak_ptr = self
                        .aocl
                        .peaks
                        .get(last_peak_idx)
                        .expect('Invalid last peak index');
                    let last_peak = last_peak_ptr.read();
                    let parent: u256 = hash_2(last_peak, leaf);
                    last_peak_ptr.write(parent);
                    // No change on last_peak_idx. (It was a single leaf that got merged into a
                // peak)
                },
                _ => {
                    let mut last_peak_ptr = self
                        .aocl
                        .peaks
                        .get(last_peak_idx)
                        .expect('Invalid last peak index');
                    let last_peak: u256 = last_peak_ptr.read();
                    let parent: u256 = hash_2(last_peak, leaf);

                    last_peak_ptr.write(parent);
                    for _ in 0..n_parents - 1 {
                        let in_progress_peak = self.aocl.peaks.get(last_peak_idx).unwrap().read();
                        let previous_peak = self.aocl.peaks.get(last_peak_idx - 1).unwrap().read();

                        let parent: u256 = hash_2(previous_peak, in_progress_peak);
                        last_peak_idx -= 1;
                        let mut last_peak_ptr = self.aocl.peaks.get(last_peak_idx).unwrap();
                        last_peak_ptr.write(parent);
                    }
                    self.aocl.last_peak_index.write(last_peak_idx);
                },
            }
            let new_n_leaves = n_leaves + 1;
            self.aocl.n_leaves.write(new_n_leaves);
            self.emit(LeafAppended { leaf: leaf, n_leaves: new_n_leaves });
        }
        fn verify_inclusion_proof_aocl(
            ref self: ContractState, full_proof_with_hints: Span<felt252>,
        ) -> bool {
            let mut res = starknet::syscalls::library_call_syscall(
                VERIFIER_CLASS_HASH.try_into().unwrap(),
                selector!("verify_ultra_keccak_zk_honk_proof"),
                full_proof_with_hints,
            )
                .unwrap_syscall();

            Serde::<bool>::deserialize(ref res).unwrap()
        }
    }

    // Private function
    fn _update_aocl_state(
        ref self: ContractState, peaks: Array<u256>, n_leaves: u64, last_peak_index: u64,
    ) {
        // Copy the AOCL into the AOCL state
        for i in 0..peaks.len() {
            self.aocl_state.peaks.get(i.into()).unwrap().write(*peaks[i]);
        }
        self.aocl_state.n_leaves.write(n_leaves);
        self.aocl_state.last_peak_index.write(last_peak_index);
    }
}
