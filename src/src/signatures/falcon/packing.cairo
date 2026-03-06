//! Base-Q polynomial packing for storage-efficient Falcon public keys.
//!
//! Packs 512 Zq values into 29 felt252 slots using base Q=12289 encoding:
//!   felt252 = pack_9(v0..v8) + pack_9(v9..v17) * 2^128
//!
//! DivRem by Q gives RemT = Zq directly — zero downcasts in the hot path.

use corelib_imports::bounded_int::bounded_int::{add, mul};
use corelib_imports::bounded_int::{
    AddHelper, BoundedInt, DivRemHelper, MulHelper, bounded_int_div_rem, downcast, upcast,
};
use super::zq::{NZ_Q, QConst, Q_CONST, Zq};

// =============================================================================
// Constants
// =============================================================================

/// Number of Zq values per u128 half (Q^9 < 2^128)
const VALS_PER_U128: usize = 9;

/// Number of Zq values per felt252 (two u128 halves)
const VALS_PER_FELT: usize = 18;

/// Total felt252 slots for 512 values: ceil(512/18) = 29
const PACKED_SLOTS: usize = 29;

/// 2^128 as felt252 for combining u128 halves
const TWO_POW_128: felt252 = 0x100000000000000000000000000000000;

// =============================================================================
// Accumulator type chain: AccN max = Q^(N+1) - 1
// Shared between Horner packing and DivRem unpacking.
// Acc0 = Zq (reused from zq.cairo)
// =============================================================================

type Acc0 = Zq; // BoundedInt<0, 12288>
type Acc1 = BoundedInt<0, 151019520>;
type Acc2 = BoundedInt<0, 1855878893568>;
type Acc3 = BoundedInt<0, 22806895723069440>;
type Acc4 = BoundedInt<0, 280273941540800360448>;
type Acc5 = BoundedInt<0, 3444286467594895629557760>;
type Acc6 = BoundedInt<0, 42326836400273672391635324928>;
type Acc7 = BoundedInt<0, 520154492522963160020806508052480>;
type Acc8 = BoundedInt<0, 6392178558614694273495691177456939008>;

// =============================================================================
// MulHelper intermediate types: MulQAccN max = Q * (Q^(N+1) - 1) = Q^(N+2) - Q
// =============================================================================

type MulQAcc0 = BoundedInt<0, 151007232>;
type MulQAcc1 = BoundedInt<0, 1855878881280>;
type MulQAcc2 = BoundedInt<0, 22806895723057152>;
type MulQAcc3 = BoundedInt<0, 280273941540800348160>;
type MulQAcc4 = BoundedInt<0, 3444286467594895629545472>;
type MulQAcc5 = BoundedInt<0, 42326836400273672391635312640>;
type MulQAcc6 = BoundedInt<0, 520154492522963160020806508040192>;
type MulQAcc7 = BoundedInt<0, 6392178558614694273495691177456926720>;

// =============================================================================
// MulHelper impls: QConst * AccN -> MulQAccN
// =============================================================================

impl MulQAcc0Impl of MulHelper<QConst, Acc0> {
    type Result = MulQAcc0;
}

impl MulQAcc1Impl of MulHelper<QConst, Acc1> {
    type Result = MulQAcc1;
}

impl MulQAcc2Impl of MulHelper<QConst, Acc2> {
    type Result = MulQAcc2;
}

impl MulQAcc3Impl of MulHelper<QConst, Acc3> {
    type Result = MulQAcc3;
}

impl MulQAcc4Impl of MulHelper<QConst, Acc4> {
    type Result = MulQAcc4;
}

impl MulQAcc5Impl of MulHelper<QConst, Acc5> {
    type Result = MulQAcc5;
}

impl MulQAcc6Impl of MulHelper<QConst, Acc6> {
    type Result = MulQAcc6;
}

impl MulQAcc7Impl of MulHelper<QConst, Acc7> {
    type Result = MulQAcc7;
}

// =============================================================================
// AddHelper impls: Zq + MulQAccN -> Acc(N+1)
// Identity: (Q-1) + Q*(Q^(N+1)-1) = Q^(N+2) - 1
// =============================================================================

impl AddZqMulQAcc0Impl of AddHelper<Zq, MulQAcc0> {
    type Result = Acc1;
}

impl AddZqMulQAcc1Impl of AddHelper<Zq, MulQAcc1> {
    type Result = Acc2;
}

impl AddZqMulQAcc2Impl of AddHelper<Zq, MulQAcc2> {
    type Result = Acc3;
}

impl AddZqMulQAcc3Impl of AddHelper<Zq, MulQAcc3> {
    type Result = Acc4;
}

impl AddZqMulQAcc4Impl of AddHelper<Zq, MulQAcc4> {
    type Result = Acc5;
}

