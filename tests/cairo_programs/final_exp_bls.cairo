%builtins range_check

from starkware.cairo.common.registers import get_fp_and_pc
from src.bls12_381.fq import BigInt4

from src.bls12_381.towers.e12 import E12, e12
from src.bls12_381.towers.e6 import E6, e6
from src.bls12_381.towers.e2 import E2, e2
// from src.bls12_381.g1 import G1Point, g1
// from src.bls12_381.g2 import G2Point, g2
from src.bls12_381.pairing import final_exponentiation
from src.bls12_381.curve import CURVE, BASE, DEGREE, N_LIMBS, P0, P1, P2, P3

func main{range_check_ptr}() {
    alloc_locals;
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
            fp_elements = [x[0] + x[1]*2**64 + x[2]*2**128 + x[3]*2**192 + x[4] * 2**256 + x[5] * 2**320 for x in sublists]
            return fp_elements
    %}
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
