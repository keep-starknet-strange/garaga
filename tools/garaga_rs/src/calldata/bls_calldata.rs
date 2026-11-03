//! Generic BLS12-381 (min-sig-size, drand DST) calldata builder.
//!
//! Mirrors `drand_calldata.rs` but lifts the drand-specific gates:
//!
//!   - the message digest is supplied directly (any 32-byte BE digest),
//!     not derived from a drand round number;
//!   - the G2 public key is supplied per call (BLS-compressed 96 bytes),
//!     not resolved from `DrandNetwork::Quicknet`;
//!   - the precomputed Miller-loop lines for the two G2 points
//!     (`G2_GEN` and `-pubkey`) are emitted into the calldata so the
//!     consumer contract does not need them as constants.
//!
//! Ciphersuite: `BLS_SIG_BLS12381G1_XMD:SHA-256_SSWU_RO_NUL_+`
//! (drand-quicknet, the only ciphersuite currently exposed by
//! `garaga::apps::drand::hash_to_curve_bls12_381`).
//!
//! Output shape (matches the Shhh V8 verifier's expected envelope and
//! the standard 2P_2F BLS verification calldata layout):
//!
//!   1. size:           u32 (1 felt)
//!   2. signature_g1:   G1Point Serde (8 felts)
//!   3. h2c_hint:       HashToCurveHint Serde (12 felts)
//!   4. lines_len:      u32 (1 felt, = 136 for BLS12-381 2P_2F)
//!   5. lines:          [G2Line<u384>; 136] (2176 felts)
//!   6. mpcheck_hint:   MPCheckHintBLS12_381 (~2079 felts)
//!
//! Total on the happy path: ~4277 felts including the size prefix.

use crate::algebra::extf_mul::from_e2;
use crate::algebra::g1g2pair::G1G2Pair;
use crate::algebra::g1point::G1Point;
use crate::algebra::g2point::G2Point;
use crate::calldata::drand_calldata::{
    build_hash_to_curve_hint, deserialize_bls_point, hash_to_curve, CurvePoint,
};
use crate::calldata::mpc_calldata;
use crate::definitions::{BLS12381PrimeField, CurveID, CurveParamsProvider, FieldElement};
use crate::io::field_element_to_u384_limbs;
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree12ExtensionField as BLS12381Degree12ExtensionField;
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree2ExtensionField as BLS12381Degree2ExtensionField;
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree6ExtensionField as BLS12381Degree6ExtensionField;
use num_bigint::BigUint;

type F = BLS12381PrimeField;
type E2 = BLS12381Degree2ExtensionField;