impl AddZqMulQAcc5Impl of AddHelper<Zq, MulQAcc5> {
    type Result = Acc6;
}

impl AddZqMulQAcc6Impl of AddHelper<Zq, MulQAcc6> {
    type Result = Acc7;
}

impl AddZqMulQAcc7Impl of AddHelper<Zq, MulQAcc7> {
    type Result = Acc8;
}

// =============================================================================
// DivRemHelper impls: AccN / QConst -> (Acc(N-1), Zq)
// =============================================================================

impl DivRemAcc1Impl of DivRemHelper<Acc1, QConst> {
    type DivT = Acc0;
    type RemT = Zq;
}

impl DivRemAcc2Impl of DivRemHelper<Acc2, QConst> {
    type DivT = Acc1;
    type RemT = Zq;
}

impl DivRemAcc3Impl of DivRemHelper<Acc3, QConst> {
    type DivT = Acc2;
    type RemT = Zq;
}

impl DivRemAcc4Impl of DivRemHelper<Acc4, QConst> {
    type DivT = Acc3;
    type RemT = Zq;
}

impl DivRemAcc5Impl of DivRemHelper<Acc5, QConst> {
    type DivT = Acc4;
    type RemT = Zq;
}

impl DivRemAcc6Impl of DivRemHelper<Acc6, QConst> {
    type DivT = Acc5;
    type RemT = Zq;
}

impl DivRemAcc7Impl of DivRemHelper<Acc7, QConst> {
    type DivT = Acc6;
    type RemT = Zq;
}

impl DivRemAcc8Impl of DivRemHelper<Acc8, QConst> {
    type DivT = Acc7;
    type RemT = Zq;
}

// =============================================================================
// Packing functions
// =============================================================================

/// Helper: get a Zq value from a Zq span
#[inline(always)]
fn v(vals: Span<Zq>, i: usize) -> Zq {
    *vals.at(i)
}

/// Horner-encode up to 9 Zq values into a u128.
/// Encoding: v0 + Q*(v1 + Q*(v2 + ... + Q*v8))
fn pack_9(vals: Span<Zq>) -> u128 {
    let n = vals.len();
    match n {
        0 => 0_u128,
        1 => {
            let a: Zq = v(vals, 0);
            upcast(a)
        },
        2 => {
            let a1: Acc1 = add(v(vals, 0), mul(Q_CONST, v(vals, 1)));
            upcast(a1)
        },
        3 => {
            let a1: Acc1 = add(v(vals, 1), mul(Q_CONST, v(vals, 2)));
            let a2: Acc2 = add(v(vals, 0), mul(Q_CONST, a1));
            upcast(a2)
        },
        4 => {
            let a1: Acc1 = add(v(vals, 2), mul(Q_CONST, v(vals, 3)));
            let a2: Acc2 = add(v(vals, 1), mul(Q_CONST, a1));
            let a3: Acc3 = add(v(vals, 0), mul(Q_CONST, a2));
            upcast(a3)
        },
        5 => {
            let a1: Acc1 = add(v(vals, 3), mul(Q_CONST, v(vals, 4)));
            let a2: Acc2 = add(v(vals, 2), mul(Q_CONST, a1));
            let a3: Acc3 = add(v(vals, 1), mul(Q_CONST, a2));
            let a4: Acc4 = add(v(vals, 0), mul(Q_CONST, a3));
            upcast(a4)
        },
        6 => {
            let a1: Acc1 = add(v(vals, 4), mul(Q_CONST, v(vals, 5)));
            let a2: Acc2 = add(v(vals, 3), mul(Q_CONST, a1));
            let a3: Acc3 = add(v(vals, 2), mul(Q_CONST, a2));
            let a4: Acc4 = add(v(vals, 1), mul(Q_CONST, a3));
            let a5: Acc5 = add(v(vals, 0), mul(Q_CONST, a4));
            upcast(a5)
        },
        7 => {
            let a1: Acc1 = add(v(vals, 5), mul(Q_CONST, v(vals, 6)));
            let a2: Acc2 = add(v(vals, 4), mul(Q_CONST, a1));
            let a3: Acc3 = add(v(vals, 3), mul(Q_CONST, a2));
            let a4: Acc4 = add(v(vals, 2), mul(Q_CONST, a3));
            let a5: Acc5 = add(v(vals, 1), mul(Q_CONST, a4));
            let a6: Acc6 = add(v(vals, 0), mul(Q_CONST, a5));
            upcast(a6)
        },
        8 => {
            let a1: Acc1 = add(v(vals, 6), mul(Q_CONST, v(vals, 7)));
            let a2: Acc2 = add(v(vals, 5), mul(Q_CONST, a1));
            let a3: Acc3 = add(v(vals, 4), mul(Q_CONST, a2));
            let a4: Acc4 = add(v(vals, 3), mul(Q_CONST, a3));
            let a5: Acc5 = add(v(vals, 2), mul(Q_CONST, a4));
            let a6: Acc6 = add(v(vals, 1), mul(Q_CONST, a5));
            let a7: Acc7 = add(v(vals, 0), mul(Q_CONST, a6));
            upcast(a7)
        },
        9 => {
            let a1: Acc1 = add(v(vals, 7), mul(Q_CONST, v(vals, 8)));
            let a2: Acc2 = add(v(vals, 6), mul(Q_CONST, a1));
            let a3: Acc3 = add(v(vals, 5), mul(Q_CONST, a2));
            let a4: Acc4 = add(v(vals, 4), mul(Q_CONST, a3));
            let a5: Acc5 = add(v(vals, 3), mul(Q_CONST, a4));
            let a6: Acc6 = add(v(vals, 2), mul(Q_CONST, a5));
            let a7: Acc7 = add(v(vals, 1), mul(Q_CONST, a6));
            let a8: Acc8 = add(v(vals, 0), mul(Q_CONST, a7));
            upcast(a8)
        },
        _ => core::panic_with_felt252('pack_9: count > 9'),
    }
}

