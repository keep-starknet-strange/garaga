use garaga::definitions::{u384};
use core::num::traits::{One, Zero};
use garaga::definitions::{G1Point, G2Point, BNProcessedPair, E12T};
use garaga::circuits::multi_pairing_check::{
    run_BN254_MP_CHECK_PREPARE_PAIRS_1P_circuit, run_BLS12_381_MP_CHECK_PREPARE_PAIRS_1P_circuit,
};

use garaga::circuits::tower_circuits as tw;
use garaga::circuits::tower_circuits::{
    run_BN254_TOWER_MILLER_BIT0_1P_circuit, run_BN254_TOWER_MILLER_BIT1_1P_circuit,
    run_BLS12_381_TOWER_MILLER_BIT0_1P_circuit, run_BLS12_381_TOWER_MILLER_BIT1_1P_circuit,
};
use garaga::basic_field_ops::{compute_yInvXnegOverY_BLS12_381, compute_yInvXnegOverY_BN254};
use garaga::ec_ops_g2::G2PointTrait;


impl E12TOne of One<E12T> {
    fn one() -> E12T {
        E12T {
            c0b0a0: One::one(),
            c0b0a1: Zero::zero(),
            c0b1a0: Zero::zero(),
            c0b1a1: Zero::zero(),
            c0b2a0: Zero::zero(),
            c0b2a1: Zero::zero(),
            c1b0a0: Zero::zero(),
            c1b0a1: Zero::zero(),
            c1b1a0: Zero::zero(),
            c1b1a1: Zero::zero(),
            c1b2a0: Zero::zero(),
            c1b2a1: Zero::zero(),
        }
    }
    fn is_one(self: @E12T) -> bool {
        *self == Self::one()
    }
    fn is_non_one(self: @E12T) -> bool {
        !Self::is_one(self)
    }
}

pub fn miller_loop_bn254_tower(P: G1Point, Q: G2Point) -> (E12T,) {
    let bits = bn_bits.span();

    let (processed_pair): (BNProcessedPair,) = run_BN254_MP_CHECK_PREPARE_PAIRS_1P_circuit(
        P, Q.y0, Q.y1,
    );

    let mut Mi: E12T = E12TOne::one();
    let mut Qi = Q;

    for bit in bits {
        let (_Qi, _Mi) = match *bit {
            0 => {
                run_BN254_TOWER_MILLER_BIT0_1P_circuit(
                    processed_pair.yInv, processed_pair.xNegOverY, Qi, Mi,
                )
            },
            1 => {
                run_BN254_TOWER_MILLER_BIT1_1P_circuit(
                    processed_pair.yInv, processed_pair.xNegOverY, Qi, Q, Mi,
                )
            },
            _ => {
                run_BN254_TOWER_MILLER_BIT1_1P_circuit(
                    processed_pair.yInv,
                    processed_pair.xNegOverY,
                    Qi,
                    G2Point {
                        x0: Q.x0, x1: Q.x1, y0: processed_pair.QyNeg0, y1: processed_pair.QyNeg1,
                    },
                    Mi,
                )
            },
        };
        Qi = _Qi;
        Mi = _Mi;
    };

    tw::run_BN254_TOWER_MILLER_FINALIZE_BN_1P_circuit(
        Q, processed_pair.yInv, processed_pair.xNegOverY, Qi, Mi,
    )
}

