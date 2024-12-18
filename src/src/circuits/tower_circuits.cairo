use core::circuit::{
    RangeCheck96, AddMod, MulMod, u384, u96, circuit_add, circuit_sub, circuit_mul, circuit_inverse,
    EvalCircuitResult, EvalCircuitTrait, CircuitOutputsTrait, CircuitModulus, AddInputResultTrait,
    CircuitInputs, CircuitDefinition, CircuitData, CircuitInputAccumulator,
};
use garaga::core::circuit::AddInputResultTrait2;
use core::circuit::CircuitElement as CE;
use core::circuit::CircuitInput as CI;
use garaga::definitions::{
    get_a, get_b, get_modulus, get_g, get_min_one, G1Point, G2Point, E12D, u288, E12DMulQuotient,
    G1G2Pair, BNProcessedPair, BLSProcessedPair, MillerLoopResultScalingFactor, G2Line, E12T,
    get_BLS12_381_modulus, get_BN254_modulus,
};
use garaga::ec_ops::{SlopeInterceptOutput, FunctionFeltEvaluations, FunctionFelt};
use core::option::Option;
#[inline(always)]
pub fn run_BLS12_381_E12T_CYCLOTOMIC_SQUARE_circuit(M: E12T) -> (E12T,) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let t0 = circuit_add(in8, in9);
    let t1 = circuit_sub(in8, in9);
    let t2 = circuit_mul(t0, t1);
    let t3 = circuit_mul(in8, in9);
    let t4 = circuit_add(t3, t3);
    let t5 = circuit_add(in0, in1);
    let t6 = circuit_sub(in0, in1);
    let t7 = circuit_mul(t5, t6);
    let t8 = circuit_mul(in0, in1);
    let t9 = circuit_add(t8, t8);
    let t10 = circuit_add(in8, in0); // Fp2 add coeff 0/1
    let t11 = circuit_add(in9, in1); // Fp2 add coeff 1/1
    let t12 = circuit_add(t10, t11);
    let t13 = circuit_sub(t10, t11);
    let t14 = circuit_mul(t12, t13);
    let t15 = circuit_mul(t10, t11);
    let t16 = circuit_add(t15, t15);
    let t17 = circuit_sub(t14, t2); // Fp2 sub coeff 0/1
    let t18 = circuit_sub(t16, t4); // Fp2 sub coeff 1/1
    let t19 = circuit_sub(t17, t7); // Fp2 sub coeff 0/1
    let t20 = circuit_sub(t18, t9); // Fp2 sub coeff 1/1
    let t21 = circuit_add(in4, in5);
    let t22 = circuit_sub(in4, in5);
    let t23 = circuit_mul(t21, t22);
    let t24 = circuit_mul(in4, in5);
    let t25 = circuit_add(t24, t24);
    let t26 = circuit_add(in6, in7);
    let t27 = circuit_sub(in6, in7);
    let t28 = circuit_mul(t26, t27);
    let t29 = circuit_mul(in6, in7);
    let t30 = circuit_add(t29, t29);
    let t31 = circuit_add(in4, in6); // Fp2 add coeff 0/1
    let t32 = circuit_add(in5, in7); // Fp2 add coeff 1/1
    let t33 = circuit_add(t31, t32);
    let t34 = circuit_sub(t31, t32);
    let t35 = circuit_mul(t33, t34);
    let t36 = circuit_mul(t31, t32);
    let t37 = circuit_add(t36, t36);
    let t38 = circuit_sub(t35, t23); // Fp2 sub coeff 0/1
    let t39 = circuit_sub(t37, t25); // Fp2 sub coeff 1/1
    let t40 = circuit_sub(t38, t28); // Fp2 sub coeff 0/1
    let t41 = circuit_sub(t39, t30); // Fp2 sub coeff 1/1
    let t42 = circuit_add(in10, in11);
    let t43 = circuit_sub(in10, in11);
    let t44 = circuit_mul(t42, t43);
    let t45 = circuit_mul(in10, in11);
    let t46 = circuit_add(t45, t45);
    let t47 = circuit_add(in2, in3);
    let t48 = circuit_sub(in2, in3);
    let t49 = circuit_mul(t47, t48);
    let t50 = circuit_mul(in2, in3);
    let t51 = circuit_add(t50, t50);
    let t52 = circuit_add(in10, in2); // Fp2 add coeff 0/1
    let t53 = circuit_add(in11, in3); // Fp2 add coeff 1/1
    let t54 = circuit_add(t52, t53);
    let t55 = circuit_sub(t52, t53);
    let t56 = circuit_mul(t54, t55);
    let t57 = circuit_mul(t52, t53);
    let t58 = circuit_add(t57, t57);
    let t59 = circuit_sub(t56, t44); // Fp2 sub coeff 0/1
    let t60 = circuit_sub(t58, t46); // Fp2 sub coeff 1/1
    let t61 = circuit_sub(t59, t49); // Fp2 sub coeff 0/1
    let t62 = circuit_sub(t60, t51); // Fp2 sub coeff 1/1
    let t63 = circuit_add(t61, t62);
    let t64 = circuit_add(t63, t63);
    let t65 = circuit_sub(t61, t62);
    let t66 = circuit_sub(t64, t61);
    let t67 = circuit_sub(t66, t62);
    let t68 = circuit_add(t2, t4);
    let t69 = circuit_add(t68, t68);
    let t70 = circuit_sub(t2, t4);
    let t71 = circuit_sub(t69, t2);
    let t72 = circuit_sub(t71, t4);
    let t73 = circuit_add(t70, t7); // Fp2 add coeff 0/1
    let t74 = circuit_add(t72, t9); // Fp2 add coeff 1/1
    let t75 = circuit_add(t23, t25);
    let t76 = circuit_add(t75, t75);
    let t77 = circuit_sub(t23, t25);
    let t78 = circuit_sub(t76, t23);
    let t79 = circuit_sub(t78, t25);
    let t80 = circuit_add(t77, t28); // Fp2 add coeff 0/1
    let t81 = circuit_add(t79, t30); // Fp2 add coeff 1/1
    let t82 = circuit_add(t44, t46);
    let t83 = circuit_add(t82, t82);
    let t84 = circuit_sub(t44, t46);
    let t85 = circuit_sub(t83, t44);
    let t86 = circuit_sub(t85, t46);
    let t87 = circuit_add(t84, t49); // Fp2 add coeff 0/1
    let t88 = circuit_add(t86, t51); // Fp2 add coeff 1/1
    let t89 = circuit_sub(t73, in0); // Fp2 sub coeff 0/1
    let t90 = circuit_sub(t74, in1); // Fp2 sub coeff 1/1
    let t91 = circuit_add(t89, t89); // Fp2 add coeff 0/1
    let t92 = circuit_add(t90, t90); // Fp2 add coeff 1/1
    let t93 = circuit_add(t91, t73); // Fp2 add coeff 0/1
    let t94 = circuit_add(t92, t74); // Fp2 add coeff 1/1
    let t95 = circuit_sub(t80, in2); // Fp2 sub coeff 0/1
    let t96 = circuit_sub(t81, in3); // Fp2 sub coeff 1/1
    let t97 = circuit_add(t95, t95); // Fp2 add coeff 0/1
    let t98 = circuit_add(t96, t96); // Fp2 add coeff 1/1
    let t99 = circuit_add(t97, t80); // Fp2 add coeff 0/1
    let t100 = circuit_add(t98, t81); // Fp2 add coeff 1/1
    let t101 = circuit_sub(t87, in4); // Fp2 sub coeff 0/1
    let t102 = circuit_sub(t88, in5); // Fp2 sub coeff 1/1
    let t103 = circuit_add(t101, t101); // Fp2 add coeff 0/1
    let t104 = circuit_add(t102, t102); // Fp2 add coeff 1/1
    let t105 = circuit_add(t103, t87); // Fp2 add coeff 0/1
    let t106 = circuit_add(t104, t88); // Fp2 add coeff 1/1
    let t107 = circuit_add(t65, in6); // Fp2 add coeff 0/1
    let t108 = circuit_add(t67, in7); // Fp2 add coeff 1/1
    let t109 = circuit_add(t107, t107); // Fp2 add coeff 0/1
    let t110 = circuit_add(t108, t108); // Fp2 add coeff 1/1
    let t111 = circuit_add(t109, t65); // Fp2 add coeff 0/1
    let t112 = circuit_add(t110, t67); // Fp2 add coeff 1/1
    let t113 = circuit_add(t19, in8); // Fp2 add coeff 0/1
    let t114 = circuit_add(t20, in9); // Fp2 add coeff 1/1
    let t115 = circuit_add(t113, t113); // Fp2 add coeff 0/1
    let t116 = circuit_add(t114, t114); // Fp2 add coeff 1/1
    let t117 = circuit_add(t115, t19); // Fp2 add coeff 0/1
    let t118 = circuit_add(t116, t20); // Fp2 add coeff 1/1
    let t119 = circuit_add(t40, in10); // Fp2 add coeff 0/1
    let t120 = circuit_add(t41, in11); // Fp2 add coeff 1/1
    let t121 = circuit_add(t119, t119); // Fp2 add coeff 0/1
    let t122 = circuit_add(t120, t120); // Fp2 add coeff 1/1
    let t123 = circuit_add(t121, t40); // Fp2 add coeff 0/1
    let t124 = circuit_add(t122, t41); // Fp2 add coeff 1/1

    let modulus = get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (t93, t94, t99, t100, t105, t106, t111, t112, t117, t118, t123, t124)
        .new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(M.c0b0a0); // in0
    circuit_inputs = circuit_inputs.next_2(M.c0b0a1); // in1
    circuit_inputs = circuit_inputs.next_2(M.c0b1a0); // in2
    circuit_inputs = circuit_inputs.next_2(M.c0b1a1); // in3
    circuit_inputs = circuit_inputs.next_2(M.c0b2a0); // in4
    circuit_inputs = circuit_inputs.next_2(M.c0b2a1); // in5
    circuit_inputs = circuit_inputs.next_2(M.c1b0a0); // in6
    circuit_inputs = circuit_inputs.next_2(M.c1b0a1); // in7
    circuit_inputs = circuit_inputs.next_2(M.c1b1a0); // in8
    circuit_inputs = circuit_inputs.next_2(M.c1b1a1); // in9
    circuit_inputs = circuit_inputs.next_2(M.c1b2a0); // in10
    circuit_inputs = circuit_inputs.next_2(M.c1b2a1); // in11

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: E12T = E12T {
        c0b0a0: outputs.get_output(t93),
        c0b0a1: outputs.get_output(t94),
        c0b1a0: outputs.get_output(t99),
        c0b1a1: outputs.get_output(t100),
        c0b2a0: outputs.get_output(t105),
        c0b2a1: outputs.get_output(t106),
        c1b0a0: outputs.get_output(t111),
        c1b0a1: outputs.get_output(t112),
        c1b1a0: outputs.get_output(t117),
        c1b1a1: outputs.get_output(t118),
        c1b2a0: outputs.get_output(t123),
        c1b2a1: outputs.get_output(t124),
    };
    return (res,);
}
#[inline(always)]
pub fn run_BLS12_381_E12T_CYCLO_SQUARE_COMPRESSED_circuit(
    xc0b1a0: u384,
    xc0b1a1: u384,
    xc0b2a0: u384,
    xc0b2a1: u384,
    xc1b0a0: u384,
    xc1b0a1: u384,
    xc1b2a0: u384,
    xc1b2a1: u384,
) -> (u384, u384, u384, u384, u384, u384, u384, u384) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7) = (CE::<CI<6>> {}, CE::<CI<7>> {});
    let t0 = circuit_add(in0, in1);
    let t1 = circuit_sub(in0, in1);
    let t2 = circuit_mul(t0, t1);
    let t3 = circuit_mul(in0, in1);
    let t4 = circuit_add(t3, t3);
    let t5 = circuit_add(in6, in7);
    let t6 = circuit_sub(in6, in7);
    let t7 = circuit_mul(t5, t6);
    let t8 = circuit_mul(in6, in7);
    let t9 = circuit_add(t8, t8);
    let t10 = circuit_add(in0, in6); // Fp2 add coeff 0/1
    let t11 = circuit_add(in1, in7); // Fp2 add coeff 1/1
    let t12 = circuit_add(t10, t11);
    let t13 = circuit_sub(t10, t11);
    let t14 = circuit_mul(t12, t13);
    let t15 = circuit_mul(t10, t11);
    let t16 = circuit_add(t15, t15);
    let t17 = circuit_add(t2, t7); // Fp2 add coeff 0/1
    let t18 = circuit_add(t4, t9); // Fp2 add coeff 1/1
    let t19 = circuit_sub(t14, t17); // Fp2 sub coeff 0/1
    let t20 = circuit_sub(t16, t18); // Fp2 sub coeff 1/1
    let t21 = circuit_add(in4, in2); // Fp2 add coeff 0/1
    let t22 = circuit_add(in5, in3); // Fp2 add coeff 1/1
    let t23 = circuit_add(t21, t22);
    let t24 = circuit_sub(t21, t22);
    let t25 = circuit_mul(t23, t24);
    let t26 = circuit_mul(t21, t22);
    let t27 = circuit_add(t26, t26);
    let t28 = circuit_add(in4, in5);
    let t29 = circuit_sub(in4, in5);
    let t30 = circuit_mul(t28, t29);
    let t31 = circuit_mul(in4, in5);
    let t32 = circuit_add(t31, t31);
    let t33 = circuit_add(t19, t20);
    let t34 = circuit_add(t33, t33);
    let t35 = circuit_sub(t19, t20);
    let t36 = circuit_sub(t34, t19);
    let t37 = circuit_sub(t36, t20);
    let t38 = circuit_add(t35, in4); // Fp2 add coeff 0/1
    let t39 = circuit_add(t37, in5); // Fp2 add coeff 1/1
    let t40 = circuit_add(t38, t38); // Fp2 add coeff 0/1
    let t41 = circuit_add(t39, t39); // Fp2 add coeff 1/1
    let t42 = circuit_add(t40, t35); // Fp2 add coeff 0/1
    let t43 = circuit_add(t41, t37); // Fp2 add coeff 1/1
    let t44 = circuit_add(t7, t9);
    let t45 = circuit_add(t44, t44);
    let t46 = circuit_sub(t7, t9);
    let t47 = circuit_sub(t45, t7);
    let t48 = circuit_sub(t47, t9);
    let t49 = circuit_add(t2, t46); // Fp2 add coeff 0/1
    let t50 = circuit_add(t4, t48); // Fp2 add coeff 1/1
    let t51 = circuit_sub(t49, in2); // Fp2 sub coeff 0/1
    let t52 = circuit_sub(t50, in3); // Fp2 sub coeff 1/1
    let t53 = circuit_add(in2, in3);
    let t54 = circuit_sub(in2, in3);
    let t55 = circuit_mul(t53, t54);
    let t56 = circuit_mul(in2, in3);
    let t57 = circuit_add(t56, t56);
    let t58 = circuit_add(t51, t51); // Fp2 add coeff 0/1
    let t59 = circuit_add(t52, t52); // Fp2 add coeff 1/1
    let t60 = circuit_add(t58, t49); // Fp2 add coeff 0/1
    let t61 = circuit_add(t59, t50); // Fp2 add coeff 1/1
    let t62 = circuit_add(t55, t57);
    let t63 = circuit_add(t62, t62);
    let t64 = circuit_sub(t55, t57);
    let t65 = circuit_sub(t63, t55);
    let t66 = circuit_sub(t65, t57);
    let t67 = circuit_add(t30, t64); // Fp2 add coeff 0/1
    let t68 = circuit_add(t32, t66); // Fp2 add coeff 1/1
    let t69 = circuit_sub(t67, in0); // Fp2 sub coeff 0/1
    let t70 = circuit_sub(t68, in1); // Fp2 sub coeff 1/1
    let t71 = circuit_add(t69, t69); // Fp2 add coeff 0/1
    let t72 = circuit_add(t70, t70); // Fp2 add coeff 1/1
    let t73 = circuit_add(t71, t67); // Fp2 add coeff 0/1
    let t74 = circuit_add(t72, t68); // Fp2 add coeff 1/1
    let t75 = circuit_add(t30, t55); // Fp2 add coeff 0/1
    let t76 = circuit_add(t32, t57); // Fp2 add coeff 1/1
    let t77 = circuit_sub(t25, t75); // Fp2 sub coeff 0/1
    let t78 = circuit_sub(t27, t76); // Fp2 sub coeff 1/1
    let t79 = circuit_add(t77, in6); // Fp2 add coeff 0/1
    let t80 = circuit_add(t78, in7); // Fp2 add coeff 1/1
    let t81 = circuit_add(t79, t79); // Fp2 add coeff 0/1
    let t82 = circuit_add(t80, t80); // Fp2 add coeff 1/1
    let t83 = circuit_add(t77, t81); // Fp2 add coeff 0/1
    let t84 = circuit_add(t78, t82); // Fp2 add coeff 1/1

    let modulus = get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (t73, t74, t60, t61, t42, t43, t83, t84).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(xc0b1a0); // in0
    circuit_inputs = circuit_inputs.next_2(xc0b1a1); // in1
    circuit_inputs = circuit_inputs.next_2(xc0b2a0); // in2
    circuit_inputs = circuit_inputs.next_2(xc0b2a1); // in3
    circuit_inputs = circuit_inputs.next_2(xc1b0a0); // in4
    circuit_inputs = circuit_inputs.next_2(xc1b0a1); // in5
    circuit_inputs = circuit_inputs.next_2(xc1b2a0); // in6
    circuit_inputs = circuit_inputs.next_2(xc1b2a1); // in7

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let xc0b1a0: u384 = outputs.get_output(t73);
    let xc0b1a1: u384 = outputs.get_output(t74);
    let xc0b2a0: u384 = outputs.get_output(t60);
    let xc0b2a1: u384 = outputs.get_output(t61);
    let xc1b0a0: u384 = outputs.get_output(t42);
    let xc1b0a1: u384 = outputs.get_output(t43);
    let xc1b2a0: u384 = outputs.get_output(t83);
    let xc1b2a1: u384 = outputs.get_output(t84);
    return (xc0b1a0, xc0b1a1, xc0b2a0, xc0b2a1, xc1b0a0, xc1b0a1, xc1b2a0, xc1b2a1);
}
#[inline(always)]
pub fn run_BLS12_381_E12T_DECOMP_KARABINA_II_circuit(
    t0a0: u384,
    t0a1: u384,
    t1a0: u384,
    t1a1: u384,
    xc0b1a0: u384,
    xc0b1a1: u384,
    xc0b2a0: u384,
    xc0b2a1: u384,
    xc1b0a0: u384,
    xc1b0a1: u384,
    xc1b2a0: u384,
    xc1b2a1: u384,
) -> (u384, u384, u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0
    let in1 = CE::<CI<1>> {}; // 0x1

    // INPUT stack
    let (in2, in3, in4) = (CE::<CI<2>> {}, CE::<CI<3>> {}, CE::<CI<4>> {});
    let (in5, in6, in7) = (CE::<CI<5>> {}, CE::<CI<6>> {}, CE::<CI<7>> {});
    let (in8, in9, in10) = (CE::<CI<8>> {}, CE::<CI<9>> {}, CE::<CI<10>> {});
    let (in11, in12, in13) = (CE::<CI<11>> {}, CE::<CI<12>> {}, CE::<CI<13>> {});
    let t0 = circuit_mul(in4, in4); // Fp2 Inv start
    let t1 = circuit_mul(in5, in5);
    let t2 = circuit_add(t0, t1);
    let t3 = circuit_inverse(t2);
    let t4 = circuit_mul(in4, t3); // Fp2 Inv real part end
    let t5 = circuit_mul(in5, t3);
    let t6 = circuit_sub(in0, t5); // Fp2 Inv imag part end
    let t7 = circuit_mul(in2, t4); // Fp2 mul start
    let t8 = circuit_mul(in3, t6);
    let t9 = circuit_sub(t7, t8); // Fp2 mul real part end
    let t10 = circuit_mul(in2, t6);
    let t11 = circuit_mul(in3, t4);
    let t12 = circuit_add(t10, t11); // Fp2 mul imag part end
    let t13 = circuit_mul(in8, in6); // Fp2 mul start
    let t14 = circuit_mul(in9, in7);
    let t15 = circuit_sub(t13, t14); // Fp2 mul real part end
    let t16 = circuit_mul(in8, in7);
    let t17 = circuit_mul(in9, in6);
    let t18 = circuit_add(t16, t17); // Fp2 mul imag part end
    let t19 = circuit_add(t9, t12);
    let t20 = circuit_sub(t9, t12);
    let t21 = circuit_mul(t19, t20);
    let t22 = circuit_mul(t9, t12);
    let t23 = circuit_add(t22, t22);
    let t24 = circuit_sub(t21, t15); // Fp2 sub coeff 0/1
    let t25 = circuit_sub(t23, t18); // Fp2 sub coeff 1/1
    let t26 = circuit_add(t24, t24); // Fp2 add coeff 0/1
    let t27 = circuit_add(t25, t25); // Fp2 add coeff 1/1
    let t28 = circuit_sub(t26, t15); // Fp2 sub coeff 0/1
    let t29 = circuit_sub(t27, t18); // Fp2 sub coeff 1/1
    let t30 = circuit_mul(in10, in12); // Fp2 mul start
    let t31 = circuit_mul(in11, in13);
    let t32 = circuit_sub(t30, t31); // Fp2 mul real part end
    let t33 = circuit_mul(in10, in13);
    let t34 = circuit_mul(in11, in12);
    let t35 = circuit_add(t33, t34); // Fp2 mul imag part end
    let t36 = circuit_add(t28, t32); // Fp2 add coeff 0/1
    let t37 = circuit_add(t29, t35); // Fp2 add coeff 1/1
    let t38 = circuit_add(t36, t37);
    let t39 = circuit_add(t38, t38);
    let t40 = circuit_sub(t36, t37);
    let t41 = circuit_sub(t39, t36);
    let t42 = circuit_sub(t41, t37);
    let t43 = circuit_add(t40, in1);

    let modulus = get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (t43, t42, t9, t12).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs.next_2([0x1, 0x0, 0x0, 0x0]); // in1
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(t0a0); // in2
    circuit_inputs = circuit_inputs.next_2(t0a1); // in3
    circuit_inputs = circuit_inputs.next_2(t1a0); // in4
    circuit_inputs = circuit_inputs.next_2(t1a1); // in5
    circuit_inputs = circuit_inputs.next_2(xc0b1a0); // in6
    circuit_inputs = circuit_inputs.next_2(xc0b1a1); // in7
    circuit_inputs = circuit_inputs.next_2(xc0b2a0); // in8
    circuit_inputs = circuit_inputs.next_2(xc0b2a1); // in9
    circuit_inputs = circuit_inputs.next_2(xc1b0a0); // in10
    circuit_inputs = circuit_inputs.next_2(xc1b0a1); // in11
    circuit_inputs = circuit_inputs.next_2(xc1b2a0); // in12
    circuit_inputs = circuit_inputs.next_2(xc1b2a1); // in13

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let zc0b0a0: u384 = outputs.get_output(t43);
    let zc0b0a1: u384 = outputs.get_output(t42);
    let zc1b1a0: u384 = outputs.get_output(t9);
    let zc1b1a1: u384 = outputs.get_output(t12);
    return (zc0b0a0, zc0b0a1, zc1b1a0, zc1b1a1);
}
#[inline(always)]
pub fn run_BLS12_381_E12T_DECOMP_KARABINA_I_NZ_circuit(
    xc0b1a0: u384,
    xc0b1a1: u384,
    xc0b2a0: u384,
    xc0b2a1: u384,
    xc1b0a0: u384,
    xc1b0a1: u384,
    xc1b2a0: u384,
    xc1b2a1: u384,
) -> (u384, u384, u384, u384) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7) = (CE::<CI<6>> {}, CE::<CI<7>> {});
    let t0 = circuit_add(in0, in1);
    let t1 = circuit_sub(in0, in1);
    let t2 = circuit_mul(t0, t1);
    let t3 = circuit_mul(in0, in1);
    let t4 = circuit_add(t3, t3);
    let t5 = circuit_sub(t2, in2); // Fp2 sub coeff 0/1
    let t6 = circuit_sub(t4, in3); // Fp2 sub coeff 1/1
    let t7 = circuit_add(t5, t5); // Fp2 add coeff 0/1
    let t8 = circuit_add(t6, t6); // Fp2 add coeff 1/1
    let t9 = circuit_add(t7, t2); // Fp2 add coeff 0/1
    let t10 = circuit_add(t8, t4); // Fp2 add coeff 1/1
    let t11 = circuit_add(in6, in7);
    let t12 = circuit_sub(in6, in7);
    let t13 = circuit_mul(t11, t12);
    let t14 = circuit_mul(in6, in7);
    let t15 = circuit_add(t14, t14);
    let t16 = circuit_add(t13, t15);
    let t17 = circuit_add(t16, t16);
    let t18 = circuit_sub(t13, t15);
    let t19 = circuit_sub(t17, t13);
    let t20 = circuit_sub(t19, t15);
    let t21 = circuit_add(t18, t9); // Fp2 add coeff 0/1
    let t22 = circuit_add(t20, t10); // Fp2 add coeff 1/1
    let t23 = circuit_add(in4, in4); // Fp2 add coeff 0/1
    let t24 = circuit_add(in5, in5); // Fp2 add coeff 1/1
    let t25 = circuit_add(t23, t23); // Fp2 add coeff 0/1
    let t26 = circuit_add(t24, t24); // Fp2 add coeff 1/1

    let modulus = get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (t21, t22, t25, t26).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(xc0b1a0); // in0
    circuit_inputs = circuit_inputs.next_2(xc0b1a1); // in1
    circuit_inputs = circuit_inputs.next_2(xc0b2a0); // in2
    circuit_inputs = circuit_inputs.next_2(xc0b2a1); // in3
    circuit_inputs = circuit_inputs.next_2(xc1b0a0); // in4
    circuit_inputs = circuit_inputs.next_2(xc1b0a1); // in5
    circuit_inputs = circuit_inputs.next_2(xc1b2a0); // in6
    circuit_inputs = circuit_inputs.next_2(xc1b2a1); // in7

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let t0a0: u384 = outputs.get_output(t21);
    let t0a1: u384 = outputs.get_output(t22);
    let t1a0: u384 = outputs.get_output(t25);
    let t1a1: u384 = outputs.get_output(t26);
    return (t0a0, t0a1, t1a0, t1a1);
}
#[inline(always)]
pub fn run_BLS12_381_E12T_DECOMP_KARABINA_I_Z_circuit(
    xc0b1a0: u384, xc0b1a1: u384, xc1b2a0: u384, xc1b2a1: u384,
) -> (u384, u384) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let in3 = CE::<CI<3>> {};
    let t0 = circuit_mul(in0, in2); // Fp2 mul start
    let t1 = circuit_mul(in1, in3);
    let t2 = circuit_sub(t0, t1); // Fp2 mul real part end
    let t3 = circuit_mul(in0, in3);
    let t4 = circuit_mul(in1, in2);
    let t5 = circuit_add(t3, t4); // Fp2 mul imag part end
    let t6 = circuit_add(t2, t2); // Fp2 add coeff 0/1
    let t7 = circuit_add(t5, t5); // Fp2 add coeff 1/1

    let modulus = get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (t6, t7).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(xc0b1a0); // in0
    circuit_inputs = circuit_inputs.next_2(xc0b1a1); // in1
    circuit_inputs = circuit_inputs.next_2(xc1b2a0); // in2
    circuit_inputs = circuit_inputs.next_2(xc1b2a1); // in3

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res0: u384 = outputs.get_output(t6);
    let res1: u384 = outputs.get_output(t7);
    return (res0, res1);
}
#[inline(always)]
pub fn run_BLS12_381_E12T_FROBENIUS_CUBE_circuit(M: E12T) -> (E12T,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0
    let in1 = CE::<CI<1>> {}; // 0x1
    let in2 = CE::<CI<2>> {}; // -0x1 % p
    let in3 = CE::<
        CI<3>,
    > {}; // 0x135203e60180a68ee2e9c448d77a2cd91c3dedd930b1cf60ef396489f61eb45e304466cf3e67fa0af1ee7b04121bdea2
    let in4 = CE::<
        CI<4>,
    > {}; // 0x6af0e0437ff400b6831e36d6bd17ffe48395dabc2d3435e77f76e17009241c5ee67992f72ec05f4c81084fbede3cc09

    // INPUT stack
    let (in5, in6, in7) = (CE::<CI<5>> {}, CE::<CI<6>> {}, CE::<CI<7>> {});
    let (in8, in9, in10) = (CE::<CI<8>> {}, CE::<CI<9>> {}, CE::<CI<10>> {});
    let (in11, in12, in13) = (CE::<CI<11>> {}, CE::<CI<12>> {}, CE::<CI<13>> {});
    let (in14, in15, in16) = (CE::<CI<14>> {}, CE::<CI<15>> {}, CE::<CI<16>> {});
    let t0 = circuit_sub(in0, in6);
    let t1 = circuit_add(in5, in0);
    let t2 = circuit_sub(in0, in8);
    let t3 = circuit_sub(in0, in10);
    let t4 = circuit_sub(in0, in12);
    let t5 = circuit_sub(in0, in14);
    let t6 = circuit_sub(in0, in16);
    let t7 = circuit_mul(in0, in7); // Fp2 mul start
    let t8 = circuit_mul(in1, t2);
    let t9 = circuit_sub(t7, t8); // Fp2 mul real part end
    let t10 = circuit_mul(in0, t2);
    let t11 = circuit_mul(in1, in7);
    let t12 = circuit_add(t10, t11); // Fp2 mul imag part end
    let t13 = circuit_mul(in2, in9);
    let t14 = circuit_mul(in2, t3);
    let t15 = circuit_mul(in3, in11); // Fp2 mul start
    let t16 = circuit_mul(in4, t4);
    let t17 = circuit_sub(t15, t16); // Fp2 mul real part end
    let t18 = circuit_mul(in3, t4);
    let t19 = circuit_mul(in4, in11);
    let t20 = circuit_add(t18, t19); // Fp2 mul imag part end
    let t21 = circuit_mul(in3, in13); // Fp2 mul start
    let t22 = circuit_mul(in3, t5);
    let t23 = circuit_sub(t21, t22); // Fp2 mul real part end
    let t24 = circuit_mul(in3, t5);
    let t25 = circuit_mul(in3, in13);
    let t26 = circuit_add(t24, t25); // Fp2 mul imag part end
    let t27 = circuit_mul(in4, in15); // Fp2 mul start
    let t28 = circuit_mul(in3, t6);
    let t29 = circuit_sub(t27, t28); // Fp2 mul real part end
    let t30 = circuit_mul(in4, t6);
    let t31 = circuit_mul(in3, in15);
    let t32 = circuit_add(t30, t31); // Fp2 mul imag part end

    let modulus = get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (t1, t0, t9, t12, t13, t14, t17, t20, t23, t26, t29, t32).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs.next_2([0x1, 0x0, 0x0, 0x0]); // in1
    circuit_inputs = circuit_inputs
        .next_2(
            [
                0xb153ffffb9feffffffffaaaa, 0x6730d2a0f6b0f6241eabfffe, 0x434bacd764774b84f38512bf,
                0x1a0111ea397fe69a4b1ba7b6,
            ],
        ); // in2
    circuit_inputs = circuit_inputs
        .next_2(
            [
                0x3e67fa0af1ee7b04121bdea2, 0xef396489f61eb45e304466cf, 0xd77a2cd91c3dedd930b1cf60,
                0x135203e60180a68ee2e9c448,
            ],
        ); // in3
    circuit_inputs = circuit_inputs
        .next_2(
            [
                0x72ec05f4c81084fbede3cc09, 0x77f76e17009241c5ee67992f, 0x6bd17ffe48395dabc2d3435e,
                0x6af0e0437ff400b6831e36d,
            ],
        ); // in4
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(M.c0b0a0); // in5
    circuit_inputs = circuit_inputs.next_2(M.c0b0a1); // in6
    circuit_inputs = circuit_inputs.next_2(M.c0b1a0); // in7
    circuit_inputs = circuit_inputs.next_2(M.c0b1a1); // in8
    circuit_inputs = circuit_inputs.next_2(M.c0b2a0); // in9
    circuit_inputs = circuit_inputs.next_2(M.c0b2a1); // in10
    circuit_inputs = circuit_inputs.next_2(M.c1b0a0); // in11
    circuit_inputs = circuit_inputs.next_2(M.c1b0a1); // in12
    circuit_inputs = circuit_inputs.next_2(M.c1b1a0); // in13
    circuit_inputs = circuit_inputs.next_2(M.c1b1a1); // in14
    circuit_inputs = circuit_inputs.next_2(M.c1b2a0); // in15
    circuit_inputs = circuit_inputs.next_2(M.c1b2a1); // in16

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: E12T = E12T {
        c0b0a0: outputs.get_output(t1),
        c0b0a1: outputs.get_output(t0),
        c0b1a0: outputs.get_output(t9),
        c0b1a1: outputs.get_output(t12),
        c0b2a0: outputs.get_output(t13),
        c0b2a1: outputs.get_output(t14),
        c1b0a0: outputs.get_output(t17),
        c1b0a1: outputs.get_output(t20),
        c1b1a0: outputs.get_output(t23),
        c1b1a1: outputs.get_output(t26),
        c1b2a0: outputs.get_output(t29),
        c1b2a1: outputs.get_output(t32),
    };
    return (res,);
}
#[inline(always)]
pub fn run_BLS12_381_E12T_FROBENIUS_SQUARE_circuit(M: E12T) -> (E12T,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0
    let in1 = CE::<
        CI<1>,
    > {}; // 0x5f19672fdf76ce51ba69c6076a0f77eaddb3a93be6f89688de17d813620a00022e01fffffffefffe
    let in2 = CE::<
        CI<2>,
    > {}; // 0x1a0111ea397fe699ec02408663d4de85aa0d857d89759ad4897d29650fb85f9b409427eb4f49fffd8bfd00000000aaac
    let in3 = CE::<
        CI<3>,
    > {}; // 0x5f19672fdf76ce51ba69c6076a0f77eaddb3a93be6f89688de17d813620a00022e01fffffffeffff
    let in4 = CE::<CI<4>> {}; // -0x1 % p
    let in5 = CE::<
        CI<5>,
    > {}; // 0x1a0111ea397fe699ec02408663d4de85aa0d857d89759ad4897d29650fb85f9b409427eb4f49fffd8bfd00000000aaad

    // INPUT stack
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13, in14) = (CE::<CI<12>> {}, CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16, in17) = (CE::<CI<15>> {}, CE::<CI<16>> {}, CE::<CI<17>> {});
    let t0 = circuit_add(in6, in0);
    let t1 = circuit_add(in7, in0);
    let t2 = circuit_mul(in1, in8);
    let t3 = circuit_mul(in1, in9);
    let t4 = circuit_mul(in2, in10);
    let t5 = circuit_mul(in2, in11);
    let t6 = circuit_mul(in3, in12);
    let t7 = circuit_mul(in3, in13);
    let t8 = circuit_mul(in4, in14);
    let t9 = circuit_mul(in4, in15);
    let t10 = circuit_mul(in5, in16);
    let t11 = circuit_mul(in5, in17);

    let modulus = get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs
        .next_2(
            [
                0x620a00022e01fffffffefffe, 0xddb3a93be6f89688de17d813, 0xdf76ce51ba69c6076a0f77ea,
                0x5f19672f,
            ],
        ); // in1
    circuit_inputs = circuit_inputs
        .next_2(
            [
                0x4f49fffd8bfd00000000aaac, 0x897d29650fb85f9b409427eb, 0x63d4de85aa0d857d89759ad4,
                0x1a0111ea397fe699ec024086,
            ],
        ); // in2
    circuit_inputs = circuit_inputs
        .next_2(
            [
                0x620a00022e01fffffffeffff, 0xddb3a93be6f89688de17d813, 0xdf76ce51ba69c6076a0f77ea,
                0x5f19672f,
            ],
        ); // in3
    circuit_inputs = circuit_inputs
        .next_2(
            [
                0xb153ffffb9feffffffffaaaa, 0x6730d2a0f6b0f6241eabfffe, 0x434bacd764774b84f38512bf,
                0x1a0111ea397fe69a4b1ba7b6,
            ],
        ); // in4
    circuit_inputs = circuit_inputs
        .next_2(
            [
                0x4f49fffd8bfd00000000aaad, 0x897d29650fb85f9b409427eb, 0x63d4de85aa0d857d89759ad4,
                0x1a0111ea397fe699ec024086,
            ],
        ); // in5
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(M.c0b0a0); // in6
    circuit_inputs = circuit_inputs.next_2(M.c0b0a1); // in7
    circuit_inputs = circuit_inputs.next_2(M.c0b1a0); // in8
    circuit_inputs = circuit_inputs.next_2(M.c0b1a1); // in9
    circuit_inputs = circuit_inputs.next_2(M.c0b2a0); // in10
    circuit_inputs = circuit_inputs.next_2(M.c0b2a1); // in11
    circuit_inputs = circuit_inputs.next_2(M.c1b0a0); // in12
    circuit_inputs = circuit_inputs.next_2(M.c1b0a1); // in13
    circuit_inputs = circuit_inputs.next_2(M.c1b1a0); // in14
    circuit_inputs = circuit_inputs.next_2(M.c1b1a1); // in15
    circuit_inputs = circuit_inputs.next_2(M.c1b2a0); // in16
    circuit_inputs = circuit_inputs.next_2(M.c1b2a1); // in17

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: E12T = E12T {
        c0b0a0: outputs.get_output(t0),
        c0b0a1: outputs.get_output(t1),
        c0b1a0: outputs.get_output(t2),
        c0b1a1: outputs.get_output(t3),
        c0b2a0: outputs.get_output(t4),
        c0b2a1: outputs.get_output(t5),
        c1b0a0: outputs.get_output(t6),
        c1b0a1: outputs.get_output(t7),
        c1b1a0: outputs.get_output(t8),
        c1b1a1: outputs.get_output(t9),
        c1b2a0: outputs.get_output(t10),
        c1b2a1: outputs.get_output(t11),
    };
    return (res,);
}
#[inline(always)]
pub fn run_BLS12_381_E12T_FROBENIUS_circuit(M: E12T) -> (E12T,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0
    let in1 = CE::<
        CI<1>,
    > {}; // 0x1a0111ea397fe699ec02408663d4de85aa0d857d89759ad4897d29650fb85f9b409427eb4f49fffd8bfd00000000aaac
    let in2 = CE::<
        CI<2>,
    > {}; // 0x1a0111ea397fe699ec02408663d4de85aa0d857d89759ad4897d29650fb85f9b409427eb4f49fffd8bfd00000000aaad
    let in3 = CE::<
        CI<3>,
    > {}; // 0x1904d3bf02bb0667c231beb4202c0d1f0fd603fd3cbd5f4f7b2443d784bab9c4f67ea53d63e7813d8d0775ed92235fb8
    let in4 = CE::<
        CI<4>,
    > {}; // 0xfc3e2b36c4e03288e9e902231f9fb854a14787b6c7b36fec0c8ec971f63c5f282d5ac14d6c7ec22cf78a126ddc4af3
    let in5 = CE::<
        CI<5>,
    > {}; // 0x6af0e0437ff400b6831e36d6bd17ffe48395dabc2d3435e77f76e17009241c5ee67992f72ec05f4c81084fbede3cc09
    let in6 = CE::<
        CI<6>,
    > {}; // 0x5b2cfd9013a5fd8df47fa6b48b1e045f39816240c0b8fee8beadf4d8e9c0566c63a3e6e257f87329b18fae980078116
    let in7 = CE::<
        CI<7>,
    > {}; // 0x144e4211384586c16bd3ad4afa99cc9170df3560e77982d0db45f3536814f0bd5871c1908bd478cd1ee605167ff82995

    // INPUT stack
    let (in8, in9, in10) = (CE::<CI<8>> {}, CE::<CI<9>> {}, CE::<CI<10>> {});
    let (in11, in12, in13) = (CE::<CI<11>> {}, CE::<CI<12>> {}, CE::<CI<13>> {});
    let (in14, in15, in16) = (CE::<CI<14>> {}, CE::<CI<15>> {}, CE::<CI<16>> {});
    let (in17, in18, in19) = (CE::<CI<17>> {}, CE::<CI<18>> {}, CE::<CI<19>> {});
    let t0 = circuit_sub(in0, in9);
    let t1 = circuit_add(in8, in0);
    let t2 = circuit_sub(in0, in11);
    let t3 = circuit_sub(in0, in13);
    let t4 = circuit_sub(in0, in15);
    let t5 = circuit_sub(in0, in17);
    let t6 = circuit_sub(in0, in19);
    let t7 = circuit_mul(in0, in10); // Fp2 mul start
    let t8 = circuit_mul(in1, t2);
    let t9 = circuit_sub(t7, t8); // Fp2 mul real part end
    let t10 = circuit_mul(in0, t2);
    let t11 = circuit_mul(in1, in10);
    let t12 = circuit_add(t10, t11); // Fp2 mul imag part end
    let t13 = circuit_mul(in2, in12);
    let t14 = circuit_mul(in2, t3);
    let t15 = circuit_mul(in3, in14); // Fp2 mul start
    let t16 = circuit_mul(in4, t4);
    let t17 = circuit_sub(t15, t16); // Fp2 mul real part end
    let t18 = circuit_mul(in3, t4);
    let t19 = circuit_mul(in4, in14);
    let t20 = circuit_add(t18, t19); // Fp2 mul imag part end
    let t21 = circuit_mul(in5, in16); // Fp2 mul start
    let t22 = circuit_mul(in5, t5);
    let t23 = circuit_sub(t21, t22); // Fp2 mul real part end
    let t24 = circuit_mul(in5, t5);
    let t25 = circuit_mul(in5, in16);
    let t26 = circuit_add(t24, t25); // Fp2 mul imag part end
    let t27 = circuit_mul(in6, in18); // Fp2 mul start
    let t28 = circuit_mul(in7, t6);
    let t29 = circuit_sub(t27, t28); // Fp2 mul real part end
    let t30 = circuit_mul(in6, t6);
    let t31 = circuit_mul(in7, in18);
    let t32 = circuit_add(t30, t31); // Fp2 mul imag part end

    let modulus = get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (t1, t0, t9, t12, t13, t14, t17, t20, t23, t26, t29, t32).new_inputs();
    // Prefill constants:

    circuit_inputs = circuit_inputs
        .next_span(E12T_FROBENIUS_BLS12_381_CONSTANTS.span()); // in0 - in7

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(M.c0b0a0); // in8
    circuit_inputs = circuit_inputs.next_2(M.c0b0a1); // in9
    circuit_inputs = circuit_inputs.next_2(M.c0b1a0); // in10
    circuit_inputs = circuit_inputs.next_2(M.c0b1a1); // in11
    circuit_inputs = circuit_inputs.next_2(M.c0b2a0); // in12
    circuit_inputs = circuit_inputs.next_2(M.c0b2a1); // in13
    circuit_inputs = circuit_inputs.next_2(M.c1b0a0); // in14
    circuit_inputs = circuit_inputs.next_2(M.c1b0a1); // in15
    circuit_inputs = circuit_inputs.next_2(M.c1b1a0); // in16
    circuit_inputs = circuit_inputs.next_2(M.c1b1a1); // in17
    circuit_inputs = circuit_inputs.next_2(M.c1b2a0); // in18
    circuit_inputs = circuit_inputs.next_2(M.c1b2a1); // in19

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: E12T = E12T {
        c0b0a0: outputs.get_output(t1),
        c0b0a1: outputs.get_output(t0),
        c0b1a0: outputs.get_output(t9),
        c0b1a1: outputs.get_output(t12),
        c0b2a0: outputs.get_output(t13),
        c0b2a1: outputs.get_output(t14),
        c1b0a0: outputs.get_output(t17),
        c1b0a1: outputs.get_output(t20),
        c1b1a0: outputs.get_output(t23),
        c1b1a1: outputs.get_output(t26),
        c1b2a0: outputs.get_output(t29),
        c1b2a1: outputs.get_output(t32),
    };
    return (res,);
}
const E12T_FROBENIUS_BLS12_381_CONSTANTS: [u384; 8] = [
    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 {
        limb0: 0x4f49fffd8bfd00000000aaac,
        limb1: 0x897d29650fb85f9b409427eb,
        limb2: 0x63d4de85aa0d857d89759ad4,
        limb3: 0x1a0111ea397fe699ec024086,
    },
    u384 {
        limb0: 0x4f49fffd8bfd00000000aaad,
        limb1: 0x897d29650fb85f9b409427eb,
        limb2: 0x63d4de85aa0d857d89759ad4,
        limb3: 0x1a0111ea397fe699ec024086,
    },
    u384 {
        limb0: 0x63e7813d8d0775ed92235fb8,
        limb1: 0x7b2443d784bab9c4f67ea53d,
        limb2: 0x202c0d1f0fd603fd3cbd5f4f,
        limb3: 0x1904d3bf02bb0667c231beb4,
    },
    u384 {
        limb0: 0x4d6c7ec22cf78a126ddc4af3,
        limb1: 0xec0c8ec971f63c5f282d5ac1,
        limb2: 0x231f9fb854a14787b6c7b36f,
        limb3: 0xfc3e2b36c4e03288e9e902,
    },
    u384 {
        limb0: 0x72ec05f4c81084fbede3cc09,
        limb1: 0x77f76e17009241c5ee67992f,
        limb2: 0x6bd17ffe48395dabc2d3435e,
        limb3: 0x6af0e0437ff400b6831e36d,
    },
    u384 {
        limb0: 0x257f87329b18fae980078116,
        limb1: 0x8beadf4d8e9c0566c63a3e6e,
        limb2: 0x48b1e045f39816240c0b8fee,
        limb3: 0x5b2cfd9013a5fd8df47fa6b,
    },
    u384 {
        limb0: 0x8bd478cd1ee605167ff82995,
        limb1: 0xdb45f3536814f0bd5871c190,
        limb2: 0xfa99cc9170df3560e77982d0,
        limb3: 0x144e4211384586c16bd3ad4a,
    },
];
#[inline(always)]
pub fn run_BLS12_381_E12T_INVERSE_circuit(M: E12T) -> (E12T,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0

    // INPUT stack
    let (in1, in2, in3) = (CE::<CI<1>> {}, CE::<CI<2>> {}, CE::<CI<3>> {});
    let (in4, in5, in6) = (CE::<CI<4>> {}, CE::<CI<5>> {}, CE::<CI<6>> {});
    let (in7, in8, in9) = (CE::<CI<7>> {}, CE::<CI<8>> {}, CE::<CI<9>> {});
    let (in10, in11, in12) = (CE::<CI<10>> {}, CE::<CI<11>> {}, CE::<CI<12>> {});
    let t0 = circuit_mul(in1, in3); // Fp2 mul start
    let t1 = circuit_mul(in2, in4);
    let t2 = circuit_sub(t0, t1); // Fp2 mul real part end
    let t3 = circuit_mul(in1, in4);
    let t4 = circuit_mul(in2, in3);
    let t5 = circuit_add(t3, t4); // Fp2 mul imag part end
    let t6 = circuit_add(t2, t2); // Fp2 add coeff 0/1
    let t7 = circuit_add(t5, t5); // Fp2 add coeff 1/1
    let t8 = circuit_add(in5, in6);
    let t9 = circuit_sub(in5, in6);
    let t10 = circuit_mul(t8, t9);
    let t11 = circuit_mul(in5, in6);
    let t12 = circuit_add(t11, t11);
    let t13 = circuit_add(t10, t12);
    let t14 = circuit_add(t13, t13);
    let t15 = circuit_sub(t10, t12);
    let t16 = circuit_sub(t14, t10);
    let t17 = circuit_sub(t16, t12);
    let t18 = circuit_add(t15, t6); // Fp2 add coeff 0/1
    let t19 = circuit_add(t17, t7); // Fp2 add coeff 1/1
    let t20 = circuit_sub(t6, t10); // Fp2 sub coeff 0/1
    let t21 = circuit_sub(t7, t12); // Fp2 sub coeff 1/1
    let t22 = circuit_add(in1, in2);
    let t23 = circuit_sub(in1, in2);
    let t24 = circuit_mul(t22, t23);
    let t25 = circuit_mul(in1, in2);
    let t26 = circuit_add(t25, t25);
    let t27 = circuit_sub(in1, in3); // Fp2 sub coeff 0/1
    let t28 = circuit_sub(in2, in4); // Fp2 sub coeff 1/1
    let t29 = circuit_add(t27, in5); // Fp2 add coeff 0/1
    let t30 = circuit_add(t28, in6); // Fp2 add coeff 1/1
    let t31 = circuit_mul(in3, in5); // Fp2 mul start
    let t32 = circuit_mul(in4, in6);
    let t33 = circuit_sub(t31, t32); // Fp2 mul real part end
    let t34 = circuit_mul(in3, in6);
    let t35 = circuit_mul(in4, in5);
    let t36 = circuit_add(t34, t35); // Fp2 mul imag part end
    let t37 = circuit_add(t33, t33); // Fp2 add coeff 0/1
    let t38 = circuit_add(t36, t36); // Fp2 add coeff 1/1
    let t39 = circuit_add(t29, t30);
    let t40 = circuit_sub(t29, t30);
    let t41 = circuit_mul(t39, t40);
    let t42 = circuit_mul(t29, t30);
    let t43 = circuit_add(t42, t42);
    let t44 = circuit_add(t37, t38);
    let t45 = circuit_add(t44, t44);
    let t46 = circuit_sub(t37, t38);
    let t47 = circuit_sub(t45, t37);
    let t48 = circuit_sub(t47, t38);
    let t49 = circuit_add(t46, t24); // Fp2 add coeff 0/1
    let t50 = circuit_add(t48, t26); // Fp2 add coeff 1/1
    let t51 = circuit_add(t20, t41); // Fp2 add coeff 0/1
    let t52 = circuit_add(t21, t43); // Fp2 add coeff 1/1
    let t53 = circuit_add(t51, t37); // Fp2 add coeff 0/1
    let t54 = circuit_add(t52, t38); // Fp2 add coeff 1/1
    let t55 = circuit_sub(t53, t24); // Fp2 sub coeff 0/1
    let t56 = circuit_sub(t54, t26); // Fp2 sub coeff 1/1
    let t57 = circuit_mul(in7, in9); // Fp2 mul start
    let t58 = circuit_mul(in8, in10);
    let t59 = circuit_sub(t57, t58); // Fp2 mul real part end
    let t60 = circuit_mul(in7, in10);
    let t61 = circuit_mul(in8, in9);
    let t62 = circuit_add(t60, t61); // Fp2 mul imag part end
    let t63 = circuit_add(t59, t59); // Fp2 add coeff 0/1
    let t64 = circuit_add(t62, t62); // Fp2 add coeff 1/1
    let t65 = circuit_add(in11, in12);
    let t66 = circuit_sub(in11, in12);
    let t67 = circuit_mul(t65, t66);
    let t68 = circuit_mul(in11, in12);
    let t69 = circuit_add(t68, t68);
    let t70 = circuit_add(t67, t69);
    let t71 = circuit_add(t70, t70);
    let t72 = circuit_sub(t67, t69);
    let t73 = circuit_sub(t71, t67);
    let t74 = circuit_sub(t73, t69);
    let t75 = circuit_add(t72, t63); // Fp2 add coeff 0/1
    let t76 = circuit_add(t74, t64); // Fp2 add coeff 1/1
    let t77 = circuit_sub(t63, t67); // Fp2 sub coeff 0/1
    let t78 = circuit_sub(t64, t69); // Fp2 sub coeff 1/1
    let t79 = circuit_add(in7, in8);
    let t80 = circuit_sub(in7, in8);
    let t81 = circuit_mul(t79, t80);
    let t82 = circuit_mul(in7, in8);
    let t83 = circuit_add(t82, t82);
    let t84 = circuit_sub(in7, in9); // Fp2 sub coeff 0/1
    let t85 = circuit_sub(in8, in10); // Fp2 sub coeff 1/1
    let t86 = circuit_add(t84, in11); // Fp2 add coeff 0/1
    let t87 = circuit_add(t85, in12); // Fp2 add coeff 1/1
    let t88 = circuit_mul(in9, in11); // Fp2 mul start
    let t89 = circuit_mul(in10, in12);
    let t90 = circuit_sub(t88, t89); // Fp2 mul real part end
    let t91 = circuit_mul(in9, in12);
    let t92 = circuit_mul(in10, in11);
    let t93 = circuit_add(t91, t92); // Fp2 mul imag part end
    let t94 = circuit_add(t90, t90); // Fp2 add coeff 0/1
    let t95 = circuit_add(t93, t93); // Fp2 add coeff 1/1
    let t96 = circuit_add(t86, t87);
    let t97 = circuit_sub(t86, t87);
    let t98 = circuit_mul(t96, t97);
    let t99 = circuit_mul(t86, t87);
    let t100 = circuit_add(t99, t99);
    let t101 = circuit_add(t94, t95);
    let t102 = circuit_add(t101, t101);
    let t103 = circuit_sub(t94, t95);
    let t104 = circuit_sub(t102, t94);
    let t105 = circuit_sub(t104, t95);
    let t106 = circuit_add(t103, t81); // Fp2 add coeff 0/1
    let t107 = circuit_add(t105, t83); // Fp2 add coeff 1/1
    let t108 = circuit_add(t77, t98); // Fp2 add coeff 0/1
    let t109 = circuit_add(t78, t100); // Fp2 add coeff 1/1
    let t110 = circuit_add(t108, t94); // Fp2 add coeff 0/1
    let t111 = circuit_add(t109, t95); // Fp2 add coeff 1/1
    let t112 = circuit_sub(t110, t81); // Fp2 sub coeff 0/1
    let t113 = circuit_sub(t111, t83); // Fp2 sub coeff 1/1
    let t114 = circuit_add(t112, t113);
    let t115 = circuit_add(t114, t114);
    let t116 = circuit_sub(t112, t113);
    let t117 = circuit_sub(t115, t112);
    let t118 = circuit_sub(t117, t113);
    let t119 = circuit_sub(t49, t116); // Fp6 sub coeff 0/5
    let t120 = circuit_sub(t50, t118); // Fp6 sub coeff 1/5
    let t121 = circuit_sub(t18, t106); // Fp6 sub coeff 2/5
    let t122 = circuit_sub(t19, t107); // Fp6 sub coeff 3/5
    let t123 = circuit_sub(t55, t75); // Fp6 sub coeff 4/5
    let t124 = circuit_sub(t56, t76); // Fp6 sub coeff 5/5
    let t125 = circuit_add(t119, t120);
    let t126 = circuit_sub(t119, t120);
    let t127 = circuit_mul(t125, t126);
    let t128 = circuit_mul(t119, t120);
    let t129 = circuit_add(t128, t128);
    let t130 = circuit_add(t121, t122);
    let t131 = circuit_sub(t121, t122);
    let t132 = circuit_mul(t130, t131);
    let t133 = circuit_mul(t121, t122);
    let t134 = circuit_add(t133, t133);
    let t135 = circuit_add(t123, t124);
    let t136 = circuit_sub(t123, t124);
    let t137 = circuit_mul(t135, t136);
    let t138 = circuit_mul(t123, t124);
    let t139 = circuit_add(t138, t138);
    let t140 = circuit_mul(t119, t121); // Fp2 mul start
    let t141 = circuit_mul(t120, t122);
    let t142 = circuit_sub(t140, t141); // Fp2 mul real part end
    let t143 = circuit_mul(t119, t122);
    let t144 = circuit_mul(t120, t121);
    let t145 = circuit_add(t143, t144); // Fp2 mul imag part end
    let t146 = circuit_mul(t119, t123); // Fp2 mul start
    let t147 = circuit_mul(t120, t124);
    let t148 = circuit_sub(t146, t147); // Fp2 mul real part end
    let t149 = circuit_mul(t119, t124);
    let t150 = circuit_mul(t120, t123);
    let t151 = circuit_add(t149, t150); // Fp2 mul imag part end
    let t152 = circuit_mul(t121, t123); // Fp2 mul start
    let t153 = circuit_mul(t122, t124);
    let t154 = circuit_sub(t152, t153); // Fp2 mul real part end
    let t155 = circuit_mul(t121, t124);
    let t156 = circuit_mul(t122, t123);
    let t157 = circuit_add(t155, t156); // Fp2 mul imag part end
    let t158 = circuit_add(t154, t157);
    let t159 = circuit_add(t158, t158);
    let t160 = circuit_sub(t154, t157);
    let t161 = circuit_sub(t159, t154);
    let t162 = circuit_sub(t161, t157);
    let t163 = circuit_sub(in0, t160); // Fp2 neg coeff 0/1
    let t164 = circuit_sub(in0, t162); // Fp2 neg coeff 1/1
    let t165 = circuit_add(t163, t127); // Fp2 add coeff 0/1
    let t166 = circuit_add(t164, t129); // Fp2 add coeff 1/1
    let t167 = circuit_add(t137, t139);
    let t168 = circuit_add(t167, t167);
    let t169 = circuit_sub(t137, t139);
    let t170 = circuit_sub(t168, t137);
    let t171 = circuit_sub(t170, t139);
    let t172 = circuit_sub(t169, t142); // Fp2 sub coeff 0/1
    let t173 = circuit_sub(t171, t145); // Fp2 sub coeff 1/1
    let t174 = circuit_sub(t132, t148); // Fp2 sub coeff 0/1
    let t175 = circuit_sub(t134, t151); // Fp2 sub coeff 1/1
    let t176 = circuit_mul(t119, t165); // Fp2 mul start
    let t177 = circuit_mul(t120, t166);
    let t178 = circuit_sub(t176, t177); // Fp2 mul real part end
    let t179 = circuit_mul(t119, t166);
    let t180 = circuit_mul(t120, t165);
    let t181 = circuit_add(t179, t180); // Fp2 mul imag part end
    let t182 = circuit_mul(t123, t172); // Fp2 mul start
    let t183 = circuit_mul(t124, t173);
    let t184 = circuit_sub(t182, t183); // Fp2 mul real part end
    let t185 = circuit_mul(t123, t173);
    let t186 = circuit_mul(t124, t172);
    let t187 = circuit_add(t185, t186); // Fp2 mul imag part end
    let t188 = circuit_mul(t121, t174); // Fp2 mul start
    let t189 = circuit_mul(t122, t175);
    let t190 = circuit_sub(t188, t189); // Fp2 mul real part end
    let t191 = circuit_mul(t121, t175);
    let t192 = circuit_mul(t122, t174);
    let t193 = circuit_add(t191, t192); // Fp2 mul imag part end
    let t194 = circuit_add(t184, t190); // Fp2 add coeff 0/1
    let t195 = circuit_add(t187, t193); // Fp2 add coeff 1/1
    let t196 = circuit_add(t194, t195);
    let t197 = circuit_add(t196, t196);
    let t198 = circuit_sub(t194, t195);
    let t199 = circuit_sub(t197, t194);
    let t200 = circuit_sub(t199, t195);
    let t201 = circuit_add(t178, t198); // Fp2 add coeff 0/1
    let t202 = circuit_add(t181, t200); // Fp2 add coeff 1/1
    let t203 = circuit_mul(t201, t201); // Fp2 Inv start
    let t204 = circuit_mul(t202, t202);
    let t205 = circuit_add(t203, t204);
    let t206 = circuit_inverse(t205);
    let t207 = circuit_mul(t201, t206); // Fp2 Inv real part end
    let t208 = circuit_mul(t202, t206);
    let t209 = circuit_sub(in0, t208); // Fp2 Inv imag part end
    let t210 = circuit_mul(t165, t207); // Fp2 mul start
    let t211 = circuit_mul(t166, t209);
    let t212 = circuit_sub(t210, t211); // Fp2 mul real part end
    let t213 = circuit_mul(t165, t209);
    let t214 = circuit_mul(t166, t207);
    let t215 = circuit_add(t213, t214); // Fp2 mul imag part end
    let t216 = circuit_mul(t172, t207); // Fp2 mul start
    let t217 = circuit_mul(t173, t209);
    let t218 = circuit_sub(t216, t217); // Fp2 mul real part end
    let t219 = circuit_mul(t172, t209);
    let t220 = circuit_mul(t173, t207);
    let t221 = circuit_add(t219, t220); // Fp2 mul imag part end
    let t222 = circuit_mul(t174, t207); // Fp2 mul start
    let t223 = circuit_mul(t175, t209);
    let t224 = circuit_sub(t222, t223); // Fp2 mul real part end
    let t225 = circuit_mul(t174, t209);
    let t226 = circuit_mul(t175, t207);
    let t227 = circuit_add(t225, t226); // Fp2 mul imag part end
    let t228 = circuit_mul(in1, t212); // Fp2 mul start
    let t229 = circuit_mul(in2, t215);
    let t230 = circuit_sub(t228, t229); // Fp2 mul real part end
    let t231 = circuit_mul(in1, t215);
    let t232 = circuit_mul(in2, t212);
    let t233 = circuit_add(t231, t232); // Fp2 mul imag part end
    let t234 = circuit_mul(in3, t218); // Fp2 mul start
    let t235 = circuit_mul(in4, t221);
    let t236 = circuit_sub(t234, t235); // Fp2 mul real part end
    let t237 = circuit_mul(in3, t221);
    let t238 = circuit_mul(in4, t218);
    let t239 = circuit_add(t237, t238); // Fp2 mul imag part end
    let t240 = circuit_mul(in5, t224); // Fp2 mul start
    let t241 = circuit_mul(in6, t227);
    let t242 = circuit_sub(t240, t241); // Fp2 mul real part end
    let t243 = circuit_mul(in5, t227);
    let t244 = circuit_mul(in6, t224);
    let t245 = circuit_add(t243, t244); // Fp2 mul imag part end
    let t246 = circuit_add(in3, in5); // Fp2 add coeff 0/1
    let t247 = circuit_add(in4, in6); // Fp2 add coeff 1/1
    let t248 = circuit_add(t218, t224); // Fp2 add coeff 0/1
    let t249 = circuit_add(t221, t227); // Fp2 add coeff 1/1
    let t250 = circuit_mul(t246, t248); // Fp2 mul start
    let t251 = circuit_mul(t247, t249);
    let t252 = circuit_sub(t250, t251); // Fp2 mul real part end
    let t253 = circuit_mul(t246, t249);
    let t254 = circuit_mul(t247, t248);
    let t255 = circuit_add(t253, t254); // Fp2 mul imag part end
    let t256 = circuit_sub(t252, t236); // Fp2 sub coeff 0/1
    let t257 = circuit_sub(t255, t239); // Fp2 sub coeff 1/1
    let t258 = circuit_sub(t256, t242); // Fp2 sub coeff 0/1
    let t259 = circuit_sub(t257, t245); // Fp2 sub coeff 1/1
    let t260 = circuit_add(t258, t259);
    let t261 = circuit_add(t260, t260);
    let t262 = circuit_sub(t258, t259);
    let t263 = circuit_sub(t261, t258);
    let t264 = circuit_sub(t263, t259);
    let t265 = circuit_add(t262, t230); // Fp2 add coeff 0/1
    let t266 = circuit_add(t264, t233); // Fp2 add coeff 1/1
    let t267 = circuit_add(in1, in3); // Fp2 add coeff 0/1
    let t268 = circuit_add(in2, in4); // Fp2 add coeff 1/1
    let t269 = circuit_add(t212, t218); // Fp2 add coeff 0/1
    let t270 = circuit_add(t215, t221); // Fp2 add coeff 1/1
    let t271 = circuit_mul(t267, t269); // Fp2 mul start
    let t272 = circuit_mul(t268, t270);
    let t273 = circuit_sub(t271, t272); // Fp2 mul real part end
    let t274 = circuit_mul(t267, t270);
    let t275 = circuit_mul(t268, t269);
    let t276 = circuit_add(t274, t275); // Fp2 mul imag part end
    let t277 = circuit_sub(t273, t230); // Fp2 sub coeff 0/1
    let t278 = circuit_sub(t276, t233); // Fp2 sub coeff 1/1
    let t279 = circuit_sub(t277, t236); // Fp2 sub coeff 0/1
    let t280 = circuit_sub(t278, t239); // Fp2 sub coeff 1/1
    let t281 = circuit_add(t242, t245);
    let t282 = circuit_add(t281, t281);
    let t283 = circuit_sub(t242, t245);
    let t284 = circuit_sub(t282, t242);
    let t285 = circuit_sub(t284, t245);
    let t286 = circuit_add(t279, t283); // Fp2 add coeff 0/1
    let t287 = circuit_add(t280, t285); // Fp2 add coeff 1/1
    let t288 = circuit_add(in1, in5); // Fp2 add coeff 0/1
    let t289 = circuit_add(in2, in6); // Fp2 add coeff 1/1
    let t290 = circuit_add(t212, t224); // Fp2 add coeff 0/1
    let t291 = circuit_add(t215, t227); // Fp2 add coeff 1/1
    let t292 = circuit_mul(t290, t288); // Fp2 mul start
    let t293 = circuit_mul(t291, t289);
    let t294 = circuit_sub(t292, t293); // Fp2 mul real part end
    let t295 = circuit_mul(t290, t289);
    let t296 = circuit_mul(t291, t288);
    let t297 = circuit_add(t295, t296); // Fp2 mul imag part end
    let t298 = circuit_sub(t294, t230); // Fp2 sub coeff 0/1
    let t299 = circuit_sub(t297, t233); // Fp2 sub coeff 1/1
    let t300 = circuit_sub(t298, t242); // Fp2 sub coeff 0/1
    let t301 = circuit_sub(t299, t245); // Fp2 sub coeff 1/1
    let t302 = circuit_add(t300, t236); // Fp2 add coeff 0/1
    let t303 = circuit_add(t301, t239); // Fp2 add coeff 1/1
    let t304 = circuit_mul(in7, t212); // Fp2 mul start
    let t305 = circuit_mul(in8, t215);
    let t306 = circuit_sub(t304, t305); // Fp2 mul real part end
    let t307 = circuit_mul(in7, t215);
    let t308 = circuit_mul(in8, t212);
    let t309 = circuit_add(t307, t308); // Fp2 mul imag part end
    let t310 = circuit_mul(in9, t218); // Fp2 mul start
    let t311 = circuit_mul(in10, t221);
    let t312 = circuit_sub(t310, t311); // Fp2 mul real part end
    let t313 = circuit_mul(in9, t221);
    let t314 = circuit_mul(in10, t218);
    let t315 = circuit_add(t313, t314); // Fp2 mul imag part end
    let t316 = circuit_mul(in11, t224); // Fp2 mul start
    let t317 = circuit_mul(in12, t227);
    let t318 = circuit_sub(t316, t317); // Fp2 mul real part end
    let t319 = circuit_mul(in11, t227);
    let t320 = circuit_mul(in12, t224);
    let t321 = circuit_add(t319, t320); // Fp2 mul imag part end
    let t322 = circuit_add(in9, in11); // Fp2 add coeff 0/1
    let t323 = circuit_add(in10, in12); // Fp2 add coeff 1/1
    let t324 = circuit_add(t218, t224); // Fp2 add coeff 0/1
    let t325 = circuit_add(t221, t227); // Fp2 add coeff 1/1
    let t326 = circuit_mul(t322, t324); // Fp2 mul start
    let t327 = circuit_mul(t323, t325);
    let t328 = circuit_sub(t326, t327); // Fp2 mul real part end
    let t329 = circuit_mul(t322, t325);
    let t330 = circuit_mul(t323, t324);
    let t331 = circuit_add(t329, t330); // Fp2 mul imag part end
    let t332 = circuit_sub(t328, t312); // Fp2 sub coeff 0/1
    let t333 = circuit_sub(t331, t315); // Fp2 sub coeff 1/1
    let t334 = circuit_sub(t332, t318); // Fp2 sub coeff 0/1
    let t335 = circuit_sub(t333, t321); // Fp2 sub coeff 1/1
    let t336 = circuit_add(t334, t335);
    let t337 = circuit_add(t336, t336);
    let t338 = circuit_sub(t334, t335);
    let t339 = circuit_sub(t337, t334);
    let t340 = circuit_sub(t339, t335);
    let t341 = circuit_add(t338, t306); // Fp2 add coeff 0/1
    let t342 = circuit_add(t340, t309); // Fp2 add coeff 1/1
    let t343 = circuit_add(in7, in9); // Fp2 add coeff 0/1
    let t344 = circuit_add(in8, in10); // Fp2 add coeff 1/1
    let t345 = circuit_add(t212, t218); // Fp2 add coeff 0/1
    let t346 = circuit_add(t215, t221); // Fp2 add coeff 1/1
    let t347 = circuit_mul(t343, t345); // Fp2 mul start
    let t348 = circuit_mul(t344, t346);
    let t349 = circuit_sub(t347, t348); // Fp2 mul real part end
    let t350 = circuit_mul(t343, t346);
    let t351 = circuit_mul(t344, t345);
    let t352 = circuit_add(t350, t351); // Fp2 mul imag part end
    let t353 = circuit_sub(t349, t306); // Fp2 sub coeff 0/1
    let t354 = circuit_sub(t352, t309); // Fp2 sub coeff 1/1
    let t355 = circuit_sub(t353, t312); // Fp2 sub coeff 0/1
    let t356 = circuit_sub(t354, t315); // Fp2 sub coeff 1/1
    let t357 = circuit_add(t318, t321);
    let t358 = circuit_add(t357, t357);
    let t359 = circuit_sub(t318, t321);
    let t360 = circuit_sub(t358, t318);
    let t361 = circuit_sub(t360, t321);
    let t362 = circuit_add(t355, t359); // Fp2 add coeff 0/1
    let t363 = circuit_add(t356, t361); // Fp2 add coeff 1/1
    let t364 = circuit_add(in7, in11); // Fp2 add coeff 0/1
    let t365 = circuit_add(in8, in12); // Fp2 add coeff 1/1
    let t366 = circuit_add(t212, t224); // Fp2 add coeff 0/1
    let t367 = circuit_add(t215, t227); // Fp2 add coeff 1/1
    let t368 = circuit_mul(t366, t364); // Fp2 mul start
    let t369 = circuit_mul(t367, t365);
    let t370 = circuit_sub(t368, t369); // Fp2 mul real part end
    let t371 = circuit_mul(t366, t365);
    let t372 = circuit_mul(t367, t364);
    let t373 = circuit_add(t371, t372); // Fp2 mul imag part end
    let t374 = circuit_sub(t370, t306); // Fp2 sub coeff 0/1
    let t375 = circuit_sub(t373, t309); // Fp2 sub coeff 1/1
    let t376 = circuit_sub(t374, t318); // Fp2 sub coeff 0/1
    let t377 = circuit_sub(t375, t321); // Fp2 sub coeff 1/1
    let t378 = circuit_add(t376, t312); // Fp2 add coeff 0/1
    let t379 = circuit_add(t377, t315); // Fp2 add coeff 1/1
    let t380 = circuit_sub(in0, t341); // Fp6 neg coeff 0/5
    let t381 = circuit_sub(in0, t342); // Fp6 neg coeff 1/5
    let t382 = circuit_sub(in0, t362); // Fp6 neg coeff 2/5
    let t383 = circuit_sub(in0, t363); // Fp6 neg coeff 3/5
    let t384 = circuit_sub(in0, t378); // Fp6 neg coeff 4/5
    let t385 = circuit_sub(in0, t379); // Fp6 neg coeff 5/5

    let modulus = get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (
        t265, t266, t286, t287, t302, t303, t380, t381, t382, t383, t384, t385,
    )
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in0
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(M.c0b0a0); // in1
    circuit_inputs = circuit_inputs.next_2(M.c0b0a1); // in2
    circuit_inputs = circuit_inputs.next_2(M.c0b1a0); // in3
    circuit_inputs = circuit_inputs.next_2(M.c0b1a1); // in4
    circuit_inputs = circuit_inputs.next_2(M.c0b2a0); // in5
    circuit_inputs = circuit_inputs.next_2(M.c0b2a1); // in6
    circuit_inputs = circuit_inputs.next_2(M.c1b0a0); // in7
    circuit_inputs = circuit_inputs.next_2(M.c1b0a1); // in8
    circuit_inputs = circuit_inputs.next_2(M.c1b1a0); // in9
    circuit_inputs = circuit_inputs.next_2(M.c1b1a1); // in10
    circuit_inputs = circuit_inputs.next_2(M.c1b2a0); // in11
    circuit_inputs = circuit_inputs.next_2(M.c1b2a1); // in12

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: E12T = E12T {
        c0b0a0: outputs.get_output(t265),
        c0b0a1: outputs.get_output(t266),
        c0b1a0: outputs.get_output(t286),
        c0b1a1: outputs.get_output(t287),
        c0b2a0: outputs.get_output(t302),
        c0b2a1: outputs.get_output(t303),
        c1b0a0: outputs.get_output(t380),
        c1b0a1: outputs.get_output(t381),
        c1b1a0: outputs.get_output(t382),
        c1b1a1: outputs.get_output(t383),
        c1b2a0: outputs.get_output(t384),
        c1b2a1: outputs.get_output(t385),
    };
    return (res,);
}
#[inline(always)]
pub fn run_BLS12_381_E12T_MUL_circuit(X: E12T, Y: E12T) -> (E12T,) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13, in14) = (CE::<CI<12>> {}, CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16, in17) = (CE::<CI<15>> {}, CE::<CI<16>> {}, CE::<CI<17>> {});
    let (in18, in19, in20) = (CE::<CI<18>> {}, CE::<CI<19>> {}, CE::<CI<20>> {});
    let (in21, in22, in23) = (CE::<CI<21>> {}, CE::<CI<22>> {}, CE::<CI<23>> {});
    let t0 = circuit_add(in0, in6); // Fp6 add coeff 0/5
    let t1 = circuit_add(in1, in7); // Fp6 add coeff 1/5
    let t2 = circuit_add(in2, in8); // Fp6 add coeff 2/5
    let t3 = circuit_add(in3, in9); // Fp6 add coeff 3/5
    let t4 = circuit_add(in4, in10); // Fp6 add coeff 4/5
    let t5 = circuit_add(in5, in11); // Fp6 add coeff 5/5
    let t6 = circuit_add(in12, in18); // Fp6 add coeff 0/5
    let t7 = circuit_add(in13, in19); // Fp6 add coeff 1/5
    let t8 = circuit_add(in14, in20); // Fp6 add coeff 2/5
    let t9 = circuit_add(in15, in21); // Fp6 add coeff 3/5
    let t10 = circuit_add(in16, in22); // Fp6 add coeff 4/5
    let t11 = circuit_add(in17, in23); // Fp6 add coeff 5/5
    let t12 = circuit_mul(t0, t6); // Fp2 mul start
    let t13 = circuit_mul(t1, t7);
    let t14 = circuit_sub(t12, t13); // Fp2 mul real part end
    let t15 = circuit_mul(t0, t7);
    let t16 = circuit_mul(t1, t6);
    let t17 = circuit_add(t15, t16); // Fp2 mul imag part end
    let t18 = circuit_mul(t2, t8); // Fp2 mul start
    let t19 = circuit_mul(t3, t9);
    let t20 = circuit_sub(t18, t19); // Fp2 mul real part end
    let t21 = circuit_mul(t2, t9);
    let t22 = circuit_mul(t3, t8);
    let t23 = circuit_add(t21, t22); // Fp2 mul imag part end
    let t24 = circuit_mul(t4, t10); // Fp2 mul start
    let t25 = circuit_mul(t5, t11);
    let t26 = circuit_sub(t24, t25); // Fp2 mul real part end
    let t27 = circuit_mul(t4, t11);
    let t28 = circuit_mul(t5, t10);
    let t29 = circuit_add(t27, t28); // Fp2 mul imag part end
    let t30 = circuit_add(t2, t4); // Fp2 add coeff 0/1
    let t31 = circuit_add(t3, t5); // Fp2 add coeff 1/1
    let t32 = circuit_add(t8, t10); // Fp2 add coeff 0/1
    let t33 = circuit_add(t9, t11); // Fp2 add coeff 1/1
    let t34 = circuit_mul(t30, t32); // Fp2 mul start
    let t35 = circuit_mul(t31, t33);
    let t36 = circuit_sub(t34, t35); // Fp2 mul real part end
    let t37 = circuit_mul(t30, t33);
    let t38 = circuit_mul(t31, t32);
    let t39 = circuit_add(t37, t38); // Fp2 mul imag part end
    let t40 = circuit_sub(t36, t20); // Fp2 sub coeff 0/1
    let t41 = circuit_sub(t39, t23); // Fp2 sub coeff 1/1
    let t42 = circuit_sub(t40, t26); // Fp2 sub coeff 0/1
    let t43 = circuit_sub(t41, t29); // Fp2 sub coeff 1/1
    let t44 = circuit_add(t42, t43);
    let t45 = circuit_add(t44, t44);
    let t46 = circuit_sub(t42, t43);
    let t47 = circuit_sub(t45, t42);
    let t48 = circuit_sub(t47, t43);
    let t49 = circuit_add(t46, t14); // Fp2 add coeff 0/1
    let t50 = circuit_add(t48, t17); // Fp2 add coeff 1/1
    let t51 = circuit_add(t0, t2); // Fp2 add coeff 0/1
    let t52 = circuit_add(t1, t3); // Fp2 add coeff 1/1
    let t53 = circuit_add(t6, t8); // Fp2 add coeff 0/1
    let t54 = circuit_add(t7, t9); // Fp2 add coeff 1/1
    let t55 = circuit_mul(t51, t53); // Fp2 mul start
    let t56 = circuit_mul(t52, t54);
    let t57 = circuit_sub(t55, t56); // Fp2 mul real part end
    let t58 = circuit_mul(t51, t54);
    let t59 = circuit_mul(t52, t53);
    let t60 = circuit_add(t58, t59); // Fp2 mul imag part end
    let t61 = circuit_sub(t57, t14); // Fp2 sub coeff 0/1
    let t62 = circuit_sub(t60, t17); // Fp2 sub coeff 1/1
    let t63 = circuit_sub(t61, t20); // Fp2 sub coeff 0/1
    let t64 = circuit_sub(t62, t23); // Fp2 sub coeff 1/1
    let t65 = circuit_add(t26, t29);
    let t66 = circuit_add(t65, t65);
    let t67 = circuit_sub(t26, t29);
    let t68 = circuit_sub(t66, t26);
    let t69 = circuit_sub(t68, t29);
    let t70 = circuit_add(t63, t67); // Fp2 add coeff 0/1
    let t71 = circuit_add(t64, t69); // Fp2 add coeff 1/1
    let t72 = circuit_add(t0, t4); // Fp2 add coeff 0/1
    let t73 = circuit_add(t1, t5); // Fp2 add coeff 1/1
    let t74 = circuit_add(t6, t10); // Fp2 add coeff 0/1
    let t75 = circuit_add(t7, t11); // Fp2 add coeff 1/1
    let t76 = circuit_mul(t74, t72); // Fp2 mul start
    let t77 = circuit_mul(t75, t73);
    let t78 = circuit_sub(t76, t77); // Fp2 mul real part end
    let t79 = circuit_mul(t74, t73);
    let t80 = circuit_mul(t75, t72);
    let t81 = circuit_add(t79, t80); // Fp2 mul imag part end
    let t82 = circuit_sub(t78, t14); // Fp2 sub coeff 0/1
    let t83 = circuit_sub(t81, t17); // Fp2 sub coeff 1/1
    let t84 = circuit_sub(t82, t26); // Fp2 sub coeff 0/1
    let t85 = circuit_sub(t83, t29); // Fp2 sub coeff 1/1
    let t86 = circuit_add(t84, t20); // Fp2 add coeff 0/1
    let t87 = circuit_add(t85, t23); // Fp2 add coeff 1/1
    let t88 = circuit_mul(in0, in12); // Fp2 mul start
    let t89 = circuit_mul(in1, in13);
    let t90 = circuit_sub(t88, t89); // Fp2 mul real part end
    let t91 = circuit_mul(in0, in13);
    let t92 = circuit_mul(in1, in12);
    let t93 = circuit_add(t91, t92); // Fp2 mul imag part end
    let t94 = circuit_mul(in2, in14); // Fp2 mul start
    let t95 = circuit_mul(in3, in15);
    let t96 = circuit_sub(t94, t95); // Fp2 mul real part end
    let t97 = circuit_mul(in2, in15);
    let t98 = circuit_mul(in3, in14);
    let t99 = circuit_add(t97, t98); // Fp2 mul imag part end
    let t100 = circuit_mul(in4, in16); // Fp2 mul start
    let t101 = circuit_mul(in5, in17);
    let t102 = circuit_sub(t100, t101); // Fp2 mul real part end
    let t103 = circuit_mul(in4, in17);
    let t104 = circuit_mul(in5, in16);
    let t105 = circuit_add(t103, t104); // Fp2 mul imag part end
    let t106 = circuit_add(in2, in4); // Fp2 add coeff 0/1
    let t107 = circuit_add(in3, in5); // Fp2 add coeff 1/1
    let t108 = circuit_add(in14, in16); // Fp2 add coeff 0/1
    let t109 = circuit_add(in15, in17); // Fp2 add coeff 1/1
    let t110 = circuit_mul(t106, t108); // Fp2 mul start
    let t111 = circuit_mul(t107, t109);
    let t112 = circuit_sub(t110, t111); // Fp2 mul real part end
    let t113 = circuit_mul(t106, t109);
    let t114 = circuit_mul(t107, t108);
    let t115 = circuit_add(t113, t114); // Fp2 mul imag part end
    let t116 = circuit_sub(t112, t96); // Fp2 sub coeff 0/1
    let t117 = circuit_sub(t115, t99); // Fp2 sub coeff 1/1
    let t118 = circuit_sub(t116, t102); // Fp2 sub coeff 0/1
    let t119 = circuit_sub(t117, t105); // Fp2 sub coeff 1/1
    let t120 = circuit_add(t118, t119);
    let t121 = circuit_add(t120, t120);
    let t122 = circuit_sub(t118, t119);
    let t123 = circuit_sub(t121, t118);
    let t124 = circuit_sub(t123, t119);
    let t125 = circuit_add(t122, t90); // Fp2 add coeff 0/1
    let t126 = circuit_add(t124, t93); // Fp2 add coeff 1/1
    let t127 = circuit_add(in0, in2); // Fp2 add coeff 0/1
    let t128 = circuit_add(in1, in3); // Fp2 add coeff 1/1
    let t129 = circuit_add(in12, in14); // Fp2 add coeff 0/1
    let t130 = circuit_add(in13, in15); // Fp2 add coeff 1/1
    let t131 = circuit_mul(t127, t129); // Fp2 mul start
    let t132 = circuit_mul(t128, t130);
    let t133 = circuit_sub(t131, t132); // Fp2 mul real part end
    let t134 = circuit_mul(t127, t130);
    let t135 = circuit_mul(t128, t129);
    let t136 = circuit_add(t134, t135); // Fp2 mul imag part end
    let t137 = circuit_sub(t133, t90); // Fp2 sub coeff 0/1
    let t138 = circuit_sub(t136, t93); // Fp2 sub coeff 1/1
    let t139 = circuit_sub(t137, t96); // Fp2 sub coeff 0/1
    let t140 = circuit_sub(t138, t99); // Fp2 sub coeff 1/1
    let t141 = circuit_add(t102, t105);
    let t142 = circuit_add(t141, t141);
    let t143 = circuit_sub(t102, t105);
    let t144 = circuit_sub(t142, t102);
    let t145 = circuit_sub(t144, t105);
    let t146 = circuit_add(t139, t143); // Fp2 add coeff 0/1
    let t147 = circuit_add(t140, t145); // Fp2 add coeff 1/1
    let t148 = circuit_add(in0, in4); // Fp2 add coeff 0/1
    let t149 = circuit_add(in1, in5); // Fp2 add coeff 1/1
    let t150 = circuit_add(in12, in16); // Fp2 add coeff 0/1
    let t151 = circuit_add(in13, in17); // Fp2 add coeff 1/1
    let t152 = circuit_mul(t150, t148); // Fp2 mul start
    let t153 = circuit_mul(t151, t149);
    let t154 = circuit_sub(t152, t153); // Fp2 mul real part end
    let t155 = circuit_mul(t150, t149);
    let t156 = circuit_mul(t151, t148);
    let t157 = circuit_add(t155, t156); // Fp2 mul imag part end
    let t158 = circuit_sub(t154, t90); // Fp2 sub coeff 0/1
    let t159 = circuit_sub(t157, t93); // Fp2 sub coeff 1/1
    let t160 = circuit_sub(t158, t102); // Fp2 sub coeff 0/1
    let t161 = circuit_sub(t159, t105); // Fp2 sub coeff 1/1
    let t162 = circuit_add(t160, t96); // Fp2 add coeff 0/1
    let t163 = circuit_add(t161, t99); // Fp2 add coeff 1/1
    let t164 = circuit_mul(in6, in18); // Fp2 mul start
    let t165 = circuit_mul(in7, in19);
    let t166 = circuit_sub(t164, t165); // Fp2 mul real part end
    let t167 = circuit_mul(in6, in19);
    let t168 = circuit_mul(in7, in18);
    let t169 = circuit_add(t167, t168); // Fp2 mul imag part end
    let t170 = circuit_mul(in8, in20); // Fp2 mul start
    let t171 = circuit_mul(in9, in21);
    let t172 = circuit_sub(t170, t171); // Fp2 mul real part end
    let t173 = circuit_mul(in8, in21);
    let t174 = circuit_mul(in9, in20);
    let t175 = circuit_add(t173, t174); // Fp2 mul imag part end
    let t176 = circuit_mul(in10, in22); // Fp2 mul start
    let t177 = circuit_mul(in11, in23);
    let t178 = circuit_sub(t176, t177); // Fp2 mul real part end
    let t179 = circuit_mul(in10, in23);
    let t180 = circuit_mul(in11, in22);
    let t181 = circuit_add(t179, t180); // Fp2 mul imag part end
    let t182 = circuit_add(in8, in10); // Fp2 add coeff 0/1
    let t183 = circuit_add(in9, in11); // Fp2 add coeff 1/1
    let t184 = circuit_add(in20, in22); // Fp2 add coeff 0/1
    let t185 = circuit_add(in21, in23); // Fp2 add coeff 1/1
    let t186 = circuit_mul(t182, t184); // Fp2 mul start
    let t187 = circuit_mul(t183, t185);
    let t188 = circuit_sub(t186, t187); // Fp2 mul real part end
    let t189 = circuit_mul(t182, t185);
    let t190 = circuit_mul(t183, t184);
    let t191 = circuit_add(t189, t190); // Fp2 mul imag part end
    let t192 = circuit_sub(t188, t172); // Fp2 sub coeff 0/1
    let t193 = circuit_sub(t191, t175); // Fp2 sub coeff 1/1
    let t194 = circuit_sub(t192, t178); // Fp2 sub coeff 0/1
    let t195 = circuit_sub(t193, t181); // Fp2 sub coeff 1/1
    let t196 = circuit_add(t194, t195);
    let t197 = circuit_add(t196, t196);
    let t198 = circuit_sub(t194, t195);
    let t199 = circuit_sub(t197, t194);
    let t200 = circuit_sub(t199, t195);
    let t201 = circuit_add(t198, t166); // Fp2 add coeff 0/1
    let t202 = circuit_add(t200, t169); // Fp2 add coeff 1/1
    let t203 = circuit_add(in6, in8); // Fp2 add coeff 0/1
    let t204 = circuit_add(in7, in9); // Fp2 add coeff 1/1
    let t205 = circuit_add(in18, in20); // Fp2 add coeff 0/1
    let t206 = circuit_add(in19, in21); // Fp2 add coeff 1/1
    let t207 = circuit_mul(t203, t205); // Fp2 mul start
    let t208 = circuit_mul(t204, t206);
    let t209 = circuit_sub(t207, t208); // Fp2 mul real part end
    let t210 = circuit_mul(t203, t206);
    let t211 = circuit_mul(t204, t205);
    let t212 = circuit_add(t210, t211); // Fp2 mul imag part end
    let t213 = circuit_sub(t209, t166); // Fp2 sub coeff 0/1
    let t214 = circuit_sub(t212, t169); // Fp2 sub coeff 1/1
    let t215 = circuit_sub(t213, t172); // Fp2 sub coeff 0/1
    let t216 = circuit_sub(t214, t175); // Fp2 sub coeff 1/1
    let t217 = circuit_add(t178, t181);
    let t218 = circuit_add(t217, t217);
    let t219 = circuit_sub(t178, t181);
    let t220 = circuit_sub(t218, t178);
    let t221 = circuit_sub(t220, t181);
    let t222 = circuit_add(t215, t219); // Fp2 add coeff 0/1
    let t223 = circuit_add(t216, t221); // Fp2 add coeff 1/1
    let t224 = circuit_add(in6, in10); // Fp2 add coeff 0/1
    let t225 = circuit_add(in7, in11); // Fp2 add coeff 1/1
    let t226 = circuit_add(in18, in22); // Fp2 add coeff 0/1
    let t227 = circuit_add(in19, in23); // Fp2 add coeff 1/1
    let t228 = circuit_mul(t226, t224); // Fp2 mul start
    let t229 = circuit_mul(t227, t225);
    let t230 = circuit_sub(t228, t229); // Fp2 mul real part end
    let t231 = circuit_mul(t226, t225);
    let t232 = circuit_mul(t227, t224);
    let t233 = circuit_add(t231, t232); // Fp2 mul imag part end
    let t234 = circuit_sub(t230, t166); // Fp2 sub coeff 0/1
    let t235 = circuit_sub(t233, t169); // Fp2 sub coeff 1/1
    let t236 = circuit_sub(t234, t178); // Fp2 sub coeff 0/1
    let t237 = circuit_sub(t235, t181); // Fp2 sub coeff 1/1
    let t238 = circuit_add(t236, t172); // Fp2 add coeff 0/1
    let t239 = circuit_add(t237, t175); // Fp2 add coeff 1/1
    let t240 = circuit_sub(t49, t125); // Fp6 sub coeff 0/5
    let t241 = circuit_sub(t50, t126); // Fp6 sub coeff 1/5
    let t242 = circuit_sub(t70, t146); // Fp6 sub coeff 2/5
    let t243 = circuit_sub(t71, t147); // Fp6 sub coeff 3/5
    let t244 = circuit_sub(t86, t162); // Fp6 sub coeff 4/5
    let t245 = circuit_sub(t87, t163); // Fp6 sub coeff 5/5
    let t246 = circuit_sub(t240, t201); // Fp6 sub coeff 0/5
    let t247 = circuit_sub(t241, t202); // Fp6 sub coeff 1/5
    let t248 = circuit_sub(t242, t222); // Fp6 sub coeff 2/5
    let t249 = circuit_sub(t243, t223); // Fp6 sub coeff 3/5
    let t250 = circuit_sub(t244, t238); // Fp6 sub coeff 4/5
    let t251 = circuit_sub(t245, t239); // Fp6 sub coeff 5/5
    let t252 = circuit_add(t238, t239);
    let t253 = circuit_add(t252, t252);
    let t254 = circuit_sub(t238, t239);
    let t255 = circuit_sub(t253, t238);
    let t256 = circuit_sub(t255, t239);
    let t257 = circuit_add(t254, t125); // Fp6 add coeff 0/5
    let t258 = circuit_add(t256, t126); // Fp6 add coeff 1/5
    let t259 = circuit_add(t201, t146); // Fp6 add coeff 2/5
    let t260 = circuit_add(t202, t147); // Fp6 add coeff 3/5
    let t261 = circuit_add(t222, t162); // Fp6 add coeff 4/5
    let t262 = circuit_add(t223, t163); // Fp6 add coeff 5/5

    let modulus = get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (
        t257, t258, t259, t260, t261, t262, t246, t247, t248, t249, t250, t251,
    )
        .new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(X.c0b0a0); // in0
    circuit_inputs = circuit_inputs.next_2(X.c0b0a1); // in1
    circuit_inputs = circuit_inputs.next_2(X.c0b1a0); // in2
    circuit_inputs = circuit_inputs.next_2(X.c0b1a1); // in3
    circuit_inputs = circuit_inputs.next_2(X.c0b2a0); // in4
    circuit_inputs = circuit_inputs.next_2(X.c0b2a1); // in5
    circuit_inputs = circuit_inputs.next_2(X.c1b0a0); // in6
    circuit_inputs = circuit_inputs.next_2(X.c1b0a1); // in7
    circuit_inputs = circuit_inputs.next_2(X.c1b1a0); // in8
    circuit_inputs = circuit_inputs.next_2(X.c1b1a1); // in9
    circuit_inputs = circuit_inputs.next_2(X.c1b2a0); // in10
    circuit_inputs = circuit_inputs.next_2(X.c1b2a1); // in11
    circuit_inputs = circuit_inputs.next_2(Y.c0b0a0); // in12
    circuit_inputs = circuit_inputs.next_2(Y.c0b0a1); // in13
    circuit_inputs = circuit_inputs.next_2(Y.c0b1a0); // in14
    circuit_inputs = circuit_inputs.next_2(Y.c0b1a1); // in15
    circuit_inputs = circuit_inputs.next_2(Y.c0b2a0); // in16
    circuit_inputs = circuit_inputs.next_2(Y.c0b2a1); // in17
    circuit_inputs = circuit_inputs.next_2(Y.c1b0a0); // in18
    circuit_inputs = circuit_inputs.next_2(Y.c1b0a1); // in19
    circuit_inputs = circuit_inputs.next_2(Y.c1b1a0); // in20
    circuit_inputs = circuit_inputs.next_2(Y.c1b1a1); // in21
    circuit_inputs = circuit_inputs.next_2(Y.c1b2a0); // in22
    circuit_inputs = circuit_inputs.next_2(Y.c1b2a1); // in23

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: E12T = E12T {
        c0b0a0: outputs.get_output(t257),
        c0b0a1: outputs.get_output(t258),
        c0b1a0: outputs.get_output(t259),
        c0b1a1: outputs.get_output(t260),
        c0b2a0: outputs.get_output(t261),
        c0b2a1: outputs.get_output(t262),
        c1b0a0: outputs.get_output(t246),
        c1b0a1: outputs.get_output(t247),
        c1b1a0: outputs.get_output(t248),
        c1b1a1: outputs.get_output(t249),
        c1b2a0: outputs.get_output(t250),
        c1b2a1: outputs.get_output(t251),
    };
    return (res,);
}
#[inline(always)]
pub fn run_BLS12_381_TOWER_MILLER_BIT0_1P_circuit(
    yInv_0: u384, xNegOverY_0: u384, Q_0: G2Point, M_i: E12T,
) -> (G2Point, E12T) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0
    let in1 = CE::<CI<1>> {}; // 0x3
    let in2 = CE::<CI<2>> {}; // 0x6
    let in3 = CE::<CI<3>> {}; // 0x1

    // INPUT stack
    let (in4, in5, in6) = (CE::<CI<4>> {}, CE::<CI<5>> {}, CE::<CI<6>> {});
    let (in7, in8, in9) = (CE::<CI<7>> {}, CE::<CI<8>> {}, CE::<CI<9>> {});
    let (in10, in11, in12) = (CE::<CI<10>> {}, CE::<CI<11>> {}, CE::<CI<12>> {});
    let (in13, in14, in15) = (CE::<CI<13>> {}, CE::<CI<14>> {}, CE::<CI<15>> {});
    let (in16, in17, in18) = (CE::<CI<16>> {}, CE::<CI<17>> {}, CE::<CI<18>> {});
    let (in19, in20, in21) = (CE::<CI<19>> {}, CE::<CI<20>> {}, CE::<CI<21>> {});
    let t0 = circuit_sub(in10, in16); // Fp6 sub coeff 0/5
    let t1 = circuit_sub(in11, in17); // Fp6 sub coeff 1/5
    let t2 = circuit_sub(in12, in18); // Fp6 sub coeff 2/5
    let t3 = circuit_sub(in13, in19); // Fp6 sub coeff 3/5
    let t4 = circuit_sub(in14, in20); // Fp6 sub coeff 4/5
    let t5 = circuit_sub(in15, in21); // Fp6 sub coeff 5/5
    let t6 = circuit_add(in20, in21);
    let t7 = circuit_add(t6, t6);
    let t8 = circuit_sub(in20, in21);
    let t9 = circuit_sub(t7, in20);
    let t10 = circuit_sub(t9, in21);
    let t11 = circuit_sub(in0, t8); // Fp6 neg coeff 0/5
    let t12 = circuit_sub(in0, t10); // Fp6 neg coeff 1/5
    let t13 = circuit_sub(in0, in16); // Fp6 neg coeff 2/5
    let t14 = circuit_sub(in0, in17); // Fp6 neg coeff 3/5
    let t15 = circuit_sub(in0, in18); // Fp6 neg coeff 4/5
    let t16 = circuit_sub(in0, in19); // Fp6 neg coeff 5/5
    let t17 = circuit_add(in10, t11); // Fp6 add coeff 0/5
    let t18 = circuit_add(in11, t12); // Fp6 add coeff 1/5
    let t19 = circuit_add(in12, t13); // Fp6 add coeff 2/5
    let t20 = circuit_add(in13, t14); // Fp6 add coeff 3/5
    let t21 = circuit_add(in14, t15); // Fp6 add coeff 4/5
    let t22 = circuit_add(in15, t16); // Fp6 add coeff 5/5
    let t23 = circuit_mul(in10, in16); // Fp2 mul start
    let t24 = circuit_mul(in11, in17);
    let t25 = circuit_sub(t23, t24); // Fp2 mul real part end
    let t26 = circuit_mul(in10, in17);
    let t27 = circuit_mul(in11, in16);
    let t28 = circuit_add(t26, t27); // Fp2 mul imag part end
    let t29 = circuit_mul(in12, in18); // Fp2 mul start
    let t30 = circuit_mul(in13, in19);
    let t31 = circuit_sub(t29, t30); // Fp2 mul real part end
    let t32 = circuit_mul(in12, in19);
    let t33 = circuit_mul(in13, in18);
    let t34 = circuit_add(t32, t33); // Fp2 mul imag part end
    let t35 = circuit_mul(in14, in20); // Fp2 mul start
    let t36 = circuit_mul(in15, in21);
    let t37 = circuit_sub(t35, t36); // Fp2 mul real part end
    let t38 = circuit_mul(in14, in21);
    let t39 = circuit_mul(in15, in20);
    let t40 = circuit_add(t38, t39); // Fp2 mul imag part end
    let t41 = circuit_add(in12, in14); // Fp2 add coeff 0/1
    let t42 = circuit_add(in13, in15); // Fp2 add coeff 1/1
    let t43 = circuit_add(in18, in20); // Fp2 add coeff 0/1
    let t44 = circuit_add(in19, in21); // Fp2 add coeff 1/1
    let t45 = circuit_mul(t41, t43); // Fp2 mul start
    let t46 = circuit_mul(t42, t44);
    let t47 = circuit_sub(t45, t46); // Fp2 mul real part end
    let t48 = circuit_mul(t41, t44);
    let t49 = circuit_mul(t42, t43);
    let t50 = circuit_add(t48, t49); // Fp2 mul imag part end
    let t51 = circuit_sub(t47, t31); // Fp2 sub coeff 0/1
    let t52 = circuit_sub(t50, t34); // Fp2 sub coeff 1/1
    let t53 = circuit_sub(t51, t37); // Fp2 sub coeff 0/1
    let t54 = circuit_sub(t52, t40); // Fp2 sub coeff 1/1
    let t55 = circuit_add(t53, t54);
    let t56 = circuit_add(t55, t55);
    let t57 = circuit_sub(t53, t54);
    let t58 = circuit_sub(t56, t53);
    let t59 = circuit_sub(t58, t54);
    let t60 = circuit_add(t57, t25); // Fp2 add coeff 0/1
    let t61 = circuit_add(t59, t28); // Fp2 add coeff 1/1
    let t62 = circuit_add(in10, in12); // Fp2 add coeff 0/1
    let t63 = circuit_add(in11, in13); // Fp2 add coeff 1/1
    let t64 = circuit_add(in16, in18); // Fp2 add coeff 0/1
    let t65 = circuit_add(in17, in19); // Fp2 add coeff 1/1
    let t66 = circuit_mul(t62, t64); // Fp2 mul start
    let t67 = circuit_mul(t63, t65);
    let t68 = circuit_sub(t66, t67); // Fp2 mul real part end
    let t69 = circuit_mul(t62, t65);
    let t70 = circuit_mul(t63, t64);
    let t71 = circuit_add(t69, t70); // Fp2 mul imag part end
    let t72 = circuit_sub(t68, t25); // Fp2 sub coeff 0/1
    let t73 = circuit_sub(t71, t28); // Fp2 sub coeff 1/1
    let t74 = circuit_sub(t72, t31); // Fp2 sub coeff 0/1
    let t75 = circuit_sub(t73, t34); // Fp2 sub coeff 1/1
    let t76 = circuit_add(t37, t40);
    let t77 = circuit_add(t76, t76);
    let t78 = circuit_sub(t37, t40);
    let t79 = circuit_sub(t77, t37);
    let t80 = circuit_sub(t79, t40);
    let t81 = circuit_add(t74, t78); // Fp2 add coeff 0/1
    let t82 = circuit_add(t75, t80); // Fp2 add coeff 1/1
    let t83 = circuit_add(in10, in14); // Fp2 add coeff 0/1
    let t84 = circuit_add(in11, in15); // Fp2 add coeff 1/1
    let t85 = circuit_add(in16, in20); // Fp2 add coeff 0/1
    let t86 = circuit_add(in17, in21); // Fp2 add coeff 1/1
    let t87 = circuit_mul(t85, t83); // Fp2 mul start
    let t88 = circuit_mul(t86, t84);
    let t89 = circuit_sub(t87, t88); // Fp2 mul real part end
    let t90 = circuit_mul(t85, t84);
    let t91 = circuit_mul(t86, t83);
    let t92 = circuit_add(t90, t91); // Fp2 mul imag part end
    let t93 = circuit_sub(t89, t25); // Fp2 sub coeff 0/1
    let t94 = circuit_sub(t92, t28); // Fp2 sub coeff 1/1
    let t95 = circuit_sub(t93, t37); // Fp2 sub coeff 0/1
    let t96 = circuit_sub(t94, t40); // Fp2 sub coeff 1/1
    let t97 = circuit_add(t95, t31); // Fp2 add coeff 0/1
    let t98 = circuit_add(t96, t34); // Fp2 add coeff 1/1
    let t99 = circuit_mul(t0, t17); // Fp2 mul start
    let t100 = circuit_mul(t1, t18);
    let t101 = circuit_sub(t99, t100); // Fp2 mul real part end
    let t102 = circuit_mul(t0, t18);
    let t103 = circuit_mul(t1, t17);
    let t104 = circuit_add(t102, t103); // Fp2 mul imag part end
    let t105 = circuit_mul(t2, t19); // Fp2 mul start
    let t106 = circuit_mul(t3, t20);
    let t107 = circuit_sub(t105, t106); // Fp2 mul real part end
    let t108 = circuit_mul(t2, t20);
    let t109 = circuit_mul(t3, t19);
    let t110 = circuit_add(t108, t109); // Fp2 mul imag part end
    let t111 = circuit_mul(t4, t21); // Fp2 mul start
    let t112 = circuit_mul(t5, t22);
    let t113 = circuit_sub(t111, t112); // Fp2 mul real part end
    let t114 = circuit_mul(t4, t22);
    let t115 = circuit_mul(t5, t21);
    let t116 = circuit_add(t114, t115); // Fp2 mul imag part end
    let t117 = circuit_add(t2, t4); // Fp2 add coeff 0/1
    let t118 = circuit_add(t3, t5); // Fp2 add coeff 1/1
    let t119 = circuit_add(t19, t21); // Fp2 add coeff 0/1
    let t120 = circuit_add(t20, t22); // Fp2 add coeff 1/1
    let t121 = circuit_mul(t117, t119); // Fp2 mul start
    let t122 = circuit_mul(t118, t120);
    let t123 = circuit_sub(t121, t122); // Fp2 mul real part end
    let t124 = circuit_mul(t117, t120);
    let t125 = circuit_mul(t118, t119);
    let t126 = circuit_add(t124, t125); // Fp2 mul imag part end
    let t127 = circuit_sub(t123, t107); // Fp2 sub coeff 0/1
    let t128 = circuit_sub(t126, t110); // Fp2 sub coeff 1/1
    let t129 = circuit_sub(t127, t113); // Fp2 sub coeff 0/1
    let t130 = circuit_sub(t128, t116); // Fp2 sub coeff 1/1
    let t131 = circuit_add(t129, t130);
    let t132 = circuit_add(t131, t131);
    let t133 = circuit_sub(t129, t130);
    let t134 = circuit_sub(t132, t129);
    let t135 = circuit_sub(t134, t130);
    let t136 = circuit_add(t133, t101); // Fp2 add coeff 0/1
    let t137 = circuit_add(t135, t104); // Fp2 add coeff 1/1
    let t138 = circuit_add(t0, t2); // Fp2 add coeff 0/1
    let t139 = circuit_add(t1, t3); // Fp2 add coeff 1/1
    let t140 = circuit_add(t17, t19); // Fp2 add coeff 0/1
    let t141 = circuit_add(t18, t20); // Fp2 add coeff 1/1
    let t142 = circuit_mul(t138, t140); // Fp2 mul start
    let t143 = circuit_mul(t139, t141);
    let t144 = circuit_sub(t142, t143); // Fp2 mul real part end
    let t145 = circuit_mul(t138, t141);
    let t146 = circuit_mul(t139, t140);
    let t147 = circuit_add(t145, t146); // Fp2 mul imag part end
    let t148 = circuit_sub(t144, t101); // Fp2 sub coeff 0/1
    let t149 = circuit_sub(t147, t104); // Fp2 sub coeff 1/1
    let t150 = circuit_sub(t148, t107); // Fp2 sub coeff 0/1
    let t151 = circuit_sub(t149, t110); // Fp2 sub coeff 1/1
    let t152 = circuit_add(t113, t116);
    let t153 = circuit_add(t152, t152);
    let t154 = circuit_sub(t113, t116);
    let t155 = circuit_sub(t153, t113);
    let t156 = circuit_sub(t155, t116);
    let t157 = circuit_add(t150, t154); // Fp2 add coeff 0/1
    let t158 = circuit_add(t151, t156); // Fp2 add coeff 1/1
    let t159 = circuit_add(t0, t4); // Fp2 add coeff 0/1
    let t160 = circuit_add(t1, t5); // Fp2 add coeff 1/1
    let t161 = circuit_add(t17, t21); // Fp2 add coeff 0/1
    let t162 = circuit_add(t18, t22); // Fp2 add coeff 1/1
    let t163 = circuit_mul(t161, t159); // Fp2 mul start
    let t164 = circuit_mul(t162, t160);
    let t165 = circuit_sub(t163, t164); // Fp2 mul real part end
    let t166 = circuit_mul(t161, t160);
    let t167 = circuit_mul(t162, t159);
    let t168 = circuit_add(t166, t167); // Fp2 mul imag part end
    let t169 = circuit_sub(t165, t101); // Fp2 sub coeff 0/1
    let t170 = circuit_sub(t168, t104); // Fp2 sub coeff 1/1
    let t171 = circuit_sub(t169, t113); // Fp2 sub coeff 0/1
    let t172 = circuit_sub(t170, t116); // Fp2 sub coeff 1/1
    let t173 = circuit_add(t171, t107); // Fp2 add coeff 0/1
    let t174 = circuit_add(t172, t110); // Fp2 add coeff 1/1
    let t175 = circuit_add(t136, t60); // Fp6 add coeff 0/5
    let t176 = circuit_add(t137, t61); // Fp6 add coeff 1/5
    let t177 = circuit_add(t157, t81); // Fp6 add coeff 2/5
    let t178 = circuit_add(t158, t82); // Fp6 add coeff 3/5
    let t179 = circuit_add(t173, t97); // Fp6 add coeff 4/5
    let t180 = circuit_add(t174, t98); // Fp6 add coeff 5/5
    let t181 = circuit_add(t60, t60); // Fp6 add coeff 0/5
    let t182 = circuit_add(t61, t61); // Fp6 add coeff 1/5
    let t183 = circuit_add(t81, t81); // Fp6 add coeff 2/5
    let t184 = circuit_add(t82, t82); // Fp6 add coeff 3/5
    let t185 = circuit_add(t97, t97); // Fp6 add coeff 4/5
    let t186 = circuit_add(t98, t98); // Fp6 add coeff 5/5
    let t187 = circuit_add(t97, t98);
    let t188 = circuit_add(t187, t187);
    let t189 = circuit_sub(t97, t98);
    let t190 = circuit_sub(t188, t97);
    let t191 = circuit_sub(t190, t98);
    let t192 = circuit_add(t175, t189); // Fp6 add coeff 0/5
    let t193 = circuit_add(t176, t191); // Fp6 add coeff 1/5
    let t194 = circuit_add(t177, t60); // Fp6 add coeff 2/5
    let t195 = circuit_add(t178, t61); // Fp6 add coeff 3/5
    let t196 = circuit_add(t179, t81); // Fp6 add coeff 4/5
    let t197 = circuit_add(t180, t82); // Fp6 add coeff 5/5
    let t198 = circuit_add(in6, in7); // Doubling slope numerator start
    let t199 = circuit_sub(in6, in7);
    let t200 = circuit_mul(t198, t199);
    let t201 = circuit_mul(in6, in7);
    let t202 = circuit_mul(t200, in1);
    let t203 = circuit_mul(t201, in2); // Doubling slope numerator end
    let t204 = circuit_add(in8, in8); // Fp2 add coeff 0/1
    let t205 = circuit_add(in9, in9); // Fp2 add coeff 1/1
    let t206 = circuit_mul(t204, t204); // Fp2 Inv start
    let t207 = circuit_mul(t205, t205);
    let t208 = circuit_add(t206, t207);
    let t209 = circuit_inverse(t208);
    let t210 = circuit_mul(t204, t209); // Fp2 Inv real part end
    let t211 = circuit_mul(t205, t209);
    let t212 = circuit_sub(in0, t211); // Fp2 Inv imag part end
    let t213 = circuit_mul(t202, t210); // Fp2 mul start
    let t214 = circuit_mul(t203, t212);
    let t215 = circuit_sub(t213, t214); // Fp2 mul real part end
    let t216 = circuit_mul(t202, t212);
    let t217 = circuit_mul(t203, t210);
    let t218 = circuit_add(t216, t217); // Fp2 mul imag part end
    let t219 = circuit_add(t215, t218);
    let t220 = circuit_sub(t215, t218);
    let t221 = circuit_mul(t219, t220);
    let t222 = circuit_mul(t215, t218);
    let t223 = circuit_add(t222, t222);
    let t224 = circuit_add(in6, in6); // Fp2 add coeff 0/1
    let t225 = circuit_add(in7, in7); // Fp2 add coeff 1/1
    let t226 = circuit_sub(t221, t224); // Fp2 sub coeff 0/1
    let t227 = circuit_sub(t223, t225); // Fp2 sub coeff 1/1
    let t228 = circuit_sub(in6, t226); // Fp2 sub coeff 0/1
    let t229 = circuit_sub(in7, t227); // Fp2 sub coeff 1/1
    let t230 = circuit_mul(t215, t228); // Fp2 mul start
    let t231 = circuit_mul(t218, t229);
    let t232 = circuit_sub(t230, t231); // Fp2 mul real part end
    let t233 = circuit_mul(t215, t229);
    let t234 = circuit_mul(t218, t228);
    let t235 = circuit_add(t233, t234); // Fp2 mul imag part end
    let t236 = circuit_sub(t232, in8); // Fp2 sub coeff 0/1
    let t237 = circuit_sub(t235, in9); // Fp2 sub coeff 1/1
    let t238 = circuit_mul(t215, in6); // Fp2 mul start
    let t239 = circuit_mul(t218, in7);
    let t240 = circuit_sub(t238, t239); // Fp2 mul real part end
    let t241 = circuit_mul(t215, in7);
    let t242 = circuit_mul(t218, in6);
    let t243 = circuit_add(t241, t242); // Fp2 mul imag part end
    let t244 = circuit_sub(t240, in8); // Fp2 sub coeff 0/1
    let t245 = circuit_sub(t243, in9); // Fp2 sub coeff 1/1
    let t246 = circuit_mul(t244, in4);
    let t247 = circuit_mul(t245, in4);
    let t248 = circuit_mul(t215, in5);
    let t249 = circuit_mul(t218, in5);
    let t250 = circuit_mul(t192, t246); // Fp2 mul start
    let t251 = circuit_mul(t193, t247);
    let t252 = circuit_sub(t250, t251); // Fp2 mul real part end
    let t253 = circuit_mul(t192, t247);
    let t254 = circuit_mul(t193, t246);
    let t255 = circuit_add(t253, t254); // Fp2 mul imag part end
    let t256 = circuit_mul(t194, t248); // Fp2 mul start
    let t257 = circuit_mul(t195, t249);
    let t258 = circuit_sub(t256, t257); // Fp2 mul real part end
    let t259 = circuit_mul(t194, t249);
    let t260 = circuit_mul(t195, t248);
    let t261 = circuit_add(t259, t260); // Fp2 mul imag part end
    let t262 = circuit_add(t194, t196); // Fp2 add coeff 0/1
    let t263 = circuit_add(t195, t197); // Fp2 add coeff 1/1
    let t264 = circuit_mul(t248, t262); // Fp2 mul start
    let t265 = circuit_mul(t249, t263);
    let t266 = circuit_sub(t264, t265); // Fp2 mul real part end
    let t267 = circuit_mul(t248, t263);
    let t268 = circuit_mul(t249, t262);
    let t269 = circuit_add(t267, t268); // Fp2 mul imag part end
    let t270 = circuit_sub(t266, t258); // Fp2 sub coeff 0/1
    let t271 = circuit_sub(t269, t261); // Fp2 sub coeff 1/1
    let t272 = circuit_add(t270, t271);
    let t273 = circuit_add(t272, t272);
    let t274 = circuit_sub(t270, t271);
    let t275 = circuit_sub(t273, t270);
    let t276 = circuit_sub(t275, t271);
    let t277 = circuit_add(t274, t252); // Fp2 add coeff 0/1
    let t278 = circuit_add(t276, t255); // Fp2 add coeff 1/1
    let t279 = circuit_add(t192, t196); // Fp2 add coeff 0/1
    let t280 = circuit_add(t193, t197); // Fp2 add coeff 1/1
    let t281 = circuit_mul(t246, t279); // Fp2 mul start
    let t282 = circuit_mul(t247, t280);
    let t283 = circuit_sub(t281, t282); // Fp2 mul real part end
    let t284 = circuit_mul(t246, t280);
    let t285 = circuit_mul(t247, t279);
    let t286 = circuit_add(t284, t285); // Fp2 mul imag part end
    let t287 = circuit_sub(t283, t252); // Fp2 sub coeff 0/1
    let t288 = circuit_sub(t286, t255); // Fp2 sub coeff 1/1
    let t289 = circuit_add(t287, t258); // Fp2 add coeff 0/1
    let t290 = circuit_add(t288, t261); // Fp2 add coeff 1/1
    let t291 = circuit_add(t246, t248); // Fp2 add coeff 0/1
    let t292 = circuit_add(t247, t249); // Fp2 add coeff 1/1
    let t293 = circuit_add(t192, t194); // Fp2 add coeff 0/1
    let t294 = circuit_add(t193, t195); // Fp2 add coeff 1/1
    let t295 = circuit_mul(t291, t293); // Fp2 mul start
    let t296 = circuit_mul(t292, t294);
    let t297 = circuit_sub(t295, t296); // Fp2 mul real part end
    let t298 = circuit_mul(t291, t294);
    let t299 = circuit_mul(t292, t293);
    let t300 = circuit_add(t298, t299); // Fp2 mul imag part end
    let t301 = circuit_sub(t297, t252); // Fp2 sub coeff 0/1
    let t302 = circuit_sub(t300, t255); // Fp2 sub coeff 1/1
    let t303 = circuit_sub(t301, t258); // Fp2 sub coeff 0/1
    let t304 = circuit_sub(t302, t261); // Fp2 sub coeff 1/1
    let t305 = circuit_add(t185, t186);
    let t306 = circuit_add(t305, t305);
    let t307 = circuit_sub(t185, t186);
    let t308 = circuit_sub(t306, t185);
    let t309 = circuit_sub(t308, t186);
    let t310 = circuit_add(in3, t248);
    let t311 = circuit_add(t181, t192); // Fp6 add coeff 0/5
    let t312 = circuit_add(t182, t193); // Fp6 add coeff 1/5
    let t313 = circuit_add(t183, t194); // Fp6 add coeff 2/5
    let t314 = circuit_add(t184, t195); // Fp6 add coeff 3/5
    let t315 = circuit_add(t185, t196); // Fp6 add coeff 4/5
    let t316 = circuit_add(t186, t197); // Fp6 add coeff 5/5
    let t317 = circuit_mul(t311, t246); // Fp2 mul start
    let t318 = circuit_mul(t312, t247);
    let t319 = circuit_sub(t317, t318); // Fp2 mul real part end
    let t320 = circuit_mul(t311, t247);
    let t321 = circuit_mul(t312, t246);
    let t322 = circuit_add(t320, t321); // Fp2 mul imag part end
    let t323 = circuit_mul(t313, t310); // Fp2 mul start
    let t324 = circuit_mul(t314, t249);
    let t325 = circuit_sub(t323, t324); // Fp2 mul real part end
    let t326 = circuit_mul(t313, t249);
    let t327 = circuit_mul(t314, t310);
    let t328 = circuit_add(t326, t327); // Fp2 mul imag part end
    let t329 = circuit_add(t313, t315); // Fp2 add coeff 0/1
    let t330 = circuit_add(t314, t316); // Fp2 add coeff 1/1
    let t331 = circuit_mul(t310, t329); // Fp2 mul start
    let t332 = circuit_mul(t249, t330);
    let t333 = circuit_sub(t331, t332); // Fp2 mul real part end
    let t334 = circuit_mul(t310, t330);
    let t335 = circuit_mul(t249, t329);
    let t336 = circuit_add(t334, t335); // Fp2 mul imag part end
    let t337 = circuit_sub(t333, t325); // Fp2 sub coeff 0/1
    let t338 = circuit_sub(t336, t328); // Fp2 sub coeff 1/1
    let t339 = circuit_add(t337, t338);
    let t340 = circuit_add(t339, t339);
    let t341 = circuit_sub(t337, t338);
    let t342 = circuit_sub(t340, t337);
    let t343 = circuit_sub(t342, t338);
    let t344 = circuit_add(t341, t319); // Fp2 add coeff 0/1
    let t345 = circuit_add(t343, t322); // Fp2 add coeff 1/1
    let t346 = circuit_add(t311, t315); // Fp2 add coeff 0/1
    let t347 = circuit_add(t312, t316); // Fp2 add coeff 1/1
    let t348 = circuit_mul(t246, t346); // Fp2 mul start
    let t349 = circuit_mul(t247, t347);
    let t350 = circuit_sub(t348, t349); // Fp2 mul real part end
    let t351 = circuit_mul(t246, t347);
    let t352 = circuit_mul(t247, t346);
    let t353 = circuit_add(t351, t352); // Fp2 mul imag part end
    let t354 = circuit_sub(t350, t319); // Fp2 sub coeff 0/1
    let t355 = circuit_sub(t353, t322); // Fp2 sub coeff 1/1
    let t356 = circuit_add(t354, t325); // Fp2 add coeff 0/1
    let t357 = circuit_add(t355, t328); // Fp2 add coeff 1/1
    let t358 = circuit_add(t246, t310); // Fp2 add coeff 0/1
    let t359 = circuit_add(t247, t249); // Fp2 add coeff 1/1
    let t360 = circuit_add(t311, t313); // Fp2 add coeff 0/1
    let t361 = circuit_add(t312, t314); // Fp2 add coeff 1/1
    let t362 = circuit_mul(t358, t360); // Fp2 mul start
    let t363 = circuit_mul(t359, t361);
    let t364 = circuit_sub(t362, t363); // Fp2 mul real part end
    let t365 = circuit_mul(t358, t361);
    let t366 = circuit_mul(t359, t360);
    let t367 = circuit_add(t365, t366); // Fp2 mul imag part end
    let t368 = circuit_sub(t364, t319); // Fp2 sub coeff 0/1
    let t369 = circuit_sub(t367, t322); // Fp2 sub coeff 1/1
    let t370 = circuit_sub(t368, t325); // Fp2 sub coeff 0/1
    let t371 = circuit_sub(t369, t328); // Fp2 sub coeff 1/1
    let t372 = circuit_sub(t344, t277); // Fp6 sub coeff 0/5
    let t373 = circuit_sub(t345, t278); // Fp6 sub coeff 1/5
    let t374 = circuit_sub(t370, t303); // Fp6 sub coeff 2/5
    let t375 = circuit_sub(t371, t304); // Fp6 sub coeff 3/5
    let t376 = circuit_sub(t356, t289); // Fp6 sub coeff 4/5
    let t377 = circuit_sub(t357, t290); // Fp6 sub coeff 5/5
    let t378 = circuit_sub(t372, t307); // Fp6 sub coeff 0/5
    let t379 = circuit_sub(t373, t309); // Fp6 sub coeff 1/5
    let t380 = circuit_sub(t374, t181); // Fp6 sub coeff 2/5
    let t381 = circuit_sub(t375, t182); // Fp6 sub coeff 3/5
    let t382 = circuit_sub(t376, t183); // Fp6 sub coeff 4/5
    let t383 = circuit_sub(t377, t184); // Fp6 sub coeff 5/5
    let t384 = circuit_add(t183, t184);
    let t385 = circuit_add(t384, t384);
    let t386 = circuit_sub(t183, t184);
    let t387 = circuit_sub(t385, t183);
    let t388 = circuit_sub(t387, t184);
    let t389 = circuit_add(t386, t277); // Fp6 add coeff 0/5
    let t390 = circuit_add(t388, t278); // Fp6 add coeff 1/5
    let t391 = circuit_add(t307, t303); // Fp6 add coeff 2/5
    let t392 = circuit_add(t309, t304); // Fp6 add coeff 3/5
    let t393 = circuit_add(t181, t289); // Fp6 add coeff 4/5
    let t394 = circuit_add(t182, t290); // Fp6 add coeff 5/5
    let t395 = circuit_add(t226, t227);
    let t396 = circuit_add(t395, t236);
    let t397 = circuit_add(t396, t237);

    let modulus = get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (
        t397, t389, t390, t391, t392, t393, t394, t378, t379, t380, t381, t382, t383,
    )
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs.next_2([0x3, 0x0, 0x0, 0x0]); // in1
    circuit_inputs = circuit_inputs.next_2([0x6, 0x0, 0x0, 0x0]); // in2
    circuit_inputs = circuit_inputs.next_2([0x1, 0x0, 0x0, 0x0]); // in3
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(yInv_0); // in4
    circuit_inputs = circuit_inputs.next_2(xNegOverY_0); // in5
    circuit_inputs = circuit_inputs.next_2(Q_0.x0); // in6
    circuit_inputs = circuit_inputs.next_2(Q_0.x1); // in7
    circuit_inputs = circuit_inputs.next_2(Q_0.y0); // in8
    circuit_inputs = circuit_inputs.next_2(Q_0.y1); // in9
    circuit_inputs = circuit_inputs.next_2(M_i.c0b0a0); // in10
    circuit_inputs = circuit_inputs.next_2(M_i.c0b0a1); // in11
    circuit_inputs = circuit_inputs.next_2(M_i.c0b1a0); // in12
    circuit_inputs = circuit_inputs.next_2(M_i.c0b1a1); // in13
    circuit_inputs = circuit_inputs.next_2(M_i.c0b2a0); // in14
    circuit_inputs = circuit_inputs.next_2(M_i.c0b2a1); // in15
    circuit_inputs = circuit_inputs.next_2(M_i.c1b0a0); // in16
    circuit_inputs = circuit_inputs.next_2(M_i.c1b0a1); // in17
    circuit_inputs = circuit_inputs.next_2(M_i.c1b1a0); // in18
    circuit_inputs = circuit_inputs.next_2(M_i.c1b1a1); // in19
    circuit_inputs = circuit_inputs.next_2(M_i.c1b2a0); // in20
    circuit_inputs = circuit_inputs.next_2(M_i.c1b2a1); // in21

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let Q0: G2Point = G2Point {
        x0: outputs.get_output(t226),
        x1: outputs.get_output(t227),
        y0: outputs.get_output(t236),
        y1: outputs.get_output(t237),
    };
    let Mi_plus_one: E12T = E12T {
        c0b0a0: outputs.get_output(t389),
        c0b0a1: outputs.get_output(t390),
        c0b1a0: outputs.get_output(t391),
        c0b1a1: outputs.get_output(t392),
        c0b2a0: outputs.get_output(t393),
        c0b2a1: outputs.get_output(t394),
        c1b0a0: outputs.get_output(t378),
        c1b0a1: outputs.get_output(t379),
        c1b1a0: outputs.get_output(t380),
        c1b1a1: outputs.get_output(t381),
        c1b2a0: outputs.get_output(t382),
        c1b2a1: outputs.get_output(t383),
    };
    return (Q0, Mi_plus_one);
}
#[inline(always)]
pub fn run_BLS12_381_TOWER_MILLER_BIT1_1P_circuit(
    yInv_0: u384, xNegOverY_0: u384, Q_0: G2Point, Q_or_Q_neg_0: G2Point, M_i: E12T,
) -> (G2Point, E12T) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0
    let in1 = CE::<CI<1>> {}; // 0x1

    // INPUT stack
    let (in2, in3, in4) = (CE::<CI<2>> {}, CE::<CI<3>> {}, CE::<CI<4>> {});
    let (in5, in6, in7) = (CE::<CI<5>> {}, CE::<CI<6>> {}, CE::<CI<7>> {});
    let (in8, in9, in10) = (CE::<CI<8>> {}, CE::<CI<9>> {}, CE::<CI<10>> {});
    let (in11, in12, in13) = (CE::<CI<11>> {}, CE::<CI<12>> {}, CE::<CI<13>> {});
    let (in14, in15, in16) = (CE::<CI<14>> {}, CE::<CI<15>> {}, CE::<CI<16>> {});
    let (in17, in18, in19) = (CE::<CI<17>> {}, CE::<CI<18>> {}, CE::<CI<19>> {});
    let (in20, in21, in22) = (CE::<CI<20>> {}, CE::<CI<21>> {}, CE::<CI<22>> {});
    let in23 = CE::<CI<23>> {};
    let t0 = circuit_sub(in12, in18); // Fp6 sub coeff 0/5
    let t1 = circuit_sub(in13, in19); // Fp6 sub coeff 1/5
    let t2 = circuit_sub(in14, in20); // Fp6 sub coeff 2/5
    let t3 = circuit_sub(in15, in21); // Fp6 sub coeff 3/5
    let t4 = circuit_sub(in16, in22); // Fp6 sub coeff 4/5
    let t5 = circuit_sub(in17, in23); // Fp6 sub coeff 5/5
    let t6 = circuit_add(in22, in23);
    let t7 = circuit_add(t6, t6);
    let t8 = circuit_sub(in22, in23);
    let t9 = circuit_sub(t7, in22);
    let t10 = circuit_sub(t9, in23);
    let t11 = circuit_sub(in0, t8); // Fp6 neg coeff 0/5
    let t12 = circuit_sub(in0, t10); // Fp6 neg coeff 1/5
    let t13 = circuit_sub(in0, in18); // Fp6 neg coeff 2/5
    let t14 = circuit_sub(in0, in19); // Fp6 neg coeff 3/5
    let t15 = circuit_sub(in0, in20); // Fp6 neg coeff 4/5
    let t16 = circuit_sub(in0, in21); // Fp6 neg coeff 5/5
    let t17 = circuit_add(in12, t11); // Fp6 add coeff 0/5
    let t18 = circuit_add(in13, t12); // Fp6 add coeff 1/5
    let t19 = circuit_add(in14, t13); // Fp6 add coeff 2/5
    let t20 = circuit_add(in15, t14); // Fp6 add coeff 3/5
    let t21 = circuit_add(in16, t15); // Fp6 add coeff 4/5
    let t22 = circuit_add(in17, t16); // Fp6 add coeff 5/5
    let t23 = circuit_mul(in12, in18); // Fp2 mul start
    let t24 = circuit_mul(in13, in19);
    let t25 = circuit_sub(t23, t24); // Fp2 mul real part end
    let t26 = circuit_mul(in12, in19);
    let t27 = circuit_mul(in13, in18);
    let t28 = circuit_add(t26, t27); // Fp2 mul imag part end
    let t29 = circuit_mul(in14, in20); // Fp2 mul start
    let t30 = circuit_mul(in15, in21);
    let t31 = circuit_sub(t29, t30); // Fp2 mul real part end
    let t32 = circuit_mul(in14, in21);
    let t33 = circuit_mul(in15, in20);
    let t34 = circuit_add(t32, t33); // Fp2 mul imag part end
    let t35 = circuit_mul(in16, in22); // Fp2 mul start
    let t36 = circuit_mul(in17, in23);
    let t37 = circuit_sub(t35, t36); // Fp2 mul real part end
    let t38 = circuit_mul(in16, in23);
    let t39 = circuit_mul(in17, in22);
    let t40 = circuit_add(t38, t39); // Fp2 mul imag part end
    let t41 = circuit_add(in14, in16); // Fp2 add coeff 0/1
    let t42 = circuit_add(in15, in17); // Fp2 add coeff 1/1
    let t43 = circuit_add(in20, in22); // Fp2 add coeff 0/1
    let t44 = circuit_add(in21, in23); // Fp2 add coeff 1/1
    let t45 = circuit_mul(t41, t43); // Fp2 mul start
    let t46 = circuit_mul(t42, t44);
    let t47 = circuit_sub(t45, t46); // Fp2 mul real part end
    let t48 = circuit_mul(t41, t44);
    let t49 = circuit_mul(t42, t43);
    let t50 = circuit_add(t48, t49); // Fp2 mul imag part end
    let t51 = circuit_sub(t47, t31); // Fp2 sub coeff 0/1
    let t52 = circuit_sub(t50, t34); // Fp2 sub coeff 1/1
    let t53 = circuit_sub(t51, t37); // Fp2 sub coeff 0/1
    let t54 = circuit_sub(t52, t40); // Fp2 sub coeff 1/1
    let t55 = circuit_add(t53, t54);
    let t56 = circuit_add(t55, t55);
    let t57 = circuit_sub(t53, t54);
    let t58 = circuit_sub(t56, t53);
    let t59 = circuit_sub(t58, t54);
    let t60 = circuit_add(t57, t25); // Fp2 add coeff 0/1
    let t61 = circuit_add(t59, t28); // Fp2 add coeff 1/1
    let t62 = circuit_add(in12, in14); // Fp2 add coeff 0/1
    let t63 = circuit_add(in13, in15); // Fp2 add coeff 1/1
    let t64 = circuit_add(in18, in20); // Fp2 add coeff 0/1
    let t65 = circuit_add(in19, in21); // Fp2 add coeff 1/1
    let t66 = circuit_mul(t62, t64); // Fp2 mul start
    let t67 = circuit_mul(t63, t65);
    let t68 = circuit_sub(t66, t67); // Fp2 mul real part end
    let t69 = circuit_mul(t62, t65);
    let t70 = circuit_mul(t63, t64);
    let t71 = circuit_add(t69, t70); // Fp2 mul imag part end
    let t72 = circuit_sub(t68, t25); // Fp2 sub coeff 0/1
    let t73 = circuit_sub(t71, t28); // Fp2 sub coeff 1/1
    let t74 = circuit_sub(t72, t31); // Fp2 sub coeff 0/1
    let t75 = circuit_sub(t73, t34); // Fp2 sub coeff 1/1
    let t76 = circuit_add(t37, t40);
    let t77 = circuit_add(t76, t76);
    let t78 = circuit_sub(t37, t40);
    let t79 = circuit_sub(t77, t37);
    let t80 = circuit_sub(t79, t40);
    let t81 = circuit_add(t74, t78); // Fp2 add coeff 0/1
    let t82 = circuit_add(t75, t80); // Fp2 add coeff 1/1
    let t83 = circuit_add(in12, in16); // Fp2 add coeff 0/1
    let t84 = circuit_add(in13, in17); // Fp2 add coeff 1/1
    let t85 = circuit_add(in18, in22); // Fp2 add coeff 0/1
    let t86 = circuit_add(in19, in23); // Fp2 add coeff 1/1
    let t87 = circuit_mul(t85, t83); // Fp2 mul start
    let t88 = circuit_mul(t86, t84);
    let t89 = circuit_sub(t87, t88); // Fp2 mul real part end
    let t90 = circuit_mul(t85, t84);
    let t91 = circuit_mul(t86, t83);
    let t92 = circuit_add(t90, t91); // Fp2 mul imag part end
    let t93 = circuit_sub(t89, t25); // Fp2 sub coeff 0/1
    let t94 = circuit_sub(t92, t28); // Fp2 sub coeff 1/1
    let t95 = circuit_sub(t93, t37); // Fp2 sub coeff 0/1
    let t96 = circuit_sub(t94, t40); // Fp2 sub coeff 1/1
    let t97 = circuit_add(t95, t31); // Fp2 add coeff 0/1
    let t98 = circuit_add(t96, t34); // Fp2 add coeff 1/1
    let t99 = circuit_mul(t0, t17); // Fp2 mul start
    let t100 = circuit_mul(t1, t18);
    let t101 = circuit_sub(t99, t100); // Fp2 mul real part end
    let t102 = circuit_mul(t0, t18);
    let t103 = circuit_mul(t1, t17);
    let t104 = circuit_add(t102, t103); // Fp2 mul imag part end
    let t105 = circuit_mul(t2, t19); // Fp2 mul start
    let t106 = circuit_mul(t3, t20);
    let t107 = circuit_sub(t105, t106); // Fp2 mul real part end
    let t108 = circuit_mul(t2, t20);
    let t109 = circuit_mul(t3, t19);
    let t110 = circuit_add(t108, t109); // Fp2 mul imag part end
    let t111 = circuit_mul(t4, t21); // Fp2 mul start
    let t112 = circuit_mul(t5, t22);
    let t113 = circuit_sub(t111, t112); // Fp2 mul real part end
    let t114 = circuit_mul(t4, t22);
    let t115 = circuit_mul(t5, t21);
    let t116 = circuit_add(t114, t115); // Fp2 mul imag part end
    let t117 = circuit_add(t2, t4); // Fp2 add coeff 0/1
    let t118 = circuit_add(t3, t5); // Fp2 add coeff 1/1
    let t119 = circuit_add(t19, t21); // Fp2 add coeff 0/1
    let t120 = circuit_add(t20, t22); // Fp2 add coeff 1/1
    let t121 = circuit_mul(t117, t119); // Fp2 mul start
    let t122 = circuit_mul(t118, t120);
    let t123 = circuit_sub(t121, t122); // Fp2 mul real part end
    let t124 = circuit_mul(t117, t120);
    let t125 = circuit_mul(t118, t119);
    let t126 = circuit_add(t124, t125); // Fp2 mul imag part end
    let t127 = circuit_sub(t123, t107); // Fp2 sub coeff 0/1
    let t128 = circuit_sub(t126, t110); // Fp2 sub coeff 1/1
    let t129 = circuit_sub(t127, t113); // Fp2 sub coeff 0/1
    let t130 = circuit_sub(t128, t116); // Fp2 sub coeff 1/1
    let t131 = circuit_add(t129, t130);
    let t132 = circuit_add(t131, t131);
    let t133 = circuit_sub(t129, t130);
    let t134 = circuit_sub(t132, t129);
    let t135 = circuit_sub(t134, t130);
    let t136 = circuit_add(t133, t101); // Fp2 add coeff 0/1
    let t137 = circuit_add(t135, t104); // Fp2 add coeff 1/1
    let t138 = circuit_add(t0, t2); // Fp2 add coeff 0/1
    let t139 = circuit_add(t1, t3); // Fp2 add coeff 1/1
    let t140 = circuit_add(t17, t19); // Fp2 add coeff 0/1
    let t141 = circuit_add(t18, t20); // Fp2 add coeff 1/1
    let t142 = circuit_mul(t138, t140); // Fp2 mul start
    let t143 = circuit_mul(t139, t141);
    let t144 = circuit_sub(t142, t143); // Fp2 mul real part end
    let t145 = circuit_mul(t138, t141);
    let t146 = circuit_mul(t139, t140);
    let t147 = circuit_add(t145, t146); // Fp2 mul imag part end
    let t148 = circuit_sub(t144, t101); // Fp2 sub coeff 0/1
    let t149 = circuit_sub(t147, t104); // Fp2 sub coeff 1/1
    let t150 = circuit_sub(t148, t107); // Fp2 sub coeff 0/1
    let t151 = circuit_sub(t149, t110); // Fp2 sub coeff 1/1
    let t152 = circuit_add(t113, t116);
    let t153 = circuit_add(t152, t152);
    let t154 = circuit_sub(t113, t116);
    let t155 = circuit_sub(t153, t113);
    let t156 = circuit_sub(t155, t116);
    let t157 = circuit_add(t150, t154); // Fp2 add coeff 0/1
    let t158 = circuit_add(t151, t156); // Fp2 add coeff 1/1
    let t159 = circuit_add(t0, t4); // Fp2 add coeff 0/1
    let t160 = circuit_add(t1, t5); // Fp2 add coeff 1/1
    let t161 = circuit_add(t17, t21); // Fp2 add coeff 0/1
    let t162 = circuit_add(t18, t22); // Fp2 add coeff 1/1
    let t163 = circuit_mul(t161, t159); // Fp2 mul start
    let t164 = circuit_mul(t162, t160);
    let t165 = circuit_sub(t163, t164); // Fp2 mul real part end
    let t166 = circuit_mul(t161, t160);
    let t167 = circuit_mul(t162, t159);
    let t168 = circuit_add(t166, t167); // Fp2 mul imag part end
    let t169 = circuit_sub(t165, t101); // Fp2 sub coeff 0/1
    let t170 = circuit_sub(t168, t104); // Fp2 sub coeff 1/1
    let t171 = circuit_sub(t169, t113); // Fp2 sub coeff 0/1
    let t172 = circuit_sub(t170, t116); // Fp2 sub coeff 1/1
    let t173 = circuit_add(t171, t107); // Fp2 add coeff 0/1
    let t174 = circuit_add(t172, t110); // Fp2 add coeff 1/1
    let t175 = circuit_add(t136, t60); // Fp6 add coeff 0/5
    let t176 = circuit_add(t137, t61); // Fp6 add coeff 1/5
    let t177 = circuit_add(t157, t81); // Fp6 add coeff 2/5
    let t178 = circuit_add(t158, t82); // Fp6 add coeff 3/5
    let t179 = circuit_add(t173, t97); // Fp6 add coeff 4/5
    let t180 = circuit_add(t174, t98); // Fp6 add coeff 5/5
    let t181 = circuit_add(t60, t60); // Fp6 add coeff 0/5
    let t182 = circuit_add(t61, t61); // Fp6 add coeff 1/5
    let t183 = circuit_add(t81, t81); // Fp6 add coeff 2/5
    let t184 = circuit_add(t82, t82); // Fp6 add coeff 3/5
    let t185 = circuit_add(t97, t97); // Fp6 add coeff 4/5
    let t186 = circuit_add(t98, t98); // Fp6 add coeff 5/5
    let t187 = circuit_add(t97, t98);
    let t188 = circuit_add(t187, t187);
    let t189 = circuit_sub(t97, t98);
    let t190 = circuit_sub(t188, t97);
    let t191 = circuit_sub(t190, t98);
    let t192 = circuit_add(t175, t189); // Fp6 add coeff 0/5
    let t193 = circuit_add(t176, t191); // Fp6 add coeff 1/5
    let t194 = circuit_add(t177, t60); // Fp6 add coeff 2/5
    let t195 = circuit_add(t178, t61); // Fp6 add coeff 3/5
    let t196 = circuit_add(t179, t81); // Fp6 add coeff 4/5
    let t197 = circuit_add(t180, t82); // Fp6 add coeff 5/5
    let t198 = circuit_sub(in6, in10); // Fp2 sub coeff 0/1
    let t199 = circuit_sub(in7, in11); // Fp2 sub coeff 1/1
    let t200 = circuit_sub(in4, in8); // Fp2 sub coeff 0/1
    let t201 = circuit_sub(in5, in9); // Fp2 sub coeff 1/1
    let t202 = circuit_mul(t200, t200); // Fp2 Inv start
    let t203 = circuit_mul(t201, t201);
    let t204 = circuit_add(t202, t203);
    let t205 = circuit_inverse(t204);
    let t206 = circuit_mul(t200, t205); // Fp2 Inv real part end
    let t207 = circuit_mul(t201, t205);
    let t208 = circuit_sub(in0, t207); // Fp2 Inv imag part end
    let t209 = circuit_mul(t198, t206); // Fp2 mul start
    let t210 = circuit_mul(t199, t208);
    let t211 = circuit_sub(t209, t210); // Fp2 mul real part end
    let t212 = circuit_mul(t198, t208);
    let t213 = circuit_mul(t199, t206);
    let t214 = circuit_add(t212, t213); // Fp2 mul imag part end
    let t215 = circuit_add(t211, t214);
    let t216 = circuit_sub(t211, t214);
    let t217 = circuit_mul(t215, t216);
    let t218 = circuit_mul(t211, t214);
    let t219 = circuit_add(t218, t218);
    let t220 = circuit_add(in4, in8); // Fp2 add coeff 0/1
    let t221 = circuit_add(in5, in9); // Fp2 add coeff 1/1
    let t222 = circuit_sub(t217, t220); // Fp2 sub coeff 0/1
    let t223 = circuit_sub(t219, t221); // Fp2 sub coeff 1/1
    let t224 = circuit_mul(t211, in4); // Fp2 mul start
    let t225 = circuit_mul(t214, in5);
    let t226 = circuit_sub(t224, t225); // Fp2 mul real part end
    let t227 = circuit_mul(t211, in5);
    let t228 = circuit_mul(t214, in4);
    let t229 = circuit_add(t227, t228); // Fp2 mul imag part end
    let t230 = circuit_sub(t226, in6); // Fp2 sub coeff 0/1
    let t231 = circuit_sub(t229, in7); // Fp2 sub coeff 1/1
    let t232 = circuit_add(in6, in6); // Fp2 add coeff 0/1
    let t233 = circuit_add(in7, in7); // Fp2 add coeff 1/1
    let t234 = circuit_sub(t222, in4); // Fp2 sub coeff 0/1
    let t235 = circuit_sub(t223, in5); // Fp2 sub coeff 1/1
    let t236 = circuit_mul(t234, t234); // Fp2 Inv start
    let t237 = circuit_mul(t235, t235);
    let t238 = circuit_add(t236, t237);
    let t239 = circuit_inverse(t238);
    let t240 = circuit_mul(t234, t239); // Fp2 Inv real part end
    let t241 = circuit_mul(t235, t239);
    let t242 = circuit_sub(in0, t241); // Fp2 Inv imag part end
    let t243 = circuit_mul(t232, t240); // Fp2 mul start
    let t244 = circuit_mul(t233, t242);
    let t245 = circuit_sub(t243, t244); // Fp2 mul real part end
    let t246 = circuit_mul(t232, t242);
    let t247 = circuit_mul(t233, t240);
    let t248 = circuit_add(t246, t247); // Fp2 mul imag part end
    let t249 = circuit_add(t211, t245); // Fp2 add coeff 0/1
    let t250 = circuit_add(t214, t248); // Fp2 add coeff 1/1
    let t251 = circuit_sub(in0, t249); // Fp2 neg coeff 0/1
    let t252 = circuit_sub(in0, t250); // Fp2 neg coeff 1/1
    let t253 = circuit_add(t251, t252);
    let t254 = circuit_sub(t251, t252);
    let t255 = circuit_mul(t253, t254);
    let t256 = circuit_mul(t251, t252);
    let t257 = circuit_add(t256, t256);
    let t258 = circuit_sub(t255, in4); // Fp2 sub coeff 0/1
    let t259 = circuit_sub(t257, in5); // Fp2 sub coeff 1/1
    let t260 = circuit_sub(t258, t222); // Fp2 sub coeff 0/1
    let t261 = circuit_sub(t259, t223); // Fp2 sub coeff 1/1
    let t262 = circuit_sub(in4, t260); // Fp2 sub coeff 0/1
    let t263 = circuit_sub(in5, t261); // Fp2 sub coeff 1/1
    let t264 = circuit_mul(t251, t262); // Fp2 mul start
    let t265 = circuit_mul(t252, t263);
    let t266 = circuit_sub(t264, t265); // Fp2 mul real part end
    let t267 = circuit_mul(t251, t263);
    let t268 = circuit_mul(t252, t262);
    let t269 = circuit_add(t267, t268); // Fp2 mul imag part end
    let t270 = circuit_sub(t266, in6); // Fp2 sub coeff 0/1
    let t271 = circuit_sub(t269, in7); // Fp2 sub coeff 1/1
    let t272 = circuit_mul(t251, in4); // Fp2 mul start
    let t273 = circuit_mul(t252, in5);
    let t274 = circuit_sub(t272, t273); // Fp2 mul real part end
    let t275 = circuit_mul(t251, in5);
    let t276 = circuit_mul(t252, in4);
    let t277 = circuit_add(t275, t276); // Fp2 mul imag part end
    let t278 = circuit_sub(t274, in6); // Fp2 sub coeff 0/1
    let t279 = circuit_sub(t277, in7); // Fp2 sub coeff 1/1
    let t280 = circuit_mul(t230, in2);
    let t281 = circuit_mul(t231, in2);
    let t282 = circuit_mul(t211, in3);
    let t283 = circuit_mul(t214, in3);
    let t284 = circuit_mul(t278, in2);
    let t285 = circuit_mul(t279, in2);
    let t286 = circuit_mul(t251, in3);
    let t287 = circuit_mul(t252, in3);
    let t288 = circuit_mul(t192, t280); // Fp2 mul start
    let t289 = circuit_mul(t193, t281);
    let t290 = circuit_sub(t288, t289); // Fp2 mul real part end
    let t291 = circuit_mul(t192, t281);
    let t292 = circuit_mul(t193, t280);
    let t293 = circuit_add(t291, t292); // Fp2 mul imag part end
    let t294 = circuit_mul(t194, t282); // Fp2 mul start
    let t295 = circuit_mul(t195, t283);
    let t296 = circuit_sub(t294, t295); // Fp2 mul real part end
    let t297 = circuit_mul(t194, t283);
    let t298 = circuit_mul(t195, t282);
    let t299 = circuit_add(t297, t298); // Fp2 mul imag part end
    let t300 = circuit_add(t194, t196); // Fp2 add coeff 0/1
    let t301 = circuit_add(t195, t197); // Fp2 add coeff 1/1
    let t302 = circuit_mul(t282, t300); // Fp2 mul start
    let t303 = circuit_mul(t283, t301);
    let t304 = circuit_sub(t302, t303); // Fp2 mul real part end
    let t305 = circuit_mul(t282, t301);
    let t306 = circuit_mul(t283, t300);
    let t307 = circuit_add(t305, t306); // Fp2 mul imag part end
    let t308 = circuit_sub(t304, t296); // Fp2 sub coeff 0/1
    let t309 = circuit_sub(t307, t299); // Fp2 sub coeff 1/1
    let t310 = circuit_add(t308, t309);
    let t311 = circuit_add(t310, t310);
    let t312 = circuit_sub(t308, t309);
    let t313 = circuit_sub(t311, t308);
    let t314 = circuit_sub(t313, t309);
    let t315 = circuit_add(t312, t290); // Fp2 add coeff 0/1
    let t316 = circuit_add(t314, t293); // Fp2 add coeff 1/1
    let t317 = circuit_add(t192, t196); // Fp2 add coeff 0/1
    let t318 = circuit_add(t193, t197); // Fp2 add coeff 1/1
    let t319 = circuit_mul(t280, t317); // Fp2 mul start
    let t320 = circuit_mul(t281, t318);
    let t321 = circuit_sub(t319, t320); // Fp2 mul real part end
    let t322 = circuit_mul(t280, t318);
    let t323 = circuit_mul(t281, t317);
    let t324 = circuit_add(t322, t323); // Fp2 mul imag part end
    let t325 = circuit_sub(t321, t290); // Fp2 sub coeff 0/1
    let t326 = circuit_sub(t324, t293); // Fp2 sub coeff 1/1
    let t327 = circuit_add(t325, t296); // Fp2 add coeff 0/1
    let t328 = circuit_add(t326, t299); // Fp2 add coeff 1/1
    let t329 = circuit_add(t280, t282); // Fp2 add coeff 0/1
    let t330 = circuit_add(t281, t283); // Fp2 add coeff 1/1
    let t331 = circuit_add(t192, t194); // Fp2 add coeff 0/1
    let t332 = circuit_add(t193, t195); // Fp2 add coeff 1/1
    let t333 = circuit_mul(t329, t331); // Fp2 mul start
    let t334 = circuit_mul(t330, t332);
    let t335 = circuit_sub(t333, t334); // Fp2 mul real part end
    let t336 = circuit_mul(t329, t332);
    let t337 = circuit_mul(t330, t331);
    let t338 = circuit_add(t336, t337); // Fp2 mul imag part end
    let t339 = circuit_sub(t335, t290); // Fp2 sub coeff 0/1
    let t340 = circuit_sub(t338, t293); // Fp2 sub coeff 1/1
    let t341 = circuit_sub(t339, t296); // Fp2 sub coeff 0/1
    let t342 = circuit_sub(t340, t299); // Fp2 sub coeff 1/1
    let t343 = circuit_add(t185, t186);
    let t344 = circuit_add(t343, t343);
    let t345 = circuit_sub(t185, t186);
    let t346 = circuit_sub(t344, t185);
    let t347 = circuit_sub(t346, t186);
    let t348 = circuit_add(in1, t282);
    let t349 = circuit_add(t181, t192); // Fp6 add coeff 0/5
    let t350 = circuit_add(t182, t193); // Fp6 add coeff 1/5
    let t351 = circuit_add(t183, t194); // Fp6 add coeff 2/5
    let t352 = circuit_add(t184, t195); // Fp6 add coeff 3/5
    let t353 = circuit_add(t185, t196); // Fp6 add coeff 4/5
    let t354 = circuit_add(t186, t197); // Fp6 add coeff 5/5
    let t355 = circuit_mul(t349, t280); // Fp2 mul start
    let t356 = circuit_mul(t350, t281);
    let t357 = circuit_sub(t355, t356); // Fp2 mul real part end
    let t358 = circuit_mul(t349, t281);
    let t359 = circuit_mul(t350, t280);
    let t360 = circuit_add(t358, t359); // Fp2 mul imag part end
    let t361 = circuit_mul(t351, t348); // Fp2 mul start
    let t362 = circuit_mul(t352, t283);
    let t363 = circuit_sub(t361, t362); // Fp2 mul real part end
    let t364 = circuit_mul(t351, t283);
    let t365 = circuit_mul(t352, t348);
    let t366 = circuit_add(t364, t365); // Fp2 mul imag part end
    let t367 = circuit_add(t351, t353); // Fp2 add coeff 0/1
    let t368 = circuit_add(t352, t354); // Fp2 add coeff 1/1
    let t369 = circuit_mul(t348, t367); // Fp2 mul start
    let t370 = circuit_mul(t283, t368);
    let t371 = circuit_sub(t369, t370); // Fp2 mul real part end
    let t372 = circuit_mul(t348, t368);
    let t373 = circuit_mul(t283, t367);
    let t374 = circuit_add(t372, t373); // Fp2 mul imag part end
    let t375 = circuit_sub(t371, t363); // Fp2 sub coeff 0/1
    let t376 = circuit_sub(t374, t366); // Fp2 sub coeff 1/1
    let t377 = circuit_add(t375, t376);
    let t378 = circuit_add(t377, t377);
    let t379 = circuit_sub(t375, t376);
    let t380 = circuit_sub(t378, t375);
    let t381 = circuit_sub(t380, t376);
    let t382 = circuit_add(t379, t357); // Fp2 add coeff 0/1
    let t383 = circuit_add(t381, t360); // Fp2 add coeff 1/1
    let t384 = circuit_add(t349, t353); // Fp2 add coeff 0/1
    let t385 = circuit_add(t350, t354); // Fp2 add coeff 1/1
    let t386 = circuit_mul(t280, t384); // Fp2 mul start
    let t387 = circuit_mul(t281, t385);
    let t388 = circuit_sub(t386, t387); // Fp2 mul real part end
    let t389 = circuit_mul(t280, t385);
    let t390 = circuit_mul(t281, t384);
    let t391 = circuit_add(t389, t390); // Fp2 mul imag part end
    let t392 = circuit_sub(t388, t357); // Fp2 sub coeff 0/1
    let t393 = circuit_sub(t391, t360); // Fp2 sub coeff 1/1
    let t394 = circuit_add(t392, t363); // Fp2 add coeff 0/1
    let t395 = circuit_add(t393, t366); // Fp2 add coeff 1/1
    let t396 = circuit_add(t280, t348); // Fp2 add coeff 0/1
    let t397 = circuit_add(t281, t283); // Fp2 add coeff 1/1
    let t398 = circuit_add(t349, t351); // Fp2 add coeff 0/1
    let t399 = circuit_add(t350, t352); // Fp2 add coeff 1/1
    let t400 = circuit_mul(t396, t398); // Fp2 mul start
    let t401 = circuit_mul(t397, t399);
    let t402 = circuit_sub(t400, t401); // Fp2 mul real part end
    let t403 = circuit_mul(t396, t399);
    let t404 = circuit_mul(t397, t398);
    let t405 = circuit_add(t403, t404); // Fp2 mul imag part end
    let t406 = circuit_sub(t402, t357); // Fp2 sub coeff 0/1
    let t407 = circuit_sub(t405, t360); // Fp2 sub coeff 1/1
    let t408 = circuit_sub(t406, t363); // Fp2 sub coeff 0/1
    let t409 = circuit_sub(t407, t366); // Fp2 sub coeff 1/1
    let t410 = circuit_sub(t382, t315); // Fp6 sub coeff 0/5
    let t411 = circuit_sub(t383, t316); // Fp6 sub coeff 1/5
    let t412 = circuit_sub(t408, t341); // Fp6 sub coeff 2/5
    let t413 = circuit_sub(t409, t342); // Fp6 sub coeff 3/5
    let t414 = circuit_sub(t394, t327); // Fp6 sub coeff 4/5
    let t415 = circuit_sub(t395, t328); // Fp6 sub coeff 5/5
    let t416 = circuit_sub(t410, t345); // Fp6 sub coeff 0/5
    let t417 = circuit_sub(t411, t347); // Fp6 sub coeff 1/5
    let t418 = circuit_sub(t412, t181); // Fp6 sub coeff 2/5
    let t419 = circuit_sub(t413, t182); // Fp6 sub coeff 3/5
    let t420 = circuit_sub(t414, t183); // Fp6 sub coeff 4/5
    let t421 = circuit_sub(t415, t184); // Fp6 sub coeff 5/5
    let t422 = circuit_add(t183, t184);
    let t423 = circuit_add(t422, t422);
    let t424 = circuit_sub(t183, t184);
    let t425 = circuit_sub(t423, t183);
    let t426 = circuit_sub(t425, t184);
    let t427 = circuit_add(t424, t315); // Fp6 add coeff 0/5
    let t428 = circuit_add(t426, t316); // Fp6 add coeff 1/5
    let t429 = circuit_add(t345, t341); // Fp6 add coeff 2/5
    let t430 = circuit_add(t347, t342); // Fp6 add coeff 3/5
    let t431 = circuit_add(t181, t327); // Fp6 add coeff 4/5
    let t432 = circuit_add(t182, t328); // Fp6 add coeff 5/5
    let t433 = circuit_mul(t427, t284); // Fp2 mul start
    let t434 = circuit_mul(t428, t285);
    let t435 = circuit_sub(t433, t434); // Fp2 mul real part end
    let t436 = circuit_mul(t427, t285);
    let t437 = circuit_mul(t428, t284);
    let t438 = circuit_add(t436, t437); // Fp2 mul imag part end
    let t439 = circuit_mul(t429, t286); // Fp2 mul start
    let t440 = circuit_mul(t430, t287);
    let t441 = circuit_sub(t439, t440); // Fp2 mul real part end
    let t442 = circuit_mul(t429, t287);
    let t443 = circuit_mul(t430, t286);
    let t444 = circuit_add(t442, t443); // Fp2 mul imag part end
    let t445 = circuit_add(t429, t431); // Fp2 add coeff 0/1
    let t446 = circuit_add(t430, t432); // Fp2 add coeff 1/1
    let t447 = circuit_mul(t286, t445); // Fp2 mul start
    let t448 = circuit_mul(t287, t446);
    let t449 = circuit_sub(t447, t448); // Fp2 mul real part end
    let t450 = circuit_mul(t286, t446);
    let t451 = circuit_mul(t287, t445);
    let t452 = circuit_add(t450, t451); // Fp2 mul imag part end
    let t453 = circuit_sub(t449, t441); // Fp2 sub coeff 0/1
    let t454 = circuit_sub(t452, t444); // Fp2 sub coeff 1/1
    let t455 = circuit_add(t453, t454);
    let t456 = circuit_add(t455, t455);
    let t457 = circuit_sub(t453, t454);
    let t458 = circuit_sub(t456, t453);
    let t459 = circuit_sub(t458, t454);
    let t460 = circuit_add(t457, t435); // Fp2 add coeff 0/1
    let t461 = circuit_add(t459, t438); // Fp2 add coeff 1/1
    let t462 = circuit_add(t427, t431); // Fp2 add coeff 0/1
    let t463 = circuit_add(t428, t432); // Fp2 add coeff 1/1
    let t464 = circuit_mul(t284, t462); // Fp2 mul start
    let t465 = circuit_mul(t285, t463);
    let t466 = circuit_sub(t464, t465); // Fp2 mul real part end
    let t467 = circuit_mul(t284, t463);
    let t468 = circuit_mul(t285, t462);
    let t469 = circuit_add(t467, t468); // Fp2 mul imag part end
    let t470 = circuit_sub(t466, t435); // Fp2 sub coeff 0/1
    let t471 = circuit_sub(t469, t438); // Fp2 sub coeff 1/1
    let t472 = circuit_add(t470, t441); // Fp2 add coeff 0/1
    let t473 = circuit_add(t471, t444); // Fp2 add coeff 1/1
    let t474 = circuit_add(t284, t286); // Fp2 add coeff 0/1
    let t475 = circuit_add(t285, t287); // Fp2 add coeff 1/1
    let t476 = circuit_add(t427, t429); // Fp2 add coeff 0/1
    let t477 = circuit_add(t428, t430); // Fp2 add coeff 1/1
    let t478 = circuit_mul(t474, t476); // Fp2 mul start
    let t479 = circuit_mul(t475, t477);
    let t480 = circuit_sub(t478, t479); // Fp2 mul real part end
    let t481 = circuit_mul(t474, t477);
    let t482 = circuit_mul(t475, t476);
    let t483 = circuit_add(t481, t482); // Fp2 mul imag part end
    let t484 = circuit_sub(t480, t435); // Fp2 sub coeff 0/1
    let t485 = circuit_sub(t483, t438); // Fp2 sub coeff 1/1
    let t486 = circuit_sub(t484, t441); // Fp2 sub coeff 0/1
    let t487 = circuit_sub(t485, t444); // Fp2 sub coeff 1/1
    let t488 = circuit_add(t420, t421);
    let t489 = circuit_add(t488, t488);
    let t490 = circuit_sub(t420, t421);
    let t491 = circuit_sub(t489, t420);
    let t492 = circuit_sub(t491, t421);
    let t493 = circuit_add(in1, t286);
    let t494 = circuit_add(t416, t427); // Fp6 add coeff 0/5
    let t495 = circuit_add(t417, t428); // Fp6 add coeff 1/5
    let t496 = circuit_add(t418, t429); // Fp6 add coeff 2/5
    let t497 = circuit_add(t419, t430); // Fp6 add coeff 3/5
    let t498 = circuit_add(t420, t431); // Fp6 add coeff 4/5
    let t499 = circuit_add(t421, t432); // Fp6 add coeff 5/5
    let t500 = circuit_mul(t494, t284); // Fp2 mul start
    let t501 = circuit_mul(t495, t285);
    let t502 = circuit_sub(t500, t501); // Fp2 mul real part end
    let t503 = circuit_mul(t494, t285);
    let t504 = circuit_mul(t495, t284);
    let t505 = circuit_add(t503, t504); // Fp2 mul imag part end
    let t506 = circuit_mul(t496, t493); // Fp2 mul start
    let t507 = circuit_mul(t497, t287);
    let t508 = circuit_sub(t506, t507); // Fp2 mul real part end
    let t509 = circuit_mul(t496, t287);
    let t510 = circuit_mul(t497, t493);
    let t511 = circuit_add(t509, t510); // Fp2 mul imag part end
    let t512 = circuit_add(t496, t498); // Fp2 add coeff 0/1
    let t513 = circuit_add(t497, t499); // Fp2 add coeff 1/1
    let t514 = circuit_mul(t493, t512); // Fp2 mul start
    let t515 = circuit_mul(t287, t513);
    let t516 = circuit_sub(t514, t515); // Fp2 mul real part end
    let t517 = circuit_mul(t493, t513);
    let t518 = circuit_mul(t287, t512);
    let t519 = circuit_add(t517, t518); // Fp2 mul imag part end
    let t520 = circuit_sub(t516, t508); // Fp2 sub coeff 0/1
    let t521 = circuit_sub(t519, t511); // Fp2 sub coeff 1/1
    let t522 = circuit_add(t520, t521);
    let t523 = circuit_add(t522, t522);
    let t524 = circuit_sub(t520, t521);
    let t525 = circuit_sub(t523, t520);
    let t526 = circuit_sub(t525, t521);
    let t527 = circuit_add(t524, t502); // Fp2 add coeff 0/1
    let t528 = circuit_add(t526, t505); // Fp2 add coeff 1/1
    let t529 = circuit_add(t494, t498); // Fp2 add coeff 0/1
    let t530 = circuit_add(t495, t499); // Fp2 add coeff 1/1
    let t531 = circuit_mul(t284, t529); // Fp2 mul start
    let t532 = circuit_mul(t285, t530);
    let t533 = circuit_sub(t531, t532); // Fp2 mul real part end
    let t534 = circuit_mul(t284, t530);
    let t535 = circuit_mul(t285, t529);
    let t536 = circuit_add(t534, t535); // Fp2 mul imag part end
    let t537 = circuit_sub(t533, t502); // Fp2 sub coeff 0/1
    let t538 = circuit_sub(t536, t505); // Fp2 sub coeff 1/1
    let t539 = circuit_add(t537, t508); // Fp2 add coeff 0/1
    let t540 = circuit_add(t538, t511); // Fp2 add coeff 1/1
    let t541 = circuit_add(t284, t493); // Fp2 add coeff 0/1
    let t542 = circuit_add(t285, t287); // Fp2 add coeff 1/1
    let t543 = circuit_add(t494, t496); // Fp2 add coeff 0/1
    let t544 = circuit_add(t495, t497); // Fp2 add coeff 1/1
    let t545 = circuit_mul(t541, t543); // Fp2 mul start
    let t546 = circuit_mul(t542, t544);
    let t547 = circuit_sub(t545, t546); // Fp2 mul real part end
    let t548 = circuit_mul(t541, t544);
    let t549 = circuit_mul(t542, t543);
    let t550 = circuit_add(t548, t549); // Fp2 mul imag part end
    let t551 = circuit_sub(t547, t502); // Fp2 sub coeff 0/1
    let t552 = circuit_sub(t550, t505); // Fp2 sub coeff 1/1
    let t553 = circuit_sub(t551, t508); // Fp2 sub coeff 0/1
    let t554 = circuit_sub(t552, t511); // Fp2 sub coeff 1/1
    let t555 = circuit_sub(t527, t460); // Fp6 sub coeff 0/5
    let t556 = circuit_sub(t528, t461); // Fp6 sub coeff 1/5
    let t557 = circuit_sub(t553, t486); // Fp6 sub coeff 2/5
    let t558 = circuit_sub(t554, t487); // Fp6 sub coeff 3/5
    let t559 = circuit_sub(t539, t472); // Fp6 sub coeff 4/5
    let t560 = circuit_sub(t540, t473); // Fp6 sub coeff 5/5
    let t561 = circuit_sub(t555, t490); // Fp6 sub coeff 0/5
    let t562 = circuit_sub(t556, t492); // Fp6 sub coeff 1/5
    let t563 = circuit_sub(t557, t416); // Fp6 sub coeff 2/5
    let t564 = circuit_sub(t558, t417); // Fp6 sub coeff 3/5
    let t565 = circuit_sub(t559, t418); // Fp6 sub coeff 4/5
    let t566 = circuit_sub(t560, t419); // Fp6 sub coeff 5/5
    let t567 = circuit_add(t418, t419);
    let t568 = circuit_add(t567, t567);
    let t569 = circuit_sub(t418, t419);
    let t570 = circuit_sub(t568, t418);
    let t571 = circuit_sub(t570, t419);
    let t572 = circuit_add(t569, t460); // Fp6 add coeff 0/5
    let t573 = circuit_add(t571, t461); // Fp6 add coeff 1/5
    let t574 = circuit_add(t490, t486); // Fp6 add coeff 2/5
    let t575 = circuit_add(t492, t487); // Fp6 add coeff 3/5
    let t576 = circuit_add(t416, t472); // Fp6 add coeff 4/5
    let t577 = circuit_add(t417, t473); // Fp6 add coeff 5/5
    let t578 = circuit_add(t260, t261);
    let t579 = circuit_add(t578, t270);
    let t580 = circuit_add(t579, t271);

    let modulus = get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (
        t580, t572, t573, t574, t575, t576, t577, t561, t562, t563, t564, t565, t566,
    )
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs.next_2([0x1, 0x0, 0x0, 0x0]); // in1
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(yInv_0); // in2
    circuit_inputs = circuit_inputs.next_2(xNegOverY_0); // in3
    circuit_inputs = circuit_inputs.next_2(Q_0.x0); // in4
    circuit_inputs = circuit_inputs.next_2(Q_0.x1); // in5
    circuit_inputs = circuit_inputs.next_2(Q_0.y0); // in6
    circuit_inputs = circuit_inputs.next_2(Q_0.y1); // in7
    circuit_inputs = circuit_inputs.next_2(Q_or_Q_neg_0.x0); // in8
    circuit_inputs = circuit_inputs.next_2(Q_or_Q_neg_0.x1); // in9
    circuit_inputs = circuit_inputs.next_2(Q_or_Q_neg_0.y0); // in10
    circuit_inputs = circuit_inputs.next_2(Q_or_Q_neg_0.y1); // in11
    circuit_inputs = circuit_inputs.next_2(M_i.c0b0a0); // in12
    circuit_inputs = circuit_inputs.next_2(M_i.c0b0a1); // in13
    circuit_inputs = circuit_inputs.next_2(M_i.c0b1a0); // in14
    circuit_inputs = circuit_inputs.next_2(M_i.c0b1a1); // in15
    circuit_inputs = circuit_inputs.next_2(M_i.c0b2a0); // in16
    circuit_inputs = circuit_inputs.next_2(M_i.c0b2a1); // in17
    circuit_inputs = circuit_inputs.next_2(M_i.c1b0a0); // in18
    circuit_inputs = circuit_inputs.next_2(M_i.c1b0a1); // in19
    circuit_inputs = circuit_inputs.next_2(M_i.c1b1a0); // in20
    circuit_inputs = circuit_inputs.next_2(M_i.c1b1a1); // in21
    circuit_inputs = circuit_inputs.next_2(M_i.c1b2a0); // in22
    circuit_inputs = circuit_inputs.next_2(M_i.c1b2a1); // in23

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let Q0: G2Point = G2Point {
        x0: outputs.get_output(t260),
        x1: outputs.get_output(t261),
        y0: outputs.get_output(t270),
        y1: outputs.get_output(t271),
    };
    let Mi_plus_one: E12T = E12T {
        c0b0a0: outputs.get_output(t572),
        c0b0a1: outputs.get_output(t573),
        c0b1a0: outputs.get_output(t574),
        c0b1a1: outputs.get_output(t575),
        c0b2a0: outputs.get_output(t576),
        c0b2a1: outputs.get_output(t577),
        c1b0a0: outputs.get_output(t561),
        c1b0a1: outputs.get_output(t562),
        c1b1a0: outputs.get_output(t563),
        c1b1a1: outputs.get_output(t564),
        c1b2a0: outputs.get_output(t565),
        c1b2a1: outputs.get_output(t566),
    };
    return (Q0, Mi_plus_one);
}
#[inline(always)]
pub fn run_BLS12_381_TOWER_MILLER_INIT_BIT_1P_circuit(
    yInv_0: u384, xNegOverY_0: u384, Q_0: G2Point,
) -> (G2Point, u384, u384, u384, u384, u384, u384, u384, u384, u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x3
    let in1 = CE::<CI<1>> {}; // 0x6
    let in2 = CE::<CI<2>> {}; // 0x0
    let in3 = CE::<CI<3>> {}; // 0x1

    // INPUT stack
    let (in4, in5, in6) = (CE::<CI<4>> {}, CE::<CI<5>> {}, CE::<CI<6>> {});
    let (in7, in8, in9) = (CE::<CI<7>> {}, CE::<CI<8>> {}, CE::<CI<9>> {});
    let t0 = circuit_add(in6, in7);
    let t1 = circuit_sub(in6, in7);
    let t2 = circuit_mul(t0, t1);
    let t3 = circuit_mul(in6, in7);
    let t4 = circuit_mul(t2, in0);
    let t5 = circuit_mul(t3, in1);
    let t6 = circuit_add(in8, in8); // Fp2 add coeff 0/1
    let t7 = circuit_add(in9, in9); // Fp2 add coeff 1/1
    let t8 = circuit_mul(t6, t6); // Fp2 Inv start
    let t9 = circuit_mul(t7, t7);
    let t10 = circuit_add(t8, t9);
    let t11 = circuit_inverse(t10);
    let t12 = circuit_mul(t6, t11); // Fp2 Inv real part end
    let t13 = circuit_mul(t7, t11);
    let t14 = circuit_sub(in2, t13); // Fp2 Inv imag part end
    let t15 = circuit_mul(t4, t12); // Fp2 mul start
    let t16 = circuit_mul(t5, t14);
    let t17 = circuit_sub(t15, t16); // Fp2 mul real part end
    let t18 = circuit_mul(t4, t14);
    let t19 = circuit_mul(t5, t12);
    let t20 = circuit_add(t18, t19); // Fp2 mul imag part end
    let t21 = circuit_mul(t17, in6); // Fp2 mul start
    let t22 = circuit_mul(t20, in7);
    let t23 = circuit_sub(t21, t22); // Fp2 mul real part end
    let t24 = circuit_mul(t17, in7);
    let t25 = circuit_mul(t20, in6);
    let t26 = circuit_add(t24, t25); // Fp2 mul imag part end
    let t27 = circuit_sub(t23, in8); // Fp2 sub coeff 0/1
    let t28 = circuit_sub(t26, in9); // Fp2 sub coeff 1/1
    let t29 = circuit_add(t17, t20);
    let t30 = circuit_sub(t17, t20);
    let t31 = circuit_mul(t29, t30);
    let t32 = circuit_mul(t17, t20);
    let t33 = circuit_add(t32, t32);
    let t34 = circuit_add(in6, in6); // Fp2 add coeff 0/1
    let t35 = circuit_add(in7, in7); // Fp2 add coeff 1/1
    let t36 = circuit_sub(t31, t34); // Fp2 sub coeff 0/1
    let t37 = circuit_sub(t33, t35); // Fp2 sub coeff 1/1
    let t38 = circuit_sub(in6, t36); // Fp2 sub coeff 0/1
    let t39 = circuit_sub(in7, t37); // Fp2 sub coeff 1/1
    let t40 = circuit_mul(t38, t38); // Fp2 Inv start
    let t41 = circuit_mul(t39, t39);
    let t42 = circuit_add(t40, t41);
    let t43 = circuit_inverse(t42);
    let t44 = circuit_mul(t38, t43); // Fp2 Inv real part end
    let t45 = circuit_mul(t39, t43);
    let t46 = circuit_sub(in2, t45); // Fp2 Inv imag part end
    let t47 = circuit_mul(t6, t44); // Fp2 mul start
    let t48 = circuit_mul(t7, t46);
    let t49 = circuit_sub(t47, t48); // Fp2 mul real part end
    let t50 = circuit_mul(t6, t46);
    let t51 = circuit_mul(t7, t44);
    let t52 = circuit_add(t50, t51); // Fp2 mul imag part end
    let t53 = circuit_sub(t49, t17); // Fp2 sub coeff 0/1
    let t54 = circuit_sub(t52, t20); // Fp2 sub coeff 1/1
    let t55 = circuit_mul(t53, in6); // Fp2 mul start
    let t56 = circuit_mul(t54, in7);
    let t57 = circuit_sub(t55, t56); // Fp2 mul real part end
    let t58 = circuit_mul(t53, in7);
    let t59 = circuit_mul(t54, in6);
    let t60 = circuit_add(t58, t59); // Fp2 mul imag part end
    let t61 = circuit_sub(t57, in8); // Fp2 sub coeff 0/1
    let t62 = circuit_sub(t60, in9); // Fp2 sub coeff 1/1
    let t63 = circuit_add(t53, t54);
    let t64 = circuit_sub(t53, t54);
    let t65 = circuit_mul(t63, t64);
    let t66 = circuit_mul(t53, t54);
    let t67 = circuit_add(t66, t66);
    let t68 = circuit_add(in6, t36); // Fp2 add coeff 0/1
    let t69 = circuit_add(in7, t37); // Fp2 add coeff 1/1
    let t70 = circuit_sub(t65, t68); // Fp2 sub coeff 0/1
    let t71 = circuit_sub(t67, t69); // Fp2 sub coeff 1/1
    let t72 = circuit_sub(in6, t70); // Fp2 sub coeff 0/1
    let t73 = circuit_sub(in7, t71); // Fp2 sub coeff 1/1
    let t74 = circuit_mul(t53, t72); // Fp2 mul start
    let t75 = circuit_mul(t54, t73);
    let t76 = circuit_sub(t74, t75); // Fp2 mul real part end
    let t77 = circuit_mul(t53, t73);
    let t78 = circuit_mul(t54, t72);
    let t79 = circuit_add(t77, t78); // Fp2 mul imag part end
    let t80 = circuit_sub(t76, in8); // Fp2 sub coeff 0/1
    let t81 = circuit_sub(t79, in9); // Fp2 sub coeff 1/1
    let t82 = circuit_mul(t27, in4);
    let t83 = circuit_mul(t28, in4);
    let t84 = circuit_mul(t17, in5);
    let t85 = circuit_mul(t20, in5);
    let t86 = circuit_mul(t61, in4);
    let t87 = circuit_mul(t62, in4);
    let t88 = circuit_mul(t53, in5);
    let t89 = circuit_mul(t54, in5);
    let t90 = circuit_mul(t86, t82); // Fp2 mul start
    let t91 = circuit_mul(t87, t83);
    let t92 = circuit_sub(t90, t91); // Fp2 mul real part end
    let t93 = circuit_mul(t86, t83);
    let t94 = circuit_mul(t87, t82);
    let t95 = circuit_add(t93, t94); // Fp2 mul imag part end
    let t96 = circuit_mul(t88, t84); // Fp2 mul start
    let t97 = circuit_mul(t89, t85);
    let t98 = circuit_sub(t96, t97); // Fp2 mul real part end
    let t99 = circuit_mul(t88, t85);
    let t100 = circuit_mul(t89, t84);
    let t101 = circuit_add(t99, t100); // Fp2 mul imag part end
    let t102 = circuit_add(t82, t86); // Fp2 add coeff 0/1
    let t103 = circuit_add(t83, t87); // Fp2 add coeff 1/1
    let t104 = circuit_add(t86, t88); // Fp2 add coeff 0/1
    let t105 = circuit_add(t87, t89); // Fp2 add coeff 1/1
    let t106 = circuit_add(t82, t84); // Fp2 add coeff 0/1
    let t107 = circuit_add(t83, t85); // Fp2 add coeff 1/1
    let t108 = circuit_mul(t106, t104); // Fp2 mul start
    let t109 = circuit_mul(t107, t105);
    let t110 = circuit_sub(t108, t109); // Fp2 mul real part end
    let t111 = circuit_mul(t106, t105);
    let t112 = circuit_mul(t107, t104);
    let t113 = circuit_add(t111, t112); // Fp2 mul imag part end
    let t114 = circuit_sub(t110, t92); // Fp2 sub coeff 0/1
    let t115 = circuit_sub(t113, t95); // Fp2 sub coeff 1/1
    let t116 = circuit_sub(t114, t98); // Fp2 sub coeff 0/1
    let t117 = circuit_sub(t115, t101); // Fp2 sub coeff 1/1
    let t118 = circuit_add(t84, t88); // Fp2 add coeff 0/1
    let t119 = circuit_add(t85, t89); // Fp2 add coeff 1/1
    let t120 = circuit_add(in3, in2);
    let t121 = circuit_add(t120, t120);
    let t122 = circuit_sub(in3, in2);
    let t123 = circuit_sub(t121, in3);
    let t124 = circuit_sub(t123, in2);
    let t125 = circuit_add(t122, t92); // Fp2 add coeff 0/1
    let t126 = circuit_add(t124, t95); // Fp2 add coeff 1/1

    let modulus = get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (
        t70, t71, t80, t81, t125, t126, t116, t117, t98, t101, t102, t103, t118, t119,
    )
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x3, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs.next_2([0x6, 0x0, 0x0, 0x0]); // in1
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in2
    circuit_inputs = circuit_inputs.next_2([0x1, 0x0, 0x0, 0x0]); // in3
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(yInv_0); // in4
    circuit_inputs = circuit_inputs.next_2(xNegOverY_0); // in5
    circuit_inputs = circuit_inputs.next_2(Q_0.x0); // in6
    circuit_inputs = circuit_inputs.next_2(Q_0.x1); // in7
    circuit_inputs = circuit_inputs.next_2(Q_0.y0); // in8
    circuit_inputs = circuit_inputs.next_2(Q_0.y1); // in9

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let Q0: G2Point = G2Point {
        x0: outputs.get_output(t70),
        x1: outputs.get_output(t71),
        y0: outputs.get_output(t80),
        y1: outputs.get_output(t81),
    };
    let c0b0a0: u384 = outputs.get_output(t125);
    let c0b0a1: u384 = outputs.get_output(t126);
    let c0b1a0: u384 = outputs.get_output(t116);
    let c0b1a1: u384 = outputs.get_output(t117);
    let c0b2a0: u384 = outputs.get_output(t98);
    let c0b2a1: u384 = outputs.get_output(t101);
    let c1b1a0: u384 = outputs.get_output(t102);
    let c1b1a1: u384 = outputs.get_output(t103);
    let c1b2a0: u384 = outputs.get_output(t118);
    let c1b2a1: u384 = outputs.get_output(t119);
    return (Q0, c0b0a0, c0b0a1, c0b1a0, c0b1a1, c0b2a0, c0b2a1, c1b1a0, c1b1a1, c1b2a0, c1b2a1);
}
#[inline(always)]
pub fn run_BN254_E12T_CYCLOTOMIC_SQUARE_circuit(M: E12T) -> (E12T,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0xa
    let in1 = CE::<CI<1>> {}; // 0x9

    // INPUT stack
    let (in2, in3, in4) = (CE::<CI<2>> {}, CE::<CI<3>> {}, CE::<CI<4>> {});
    let (in5, in6, in7) = (CE::<CI<5>> {}, CE::<CI<6>> {}, CE::<CI<7>> {});
    let (in8, in9, in10) = (CE::<CI<8>> {}, CE::<CI<9>> {}, CE::<CI<10>> {});
    let (in11, in12, in13) = (CE::<CI<11>> {}, CE::<CI<12>> {}, CE::<CI<13>> {});
    let t0 = circuit_add(in10, in11);
    let t1 = circuit_sub(in10, in11);
    let t2 = circuit_mul(t0, t1);
    let t3 = circuit_mul(in10, in11);
    let t4 = circuit_add(t3, t3);
    let t5 = circuit_add(in2, in3);
    let t6 = circuit_sub(in2, in3);
    let t7 = circuit_mul(t5, t6);
    let t8 = circuit_mul(in2, in3);
    let t9 = circuit_add(t8, t8);
    let t10 = circuit_add(in10, in2); // Fp2 add coeff 0/1
    let t11 = circuit_add(in11, in3); // Fp2 add coeff 1/1
    let t12 = circuit_add(t10, t11);
    let t13 = circuit_sub(t10, t11);
    let t14 = circuit_mul(t12, t13);
    let t15 = circuit_mul(t10, t11);
    let t16 = circuit_add(t15, t15);
    let t17 = circuit_sub(t14, t2); // Fp2 sub coeff 0/1
    let t18 = circuit_sub(t16, t4); // Fp2 sub coeff 1/1
    let t19 = circuit_sub(t17, t7); // Fp2 sub coeff 0/1
    let t20 = circuit_sub(t18, t9); // Fp2 sub coeff 1/1
    let t21 = circuit_add(in6, in7);
    let t22 = circuit_sub(in6, in7);
    let t23 = circuit_mul(t21, t22);
    let t24 = circuit_mul(in6, in7);
    let t25 = circuit_add(t24, t24);
    let t26 = circuit_add(in8, in9);
    let t27 = circuit_sub(in8, in9);
    let t28 = circuit_mul(t26, t27);
    let t29 = circuit_mul(in8, in9);
    let t30 = circuit_add(t29, t29);
    let t31 = circuit_add(in6, in8); // Fp2 add coeff 0/1
    let t32 = circuit_add(in7, in9); // Fp2 add coeff 1/1
    let t33 = circuit_add(t31, t32);
    let t34 = circuit_sub(t31, t32);
    let t35 = circuit_mul(t33, t34);
    let t36 = circuit_mul(t31, t32);
    let t37 = circuit_add(t36, t36);
    let t38 = circuit_sub(t35, t23); // Fp2 sub coeff 0/1
    let t39 = circuit_sub(t37, t25); // Fp2 sub coeff 1/1
    let t40 = circuit_sub(t38, t28); // Fp2 sub coeff 0/1
    let t41 = circuit_sub(t39, t30); // Fp2 sub coeff 1/1
    let t42 = circuit_add(in12, in13);
    let t43 = circuit_sub(in12, in13);
    let t44 = circuit_mul(t42, t43);
    let t45 = circuit_mul(in12, in13);
    let t46 = circuit_add(t45, t45);
    let t47 = circuit_add(in4, in5);
    let t48 = circuit_sub(in4, in5);
    let t49 = circuit_mul(t47, t48);
    let t50 = circuit_mul(in4, in5);
    let t51 = circuit_add(t50, t50);
    let t52 = circuit_add(in12, in4); // Fp2 add coeff 0/1
    let t53 = circuit_add(in13, in5); // Fp2 add coeff 1/1
    let t54 = circuit_add(t52, t53);
    let t55 = circuit_sub(t52, t53);
    let t56 = circuit_mul(t54, t55);
    let t57 = circuit_mul(t52, t53);
    let t58 = circuit_add(t57, t57);
    let t59 = circuit_sub(t56, t44); // Fp2 sub coeff 0/1
    let t60 = circuit_sub(t58, t46); // Fp2 sub coeff 1/1
    let t61 = circuit_sub(t59, t49); // Fp2 sub coeff 0/1
    let t62 = circuit_sub(t60, t51); // Fp2 sub coeff 1/1
    let t63 = circuit_add(t61, t62);
    let t64 = circuit_mul(t63, in0);
    let t65 = circuit_mul(t61, in1);
    let t66 = circuit_sub(t65, t62);
    let t67 = circuit_sub(t64, t65);
    let t68 = circuit_sub(t67, t62);
    let t69 = circuit_add(t2, t4);
    let t70 = circuit_mul(t69, in0);
    let t71 = circuit_mul(t2, in1);
    let t72 = circuit_sub(t71, t4);
    let t73 = circuit_sub(t70, t71);
    let t74 = circuit_sub(t73, t4);
    let t75 = circuit_add(t72, t7); // Fp2 add coeff 0/1
    let t76 = circuit_add(t74, t9); // Fp2 add coeff 1/1
    let t77 = circuit_add(t23, t25);
    let t78 = circuit_mul(t77, in0);
    let t79 = circuit_mul(t23, in1);
    let t80 = circuit_sub(t79, t25);
    let t81 = circuit_sub(t78, t79);
    let t82 = circuit_sub(t81, t25);
    let t83 = circuit_add(t80, t28); // Fp2 add coeff 0/1
    let t84 = circuit_add(t82, t30); // Fp2 add coeff 1/1
    let t85 = circuit_add(t44, t46);
    let t86 = circuit_mul(t85, in0);
    let t87 = circuit_mul(t44, in1);
    let t88 = circuit_sub(t87, t46);
    let t89 = circuit_sub(t86, t87);
    let t90 = circuit_sub(t89, t46);
    let t91 = circuit_add(t88, t49); // Fp2 add coeff 0/1
    let t92 = circuit_add(t90, t51); // Fp2 add coeff 1/1
    let t93 = circuit_sub(t75, in2); // Fp2 sub coeff 0/1
    let t94 = circuit_sub(t76, in3); // Fp2 sub coeff 1/1
    let t95 = circuit_add(t93, t93); // Fp2 add coeff 0/1
    let t96 = circuit_add(t94, t94); // Fp2 add coeff 1/1
    let t97 = circuit_add(t95, t75); // Fp2 add coeff 0/1
    let t98 = circuit_add(t96, t76); // Fp2 add coeff 1/1
    let t99 = circuit_sub(t83, in4); // Fp2 sub coeff 0/1
    let t100 = circuit_sub(t84, in5); // Fp2 sub coeff 1/1
    let t101 = circuit_add(t99, t99); // Fp2 add coeff 0/1
    let t102 = circuit_add(t100, t100); // Fp2 add coeff 1/1
    let t103 = circuit_add(t101, t83); // Fp2 add coeff 0/1
    let t104 = circuit_add(t102, t84); // Fp2 add coeff 1/1
    let t105 = circuit_sub(t91, in6); // Fp2 sub coeff 0/1
    let t106 = circuit_sub(t92, in7); // Fp2 sub coeff 1/1
    let t107 = circuit_add(t105, t105); // Fp2 add coeff 0/1
    let t108 = circuit_add(t106, t106); // Fp2 add coeff 1/1
    let t109 = circuit_add(t107, t91); // Fp2 add coeff 0/1
    let t110 = circuit_add(t108, t92); // Fp2 add coeff 1/1
    let t111 = circuit_add(t66, in8); // Fp2 add coeff 0/1
    let t112 = circuit_add(t68, in9); // Fp2 add coeff 1/1
    let t113 = circuit_add(t111, t111); // Fp2 add coeff 0/1
    let t114 = circuit_add(t112, t112); // Fp2 add coeff 1/1
    let t115 = circuit_add(t113, t66); // Fp2 add coeff 0/1
    let t116 = circuit_add(t114, t68); // Fp2 add coeff 1/1
    let t117 = circuit_add(t19, in10); // Fp2 add coeff 0/1
    let t118 = circuit_add(t20, in11); // Fp2 add coeff 1/1
    let t119 = circuit_add(t117, t117); // Fp2 add coeff 0/1
    let t120 = circuit_add(t118, t118); // Fp2 add coeff 1/1
    let t121 = circuit_add(t119, t19); // Fp2 add coeff 0/1
    let t122 = circuit_add(t120, t20); // Fp2 add coeff 1/1
    let t123 = circuit_add(t40, in12); // Fp2 add coeff 0/1
    let t124 = circuit_add(t41, in13); // Fp2 add coeff 1/1
    let t125 = circuit_add(t123, t123); // Fp2 add coeff 0/1
    let t126 = circuit_add(t124, t124); // Fp2 add coeff 1/1
    let t127 = circuit_add(t125, t40); // Fp2 add coeff 0/1
    let t128 = circuit_add(t126, t41); // Fp2 add coeff 1/1

    let modulus = get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (t97, t98, t103, t104, t109, t110, t115, t116, t121, t122, t127, t128)
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0xa, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs.next_2([0x9, 0x0, 0x0, 0x0]); // in1
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(M.c0b0a0); // in2
    circuit_inputs = circuit_inputs.next_2(M.c0b0a1); // in3
    circuit_inputs = circuit_inputs.next_2(M.c0b1a0); // in4
    circuit_inputs = circuit_inputs.next_2(M.c0b1a1); // in5
    circuit_inputs = circuit_inputs.next_2(M.c0b2a0); // in6
    circuit_inputs = circuit_inputs.next_2(M.c0b2a1); // in7
    circuit_inputs = circuit_inputs.next_2(M.c1b0a0); // in8
    circuit_inputs = circuit_inputs.next_2(M.c1b0a1); // in9
    circuit_inputs = circuit_inputs.next_2(M.c1b1a0); // in10
    circuit_inputs = circuit_inputs.next_2(M.c1b1a1); // in11
    circuit_inputs = circuit_inputs.next_2(M.c1b2a0); // in12
    circuit_inputs = circuit_inputs.next_2(M.c1b2a1); // in13

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: E12T = E12T {
        c0b0a0: outputs.get_output(t97),
        c0b0a1: outputs.get_output(t98),
        c0b1a0: outputs.get_output(t103),
        c0b1a1: outputs.get_output(t104),
        c0b2a0: outputs.get_output(t109),
        c0b2a1: outputs.get_output(t110),
        c1b0a0: outputs.get_output(t115),
        c1b0a1: outputs.get_output(t116),
        c1b1a0: outputs.get_output(t121),
        c1b1a1: outputs.get_output(t122),
        c1b2a0: outputs.get_output(t127),
        c1b2a1: outputs.get_output(t128),
    };
    return (res,);
}
#[inline(always)]
pub fn run_BN254_E12T_FROBENIUS_CUBE_circuit(M: E12T) -> (E12T,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0
    let in1 = CE::<CI<1>> {}; // 0x856e078b755ef0abaff1c77959f25ac805ffd3d5d6942d37b746ee87bdcfb6d
    let in2 = CE::<CI<2>> {}; // 0x4f1de41b3d1766fa9f30e6dec26094f0fdf31bf98ff2631380cab2baaa586de
    let in3 = CE::<CI<3>> {}; // 0xbc58c6611c08dab19bee0f7b5b2444ee633094575b06bcb0e1a92bc3ccbf066
    let in4 = CE::<CI<4>> {}; // 0x23d5e999e1910a12feb0f6ef0cd21d04a44a9e08737f96e55fe3ed9d730c239f
    let in5 = CE::<CI<5>> {}; // 0x19dc81cfcc82e4bbefe9608cd0acaa90894cb38dbe55d24ae86f7d391ed4a67f
    let in6 = CE::<CI<6>> {}; // 0xabf8b60be77d7306cbeee33576139d7f03a5e397d439ec7694aa2bf4c0c101
    let in7 = CE::<CI<7>> {}; // 0x2a275b6d9896aa4cdbf17f1dca9e5ea3bbd689a3bea870f45fcc8ad066dce9ed
    let in8 = CE::<CI<8>> {}; // 0x28a411b634f09b8fb14b900e9507e9327600ecc7d8cf6ebab94d0cb3b2594c64
    let in9 = CE::<CI<9>> {}; // 0x13c49044952c0905711699fa3b4d3f692ed68098967c84a5ebde847076261b43
    let in10 = CE::<
        CI<10>,
    > {}; // 0x16db366a59b1dd0b9fb1b2282a48633d3e2ddaea200280211f25041384282499

    // INPUT stack
    let (in11, in12, in13) = (CE::<CI<11>> {}, CE::<CI<12>> {}, CE::<CI<13>> {});
    let (in14, in15, in16) = (CE::<CI<14>> {}, CE::<CI<15>> {}, CE::<CI<16>> {});
    let (in17, in18, in19) = (CE::<CI<17>> {}, CE::<CI<18>> {}, CE::<CI<19>> {});
    let (in20, in21, in22) = (CE::<CI<20>> {}, CE::<CI<21>> {}, CE::<CI<22>> {});
    let t0 = circuit_sub(in0, in12);
    let t1 = circuit_add(in11, in0);
    let t2 = circuit_sub(in0, in14);
    let t3 = circuit_sub(in0, in16);
    let t4 = circuit_sub(in0, in18);
    let t5 = circuit_sub(in0, in20);
    let t6 = circuit_sub(in0, in22);
    let t7 = circuit_mul(in1, in13); // Fp2 mul start
    let t8 = circuit_mul(in2, t2);
    let t9 = circuit_sub(t7, t8); // Fp2 mul real part end
    let t10 = circuit_mul(in1, t2);
    let t11 = circuit_mul(in2, in13);
    let t12 = circuit_add(t10, t11); // Fp2 mul imag part end
    let t13 = circuit_mul(in3, in15); // Fp2 mul start
    let t14 = circuit_mul(in4, t3);
    let t15 = circuit_sub(t13, t14); // Fp2 mul real part end
    let t16 = circuit_mul(in3, t3);
    let t17 = circuit_mul(in4, in15);
    let t18 = circuit_add(t16, t17); // Fp2 mul imag part end
    let t19 = circuit_mul(in5, in17); // Fp2 mul start
    let t20 = circuit_mul(in6, t4);
    let t21 = circuit_sub(t19, t20); // Fp2 mul real part end
    let t22 = circuit_mul(in5, t4);
    let t23 = circuit_mul(in6, in17);
    let t24 = circuit_add(t22, t23); // Fp2 mul imag part end
    let t25 = circuit_mul(in7, in19); // Fp2 mul start
    let t26 = circuit_mul(in8, t5);
    let t27 = circuit_sub(t25, t26); // Fp2 mul real part end
    let t28 = circuit_mul(in7, t5);
    let t29 = circuit_mul(in8, in19);
    let t30 = circuit_add(t28, t29); // Fp2 mul imag part end
    let t31 = circuit_mul(in9, in21); // Fp2 mul start
    let t32 = circuit_mul(in10, t6);
    let t33 = circuit_sub(t31, t32); // Fp2 mul real part end
    let t34 = circuit_mul(in9, t6);
    let t35 = circuit_mul(in10, in21);
    let t36 = circuit_add(t34, t35); // Fp2 mul imag part end

    let modulus = get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (t1, t0, t9, t12, t15, t18, t21, t24, t27, t30, t33, t36).new_inputs();
    // Prefill constants:

    circuit_inputs = circuit_inputs
        .next_span(E12T_FROBENIUS_CUBE_BN254_CONSTANTS.span()); // in0 - in10

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(M.c0b0a0); // in11
    circuit_inputs = circuit_inputs.next_2(M.c0b0a1); // in12
    circuit_inputs = circuit_inputs.next_2(M.c0b1a0); // in13
    circuit_inputs = circuit_inputs.next_2(M.c0b1a1); // in14
    circuit_inputs = circuit_inputs.next_2(M.c0b2a0); // in15
    circuit_inputs = circuit_inputs.next_2(M.c0b2a1); // in16
    circuit_inputs = circuit_inputs.next_2(M.c1b0a0); // in17
    circuit_inputs = circuit_inputs.next_2(M.c1b0a1); // in18
    circuit_inputs = circuit_inputs.next_2(M.c1b1a0); // in19
    circuit_inputs = circuit_inputs.next_2(M.c1b1a1); // in20
    circuit_inputs = circuit_inputs.next_2(M.c1b2a0); // in21
    circuit_inputs = circuit_inputs.next_2(M.c1b2a1); // in22

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: E12T = E12T {
        c0b0a0: outputs.get_output(t1),
        c0b0a1: outputs.get_output(t0),
        c0b1a0: outputs.get_output(t9),
        c0b1a1: outputs.get_output(t12),
        c0b2a0: outputs.get_output(t15),
        c0b2a1: outputs.get_output(t18),
        c1b0a0: outputs.get_output(t21),
        c1b0a1: outputs.get_output(t24),
        c1b1a0: outputs.get_output(t27),
        c1b1a1: outputs.get_output(t30),
        c1b2a0: outputs.get_output(t33),
        c1b2a1: outputs.get_output(t36),
    };
    return (res,);
}
const E12T_FROBENIUS_CUBE_BN254_CONSTANTS: [u384; 11] = [
    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 {
        limb0: 0x5d6942d37b746ee87bdcfb6d,
        limb1: 0xbaff1c77959f25ac805ffd3d,
        limb2: 0x856e078b755ef0a,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x98ff2631380cab2baaa586de,
        limb1: 0xa9f30e6dec26094f0fdf31bf,
        limb2: 0x4f1de41b3d1766f,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x75b06bcb0e1a92bc3ccbf066,
        limb1: 0x19bee0f7b5b2444ee6330945,
        limb2: 0xbc58c6611c08dab,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x737f96e55fe3ed9d730c239f,
        limb1: 0xfeb0f6ef0cd21d04a44a9e08,
        limb2: 0x23d5e999e1910a12,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xbe55d24ae86f7d391ed4a67f,
        limb1: 0xefe9608cd0acaa90894cb38d,
        limb2: 0x19dc81cfcc82e4bb,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x97d439ec7694aa2bf4c0c101,
        limb1: 0x6cbeee33576139d7f03a5e3,
        limb2: 0xabf8b60be77d73,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xbea870f45fcc8ad066dce9ed,
        limb1: 0xdbf17f1dca9e5ea3bbd689a3,
        limb2: 0x2a275b6d9896aa4c,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xd8cf6ebab94d0cb3b2594c64,
        limb1: 0xb14b900e9507e9327600ecc7,
        limb2: 0x28a411b634f09b8f,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x967c84a5ebde847076261b43,
        limb1: 0x711699fa3b4d3f692ed68098,
        limb2: 0x13c49044952c0905,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x200280211f25041384282499,
        limb1: 0x9fb1b2282a48633d3e2ddaea,
        limb2: 0x16db366a59b1dd0b,
        limb3: 0x0,
    },
];
#[inline(always)]
pub fn run_BN254_E12T_FROBENIUS_SQUARE_circuit(M: E12T) -> (E12T,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0
    let in1 = CE::<CI<1>> {}; // 0x30644e72e131a0295e6dd9e7e0acccb0c28f069fbb966e3de4bd44e5607cfd48
    let in2 = CE::<CI<2>> {}; // 0x59e26bcea0d48bacd4f263f1acdb5c4f5763473177fffffe
    let in3 = CE::<CI<3>> {}; // 0x30644e72e131a0295e6dd9e7e0acccb0c28f069fbb966e3de4bd44e5607cfd49
    let in4 = CE::<CI<4>> {}; // -0x1 % p
    let in5 = CE::<CI<5>> {}; // 0x59e26bcea0d48bacd4f263f1acdb5c4f5763473177ffffff

    // INPUT stack
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13, in14) = (CE::<CI<12>> {}, CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16, in17) = (CE::<CI<15>> {}, CE::<CI<16>> {}, CE::<CI<17>> {});
    let t0 = circuit_add(in6, in0);
    let t1 = circuit_add(in7, in0);
    let t2 = circuit_mul(in1, in8);
    let t3 = circuit_mul(in1, in9);
    let t4 = circuit_mul(in2, in10);
    let t5 = circuit_mul(in2, in11);
    let t6 = circuit_mul(in3, in12);
    let t7 = circuit_mul(in3, in13);
    let t8 = circuit_mul(in4, in14);
    let t9 = circuit_mul(in4, in15);
    let t10 = circuit_mul(in5, in16);
    let t11 = circuit_mul(in5, in17);

    let modulus = get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs
        .next_2(
            [0xbb966e3de4bd44e5607cfd48, 0x5e6dd9e7e0acccb0c28f069f, 0x30644e72e131a029, 0x0],
        ); // in1
    circuit_inputs = circuit_inputs
        .next_2([0xacdb5c4f5763473177fffffe, 0x59e26bcea0d48bacd4f263f1, 0x0, 0x0]); // in2
    circuit_inputs = circuit_inputs
        .next_2(
            [0xbb966e3de4bd44e5607cfd49, 0x5e6dd9e7e0acccb0c28f069f, 0x30644e72e131a029, 0x0],
        ); // in3
    circuit_inputs = circuit_inputs
        .next_2(
            [0x6871ca8d3c208c16d87cfd46, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0],
        ); // in4
    circuit_inputs = circuit_inputs
        .next_2([0xacdb5c4f5763473177ffffff, 0x59e26bcea0d48bacd4f263f1, 0x0, 0x0]); // in5
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(M.c0b0a0); // in6
    circuit_inputs = circuit_inputs.next_2(M.c0b0a1); // in7
    circuit_inputs = circuit_inputs.next_2(M.c0b1a0); // in8
    circuit_inputs = circuit_inputs.next_2(M.c0b1a1); // in9
    circuit_inputs = circuit_inputs.next_2(M.c0b2a0); // in10
    circuit_inputs = circuit_inputs.next_2(M.c0b2a1); // in11
    circuit_inputs = circuit_inputs.next_2(M.c1b0a0); // in12
    circuit_inputs = circuit_inputs.next_2(M.c1b0a1); // in13
    circuit_inputs = circuit_inputs.next_2(M.c1b1a0); // in14
    circuit_inputs = circuit_inputs.next_2(M.c1b1a1); // in15
    circuit_inputs = circuit_inputs.next_2(M.c1b2a0); // in16
    circuit_inputs = circuit_inputs.next_2(M.c1b2a1); // in17

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: E12T = E12T {
        c0b0a0: outputs.get_output(t0),
        c0b0a1: outputs.get_output(t1),
        c0b1a0: outputs.get_output(t2),
        c0b1a1: outputs.get_output(t3),
        c0b2a0: outputs.get_output(t4),
        c0b2a1: outputs.get_output(t5),
        c1b0a0: outputs.get_output(t6),
        c1b0a1: outputs.get_output(t7),
        c1b1a0: outputs.get_output(t8),
        c1b1a1: outputs.get_output(t9),
        c1b2a0: outputs.get_output(t10),
        c1b2a1: outputs.get_output(t11),
    };
    return (res,);
}
#[inline(always)]
pub fn run_BN254_E12T_FROBENIUS_circuit(M: E12T) -> (E12T,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0
    let in1 = CE::<CI<1>> {}; // 0x2fb347984f7911f74c0bec3cf559b143b78cc310c2c3330c99e39557176f553d
    let in2 = CE::<CI<2>> {}; // 0x16c9e55061ebae204ba4cc8bd75a079432ae2a1d0b7c9dce1665d51c640fcba2
    let in3 = CE::<CI<3>> {}; // 0x5b54f5e64eea80180f3c0b75a181e84d33365f7be94ec72848a1f55921ea762
    let in4 = CE::<CI<4>> {}; // 0x2c145edbe7fd8aee9f3a80b03b0b1c923685d2ea1bdec763c13b4711cd2b8126
    let in5 = CE::<CI<5>> {}; // 0x1284b71c2865a7dfe8b99fdd76e68b605c521e08292f2176d60b35dadcc9e470
    let in6 = CE::<CI<6>> {}; // 0x246996f3b4fae7e6a6327cfe12150b8e747992778eeec7e5ca5cf05f80f362ac
    let in7 = CE::<CI<7>> {}; // 0x63cf305489af5dcdc5ec698b6e2f9b9dbaae0eda9c95998dc54014671a0135a
    let in8 = CE::<CI<8>> {}; // 0x7c03cbcac41049a0704b5a7ec796f2b21807dc98fa25bd282d37f632623b0e3
    let in9 = CE::<CI<9>> {}; // 0x183c1e74f798649e93a3661a4353ff4425c459b55aa1bd32ea2c810eab7692f
    let in10 = CE::<
        CI<10>,
    > {}; // 0x12acf2ca76fd0675a27fb246c7729f7db080cb99678e2ac024c6b8ee6e0c2c4b

    // INPUT stack
    let (in11, in12, in13) = (CE::<CI<11>> {}, CE::<CI<12>> {}, CE::<CI<13>> {});
    let (in14, in15, in16) = (CE::<CI<14>> {}, CE::<CI<15>> {}, CE::<CI<16>> {});
    let (in17, in18, in19) = (CE::<CI<17>> {}, CE::<CI<18>> {}, CE::<CI<19>> {});
    let (in20, in21, in22) = (CE::<CI<20>> {}, CE::<CI<21>> {}, CE::<CI<22>> {});
    let t0 = circuit_sub(in0, in12);
    let t1 = circuit_add(in11, in0);
    let t2 = circuit_sub(in0, in14);
    let t3 = circuit_sub(in0, in16);
    let t4 = circuit_sub(in0, in18);
    let t5 = circuit_sub(in0, in20);
    let t6 = circuit_sub(in0, in22);
    let t7 = circuit_mul(in1, in13); // Fp2 mul start
    let t8 = circuit_mul(in2, t2);
    let t9 = circuit_sub(t7, t8); // Fp2 mul real part end
    let t10 = circuit_mul(in1, t2);
    let t11 = circuit_mul(in2, in13);
    let t12 = circuit_add(t10, t11); // Fp2 mul imag part end
    let t13 = circuit_mul(in3, in15); // Fp2 mul start
    let t14 = circuit_mul(in4, t3);
    let t15 = circuit_sub(t13, t14); // Fp2 mul real part end
    let t16 = circuit_mul(in3, t3);
    let t17 = circuit_mul(in4, in15);
    let t18 = circuit_add(t16, t17); // Fp2 mul imag part end
    let t19 = circuit_mul(in5, in17); // Fp2 mul start
    let t20 = circuit_mul(in6, t4);
    let t21 = circuit_sub(t19, t20); // Fp2 mul real part end
    let t22 = circuit_mul(in5, t4);
    let t23 = circuit_mul(in6, in17);
    let t24 = circuit_add(t22, t23); // Fp2 mul imag part end
    let t25 = circuit_mul(in7, in19); // Fp2 mul start
    let t26 = circuit_mul(in8, t5);
    let t27 = circuit_sub(t25, t26); // Fp2 mul real part end
    let t28 = circuit_mul(in7, t5);
    let t29 = circuit_mul(in8, in19);
    let t30 = circuit_add(t28, t29); // Fp2 mul imag part end
    let t31 = circuit_mul(in9, in21); // Fp2 mul start
    let t32 = circuit_mul(in10, t6);
    let t33 = circuit_sub(t31, t32); // Fp2 mul real part end
    let t34 = circuit_mul(in9, t6);
    let t35 = circuit_mul(in10, in21);
    let t36 = circuit_add(t34, t35); // Fp2 mul imag part end

    let modulus = get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (t1, t0, t9, t12, t15, t18, t21, t24, t27, t30, t33, t36).new_inputs();
    // Prefill constants:

    circuit_inputs = circuit_inputs.next_span(E12T_FROBENIUS_BN254_CONSTANTS.span()); // in0 - in10

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(M.c0b0a0); // in11
    circuit_inputs = circuit_inputs.next_2(M.c0b0a1); // in12
    circuit_inputs = circuit_inputs.next_2(M.c0b1a0); // in13
    circuit_inputs = circuit_inputs.next_2(M.c0b1a1); // in14
    circuit_inputs = circuit_inputs.next_2(M.c0b2a0); // in15
    circuit_inputs = circuit_inputs.next_2(M.c0b2a1); // in16
    circuit_inputs = circuit_inputs.next_2(M.c1b0a0); // in17
    circuit_inputs = circuit_inputs.next_2(M.c1b0a1); // in18
    circuit_inputs = circuit_inputs.next_2(M.c1b1a0); // in19
    circuit_inputs = circuit_inputs.next_2(M.c1b1a1); // in20
    circuit_inputs = circuit_inputs.next_2(M.c1b2a0); // in21
    circuit_inputs = circuit_inputs.next_2(M.c1b2a1); // in22

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: E12T = E12T {
        c0b0a0: outputs.get_output(t1),
        c0b0a1: outputs.get_output(t0),
        c0b1a0: outputs.get_output(t9),
        c0b1a1: outputs.get_output(t12),
        c0b2a0: outputs.get_output(t15),
        c0b2a1: outputs.get_output(t18),
        c1b0a0: outputs.get_output(t21),
        c1b0a1: outputs.get_output(t24),
        c1b1a0: outputs.get_output(t27),
        c1b1a1: outputs.get_output(t30),
        c1b2a0: outputs.get_output(t33),
        c1b2a1: outputs.get_output(t36),
    };
    return (res,);
}
const E12T_FROBENIUS_BN254_CONSTANTS: [u384; 11] = [
    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
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
        limb0: 0xbe94ec72848a1f55921ea762,
        limb1: 0x80f3c0b75a181e84d33365f7,
        limb2: 0x5b54f5e64eea801,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x1bdec763c13b4711cd2b8126,
        limb1: 0x9f3a80b03b0b1c923685d2ea,
        limb2: 0x2c145edbe7fd8aee,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x292f2176d60b35dadcc9e470,
        limb1: 0xe8b99fdd76e68b605c521e08,
        limb2: 0x1284b71c2865a7df,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x8eeec7e5ca5cf05f80f362ac,
        limb1: 0xa6327cfe12150b8e74799277,
        limb2: 0x246996f3b4fae7e6,
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
        limb0: 0x55aa1bd32ea2c810eab7692f,
        limb1: 0xe93a3661a4353ff4425c459b,
        limb2: 0x183c1e74f798649,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x678e2ac024c6b8ee6e0c2c4b,
        limb1: 0xa27fb246c7729f7db080cb99,
        limb2: 0x12acf2ca76fd0675,
        limb3: 0x0,
    },
];
#[inline(always)]
pub fn run_BN254_E12T_INVERSE_circuit(M: E12T) -> (E12T,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0xa
    let in1 = CE::<CI<1>> {}; // 0x9
    let in2 = CE::<CI<2>> {}; // 0x0

    // INPUT stack
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13, in14) = (CE::<CI<12>> {}, CE::<CI<13>> {}, CE::<CI<14>> {});
    let t0 = circuit_mul(in3, in5); // Fp2 mul start
    let t1 = circuit_mul(in4, in6);
    let t2 = circuit_sub(t0, t1); // Fp2 mul real part end
    let t3 = circuit_mul(in3, in6);
    let t4 = circuit_mul(in4, in5);
    let t5 = circuit_add(t3, t4); // Fp2 mul imag part end
    let t6 = circuit_add(t2, t2); // Fp2 add coeff 0/1
    let t7 = circuit_add(t5, t5); // Fp2 add coeff 1/1
    let t8 = circuit_add(in7, in8);
    let t9 = circuit_sub(in7, in8);
    let t10 = circuit_mul(t8, t9);
    let t11 = circuit_mul(in7, in8);
    let t12 = circuit_add(t11, t11);
    let t13 = circuit_add(t10, t12);
    let t14 = circuit_mul(t13, in0);
    let t15 = circuit_mul(t10, in1);
    let t16 = circuit_sub(t15, t12);
    let t17 = circuit_sub(t14, t15);
    let t18 = circuit_sub(t17, t12);
    let t19 = circuit_add(t16, t6); // Fp2 add coeff 0/1
    let t20 = circuit_add(t18, t7); // Fp2 add coeff 1/1
    let t21 = circuit_sub(t6, t10); // Fp2 sub coeff 0/1
    let t22 = circuit_sub(t7, t12); // Fp2 sub coeff 1/1
    let t23 = circuit_add(in3, in4);
    let t24 = circuit_sub(in3, in4);
    let t25 = circuit_mul(t23, t24);
    let t26 = circuit_mul(in3, in4);
    let t27 = circuit_add(t26, t26);
    let t28 = circuit_sub(in3, in5); // Fp2 sub coeff 0/1
    let t29 = circuit_sub(in4, in6); // Fp2 sub coeff 1/1
    let t30 = circuit_add(t28, in7); // Fp2 add coeff 0/1
    let t31 = circuit_add(t29, in8); // Fp2 add coeff 1/1
    let t32 = circuit_mul(in5, in7); // Fp2 mul start
    let t33 = circuit_mul(in6, in8);
    let t34 = circuit_sub(t32, t33); // Fp2 mul real part end
    let t35 = circuit_mul(in5, in8);
    let t36 = circuit_mul(in6, in7);
    let t37 = circuit_add(t35, t36); // Fp2 mul imag part end
    let t38 = circuit_add(t34, t34); // Fp2 add coeff 0/1
    let t39 = circuit_add(t37, t37); // Fp2 add coeff 1/1
    let t40 = circuit_add(t30, t31);
    let t41 = circuit_sub(t30, t31);
    let t42 = circuit_mul(t40, t41);
    let t43 = circuit_mul(t30, t31);
    let t44 = circuit_add(t43, t43);
    let t45 = circuit_add(t38, t39);
    let t46 = circuit_mul(t45, in0);
    let t47 = circuit_mul(t38, in1);
    let t48 = circuit_sub(t47, t39);
    let t49 = circuit_sub(t46, t47);
    let t50 = circuit_sub(t49, t39);
    let t51 = circuit_add(t48, t25); // Fp2 add coeff 0/1
    let t52 = circuit_add(t50, t27); // Fp2 add coeff 1/1
    let t53 = circuit_add(t21, t42); // Fp2 add coeff 0/1
    let t54 = circuit_add(t22, t44); // Fp2 add coeff 1/1
    let t55 = circuit_add(t53, t38); // Fp2 add coeff 0/1
    let t56 = circuit_add(t54, t39); // Fp2 add coeff 1/1
    let t57 = circuit_sub(t55, t25); // Fp2 sub coeff 0/1
    let t58 = circuit_sub(t56, t27); // Fp2 sub coeff 1/1
    let t59 = circuit_mul(in9, in11); // Fp2 mul start
    let t60 = circuit_mul(in10, in12);
    let t61 = circuit_sub(t59, t60); // Fp2 mul real part end
    let t62 = circuit_mul(in9, in12);
    let t63 = circuit_mul(in10, in11);
    let t64 = circuit_add(t62, t63); // Fp2 mul imag part end
    let t65 = circuit_add(t61, t61); // Fp2 add coeff 0/1
    let t66 = circuit_add(t64, t64); // Fp2 add coeff 1/1
    let t67 = circuit_add(in13, in14);
    let t68 = circuit_sub(in13, in14);
    let t69 = circuit_mul(t67, t68);
    let t70 = circuit_mul(in13, in14);
    let t71 = circuit_add(t70, t70);
    let t72 = circuit_add(t69, t71);
    let t73 = circuit_mul(t72, in0);
    let t74 = circuit_mul(t69, in1);
    let t75 = circuit_sub(t74, t71);
    let t76 = circuit_sub(t73, t74);
    let t77 = circuit_sub(t76, t71);
    let t78 = circuit_add(t75, t65); // Fp2 add coeff 0/1
    let t79 = circuit_add(t77, t66); // Fp2 add coeff 1/1
    let t80 = circuit_sub(t65, t69); // Fp2 sub coeff 0/1
    let t81 = circuit_sub(t66, t71); // Fp2 sub coeff 1/1
    let t82 = circuit_add(in9, in10);
    let t83 = circuit_sub(in9, in10);
    let t84 = circuit_mul(t82, t83);
    let t85 = circuit_mul(in9, in10);
    let t86 = circuit_add(t85, t85);
    let t87 = circuit_sub(in9, in11); // Fp2 sub coeff 0/1
    let t88 = circuit_sub(in10, in12); // Fp2 sub coeff 1/1
    let t89 = circuit_add(t87, in13); // Fp2 add coeff 0/1
    let t90 = circuit_add(t88, in14); // Fp2 add coeff 1/1
    let t91 = circuit_mul(in11, in13); // Fp2 mul start
    let t92 = circuit_mul(in12, in14);
    let t93 = circuit_sub(t91, t92); // Fp2 mul real part end
    let t94 = circuit_mul(in11, in14);
    let t95 = circuit_mul(in12, in13);
    let t96 = circuit_add(t94, t95); // Fp2 mul imag part end
    let t97 = circuit_add(t93, t93); // Fp2 add coeff 0/1
    let t98 = circuit_add(t96, t96); // Fp2 add coeff 1/1
    let t99 = circuit_add(t89, t90);
    let t100 = circuit_sub(t89, t90);
    let t101 = circuit_mul(t99, t100);
    let t102 = circuit_mul(t89, t90);
    let t103 = circuit_add(t102, t102);
    let t104 = circuit_add(t97, t98);
    let t105 = circuit_mul(t104, in0);
    let t106 = circuit_mul(t97, in1);
    let t107 = circuit_sub(t106, t98);
    let t108 = circuit_sub(t105, t106);
    let t109 = circuit_sub(t108, t98);
    let t110 = circuit_add(t107, t84); // Fp2 add coeff 0/1
    let t111 = circuit_add(t109, t86); // Fp2 add coeff 1/1
    let t112 = circuit_add(t80, t101); // Fp2 add coeff 0/1
    let t113 = circuit_add(t81, t103); // Fp2 add coeff 1/1
    let t114 = circuit_add(t112, t97); // Fp2 add coeff 0/1
    let t115 = circuit_add(t113, t98); // Fp2 add coeff 1/1
    let t116 = circuit_sub(t114, t84); // Fp2 sub coeff 0/1
    let t117 = circuit_sub(t115, t86); // Fp2 sub coeff 1/1
    let t118 = circuit_add(t116, t117);
    let t119 = circuit_mul(t118, in0);
    let t120 = circuit_mul(t116, in1);
    let t121 = circuit_sub(t120, t117);
    let t122 = circuit_sub(t119, t120);
    let t123 = circuit_sub(t122, t117);
    let t124 = circuit_sub(t51, t121); // Fp6 sub coeff 0/5
    let t125 = circuit_sub(t52, t123); // Fp6 sub coeff 1/5
    let t126 = circuit_sub(t19, t110); // Fp6 sub coeff 2/5
    let t127 = circuit_sub(t20, t111); // Fp6 sub coeff 3/5
    let t128 = circuit_sub(t57, t78); // Fp6 sub coeff 4/5
    let t129 = circuit_sub(t58, t79); // Fp6 sub coeff 5/5
    let t130 = circuit_add(t124, t125);
    let t131 = circuit_sub(t124, t125);
    let t132 = circuit_mul(t130, t131);
    let t133 = circuit_mul(t124, t125);
    let t134 = circuit_add(t133, t133);
    let t135 = circuit_add(t126, t127);
    let t136 = circuit_sub(t126, t127);
    let t137 = circuit_mul(t135, t136);
    let t138 = circuit_mul(t126, t127);
    let t139 = circuit_add(t138, t138);
    let t140 = circuit_add(t128, t129);
    let t141 = circuit_sub(t128, t129);
    let t142 = circuit_mul(t140, t141);
    let t143 = circuit_mul(t128, t129);
    let t144 = circuit_add(t143, t143);
    let t145 = circuit_mul(t124, t126); // Fp2 mul start
    let t146 = circuit_mul(t125, t127);
    let t147 = circuit_sub(t145, t146); // Fp2 mul real part end
    let t148 = circuit_mul(t124, t127);
    let t149 = circuit_mul(t125, t126);
    let t150 = circuit_add(t148, t149); // Fp2 mul imag part end
    let t151 = circuit_mul(t124, t128); // Fp2 mul start
    let t152 = circuit_mul(t125, t129);
    let t153 = circuit_sub(t151, t152); // Fp2 mul real part end
    let t154 = circuit_mul(t124, t129);
    let t155 = circuit_mul(t125, t128);
    let t156 = circuit_add(t154, t155); // Fp2 mul imag part end
    let t157 = circuit_mul(t126, t128); // Fp2 mul start
    let t158 = circuit_mul(t127, t129);
    let t159 = circuit_sub(t157, t158); // Fp2 mul real part end
    let t160 = circuit_mul(t126, t129);
    let t161 = circuit_mul(t127, t128);
    let t162 = circuit_add(t160, t161); // Fp2 mul imag part end
    let t163 = circuit_add(t159, t162);
    let t164 = circuit_mul(t163, in0);
    let t165 = circuit_mul(t159, in1);
    let t166 = circuit_sub(t165, t162);
    let t167 = circuit_sub(t164, t165);
    let t168 = circuit_sub(t167, t162);
    let t169 = circuit_sub(in2, t166); // Fp2 neg coeff 0/1
    let t170 = circuit_sub(in2, t168); // Fp2 neg coeff 1/1
    let t171 = circuit_add(t169, t132); // Fp2 add coeff 0/1
    let t172 = circuit_add(t170, t134); // Fp2 add coeff 1/1
    let t173 = circuit_add(t142, t144);
    let t174 = circuit_mul(t173, in0);
    let t175 = circuit_mul(t142, in1);
    let t176 = circuit_sub(t175, t144);
    let t177 = circuit_sub(t174, t175);
    let t178 = circuit_sub(t177, t144);
    let t179 = circuit_sub(t176, t147); // Fp2 sub coeff 0/1
    let t180 = circuit_sub(t178, t150); // Fp2 sub coeff 1/1
    let t181 = circuit_sub(t137, t153); // Fp2 sub coeff 0/1
    let t182 = circuit_sub(t139, t156); // Fp2 sub coeff 1/1
    let t183 = circuit_mul(t124, t171); // Fp2 mul start
    let t184 = circuit_mul(t125, t172);
    let t185 = circuit_sub(t183, t184); // Fp2 mul real part end
    let t186 = circuit_mul(t124, t172);
    let t187 = circuit_mul(t125, t171);
    let t188 = circuit_add(t186, t187); // Fp2 mul imag part end
    let t189 = circuit_mul(t128, t179); // Fp2 mul start
    let t190 = circuit_mul(t129, t180);
    let t191 = circuit_sub(t189, t190); // Fp2 mul real part end
    let t192 = circuit_mul(t128, t180);
    let t193 = circuit_mul(t129, t179);
    let t194 = circuit_add(t192, t193); // Fp2 mul imag part end
    let t195 = circuit_mul(t126, t181); // Fp2 mul start
    let t196 = circuit_mul(t127, t182);
    let t197 = circuit_sub(t195, t196); // Fp2 mul real part end
    let t198 = circuit_mul(t126, t182);
    let t199 = circuit_mul(t127, t181);
    let t200 = circuit_add(t198, t199); // Fp2 mul imag part end
    let t201 = circuit_add(t191, t197); // Fp2 add coeff 0/1
    let t202 = circuit_add(t194, t200); // Fp2 add coeff 1/1
    let t203 = circuit_add(t201, t202);
    let t204 = circuit_mul(t203, in0);
    let t205 = circuit_mul(t201, in1);
    let t206 = circuit_sub(t205, t202);
    let t207 = circuit_sub(t204, t205);
    let t208 = circuit_sub(t207, t202);
    let t209 = circuit_add(t185, t206); // Fp2 add coeff 0/1
    let t210 = circuit_add(t188, t208); // Fp2 add coeff 1/1
    let t211 = circuit_mul(t209, t209); // Fp2 Inv start
    let t212 = circuit_mul(t210, t210);
    let t213 = circuit_add(t211, t212);
    let t214 = circuit_inverse(t213);
    let t215 = circuit_mul(t209, t214); // Fp2 Inv real part end
    let t216 = circuit_mul(t210, t214);
    let t217 = circuit_sub(in2, t216); // Fp2 Inv imag part end
    let t218 = circuit_mul(t171, t215); // Fp2 mul start
    let t219 = circuit_mul(t172, t217);
    let t220 = circuit_sub(t218, t219); // Fp2 mul real part end
    let t221 = circuit_mul(t171, t217);
    let t222 = circuit_mul(t172, t215);
    let t223 = circuit_add(t221, t222); // Fp2 mul imag part end
    let t224 = circuit_mul(t179, t215); // Fp2 mul start
    let t225 = circuit_mul(t180, t217);
    let t226 = circuit_sub(t224, t225); // Fp2 mul real part end
    let t227 = circuit_mul(t179, t217);
    let t228 = circuit_mul(t180, t215);
    let t229 = circuit_add(t227, t228); // Fp2 mul imag part end
    let t230 = circuit_mul(t181, t215); // Fp2 mul start
    let t231 = circuit_mul(t182, t217);
    let t232 = circuit_sub(t230, t231); // Fp2 mul real part end
    let t233 = circuit_mul(t181, t217);
    let t234 = circuit_mul(t182, t215);
    let t235 = circuit_add(t233, t234); // Fp2 mul imag part end
    let t236 = circuit_mul(in3, t220); // Fp2 mul start
    let t237 = circuit_mul(in4, t223);
    let t238 = circuit_sub(t236, t237); // Fp2 mul real part end
    let t239 = circuit_mul(in3, t223);
    let t240 = circuit_mul(in4, t220);
    let t241 = circuit_add(t239, t240); // Fp2 mul imag part end
    let t242 = circuit_mul(in5, t226); // Fp2 mul start
    let t243 = circuit_mul(in6, t229);
    let t244 = circuit_sub(t242, t243); // Fp2 mul real part end
    let t245 = circuit_mul(in5, t229);
    let t246 = circuit_mul(in6, t226);
    let t247 = circuit_add(t245, t246); // Fp2 mul imag part end
    let t248 = circuit_mul(in7, t232); // Fp2 mul start
    let t249 = circuit_mul(in8, t235);
    let t250 = circuit_sub(t248, t249); // Fp2 mul real part end
    let t251 = circuit_mul(in7, t235);
    let t252 = circuit_mul(in8, t232);
    let t253 = circuit_add(t251, t252); // Fp2 mul imag part end
    let t254 = circuit_add(in5, in7); // Fp2 add coeff 0/1
    let t255 = circuit_add(in6, in8); // Fp2 add coeff 1/1
    let t256 = circuit_add(t226, t232); // Fp2 add coeff 0/1
    let t257 = circuit_add(t229, t235); // Fp2 add coeff 1/1
    let t258 = circuit_mul(t254, t256); // Fp2 mul start
    let t259 = circuit_mul(t255, t257);
    let t260 = circuit_sub(t258, t259); // Fp2 mul real part end
    let t261 = circuit_mul(t254, t257);
    let t262 = circuit_mul(t255, t256);
    let t263 = circuit_add(t261, t262); // Fp2 mul imag part end
    let t264 = circuit_sub(t260, t244); // Fp2 sub coeff 0/1
    let t265 = circuit_sub(t263, t247); // Fp2 sub coeff 1/1
    let t266 = circuit_sub(t264, t250); // Fp2 sub coeff 0/1
    let t267 = circuit_sub(t265, t253); // Fp2 sub coeff 1/1
    let t268 = circuit_add(t266, t267);
    let t269 = circuit_mul(t268, in0);
    let t270 = circuit_mul(t266, in1);
    let t271 = circuit_sub(t270, t267);
    let t272 = circuit_sub(t269, t270);
    let t273 = circuit_sub(t272, t267);
    let t274 = circuit_add(t271, t238); // Fp2 add coeff 0/1
    let t275 = circuit_add(t273, t241); // Fp2 add coeff 1/1
    let t276 = circuit_add(in3, in5); // Fp2 add coeff 0/1
    let t277 = circuit_add(in4, in6); // Fp2 add coeff 1/1
    let t278 = circuit_add(t220, t226); // Fp2 add coeff 0/1
    let t279 = circuit_add(t223, t229); // Fp2 add coeff 1/1
    let t280 = circuit_mul(t276, t278); // Fp2 mul start
    let t281 = circuit_mul(t277, t279);
    let t282 = circuit_sub(t280, t281); // Fp2 mul real part end
    let t283 = circuit_mul(t276, t279);
    let t284 = circuit_mul(t277, t278);
    let t285 = circuit_add(t283, t284); // Fp2 mul imag part end
    let t286 = circuit_sub(t282, t238); // Fp2 sub coeff 0/1
    let t287 = circuit_sub(t285, t241); // Fp2 sub coeff 1/1
    let t288 = circuit_sub(t286, t244); // Fp2 sub coeff 0/1
    let t289 = circuit_sub(t287, t247); // Fp2 sub coeff 1/1
    let t290 = circuit_add(t250, t253);
    let t291 = circuit_mul(t290, in0);
    let t292 = circuit_mul(t250, in1);
    let t293 = circuit_sub(t292, t253);
    let t294 = circuit_sub(t291, t292);
    let t295 = circuit_sub(t294, t253);
    let t296 = circuit_add(t288, t293); // Fp2 add coeff 0/1
    let t297 = circuit_add(t289, t295); // Fp2 add coeff 1/1
    let t298 = circuit_add(in3, in7); // Fp2 add coeff 0/1
    let t299 = circuit_add(in4, in8); // Fp2 add coeff 1/1
    let t300 = circuit_add(t220, t232); // Fp2 add coeff 0/1
    let t301 = circuit_add(t223, t235); // Fp2 add coeff 1/1
    let t302 = circuit_mul(t300, t298); // Fp2 mul start
    let t303 = circuit_mul(t301, t299);
    let t304 = circuit_sub(t302, t303); // Fp2 mul real part end
    let t305 = circuit_mul(t300, t299);
    let t306 = circuit_mul(t301, t298);
    let t307 = circuit_add(t305, t306); // Fp2 mul imag part end
    let t308 = circuit_sub(t304, t238); // Fp2 sub coeff 0/1
    let t309 = circuit_sub(t307, t241); // Fp2 sub coeff 1/1
    let t310 = circuit_sub(t308, t250); // Fp2 sub coeff 0/1
    let t311 = circuit_sub(t309, t253); // Fp2 sub coeff 1/1
    let t312 = circuit_add(t310, t244); // Fp2 add coeff 0/1
    let t313 = circuit_add(t311, t247); // Fp2 add coeff 1/1
    let t314 = circuit_mul(in9, t220); // Fp2 mul start
    let t315 = circuit_mul(in10, t223);
    let t316 = circuit_sub(t314, t315); // Fp2 mul real part end
    let t317 = circuit_mul(in9, t223);
    let t318 = circuit_mul(in10, t220);
    let t319 = circuit_add(t317, t318); // Fp2 mul imag part end
    let t320 = circuit_mul(in11, t226); // Fp2 mul start
    let t321 = circuit_mul(in12, t229);
    let t322 = circuit_sub(t320, t321); // Fp2 mul real part end
    let t323 = circuit_mul(in11, t229);
    let t324 = circuit_mul(in12, t226);
    let t325 = circuit_add(t323, t324); // Fp2 mul imag part end
    let t326 = circuit_mul(in13, t232); // Fp2 mul start
    let t327 = circuit_mul(in14, t235);
    let t328 = circuit_sub(t326, t327); // Fp2 mul real part end
    let t329 = circuit_mul(in13, t235);
    let t330 = circuit_mul(in14, t232);
    let t331 = circuit_add(t329, t330); // Fp2 mul imag part end
    let t332 = circuit_add(in11, in13); // Fp2 add coeff 0/1
    let t333 = circuit_add(in12, in14); // Fp2 add coeff 1/1
    let t334 = circuit_add(t226, t232); // Fp2 add coeff 0/1
    let t335 = circuit_add(t229, t235); // Fp2 add coeff 1/1
    let t336 = circuit_mul(t332, t334); // Fp2 mul start
    let t337 = circuit_mul(t333, t335);
    let t338 = circuit_sub(t336, t337); // Fp2 mul real part end
    let t339 = circuit_mul(t332, t335);
    let t340 = circuit_mul(t333, t334);
    let t341 = circuit_add(t339, t340); // Fp2 mul imag part end
    let t342 = circuit_sub(t338, t322); // Fp2 sub coeff 0/1
    let t343 = circuit_sub(t341, t325); // Fp2 sub coeff 1/1
    let t344 = circuit_sub(t342, t328); // Fp2 sub coeff 0/1
    let t345 = circuit_sub(t343, t331); // Fp2 sub coeff 1/1
    let t346 = circuit_add(t344, t345);
    let t347 = circuit_mul(t346, in0);
    let t348 = circuit_mul(t344, in1);
    let t349 = circuit_sub(t348, t345);
    let t350 = circuit_sub(t347, t348);
    let t351 = circuit_sub(t350, t345);
    let t352 = circuit_add(t349, t316); // Fp2 add coeff 0/1
    let t353 = circuit_add(t351, t319); // Fp2 add coeff 1/1
    let t354 = circuit_add(in9, in11); // Fp2 add coeff 0/1
    let t355 = circuit_add(in10, in12); // Fp2 add coeff 1/1
    let t356 = circuit_add(t220, t226); // Fp2 add coeff 0/1
    let t357 = circuit_add(t223, t229); // Fp2 add coeff 1/1
    let t358 = circuit_mul(t354, t356); // Fp2 mul start
    let t359 = circuit_mul(t355, t357);
    let t360 = circuit_sub(t358, t359); // Fp2 mul real part end
    let t361 = circuit_mul(t354, t357);
    let t362 = circuit_mul(t355, t356);
    let t363 = circuit_add(t361, t362); // Fp2 mul imag part end
    let t364 = circuit_sub(t360, t316); // Fp2 sub coeff 0/1
    let t365 = circuit_sub(t363, t319); // Fp2 sub coeff 1/1
    let t366 = circuit_sub(t364, t322); // Fp2 sub coeff 0/1
    let t367 = circuit_sub(t365, t325); // Fp2 sub coeff 1/1
    let t368 = circuit_add(t328, t331);
    let t369 = circuit_mul(t368, in0);
    let t370 = circuit_mul(t328, in1);
    let t371 = circuit_sub(t370, t331);
    let t372 = circuit_sub(t369, t370);
    let t373 = circuit_sub(t372, t331);
    let t374 = circuit_add(t366, t371); // Fp2 add coeff 0/1
    let t375 = circuit_add(t367, t373); // Fp2 add coeff 1/1
    let t376 = circuit_add(in9, in13); // Fp2 add coeff 0/1
    let t377 = circuit_add(in10, in14); // Fp2 add coeff 1/1
    let t378 = circuit_add(t220, t232); // Fp2 add coeff 0/1
    let t379 = circuit_add(t223, t235); // Fp2 add coeff 1/1
    let t380 = circuit_mul(t378, t376); // Fp2 mul start
    let t381 = circuit_mul(t379, t377);
    let t382 = circuit_sub(t380, t381); // Fp2 mul real part end
    let t383 = circuit_mul(t378, t377);
    let t384 = circuit_mul(t379, t376);
    let t385 = circuit_add(t383, t384); // Fp2 mul imag part end
    let t386 = circuit_sub(t382, t316); // Fp2 sub coeff 0/1
    let t387 = circuit_sub(t385, t319); // Fp2 sub coeff 1/1
    let t388 = circuit_sub(t386, t328); // Fp2 sub coeff 0/1
    let t389 = circuit_sub(t387, t331); // Fp2 sub coeff 1/1
    let t390 = circuit_add(t388, t322); // Fp2 add coeff 0/1
    let t391 = circuit_add(t389, t325); // Fp2 add coeff 1/1
    let t392 = circuit_sub(in2, t352); // Fp6 neg coeff 0/5
    let t393 = circuit_sub(in2, t353); // Fp6 neg coeff 1/5
    let t394 = circuit_sub(in2, t374); // Fp6 neg coeff 2/5
    let t395 = circuit_sub(in2, t375); // Fp6 neg coeff 3/5
    let t396 = circuit_sub(in2, t390); // Fp6 neg coeff 4/5
    let t397 = circuit_sub(in2, t391); // Fp6 neg coeff 5/5

    let modulus = get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (
        t274, t275, t296, t297, t312, t313, t392, t393, t394, t395, t396, t397,
    )
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0xa, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs.next_2([0x9, 0x0, 0x0, 0x0]); // in1
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in2
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(M.c0b0a0); // in3
    circuit_inputs = circuit_inputs.next_2(M.c0b0a1); // in4
    circuit_inputs = circuit_inputs.next_2(M.c0b1a0); // in5
    circuit_inputs = circuit_inputs.next_2(M.c0b1a1); // in6
    circuit_inputs = circuit_inputs.next_2(M.c0b2a0); // in7
    circuit_inputs = circuit_inputs.next_2(M.c0b2a1); // in8
    circuit_inputs = circuit_inputs.next_2(M.c1b0a0); // in9
    circuit_inputs = circuit_inputs.next_2(M.c1b0a1); // in10
    circuit_inputs = circuit_inputs.next_2(M.c1b1a0); // in11
    circuit_inputs = circuit_inputs.next_2(M.c1b1a1); // in12
    circuit_inputs = circuit_inputs.next_2(M.c1b2a0); // in13
    circuit_inputs = circuit_inputs.next_2(M.c1b2a1); // in14

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: E12T = E12T {
        c0b0a0: outputs.get_output(t274),
        c0b0a1: outputs.get_output(t275),
        c0b1a0: outputs.get_output(t296),
        c0b1a1: outputs.get_output(t297),
        c0b2a0: outputs.get_output(t312),
        c0b2a1: outputs.get_output(t313),
        c1b0a0: outputs.get_output(t392),
        c1b0a1: outputs.get_output(t393),
        c1b1a0: outputs.get_output(t394),
        c1b1a1: outputs.get_output(t395),
        c1b2a0: outputs.get_output(t396),
        c1b2a1: outputs.get_output(t397),
    };
    return (res,);
}
#[inline(always)]
pub fn run_BN254_E12T_MUL_circuit(X: E12T, Y: E12T) -> (E12T,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0xa
    let in1 = CE::<CI<1>> {}; // 0x9

    // INPUT stack
    let (in2, in3, in4) = (CE::<CI<2>> {}, CE::<CI<3>> {}, CE::<CI<4>> {});
    let (in5, in6, in7) = (CE::<CI<5>> {}, CE::<CI<6>> {}, CE::<CI<7>> {});
    let (in8, in9, in10) = (CE::<CI<8>> {}, CE::<CI<9>> {}, CE::<CI<10>> {});
    let (in11, in12, in13) = (CE::<CI<11>> {}, CE::<CI<12>> {}, CE::<CI<13>> {});
    let (in14, in15, in16) = (CE::<CI<14>> {}, CE::<CI<15>> {}, CE::<CI<16>> {});
    let (in17, in18, in19) = (CE::<CI<17>> {}, CE::<CI<18>> {}, CE::<CI<19>> {});
    let (in20, in21, in22) = (CE::<CI<20>> {}, CE::<CI<21>> {}, CE::<CI<22>> {});
    let (in23, in24, in25) = (CE::<CI<23>> {}, CE::<CI<24>> {}, CE::<CI<25>> {});
    let t0 = circuit_add(in2, in8); // Fp6 add coeff 0/5
    let t1 = circuit_add(in3, in9); // Fp6 add coeff 1/5
    let t2 = circuit_add(in4, in10); // Fp6 add coeff 2/5
    let t3 = circuit_add(in5, in11); // Fp6 add coeff 3/5
    let t4 = circuit_add(in6, in12); // Fp6 add coeff 4/5
    let t5 = circuit_add(in7, in13); // Fp6 add coeff 5/5
    let t6 = circuit_add(in14, in20); // Fp6 add coeff 0/5
    let t7 = circuit_add(in15, in21); // Fp6 add coeff 1/5
    let t8 = circuit_add(in16, in22); // Fp6 add coeff 2/5
    let t9 = circuit_add(in17, in23); // Fp6 add coeff 3/5
    let t10 = circuit_add(in18, in24); // Fp6 add coeff 4/5
    let t11 = circuit_add(in19, in25); // Fp6 add coeff 5/5
    let t12 = circuit_mul(t0, t6); // Fp2 mul start
    let t13 = circuit_mul(t1, t7);
    let t14 = circuit_sub(t12, t13); // Fp2 mul real part end
    let t15 = circuit_mul(t0, t7);
    let t16 = circuit_mul(t1, t6);
    let t17 = circuit_add(t15, t16); // Fp2 mul imag part end
    let t18 = circuit_mul(t2, t8); // Fp2 mul start
    let t19 = circuit_mul(t3, t9);
    let t20 = circuit_sub(t18, t19); // Fp2 mul real part end
    let t21 = circuit_mul(t2, t9);
    let t22 = circuit_mul(t3, t8);
    let t23 = circuit_add(t21, t22); // Fp2 mul imag part end
    let t24 = circuit_mul(t4, t10); // Fp2 mul start
    let t25 = circuit_mul(t5, t11);
    let t26 = circuit_sub(t24, t25); // Fp2 mul real part end
    let t27 = circuit_mul(t4, t11);
    let t28 = circuit_mul(t5, t10);
    let t29 = circuit_add(t27, t28); // Fp2 mul imag part end
    let t30 = circuit_add(t2, t4); // Fp2 add coeff 0/1
    let t31 = circuit_add(t3, t5); // Fp2 add coeff 1/1
    let t32 = circuit_add(t8, t10); // Fp2 add coeff 0/1
    let t33 = circuit_add(t9, t11); // Fp2 add coeff 1/1
    let t34 = circuit_mul(t30, t32); // Fp2 mul start
    let t35 = circuit_mul(t31, t33);
    let t36 = circuit_sub(t34, t35); // Fp2 mul real part end
    let t37 = circuit_mul(t30, t33);
    let t38 = circuit_mul(t31, t32);
    let t39 = circuit_add(t37, t38); // Fp2 mul imag part end
    let t40 = circuit_sub(t36, t20); // Fp2 sub coeff 0/1
    let t41 = circuit_sub(t39, t23); // Fp2 sub coeff 1/1
    let t42 = circuit_sub(t40, t26); // Fp2 sub coeff 0/1
    let t43 = circuit_sub(t41, t29); // Fp2 sub coeff 1/1
    let t44 = circuit_add(t42, t43);
    let t45 = circuit_mul(t44, in0);
    let t46 = circuit_mul(t42, in1);
    let t47 = circuit_sub(t46, t43);
    let t48 = circuit_sub(t45, t46);
    let t49 = circuit_sub(t48, t43);
    let t50 = circuit_add(t47, t14); // Fp2 add coeff 0/1
    let t51 = circuit_add(t49, t17); // Fp2 add coeff 1/1
    let t52 = circuit_add(t0, t2); // Fp2 add coeff 0/1
    let t53 = circuit_add(t1, t3); // Fp2 add coeff 1/1
    let t54 = circuit_add(t6, t8); // Fp2 add coeff 0/1
    let t55 = circuit_add(t7, t9); // Fp2 add coeff 1/1
    let t56 = circuit_mul(t52, t54); // Fp2 mul start
    let t57 = circuit_mul(t53, t55);
    let t58 = circuit_sub(t56, t57); // Fp2 mul real part end
    let t59 = circuit_mul(t52, t55);
    let t60 = circuit_mul(t53, t54);
    let t61 = circuit_add(t59, t60); // Fp2 mul imag part end
    let t62 = circuit_sub(t58, t14); // Fp2 sub coeff 0/1
    let t63 = circuit_sub(t61, t17); // Fp2 sub coeff 1/1
    let t64 = circuit_sub(t62, t20); // Fp2 sub coeff 0/1
    let t65 = circuit_sub(t63, t23); // Fp2 sub coeff 1/1
    let t66 = circuit_add(t26, t29);
    let t67 = circuit_mul(t66, in0);
    let t68 = circuit_mul(t26, in1);
    let t69 = circuit_sub(t68, t29);
    let t70 = circuit_sub(t67, t68);
    let t71 = circuit_sub(t70, t29);
    let t72 = circuit_add(t64, t69); // Fp2 add coeff 0/1
    let t73 = circuit_add(t65, t71); // Fp2 add coeff 1/1
    let t74 = circuit_add(t0, t4); // Fp2 add coeff 0/1
    let t75 = circuit_add(t1, t5); // Fp2 add coeff 1/1
    let t76 = circuit_add(t6, t10); // Fp2 add coeff 0/1
    let t77 = circuit_add(t7, t11); // Fp2 add coeff 1/1
    let t78 = circuit_mul(t76, t74); // Fp2 mul start
    let t79 = circuit_mul(t77, t75);
    let t80 = circuit_sub(t78, t79); // Fp2 mul real part end
    let t81 = circuit_mul(t76, t75);
    let t82 = circuit_mul(t77, t74);
    let t83 = circuit_add(t81, t82); // Fp2 mul imag part end
    let t84 = circuit_sub(t80, t14); // Fp2 sub coeff 0/1
    let t85 = circuit_sub(t83, t17); // Fp2 sub coeff 1/1
    let t86 = circuit_sub(t84, t26); // Fp2 sub coeff 0/1
    let t87 = circuit_sub(t85, t29); // Fp2 sub coeff 1/1
    let t88 = circuit_add(t86, t20); // Fp2 add coeff 0/1
    let t89 = circuit_add(t87, t23); // Fp2 add coeff 1/1
    let t90 = circuit_mul(in2, in14); // Fp2 mul start
    let t91 = circuit_mul(in3, in15);
    let t92 = circuit_sub(t90, t91); // Fp2 mul real part end
    let t93 = circuit_mul(in2, in15);
    let t94 = circuit_mul(in3, in14);
    let t95 = circuit_add(t93, t94); // Fp2 mul imag part end
    let t96 = circuit_mul(in4, in16); // Fp2 mul start
    let t97 = circuit_mul(in5, in17);
    let t98 = circuit_sub(t96, t97); // Fp2 mul real part end
    let t99 = circuit_mul(in4, in17);
    let t100 = circuit_mul(in5, in16);
    let t101 = circuit_add(t99, t100); // Fp2 mul imag part end
    let t102 = circuit_mul(in6, in18); // Fp2 mul start
    let t103 = circuit_mul(in7, in19);
    let t104 = circuit_sub(t102, t103); // Fp2 mul real part end
    let t105 = circuit_mul(in6, in19);
    let t106 = circuit_mul(in7, in18);
    let t107 = circuit_add(t105, t106); // Fp2 mul imag part end
    let t108 = circuit_add(in4, in6); // Fp2 add coeff 0/1
    let t109 = circuit_add(in5, in7); // Fp2 add coeff 1/1
    let t110 = circuit_add(in16, in18); // Fp2 add coeff 0/1
    let t111 = circuit_add(in17, in19); // Fp2 add coeff 1/1
    let t112 = circuit_mul(t108, t110); // Fp2 mul start
    let t113 = circuit_mul(t109, t111);
    let t114 = circuit_sub(t112, t113); // Fp2 mul real part end
    let t115 = circuit_mul(t108, t111);
    let t116 = circuit_mul(t109, t110);
    let t117 = circuit_add(t115, t116); // Fp2 mul imag part end
    let t118 = circuit_sub(t114, t98); // Fp2 sub coeff 0/1
    let t119 = circuit_sub(t117, t101); // Fp2 sub coeff 1/1
    let t120 = circuit_sub(t118, t104); // Fp2 sub coeff 0/1
    let t121 = circuit_sub(t119, t107); // Fp2 sub coeff 1/1
    let t122 = circuit_add(t120, t121);
    let t123 = circuit_mul(t122, in0);
    let t124 = circuit_mul(t120, in1);
    let t125 = circuit_sub(t124, t121);
    let t126 = circuit_sub(t123, t124);
    let t127 = circuit_sub(t126, t121);
    let t128 = circuit_add(t125, t92); // Fp2 add coeff 0/1
    let t129 = circuit_add(t127, t95); // Fp2 add coeff 1/1
    let t130 = circuit_add(in2, in4); // Fp2 add coeff 0/1
    let t131 = circuit_add(in3, in5); // Fp2 add coeff 1/1
    let t132 = circuit_add(in14, in16); // Fp2 add coeff 0/1
    let t133 = circuit_add(in15, in17); // Fp2 add coeff 1/1
    let t134 = circuit_mul(t130, t132); // Fp2 mul start
    let t135 = circuit_mul(t131, t133);
    let t136 = circuit_sub(t134, t135); // Fp2 mul real part end
    let t137 = circuit_mul(t130, t133);
    let t138 = circuit_mul(t131, t132);
    let t139 = circuit_add(t137, t138); // Fp2 mul imag part end
    let t140 = circuit_sub(t136, t92); // Fp2 sub coeff 0/1
    let t141 = circuit_sub(t139, t95); // Fp2 sub coeff 1/1
    let t142 = circuit_sub(t140, t98); // Fp2 sub coeff 0/1
    let t143 = circuit_sub(t141, t101); // Fp2 sub coeff 1/1
    let t144 = circuit_add(t104, t107);
    let t145 = circuit_mul(t144, in0);
    let t146 = circuit_mul(t104, in1);
    let t147 = circuit_sub(t146, t107);
    let t148 = circuit_sub(t145, t146);
    let t149 = circuit_sub(t148, t107);
    let t150 = circuit_add(t142, t147); // Fp2 add coeff 0/1
    let t151 = circuit_add(t143, t149); // Fp2 add coeff 1/1
    let t152 = circuit_add(in2, in6); // Fp2 add coeff 0/1
    let t153 = circuit_add(in3, in7); // Fp2 add coeff 1/1
    let t154 = circuit_add(in14, in18); // Fp2 add coeff 0/1
    let t155 = circuit_add(in15, in19); // Fp2 add coeff 1/1
    let t156 = circuit_mul(t154, t152); // Fp2 mul start
    let t157 = circuit_mul(t155, t153);
    let t158 = circuit_sub(t156, t157); // Fp2 mul real part end
    let t159 = circuit_mul(t154, t153);
    let t160 = circuit_mul(t155, t152);
    let t161 = circuit_add(t159, t160); // Fp2 mul imag part end
    let t162 = circuit_sub(t158, t92); // Fp2 sub coeff 0/1
    let t163 = circuit_sub(t161, t95); // Fp2 sub coeff 1/1
    let t164 = circuit_sub(t162, t104); // Fp2 sub coeff 0/1
    let t165 = circuit_sub(t163, t107); // Fp2 sub coeff 1/1
    let t166 = circuit_add(t164, t98); // Fp2 add coeff 0/1
    let t167 = circuit_add(t165, t101); // Fp2 add coeff 1/1
    let t168 = circuit_mul(in8, in20); // Fp2 mul start
    let t169 = circuit_mul(in9, in21);
    let t170 = circuit_sub(t168, t169); // Fp2 mul real part end
    let t171 = circuit_mul(in8, in21);
    let t172 = circuit_mul(in9, in20);
    let t173 = circuit_add(t171, t172); // Fp2 mul imag part end
    let t174 = circuit_mul(in10, in22); // Fp2 mul start
    let t175 = circuit_mul(in11, in23);
    let t176 = circuit_sub(t174, t175); // Fp2 mul real part end
    let t177 = circuit_mul(in10, in23);
    let t178 = circuit_mul(in11, in22);
    let t179 = circuit_add(t177, t178); // Fp2 mul imag part end
    let t180 = circuit_mul(in12, in24); // Fp2 mul start
    let t181 = circuit_mul(in13, in25);
    let t182 = circuit_sub(t180, t181); // Fp2 mul real part end
    let t183 = circuit_mul(in12, in25);
    let t184 = circuit_mul(in13, in24);
    let t185 = circuit_add(t183, t184); // Fp2 mul imag part end
    let t186 = circuit_add(in10, in12); // Fp2 add coeff 0/1
    let t187 = circuit_add(in11, in13); // Fp2 add coeff 1/1
    let t188 = circuit_add(in22, in24); // Fp2 add coeff 0/1
    let t189 = circuit_add(in23, in25); // Fp2 add coeff 1/1
    let t190 = circuit_mul(t186, t188); // Fp2 mul start
    let t191 = circuit_mul(t187, t189);
    let t192 = circuit_sub(t190, t191); // Fp2 mul real part end
    let t193 = circuit_mul(t186, t189);
    let t194 = circuit_mul(t187, t188);
    let t195 = circuit_add(t193, t194); // Fp2 mul imag part end
    let t196 = circuit_sub(t192, t176); // Fp2 sub coeff 0/1
    let t197 = circuit_sub(t195, t179); // Fp2 sub coeff 1/1
    let t198 = circuit_sub(t196, t182); // Fp2 sub coeff 0/1
    let t199 = circuit_sub(t197, t185); // Fp2 sub coeff 1/1
    let t200 = circuit_add(t198, t199);
    let t201 = circuit_mul(t200, in0);
    let t202 = circuit_mul(t198, in1);
    let t203 = circuit_sub(t202, t199);
    let t204 = circuit_sub(t201, t202);
    let t205 = circuit_sub(t204, t199);
    let t206 = circuit_add(t203, t170); // Fp2 add coeff 0/1
    let t207 = circuit_add(t205, t173); // Fp2 add coeff 1/1
    let t208 = circuit_add(in8, in10); // Fp2 add coeff 0/1
    let t209 = circuit_add(in9, in11); // Fp2 add coeff 1/1
    let t210 = circuit_add(in20, in22); // Fp2 add coeff 0/1
    let t211 = circuit_add(in21, in23); // Fp2 add coeff 1/1
    let t212 = circuit_mul(t208, t210); // Fp2 mul start
    let t213 = circuit_mul(t209, t211);
    let t214 = circuit_sub(t212, t213); // Fp2 mul real part end
    let t215 = circuit_mul(t208, t211);
    let t216 = circuit_mul(t209, t210);
    let t217 = circuit_add(t215, t216); // Fp2 mul imag part end
    let t218 = circuit_sub(t214, t170); // Fp2 sub coeff 0/1
    let t219 = circuit_sub(t217, t173); // Fp2 sub coeff 1/1
    let t220 = circuit_sub(t218, t176); // Fp2 sub coeff 0/1
    let t221 = circuit_sub(t219, t179); // Fp2 sub coeff 1/1
    let t222 = circuit_add(t182, t185);
    let t223 = circuit_mul(t222, in0);
    let t224 = circuit_mul(t182, in1);
    let t225 = circuit_sub(t224, t185);
    let t226 = circuit_sub(t223, t224);
    let t227 = circuit_sub(t226, t185);
    let t228 = circuit_add(t220, t225); // Fp2 add coeff 0/1
    let t229 = circuit_add(t221, t227); // Fp2 add coeff 1/1
    let t230 = circuit_add(in8, in12); // Fp2 add coeff 0/1
    let t231 = circuit_add(in9, in13); // Fp2 add coeff 1/1
    let t232 = circuit_add(in20, in24); // Fp2 add coeff 0/1
    let t233 = circuit_add(in21, in25); // Fp2 add coeff 1/1
    let t234 = circuit_mul(t232, t230); // Fp2 mul start
    let t235 = circuit_mul(t233, t231);
    let t236 = circuit_sub(t234, t235); // Fp2 mul real part end
    let t237 = circuit_mul(t232, t231);
    let t238 = circuit_mul(t233, t230);
    let t239 = circuit_add(t237, t238); // Fp2 mul imag part end
    let t240 = circuit_sub(t236, t170); // Fp2 sub coeff 0/1
    let t241 = circuit_sub(t239, t173); // Fp2 sub coeff 1/1
    let t242 = circuit_sub(t240, t182); // Fp2 sub coeff 0/1
    let t243 = circuit_sub(t241, t185); // Fp2 sub coeff 1/1
    let t244 = circuit_add(t242, t176); // Fp2 add coeff 0/1
    let t245 = circuit_add(t243, t179); // Fp2 add coeff 1/1
    let t246 = circuit_sub(t50, t128); // Fp6 sub coeff 0/5
    let t247 = circuit_sub(t51, t129); // Fp6 sub coeff 1/5
    let t248 = circuit_sub(t72, t150); // Fp6 sub coeff 2/5
    let t249 = circuit_sub(t73, t151); // Fp6 sub coeff 3/5
    let t250 = circuit_sub(t88, t166); // Fp6 sub coeff 4/5
    let t251 = circuit_sub(t89, t167); // Fp6 sub coeff 5/5
    let t252 = circuit_sub(t246, t206); // Fp6 sub coeff 0/5
    let t253 = circuit_sub(t247, t207); // Fp6 sub coeff 1/5
    let t254 = circuit_sub(t248, t228); // Fp6 sub coeff 2/5
    let t255 = circuit_sub(t249, t229); // Fp6 sub coeff 3/5
    let t256 = circuit_sub(t250, t244); // Fp6 sub coeff 4/5
    let t257 = circuit_sub(t251, t245); // Fp6 sub coeff 5/5
    let t258 = circuit_add(t244, t245);
    let t259 = circuit_mul(t258, in0);
    let t260 = circuit_mul(t244, in1);
    let t261 = circuit_sub(t260, t245);
    let t262 = circuit_sub(t259, t260);
    let t263 = circuit_sub(t262, t245);
    let t264 = circuit_add(t261, t128); // Fp6 add coeff 0/5
    let t265 = circuit_add(t263, t129); // Fp6 add coeff 1/5
    let t266 = circuit_add(t206, t150); // Fp6 add coeff 2/5
    let t267 = circuit_add(t207, t151); // Fp6 add coeff 3/5
    let t268 = circuit_add(t228, t166); // Fp6 add coeff 4/5
    let t269 = circuit_add(t229, t167); // Fp6 add coeff 5/5

    let modulus = get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (
        t264, t265, t266, t267, t268, t269, t252, t253, t254, t255, t256, t257,
    )
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0xa, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs.next_2([0x9, 0x0, 0x0, 0x0]); // in1
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(X.c0b0a0); // in2
    circuit_inputs = circuit_inputs.next_2(X.c0b0a1); // in3
    circuit_inputs = circuit_inputs.next_2(X.c0b1a0); // in4
    circuit_inputs = circuit_inputs.next_2(X.c0b1a1); // in5
    circuit_inputs = circuit_inputs.next_2(X.c0b2a0); // in6
    circuit_inputs = circuit_inputs.next_2(X.c0b2a1); // in7
    circuit_inputs = circuit_inputs.next_2(X.c1b0a0); // in8
    circuit_inputs = circuit_inputs.next_2(X.c1b0a1); // in9
    circuit_inputs = circuit_inputs.next_2(X.c1b1a0); // in10
    circuit_inputs = circuit_inputs.next_2(X.c1b1a1); // in11
    circuit_inputs = circuit_inputs.next_2(X.c1b2a0); // in12
    circuit_inputs = circuit_inputs.next_2(X.c1b2a1); // in13
    circuit_inputs = circuit_inputs.next_2(Y.c0b0a0); // in14
    circuit_inputs = circuit_inputs.next_2(Y.c0b0a1); // in15
    circuit_inputs = circuit_inputs.next_2(Y.c0b1a0); // in16
    circuit_inputs = circuit_inputs.next_2(Y.c0b1a1); // in17
    circuit_inputs = circuit_inputs.next_2(Y.c0b2a0); // in18
    circuit_inputs = circuit_inputs.next_2(Y.c0b2a1); // in19
    circuit_inputs = circuit_inputs.next_2(Y.c1b0a0); // in20
    circuit_inputs = circuit_inputs.next_2(Y.c1b0a1); // in21
    circuit_inputs = circuit_inputs.next_2(Y.c1b1a0); // in22
    circuit_inputs = circuit_inputs.next_2(Y.c1b1a1); // in23
    circuit_inputs = circuit_inputs.next_2(Y.c1b2a0); // in24
    circuit_inputs = circuit_inputs.next_2(Y.c1b2a1); // in25

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: E12T = E12T {
        c0b0a0: outputs.get_output(t264),
        c0b0a1: outputs.get_output(t265),
        c0b1a0: outputs.get_output(t266),
        c0b1a1: outputs.get_output(t267),
        c0b2a0: outputs.get_output(t268),
        c0b2a1: outputs.get_output(t269),
        c1b0a0: outputs.get_output(t252),
        c1b0a1: outputs.get_output(t253),
        c1b1a0: outputs.get_output(t254),
        c1b1a1: outputs.get_output(t255),
        c1b2a0: outputs.get_output(t256),
        c1b2a1: outputs.get_output(t257),
    };
    return (res,);
}
#[inline(always)]
pub fn run_BN254_TOWER_MILLER_BIT0_1P_circuit(
    yInv_0: u384, xNegOverY_0: u384, Q_0: G2Point, M_i: E12T,
) -> (G2Point, E12T) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0xa
    let in1 = CE::<CI<1>> {}; // 0x9
    let in2 = CE::<CI<2>> {}; // 0x0
    let in3 = CE::<CI<3>> {}; // 0x3
    let in4 = CE::<CI<4>> {}; // 0x6
    let in5 = CE::<CI<5>> {}; // 0x1

    // INPUT stack
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13, in14) = (CE::<CI<12>> {}, CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16, in17) = (CE::<CI<15>> {}, CE::<CI<16>> {}, CE::<CI<17>> {});
    let (in18, in19, in20) = (CE::<CI<18>> {}, CE::<CI<19>> {}, CE::<CI<20>> {});
    let (in21, in22, in23) = (CE::<CI<21>> {}, CE::<CI<22>> {}, CE::<CI<23>> {});
    let t0 = circuit_sub(in12, in18); // Fp6 sub coeff 0/5
    let t1 = circuit_sub(in13, in19); // Fp6 sub coeff 1/5
    let t2 = circuit_sub(in14, in20); // Fp6 sub coeff 2/5
    let t3 = circuit_sub(in15, in21); // Fp6 sub coeff 3/5
    let t4 = circuit_sub(in16, in22); // Fp6 sub coeff 4/5
    let t5 = circuit_sub(in17, in23); // Fp6 sub coeff 5/5
    let t6 = circuit_add(in22, in23);
    let t7 = circuit_mul(t6, in0);
    let t8 = circuit_mul(in22, in1);
    let t9 = circuit_sub(t8, in23);
    let t10 = circuit_sub(t7, t8);
    let t11 = circuit_sub(t10, in23);
    let t12 = circuit_sub(in2, t9); // Fp6 neg coeff 0/5
    let t13 = circuit_sub(in2, t11); // Fp6 neg coeff 1/5
    let t14 = circuit_sub(in2, in18); // Fp6 neg coeff 2/5
    let t15 = circuit_sub(in2, in19); // Fp6 neg coeff 3/5
    let t16 = circuit_sub(in2, in20); // Fp6 neg coeff 4/5
    let t17 = circuit_sub(in2, in21); // Fp6 neg coeff 5/5
    let t18 = circuit_add(in12, t12); // Fp6 add coeff 0/5
    let t19 = circuit_add(in13, t13); // Fp6 add coeff 1/5
    let t20 = circuit_add(in14, t14); // Fp6 add coeff 2/5
    let t21 = circuit_add(in15, t15); // Fp6 add coeff 3/5
    let t22 = circuit_add(in16, t16); // Fp6 add coeff 4/5
    let t23 = circuit_add(in17, t17); // Fp6 add coeff 5/5
    let t24 = circuit_mul(in12, in18); // Fp2 mul start
    let t25 = circuit_mul(in13, in19);
    let t26 = circuit_sub(t24, t25); // Fp2 mul real part end
    let t27 = circuit_mul(in12, in19);
    let t28 = circuit_mul(in13, in18);
    let t29 = circuit_add(t27, t28); // Fp2 mul imag part end
    let t30 = circuit_mul(in14, in20); // Fp2 mul start
    let t31 = circuit_mul(in15, in21);
    let t32 = circuit_sub(t30, t31); // Fp2 mul real part end
    let t33 = circuit_mul(in14, in21);
    let t34 = circuit_mul(in15, in20);
    let t35 = circuit_add(t33, t34); // Fp2 mul imag part end
    let t36 = circuit_mul(in16, in22); // Fp2 mul start
    let t37 = circuit_mul(in17, in23);
    let t38 = circuit_sub(t36, t37); // Fp2 mul real part end
    let t39 = circuit_mul(in16, in23);
    let t40 = circuit_mul(in17, in22);
    let t41 = circuit_add(t39, t40); // Fp2 mul imag part end
    let t42 = circuit_add(in14, in16); // Fp2 add coeff 0/1
    let t43 = circuit_add(in15, in17); // Fp2 add coeff 1/1
    let t44 = circuit_add(in20, in22); // Fp2 add coeff 0/1
    let t45 = circuit_add(in21, in23); // Fp2 add coeff 1/1
    let t46 = circuit_mul(t42, t44); // Fp2 mul start
    let t47 = circuit_mul(t43, t45);
    let t48 = circuit_sub(t46, t47); // Fp2 mul real part end
    let t49 = circuit_mul(t42, t45);
    let t50 = circuit_mul(t43, t44);
    let t51 = circuit_add(t49, t50); // Fp2 mul imag part end
    let t52 = circuit_sub(t48, t32); // Fp2 sub coeff 0/1
    let t53 = circuit_sub(t51, t35); // Fp2 sub coeff 1/1
    let t54 = circuit_sub(t52, t38); // Fp2 sub coeff 0/1
    let t55 = circuit_sub(t53, t41); // Fp2 sub coeff 1/1
    let t56 = circuit_add(t54, t55);
    let t57 = circuit_mul(t56, in0);
    let t58 = circuit_mul(t54, in1);
    let t59 = circuit_sub(t58, t55);
    let t60 = circuit_sub(t57, t58);
    let t61 = circuit_sub(t60, t55);
    let t62 = circuit_add(t59, t26); // Fp2 add coeff 0/1
    let t63 = circuit_add(t61, t29); // Fp2 add coeff 1/1
    let t64 = circuit_add(in12, in14); // Fp2 add coeff 0/1
    let t65 = circuit_add(in13, in15); // Fp2 add coeff 1/1
    let t66 = circuit_add(in18, in20); // Fp2 add coeff 0/1
    let t67 = circuit_add(in19, in21); // Fp2 add coeff 1/1
    let t68 = circuit_mul(t64, t66); // Fp2 mul start
    let t69 = circuit_mul(t65, t67);
    let t70 = circuit_sub(t68, t69); // Fp2 mul real part end
    let t71 = circuit_mul(t64, t67);
    let t72 = circuit_mul(t65, t66);
    let t73 = circuit_add(t71, t72); // Fp2 mul imag part end
    let t74 = circuit_sub(t70, t26); // Fp2 sub coeff 0/1
    let t75 = circuit_sub(t73, t29); // Fp2 sub coeff 1/1
    let t76 = circuit_sub(t74, t32); // Fp2 sub coeff 0/1
    let t77 = circuit_sub(t75, t35); // Fp2 sub coeff 1/1
    let t78 = circuit_add(t38, t41);
    let t79 = circuit_mul(t78, in0);
    let t80 = circuit_mul(t38, in1);
    let t81 = circuit_sub(t80, t41);
    let t82 = circuit_sub(t79, t80);
    let t83 = circuit_sub(t82, t41);
    let t84 = circuit_add(t76, t81); // Fp2 add coeff 0/1
    let t85 = circuit_add(t77, t83); // Fp2 add coeff 1/1
    let t86 = circuit_add(in12, in16); // Fp2 add coeff 0/1
    let t87 = circuit_add(in13, in17); // Fp2 add coeff 1/1
    let t88 = circuit_add(in18, in22); // Fp2 add coeff 0/1
    let t89 = circuit_add(in19, in23); // Fp2 add coeff 1/1
    let t90 = circuit_mul(t88, t86); // Fp2 mul start
    let t91 = circuit_mul(t89, t87);
    let t92 = circuit_sub(t90, t91); // Fp2 mul real part end
    let t93 = circuit_mul(t88, t87);
    let t94 = circuit_mul(t89, t86);
    let t95 = circuit_add(t93, t94); // Fp2 mul imag part end
    let t96 = circuit_sub(t92, t26); // Fp2 sub coeff 0/1
    let t97 = circuit_sub(t95, t29); // Fp2 sub coeff 1/1
    let t98 = circuit_sub(t96, t38); // Fp2 sub coeff 0/1
    let t99 = circuit_sub(t97, t41); // Fp2 sub coeff 1/1
    let t100 = circuit_add(t98, t32); // Fp2 add coeff 0/1
    let t101 = circuit_add(t99, t35); // Fp2 add coeff 1/1
    let t102 = circuit_mul(t0, t18); // Fp2 mul start
    let t103 = circuit_mul(t1, t19);
    let t104 = circuit_sub(t102, t103); // Fp2 mul real part end
    let t105 = circuit_mul(t0, t19);
    let t106 = circuit_mul(t1, t18);
    let t107 = circuit_add(t105, t106); // Fp2 mul imag part end
    let t108 = circuit_mul(t2, t20); // Fp2 mul start
    let t109 = circuit_mul(t3, t21);
    let t110 = circuit_sub(t108, t109); // Fp2 mul real part end
    let t111 = circuit_mul(t2, t21);
    let t112 = circuit_mul(t3, t20);
    let t113 = circuit_add(t111, t112); // Fp2 mul imag part end
    let t114 = circuit_mul(t4, t22); // Fp2 mul start
    let t115 = circuit_mul(t5, t23);
    let t116 = circuit_sub(t114, t115); // Fp2 mul real part end
    let t117 = circuit_mul(t4, t23);
    let t118 = circuit_mul(t5, t22);
    let t119 = circuit_add(t117, t118); // Fp2 mul imag part end
    let t120 = circuit_add(t2, t4); // Fp2 add coeff 0/1
    let t121 = circuit_add(t3, t5); // Fp2 add coeff 1/1
    let t122 = circuit_add(t20, t22); // Fp2 add coeff 0/1
    let t123 = circuit_add(t21, t23); // Fp2 add coeff 1/1
    let t124 = circuit_mul(t120, t122); // Fp2 mul start
    let t125 = circuit_mul(t121, t123);
    let t126 = circuit_sub(t124, t125); // Fp2 mul real part end
    let t127 = circuit_mul(t120, t123);
    let t128 = circuit_mul(t121, t122);
    let t129 = circuit_add(t127, t128); // Fp2 mul imag part end
    let t130 = circuit_sub(t126, t110); // Fp2 sub coeff 0/1
    let t131 = circuit_sub(t129, t113); // Fp2 sub coeff 1/1
    let t132 = circuit_sub(t130, t116); // Fp2 sub coeff 0/1
    let t133 = circuit_sub(t131, t119); // Fp2 sub coeff 1/1
    let t134 = circuit_add(t132, t133);
    let t135 = circuit_mul(t134, in0);
    let t136 = circuit_mul(t132, in1);
    let t137 = circuit_sub(t136, t133);
    let t138 = circuit_sub(t135, t136);
    let t139 = circuit_sub(t138, t133);
    let t140 = circuit_add(t137, t104); // Fp2 add coeff 0/1
    let t141 = circuit_add(t139, t107); // Fp2 add coeff 1/1
    let t142 = circuit_add(t0, t2); // Fp2 add coeff 0/1
    let t143 = circuit_add(t1, t3); // Fp2 add coeff 1/1
    let t144 = circuit_add(t18, t20); // Fp2 add coeff 0/1
    let t145 = circuit_add(t19, t21); // Fp2 add coeff 1/1
    let t146 = circuit_mul(t142, t144); // Fp2 mul start
    let t147 = circuit_mul(t143, t145);
    let t148 = circuit_sub(t146, t147); // Fp2 mul real part end
    let t149 = circuit_mul(t142, t145);
    let t150 = circuit_mul(t143, t144);
    let t151 = circuit_add(t149, t150); // Fp2 mul imag part end
    let t152 = circuit_sub(t148, t104); // Fp2 sub coeff 0/1
    let t153 = circuit_sub(t151, t107); // Fp2 sub coeff 1/1
    let t154 = circuit_sub(t152, t110); // Fp2 sub coeff 0/1
    let t155 = circuit_sub(t153, t113); // Fp2 sub coeff 1/1
    let t156 = circuit_add(t116, t119);
    let t157 = circuit_mul(t156, in0);
    let t158 = circuit_mul(t116, in1);
    let t159 = circuit_sub(t158, t119);
    let t160 = circuit_sub(t157, t158);
    let t161 = circuit_sub(t160, t119);
    let t162 = circuit_add(t154, t159); // Fp2 add coeff 0/1
    let t163 = circuit_add(t155, t161); // Fp2 add coeff 1/1
    let t164 = circuit_add(t0, t4); // Fp2 add coeff 0/1
    let t165 = circuit_add(t1, t5); // Fp2 add coeff 1/1
    let t166 = circuit_add(t18, t22); // Fp2 add coeff 0/1
    let t167 = circuit_add(t19, t23); // Fp2 add coeff 1/1
    let t168 = circuit_mul(t166, t164); // Fp2 mul start
    let t169 = circuit_mul(t167, t165);
    let t170 = circuit_sub(t168, t169); // Fp2 mul real part end
    let t171 = circuit_mul(t166, t165);
    let t172 = circuit_mul(t167, t164);
    let t173 = circuit_add(t171, t172); // Fp2 mul imag part end
    let t174 = circuit_sub(t170, t104); // Fp2 sub coeff 0/1
    let t175 = circuit_sub(t173, t107); // Fp2 sub coeff 1/1
    let t176 = circuit_sub(t174, t116); // Fp2 sub coeff 0/1
    let t177 = circuit_sub(t175, t119); // Fp2 sub coeff 1/1
    let t178 = circuit_add(t176, t110); // Fp2 add coeff 0/1
    let t179 = circuit_add(t177, t113); // Fp2 add coeff 1/1
    let t180 = circuit_add(t140, t62); // Fp6 add coeff 0/5
    let t181 = circuit_add(t141, t63); // Fp6 add coeff 1/5
    let t182 = circuit_add(t162, t84); // Fp6 add coeff 2/5
    let t183 = circuit_add(t163, t85); // Fp6 add coeff 3/5
    let t184 = circuit_add(t178, t100); // Fp6 add coeff 4/5
    let t185 = circuit_add(t179, t101); // Fp6 add coeff 5/5
    let t186 = circuit_add(t62, t62); // Fp6 add coeff 0/5
    let t187 = circuit_add(t63, t63); // Fp6 add coeff 1/5
    let t188 = circuit_add(t84, t84); // Fp6 add coeff 2/5
    let t189 = circuit_add(t85, t85); // Fp6 add coeff 3/5
    let t190 = circuit_add(t100, t100); // Fp6 add coeff 4/5
    let t191 = circuit_add(t101, t101); // Fp6 add coeff 5/5
    let t192 = circuit_add(t100, t101);
    let t193 = circuit_mul(t192, in0);
    let t194 = circuit_mul(t100, in1);
    let t195 = circuit_sub(t194, t101);
    let t196 = circuit_sub(t193, t194);
    let t197 = circuit_sub(t196, t101);
    let t198 = circuit_add(t180, t195); // Fp6 add coeff 0/5
    let t199 = circuit_add(t181, t197); // Fp6 add coeff 1/5
    let t200 = circuit_add(t182, t62); // Fp6 add coeff 2/5
    let t201 = circuit_add(t183, t63); // Fp6 add coeff 3/5
    let t202 = circuit_add(t184, t84); // Fp6 add coeff 4/5
    let t203 = circuit_add(t185, t85); // Fp6 add coeff 5/5
    let t204 = circuit_add(in8, in9); // Doubling slope numerator start
    let t205 = circuit_sub(in8, in9);
    let t206 = circuit_mul(t204, t205);
    let t207 = circuit_mul(in8, in9);
    let t208 = circuit_mul(t206, in3);
    let t209 = circuit_mul(t207, in4); // Doubling slope numerator end
    let t210 = circuit_add(in10, in10); // Fp2 add coeff 0/1
    let t211 = circuit_add(in11, in11); // Fp2 add coeff 1/1
    let t212 = circuit_mul(t210, t210); // Fp2 Inv start
    let t213 = circuit_mul(t211, t211);
    let t214 = circuit_add(t212, t213);
    let t215 = circuit_inverse(t214);
    let t216 = circuit_mul(t210, t215); // Fp2 Inv real part end
    let t217 = circuit_mul(t211, t215);
    let t218 = circuit_sub(in2, t217); // Fp2 Inv imag part end
    let t219 = circuit_mul(t208, t216); // Fp2 mul start
    let t220 = circuit_mul(t209, t218);
    let t221 = circuit_sub(t219, t220); // Fp2 mul real part end
    let t222 = circuit_mul(t208, t218);
    let t223 = circuit_mul(t209, t216);
    let t224 = circuit_add(t222, t223); // Fp2 mul imag part end
    let t225 = circuit_add(t221, t224);
    let t226 = circuit_sub(t221, t224);
    let t227 = circuit_mul(t225, t226);
    let t228 = circuit_mul(t221, t224);
    let t229 = circuit_add(t228, t228);
    let t230 = circuit_add(in8, in8); // Fp2 add coeff 0/1
    let t231 = circuit_add(in9, in9); // Fp2 add coeff 1/1
    let t232 = circuit_sub(t227, t230); // Fp2 sub coeff 0/1
    let t233 = circuit_sub(t229, t231); // Fp2 sub coeff 1/1
    let t234 = circuit_sub(in8, t232); // Fp2 sub coeff 0/1
    let t235 = circuit_sub(in9, t233); // Fp2 sub coeff 1/1
    let t236 = circuit_mul(t221, t234); // Fp2 mul start
    let t237 = circuit_mul(t224, t235);
    let t238 = circuit_sub(t236, t237); // Fp2 mul real part end
    let t239 = circuit_mul(t221, t235);
    let t240 = circuit_mul(t224, t234);
    let t241 = circuit_add(t239, t240); // Fp2 mul imag part end
    let t242 = circuit_sub(t238, in10); // Fp2 sub coeff 0/1
    let t243 = circuit_sub(t241, in11); // Fp2 sub coeff 1/1
    let t244 = circuit_mul(t221, in8); // Fp2 mul start
    let t245 = circuit_mul(t224, in9);
    let t246 = circuit_sub(t244, t245); // Fp2 mul real part end
    let t247 = circuit_mul(t221, in9);
    let t248 = circuit_mul(t224, in8);
    let t249 = circuit_add(t247, t248); // Fp2 mul imag part end
    let t250 = circuit_sub(t246, in10); // Fp2 sub coeff 0/1
    let t251 = circuit_sub(t249, in11); // Fp2 sub coeff 1/1
    let t252 = circuit_mul(t221, in7);
    let t253 = circuit_mul(t224, in7);
    let t254 = circuit_mul(t250, in6);
    let t255 = circuit_mul(t251, in6);
    let t256 = circuit_mul(t186, t252); // Fp2 mul start
    let t257 = circuit_mul(t187, t253);
    let t258 = circuit_sub(t256, t257); // Fp2 mul real part end
    let t259 = circuit_mul(t186, t253);
    let t260 = circuit_mul(t187, t252);
    let t261 = circuit_add(t259, t260); // Fp2 mul imag part end
    let t262 = circuit_mul(t188, t254); // Fp2 mul start
    let t263 = circuit_mul(t189, t255);
    let t264 = circuit_sub(t262, t263); // Fp2 mul real part end
    let t265 = circuit_mul(t188, t255);
    let t266 = circuit_mul(t189, t254);
    let t267 = circuit_add(t265, t266); // Fp2 mul imag part end
    let t268 = circuit_add(t188, t190); // Fp2 add coeff 0/1
    let t269 = circuit_add(t189, t191); // Fp2 add coeff 1/1
    let t270 = circuit_mul(t254, t268); // Fp2 mul start
    let t271 = circuit_mul(t255, t269);
    let t272 = circuit_sub(t270, t271); // Fp2 mul real part end
    let t273 = circuit_mul(t254, t269);
    let t274 = circuit_mul(t255, t268);
    let t275 = circuit_add(t273, t274); // Fp2 mul imag part end
    let t276 = circuit_sub(t272, t264); // Fp2 sub coeff 0/1
    let t277 = circuit_sub(t275, t267); // Fp2 sub coeff 1/1
    let t278 = circuit_add(t276, t277);
    let t279 = circuit_mul(t278, in0);
    let t280 = circuit_mul(t276, in1);
    let t281 = circuit_sub(t280, t277);
    let t282 = circuit_sub(t279, t280);
    let t283 = circuit_sub(t282, t277);
    let t284 = circuit_add(t281, t258); // Fp2 add coeff 0/1
    let t285 = circuit_add(t283, t261); // Fp2 add coeff 1/1
    let t286 = circuit_add(t186, t190); // Fp2 add coeff 0/1
    let t287 = circuit_add(t187, t191); // Fp2 add coeff 1/1
    let t288 = circuit_mul(t252, t286); // Fp2 mul start
    let t289 = circuit_mul(t253, t287);
    let t290 = circuit_sub(t288, t289); // Fp2 mul real part end
    let t291 = circuit_mul(t252, t287);
    let t292 = circuit_mul(t253, t286);
    let t293 = circuit_add(t291, t292); // Fp2 mul imag part end
    let t294 = circuit_sub(t290, t258); // Fp2 sub coeff 0/1
    let t295 = circuit_sub(t293, t261); // Fp2 sub coeff 1/1
    let t296 = circuit_add(t294, t264); // Fp2 add coeff 0/1
    let t297 = circuit_add(t295, t267); // Fp2 add coeff 1/1
    let t298 = circuit_add(t252, t254); // Fp2 add coeff 0/1
    let t299 = circuit_add(t253, t255); // Fp2 add coeff 1/1
    let t300 = circuit_add(t186, t188); // Fp2 add coeff 0/1
    let t301 = circuit_add(t187, t189); // Fp2 add coeff 1/1
    let t302 = circuit_mul(t298, t300); // Fp2 mul start
    let t303 = circuit_mul(t299, t301);
    let t304 = circuit_sub(t302, t303); // Fp2 mul real part end
    let t305 = circuit_mul(t298, t301);
    let t306 = circuit_mul(t299, t300);
    let t307 = circuit_add(t305, t306); // Fp2 mul imag part end
    let t308 = circuit_sub(t304, t258); // Fp2 sub coeff 0/1
    let t309 = circuit_sub(t307, t261); // Fp2 sub coeff 1/1
    let t310 = circuit_sub(t308, t264); // Fp2 sub coeff 0/1
    let t311 = circuit_sub(t309, t267); // Fp2 sub coeff 1/1
    let t312 = circuit_add(in5, t252); // Fp2 add coeff 0/1
    let t313 = circuit_add(in2, t253); // Fp2 add coeff 1/1
    let t314 = circuit_add(t198, t186); // Fp6 add coeff 0/5
    let t315 = circuit_add(t199, t187); // Fp6 add coeff 1/5
    let t316 = circuit_add(t200, t188); // Fp6 add coeff 2/5
    let t317 = circuit_add(t201, t189); // Fp6 add coeff 3/5
    let t318 = circuit_add(t202, t190); // Fp6 add coeff 4/5
    let t319 = circuit_add(t203, t191); // Fp6 add coeff 5/5
    let t320 = circuit_mul(t314, t312); // Fp2 mul start
    let t321 = circuit_mul(t315, t313);
    let t322 = circuit_sub(t320, t321); // Fp2 mul real part end
    let t323 = circuit_mul(t314, t313);
    let t324 = circuit_mul(t315, t312);
    let t325 = circuit_add(t323, t324); // Fp2 mul imag part end
    let t326 = circuit_mul(t316, t254); // Fp2 mul start
    let t327 = circuit_mul(t317, t255);
    let t328 = circuit_sub(t326, t327); // Fp2 mul real part end
    let t329 = circuit_mul(t316, t255);
    let t330 = circuit_mul(t317, t254);
    let t331 = circuit_add(t329, t330); // Fp2 mul imag part end
    let t332 = circuit_add(t316, t318); // Fp2 add coeff 0/1
    let t333 = circuit_add(t317, t319); // Fp2 add coeff 1/1
    let t334 = circuit_mul(t254, t332); // Fp2 mul start
    let t335 = circuit_mul(t255, t333);
    let t336 = circuit_sub(t334, t335); // Fp2 mul real part end
    let t337 = circuit_mul(t254, t333);
    let t338 = circuit_mul(t255, t332);
    let t339 = circuit_add(t337, t338); // Fp2 mul imag part end
    let t340 = circuit_sub(t336, t328); // Fp2 sub coeff 0/1
    let t341 = circuit_sub(t339, t331); // Fp2 sub coeff 1/1
    let t342 = circuit_add(t340, t341);
    let t343 = circuit_mul(t342, in0);
    let t344 = circuit_mul(t340, in1);
    let t345 = circuit_sub(t344, t341);
    let t346 = circuit_sub(t343, t344);
    let t347 = circuit_sub(t346, t341);
    let t348 = circuit_add(t345, t322); // Fp2 add coeff 0/1
    let t349 = circuit_add(t347, t325); // Fp2 add coeff 1/1
    let t350 = circuit_add(t314, t318); // Fp2 add coeff 0/1
    let t351 = circuit_add(t315, t319); // Fp2 add coeff 1/1
    let t352 = circuit_mul(t312, t350); // Fp2 mul start
    let t353 = circuit_mul(t313, t351);
    let t354 = circuit_sub(t352, t353); // Fp2 mul real part end
    let t355 = circuit_mul(t312, t351);
    let t356 = circuit_mul(t313, t350);
    let t357 = circuit_add(t355, t356); // Fp2 mul imag part end
    let t358 = circuit_sub(t354, t322); // Fp2 sub coeff 0/1
    let t359 = circuit_sub(t357, t325); // Fp2 sub coeff 1/1
    let t360 = circuit_add(t358, t328); // Fp2 add coeff 0/1
    let t361 = circuit_add(t359, t331); // Fp2 add coeff 1/1
    let t362 = circuit_add(t312, t254); // Fp2 add coeff 0/1
    let t363 = circuit_add(t313, t255); // Fp2 add coeff 1/1
    let t364 = circuit_add(t314, t316); // Fp2 add coeff 0/1
    let t365 = circuit_add(t315, t317); // Fp2 add coeff 1/1
    let t366 = circuit_mul(t362, t364); // Fp2 mul start
    let t367 = circuit_mul(t363, t365);
    let t368 = circuit_sub(t366, t367); // Fp2 mul real part end
    let t369 = circuit_mul(t362, t365);
    let t370 = circuit_mul(t363, t364);
    let t371 = circuit_add(t369, t370); // Fp2 mul imag part end
    let t372 = circuit_sub(t368, t322); // Fp2 sub coeff 0/1
    let t373 = circuit_sub(t371, t325); // Fp2 sub coeff 1/1
    let t374 = circuit_sub(t372, t328); // Fp2 sub coeff 0/1
    let t375 = circuit_sub(t373, t331); // Fp2 sub coeff 1/1
    let t376 = circuit_add(t198, t284); // Fp6 add coeff 0/5
    let t377 = circuit_add(t199, t285); // Fp6 add coeff 1/5
    let t378 = circuit_add(t200, t310); // Fp6 add coeff 2/5
    let t379 = circuit_add(t201, t311); // Fp6 add coeff 3/5
    let t380 = circuit_add(t202, t296); // Fp6 add coeff 4/5
    let t381 = circuit_add(t203, t297); // Fp6 add coeff 5/5
    let t382 = circuit_sub(in2, t376); // Fp6 neg coeff 0/5
    let t383 = circuit_sub(in2, t377); // Fp6 neg coeff 1/5
    let t384 = circuit_sub(in2, t378); // Fp6 neg coeff 2/5
    let t385 = circuit_sub(in2, t379); // Fp6 neg coeff 3/5
    let t386 = circuit_sub(in2, t380); // Fp6 neg coeff 4/5
    let t387 = circuit_sub(in2, t381); // Fp6 neg coeff 5/5
    let t388 = circuit_add(t382, t348); // Fp6 add coeff 0/5
    let t389 = circuit_add(t383, t349); // Fp6 add coeff 1/5
    let t390 = circuit_add(t384, t374); // Fp6 add coeff 2/5
    let t391 = circuit_add(t385, t375); // Fp6 add coeff 3/5
    let t392 = circuit_add(t386, t360); // Fp6 add coeff 4/5
    let t393 = circuit_add(t387, t361); // Fp6 add coeff 5/5
    let t394 = circuit_add(t296, t297);
    let t395 = circuit_mul(t394, in0);
    let t396 = circuit_mul(t296, in1);
    let t397 = circuit_sub(t396, t297);
    let t398 = circuit_sub(t395, t396);
    let t399 = circuit_sub(t398, t297);
    let t400 = circuit_add(t397, t198); // Fp6 add coeff 0/5
    let t401 = circuit_add(t399, t199); // Fp6 add coeff 1/5
    let t402 = circuit_add(t284, t200); // Fp6 add coeff 2/5
    let t403 = circuit_add(t285, t201); // Fp6 add coeff 3/5
    let t404 = circuit_add(t310, t202); // Fp6 add coeff 4/5
    let t405 = circuit_add(t311, t203); // Fp6 add coeff 5/5
    let t406 = circuit_add(t232, t233);
    let t407 = circuit_add(t406, t242);
    let t408 = circuit_add(t407, t243);

    let modulus = get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (
        t408, t400, t401, t402, t403, t404, t405, t388, t389, t390, t391, t392, t393,
    )
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0xa, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs.next_2([0x9, 0x0, 0x0, 0x0]); // in1
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in2
    circuit_inputs = circuit_inputs.next_2([0x3, 0x0, 0x0, 0x0]); // in3
    circuit_inputs = circuit_inputs.next_2([0x6, 0x0, 0x0, 0x0]); // in4
    circuit_inputs = circuit_inputs.next_2([0x1, 0x0, 0x0, 0x0]); // in5
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(yInv_0); // in6
    circuit_inputs = circuit_inputs.next_2(xNegOverY_0); // in7
    circuit_inputs = circuit_inputs.next_2(Q_0.x0); // in8
    circuit_inputs = circuit_inputs.next_2(Q_0.x1); // in9
    circuit_inputs = circuit_inputs.next_2(Q_0.y0); // in10
    circuit_inputs = circuit_inputs.next_2(Q_0.y1); // in11
    circuit_inputs = circuit_inputs.next_2(M_i.c0b0a0); // in12
    circuit_inputs = circuit_inputs.next_2(M_i.c0b0a1); // in13
    circuit_inputs = circuit_inputs.next_2(M_i.c0b1a0); // in14
    circuit_inputs = circuit_inputs.next_2(M_i.c0b1a1); // in15
    circuit_inputs = circuit_inputs.next_2(M_i.c0b2a0); // in16
    circuit_inputs = circuit_inputs.next_2(M_i.c0b2a1); // in17
    circuit_inputs = circuit_inputs.next_2(M_i.c1b0a0); // in18
    circuit_inputs = circuit_inputs.next_2(M_i.c1b0a1); // in19
    circuit_inputs = circuit_inputs.next_2(M_i.c1b1a0); // in20
    circuit_inputs = circuit_inputs.next_2(M_i.c1b1a1); // in21
    circuit_inputs = circuit_inputs.next_2(M_i.c1b2a0); // in22
    circuit_inputs = circuit_inputs.next_2(M_i.c1b2a1); // in23

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let Q0: G2Point = G2Point {
        x0: outputs.get_output(t232),
        x1: outputs.get_output(t233),
        y0: outputs.get_output(t242),
        y1: outputs.get_output(t243),
    };
    let Mi_plus_one: E12T = E12T {
        c0b0a0: outputs.get_output(t400),
        c0b0a1: outputs.get_output(t401),
        c0b1a0: outputs.get_output(t402),
        c0b1a1: outputs.get_output(t403),
        c0b2a0: outputs.get_output(t404),
        c0b2a1: outputs.get_output(t405),
        c1b0a0: outputs.get_output(t388),
        c1b0a1: outputs.get_output(t389),
        c1b1a0: outputs.get_output(t390),
        c1b1a1: outputs.get_output(t391),
        c1b2a0: outputs.get_output(t392),
        c1b2a1: outputs.get_output(t393),
    };
    return (Q0, Mi_plus_one);
}
#[inline(always)]
pub fn run_BN254_TOWER_MILLER_BIT1_1P_circuit(
    yInv_0: u384, xNegOverY_0: u384, Q_0: G2Point, Q_or_Q_neg_0: G2Point, M_i: E12T,
) -> (G2Point, E12T) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0xa
    let in1 = CE::<CI<1>> {}; // 0x9
    let in2 = CE::<CI<2>> {}; // 0x0
    let in3 = CE::<CI<3>> {}; // 0x1

    // INPUT stack
    let (in4, in5, in6) = (CE::<CI<4>> {}, CE::<CI<5>> {}, CE::<CI<6>> {});
    let (in7, in8, in9) = (CE::<CI<7>> {}, CE::<CI<8>> {}, CE::<CI<9>> {});
    let (in10, in11, in12) = (CE::<CI<10>> {}, CE::<CI<11>> {}, CE::<CI<12>> {});
    let (in13, in14, in15) = (CE::<CI<13>> {}, CE::<CI<14>> {}, CE::<CI<15>> {});
    let (in16, in17, in18) = (CE::<CI<16>> {}, CE::<CI<17>> {}, CE::<CI<18>> {});
    let (in19, in20, in21) = (CE::<CI<19>> {}, CE::<CI<20>> {}, CE::<CI<21>> {});
    let (in22, in23, in24) = (CE::<CI<22>> {}, CE::<CI<23>> {}, CE::<CI<24>> {});
    let in25 = CE::<CI<25>> {};
    let t0 = circuit_sub(in14, in20); // Fp6 sub coeff 0/5
    let t1 = circuit_sub(in15, in21); // Fp6 sub coeff 1/5
    let t2 = circuit_sub(in16, in22); // Fp6 sub coeff 2/5
    let t3 = circuit_sub(in17, in23); // Fp6 sub coeff 3/5
    let t4 = circuit_sub(in18, in24); // Fp6 sub coeff 4/5
    let t5 = circuit_sub(in19, in25); // Fp6 sub coeff 5/5
    let t6 = circuit_add(in24, in25);
    let t7 = circuit_mul(t6, in0);
    let t8 = circuit_mul(in24, in1);
    let t9 = circuit_sub(t8, in25);
    let t10 = circuit_sub(t7, t8);
    let t11 = circuit_sub(t10, in25);
    let t12 = circuit_sub(in2, t9); // Fp6 neg coeff 0/5
    let t13 = circuit_sub(in2, t11); // Fp6 neg coeff 1/5
    let t14 = circuit_sub(in2, in20); // Fp6 neg coeff 2/5
    let t15 = circuit_sub(in2, in21); // Fp6 neg coeff 3/5
    let t16 = circuit_sub(in2, in22); // Fp6 neg coeff 4/5
    let t17 = circuit_sub(in2, in23); // Fp6 neg coeff 5/5
    let t18 = circuit_add(in14, t12); // Fp6 add coeff 0/5
    let t19 = circuit_add(in15, t13); // Fp6 add coeff 1/5
    let t20 = circuit_add(in16, t14); // Fp6 add coeff 2/5
    let t21 = circuit_add(in17, t15); // Fp6 add coeff 3/5
    let t22 = circuit_add(in18, t16); // Fp6 add coeff 4/5
    let t23 = circuit_add(in19, t17); // Fp6 add coeff 5/5
    let t24 = circuit_mul(in14, in20); // Fp2 mul start
    let t25 = circuit_mul(in15, in21);
    let t26 = circuit_sub(t24, t25); // Fp2 mul real part end
    let t27 = circuit_mul(in14, in21);
    let t28 = circuit_mul(in15, in20);
    let t29 = circuit_add(t27, t28); // Fp2 mul imag part end
    let t30 = circuit_mul(in16, in22); // Fp2 mul start
    let t31 = circuit_mul(in17, in23);
    let t32 = circuit_sub(t30, t31); // Fp2 mul real part end
    let t33 = circuit_mul(in16, in23);
    let t34 = circuit_mul(in17, in22);
    let t35 = circuit_add(t33, t34); // Fp2 mul imag part end
    let t36 = circuit_mul(in18, in24); // Fp2 mul start
    let t37 = circuit_mul(in19, in25);
    let t38 = circuit_sub(t36, t37); // Fp2 mul real part end
    let t39 = circuit_mul(in18, in25);
    let t40 = circuit_mul(in19, in24);
    let t41 = circuit_add(t39, t40); // Fp2 mul imag part end
    let t42 = circuit_add(in16, in18); // Fp2 add coeff 0/1
    let t43 = circuit_add(in17, in19); // Fp2 add coeff 1/1
    let t44 = circuit_add(in22, in24); // Fp2 add coeff 0/1
    let t45 = circuit_add(in23, in25); // Fp2 add coeff 1/1
    let t46 = circuit_mul(t42, t44); // Fp2 mul start
    let t47 = circuit_mul(t43, t45);
    let t48 = circuit_sub(t46, t47); // Fp2 mul real part end
    let t49 = circuit_mul(t42, t45);
    let t50 = circuit_mul(t43, t44);
    let t51 = circuit_add(t49, t50); // Fp2 mul imag part end
    let t52 = circuit_sub(t48, t32); // Fp2 sub coeff 0/1
    let t53 = circuit_sub(t51, t35); // Fp2 sub coeff 1/1
    let t54 = circuit_sub(t52, t38); // Fp2 sub coeff 0/1
    let t55 = circuit_sub(t53, t41); // Fp2 sub coeff 1/1
    let t56 = circuit_add(t54, t55);
    let t57 = circuit_mul(t56, in0);
    let t58 = circuit_mul(t54, in1);
    let t59 = circuit_sub(t58, t55);
    let t60 = circuit_sub(t57, t58);
    let t61 = circuit_sub(t60, t55);
    let t62 = circuit_add(t59, t26); // Fp2 add coeff 0/1
    let t63 = circuit_add(t61, t29); // Fp2 add coeff 1/1
    let t64 = circuit_add(in14, in16); // Fp2 add coeff 0/1
    let t65 = circuit_add(in15, in17); // Fp2 add coeff 1/1
    let t66 = circuit_add(in20, in22); // Fp2 add coeff 0/1
    let t67 = circuit_add(in21, in23); // Fp2 add coeff 1/1
    let t68 = circuit_mul(t64, t66); // Fp2 mul start
    let t69 = circuit_mul(t65, t67);
    let t70 = circuit_sub(t68, t69); // Fp2 mul real part end
    let t71 = circuit_mul(t64, t67);
    let t72 = circuit_mul(t65, t66);
    let t73 = circuit_add(t71, t72); // Fp2 mul imag part end
    let t74 = circuit_sub(t70, t26); // Fp2 sub coeff 0/1
    let t75 = circuit_sub(t73, t29); // Fp2 sub coeff 1/1
    let t76 = circuit_sub(t74, t32); // Fp2 sub coeff 0/1
    let t77 = circuit_sub(t75, t35); // Fp2 sub coeff 1/1
    let t78 = circuit_add(t38, t41);
    let t79 = circuit_mul(t78, in0);
    let t80 = circuit_mul(t38, in1);
    let t81 = circuit_sub(t80, t41);
    let t82 = circuit_sub(t79, t80);
    let t83 = circuit_sub(t82, t41);
    let t84 = circuit_add(t76, t81); // Fp2 add coeff 0/1
    let t85 = circuit_add(t77, t83); // Fp2 add coeff 1/1
    let t86 = circuit_add(in14, in18); // Fp2 add coeff 0/1
    let t87 = circuit_add(in15, in19); // Fp2 add coeff 1/1
    let t88 = circuit_add(in20, in24); // Fp2 add coeff 0/1
    let t89 = circuit_add(in21, in25); // Fp2 add coeff 1/1
    let t90 = circuit_mul(t88, t86); // Fp2 mul start
    let t91 = circuit_mul(t89, t87);
    let t92 = circuit_sub(t90, t91); // Fp2 mul real part end
    let t93 = circuit_mul(t88, t87);
    let t94 = circuit_mul(t89, t86);
    let t95 = circuit_add(t93, t94); // Fp2 mul imag part end
    let t96 = circuit_sub(t92, t26); // Fp2 sub coeff 0/1
    let t97 = circuit_sub(t95, t29); // Fp2 sub coeff 1/1
    let t98 = circuit_sub(t96, t38); // Fp2 sub coeff 0/1
    let t99 = circuit_sub(t97, t41); // Fp2 sub coeff 1/1
    let t100 = circuit_add(t98, t32); // Fp2 add coeff 0/1
    let t101 = circuit_add(t99, t35); // Fp2 add coeff 1/1
    let t102 = circuit_mul(t0, t18); // Fp2 mul start
    let t103 = circuit_mul(t1, t19);
    let t104 = circuit_sub(t102, t103); // Fp2 mul real part end
    let t105 = circuit_mul(t0, t19);
    let t106 = circuit_mul(t1, t18);
    let t107 = circuit_add(t105, t106); // Fp2 mul imag part end
    let t108 = circuit_mul(t2, t20); // Fp2 mul start
    let t109 = circuit_mul(t3, t21);
    let t110 = circuit_sub(t108, t109); // Fp2 mul real part end
    let t111 = circuit_mul(t2, t21);
    let t112 = circuit_mul(t3, t20);
    let t113 = circuit_add(t111, t112); // Fp2 mul imag part end
    let t114 = circuit_mul(t4, t22); // Fp2 mul start
    let t115 = circuit_mul(t5, t23);
    let t116 = circuit_sub(t114, t115); // Fp2 mul real part end
    let t117 = circuit_mul(t4, t23);
    let t118 = circuit_mul(t5, t22);
    let t119 = circuit_add(t117, t118); // Fp2 mul imag part end
    let t120 = circuit_add(t2, t4); // Fp2 add coeff 0/1
    let t121 = circuit_add(t3, t5); // Fp2 add coeff 1/1
    let t122 = circuit_add(t20, t22); // Fp2 add coeff 0/1
    let t123 = circuit_add(t21, t23); // Fp2 add coeff 1/1
    let t124 = circuit_mul(t120, t122); // Fp2 mul start
    let t125 = circuit_mul(t121, t123);
    let t126 = circuit_sub(t124, t125); // Fp2 mul real part end
    let t127 = circuit_mul(t120, t123);
    let t128 = circuit_mul(t121, t122);
    let t129 = circuit_add(t127, t128); // Fp2 mul imag part end
    let t130 = circuit_sub(t126, t110); // Fp2 sub coeff 0/1
    let t131 = circuit_sub(t129, t113); // Fp2 sub coeff 1/1
    let t132 = circuit_sub(t130, t116); // Fp2 sub coeff 0/1
    let t133 = circuit_sub(t131, t119); // Fp2 sub coeff 1/1
    let t134 = circuit_add(t132, t133);
    let t135 = circuit_mul(t134, in0);
    let t136 = circuit_mul(t132, in1);
    let t137 = circuit_sub(t136, t133);
    let t138 = circuit_sub(t135, t136);
    let t139 = circuit_sub(t138, t133);
    let t140 = circuit_add(t137, t104); // Fp2 add coeff 0/1
    let t141 = circuit_add(t139, t107); // Fp2 add coeff 1/1
    let t142 = circuit_add(t0, t2); // Fp2 add coeff 0/1
    let t143 = circuit_add(t1, t3); // Fp2 add coeff 1/1
    let t144 = circuit_add(t18, t20); // Fp2 add coeff 0/1
    let t145 = circuit_add(t19, t21); // Fp2 add coeff 1/1
    let t146 = circuit_mul(t142, t144); // Fp2 mul start
    let t147 = circuit_mul(t143, t145);
    let t148 = circuit_sub(t146, t147); // Fp2 mul real part end
    let t149 = circuit_mul(t142, t145);
    let t150 = circuit_mul(t143, t144);
    let t151 = circuit_add(t149, t150); // Fp2 mul imag part end
    let t152 = circuit_sub(t148, t104); // Fp2 sub coeff 0/1
    let t153 = circuit_sub(t151, t107); // Fp2 sub coeff 1/1
    let t154 = circuit_sub(t152, t110); // Fp2 sub coeff 0/1
    let t155 = circuit_sub(t153, t113); // Fp2 sub coeff 1/1
    let t156 = circuit_add(t116, t119);
    let t157 = circuit_mul(t156, in0);
    let t158 = circuit_mul(t116, in1);
    let t159 = circuit_sub(t158, t119);
    let t160 = circuit_sub(t157, t158);
    let t161 = circuit_sub(t160, t119);
    let t162 = circuit_add(t154, t159); // Fp2 add coeff 0/1
    let t163 = circuit_add(t155, t161); // Fp2 add coeff 1/1
    let t164 = circuit_add(t0, t4); // Fp2 add coeff 0/1
    let t165 = circuit_add(t1, t5); // Fp2 add coeff 1/1
    let t166 = circuit_add(t18, t22); // Fp2 add coeff 0/1
    let t167 = circuit_add(t19, t23); // Fp2 add coeff 1/1
    let t168 = circuit_mul(t166, t164); // Fp2 mul start
    let t169 = circuit_mul(t167, t165);
    let t170 = circuit_sub(t168, t169); // Fp2 mul real part end
    let t171 = circuit_mul(t166, t165);
    let t172 = circuit_mul(t167, t164);
    let t173 = circuit_add(t171, t172); // Fp2 mul imag part end
    let t174 = circuit_sub(t170, t104); // Fp2 sub coeff 0/1
    let t175 = circuit_sub(t173, t107); // Fp2 sub coeff 1/1
    let t176 = circuit_sub(t174, t116); // Fp2 sub coeff 0/1
    let t177 = circuit_sub(t175, t119); // Fp2 sub coeff 1/1
    let t178 = circuit_add(t176, t110); // Fp2 add coeff 0/1
    let t179 = circuit_add(t177, t113); // Fp2 add coeff 1/1
    let t180 = circuit_add(t140, t62); // Fp6 add coeff 0/5
    let t181 = circuit_add(t141, t63); // Fp6 add coeff 1/5
    let t182 = circuit_add(t162, t84); // Fp6 add coeff 2/5
    let t183 = circuit_add(t163, t85); // Fp6 add coeff 3/5
    let t184 = circuit_add(t178, t100); // Fp6 add coeff 4/5
    let t185 = circuit_add(t179, t101); // Fp6 add coeff 5/5
    let t186 = circuit_add(t62, t62); // Fp6 add coeff 0/5
    let t187 = circuit_add(t63, t63); // Fp6 add coeff 1/5
    let t188 = circuit_add(t84, t84); // Fp6 add coeff 2/5
    let t189 = circuit_add(t85, t85); // Fp6 add coeff 3/5
    let t190 = circuit_add(t100, t100); // Fp6 add coeff 4/5
    let t191 = circuit_add(t101, t101); // Fp6 add coeff 5/5
    let t192 = circuit_add(t100, t101);
    let t193 = circuit_mul(t192, in0);
    let t194 = circuit_mul(t100, in1);
    let t195 = circuit_sub(t194, t101);
    let t196 = circuit_sub(t193, t194);
    let t197 = circuit_sub(t196, t101);
    let t198 = circuit_add(t180, t195); // Fp6 add coeff 0/5
    let t199 = circuit_add(t181, t197); // Fp6 add coeff 1/5
    let t200 = circuit_add(t182, t62); // Fp6 add coeff 2/5
    let t201 = circuit_add(t183, t63); // Fp6 add coeff 3/5
    let t202 = circuit_add(t184, t84); // Fp6 add coeff 4/5
    let t203 = circuit_add(t185, t85); // Fp6 add coeff 5/5
    let t204 = circuit_sub(in8, in12); // Fp2 sub coeff 0/1
    let t205 = circuit_sub(in9, in13); // Fp2 sub coeff 1/1
    let t206 = circuit_sub(in6, in10); // Fp2 sub coeff 0/1
    let t207 = circuit_sub(in7, in11); // Fp2 sub coeff 1/1
    let t208 = circuit_mul(t206, t206); // Fp2 Inv start
    let t209 = circuit_mul(t207, t207);
    let t210 = circuit_add(t208, t209);
    let t211 = circuit_inverse(t210);
    let t212 = circuit_mul(t206, t211); // Fp2 Inv real part end
    let t213 = circuit_mul(t207, t211);
    let t214 = circuit_sub(in2, t213); // Fp2 Inv imag part end
    let t215 = circuit_mul(t204, t212); // Fp2 mul start
    let t216 = circuit_mul(t205, t214);
    let t217 = circuit_sub(t215, t216); // Fp2 mul real part end
    let t218 = circuit_mul(t204, t214);
    let t219 = circuit_mul(t205, t212);
    let t220 = circuit_add(t218, t219); // Fp2 mul imag part end
    let t221 = circuit_add(t217, t220);
    let t222 = circuit_sub(t217, t220);
    let t223 = circuit_mul(t221, t222);
    let t224 = circuit_mul(t217, t220);
    let t225 = circuit_add(t224, t224);
    let t226 = circuit_add(in6, in10); // Fp2 add coeff 0/1
    let t227 = circuit_add(in7, in11); // Fp2 add coeff 1/1
    let t228 = circuit_sub(t223, t226); // Fp2 sub coeff 0/1
    let t229 = circuit_sub(t225, t227); // Fp2 sub coeff 1/1
    let t230 = circuit_mul(t217, in6); // Fp2 mul start
    let t231 = circuit_mul(t220, in7);
    let t232 = circuit_sub(t230, t231); // Fp2 mul real part end
    let t233 = circuit_mul(t217, in7);
    let t234 = circuit_mul(t220, in6);
    let t235 = circuit_add(t233, t234); // Fp2 mul imag part end
    let t236 = circuit_sub(t232, in8); // Fp2 sub coeff 0/1
    let t237 = circuit_sub(t235, in9); // Fp2 sub coeff 1/1
    let t238 = circuit_add(in8, in8); // Fp2 add coeff 0/1
    let t239 = circuit_add(in9, in9); // Fp2 add coeff 1/1
    let t240 = circuit_sub(t228, in6); // Fp2 sub coeff 0/1
    let t241 = circuit_sub(t229, in7); // Fp2 sub coeff 1/1
    let t242 = circuit_mul(t240, t240); // Fp2 Inv start
    let t243 = circuit_mul(t241, t241);
    let t244 = circuit_add(t242, t243);
    let t245 = circuit_inverse(t244);
    let t246 = circuit_mul(t240, t245); // Fp2 Inv real part end
    let t247 = circuit_mul(t241, t245);
    let t248 = circuit_sub(in2, t247); // Fp2 Inv imag part end
    let t249 = circuit_mul(t238, t246); // Fp2 mul start
    let t250 = circuit_mul(t239, t248);
    let t251 = circuit_sub(t249, t250); // Fp2 mul real part end
    let t252 = circuit_mul(t238, t248);
    let t253 = circuit_mul(t239, t246);
    let t254 = circuit_add(t252, t253); // Fp2 mul imag part end
    let t255 = circuit_add(t217, t251); // Fp2 add coeff 0/1
    let t256 = circuit_add(t220, t254); // Fp2 add coeff 1/1
    let t257 = circuit_sub(in2, t255); // Fp2 neg coeff 0/1
    let t258 = circuit_sub(in2, t256); // Fp2 neg coeff 1/1
    let t259 = circuit_add(t257, t258);
    let t260 = circuit_sub(t257, t258);
    let t261 = circuit_mul(t259, t260);
    let t262 = circuit_mul(t257, t258);
    let t263 = circuit_add(t262, t262);
    let t264 = circuit_sub(t261, in6); // Fp2 sub coeff 0/1
    let t265 = circuit_sub(t263, in7); // Fp2 sub coeff 1/1
    let t266 = circuit_sub(t264, t228); // Fp2 sub coeff 0/1
    let t267 = circuit_sub(t265, t229); // Fp2 sub coeff 1/1
    let t268 = circuit_sub(in6, t266); // Fp2 sub coeff 0/1
    let t269 = circuit_sub(in7, t267); // Fp2 sub coeff 1/1
    let t270 = circuit_mul(t257, t268); // Fp2 mul start
    let t271 = circuit_mul(t258, t269);
    let t272 = circuit_sub(t270, t271); // Fp2 mul real part end
    let t273 = circuit_mul(t257, t269);
    let t274 = circuit_mul(t258, t268);
    let t275 = circuit_add(t273, t274); // Fp2 mul imag part end
    let t276 = circuit_sub(t272, in8); // Fp2 sub coeff 0/1
    let t277 = circuit_sub(t275, in9); // Fp2 sub coeff 1/1
    let t278 = circuit_mul(t257, in6); // Fp2 mul start
    let t279 = circuit_mul(t258, in7);
    let t280 = circuit_sub(t278, t279); // Fp2 mul real part end
    let t281 = circuit_mul(t257, in7);
    let t282 = circuit_mul(t258, in6);
    let t283 = circuit_add(t281, t282); // Fp2 mul imag part end
    let t284 = circuit_sub(t280, in8); // Fp2 sub coeff 0/1
    let t285 = circuit_sub(t283, in9); // Fp2 sub coeff 1/1
    let t286 = circuit_mul(t217, in5);
    let t287 = circuit_mul(t220, in5);
    let t288 = circuit_mul(t236, in4);
    let t289 = circuit_mul(t237, in4);
    let t290 = circuit_mul(t257, in5);
    let t291 = circuit_mul(t258, in5);
    let t292 = circuit_mul(t284, in4);
    let t293 = circuit_mul(t285, in4);
    let t294 = circuit_mul(t186, t286); // Fp2 mul start
    let t295 = circuit_mul(t187, t287);
    let t296 = circuit_sub(t294, t295); // Fp2 mul real part end
    let t297 = circuit_mul(t186, t287);
    let t298 = circuit_mul(t187, t286);
    let t299 = circuit_add(t297, t298); // Fp2 mul imag part end
    let t300 = circuit_mul(t188, t288); // Fp2 mul start
    let t301 = circuit_mul(t189, t289);
    let t302 = circuit_sub(t300, t301); // Fp2 mul real part end
    let t303 = circuit_mul(t188, t289);
    let t304 = circuit_mul(t189, t288);
    let t305 = circuit_add(t303, t304); // Fp2 mul imag part end
    let t306 = circuit_add(t188, t190); // Fp2 add coeff 0/1
    let t307 = circuit_add(t189, t191); // Fp2 add coeff 1/1
    let t308 = circuit_mul(t288, t306); // Fp2 mul start
    let t309 = circuit_mul(t289, t307);
    let t310 = circuit_sub(t308, t309); // Fp2 mul real part end
    let t311 = circuit_mul(t288, t307);
    let t312 = circuit_mul(t289, t306);
    let t313 = circuit_add(t311, t312); // Fp2 mul imag part end
    let t314 = circuit_sub(t310, t302); // Fp2 sub coeff 0/1
    let t315 = circuit_sub(t313, t305); // Fp2 sub coeff 1/1
    let t316 = circuit_add(t314, t315);
    let t317 = circuit_mul(t316, in0);
    let t318 = circuit_mul(t314, in1);
    let t319 = circuit_sub(t318, t315);
    let t320 = circuit_sub(t317, t318);
    let t321 = circuit_sub(t320, t315);
    let t322 = circuit_add(t319, t296); // Fp2 add coeff 0/1
    let t323 = circuit_add(t321, t299); // Fp2 add coeff 1/1
    let t324 = circuit_add(t186, t190); // Fp2 add coeff 0/1
    let t325 = circuit_add(t187, t191); // Fp2 add coeff 1/1
    let t326 = circuit_mul(t286, t324); // Fp2 mul start
    let t327 = circuit_mul(t287, t325);
    let t328 = circuit_sub(t326, t327); // Fp2 mul real part end
    let t329 = circuit_mul(t286, t325);
    let t330 = circuit_mul(t287, t324);
    let t331 = circuit_add(t329, t330); // Fp2 mul imag part end
    let t332 = circuit_sub(t328, t296); // Fp2 sub coeff 0/1
    let t333 = circuit_sub(t331, t299); // Fp2 sub coeff 1/1
    let t334 = circuit_add(t332, t302); // Fp2 add coeff 0/1
    let t335 = circuit_add(t333, t305); // Fp2 add coeff 1/1
    let t336 = circuit_add(t286, t288); // Fp2 add coeff 0/1
    let t337 = circuit_add(t287, t289); // Fp2 add coeff 1/1
    let t338 = circuit_add(t186, t188); // Fp2 add coeff 0/1
    let t339 = circuit_add(t187, t189); // Fp2 add coeff 1/1
    let t340 = circuit_mul(t336, t338); // Fp2 mul start
    let t341 = circuit_mul(t337, t339);
    let t342 = circuit_sub(t340, t341); // Fp2 mul real part end
    let t343 = circuit_mul(t336, t339);
    let t344 = circuit_mul(t337, t338);
    let t345 = circuit_add(t343, t344); // Fp2 mul imag part end
    let t346 = circuit_sub(t342, t296); // Fp2 sub coeff 0/1
    let t347 = circuit_sub(t345, t299); // Fp2 sub coeff 1/1
    let t348 = circuit_sub(t346, t302); // Fp2 sub coeff 0/1
    let t349 = circuit_sub(t347, t305); // Fp2 sub coeff 1/1
    let t350 = circuit_add(in3, t286); // Fp2 add coeff 0/1
    let t351 = circuit_add(in2, t287); // Fp2 add coeff 1/1
    let t352 = circuit_add(t198, t186); // Fp6 add coeff 0/5
    let t353 = circuit_add(t199, t187); // Fp6 add coeff 1/5
    let t354 = circuit_add(t200, t188); // Fp6 add coeff 2/5
    let t355 = circuit_add(t201, t189); // Fp6 add coeff 3/5
    let t356 = circuit_add(t202, t190); // Fp6 add coeff 4/5
    let t357 = circuit_add(t203, t191); // Fp6 add coeff 5/5
    let t358 = circuit_mul(t352, t350); // Fp2 mul start
    let t359 = circuit_mul(t353, t351);
    let t360 = circuit_sub(t358, t359); // Fp2 mul real part end
    let t361 = circuit_mul(t352, t351);
    let t362 = circuit_mul(t353, t350);
    let t363 = circuit_add(t361, t362); // Fp2 mul imag part end
    let t364 = circuit_mul(t354, t288); // Fp2 mul start
    let t365 = circuit_mul(t355, t289);
    let t366 = circuit_sub(t364, t365); // Fp2 mul real part end
    let t367 = circuit_mul(t354, t289);
    let t368 = circuit_mul(t355, t288);
    let t369 = circuit_add(t367, t368); // Fp2 mul imag part end
    let t370 = circuit_add(t354, t356); // Fp2 add coeff 0/1
    let t371 = circuit_add(t355, t357); // Fp2 add coeff 1/1
    let t372 = circuit_mul(t288, t370); // Fp2 mul start
    let t373 = circuit_mul(t289, t371);
    let t374 = circuit_sub(t372, t373); // Fp2 mul real part end
    let t375 = circuit_mul(t288, t371);
    let t376 = circuit_mul(t289, t370);
    let t377 = circuit_add(t375, t376); // Fp2 mul imag part end
    let t378 = circuit_sub(t374, t366); // Fp2 sub coeff 0/1
    let t379 = circuit_sub(t377, t369); // Fp2 sub coeff 1/1
    let t380 = circuit_add(t378, t379);
    let t381 = circuit_mul(t380, in0);
    let t382 = circuit_mul(t378, in1);
    let t383 = circuit_sub(t382, t379);
    let t384 = circuit_sub(t381, t382);
    let t385 = circuit_sub(t384, t379);
    let t386 = circuit_add(t383, t360); // Fp2 add coeff 0/1
    let t387 = circuit_add(t385, t363); // Fp2 add coeff 1/1
    let t388 = circuit_add(t352, t356); // Fp2 add coeff 0/1
    let t389 = circuit_add(t353, t357); // Fp2 add coeff 1/1
    let t390 = circuit_mul(t350, t388); // Fp2 mul start
    let t391 = circuit_mul(t351, t389);
    let t392 = circuit_sub(t390, t391); // Fp2 mul real part end
    let t393 = circuit_mul(t350, t389);
    let t394 = circuit_mul(t351, t388);
    let t395 = circuit_add(t393, t394); // Fp2 mul imag part end
    let t396 = circuit_sub(t392, t360); // Fp2 sub coeff 0/1
    let t397 = circuit_sub(t395, t363); // Fp2 sub coeff 1/1
    let t398 = circuit_add(t396, t366); // Fp2 add coeff 0/1
    let t399 = circuit_add(t397, t369); // Fp2 add coeff 1/1
    let t400 = circuit_add(t350, t288); // Fp2 add coeff 0/1
    let t401 = circuit_add(t351, t289); // Fp2 add coeff 1/1
    let t402 = circuit_add(t352, t354); // Fp2 add coeff 0/1
    let t403 = circuit_add(t353, t355); // Fp2 add coeff 1/1
    let t404 = circuit_mul(t400, t402); // Fp2 mul start
    let t405 = circuit_mul(t401, t403);
    let t406 = circuit_sub(t404, t405); // Fp2 mul real part end
    let t407 = circuit_mul(t400, t403);
    let t408 = circuit_mul(t401, t402);
    let t409 = circuit_add(t407, t408); // Fp2 mul imag part end
    let t410 = circuit_sub(t406, t360); // Fp2 sub coeff 0/1
    let t411 = circuit_sub(t409, t363); // Fp2 sub coeff 1/1
    let t412 = circuit_sub(t410, t366); // Fp2 sub coeff 0/1
    let t413 = circuit_sub(t411, t369); // Fp2 sub coeff 1/1
    let t414 = circuit_add(t198, t322); // Fp6 add coeff 0/5
    let t415 = circuit_add(t199, t323); // Fp6 add coeff 1/5
    let t416 = circuit_add(t200, t348); // Fp6 add coeff 2/5
    let t417 = circuit_add(t201, t349); // Fp6 add coeff 3/5
    let t418 = circuit_add(t202, t334); // Fp6 add coeff 4/5
    let t419 = circuit_add(t203, t335); // Fp6 add coeff 5/5
    let t420 = circuit_sub(in2, t414); // Fp6 neg coeff 0/5
    let t421 = circuit_sub(in2, t415); // Fp6 neg coeff 1/5
    let t422 = circuit_sub(in2, t416); // Fp6 neg coeff 2/5
    let t423 = circuit_sub(in2, t417); // Fp6 neg coeff 3/5
    let t424 = circuit_sub(in2, t418); // Fp6 neg coeff 4/5
    let t425 = circuit_sub(in2, t419); // Fp6 neg coeff 5/5
    let t426 = circuit_add(t420, t386); // Fp6 add coeff 0/5
    let t427 = circuit_add(t421, t387); // Fp6 add coeff 1/5
    let t428 = circuit_add(t422, t412); // Fp6 add coeff 2/5
    let t429 = circuit_add(t423, t413); // Fp6 add coeff 3/5
    let t430 = circuit_add(t424, t398); // Fp6 add coeff 4/5
    let t431 = circuit_add(t425, t399); // Fp6 add coeff 5/5
    let t432 = circuit_add(t334, t335);
    let t433 = circuit_mul(t432, in0);
    let t434 = circuit_mul(t334, in1);
    let t435 = circuit_sub(t434, t335);
    let t436 = circuit_sub(t433, t434);
    let t437 = circuit_sub(t436, t335);
    let t438 = circuit_add(t435, t198); // Fp6 add coeff 0/5
    let t439 = circuit_add(t437, t199); // Fp6 add coeff 1/5
    let t440 = circuit_add(t322, t200); // Fp6 add coeff 2/5
    let t441 = circuit_add(t323, t201); // Fp6 add coeff 3/5
    let t442 = circuit_add(t348, t202); // Fp6 add coeff 4/5
    let t443 = circuit_add(t349, t203); // Fp6 add coeff 5/5
    let t444 = circuit_mul(t426, t290); // Fp2 mul start
    let t445 = circuit_mul(t427, t291);
    let t446 = circuit_sub(t444, t445); // Fp2 mul real part end
    let t447 = circuit_mul(t426, t291);
    let t448 = circuit_mul(t427, t290);
    let t449 = circuit_add(t447, t448); // Fp2 mul imag part end
    let t450 = circuit_mul(t428, t292); // Fp2 mul start
    let t451 = circuit_mul(t429, t293);
    let t452 = circuit_sub(t450, t451); // Fp2 mul real part end
    let t453 = circuit_mul(t428, t293);
    let t454 = circuit_mul(t429, t292);
    let t455 = circuit_add(t453, t454); // Fp2 mul imag part end
    let t456 = circuit_add(t428, t430); // Fp2 add coeff 0/1
    let t457 = circuit_add(t429, t431); // Fp2 add coeff 1/1
    let t458 = circuit_mul(t292, t456); // Fp2 mul start
    let t459 = circuit_mul(t293, t457);
    let t460 = circuit_sub(t458, t459); // Fp2 mul real part end
    let t461 = circuit_mul(t292, t457);
    let t462 = circuit_mul(t293, t456);
    let t463 = circuit_add(t461, t462); // Fp2 mul imag part end
    let t464 = circuit_sub(t460, t452); // Fp2 sub coeff 0/1
    let t465 = circuit_sub(t463, t455); // Fp2 sub coeff 1/1
    let t466 = circuit_add(t464, t465);
    let t467 = circuit_mul(t466, in0);
    let t468 = circuit_mul(t464, in1);
    let t469 = circuit_sub(t468, t465);
    let t470 = circuit_sub(t467, t468);
    let t471 = circuit_sub(t470, t465);
    let t472 = circuit_add(t469, t446); // Fp2 add coeff 0/1
    let t473 = circuit_add(t471, t449); // Fp2 add coeff 1/1
    let t474 = circuit_add(t426, t430); // Fp2 add coeff 0/1
    let t475 = circuit_add(t427, t431); // Fp2 add coeff 1/1
    let t476 = circuit_mul(t290, t474); // Fp2 mul start
    let t477 = circuit_mul(t291, t475);
    let t478 = circuit_sub(t476, t477); // Fp2 mul real part end
    let t479 = circuit_mul(t290, t475);
    let t480 = circuit_mul(t291, t474);
    let t481 = circuit_add(t479, t480); // Fp2 mul imag part end
    let t482 = circuit_sub(t478, t446); // Fp2 sub coeff 0/1
    let t483 = circuit_sub(t481, t449); // Fp2 sub coeff 1/1
    let t484 = circuit_add(t482, t452); // Fp2 add coeff 0/1
    let t485 = circuit_add(t483, t455); // Fp2 add coeff 1/1
    let t486 = circuit_add(t290, t292); // Fp2 add coeff 0/1
    let t487 = circuit_add(t291, t293); // Fp2 add coeff 1/1
    let t488 = circuit_add(t426, t428); // Fp2 add coeff 0/1
    let t489 = circuit_add(t427, t429); // Fp2 add coeff 1/1
    let t490 = circuit_mul(t486, t488); // Fp2 mul start
    let t491 = circuit_mul(t487, t489);
    let t492 = circuit_sub(t490, t491); // Fp2 mul real part end
    let t493 = circuit_mul(t486, t489);
    let t494 = circuit_mul(t487, t488);
    let t495 = circuit_add(t493, t494); // Fp2 mul imag part end
    let t496 = circuit_sub(t492, t446); // Fp2 sub coeff 0/1
    let t497 = circuit_sub(t495, t449); // Fp2 sub coeff 1/1
    let t498 = circuit_sub(t496, t452); // Fp2 sub coeff 0/1
    let t499 = circuit_sub(t497, t455); // Fp2 sub coeff 1/1
    let t500 = circuit_add(in3, t290); // Fp2 add coeff 0/1
    let t501 = circuit_add(in2, t291); // Fp2 add coeff 1/1
    let t502 = circuit_add(t438, t426); // Fp6 add coeff 0/5
    let t503 = circuit_add(t439, t427); // Fp6 add coeff 1/5
    let t504 = circuit_add(t440, t428); // Fp6 add coeff 2/5
    let t505 = circuit_add(t441, t429); // Fp6 add coeff 3/5
    let t506 = circuit_add(t442, t430); // Fp6 add coeff 4/5
    let t507 = circuit_add(t443, t431); // Fp6 add coeff 5/5
    let t508 = circuit_mul(t502, t500); // Fp2 mul start
    let t509 = circuit_mul(t503, t501);
    let t510 = circuit_sub(t508, t509); // Fp2 mul real part end
    let t511 = circuit_mul(t502, t501);
    let t512 = circuit_mul(t503, t500);
    let t513 = circuit_add(t511, t512); // Fp2 mul imag part end
    let t514 = circuit_mul(t504, t292); // Fp2 mul start
    let t515 = circuit_mul(t505, t293);
    let t516 = circuit_sub(t514, t515); // Fp2 mul real part end
    let t517 = circuit_mul(t504, t293);
    let t518 = circuit_mul(t505, t292);
    let t519 = circuit_add(t517, t518); // Fp2 mul imag part end
    let t520 = circuit_add(t504, t506); // Fp2 add coeff 0/1
    let t521 = circuit_add(t505, t507); // Fp2 add coeff 1/1
    let t522 = circuit_mul(t292, t520); // Fp2 mul start
    let t523 = circuit_mul(t293, t521);
    let t524 = circuit_sub(t522, t523); // Fp2 mul real part end
    let t525 = circuit_mul(t292, t521);
    let t526 = circuit_mul(t293, t520);
    let t527 = circuit_add(t525, t526); // Fp2 mul imag part end
    let t528 = circuit_sub(t524, t516); // Fp2 sub coeff 0/1
    let t529 = circuit_sub(t527, t519); // Fp2 sub coeff 1/1
    let t530 = circuit_add(t528, t529);
    let t531 = circuit_mul(t530, in0);
    let t532 = circuit_mul(t528, in1);
    let t533 = circuit_sub(t532, t529);
    let t534 = circuit_sub(t531, t532);
    let t535 = circuit_sub(t534, t529);
    let t536 = circuit_add(t533, t510); // Fp2 add coeff 0/1
    let t537 = circuit_add(t535, t513); // Fp2 add coeff 1/1
    let t538 = circuit_add(t502, t506); // Fp2 add coeff 0/1
    let t539 = circuit_add(t503, t507); // Fp2 add coeff 1/1
    let t540 = circuit_mul(t500, t538); // Fp2 mul start
    let t541 = circuit_mul(t501, t539);
    let t542 = circuit_sub(t540, t541); // Fp2 mul real part end
    let t543 = circuit_mul(t500, t539);
    let t544 = circuit_mul(t501, t538);
    let t545 = circuit_add(t543, t544); // Fp2 mul imag part end
    let t546 = circuit_sub(t542, t510); // Fp2 sub coeff 0/1
    let t547 = circuit_sub(t545, t513); // Fp2 sub coeff 1/1
    let t548 = circuit_add(t546, t516); // Fp2 add coeff 0/1
    let t549 = circuit_add(t547, t519); // Fp2 add coeff 1/1
    let t550 = circuit_add(t500, t292); // Fp2 add coeff 0/1
    let t551 = circuit_add(t501, t293); // Fp2 add coeff 1/1
    let t552 = circuit_add(t502, t504); // Fp2 add coeff 0/1
    let t553 = circuit_add(t503, t505); // Fp2 add coeff 1/1
    let t554 = circuit_mul(t550, t552); // Fp2 mul start
    let t555 = circuit_mul(t551, t553);
    let t556 = circuit_sub(t554, t555); // Fp2 mul real part end
    let t557 = circuit_mul(t550, t553);
    let t558 = circuit_mul(t551, t552);
    let t559 = circuit_add(t557, t558); // Fp2 mul imag part end
    let t560 = circuit_sub(t556, t510); // Fp2 sub coeff 0/1
    let t561 = circuit_sub(t559, t513); // Fp2 sub coeff 1/1
    let t562 = circuit_sub(t560, t516); // Fp2 sub coeff 0/1
    let t563 = circuit_sub(t561, t519); // Fp2 sub coeff 1/1
    let t564 = circuit_add(t438, t472); // Fp6 add coeff 0/5
    let t565 = circuit_add(t439, t473); // Fp6 add coeff 1/5
    let t566 = circuit_add(t440, t498); // Fp6 add coeff 2/5
    let t567 = circuit_add(t441, t499); // Fp6 add coeff 3/5
    let t568 = circuit_add(t442, t484); // Fp6 add coeff 4/5
    let t569 = circuit_add(t443, t485); // Fp6 add coeff 5/5
    let t570 = circuit_sub(in2, t564); // Fp6 neg coeff 0/5
    let t571 = circuit_sub(in2, t565); // Fp6 neg coeff 1/5
    let t572 = circuit_sub(in2, t566); // Fp6 neg coeff 2/5
    let t573 = circuit_sub(in2, t567); // Fp6 neg coeff 3/5
    let t574 = circuit_sub(in2, t568); // Fp6 neg coeff 4/5
    let t575 = circuit_sub(in2, t569); // Fp6 neg coeff 5/5
    let t576 = circuit_add(t570, t536); // Fp6 add coeff 0/5
    let t577 = circuit_add(t571, t537); // Fp6 add coeff 1/5
    let t578 = circuit_add(t572, t562); // Fp6 add coeff 2/5
    let t579 = circuit_add(t573, t563); // Fp6 add coeff 3/5
    let t580 = circuit_add(t574, t548); // Fp6 add coeff 4/5
    let t581 = circuit_add(t575, t549); // Fp6 add coeff 5/5
    let t582 = circuit_add(t484, t485);
    let t583 = circuit_mul(t582, in0);
    let t584 = circuit_mul(t484, in1);
    let t585 = circuit_sub(t584, t485);
    let t586 = circuit_sub(t583, t584);
    let t587 = circuit_sub(t586, t485);
    let t588 = circuit_add(t585, t438); // Fp6 add coeff 0/5
    let t589 = circuit_add(t587, t439); // Fp6 add coeff 1/5
    let t590 = circuit_add(t472, t440); // Fp6 add coeff 2/5
    let t591 = circuit_add(t473, t441); // Fp6 add coeff 3/5
    let t592 = circuit_add(t498, t442); // Fp6 add coeff 4/5
    let t593 = circuit_add(t499, t443); // Fp6 add coeff 5/5
    let t594 = circuit_add(t266, t267);
    let t595 = circuit_add(t594, t276);
    let t596 = circuit_add(t595, t277);

    let modulus = get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (
        t596, t588, t589, t590, t591, t592, t593, t576, t577, t578, t579, t580, t581,
    )
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0xa, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs.next_2([0x9, 0x0, 0x0, 0x0]); // in1
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in2
    circuit_inputs = circuit_inputs.next_2([0x1, 0x0, 0x0, 0x0]); // in3
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(yInv_0); // in4
    circuit_inputs = circuit_inputs.next_2(xNegOverY_0); // in5
    circuit_inputs = circuit_inputs.next_2(Q_0.x0); // in6
    circuit_inputs = circuit_inputs.next_2(Q_0.x1); // in7
    circuit_inputs = circuit_inputs.next_2(Q_0.y0); // in8
    circuit_inputs = circuit_inputs.next_2(Q_0.y1); // in9
    circuit_inputs = circuit_inputs.next_2(Q_or_Q_neg_0.x0); // in10
    circuit_inputs = circuit_inputs.next_2(Q_or_Q_neg_0.x1); // in11
    circuit_inputs = circuit_inputs.next_2(Q_or_Q_neg_0.y0); // in12
    circuit_inputs = circuit_inputs.next_2(Q_or_Q_neg_0.y1); // in13
    circuit_inputs = circuit_inputs.next_2(M_i.c0b0a0); // in14
    circuit_inputs = circuit_inputs.next_2(M_i.c0b0a1); // in15
    circuit_inputs = circuit_inputs.next_2(M_i.c0b1a0); // in16
    circuit_inputs = circuit_inputs.next_2(M_i.c0b1a1); // in17
    circuit_inputs = circuit_inputs.next_2(M_i.c0b2a0); // in18
    circuit_inputs = circuit_inputs.next_2(M_i.c0b2a1); // in19
    circuit_inputs = circuit_inputs.next_2(M_i.c1b0a0); // in20
    circuit_inputs = circuit_inputs.next_2(M_i.c1b0a1); // in21
    circuit_inputs = circuit_inputs.next_2(M_i.c1b1a0); // in22
    circuit_inputs = circuit_inputs.next_2(M_i.c1b1a1); // in23
    circuit_inputs = circuit_inputs.next_2(M_i.c1b2a0); // in24
    circuit_inputs = circuit_inputs.next_2(M_i.c1b2a1); // in25

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let Q0: G2Point = G2Point {
        x0: outputs.get_output(t266),
        x1: outputs.get_output(t267),
        y0: outputs.get_output(t276),
        y1: outputs.get_output(t277),
    };
    let Mi_plus_one: E12T = E12T {
        c0b0a0: outputs.get_output(t588),
        c0b0a1: outputs.get_output(t589),
        c0b1a0: outputs.get_output(t590),
        c0b1a1: outputs.get_output(t591),
        c0b2a0: outputs.get_output(t592),
        c0b2a1: outputs.get_output(t593),
        c1b0a0: outputs.get_output(t576),
        c1b0a1: outputs.get_output(t577),
        c1b1a0: outputs.get_output(t578),
        c1b1a1: outputs.get_output(t579),
        c1b2a0: outputs.get_output(t580),
        c1b2a1: outputs.get_output(t581),
    };
    return (Q0, Mi_plus_one);
}
#[inline(always)]
pub fn run_BN254_TOWER_MILLER_FINALIZE_BN_1P_circuit(
    original_Q0: G2Point, yInv_0: u384, xNegOverY_0: u384, Q_0: G2Point, Mi: E12T,
) -> (E12T,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x2fb347984f7911f74c0bec3cf559b143b78cc310c2c3330c99e39557176f553d
    let in1 = CE::<CI<1>> {}; // 0x16c9e55061ebae204ba4cc8bd75a079432ae2a1d0b7c9dce1665d51c640fcba2
    let in2 = CE::<CI<2>> {}; // 0x63cf305489af5dcdc5ec698b6e2f9b9dbaae0eda9c95998dc54014671a0135a
    let in3 = CE::<CI<3>> {}; // 0x7c03cbcac41049a0704b5a7ec796f2b21807dc98fa25bd282d37f632623b0e3
    let in4 = CE::<CI<4>> {}; // 0x30644e72e131a0295e6dd9e7e0acccb0c28f069fbb966e3de4bd44e5607cfd48
    let in5 = CE::<CI<5>> {}; // 0x1
    let in6 = CE::<CI<6>> {}; // 0x0
    let in7 = CE::<CI<7>> {}; // 0xa
    let in8 = CE::<CI<8>> {}; // 0x9

    // INPUT stack
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13, in14) = (CE::<CI<12>> {}, CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16, in17) = (CE::<CI<15>> {}, CE::<CI<16>> {}, CE::<CI<17>> {});
    let (in18, in19, in20) = (CE::<CI<18>> {}, CE::<CI<19>> {}, CE::<CI<20>> {});
    let (in21, in22, in23) = (CE::<CI<21>> {}, CE::<CI<22>> {}, CE::<CI<23>> {});
    let (in24, in25, in26) = (CE::<CI<24>> {}, CE::<CI<25>> {}, CE::<CI<26>> {});
    let (in27, in28, in29) = (CE::<CI<27>> {}, CE::<CI<28>> {}, CE::<CI<29>> {});
    let in30 = CE::<CI<30>> {};
    let t0 = circuit_sub(in6, in10);
    let t1 = circuit_sub(in6, in12);
    let t2 = circuit_mul(in9, in0); // Fp2 mul start
    let t3 = circuit_mul(t0, in1);
    let t4 = circuit_sub(t2, t3); // Fp2 mul real part end
    let t5 = circuit_mul(in9, in1);
    let t6 = circuit_mul(t0, in0);
    let t7 = circuit_add(t5, t6); // Fp2 mul imag part end
    let t8 = circuit_mul(in11, in2); // Fp2 mul start
    let t9 = circuit_mul(t1, in3);
    let t10 = circuit_sub(t8, t9); // Fp2 mul real part end
    let t11 = circuit_mul(in11, in3);
    let t12 = circuit_mul(t1, in2);
    let t13 = circuit_add(t11, t12); // Fp2 mul imag part end
    let t14 = circuit_mul(in9, in4); // Fp2 scalar mul coeff 0/1
    let t15 = circuit_mul(in10, in4); // Fp2 scalar mul coeff 1/1
    let t16 = circuit_mul(in11, in5); // Fp2 scalar mul coeff 0/1
    let t17 = circuit_mul(in12, in5); // Fp2 scalar mul coeff 1/1
    let t18 = circuit_sub(in17, t10); // Fp2 sub coeff 0/1
    let t19 = circuit_sub(in18, t13); // Fp2 sub coeff 1/1
    let t20 = circuit_sub(in15, t4); // Fp2 sub coeff 0/1
    let t21 = circuit_sub(in16, t7); // Fp2 sub coeff 1/1
    let t22 = circuit_mul(t20, t20); // Fp2 Inv start
    let t23 = circuit_mul(t21, t21);
    let t24 = circuit_add(t22, t23);
    let t25 = circuit_inverse(t24);
    let t26 = circuit_mul(t20, t25); // Fp2 Inv real part end
    let t27 = circuit_mul(t21, t25);
    let t28 = circuit_sub(in6, t27); // Fp2 Inv imag part end
    let t29 = circuit_mul(t18, t26); // Fp2 mul start
    let t30 = circuit_mul(t19, t28);
    let t31 = circuit_sub(t29, t30); // Fp2 mul real part end
    let t32 = circuit_mul(t18, t28);
    let t33 = circuit_mul(t19, t26);
    let t34 = circuit_add(t32, t33); // Fp2 mul imag part end
    let t35 = circuit_add(t31, t34);
    let t36 = circuit_sub(t31, t34);
    let t37 = circuit_mul(t35, t36);
    let t38 = circuit_mul(t31, t34);
    let t39 = circuit_add(t38, t38);
    let t40 = circuit_add(in15, t4); // Fp2 add coeff 0/1
    let t41 = circuit_add(in16, t7); // Fp2 add coeff 1/1
    let t42 = circuit_sub(t37, t40); // Fp2 sub coeff 0/1
    let t43 = circuit_sub(t39, t41); // Fp2 sub coeff 1/1
    let t44 = circuit_sub(in15, t42); // Fp2 sub coeff 0/1
    let t45 = circuit_sub(in16, t43); // Fp2 sub coeff 1/1
    let t46 = circuit_mul(t31, t44); // Fp2 mul start
    let t47 = circuit_mul(t34, t45);
    let t48 = circuit_sub(t46, t47); // Fp2 mul real part end
    let t49 = circuit_mul(t31, t45);
    let t50 = circuit_mul(t34, t44);
    let t51 = circuit_add(t49, t50); // Fp2 mul imag part end
    let t52 = circuit_sub(t48, in17); // Fp2 sub coeff 0/1
    let t53 = circuit_sub(t51, in18); // Fp2 sub coeff 1/1
    let t54 = circuit_mul(t31, in15); // Fp2 mul start
    let t55 = circuit_mul(t34, in16);
    let t56 = circuit_sub(t54, t55); // Fp2 mul real part end
    let t57 = circuit_mul(t31, in16);
    let t58 = circuit_mul(t34, in15);
    let t59 = circuit_add(t57, t58); // Fp2 mul imag part end
    let t60 = circuit_sub(t56, in17); // Fp2 sub coeff 0/1
    let t61 = circuit_sub(t59, in18); // Fp2 sub coeff 1/1
    let t62 = circuit_sub(t52, t16); // Fp2 sub coeff 0/1
    let t63 = circuit_sub(t53, t17); // Fp2 sub coeff 1/1
    let t64 = circuit_sub(t42, t14); // Fp2 sub coeff 0/1
    let t65 = circuit_sub(t43, t15); // Fp2 sub coeff 1/1
    let t66 = circuit_mul(t64, t64); // Fp2 Inv start
    let t67 = circuit_mul(t65, t65);
    let t68 = circuit_add(t66, t67);
    let t69 = circuit_inverse(t68);
    let t70 = circuit_mul(t64, t69); // Fp2 Inv real part end
    let t71 = circuit_mul(t65, t69);
    let t72 = circuit_sub(in6, t71); // Fp2 Inv imag part end
    let t73 = circuit_mul(t62, t70); // Fp2 mul start
    let t74 = circuit_mul(t63, t72);
    let t75 = circuit_sub(t73, t74); // Fp2 mul real part end
    let t76 = circuit_mul(t62, t72);
    let t77 = circuit_mul(t63, t70);
    let t78 = circuit_add(t76, t77); // Fp2 mul imag part end
    let t79 = circuit_mul(t75, t42); // Fp2 mul start
    let t80 = circuit_mul(t78, t43);
    let t81 = circuit_sub(t79, t80); // Fp2 mul real part end
    let t82 = circuit_mul(t75, t43);
    let t83 = circuit_mul(t78, t42);
    let t84 = circuit_add(t82, t83); // Fp2 mul imag part end
    let t85 = circuit_sub(t81, t52); // Fp2 sub coeff 0/1
    let t86 = circuit_sub(t84, t53); // Fp2 sub coeff 1/1
    let t87 = circuit_mul(t31, in14);
    let t88 = circuit_mul(t34, in14);
    let t89 = circuit_mul(t60, in13);
    let t90 = circuit_mul(t61, in13);
    let t91 = circuit_mul(t75, in14);
    let t92 = circuit_mul(t78, in14);
    let t93 = circuit_mul(t85, in13);
    let t94 = circuit_mul(t86, in13);
    let t95 = circuit_mul(t91, t87); // Fp2 mul start
    let t96 = circuit_mul(t92, t88);
    let t97 = circuit_sub(t95, t96); // Fp2 mul real part end
    let t98 = circuit_mul(t91, t88);
    let t99 = circuit_mul(t92, t87);
    let t100 = circuit_add(t98, t99); // Fp2 mul imag part end
    let t101 = circuit_mul(t93, t89); // Fp2 mul start
    let t102 = circuit_mul(t94, t90);
    let t103 = circuit_sub(t101, t102); // Fp2 mul real part end
    let t104 = circuit_mul(t93, t90);
    let t105 = circuit_mul(t94, t89);
    let t106 = circuit_add(t104, t105); // Fp2 mul imag part end
    let t107 = circuit_add(t93, t89); // Fp2 add coeff 0/1
    let t108 = circuit_add(t94, t90); // Fp2 add coeff 1/1
    let t109 = circuit_add(t91, t87); // Fp2 add coeff 0/1
    let t110 = circuit_add(t92, t88); // Fp2 add coeff 1/1
    let t111 = circuit_add(t91, t93); // Fp2 add coeff 0/1
    let t112 = circuit_add(t92, t94); // Fp2 add coeff 1/1
    let t113 = circuit_add(t87, t89); // Fp2 add coeff 0/1
    let t114 = circuit_add(t88, t90); // Fp2 add coeff 1/1
    let t115 = circuit_mul(t113, t111); // Fp2 mul start
    let t116 = circuit_mul(t114, t112);
    let t117 = circuit_sub(t115, t116); // Fp2 mul real part end
    let t118 = circuit_mul(t113, t112);
    let t119 = circuit_mul(t114, t111);
    let t120 = circuit_add(t118, t119); // Fp2 mul imag part end
    let t121 = circuit_sub(t117, t97); // Fp2 sub coeff 0/1
    let t122 = circuit_sub(t120, t100); // Fp2 sub coeff 1/1
    let t123 = circuit_sub(t121, t103); // Fp2 sub coeff 0/1
    let t124 = circuit_sub(t122, t106); // Fp2 sub coeff 1/1
    let t125 = circuit_add(t103, t106);
    let t126 = circuit_mul(t125, in7);
    let t127 = circuit_mul(t103, in8);
    let t128 = circuit_sub(t127, t106);
    let t129 = circuit_sub(t126, t127);
    let t130 = circuit_sub(t129, t106);
    let t131 = circuit_add(t128, in5);
    let t132 = circuit_add(in19, in25); // Fp6 add coeff 0/5
    let t133 = circuit_add(in20, in26); // Fp6 add coeff 1/5
    let t134 = circuit_add(in21, in27); // Fp6 add coeff 2/5
    let t135 = circuit_add(in22, in28); // Fp6 add coeff 3/5
    let t136 = circuit_add(in23, in29); // Fp6 add coeff 4/5
    let t137 = circuit_add(in24, in30); // Fp6 add coeff 5/5
    let t138 = circuit_add(t131, t109); // Fp6 add coeff 0/5
    let t139 = circuit_add(t130, t110); // Fp6 add coeff 1/5
    let t140 = circuit_add(t97, t107); // Fp6 add coeff 2/5
    let t141 = circuit_add(t100, t108); // Fp6 add coeff 3/5
    let t142 = circuit_add(t123, in6); // Fp6 add coeff 4/5
    let t143 = circuit_add(t124, in6); // Fp6 add coeff 5/5
    let t144 = circuit_mul(t132, t138); // Fp2 mul start
    let t145 = circuit_mul(t133, t139);
    let t146 = circuit_sub(t144, t145); // Fp2 mul real part end
    let t147 = circuit_mul(t132, t139);
    let t148 = circuit_mul(t133, t138);
    let t149 = circuit_add(t147, t148); // Fp2 mul imag part end
    let t150 = circuit_mul(t134, t140); // Fp2 mul start
    let t151 = circuit_mul(t135, t141);
    let t152 = circuit_sub(t150, t151); // Fp2 mul real part end
    let t153 = circuit_mul(t134, t141);
    let t154 = circuit_mul(t135, t140);
    let t155 = circuit_add(t153, t154); // Fp2 mul imag part end
    let t156 = circuit_mul(t136, t142); // Fp2 mul start
    let t157 = circuit_mul(t137, t143);
    let t158 = circuit_sub(t156, t157); // Fp2 mul real part end
    let t159 = circuit_mul(t136, t143);
    let t160 = circuit_mul(t137, t142);
    let t161 = circuit_add(t159, t160); // Fp2 mul imag part end
    let t162 = circuit_add(t134, t136); // Fp2 add coeff 0/1
    let t163 = circuit_add(t135, t137); // Fp2 add coeff 1/1
    let t164 = circuit_add(t140, t142); // Fp2 add coeff 0/1
    let t165 = circuit_add(t141, t143); // Fp2 add coeff 1/1
    let t166 = circuit_mul(t162, t164); // Fp2 mul start
    let t167 = circuit_mul(t163, t165);
    let t168 = circuit_sub(t166, t167); // Fp2 mul real part end
    let t169 = circuit_mul(t162, t165);
    let t170 = circuit_mul(t163, t164);
    let t171 = circuit_add(t169, t170); // Fp2 mul imag part end
    let t172 = circuit_sub(t168, t152); // Fp2 sub coeff 0/1
    let t173 = circuit_sub(t171, t155); // Fp2 sub coeff 1/1
    let t174 = circuit_sub(t172, t158); // Fp2 sub coeff 0/1
    let t175 = circuit_sub(t173, t161); // Fp2 sub coeff 1/1
    let t176 = circuit_add(t174, t175);
    let t177 = circuit_mul(t176, in7);
    let t178 = circuit_mul(t174, in8);
    let t179 = circuit_sub(t178, t175);
    let t180 = circuit_sub(t177, t178);
    let t181 = circuit_sub(t180, t175);
    let t182 = circuit_add(t179, t146); // Fp2 add coeff 0/1
    let t183 = circuit_add(t181, t149); // Fp2 add coeff 1/1
    let t184 = circuit_add(t132, t134); // Fp2 add coeff 0/1
    let t185 = circuit_add(t133, t135); // Fp2 add coeff 1/1
    let t186 = circuit_add(t138, t140); // Fp2 add coeff 0/1
    let t187 = circuit_add(t139, t141); // Fp2 add coeff 1/1
    let t188 = circuit_mul(t184, t186); // Fp2 mul start
    let t189 = circuit_mul(t185, t187);
    let t190 = circuit_sub(t188, t189); // Fp2 mul real part end
    let t191 = circuit_mul(t184, t187);
    let t192 = circuit_mul(t185, t186);
    let t193 = circuit_add(t191, t192); // Fp2 mul imag part end
    let t194 = circuit_sub(t190, t146); // Fp2 sub coeff 0/1
    let t195 = circuit_sub(t193, t149); // Fp2 sub coeff 1/1
    let t196 = circuit_sub(t194, t152); // Fp2 sub coeff 0/1
    let t197 = circuit_sub(t195, t155); // Fp2 sub coeff 1/1
    let t198 = circuit_add(t158, t161);
    let t199 = circuit_mul(t198, in7);
    let t200 = circuit_mul(t158, in8);
    let t201 = circuit_sub(t200, t161);
    let t202 = circuit_sub(t199, t200);
    let t203 = circuit_sub(t202, t161);
    let t204 = circuit_add(t196, t201); // Fp2 add coeff 0/1
    let t205 = circuit_add(t197, t203); // Fp2 add coeff 1/1
    let t206 = circuit_add(t132, t136); // Fp2 add coeff 0/1
    let t207 = circuit_add(t133, t137); // Fp2 add coeff 1/1
    let t208 = circuit_add(t138, t142); // Fp2 add coeff 0/1
    let t209 = circuit_add(t139, t143); // Fp2 add coeff 1/1
    let t210 = circuit_mul(t208, t206); // Fp2 mul start
    let t211 = circuit_mul(t209, t207);
    let t212 = circuit_sub(t210, t211); // Fp2 mul real part end
    let t213 = circuit_mul(t208, t207);
    let t214 = circuit_mul(t209, t206);
    let t215 = circuit_add(t213, t214); // Fp2 mul imag part end
    let t216 = circuit_sub(t212, t146); // Fp2 sub coeff 0/1
    let t217 = circuit_sub(t215, t149); // Fp2 sub coeff 1/1
    let t218 = circuit_sub(t216, t158); // Fp2 sub coeff 0/1
    let t219 = circuit_sub(t217, t161); // Fp2 sub coeff 1/1
    let t220 = circuit_add(t218, t152); // Fp2 add coeff 0/1
    let t221 = circuit_add(t219, t155); // Fp2 add coeff 1/1
    let t222 = circuit_mul(in19, t131); // Fp2 mul start
    let t223 = circuit_mul(in20, t130);
    let t224 = circuit_sub(t222, t223); // Fp2 mul real part end
    let t225 = circuit_mul(in19, t130);
    let t226 = circuit_mul(in20, t131);
    let t227 = circuit_add(t225, t226); // Fp2 mul imag part end
    let t228 = circuit_mul(in21, t97); // Fp2 mul start
    let t229 = circuit_mul(in22, t100);
    let t230 = circuit_sub(t228, t229); // Fp2 mul real part end
    let t231 = circuit_mul(in21, t100);
    let t232 = circuit_mul(in22, t97);
    let t233 = circuit_add(t231, t232); // Fp2 mul imag part end
    let t234 = circuit_mul(in23, t123); // Fp2 mul start
    let t235 = circuit_mul(in24, t124);
    let t236 = circuit_sub(t234, t235); // Fp2 mul real part end
    let t237 = circuit_mul(in23, t124);
    let t238 = circuit_mul(in24, t123);
    let t239 = circuit_add(t237, t238); // Fp2 mul imag part end
    let t240 = circuit_add(in21, in23); // Fp2 add coeff 0/1
    let t241 = circuit_add(in22, in24); // Fp2 add coeff 1/1
    let t242 = circuit_add(t97, t123); // Fp2 add coeff 0/1
    let t243 = circuit_add(t100, t124); // Fp2 add coeff 1/1
    let t244 = circuit_mul(t240, t242); // Fp2 mul start
    let t245 = circuit_mul(t241, t243);
    let t246 = circuit_sub(t244, t245); // Fp2 mul real part end
    let t247 = circuit_mul(t240, t243);
    let t248 = circuit_mul(t241, t242);
    let t249 = circuit_add(t247, t248); // Fp2 mul imag part end
    let t250 = circuit_sub(t246, t230); // Fp2 sub coeff 0/1
    let t251 = circuit_sub(t249, t233); // Fp2 sub coeff 1/1
    let t252 = circuit_sub(t250, t236); // Fp2 sub coeff 0/1
    let t253 = circuit_sub(t251, t239); // Fp2 sub coeff 1/1
    let t254 = circuit_add(t252, t253);
    let t255 = circuit_mul(t254, in7);
    let t256 = circuit_mul(t252, in8);
    let t257 = circuit_sub(t256, t253);
    let t258 = circuit_sub(t255, t256);
    let t259 = circuit_sub(t258, t253);
    let t260 = circuit_add(t257, t224); // Fp2 add coeff 0/1
    let t261 = circuit_add(t259, t227); // Fp2 add coeff 1/1
    let t262 = circuit_add(in19, in21); // Fp2 add coeff 0/1
    let t263 = circuit_add(in20, in22); // Fp2 add coeff 1/1
    let t264 = circuit_add(t131, t97); // Fp2 add coeff 0/1
    let t265 = circuit_add(t130, t100); // Fp2 add coeff 1/1
    let t266 = circuit_mul(t262, t264); // Fp2 mul start
    let t267 = circuit_mul(t263, t265);
    let t268 = circuit_sub(t266, t267); // Fp2 mul real part end
    let t269 = circuit_mul(t262, t265);
    let t270 = circuit_mul(t263, t264);
    let t271 = circuit_add(t269, t270); // Fp2 mul imag part end
    let t272 = circuit_sub(t268, t224); // Fp2 sub coeff 0/1
    let t273 = circuit_sub(t271, t227); // Fp2 sub coeff 1/1
    let t274 = circuit_sub(t272, t230); // Fp2 sub coeff 0/1
    let t275 = circuit_sub(t273, t233); // Fp2 sub coeff 1/1
    let t276 = circuit_add(t236, t239);
    let t277 = circuit_mul(t276, in7);
    let t278 = circuit_mul(t236, in8);
    let t279 = circuit_sub(t278, t239);
    let t280 = circuit_sub(t277, t278);
    let t281 = circuit_sub(t280, t239);
    let t282 = circuit_add(t274, t279); // Fp2 add coeff 0/1
    let t283 = circuit_add(t275, t281); // Fp2 add coeff 1/1
    let t284 = circuit_add(in19, in23); // Fp2 add coeff 0/1
    let t285 = circuit_add(in20, in24); // Fp2 add coeff 1/1
    let t286 = circuit_add(t131, t123); // Fp2 add coeff 0/1
    let t287 = circuit_add(t130, t124); // Fp2 add coeff 1/1
    let t288 = circuit_mul(t286, t284); // Fp2 mul start
    let t289 = circuit_mul(t287, t285);
    let t290 = circuit_sub(t288, t289); // Fp2 mul real part end
    let t291 = circuit_mul(t286, t285);
    let t292 = circuit_mul(t287, t284);
    let t293 = circuit_add(t291, t292); // Fp2 mul imag part end
    let t294 = circuit_sub(t290, t224); // Fp2 sub coeff 0/1
    let t295 = circuit_sub(t293, t227); // Fp2 sub coeff 1/1
    let t296 = circuit_sub(t294, t236); // Fp2 sub coeff 0/1
    let t297 = circuit_sub(t295, t239); // Fp2 sub coeff 1/1
    let t298 = circuit_add(t296, t230); // Fp2 add coeff 0/1
    let t299 = circuit_add(t297, t233); // Fp2 add coeff 1/1
    let t300 = circuit_mul(in25, t109); // Fp2 mul start
    let t301 = circuit_mul(in26, t110);
    let t302 = circuit_sub(t300, t301); // Fp2 mul real part end
    let t303 = circuit_mul(in25, t110);
    let t304 = circuit_mul(in26, t109);
    let t305 = circuit_add(t303, t304); // Fp2 mul imag part end
    let t306 = circuit_mul(in27, t107); // Fp2 mul start
    let t307 = circuit_mul(in28, t108);
    let t308 = circuit_sub(t306, t307); // Fp2 mul real part end
    let t309 = circuit_mul(in27, t108);
    let t310 = circuit_mul(in28, t107);
    let t311 = circuit_add(t309, t310); // Fp2 mul imag part end
    let t312 = circuit_mul(in29, in6); // Fp2 mul start
    let t313 = circuit_mul(in30, in6);
    let t314 = circuit_sub(t312, t313); // Fp2 mul real part end
    let t315 = circuit_mul(in29, in6);
    let t316 = circuit_mul(in30, in6);
    let t317 = circuit_add(t315, t316); // Fp2 mul imag part end
    let t318 = circuit_add(in27, in29); // Fp2 add coeff 0/1
    let t319 = circuit_add(in28, in30); // Fp2 add coeff 1/1
    let t320 = circuit_add(t107, in6); // Fp2 add coeff 0/1
    let t321 = circuit_add(t108, in6); // Fp2 add coeff 1/1
    let t322 = circuit_mul(t318, t320); // Fp2 mul start
    let t323 = circuit_mul(t319, t321);
    let t324 = circuit_sub(t322, t323); // Fp2 mul real part end
    let t325 = circuit_mul(t318, t321);
    let t326 = circuit_mul(t319, t320);
    let t327 = circuit_add(t325, t326); // Fp2 mul imag part end
    let t328 = circuit_sub(t324, t308); // Fp2 sub coeff 0/1
    let t329 = circuit_sub(t327, t311); // Fp2 sub coeff 1/1
    let t330 = circuit_sub(t328, t314); // Fp2 sub coeff 0/1
    let t331 = circuit_sub(t329, t317); // Fp2 sub coeff 1/1
    let t332 = circuit_add(t330, t331);
    let t333 = circuit_mul(t332, in7);
    let t334 = circuit_mul(t330, in8);
    let t335 = circuit_sub(t334, t331);
    let t336 = circuit_sub(t333, t334);
    let t337 = circuit_sub(t336, t331);
    let t338 = circuit_add(t335, t302); // Fp2 add coeff 0/1
    let t339 = circuit_add(t337, t305); // Fp2 add coeff 1/1
    let t340 = circuit_add(in25, in27); // Fp2 add coeff 0/1
    let t341 = circuit_add(in26, in28); // Fp2 add coeff 1/1
    let t342 = circuit_add(t109, t107); // Fp2 add coeff 0/1
    let t343 = circuit_add(t110, t108); // Fp2 add coeff 1/1
    let t344 = circuit_mul(t340, t342); // Fp2 mul start
    let t345 = circuit_mul(t341, t343);
    let t346 = circuit_sub(t344, t345); // Fp2 mul real part end
    let t347 = circuit_mul(t340, t343);
    let t348 = circuit_mul(t341, t342);
    let t349 = circuit_add(t347, t348); // Fp2 mul imag part end
    let t350 = circuit_sub(t346, t302); // Fp2 sub coeff 0/1
    let t351 = circuit_sub(t349, t305); // Fp2 sub coeff 1/1
    let t352 = circuit_sub(t350, t308); // Fp2 sub coeff 0/1
    let t353 = circuit_sub(t351, t311); // Fp2 sub coeff 1/1
    let t354 = circuit_add(t314, t317);
    let t355 = circuit_mul(t354, in7);
    let t356 = circuit_mul(t314, in8);
    let t357 = circuit_sub(t356, t317);
    let t358 = circuit_sub(t355, t356);
    let t359 = circuit_sub(t358, t317);
    let t360 = circuit_add(t352, t357); // Fp2 add coeff 0/1
    let t361 = circuit_add(t353, t359); // Fp2 add coeff 1/1
    let t362 = circuit_add(in25, in29); // Fp2 add coeff 0/1
    let t363 = circuit_add(in26, in30); // Fp2 add coeff 1/1
    let t364 = circuit_add(t109, in6); // Fp2 add coeff 0/1
    let t365 = circuit_add(t110, in6); // Fp2 add coeff 1/1
    let t366 = circuit_mul(t364, t362); // Fp2 mul start
    let t367 = circuit_mul(t365, t363);
    let t368 = circuit_sub(t366, t367); // Fp2 mul real part end
    let t369 = circuit_mul(t364, t363);
    let t370 = circuit_mul(t365, t362);
    let t371 = circuit_add(t369, t370); // Fp2 mul imag part end
    let t372 = circuit_sub(t368, t302); // Fp2 sub coeff 0/1
    let t373 = circuit_sub(t371, t305); // Fp2 sub coeff 1/1
    let t374 = circuit_sub(t372, t314); // Fp2 sub coeff 0/1
    let t375 = circuit_sub(t373, t317); // Fp2 sub coeff 1/1
    let t376 = circuit_add(t374, t308); // Fp2 add coeff 0/1
    let t377 = circuit_add(t375, t311); // Fp2 add coeff 1/1
    let t378 = circuit_sub(t182, t260); // Fp6 sub coeff 0/5
    let t379 = circuit_sub(t183, t261); // Fp6 sub coeff 1/5
    let t380 = circuit_sub(t204, t282); // Fp6 sub coeff 2/5
    let t381 = circuit_sub(t205, t283); // Fp6 sub coeff 3/5
    let t382 = circuit_sub(t220, t298); // Fp6 sub coeff 4/5
    let t383 = circuit_sub(t221, t299); // Fp6 sub coeff 5/5
    let t384 = circuit_sub(t378, t338); // Fp6 sub coeff 0/5
    let t385 = circuit_sub(t379, t339); // Fp6 sub coeff 1/5
    let t386 = circuit_sub(t380, t360); // Fp6 sub coeff 2/5
    let t387 = circuit_sub(t381, t361); // Fp6 sub coeff 3/5
    let t388 = circuit_sub(t382, t376); // Fp6 sub coeff 4/5
    let t389 = circuit_sub(t383, t377); // Fp6 sub coeff 5/5
    let t390 = circuit_add(t376, t377);
    let t391 = circuit_mul(t390, in7);
    let t392 = circuit_mul(t376, in8);
    let t393 = circuit_sub(t392, t377);
    let t394 = circuit_sub(t391, t392);
    let t395 = circuit_sub(t394, t377);
    let t396 = circuit_add(t393, t260); // Fp6 add coeff 0/5
    let t397 = circuit_add(t395, t261); // Fp6 add coeff 1/5
    let t398 = circuit_add(t338, t282); // Fp6 add coeff 2/5
    let t399 = circuit_add(t339, t283); // Fp6 add coeff 3/5
    let t400 = circuit_add(t360, t298); // Fp6 add coeff 4/5
    let t401 = circuit_add(t361, t299); // Fp6 add coeff 5/5

    let modulus = get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (
        t396, t397, t398, t399, t400, t401, t384, t385, t386, t387, t388, t389,
    )
        .new_inputs();
    // Prefill constants:

    circuit_inputs = circuit_inputs
        .next_span(TOWER_MILLER_FINALIZE_BN_1P_BN254_CONSTANTS.span()); // in0 - in8

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(original_Q0.x0); // in9
    circuit_inputs = circuit_inputs.next_2(original_Q0.x1); // in10
    circuit_inputs = circuit_inputs.next_2(original_Q0.y0); // in11
    circuit_inputs = circuit_inputs.next_2(original_Q0.y1); // in12
    circuit_inputs = circuit_inputs.next_2(yInv_0); // in13
    circuit_inputs = circuit_inputs.next_2(xNegOverY_0); // in14
    circuit_inputs = circuit_inputs.next_2(Q_0.x0); // in15
    circuit_inputs = circuit_inputs.next_2(Q_0.x1); // in16
    circuit_inputs = circuit_inputs.next_2(Q_0.y0); // in17
    circuit_inputs = circuit_inputs.next_2(Q_0.y1); // in18
    circuit_inputs = circuit_inputs.next_2(Mi.c0b0a0); // in19
    circuit_inputs = circuit_inputs.next_2(Mi.c0b0a1); // in20
    circuit_inputs = circuit_inputs.next_2(Mi.c0b1a0); // in21
    circuit_inputs = circuit_inputs.next_2(Mi.c0b1a1); // in22
    circuit_inputs = circuit_inputs.next_2(Mi.c0b2a0); // in23
    circuit_inputs = circuit_inputs.next_2(Mi.c0b2a1); // in24
    circuit_inputs = circuit_inputs.next_2(Mi.c1b0a0); // in25
    circuit_inputs = circuit_inputs.next_2(Mi.c1b0a1); // in26
    circuit_inputs = circuit_inputs.next_2(Mi.c1b1a0); // in27
    circuit_inputs = circuit_inputs.next_2(Mi.c1b1a1); // in28
    circuit_inputs = circuit_inputs.next_2(Mi.c1b2a0); // in29
    circuit_inputs = circuit_inputs.next_2(Mi.c1b2a1); // in30

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let Mi: E12T = E12T {
        c0b0a0: outputs.get_output(t396),
        c0b0a1: outputs.get_output(t397),
        c0b1a0: outputs.get_output(t398),
        c0b1a1: outputs.get_output(t399),
        c0b2a0: outputs.get_output(t400),
        c0b2a1: outputs.get_output(t401),
        c1b0a0: outputs.get_output(t384),
        c1b0a1: outputs.get_output(t385),
        c1b1a0: outputs.get_output(t386),
        c1b1a1: outputs.get_output(t387),
        c1b2a0: outputs.get_output(t388),
        c1b2a1: outputs.get_output(t389),
    };
    return (Mi,);
}
const TOWER_MILLER_FINALIZE_BN_1P_BN254_CONSTANTS: [u384; 9] = [
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
    u384 { limb0: 0xa, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x9, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
];
#[inline(always)]
pub fn run_FP6_NEG_circuit(
    b0a0: u384, b0a1: u384, b1a0: u384, b1a1: u384, b2a0: u384, b2a1: u384, curve_index: usize,
) -> (u384, u384, u384, u384, u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0

    // INPUT stack
    let (in1, in2, in3) = (CE::<CI<1>> {}, CE::<CI<2>> {}, CE::<CI<3>> {});
    let (in4, in5, in6) = (CE::<CI<4>> {}, CE::<CI<5>> {}, CE::<CI<6>> {});
    let t0 = circuit_sub(in0, in1);
    let t1 = circuit_sub(in0, in2);
    let t2 = circuit_sub(in0, in3);
    let t3 = circuit_sub(in0, in4);
    let t4 = circuit_sub(in0, in5);
    let t5 = circuit_sub(in0, in6);

    let modulus = get_modulus(curve_index);

    let mut circuit_inputs = (t0, t1, t2, t3, t4, t5).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in0
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(b0a0); // in1
    circuit_inputs = circuit_inputs.next_2(b0a1); // in2
    circuit_inputs = circuit_inputs.next_2(b1a0); // in3
    circuit_inputs = circuit_inputs.next_2(b1a1); // in4
    circuit_inputs = circuit_inputs.next_2(b2a0); // in5
    circuit_inputs = circuit_inputs.next_2(b2a1); // in6

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let r0: u384 = outputs.get_output(t0);
    let r1: u384 = outputs.get_output(t1);
    let r2: u384 = outputs.get_output(t2);
    let r3: u384 = outputs.get_output(t3);
    let r4: u384 = outputs.get_output(t4);
    let r5: u384 = outputs.get_output(t5);
    return (r0, r1, r2, r3, r4, r5);
}

#[cfg(test)]
mod tests {
    use core::traits::TryInto;

    use core::circuit::{
        RangeCheck96, AddMod, MulMod, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
        circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, u384,
        CircuitOutputsTrait, CircuitModulus, AddInputResultTrait, CircuitInputs,
    };
    use garaga::definitions::{
        G1Point, G2Point, E12D, E12DMulQuotient, G1G2Pair, BNProcessedPair, BLSProcessedPair,
        MillerLoopResultScalingFactor, G2Line,
    };
    use garaga::ec_ops::{SlopeInterceptOutput, FunctionFeltEvaluations, FunctionFelt};

    use super::{
        run_BLS12_381_E12T_CYCLOTOMIC_SQUARE_circuit,
        run_BLS12_381_E12T_CYCLO_SQUARE_COMPRESSED_circuit,
        run_BLS12_381_E12T_DECOMP_KARABINA_II_circuit,
        run_BLS12_381_E12T_DECOMP_KARABINA_I_NZ_circuit,
        run_BLS12_381_E12T_DECOMP_KARABINA_I_Z_circuit, run_BLS12_381_E12T_FROBENIUS_CUBE_circuit,
        run_BLS12_381_E12T_FROBENIUS_SQUARE_circuit, run_BLS12_381_E12T_FROBENIUS_circuit,
        run_BLS12_381_E12T_INVERSE_circuit, run_BLS12_381_E12T_MUL_circuit,
        run_BLS12_381_TOWER_MILLER_BIT0_1P_circuit, run_BLS12_381_TOWER_MILLER_BIT1_1P_circuit,
        run_BLS12_381_TOWER_MILLER_INIT_BIT_1P_circuit, run_BN254_E12T_CYCLOTOMIC_SQUARE_circuit,
        run_BN254_E12T_FROBENIUS_CUBE_circuit, run_BN254_E12T_FROBENIUS_SQUARE_circuit,
        run_BN254_E12T_FROBENIUS_circuit, run_BN254_E12T_INVERSE_circuit,
        run_BN254_E12T_MUL_circuit, run_BN254_TOWER_MILLER_BIT0_1P_circuit,
        run_BN254_TOWER_MILLER_BIT1_1P_circuit, run_BN254_TOWER_MILLER_FINALIZE_BN_1P_circuit,
        run_FP6_NEG_circuit,
    };
}
