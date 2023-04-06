%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.registers import get_fp_and_pc
from src.bls12_381.fq import BigInt4

from src.bls12_381.towers.e12 import E12, e12
from src.bls12_381.towers.e6 import E6, e6
from src.bls12_381.towers.e2 import E2, e2
// from src.bls12_381.g1 import G1Point, g1
// from src.bls12_381.g2 import G2Point, g2
from src.bls12_381.pairing import final_exponentiation
from src.bls12_381.curve import CURVE, BASE, DEGREE, N_LIMBS, P0, P1, P2, P3

@external
func __setup__() {
    %{
        import subprocess, random, functools, re
        CURVE_STR = bytes.fromhex(f'{ids.CURVE:x}').decode('ascii')
        MAIN_FILE = './tools/parser_go/' + CURVE_STR + '/cairo_test/main'
        BASE_GNARK=2**64
        DEGREE_GNARK=5
        CURVE_ORDER = 0x73eda753299d7d483339d80809a1d80553bda402fffe5bfeffffffff00000001
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

        def fill_g1_point(g1:str, a0:int, a1:int):
            sa0, sa1 = split(a0), split(a1)
            for i in range(3): rsetattr(ids,g1+'.x.d'+str(i),sa0[i])
            for i in range(3): rsetattr(ids,g1+'.y.d'+str(i),sa1[i])
            return None
        def fill_g2_point(g2:str, a0:int, a1:int, a2, a3):
            sa0, sa1, sa2, sa3 = split(a0), split(a1), split(a2), split(a3)
            for i in range(3): rsetattr(ids,g2+'.x.a0.d'+str(i),sa0[i])
            for i in range(3): rsetattr(ids,g2+'.x.a1.d'+str(i),sa1[i])
            for i in range(3): rsetattr(ids,g2+'.y.a0.d'+str(i),sa2[i])
            for i in range(3): rsetattr(ids,g2+'.y.a1.d'+str(i),sa3[i])
            return None
        def fill_e12(e2:str, *args):
            for i in range(12):
                splitted = split(args[i])
                for j in range(ids.N_LIMBS):
                    rsetattr(ids,e2+str(i)+'.d'+str(j),splitted[j])
            return None
        def fill_element(element:str, value:int):
            s = split(value)
            for i in range(3): rsetattr(ids,element+'.d'+str(i),s[i])
        def parse_fp_elements(input_string:str):
            pattern = re.compile(r'\[([^\[\]]+)\]')
            substrings = pattern.findall(input_string)
            sublists = [substring.split(' ') for substring in substrings]
            sublists = [[int(x) for x in sublist] for sublist in sublists]
            fp_elements = [x[0] + x[1]*2**64 + x[2]*2**128 + x[3]*2**192 + x[4] * 2**256 + x[5] * 2**320 for x in sublists]
            return fp_elements
    %}
    return ();
}

@external
func test_final_exp{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();
    local x0: BigInt4;
    local x1: BigInt4;
    local x2: BigInt4;
    local x3: BigInt4;
    local x4: BigInt4;
    local x5: BigInt4;
    local x6: BigInt4;
    local x7: BigInt4;
    local x8: BigInt4;
    local x9: BigInt4;
    local x10: BigInt4;
    local x11: BigInt4;

    local z0: BigInt4;
    local z1: BigInt4;
    local z2: BigInt4;
    local z3: BigInt4;
    local z4: BigInt4;
    local z5: BigInt4;
    local z6: BigInt4;
    local z7: BigInt4;
    local z8: BigInt4;
    local z9: BigInt4;
    local z10: BigInt4;
    local z11: BigInt4;
    tempvar x = new E12(
        new E6(new E2(&x0, &x1), new E2(&x2, &x3), new E2(&x4, &x5)),
        new E6(new E2(&x6, &x7), new E2(&x8, &x9), new E2(&x10, &x11)),
    );
    tempvar z = new E12(
        new E6(new E2(&z0, &z1), new E2(&z2, &z3), new E2(&z4, &z5)),
        new E6(new E2(&z6, &z7), new E2(&z8, &z9), new E2(&z10, &z11)),
    );

    %{
        cmd = [MAIN_FILE, 'nG1nG2', '1', '1']
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements_0 = parse_fp_elements(out)
        assert len(fp_elements_0) == 6

        cmd = [MAIN_FILE, 'pair', 'miller_loop'] + [str(x) for x in fp_elements_0]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)
        assert len(fp_elements) == 12
        fill_e12('x', *fp_elements)

        cmd = [MAIN_FILE, 'pair', 'pair'] + [str(x) for x in fp_elements_0]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)
        assert len(fp_elements) == 12
        fill_e12('z', *fp_elements)
    %}

    let res = final_exponentiation(x);

    e12.assert_E12(res, z);
    return ();
}

