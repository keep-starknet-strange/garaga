use core::internal::bounded_int;
use core::internal::bounded_int::{BoundedInt, DivRemHelper, UnitInt, upcast};


const TWO: felt252 = 2;
const TWO_NZ_TYPED: NonZero<UnitInt<TWO>> = 2;
const POW128_DIV_2: felt252 = 0x7fffffffffffffffffffffffffffffff; // ((2^128-1) // 2)
const POW128: felt252 = 0x100000000000000000000000000000000;

impl DivRemU128By2 of DivRemHelper<BoundedInt<0, { POW128 - 1 }>, UnitInt<TWO>> {
    type DivT = BoundedInt<0, { POW128_DIV_2 }>;
    type RemT = BoundedInt<0, { TWO - 1 }>;
}


#[inline(always)]
pub fn build_selectors_inlined(
    _u1: u128, _u2: u128, _v1: u128, _v2: u128,
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

    let selector_0: felt252 = u1b_0.into() + 2 * u2b_0.into() + 4 * v1b_0.into() + 8 * v2b_0.into();
    let selector_0_usize: usize = selector_0.try_into().unwrap();
    selectors.append(selector_0_usize);

    // --- Iteration 1 ---
    let (qu1_1, u1b_1) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_1, u2b_1) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_1, v1b_1) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_1, v2b_1) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_1);
    u2 = upcast(qu2_1);
    v1 = upcast(qv1_1);
    v2 = upcast(qv2_1);

    let selector_1: felt252 = u1b_1.into() + 2 * u2b_1.into() + 4 * v1b_1.into() + 8 * v2b_1.into();
    let selector_1_usize: usize = selector_1.try_into().unwrap();
    selectors.append(selector_1_usize);

    // --- Iteration 2 ---
    let (qu1_2, u1b_2) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_2, u2b_2) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_2, v1b_2) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_2, v2b_2) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_2);
    u2 = upcast(qu2_2);
    v1 = upcast(qv1_2);
    v2 = upcast(qv2_2);

    let selector_2: felt252 = u1b_2.into() + 2 * u2b_2.into() + 4 * v1b_2.into() + 8 * v2b_2.into();
    let selector_2_usize: usize = selector_2.try_into().unwrap();
    selectors.append(selector_2_usize);

    // --- Iteration 3 ---
    let (qu1_3, u1b_3) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_3, u2b_3) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_3, v1b_3) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_3, v2b_3) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_3);
    u2 = upcast(qu2_3);
    v1 = upcast(qv1_3);
    v2 = upcast(qv2_3);

    let selector_3: felt252 = u1b_3.into() + 2 * u2b_3.into() + 4 * v1b_3.into() + 8 * v2b_3.into();
    let selector_3_usize: usize = selector_3.try_into().unwrap();
    selectors.append(selector_3_usize);

    // --- Iteration 4 ---
    let (qu1_4, u1b_4) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_4, u2b_4) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_4, v1b_4) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_4, v2b_4) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_4);
    u2 = upcast(qu2_4);
    v1 = upcast(qv1_4);
    v2 = upcast(qv2_4);

    let selector_4: felt252 = u1b_4.into() + 2 * u2b_4.into() + 4 * v1b_4.into() + 8 * v2b_4.into();
    let selector_4_usize: usize = selector_4.try_into().unwrap();
    selectors.append(selector_4_usize);

    // --- Iteration 5 ---
    let (qu1_5, u1b_5) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_5, u2b_5) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_5, v1b_5) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_5, v2b_5) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_5);
    u2 = upcast(qu2_5);
    v1 = upcast(qv1_5);
    v2 = upcast(qv2_5);

    let selector_5: felt252 = u1b_5.into() + 2 * u2b_5.into() + 4 * v1b_5.into() + 8 * v2b_5.into();
    let selector_5_usize: usize = selector_5.try_into().unwrap();
    selectors.append(selector_5_usize);

    // --- Iteration 6 ---
    let (qu1_6, u1b_6) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_6, u2b_6) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_6, v1b_6) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_6, v2b_6) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_6);
    u2 = upcast(qu2_6);
    v1 = upcast(qv1_6);
    v2 = upcast(qv2_6);

    let selector_6: felt252 = u1b_6.into() + 2 * u2b_6.into() + 4 * v1b_6.into() + 8 * v2b_6.into();
    let selector_6_usize: usize = selector_6.try_into().unwrap();
    selectors.append(selector_6_usize);

    // --- Iteration 7 ---
    let (qu1_7, u1b_7) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_7, u2b_7) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_7, v1b_7) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_7, v2b_7) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_7);
    u2 = upcast(qu2_7);
    v1 = upcast(qv1_7);
    v2 = upcast(qv2_7);

    let selector_7: felt252 = u1b_7.into() + 2 * u2b_7.into() + 4 * v1b_7.into() + 8 * v2b_7.into();
    let selector_7_usize: usize = selector_7.try_into().unwrap();
    selectors.append(selector_7_usize);

    // --- Iteration 8 ---
    let (qu1_8, u1b_8) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_8, u2b_8) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_8, v1b_8) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_8, v2b_8) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_8);
    u2 = upcast(qu2_8);
    v1 = upcast(qv1_8);
    v2 = upcast(qv2_8);

    let selector_8: felt252 = u1b_8.into() + 2 * u2b_8.into() + 4 * v1b_8.into() + 8 * v2b_8.into();
    let selector_8_usize: usize = selector_8.try_into().unwrap();
    selectors.append(selector_8_usize);

    // --- Iteration 9 ---
    let (qu1_9, u1b_9) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_9, u2b_9) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_9, v1b_9) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_9, v2b_9) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_9);
    u2 = upcast(qu2_9);
    v1 = upcast(qv1_9);
    v2 = upcast(qv2_9);

    let selector_9: felt252 = u1b_9.into() + 2 * u2b_9.into() + 4 * v1b_9.into() + 8 * v2b_9.into();
    let selector_9_usize: usize = selector_9.try_into().unwrap();
    selectors.append(selector_9_usize);

    // --- Iteration 10 ---
    let (qu1_10, u1b_10) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_10, u2b_10) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_10, v1b_10) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_10, v2b_10) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_10);
    u2 = upcast(qu2_10);
    v1 = upcast(qv1_10);
    v2 = upcast(qv2_10);

    let selector_10: felt252 = u1b_10.into()
        + 2 * u2b_10.into()
        + 4 * v1b_10.into()
        + 8 * v2b_10.into();
    let selector_10_usize: usize = selector_10.try_into().unwrap();
    selectors.append(selector_10_usize);

    // --- Iteration 11 ---
    let (qu1_11, u1b_11) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_11, u2b_11) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_11, v1b_11) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_11, v2b_11) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_11);
    u2 = upcast(qu2_11);
    v1 = upcast(qv1_11);
    v2 = upcast(qv2_11);

    let selector_11: felt252 = u1b_11.into()
        + 2 * u2b_11.into()
        + 4 * v1b_11.into()
        + 8 * v2b_11.into();
    let selector_11_usize: usize = selector_11.try_into().unwrap();
    selectors.append(selector_11_usize);

    // --- Iteration 12 ---
    let (qu1_12, u1b_12) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_12, u2b_12) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_12, v1b_12) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_12, v2b_12) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_12);
    u2 = upcast(qu2_12);
    v1 = upcast(qv1_12);
    v2 = upcast(qv2_12);

    let selector_12: felt252 = u1b_12.into()
        + 2 * u2b_12.into()
        + 4 * v1b_12.into()
        + 8 * v2b_12.into();
    let selector_12_usize: usize = selector_12.try_into().unwrap();
    selectors.append(selector_12_usize);

    // --- Iteration 13 ---
    let (qu1_13, u1b_13) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_13, u2b_13) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_13, v1b_13) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_13, v2b_13) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_13);
    u2 = upcast(qu2_13);
    v1 = upcast(qv1_13);
    v2 = upcast(qv2_13);

    let selector_13: felt252 = u1b_13.into()
        + 2 * u2b_13.into()
        + 4 * v1b_13.into()
        + 8 * v2b_13.into();
    let selector_13_usize: usize = selector_13.try_into().unwrap();
    selectors.append(selector_13_usize);

    // --- Iteration 14 ---
    let (qu1_14, u1b_14) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_14, u2b_14) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_14, v1b_14) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_14, v2b_14) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_14);
    u2 = upcast(qu2_14);
    v1 = upcast(qv1_14);
    v2 = upcast(qv2_14);

    let selector_14: felt252 = u1b_14.into()
        + 2 * u2b_14.into()
        + 4 * v1b_14.into()
        + 8 * v2b_14.into();
    let selector_14_usize: usize = selector_14.try_into().unwrap();
    selectors.append(selector_14_usize);

    // --- Iteration 15 ---
    let (qu1_15, u1b_15) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_15, u2b_15) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_15, v1b_15) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_15, v2b_15) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_15);
    u2 = upcast(qu2_15);
    v1 = upcast(qv1_15);
    v2 = upcast(qv2_15);

    let selector_15: felt252 = u1b_15.into()
        + 2 * u2b_15.into()
        + 4 * v1b_15.into()
        + 8 * v2b_15.into();
    let selector_15_usize: usize = selector_15.try_into().unwrap();
    selectors.append(selector_15_usize);

    // --- Iteration 16 ---
    let (qu1_16, u1b_16) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_16, u2b_16) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_16, v1b_16) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_16, v2b_16) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_16);
    u2 = upcast(qu2_16);
    v1 = upcast(qv1_16);
    v2 = upcast(qv2_16);

    let selector_16: felt252 = u1b_16.into()
        + 2 * u2b_16.into()
        + 4 * v1b_16.into()
        + 8 * v2b_16.into();
    let selector_16_usize: usize = selector_16.try_into().unwrap();
    selectors.append(selector_16_usize);

    // --- Iteration 17 ---
    let (qu1_17, u1b_17) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_17, u2b_17) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_17, v1b_17) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_17, v2b_17) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_17);
    u2 = upcast(qu2_17);
    v1 = upcast(qv1_17);
    v2 = upcast(qv2_17);

    let selector_17: felt252 = u1b_17.into()
        + 2 * u2b_17.into()
        + 4 * v1b_17.into()
        + 8 * v2b_17.into();
    let selector_17_usize: usize = selector_17.try_into().unwrap();
    selectors.append(selector_17_usize);

    // --- Iteration 18 ---
    let (qu1_18, u1b_18) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_18, u2b_18) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_18, v1b_18) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_18, v2b_18) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_18);
    u2 = upcast(qu2_18);
    v1 = upcast(qv1_18);
    v2 = upcast(qv2_18);

    let selector_18: felt252 = u1b_18.into()
        + 2 * u2b_18.into()
        + 4 * v1b_18.into()
        + 8 * v2b_18.into();
    let selector_18_usize: usize = selector_18.try_into().unwrap();
    selectors.append(selector_18_usize);

    // --- Iteration 19 ---
    let (qu1_19, u1b_19) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_19, u2b_19) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_19, v1b_19) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_19, v2b_19) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_19);
    u2 = upcast(qu2_19);
    v1 = upcast(qv1_19);
    v2 = upcast(qv2_19);

    let selector_19: felt252 = u1b_19.into()
        + 2 * u2b_19.into()
        + 4 * v1b_19.into()
        + 8 * v2b_19.into();
    let selector_19_usize: usize = selector_19.try_into().unwrap();
    selectors.append(selector_19_usize);

    // --- Iteration 20 ---
    let (qu1_20, u1b_20) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_20, u2b_20) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_20, v1b_20) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_20, v2b_20) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_20);
    u2 = upcast(qu2_20);
    v1 = upcast(qv1_20);
    v2 = upcast(qv2_20);

    let selector_20: felt252 = u1b_20.into()
        + 2 * u2b_20.into()
        + 4 * v1b_20.into()
        + 8 * v2b_20.into();
    let selector_20_usize: usize = selector_20.try_into().unwrap();
    selectors.append(selector_20_usize);

    // --- Iteration 21 ---
    let (qu1_21, u1b_21) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_21, u2b_21) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_21, v1b_21) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_21, v2b_21) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_21);
    u2 = upcast(qu2_21);
    v1 = upcast(qv1_21);
    v2 = upcast(qv2_21);

    let selector_21: felt252 = u1b_21.into()
        + 2 * u2b_21.into()
        + 4 * v1b_21.into()
        + 8 * v2b_21.into();
    let selector_21_usize: usize = selector_21.try_into().unwrap();
    selectors.append(selector_21_usize);

    // --- Iteration 22 ---
    let (qu1_22, u1b_22) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_22, u2b_22) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_22, v1b_22) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_22, v2b_22) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_22);
    u2 = upcast(qu2_22);
    v1 = upcast(qv1_22);
    v2 = upcast(qv2_22);

    let selector_22: felt252 = u1b_22.into()
        + 2 * u2b_22.into()
        + 4 * v1b_22.into()
        + 8 * v2b_22.into();
    let selector_22_usize: usize = selector_22.try_into().unwrap();
    selectors.append(selector_22_usize);

    // --- Iteration 23 ---
    let (qu1_23, u1b_23) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_23, u2b_23) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_23, v1b_23) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_23, v2b_23) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_23);
    u2 = upcast(qu2_23);
    v1 = upcast(qv1_23);
    v2 = upcast(qv2_23);

    let selector_23: felt252 = u1b_23.into()
        + 2 * u2b_23.into()
        + 4 * v1b_23.into()
        + 8 * v2b_23.into();
    let selector_23_usize: usize = selector_23.try_into().unwrap();
    selectors.append(selector_23_usize);

    // --- Iteration 24 ---
    let (qu1_24, u1b_24) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_24, u2b_24) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_24, v1b_24) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_24, v2b_24) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_24);
    u2 = upcast(qu2_24);
    v1 = upcast(qv1_24);
    v2 = upcast(qv2_24);

    let selector_24: felt252 = u1b_24.into()
        + 2 * u2b_24.into()
        + 4 * v1b_24.into()
        + 8 * v2b_24.into();
    let selector_24_usize: usize = selector_24.try_into().unwrap();
    selectors.append(selector_24_usize);

    // --- Iteration 25 ---
    let (qu1_25, u1b_25) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_25, u2b_25) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_25, v1b_25) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_25, v2b_25) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_25);
    u2 = upcast(qu2_25);
    v1 = upcast(qv1_25);
    v2 = upcast(qv2_25);

    let selector_25: felt252 = u1b_25.into()
        + 2 * u2b_25.into()
        + 4 * v1b_25.into()
        + 8 * v2b_25.into();
    let selector_25_usize: usize = selector_25.try_into().unwrap();
    selectors.append(selector_25_usize);

    // --- Iteration 26 ---
    let (qu1_26, u1b_26) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_26, u2b_26) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_26, v1b_26) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_26, v2b_26) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_26);
    u2 = upcast(qu2_26);
    v1 = upcast(qv1_26);
    v2 = upcast(qv2_26);

    let selector_26: felt252 = u1b_26.into()
        + 2 * u2b_26.into()
        + 4 * v1b_26.into()
        + 8 * v2b_26.into();
    let selector_26_usize: usize = selector_26.try_into().unwrap();
    selectors.append(selector_26_usize);

    // --- Iteration 27 ---
    let (qu1_27, u1b_27) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_27, u2b_27) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_27, v1b_27) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_27, v2b_27) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_27);
    u2 = upcast(qu2_27);
    v1 = upcast(qv1_27);
    v2 = upcast(qv2_27);

    let selector_27: felt252 = u1b_27.into()
        + 2 * u2b_27.into()
        + 4 * v1b_27.into()
        + 8 * v2b_27.into();
    let selector_27_usize: usize = selector_27.try_into().unwrap();
    selectors.append(selector_27_usize);

    // --- Iteration 28 ---
    let (qu1_28, u1b_28) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_28, u2b_28) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_28, v1b_28) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_28, v2b_28) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_28);
    u2 = upcast(qu2_28);
    v1 = upcast(qv1_28);
    v2 = upcast(qv2_28);

    let selector_28: felt252 = u1b_28.into()
        + 2 * u2b_28.into()
        + 4 * v1b_28.into()
        + 8 * v2b_28.into();
    let selector_28_usize: usize = selector_28.try_into().unwrap();
    selectors.append(selector_28_usize);

    // --- Iteration 29 ---
    let (qu1_29, u1b_29) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_29, u2b_29) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_29, v1b_29) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_29, v2b_29) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_29);
    u2 = upcast(qu2_29);
    v1 = upcast(qv1_29);
    v2 = upcast(qv2_29);

    let selector_29: felt252 = u1b_29.into()
        + 2 * u2b_29.into()
        + 4 * v1b_29.into()
        + 8 * v2b_29.into();
    let selector_29_usize: usize = selector_29.try_into().unwrap();
    selectors.append(selector_29_usize);

    // --- Iteration 30 ---
    let (qu1_30, u1b_30) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_30, u2b_30) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_30, v1b_30) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_30, v2b_30) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_30);
    u2 = upcast(qu2_30);
    v1 = upcast(qv1_30);
    v2 = upcast(qv2_30);

    let selector_30: felt252 = u1b_30.into()
        + 2 * u2b_30.into()
        + 4 * v1b_30.into()
        + 8 * v2b_30.into();
    let selector_30_usize: usize = selector_30.try_into().unwrap();
    selectors.append(selector_30_usize);

    // --- Iteration 31 ---
    let (qu1_31, u1b_31) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_31, u2b_31) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_31, v1b_31) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_31, v2b_31) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_31);
    u2 = upcast(qu2_31);
    v1 = upcast(qv1_31);
    v2 = upcast(qv2_31);

    let selector_31: felt252 = u1b_31.into()
        + 2 * u2b_31.into()
        + 4 * v1b_31.into()
        + 8 * v2b_31.into();
    let selector_31_usize: usize = selector_31.try_into().unwrap();
    selectors.append(selector_31_usize);

    // --- Iteration 32 ---
    let (qu1_32, u1b_32) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_32, u2b_32) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_32, v1b_32) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_32, v2b_32) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_32);
    u2 = upcast(qu2_32);
    v1 = upcast(qv1_32);
    v2 = upcast(qv2_32);

    let selector_32: felt252 = u1b_32.into()
        + 2 * u2b_32.into()
        + 4 * v1b_32.into()
        + 8 * v2b_32.into();
    let selector_32_usize: usize = selector_32.try_into().unwrap();
    selectors.append(selector_32_usize);

    // --- Iteration 33 ---
    let (qu1_33, u1b_33) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_33, u2b_33) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_33, v1b_33) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_33, v2b_33) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_33);
    u2 = upcast(qu2_33);
    v1 = upcast(qv1_33);
    v2 = upcast(qv2_33);

    let selector_33: felt252 = u1b_33.into()
        + 2 * u2b_33.into()
        + 4 * v1b_33.into()
        + 8 * v2b_33.into();
    let selector_33_usize: usize = selector_33.try_into().unwrap();
    selectors.append(selector_33_usize);

    // --- Iteration 34 ---
    let (qu1_34, u1b_34) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_34, u2b_34) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_34, v1b_34) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_34, v2b_34) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_34);
    u2 = upcast(qu2_34);
    v1 = upcast(qv1_34);
    v2 = upcast(qv2_34);

    let selector_34: felt252 = u1b_34.into()
        + 2 * u2b_34.into()
        + 4 * v1b_34.into()
        + 8 * v2b_34.into();
    let selector_34_usize: usize = selector_34.try_into().unwrap();
    selectors.append(selector_34_usize);

    // --- Iteration 35 ---
    let (qu1_35, u1b_35) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_35, u2b_35) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_35, v1b_35) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_35, v2b_35) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_35);
    u2 = upcast(qu2_35);
    v1 = upcast(qv1_35);
    v2 = upcast(qv2_35);

    let selector_35: felt252 = u1b_35.into()
        + 2 * u2b_35.into()
        + 4 * v1b_35.into()
        + 8 * v2b_35.into();
    let selector_35_usize: usize = selector_35.try_into().unwrap();
    selectors.append(selector_35_usize);

    // --- Iteration 36 ---
    let (qu1_36, u1b_36) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_36, u2b_36) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_36, v1b_36) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_36, v2b_36) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_36);
    u2 = upcast(qu2_36);
    v1 = upcast(qv1_36);
    v2 = upcast(qv2_36);

    let selector_36: felt252 = u1b_36.into()
        + 2 * u2b_36.into()
        + 4 * v1b_36.into()
        + 8 * v2b_36.into();
    let selector_36_usize: usize = selector_36.try_into().unwrap();
    selectors.append(selector_36_usize);

    // --- Iteration 37 ---
    let (qu1_37, u1b_37) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_37, u2b_37) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_37, v1b_37) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_37, v2b_37) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_37);
    u2 = upcast(qu2_37);
    v1 = upcast(qv1_37);
    v2 = upcast(qv2_37);

    let selector_37: felt252 = u1b_37.into()
        + 2 * u2b_37.into()
        + 4 * v1b_37.into()
        + 8 * v2b_37.into();
    let selector_37_usize: usize = selector_37.try_into().unwrap();
    selectors.append(selector_37_usize);

    // --- Iteration 38 ---
    let (qu1_38, u1b_38) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_38, u2b_38) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_38, v1b_38) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_38, v2b_38) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_38);
    u2 = upcast(qu2_38);
    v1 = upcast(qv1_38);
    v2 = upcast(qv2_38);

    let selector_38: felt252 = u1b_38.into()
        + 2 * u2b_38.into()
        + 4 * v1b_38.into()
        + 8 * v2b_38.into();
    let selector_38_usize: usize = selector_38.try_into().unwrap();
    selectors.append(selector_38_usize);

    // --- Iteration 39 ---
    let (qu1_39, u1b_39) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_39, u2b_39) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_39, v1b_39) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_39, v2b_39) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_39);
    u2 = upcast(qu2_39);
    v1 = upcast(qv1_39);
    v2 = upcast(qv2_39);

    let selector_39: felt252 = u1b_39.into()
        + 2 * u2b_39.into()
        + 4 * v1b_39.into()
        + 8 * v2b_39.into();
    let selector_39_usize: usize = selector_39.try_into().unwrap();
    selectors.append(selector_39_usize);

    // --- Iteration 40 ---
    let (qu1_40, u1b_40) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_40, u2b_40) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_40, v1b_40) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_40, v2b_40) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_40);
    u2 = upcast(qu2_40);
    v1 = upcast(qv1_40);
    v2 = upcast(qv2_40);

    let selector_40: felt252 = u1b_40.into()
        + 2 * u2b_40.into()
        + 4 * v1b_40.into()
        + 8 * v2b_40.into();
    let selector_40_usize: usize = selector_40.try_into().unwrap();
    selectors.append(selector_40_usize);

    // --- Iteration 41 ---
    let (qu1_41, u1b_41) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_41, u2b_41) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_41, v1b_41) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_41, v2b_41) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_41);
    u2 = upcast(qu2_41);
    v1 = upcast(qv1_41);
    v2 = upcast(qv2_41);

    let selector_41: felt252 = u1b_41.into()
        + 2 * u2b_41.into()
        + 4 * v1b_41.into()
        + 8 * v2b_41.into();
    let selector_41_usize: usize = selector_41.try_into().unwrap();
    selectors.append(selector_41_usize);

    // --- Iteration 42 ---
    let (qu1_42, u1b_42) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_42, u2b_42) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_42, v1b_42) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_42, v2b_42) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_42);
    u2 = upcast(qu2_42);
    v1 = upcast(qv1_42);
    v2 = upcast(qv2_42);

    let selector_42: felt252 = u1b_42.into()
        + 2 * u2b_42.into()
        + 4 * v1b_42.into()
        + 8 * v2b_42.into();
    let selector_42_usize: usize = selector_42.try_into().unwrap();
    selectors.append(selector_42_usize);

    // --- Iteration 43 ---
    let (qu1_43, u1b_43) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_43, u2b_43) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_43, v1b_43) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_43, v2b_43) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_43);
    u2 = upcast(qu2_43);
    v1 = upcast(qv1_43);
    v2 = upcast(qv2_43);

    let selector_43: felt252 = u1b_43.into()
        + 2 * u2b_43.into()
        + 4 * v1b_43.into()
        + 8 * v2b_43.into();
    let selector_43_usize: usize = selector_43.try_into().unwrap();
    selectors.append(selector_43_usize);

    // --- Iteration 44 ---
    let (qu1_44, u1b_44) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_44, u2b_44) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_44, v1b_44) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_44, v2b_44) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_44);
    u2 = upcast(qu2_44);
    v1 = upcast(qv1_44);
    v2 = upcast(qv2_44);

    let selector_44: felt252 = u1b_44.into()
        + 2 * u2b_44.into()
        + 4 * v1b_44.into()
        + 8 * v2b_44.into();
    let selector_44_usize: usize = selector_44.try_into().unwrap();
    selectors.append(selector_44_usize);

    // --- Iteration 45 ---
    let (qu1_45, u1b_45) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_45, u2b_45) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_45, v1b_45) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_45, v2b_45) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_45);
    u2 = upcast(qu2_45);
    v1 = upcast(qv1_45);
    v2 = upcast(qv2_45);

    let selector_45: felt252 = u1b_45.into()
        + 2 * u2b_45.into()
        + 4 * v1b_45.into()
        + 8 * v2b_45.into();
    let selector_45_usize: usize = selector_45.try_into().unwrap();
    selectors.append(selector_45_usize);

    // --- Iteration 46 ---
    let (qu1_46, u1b_46) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_46, u2b_46) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_46, v1b_46) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_46, v2b_46) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_46);
    u2 = upcast(qu2_46);
    v1 = upcast(qv1_46);
    v2 = upcast(qv2_46);

    let selector_46: felt252 = u1b_46.into()
        + 2 * u2b_46.into()
        + 4 * v1b_46.into()
        + 8 * v2b_46.into();
    let selector_46_usize: usize = selector_46.try_into().unwrap();
    selectors.append(selector_46_usize);

    // --- Iteration 47 ---
    let (qu1_47, u1b_47) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_47, u2b_47) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_47, v1b_47) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_47, v2b_47) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_47);
    u2 = upcast(qu2_47);
    v1 = upcast(qv1_47);
    v2 = upcast(qv2_47);

    let selector_47: felt252 = u1b_47.into()
        + 2 * u2b_47.into()
        + 4 * v1b_47.into()
        + 8 * v2b_47.into();
    let selector_47_usize: usize = selector_47.try_into().unwrap();
    selectors.append(selector_47_usize);

    // --- Iteration 48 ---
    let (qu1_48, u1b_48) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_48, u2b_48) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_48, v1b_48) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_48, v2b_48) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_48);
    u2 = upcast(qu2_48);
    v1 = upcast(qv1_48);
    v2 = upcast(qv2_48);

    let selector_48: felt252 = u1b_48.into()
        + 2 * u2b_48.into()
        + 4 * v1b_48.into()
        + 8 * v2b_48.into();
    let selector_48_usize: usize = selector_48.try_into().unwrap();
    selectors.append(selector_48_usize);

    // --- Iteration 49 ---
    let (qu1_49, u1b_49) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_49, u2b_49) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_49, v1b_49) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_49, v2b_49) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_49);
    u2 = upcast(qu2_49);
    v1 = upcast(qv1_49);
    v2 = upcast(qv2_49);

    let selector_49: felt252 = u1b_49.into()
        + 2 * u2b_49.into()
        + 4 * v1b_49.into()
        + 8 * v2b_49.into();
    let selector_49_usize: usize = selector_49.try_into().unwrap();
    selectors.append(selector_49_usize);

    // --- Iteration 50 ---
    let (qu1_50, u1b_50) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_50, u2b_50) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_50, v1b_50) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_50, v2b_50) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_50);
    u2 = upcast(qu2_50);
    v1 = upcast(qv1_50);
    v2 = upcast(qv2_50);

    let selector_50: felt252 = u1b_50.into()
        + 2 * u2b_50.into()
        + 4 * v1b_50.into()
        + 8 * v2b_50.into();
    let selector_50_usize: usize = selector_50.try_into().unwrap();
    selectors.append(selector_50_usize);

    // --- Iteration 51 ---
    let (qu1_51, u1b_51) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_51, u2b_51) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_51, v1b_51) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_51, v2b_51) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_51);
    u2 = upcast(qu2_51);
    v1 = upcast(qv1_51);
    v2 = upcast(qv2_51);

    let selector_51: felt252 = u1b_51.into()
        + 2 * u2b_51.into()
        + 4 * v1b_51.into()
        + 8 * v2b_51.into();
    let selector_51_usize: usize = selector_51.try_into().unwrap();
    selectors.append(selector_51_usize);

    // --- Iteration 52 ---
    let (qu1_52, u1b_52) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_52, u2b_52) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_52, v1b_52) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_52, v2b_52) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_52);
    u2 = upcast(qu2_52);
    v1 = upcast(qv1_52);
    v2 = upcast(qv2_52);

    let selector_52: felt252 = u1b_52.into()
        + 2 * u2b_52.into()
        + 4 * v1b_52.into()
        + 8 * v2b_52.into();
    let selector_52_usize: usize = selector_52.try_into().unwrap();
    selectors.append(selector_52_usize);

    // --- Iteration 53 ---
    let (qu1_53, u1b_53) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_53, u2b_53) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_53, v1b_53) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_53, v2b_53) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_53);
    u2 = upcast(qu2_53);
    v1 = upcast(qv1_53);
    v2 = upcast(qv2_53);

    let selector_53: felt252 = u1b_53.into()
        + 2 * u2b_53.into()
        + 4 * v1b_53.into()
        + 8 * v2b_53.into();
    let selector_53_usize: usize = selector_53.try_into().unwrap();
    selectors.append(selector_53_usize);

    // --- Iteration 54 ---
    let (qu1_54, u1b_54) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_54, u2b_54) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_54, v1b_54) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_54, v2b_54) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_54);
    u2 = upcast(qu2_54);
    v1 = upcast(qv1_54);
    v2 = upcast(qv2_54);

    let selector_54: felt252 = u1b_54.into()
        + 2 * u2b_54.into()
        + 4 * v1b_54.into()
        + 8 * v2b_54.into();
    let selector_54_usize: usize = selector_54.try_into().unwrap();
    selectors.append(selector_54_usize);

    // --- Iteration 55 ---
    let (qu1_55, u1b_55) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_55, u2b_55) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_55, v1b_55) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_55, v2b_55) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_55);
    u2 = upcast(qu2_55);
    v1 = upcast(qv1_55);
    v2 = upcast(qv2_55);

    let selector_55: felt252 = u1b_55.into()
        + 2 * u2b_55.into()
        + 4 * v1b_55.into()
        + 8 * v2b_55.into();
    let selector_55_usize: usize = selector_55.try_into().unwrap();
    selectors.append(selector_55_usize);

    // --- Iteration 56 ---
    let (qu1_56, u1b_56) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_56, u2b_56) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_56, v1b_56) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_56, v2b_56) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_56);
    u2 = upcast(qu2_56);
    v1 = upcast(qv1_56);
    v2 = upcast(qv2_56);

    let selector_56: felt252 = u1b_56.into()
        + 2 * u2b_56.into()
        + 4 * v1b_56.into()
        + 8 * v2b_56.into();
    let selector_56_usize: usize = selector_56.try_into().unwrap();
    selectors.append(selector_56_usize);

    // --- Iteration 57 ---
    let (qu1_57, u1b_57) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_57, u2b_57) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_57, v1b_57) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_57, v2b_57) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_57);
    u2 = upcast(qu2_57);
    v1 = upcast(qv1_57);
    v2 = upcast(qv2_57);

    let selector_57: felt252 = u1b_57.into()
        + 2 * u2b_57.into()
        + 4 * v1b_57.into()
        + 8 * v2b_57.into();
    let selector_57_usize: usize = selector_57.try_into().unwrap();
    selectors.append(selector_57_usize);

    // --- Iteration 58 ---
    let (qu1_58, u1b_58) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_58, u2b_58) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_58, v1b_58) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_58, v2b_58) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_58);
    u2 = upcast(qu2_58);
    v1 = upcast(qv1_58);
    v2 = upcast(qv2_58);

    let selector_58: felt252 = u1b_58.into()
        + 2 * u2b_58.into()
        + 4 * v1b_58.into()
        + 8 * v2b_58.into();
    let selector_58_usize: usize = selector_58.try_into().unwrap();
    selectors.append(selector_58_usize);

    // --- Iteration 59 ---
    let (qu1_59, u1b_59) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_59, u2b_59) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_59, v1b_59) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_59, v2b_59) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_59);
    u2 = upcast(qu2_59);
    v1 = upcast(qv1_59);
    v2 = upcast(qv2_59);

    let selector_59: felt252 = u1b_59.into()
        + 2 * u2b_59.into()
        + 4 * v1b_59.into()
        + 8 * v2b_59.into();
    let selector_59_usize: usize = selector_59.try_into().unwrap();
    selectors.append(selector_59_usize);

    // --- Iteration 60 ---
    let (qu1_60, u1b_60) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_60, u2b_60) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_60, v1b_60) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_60, v2b_60) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_60);
    u2 = upcast(qu2_60);
    v1 = upcast(qv1_60);
    v2 = upcast(qv2_60);

    let selector_60: felt252 = u1b_60.into()
        + 2 * u2b_60.into()
        + 4 * v1b_60.into()
        + 8 * v2b_60.into();
    let selector_60_usize: usize = selector_60.try_into().unwrap();
    selectors.append(selector_60_usize);

    // --- Iteration 61 ---
    let (qu1_61, u1b_61) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_61, u2b_61) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_61, v1b_61) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_61, v2b_61) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_61);
    u2 = upcast(qu2_61);
    v1 = upcast(qv1_61);
    v2 = upcast(qv2_61);

    let selector_61: felt252 = u1b_61.into()
        + 2 * u2b_61.into()
        + 4 * v1b_61.into()
        + 8 * v2b_61.into();
    let selector_61_usize: usize = selector_61.try_into().unwrap();
    selectors.append(selector_61_usize);

    // --- Iteration 62 ---
    let (qu1_62, u1b_62) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_62, u2b_62) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_62, v1b_62) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_62, v2b_62) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_62);
    u2 = upcast(qu2_62);
    v1 = upcast(qv1_62);
    v2 = upcast(qv2_62);

    let selector_62: felt252 = u1b_62.into()
        + 2 * u2b_62.into()
        + 4 * v1b_62.into()
        + 8 * v2b_62.into();
    let selector_62_usize: usize = selector_62.try_into().unwrap();
    selectors.append(selector_62_usize);

    // --- Iteration 63 ---
    let (qu1_63, u1b_63) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_63, u2b_63) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_63, v1b_63) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_63, v2b_63) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_63);
    u2 = upcast(qu2_63);
    v1 = upcast(qv1_63);
    v2 = upcast(qv2_63);

    let selector_63: felt252 = u1b_63.into()
        + 2 * u2b_63.into()
        + 4 * v1b_63.into()
        + 8 * v2b_63.into();
    let selector_63_usize: usize = selector_63.try_into().unwrap();
    selectors.append(selector_63_usize);

    // --- Iteration 64 ---
    let (qu1_64, u1b_64) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_64, u2b_64) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_64, v1b_64) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_64, v2b_64) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_64);
    u2 = upcast(qu2_64);
    v1 = upcast(qv1_64);
    v2 = upcast(qv2_64);

    let selector_64: felt252 = u1b_64.into()
        + 2 * u2b_64.into()
        + 4 * v1b_64.into()
        + 8 * v2b_64.into();
    let selector_64_usize: usize = selector_64.try_into().unwrap();
    selectors.append(selector_64_usize);

    // --- Iteration 65 ---
    let (qu1_65, u1b_65) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_65, u2b_65) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_65, v1b_65) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_65, v2b_65) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_65);
    u2 = upcast(qu2_65);
    v1 = upcast(qv1_65);
    v2 = upcast(qv2_65);

    let selector_65: felt252 = u1b_65.into()
        + 2 * u2b_65.into()
        + 4 * v1b_65.into()
        + 8 * v2b_65.into();
    let selector_65_usize: usize = selector_65.try_into().unwrap();
    selectors.append(selector_65_usize);

    // --- Iteration 66 ---
    let (qu1_66, u1b_66) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_66, u2b_66) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_66, v1b_66) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_66, v2b_66) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_66);
    u2 = upcast(qu2_66);
    v1 = upcast(qv1_66);
    v2 = upcast(qv2_66);

    let selector_66: felt252 = u1b_66.into()
        + 2 * u2b_66.into()
        + 4 * v1b_66.into()
        + 8 * v2b_66.into();
    let selector_66_usize: usize = selector_66.try_into().unwrap();
    selectors.append(selector_66_usize);

    // --- Iteration 67 ---
    let (qu1_67, u1b_67) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_67, u2b_67) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_67, v1b_67) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_67, v2b_67) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_67);
    u2 = upcast(qu2_67);
    v1 = upcast(qv1_67);
    v2 = upcast(qv2_67);

    let selector_67: felt252 = u1b_67.into()
        + 2 * u2b_67.into()
        + 4 * v1b_67.into()
        + 8 * v2b_67.into();
    let selector_67_usize: usize = selector_67.try_into().unwrap();
    selectors.append(selector_67_usize);

    // --- Iteration 68 ---
    let (qu1_68, u1b_68) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_68, u2b_68) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_68, v1b_68) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_68, v2b_68) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_68);
    u2 = upcast(qu2_68);
    v1 = upcast(qv1_68);
    v2 = upcast(qv2_68);

    let selector_68: felt252 = u1b_68.into()
        + 2 * u2b_68.into()
        + 4 * v1b_68.into()
        + 8 * v2b_68.into();
    let selector_68_usize: usize = selector_68.try_into().unwrap();
    selectors.append(selector_68_usize);

    // --- Iteration 69 ---
    let (qu1_69, u1b_69) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_69, u2b_69) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_69, v1b_69) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_69, v2b_69) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_69);
    u2 = upcast(qu2_69);
    v1 = upcast(qv1_69);
    v2 = upcast(qv2_69);

    let selector_69: felt252 = u1b_69.into()
        + 2 * u2b_69.into()
        + 4 * v1b_69.into()
        + 8 * v2b_69.into();
    let selector_69_usize: usize = selector_69.try_into().unwrap();
    selectors.append(selector_69_usize);

    // --- Iteration 70 ---
    let (qu1_70, u1b_70) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_70, u2b_70) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_70, v1b_70) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_70, v2b_70) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_70);
    u2 = upcast(qu2_70);
    v1 = upcast(qv1_70);
    v2 = upcast(qv2_70);

    let selector_70: felt252 = u1b_70.into()
        + 2 * u2b_70.into()
        + 4 * v1b_70.into()
        + 8 * v2b_70.into();
    let selector_70_usize: usize = selector_70.try_into().unwrap();
    selectors.append(selector_70_usize);

    // --- Iteration 71 ---
    let (qu1_71, u1b_71) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2_71, u2b_71) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1_71, v1b_71) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2_71, v2b_71) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1_71);
    u2 = upcast(qu2_71);
    v1 = upcast(qv1_71);
    v2 = upcast(qv2_71);

    let selector_71: felt252 = u1b_71.into()
        + 2 * u2b_71.into()
        + 4 * v1b_71.into()
        + 8 * v2b_71.into();
    let selector_71_usize: usize = selector_71.try_into().unwrap();
    selectors.append(selector_71_usize);

    return (selectors.span(), upcast(u1lsb), upcast(u2lsb), upcast(v1lsb), upcast(v2lsb));
}
