from starkware.cairo.common.uint256 import (
    Uint256,
    SHIFT,
    HALF_SHIFT,
    split_64,
    uint256_check,
    uint256_add,
    uint256_le,
    uint256_lt,
)

// Splits a field element in the range [0, 2^224) to its low 128-bit and high 96-bit parts.
func split_128{range_check_ptr}(a: felt) -> (low: felt, high: felt) {
    alloc_locals;
    const UPPER_BOUND = 2 ** 224;
    const HIGH_BOUND = UPPER_BOUND / SHIFT;
    local low: felt;
    local high: felt;

    %{
        ids.low = ids.a & ((1<<128) - 1)
        ids.high = ids.a >> 128
    %}
    assert a = low + high * SHIFT;
    assert [range_check_ptr + 0] = high;
    assert [range_check_ptr + 1] = HIGH_BOUND - 1 - high;
    assert [range_check_ptr + 2] = low;
    let range_check_ptr = range_check_ptr + 3;
    return (low, high);
}

// Adds two integers. Returns the result as a 256-bit integer and the (1-bit) carry.
// Doesn't verify that the result is a valid Uint256
// For use when that check would be performed elsewhere
func _uint256_add_no_uint256_check{range_check_ptr}(a: Uint256, b: Uint256) -> (
    res: Uint256, carry: felt
) {
    alloc_locals;
    local res: Uint256;
    local carry_low: felt;
    local carry_high: felt;
    %{
        sum_low = ids.a.low + ids.b.low
        ids.carry_low = 1 if sum_low >= ids.SHIFT else 0
        sum_high = ids.a.high + ids.b.high + ids.carry_low
        ids.carry_high = 1 if sum_high >= ids.SHIFT else 0
    %}

    assert carry_low * carry_low = carry_low;
    assert carry_high * carry_high = carry_high;

    assert res.low = a.low + b.low - carry_low * SHIFT;
    assert res.high = a.high + b.high + carry_low - carry_high * SHIFT;

    return (res, carry_high);
}

func uint256_mul{range_check_ptr}(a: Uint256, b: Uint256) -> (low: Uint256, high: Uint256) {
    alloc_locals;
    let (a0, a1) = split_64(a.low);
    let (a2, a3) = split_64(a.high);
    let (b0, b1) = split_64(b.low);
    let (b2, b3) = split_64(b.high);

    local B0 = b0 * HALF_SHIFT;
    local b12 = b1 + b2 * HALF_SHIFT;

    let (res0, carry) = split_128(a1 * B0 + a0 * b.low);
    let (res2, carry) = split_128(a3 * B0 + a2 * b.low + a1 * b12 + a0 * b.high + carry);
    let (res4, carry) = split_128(a3 * b12 + a2 * b.high + a1 * b3 + carry);
    // let (res6, carry) = split_64(a3 * b3 + carry);

    return (low=Uint256(low=res0, high=res2), high=Uint256(low=res4, high=a3 * b3 + carry));
}

func uint256_square{range_check_ptr}(a: Uint256) -> (low: Uint256, high: Uint256) {
    alloc_locals;
    let (a0, a1) = split_64(a.low);
    let (a2, a3) = split_64(a.high);

    const HALF_SHIFT2 = 2 * HALF_SHIFT;

    local a12 = a1 + a2 * HALF_SHIFT2;

    let (res0, carry) = split_128(a0 * (a0 + a1 * HALF_SHIFT2));
    let (res2, carry) = split_128(a0 * a.high * 2 + a1 * a12 + carry);
    let (res4, carry) = split_128(a3 * (a1 + a12) + a2 * a2 + carry);
    // let (res6, carry) = split_64(a3*a3 + carry);

    return (low=Uint256(low=res0, high=res2), high=Uint256(low=res4, high=a3 * a3 + carry));
}

