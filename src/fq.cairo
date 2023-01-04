from starkware.cairo.common.bitwise import bitwise_and, bitwise_or, bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.math import assert_in_range, assert_le, assert_nn_le, assert_not_zero
from starkware.cairo.common.math import unsigned_div_rem as felt_divmod
from starkware.cairo.common.math_cmp import is_le, is_nn
from starkware.cairo.common.registers import get_ap, get_fp_and_pc

from src.u255 import u255, Uint256, Uint512, Uint768
from src.curve import P_low, P_high, P2_low, P2_high, P3_low, P3_high, M_low, M_high, mu
from src.uint384 import uint384_lib, Uint384
from starkware.cairo.common.uint256 import SHIFT, uint256_le, uint256_lt, assert_uint256_le
from src.uint256_improvements import uint256_unsigned_div_rem
from src.utils import get_felt_bitlength, pow2, felt_divmod_no_input_check
from starkware.cairo.common.cairo_secp.bigint import BigInt3

struct Polyfelt {
    p00: felt,
    p10: felt,
    p20: felt,
    p30: felt,
    p40: felt,
}

func fq_zero() -> (res: BigInt3) {
    return (BigInt3(0, 0, 0),);
}
func fq_eq_zero(x: BigInt3) -> (res: felt) {
    if (x.d0 != 0) {
        return (res=0);
    }
    if (x.d1 != 0) {
        return (res=0);
    }
    if (x.d2 != 0) {
        return (res=0);
    }
    return (res=1);
}

