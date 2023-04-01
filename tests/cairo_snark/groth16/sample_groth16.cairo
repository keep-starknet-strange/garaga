%builtins range_check

from src.bn254.towers.e12 import E12, e12
from src.bn254.towers.e2 import E2, e2
from src.bn254.g1 import G1Point, g1
from src.bn254.g2 import G2Point, g2
from src.bn254.pairing import miller_loop, final_exponentiation, pair
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.cairo_secp.bigint import BigInt3, uint256_to_bigint, bigint_to_uint256

func main{range_check_ptr}() {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    %{
        import functools
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
    %}
    local ax: BigInt3;
    local ay: BigInt3;

    local bx0: BigInt3;
    local bx1: BigInt3;
    local by0: BigInt3;
    local by1: BigInt3;

    local cx: BigInt3;
    local cy: BigInt3;

    local vk_alfa1_x: BigInt3;
    local vk_alfa1_y: BigInt3;

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

    %{
        for var_name in list(program_input.keys()):
            fill_element(var_name, program_input[var_name])
    %}

    // TODO : complete pre-computations and verification.

    local a: G1Point = G1Point(&ax, &ay);
    let a = g1.neg(a);
    local b: G2Point = G2Point(new E2(&bx0, &bx1), new E2(&by0, &by1));
    local c: G1Point = G1Point(&cx, &cy);

    local vk_alfa1: G1Point = G1Point(&vk_alfa1_x, &vk_alfa1_y);
    local vk_beta2: G2Point = G2Point(
        new E2(&vk_beta2_x0, &vk_beta2_x1), new E2(&vk_beta2_y0, &vk_beta2_y1)
    );
    local vk_gamma2: G2Point = G2Point(
        new E2(&vk_gamma2_x0, &vk_gamma2_x1), new E2(&vk_gamma2_y0, &vk_gamma2_y1)
    );
    local vk_delta2: G2Point = G2Point(
        new E2(&vk_delta2_x0, &vk_delta2_x1), new E2(&vk_delta2_y0, &vk_delta2_y1)
    );

    g1.assert_on_curve(a);
    g2.assert_on_curve(b);
    g1.assert_on_curve(c);

    g1.assert_on_curve(vk_alfa1);
    g2.assert_on_curve(vk_beta2);
    g2.assert_on_curve(vk_gamma2);
    g2.assert_on_curve(vk_delta2);

    let m1 = miller_loop(&a, &b);
    let m2 = miller_loop(&vk_alfa1, &vk_beta2);

    // let m3 = miller_loop(&vk_x, &vk_gamma2);
    // let m4 = miller_loop(&c, &vk_delta2);

    let m = e12.mul(m1, m2);
    // let m = e12.mul(m, m3);
    // let m = e12.mul(m, m4);
    // let pairing_result = final_exponentiation(m);

    return ();
}
