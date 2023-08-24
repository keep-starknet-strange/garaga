%builtins output range_check

from starkware.cairo.common.uint256 import SHIFT
from starkware.cairo.common.math import assert_le_felt
from starkware.cairo.common.cairo_secp.bigint import BigInt3, UnreducedBigInt5
from starkware.cairo.common.registers import get_fp_and_pc
from src.bn254.fq import nd, fq_bigint3
from src.bn254.curve import P0, P1, P2, N_LIMBS, N_LIMBS_UNREDUCED, DEGREE, BASE

const BASE_MIN_1 = BASE - 1;

func main{output_ptr: felt*, range_check_ptr}() {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    local zero: BigInt3 = BigInt3(0, 0, 0);
    local Xb: BigInt3;
    local Yb: BigInt3;
    %{
        import random, functools
        def rgetattr(obj, attr, *args):
            def _getattr(obj, attr):
                return getattr(obj, attr, *args)
            return functools.reduce(_getattr, [obj] + attr.split('.'))
        def rsetattr(obj, attr, val):
            pre, _, post = attr.rpartition('.')
            return setattr(rgetattr(obj, pre) if pre else obj, post, val)
        def get_p(n_limbs:int=ids.N_LIMBS):
            p=0
            for i in range(n_limbs):
                p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
            return p
        P=p=get_p()
        def split(x, degree=ids.DEGREE, base=ids.BASE):
            coeffs = []
            for n in range(degree, 0, -1):
                q, r = divmod(x, base ** n)
                coeffs.append(q)
                x = r
            coeffs.append(x)
            return coeffs[::-1]
        def fill_element(element:str, value:int):
            s = split(value)
            for i in range(ids.N_LIMBS): rsetattr(ids,element+'.d'+str(i),s[i])

        inputs=[random.randint(0, P) for i in range(2)]
        fill_element('Xb', inputs[0])
        fill_element('Yb', inputs[1])
    %}
    local larger_than_P: BigInt3 = BigInt3(P0, P1, P2 + 1);
    // let res0 = add_bigint3(Xb, Yb);
    let xxu = fq_bigint3.add(&Xb, &Yb);
    let xxx = fq_bigint3.sub(&Xb, &Yb);
    // let res = mul_bitwise(&Xb, &Yb);
    let res = mul_casting(&Xb, &Yb);
    let res = fq_bigint3.mul(&Xb, &Yb);

    // let res = fq_bigint3.mul(&Xb, &zero);
    // let res = fq_bigint3.mulo(&Xb, &Yb);

    %{ value = 456 + 456*2**86 + 15*2**(86*2) %}
    let value = nd();
    let (__fp__, _) = get_fp_and_pc();
    tempvar y = fp + 1;
    return ();
}

// Coprime set of modulis M, exluding M0 = p
const M1 = 16790636383536516810524;
const M2 = 16790636383536516810523;
const M3 = 16790636383536516810521;
const M_LEN = 4;

const B_P1_MOD_Q_M0 = 77371252455336267181195264;
const B_P2_MOD_Q_M0 = 5986310706507378352962293074805895248510699696029696;
const B_P3_MOD_Q_M0 = 3515256640640002027109419384348854550457404359307959241360540244102768179501;
const B_P4_MOD_Q_M0 = 644519276566291711816535256957525107255828756938133930356899123652032501050;

const B_P1_MOD_Q_M1 = 16790636383534235111196;
const B_P2_MOD_Q_M1 = 5206151823395651584;
const B_P3_MOD_Q_M1 = 14231174656339385284489;
const B_P4_MOD_Q_M1 = 4460223234760005831961;

const B_P1_MOD_Q_M2 = 16790636383534235115803;
const B_P2_MOD_Q_M2 = 5206130795275878400;
const B_P3_MOD_Q_M2 = 14648891462048755938340;
const B_P4_MOD_Q_M2 = 3980935173863203407779;

const B_P1_MOD_Q_M3 = 16790636383534235125017;
const B_P2_MOD_Q_M3 = 5206088739163734016;
const B_P3_MOD_Q_M3 = 3336158251717865685600;
const B_P4_MOD_Q_M3 = 4818051095190485903721;