namespace fq_poly {
    func to_polyfelt{range_check_ptr}(a: Uint256) -> Polyfelt {
        alloc_locals;
        let (a4, r) = uint256_unsigned_div_rem(
            a,
            Uint256(272204382041124684987214825571503402433, 1786771239255088250803009499627505898),
        );
        assert a4.high = 0;
        let (a3, r) = uint256_unsigned_div_rem(
            r, Uint256(331349846221318139915745154521890902225, 359825430517661861)
        );
        // May use felt_divmod here for the last two:
        let (a2, r) = uint256_unsigned_div_rem(
            r, Uint256(24657792813631553165138951344902952161, 0)
        );
        let (a1, a0) = uint256_unsigned_div_rem(r, Uint256(4965661367192848881, 0));

        assert a3.high = 0;
        assert a2.high = 0;
        assert a1.high = 0;
        assert a0.high = 0;

        let a00 = a0.low;
        let a10 = a1.low;
        let a20 = a2.low;
        let a30 = a3.low;
        let a40 = a4.low;

        let res = Polyfelt(a00, a10, a20, a30, a40);
        return res;
    }
    func add{range_check_ptr}(a: Polyfelt, b: Polyfelt) -> Polyfelt {
        alloc_locals;
        // BEGIN0
        // 3. c(t) = c(t) + a(t)bj
        let c00 = a.p00 + b.p00;
        %{ print_felt_info(ids.c00, "c00") %}
        // 4. mu = c00 // 2**m, gamma = c00%2**m - s*mu
        // let (mu, gamma) = felt_divmod(c00, 2 ** 63);
        let (mu, gamma) = felt_divmod_no_input_check(c00, 2 ** 63);

        const s = 857;
        let gamma = gamma - s * mu;

        // 5. g(t) = p(t) * gamma
        let (qc00, rc00) = felt_divmod_no_input_check(c00 - gamma, 4965661367192848881);
        let c00 = qc00 + mu;
        %{ print_felt_info(ids.c00, "c00") %}
        let c1000 = a.p10 + b.p10 - 6 * gamma + c00;
        let c2010 = a.p20 + b.p20 - 24 * gamma;
        let c3020 = a.p30 + b.p30 - 36 * gamma;
        let c4030 = a.p40 + b.p40;

        %{ print_felt_info(ids.c1000, "c1000") %}

        %{ print_felt_info(ids.c2010, "c2010") %}
        %{ print_felt_info(ids.c3020, "c3020") %}
        %{ print_felt_info(ids.c4030, "c4030") %}
    }
    func mul{range_check_ptr}(a: Polyfelt, b: Polyfelt) -> Polyfelt {
        alloc_locals;
        // BEGIN0
        %{ print('BEGIN0 \n') %}

        // 3. c(t) = c(t) + a(t)bj
        let c00 = a.p00 * b.p00;
        // %{ print_felt_info(ids.c00, "c00") %}
        // 4. mu = c00 // 2**m, gamma = c00%2**m - s*mu
        // let (mu, gamma) = felt_divmod(c00, 2 ** 63);
        let (mu, gamma) = felt_divmod_no_input_check(c00, 2 ** 63);

        const s = 857;
        let gamma = gamma - s * mu;

        // 5. g(t) = p(t) * gamma
        let (qc00, rc00) = felt_divmod_no_input_check(c00 - gamma, 4965661367192848881);
        let c00 = qc00 + mu;
        // %{ print_felt_info(ids.c00, "c00") %}
        let c1000 = a.p10 * b.p00 - 6 * gamma + c00;
        let c2010 = a.p20 * b.p00 - 24 * gamma;
        let c3020 = a.p30 * b.p00 - 36 * gamma;
        let c4030 = a.p40 * b.p00;

        %{ print_felt_info(ids.c1000, "c1000") %}

        %{ print_felt_info(ids.c2010, "c2010") %}
        %{ print_felt_info(ids.c3020, "c3020") %}
        %{ print_felt_info(ids.c4030, "c4030") %}

        // BEGIN1
        %{ print('BEGIN1 \n') %}

        // 3. c(t) = c(t) + a(t)bj

        let c00 = c1000 + a.p00 * b.p10;
        // %{ print_felt_info(ids.c00, "c00") %}
        // 4. mu = c00 // 2**m, gamma = c00%2**m - s*mu
        // let (mu, gamma) = felt_divmod(c00, 2 ** 63);
        let (mu, gamma) = felt_divmod_no_input_check(c00, 2 ** 63);

        let gamma = gamma - s * mu;

        // 5. g(t) = p(t) * gamma
        let (qc00, rc00) = felt_divmod_no_input_check(c00 - gamma, 4965661367192848881);
        let c00 = qc00 + mu;
        // %{ print_felt_info(ids.c00, "c00") %}
        let c1000 = c2010 + a.p10 * b.p10 - 6 * gamma + qc00 + mu;
        let c2010 = c3020 + a.p20 * b.p10 - 24 * gamma;
        let c3020 = c4030 + a.p30 * b.p10 - 36 * gamma;
        let c4030 = a.p40 * b.p10;

        // let is_nnk = is_nn(c4030t);
        // local c4030;
        // if (is_nnk == 0) {
        //     assert c4030 = (-1) * c4030t;
        // } else {
        //     assert c4030 = c4030t;
        // }
        // %{ print_felt_info(ids.c1000, "c1000") %}
        // %{ print_felt_info(ids.c2010, "c2010") %}
        // %{ print_felt_info(ids.c3020, "c3020") %}
        %{ print_felt_info(ids.c4030, "c4030") %}

        // BEGIN2
        %{ print('BEGIN2 \n') %}

        // 3. c(t) = c(t) + a(t)bj

        let c00 = c1000 + a.p00 * b.p20;
        // %{ print_felt_info(ids.c00, "c00") %}
        // 4. mu = c00 // 2**m, gamma = c00%2**m - s*mu
        // let (mu, gamma) = felt_divmod(c00, 2 ** 63);
        let (mu, gamma) = felt_divmod_no_input_check(c00, 2 ** 63);
        let gamma = gamma - s * mu;

        // 5. g(t) = p(t) * gamma
        let (qc00, rc00) = felt_divmod_no_input_check(c00 - gamma, 4965661367192848881);
        let c00 = qc00 + mu;
        // %{ print_felt_info(ids.c00, "c00") %}
        let c1000 = c2010 + a.p10 * b.p20 - 6 * gamma + qc00 + mu;
        let c2010 = c3020 + a.p20 * b.p20 - 24 * gamma;
        let c3020 = c4030 + a.p30 * b.p20 - 36 * gamma;
        let c4030 = a.p40 * b.p20;
        // let is_nnk = is_nn(c4030t);
        // local c4030;
        // if (is_nnk == 0) {
        //     assert c4030 = (-1) * c4030t;
        // } else {
        //     assert c4030 = c4030t;
        // }

        // %{ print_felt_info(ids.c1000, "c1000") %}

        // %{ print_felt_info(ids.c2010, "c2010") %}
        // %{ print_felt_info(ids.c3020, "c3020") %}
        %{ print_felt_info(ids.c4030, "c4030") %}

        // BEGIN3
        %{ print('\n BEGIN3 \n') %}
        // 3. c(t) = c(t) + a(t)bj

        let c00 = c1000 + a.p00 * b.p30;
        // %{ print_felt_info(ids.c00, "c00") %}

        let (mu, gamma) = felt_divmod_no_input_check(c00, 2 ** 63);

        let gamma = gamma - s * mu;

        // 5. g(t) = p(t) * gamma
        let (qc00, rc00) = felt_divmod_no_input_check(c00 - gamma, 4965661367192848881);
        let c00 = qc00 + mu;
        // %{ print_felt_info(ids.c00, "c00") %}
        let c1000 = c2010 + a.p10 * b.p30 - 6 * gamma + qc00 + mu;
        let c2010 = c3020 + a.p20 * b.p30 - 24 * gamma;
        let c3020 = c4030 + a.p30 * b.p30 - 36 * gamma;
        let c4030 = a.p40 * b.p30;
        // let is_nnk = is_nn(c4030t);
        // local c4030;
        // if (is_nnk == 0) {
        //     assert c4030 = (-1) * c4030t;
        // } else {
        //     assert c4030 = c4030t;
        // }

        // %{ print_felt_info(ids.c1000, "c1000") %}

        // %{ print_felt_info(ids.c2010, "c2010") %}
        // %{ print_felt_info(ids.c3020, "c3020") %}
        %{ print_felt_info(ids.c4030, "c4030") %}

        // BEGIN4

        %{ print('\n BEGIN4\n ') %}

        // 3. c(t) = c(t) + a(t)bj

        let c00 = c1000 + a.p00 * b.p40;
        // %{ print_felt_info(ids.c00, "c00") %}
        // 4. mu = c00 // 2**m, gamma = c00%2**m - s*mu
        // let (mu, gamma) = felt_divmod(c00, 2 ** 63);
        let (mu, gamma) = felt_divmod_no_input_check(c00, 2 ** 63);

        let gamma = gamma - s * mu;

        // 5. g(t) = p(t) * gamma
        let (qc00, rc00) = felt_divmod_no_input_check(c00 - gamma, 4965661367192848881);

        let c00 = qc00 + mu;
        // %{ print_felt_info(ids.c00, "c00") %}
        let c1000 = c2010 + a.p10 * b.p40 - 6 * gamma + qc00 + mu;
        let c2010 = c3020 + a.p20 * b.p40 - 24 * gamma;
        let c3020 = c4030 + a.p30 * b.p40 - 36 * gamma;

        let c4030 = a.p40 * b.p40;
        // let is_nnk = is_nn(c4030t);
        // local c4030;
        // if (is_nnk == 0) {
        //     assert c4030 = (-1) * c4030t;
        // } else {
        //     assert c4030 = c4030t;
        // }

        // %{ print_felt_info(ids.c1000, "c1000") %}
        // %{ print_felt_info(ids.c2010, "c2010") %}
        // %{ print_felt_info(ids.c3020, "c3020") %}
        %{ print_felt_info(ids.c4030, "c4030") %}

        // BEGIN 0
        // let (mu, gamma) = felt_divmod(c1000, 2 ** 63);
        let (mu, gamma) = felt_divmod_no_input_check(c1000, 2 ** 63);

        let c00 = gamma - s * mu;
        let c10 = c2010 + mu;
        // BEGIN 1
        // let (mu, gamma) = felt_divmod(c10, 2 ** 63);
        let (mu, gamma) = felt_divmod_no_input_check(c10, 2 ** 63);

        let c10 = gamma - s * mu;
        let c20 = c3020 + mu;
        // BEGIN 2
        // let (mu, gamma) = felt_divmod(c20, 2 ** 63);
        let (mu, gamma) = felt_divmod_no_input_check(c20, 2 ** 63);

        let c20 = gamma - s * mu;
        let c30 = c4030 + mu;
        // BEGIN 3
        // let (mu, gamma) = felt_divmod(c30, 2 ** 63);
        let (mu, gamma) = felt_divmod_no_input_check(c30, 2 ** 63);

        let c30 = gamma - s * mu;
        let c40 = mu;

        // BEGIN 0
        // let (mu, gamma) = felt_divmod(c1000, 2 ** 63);
        let (mu, gamma) = felt_divmod_no_input_check(c00, 2 ** 63);
        let c00 = gamma - s * mu;
        let c10 = c10 + mu;

        // BEGIN 1
        // let (mu, gamma) = felt_divmod(c10, 2 ** 63);
        let (mu, gamma) = felt_divmod_no_input_check(c10, 2 ** 63);
        let c10 = gamma - s * mu;
        let c20 = c20 + mu;
        // BEGIN 2
        // let (mu, gamma) = felt_divmod(c20, 2 ** 63);
        let (mu, gamma) = felt_divmod_no_input_check(c20, 2 ** 63);
        let c20 = gamma - s * mu;
        let c30 = c30 + mu;
        // BEGIN 3
        // let (mu, gamma) = felt_divmod(c30, 2 ** 63);
        let (mu, gamma) = felt_divmod_no_input_check(c30, 2 ** 63);
        let c30 = gamma - s * mu;
        let c40 = c40 + mu;

        %{
        %}
        let res = Polyfelt(c00, c10, c20, c30, c40);
        return res;
    }
}

