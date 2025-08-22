use core::circuit::u384;
use corelib_imports::bounded_int::{
    AddHelper, BoundedInt, DivRemHelper, UnitInt, bounded_int, upcast,
};
use garaga::definitions::get_min_one;


const STARK_MINUS_1_HALF: u256 =
    180925139433306560684866139154753505281553607665798349986546028067936010240; // (STARK-1)//2


// Returns the sign of a felt252.
// num is considered positive if num <= (STARK-1)//2
// num is considered negative if num > (STARK-1)//2
pub fn sign(num: felt252) -> felt252 {
    if num.into() <= STARK_MINUS_1_HALF {
        return 1;
    } else {
        return -1;
    }
}

// Maps a sign returned by sign() to a u384 modulo the prime of a given curve index.
pub fn sign_to_u384(sign: felt252, curve_index: usize) -> u384 {
    if (sign == -1) {
        return get_min_one(curve_index);
    } else {
        return u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 };
    }
}

pub fn u256_array_to_low_high_epns(
    scalars: Span<u256>,
    scalars_digits_decompositions: Option<Span<(Span<felt252>, Span<felt252>)>>,
) -> (Array<(felt252, felt252, felt252, felt252)>, Array<(felt252, felt252, felt252, felt252)>) {
    let mut epns_low: Array<(felt252, felt252, felt252, felt252)> = ArrayTrait::new();
    let mut epns_high: Array<(felt252, felt252, felt252, felt252)> = ArrayTrait::new();

    match scalars_digits_decompositions {
        Option::None(_) => {
            for scalar in scalars {
                epns_low.append(scalar_to_epns(*scalar.low));
                epns_high.append(scalar_to_epns(*scalar.high));
            }
        },
        Option::Some(decompositions) => {
            let mut i = 0;
            for scalar in scalars {
                match decompositions.get(i) {
                    Option::Some(decompositions) => {
                        let (decomposition_low, decomposition_high) = decompositions.unbox();
                        epns_low
                            .append(scalar_to_epns_with_digits(*scalar.low, *decomposition_low));
                        epns_high
                            .append(scalar_to_epns_with_digits(*scalar.high, *decomposition_high));
                    },
                    Option::None(_) => {
                        epns_low.append(scalar_to_epns(*scalar.low));
                        epns_high.append(scalar_to_epns(*scalar.high));
                    },
                }
                i += 1;
            }
        },
    }

    return (epns_low, epns_high);
}

pub fn u128_array_to_epns(
    scalars: Span<u128>, scalars_digits_decompositions: Option<Span<Span<felt252>>>,
) -> Array<(felt252, felt252, felt252, felt252)> {
    let mut epns: Array<(felt252, felt252, felt252, felt252)> = ArrayTrait::new();

    match scalars_digits_decompositions {
        Option::None(_) => { for scalar in scalars {
            epns.append(scalar_to_epns(*scalar));
        } },
        Option::Some(decompositions) => {
            let mut i = 0;
            for scalar in scalars {
                match decompositions.get(i) {
                    Option::Some(decomposition) => {
                        let decomposition = decomposition.unbox();
                        epns.append(scalar_to_epns_with_digits(*scalar, *decomposition));
                    },
                    Option::None(_) => { epns.append(scalar_to_epns(*scalar)); },
                }
                i += 1;
            }
        },
    }

    return epns;
}

const THREE: felt252 = 3;
const THREE_NZ_TYPED: NonZero<UnitInt<THREE>> = 3;
const POW128_DIV_3: felt252 = 113427455640312821154458202477256070485; // ((2^128-1) // 3)
const POW128: felt252 = 0x100000000000000000000000000000000;

impl DivRemU128By3 of DivRemHelper<BoundedInt<0, { POW128 - 1 }>, UnitInt<THREE>> {
    type DivT = BoundedInt<0, { POW128_DIV_3 }>;
    type RemT = BoundedInt<0, { THREE - 1 }>;
}

impl AddOneHelper of AddHelper<BoundedInt<0, { POW128_DIV_3 }>, BoundedInt<0, 1>> {
    type Result = BoundedInt<0, { POW128_DIV_3 + 1 }>;
}