/// Unpack a u128 into `count` Zq values using iterated DivRem by Q.
fn unpack_9(packed: u128, count: usize, ref output: Array<Zq>) {
    if count == 0 {
        return;
    }
    let acc8: Acc8 = downcast(packed).expect('invalid packed value');
    let (acc7, r0) = bounded_int_div_rem(acc8, NZ_Q);
    output.append(r0);
    if count == 1 {
        return;
    }
    let (acc6, r1) = bounded_int_div_rem(acc7, NZ_Q);
    output.append(r1);
    if count == 2 {
        return;
    }
    let (acc5, r2) = bounded_int_div_rem(acc6, NZ_Q);
    output.append(r2);
    if count == 3 {
        return;
    }
    let (acc4, r3) = bounded_int_div_rem(acc5, NZ_Q);
    output.append(r3);
    if count == 4 {
        return;
    }
    let (acc3, r4) = bounded_int_div_rem(acc4, NZ_Q);
    output.append(r4);
    if count == 5 {
        return;
    }
    let (acc2, r5) = bounded_int_div_rem(acc3, NZ_Q);
    output.append(r5);
    if count == 6 {
        return;
    }
    let (acc1, r6) = bounded_int_div_rem(acc2, NZ_Q);
    output.append(r6);
    if count == 7 {
        return;
    }
    let (acc0, r7) = bounded_int_div_rem(acc1, NZ_Q);
    output.append(r7);
    if count == 8 {
        return;
    }
    output.append(acc0);
}

/// Unpack a u128 into exactly 9 Zq values. No count checks.
fn unpack_9_full(packed: u128, ref output: Array<Zq>) {
    let acc8: Acc8 = downcast(packed).expect('bad pack');
    let (acc7, r0) = bounded_int_div_rem(acc8, NZ_Q);
    output.append(r0);
    let (acc6, r1) = bounded_int_div_rem(acc7, NZ_Q);
    output.append(r1);
    let (acc5, r2) = bounded_int_div_rem(acc6, NZ_Q);
    output.append(r2);
    let (acc4, r3) = bounded_int_div_rem(acc5, NZ_Q);
    output.append(r3);
    let (acc3, r4) = bounded_int_div_rem(acc4, NZ_Q);
    output.append(r4);
    let (acc2, r5) = bounded_int_div_rem(acc3, NZ_Q);
    output.append(r5);
    let (acc1, r6) = bounded_int_div_rem(acc2, NZ_Q);
    output.append(r6);
    let (acc0, r7) = bounded_int_div_rem(acc1, NZ_Q);
    output.append(r7);
    output.append(acc0);
}

/// Unpack a u128 into exactly 8 Zq values (7 div_rems + final quotient).
fn unpack_8(packed: u128, ref output: Array<Zq>) {
    let acc7: Acc7 = downcast(packed).expect('bad pack');
    let (acc6, r0) = bounded_int_div_rem(acc7, NZ_Q);
    output.append(r0);
    let (acc5, r1) = bounded_int_div_rem(acc6, NZ_Q);
    output.append(r1);
    let (acc4, r2) = bounded_int_div_rem(acc5, NZ_Q);
    output.append(r2);
    let (acc3, r3) = bounded_int_div_rem(acc4, NZ_Q);
    output.append(r3);
    let (acc2, r4) = bounded_int_div_rem(acc3, NZ_Q);
    output.append(r4);
    let (acc1, r5) = bounded_int_div_rem(acc2, NZ_Q);
    output.append(r5);
    let (acc0, r6) = bounded_int_div_rem(acc1, NZ_Q);
    output.append(r6);
    output.append(acc0);
}

