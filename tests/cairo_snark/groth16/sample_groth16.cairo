%builtins range_check

from src.bn254.towers.e12 import E12, e12
from src.bn254.towers.e2 import E2, e2
from src.bn254.towers.e6 import E6
from src.bn254.g1 import G1Point, g1
from src.bn254.g2 import G2Point, g2
from src.bn254.pairing import miller_loop, final_exponentiation, pair
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.cairo_secp.bigint import BigInt3, uint256_to_bigint, bigint_to_uint256

func main{range_check_ptr}() {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    %{
        import functools, re, subprocess
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
    local ax: BigInt3;
    local ay: BigInt3;

    local bx0: BigInt3;
    local bx1: BigInt3;
    local by0: BigInt3;
    local by1: BigInt3;

    local cx: BigInt3;
    local cy: BigInt3;

    local vk_alpha1_x: BigInt3;
    local vk_alpha1_y: BigInt3;

    local vk_beta2_x0: BigInt3;
    local vk_beta2_x1: BigInt3;
    local vk_beta2_y0: BigInt3;
    local vk_beta2_y1: BigInt3;

    local vk_gamma2_x0: BigInt3;
    local vk_gamma2_x1: BigInt3;
    local vk_gamma2_y0: BigInt3;
    local vk_gamma2_y1: BigInt3;

    local vk_delta2_x0: BigInt3;
    local vk_delta2_x1: BigInt3;
    local vk_delta2_y0: BigInt3;
    local vk_delta2_y1: BigInt3;

    local vk_ic0_x: BigInt3;
    local vk_ic0_y: BigInt3;
    local vk_ic1_x: BigInt3;
    local vk_ic1_y: BigInt3;
    local vk_ic2_x: BigInt3;
    local vk_ic2_y: BigInt3;
    local vk_ic3_x: BigInt3;
    local vk_ic3_y: BigInt3;
    local vk_ic4_x: BigInt3;
    local vk_ic4_y: BigInt3;

    local input_0: BigInt3;
    local input_1: BigInt3;
    local input_2: BigInt3;
    local input_3: BigInt3;

    // Precomputed e(vk_alpha1, vk_beta2)
    local e_vk0: BigInt3;
    local e_vk1: BigInt3;
    local e_vk2: BigInt3;
    local e_vk3: BigInt3;
    local e_vk4: BigInt3;
    local e_vk5: BigInt3;
    local e_vk6: BigInt3;
    local e_vk7: BigInt3;
    local e_vk8: BigInt3;
    local e_vk9: BigInt3;
    local e_vk10: BigInt3;
    local e_vk11: BigInt3;

    %{
        for var_name in list(program_input.keys()):
            fill_element(var_name, program_input[var_name])
    %}

    // TODO : complete pre-computations and verification.

    local a: G1Point* = new G1Point(&ax, &ay);
    let a = g1.neg(a);
    local b: G2Point* = new G2Point(new E2(&bx0, &bx1), new E2(&by0, &by1));
    local c: G1Point* = new G1Point(&cx, &cy);

    local vk_alpha1: G1Point* = new G1Point(&vk_alpha1_x, &vk_alpha1_y);
    local vk_beta2: G2Point* = new G2Point(
        new E2(&vk_beta2_x0, &vk_beta2_x1), new E2(&vk_beta2_y0, &vk_beta2_y1)
    );
    local vk_gamma2: G2Point* = new G2Point(
        new E2(&vk_gamma2_x0, &vk_gamma2_x1), new E2(&vk_gamma2_y0, &vk_gamma2_y1)
    );
    local vk_delta2: G2Point* = new G2Point(
        new E2(&vk_delta2_x0, &vk_delta2_x1), new E2(&vk_delta2_y0, &vk_delta2_y1)
    );
    local vk_ic0: G1Point* = new G1Point(&vk_ic0_x, &vk_ic0_y);
    local vk_ic1: G1Point* = new G1Point(&vk_ic1_x, &vk_ic1_y);
    local vk_ic2: G1Point* = new G1Point(&vk_ic2_x, &vk_ic2_y);
    local vk_ic3: G1Point* = new G1Point(&vk_ic3_x, &vk_ic3_y);
    local vk_ic4: G1Point* = new G1Point(&vk_ic4_x, &vk_ic4_y);

    g1.assert_on_curve(a);
    g2.assert_on_curve(b);
    g1.assert_on_curve(c);

    g1.assert_on_curve(vk_alpha1);

    g2.assert_on_curve(vk_beta2);
    g2.assert_on_curve(vk_gamma2);
    g2.assert_on_curve(vk_delta2);

    g1.assert_on_curve(vk_ic0);
    g1.assert_on_curve(vk_ic1);
    g1.assert_on_curve(vk_ic2);
    g1.assert_on_curve(vk_ic3);
    g1.assert_on_curve(vk_ic4);

    %{ print(f"All elements on curve!") %}

    // Compute vk_x € G1
    let vk_x = vk_ic0;
    let (temp_0) = g1.scalar_mul(vk_ic1, input_0);
    let (vk_x) = g1.add(vk_x, temp_0);

    let (temp_1) = g1.scalar_mul(vk_ic2, input_1);
    let (vk_x) = g1.add(vk_x, temp_1);
    let (temp_2) = g1.scalar_mul(vk_ic3, input_2);
    let (vk_x) = g1.add(vk_x, temp_2);
    let (temp_3) = g1.scalar_mul(vk_ic4, input_3);
    let (vk_x) = g1.add(vk_x, temp_3);

    // Compute & verify pairing:

    %{ print(f"Computing m1 = miller(a,b) ...") %}
    let m1 = miller_loop(a, b);

    %{ print(f"Avoid computing m2 = miller(vk_alpha1, vk_beta2) thanks to precomputation.") %}
    %{
        felts = [program_input['vk_alpha1_x'], program_input['vk_alpha1_y']]
        felts+= [program_input['vk_beta2_x0'], program_input['vk_beta2_x1'], program_input['vk_beta2_y0'], program_input['vk_beta2_y1']]

        cmd = ['./tools/parser_go/main', 'pair', 'pair'] + [str(x) for x in felts]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)
        assert len(fp_elements) == 12

        fill_e12('e_vk', *fp_elements)
    %}
    tempvar pair_vk_alpha_beta: E12* = new E12(
        new E6(new E2(&e_vk0, &e_vk1), new E2(&e_vk2, &e_vk3), new E2(&e_vk4, &e_vk5)),
        new E6(new E2(&e_vk6, &e_vk7), new E2(&e_vk8, &e_vk9), new E2(&e_vk10, &e_vk11)),
    );
    // let m2 = miller_loop(vk_alpha1, vk_beta2);

    %{ print(f"Computing m3 = miller(vk_x, vk_gamma2) ...") %}
    let m3 = miller_loop(vk_x, vk_gamma2);

    %{ print(f"Computing m4 = miller(c, vk_delta2) ...") %}
    let m4 = miller_loop(c, vk_delta2);

    %{ print(f"Computing m = m1 * m3 * m4") %}
    let m = e12.mul(m1, m3);
    let m = e12.mul(m, m4);
    %{ print(f"Computing E = final_exp(m) * e(vk_alpha1, vk_beta2) ...") %}
    let pairing_result = final_exponentiation(m);
    let pairing_result = e12.mul(pairing_result, pair_vk_alpha_beta);
    let one = e12.one();
    %{ print(f"Verifying Groth 16 Circuit assertion E == 1 ...") %}

    e12.assert_E12(pairing_result, one);
    %{ print(f"Groth 16 Circuit Verification COMPLETE!") %}

    return ();
}
