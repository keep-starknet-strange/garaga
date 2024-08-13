%builtins range_check poseidon range_check96 add_mod mul_mod

from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_secp.bigint import BigInt3, uint256_to_bigint, bigint_to_uint256
from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, ModBuiltin

func main{
    range_check_ptr,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}() {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    // %{
    //         import functools, re, subprocess
    //         from starkware.cairo.common.cairo_secp.secp_utils import split

    // P=0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
    //         BN254_ORDER = 21888242871839275222246405745257275088548364400416034343698204186575808495617
    //         def rgetattr(obj, attr, *args):
    //             def _getattr(obj, attr):
    //                 return getattr(obj, attr, *args)
    //             return functools.reduce(_getattr, [obj] + attr.split('.'))
    //         def rsetattr(obj, attr, val):
    //             pre, _, post = attr.rpartition('.')
    //             return setattr(rgetattr(obj, pre) if pre else obj, post, val)
    //         def fill_element(element:str, value:int):
    //             s = split(value)
    //             for i in range(3): rsetattr(ids,element+'.d'+str(i),s[i])
    //         def fill_e12(e2:str, *args):
    //             for i in range(12):
    //                 splitted = split(args[i])
    //                 for j in range(3):
    //                     rsetattr(ids,e2+str(i)+'.d'+str(j),splitted[j])
    //             return None
    //         def parse_fp_elements(input_string:str):
    //             pattern = re.compile(r'\[([^\[\]]+)\]')
    //             substrings = pattern.findall(input_string)
    //             sublists = [substring.split(' ') for substring in substrings]
    //             sublists = [[int(x) for x in sublist] for sublist in sublists]
    //             fp_elements = [x[0] + x[1]*2**64 + x[2]*2**128 + x[3]*2**192 for x in sublists]
    //             return fp_elements
    //     %}
    //     local ax: BigInt3;
    //     local ay: BigInt3;

    // local bx0: BigInt3;
    //     local bx1: BigInt3;
    //     local by0: BigInt3;
    //     local by1: BigInt3;

    // local cx: BigInt3;
    //     local cy: BigInt3;

    // local vk_alpha1_x: BigInt3;
    //     local vk_alpha1_y: BigInt3;

    // local vk_beta2_x0: BigInt3;
    //     local vk_beta2_x1: BigInt3;
    //     local vk_beta2_y0: BigInt3;
    //     local vk_beta2_y1: BigInt3;

    // local vk_gamma2_x0: BigInt3;
    //     local vk_gamma2_x1: BigInt3;
    //     local vk_gamma2_y0: BigInt3;
    //     local vk_gamma2_y1: BigInt3;

    // local vk_delta2_x0: BigInt3;
    //     local vk_delta2_x1: BigInt3;
    //     local vk_delta2_y0: BigInt3;
    //     local vk_delta2_y1: BigInt3;

    // local vk_ic0_x: BigInt3;
    //     local vk_ic0_y: BigInt3;
    //     local vk_ic1_x: BigInt3;
    //     local vk_ic1_y: BigInt3;
    //     local vk_ic2_x: BigInt3;
    //     local vk_ic2_y: BigInt3;
    //     local vk_ic3_x: BigInt3;
    //     local vk_ic3_y: BigInt3;
    //     local vk_ic4_x: BigInt3;
    //     local vk_ic4_y: BigInt3;

    // local input_0: BigInt3;
    //     local input_1: BigInt3;
    //     local input_2: BigInt3;
    //     local input_3: BigInt3;

    // // Precomputed e(vk_alpha1, vk_beta2)
    //     local e_vk0: BigInt3;
    //     local e_vk1: BigInt3;
    //     local e_vk2: BigInt3;
    //     local e_vk3: BigInt3;
    //     local e_vk4: BigInt3;
    //     local e_vk5: BigInt3;
    //     local e_vk6: BigInt3;
    //     local e_vk7: BigInt3;
    //     local e_vk8: BigInt3;
    //     local e_vk9: BigInt3;
    //     local e_vk10: BigInt3;
    //     local e_vk11: BigInt3;

    // %{
    //         for var_name in list(program_input.keys()):
    //             fill_element(var_name, program_input[var_name])
    //     %}

    // local a: G1Point = G1Point(ax, ay);
    //     let (local a: G1Point) = g1.neg(a);
    //     local bx: E2 = E2(bx0, bx1);
    //     local by: E2 = E2(by0, by1);
    //     local b: G2Point = G2Point(&bx, &by);
    //     local c: G1Point = G1Point(cx, cy);

    // local vk_alpha1: G1Point = G1Point(vk_alpha1_x, vk_alpha1_y);
    //     local vk_beta2x: E2 = E2(vk_beta2_x0, vk_beta2_x1);
    //     local vk_beta2y: E2 = E2(vk_beta2_y0, vk_beta2_y1);

    // local vk_beta2: G2Point = G2Point(&vk_beta2x, &vk_beta2y);

    // local vk_gamma2x: E2 = E2(vk_gamma2_x0, vk_gamma2_x1);
    //     local vk_gamma2y: E2 = E2(vk_gamma2_y0, vk_gamma2_y1);
    //     local vk_gamma2: G2Point = G2Point(&vk_gamma2x, &vk_gamma2y);

    // local vk_delta2x: E2 = E2(vk_delta2_x0, vk_delta2_x1);
    //     local vk_delta2y: E2 = E2(vk_delta2_y0, vk_delta2_y1);

    // local vk_delta2: G2Point = G2Point(&vk_delta2x, &vk_delta2y);

    // local vk_ic0: G1Point = G1Point(vk_ic0_x, vk_ic0_y);
    //     local vk_ic1: G1Point = G1Point(vk_ic1_x, vk_ic1_y);
    //     local vk_ic2: G1Point = G1Point(vk_ic2_x, vk_ic2_y);
    //     local vk_ic3: G1Point = G1Point(vk_ic3_x, vk_ic3_y);
    //     local vk_ic4: G1Point = G1Point(vk_ic4_x, vk_ic4_y);

    // g1.assert_on_curve(&a);
    //     g2.assert_on_curve(&b);
    //     g1.assert_on_curve(&c);

    // g1.assert_on_curve(&vk_alpha1);
    //     g2.assert_on_curve(&vk_beta2);

    // g2.assert_on_curve(&vk_gamma2);
    //     g2.assert_on_curve(&vk_delta2);

    // g1.assert_on_curve(&vk_ic0);
    //     g1.assert_on_curve(&vk_ic1);
    //     g1.assert_on_curve(&vk_ic2);
    //     g1.assert_on_curve(&vk_ic3);
    //     g1.assert_on_curve(&vk_ic4);

    // %{ print(f"All elements on curve!") %}

    // // Compute vk_x € G1
    //     let vk_x = vk_ic0;
    //     let (temp_0) = g1.scalar_mul(vk_ic1, input_0);
    //     let (vk_x) = g1.add(vk_x, temp_0);

    // let (local temp_1) = g1.scalar_mul(vk_ic2, input_1);
    //     let (local vk_x) = g1.add(vk_x, temp_1);
    //     let (local temp_2) = g1.scalar_mul(vk_ic3, input_2);
    //     let (local vk_x) = g1.add(vk_x, temp_2);
    //     let (local temp_3) = g1.scalar_mul(vk_ic4, input_3);
    //     let (local vk_x) = g1.add(vk_x, temp_3);

    // // Compute & verify pairing:

    // let (P: G1Point**) = alloc();
    //     let (Q: G2Point**) = alloc();

    // assert P[0] = &a;
    //     assert Q[0] = &b;
    //     assert P[1] = &vk_x;
    //     assert Q[1] = &vk_gamma2;
    //     assert P[2] = &c;
    //     assert Q[2] = &vk_delta2;

    // %{ print(f"Computing m = multi_miller(P = [a, vk_x, c], Q = [b, vk_gamma2, vk_delta2]) ...") %}

    // let m = multi_miller_loop(P, Q, 3);
    //     %{
    //         from tools.py.extension_trick import mul_e12, pack_e12, gnark_to_w
    //         from garaga.hints.fq import pack_e12t
    //         mt = pack_e12t(ids.m, ids.N_LIMBS, ids.BASE)
    //         md = gnark_to_w(mt)
    //     %}

    // %{ print(f"Avoid computing m2 = miller(vk_alpha1, vk_beta2) thanks to precomputation.") %}
    //     %{
    //         felts = [program_input['vk_alpha1_x'], program_input['vk_alpha1_y']]
    //         felts+= [program_input['vk_beta2_x0'], program_input['vk_beta2_x1'], program_input['vk_beta2_y0'], program_input['vk_beta2_y1']]

    // cmd = ['./tools/gnark/main', 'pair', 'pair'] + [str(x) for x in felts]
    //         out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
    //         fp_elements = parse_fp_elements(out)

    // assert len(fp_elements) == 12

    // fill_e12('e_vk', *gnark_to_w(fp_elements))
    //     %}
    //     local pair_vk_alpha_beta: E12D = E12D(
    //         e_vk0, e_vk1, e_vk2, e_vk3, e_vk4, e_vk5, e_vk6, e_vk7, e_vk8, e_vk9, e_vk10, e_vk11
    //     );

    // %{ print(f"Computing E = final_exp(m) * e(vk_alpha1, vk_beta2) ...") %}
    //     let pairing_result = final_exponentiation(m, 0);
    //     let pairing_result = e12.mul_trick_pure(pairing_result, &pair_vk_alpha_beta);
    //     let one = e12.one_full();
    //     %{ print(f"Verifying Groth 16 Circuit assertion E == 1 ...") %}

    // assert_E12D(pairing_result, one);
    //     %{ print(f"Groth 16 Circuit Verification COMPLETE!") %}

    return ();
}