pub fn expt_bn254_tower(X: E12T) -> (E12T,) {
    // Step 1
    let (t3) = tw::run_BN254_E12T_CYCLOTOMIC_SQUARE_circuit(X);
    // Step 2
    let (t5) = tw::run_BN254_E12T_CYCLOTOMIC_SQUARE_circuit(t3);
    // Step 3
    let (result) = tw::run_BN254_E12T_CYCLOTOMIC_SQUARE_circuit(t5);
    // Step 4
    let (t0) = tw::run_BN254_E12T_CYCLOTOMIC_SQUARE_circuit(result);
    // Step 5
    let (t2) = tw::run_BN254_E12T_MUL_circuit(X, t0);
    // Step 6
    let (t0) = tw::run_BN254_E12T_MUL_circuit(t3, t2);
    // Step 7
    let (t1) = tw::run_BN254_E12T_MUL_circuit(X, t0);
    // Step 8
    let (t4) = tw::run_BN254_E12T_MUL_circuit(result, t2);
    // Step 9
    let (t6) = tw::run_BN254_E12T_CYCLOTOMIC_SQUARE_circuit(t2);
    // Step 10
    let (t1) = tw::run_BN254_E12T_MUL_circuit(t0, t1);
    // Step 11
    let (t0) = tw::run_BN254_E12T_MUL_circuit(t3, t1);
    // Step 17
    let mut t6 = t6;
    for _ in 0..6_u8 {
        let (_t6) = tw::run_BN254_E12T_CYCLOTOMIC_SQUARE_circuit(t6);
        t6 = _t6;
    };
    // Step 18
    let (t5) = tw::run_BN254_E12T_MUL_circuit(t5, t6);
    // Step 19
    let (mut t5) = tw::run_BN254_E12T_MUL_circuit(t4, t5);
    // Step 26
    for _ in 0..7_u8 {
        let (_t5) = tw::run_BN254_E12T_CYCLOTOMIC_SQUARE_circuit(t5);
        t5 = _t5;
    };
    // Step 27
    let (mut t4) = tw::run_BN254_E12T_MUL_circuit(t4, t5);
    // Step 35
    for _ in 0..8_u8 {
        let (_t4) = tw::run_BN254_E12T_CYCLOTOMIC_SQUARE_circuit(t4);
        t4 = _t4;
    };
    // Step 36
    let (t4) = tw::run_BN254_E12T_MUL_circuit(t0, t4);
    // Step 37
    let (mut t3) = tw::run_BN254_E12T_MUL_circuit(t3, t4);
    // Step 43
    for _ in 0..6_u8 {
        let (_t3) = tw::run_BN254_E12T_CYCLOTOMIC_SQUARE_circuit(t3);
        t3 = _t3;
    };
    // Step 44
    let (mut t2) = tw::run_BN254_E12T_MUL_circuit(t2, t3);
    // Step 52
    for _ in 0..8_u8 {
        let (_t2) = tw::run_BN254_E12T_CYCLOTOMIC_SQUARE_circuit(t2);
        t2 = _t2;
    };
    // Step 53
    let (mut t2) = tw::run_BN254_E12T_MUL_circuit(t0, t2);

    // Step 59
    for _ in 0..6_u8 {
        let (_t2) = tw::run_BN254_E12T_CYCLOTOMIC_SQUARE_circuit(t2);
        t2 = _t2;
    };

    // Step 60
    let (mut t2) = tw::run_BN254_E12T_MUL_circuit(t0, t2);
    // Step 70
    for _ in 0..10_u8 {
        let (_t2) = tw::run_BN254_E12T_CYCLOTOMIC_SQUARE_circuit(t2);
        t2 = _t2;
    };
    // Step 71
    let (mut t1) = tw::run_BN254_E12T_MUL_circuit(t1, t2);
    // Step 77
    for _ in 0..6_u8 {
        let (_t1) = tw::run_BN254_E12T_CYCLOTOMIC_SQUARE_circuit(t1);
        t1 = _t1;
    };
    // Step 78
    let (t0) = tw::run_BN254_E12T_MUL_circuit(t0, t1);
    // Step 79
    let (result) = tw::run_BN254_E12T_MUL_circuit(result, t0);

    return (result,);
}