/// Build the on-chain calldata for a BLS12-381 min-sig-size signature
/// verification.
///
/// `values` MUST contain exactly three big-endian unsigned integers:
///
///   - `values[0]` — 32-byte big-endian message digest (left-padded
///     if shorter).
///   - `values[1]` — 48-byte BLS-compressed OR 96-byte uncompressed
///     G1 signature.
///   - `values[2]` — 192-byte uncompressed G2 public key
///     `(x0 || x1 || y0 || y1)` (big-endian, 48 bytes each).
///     Garaga's current `deserialize_bls_point` does not yet decode
///     compressed G2 points; callers should send the uncompressed
///     form. A follow-up PR can lift this restriction once
///     compressed-G2 decoding lands upstream.
pub fn bls_calldata_builder(values: &[BigUint]) -> Result<Vec<BigUint>, String> {
    if values.len() != 3 {
        return Err(format!("Invalid data array length: {}", values.len()));
    }

    // ---------- 1. parse message digest (left-pad to 32 bytes BE) ----------
    let message: [u8; 32] = {
        let bytes = values[0].to_bytes_be();
        if bytes.len() > 32 {
            return Err(format!(
                "message_hash must fit in 32 bytes, got {}",
                bytes.len()
            ));
        }
        let mut padded = [0u8; 32];
        let len = bytes.len();
        padded[32 - len..].copy_from_slice(&bytes);
        padded
    };

    // ---------- 2. parse G1 signature (compressed, 48 bytes) ----------
    let signature_pt: G1Point<F> = {
        let bytes = values[1].to_bytes_be();
        if bytes.len() > 48 {
            return Err(format!(
                "signature must fit in 48 bytes, got {}",
                bytes.len()
            ));
        }
        let mut padded = [0u8; 48];
        let len = bytes.len();
        padded[48 - len..].copy_from_slice(&bytes);
        match deserialize_bls_point(&padded)? {
            CurvePoint::G1Point(p) => p,
            CurvePoint::G2Point(_) => {
                return Err("expected G1 signature, got G2 point".to_string());
            }
        }
    };

    // ---------- 3. parse G2 public key (uncompressed, 192 bytes) ----------
    let pubkey_pt: G2Point<F, E2> = {
        let bytes = values[2].to_bytes_be();
        if bytes.len() > 192 {
            return Err(format!(
                "pubkey must fit in 192 uncompressed bytes, got {}",
                bytes.len()
            ));
        }
        let mut padded = [0u8; 192];
        let len = bytes.len();
        padded[192 - len..].copy_from_slice(&bytes);
        match deserialize_bls_point(&padded)? {
            CurvePoint::G2Point(p) => p,
            CurvePoint::G1Point(_) => {
                return Err("expected G2 pubkey, got G1 point".to_string());
            }
        }
    };

    // ---------- 4. compute H(m) ----------
    let msg_pt: G1Point<F> = hash_to_curve::<F>(message, "sha256")?;

    // ---------- 5. build h2c_hint calldata ----------
    let h2c_hint = build_hash_to_curve_hint(message)?.to_calldata()?;

    // ---------- 6. precompute Miller-loop lines for [G2_GEN, -pubkey] ----------
    let g2_gen = G2Point::<F, E2>::generator();
    let neg_pubkey = pubkey_pt.neg();
    let lines = precompute_lines_bls12_381(&[g2_gen.clone(), neg_pubkey.clone()]);

    // ---------- 7. build mpcheck_hint calldata ----------
    let pairs = [
        G1G2Pair::new(signature_pt.clone(), g2_gen),
        G1G2Pair::new(msg_pt, neg_pubkey),
    ];
    let mpc_data = mpc_calldata::calldata_builder::<
        false,
        F,
        E2,
        BLS12381Degree6ExtensionField,
        BLS12381Degree12ExtensionField,
    >(&pairs, 2, &None)?;

    // ---------- 8. assemble calldata ----------
    // Body = signature_g1 (8) + h2c_hint (12) + lines_len (1) + lines + mpcheck_hint
    let lines_felts: Vec<BigUint> = lines
        .iter()
        .flat_map(|fe| {
            field_element_to_u384_limbs(fe)
                .into_iter()
                .map(BigUint::from)
        })
        .collect();
    let n_lines = lines.len() / 4;

    let body_len = 4 + 4 + h2c_hint.len() + 1 + lines_felts.len() + mpc_data.len();
    let mut call_data: Vec<BigUint> = Vec::with_capacity(1 + body_len);
    call_data.push(BigUint::from(body_len));
    call_data.extend(
        field_element_to_u384_limbs(&signature_pt.x)
            .into_iter()
            .map(BigUint::from),
    );
    call_data.extend(
        field_element_to_u384_limbs(&signature_pt.y)
            .into_iter()
            .map(BigUint::from),
    );
    call_data.extend(h2c_hint);
    call_data.push(BigUint::from(n_lines));
    call_data.extend(lines_felts);
    call_data.extend(mpc_data);

    debug_assert_eq!(call_data.len(), 1 + body_len);
    Ok(call_data)
}

// ----------------------------------------------------------------
//  Miller-loop line precomputation (port of Python
//  `hydra/garaga/precompiled_circuits/multi_miller_loop.py:precompute_lines`).
//
//  For every step in the BLS12-381 ate Miller loop counter we emit
//  the raw line coefficients (r0_e2, r1_e2) in Fp2, flattened as
//  four FieldElement<Fp> entries each. The 64-bit BLS loop counter
//  has 67 nonzero contributions (initial bit + 64 doubles + 4
//  double-and-add steps) → 136 total lines for n_pairs=2.
// ----------------------------------------------------------------

