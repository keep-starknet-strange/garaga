use array::ArrayTrait;
use core::circuit::{u384, u96};
use core::poseidon::hades_permutation;
use garaga::definitions::{get_min_one};

const STARK_MINUS_1_HALF: u256 =
    180925139433306560684866139154753505281553607665798349986546028067936010240; // (STARK-1)//2


// Returns the sign of a felt252 such that 1 if positive, 0 if negative
// num is considered positive if num <= (STARK-1)//2
// num is considered negative if num > (STARK-1)//2
fn sign(num: felt252) -> felt252 {
    if num.into() <= STARK_MINUS_1_HALF {
        return 1;
    } else {
        return -1;
    }
}

// Maps a sign returned by sign() to a u384 modulo the prime of a given curve index.
fn sign_to_u384(sign: felt252, curve_index: usize) -> u384 {
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

// From a 128 bit scalar, returns the positive and negative multiplicities of the scalar in base
// (-3)
// scalar = sum(digits[i] * (-3)^i for i in [0, 81])
// scalar = sum_p - sum_n
// Where sum_p = sum(digits[i] * (-3)^i for i in [0, 81] if digits[i]==1)
// And sum_n = sum(digits[i] * (-3)^i for i in [0, 81] if digits[i]==-1)
// Returns (abs(sum_p), abs(sum_n), p_sign, n_sign)
pub fn scalar_to_base_neg3_le(scalar: u128) -> (felt252, felt252, felt252, felt252) {
    let digits: Span<felt252> = neg_3_base_le(scalar).span();

    let digits_len = digits.len();

    let mut sum_p = 0;
    let mut sum_n = 0;

    let mut base_power = 1; // Init to (-3)^0
    let mut i = 0;

    while i != digits_len {
        let digit = *digits.at(i);

        if digit != 0 {
            if digit == 1 {
                sum_p += base_power;
            } else {
                sum_n += base_power;
            }
        }

        base_power = base_power * (-3);
        i += 1;
    };

    let sign_p = sign(sum_p);
    let sign_n = sign(sum_n);
    return (sign_p * sum_p, sign_n * sum_n, sign_p, sign_n);
}


// Apply sponge construction to a transcript of u384 elements
pub fn hash_u384_transcript(transcript: Span<u384>, init_hash: felt252) -> felt252 {
    let n = transcript.len();
    let (_s0, _s1, _s2) = hades_permutation(init_hash, 0, 1);
    let base: felt252 = 79228162514264337593543950336;

    let mut s0: felt252 = _s0;
    let mut s1: felt252 = _s1;
    let mut s2: felt252 = _s2;
    let mut i = 0;

    while i != n {
        let elmt: u384 = *transcript.at(i);
        let in_1 = s0 + elmt.limb0.into() + base * elmt.limb1.into();
        let in_2 = s1 + elmt.limb2.into() + base * elmt.limb3.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, s2);
        s0 = _s0;
        s1 = _s1;
        s2 = _s2;
        i += 1;
    };
    return s0;
}


#[cfg(test)]
mod tests {
    use core::traits::TryInto;
    use core::circuit::{u384};
    use super::{scalar_to_base_neg3_le, neg_3_base_le, hash_u384_transcript};

    #[test]
    fn test_hash_u384_1() {
        // Auto-generated from hydra/poseidon_transcript.py
        let transcript: Array<u384> = array![
            u384 {
                limb0: 76677015132228699860956691808,
                limb1: 46220287081956549667980460548,
                limb2: 17306816048104837991486447480,
                limb3: 22329494809335620336969001078
            },
        ];
        let expected_res: felt252 =
            3297762138193981227815629833717514065743219132059723073766743112461412207308;
        let res = hash_u384_transcript(transcript.span(), 0);
        assert_eq!(res, expected_res);
    }


    #[test]
    fn test_hash_u384_2() {
        // Auto-generated from hydra/poseidon_transcript.py
        let transcript: Array<u384> = array![
            u384 {
                limb0: 7824838117372778964875952937,
                limb1: 71213305969009323122414207227,
                limb2: 26160919184156030613461706516,
                limb3: 7978371848643316311778023511
            },
            u384 {
                limb0: 48399452498814755378949382818,
                limb1: 16200395963046324809355151807,
                limb2: 37792607957164279448458200001,
                limb3: 41305890795846888865569987091
            },
        ];
        let expected_res: felt252 =
            2923707871009173167795776359273914941692187491124628723472060583265988140716;
        let res = hash_u384_transcript(transcript.span(), 0);
        assert_eq!(res, expected_res);
    }


    #[test]
    fn test_hash_u384_3() {
        // Auto-generated from hydra/poseidon_transcript.py
        let transcript: Array<u384> = array![
            u384 {
                limb0: 72653727858928910840526519500,
                limb1: 18905101524972380650079806031,
                limb2: 11289568892202578355407029612,
                limb3: 35491806037101694621488851837
            },
            u384 {
                limb0: 26363211711172777510060660809,
                limb1: 42805677332347798066389116526,
                limb2: 63337140896749935806613096796,
                limb3: 46555820521213219618912100242
            },
            u384 {
                limb0: 47242712145107283230751116549,
                limb1: 25119039362616788698565802017,
                limb2: 23002273116341292026554080626,
                limb3: 65083337955339917286341477716
            },
        ];
        let expected_res: felt252 =
            1458748780558279957833105102547490952861375462817610622005882065045722920959;
        let res = hash_u384_transcript(transcript.span(), 0);
        assert_eq!(res, expected_res);
    }