namespace fq {
    // Computes a + b modulo bn254 prime
    // Assumes a+b < 2^256. If a and b both < PRIME, it is ok.
    func slow_add{range_check_ptr}(a: Uint256, b: Uint256) -> Uint256 {
        let sum = u255.add(a, b);
        return u255.a_modulo_bn254p(sum);
    }

    // a and b must both be < P
    func add{range_check_ptr}(a: Uint256, b: Uint256) -> Uint256 {
        let P = Uint256(P_low, P_high);
        // assert_uint256_le(a, P);
        // assert_uint256_le(b, P);
        let sum: Uint256 = u255.add(a, b);

        let (is_le) = uint256_lt(P, sum);
        if (is_le == 1) {
            let res = u255.sub_b(sum, P);
            return res;
        } else {
            return sum;
        }
    }
    // Computes (a - b) modulo p .
    // NOTE: Expects a and b to be reduced modulo p (i.e. between 0 and p-1). The function will revert if a > p.
    // NOTE: To reduce a, take the remainder of uint384_lin.unsigned_div_rem(a, p), and similarly for b.
    // @dev First it computes res =(a-b) mod p in a hint and then checks outside of the hint that res + b = a modulo p
    func sub{range_check_ptr}(a: Uint256, b: Uint256) -> Uint256 {
        alloc_locals;
        local res: Uint256;
        local p: Uint256 = Uint256(P_low, P_high);
        %{
            def split(num: int, num_bits_shift: int, length: int):
                a = []
                for _ in range(length):
                    a.append( num & ((1 << num_bits_shift) - 1) )
                    num = num >> num_bits_shift
                return tuple(a)

            def pack(z) -> int:
                return z.low + (z.high << 128)

            a = pack(ids.a)
            b = pack(ids.b)
            p = pack(ids.p)

            res = (a - b) % p

            res_split = split(res, num_bits_shift=128, length=2)

            ids.res.low = res_split[0]
            ids.res.high = res_split[1]
        %}
        %{ print_u_256_info(ids.res, "res") %}

        let b_plus_res: Uint256 = add(b, res);
        assert b_plus_res = a;
        return res;
    }
    // Computes a * b modulo p
    func mul{range_check_ptr}(a: Uint256, b: Uint256) -> Uint256 {
        let full_mul_result: Uint512 = u255.mul(a, b);
        // %{ print_u_512_info(ids.full_mul_result, 'full_mul') %}
        return u512_modulo_bn254p(full_mul_result);
    }

