use array::ArrayTrait;

const STARK_MINUS_1_HALF: u256 =
    1809251394333065606848661391547535052811553607665798349986546028067936010240;


// Returns the sign of a felt252
// num is considered positive if num <= (STARK-1)//2
// num is considered negative if num > (STARK-1)//2
fn sign(num: felt252) -> felt252 {
    if num.into() <= STARK_MINUS_1_HALF {
        return 1;
    } else {
        return -1;
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