// @external
// func test_pair_gen{
//     syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
// }() {
//     alloc_locals;
//     __setup__();
//     let (__fp__, _) = get_fp_and_pc();

// local g1x: BigInt4;
//     local g1y: BigInt4;

// local g2x0: BigInt4;
//     local g2x1: BigInt4;
//     local g2y0: BigInt4;
//     local g2y1: BigInt4;

// local z0: BigInt4;
//     local z1: BigInt4;
//     local z2: BigInt4;
//     local z3: BigInt4;
//     local z4: BigInt4;
//     local z5: BigInt4;
//     local z6: BigInt4;
//     local z7: BigInt4;
//     local z8: BigInt4;
//     local z9: BigInt4;
//     local z10: BigInt4;
//     local z11: BigInt4;

// %{
//         cmd = [MAIN_FILE, 'nG1nG2', '1', '1']
//         out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
//         fp_elements = parse_fp_elements(out)
//         assert len(fp_elements) == 6

// fill_element('g1x', fp_elements[0])
//         fill_element('g1y', fp_elements[1])
//         fill_element('g2x0', fp_elements[2])
//         fill_element('g2x1', fp_elements[3])
//         fill_element('g2y0', fp_elements[4])
//         fill_element('g2y1', fp_elements[5])

// cmd = [MAIN_FILE, 'pair', 'pair'] + [str(x) for x in fp_elements]
//         out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
//         print(out)
//         fp_elements_2 = parse_fp_elements(out)
//         assert len(fp_elements_2) == 12

// fill_e12('z', *fp_elements_2)
//     %}
//     local x: G1Point = G1Point(&g1x, &g1y);
//     local y: G2Point = G2Point(new E2(&g2x0, &g2x1), new E2(&g2y0, &g2y1));
//     local z: E12 = E12(
//         new E6(new E2(&z0, &z1), new E2(&z2, &z3), new E2(&z4, &z5)),
//         new E6(new E2(&z6, &z7), new E2(&z8, &z9), new E2(&z10, &z11)),
//     );
//     g1.assert_on_curve(x);
//     g2.assert_on_curve(y);
//     let res = pair(&x, &y);

// e12.assert_E12(res, &z);
//     return ();
// }

// @external
// func test_neg_g1_g2{
//     syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
// }() {
//     alloc_locals;
//     __setup__();
//     let (__fp__, _) = get_fp_and_pc();

// local g1x: BigInt4;
//     local g1y: BigInt4;

// local g2x0: BigInt4;
//     local g2x1: BigInt4;
//     local g2y0: BigInt4;
//     local g2y1: BigInt4;

// local z0: BigInt4;
//     local z1: BigInt4;
//     local z2: BigInt4;
//     local z3: BigInt4;
//     local z4: BigInt4;
//     local z5: BigInt4;
//     local z6: BigInt4;
//     local z7: BigInt4;
//     local z8: BigInt4;
//     local z9: BigInt4;
//     local z10: BigInt4;
//     local z11: BigInt4;

// %{
//         cmd = [MAIN_FILE, 'nG1nG2', '1', '1']
//         out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
//         fp_elements = parse_fp_elements(out)
//         assert len(fp_elements) == 6

// fill_element('g1x', fp_elements[0])
//         fill_element('g1y', fp_elements[1])
//         fill_element('g2x0', fp_elements[2])
//         fill_element('g2x1', fp_elements[3])
//         fill_element('g2y0', fp_elements[4])
//         fill_element('g2y1', fp_elements[5])

// cmd = [MAIN_FILE, 'pair', 'pair'] + [str(x) for x in fp_elements]
//         out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
//         print(out)
//         fp_elements_2 = parse_fp_elements(out)
//         assert len(fp_elements_2) == 12

// fill_e12('z', *fp_elements_2)
//     %}
//     local x: G1Point = G1Point(&g1x, &g1y);
//     local y: G2Point = G2Point(new E2(&g2x0, &g2x1), new E2(&g2y0, &g2y1));
//     local z: E12 = E12(
//         new E6(new E2(&z0, &z1), new E2(&z2, &z3), new E2(&z4, &z5)),
//         new E6(new E2(&z6, &z7), new E2(&z8, &z9), new E2(&z10, &z11)),
//     );
//     g1.assert_on_curve(x);
//     g2.assert_on_curve(y);

// let g1_neg = g1.neg(&x);

// let m1 = miller_loop(&x, &y);
//     let m2 = miller_loop(g1_neg, &y);
//     let m1m2 = e12.mul(m1, m2);
//     let ee = final_exponentiation(m1m2);
//     let one = e12.one();
//     e12.assert_E12(ee, one);
//     return ();
// }

// @external
// func test_g1_neg_g2{
//     syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
// }() {
//     alloc_locals;
//     __setup__();
//     let (__fp__, _) = get_fp_and_pc();