    // Computes 2*a*b modulo p
    func mul2ab{range_check_ptr}(a: Uint256, b: Uint256) -> Uint256 {
        let full_mul_result: Uint512 = u255.mul2ab(a, b);
        // %{ print_u_512_info(ids.full_mul_result, 'full_mul2') %}
        return u512_modulo_bn254p(full_mul_result);
    }
    // Computes a*a modulo p
    func square{range_check_ptr}(a: Uint256) -> Uint256 {
        let full_mul_result: Uint512 = u255.square(a);
        // %{ print_u_512_info(ids.full_mul_result, 'full_mul2') %}
        return u512_modulo_bn254p(full_mul_result);
    }
    // Computes 2*a*a modulo p
    func square2{range_check_ptr}(a: Uint256) -> Uint256 {
        let full_mul_result: Uint512 = u255.square(a);
        let full_mul_result = u255.double_u511(full_mul_result);
        // %{ print_u_512_info(ids.full_mul_result, 'full_mul2') %}
        return u512_modulo_bn254p(full_mul_result);
    }

    func fast_u512_modulo_bn254p{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
        x: Uint512
    ) -> Uint256 {
        alloc_locals;
        let P = Uint256(P_low, P_high);
        // let d2_bl = get_felt_bitlength(x.d2);

        // let n = pow2(d2_bl);
        // let n2 = pow2(d2_bl - 3);

        // splits first 3 bits (word/2**125) and last (word2)
        assert bitwise_ptr[0].x = x.d2;
        assert bitwise_ptr[0].y = 2 ** 128 - 2 ** 125;  // 2**bl-(2**(bl-3)-1) or 2**128-(2**125-1)

        assert bitwise_ptr[1].x = x.d2;
        assert bitwise_ptr[1].y = 2 ** 125 - 1;

        tempvar word = bitwise_ptr[0].x_and_y;
        tempvar word1 = bitwise_ptr[0].x_or_y - 1;
        tempvar word2 = bitwise_ptr[1].x_and_y;  // x_mod_2**3s

        // let ww = word - 2 ** 125 + 1;
        // let ww2 = x.d2 - 2 ** 126 - 2 ** 125 + 1;  //
        let x_div_23s: felt = x.d3 * 2 ** 3 + word / 2 ** 125;

        %{ print_felt_info(ids.x.d2, 'd2') %}

        %{ print_felt_info(ids.word, 'word') %}
        %{ print_felt_info(ids.word1, 'word1') %}

        %{ print_felt_info(ids.word2, 'word2') %}

        // %{ print_felt_info(ids.ww2, 'ww2') %}

        %{ print_felt_info(ids.x_div_23s, 'x_div_32s') %}
        // parse 3 high bits (cut at 381) of x.d2, multiply x.d3*2**3 + x.d2 high 3 bits
        let M_temp: Uint384 = u255.mul_M_by_u128(x_div_23s);
        local X_mod_23s: Uint384 = Uint384(x.d0, x.d1, word2);

        %{
            def pack(z, num_bits_shift: int) -> int:
                limbs = (z.d0, z.d1, z.d2)
                print(z.d0.bit_length(), z.d1.bit_length(), z.d2.bit_length())
                return sum(limb << (num_bits_shift * i) for i, limb in enumerate(limbs))
            o=pack(ids.X_mod_23s, 128)
            print('X_mod_32s', o, o.bit_length())
        %}
        let N: Uint384 = uint384_lib._add_no_uint384_check(M_temp, X_mod_23s);
        %{
            o=pack(ids.N, 128)
            print('N', o, o.bit_length())
        %}
        %{ assert ids.N.d2.bit_length()<128 %}

        assert bitwise_ptr[2].x = N.d1;
        assert bitwise_ptr[2].y = 2 ** 128 - 2 ** 126;
        tempvar word3 = bitwise_ptr[2].x_and_y;
        %{ print_felt_info(ids.word3, 'word3') %}

        let N_div_22s: felt = N.d2 * 2 ** 2 + word3 / 2 ** 126;  // + word3 - 2 ** 126 + 1;
        %{ print_felt_info(ids.N_div_22s, "n_div_254") %}

        let bitwise_ptr = bitwise_ptr + 3 * BitwiseBuiltin.SIZE;

        let T_mu_high: felt = u255.mul_mu_by_u128(N_div_22s);
        %{ print_felt_info(ids.T_mu_high, 'T_mu_high') %}
        let T_P: Uint384 = u255.mul_P_by_u128(T_mu_high);

        %{
            o=pack(ids.T_P, 128)
            print('T_P', o, o.bit_length())
        %}
        let R: Uint384 = uint384_lib.sub_b(N, T_P);
        %{
            o=pack(ids.R, 128)
            print('R', o, o.bit_length())
        %}
        // assert R.d2 = 0;
        let res = Uint256(R.d0, R.d1);
        let (is_le) = uint256_lt(P, res);
        if (is_le == 1) {
            let reduced = u255.sub_b(res, P);
            return reduced;
        } else {
            return res;
        }
    }

