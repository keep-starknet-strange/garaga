use core::circuit::{
    CircuitElement as CE, CircuitInput as CI, CircuitInputs, CircuitOutputsTrait, EvalCircuitTrait,
    circuit_add, circuit_inverse, circuit_mul, circuit_sub, u384,
};
use garaga::core::circuit::{AddInputResultTrait2, u288IntoCircuitInputValue};
use garaga::definitions::{
    BLSProcessedPair, BNProcessedPair, E12D, G1Point, G2Line, G2Point,
    MillerLoopResultScalingFactor, u288,
};
#[inline(always)]
pub fn run_BLS12_381_INITIALIZE_MPCHECK_EXT_MLR_circuit(
    lambda_root_inverse: E12D<u384>,
    z: u384,
    scaling_factor: MillerLoopResultScalingFactor<u384>,
    precomputed_miller_loop_result: E12D<u384>,
) -> (u384, u384, u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0
    let in1 = CE::<CI<1>> {}; // 0x2
    let in2 = CE::<
        CI<2>,
    > {}; // 0x18089593cbf626353947d5b1fd0c6d66bb34bc7585f5abdf8f17b50e12c47d65ce514a7c167b027b600febdb244714c5
    let in3 = CE::<
        CI<3>,
    > {}; // 0x5f19672fdf76ce51ba69c6076a0f77eaddb3a93be6f89688de17d813620a00022e01fffffffeffff
    let in4 = CE::<
        CI<4>,
    > {}; // 0xd5e1c086ffe8016d063c6dad7a2fffc9072bb5785a686bcefeedc2e0124838bdccf325ee5d80be9902109f7dbc79812
    let in5 = CE::<
        CI<5>,
    > {}; // 0x1a0111ea397fe699ec02408663d4de85aa0d857d89759ad4897d29650fb85f9b409427eb4f49fffd8bfd00000000aaad
    let in6 = CE::<
        CI<6>,
    > {}; // 0x1a0111ea397fe6998ce8d956845e1033efa3bf761f6622e9abc9802928bfc912627c4fd7ed3ffffb5dfb00000001aaaf
    let in7 = CE::<
        CI<7>,
    > {}; // 0xb659fb20274bfb1be8ff4d69163c08be7302c4818171fdd17d5be9b1d380acd8c747cdc4aff0e653631f5d3000f022c
    let in8 = CE::<CI<8>> {}; // -0x1 % p
    let in9 = CE::<
        CI<9>,
    > {}; // 0xfc3e2b36c4e03288e9e902231f9fb854a14787b6c7b36fec0c8ec971f63c5f282d5ac14d6c7ec22cf78a126ddc4af3
    let in10 = CE::<
        CI<10>,
    > {}; // 0x1f87c566d89c06511d3d204463f3f70a9428f0f6d8f66dfd8191d92e3ec78be505ab5829ad8fd8459ef1424dbb895e6
    let in11 = CE::<
        CI<11>,
    > {}; // 0x1a0111ea397fe699ec02408663d4de85aa0d857d89759ad4897d29650fb85f9b409427eb4f49fffd8bfd00000000aaac
    let in12 = CE::<
        CI<12>,
    > {}; // 0x6af0e0437ff400b6831e36d6bd17ffe48395dabc2d3435e77f76e17009241c5ee67992f72ec05f4c81084fbede3cc09
    let in13 = CE::<
        CI<13>,
    > {}; // 0x5f19672fdf76ce51ba69c6076a0f77eaddb3a93be6f89688de17d813620a00022e01fffffffefffe
    let in14 = CE::<
        CI<14>,
    > {}; // 0x144e4211384586c16bd3ad4afa99cc9170df3560e77982d0db45f3536814f0bd5871c1908bd478cd1ee605167ff82995
    let in15 = CE::<
        CI<15>,
    > {}; // 0xe9b7238370b26e88c8bb2dfb1e7ec4b7d471f3cdb6df2e24f5b1405d978eb56923783226654f19a83cd0a2cfff0a87f

    // INPUT stack
    let (in16, in17, in18) = (CE::<CI<16>> {}, CE::<CI<17>> {}, CE::<CI<18>> {});
    let (in19, in20, in21) = (CE::<CI<19>> {}, CE::<CI<20>> {}, CE::<CI<21>> {});
    let (in22, in23, in24) = (CE::<CI<22>> {}, CE::<CI<23>> {}, CE::<CI<24>> {});
    let (in25, in26, in27) = (CE::<CI<25>> {}, CE::<CI<26>> {}, CE::<CI<27>> {});
    let (in28, in29, in30) = (CE::<CI<28>> {}, CE::<CI<29>> {}, CE::<CI<30>> {});
    let (in31, in32, in33) = (CE::<CI<31>> {}, CE::<CI<32>> {}, CE::<CI<33>> {});
    let (in34, in35, in36) = (CE::<CI<34>> {}, CE::<CI<35>> {}, CE::<CI<36>> {});
    let (in37, in38, in39) = (CE::<CI<37>> {}, CE::<CI<38>> {}, CE::<CI<39>> {});
    let (in40, in41, in42) = (CE::<CI<40>> {}, CE::<CI<41>> {}, CE::<CI<42>> {});
    let (in43, in44, in45) = (CE::<CI<43>> {}, CE::<CI<44>> {}, CE::<CI<45>> {});
    let in46 = CE::<CI<46>> {};
    let t0 = circuit_mul(in28, in28); // Compute z^2
    let t1 = circuit_mul(t0, in28); // Compute z^3
    let t2 = circuit_mul(t1, in28); // Compute z^4
    let t3 = circuit_mul(t2, in28); // Compute z^5
    let t4 = circuit_mul(t3, in28); // Compute z^6
    let t5 = circuit_mul(t4, in28); // Compute z^7
    let t6 = circuit_mul(t5, in28); // Compute z^8
    let t7 = circuit_mul(t6, in28); // Compute z^9
    let t8 = circuit_mul(t7, in28); // Compute z^10
    let t9 = circuit_mul(t8, in28); // Compute z^11
    let t10 = circuit_sub(in0, in17);
    let t11 = circuit_sub(in0, in19);
    let t12 = circuit_sub(in0, in21);
    let t13 = circuit_sub(in0, in23);
    let t14 = circuit_sub(in0, in25);
    let t15 = circuit_sub(in0, in27);
    let t16 = circuit_mul(t10, in28); // Eval C_inv step coeff_1 * z^1
    let t17 = circuit_add(in16, t16); // Eval C_inv step + (coeff_1 * z^1)
    let t18 = circuit_mul(in18, t0); // Eval C_inv step coeff_2 * z^2
    let t19 = circuit_add(t17, t18); // Eval C_inv step + (coeff_2 * z^2)
    let t20 = circuit_mul(t11, t1); // Eval C_inv step coeff_3 * z^3
    let t21 = circuit_add(t19, t20); // Eval C_inv step + (coeff_3 * z^3)
    let t22 = circuit_mul(in20, t2); // Eval C_inv step coeff_4 * z^4
    let t23 = circuit_add(t21, t22); // Eval C_inv step + (coeff_4 * z^4)
    let t24 = circuit_mul(t12, t3); // Eval C_inv step coeff_5 * z^5
    let t25 = circuit_add(t23, t24); // Eval C_inv step + (coeff_5 * z^5)
    let t26 = circuit_mul(in22, t4); // Eval C_inv step coeff_6 * z^6
    let t27 = circuit_add(t25, t26); // Eval C_inv step + (coeff_6 * z^6)
    let t28 = circuit_mul(t13, t5); // Eval C_inv step coeff_7 * z^7
    let t29 = circuit_add(t27, t28); // Eval C_inv step + (coeff_7 * z^7)
    let t30 = circuit_mul(in24, t6); // Eval C_inv step coeff_8 * z^8
    let t31 = circuit_add(t29, t30); // Eval C_inv step + (coeff_8 * z^8)
    let t32 = circuit_mul(t14, t7); // Eval C_inv step coeff_9 * z^9
    let t33 = circuit_add(t31, t32); // Eval C_inv step + (coeff_9 * z^9)
    let t34 = circuit_mul(in26, t8); // Eval C_inv step coeff_10 * z^10
    let t35 = circuit_add(t33, t34); // Eval C_inv step + (coeff_10 * z^10)
    let t36 = circuit_mul(t15, t9); // Eval C_inv step coeff_11 * z^11
    let t37 = circuit_add(t35, t36); // Eval C_inv step + (coeff_11 * z^11)
    let t38 = circuit_mul(in30, t0); // Eval sparse poly W step coeff_2 * z^2
    let t39 = circuit_add(in29, t38); // Eval sparse poly W step + coeff_2 * z^2
    let t40 = circuit_mul(in31, t2); // Eval sparse poly W step coeff_4 * z^4
    let t41 = circuit_add(t39, t40); // Eval sparse poly W step + coeff_4 * z^4
    let t42 = circuit_mul(in32, t4); // Eval sparse poly W step coeff_6 * z^6
    let t43 = circuit_add(t41, t42); // Eval sparse poly W step + coeff_6 * z^6
    let t44 = circuit_mul(in33, t6); // Eval sparse poly W step coeff_8 * z^8
    let t45 = circuit_add(t43, t44); // Eval sparse poly W step + coeff_8 * z^8
    let t46 = circuit_mul(in34, t8); // Eval sparse poly W step coeff_10 * z^10
    let t47 = circuit_add(t45, t46); // Eval sparse poly W step + coeff_10 * z^10
    let t48 = circuit_mul(in22, in1);
    let t49 = circuit_add(in16, t48);
    let t50 = circuit_mul(t10, in2);
    let t51 = circuit_mul(t13, in2);
    let t52 = circuit_add(t50, t51);
    let t53 = circuit_mul(in18, in3);
    let t54 = circuit_mul(t14, in4);
    let t55 = circuit_mul(in20, in5);
    let t56 = circuit_mul(in26, in6);
    let t57 = circuit_add(t55, t56);
    let t58 = circuit_mul(t12, in7);
    let t59 = circuit_mul(t15, in7);
    let t60 = circuit_add(t58, t59);
    let t61 = circuit_mul(in22, in8);
    let t62 = circuit_mul(t10, in9);
    let t63 = circuit_mul(t13, in10);
    let t64 = circuit_add(t62, t63);
    let t65 = circuit_mul(in18, in11);
    let t66 = circuit_mul(in24, in11);
    let t67 = circuit_add(t65, t66);
    let t68 = circuit_mul(t11, in12);
    let t69 = circuit_mul(in26, in13);
    let t70 = circuit_mul(t12, in14);
    let t71 = circuit_mul(t15, in15);
    let t72 = circuit_add(t70, t71);
    let t73 = circuit_sub(in0, t52);
    let t74 = circuit_sub(in0, t54);
    let t75 = circuit_sub(in0, t60);
    let t76 = circuit_sub(in0, t64);
    let t77 = circuit_sub(in0, t68);
    let t78 = circuit_sub(in0, t72);
    let t79 = circuit_mul(t73, in28); // Eval C_inv_frob_1 step coeff_1 * z^1
    let t80 = circuit_add(t49, t79); // Eval C_inv_frob_1 step + (coeff_1 * z^1)
    let t81 = circuit_mul(t53, t0); // Eval C_inv_frob_1 step coeff_2 * z^2
    let t82 = circuit_add(t80, t81); // Eval C_inv_frob_1 step + (coeff_2 * z^2)
    let t83 = circuit_mul(t74, t1); // Eval C_inv_frob_1 step coeff_3 * z^3
    let t84 = circuit_add(t82, t83); // Eval C_inv_frob_1 step + (coeff_3 * z^3)
    let t85 = circuit_mul(t57, t2); // Eval C_inv_frob_1 step coeff_4 * z^4
    let t86 = circuit_add(t84, t85); // Eval C_inv_frob_1 step + (coeff_4 * z^4)
    let t87 = circuit_mul(t75, t3); // Eval C_inv_frob_1 step coeff_5 * z^5
    let t88 = circuit_add(t86, t87); // Eval C_inv_frob_1 step + (coeff_5 * z^5)
    let t89 = circuit_mul(t61, t4); // Eval C_inv_frob_1 step coeff_6 * z^6
    let t90 = circuit_add(t88, t89); // Eval C_inv_frob_1 step + (coeff_6 * z^6)
    let t91 = circuit_mul(t76, t5); // Eval C_inv_frob_1 step coeff_7 * z^7
    let t92 = circuit_add(t90, t91); // Eval C_inv_frob_1 step + (coeff_7 * z^7)
    let t93 = circuit_mul(t67, t6); // Eval C_inv_frob_1 step coeff_8 * z^8
    let t94 = circuit_add(t92, t93); // Eval C_inv_frob_1 step + (coeff_8 * z^8)
    let t95 = circuit_mul(t77, t7); // Eval C_inv_frob_1 step coeff_9 * z^9
    let t96 = circuit_add(t94, t95); // Eval C_inv_frob_1 step + (coeff_9 * z^9)
    let t97 = circuit_mul(t69, t8); // Eval C_inv_frob_1 step coeff_10 * z^10
    let t98 = circuit_add(t96, t97); // Eval C_inv_frob_1 step + (coeff_10 * z^10)
    let t99 = circuit_mul(t78, t9); // Eval C_inv_frob_1 step coeff_11 * z^11
    let t100 = circuit_add(t98, t99); // Eval C_inv_frob_1 step + (coeff_11 * z^11)
    let t101 = circuit_mul(in36, in28); // Eval precomputed_miller_loop_result step coeff_1 * z^1
    let t102 = circuit_add(
        in35, t101,
    ); // Eval precomputed_miller_loop_result step + (coeff_1 * z^1)
    let t103 = circuit_mul(in37, t0); // Eval precomputed_miller_loop_result step coeff_2 * z^2
    let t104 = circuit_add(
        t102, t103,
    ); // Eval precomputed_miller_loop_result step + (coeff_2 * z^2)
    let t105 = circuit_mul(in38, t1); // Eval precomputed_miller_loop_result step coeff_3 * z^3
    let t106 = circuit_add(
        t104, t105,
    ); // Eval precomputed_miller_loop_result step + (coeff_3 * z^3)
    let t107 = circuit_mul(in39, t2); // Eval precomputed_miller_loop_result step coeff_4 * z^4
    let t108 = circuit_add(
        t106, t107,
    ); // Eval precomputed_miller_loop_result step + (coeff_4 * z^4)
    let t109 = circuit_mul(in40, t3); // Eval precomputed_miller_loop_result step coeff_5 * z^5
    let t110 = circuit_add(
        t108, t109,
    ); // Eval precomputed_miller_loop_result step + (coeff_5 * z^5)
    let t111 = circuit_mul(in41, t4); // Eval precomputed_miller_loop_result step coeff_6 * z^6
    let t112 = circuit_add(
        t110, t111,
    ); // Eval precomputed_miller_loop_result step + (coeff_6 * z^6)
    let t113 = circuit_mul(in42, t5); // Eval precomputed_miller_loop_result step coeff_7 * z^7
    let t114 = circuit_add(
        t112, t113,
    ); // Eval precomputed_miller_loop_result step + (coeff_7 * z^7)
    let t115 = circuit_mul(in43, t6); // Eval precomputed_miller_loop_result step coeff_8 * z^8
    let t116 = circuit_add(
        t114, t115,
    ); // Eval precomputed_miller_loop_result step + (coeff_8 * z^8)
    let t117 = circuit_mul(in44, t7); // Eval precomputed_miller_loop_result step coeff_9 * z^9
    let t118 = circuit_add(
        t116, t117,
    ); // Eval precomputed_miller_loop_result step + (coeff_9 * z^9)
    let t119 = circuit_mul(in45, t8); // Eval precomputed_miller_loop_result step coeff_10 * z^10
    let t120 = circuit_add(
        t118, t119,
    ); // Eval precomputed_miller_loop_result step + (coeff_10 * z^10)
    let t121 = circuit_mul(in46, t9); // Eval precomputed_miller_loop_result step coeff_11 * z^11
    let t122 = circuit_add(
        t120, t121,
    ); // Eval precomputed_miller_loop_result step + (coeff_11 * z^11)

    let modulus = crate::definitions::get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (t37, t47, t100, t122).new_inputs();
    // Prefill constants:

    circuit_inputs = circuit_inputs
        .next_span(INITIALIZE_MPCHECK_EXT_MLR_BLS12_381_CONSTANTS.span()); // in0 - in15

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(lambda_root_inverse.w0); // in16
    circuit_inputs = circuit_inputs.next_2(lambda_root_inverse.w1); // in17
    circuit_inputs = circuit_inputs.next_2(lambda_root_inverse.w2); // in18
    circuit_inputs = circuit_inputs.next_2(lambda_root_inverse.w3); // in19
    circuit_inputs = circuit_inputs.next_2(lambda_root_inverse.w4); // in20
    circuit_inputs = circuit_inputs.next_2(lambda_root_inverse.w5); // in21
    circuit_inputs = circuit_inputs.next_2(lambda_root_inverse.w6); // in22
    circuit_inputs = circuit_inputs.next_2(lambda_root_inverse.w7); // in23
    circuit_inputs = circuit_inputs.next_2(lambda_root_inverse.w8); // in24
    circuit_inputs = circuit_inputs.next_2(lambda_root_inverse.w9); // in25
    circuit_inputs = circuit_inputs.next_2(lambda_root_inverse.w10); // in26
    circuit_inputs = circuit_inputs.next_2(lambda_root_inverse.w11); // in27
    circuit_inputs = circuit_inputs.next_2(z); // in28
    circuit_inputs = circuit_inputs.next_2(scaling_factor.w0); // in29
    circuit_inputs = circuit_inputs.next_2(scaling_factor.w2); // in30
    circuit_inputs = circuit_inputs.next_2(scaling_factor.w4); // in31
    circuit_inputs = circuit_inputs.next_2(scaling_factor.w6); // in32
    circuit_inputs = circuit_inputs.next_2(scaling_factor.w8); // in33
    circuit_inputs = circuit_inputs.next_2(scaling_factor.w10); // in34
    circuit_inputs = circuit_inputs.next_2(precomputed_miller_loop_result.w0); // in35
    circuit_inputs = circuit_inputs.next_2(precomputed_miller_loop_result.w1); // in36
    circuit_inputs = circuit_inputs.next_2(precomputed_miller_loop_result.w2); // in37
    circuit_inputs = circuit_inputs.next_2(precomputed_miller_loop_result.w3); // in38
    circuit_inputs = circuit_inputs.next_2(precomputed_miller_loop_result.w4); // in39
    circuit_inputs = circuit_inputs.next_2(precomputed_miller_loop_result.w5); // in40
    circuit_inputs = circuit_inputs.next_2(precomputed_miller_loop_result.w6); // in41
    circuit_inputs = circuit_inputs.next_2(precomputed_miller_loop_result.w7); // in42
    circuit_inputs = circuit_inputs.next_2(precomputed_miller_loop_result.w8); // in43
    circuit_inputs = circuit_inputs.next_2(precomputed_miller_loop_result.w9); // in44
    circuit_inputs = circuit_inputs.next_2(precomputed_miller_loop_result.w10); // in45
    circuit_inputs = circuit_inputs.next_2(precomputed_miller_loop_result.w11); // in46

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let c_inv_of_z: u384 = outputs.get_output(t37);
    let scaling_factor_of_z: u384 = outputs.get_output(t47);
    let c_inv_frob_1_conjugate_of_z: u384 = outputs.get_output(t100);
    let precomputed_miller_loop_result_of_z: u384 = outputs.get_output(t122);
    return (
        c_inv_of_z,
        scaling_factor_of_z,
        c_inv_frob_1_conjugate_of_z,
        precomputed_miller_loop_result_of_z,
    );
}
const INITIALIZE_MPCHECK_EXT_MLR_BLS12_381_CONSTANTS: [u384; 16] = [
    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x2, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 {
        limb0: 0x167b027b600febdb244714c5,
        limb1: 0x8f17b50e12c47d65ce514a7c,
        limb2: 0xfd0c6d66bb34bc7585f5abdf,
        limb3: 0x18089593cbf626353947d5b1,
    },
    u384 {
        limb0: 0x620a00022e01fffffffeffff,
        limb1: 0xddb3a93be6f89688de17d813,
        limb2: 0xdf76ce51ba69c6076a0f77ea,
        limb3: 0x5f19672f,
    },
    u384 {
        limb0: 0xe5d80be9902109f7dbc79812,
        limb1: 0xefeedc2e0124838bdccf325e,
        limb2: 0xd7a2fffc9072bb5785a686bc,
        limb3: 0xd5e1c086ffe8016d063c6da,
    },
    u384 {
        limb0: 0x4f49fffd8bfd00000000aaad,
        limb1: 0x897d29650fb85f9b409427eb,
        limb2: 0x63d4de85aa0d857d89759ad4,
        limb3: 0x1a0111ea397fe699ec024086,
    },
    u384 {
        limb0: 0xed3ffffb5dfb00000001aaaf,
        limb1: 0xabc9802928bfc912627c4fd7,
        limb2: 0x845e1033efa3bf761f6622e9,
        limb3: 0x1a0111ea397fe6998ce8d956,
    },
    u384 {
        limb0: 0x4aff0e653631f5d3000f022c,
        limb1: 0x17d5be9b1d380acd8c747cdc,
        limb2: 0x9163c08be7302c4818171fdd,
        limb3: 0xb659fb20274bfb1be8ff4d6,
    },
    u384 {
        limb0: 0xb153ffffb9feffffffffaaaa,
        limb1: 0x6730d2a0f6b0f6241eabfffe,
        limb2: 0x434bacd764774b84f38512bf,
        limb3: 0x1a0111ea397fe69a4b1ba7b6,
    },
    u384 {
        limb0: 0x4d6c7ec22cf78a126ddc4af3,
        limb1: 0xec0c8ec971f63c5f282d5ac1,
        limb2: 0x231f9fb854a14787b6c7b36f,
        limb3: 0xfc3e2b36c4e03288e9e902,
    },
    u384 {
        limb0: 0x9ad8fd8459ef1424dbb895e6,
        limb1: 0xd8191d92e3ec78be505ab582,
        limb2: 0x463f3f70a9428f0f6d8f66df,
        limb3: 0x1f87c566d89c06511d3d204,
    },
    u384 {
        limb0: 0x4f49fffd8bfd00000000aaac,
        limb1: 0x897d29650fb85f9b409427eb,
        limb2: 0x63d4de85aa0d857d89759ad4,
        limb3: 0x1a0111ea397fe699ec024086,
    },
    u384 {
        limb0: 0x72ec05f4c81084fbede3cc09,
        limb1: 0x77f76e17009241c5ee67992f,
        limb2: 0x6bd17ffe48395dabc2d3435e,
        limb3: 0x6af0e0437ff400b6831e36d,
    },
    u384 {
        limb0: 0x620a00022e01fffffffefffe,
        limb1: 0xddb3a93be6f89688de17d813,
        limb2: 0xdf76ce51ba69c6076a0f77ea,
        limb3: 0x5f19672f,
    },
    u384 {
        limb0: 0x8bd478cd1ee605167ff82995,
        limb1: 0xdb45f3536814f0bd5871c190,
        limb2: 0xfa99cc9170df3560e77982d0,
        limb3: 0x144e4211384586c16bd3ad4a,
    },
    u384 {
        limb0: 0x6654f19a83cd0a2cfff0a87f,
        limb1: 0x4f5b1405d978eb5692378322,
        limb2: 0xb1e7ec4b7d471f3cdb6df2e2,
        limb3: 0xe9b7238370b26e88c8bb2df,
    },
];
#[inline(always)]
pub fn run_BLS12_381_INITIALIZE_MPCHECK_circuit(
    lambda_root_inverse: E12D<u384>, z: u384, scaling_factor: MillerLoopResultScalingFactor<u384>,
) -> (u384, u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0
    let in1 = CE::<CI<1>> {}; // 0x2
    let in2 = CE::<
        CI<2>,
    > {}; // 0x18089593cbf626353947d5b1fd0c6d66bb34bc7585f5abdf8f17b50e12c47d65ce514a7c167b027b600febdb244714c5
    let in3 = CE::<
        CI<3>,
    > {}; // 0x5f19672fdf76ce51ba69c6076a0f77eaddb3a93be6f89688de17d813620a00022e01fffffffeffff
    let in4 = CE::<
        CI<4>,
    > {}; // 0xd5e1c086ffe8016d063c6dad7a2fffc9072bb5785a686bcefeedc2e0124838bdccf325ee5d80be9902109f7dbc79812
    let in5 = CE::<
        CI<5>,
    > {}; // 0x1a0111ea397fe699ec02408663d4de85aa0d857d89759ad4897d29650fb85f9b409427eb4f49fffd8bfd00000000aaad
    let in6 = CE::<
        CI<6>,
    > {}; // 0x1a0111ea397fe6998ce8d956845e1033efa3bf761f6622e9abc9802928bfc912627c4fd7ed3ffffb5dfb00000001aaaf
    let in7 = CE::<
        CI<7>,
    > {}; // 0xb659fb20274bfb1be8ff4d69163c08be7302c4818171fdd17d5be9b1d380acd8c747cdc4aff0e653631f5d3000f022c
    let in8 = CE::<CI<8>> {}; // -0x1 % p
    let in9 = CE::<
        CI<9>,
    > {}; // 0xfc3e2b36c4e03288e9e902231f9fb854a14787b6c7b36fec0c8ec971f63c5f282d5ac14d6c7ec22cf78a126ddc4af3
    let in10 = CE::<
        CI<10>,
    > {}; // 0x1f87c566d89c06511d3d204463f3f70a9428f0f6d8f66dfd8191d92e3ec78be505ab5829ad8fd8459ef1424dbb895e6
    let in11 = CE::<
        CI<11>,
    > {}; // 0x1a0111ea397fe699ec02408663d4de85aa0d857d89759ad4897d29650fb85f9b409427eb4f49fffd8bfd00000000aaac
    let in12 = CE::<
        CI<12>,
    > {}; // 0x6af0e0437ff400b6831e36d6bd17ffe48395dabc2d3435e77f76e17009241c5ee67992f72ec05f4c81084fbede3cc09
    let in13 = CE::<
        CI<13>,
    > {}; // 0x5f19672fdf76ce51ba69c6076a0f77eaddb3a93be6f89688de17d813620a00022e01fffffffefffe
    let in14 = CE::<
        CI<14>,
    > {}; // 0x144e4211384586c16bd3ad4afa99cc9170df3560e77982d0db45f3536814f0bd5871c1908bd478cd1ee605167ff82995
    let in15 = CE::<
        CI<15>,
    > {}; // 0xe9b7238370b26e88c8bb2dfb1e7ec4b7d471f3cdb6df2e24f5b1405d978eb56923783226654f19a83cd0a2cfff0a87f

    // INPUT stack
    let (in16, in17, in18) = (CE::<CI<16>> {}, CE::<CI<17>> {}, CE::<CI<18>> {});
    let (in19, in20, in21) = (CE::<CI<19>> {}, CE::<CI<20>> {}, CE::<CI<21>> {});
    let (in22, in23, in24) = (CE::<CI<22>> {}, CE::<CI<23>> {}, CE::<CI<24>> {});
    let (in25, in26, in27) = (CE::<CI<25>> {}, CE::<CI<26>> {}, CE::<CI<27>> {});
    let (in28, in29, in30) = (CE::<CI<28>> {}, CE::<CI<29>> {}, CE::<CI<30>> {});
    let (in31, in32, in33) = (CE::<CI<31>> {}, CE::<CI<32>> {}, CE::<CI<33>> {});
    let in34 = CE::<CI<34>> {};
    let t0 = circuit_mul(in28, in28); // Compute z^2
    let t1 = circuit_mul(t0, in28); // Compute z^3
    let t2 = circuit_mul(t1, in28); // Compute z^4
    let t3 = circuit_mul(t2, in28); // Compute z^5
    let t4 = circuit_mul(t3, in28); // Compute z^6
    let t5 = circuit_mul(t4, in28); // Compute z^7
    let t6 = circuit_mul(t5, in28); // Compute z^8
    let t7 = circuit_mul(t6, in28); // Compute z^9
    let t8 = circuit_mul(t7, in28); // Compute z^10
    let t9 = circuit_mul(t8, in28); // Compute z^11
    let t10 = circuit_sub(in0, in17);
    let t11 = circuit_sub(in0, in19);
    let t12 = circuit_sub(in0, in21);
    let t13 = circuit_sub(in0, in23);
    let t14 = circuit_sub(in0, in25);
    let t15 = circuit_sub(in0, in27);
    let t16 = circuit_mul(t10, in28); // Eval C_inv step coeff_1 * z^1
    let t17 = circuit_add(in16, t16); // Eval C_inv step + (coeff_1 * z^1)
    let t18 = circuit_mul(in18, t0); // Eval C_inv step coeff_2 * z^2
    let t19 = circuit_add(t17, t18); // Eval C_inv step + (coeff_2 * z^2)
    let t20 = circuit_mul(t11, t1); // Eval C_inv step coeff_3 * z^3
    let t21 = circuit_add(t19, t20); // Eval C_inv step + (coeff_3 * z^3)
    let t22 = circuit_mul(in20, t2); // Eval C_inv step coeff_4 * z^4
    let t23 = circuit_add(t21, t22); // Eval C_inv step + (coeff_4 * z^4)
    let t24 = circuit_mul(t12, t3); // Eval C_inv step coeff_5 * z^5
    let t25 = circuit_add(t23, t24); // Eval C_inv step + (coeff_5 * z^5)
    let t26 = circuit_mul(in22, t4); // Eval C_inv step coeff_6 * z^6
    let t27 = circuit_add(t25, t26); // Eval C_inv step + (coeff_6 * z^6)
    let t28 = circuit_mul(t13, t5); // Eval C_inv step coeff_7 * z^7
    let t29 = circuit_add(t27, t28); // Eval C_inv step + (coeff_7 * z^7)
    let t30 = circuit_mul(in24, t6); // Eval C_inv step coeff_8 * z^8
    let t31 = circuit_add(t29, t30); // Eval C_inv step + (coeff_8 * z^8)
    let t32 = circuit_mul(t14, t7); // Eval C_inv step coeff_9 * z^9
    let t33 = circuit_add(t31, t32); // Eval C_inv step + (coeff_9 * z^9)
    let t34 = circuit_mul(in26, t8); // Eval C_inv step coeff_10 * z^10
    let t35 = circuit_add(t33, t34); // Eval C_inv step + (coeff_10 * z^10)
    let t36 = circuit_mul(t15, t9); // Eval C_inv step coeff_11 * z^11
    let t37 = circuit_add(t35, t36); // Eval C_inv step + (coeff_11 * z^11)
    let t38 = circuit_mul(in30, t0); // Eval sparse poly W step coeff_2 * z^2
    let t39 = circuit_add(in29, t38); // Eval sparse poly W step + coeff_2 * z^2
    let t40 = circuit_mul(in31, t2); // Eval sparse poly W step coeff_4 * z^4
    let t41 = circuit_add(t39, t40); // Eval sparse poly W step + coeff_4 * z^4
    let t42 = circuit_mul(in32, t4); // Eval sparse poly W step coeff_6 * z^6
    let t43 = circuit_add(t41, t42); // Eval sparse poly W step + coeff_6 * z^6
    let t44 = circuit_mul(in33, t6); // Eval sparse poly W step coeff_8 * z^8
    let t45 = circuit_add(t43, t44); // Eval sparse poly W step + coeff_8 * z^8
    let t46 = circuit_mul(in34, t8); // Eval sparse poly W step coeff_10 * z^10
    let t47 = circuit_add(t45, t46); // Eval sparse poly W step + coeff_10 * z^10
    let t48 = circuit_mul(in22, in1);
    let t49 = circuit_add(in16, t48);
    let t50 = circuit_mul(t10, in2);
    let t51 = circuit_mul(t13, in2);
    let t52 = circuit_add(t50, t51);
    let t53 = circuit_mul(in18, in3);
    let t54 = circuit_mul(t14, in4);
    let t55 = circuit_mul(in20, in5);
    let t56 = circuit_mul(in26, in6);
    let t57 = circuit_add(t55, t56);
    let t58 = circuit_mul(t12, in7);
    let t59 = circuit_mul(t15, in7);
    let t60 = circuit_add(t58, t59);
    let t61 = circuit_mul(in22, in8);
    let t62 = circuit_mul(t10, in9);
    let t63 = circuit_mul(t13, in10);
    let t64 = circuit_add(t62, t63);
    let t65 = circuit_mul(in18, in11);
    let t66 = circuit_mul(in24, in11);
    let t67 = circuit_add(t65, t66);
    let t68 = circuit_mul(t11, in12);
    let t69 = circuit_mul(in26, in13);
    let t70 = circuit_mul(t12, in14);
    let t71 = circuit_mul(t15, in15);
    let t72 = circuit_add(t70, t71);
    let t73 = circuit_sub(in0, t52);
    let t74 = circuit_sub(in0, t54);
    let t75 = circuit_sub(in0, t60);
    let t76 = circuit_sub(in0, t64);
    let t77 = circuit_sub(in0, t68);
    let t78 = circuit_sub(in0, t72);
    let t79 = circuit_mul(t73, in28); // Eval C_inv_frob_1 step coeff_1 * z^1
    let t80 = circuit_add(t49, t79); // Eval C_inv_frob_1 step + (coeff_1 * z^1)
    let t81 = circuit_mul(t53, t0); // Eval C_inv_frob_1 step coeff_2 * z^2
    let t82 = circuit_add(t80, t81); // Eval C_inv_frob_1 step + (coeff_2 * z^2)
    let t83 = circuit_mul(t74, t1); // Eval C_inv_frob_1 step coeff_3 * z^3
    let t84 = circuit_add(t82, t83); // Eval C_inv_frob_1 step + (coeff_3 * z^3)
    let t85 = circuit_mul(t57, t2); // Eval C_inv_frob_1 step coeff_4 * z^4
    let t86 = circuit_add(t84, t85); // Eval C_inv_frob_1 step + (coeff_4 * z^4)
    let t87 = circuit_mul(t75, t3); // Eval C_inv_frob_1 step coeff_5 * z^5
    let t88 = circuit_add(t86, t87); // Eval C_inv_frob_1 step + (coeff_5 * z^5)
    let t89 = circuit_mul(t61, t4); // Eval C_inv_frob_1 step coeff_6 * z^6
    let t90 = circuit_add(t88, t89); // Eval C_inv_frob_1 step + (coeff_6 * z^6)
    let t91 = circuit_mul(t76, t5); // Eval C_inv_frob_1 step coeff_7 * z^7
    let t92 = circuit_add(t90, t91); // Eval C_inv_frob_1 step + (coeff_7 * z^7)
    let t93 = circuit_mul(t67, t6); // Eval C_inv_frob_1 step coeff_8 * z^8
    let t94 = circuit_add(t92, t93); // Eval C_inv_frob_1 step + (coeff_8 * z^8)
    let t95 = circuit_mul(t77, t7); // Eval C_inv_frob_1 step coeff_9 * z^9
    let t96 = circuit_add(t94, t95); // Eval C_inv_frob_1 step + (coeff_9 * z^9)
    let t97 = circuit_mul(t69, t8); // Eval C_inv_frob_1 step coeff_10 * z^10
    let t98 = circuit_add(t96, t97); // Eval C_inv_frob_1 step + (coeff_10 * z^10)
    let t99 = circuit_mul(t78, t9); // Eval C_inv_frob_1 step coeff_11 * z^11
    let t100 = circuit_add(t98, t99); // Eval C_inv_frob_1 step + (coeff_11 * z^11)

    let modulus = crate::definitions::get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (t37, t47, t100).new_inputs();
    // Prefill constants:

    circuit_inputs = circuit_inputs
        .next_span(INITIALIZE_MPCHECK_BLS12_381_CONSTANTS.span()); // in0 - in15

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(lambda_root_inverse.w0); // in16
    circuit_inputs = circuit_inputs.next_2(lambda_root_inverse.w1); // in17
    circuit_inputs = circuit_inputs.next_2(lambda_root_inverse.w2); // in18
    circuit_inputs = circuit_inputs.next_2(lambda_root_inverse.w3); // in19
    circuit_inputs = circuit_inputs.next_2(lambda_root_inverse.w4); // in20
    circuit_inputs = circuit_inputs.next_2(lambda_root_inverse.w5); // in21
    circuit_inputs = circuit_inputs.next_2(lambda_root_inverse.w6); // in22
    circuit_inputs = circuit_inputs.next_2(lambda_root_inverse.w7); // in23
    circuit_inputs = circuit_inputs.next_2(lambda_root_inverse.w8); // in24
    circuit_inputs = circuit_inputs.next_2(lambda_root_inverse.w9); // in25
    circuit_inputs = circuit_inputs.next_2(lambda_root_inverse.w10); // in26
    circuit_inputs = circuit_inputs.next_2(lambda_root_inverse.w11); // in27
    circuit_inputs = circuit_inputs.next_2(z); // in28
    circuit_inputs = circuit_inputs.next_2(scaling_factor.w0); // in29
    circuit_inputs = circuit_inputs.next_2(scaling_factor.w2); // in30
    circuit_inputs = circuit_inputs.next_2(scaling_factor.w4); // in31
    circuit_inputs = circuit_inputs.next_2(scaling_factor.w6); // in32
    circuit_inputs = circuit_inputs.next_2(scaling_factor.w8); // in33
    circuit_inputs = circuit_inputs.next_2(scaling_factor.w10); // in34

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let c_inv_of_z: u384 = outputs.get_output(t37);
    let scaling_factor_of_z: u384 = outputs.get_output(t47);
    let c_inv_frob_1_conjugate_of_z: u384 = outputs.get_output(t100);
    return (c_inv_of_z, scaling_factor_of_z, c_inv_frob_1_conjugate_of_z);
}
const INITIALIZE_MPCHECK_BLS12_381_CONSTANTS: [u384; 16] = [
    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x2, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 {
        limb0: 0x167b027b600febdb244714c5,
        limb1: 0x8f17b50e12c47d65ce514a7c,
        limb2: 0xfd0c6d66bb34bc7585f5abdf,
        limb3: 0x18089593cbf626353947d5b1,
    },
    u384 {
        limb0: 0x620a00022e01fffffffeffff,
        limb1: 0xddb3a93be6f89688de17d813,
        limb2: 0xdf76ce51ba69c6076a0f77ea,
        limb3: 0x5f19672f,
    },
    u384 {
        limb0: 0xe5d80be9902109f7dbc79812,
        limb1: 0xefeedc2e0124838bdccf325e,
        limb2: 0xd7a2fffc9072bb5785a686bc,
        limb3: 0xd5e1c086ffe8016d063c6da,
    },
    u384 {
        limb0: 0x4f49fffd8bfd00000000aaad,
        limb1: 0x897d29650fb85f9b409427eb,
        limb2: 0x63d4de85aa0d857d89759ad4,
        limb3: 0x1a0111ea397fe699ec024086,
    },
    u384 {
        limb0: 0xed3ffffb5dfb00000001aaaf,
        limb1: 0xabc9802928bfc912627c4fd7,
        limb2: 0x845e1033efa3bf761f6622e9,
        limb3: 0x1a0111ea397fe6998ce8d956,
    },
    u384 {
        limb0: 0x4aff0e653631f5d3000f022c,
        limb1: 0x17d5be9b1d380acd8c747cdc,
        limb2: 0x9163c08be7302c4818171fdd,
        limb3: 0xb659fb20274bfb1be8ff4d6,
    },
    u384 {
        limb0: 0xb153ffffb9feffffffffaaaa,
        limb1: 0x6730d2a0f6b0f6241eabfffe,
        limb2: 0x434bacd764774b84f38512bf,
        limb3: 0x1a0111ea397fe69a4b1ba7b6,
    },
    u384 {
        limb0: 0x4d6c7ec22cf78a126ddc4af3,
        limb1: 0xec0c8ec971f63c5f282d5ac1,
        limb2: 0x231f9fb854a14787b6c7b36f,
        limb3: 0xfc3e2b36c4e03288e9e902,
    },
    u384 {
        limb0: 0x9ad8fd8459ef1424dbb895e6,
        limb1: 0xd8191d92e3ec78be505ab582,
        limb2: 0x463f3f70a9428f0f6d8f66df,
        limb3: 0x1f87c566d89c06511d3d204,
    },
    u384 {
        limb0: 0x4f49fffd8bfd00000000aaac,
        limb1: 0x897d29650fb85f9b409427eb,
        limb2: 0x63d4de85aa0d857d89759ad4,
        limb3: 0x1a0111ea397fe699ec024086,
    },
    u384 {
        limb0: 0x72ec05f4c81084fbede3cc09,
        limb1: 0x77f76e17009241c5ee67992f,
        limb2: 0x6bd17ffe48395dabc2d3435e,
        limb3: 0x6af0e0437ff400b6831e36d,
    },
    u384 {
        limb0: 0x620a00022e01fffffffefffe,
        limb1: 0xddb3a93be6f89688de17d813,
        limb2: 0xdf76ce51ba69c6076a0f77ea,
        limb3: 0x5f19672f,
    },
    u384 {
        limb0: 0x8bd478cd1ee605167ff82995,
        limb1: 0xdb45f3536814f0bd5871c190,
        limb2: 0xfa99cc9170df3560e77982d0,
        limb3: 0x144e4211384586c16bd3ad4a,
    },
    u384 {
        limb0: 0x6654f19a83cd0a2cfff0a87f,
        limb1: 0x4f5b1405d978eb5692378322,
        limb2: 0xb1e7ec4b7d471f3cdb6df2e2,
        limb3: 0xe9b7238370b26e88c8bb2df,
    },
];
#[inline(always)]
pub fn run_BLS12_381_MP_CHECK_BIT00_2P_2F_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    G2_line_dbl_0: G2Line<u384>,
    G2_line_2nd_0_0: G2Line<u384>,
    yInv_1: u384,
    xNegOverY_1: u384,
    G2_line_dbl_1: G2Line<u384>,
    G2_line_2nd_0_1: G2Line<u384>,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one_of_z: u384,
    z: u384,
    c1: u384,
) -> (u384,) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13, in14) = (CE::<CI<12>> {}, CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16, in17) = (CE::<CI<15>> {}, CE::<CI<16>> {}, CE::<CI<17>> {});
    let (in18, in19, in20) = (CE::<CI<18>> {}, CE::<CI<19>> {}, CE::<CI<20>> {});
    let (in21, in22, in23) = (CE::<CI<21>> {}, CE::<CI<22>> {}, CE::<CI<23>> {});
    let in24 = CE::<CI<24>> {};
    let t0 = circuit_mul(in23, in23); // compute z^2
    let t1 = circuit_mul(t0, in23); // compute z^3
    let t2 = circuit_mul(t1, t1); // compute z^6
    let t3 = circuit_mul(t2, t0); // compute z^8
    let t4 = circuit_mul(in21, in21); // Square f evaluation in Z, the result of previous bit.
    let t5 = circuit_sub(in4, in5);
    let t6 = circuit_mul(t5, in0); // eval bls line by yInv
    let t7 = circuit_sub(in2, in3);
    let t8 = circuit_mul(t7, in1); // eval blsline by xNegOverY
    let t9 = circuit_mul(in5, in0); // eval bls line by yInv
    let t10 = circuit_mul(in3, in1); // eval bls line by xNegOverY
    let t11 = circuit_mul(t8, t0); // Eval sparse poly line_0p_1 step coeff_2 * z^2
    let t12 = circuit_add(t6, t11); // Eval sparse poly line_0p_1 step + coeff_2 * z^2
    let t13 = circuit_add(t12, t1); // Eval sparse poly line_0p_1 step + 1*z^3
    let t14 = circuit_mul(t9, t2); // Eval sparse poly line_0p_1 step coeff_6 * z^6
    let t15 = circuit_add(t13, t14); // Eval sparse poly line_0p_1 step + coeff_6 * z^6
    let t16 = circuit_mul(t10, t3); // Eval sparse poly line_0p_1 step coeff_8 * z^8
    let t17 = circuit_add(t15, t16); // Eval sparse poly line_0p_1 step + coeff_8 * z^8
    let t18 = circuit_mul(t4, t17); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t19 = circuit_sub(in8, in9);
    let t20 = circuit_mul(t19, in10); // eval bls line by yInv
    let t21 = circuit_sub(in6, in7);
    let t22 = circuit_mul(t21, in11); // eval blsline by xNegOverY
    let t23 = circuit_mul(in9, in10); // eval bls line by yInv
    let t24 = circuit_mul(in7, in11); // eval bls line by xNegOverY
    let t25 = circuit_mul(t22, t0); // Eval sparse poly line_1p_1 step coeff_2 * z^2
    let t26 = circuit_add(t20, t25); // Eval sparse poly line_1p_1 step + coeff_2 * z^2
    let t27 = circuit_add(t26, t1); // Eval sparse poly line_1p_1 step + 1*z^3
    let t28 = circuit_mul(t23, t2); // Eval sparse poly line_1p_1 step coeff_6 * z^6
    let t29 = circuit_add(t27, t28); // Eval sparse poly line_1p_1 step + coeff_6 * z^6
    let t30 = circuit_mul(t24, t3); // Eval sparse poly line_1p_1 step coeff_8 * z^8
    let t31 = circuit_add(t29, t30); // Eval sparse poly line_1p_1 step + coeff_8 * z^8
    let t32 = circuit_mul(t18, t31); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t33 = circuit_mul(
        t32, t32,
    ); // Compute (f^2 * Π(i,k) (line_i,k(z))) ^ 2 = f^4 * (Π(i,k) (line_i,k(z)))^2
    let t34 = circuit_sub(in14, in15);
    let t35 = circuit_mul(t34, in0); // eval bls line by yInv
    let t36 = circuit_sub(in12, in13);
    let t37 = circuit_mul(t36, in1); // eval blsline by xNegOverY
    let t38 = circuit_mul(in15, in0); // eval bls line by yInv
    let t39 = circuit_mul(in13, in1); // eval bls line by xNegOverY
    let t40 = circuit_mul(t37, t0); // Eval sparse poly line_0p_1 step coeff_2 * z^2
    let t41 = circuit_add(t35, t40); // Eval sparse poly line_0p_1 step + coeff_2 * z^2
    let t42 = circuit_add(t41, t1); // Eval sparse poly line_0p_1 step + 1*z^3
    let t43 = circuit_mul(t38, t2); // Eval sparse poly line_0p_1 step coeff_6 * z^6
    let t44 = circuit_add(t42, t43); // Eval sparse poly line_0p_1 step + coeff_6 * z^6
    let t45 = circuit_mul(t39, t3); // Eval sparse poly line_0p_1 step coeff_8 * z^8
    let t46 = circuit_add(t44, t45); // Eval sparse poly line_0p_1 step + coeff_8 * z^8
    let t47 = circuit_mul(t33, t46); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t48 = circuit_sub(in18, in19);
    let t49 = circuit_mul(t48, in10); // eval bls line by yInv
    let t50 = circuit_sub(in16, in17);
    let t51 = circuit_mul(t50, in11); // eval blsline by xNegOverY
    let t52 = circuit_mul(in19, in10); // eval bls line by yInv
    let t53 = circuit_mul(in17, in11); // eval bls line by xNegOverY
    let t54 = circuit_mul(t51, t0); // Eval sparse poly line_1p_1 step coeff_2 * z^2
    let t55 = circuit_add(t49, t54); // Eval sparse poly line_1p_1 step + coeff_2 * z^2
    let t56 = circuit_add(t55, t1); // Eval sparse poly line_1p_1 step + 1*z^3
    let t57 = circuit_mul(t52, t2); // Eval sparse poly line_1p_1 step coeff_6 * z^6
    let t58 = circuit_add(t56, t57); // Eval sparse poly line_1p_1 step + coeff_6 * z^6
    let t59 = circuit_mul(t53, t3); // Eval sparse poly line_1p_1 step coeff_8 * z^8
    let t60 = circuit_add(t58, t59); // Eval sparse poly line_1p_1 step + coeff_8 * z^8
    let t61 = circuit_mul(t47, t60); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t62 = circuit_sub(t61, in22); // (Π(i,k) (Pk(z))) - Ri(z)
    let t63 = circuit_mul(in24, in20);
    let t64 = circuit_add(t63, t62); // LHS = c1 * LHS + ((Π(i,k) (Pk(z)) - Ri(z))

    let modulus = crate::definitions::get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (t64,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(yInv_0); // in0
    circuit_inputs = circuit_inputs.next_2(xNegOverY_0); // in1
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r0a0); // in2
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r0a1); // in3
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r1a0); // in4
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r1a1); // in5
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_0.r0a0); // in6
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_0.r0a1); // in7
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_0.r1a0); // in8
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_0.r1a1); // in9
    circuit_inputs = circuit_inputs.next_2(yInv_1); // in10
    circuit_inputs = circuit_inputs.next_2(xNegOverY_1); // in11
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r0a0); // in12
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r0a1); // in13
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r1a0); // in14
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r1a1); // in15
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_1.r0a0); // in16
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_1.r0a1); // in17
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_1.r1a0); // in18
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_1.r1a1); // in19
    circuit_inputs = circuit_inputs.next_2(lhs_i); // in20
    circuit_inputs = circuit_inputs.next_2(f_i_of_z); // in21
    circuit_inputs = circuit_inputs.next_2(f_i_plus_one_of_z); // in22
    circuit_inputs = circuit_inputs.next_2(z); // in23
    circuit_inputs = circuit_inputs.next_2(c1); // in24

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let lhs_i_plus_one: u384 = outputs.get_output(t64);
    return (lhs_i_plus_one,);
}
#[inline(always)]
pub fn run_BLS12_381_MP_CHECK_BIT00_3P_2F_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    G2_line_dbl_0: G2Line<u384>,
    G2_line_2nd_0_0: G2Line<u384>,
    yInv_1: u384,
    xNegOverY_1: u384,
    G2_line_dbl_1: G2Line<u384>,
    G2_line_2nd_0_1: G2Line<u384>,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q_2: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one_of_z: u384,
    z: u384,
    c1: u384,
) -> (G2Point, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x3
    let in1 = CE::<CI<1>> {}; // 0x6
    let in2 = CE::<CI<2>> {}; // 0x0

    // INPUT stack
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13, in14) = (CE::<CI<12>> {}, CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16, in17) = (CE::<CI<15>> {}, CE::<CI<16>> {}, CE::<CI<17>> {});
    let (in18, in19, in20) = (CE::<CI<18>> {}, CE::<CI<19>> {}, CE::<CI<20>> {});
    let (in21, in22, in23) = (CE::<CI<21>> {}, CE::<CI<22>> {}, CE::<CI<23>> {});
    let (in24, in25, in26) = (CE::<CI<24>> {}, CE::<CI<25>> {}, CE::<CI<26>> {});
    let (in27, in28, in29) = (CE::<CI<27>> {}, CE::<CI<28>> {}, CE::<CI<29>> {});
    let (in30, in31, in32) = (CE::<CI<30>> {}, CE::<CI<31>> {}, CE::<CI<32>> {});
    let in33 = CE::<CI<33>> {};
    let t0 = circuit_mul(in32, in32); // compute z^2
    let t1 = circuit_mul(t0, in32); // compute z^3
    let t2 = circuit_mul(t1, t1); // compute z^6
    let t3 = circuit_mul(t2, t0); // compute z^8
    let t4 = circuit_mul(in30, in30); // Square f evaluation in Z, the result of previous bit.
    let t5 = circuit_sub(in7, in8);
    let t6 = circuit_mul(t5, in3); // eval bls line by yInv
    let t7 = circuit_sub(in5, in6);
    let t8 = circuit_mul(t7, in4); // eval blsline by xNegOverY
    let t9 = circuit_mul(in8, in3); // eval bls line by yInv
    let t10 = circuit_mul(in6, in4); // eval bls line by xNegOverY
    let t11 = circuit_mul(t8, t0); // Eval sparse poly line_0p_1 step coeff_2 * z^2
    let t12 = circuit_add(t6, t11); // Eval sparse poly line_0p_1 step + coeff_2 * z^2
    let t13 = circuit_add(t12, t1); // Eval sparse poly line_0p_1 step + 1*z^3
    let t14 = circuit_mul(t9, t2); // Eval sparse poly line_0p_1 step coeff_6 * z^6
    let t15 = circuit_add(t13, t14); // Eval sparse poly line_0p_1 step + coeff_6 * z^6
    let t16 = circuit_mul(t10, t3); // Eval sparse poly line_0p_1 step coeff_8 * z^8
    let t17 = circuit_add(t15, t16); // Eval sparse poly line_0p_1 step + coeff_8 * z^8
    let t18 = circuit_mul(t4, t17); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t19 = circuit_sub(in11, in12);
    let t20 = circuit_mul(t19, in13); // eval bls line by yInv
    let t21 = circuit_sub(in9, in10);
    let t22 = circuit_mul(t21, in14); // eval blsline by xNegOverY
    let t23 = circuit_mul(in12, in13); // eval bls line by yInv
    let t24 = circuit_mul(in10, in14); // eval bls line by xNegOverY
    let t25 = circuit_mul(t22, t0); // Eval sparse poly line_1p_1 step coeff_2 * z^2
    let t26 = circuit_add(t20, t25); // Eval sparse poly line_1p_1 step + coeff_2 * z^2
    let t27 = circuit_add(t26, t1); // Eval sparse poly line_1p_1 step + 1*z^3
    let t28 = circuit_mul(t23, t2); // Eval sparse poly line_1p_1 step coeff_6 * z^6
    let t29 = circuit_add(t27, t28); // Eval sparse poly line_1p_1 step + coeff_6 * z^6
    let t30 = circuit_mul(t24, t3); // Eval sparse poly line_1p_1 step coeff_8 * z^8
    let t31 = circuit_add(t29, t30); // Eval sparse poly line_1p_1 step + coeff_8 * z^8
    let t32 = circuit_mul(t18, t31); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t33 = circuit_add(in25, in26); // Doubling slope numerator start
    let t34 = circuit_sub(in25, in26);
    let t35 = circuit_mul(t33, t34);
    let t36 = circuit_mul(in25, in26);
    let t37 = circuit_mul(t35, in0);
    let t38 = circuit_mul(t36, in1); // Doubling slope numerator end
    let t39 = circuit_add(in27, in27); // Fp2 add coeff 0/1
    let t40 = circuit_add(in28, in28); // Fp2 add coeff 1/1
    let t41 = circuit_mul(t39, t39); // Fp2 Inv start
    let t42 = circuit_mul(t40, t40);
    let t43 = circuit_add(t41, t42);
    let t44 = circuit_inverse(t43);
    let t45 = circuit_mul(t39, t44); // Fp2 Inv real part end
    let t46 = circuit_mul(t40, t44);
    let t47 = circuit_sub(in2, t46); // Fp2 Inv imag part end
    let t48 = circuit_mul(t37, t45); // Fp2 mul start
    let t49 = circuit_mul(t38, t47);
    let t50 = circuit_sub(t48, t49); // Fp2 mul real part end
    let t51 = circuit_mul(t37, t47);
    let t52 = circuit_mul(t38, t45);
    let t53 = circuit_add(t51, t52); // Fp2 mul imag part end
    let t54 = circuit_add(t50, t53);
    let t55 = circuit_sub(t50, t53);
    let t56 = circuit_mul(t54, t55);
    let t57 = circuit_mul(t50, t53);
    let t58 = circuit_add(t57, t57);
    let t59 = circuit_add(in25, in25); // Fp2 add coeff 0/1
    let t60 = circuit_add(in26, in26); // Fp2 add coeff 1/1
    let t61 = circuit_sub(t56, t59); // Fp2 sub coeff 0/1
    let t62 = circuit_sub(t58, t60); // Fp2 sub coeff 1/1
    let t63 = circuit_sub(in25, t61); // Fp2 sub coeff 0/1
    let t64 = circuit_sub(in26, t62); // Fp2 sub coeff 1/1
    let t65 = circuit_mul(t50, t63); // Fp2 mul start
    let t66 = circuit_mul(t53, t64);
    let t67 = circuit_sub(t65, t66); // Fp2 mul real part end
    let t68 = circuit_mul(t50, t64);
    let t69 = circuit_mul(t53, t63);
    let t70 = circuit_add(t68, t69); // Fp2 mul imag part end
    let t71 = circuit_sub(t67, in27); // Fp2 sub coeff 0/1
    let t72 = circuit_sub(t70, in28); // Fp2 sub coeff 1/1
    let t73 = circuit_mul(t50, in25); // Fp2 mul start
    let t74 = circuit_mul(t53, in26);
    let t75 = circuit_sub(t73, t74); // Fp2 mul real part end
    let t76 = circuit_mul(t50, in26);
    let t77 = circuit_mul(t53, in25);
    let t78 = circuit_add(t76, t77); // Fp2 mul imag part end
    let t79 = circuit_sub(t75, in27); // Fp2 sub coeff 0/1
    let t80 = circuit_sub(t78, in28); // Fp2 sub coeff 1/1
    let t81 = circuit_sub(t79, t80);
    let t82 = circuit_mul(t81, in23); // eval bls line by yInv
    let t83 = circuit_sub(t50, t53);
    let t84 = circuit_mul(t83, in24); // eval blsline by xNegOverY
    let t85 = circuit_mul(t80, in23); // eval bls line by yInv
    let t86 = circuit_mul(t53, in24); // eval bls line by xNegOverY
    let t87 = circuit_mul(t84, t0); // Eval sparse poly line_2p_1 step coeff_2 * z^2
    let t88 = circuit_add(t82, t87); // Eval sparse poly line_2p_1 step + coeff_2 * z^2
    let t89 = circuit_add(t88, t1); // Eval sparse poly line_2p_1 step + 1*z^3
    let t90 = circuit_mul(t85, t2); // Eval sparse poly line_2p_1 step coeff_6 * z^6
    let t91 = circuit_add(t89, t90); // Eval sparse poly line_2p_1 step + coeff_6 * z^6
    let t92 = circuit_mul(t86, t3); // Eval sparse poly line_2p_1 step coeff_8 * z^8
    let t93 = circuit_add(t91, t92); // Eval sparse poly line_2p_1 step + coeff_8 * z^8
    let t94 = circuit_mul(t32, t93); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t95 = circuit_mul(
        t94, t94,
    ); // Compute (f^2 * Π(i,k) (line_i,k(z))) ^ 2 = f^4 * (Π(i,k) (line_i,k(z)))^2
    let t96 = circuit_sub(in17, in18);
    let t97 = circuit_mul(t96, in3); // eval bls line by yInv
    let t98 = circuit_sub(in15, in16);
    let t99 = circuit_mul(t98, in4); // eval blsline by xNegOverY
    let t100 = circuit_mul(in18, in3); // eval bls line by yInv
    let t101 = circuit_mul(in16, in4); // eval bls line by xNegOverY
    let t102 = circuit_mul(t99, t0); // Eval sparse poly line_0p_1 step coeff_2 * z^2
    let t103 = circuit_add(t97, t102); // Eval sparse poly line_0p_1 step + coeff_2 * z^2
    let t104 = circuit_add(t103, t1); // Eval sparse poly line_0p_1 step + 1*z^3
    let t105 = circuit_mul(t100, t2); // Eval sparse poly line_0p_1 step coeff_6 * z^6
    let t106 = circuit_add(t104, t105); // Eval sparse poly line_0p_1 step + coeff_6 * z^6
    let t107 = circuit_mul(t101, t3); // Eval sparse poly line_0p_1 step coeff_8 * z^8
    let t108 = circuit_add(t106, t107); // Eval sparse poly line_0p_1 step + coeff_8 * z^8
    let t109 = circuit_mul(t95, t108); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t110 = circuit_sub(in21, in22);
    let t111 = circuit_mul(t110, in13); // eval bls line by yInv
    let t112 = circuit_sub(in19, in20);
    let t113 = circuit_mul(t112, in14); // eval blsline by xNegOverY
    let t114 = circuit_mul(in22, in13); // eval bls line by yInv
    let t115 = circuit_mul(in20, in14); // eval bls line by xNegOverY
    let t116 = circuit_mul(t113, t0); // Eval sparse poly line_1p_1 step coeff_2 * z^2
    let t117 = circuit_add(t111, t116); // Eval sparse poly line_1p_1 step + coeff_2 * z^2
    let t118 = circuit_add(t117, t1); // Eval sparse poly line_1p_1 step + 1*z^3
    let t119 = circuit_mul(t114, t2); // Eval sparse poly line_1p_1 step coeff_6 * z^6
    let t120 = circuit_add(t118, t119); // Eval sparse poly line_1p_1 step + coeff_6 * z^6
    let t121 = circuit_mul(t115, t3); // Eval sparse poly line_1p_1 step coeff_8 * z^8
    let t122 = circuit_add(t120, t121); // Eval sparse poly line_1p_1 step + coeff_8 * z^8
    let t123 = circuit_mul(t109, t122); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t124 = circuit_add(t61, t62); // Doubling slope numerator start
    let t125 = circuit_sub(t61, t62);
    let t126 = circuit_mul(t124, t125);
    let t127 = circuit_mul(t61, t62);
    let t128 = circuit_mul(t126, in0);
    let t129 = circuit_mul(t127, in1); // Doubling slope numerator end
    let t130 = circuit_add(t71, t71); // Fp2 add coeff 0/1
    let t131 = circuit_add(t72, t72); // Fp2 add coeff 1/1
    let t132 = circuit_mul(t130, t130); // Fp2 Inv start
    let t133 = circuit_mul(t131, t131);
    let t134 = circuit_add(t132, t133);
    let t135 = circuit_inverse(t134);
    let t136 = circuit_mul(t130, t135); // Fp2 Inv real part end
    let t137 = circuit_mul(t131, t135);
    let t138 = circuit_sub(in2, t137); // Fp2 Inv imag part end
    let t139 = circuit_mul(t128, t136); // Fp2 mul start
    let t140 = circuit_mul(t129, t138);
    let t141 = circuit_sub(t139, t140); // Fp2 mul real part end
    let t142 = circuit_mul(t128, t138);
    let t143 = circuit_mul(t129, t136);
    let t144 = circuit_add(t142, t143); // Fp2 mul imag part end
    let t145 = circuit_add(t141, t144);
    let t146 = circuit_sub(t141, t144);
    let t147 = circuit_mul(t145, t146);
    let t148 = circuit_mul(t141, t144);
    let t149 = circuit_add(t148, t148);
    let t150 = circuit_add(t61, t61); // Fp2 add coeff 0/1
    let t151 = circuit_add(t62, t62); // Fp2 add coeff 1/1
    let t152 = circuit_sub(t147, t150); // Fp2 sub coeff 0/1
    let t153 = circuit_sub(t149, t151); // Fp2 sub coeff 1/1
    let t154 = circuit_sub(t61, t152); // Fp2 sub coeff 0/1
    let t155 = circuit_sub(t62, t153); // Fp2 sub coeff 1/1
    let t156 = circuit_mul(t141, t154); // Fp2 mul start
    let t157 = circuit_mul(t144, t155);
    let t158 = circuit_sub(t156, t157); // Fp2 mul real part end
    let t159 = circuit_mul(t141, t155);
    let t160 = circuit_mul(t144, t154);
    let t161 = circuit_add(t159, t160); // Fp2 mul imag part end
    let t162 = circuit_sub(t158, t71); // Fp2 sub coeff 0/1
    let t163 = circuit_sub(t161, t72); // Fp2 sub coeff 1/1
    let t164 = circuit_mul(t141, t61); // Fp2 mul start
    let t165 = circuit_mul(t144, t62);
    let t166 = circuit_sub(t164, t165); // Fp2 mul real part end
    let t167 = circuit_mul(t141, t62);
    let t168 = circuit_mul(t144, t61);
    let t169 = circuit_add(t167, t168); // Fp2 mul imag part end
    let t170 = circuit_sub(t166, t71); // Fp2 sub coeff 0/1
    let t171 = circuit_sub(t169, t72); // Fp2 sub coeff 1/1
    let t172 = circuit_sub(t170, t171);
    let t173 = circuit_mul(t172, in23); // eval bls line by yInv
    let t174 = circuit_sub(t141, t144);
    let t175 = circuit_mul(t174, in24); // eval blsline by xNegOverY
    let t176 = circuit_mul(t171, in23); // eval bls line by yInv
    let t177 = circuit_mul(t144, in24); // eval bls line by xNegOverY
    let t178 = circuit_mul(t175, t0); // Eval sparse poly line_2p_1 step coeff_2 * z^2
    let t179 = circuit_add(t173, t178); // Eval sparse poly line_2p_1 step + coeff_2 * z^2
    let t180 = circuit_add(t179, t1); // Eval sparse poly line_2p_1 step + 1*z^3
    let t181 = circuit_mul(t176, t2); // Eval sparse poly line_2p_1 step coeff_6 * z^6
    let t182 = circuit_add(t180, t181); // Eval sparse poly line_2p_1 step + coeff_6 * z^6
    let t183 = circuit_mul(t177, t3); // Eval sparse poly line_2p_1 step coeff_8 * z^8
    let t184 = circuit_add(t182, t183); // Eval sparse poly line_2p_1 step + coeff_8 * z^8
    let t185 = circuit_mul(t123, t184); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t186 = circuit_sub(t185, in31); // (Π(i,k) (Pk(z))) - Ri(z)
    let t187 = circuit_mul(in33, in29);
    let t188 = circuit_add(t187, t186); // LHS = c1 * LHS + ((Π(i,k) (Pk(z)) - Ri(z))

    let modulus = crate::definitions::get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (t152, t153, t162, t163, t188).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x3, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs.next_2([0x6, 0x0, 0x0, 0x0]); // in1
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in2
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(yInv_0); // in3
    circuit_inputs = circuit_inputs.next_2(xNegOverY_0); // in4
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r0a0); // in5
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r0a1); // in6
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r1a0); // in7
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r1a1); // in8
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_0.r0a0); // in9
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_0.r0a1); // in10
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_0.r1a0); // in11
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_0.r1a1); // in12
    circuit_inputs = circuit_inputs.next_2(yInv_1); // in13
    circuit_inputs = circuit_inputs.next_2(xNegOverY_1); // in14
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r0a0); // in15
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r0a1); // in16
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r1a0); // in17
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r1a1); // in18
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_1.r0a0); // in19
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_1.r0a1); // in20
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_1.r1a0); // in21
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_1.r1a1); // in22
    circuit_inputs = circuit_inputs.next_2(yInv_2); // in23
    circuit_inputs = circuit_inputs.next_2(xNegOverY_2); // in24
    circuit_inputs = circuit_inputs.next_2(Q_2.x0); // in25
    circuit_inputs = circuit_inputs.next_2(Q_2.x1); // in26
    circuit_inputs = circuit_inputs.next_2(Q_2.y0); // in27
    circuit_inputs = circuit_inputs.next_2(Q_2.y1); // in28
    circuit_inputs = circuit_inputs.next_2(lhs_i); // in29
    circuit_inputs = circuit_inputs.next_2(f_i_of_z); // in30
    circuit_inputs = circuit_inputs.next_2(f_i_plus_one_of_z); // in31
    circuit_inputs = circuit_inputs.next_2(z); // in32
    circuit_inputs = circuit_inputs.next_2(c1); // in33

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let Q0: G2Point = G2Point {
        x0: outputs.get_output(t152),
        x1: outputs.get_output(t153),
        y0: outputs.get_output(t162),
        y1: outputs.get_output(t163),
    };
    let lhs_i_plus_one: u384 = outputs.get_output(t188);
    return (Q0, lhs_i_plus_one);
}
#[inline(always)]
pub fn run_BLS12_381_MP_CHECK_BIT0_2P_2F_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    G2_line_dbl_0: G2Line<u384>,
    yInv_1: u384,
    xNegOverY_1: u384,
    G2_line_dbl_1: G2Line<u384>,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one_of_z: u384,
    z: u384,
    c1: u384,
) -> (u384,) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13, in14) = (CE::<CI<12>> {}, CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16) = (CE::<CI<15>> {}, CE::<CI<16>> {});
    let t0 = circuit_mul(in15, in15); // compute z^2
    let t1 = circuit_mul(t0, in15); // compute z^3
    let t2 = circuit_mul(t1, t1); // compute z^6
    let t3 = circuit_mul(t2, t0); // compute z^8
    let t4 = circuit_mul(in13, in13); // Square f evaluation in Z, the result of previous bit.
    let t5 = circuit_sub(in4, in5);
    let t6 = circuit_mul(t5, in0); // eval bls line by yInv
    let t7 = circuit_sub(in2, in3);
    let t8 = circuit_mul(t7, in1); // eval blsline by xNegOverY
    let t9 = circuit_mul(in5, in0); // eval bls line by yInv
    let t10 = circuit_mul(in3, in1); // eval bls line by xNegOverY
    let t11 = circuit_mul(t8, t0); // Eval sparse poly line_0p_1 step coeff_2 * z^2
    let t12 = circuit_add(t6, t11); // Eval sparse poly line_0p_1 step + coeff_2 * z^2
    let t13 = circuit_add(t12, t1); // Eval sparse poly line_0p_1 step + 1*z^3
    let t14 = circuit_mul(t9, t2); // Eval sparse poly line_0p_1 step coeff_6 * z^6
    let t15 = circuit_add(t13, t14); // Eval sparse poly line_0p_1 step + coeff_6 * z^6
    let t16 = circuit_mul(t10, t3); // Eval sparse poly line_0p_1 step coeff_8 * z^8
    let t17 = circuit_add(t15, t16); // Eval sparse poly line_0p_1 step + coeff_8 * z^8
    let t18 = circuit_mul(t4, t17); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t19 = circuit_sub(in10, in11);
    let t20 = circuit_mul(t19, in6); // eval bls line by yInv
    let t21 = circuit_sub(in8, in9);
    let t22 = circuit_mul(t21, in7); // eval blsline by xNegOverY
    let t23 = circuit_mul(in11, in6); // eval bls line by yInv
    let t24 = circuit_mul(in9, in7); // eval bls line by xNegOverY
    let t25 = circuit_mul(t22, t0); // Eval sparse poly line_1p_1 step coeff_2 * z^2
    let t26 = circuit_add(t20, t25); // Eval sparse poly line_1p_1 step + coeff_2 * z^2
    let t27 = circuit_add(t26, t1); // Eval sparse poly line_1p_1 step + 1*z^3
    let t28 = circuit_mul(t23, t2); // Eval sparse poly line_1p_1 step coeff_6 * z^6
    let t29 = circuit_add(t27, t28); // Eval sparse poly line_1p_1 step + coeff_6 * z^6
    let t30 = circuit_mul(t24, t3); // Eval sparse poly line_1p_1 step coeff_8 * z^8
    let t31 = circuit_add(t29, t30); // Eval sparse poly line_1p_1 step + coeff_8 * z^8
    let t32 = circuit_mul(t18, t31); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t33 = circuit_sub(t32, in14); // (Π(i,k) (Pk(z))) - Ri(z)
    let t34 = circuit_mul(in16, in12);
    let t35 = circuit_add(t34, t33); // LHS = c1 * LHS + ((Π(i,k) (Pk(z)) - Ri(z))

    let modulus = crate::definitions::get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (t35,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(yInv_0); // in0
    circuit_inputs = circuit_inputs.next_2(xNegOverY_0); // in1
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r0a0); // in2
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r0a1); // in3
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r1a0); // in4
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r1a1); // in5
    circuit_inputs = circuit_inputs.next_2(yInv_1); // in6
    circuit_inputs = circuit_inputs.next_2(xNegOverY_1); // in7
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r0a0); // in8
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r0a1); // in9
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r1a0); // in10
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r1a1); // in11
    circuit_inputs = circuit_inputs.next_2(lhs_i); // in12
    circuit_inputs = circuit_inputs.next_2(f_i_of_z); // in13
    circuit_inputs = circuit_inputs.next_2(f_i_plus_one_of_z); // in14
    circuit_inputs = circuit_inputs.next_2(z); // in15
    circuit_inputs = circuit_inputs.next_2(c1); // in16

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let lhs_i_plus_one: u384 = outputs.get_output(t35);
    return (lhs_i_plus_one,);
}
#[inline(always)]
pub fn run_BLS12_381_MP_CHECK_BIT0_3P_2F_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    G2_line_dbl_0: G2Line<u384>,
    yInv_1: u384,
    xNegOverY_1: u384,
    G2_line_dbl_1: G2Line<u384>,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q_2: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one_of_z: u384,
    z: u384,
    c1: u384,
) -> (G2Point, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x3
    let in1 = CE::<CI<1>> {}; // 0x6
    let in2 = CE::<CI<2>> {}; // 0x0

    // INPUT stack
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13, in14) = (CE::<CI<12>> {}, CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16, in17) = (CE::<CI<15>> {}, CE::<CI<16>> {}, CE::<CI<17>> {});
    let (in18, in19, in20) = (CE::<CI<18>> {}, CE::<CI<19>> {}, CE::<CI<20>> {});
    let (in21, in22, in23) = (CE::<CI<21>> {}, CE::<CI<22>> {}, CE::<CI<23>> {});
    let (in24, in25) = (CE::<CI<24>> {}, CE::<CI<25>> {});
    let t0 = circuit_mul(in24, in24); // compute z^2
    let t1 = circuit_mul(t0, in24); // compute z^3
    let t2 = circuit_mul(t1, t1); // compute z^6
    let t3 = circuit_mul(t2, t0); // compute z^8
    let t4 = circuit_mul(in22, in22); // Square f evaluation in Z, the result of previous bit.
    let t5 = circuit_sub(in7, in8);
    let t6 = circuit_mul(t5, in3); // eval bls line by yInv
    let t7 = circuit_sub(in5, in6);
    let t8 = circuit_mul(t7, in4); // eval blsline by xNegOverY
    let t9 = circuit_mul(in8, in3); // eval bls line by yInv
    let t10 = circuit_mul(in6, in4); // eval bls line by xNegOverY
    let t11 = circuit_mul(t8, t0); // Eval sparse poly line_0p_1 step coeff_2 * z^2
    let t12 = circuit_add(t6, t11); // Eval sparse poly line_0p_1 step + coeff_2 * z^2
    let t13 = circuit_add(t12, t1); // Eval sparse poly line_0p_1 step + 1*z^3
    let t14 = circuit_mul(t9, t2); // Eval sparse poly line_0p_1 step coeff_6 * z^6
    let t15 = circuit_add(t13, t14); // Eval sparse poly line_0p_1 step + coeff_6 * z^6
    let t16 = circuit_mul(t10, t3); // Eval sparse poly line_0p_1 step coeff_8 * z^8
    let t17 = circuit_add(t15, t16); // Eval sparse poly line_0p_1 step + coeff_8 * z^8
    let t18 = circuit_mul(t4, t17); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t19 = circuit_sub(in13, in14);
    let t20 = circuit_mul(t19, in9); // eval bls line by yInv
    let t21 = circuit_sub(in11, in12);
    let t22 = circuit_mul(t21, in10); // eval blsline by xNegOverY
    let t23 = circuit_mul(in14, in9); // eval bls line by yInv
    let t24 = circuit_mul(in12, in10); // eval bls line by xNegOverY
    let t25 = circuit_mul(t22, t0); // Eval sparse poly line_1p_1 step coeff_2 * z^2
    let t26 = circuit_add(t20, t25); // Eval sparse poly line_1p_1 step + coeff_2 * z^2
    let t27 = circuit_add(t26, t1); // Eval sparse poly line_1p_1 step + 1*z^3
    let t28 = circuit_mul(t23, t2); // Eval sparse poly line_1p_1 step coeff_6 * z^6
    let t29 = circuit_add(t27, t28); // Eval sparse poly line_1p_1 step + coeff_6 * z^6
    let t30 = circuit_mul(t24, t3); // Eval sparse poly line_1p_1 step coeff_8 * z^8
    let t31 = circuit_add(t29, t30); // Eval sparse poly line_1p_1 step + coeff_8 * z^8
    let t32 = circuit_mul(t18, t31); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t33 = circuit_add(in17, in18); // Doubling slope numerator start
    let t34 = circuit_sub(in17, in18);
    let t35 = circuit_mul(t33, t34);
    let t36 = circuit_mul(in17, in18);
    let t37 = circuit_mul(t35, in0);
    let t38 = circuit_mul(t36, in1); // Doubling slope numerator end
    let t39 = circuit_add(in19, in19); // Fp2 add coeff 0/1
    let t40 = circuit_add(in20, in20); // Fp2 add coeff 1/1
    let t41 = circuit_mul(t39, t39); // Fp2 Inv start
    let t42 = circuit_mul(t40, t40);
    let t43 = circuit_add(t41, t42);
    let t44 = circuit_inverse(t43);
    let t45 = circuit_mul(t39, t44); // Fp2 Inv real part end
    let t46 = circuit_mul(t40, t44);
    let t47 = circuit_sub(in2, t46); // Fp2 Inv imag part end
    let t48 = circuit_mul(t37, t45); // Fp2 mul start
    let t49 = circuit_mul(t38, t47);
    let t50 = circuit_sub(t48, t49); // Fp2 mul real part end
    let t51 = circuit_mul(t37, t47);
    let t52 = circuit_mul(t38, t45);
    let t53 = circuit_add(t51, t52); // Fp2 mul imag part end
    let t54 = circuit_add(t50, t53);
    let t55 = circuit_sub(t50, t53);
    let t56 = circuit_mul(t54, t55);
    let t57 = circuit_mul(t50, t53);
    let t58 = circuit_add(t57, t57);
    let t59 = circuit_add(in17, in17); // Fp2 add coeff 0/1
    let t60 = circuit_add(in18, in18); // Fp2 add coeff 1/1
    let t61 = circuit_sub(t56, t59); // Fp2 sub coeff 0/1
    let t62 = circuit_sub(t58, t60); // Fp2 sub coeff 1/1
    let t63 = circuit_sub(in17, t61); // Fp2 sub coeff 0/1
    let t64 = circuit_sub(in18, t62); // Fp2 sub coeff 1/1
    let t65 = circuit_mul(t50, t63); // Fp2 mul start
    let t66 = circuit_mul(t53, t64);
    let t67 = circuit_sub(t65, t66); // Fp2 mul real part end
    let t68 = circuit_mul(t50, t64);
    let t69 = circuit_mul(t53, t63);
    let t70 = circuit_add(t68, t69); // Fp2 mul imag part end
    let t71 = circuit_sub(t67, in19); // Fp2 sub coeff 0/1
    let t72 = circuit_sub(t70, in20); // Fp2 sub coeff 1/1
    let t73 = circuit_mul(t50, in17); // Fp2 mul start
    let t74 = circuit_mul(t53, in18);
    let t75 = circuit_sub(t73, t74); // Fp2 mul real part end
    let t76 = circuit_mul(t50, in18);
    let t77 = circuit_mul(t53, in17);
    let t78 = circuit_add(t76, t77); // Fp2 mul imag part end
    let t79 = circuit_sub(t75, in19); // Fp2 sub coeff 0/1
    let t80 = circuit_sub(t78, in20); // Fp2 sub coeff 1/1
    let t81 = circuit_sub(t79, t80);
    let t82 = circuit_mul(t81, in15); // eval bls line by yInv
    let t83 = circuit_sub(t50, t53);
    let t84 = circuit_mul(t83, in16); // eval blsline by xNegOverY
    let t85 = circuit_mul(t80, in15); // eval bls line by yInv
    let t86 = circuit_mul(t53, in16); // eval bls line by xNegOverY
    let t87 = circuit_mul(t84, t0); // Eval sparse poly line_2p_1 step coeff_2 * z^2
    let t88 = circuit_add(t82, t87); // Eval sparse poly line_2p_1 step + coeff_2 * z^2
    let t89 = circuit_add(t88, t1); // Eval sparse poly line_2p_1 step + 1*z^3
    let t90 = circuit_mul(t85, t2); // Eval sparse poly line_2p_1 step coeff_6 * z^6
    let t91 = circuit_add(t89, t90); // Eval sparse poly line_2p_1 step + coeff_6 * z^6
    let t92 = circuit_mul(t86, t3); // Eval sparse poly line_2p_1 step coeff_8 * z^8
    let t93 = circuit_add(t91, t92); // Eval sparse poly line_2p_1 step + coeff_8 * z^8
    let t94 = circuit_mul(t32, t93); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t95 = circuit_sub(t94, in23); // (Π(i,k) (Pk(z))) - Ri(z)
    let t96 = circuit_mul(in25, in21);
    let t97 = circuit_add(t96, t95); // LHS = c1 * LHS + ((Π(i,k) (Pk(z)) - Ri(z))

    let modulus = crate::definitions::get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (t61, t62, t71, t72, t97).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x3, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs.next_2([0x6, 0x0, 0x0, 0x0]); // in1
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in2
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(yInv_0); // in3
    circuit_inputs = circuit_inputs.next_2(xNegOverY_0); // in4
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r0a0); // in5
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r0a1); // in6
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r1a0); // in7
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r1a1); // in8
    circuit_inputs = circuit_inputs.next_2(yInv_1); // in9
    circuit_inputs = circuit_inputs.next_2(xNegOverY_1); // in10
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r0a0); // in11
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r0a1); // in12
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r1a0); // in13
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r1a1); // in14
    circuit_inputs = circuit_inputs.next_2(yInv_2); // in15
    circuit_inputs = circuit_inputs.next_2(xNegOverY_2); // in16
    circuit_inputs = circuit_inputs.next_2(Q_2.x0); // in17
    circuit_inputs = circuit_inputs.next_2(Q_2.x1); // in18
    circuit_inputs = circuit_inputs.next_2(Q_2.y0); // in19
    circuit_inputs = circuit_inputs.next_2(Q_2.y1); // in20
    circuit_inputs = circuit_inputs.next_2(lhs_i); // in21
    circuit_inputs = circuit_inputs.next_2(f_i_of_z); // in22
    circuit_inputs = circuit_inputs.next_2(f_i_plus_one_of_z); // in23
    circuit_inputs = circuit_inputs.next_2(z); // in24
    circuit_inputs = circuit_inputs.next_2(c1); // in25

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let Q0: G2Point = G2Point {
        x0: outputs.get_output(t61),
        x1: outputs.get_output(t62),
        y0: outputs.get_output(t71),
        y1: outputs.get_output(t72),
    };
    let lhs_i_plus_one: u384 = outputs.get_output(t97);
    return (Q0, lhs_i_plus_one);
}
#[inline(always)]
pub fn run_BLS12_381_MP_CHECK_BIT1_2P_2F_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    G2_line_dbl_0: G2Line<u384>,
    G2_line_add_0: G2Line<u384>,
    yInv_1: u384,
    xNegOverY_1: u384,
    G2_line_dbl_1: G2Line<u384>,
    G2_line_add_1: G2Line<u384>,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one_of_z: u384,
    c_or_cinv_of_z: u384,
    z: u384,
    c1: u384,
) -> (u384,) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13, in14) = (CE::<CI<12>> {}, CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16, in17) = (CE::<CI<15>> {}, CE::<CI<16>> {}, CE::<CI<17>> {});
    let (in18, in19, in20) = (CE::<CI<18>> {}, CE::<CI<19>> {}, CE::<CI<20>> {});
    let (in21, in22, in23) = (CE::<CI<21>> {}, CE::<CI<22>> {}, CE::<CI<23>> {});
    let (in24, in25) = (CE::<CI<24>> {}, CE::<CI<25>> {});
    let t0 = circuit_mul(in24, in24); // compute z^2
    let t1 = circuit_mul(t0, in24); // compute z^3
    let t2 = circuit_mul(t1, t1); // compute z^6
    let t3 = circuit_mul(t2, t0); // compute z^8
    let t4 = circuit_mul(in21, in21); // Square f evaluation in Z, the result of previous bit.
    let t5 = circuit_sub(in4, in5);
    let t6 = circuit_mul(t5, in0); // eval bls line by yInv
    let t7 = circuit_sub(in2, in3);
    let t8 = circuit_mul(t7, in1); // eval blsline by xNegOverY
    let t9 = circuit_mul(in5, in0); // eval bls line by yInv
    let t10 = circuit_mul(in3, in1); // eval bls line by xNegOverY
    let t11 = circuit_sub(in8, in9);
    let t12 = circuit_mul(t11, in0); // eval bls line by yInv
    let t13 = circuit_sub(in6, in7);
    let t14 = circuit_mul(t13, in1); // eval blsline by xNegOverY
    let t15 = circuit_mul(in9, in0); // eval bls line by yInv
    let t16 = circuit_mul(in7, in1); // eval bls line by xNegOverY
    let t17 = circuit_mul(t8, t0); // Eval sparse poly line_0p_1 step coeff_2 * z^2
    let t18 = circuit_add(t6, t17); // Eval sparse poly line_0p_1 step + coeff_2 * z^2
    let t19 = circuit_add(t18, t1); // Eval sparse poly line_0p_1 step + 1*z^3
    let t20 = circuit_mul(t9, t2); // Eval sparse poly line_0p_1 step coeff_6 * z^6
    let t21 = circuit_add(t19, t20); // Eval sparse poly line_0p_1 step + coeff_6 * z^6
    let t22 = circuit_mul(t10, t3); // Eval sparse poly line_0p_1 step coeff_8 * z^8
    let t23 = circuit_add(t21, t22); // Eval sparse poly line_0p_1 step + coeff_8 * z^8
    let t24 = circuit_mul(t4, t23); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t25 = circuit_mul(t14, t0); // Eval sparse poly line_0p_2 step coeff_2 * z^2
    let t26 = circuit_add(t12, t25); // Eval sparse poly line_0p_2 step + coeff_2 * z^2
    let t27 = circuit_add(t26, t1); // Eval sparse poly line_0p_2 step + 1*z^3
    let t28 = circuit_mul(t15, t2); // Eval sparse poly line_0p_2 step coeff_6 * z^6
    let t29 = circuit_add(t27, t28); // Eval sparse poly line_0p_2 step + coeff_6 * z^6
    let t30 = circuit_mul(t16, t3); // Eval sparse poly line_0p_2 step coeff_8 * z^8
    let t31 = circuit_add(t29, t30); // Eval sparse poly line_0p_2 step + coeff_8 * z^8
    let t32 = circuit_mul(t24, t31); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t33 = circuit_sub(in14, in15);
    let t34 = circuit_mul(t33, in10); // eval bls line by yInv
    let t35 = circuit_sub(in12, in13);
    let t36 = circuit_mul(t35, in11); // eval blsline by xNegOverY
    let t37 = circuit_mul(in15, in10); // eval bls line by yInv
    let t38 = circuit_mul(in13, in11); // eval bls line by xNegOverY
    let t39 = circuit_sub(in18, in19);
    let t40 = circuit_mul(t39, in10); // eval bls line by yInv
    let t41 = circuit_sub(in16, in17);
    let t42 = circuit_mul(t41, in11); // eval blsline by xNegOverY
    let t43 = circuit_mul(in19, in10); // eval bls line by yInv
    let t44 = circuit_mul(in17, in11); // eval bls line by xNegOverY
    let t45 = circuit_mul(t36, t0); // Eval sparse poly line_1p_1 step coeff_2 * z^2
    let t46 = circuit_add(t34, t45); // Eval sparse poly line_1p_1 step + coeff_2 * z^2
    let t47 = circuit_add(t46, t1); // Eval sparse poly line_1p_1 step + 1*z^3
    let t48 = circuit_mul(t37, t2); // Eval sparse poly line_1p_1 step coeff_6 * z^6
    let t49 = circuit_add(t47, t48); // Eval sparse poly line_1p_1 step + coeff_6 * z^6
    let t50 = circuit_mul(t38, t3); // Eval sparse poly line_1p_1 step coeff_8 * z^8
    let t51 = circuit_add(t49, t50); // Eval sparse poly line_1p_1 step + coeff_8 * z^8
    let t52 = circuit_mul(t32, t51); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t53 = circuit_mul(t42, t0); // Eval sparse poly line_1p_2 step coeff_2 * z^2
    let t54 = circuit_add(t40, t53); // Eval sparse poly line_1p_2 step + coeff_2 * z^2
    let t55 = circuit_add(t54, t1); // Eval sparse poly line_1p_2 step + 1*z^3
    let t56 = circuit_mul(t43, t2); // Eval sparse poly line_1p_2 step coeff_6 * z^6
    let t57 = circuit_add(t55, t56); // Eval sparse poly line_1p_2 step + coeff_6 * z^6
    let t58 = circuit_mul(t44, t3); // Eval sparse poly line_1p_2 step coeff_8 * z^8
    let t59 = circuit_add(t57, t58); // Eval sparse poly line_1p_2 step + coeff_8 * z^8
    let t60 = circuit_mul(t52, t59); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t61 = circuit_mul(t60, in23);
    let t62 = circuit_sub(t61, in22); // (Π(i,k) (Pk(z))) - Ri(z)
    let t63 = circuit_mul(in25, in20);
    let t64 = circuit_add(t63, t62); // LHS = c1 * LHS + ((Π(i,k) (Pk(z)) - Ri(z))

    let modulus = crate::definitions::get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (t64,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(yInv_0); // in0
    circuit_inputs = circuit_inputs.next_2(xNegOverY_0); // in1
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r0a0); // in2
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r0a1); // in3
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r1a0); // in4
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r1a1); // in5
    circuit_inputs = circuit_inputs.next_2(G2_line_add_0.r0a0); // in6
    circuit_inputs = circuit_inputs.next_2(G2_line_add_0.r0a1); // in7
    circuit_inputs = circuit_inputs.next_2(G2_line_add_0.r1a0); // in8
    circuit_inputs = circuit_inputs.next_2(G2_line_add_0.r1a1); // in9
    circuit_inputs = circuit_inputs.next_2(yInv_1); // in10
    circuit_inputs = circuit_inputs.next_2(xNegOverY_1); // in11
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r0a0); // in12
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r0a1); // in13
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r1a0); // in14
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r1a1); // in15
    circuit_inputs = circuit_inputs.next_2(G2_line_add_1.r0a0); // in16
    circuit_inputs = circuit_inputs.next_2(G2_line_add_1.r0a1); // in17
    circuit_inputs = circuit_inputs.next_2(G2_line_add_1.r1a0); // in18
    circuit_inputs = circuit_inputs.next_2(G2_line_add_1.r1a1); // in19
    circuit_inputs = circuit_inputs.next_2(lhs_i); // in20
    circuit_inputs = circuit_inputs.next_2(f_i_of_z); // in21
    circuit_inputs = circuit_inputs.next_2(f_i_plus_one_of_z); // in22
    circuit_inputs = circuit_inputs.next_2(c_or_cinv_of_z); // in23
    circuit_inputs = circuit_inputs.next_2(z); // in24
    circuit_inputs = circuit_inputs.next_2(c1); // in25

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let lhs_i_plus_one: u384 = outputs.get_output(t64);
    return (lhs_i_plus_one,);
}
#[inline(always)]
pub fn run_BLS12_381_MP_CHECK_BIT1_3P_2F_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    G2_line_dbl_0: G2Line<u384>,
    G2_line_add_0: G2Line<u384>,
    yInv_1: u384,
    xNegOverY_1: u384,
    G2_line_dbl_1: G2Line<u384>,
    G2_line_add_1: G2Line<u384>,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q_2: G2Point,
    Q_or_Q_neg_2: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one_of_z: u384,
    c_or_cinv_of_z: u384,
    z: u384,
    c1: u384,
) -> (G2Point, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0

    // INPUT stack
    let (in1, in2, in3) = (CE::<CI<1>> {}, CE::<CI<2>> {}, CE::<CI<3>> {});
    let (in4, in5, in6) = (CE::<CI<4>> {}, CE::<CI<5>> {}, CE::<CI<6>> {});
    let (in7, in8, in9) = (CE::<CI<7>> {}, CE::<CI<8>> {}, CE::<CI<9>> {});
    let (in10, in11, in12) = (CE::<CI<10>> {}, CE::<CI<11>> {}, CE::<CI<12>> {});
    let (in13, in14, in15) = (CE::<CI<13>> {}, CE::<CI<14>> {}, CE::<CI<15>> {});
    let (in16, in17, in18) = (CE::<CI<16>> {}, CE::<CI<17>> {}, CE::<CI<18>> {});
    let (in19, in20, in21) = (CE::<CI<19>> {}, CE::<CI<20>> {}, CE::<CI<21>> {});
    let (in22, in23, in24) = (CE::<CI<22>> {}, CE::<CI<23>> {}, CE::<CI<24>> {});
    let (in25, in26, in27) = (CE::<CI<25>> {}, CE::<CI<26>> {}, CE::<CI<27>> {});
    let (in28, in29, in30) = (CE::<CI<28>> {}, CE::<CI<29>> {}, CE::<CI<30>> {});
    let (in31, in32, in33) = (CE::<CI<31>> {}, CE::<CI<32>> {}, CE::<CI<33>> {});
    let (in34, in35, in36) = (CE::<CI<34>> {}, CE::<CI<35>> {}, CE::<CI<36>> {});
    let t0 = circuit_mul(in35, in35); // compute z^2
    let t1 = circuit_mul(t0, in35); // compute z^3
    let t2 = circuit_mul(t1, t1); // compute z^6
    let t3 = circuit_mul(t2, t0); // compute z^8
    let t4 = circuit_mul(in32, in32); // Square f evaluation in Z, the result of previous bit.
    let t5 = circuit_sub(in5, in6);
    let t6 = circuit_mul(t5, in1); // eval bls line by yInv
    let t7 = circuit_sub(in3, in4);
    let t8 = circuit_mul(t7, in2); // eval blsline by xNegOverY
    let t9 = circuit_mul(in6, in1); // eval bls line by yInv
    let t10 = circuit_mul(in4, in2); // eval bls line by xNegOverY
    let t11 = circuit_sub(in9, in10);
    let t12 = circuit_mul(t11, in1); // eval bls line by yInv
    let t13 = circuit_sub(in7, in8);
    let t14 = circuit_mul(t13, in2); // eval blsline by xNegOverY
    let t15 = circuit_mul(in10, in1); // eval bls line by yInv
    let t16 = circuit_mul(in8, in2); // eval bls line by xNegOverY
    let t17 = circuit_mul(t8, t0); // Eval sparse poly line_0p_1 step coeff_2 * z^2
    let t18 = circuit_add(t6, t17); // Eval sparse poly line_0p_1 step + coeff_2 * z^2
    let t19 = circuit_add(t18, t1); // Eval sparse poly line_0p_1 step + 1*z^3
    let t20 = circuit_mul(t9, t2); // Eval sparse poly line_0p_1 step coeff_6 * z^6
    let t21 = circuit_add(t19, t20); // Eval sparse poly line_0p_1 step + coeff_6 * z^6
    let t22 = circuit_mul(t10, t3); // Eval sparse poly line_0p_1 step coeff_8 * z^8
    let t23 = circuit_add(t21, t22); // Eval sparse poly line_0p_1 step + coeff_8 * z^8
    let t24 = circuit_mul(t4, t23); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t25 = circuit_mul(t14, t0); // Eval sparse poly line_0p_2 step coeff_2 * z^2
    let t26 = circuit_add(t12, t25); // Eval sparse poly line_0p_2 step + coeff_2 * z^2
    let t27 = circuit_add(t26, t1); // Eval sparse poly line_0p_2 step + 1*z^3
    let t28 = circuit_mul(t15, t2); // Eval sparse poly line_0p_2 step coeff_6 * z^6
    let t29 = circuit_add(t27, t28); // Eval sparse poly line_0p_2 step + coeff_6 * z^6
    let t30 = circuit_mul(t16, t3); // Eval sparse poly line_0p_2 step coeff_8 * z^8
    let t31 = circuit_add(t29, t30); // Eval sparse poly line_0p_2 step + coeff_8 * z^8
    let t32 = circuit_mul(t24, t31); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t33 = circuit_sub(in15, in16);
    let t34 = circuit_mul(t33, in11); // eval bls line by yInv
    let t35 = circuit_sub(in13, in14);
    let t36 = circuit_mul(t35, in12); // eval blsline by xNegOverY
    let t37 = circuit_mul(in16, in11); // eval bls line by yInv
    let t38 = circuit_mul(in14, in12); // eval bls line by xNegOverY
    let t39 = circuit_sub(in19, in20);
    let t40 = circuit_mul(t39, in11); // eval bls line by yInv
    let t41 = circuit_sub(in17, in18);
    let t42 = circuit_mul(t41, in12); // eval blsline by xNegOverY
    let t43 = circuit_mul(in20, in11); // eval bls line by yInv
    let t44 = circuit_mul(in18, in12); // eval bls line by xNegOverY
    let t45 = circuit_mul(t36, t0); // Eval sparse poly line_1p_1 step coeff_2 * z^2
    let t46 = circuit_add(t34, t45); // Eval sparse poly line_1p_1 step + coeff_2 * z^2
    let t47 = circuit_add(t46, t1); // Eval sparse poly line_1p_1 step + 1*z^3
    let t48 = circuit_mul(t37, t2); // Eval sparse poly line_1p_1 step coeff_6 * z^6
    let t49 = circuit_add(t47, t48); // Eval sparse poly line_1p_1 step + coeff_6 * z^6
    let t50 = circuit_mul(t38, t3); // Eval sparse poly line_1p_1 step coeff_8 * z^8
    let t51 = circuit_add(t49, t50); // Eval sparse poly line_1p_1 step + coeff_8 * z^8
    let t52 = circuit_mul(t32, t51); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t53 = circuit_mul(t42, t0); // Eval sparse poly line_1p_2 step coeff_2 * z^2
    let t54 = circuit_add(t40, t53); // Eval sparse poly line_1p_2 step + coeff_2 * z^2
    let t55 = circuit_add(t54, t1); // Eval sparse poly line_1p_2 step + 1*z^3
    let t56 = circuit_mul(t43, t2); // Eval sparse poly line_1p_2 step coeff_6 * z^6
    let t57 = circuit_add(t55, t56); // Eval sparse poly line_1p_2 step + coeff_6 * z^6
    let t58 = circuit_mul(t44, t3); // Eval sparse poly line_1p_2 step coeff_8 * z^8
    let t59 = circuit_add(t57, t58); // Eval sparse poly line_1p_2 step + coeff_8 * z^8
    let t60 = circuit_mul(t52, t59); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t61 = circuit_sub(in25, in29); // Fp2 sub coeff 0/1
    let t62 = circuit_sub(in26, in30); // Fp2 sub coeff 1/1
    let t63 = circuit_sub(in23, in27); // Fp2 sub coeff 0/1
    let t64 = circuit_sub(in24, in28); // Fp2 sub coeff 1/1
    let t65 = circuit_mul(t63, t63); // Fp2 Inv start
    let t66 = circuit_mul(t64, t64);
    let t67 = circuit_add(t65, t66);
    let t68 = circuit_inverse(t67);
    let t69 = circuit_mul(t63, t68); // Fp2 Inv real part end
    let t70 = circuit_mul(t64, t68);
    let t71 = circuit_sub(in0, t70); // Fp2 Inv imag part end
    let t72 = circuit_mul(t61, t69); // Fp2 mul start
    let t73 = circuit_mul(t62, t71);
    let t74 = circuit_sub(t72, t73); // Fp2 mul real part end
    let t75 = circuit_mul(t61, t71);
    let t76 = circuit_mul(t62, t69);
    let t77 = circuit_add(t75, t76); // Fp2 mul imag part end
    let t78 = circuit_add(t74, t77);
    let t79 = circuit_sub(t74, t77);
    let t80 = circuit_mul(t78, t79);
    let t81 = circuit_mul(t74, t77);
    let t82 = circuit_add(t81, t81);
    let t83 = circuit_add(in23, in27); // Fp2 add coeff 0/1
    let t84 = circuit_add(in24, in28); // Fp2 add coeff 1/1
    let t85 = circuit_sub(t80, t83); // Fp2 sub coeff 0/1
    let t86 = circuit_sub(t82, t84); // Fp2 sub coeff 1/1
    let t87 = circuit_mul(t74, in23); // Fp2 mul start
    let t88 = circuit_mul(t77, in24);
    let t89 = circuit_sub(t87, t88); // Fp2 mul real part end
    let t90 = circuit_mul(t74, in24);
    let t91 = circuit_mul(t77, in23);
    let t92 = circuit_add(t90, t91); // Fp2 mul imag part end
    let t93 = circuit_sub(t89, in25); // Fp2 sub coeff 0/1
    let t94 = circuit_sub(t92, in26); // Fp2 sub coeff 1/1
    let t95 = circuit_add(in25, in25); // Fp2 add coeff 0/1
    let t96 = circuit_add(in26, in26); // Fp2 add coeff 1/1
    let t97 = circuit_sub(t85, in23); // Fp2 sub coeff 0/1
    let t98 = circuit_sub(t86, in24); // Fp2 sub coeff 1/1
    let t99 = circuit_mul(t97, t97); // Fp2 Inv start
    let t100 = circuit_mul(t98, t98);
    let t101 = circuit_add(t99, t100);
    let t102 = circuit_inverse(t101);
    let t103 = circuit_mul(t97, t102); // Fp2 Inv real part end
    let t104 = circuit_mul(t98, t102);
    let t105 = circuit_sub(in0, t104); // Fp2 Inv imag part end
    let t106 = circuit_mul(t95, t103); // Fp2 mul start
    let t107 = circuit_mul(t96, t105);
    let t108 = circuit_sub(t106, t107); // Fp2 mul real part end
    let t109 = circuit_mul(t95, t105);
    let t110 = circuit_mul(t96, t103);
    let t111 = circuit_add(t109, t110); // Fp2 mul imag part end
    let t112 = circuit_add(t74, t108); // Fp2 add coeff 0/1
    let t113 = circuit_add(t77, t111); // Fp2 add coeff 1/1
    let t114 = circuit_sub(in0, t112); // Fp2 neg coeff 0/1
    let t115 = circuit_sub(in0, t113); // Fp2 neg coeff 1/1
    let t116 = circuit_add(t114, t115);
    let t117 = circuit_sub(t114, t115);
    let t118 = circuit_mul(t116, t117);
    let t119 = circuit_mul(t114, t115);
    let t120 = circuit_add(t119, t119);
    let t121 = circuit_sub(t118, in23); // Fp2 sub coeff 0/1
    let t122 = circuit_sub(t120, in24); // Fp2 sub coeff 1/1
    let t123 = circuit_sub(t121, t85); // Fp2 sub coeff 0/1
    let t124 = circuit_sub(t122, t86); // Fp2 sub coeff 1/1
    let t125 = circuit_sub(in23, t123); // Fp2 sub coeff 0/1
    let t126 = circuit_sub(in24, t124); // Fp2 sub coeff 1/1
    let t127 = circuit_mul(t114, t125); // Fp2 mul start
    let t128 = circuit_mul(t115, t126);
    let t129 = circuit_sub(t127, t128); // Fp2 mul real part end
    let t130 = circuit_mul(t114, t126);
    let t131 = circuit_mul(t115, t125);
    let t132 = circuit_add(t130, t131); // Fp2 mul imag part end
    let t133 = circuit_sub(t129, in25); // Fp2 sub coeff 0/1
    let t134 = circuit_sub(t132, in26); // Fp2 sub coeff 1/1
    let t135 = circuit_mul(t114, in23); // Fp2 mul start
    let t136 = circuit_mul(t115, in24);
    let t137 = circuit_sub(t135, t136); // Fp2 mul real part end
    let t138 = circuit_mul(t114, in24);
    let t139 = circuit_mul(t115, in23);
    let t140 = circuit_add(t138, t139); // Fp2 mul imag part end
    let t141 = circuit_sub(t137, in25); // Fp2 sub coeff 0/1
    let t142 = circuit_sub(t140, in26); // Fp2 sub coeff 1/1
    let t143 = circuit_sub(t93, t94);
    let t144 = circuit_mul(t143, in21); // eval bls line by yInv
    let t145 = circuit_sub(t74, t77);
    let t146 = circuit_mul(t145, in22); // eval blsline by xNegOverY
    let t147 = circuit_mul(t94, in21); // eval bls line by yInv
    let t148 = circuit_mul(t77, in22); // eval bls line by xNegOverY
    let t149 = circuit_sub(t141, t142);
    let t150 = circuit_mul(t149, in21); // eval bls line by yInv
    let t151 = circuit_sub(t114, t115);
    let t152 = circuit_mul(t151, in22); // eval blsline by xNegOverY
    let t153 = circuit_mul(t142, in21); // eval bls line by yInv
    let t154 = circuit_mul(t115, in22); // eval bls line by xNegOverY
    let t155 = circuit_mul(t146, t0); // Eval sparse poly line_2p_1 step coeff_2 * z^2
    let t156 = circuit_add(t144, t155); // Eval sparse poly line_2p_1 step + coeff_2 * z^2
    let t157 = circuit_add(t156, t1); // Eval sparse poly line_2p_1 step + 1*z^3
    let t158 = circuit_mul(t147, t2); // Eval sparse poly line_2p_1 step coeff_6 * z^6
    let t159 = circuit_add(t157, t158); // Eval sparse poly line_2p_1 step + coeff_6 * z^6
    let t160 = circuit_mul(t148, t3); // Eval sparse poly line_2p_1 step coeff_8 * z^8
    let t161 = circuit_add(t159, t160); // Eval sparse poly line_2p_1 step + coeff_8 * z^8
    let t162 = circuit_mul(t60, t161); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t163 = circuit_mul(t152, t0); // Eval sparse poly line_2p_2 step coeff_2 * z^2
    let t164 = circuit_add(t150, t163); // Eval sparse poly line_2p_2 step + coeff_2 * z^2
    let t165 = circuit_add(t164, t1); // Eval sparse poly line_2p_2 step + 1*z^3
    let t166 = circuit_mul(t153, t2); // Eval sparse poly line_2p_2 step coeff_6 * z^6
    let t167 = circuit_add(t165, t166); // Eval sparse poly line_2p_2 step + coeff_6 * z^6
    let t168 = circuit_mul(t154, t3); // Eval sparse poly line_2p_2 step coeff_8 * z^8
    let t169 = circuit_add(t167, t168); // Eval sparse poly line_2p_2 step + coeff_8 * z^8
    let t170 = circuit_mul(t162, t169); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t171 = circuit_mul(t170, in34);
    let t172 = circuit_sub(t171, in33); // (Π(i,k) (Pk(z))) - Ri(z)
    let t173 = circuit_mul(in36, in31);
    let t174 = circuit_add(t173, t172); // LHS = c1 * LHS + ((Π(i,k) (Pk(z)) - Ri(z))

    let modulus = crate::definitions::get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (t123, t124, t133, t134, t174).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in0
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(yInv_0); // in1
    circuit_inputs = circuit_inputs.next_2(xNegOverY_0); // in2
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r0a0); // in3
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r0a1); // in4
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r1a0); // in5
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r1a1); // in6
    circuit_inputs = circuit_inputs.next_2(G2_line_add_0.r0a0); // in7
    circuit_inputs = circuit_inputs.next_2(G2_line_add_0.r0a1); // in8
    circuit_inputs = circuit_inputs.next_2(G2_line_add_0.r1a0); // in9
    circuit_inputs = circuit_inputs.next_2(G2_line_add_0.r1a1); // in10
    circuit_inputs = circuit_inputs.next_2(yInv_1); // in11
    circuit_inputs = circuit_inputs.next_2(xNegOverY_1); // in12
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r0a0); // in13
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r0a1); // in14
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r1a0); // in15
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r1a1); // in16
    circuit_inputs = circuit_inputs.next_2(G2_line_add_1.r0a0); // in17
    circuit_inputs = circuit_inputs.next_2(G2_line_add_1.r0a1); // in18
    circuit_inputs = circuit_inputs.next_2(G2_line_add_1.r1a0); // in19
    circuit_inputs = circuit_inputs.next_2(G2_line_add_1.r1a1); // in20
    circuit_inputs = circuit_inputs.next_2(yInv_2); // in21
    circuit_inputs = circuit_inputs.next_2(xNegOverY_2); // in22
    circuit_inputs = circuit_inputs.next_2(Q_2.x0); // in23
    circuit_inputs = circuit_inputs.next_2(Q_2.x1); // in24
    circuit_inputs = circuit_inputs.next_2(Q_2.y0); // in25
    circuit_inputs = circuit_inputs.next_2(Q_2.y1); // in26
    circuit_inputs = circuit_inputs.next_2(Q_or_Q_neg_2.x0); // in27
    circuit_inputs = circuit_inputs.next_2(Q_or_Q_neg_2.x1); // in28
    circuit_inputs = circuit_inputs.next_2(Q_or_Q_neg_2.y0); // in29
    circuit_inputs = circuit_inputs.next_2(Q_or_Q_neg_2.y1); // in30
    circuit_inputs = circuit_inputs.next_2(lhs_i); // in31
    circuit_inputs = circuit_inputs.next_2(f_i_of_z); // in32
    circuit_inputs = circuit_inputs.next_2(f_i_plus_one_of_z); // in33
    circuit_inputs = circuit_inputs.next_2(c_or_cinv_of_z); // in34
    circuit_inputs = circuit_inputs.next_2(z); // in35
    circuit_inputs = circuit_inputs.next_2(c1); // in36

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let Q0: G2Point = G2Point {
        x0: outputs.get_output(t123),
        x1: outputs.get_output(t124),
        y0: outputs.get_output(t133),
        y1: outputs.get_output(t134),
    };
    let lhs_i_plus_one: u384 = outputs.get_output(t174);
    return (Q0, lhs_i_plus_one);
}
#[inline(always)]
pub fn run_BLS12_381_MP_CHECK_FINALIZE_2P_circuit(
    R_n_minus_1_of_z: u384,
    c_1: u384,
    w_of_z: u384,
    z: u384,
    c_inv_frob_1_of_z: u384,
    previous_lhs: u384,
    R_n_minus_2: E12D<u384>,
    Q: Array<u384>,
) -> (u384,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0
    let in1 = CE::<CI<1>> {}; // 0x2
    let in2 = CE::<CI<2>> {}; // -0x2 % p

    // INPUT stack
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13, in14) = (CE::<CI<12>> {}, CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16, in17) = (CE::<CI<15>> {}, CE::<CI<16>> {}, CE::<CI<17>> {});
    let (in18, in19, in20) = (CE::<CI<18>> {}, CE::<CI<19>> {}, CE::<CI<20>> {});
    let (in21, in22, in23) = (CE::<CI<21>> {}, CE::<CI<22>> {}, CE::<CI<23>> {});
    let (in24, in25, in26) = (CE::<CI<24>> {}, CE::<CI<25>> {}, CE::<CI<26>> {});
    let (in27, in28, in29) = (CE::<CI<27>> {}, CE::<CI<28>> {}, CE::<CI<29>> {});
    let (in30, in31, in32) = (CE::<CI<30>> {}, CE::<CI<31>> {}, CE::<CI<32>> {});
    let (in33, in34, in35) = (CE::<CI<33>> {}, CE::<CI<34>> {}, CE::<CI<35>> {});
    let (in36, in37, in38) = (CE::<CI<36>> {}, CE::<CI<37>> {}, CE::<CI<38>> {});
    let (in39, in40, in41) = (CE::<CI<39>> {}, CE::<CI<40>> {}, CE::<CI<41>> {});
    let (in42, in43, in44) = (CE::<CI<42>> {}, CE::<CI<43>> {}, CE::<CI<44>> {});
    let (in45, in46, in47) = (CE::<CI<45>> {}, CE::<CI<46>> {}, CE::<CI<47>> {});
    let (in48, in49, in50) = (CE::<CI<48>> {}, CE::<CI<49>> {}, CE::<CI<50>> {});
    let (in51, in52, in53) = (CE::<CI<51>> {}, CE::<CI<52>> {}, CE::<CI<53>> {});
    let (in54, in55, in56) = (CE::<CI<54>> {}, CE::<CI<55>> {}, CE::<CI<56>> {});
    let (in57, in58, in59) = (CE::<CI<57>> {}, CE::<CI<58>> {}, CE::<CI<59>> {});
    let (in60, in61, in62) = (CE::<CI<60>> {}, CE::<CI<61>> {}, CE::<CI<62>> {});
    let (in63, in64, in65) = (CE::<CI<63>> {}, CE::<CI<64>> {}, CE::<CI<65>> {});
    let (in66, in67, in68) = (CE::<CI<66>> {}, CE::<CI<67>> {}, CE::<CI<68>> {});
    let (in69, in70, in71) = (CE::<CI<69>> {}, CE::<CI<70>> {}, CE::<CI<71>> {});
    let (in72, in73, in74) = (CE::<CI<72>> {}, CE::<CI<73>> {}, CE::<CI<74>> {});
    let (in75, in76, in77) = (CE::<CI<75>> {}, CE::<CI<76>> {}, CE::<CI<77>> {});
    let (in78, in79, in80) = (CE::<CI<78>> {}, CE::<CI<79>> {}, CE::<CI<80>> {});
    let (in81, in82, in83) = (CE::<CI<81>> {}, CE::<CI<82>> {}, CE::<CI<83>> {});
    let (in84, in85, in86) = (CE::<CI<84>> {}, CE::<CI<85>> {}, CE::<CI<86>> {});
    let (in87, in88, in89) = (CE::<CI<87>> {}, CE::<CI<88>> {}, CE::<CI<89>> {});
    let (in90, in91, in92) = (CE::<CI<90>> {}, CE::<CI<91>> {}, CE::<CI<92>> {});
    let (in93, in94, in95) = (CE::<CI<93>> {}, CE::<CI<94>> {}, CE::<CI<95>> {});
    let (in96, in97, in98) = (CE::<CI<96>> {}, CE::<CI<97>> {}, CE::<CI<98>> {});
    let (in99, in100, in101) = (CE::<CI<99>> {}, CE::<CI<100>> {}, CE::<CI<101>> {});
    let t0 = circuit_mul(in6, in6); // Compute z^2
    let t1 = circuit_mul(t0, in6); // Compute z^3
    let t2 = circuit_mul(t1, in6); // Compute z^4
    let t3 = circuit_mul(t2, in6); // Compute z^5
    let t4 = circuit_mul(t3, in6); // Compute z^6
    let t5 = circuit_mul(t4, in6); // Compute z^7
    let t6 = circuit_mul(t5, in6); // Compute z^8
    let t7 = circuit_mul(t6, in6); // Compute z^9
    let t8 = circuit_mul(t7, in6); // Compute z^10
    let t9 = circuit_mul(t8, in6); // Compute z^11
    let t10 = circuit_mul(t9, in6); // Compute z^12
    let t11 = circuit_sub(in0, in10);
    let t12 = circuit_sub(in0, in12);
    let t13 = circuit_sub(in0, in14);
    let t14 = circuit_sub(in0, in16);
    let t15 = circuit_sub(in0, in18);
    let t16 = circuit_sub(in0, in20);
    let t17 = circuit_mul(t11, in6); // Eval R_n_minus_2_conjugate step coeff_1 * z^1
    let t18 = circuit_add(in9, t17); // Eval R_n_minus_2_conjugate step + (coeff_1 * z^1)
    let t19 = circuit_mul(in11, t0); // Eval R_n_minus_2_conjugate step coeff_2 * z^2
    let t20 = circuit_add(t18, t19); // Eval R_n_minus_2_conjugate step + (coeff_2 * z^2)
    let t21 = circuit_mul(t12, t1); // Eval R_n_minus_2_conjugate step coeff_3 * z^3
    let t22 = circuit_add(t20, t21); // Eval R_n_minus_2_conjugate step + (coeff_3 * z^3)
    let t23 = circuit_mul(in13, t2); // Eval R_n_minus_2_conjugate step coeff_4 * z^4
    let t24 = circuit_add(t22, t23); // Eval R_n_minus_2_conjugate step + (coeff_4 * z^4)
    let t25 = circuit_mul(t13, t3); // Eval R_n_minus_2_conjugate step coeff_5 * z^5
    let t26 = circuit_add(t24, t25); // Eval R_n_minus_2_conjugate step + (coeff_5 * z^5)
    let t27 = circuit_mul(in15, t4); // Eval R_n_minus_2_conjugate step coeff_6 * z^6
    let t28 = circuit_add(t26, t27); // Eval R_n_minus_2_conjugate step + (coeff_6 * z^6)
    let t29 = circuit_mul(t14, t5); // Eval R_n_minus_2_conjugate step coeff_7 * z^7
    let t30 = circuit_add(t28, t29); // Eval R_n_minus_2_conjugate step + (coeff_7 * z^7)
    let t31 = circuit_mul(in17, t6); // Eval R_n_minus_2_conjugate step coeff_8 * z^8
    let t32 = circuit_add(t30, t31); // Eval R_n_minus_2_conjugate step + (coeff_8 * z^8)
    let t33 = circuit_mul(t15, t7); // Eval R_n_minus_2_conjugate step coeff_9 * z^9
    let t34 = circuit_add(t32, t33); // Eval R_n_minus_2_conjugate step + (coeff_9 * z^9)
    let t35 = circuit_mul(in19, t8); // Eval R_n_minus_2_conjugate step coeff_10 * z^10
    let t36 = circuit_add(t34, t35); // Eval R_n_minus_2_conjugate step + (coeff_10 * z^10)
    let t37 = circuit_mul(t16, t9); // Eval R_n_minus_2_conjugate step coeff_11 * z^11
    let t38 = circuit_add(t36, t37); // Eval R_n_minus_2_conjugate step + (coeff_11 * z^11)
    let t39 = circuit_mul(t38, in7);
    let t40 = circuit_mul(t39, in5);
    let t41 = circuit_sub(t40, in3); // (Π(n-1,k) (Pk(z)) - R_n_minus_1(z))
    let t42 = circuit_mul(in4, in8);
    let t43 = circuit_add(t42, t41); // c_1 * previous_lhs + lhs_n_minus_1
    let t44 = circuit_mul(in2, t4); // Eval sparse poly P_irr step coeff_6 * z^6
    let t45 = circuit_add(in1, t44); // Eval sparse poly P_irr step + coeff_6 * z^6
    let t46 = circuit_add(t45, t10); // Eval sparse poly P_irr step + 1*z^12
    let t47 = circuit_mul(in101, in6); // Eval big_Q Horner step: multiply by z
    let t48 = circuit_add(in100, t47); // Eval big_Q Horner step: add coefficient_79
    let t49 = circuit_mul(t48, in6); // Eval big_Q Horner step: multiply by z
    let t50 = circuit_add(in99, t49); // Eval big_Q Horner step: add coefficient_78
    let t51 = circuit_mul(t50, in6); // Eval big_Q Horner step: multiply by z
    let t52 = circuit_add(in98, t51); // Eval big_Q Horner step: add coefficient_77
    let t53 = circuit_mul(t52, in6); // Eval big_Q Horner step: multiply by z
    let t54 = circuit_add(in97, t53); // Eval big_Q Horner step: add coefficient_76
    let t55 = circuit_mul(t54, in6); // Eval big_Q Horner step: multiply by z
    let t56 = circuit_add(in96, t55); // Eval big_Q Horner step: add coefficient_75
    let t57 = circuit_mul(t56, in6); // Eval big_Q Horner step: multiply by z
    let t58 = circuit_add(in95, t57); // Eval big_Q Horner step: add coefficient_74
    let t59 = circuit_mul(t58, in6); // Eval big_Q Horner step: multiply by z
    let t60 = circuit_add(in94, t59); // Eval big_Q Horner step: add coefficient_73
    let t61 = circuit_mul(t60, in6); // Eval big_Q Horner step: multiply by z
    let t62 = circuit_add(in93, t61); // Eval big_Q Horner step: add coefficient_72
    let t63 = circuit_mul(t62, in6); // Eval big_Q Horner step: multiply by z
    let t64 = circuit_add(in92, t63); // Eval big_Q Horner step: add coefficient_71
    let t65 = circuit_mul(t64, in6); // Eval big_Q Horner step: multiply by z
    let t66 = circuit_add(in91, t65); // Eval big_Q Horner step: add coefficient_70
    let t67 = circuit_mul(t66, in6); // Eval big_Q Horner step: multiply by z
    let t68 = circuit_add(in90, t67); // Eval big_Q Horner step: add coefficient_69
    let t69 = circuit_mul(t68, in6); // Eval big_Q Horner step: multiply by z
    let t70 = circuit_add(in89, t69); // Eval big_Q Horner step: add coefficient_68
    let t71 = circuit_mul(t70, in6); // Eval big_Q Horner step: multiply by z
    let t72 = circuit_add(in88, t71); // Eval big_Q Horner step: add coefficient_67
    let t73 = circuit_mul(t72, in6); // Eval big_Q Horner step: multiply by z
    let t74 = circuit_add(in87, t73); // Eval big_Q Horner step: add coefficient_66
    let t75 = circuit_mul(t74, in6); // Eval big_Q Horner step: multiply by z
    let t76 = circuit_add(in86, t75); // Eval big_Q Horner step: add coefficient_65
    let t77 = circuit_mul(t76, in6); // Eval big_Q Horner step: multiply by z
    let t78 = circuit_add(in85, t77); // Eval big_Q Horner step: add coefficient_64
    let t79 = circuit_mul(t78, in6); // Eval big_Q Horner step: multiply by z
    let t80 = circuit_add(in84, t79); // Eval big_Q Horner step: add coefficient_63
    let t81 = circuit_mul(t80, in6); // Eval big_Q Horner step: multiply by z
    let t82 = circuit_add(in83, t81); // Eval big_Q Horner step: add coefficient_62
    let t83 = circuit_mul(t82, in6); // Eval big_Q Horner step: multiply by z
    let t84 = circuit_add(in82, t83); // Eval big_Q Horner step: add coefficient_61
    let t85 = circuit_mul(t84, in6); // Eval big_Q Horner step: multiply by z
    let t86 = circuit_add(in81, t85); // Eval big_Q Horner step: add coefficient_60
    let t87 = circuit_mul(t86, in6); // Eval big_Q Horner step: multiply by z
    let t88 = circuit_add(in80, t87); // Eval big_Q Horner step: add coefficient_59
    let t89 = circuit_mul(t88, in6); // Eval big_Q Horner step: multiply by z
    let t90 = circuit_add(in79, t89); // Eval big_Q Horner step: add coefficient_58
    let t91 = circuit_mul(t90, in6); // Eval big_Q Horner step: multiply by z
    let t92 = circuit_add(in78, t91); // Eval big_Q Horner step: add coefficient_57
    let t93 = circuit_mul(t92, in6); // Eval big_Q Horner step: multiply by z
    let t94 = circuit_add(in77, t93); // Eval big_Q Horner step: add coefficient_56
    let t95 = circuit_mul(t94, in6); // Eval big_Q Horner step: multiply by z
    let t96 = circuit_add(in76, t95); // Eval big_Q Horner step: add coefficient_55
    let t97 = circuit_mul(t96, in6); // Eval big_Q Horner step: multiply by z
    let t98 = circuit_add(in75, t97); // Eval big_Q Horner step: add coefficient_54
    let t99 = circuit_mul(t98, in6); // Eval big_Q Horner step: multiply by z
    let t100 = circuit_add(in74, t99); // Eval big_Q Horner step: add coefficient_53
    let t101 = circuit_mul(t100, in6); // Eval big_Q Horner step: multiply by z
    let t102 = circuit_add(in73, t101); // Eval big_Q Horner step: add coefficient_52
    let t103 = circuit_mul(t102, in6); // Eval big_Q Horner step: multiply by z
    let t104 = circuit_add(in72, t103); // Eval big_Q Horner step: add coefficient_51
    let t105 = circuit_mul(t104, in6); // Eval big_Q Horner step: multiply by z
    let t106 = circuit_add(in71, t105); // Eval big_Q Horner step: add coefficient_50
    let t107 = circuit_mul(t106, in6); // Eval big_Q Horner step: multiply by z
    let t108 = circuit_add(in70, t107); // Eval big_Q Horner step: add coefficient_49
    let t109 = circuit_mul(t108, in6); // Eval big_Q Horner step: multiply by z
    let t110 = circuit_add(in69, t109); // Eval big_Q Horner step: add coefficient_48
    let t111 = circuit_mul(t110, in6); // Eval big_Q Horner step: multiply by z
    let t112 = circuit_add(in68, t111); // Eval big_Q Horner step: add coefficient_47
    let t113 = circuit_mul(t112, in6); // Eval big_Q Horner step: multiply by z
    let t114 = circuit_add(in67, t113); // Eval big_Q Horner step: add coefficient_46
    let t115 = circuit_mul(t114, in6); // Eval big_Q Horner step: multiply by z
    let t116 = circuit_add(in66, t115); // Eval big_Q Horner step: add coefficient_45
    let t117 = circuit_mul(t116, in6); // Eval big_Q Horner step: multiply by z
    let t118 = circuit_add(in65, t117); // Eval big_Q Horner step: add coefficient_44
    let t119 = circuit_mul(t118, in6); // Eval big_Q Horner step: multiply by z
    let t120 = circuit_add(in64, t119); // Eval big_Q Horner step: add coefficient_43
    let t121 = circuit_mul(t120, in6); // Eval big_Q Horner step: multiply by z
    let t122 = circuit_add(in63, t121); // Eval big_Q Horner step: add coefficient_42
    let t123 = circuit_mul(t122, in6); // Eval big_Q Horner step: multiply by z
    let t124 = circuit_add(in62, t123); // Eval big_Q Horner step: add coefficient_41
    let t125 = circuit_mul(t124, in6); // Eval big_Q Horner step: multiply by z
    let t126 = circuit_add(in61, t125); // Eval big_Q Horner step: add coefficient_40
    let t127 = circuit_mul(t126, in6); // Eval big_Q Horner step: multiply by z
    let t128 = circuit_add(in60, t127); // Eval big_Q Horner step: add coefficient_39
    let t129 = circuit_mul(t128, in6); // Eval big_Q Horner step: multiply by z
    let t130 = circuit_add(in59, t129); // Eval big_Q Horner step: add coefficient_38
    let t131 = circuit_mul(t130, in6); // Eval big_Q Horner step: multiply by z
    let t132 = circuit_add(in58, t131); // Eval big_Q Horner step: add coefficient_37
    let t133 = circuit_mul(t132, in6); // Eval big_Q Horner step: multiply by z
    let t134 = circuit_add(in57, t133); // Eval big_Q Horner step: add coefficient_36
    let t135 = circuit_mul(t134, in6); // Eval big_Q Horner step: multiply by z
    let t136 = circuit_add(in56, t135); // Eval big_Q Horner step: add coefficient_35
    let t137 = circuit_mul(t136, in6); // Eval big_Q Horner step: multiply by z
    let t138 = circuit_add(in55, t137); // Eval big_Q Horner step: add coefficient_34
    let t139 = circuit_mul(t138, in6); // Eval big_Q Horner step: multiply by z
    let t140 = circuit_add(in54, t139); // Eval big_Q Horner step: add coefficient_33
    let t141 = circuit_mul(t140, in6); // Eval big_Q Horner step: multiply by z
    let t142 = circuit_add(in53, t141); // Eval big_Q Horner step: add coefficient_32
    let t143 = circuit_mul(t142, in6); // Eval big_Q Horner step: multiply by z
    let t144 = circuit_add(in52, t143); // Eval big_Q Horner step: add coefficient_31
    let t145 = circuit_mul(t144, in6); // Eval big_Q Horner step: multiply by z
    let t146 = circuit_add(in51, t145); // Eval big_Q Horner step: add coefficient_30
    let t147 = circuit_mul(t146, in6); // Eval big_Q Horner step: multiply by z
    let t148 = circuit_add(in50, t147); // Eval big_Q Horner step: add coefficient_29
    let t149 = circuit_mul(t148, in6); // Eval big_Q Horner step: multiply by z
    let t150 = circuit_add(in49, t149); // Eval big_Q Horner step: add coefficient_28
    let t151 = circuit_mul(t150, in6); // Eval big_Q Horner step: multiply by z
    let t152 = circuit_add(in48, t151); // Eval big_Q Horner step: add coefficient_27
    let t153 = circuit_mul(t152, in6); // Eval big_Q Horner step: multiply by z
    let t154 = circuit_add(in47, t153); // Eval big_Q Horner step: add coefficient_26
    let t155 = circuit_mul(t154, in6); // Eval big_Q Horner step: multiply by z
    let t156 = circuit_add(in46, t155); // Eval big_Q Horner step: add coefficient_25
    let t157 = circuit_mul(t156, in6); // Eval big_Q Horner step: multiply by z
    let t158 = circuit_add(in45, t157); // Eval big_Q Horner step: add coefficient_24
    let t159 = circuit_mul(t158, in6); // Eval big_Q Horner step: multiply by z
    let t160 = circuit_add(in44, t159); // Eval big_Q Horner step: add coefficient_23
    let t161 = circuit_mul(t160, in6); // Eval big_Q Horner step: multiply by z
    let t162 = circuit_add(in43, t161); // Eval big_Q Horner step: add coefficient_22
    let t163 = circuit_mul(t162, in6); // Eval big_Q Horner step: multiply by z
    let t164 = circuit_add(in42, t163); // Eval big_Q Horner step: add coefficient_21
    let t165 = circuit_mul(t164, in6); // Eval big_Q Horner step: multiply by z
    let t166 = circuit_add(in41, t165); // Eval big_Q Horner step: add coefficient_20
    let t167 = circuit_mul(t166, in6); // Eval big_Q Horner step: multiply by z
    let t168 = circuit_add(in40, t167); // Eval big_Q Horner step: add coefficient_19
    let t169 = circuit_mul(t168, in6); // Eval big_Q Horner step: multiply by z
    let t170 = circuit_add(in39, t169); // Eval big_Q Horner step: add coefficient_18
    let t171 = circuit_mul(t170, in6); // Eval big_Q Horner step: multiply by z
    let t172 = circuit_add(in38, t171); // Eval big_Q Horner step: add coefficient_17
    let t173 = circuit_mul(t172, in6); // Eval big_Q Horner step: multiply by z
    let t174 = circuit_add(in37, t173); // Eval big_Q Horner step: add coefficient_16
    let t175 = circuit_mul(t174, in6); // Eval big_Q Horner step: multiply by z
    let t176 = circuit_add(in36, t175); // Eval big_Q Horner step: add coefficient_15
    let t177 = circuit_mul(t176, in6); // Eval big_Q Horner step: multiply by z
    let t178 = circuit_add(in35, t177); // Eval big_Q Horner step: add coefficient_14
    let t179 = circuit_mul(t178, in6); // Eval big_Q Horner step: multiply by z
    let t180 = circuit_add(in34, t179); // Eval big_Q Horner step: add coefficient_13
    let t181 = circuit_mul(t180, in6); // Eval big_Q Horner step: multiply by z
    let t182 = circuit_add(in33, t181); // Eval big_Q Horner step: add coefficient_12
    let t183 = circuit_mul(t182, in6); // Eval big_Q Horner step: multiply by z
    let t184 = circuit_add(in32, t183); // Eval big_Q Horner step: add coefficient_11
    let t185 = circuit_mul(t184, in6); // Eval big_Q Horner step: multiply by z
    let t186 = circuit_add(in31, t185); // Eval big_Q Horner step: add coefficient_10
    let t187 = circuit_mul(t186, in6); // Eval big_Q Horner step: multiply by z
    let t188 = circuit_add(in30, t187); // Eval big_Q Horner step: add coefficient_9
    let t189 = circuit_mul(t188, in6); // Eval big_Q Horner step: multiply by z
    let t190 = circuit_add(in29, t189); // Eval big_Q Horner step: add coefficient_8
    let t191 = circuit_mul(t190, in6); // Eval big_Q Horner step: multiply by z
    let t192 = circuit_add(in28, t191); // Eval big_Q Horner step: add coefficient_7
    let t193 = circuit_mul(t192, in6); // Eval big_Q Horner step: multiply by z
    let t194 = circuit_add(in27, t193); // Eval big_Q Horner step: add coefficient_6
    let t195 = circuit_mul(t194, in6); // Eval big_Q Horner step: multiply by z
    let t196 = circuit_add(in26, t195); // Eval big_Q Horner step: add coefficient_5
    let t197 = circuit_mul(t196, in6); // Eval big_Q Horner step: multiply by z
    let t198 = circuit_add(in25, t197); // Eval big_Q Horner step: add coefficient_4
    let t199 = circuit_mul(t198, in6); // Eval big_Q Horner step: multiply by z
    let t200 = circuit_add(in24, t199); // Eval big_Q Horner step: add coefficient_3
    let t201 = circuit_mul(t200, in6); // Eval big_Q Horner step: multiply by z
    let t202 = circuit_add(in23, t201); // Eval big_Q Horner step: add coefficient_2
    let t203 = circuit_mul(t202, in6); // Eval big_Q Horner step: multiply by z
    let t204 = circuit_add(in22, t203); // Eval big_Q Horner step: add coefficient_1
    let t205 = circuit_mul(t204, in6); // Eval big_Q Horner step: multiply by z
    let t206 = circuit_add(in21, t205); // Eval big_Q Horner step: add coefficient_0
    let t207 = circuit_mul(t206, t46); // Q(z) * P(z)
    let t208 = circuit_sub(t43, t207); // final_lhs - Q(z) * P(z)

    let modulus = crate::definitions::get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (t208,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs.next_2([0x2, 0x0, 0x0, 0x0]); // in1
    circuit_inputs = circuit_inputs
        .next_2(
            [
                0xb153ffffb9feffffffffaaa9, 0x6730d2a0f6b0f6241eabfffe, 0x434bacd764774b84f38512bf,
                0x1a0111ea397fe69a4b1ba7b6,
            ],
        ); // in2
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(R_n_minus_1_of_z); // in3
    circuit_inputs = circuit_inputs.next_2(c_1); // in4
    circuit_inputs = circuit_inputs.next_2(w_of_z); // in5
    circuit_inputs = circuit_inputs.next_2(z); // in6
    circuit_inputs = circuit_inputs.next_2(c_inv_frob_1_of_z); // in7
    circuit_inputs = circuit_inputs.next_2(previous_lhs); // in8
    circuit_inputs = circuit_inputs.next_2(R_n_minus_2.w0); // in9
    circuit_inputs = circuit_inputs.next_2(R_n_minus_2.w1); // in10
    circuit_inputs = circuit_inputs.next_2(R_n_minus_2.w2); // in11
    circuit_inputs = circuit_inputs.next_2(R_n_minus_2.w3); // in12
    circuit_inputs = circuit_inputs.next_2(R_n_minus_2.w4); // in13
    circuit_inputs = circuit_inputs.next_2(R_n_minus_2.w5); // in14
    circuit_inputs = circuit_inputs.next_2(R_n_minus_2.w6); // in15
    circuit_inputs = circuit_inputs.next_2(R_n_minus_2.w7); // in16
    circuit_inputs = circuit_inputs.next_2(R_n_minus_2.w8); // in17
    circuit_inputs = circuit_inputs.next_2(R_n_minus_2.w9); // in18
    circuit_inputs = circuit_inputs.next_2(R_n_minus_2.w10); // in19
    circuit_inputs = circuit_inputs.next_2(R_n_minus_2.w11); // in20

    for val in Q.span() {
        circuit_inputs = circuit_inputs.next_2(*val);
    } // in21 - in101

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let final_check: u384 = outputs.get_output(t208);
    return (final_check,);
}
#[inline(always)]
pub fn run_BLS12_381_MP_CHECK_FINALIZE_3P_EXT_MLR_circuit(
    R_n_minus_1_of_z: u384,
    c_1: u384,
    w_of_z: u384,
    z: u384,
    c_inv_frob_1_of_z: u384,
    previous_lhs: u384,
    R_n_minus_2: E12D<u384>,
    Q: Array<u384>,
    precomputed_miller_loop_result_of_z: u384,
) -> (u384,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0
    let in1 = CE::<CI<1>> {}; // 0x2
    let in2 = CE::<CI<2>> {}; // -0x2 % p

    // INPUT stack
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13, in14) = (CE::<CI<12>> {}, CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16, in17) = (CE::<CI<15>> {}, CE::<CI<16>> {}, CE::<CI<17>> {});
    let (in18, in19, in20) = (CE::<CI<18>> {}, CE::<CI<19>> {}, CE::<CI<20>> {});
    let (in21, in22, in23) = (CE::<CI<21>> {}, CE::<CI<22>> {}, CE::<CI<23>> {});
    let (in24, in25, in26) = (CE::<CI<24>> {}, CE::<CI<25>> {}, CE::<CI<26>> {});
    let (in27, in28, in29) = (CE::<CI<27>> {}, CE::<CI<28>> {}, CE::<CI<29>> {});
    let (in30, in31, in32) = (CE::<CI<30>> {}, CE::<CI<31>> {}, CE::<CI<32>> {});
    let (in33, in34, in35) = (CE::<CI<33>> {}, CE::<CI<34>> {}, CE::<CI<35>> {});
    let (in36, in37, in38) = (CE::<CI<36>> {}, CE::<CI<37>> {}, CE::<CI<38>> {});
    let (in39, in40, in41) = (CE::<CI<39>> {}, CE::<CI<40>> {}, CE::<CI<41>> {});
    let (in42, in43, in44) = (CE::<CI<42>> {}, CE::<CI<43>> {}, CE::<CI<44>> {});
    let (in45, in46, in47) = (CE::<CI<45>> {}, CE::<CI<46>> {}, CE::<CI<47>> {});
    let (in48, in49, in50) = (CE::<CI<48>> {}, CE::<CI<49>> {}, CE::<CI<50>> {});
    let (in51, in52, in53) = (CE::<CI<51>> {}, CE::<CI<52>> {}, CE::<CI<53>> {});
    let (in54, in55, in56) = (CE::<CI<54>> {}, CE::<CI<55>> {}, CE::<CI<56>> {});
    let (in57, in58, in59) = (CE::<CI<57>> {}, CE::<CI<58>> {}, CE::<CI<59>> {});
    let (in60, in61, in62) = (CE::<CI<60>> {}, CE::<CI<61>> {}, CE::<CI<62>> {});
    let (in63, in64, in65) = (CE::<CI<63>> {}, CE::<CI<64>> {}, CE::<CI<65>> {});
    let (in66, in67, in68) = (CE::<CI<66>> {}, CE::<CI<67>> {}, CE::<CI<68>> {});
    let (in69, in70, in71) = (CE::<CI<69>> {}, CE::<CI<70>> {}, CE::<CI<71>> {});
    let (in72, in73, in74) = (CE::<CI<72>> {}, CE::<CI<73>> {}, CE::<CI<74>> {});
    let (in75, in76, in77) = (CE::<CI<75>> {}, CE::<CI<76>> {}, CE::<CI<77>> {});
    let (in78, in79, in80) = (CE::<CI<78>> {}, CE::<CI<79>> {}, CE::<CI<80>> {});
    let (in81, in82, in83) = (CE::<CI<81>> {}, CE::<CI<82>> {}, CE::<CI<83>> {});
    let (in84, in85, in86) = (CE::<CI<84>> {}, CE::<CI<85>> {}, CE::<CI<86>> {});
    let (in87, in88, in89) = (CE::<CI<87>> {}, CE::<CI<88>> {}, CE::<CI<89>> {});
    let (in90, in91, in92) = (CE::<CI<90>> {}, CE::<CI<91>> {}, CE::<CI<92>> {});
    let (in93, in94, in95) = (CE::<CI<93>> {}, CE::<CI<94>> {}, CE::<CI<95>> {});
    let (in96, in97, in98) = (CE::<CI<96>> {}, CE::<CI<97>> {}, CE::<CI<98>> {});
    let (in99, in100, in101) = (CE::<CI<99>> {}, CE::<CI<100>> {}, CE::<CI<101>> {});
    let (in102, in103, in104) = (CE::<CI<102>> {}, CE::<CI<103>> {}, CE::<CI<104>> {});
    let (in105, in106, in107) = (CE::<CI<105>> {}, CE::<CI<106>> {}, CE::<CI<107>> {});
    let (in108, in109, in110) = (CE::<CI<108>> {}, CE::<CI<109>> {}, CE::<CI<110>> {});
    let (in111, in112, in113) = (CE::<CI<111>> {}, CE::<CI<112>> {}, CE::<CI<113>> {});
    let (in114, in115, in116) = (CE::<CI<114>> {}, CE::<CI<115>> {}, CE::<CI<116>> {});
    let (in117, in118, in119) = (CE::<CI<117>> {}, CE::<CI<118>> {}, CE::<CI<119>> {});
    let (in120, in121, in122) = (CE::<CI<120>> {}, CE::<CI<121>> {}, CE::<CI<122>> {});
    let (in123, in124, in125) = (CE::<CI<123>> {}, CE::<CI<124>> {}, CE::<CI<125>> {});
    let in126 = CE::<CI<126>> {};
    let t0 = circuit_mul(in6, in6); // Compute z^2
    let t1 = circuit_mul(t0, in6); // Compute z^3
    let t2 = circuit_mul(t1, in6); // Compute z^4
    let t3 = circuit_mul(t2, in6); // Compute z^5
    let t4 = circuit_mul(t3, in6); // Compute z^6
    let t5 = circuit_mul(t4, in6); // Compute z^7
    let t6 = circuit_mul(t5, in6); // Compute z^8
    let t7 = circuit_mul(t6, in6); // Compute z^9
    let t8 = circuit_mul(t7, in6); // Compute z^10
    let t9 = circuit_mul(t8, in6); // Compute z^11
    let t10 = circuit_mul(t9, in6); // Compute z^12
    let t11 = circuit_sub(in0, in10);
    let t12 = circuit_sub(in0, in12);
    let t13 = circuit_sub(in0, in14);
    let t14 = circuit_sub(in0, in16);
    let t15 = circuit_sub(in0, in18);
    let t16 = circuit_sub(in0, in20);
    let t17 = circuit_mul(t11, in6); // Eval R_n_minus_2_conjugate step coeff_1 * z^1
    let t18 = circuit_add(in9, t17); // Eval R_n_minus_2_conjugate step + (coeff_1 * z^1)
    let t19 = circuit_mul(in11, t0); // Eval R_n_minus_2_conjugate step coeff_2 * z^2
    let t20 = circuit_add(t18, t19); // Eval R_n_minus_2_conjugate step + (coeff_2 * z^2)
    let t21 = circuit_mul(t12, t1); // Eval R_n_minus_2_conjugate step coeff_3 * z^3
    let t22 = circuit_add(t20, t21); // Eval R_n_minus_2_conjugate step + (coeff_3 * z^3)
    let t23 = circuit_mul(in13, t2); // Eval R_n_minus_2_conjugate step coeff_4 * z^4
    let t24 = circuit_add(t22, t23); // Eval R_n_minus_2_conjugate step + (coeff_4 * z^4)
    let t25 = circuit_mul(t13, t3); // Eval R_n_minus_2_conjugate step coeff_5 * z^5
    let t26 = circuit_add(t24, t25); // Eval R_n_minus_2_conjugate step + (coeff_5 * z^5)
    let t27 = circuit_mul(in15, t4); // Eval R_n_minus_2_conjugate step coeff_6 * z^6
    let t28 = circuit_add(t26, t27); // Eval R_n_minus_2_conjugate step + (coeff_6 * z^6)
    let t29 = circuit_mul(t14, t5); // Eval R_n_minus_2_conjugate step coeff_7 * z^7
    let t30 = circuit_add(t28, t29); // Eval R_n_minus_2_conjugate step + (coeff_7 * z^7)
    let t31 = circuit_mul(in17, t6); // Eval R_n_minus_2_conjugate step coeff_8 * z^8
    let t32 = circuit_add(t30, t31); // Eval R_n_minus_2_conjugate step + (coeff_8 * z^8)
    let t33 = circuit_mul(t15, t7); // Eval R_n_minus_2_conjugate step coeff_9 * z^9
    let t34 = circuit_add(t32, t33); // Eval R_n_minus_2_conjugate step + (coeff_9 * z^9)
    let t35 = circuit_mul(in19, t8); // Eval R_n_minus_2_conjugate step coeff_10 * z^10
    let t36 = circuit_add(t34, t35); // Eval R_n_minus_2_conjugate step + (coeff_10 * z^10)
    let t37 = circuit_mul(t16, t9); // Eval R_n_minus_2_conjugate step coeff_11 * z^11
    let t38 = circuit_add(t36, t37); // Eval R_n_minus_2_conjugate step + (coeff_11 * z^11)
    let t39 = circuit_mul(t38, in7);
    let t40 = circuit_mul(t39, in5);
    let t41 = circuit_mul(t40, in126);
    let t42 = circuit_sub(t41, in3); // (Π(n-1,k) (Pk(z)) - R_n_minus_1(z))
    let t43 = circuit_mul(in4, in8);
    let t44 = circuit_add(t43, t42); // c_1 * previous_lhs + lhs_n_minus_1
    let t45 = circuit_mul(in2, t4); // Eval sparse poly P_irr step coeff_6 * z^6
    let t46 = circuit_add(in1, t45); // Eval sparse poly P_irr step + coeff_6 * z^6
    let t47 = circuit_add(t46, t10); // Eval sparse poly P_irr step + 1*z^12
    let t48 = circuit_mul(in125, in6); // Eval big_Q Horner step: multiply by z
    let t49 = circuit_add(in124, t48); // Eval big_Q Horner step: add coefficient_103
    let t50 = circuit_mul(t49, in6); // Eval big_Q Horner step: multiply by z
    let t51 = circuit_add(in123, t50); // Eval big_Q Horner step: add coefficient_102
    let t52 = circuit_mul(t51, in6); // Eval big_Q Horner step: multiply by z
    let t53 = circuit_add(in122, t52); // Eval big_Q Horner step: add coefficient_101
    let t54 = circuit_mul(t53, in6); // Eval big_Q Horner step: multiply by z
    let t55 = circuit_add(in121, t54); // Eval big_Q Horner step: add coefficient_100
    let t56 = circuit_mul(t55, in6); // Eval big_Q Horner step: multiply by z
    let t57 = circuit_add(in120, t56); // Eval big_Q Horner step: add coefficient_99
    let t58 = circuit_mul(t57, in6); // Eval big_Q Horner step: multiply by z
    let t59 = circuit_add(in119, t58); // Eval big_Q Horner step: add coefficient_98
    let t60 = circuit_mul(t59, in6); // Eval big_Q Horner step: multiply by z
    let t61 = circuit_add(in118, t60); // Eval big_Q Horner step: add coefficient_97
    let t62 = circuit_mul(t61, in6); // Eval big_Q Horner step: multiply by z
    let t63 = circuit_add(in117, t62); // Eval big_Q Horner step: add coefficient_96
    let t64 = circuit_mul(t63, in6); // Eval big_Q Horner step: multiply by z
    let t65 = circuit_add(in116, t64); // Eval big_Q Horner step: add coefficient_95
    let t66 = circuit_mul(t65, in6); // Eval big_Q Horner step: multiply by z
    let t67 = circuit_add(in115, t66); // Eval big_Q Horner step: add coefficient_94
    let t68 = circuit_mul(t67, in6); // Eval big_Q Horner step: multiply by z
    let t69 = circuit_add(in114, t68); // Eval big_Q Horner step: add coefficient_93
    let t70 = circuit_mul(t69, in6); // Eval big_Q Horner step: multiply by z
    let t71 = circuit_add(in113, t70); // Eval big_Q Horner step: add coefficient_92
    let t72 = circuit_mul(t71, in6); // Eval big_Q Horner step: multiply by z
    let t73 = circuit_add(in112, t72); // Eval big_Q Horner step: add coefficient_91
    let t74 = circuit_mul(t73, in6); // Eval big_Q Horner step: multiply by z
    let t75 = circuit_add(in111, t74); // Eval big_Q Horner step: add coefficient_90
    let t76 = circuit_mul(t75, in6); // Eval big_Q Horner step: multiply by z
    let t77 = circuit_add(in110, t76); // Eval big_Q Horner step: add coefficient_89
    let t78 = circuit_mul(t77, in6); // Eval big_Q Horner step: multiply by z
    let t79 = circuit_add(in109, t78); // Eval big_Q Horner step: add coefficient_88
    let t80 = circuit_mul(t79, in6); // Eval big_Q Horner step: multiply by z
    let t81 = circuit_add(in108, t80); // Eval big_Q Horner step: add coefficient_87
    let t82 = circuit_mul(t81, in6); // Eval big_Q Horner step: multiply by z
    let t83 = circuit_add(in107, t82); // Eval big_Q Horner step: add coefficient_86
    let t84 = circuit_mul(t83, in6); // Eval big_Q Horner step: multiply by z
    let t85 = circuit_add(in106, t84); // Eval big_Q Horner step: add coefficient_85
    let t86 = circuit_mul(t85, in6); // Eval big_Q Horner step: multiply by z
    let t87 = circuit_add(in105, t86); // Eval big_Q Horner step: add coefficient_84
    let t88 = circuit_mul(t87, in6); // Eval big_Q Horner step: multiply by z
    let t89 = circuit_add(in104, t88); // Eval big_Q Horner step: add coefficient_83
    let t90 = circuit_mul(t89, in6); // Eval big_Q Horner step: multiply by z
    let t91 = circuit_add(in103, t90); // Eval big_Q Horner step: add coefficient_82
    let t92 = circuit_mul(t91, in6); // Eval big_Q Horner step: multiply by z
    let t93 = circuit_add(in102, t92); // Eval big_Q Horner step: add coefficient_81
    let t94 = circuit_mul(t93, in6); // Eval big_Q Horner step: multiply by z
    let t95 = circuit_add(in101, t94); // Eval big_Q Horner step: add coefficient_80
    let t96 = circuit_mul(t95, in6); // Eval big_Q Horner step: multiply by z
    let t97 = circuit_add(in100, t96); // Eval big_Q Horner step: add coefficient_79
    let t98 = circuit_mul(t97, in6); // Eval big_Q Horner step: multiply by z
    let t99 = circuit_add(in99, t98); // Eval big_Q Horner step: add coefficient_78
    let t100 = circuit_mul(t99, in6); // Eval big_Q Horner step: multiply by z
    let t101 = circuit_add(in98, t100); // Eval big_Q Horner step: add coefficient_77
    let t102 = circuit_mul(t101, in6); // Eval big_Q Horner step: multiply by z
    let t103 = circuit_add(in97, t102); // Eval big_Q Horner step: add coefficient_76
    let t104 = circuit_mul(t103, in6); // Eval big_Q Horner step: multiply by z
    let t105 = circuit_add(in96, t104); // Eval big_Q Horner step: add coefficient_75
    let t106 = circuit_mul(t105, in6); // Eval big_Q Horner step: multiply by z
    let t107 = circuit_add(in95, t106); // Eval big_Q Horner step: add coefficient_74
    let t108 = circuit_mul(t107, in6); // Eval big_Q Horner step: multiply by z
    let t109 = circuit_add(in94, t108); // Eval big_Q Horner step: add coefficient_73
    let t110 = circuit_mul(t109, in6); // Eval big_Q Horner step: multiply by z
    let t111 = circuit_add(in93, t110); // Eval big_Q Horner step: add coefficient_72
    let t112 = circuit_mul(t111, in6); // Eval big_Q Horner step: multiply by z
    let t113 = circuit_add(in92, t112); // Eval big_Q Horner step: add coefficient_71
    let t114 = circuit_mul(t113, in6); // Eval big_Q Horner step: multiply by z
    let t115 = circuit_add(in91, t114); // Eval big_Q Horner step: add coefficient_70
    let t116 = circuit_mul(t115, in6); // Eval big_Q Horner step: multiply by z
    let t117 = circuit_add(in90, t116); // Eval big_Q Horner step: add coefficient_69
    let t118 = circuit_mul(t117, in6); // Eval big_Q Horner step: multiply by z
    let t119 = circuit_add(in89, t118); // Eval big_Q Horner step: add coefficient_68
    let t120 = circuit_mul(t119, in6); // Eval big_Q Horner step: multiply by z
    let t121 = circuit_add(in88, t120); // Eval big_Q Horner step: add coefficient_67
    let t122 = circuit_mul(t121, in6); // Eval big_Q Horner step: multiply by z
    let t123 = circuit_add(in87, t122); // Eval big_Q Horner step: add coefficient_66
    let t124 = circuit_mul(t123, in6); // Eval big_Q Horner step: multiply by z
    let t125 = circuit_add(in86, t124); // Eval big_Q Horner step: add coefficient_65
    let t126 = circuit_mul(t125, in6); // Eval big_Q Horner step: multiply by z
    let t127 = circuit_add(in85, t126); // Eval big_Q Horner step: add coefficient_64
    let t128 = circuit_mul(t127, in6); // Eval big_Q Horner step: multiply by z
    let t129 = circuit_add(in84, t128); // Eval big_Q Horner step: add coefficient_63
    let t130 = circuit_mul(t129, in6); // Eval big_Q Horner step: multiply by z
    let t131 = circuit_add(in83, t130); // Eval big_Q Horner step: add coefficient_62
    let t132 = circuit_mul(t131, in6); // Eval big_Q Horner step: multiply by z
    let t133 = circuit_add(in82, t132); // Eval big_Q Horner step: add coefficient_61
    let t134 = circuit_mul(t133, in6); // Eval big_Q Horner step: multiply by z
    let t135 = circuit_add(in81, t134); // Eval big_Q Horner step: add coefficient_60
    let t136 = circuit_mul(t135, in6); // Eval big_Q Horner step: multiply by z
    let t137 = circuit_add(in80, t136); // Eval big_Q Horner step: add coefficient_59
    let t138 = circuit_mul(t137, in6); // Eval big_Q Horner step: multiply by z
    let t139 = circuit_add(in79, t138); // Eval big_Q Horner step: add coefficient_58
    let t140 = circuit_mul(t139, in6); // Eval big_Q Horner step: multiply by z
    let t141 = circuit_add(in78, t140); // Eval big_Q Horner step: add coefficient_57
    let t142 = circuit_mul(t141, in6); // Eval big_Q Horner step: multiply by z
    let t143 = circuit_add(in77, t142); // Eval big_Q Horner step: add coefficient_56
    let t144 = circuit_mul(t143, in6); // Eval big_Q Horner step: multiply by z
    let t145 = circuit_add(in76, t144); // Eval big_Q Horner step: add coefficient_55
    let t146 = circuit_mul(t145, in6); // Eval big_Q Horner step: multiply by z
    let t147 = circuit_add(in75, t146); // Eval big_Q Horner step: add coefficient_54
    let t148 = circuit_mul(t147, in6); // Eval big_Q Horner step: multiply by z
    let t149 = circuit_add(in74, t148); // Eval big_Q Horner step: add coefficient_53
    let t150 = circuit_mul(t149, in6); // Eval big_Q Horner step: multiply by z
    let t151 = circuit_add(in73, t150); // Eval big_Q Horner step: add coefficient_52
    let t152 = circuit_mul(t151, in6); // Eval big_Q Horner step: multiply by z
    let t153 = circuit_add(in72, t152); // Eval big_Q Horner step: add coefficient_51
    let t154 = circuit_mul(t153, in6); // Eval big_Q Horner step: multiply by z
    let t155 = circuit_add(in71, t154); // Eval big_Q Horner step: add coefficient_50
    let t156 = circuit_mul(t155, in6); // Eval big_Q Horner step: multiply by z
    let t157 = circuit_add(in70, t156); // Eval big_Q Horner step: add coefficient_49
    let t158 = circuit_mul(t157, in6); // Eval big_Q Horner step: multiply by z
    let t159 = circuit_add(in69, t158); // Eval big_Q Horner step: add coefficient_48
    let t160 = circuit_mul(t159, in6); // Eval big_Q Horner step: multiply by z
    let t161 = circuit_add(in68, t160); // Eval big_Q Horner step: add coefficient_47
    let t162 = circuit_mul(t161, in6); // Eval big_Q Horner step: multiply by z
    let t163 = circuit_add(in67, t162); // Eval big_Q Horner step: add coefficient_46
    let t164 = circuit_mul(t163, in6); // Eval big_Q Horner step: multiply by z
    let t165 = circuit_add(in66, t164); // Eval big_Q Horner step: add coefficient_45
    let t166 = circuit_mul(t165, in6); // Eval big_Q Horner step: multiply by z
    let t167 = circuit_add(in65, t166); // Eval big_Q Horner step: add coefficient_44
    let t168 = circuit_mul(t167, in6); // Eval big_Q Horner step: multiply by z
    let t169 = circuit_add(in64, t168); // Eval big_Q Horner step: add coefficient_43
    let t170 = circuit_mul(t169, in6); // Eval big_Q Horner step: multiply by z
    let t171 = circuit_add(in63, t170); // Eval big_Q Horner step: add coefficient_42
    let t172 = circuit_mul(t171, in6); // Eval big_Q Horner step: multiply by z
    let t173 = circuit_add(in62, t172); // Eval big_Q Horner step: add coefficient_41
    let t174 = circuit_mul(t173, in6); // Eval big_Q Horner step: multiply by z
    let t175 = circuit_add(in61, t174); // Eval big_Q Horner step: add coefficient_40
    let t176 = circuit_mul(t175, in6); // Eval big_Q Horner step: multiply by z
    let t177 = circuit_add(in60, t176); // Eval big_Q Horner step: add coefficient_39
    let t178 = circuit_mul(t177, in6); // Eval big_Q Horner step: multiply by z
    let t179 = circuit_add(in59, t178); // Eval big_Q Horner step: add coefficient_38
    let t180 = circuit_mul(t179, in6); // Eval big_Q Horner step: multiply by z
    let t181 = circuit_add(in58, t180); // Eval big_Q Horner step: add coefficient_37
    let t182 = circuit_mul(t181, in6); // Eval big_Q Horner step: multiply by z
    let t183 = circuit_add(in57, t182); // Eval big_Q Horner step: add coefficient_36
    let t184 = circuit_mul(t183, in6); // Eval big_Q Horner step: multiply by z
    let t185 = circuit_add(in56, t184); // Eval big_Q Horner step: add coefficient_35
    let t186 = circuit_mul(t185, in6); // Eval big_Q Horner step: multiply by z
    let t187 = circuit_add(in55, t186); // Eval big_Q Horner step: add coefficient_34
    let t188 = circuit_mul(t187, in6); // Eval big_Q Horner step: multiply by z
    let t189 = circuit_add(in54, t188); // Eval big_Q Horner step: add coefficient_33
    let t190 = circuit_mul(t189, in6); // Eval big_Q Horner step: multiply by z
    let t191 = circuit_add(in53, t190); // Eval big_Q Horner step: add coefficient_32
    let t192 = circuit_mul(t191, in6); // Eval big_Q Horner step: multiply by z
    let t193 = circuit_add(in52, t192); // Eval big_Q Horner step: add coefficient_31
    let t194 = circuit_mul(t193, in6); // Eval big_Q Horner step: multiply by z
    let t195 = circuit_add(in51, t194); // Eval big_Q Horner step: add coefficient_30
    let t196 = circuit_mul(t195, in6); // Eval big_Q Horner step: multiply by z
    let t197 = circuit_add(in50, t196); // Eval big_Q Horner step: add coefficient_29
    let t198 = circuit_mul(t197, in6); // Eval big_Q Horner step: multiply by z
    let t199 = circuit_add(in49, t198); // Eval big_Q Horner step: add coefficient_28
    let t200 = circuit_mul(t199, in6); // Eval big_Q Horner step: multiply by z
    let t201 = circuit_add(in48, t200); // Eval big_Q Horner step: add coefficient_27
    let t202 = circuit_mul(t201, in6); // Eval big_Q Horner step: multiply by z
    let t203 = circuit_add(in47, t202); // Eval big_Q Horner step: add coefficient_26
    let t204 = circuit_mul(t203, in6); // Eval big_Q Horner step: multiply by z
    let t205 = circuit_add(in46, t204); // Eval big_Q Horner step: add coefficient_25
    let t206 = circuit_mul(t205, in6); // Eval big_Q Horner step: multiply by z
    let t207 = circuit_add(in45, t206); // Eval big_Q Horner step: add coefficient_24
    let t208 = circuit_mul(t207, in6); // Eval big_Q Horner step: multiply by z
    let t209 = circuit_add(in44, t208); // Eval big_Q Horner step: add coefficient_23
    let t210 = circuit_mul(t209, in6); // Eval big_Q Horner step: multiply by z
    let t211 = circuit_add(in43, t210); // Eval big_Q Horner step: add coefficient_22
    let t212 = circuit_mul(t211, in6); // Eval big_Q Horner step: multiply by z
    let t213 = circuit_add(in42, t212); // Eval big_Q Horner step: add coefficient_21
    let t214 = circuit_mul(t213, in6); // Eval big_Q Horner step: multiply by z
    let t215 = circuit_add(in41, t214); // Eval big_Q Horner step: add coefficient_20
    let t216 = circuit_mul(t215, in6); // Eval big_Q Horner step: multiply by z
    let t217 = circuit_add(in40, t216); // Eval big_Q Horner step: add coefficient_19
    let t218 = circuit_mul(t217, in6); // Eval big_Q Horner step: multiply by z
    let t219 = circuit_add(in39, t218); // Eval big_Q Horner step: add coefficient_18
    let t220 = circuit_mul(t219, in6); // Eval big_Q Horner step: multiply by z
    let t221 = circuit_add(in38, t220); // Eval big_Q Horner step: add coefficient_17
    let t222 = circuit_mul(t221, in6); // Eval big_Q Horner step: multiply by z
    let t223 = circuit_add(in37, t222); // Eval big_Q Horner step: add coefficient_16
    let t224 = circuit_mul(t223, in6); // Eval big_Q Horner step: multiply by z
    let t225 = circuit_add(in36, t224); // Eval big_Q Horner step: add coefficient_15
    let t226 = circuit_mul(t225, in6); // Eval big_Q Horner step: multiply by z
    let t227 = circuit_add(in35, t226); // Eval big_Q Horner step: add coefficient_14
    let t228 = circuit_mul(t227, in6); // Eval big_Q Horner step: multiply by z
    let t229 = circuit_add(in34, t228); // Eval big_Q Horner step: add coefficient_13
    let t230 = circuit_mul(t229, in6); // Eval big_Q Horner step: multiply by z
    let t231 = circuit_add(in33, t230); // Eval big_Q Horner step: add coefficient_12
    let t232 = circuit_mul(t231, in6); // Eval big_Q Horner step: multiply by z
    let t233 = circuit_add(in32, t232); // Eval big_Q Horner step: add coefficient_11
    let t234 = circuit_mul(t233, in6); // Eval big_Q Horner step: multiply by z
    let t235 = circuit_add(in31, t234); // Eval big_Q Horner step: add coefficient_10
    let t236 = circuit_mul(t235, in6); // Eval big_Q Horner step: multiply by z
    let t237 = circuit_add(in30, t236); // Eval big_Q Horner step: add coefficient_9
    let t238 = circuit_mul(t237, in6); // Eval big_Q Horner step: multiply by z
    let t239 = circuit_add(in29, t238); // Eval big_Q Horner step: add coefficient_8
    let t240 = circuit_mul(t239, in6); // Eval big_Q Horner step: multiply by z
    let t241 = circuit_add(in28, t240); // Eval big_Q Horner step: add coefficient_7
    let t242 = circuit_mul(t241, in6); // Eval big_Q Horner step: multiply by z
    let t243 = circuit_add(in27, t242); // Eval big_Q Horner step: add coefficient_6
    let t244 = circuit_mul(t243, in6); // Eval big_Q Horner step: multiply by z
    let t245 = circuit_add(in26, t244); // Eval big_Q Horner step: add coefficient_5
    let t246 = circuit_mul(t245, in6); // Eval big_Q Horner step: multiply by z
    let t247 = circuit_add(in25, t246); // Eval big_Q Horner step: add coefficient_4
    let t248 = circuit_mul(t247, in6); // Eval big_Q Horner step: multiply by z
    let t249 = circuit_add(in24, t248); // Eval big_Q Horner step: add coefficient_3
    let t250 = circuit_mul(t249, in6); // Eval big_Q Horner step: multiply by z
    let t251 = circuit_add(in23, t250); // Eval big_Q Horner step: add coefficient_2
    let t252 = circuit_mul(t251, in6); // Eval big_Q Horner step: multiply by z
    let t253 = circuit_add(in22, t252); // Eval big_Q Horner step: add coefficient_1
    let t254 = circuit_mul(t253, in6); // Eval big_Q Horner step: multiply by z
    let t255 = circuit_add(in21, t254); // Eval big_Q Horner step: add coefficient_0
    let t256 = circuit_mul(t255, t47); // Q(z) * P(z)
    let t257 = circuit_sub(t44, t256); // final_lhs - Q(z) * P(z)

    let modulus = crate::definitions::get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (t257,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs.next_2([0x2, 0x0, 0x0, 0x0]); // in1
    circuit_inputs = circuit_inputs
        .next_2(
            [
                0xb153ffffb9feffffffffaaa9, 0x6730d2a0f6b0f6241eabfffe, 0x434bacd764774b84f38512bf,
                0x1a0111ea397fe69a4b1ba7b6,
            ],
        ); // in2
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(R_n_minus_1_of_z); // in3
    circuit_inputs = circuit_inputs.next_2(c_1); // in4
    circuit_inputs = circuit_inputs.next_2(w_of_z); // in5
    circuit_inputs = circuit_inputs.next_2(z); // in6
    circuit_inputs = circuit_inputs.next_2(c_inv_frob_1_of_z); // in7
    circuit_inputs = circuit_inputs.next_2(previous_lhs); // in8
    circuit_inputs = circuit_inputs.next_2(R_n_minus_2.w0); // in9
    circuit_inputs = circuit_inputs.next_2(R_n_minus_2.w1); // in10
    circuit_inputs = circuit_inputs.next_2(R_n_minus_2.w2); // in11
    circuit_inputs = circuit_inputs.next_2(R_n_minus_2.w3); // in12
    circuit_inputs = circuit_inputs.next_2(R_n_minus_2.w4); // in13
    circuit_inputs = circuit_inputs.next_2(R_n_minus_2.w5); // in14
    circuit_inputs = circuit_inputs.next_2(R_n_minus_2.w6); // in15
    circuit_inputs = circuit_inputs.next_2(R_n_minus_2.w7); // in16
    circuit_inputs = circuit_inputs.next_2(R_n_minus_2.w8); // in17
    circuit_inputs = circuit_inputs.next_2(R_n_minus_2.w9); // in18
    circuit_inputs = circuit_inputs.next_2(R_n_minus_2.w10); // in19
    circuit_inputs = circuit_inputs.next_2(R_n_minus_2.w11); // in20

    for val in Q.span() {
        circuit_inputs = circuit_inputs.next_2(*val);
    } // in21 - in125

    circuit_inputs = circuit_inputs.next_2(precomputed_miller_loop_result_of_z); // in126

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let final_check: u384 = outputs.get_output(t257);
    return (final_check,);
}
#[inline(always)]
pub fn run_BLS12_381_MP_CHECK_INIT_BIT_2P_2F_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    G2_line_0: G2Line<u384>,
    G2_line_0_2: G2Line<u384>,
    yInv_1: u384,
    xNegOverY_1: u384,
    G2_line_1: G2Line<u384>,
    G2_line_1_2: G2Line<u384>,
    R_i_of_z: u384,
    z: u384,
    c_inv_of_z: u384,
) -> (u384,) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13, in14) = (CE::<CI<12>> {}, CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16, in17) = (CE::<CI<15>> {}, CE::<CI<16>> {}, CE::<CI<17>> {});
    let (in18, in19, in20) = (CE::<CI<18>> {}, CE::<CI<19>> {}, CE::<CI<20>> {});
    let (in21, in22) = (CE::<CI<21>> {}, CE::<CI<22>> {});
    let t0 = circuit_mul(in21, in21); // compute z^2
    let t1 = circuit_mul(t0, in21); // compute z^3
    let t2 = circuit_mul(t1, t1); // compute z^6
    let t3 = circuit_mul(t2, t0); // compute z^8
    let t4 = circuit_mul(in22, in22);
    let t5 = circuit_mul(in22, t4);
    let t6 = circuit_sub(in4, in5);
    let t7 = circuit_mul(t6, in0); // eval bls line by yInv
    let t8 = circuit_sub(in2, in3);
    let t9 = circuit_mul(t8, in1); // eval blsline by xNegOverY
    let t10 = circuit_mul(in5, in0); // eval bls line by yInv
    let t11 = circuit_mul(in3, in1); // eval bls line by xNegOverY
    let t12 = circuit_sub(in8, in9);
    let t13 = circuit_mul(t12, in0); // eval bls line by yInv
    let t14 = circuit_sub(in6, in7);
    let t15 = circuit_mul(t14, in1); // eval blsline by xNegOverY
    let t16 = circuit_mul(in9, in0); // eval bls line by yInv
    let t17 = circuit_mul(in7, in1); // eval bls line by xNegOverY
    let t18 = circuit_mul(t9, t0); // Eval sparse poly line_0p_1 step coeff_2 * z^2
    let t19 = circuit_add(t7, t18); // Eval sparse poly line_0p_1 step + coeff_2 * z^2
    let t20 = circuit_add(t19, t1); // Eval sparse poly line_0p_1 step + 1*z^3
    let t21 = circuit_mul(t10, t2); // Eval sparse poly line_0p_1 step coeff_6 * z^6
    let t22 = circuit_add(t20, t21); // Eval sparse poly line_0p_1 step + coeff_6 * z^6
    let t23 = circuit_mul(t11, t3); // Eval sparse poly line_0p_1 step coeff_8 * z^8
    let t24 = circuit_add(t22, t23); // Eval sparse poly line_0p_1 step + coeff_8 * z^8
    let t25 = circuit_mul(t5, t24);
    let t26 = circuit_mul(t15, t0); // Eval sparse poly line_0p_2 step coeff_2 * z^2
    let t27 = circuit_add(t13, t26); // Eval sparse poly line_0p_2 step + coeff_2 * z^2
    let t28 = circuit_add(t27, t1); // Eval sparse poly line_0p_2 step + 1*z^3
    let t29 = circuit_mul(t16, t2); // Eval sparse poly line_0p_2 step coeff_6 * z^6
    let t30 = circuit_add(t28, t29); // Eval sparse poly line_0p_2 step + coeff_6 * z^6
    let t31 = circuit_mul(t17, t3); // Eval sparse poly line_0p_2 step coeff_8 * z^8
    let t32 = circuit_add(t30, t31); // Eval sparse poly line_0p_2 step + coeff_8 * z^8
    let t33 = circuit_mul(t25, t32);
    let t34 = circuit_sub(in14, in15);
    let t35 = circuit_mul(t34, in10); // eval bls line by yInv
    let t36 = circuit_sub(in12, in13);
    let t37 = circuit_mul(t36, in11); // eval blsline by xNegOverY
    let t38 = circuit_mul(in15, in10); // eval bls line by yInv
    let t39 = circuit_mul(in13, in11); // eval bls line by xNegOverY
    let t40 = circuit_sub(in18, in19);
    let t41 = circuit_mul(t40, in10); // eval bls line by yInv
    let t42 = circuit_sub(in16, in17);
    let t43 = circuit_mul(t42, in11); // eval blsline by xNegOverY
    let t44 = circuit_mul(in19, in10); // eval bls line by yInv
    let t45 = circuit_mul(in17, in11); // eval bls line by xNegOverY
    let t46 = circuit_mul(t37, t0); // Eval sparse poly line_1p_1 step coeff_2 * z^2
    let t47 = circuit_add(t35, t46); // Eval sparse poly line_1p_1 step + coeff_2 * z^2
    let t48 = circuit_add(t47, t1); // Eval sparse poly line_1p_1 step + 1*z^3
    let t49 = circuit_mul(t38, t2); // Eval sparse poly line_1p_1 step coeff_6 * z^6
    let t50 = circuit_add(t48, t49); // Eval sparse poly line_1p_1 step + coeff_6 * z^6
    let t51 = circuit_mul(t39, t3); // Eval sparse poly line_1p_1 step coeff_8 * z^8
    let t52 = circuit_add(t50, t51); // Eval sparse poly line_1p_1 step + coeff_8 * z^8
    let t53 = circuit_mul(t33, t52);
    let t54 = circuit_mul(t43, t0); // Eval sparse poly line_1p_2 step coeff_2 * z^2
    let t55 = circuit_add(t41, t54); // Eval sparse poly line_1p_2 step + coeff_2 * z^2
    let t56 = circuit_add(t55, t1); // Eval sparse poly line_1p_2 step + 1*z^3
    let t57 = circuit_mul(t44, t2); // Eval sparse poly line_1p_2 step coeff_6 * z^6
    let t58 = circuit_add(t56, t57); // Eval sparse poly line_1p_2 step + coeff_6 * z^6
    let t59 = circuit_mul(t45, t3); // Eval sparse poly line_1p_2 step coeff_8 * z^8
    let t60 = circuit_add(t58, t59); // Eval sparse poly line_1p_2 step + coeff_8 * z^8
    let t61 = circuit_mul(t53, t60);
    let t62 = circuit_sub(t61, in20); // ((Π(i,k) (Pk(z)) - Ri(z))

    let modulus = crate::definitions::get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (t62,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(yInv_0); // in0
    circuit_inputs = circuit_inputs.next_2(xNegOverY_0); // in1
    circuit_inputs = circuit_inputs.next_2(G2_line_0.r0a0); // in2
    circuit_inputs = circuit_inputs.next_2(G2_line_0.r0a1); // in3
    circuit_inputs = circuit_inputs.next_2(G2_line_0.r1a0); // in4
    circuit_inputs = circuit_inputs.next_2(G2_line_0.r1a1); // in5
    circuit_inputs = circuit_inputs.next_2(G2_line_0_2.r0a0); // in6
    circuit_inputs = circuit_inputs.next_2(G2_line_0_2.r0a1); // in7
    circuit_inputs = circuit_inputs.next_2(G2_line_0_2.r1a0); // in8
    circuit_inputs = circuit_inputs.next_2(G2_line_0_2.r1a1); // in9
    circuit_inputs = circuit_inputs.next_2(yInv_1); // in10
    circuit_inputs = circuit_inputs.next_2(xNegOverY_1); // in11
    circuit_inputs = circuit_inputs.next_2(G2_line_1.r0a0); // in12
    circuit_inputs = circuit_inputs.next_2(G2_line_1.r0a1); // in13
    circuit_inputs = circuit_inputs.next_2(G2_line_1.r1a0); // in14
    circuit_inputs = circuit_inputs.next_2(G2_line_1.r1a1); // in15
    circuit_inputs = circuit_inputs.next_2(G2_line_1_2.r0a0); // in16
    circuit_inputs = circuit_inputs.next_2(G2_line_1_2.r0a1); // in17
    circuit_inputs = circuit_inputs.next_2(G2_line_1_2.r1a0); // in18
    circuit_inputs = circuit_inputs.next_2(G2_line_1_2.r1a1); // in19
    circuit_inputs = circuit_inputs.next_2(R_i_of_z); // in20
    circuit_inputs = circuit_inputs.next_2(z); // in21
    circuit_inputs = circuit_inputs.next_2(c_inv_of_z); // in22

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let new_lhs: u384 = outputs.get_output(t62);
    return (new_lhs,);
}
#[inline(always)]
pub fn run_BLS12_381_MP_CHECK_INIT_BIT_3P_2F_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    G2_line_0: G2Line<u384>,
    G2_line_0_2: G2Line<u384>,
    yInv_1: u384,
    xNegOverY_1: u384,
    G2_line_1: G2Line<u384>,
    G2_line_1_2: G2Line<u384>,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q_2: G2Point,
    R_i_of_z: u384,
    z: u384,
    c_inv_of_z: u384,
) -> (G2Point, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x3
    let in1 = CE::<CI<1>> {}; // 0x6
    let in2 = CE::<CI<2>> {}; // 0x0

    // INPUT stack
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13, in14) = (CE::<CI<12>> {}, CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16, in17) = (CE::<CI<15>> {}, CE::<CI<16>> {}, CE::<CI<17>> {});
    let (in18, in19, in20) = (CE::<CI<18>> {}, CE::<CI<19>> {}, CE::<CI<20>> {});
    let (in21, in22, in23) = (CE::<CI<21>> {}, CE::<CI<22>> {}, CE::<CI<23>> {});
    let (in24, in25, in26) = (CE::<CI<24>> {}, CE::<CI<25>> {}, CE::<CI<26>> {});
    let (in27, in28, in29) = (CE::<CI<27>> {}, CE::<CI<28>> {}, CE::<CI<29>> {});
    let (in30, in31) = (CE::<CI<30>> {}, CE::<CI<31>> {});
    let t0 = circuit_mul(in30, in30); // compute z^2
    let t1 = circuit_mul(t0, in30); // compute z^3
    let t2 = circuit_mul(t1, t1); // compute z^6
    let t3 = circuit_mul(t2, t0); // compute z^8
    let t4 = circuit_mul(in31, in31);
    let t5 = circuit_mul(in31, t4);
    let t6 = circuit_sub(in7, in8);
    let t7 = circuit_mul(t6, in3); // eval bls line by yInv
    let t8 = circuit_sub(in5, in6);
    let t9 = circuit_mul(t8, in4); // eval blsline by xNegOverY
    let t10 = circuit_mul(in8, in3); // eval bls line by yInv
    let t11 = circuit_mul(in6, in4); // eval bls line by xNegOverY
    let t12 = circuit_sub(in11, in12);
    let t13 = circuit_mul(t12, in3); // eval bls line by yInv
    let t14 = circuit_sub(in9, in10);
    let t15 = circuit_mul(t14, in4); // eval blsline by xNegOverY
    let t16 = circuit_mul(in12, in3); // eval bls line by yInv
    let t17 = circuit_mul(in10, in4); // eval bls line by xNegOverY
    let t18 = circuit_mul(t9, t0); // Eval sparse poly line_0p_1 step coeff_2 * z^2
    let t19 = circuit_add(t7, t18); // Eval sparse poly line_0p_1 step + coeff_2 * z^2
    let t20 = circuit_add(t19, t1); // Eval sparse poly line_0p_1 step + 1*z^3
    let t21 = circuit_mul(t10, t2); // Eval sparse poly line_0p_1 step coeff_6 * z^6
    let t22 = circuit_add(t20, t21); // Eval sparse poly line_0p_1 step + coeff_6 * z^6
    let t23 = circuit_mul(t11, t3); // Eval sparse poly line_0p_1 step coeff_8 * z^8
    let t24 = circuit_add(t22, t23); // Eval sparse poly line_0p_1 step + coeff_8 * z^8
    let t25 = circuit_mul(t5, t24);
    let t26 = circuit_mul(t15, t0); // Eval sparse poly line_0p_2 step coeff_2 * z^2
    let t27 = circuit_add(t13, t26); // Eval sparse poly line_0p_2 step + coeff_2 * z^2
    let t28 = circuit_add(t27, t1); // Eval sparse poly line_0p_2 step + 1*z^3
    let t29 = circuit_mul(t16, t2); // Eval sparse poly line_0p_2 step coeff_6 * z^6
    let t30 = circuit_add(t28, t29); // Eval sparse poly line_0p_2 step + coeff_6 * z^6
    let t31 = circuit_mul(t17, t3); // Eval sparse poly line_0p_2 step coeff_8 * z^8
    let t32 = circuit_add(t30, t31); // Eval sparse poly line_0p_2 step + coeff_8 * z^8
    let t33 = circuit_mul(t25, t32);
    let t34 = circuit_sub(in17, in18);
    let t35 = circuit_mul(t34, in13); // eval bls line by yInv
    let t36 = circuit_sub(in15, in16);
    let t37 = circuit_mul(t36, in14); // eval blsline by xNegOverY
    let t38 = circuit_mul(in18, in13); // eval bls line by yInv
    let t39 = circuit_mul(in16, in14); // eval bls line by xNegOverY
    let t40 = circuit_sub(in21, in22);
    let t41 = circuit_mul(t40, in13); // eval bls line by yInv
    let t42 = circuit_sub(in19, in20);
    let t43 = circuit_mul(t42, in14); // eval blsline by xNegOverY
    let t44 = circuit_mul(in22, in13); // eval bls line by yInv
    let t45 = circuit_mul(in20, in14); // eval bls line by xNegOverY
    let t46 = circuit_mul(t37, t0); // Eval sparse poly line_1p_1 step coeff_2 * z^2
    let t47 = circuit_add(t35, t46); // Eval sparse poly line_1p_1 step + coeff_2 * z^2
    let t48 = circuit_add(t47, t1); // Eval sparse poly line_1p_1 step + 1*z^3
    let t49 = circuit_mul(t38, t2); // Eval sparse poly line_1p_1 step coeff_6 * z^6
    let t50 = circuit_add(t48, t49); // Eval sparse poly line_1p_1 step + coeff_6 * z^6
    let t51 = circuit_mul(t39, t3); // Eval sparse poly line_1p_1 step coeff_8 * z^8
    let t52 = circuit_add(t50, t51); // Eval sparse poly line_1p_1 step + coeff_8 * z^8
    let t53 = circuit_mul(t33, t52);
    let t54 = circuit_mul(t43, t0); // Eval sparse poly line_1p_2 step coeff_2 * z^2
    let t55 = circuit_add(t41, t54); // Eval sparse poly line_1p_2 step + coeff_2 * z^2
    let t56 = circuit_add(t55, t1); // Eval sparse poly line_1p_2 step + 1*z^3
    let t57 = circuit_mul(t44, t2); // Eval sparse poly line_1p_2 step coeff_6 * z^6
    let t58 = circuit_add(t56, t57); // Eval sparse poly line_1p_2 step + coeff_6 * z^6
    let t59 = circuit_mul(t45, t3); // Eval sparse poly line_1p_2 step coeff_8 * z^8
    let t60 = circuit_add(t58, t59); // Eval sparse poly line_1p_2 step + coeff_8 * z^8
    let t61 = circuit_mul(t53, t60);
    let t62 = circuit_add(in25, in26);
    let t63 = circuit_sub(in25, in26);
    let t64 = circuit_mul(t62, t63);
    let t65 = circuit_mul(in25, in26);
    let t66 = circuit_mul(t64, in0);
    let t67 = circuit_mul(t65, in1);
    let t68 = circuit_add(in27, in27); // Fp2 add coeff 0/1
    let t69 = circuit_add(in28, in28); // Fp2 add coeff 1/1
    let t70 = circuit_mul(t68, t68); // Fp2 Inv start
    let t71 = circuit_mul(t69, t69);
    let t72 = circuit_add(t70, t71);
    let t73 = circuit_inverse(t72);
    let t74 = circuit_mul(t68, t73); // Fp2 Inv real part end
    let t75 = circuit_mul(t69, t73);
    let t76 = circuit_sub(in2, t75); // Fp2 Inv imag part end
    let t77 = circuit_mul(t66, t74); // Fp2 mul start
    let t78 = circuit_mul(t67, t76);
    let t79 = circuit_sub(t77, t78); // Fp2 mul real part end
    let t80 = circuit_mul(t66, t76);
    let t81 = circuit_mul(t67, t74);
    let t82 = circuit_add(t80, t81); // Fp2 mul imag part end
    let t83 = circuit_mul(t79, in25); // Fp2 mul start
    let t84 = circuit_mul(t82, in26);
    let t85 = circuit_sub(t83, t84); // Fp2 mul real part end
    let t86 = circuit_mul(t79, in26);
    let t87 = circuit_mul(t82, in25);
    let t88 = circuit_add(t86, t87); // Fp2 mul imag part end
    let t89 = circuit_sub(t85, in27); // Fp2 sub coeff 0/1
    let t90 = circuit_sub(t88, in28); // Fp2 sub coeff 1/1
    let t91 = circuit_add(t79, t82);
    let t92 = circuit_sub(t79, t82);
    let t93 = circuit_mul(t91, t92);
    let t94 = circuit_mul(t79, t82);
    let t95 = circuit_add(t94, t94);
    let t96 = circuit_add(in25, in25); // Fp2 add coeff 0/1
    let t97 = circuit_add(in26, in26); // Fp2 add coeff 1/1
    let t98 = circuit_sub(t93, t96); // Fp2 sub coeff 0/1
    let t99 = circuit_sub(t95, t97); // Fp2 sub coeff 1/1
    let t100 = circuit_sub(in25, t98); // Fp2 sub coeff 0/1
    let t101 = circuit_sub(in26, t99); // Fp2 sub coeff 1/1
    let t102 = circuit_mul(t100, t100); // Fp2 Inv start
    let t103 = circuit_mul(t101, t101);
    let t104 = circuit_add(t102, t103);
    let t105 = circuit_inverse(t104);
    let t106 = circuit_mul(t100, t105); // Fp2 Inv real part end
    let t107 = circuit_mul(t101, t105);
    let t108 = circuit_sub(in2, t107); // Fp2 Inv imag part end
    let t109 = circuit_mul(t68, t106); // Fp2 mul start
    let t110 = circuit_mul(t69, t108);
    let t111 = circuit_sub(t109, t110); // Fp2 mul real part end
    let t112 = circuit_mul(t68, t108);
    let t113 = circuit_mul(t69, t106);
    let t114 = circuit_add(t112, t113); // Fp2 mul imag part end
    let t115 = circuit_sub(t111, t79); // Fp2 sub coeff 0/1
    let t116 = circuit_sub(t114, t82); // Fp2 sub coeff 1/1
    let t117 = circuit_mul(t115, in25); // Fp2 mul start
    let t118 = circuit_mul(t116, in26);
    let t119 = circuit_sub(t117, t118); // Fp2 mul real part end
    let t120 = circuit_mul(t115, in26);
    let t121 = circuit_mul(t116, in25);
    let t122 = circuit_add(t120, t121); // Fp2 mul imag part end
    let t123 = circuit_sub(t119, in27); // Fp2 sub coeff 0/1
    let t124 = circuit_sub(t122, in28); // Fp2 sub coeff 1/1
    let t125 = circuit_add(t115, t116);
    let t126 = circuit_sub(t115, t116);
    let t127 = circuit_mul(t125, t126);
    let t128 = circuit_mul(t115, t116);
    let t129 = circuit_add(t128, t128);
    let t130 = circuit_add(in25, t98); // Fp2 add coeff 0/1
    let t131 = circuit_add(in26, t99); // Fp2 add coeff 1/1
    let t132 = circuit_sub(t127, t130); // Fp2 sub coeff 0/1
    let t133 = circuit_sub(t129, t131); // Fp2 sub coeff 1/1
    let t134 = circuit_sub(in25, t132); // Fp2 sub coeff 0/1
    let t135 = circuit_sub(in26, t133); // Fp2 sub coeff 1/1
    let t136 = circuit_mul(t115, t134); // Fp2 mul start
    let t137 = circuit_mul(t116, t135);
    let t138 = circuit_sub(t136, t137); // Fp2 mul real part end
    let t139 = circuit_mul(t115, t135);
    let t140 = circuit_mul(t116, t134);
    let t141 = circuit_add(t139, t140); // Fp2 mul imag part end
    let t142 = circuit_sub(t138, in27); // Fp2 sub coeff 0/1
    let t143 = circuit_sub(t141, in28); // Fp2 sub coeff 1/1
    let t144 = circuit_sub(t89, t90);
    let t145 = circuit_mul(t144, in23); // eval bls line by yInv
    let t146 = circuit_sub(t79, t82);
    let t147 = circuit_mul(t146, in24); // eval blsline by xNegOverY
    let t148 = circuit_mul(t90, in23); // eval bls line by yInv
    let t149 = circuit_mul(t82, in24); // eval bls line by xNegOverY
    let t150 = circuit_sub(t123, t124);
    let t151 = circuit_mul(t150, in23); // eval bls line by yInv
    let t152 = circuit_sub(t115, t116);
    let t153 = circuit_mul(t152, in24); // eval blsline by xNegOverY
    let t154 = circuit_mul(t124, in23); // eval bls line by yInv
    let t155 = circuit_mul(t116, in24); // eval bls line by xNegOverY
    let t156 = circuit_mul(t147, t0); // Eval sparse poly line_2p_1 step coeff_2 * z^2
    let t157 = circuit_add(t145, t156); // Eval sparse poly line_2p_1 step + coeff_2 * z^2
    let t158 = circuit_add(t157, t1); // Eval sparse poly line_2p_1 step + 1*z^3
    let t159 = circuit_mul(t148, t2); // Eval sparse poly line_2p_1 step coeff_6 * z^6
    let t160 = circuit_add(t158, t159); // Eval sparse poly line_2p_1 step + coeff_6 * z^6
    let t161 = circuit_mul(t149, t3); // Eval sparse poly line_2p_1 step coeff_8 * z^8
    let t162 = circuit_add(t160, t161); // Eval sparse poly line_2p_1 step + coeff_8 * z^8
    let t163 = circuit_mul(t61, t162);
    let t164 = circuit_mul(t153, t0); // Eval sparse poly line_2p_2 step coeff_2 * z^2
    let t165 = circuit_add(t151, t164); // Eval sparse poly line_2p_2 step + coeff_2 * z^2
    let t166 = circuit_add(t165, t1); // Eval sparse poly line_2p_2 step + 1*z^3
    let t167 = circuit_mul(t154, t2); // Eval sparse poly line_2p_2 step coeff_6 * z^6
    let t168 = circuit_add(t166, t167); // Eval sparse poly line_2p_2 step + coeff_6 * z^6
    let t169 = circuit_mul(t155, t3); // Eval sparse poly line_2p_2 step coeff_8 * z^8
    let t170 = circuit_add(t168, t169); // Eval sparse poly line_2p_2 step + coeff_8 * z^8
    let t171 = circuit_mul(t163, t170);
    let t172 = circuit_sub(t171, in29); // ((Π(i,k) (Pk(z)) - Ri(z))

    let modulus = crate::definitions::get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (t132, t133, t142, t143, t172).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x3, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs.next_2([0x6, 0x0, 0x0, 0x0]); // in1
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in2
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(yInv_0); // in3
    circuit_inputs = circuit_inputs.next_2(xNegOverY_0); // in4
    circuit_inputs = circuit_inputs.next_2(G2_line_0.r0a0); // in5
    circuit_inputs = circuit_inputs.next_2(G2_line_0.r0a1); // in6
    circuit_inputs = circuit_inputs.next_2(G2_line_0.r1a0); // in7
    circuit_inputs = circuit_inputs.next_2(G2_line_0.r1a1); // in8
    circuit_inputs = circuit_inputs.next_2(G2_line_0_2.r0a0); // in9
    circuit_inputs = circuit_inputs.next_2(G2_line_0_2.r0a1); // in10
    circuit_inputs = circuit_inputs.next_2(G2_line_0_2.r1a0); // in11
    circuit_inputs = circuit_inputs.next_2(G2_line_0_2.r1a1); // in12
    circuit_inputs = circuit_inputs.next_2(yInv_1); // in13
    circuit_inputs = circuit_inputs.next_2(xNegOverY_1); // in14
    circuit_inputs = circuit_inputs.next_2(G2_line_1.r0a0); // in15
    circuit_inputs = circuit_inputs.next_2(G2_line_1.r0a1); // in16
    circuit_inputs = circuit_inputs.next_2(G2_line_1.r1a0); // in17
    circuit_inputs = circuit_inputs.next_2(G2_line_1.r1a1); // in18
    circuit_inputs = circuit_inputs.next_2(G2_line_1_2.r0a0); // in19
    circuit_inputs = circuit_inputs.next_2(G2_line_1_2.r0a1); // in20
    circuit_inputs = circuit_inputs.next_2(G2_line_1_2.r1a0); // in21
    circuit_inputs = circuit_inputs.next_2(G2_line_1_2.r1a1); // in22
    circuit_inputs = circuit_inputs.next_2(yInv_2); // in23
    circuit_inputs = circuit_inputs.next_2(xNegOverY_2); // in24
    circuit_inputs = circuit_inputs.next_2(Q_2.x0); // in25
    circuit_inputs = circuit_inputs.next_2(Q_2.x1); // in26
    circuit_inputs = circuit_inputs.next_2(Q_2.y0); // in27
    circuit_inputs = circuit_inputs.next_2(Q_2.y1); // in28
    circuit_inputs = circuit_inputs.next_2(R_i_of_z); // in29
    circuit_inputs = circuit_inputs.next_2(z); // in30
    circuit_inputs = circuit_inputs.next_2(c_inv_of_z); // in31

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let Q0: G2Point = G2Point {
        x0: outputs.get_output(t132),
        x1: outputs.get_output(t133),
        y0: outputs.get_output(t142),
        y1: outputs.get_output(t143),
    };
    let new_lhs: u384 = outputs.get_output(t172);
    return (Q0, new_lhs);
}
#[inline(always)]
pub fn run_BLS12_381_MP_CHECK_PREPARE_PAIRS_1P_circuit(p_0: G1Point) -> (BLSProcessedPair,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0

    // INPUT stack
    let (in1, in2) = (CE::<CI<1>> {}, CE::<CI<2>> {});
    let t0 = circuit_inverse(in2);
    let t1 = circuit_mul(in1, t0);
    let t2 = circuit_sub(in0, t1);

    let modulus = crate::definitions::get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (t0, t2).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in0
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(p_0.x); // in1
    circuit_inputs = circuit_inputs.next_2(p_0.y); // in2

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let p_0: BLSProcessedPair = BLSProcessedPair {
        yInv: outputs.get_output(t0), xNegOverY: outputs.get_output(t2),
    };
    return (p_0,);
}
#[inline(always)]
pub fn run_BLS12_381_MP_CHECK_PREPARE_PAIRS_2P_circuit(
    p_0: G1Point, p_1: G1Point,
) -> (BLSProcessedPair, BLSProcessedPair) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0

    // INPUT stack
    let (in1, in2, in3) = (CE::<CI<1>> {}, CE::<CI<2>> {}, CE::<CI<3>> {});
    let in4 = CE::<CI<4>> {};
    let t0 = circuit_inverse(in2);
    let t1 = circuit_mul(in1, t0);
    let t2 = circuit_sub(in0, t1);
    let t3 = circuit_inverse(in4);
    let t4 = circuit_mul(in3, t3);
    let t5 = circuit_sub(in0, t4);

    let modulus = crate::definitions::get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (t0, t2, t3, t5).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in0
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(p_0.x); // in1
    circuit_inputs = circuit_inputs.next_2(p_0.y); // in2
    circuit_inputs = circuit_inputs.next_2(p_1.x); // in3
    circuit_inputs = circuit_inputs.next_2(p_1.y); // in4

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let p_0: BLSProcessedPair = BLSProcessedPair {
        yInv: outputs.get_output(t0), xNegOverY: outputs.get_output(t2),
    };
    let p_1: BLSProcessedPair = BLSProcessedPair {
        yInv: outputs.get_output(t3), xNegOverY: outputs.get_output(t5),
    };
    return (p_0, p_1);
}
#[inline(always)]
pub fn run_BLS12_381_MP_CHECK_PREPARE_PAIRS_3P_circuit(
    p_0: G1Point, p_1: G1Point, p_2: G1Point,
) -> (BLSProcessedPair, BLSProcessedPair, BLSProcessedPair) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0

    // INPUT stack
    let (in1, in2, in3) = (CE::<CI<1>> {}, CE::<CI<2>> {}, CE::<CI<3>> {});
    let (in4, in5, in6) = (CE::<CI<4>> {}, CE::<CI<5>> {}, CE::<CI<6>> {});
    let t0 = circuit_inverse(in2);
    let t1 = circuit_mul(in1, t0);
    let t2 = circuit_sub(in0, t1);
    let t3 = circuit_inverse(in4);
    let t4 = circuit_mul(in3, t3);
    let t5 = circuit_sub(in0, t4);
    let t6 = circuit_inverse(in6);
    let t7 = circuit_mul(in5, t6);
    let t8 = circuit_sub(in0, t7);

    let modulus = crate::definitions::get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (t0, t2, t3, t5, t6, t8).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in0
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(p_0.x); // in1
    circuit_inputs = circuit_inputs.next_2(p_0.y); // in2
    circuit_inputs = circuit_inputs.next_2(p_1.x); // in3
    circuit_inputs = circuit_inputs.next_2(p_1.y); // in4
    circuit_inputs = circuit_inputs.next_2(p_2.x); // in5
    circuit_inputs = circuit_inputs.next_2(p_2.y); // in6

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let p_0: BLSProcessedPair = BLSProcessedPair {
        yInv: outputs.get_output(t0), xNegOverY: outputs.get_output(t2),
    };
    let p_1: BLSProcessedPair = BLSProcessedPair {
        yInv: outputs.get_output(t3), xNegOverY: outputs.get_output(t5),
    };
    let p_2: BLSProcessedPair = BLSProcessedPair {
        yInv: outputs.get_output(t6), xNegOverY: outputs.get_output(t8),
    };
    return (p_0, p_1, p_2);
}
#[inline(always)]
pub fn run_BN254_INITIALIZE_MPCHECK_EXT_MLR_circuit(
    lambda_root: E12D<u288>,
    z: u384,
    scaling_factor: MillerLoopResultScalingFactor<u288>,
    c_inv: E12D<u288>,
    precomputed_miller_loop_result: E12D<u288>,
) -> (u384, u384, u384, u384, u384, u384, u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x1
    let in1 = CE::<CI<1>> {}; // 0x12
    let in2 = CE::<CI<2>> {}; // 0x1d8c8daef3eee1e81b2522ec5eb28ded6895e1cdfde6a43f5daa971f3fa65955
    let in3 = CE::<CI<3>> {}; // 0x217e400dc9351e774e34e2ac06ead4000d14d1e242b29c567e9c385ce480a71a
    let in4 = CE::<CI<4>> {}; // 0x242b719062f6737b8481d22c6934ce844d72f250fd28d102c0d147b2f4d521a7
    let in5 = CE::<CI<5>> {}; // 0x359809094bd5c8e1b9c22d81246ffc2e794e17643ac198484b8d9094aa82536
    let in6 = CE::<CI<6>> {}; // 0x21436d48fcb50cc60dd4ef1e69a0c1f0dd2949fa6df7b44cbb259ef7cb58d5ed
    let in7 = CE::<CI<7>> {}; // 0x18857a58f3b5bb3038a4311a86919d9c7c6c15f88a4f4f0831364cf35f78f771
    let in8 = CE::<CI<8>> {}; // 0x2c84bbad27c3671562b7adefd44038ab3c0bbad96fc008e7d6998c82f7fc048b
    let in9 = CE::<CI<9>> {}; // 0xc33b1c70e4fd11b6d1eab6fcd18b99ad4afd096a8697e0c9c36d8ca3339a7b5
    let in10 = CE::<
        CI<10>,
    > {}; // 0x1b007294a55accce13fe08bea73305ff6bdac77c5371c546d428780a6e3dcfa8
    let in11 = CE::<
        CI<11>,
    > {}; // 0x215d42e7ac7bd17cefe88dd8e6965b3adae92c974f501fe811493d72543a3977
    let in12 = CE::<CI<12>> {}; // -0x1 % p
    let in13 = CE::<
        CI<13>,
    > {}; // 0x246996f3b4fae7e6a6327cfe12150b8e747992778eeec7e5ca5cf05f80f362ac
    let in14 = CE::<
        CI<14>,
    > {}; // 0x12d7c0c3ed42be419d2b22ca22ceca702eeb88c36a8b264dde75f4f798d6a3f2
    let in15 = CE::<
        CI<15>,
    > {}; // 0x16c9e55061ebae204ba4cc8bd75a079432ae2a1d0b7c9dce1665d51c640fcba2
    let in16 = CE::<CI<16>> {}; // 0xc38dce27e3b2cae33ce738a184c89d94a0e78406b48f98a7b4f4463e3a7dba0
    let in17 = CE::<CI<17>> {}; // 0x7c03cbcac41049a0704b5a7ec796f2b21807dc98fa25bd282d37f632623b0e3
    let in18 = CE::<CI<18>> {}; // 0xf20e129e47c9363aa7b569817e0966cba582096fa7a164080faed1f0d24275a
    let in19 = CE::<
        CI<19>,
    > {}; // 0x2c145edbe7fd8aee9f3a80b03b0b1c923685d2ea1bdec763c13b4711cd2b8126
    let in20 = CE::<CI<20>> {}; // 0x3df92c5b96e3914559897c6ad411fb25b75afb7f8b1c1a56586ff93e080f8bc
    let in21 = CE::<
        CI<21>,
    > {}; // 0x12acf2ca76fd0675a27fb246c7729f7db080cb99678e2ac024c6b8ee6e0c2c4b
    let in22 = CE::<
        CI<22>,
    > {}; // 0x1563dbde3bd6d35ba4523cf7da4e525e2ba6a3151500054667f8140c6a3f2d9f
    let in23 = CE::<
        CI<23>,
    > {}; // 0x30644e72e131a0295e6dd9e7e0acccb0c28f069fbb966e3de4bd44e5607cfd49
    let in24 = CE::<
        CI<24>,
    > {}; // 0x30644e72e131a0295e6dd9e7e0acccb0c28f069fbb966e3de4bd44e5607cfd48
    let in25 = CE::<CI<25>> {}; // 0x59e26bcea0d48bacd4f263f1acdb5c4f5763473177fffffe
    let in26 = CE::<CI<26>> {}; // 0x59e26bcea0d48bacd4f263f1acdb5c4f5763473177ffffff
    let in27 = CE::<
        CI<27>,
    > {}; // 0x13d0c369615f7bb0b2bdfa8fef85fa07122bde8d67dfc8fabd3581ad840ddd76
    let in28 = CE::<
        CI<28>,
    > {}; // 0x18a0f4219f4fdff6fc2bf531eb331a053a35744cac285af5685d3f90eacf7a66
    let in29 = CE::<CI<29>> {}; // 0xc3a5e9c462a654779c3e050c9ca2a428908a81264e2b5a5bf22f67654883ae6
    let in30 = CE::<
        CI<30>,
    > {}; // 0x2ce02aa5f9bf8cd65bdd2055c255cf9d9e08c1d9345582cc92fd973c74bd77f4
    let in31 = CE::<
        CI<31>,
    > {}; // 0x17ded419ed7be4f97fac149bfaefbac11b155498de227b850aea3f23790405d6
    let in32 = CE::<
        CI<32>,
    > {}; // 0x1bfe7b214c0294242fb81a8dccd8a9b4441d64f34150a79753fb0cd31cc99cc0
    let in33 = CE::<CI<33>> {}; // 0x697b9c523e0390ed15da0ec97a9b8346513297b9efaf0f0f1a228f0d5662fbd
    let in34 = CE::<CI<34>> {}; // 0x7a0e052f2b1c443b5186d6ac4c723b85d3f78a3182d2db0c413901c32b0c6fe
    let in35 = CE::<
        CI<35>,
    > {}; // 0x1b76a37fba85f3cd5dc79824a3792597356c892c39c0d06b220500933945267f
    let in36 = CE::<CI<36>> {}; // 0xabf8b60be77d7306cbeee33576139d7f03a5e397d439ec7694aa2bf4c0c101
    let in37 = CE::<
        CI<37>,
    > {}; // 0x1c938b097fd2247905924b2691fb5e5685558c04009201927eeb0a69546f1fd1
    let in38 = CE::<CI<38>> {}; // 0x4f1de41b3d1766fa9f30e6dec26094f0fdf31bf98ff2631380cab2baaa586de
    let in39 = CE::<
        CI<39>,
    > {}; // 0x2429efd69b073ae23e8c6565b7b72e1b0e78c27f038f14e77cfd95a083f4c261
    let in40 = CE::<
        CI<40>,
    > {}; // 0x28a411b634f09b8fb14b900e9507e9327600ecc7d8cf6ebab94d0cb3b2594c64
    let in41 = CE::<
        CI<41>,
    > {}; // 0x23d5e999e1910a12feb0f6ef0cd21d04a44a9e08737f96e55fe3ed9d730c239f
    let in42 = CE::<
        CI<42>,
    > {}; // 0x1465d351952f0c0588982b28b4a8aea95364059e272122f5e8257f43bbb36087
    let in43 = CE::<
        CI<43>,
    > {}; // 0x16db366a59b1dd0b9fb1b2282a48633d3e2ddaea200280211f25041384282499
    let in44 = CE::<
        CI<44>,
    > {}; // 0x28c36e1fee7fdbe60337d84bbcba34a53a41f1ee50449cdc780cfbfaa5cc3649

    // INPUT stack
    let (in45, in46, in47) = (CE::<CI<45>> {}, CE::<CI<46>> {}, CE::<CI<47>> {});
    let (in48, in49, in50) = (CE::<CI<48>> {}, CE::<CI<49>> {}, CE::<CI<50>> {});
    let (in51, in52, in53) = (CE::<CI<51>> {}, CE::<CI<52>> {}, CE::<CI<53>> {});
    let (in54, in55, in56) = (CE::<CI<54>> {}, CE::<CI<55>> {}, CE::<CI<56>> {});
    let (in57, in58, in59) = (CE::<CI<57>> {}, CE::<CI<58>> {}, CE::<CI<59>> {});
    let (in60, in61, in62) = (CE::<CI<60>> {}, CE::<CI<61>> {}, CE::<CI<62>> {});
    let (in63, in64, in65) = (CE::<CI<63>> {}, CE::<CI<64>> {}, CE::<CI<65>> {});
    let (in66, in67, in68) = (CE::<CI<66>> {}, CE::<CI<67>> {}, CE::<CI<68>> {});
    let (in69, in70, in71) = (CE::<CI<69>> {}, CE::<CI<70>> {}, CE::<CI<71>> {});
    let (in72, in73, in74) = (CE::<CI<72>> {}, CE::<CI<73>> {}, CE::<CI<74>> {});
    let (in75, in76, in77) = (CE::<CI<75>> {}, CE::<CI<76>> {}, CE::<CI<77>> {});
    let (in78, in79, in80) = (CE::<CI<78>> {}, CE::<CI<79>> {}, CE::<CI<80>> {});
    let (in81, in82, in83) = (CE::<CI<81>> {}, CE::<CI<82>> {}, CE::<CI<83>> {});
    let (in84, in85, in86) = (CE::<CI<84>> {}, CE::<CI<85>> {}, CE::<CI<86>> {});
    let in87 = CE::<CI<87>> {};
    let t0 = circuit_mul(in57, in57); // Compute z^2
    let t1 = circuit_mul(t0, in57); // Compute z^3
    let t2 = circuit_mul(t1, in57); // Compute z^4
    let t3 = circuit_mul(t2, in57); // Compute z^5
    let t4 = circuit_mul(t3, in57); // Compute z^6
    let t5 = circuit_mul(t4, in57); // Compute z^7
    let t6 = circuit_mul(t5, in57); // Compute z^8
    let t7 = circuit_mul(t6, in57); // Compute z^9
    let t8 = circuit_mul(t7, in57); // Compute z^10
    let t9 = circuit_mul(t8, in57); // Compute z^11
    let t10 = circuit_mul(in46, in57); // Eval C step coeff_1 * z^1
    let t11 = circuit_add(in45, t10); // Eval C step + (coeff_1 * z^1)
    let t12 = circuit_mul(in47, t0); // Eval C step coeff_2 * z^2
    let t13 = circuit_add(t11, t12); // Eval C step + (coeff_2 * z^2)
    let t14 = circuit_mul(in48, t1); // Eval C step coeff_3 * z^3
    let t15 = circuit_add(t13, t14); // Eval C step + (coeff_3 * z^3)
    let t16 = circuit_mul(in49, t2); // Eval C step coeff_4 * z^4
    let t17 = circuit_add(t15, t16); // Eval C step + (coeff_4 * z^4)
    let t18 = circuit_mul(in50, t3); // Eval C step coeff_5 * z^5
    let t19 = circuit_add(t17, t18); // Eval C step + (coeff_5 * z^5)
    let t20 = circuit_mul(in51, t4); // Eval C step coeff_6 * z^6
    let t21 = circuit_add(t19, t20); // Eval C step + (coeff_6 * z^6)
    let t22 = circuit_mul(in52, t5); // Eval C step coeff_7 * z^7
    let t23 = circuit_add(t21, t22); // Eval C step + (coeff_7 * z^7)
    let t24 = circuit_mul(in53, t6); // Eval C step coeff_8 * z^8
    let t25 = circuit_add(t23, t24); // Eval C step + (coeff_8 * z^8)
    let t26 = circuit_mul(in54, t7); // Eval C step coeff_9 * z^9
    let t27 = circuit_add(t25, t26); // Eval C step + (coeff_9 * z^9)
    let t28 = circuit_mul(in55, t8); // Eval C step coeff_10 * z^10
    let t29 = circuit_add(t27, t28); // Eval C step + (coeff_10 * z^10)
    let t30 = circuit_mul(in56, t9); // Eval C step coeff_11 * z^11
    let t31 = circuit_add(t29, t30); // Eval C step + (coeff_11 * z^11)
    let t32 = circuit_mul(in59, t0); // Eval sparse poly W step coeff_2 * z^2
    let t33 = circuit_add(in58, t32); // Eval sparse poly W step + coeff_2 * z^2
    let t34 = circuit_mul(in60, t2); // Eval sparse poly W step coeff_4 * z^4
    let t35 = circuit_add(t33, t34); // Eval sparse poly W step + coeff_4 * z^4
    let t36 = circuit_mul(in61, t4); // Eval sparse poly W step coeff_6 * z^6
    let t37 = circuit_add(t35, t36); // Eval sparse poly W step + coeff_6 * z^6
    let t38 = circuit_mul(in62, t6); // Eval sparse poly W step coeff_8 * z^8
    let t39 = circuit_add(t37, t38); // Eval sparse poly W step + coeff_8 * z^8
    let t40 = circuit_mul(in63, t8); // Eval sparse poly W step coeff_10 * z^10
    let t41 = circuit_add(t39, t40); // Eval sparse poly W step + coeff_10 * z^10
    let t42 = circuit_mul(in65, in57); // Eval C_inv step coeff_1 * z^1
    let t43 = circuit_add(in64, t42); // Eval C_inv step + (coeff_1 * z^1)
    let t44 = circuit_mul(in66, t0); // Eval C_inv step coeff_2 * z^2
    let t45 = circuit_add(t43, t44); // Eval C_inv step + (coeff_2 * z^2)
    let t46 = circuit_mul(in67, t1); // Eval C_inv step coeff_3 * z^3
    let t47 = circuit_add(t45, t46); // Eval C_inv step + (coeff_3 * z^3)
    let t48 = circuit_mul(in68, t2); // Eval C_inv step coeff_4 * z^4
    let t49 = circuit_add(t47, t48); // Eval C_inv step + (coeff_4 * z^4)
    let t50 = circuit_mul(in69, t3); // Eval C_inv step coeff_5 * z^5
    let t51 = circuit_add(t49, t50); // Eval C_inv step + (coeff_5 * z^5)
    let t52 = circuit_mul(in70, t4); // Eval C_inv step coeff_6 * z^6
    let t53 = circuit_add(t51, t52); // Eval C_inv step + (coeff_6 * z^6)
    let t54 = circuit_mul(in71, t5); // Eval C_inv step coeff_7 * z^7
    let t55 = circuit_add(t53, t54); // Eval C_inv step + (coeff_7 * z^7)
    let t56 = circuit_mul(in72, t6); // Eval C_inv step coeff_8 * z^8
    let t57 = circuit_add(t55, t56); // Eval C_inv step + (coeff_8 * z^8)
    let t58 = circuit_mul(in73, t7); // Eval C_inv step coeff_9 * z^9
    let t59 = circuit_add(t57, t58); // Eval C_inv step + (coeff_9 * z^9)
    let t60 = circuit_mul(in74, t8); // Eval C_inv step coeff_10 * z^10
    let t61 = circuit_add(t59, t60); // Eval C_inv step + (coeff_10 * z^10)
    let t62 = circuit_mul(in75, t9); // Eval C_inv step coeff_11 * z^11
    let t63 = circuit_add(t61, t62); // Eval C_inv step + (coeff_11 * z^11)
    let t64 = circuit_mul(t31, t63);
    let t65 = circuit_sub(t64, in0); // c_of_z * c_inv_of_z - 1
    let t66 = circuit_mul(in70, in1);
    let t67 = circuit_add(in64, t66);
    let t68 = circuit_mul(in65, in2);
    let t69 = circuit_mul(in71, in3);
    let t70 = circuit_add(t68, t69);
    let t71 = circuit_mul(in66, in4);
    let t72 = circuit_mul(in72, in5);
    let t73 = circuit_add(t71, t72);
    let t74 = circuit_mul(in67, in6);
    let t75 = circuit_mul(in73, in7);
    let t76 = circuit_add(t74, t75);
    let t77 = circuit_mul(in68, in8);
    let t78 = circuit_mul(in74, in9);
    let t79 = circuit_add(t77, t78);
    let t80 = circuit_mul(in69, in10);
    let t81 = circuit_mul(in75, in11);
    let t82 = circuit_add(t80, t81);
    let t83 = circuit_mul(in70, in12);
    let t84 = circuit_mul(in65, in13);
    let t85 = circuit_mul(in71, in14);
    let t86 = circuit_add(t84, t85);
    let t87 = circuit_mul(in66, in15);
    let t88 = circuit_mul(in72, in16);
    let t89 = circuit_add(t87, t88);
    let t90 = circuit_mul(in67, in17);
    let t91 = circuit_mul(in73, in18);
    let t92 = circuit_add(t90, t91);
    let t93 = circuit_mul(in68, in19);
    let t94 = circuit_mul(in74, in20);
    let t95 = circuit_add(t93, t94);
    let t96 = circuit_mul(in69, in21);
    let t97 = circuit_mul(in75, in22);
    let t98 = circuit_add(t96, t97);
    let t99 = circuit_mul(in46, in23);
    let t100 = circuit_mul(in47, in24);
    let t101 = circuit_mul(in48, in12);
    let t102 = circuit_mul(in49, in25);
    let t103 = circuit_mul(in50, in26);
    let t104 = circuit_mul(in52, in23);
    let t105 = circuit_mul(in53, in24);
    let t106 = circuit_mul(in54, in12);
    let t107 = circuit_mul(in55, in25);
    let t108 = circuit_mul(in56, in26);
    let t109 = circuit_mul(in70, in1);
    let t110 = circuit_add(in64, t109);
    let t111 = circuit_mul(in65, in27);
    let t112 = circuit_mul(in71, in28);
    let t113 = circuit_add(t111, t112);
    let t114 = circuit_mul(in66, in29);
    let t115 = circuit_mul(in72, in30);
    let t116 = circuit_add(t114, t115);
    let t117 = circuit_mul(in67, in18);
    let t118 = circuit_mul(in73, in31);
    let t119 = circuit_add(t117, t118);
    let t120 = circuit_mul(in68, in32);
    let t121 = circuit_mul(in74, in33);
    let t122 = circuit_add(t120, t121);
    let t123 = circuit_mul(in69, in34);
    let t124 = circuit_mul(in75, in35);
    let t125 = circuit_add(t123, t124);
    let t126 = circuit_mul(in70, in12);
    let t127 = circuit_mul(in65, in36);
    let t128 = circuit_mul(in71, in37);
    let t129 = circuit_add(t127, t128);
    let t130 = circuit_mul(in66, in38);
    let t131 = circuit_mul(in72, in39);
    let t132 = circuit_add(t130, t131);
    let t133 = circuit_mul(in67, in40);
    let t134 = circuit_mul(in73, in6);
    let t135 = circuit_add(t133, t134);
    let t136 = circuit_mul(in68, in41);
    let t137 = circuit_mul(in74, in42);
    let t138 = circuit_add(t136, t137);
    let t139 = circuit_mul(in69, in43);
    let t140 = circuit_mul(in75, in44);
    let t141 = circuit_add(t139, t140);
    let t142 = circuit_mul(t70, in57); // Eval C_inv_frob_1 step coeff_1 * z^1
    let t143 = circuit_add(t67, t142); // Eval C_inv_frob_1 step + (coeff_1 * z^1)
    let t144 = circuit_mul(t73, t0); // Eval C_inv_frob_1 step coeff_2 * z^2
    let t145 = circuit_add(t143, t144); // Eval C_inv_frob_1 step + (coeff_2 * z^2)
    let t146 = circuit_mul(t76, t1); // Eval C_inv_frob_1 step coeff_3 * z^3
    let t147 = circuit_add(t145, t146); // Eval C_inv_frob_1 step + (coeff_3 * z^3)
    let t148 = circuit_mul(t79, t2); // Eval C_inv_frob_1 step coeff_4 * z^4
    let t149 = circuit_add(t147, t148); // Eval C_inv_frob_1 step + (coeff_4 * z^4)
    let t150 = circuit_mul(t82, t3); // Eval C_inv_frob_1 step coeff_5 * z^5
    let t151 = circuit_add(t149, t150); // Eval C_inv_frob_1 step + (coeff_5 * z^5)
    let t152 = circuit_mul(t83, t4); // Eval C_inv_frob_1 step coeff_6 * z^6
    let t153 = circuit_add(t151, t152); // Eval C_inv_frob_1 step + (coeff_6 * z^6)
    let t154 = circuit_mul(t86, t5); // Eval C_inv_frob_1 step coeff_7 * z^7
    let t155 = circuit_add(t153, t154); // Eval C_inv_frob_1 step + (coeff_7 * z^7)
    let t156 = circuit_mul(t89, t6); // Eval C_inv_frob_1 step coeff_8 * z^8
    let t157 = circuit_add(t155, t156); // Eval C_inv_frob_1 step + (coeff_8 * z^8)
    let t158 = circuit_mul(t92, t7); // Eval C_inv_frob_1 step coeff_9 * z^9
    let t159 = circuit_add(t157, t158); // Eval C_inv_frob_1 step + (coeff_9 * z^9)
    let t160 = circuit_mul(t95, t8); // Eval C_inv_frob_1 step coeff_10 * z^10
    let t161 = circuit_add(t159, t160); // Eval C_inv_frob_1 step + (coeff_10 * z^10)
    let t162 = circuit_mul(t98, t9); // Eval C_inv_frob_1 step coeff_11 * z^11
    let t163 = circuit_add(t161, t162); // Eval C_inv_frob_1 step + (coeff_11 * z^11)
    let t164 = circuit_mul(t99, in57); // Eval C_frob_2 step coeff_1 * z^1
    let t165 = circuit_add(in45, t164); // Eval C_frob_2 step + (coeff_1 * z^1)
    let t166 = circuit_mul(t100, t0); // Eval C_frob_2 step coeff_2 * z^2
    let t167 = circuit_add(t165, t166); // Eval C_frob_2 step + (coeff_2 * z^2)
    let t168 = circuit_mul(t101, t1); // Eval C_frob_2 step coeff_3 * z^3
    let t169 = circuit_add(t167, t168); // Eval C_frob_2 step + (coeff_3 * z^3)
    let t170 = circuit_mul(t102, t2); // Eval C_frob_2 step coeff_4 * z^4
    let t171 = circuit_add(t169, t170); // Eval C_frob_2 step + (coeff_4 * z^4)
    let t172 = circuit_mul(t103, t3); // Eval C_frob_2 step coeff_5 * z^5
    let t173 = circuit_add(t171, t172); // Eval C_frob_2 step + (coeff_5 * z^5)
    let t174 = circuit_mul(in51, t4); // Eval C_frob_2 step coeff_6 * z^6
    let t175 = circuit_add(t173, t174); // Eval C_frob_2 step + (coeff_6 * z^6)
    let t176 = circuit_mul(t104, t5); // Eval C_frob_2 step coeff_7 * z^7
    let t177 = circuit_add(t175, t176); // Eval C_frob_2 step + (coeff_7 * z^7)
    let t178 = circuit_mul(t105, t6); // Eval C_frob_2 step coeff_8 * z^8
    let t179 = circuit_add(t177, t178); // Eval C_frob_2 step + (coeff_8 * z^8)
    let t180 = circuit_mul(t106, t7); // Eval C_frob_2 step coeff_9 * z^9
    let t181 = circuit_add(t179, t180); // Eval C_frob_2 step + (coeff_9 * z^9)
    let t182 = circuit_mul(t107, t8); // Eval C_frob_2 step coeff_10 * z^10
    let t183 = circuit_add(t181, t182); // Eval C_frob_2 step + (coeff_10 * z^10)
    let t184 = circuit_mul(t108, t9); // Eval C_frob_2 step coeff_11 * z^11
    let t185 = circuit_add(t183, t184); // Eval C_frob_2 step + (coeff_11 * z^11)
    let t186 = circuit_mul(t113, in57); // Eval C_inv_frob_3 step coeff_1 * z^1
    let t187 = circuit_add(t110, t186); // Eval C_inv_frob_3 step + (coeff_1 * z^1)
    let t188 = circuit_mul(t116, t0); // Eval C_inv_frob_3 step coeff_2 * z^2
    let t189 = circuit_add(t187, t188); // Eval C_inv_frob_3 step + (coeff_2 * z^2)
    let t190 = circuit_mul(t119, t1); // Eval C_inv_frob_3 step coeff_3 * z^3
    let t191 = circuit_add(t189, t190); // Eval C_inv_frob_3 step + (coeff_3 * z^3)
    let t192 = circuit_mul(t122, t2); // Eval C_inv_frob_3 step coeff_4 * z^4
    let t193 = circuit_add(t191, t192); // Eval C_inv_frob_3 step + (coeff_4 * z^4)
    let t194 = circuit_mul(t125, t3); // Eval C_inv_frob_3 step coeff_5 * z^5
    let t195 = circuit_add(t193, t194); // Eval C_inv_frob_3 step + (coeff_5 * z^5)
    let t196 = circuit_mul(t126, t4); // Eval C_inv_frob_3 step coeff_6 * z^6
    let t197 = circuit_add(t195, t196); // Eval C_inv_frob_3 step + (coeff_6 * z^6)
    let t198 = circuit_mul(t129, t5); // Eval C_inv_frob_3 step coeff_7 * z^7
    let t199 = circuit_add(t197, t198); // Eval C_inv_frob_3 step + (coeff_7 * z^7)
    let t200 = circuit_mul(t132, t6); // Eval C_inv_frob_3 step coeff_8 * z^8
    let t201 = circuit_add(t199, t200); // Eval C_inv_frob_3 step + (coeff_8 * z^8)
    let t202 = circuit_mul(t135, t7); // Eval C_inv_frob_3 step coeff_9 * z^9
    let t203 = circuit_add(t201, t202); // Eval C_inv_frob_3 step + (coeff_9 * z^9)
    let t204 = circuit_mul(t138, t8); // Eval C_inv_frob_3 step coeff_10 * z^10
    let t205 = circuit_add(t203, t204); // Eval C_inv_frob_3 step + (coeff_10 * z^10)
    let t206 = circuit_mul(t141, t9); // Eval C_inv_frob_3 step coeff_11 * z^11
    let t207 = circuit_add(t205, t206); // Eval C_inv_frob_3 step + (coeff_11 * z^11)
    let t208 = circuit_mul(in77, in57); // Eval precomputed_miller_loop_result step coeff_1 * z^1
    let t209 = circuit_add(
        in76, t208,
    ); // Eval precomputed_miller_loop_result step + (coeff_1 * z^1)
    let t210 = circuit_mul(in78, t0); // Eval precomputed_miller_loop_result step coeff_2 * z^2
    let t211 = circuit_add(
        t209, t210,
    ); // Eval precomputed_miller_loop_result step + (coeff_2 * z^2)
    let t212 = circuit_mul(in79, t1); // Eval precomputed_miller_loop_result step coeff_3 * z^3
    let t213 = circuit_add(
        t211, t212,
    ); // Eval precomputed_miller_loop_result step + (coeff_3 * z^3)
    let t214 = circuit_mul(in80, t2); // Eval precomputed_miller_loop_result step coeff_4 * z^4
    let t215 = circuit_add(
        t213, t214,
    ); // Eval precomputed_miller_loop_result step + (coeff_4 * z^4)
    let t216 = circuit_mul(in81, t3); // Eval precomputed_miller_loop_result step coeff_5 * z^5
    let t217 = circuit_add(
        t215, t216,
    ); // Eval precomputed_miller_loop_result step + (coeff_5 * z^5)
    let t218 = circuit_mul(in82, t4); // Eval precomputed_miller_loop_result step coeff_6 * z^6
    let t219 = circuit_add(
        t217, t218,
    ); // Eval precomputed_miller_loop_result step + (coeff_6 * z^6)
    let t220 = circuit_mul(in83, t5); // Eval precomputed_miller_loop_result step coeff_7 * z^7
    let t221 = circuit_add(
        t219, t220,
    ); // Eval precomputed_miller_loop_result step + (coeff_7 * z^7)
    let t222 = circuit_mul(in84, t6); // Eval precomputed_miller_loop_result step coeff_8 * z^8
    let t223 = circuit_add(
        t221, t222,
    ); // Eval precomputed_miller_loop_result step + (coeff_8 * z^8)
    let t224 = circuit_mul(in85, t7); // Eval precomputed_miller_loop_result step coeff_9 * z^9
    let t225 = circuit_add(
        t223, t224,
    ); // Eval precomputed_miller_loop_result step + (coeff_9 * z^9)
    let t226 = circuit_mul(in86, t8); // Eval precomputed_miller_loop_result step coeff_10 * z^10
    let t227 = circuit_add(
        t225, t226,
    ); // Eval precomputed_miller_loop_result step + (coeff_10 * z^10)
    let t228 = circuit_mul(in87, t9); // Eval precomputed_miller_loop_result step coeff_11 * z^11
    let t229 = circuit_add(
        t227, t228,
    ); // Eval precomputed_miller_loop_result step + (coeff_11 * z^11)

    let modulus = crate::definitions::get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (t31, t41, t63, t65, t163, t185, t207, t229).new_inputs();
    // Prefill constants:

    circuit_inputs = circuit_inputs
        .next_span(INITIALIZE_MPCHECK_EXT_MLR_BN254_CONSTANTS.span()); // in0 - in44

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(lambda_root.w0); // in45
    circuit_inputs = circuit_inputs.next_2(lambda_root.w1); // in46
    circuit_inputs = circuit_inputs.next_2(lambda_root.w2); // in47
    circuit_inputs = circuit_inputs.next_2(lambda_root.w3); // in48
    circuit_inputs = circuit_inputs.next_2(lambda_root.w4); // in49
    circuit_inputs = circuit_inputs.next_2(lambda_root.w5); // in50
    circuit_inputs = circuit_inputs.next_2(lambda_root.w6); // in51
    circuit_inputs = circuit_inputs.next_2(lambda_root.w7); // in52
    circuit_inputs = circuit_inputs.next_2(lambda_root.w8); // in53
    circuit_inputs = circuit_inputs.next_2(lambda_root.w9); // in54
    circuit_inputs = circuit_inputs.next_2(lambda_root.w10); // in55
    circuit_inputs = circuit_inputs.next_2(lambda_root.w11); // in56
    circuit_inputs = circuit_inputs.next_2(z); // in57
    circuit_inputs = circuit_inputs.next_2(scaling_factor.w0); // in58
    circuit_inputs = circuit_inputs.next_2(scaling_factor.w2); // in59
    circuit_inputs = circuit_inputs.next_2(scaling_factor.w4); // in60
    circuit_inputs = circuit_inputs.next_2(scaling_factor.w6); // in61
    circuit_inputs = circuit_inputs.next_2(scaling_factor.w8); // in62
    circuit_inputs = circuit_inputs.next_2(scaling_factor.w10); // in63
    circuit_inputs = circuit_inputs.next_2(c_inv.w0); // in64
    circuit_inputs = circuit_inputs.next_2(c_inv.w1); // in65
    circuit_inputs = circuit_inputs.next_2(c_inv.w2); // in66
    circuit_inputs = circuit_inputs.next_2(c_inv.w3); // in67
    circuit_inputs = circuit_inputs.next_2(c_inv.w4); // in68
    circuit_inputs = circuit_inputs.next_2(c_inv.w5); // in69
    circuit_inputs = circuit_inputs.next_2(c_inv.w6); // in70
    circuit_inputs = circuit_inputs.next_2(c_inv.w7); // in71
    circuit_inputs = circuit_inputs.next_2(c_inv.w8); // in72
    circuit_inputs = circuit_inputs.next_2(c_inv.w9); // in73
    circuit_inputs = circuit_inputs.next_2(c_inv.w10); // in74
    circuit_inputs = circuit_inputs.next_2(c_inv.w11); // in75
    circuit_inputs = circuit_inputs.next_2(precomputed_miller_loop_result.w0); // in76
    circuit_inputs = circuit_inputs.next_2(precomputed_miller_loop_result.w1); // in77
    circuit_inputs = circuit_inputs.next_2(precomputed_miller_loop_result.w2); // in78
    circuit_inputs = circuit_inputs.next_2(precomputed_miller_loop_result.w3); // in79
    circuit_inputs = circuit_inputs.next_2(precomputed_miller_loop_result.w4); // in80
    circuit_inputs = circuit_inputs.next_2(precomputed_miller_loop_result.w5); // in81
    circuit_inputs = circuit_inputs.next_2(precomputed_miller_loop_result.w6); // in82
    circuit_inputs = circuit_inputs.next_2(precomputed_miller_loop_result.w7); // in83
    circuit_inputs = circuit_inputs.next_2(precomputed_miller_loop_result.w8); // in84
    circuit_inputs = circuit_inputs.next_2(precomputed_miller_loop_result.w9); // in85
    circuit_inputs = circuit_inputs.next_2(precomputed_miller_loop_result.w10); // in86
    circuit_inputs = circuit_inputs.next_2(precomputed_miller_loop_result.w11); // in87

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let c_of_z: u384 = outputs.get_output(t31);
    let scaling_factor_of_z: u384 = outputs.get_output(t41);
    let c_inv_of_z: u384 = outputs.get_output(t63);
    let lhs: u384 = outputs.get_output(t65);
    let c_inv_frob_1_of_z: u384 = outputs.get_output(t163);
    let c_frob_2_of_z: u384 = outputs.get_output(t185);
    let c_inv_frob_3_of_z: u384 = outputs.get_output(t207);
    let precomputed_miller_loop_result_of_z: u384 = outputs.get_output(t229);
    return (
        c_of_z,
        scaling_factor_of_z,
        c_inv_of_z,
        lhs,
        c_inv_frob_1_of_z,
        c_frob_2_of_z,
        c_inv_frob_3_of_z,
        precomputed_miller_loop_result_of_z,
    );
}
const INITIALIZE_MPCHECK_EXT_MLR_BN254_CONSTANTS: [u384; 45] = [
    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x12, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 {
        limb0: 0xfde6a43f5daa971f3fa65955,
        limb1: 0x1b2522ec5eb28ded6895e1cd,
        limb2: 0x1d8c8daef3eee1e8,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x42b29c567e9c385ce480a71a,
        limb1: 0x4e34e2ac06ead4000d14d1e2,
        limb2: 0x217e400dc9351e77,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xfd28d102c0d147b2f4d521a7,
        limb1: 0x8481d22c6934ce844d72f250,
        limb2: 0x242b719062f6737b,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x43ac198484b8d9094aa82536,
        limb1: 0x1b9c22d81246ffc2e794e176,
        limb2: 0x359809094bd5c8e,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x6df7b44cbb259ef7cb58d5ed,
        limb1: 0xdd4ef1e69a0c1f0dd2949fa,
        limb2: 0x21436d48fcb50cc6,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x8a4f4f0831364cf35f78f771,
        limb1: 0x38a4311a86919d9c7c6c15f8,
        limb2: 0x18857a58f3b5bb30,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x6fc008e7d6998c82f7fc048b,
        limb1: 0x62b7adefd44038ab3c0bbad9,
        limb2: 0x2c84bbad27c36715,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xa8697e0c9c36d8ca3339a7b5,
        limb1: 0x6d1eab6fcd18b99ad4afd096,
        limb2: 0xc33b1c70e4fd11b,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x5371c546d428780a6e3dcfa8,
        limb1: 0x13fe08bea73305ff6bdac77c,
        limb2: 0x1b007294a55accce,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x4f501fe811493d72543a3977,
        limb1: 0xefe88dd8e6965b3adae92c97,
        limb2: 0x215d42e7ac7bd17c,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x6871ca8d3c208c16d87cfd46,
        limb1: 0xb85045b68181585d97816a91,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x8eeec7e5ca5cf05f80f362ac,
        limb1: 0xa6327cfe12150b8e74799277,
        limb2: 0x246996f3b4fae7e6,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x6a8b264dde75f4f798d6a3f2,
        limb1: 0x9d2b22ca22ceca702eeb88c3,
        limb2: 0x12d7c0c3ed42be41,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xb7c9dce1665d51c640fcba2,
        limb1: 0x4ba4cc8bd75a079432ae2a1d,
        limb2: 0x16c9e55061ebae20,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x6b48f98a7b4f4463e3a7dba0,
        limb1: 0x33ce738a184c89d94a0e7840,
        limb2: 0xc38dce27e3b2cae,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x8fa25bd282d37f632623b0e3,
        limb1: 0x704b5a7ec796f2b21807dc9,
        limb2: 0x7c03cbcac41049a,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xfa7a164080faed1f0d24275a,
        limb1: 0xaa7b569817e0966cba582096,
        limb2: 0xf20e129e47c9363,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x1bdec763c13b4711cd2b8126,
        limb1: 0x9f3a80b03b0b1c923685d2ea,
        limb2: 0x2c145edbe7fd8aee,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xf8b1c1a56586ff93e080f8bc,
        limb1: 0x559897c6ad411fb25b75afb7,
        limb2: 0x3df92c5b96e3914,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x678e2ac024c6b8ee6e0c2c4b,
        limb1: 0xa27fb246c7729f7db080cb99,
        limb2: 0x12acf2ca76fd0675,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x1500054667f8140c6a3f2d9f,
        limb1: 0xa4523cf7da4e525e2ba6a315,
        limb2: 0x1563dbde3bd6d35b,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xbb966e3de4bd44e5607cfd49,
        limb1: 0x5e6dd9e7e0acccb0c28f069f,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xbb966e3de4bd44e5607cfd48,
        limb1: 0x5e6dd9e7e0acccb0c28f069f,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xacdb5c4f5763473177fffffe,
        limb1: 0x59e26bcea0d48bacd4f263f1,
        limb2: 0x0,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xacdb5c4f5763473177ffffff,
        limb1: 0x59e26bcea0d48bacd4f263f1,
        limb2: 0x0,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x67dfc8fabd3581ad840ddd76,
        limb1: 0xb2bdfa8fef85fa07122bde8d,
        limb2: 0x13d0c369615f7bb0,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xac285af5685d3f90eacf7a66,
        limb1: 0xfc2bf531eb331a053a35744c,
        limb2: 0x18a0f4219f4fdff6,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x64e2b5a5bf22f67654883ae6,
        limb1: 0x79c3e050c9ca2a428908a812,
        limb2: 0xc3a5e9c462a6547,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x345582cc92fd973c74bd77f4,
        limb1: 0x5bdd2055c255cf9d9e08c1d9,
        limb2: 0x2ce02aa5f9bf8cd6,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xde227b850aea3f23790405d6,
        limb1: 0x7fac149bfaefbac11b155498,
        limb2: 0x17ded419ed7be4f9,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x4150a79753fb0cd31cc99cc0,
        limb1: 0x2fb81a8dccd8a9b4441d64f3,
        limb2: 0x1bfe7b214c029424,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x9efaf0f0f1a228f0d5662fbd,
        limb1: 0xd15da0ec97a9b8346513297b,
        limb2: 0x697b9c523e0390e,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x182d2db0c413901c32b0c6fe,
        limb1: 0xb5186d6ac4c723b85d3f78a3,
        limb2: 0x7a0e052f2b1c443,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x39c0d06b220500933945267f,
        limb1: 0x5dc79824a3792597356c892c,
        limb2: 0x1b76a37fba85f3cd,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x97d439ec7694aa2bf4c0c101,
        limb1: 0x6cbeee33576139d7f03a5e3,
        limb2: 0xabf8b60be77d73,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x9201927eeb0a69546f1fd1,
        limb1: 0x5924b2691fb5e5685558c04,
        limb2: 0x1c938b097fd22479,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x98ff2631380cab2baaa586de,
        limb1: 0xa9f30e6dec26094f0fdf31bf,
        limb2: 0x4f1de41b3d1766f,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x38f14e77cfd95a083f4c261,
        limb1: 0x3e8c6565b7b72e1b0e78c27f,
        limb2: 0x2429efd69b073ae2,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xd8cf6ebab94d0cb3b2594c64,
        limb1: 0xb14b900e9507e9327600ecc7,
        limb2: 0x28a411b634f09b8f,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x737f96e55fe3ed9d730c239f,
        limb1: 0xfeb0f6ef0cd21d04a44a9e08,
        limb2: 0x23d5e999e1910a12,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x272122f5e8257f43bbb36087,
        limb1: 0x88982b28b4a8aea95364059e,
        limb2: 0x1465d351952f0c05,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x200280211f25041384282499,
        limb1: 0x9fb1b2282a48633d3e2ddaea,
        limb2: 0x16db366a59b1dd0b,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x50449cdc780cfbfaa5cc3649,
        limb1: 0x337d84bbcba34a53a41f1ee,
        limb2: 0x28c36e1fee7fdbe6,
        limb3: 0x0,
    },
];
#[inline(always)]
pub fn run_BN254_INITIALIZE_MPCHECK_circuit(
    lambda_root: E12D<u288>,
    z: u384,
    scaling_factor: MillerLoopResultScalingFactor<u288>,
    c_inv: E12D<u288>,
) -> (u384, u384, u384, u384, u384, u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x1
    let in1 = CE::<CI<1>> {}; // 0x12
    let in2 = CE::<CI<2>> {}; // 0x1d8c8daef3eee1e81b2522ec5eb28ded6895e1cdfde6a43f5daa971f3fa65955
    let in3 = CE::<CI<3>> {}; // 0x217e400dc9351e774e34e2ac06ead4000d14d1e242b29c567e9c385ce480a71a
    let in4 = CE::<CI<4>> {}; // 0x242b719062f6737b8481d22c6934ce844d72f250fd28d102c0d147b2f4d521a7
    let in5 = CE::<CI<5>> {}; // 0x359809094bd5c8e1b9c22d81246ffc2e794e17643ac198484b8d9094aa82536
    let in6 = CE::<CI<6>> {}; // 0x21436d48fcb50cc60dd4ef1e69a0c1f0dd2949fa6df7b44cbb259ef7cb58d5ed
    let in7 = CE::<CI<7>> {}; // 0x18857a58f3b5bb3038a4311a86919d9c7c6c15f88a4f4f0831364cf35f78f771
    let in8 = CE::<CI<8>> {}; // 0x2c84bbad27c3671562b7adefd44038ab3c0bbad96fc008e7d6998c82f7fc048b
    let in9 = CE::<CI<9>> {}; // 0xc33b1c70e4fd11b6d1eab6fcd18b99ad4afd096a8697e0c9c36d8ca3339a7b5
    let in10 = CE::<
        CI<10>,
    > {}; // 0x1b007294a55accce13fe08bea73305ff6bdac77c5371c546d428780a6e3dcfa8
    let in11 = CE::<
        CI<11>,
    > {}; // 0x215d42e7ac7bd17cefe88dd8e6965b3adae92c974f501fe811493d72543a3977
    let in12 = CE::<CI<12>> {}; // -0x1 % p
    let in13 = CE::<
        CI<13>,
    > {}; // 0x246996f3b4fae7e6a6327cfe12150b8e747992778eeec7e5ca5cf05f80f362ac
    let in14 = CE::<
        CI<14>,
    > {}; // 0x12d7c0c3ed42be419d2b22ca22ceca702eeb88c36a8b264dde75f4f798d6a3f2
    let in15 = CE::<
        CI<15>,
    > {}; // 0x16c9e55061ebae204ba4cc8bd75a079432ae2a1d0b7c9dce1665d51c640fcba2
    let in16 = CE::<CI<16>> {}; // 0xc38dce27e3b2cae33ce738a184c89d94a0e78406b48f98a7b4f4463e3a7dba0
    let in17 = CE::<CI<17>> {}; // 0x7c03cbcac41049a0704b5a7ec796f2b21807dc98fa25bd282d37f632623b0e3
    let in18 = CE::<CI<18>> {}; // 0xf20e129e47c9363aa7b569817e0966cba582096fa7a164080faed1f0d24275a
    let in19 = CE::<
        CI<19>,
    > {}; // 0x2c145edbe7fd8aee9f3a80b03b0b1c923685d2ea1bdec763c13b4711cd2b8126
    let in20 = CE::<CI<20>> {}; // 0x3df92c5b96e3914559897c6ad411fb25b75afb7f8b1c1a56586ff93e080f8bc
    let in21 = CE::<
        CI<21>,
    > {}; // 0x12acf2ca76fd0675a27fb246c7729f7db080cb99678e2ac024c6b8ee6e0c2c4b
    let in22 = CE::<
        CI<22>,
    > {}; // 0x1563dbde3bd6d35ba4523cf7da4e525e2ba6a3151500054667f8140c6a3f2d9f
    let in23 = CE::<
        CI<23>,
    > {}; // 0x30644e72e131a0295e6dd9e7e0acccb0c28f069fbb966e3de4bd44e5607cfd49
    let in24 = CE::<
        CI<24>,
    > {}; // 0x30644e72e131a0295e6dd9e7e0acccb0c28f069fbb966e3de4bd44e5607cfd48
    let in25 = CE::<CI<25>> {}; // 0x59e26bcea0d48bacd4f263f1acdb5c4f5763473177fffffe
    let in26 = CE::<CI<26>> {}; // 0x59e26bcea0d48bacd4f263f1acdb5c4f5763473177ffffff
    let in27 = CE::<
        CI<27>,
    > {}; // 0x13d0c369615f7bb0b2bdfa8fef85fa07122bde8d67dfc8fabd3581ad840ddd76
    let in28 = CE::<
        CI<28>,
    > {}; // 0x18a0f4219f4fdff6fc2bf531eb331a053a35744cac285af5685d3f90eacf7a66
    let in29 = CE::<CI<29>> {}; // 0xc3a5e9c462a654779c3e050c9ca2a428908a81264e2b5a5bf22f67654883ae6
    let in30 = CE::<
        CI<30>,
    > {}; // 0x2ce02aa5f9bf8cd65bdd2055c255cf9d9e08c1d9345582cc92fd973c74bd77f4
    let in31 = CE::<
        CI<31>,
    > {}; // 0x17ded419ed7be4f97fac149bfaefbac11b155498de227b850aea3f23790405d6
    let in32 = CE::<
        CI<32>,
    > {}; // 0x1bfe7b214c0294242fb81a8dccd8a9b4441d64f34150a79753fb0cd31cc99cc0
    let in33 = CE::<CI<33>> {}; // 0x697b9c523e0390ed15da0ec97a9b8346513297b9efaf0f0f1a228f0d5662fbd
    let in34 = CE::<CI<34>> {}; // 0x7a0e052f2b1c443b5186d6ac4c723b85d3f78a3182d2db0c413901c32b0c6fe
    let in35 = CE::<
        CI<35>,
    > {}; // 0x1b76a37fba85f3cd5dc79824a3792597356c892c39c0d06b220500933945267f
    let in36 = CE::<CI<36>> {}; // 0xabf8b60be77d7306cbeee33576139d7f03a5e397d439ec7694aa2bf4c0c101
    let in37 = CE::<
        CI<37>,
    > {}; // 0x1c938b097fd2247905924b2691fb5e5685558c04009201927eeb0a69546f1fd1
    let in38 = CE::<CI<38>> {}; // 0x4f1de41b3d1766fa9f30e6dec26094f0fdf31bf98ff2631380cab2baaa586de
    let in39 = CE::<
        CI<39>,
    > {}; // 0x2429efd69b073ae23e8c6565b7b72e1b0e78c27f038f14e77cfd95a083f4c261
    let in40 = CE::<
        CI<40>,
    > {}; // 0x28a411b634f09b8fb14b900e9507e9327600ecc7d8cf6ebab94d0cb3b2594c64
    let in41 = CE::<
        CI<41>,
    > {}; // 0x23d5e999e1910a12feb0f6ef0cd21d04a44a9e08737f96e55fe3ed9d730c239f
    let in42 = CE::<
        CI<42>,
    > {}; // 0x1465d351952f0c0588982b28b4a8aea95364059e272122f5e8257f43bbb36087
    let in43 = CE::<
        CI<43>,
    > {}; // 0x16db366a59b1dd0b9fb1b2282a48633d3e2ddaea200280211f25041384282499
    let in44 = CE::<
        CI<44>,
    > {}; // 0x28c36e1fee7fdbe60337d84bbcba34a53a41f1ee50449cdc780cfbfaa5cc3649

    // INPUT stack
    let (in45, in46, in47) = (CE::<CI<45>> {}, CE::<CI<46>> {}, CE::<CI<47>> {});
    let (in48, in49, in50) = (CE::<CI<48>> {}, CE::<CI<49>> {}, CE::<CI<50>> {});
    let (in51, in52, in53) = (CE::<CI<51>> {}, CE::<CI<52>> {}, CE::<CI<53>> {});
    let (in54, in55, in56) = (CE::<CI<54>> {}, CE::<CI<55>> {}, CE::<CI<56>> {});
    let (in57, in58, in59) = (CE::<CI<57>> {}, CE::<CI<58>> {}, CE::<CI<59>> {});
    let (in60, in61, in62) = (CE::<CI<60>> {}, CE::<CI<61>> {}, CE::<CI<62>> {});
    let (in63, in64, in65) = (CE::<CI<63>> {}, CE::<CI<64>> {}, CE::<CI<65>> {});
    let (in66, in67, in68) = (CE::<CI<66>> {}, CE::<CI<67>> {}, CE::<CI<68>> {});
    let (in69, in70, in71) = (CE::<CI<69>> {}, CE::<CI<70>> {}, CE::<CI<71>> {});
    let (in72, in73, in74) = (CE::<CI<72>> {}, CE::<CI<73>> {}, CE::<CI<74>> {});
    let in75 = CE::<CI<75>> {};
    let t0 = circuit_mul(in57, in57); // Compute z^2
    let t1 = circuit_mul(t0, in57); // Compute z^3
    let t2 = circuit_mul(t1, in57); // Compute z^4
    let t3 = circuit_mul(t2, in57); // Compute z^5
    let t4 = circuit_mul(t3, in57); // Compute z^6
    let t5 = circuit_mul(t4, in57); // Compute z^7
    let t6 = circuit_mul(t5, in57); // Compute z^8
    let t7 = circuit_mul(t6, in57); // Compute z^9
    let t8 = circuit_mul(t7, in57); // Compute z^10
    let t9 = circuit_mul(t8, in57); // Compute z^11
    let t10 = circuit_mul(in46, in57); // Eval C step coeff_1 * z^1
    let t11 = circuit_add(in45, t10); // Eval C step + (coeff_1 * z^1)
    let t12 = circuit_mul(in47, t0); // Eval C step coeff_2 * z^2
    let t13 = circuit_add(t11, t12); // Eval C step + (coeff_2 * z^2)
    let t14 = circuit_mul(in48, t1); // Eval C step coeff_3 * z^3
    let t15 = circuit_add(t13, t14); // Eval C step + (coeff_3 * z^3)
    let t16 = circuit_mul(in49, t2); // Eval C step coeff_4 * z^4
    let t17 = circuit_add(t15, t16); // Eval C step + (coeff_4 * z^4)
    let t18 = circuit_mul(in50, t3); // Eval C step coeff_5 * z^5
    let t19 = circuit_add(t17, t18); // Eval C step + (coeff_5 * z^5)
    let t20 = circuit_mul(in51, t4); // Eval C step coeff_6 * z^6
    let t21 = circuit_add(t19, t20); // Eval C step + (coeff_6 * z^6)
    let t22 = circuit_mul(in52, t5); // Eval C step coeff_7 * z^7
    let t23 = circuit_add(t21, t22); // Eval C step + (coeff_7 * z^7)
    let t24 = circuit_mul(in53, t6); // Eval C step coeff_8 * z^8
    let t25 = circuit_add(t23, t24); // Eval C step + (coeff_8 * z^8)
    let t26 = circuit_mul(in54, t7); // Eval C step coeff_9 * z^9
    let t27 = circuit_add(t25, t26); // Eval C step + (coeff_9 * z^9)
    let t28 = circuit_mul(in55, t8); // Eval C step coeff_10 * z^10
    let t29 = circuit_add(t27, t28); // Eval C step + (coeff_10 * z^10)
    let t30 = circuit_mul(in56, t9); // Eval C step coeff_11 * z^11
    let t31 = circuit_add(t29, t30); // Eval C step + (coeff_11 * z^11)
    let t32 = circuit_mul(in59, t0); // Eval sparse poly W step coeff_2 * z^2
    let t33 = circuit_add(in58, t32); // Eval sparse poly W step + coeff_2 * z^2
    let t34 = circuit_mul(in60, t2); // Eval sparse poly W step coeff_4 * z^4
    let t35 = circuit_add(t33, t34); // Eval sparse poly W step + coeff_4 * z^4
    let t36 = circuit_mul(in61, t4); // Eval sparse poly W step coeff_6 * z^6
    let t37 = circuit_add(t35, t36); // Eval sparse poly W step + coeff_6 * z^6
    let t38 = circuit_mul(in62, t6); // Eval sparse poly W step coeff_8 * z^8
    let t39 = circuit_add(t37, t38); // Eval sparse poly W step + coeff_8 * z^8
    let t40 = circuit_mul(in63, t8); // Eval sparse poly W step coeff_10 * z^10
    let t41 = circuit_add(t39, t40); // Eval sparse poly W step + coeff_10 * z^10
    let t42 = circuit_mul(in65, in57); // Eval C_inv step coeff_1 * z^1
    let t43 = circuit_add(in64, t42); // Eval C_inv step + (coeff_1 * z^1)
    let t44 = circuit_mul(in66, t0); // Eval C_inv step coeff_2 * z^2
    let t45 = circuit_add(t43, t44); // Eval C_inv step + (coeff_2 * z^2)
    let t46 = circuit_mul(in67, t1); // Eval C_inv step coeff_3 * z^3
    let t47 = circuit_add(t45, t46); // Eval C_inv step + (coeff_3 * z^3)
    let t48 = circuit_mul(in68, t2); // Eval C_inv step coeff_4 * z^4
    let t49 = circuit_add(t47, t48); // Eval C_inv step + (coeff_4 * z^4)
    let t50 = circuit_mul(in69, t3); // Eval C_inv step coeff_5 * z^5
    let t51 = circuit_add(t49, t50); // Eval C_inv step + (coeff_5 * z^5)
    let t52 = circuit_mul(in70, t4); // Eval C_inv step coeff_6 * z^6
    let t53 = circuit_add(t51, t52); // Eval C_inv step + (coeff_6 * z^6)
    let t54 = circuit_mul(in71, t5); // Eval C_inv step coeff_7 * z^7
    let t55 = circuit_add(t53, t54); // Eval C_inv step + (coeff_7 * z^7)
    let t56 = circuit_mul(in72, t6); // Eval C_inv step coeff_8 * z^8
    let t57 = circuit_add(t55, t56); // Eval C_inv step + (coeff_8 * z^8)
    let t58 = circuit_mul(in73, t7); // Eval C_inv step coeff_9 * z^9
    let t59 = circuit_add(t57, t58); // Eval C_inv step + (coeff_9 * z^9)
    let t60 = circuit_mul(in74, t8); // Eval C_inv step coeff_10 * z^10
    let t61 = circuit_add(t59, t60); // Eval C_inv step + (coeff_10 * z^10)
    let t62 = circuit_mul(in75, t9); // Eval C_inv step coeff_11 * z^11
    let t63 = circuit_add(t61, t62); // Eval C_inv step + (coeff_11 * z^11)
    let t64 = circuit_mul(t31, t63);
    let t65 = circuit_sub(t64, in0); // c_of_z * c_inv_of_z - 1
    let t66 = circuit_mul(in70, in1);
    let t67 = circuit_add(in64, t66);
    let t68 = circuit_mul(in65, in2);
    let t69 = circuit_mul(in71, in3);
    let t70 = circuit_add(t68, t69);
    let t71 = circuit_mul(in66, in4);
    let t72 = circuit_mul(in72, in5);
    let t73 = circuit_add(t71, t72);
    let t74 = circuit_mul(in67, in6);
    let t75 = circuit_mul(in73, in7);
    let t76 = circuit_add(t74, t75);
    let t77 = circuit_mul(in68, in8);
    let t78 = circuit_mul(in74, in9);
    let t79 = circuit_add(t77, t78);
    let t80 = circuit_mul(in69, in10);
    let t81 = circuit_mul(in75, in11);
    let t82 = circuit_add(t80, t81);
    let t83 = circuit_mul(in70, in12);
    let t84 = circuit_mul(in65, in13);
    let t85 = circuit_mul(in71, in14);
    let t86 = circuit_add(t84, t85);
    let t87 = circuit_mul(in66, in15);
    let t88 = circuit_mul(in72, in16);
    let t89 = circuit_add(t87, t88);
    let t90 = circuit_mul(in67, in17);
    let t91 = circuit_mul(in73, in18);
    let t92 = circuit_add(t90, t91);
    let t93 = circuit_mul(in68, in19);
    let t94 = circuit_mul(in74, in20);
    let t95 = circuit_add(t93, t94);
    let t96 = circuit_mul(in69, in21);
    let t97 = circuit_mul(in75, in22);
    let t98 = circuit_add(t96, t97);
    let t99 = circuit_mul(in46, in23);
    let t100 = circuit_mul(in47, in24);
    let t101 = circuit_mul(in48, in12);
    let t102 = circuit_mul(in49, in25);
    let t103 = circuit_mul(in50, in26);
    let t104 = circuit_mul(in52, in23);
    let t105 = circuit_mul(in53, in24);
    let t106 = circuit_mul(in54, in12);
    let t107 = circuit_mul(in55, in25);
    let t108 = circuit_mul(in56, in26);
    let t109 = circuit_mul(in70, in1);
    let t110 = circuit_add(in64, t109);
    let t111 = circuit_mul(in65, in27);
    let t112 = circuit_mul(in71, in28);
    let t113 = circuit_add(t111, t112);
    let t114 = circuit_mul(in66, in29);
    let t115 = circuit_mul(in72, in30);
    let t116 = circuit_add(t114, t115);
    let t117 = circuit_mul(in67, in18);
    let t118 = circuit_mul(in73, in31);
    let t119 = circuit_add(t117, t118);
    let t120 = circuit_mul(in68, in32);
    let t121 = circuit_mul(in74, in33);
    let t122 = circuit_add(t120, t121);
    let t123 = circuit_mul(in69, in34);
    let t124 = circuit_mul(in75, in35);
    let t125 = circuit_add(t123, t124);
    let t126 = circuit_mul(in70, in12);
    let t127 = circuit_mul(in65, in36);
    let t128 = circuit_mul(in71, in37);
    let t129 = circuit_add(t127, t128);
    let t130 = circuit_mul(in66, in38);
    let t131 = circuit_mul(in72, in39);
    let t132 = circuit_add(t130, t131);
    let t133 = circuit_mul(in67, in40);
    let t134 = circuit_mul(in73, in6);
    let t135 = circuit_add(t133, t134);
    let t136 = circuit_mul(in68, in41);
    let t137 = circuit_mul(in74, in42);
    let t138 = circuit_add(t136, t137);
    let t139 = circuit_mul(in69, in43);
    let t140 = circuit_mul(in75, in44);
    let t141 = circuit_add(t139, t140);
    let t142 = circuit_mul(t70, in57); // Eval C_inv_frob_1 step coeff_1 * z^1
    let t143 = circuit_add(t67, t142); // Eval C_inv_frob_1 step + (coeff_1 * z^1)
    let t144 = circuit_mul(t73, t0); // Eval C_inv_frob_1 step coeff_2 * z^2
    let t145 = circuit_add(t143, t144); // Eval C_inv_frob_1 step + (coeff_2 * z^2)
    let t146 = circuit_mul(t76, t1); // Eval C_inv_frob_1 step coeff_3 * z^3
    let t147 = circuit_add(t145, t146); // Eval C_inv_frob_1 step + (coeff_3 * z^3)
    let t148 = circuit_mul(t79, t2); // Eval C_inv_frob_1 step coeff_4 * z^4
    let t149 = circuit_add(t147, t148); // Eval C_inv_frob_1 step + (coeff_4 * z^4)
    let t150 = circuit_mul(t82, t3); // Eval C_inv_frob_1 step coeff_5 * z^5
    let t151 = circuit_add(t149, t150); // Eval C_inv_frob_1 step + (coeff_5 * z^5)
    let t152 = circuit_mul(t83, t4); // Eval C_inv_frob_1 step coeff_6 * z^6
    let t153 = circuit_add(t151, t152); // Eval C_inv_frob_1 step + (coeff_6 * z^6)
    let t154 = circuit_mul(t86, t5); // Eval C_inv_frob_1 step coeff_7 * z^7
    let t155 = circuit_add(t153, t154); // Eval C_inv_frob_1 step + (coeff_7 * z^7)
    let t156 = circuit_mul(t89, t6); // Eval C_inv_frob_1 step coeff_8 * z^8
    let t157 = circuit_add(t155, t156); // Eval C_inv_frob_1 step + (coeff_8 * z^8)
    let t158 = circuit_mul(t92, t7); // Eval C_inv_frob_1 step coeff_9 * z^9
    let t159 = circuit_add(t157, t158); // Eval C_inv_frob_1 step + (coeff_9 * z^9)
    let t160 = circuit_mul(t95, t8); // Eval C_inv_frob_1 step coeff_10 * z^10
    let t161 = circuit_add(t159, t160); // Eval C_inv_frob_1 step + (coeff_10 * z^10)
    let t162 = circuit_mul(t98, t9); // Eval C_inv_frob_1 step coeff_11 * z^11
    let t163 = circuit_add(t161, t162); // Eval C_inv_frob_1 step + (coeff_11 * z^11)
    let t164 = circuit_mul(t99, in57); // Eval C_frob_2 step coeff_1 * z^1
    let t165 = circuit_add(in45, t164); // Eval C_frob_2 step + (coeff_1 * z^1)
    let t166 = circuit_mul(t100, t0); // Eval C_frob_2 step coeff_2 * z^2
    let t167 = circuit_add(t165, t166); // Eval C_frob_2 step + (coeff_2 * z^2)
    let t168 = circuit_mul(t101, t1); // Eval C_frob_2 step coeff_3 * z^3
    let t169 = circuit_add(t167, t168); // Eval C_frob_2 step + (coeff_3 * z^3)
    let t170 = circuit_mul(t102, t2); // Eval C_frob_2 step coeff_4 * z^4
    let t171 = circuit_add(t169, t170); // Eval C_frob_2 step + (coeff_4 * z^4)
    let t172 = circuit_mul(t103, t3); // Eval C_frob_2 step coeff_5 * z^5
    let t173 = circuit_add(t171, t172); // Eval C_frob_2 step + (coeff_5 * z^5)
    let t174 = circuit_mul(in51, t4); // Eval C_frob_2 step coeff_6 * z^6
    let t175 = circuit_add(t173, t174); // Eval C_frob_2 step + (coeff_6 * z^6)
    let t176 = circuit_mul(t104, t5); // Eval C_frob_2 step coeff_7 * z^7
    let t177 = circuit_add(t175, t176); // Eval C_frob_2 step + (coeff_7 * z^7)
    let t178 = circuit_mul(t105, t6); // Eval C_frob_2 step coeff_8 * z^8
    let t179 = circuit_add(t177, t178); // Eval C_frob_2 step + (coeff_8 * z^8)
    let t180 = circuit_mul(t106, t7); // Eval C_frob_2 step coeff_9 * z^9
    let t181 = circuit_add(t179, t180); // Eval C_frob_2 step + (coeff_9 * z^9)
    let t182 = circuit_mul(t107, t8); // Eval C_frob_2 step coeff_10 * z^10
    let t183 = circuit_add(t181, t182); // Eval C_frob_2 step + (coeff_10 * z^10)
    let t184 = circuit_mul(t108, t9); // Eval C_frob_2 step coeff_11 * z^11
    let t185 = circuit_add(t183, t184); // Eval C_frob_2 step + (coeff_11 * z^11)
    let t186 = circuit_mul(t113, in57); // Eval C_inv_frob_3 step coeff_1 * z^1
    let t187 = circuit_add(t110, t186); // Eval C_inv_frob_3 step + (coeff_1 * z^1)
    let t188 = circuit_mul(t116, t0); // Eval C_inv_frob_3 step coeff_2 * z^2
    let t189 = circuit_add(t187, t188); // Eval C_inv_frob_3 step + (coeff_2 * z^2)
    let t190 = circuit_mul(t119, t1); // Eval C_inv_frob_3 step coeff_3 * z^3
    let t191 = circuit_add(t189, t190); // Eval C_inv_frob_3 step + (coeff_3 * z^3)
    let t192 = circuit_mul(t122, t2); // Eval C_inv_frob_3 step coeff_4 * z^4
    let t193 = circuit_add(t191, t192); // Eval C_inv_frob_3 step + (coeff_4 * z^4)
    let t194 = circuit_mul(t125, t3); // Eval C_inv_frob_3 step coeff_5 * z^5
    let t195 = circuit_add(t193, t194); // Eval C_inv_frob_3 step + (coeff_5 * z^5)
    let t196 = circuit_mul(t126, t4); // Eval C_inv_frob_3 step coeff_6 * z^6
    let t197 = circuit_add(t195, t196); // Eval C_inv_frob_3 step + (coeff_6 * z^6)
    let t198 = circuit_mul(t129, t5); // Eval C_inv_frob_3 step coeff_7 * z^7
    let t199 = circuit_add(t197, t198); // Eval C_inv_frob_3 step + (coeff_7 * z^7)
    let t200 = circuit_mul(t132, t6); // Eval C_inv_frob_3 step coeff_8 * z^8
    let t201 = circuit_add(t199, t200); // Eval C_inv_frob_3 step + (coeff_8 * z^8)
    let t202 = circuit_mul(t135, t7); // Eval C_inv_frob_3 step coeff_9 * z^9
    let t203 = circuit_add(t201, t202); // Eval C_inv_frob_3 step + (coeff_9 * z^9)
    let t204 = circuit_mul(t138, t8); // Eval C_inv_frob_3 step coeff_10 * z^10
    let t205 = circuit_add(t203, t204); // Eval C_inv_frob_3 step + (coeff_10 * z^10)
    let t206 = circuit_mul(t141, t9); // Eval C_inv_frob_3 step coeff_11 * z^11
    let t207 = circuit_add(t205, t206); // Eval C_inv_frob_3 step + (coeff_11 * z^11)

    let modulus = crate::definitions::get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (t31, t41, t63, t65, t163, t185, t207).new_inputs();
    // Prefill constants:

    circuit_inputs = circuit_inputs
        .next_span(INITIALIZE_MPCHECK_BN254_CONSTANTS.span()); // in0 - in44

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(lambda_root.w0); // in45
    circuit_inputs = circuit_inputs.next_2(lambda_root.w1); // in46
    circuit_inputs = circuit_inputs.next_2(lambda_root.w2); // in47
    circuit_inputs = circuit_inputs.next_2(lambda_root.w3); // in48
    circuit_inputs = circuit_inputs.next_2(lambda_root.w4); // in49
    circuit_inputs = circuit_inputs.next_2(lambda_root.w5); // in50
    circuit_inputs = circuit_inputs.next_2(lambda_root.w6); // in51
    circuit_inputs = circuit_inputs.next_2(lambda_root.w7); // in52
    circuit_inputs = circuit_inputs.next_2(lambda_root.w8); // in53
    circuit_inputs = circuit_inputs.next_2(lambda_root.w9); // in54
    circuit_inputs = circuit_inputs.next_2(lambda_root.w10); // in55
    circuit_inputs = circuit_inputs.next_2(lambda_root.w11); // in56
    circuit_inputs = circuit_inputs.next_2(z); // in57
    circuit_inputs = circuit_inputs.next_2(scaling_factor.w0); // in58
    circuit_inputs = circuit_inputs.next_2(scaling_factor.w2); // in59
    circuit_inputs = circuit_inputs.next_2(scaling_factor.w4); // in60
    circuit_inputs = circuit_inputs.next_2(scaling_factor.w6); // in61
    circuit_inputs = circuit_inputs.next_2(scaling_factor.w8); // in62
    circuit_inputs = circuit_inputs.next_2(scaling_factor.w10); // in63
    circuit_inputs = circuit_inputs.next_2(c_inv.w0); // in64
    circuit_inputs = circuit_inputs.next_2(c_inv.w1); // in65
    circuit_inputs = circuit_inputs.next_2(c_inv.w2); // in66
    circuit_inputs = circuit_inputs.next_2(c_inv.w3); // in67
    circuit_inputs = circuit_inputs.next_2(c_inv.w4); // in68
    circuit_inputs = circuit_inputs.next_2(c_inv.w5); // in69
    circuit_inputs = circuit_inputs.next_2(c_inv.w6); // in70
    circuit_inputs = circuit_inputs.next_2(c_inv.w7); // in71
    circuit_inputs = circuit_inputs.next_2(c_inv.w8); // in72
    circuit_inputs = circuit_inputs.next_2(c_inv.w9); // in73
    circuit_inputs = circuit_inputs.next_2(c_inv.w10); // in74
    circuit_inputs = circuit_inputs.next_2(c_inv.w11); // in75

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let c_of_z: u384 = outputs.get_output(t31);
    let scaling_factor_of_z: u384 = outputs.get_output(t41);
    let c_inv_of_z: u384 = outputs.get_output(t63);
    let lhs: u384 = outputs.get_output(t65);
    let c_inv_frob_1_of_z: u384 = outputs.get_output(t163);
    let c_frob_2_of_z: u384 = outputs.get_output(t185);
    let c_inv_frob_3_of_z: u384 = outputs.get_output(t207);
    return (
        c_of_z,
        scaling_factor_of_z,
        c_inv_of_z,
        lhs,
        c_inv_frob_1_of_z,
        c_frob_2_of_z,
        c_inv_frob_3_of_z,
    );
}
const INITIALIZE_MPCHECK_BN254_CONSTANTS: [u384; 45] = [
    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x12, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 {
        limb0: 0xfde6a43f5daa971f3fa65955,
        limb1: 0x1b2522ec5eb28ded6895e1cd,
        limb2: 0x1d8c8daef3eee1e8,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x42b29c567e9c385ce480a71a,
        limb1: 0x4e34e2ac06ead4000d14d1e2,
        limb2: 0x217e400dc9351e77,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xfd28d102c0d147b2f4d521a7,
        limb1: 0x8481d22c6934ce844d72f250,
        limb2: 0x242b719062f6737b,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x43ac198484b8d9094aa82536,
        limb1: 0x1b9c22d81246ffc2e794e176,
        limb2: 0x359809094bd5c8e,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x6df7b44cbb259ef7cb58d5ed,
        limb1: 0xdd4ef1e69a0c1f0dd2949fa,
        limb2: 0x21436d48fcb50cc6,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x8a4f4f0831364cf35f78f771,
        limb1: 0x38a4311a86919d9c7c6c15f8,
        limb2: 0x18857a58f3b5bb30,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x6fc008e7d6998c82f7fc048b,
        limb1: 0x62b7adefd44038ab3c0bbad9,
        limb2: 0x2c84bbad27c36715,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xa8697e0c9c36d8ca3339a7b5,
        limb1: 0x6d1eab6fcd18b99ad4afd096,
        limb2: 0xc33b1c70e4fd11b,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x5371c546d428780a6e3dcfa8,
        limb1: 0x13fe08bea73305ff6bdac77c,
        limb2: 0x1b007294a55accce,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x4f501fe811493d72543a3977,
        limb1: 0xefe88dd8e6965b3adae92c97,
        limb2: 0x215d42e7ac7bd17c,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x6871ca8d3c208c16d87cfd46,
        limb1: 0xb85045b68181585d97816a91,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x8eeec7e5ca5cf05f80f362ac,
        limb1: 0xa6327cfe12150b8e74799277,
        limb2: 0x246996f3b4fae7e6,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x6a8b264dde75f4f798d6a3f2,
        limb1: 0x9d2b22ca22ceca702eeb88c3,
        limb2: 0x12d7c0c3ed42be41,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xb7c9dce1665d51c640fcba2,
        limb1: 0x4ba4cc8bd75a079432ae2a1d,
        limb2: 0x16c9e55061ebae20,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x6b48f98a7b4f4463e3a7dba0,
        limb1: 0x33ce738a184c89d94a0e7840,
        limb2: 0xc38dce27e3b2cae,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x8fa25bd282d37f632623b0e3,
        limb1: 0x704b5a7ec796f2b21807dc9,
        limb2: 0x7c03cbcac41049a,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xfa7a164080faed1f0d24275a,
        limb1: 0xaa7b569817e0966cba582096,
        limb2: 0xf20e129e47c9363,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x1bdec763c13b4711cd2b8126,
        limb1: 0x9f3a80b03b0b1c923685d2ea,
        limb2: 0x2c145edbe7fd8aee,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xf8b1c1a56586ff93e080f8bc,
        limb1: 0x559897c6ad411fb25b75afb7,
        limb2: 0x3df92c5b96e3914,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x678e2ac024c6b8ee6e0c2c4b,
        limb1: 0xa27fb246c7729f7db080cb99,
        limb2: 0x12acf2ca76fd0675,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x1500054667f8140c6a3f2d9f,
        limb1: 0xa4523cf7da4e525e2ba6a315,
        limb2: 0x1563dbde3bd6d35b,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xbb966e3de4bd44e5607cfd49,
        limb1: 0x5e6dd9e7e0acccb0c28f069f,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xbb966e3de4bd44e5607cfd48,
        limb1: 0x5e6dd9e7e0acccb0c28f069f,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xacdb5c4f5763473177fffffe,
        limb1: 0x59e26bcea0d48bacd4f263f1,
        limb2: 0x0,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xacdb5c4f5763473177ffffff,
        limb1: 0x59e26bcea0d48bacd4f263f1,
        limb2: 0x0,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x67dfc8fabd3581ad840ddd76,
        limb1: 0xb2bdfa8fef85fa07122bde8d,
        limb2: 0x13d0c369615f7bb0,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xac285af5685d3f90eacf7a66,
        limb1: 0xfc2bf531eb331a053a35744c,
        limb2: 0x18a0f4219f4fdff6,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x64e2b5a5bf22f67654883ae6,
        limb1: 0x79c3e050c9ca2a428908a812,
        limb2: 0xc3a5e9c462a6547,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x345582cc92fd973c74bd77f4,
        limb1: 0x5bdd2055c255cf9d9e08c1d9,
        limb2: 0x2ce02aa5f9bf8cd6,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xde227b850aea3f23790405d6,
        limb1: 0x7fac149bfaefbac11b155498,
        limb2: 0x17ded419ed7be4f9,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x4150a79753fb0cd31cc99cc0,
        limb1: 0x2fb81a8dccd8a9b4441d64f3,
        limb2: 0x1bfe7b214c029424,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x9efaf0f0f1a228f0d5662fbd,
        limb1: 0xd15da0ec97a9b8346513297b,
        limb2: 0x697b9c523e0390e,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x182d2db0c413901c32b0c6fe,
        limb1: 0xb5186d6ac4c723b85d3f78a3,
        limb2: 0x7a0e052f2b1c443,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x39c0d06b220500933945267f,
        limb1: 0x5dc79824a3792597356c892c,
        limb2: 0x1b76a37fba85f3cd,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x97d439ec7694aa2bf4c0c101,
        limb1: 0x6cbeee33576139d7f03a5e3,
        limb2: 0xabf8b60be77d73,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x9201927eeb0a69546f1fd1,
        limb1: 0x5924b2691fb5e5685558c04,
        limb2: 0x1c938b097fd22479,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x98ff2631380cab2baaa586de,
        limb1: 0xa9f30e6dec26094f0fdf31bf,
        limb2: 0x4f1de41b3d1766f,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x38f14e77cfd95a083f4c261,
        limb1: 0x3e8c6565b7b72e1b0e78c27f,
        limb2: 0x2429efd69b073ae2,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xd8cf6ebab94d0cb3b2594c64,
        limb1: 0xb14b900e9507e9327600ecc7,
        limb2: 0x28a411b634f09b8f,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x737f96e55fe3ed9d730c239f,
        limb1: 0xfeb0f6ef0cd21d04a44a9e08,
        limb2: 0x23d5e999e1910a12,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x272122f5e8257f43bbb36087,
        limb1: 0x88982b28b4a8aea95364059e,
        limb2: 0x1465d351952f0c05,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x200280211f25041384282499,
        limb1: 0x9fb1b2282a48633d3e2ddaea,
        limb2: 0x16db366a59b1dd0b,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x50449cdc780cfbfaa5cc3649,
        limb1: 0x337d84bbcba34a53a41f1ee,
        limb2: 0x28c36e1fee7fdbe6,
        limb3: 0x0,
    },
];
#[inline(always)]
pub fn run_BN254_MP_CHECK_BIT00_2P_2F_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    G2_line_dbl_0: G2Line<u288>,
    G2_line_2nd_0_0: G2Line<u288>,
    yInv_1: u384,
    xNegOverY_1: u384,
    G2_line_dbl_1: G2Line<u288>,
    G2_line_2nd_0_1: G2Line<u288>,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one_of_z: u384,
    z: u384,
    c1: u384,
) -> (u384,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // -0x9 % p
    let in1 = CE::<CI<1>> {}; // 0x1

    // INPUT stack
    let (in2, in3, in4) = (CE::<CI<2>> {}, CE::<CI<3>> {}, CE::<CI<4>> {});
    let (in5, in6, in7) = (CE::<CI<5>> {}, CE::<CI<6>> {}, CE::<CI<7>> {});
    let (in8, in9, in10) = (CE::<CI<8>> {}, CE::<CI<9>> {}, CE::<CI<10>> {});
    let (in11, in12, in13) = (CE::<CI<11>> {}, CE::<CI<12>> {}, CE::<CI<13>> {});
    let (in14, in15, in16) = (CE::<CI<14>> {}, CE::<CI<15>> {}, CE::<CI<16>> {});
    let (in17, in18, in19) = (CE::<CI<17>> {}, CE::<CI<18>> {}, CE::<CI<19>> {});
    let (in20, in21, in22) = (CE::<CI<20>> {}, CE::<CI<21>> {}, CE::<CI<22>> {});
    let (in23, in24, in25) = (CE::<CI<23>> {}, CE::<CI<24>> {}, CE::<CI<25>> {});
    let in26 = CE::<CI<26>> {};
    let t0 = circuit_mul(in25, in25); // compute z^2
    let t1 = circuit_mul(t0, in25); // compute z^3
    let t2 = circuit_mul(t1, t1); // compute z^6
    let t3 = circuit_mul(t2, in25); // compute z^7
    let t4 = circuit_mul(t3, t0); // compute z^9
    let t5 = circuit_mul(in23, in23); // Square f evaluation in Z, the result of previous bit.
    let t6 = circuit_mul(in0, in5);
    let t7 = circuit_add(in4, t6);
    let t8 = circuit_mul(t7, in3); // eval bn line by xNegOverY
    let t9 = circuit_mul(in0, in7);
    let t10 = circuit_add(in6, t9);
    let t11 = circuit_mul(t10, in2); // eval bn line by yInv
    let t12 = circuit_mul(in5, in3); // eval bn line by xNegOverY
    let t13 = circuit_mul(in7, in2); // eval bn line by yInv
    let t14 = circuit_mul(t8, in25); // Eval sparse poly line_0p_1 step coeff_1 * z^1
    let t15 = circuit_add(in1, t14); // Eval sparse poly line_0p_1 step + coeff_1 * z^1
    let t16 = circuit_mul(t11, t1); // Eval sparse poly line_0p_1 step coeff_3 * z^3
    let t17 = circuit_add(t15, t16); // Eval sparse poly line_0p_1 step + coeff_3 * z^3
    let t18 = circuit_mul(t12, t3); // Eval sparse poly line_0p_1 step coeff_7 * z^7
    let t19 = circuit_add(t17, t18); // Eval sparse poly line_0p_1 step + coeff_7 * z^7
    let t20 = circuit_mul(t13, t4); // Eval sparse poly line_0p_1 step coeff_9 * z^9
    let t21 = circuit_add(t19, t20); // Eval sparse poly line_0p_1 step + coeff_9 * z^9
    let t22 = circuit_mul(t5, t21); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t23 = circuit_mul(in0, in9);
    let t24 = circuit_add(in8, t23);
    let t25 = circuit_mul(t24, in13); // eval bn line by xNegOverY
    let t26 = circuit_mul(in0, in11);
    let t27 = circuit_add(in10, t26);
    let t28 = circuit_mul(t27, in12); // eval bn line by yInv
    let t29 = circuit_mul(in9, in13); // eval bn line by xNegOverY
    let t30 = circuit_mul(in11, in12); // eval bn line by yInv
    let t31 = circuit_mul(t25, in25); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t32 = circuit_add(in1, t31); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t33 = circuit_mul(t28, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t34 = circuit_add(t32, t33); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t35 = circuit_mul(t29, t3); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t36 = circuit_add(t34, t35); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t37 = circuit_mul(t30, t4); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t38 = circuit_add(t36, t37); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t39 = circuit_mul(t22, t38); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t40 = circuit_mul(
        t39, t39,
    ); // Compute (f^2 * Π(i,k) (line_i,k(z))) ^ 2 = f^4 * (Π(i,k) (line_i,k(z)))^2
    let t41 = circuit_mul(in0, in15);
    let t42 = circuit_add(in14, t41);
    let t43 = circuit_mul(t42, in3); // eval bn line by xNegOverY
    let t44 = circuit_mul(in0, in17);
    let t45 = circuit_add(in16, t44);
    let t46 = circuit_mul(t45, in2); // eval bn line by yInv
    let t47 = circuit_mul(in15, in3); // eval bn line by xNegOverY
    let t48 = circuit_mul(in17, in2); // eval bn line by yInv
    let t49 = circuit_mul(t43, in25); // Eval sparse poly line_0p_1 step coeff_1 * z^1
    let t50 = circuit_add(in1, t49); // Eval sparse poly line_0p_1 step + coeff_1 * z^1
    let t51 = circuit_mul(t46, t1); // Eval sparse poly line_0p_1 step coeff_3 * z^3
    let t52 = circuit_add(t50, t51); // Eval sparse poly line_0p_1 step + coeff_3 * z^3
    let t53 = circuit_mul(t47, t3); // Eval sparse poly line_0p_1 step coeff_7 * z^7
    let t54 = circuit_add(t52, t53); // Eval sparse poly line_0p_1 step + coeff_7 * z^7
    let t55 = circuit_mul(t48, t4); // Eval sparse poly line_0p_1 step coeff_9 * z^9
    let t56 = circuit_add(t54, t55); // Eval sparse poly line_0p_1 step + coeff_9 * z^9
    let t57 = circuit_mul(t40, t56); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t58 = circuit_mul(in0, in19);
    let t59 = circuit_add(in18, t58);
    let t60 = circuit_mul(t59, in13); // eval bn line by xNegOverY
    let t61 = circuit_mul(in0, in21);
    let t62 = circuit_add(in20, t61);
    let t63 = circuit_mul(t62, in12); // eval bn line by yInv
    let t64 = circuit_mul(in19, in13); // eval bn line by xNegOverY
    let t65 = circuit_mul(in21, in12); // eval bn line by yInv
    let t66 = circuit_mul(t60, in25); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t67 = circuit_add(in1, t66); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t68 = circuit_mul(t63, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t69 = circuit_add(t67, t68); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t70 = circuit_mul(t64, t3); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t71 = circuit_add(t69, t70); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t72 = circuit_mul(t65, t4); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t73 = circuit_add(t71, t72); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t74 = circuit_mul(t57, t73); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t75 = circuit_sub(t74, in24); // (Π(i,k) (Pk(z))) - Ri(z)
    let t76 = circuit_mul(in26, in22);
    let t77 = circuit_add(t76, t75); // LHS = c1 * LHS + ((Π(i,k) (Pk(z)) - Ri(z))

    let modulus = crate::definitions::get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (t77,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs
        .next_2(
            [0x6871ca8d3c208c16d87cfd3e, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0],
        ); // in0
    circuit_inputs = circuit_inputs.next_2([0x1, 0x0, 0x0, 0x0]); // in1
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(yInv_0); // in2
    circuit_inputs = circuit_inputs.next_2(xNegOverY_0); // in3
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r0a0); // in4
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r0a1); // in5
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r1a0); // in6
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r1a1); // in7
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_0.r0a0); // in8
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_0.r0a1); // in9
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_0.r1a0); // in10
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_0.r1a1); // in11
    circuit_inputs = circuit_inputs.next_2(yInv_1); // in12
    circuit_inputs = circuit_inputs.next_2(xNegOverY_1); // in13
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r0a0); // in14
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r0a1); // in15
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r1a0); // in16
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r1a1); // in17
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_1.r0a0); // in18
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_1.r0a1); // in19
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_1.r1a0); // in20
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_1.r1a1); // in21
    circuit_inputs = circuit_inputs.next_2(lhs_i); // in22
    circuit_inputs = circuit_inputs.next_2(f_i_of_z); // in23
    circuit_inputs = circuit_inputs.next_2(f_i_plus_one_of_z); // in24
    circuit_inputs = circuit_inputs.next_2(z); // in25
    circuit_inputs = circuit_inputs.next_2(c1); // in26

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let lhs_i_plus_one: u384 = outputs.get_output(t77);
    return (lhs_i_plus_one,);
}
#[inline(always)]
pub fn run_BN254_MP_CHECK_BIT00_3P_2F_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    G2_line_dbl_0: G2Line<u288>,
    G2_line_2nd_0_0: G2Line<u288>,
    yInv_1: u384,
    xNegOverY_1: u384,
    G2_line_dbl_1: G2Line<u288>,
    G2_line_2nd_0_1: G2Line<u288>,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q_2: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one_of_z: u384,
    z: u384,
    c1: u384,
) -> (G2Point, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // -0x9 % p
    let in1 = CE::<CI<1>> {}; // 0x1
    let in2 = CE::<CI<2>> {}; // 0x3
    let in3 = CE::<CI<3>> {}; // 0x6
    let in4 = CE::<CI<4>> {}; // 0x0

    // INPUT stack
    let (in5, in6, in7) = (CE::<CI<5>> {}, CE::<CI<6>> {}, CE::<CI<7>> {});
    let (in8, in9, in10) = (CE::<CI<8>> {}, CE::<CI<9>> {}, CE::<CI<10>> {});
    let (in11, in12, in13) = (CE::<CI<11>> {}, CE::<CI<12>> {}, CE::<CI<13>> {});
    let (in14, in15, in16) = (CE::<CI<14>> {}, CE::<CI<15>> {}, CE::<CI<16>> {});
    let (in17, in18, in19) = (CE::<CI<17>> {}, CE::<CI<18>> {}, CE::<CI<19>> {});
    let (in20, in21, in22) = (CE::<CI<20>> {}, CE::<CI<21>> {}, CE::<CI<22>> {});
    let (in23, in24, in25) = (CE::<CI<23>> {}, CE::<CI<24>> {}, CE::<CI<25>> {});
    let (in26, in27, in28) = (CE::<CI<26>> {}, CE::<CI<27>> {}, CE::<CI<28>> {});
    let (in29, in30, in31) = (CE::<CI<29>> {}, CE::<CI<30>> {}, CE::<CI<31>> {});
    let (in32, in33, in34) = (CE::<CI<32>> {}, CE::<CI<33>> {}, CE::<CI<34>> {});
    let in35 = CE::<CI<35>> {};
    let t0 = circuit_mul(in34, in34); // compute z^2
    let t1 = circuit_mul(t0, in34); // compute z^3
    let t2 = circuit_mul(t1, t1); // compute z^6
    let t3 = circuit_mul(t2, in34); // compute z^7
    let t4 = circuit_mul(t3, t0); // compute z^9
    let t5 = circuit_mul(in32, in32); // Square f evaluation in Z, the result of previous bit.
    let t6 = circuit_mul(in0, in8);
    let t7 = circuit_add(in7, t6);
    let t8 = circuit_mul(t7, in6); // eval bn line by xNegOverY
    let t9 = circuit_mul(in0, in10);
    let t10 = circuit_add(in9, t9);
    let t11 = circuit_mul(t10, in5); // eval bn line by yInv
    let t12 = circuit_mul(in8, in6); // eval bn line by xNegOverY
    let t13 = circuit_mul(in10, in5); // eval bn line by yInv
    let t14 = circuit_mul(t8, in34); // Eval sparse poly line_0p_1 step coeff_1 * z^1
    let t15 = circuit_add(in1, t14); // Eval sparse poly line_0p_1 step + coeff_1 * z^1
    let t16 = circuit_mul(t11, t1); // Eval sparse poly line_0p_1 step coeff_3 * z^3
    let t17 = circuit_add(t15, t16); // Eval sparse poly line_0p_1 step + coeff_3 * z^3
    let t18 = circuit_mul(t12, t3); // Eval sparse poly line_0p_1 step coeff_7 * z^7
    let t19 = circuit_add(t17, t18); // Eval sparse poly line_0p_1 step + coeff_7 * z^7
    let t20 = circuit_mul(t13, t4); // Eval sparse poly line_0p_1 step coeff_9 * z^9
    let t21 = circuit_add(t19, t20); // Eval sparse poly line_0p_1 step + coeff_9 * z^9
    let t22 = circuit_mul(t5, t21); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t23 = circuit_mul(in0, in12);
    let t24 = circuit_add(in11, t23);
    let t25 = circuit_mul(t24, in16); // eval bn line by xNegOverY
    let t26 = circuit_mul(in0, in14);
    let t27 = circuit_add(in13, t26);
    let t28 = circuit_mul(t27, in15); // eval bn line by yInv
    let t29 = circuit_mul(in12, in16); // eval bn line by xNegOverY
    let t30 = circuit_mul(in14, in15); // eval bn line by yInv
    let t31 = circuit_mul(t25, in34); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t32 = circuit_add(in1, t31); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t33 = circuit_mul(t28, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t34 = circuit_add(t32, t33); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t35 = circuit_mul(t29, t3); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t36 = circuit_add(t34, t35); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t37 = circuit_mul(t30, t4); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t38 = circuit_add(t36, t37); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t39 = circuit_mul(t22, t38); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t40 = circuit_add(in27, in28); // Doubling slope numerator start
    let t41 = circuit_sub(in27, in28);
    let t42 = circuit_mul(t40, t41);
    let t43 = circuit_mul(in27, in28);
    let t44 = circuit_mul(t42, in2);
    let t45 = circuit_mul(t43, in3); // Doubling slope numerator end
    let t46 = circuit_add(in29, in29); // Fp2 add coeff 0/1
    let t47 = circuit_add(in30, in30); // Fp2 add coeff 1/1
    let t48 = circuit_mul(t46, t46); // Fp2 Inv start
    let t49 = circuit_mul(t47, t47);
    let t50 = circuit_add(t48, t49);
    let t51 = circuit_inverse(t50);
    let t52 = circuit_mul(t46, t51); // Fp2 Inv real part end
    let t53 = circuit_mul(t47, t51);
    let t54 = circuit_sub(in4, t53); // Fp2 Inv imag part end
    let t55 = circuit_mul(t44, t52); // Fp2 mul start
    let t56 = circuit_mul(t45, t54);
    let t57 = circuit_sub(t55, t56); // Fp2 mul real part end
    let t58 = circuit_mul(t44, t54);
    let t59 = circuit_mul(t45, t52);
    let t60 = circuit_add(t58, t59); // Fp2 mul imag part end
    let t61 = circuit_add(t57, t60);
    let t62 = circuit_sub(t57, t60);
    let t63 = circuit_mul(t61, t62);
    let t64 = circuit_mul(t57, t60);
    let t65 = circuit_add(t64, t64);
    let t66 = circuit_add(in27, in27); // Fp2 add coeff 0/1
    let t67 = circuit_add(in28, in28); // Fp2 add coeff 1/1
    let t68 = circuit_sub(t63, t66); // Fp2 sub coeff 0/1
    let t69 = circuit_sub(t65, t67); // Fp2 sub coeff 1/1
    let t70 = circuit_sub(in27, t68); // Fp2 sub coeff 0/1
    let t71 = circuit_sub(in28, t69); // Fp2 sub coeff 1/1
    let t72 = circuit_mul(t57, t70); // Fp2 mul start
    let t73 = circuit_mul(t60, t71);
    let t74 = circuit_sub(t72, t73); // Fp2 mul real part end
    let t75 = circuit_mul(t57, t71);
    let t76 = circuit_mul(t60, t70);
    let t77 = circuit_add(t75, t76); // Fp2 mul imag part end
    let t78 = circuit_sub(t74, in29); // Fp2 sub coeff 0/1
    let t79 = circuit_sub(t77, in30); // Fp2 sub coeff 1/1
    let t80 = circuit_mul(t57, in27); // Fp2 mul start
    let t81 = circuit_mul(t60, in28);
    let t82 = circuit_sub(t80, t81); // Fp2 mul real part end
    let t83 = circuit_mul(t57, in28);
    let t84 = circuit_mul(t60, in27);
    let t85 = circuit_add(t83, t84); // Fp2 mul imag part end
    let t86 = circuit_sub(t82, in29); // Fp2 sub coeff 0/1
    let t87 = circuit_sub(t85, in30); // Fp2 sub coeff 1/1
    let t88 = circuit_mul(in0, t60);
    let t89 = circuit_add(t57, t88);
    let t90 = circuit_mul(t89, in26); // eval bn line by xNegOverY
    let t91 = circuit_mul(in0, t87);
    let t92 = circuit_add(t86, t91);
    let t93 = circuit_mul(t92, in25); // eval bn line by yInv
    let t94 = circuit_mul(t60, in26); // eval bn line by xNegOverY
    let t95 = circuit_mul(t87, in25); // eval bn line by yInv
    let t96 = circuit_mul(t90, in34); // Eval sparse poly line_2p_1 step coeff_1 * z^1
    let t97 = circuit_add(in1, t96); // Eval sparse poly line_2p_1 step + coeff_1 * z^1
    let t98 = circuit_mul(t93, t1); // Eval sparse poly line_2p_1 step coeff_3 * z^3
    let t99 = circuit_add(t97, t98); // Eval sparse poly line_2p_1 step + coeff_3 * z^3
    let t100 = circuit_mul(t94, t3); // Eval sparse poly line_2p_1 step coeff_7 * z^7
    let t101 = circuit_add(t99, t100); // Eval sparse poly line_2p_1 step + coeff_7 * z^7
    let t102 = circuit_mul(t95, t4); // Eval sparse poly line_2p_1 step coeff_9 * z^9
    let t103 = circuit_add(t101, t102); // Eval sparse poly line_2p_1 step + coeff_9 * z^9
    let t104 = circuit_mul(t39, t103); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t105 = circuit_mul(
        t104, t104,
    ); // Compute (f^2 * Π(i,k) (line_i,k(z))) ^ 2 = f^4 * (Π(i,k) (line_i,k(z)))^2
    let t106 = circuit_mul(in0, in18);
    let t107 = circuit_add(in17, t106);
    let t108 = circuit_mul(t107, in6); // eval bn line by xNegOverY
    let t109 = circuit_mul(in0, in20);
    let t110 = circuit_add(in19, t109);
    let t111 = circuit_mul(t110, in5); // eval bn line by yInv
    let t112 = circuit_mul(in18, in6); // eval bn line by xNegOverY
    let t113 = circuit_mul(in20, in5); // eval bn line by yInv
    let t114 = circuit_mul(t108, in34); // Eval sparse poly line_0p_1 step coeff_1 * z^1
    let t115 = circuit_add(in1, t114); // Eval sparse poly line_0p_1 step + coeff_1 * z^1
    let t116 = circuit_mul(t111, t1); // Eval sparse poly line_0p_1 step coeff_3 * z^3
    let t117 = circuit_add(t115, t116); // Eval sparse poly line_0p_1 step + coeff_3 * z^3
    let t118 = circuit_mul(t112, t3); // Eval sparse poly line_0p_1 step coeff_7 * z^7
    let t119 = circuit_add(t117, t118); // Eval sparse poly line_0p_1 step + coeff_7 * z^7
    let t120 = circuit_mul(t113, t4); // Eval sparse poly line_0p_1 step coeff_9 * z^9
    let t121 = circuit_add(t119, t120); // Eval sparse poly line_0p_1 step + coeff_9 * z^9
    let t122 = circuit_mul(t105, t121); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t123 = circuit_mul(in0, in22);
    let t124 = circuit_add(in21, t123);
    let t125 = circuit_mul(t124, in16); // eval bn line by xNegOverY
    let t126 = circuit_mul(in0, in24);
    let t127 = circuit_add(in23, t126);
    let t128 = circuit_mul(t127, in15); // eval bn line by yInv
    let t129 = circuit_mul(in22, in16); // eval bn line by xNegOverY
    let t130 = circuit_mul(in24, in15); // eval bn line by yInv
    let t131 = circuit_mul(t125, in34); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t132 = circuit_add(in1, t131); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t133 = circuit_mul(t128, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t134 = circuit_add(t132, t133); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t135 = circuit_mul(t129, t3); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t136 = circuit_add(t134, t135); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t137 = circuit_mul(t130, t4); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t138 = circuit_add(t136, t137); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t139 = circuit_mul(t122, t138); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t140 = circuit_add(t68, t69); // Doubling slope numerator start
    let t141 = circuit_sub(t68, t69);
    let t142 = circuit_mul(t140, t141);
    let t143 = circuit_mul(t68, t69);
    let t144 = circuit_mul(t142, in2);
    let t145 = circuit_mul(t143, in3); // Doubling slope numerator end
    let t146 = circuit_add(t78, t78); // Fp2 add coeff 0/1
    let t147 = circuit_add(t79, t79); // Fp2 add coeff 1/1
    let t148 = circuit_mul(t146, t146); // Fp2 Inv start
    let t149 = circuit_mul(t147, t147);
    let t150 = circuit_add(t148, t149);
    let t151 = circuit_inverse(t150);
    let t152 = circuit_mul(t146, t151); // Fp2 Inv real part end
    let t153 = circuit_mul(t147, t151);
    let t154 = circuit_sub(in4, t153); // Fp2 Inv imag part end
    let t155 = circuit_mul(t144, t152); // Fp2 mul start
    let t156 = circuit_mul(t145, t154);
    let t157 = circuit_sub(t155, t156); // Fp2 mul real part end
    let t158 = circuit_mul(t144, t154);
    let t159 = circuit_mul(t145, t152);
    let t160 = circuit_add(t158, t159); // Fp2 mul imag part end
    let t161 = circuit_add(t157, t160);
    let t162 = circuit_sub(t157, t160);
    let t163 = circuit_mul(t161, t162);
    let t164 = circuit_mul(t157, t160);
    let t165 = circuit_add(t164, t164);
    let t166 = circuit_add(t68, t68); // Fp2 add coeff 0/1
    let t167 = circuit_add(t69, t69); // Fp2 add coeff 1/1
    let t168 = circuit_sub(t163, t166); // Fp2 sub coeff 0/1
    let t169 = circuit_sub(t165, t167); // Fp2 sub coeff 1/1
    let t170 = circuit_sub(t68, t168); // Fp2 sub coeff 0/1
    let t171 = circuit_sub(t69, t169); // Fp2 sub coeff 1/1
    let t172 = circuit_mul(t157, t170); // Fp2 mul start
    let t173 = circuit_mul(t160, t171);
    let t174 = circuit_sub(t172, t173); // Fp2 mul real part end
    let t175 = circuit_mul(t157, t171);
    let t176 = circuit_mul(t160, t170);
    let t177 = circuit_add(t175, t176); // Fp2 mul imag part end
    let t178 = circuit_sub(t174, t78); // Fp2 sub coeff 0/1
    let t179 = circuit_sub(t177, t79); // Fp2 sub coeff 1/1
    let t180 = circuit_mul(t157, t68); // Fp2 mul start
    let t181 = circuit_mul(t160, t69);
    let t182 = circuit_sub(t180, t181); // Fp2 mul real part end
    let t183 = circuit_mul(t157, t69);
    let t184 = circuit_mul(t160, t68);
    let t185 = circuit_add(t183, t184); // Fp2 mul imag part end
    let t186 = circuit_sub(t182, t78); // Fp2 sub coeff 0/1
    let t187 = circuit_sub(t185, t79); // Fp2 sub coeff 1/1
    let t188 = circuit_mul(in0, t160);
    let t189 = circuit_add(t157, t188);
    let t190 = circuit_mul(t189, in26); // eval bn line by xNegOverY
    let t191 = circuit_mul(in0, t187);
    let t192 = circuit_add(t186, t191);
    let t193 = circuit_mul(t192, in25); // eval bn line by yInv
    let t194 = circuit_mul(t160, in26); // eval bn line by xNegOverY
    let t195 = circuit_mul(t187, in25); // eval bn line by yInv
    let t196 = circuit_mul(t190, in34); // Eval sparse poly line_2p_1 step coeff_1 * z^1
    let t197 = circuit_add(in1, t196); // Eval sparse poly line_2p_1 step + coeff_1 * z^1
    let t198 = circuit_mul(t193, t1); // Eval sparse poly line_2p_1 step coeff_3 * z^3
    let t199 = circuit_add(t197, t198); // Eval sparse poly line_2p_1 step + coeff_3 * z^3
    let t200 = circuit_mul(t194, t3); // Eval sparse poly line_2p_1 step coeff_7 * z^7
    let t201 = circuit_add(t199, t200); // Eval sparse poly line_2p_1 step + coeff_7 * z^7
    let t202 = circuit_mul(t195, t4); // Eval sparse poly line_2p_1 step coeff_9 * z^9
    let t203 = circuit_add(t201, t202); // Eval sparse poly line_2p_1 step + coeff_9 * z^9
    let t204 = circuit_mul(t139, t203); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t205 = circuit_sub(t204, in33); // (Π(i,k) (Pk(z))) - Ri(z)
    let t206 = circuit_mul(in35, in31);
    let t207 = circuit_add(t206, t205); // LHS = c1 * LHS + ((Π(i,k) (Pk(z)) - Ri(z))

    let modulus = crate::definitions::get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (t168, t169, t178, t179, t207).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs
        .next_2(
            [0x6871ca8d3c208c16d87cfd3e, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0],
        ); // in0
    circuit_inputs = circuit_inputs.next_2([0x1, 0x0, 0x0, 0x0]); // in1
    circuit_inputs = circuit_inputs.next_2([0x3, 0x0, 0x0, 0x0]); // in2
    circuit_inputs = circuit_inputs.next_2([0x6, 0x0, 0x0, 0x0]); // in3
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in4
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(yInv_0); // in5
    circuit_inputs = circuit_inputs.next_2(xNegOverY_0); // in6
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r0a0); // in7
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r0a1); // in8
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r1a0); // in9
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r1a1); // in10
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_0.r0a0); // in11
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_0.r0a1); // in12
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_0.r1a0); // in13
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_0.r1a1); // in14
    circuit_inputs = circuit_inputs.next_2(yInv_1); // in15
    circuit_inputs = circuit_inputs.next_2(xNegOverY_1); // in16
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r0a0); // in17
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r0a1); // in18
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r1a0); // in19
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r1a1); // in20
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_1.r0a0); // in21
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_1.r0a1); // in22
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_1.r1a0); // in23
    circuit_inputs = circuit_inputs.next_2(G2_line_2nd_0_1.r1a1); // in24
    circuit_inputs = circuit_inputs.next_2(yInv_2); // in25
    circuit_inputs = circuit_inputs.next_2(xNegOverY_2); // in26
    circuit_inputs = circuit_inputs.next_2(Q_2.x0); // in27
    circuit_inputs = circuit_inputs.next_2(Q_2.x1); // in28
    circuit_inputs = circuit_inputs.next_2(Q_2.y0); // in29
    circuit_inputs = circuit_inputs.next_2(Q_2.y1); // in30
    circuit_inputs = circuit_inputs.next_2(lhs_i); // in31
    circuit_inputs = circuit_inputs.next_2(f_i_of_z); // in32
    circuit_inputs = circuit_inputs.next_2(f_i_plus_one_of_z); // in33
    circuit_inputs = circuit_inputs.next_2(z); // in34
    circuit_inputs = circuit_inputs.next_2(c1); // in35

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let Q0: G2Point = G2Point {
        x0: outputs.get_output(t168),
        x1: outputs.get_output(t169),
        y0: outputs.get_output(t178),
        y1: outputs.get_output(t179),
    };
    let lhs_i_plus_one: u384 = outputs.get_output(t207);
    return (Q0, lhs_i_plus_one);
}
#[inline(always)]
pub fn run_BN254_MP_CHECK_BIT01_2P_2F_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    G2_line_dbl_0: G2Line<u288>,
    G2_line_dbl_10: G2Line<u288>,
    G2_line_add_10: G2Line<u288>,
    yInv_1: u384,
    xNegOverY_1: u384,
    G2_line_dbl_1: G2Line<u288>,
    G2_line_dbl_11: G2Line<u288>,
    G2_line_add_11: G2Line<u288>,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one_of_z: u384,
    c_or_cinv_of_z: u384,
    z: u384,
    c1: u384,
) -> (u384,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // -0x9 % p
    let in1 = CE::<CI<1>> {}; // 0x1

    // INPUT stack
    let (in2, in3, in4) = (CE::<CI<2>> {}, CE::<CI<3>> {}, CE::<CI<4>> {});
    let (in5, in6, in7) = (CE::<CI<5>> {}, CE::<CI<6>> {}, CE::<CI<7>> {});
    let (in8, in9, in10) = (CE::<CI<8>> {}, CE::<CI<9>> {}, CE::<CI<10>> {});
    let (in11, in12, in13) = (CE::<CI<11>> {}, CE::<CI<12>> {}, CE::<CI<13>> {});
    let (in14, in15, in16) = (CE::<CI<14>> {}, CE::<CI<15>> {}, CE::<CI<16>> {});
    let (in17, in18, in19) = (CE::<CI<17>> {}, CE::<CI<18>> {}, CE::<CI<19>> {});
    let (in20, in21, in22) = (CE::<CI<20>> {}, CE::<CI<21>> {}, CE::<CI<22>> {});
    let (in23, in24, in25) = (CE::<CI<23>> {}, CE::<CI<24>> {}, CE::<CI<25>> {});
    let (in26, in27, in28) = (CE::<CI<26>> {}, CE::<CI<27>> {}, CE::<CI<28>> {});
    let (in29, in30, in31) = (CE::<CI<29>> {}, CE::<CI<30>> {}, CE::<CI<31>> {});
    let (in32, in33, in34) = (CE::<CI<32>> {}, CE::<CI<33>> {}, CE::<CI<34>> {});
    let in35 = CE::<CI<35>> {};
    let t0 = circuit_mul(in34, in34); // compute z^2
    let t1 = circuit_mul(t0, in34); // compute z^3
    let t2 = circuit_mul(t1, t1); // compute z^6
    let t3 = circuit_mul(t2, in34); // compute z^7
    let t4 = circuit_mul(t3, t0); // compute z^9
    let t5 = circuit_mul(in31, in31); // Square f evaluation in Z, the result of previous bit.
    let t6 = circuit_mul(in0, in5);
    let t7 = circuit_add(in4, t6);
    let t8 = circuit_mul(t7, in3); // eval bn line by xNegOverY
    let t9 = circuit_mul(in0, in7);
    let t10 = circuit_add(in6, t9);
    let t11 = circuit_mul(t10, in2); // eval bn line by yInv
    let t12 = circuit_mul(in5, in3); // eval bn line by xNegOverY
    let t13 = circuit_mul(in7, in2); // eval bn line by yInv
    let t14 = circuit_mul(t8, in34); // Eval sparse poly line_0p_1 step coeff_1 * z^1
    let t15 = circuit_add(in1, t14); // Eval sparse poly line_0p_1 step + coeff_1 * z^1
    let t16 = circuit_mul(t11, t1); // Eval sparse poly line_0p_1 step coeff_3 * z^3
    let t17 = circuit_add(t15, t16); // Eval sparse poly line_0p_1 step + coeff_3 * z^3
    let t18 = circuit_mul(t12, t3); // Eval sparse poly line_0p_1 step coeff_7 * z^7
    let t19 = circuit_add(t17, t18); // Eval sparse poly line_0p_1 step + coeff_7 * z^7
    let t20 = circuit_mul(t13, t4); // Eval sparse poly line_0p_1 step coeff_9 * z^9
    let t21 = circuit_add(t19, t20); // Eval sparse poly line_0p_1 step + coeff_9 * z^9
    let t22 = circuit_mul(t5, t21); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t23 = circuit_mul(in0, in9);
    let t24 = circuit_add(in8, t23);
    let t25 = circuit_mul(t24, in17); // eval bn line by xNegOverY
    let t26 = circuit_mul(in0, in11);
    let t27 = circuit_add(in10, t26);
    let t28 = circuit_mul(t27, in16); // eval bn line by yInv
    let t29 = circuit_mul(in9, in17); // eval bn line by xNegOverY
    let t30 = circuit_mul(in11, in16); // eval bn line by yInv
    let t31 = circuit_mul(t25, in34); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t32 = circuit_add(in1, t31); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t33 = circuit_mul(t28, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t34 = circuit_add(t32, t33); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t35 = circuit_mul(t29, t3); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t36 = circuit_add(t34, t35); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t37 = circuit_mul(t30, t4); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t38 = circuit_add(t36, t37); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t39 = circuit_mul(t22, t38); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t40 = circuit_mul(
        t39, t39,
    ); // Compute (f^2 * Π(i,k) (line_i,k(z))) ^ 2 = f^4 * (Π(i,k) (line_i,k(z)))^2
    let t41 = circuit_mul(in0, in13);
    let t42 = circuit_add(in12, t41);
    let t43 = circuit_mul(t42, in3); // eval bn line by xNegOverY
    let t44 = circuit_mul(in0, in15);
    let t45 = circuit_add(in14, t44);
    let t46 = circuit_mul(t45, in2); // eval bn line by yInv
    let t47 = circuit_mul(in13, in3); // eval bn line by xNegOverY
    let t48 = circuit_mul(in15, in2); // eval bn line by yInv
    let t49 = circuit_mul(in0, in19);
    let t50 = circuit_add(in18, t49);
    let t51 = circuit_mul(t50, in3); // eval bn line by xNegOverY
    let t52 = circuit_mul(in0, in21);
    let t53 = circuit_add(in20, t52);
    let t54 = circuit_mul(t53, in2); // eval bn line by yInv
    let t55 = circuit_mul(in19, in3); // eval bn line by xNegOverY
    let t56 = circuit_mul(in21, in2); // eval bn line by yInv
    let t57 = circuit_mul(t43, in34); // Eval sparse poly line_0p_1 step coeff_1 * z^1
    let t58 = circuit_add(in1, t57); // Eval sparse poly line_0p_1 step + coeff_1 * z^1
    let t59 = circuit_mul(t46, t1); // Eval sparse poly line_0p_1 step coeff_3 * z^3
    let t60 = circuit_add(t58, t59); // Eval sparse poly line_0p_1 step + coeff_3 * z^3
    let t61 = circuit_mul(t47, t3); // Eval sparse poly line_0p_1 step coeff_7 * z^7
    let t62 = circuit_add(t60, t61); // Eval sparse poly line_0p_1 step + coeff_7 * z^7
    let t63 = circuit_mul(t48, t4); // Eval sparse poly line_0p_1 step coeff_9 * z^9
    let t64 = circuit_add(t62, t63); // Eval sparse poly line_0p_1 step + coeff_9 * z^9
    let t65 = circuit_mul(t40, t64); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t66 = circuit_mul(t51, in34); // Eval sparse poly line_0p_2 step coeff_1 * z^1
    let t67 = circuit_add(in1, t66); // Eval sparse poly line_0p_2 step + coeff_1 * z^1
    let t68 = circuit_mul(t54, t1); // Eval sparse poly line_0p_2 step coeff_3 * z^3
    let t69 = circuit_add(t67, t68); // Eval sparse poly line_0p_2 step + coeff_3 * z^3
    let t70 = circuit_mul(t55, t3); // Eval sparse poly line_0p_2 step coeff_7 * z^7
    let t71 = circuit_add(t69, t70); // Eval sparse poly line_0p_2 step + coeff_7 * z^7
    let t72 = circuit_mul(t56, t4); // Eval sparse poly line_0p_2 step coeff_9 * z^9
    let t73 = circuit_add(t71, t72); // Eval sparse poly line_0p_2 step + coeff_9 * z^9
    let t74 = circuit_mul(t65, t73); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t75 = circuit_mul(in0, in23);
    let t76 = circuit_add(in22, t75);
    let t77 = circuit_mul(t76, in17); // eval bn line by xNegOverY
    let t78 = circuit_mul(in0, in25);
    let t79 = circuit_add(in24, t78);
    let t80 = circuit_mul(t79, in16); // eval bn line by yInv
    let t81 = circuit_mul(in23, in17); // eval bn line by xNegOverY
    let t82 = circuit_mul(in25, in16); // eval bn line by yInv
    let t83 = circuit_mul(in0, in27);
    let t84 = circuit_add(in26, t83);
    let t85 = circuit_mul(t84, in17); // eval bn line by xNegOverY
    let t86 = circuit_mul(in0, in29);
    let t87 = circuit_add(in28, t86);
    let t88 = circuit_mul(t87, in16); // eval bn line by yInv
    let t89 = circuit_mul(in27, in17); // eval bn line by xNegOverY
    let t90 = circuit_mul(in29, in16); // eval bn line by yInv
    let t91 = circuit_mul(t77, in34); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t92 = circuit_add(in1, t91); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t93 = circuit_mul(t80, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t94 = circuit_add(t92, t93); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t95 = circuit_mul(t81, t3); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t96 = circuit_add(t94, t95); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t97 = circuit_mul(t82, t4); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t98 = circuit_add(t96, t97); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t99 = circuit_mul(t74, t98); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t100 = circuit_mul(t85, in34); // Eval sparse poly line_1p_2 step coeff_1 * z^1
    let t101 = circuit_add(in1, t100); // Eval sparse poly line_1p_2 step + coeff_1 * z^1
    let t102 = circuit_mul(t88, t1); // Eval sparse poly line_1p_2 step coeff_3 * z^3
    let t103 = circuit_add(t101, t102); // Eval sparse poly line_1p_2 step + coeff_3 * z^3
    let t104 = circuit_mul(t89, t3); // Eval sparse poly line_1p_2 step coeff_7 * z^7
    let t105 = circuit_add(t103, t104); // Eval sparse poly line_1p_2 step + coeff_7 * z^7
    let t106 = circuit_mul(t90, t4); // Eval sparse poly line_1p_2 step coeff_9 * z^9
    let t107 = circuit_add(t105, t106); // Eval sparse poly line_1p_2 step + coeff_9 * z^9
    let t108 = circuit_mul(t99, t107); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t109 = circuit_mul(t108, in33);
    let t110 = circuit_sub(t109, in32); // (Π(i,k) (Pk(z))) - Ri(z)
    let t111 = circuit_mul(in35, in30);
    let t112 = circuit_add(t111, t110); // LHS = c1 * LHS + ((Π(i,k) (Pk(z)) - Ri(z))

    let modulus = crate::definitions::get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (t112,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs
        .next_2(
            [0x6871ca8d3c208c16d87cfd3e, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0],
        ); // in0
    circuit_inputs = circuit_inputs.next_2([0x1, 0x0, 0x0, 0x0]); // in1
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(yInv_0); // in2
    circuit_inputs = circuit_inputs.next_2(xNegOverY_0); // in3
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r0a0); // in4
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r0a1); // in5
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r1a0); // in6
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r1a1); // in7
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_10.r0a0); // in8
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_10.r0a1); // in9
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_10.r1a0); // in10
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_10.r1a1); // in11
    circuit_inputs = circuit_inputs.next_2(G2_line_add_10.r0a0); // in12
    circuit_inputs = circuit_inputs.next_2(G2_line_add_10.r0a1); // in13
    circuit_inputs = circuit_inputs.next_2(G2_line_add_10.r1a0); // in14
    circuit_inputs = circuit_inputs.next_2(G2_line_add_10.r1a1); // in15
    circuit_inputs = circuit_inputs.next_2(yInv_1); // in16
    circuit_inputs = circuit_inputs.next_2(xNegOverY_1); // in17
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r0a0); // in18
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r0a1); // in19
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r1a0); // in20
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r1a1); // in21
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_11.r0a0); // in22
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_11.r0a1); // in23
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_11.r1a0); // in24
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_11.r1a1); // in25
    circuit_inputs = circuit_inputs.next_2(G2_line_add_11.r0a0); // in26
    circuit_inputs = circuit_inputs.next_2(G2_line_add_11.r0a1); // in27
    circuit_inputs = circuit_inputs.next_2(G2_line_add_11.r1a0); // in28
    circuit_inputs = circuit_inputs.next_2(G2_line_add_11.r1a1); // in29
    circuit_inputs = circuit_inputs.next_2(lhs_i); // in30
    circuit_inputs = circuit_inputs.next_2(f_i_of_z); // in31
    circuit_inputs = circuit_inputs.next_2(f_i_plus_one_of_z); // in32
    circuit_inputs = circuit_inputs.next_2(c_or_cinv_of_z); // in33
    circuit_inputs = circuit_inputs.next_2(z); // in34
    circuit_inputs = circuit_inputs.next_2(c1); // in35

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let lhs_i_plus_one: u384 = outputs.get_output(t112);
    return (lhs_i_plus_one,);
}
#[inline(always)]
pub fn run_BN254_MP_CHECK_BIT01_3P_2F_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    G2_line_dbl_0: G2Line<u288>,
    G2_line_dbl_10: G2Line<u288>,
    G2_line_add_10: G2Line<u288>,
    yInv_1: u384,
    xNegOverY_1: u384,
    G2_line_dbl_1: G2Line<u288>,
    G2_line_dbl_11: G2Line<u288>,
    G2_line_add_11: G2Line<u288>,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q_2: G2Point,
    Q_or_Q_neg_2: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one_of_z: u384,
    c_or_cinv_of_z: u384,
    z: u384,
    c1: u384,
) -> (G2Point, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // -0x9 % p
    let in1 = CE::<CI<1>> {}; // 0x1
    let in2 = CE::<CI<2>> {}; // 0x3
    let in3 = CE::<CI<3>> {}; // 0x6
    let in4 = CE::<CI<4>> {}; // 0x0

    // INPUT stack
    let (in5, in6, in7) = (CE::<CI<5>> {}, CE::<CI<6>> {}, CE::<CI<7>> {});
    let (in8, in9, in10) = (CE::<CI<8>> {}, CE::<CI<9>> {}, CE::<CI<10>> {});
    let (in11, in12, in13) = (CE::<CI<11>> {}, CE::<CI<12>> {}, CE::<CI<13>> {});
    let (in14, in15, in16) = (CE::<CI<14>> {}, CE::<CI<15>> {}, CE::<CI<16>> {});
    let (in17, in18, in19) = (CE::<CI<17>> {}, CE::<CI<18>> {}, CE::<CI<19>> {});
    let (in20, in21, in22) = (CE::<CI<20>> {}, CE::<CI<21>> {}, CE::<CI<22>> {});
    let (in23, in24, in25) = (CE::<CI<23>> {}, CE::<CI<24>> {}, CE::<CI<25>> {});
    let (in26, in27, in28) = (CE::<CI<26>> {}, CE::<CI<27>> {}, CE::<CI<28>> {});
    let (in29, in30, in31) = (CE::<CI<29>> {}, CE::<CI<30>> {}, CE::<CI<31>> {});
    let (in32, in33, in34) = (CE::<CI<32>> {}, CE::<CI<33>> {}, CE::<CI<34>> {});
    let (in35, in36, in37) = (CE::<CI<35>> {}, CE::<CI<36>> {}, CE::<CI<37>> {});
    let (in38, in39, in40) = (CE::<CI<38>> {}, CE::<CI<39>> {}, CE::<CI<40>> {});
    let (in41, in42, in43) = (CE::<CI<41>> {}, CE::<CI<42>> {}, CE::<CI<43>> {});
    let (in44, in45, in46) = (CE::<CI<44>> {}, CE::<CI<45>> {}, CE::<CI<46>> {});
    let (in47, in48) = (CE::<CI<47>> {}, CE::<CI<48>> {});
    let t0 = circuit_mul(in47, in47); // compute z^2
    let t1 = circuit_mul(t0, in47); // compute z^3
    let t2 = circuit_mul(t1, t1); // compute z^6
    let t3 = circuit_mul(t2, in47); // compute z^7
    let t4 = circuit_mul(t3, t0); // compute z^9
    let t5 = circuit_mul(in44, in44); // Square f evaluation in Z, the result of previous bit.
    let t6 = circuit_mul(in0, in8);
    let t7 = circuit_add(in7, t6);
    let t8 = circuit_mul(t7, in6); // eval bn line by xNegOverY
    let t9 = circuit_mul(in0, in10);
    let t10 = circuit_add(in9, t9);
    let t11 = circuit_mul(t10, in5); // eval bn line by yInv
    let t12 = circuit_mul(in8, in6); // eval bn line by xNegOverY
    let t13 = circuit_mul(in10, in5); // eval bn line by yInv
    let t14 = circuit_mul(t8, in47); // Eval sparse poly line_0p_1 step coeff_1 * z^1
    let t15 = circuit_add(in1, t14); // Eval sparse poly line_0p_1 step + coeff_1 * z^1
    let t16 = circuit_mul(t11, t1); // Eval sparse poly line_0p_1 step coeff_3 * z^3
    let t17 = circuit_add(t15, t16); // Eval sparse poly line_0p_1 step + coeff_3 * z^3
    let t18 = circuit_mul(t12, t3); // Eval sparse poly line_0p_1 step coeff_7 * z^7
    let t19 = circuit_add(t17, t18); // Eval sparse poly line_0p_1 step + coeff_7 * z^7
    let t20 = circuit_mul(t13, t4); // Eval sparse poly line_0p_1 step coeff_9 * z^9
    let t21 = circuit_add(t19, t20); // Eval sparse poly line_0p_1 step + coeff_9 * z^9
    let t22 = circuit_mul(t5, t21); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t23 = circuit_mul(in0, in12);
    let t24 = circuit_add(in11, t23);
    let t25 = circuit_mul(t24, in20); // eval bn line by xNegOverY
    let t26 = circuit_mul(in0, in14);
    let t27 = circuit_add(in13, t26);
    let t28 = circuit_mul(t27, in19); // eval bn line by yInv
    let t29 = circuit_mul(in12, in20); // eval bn line by xNegOverY
    let t30 = circuit_mul(in14, in19); // eval bn line by yInv
    let t31 = circuit_mul(t25, in47); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t32 = circuit_add(in1, t31); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t33 = circuit_mul(t28, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t34 = circuit_add(t32, t33); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t35 = circuit_mul(t29, t3); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t36 = circuit_add(t34, t35); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t37 = circuit_mul(t30, t4); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t38 = circuit_add(t36, t37); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t39 = circuit_mul(t22, t38); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t40 = circuit_add(in35, in36); // Doubling slope numerator start
    let t41 = circuit_sub(in35, in36);
    let t42 = circuit_mul(t40, t41);
    let t43 = circuit_mul(in35, in36);
    let t44 = circuit_mul(t42, in2);
    let t45 = circuit_mul(t43, in3); // Doubling slope numerator end
    let t46 = circuit_add(in37, in37); // Fp2 add coeff 0/1
    let t47 = circuit_add(in38, in38); // Fp2 add coeff 1/1
    let t48 = circuit_mul(t46, t46); // Fp2 Inv start
    let t49 = circuit_mul(t47, t47);
    let t50 = circuit_add(t48, t49);
    let t51 = circuit_inverse(t50);
    let t52 = circuit_mul(t46, t51); // Fp2 Inv real part end
    let t53 = circuit_mul(t47, t51);
    let t54 = circuit_sub(in4, t53); // Fp2 Inv imag part end
    let t55 = circuit_mul(t44, t52); // Fp2 mul start
    let t56 = circuit_mul(t45, t54);
    let t57 = circuit_sub(t55, t56); // Fp2 mul real part end
    let t58 = circuit_mul(t44, t54);
    let t59 = circuit_mul(t45, t52);
    let t60 = circuit_add(t58, t59); // Fp2 mul imag part end
    let t61 = circuit_add(t57, t60);
    let t62 = circuit_sub(t57, t60);
    let t63 = circuit_mul(t61, t62);
    let t64 = circuit_mul(t57, t60);
    let t65 = circuit_add(t64, t64);
    let t66 = circuit_add(in35, in35); // Fp2 add coeff 0/1
    let t67 = circuit_add(in36, in36); // Fp2 add coeff 1/1
    let t68 = circuit_sub(t63, t66); // Fp2 sub coeff 0/1
    let t69 = circuit_sub(t65, t67); // Fp2 sub coeff 1/1
    let t70 = circuit_sub(in35, t68); // Fp2 sub coeff 0/1
    let t71 = circuit_sub(in36, t69); // Fp2 sub coeff 1/1
    let t72 = circuit_mul(t57, t70); // Fp2 mul start
    let t73 = circuit_mul(t60, t71);
    let t74 = circuit_sub(t72, t73); // Fp2 mul real part end
    let t75 = circuit_mul(t57, t71);
    let t76 = circuit_mul(t60, t70);
    let t77 = circuit_add(t75, t76); // Fp2 mul imag part end
    let t78 = circuit_sub(t74, in37); // Fp2 sub coeff 0/1
    let t79 = circuit_sub(t77, in38); // Fp2 sub coeff 1/1
    let t80 = circuit_mul(t57, in35); // Fp2 mul start
    let t81 = circuit_mul(t60, in36);
    let t82 = circuit_sub(t80, t81); // Fp2 mul real part end
    let t83 = circuit_mul(t57, in36);
    let t84 = circuit_mul(t60, in35);
    let t85 = circuit_add(t83, t84); // Fp2 mul imag part end
    let t86 = circuit_sub(t82, in37); // Fp2 sub coeff 0/1
    let t87 = circuit_sub(t85, in38); // Fp2 sub coeff 1/1
    let t88 = circuit_mul(in0, t60);
    let t89 = circuit_add(t57, t88);
    let t90 = circuit_mul(t89, in34); // eval bn line by xNegOverY
    let t91 = circuit_mul(in0, t87);
    let t92 = circuit_add(t86, t91);
    let t93 = circuit_mul(t92, in33); // eval bn line by yInv
    let t94 = circuit_mul(t60, in34); // eval bn line by xNegOverY
    let t95 = circuit_mul(t87, in33); // eval bn line by yInv
    let t96 = circuit_mul(t90, in47); // Eval sparse poly line_2p_1 step coeff_1 * z^1
    let t97 = circuit_add(in1, t96); // Eval sparse poly line_2p_1 step + coeff_1 * z^1
    let t98 = circuit_mul(t93, t1); // Eval sparse poly line_2p_1 step coeff_3 * z^3
    let t99 = circuit_add(t97, t98); // Eval sparse poly line_2p_1 step + coeff_3 * z^3
    let t100 = circuit_mul(t94, t3); // Eval sparse poly line_2p_1 step coeff_7 * z^7
    let t101 = circuit_add(t99, t100); // Eval sparse poly line_2p_1 step + coeff_7 * z^7
    let t102 = circuit_mul(t95, t4); // Eval sparse poly line_2p_1 step coeff_9 * z^9
    let t103 = circuit_add(t101, t102); // Eval sparse poly line_2p_1 step + coeff_9 * z^9
    let t104 = circuit_mul(t39, t103); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t105 = circuit_mul(
        t104, t104,
    ); // Compute (f^2 * Π(i,k) (line_i,k(z))) ^ 2 = f^4 * (Π(i,k) (line_i,k(z)))^2
    let t106 = circuit_mul(in0, in16);
    let t107 = circuit_add(in15, t106);
    let t108 = circuit_mul(t107, in6); // eval bn line by xNegOverY
    let t109 = circuit_mul(in0, in18);
    let t110 = circuit_add(in17, t109);
    let t111 = circuit_mul(t110, in5); // eval bn line by yInv
    let t112 = circuit_mul(in16, in6); // eval bn line by xNegOverY
    let t113 = circuit_mul(in18, in5); // eval bn line by yInv
    let t114 = circuit_mul(in0, in22);
    let t115 = circuit_add(in21, t114);
    let t116 = circuit_mul(t115, in6); // eval bn line by xNegOverY
    let t117 = circuit_mul(in0, in24);
    let t118 = circuit_add(in23, t117);
    let t119 = circuit_mul(t118, in5); // eval bn line by yInv
    let t120 = circuit_mul(in22, in6); // eval bn line by xNegOverY
    let t121 = circuit_mul(in24, in5); // eval bn line by yInv
    let t122 = circuit_mul(t108, in47); // Eval sparse poly line_0p_1 step coeff_1 * z^1
    let t123 = circuit_add(in1, t122); // Eval sparse poly line_0p_1 step + coeff_1 * z^1
    let t124 = circuit_mul(t111, t1); // Eval sparse poly line_0p_1 step coeff_3 * z^3
    let t125 = circuit_add(t123, t124); // Eval sparse poly line_0p_1 step + coeff_3 * z^3
    let t126 = circuit_mul(t112, t3); // Eval sparse poly line_0p_1 step coeff_7 * z^7
    let t127 = circuit_add(t125, t126); // Eval sparse poly line_0p_1 step + coeff_7 * z^7
    let t128 = circuit_mul(t113, t4); // Eval sparse poly line_0p_1 step coeff_9 * z^9
    let t129 = circuit_add(t127, t128); // Eval sparse poly line_0p_1 step + coeff_9 * z^9
    let t130 = circuit_mul(t105, t129); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t131 = circuit_mul(t116, in47); // Eval sparse poly line_0p_2 step coeff_1 * z^1
    let t132 = circuit_add(in1, t131); // Eval sparse poly line_0p_2 step + coeff_1 * z^1
    let t133 = circuit_mul(t119, t1); // Eval sparse poly line_0p_2 step coeff_3 * z^3
    let t134 = circuit_add(t132, t133); // Eval sparse poly line_0p_2 step + coeff_3 * z^3
    let t135 = circuit_mul(t120, t3); // Eval sparse poly line_0p_2 step coeff_7 * z^7
    let t136 = circuit_add(t134, t135); // Eval sparse poly line_0p_2 step + coeff_7 * z^7
    let t137 = circuit_mul(t121, t4); // Eval sparse poly line_0p_2 step coeff_9 * z^9
    let t138 = circuit_add(t136, t137); // Eval sparse poly line_0p_2 step + coeff_9 * z^9
    let t139 = circuit_mul(t130, t138); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t140 = circuit_mul(in0, in26);
    let t141 = circuit_add(in25, t140);
    let t142 = circuit_mul(t141, in20); // eval bn line by xNegOverY
    let t143 = circuit_mul(in0, in28);
    let t144 = circuit_add(in27, t143);
    let t145 = circuit_mul(t144, in19); // eval bn line by yInv
    let t146 = circuit_mul(in26, in20); // eval bn line by xNegOverY
    let t147 = circuit_mul(in28, in19); // eval bn line by yInv
    let t148 = circuit_mul(in0, in30);
    let t149 = circuit_add(in29, t148);
    let t150 = circuit_mul(t149, in20); // eval bn line by xNegOverY
    let t151 = circuit_mul(in0, in32);
    let t152 = circuit_add(in31, t151);
    let t153 = circuit_mul(t152, in19); // eval bn line by yInv
    let t154 = circuit_mul(in30, in20); // eval bn line by xNegOverY
    let t155 = circuit_mul(in32, in19); // eval bn line by yInv
    let t156 = circuit_mul(t142, in47); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t157 = circuit_add(in1, t156); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t158 = circuit_mul(t145, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t159 = circuit_add(t157, t158); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t160 = circuit_mul(t146, t3); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t161 = circuit_add(t159, t160); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t162 = circuit_mul(t147, t4); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t163 = circuit_add(t161, t162); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t164 = circuit_mul(t139, t163); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t165 = circuit_mul(t150, in47); // Eval sparse poly line_1p_2 step coeff_1 * z^1
    let t166 = circuit_add(in1, t165); // Eval sparse poly line_1p_2 step + coeff_1 * z^1
    let t167 = circuit_mul(t153, t1); // Eval sparse poly line_1p_2 step coeff_3 * z^3
    let t168 = circuit_add(t166, t167); // Eval sparse poly line_1p_2 step + coeff_3 * z^3
    let t169 = circuit_mul(t154, t3); // Eval sparse poly line_1p_2 step coeff_7 * z^7
    let t170 = circuit_add(t168, t169); // Eval sparse poly line_1p_2 step + coeff_7 * z^7
    let t171 = circuit_mul(t155, t4); // Eval sparse poly line_1p_2 step coeff_9 * z^9
    let t172 = circuit_add(t170, t171); // Eval sparse poly line_1p_2 step + coeff_9 * z^9
    let t173 = circuit_mul(t164, t172); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t174 = circuit_sub(t78, in41); // Fp2 sub coeff 0/1
    let t175 = circuit_sub(t79, in42); // Fp2 sub coeff 1/1
    let t176 = circuit_sub(t68, in39); // Fp2 sub coeff 0/1
    let t177 = circuit_sub(t69, in40); // Fp2 sub coeff 1/1
    let t178 = circuit_mul(t176, t176); // Fp2 Inv start
    let t179 = circuit_mul(t177, t177);
    let t180 = circuit_add(t178, t179);
    let t181 = circuit_inverse(t180);
    let t182 = circuit_mul(t176, t181); // Fp2 Inv real part end
    let t183 = circuit_mul(t177, t181);
    let t184 = circuit_sub(in4, t183); // Fp2 Inv imag part end
    let t185 = circuit_mul(t174, t182); // Fp2 mul start
    let t186 = circuit_mul(t175, t184);
    let t187 = circuit_sub(t185, t186); // Fp2 mul real part end
    let t188 = circuit_mul(t174, t184);
    let t189 = circuit_mul(t175, t182);
    let t190 = circuit_add(t188, t189); // Fp2 mul imag part end
    let t191 = circuit_add(t187, t190);
    let t192 = circuit_sub(t187, t190);
    let t193 = circuit_mul(t191, t192);
    let t194 = circuit_mul(t187, t190);
    let t195 = circuit_add(t194, t194);
    let t196 = circuit_add(t68, in39); // Fp2 add coeff 0/1
    let t197 = circuit_add(t69, in40); // Fp2 add coeff 1/1
    let t198 = circuit_sub(t193, t196); // Fp2 sub coeff 0/1
    let t199 = circuit_sub(t195, t197); // Fp2 sub coeff 1/1
    let t200 = circuit_mul(t187, t68); // Fp2 mul start
    let t201 = circuit_mul(t190, t69);
    let t202 = circuit_sub(t200, t201); // Fp2 mul real part end
    let t203 = circuit_mul(t187, t69);
    let t204 = circuit_mul(t190, t68);
    let t205 = circuit_add(t203, t204); // Fp2 mul imag part end
    let t206 = circuit_sub(t202, t78); // Fp2 sub coeff 0/1
    let t207 = circuit_sub(t205, t79); // Fp2 sub coeff 1/1
    let t208 = circuit_add(t78, t78); // Fp2 add coeff 0/1
    let t209 = circuit_add(t79, t79); // Fp2 add coeff 1/1
    let t210 = circuit_sub(t198, t68); // Fp2 sub coeff 0/1
    let t211 = circuit_sub(t199, t69); // Fp2 sub coeff 1/1
    let t212 = circuit_mul(t210, t210); // Fp2 Inv start
    let t213 = circuit_mul(t211, t211);
    let t214 = circuit_add(t212, t213);
    let t215 = circuit_inverse(t214);
    let t216 = circuit_mul(t210, t215); // Fp2 Inv real part end
    let t217 = circuit_mul(t211, t215);
    let t218 = circuit_sub(in4, t217); // Fp2 Inv imag part end
    let t219 = circuit_mul(t208, t216); // Fp2 mul start
    let t220 = circuit_mul(t209, t218);
    let t221 = circuit_sub(t219, t220); // Fp2 mul real part end
    let t222 = circuit_mul(t208, t218);
    let t223 = circuit_mul(t209, t216);
    let t224 = circuit_add(t222, t223); // Fp2 mul imag part end
    let t225 = circuit_add(t187, t221); // Fp2 add coeff 0/1
    let t226 = circuit_add(t190, t224); // Fp2 add coeff 1/1
    let t227 = circuit_sub(in4, t225); // Fp2 neg coeff 0/1
    let t228 = circuit_sub(in4, t226); // Fp2 neg coeff 1/1
    let t229 = circuit_add(t227, t228);
    let t230 = circuit_sub(t227, t228);
    let t231 = circuit_mul(t229, t230);
    let t232 = circuit_mul(t227, t228);
    let t233 = circuit_add(t232, t232);
    let t234 = circuit_sub(t231, t68); // Fp2 sub coeff 0/1
    let t235 = circuit_sub(t233, t69); // Fp2 sub coeff 1/1
    let t236 = circuit_sub(t234, t198); // Fp2 sub coeff 0/1
    let t237 = circuit_sub(t235, t199); // Fp2 sub coeff 1/1
    let t238 = circuit_sub(t68, t236); // Fp2 sub coeff 0/1
    let t239 = circuit_sub(t69, t237); // Fp2 sub coeff 1/1
    let t240 = circuit_mul(t227, t238); // Fp2 mul start
    let t241 = circuit_mul(t228, t239);
    let t242 = circuit_sub(t240, t241); // Fp2 mul real part end
    let t243 = circuit_mul(t227, t239);
    let t244 = circuit_mul(t228, t238);
    let t245 = circuit_add(t243, t244); // Fp2 mul imag part end
    let t246 = circuit_sub(t242, t78); // Fp2 sub coeff 0/1
    let t247 = circuit_sub(t245, t79); // Fp2 sub coeff 1/1
    let t248 = circuit_mul(t227, t68); // Fp2 mul start
    let t249 = circuit_mul(t228, t69);
    let t250 = circuit_sub(t248, t249); // Fp2 mul real part end
    let t251 = circuit_mul(t227, t69);
    let t252 = circuit_mul(t228, t68);
    let t253 = circuit_add(t251, t252); // Fp2 mul imag part end
    let t254 = circuit_sub(t250, t78); // Fp2 sub coeff 0/1
    let t255 = circuit_sub(t253, t79); // Fp2 sub coeff 1/1
    let t256 = circuit_mul(in0, t190);
    let t257 = circuit_add(t187, t256);
    let t258 = circuit_mul(t257, in34); // eval bn line by xNegOverY
    let t259 = circuit_mul(in0, t207);
    let t260 = circuit_add(t206, t259);
    let t261 = circuit_mul(t260, in33); // eval bn line by yInv
    let t262 = circuit_mul(t190, in34); // eval bn line by xNegOverY
    let t263 = circuit_mul(t207, in33); // eval bn line by yInv
    let t264 = circuit_mul(in0, t228);
    let t265 = circuit_add(t227, t264);
    let t266 = circuit_mul(t265, in34); // eval bn line by xNegOverY
    let t267 = circuit_mul(in0, t255);
    let t268 = circuit_add(t254, t267);
    let t269 = circuit_mul(t268, in33); // eval bn line by yInv
    let t270 = circuit_mul(t228, in34); // eval bn line by xNegOverY
    let t271 = circuit_mul(t255, in33); // eval bn line by yInv
    let t272 = circuit_mul(t258, in47); // Eval sparse poly line_2p_1 step coeff_1 * z^1
    let t273 = circuit_add(in1, t272); // Eval sparse poly line_2p_1 step + coeff_1 * z^1
    let t274 = circuit_mul(t261, t1); // Eval sparse poly line_2p_1 step coeff_3 * z^3
    let t275 = circuit_add(t273, t274); // Eval sparse poly line_2p_1 step + coeff_3 * z^3
    let t276 = circuit_mul(t262, t3); // Eval sparse poly line_2p_1 step coeff_7 * z^7
    let t277 = circuit_add(t275, t276); // Eval sparse poly line_2p_1 step + coeff_7 * z^7
    let t278 = circuit_mul(t263, t4); // Eval sparse poly line_2p_1 step coeff_9 * z^9
    let t279 = circuit_add(t277, t278); // Eval sparse poly line_2p_1 step + coeff_9 * z^9
    let t280 = circuit_mul(t173, t279); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t281 = circuit_mul(t266, in47); // Eval sparse poly line_2p_2 step coeff_1 * z^1
    let t282 = circuit_add(in1, t281); // Eval sparse poly line_2p_2 step + coeff_1 * z^1
    let t283 = circuit_mul(t269, t1); // Eval sparse poly line_2p_2 step coeff_3 * z^3
    let t284 = circuit_add(t282, t283); // Eval sparse poly line_2p_2 step + coeff_3 * z^3
    let t285 = circuit_mul(t270, t3); // Eval sparse poly line_2p_2 step coeff_7 * z^7
    let t286 = circuit_add(t284, t285); // Eval sparse poly line_2p_2 step + coeff_7 * z^7
    let t287 = circuit_mul(t271, t4); // Eval sparse poly line_2p_2 step coeff_9 * z^9
    let t288 = circuit_add(t286, t287); // Eval sparse poly line_2p_2 step + coeff_9 * z^9
    let t289 = circuit_mul(t280, t288); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t290 = circuit_mul(t289, in46);
    let t291 = circuit_sub(t290, in45); // (Π(i,k) (Pk(z))) - Ri(z)
    let t292 = circuit_mul(in48, in43);
    let t293 = circuit_add(t292, t291); // LHS = c1 * LHS + ((Π(i,k) (Pk(z)) - Ri(z))

    let modulus = crate::definitions::get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (t236, t237, t246, t247, t293).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs
        .next_2(
            [0x6871ca8d3c208c16d87cfd3e, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0],
        ); // in0
    circuit_inputs = circuit_inputs.next_2([0x1, 0x0, 0x0, 0x0]); // in1
    circuit_inputs = circuit_inputs.next_2([0x3, 0x0, 0x0, 0x0]); // in2
    circuit_inputs = circuit_inputs.next_2([0x6, 0x0, 0x0, 0x0]); // in3
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in4
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(yInv_0); // in5
    circuit_inputs = circuit_inputs.next_2(xNegOverY_0); // in6
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r0a0); // in7
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r0a1); // in8
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r1a0); // in9
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r1a1); // in10
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_10.r0a0); // in11
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_10.r0a1); // in12
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_10.r1a0); // in13
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_10.r1a1); // in14
    circuit_inputs = circuit_inputs.next_2(G2_line_add_10.r0a0); // in15
    circuit_inputs = circuit_inputs.next_2(G2_line_add_10.r0a1); // in16
    circuit_inputs = circuit_inputs.next_2(G2_line_add_10.r1a0); // in17
    circuit_inputs = circuit_inputs.next_2(G2_line_add_10.r1a1); // in18
    circuit_inputs = circuit_inputs.next_2(yInv_1); // in19
    circuit_inputs = circuit_inputs.next_2(xNegOverY_1); // in20
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r0a0); // in21
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r0a1); // in22
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r1a0); // in23
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r1a1); // in24
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_11.r0a0); // in25
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_11.r0a1); // in26
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_11.r1a0); // in27
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_11.r1a1); // in28
    circuit_inputs = circuit_inputs.next_2(G2_line_add_11.r0a0); // in29
    circuit_inputs = circuit_inputs.next_2(G2_line_add_11.r0a1); // in30
    circuit_inputs = circuit_inputs.next_2(G2_line_add_11.r1a0); // in31
    circuit_inputs = circuit_inputs.next_2(G2_line_add_11.r1a1); // in32
    circuit_inputs = circuit_inputs.next_2(yInv_2); // in33
    circuit_inputs = circuit_inputs.next_2(xNegOverY_2); // in34
    circuit_inputs = circuit_inputs.next_2(Q_2.x0); // in35
    circuit_inputs = circuit_inputs.next_2(Q_2.x1); // in36
    circuit_inputs = circuit_inputs.next_2(Q_2.y0); // in37
    circuit_inputs = circuit_inputs.next_2(Q_2.y1); // in38
    circuit_inputs = circuit_inputs.next_2(Q_or_Q_neg_2.x0); // in39
    circuit_inputs = circuit_inputs.next_2(Q_or_Q_neg_2.x1); // in40
    circuit_inputs = circuit_inputs.next_2(Q_or_Q_neg_2.y0); // in41
    circuit_inputs = circuit_inputs.next_2(Q_or_Q_neg_2.y1); // in42
    circuit_inputs = circuit_inputs.next_2(lhs_i); // in43
    circuit_inputs = circuit_inputs.next_2(f_i_of_z); // in44
    circuit_inputs = circuit_inputs.next_2(f_i_plus_one_of_z); // in45
    circuit_inputs = circuit_inputs.next_2(c_or_cinv_of_z); // in46
    circuit_inputs = circuit_inputs.next_2(z); // in47
    circuit_inputs = circuit_inputs.next_2(c1); // in48

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let Q0: G2Point = G2Point {
        x0: outputs.get_output(t236),
        x1: outputs.get_output(t237),
        y0: outputs.get_output(t246),
        y1: outputs.get_output(t247),
    };
    let lhs_i_plus_one: u384 = outputs.get_output(t293);
    return (Q0, lhs_i_plus_one);
}
#[inline(always)]
pub fn run_BN254_MP_CHECK_BIT10_2P_2F_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    G2_line_dbl_0: G2Line<u288>,
    G2_line_add_1_0: G2Line<u288>,
    G2_line_dbl_0_0: G2Line<u288>,
    yInv_1: u384,
    xNegOverY_1: u384,
    G2_line_dbl_1: G2Line<u288>,
    G2_line_add_1_1: G2Line<u288>,
    G2_line_dbl_0_1: G2Line<u288>,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one_of_z: u384,
    c_or_cinv_of_z: u384,
    z: u384,
    c1: u384,
) -> (u384,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // -0x9 % p
    let in1 = CE::<CI<1>> {}; // 0x1

    // INPUT stack
    let (in2, in3, in4) = (CE::<CI<2>> {}, CE::<CI<3>> {}, CE::<CI<4>> {});
    let (in5, in6, in7) = (CE::<CI<5>> {}, CE::<CI<6>> {}, CE::<CI<7>> {});
    let (in8, in9, in10) = (CE::<CI<8>> {}, CE::<CI<9>> {}, CE::<CI<10>> {});
    let (in11, in12, in13) = (CE::<CI<11>> {}, CE::<CI<12>> {}, CE::<CI<13>> {});
    let (in14, in15, in16) = (CE::<CI<14>> {}, CE::<CI<15>> {}, CE::<CI<16>> {});
    let (in17, in18, in19) = (CE::<CI<17>> {}, CE::<CI<18>> {}, CE::<CI<19>> {});
    let (in20, in21, in22) = (CE::<CI<20>> {}, CE::<CI<21>> {}, CE::<CI<22>> {});
    let (in23, in24, in25) = (CE::<CI<23>> {}, CE::<CI<24>> {}, CE::<CI<25>> {});
    let (in26, in27, in28) = (CE::<CI<26>> {}, CE::<CI<27>> {}, CE::<CI<28>> {});
    let (in29, in30, in31) = (CE::<CI<29>> {}, CE::<CI<30>> {}, CE::<CI<31>> {});
    let (in32, in33, in34) = (CE::<CI<32>> {}, CE::<CI<33>> {}, CE::<CI<34>> {});
    let in35 = CE::<CI<35>> {};
    let t0 = circuit_mul(in34, in34); // compute z^2
    let t1 = circuit_mul(t0, in34); // compute z^3
    let t2 = circuit_mul(t1, t1); // compute z^6
    let t3 = circuit_mul(t2, in34); // compute z^7
    let t4 = circuit_mul(t3, t0); // compute z^9
    let t5 = circuit_mul(in31, in31); // Square f evaluation in Z, the result of previous bit.
    let t6 = circuit_mul(in0, in5);
    let t7 = circuit_add(in4, t6);
    let t8 = circuit_mul(t7, in3); // eval bn line by xNegOverY
    let t9 = circuit_mul(in0, in7);
    let t10 = circuit_add(in6, t9);
    let t11 = circuit_mul(t10, in2); // eval bn line by yInv
    let t12 = circuit_mul(in5, in3); // eval bn line by xNegOverY
    let t13 = circuit_mul(in7, in2); // eval bn line by yInv
    let t14 = circuit_mul(in0, in9);
    let t15 = circuit_add(in8, t14);
    let t16 = circuit_mul(t15, in3); // eval bn line by xNegOverY
    let t17 = circuit_mul(in0, in11);
    let t18 = circuit_add(in10, t17);
    let t19 = circuit_mul(t18, in2); // eval bn line by yInv
    let t20 = circuit_mul(in9, in3); // eval bn line by xNegOverY
    let t21 = circuit_mul(in11, in2); // eval bn line by yInv
    let t22 = circuit_mul(t8, in34); // Eval sparse poly line_0p_1 step coeff_1 * z^1
    let t23 = circuit_add(in1, t22); // Eval sparse poly line_0p_1 step + coeff_1 * z^1
    let t24 = circuit_mul(t11, t1); // Eval sparse poly line_0p_1 step coeff_3 * z^3
    let t25 = circuit_add(t23, t24); // Eval sparse poly line_0p_1 step + coeff_3 * z^3
    let t26 = circuit_mul(t12, t3); // Eval sparse poly line_0p_1 step coeff_7 * z^7
    let t27 = circuit_add(t25, t26); // Eval sparse poly line_0p_1 step + coeff_7 * z^7
    let t28 = circuit_mul(t13, t4); // Eval sparse poly line_0p_1 step coeff_9 * z^9
    let t29 = circuit_add(t27, t28); // Eval sparse poly line_0p_1 step + coeff_9 * z^9
    let t30 = circuit_mul(t5, t29); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t31 = circuit_mul(t16, in34); // Eval sparse poly line_0p_2 step coeff_1 * z^1
    let t32 = circuit_add(in1, t31); // Eval sparse poly line_0p_2 step + coeff_1 * z^1
    let t33 = circuit_mul(t19, t1); // Eval sparse poly line_0p_2 step coeff_3 * z^3
    let t34 = circuit_add(t32, t33); // Eval sparse poly line_0p_2 step + coeff_3 * z^3
    let t35 = circuit_mul(t20, t3); // Eval sparse poly line_0p_2 step coeff_7 * z^7
    let t36 = circuit_add(t34, t35); // Eval sparse poly line_0p_2 step + coeff_7 * z^7
    let t37 = circuit_mul(t21, t4); // Eval sparse poly line_0p_2 step coeff_9 * z^9
    let t38 = circuit_add(t36, t37); // Eval sparse poly line_0p_2 step + coeff_9 * z^9
    let t39 = circuit_mul(t30, t38); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t40 = circuit_mul(in0, in13);
    let t41 = circuit_add(in12, t40);
    let t42 = circuit_mul(t41, in17); // eval bn line by xNegOverY
    let t43 = circuit_mul(in0, in15);
    let t44 = circuit_add(in14, t43);
    let t45 = circuit_mul(t44, in16); // eval bn line by yInv
    let t46 = circuit_mul(in13, in17); // eval bn line by xNegOverY
    let t47 = circuit_mul(in15, in16); // eval bn line by yInv
    let t48 = circuit_mul(in0, in19);
    let t49 = circuit_add(in18, t48);
    let t50 = circuit_mul(t49, in17); // eval bn line by xNegOverY
    let t51 = circuit_mul(in0, in21);
    let t52 = circuit_add(in20, t51);
    let t53 = circuit_mul(t52, in16); // eval bn line by yInv
    let t54 = circuit_mul(in19, in17); // eval bn line by xNegOverY
    let t55 = circuit_mul(in21, in16); // eval bn line by yInv
    let t56 = circuit_mul(t42, in34); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t57 = circuit_add(in1, t56); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t58 = circuit_mul(t45, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t59 = circuit_add(t57, t58); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t60 = circuit_mul(t46, t3); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t61 = circuit_add(t59, t60); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t62 = circuit_mul(t47, t4); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t63 = circuit_add(t61, t62); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t64 = circuit_mul(t39, t63); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t65 = circuit_mul(t50, in34); // Eval sparse poly line_1p_2 step coeff_1 * z^1
    let t66 = circuit_add(in1, t65); // Eval sparse poly line_1p_2 step + coeff_1 * z^1
    let t67 = circuit_mul(t53, t1); // Eval sparse poly line_1p_2 step coeff_3 * z^3
    let t68 = circuit_add(t66, t67); // Eval sparse poly line_1p_2 step + coeff_3 * z^3
    let t69 = circuit_mul(t54, t3); // Eval sparse poly line_1p_2 step coeff_7 * z^7
    let t70 = circuit_add(t68, t69); // Eval sparse poly line_1p_2 step + coeff_7 * z^7
    let t71 = circuit_mul(t55, t4); // Eval sparse poly line_1p_2 step coeff_9 * z^9
    let t72 = circuit_add(t70, t71); // Eval sparse poly line_1p_2 step + coeff_9 * z^9
    let t73 = circuit_mul(t64, t72); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t74 = circuit_mul(
        t73, t73,
    ); // Compute (f^2 * Π(i,k) (line_i,k(z))) ^ 2 = f^4 * (Π(i,k) (line_i,k(z)))^2
    let t75 = circuit_mul(in0, in23);
    let t76 = circuit_add(in22, t75);
    let t77 = circuit_mul(t76, in3); // eval bn line by xNegOverY
    let t78 = circuit_mul(in0, in25);
    let t79 = circuit_add(in24, t78);
    let t80 = circuit_mul(t79, in2); // eval bn line by yInv
    let t81 = circuit_mul(in23, in3); // eval bn line by xNegOverY
    let t82 = circuit_mul(in25, in2); // eval bn line by yInv
    let t83 = circuit_mul(t77, in34); // Eval sparse poly line_0p_1 step coeff_1 * z^1
    let t84 = circuit_add(in1, t83); // Eval sparse poly line_0p_1 step + coeff_1 * z^1
    let t85 = circuit_mul(t80, t1); // Eval sparse poly line_0p_1 step coeff_3 * z^3
    let t86 = circuit_add(t84, t85); // Eval sparse poly line_0p_1 step + coeff_3 * z^3
    let t87 = circuit_mul(t81, t3); // Eval sparse poly line_0p_1 step coeff_7 * z^7
    let t88 = circuit_add(t86, t87); // Eval sparse poly line_0p_1 step + coeff_7 * z^7
    let t89 = circuit_mul(t82, t4); // Eval sparse poly line_0p_1 step coeff_9 * z^9
    let t90 = circuit_add(t88, t89); // Eval sparse poly line_0p_1 step + coeff_9 * z^9
    let t91 = circuit_mul(t74, t90); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t92 = circuit_mul(in0, in27);
    let t93 = circuit_add(in26, t92);
    let t94 = circuit_mul(t93, in17); // eval bn line by xNegOverY
    let t95 = circuit_mul(in0, in29);
    let t96 = circuit_add(in28, t95);
    let t97 = circuit_mul(t96, in16); // eval bn line by yInv
    let t98 = circuit_mul(in27, in17); // eval bn line by xNegOverY
    let t99 = circuit_mul(in29, in16); // eval bn line by yInv
    let t100 = circuit_mul(t94, in34); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t101 = circuit_add(in1, t100); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t102 = circuit_mul(t97, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t103 = circuit_add(t101, t102); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t104 = circuit_mul(t98, t3); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t105 = circuit_add(t103, t104); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t106 = circuit_mul(t99, t4); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t107 = circuit_add(t105, t106); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t108 = circuit_mul(t91, t107); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t109 = circuit_mul(in33, in33);
    let t110 = circuit_mul(t108, t109);
    let t111 = circuit_sub(t110, in32); // (Π(i,k) (Pk(z))) - Ri(z)
    let t112 = circuit_mul(in35, in30);
    let t113 = circuit_add(t112, t111); // LHS = c1 * LHS + ((Π(i,k) (Pk(z)) - Ri(z))

    let modulus = crate::definitions::get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (t113,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs
        .next_2(
            [0x6871ca8d3c208c16d87cfd3e, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0],
        ); // in0
    circuit_inputs = circuit_inputs.next_2([0x1, 0x0, 0x0, 0x0]); // in1
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(yInv_0); // in2
    circuit_inputs = circuit_inputs.next_2(xNegOverY_0); // in3
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r0a0); // in4
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r0a1); // in5
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r1a0); // in6
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r1a1); // in7
    circuit_inputs = circuit_inputs.next_2(G2_line_add_1_0.r0a0); // in8
    circuit_inputs = circuit_inputs.next_2(G2_line_add_1_0.r0a1); // in9
    circuit_inputs = circuit_inputs.next_2(G2_line_add_1_0.r1a0); // in10
    circuit_inputs = circuit_inputs.next_2(G2_line_add_1_0.r1a1); // in11
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0_0.r0a0); // in12
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0_0.r0a1); // in13
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0_0.r1a0); // in14
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0_0.r1a1); // in15
    circuit_inputs = circuit_inputs.next_2(yInv_1); // in16
    circuit_inputs = circuit_inputs.next_2(xNegOverY_1); // in17
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r0a0); // in18
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r0a1); // in19
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r1a0); // in20
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r1a1); // in21
    circuit_inputs = circuit_inputs.next_2(G2_line_add_1_1.r0a0); // in22
    circuit_inputs = circuit_inputs.next_2(G2_line_add_1_1.r0a1); // in23
    circuit_inputs = circuit_inputs.next_2(G2_line_add_1_1.r1a0); // in24
    circuit_inputs = circuit_inputs.next_2(G2_line_add_1_1.r1a1); // in25
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0_1.r0a0); // in26
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0_1.r0a1); // in27
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0_1.r1a0); // in28
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0_1.r1a1); // in29
    circuit_inputs = circuit_inputs.next_2(lhs_i); // in30
    circuit_inputs = circuit_inputs.next_2(f_i_of_z); // in31
    circuit_inputs = circuit_inputs.next_2(f_i_plus_one_of_z); // in32
    circuit_inputs = circuit_inputs.next_2(c_or_cinv_of_z); // in33
    circuit_inputs = circuit_inputs.next_2(z); // in34
    circuit_inputs = circuit_inputs.next_2(c1); // in35

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let lhs_i_plus_one: u384 = outputs.get_output(t113);
    return (lhs_i_plus_one,);
}
#[inline(always)]
pub fn run_BN254_MP_CHECK_BIT10_3P_2F_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    G2_line_dbl_0: G2Line<u288>,
    G2_line_add_1_0: G2Line<u288>,
    G2_line_dbl_0_0: G2Line<u288>,
    yInv_1: u384,
    xNegOverY_1: u384,
    G2_line_dbl_1: G2Line<u288>,
    G2_line_add_1_1: G2Line<u288>,
    G2_line_dbl_0_1: G2Line<u288>,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q_2: G2Point,
    Q_or_Q_neg_2: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one_of_z: u384,
    c_or_cinv_of_z: u384,
    z: u384,
    c1: u384,
) -> (G2Point, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // -0x9 % p
    let in1 = CE::<CI<1>> {}; // 0x1
    let in2 = CE::<CI<2>> {}; // 0x0
    let in3 = CE::<CI<3>> {}; // 0x3
    let in4 = CE::<CI<4>> {}; // 0x6

    // INPUT stack
    let (in5, in6, in7) = (CE::<CI<5>> {}, CE::<CI<6>> {}, CE::<CI<7>> {});
    let (in8, in9, in10) = (CE::<CI<8>> {}, CE::<CI<9>> {}, CE::<CI<10>> {});
    let (in11, in12, in13) = (CE::<CI<11>> {}, CE::<CI<12>> {}, CE::<CI<13>> {});
    let (in14, in15, in16) = (CE::<CI<14>> {}, CE::<CI<15>> {}, CE::<CI<16>> {});
    let (in17, in18, in19) = (CE::<CI<17>> {}, CE::<CI<18>> {}, CE::<CI<19>> {});
    let (in20, in21, in22) = (CE::<CI<20>> {}, CE::<CI<21>> {}, CE::<CI<22>> {});
    let (in23, in24, in25) = (CE::<CI<23>> {}, CE::<CI<24>> {}, CE::<CI<25>> {});
    let (in26, in27, in28) = (CE::<CI<26>> {}, CE::<CI<27>> {}, CE::<CI<28>> {});
    let (in29, in30, in31) = (CE::<CI<29>> {}, CE::<CI<30>> {}, CE::<CI<31>> {});
    let (in32, in33, in34) = (CE::<CI<32>> {}, CE::<CI<33>> {}, CE::<CI<34>> {});
    let (in35, in36, in37) = (CE::<CI<35>> {}, CE::<CI<36>> {}, CE::<CI<37>> {});
    let (in38, in39, in40) = (CE::<CI<38>> {}, CE::<CI<39>> {}, CE::<CI<40>> {});
    let (in41, in42, in43) = (CE::<CI<41>> {}, CE::<CI<42>> {}, CE::<CI<43>> {});
    let (in44, in45, in46) = (CE::<CI<44>> {}, CE::<CI<45>> {}, CE::<CI<46>> {});
    let (in47, in48) = (CE::<CI<47>> {}, CE::<CI<48>> {});
    let t0 = circuit_mul(in47, in47); // compute z^2
    let t1 = circuit_mul(t0, in47); // compute z^3
    let t2 = circuit_mul(t1, t1); // compute z^6
    let t3 = circuit_mul(t2, in47); // compute z^7
    let t4 = circuit_mul(t3, t0); // compute z^9
    let t5 = circuit_mul(in44, in44); // Square f evaluation in Z, the result of previous bit.
    let t6 = circuit_mul(in0, in8);
    let t7 = circuit_add(in7, t6);
    let t8 = circuit_mul(t7, in6); // eval bn line by xNegOverY
    let t9 = circuit_mul(in0, in10);
    let t10 = circuit_add(in9, t9);
    let t11 = circuit_mul(t10, in5); // eval bn line by yInv
    let t12 = circuit_mul(in8, in6); // eval bn line by xNegOverY
    let t13 = circuit_mul(in10, in5); // eval bn line by yInv
    let t14 = circuit_mul(in0, in12);
    let t15 = circuit_add(in11, t14);
    let t16 = circuit_mul(t15, in6); // eval bn line by xNegOverY
    let t17 = circuit_mul(in0, in14);
    let t18 = circuit_add(in13, t17);
    let t19 = circuit_mul(t18, in5); // eval bn line by yInv
    let t20 = circuit_mul(in12, in6); // eval bn line by xNegOverY
    let t21 = circuit_mul(in14, in5); // eval bn line by yInv
    let t22 = circuit_mul(t8, in47); // Eval sparse poly line_0p_1 step coeff_1 * z^1
    let t23 = circuit_add(in1, t22); // Eval sparse poly line_0p_1 step + coeff_1 * z^1
    let t24 = circuit_mul(t11, t1); // Eval sparse poly line_0p_1 step coeff_3 * z^3
    let t25 = circuit_add(t23, t24); // Eval sparse poly line_0p_1 step + coeff_3 * z^3
    let t26 = circuit_mul(t12, t3); // Eval sparse poly line_0p_1 step coeff_7 * z^7
    let t27 = circuit_add(t25, t26); // Eval sparse poly line_0p_1 step + coeff_7 * z^7
    let t28 = circuit_mul(t13, t4); // Eval sparse poly line_0p_1 step coeff_9 * z^9
    let t29 = circuit_add(t27, t28); // Eval sparse poly line_0p_1 step + coeff_9 * z^9
    let t30 = circuit_mul(t5, t29); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t31 = circuit_mul(t16, in47); // Eval sparse poly line_0p_2 step coeff_1 * z^1
    let t32 = circuit_add(in1, t31); // Eval sparse poly line_0p_2 step + coeff_1 * z^1
    let t33 = circuit_mul(t19, t1); // Eval sparse poly line_0p_2 step coeff_3 * z^3
    let t34 = circuit_add(t32, t33); // Eval sparse poly line_0p_2 step + coeff_3 * z^3
    let t35 = circuit_mul(t20, t3); // Eval sparse poly line_0p_2 step coeff_7 * z^7
    let t36 = circuit_add(t34, t35); // Eval sparse poly line_0p_2 step + coeff_7 * z^7
    let t37 = circuit_mul(t21, t4); // Eval sparse poly line_0p_2 step coeff_9 * z^9
    let t38 = circuit_add(t36, t37); // Eval sparse poly line_0p_2 step + coeff_9 * z^9
    let t39 = circuit_mul(t30, t38); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t40 = circuit_mul(in0, in16);
    let t41 = circuit_add(in15, t40);
    let t42 = circuit_mul(t41, in20); // eval bn line by xNegOverY
    let t43 = circuit_mul(in0, in18);
    let t44 = circuit_add(in17, t43);
    let t45 = circuit_mul(t44, in19); // eval bn line by yInv
    let t46 = circuit_mul(in16, in20); // eval bn line by xNegOverY
    let t47 = circuit_mul(in18, in19); // eval bn line by yInv
    let t48 = circuit_mul(in0, in22);
    let t49 = circuit_add(in21, t48);
    let t50 = circuit_mul(t49, in20); // eval bn line by xNegOverY
    let t51 = circuit_mul(in0, in24);
    let t52 = circuit_add(in23, t51);
    let t53 = circuit_mul(t52, in19); // eval bn line by yInv
    let t54 = circuit_mul(in22, in20); // eval bn line by xNegOverY
    let t55 = circuit_mul(in24, in19); // eval bn line by yInv
    let t56 = circuit_mul(t42, in47); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t57 = circuit_add(in1, t56); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t58 = circuit_mul(t45, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t59 = circuit_add(t57, t58); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t60 = circuit_mul(t46, t3); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t61 = circuit_add(t59, t60); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t62 = circuit_mul(t47, t4); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t63 = circuit_add(t61, t62); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t64 = circuit_mul(t39, t63); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t65 = circuit_mul(t50, in47); // Eval sparse poly line_1p_2 step coeff_1 * z^1
    let t66 = circuit_add(in1, t65); // Eval sparse poly line_1p_2 step + coeff_1 * z^1
    let t67 = circuit_mul(t53, t1); // Eval sparse poly line_1p_2 step coeff_3 * z^3
    let t68 = circuit_add(t66, t67); // Eval sparse poly line_1p_2 step + coeff_3 * z^3
    let t69 = circuit_mul(t54, t3); // Eval sparse poly line_1p_2 step coeff_7 * z^7
    let t70 = circuit_add(t68, t69); // Eval sparse poly line_1p_2 step + coeff_7 * z^7
    let t71 = circuit_mul(t55, t4); // Eval sparse poly line_1p_2 step coeff_9 * z^9
    let t72 = circuit_add(t70, t71); // Eval sparse poly line_1p_2 step + coeff_9 * z^9
    let t73 = circuit_mul(t64, t72); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t74 = circuit_sub(in37, in41); // Fp2 sub coeff 0/1
    let t75 = circuit_sub(in38, in42); // Fp2 sub coeff 1/1
    let t76 = circuit_sub(in35, in39); // Fp2 sub coeff 0/1
    let t77 = circuit_sub(in36, in40); // Fp2 sub coeff 1/1
    let t78 = circuit_mul(t76, t76); // Fp2 Inv start
    let t79 = circuit_mul(t77, t77);
    let t80 = circuit_add(t78, t79);
    let t81 = circuit_inverse(t80);
    let t82 = circuit_mul(t76, t81); // Fp2 Inv real part end
    let t83 = circuit_mul(t77, t81);
    let t84 = circuit_sub(in2, t83); // Fp2 Inv imag part end
    let t85 = circuit_mul(t74, t82); // Fp2 mul start
    let t86 = circuit_mul(t75, t84);
    let t87 = circuit_sub(t85, t86); // Fp2 mul real part end
    let t88 = circuit_mul(t74, t84);
    let t89 = circuit_mul(t75, t82);
    let t90 = circuit_add(t88, t89); // Fp2 mul imag part end
    let t91 = circuit_add(t87, t90);
    let t92 = circuit_sub(t87, t90);
    let t93 = circuit_mul(t91, t92);
    let t94 = circuit_mul(t87, t90);
    let t95 = circuit_add(t94, t94);
    let t96 = circuit_add(in35, in39); // Fp2 add coeff 0/1
    let t97 = circuit_add(in36, in40); // Fp2 add coeff 1/1
    let t98 = circuit_sub(t93, t96); // Fp2 sub coeff 0/1
    let t99 = circuit_sub(t95, t97); // Fp2 sub coeff 1/1
    let t100 = circuit_mul(t87, in35); // Fp2 mul start
    let t101 = circuit_mul(t90, in36);
    let t102 = circuit_sub(t100, t101); // Fp2 mul real part end
    let t103 = circuit_mul(t87, in36);
    let t104 = circuit_mul(t90, in35);
    let t105 = circuit_add(t103, t104); // Fp2 mul imag part end
    let t106 = circuit_sub(t102, in37); // Fp2 sub coeff 0/1
    let t107 = circuit_sub(t105, in38); // Fp2 sub coeff 1/1
    let t108 = circuit_add(in37, in37); // Fp2 add coeff 0/1
    let t109 = circuit_add(in38, in38); // Fp2 add coeff 1/1
    let t110 = circuit_sub(t98, in35); // Fp2 sub coeff 0/1
    let t111 = circuit_sub(t99, in36); // Fp2 sub coeff 1/1
    let t112 = circuit_mul(t110, t110); // Fp2 Inv start
    let t113 = circuit_mul(t111, t111);
    let t114 = circuit_add(t112, t113);
    let t115 = circuit_inverse(t114);
    let t116 = circuit_mul(t110, t115); // Fp2 Inv real part end
    let t117 = circuit_mul(t111, t115);
    let t118 = circuit_sub(in2, t117); // Fp2 Inv imag part end
    let t119 = circuit_mul(t108, t116); // Fp2 mul start
    let t120 = circuit_mul(t109, t118);
    let t121 = circuit_sub(t119, t120); // Fp2 mul real part end
    let t122 = circuit_mul(t108, t118);
    let t123 = circuit_mul(t109, t116);
    let t124 = circuit_add(t122, t123); // Fp2 mul imag part end
    let t125 = circuit_add(t87, t121); // Fp2 add coeff 0/1
    let t126 = circuit_add(t90, t124); // Fp2 add coeff 1/1
    let t127 = circuit_sub(in2, t125); // Fp2 neg coeff 0/1
    let t128 = circuit_sub(in2, t126); // Fp2 neg coeff 1/1
    let t129 = circuit_add(t127, t128);
    let t130 = circuit_sub(t127, t128);
    let t131 = circuit_mul(t129, t130);
    let t132 = circuit_mul(t127, t128);
    let t133 = circuit_add(t132, t132);
    let t134 = circuit_sub(t131, in35); // Fp2 sub coeff 0/1
    let t135 = circuit_sub(t133, in36); // Fp2 sub coeff 1/1
    let t136 = circuit_sub(t134, t98); // Fp2 sub coeff 0/1
    let t137 = circuit_sub(t135, t99); // Fp2 sub coeff 1/1
    let t138 = circuit_sub(in35, t136); // Fp2 sub coeff 0/1
    let t139 = circuit_sub(in36, t137); // Fp2 sub coeff 1/1
    let t140 = circuit_mul(t127, t138); // Fp2 mul start
    let t141 = circuit_mul(t128, t139);
    let t142 = circuit_sub(t140, t141); // Fp2 mul real part end
    let t143 = circuit_mul(t127, t139);
    let t144 = circuit_mul(t128, t138);
    let t145 = circuit_add(t143, t144); // Fp2 mul imag part end
    let t146 = circuit_sub(t142, in37); // Fp2 sub coeff 0/1
    let t147 = circuit_sub(t145, in38); // Fp2 sub coeff 1/1
    let t148 = circuit_mul(t127, in35); // Fp2 mul start
    let t149 = circuit_mul(t128, in36);
    let t150 = circuit_sub(t148, t149); // Fp2 mul real part end
    let t151 = circuit_mul(t127, in36);
    let t152 = circuit_mul(t128, in35);
    let t153 = circuit_add(t151, t152); // Fp2 mul imag part end
    let t154 = circuit_sub(t150, in37); // Fp2 sub coeff 0/1
    let t155 = circuit_sub(t153, in38); // Fp2 sub coeff 1/1
    let t156 = circuit_mul(in0, t90);
    let t157 = circuit_add(t87, t156);
    let t158 = circuit_mul(t157, in34); // eval bn line by xNegOverY
    let t159 = circuit_mul(in0, t107);
    let t160 = circuit_add(t106, t159);
    let t161 = circuit_mul(t160, in33); // eval bn line by yInv
    let t162 = circuit_mul(t90, in34); // eval bn line by xNegOverY
    let t163 = circuit_mul(t107, in33); // eval bn line by yInv
    let t164 = circuit_mul(in0, t128);
    let t165 = circuit_add(t127, t164);
    let t166 = circuit_mul(t165, in34); // eval bn line by xNegOverY
    let t167 = circuit_mul(in0, t155);
    let t168 = circuit_add(t154, t167);
    let t169 = circuit_mul(t168, in33); // eval bn line by yInv
    let t170 = circuit_mul(t128, in34); // eval bn line by xNegOverY
    let t171 = circuit_mul(t155, in33); // eval bn line by yInv
    let t172 = circuit_mul(t158, in47); // Eval sparse poly line_2p_1 step coeff_1 * z^1
    let t173 = circuit_add(in1, t172); // Eval sparse poly line_2p_1 step + coeff_1 * z^1
    let t174 = circuit_mul(t161, t1); // Eval sparse poly line_2p_1 step coeff_3 * z^3
    let t175 = circuit_add(t173, t174); // Eval sparse poly line_2p_1 step + coeff_3 * z^3
    let t176 = circuit_mul(t162, t3); // Eval sparse poly line_2p_1 step coeff_7 * z^7
    let t177 = circuit_add(t175, t176); // Eval sparse poly line_2p_1 step + coeff_7 * z^7
    let t178 = circuit_mul(t163, t4); // Eval sparse poly line_2p_1 step coeff_9 * z^9
    let t179 = circuit_add(t177, t178); // Eval sparse poly line_2p_1 step + coeff_9 * z^9
    let t180 = circuit_mul(t73, t179); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t181 = circuit_mul(t166, in47); // Eval sparse poly line_2p_2 step coeff_1 * z^1
    let t182 = circuit_add(in1, t181); // Eval sparse poly line_2p_2 step + coeff_1 * z^1
    let t183 = circuit_mul(t169, t1); // Eval sparse poly line_2p_2 step coeff_3 * z^3
    let t184 = circuit_add(t182, t183); // Eval sparse poly line_2p_2 step + coeff_3 * z^3
    let t185 = circuit_mul(t170, t3); // Eval sparse poly line_2p_2 step coeff_7 * z^7
    let t186 = circuit_add(t184, t185); // Eval sparse poly line_2p_2 step + coeff_7 * z^7
    let t187 = circuit_mul(t171, t4); // Eval sparse poly line_2p_2 step coeff_9 * z^9
    let t188 = circuit_add(t186, t187); // Eval sparse poly line_2p_2 step + coeff_9 * z^9
    let t189 = circuit_mul(t180, t188); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t190 = circuit_mul(
        t189, t189,
    ); // Compute (f^2 * Π(i,k) (line_i,k(z))) ^ 2 = f^4 * (Π(i,k) (line_i,k(z)))^2
    let t191 = circuit_mul(in0, in26);
    let t192 = circuit_add(in25, t191);
    let t193 = circuit_mul(t192, in6); // eval bn line by xNegOverY
    let t194 = circuit_mul(in0, in28);
    let t195 = circuit_add(in27, t194);
    let t196 = circuit_mul(t195, in5); // eval bn line by yInv
    let t197 = circuit_mul(in26, in6); // eval bn line by xNegOverY
    let t198 = circuit_mul(in28, in5); // eval bn line by yInv
    let t199 = circuit_mul(t193, in47); // Eval sparse poly line_0p_1 step coeff_1 * z^1
    let t200 = circuit_add(in1, t199); // Eval sparse poly line_0p_1 step + coeff_1 * z^1
    let t201 = circuit_mul(t196, t1); // Eval sparse poly line_0p_1 step coeff_3 * z^3
    let t202 = circuit_add(t200, t201); // Eval sparse poly line_0p_1 step + coeff_3 * z^3
    let t203 = circuit_mul(t197, t3); // Eval sparse poly line_0p_1 step coeff_7 * z^7
    let t204 = circuit_add(t202, t203); // Eval sparse poly line_0p_1 step + coeff_7 * z^7
    let t205 = circuit_mul(t198, t4); // Eval sparse poly line_0p_1 step coeff_9 * z^9
    let t206 = circuit_add(t204, t205); // Eval sparse poly line_0p_1 step + coeff_9 * z^9
    let t207 = circuit_mul(t190, t206); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t208 = circuit_mul(in0, in30);
    let t209 = circuit_add(in29, t208);
    let t210 = circuit_mul(t209, in20); // eval bn line by xNegOverY
    let t211 = circuit_mul(in0, in32);
    let t212 = circuit_add(in31, t211);
    let t213 = circuit_mul(t212, in19); // eval bn line by yInv
    let t214 = circuit_mul(in30, in20); // eval bn line by xNegOverY
    let t215 = circuit_mul(in32, in19); // eval bn line by yInv
    let t216 = circuit_mul(t210, in47); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t217 = circuit_add(in1, t216); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t218 = circuit_mul(t213, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t219 = circuit_add(t217, t218); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t220 = circuit_mul(t214, t3); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t221 = circuit_add(t219, t220); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t222 = circuit_mul(t215, t4); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t223 = circuit_add(t221, t222); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t224 = circuit_mul(t207, t223); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t225 = circuit_add(t136, t137); // Doubling slope numerator start
    let t226 = circuit_sub(t136, t137);
    let t227 = circuit_mul(t225, t226);
    let t228 = circuit_mul(t136, t137);
    let t229 = circuit_mul(t227, in3);
    let t230 = circuit_mul(t228, in4); // Doubling slope numerator end
    let t231 = circuit_add(t146, t146); // Fp2 add coeff 0/1
    let t232 = circuit_add(t147, t147); // Fp2 add coeff 1/1
    let t233 = circuit_mul(t231, t231); // Fp2 Inv start
    let t234 = circuit_mul(t232, t232);
    let t235 = circuit_add(t233, t234);
    let t236 = circuit_inverse(t235);
    let t237 = circuit_mul(t231, t236); // Fp2 Inv real part end
    let t238 = circuit_mul(t232, t236);
    let t239 = circuit_sub(in2, t238); // Fp2 Inv imag part end
    let t240 = circuit_mul(t229, t237); // Fp2 mul start
    let t241 = circuit_mul(t230, t239);
    let t242 = circuit_sub(t240, t241); // Fp2 mul real part end
    let t243 = circuit_mul(t229, t239);
    let t244 = circuit_mul(t230, t237);
    let t245 = circuit_add(t243, t244); // Fp2 mul imag part end
    let t246 = circuit_add(t242, t245);
    let t247 = circuit_sub(t242, t245);
    let t248 = circuit_mul(t246, t247);
    let t249 = circuit_mul(t242, t245);
    let t250 = circuit_add(t249, t249);
    let t251 = circuit_add(t136, t136); // Fp2 add coeff 0/1
    let t252 = circuit_add(t137, t137); // Fp2 add coeff 1/1
    let t253 = circuit_sub(t248, t251); // Fp2 sub coeff 0/1
    let t254 = circuit_sub(t250, t252); // Fp2 sub coeff 1/1
    let t255 = circuit_sub(t136, t253); // Fp2 sub coeff 0/1
    let t256 = circuit_sub(t137, t254); // Fp2 sub coeff 1/1
    let t257 = circuit_mul(t242, t255); // Fp2 mul start
    let t258 = circuit_mul(t245, t256);
    let t259 = circuit_sub(t257, t258); // Fp2 mul real part end
    let t260 = circuit_mul(t242, t256);
    let t261 = circuit_mul(t245, t255);
    let t262 = circuit_add(t260, t261); // Fp2 mul imag part end
    let t263 = circuit_sub(t259, t146); // Fp2 sub coeff 0/1
    let t264 = circuit_sub(t262, t147); // Fp2 sub coeff 1/1
    let t265 = circuit_mul(t242, t136); // Fp2 mul start
    let t266 = circuit_mul(t245, t137);
    let t267 = circuit_sub(t265, t266); // Fp2 mul real part end
    let t268 = circuit_mul(t242, t137);
    let t269 = circuit_mul(t245, t136);
    let t270 = circuit_add(t268, t269); // Fp2 mul imag part end
    let t271 = circuit_sub(t267, t146); // Fp2 sub coeff 0/1
    let t272 = circuit_sub(t270, t147); // Fp2 sub coeff 1/1
    let t273 = circuit_mul(in0, t245);
    let t274 = circuit_add(t242, t273);
    let t275 = circuit_mul(t274, in34); // eval bn line by xNegOverY
    let t276 = circuit_mul(in0, t272);
    let t277 = circuit_add(t271, t276);
    let t278 = circuit_mul(t277, in33); // eval bn line by yInv
    let t279 = circuit_mul(t245, in34); // eval bn line by xNegOverY
    let t280 = circuit_mul(t272, in33); // eval bn line by yInv
    let t281 = circuit_mul(t275, in47); // Eval sparse poly line_2p_1 step coeff_1 * z^1
    let t282 = circuit_add(in1, t281); // Eval sparse poly line_2p_1 step + coeff_1 * z^1
    let t283 = circuit_mul(t278, t1); // Eval sparse poly line_2p_1 step coeff_3 * z^3
    let t284 = circuit_add(t282, t283); // Eval sparse poly line_2p_1 step + coeff_3 * z^3
    let t285 = circuit_mul(t279, t3); // Eval sparse poly line_2p_1 step coeff_7 * z^7
    let t286 = circuit_add(t284, t285); // Eval sparse poly line_2p_1 step + coeff_7 * z^7
    let t287 = circuit_mul(t280, t4); // Eval sparse poly line_2p_1 step coeff_9 * z^9
    let t288 = circuit_add(t286, t287); // Eval sparse poly line_2p_1 step + coeff_9 * z^9
    let t289 = circuit_mul(t224, t288); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t290 = circuit_mul(in46, in46);
    let t291 = circuit_mul(t289, t290);
    let t292 = circuit_sub(t291, in45); // (Π(i,k) (Pk(z))) - Ri(z)
    let t293 = circuit_mul(in48, in43);
    let t294 = circuit_add(t293, t292); // LHS = c1 * LHS + ((Π(i,k) (Pk(z)) - Ri(z))

    let modulus = crate::definitions::get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (t253, t254, t263, t264, t294).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs
        .next_2(
            [0x6871ca8d3c208c16d87cfd3e, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0],
        ); // in0
    circuit_inputs = circuit_inputs.next_2([0x1, 0x0, 0x0, 0x0]); // in1
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in2
    circuit_inputs = circuit_inputs.next_2([0x3, 0x0, 0x0, 0x0]); // in3
    circuit_inputs = circuit_inputs.next_2([0x6, 0x0, 0x0, 0x0]); // in4
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(yInv_0); // in5
    circuit_inputs = circuit_inputs.next_2(xNegOverY_0); // in6
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r0a0); // in7
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r0a1); // in8
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r1a0); // in9
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0.r1a1); // in10
    circuit_inputs = circuit_inputs.next_2(G2_line_add_1_0.r0a0); // in11
    circuit_inputs = circuit_inputs.next_2(G2_line_add_1_0.r0a1); // in12
    circuit_inputs = circuit_inputs.next_2(G2_line_add_1_0.r1a0); // in13
    circuit_inputs = circuit_inputs.next_2(G2_line_add_1_0.r1a1); // in14
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0_0.r0a0); // in15
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0_0.r0a1); // in16
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0_0.r1a0); // in17
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0_0.r1a1); // in18
    circuit_inputs = circuit_inputs.next_2(yInv_1); // in19
    circuit_inputs = circuit_inputs.next_2(xNegOverY_1); // in20
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r0a0); // in21
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r0a1); // in22
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r1a0); // in23
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_1.r1a1); // in24
    circuit_inputs = circuit_inputs.next_2(G2_line_add_1_1.r0a0); // in25
    circuit_inputs = circuit_inputs.next_2(G2_line_add_1_1.r0a1); // in26
    circuit_inputs = circuit_inputs.next_2(G2_line_add_1_1.r1a0); // in27
    circuit_inputs = circuit_inputs.next_2(G2_line_add_1_1.r1a1); // in28
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0_1.r0a0); // in29
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0_1.r0a1); // in30
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0_1.r1a0); // in31
    circuit_inputs = circuit_inputs.next_2(G2_line_dbl_0_1.r1a1); // in32
    circuit_inputs = circuit_inputs.next_2(yInv_2); // in33
    circuit_inputs = circuit_inputs.next_2(xNegOverY_2); // in34
    circuit_inputs = circuit_inputs.next_2(Q_2.x0); // in35
    circuit_inputs = circuit_inputs.next_2(Q_2.x1); // in36
    circuit_inputs = circuit_inputs.next_2(Q_2.y0); // in37
    circuit_inputs = circuit_inputs.next_2(Q_2.y1); // in38
    circuit_inputs = circuit_inputs.next_2(Q_or_Q_neg_2.x0); // in39
    circuit_inputs = circuit_inputs.next_2(Q_or_Q_neg_2.x1); // in40
    circuit_inputs = circuit_inputs.next_2(Q_or_Q_neg_2.y0); // in41
    circuit_inputs = circuit_inputs.next_2(Q_or_Q_neg_2.y1); // in42
    circuit_inputs = circuit_inputs.next_2(lhs_i); // in43
    circuit_inputs = circuit_inputs.next_2(f_i_of_z); // in44
    circuit_inputs = circuit_inputs.next_2(f_i_plus_one_of_z); // in45
    circuit_inputs = circuit_inputs.next_2(c_or_cinv_of_z); // in46
    circuit_inputs = circuit_inputs.next_2(z); // in47
    circuit_inputs = circuit_inputs.next_2(c1); // in48

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let Q0: G2Point = G2Point {
        x0: outputs.get_output(t253),
        x1: outputs.get_output(t254),
        y0: outputs.get_output(t263),
        y1: outputs.get_output(t264),
    };
    let lhs_i_plus_one: u384 = outputs.get_output(t294);
    return (Q0, lhs_i_plus_one);
}
#[inline(always)]
pub fn run_BN254_MP_CHECK_FINALIZE_2P_2F_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    line_1_0: G2Line<u288>,
    line_2_0: G2Line<u288>,
    yInv_1: u384,
    xNegOverY_1: u384,
    line_1_1: G2Line<u288>,
    line_2_1: G2Line<u288>,
    R_n_minus_2_of_z: u384,
    R_n_minus_1_of_z: u384,
    c_0: u384,
    w_of_z: u384,
    z: u384,
    c_inv_frob_1_of_z: u384,
    c_frob_2_of_z: u384,
    c_inv_frob_3_of_z: u384,
    previous_lhs: u384,
    R_n_minus_3_of_z: u384,
    Q: Array<u288>,
) -> (u384,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // -0x9 % p
    let in1 = CE::<CI<1>> {}; // 0x1
    let in2 = CE::<CI<2>> {}; // 0x52
    let in3 = CE::<CI<3>> {}; // -0x12 % p

    // INPUT stack
    let (in4, in5, in6) = (CE::<CI<4>> {}, CE::<CI<5>> {}, CE::<CI<6>> {});
    let (in7, in8, in9) = (CE::<CI<7>> {}, CE::<CI<8>> {}, CE::<CI<9>> {});
    let (in10, in11, in12) = (CE::<CI<10>> {}, CE::<CI<11>> {}, CE::<CI<12>> {});
    let (in13, in14, in15) = (CE::<CI<13>> {}, CE::<CI<14>> {}, CE::<CI<15>> {});
    let (in16, in17, in18) = (CE::<CI<16>> {}, CE::<CI<17>> {}, CE::<CI<18>> {});
    let (in19, in20, in21) = (CE::<CI<19>> {}, CE::<CI<20>> {}, CE::<CI<21>> {});
    let (in22, in23, in24) = (CE::<CI<22>> {}, CE::<CI<23>> {}, CE::<CI<24>> {});
    let (in25, in26, in27) = (CE::<CI<25>> {}, CE::<CI<26>> {}, CE::<CI<27>> {});
    let (in28, in29, in30) = (CE::<CI<28>> {}, CE::<CI<29>> {}, CE::<CI<30>> {});
    let (in31, in32, in33) = (CE::<CI<31>> {}, CE::<CI<32>> {}, CE::<CI<33>> {});
    let (in34, in35, in36) = (CE::<CI<34>> {}, CE::<CI<35>> {}, CE::<CI<36>> {});
    let (in37, in38, in39) = (CE::<CI<37>> {}, CE::<CI<38>> {}, CE::<CI<39>> {});
    let (in40, in41, in42) = (CE::<CI<40>> {}, CE::<CI<41>> {}, CE::<CI<42>> {});
    let (in43, in44, in45) = (CE::<CI<43>> {}, CE::<CI<44>> {}, CE::<CI<45>> {});
    let (in46, in47, in48) = (CE::<CI<46>> {}, CE::<CI<47>> {}, CE::<CI<48>> {});
    let (in49, in50, in51) = (CE::<CI<49>> {}, CE::<CI<50>> {}, CE::<CI<51>> {});
    let (in52, in53, in54) = (CE::<CI<52>> {}, CE::<CI<53>> {}, CE::<CI<54>> {});
    let (in55, in56, in57) = (CE::<CI<55>> {}, CE::<CI<56>> {}, CE::<CI<57>> {});
    let (in58, in59, in60) = (CE::<CI<58>> {}, CE::<CI<59>> {}, CE::<CI<60>> {});
    let (in61, in62, in63) = (CE::<CI<61>> {}, CE::<CI<62>> {}, CE::<CI<63>> {});
    let (in64, in65, in66) = (CE::<CI<64>> {}, CE::<CI<65>> {}, CE::<CI<66>> {});
    let (in67, in68, in69) = (CE::<CI<67>> {}, CE::<CI<68>> {}, CE::<CI<69>> {});
    let (in70, in71, in72) = (CE::<CI<70>> {}, CE::<CI<71>> {}, CE::<CI<72>> {});
    let (in73, in74, in75) = (CE::<CI<73>> {}, CE::<CI<74>> {}, CE::<CI<75>> {});
    let (in76, in77, in78) = (CE::<CI<76>> {}, CE::<CI<77>> {}, CE::<CI<78>> {});
    let (in79, in80, in81) = (CE::<CI<79>> {}, CE::<CI<80>> {}, CE::<CI<81>> {});
    let (in82, in83, in84) = (CE::<CI<82>> {}, CE::<CI<83>> {}, CE::<CI<84>> {});
    let (in85, in86, in87) = (CE::<CI<85>> {}, CE::<CI<86>> {}, CE::<CI<87>> {});
    let (in88, in89, in90) = (CE::<CI<88>> {}, CE::<CI<89>> {}, CE::<CI<90>> {});
    let (in91, in92, in93) = (CE::<CI<91>> {}, CE::<CI<92>> {}, CE::<CI<93>> {});
    let (in94, in95, in96) = (CE::<CI<94>> {}, CE::<CI<95>> {}, CE::<CI<96>> {});
    let (in97, in98, in99) = (CE::<CI<97>> {}, CE::<CI<98>> {}, CE::<CI<99>> {});
    let (in100, in101, in102) = (CE::<CI<100>> {}, CE::<CI<101>> {}, CE::<CI<102>> {});
    let (in103, in104, in105) = (CE::<CI<103>> {}, CE::<CI<104>> {}, CE::<CI<105>> {});
    let (in106, in107, in108) = (CE::<CI<106>> {}, CE::<CI<107>> {}, CE::<CI<108>> {});
    let (in109, in110, in111) = (CE::<CI<109>> {}, CE::<CI<110>> {}, CE::<CI<111>> {});
    let (in112, in113, in114) = (CE::<CI<112>> {}, CE::<CI<113>> {}, CE::<CI<114>> {});
    let (in115, in116, in117) = (CE::<CI<115>> {}, CE::<CI<116>> {}, CE::<CI<117>> {});
    let (in118, in119, in120) = (CE::<CI<118>> {}, CE::<CI<119>> {}, CE::<CI<120>> {});
    let (in121, in122, in123) = (CE::<CI<121>> {}, CE::<CI<122>> {}, CE::<CI<123>> {});
    let (in124, in125, in126) = (CE::<CI<124>> {}, CE::<CI<125>> {}, CE::<CI<126>> {});
    let (in127, in128, in129) = (CE::<CI<127>> {}, CE::<CI<128>> {}, CE::<CI<129>> {});
    let (in130, in131, in132) = (CE::<CI<130>> {}, CE::<CI<131>> {}, CE::<CI<132>> {});
    let (in133, in134, in135) = (CE::<CI<133>> {}, CE::<CI<134>> {}, CE::<CI<135>> {});
    let (in136, in137, in138) = (CE::<CI<136>> {}, CE::<CI<137>> {}, CE::<CI<138>> {});
    let (in139, in140, in141) = (CE::<CI<139>> {}, CE::<CI<140>> {}, CE::<CI<141>> {});
    let (in142, in143, in144) = (CE::<CI<142>> {}, CE::<CI<143>> {}, CE::<CI<144>> {});
    let (in145, in146, in147) = (CE::<CI<145>> {}, CE::<CI<146>> {}, CE::<CI<147>> {});
    let (in148, in149, in150) = (CE::<CI<148>> {}, CE::<CI<149>> {}, CE::<CI<150>> {});
    let (in151, in152, in153) = (CE::<CI<151>> {}, CE::<CI<152>> {}, CE::<CI<153>> {});
    let (in154, in155, in156) = (CE::<CI<154>> {}, CE::<CI<155>> {}, CE::<CI<156>> {});
    let (in157, in158, in159) = (CE::<CI<157>> {}, CE::<CI<158>> {}, CE::<CI<159>> {});
    let (in160, in161, in162) = (CE::<CI<160>> {}, CE::<CI<161>> {}, CE::<CI<162>> {});
    let (in163, in164, in165) = (CE::<CI<163>> {}, CE::<CI<164>> {}, CE::<CI<165>> {});
    let (in166, in167, in168) = (CE::<CI<166>> {}, CE::<CI<167>> {}, CE::<CI<168>> {});
    let (in169, in170, in171) = (CE::<CI<169>> {}, CE::<CI<170>> {}, CE::<CI<171>> {});
    let (in172, in173, in174) = (CE::<CI<172>> {}, CE::<CI<173>> {}, CE::<CI<174>> {});
    let (in175, in176, in177) = (CE::<CI<175>> {}, CE::<CI<176>> {}, CE::<CI<177>> {});
    let in178 = CE::<CI<178>> {};
    let t0 = circuit_mul(in28, in28); // compute z^2
    let t1 = circuit_mul(t0, in28); // compute z^3
    let t2 = circuit_mul(t1, t1); // compute z^6
    let t3 = circuit_mul(t2, in28); // compute z^7
    let t4 = circuit_mul(t3, t0); // compute z^9
    let t5 = circuit_mul(t4, t1); // compute z^12
    let t6 = circuit_mul(in0, in7);
    let t7 = circuit_add(in6, t6);
    let t8 = circuit_mul(t7, in5); // eval bn line by xNegOverY
    let t9 = circuit_mul(in0, in9);
    let t10 = circuit_add(in8, t9);
    let t11 = circuit_mul(t10, in4); // eval bn line by yInv
    let t12 = circuit_mul(in7, in5); // eval bn line by xNegOverY
    let t13 = circuit_mul(in9, in4); // eval bn line by yInv
    let t14 = circuit_mul(in0, in11);
    let t15 = circuit_add(in10, t14);
    let t16 = circuit_mul(t15, in5); // eval bn line by xNegOverY
    let t17 = circuit_mul(in0, in13);
    let t18 = circuit_add(in12, t17);
    let t19 = circuit_mul(t18, in4); // eval bn line by yInv
    let t20 = circuit_mul(in11, in5); // eval bn line by xNegOverY
    let t21 = circuit_mul(in13, in4); // eval bn line by yInv
    let t22 = circuit_mul(in0, in17);
    let t23 = circuit_add(in16, t22);
    let t24 = circuit_mul(t23, in15); // eval bn line by xNegOverY
    let t25 = circuit_mul(in0, in19);
    let t26 = circuit_add(in18, t25);
    let t27 = circuit_mul(t26, in14); // eval bn line by yInv
    let t28 = circuit_mul(in17, in15); // eval bn line by xNegOverY
    let t29 = circuit_mul(in19, in14); // eval bn line by yInv
    let t30 = circuit_mul(in0, in21);
    let t31 = circuit_add(in20, t30);
    let t32 = circuit_mul(t31, in15); // eval bn line by xNegOverY
    let t33 = circuit_mul(in0, in23);
    let t34 = circuit_add(in22, t33);
    let t35 = circuit_mul(t34, in14); // eval bn line by yInv
    let t36 = circuit_mul(in21, in15); // eval bn line by xNegOverY
    let t37 = circuit_mul(in23, in14); // eval bn line by yInv
    let t38 = circuit_mul(t8, in28); // Eval sparse poly line_0 step coeff_1 * z^1
    let t39 = circuit_add(in1, t38); // Eval sparse poly line_0 step + coeff_1 * z^1
    let t40 = circuit_mul(t11, t1); // Eval sparse poly line_0 step coeff_3 * z^3
    let t41 = circuit_add(t39, t40); // Eval sparse poly line_0 step + coeff_3 * z^3
    let t42 = circuit_mul(t12, t3); // Eval sparse poly line_0 step coeff_7 * z^7
    let t43 = circuit_add(t41, t42); // Eval sparse poly line_0 step + coeff_7 * z^7
    let t44 = circuit_mul(t13, t4); // Eval sparse poly line_0 step coeff_9 * z^9
    let t45 = circuit_add(t43, t44); // Eval sparse poly line_0 step + coeff_9 * z^9
    let t46 = circuit_mul(in33, t45);
    let t47 = circuit_mul(t16, in28); // Eval sparse poly line_1 step coeff_1 * z^1
    let t48 = circuit_add(in1, t47); // Eval sparse poly line_1 step + coeff_1 * z^1
    let t49 = circuit_mul(t19, t1); // Eval sparse poly line_1 step coeff_3 * z^3
    let t50 = circuit_add(t48, t49); // Eval sparse poly line_1 step + coeff_3 * z^3
    let t51 = circuit_mul(t20, t3); // Eval sparse poly line_1 step coeff_7 * z^7
    let t52 = circuit_add(t50, t51); // Eval sparse poly line_1 step + coeff_7 * z^7
    let t53 = circuit_mul(t21, t4); // Eval sparse poly line_1 step coeff_9 * z^9
    let t54 = circuit_add(t52, t53); // Eval sparse poly line_1 step + coeff_9 * z^9
    let t55 = circuit_mul(t46, t54);
    let t56 = circuit_mul(t24, in28); // Eval sparse poly line_2 step coeff_1 * z^1
    let t57 = circuit_add(in1, t56); // Eval sparse poly line_2 step + coeff_1 * z^1
    let t58 = circuit_mul(t27, t1); // Eval sparse poly line_2 step coeff_3 * z^3
    let t59 = circuit_add(t57, t58); // Eval sparse poly line_2 step + coeff_3 * z^3
    let t60 = circuit_mul(t28, t3); // Eval sparse poly line_2 step coeff_7 * z^7
    let t61 = circuit_add(t59, t60); // Eval sparse poly line_2 step + coeff_7 * z^7
    let t62 = circuit_mul(t29, t4); // Eval sparse poly line_2 step coeff_9 * z^9
    let t63 = circuit_add(t61, t62); // Eval sparse poly line_2 step + coeff_9 * z^9
    let t64 = circuit_mul(t55, t63);
    let t65 = circuit_mul(t32, in28); // Eval sparse poly line_3 step coeff_1 * z^1
    let t66 = circuit_add(in1, t65); // Eval sparse poly line_3 step + coeff_1 * z^1
    let t67 = circuit_mul(t35, t1); // Eval sparse poly line_3 step coeff_3 * z^3
    let t68 = circuit_add(t66, t67); // Eval sparse poly line_3 step + coeff_3 * z^3
    let t69 = circuit_mul(t36, t3); // Eval sparse poly line_3 step coeff_7 * z^7
    let t70 = circuit_add(t68, t69); // Eval sparse poly line_3 step + coeff_7 * z^7
    let t71 = circuit_mul(t37, t4); // Eval sparse poly line_3 step coeff_9 * z^9
    let t72 = circuit_add(t70, t71); // Eval sparse poly line_3 step + coeff_9 * z^9
    let t73 = circuit_mul(t64, t72);
    let t74 = circuit_sub(t73, in24); // ((Π(n-2,k) (Pk(z)) - R_n_minus_2(z))
    let t75 = circuit_mul(in24, in29);
    let t76 = circuit_mul(t75, in30);
    let t77 = circuit_mul(t76, in31);
    let t78 = circuit_mul(t77, in27);
    let t79 = circuit_sub(t78, in25); // ((Π(n-1,k) (Pk(z)) - R_n_minus_1(z))
    let t80 = circuit_mul(in26, in32);
    let t81 = circuit_add(t80, t74);
    let t82 = circuit_mul(in26, t81);
    let t83 = circuit_add(t82, t79);
    let t84 = circuit_mul(in178, in28); // Eval big_Q Horner step: multiply by z
    let t85 = circuit_add(in177, t84); // Eval big_Q Horner step: add coefficient_143
    let t86 = circuit_mul(t85, in28); // Eval big_Q Horner step: multiply by z
    let t87 = circuit_add(in176, t86); // Eval big_Q Horner step: add coefficient_142
    let t88 = circuit_mul(t87, in28); // Eval big_Q Horner step: multiply by z
    let t89 = circuit_add(in175, t88); // Eval big_Q Horner step: add coefficient_141
    let t90 = circuit_mul(t89, in28); // Eval big_Q Horner step: multiply by z
    let t91 = circuit_add(in174, t90); // Eval big_Q Horner step: add coefficient_140
    let t92 = circuit_mul(t91, in28); // Eval big_Q Horner step: multiply by z
    let t93 = circuit_add(in173, t92); // Eval big_Q Horner step: add coefficient_139
    let t94 = circuit_mul(t93, in28); // Eval big_Q Horner step: multiply by z
    let t95 = circuit_add(in172, t94); // Eval big_Q Horner step: add coefficient_138
    let t96 = circuit_mul(t95, in28); // Eval big_Q Horner step: multiply by z
    let t97 = circuit_add(in171, t96); // Eval big_Q Horner step: add coefficient_137
    let t98 = circuit_mul(t97, in28); // Eval big_Q Horner step: multiply by z
    let t99 = circuit_add(in170, t98); // Eval big_Q Horner step: add coefficient_136
    let t100 = circuit_mul(t99, in28); // Eval big_Q Horner step: multiply by z
    let t101 = circuit_add(in169, t100); // Eval big_Q Horner step: add coefficient_135
    let t102 = circuit_mul(t101, in28); // Eval big_Q Horner step: multiply by z
    let t103 = circuit_add(in168, t102); // Eval big_Q Horner step: add coefficient_134
    let t104 = circuit_mul(t103, in28); // Eval big_Q Horner step: multiply by z
    let t105 = circuit_add(in167, t104); // Eval big_Q Horner step: add coefficient_133
    let t106 = circuit_mul(t105, in28); // Eval big_Q Horner step: multiply by z
    let t107 = circuit_add(in166, t106); // Eval big_Q Horner step: add coefficient_132
    let t108 = circuit_mul(t107, in28); // Eval big_Q Horner step: multiply by z
    let t109 = circuit_add(in165, t108); // Eval big_Q Horner step: add coefficient_131
    let t110 = circuit_mul(t109, in28); // Eval big_Q Horner step: multiply by z
    let t111 = circuit_add(in164, t110); // Eval big_Q Horner step: add coefficient_130
    let t112 = circuit_mul(t111, in28); // Eval big_Q Horner step: multiply by z
    let t113 = circuit_add(in163, t112); // Eval big_Q Horner step: add coefficient_129
    let t114 = circuit_mul(t113, in28); // Eval big_Q Horner step: multiply by z
    let t115 = circuit_add(in162, t114); // Eval big_Q Horner step: add coefficient_128
    let t116 = circuit_mul(t115, in28); // Eval big_Q Horner step: multiply by z
    let t117 = circuit_add(in161, t116); // Eval big_Q Horner step: add coefficient_127
    let t118 = circuit_mul(t117, in28); // Eval big_Q Horner step: multiply by z
    let t119 = circuit_add(in160, t118); // Eval big_Q Horner step: add coefficient_126
    let t120 = circuit_mul(t119, in28); // Eval big_Q Horner step: multiply by z
    let t121 = circuit_add(in159, t120); // Eval big_Q Horner step: add coefficient_125
    let t122 = circuit_mul(t121, in28); // Eval big_Q Horner step: multiply by z
    let t123 = circuit_add(in158, t122); // Eval big_Q Horner step: add coefficient_124
    let t124 = circuit_mul(t123, in28); // Eval big_Q Horner step: multiply by z
    let t125 = circuit_add(in157, t124); // Eval big_Q Horner step: add coefficient_123
    let t126 = circuit_mul(t125, in28); // Eval big_Q Horner step: multiply by z
    let t127 = circuit_add(in156, t126); // Eval big_Q Horner step: add coefficient_122
    let t128 = circuit_mul(t127, in28); // Eval big_Q Horner step: multiply by z
    let t129 = circuit_add(in155, t128); // Eval big_Q Horner step: add coefficient_121
    let t130 = circuit_mul(t129, in28); // Eval big_Q Horner step: multiply by z
    let t131 = circuit_add(in154, t130); // Eval big_Q Horner step: add coefficient_120
    let t132 = circuit_mul(t131, in28); // Eval big_Q Horner step: multiply by z
    let t133 = circuit_add(in153, t132); // Eval big_Q Horner step: add coefficient_119
    let t134 = circuit_mul(t133, in28); // Eval big_Q Horner step: multiply by z
    let t135 = circuit_add(in152, t134); // Eval big_Q Horner step: add coefficient_118
    let t136 = circuit_mul(t135, in28); // Eval big_Q Horner step: multiply by z
    let t137 = circuit_add(in151, t136); // Eval big_Q Horner step: add coefficient_117
    let t138 = circuit_mul(t137, in28); // Eval big_Q Horner step: multiply by z
    let t139 = circuit_add(in150, t138); // Eval big_Q Horner step: add coefficient_116
    let t140 = circuit_mul(t139, in28); // Eval big_Q Horner step: multiply by z
    let t141 = circuit_add(in149, t140); // Eval big_Q Horner step: add coefficient_115
    let t142 = circuit_mul(t141, in28); // Eval big_Q Horner step: multiply by z
    let t143 = circuit_add(in148, t142); // Eval big_Q Horner step: add coefficient_114
    let t144 = circuit_mul(t143, in28); // Eval big_Q Horner step: multiply by z
    let t145 = circuit_add(in147, t144); // Eval big_Q Horner step: add coefficient_113
    let t146 = circuit_mul(t145, in28); // Eval big_Q Horner step: multiply by z
    let t147 = circuit_add(in146, t146); // Eval big_Q Horner step: add coefficient_112
    let t148 = circuit_mul(t147, in28); // Eval big_Q Horner step: multiply by z
    let t149 = circuit_add(in145, t148); // Eval big_Q Horner step: add coefficient_111
    let t150 = circuit_mul(t149, in28); // Eval big_Q Horner step: multiply by z
    let t151 = circuit_add(in144, t150); // Eval big_Q Horner step: add coefficient_110
    let t152 = circuit_mul(t151, in28); // Eval big_Q Horner step: multiply by z
    let t153 = circuit_add(in143, t152); // Eval big_Q Horner step: add coefficient_109
    let t154 = circuit_mul(t153, in28); // Eval big_Q Horner step: multiply by z
    let t155 = circuit_add(in142, t154); // Eval big_Q Horner step: add coefficient_108
    let t156 = circuit_mul(t155, in28); // Eval big_Q Horner step: multiply by z
    let t157 = circuit_add(in141, t156); // Eval big_Q Horner step: add coefficient_107
    let t158 = circuit_mul(t157, in28); // Eval big_Q Horner step: multiply by z
    let t159 = circuit_add(in140, t158); // Eval big_Q Horner step: add coefficient_106
    let t160 = circuit_mul(t159, in28); // Eval big_Q Horner step: multiply by z
    let t161 = circuit_add(in139, t160); // Eval big_Q Horner step: add coefficient_105
    let t162 = circuit_mul(t161, in28); // Eval big_Q Horner step: multiply by z
    let t163 = circuit_add(in138, t162); // Eval big_Q Horner step: add coefficient_104
    let t164 = circuit_mul(t163, in28); // Eval big_Q Horner step: multiply by z
    let t165 = circuit_add(in137, t164); // Eval big_Q Horner step: add coefficient_103
    let t166 = circuit_mul(t165, in28); // Eval big_Q Horner step: multiply by z
    let t167 = circuit_add(in136, t166); // Eval big_Q Horner step: add coefficient_102
    let t168 = circuit_mul(t167, in28); // Eval big_Q Horner step: multiply by z
    let t169 = circuit_add(in135, t168); // Eval big_Q Horner step: add coefficient_101
    let t170 = circuit_mul(t169, in28); // Eval big_Q Horner step: multiply by z
    let t171 = circuit_add(in134, t170); // Eval big_Q Horner step: add coefficient_100
    let t172 = circuit_mul(t171, in28); // Eval big_Q Horner step: multiply by z
    let t173 = circuit_add(in133, t172); // Eval big_Q Horner step: add coefficient_99
    let t174 = circuit_mul(t173, in28); // Eval big_Q Horner step: multiply by z
    let t175 = circuit_add(in132, t174); // Eval big_Q Horner step: add coefficient_98
    let t176 = circuit_mul(t175, in28); // Eval big_Q Horner step: multiply by z
    let t177 = circuit_add(in131, t176); // Eval big_Q Horner step: add coefficient_97
    let t178 = circuit_mul(t177, in28); // Eval big_Q Horner step: multiply by z
    let t179 = circuit_add(in130, t178); // Eval big_Q Horner step: add coefficient_96
    let t180 = circuit_mul(t179, in28); // Eval big_Q Horner step: multiply by z
    let t181 = circuit_add(in129, t180); // Eval big_Q Horner step: add coefficient_95
    let t182 = circuit_mul(t181, in28); // Eval big_Q Horner step: multiply by z
    let t183 = circuit_add(in128, t182); // Eval big_Q Horner step: add coefficient_94
    let t184 = circuit_mul(t183, in28); // Eval big_Q Horner step: multiply by z
    let t185 = circuit_add(in127, t184); // Eval big_Q Horner step: add coefficient_93
    let t186 = circuit_mul(t185, in28); // Eval big_Q Horner step: multiply by z
    let t187 = circuit_add(in126, t186); // Eval big_Q Horner step: add coefficient_92
    let t188 = circuit_mul(t187, in28); // Eval big_Q Horner step: multiply by z
    let t189 = circuit_add(in125, t188); // Eval big_Q Horner step: add coefficient_91
    let t190 = circuit_mul(t189, in28); // Eval big_Q Horner step: multiply by z
    let t191 = circuit_add(in124, t190); // Eval big_Q Horner step: add coefficient_90
    let t192 = circuit_mul(t191, in28); // Eval big_Q Horner step: multiply by z
    let t193 = circuit_add(in123, t192); // Eval big_Q Horner step: add coefficient_89
    let t194 = circuit_mul(t193, in28); // Eval big_Q Horner step: multiply by z
    let t195 = circuit_add(in122, t194); // Eval big_Q Horner step: add coefficient_88
    let t196 = circuit_mul(t195, in28); // Eval big_Q Horner step: multiply by z
    let t197 = circuit_add(in121, t196); // Eval big_Q Horner step: add coefficient_87
    let t198 = circuit_mul(t197, in28); // Eval big_Q Horner step: multiply by z
    let t199 = circuit_add(in120, t198); // Eval big_Q Horner step: add coefficient_86
    let t200 = circuit_mul(t199, in28); // Eval big_Q Horner step: multiply by z
    let t201 = circuit_add(in119, t200); // Eval big_Q Horner step: add coefficient_85
    let t202 = circuit_mul(t201, in28); // Eval big_Q Horner step: multiply by z
    let t203 = circuit_add(in118, t202); // Eval big_Q Horner step: add coefficient_84
    let t204 = circuit_mul(t203, in28); // Eval big_Q Horner step: multiply by z
    let t205 = circuit_add(in117, t204); // Eval big_Q Horner step: add coefficient_83
    let t206 = circuit_mul(t205, in28); // Eval big_Q Horner step: multiply by z
    let t207 = circuit_add(in116, t206); // Eval big_Q Horner step: add coefficient_82
    let t208 = circuit_mul(t207, in28); // Eval big_Q Horner step: multiply by z
    let t209 = circuit_add(in115, t208); // Eval big_Q Horner step: add coefficient_81
    let t210 = circuit_mul(t209, in28); // Eval big_Q Horner step: multiply by z
    let t211 = circuit_add(in114, t210); // Eval big_Q Horner step: add coefficient_80
    let t212 = circuit_mul(t211, in28); // Eval big_Q Horner step: multiply by z
    let t213 = circuit_add(in113, t212); // Eval big_Q Horner step: add coefficient_79
    let t214 = circuit_mul(t213, in28); // Eval big_Q Horner step: multiply by z
    let t215 = circuit_add(in112, t214); // Eval big_Q Horner step: add coefficient_78
    let t216 = circuit_mul(t215, in28); // Eval big_Q Horner step: multiply by z
    let t217 = circuit_add(in111, t216); // Eval big_Q Horner step: add coefficient_77
    let t218 = circuit_mul(t217, in28); // Eval big_Q Horner step: multiply by z
    let t219 = circuit_add(in110, t218); // Eval big_Q Horner step: add coefficient_76
    let t220 = circuit_mul(t219, in28); // Eval big_Q Horner step: multiply by z
    let t221 = circuit_add(in109, t220); // Eval big_Q Horner step: add coefficient_75
    let t222 = circuit_mul(t221, in28); // Eval big_Q Horner step: multiply by z
    let t223 = circuit_add(in108, t222); // Eval big_Q Horner step: add coefficient_74
    let t224 = circuit_mul(t223, in28); // Eval big_Q Horner step: multiply by z
    let t225 = circuit_add(in107, t224); // Eval big_Q Horner step: add coefficient_73
    let t226 = circuit_mul(t225, in28); // Eval big_Q Horner step: multiply by z
    let t227 = circuit_add(in106, t226); // Eval big_Q Horner step: add coefficient_72
    let t228 = circuit_mul(t227, in28); // Eval big_Q Horner step: multiply by z
    let t229 = circuit_add(in105, t228); // Eval big_Q Horner step: add coefficient_71
    let t230 = circuit_mul(t229, in28); // Eval big_Q Horner step: multiply by z
    let t231 = circuit_add(in104, t230); // Eval big_Q Horner step: add coefficient_70
    let t232 = circuit_mul(t231, in28); // Eval big_Q Horner step: multiply by z
    let t233 = circuit_add(in103, t232); // Eval big_Q Horner step: add coefficient_69
    let t234 = circuit_mul(t233, in28); // Eval big_Q Horner step: multiply by z
    let t235 = circuit_add(in102, t234); // Eval big_Q Horner step: add coefficient_68
    let t236 = circuit_mul(t235, in28); // Eval big_Q Horner step: multiply by z
    let t237 = circuit_add(in101, t236); // Eval big_Q Horner step: add coefficient_67
    let t238 = circuit_mul(t237, in28); // Eval big_Q Horner step: multiply by z
    let t239 = circuit_add(in100, t238); // Eval big_Q Horner step: add coefficient_66
    let t240 = circuit_mul(t239, in28); // Eval big_Q Horner step: multiply by z
    let t241 = circuit_add(in99, t240); // Eval big_Q Horner step: add coefficient_65
    let t242 = circuit_mul(t241, in28); // Eval big_Q Horner step: multiply by z
    let t243 = circuit_add(in98, t242); // Eval big_Q Horner step: add coefficient_64
    let t244 = circuit_mul(t243, in28); // Eval big_Q Horner step: multiply by z
    let t245 = circuit_add(in97, t244); // Eval big_Q Horner step: add coefficient_63
    let t246 = circuit_mul(t245, in28); // Eval big_Q Horner step: multiply by z
    let t247 = circuit_add(in96, t246); // Eval big_Q Horner step: add coefficient_62
    let t248 = circuit_mul(t247, in28); // Eval big_Q Horner step: multiply by z
    let t249 = circuit_add(in95, t248); // Eval big_Q Horner step: add coefficient_61
    let t250 = circuit_mul(t249, in28); // Eval big_Q Horner step: multiply by z
    let t251 = circuit_add(in94, t250); // Eval big_Q Horner step: add coefficient_60
    let t252 = circuit_mul(t251, in28); // Eval big_Q Horner step: multiply by z
    let t253 = circuit_add(in93, t252); // Eval big_Q Horner step: add coefficient_59
    let t254 = circuit_mul(t253, in28); // Eval big_Q Horner step: multiply by z
    let t255 = circuit_add(in92, t254); // Eval big_Q Horner step: add coefficient_58
    let t256 = circuit_mul(t255, in28); // Eval big_Q Horner step: multiply by z
    let t257 = circuit_add(in91, t256); // Eval big_Q Horner step: add coefficient_57
    let t258 = circuit_mul(t257, in28); // Eval big_Q Horner step: multiply by z
    let t259 = circuit_add(in90, t258); // Eval big_Q Horner step: add coefficient_56
    let t260 = circuit_mul(t259, in28); // Eval big_Q Horner step: multiply by z
    let t261 = circuit_add(in89, t260); // Eval big_Q Horner step: add coefficient_55
    let t262 = circuit_mul(t261, in28); // Eval big_Q Horner step: multiply by z
    let t263 = circuit_add(in88, t262); // Eval big_Q Horner step: add coefficient_54
    let t264 = circuit_mul(t263, in28); // Eval big_Q Horner step: multiply by z
    let t265 = circuit_add(in87, t264); // Eval big_Q Horner step: add coefficient_53
    let t266 = circuit_mul(t265, in28); // Eval big_Q Horner step: multiply by z
    let t267 = circuit_add(in86, t266); // Eval big_Q Horner step: add coefficient_52
    let t268 = circuit_mul(t267, in28); // Eval big_Q Horner step: multiply by z
    let t269 = circuit_add(in85, t268); // Eval big_Q Horner step: add coefficient_51
    let t270 = circuit_mul(t269, in28); // Eval big_Q Horner step: multiply by z
    let t271 = circuit_add(in84, t270); // Eval big_Q Horner step: add coefficient_50
    let t272 = circuit_mul(t271, in28); // Eval big_Q Horner step: multiply by z
    let t273 = circuit_add(in83, t272); // Eval big_Q Horner step: add coefficient_49
    let t274 = circuit_mul(t273, in28); // Eval big_Q Horner step: multiply by z
    let t275 = circuit_add(in82, t274); // Eval big_Q Horner step: add coefficient_48
    let t276 = circuit_mul(t275, in28); // Eval big_Q Horner step: multiply by z
    let t277 = circuit_add(in81, t276); // Eval big_Q Horner step: add coefficient_47
    let t278 = circuit_mul(t277, in28); // Eval big_Q Horner step: multiply by z
    let t279 = circuit_add(in80, t278); // Eval big_Q Horner step: add coefficient_46
    let t280 = circuit_mul(t279, in28); // Eval big_Q Horner step: multiply by z
    let t281 = circuit_add(in79, t280); // Eval big_Q Horner step: add coefficient_45
    let t282 = circuit_mul(t281, in28); // Eval big_Q Horner step: multiply by z
    let t283 = circuit_add(in78, t282); // Eval big_Q Horner step: add coefficient_44
    let t284 = circuit_mul(t283, in28); // Eval big_Q Horner step: multiply by z
    let t285 = circuit_add(in77, t284); // Eval big_Q Horner step: add coefficient_43
    let t286 = circuit_mul(t285, in28); // Eval big_Q Horner step: multiply by z
    let t287 = circuit_add(in76, t286); // Eval big_Q Horner step: add coefficient_42
    let t288 = circuit_mul(t287, in28); // Eval big_Q Horner step: multiply by z
    let t289 = circuit_add(in75, t288); // Eval big_Q Horner step: add coefficient_41
    let t290 = circuit_mul(t289, in28); // Eval big_Q Horner step: multiply by z
    let t291 = circuit_add(in74, t290); // Eval big_Q Horner step: add coefficient_40
    let t292 = circuit_mul(t291, in28); // Eval big_Q Horner step: multiply by z
    let t293 = circuit_add(in73, t292); // Eval big_Q Horner step: add coefficient_39
    let t294 = circuit_mul(t293, in28); // Eval big_Q Horner step: multiply by z
    let t295 = circuit_add(in72, t294); // Eval big_Q Horner step: add coefficient_38
    let t296 = circuit_mul(t295, in28); // Eval big_Q Horner step: multiply by z
    let t297 = circuit_add(in71, t296); // Eval big_Q Horner step: add coefficient_37
    let t298 = circuit_mul(t297, in28); // Eval big_Q Horner step: multiply by z
    let t299 = circuit_add(in70, t298); // Eval big_Q Horner step: add coefficient_36
    let t300 = circuit_mul(t299, in28); // Eval big_Q Horner step: multiply by z
    let t301 = circuit_add(in69, t300); // Eval big_Q Horner step: add coefficient_35
    let t302 = circuit_mul(t301, in28); // Eval big_Q Horner step: multiply by z
    let t303 = circuit_add(in68, t302); // Eval big_Q Horner step: add coefficient_34
    let t304 = circuit_mul(t303, in28); // Eval big_Q Horner step: multiply by z
    let t305 = circuit_add(in67, t304); // Eval big_Q Horner step: add coefficient_33
    let t306 = circuit_mul(t305, in28); // Eval big_Q Horner step: multiply by z
    let t307 = circuit_add(in66, t306); // Eval big_Q Horner step: add coefficient_32
    let t308 = circuit_mul(t307, in28); // Eval big_Q Horner step: multiply by z
    let t309 = circuit_add(in65, t308); // Eval big_Q Horner step: add coefficient_31
    let t310 = circuit_mul(t309, in28); // Eval big_Q Horner step: multiply by z
    let t311 = circuit_add(in64, t310); // Eval big_Q Horner step: add coefficient_30
    let t312 = circuit_mul(t311, in28); // Eval big_Q Horner step: multiply by z
    let t313 = circuit_add(in63, t312); // Eval big_Q Horner step: add coefficient_29
    let t314 = circuit_mul(t313, in28); // Eval big_Q Horner step: multiply by z
    let t315 = circuit_add(in62, t314); // Eval big_Q Horner step: add coefficient_28
    let t316 = circuit_mul(t315, in28); // Eval big_Q Horner step: multiply by z
    let t317 = circuit_add(in61, t316); // Eval big_Q Horner step: add coefficient_27
    let t318 = circuit_mul(t317, in28); // Eval big_Q Horner step: multiply by z
    let t319 = circuit_add(in60, t318); // Eval big_Q Horner step: add coefficient_26
    let t320 = circuit_mul(t319, in28); // Eval big_Q Horner step: multiply by z
    let t321 = circuit_add(in59, t320); // Eval big_Q Horner step: add coefficient_25
    let t322 = circuit_mul(t321, in28); // Eval big_Q Horner step: multiply by z
    let t323 = circuit_add(in58, t322); // Eval big_Q Horner step: add coefficient_24
    let t324 = circuit_mul(t323, in28); // Eval big_Q Horner step: multiply by z
    let t325 = circuit_add(in57, t324); // Eval big_Q Horner step: add coefficient_23
    let t326 = circuit_mul(t325, in28); // Eval big_Q Horner step: multiply by z
    let t327 = circuit_add(in56, t326); // Eval big_Q Horner step: add coefficient_22
    let t328 = circuit_mul(t327, in28); // Eval big_Q Horner step: multiply by z
    let t329 = circuit_add(in55, t328); // Eval big_Q Horner step: add coefficient_21
    let t330 = circuit_mul(t329, in28); // Eval big_Q Horner step: multiply by z
    let t331 = circuit_add(in54, t330); // Eval big_Q Horner step: add coefficient_20
    let t332 = circuit_mul(t331, in28); // Eval big_Q Horner step: multiply by z
    let t333 = circuit_add(in53, t332); // Eval big_Q Horner step: add coefficient_19
    let t334 = circuit_mul(t333, in28); // Eval big_Q Horner step: multiply by z
    let t335 = circuit_add(in52, t334); // Eval big_Q Horner step: add coefficient_18
    let t336 = circuit_mul(t335, in28); // Eval big_Q Horner step: multiply by z
    let t337 = circuit_add(in51, t336); // Eval big_Q Horner step: add coefficient_17
    let t338 = circuit_mul(t337, in28); // Eval big_Q Horner step: multiply by z
    let t339 = circuit_add(in50, t338); // Eval big_Q Horner step: add coefficient_16
    let t340 = circuit_mul(t339, in28); // Eval big_Q Horner step: multiply by z
    let t341 = circuit_add(in49, t340); // Eval big_Q Horner step: add coefficient_15
    let t342 = circuit_mul(t341, in28); // Eval big_Q Horner step: multiply by z
    let t343 = circuit_add(in48, t342); // Eval big_Q Horner step: add coefficient_14
    let t344 = circuit_mul(t343, in28); // Eval big_Q Horner step: multiply by z
    let t345 = circuit_add(in47, t344); // Eval big_Q Horner step: add coefficient_13
    let t346 = circuit_mul(t345, in28); // Eval big_Q Horner step: multiply by z
    let t347 = circuit_add(in46, t346); // Eval big_Q Horner step: add coefficient_12
    let t348 = circuit_mul(t347, in28); // Eval big_Q Horner step: multiply by z
    let t349 = circuit_add(in45, t348); // Eval big_Q Horner step: add coefficient_11
    let t350 = circuit_mul(t349, in28); // Eval big_Q Horner step: multiply by z
    let t351 = circuit_add(in44, t350); // Eval big_Q Horner step: add coefficient_10
    let t352 = circuit_mul(t351, in28); // Eval big_Q Horner step: multiply by z
    let t353 = circuit_add(in43, t352); // Eval big_Q Horner step: add coefficient_9
    let t354 = circuit_mul(t353, in28); // Eval big_Q Horner step: multiply by z
    let t355 = circuit_add(in42, t354); // Eval big_Q Horner step: add coefficient_8
    let t356 = circuit_mul(t355, in28); // Eval big_Q Horner step: multiply by z
    let t357 = circuit_add(in41, t356); // Eval big_Q Horner step: add coefficient_7
    let t358 = circuit_mul(t357, in28); // Eval big_Q Horner step: multiply by z
    let t359 = circuit_add(in40, t358); // Eval big_Q Horner step: add coefficient_6
    let t360 = circuit_mul(t359, in28); // Eval big_Q Horner step: multiply by z
    let t361 = circuit_add(in39, t360); // Eval big_Q Horner step: add coefficient_5
    let t362 = circuit_mul(t361, in28); // Eval big_Q Horner step: multiply by z
    let t363 = circuit_add(in38, t362); // Eval big_Q Horner step: add coefficient_4
    let t364 = circuit_mul(t363, in28); // Eval big_Q Horner step: multiply by z
    let t365 = circuit_add(in37, t364); // Eval big_Q Horner step: add coefficient_3
    let t366 = circuit_mul(t365, in28); // Eval big_Q Horner step: multiply by z
    let t367 = circuit_add(in36, t366); // Eval big_Q Horner step: add coefficient_2
    let t368 = circuit_mul(t367, in28); // Eval big_Q Horner step: multiply by z
    let t369 = circuit_add(in35, t368); // Eval big_Q Horner step: add coefficient_1
    let t370 = circuit_mul(t369, in28); // Eval big_Q Horner step: multiply by z
    let t371 = circuit_add(in34, t370); // Eval big_Q Horner step: add coefficient_0
    let t372 = circuit_mul(in3, t2); // Eval sparse poly P_irr step coeff_6 * z^6
    let t373 = circuit_add(in2, t372); // Eval sparse poly P_irr step + coeff_6 * z^6
    let t374 = circuit_add(t373, t5); // Eval sparse poly P_irr step + 1*z^12
    let t375 = circuit_mul(t371, t374);
    let t376 = circuit_sub(t83, t375);

    let modulus = crate::definitions::get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (t376,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs
        .next_2(
            [0x6871ca8d3c208c16d87cfd3e, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0],
        ); // in0
    circuit_inputs = circuit_inputs.next_2([0x1, 0x0, 0x0, 0x0]); // in1
    circuit_inputs = circuit_inputs.next_2([0x52, 0x0, 0x0, 0x0]); // in2
    circuit_inputs = circuit_inputs
        .next_2(
            [0x6871ca8d3c208c16d87cfd35, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0],
        ); // in3
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(yInv_0); // in4
    circuit_inputs = circuit_inputs.next_2(xNegOverY_0); // in5
    circuit_inputs = circuit_inputs.next_2(line_1_0.r0a0); // in6
    circuit_inputs = circuit_inputs.next_2(line_1_0.r0a1); // in7
    circuit_inputs = circuit_inputs.next_2(line_1_0.r1a0); // in8
    circuit_inputs = circuit_inputs.next_2(line_1_0.r1a1); // in9
    circuit_inputs = circuit_inputs.next_2(line_2_0.r0a0); // in10
    circuit_inputs = circuit_inputs.next_2(line_2_0.r0a1); // in11
    circuit_inputs = circuit_inputs.next_2(line_2_0.r1a0); // in12
    circuit_inputs = circuit_inputs.next_2(line_2_0.r1a1); // in13
    circuit_inputs = circuit_inputs.next_2(yInv_1); // in14
    circuit_inputs = circuit_inputs.next_2(xNegOverY_1); // in15
    circuit_inputs = circuit_inputs.next_2(line_1_1.r0a0); // in16
    circuit_inputs = circuit_inputs.next_2(line_1_1.r0a1); // in17
    circuit_inputs = circuit_inputs.next_2(line_1_1.r1a0); // in18
    circuit_inputs = circuit_inputs.next_2(line_1_1.r1a1); // in19
    circuit_inputs = circuit_inputs.next_2(line_2_1.r0a0); // in20
    circuit_inputs = circuit_inputs.next_2(line_2_1.r0a1); // in21
    circuit_inputs = circuit_inputs.next_2(line_2_1.r1a0); // in22
    circuit_inputs = circuit_inputs.next_2(line_2_1.r1a1); // in23
    circuit_inputs = circuit_inputs.next_2(R_n_minus_2_of_z); // in24
    circuit_inputs = circuit_inputs.next_2(R_n_minus_1_of_z); // in25
    circuit_inputs = circuit_inputs.next_2(c_0); // in26
    circuit_inputs = circuit_inputs.next_2(w_of_z); // in27
    circuit_inputs = circuit_inputs.next_2(z); // in28
    circuit_inputs = circuit_inputs.next_2(c_inv_frob_1_of_z); // in29
    circuit_inputs = circuit_inputs.next_2(c_frob_2_of_z); // in30
    circuit_inputs = circuit_inputs.next_2(c_inv_frob_3_of_z); // in31
    circuit_inputs = circuit_inputs.next_2(previous_lhs); // in32
    circuit_inputs = circuit_inputs.next_2(R_n_minus_3_of_z); // in33

    for val in Q.span() {
        circuit_inputs = circuit_inputs.next_2(*val);
    } // in34 - in178

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let final_check: u384 = outputs.get_output(t376);
    return (final_check,);
}
#[inline(always)]
pub fn run_BN254_MP_CHECK_FINALIZE_3P_2F_EXT_MLR_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    line_1_0: G2Line<u288>,
    line_2_0: G2Line<u288>,
    yInv_1: u384,
    xNegOverY_1: u384,
    line_1_1: G2Line<u288>,
    line_2_1: G2Line<u288>,
    original_Q2: G2Point,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q_2: G2Point,
    R_n_minus_2_of_z: u384,
    R_n_minus_1_of_z: u384,
    c_0: u384,
    w_of_z: u384,
    z: u384,
    c_inv_frob_1_of_z: u384,
    c_frob_2_of_z: u384,
    c_inv_frob_3_of_z: u384,
    previous_lhs: u384,
    R_n_minus_3_of_z: u384,
    Q: Array<u288>,
    precomputed_miller_loop_result_of_z: u384,
) -> (u384,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x2fb347984f7911f74c0bec3cf559b143b78cc310c2c3330c99e39557176f553d
    let in1 = CE::<CI<1>> {}; // 0x16c9e55061ebae204ba4cc8bd75a079432ae2a1d0b7c9dce1665d51c640fcba2
    let in2 = CE::<CI<2>> {}; // 0x63cf305489af5dcdc5ec698b6e2f9b9dbaae0eda9c95998dc54014671a0135a
    let in3 = CE::<CI<3>> {}; // 0x7c03cbcac41049a0704b5a7ec796f2b21807dc98fa25bd282d37f632623b0e3
    let in4 = CE::<CI<4>> {}; // 0x30644e72e131a0295e6dd9e7e0acccb0c28f069fbb966e3de4bd44e5607cfd48
    let in5 = CE::<CI<5>> {}; // 0x1
    let in6 = CE::<CI<6>> {}; // 0x0
    let in7 = CE::<CI<7>> {}; // -0x9 % p
    let in8 = CE::<CI<8>> {}; // 0x52
    let in9 = CE::<CI<9>> {}; // -0x12 % p

    // INPUT stack
    let (in10, in11, in12) = (CE::<CI<10>> {}, CE::<CI<11>> {}, CE::<CI<12>> {});
    let (in13, in14, in15) = (CE::<CI<13>> {}, CE::<CI<14>> {}, CE::<CI<15>> {});
    let (in16, in17, in18) = (CE::<CI<16>> {}, CE::<CI<17>> {}, CE::<CI<18>> {});
    let (in19, in20, in21) = (CE::<CI<19>> {}, CE::<CI<20>> {}, CE::<CI<21>> {});
    let (in22, in23, in24) = (CE::<CI<22>> {}, CE::<CI<23>> {}, CE::<CI<24>> {});
    let (in25, in26, in27) = (CE::<CI<25>> {}, CE::<CI<26>> {}, CE::<CI<27>> {});
    let (in28, in29, in30) = (CE::<CI<28>> {}, CE::<CI<29>> {}, CE::<CI<30>> {});
    let (in31, in32, in33) = (CE::<CI<31>> {}, CE::<CI<32>> {}, CE::<CI<33>> {});
    let (in34, in35, in36) = (CE::<CI<34>> {}, CE::<CI<35>> {}, CE::<CI<36>> {});
    let (in37, in38, in39) = (CE::<CI<37>> {}, CE::<CI<38>> {}, CE::<CI<39>> {});
    let (in40, in41, in42) = (CE::<CI<40>> {}, CE::<CI<41>> {}, CE::<CI<42>> {});
    let (in43, in44, in45) = (CE::<CI<43>> {}, CE::<CI<44>> {}, CE::<CI<45>> {});
    let (in46, in47, in48) = (CE::<CI<46>> {}, CE::<CI<47>> {}, CE::<CI<48>> {});
    let (in49, in50, in51) = (CE::<CI<49>> {}, CE::<CI<50>> {}, CE::<CI<51>> {});
    let (in52, in53, in54) = (CE::<CI<52>> {}, CE::<CI<53>> {}, CE::<CI<54>> {});
    let (in55, in56, in57) = (CE::<CI<55>> {}, CE::<CI<56>> {}, CE::<CI<57>> {});
    let (in58, in59, in60) = (CE::<CI<58>> {}, CE::<CI<59>> {}, CE::<CI<60>> {});
    let (in61, in62, in63) = (CE::<CI<61>> {}, CE::<CI<62>> {}, CE::<CI<63>> {});
    let (in64, in65, in66) = (CE::<CI<64>> {}, CE::<CI<65>> {}, CE::<CI<66>> {});
    let (in67, in68, in69) = (CE::<CI<67>> {}, CE::<CI<68>> {}, CE::<CI<69>> {});
    let (in70, in71, in72) = (CE::<CI<70>> {}, CE::<CI<71>> {}, CE::<CI<72>> {});
    let (in73, in74, in75) = (CE::<CI<73>> {}, CE::<CI<74>> {}, CE::<CI<75>> {});
    let (in76, in77, in78) = (CE::<CI<76>> {}, CE::<CI<77>> {}, CE::<CI<78>> {});
    let (in79, in80, in81) = (CE::<CI<79>> {}, CE::<CI<80>> {}, CE::<CI<81>> {});
    let (in82, in83, in84) = (CE::<CI<82>> {}, CE::<CI<83>> {}, CE::<CI<84>> {});
    let (in85, in86, in87) = (CE::<CI<85>> {}, CE::<CI<86>> {}, CE::<CI<87>> {});
    let (in88, in89, in90) = (CE::<CI<88>> {}, CE::<CI<89>> {}, CE::<CI<90>> {});
    let (in91, in92, in93) = (CE::<CI<91>> {}, CE::<CI<92>> {}, CE::<CI<93>> {});
    let (in94, in95, in96) = (CE::<CI<94>> {}, CE::<CI<95>> {}, CE::<CI<96>> {});
    let (in97, in98, in99) = (CE::<CI<97>> {}, CE::<CI<98>> {}, CE::<CI<99>> {});
    let (in100, in101, in102) = (CE::<CI<100>> {}, CE::<CI<101>> {}, CE::<CI<102>> {});
    let (in103, in104, in105) = (CE::<CI<103>> {}, CE::<CI<104>> {}, CE::<CI<105>> {});
    let (in106, in107, in108) = (CE::<CI<106>> {}, CE::<CI<107>> {}, CE::<CI<108>> {});
    let (in109, in110, in111) = (CE::<CI<109>> {}, CE::<CI<110>> {}, CE::<CI<111>> {});
    let (in112, in113, in114) = (CE::<CI<112>> {}, CE::<CI<113>> {}, CE::<CI<114>> {});
    let (in115, in116, in117) = (CE::<CI<115>> {}, CE::<CI<116>> {}, CE::<CI<117>> {});
    let (in118, in119, in120) = (CE::<CI<118>> {}, CE::<CI<119>> {}, CE::<CI<120>> {});
    let (in121, in122, in123) = (CE::<CI<121>> {}, CE::<CI<122>> {}, CE::<CI<123>> {});
    let (in124, in125, in126) = (CE::<CI<124>> {}, CE::<CI<125>> {}, CE::<CI<126>> {});
    let (in127, in128, in129) = (CE::<CI<127>> {}, CE::<CI<128>> {}, CE::<CI<129>> {});
    let (in130, in131, in132) = (CE::<CI<130>> {}, CE::<CI<131>> {}, CE::<CI<132>> {});
    let (in133, in134, in135) = (CE::<CI<133>> {}, CE::<CI<134>> {}, CE::<CI<135>> {});
    let (in136, in137, in138) = (CE::<CI<136>> {}, CE::<CI<137>> {}, CE::<CI<138>> {});
    let (in139, in140, in141) = (CE::<CI<139>> {}, CE::<CI<140>> {}, CE::<CI<141>> {});
    let (in142, in143, in144) = (CE::<CI<142>> {}, CE::<CI<143>> {}, CE::<CI<144>> {});
    let (in145, in146, in147) = (CE::<CI<145>> {}, CE::<CI<146>> {}, CE::<CI<147>> {});
    let (in148, in149, in150) = (CE::<CI<148>> {}, CE::<CI<149>> {}, CE::<CI<150>> {});
    let (in151, in152, in153) = (CE::<CI<151>> {}, CE::<CI<152>> {}, CE::<CI<153>> {});
    let (in154, in155, in156) = (CE::<CI<154>> {}, CE::<CI<155>> {}, CE::<CI<156>> {});
    let (in157, in158, in159) = (CE::<CI<157>> {}, CE::<CI<158>> {}, CE::<CI<159>> {});
    let (in160, in161, in162) = (CE::<CI<160>> {}, CE::<CI<161>> {}, CE::<CI<162>> {});
    let (in163, in164, in165) = (CE::<CI<163>> {}, CE::<CI<164>> {}, CE::<CI<165>> {});
    let (in166, in167, in168) = (CE::<CI<166>> {}, CE::<CI<167>> {}, CE::<CI<168>> {});
    let (in169, in170, in171) = (CE::<CI<169>> {}, CE::<CI<170>> {}, CE::<CI<171>> {});
    let (in172, in173, in174) = (CE::<CI<172>> {}, CE::<CI<173>> {}, CE::<CI<174>> {});
    let (in175, in176, in177) = (CE::<CI<175>> {}, CE::<CI<176>> {}, CE::<CI<177>> {});
    let (in178, in179, in180) = (CE::<CI<178>> {}, CE::<CI<179>> {}, CE::<CI<180>> {});
    let (in181, in182, in183) = (CE::<CI<181>> {}, CE::<CI<182>> {}, CE::<CI<183>> {});
    let (in184, in185, in186) = (CE::<CI<184>> {}, CE::<CI<185>> {}, CE::<CI<186>> {});
    let (in187, in188, in189) = (CE::<CI<187>> {}, CE::<CI<188>> {}, CE::<CI<189>> {});
    let (in190, in191, in192) = (CE::<CI<190>> {}, CE::<CI<191>> {}, CE::<CI<192>> {});
    let (in193, in194, in195) = (CE::<CI<193>> {}, CE::<CI<194>> {}, CE::<CI<195>> {});
    let (in196, in197, in198) = (CE::<CI<196>> {}, CE::<CI<197>> {}, CE::<CI<198>> {});
    let (in199, in200, in201) = (CE::<CI<199>> {}, CE::<CI<200>> {}, CE::<CI<201>> {});
    let (in202, in203, in204) = (CE::<CI<202>> {}, CE::<CI<203>> {}, CE::<CI<204>> {});
    let (in205, in206, in207) = (CE::<CI<205>> {}, CE::<CI<206>> {}, CE::<CI<207>> {});
    let (in208, in209, in210) = (CE::<CI<208>> {}, CE::<CI<209>> {}, CE::<CI<210>> {});
    let (in211, in212, in213) = (CE::<CI<211>> {}, CE::<CI<212>> {}, CE::<CI<213>> {});
    let (in214, in215, in216) = (CE::<CI<214>> {}, CE::<CI<215>> {}, CE::<CI<216>> {});
    let (in217, in218, in219) = (CE::<CI<217>> {}, CE::<CI<218>> {}, CE::<CI<219>> {});
    let (in220, in221, in222) = (CE::<CI<220>> {}, CE::<CI<221>> {}, CE::<CI<222>> {});
    let (in223, in224, in225) = (CE::<CI<223>> {}, CE::<CI<224>> {}, CE::<CI<225>> {});
    let (in226, in227, in228) = (CE::<CI<226>> {}, CE::<CI<227>> {}, CE::<CI<228>> {});
    let (in229, in230, in231) = (CE::<CI<229>> {}, CE::<CI<230>> {}, CE::<CI<231>> {});
    let (in232, in233, in234) = (CE::<CI<232>> {}, CE::<CI<233>> {}, CE::<CI<234>> {});
    let (in235, in236, in237) = (CE::<CI<235>> {}, CE::<CI<236>> {}, CE::<CI<237>> {});
    let (in238, in239, in240) = (CE::<CI<238>> {}, CE::<CI<239>> {}, CE::<CI<240>> {});
    let t0 = circuit_mul(in44, in44); // compute z^2
    let t1 = circuit_mul(t0, in44); // compute z^3
    let t2 = circuit_mul(t1, t1); // compute z^6
    let t3 = circuit_mul(t2, in44); // compute z^7
    let t4 = circuit_mul(t3, t0); // compute z^9
    let t5 = circuit_mul(t4, t1); // compute z^12
    let t6 = circuit_sub(in6, in31);
    let t7 = circuit_sub(in6, in33);
    let t8 = circuit_mul(in30, in0); // Fp2 mul start
    let t9 = circuit_mul(t6, in1);
    let t10 = circuit_sub(t8, t9); // Fp2 mul real part end
    let t11 = circuit_mul(in30, in1);
    let t12 = circuit_mul(t6, in0);
    let t13 = circuit_add(t11, t12); // Fp2 mul imag part end
    let t14 = circuit_mul(in32, in2); // Fp2 mul start
    let t15 = circuit_mul(t7, in3);
    let t16 = circuit_sub(t14, t15); // Fp2 mul real part end
    let t17 = circuit_mul(in32, in3);
    let t18 = circuit_mul(t7, in2);
    let t19 = circuit_add(t17, t18); // Fp2 mul imag part end
    let t20 = circuit_mul(in30, in4); // Fp2 scalar mul coeff 0/1
    let t21 = circuit_mul(in31, in4); // Fp2 scalar mul coeff 1/1
    let t22 = circuit_mul(in32, in5); // Fp2 scalar mul coeff 0/1
    let t23 = circuit_mul(in33, in5); // Fp2 scalar mul coeff 1/1
    let t24 = circuit_sub(in38, t16); // Fp2 sub coeff 0/1
    let t25 = circuit_sub(in39, t19); // Fp2 sub coeff 1/1
    let t26 = circuit_sub(in36, t10); // Fp2 sub coeff 0/1
    let t27 = circuit_sub(in37, t13); // Fp2 sub coeff 1/1
    let t28 = circuit_mul(t26, t26); // Fp2 Inv start
    let t29 = circuit_mul(t27, t27);
    let t30 = circuit_add(t28, t29);
    let t31 = circuit_inverse(t30);
    let t32 = circuit_mul(t26, t31); // Fp2 Inv real part end
    let t33 = circuit_mul(t27, t31);
    let t34 = circuit_sub(in6, t33); // Fp2 Inv imag part end
    let t35 = circuit_mul(t24, t32); // Fp2 mul start
    let t36 = circuit_mul(t25, t34);
    let t37 = circuit_sub(t35, t36); // Fp2 mul real part end
    let t38 = circuit_mul(t24, t34);
    let t39 = circuit_mul(t25, t32);
    let t40 = circuit_add(t38, t39); // Fp2 mul imag part end
    let t41 = circuit_add(t37, t40);
    let t42 = circuit_sub(t37, t40);
    let t43 = circuit_mul(t41, t42);
    let t44 = circuit_mul(t37, t40);
    let t45 = circuit_add(t44, t44);
    let t46 = circuit_add(in36, t10); // Fp2 add coeff 0/1
    let t47 = circuit_add(in37, t13); // Fp2 add coeff 1/1
    let t48 = circuit_sub(t43, t46); // Fp2 sub coeff 0/1
    let t49 = circuit_sub(t45, t47); // Fp2 sub coeff 1/1
    let t50 = circuit_sub(in36, t48); // Fp2 sub coeff 0/1
    let t51 = circuit_sub(in37, t49); // Fp2 sub coeff 1/1
    let t52 = circuit_mul(t37, t50); // Fp2 mul start
    let t53 = circuit_mul(t40, t51);
    let t54 = circuit_sub(t52, t53); // Fp2 mul real part end
    let t55 = circuit_mul(t37, t51);
    let t56 = circuit_mul(t40, t50);
    let t57 = circuit_add(t55, t56); // Fp2 mul imag part end
    let t58 = circuit_sub(t54, in38); // Fp2 sub coeff 0/1
    let t59 = circuit_sub(t57, in39); // Fp2 sub coeff 1/1
    let t60 = circuit_mul(t37, in36); // Fp2 mul start
    let t61 = circuit_mul(t40, in37);
    let t62 = circuit_sub(t60, t61); // Fp2 mul real part end
    let t63 = circuit_mul(t37, in37);
    let t64 = circuit_mul(t40, in36);
    let t65 = circuit_add(t63, t64); // Fp2 mul imag part end
    let t66 = circuit_sub(t62, in38); // Fp2 sub coeff 0/1
    let t67 = circuit_sub(t65, in39); // Fp2 sub coeff 1/1
    let t68 = circuit_sub(t58, t22); // Fp2 sub coeff 0/1
    let t69 = circuit_sub(t59, t23); // Fp2 sub coeff 1/1
    let t70 = circuit_sub(t48, t20); // Fp2 sub coeff 0/1
    let t71 = circuit_sub(t49, t21); // Fp2 sub coeff 1/1
    let t72 = circuit_mul(t70, t70); // Fp2 Inv start
    let t73 = circuit_mul(t71, t71);
    let t74 = circuit_add(t72, t73);
    let t75 = circuit_inverse(t74);
    let t76 = circuit_mul(t70, t75); // Fp2 Inv real part end
    let t77 = circuit_mul(t71, t75);
    let t78 = circuit_sub(in6, t77); // Fp2 Inv imag part end
    let t79 = circuit_mul(t68, t76); // Fp2 mul start
    let t80 = circuit_mul(t69, t78);
    let t81 = circuit_sub(t79, t80); // Fp2 mul real part end
    let t82 = circuit_mul(t68, t78);
    let t83 = circuit_mul(t69, t76);
    let t84 = circuit_add(t82, t83); // Fp2 mul imag part end
    let t85 = circuit_mul(t81, t48); // Fp2 mul start
    let t86 = circuit_mul(t84, t49);
    let t87 = circuit_sub(t85, t86); // Fp2 mul real part end
    let t88 = circuit_mul(t81, t49);
    let t89 = circuit_mul(t84, t48);
    let t90 = circuit_add(t88, t89); // Fp2 mul imag part end
    let t91 = circuit_sub(t87, t58); // Fp2 sub coeff 0/1
    let t92 = circuit_sub(t90, t59); // Fp2 sub coeff 1/1
    let t93 = circuit_mul(in7, in13);
    let t94 = circuit_add(in12, t93);
    let t95 = circuit_mul(t94, in11); // eval bn line by xNegOverY
    let t96 = circuit_mul(in7, in15);
    let t97 = circuit_add(in14, t96);
    let t98 = circuit_mul(t97, in10); // eval bn line by yInv
    let t99 = circuit_mul(in13, in11); // eval bn line by xNegOverY
    let t100 = circuit_mul(in15, in10); // eval bn line by yInv
    let t101 = circuit_mul(in7, in17);
    let t102 = circuit_add(in16, t101);
    let t103 = circuit_mul(t102, in11); // eval bn line by xNegOverY
    let t104 = circuit_mul(in7, in19);
    let t105 = circuit_add(in18, t104);
    let t106 = circuit_mul(t105, in10); // eval bn line by yInv
    let t107 = circuit_mul(in17, in11); // eval bn line by xNegOverY
    let t108 = circuit_mul(in19, in10); // eval bn line by yInv
    let t109 = circuit_mul(in7, in23);
    let t110 = circuit_add(in22, t109);
    let t111 = circuit_mul(t110, in21); // eval bn line by xNegOverY
    let t112 = circuit_mul(in7, in25);
    let t113 = circuit_add(in24, t112);
    let t114 = circuit_mul(t113, in20); // eval bn line by yInv
    let t115 = circuit_mul(in23, in21); // eval bn line by xNegOverY
    let t116 = circuit_mul(in25, in20); // eval bn line by yInv
    let t117 = circuit_mul(in7, in27);
    let t118 = circuit_add(in26, t117);
    let t119 = circuit_mul(t118, in21); // eval bn line by xNegOverY
    let t120 = circuit_mul(in7, in29);
    let t121 = circuit_add(in28, t120);
    let t122 = circuit_mul(t121, in20); // eval bn line by yInv
    let t123 = circuit_mul(in27, in21); // eval bn line by xNegOverY
    let t124 = circuit_mul(in29, in20); // eval bn line by yInv
    let t125 = circuit_mul(in7, t40);
    let t126 = circuit_add(t37, t125);
    let t127 = circuit_mul(t126, in35); // eval bn line by xNegOverY
    let t128 = circuit_mul(in7, t67);
    let t129 = circuit_add(t66, t128);
    let t130 = circuit_mul(t129, in34); // eval bn line by yInv
    let t131 = circuit_mul(t40, in35); // eval bn line by xNegOverY
    let t132 = circuit_mul(t67, in34); // eval bn line by yInv
    let t133 = circuit_mul(in7, t84);
    let t134 = circuit_add(t81, t133);
    let t135 = circuit_mul(t134, in35); // eval bn line by xNegOverY
    let t136 = circuit_mul(in7, t92);
    let t137 = circuit_add(t91, t136);
    let t138 = circuit_mul(t137, in34); // eval bn line by yInv
    let t139 = circuit_mul(t84, in35); // eval bn line by xNegOverY
    let t140 = circuit_mul(t92, in34); // eval bn line by yInv
    let t141 = circuit_mul(t95, in44); // Eval sparse poly line_0 step coeff_1 * z^1
    let t142 = circuit_add(in5, t141); // Eval sparse poly line_0 step + coeff_1 * z^1
    let t143 = circuit_mul(t98, t1); // Eval sparse poly line_0 step coeff_3 * z^3
    let t144 = circuit_add(t142, t143); // Eval sparse poly line_0 step + coeff_3 * z^3
    let t145 = circuit_mul(t99, t3); // Eval sparse poly line_0 step coeff_7 * z^7
    let t146 = circuit_add(t144, t145); // Eval sparse poly line_0 step + coeff_7 * z^7
    let t147 = circuit_mul(t100, t4); // Eval sparse poly line_0 step coeff_9 * z^9
    let t148 = circuit_add(t146, t147); // Eval sparse poly line_0 step + coeff_9 * z^9
    let t149 = circuit_mul(in49, t148);
    let t150 = circuit_mul(t103, in44); // Eval sparse poly line_1 step coeff_1 * z^1
    let t151 = circuit_add(in5, t150); // Eval sparse poly line_1 step + coeff_1 * z^1
    let t152 = circuit_mul(t106, t1); // Eval sparse poly line_1 step coeff_3 * z^3
    let t153 = circuit_add(t151, t152); // Eval sparse poly line_1 step + coeff_3 * z^3
    let t154 = circuit_mul(t107, t3); // Eval sparse poly line_1 step coeff_7 * z^7
    let t155 = circuit_add(t153, t154); // Eval sparse poly line_1 step + coeff_7 * z^7
    let t156 = circuit_mul(t108, t4); // Eval sparse poly line_1 step coeff_9 * z^9
    let t157 = circuit_add(t155, t156); // Eval sparse poly line_1 step + coeff_9 * z^9
    let t158 = circuit_mul(t149, t157);
    let t159 = circuit_mul(t111, in44); // Eval sparse poly line_2 step coeff_1 * z^1
    let t160 = circuit_add(in5, t159); // Eval sparse poly line_2 step + coeff_1 * z^1
    let t161 = circuit_mul(t114, t1); // Eval sparse poly line_2 step coeff_3 * z^3
    let t162 = circuit_add(t160, t161); // Eval sparse poly line_2 step + coeff_3 * z^3
    let t163 = circuit_mul(t115, t3); // Eval sparse poly line_2 step coeff_7 * z^7
    let t164 = circuit_add(t162, t163); // Eval sparse poly line_2 step + coeff_7 * z^7
    let t165 = circuit_mul(t116, t4); // Eval sparse poly line_2 step coeff_9 * z^9
    let t166 = circuit_add(t164, t165); // Eval sparse poly line_2 step + coeff_9 * z^9
    let t167 = circuit_mul(t158, t166);
    let t168 = circuit_mul(t119, in44); // Eval sparse poly line_3 step coeff_1 * z^1
    let t169 = circuit_add(in5, t168); // Eval sparse poly line_3 step + coeff_1 * z^1
    let t170 = circuit_mul(t122, t1); // Eval sparse poly line_3 step coeff_3 * z^3
    let t171 = circuit_add(t169, t170); // Eval sparse poly line_3 step + coeff_3 * z^3
    let t172 = circuit_mul(t123, t3); // Eval sparse poly line_3 step coeff_7 * z^7
    let t173 = circuit_add(t171, t172); // Eval sparse poly line_3 step + coeff_7 * z^7
    let t174 = circuit_mul(t124, t4); // Eval sparse poly line_3 step coeff_9 * z^9
    let t175 = circuit_add(t173, t174); // Eval sparse poly line_3 step + coeff_9 * z^9
    let t176 = circuit_mul(t167, t175);
    let t177 = circuit_mul(t127, in44); // Eval sparse poly line_4 step coeff_1 * z^1
    let t178 = circuit_add(in5, t177); // Eval sparse poly line_4 step + coeff_1 * z^1
    let t179 = circuit_mul(t130, t1); // Eval sparse poly line_4 step coeff_3 * z^3
    let t180 = circuit_add(t178, t179); // Eval sparse poly line_4 step + coeff_3 * z^3
    let t181 = circuit_mul(t131, t3); // Eval sparse poly line_4 step coeff_7 * z^7
    let t182 = circuit_add(t180, t181); // Eval sparse poly line_4 step + coeff_7 * z^7
    let t183 = circuit_mul(t132, t4); // Eval sparse poly line_4 step coeff_9 * z^9
    let t184 = circuit_add(t182, t183); // Eval sparse poly line_4 step + coeff_9 * z^9
    let t185 = circuit_mul(t176, t184);
    let t186 = circuit_mul(t135, in44); // Eval sparse poly line_5 step coeff_1 * z^1
    let t187 = circuit_add(in5, t186); // Eval sparse poly line_5 step + coeff_1 * z^1
    let t188 = circuit_mul(t138, t1); // Eval sparse poly line_5 step coeff_3 * z^3
    let t189 = circuit_add(t187, t188); // Eval sparse poly line_5 step + coeff_3 * z^3
    let t190 = circuit_mul(t139, t3); // Eval sparse poly line_5 step coeff_7 * z^7
    let t191 = circuit_add(t189, t190); // Eval sparse poly line_5 step + coeff_7 * z^7
    let t192 = circuit_mul(t140, t4); // Eval sparse poly line_5 step coeff_9 * z^9
    let t193 = circuit_add(t191, t192); // Eval sparse poly line_5 step + coeff_9 * z^9
    let t194 = circuit_mul(t185, t193);
    let t195 = circuit_sub(t194, in40); // ((Π(n-2,k) (Pk(z)) - R_n_minus_2(z))
    let t196 = circuit_mul(in40, in45);
    let t197 = circuit_mul(t196, in46);
    let t198 = circuit_mul(t197, in47);
    let t199 = circuit_mul(t198, in43);
    let t200 = circuit_mul(t199, in240);
    let t201 = circuit_sub(t200, in41); // ((Π(n-1,k) (Pk(z)) - R_n_minus_1(z))
    let t202 = circuit_mul(in42, in48);
    let t203 = circuit_add(t202, t195);
    let t204 = circuit_mul(in42, t203);
    let t205 = circuit_add(t204, t201);
    let t206 = circuit_mul(in239, in44); // Eval big_Q Horner step: multiply by z
    let t207 = circuit_add(in238, t206); // Eval big_Q Horner step: add coefficient_188
    let t208 = circuit_mul(t207, in44); // Eval big_Q Horner step: multiply by z
    let t209 = circuit_add(in237, t208); // Eval big_Q Horner step: add coefficient_187
    let t210 = circuit_mul(t209, in44); // Eval big_Q Horner step: multiply by z
    let t211 = circuit_add(in236, t210); // Eval big_Q Horner step: add coefficient_186
    let t212 = circuit_mul(t211, in44); // Eval big_Q Horner step: multiply by z
    let t213 = circuit_add(in235, t212); // Eval big_Q Horner step: add coefficient_185
    let t214 = circuit_mul(t213, in44); // Eval big_Q Horner step: multiply by z
    let t215 = circuit_add(in234, t214); // Eval big_Q Horner step: add coefficient_184
    let t216 = circuit_mul(t215, in44); // Eval big_Q Horner step: multiply by z
    let t217 = circuit_add(in233, t216); // Eval big_Q Horner step: add coefficient_183
    let t218 = circuit_mul(t217, in44); // Eval big_Q Horner step: multiply by z
    let t219 = circuit_add(in232, t218); // Eval big_Q Horner step: add coefficient_182
    let t220 = circuit_mul(t219, in44); // Eval big_Q Horner step: multiply by z
    let t221 = circuit_add(in231, t220); // Eval big_Q Horner step: add coefficient_181
    let t222 = circuit_mul(t221, in44); // Eval big_Q Horner step: multiply by z
    let t223 = circuit_add(in230, t222); // Eval big_Q Horner step: add coefficient_180
    let t224 = circuit_mul(t223, in44); // Eval big_Q Horner step: multiply by z
    let t225 = circuit_add(in229, t224); // Eval big_Q Horner step: add coefficient_179
    let t226 = circuit_mul(t225, in44); // Eval big_Q Horner step: multiply by z
    let t227 = circuit_add(in228, t226); // Eval big_Q Horner step: add coefficient_178
    let t228 = circuit_mul(t227, in44); // Eval big_Q Horner step: multiply by z
    let t229 = circuit_add(in227, t228); // Eval big_Q Horner step: add coefficient_177
    let t230 = circuit_mul(t229, in44); // Eval big_Q Horner step: multiply by z
    let t231 = circuit_add(in226, t230); // Eval big_Q Horner step: add coefficient_176
    let t232 = circuit_mul(t231, in44); // Eval big_Q Horner step: multiply by z
    let t233 = circuit_add(in225, t232); // Eval big_Q Horner step: add coefficient_175
    let t234 = circuit_mul(t233, in44); // Eval big_Q Horner step: multiply by z
    let t235 = circuit_add(in224, t234); // Eval big_Q Horner step: add coefficient_174
    let t236 = circuit_mul(t235, in44); // Eval big_Q Horner step: multiply by z
    let t237 = circuit_add(in223, t236); // Eval big_Q Horner step: add coefficient_173
    let t238 = circuit_mul(t237, in44); // Eval big_Q Horner step: multiply by z
    let t239 = circuit_add(in222, t238); // Eval big_Q Horner step: add coefficient_172
    let t240 = circuit_mul(t239, in44); // Eval big_Q Horner step: multiply by z
    let t241 = circuit_add(in221, t240); // Eval big_Q Horner step: add coefficient_171
    let t242 = circuit_mul(t241, in44); // Eval big_Q Horner step: multiply by z
    let t243 = circuit_add(in220, t242); // Eval big_Q Horner step: add coefficient_170
    let t244 = circuit_mul(t243, in44); // Eval big_Q Horner step: multiply by z
    let t245 = circuit_add(in219, t244); // Eval big_Q Horner step: add coefficient_169
    let t246 = circuit_mul(t245, in44); // Eval big_Q Horner step: multiply by z
    let t247 = circuit_add(in218, t246); // Eval big_Q Horner step: add coefficient_168
    let t248 = circuit_mul(t247, in44); // Eval big_Q Horner step: multiply by z
    let t249 = circuit_add(in217, t248); // Eval big_Q Horner step: add coefficient_167
    let t250 = circuit_mul(t249, in44); // Eval big_Q Horner step: multiply by z
    let t251 = circuit_add(in216, t250); // Eval big_Q Horner step: add coefficient_166
    let t252 = circuit_mul(t251, in44); // Eval big_Q Horner step: multiply by z
    let t253 = circuit_add(in215, t252); // Eval big_Q Horner step: add coefficient_165
    let t254 = circuit_mul(t253, in44); // Eval big_Q Horner step: multiply by z
    let t255 = circuit_add(in214, t254); // Eval big_Q Horner step: add coefficient_164
    let t256 = circuit_mul(t255, in44); // Eval big_Q Horner step: multiply by z
    let t257 = circuit_add(in213, t256); // Eval big_Q Horner step: add coefficient_163
    let t258 = circuit_mul(t257, in44); // Eval big_Q Horner step: multiply by z
    let t259 = circuit_add(in212, t258); // Eval big_Q Horner step: add coefficient_162
    let t260 = circuit_mul(t259, in44); // Eval big_Q Horner step: multiply by z
    let t261 = circuit_add(in211, t260); // Eval big_Q Horner step: add coefficient_161
    let t262 = circuit_mul(t261, in44); // Eval big_Q Horner step: multiply by z
    let t263 = circuit_add(in210, t262); // Eval big_Q Horner step: add coefficient_160
    let t264 = circuit_mul(t263, in44); // Eval big_Q Horner step: multiply by z
    let t265 = circuit_add(in209, t264); // Eval big_Q Horner step: add coefficient_159
    let t266 = circuit_mul(t265, in44); // Eval big_Q Horner step: multiply by z
    let t267 = circuit_add(in208, t266); // Eval big_Q Horner step: add coefficient_158
    let t268 = circuit_mul(t267, in44); // Eval big_Q Horner step: multiply by z
    let t269 = circuit_add(in207, t268); // Eval big_Q Horner step: add coefficient_157
    let t270 = circuit_mul(t269, in44); // Eval big_Q Horner step: multiply by z
    let t271 = circuit_add(in206, t270); // Eval big_Q Horner step: add coefficient_156
    let t272 = circuit_mul(t271, in44); // Eval big_Q Horner step: multiply by z
    let t273 = circuit_add(in205, t272); // Eval big_Q Horner step: add coefficient_155
    let t274 = circuit_mul(t273, in44); // Eval big_Q Horner step: multiply by z
    let t275 = circuit_add(in204, t274); // Eval big_Q Horner step: add coefficient_154
    let t276 = circuit_mul(t275, in44); // Eval big_Q Horner step: multiply by z
    let t277 = circuit_add(in203, t276); // Eval big_Q Horner step: add coefficient_153
    let t278 = circuit_mul(t277, in44); // Eval big_Q Horner step: multiply by z
    let t279 = circuit_add(in202, t278); // Eval big_Q Horner step: add coefficient_152
    let t280 = circuit_mul(t279, in44); // Eval big_Q Horner step: multiply by z
    let t281 = circuit_add(in201, t280); // Eval big_Q Horner step: add coefficient_151
    let t282 = circuit_mul(t281, in44); // Eval big_Q Horner step: multiply by z
    let t283 = circuit_add(in200, t282); // Eval big_Q Horner step: add coefficient_150
    let t284 = circuit_mul(t283, in44); // Eval big_Q Horner step: multiply by z
    let t285 = circuit_add(in199, t284); // Eval big_Q Horner step: add coefficient_149
    let t286 = circuit_mul(t285, in44); // Eval big_Q Horner step: multiply by z
    let t287 = circuit_add(in198, t286); // Eval big_Q Horner step: add coefficient_148
    let t288 = circuit_mul(t287, in44); // Eval big_Q Horner step: multiply by z
    let t289 = circuit_add(in197, t288); // Eval big_Q Horner step: add coefficient_147
    let t290 = circuit_mul(t289, in44); // Eval big_Q Horner step: multiply by z
    let t291 = circuit_add(in196, t290); // Eval big_Q Horner step: add coefficient_146
    let t292 = circuit_mul(t291, in44); // Eval big_Q Horner step: multiply by z
    let t293 = circuit_add(in195, t292); // Eval big_Q Horner step: add coefficient_145
    let t294 = circuit_mul(t293, in44); // Eval big_Q Horner step: multiply by z
    let t295 = circuit_add(in194, t294); // Eval big_Q Horner step: add coefficient_144
    let t296 = circuit_mul(t295, in44); // Eval big_Q Horner step: multiply by z
    let t297 = circuit_add(in193, t296); // Eval big_Q Horner step: add coefficient_143
    let t298 = circuit_mul(t297, in44); // Eval big_Q Horner step: multiply by z
    let t299 = circuit_add(in192, t298); // Eval big_Q Horner step: add coefficient_142
    let t300 = circuit_mul(t299, in44); // Eval big_Q Horner step: multiply by z
    let t301 = circuit_add(in191, t300); // Eval big_Q Horner step: add coefficient_141
    let t302 = circuit_mul(t301, in44); // Eval big_Q Horner step: multiply by z
    let t303 = circuit_add(in190, t302); // Eval big_Q Horner step: add coefficient_140
    let t304 = circuit_mul(t303, in44); // Eval big_Q Horner step: multiply by z
    let t305 = circuit_add(in189, t304); // Eval big_Q Horner step: add coefficient_139
    let t306 = circuit_mul(t305, in44); // Eval big_Q Horner step: multiply by z
    let t307 = circuit_add(in188, t306); // Eval big_Q Horner step: add coefficient_138
    let t308 = circuit_mul(t307, in44); // Eval big_Q Horner step: multiply by z
    let t309 = circuit_add(in187, t308); // Eval big_Q Horner step: add coefficient_137
    let t310 = circuit_mul(t309, in44); // Eval big_Q Horner step: multiply by z
    let t311 = circuit_add(in186, t310); // Eval big_Q Horner step: add coefficient_136
    let t312 = circuit_mul(t311, in44); // Eval big_Q Horner step: multiply by z
    let t313 = circuit_add(in185, t312); // Eval big_Q Horner step: add coefficient_135
    let t314 = circuit_mul(t313, in44); // Eval big_Q Horner step: multiply by z
    let t315 = circuit_add(in184, t314); // Eval big_Q Horner step: add coefficient_134
    let t316 = circuit_mul(t315, in44); // Eval big_Q Horner step: multiply by z
    let t317 = circuit_add(in183, t316); // Eval big_Q Horner step: add coefficient_133
    let t318 = circuit_mul(t317, in44); // Eval big_Q Horner step: multiply by z
    let t319 = circuit_add(in182, t318); // Eval big_Q Horner step: add coefficient_132
    let t320 = circuit_mul(t319, in44); // Eval big_Q Horner step: multiply by z
    let t321 = circuit_add(in181, t320); // Eval big_Q Horner step: add coefficient_131
    let t322 = circuit_mul(t321, in44); // Eval big_Q Horner step: multiply by z
    let t323 = circuit_add(in180, t322); // Eval big_Q Horner step: add coefficient_130
    let t324 = circuit_mul(t323, in44); // Eval big_Q Horner step: multiply by z
    let t325 = circuit_add(in179, t324); // Eval big_Q Horner step: add coefficient_129
    let t326 = circuit_mul(t325, in44); // Eval big_Q Horner step: multiply by z
    let t327 = circuit_add(in178, t326); // Eval big_Q Horner step: add coefficient_128
    let t328 = circuit_mul(t327, in44); // Eval big_Q Horner step: multiply by z
    let t329 = circuit_add(in177, t328); // Eval big_Q Horner step: add coefficient_127
    let t330 = circuit_mul(t329, in44); // Eval big_Q Horner step: multiply by z
    let t331 = circuit_add(in176, t330); // Eval big_Q Horner step: add coefficient_126
    let t332 = circuit_mul(t331, in44); // Eval big_Q Horner step: multiply by z
    let t333 = circuit_add(in175, t332); // Eval big_Q Horner step: add coefficient_125
    let t334 = circuit_mul(t333, in44); // Eval big_Q Horner step: multiply by z
    let t335 = circuit_add(in174, t334); // Eval big_Q Horner step: add coefficient_124
    let t336 = circuit_mul(t335, in44); // Eval big_Q Horner step: multiply by z
    let t337 = circuit_add(in173, t336); // Eval big_Q Horner step: add coefficient_123
    let t338 = circuit_mul(t337, in44); // Eval big_Q Horner step: multiply by z
    let t339 = circuit_add(in172, t338); // Eval big_Q Horner step: add coefficient_122
    let t340 = circuit_mul(t339, in44); // Eval big_Q Horner step: multiply by z
    let t341 = circuit_add(in171, t340); // Eval big_Q Horner step: add coefficient_121
    let t342 = circuit_mul(t341, in44); // Eval big_Q Horner step: multiply by z
    let t343 = circuit_add(in170, t342); // Eval big_Q Horner step: add coefficient_120
    let t344 = circuit_mul(t343, in44); // Eval big_Q Horner step: multiply by z
    let t345 = circuit_add(in169, t344); // Eval big_Q Horner step: add coefficient_119
    let t346 = circuit_mul(t345, in44); // Eval big_Q Horner step: multiply by z
    let t347 = circuit_add(in168, t346); // Eval big_Q Horner step: add coefficient_118
    let t348 = circuit_mul(t347, in44); // Eval big_Q Horner step: multiply by z
    let t349 = circuit_add(in167, t348); // Eval big_Q Horner step: add coefficient_117
    let t350 = circuit_mul(t349, in44); // Eval big_Q Horner step: multiply by z
    let t351 = circuit_add(in166, t350); // Eval big_Q Horner step: add coefficient_116
    let t352 = circuit_mul(t351, in44); // Eval big_Q Horner step: multiply by z
    let t353 = circuit_add(in165, t352); // Eval big_Q Horner step: add coefficient_115
    let t354 = circuit_mul(t353, in44); // Eval big_Q Horner step: multiply by z
    let t355 = circuit_add(in164, t354); // Eval big_Q Horner step: add coefficient_114
    let t356 = circuit_mul(t355, in44); // Eval big_Q Horner step: multiply by z
    let t357 = circuit_add(in163, t356); // Eval big_Q Horner step: add coefficient_113
    let t358 = circuit_mul(t357, in44); // Eval big_Q Horner step: multiply by z
    let t359 = circuit_add(in162, t358); // Eval big_Q Horner step: add coefficient_112
    let t360 = circuit_mul(t359, in44); // Eval big_Q Horner step: multiply by z
    let t361 = circuit_add(in161, t360); // Eval big_Q Horner step: add coefficient_111
    let t362 = circuit_mul(t361, in44); // Eval big_Q Horner step: multiply by z
    let t363 = circuit_add(in160, t362); // Eval big_Q Horner step: add coefficient_110
    let t364 = circuit_mul(t363, in44); // Eval big_Q Horner step: multiply by z
    let t365 = circuit_add(in159, t364); // Eval big_Q Horner step: add coefficient_109
    let t366 = circuit_mul(t365, in44); // Eval big_Q Horner step: multiply by z
    let t367 = circuit_add(in158, t366); // Eval big_Q Horner step: add coefficient_108
    let t368 = circuit_mul(t367, in44); // Eval big_Q Horner step: multiply by z
    let t369 = circuit_add(in157, t368); // Eval big_Q Horner step: add coefficient_107
    let t370 = circuit_mul(t369, in44); // Eval big_Q Horner step: multiply by z
    let t371 = circuit_add(in156, t370); // Eval big_Q Horner step: add coefficient_106
    let t372 = circuit_mul(t371, in44); // Eval big_Q Horner step: multiply by z
    let t373 = circuit_add(in155, t372); // Eval big_Q Horner step: add coefficient_105
    let t374 = circuit_mul(t373, in44); // Eval big_Q Horner step: multiply by z
    let t375 = circuit_add(in154, t374); // Eval big_Q Horner step: add coefficient_104
    let t376 = circuit_mul(t375, in44); // Eval big_Q Horner step: multiply by z
    let t377 = circuit_add(in153, t376); // Eval big_Q Horner step: add coefficient_103
    let t378 = circuit_mul(t377, in44); // Eval big_Q Horner step: multiply by z
    let t379 = circuit_add(in152, t378); // Eval big_Q Horner step: add coefficient_102
    let t380 = circuit_mul(t379, in44); // Eval big_Q Horner step: multiply by z
    let t381 = circuit_add(in151, t380); // Eval big_Q Horner step: add coefficient_101
    let t382 = circuit_mul(t381, in44); // Eval big_Q Horner step: multiply by z
    let t383 = circuit_add(in150, t382); // Eval big_Q Horner step: add coefficient_100
    let t384 = circuit_mul(t383, in44); // Eval big_Q Horner step: multiply by z
    let t385 = circuit_add(in149, t384); // Eval big_Q Horner step: add coefficient_99
    let t386 = circuit_mul(t385, in44); // Eval big_Q Horner step: multiply by z
    let t387 = circuit_add(in148, t386); // Eval big_Q Horner step: add coefficient_98
    let t388 = circuit_mul(t387, in44); // Eval big_Q Horner step: multiply by z
    let t389 = circuit_add(in147, t388); // Eval big_Q Horner step: add coefficient_97
    let t390 = circuit_mul(t389, in44); // Eval big_Q Horner step: multiply by z
    let t391 = circuit_add(in146, t390); // Eval big_Q Horner step: add coefficient_96
    let t392 = circuit_mul(t391, in44); // Eval big_Q Horner step: multiply by z
    let t393 = circuit_add(in145, t392); // Eval big_Q Horner step: add coefficient_95
    let t394 = circuit_mul(t393, in44); // Eval big_Q Horner step: multiply by z
    let t395 = circuit_add(in144, t394); // Eval big_Q Horner step: add coefficient_94
    let t396 = circuit_mul(t395, in44); // Eval big_Q Horner step: multiply by z
    let t397 = circuit_add(in143, t396); // Eval big_Q Horner step: add coefficient_93
    let t398 = circuit_mul(t397, in44); // Eval big_Q Horner step: multiply by z
    let t399 = circuit_add(in142, t398); // Eval big_Q Horner step: add coefficient_92
    let t400 = circuit_mul(t399, in44); // Eval big_Q Horner step: multiply by z
    let t401 = circuit_add(in141, t400); // Eval big_Q Horner step: add coefficient_91
    let t402 = circuit_mul(t401, in44); // Eval big_Q Horner step: multiply by z
    let t403 = circuit_add(in140, t402); // Eval big_Q Horner step: add coefficient_90
    let t404 = circuit_mul(t403, in44); // Eval big_Q Horner step: multiply by z
    let t405 = circuit_add(in139, t404); // Eval big_Q Horner step: add coefficient_89
    let t406 = circuit_mul(t405, in44); // Eval big_Q Horner step: multiply by z
    let t407 = circuit_add(in138, t406); // Eval big_Q Horner step: add coefficient_88
    let t408 = circuit_mul(t407, in44); // Eval big_Q Horner step: multiply by z
    let t409 = circuit_add(in137, t408); // Eval big_Q Horner step: add coefficient_87
    let t410 = circuit_mul(t409, in44); // Eval big_Q Horner step: multiply by z
    let t411 = circuit_add(in136, t410); // Eval big_Q Horner step: add coefficient_86
    let t412 = circuit_mul(t411, in44); // Eval big_Q Horner step: multiply by z
    let t413 = circuit_add(in135, t412); // Eval big_Q Horner step: add coefficient_85
    let t414 = circuit_mul(t413, in44); // Eval big_Q Horner step: multiply by z
    let t415 = circuit_add(in134, t414); // Eval big_Q Horner step: add coefficient_84
    let t416 = circuit_mul(t415, in44); // Eval big_Q Horner step: multiply by z
    let t417 = circuit_add(in133, t416); // Eval big_Q Horner step: add coefficient_83
    let t418 = circuit_mul(t417, in44); // Eval big_Q Horner step: multiply by z
    let t419 = circuit_add(in132, t418); // Eval big_Q Horner step: add coefficient_82
    let t420 = circuit_mul(t419, in44); // Eval big_Q Horner step: multiply by z
    let t421 = circuit_add(in131, t420); // Eval big_Q Horner step: add coefficient_81
    let t422 = circuit_mul(t421, in44); // Eval big_Q Horner step: multiply by z
    let t423 = circuit_add(in130, t422); // Eval big_Q Horner step: add coefficient_80
    let t424 = circuit_mul(t423, in44); // Eval big_Q Horner step: multiply by z
    let t425 = circuit_add(in129, t424); // Eval big_Q Horner step: add coefficient_79
    let t426 = circuit_mul(t425, in44); // Eval big_Q Horner step: multiply by z
    let t427 = circuit_add(in128, t426); // Eval big_Q Horner step: add coefficient_78
    let t428 = circuit_mul(t427, in44); // Eval big_Q Horner step: multiply by z
    let t429 = circuit_add(in127, t428); // Eval big_Q Horner step: add coefficient_77
    let t430 = circuit_mul(t429, in44); // Eval big_Q Horner step: multiply by z
    let t431 = circuit_add(in126, t430); // Eval big_Q Horner step: add coefficient_76
    let t432 = circuit_mul(t431, in44); // Eval big_Q Horner step: multiply by z
    let t433 = circuit_add(in125, t432); // Eval big_Q Horner step: add coefficient_75
    let t434 = circuit_mul(t433, in44); // Eval big_Q Horner step: multiply by z
    let t435 = circuit_add(in124, t434); // Eval big_Q Horner step: add coefficient_74
    let t436 = circuit_mul(t435, in44); // Eval big_Q Horner step: multiply by z
    let t437 = circuit_add(in123, t436); // Eval big_Q Horner step: add coefficient_73
    let t438 = circuit_mul(t437, in44); // Eval big_Q Horner step: multiply by z
    let t439 = circuit_add(in122, t438); // Eval big_Q Horner step: add coefficient_72
    let t440 = circuit_mul(t439, in44); // Eval big_Q Horner step: multiply by z
    let t441 = circuit_add(in121, t440); // Eval big_Q Horner step: add coefficient_71
    let t442 = circuit_mul(t441, in44); // Eval big_Q Horner step: multiply by z
    let t443 = circuit_add(in120, t442); // Eval big_Q Horner step: add coefficient_70
    let t444 = circuit_mul(t443, in44); // Eval big_Q Horner step: multiply by z
    let t445 = circuit_add(in119, t444); // Eval big_Q Horner step: add coefficient_69
    let t446 = circuit_mul(t445, in44); // Eval big_Q Horner step: multiply by z
    let t447 = circuit_add(in118, t446); // Eval big_Q Horner step: add coefficient_68
    let t448 = circuit_mul(t447, in44); // Eval big_Q Horner step: multiply by z
    let t449 = circuit_add(in117, t448); // Eval big_Q Horner step: add coefficient_67
    let t450 = circuit_mul(t449, in44); // Eval big_Q Horner step: multiply by z
    let t451 = circuit_add(in116, t450); // Eval big_Q Horner step: add coefficient_66
    let t452 = circuit_mul(t451, in44); // Eval big_Q Horner step: multiply by z
    let t453 = circuit_add(in115, t452); // Eval big_Q Horner step: add coefficient_65
    let t454 = circuit_mul(t453, in44); // Eval big_Q Horner step: multiply by z
    let t455 = circuit_add(in114, t454); // Eval big_Q Horner step: add coefficient_64
    let t456 = circuit_mul(t455, in44); // Eval big_Q Horner step: multiply by z
    let t457 = circuit_add(in113, t456); // Eval big_Q Horner step: add coefficient_63
    let t458 = circuit_mul(t457, in44); // Eval big_Q Horner step: multiply by z
    let t459 = circuit_add(in112, t458); // Eval big_Q Horner step: add coefficient_62
    let t460 = circuit_mul(t459, in44); // Eval big_Q Horner step: multiply by z
    let t461 = circuit_add(in111, t460); // Eval big_Q Horner step: add coefficient_61
    let t462 = circuit_mul(t461, in44); // Eval big_Q Horner step: multiply by z
    let t463 = circuit_add(in110, t462); // Eval big_Q Horner step: add coefficient_60
    let t464 = circuit_mul(t463, in44); // Eval big_Q Horner step: multiply by z
    let t465 = circuit_add(in109, t464); // Eval big_Q Horner step: add coefficient_59
    let t466 = circuit_mul(t465, in44); // Eval big_Q Horner step: multiply by z
    let t467 = circuit_add(in108, t466); // Eval big_Q Horner step: add coefficient_58
    let t468 = circuit_mul(t467, in44); // Eval big_Q Horner step: multiply by z
    let t469 = circuit_add(in107, t468); // Eval big_Q Horner step: add coefficient_57
    let t470 = circuit_mul(t469, in44); // Eval big_Q Horner step: multiply by z
    let t471 = circuit_add(in106, t470); // Eval big_Q Horner step: add coefficient_56
    let t472 = circuit_mul(t471, in44); // Eval big_Q Horner step: multiply by z
    let t473 = circuit_add(in105, t472); // Eval big_Q Horner step: add coefficient_55
    let t474 = circuit_mul(t473, in44); // Eval big_Q Horner step: multiply by z
    let t475 = circuit_add(in104, t474); // Eval big_Q Horner step: add coefficient_54
    let t476 = circuit_mul(t475, in44); // Eval big_Q Horner step: multiply by z
    let t477 = circuit_add(in103, t476); // Eval big_Q Horner step: add coefficient_53
    let t478 = circuit_mul(t477, in44); // Eval big_Q Horner step: multiply by z
    let t479 = circuit_add(in102, t478); // Eval big_Q Horner step: add coefficient_52
    let t480 = circuit_mul(t479, in44); // Eval big_Q Horner step: multiply by z
    let t481 = circuit_add(in101, t480); // Eval big_Q Horner step: add coefficient_51
    let t482 = circuit_mul(t481, in44); // Eval big_Q Horner step: multiply by z
    let t483 = circuit_add(in100, t482); // Eval big_Q Horner step: add coefficient_50
    let t484 = circuit_mul(t483, in44); // Eval big_Q Horner step: multiply by z
    let t485 = circuit_add(in99, t484); // Eval big_Q Horner step: add coefficient_49
    let t486 = circuit_mul(t485, in44); // Eval big_Q Horner step: multiply by z
    let t487 = circuit_add(in98, t486); // Eval big_Q Horner step: add coefficient_48
    let t488 = circuit_mul(t487, in44); // Eval big_Q Horner step: multiply by z
    let t489 = circuit_add(in97, t488); // Eval big_Q Horner step: add coefficient_47
    let t490 = circuit_mul(t489, in44); // Eval big_Q Horner step: multiply by z
    let t491 = circuit_add(in96, t490); // Eval big_Q Horner step: add coefficient_46
    let t492 = circuit_mul(t491, in44); // Eval big_Q Horner step: multiply by z
    let t493 = circuit_add(in95, t492); // Eval big_Q Horner step: add coefficient_45
    let t494 = circuit_mul(t493, in44); // Eval big_Q Horner step: multiply by z
    let t495 = circuit_add(in94, t494); // Eval big_Q Horner step: add coefficient_44
    let t496 = circuit_mul(t495, in44); // Eval big_Q Horner step: multiply by z
    let t497 = circuit_add(in93, t496); // Eval big_Q Horner step: add coefficient_43
    let t498 = circuit_mul(t497, in44); // Eval big_Q Horner step: multiply by z
    let t499 = circuit_add(in92, t498); // Eval big_Q Horner step: add coefficient_42
    let t500 = circuit_mul(t499, in44); // Eval big_Q Horner step: multiply by z
    let t501 = circuit_add(in91, t500); // Eval big_Q Horner step: add coefficient_41
    let t502 = circuit_mul(t501, in44); // Eval big_Q Horner step: multiply by z
    let t503 = circuit_add(in90, t502); // Eval big_Q Horner step: add coefficient_40
    let t504 = circuit_mul(t503, in44); // Eval big_Q Horner step: multiply by z
    let t505 = circuit_add(in89, t504); // Eval big_Q Horner step: add coefficient_39
    let t506 = circuit_mul(t505, in44); // Eval big_Q Horner step: multiply by z
    let t507 = circuit_add(in88, t506); // Eval big_Q Horner step: add coefficient_38
    let t508 = circuit_mul(t507, in44); // Eval big_Q Horner step: multiply by z
    let t509 = circuit_add(in87, t508); // Eval big_Q Horner step: add coefficient_37
    let t510 = circuit_mul(t509, in44); // Eval big_Q Horner step: multiply by z
    let t511 = circuit_add(in86, t510); // Eval big_Q Horner step: add coefficient_36
    let t512 = circuit_mul(t511, in44); // Eval big_Q Horner step: multiply by z
    let t513 = circuit_add(in85, t512); // Eval big_Q Horner step: add coefficient_35
    let t514 = circuit_mul(t513, in44); // Eval big_Q Horner step: multiply by z
    let t515 = circuit_add(in84, t514); // Eval big_Q Horner step: add coefficient_34
    let t516 = circuit_mul(t515, in44); // Eval big_Q Horner step: multiply by z
    let t517 = circuit_add(in83, t516); // Eval big_Q Horner step: add coefficient_33
    let t518 = circuit_mul(t517, in44); // Eval big_Q Horner step: multiply by z
    let t519 = circuit_add(in82, t518); // Eval big_Q Horner step: add coefficient_32
    let t520 = circuit_mul(t519, in44); // Eval big_Q Horner step: multiply by z
    let t521 = circuit_add(in81, t520); // Eval big_Q Horner step: add coefficient_31
    let t522 = circuit_mul(t521, in44); // Eval big_Q Horner step: multiply by z
    let t523 = circuit_add(in80, t522); // Eval big_Q Horner step: add coefficient_30
    let t524 = circuit_mul(t523, in44); // Eval big_Q Horner step: multiply by z
    let t525 = circuit_add(in79, t524); // Eval big_Q Horner step: add coefficient_29
    let t526 = circuit_mul(t525, in44); // Eval big_Q Horner step: multiply by z
    let t527 = circuit_add(in78, t526); // Eval big_Q Horner step: add coefficient_28
    let t528 = circuit_mul(t527, in44); // Eval big_Q Horner step: multiply by z
    let t529 = circuit_add(in77, t528); // Eval big_Q Horner step: add coefficient_27
    let t530 = circuit_mul(t529, in44); // Eval big_Q Horner step: multiply by z
    let t531 = circuit_add(in76, t530); // Eval big_Q Horner step: add coefficient_26
    let t532 = circuit_mul(t531, in44); // Eval big_Q Horner step: multiply by z
    let t533 = circuit_add(in75, t532); // Eval big_Q Horner step: add coefficient_25
    let t534 = circuit_mul(t533, in44); // Eval big_Q Horner step: multiply by z
    let t535 = circuit_add(in74, t534); // Eval big_Q Horner step: add coefficient_24
    let t536 = circuit_mul(t535, in44); // Eval big_Q Horner step: multiply by z
    let t537 = circuit_add(in73, t536); // Eval big_Q Horner step: add coefficient_23
    let t538 = circuit_mul(t537, in44); // Eval big_Q Horner step: multiply by z
    let t539 = circuit_add(in72, t538); // Eval big_Q Horner step: add coefficient_22
    let t540 = circuit_mul(t539, in44); // Eval big_Q Horner step: multiply by z
    let t541 = circuit_add(in71, t540); // Eval big_Q Horner step: add coefficient_21
    let t542 = circuit_mul(t541, in44); // Eval big_Q Horner step: multiply by z
    let t543 = circuit_add(in70, t542); // Eval big_Q Horner step: add coefficient_20
    let t544 = circuit_mul(t543, in44); // Eval big_Q Horner step: multiply by z
    let t545 = circuit_add(in69, t544); // Eval big_Q Horner step: add coefficient_19
    let t546 = circuit_mul(t545, in44); // Eval big_Q Horner step: multiply by z
    let t547 = circuit_add(in68, t546); // Eval big_Q Horner step: add coefficient_18
    let t548 = circuit_mul(t547, in44); // Eval big_Q Horner step: multiply by z
    let t549 = circuit_add(in67, t548); // Eval big_Q Horner step: add coefficient_17
    let t550 = circuit_mul(t549, in44); // Eval big_Q Horner step: multiply by z
    let t551 = circuit_add(in66, t550); // Eval big_Q Horner step: add coefficient_16
    let t552 = circuit_mul(t551, in44); // Eval big_Q Horner step: multiply by z
    let t553 = circuit_add(in65, t552); // Eval big_Q Horner step: add coefficient_15
    let t554 = circuit_mul(t553, in44); // Eval big_Q Horner step: multiply by z
    let t555 = circuit_add(in64, t554); // Eval big_Q Horner step: add coefficient_14
    let t556 = circuit_mul(t555, in44); // Eval big_Q Horner step: multiply by z
    let t557 = circuit_add(in63, t556); // Eval big_Q Horner step: add coefficient_13
    let t558 = circuit_mul(t557, in44); // Eval big_Q Horner step: multiply by z
    let t559 = circuit_add(in62, t558); // Eval big_Q Horner step: add coefficient_12
    let t560 = circuit_mul(t559, in44); // Eval big_Q Horner step: multiply by z
    let t561 = circuit_add(in61, t560); // Eval big_Q Horner step: add coefficient_11
    let t562 = circuit_mul(t561, in44); // Eval big_Q Horner step: multiply by z
    let t563 = circuit_add(in60, t562); // Eval big_Q Horner step: add coefficient_10
    let t564 = circuit_mul(t563, in44); // Eval big_Q Horner step: multiply by z
    let t565 = circuit_add(in59, t564); // Eval big_Q Horner step: add coefficient_9
    let t566 = circuit_mul(t565, in44); // Eval big_Q Horner step: multiply by z
    let t567 = circuit_add(in58, t566); // Eval big_Q Horner step: add coefficient_8
    let t568 = circuit_mul(t567, in44); // Eval big_Q Horner step: multiply by z
    let t569 = circuit_add(in57, t568); // Eval big_Q Horner step: add coefficient_7
    let t570 = circuit_mul(t569, in44); // Eval big_Q Horner step: multiply by z
    let t571 = circuit_add(in56, t570); // Eval big_Q Horner step: add coefficient_6
    let t572 = circuit_mul(t571, in44); // Eval big_Q Horner step: multiply by z
    let t573 = circuit_add(in55, t572); // Eval big_Q Horner step: add coefficient_5
    let t574 = circuit_mul(t573, in44); // Eval big_Q Horner step: multiply by z
    let t575 = circuit_add(in54, t574); // Eval big_Q Horner step: add coefficient_4
    let t576 = circuit_mul(t575, in44); // Eval big_Q Horner step: multiply by z
    let t577 = circuit_add(in53, t576); // Eval big_Q Horner step: add coefficient_3
    let t578 = circuit_mul(t577, in44); // Eval big_Q Horner step: multiply by z
    let t579 = circuit_add(in52, t578); // Eval big_Q Horner step: add coefficient_2
    let t580 = circuit_mul(t579, in44); // Eval big_Q Horner step: multiply by z
    let t581 = circuit_add(in51, t580); // Eval big_Q Horner step: add coefficient_1
    let t582 = circuit_mul(t581, in44); // Eval big_Q Horner step: multiply by z
    let t583 = circuit_add(in50, t582); // Eval big_Q Horner step: add coefficient_0
    let t584 = circuit_mul(in9, t2); // Eval sparse poly P_irr step coeff_6 * z^6
    let t585 = circuit_add(in8, t584); // Eval sparse poly P_irr step + coeff_6 * z^6
    let t586 = circuit_add(t585, t5); // Eval sparse poly P_irr step + 1*z^12
    let t587 = circuit_mul(t583, t586);
    let t588 = circuit_sub(t205, t587);

    let modulus = crate::definitions::get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (t588,).new_inputs();
    // Prefill constants:

    circuit_inputs = circuit_inputs
        .next_span(MP_CHECK_FINALIZE_3P_2F_EXT_MLR_BN254_CONSTANTS.span()); // in0 - in9

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(yInv_0); // in10
    circuit_inputs = circuit_inputs.next_2(xNegOverY_0); // in11
    circuit_inputs = circuit_inputs.next_2(line_1_0.r0a0); // in12
    circuit_inputs = circuit_inputs.next_2(line_1_0.r0a1); // in13
    circuit_inputs = circuit_inputs.next_2(line_1_0.r1a0); // in14
    circuit_inputs = circuit_inputs.next_2(line_1_0.r1a1); // in15
    circuit_inputs = circuit_inputs.next_2(line_2_0.r0a0); // in16
    circuit_inputs = circuit_inputs.next_2(line_2_0.r0a1); // in17
    circuit_inputs = circuit_inputs.next_2(line_2_0.r1a0); // in18
    circuit_inputs = circuit_inputs.next_2(line_2_0.r1a1); // in19
    circuit_inputs = circuit_inputs.next_2(yInv_1); // in20
    circuit_inputs = circuit_inputs.next_2(xNegOverY_1); // in21
    circuit_inputs = circuit_inputs.next_2(line_1_1.r0a0); // in22
    circuit_inputs = circuit_inputs.next_2(line_1_1.r0a1); // in23
    circuit_inputs = circuit_inputs.next_2(line_1_1.r1a0); // in24
    circuit_inputs = circuit_inputs.next_2(line_1_1.r1a1); // in25
    circuit_inputs = circuit_inputs.next_2(line_2_1.r0a0); // in26
    circuit_inputs = circuit_inputs.next_2(line_2_1.r0a1); // in27
    circuit_inputs = circuit_inputs.next_2(line_2_1.r1a0); // in28
    circuit_inputs = circuit_inputs.next_2(line_2_1.r1a1); // in29
    circuit_inputs = circuit_inputs.next_2(original_Q2.x0); // in30
    circuit_inputs = circuit_inputs.next_2(original_Q2.x1); // in31
    circuit_inputs = circuit_inputs.next_2(original_Q2.y0); // in32
    circuit_inputs = circuit_inputs.next_2(original_Q2.y1); // in33
    circuit_inputs = circuit_inputs.next_2(yInv_2); // in34
    circuit_inputs = circuit_inputs.next_2(xNegOverY_2); // in35
    circuit_inputs = circuit_inputs.next_2(Q_2.x0); // in36
    circuit_inputs = circuit_inputs.next_2(Q_2.x1); // in37
    circuit_inputs = circuit_inputs.next_2(Q_2.y0); // in38
    circuit_inputs = circuit_inputs.next_2(Q_2.y1); // in39
    circuit_inputs = circuit_inputs.next_2(R_n_minus_2_of_z); // in40
    circuit_inputs = circuit_inputs.next_2(R_n_minus_1_of_z); // in41
    circuit_inputs = circuit_inputs.next_2(c_0); // in42
    circuit_inputs = circuit_inputs.next_2(w_of_z); // in43
    circuit_inputs = circuit_inputs.next_2(z); // in44
    circuit_inputs = circuit_inputs.next_2(c_inv_frob_1_of_z); // in45
    circuit_inputs = circuit_inputs.next_2(c_frob_2_of_z); // in46
    circuit_inputs = circuit_inputs.next_2(c_inv_frob_3_of_z); // in47
    circuit_inputs = circuit_inputs.next_2(previous_lhs); // in48
    circuit_inputs = circuit_inputs.next_2(R_n_minus_3_of_z); // in49

    for val in Q.span() {
        circuit_inputs = circuit_inputs.next_2(*val);
    } // in50 - in239

    circuit_inputs = circuit_inputs.next_2(precomputed_miller_loop_result_of_z); // in240

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let final_check: u384 = outputs.get_output(t588);
    return (final_check,);
}
const MP_CHECK_FINALIZE_3P_2F_EXT_MLR_BN254_CONSTANTS: [u384; 10] = [
    u384 {
        limb0: 0xc2c3330c99e39557176f553d,
        limb1: 0x4c0bec3cf559b143b78cc310,
        limb2: 0x2fb347984f7911f7,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xb7c9dce1665d51c640fcba2,
        limb1: 0x4ba4cc8bd75a079432ae2a1d,
        limb2: 0x16c9e55061ebae20,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xa9c95998dc54014671a0135a,
        limb1: 0xdc5ec698b6e2f9b9dbaae0ed,
        limb2: 0x63cf305489af5dc,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x8fa25bd282d37f632623b0e3,
        limb1: 0x704b5a7ec796f2b21807dc9,
        limb2: 0x7c03cbcac41049a,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xbb966e3de4bd44e5607cfd48,
        limb1: 0x5e6dd9e7e0acccb0c28f069f,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 {
        limb0: 0x6871ca8d3c208c16d87cfd3e,
        limb1: 0xb85045b68181585d97816a91,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    u384 { limb0: 0x52, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 {
        limb0: 0x6871ca8d3c208c16d87cfd35,
        limb1: 0xb85045b68181585d97816a91,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
];
#[inline(always)]
pub fn run_BN254_MP_CHECK_INIT_BIT_2P_2F_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    G2_line_0: G2Line<u288>,
    yInv_1: u384,
    xNegOverY_1: u384,
    G2_line_1: G2Line<u288>,
    R_i_of_z: u384,
    z: u384,
    c_inv_of_z: u384,
    c1: u384,
    previous_lhs: u384,
) -> (u384,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // -0x9 % p
    let in1 = CE::<CI<1>> {}; // 0x1

    // INPUT stack
    let (in2, in3, in4) = (CE::<CI<2>> {}, CE::<CI<3>> {}, CE::<CI<4>> {});
    let (in5, in6, in7) = (CE::<CI<5>> {}, CE::<CI<6>> {}, CE::<CI<7>> {});
    let (in8, in9, in10) = (CE::<CI<8>> {}, CE::<CI<9>> {}, CE::<CI<10>> {});
    let (in11, in12, in13) = (CE::<CI<11>> {}, CE::<CI<12>> {}, CE::<CI<13>> {});
    let (in14, in15, in16) = (CE::<CI<14>> {}, CE::<CI<15>> {}, CE::<CI<16>> {});
    let (in17, in18) = (CE::<CI<17>> {}, CE::<CI<18>> {});
    let t0 = circuit_mul(in15, in15); // compute z^2
    let t1 = circuit_mul(t0, in15); // compute z^3
    let t2 = circuit_mul(t1, t1); // compute z^6
    let t3 = circuit_mul(t2, in15); // compute z^7
    let t4 = circuit_mul(t3, t0); // compute z^9
    let t5 = circuit_mul(in16, in16);
    let t6 = circuit_mul(in0, in5);
    let t7 = circuit_add(in4, t6);
    let t8 = circuit_mul(t7, in3); // eval bn line by xNegOverY
    let t9 = circuit_mul(in0, in7);
    let t10 = circuit_add(in6, t9);
    let t11 = circuit_mul(t10, in2); // eval bn line by yInv
    let t12 = circuit_mul(in5, in3); // eval bn line by xNegOverY
    let t13 = circuit_mul(in7, in2); // eval bn line by yInv
    let t14 = circuit_mul(t8, in15); // Eval sparse poly line_0p_1 step coeff_1 * z^1
    let t15 = circuit_add(in1, t14); // Eval sparse poly line_0p_1 step + coeff_1 * z^1
    let t16 = circuit_mul(t11, t1); // Eval sparse poly line_0p_1 step coeff_3 * z^3
    let t17 = circuit_add(t15, t16); // Eval sparse poly line_0p_1 step + coeff_3 * z^3
    let t18 = circuit_mul(t12, t3); // Eval sparse poly line_0p_1 step coeff_7 * z^7
    let t19 = circuit_add(t17, t18); // Eval sparse poly line_0p_1 step + coeff_7 * z^7
    let t20 = circuit_mul(t13, t4); // Eval sparse poly line_0p_1 step coeff_9 * z^9
    let t21 = circuit_add(t19, t20); // Eval sparse poly line_0p_1 step + coeff_9 * z^9
    let t22 = circuit_mul(t5, t21);
    let t23 = circuit_mul(in0, in11);
    let t24 = circuit_add(in10, t23);
    let t25 = circuit_mul(t24, in9); // eval bn line by xNegOverY
    let t26 = circuit_mul(in0, in13);
    let t27 = circuit_add(in12, t26);
    let t28 = circuit_mul(t27, in8); // eval bn line by yInv
    let t29 = circuit_mul(in11, in9); // eval bn line by xNegOverY
    let t30 = circuit_mul(in13, in8); // eval bn line by yInv
    let t31 = circuit_mul(t25, in15); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t32 = circuit_add(in1, t31); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t33 = circuit_mul(t28, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t34 = circuit_add(t32, t33); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t35 = circuit_mul(t29, t3); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t36 = circuit_add(t34, t35); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t37 = circuit_mul(t30, t4); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t38 = circuit_add(t36, t37); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t39 = circuit_mul(t22, t38);
    let t40 = circuit_sub(t39, in14); // ((Π(i,k) (Pk(z)) - Ri(z))
    let t41 = circuit_mul(in17, in18);
    let t42 = circuit_add(t40, t41);

    let modulus = crate::definitions::get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (t42,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs
        .next_2(
            [0x6871ca8d3c208c16d87cfd3e, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0],
        ); // in0
    circuit_inputs = circuit_inputs.next_2([0x1, 0x0, 0x0, 0x0]); // in1
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(yInv_0); // in2
    circuit_inputs = circuit_inputs.next_2(xNegOverY_0); // in3
    circuit_inputs = circuit_inputs.next_2(G2_line_0.r0a0); // in4
    circuit_inputs = circuit_inputs.next_2(G2_line_0.r0a1); // in5
    circuit_inputs = circuit_inputs.next_2(G2_line_0.r1a0); // in6
    circuit_inputs = circuit_inputs.next_2(G2_line_0.r1a1); // in7
    circuit_inputs = circuit_inputs.next_2(yInv_1); // in8
    circuit_inputs = circuit_inputs.next_2(xNegOverY_1); // in9
    circuit_inputs = circuit_inputs.next_2(G2_line_1.r0a0); // in10
    circuit_inputs = circuit_inputs.next_2(G2_line_1.r0a1); // in11
    circuit_inputs = circuit_inputs.next_2(G2_line_1.r1a0); // in12
    circuit_inputs = circuit_inputs.next_2(G2_line_1.r1a1); // in13
    circuit_inputs = circuit_inputs.next_2(R_i_of_z); // in14
    circuit_inputs = circuit_inputs.next_2(z); // in15
    circuit_inputs = circuit_inputs.next_2(c_inv_of_z); // in16
    circuit_inputs = circuit_inputs.next_2(c1); // in17
    circuit_inputs = circuit_inputs.next_2(previous_lhs); // in18

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let new_lhs: u384 = outputs.get_output(t42);
    return (new_lhs,);
}
#[inline(always)]
pub fn run_BN254_MP_CHECK_INIT_BIT_3P_2F_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    G2_line_0: G2Line<u288>,
    yInv_1: u384,
    xNegOverY_1: u384,
    G2_line_1: G2Line<u288>,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q_2: G2Point,
    R_i_of_z: u384,
    z: u384,
    c_inv_of_z: u384,
    c1: u384,
    previous_lhs: u384,
) -> (G2Point, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // -0x9 % p
    let in1 = CE::<CI<1>> {}; // 0x1
    let in2 = CE::<CI<2>> {}; // 0x3
    let in3 = CE::<CI<3>> {}; // 0x6
    let in4 = CE::<CI<4>> {}; // 0x0

    // INPUT stack
    let (in5, in6, in7) = (CE::<CI<5>> {}, CE::<CI<6>> {}, CE::<CI<7>> {});
    let (in8, in9, in10) = (CE::<CI<8>> {}, CE::<CI<9>> {}, CE::<CI<10>> {});
    let (in11, in12, in13) = (CE::<CI<11>> {}, CE::<CI<12>> {}, CE::<CI<13>> {});
    let (in14, in15, in16) = (CE::<CI<14>> {}, CE::<CI<15>> {}, CE::<CI<16>> {});
    let (in17, in18, in19) = (CE::<CI<17>> {}, CE::<CI<18>> {}, CE::<CI<19>> {});
    let (in20, in21, in22) = (CE::<CI<20>> {}, CE::<CI<21>> {}, CE::<CI<22>> {});
    let (in23, in24, in25) = (CE::<CI<23>> {}, CE::<CI<24>> {}, CE::<CI<25>> {});
    let (in26, in27) = (CE::<CI<26>> {}, CE::<CI<27>> {});
    let t0 = circuit_mul(in24, in24); // compute z^2
    let t1 = circuit_mul(t0, in24); // compute z^3
    let t2 = circuit_mul(t1, t1); // compute z^6
    let t3 = circuit_mul(t2, in24); // compute z^7
    let t4 = circuit_mul(t3, t0); // compute z^9
    let t5 = circuit_mul(in25, in25);
    let t6 = circuit_mul(in0, in8);
    let t7 = circuit_add(in7, t6);
    let t8 = circuit_mul(t7, in6); // eval bn line by xNegOverY
    let t9 = circuit_mul(in0, in10);
    let t10 = circuit_add(in9, t9);
    let t11 = circuit_mul(t10, in5); // eval bn line by yInv
    let t12 = circuit_mul(in8, in6); // eval bn line by xNegOverY
    let t13 = circuit_mul(in10, in5); // eval bn line by yInv
    let t14 = circuit_mul(t8, in24); // Eval sparse poly line_0p_1 step coeff_1 * z^1
    let t15 = circuit_add(in1, t14); // Eval sparse poly line_0p_1 step + coeff_1 * z^1
    let t16 = circuit_mul(t11, t1); // Eval sparse poly line_0p_1 step coeff_3 * z^3
    let t17 = circuit_add(t15, t16); // Eval sparse poly line_0p_1 step + coeff_3 * z^3
    let t18 = circuit_mul(t12, t3); // Eval sparse poly line_0p_1 step coeff_7 * z^7
    let t19 = circuit_add(t17, t18); // Eval sparse poly line_0p_1 step + coeff_7 * z^7
    let t20 = circuit_mul(t13, t4); // Eval sparse poly line_0p_1 step coeff_9 * z^9
    let t21 = circuit_add(t19, t20); // Eval sparse poly line_0p_1 step + coeff_9 * z^9
    let t22 = circuit_mul(t5, t21);
    let t23 = circuit_mul(in0, in14);
    let t24 = circuit_add(in13, t23);
    let t25 = circuit_mul(t24, in12); // eval bn line by xNegOverY
    let t26 = circuit_mul(in0, in16);
    let t27 = circuit_add(in15, t26);
    let t28 = circuit_mul(t27, in11); // eval bn line by yInv
    let t29 = circuit_mul(in14, in12); // eval bn line by xNegOverY
    let t30 = circuit_mul(in16, in11); // eval bn line by yInv
    let t31 = circuit_mul(t25, in24); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t32 = circuit_add(in1, t31); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t33 = circuit_mul(t28, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t34 = circuit_add(t32, t33); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t35 = circuit_mul(t29, t3); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t36 = circuit_add(t34, t35); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t37 = circuit_mul(t30, t4); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t38 = circuit_add(t36, t37); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t39 = circuit_mul(t22, t38);
    let t40 = circuit_add(in19, in20); // Doubling slope numerator start
    let t41 = circuit_sub(in19, in20);
    let t42 = circuit_mul(t40, t41);
    let t43 = circuit_mul(in19, in20);
    let t44 = circuit_mul(t42, in2);
    let t45 = circuit_mul(t43, in3); // Doubling slope numerator end
    let t46 = circuit_add(in21, in21); // Fp2 add coeff 0/1
    let t47 = circuit_add(in22, in22); // Fp2 add coeff 1/1
    let t48 = circuit_mul(t46, t46); // Fp2 Inv start
    let t49 = circuit_mul(t47, t47);
    let t50 = circuit_add(t48, t49);
    let t51 = circuit_inverse(t50);
    let t52 = circuit_mul(t46, t51); // Fp2 Inv real part end
    let t53 = circuit_mul(t47, t51);
    let t54 = circuit_sub(in4, t53); // Fp2 Inv imag part end
    let t55 = circuit_mul(t44, t52); // Fp2 mul start
    let t56 = circuit_mul(t45, t54);
    let t57 = circuit_sub(t55, t56); // Fp2 mul real part end
    let t58 = circuit_mul(t44, t54);
    let t59 = circuit_mul(t45, t52);
    let t60 = circuit_add(t58, t59); // Fp2 mul imag part end
    let t61 = circuit_add(t57, t60);
    let t62 = circuit_sub(t57, t60);
    let t63 = circuit_mul(t61, t62);
    let t64 = circuit_mul(t57, t60);
    let t65 = circuit_add(t64, t64);
    let t66 = circuit_add(in19, in19); // Fp2 add coeff 0/1
    let t67 = circuit_add(in20, in20); // Fp2 add coeff 1/1
    let t68 = circuit_sub(t63, t66); // Fp2 sub coeff 0/1
    let t69 = circuit_sub(t65, t67); // Fp2 sub coeff 1/1
    let t70 = circuit_sub(in19, t68); // Fp2 sub coeff 0/1
    let t71 = circuit_sub(in20, t69); // Fp2 sub coeff 1/1
    let t72 = circuit_mul(t57, t70); // Fp2 mul start
    let t73 = circuit_mul(t60, t71);
    let t74 = circuit_sub(t72, t73); // Fp2 mul real part end
    let t75 = circuit_mul(t57, t71);
    let t76 = circuit_mul(t60, t70);
    let t77 = circuit_add(t75, t76); // Fp2 mul imag part end
    let t78 = circuit_sub(t74, in21); // Fp2 sub coeff 0/1
    let t79 = circuit_sub(t77, in22); // Fp2 sub coeff 1/1
    let t80 = circuit_mul(t57, in19); // Fp2 mul start
    let t81 = circuit_mul(t60, in20);
    let t82 = circuit_sub(t80, t81); // Fp2 mul real part end
    let t83 = circuit_mul(t57, in20);
    let t84 = circuit_mul(t60, in19);
    let t85 = circuit_add(t83, t84); // Fp2 mul imag part end
    let t86 = circuit_sub(t82, in21); // Fp2 sub coeff 0/1
    let t87 = circuit_sub(t85, in22); // Fp2 sub coeff 1/1
    let t88 = circuit_mul(in0, t60);
    let t89 = circuit_add(t57, t88);
    let t90 = circuit_mul(t89, in18); // eval bn line by xNegOverY
    let t91 = circuit_mul(in0, t87);
    let t92 = circuit_add(t86, t91);
    let t93 = circuit_mul(t92, in17); // eval bn line by yInv
    let t94 = circuit_mul(t60, in18); // eval bn line by xNegOverY
    let t95 = circuit_mul(t87, in17); // eval bn line by yInv
    let t96 = circuit_mul(t90, in24); // Eval sparse poly line_2p_1 step coeff_1 * z^1
    let t97 = circuit_add(in1, t96); // Eval sparse poly line_2p_1 step + coeff_1 * z^1
    let t98 = circuit_mul(t93, t1); // Eval sparse poly line_2p_1 step coeff_3 * z^3
    let t99 = circuit_add(t97, t98); // Eval sparse poly line_2p_1 step + coeff_3 * z^3
    let t100 = circuit_mul(t94, t3); // Eval sparse poly line_2p_1 step coeff_7 * z^7
    let t101 = circuit_add(t99, t100); // Eval sparse poly line_2p_1 step + coeff_7 * z^7
    let t102 = circuit_mul(t95, t4); // Eval sparse poly line_2p_1 step coeff_9 * z^9
    let t103 = circuit_add(t101, t102); // Eval sparse poly line_2p_1 step + coeff_9 * z^9
    let t104 = circuit_mul(t39, t103);
    let t105 = circuit_sub(t104, in23); // ((Π(i,k) (Pk(z)) - Ri(z))
    let t106 = circuit_mul(in26, in27);
    let t107 = circuit_add(t105, t106);

    let modulus = crate::definitions::get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (t68, t69, t78, t79, t107).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs
        .next_2(
            [0x6871ca8d3c208c16d87cfd3e, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0],
        ); // in0
    circuit_inputs = circuit_inputs.next_2([0x1, 0x0, 0x0, 0x0]); // in1
    circuit_inputs = circuit_inputs.next_2([0x3, 0x0, 0x0, 0x0]); // in2
    circuit_inputs = circuit_inputs.next_2([0x6, 0x0, 0x0, 0x0]); // in3
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in4
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(yInv_0); // in5
    circuit_inputs = circuit_inputs.next_2(xNegOverY_0); // in6
    circuit_inputs = circuit_inputs.next_2(G2_line_0.r0a0); // in7
    circuit_inputs = circuit_inputs.next_2(G2_line_0.r0a1); // in8
    circuit_inputs = circuit_inputs.next_2(G2_line_0.r1a0); // in9
    circuit_inputs = circuit_inputs.next_2(G2_line_0.r1a1); // in10
    circuit_inputs = circuit_inputs.next_2(yInv_1); // in11
    circuit_inputs = circuit_inputs.next_2(xNegOverY_1); // in12
    circuit_inputs = circuit_inputs.next_2(G2_line_1.r0a0); // in13
    circuit_inputs = circuit_inputs.next_2(G2_line_1.r0a1); // in14
    circuit_inputs = circuit_inputs.next_2(G2_line_1.r1a0); // in15
    circuit_inputs = circuit_inputs.next_2(G2_line_1.r1a1); // in16
    circuit_inputs = circuit_inputs.next_2(yInv_2); // in17
    circuit_inputs = circuit_inputs.next_2(xNegOverY_2); // in18
    circuit_inputs = circuit_inputs.next_2(Q_2.x0); // in19
    circuit_inputs = circuit_inputs.next_2(Q_2.x1); // in20
    circuit_inputs = circuit_inputs.next_2(Q_2.y0); // in21
    circuit_inputs = circuit_inputs.next_2(Q_2.y1); // in22
    circuit_inputs = circuit_inputs.next_2(R_i_of_z); // in23
    circuit_inputs = circuit_inputs.next_2(z); // in24
    circuit_inputs = circuit_inputs.next_2(c_inv_of_z); // in25
    circuit_inputs = circuit_inputs.next_2(c1); // in26
    circuit_inputs = circuit_inputs.next_2(previous_lhs); // in27

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let Q0: G2Point = G2Point {
        x0: outputs.get_output(t68),
        x1: outputs.get_output(t69),
        y0: outputs.get_output(t78),
        y1: outputs.get_output(t79),
    };
    let new_lhs: u384 = outputs.get_output(t107);
    return (Q0, new_lhs);
}
#[inline(always)]
pub fn run_BN254_MP_CHECK_PREPARE_PAIRS_1P_circuit(
    p_0: G1Point, Qy0_0: u384, Qy1_0: u384,
) -> (BNProcessedPair,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0

    // INPUT stack
    let (in1, in2, in3) = (CE::<CI<1>> {}, CE::<CI<2>> {}, CE::<CI<3>> {});
    let in4 = CE::<CI<4>> {};
    let t0 = circuit_inverse(in2);
    let t1 = circuit_mul(in1, t0);
    let t2 = circuit_sub(in0, t1);
    let t3 = circuit_sub(in0, in3);
    let t4 = circuit_sub(in0, in4);

    let modulus = crate::definitions::get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (t0, t2, t3, t4).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in0
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(p_0.x); // in1
    circuit_inputs = circuit_inputs.next_2(p_0.y); // in2
    circuit_inputs = circuit_inputs.next_2(Qy0_0); // in3
    circuit_inputs = circuit_inputs.next_2(Qy1_0); // in4

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let p_0: BNProcessedPair = BNProcessedPair {
        yInv: outputs.get_output(t0),
        xNegOverY: outputs.get_output(t2),
        QyNeg0: outputs.get_output(t3),
        QyNeg1: outputs.get_output(t4),
    };
    return (p_0,);
}
#[inline(always)]
pub fn run_BN254_MP_CHECK_PREPARE_PAIRS_2P_circuit(
    p_0: G1Point, Qy0_0: u384, Qy1_0: u384, p_1: G1Point, Qy0_1: u384, Qy1_1: u384,
) -> (BNProcessedPair, BNProcessedPair) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0

    // INPUT stack
    let (in1, in2, in3) = (CE::<CI<1>> {}, CE::<CI<2>> {}, CE::<CI<3>> {});
    let (in4, in5, in6) = (CE::<CI<4>> {}, CE::<CI<5>> {}, CE::<CI<6>> {});
    let (in7, in8) = (CE::<CI<7>> {}, CE::<CI<8>> {});
    let t0 = circuit_inverse(in2);
    let t1 = circuit_mul(in1, t0);
    let t2 = circuit_sub(in0, t1);
    let t3 = circuit_sub(in0, in3);
    let t4 = circuit_sub(in0, in4);
    let t5 = circuit_inverse(in6);
    let t6 = circuit_mul(in5, t5);
    let t7 = circuit_sub(in0, t6);
    let t8 = circuit_sub(in0, in7);
    let t9 = circuit_sub(in0, in8);

    let modulus = crate::definitions::get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (t0, t2, t3, t4, t5, t7, t8, t9).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in0
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(p_0.x); // in1
    circuit_inputs = circuit_inputs.next_2(p_0.y); // in2
    circuit_inputs = circuit_inputs.next_2(Qy0_0); // in3
    circuit_inputs = circuit_inputs.next_2(Qy1_0); // in4
    circuit_inputs = circuit_inputs.next_2(p_1.x); // in5
    circuit_inputs = circuit_inputs.next_2(p_1.y); // in6
    circuit_inputs = circuit_inputs.next_2(Qy0_1); // in7
    circuit_inputs = circuit_inputs.next_2(Qy1_1); // in8

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let p_0: BNProcessedPair = BNProcessedPair {
        yInv: outputs.get_output(t0),
        xNegOverY: outputs.get_output(t2),
        QyNeg0: outputs.get_output(t3),
        QyNeg1: outputs.get_output(t4),
    };
    let p_1: BNProcessedPair = BNProcessedPair {
        yInv: outputs.get_output(t5),
        xNegOverY: outputs.get_output(t7),
        QyNeg0: outputs.get_output(t8),
        QyNeg1: outputs.get_output(t9),
    };
    return (p_0, p_1);
}
#[inline(always)]
pub fn run_BN254_MP_CHECK_PREPARE_PAIRS_3P_circuit(
    p_0: G1Point,
    Qy0_0: u384,
    Qy1_0: u384,
    p_1: G1Point,
    Qy0_1: u384,
    Qy1_1: u384,
    p_2: G1Point,
    Qy0_2: u384,
    Qy1_2: u384,
) -> (BNProcessedPair, BNProcessedPair, BNProcessedPair) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0

    // INPUT stack
    let (in1, in2, in3) = (CE::<CI<1>> {}, CE::<CI<2>> {}, CE::<CI<3>> {});
    let (in4, in5, in6) = (CE::<CI<4>> {}, CE::<CI<5>> {}, CE::<CI<6>> {});
    let (in7, in8, in9) = (CE::<CI<7>> {}, CE::<CI<8>> {}, CE::<CI<9>> {});
    let (in10, in11, in12) = (CE::<CI<10>> {}, CE::<CI<11>> {}, CE::<CI<12>> {});
    let t0 = circuit_inverse(in2);
    let t1 = circuit_mul(in1, t0);
    let t2 = circuit_sub(in0, t1);
    let t3 = circuit_sub(in0, in3);
    let t4 = circuit_sub(in0, in4);
    let t5 = circuit_inverse(in6);
    let t6 = circuit_mul(in5, t5);
    let t7 = circuit_sub(in0, t6);
    let t8 = circuit_sub(in0, in7);
    let t9 = circuit_sub(in0, in8);
    let t10 = circuit_inverse(in10);
    let t11 = circuit_mul(in9, t10);
    let t12 = circuit_sub(in0, t11);
    let t13 = circuit_sub(in0, in11);
    let t14 = circuit_sub(in0, in12);

    let modulus = crate::definitions::get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (t0, t2, t3, t4, t5, t7, t8, t9, t10, t12, t13, t14).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in0
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(p_0.x); // in1
    circuit_inputs = circuit_inputs.next_2(p_0.y); // in2
    circuit_inputs = circuit_inputs.next_2(Qy0_0); // in3
    circuit_inputs = circuit_inputs.next_2(Qy1_0); // in4
    circuit_inputs = circuit_inputs.next_2(p_1.x); // in5
    circuit_inputs = circuit_inputs.next_2(p_1.y); // in6
    circuit_inputs = circuit_inputs.next_2(Qy0_1); // in7
    circuit_inputs = circuit_inputs.next_2(Qy1_1); // in8
    circuit_inputs = circuit_inputs.next_2(p_2.x); // in9
    circuit_inputs = circuit_inputs.next_2(p_2.y); // in10
    circuit_inputs = circuit_inputs.next_2(Qy0_2); // in11
    circuit_inputs = circuit_inputs.next_2(Qy1_2); // in12

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let p_0: BNProcessedPair = BNProcessedPair {
        yInv: outputs.get_output(t0),
        xNegOverY: outputs.get_output(t2),
        QyNeg0: outputs.get_output(t3),
        QyNeg1: outputs.get_output(t4),
    };
    let p_1: BNProcessedPair = BNProcessedPair {
        yInv: outputs.get_output(t5),
        xNegOverY: outputs.get_output(t7),
        QyNeg0: outputs.get_output(t8),
        QyNeg1: outputs.get_output(t9),
    };
    let p_2: BNProcessedPair = BNProcessedPair {
        yInv: outputs.get_output(t10),
        xNegOverY: outputs.get_output(t12),
        QyNeg0: outputs.get_output(t13),
        QyNeg1: outputs.get_output(t14),
    };
    return (p_0, p_1, p_2);
}