const Q_MOD_M0 = 177226139842487940062469046686854454957667865308243462850485557829994085697;
const Q_MOD_M1 = 8041484681391090767143;
const Q_MOD_M2 = 1854072493394001233807;
const Q_MOD_M3 = 451894199828812046474;

const R_BOUND = (N_LIMBS ** 2) * BASE ** 2 - 1;  // |r| < n**2 * b ** 2
const S_BOUND = 2 * (N_LIMBS ** 2) * BASE ** 2 - 1;  // |s| < 2 * n**2 * b ** 2

func mul_casting{range_check_ptr}(a: BigInt3*, b: BigInt3*) -> BigInt3* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    local z: BigInt3;
    local r: felt;
    local s1: felt;
    local s2: felt;
    local s3: felt;
    %{
        from starkware.cairo.common.math_utils import as_int
        assert 1 < ids.N_LIMBS <= 12
        assert ids.DEGREE == ids.N_LIMBS-1
        a_limbs, b_limbs, q = ids.N_LIMBS*[0], ids.N_LIMBS*[0], 0
        M = ids.M_LEN * [0]

        def split(x, base=ids.BASE):
            coeffs, degree = [] , ids.DEGREE
            for n in range(degree, 0, -1):
                q, r = divmod(x, base ** n)
                coeffs.append(q)
                x = r
            coeffs.append(x)
            return coeffs[::-1]
        #evaluate x(b)
        def sigma_b(x:list, b:int = ids.BASE) -> int:
            result = 0
            for i in range(len(x)):
                assert x[i] < b, f"Error: wrong bounds {x[i]} >= {b}"
                result += b**i * x[i]
            assert 0 <= result < b**(len(x)) - 1, f"Error: wrong bounds {result} >= {b**(len(x)) - 1}"
            return result
        # evaluate x(b) mod m
        def sigma_b_mod_m(x:list, m:int, b:int=ids.BASE, n=ids.N_LIMBS) -> int:
            result = 0
            assert len(x) == ids.N_LIMBS, "Error: sigma_b_mod_m() requires a list of length N_LIMBS"
            for i in range(n):
                result += (b**i % m) * x[i]
            return result

        # multiply x(b) and y(b) mod m, returns limbs and x(b)*y(b) mod m
        def pi_b_mod_m(x:list, y:list, m:int, b:int=ids.BASE, n=ids.N_LIMBS) -> int:
            assert len(x) == len(y) == n, "Error: pi_b() requires two lists of length n"
            result = 0
            for i in range(ids.N_LIMBS):
                for j in range(n):
                    result += x[i]*y[j] * (b**(i+j)%m)
            return result

        def sigma_b_mod_q_mod_m(x:list, q:int, m:int, b:int=ids.BASE) -> int:
            result = 0
            for i in range(len(x)):
                result += ((b**i % q) % m) * x[i]
            return result

        def pi_b_mod_q_mod_m(x:list, y:list, q:int, m:int, b:int=ids.BASE, n=ids.N_LIMBS) -> int:
            result = 0
            for i in range(n):
                for j in range(n):
                    result += x[i]*y[j] * ((b**(i+j)%q)%m)
            return result

        def get_witness_z_r_s(x:list, y:list, M:list):
            z:list = split(sigma_b(x) * sigma_b(y) % q)
            pi:int = pi_b_mod_m(x, y, q)
            sigma:int = sigma_b_mod_m(z, q)
            r_q = pi - sigma
            assert r_q % q == 0, "Error: r_q is not divisible by q"
            r = r_q // q
            S = []
            for i in range(len(M)):
                m = M[i]
                pi:int = pi_b_mod_q_mod_m(x, y, q, m)
                sigma:int = sigma_b_mod_q_mod_m(z, q, m)
                s_m = pi - sigma - r*(q%m)
                assert s_m % m == 0, "Error: s_m is not divisible by m"
                s = s_m // m
                S.append(s)
            return z, r, S

        for i in range(ids.N_LIMBS):
            a_limbs[i]=as_int(getattr(ids.a, 'd'+str(i)),PRIME)
            b_limbs[i]=as_int(getattr(ids.b, 'd'+str(i)),PRIME)
            q+=getattr(ids, 'P'+str(i)) * ids.BASE**i
        M[0] = PRIME
        for i in range(1, ids.M_LEN):
            M[i] = getattr(ids, 'M'+str(i))

        z, r, S = get_witness_z_r_s(a_limbs, b_limbs, M)

        for i in range(ids.N_LIMBS):
            setattr(ids.z, 'd'+str(i), z[i])
        for i in range(1, ids.M_LEN):
            setattr(ids, 's'+str(i), S[i])
        ids.r = r
    %}
    // mul_sub = val = a * b  - result
    tempvar val: UnreducedBigInt5 = UnreducedBigInt5(
        d0=a.d0 * b.d0 - z.d0,
        d1=a.d0 * b.d1 + a.d1 * b.d0 - z.d1,
        d2=a.d0 * b.d2 + a.d1 * b.d1 + a.d2 * b.d0 - z.d2,
        d3=a.d1 * b.d2 + a.d2 * b.d1,
        d4=a.d2 * b.d2,
    );

    assert val.d0 + val.d1 * B_P1_MOD_Q_M0 + val.d2 * B_P2_MOD_Q_M0 + val.d3 * B_P3_MOD_Q_M0 +
        val.d4 * B_P4_MOD_Q_M0 = r * Q_MOD_M0;
    assert val.d0 + val.d1 * B_P1_MOD_Q_M1 + val.d2 * B_P2_MOD_Q_M1 + val.d3 * B_P3_MOD_Q_M1 +
        val.d4 * B_P4_MOD_Q_M1 - r * Q_MOD_M1 = s1 * M1;
    assert val.d0 + val.d1 * B_P1_MOD_Q_M2 + val.d2 * B_P2_MOD_Q_M2 + val.d3 * B_P3_MOD_Q_M2 +
        val.d4 * B_P4_MOD_Q_M2 - r * Q_MOD_M2 = s2 * M2;
    assert val.d0 + val.d1 * B_P1_MOD_Q_M3 + val.d2 * B_P2_MOD_Q_M3 + val.d3 * B_P3_MOD_Q_M3 +
        val.d4 * B_P4_MOD_Q_M3 - r * Q_MOD_M3 = s3 * M3;

    // |r| < n**2 * n ** 2
    assert_le_felt(r, R_BOUND);
    assert_le_felt(s1, S_BOUND);
    assert_le_felt(s2, S_BOUND);
    assert_le_felt(s3, S_BOUND);
    return &z;
}

