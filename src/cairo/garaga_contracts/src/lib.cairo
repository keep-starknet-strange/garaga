use garaga::definitions::{u384, u96, G1Point};

#[starknet::interface]
trait IGaraga<TContractState> {
    fn get_p(self: @TContractState, curve_index: usize) -> (felt252, felt252, felt252, felt252);
    fn ec_add_unchecked(self: @TContractState, inputs: Array<u384>, curve_index: usize) -> G1Point;
}

#[starknet::contract]
mod Garaga {
    use core::array::ArrayTrait;
    use garaga::definitions::{get_p, u384, G1Point, u96};
    use garaga::ec_ops::{ec_add_unchecked2};
    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl IGaraga of super::IGaraga<ContractState> {
        fn get_p(self: @ContractState, curve_index: usize) -> (felt252, felt252, felt252, felt252) {
            let p = get_p(curve_index);
            return (p.limb0.into(), p.limb1.into(), p.limb2.into(), p.limb3.into());
        }
        fn ec_add_unchecked(
            self: @ContractState, inputs: Array<u384>, curve_index: usize
        ) -> G1Point {
            return ec_add_unchecked2(inputs, curve_index);
        }
    }
}