// local g1x: BigInt4;
//     local g1y: BigInt4;

// local g2x0: BigInt4;
//     local g2x1: BigInt4;
//     local g2y0: BigInt4;
//     local g2y1: BigInt4;

// local z0: BigInt4;
//     local z1: BigInt4;
//     local z2: BigInt4;
//     local z3: BigInt4;
//     local z4: BigInt4;
//     local z5: BigInt4;
//     local z6: BigInt4;
//     local z7: BigInt4;
//     local z8: BigInt4;
//     local z9: BigInt4;
//     local z10: BigInt4;
//     local z11: BigInt4;

// %{
//         cmd = [MAIN_FILE, 'nG1nG2', '1', '1']
//         out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
//         fp_elements = parse_fp_elements(out)
//         assert len(fp_elements) == 6

// fill_element('g1x', fp_elements[0])
//         fill_element('g1y', fp_elements[1])
//         fill_element('g2x0', fp_elements[2])
//         fill_element('g2x1', fp_elements[3])
//         fill_element('g2y0', fp_elements[4])
//         fill_element('g2y1', fp_elements[5])

// cmd = [MAIN_FILE, 'pair', 'pair'] + [str(x) for x in fp_elements]
//         out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
//         print(out)
//         fp_elements_2 = parse_fp_elements(out)
//         assert len(fp_elements_2) == 12

// fill_e12('z', *fp_elements_2)
//     %}
//     local x: G1Point = G1Point(&g1x, &g1y);
//     local y: G2Point = G2Point(new E2(&g2x0, &g2x1), new E2(&g2y0, &g2y1));
//     local z: E12 = E12(
//         new E6(new E2(&z0, &z1), new E2(&z2, &z3), new E2(&z4, &z5)),
//         new E6(new E2(&z6, &z7), new E2(&z8, &z9), new E2(&z10, &z11)),
//     );
//     g1.assert_on_curve(x);
//     g2.assert_on_curve(y);

// let g2_neg = g2.neg(&y);

// let m1 = miller_loop(&x, &y);
//     let m2 = miller_loop(&x, g2_neg);
//     let m1m2 = e12.mul(m1, m2);
//     let ee = final_exponentiation(m1m2);
//     let one = e12.one();
//     e12.assert_E12(ee, one);
//     return ();
// }

// @external
// func test_pair_random{
//     syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
// }() {
//     alloc_locals;
//     __setup__();
//     let (__fp__, _) = get_fp_and_pc();

// local g1x: BigInt4;
//     local g1y: BigInt4;

// local g2x0: BigInt4;
//     local g2x1: BigInt4;
//     local g2y0: BigInt4;
//     local g2y1: BigInt4;

// local z0: BigInt4;
//     local z1: BigInt4;
//     local z2: BigInt4;
//     local z3: BigInt4;
//     local z4: BigInt4;
//     local z5: BigInt4;
//     local z6: BigInt4;
//     local z7: BigInt4;
//     local z8: BigInt4;
//     local z9: BigInt4;
//     local z10: BigInt4;
//     local z11: BigInt4;

// tempvar z = new E12(
//         new E6(new E2(&z0, &z1), new E2(&z2, &z3), new E2(&z4, &z5)),
//         new E6(new E2(&z6, &z7), new E2(&z8, &z9), new E2(&z10, &z11)),
//     );
//     %{
//         inputs=[random.randint(0, CURVE_ORDER) for i in range(2)]
//         cmd = [MAIN_FILE, 'nG1nG2']+[str(x) for x in inputs]
//         out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
//         fp_elements = parse_fp_elements(out)
//         assert len(fp_elements) == 6
//         fill_element('g1x', fp_elements[0])
//         fill_element('g1y', fp_elements[1])
//         fill_element('g2x0', fp_elements[2])
//         fill_element('g2x1', fp_elements[3])
//         fill_element('g2y0', fp_elements[4])
//         fill_element('g2y1', fp_elements[5])

// cmd = [MAIN_FILE, 'pair', 'pair'] + [str(x) for x in fp_elements]
//         out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
//         fp_elements = parse_fp_elements(out)
//         assert len(fp_elements) == 12

// fill_e12('z', fp_elements[0], fp_elements[1], fp_elements[2], fp_elements[3], fp_elements[4], fp_elements[5], fp_elements[6], fp_elements[7], fp_elements[8], fp_elements[9], fp_elements[10], fp_elements[11])
//     %}
//     local x: G1Point = G1Point(&g1x, &g1y);
//     local y: G2Point = G2Point(new E2(&g2x0, &g2x1), new E2(&g2y0, &g2y1));
//     g1.assert_on_curve(x);
//     g2.assert_on_curve(y);
//     let res = pair(&x, &y);

// e12.assert_E12(res, z);
//     return ();
// }