pub fn final_exp_bn254_tower(M: E12T) -> E12T {
    let curve_id = 0;
    let (t0) = fp12_conjugate(M, curve_id);
    let (result) = tw::run_BN254_E12T_INVERSE_circuit(M);
    let (t0) = tw::run_BN254_E12T_MUL_circuit(t0, result);
    let (result) = tw::run_BN254_E12T_FROBENIUS_SQUARE_circuit(t0);
    let (result) = tw::run_BN254_E12T_MUL_circuit(result, t0);

    // Hard part
    let (t0) = expt_bn254_tower(result);
    let (t0) = fp12_conjugate(t0, curve_id);
    let (t0) = tw::run_BN254_E12T_CYCLOTOMIC_SQUARE_circuit(t0);
    let (t1) = tw::run_BN254_E12T_CYCLOTOMIC_SQUARE_circuit(t0);
    let (t1) = tw::run_BN254_E12T_MUL_circuit(t0, t1);
    let (t2) = expt_bn254_tower(t1);
    let (t2) = fp12_conjugate(t2, curve_id);
    let (t3) = fp12_conjugate(t1, curve_id);
    let (t1) = tw::run_BN254_E12T_MUL_circuit(t2, t3);
    let (t3) = tw::run_BN254_E12T_CYCLOTOMIC_SQUARE_circuit(t2);
    let (t4) = expt_bn254_tower(t3);
    let (t4) = tw::run_BN254_E12T_MUL_circuit(t1, t4);
    let (t3) = tw::run_BN254_E12T_MUL_circuit(t0, t4);
    let (t0) = tw::run_BN254_E12T_MUL_circuit(t2, t4);
    let (t0) = tw::run_BN254_E12T_MUL_circuit(result, t0);
    let (t2) = tw::run_BN254_E12T_FROBENIUS_circuit(t3);
    let (t0) = tw::run_BN254_E12T_MUL_circuit(t2, t0);
    let (t2) = tw::run_BN254_E12T_FROBENIUS_SQUARE_circuit(t4);
    let (t0) = tw::run_BN254_E12T_MUL_circuit(t2, t0);
    let (t2) = fp12_conjugate(result, curve_id);
    let (t2) = tw::run_BN254_E12T_MUL_circuit(t2, t3);
    let (t2) = tw::run_BN254_E12T_FROBENIUS_CUBE_circuit(t2);
    let (result) = tw::run_BN254_E12T_MUL_circuit(t2, t0);

    result
}

#[inline]
pub fn fp12_conjugate(X: E12T, curve_id: usize) -> (E12T,) {
    let (b0a0, b0a1, b1a0, b1a1, b2a0, b2a1) = tw::run_FP6_NEG_circuit(
        X.c1b0a0, X.c1b0a1, X.c1b1a0, X.c1b1a1, X.c1b2a0, X.c1b2a1, curve_id,
    );
    (
        E12T {
            c0b0a0: X.c0b0a0,
            c0b0a1: X.c0b0a1,
            c0b1a0: X.c0b1a0,
            c0b1a1: X.c0b1a1,
            c0b2a0: X.c0b2a0,
            c0b2a1: X.c0b2a1,
            c1b0a0: b0a0,
            c1b0a1: b0a1,
            c1b1a0: b1a0,
            c1b1a1: b1a1,
            c1b2a0: b2a0,
            c1b2a1: b2a1,
        },
    )
}