    func u512_modulo_bn254p{range_check_ptr}(x: Uint512) -> Uint256 {
        alloc_locals;
        local quotient: Uint512;
        local remainder: Uint256;
        local div: Uint256 = Uint256(P_low, P_high);
        %{
            def split(num: int, num_bits_shift: int, length: int):
                a = []
                for _ in range(length):
                    a.append( num & ((1 << num_bits_shift) - 1) )
                    num = num >> num_bits_shift 
                return tuple(a)

            def pack(z, num_bits_shift: int) -> int:
                limbs = (z.low, z.high)
                return sum(limb << (num_bits_shift * i) for i, limb in enumerate(limbs))
                
            def pack_extended(z, num_bits_shift: int) -> int:
                limbs = (z.d0, z.d1, z.d2, z.d3)
                return sum(limb << (num_bits_shift * i) for i, limb in enumerate(limbs))

            x = pack_extended(ids.x, num_bits_shift = 128)
            div = pack(ids.div, num_bits_shift = 128)

            quotient, remainder = divmod(x, div)

            quotient_split = split(quotient, num_bits_shift=128, length=4)

            ids.quotient.d0 = quotient_split[0]
            ids.quotient.d1 = quotient_split[1]
            ids.quotient.d2 = quotient_split[2]
            ids.quotient.d3 = quotient_split[3]

            remainder_split = split(remainder, num_bits_shift=128, length=2)
            ids.remainder.low = remainder_split[0]
            ids.remainder.high = remainder_split[1]
        %}

        let res_mul: Uint768 = u255.mul_u512_by_u256(quotient, div);

        assert res_mul.d4 = 0;
        assert res_mul.d5 = 0;

        let check_val: Uint512 = u255.add_u512_and_u256(
            Uint512(res_mul.d0, res_mul.d1, res_mul.d2, res_mul.d3), remainder
        );

        // assert add_carry = 0;
        assert check_val = x;

        let is_valid = u255.lt(remainder, div);
        assert is_valid = 1;

        return remainder;
    }

