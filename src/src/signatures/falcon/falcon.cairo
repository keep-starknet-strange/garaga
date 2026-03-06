// SPDX-FileCopyrightText: 2025 StarkWare Industries Ltd.
//
// SPDX-License-Identifier: MIT

use corelib_imports::bounded_int::{BoundedInt, downcast, upcast};
use super::ntt::ntt_fast;
use super::packing::{PackedPolynomial512, PackedPolynomial512Trait};
use super::types::{
    FalconPublicKey, FalconSignature, FalconSignatureWithHint, FalconVerificationHint, HashToPoint,
    PackedFalconSignatureWithHint,
};
use super::zq::{Zq, mul_mod, sub_mod};

/// Zq value in the low half: [0, (Q-1)/2] = [0, 6144]
type ZqLow = BoundedInt<0, 6144>;
const Q_felt252: felt252 = 12289;

/// Compute the squared centered norm of a single Zq element.
fn center_and_square(coeff: Zq) -> felt252 {
    match downcast::<Zq, ZqLow>(coeff) {
        Option::Some(low) => {
            let x: felt252 = upcast(low);
            x * x
        },
        Option::None => {
            let x: felt252 = upcast(coeff);
            let centered = Q_felt252 - x;
            centered * centered
        },
    }
}

/// Signature bound for Falcon-512
const SIG_BOUND_512: u64 = 34034726;

/// Verify a Falcon signature using the hint-based approach.
/// Computes msg_point internally via hash_to_point.
/// Cost: 2 NTTs, 0 INTTs.
pub fn verify<H, +HashToPoint<H>, +Drop<H>>(
    pk: @FalconPublicKey, sig_with_hint: FalconSignatureWithHint, message: Span<felt252>,
) -> bool {
    let msg_point = HashToPoint::<H>::hash_to_point(message, sig_with_hint.signature.salt.span());
    verify_with_msg_point(pk, sig_with_hint, msg_point.span())
}

/// Verify with a pre-computed msg_point (useful for testing without hash_to_point).
///
/// Single-pass verification: 2 unrolled NTTs + 1 fused loop that does
/// hint verification, pointwise multiply check, and norm computation.
pub fn verify_with_msg_point(
    pk: @FalconPublicKey, sig_with_hint: FalconSignatureWithHint, msg_point: Span<Zq>,
) -> bool {
    let s1 = sig_with_hint.signature.s1.span();
    let pk_ntt = pk.h_ntt.span();
    let mul_hint = sig_with_hint.hint.mul_hint.span();

    assert!(s1.len() == 512, "s1 must be 512 elements");
    assert!(pk_ntt.len() == 512, "pk must be 512 elements");
    assert!(mul_hint.len() == 512, "mul_hint must be 512 elements");
    assert!(msg_point.len() == 512, "msg_point must be 512 elements");

    // Two forward NTTs (unrolled, no loops)
    let s1_ntt = ntt_fast(s1);
    let hint_ntt = ntt_fast(mul_hint);

    // Single pass over all 512 coefficients:
    //   - Verify hint: s1_ntt[i] * pk_ntt[i] == NTT(mul_hint)[i]
    //   - Accumulate: ||msg_point - mul_hint||² + ||s1||²
    let mut s1_ntt_iter = s1_ntt.span();
    let mut pk_ntt_iter = pk_ntt;
    let mut hint_ntt_iter = hint_ntt.span();
    let mut msg_iter = msg_point;
    let mut hint_iter = mul_hint;
    let mut s1_iter = s1;

    let mut acc: felt252 = 0;
    while let Some(s1n_box) = s1_ntt_iter.multi_pop_front::<8>() {
        let [s1n0, s1n1, s1n2, s1n3, s1n4, s1n5, s1n6, s1n7] = s1n_box.unbox();
        let [pkn0, pkn1, pkn2, pkn3, pkn4, pkn5, pkn6, pkn7] = pk_ntt_iter
            .multi_pop_front::<8>()
            .unwrap()
            .unbox();
        let [hn0, hn1, hn2, hn3, hn4, hn5, hn6, hn7] = hint_ntt_iter
            .multi_pop_front::<8>()
            .unwrap()
            .unbox();
        let [msg0, msg1, msg2, msg3, msg4, msg5, msg6, msg7] = msg_iter
            .multi_pop_front::<8>()
            .unwrap()
            .unbox();
        let [hint0, hint1, hint2, hint3, hint4, hint5, hint6, hint7] = hint_iter
            .multi_pop_front::<8>()
            .unwrap()
            .unbox();
        let [s1v0, s1v1, s1v2, s1v3, s1v4, s1v5, s1v6, s1v7] = s1_iter
            .multi_pop_front::<8>()
            .unwrap()
            .unbox();

        // Verify: NTT(s1)[i] * pk_ntt[i] == NTT(mul_hint)[i]
        assert(mul_mod(s1n0, pkn0) == hn0, 'hint mismatch');
        assert(mul_mod(s1n1, pkn1) == hn1, 'hint mismatch');
        assert(mul_mod(s1n2, pkn2) == hn2, 'hint mismatch');
        assert(mul_mod(s1n3, pkn3) == hn3, 'hint mismatch');
        assert(mul_mod(s1n4, pkn4) == hn4, 'hint mismatch');
        assert(mul_mod(s1n5, pkn5) == hn5, 'hint mismatch');
        assert(mul_mod(s1n6, pkn6) == hn6, 'hint mismatch');
        assert(mul_mod(s1n7, pkn7) == hn7, 'hint mismatch');

        // Accumulate: ||msg_point - mul_hint||² + ||s1||²
        acc += center_and_square(sub_mod(msg0, hint0))
            + center_and_square(s1v0)
            + center_and_square(sub_mod(msg1, hint1))
            + center_and_square(s1v1)
            + center_and_square(sub_mod(msg2, hint2))
            + center_and_square(s1v2)
            + center_and_square(sub_mod(msg3, hint3))
            + center_and_square(s1v3)
            + center_and_square(sub_mod(msg4, hint4))
            + center_and_square(s1v4)
            + center_and_square(sub_mod(msg5, hint5))
            + center_and_square(s1v5)
            + center_and_square(sub_mod(msg6, hint6))
            + center_and_square(s1v6)
            + center_and_square(sub_mod(msg7, hint7))
            + center_and_square(s1v7);
    }

    let norm_u64: u64 = acc.try_into().unwrap();
    norm_u64 <= SIG_BOUND_512
}

/// Verify a Falcon signature from packed (29 felt252) inputs.
/// Unpacks PK, s1, and mul_hint, then delegates to verify.
pub fn verify_packed<H, +HashToPoint<H>, +Drop<H>>(
    pk: @PackedPolynomial512, sig: PackedFalconSignatureWithHint, message: Span<felt252>,
) -> bool {
    let pk_coeffs = pk.to_coeffs();
    let s1_coeffs = sig.signature.s1.to_coeffs();
    let mul_hint_coeffs = sig.hint.mul_hint.to_coeffs();
    let falcon_pk = FalconPublicKey { h_ntt: pk_coeffs };
    let sig_with_hint = FalconSignatureWithHint {
        signature: FalconSignature { s1: s1_coeffs, salt: sig.signature.salt },
        hint: FalconVerificationHint { mul_hint: mul_hint_coeffs },
    };
    verify::<H>(@falcon_pk, sig_with_hint, message)
}
