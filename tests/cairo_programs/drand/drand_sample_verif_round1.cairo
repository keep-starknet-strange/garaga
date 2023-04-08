%builtins range_check
from starkware.cairo.common.registers import get_label_location
from src.bls12_381.g1 import G1Point, g1
from src.bls12_381.g2 import G2Point, g2, E4
from src.bls12_381.towers.e12 import E12, e12
from src.bls12_381.towers.e2 import E2, e2
from src.bls12_381.towers.e6 import E6, e6
from src.bls12_381.curve import CURVE, BASE, DEGREE, N_LIMBS, P0, P1, P2, P3
from src.bls12_381.fq import BigInt4, fq_bigint4
from starkware.cairo.common.registers import get_fp_and_pc
from src.bls12_381.pairing import get_loop_digit, final_exponentiation

from tests.cairo_programs.drand.drand_gen_nQ_lines import get_nQ_lines as get_drand_gen_nQ_lines
from tests.cairo_programs.drand.drand_pk_nQ_lines import get_nQ_lines as get_drand_pk_nQ_lines

func main{range_check_ptr}() {
    alloc_locals;
    %{
        import subprocess, random, functools, re
        CURVE_STR = bytes.fromhex(f'{ids.CURVE:x}').decode('ascii')
        MAIN_FILE = './tools/parser_go/' + CURVE_STR + '/cairo_test/main'
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
        def rgetattr(obj, attr, *args):
            def _getattr(obj, attr):
                return getattr(obj, attr, *args)
            return functools.reduce(_getattr, [obj] + attr.split('.'))
        def rsetattr(obj, attr, val):
            pre, _, post = attr.rpartition('.')
            return setattr(rgetattr(obj, pre) if pre else obj, post, val)

        def fill_element(element:str, value:int):
            s = split(value)
            for i in range(ids.N_LIMBS): rsetattr(ids,element+'.d'+str(i),s[i])
        def fill_e12(e2:str, *args):
            for i in range(12):
                splitted = split(args[i])
                for j in range(ids.N_LIMBS):
                    rsetattr(ids,e2+str(i)+'.d'+str(j),splitted[j])
            return None
        def parse_fp_elements(input_string:str):
            pattern = re.compile(r'\[([^\[\]]+)\]')
            substrings = pattern.findall(input_string)
            sublists = [substring.split(' ') for substring in substrings]
            sublists = [[int(x) for x in sublist] for sublist in sublists]
            fp_elements = [x[0] + x[1]*2**64 + x[2]*2**128 + x[3]*2**192  + x[4]*2**256 + x[5] * 2**320 for x in sublists]
            return fp_elements
    %}
    let (__fp__, _) = get_fp_and_pc();
    local sigmax: BigInt4;
    local sigmay: BigInt4;

    local messagex: BigInt4;
    local messagey: BigInt4;

    local pkx0: BigInt4;
    local pkx1: BigInt4;
    local pky0: BigInt4;
    local pky1: BigInt4;
    // local e_vk0: BigInt4;
    // local e_vk1: BigInt4;
    // local e_vk2: BigInt4;
    // local e_vk3: BigInt4;
    // local e_vk4: BigInt4;
    // local e_vk5: BigInt4;
    // local e_vk6: BigInt4;
    // local e_vk7: BigInt4;
    // local e_vk8: BigInt4;
    // local e_vk9: BigInt4;
    // local e_vk10: BigInt4;
    // local e_vk11: BigInt4;

    // local e0: BigInt4;
    // local e1: BigInt4;
    // local e2: BigInt4;
    // local e3: BigInt4;
    // local e4: BigInt4;
    // local e5: BigInt4;
    // local e6: BigInt4;
    // local e7: BigInt4;
    // local e8: BigInt4;
    // local e9: BigInt4;
    // local e10: BigInt4;
    // local e11: BigInt4;
    %{
        for var_name in list(program_input.keys()):
            if type(program_input[var_name]) == str : continue
            fill_element(var_name, program_input[var_name])
    %}
    // %{
    //     felts = [0x1544ddce2fdbe8688d6f5b4f98eed5d63eee3902e7e162050ac0f45905a55657714880adabe3c3096b92767d886567d0,-0x0c207a831b19dfd8126b725a55c0ecf45610aa1bbfd21755ebee0d1cdf6c19c804652e1cda374694ff73d7b364ec33bc%p]
    //     felts+= [0x024aa2b2f08f0a91260805272dc51051c6e47ad4fa403b02b4510b647ae3d1770bac0326a805bbefd48056c8c121bdb8,0x13e02b6052719f607dacd3a088274f65596bd0d09920b61ab5da61bbdc7f5049334cf11213945d57e5ac7d055d042b7e, 0x0ce5d527727d6e118cc9cdc6da2e351aadfd9baa8cbdd3a76d429a695160d12c923ac9cc3baca289e193548608b82801, 0x0606c4a02ea734cc32acd2b02bc28b99cb3e287e85a763af267492ab572e99ab3f370d275cec1da1aaa9075ff05f79be]
    //     cmd = [MAIN_FILE, 'pair', 'pair'] + [str(x) for x in felts]
    //     out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
    //     print(out)
    //     fp_elements = parse_fp_elements(out)
    //     assert len(fp_elements) == 12
    //     fill_e12('e', *fp_elements)
    //     felts=[0x15b110e567bf88e6302b8d3abb546d59558d97715c4228821aecaa6f2df0e6990f47aca1294ad384d1bf168478ce58bf, 0x0c0c4fe2e9e241e0b40aa4936a3f4fd779067c4c16d11085ec69a47c3f4f8161be6e354502b479c153e8937a01317c2e]
    //     felts+=[0x0df0b8b6dce385811d6dcf8cbefb8759e5e616a3dfd054c928940766d9a5b9db91e3b697e5d70a975181e007f87fca5e, 0x00b862a7527fee3a731bcb59280ab6abd62d5c0b6ea03dc4ddf6612fdfc9d01f01c31542541771903475eb1ec6615f8d, 0x09518ba5deb9dcff223f3e24a70ac914947f300384b354a7c99f4b0cd208a75c5a938601a6afabb962e8a6c75aa67b82, 0x0fbf5a7ef15d600ac4f6d5c8aae3a6036e65e4f62e6ba07b143b8a510a74d28b3e065c95dda40902164e0dba3e695619]
    //     cmd = [MAIN_FILE, 'pair', 'pair'] + [str(x) for x in felts]
    //     out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
    //     #print(out)
    //     fp_elements = parse_fp_elements(out)
    //     assert len(fp_elements) == 12
    //     fill_e12('e_vk', *fp_elements)
    // %}
    // tempvar e_vk: E12* = new E12(
    //     new E6(new E2(&e_vk0, &e_vk1), new E2(&e_vk2, &e_vk3), new E2(&e_vk4, &e_vk5)),
    //     new E6(new E2(&e_vk6, &e_vk7), new E2(&e_vk8, &e_vk9), new E2(&e_vk10, &e_vk11)),
    // );
    // tempvar e: E12* = new E12(
    //     new E6(new E2(&e0, &e1), new E2(&e2, &e3), new E2(&e4, &e5)),
    //     new E6(new E2(&e6, &e7), new E2(&e8, &e9), new E2(&e10, &e11)),
    // );
    let one = e12.one();
    // e12.assert_E12(e, e_vk);

    // let e_vk = e12.mul(e, e_vk);
    // e12.assert_E12(one, e_vk);

    local sigma: G1Point = G1Point(&sigmax, &sigmay);
    let sigma_neg = g1.neg(&sigma);
    local message: G1Point = G1Point(&messagex, &messagey);
    local pk_g2_x: E2 = E2(&pkx0, &pkx1);
    local pk_g2_y: E2 = E2(&pky0, &pky1);
    local pk_g2: G2Point = G2Point(&pk_g2_x, &pk_g2_y);
    g1.assert_on_curve(sigma);
    g1.assert_on_curve([sigma_neg]);
    g1.assert_on_curve(message);
    g2.assert_on_curve(pk_g2);
    %{ print(f"Computing m1 = miller(-sigma, G2) ...") %}
    let m1 = miller_loop_fixed_G2(sigma_neg);
    %{ print(f"Computing m1 = miller(H(m), drand_public_key) ...") %}
    let m2 = miller_loop_fixed_Pk(&message);
    let m = e12.mul(m1, m2);
    %{ print(f"Computing E = final_exp(m1*m2) ...") %}
    let res = final_exponentiation(m);
    %{ print(f"Checking E == 1 ...") %}
    e12.assert_E12(res, one);
    %{ print(f"BLS Signature is valid!") %}
    return ();
}