    func u512_unsigned_div_rem{range_check_ptr}(x: Uint512, div: Uint256) -> (
        q: Uint512, r: Uint256
    ) {
        alloc_locals;
        local quotient: Uint512;
        local remainder: Uint256;

        %{
            def split(num: int, num_bits_shift: int, length: int):
                a = []
                for _ in range(length):
                    a.append( num & ((1 << num_bits_shift) - 1) )
                    num = num >> num_bits_shift 
                return tuple(a)

            def pack(z, num_bits_shift: int) -> int:
                limbs = (z.low, z.high)
                return sum(limb << (num_bits_shift * i) for i, limb in enumerate(limbs))
                
            def pack_extended(z, num_bits_shift: int) -> int:
                limbs = (z.d0, z.d1, z.d2, z.d3)
                return sum(limb << (num_bits_shift * i) for i, limb in enumerate(limbs))

            x = pack_extended(ids.x, num_bits_shift = 128)
            div = pack(ids.div, num_bits_shift = 128)

            quotient, remainder = divmod(x, div)

            quotient_split = split(quotient, num_bits_shift=128, length=4)

            ids.quotient.d0 = quotient_split[0]
            ids.quotient.d1 = quotient_split[1]
            ids.quotient.d2 = quotient_split[2]
            ids.quotient.d3 = quotient_split[3]

            remainder_split = split(remainder, num_bits_shift=128, length=2)
            ids.remainder.low = remainder_split[0]
            ids.remainder.high = remainder_split[1]
        %}

        let res_mul: Uint768 = u255.mul_u512_by_u256(quotient, div);

        assert res_mul.d4 = 0;
        assert res_mul.d5 = 0;

        let check_val: Uint512 = u255.add_u512_and_u256(
            Uint512(res_mul.d0, res_mul.d1, res_mul.d2, res_mul.d3), remainder
        );

        // assert add_carry = 0;
        assert check_val = x;

        let is_valid = u255.lt(remainder, div);
        assert is_valid = 1;

        return (quotient, remainder);
    }
    func inv_mod_p_uint512{range_check_ptr}(x: Uint512) -> Uint256 {
        alloc_locals;
        local x_inverse_mod_p: Uint256;
        local p: Uint256 = Uint256(P_low, P_high);
        // To whitelist
        %{
            def pack_512(u, num_bits_shift: int) -> int:
                limbs = (u.d0, u.d1, u.d2, u.d3)
                return sum(limb << (num_bits_shift * i) for i, limb in enumerate(limbs))

            x = pack_512(ids.x, num_bits_shift = 128)
            p = ids.p.low + (ids.p.high << 128)
            x_inverse_mod_p = pow(x,-1, p) 

            x_inverse_mod_p_split = (x_inverse_mod_p & ((1 << 128) - 1), x_inverse_mod_p >> 128)

            ids.x_inverse_mod_p.low = x_inverse_mod_p_split[0]
            ids.x_inverse_mod_p.high = x_inverse_mod_p_split[1]
        %}

        let x_times_x_inverse: Uint768 = u255.mul_u512_by_u256(
            x, Uint256(x_inverse_mod_p.low, x_inverse_mod_p.high)
        );
        let x_times_x_inverse_mod_p = u255.u768_modulo_p(x_times_x_inverse);
        assert x_times_x_inverse_mod_p = Uint256(1, 0);

        return x_inverse_mod_p;
    }
    // Computes a * b^{-1} modulo p
    // NOTE: The modular inverse of b modulo p is computed in a hint and verified outside the hind with a multiplicaiton
    func div{range_check_ptr}(a: Uint256, b: Uint256) -> Uint256 {
        alloc_locals;
        local p: Uint256 = Uint256(P_low, P_high);
        local b_inverse_mod_p: Uint256;
        // To whitelist
        %{
            from starkware.python.math_utils import div_mod

            def split(a: int):
                return (a & ((1 << 128) - 1), a >> 128)

            def pack(z, num_bits_shift: int) -> int:
                limbs = (z.low, z.high)
                return sum(limb << (num_bits_shift * i) for i, limb in enumerate(limbs))

            a = pack(ids.a, 128)
            b = pack(ids.b, 128)
            p = pack(ids.p, 128)
            # For python3.8 and above the modular inverse can be computed as follows:
            # b_inverse_mod_p = pow(b, -1, p)
            # Instead we use the python3.7-friendly function div_mod from starkware.python.math_utils
            b_inverse_mod_p = div_mod(1, b, p)

            b_inverse_mod_p_split = split(b_inverse_mod_p)

            ids.b_inverse_mod_p.low = b_inverse_mod_p_split[0]
            ids.b_inverse_mod_p.high = b_inverse_mod_p_split[1]
        %}
        let b_times_b_inverse = mul(b, b_inverse_mod_p);
        assert b_times_b_inverse = Uint256(1, 0);

        let res: Uint256 = mul(a, b_inverse_mod_p);
        return res;
    }