// Returns the floor value of the square root of a uint256 integer.
func uint256_sqrt{range_check_ptr}(n: Uint256) -> (res: Uint256) {
    alloc_locals;
    local root: felt;

    %{
        from starkware.python.math_utils import isqrt
        n = (ids.n.high << 128) + ids.n.low
        root = isqrt(n)
        assert 0 <= root < 2 ** 128
        ids.root = root
    %}

    // Verify that 0 <= root < 2**128.
    [range_check_ptr] = root;
    let range_check_ptr = range_check_ptr + 1;

    // Verify that n >= root**2.
    let (root_squared) = uint128_square(root);
    let (check_lower_bound) = uint256_le(root_squared, n);
    assert check_lower_bound = 1;

    // Verify that n <= (root+1)**2 - 1.
    // Note that (root+1)**2 - 1 = root**2 + 2*root.
    // In the case where root = 2**128 - 1,
    // Since (root+1)**2 = 2**256, next_root_squared_minus_one = 2**256 - 1, as desired.
    let (twice_root) = uint128_add(root, root);
    let (next_root_squared_minus_one, _) = uint256_add(root_squared, twice_root);
    let (check_upper_bound) = uint256_le(n, next_root_squared_minus_one);
    assert check_upper_bound = 1;

    return (res=Uint256(low=root, high=0));
}

// Uses new uint256_mul, also uses no_uint256_check version of add
func uint256_unsigned_div_rem{range_check_ptr}(a: Uint256, div: Uint256) -> (
    quotient: Uint256, remainder: Uint256
) {
    alloc_locals;

    // If div == 0, return (0, 0).
    if (div.low + div.high == 0) {
        return (quotient=Uint256(0, 0), remainder=Uint256(0, 0));
    }

    // Guess the quotient and the remainder.
    local quotient: Uint256;
    local remainder: Uint256;
    %{
        a = (ids.a.high << 128) + ids.a.low
        div = (ids.div.high << 128) + ids.div.low
        quotient, remainder = divmod(a, div)

        ids.quotient.low = quotient & ((1 << 128) - 1)
        ids.quotient.high = quotient >> 128
        ids.remainder.low = remainder & ((1 << 128) - 1)
        ids.remainder.high = remainder >> 128
    %}
    uint256_check(quotient);
    uint256_check(remainder);
    let (res_mul, carry) = uint256_mul(quotient, div);
    assert carry = Uint256(0, 0);

    let (check_val, add_carry) = _uint256_add_no_uint256_check(res_mul, remainder);
    assert check_val = a;
    assert add_carry = 0;

    let (is_valid) = uint256_lt(remainder, div);
    assert is_valid = 1;
    return (quotient=quotient, remainder=remainder);
}

// Subtracts two integers. Returns the result as a 256-bit integer
// and a sign felt that is 1 if the result is non-negative, convention based on signed_nn
// although I think the opposite convetion makes more sense
func uint256_sub{range_check_ptr}(a: Uint256, b: Uint256) -> (res: Uint256, sign: felt) {
    alloc_locals;
    local res: Uint256;
    %{
        def split(num: int, num_bits_shift: int = 128, length: int = 2):
            a = []
            for _ in range(length):
                a.append( num & ((1 << num_bits_shift) - 1) )
                num = num >> num_bits_shift
            return tuple(a)

        def pack(z, num_bits_shift: int = 128) -> int:
            limbs = (z.low, z.high)
            return sum(limb << (num_bits_shift * i) for i, limb in enumerate(limbs))

        a = pack(ids.a)
        b = pack(ids.b)
        res = (a - b)%2**256
        res_split = split(res)
        ids.res.low = res_split[0]
        ids.res.high = res_split[1]
    %}
    uint256_check(res);
    let (aa, inv_sign) = _uint256_add_no_uint256_check(res, b);
    assert aa = a;
    return (res, 1 - inv_sign);
}