    #[test]
    fn test_scalar_to_base_neg3_le() {
        let (sum_p, sum_n, sign_p, sign_n) = scalar_to_base_neg3_le(12);

        assert_eq!(sum_p, 9);
        assert_eq!(sum_n, 3);
        assert_eq!(sign_p, 1);
        assert_eq!(sign_n, -1);

        let (sum_p, sum_n, sign_p, sign_n) = scalar_to_base_neg3_le(35);

        assert_eq!(sum_p, 9);
        assert_eq!(sum_n, 26);
        assert_eq!(sign_p, 1);
        assert_eq!(sign_n, -1);

        let (sum_p, sum_n, _, _) = scalar_to_base_neg3_le(0);

        assert_eq!(sum_p, 0);
        assert_eq!(sum_n, 0);

        let (sum_p, sum_n, sign_p, sign_n) = scalar_to_base_neg3_le(
            170141183460469231731687303715884105728
        ); //2**127

        assert_eq!(sum_p, 164253760949568696627221936579612523510);
        assert_eq!(sum_n, 5887422510900535104465367136271582218); //using STARK field
        assert_eq!(sign_p, 1);
        assert_eq!(sign_n, -1);

        let (sum_p, sum_n, sign_p, sign_n) = scalar_to_base_neg3_le(
            85070591730234615865843651857942052864
        ); //2 **126

        assert_eq!(sum_p, 97865891762673628272143863189949020615);
        assert_eq!(sum_n, 12795300032439012406300211332006967751);
        assert_eq!(sign_p, 1);
        assert_eq!(sign_n, 1);

        let (sum_p, sum_n, sign_p, sign_n) = scalar_to_base_neg3_le(
            85070591730234615865843651857942052874
        ); //2 **126 + 10

        assert_eq!(sum_p, 97865891762673628272143863189949020623);
        assert_eq!(sum_n, 12795300032439012406300211332006967749);
        assert_eq!(sign_p, 1);
        assert_eq!(sign_n, 1);
    }

    #[test]
    fn test_scalar_to_base_neg3_le_single() {
        let (sum_p, sum_n, sign_p, sign_n) = scalar_to_base_neg3_le(
            170141183460469231731687303715884105728
        ); //2**127

        assert_eq!(sum_p, 164253760949568696627221936579612523510);
        assert_eq!(sum_n, 5887422510900535104465367136271582218);
        assert_eq!(sign_p, 1);
        assert_eq!(sign_n, -1);
    }

    #[test]
    fn test_neg_3_base_le() {
        let digits: Array<felt252> = neg_3_base_le(12);

        let expected: Array<felt252> = array![0, -1, 1];

        assert_eq!(digits, expected);

        let digits: Array<felt252> = neg_3_base_le(0);
        let expected: Array<felt252> = array![0];

        assert_eq!(digits, expected);

        let digits: Array<felt252> = neg_3_base_le(35);

        let expected: Array<felt252> = array![-1, 0, 1, -1];

        assert_eq!(digits, expected);

        let digits: Array<felt252> = neg_3_base_le(22);
        let expected: Array<felt252> = array![1, -1, -1, -1];

        assert_eq!(digits, expected);

        let digits: Array<felt252> = neg_3_base_le(16);

        let expected: Array<felt252> = array![1, 1, -1, -1];

        assert_eq!(digits, expected);
        let digits: Array<felt252> = neg_3_base_le(
            170141183460469231731687303715884105728
        ); //2**127

        let expected: Array<felt252> = array![
            -1,
            -1,
            0,
            1,
            0,
            -1,
            0,
            0,
            -1,
            -1,
            1,
            0,
            0,
            1,
            -1,
            1,
            0,
            1,
            1,
            1,
            0,
            1,
            1,
            1,
            0,
            0,
            -1,
            -1,
            0,
            0,
            -1,
            -1,
            -1,
            -1,
            1,
            0,
            1,
            1,
            0,
            0,
            0,
            1,
            1,
            -1,
            1,
            1,
            0,
            1,
            1,
            1,
            -1,
            0,
            1,
            0,
            -1,
            -1,
            1,
            0,
            0,
            0,
            1,
            1,
            -1,
            -1,
            1,
            0,
            1,
            0,
            0,
            1,
            0,
            -1,
            1,
            0,
            -1,
            -1,
            0,
            -1,
            1,
            0,
            1
        ];

        assert_eq!(digits, expected);
    }

    #[test]
    fn test_neg_3_base_le_single() {
        let digits: Array<felt252> = neg_3_base_le(16);

        let expected: Array<felt252> = array![1, 1, -1, -1];

        assert_eq!(digits, expected);
    }
}