// func mul_bitwise{bitwise_ptr: BitwiseBuiltin*}(a: BigInt3*, b: BigInt3*) -> BigInt3* {
//     alloc_locals;
//     let (__fp__, _) = get_fp_and_pc();
//     local q: BigInt3;
//     local r: BigInt3;
//     %{
//         from starkware.cairo.common.math_utils import as_int
//         assert 1 < ids.N_LIMBS <= 12
//         assert ids.DEGREE == ids.N_LIMBS-1
//         a,b,p=0,0,0

// def split(x, degree=ids.DEGREE, base=ids.BASE):
//             coeffs = []
//             for n in range(degree, 0, -1):
//                 q, r = divmod(x, base ** n)
//                 coeffs.append(q)
//                 x = r
//             coeffs.append(x)
//             return coeffs[::-1]

// for i in range(ids.N_LIMBS):
//             a+=as_int(getattr(ids.a, 'd'+str(i)),PRIME) * ids.BASE**i
//             b+=as_int(getattr(ids.b, 'd'+str(i)),PRIME) * ids.BASE**i
//             p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
//         mul = a*b
//         q, r = divmod(mul, p)
//         qs, rs = split(q), split(r)
//         for i in range(ids.N_LIMBS):
//             setattr(ids.r, 'd'+str(i), rs[i])
//             setattr(ids.q, 'd'+str(i), qs[i])
//     %}

// // mul_sub = val = a * b  - a*b%p
//     tempvar val_d0 = a.d0 * b.d0;
//     tempvar val_d1 = a.d0 * b.d1 + a.d1 * b.d0;
//     tempvar val_d2 = a.d0 * b.d2 + a.d1 * b.d1 + a.d2 * b.d0;
//     tempvar val_d3 = a.d1 * b.d2 + a.d2 * b.d1;
//     // tempvar val_d4 = a.d2 * b.d2;