// assumes inputs are <2**128
func uint128_add{range_check_ptr}(a: felt, b: felt) -> (result: Uint256) {
    alloc_locals;
    local carry: felt;
    %{
        res = ids.a + ids.b
        ids.carry = 1 if res >= ids.SHIFT else 0
    %}
    // Either 0 or 1
    assert carry * carry = carry;
    local res = a + b - carry * SHIFT;
    [range_check_ptr] = res;
    let range_check_ptr = range_check_ptr + 1;

    return (result=Uint256(low=res, high=carry));
}

// assumes inputs are <2**128
func uint128_mul{range_check_ptr}(a: felt, b: felt) -> (result: Uint256) {
    let (a0, a1) = split_64(a);
    let (b0, b1) = split_64(b);

    let (res0, carry) = split_128(a1 * b0 * HALF_SHIFT + a0 * b);
    // let (res2, carry) = split_64(a1 * b1 + carry);

    return (result=Uint256(low=res0, high=a1 * b1 + carry));
}

// assumes input is <2**128
func uint128_square{range_check_ptr}(a: felt) -> (result: Uint256) {
    let (a0, a1) = split_64(a);

    let (res0, carry) = split_128(a0 * (a + a1 * HALF_SHIFT));
    // let (res2, carry) = split_64(a1 * a1 + carry);

    return (result=Uint256(low=res0, high=a1 * a1 + carry));
}

// a series of overlapping 128-bit sections of a Uint256.
// for use in uint128_mul_expanded and uint128_unsigned_div_rem_expanded
struct Uint256_expand {
    B0: felt,
    b01: felt,
    b12: felt,
    b23: felt,
    b3: felt,
}

// expands a Uint256 into a Uint256_expand
func uint256_expand{range_check_ptr}(a: Uint256) -> (exp: Uint256_expand) {
    let (a0, a1) = split_64(a.low);
    let (a2, a3) = split_64(a.high);

    return (exp=Uint256_expand(a0 * HALF_SHIFT, a.low, a1 + a2 * HALF_SHIFT, a.high, a3));
}

func uint256_mul_expanded{range_check_ptr}(a: Uint256, b: Uint256_expand) -> (
    low: Uint256, high: Uint256
) {
    let (a0, a1) = split_64(a.low);
    let (a2, a3) = split_64(a.high);

    let (res0, carry) = split_128(a1 * b.B0 + a0 * b.b01);
    let (res2, carry) = split_128(a3 * b.B0 + a2 * b.b01 + a1 * b.b12 + a0 * b.b23 + carry);
    let (res4, carry) = split_128(a3 * b.b12 + a2 * b.b23 + a1 * b.b3 + carry);
    // let (res6, carry) = split_64(a3 * b.b3 + carry);

    return (low=Uint256(low=res0, high=res2), high=Uint256(low=res4, high=a3 * b.b3 + carry));
}

func uint256_unsigned_div_rem_expanded{range_check_ptr}(a: Uint256, div: Uint256_expand) -> (
    quotient: Uint256, remainder: Uint256
) {
    alloc_locals;

    // Guess the quotient and the remainder.
    local quotient: Uint256;
    local remainder: Uint256;
    %{
        a = (ids.a.high << 128) + ids.a.low
        div = (ids.div.b23 << 128) + ids.div.b01
        quotient, remainder = divmod(a, div)

        ids.quotient.low = quotient & ((1 << 128) - 1)
        ids.quotient.high = quotient >> 128
        ids.remainder.low = remainder & ((1 << 128) - 1)
        ids.remainder.high = remainder >> 128
    %}
    uint256_check(quotient);
    uint256_check(remainder);
    let (res_mul, carry) = uint256_mul_expanded(quotient, div);
    assert carry = Uint256(0, 0);

    let (check_val, add_carry) = _uint256_add_no_uint256_check(res_mul, remainder);
    assert check_val = a;
    assert add_carry = 0;

    let (is_valid) = uint256_lt(remainder, Uint256(div.b01, div.b23));
    assert is_valid = 1;
    return (quotient=quotient, remainder=remainder);
}
