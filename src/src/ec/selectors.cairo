use corelib_imports::bounded_int::{
    AddHelper, BoundedInt, DivRemHelper, MulHelper, UnitInt, bounded_int, upcast,
};

const TWO: felt252 = 2;
const TWO_UI: UnitInt<TWO> = 2;
const FOUR_UI: UnitInt<FOUR> = 4;
const EIGHT_UI: UnitInt<EIGHT> = 8;
const TWO_NZ_TYPED: NonZero<UnitInt<TWO>> = 2;
const FOUR_NZ_TYPED: NonZero<UnitInt<FOUR>> = 4;
const POW128_DIV_2: felt252 = 0x7fffffffffffffffffffffffffffffff; // ((2^128-1) // 2)
const POW128_DIV_4: felt252 = 0x3fffffffffffffffffffffffffffffff; // ((2^128-1) // 4)
const POW128: felt252 = 0x100000000000000000000000000000000;

const FOUR: felt252 = 4;
const EIGHT: felt252 = 8;


pub type u15_bi = BoundedInt<0, { 15 }>;
pub type u12_bi = BoundedInt<0, { 12 }>;
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

impl DivRemU128By4 of DivRemHelper<BoundedInt<0, { POW128 - 1 }>, UnitInt<FOUR>> {
    type DivT = BoundedInt<0, { POW128_DIV_4 }>;
    type RemT = u3_bi;
}

impl MulHelperBitBy2Impl of MulHelper<u1_bi, UnitInt<TWO>> {
    type Result = u2_bi;
}

impl MulHelperBitBy4Impl of MulHelper<u1_bi, UnitInt<FOUR>> {
    type Result = u4_bi;
}

impl MulHelperBit3By4Impl of MulHelper<u3_bi, UnitInt<FOUR>> {
    type Result = u12_bi;
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

impl AddHelperU3ByU12Impl of AddHelper<u3_bi, u12_bi> {
    type Result = u15_bi;
}


#[inline(always)]
fn _extract_and_calculate_selector_bit_inlined(
    mut u1: BoundedInt<0, { POW128 - 1 }>,
    mut u2: BoundedInt<0, { POW128 - 1 }>,
    mut v1: BoundedInt<0, { POW128 - 1 }>,
    mut v2: BoundedInt<0, { POW128 - 1 }>,
) -> (
    BoundedInt<0, { POW128 - 1 }>,
    BoundedInt<0, { POW128 - 1 }>,
    BoundedInt<0, { POW128 - 1 }>,
    BoundedInt<0, { POW128 - 1 }>,
    u15_bi,
) {
    let (qu1, u1b) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2, u2b) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1, v1b) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2, v2b) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1);
    u2 = upcast(qu2);
    v1 = upcast(qv1);
    v2 = upcast(qv2);
    let selector: u15_bi = bounded_int::add(
        bounded_int::add(
            bounded_int::add(u1b, bounded_int::mul(u2b, TWO_UI)), bounded_int::mul(v1b, FOUR_UI),
        ),
        bounded_int::mul(v2b, EIGHT_UI),
    );
    return (u1, u2, v1, v2, selector);
}

#[inline(always)]
fn _extract_and_calculate_selector_bit_inlined_fake_glv(
    mut s1: BoundedInt<0, { POW128 - 1 }>, mut s2: BoundedInt<0, { POW128 - 1 }>,
) -> (BoundedInt<0, { POW128 - 1 }>, BoundedInt<0, { POW128 - 1 }>, u15_bi) {
    let (qs1, s1b) = bounded_int::div_rem(s1, FOUR_NZ_TYPED);
    let (qs2, s2b) = bounded_int::div_rem(s2, FOUR_NZ_TYPED);
    s1 = upcast(qs1);
    s2 = upcast(qs2);
    let selector: u15_bi = bounded_int::add(s1b, bounded_int::mul(s2b, FOUR_UI));
    return (s1, s2, selector);
}


