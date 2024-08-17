// use garaga::definitions::{u384, u96, G1Point};

// #[starknet::interface]
// trait IGaraga<TContractState> {
//     fn get_p(self: @TContractState, curve_index: usize) -> (felt252, felt252, felt252, felt252);
//     fn ec_add_unchecked(self: @TContractState, curve_index: usize) -> felt252;
//     fn c1(self: @TContractState, curve_index: usize) -> felt252;
//     fn c2(self: @TContractState, curve_index: usize) -> felt252;
//     fn c3(self: @TContractState, curve_index: usize) -> felt252;
//     fn c4(self: @TContractState, curve_index: usize) -> felt252;
//     fn c5(self: @TContractState, curve_index: usize) -> felt252;
//     fn c6(self: @TContractState, curve_index: usize) -> felt252;
//     // fn c7(self: @TContractState, curve_index: usize) -> felt252;
// }

// #[starknet::contract]
// mod Garaga {
//     use core::array::ArrayTrait;
//     use garaga::definitions::{get_p, u384, G1Point, u96};
//     use garaga::ec_ops::{ec_add_unchecked2};
//     use garaga::circuits;
//     #[storage]
//     struct Storage {}

//     #[abi(embed_v0)]
//     impl IGaraga of super::IGaraga<ContractState> {
//         fn get_p(self: @ContractState, curve_index: usize) -> (felt252, felt252, felt252,
//         felt252) {
//             let p = get_p(curve_index);
//             return (p.limb0.into(), p.limb1.into(), p.limb2.into(), p.limb3.into());
//         }
//         fn ec_add_unchecked(self: @ContractState, curve_index: usize) -> felt252 {
//             let inputs = array![u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }];
//             let res = ec_add_unchecked2(inputs, curve_index);
//             return 0;
//         }
//         fn c1(self: @ContractState, curve_index: usize) -> felt252 {
//             let inputs = array![u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }];

//             let res = circuits::ec::get_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit(
//                 inputs, curve_index
//             );
//             return 0;
//         }
//         fn c2(self: @ContractState, curve_index: usize) -> felt252 {
//             let inputs = array![u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }];

//             let res = circuits::ec::get_DERIVE_POINT_FROM_X_circuit(inputs, curve_index);
//             return 0;
//         }
//         fn c3(self: @ContractState, curve_index: usize) -> felt252 {
//             let inputs = array![u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }];

//             let res = circuits::ec::get_DOUBLE_EC_POINT_circuit(inputs, curve_index);
//             return 0;
//         }
//         fn c4(self: @ContractState, curve_index: usize) -> felt252 {
//             let inputs = array![u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }];

//             let res = circuits::ec::get_IS_ON_CURVE_G1_circuit(inputs, curve_index);
//             return 0;
//         }
//         fn c5(self: @ContractState, curve_index: usize) -> felt252 {
//             let inputs = array![u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }];

//             let res = circuits::ec::get_IS_ON_CURVE_G1_G2_circuit(inputs, curve_index);
//             return 0;
//         }
//         fn c6(self: @ContractState, curve_index: usize) -> felt252 {
//             let inputs = array![u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }];

//             let res = circuits::ec::get_RHS_FINALIZE_ACC_circuit(inputs, curve_index);
//             return 0;
//         }
//         // fn c7(self: @ContractState, curve_index: usize) -> felt252 {
//     //     let inputs = array![u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }];

//         //     let res = circuits::ec::get_SLOPE_INTERCEPT_SAME_POINT_circuit(inputs,
//         curve_index);
//     //     return 0;
//     // }
//     }
// }