// From a 128 bit scalar, returns the positive and negative multiplicities of the scalar in base
// (-3)
// scalar = sum(digits[i] * (-3)^i for i in [0, 81])
// scalar = sum_p - sum_n
// Where sum_p = sum(digits[i] * (-3)^i for i in [0, 81] if digits[i]==1)
// And sum_n = sum(digits[i] * (-3)^i for i in [0, 81] if digits[i]==-1)
// Returns (abs(sum_p), abs(sum_n), p_sign, n_sign)
pub fn scalar_to_epns(mut _scalar: u128) -> (felt252, felt252, felt252, felt252) {
    let mut sum_p: felt252 = 0;
    let mut sum_n: felt252 = 0;

    let mut base_power: felt252 = 1; // Init to (-3)^0

    let mut scalar: BoundedInt<0, { POW128 - 1 }> = upcast(_scalar);
    while scalar != 0 {
        let (q0, r0) = bounded_int::div_rem(scalar, THREE_NZ_TYPED);
        let r0: felt252 = r0.into();

        if r0 == 0 {
            scalar = upcast(q0);
        } else if r0 == 2 {
            scalar = upcast(bounded_int::add(q0, 1));
            sum_n += base_power;
        } else {
            scalar = upcast(q0);
            sum_p += base_power;
        }
        base_power = base_power * (-3);

        let (q1, r1) = bounded_int::div_rem(scalar, THREE_NZ_TYPED);
        let r1: felt252 = r1.into();

        if r1 == 0 {
            scalar = upcast(q1);
        } else if r1 == 2 {
            scalar = upcast(bounded_int::add(q1, 1));
            sum_p += base_power;
        } else {
            scalar = upcast(q1);
            sum_n += base_power;
        }

        base_power = base_power * (-3);
    }

    let sign_p = sign(sum_p);
    let sign_n = sign(sum_n);
    return (sign_p * sum_p, sign_n * sum_n, sign_p, sign_n);
}


pub fn scalar_to_epns_with_digits(
    scalar: u128, mut digits: Span<felt252>,
) -> (felt252, felt252, felt252, felt252) {
    assert!(digits.len() <= 82, "The number of digits must be <= 82 for u128");
    let mut sum_p = 0;
    let mut sum_n = 0;

    let mut base_power = 1; // Init to (-3)^0

    while let Option::Some(digit) = digits.pop_front() {
        let digit = *digit;
        if digit != 0 {
            if digit == 1 {
                sum_p += base_power;
            } else {
                sum_n += base_power;
            }
        }

        base_power = base_power * (-3);
    }

    assert!(
        scalar.into() == sum_p - sum_n,
        "The scalar must be equal to the sum of the positive and negative digits",
    );

    let sign_p = sign(sum_p);
    let sign_n = sign(sum_n);
    return (sign_p * sum_p, sign_n * sum_n, sign_p, sign_n);
}


#[cfg(test)]
mod tests {
    use super::scalar_to_epns;

    #[test]
    fn test_scalar_to_epns() {
        let (sum_p, sum_n, sign_p, sign_n) = scalar_to_epns(12);

        assert_eq!(sum_p, 9);
        assert_eq!(sum_n, 3);
        assert_eq!(sign_p, 1);
        assert_eq!(sign_n, -1);

        let (sum_p, sum_n, sign_p, sign_n) = scalar_to_epns(35);

        assert_eq!(sum_p, 9);
        assert_eq!(sum_n, 26);
        assert_eq!(sign_p, 1);
        assert_eq!(sign_n, -1);

        let (sum_p, sum_n, _, _) = scalar_to_epns(0);

        assert_eq!(sum_p, 0);
        assert_eq!(sum_n, 0);

        let (sum_p, sum_n, sign_p, sign_n) = scalar_to_epns(
            170141183460469231731687303715884105728,
        ); //2**127

        assert_eq!(sum_p, 164253760949568696627221936579612523510);
        assert_eq!(sum_n, 5887422510900535104465367136271582218); //using STARK field
        assert_eq!(sign_p, 1);
        assert_eq!(sign_n, -1);

        let (sum_p, sum_n, sign_p, sign_n) = scalar_to_epns(
            85070591730234615865843651857942052864,
        ); //2 **126

        assert_eq!(sum_p, 97865891762673628272143863189949020615);
        assert_eq!(sum_n, 12795300032439012406300211332006967751);
        assert_eq!(sign_p, 1);
        assert_eq!(sign_n, 1);

        let (sum_p, sum_n, sign_p, sign_n) = scalar_to_epns(
            85070591730234615865843651857942052874,
        ); //2 **126 + 10

        assert_eq!(sum_p, 97865891762673628272143863189949020623);
        assert_eq!(sum_n, 12795300032439012406300211332006967749);
        assert_eq!(sign_p, 1);
        assert_eq!(sign_n, 1);
    }

    #[test]
    fn test_scalar_to_epns_single() {
        let (sum_p, sum_n, sign_p, sign_n) = scalar_to_epns(
            170141183460469231731687303715884105728,
        ); //2**127

        assert_eq!(sum_p, 164253760949568696627221936579612523510);
        assert_eq!(sum_n, 5887422510900535104465367136271582218);
        assert_eq!(sign_p, 1);
        assert_eq!(sign_n, -1);
    }
}