pub fn final_exp_bls12_381_tower(M: E12T) -> E12T {
    let result = M;
    let (t0) = fp12_conjugate(M, 1);
    let (result) = tw::run_BLS12_381_E12T_INVERSE_circuit(result);
    let (t0) = tw::run_BLS12_381_E12T_MUL_circuit(t0, result);
    let (result) = tw::run_BLS12_381_E12T_FROBENIUS_SQUARE_circuit(t0);
    let (result) = tw::run_BLS12_381_E12T_MUL_circuit(result, t0);

    let (t0) = tw::run_BLS12_381_E12T_CYCLOTOMIC_SQUARE_circuit(result);
    let (t1) = expt_half_bls12_381_tower(t0);
    let (t2) = fp12_conjugate(result, 1);
    let (t1) = tw::run_BLS12_381_E12T_MUL_circuit(t1, t2);
    let (t2) = expt_bls12_381_tower(t1);
    let (t1) = fp12_conjugate(t1, 1);
    let (t1) = tw::run_BLS12_381_E12T_MUL_circuit(t1, t2);
    let (t2) = expt_bls12_381_tower(t1);
    let (t1) = tw::run_BLS12_381_E12T_FROBENIUS_circuit(t1);
    let (t1) = tw::run_BLS12_381_E12T_MUL_circuit(t1, t2);
    let (result) = tw::run_BLS12_381_E12T_MUL_circuit(result, t0);
    let (t0) = expt_bls12_381_tower(t1);
    let (t2) = expt_bls12_381_tower(t0);
    let (t0) = tw::run_BLS12_381_E12T_FROBENIUS_SQUARE_circuit(t1);
    let (t1) = fp12_conjugate(t1, 1);
    let (t1) = tw::run_BLS12_381_E12T_MUL_circuit(t1, t2);
    let (t1) = tw::run_BLS12_381_E12T_MUL_circuit(t1, t0);
    let (result) = tw::run_BLS12_381_E12T_MUL_circuit(result, t1);
    result
}