    // Computes (a**exp) % p. Using the exponentiation by squaring algorithm, so it takes at most 256 squarings: https://en.wikipedia.org/wiki/Exponentiation_by_squaring
    func pow{range_check_ptr}(a: Uint256, exp: Uint256) -> Uint256 {
        alloc_locals;
        let is_exp_zero = u255.eq(exp, Uint256(0, 0));

        if (is_exp_zero == 1) {
            let o = Uint256(1, 0);
            return o;
        }

        let is_exp_one = u255.eq(exp, Uint256(1, 0));
        if (is_exp_one == 1) {
            // If exp = 1, it is possible that `a` is not reduced mod p,
            // so we check and reduce if necessary
            let is_a_lt_p = u255.lt(a, Uint256(P_low, P_high));
            if (is_a_lt_p == 1) {
                return a;
            } else {
                let remainder = u255.a_modulo_bn254p(a);
                return remainder;
            }
        }

        let (exp_div_2, remainder) = u255.unsigned_div_rem(exp, Uint256(2, 0));
        let is_remainder_zero = u255.eq(remainder, Uint256(0, 0));

        if (is_remainder_zero == 1) {
            // NOTE: Code is repeated in the if-else to avoid declaring a_squared as a local variable
            let a_squared_mod_p: Uint256 = square(a);
            let res = pow(a_squared_mod_p, exp_div_2);
            return res;
        } else {
            let a_squared_mod_p: Uint256 = square(a);
            let res = pow(a_squared_mod_p, exp_div_2);
            let res_mul = mul(a, res);
            return res_mul;
        }
    }
    // Finds a square of x in F_p, i.e. x ≅ y**2 (mod p) for some y
    // To do so, the following is done in a hint:
    // 0. Assume x is not  0 mod p
    // 1. Check if x is a square, if yes, find a square root r of it
    // 2. If (and only if not), then gx *is* a square (for g a generator of F_p^*), so find a square root r of it
    // 3. Check in Cairo that r**2 = x (mod p) or r**2 = gx (mod p), respectively
    // NOTE: The function assumes that 0 <= x < p
    // func get_square_root{range_check_ptr}(x: Uint256) -> (success: felt, res: Uint256) {
    //     alloc_locals;