// tempvar qP_d0 = q.d0 * P0 + r.d0;
//     tempvar qP_d1 = q.d0 * P1 + q.d1 * P0 + r.d1;
//     tempvar qP_d2 = q.d0 * P2 + q.d1 * P1 + q.d2 * P0 + r.d2;
//     tempvar qP_d3 = q.d1 * P2 + q.d2 * P1;
//     // tempvar qP_d4 = q.d2 * P2;

// // // val mod P = 0, so val = k_P
//     %{
//         print(f"qP_d0 - val_d0 = {ids.qP_d0 - ids.val_d0}")
//         print(f"qP_d1 - val_d1 = {ids.qP_d1 - ids.val_d1}")
//         print(f"qP_d2 - val_d2 = {ids.qP_d2 - ids.val_d2}")
//         print(f"qP_d3 - val_d3 = {ids.qP_d3 - ids.val_d3}")
//     %}
//     local flag0: felt;
//     local flag1: felt;
//     local flag2: felt;
//     local flag3: felt;

// local q0: felt;
//     local q1: felt;
//     local q2: felt;
//     local q3: felt;

// %{
//         for i in range(0, ids.N_LIMBS_UNREDUCED-1):
//             setattr(ids, 'flag'+str(i), 1 if getattr(ids, 'qP_d'+str(i)) - getattr(ids, 'val_d'+str(i)) >= 0 else 0)
//     %}

// if (flag0 != 0) {
//         assert bitwise_ptr[0].x = qP_d0 - val_d0;
//         assert bitwise_ptr[0].y = BASE_MIN_1;
//         assert bitwise_ptr[0].x_and_y = 0;
//         assert q0 = bitwise_ptr[0].x / BASE;
//     } else {
//         assert bitwise_ptr[0].x = val_d0 - qP_d0;
//         assert bitwise_ptr[0].y = BASE_MIN_1;
//         assert bitwise_ptr[0].x_and_y = 0;
//         assert q0 = (-1) * bitwise_ptr[0].x / BASE;
//     }

// %{ print(f"q0 = {ids.q0}") %}

// if (flag1 != 0) {
//         assert bitwise_ptr[1].x = qP_d1 - val_d1 + q0;
//         assert bitwise_ptr[1].y = BASE_MIN_1;
//         assert bitwise_ptr[1].x_and_y = 0;
//         assert q1 = bitwise_ptr[1].x / BASE;
//     } else {
//         assert bitwise_ptr[1].x = val_d1 - qP_d1 - q0;
//         assert bitwise_ptr[1].y = BASE_MIN_1;
//         assert bitwise_ptr[1].x_and_y = 0;
//         assert q1 = (-1) * bitwise_ptr[1].x / BASE;
//     }

// %{ print(f"q1 = {ids.q1}") %}

// if (flag2 != 0) {
//         assert bitwise_ptr[2].x = qP_d2 - val_d2 + q1;
//         assert bitwise_ptr[2].y = BASE_MIN_1;
//         assert bitwise_ptr[2].x_and_y = 0;
//         assert q2 = bitwise_ptr[2].x / BASE;
//     } else {
//         assert bitwise_ptr[2].x = val_d2 - qP_d2 - q1;
//         assert bitwise_ptr[2].y = BASE_MIN_1;
//         assert bitwise_ptr[2].x_and_y = 0;
//         assert q2 = (-1) * bitwise_ptr[2].x / BASE;
//     }

// %{ print(f"q2 = {ids.q2}") %}

// if (flag3 != 0) {
//         assert bitwise_ptr[3].x = qP_d3 - val_d3 + q2;
//         assert bitwise_ptr[3].y = BASE_MIN_1;
//         assert bitwise_ptr[3].x_and_y = 0;
//         assert q3 = bitwise_ptr[3].x / BASE;
//     } else {
//         assert bitwise_ptr[3].x = val_d3 - qP_d3 - q2;
//         assert bitwise_ptr[3].y = BASE_MIN_1;
//         assert bitwise_ptr[3].x_and_y = 0;
//         assert q3 = (-1) * bitwise_ptr[3].x / BASE;
//     }