pub fn decompress_karabina_bls12_381(X: E12T) -> (E12T,) {
    let (t0a0, t0a1, t1a0, t1a1) = match (X.c1b2a0.is_zero() && X.c1b2a1.is_zero()) {
        true => {
            let (t0a0, t0a1) = tw::run_BLS12_381_E12T_DECOMP_KARABINA_I_Z_circuit(
                X.c0b1a0, X.c0b1a1, X.c1b2a0, X.c1b2a1,
            );
            (t0a0, t0a1, X.c0b2a0, X.c0b2a1)
        },
        false => {
            tw::run_BLS12_381_E12T_DECOMP_KARABINA_I_NZ_circuit(
                X.c0b1a0, X.c0b1a1, X.c0b2a0, X.c0b2a1, X.c1b0a0, X.c1b0a1, X.c1b2a0, X.c1b2a1,
            )
        },
    };

    if t1a0.is_zero() && t1a1.is_zero() {
        return (One::one(),);
    }

    let (zc0b0a0, zc0b0a1, zc1b1a0, zc1b1a1) = tw::run_BLS12_381_E12T_DECOMP_KARABINA_II_circuit(
        t0a0,
        t0a1,
        t1a0,
        t1a1,
        X.c0b1a0,
        X.c0b1a1,
        X.c0b2a0,
        X.c0b2a1,
        X.c1b0a0,
        X.c1b0a1,
        X.c1b2a0,
        X.c1b2a1,
    );

    (
        E12T {
            c0b0a0: zc0b0a0,
            c0b0a1: zc0b0a1,
            c0b1a0: X.c0b1a0,
            c0b1a1: X.c0b1a1,
            c0b2a0: X.c0b2a0,
            c0b2a1: X.c0b2a1,
            c1b0a0: X.c1b0a0,
            c1b0a1: X.c1b0a1,
            c1b1a0: zc1b1a0,
            c1b1a1: zc1b1a1,
            c1b2a0: X.c1b2a0,
            c1b2a1: X.c1b2a1,
        },
    )
}
pub fn expt_half_bls12_381_tower(M: E12T) -> (E12T,) {
    let (
        mut xc0b1a0,
        mut xc0b1a1,
        mut xc0b2a0,
        mut xc0b2a1,
        mut xc1b0a0,
        mut xc1b0a1,
        mut xc1b2a0,
        mut xc1b2a1,
    ) =
        (
        M.c0b1a0, M.c0b1a1, M.c0b2a0, M.c0b2a1, M.c1b0a0, M.c1b0a1, M.c1b2a0, M.c1b2a1,
    );
    for _ in 0..15_u32 {
        let (_xc0b1a0, _xc0b1a1, _xc0b2a0, _xc0b2a1, _xc1b0a0, _xc1b0a1, _xc1b2a0, _xc1b2a1) =
            tw::run_BLS12_381_E12T_CYCLO_SQUARE_COMPRESSED_circuit(
            xc0b1a0, xc0b1a1, xc0b2a0, xc0b2a1, xc1b0a0, xc1b0a1, xc1b2a0, xc1b2a1,
        );
        xc0b1a0 = _xc0b1a0;
        xc0b1a1 = _xc0b1a1;
        xc0b2a0 = _xc0b2a0;
        xc0b2a1 = _xc0b2a1;
        xc1b0a0 = _xc1b0a0;
        xc1b0a1 = _xc1b0a1;
        xc1b2a0 = _xc1b2a0;
        xc1b2a1 = _xc1b2a1;
    };

    let t0c0b1a0 = xc0b1a0;
    let t0c0b1a1 = xc0b1a1;
    let t0c0b2a0 = xc0b2a0;
    let t0c0b2a1 = xc0b2a1;
    let t0c1b0a0 = xc1b0a0;
    let t0c1b0a1 = xc1b0a1;
    let t0c1b2a0 = xc1b2a0;
    let t0c1b2a1 = xc1b2a1;

    let (
        mut xc0b1a0,
        mut xc0b1a1,
        mut xc0b2a0,
        mut xc0b2a1,
        mut xc1b0a0,
        mut xc1b0a1,
        mut xc1b2a0,
        mut xc1b2a1,
    ) =
        (
        xc0b1a0, xc0b1a1, xc0b2a0, xc0b2a1, xc1b0a0, xc1b0a1, xc1b2a0, xc1b2a1,
    );
    for _ in 0..32_u32 {
        let (_xc0b1a0, _xc0b1a1, _xc0b2a0, _xc0b2a1, _xc1b0a0, _xc1b0a1, _xc1b2a0, _xc1b2a1) =
            tw::run_BLS12_381_E12T_CYCLO_SQUARE_COMPRESSED_circuit(
            xc0b1a0, xc0b1a1, xc0b2a0, xc0b2a1, xc1b0a0, xc1b0a1, xc1b2a0, xc1b2a1,
        );
        xc0b1a0 = _xc0b1a0;
        xc0b1a1 = _xc0b1a1;
        xc0b2a0 = _xc0b2a0;
        xc0b2a1 = _xc0b2a1;
        xc1b0a0 = _xc1b0a0;
        xc1b0a1 = _xc1b0a1;
        xc1b2a0 = _xc1b2a0;
        xc1b2a1 = _xc1b2a1;
    };

    let (t0) = decompress_karabina_bls12_381(
        E12T {
            c0b0a0: M.c0b0a0,
            c0b0a1: M.c0b0a1,
            c0b1a0: t0c0b1a0,
            c0b1a1: t0c0b1a1,
            c0b2a0: t0c0b2a0,
            c0b2a1: t0c0b2a1,
            c1b0a0: t0c1b0a0,
            c1b0a1: t0c1b0a1,
            c1b1a0: M.c1b1a0,
            c1b1a1: M.c1b1a1,
            c1b2a0: t0c1b2a0,
            c1b2a1: t0c1b2a1,
        },
    );

    let (mut t1) = decompress_karabina_bls12_381(
        E12T {
            c0b0a0: M.c0b0a0,
            c0b0a1: M.c0b0a1,
            c0b1a0: xc0b1a0,
            c0b1a1: xc0b1a1,
            c0b2a0: xc0b2a0,
            c0b2a1: xc0b2a1,
            c1b0a0: xc1b0a0,
            c1b0a1: xc1b0a1,
            c1b1a0: M.c1b1a0,
            c1b1a1: M.c1b1a1,
            c1b2a0: xc1b2a0,
            c1b2a1: xc1b2a1,
        },
    );

    let (mut result) = tw::run_BLS12_381_E12T_MUL_circuit(t0, t1);

    for _ in 0..9_u32 {
        let (_t1) = tw::run_BLS12_381_E12T_CYCLOTOMIC_SQUARE_circuit(t1);
        t1 = _t1;
    };
    let (result) = tw::run_BLS12_381_E12T_MUL_circuit(result, t1);
    for _ in 0..3_u32 {
        let (_t1) = tw::run_BLS12_381_E12T_CYCLOTOMIC_SQUARE_circuit(t1);
        t1 = _t1;
    };
    let (result) = tw::run_BLS12_381_E12T_MUL_circuit(result, t1);
    // 2 sq
    let (t1) = tw::run_BLS12_381_E12T_CYCLOTOMIC_SQUARE_circuit(t1);
    let (t1) = tw::run_BLS12_381_E12T_CYCLOTOMIC_SQUARE_circuit(t1);
    let (result) = tw::run_BLS12_381_E12T_MUL_circuit(result, t1);
    let (t1) = tw::run_BLS12_381_E12T_CYCLOTOMIC_SQUARE_circuit(t1);
    let (result) = tw::run_BLS12_381_E12T_MUL_circuit(result, t1);
    let (result) = fp12_conjugate(result, 1);
    (result,)
}