#[inline(always)]
pub fn build_selectors_inlined(
    _u1: u128, _u2: u128, _v1: u128, _v2: u128,
) -> (Span<usize>, u128, u128, u128, u128) {
    // Generated code for n_bits = 73
    let mut selectors: Array<usize> = array![];

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
    let (u1, u2, v1, v2, selector_0) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_0));
    let (u1, u2, v1, v2, selector_1) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_1));
    let (u1, u2, v1, v2, selector_2) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_2));
    let (u1, u2, v1, v2, selector_3) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_3));
    let (u1, u2, v1, v2, selector_4) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_4));
    let (u1, u2, v1, v2, selector_5) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_5));
    let (u1, u2, v1, v2, selector_6) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_6));
    let (u1, u2, v1, v2, selector_7) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_7));
    let (u1, u2, v1, v2, selector_8) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_8));
    let (u1, u2, v1, v2, selector_9) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_9));
    let (u1, u2, v1, v2, selector_10) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_10));
    let (u1, u2, v1, v2, selector_11) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_11));
    let (u1, u2, v1, v2, selector_12) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_12));
    let (u1, u2, v1, v2, selector_13) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_13));
    let (u1, u2, v1, v2, selector_14) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_14));
    let (u1, u2, v1, v2, selector_15) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_15));
    let (u1, u2, v1, v2, selector_16) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_16));
    let (u1, u2, v1, v2, selector_17) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_17));
    let (u1, u2, v1, v2, selector_18) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_18));
    let (u1, u2, v1, v2, selector_19) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_19));
    let (u1, u2, v1, v2, selector_20) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_20));
    let (u1, u2, v1, v2, selector_21) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_21));
    let (u1, u2, v1, v2, selector_22) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_22));
    let (u1, u2, v1, v2, selector_23) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_23));
    let (u1, u2, v1, v2, selector_24) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_24));
    let (u1, u2, v1, v2, selector_25) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_25));
    let (u1, u2, v1, v2, selector_26) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_26));
    let (u1, u2, v1, v2, selector_27) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_27));
    let (u1, u2, v1, v2, selector_28) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_28));
    let (u1, u2, v1, v2, selector_29) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_29));
    let (u1, u2, v1, v2, selector_30) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_30));
    let (u1, u2, v1, v2, selector_31) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_31));
    let (u1, u2, v1, v2, selector_32) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_32));
    let (u1, u2, v1, v2, selector_33) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_33));
    let (u1, u2, v1, v2, selector_34) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_34));
    let (u1, u2, v1, v2, selector_35) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_35));
    let (u1, u2, v1, v2, selector_36) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_36));
    let (u1, u2, v1, v2, selector_37) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_37));
    let (u1, u2, v1, v2, selector_38) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_38));
    let (u1, u2, v1, v2, selector_39) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_39));
    let (u1, u2, v1, v2, selector_40) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_40));
    let (u1, u2, v1, v2, selector_41) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_41));
    let (u1, u2, v1, v2, selector_42) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_42));
    let (u1, u2, v1, v2, selector_43) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_43));
    let (u1, u2, v1, v2, selector_44) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_44));
    let (u1, u2, v1, v2, selector_45) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_45));
    let (u1, u2, v1, v2, selector_46) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_46));
    let (u1, u2, v1, v2, selector_47) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_47));
    let (u1, u2, v1, v2, selector_48) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_48));
    let (u1, u2, v1, v2, selector_49) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_49));
    let (u1, u2, v1, v2, selector_50) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_50));
    let (u1, u2, v1, v2, selector_51) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_51));
    let (u1, u2, v1, v2, selector_52) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_52));
    let (u1, u2, v1, v2, selector_53) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_53));
    let (u1, u2, v1, v2, selector_54) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_54));
    let (u1, u2, v1, v2, selector_55) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_55));
    let (u1, u2, v1, v2, selector_56) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_56));
    let (u1, u2, v1, v2, selector_57) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_57));
    let (u1, u2, v1, v2, selector_58) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_58));
    let (u1, u2, v1, v2, selector_59) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_59));
    let (u1, u2, v1, v2, selector_60) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_60));
    let (u1, u2, v1, v2, selector_61) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_61));
    let (u1, u2, v1, v2, selector_62) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_62));
    let (u1, u2, v1, v2, selector_63) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_63));
    let (u1, u2, v1, v2, selector_64) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_64));
    let (u1, u2, v1, v2, selector_65) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_65));
    let (u1, u2, v1, v2, selector_66) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_66));
    let (u1, u2, v1, v2, selector_67) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_67));
    let (u1, u2, v1, v2, selector_68) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_68));
    let (u1, u2, v1, v2, selector_69) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_69));
    let (u1, u2, v1, v2, selector_70) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_70));
    let (_, _, _, _, selector_71) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);
    selectors.append(upcast(selector_71));
    return (selectors.span(), upcast(u1lsb), upcast(u2lsb), upcast(v1lsb), upcast(v2lsb));
}