// %{ print(f"q3 = {ids.q3}") %}

// let bitwise_ptr = bitwise_ptr + 4 * BitwiseBuiltin.SIZE;

// assert q.d2 * P2 - a.d2 * b.d2 + q3 = 0;

// return &r;
// }

// func add_rc{range_check_ptr}(a0, a1, a2, b0, b1, b2) -> BigInt3* {
//     let (__fp__, _) = get_fp_and_pc();
//     // compute case_index
//     %{
//         BASE = ids.BASE
//         assert 1 < ids.N_LIMBS <= 12

// p, sum_limbs = 0, []
//         for i in range(ids.N_LIMBS):
//             p+=getattr(ids, 'P'+str(i)) * BASE**i

// p_limbs = [getattr(ids, 'P'+str(i)) for i in range(ids.N_LIMBS)]
//         sum_limbs = [getattr(getattr(ids, 'a'), 'd'+str(i)) + getattr(getattr(ids, 'b'), 'd'+str(i)) for i in range(ids.N_LIMBS)]
//         sum_unreduced = sum([sum_limbs[i] * BASE**i for i in range(ids.N_LIMBS)])
//         sum_reduced = [sum_limbs[i] - p_limbs[i] for i in range(ids.N_LIMBS)]
//         has_carry = [1 if sum_limbs[0] >= BASE else 0]
//         for i in range(1,ids.N_LIMBS):
//             if sum_limbs[i] + has_carry[i-1] >= BASE:
//                 has_carry.append(1)
//             else:
//                 has_carry.append(0)
//         needs_reduction = 1 if sum_unreduced >= p else 0
//         has_borrow_carry_reduced = [-1 if sum_reduced[0] < 0 else (1 if sum_reduced[0]>=BASE else 0)]
//         for i in range(1,ids.N_LIMBS):
//             if (sum_reduced[i] + has_borrow_carry_reduced[i-1]) < 0:
//                 has_borrow_carry_reduced.append(-1)
//             elif (sum_reduced[i] + has_borrow_carry_reduced[i-1]) >= BASE:
//                 has_borrow_carry_reduced.append(1)
//             else:
//                 has_borrow_carry_reduced.append(0)

// case_dict = {[0, 0,0]:0, [0,1,0]:1, [0,0,1]:2, [0,1,1]:3,
//                     [1,0,0]:4, [1,1,0]:5, [1,0,1]:6, [1,1,1]:7,
//                     [1,-1,0]:8, [1,0,-1]:9, [1,-1,-1]:10, [1,-1,1]:11, [1, 1,-1]:12}}

// case_index = [needs_reduction]
//         for i in range(ids.N_LIMBS-1):
//             if needs_reduction:
//                 case_index[1+i] = has_borrow_carry_reduced[i]
//             else:
//                 case_index[1+i] = has_carry[i]

