from starkware.cairo.common.cairo_builtins import UInt384
from src.precompiled_circuits.final_exp import BN254_final_exp, BLS12_381_final_exp

namespace bls {
    const CURVE_ID = 'bls12_381';
    const P0 = 0xb153ffffb9feffffffffaaab;
    const P1 = 0x6730d2a0f6b0f6241eabfffe;
    const P2 = 0x434bacd764774b84f38512bf;
    const P3 = 0x1a0111ea397fe69a4b1ba7b6;

    // The following constants represent the size of the curve:
    // const n = 0x73eda753299d7d483339d80809a1d80553bda402fffe5bfeffffffff00000001
    const N0 = 0x3e5bfeffffffff00000001;
    const N1 = 0x2020268760154ef6900bff;
    const N2 = 0x73eda753299d7d483339d;

    // Non residue constants:
    const NON_RESIDUE_E2_a0 = 1;
    const NON_RESIDUE_E2_a1 = 1;
}

namespace bn {
    const CURVE_ID = 'bn254';
    const P0 = 60193888514187762220203335;
    const P1 = 27625954992973055882053025;
    const P2 = 3656382694611191768777988;

    // The following constants represent the size of the curve:
    // n = n(u) = 36u^4 + 36u^3 + 18u^2 + 6u + 1
    // const n = 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001
    const N0 = 0x39709143e1f593f0000001;
    const N1 = 0x16da06056174a0cfa121e6;
    const N2 = 0x30644e72e131a029b8504;

    // Non residue constants:
    const NON_RESIDUE_E2_a0 = 9;
    const NON_RESIDUE_E2_a1 = 1;
}

func get_P(curve_id: felt) -> (prime: UInt384) {
    if (curve_id == bls.CURVE_ID) {
        return (UInt384(bls.P0, bls.P1, bls.P2, bls.P3),);
    } else {
        if (curve_id == bn.CURVE_ID) {
            return (UInt384(bn.P0, bn.P1, bn.P2, 0),);
        } else {
            return (UInt384(-1, 0, 0, 0),);
        }
    }
}

// func get_final_exp_circuit(curve_id: felt) -> (
//     constants_ptr: felt*,
//     add_offsets_ptr: felt*,
//     mul_offsets_ptr: felt*,
//     left_assert_eq_offsets_ptr: felt*,
//     right_assert_eq_offsets_ptr: felt*,
//     poseidon_indexes_ptr: felt*,
//     constants_ptr_len: felt,
//     add_mod_n: felt,
//     mul_mod_n: felt,
//     commitments_len: felt,
//     assert_eq_len: felt,
//     N_Euclidean_equations: felt,
// ) {
//     if (curve_id == bls.CURVE_ID) {
//         return (
//             cast(0, felt*),
//             cast(0, felt*),
//             cast(0, felt*),
//             cast(0, felt*),
//             cast(0, felt*),
//             cast(0, felt*),
//             0,
//             0,
//             0,
//             0,
//             0,
//             0,
//         );
//     } else {
//         if (curve_id == bn.CURVE_ID) {
//             return get_GaragaBN254FinalExp_non_interactive_circuit();
//         } else {
//             return (
//                 cast(0, felt*),
//                 cast(0, felt*),
//                 cast(0, felt*),
//                 cast(0, felt*),
//                 cast(0, felt*),
//                 cast(0, felt*),
//                 0,
//                 0,
//                 0,
//                 0,
//                 0,
//                 0,
//             );
//         }
//     }
// }

// Base for UInt384 / BigInt4
const BASE = 2 ** 96;
const N_LIMBS = 4;

const STARK_MIN_ONE_D2 = 576460752303423505;

struct E6D {
    w0: UInt384,
    w1: UInt384,
    w2: UInt384,
    w3: UInt384,
    w4: UInt384,
    w5: UInt384,
}

struct E12D {
    w0: UInt384,
    w1: UInt384,
    w2: UInt384,
    w3: UInt384,
    w4: UInt384,
    w5: UInt384,
    w6: UInt384,
    w7: UInt384,
    w8: UInt384,
    w9: UInt384,
    w10: UInt384,
    w11: UInt384,
}

struct ExtFCircuitInfo {
    constants_ptr: felt*,
    constants_ptr_len: felt,
    add_offsets: felt*,
    mul_offsets: felt*,
    commitments_len: felt,
    transcript_indexes: felt*,
    N_Euclidean_equations: felt,
}

func zero_E12D() -> E12D {
    let res = E12D(
        UInt384(0, 0, 0, 0),
        UInt384(0, 0, 0, 0),
        UInt384(0, 0, 0, 0),
        UInt384(0, 0, 0, 0),
        UInt384(0, 0, 0, 0),
        UInt384(0, 0, 0, 0),
        UInt384(0, 0, 0, 0),
        UInt384(0, 0, 0, 0),
        UInt384(0, 0, 0, 0),
        UInt384(0, 0, 0, 0),
        UInt384(0, 0, 0, 0),
        UInt384(0, 0, 0, 0),
    );
    return res;
}

func one_E12D() -> E12D {
    let res = E12D(
        UInt384(0, 0, 0, 0),
        UInt384(1, 0, 0, 0),
        UInt384(0, 0, 0, 0),
        UInt384(0, 0, 0, 0),
        UInt384(0, 0, 0, 0),
        UInt384(0, 0, 0, 0),
        UInt384(0, 0, 0, 0),
        UInt384(0, 0, 0, 0),
        UInt384(0, 0, 0, 0),
        UInt384(0, 0, 0, 0),
        UInt384(0, 0, 0, 0),
        UInt384(0, 0, 0, 0),
    );
    return res;
}