/// Precompute Miller-loop lines for a list of G2 points on BLS12-381.
/// Returns a flat `Vec<FieldElement<F>>` where every group of 4
/// elements represents one G2Line in the Cairo verifier:
/// `[r0a0, r0a1, r1a0, r1a1]` (Fp2 → 2 felts each, 2 lines per step).
pub fn precompute_lines_bls12_381(qs: &[G2Point<F, E2>]) -> Vec<FieldElement<F>> {
    if qs.is_empty() {
        return vec![];
    }
    let curve_params = F::get_curve_params();
    debug_assert_eq!(curve_params.curve_id, CurveID::BLS12_381);
    let loop_counter = curve_params.loop_counter;
    let start_index = loop_counter.len() - 2;
    let n_pairs = qs.len();

    let mut points: Vec<G2Point<F, E2>> = Vec::with_capacity(n_pairs);
    let mut out: Vec<FieldElement<F>> = Vec::new();

    // --- initial bit ---
    if loop_counter[start_index] == 1 {
        for q in qs.iter() {
            let (t, l1, l2) = step_triple(q);
            push_line(&mut out, &l1);
            push_line(&mut out, &l2);
            points.push(t);
        }
    } else if loop_counter[start_index] == 0 {
        for q in qs.iter() {
            let (t, l1) = step_double(q);
            push_line(&mut out, &l1);
            points.push(t);
        }
    } else {
        panic!("Unsupported initial loop-counter bit for BLS12-381");
    }

    // --- main loop, MSB-1 → LSB ---
    for i in (0..start_index).rev() {
        let bit = loop_counter[i];
        let mut new_points: Vec<G2Point<F, E2>> = Vec::with_capacity(n_pairs);
        if bit == 0 {
            for p in points.iter() {
                let (t, l1) = step_double(p);
                push_line(&mut out, &l1);
                new_points.push(t);
            }
        } else if bit == 1 || bit == -1 {
            for (k, p) in points.iter().enumerate() {
                let q_select = if bit == 1 { qs[k].clone() } else { qs[k].neg() };
                let (t, l1, l2) = step_double_and_add(p, &q_select);
                push_line(&mut out, &l1);
                push_line(&mut out, &l2);
                new_points.push(t);
            }
        } else {
            panic!("Unsupported loop-counter bit for BLS12-381");
        }
        points = new_points;
    }

    // BLS12-381 has no finalize step (only BN254 does), so we're done.
    out
}

/// Append a single Fp2-pair line (lineR0, lineR1) to the output as 4
/// FieldElement<F> entries: [r0a0, r0a1, r1a0, r1a1].
fn push_line(out: &mut Vec<FieldElement<F>>, line: &(FieldElement<E2>, FieldElement<E2>)) {
    let [r0a0, r0a1] = from_e2::<F, E2>(line.0.clone());
    let [r1a0, r1a1] = from_e2::<F, E2>(line.1.clone());
    out.push(r0a0);
    out.push(r0a1);
    out.push(r1a0);
    out.push(r1a1);
}

/// Emit the new T = 2·Q point and the line `(λ, λ·Q.x − Q.y)` from a
/// single Miller-loop doubling step. Mirrors Python's `_double`.
fn step_double(q: &G2Point<F, E2>) -> (G2Point<F, E2>, (FieldElement<E2>, FieldElement<E2>)) {
    let lambda: FieldElement<E2> = G2Point::compute_doubling_slope(q);
    let xr = &(&lambda * &lambda) - &(&q.x + &q.x);
    let yr = &(&lambda * &(&q.x - &xr)) - &q.y;
    let t = G2Point::new_unchecked(xr, yr);
    let line_r0 = lambda.clone();
    let line_r1 = &(&lambda * &q.x) - &q.y;
    (t, (line_r0, line_r1))
}

/// Emit T = 2·Qa + Qb and two lines from a single double-and-add step.
/// Mirrors Python's `_double_and_add`.
fn step_double_and_add(
    qa: &G2Point<F, E2>,
    qb: &G2Point<F, E2>,
) -> (
    G2Point<F, E2>,
    (FieldElement<E2>, FieldElement<E2>),
    (FieldElement<E2>, FieldElement<E2>),
) {
    let lambda1 = G2Point::compute_adding_slope(qa, qb);
    let x3 = &(&lambda1 * &lambda1) - &(&qa.x + &qb.x);
    let line1_r0 = lambda1.clone();
    let line1_r1 = &(&lambda1 * &qa.x) - &qa.y;
    let num = &qa.y + &qa.y;
    let den = &x3 - &qa.x;
    let lambda2 = -&(&lambda1 + &(&num / &den).unwrap());
    let x4 = &(&(&lambda2 * &lambda2) - &qa.x) - &x3;
    let y4 = &(&lambda2 * &(&qa.x - &x4)) - &qa.y;
    let t = G2Point::new_unchecked(x4, y4);
    let line2_r0 = lambda2.clone();
    let line2_r1 = &(&lambda2 * &qa.x) - &qa.y;
    (t, (line1_r0, line1_r1), (line2_r0, line2_r1))
}