pub fn expt_bls12_381_tower(M: E12T) -> (E12T,) {
    let (t0) = expt_half_bls12_381_tower(M);
    return tw::run_BLS12_381_E12T_CYCLOTOMIC_SQUARE_circuit(t0);
}

pub fn miller_loop_bls12_381_tower(P: G1Point, Q: G2Point) -> (E12T,) {
    let bits = bls_bits.span();

    let (yInv, xNegOverY) = compute_yInvXnegOverY_BLS12_381(P.x, P.y);

    let (TripleQ, c0b0a0, c0b0a1, c0b1a0, c0b1a1, c0b2a0, c0b2a1, c1b1a0, c1b1a1, c1b2a0, c1b2a1) =
        tw::run_BLS12_381_TOWER_MILLER_INIT_BIT_1P_circuit(
        yInv, xNegOverY, Q,
    );

    let mut Mi: E12T = E12T {
        c0b0a0: c0b0a0,
        c0b0a1: c0b0a1,
        c0b1a0: c0b1a0,
        c0b1a1: c0b1a1,
        c0b2a0: c0b2a0,
        c0b2a1: c0b2a1,
        c1b0a0: Zero::zero(),
        c1b0a1: Zero::zero(),
        c1b1a0: c1b1a0,
        c1b1a1: c1b1a1,
        c1b2a0: c1b2a0,
        c1b2a1: c1b2a1,
    };

    let mut Qi = TripleQ;
    for bit in bits {
        let (_Qi, _Mi) = match *bit {
            0 => { tw::run_BLS12_381_TOWER_MILLER_BIT0_1P_circuit(yInv, xNegOverY, Qi, Mi) },
            _ => { tw::run_BLS12_381_TOWER_MILLER_BIT1_1P_circuit(yInv, xNegOverY, Qi, Q, Mi) },
        };
        Qi = _Qi;
        Mi = _Mi;
    };

    return fp12_conjugate(Mi, 1);
}


pub const bn_bits: [usize; 65] = [
    0, 2, 0, 1, 0, 0, 0, 2, 0, 2, 0, 0, 0, 2, 0, 0, 1, 1, 0, 0, 2, 0, 0, 0, 0, 0, 1, 0, 0, 2, 0, 1,
    0, 0, 2, 0, 0, 0, 0, 2, 0, 1, 0, 0, 0, 2, 0, 2, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 2, 0, 2, 2, 0, 0,
    0,
];

pub const bls_bits: [usize; 62] = [
    0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
];
