use core::circuit::u384;
use core::num::traits::{One, Zero};
use garaga::circuits::multi_pairing_check::run_BN254_MP_CHECK_PREPARE_PAIRS_1P_circuit;
use garaga::circuits::tower_circuits as tw;
use garaga::definitions::curves::{BLS12_381_SEED_BITS, BN254_SEED_BITS_NAF, get_BLS12_381_modulus};
use garaga::definitions::{BNProcessedPair, E12T, G1Point, G2Point};
use garaga::ec::pairing::pairing_check::compute_yInvXnegOverY;


pub fn miller_loop_bn254_tower(P: G1Point, Q: G2Point) -> (E12T,) {
    let bits = BN254_SEED_BITS_NAF.span();

    let (processed_pair): (BNProcessedPair,) = run_BN254_MP_CHECK_PREPARE_PAIRS_1P_circuit(
        P, Q.y0, Q.y1,
    );

    let mut Mi: E12T = One::one();
    let mut Qi = Q;

    for bit in bits {
        let (_Qi, _Mi) = match *bit {
            0 => {
                tw::run_BN254_TOWER_MILLER_BIT0_1P_circuit(
                    processed_pair.yInv, processed_pair.xNegOverY, Qi, Mi,
                )
            },
            1 => {
                tw::run_BN254_TOWER_MILLER_BIT1_1P_circuit(
                    processed_pair.yInv, processed_pair.xNegOverY, Qi, Q, Mi,
                )
            },
            _ => {
                tw::run_BN254_TOWER_MILLER_BIT1_1P_circuit(
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
    }

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
    }
    // Step 18
    let (t5) = tw::run_BN254_E12T_MUL_circuit(t5, t6);
    // Step 19
    let (mut t5) = tw::run_BN254_E12T_MUL_circuit(t4, t5);
    // Step 26
    for _ in 0..7_u8 {
        let (_t5) = tw::run_BN254_E12T_CYCLOTOMIC_SQUARE_circuit(t5);
        t5 = _t5;
    }
    // Step 27
    let (mut t4) = tw::run_BN254_E12T_MUL_circuit(t4, t5);
    // Step 35
    for _ in 0..8_u8 {
        let (_t4) = tw::run_BN254_E12T_CYCLOTOMIC_SQUARE_circuit(t4);
        t4 = _t4;
    }
    // Step 36
    let (t4) = tw::run_BN254_E12T_MUL_circuit(t0, t4);
    // Step 37
    let (mut t3) = tw::run_BN254_E12T_MUL_circuit(t3, t4);
    // Step 43
    for _ in 0..6_u8 {
        let (_t3) = tw::run_BN254_E12T_CYCLOTOMIC_SQUARE_circuit(t3);
        t3 = _t3;
    }
    // Step 44
    let (mut t2) = tw::run_BN254_E12T_MUL_circuit(t2, t3);
    // Step 52
    for _ in 0..8_u8 {
        let (_t2) = tw::run_BN254_E12T_CYCLOTOMIC_SQUARE_circuit(t2);
        t2 = _t2;
    }
    // Step 53
    let (mut t2) = tw::run_BN254_E12T_MUL_circuit(t0, t2);

    // Step 59
    for _ in 0..6_u8 {
        let (_t2) = tw::run_BN254_E12T_CYCLOTOMIC_SQUARE_circuit(t2);
        t2 = _t2;
    }

    // Step 60
    let (mut t2) = tw::run_BN254_E12T_MUL_circuit(t0, t2);
    // Step 70
    for _ in 0..10_u8 {
        let (_t2) = tw::run_BN254_E12T_CYCLOTOMIC_SQUARE_circuit(t2);
        t2 = _t2;
    }
    // Step 71
    let (mut t1) = tw::run_BN254_E12T_MUL_circuit(t1, t2);
    // Step 77
    for _ in 0..6_u8 {
        let (_t1) = tw::run_BN254_E12T_CYCLOTOMIC_SQUARE_circuit(t1);
        t1 = _t1;
    }
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

/// Dedicated structure for compressed elements in the cyclotomic subgroup G_phi ⊂ Fq^12
///
/// Background and intent (Observation 47):
/// - Elements in the cyclotomic subgroup admit the Karabina compression where two of the
///   Fp6 components (c0.b0 and c1.b1 in our tower representation) can be recovered from the
///   remaining ones. Squaring in this form is cheaper and is implemented by the circuit
///   `run_BLS12_381_E12T_CYCLO_SQUARE_COMPRESSED_circuit` that takes eight Fp limbs.
/// - We represent such compressed elements explicitly instead of overloading `E12T`.
///   This avoids confusing unused fields and makes the intent of “compressed cyclotomic
///   value” explicit at the type level.
///
/// Representation details:
/// - `E12T` is modeled as Fp12 via the tower (Fp2 → Fp6 → Fp12) with coordinates
///   `c{i}.b{j}.a{k}`. The compressed form stores exactly the eight limbs required by the
///   Karabina formulas: c0.b1, c0.b2, c1.b0 and c1.b2 (each over Fp2 → a0,a1).
/// - The fields `c0.b0` and `c1.b1` are intentionally absent; they are reconstructed during
///   decompression using `DECOMP_KARABINA_*` circuits.
/// - Validity invariant: values of this type must come from the cyclotomic subgroup; using
///   arbitrary Fp12 elements here is undefined.
///
/// Usage:
/// - Squaring: feed the eight limbs directly to
///   `run_BLS12_381_E12T_CYCLO_SQUARE_COMPRESSED_circuit`.
/// - Multiplication or any generic operation: first call
///   `decompress_karabina_bls12_381_compressed` to recover a full `E12T`.
/// - Zero-branch: when `c1b2 == 0`, decompression uses the cheaper "I_Z" path.
///
/// Security/correctness notes:
/// - Decompression returns `One` when the Karabina t1 component is zero, matching the
///   standard algorithmic edge case.
/// - The helper `to_compressed(E12T)` merely copies the eight required limbs; it does not
///   check subgroup membership.
#[derive(Copy, Drop, Debug, PartialEq)]
pub struct CompressedE12T {
    pub c0b1a0: u384,
    pub c0b1a1: u384,
    pub c0b2a0: u384,
    pub c0b2a1: u384,
    pub c1b0a0: u384,
    pub c1b0a1: u384,
    pub c1b2a0: u384,
    pub c1b2a1: u384,
}

/// Convert a full `E12T` (assumed in G_phi) into its Karabina compressed form by
/// extracting the eight required limbs (c0.b1, c0.b2, c1.b0, c1.b2).
#[inline]
fn to_compressed(X: E12T) -> (CompressedE12T,) {
    (
        CompressedE12T {
            c0b1a0: X.c0b1a0,
            c0b1a1: X.c0b1a1,
            c0b2a0: X.c0b2a0,
            c0b2a1: X.c0b2a1,
            c1b0a0: X.c1b0a0,
            c1b0a1: X.c1b0a1,
            c1b2a0: X.c1b2a0,
            c1b2a1: X.c1b2a1,
        },
    )
}

/// Decompress a Karabina-compressed cyclotomic element back to `E12T`.
///
/// The implementation mirrors the two-step Karabina decompression and branches between
/// the “I_Z” and “I_NZ” circuits depending on whether `c1b2 == 0`.
pub fn decompress_karabina_bls12_381_compressed(X: CompressedE12T) -> (E12T,) {
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

/// Apply `times` Karabina cyclotomic squarings on a value in the compressed domain and
/// return the decompressed `E12T`.
///
/// This keeps the element compressed between squarings (cheap), and only performs the
/// final decompression once at the end when a full `E12T` is needed for multiplication or
/// other generic operations.
fn cyclo_square_compressed_then_decompress_k(X: E12T, times: u32) -> (E12T,) {
    let (mut C) = to_compressed(X);
    for _ in 0..times {
        let (_c0b1a0, _c0b1a1, _c0b2a0, _c0b2a1, _c1b0a0, _c1b0a1, _c1b2a0, _c1b2a1) =
            tw::run_BLS12_381_E12T_CYCLO_SQUARE_COMPRESSED_circuit(
            C.c0b1a0, C.c0b1a1, C.c0b2a0, C.c0b2a1, C.c1b0a0, C.c1b0a1, C.c1b2a0, C.c1b2a1,
        );
        C =
            CompressedE12T {
                c0b1a0: _c0b1a0,
                c0b1a1: _c0b1a1,
                c0b2a0: _c0b2a0,
                c0b2a1: _c0b2a1,
                c1b0a0: _c1b0a0,
                c1b0a1: _c1b0a1,
                c1b2a0: _c1b2a0,
                c1b2a1: _c1b2a1,
            };
    }
    decompress_karabina_bls12_381_compressed(C)
}
pub fn expt_half_bls12_381_tower(M: E12T) -> (E12T,) {
    let (t0) = cyclo_square_compressed_then_decompress_k(M, 15_u32);
    let (t1) = cyclo_square_compressed_then_decompress_k(t0, 32_u32);

    let (mut result) = tw::run_BLS12_381_E12T_MUL_circuit(t0, t1);

    let (t1) = cyclo_square_compressed_then_decompress_k(t1, 9_u32);
    let (result) = tw::run_BLS12_381_E12T_MUL_circuit(result, t1);
    let (t1) = cyclo_square_compressed_then_decompress_k(t1, 3_u32);
    let (result) = tw::run_BLS12_381_E12T_MUL_circuit(result, t1);
    let (t1) = cyclo_square_compressed_then_decompress_k(t1, 2_u32);
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
    let bits = BLS12_381_SEED_BITS.span();
    let modulus = get_BLS12_381_modulus();
    let (yInv, xNegOverY) = compute_yInvXnegOverY(P.x, P.y, modulus);

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
    }

    return fp12_conjugate(Mi, 1);
}
