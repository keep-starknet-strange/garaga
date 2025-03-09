#[starknet::interface]
pub trait IMutatorSetContract<TContractState> {
    fn get_n_leaves_aocl(self: @TContractState) -> u64;
    fn get_n_peaks_aocl(self: @TContractState) -> u64;
    fn append_leaf_aocl(ref self: TContractState, leaf: u256);
    fn get_peaks_aocl(self: @TContractState) -> Array<u256>;
}

#[starknet::contract]
mod MutatorSetContract {
    use core::starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use core::starknet::storage::{Vec, VecTrait, MutableVecTrait};
    use garaga::crypto::mmr::trailing_ones;
    use garaga::hashes::poseidon_hash_2_bn254;
    use garaga::definitions::u384;

    #[storage]
    struct Storage {
        n_leaves_aocl: u64,
        peaks_aocl: Vec<u256>,
        last_peak_index_aocl: u64,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.peaks_aocl.append().write(0);
        self.n_leaves_aocl.write(1);
        self.last_peak_index_aocl.write(0);
    }

    fn hash_2(x: u256, y: u256) -> u256 {
        let x_u384: u384 = x.into();
        let y_u384: u384 = y.into();
        poseidon_hash_2_bn254(x_u384, y_u384).try_into().unwrap()
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
            };
            peaks
        }
        fn get_n_peaks_aocl(self: @ContractState) -> u64 {
            self.last_peak_index_aocl.read() + 1
        }

        fn append_leaf_aocl(ref self: ContractState, leaf: u256) {
            // TODO : assert leaf is reduced mod bn254 scalar field
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
                            self.peaks_aocl.append().write(leaf);
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
                    // last_peak_idx -= 1;
                    for _ in 0..n_parents - 1 {
                        let in_progress_peak = self.peaks_aocl.get(last_peak_idx).unwrap().read();
                        let previous_peak = self.peaks_aocl.get(last_peak_idx - 1).unwrap().read();

                        let parent: u256 = hash_2(previous_peak, in_progress_peak);
                        last_peak_idx -= 1;
                        let mut last_peak_ptr = self.peaks_aocl.get(last_peak_idx).unwrap();
                        last_peak_ptr.write(parent);
                    };
                    self.last_peak_index_aocl.write(last_peak_idx);
                },
            };
            self.n_leaves_aocl.write(n_leaves + 1);
        }
    }
}