    // // TODO: Create an equality function within field_arithmetic to avoid overflow bugs
    //     let is_zero = u255.eq(x, Uint256(0, 0));
    //     if (is_zero == 1) {
    //         return (1, Uint256(0, 0));
    //     }
    //     // let x = Uint384(x.low, x.high, 0);
    //     local p: Uint256 = Uint256(P_low, P_high);

    // local generator: Uint256 = Uint256(P_min_1_div_2_low, P_min_1_div_2_high);
    //     local success_x: felt;
    //     local success_gx: felt;
    //     local sqrt_x: Uint256;
    //     local sqrt_gx: Uint256;

    // // Compute square roots in a hint
    //     // To whitelist
    //     %{
    //         from starkware.python.math_utils import is_quad_residue, sqrt

    // def split(a: int):
    //             return (a & ((1 << 128) - 1), a >> 128)

    // def pack(z) -> int:
    //             return z.low + (z.high << 128)

    // generator = pack(ids.generator)
    //         x = pack(ids.x)
    //         p = pack(ids.p)

    // success_x = is_quad_residue(x, p)
    //         root_x = sqrt(x, p) if success_x else None
    //         success_gx = is_quad_residue(generator*x, p)
    //         root_gx = sqrt(generator*x, p) if success_gx else None

    // # Check that one is 0 and the other is 1
    //         if x != 0:
    //             assert success_x + success_gx == 1

    // # `None` means that no root was found, but we need to transform these into a felt no matter what
    //         if root_x == None:
    //             root_x = 0
    //         if root_gx == None:
    //             root_gx = 0
    //         ids.success_x = int(success_x)
    //         ids.success_gx = int(success_gx)
    //         split_root_x = split(root_x)
    //         print('split root x', split_root_x)
    //         split_root_gx = split(root_gx)
    //         ids.sqrt_x.low = split_root_x[0]
    //         ids.sqrt_x.high = split_root_x[1]
    //         ids.sqrt_gx.low = split_root_gx[0]
    //         ids.sqrt_gx.high = split_root_gx[1]
    //     %}

    // // Verify that the values computed in the hint are what they are supposed to be
    //     %{ print_u_256_info(ids.sqrt_x, 'root') %}
    //     let gx: Uint256 = mul(generator, x);
    //     if (success_x == 1) {
    //         let sqrt_x_squared: Uint256 = mul(sqrt_x, sqrt_x);

    // // Note these checks may fail if the input x does not satisfy 0<= x < p
    //         // TODO: Create a equality function within field_arithmetic to avoid overflow bugs
    //         let check_x = u255.eq(x, sqrt_x_squared);
    //         assert check_x = 1;
    //     } else {
    //         // In this case success_gx = 1
    //         let sqrt_gx_squared: Uint256 = mul(sqrt_gx, sqrt_gx);
    //         let check_gx = u255.eq(gx, sqrt_gx_squared);
    //         assert check_gx = 1;
    //     }

    // // Return the appropriate values
    //     if (success_x == 0) {
    //         // No square roots were found
    //         // Note that Uint256(0, 0) is not a square root here, but something needs to be returned
    //         return (0, Uint256(0, 0));
    //     } else {
    //         return (1, sqrt_x);
    //     }
    // }

    // TODO: not tested
    // RIght now thid function expects a and be to be between 0 and p-1
    func eq{range_check_ptr}(a: Uint256, b: Uint256) -> (res: felt) {
        let (is_a_eq_b) = u255.eq(a, b);
        return (is_a_eq_b,);
    }

    // TODO: not tested
    func is_zero{range_check_ptr}(a: Uint256) -> (bool: felt) {
        let (is_a_zero) = u255.eq(a, Uint256(0, 0));
        if (is_a_zero == 1) {
            return (1,);
        } else {
            return (0,);
        }
    }
}