func miller_loop_fixed_G2{range_check_ptr}(P: G1Point*) -> E12* {
    alloc_locals;
    // todo : Assert P, Q not 0 (point at infinity)
    %{
        import numpy as np
        def print_G2(id, index, bit):
            x0 = id.x.a0.d0 + id.x.a0.d1 * 2**96 + id.x.a0.d2 * 2**192 + id.x.a0.d3 * 2**288
            x1 = id.x.a1.d0 + id.x.a1.d1 * 2**96 + id.x.a1.d2 * 2**192 + id.x.a1.d3 * 2**288
            y0 = id.y.a0.d0 + id.y.a0.d1 * 2**96 + id.y.a0.d2 * 2**192 + id.y.a0.d3 * 2**288 
            y1 = id.y.a1.d0 + id.y.a1.d1 * 2**96 + id.y.a1.d2 * 2**192 + id.y.a1.d3 * 2**288 
            print(f"{index} || {bit} X={np.base_repr(x0,36).lower()} + {np.base_repr(x1,36).lower()}*u ")
            # print(f"Y={np.base_repr(y0,36).lower()} + {np.base_repr(y1,36).lower()}*u")
    %}

    // local Q_original: G2Point* = Q;

    let result = e12.one();
    let xp_bar = fq_bigint4.neg(P.x);
    let yp_prime = fq_bigint4.inv(P.y);
    let xp_prime = fq_bigint4.mul(xp_bar, yp_prime);
    let (Q: G2Point*, local l1: E4*) = get_drand_gen_nQ_lines(0);
    let l1r0 = e2.mul_by_element(yp_prime, l1.r0);
    let l1r1 = e2.mul_by_element(xp_prime, l1.r1);

    let (Q: G2Point*, local l2: E4*) = get_drand_gen_nQ_lines(1);
    let l2r0 = e2.mul_by_element(yp_prime, l2.r0);
    let l2r1 = e2.mul_by_element(xp_prime, l2.r1);

    let lines = e12.mul_014_by_014(l1r0, l1r1, l2r0, l2r1);
    let result = e12.mul(result, lines);
    let n = 2;
    with n, xp_prime, yp_prime {
        let (local final_Q: G2Point*, local result: E12*) = miller_loop_fixed_G2_inner(
            Q=Q, result=result, index=61
        );
    }

    return result;
}
func miller_loop_fixed_G2_inner{range_check_ptr, n: felt, xp_prime: BigInt4*, yp_prime: BigInt4*}(
    Q: G2Point*, result: E12*, index: felt
) -> (point: G2Point*, res: E12*) {
    alloc_locals;
    if (index == -1) {
        let result = e12.conjugate(result);
        return (Q, result);
    }

    let result = e12.square(result);
    let (Q: G2Point*, l1: E4*) = get_drand_gen_nQ_lines(n);
    let l1r0 = e2.mul_by_element(yp_prime, l1.r0);
    let l1r1 = e2.mul_by_element(xp_prime, l1.r1);
    let n = n + 1;
    let (local bit: felt) = get_loop_digit(index);
    if (bit == 0) {
        let result = e12.mul_by_014(result, l1r0, l1r1);
        // %{ print_G2(ids.Q, ids.index, ids.bit) %}
        return miller_loop_fixed_G2_inner(Q, result, index - 1);
    } else {
        let (Q: G2Point*, l2: E4*) = get_drand_gen_nQ_lines(n);
        let l2r0 = e2.mul_by_element(yp_prime, l2.r0);
        let l2r1 = e2.mul_by_element(xp_prime, l2.r1);
        let n = n + 1;
        let lines = e12.mul_014_by_014(l1r0, l1r1, l2r0, l2r1);
        let result = e12.mul(result, lines);
        return miller_loop_fixed_G2_inner(Q, result, index - 1);
    }
}

