use core::internal::bounded_int;
use core::internal::bounded_int::{AddHelper, BoundedInt, DivRemHelper, MulHelper, UnitInt, upcast};

const TWO: felt252 = 2;
const TWO_UI: UnitInt<TWO> = 2;
const FOUR_UI: UnitInt<FOUR> = 4;
const EIGHT_UI: UnitInt<EIGHT> = 8;
const TWO_NZ_TYPED: NonZero<UnitInt<TWO>> = 2;
const POW128_DIV_2: felt252 = 0x7fffffffffffffffffffffffffffffff; // ((2^128-1) // 2)
const POW128: felt252 = 0x100000000000000000000000000000000;

const FOUR: felt252 = 4;
const EIGHT: felt252 = 8;


pub type u15_bi = BoundedInt<0, { 15 }>;
pub type u1_bi = BoundedInt<0, { 1 }>;
pub type u2_bi = BoundedInt<0, { 2 }>;
pub type u3_bi = BoundedInt<0, { 3 }>;
pub type u4_bi = BoundedInt<0, { 4 }>;
pub type u5_bi = BoundedInt<0, { 5 }>;
pub type u6_bi = BoundedInt<0, { 6 }>;
pub type u7_bi = BoundedInt<0, { 7 }>;
pub type u8_bi = BoundedInt<0, { 8 }>;

impl DivRemU128By2 of DivRemHelper<BoundedInt<0, { POW128 - 1 }>, UnitInt<TWO>> {
    type DivT = BoundedInt<0, { POW128_DIV_2 }>;
    type RemT = u1_bi;
}


impl MulHelperBitBy2Impl of MulHelper<u1_bi, UnitInt<TWO>> {
    type Result = u2_bi;
}

impl MulHelperBitBy4Impl of MulHelper<u1_bi, UnitInt<FOUR>> {
    type Result = u4_bi;
}

impl MulHelperBitBy8Impl of MulHelper<u1_bi, UnitInt<EIGHT>> {
    type Result = u8_bi;
}

impl AddHelperU1ByU2Impl of AddHelper<u1_bi, u2_bi> {
    type Result = u3_bi;
}

impl AddHelperU3ByU4Impl of AddHelper<u3_bi, u4_bi> {
    type Result = u7_bi;
}

impl AddHelperU7ByU8Impl of AddHelper<u7_bi, u8_bi> {
    type Result = u15_bi;
}

#[inline(always)]
fn build_selectors(
    _u1: u128, _u2: u128, _v1: u128, _v2: u128, n_bits: usize,
) -> (Span<usize>, u128, u128, u128, u128) {
    let mut selectors: Array<usize> = array![];

    let mut u1: BoundedInt<0, { POW128 - 1 }> = upcast(_u1);
    let mut u2: BoundedInt<0, { POW128 - 1 }> = upcast(_u2);
    let mut v1: BoundedInt<0, { POW128 - 1 }> = upcast(_v1);
    let mut v2: BoundedInt<0, { POW128 - 1 }> = upcast(_v2);

    let (qu1, u1lsb) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2, u2lsb) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1, v1lsb) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2, v2lsb) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1);
    u2 = upcast(qu2);
    v1 = upcast(qv1);
    v2 = upcast(qv2);

    for _ in 0..n_bits - 1 {
        let (qu1, u1b) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
        let (qu2, u2b) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
        let (qv1, v1b) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
        let (qv2, v2b) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
        u1 = upcast(qu1);
        u2 = upcast(qu2);
        v1 = upcast(qv1);
        v2 = upcast(qv2);
        let selector_y: felt252 = u1b.into() + 2 * u2b.into() + 4 * v1b.into() + 8 * v2b.into();
        let selector_y: usize = selector_y.try_into().unwrap();
        selectors.append(selector_y);
    }
    return (selectors.span(), upcast(u1lsb), upcast(u2lsb), upcast(v1lsb), upcast(v2lsb));
}