// #memory[fp+2] = 1 + ids.N_LIMBS * case_dict[case_index]
//     %}
//     %{ memory[fp+2] = 1 + ids.N_LIMBS * case_dict[case_index] %}
//     ap += 1;
//     jmp rel [fp + 2];
//     // case 0 : No reduction, c0 = 0, c1 = 0
//     [fp + 3] = [[fp - 3]] + [[fp - 4]], ap++;
//     [fp + 4] = a1 + b.d1, ap++;
//     [fp + 5] = a2 + b.d2, ap++;
//     jmp end;
//     // case 1 : No reduction, c0=1, c1 = 0
//     [fp + 3] = a0 + b.d0 - BASE, ap++;
//     [fp + 4] = a1 + b.d1 + 1, ap++;
//     [fp + 5] = a2 + b.d2, ap++;
//     jmp end;
//     // case 2 : No reduction, c0=0, c1 = 1
//     [fp + 3] = a0 + b.d0, ap++;
//     [fp + 4] = a1 + b.d1 - BASE, ap++;
//     [fp + 5] = a2 + b.d2 + 1, ap++;
//     jmp end;
//     // case 3 : No reduction, c0=1, c1 = 1
//     [fp + 3] = a0 + b.d0 - BASE, ap++;
//     [fp + 4] = a1 + b.d1 + 1 - BASE, ap++;
//     [fp + 5] = a2 + b.d2 + 1, ap++;
//     jmp end;
//     // case 4 : Reduction, c0 = 0, c1 = 0
//     [fp + 3] = a0 + b.d0 - P0, ap++;
//     [fp + 4] = a1 + b.d1 - P1, ap++;
//     [fp + 5] = a2 + b.d2 - P2, ap++;
//     jmp end;
//     // case 5 : Reduction, c0 = 1, c1 = 0
//     [fp + 3] = a0 + b.d0 - P0 - BASE, ap++;
//     [fp + 4] = a1 + b.d1 - P1 + 1, ap++;
//     [fp + 5] = a2 + b.d2 - P2, ap++;
//     jmp end;
//     // case 6 : Reduction, c0 = 0, c1 = 1
//     [fp + 3] = a0 + b.d0 - P0, ap++;
//     [fp + 4] = a1 + b.d1 - P1 - BASE, ap++;
//     [fp + 5] = a2 + b.d2 - P2 + 1, ap++;
//     jmp end;
//     // case 7 : Reduction, c0 = 1, c1 = 1
//     [fp + 3] = a0 + b.d0 - P0 - BASE, ap++;
//     [fp + 4] = a1 + b.d1 - P1 + 1 - BASE, ap++;
//     [fp + 5] = a2 + b.d2 - P2 + 1, ap++;
//     jmp end;
//     // case 8 : Reduction c0 = -1, c1 = 0
//     [fp + 3] = a0 + b.d0 - P0 + BASE, ap++;
//     [fp + 4] = a1 + b.d1 - P1 - 1, ap++;
//     [fp + 5] = a2 + b.d2 - P2, ap++;
//     jmp end;
//     // case 9 : Reduction c0 = 0, c1 = -1
//     [fp + 3] = a0 + b.d0 - P0, ap++;
//     [fp + 4] = a1 + b.d1 - P1 + BASE, ap++;
//     [fp + 5] = a2 + b.d2 - P2 - 1, ap++;
//     jmp end;
//     // case 10 : Reduction c0 = -1, c1 = -1
//     [fp + 3] = a0 + b.d0 - P0 + BASE, ap++;
//     [fp + 4] = a1 + b.d1 - P1 - 1 + BASE, ap++;
//     [fp + 5] = a2 + b.d2 - P2 - 1, ap++;
//     jmp end;
//     // case 11 : Reduction c0 = -1, c1 = 1
//     [fp + 3] = a0 + b.d0 - P0 + BASE, ap++;
//     [fp + 4] = a1 + b.d1 - P1 - 1 - BASE, ap++;
//     [fp + 5] = a.d2 + b.d2 - P2 + 1, ap++;
//     jmp end;
//     // case 12 : Reduction c0 = 1, c1 = -1
//     [fp + 3] = a0 + b.d0 - P0 - BASE, ap++;
//     [fp + 4] = a1 + b.d1 - P1 + 1 + BASE, ap++;
//     [fp + 5] = a.d2 + b.d2 - P2 - 1, ap++;
//     jmp end;

// end:
//     return fp + 3;
//     // assert [range_check_ptr] = BASE_MIN_1 - [fp + 5];
//     // assert [range_check_ptr + 1] = BASE_MIN_1 - [fp + 6];
//     // assert [range_check_ptr + 2] = P2 - [fp + 7];

// // if (res.d2 == P2) {
//     //     if (res.d1 == P1) {
//     //         assert [range_check_ptr + 3] = P0 - 1 - [fp + 5];
//     //         tempvar range_check_ptr = range_check_ptr + 4;
//     //         return fp + 5;
//     //     } else {
//     //         assert [range_check_ptr + 3] = P1 - 1 - [fp + 6];
//     //         tempvar range_check_ptr = range_check_ptr + 4;
//     //         return fp + 5;
//     //     }
//     // } else {
//     //     tempvar range_check_ptr = range_check_ptr + 3;
//     //     return fp + 5;
//     // }
// }