func miller_loop_fixed_Pk{range_check_ptr}(P: G1Point*) -> E12* {
    alloc_locals;
    // todo : Assert P, Q not 0 (point at infinity)
    %{
        import numpy as np
        def print_G2(id, index, bit):
            x0 = id.x.a0.d0 + id.x.a0.d1 * 2**96 + id.x.a0.d2 * 2**192 + id.x.a0.d3 * 2**288
            x1 = id.x.a1.d0 + id.x.a1.d1 * 2**96 + id.x.a1.d2 * 2**192 + id.x.a1.d3 * 2**288
            y0 = id.y.a0.d0 + id.y.a0.d1 * 2**96 + id.y.a0.d2 * 2**192 + id.y.a0.d3 * 2**288 
            y1 = id.y.a1.d0 + id.y.a1.d1 * 2**96 + id.y.a1.d2 * 2**192 + id.y.a1.d3 * 2**288 
            print(f"{index} || {bit} X={np.base_repr(x0,36).lower()} + {np.base_repr(x1,36).lower()}*u ")
            # print(f"Y={np.base_repr(y0,36).lower()} + {np.base_repr(y1,36).lower()}*u")
    %}

    // local Q_original: G2Point* = Q;

    let result = e12.one();
    let xp_bar = fq_bigint4.neg(P.x);
    let yp_prime = fq_bigint4.inv(P.y);
    let xp_prime = fq_bigint4.mul(xp_bar, yp_prime);
    let (Q: G2Point*, local l1: E4*) = get_drand_pk_nQ_lines(0);
    let l1r0 = e2.mul_by_element(yp_prime, l1.r0);
    let l1r1 = e2.mul_by_element(xp_prime, l1.r1);

    let (Q: G2Point*, local l2: E4*) = get_drand_pk_nQ_lines(1);
    let l2r0 = e2.mul_by_element(yp_prime, l2.r0);
    let l2r1 = e2.mul_by_element(xp_prime, l2.r1);

    let lines = e12.mul_014_by_014(l1r0, l1r1, l2r0, l2r1);
    let result = e12.mul(result, lines);
    let n = 2;
    with n, xp_prime, yp_prime {
        let (local final_Q: G2Point*, local result: E12*) = miller_loop_fixed_Pk_inner(
            Q=Q, result=result, index=61
        );
    }

    return result;
}
func miller_loop_fixed_Pk_inner{range_check_ptr, n: felt, xp_prime: BigInt4*, yp_prime: BigInt4*}(
    Q: G2Point*, result: E12*, index: felt
) -> (point: G2Point*, res: E12*) {
    alloc_locals;
    if (index == -1) {
        let result = e12.conjugate(result);
        return (Q, result);
    }

    let result = e12.square(result);
    let (Q: G2Point*, l1: E4*) = get_drand_pk_nQ_lines(n);
    let l1r0 = e2.mul_by_element(yp_prime, l1.r0);
    let l1r1 = e2.mul_by_element(xp_prime, l1.r1);
    let n = n + 1;
    let (local bit: felt) = get_loop_digit(index);
    if (bit == 0) {
        let result = e12.mul_by_014(result, l1r0, l1r1);
        // %{ print_G2(ids.Q, ids.index, ids.bit) %}
        return miller_loop_fixed_Pk_inner(Q, result, index - 1);
    } else {
        let (Q: G2Point*, l2: E4*) = get_drand_pk_nQ_lines(n);
        let l2r0 = e2.mul_by_element(yp_prime, l2.r0);
        let l2r1 = e2.mul_by_element(xp_prime, l2.r1);
        let n = n + 1;
        let lines = e12.mul_014_by_014(l1r0, l1r1, l2r0, l2r1);
        let result = e12.mul(result, lines);
        return miller_loop_fixed_Pk_inner(Q, result, index - 1);
    }
}