/// Pack 512 Zq values into 29 felt252 slots.
/// Each slot encodes up to 18 values: pack_9(lo) + pack_9(hi) * 2^128.
pub fn pack_public_key(values: Span<Zq>) -> Array<felt252> {
    assert!(values.len() == 512, "expected 512 values");
    let mut result: Array<felt252> = array![];
    let mut offset: usize = 0;
    // 28 full slots: 9 lo + 9 hi = 18 values each (504 total)
    while offset != 504 {
        let lo_felt: felt252 = pack_9(values.slice(offset, 9)).into();
        let hi_felt: felt252 = pack_9(values.slice(offset + 9, 9)).into();
        result.append(lo_felt + hi_felt * TWO_POW_128);
        offset += 18;
    }
    // Last slot: 8 remaining values in low half only
    result.append(pack_9(values.slice(504, 8)).into());
    result
}

/// Unpack 29 felt252 slots back to 512 Zq values.
pub fn unpack_public_key(packed: Span<felt252>) -> Array<Zq> {
    let mut output: Array<Zq> = array![];
    let mut packed = packed;
    // 28 full slots: 9 lo + 9 hi = 18 values each (504 total)
    let mut i: usize = 0;
    while i != 28 {
        let val_u256: u256 = (*packed.pop_front().unwrap()).into();
        unpack_9_full(val_u256.low, ref output);
        unpack_9_full(val_u256.high, ref output);
        i += 1;
    }
    // Last slot: 8 remaining values in low half
    let val_u256: u256 = (*packed.pop_front().unwrap()).into();
    unpack_8(val_u256.low, ref output);
    output
}

// =============================================================================
// PackedPolynomial512: storage-friendly struct for 512 Zq coefficients
// =============================================================================

/// A polynomial of 512 Zq coefficients packed into 29 felt252 fields.
/// Suitable for Starknet storage (each field maps to a single storage slot).
#[derive(Drop, Copy, Serde)]
pub struct PackedPolynomial512 {
    pub s0: felt252,
    pub s1: felt252,
    pub s2: felt252,
    pub s3: felt252,
    pub s4: felt252,
    pub s5: felt252,
    pub s6: felt252,
    pub s7: felt252,
    pub s8: felt252,
    pub s9: felt252,
    pub s10: felt252,
    pub s11: felt252,
    pub s12: felt252,
    pub s13: felt252,
    pub s14: felt252,
    pub s15: felt252,
    pub s16: felt252,
    pub s17: felt252,
    pub s18: felt252,
    pub s19: felt252,
    pub s20: felt252,
    pub s21: felt252,
    pub s22: felt252,
    pub s23: felt252,
    pub s24: felt252,
    pub s25: felt252,
    pub s26: felt252,
    pub s27: felt252,
    pub s28: felt252,
}

#[generate_trait]
pub impl PackedPolynomial512Impl of PackedPolynomial512Trait {
    /// Pack 512 Zq coefficients into a `PackedPolynomial512`.
    fn from_coeffs(values: Span<Zq>) -> PackedPolynomial512 {
        let packed = pack_public_key(values);
        let s = packed.span();
        PackedPolynomial512 {
            s0: *s.at(0),
            s1: *s.at(1),
            s2: *s.at(2),
            s3: *s.at(3),
            s4: *s.at(4),
            s5: *s.at(5),
            s6: *s.at(6),
            s7: *s.at(7),
            s8: *s.at(8),
            s9: *s.at(9),
            s10: *s.at(10),
            s11: *s.at(11),
            s12: *s.at(12),
            s13: *s.at(13),
            s14: *s.at(14),
            s15: *s.at(15),
            s16: *s.at(16),
            s17: *s.at(17),
            s18: *s.at(18),
            s19: *s.at(19),
            s20: *s.at(20),
            s21: *s.at(21),
            s22: *s.at(22),
            s23: *s.at(23),
            s24: *s.at(24),
            s25: *s.at(25),
            s26: *s.at(26),
            s27: *s.at(27),
            s28: *s.at(28),
        }
    }

    /// Unpack back to 512 Zq coefficients.
    fn to_coeffs(self: @PackedPolynomial512) -> Array<Zq> {
        unpack_public_key(self.to_span())
    }

    /// Return the 29 packed felt252 values as a span.
    fn to_span(self: @PackedPolynomial512) -> Span<felt252> {
        array![
            *self.s0, *self.s1, *self.s2, *self.s3, *self.s4, *self.s5, *self.s6, *self.s7,
            *self.s8, *self.s9, *self.s10, *self.s11, *self.s12, *self.s13, *self.s14, *self.s15,
            *self.s16, *self.s17, *self.s18, *self.s19, *self.s20, *self.s21, *self.s22, *self.s23,
            *self.s24, *self.s25, *self.s26, *self.s27, *self.s28,
        ]
            .span()
    }
}
