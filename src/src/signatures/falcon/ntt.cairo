// SPDX-FileCopyrightText: 2025 StarkWare Industries Ltd.
//
// SPDX-License-Identifier: MIT

//! NTT operations for Falcon-512 signature verification.
//!
//! Uses the auto-generated unrolled NTT (ntt_felt252) for n=512 only.
//! No recursive NTT or INTT — verification uses hint-based approach.

use super::ntt_felt252::ntt_512;
use super::zq::{Zq, mul_mod};

/// Multiply coefficients of two polynomials modulo Q (pointwise in NTT domain)
pub fn mul_ntt(mut f: Span<Zq>, mut g: Span<Zq>) -> Array<Zq> {
    assert(f.len() == g.len(), 'f.len() != g.len()');
    let mut res: Array<Zq> = array![];
    while let Some(f_coeff) = f.pop_front() {
        let g_coeff = g.pop_front().unwrap();
        res.append(mul_mod(*f_coeff, *g_coeff));
    }
    res
}

/// Compute NTT of a 512-element polynomial using the unrolled felt252 implementation.
pub fn ntt_fast(f: Span<Zq>) -> Array<Zq> {
    assert(f.len() == 512, 'ntt_fast requires n=512');
    ntt_512(f)
}

/// Verify an INTT result supplied as a hint.
/// Given f_ntt (NTT-domain polynomial) and result_hint (claimed coefficients),
/// verifies that NTT(result_hint) == f_ntt element-by-element.
/// Returns the verified result.
pub fn intt_with_hint(f_ntt: Span<Zq>, result_hint: Span<Zq>) -> Span<Zq> {
    assert(f_ntt.len() == result_hint.len(), 'length mismatch');
    let roundtrip = ntt_fast(result_hint);
    let mut f_iter = f_ntt;
    let mut r_iter = roundtrip.span();
    while let Some(f_val) = f_iter.pop_front() {
        assert(f_val == r_iter.pop_front().unwrap(), 'intt hint mismatch');
    }
    result_hint
}