#[inline(always)]
pub fn build_selectors_inlined(
    _u1: u128, _u2: u128, _v1: u128, _v2: u128, bits_73: bool,
) -> (Span<usize>, u128, u128, u128, u128) {
    // Generated code for n_bits = 73
    let mut selectors: Array<usize> = array![];

    // Use BoundedInt for calculations
    let mut u1: BoundedInt<0, { POW128 - 1 }> = upcast(_u1);
    let mut u2: BoundedInt<0, { POW128 - 1 }> = upcast(_u2);
    let mut v1: BoundedInt<0, { POW128 - 1 }> = upcast(_v1);
    let mut v2: BoundedInt<0, { POW128 - 1 }> = upcast(_v2);

    // Initial division and remainder to get LSBs
    let (qu1, u1lsb) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2, u2lsb) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1, v1lsb) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2, v2lsb) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1);
    u2 = upcast(qu2);
    v1 = upcast(qv1);
    v2 = upcast(qv2);

    // Inlined loop (72 iterations)
    // --- Iteration 0 ---
    let (qu1_0, u1b_0) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_0, u2b_0) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_0, v1b_0) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_0, v2b_0) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_0);
    u2 = upcast(qu2_0);
    v1 = upcast(qv1_0);
    v2 = upcast(qv2_0);

    let selector_0: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_0, bounded_int::mul(u2b_0, TWO_UI)),
            bounded_int::mul(v1b_0, FOUR_UI),
        ),
        bounded_int::mul(v2b_0, EIGHT_UI),
    );
    selectors.append(upcast(selector_0));

    // --- Iteration 1 ---
    let (qu1_1, u1b_1) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_1, u2b_1) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_1, v1b_1) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_1, v2b_1) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_1);
    u2 = upcast(qu2_1);
    v1 = upcast(qv1_1);
    v2 = upcast(qv2_1);

    let selector_1: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_1, bounded_int::mul(u2b_1, TWO_UI)),
            bounded_int::mul(v1b_1, FOUR_UI),
        ),
        bounded_int::mul(v2b_1, EIGHT_UI),
    );
    selectors.append(upcast(selector_1));

    // --- Iteration 2 ---
    let (qu1_2, u1b_2) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_2, u2b_2) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_2, v1b_2) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_2, v2b_2) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_2);
    u2 = upcast(qu2_2);
    v1 = upcast(qv1_2);
    v2 = upcast(qv2_2);

    let selector_2: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_2, bounded_int::mul(u2b_2, TWO_UI)),
            bounded_int::mul(v1b_2, FOUR_UI),
        ),
        bounded_int::mul(v2b_2, EIGHT_UI),
    );
    selectors.append(upcast(selector_2));

    // --- Iteration 3 ---
    let (qu1_3, u1b_3) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_3, u2b_3) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_3, v1b_3) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_3, v2b_3) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_3);
    u2 = upcast(qu2_3);
    v1 = upcast(qv1_3);
    v2 = upcast(qv2_3);

    let selector_3: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_3, bounded_int::mul(u2b_3, TWO_UI)),
            bounded_int::mul(v1b_3, FOUR_UI),
        ),
        bounded_int::mul(v2b_3, EIGHT_UI),
    );
    selectors.append(upcast(selector_3));

    // --- Iteration 4 ---
    let (qu1_4, u1b_4) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_4, u2b_4) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_4, v1b_4) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_4, v2b_4) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_4);
    u2 = upcast(qu2_4);
    v1 = upcast(qv1_4);
    v2 = upcast(qv2_4);

    let selector_4: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_4, bounded_int::mul(u2b_4, TWO_UI)),
            bounded_int::mul(v1b_4, FOUR_UI),
        ),
        bounded_int::mul(v2b_4, EIGHT_UI),
    );
    selectors.append(upcast(selector_4));

    // --- Iteration 5 ---
    let (qu1_5, u1b_5) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_5, u2b_5) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_5, v1b_5) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_5, v2b_5) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_5);
    u2 = upcast(qu2_5);
    v1 = upcast(qv1_5);
    v2 = upcast(qv2_5);

    let selector_5: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_5, bounded_int::mul(u2b_5, TWO_UI)),
            bounded_int::mul(v1b_5, FOUR_UI),
        ),
        bounded_int::mul(v2b_5, EIGHT_UI),
    );
    selectors.append(upcast(selector_5));

    // --- Iteration 6 ---
    let (qu1_6, u1b_6) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_6, u2b_6) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_6, v1b_6) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_6, v2b_6) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_6);
    u2 = upcast(qu2_6);
    v1 = upcast(qv1_6);
    v2 = upcast(qv2_6);

    let selector_6: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_6, bounded_int::mul(u2b_6, TWO_UI)),
            bounded_int::mul(v1b_6, FOUR_UI),
        ),
        bounded_int::mul(v2b_6, EIGHT_UI),
    );
    selectors.append(upcast(selector_6));

    // --- Iteration 7 ---
    let (qu1_7, u1b_7) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_7, u2b_7) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_7, v1b_7) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_7, v2b_7) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_7);
    u2 = upcast(qu2_7);
    v1 = upcast(qv1_7);
    v2 = upcast(qv2_7);

    let selector_7: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_7, bounded_int::mul(u2b_7, TWO_UI)),
            bounded_int::mul(v1b_7, FOUR_UI),
        ),
        bounded_int::mul(v2b_7, EIGHT_UI),
    );
    selectors.append(upcast(selector_7));

    // --- Iteration 8 ---
    let (qu1_8, u1b_8) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_8, u2b_8) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_8, v1b_8) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_8, v2b_8) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_8);
    u2 = upcast(qu2_8);
    v1 = upcast(qv1_8);
    v2 = upcast(qv2_8);

    let selector_8: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_8, bounded_int::mul(u2b_8, TWO_UI)),
            bounded_int::mul(v1b_8, FOUR_UI),
        ),
        bounded_int::mul(v2b_8, EIGHT_UI),
    );
    selectors.append(upcast(selector_8));

    // --- Iteration 9 ---
    let (qu1_9, u1b_9) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_9, u2b_9) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_9, v1b_9) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_9, v2b_9) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_9);
    u2 = upcast(qu2_9);
    v1 = upcast(qv1_9);
    v2 = upcast(qv2_9);

    let selector_9: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_9, bounded_int::mul(u2b_9, TWO_UI)),
            bounded_int::mul(v1b_9, FOUR_UI),
        ),
        bounded_int::mul(v2b_9, EIGHT_UI),
    );
    selectors.append(upcast(selector_9));

    // --- Iteration 10 ---
    let (qu1_10, u1b_10) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_10, u2b_10) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_10, v1b_10) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_10, v2b_10) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_10);
    u2 = upcast(qu2_10);
    v1 = upcast(qv1_10);
    v2 = upcast(qv2_10);

    let selector_10: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_10, bounded_int::mul(u2b_10, TWO_UI)),
            bounded_int::mul(v1b_10, FOUR_UI),
        ),
        bounded_int::mul(v2b_10, EIGHT_UI),
    );
    selectors.append(upcast(selector_10));

    // --- Iteration 11 ---
    let (qu1_11, u1b_11) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_11, u2b_11) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_11, v1b_11) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_11, v2b_11) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_11);
    u2 = upcast(qu2_11);
    v1 = upcast(qv1_11);
    v2 = upcast(qv2_11);

    let selector_11: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_11, bounded_int::mul(u2b_11, TWO_UI)),
            bounded_int::mul(v1b_11, FOUR_UI),
        ),
        bounded_int::mul(v2b_11, EIGHT_UI),
    );
    selectors.append(upcast(selector_11));

    // --- Iteration 12 ---
    let (qu1_12, u1b_12) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_12, u2b_12) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_12, v1b_12) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_12, v2b_12) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_12);
    u2 = upcast(qu2_12);
    v1 = upcast(qv1_12);
    v2 = upcast(qv2_12);

    let selector_12: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_12, bounded_int::mul(u2b_12, TWO_UI)),
            bounded_int::mul(v1b_12, FOUR_UI),
        ),
        bounded_int::mul(v2b_12, EIGHT_UI),
    );
    selectors.append(upcast(selector_12));

    // --- Iteration 13 ---
    let (qu1_13, u1b_13) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_13, u2b_13) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_13, v1b_13) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_13, v2b_13) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_13);
    u2 = upcast(qu2_13);
    v1 = upcast(qv1_13);
    v2 = upcast(qv2_13);

    let selector_13: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_13, bounded_int::mul(u2b_13, TWO_UI)),
            bounded_int::mul(v1b_13, FOUR_UI),
        ),
        bounded_int::mul(v2b_13, EIGHT_UI),
    );
    selectors.append(upcast(selector_13));

    // --- Iteration 14 ---
    let (qu1_14, u1b_14) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_14, u2b_14) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_14, v1b_14) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_14, v2b_14) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_14);
    u2 = upcast(qu2_14);
    v1 = upcast(qv1_14);
    v2 = upcast(qv2_14);

    let selector_14: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_14, bounded_int::mul(u2b_14, TWO_UI)),
            bounded_int::mul(v1b_14, FOUR_UI),
        ),
        bounded_int::mul(v2b_14, EIGHT_UI),
    );
    selectors.append(upcast(selector_14));

    // --- Iteration 15 ---
    let (qu1_15, u1b_15) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_15, u2b_15) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_15, v1b_15) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_15, v2b_15) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_15);
    u2 = upcast(qu2_15);
    v1 = upcast(qv1_15);
    v2 = upcast(qv2_15);

    let selector_15: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_15, bounded_int::mul(u2b_15, TWO_UI)),
            bounded_int::mul(v1b_15, FOUR_UI),
        ),
        bounded_int::mul(v2b_15, EIGHT_UI),
    );
    selectors.append(upcast(selector_15));

    // --- Iteration 16 ---
    let (qu1_16, u1b_16) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_16, u2b_16) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_16, v1b_16) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_16, v2b_16) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_16);
    u2 = upcast(qu2_16);
    v1 = upcast(qv1_16);
    v2 = upcast(qv2_16);

    let selector_16: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_16, bounded_int::mul(u2b_16, TWO_UI)),
            bounded_int::mul(v1b_16, FOUR_UI),
        ),
        bounded_int::mul(v2b_16, EIGHT_UI),
    );
    selectors.append(upcast(selector_16));

    // --- Iteration 17 ---
    let (qu1_17, u1b_17) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_17, u2b_17) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_17, v1b_17) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_17, v2b_17) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_17);
    u2 = upcast(qu2_17);
    v1 = upcast(qv1_17);
    v2 = upcast(qv2_17);

    let selector_17: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_17, bounded_int::mul(u2b_17, TWO_UI)),
            bounded_int::mul(v1b_17, FOUR_UI),
        ),
        bounded_int::mul(v2b_17, EIGHT_UI),
    );
    selectors.append(upcast(selector_17));

    // --- Iteration 18 ---
    let (qu1_18, u1b_18) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_18, u2b_18) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_18, v1b_18) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_18, v2b_18) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_18);
    u2 = upcast(qu2_18);
    v1 = upcast(qv1_18);
    v2 = upcast(qv2_18);

    let selector_18: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_18, bounded_int::mul(u2b_18, TWO_UI)),
            bounded_int::mul(v1b_18, FOUR_UI),
        ),
        bounded_int::mul(v2b_18, EIGHT_UI),
    );
    selectors.append(upcast(selector_18));

    // --- Iteration 19 ---
    let (qu1_19, u1b_19) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_19, u2b_19) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_19, v1b_19) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_19, v2b_19) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_19);
    u2 = upcast(qu2_19);
    v1 = upcast(qv1_19);
    v2 = upcast(qv2_19);

    let selector_19: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_19, bounded_int::mul(u2b_19, TWO_UI)),
            bounded_int::mul(v1b_19, FOUR_UI),
        ),
        bounded_int::mul(v2b_19, EIGHT_UI),
    );
    selectors.append(upcast(selector_19));

    // --- Iteration 20 ---
    let (qu1_20, u1b_20) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_20, u2b_20) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_20, v1b_20) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_20, v2b_20) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_20);
    u2 = upcast(qu2_20);
    v1 = upcast(qv1_20);
    v2 = upcast(qv2_20);

    let selector_20: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_20, bounded_int::mul(u2b_20, TWO_UI)),
            bounded_int::mul(v1b_20, FOUR_UI),
        ),
        bounded_int::mul(v2b_20, EIGHT_UI),
    );
    selectors.append(upcast(selector_20));

    // --- Iteration 21 ---
    let (qu1_21, u1b_21) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_21, u2b_21) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_21, v1b_21) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_21, v2b_21) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_21);
    u2 = upcast(qu2_21);
    v1 = upcast(qv1_21);
    v2 = upcast(qv2_21);

    let selector_21: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_21, bounded_int::mul(u2b_21, TWO_UI)),
            bounded_int::mul(v1b_21, FOUR_UI),
        ),
        bounded_int::mul(v2b_21, EIGHT_UI),
    );
    selectors.append(upcast(selector_21));

    // --- Iteration 22 ---
    let (qu1_22, u1b_22) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_22, u2b_22) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_22, v1b_22) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_22, v2b_22) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_22);
    u2 = upcast(qu2_22);
    v1 = upcast(qv1_22);
    v2 = upcast(qv2_22);

    let selector_22: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_22, bounded_int::mul(u2b_22, TWO_UI)),
            bounded_int::mul(v1b_22, FOUR_UI),
        ),
        bounded_int::mul(v2b_22, EIGHT_UI),
    );
    selectors.append(upcast(selector_22));

    // --- Iteration 23 ---
    let (qu1_23, u1b_23) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_23, u2b_23) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_23, v1b_23) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_23, v2b_23) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_23);
    u2 = upcast(qu2_23);
    v1 = upcast(qv1_23);
    v2 = upcast(qv2_23);

    let selector_23: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_23, bounded_int::mul(u2b_23, TWO_UI)),
            bounded_int::mul(v1b_23, FOUR_UI),
        ),
        bounded_int::mul(v2b_23, EIGHT_UI),
    );
    selectors.append(upcast(selector_23));

    // --- Iteration 24 ---
    let (qu1_24, u1b_24) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_24, u2b_24) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_24, v1b_24) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_24, v2b_24) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_24);
    u2 = upcast(qu2_24);
    v1 = upcast(qv1_24);
    v2 = upcast(qv2_24);

    let selector_24: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_24, bounded_int::mul(u2b_24, TWO_UI)),
            bounded_int::mul(v1b_24, FOUR_UI),
        ),
        bounded_int::mul(v2b_24, EIGHT_UI),
    );
    selectors.append(upcast(selector_24));

    // --- Iteration 25 ---
    let (qu1_25, u1b_25) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_25, u2b_25) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_25, v1b_25) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_25, v2b_25) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_25);
    u2 = upcast(qu2_25);
    v1 = upcast(qv1_25);
    v2 = upcast(qv2_25);

    let selector_25: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_25, bounded_int::mul(u2b_25, TWO_UI)),
            bounded_int::mul(v1b_25, FOUR_UI),
        ),
        bounded_int::mul(v2b_25, EIGHT_UI),
    );
    selectors.append(upcast(selector_25));

    // --- Iteration 26 ---
    let (qu1_26, u1b_26) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_26, u2b_26) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_26, v1b_26) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_26, v2b_26) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_26);
    u2 = upcast(qu2_26);
    v1 = upcast(qv1_26);
    v2 = upcast(qv2_26);

    let selector_26: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_26, bounded_int::mul(u2b_26, TWO_UI)),
            bounded_int::mul(v1b_26, FOUR_UI),
        ),
        bounded_int::mul(v2b_26, EIGHT_UI),
    );
    selectors.append(upcast(selector_26));

    // --- Iteration 27 ---
    let (qu1_27, u1b_27) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_27, u2b_27) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_27, v1b_27) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_27, v2b_27) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_27);
    u2 = upcast(qu2_27);
    v1 = upcast(qv1_27);
    v2 = upcast(qv2_27);

    let selector_27: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_27, bounded_int::mul(u2b_27, TWO_UI)),
            bounded_int::mul(v1b_27, FOUR_UI),
        ),
        bounded_int::mul(v2b_27, EIGHT_UI),
    );
    selectors.append(upcast(selector_27));

    // --- Iteration 28 ---
    let (qu1_28, u1b_28) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_28, u2b_28) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_28, v1b_28) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_28, v2b_28) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_28);
    u2 = upcast(qu2_28);
    v1 = upcast(qv1_28);
    v2 = upcast(qv2_28);

    let selector_28: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_28, bounded_int::mul(u2b_28, TWO_UI)),
            bounded_int::mul(v1b_28, FOUR_UI),
        ),
        bounded_int::mul(v2b_28, EIGHT_UI),
    );
    selectors.append(upcast(selector_28));

    // --- Iteration 29 ---
    let (qu1_29, u1b_29) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_29, u2b_29) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_29, v1b_29) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_29, v2b_29) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_29);
    u2 = upcast(qu2_29);
    v1 = upcast(qv1_29);
    v2 = upcast(qv2_29);

    let selector_29: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_29, bounded_int::mul(u2b_29, TWO_UI)),
            bounded_int::mul(v1b_29, FOUR_UI),
        ),
        bounded_int::mul(v2b_29, EIGHT_UI),
    );
    selectors.append(upcast(selector_29));

    // --- Iteration 30 ---
    let (qu1_30, u1b_30) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_30, u2b_30) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_30, v1b_30) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_30, v2b_30) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_30);
    u2 = upcast(qu2_30);
    v1 = upcast(qv1_30);
    v2 = upcast(qv2_30);

    let selector_30: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_30, bounded_int::mul(u2b_30, TWO_UI)),
            bounded_int::mul(v1b_30, FOUR_UI),
        ),
        bounded_int::mul(v2b_30, EIGHT_UI),
    );
    selectors.append(upcast(selector_30));

    // --- Iteration 31 ---
    let (qu1_31, u1b_31) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_31, u2b_31) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_31, v1b_31) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_31, v2b_31) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_31);
    u2 = upcast(qu2_31);
    v1 = upcast(qv1_31);
    v2 = upcast(qv2_31);

    let selector_31: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_31, bounded_int::mul(u2b_31, TWO_UI)),
            bounded_int::mul(v1b_31, FOUR_UI),
        ),
        bounded_int::mul(v2b_31, EIGHT_UI),
    );
    selectors.append(upcast(selector_31));

    // --- Iteration 32 ---
    let (qu1_32, u1b_32) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_32, u2b_32) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_32, v1b_32) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_32, v2b_32) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_32);
    u2 = upcast(qu2_32);
    v1 = upcast(qv1_32);
    v2 = upcast(qv2_32);

    let selector_32: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_32, bounded_int::mul(u2b_32, TWO_UI)),
            bounded_int::mul(v1b_32, FOUR_UI),
        ),
        bounded_int::mul(v2b_32, EIGHT_UI),
    );
    selectors.append(upcast(selector_32));

    // --- Iteration 33 ---
    let (qu1_33, u1b_33) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_33, u2b_33) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_33, v1b_33) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_33, v2b_33) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_33);
    u2 = upcast(qu2_33);
    v1 = upcast(qv1_33);
    v2 = upcast(qv2_33);

    let selector_33: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_33, bounded_int::mul(u2b_33, TWO_UI)),
            bounded_int::mul(v1b_33, FOUR_UI),
        ),
        bounded_int::mul(v2b_33, EIGHT_UI),
    );
    selectors.append(upcast(selector_33));

    // --- Iteration 34 ---
    let (qu1_34, u1b_34) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_34, u2b_34) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_34, v1b_34) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_34, v2b_34) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_34);
    u2 = upcast(qu2_34);
    v1 = upcast(qv1_34);
    v2 = upcast(qv2_34);

    let selector_34: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_34, bounded_int::mul(u2b_34, TWO_UI)),
            bounded_int::mul(v1b_34, FOUR_UI),
        ),
        bounded_int::mul(v2b_34, EIGHT_UI),
    );
    selectors.append(upcast(selector_34));

    // --- Iteration 35 ---
    let (qu1_35, u1b_35) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_35, u2b_35) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_35, v1b_35) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_35, v2b_35) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_35);
    u2 = upcast(qu2_35);
    v1 = upcast(qv1_35);
    v2 = upcast(qv2_35);

    let selector_35: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_35, bounded_int::mul(u2b_35, TWO_UI)),
            bounded_int::mul(v1b_35, FOUR_UI),
        ),
        bounded_int::mul(v2b_35, EIGHT_UI),
    );
    selectors.append(upcast(selector_35));

    // --- Iteration 36 ---
    let (qu1_36, u1b_36) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_36, u2b_36) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_36, v1b_36) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_36, v2b_36) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_36);
    u2 = upcast(qu2_36);
    v1 = upcast(qv1_36);
    v2 = upcast(qv2_36);

    let selector_36: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_36, bounded_int::mul(u2b_36, TWO_UI)),
            bounded_int::mul(v1b_36, FOUR_UI),
        ),
        bounded_int::mul(v2b_36, EIGHT_UI),
    );
    selectors.append(upcast(selector_36));

    // --- Iteration 37 ---
    let (qu1_37, u1b_37) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_37, u2b_37) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_37, v1b_37) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_37, v2b_37) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_37);
    u2 = upcast(qu2_37);
    v1 = upcast(qv1_37);
    v2 = upcast(qv2_37);

    let selector_37: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_37, bounded_int::mul(u2b_37, TWO_UI)),
            bounded_int::mul(v1b_37, FOUR_UI),
        ),
        bounded_int::mul(v2b_37, EIGHT_UI),
    );
    selectors.append(upcast(selector_37));

    // --- Iteration 38 ---
    let (qu1_38, u1b_38) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_38, u2b_38) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_38, v1b_38) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_38, v2b_38) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_38);
    u2 = upcast(qu2_38);
    v1 = upcast(qv1_38);
    v2 = upcast(qv2_38);

    let selector_38: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_38, bounded_int::mul(u2b_38, TWO_UI)),
            bounded_int::mul(v1b_38, FOUR_UI),
        ),
        bounded_int::mul(v2b_38, EIGHT_UI),
    );
    selectors.append(upcast(selector_38));

    // --- Iteration 39 ---
    let (qu1_39, u1b_39) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_39, u2b_39) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_39, v1b_39) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_39, v2b_39) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_39);
    u2 = upcast(qu2_39);
    v1 = upcast(qv1_39);
    v2 = upcast(qv2_39);

    let selector_39: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_39, bounded_int::mul(u2b_39, TWO_UI)),
            bounded_int::mul(v1b_39, FOUR_UI),
        ),
        bounded_int::mul(v2b_39, EIGHT_UI),
    );
    selectors.append(upcast(selector_39));

    // --- Iteration 40 ---
    let (qu1_40, u1b_40) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_40, u2b_40) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_40, v1b_40) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_40, v2b_40) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_40);
    u2 = upcast(qu2_40);
    v1 = upcast(qv1_40);
    v2 = upcast(qv2_40);

    let selector_40: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_40, bounded_int::mul(u2b_40, TWO_UI)),
            bounded_int::mul(v1b_40, FOUR_UI),
        ),
        bounded_int::mul(v2b_40, EIGHT_UI),
    );
    selectors.append(upcast(selector_40));

    // --- Iteration 41 ---
    let (qu1_41, u1b_41) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_41, u2b_41) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_41, v1b_41) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_41, v2b_41) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_41);
    u2 = upcast(qu2_41);
    v1 = upcast(qv1_41);
    v2 = upcast(qv2_41);

    let selector_41: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_41, bounded_int::mul(u2b_41, TWO_UI)),
            bounded_int::mul(v1b_41, FOUR_UI),
        ),
        bounded_int::mul(v2b_41, EIGHT_UI),
    );
    selectors.append(upcast(selector_41));

    // --- Iteration 42 ---
    let (qu1_42, u1b_42) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_42, u2b_42) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_42, v1b_42) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_42, v2b_42) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_42);
    u2 = upcast(qu2_42);
    v1 = upcast(qv1_42);
    v2 = upcast(qv2_42);

    let selector_42: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_42, bounded_int::mul(u2b_42, TWO_UI)),
            bounded_int::mul(v1b_42, FOUR_UI),
        ),
        bounded_int::mul(v2b_42, EIGHT_UI),
    );
    selectors.append(upcast(selector_42));

    // --- Iteration 43 ---
    let (qu1_43, u1b_43) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_43, u2b_43) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_43, v1b_43) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_43, v2b_43) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_43);
    u2 = upcast(qu2_43);
    v1 = upcast(qv1_43);
    v2 = upcast(qv2_43);

    let selector_43: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_43, bounded_int::mul(u2b_43, TWO_UI)),
            bounded_int::mul(v1b_43, FOUR_UI),
        ),
        bounded_int::mul(v2b_43, EIGHT_UI),
    );
    selectors.append(upcast(selector_43));

    // --- Iteration 44 ---
    let (qu1_44, u1b_44) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_44, u2b_44) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_44, v1b_44) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_44, v2b_44) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_44);
    u2 = upcast(qu2_44);
    v1 = upcast(qv1_44);
    v2 = upcast(qv2_44);

    let selector_44: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_44, bounded_int::mul(u2b_44, TWO_UI)),
            bounded_int::mul(v1b_44, FOUR_UI),
        ),
        bounded_int::mul(v2b_44, EIGHT_UI),
    );
    selectors.append(upcast(selector_44));

    // --- Iteration 45 ---
    let (qu1_45, u1b_45) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_45, u2b_45) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_45, v1b_45) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_45, v2b_45) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_45);
    u2 = upcast(qu2_45);
    v1 = upcast(qv1_45);
    v2 = upcast(qv2_45);

    let selector_45: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_45, bounded_int::mul(u2b_45, TWO_UI)),
            bounded_int::mul(v1b_45, FOUR_UI),
        ),
        bounded_int::mul(v2b_45, EIGHT_UI),
    );
    selectors.append(upcast(selector_45));

    // --- Iteration 46 ---
    let (qu1_46, u1b_46) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_46, u2b_46) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_46, v1b_46) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_46, v2b_46) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_46);
    u2 = upcast(qu2_46);
    v1 = upcast(qv1_46);
    v2 = upcast(qv2_46);

    let selector_46: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_46, bounded_int::mul(u2b_46, TWO_UI)),
            bounded_int::mul(v1b_46, FOUR_UI),
        ),
        bounded_int::mul(v2b_46, EIGHT_UI),
    );
    selectors.append(upcast(selector_46));

    // --- Iteration 47 ---
    let (qu1_47, u1b_47) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_47, u2b_47) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_47, v1b_47) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_47, v2b_47) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_47);
    u2 = upcast(qu2_47);
    v1 = upcast(qv1_47);
    v2 = upcast(qv2_47);

    let selector_47: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_47, bounded_int::mul(u2b_47, TWO_UI)),
            bounded_int::mul(v1b_47, FOUR_UI),
        ),
        bounded_int::mul(v2b_47, EIGHT_UI),
    );
    selectors.append(upcast(selector_47));

    // --- Iteration 48 ---
    let (qu1_48, u1b_48) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_48, u2b_48) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_48, v1b_48) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_48, v2b_48) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_48);
    u2 = upcast(qu2_48);
    v1 = upcast(qv1_48);
    v2 = upcast(qv2_48);

    let selector_48: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_48, bounded_int::mul(u2b_48, TWO_UI)),
            bounded_int::mul(v1b_48, FOUR_UI),
        ),
        bounded_int::mul(v2b_48, EIGHT_UI),
    );
    selectors.append(upcast(selector_48));

    // --- Iteration 49 ---
    let (qu1_49, u1b_49) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_49, u2b_49) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_49, v1b_49) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_49, v2b_49) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_49);
    u2 = upcast(qu2_49);
    v1 = upcast(qv1_49);
    v2 = upcast(qv2_49);

    let selector_49: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_49, bounded_int::mul(u2b_49, TWO_UI)),
            bounded_int::mul(v1b_49, FOUR_UI),
        ),
        bounded_int::mul(v2b_49, EIGHT_UI),
    );
    selectors.append(upcast(selector_49));

    // --- Iteration 50 ---
    let (qu1_50, u1b_50) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_50, u2b_50) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_50, v1b_50) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_50, v2b_50) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_50);
    u2 = upcast(qu2_50);
    v1 = upcast(qv1_50);
    v2 = upcast(qv2_50);

    let selector_50: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_50, bounded_int::mul(u2b_50, TWO_UI)),
            bounded_int::mul(v1b_50, FOUR_UI),
        ),
        bounded_int::mul(v2b_50, EIGHT_UI),
    );
    selectors.append(upcast(selector_50));

    // --- Iteration 51 ---
    let (qu1_51, u1b_51) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_51, u2b_51) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_51, v1b_51) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_51, v2b_51) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_51);
    u2 = upcast(qu2_51);
    v1 = upcast(qv1_51);
    v2 = upcast(qv2_51);

    let selector_51: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_51, bounded_int::mul(u2b_51, TWO_UI)),
            bounded_int::mul(v1b_51, FOUR_UI),
        ),
        bounded_int::mul(v2b_51, EIGHT_UI),
    );
    selectors.append(upcast(selector_51));

    // --- Iteration 52 ---
    let (qu1_52, u1b_52) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_52, u2b_52) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_52, v1b_52) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_52, v2b_52) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_52);
    u2 = upcast(qu2_52);
    v1 = upcast(qv1_52);
    v2 = upcast(qv2_52);

    let selector_52: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_52, bounded_int::mul(u2b_52, TWO_UI)),
            bounded_int::mul(v1b_52, FOUR_UI),
        ),
        bounded_int::mul(v2b_52, EIGHT_UI),
    );
    selectors.append(upcast(selector_52));

    // --- Iteration 53 ---
    let (qu1_53, u1b_53) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_53, u2b_53) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_53, v1b_53) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_53, v2b_53) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_53);
    u2 = upcast(qu2_53);
    v1 = upcast(qv1_53);
    v2 = upcast(qv2_53);

    let selector_53: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_53, bounded_int::mul(u2b_53, TWO_UI)),
            bounded_int::mul(v1b_53, FOUR_UI),
        ),
        bounded_int::mul(v2b_53, EIGHT_UI),
    );
    selectors.append(upcast(selector_53));

    // --- Iteration 54 ---
    let (qu1_54, u1b_54) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_54, u2b_54) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_54, v1b_54) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_54, v2b_54) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_54);
    u2 = upcast(qu2_54);
    v1 = upcast(qv1_54);
    v2 = upcast(qv2_54);

    let selector_54: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_54, bounded_int::mul(u2b_54, TWO_UI)),
            bounded_int::mul(v1b_54, FOUR_UI),
        ),
        bounded_int::mul(v2b_54, EIGHT_UI),
    );
    selectors.append(upcast(selector_54));

    // --- Iteration 55 ---
    let (qu1_55, u1b_55) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_55, u2b_55) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_55, v1b_55) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_55, v2b_55) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_55);
    u2 = upcast(qu2_55);
    v1 = upcast(qv1_55);
    v2 = upcast(qv2_55);

    let selector_55: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_55, bounded_int::mul(u2b_55, TWO_UI)),
            bounded_int::mul(v1b_55, FOUR_UI),
        ),
        bounded_int::mul(v2b_55, EIGHT_UI),
    );
    selectors.append(upcast(selector_55));

    // --- Iteration 56 ---
    let (qu1_56, u1b_56) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_56, u2b_56) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_56, v1b_56) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_56, v2b_56) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_56);
    u2 = upcast(qu2_56);
    v1 = upcast(qv1_56);
    v2 = upcast(qv2_56);

    let selector_56: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_56, bounded_int::mul(u2b_56, TWO_UI)),
            bounded_int::mul(v1b_56, FOUR_UI),
        ),
        bounded_int::mul(v2b_56, EIGHT_UI),
    );
    selectors.append(upcast(selector_56));

    // --- Iteration 57 ---
    let (qu1_57, u1b_57) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_57, u2b_57) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_57, v1b_57) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_57, v2b_57) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_57);
    u2 = upcast(qu2_57);
    v1 = upcast(qv1_57);
    v2 = upcast(qv2_57);

    let selector_57: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_57, bounded_int::mul(u2b_57, TWO_UI)),
            bounded_int::mul(v1b_57, FOUR_UI),
        ),
        bounded_int::mul(v2b_57, EIGHT_UI),
    );
    selectors.append(upcast(selector_57));

    // --- Iteration 58 ---
    let (qu1_58, u1b_58) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_58, u2b_58) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_58, v1b_58) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_58, v2b_58) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_58);
    u2 = upcast(qu2_58);
    v1 = upcast(qv1_58);
    v2 = upcast(qv2_58);

    let selector_58: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_58, bounded_int::mul(u2b_58, TWO_UI)),
            bounded_int::mul(v1b_58, FOUR_UI),
        ),
        bounded_int::mul(v2b_58, EIGHT_UI),
    );
    selectors.append(upcast(selector_58));

    // --- Iteration 59 ---
    let (qu1_59, u1b_59) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_59, u2b_59) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_59, v1b_59) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_59, v2b_59) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_59);
    u2 = upcast(qu2_59);
    v1 = upcast(qv1_59);
    v2 = upcast(qv2_59);

    let selector_59: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_59, bounded_int::mul(u2b_59, TWO_UI)),
            bounded_int::mul(v1b_59, FOUR_UI),
        ),
        bounded_int::mul(v2b_59, EIGHT_UI),
    );
    selectors.append(upcast(selector_59));

    // --- Iteration 60 ---
    let (qu1_60, u1b_60) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_60, u2b_60) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_60, v1b_60) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_60, v2b_60) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_60);
    u2 = upcast(qu2_60);
    v1 = upcast(qv1_60);
    v2 = upcast(qv2_60);

    let selector_60: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_60, bounded_int::mul(u2b_60, TWO_UI)),
            bounded_int::mul(v1b_60, FOUR_UI),
        ),
        bounded_int::mul(v2b_60, EIGHT_UI),
    );
    selectors.append(upcast(selector_60));

    // --- Iteration 61 ---
    let (qu1_61, u1b_61) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_61, u2b_61) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_61, v1b_61) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_61, v2b_61) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_61);
    u2 = upcast(qu2_61);
    v1 = upcast(qv1_61);
    v2 = upcast(qv2_61);

    let selector_61: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_61, bounded_int::mul(u2b_61, TWO_UI)),
            bounded_int::mul(v1b_61, FOUR_UI),
        ),
        bounded_int::mul(v2b_61, EIGHT_UI),
    );
    selectors.append(upcast(selector_61));

    // --- Iteration 62 ---
    let (qu1_62, u1b_62) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_62, u2b_62) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_62, v1b_62) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_62, v2b_62) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_62);
    u2 = upcast(qu2_62);
    v1 = upcast(qv1_62);
    v2 = upcast(qv2_62);

    let selector_62: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_62, bounded_int::mul(u2b_62, TWO_UI)),
            bounded_int::mul(v1b_62, FOUR_UI),
        ),
        bounded_int::mul(v2b_62, EIGHT_UI),
    );
    selectors.append(upcast(selector_62));

    // --- Iteration 63 ---
    let (qu1_63, u1b_63) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_63, u2b_63) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_63, v1b_63) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_63, v2b_63) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_63);
    u2 = upcast(qu2_63);
    v1 = upcast(qv1_63);
    v2 = upcast(qv2_63);

    let selector_63: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_63, bounded_int::mul(u2b_63, TWO_UI)),
            bounded_int::mul(v1b_63, FOUR_UI),
        ),
        bounded_int::mul(v2b_63, EIGHT_UI),
    );
    selectors.append(upcast(selector_63));

    // --- Iteration 64 ---
    let (qu1_64, u1b_64) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_64, u2b_64) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_64, v1b_64) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_64, v2b_64) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_64);
    u2 = upcast(qu2_64);
    v1 = upcast(qv1_64);
    v2 = upcast(qv2_64);

    let selector_64: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_64, bounded_int::mul(u2b_64, TWO_UI)),
            bounded_int::mul(v1b_64, FOUR_UI),
        ),
        bounded_int::mul(v2b_64, EIGHT_UI),
    );
    selectors.append(upcast(selector_64));

    // --- Iteration 65 ---
    let (qu1_65, u1b_65) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_65, u2b_65) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_65, v1b_65) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_65, v2b_65) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_65);
    u2 = upcast(qu2_65);
    v1 = upcast(qv1_65);
    v2 = upcast(qv2_65);

    let selector_65: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_65, bounded_int::mul(u2b_65, TWO_UI)),
            bounded_int::mul(v1b_65, FOUR_UI),
        ),
        bounded_int::mul(v2b_65, EIGHT_UI),
    );
    selectors.append(upcast(selector_65));

    // --- Iteration 66 ---
    let (qu1_66, u1b_66) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_66, u2b_66) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_66, v1b_66) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_66, v2b_66) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_66);
    u2 = upcast(qu2_66);
    v1 = upcast(qv1_66);
    v2 = upcast(qv2_66);

    let selector_66: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_66, bounded_int::mul(u2b_66, TWO_UI)),
            bounded_int::mul(v1b_66, FOUR_UI),
        ),
        bounded_int::mul(v2b_66, EIGHT_UI),
    );
    selectors.append(upcast(selector_66));

    // --- Iteration 67 ---
    let (qu1_67, u1b_67) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_67, u2b_67) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_67, v1b_67) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_67, v2b_67) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_67);
    u2 = upcast(qu2_67);
    v1 = upcast(qv1_67);
    v2 = upcast(qv2_67);

    let selector_67: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_67, bounded_int::mul(u2b_67, TWO_UI)),
            bounded_int::mul(v1b_67, FOUR_UI),
        ),
        bounded_int::mul(v2b_67, EIGHT_UI),
    );
    selectors.append(upcast(selector_67));

    // --- Iteration 68 ---
    let (qu1_68, u1b_68) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_68, u2b_68) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_68, v1b_68) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_68, v2b_68) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_68);
    u2 = upcast(qu2_68);
    v1 = upcast(qv1_68);
    v2 = upcast(qv2_68);

    let selector_68: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_68, bounded_int::mul(u2b_68, TWO_UI)),
            bounded_int::mul(v1b_68, FOUR_UI),
        ),
        bounded_int::mul(v2b_68, EIGHT_UI),
    );
    selectors.append(upcast(selector_68));

    // --- Iteration 69 ---
    let (qu1_69, u1b_69) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_69, u2b_69) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_69, v1b_69) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_69, v2b_69) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_69);
    u2 = upcast(qu2_69);
    v1 = upcast(qv1_69);
    v2 = upcast(qv2_69);

    let selector_69: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_69, bounded_int::mul(u2b_69, TWO_UI)),
            bounded_int::mul(v1b_69, FOUR_UI),
        ),
        bounded_int::mul(v2b_69, EIGHT_UI),
    );
    selectors.append(upcast(selector_69));

    // --- Iteration 70 ---
    let (qu1_70, u1b_70) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_70, u2b_70) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_70, v1b_70) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_70, v2b_70) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_70);
    u2 = upcast(qu2_70);
    v1 = upcast(qv1_70);
    v2 = upcast(qv2_70);

    let selector_70: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b_70, bounded_int::mul(u2b_70, TWO_UI)),
            bounded_int::mul(v1b_70, FOUR_UI),
        ),
        bounded_int::mul(v2b_70, EIGHT_UI),
    );
    selectors.append(upcast(selector_70));

    if bits_73 {
        // --- Iteration 71 --- (secp256k1)
        let (qu1_71, u1b_71) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
        let (qu2_71, u2b_71) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
        let (qv1_71, v1b_71) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
        let (qv2_71, v2b_71) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
        u1 = upcast(qu1_71);
        u2 = upcast(qu2_71);
        v1 = upcast(qv1_71);
        v2 = upcast(qv2_71);

        let selector_71: u15_bi = bounded_int::add(
            bounded_int::add(
                bounded_int::add(u1b_71, bounded_int::mul(u2b_71, TWO_UI)),
                bounded_int::mul(v1b_71, FOUR_UI),
            ),
            bounded_int::mul(v2b_71, EIGHT_UI),
        );
        selectors.append(upcast(selector_71));
    }

    return (selectors.span(), upcast(u1lsb), upcast(u2lsb), upcast(v1lsb), upcast(v2lsb));
}