/// Emit T = 3·Q and two lines from a single tripling step. Mirrors
/// Python's `_triple` — first a doubling-slope to derive an
/// intermediate point and slope, then an addition step relative to Q.
fn step_triple(
    q: &G2Point<F, E2>,
) -> (
    G2Point<F, E2>,
    (FieldElement<E2>, FieldElement<E2>),
    (FieldElement<E2>, FieldElement<E2>),
) {
    let lambda1 = G2Point::compute_doubling_slope(q);
    let x_mid = &(&lambda1 * &lambda1) - &(&q.x + &q.x);
    let line1_r0 = lambda1.clone();
    let line1_r1 = &(&lambda1 * &q.x) - &q.y;
    let num = &q.y + &q.y;
    let den = &x_mid - &q.x;
    let lambda2 = -&(&lambda1 + &(&num / &den).unwrap());
    let x_final = &(&(&lambda2 * &lambda2) - &q.x) - &x_mid;
    let y_final = &(&lambda2 * &(&q.x - &x_final)) - &q.y;
    let t = G2Point::new_unchecked(x_final, y_final);
    let line2_r0 = lambda2.clone();
    let line2_r1 = &(&lambda2 * &q.x) - &q.y;
    (t, (line1_r0, line1_r1), (line2_r0, line2_r1))
}

#[cfg(test)]
mod tests {
    use super::*;

    /// End-to-end happy-path against the deterministic fixture pinned
    /// at `haycarlitos/shhh-wallet-cairo:scripts/py/gen_bls_fixture.py`:
    ///   sk           = 0x12345678
    ///   message_hash = 0x05bcd634…2197a2a2f
    ///   pubkey_g2    = sk · G2_GEN          (compressed below)
    ///   signature_g1 = sk · H(message_hash) (compressed below)
    /// On this input `bls_calldata_builder` MUST emit exactly 4277
    /// felts: 1 (size) + 8 (sig_g1) + 12 (h2c_hint) + 1 (lines_len)
    /// + 2176 (lines) + 2079 (mpcheck_hint) = 4277.
    #[test]
    fn test_bls_calldata_builder_known_fixture() {
        let message_hash = BigUint::parse_bytes(
            b"05bcd634ce46c7234bd7a4b0959c3c5edeed7f569dcfb7b33e23d7e2197a2a2f",
            16,
        )
        .unwrap();
        let signature_compressed = BigUint::parse_bytes(
            b"80ffac3b39757a00a67e77515c2ddd3e48d317dda4578eb2cab7bfbbfa657093c5277edefa2c595ff1c7709a37b3d4a1",
            16,
        )
        .unwrap();
        // Uncompressed G2: x0 || x1 || y0 || y1 (48 bytes each).
        let pubkey_uncompressed = BigUint::parse_bytes(
            b"13dec97a5c18cf35174115e4743fb04043ee71f7d7d5e43033c2dfa04be7c1d60a73315a3cd48a9839c980732b4934b10f40cb7f4e60ef34d19a36bd662b2434914fdb764559e98f4058d0160f4b56c99284598c03363926be3fac1180c95f650d0567ebb42929a41c47be7b6a6162a2a68f723aa049ab7558ace3838346386680bd788384703c673977e4e88e86e76a1939db2a9fe74ef4e99ba3b3b075ff46d18f8c27c41bf07a7704b984535494b9e8b804807172aa1b85caab6973ca2e15",
            16,
        )
        .unwrap();

        let calldata =
            bls_calldata_builder(&[message_hash, signature_compressed, pubkey_uncompressed])
                .expect("builder failed on known fixture");

        // 1 (size) + 8 (sig) + 12 (h2c_hint) + 1 (lines_len) + 2176 (lines) + 2079 (mpcheck_hint).
        assert_eq!(
            calldata.len(),
            4277,
            "calldata length must match the Shhh V8 verifier envelope"
        );

        // size prefix self-check
        let body_len = &calldata[0];
        assert_eq!(body_len, &BigUint::from(4276u32));
    }

    /// Reject obviously-malformed inputs without panicking.
    #[test]
    fn test_bls_calldata_builder_rejects_wrong_arity() {
        let r = bls_calldata_builder(&[BigUint::from(0u64)]);
        assert!(r.is_err());
    }

    #[test]
    fn test_precompute_lines_count_matches_python() {
        // For BLS12-381 with 2 G2 points the Cairo verifier consumes
        // exactly 136 G2Line<u384> records (= 544 FieldElement<F> in
        // raw form). Python's hydra.precompute_lines produces the
        // same count; this test pins Rust's output length to 544.
        let g = G2Point::<F, E2>::generator();
        let g_neg = g.neg();
        let lines = precompute_lines_bls12_381(&[g, g_neg]);
        assert_eq!(lines.len(), 544, "expected 544 felts (136 lines × 4)");
    }
}