#[inline(always)]
pub fn build_selectors_inlined_fake_glv(_s1: u128, _s2: u128) -> (Span<usize>, u128, u128) {
    // Generated code for n_bits = 128
    let mut selectors: Array<usize> = array![];

    let mut s1: BoundedInt<0, { POW128 - 1 }> = upcast(_s1);
    let mut s2: BoundedInt<0, { POW128 - 1 }> = upcast(_s2);

    // Initial division and remainder to get LSBs
    let (qs1, s1lsb) = bounded_int::div_rem(s1, TWO_NZ_TYPED);
    let (qs2, s2lsb) = bounded_int::div_rem(s2, TWO_NZ_TYPED);
    s1 = upcast(qs1);
    s2 = upcast(qs2);

    // Inlined loop (63 2-bit iterations for 128 bits)
    let (s1, s2, selector_0) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_0));
    // Correction for the last bits 2-1.
    selectors.append(16);
    let (s1, s2, selector_1) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_1));
    let (s1, s2, selector_2) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_2));
    let (s1, s2, selector_3) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_3));
    let (s1, s2, selector_4) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_4));
    let (s1, s2, selector_5) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_5));
    let (s1, s2, selector_6) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_6));
    let (s1, s2, selector_7) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_7));
    let (s1, s2, selector_8) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_8));
    let (s1, s2, selector_9) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_9));
    let (s1, s2, selector_10) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_10));
    let (s1, s2, selector_11) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_11));
    let (s1, s2, selector_12) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_12));
    let (s1, s2, selector_13) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_13));
    let (s1, s2, selector_14) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_14));
    let (s1, s2, selector_15) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_15));
    let (s1, s2, selector_16) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_16));
    let (s1, s2, selector_17) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_17));
    let (s1, s2, selector_18) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_18));
    let (s1, s2, selector_19) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_19));
    let (s1, s2, selector_20) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_20));
    let (s1, s2, selector_21) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_21));
    let (s1, s2, selector_22) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_22));
    let (s1, s2, selector_23) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_23));
    let (s1, s2, selector_24) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_24));
    let (s1, s2, selector_25) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_25));
    let (s1, s2, selector_26) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_26));
    let (s1, s2, selector_27) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_27));
    let (s1, s2, selector_28) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_28));
    let (s1, s2, selector_29) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_29));
    let (s1, s2, selector_30) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_30));
    let (s1, s2, selector_31) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_31));
    let (s1, s2, selector_32) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_32));
    let (s1, s2, selector_33) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_33));
    let (s1, s2, selector_34) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_34));
    let (s1, s2, selector_35) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_35));
    let (s1, s2, selector_36) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_36));
    let (s1, s2, selector_37) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_37));
    let (s1, s2, selector_38) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_38));
    let (s1, s2, selector_39) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_39));
    let (s1, s2, selector_40) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_40));
    let (s1, s2, selector_41) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_41));
    let (s1, s2, selector_42) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_42));
    let (s1, s2, selector_43) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_43));
    let (s1, s2, selector_44) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_44));
    let (s1, s2, selector_45) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_45));
    let (s1, s2, selector_46) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_46));
    let (s1, s2, selector_47) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_47));
    let (s1, s2, selector_48) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_48));
    let (s1, s2, selector_49) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_49));
    let (s1, s2, selector_50) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_50));
    let (s1, s2, selector_51) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_51));
    let (s1, s2, selector_52) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_52));
    let (s1, s2, selector_53) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_53));
    let (s1, s2, selector_54) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_54));
    let (s1, s2, selector_55) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_55));
    let (s1, s2, selector_56) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_56));
    let (s1, s2, selector_57) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_57));
    let (s1, s2, selector_58) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_58));
    let (s1, s2, selector_59) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_59));
    let (s1, s2, selector_60) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_60));
    let (s1, s2, selector_61) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_61));
    let (s1, s2, selector_62) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);
    selectors.append(upcast(selector_62));
    // At this point s1, and s2 are the MSB (last bit).
    if s1 != 0 {
        if s2 != 0 {
            // 11 T2 index : 10
            selectors.append(10);
        } else {
            // 10 T12 index : 6
            selectors.append(6);
        }
    } else {
        if s2 != 0 {
            // 01 T15 index : 9
            selectors.append(9);
        } else {
            // 00 T5 index : 5
            selectors.append(5);
        }
    }
    return (selectors.span(), upcast(s1lsb), upcast(s2lsb));
}
