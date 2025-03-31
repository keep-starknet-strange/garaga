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
    use garaga::definitions::u384;
    use garaga::hashes::poseidon_hash_2_bn254;
    use mutator_set::VERIFIER_CLASS_HASH;
    use starknet::SyscallResultTrait;
    use starknet::storage::{
        MutableVecTrait, StoragePointerReadAccess, StoragePointerWriteAccess, Vec, VecTrait,
    };
    const BN254_CURVE_ORDER: u256 = u256 {
        low: 0x2833e84879b9709143e1f593f0000001, high: 0x30644e72e131a029b85045b68181585d,
    };
    #[storage]
    struct Storage {
        n_leaves_aocl: u64,
        peaks_aocl: Vec<u256>,
        last_peak_index_aocl: u64,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.peaks_aocl.push(0);
        self.n_leaves_aocl.write(1);
        self.last_peak_index_aocl.write(0);
    }

    fn hash_2(x: u256, y: u256) -> u256 {
        let x_u384: u384 = x.into();
        let y_u384: u384 = y.into();
        poseidon_hash_2_bn254(x_u384, y_u384).try_into().unwrap()
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
            self.n_leaves_aocl.read()
        }
        fn get_peaks_aocl(self: @ContractState) -> Array<u256> {
            let n_peaks = self.last_peak_index_aocl.read() + 1;
            let mut peaks = array![];

            for i in 0..n_peaks {
                peaks.append(self.peaks_aocl.get(i).expect('Invalid peak index').read());
            }
            peaks
        }
        fn get_n_peaks_aocl(self: @ContractState) -> u64 {
            self.last_peak_index_aocl.read() + 1
        }

        fn append_leaf_aocl(ref self: ContractState, leaf: u256) {
            assert(leaf < BN254_CURVE_ORDER, 'Invalid leaf value');
            let n_leaves = self.n_leaves_aocl.read();
            let n_parents = trailing_ones(n_leaves);
            let mut last_peak_idx = self.last_peak_index_aocl.read();

            match n_parents {
                0 => {
                    let peaks_vec_last_idx = self.peaks_aocl.len() - 1;
                    let new_peak_idx = last_peak_idx + 1;
                    match new_peak_idx <= peaks_vec_last_idx {
                        true => {
                            self.peaks_aocl.get(new_peak_idx).unwrap().write(leaf);
                            self.last_peak_index_aocl.write(new_peak_idx);
                        },
                        false => {
                            self.peaks_aocl.push(leaf);
                            self.last_peak_index_aocl.write(new_peak_idx);
                        },
                    }
                },
                1 => {
                    let mut last_peak_ptr = self
                        .peaks_aocl
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
                        .peaks_aocl
                        .get(last_peak_idx)
                        .expect('Invalid last peak index');
                    let last_peak: u256 = last_peak_ptr.read();
                    let parent: u256 = hash_2(last_peak, leaf);

                    last_peak_ptr.write(parent);
                    for _ in 0..n_parents - 1 {
                        let in_progress_peak = self.peaks_aocl.get(last_peak_idx).unwrap().read();
                        let previous_peak = self.peaks_aocl.get(last_peak_idx - 1).unwrap().read();

                        let parent: u256 = hash_2(previous_peak, in_progress_peak);
                        last_peak_idx -= 1;
                        let mut last_peak_ptr = self.peaks_aocl.get(last_peak_idx).unwrap();
                        last_peak_ptr.write(parent);
                    }
                    self.last_peak_index_aocl.write(last_peak_idx);
                },
            }
            let new_n_leaves = n_leaves + 1;
            self.n_leaves_aocl.write(new_n_leaves);
            self.emit(LeafAppended {
                leaf: leaf,
                n_leaves: new_n_leaves,
            });
        }

        fn verify_inclusion_proof_aocl(
            ref self: ContractState, full_proof_with_hints: Span<felt252>,
        ) -> bool {
            let mut res = starknet::syscalls::library_call_syscall(
                VERIFIER_CLASS_HASH.try_into().unwrap(), selector!("verify_ultra_keccak_zk_honk_proof"), full_proof_with_hints,
            )
                .unwrap_syscall();

            Serde::<bool>::deserialize(ref res).unwrap()
        }
    }
}
