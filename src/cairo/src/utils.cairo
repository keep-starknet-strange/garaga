use array::ArrayTrait;
const STARK_MINUS_1: u256 = 3618502788666131213697322783095070105623107215331596699973092056135872020480;

// From a 128 bit scalar, decomposes it into base (-3) such that
// scalar = sum(digits[i] * (-3)^i for i in [0, 81])
// scalar = sum_p - sum_n
// Where sum_p = sum(digits[i] * (-3)^i for i in [0, 81] if digits[i]==1)
// And sum_n = sum(digits[i] * (-3)^i for i in [0, 81] if digits[i]==-1)
// Returns (abs(sum_p), abs(sum_n), p_sign, n_sign)
pub fn  scalar_to_base_neg3_le(scalar: u128) -> (felt252, felt252, felt252, felt252){

    let mut scalar: u128 = scalar;

    let digits: Span<felt252> = neg_3_base_le(scalar).span();
    let digits_len = digits.len();


    let mut sum_p = 0;
    let mut sum_n = 0;

    let mut base_power = 1;
    let mut i = 0;

    //implementation like this to run in O(n) time complexity, only computing each power of -3 once
    while i < digits_len {
        let digit = digits.at(i);
        if *digit == 1 {
            sum_p += base_power;
        } else if *digit == -1 {
            sum_n += base_power;
        }
        base_power = base_power * (-3);
        i += 1;
    };

    return (sum_p, sum_n, sign(sum_p), sign(sum_n));
}

fn sign(num: felt252) -> felt252 {
    if num.into() <= STARK_MINUS_1 / 2 {
        return 1;
    } else {
        return -1;
    }
}

// Decomposes a scalar into base -3 representation. 
// :param scalar: The integer to be decomposed. 
// :return: A list of coefficients in base -3 representation. (Least significant bit first), 
// with digits [-1, 0, 1] such that scalar = sum((-3) ** i * d for (i, d) in enumerate(digits)) 
pub fn  neg_3_base_le(scalar: u128) -> Array<felt252> {
    let mut digits: Array<felt252> = ArrayTrait::new();

    if scalar == 0 {
        digits.append(0);
        return digits;
    }

    let mut scalar: i128 = scalar.try_into().unwrap();
    let mut remainder = 0;

    while scalar != 0 {
        remainder =  scalar % 3;
        if remainder == 2 {
            remainder = -1;
            scalar += 1;
        }

        digits.append(remainder.into());
        scalar = -(scalar / 3);
    };

    return digits;
}
