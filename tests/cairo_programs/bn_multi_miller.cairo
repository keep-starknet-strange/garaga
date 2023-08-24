%builtins range_check

from src.bn254.towers.e12 import E12, e12
from src.bn254.towers.e6 import E6, e6
from src.bn254.towers.e2 import E2, e2
from src.bn254.g1 import G1Point, g1
from src.bn254.g2 import G2Point, g2
from src.bn254.pairing import final_exponentiation, multi_miller_loop
from src.bn254.fq import BigInt3, assert_fq_eq
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.alloc import alloc

func main{range_check_ptr}() {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();

    %{
        import subprocess
        import random
        import functools
        import re
        from starkware.cairo.common.cairo_secp.secp_utils import split

        P=0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
        BN254_ORDER = 21888242871839275222246405745257275088548364400416034343698204186575808495617
        def rgetattr(obj, attr, *args):
            def _getattr(obj, attr):
                return getattr(obj, attr, *args)
            return functools.reduce(_getattr, [obj] + attr.split('.'))

        def rsetattr(obj, attr, val):
            pre, _, post = attr.rpartition('.')
            return setattr(rgetattr(obj, pre) if pre else obj, post, val)

        def fill_g1_point(g1:str, a0:int, a1:int):
            sa0 = split(a0)
            sa1 = split(a1)
            for i in range(3): rsetattr(ids,g1+'.x.d'+str(i),sa0[i])
            for i in range(3): rsetattr(ids,g1+'.y.d'+str(i),sa1[i])
        def fill_g2_point(g2:str, a0:int, a1:int, a2, a3):
            sa0 = split(a0)
            sa1 = split(a1)
            sa2 = split(a2)
            sa3 = split(a3)

            for i in range(3): rsetattr(ids,g2+'.x.a0.d'+str(i),sa0[i])
            for i in range(3): rsetattr(ids,g2+'.x.a1.d'+str(i),sa1[i])
            for i in range(3): rsetattr(ids,g2+'.y.a0.d'+str(i),sa2[i])
            for i in range(3): rsetattr(ids,g2+'.y.a1.d'+str(i),sa3[i])
        def fill_element(element:str, value:int):
            s = split(value)
            for i in range(3): rsetattr(ids,element+'.d'+str(i),s[i])
        def fill_e12(e2:str, *args):
            for i in range(12):
                splitted = split(args[i])
                for j in range(3):
                    rsetattr(ids,e2+str(i)+'.d'+str(j),splitted[j])
            return None
        def parse_fp_elements(input_string:str):
            pattern = re.compile(r'\[([^\[\]]+)\]')
            substrings = pattern.findall(input_string)
            sublists = [substring.split(' ') for substring in substrings]
            sublists = [[int(x) for x in sublist] for sublist in sublists]
            fp_elements = [x[0] + x[1]*2**64 + x[2]*2**128 + x[3]*2**192 for x in sublists]
            return fp_elements
    %}
    local g1x0: BigInt3;
    local g1y0: BigInt3;

    local g2x00: BigInt3;
    local g2x10: BigInt3;
    local g2y00: BigInt3;
    local g2y10: BigInt3;

    local g1x1: BigInt3;
    local g1y1: BigInt3;

    local g2x01: BigInt3;
    local g2x11: BigInt3;
    local g2y01: BigInt3;
    local g2y11: BigInt3;

    local g1x2: BigInt3;
    local g1y2: BigInt3;

    local g2x02: BigInt3;
    local g2x12: BigInt3;
    local g2y02: BigInt3;
    local g2y12: BigInt3;

    local g1x3: BigInt3;
    local g1y3: BigInt3;

    local g2x03: BigInt3;
    local g2x13: BigInt3;
    local g2y03: BigInt3;
    local g2y13: BigInt3;

    local z0: BigInt3;
    local z1: BigInt3;
    local z2: BigInt3;
    local z3: BigInt3;
    local z4: BigInt3;
    local z5: BigInt3;
    local z6: BigInt3;
    local z7: BigInt3;
    local z8: BigInt3;
    local z9: BigInt3;
    local z10: BigInt3;
    local z11: BigInt3;

    local n_points: felt = 3;

    %{
        scalars = [random.randint(1, BN254_ORDER) for _ in range(4)]
        fp_elements = []
        for i, s in enumerate(scalars):
            cmd = ['./tools/gnark/main', 'nG1nG2', str(s), str(s)]
            out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
            fp_elements +=parse_fp_elements(out)
            assert len(fp_elements) == 6*(i+1)
            fill_element(f'g1x{i}', fp_elements[0 + i*6])
            fill_element(f'g1y{i}', fp_elements[1 + i*6])
            fill_element(f'g2x0{i}', fp_elements[2 + i*6])
            fill_element(f'g2x1{i}', fp_elements[3 + i*6])
            fill_element(f'g2y0{i}', fp_elements[4 + i*6])
            fill_element(f'g2y1{i}', fp_elements[5 + i*6])


        cmd = ['./tools/gnark/main', 'n_pair', 'pair' , str(ids.n_points)] + [str(x) for x in fp_elements[:6*ids.n_points]]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements_2 = parse_fp_elements(out)
        print(out)
        assert len(fp_elements_2) == 12
        print('\n\n\n')

        fill_e12('z', *fp_elements_2)
    %}
    local P0: G1Point* = new G1Point(&g1x0, &g1y0);
    local Q0: G2Point* = new G2Point(new E2(&g2x00, &g2x10), new E2(&g2y00, &g2y10));

    local P1: G1Point* = new G1Point(&g1x1, &g1y1);
    local Q1: G2Point* = new G2Point(new E2(&g2x01, &g2x11), new E2(&g2y01, &g2y11));

    local P2: G1Point* = new G1Point(&g1x2, &g1y2);
    local Q2: G2Point* = new G2Point(new E2(&g2x02, &g2x12), new E2(&g2y02, &g2y12));

    local P3: G1Point* = new G1Point(&g1x3, &g1y3);
    local Q3: G2Point* = new G2Point(new E2(&g2x03, &g2x13), new E2(&g2y03, &g2y13));

    tempvar z = new E12(
        new E6(new E2(&z0, &z1), new E2(&z2, &z3), new E2(&z4, &z5)),
        new E6(new E2(&z6, &z7), new E2(&z8, &z9), new E2(&z10, &z11)),
    );
    g1.assert_on_curve(P0);
    g2.assert_on_curve(Q0);
    g1.assert_on_curve(P1);
    g2.assert_on_curve(Q1);
    g1.assert_on_curve(P2);
    g2.assert_on_curve(Q2);
    g1.assert_on_curve(P3);
    g2.assert_on_curve(Q3);

    let (P: G1Point**) = alloc();
    let (Q: G2Point**) = alloc();

    assert P[0] = P0;
    assert Q[0] = Q0;
    assert P[1] = P1;
    assert Q[1] = Q1;
    assert P[2] = P2;
    assert Q[2] = Q2;
    assert P[3] = P3;
    assert Q[3] = Q3;

    let res = multi_miller_loop(P, Q, n_points);
    // let res = final_exponentiation(res, 0);
    // e12.assert_E12(res, z);
    return ();
}
