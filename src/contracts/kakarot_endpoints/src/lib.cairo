// use garaga::definitions::{u384, u96, G1Point, G2Point};

// // Unoptimized contract endpoints for Kakarot that doesn't require any hints.

// #[starknet::interface]
// trait IKakarotEndpoints<TContractState> {
//     fn ec_add(self: @TContractState, p: G1Point, q: G1Point) -> G1Point;
//     fn ec_mul(self: @TContractState, p: G1Point, scalar: u256) -> G1Point;
//     fn ec_pairing(self: @TContractState, p: Array<G1Point>, q: Array<G2Point>) -> bool;
// }


