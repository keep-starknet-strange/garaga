use garaga::definitions::get_min_one;
use core::circuit::{u384, u96};

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

// Decomposes a scalar into base -3 representation.
// :param scalar: The integer to be decomposed.
// :return: A list of coefficients in base -3 representation. (Least significant bit first),
// with digits [-1, 0, 1] such that scalar = sum((-3) ** i * d for (i, d) in enumerate(digits))
pub fn neg_3_base_le(scalar: u128) -> Array<felt252> {
    let mut digits: Array<felt252> = ArrayTrait::new();

    if scalar == 0 {
        digits.append(0);
        return digits;
    }

    let mut scalar: u128 = scalar;

    let mut scalar_negative: bool = false;

    while scalar != 0 {
        let (q, r) = core::traits::DivRem::div_rem(scalar, 3);

        if r == 2 {
            if scalar_negative {
                scalar = q + 1;
                digits.append(1);
            } else {
                scalar = q + 1;
                digits.append(-1);
            }
        } else {
            if scalar_negative {
                scalar = q;
                digits.append(-r.into());
            } else {
                scalar = q;
                digits.append(r.into());
            }
        }
        scalar_negative = !scalar_negative;
    };

    return digits;
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

// From a 128 bit scalar, returns the positive and negative multiplicities of the scalar in base
// (-3)
// scalar = sum(digits[i] * (-3)^i for i in [0, 81])
// scalar = sum_p - sum_n
// Where sum_p = sum(digits[i] * (-3)^i for i in [0, 81] if digits[i]==1)
// And sum_n = sum(digits[i] * (-3)^i for i in [0, 81] if digits[i]==-1)
// Returns (abs(sum_p), abs(sum_n), p_sign, n_sign)
pub fn scalar_to_epns(scalar: u128) -> (felt252, felt252, felt252, felt252) {
    let mut digits: Array<felt252> = neg_3_base_le(scalar);

    let mut sum_p = 0;
    let mut sum_n = 0;

    let mut base_power = 1; // Init to (-3)^0

    while let Option::Some(digit) = digits.pop_front() {
        if digit != 0 {
            if digit == 1 {
                sum_p += base_power;
            } else {
                sum_n += base_power;
            }
        }

        base_power = base_power * (-3);
    };

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
    };

    assert!(
        scalar.into() == sum_p - sum_n,
        "The scalar must be equal to the sum of the positive and negative digits",
    );

    let sign_p = sign(sum_p);
    let sign_n = sign(sum_n);
    return (sign_p * sum_p, sign_n * sum_n, sign_p, sign_n);
}
// #[cfg(test)]
// mod tests {
//     use core::traits::TryInto;
//     use core::circuit::{u384};
//     use super::{scalar_to_epns, neg_3_base_le, u384_eq_zero};

//     #[test]
//     fn test_scalar_to_epns() {
//         let (sum_p, sum_n, sign_p, sign_n) = scalar_to_epns(12);

//         assert_eq!(sum_p, 9);
//         assert_eq!(sum_n, 3);
//         assert_eq!(sign_p, 1);
//         assert_eq!(sign_n, -1);

//         let (sum_p, sum_n, sign_p, sign_n) = scalar_to_epns(35);

//         assert_eq!(sum_p, 9);
//         assert_eq!(sum_n, 26);
//         assert_eq!(sign_p, 1);
//         assert_eq!(sign_n, -1);

//         let (sum_p, sum_n, _, _) = scalar_to_epns(0);

//         assert_eq!(sum_p, 0);
//         assert_eq!(sum_n, 0);

//         let (sum_p, sum_n, sign_p, sign_n) = scalar_to_epns(
//             170141183460469231731687303715884105728
//         ); //2**127

//         assert_eq!(sum_p, 164253760949568696627221936579612523510);
//         assert_eq!(sum_n, 5887422510900535104465367136271582218); //using STARK field
//         assert_eq!(sign_p, 1);
//         assert_eq!(sign_n, -1);

//         let (sum_p, sum_n, sign_p, sign_n) = scalar_to_epns(
//             85070591730234615865843651857942052864
//         ); //2 **126

//         assert_eq!(sum_p, 97865891762673628272143863189949020615);
//         assert_eq!(sum_n, 12795300032439012406300211332006967751);
//         assert_eq!(sign_p, 1);
//         assert_eq!(sign_n, 1);

//         let (sum_p, sum_n, sign_p, sign_n) = scalar_to_epns(
//             85070591730234615865843651857942052874
//         ); //2 **126 + 10

//         assert_eq!(sum_p, 97865891762673628272143863189949020623);
//         assert_eq!(sum_n, 12795300032439012406300211332006967749);
//         assert_eq!(sign_p, 1);
//         assert_eq!(sign_n, 1);
//     }

//     #[test]
//     fn test_scalar_to_epns_single() {
//         let (sum_p, sum_n, sign_p, sign_n) = scalar_to_epns(
//             170141183460469231731687303715884105728
//         ); //2**127

//         assert_eq!(sum_p, 164253760949568696627221936579612523510);
//         assert_eq!(sum_n, 5887422510900535104465367136271582218);
//         assert_eq!(sign_p, 1);
//         assert_eq!(sign_n, -1);
//     }

//     #[test]
//     fn test_neg_3_base_le() {
//         let digits: Array<felt252> = neg_3_base_le(12);

//         let expected: Array<felt252> = array![0, -1, 1];

//         assert_eq!(digits, expected);

//         let digits: Array<felt252> = neg_3_base_le(0);
//         let expected: Array<felt252> = array![0];

//         assert_eq!(digits, expected);

//         let digits: Array<felt252> = neg_3_base_le(35);

//         let expected: Array<felt252> = array![-1, 0, 1, -1];

//         assert_eq!(digits, expected);

//         let digits: Array<felt252> = neg_3_base_le(22);
//         let expected: Array<felt252> = array![1, -1, -1, -1];

//         assert_eq!(digits, expected);

//         let digits: Array<felt252> = neg_3_base_le(16);

//         let expected: Array<felt252> = array![1, 1, -1, -1];

//         assert_eq!(digits, expected);
//         let digits: Array<felt252> = neg_3_base_le(
//             170141183460469231731687303715884105728
//         ); //2**127

//         let expected: Array<felt252> = array![
//             -1,
//             -1,
//             0,
//             1,
//             0,
//             -1,
//             0,
//             0,
//             -1,
//             -1,
//             1,
//             0,
//             0,
//             1,
//             -1,
//             1,
//             0,
//             1,
//             1,
//             1,
//             0,
//             1,
//             1,
//             1,
//             0,
//             0,
//             -1,
//             -1,
//             0,
//             0,
//             -1,
//             -1,
//             -1,
//             -1,
//             1,
//             0,
//             1,
//             1,
//             0,
//             0,
//             0,
//             1,
//             1,
//             -1,
//             1,
//             1,
//             0,
//             1,
//             1,
//             1,
//             -1,
//             0,
//             1,
//             0,
//             -1,
//             -1,
//             1,
//             0,
//             0,
//             0,
//             1,
//             1,
//             -1,
//             -1,
//             1,
//             0,
//             1,
//             0,
//             0,
//             1,
//             0,
//             -1,
//             1,
//             0,
//             -1,
//             -1,
//             0,
//             -1,
//             1,
//             0,
//             1
//         ];

//         assert_eq!(digits, expected);
//     }

//     #[test]
//     fn test_neg_3_base_le_single() {
//         let digits: Array<felt252> = neg_3_base_le(16);

//         let expected: Array<felt252> = array![1, 1, -1, -1];

//         assert_eq!(digits, expected);
//     }
// }


