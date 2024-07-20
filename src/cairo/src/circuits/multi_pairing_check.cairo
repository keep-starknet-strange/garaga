use core::circuit::{
    RangeCheck96, AddMod, MulMod, u384, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
    circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, CircuitOutputsTrait,
    CircuitModulus, AddInputResultTrait, CircuitInputs, CircuitDefinition, CircuitData,
    CircuitInputAccumulator
};
use garaga::definitions::{
    get_a, get_b, get_p, get_g, get_min_one, G1Point, G2Point, E12D, E12DMulQuotient, G1G2Pair,
    BNProcessedPair, BLSProcessedPair, MillerLoopResultScalingFactor
};
use core::option::Option;


fn run_BLS12_381_MP_CHECK_BIT0_LOOP_2_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    Q0: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q1: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one: E12D,
    ci: u384,
    z: u384
) -> (G2Point, G2Point, u384, u384, u384) {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0x0
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 0x3
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 0x6

    // INPUT stack
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
    let in9 = CircuitElement::<CircuitInput<9>> {}; // 
    let in10 = CircuitElement::<CircuitInput<10>> {}; // 
    let in11 = CircuitElement::<CircuitInput<11>> {}; // 
    let in12 = CircuitElement::<CircuitInput<12>> {}; // 
    let in13 = CircuitElement::<CircuitInput<13>> {}; // 
    let in14 = CircuitElement::<CircuitInput<14>> {}; // 
    let in15 = CircuitElement::<CircuitInput<15>> {}; // 
    let in16 = CircuitElement::<CircuitInput<16>> {}; // 
    let in17 = CircuitElement::<CircuitInput<17>> {}; // 
    let in18 = CircuitElement::<CircuitInput<18>> {}; // 
    let in19 = CircuitElement::<CircuitInput<19>> {}; // 
    let in20 = CircuitElement::<CircuitInput<20>> {}; // 
    let in21 = CircuitElement::<CircuitInput<21>> {}; // 
    let in22 = CircuitElement::<CircuitInput<22>> {}; // 
    let in23 = CircuitElement::<CircuitInput<23>> {}; // 
    let in24 = CircuitElement::<CircuitInput<24>> {}; // 
    let in25 = CircuitElement::<CircuitInput<25>> {}; // 
    let in26 = CircuitElement::<CircuitInput<26>> {}; // 
    let in27 = CircuitElement::<CircuitInput<27>> {}; // 
    let in28 = CircuitElement::<CircuitInput<28>> {}; // 
    let in29 = CircuitElement::<CircuitInput<29>> {}; // 
    let in30 = CircuitElement::<CircuitInput<30>> {}; // 
    let t0 = circuit_mul(in30, in30); // Compute z^2
    let t1 = circuit_mul(t0, in30); // Compute z^3
    let t2 = circuit_mul(t1, in30); // Compute z^4
    let t3 = circuit_mul(t2, in30); // Compute z^5
    let t4 = circuit_mul(t3, in30); // Compute z^6
    let t5 = circuit_mul(t4, in30); // Compute z^7
    let t6 = circuit_mul(t5, in30); // Compute z^8
    let t7 = circuit_mul(t6, in30); // Compute z^9
    let t8 = circuit_mul(t7, in30); // Compute z^10
    let t9 = circuit_mul(t8, in30); // Compute z^11
    let t10 = circuit_mul(in29, in29); // Compute c_i = (c_(i-1))^2
    let t11 = circuit_mul(in16, in16); // Square f evaluation in Z, the result of previous bit.
    let t12 = circuit_add(in5, in6); // Doubling slope numerator start
    let t13 = circuit_sub(in5, in6);
    let t14 = circuit_mul(t12, t13);
    let t15 = circuit_mul(in5, in6);
    let t16 = circuit_mul(t14, in1);
    let t17 = circuit_mul(t15, in2); // Doubling slope numerator end
    let t18 = circuit_add(in7, in7); // Fp2 add coeff 0/1
    let t19 = circuit_add(in8, in8); // Fp2 add coeff 1/1
    let t20 = circuit_mul(t18, t18); // Fp2 Div x/y start : Fp2 Inv y start
    let t21 = circuit_mul(t19, t19);
    let t22 = circuit_add(t20, t21);
    let t23 = circuit_inverse(t22);
    let t24 = circuit_mul(t18, t23); // Fp2 Inv y real part end
    let t25 = circuit_mul(t19, t23);
    let t26 = circuit_sub(in0, t25); // Fp2 Inv y imag part end
    let t27 = circuit_mul(t16, t24); // Fp2 mul start
    let t28 = circuit_mul(t17, t26);
    let t29 = circuit_sub(t27, t28); // Fp2 mul real part end
    let t30 = circuit_mul(t16, t26);
    let t31 = circuit_mul(t17, t24);
    let t32 = circuit_add(t30, t31); // Fp2 mul imag part end
    let t33 = circuit_add(t29, t32);
    let t34 = circuit_sub(t29, t32);
    let t35 = circuit_mul(t33, t34);
    let t36 = circuit_mul(t29, t32);
    let t37 = circuit_add(t36, t36);
    let t38 = circuit_add(in5, in5); // Fp2 add coeff 0/1
    let t39 = circuit_add(in6, in6); // Fp2 add coeff 1/1
    let t40 = circuit_sub(t35, t38); // Fp2 sub coeff 0/1
    let t41 = circuit_sub(t37, t39); // Fp2 sub coeff 1/1
    let t42 = circuit_sub(in5, t40); // Fp2 sub coeff 0/1
    let t43 = circuit_sub(in6, t41); // Fp2 sub coeff 1/1
    let t44 = circuit_mul(t29, t42); // Fp2 mul start
    let t45 = circuit_mul(t32, t43);
    let t46 = circuit_sub(t44, t45); // Fp2 mul real part end
    let t47 = circuit_mul(t29, t43);
    let t48 = circuit_mul(t32, t42);
    let t49 = circuit_add(t47, t48); // Fp2 mul imag part end
    let t50 = circuit_sub(t46, in7); // Fp2 sub coeff 0/1
    let t51 = circuit_sub(t49, in8); // Fp2 sub coeff 1/1
    let t52 = circuit_mul(t29, in5); // Fp2 mul start
    let t53 = circuit_mul(t32, in6);
    let t54 = circuit_sub(t52, t53); // Fp2 mul real part end
    let t55 = circuit_mul(t29, in6);
    let t56 = circuit_mul(t32, in5);
    let t57 = circuit_add(t55, t56); // Fp2 mul imag part end
    let t58 = circuit_sub(t54, in7); // Fp2 sub coeff 0/1
    let t59 = circuit_sub(t57, in8); // Fp2 sub coeff 1/1
    let t60 = circuit_sub(t58, t59);
    let t61 = circuit_mul(t60, in3);
    let t62 = circuit_sub(t29, t32);
    let t63 = circuit_mul(t62, in4);
    let t64 = circuit_mul(t59, in3);
    let t65 = circuit_mul(t32, in4);
    let t66 = circuit_mul(t63, t0); // Eval sparse poly UnnamedPoly step coeff_2 * z^2
    let t67 = circuit_add(t61, t66); // Eval sparse poly UnnamedPoly step + coeff_2 * z^2
    let t68 = circuit_add(t67, t1); // Eval sparse poly UnnamedPoly step + 1*z^3
    let t69 = circuit_mul(t64, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t70 = circuit_add(t68, t69); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t71 = circuit_mul(t65, t6); // Eval sparse poly UnnamedPoly step coeff_8 * z^8
    let t72 = circuit_add(t70, t71); // Eval sparse poly UnnamedPoly step + coeff_8 * z^8
    let t73 = circuit_mul(t11, t72); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_0(z)
    let t74 = circuit_add(in11, in12); // Doubling slope numerator start
    let t75 = circuit_sub(in11, in12);
    let t76 = circuit_mul(t74, t75);
    let t77 = circuit_mul(in11, in12);
    let t78 = circuit_mul(t76, in1);
    let t79 = circuit_mul(t77, in2); // Doubling slope numerator end
    let t80 = circuit_add(in13, in13); // Fp2 add coeff 0/1
    let t81 = circuit_add(in14, in14); // Fp2 add coeff 1/1
    let t82 = circuit_mul(t80, t80); // Fp2 Div x/y start : Fp2 Inv y start
    let t83 = circuit_mul(t81, t81);
    let t84 = circuit_add(t82, t83);
    let t85 = circuit_inverse(t84);
    let t86 = circuit_mul(t80, t85); // Fp2 Inv y real part end
    let t87 = circuit_mul(t81, t85);
    let t88 = circuit_sub(in0, t87); // Fp2 Inv y imag part end
    let t89 = circuit_mul(t78, t86); // Fp2 mul start
    let t90 = circuit_mul(t79, t88);
    let t91 = circuit_sub(t89, t90); // Fp2 mul real part end
    let t92 = circuit_mul(t78, t88);
    let t93 = circuit_mul(t79, t86);
    let t94 = circuit_add(t92, t93); // Fp2 mul imag part end
    let t95 = circuit_add(t91, t94);
    let t96 = circuit_sub(t91, t94);
    let t97 = circuit_mul(t95, t96);
    let t98 = circuit_mul(t91, t94);
    let t99 = circuit_add(t98, t98);
    let t100 = circuit_add(in11, in11); // Fp2 add coeff 0/1
    let t101 = circuit_add(in12, in12); // Fp2 add coeff 1/1
    let t102 = circuit_sub(t97, t100); // Fp2 sub coeff 0/1
    let t103 = circuit_sub(t99, t101); // Fp2 sub coeff 1/1
    let t104 = circuit_sub(in11, t102); // Fp2 sub coeff 0/1
    let t105 = circuit_sub(in12, t103); // Fp2 sub coeff 1/1
    let t106 = circuit_mul(t91, t104); // Fp2 mul start
    let t107 = circuit_mul(t94, t105);
    let t108 = circuit_sub(t106, t107); // Fp2 mul real part end
    let t109 = circuit_mul(t91, t105);
    let t110 = circuit_mul(t94, t104);
    let t111 = circuit_add(t109, t110); // Fp2 mul imag part end
    let t112 = circuit_sub(t108, in13); // Fp2 sub coeff 0/1
    let t113 = circuit_sub(t111, in14); // Fp2 sub coeff 1/1
    let t114 = circuit_mul(t91, in11); // Fp2 mul start
    let t115 = circuit_mul(t94, in12);
    let t116 = circuit_sub(t114, t115); // Fp2 mul real part end
    let t117 = circuit_mul(t91, in12);
    let t118 = circuit_mul(t94, in11);
    let t119 = circuit_add(t117, t118); // Fp2 mul imag part end
    let t120 = circuit_sub(t116, in13); // Fp2 sub coeff 0/1
    let t121 = circuit_sub(t119, in14); // Fp2 sub coeff 1/1
    let t122 = circuit_sub(t120, t121);
    let t123 = circuit_mul(t122, in9);
    let t124 = circuit_sub(t91, t94);
    let t125 = circuit_mul(t124, in10);
    let t126 = circuit_mul(t121, in9);
    let t127 = circuit_mul(t94, in10);
    let t128 = circuit_mul(t125, t0); // Eval sparse poly UnnamedPoly step coeff_2 * z^2
    let t129 = circuit_add(t123, t128); // Eval sparse poly UnnamedPoly step + coeff_2 * z^2
    let t130 = circuit_add(t129, t1); // Eval sparse poly UnnamedPoly step + 1*z^3
    let t131 = circuit_mul(t126, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t132 = circuit_add(t130, t131); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t133 = circuit_mul(t127, t6); // Eval sparse poly UnnamedPoly step coeff_8 * z^8
    let t134 = circuit_add(t132, t133); // Eval sparse poly UnnamedPoly step + coeff_8 * z^8
    let t135 = circuit_mul(t73, t134); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_1(z)
    let t136 = circuit_mul(in18, in30); // Eval UnnamedPoly step coeff_1 * z^1
    let t137 = circuit_add(in17, t136); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t138 = circuit_mul(in19, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t139 = circuit_add(t137, t138); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t140 = circuit_mul(in20, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t141 = circuit_add(t139, t140); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t142 = circuit_mul(in21, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t143 = circuit_add(t141, t142); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t144 = circuit_mul(in22, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t145 = circuit_add(t143, t144); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t146 = circuit_mul(in23, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t147 = circuit_add(t145, t146); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t148 = circuit_mul(in24, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t149 = circuit_add(t147, t148); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t150 = circuit_mul(in25, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t151 = circuit_add(t149, t150); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t152 = circuit_mul(in26, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t153 = circuit_add(t151, t152); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t154 = circuit_mul(in27, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t155 = circuit_add(t153, t154); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t156 = circuit_mul(in28, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t157 = circuit_add(t155, t156); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t158 = circuit_sub(t135, t157); // (Π(i,k) (Pk(z))) - Ri(z)
    let t159 = circuit_mul(t10, t158); // ci * ((Π(i,k) (Pk(z)) - Ri(z))
    let t160 = circuit_add(in15, t159); // LHS = LHS + ci * ((Π(i,k) (Pk(z)) - Ri(z))

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [
            54880396502181392957329877675,
            31935979117156477062286671870,
            20826981314825584179608359615,
            8047903782086192180586325942
        ]
    )
        .unwrap();

    let mut circuit_inputs = (t40, t41, t50, t51, t102, t103, t112, t113, t157, t160, t10,)
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x6, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(Q0.x0);
    circuit_inputs = circuit_inputs.next(Q0.x1);
    circuit_inputs = circuit_inputs.next(Q0.y0);
    circuit_inputs = circuit_inputs.next(Q0.y1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(Q1.x0);
    circuit_inputs = circuit_inputs.next(Q1.x1);
    circuit_inputs = circuit_inputs.next(Q1.y0);
    circuit_inputs = circuit_inputs.next(Q1.y1);
    circuit_inputs = circuit_inputs.next(lhs_i);
    circuit_inputs = circuit_inputs.next(f_i_of_z);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w0);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w1);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w2);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w3);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w4);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w5);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w6);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w7);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w8);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w9);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w10);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w11);
    circuit_inputs = circuit_inputs.next(ci);
    circuit_inputs = circuit_inputs.next(z);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let Q0: G2Point = G2Point {
        x0: outputs.get_output(t40),
        x1: outputs.get_output(t41),
        y0: outputs.get_output(t50),
        y1: outputs.get_output(t51)
    };

    let Q1: G2Point = G2Point {
        x0: outputs.get_output(t102),
        x1: outputs.get_output(t103),
        y0: outputs.get_output(t112),
        y1: outputs.get_output(t113)
    };

    let f_i_plus_one_of_z: u384 = outputs.get_output(t157);

    let lhs_i_plus_one: u384 = outputs.get_output(t160);

    let ci_plus_one: u384 = outputs.get_output(t10);
    return (Q0, Q1, f_i_plus_one_of_z, lhs_i_plus_one, ci_plus_one);
}
fn run_BLS12_381_MP_CHECK_BIT0_LOOP_3_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    Q0: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q1: G2Point,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q2: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one: E12D,
    ci: u384,
    z: u384
) -> (G2Point, G2Point, G2Point, u384, u384, u384) {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0x0
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 0x3
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 0x6

    // INPUT stack
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
    let in9 = CircuitElement::<CircuitInput<9>> {}; // 
    let in10 = CircuitElement::<CircuitInput<10>> {}; // 
    let in11 = CircuitElement::<CircuitInput<11>> {}; // 
    let in12 = CircuitElement::<CircuitInput<12>> {}; // 
    let in13 = CircuitElement::<CircuitInput<13>> {}; // 
    let in14 = CircuitElement::<CircuitInput<14>> {}; // 
    let in15 = CircuitElement::<CircuitInput<15>> {}; // 
    let in16 = CircuitElement::<CircuitInput<16>> {}; // 
    let in17 = CircuitElement::<CircuitInput<17>> {}; // 
    let in18 = CircuitElement::<CircuitInput<18>> {}; // 
    let in19 = CircuitElement::<CircuitInput<19>> {}; // 
    let in20 = CircuitElement::<CircuitInput<20>> {}; // 
    let in21 = CircuitElement::<CircuitInput<21>> {}; // 
    let in22 = CircuitElement::<CircuitInput<22>> {}; // 
    let in23 = CircuitElement::<CircuitInput<23>> {}; // 
    let in24 = CircuitElement::<CircuitInput<24>> {}; // 
    let in25 = CircuitElement::<CircuitInput<25>> {}; // 
    let in26 = CircuitElement::<CircuitInput<26>> {}; // 
    let in27 = CircuitElement::<CircuitInput<27>> {}; // 
    let in28 = CircuitElement::<CircuitInput<28>> {}; // 
    let in29 = CircuitElement::<CircuitInput<29>> {}; // 
    let in30 = CircuitElement::<CircuitInput<30>> {}; // 
    let in31 = CircuitElement::<CircuitInput<31>> {}; // 
    let in32 = CircuitElement::<CircuitInput<32>> {}; // 
    let in33 = CircuitElement::<CircuitInput<33>> {}; // 
    let in34 = CircuitElement::<CircuitInput<34>> {}; // 
    let in35 = CircuitElement::<CircuitInput<35>> {}; // 
    let in36 = CircuitElement::<CircuitInput<36>> {}; // 
    let t0 = circuit_mul(in36, in36); // Compute z^2
    let t1 = circuit_mul(t0, in36); // Compute z^3
    let t2 = circuit_mul(t1, in36); // Compute z^4
    let t3 = circuit_mul(t2, in36); // Compute z^5
    let t4 = circuit_mul(t3, in36); // Compute z^6
    let t5 = circuit_mul(t4, in36); // Compute z^7
    let t6 = circuit_mul(t5, in36); // Compute z^8
    let t7 = circuit_mul(t6, in36); // Compute z^9
    let t8 = circuit_mul(t7, in36); // Compute z^10
    let t9 = circuit_mul(t8, in36); // Compute z^11
    let t10 = circuit_mul(in35, in35); // Compute c_i = (c_(i-1))^2
    let t11 = circuit_mul(in22, in22); // Square f evaluation in Z, the result of previous bit.
    let t12 = circuit_add(in5, in6); // Doubling slope numerator start
    let t13 = circuit_sub(in5, in6);
    let t14 = circuit_mul(t12, t13);
    let t15 = circuit_mul(in5, in6);
    let t16 = circuit_mul(t14, in1);
    let t17 = circuit_mul(t15, in2); // Doubling slope numerator end
    let t18 = circuit_add(in7, in7); // Fp2 add coeff 0/1
    let t19 = circuit_add(in8, in8); // Fp2 add coeff 1/1
    let t20 = circuit_mul(t18, t18); // Fp2 Div x/y start : Fp2 Inv y start
    let t21 = circuit_mul(t19, t19);
    let t22 = circuit_add(t20, t21);
    let t23 = circuit_inverse(t22);
    let t24 = circuit_mul(t18, t23); // Fp2 Inv y real part end
    let t25 = circuit_mul(t19, t23);
    let t26 = circuit_sub(in0, t25); // Fp2 Inv y imag part end
    let t27 = circuit_mul(t16, t24); // Fp2 mul start
    let t28 = circuit_mul(t17, t26);
    let t29 = circuit_sub(t27, t28); // Fp2 mul real part end
    let t30 = circuit_mul(t16, t26);
    let t31 = circuit_mul(t17, t24);
    let t32 = circuit_add(t30, t31); // Fp2 mul imag part end
    let t33 = circuit_add(t29, t32);
    let t34 = circuit_sub(t29, t32);
    let t35 = circuit_mul(t33, t34);
    let t36 = circuit_mul(t29, t32);
    let t37 = circuit_add(t36, t36);
    let t38 = circuit_add(in5, in5); // Fp2 add coeff 0/1
    let t39 = circuit_add(in6, in6); // Fp2 add coeff 1/1
    let t40 = circuit_sub(t35, t38); // Fp2 sub coeff 0/1
    let t41 = circuit_sub(t37, t39); // Fp2 sub coeff 1/1
    let t42 = circuit_sub(in5, t40); // Fp2 sub coeff 0/1
    let t43 = circuit_sub(in6, t41); // Fp2 sub coeff 1/1
    let t44 = circuit_mul(t29, t42); // Fp2 mul start
    let t45 = circuit_mul(t32, t43);
    let t46 = circuit_sub(t44, t45); // Fp2 mul real part end
    let t47 = circuit_mul(t29, t43);
    let t48 = circuit_mul(t32, t42);
    let t49 = circuit_add(t47, t48); // Fp2 mul imag part end
    let t50 = circuit_sub(t46, in7); // Fp2 sub coeff 0/1
    let t51 = circuit_sub(t49, in8); // Fp2 sub coeff 1/1
    let t52 = circuit_mul(t29, in5); // Fp2 mul start
    let t53 = circuit_mul(t32, in6);
    let t54 = circuit_sub(t52, t53); // Fp2 mul real part end
    let t55 = circuit_mul(t29, in6);
    let t56 = circuit_mul(t32, in5);
    let t57 = circuit_add(t55, t56); // Fp2 mul imag part end
    let t58 = circuit_sub(t54, in7); // Fp2 sub coeff 0/1
    let t59 = circuit_sub(t57, in8); // Fp2 sub coeff 1/1
    let t60 = circuit_sub(t58, t59);
    let t61 = circuit_mul(t60, in3);
    let t62 = circuit_sub(t29, t32);
    let t63 = circuit_mul(t62, in4);
    let t64 = circuit_mul(t59, in3);
    let t65 = circuit_mul(t32, in4);
    let t66 = circuit_mul(t63, t0); // Eval sparse poly UnnamedPoly step coeff_2 * z^2
    let t67 = circuit_add(t61, t66); // Eval sparse poly UnnamedPoly step + coeff_2 * z^2
    let t68 = circuit_add(t67, t1); // Eval sparse poly UnnamedPoly step + 1*z^3
    let t69 = circuit_mul(t64, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t70 = circuit_add(t68, t69); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t71 = circuit_mul(t65, t6); // Eval sparse poly UnnamedPoly step coeff_8 * z^8
    let t72 = circuit_add(t70, t71); // Eval sparse poly UnnamedPoly step + coeff_8 * z^8
    let t73 = circuit_mul(t11, t72); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_0(z)
    let t74 = circuit_add(in11, in12); // Doubling slope numerator start
    let t75 = circuit_sub(in11, in12);
    let t76 = circuit_mul(t74, t75);
    let t77 = circuit_mul(in11, in12);
    let t78 = circuit_mul(t76, in1);
    let t79 = circuit_mul(t77, in2); // Doubling slope numerator end
    let t80 = circuit_add(in13, in13); // Fp2 add coeff 0/1
    let t81 = circuit_add(in14, in14); // Fp2 add coeff 1/1
    let t82 = circuit_mul(t80, t80); // Fp2 Div x/y start : Fp2 Inv y start
    let t83 = circuit_mul(t81, t81);
    let t84 = circuit_add(t82, t83);
    let t85 = circuit_inverse(t84);
    let t86 = circuit_mul(t80, t85); // Fp2 Inv y real part end
    let t87 = circuit_mul(t81, t85);
    let t88 = circuit_sub(in0, t87); // Fp2 Inv y imag part end
    let t89 = circuit_mul(t78, t86); // Fp2 mul start
    let t90 = circuit_mul(t79, t88);
    let t91 = circuit_sub(t89, t90); // Fp2 mul real part end
    let t92 = circuit_mul(t78, t88);
    let t93 = circuit_mul(t79, t86);
    let t94 = circuit_add(t92, t93); // Fp2 mul imag part end
    let t95 = circuit_add(t91, t94);
    let t96 = circuit_sub(t91, t94);
    let t97 = circuit_mul(t95, t96);
    let t98 = circuit_mul(t91, t94);
    let t99 = circuit_add(t98, t98);
    let t100 = circuit_add(in11, in11); // Fp2 add coeff 0/1
    let t101 = circuit_add(in12, in12); // Fp2 add coeff 1/1
    let t102 = circuit_sub(t97, t100); // Fp2 sub coeff 0/1
    let t103 = circuit_sub(t99, t101); // Fp2 sub coeff 1/1
    let t104 = circuit_sub(in11, t102); // Fp2 sub coeff 0/1
    let t105 = circuit_sub(in12, t103); // Fp2 sub coeff 1/1
    let t106 = circuit_mul(t91, t104); // Fp2 mul start
    let t107 = circuit_mul(t94, t105);
    let t108 = circuit_sub(t106, t107); // Fp2 mul real part end
    let t109 = circuit_mul(t91, t105);
    let t110 = circuit_mul(t94, t104);
    let t111 = circuit_add(t109, t110); // Fp2 mul imag part end
    let t112 = circuit_sub(t108, in13); // Fp2 sub coeff 0/1
    let t113 = circuit_sub(t111, in14); // Fp2 sub coeff 1/1
    let t114 = circuit_mul(t91, in11); // Fp2 mul start
    let t115 = circuit_mul(t94, in12);
    let t116 = circuit_sub(t114, t115); // Fp2 mul real part end
    let t117 = circuit_mul(t91, in12);
    let t118 = circuit_mul(t94, in11);
    let t119 = circuit_add(t117, t118); // Fp2 mul imag part end
    let t120 = circuit_sub(t116, in13); // Fp2 sub coeff 0/1
    let t121 = circuit_sub(t119, in14); // Fp2 sub coeff 1/1
    let t122 = circuit_sub(t120, t121);
    let t123 = circuit_mul(t122, in9);
    let t124 = circuit_sub(t91, t94);
    let t125 = circuit_mul(t124, in10);
    let t126 = circuit_mul(t121, in9);
    let t127 = circuit_mul(t94, in10);
    let t128 = circuit_mul(t125, t0); // Eval sparse poly UnnamedPoly step coeff_2 * z^2
    let t129 = circuit_add(t123, t128); // Eval sparse poly UnnamedPoly step + coeff_2 * z^2
    let t130 = circuit_add(t129, t1); // Eval sparse poly UnnamedPoly step + 1*z^3
    let t131 = circuit_mul(t126, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t132 = circuit_add(t130, t131); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t133 = circuit_mul(t127, t6); // Eval sparse poly UnnamedPoly step coeff_8 * z^8
    let t134 = circuit_add(t132, t133); // Eval sparse poly UnnamedPoly step + coeff_8 * z^8
    let t135 = circuit_mul(t73, t134); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_1(z)
    let t136 = circuit_add(in17, in18); // Doubling slope numerator start
    let t137 = circuit_sub(in17, in18);
    let t138 = circuit_mul(t136, t137);
    let t139 = circuit_mul(in17, in18);
    let t140 = circuit_mul(t138, in1);
    let t141 = circuit_mul(t139, in2); // Doubling slope numerator end
    let t142 = circuit_add(in19, in19); // Fp2 add coeff 0/1
    let t143 = circuit_add(in20, in20); // Fp2 add coeff 1/1
    let t144 = circuit_mul(t142, t142); // Fp2 Div x/y start : Fp2 Inv y start
    let t145 = circuit_mul(t143, t143);
    let t146 = circuit_add(t144, t145);
    let t147 = circuit_inverse(t146);
    let t148 = circuit_mul(t142, t147); // Fp2 Inv y real part end
    let t149 = circuit_mul(t143, t147);
    let t150 = circuit_sub(in0, t149); // Fp2 Inv y imag part end
    let t151 = circuit_mul(t140, t148); // Fp2 mul start
    let t152 = circuit_mul(t141, t150);
    let t153 = circuit_sub(t151, t152); // Fp2 mul real part end
    let t154 = circuit_mul(t140, t150);
    let t155 = circuit_mul(t141, t148);
    let t156 = circuit_add(t154, t155); // Fp2 mul imag part end
    let t157 = circuit_add(t153, t156);
    let t158 = circuit_sub(t153, t156);
    let t159 = circuit_mul(t157, t158);
    let t160 = circuit_mul(t153, t156);
    let t161 = circuit_add(t160, t160);
    let t162 = circuit_add(in17, in17); // Fp2 add coeff 0/1
    let t163 = circuit_add(in18, in18); // Fp2 add coeff 1/1
    let t164 = circuit_sub(t159, t162); // Fp2 sub coeff 0/1
    let t165 = circuit_sub(t161, t163); // Fp2 sub coeff 1/1
    let t166 = circuit_sub(in17, t164); // Fp2 sub coeff 0/1
    let t167 = circuit_sub(in18, t165); // Fp2 sub coeff 1/1
    let t168 = circuit_mul(t153, t166); // Fp2 mul start
    let t169 = circuit_mul(t156, t167);
    let t170 = circuit_sub(t168, t169); // Fp2 mul real part end
    let t171 = circuit_mul(t153, t167);
    let t172 = circuit_mul(t156, t166);
    let t173 = circuit_add(t171, t172); // Fp2 mul imag part end
    let t174 = circuit_sub(t170, in19); // Fp2 sub coeff 0/1
    let t175 = circuit_sub(t173, in20); // Fp2 sub coeff 1/1
    let t176 = circuit_mul(t153, in17); // Fp2 mul start
    let t177 = circuit_mul(t156, in18);
    let t178 = circuit_sub(t176, t177); // Fp2 mul real part end
    let t179 = circuit_mul(t153, in18);
    let t180 = circuit_mul(t156, in17);
    let t181 = circuit_add(t179, t180); // Fp2 mul imag part end
    let t182 = circuit_sub(t178, in19); // Fp2 sub coeff 0/1
    let t183 = circuit_sub(t181, in20); // Fp2 sub coeff 1/1
    let t184 = circuit_sub(t182, t183);
    let t185 = circuit_mul(t184, in15);
    let t186 = circuit_sub(t153, t156);
    let t187 = circuit_mul(t186, in16);
    let t188 = circuit_mul(t183, in15);
    let t189 = circuit_mul(t156, in16);
    let t190 = circuit_mul(t187, t0); // Eval sparse poly UnnamedPoly step coeff_2 * z^2
    let t191 = circuit_add(t185, t190); // Eval sparse poly UnnamedPoly step + coeff_2 * z^2
    let t192 = circuit_add(t191, t1); // Eval sparse poly UnnamedPoly step + 1*z^3
    let t193 = circuit_mul(t188, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t194 = circuit_add(t192, t193); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t195 = circuit_mul(t189, t6); // Eval sparse poly UnnamedPoly step coeff_8 * z^8
    let t196 = circuit_add(t194, t195); // Eval sparse poly UnnamedPoly step + coeff_8 * z^8
    let t197 = circuit_mul(t135, t196); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_2(z)
    let t198 = circuit_mul(in24, in36); // Eval UnnamedPoly step coeff_1 * z^1
    let t199 = circuit_add(in23, t198); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t200 = circuit_mul(in25, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t201 = circuit_add(t199, t200); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t202 = circuit_mul(in26, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t203 = circuit_add(t201, t202); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t204 = circuit_mul(in27, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t205 = circuit_add(t203, t204); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t206 = circuit_mul(in28, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t207 = circuit_add(t205, t206); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t208 = circuit_mul(in29, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t209 = circuit_add(t207, t208); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t210 = circuit_mul(in30, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t211 = circuit_add(t209, t210); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t212 = circuit_mul(in31, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t213 = circuit_add(t211, t212); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t214 = circuit_mul(in32, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t215 = circuit_add(t213, t214); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t216 = circuit_mul(in33, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t217 = circuit_add(t215, t216); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t218 = circuit_mul(in34, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t219 = circuit_add(t217, t218); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t220 = circuit_sub(t197, t219); // (Π(i,k) (Pk(z))) - Ri(z)
    let t221 = circuit_mul(t10, t220); // ci * ((Π(i,k) (Pk(z)) - Ri(z))
    let t222 = circuit_add(in21, t221); // LHS = LHS + ci * ((Π(i,k) (Pk(z)) - Ri(z))

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [
            54880396502181392957329877675,
            31935979117156477062286671870,
            20826981314825584179608359615,
            8047903782086192180586325942
        ]
    )
        .unwrap();

    let mut circuit_inputs = (
        t40, t41, t50, t51, t102, t103, t112, t113, t164, t165, t174, t175, t219, t222, t10,
    )
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x6, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(Q0.x0);
    circuit_inputs = circuit_inputs.next(Q0.x1);
    circuit_inputs = circuit_inputs.next(Q0.y0);
    circuit_inputs = circuit_inputs.next(Q0.y1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(Q1.x0);
    circuit_inputs = circuit_inputs.next(Q1.x1);
    circuit_inputs = circuit_inputs.next(Q1.y0);
    circuit_inputs = circuit_inputs.next(Q1.y1);
    circuit_inputs = circuit_inputs.next(yInv_2);
    circuit_inputs = circuit_inputs.next(xNegOverY_2);
    circuit_inputs = circuit_inputs.next(Q2.x0);
    circuit_inputs = circuit_inputs.next(Q2.x1);
    circuit_inputs = circuit_inputs.next(Q2.y0);
    circuit_inputs = circuit_inputs.next(Q2.y1);
    circuit_inputs = circuit_inputs.next(lhs_i);
    circuit_inputs = circuit_inputs.next(f_i_of_z);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w0);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w1);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w2);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w3);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w4);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w5);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w6);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w7);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w8);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w9);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w10);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w11);
    circuit_inputs = circuit_inputs.next(ci);
    circuit_inputs = circuit_inputs.next(z);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let Q0: G2Point = G2Point {
        x0: outputs.get_output(t40),
        x1: outputs.get_output(t41),
        y0: outputs.get_output(t50),
        y1: outputs.get_output(t51)
    };

    let Q1: G2Point = G2Point {
        x0: outputs.get_output(t102),
        x1: outputs.get_output(t103),
        y0: outputs.get_output(t112),
        y1: outputs.get_output(t113)
    };

    let Q2: G2Point = G2Point {
        x0: outputs.get_output(t164),
        x1: outputs.get_output(t165),
        y0: outputs.get_output(t174),
        y1: outputs.get_output(t175)
    };

    let f_i_plus_one_of_z: u384 = outputs.get_output(t219);

    let lhs_i_plus_one: u384 = outputs.get_output(t222);

    let ci_plus_one: u384 = outputs.get_output(t10);
    return (Q0, Q1, Q2, f_i_plus_one_of_z, lhs_i_plus_one, ci_plus_one);
}
fn run_BLS12_381_MP_CHECK_BIT1_LOOP_2_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    Q0: G2Point,
    Q_or_Qneg_0: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q1: G2Point,
    Q_or_Qneg_1: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one: E12D,
    c_or_cinv_of_z: u384,
    z: u384,
    ci: u384
) -> (G2Point, G2Point, u384, u384, u384) {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0x0

    // INPUT stack
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
    let in9 = CircuitElement::<CircuitInput<9>> {}; // 
    let in10 = CircuitElement::<CircuitInput<10>> {}; // 
    let in11 = CircuitElement::<CircuitInput<11>> {}; // 
    let in12 = CircuitElement::<CircuitInput<12>> {}; // 
    let in13 = CircuitElement::<CircuitInput<13>> {}; // 
    let in14 = CircuitElement::<CircuitInput<14>> {}; // 
    let in15 = CircuitElement::<CircuitInput<15>> {}; // 
    let in16 = CircuitElement::<CircuitInput<16>> {}; // 
    let in17 = CircuitElement::<CircuitInput<17>> {}; // 
    let in18 = CircuitElement::<CircuitInput<18>> {}; // 
    let in19 = CircuitElement::<CircuitInput<19>> {}; // 
    let in20 = CircuitElement::<CircuitInput<20>> {}; // 
    let in21 = CircuitElement::<CircuitInput<21>> {}; // 
    let in22 = CircuitElement::<CircuitInput<22>> {}; // 
    let in23 = CircuitElement::<CircuitInput<23>> {}; // 
    let in24 = CircuitElement::<CircuitInput<24>> {}; // 
    let in25 = CircuitElement::<CircuitInput<25>> {}; // 
    let in26 = CircuitElement::<CircuitInput<26>> {}; // 
    let in27 = CircuitElement::<CircuitInput<27>> {}; // 
    let in28 = CircuitElement::<CircuitInput<28>> {}; // 
    let in29 = CircuitElement::<CircuitInput<29>> {}; // 
    let in30 = CircuitElement::<CircuitInput<30>> {}; // 
    let in31 = CircuitElement::<CircuitInput<31>> {}; // 
    let in32 = CircuitElement::<CircuitInput<32>> {}; // 
    let in33 = CircuitElement::<CircuitInput<33>> {}; // 
    let in34 = CircuitElement::<CircuitInput<34>> {}; // 
    let in35 = CircuitElement::<CircuitInput<35>> {}; // 
    let in36 = CircuitElement::<CircuitInput<36>> {}; // 
    let in37 = CircuitElement::<CircuitInput<37>> {}; // 
    let t0 = circuit_mul(in36, in36); // Compute z^2
    let t1 = circuit_mul(t0, in36); // Compute z^3
    let t2 = circuit_mul(t1, in36); // Compute z^4
    let t3 = circuit_mul(t2, in36); // Compute z^5
    let t4 = circuit_mul(t3, in36); // Compute z^6
    let t5 = circuit_mul(t4, in36); // Compute z^7
    let t6 = circuit_mul(t5, in36); // Compute z^8
    let t7 = circuit_mul(t6, in36); // Compute z^9
    let t8 = circuit_mul(t7, in36); // Compute z^10
    let t9 = circuit_mul(t8, in36); // Compute z^11
    let t10 = circuit_mul(in37, in37);
    let t11 = circuit_mul(in22, in22);
    let t12 = circuit_sub(in5, in9); // Fp2 sub coeff 0/1
    let t13 = circuit_sub(in6, in10); // Fp2 sub coeff 1/1
    let t14 = circuit_sub(in3, in7); // Fp2 sub coeff 0/1
    let t15 = circuit_sub(in4, in8); // Fp2 sub coeff 1/1
    let t16 = circuit_mul(t14, t14); // Fp2 Div x/y start : Fp2 Inv y start
    let t17 = circuit_mul(t15, t15);
    let t18 = circuit_add(t16, t17);
    let t19 = circuit_inverse(t18);
    let t20 = circuit_mul(t14, t19); // Fp2 Inv y real part end
    let t21 = circuit_mul(t15, t19);
    let t22 = circuit_sub(in0, t21); // Fp2 Inv y imag part end
    let t23 = circuit_mul(t12, t20); // Fp2 mul start
    let t24 = circuit_mul(t13, t22);
    let t25 = circuit_sub(t23, t24); // Fp2 mul real part end
    let t26 = circuit_mul(t12, t22);
    let t27 = circuit_mul(t13, t20);
    let t28 = circuit_add(t26, t27); // Fp2 mul imag part end
    let t29 = circuit_add(t25, t28);
    let t30 = circuit_sub(t25, t28);
    let t31 = circuit_mul(t29, t30);
    let t32 = circuit_mul(t25, t28);
    let t33 = circuit_add(t32, t32);
    let t34 = circuit_add(in3, in7); // Fp2 add coeff 0/1
    let t35 = circuit_add(in4, in8); // Fp2 add coeff 1/1
    let t36 = circuit_sub(t31, t34); // Fp2 sub coeff 0/1
    let t37 = circuit_sub(t33, t35); // Fp2 sub coeff 1/1
    let t38 = circuit_mul(t25, in3); // Fp2 mul start
    let t39 = circuit_mul(t28, in4);
    let t40 = circuit_sub(t38, t39); // Fp2 mul real part end
    let t41 = circuit_mul(t25, in4);
    let t42 = circuit_mul(t28, in3);
    let t43 = circuit_add(t41, t42); // Fp2 mul imag part end
    let t44 = circuit_sub(t40, in5); // Fp2 sub coeff 0/1
    let t45 = circuit_sub(t43, in6); // Fp2 sub coeff 1/1
    let t46 = circuit_sub(t44, t45);
    let t47 = circuit_mul(t46, in1);
    let t48 = circuit_sub(t25, t28);
    let t49 = circuit_mul(t48, in2);
    let t50 = circuit_mul(t45, in1);
    let t51 = circuit_mul(t28, in2);
    let t52 = circuit_add(in5, in5); // Fp2 add coeff 0/1
    let t53 = circuit_add(in6, in6); // Fp2 add coeff 1/1
    let t54 = circuit_sub(t36, in3); // Fp2 sub coeff 0/1
    let t55 = circuit_sub(t37, in4); // Fp2 sub coeff 1/1
    let t56 = circuit_mul(t54, t54); // Fp2 Div x/y start : Fp2 Inv y start
    let t57 = circuit_mul(t55, t55);
    let t58 = circuit_add(t56, t57);
    let t59 = circuit_inverse(t58);
    let t60 = circuit_mul(t54, t59); // Fp2 Inv y real part end
    let t61 = circuit_mul(t55, t59);
    let t62 = circuit_sub(in0, t61); // Fp2 Inv y imag part end
    let t63 = circuit_mul(t52, t60); // Fp2 mul start
    let t64 = circuit_mul(t53, t62);
    let t65 = circuit_sub(t63, t64); // Fp2 mul real part end
    let t66 = circuit_mul(t52, t62);
    let t67 = circuit_mul(t53, t60);
    let t68 = circuit_add(t66, t67); // Fp2 mul imag part end
    let t69 = circuit_add(t25, t65); // Fp2 add coeff 0/1
    let t70 = circuit_add(t28, t68); // Fp2 add coeff 1/1
    let t71 = circuit_sub(in0, t69); // Fp2 neg coeff 0/1
    let t72 = circuit_sub(in0, t70); // Fp2 neg coeff 1/1
    let t73 = circuit_add(t71, t72);
    let t74 = circuit_sub(t71, t72);
    let t75 = circuit_mul(t73, t74);
    let t76 = circuit_mul(t71, t72);
    let t77 = circuit_add(t76, t76);
    let t78 = circuit_sub(t75, in3); // Fp2 sub coeff 0/1
    let t79 = circuit_sub(t77, in4); // Fp2 sub coeff 1/1
    let t80 = circuit_sub(t78, t36); // Fp2 sub coeff 0/1
    let t81 = circuit_sub(t79, t37); // Fp2 sub coeff 1/1
    let t82 = circuit_sub(in3, t80); // Fp2 sub coeff 0/1
    let t83 = circuit_sub(in4, t81); // Fp2 sub coeff 1/1
    let t84 = circuit_mul(t71, t82); // Fp2 mul start
    let t85 = circuit_mul(t72, t83);
    let t86 = circuit_sub(t84, t85); // Fp2 mul real part end
    let t87 = circuit_mul(t71, t83);
    let t88 = circuit_mul(t72, t82);
    let t89 = circuit_add(t87, t88); // Fp2 mul imag part end
    let t90 = circuit_sub(t86, in5); // Fp2 sub coeff 0/1
    let t91 = circuit_sub(t89, in6); // Fp2 sub coeff 1/1
    let t92 = circuit_mul(t71, in3); // Fp2 mul start
    let t93 = circuit_mul(t72, in4);
    let t94 = circuit_sub(t92, t93); // Fp2 mul real part end
    let t95 = circuit_mul(t71, in4);
    let t96 = circuit_mul(t72, in3);
    let t97 = circuit_add(t95, t96); // Fp2 mul imag part end
    let t98 = circuit_sub(t94, in5); // Fp2 sub coeff 0/1
    let t99 = circuit_sub(t97, in6); // Fp2 sub coeff 1/1
    let t100 = circuit_sub(t98, t99);
    let t101 = circuit_mul(t100, in1);
    let t102 = circuit_sub(t71, t72);
    let t103 = circuit_mul(t102, in2);
    let t104 = circuit_mul(t99, in1);
    let t105 = circuit_mul(t72, in2);
    let t106 = circuit_mul(t49, t0); // Eval sparse poly UnnamedPoly step coeff_2 * z^2
    let t107 = circuit_add(t47, t106); // Eval sparse poly UnnamedPoly step + coeff_2 * z^2
    let t108 = circuit_add(t107, t1); // Eval sparse poly UnnamedPoly step + 1*z^3
    let t109 = circuit_mul(t50, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t110 = circuit_add(t108, t109); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t111 = circuit_mul(t51, t6); // Eval sparse poly UnnamedPoly step coeff_8 * z^8
    let t112 = circuit_add(t110, t111); // Eval sparse poly UnnamedPoly step + coeff_8 * z^8
    let t113 = circuit_mul(t11, t112);
    let t114 = circuit_mul(t103, t0); // Eval sparse poly UnnamedPoly step coeff_2 * z^2
    let t115 = circuit_add(t101, t114); // Eval sparse poly UnnamedPoly step + coeff_2 * z^2
    let t116 = circuit_add(t115, t1); // Eval sparse poly UnnamedPoly step + 1*z^3
    let t117 = circuit_mul(t104, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t118 = circuit_add(t116, t117); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t119 = circuit_mul(t105, t6); // Eval sparse poly UnnamedPoly step coeff_8 * z^8
    let t120 = circuit_add(t118, t119); // Eval sparse poly UnnamedPoly step + coeff_8 * z^8
    let t121 = circuit_mul(t113, t120);
    let t122 = circuit_sub(in15, in19); // Fp2 sub coeff 0/1
    let t123 = circuit_sub(in16, in20); // Fp2 sub coeff 1/1
    let t124 = circuit_sub(in13, in17); // Fp2 sub coeff 0/1
    let t125 = circuit_sub(in14, in18); // Fp2 sub coeff 1/1
    let t126 = circuit_mul(t124, t124); // Fp2 Div x/y start : Fp2 Inv y start
    let t127 = circuit_mul(t125, t125);
    let t128 = circuit_add(t126, t127);
    let t129 = circuit_inverse(t128);
    let t130 = circuit_mul(t124, t129); // Fp2 Inv y real part end
    let t131 = circuit_mul(t125, t129);
    let t132 = circuit_sub(in0, t131); // Fp2 Inv y imag part end
    let t133 = circuit_mul(t122, t130); // Fp2 mul start
    let t134 = circuit_mul(t123, t132);
    let t135 = circuit_sub(t133, t134); // Fp2 mul real part end
    let t136 = circuit_mul(t122, t132);
    let t137 = circuit_mul(t123, t130);
    let t138 = circuit_add(t136, t137); // Fp2 mul imag part end
    let t139 = circuit_add(t135, t138);
    let t140 = circuit_sub(t135, t138);
    let t141 = circuit_mul(t139, t140);
    let t142 = circuit_mul(t135, t138);
    let t143 = circuit_add(t142, t142);
    let t144 = circuit_add(in13, in17); // Fp2 add coeff 0/1
    let t145 = circuit_add(in14, in18); // Fp2 add coeff 1/1
    let t146 = circuit_sub(t141, t144); // Fp2 sub coeff 0/1
    let t147 = circuit_sub(t143, t145); // Fp2 sub coeff 1/1
    let t148 = circuit_mul(t135, in13); // Fp2 mul start
    let t149 = circuit_mul(t138, in14);
    let t150 = circuit_sub(t148, t149); // Fp2 mul real part end
    let t151 = circuit_mul(t135, in14);
    let t152 = circuit_mul(t138, in13);
    let t153 = circuit_add(t151, t152); // Fp2 mul imag part end
    let t154 = circuit_sub(t150, in15); // Fp2 sub coeff 0/1
    let t155 = circuit_sub(t153, in16); // Fp2 sub coeff 1/1
    let t156 = circuit_sub(t154, t155);
    let t157 = circuit_mul(t156, in11);
    let t158 = circuit_sub(t135, t138);
    let t159 = circuit_mul(t158, in12);
    let t160 = circuit_mul(t155, in11);
    let t161 = circuit_mul(t138, in12);
    let t162 = circuit_add(in15, in15); // Fp2 add coeff 0/1
    let t163 = circuit_add(in16, in16); // Fp2 add coeff 1/1
    let t164 = circuit_sub(t146, in13); // Fp2 sub coeff 0/1
    let t165 = circuit_sub(t147, in14); // Fp2 sub coeff 1/1
    let t166 = circuit_mul(t164, t164); // Fp2 Div x/y start : Fp2 Inv y start
    let t167 = circuit_mul(t165, t165);
    let t168 = circuit_add(t166, t167);
    let t169 = circuit_inverse(t168);
    let t170 = circuit_mul(t164, t169); // Fp2 Inv y real part end
    let t171 = circuit_mul(t165, t169);
    let t172 = circuit_sub(in0, t171); // Fp2 Inv y imag part end
    let t173 = circuit_mul(t162, t170); // Fp2 mul start
    let t174 = circuit_mul(t163, t172);
    let t175 = circuit_sub(t173, t174); // Fp2 mul real part end
    let t176 = circuit_mul(t162, t172);
    let t177 = circuit_mul(t163, t170);
    let t178 = circuit_add(t176, t177); // Fp2 mul imag part end
    let t179 = circuit_add(t135, t175); // Fp2 add coeff 0/1
    let t180 = circuit_add(t138, t178); // Fp2 add coeff 1/1
    let t181 = circuit_sub(in0, t179); // Fp2 neg coeff 0/1
    let t182 = circuit_sub(in0, t180); // Fp2 neg coeff 1/1
    let t183 = circuit_add(t181, t182);
    let t184 = circuit_sub(t181, t182);
    let t185 = circuit_mul(t183, t184);
    let t186 = circuit_mul(t181, t182);
    let t187 = circuit_add(t186, t186);
    let t188 = circuit_sub(t185, in13); // Fp2 sub coeff 0/1
    let t189 = circuit_sub(t187, in14); // Fp2 sub coeff 1/1
    let t190 = circuit_sub(t188, t146); // Fp2 sub coeff 0/1
    let t191 = circuit_sub(t189, t147); // Fp2 sub coeff 1/1
    let t192 = circuit_sub(in13, t190); // Fp2 sub coeff 0/1
    let t193 = circuit_sub(in14, t191); // Fp2 sub coeff 1/1
    let t194 = circuit_mul(t181, t192); // Fp2 mul start
    let t195 = circuit_mul(t182, t193);
    let t196 = circuit_sub(t194, t195); // Fp2 mul real part end
    let t197 = circuit_mul(t181, t193);
    let t198 = circuit_mul(t182, t192);
    let t199 = circuit_add(t197, t198); // Fp2 mul imag part end
    let t200 = circuit_sub(t196, in15); // Fp2 sub coeff 0/1
    let t201 = circuit_sub(t199, in16); // Fp2 sub coeff 1/1
    let t202 = circuit_mul(t181, in13); // Fp2 mul start
    let t203 = circuit_mul(t182, in14);
    let t204 = circuit_sub(t202, t203); // Fp2 mul real part end
    let t205 = circuit_mul(t181, in14);
    let t206 = circuit_mul(t182, in13);
    let t207 = circuit_add(t205, t206); // Fp2 mul imag part end
    let t208 = circuit_sub(t204, in15); // Fp2 sub coeff 0/1
    let t209 = circuit_sub(t207, in16); // Fp2 sub coeff 1/1
    let t210 = circuit_sub(t208, t209);
    let t211 = circuit_mul(t210, in11);
    let t212 = circuit_sub(t181, t182);
    let t213 = circuit_mul(t212, in12);
    let t214 = circuit_mul(t209, in11);
    let t215 = circuit_mul(t182, in12);
    let t216 = circuit_mul(t159, t0); // Eval sparse poly UnnamedPoly step coeff_2 * z^2
    let t217 = circuit_add(t157, t216); // Eval sparse poly UnnamedPoly step + coeff_2 * z^2
    let t218 = circuit_add(t217, t1); // Eval sparse poly UnnamedPoly step + 1*z^3
    let t219 = circuit_mul(t160, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t220 = circuit_add(t218, t219); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t221 = circuit_mul(t161, t6); // Eval sparse poly UnnamedPoly step coeff_8 * z^8
    let t222 = circuit_add(t220, t221); // Eval sparse poly UnnamedPoly step + coeff_8 * z^8
    let t223 = circuit_mul(t121, t222);
    let t224 = circuit_mul(t213, t0); // Eval sparse poly UnnamedPoly step coeff_2 * z^2
    let t225 = circuit_add(t211, t224); // Eval sparse poly UnnamedPoly step + coeff_2 * z^2
    let t226 = circuit_add(t225, t1); // Eval sparse poly UnnamedPoly step + 1*z^3
    let t227 = circuit_mul(t214, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t228 = circuit_add(t226, t227); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t229 = circuit_mul(t215, t6); // Eval sparse poly UnnamedPoly step coeff_8 * z^8
    let t230 = circuit_add(t228, t229); // Eval sparse poly UnnamedPoly step + coeff_8 * z^8
    let t231 = circuit_mul(t223, t230);
    let t232 = circuit_mul(t231, in35);
    let t233 = circuit_mul(in24, in36); // Eval UnnamedPoly step coeff_1 * z^1
    let t234 = circuit_add(in23, t233); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t235 = circuit_mul(in25, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t236 = circuit_add(t234, t235); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t237 = circuit_mul(in26, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t238 = circuit_add(t236, t237); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t239 = circuit_mul(in27, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t240 = circuit_add(t238, t239); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t241 = circuit_mul(in28, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t242 = circuit_add(t240, t241); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t243 = circuit_mul(in29, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t244 = circuit_add(t242, t243); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t245 = circuit_mul(in30, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t246 = circuit_add(t244, t245); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t247 = circuit_mul(in31, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t248 = circuit_add(t246, t247); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t249 = circuit_mul(in32, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t250 = circuit_add(t248, t249); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t251 = circuit_mul(in33, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t252 = circuit_add(t250, t251); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t253 = circuit_mul(in34, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t254 = circuit_add(t252, t253); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t255 = circuit_sub(t232, t254);
    let t256 = circuit_mul(t10, t255); // ci * ((Π(i,k) (Pk(z)) - Ri(z))
    let t257 = circuit_add(in21, t256);

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [
            54880396502181392957329877675,
            31935979117156477062286671870,
            20826981314825584179608359615,
            8047903782086192180586325942
        ]
    )
        .unwrap();

    let mut circuit_inputs = (t80, t81, t90, t91, t190, t191, t200, t201, t254, t257, t10,)
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(Q0.x0);
    circuit_inputs = circuit_inputs.next(Q0.x1);
    circuit_inputs = circuit_inputs.next(Q0.y0);
    circuit_inputs = circuit_inputs.next(Q0.y1);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_0.x0);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_0.x1);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_0.y0);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_0.y1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(Q1.x0);
    circuit_inputs = circuit_inputs.next(Q1.x1);
    circuit_inputs = circuit_inputs.next(Q1.y0);
    circuit_inputs = circuit_inputs.next(Q1.y1);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_1.x0);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_1.x1);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_1.y0);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_1.y1);
    circuit_inputs = circuit_inputs.next(lhs_i);
    circuit_inputs = circuit_inputs.next(f_i_of_z);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w0);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w1);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w2);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w3);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w4);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w5);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w6);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w7);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w8);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w9);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w10);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w11);
    circuit_inputs = circuit_inputs.next(c_or_cinv_of_z);
    circuit_inputs = circuit_inputs.next(z);
    circuit_inputs = circuit_inputs.next(ci);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let Q0: G2Point = G2Point {
        x0: outputs.get_output(t80),
        x1: outputs.get_output(t81),
        y0: outputs.get_output(t90),
        y1: outputs.get_output(t91)
    };

    let Q1: G2Point = G2Point {
        x0: outputs.get_output(t190),
        x1: outputs.get_output(t191),
        y0: outputs.get_output(t200),
        y1: outputs.get_output(t201)
    };

    let f_i_plus_one_of_z: u384 = outputs.get_output(t254);

    let lhs_i_plus_one: u384 = outputs.get_output(t257);

    let ci_plus_one: u384 = outputs.get_output(t10);
    return (Q0, Q1, f_i_plus_one_of_z, lhs_i_plus_one, ci_plus_one);
}
fn run_BLS12_381_MP_CHECK_BIT1_LOOP_3_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    Q0: G2Point,
    Q_or_Qneg_0: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q1: G2Point,
    Q_or_Qneg_1: G2Point,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q2: G2Point,
    Q_or_Qneg_2: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one: E12D,
    c_or_cinv_of_z: u384,
    z: u384,
    ci: u384
) -> (G2Point, G2Point, G2Point, u384, u384, u384) {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0x0

    // INPUT stack
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
    let in9 = CircuitElement::<CircuitInput<9>> {}; // 
    let in10 = CircuitElement::<CircuitInput<10>> {}; // 
    let in11 = CircuitElement::<CircuitInput<11>> {}; // 
    let in12 = CircuitElement::<CircuitInput<12>> {}; // 
    let in13 = CircuitElement::<CircuitInput<13>> {}; // 
    let in14 = CircuitElement::<CircuitInput<14>> {}; // 
    let in15 = CircuitElement::<CircuitInput<15>> {}; // 
    let in16 = CircuitElement::<CircuitInput<16>> {}; // 
    let in17 = CircuitElement::<CircuitInput<17>> {}; // 
    let in18 = CircuitElement::<CircuitInput<18>> {}; // 
    let in19 = CircuitElement::<CircuitInput<19>> {}; // 
    let in20 = CircuitElement::<CircuitInput<20>> {}; // 
    let in21 = CircuitElement::<CircuitInput<21>> {}; // 
    let in22 = CircuitElement::<CircuitInput<22>> {}; // 
    let in23 = CircuitElement::<CircuitInput<23>> {}; // 
    let in24 = CircuitElement::<CircuitInput<24>> {}; // 
    let in25 = CircuitElement::<CircuitInput<25>> {}; // 
    let in26 = CircuitElement::<CircuitInput<26>> {}; // 
    let in27 = CircuitElement::<CircuitInput<27>> {}; // 
    let in28 = CircuitElement::<CircuitInput<28>> {}; // 
    let in29 = CircuitElement::<CircuitInput<29>> {}; // 
    let in30 = CircuitElement::<CircuitInput<30>> {}; // 
    let in31 = CircuitElement::<CircuitInput<31>> {}; // 
    let in32 = CircuitElement::<CircuitInput<32>> {}; // 
    let in33 = CircuitElement::<CircuitInput<33>> {}; // 
    let in34 = CircuitElement::<CircuitInput<34>> {}; // 
    let in35 = CircuitElement::<CircuitInput<35>> {}; // 
    let in36 = CircuitElement::<CircuitInput<36>> {}; // 
    let in37 = CircuitElement::<CircuitInput<37>> {}; // 
    let in38 = CircuitElement::<CircuitInput<38>> {}; // 
    let in39 = CircuitElement::<CircuitInput<39>> {}; // 
    let in40 = CircuitElement::<CircuitInput<40>> {}; // 
    let in41 = CircuitElement::<CircuitInput<41>> {}; // 
    let in42 = CircuitElement::<CircuitInput<42>> {}; // 
    let in43 = CircuitElement::<CircuitInput<43>> {}; // 
    let in44 = CircuitElement::<CircuitInput<44>> {}; // 
    let in45 = CircuitElement::<CircuitInput<45>> {}; // 
    let in46 = CircuitElement::<CircuitInput<46>> {}; // 
    let in47 = CircuitElement::<CircuitInput<47>> {}; // 
    let t0 = circuit_mul(in46, in46); // Compute z^2
    let t1 = circuit_mul(t0, in46); // Compute z^3
    let t2 = circuit_mul(t1, in46); // Compute z^4
    let t3 = circuit_mul(t2, in46); // Compute z^5
    let t4 = circuit_mul(t3, in46); // Compute z^6
    let t5 = circuit_mul(t4, in46); // Compute z^7
    let t6 = circuit_mul(t5, in46); // Compute z^8
    let t7 = circuit_mul(t6, in46); // Compute z^9
    let t8 = circuit_mul(t7, in46); // Compute z^10
    let t9 = circuit_mul(t8, in46); // Compute z^11
    let t10 = circuit_mul(in47, in47);
    let t11 = circuit_mul(in32, in32);
    let t12 = circuit_sub(in5, in9); // Fp2 sub coeff 0/1
    let t13 = circuit_sub(in6, in10); // Fp2 sub coeff 1/1
    let t14 = circuit_sub(in3, in7); // Fp2 sub coeff 0/1
    let t15 = circuit_sub(in4, in8); // Fp2 sub coeff 1/1
    let t16 = circuit_mul(t14, t14); // Fp2 Div x/y start : Fp2 Inv y start
    let t17 = circuit_mul(t15, t15);
    let t18 = circuit_add(t16, t17);
    let t19 = circuit_inverse(t18);
    let t20 = circuit_mul(t14, t19); // Fp2 Inv y real part end
    let t21 = circuit_mul(t15, t19);
    let t22 = circuit_sub(in0, t21); // Fp2 Inv y imag part end
    let t23 = circuit_mul(t12, t20); // Fp2 mul start
    let t24 = circuit_mul(t13, t22);
    let t25 = circuit_sub(t23, t24); // Fp2 mul real part end
    let t26 = circuit_mul(t12, t22);
    let t27 = circuit_mul(t13, t20);
    let t28 = circuit_add(t26, t27); // Fp2 mul imag part end
    let t29 = circuit_add(t25, t28);
    let t30 = circuit_sub(t25, t28);
    let t31 = circuit_mul(t29, t30);
    let t32 = circuit_mul(t25, t28);
    let t33 = circuit_add(t32, t32);
    let t34 = circuit_add(in3, in7); // Fp2 add coeff 0/1
    let t35 = circuit_add(in4, in8); // Fp2 add coeff 1/1
    let t36 = circuit_sub(t31, t34); // Fp2 sub coeff 0/1
    let t37 = circuit_sub(t33, t35); // Fp2 sub coeff 1/1
    let t38 = circuit_mul(t25, in3); // Fp2 mul start
    let t39 = circuit_mul(t28, in4);
    let t40 = circuit_sub(t38, t39); // Fp2 mul real part end
    let t41 = circuit_mul(t25, in4);
    let t42 = circuit_mul(t28, in3);
    let t43 = circuit_add(t41, t42); // Fp2 mul imag part end
    let t44 = circuit_sub(t40, in5); // Fp2 sub coeff 0/1
    let t45 = circuit_sub(t43, in6); // Fp2 sub coeff 1/1
    let t46 = circuit_sub(t44, t45);
    let t47 = circuit_mul(t46, in1);
    let t48 = circuit_sub(t25, t28);
    let t49 = circuit_mul(t48, in2);
    let t50 = circuit_mul(t45, in1);
    let t51 = circuit_mul(t28, in2);
    let t52 = circuit_add(in5, in5); // Fp2 add coeff 0/1
    let t53 = circuit_add(in6, in6); // Fp2 add coeff 1/1
    let t54 = circuit_sub(t36, in3); // Fp2 sub coeff 0/1
    let t55 = circuit_sub(t37, in4); // Fp2 sub coeff 1/1
    let t56 = circuit_mul(t54, t54); // Fp2 Div x/y start : Fp2 Inv y start
    let t57 = circuit_mul(t55, t55);
    let t58 = circuit_add(t56, t57);
    let t59 = circuit_inverse(t58);
    let t60 = circuit_mul(t54, t59); // Fp2 Inv y real part end
    let t61 = circuit_mul(t55, t59);
    let t62 = circuit_sub(in0, t61); // Fp2 Inv y imag part end
    let t63 = circuit_mul(t52, t60); // Fp2 mul start
    let t64 = circuit_mul(t53, t62);
    let t65 = circuit_sub(t63, t64); // Fp2 mul real part end
    let t66 = circuit_mul(t52, t62);
    let t67 = circuit_mul(t53, t60);
    let t68 = circuit_add(t66, t67); // Fp2 mul imag part end
    let t69 = circuit_add(t25, t65); // Fp2 add coeff 0/1
    let t70 = circuit_add(t28, t68); // Fp2 add coeff 1/1
    let t71 = circuit_sub(in0, t69); // Fp2 neg coeff 0/1
    let t72 = circuit_sub(in0, t70); // Fp2 neg coeff 1/1
    let t73 = circuit_add(t71, t72);
    let t74 = circuit_sub(t71, t72);
    let t75 = circuit_mul(t73, t74);
    let t76 = circuit_mul(t71, t72);
    let t77 = circuit_add(t76, t76);
    let t78 = circuit_sub(t75, in3); // Fp2 sub coeff 0/1
    let t79 = circuit_sub(t77, in4); // Fp2 sub coeff 1/1
    let t80 = circuit_sub(t78, t36); // Fp2 sub coeff 0/1
    let t81 = circuit_sub(t79, t37); // Fp2 sub coeff 1/1
    let t82 = circuit_sub(in3, t80); // Fp2 sub coeff 0/1
    let t83 = circuit_sub(in4, t81); // Fp2 sub coeff 1/1
    let t84 = circuit_mul(t71, t82); // Fp2 mul start
    let t85 = circuit_mul(t72, t83);
    let t86 = circuit_sub(t84, t85); // Fp2 mul real part end
    let t87 = circuit_mul(t71, t83);
    let t88 = circuit_mul(t72, t82);
    let t89 = circuit_add(t87, t88); // Fp2 mul imag part end
    let t90 = circuit_sub(t86, in5); // Fp2 sub coeff 0/1
    let t91 = circuit_sub(t89, in6); // Fp2 sub coeff 1/1
    let t92 = circuit_mul(t71, in3); // Fp2 mul start
    let t93 = circuit_mul(t72, in4);
    let t94 = circuit_sub(t92, t93); // Fp2 mul real part end
    let t95 = circuit_mul(t71, in4);
    let t96 = circuit_mul(t72, in3);
    let t97 = circuit_add(t95, t96); // Fp2 mul imag part end
    let t98 = circuit_sub(t94, in5); // Fp2 sub coeff 0/1
    let t99 = circuit_sub(t97, in6); // Fp2 sub coeff 1/1
    let t100 = circuit_sub(t98, t99);
    let t101 = circuit_mul(t100, in1);
    let t102 = circuit_sub(t71, t72);
    let t103 = circuit_mul(t102, in2);
    let t104 = circuit_mul(t99, in1);
    let t105 = circuit_mul(t72, in2);
    let t106 = circuit_mul(t49, t0); // Eval sparse poly UnnamedPoly step coeff_2 * z^2
    let t107 = circuit_add(t47, t106); // Eval sparse poly UnnamedPoly step + coeff_2 * z^2
    let t108 = circuit_add(t107, t1); // Eval sparse poly UnnamedPoly step + 1*z^3
    let t109 = circuit_mul(t50, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t110 = circuit_add(t108, t109); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t111 = circuit_mul(t51, t6); // Eval sparse poly UnnamedPoly step coeff_8 * z^8
    let t112 = circuit_add(t110, t111); // Eval sparse poly UnnamedPoly step + coeff_8 * z^8
    let t113 = circuit_mul(t11, t112);
    let t114 = circuit_mul(t103, t0); // Eval sparse poly UnnamedPoly step coeff_2 * z^2
    let t115 = circuit_add(t101, t114); // Eval sparse poly UnnamedPoly step + coeff_2 * z^2
    let t116 = circuit_add(t115, t1); // Eval sparse poly UnnamedPoly step + 1*z^3
    let t117 = circuit_mul(t104, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t118 = circuit_add(t116, t117); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t119 = circuit_mul(t105, t6); // Eval sparse poly UnnamedPoly step coeff_8 * z^8
    let t120 = circuit_add(t118, t119); // Eval sparse poly UnnamedPoly step + coeff_8 * z^8
    let t121 = circuit_mul(t113, t120);
    let t122 = circuit_sub(in15, in19); // Fp2 sub coeff 0/1
    let t123 = circuit_sub(in16, in20); // Fp2 sub coeff 1/1
    let t124 = circuit_sub(in13, in17); // Fp2 sub coeff 0/1
    let t125 = circuit_sub(in14, in18); // Fp2 sub coeff 1/1
    let t126 = circuit_mul(t124, t124); // Fp2 Div x/y start : Fp2 Inv y start
    let t127 = circuit_mul(t125, t125);
    let t128 = circuit_add(t126, t127);
    let t129 = circuit_inverse(t128);
    let t130 = circuit_mul(t124, t129); // Fp2 Inv y real part end
    let t131 = circuit_mul(t125, t129);
    let t132 = circuit_sub(in0, t131); // Fp2 Inv y imag part end
    let t133 = circuit_mul(t122, t130); // Fp2 mul start
    let t134 = circuit_mul(t123, t132);
    let t135 = circuit_sub(t133, t134); // Fp2 mul real part end
    let t136 = circuit_mul(t122, t132);
    let t137 = circuit_mul(t123, t130);
    let t138 = circuit_add(t136, t137); // Fp2 mul imag part end
    let t139 = circuit_add(t135, t138);
    let t140 = circuit_sub(t135, t138);
    let t141 = circuit_mul(t139, t140);
    let t142 = circuit_mul(t135, t138);
    let t143 = circuit_add(t142, t142);
    let t144 = circuit_add(in13, in17); // Fp2 add coeff 0/1
    let t145 = circuit_add(in14, in18); // Fp2 add coeff 1/1
    let t146 = circuit_sub(t141, t144); // Fp2 sub coeff 0/1
    let t147 = circuit_sub(t143, t145); // Fp2 sub coeff 1/1
    let t148 = circuit_mul(t135, in13); // Fp2 mul start
    let t149 = circuit_mul(t138, in14);
    let t150 = circuit_sub(t148, t149); // Fp2 mul real part end
    let t151 = circuit_mul(t135, in14);
    let t152 = circuit_mul(t138, in13);
    let t153 = circuit_add(t151, t152); // Fp2 mul imag part end
    let t154 = circuit_sub(t150, in15); // Fp2 sub coeff 0/1
    let t155 = circuit_sub(t153, in16); // Fp2 sub coeff 1/1
    let t156 = circuit_sub(t154, t155);
    let t157 = circuit_mul(t156, in11);
    let t158 = circuit_sub(t135, t138);
    let t159 = circuit_mul(t158, in12);
    let t160 = circuit_mul(t155, in11);
    let t161 = circuit_mul(t138, in12);
    let t162 = circuit_add(in15, in15); // Fp2 add coeff 0/1
    let t163 = circuit_add(in16, in16); // Fp2 add coeff 1/1
    let t164 = circuit_sub(t146, in13); // Fp2 sub coeff 0/1
    let t165 = circuit_sub(t147, in14); // Fp2 sub coeff 1/1
    let t166 = circuit_mul(t164, t164); // Fp2 Div x/y start : Fp2 Inv y start
    let t167 = circuit_mul(t165, t165);
    let t168 = circuit_add(t166, t167);
    let t169 = circuit_inverse(t168);
    let t170 = circuit_mul(t164, t169); // Fp2 Inv y real part end
    let t171 = circuit_mul(t165, t169);
    let t172 = circuit_sub(in0, t171); // Fp2 Inv y imag part end
    let t173 = circuit_mul(t162, t170); // Fp2 mul start
    let t174 = circuit_mul(t163, t172);
    let t175 = circuit_sub(t173, t174); // Fp2 mul real part end
    let t176 = circuit_mul(t162, t172);
    let t177 = circuit_mul(t163, t170);
    let t178 = circuit_add(t176, t177); // Fp2 mul imag part end
    let t179 = circuit_add(t135, t175); // Fp2 add coeff 0/1
    let t180 = circuit_add(t138, t178); // Fp2 add coeff 1/1
    let t181 = circuit_sub(in0, t179); // Fp2 neg coeff 0/1
    let t182 = circuit_sub(in0, t180); // Fp2 neg coeff 1/1
    let t183 = circuit_add(t181, t182);
    let t184 = circuit_sub(t181, t182);
    let t185 = circuit_mul(t183, t184);
    let t186 = circuit_mul(t181, t182);
    let t187 = circuit_add(t186, t186);
    let t188 = circuit_sub(t185, in13); // Fp2 sub coeff 0/1
    let t189 = circuit_sub(t187, in14); // Fp2 sub coeff 1/1
    let t190 = circuit_sub(t188, t146); // Fp2 sub coeff 0/1
    let t191 = circuit_sub(t189, t147); // Fp2 sub coeff 1/1
    let t192 = circuit_sub(in13, t190); // Fp2 sub coeff 0/1
    let t193 = circuit_sub(in14, t191); // Fp2 sub coeff 1/1
    let t194 = circuit_mul(t181, t192); // Fp2 mul start
    let t195 = circuit_mul(t182, t193);
    let t196 = circuit_sub(t194, t195); // Fp2 mul real part end
    let t197 = circuit_mul(t181, t193);
    let t198 = circuit_mul(t182, t192);
    let t199 = circuit_add(t197, t198); // Fp2 mul imag part end
    let t200 = circuit_sub(t196, in15); // Fp2 sub coeff 0/1
    let t201 = circuit_sub(t199, in16); // Fp2 sub coeff 1/1
    let t202 = circuit_mul(t181, in13); // Fp2 mul start
    let t203 = circuit_mul(t182, in14);
    let t204 = circuit_sub(t202, t203); // Fp2 mul real part end
    let t205 = circuit_mul(t181, in14);
    let t206 = circuit_mul(t182, in13);
    let t207 = circuit_add(t205, t206); // Fp2 mul imag part end
    let t208 = circuit_sub(t204, in15); // Fp2 sub coeff 0/1
    let t209 = circuit_sub(t207, in16); // Fp2 sub coeff 1/1
    let t210 = circuit_sub(t208, t209);
    let t211 = circuit_mul(t210, in11);
    let t212 = circuit_sub(t181, t182);
    let t213 = circuit_mul(t212, in12);
    let t214 = circuit_mul(t209, in11);
    let t215 = circuit_mul(t182, in12);
    let t216 = circuit_mul(t159, t0); // Eval sparse poly UnnamedPoly step coeff_2 * z^2
    let t217 = circuit_add(t157, t216); // Eval sparse poly UnnamedPoly step + coeff_2 * z^2
    let t218 = circuit_add(t217, t1); // Eval sparse poly UnnamedPoly step + 1*z^3
    let t219 = circuit_mul(t160, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t220 = circuit_add(t218, t219); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t221 = circuit_mul(t161, t6); // Eval sparse poly UnnamedPoly step coeff_8 * z^8
    let t222 = circuit_add(t220, t221); // Eval sparse poly UnnamedPoly step + coeff_8 * z^8
    let t223 = circuit_mul(t121, t222);
    let t224 = circuit_mul(t213, t0); // Eval sparse poly UnnamedPoly step coeff_2 * z^2
    let t225 = circuit_add(t211, t224); // Eval sparse poly UnnamedPoly step + coeff_2 * z^2
    let t226 = circuit_add(t225, t1); // Eval sparse poly UnnamedPoly step + 1*z^3
    let t227 = circuit_mul(t214, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t228 = circuit_add(t226, t227); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t229 = circuit_mul(t215, t6); // Eval sparse poly UnnamedPoly step coeff_8 * z^8
    let t230 = circuit_add(t228, t229); // Eval sparse poly UnnamedPoly step + coeff_8 * z^8
    let t231 = circuit_mul(t223, t230);
    let t232 = circuit_sub(in25, in29); // Fp2 sub coeff 0/1
    let t233 = circuit_sub(in26, in30); // Fp2 sub coeff 1/1
    let t234 = circuit_sub(in23, in27); // Fp2 sub coeff 0/1
    let t235 = circuit_sub(in24, in28); // Fp2 sub coeff 1/1
    let t236 = circuit_mul(t234, t234); // Fp2 Div x/y start : Fp2 Inv y start
    let t237 = circuit_mul(t235, t235);
    let t238 = circuit_add(t236, t237);
    let t239 = circuit_inverse(t238);
    let t240 = circuit_mul(t234, t239); // Fp2 Inv y real part end
    let t241 = circuit_mul(t235, t239);
    let t242 = circuit_sub(in0, t241); // Fp2 Inv y imag part end
    let t243 = circuit_mul(t232, t240); // Fp2 mul start
    let t244 = circuit_mul(t233, t242);
    let t245 = circuit_sub(t243, t244); // Fp2 mul real part end
    let t246 = circuit_mul(t232, t242);
    let t247 = circuit_mul(t233, t240);
    let t248 = circuit_add(t246, t247); // Fp2 mul imag part end
    let t249 = circuit_add(t245, t248);
    let t250 = circuit_sub(t245, t248);
    let t251 = circuit_mul(t249, t250);
    let t252 = circuit_mul(t245, t248);
    let t253 = circuit_add(t252, t252);
    let t254 = circuit_add(in23, in27); // Fp2 add coeff 0/1
    let t255 = circuit_add(in24, in28); // Fp2 add coeff 1/1
    let t256 = circuit_sub(t251, t254); // Fp2 sub coeff 0/1
    let t257 = circuit_sub(t253, t255); // Fp2 sub coeff 1/1
    let t258 = circuit_mul(t245, in23); // Fp2 mul start
    let t259 = circuit_mul(t248, in24);
    let t260 = circuit_sub(t258, t259); // Fp2 mul real part end
    let t261 = circuit_mul(t245, in24);
    let t262 = circuit_mul(t248, in23);
    let t263 = circuit_add(t261, t262); // Fp2 mul imag part end
    let t264 = circuit_sub(t260, in25); // Fp2 sub coeff 0/1
    let t265 = circuit_sub(t263, in26); // Fp2 sub coeff 1/1
    let t266 = circuit_sub(t264, t265);
    let t267 = circuit_mul(t266, in21);
    let t268 = circuit_sub(t245, t248);
    let t269 = circuit_mul(t268, in22);
    let t270 = circuit_mul(t265, in21);
    let t271 = circuit_mul(t248, in22);
    let t272 = circuit_add(in25, in25); // Fp2 add coeff 0/1
    let t273 = circuit_add(in26, in26); // Fp2 add coeff 1/1
    let t274 = circuit_sub(t256, in23); // Fp2 sub coeff 0/1
    let t275 = circuit_sub(t257, in24); // Fp2 sub coeff 1/1
    let t276 = circuit_mul(t274, t274); // Fp2 Div x/y start : Fp2 Inv y start
    let t277 = circuit_mul(t275, t275);
    let t278 = circuit_add(t276, t277);
    let t279 = circuit_inverse(t278);
    let t280 = circuit_mul(t274, t279); // Fp2 Inv y real part end
    let t281 = circuit_mul(t275, t279);
    let t282 = circuit_sub(in0, t281); // Fp2 Inv y imag part end
    let t283 = circuit_mul(t272, t280); // Fp2 mul start
    let t284 = circuit_mul(t273, t282);
    let t285 = circuit_sub(t283, t284); // Fp2 mul real part end
    let t286 = circuit_mul(t272, t282);
    let t287 = circuit_mul(t273, t280);
    let t288 = circuit_add(t286, t287); // Fp2 mul imag part end
    let t289 = circuit_add(t245, t285); // Fp2 add coeff 0/1
    let t290 = circuit_add(t248, t288); // Fp2 add coeff 1/1
    let t291 = circuit_sub(in0, t289); // Fp2 neg coeff 0/1
    let t292 = circuit_sub(in0, t290); // Fp2 neg coeff 1/1
    let t293 = circuit_add(t291, t292);
    let t294 = circuit_sub(t291, t292);
    let t295 = circuit_mul(t293, t294);
    let t296 = circuit_mul(t291, t292);
    let t297 = circuit_add(t296, t296);
    let t298 = circuit_sub(t295, in23); // Fp2 sub coeff 0/1
    let t299 = circuit_sub(t297, in24); // Fp2 sub coeff 1/1
    let t300 = circuit_sub(t298, t256); // Fp2 sub coeff 0/1
    let t301 = circuit_sub(t299, t257); // Fp2 sub coeff 1/1
    let t302 = circuit_sub(in23, t300); // Fp2 sub coeff 0/1
    let t303 = circuit_sub(in24, t301); // Fp2 sub coeff 1/1
    let t304 = circuit_mul(t291, t302); // Fp2 mul start
    let t305 = circuit_mul(t292, t303);
    let t306 = circuit_sub(t304, t305); // Fp2 mul real part end
    let t307 = circuit_mul(t291, t303);
    let t308 = circuit_mul(t292, t302);
    let t309 = circuit_add(t307, t308); // Fp2 mul imag part end
    let t310 = circuit_sub(t306, in25); // Fp2 sub coeff 0/1
    let t311 = circuit_sub(t309, in26); // Fp2 sub coeff 1/1
    let t312 = circuit_mul(t291, in23); // Fp2 mul start
    let t313 = circuit_mul(t292, in24);
    let t314 = circuit_sub(t312, t313); // Fp2 mul real part end
    let t315 = circuit_mul(t291, in24);
    let t316 = circuit_mul(t292, in23);
    let t317 = circuit_add(t315, t316); // Fp2 mul imag part end
    let t318 = circuit_sub(t314, in25); // Fp2 sub coeff 0/1
    let t319 = circuit_sub(t317, in26); // Fp2 sub coeff 1/1
    let t320 = circuit_sub(t318, t319);
    let t321 = circuit_mul(t320, in21);
    let t322 = circuit_sub(t291, t292);
    let t323 = circuit_mul(t322, in22);
    let t324 = circuit_mul(t319, in21);
    let t325 = circuit_mul(t292, in22);
    let t326 = circuit_mul(t269, t0); // Eval sparse poly UnnamedPoly step coeff_2 * z^2
    let t327 = circuit_add(t267, t326); // Eval sparse poly UnnamedPoly step + coeff_2 * z^2
    let t328 = circuit_add(t327, t1); // Eval sparse poly UnnamedPoly step + 1*z^3
    let t329 = circuit_mul(t270, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t330 = circuit_add(t328, t329); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t331 = circuit_mul(t271, t6); // Eval sparse poly UnnamedPoly step coeff_8 * z^8
    let t332 = circuit_add(t330, t331); // Eval sparse poly UnnamedPoly step + coeff_8 * z^8
    let t333 = circuit_mul(t231, t332);
    let t334 = circuit_mul(t323, t0); // Eval sparse poly UnnamedPoly step coeff_2 * z^2
    let t335 = circuit_add(t321, t334); // Eval sparse poly UnnamedPoly step + coeff_2 * z^2
    let t336 = circuit_add(t335, t1); // Eval sparse poly UnnamedPoly step + 1*z^3
    let t337 = circuit_mul(t324, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t338 = circuit_add(t336, t337); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t339 = circuit_mul(t325, t6); // Eval sparse poly UnnamedPoly step coeff_8 * z^8
    let t340 = circuit_add(t338, t339); // Eval sparse poly UnnamedPoly step + coeff_8 * z^8
    let t341 = circuit_mul(t333, t340);
    let t342 = circuit_mul(t341, in45);
    let t343 = circuit_mul(in34, in46); // Eval UnnamedPoly step coeff_1 * z^1
    let t344 = circuit_add(in33, t343); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t345 = circuit_mul(in35, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t346 = circuit_add(t344, t345); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t347 = circuit_mul(in36, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t348 = circuit_add(t346, t347); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t349 = circuit_mul(in37, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t350 = circuit_add(t348, t349); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t351 = circuit_mul(in38, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t352 = circuit_add(t350, t351); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t353 = circuit_mul(in39, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t354 = circuit_add(t352, t353); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t355 = circuit_mul(in40, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t356 = circuit_add(t354, t355); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t357 = circuit_mul(in41, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t358 = circuit_add(t356, t357); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t359 = circuit_mul(in42, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t360 = circuit_add(t358, t359); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t361 = circuit_mul(in43, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t362 = circuit_add(t360, t361); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t363 = circuit_mul(in44, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t364 = circuit_add(t362, t363); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t365 = circuit_sub(t342, t364);
    let t366 = circuit_mul(t10, t365); // ci * ((Π(i,k) (Pk(z)) - Ri(z))
    let t367 = circuit_add(in31, t366);

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [
            54880396502181392957329877675,
            31935979117156477062286671870,
            20826981314825584179608359615,
            8047903782086192180586325942
        ]
    )
        .unwrap();

    let mut circuit_inputs = (
        t80, t81, t90, t91, t190, t191, t200, t201, t300, t301, t310, t311, t364, t367, t10,
    )
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(Q0.x0);
    circuit_inputs = circuit_inputs.next(Q0.x1);
    circuit_inputs = circuit_inputs.next(Q0.y0);
    circuit_inputs = circuit_inputs.next(Q0.y1);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_0.x0);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_0.x1);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_0.y0);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_0.y1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(Q1.x0);
    circuit_inputs = circuit_inputs.next(Q1.x1);
    circuit_inputs = circuit_inputs.next(Q1.y0);
    circuit_inputs = circuit_inputs.next(Q1.y1);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_1.x0);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_1.x1);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_1.y0);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_1.y1);
    circuit_inputs = circuit_inputs.next(yInv_2);
    circuit_inputs = circuit_inputs.next(xNegOverY_2);
    circuit_inputs = circuit_inputs.next(Q2.x0);
    circuit_inputs = circuit_inputs.next(Q2.x1);
    circuit_inputs = circuit_inputs.next(Q2.y0);
    circuit_inputs = circuit_inputs.next(Q2.y1);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_2.x0);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_2.x1);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_2.y0);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_2.y1);
    circuit_inputs = circuit_inputs.next(lhs_i);
    circuit_inputs = circuit_inputs.next(f_i_of_z);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w0);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w1);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w2);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w3);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w4);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w5);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w6);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w7);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w8);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w9);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w10);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w11);
    circuit_inputs = circuit_inputs.next(c_or_cinv_of_z);
    circuit_inputs = circuit_inputs.next(z);
    circuit_inputs = circuit_inputs.next(ci);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let Q0: G2Point = G2Point {
        x0: outputs.get_output(t80),
        x1: outputs.get_output(t81),
        y0: outputs.get_output(t90),
        y1: outputs.get_output(t91)
    };

    let Q1: G2Point = G2Point {
        x0: outputs.get_output(t190),
        x1: outputs.get_output(t191),
        y0: outputs.get_output(t200),
        y1: outputs.get_output(t201)
    };

    let Q2: G2Point = G2Point {
        x0: outputs.get_output(t300),
        x1: outputs.get_output(t301),
        y0: outputs.get_output(t310),
        y1: outputs.get_output(t311)
    };

    let f_i_plus_one_of_z: u384 = outputs.get_output(t364);

    let lhs_i_plus_one: u384 = outputs.get_output(t367);

    let ci_plus_one: u384 = outputs.get_output(t10);
    return (Q0, Q1, Q2, f_i_plus_one_of_z, lhs_i_plus_one, ci_plus_one);
}
fn run_BLS12_381_MP_CHECK_FINALIZE_BLS_2_circuit(
    R_n_minus_1: E12D,
    c_n_minus_2: u384,
    w_of_z: u384,
    z: u384,
    c_inv_frob_1_of_z: u384,
    previous_lhs: u384,
    R_n_minus_2_of_z: u384,
    Q: Array<u384>
) -> (u384,) {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0x0
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 0x2
    let in2 = CircuitElement::<CircuitInput<2>> {}; // -0x2 % p

    // INPUT stack
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
    let in9 = CircuitElement::<CircuitInput<9>> {}; // 
    let in10 = CircuitElement::<CircuitInput<10>> {}; // 
    let in11 = CircuitElement::<CircuitInput<11>> {}; // 
    let in12 = CircuitElement::<CircuitInput<12>> {}; // 
    let in13 = CircuitElement::<CircuitInput<13>> {}; // 
    let in14 = CircuitElement::<CircuitInput<14>> {}; // 
    let in15 = CircuitElement::<CircuitInput<15>> {}; // 
    let in16 = CircuitElement::<CircuitInput<16>> {}; // 
    let in17 = CircuitElement::<CircuitInput<17>> {}; // 
    let in18 = CircuitElement::<CircuitInput<18>> {}; // 
    let in19 = CircuitElement::<CircuitInput<19>> {}; // 
    let in20 = CircuitElement::<CircuitInput<20>> {}; // 
    let in21 = CircuitElement::<CircuitInput<21>> {}; // 
    let in22 = CircuitElement::<CircuitInput<22>> {}; // 
    let in23 = CircuitElement::<CircuitInput<23>> {}; // 
    let in24 = CircuitElement::<CircuitInput<24>> {}; // 
    let in25 = CircuitElement::<CircuitInput<25>> {}; // 
    let in26 = CircuitElement::<CircuitInput<26>> {}; // 
    let in27 = CircuitElement::<CircuitInput<27>> {}; // 
    let in28 = CircuitElement::<CircuitInput<28>> {}; // 
    let in29 = CircuitElement::<CircuitInput<29>> {}; // 
    let in30 = CircuitElement::<CircuitInput<30>> {}; // 
    let in31 = CircuitElement::<CircuitInput<31>> {}; // 
    let in32 = CircuitElement::<CircuitInput<32>> {}; // 
    let in33 = CircuitElement::<CircuitInput<33>> {}; // 
    let in34 = CircuitElement::<CircuitInput<34>> {}; // 
    let in35 = CircuitElement::<CircuitInput<35>> {}; // 
    let in36 = CircuitElement::<CircuitInput<36>> {}; // 
    let in37 = CircuitElement::<CircuitInput<37>> {}; // 
    let in38 = CircuitElement::<CircuitInput<38>> {}; // 
    let in39 = CircuitElement::<CircuitInput<39>> {}; // 
    let in40 = CircuitElement::<CircuitInput<40>> {}; // 
    let in41 = CircuitElement::<CircuitInput<41>> {}; // 
    let in42 = CircuitElement::<CircuitInput<42>> {}; // 
    let in43 = CircuitElement::<CircuitInput<43>> {}; // 
    let in44 = CircuitElement::<CircuitInput<44>> {}; // 
    let in45 = CircuitElement::<CircuitInput<45>> {}; // 
    let in46 = CircuitElement::<CircuitInput<46>> {}; // 
    let in47 = CircuitElement::<CircuitInput<47>> {}; // 
    let in48 = CircuitElement::<CircuitInput<48>> {}; // 
    let in49 = CircuitElement::<CircuitInput<49>> {}; // 
    let in50 = CircuitElement::<CircuitInput<50>> {}; // 
    let in51 = CircuitElement::<CircuitInput<51>> {}; // 
    let in52 = CircuitElement::<CircuitInput<52>> {}; // 
    let in53 = CircuitElement::<CircuitInput<53>> {}; // 
    let in54 = CircuitElement::<CircuitInput<54>> {}; // 
    let in55 = CircuitElement::<CircuitInput<55>> {}; // 
    let in56 = CircuitElement::<CircuitInput<56>> {}; // 
    let in57 = CircuitElement::<CircuitInput<57>> {}; // 
    let in58 = CircuitElement::<CircuitInput<58>> {}; // 
    let in59 = CircuitElement::<CircuitInput<59>> {}; // 
    let in60 = CircuitElement::<CircuitInput<60>> {}; // 
    let in61 = CircuitElement::<CircuitInput<61>> {}; // 
    let in62 = CircuitElement::<CircuitInput<62>> {}; // 
    let in63 = CircuitElement::<CircuitInput<63>> {}; // 
    let in64 = CircuitElement::<CircuitInput<64>> {}; // 
    let in65 = CircuitElement::<CircuitInput<65>> {}; // 
    let in66 = CircuitElement::<CircuitInput<66>> {}; // 
    let in67 = CircuitElement::<CircuitInput<67>> {}; // 
    let in68 = CircuitElement::<CircuitInput<68>> {}; // 
    let in69 = CircuitElement::<CircuitInput<69>> {}; // 
    let in70 = CircuitElement::<CircuitInput<70>> {}; // 
    let in71 = CircuitElement::<CircuitInput<71>> {}; // 
    let in72 = CircuitElement::<CircuitInput<72>> {}; // 
    let in73 = CircuitElement::<CircuitInput<73>> {}; // 
    let in74 = CircuitElement::<CircuitInput<74>> {}; // 
    let t0 = circuit_mul(in17, in17); // Compute z^2
    let t1 = circuit_mul(t0, in17); // Compute z^3
    let t2 = circuit_mul(t1, in17); // Compute z^4
    let t3 = circuit_mul(t2, in17); // Compute z^5
    let t4 = circuit_mul(t3, in17); // Compute z^6
    let t5 = circuit_mul(t4, in17); // Compute z^7
    let t6 = circuit_mul(t5, in17); // Compute z^8
    let t7 = circuit_mul(t6, in17); // Compute z^9
    let t8 = circuit_mul(t7, in17); // Compute z^10
    let t9 = circuit_mul(t8, in17); // Compute z^11
    let t10 = circuit_mul(t9, in17); // Compute z^12
    let t11 = circuit_mul(t10, in17); // Compute z^13
    let t12 = circuit_mul(t11, in17); // Compute z^14
    let t13 = circuit_mul(t12, in17); // Compute z^15
    let t14 = circuit_mul(t13, in17); // Compute z^16
    let t15 = circuit_mul(t14, in17); // Compute z^17
    let t16 = circuit_mul(t15, in17); // Compute z^18
    let t17 = circuit_mul(t16, in17); // Compute z^19
    let t18 = circuit_mul(t17, in17); // Compute z^20
    let t19 = circuit_mul(t18, in17); // Compute z^21
    let t20 = circuit_mul(t19, in17); // Compute z^22
    let t21 = circuit_mul(t20, in17); // Compute z^23
    let t22 = circuit_mul(t21, in17); // Compute z^24
    let t23 = circuit_mul(t22, in17); // Compute z^25
    let t24 = circuit_mul(t23, in17); // Compute z^26
    let t25 = circuit_mul(t24, in17); // Compute z^27
    let t26 = circuit_mul(t25, in17); // Compute z^28
    let t27 = circuit_mul(t26, in17); // Compute z^29
    let t28 = circuit_mul(t27, in17); // Compute z^30
    let t29 = circuit_mul(t28, in17); // Compute z^31
    let t30 = circuit_mul(t29, in17); // Compute z^32
    let t31 = circuit_mul(t30, in17); // Compute z^33
    let t32 = circuit_mul(t31, in17); // Compute z^34
    let t33 = circuit_mul(t32, in17); // Compute z^35
    let t34 = circuit_mul(t33, in17); // Compute z^36
    let t35 = circuit_mul(t34, in17); // Compute z^37
    let t36 = circuit_mul(t35, in17); // Compute z^38
    let t37 = circuit_mul(t36, in17); // Compute z^39
    let t38 = circuit_mul(t37, in17); // Compute z^40
    let t39 = circuit_mul(t38, in17); // Compute z^41
    let t40 = circuit_mul(t39, in17); // Compute z^42
    let t41 = circuit_mul(t40, in17); // Compute z^43
    let t42 = circuit_mul(t41, in17); // Compute z^44
    let t43 = circuit_mul(t42, in17); // Compute z^45
    let t44 = circuit_mul(t43, in17); // Compute z^46
    let t45 = circuit_mul(t44, in17); // Compute z^47
    let t46 = circuit_mul(t45, in17); // Compute z^48
    let t47 = circuit_mul(t46, in17); // Compute z^49
    let t48 = circuit_mul(t47, in17); // Compute z^50
    let t49 = circuit_mul(t48, in17); // Compute z^51
    let t50 = circuit_mul(t49, in17); // Compute z^52
    let t51 = circuit_mul(t50, in17); // Compute z^53
    let t52 = circuit_mul(in15, in15);
    let t53 = circuit_mul(in4, in17); // Eval UnnamedPoly step coeff_1 * z^1
    let t54 = circuit_add(in3, t53); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t55 = circuit_mul(in5, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t56 = circuit_add(t54, t55); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t57 = circuit_mul(in6, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t58 = circuit_add(t56, t57); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t59 = circuit_mul(in7, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t60 = circuit_add(t58, t59); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t61 = circuit_mul(in8, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t62 = circuit_add(t60, t61); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t63 = circuit_mul(in9, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t64 = circuit_add(t62, t63); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t65 = circuit_mul(in10, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t66 = circuit_add(t64, t65); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t67 = circuit_mul(in11, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t68 = circuit_add(t66, t67); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t69 = circuit_mul(in12, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t70 = circuit_add(t68, t69); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t71 = circuit_mul(in13, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t72 = circuit_add(t70, t71); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t73 = circuit_mul(in14, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t74 = circuit_add(t72, t73); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t75 = circuit_mul(in20, in18);
    let t76 = circuit_mul(t75, in16);
    let t77 = circuit_sub(t76, t74);
    let t78 = circuit_mul(t52, t77); // c_n_minus_1 * ((Π(n-1,k) (Pk(z)) - R_n_minus_1(z))
    let t79 = circuit_add(in19, t78);
    let t80 = circuit_mul(in2, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t81 = circuit_add(in1, t80); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t82 = circuit_add(t81, t10); // Eval sparse poly UnnamedPoly step + 1*z^12
    let t83 = circuit_mul(in22, in17); // Eval UnnamedPoly step coeff_1 * z^1
    let t84 = circuit_add(in21, t83); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t85 = circuit_mul(in23, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t86 = circuit_add(t84, t85); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t87 = circuit_mul(in24, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t88 = circuit_add(t86, t87); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t89 = circuit_mul(in25, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t90 = circuit_add(t88, t89); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t91 = circuit_mul(in26, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t92 = circuit_add(t90, t91); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t93 = circuit_mul(in27, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t94 = circuit_add(t92, t93); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t95 = circuit_mul(in28, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t96 = circuit_add(t94, t95); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t97 = circuit_mul(in29, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t98 = circuit_add(t96, t97); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t99 = circuit_mul(in30, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t100 = circuit_add(t98, t99); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t101 = circuit_mul(in31, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t102 = circuit_add(t100, t101); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t103 = circuit_mul(in32, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t104 = circuit_add(t102, t103); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t105 = circuit_mul(in33, t10); // Eval UnnamedPoly step coeff_12 * z^12
    let t106 = circuit_add(t104, t105); // Eval UnnamedPoly step + (coeff_12 * z^12)
    let t107 = circuit_mul(in34, t11); // Eval UnnamedPoly step coeff_13 * z^13
    let t108 = circuit_add(t106, t107); // Eval UnnamedPoly step + (coeff_13 * z^13)
    let t109 = circuit_mul(in35, t12); // Eval UnnamedPoly step coeff_14 * z^14
    let t110 = circuit_add(t108, t109); // Eval UnnamedPoly step + (coeff_14 * z^14)
    let t111 = circuit_mul(in36, t13); // Eval UnnamedPoly step coeff_15 * z^15
    let t112 = circuit_add(t110, t111); // Eval UnnamedPoly step + (coeff_15 * z^15)
    let t113 = circuit_mul(in37, t14); // Eval UnnamedPoly step coeff_16 * z^16
    let t114 = circuit_add(t112, t113); // Eval UnnamedPoly step + (coeff_16 * z^16)
    let t115 = circuit_mul(in38, t15); // Eval UnnamedPoly step coeff_17 * z^17
    let t116 = circuit_add(t114, t115); // Eval UnnamedPoly step + (coeff_17 * z^17)
    let t117 = circuit_mul(in39, t16); // Eval UnnamedPoly step coeff_18 * z^18
    let t118 = circuit_add(t116, t117); // Eval UnnamedPoly step + (coeff_18 * z^18)
    let t119 = circuit_mul(in40, t17); // Eval UnnamedPoly step coeff_19 * z^19
    let t120 = circuit_add(t118, t119); // Eval UnnamedPoly step + (coeff_19 * z^19)
    let t121 = circuit_mul(in41, t18); // Eval UnnamedPoly step coeff_20 * z^20
    let t122 = circuit_add(t120, t121); // Eval UnnamedPoly step + (coeff_20 * z^20)
    let t123 = circuit_mul(in42, t19); // Eval UnnamedPoly step coeff_21 * z^21
    let t124 = circuit_add(t122, t123); // Eval UnnamedPoly step + (coeff_21 * z^21)
    let t125 = circuit_mul(in43, t20); // Eval UnnamedPoly step coeff_22 * z^22
    let t126 = circuit_add(t124, t125); // Eval UnnamedPoly step + (coeff_22 * z^22)
    let t127 = circuit_mul(in44, t21); // Eval UnnamedPoly step coeff_23 * z^23
    let t128 = circuit_add(t126, t127); // Eval UnnamedPoly step + (coeff_23 * z^23)
    let t129 = circuit_mul(in45, t22); // Eval UnnamedPoly step coeff_24 * z^24
    let t130 = circuit_add(t128, t129); // Eval UnnamedPoly step + (coeff_24 * z^24)
    let t131 = circuit_mul(in46, t23); // Eval UnnamedPoly step coeff_25 * z^25
    let t132 = circuit_add(t130, t131); // Eval UnnamedPoly step + (coeff_25 * z^25)
    let t133 = circuit_mul(in47, t24); // Eval UnnamedPoly step coeff_26 * z^26
    let t134 = circuit_add(t132, t133); // Eval UnnamedPoly step + (coeff_26 * z^26)
    let t135 = circuit_mul(in48, t25); // Eval UnnamedPoly step coeff_27 * z^27
    let t136 = circuit_add(t134, t135); // Eval UnnamedPoly step + (coeff_27 * z^27)
    let t137 = circuit_mul(in49, t26); // Eval UnnamedPoly step coeff_28 * z^28
    let t138 = circuit_add(t136, t137); // Eval UnnamedPoly step + (coeff_28 * z^28)
    let t139 = circuit_mul(in50, t27); // Eval UnnamedPoly step coeff_29 * z^29
    let t140 = circuit_add(t138, t139); // Eval UnnamedPoly step + (coeff_29 * z^29)
    let t141 = circuit_mul(in51, t28); // Eval UnnamedPoly step coeff_30 * z^30
    let t142 = circuit_add(t140, t141); // Eval UnnamedPoly step + (coeff_30 * z^30)
    let t143 = circuit_mul(in52, t29); // Eval UnnamedPoly step coeff_31 * z^31
    let t144 = circuit_add(t142, t143); // Eval UnnamedPoly step + (coeff_31 * z^31)
    let t145 = circuit_mul(in53, t30); // Eval UnnamedPoly step coeff_32 * z^32
    let t146 = circuit_add(t144, t145); // Eval UnnamedPoly step + (coeff_32 * z^32)
    let t147 = circuit_mul(in54, t31); // Eval UnnamedPoly step coeff_33 * z^33
    let t148 = circuit_add(t146, t147); // Eval UnnamedPoly step + (coeff_33 * z^33)
    let t149 = circuit_mul(in55, t32); // Eval UnnamedPoly step coeff_34 * z^34
    let t150 = circuit_add(t148, t149); // Eval UnnamedPoly step + (coeff_34 * z^34)
    let t151 = circuit_mul(in56, t33); // Eval UnnamedPoly step coeff_35 * z^35
    let t152 = circuit_add(t150, t151); // Eval UnnamedPoly step + (coeff_35 * z^35)
    let t153 = circuit_mul(in57, t34); // Eval UnnamedPoly step coeff_36 * z^36
    let t154 = circuit_add(t152, t153); // Eval UnnamedPoly step + (coeff_36 * z^36)
    let t155 = circuit_mul(in58, t35); // Eval UnnamedPoly step coeff_37 * z^37
    let t156 = circuit_add(t154, t155); // Eval UnnamedPoly step + (coeff_37 * z^37)
    let t157 = circuit_mul(in59, t36); // Eval UnnamedPoly step coeff_38 * z^38
    let t158 = circuit_add(t156, t157); // Eval UnnamedPoly step + (coeff_38 * z^38)
    let t159 = circuit_mul(in60, t37); // Eval UnnamedPoly step coeff_39 * z^39
    let t160 = circuit_add(t158, t159); // Eval UnnamedPoly step + (coeff_39 * z^39)
    let t161 = circuit_mul(in61, t38); // Eval UnnamedPoly step coeff_40 * z^40
    let t162 = circuit_add(t160, t161); // Eval UnnamedPoly step + (coeff_40 * z^40)
    let t163 = circuit_mul(in62, t39); // Eval UnnamedPoly step coeff_41 * z^41
    let t164 = circuit_add(t162, t163); // Eval UnnamedPoly step + (coeff_41 * z^41)
    let t165 = circuit_mul(in63, t40); // Eval UnnamedPoly step coeff_42 * z^42
    let t166 = circuit_add(t164, t165); // Eval UnnamedPoly step + (coeff_42 * z^42)
    let t167 = circuit_mul(in64, t41); // Eval UnnamedPoly step coeff_43 * z^43
    let t168 = circuit_add(t166, t167); // Eval UnnamedPoly step + (coeff_43 * z^43)
    let t169 = circuit_mul(in65, t42); // Eval UnnamedPoly step coeff_44 * z^44
    let t170 = circuit_add(t168, t169); // Eval UnnamedPoly step + (coeff_44 * z^44)
    let t171 = circuit_mul(in66, t43); // Eval UnnamedPoly step coeff_45 * z^45
    let t172 = circuit_add(t170, t171); // Eval UnnamedPoly step + (coeff_45 * z^45)
    let t173 = circuit_mul(in67, t44); // Eval UnnamedPoly step coeff_46 * z^46
    let t174 = circuit_add(t172, t173); // Eval UnnamedPoly step + (coeff_46 * z^46)
    let t175 = circuit_mul(in68, t45); // Eval UnnamedPoly step coeff_47 * z^47
    let t176 = circuit_add(t174, t175); // Eval UnnamedPoly step + (coeff_47 * z^47)
    let t177 = circuit_mul(in69, t46); // Eval UnnamedPoly step coeff_48 * z^48
    let t178 = circuit_add(t176, t177); // Eval UnnamedPoly step + (coeff_48 * z^48)
    let t179 = circuit_mul(in70, t47); // Eval UnnamedPoly step coeff_49 * z^49
    let t180 = circuit_add(t178, t179); // Eval UnnamedPoly step + (coeff_49 * z^49)
    let t181 = circuit_mul(in71, t48); // Eval UnnamedPoly step coeff_50 * z^50
    let t182 = circuit_add(t180, t181); // Eval UnnamedPoly step + (coeff_50 * z^50)
    let t183 = circuit_mul(in72, t49); // Eval UnnamedPoly step coeff_51 * z^51
    let t184 = circuit_add(t182, t183); // Eval UnnamedPoly step + (coeff_51 * z^51)
    let t185 = circuit_mul(in73, t50); // Eval UnnamedPoly step coeff_52 * z^52
    let t186 = circuit_add(t184, t185); // Eval UnnamedPoly step + (coeff_52 * z^52)
    let t187 = circuit_mul(in74, t51); // Eval UnnamedPoly step coeff_53 * z^53
    let t188 = circuit_add(t186, t187); // Eval UnnamedPoly step + (coeff_53 * z^53)
    let t189 = circuit_mul(t188, t82);
    let t190 = circuit_sub(t79, t189);

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [
            54880396502181392957329877675,
            31935979117156477062286671870,
            20826981314825584179608359615,
            8047903782086192180586325942
        ]
    )
        .unwrap();

    let mut circuit_inputs = (t190,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x2, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs
        .next(
            [
                0xb153ffffb9feffffffffaaa9,
                0x6730d2a0f6b0f6241eabfffe,
                0x434bacd764774b84f38512bf,
                0x1a0111ea397fe69a4b1ba7b6
            ]
        );
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w0);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w1);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w2);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w3);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w4);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w5);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w6);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w7);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w8);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w9);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w10);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w11);
    circuit_inputs = circuit_inputs.next(c_n_minus_2);
    circuit_inputs = circuit_inputs.next(w_of_z);
    circuit_inputs = circuit_inputs.next(z);
    circuit_inputs = circuit_inputs.next(c_inv_frob_1_of_z);
    circuit_inputs = circuit_inputs.next(previous_lhs);
    circuit_inputs = circuit_inputs.next(R_n_minus_2_of_z);

    let mut Q = Q;
    while let Option::Some(val) = Q.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let final_check: u384 = outputs.get_output(t190);
    return (final_check,);
}
fn run_BLS12_381_MP_CHECK_FINALIZE_BLS_3_circuit(
    R_n_minus_1: E12D,
    c_n_minus_2: u384,
    w_of_z: u384,
    z: u384,
    c_inv_frob_1_of_z: u384,
    previous_lhs: u384,
    R_n_minus_2_of_z: u384,
    Q: Array<u384>
) -> (u384,) {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0x0
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 0x2
    let in2 = CircuitElement::<CircuitInput<2>> {}; // -0x2 % p

    // INPUT stack
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
    let in9 = CircuitElement::<CircuitInput<9>> {}; // 
    let in10 = CircuitElement::<CircuitInput<10>> {}; // 
    let in11 = CircuitElement::<CircuitInput<11>> {}; // 
    let in12 = CircuitElement::<CircuitInput<12>> {}; // 
    let in13 = CircuitElement::<CircuitInput<13>> {}; // 
    let in14 = CircuitElement::<CircuitInput<14>> {}; // 
    let in15 = CircuitElement::<CircuitInput<15>> {}; // 
    let in16 = CircuitElement::<CircuitInput<16>> {}; // 
    let in17 = CircuitElement::<CircuitInput<17>> {}; // 
    let in18 = CircuitElement::<CircuitInput<18>> {}; // 
    let in19 = CircuitElement::<CircuitInput<19>> {}; // 
    let in20 = CircuitElement::<CircuitInput<20>> {}; // 
    let in21 = CircuitElement::<CircuitInput<21>> {}; // 
    let in22 = CircuitElement::<CircuitInput<22>> {}; // 
    let in23 = CircuitElement::<CircuitInput<23>> {}; // 
    let in24 = CircuitElement::<CircuitInput<24>> {}; // 
    let in25 = CircuitElement::<CircuitInput<25>> {}; // 
    let in26 = CircuitElement::<CircuitInput<26>> {}; // 
    let in27 = CircuitElement::<CircuitInput<27>> {}; // 
    let in28 = CircuitElement::<CircuitInput<28>> {}; // 
    let in29 = CircuitElement::<CircuitInput<29>> {}; // 
    let in30 = CircuitElement::<CircuitInput<30>> {}; // 
    let in31 = CircuitElement::<CircuitInput<31>> {}; // 
    let in32 = CircuitElement::<CircuitInput<32>> {}; // 
    let in33 = CircuitElement::<CircuitInput<33>> {}; // 
    let in34 = CircuitElement::<CircuitInput<34>> {}; // 
    let in35 = CircuitElement::<CircuitInput<35>> {}; // 
    let in36 = CircuitElement::<CircuitInput<36>> {}; // 
    let in37 = CircuitElement::<CircuitInput<37>> {}; // 
    let in38 = CircuitElement::<CircuitInput<38>> {}; // 
    let in39 = CircuitElement::<CircuitInput<39>> {}; // 
    let in40 = CircuitElement::<CircuitInput<40>> {}; // 
    let in41 = CircuitElement::<CircuitInput<41>> {}; // 
    let in42 = CircuitElement::<CircuitInput<42>> {}; // 
    let in43 = CircuitElement::<CircuitInput<43>> {}; // 
    let in44 = CircuitElement::<CircuitInput<44>> {}; // 
    let in45 = CircuitElement::<CircuitInput<45>> {}; // 
    let in46 = CircuitElement::<CircuitInput<46>> {}; // 
    let in47 = CircuitElement::<CircuitInput<47>> {}; // 
    let in48 = CircuitElement::<CircuitInput<48>> {}; // 
    let in49 = CircuitElement::<CircuitInput<49>> {}; // 
    let in50 = CircuitElement::<CircuitInput<50>> {}; // 
    let in51 = CircuitElement::<CircuitInput<51>> {}; // 
    let in52 = CircuitElement::<CircuitInput<52>> {}; // 
    let in53 = CircuitElement::<CircuitInput<53>> {}; // 
    let in54 = CircuitElement::<CircuitInput<54>> {}; // 
    let in55 = CircuitElement::<CircuitInput<55>> {}; // 
    let in56 = CircuitElement::<CircuitInput<56>> {}; // 
    let in57 = CircuitElement::<CircuitInput<57>> {}; // 
    let in58 = CircuitElement::<CircuitInput<58>> {}; // 
    let in59 = CircuitElement::<CircuitInput<59>> {}; // 
    let in60 = CircuitElement::<CircuitInput<60>> {}; // 
    let in61 = CircuitElement::<CircuitInput<61>> {}; // 
    let in62 = CircuitElement::<CircuitInput<62>> {}; // 
    let in63 = CircuitElement::<CircuitInput<63>> {}; // 
    let in64 = CircuitElement::<CircuitInput<64>> {}; // 
    let in65 = CircuitElement::<CircuitInput<65>> {}; // 
    let in66 = CircuitElement::<CircuitInput<66>> {}; // 
    let in67 = CircuitElement::<CircuitInput<67>> {}; // 
    let in68 = CircuitElement::<CircuitInput<68>> {}; // 
    let in69 = CircuitElement::<CircuitInput<69>> {}; // 
    let in70 = CircuitElement::<CircuitInput<70>> {}; // 
    let in71 = CircuitElement::<CircuitInput<71>> {}; // 
    let in72 = CircuitElement::<CircuitInput<72>> {}; // 
    let in73 = CircuitElement::<CircuitInput<73>> {}; // 
    let in74 = CircuitElement::<CircuitInput<74>> {}; // 
    let in75 = CircuitElement::<CircuitInput<75>> {}; // 
    let in76 = CircuitElement::<CircuitInput<76>> {}; // 
    let in77 = CircuitElement::<CircuitInput<77>> {}; // 
    let in78 = CircuitElement::<CircuitInput<78>> {}; // 
    let in79 = CircuitElement::<CircuitInput<79>> {}; // 
    let in80 = CircuitElement::<CircuitInput<80>> {}; // 
    let in81 = CircuitElement::<CircuitInput<81>> {}; // 
    let in82 = CircuitElement::<CircuitInput<82>> {}; // 
    let in83 = CircuitElement::<CircuitInput<83>> {}; // 
    let in84 = CircuitElement::<CircuitInput<84>> {}; // 
    let in85 = CircuitElement::<CircuitInput<85>> {}; // 
    let in86 = CircuitElement::<CircuitInput<86>> {}; // 
    let in87 = CircuitElement::<CircuitInput<87>> {}; // 
    let in88 = CircuitElement::<CircuitInput<88>> {}; // 
    let in89 = CircuitElement::<CircuitInput<89>> {}; // 
    let in90 = CircuitElement::<CircuitInput<90>> {}; // 
    let t0 = circuit_mul(in17, in17); // Compute z^2
    let t1 = circuit_mul(t0, in17); // Compute z^3
    let t2 = circuit_mul(t1, in17); // Compute z^4
    let t3 = circuit_mul(t2, in17); // Compute z^5
    let t4 = circuit_mul(t3, in17); // Compute z^6
    let t5 = circuit_mul(t4, in17); // Compute z^7
    let t6 = circuit_mul(t5, in17); // Compute z^8
    let t7 = circuit_mul(t6, in17); // Compute z^9
    let t8 = circuit_mul(t7, in17); // Compute z^10
    let t9 = circuit_mul(t8, in17); // Compute z^11
    let t10 = circuit_mul(t9, in17); // Compute z^12
    let t11 = circuit_mul(t10, in17); // Compute z^13
    let t12 = circuit_mul(t11, in17); // Compute z^14
    let t13 = circuit_mul(t12, in17); // Compute z^15
    let t14 = circuit_mul(t13, in17); // Compute z^16
    let t15 = circuit_mul(t14, in17); // Compute z^17
    let t16 = circuit_mul(t15, in17); // Compute z^18
    let t17 = circuit_mul(t16, in17); // Compute z^19
    let t18 = circuit_mul(t17, in17); // Compute z^20
    let t19 = circuit_mul(t18, in17); // Compute z^21
    let t20 = circuit_mul(t19, in17); // Compute z^22
    let t21 = circuit_mul(t20, in17); // Compute z^23
    let t22 = circuit_mul(t21, in17); // Compute z^24
    let t23 = circuit_mul(t22, in17); // Compute z^25
    let t24 = circuit_mul(t23, in17); // Compute z^26
    let t25 = circuit_mul(t24, in17); // Compute z^27
    let t26 = circuit_mul(t25, in17); // Compute z^28
    let t27 = circuit_mul(t26, in17); // Compute z^29
    let t28 = circuit_mul(t27, in17); // Compute z^30
    let t29 = circuit_mul(t28, in17); // Compute z^31
    let t30 = circuit_mul(t29, in17); // Compute z^32
    let t31 = circuit_mul(t30, in17); // Compute z^33
    let t32 = circuit_mul(t31, in17); // Compute z^34
    let t33 = circuit_mul(t32, in17); // Compute z^35
    let t34 = circuit_mul(t33, in17); // Compute z^36
    let t35 = circuit_mul(t34, in17); // Compute z^37
    let t36 = circuit_mul(t35, in17); // Compute z^38
    let t37 = circuit_mul(t36, in17); // Compute z^39
    let t38 = circuit_mul(t37, in17); // Compute z^40
    let t39 = circuit_mul(t38, in17); // Compute z^41
    let t40 = circuit_mul(t39, in17); // Compute z^42
    let t41 = circuit_mul(t40, in17); // Compute z^43
    let t42 = circuit_mul(t41, in17); // Compute z^44
    let t43 = circuit_mul(t42, in17); // Compute z^45
    let t44 = circuit_mul(t43, in17); // Compute z^46
    let t45 = circuit_mul(t44, in17); // Compute z^47
    let t46 = circuit_mul(t45, in17); // Compute z^48
    let t47 = circuit_mul(t46, in17); // Compute z^49
    let t48 = circuit_mul(t47, in17); // Compute z^50
    let t49 = circuit_mul(t48, in17); // Compute z^51
    let t50 = circuit_mul(t49, in17); // Compute z^52
    let t51 = circuit_mul(t50, in17); // Compute z^53
    let t52 = circuit_mul(t51, in17); // Compute z^54
    let t53 = circuit_mul(t52, in17); // Compute z^55
    let t54 = circuit_mul(t53, in17); // Compute z^56
    let t55 = circuit_mul(t54, in17); // Compute z^57
    let t56 = circuit_mul(t55, in17); // Compute z^58
    let t57 = circuit_mul(t56, in17); // Compute z^59
    let t58 = circuit_mul(t57, in17); // Compute z^60
    let t59 = circuit_mul(t58, in17); // Compute z^61
    let t60 = circuit_mul(t59, in17); // Compute z^62
    let t61 = circuit_mul(t60, in17); // Compute z^63
    let t62 = circuit_mul(t61, in17); // Compute z^64
    let t63 = circuit_mul(t62, in17); // Compute z^65
    let t64 = circuit_mul(t63, in17); // Compute z^66
    let t65 = circuit_mul(t64, in17); // Compute z^67
    let t66 = circuit_mul(t65, in17); // Compute z^68
    let t67 = circuit_mul(t66, in17); // Compute z^69
    let t68 = circuit_mul(in15, in15);
    let t69 = circuit_mul(in4, in17); // Eval UnnamedPoly step coeff_1 * z^1
    let t70 = circuit_add(in3, t69); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t71 = circuit_mul(in5, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t72 = circuit_add(t70, t71); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t73 = circuit_mul(in6, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t74 = circuit_add(t72, t73); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t75 = circuit_mul(in7, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t76 = circuit_add(t74, t75); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t77 = circuit_mul(in8, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t78 = circuit_add(t76, t77); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t79 = circuit_mul(in9, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t80 = circuit_add(t78, t79); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t81 = circuit_mul(in10, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t82 = circuit_add(t80, t81); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t83 = circuit_mul(in11, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t84 = circuit_add(t82, t83); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t85 = circuit_mul(in12, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t86 = circuit_add(t84, t85); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t87 = circuit_mul(in13, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t88 = circuit_add(t86, t87); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t89 = circuit_mul(in14, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t90 = circuit_add(t88, t89); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t91 = circuit_mul(in20, in18);
    let t92 = circuit_mul(t91, in16);
    let t93 = circuit_sub(t92, t90);
    let t94 = circuit_mul(t68, t93); // c_n_minus_1 * ((Π(n-1,k) (Pk(z)) - R_n_minus_1(z))
    let t95 = circuit_add(in19, t94);
    let t96 = circuit_mul(in2, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t97 = circuit_add(in1, t96); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t98 = circuit_add(t97, t10); // Eval sparse poly UnnamedPoly step + 1*z^12
    let t99 = circuit_mul(in22, in17); // Eval UnnamedPoly step coeff_1 * z^1
    let t100 = circuit_add(in21, t99); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t101 = circuit_mul(in23, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t102 = circuit_add(t100, t101); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t103 = circuit_mul(in24, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t104 = circuit_add(t102, t103); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t105 = circuit_mul(in25, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t106 = circuit_add(t104, t105); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t107 = circuit_mul(in26, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t108 = circuit_add(t106, t107); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t109 = circuit_mul(in27, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t110 = circuit_add(t108, t109); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t111 = circuit_mul(in28, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t112 = circuit_add(t110, t111); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t113 = circuit_mul(in29, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t114 = circuit_add(t112, t113); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t115 = circuit_mul(in30, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t116 = circuit_add(t114, t115); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t117 = circuit_mul(in31, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t118 = circuit_add(t116, t117); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t119 = circuit_mul(in32, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t120 = circuit_add(t118, t119); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t121 = circuit_mul(in33, t10); // Eval UnnamedPoly step coeff_12 * z^12
    let t122 = circuit_add(t120, t121); // Eval UnnamedPoly step + (coeff_12 * z^12)
    let t123 = circuit_mul(in34, t11); // Eval UnnamedPoly step coeff_13 * z^13
    let t124 = circuit_add(t122, t123); // Eval UnnamedPoly step + (coeff_13 * z^13)
    let t125 = circuit_mul(in35, t12); // Eval UnnamedPoly step coeff_14 * z^14
    let t126 = circuit_add(t124, t125); // Eval UnnamedPoly step + (coeff_14 * z^14)
    let t127 = circuit_mul(in36, t13); // Eval UnnamedPoly step coeff_15 * z^15
    let t128 = circuit_add(t126, t127); // Eval UnnamedPoly step + (coeff_15 * z^15)
    let t129 = circuit_mul(in37, t14); // Eval UnnamedPoly step coeff_16 * z^16
    let t130 = circuit_add(t128, t129); // Eval UnnamedPoly step + (coeff_16 * z^16)
    let t131 = circuit_mul(in38, t15); // Eval UnnamedPoly step coeff_17 * z^17
    let t132 = circuit_add(t130, t131); // Eval UnnamedPoly step + (coeff_17 * z^17)
    let t133 = circuit_mul(in39, t16); // Eval UnnamedPoly step coeff_18 * z^18
    let t134 = circuit_add(t132, t133); // Eval UnnamedPoly step + (coeff_18 * z^18)
    let t135 = circuit_mul(in40, t17); // Eval UnnamedPoly step coeff_19 * z^19
    let t136 = circuit_add(t134, t135); // Eval UnnamedPoly step + (coeff_19 * z^19)
    let t137 = circuit_mul(in41, t18); // Eval UnnamedPoly step coeff_20 * z^20
    let t138 = circuit_add(t136, t137); // Eval UnnamedPoly step + (coeff_20 * z^20)
    let t139 = circuit_mul(in42, t19); // Eval UnnamedPoly step coeff_21 * z^21
    let t140 = circuit_add(t138, t139); // Eval UnnamedPoly step + (coeff_21 * z^21)
    let t141 = circuit_mul(in43, t20); // Eval UnnamedPoly step coeff_22 * z^22
    let t142 = circuit_add(t140, t141); // Eval UnnamedPoly step + (coeff_22 * z^22)
    let t143 = circuit_mul(in44, t21); // Eval UnnamedPoly step coeff_23 * z^23
    let t144 = circuit_add(t142, t143); // Eval UnnamedPoly step + (coeff_23 * z^23)
    let t145 = circuit_mul(in45, t22); // Eval UnnamedPoly step coeff_24 * z^24
    let t146 = circuit_add(t144, t145); // Eval UnnamedPoly step + (coeff_24 * z^24)
    let t147 = circuit_mul(in46, t23); // Eval UnnamedPoly step coeff_25 * z^25
    let t148 = circuit_add(t146, t147); // Eval UnnamedPoly step + (coeff_25 * z^25)
    let t149 = circuit_mul(in47, t24); // Eval UnnamedPoly step coeff_26 * z^26
    let t150 = circuit_add(t148, t149); // Eval UnnamedPoly step + (coeff_26 * z^26)
    let t151 = circuit_mul(in48, t25); // Eval UnnamedPoly step coeff_27 * z^27
    let t152 = circuit_add(t150, t151); // Eval UnnamedPoly step + (coeff_27 * z^27)
    let t153 = circuit_mul(in49, t26); // Eval UnnamedPoly step coeff_28 * z^28
    let t154 = circuit_add(t152, t153); // Eval UnnamedPoly step + (coeff_28 * z^28)
    let t155 = circuit_mul(in50, t27); // Eval UnnamedPoly step coeff_29 * z^29
    let t156 = circuit_add(t154, t155); // Eval UnnamedPoly step + (coeff_29 * z^29)
    let t157 = circuit_mul(in51, t28); // Eval UnnamedPoly step coeff_30 * z^30
    let t158 = circuit_add(t156, t157); // Eval UnnamedPoly step + (coeff_30 * z^30)
    let t159 = circuit_mul(in52, t29); // Eval UnnamedPoly step coeff_31 * z^31
    let t160 = circuit_add(t158, t159); // Eval UnnamedPoly step + (coeff_31 * z^31)
    let t161 = circuit_mul(in53, t30); // Eval UnnamedPoly step coeff_32 * z^32
    let t162 = circuit_add(t160, t161); // Eval UnnamedPoly step + (coeff_32 * z^32)
    let t163 = circuit_mul(in54, t31); // Eval UnnamedPoly step coeff_33 * z^33
    let t164 = circuit_add(t162, t163); // Eval UnnamedPoly step + (coeff_33 * z^33)
    let t165 = circuit_mul(in55, t32); // Eval UnnamedPoly step coeff_34 * z^34
    let t166 = circuit_add(t164, t165); // Eval UnnamedPoly step + (coeff_34 * z^34)
    let t167 = circuit_mul(in56, t33); // Eval UnnamedPoly step coeff_35 * z^35
    let t168 = circuit_add(t166, t167); // Eval UnnamedPoly step + (coeff_35 * z^35)
    let t169 = circuit_mul(in57, t34); // Eval UnnamedPoly step coeff_36 * z^36
    let t170 = circuit_add(t168, t169); // Eval UnnamedPoly step + (coeff_36 * z^36)
    let t171 = circuit_mul(in58, t35); // Eval UnnamedPoly step coeff_37 * z^37
    let t172 = circuit_add(t170, t171); // Eval UnnamedPoly step + (coeff_37 * z^37)
    let t173 = circuit_mul(in59, t36); // Eval UnnamedPoly step coeff_38 * z^38
    let t174 = circuit_add(t172, t173); // Eval UnnamedPoly step + (coeff_38 * z^38)
    let t175 = circuit_mul(in60, t37); // Eval UnnamedPoly step coeff_39 * z^39
    let t176 = circuit_add(t174, t175); // Eval UnnamedPoly step + (coeff_39 * z^39)
    let t177 = circuit_mul(in61, t38); // Eval UnnamedPoly step coeff_40 * z^40
    let t178 = circuit_add(t176, t177); // Eval UnnamedPoly step + (coeff_40 * z^40)
    let t179 = circuit_mul(in62, t39); // Eval UnnamedPoly step coeff_41 * z^41
    let t180 = circuit_add(t178, t179); // Eval UnnamedPoly step + (coeff_41 * z^41)
    let t181 = circuit_mul(in63, t40); // Eval UnnamedPoly step coeff_42 * z^42
    let t182 = circuit_add(t180, t181); // Eval UnnamedPoly step + (coeff_42 * z^42)
    let t183 = circuit_mul(in64, t41); // Eval UnnamedPoly step coeff_43 * z^43
    let t184 = circuit_add(t182, t183); // Eval UnnamedPoly step + (coeff_43 * z^43)
    let t185 = circuit_mul(in65, t42); // Eval UnnamedPoly step coeff_44 * z^44
    let t186 = circuit_add(t184, t185); // Eval UnnamedPoly step + (coeff_44 * z^44)
    let t187 = circuit_mul(in66, t43); // Eval UnnamedPoly step coeff_45 * z^45
    let t188 = circuit_add(t186, t187); // Eval UnnamedPoly step + (coeff_45 * z^45)
    let t189 = circuit_mul(in67, t44); // Eval UnnamedPoly step coeff_46 * z^46
    let t190 = circuit_add(t188, t189); // Eval UnnamedPoly step + (coeff_46 * z^46)
    let t191 = circuit_mul(in68, t45); // Eval UnnamedPoly step coeff_47 * z^47
    let t192 = circuit_add(t190, t191); // Eval UnnamedPoly step + (coeff_47 * z^47)
    let t193 = circuit_mul(in69, t46); // Eval UnnamedPoly step coeff_48 * z^48
    let t194 = circuit_add(t192, t193); // Eval UnnamedPoly step + (coeff_48 * z^48)
    let t195 = circuit_mul(in70, t47); // Eval UnnamedPoly step coeff_49 * z^49
    let t196 = circuit_add(t194, t195); // Eval UnnamedPoly step + (coeff_49 * z^49)
    let t197 = circuit_mul(in71, t48); // Eval UnnamedPoly step coeff_50 * z^50
    let t198 = circuit_add(t196, t197); // Eval UnnamedPoly step + (coeff_50 * z^50)
    let t199 = circuit_mul(in72, t49); // Eval UnnamedPoly step coeff_51 * z^51
    let t200 = circuit_add(t198, t199); // Eval UnnamedPoly step + (coeff_51 * z^51)
    let t201 = circuit_mul(in73, t50); // Eval UnnamedPoly step coeff_52 * z^52
    let t202 = circuit_add(t200, t201); // Eval UnnamedPoly step + (coeff_52 * z^52)
    let t203 = circuit_mul(in74, t51); // Eval UnnamedPoly step coeff_53 * z^53
    let t204 = circuit_add(t202, t203); // Eval UnnamedPoly step + (coeff_53 * z^53)
    let t205 = circuit_mul(in75, t52); // Eval UnnamedPoly step coeff_54 * z^54
    let t206 = circuit_add(t204, t205); // Eval UnnamedPoly step + (coeff_54 * z^54)
    let t207 = circuit_mul(in76, t53); // Eval UnnamedPoly step coeff_55 * z^55
    let t208 = circuit_add(t206, t207); // Eval UnnamedPoly step + (coeff_55 * z^55)
    let t209 = circuit_mul(in77, t54); // Eval UnnamedPoly step coeff_56 * z^56
    let t210 = circuit_add(t208, t209); // Eval UnnamedPoly step + (coeff_56 * z^56)
    let t211 = circuit_mul(in78, t55); // Eval UnnamedPoly step coeff_57 * z^57
    let t212 = circuit_add(t210, t211); // Eval UnnamedPoly step + (coeff_57 * z^57)
    let t213 = circuit_mul(in79, t56); // Eval UnnamedPoly step coeff_58 * z^58
    let t214 = circuit_add(t212, t213); // Eval UnnamedPoly step + (coeff_58 * z^58)
    let t215 = circuit_mul(in80, t57); // Eval UnnamedPoly step coeff_59 * z^59
    let t216 = circuit_add(t214, t215); // Eval UnnamedPoly step + (coeff_59 * z^59)
    let t217 = circuit_mul(in81, t58); // Eval UnnamedPoly step coeff_60 * z^60
    let t218 = circuit_add(t216, t217); // Eval UnnamedPoly step + (coeff_60 * z^60)
    let t219 = circuit_mul(in82, t59); // Eval UnnamedPoly step coeff_61 * z^61
    let t220 = circuit_add(t218, t219); // Eval UnnamedPoly step + (coeff_61 * z^61)
    let t221 = circuit_mul(in83, t60); // Eval UnnamedPoly step coeff_62 * z^62
    let t222 = circuit_add(t220, t221); // Eval UnnamedPoly step + (coeff_62 * z^62)
    let t223 = circuit_mul(in84, t61); // Eval UnnamedPoly step coeff_63 * z^63
    let t224 = circuit_add(t222, t223); // Eval UnnamedPoly step + (coeff_63 * z^63)
    let t225 = circuit_mul(in85, t62); // Eval UnnamedPoly step coeff_64 * z^64
    let t226 = circuit_add(t224, t225); // Eval UnnamedPoly step + (coeff_64 * z^64)
    let t227 = circuit_mul(in86, t63); // Eval UnnamedPoly step coeff_65 * z^65
    let t228 = circuit_add(t226, t227); // Eval UnnamedPoly step + (coeff_65 * z^65)
    let t229 = circuit_mul(in87, t64); // Eval UnnamedPoly step coeff_66 * z^66
    let t230 = circuit_add(t228, t229); // Eval UnnamedPoly step + (coeff_66 * z^66)
    let t231 = circuit_mul(in88, t65); // Eval UnnamedPoly step coeff_67 * z^67
    let t232 = circuit_add(t230, t231); // Eval UnnamedPoly step + (coeff_67 * z^67)
    let t233 = circuit_mul(in89, t66); // Eval UnnamedPoly step coeff_68 * z^68
    let t234 = circuit_add(t232, t233); // Eval UnnamedPoly step + (coeff_68 * z^68)
    let t235 = circuit_mul(in90, t67); // Eval UnnamedPoly step coeff_69 * z^69
    let t236 = circuit_add(t234, t235); // Eval UnnamedPoly step + (coeff_69 * z^69)
    let t237 = circuit_mul(t236, t98);
    let t238 = circuit_sub(t95, t237);

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [
            54880396502181392957329877675,
            31935979117156477062286671870,
            20826981314825584179608359615,
            8047903782086192180586325942
        ]
    )
        .unwrap();

    let mut circuit_inputs = (t238,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x2, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs
        .next(
            [
                0xb153ffffb9feffffffffaaa9,
                0x6730d2a0f6b0f6241eabfffe,
                0x434bacd764774b84f38512bf,
                0x1a0111ea397fe69a4b1ba7b6
            ]
        );
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w0);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w1);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w2);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w3);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w4);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w5);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w6);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w7);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w8);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w9);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w10);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w11);
    circuit_inputs = circuit_inputs.next(c_n_minus_2);
    circuit_inputs = circuit_inputs.next(w_of_z);
    circuit_inputs = circuit_inputs.next(z);
    circuit_inputs = circuit_inputs.next(c_inv_frob_1_of_z);
    circuit_inputs = circuit_inputs.next(previous_lhs);
    circuit_inputs = circuit_inputs.next(R_n_minus_2_of_z);

    let mut Q = Q;
    while let Option::Some(val) = Q.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let final_check: u384 = outputs.get_output(t238);
    return (final_check,);
}
fn run_BLS12_381_MP_CHECK_INIT_BIT_2_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    Q0: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q1: G2Point,
    R_i: E12D,
    c0: u384,
    z: u384,
    c_inv_of_z: u384
) -> (G2Point, G2Point, u384, u384) {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0x0
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 0x3
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 0x6

    // INPUT stack
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
    let in9 = CircuitElement::<CircuitInput<9>> {}; // 
    let in10 = CircuitElement::<CircuitInput<10>> {}; // 
    let in11 = CircuitElement::<CircuitInput<11>> {}; // 
    let in12 = CircuitElement::<CircuitInput<12>> {}; // 
    let in13 = CircuitElement::<CircuitInput<13>> {}; // 
    let in14 = CircuitElement::<CircuitInput<14>> {}; // 
    let in15 = CircuitElement::<CircuitInput<15>> {}; // 
    let in16 = CircuitElement::<CircuitInput<16>> {}; // 
    let in17 = CircuitElement::<CircuitInput<17>> {}; // 
    let in18 = CircuitElement::<CircuitInput<18>> {}; // 
    let in19 = CircuitElement::<CircuitInput<19>> {}; // 
    let in20 = CircuitElement::<CircuitInput<20>> {}; // 
    let in21 = CircuitElement::<CircuitInput<21>> {}; // 
    let in22 = CircuitElement::<CircuitInput<22>> {}; // 
    let in23 = CircuitElement::<CircuitInput<23>> {}; // 
    let in24 = CircuitElement::<CircuitInput<24>> {}; // 
    let in25 = CircuitElement::<CircuitInput<25>> {}; // 
    let in26 = CircuitElement::<CircuitInput<26>> {}; // 
    let in27 = CircuitElement::<CircuitInput<27>> {}; // 
    let in28 = CircuitElement::<CircuitInput<28>> {}; // 
    let in29 = CircuitElement::<CircuitInput<29>> {}; // 
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
    let t10 = circuit_mul(in16, in28); // Eval UnnamedPoly step coeff_1 * z^1
    let t11 = circuit_add(in15, t10); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t12 = circuit_mul(in17, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t13 = circuit_add(t11, t12); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t14 = circuit_mul(in18, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t15 = circuit_add(t13, t14); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t16 = circuit_mul(in19, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t17 = circuit_add(t15, t16); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t18 = circuit_mul(in20, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t19 = circuit_add(t17, t18); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t20 = circuit_mul(in21, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t21 = circuit_add(t19, t20); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t22 = circuit_mul(in22, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t23 = circuit_add(t21, t22); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t24 = circuit_mul(in23, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t25 = circuit_add(t23, t24); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t26 = circuit_mul(in24, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t27 = circuit_add(t25, t26); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t28 = circuit_mul(in25, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t29 = circuit_add(t27, t28); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t30 = circuit_mul(in26, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t31 = circuit_add(t29, t30); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t32 = circuit_mul(in29, in29);
    let t33 = circuit_mul(in29, t32);
    let t34 = circuit_add(in5, in6);
    let t35 = circuit_sub(in5, in6);
    let t36 = circuit_mul(t34, t35);
    let t37 = circuit_mul(in5, in6);
    let t38 = circuit_mul(t36, in1);
    let t39 = circuit_mul(t37, in2);
    let t40 = circuit_add(in7, in7); // Fp2 add coeff 0/1
    let t41 = circuit_add(in8, in8); // Fp2 add coeff 1/1
    let t42 = circuit_mul(t40, t40); // Fp2 Div x/y start : Fp2 Inv y start
    let t43 = circuit_mul(t41, t41);
    let t44 = circuit_add(t42, t43);
    let t45 = circuit_inverse(t44);
    let t46 = circuit_mul(t40, t45); // Fp2 Inv y real part end
    let t47 = circuit_mul(t41, t45);
    let t48 = circuit_sub(in0, t47); // Fp2 Inv y imag part end
    let t49 = circuit_mul(t38, t46); // Fp2 mul start
    let t50 = circuit_mul(t39, t48);
    let t51 = circuit_sub(t49, t50); // Fp2 mul real part end
    let t52 = circuit_mul(t38, t48);
    let t53 = circuit_mul(t39, t46);
    let t54 = circuit_add(t52, t53); // Fp2 mul imag part end
    let t55 = circuit_mul(t51, in5); // Fp2 mul start
    let t56 = circuit_mul(t54, in6);
    let t57 = circuit_sub(t55, t56); // Fp2 mul real part end
    let t58 = circuit_mul(t51, in6);
    let t59 = circuit_mul(t54, in5);
    let t60 = circuit_add(t58, t59); // Fp2 mul imag part end
    let t61 = circuit_sub(t57, in7); // Fp2 sub coeff 0/1
    let t62 = circuit_sub(t60, in8); // Fp2 sub coeff 1/1
    let t63 = circuit_sub(t61, t62);
    let t64 = circuit_mul(t63, in3);
    let t65 = circuit_sub(t51, t54);
    let t66 = circuit_mul(t65, in4);
    let t67 = circuit_mul(t62, in3);
    let t68 = circuit_mul(t54, in4);
    let t69 = circuit_add(t51, t54);
    let t70 = circuit_sub(t51, t54);
    let t71 = circuit_mul(t69, t70);
    let t72 = circuit_mul(t51, t54);
    let t73 = circuit_add(t72, t72);
    let t74 = circuit_add(in5, in5); // Fp2 add coeff 0/1
    let t75 = circuit_add(in6, in6); // Fp2 add coeff 1/1
    let t76 = circuit_sub(t71, t74); // Fp2 sub coeff 0/1
    let t77 = circuit_sub(t73, t75); // Fp2 sub coeff 1/1
    let t78 = circuit_sub(in5, t76); // Fp2 sub coeff 0/1
    let t79 = circuit_sub(in6, t77); // Fp2 sub coeff 1/1
    let t80 = circuit_mul(t78, t78); // Fp2 Div x/y start : Fp2 Inv y start
    let t81 = circuit_mul(t79, t79);
    let t82 = circuit_add(t80, t81);
    let t83 = circuit_inverse(t82);
    let t84 = circuit_mul(t78, t83); // Fp2 Inv y real part end
    let t85 = circuit_mul(t79, t83);
    let t86 = circuit_sub(in0, t85); // Fp2 Inv y imag part end
    let t87 = circuit_mul(t40, t84); // Fp2 mul start
    let t88 = circuit_mul(t41, t86);
    let t89 = circuit_sub(t87, t88); // Fp2 mul real part end
    let t90 = circuit_mul(t40, t86);
    let t91 = circuit_mul(t41, t84);
    let t92 = circuit_add(t90, t91); // Fp2 mul imag part end
    let t93 = circuit_sub(t89, t51); // Fp2 sub coeff 0/1
    let t94 = circuit_sub(t92, t54); // Fp2 sub coeff 1/1
    let t95 = circuit_mul(t93, in5); // Fp2 mul start
    let t96 = circuit_mul(t94, in6);
    let t97 = circuit_sub(t95, t96); // Fp2 mul real part end
    let t98 = circuit_mul(t93, in6);
    let t99 = circuit_mul(t94, in5);
    let t100 = circuit_add(t98, t99); // Fp2 mul imag part end
    let t101 = circuit_sub(t97, in7); // Fp2 sub coeff 0/1
    let t102 = circuit_sub(t100, in8); // Fp2 sub coeff 1/1
    let t103 = circuit_sub(t101, t102);
    let t104 = circuit_mul(t103, in3);
    let t105 = circuit_sub(t93, t94);
    let t106 = circuit_mul(t105, in4);
    let t107 = circuit_mul(t102, in3);
    let t108 = circuit_mul(t94, in4);
    let t109 = circuit_add(t93, t94);
    let t110 = circuit_sub(t93, t94);
    let t111 = circuit_mul(t109, t110);
    let t112 = circuit_mul(t93, t94);
    let t113 = circuit_add(t112, t112);
    let t114 = circuit_add(in5, t76); // Fp2 add coeff 0/1
    let t115 = circuit_add(in6, t77); // Fp2 add coeff 1/1
    let t116 = circuit_sub(t111, t114); // Fp2 sub coeff 0/1
    let t117 = circuit_sub(t113, t115); // Fp2 sub coeff 1/1
    let t118 = circuit_sub(in5, t116); // Fp2 sub coeff 0/1
    let t119 = circuit_sub(in6, t117); // Fp2 sub coeff 1/1
    let t120 = circuit_mul(t93, t118); // Fp2 mul start
    let t121 = circuit_mul(t94, t119);
    let t122 = circuit_sub(t120, t121); // Fp2 mul real part end
    let t123 = circuit_mul(t93, t119);
    let t124 = circuit_mul(t94, t118);
    let t125 = circuit_add(t123, t124); // Fp2 mul imag part end
    let t126 = circuit_sub(t122, in7); // Fp2 sub coeff 0/1
    let t127 = circuit_sub(t125, in8); // Fp2 sub coeff 1/1
    let t128 = circuit_mul(t66, t0); // Eval sparse poly UnnamedPoly step coeff_2 * z^2
    let t129 = circuit_add(t64, t128); // Eval sparse poly UnnamedPoly step + coeff_2 * z^2
    let t130 = circuit_add(t129, t1); // Eval sparse poly UnnamedPoly step + 1*z^3
    let t131 = circuit_mul(t67, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t132 = circuit_add(t130, t131); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t133 = circuit_mul(t68, t6); // Eval sparse poly UnnamedPoly step coeff_8 * z^8
    let t134 = circuit_add(t132, t133); // Eval sparse poly UnnamedPoly step + coeff_8 * z^8
    let t135 = circuit_mul(t33, t134);
    let t136 = circuit_mul(t106, t0); // Eval sparse poly UnnamedPoly step coeff_2 * z^2
    let t137 = circuit_add(t104, t136); // Eval sparse poly UnnamedPoly step + coeff_2 * z^2
    let t138 = circuit_add(t137, t1); // Eval sparse poly UnnamedPoly step + 1*z^3
    let t139 = circuit_mul(t107, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t140 = circuit_add(t138, t139); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t141 = circuit_mul(t108, t6); // Eval sparse poly UnnamedPoly step coeff_8 * z^8
    let t142 = circuit_add(t140, t141); // Eval sparse poly UnnamedPoly step + coeff_8 * z^8
    let t143 = circuit_mul(t135, t142);
    let t144 = circuit_add(in11, in12);
    let t145 = circuit_sub(in11, in12);
    let t146 = circuit_mul(t144, t145);
    let t147 = circuit_mul(in11, in12);
    let t148 = circuit_mul(t146, in1);
    let t149 = circuit_mul(t147, in2);
    let t150 = circuit_add(in13, in13); // Fp2 add coeff 0/1
    let t151 = circuit_add(in14, in14); // Fp2 add coeff 1/1
    let t152 = circuit_mul(t150, t150); // Fp2 Div x/y start : Fp2 Inv y start
    let t153 = circuit_mul(t151, t151);
    let t154 = circuit_add(t152, t153);
    let t155 = circuit_inverse(t154);
    let t156 = circuit_mul(t150, t155); // Fp2 Inv y real part end
    let t157 = circuit_mul(t151, t155);
    let t158 = circuit_sub(in0, t157); // Fp2 Inv y imag part end
    let t159 = circuit_mul(t148, t156); // Fp2 mul start
    let t160 = circuit_mul(t149, t158);
    let t161 = circuit_sub(t159, t160); // Fp2 mul real part end
    let t162 = circuit_mul(t148, t158);
    let t163 = circuit_mul(t149, t156);
    let t164 = circuit_add(t162, t163); // Fp2 mul imag part end
    let t165 = circuit_mul(t161, in11); // Fp2 mul start
    let t166 = circuit_mul(t164, in12);
    let t167 = circuit_sub(t165, t166); // Fp2 mul real part end
    let t168 = circuit_mul(t161, in12);
    let t169 = circuit_mul(t164, in11);
    let t170 = circuit_add(t168, t169); // Fp2 mul imag part end
    let t171 = circuit_sub(t167, in13); // Fp2 sub coeff 0/1
    let t172 = circuit_sub(t170, in14); // Fp2 sub coeff 1/1
    let t173 = circuit_sub(t171, t172);
    let t174 = circuit_mul(t173, in9);
    let t175 = circuit_sub(t161, t164);
    let t176 = circuit_mul(t175, in10);
    let t177 = circuit_mul(t172, in9);
    let t178 = circuit_mul(t164, in10);
    let t179 = circuit_add(t161, t164);
    let t180 = circuit_sub(t161, t164);
    let t181 = circuit_mul(t179, t180);
    let t182 = circuit_mul(t161, t164);
    let t183 = circuit_add(t182, t182);
    let t184 = circuit_add(in11, in11); // Fp2 add coeff 0/1
    let t185 = circuit_add(in12, in12); // Fp2 add coeff 1/1
    let t186 = circuit_sub(t181, t184); // Fp2 sub coeff 0/1
    let t187 = circuit_sub(t183, t185); // Fp2 sub coeff 1/1
    let t188 = circuit_sub(in11, t186); // Fp2 sub coeff 0/1
    let t189 = circuit_sub(in12, t187); // Fp2 sub coeff 1/1
    let t190 = circuit_mul(t188, t188); // Fp2 Div x/y start : Fp2 Inv y start
    let t191 = circuit_mul(t189, t189);
    let t192 = circuit_add(t190, t191);
    let t193 = circuit_inverse(t192);
    let t194 = circuit_mul(t188, t193); // Fp2 Inv y real part end
    let t195 = circuit_mul(t189, t193);
    let t196 = circuit_sub(in0, t195); // Fp2 Inv y imag part end
    let t197 = circuit_mul(t150, t194); // Fp2 mul start
    let t198 = circuit_mul(t151, t196);
    let t199 = circuit_sub(t197, t198); // Fp2 mul real part end
    let t200 = circuit_mul(t150, t196);
    let t201 = circuit_mul(t151, t194);
    let t202 = circuit_add(t200, t201); // Fp2 mul imag part end
    let t203 = circuit_sub(t199, t161); // Fp2 sub coeff 0/1
    let t204 = circuit_sub(t202, t164); // Fp2 sub coeff 1/1
    let t205 = circuit_mul(t203, in11); // Fp2 mul start
    let t206 = circuit_mul(t204, in12);
    let t207 = circuit_sub(t205, t206); // Fp2 mul real part end
    let t208 = circuit_mul(t203, in12);
    let t209 = circuit_mul(t204, in11);
    let t210 = circuit_add(t208, t209); // Fp2 mul imag part end
    let t211 = circuit_sub(t207, in13); // Fp2 sub coeff 0/1
    let t212 = circuit_sub(t210, in14); // Fp2 sub coeff 1/1
    let t213 = circuit_sub(t211, t212);
    let t214 = circuit_mul(t213, in9);
    let t215 = circuit_sub(t203, t204);
    let t216 = circuit_mul(t215, in10);
    let t217 = circuit_mul(t212, in9);
    let t218 = circuit_mul(t204, in10);
    let t219 = circuit_add(t203, t204);
    let t220 = circuit_sub(t203, t204);
    let t221 = circuit_mul(t219, t220);
    let t222 = circuit_mul(t203, t204);
    let t223 = circuit_add(t222, t222);
    let t224 = circuit_add(in11, t186); // Fp2 add coeff 0/1
    let t225 = circuit_add(in12, t187); // Fp2 add coeff 1/1
    let t226 = circuit_sub(t221, t224); // Fp2 sub coeff 0/1
    let t227 = circuit_sub(t223, t225); // Fp2 sub coeff 1/1
    let t228 = circuit_sub(in11, t226); // Fp2 sub coeff 0/1
    let t229 = circuit_sub(in12, t227); // Fp2 sub coeff 1/1
    let t230 = circuit_mul(t203, t228); // Fp2 mul start
    let t231 = circuit_mul(t204, t229);
    let t232 = circuit_sub(t230, t231); // Fp2 mul real part end
    let t233 = circuit_mul(t203, t229);
    let t234 = circuit_mul(t204, t228);
    let t235 = circuit_add(t233, t234); // Fp2 mul imag part end
    let t236 = circuit_sub(t232, in13); // Fp2 sub coeff 0/1
    let t237 = circuit_sub(t235, in14); // Fp2 sub coeff 1/1
    let t238 = circuit_mul(t176, t0); // Eval sparse poly UnnamedPoly step coeff_2 * z^2
    let t239 = circuit_add(t174, t238); // Eval sparse poly UnnamedPoly step + coeff_2 * z^2
    let t240 = circuit_add(t239, t1); // Eval sparse poly UnnamedPoly step + 1*z^3
    let t241 = circuit_mul(t177, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t242 = circuit_add(t240, t241); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t243 = circuit_mul(t178, t6); // Eval sparse poly UnnamedPoly step coeff_8 * z^8
    let t244 = circuit_add(t242, t243); // Eval sparse poly UnnamedPoly step + coeff_8 * z^8
    let t245 = circuit_mul(t143, t244);
    let t246 = circuit_mul(t216, t0); // Eval sparse poly UnnamedPoly step coeff_2 * z^2
    let t247 = circuit_add(t214, t246); // Eval sparse poly UnnamedPoly step + coeff_2 * z^2
    let t248 = circuit_add(t247, t1); // Eval sparse poly UnnamedPoly step + 1*z^3
    let t249 = circuit_mul(t217, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t250 = circuit_add(t248, t249); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t251 = circuit_mul(t218, t6); // Eval sparse poly UnnamedPoly step coeff_8 * z^8
    let t252 = circuit_add(t250, t251); // Eval sparse poly UnnamedPoly step + coeff_8 * z^8
    let t253 = circuit_mul(t245, t252);
    let t254 = circuit_sub(t253, t31);
    let t255 = circuit_mul(in27, t254); // ci * ((Π(i,k) (Pk(z)) - Ri(z))

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [
            54880396502181392957329877675,
            31935979117156477062286671870,
            20826981314825584179608359615,
            8047903782086192180586325942
        ]
    )
        .unwrap();

    let mut circuit_inputs = (t116, t117, t126, t127, t226, t227, t236, t237, t255, t31,)
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x6, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(Q0.x0);
    circuit_inputs = circuit_inputs.next(Q0.x1);
    circuit_inputs = circuit_inputs.next(Q0.y0);
    circuit_inputs = circuit_inputs.next(Q0.y1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(Q1.x0);
    circuit_inputs = circuit_inputs.next(Q1.x1);
    circuit_inputs = circuit_inputs.next(Q1.y0);
    circuit_inputs = circuit_inputs.next(Q1.y1);
    circuit_inputs = circuit_inputs.next(R_i.w0);
    circuit_inputs = circuit_inputs.next(R_i.w1);
    circuit_inputs = circuit_inputs.next(R_i.w2);
    circuit_inputs = circuit_inputs.next(R_i.w3);
    circuit_inputs = circuit_inputs.next(R_i.w4);
    circuit_inputs = circuit_inputs.next(R_i.w5);
    circuit_inputs = circuit_inputs.next(R_i.w6);
    circuit_inputs = circuit_inputs.next(R_i.w7);
    circuit_inputs = circuit_inputs.next(R_i.w8);
    circuit_inputs = circuit_inputs.next(R_i.w9);
    circuit_inputs = circuit_inputs.next(R_i.w10);
    circuit_inputs = circuit_inputs.next(R_i.w11);
    circuit_inputs = circuit_inputs.next(c0);
    circuit_inputs = circuit_inputs.next(z);
    circuit_inputs = circuit_inputs.next(c_inv_of_z);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let Q0: G2Point = G2Point {
        x0: outputs.get_output(t116),
        x1: outputs.get_output(t117),
        y0: outputs.get_output(t126),
        y1: outputs.get_output(t127)
    };

    let Q1: G2Point = G2Point {
        x0: outputs.get_output(t226),
        x1: outputs.get_output(t227),
        y0: outputs.get_output(t236),
        y1: outputs.get_output(t237)
    };

    let new_lhs: u384 = outputs.get_output(t255);

    let f_i_plus_one_of_z: u384 = outputs.get_output(t31);
    return (Q0, Q1, new_lhs, f_i_plus_one_of_z);
}
fn run_BLS12_381_MP_CHECK_INIT_BIT_3_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    Q0: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q1: G2Point,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q2: G2Point,
    R_i: E12D,
    c0: u384,
    z: u384,
    c_inv_of_z: u384
) -> (G2Point, G2Point, G2Point, u384, u384) {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0x0
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 0x3
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 0x6

    // INPUT stack
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
    let in9 = CircuitElement::<CircuitInput<9>> {}; // 
    let in10 = CircuitElement::<CircuitInput<10>> {}; // 
    let in11 = CircuitElement::<CircuitInput<11>> {}; // 
    let in12 = CircuitElement::<CircuitInput<12>> {}; // 
    let in13 = CircuitElement::<CircuitInput<13>> {}; // 
    let in14 = CircuitElement::<CircuitInput<14>> {}; // 
    let in15 = CircuitElement::<CircuitInput<15>> {}; // 
    let in16 = CircuitElement::<CircuitInput<16>> {}; // 
    let in17 = CircuitElement::<CircuitInput<17>> {}; // 
    let in18 = CircuitElement::<CircuitInput<18>> {}; // 
    let in19 = CircuitElement::<CircuitInput<19>> {}; // 
    let in20 = CircuitElement::<CircuitInput<20>> {}; // 
    let in21 = CircuitElement::<CircuitInput<21>> {}; // 
    let in22 = CircuitElement::<CircuitInput<22>> {}; // 
    let in23 = CircuitElement::<CircuitInput<23>> {}; // 
    let in24 = CircuitElement::<CircuitInput<24>> {}; // 
    let in25 = CircuitElement::<CircuitInput<25>> {}; // 
    let in26 = CircuitElement::<CircuitInput<26>> {}; // 
    let in27 = CircuitElement::<CircuitInput<27>> {}; // 
    let in28 = CircuitElement::<CircuitInput<28>> {}; // 
    let in29 = CircuitElement::<CircuitInput<29>> {}; // 
    let in30 = CircuitElement::<CircuitInput<30>> {}; // 
    let in31 = CircuitElement::<CircuitInput<31>> {}; // 
    let in32 = CircuitElement::<CircuitInput<32>> {}; // 
    let in33 = CircuitElement::<CircuitInput<33>> {}; // 
    let in34 = CircuitElement::<CircuitInput<34>> {}; // 
    let in35 = CircuitElement::<CircuitInput<35>> {}; // 
    let t0 = circuit_mul(in34, in34); // Compute z^2
    let t1 = circuit_mul(t0, in34); // Compute z^3
    let t2 = circuit_mul(t1, in34); // Compute z^4
    let t3 = circuit_mul(t2, in34); // Compute z^5
    let t4 = circuit_mul(t3, in34); // Compute z^6
    let t5 = circuit_mul(t4, in34); // Compute z^7
    let t6 = circuit_mul(t5, in34); // Compute z^8
    let t7 = circuit_mul(t6, in34); // Compute z^9
    let t8 = circuit_mul(t7, in34); // Compute z^10
    let t9 = circuit_mul(t8, in34); // Compute z^11
    let t10 = circuit_mul(in22, in34); // Eval UnnamedPoly step coeff_1 * z^1
    let t11 = circuit_add(in21, t10); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t12 = circuit_mul(in23, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t13 = circuit_add(t11, t12); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t14 = circuit_mul(in24, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t15 = circuit_add(t13, t14); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t16 = circuit_mul(in25, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t17 = circuit_add(t15, t16); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t18 = circuit_mul(in26, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t19 = circuit_add(t17, t18); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t20 = circuit_mul(in27, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t21 = circuit_add(t19, t20); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t22 = circuit_mul(in28, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t23 = circuit_add(t21, t22); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t24 = circuit_mul(in29, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t25 = circuit_add(t23, t24); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t26 = circuit_mul(in30, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t27 = circuit_add(t25, t26); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t28 = circuit_mul(in31, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t29 = circuit_add(t27, t28); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t30 = circuit_mul(in32, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t31 = circuit_add(t29, t30); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t32 = circuit_mul(in35, in35);
    let t33 = circuit_mul(in35, t32);
    let t34 = circuit_add(in5, in6);
    let t35 = circuit_sub(in5, in6);
    let t36 = circuit_mul(t34, t35);
    let t37 = circuit_mul(in5, in6);
    let t38 = circuit_mul(t36, in1);
    let t39 = circuit_mul(t37, in2);
    let t40 = circuit_add(in7, in7); // Fp2 add coeff 0/1
    let t41 = circuit_add(in8, in8); // Fp2 add coeff 1/1
    let t42 = circuit_mul(t40, t40); // Fp2 Div x/y start : Fp2 Inv y start
    let t43 = circuit_mul(t41, t41);
    let t44 = circuit_add(t42, t43);
    let t45 = circuit_inverse(t44);
    let t46 = circuit_mul(t40, t45); // Fp2 Inv y real part end
    let t47 = circuit_mul(t41, t45);
    let t48 = circuit_sub(in0, t47); // Fp2 Inv y imag part end
    let t49 = circuit_mul(t38, t46); // Fp2 mul start
    let t50 = circuit_mul(t39, t48);
    let t51 = circuit_sub(t49, t50); // Fp2 mul real part end
    let t52 = circuit_mul(t38, t48);
    let t53 = circuit_mul(t39, t46);
    let t54 = circuit_add(t52, t53); // Fp2 mul imag part end
    let t55 = circuit_mul(t51, in5); // Fp2 mul start
    let t56 = circuit_mul(t54, in6);
    let t57 = circuit_sub(t55, t56); // Fp2 mul real part end
    let t58 = circuit_mul(t51, in6);
    let t59 = circuit_mul(t54, in5);
    let t60 = circuit_add(t58, t59); // Fp2 mul imag part end
    let t61 = circuit_sub(t57, in7); // Fp2 sub coeff 0/1
    let t62 = circuit_sub(t60, in8); // Fp2 sub coeff 1/1
    let t63 = circuit_sub(t61, t62);
    let t64 = circuit_mul(t63, in3);
    let t65 = circuit_sub(t51, t54);
    let t66 = circuit_mul(t65, in4);
    let t67 = circuit_mul(t62, in3);
    let t68 = circuit_mul(t54, in4);
    let t69 = circuit_add(t51, t54);
    let t70 = circuit_sub(t51, t54);
    let t71 = circuit_mul(t69, t70);
    let t72 = circuit_mul(t51, t54);
    let t73 = circuit_add(t72, t72);
    let t74 = circuit_add(in5, in5); // Fp2 add coeff 0/1
    let t75 = circuit_add(in6, in6); // Fp2 add coeff 1/1
    let t76 = circuit_sub(t71, t74); // Fp2 sub coeff 0/1
    let t77 = circuit_sub(t73, t75); // Fp2 sub coeff 1/1
    let t78 = circuit_sub(in5, t76); // Fp2 sub coeff 0/1
    let t79 = circuit_sub(in6, t77); // Fp2 sub coeff 1/1
    let t80 = circuit_mul(t78, t78); // Fp2 Div x/y start : Fp2 Inv y start
    let t81 = circuit_mul(t79, t79);
    let t82 = circuit_add(t80, t81);
    let t83 = circuit_inverse(t82);
    let t84 = circuit_mul(t78, t83); // Fp2 Inv y real part end
    let t85 = circuit_mul(t79, t83);
    let t86 = circuit_sub(in0, t85); // Fp2 Inv y imag part end
    let t87 = circuit_mul(t40, t84); // Fp2 mul start
    let t88 = circuit_mul(t41, t86);
    let t89 = circuit_sub(t87, t88); // Fp2 mul real part end
    let t90 = circuit_mul(t40, t86);
    let t91 = circuit_mul(t41, t84);
    let t92 = circuit_add(t90, t91); // Fp2 mul imag part end
    let t93 = circuit_sub(t89, t51); // Fp2 sub coeff 0/1
    let t94 = circuit_sub(t92, t54); // Fp2 sub coeff 1/1
    let t95 = circuit_mul(t93, in5); // Fp2 mul start
    let t96 = circuit_mul(t94, in6);
    let t97 = circuit_sub(t95, t96); // Fp2 mul real part end
    let t98 = circuit_mul(t93, in6);
    let t99 = circuit_mul(t94, in5);
    let t100 = circuit_add(t98, t99); // Fp2 mul imag part end
    let t101 = circuit_sub(t97, in7); // Fp2 sub coeff 0/1
    let t102 = circuit_sub(t100, in8); // Fp2 sub coeff 1/1
    let t103 = circuit_sub(t101, t102);
    let t104 = circuit_mul(t103, in3);
    let t105 = circuit_sub(t93, t94);
    let t106 = circuit_mul(t105, in4);
    let t107 = circuit_mul(t102, in3);
    let t108 = circuit_mul(t94, in4);
    let t109 = circuit_add(t93, t94);
    let t110 = circuit_sub(t93, t94);
    let t111 = circuit_mul(t109, t110);
    let t112 = circuit_mul(t93, t94);
    let t113 = circuit_add(t112, t112);
    let t114 = circuit_add(in5, t76); // Fp2 add coeff 0/1
    let t115 = circuit_add(in6, t77); // Fp2 add coeff 1/1
    let t116 = circuit_sub(t111, t114); // Fp2 sub coeff 0/1
    let t117 = circuit_sub(t113, t115); // Fp2 sub coeff 1/1
    let t118 = circuit_sub(in5, t116); // Fp2 sub coeff 0/1
    let t119 = circuit_sub(in6, t117); // Fp2 sub coeff 1/1
    let t120 = circuit_mul(t93, t118); // Fp2 mul start
    let t121 = circuit_mul(t94, t119);
    let t122 = circuit_sub(t120, t121); // Fp2 mul real part end
    let t123 = circuit_mul(t93, t119);
    let t124 = circuit_mul(t94, t118);
    let t125 = circuit_add(t123, t124); // Fp2 mul imag part end
    let t126 = circuit_sub(t122, in7); // Fp2 sub coeff 0/1
    let t127 = circuit_sub(t125, in8); // Fp2 sub coeff 1/1
    let t128 = circuit_mul(t66, t0); // Eval sparse poly UnnamedPoly step coeff_2 * z^2
    let t129 = circuit_add(t64, t128); // Eval sparse poly UnnamedPoly step + coeff_2 * z^2
    let t130 = circuit_add(t129, t1); // Eval sparse poly UnnamedPoly step + 1*z^3
    let t131 = circuit_mul(t67, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t132 = circuit_add(t130, t131); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t133 = circuit_mul(t68, t6); // Eval sparse poly UnnamedPoly step coeff_8 * z^8
    let t134 = circuit_add(t132, t133); // Eval sparse poly UnnamedPoly step + coeff_8 * z^8
    let t135 = circuit_mul(t33, t134);
    let t136 = circuit_mul(t106, t0); // Eval sparse poly UnnamedPoly step coeff_2 * z^2
    let t137 = circuit_add(t104, t136); // Eval sparse poly UnnamedPoly step + coeff_2 * z^2
    let t138 = circuit_add(t137, t1); // Eval sparse poly UnnamedPoly step + 1*z^3
    let t139 = circuit_mul(t107, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t140 = circuit_add(t138, t139); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t141 = circuit_mul(t108, t6); // Eval sparse poly UnnamedPoly step coeff_8 * z^8
    let t142 = circuit_add(t140, t141); // Eval sparse poly UnnamedPoly step + coeff_8 * z^8
    let t143 = circuit_mul(t135, t142);
    let t144 = circuit_add(in11, in12);
    let t145 = circuit_sub(in11, in12);
    let t146 = circuit_mul(t144, t145);
    let t147 = circuit_mul(in11, in12);
    let t148 = circuit_mul(t146, in1);
    let t149 = circuit_mul(t147, in2);
    let t150 = circuit_add(in13, in13); // Fp2 add coeff 0/1
    let t151 = circuit_add(in14, in14); // Fp2 add coeff 1/1
    let t152 = circuit_mul(t150, t150); // Fp2 Div x/y start : Fp2 Inv y start
    let t153 = circuit_mul(t151, t151);
    let t154 = circuit_add(t152, t153);
    let t155 = circuit_inverse(t154);
    let t156 = circuit_mul(t150, t155); // Fp2 Inv y real part end
    let t157 = circuit_mul(t151, t155);
    let t158 = circuit_sub(in0, t157); // Fp2 Inv y imag part end
    let t159 = circuit_mul(t148, t156); // Fp2 mul start
    let t160 = circuit_mul(t149, t158);
    let t161 = circuit_sub(t159, t160); // Fp2 mul real part end
    let t162 = circuit_mul(t148, t158);
    let t163 = circuit_mul(t149, t156);
    let t164 = circuit_add(t162, t163); // Fp2 mul imag part end
    let t165 = circuit_mul(t161, in11); // Fp2 mul start
    let t166 = circuit_mul(t164, in12);
    let t167 = circuit_sub(t165, t166); // Fp2 mul real part end
    let t168 = circuit_mul(t161, in12);
    let t169 = circuit_mul(t164, in11);
    let t170 = circuit_add(t168, t169); // Fp2 mul imag part end
    let t171 = circuit_sub(t167, in13); // Fp2 sub coeff 0/1
    let t172 = circuit_sub(t170, in14); // Fp2 sub coeff 1/1
    let t173 = circuit_sub(t171, t172);
    let t174 = circuit_mul(t173, in9);
    let t175 = circuit_sub(t161, t164);
    let t176 = circuit_mul(t175, in10);
    let t177 = circuit_mul(t172, in9);
    let t178 = circuit_mul(t164, in10);
    let t179 = circuit_add(t161, t164);
    let t180 = circuit_sub(t161, t164);
    let t181 = circuit_mul(t179, t180);
    let t182 = circuit_mul(t161, t164);
    let t183 = circuit_add(t182, t182);
    let t184 = circuit_add(in11, in11); // Fp2 add coeff 0/1
    let t185 = circuit_add(in12, in12); // Fp2 add coeff 1/1
    let t186 = circuit_sub(t181, t184); // Fp2 sub coeff 0/1
    let t187 = circuit_sub(t183, t185); // Fp2 sub coeff 1/1
    let t188 = circuit_sub(in11, t186); // Fp2 sub coeff 0/1
    let t189 = circuit_sub(in12, t187); // Fp2 sub coeff 1/1
    let t190 = circuit_mul(t188, t188); // Fp2 Div x/y start : Fp2 Inv y start
    let t191 = circuit_mul(t189, t189);
    let t192 = circuit_add(t190, t191);
    let t193 = circuit_inverse(t192);
    let t194 = circuit_mul(t188, t193); // Fp2 Inv y real part end
    let t195 = circuit_mul(t189, t193);
    let t196 = circuit_sub(in0, t195); // Fp2 Inv y imag part end
    let t197 = circuit_mul(t150, t194); // Fp2 mul start
    let t198 = circuit_mul(t151, t196);
    let t199 = circuit_sub(t197, t198); // Fp2 mul real part end
    let t200 = circuit_mul(t150, t196);
    let t201 = circuit_mul(t151, t194);
    let t202 = circuit_add(t200, t201); // Fp2 mul imag part end
    let t203 = circuit_sub(t199, t161); // Fp2 sub coeff 0/1
    let t204 = circuit_sub(t202, t164); // Fp2 sub coeff 1/1
    let t205 = circuit_mul(t203, in11); // Fp2 mul start
    let t206 = circuit_mul(t204, in12);
    let t207 = circuit_sub(t205, t206); // Fp2 mul real part end
    let t208 = circuit_mul(t203, in12);
    let t209 = circuit_mul(t204, in11);
    let t210 = circuit_add(t208, t209); // Fp2 mul imag part end
    let t211 = circuit_sub(t207, in13); // Fp2 sub coeff 0/1
    let t212 = circuit_sub(t210, in14); // Fp2 sub coeff 1/1
    let t213 = circuit_sub(t211, t212);
    let t214 = circuit_mul(t213, in9);
    let t215 = circuit_sub(t203, t204);
    let t216 = circuit_mul(t215, in10);
    let t217 = circuit_mul(t212, in9);
    let t218 = circuit_mul(t204, in10);
    let t219 = circuit_add(t203, t204);
    let t220 = circuit_sub(t203, t204);
    let t221 = circuit_mul(t219, t220);
    let t222 = circuit_mul(t203, t204);
    let t223 = circuit_add(t222, t222);
    let t224 = circuit_add(in11, t186); // Fp2 add coeff 0/1
    let t225 = circuit_add(in12, t187); // Fp2 add coeff 1/1
    let t226 = circuit_sub(t221, t224); // Fp2 sub coeff 0/1
    let t227 = circuit_sub(t223, t225); // Fp2 sub coeff 1/1
    let t228 = circuit_sub(in11, t226); // Fp2 sub coeff 0/1
    let t229 = circuit_sub(in12, t227); // Fp2 sub coeff 1/1
    let t230 = circuit_mul(t203, t228); // Fp2 mul start
    let t231 = circuit_mul(t204, t229);
    let t232 = circuit_sub(t230, t231); // Fp2 mul real part end
    let t233 = circuit_mul(t203, t229);
    let t234 = circuit_mul(t204, t228);
    let t235 = circuit_add(t233, t234); // Fp2 mul imag part end
    let t236 = circuit_sub(t232, in13); // Fp2 sub coeff 0/1
    let t237 = circuit_sub(t235, in14); // Fp2 sub coeff 1/1
    let t238 = circuit_mul(t176, t0); // Eval sparse poly UnnamedPoly step coeff_2 * z^2
    let t239 = circuit_add(t174, t238); // Eval sparse poly UnnamedPoly step + coeff_2 * z^2
    let t240 = circuit_add(t239, t1); // Eval sparse poly UnnamedPoly step + 1*z^3
    let t241 = circuit_mul(t177, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t242 = circuit_add(t240, t241); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t243 = circuit_mul(t178, t6); // Eval sparse poly UnnamedPoly step coeff_8 * z^8
    let t244 = circuit_add(t242, t243); // Eval sparse poly UnnamedPoly step + coeff_8 * z^8
    let t245 = circuit_mul(t143, t244);
    let t246 = circuit_mul(t216, t0); // Eval sparse poly UnnamedPoly step coeff_2 * z^2
    let t247 = circuit_add(t214, t246); // Eval sparse poly UnnamedPoly step + coeff_2 * z^2
    let t248 = circuit_add(t247, t1); // Eval sparse poly UnnamedPoly step + 1*z^3
    let t249 = circuit_mul(t217, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t250 = circuit_add(t248, t249); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t251 = circuit_mul(t218, t6); // Eval sparse poly UnnamedPoly step coeff_8 * z^8
    let t252 = circuit_add(t250, t251); // Eval sparse poly UnnamedPoly step + coeff_8 * z^8
    let t253 = circuit_mul(t245, t252);
    let t254 = circuit_add(in17, in18);
    let t255 = circuit_sub(in17, in18);
    let t256 = circuit_mul(t254, t255);
    let t257 = circuit_mul(in17, in18);
    let t258 = circuit_mul(t256, in1);
    let t259 = circuit_mul(t257, in2);
    let t260 = circuit_add(in19, in19); // Fp2 add coeff 0/1
    let t261 = circuit_add(in20, in20); // Fp2 add coeff 1/1
    let t262 = circuit_mul(t260, t260); // Fp2 Div x/y start : Fp2 Inv y start
    let t263 = circuit_mul(t261, t261);
    let t264 = circuit_add(t262, t263);
    let t265 = circuit_inverse(t264);
    let t266 = circuit_mul(t260, t265); // Fp2 Inv y real part end
    let t267 = circuit_mul(t261, t265);
    let t268 = circuit_sub(in0, t267); // Fp2 Inv y imag part end
    let t269 = circuit_mul(t258, t266); // Fp2 mul start
    let t270 = circuit_mul(t259, t268);
    let t271 = circuit_sub(t269, t270); // Fp2 mul real part end
    let t272 = circuit_mul(t258, t268);
    let t273 = circuit_mul(t259, t266);
    let t274 = circuit_add(t272, t273); // Fp2 mul imag part end
    let t275 = circuit_mul(t271, in17); // Fp2 mul start
    let t276 = circuit_mul(t274, in18);
    let t277 = circuit_sub(t275, t276); // Fp2 mul real part end
    let t278 = circuit_mul(t271, in18);
    let t279 = circuit_mul(t274, in17);
    let t280 = circuit_add(t278, t279); // Fp2 mul imag part end
    let t281 = circuit_sub(t277, in19); // Fp2 sub coeff 0/1
    let t282 = circuit_sub(t280, in20); // Fp2 sub coeff 1/1
    let t283 = circuit_sub(t281, t282);
    let t284 = circuit_mul(t283, in15);
    let t285 = circuit_sub(t271, t274);
    let t286 = circuit_mul(t285, in16);
    let t287 = circuit_mul(t282, in15);
    let t288 = circuit_mul(t274, in16);
    let t289 = circuit_add(t271, t274);
    let t290 = circuit_sub(t271, t274);
    let t291 = circuit_mul(t289, t290);
    let t292 = circuit_mul(t271, t274);
    let t293 = circuit_add(t292, t292);
    let t294 = circuit_add(in17, in17); // Fp2 add coeff 0/1
    let t295 = circuit_add(in18, in18); // Fp2 add coeff 1/1
    let t296 = circuit_sub(t291, t294); // Fp2 sub coeff 0/1
    let t297 = circuit_sub(t293, t295); // Fp2 sub coeff 1/1
    let t298 = circuit_sub(in17, t296); // Fp2 sub coeff 0/1
    let t299 = circuit_sub(in18, t297); // Fp2 sub coeff 1/1
    let t300 = circuit_mul(t298, t298); // Fp2 Div x/y start : Fp2 Inv y start
    let t301 = circuit_mul(t299, t299);
    let t302 = circuit_add(t300, t301);
    let t303 = circuit_inverse(t302);
    let t304 = circuit_mul(t298, t303); // Fp2 Inv y real part end
    let t305 = circuit_mul(t299, t303);
    let t306 = circuit_sub(in0, t305); // Fp2 Inv y imag part end
    let t307 = circuit_mul(t260, t304); // Fp2 mul start
    let t308 = circuit_mul(t261, t306);
    let t309 = circuit_sub(t307, t308); // Fp2 mul real part end
    let t310 = circuit_mul(t260, t306);
    let t311 = circuit_mul(t261, t304);
    let t312 = circuit_add(t310, t311); // Fp2 mul imag part end
    let t313 = circuit_sub(t309, t271); // Fp2 sub coeff 0/1
    let t314 = circuit_sub(t312, t274); // Fp2 sub coeff 1/1
    let t315 = circuit_mul(t313, in17); // Fp2 mul start
    let t316 = circuit_mul(t314, in18);
    let t317 = circuit_sub(t315, t316); // Fp2 mul real part end
    let t318 = circuit_mul(t313, in18);
    let t319 = circuit_mul(t314, in17);
    let t320 = circuit_add(t318, t319); // Fp2 mul imag part end
    let t321 = circuit_sub(t317, in19); // Fp2 sub coeff 0/1
    let t322 = circuit_sub(t320, in20); // Fp2 sub coeff 1/1
    let t323 = circuit_sub(t321, t322);
    let t324 = circuit_mul(t323, in15);
    let t325 = circuit_sub(t313, t314);
    let t326 = circuit_mul(t325, in16);
    let t327 = circuit_mul(t322, in15);
    let t328 = circuit_mul(t314, in16);
    let t329 = circuit_add(t313, t314);
    let t330 = circuit_sub(t313, t314);
    let t331 = circuit_mul(t329, t330);
    let t332 = circuit_mul(t313, t314);
    let t333 = circuit_add(t332, t332);
    let t334 = circuit_add(in17, t296); // Fp2 add coeff 0/1
    let t335 = circuit_add(in18, t297); // Fp2 add coeff 1/1
    let t336 = circuit_sub(t331, t334); // Fp2 sub coeff 0/1
    let t337 = circuit_sub(t333, t335); // Fp2 sub coeff 1/1
    let t338 = circuit_sub(in17, t336); // Fp2 sub coeff 0/1
    let t339 = circuit_sub(in18, t337); // Fp2 sub coeff 1/1
    let t340 = circuit_mul(t313, t338); // Fp2 mul start
    let t341 = circuit_mul(t314, t339);
    let t342 = circuit_sub(t340, t341); // Fp2 mul real part end
    let t343 = circuit_mul(t313, t339);
    let t344 = circuit_mul(t314, t338);
    let t345 = circuit_add(t343, t344); // Fp2 mul imag part end
    let t346 = circuit_sub(t342, in19); // Fp2 sub coeff 0/1
    let t347 = circuit_sub(t345, in20); // Fp2 sub coeff 1/1
    let t348 = circuit_mul(t286, t0); // Eval sparse poly UnnamedPoly step coeff_2 * z^2
    let t349 = circuit_add(t284, t348); // Eval sparse poly UnnamedPoly step + coeff_2 * z^2
    let t350 = circuit_add(t349, t1); // Eval sparse poly UnnamedPoly step + 1*z^3
    let t351 = circuit_mul(t287, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t352 = circuit_add(t350, t351); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t353 = circuit_mul(t288, t6); // Eval sparse poly UnnamedPoly step coeff_8 * z^8
    let t354 = circuit_add(t352, t353); // Eval sparse poly UnnamedPoly step + coeff_8 * z^8
    let t355 = circuit_mul(t253, t354);
    let t356 = circuit_mul(t326, t0); // Eval sparse poly UnnamedPoly step coeff_2 * z^2
    let t357 = circuit_add(t324, t356); // Eval sparse poly UnnamedPoly step + coeff_2 * z^2
    let t358 = circuit_add(t357, t1); // Eval sparse poly UnnamedPoly step + 1*z^3
    let t359 = circuit_mul(t327, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t360 = circuit_add(t358, t359); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t361 = circuit_mul(t328, t6); // Eval sparse poly UnnamedPoly step coeff_8 * z^8
    let t362 = circuit_add(t360, t361); // Eval sparse poly UnnamedPoly step + coeff_8 * z^8
    let t363 = circuit_mul(t355, t362);
    let t364 = circuit_sub(t363, t31);
    let t365 = circuit_mul(in33, t364); // ci * ((Π(i,k) (Pk(z)) - Ri(z))

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [
            54880396502181392957329877675,
            31935979117156477062286671870,
            20826981314825584179608359615,
            8047903782086192180586325942
        ]
    )
        .unwrap();

    let mut circuit_inputs = (
        t116, t117, t126, t127, t226, t227, t236, t237, t336, t337, t346, t347, t365, t31,
    )
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x6, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(Q0.x0);
    circuit_inputs = circuit_inputs.next(Q0.x1);
    circuit_inputs = circuit_inputs.next(Q0.y0);
    circuit_inputs = circuit_inputs.next(Q0.y1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(Q1.x0);
    circuit_inputs = circuit_inputs.next(Q1.x1);
    circuit_inputs = circuit_inputs.next(Q1.y0);
    circuit_inputs = circuit_inputs.next(Q1.y1);
    circuit_inputs = circuit_inputs.next(yInv_2);
    circuit_inputs = circuit_inputs.next(xNegOverY_2);
    circuit_inputs = circuit_inputs.next(Q2.x0);
    circuit_inputs = circuit_inputs.next(Q2.x1);
    circuit_inputs = circuit_inputs.next(Q2.y0);
    circuit_inputs = circuit_inputs.next(Q2.y1);
    circuit_inputs = circuit_inputs.next(R_i.w0);
    circuit_inputs = circuit_inputs.next(R_i.w1);
    circuit_inputs = circuit_inputs.next(R_i.w2);
    circuit_inputs = circuit_inputs.next(R_i.w3);
    circuit_inputs = circuit_inputs.next(R_i.w4);
    circuit_inputs = circuit_inputs.next(R_i.w5);
    circuit_inputs = circuit_inputs.next(R_i.w6);
    circuit_inputs = circuit_inputs.next(R_i.w7);
    circuit_inputs = circuit_inputs.next(R_i.w8);
    circuit_inputs = circuit_inputs.next(R_i.w9);
    circuit_inputs = circuit_inputs.next(R_i.w10);
    circuit_inputs = circuit_inputs.next(R_i.w11);
    circuit_inputs = circuit_inputs.next(c0);
    circuit_inputs = circuit_inputs.next(z);
    circuit_inputs = circuit_inputs.next(c_inv_of_z);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let Q0: G2Point = G2Point {
        x0: outputs.get_output(t116),
        x1: outputs.get_output(t117),
        y0: outputs.get_output(t126),
        y1: outputs.get_output(t127)
    };

    let Q1: G2Point = G2Point {
        x0: outputs.get_output(t226),
        x1: outputs.get_output(t227),
        y0: outputs.get_output(t236),
        y1: outputs.get_output(t237)
    };

    let Q2: G2Point = G2Point {
        x0: outputs.get_output(t336),
        x1: outputs.get_output(t337),
        y0: outputs.get_output(t346),
        y1: outputs.get_output(t347)
    };

    let new_lhs: u384 = outputs.get_output(t365);

    let f_i_plus_one_of_z: u384 = outputs.get_output(t31);
    return (Q0, Q1, Q2, new_lhs, f_i_plus_one_of_z);
}
fn run_BLS12_381_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit(
    lambda_root_inverse: E12D, z: u384, scaling_factor: MillerLoopResultScalingFactor
) -> (u384, u384, u384) {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0x0
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 0x2
    let in2 = CircuitElement::<
        CircuitInput<2>
    > {}; // 0x18089593cbf626353947d5b1fd0c6d66bb34bc7585f5abdf8f17b50e12c47d65ce514a7c167b027b600febdb244714c5
    let in3 = CircuitElement::<
        CircuitInput<3>
    > {}; // 0x5f19672fdf76ce51ba69c6076a0f77eaddb3a93be6f89688de17d813620a00022e01fffffffeffff
    let in4 = CircuitElement::<
        CircuitInput<4>
    > {}; // 0xd5e1c086ffe8016d063c6dad7a2fffc9072bb5785a686bcefeedc2e0124838bdccf325ee5d80be9902109f7dbc79812
    let in5 = CircuitElement::<
        CircuitInput<5>
    > {}; // 0x1a0111ea397fe699ec02408663d4de85aa0d857d89759ad4897d29650fb85f9b409427eb4f49fffd8bfd00000000aaad
    let in6 = CircuitElement::<
        CircuitInput<6>
    > {}; // 0x1a0111ea397fe6998ce8d956845e1033efa3bf761f6622e9abc9802928bfc912627c4fd7ed3ffffb5dfb00000001aaaf
    let in7 = CircuitElement::<
        CircuitInput<7>
    > {}; // 0xb659fb20274bfb1be8ff4d69163c08be7302c4818171fdd17d5be9b1d380acd8c747cdc4aff0e653631f5d3000f022c
    let in8 = CircuitElement::<CircuitInput<8>> {}; // -0x1 % p
    let in9 = CircuitElement::<
        CircuitInput<9>
    > {}; // 0xfc3e2b36c4e03288e9e902231f9fb854a14787b6c7b36fec0c8ec971f63c5f282d5ac14d6c7ec22cf78a126ddc4af3
    let in10 = CircuitElement::<
        CircuitInput<10>
    > {}; // 0x1f87c566d89c06511d3d204463f3f70a9428f0f6d8f66dfd8191d92e3ec78be505ab5829ad8fd8459ef1424dbb895e6
    let in11 = CircuitElement::<
        CircuitInput<11>
    > {}; // 0x1a0111ea397fe699ec02408663d4de85aa0d857d89759ad4897d29650fb85f9b409427eb4f49fffd8bfd00000000aaac
    let in12 = CircuitElement::<
        CircuitInput<12>
    > {}; // 0x6af0e0437ff400b6831e36d6bd17ffe48395dabc2d3435e77f76e17009241c5ee67992f72ec05f4c81084fbede3cc09
    let in13 = CircuitElement::<
        CircuitInput<13>
    > {}; // 0x5f19672fdf76ce51ba69c6076a0f77eaddb3a93be6f89688de17d813620a00022e01fffffffefffe
    let in14 = CircuitElement::<
        CircuitInput<14>
    > {}; // 0x144e4211384586c16bd3ad4afa99cc9170df3560e77982d0db45f3536814f0bd5871c1908bd478cd1ee605167ff82995
    let in15 = CircuitElement::<
        CircuitInput<15>
    > {}; // 0xe9b7238370b26e88c8bb2dfb1e7ec4b7d471f3cdb6df2e24f5b1405d978eb56923783226654f19a83cd0a2cfff0a87f

    // INPUT stack
    let in16 = CircuitElement::<CircuitInput<16>> {}; // 
    let in17 = CircuitElement::<CircuitInput<17>> {}; // 
    let in18 = CircuitElement::<CircuitInput<18>> {}; // 
    let in19 = CircuitElement::<CircuitInput<19>> {}; // 
    let in20 = CircuitElement::<CircuitInput<20>> {}; // 
    let in21 = CircuitElement::<CircuitInput<21>> {}; // 
    let in22 = CircuitElement::<CircuitInput<22>> {}; // 
    let in23 = CircuitElement::<CircuitInput<23>> {}; // 
    let in24 = CircuitElement::<CircuitInput<24>> {}; // 
    let in25 = CircuitElement::<CircuitInput<25>> {}; // 
    let in26 = CircuitElement::<CircuitInput<26>> {}; // 
    let in27 = CircuitElement::<CircuitInput<27>> {}; // 
    let in28 = CircuitElement::<CircuitInput<28>> {}; // 
    let in29 = CircuitElement::<CircuitInput<29>> {}; // 
    let in30 = CircuitElement::<CircuitInput<30>> {}; // 
    let in31 = CircuitElement::<CircuitInput<31>> {}; // 
    let in32 = CircuitElement::<CircuitInput<32>> {}; // 
    let in33 = CircuitElement::<CircuitInput<33>> {}; // 
    let in34 = CircuitElement::<CircuitInput<34>> {}; // 
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
    let t16 = circuit_mul(t10, in28); // Eval UnnamedPoly step coeff_1 * z^1
    let t17 = circuit_add(in16, t16); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t18 = circuit_mul(in18, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t19 = circuit_add(t17, t18); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t20 = circuit_mul(t11, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t21 = circuit_add(t19, t20); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t22 = circuit_mul(in20, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t23 = circuit_add(t21, t22); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t24 = circuit_mul(t12, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t25 = circuit_add(t23, t24); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t26 = circuit_mul(in22, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t27 = circuit_add(t25, t26); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t28 = circuit_mul(t13, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t29 = circuit_add(t27, t28); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t30 = circuit_mul(in24, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t31 = circuit_add(t29, t30); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t32 = circuit_mul(t14, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t33 = circuit_add(t31, t32); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t34 = circuit_mul(in26, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t35 = circuit_add(t33, t34); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t36 = circuit_mul(t15, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t37 = circuit_add(t35, t36); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t38 = circuit_mul(in30, t0); // Eval sparse poly UnnamedPoly step coeff_2 * z^2
    let t39 = circuit_add(in29, t38); // Eval sparse poly UnnamedPoly step + coeff_2 * z^2
    let t40 = circuit_mul(in31, t2); // Eval sparse poly UnnamedPoly step coeff_4 * z^4
    let t41 = circuit_add(t39, t40); // Eval sparse poly UnnamedPoly step + coeff_4 * z^4
    let t42 = circuit_mul(in32, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t43 = circuit_add(t41, t42); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t44 = circuit_mul(in33, t6); // Eval sparse poly UnnamedPoly step coeff_8 * z^8
    let t45 = circuit_add(t43, t44); // Eval sparse poly UnnamedPoly step + coeff_8 * z^8
    let t46 = circuit_mul(in34, t8); // Eval sparse poly UnnamedPoly step coeff_10 * z^10
    let t47 = circuit_add(t45, t46); // Eval sparse poly UnnamedPoly step + coeff_10 * z^10
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
    let t73 = circuit_mul(t52, in28); // Eval UnnamedPoly step coeff_1 * z^1
    let t74 = circuit_add(t49, t73); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t75 = circuit_mul(t53, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t76 = circuit_add(t74, t75); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t77 = circuit_mul(t54, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t78 = circuit_add(t76, t77); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t79 = circuit_mul(t57, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t80 = circuit_add(t78, t79); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t81 = circuit_mul(t60, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t82 = circuit_add(t80, t81); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t83 = circuit_mul(t61, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t84 = circuit_add(t82, t83); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t85 = circuit_mul(t64, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t86 = circuit_add(t84, t85); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t87 = circuit_mul(t67, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t88 = circuit_add(t86, t87); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t89 = circuit_mul(t68, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t90 = circuit_add(t88, t89); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t91 = circuit_mul(t69, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t92 = circuit_add(t90, t91); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t93 = circuit_mul(t72, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t94 = circuit_add(t92, t93); // Eval UnnamedPoly step + (coeff_11 * z^11)

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [
            54880396502181392957329877675,
            31935979117156477062286671870,
            20826981314825584179608359615,
            8047903782086192180586325942
        ]
    )
        .unwrap();

    let mut circuit_inputs = (t37, t47, t94,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x2, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs
        .next(
            [
                0x167b027b600febdb244714c5,
                0x8f17b50e12c47d65ce514a7c,
                0xfd0c6d66bb34bc7585f5abdf,
                0x18089593cbf626353947d5b1
            ]
        );
    circuit_inputs = circuit_inputs
        .next(
            [
                0x620a00022e01fffffffeffff,
                0xddb3a93be6f89688de17d813,
                0xdf76ce51ba69c6076a0f77ea,
                0x5f19672f
            ]
        );
    circuit_inputs = circuit_inputs
        .next(
            [
                0xe5d80be9902109f7dbc79812,
                0xefeedc2e0124838bdccf325e,
                0xd7a2fffc9072bb5785a686bc,
                0xd5e1c086ffe8016d063c6da
            ]
        );
    circuit_inputs = circuit_inputs
        .next(
            [
                0x4f49fffd8bfd00000000aaad,
                0x897d29650fb85f9b409427eb,
                0x63d4de85aa0d857d89759ad4,
                0x1a0111ea397fe699ec024086
            ]
        );
    circuit_inputs = circuit_inputs
        .next(
            [
                0xed3ffffb5dfb00000001aaaf,
                0xabc9802928bfc912627c4fd7,
                0x845e1033efa3bf761f6622e9,
                0x1a0111ea397fe6998ce8d956
            ]
        );
    circuit_inputs = circuit_inputs
        .next(
            [
                0x4aff0e653631f5d3000f022c,
                0x17d5be9b1d380acd8c747cdc,
                0x9163c08be7302c4818171fdd,
                0xb659fb20274bfb1be8ff4d6
            ]
        );
    circuit_inputs = circuit_inputs
        .next(
            [
                0xb153ffffb9feffffffffaaaa,
                0x6730d2a0f6b0f6241eabfffe,
                0x434bacd764774b84f38512bf,
                0x1a0111ea397fe69a4b1ba7b6
            ]
        );
    circuit_inputs = circuit_inputs
        .next(
            [
                0x4d6c7ec22cf78a126ddc4af3,
                0xec0c8ec971f63c5f282d5ac1,
                0x231f9fb854a14787b6c7b36f,
                0xfc3e2b36c4e03288e9e902
            ]
        );
    circuit_inputs = circuit_inputs
        .next(
            [
                0x9ad8fd8459ef1424dbb895e6,
                0xd8191d92e3ec78be505ab582,
                0x463f3f70a9428f0f6d8f66df,
                0x1f87c566d89c06511d3d204
            ]
        );
    circuit_inputs = circuit_inputs
        .next(
            [
                0x4f49fffd8bfd00000000aaac,
                0x897d29650fb85f9b409427eb,
                0x63d4de85aa0d857d89759ad4,
                0x1a0111ea397fe699ec024086
            ]
        );
    circuit_inputs = circuit_inputs
        .next(
            [
                0x72ec05f4c81084fbede3cc09,
                0x77f76e17009241c5ee67992f,
                0x6bd17ffe48395dabc2d3435e,
                0x6af0e0437ff400b6831e36d
            ]
        );
    circuit_inputs = circuit_inputs
        .next(
            [
                0x620a00022e01fffffffefffe,
                0xddb3a93be6f89688de17d813,
                0xdf76ce51ba69c6076a0f77ea,
                0x5f19672f
            ]
        );
    circuit_inputs = circuit_inputs
        .next(
            [
                0x8bd478cd1ee605167ff82995,
                0xdb45f3536814f0bd5871c190,
                0xfa99cc9170df3560e77982d0,
                0x144e4211384586c16bd3ad4a
            ]
        );
    circuit_inputs = circuit_inputs
        .next(
            [
                0x6654f19a83cd0a2cfff0a87f,
                0x4f5b1405d978eb5692378322,
                0xb1e7ec4b7d471f3cdb6df2e2,
                0xe9b7238370b26e88c8bb2df
            ]
        );
    circuit_inputs = circuit_inputs.next(lambda_root_inverse.w0);
    circuit_inputs = circuit_inputs.next(lambda_root_inverse.w1);
    circuit_inputs = circuit_inputs.next(lambda_root_inverse.w2);
    circuit_inputs = circuit_inputs.next(lambda_root_inverse.w3);
    circuit_inputs = circuit_inputs.next(lambda_root_inverse.w4);
    circuit_inputs = circuit_inputs.next(lambda_root_inverse.w5);
    circuit_inputs = circuit_inputs.next(lambda_root_inverse.w6);
    circuit_inputs = circuit_inputs.next(lambda_root_inverse.w7);
    circuit_inputs = circuit_inputs.next(lambda_root_inverse.w8);
    circuit_inputs = circuit_inputs.next(lambda_root_inverse.w9);
    circuit_inputs = circuit_inputs.next(lambda_root_inverse.w10);
    circuit_inputs = circuit_inputs.next(lambda_root_inverse.w11);
    circuit_inputs = circuit_inputs.next(z);
    circuit_inputs = circuit_inputs.next(scaling_factor.w0);
    circuit_inputs = circuit_inputs.next(scaling_factor.w2);
    circuit_inputs = circuit_inputs.next(scaling_factor.w4);
    circuit_inputs = circuit_inputs.next(scaling_factor.w6);
    circuit_inputs = circuit_inputs.next(scaling_factor.w8);
    circuit_inputs = circuit_inputs.next(scaling_factor.w10);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let c_inv_of_z: u384 = outputs.get_output(t37);

    let scaling_factor_of_z: u384 = outputs.get_output(t47);

    let c_inv_frob_1_of_z: u384 = outputs.get_output(t94);
    return (c_inv_of_z, scaling_factor_of_z, c_inv_frob_1_of_z);
}
fn run_BLS12_381_MP_CHECK_PREPARE_PAIRS_2_circuit(
    p_0: G1Point, p_1: G1Point
) -> (BLSProcessedPair, BLSProcessedPair) {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0x0

    // INPUT stack
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let t0 = circuit_inverse(in2);
    let t1 = circuit_mul(in1, t0);
    let t2 = circuit_sub(in0, t1);
    let t3 = circuit_inverse(in4);
    let t4 = circuit_mul(in3, t3);
    let t5 = circuit_sub(in0, t4);

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [
            54880396502181392957329877675,
            31935979117156477062286671870,
            20826981314825584179608359615,
            8047903782086192180586325942
        ]
    )
        .unwrap();

    let mut circuit_inputs = (t0, t2, t3, t5,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(p_0.x);
    circuit_inputs = circuit_inputs.next(p_0.y);
    circuit_inputs = circuit_inputs.next(p_1.x);
    circuit_inputs = circuit_inputs.next(p_1.y);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let p_0: BLSProcessedPair = BLSProcessedPair {
        yInv: outputs.get_output(t0), xNegOverY: outputs.get_output(t2)
    };

    let p_1: BLSProcessedPair = BLSProcessedPair {
        yInv: outputs.get_output(t3), xNegOverY: outputs.get_output(t5)
    };
    return (p_0, p_1);
}
fn run_BLS12_381_MP_CHECK_PREPARE_PAIRS_3_circuit(
    p_0: G1Point, p_1: G1Point, p_2: G1Point
) -> (BLSProcessedPair, BLSProcessedPair, BLSProcessedPair) {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0x0

    // INPUT stack
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let t0 = circuit_inverse(in2);
    let t1 = circuit_mul(in1, t0);
    let t2 = circuit_sub(in0, t1);
    let t3 = circuit_inverse(in4);
    let t4 = circuit_mul(in3, t3);
    let t5 = circuit_sub(in0, t4);
    let t6 = circuit_inverse(in6);
    let t7 = circuit_mul(in5, t6);
    let t8 = circuit_sub(in0, t7);

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [
            54880396502181392957329877675,
            31935979117156477062286671870,
            20826981314825584179608359615,
            8047903782086192180586325942
        ]
    )
        .unwrap();

    let mut circuit_inputs = (t0, t2, t3, t5, t6, t8,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(p_0.x);
    circuit_inputs = circuit_inputs.next(p_0.y);
    circuit_inputs = circuit_inputs.next(p_1.x);
    circuit_inputs = circuit_inputs.next(p_1.y);
    circuit_inputs = circuit_inputs.next(p_2.x);
    circuit_inputs = circuit_inputs.next(p_2.y);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let p_0: BLSProcessedPair = BLSProcessedPair {
        yInv: outputs.get_output(t0), xNegOverY: outputs.get_output(t2)
    };

    let p_1: BLSProcessedPair = BLSProcessedPair {
        yInv: outputs.get_output(t3), xNegOverY: outputs.get_output(t5)
    };

    let p_2: BLSProcessedPair = BLSProcessedPair {
        yInv: outputs.get_output(t6), xNegOverY: outputs.get_output(t8)
    };
    return (p_0, p_1, p_2);
}
fn run_BN254_MP_CHECK_BIT0_LOOP_2_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    Q0: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q1: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one: E12D,
    ci: u384,
    z: u384
) -> (G2Point, G2Point, u384, u384, u384) {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0x0
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 0x3
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 0x6
    let in3 = CircuitElement::<CircuitInput<3>> {}; // -0x9 % p
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 0x1

    // INPUT stack
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
    let in9 = CircuitElement::<CircuitInput<9>> {}; // 
    let in10 = CircuitElement::<CircuitInput<10>> {}; // 
    let in11 = CircuitElement::<CircuitInput<11>> {}; // 
    let in12 = CircuitElement::<CircuitInput<12>> {}; // 
    let in13 = CircuitElement::<CircuitInput<13>> {}; // 
    let in14 = CircuitElement::<CircuitInput<14>> {}; // 
    let in15 = CircuitElement::<CircuitInput<15>> {}; // 
    let in16 = CircuitElement::<CircuitInput<16>> {}; // 
    let in17 = CircuitElement::<CircuitInput<17>> {}; // 
    let in18 = CircuitElement::<CircuitInput<18>> {}; // 
    let in19 = CircuitElement::<CircuitInput<19>> {}; // 
    let in20 = CircuitElement::<CircuitInput<20>> {}; // 
    let in21 = CircuitElement::<CircuitInput<21>> {}; // 
    let in22 = CircuitElement::<CircuitInput<22>> {}; // 
    let in23 = CircuitElement::<CircuitInput<23>> {}; // 
    let in24 = CircuitElement::<CircuitInput<24>> {}; // 
    let in25 = CircuitElement::<CircuitInput<25>> {}; // 
    let in26 = CircuitElement::<CircuitInput<26>> {}; // 
    let in27 = CircuitElement::<CircuitInput<27>> {}; // 
    let in28 = CircuitElement::<CircuitInput<28>> {}; // 
    let in29 = CircuitElement::<CircuitInput<29>> {}; // 
    let in30 = CircuitElement::<CircuitInput<30>> {}; // 
    let in31 = CircuitElement::<CircuitInput<31>> {}; // 
    let in32 = CircuitElement::<CircuitInput<32>> {}; // 
    let t0 = circuit_mul(in32, in32); // Compute z^2
    let t1 = circuit_mul(t0, in32); // Compute z^3
    let t2 = circuit_mul(t1, in32); // Compute z^4
    let t3 = circuit_mul(t2, in32); // Compute z^5
    let t4 = circuit_mul(t3, in32); // Compute z^6
    let t5 = circuit_mul(t4, in32); // Compute z^7
    let t6 = circuit_mul(t5, in32); // Compute z^8
    let t7 = circuit_mul(t6, in32); // Compute z^9
    let t8 = circuit_mul(t7, in32); // Compute z^10
    let t9 = circuit_mul(t8, in32); // Compute z^11
    let t10 = circuit_mul(in31, in31); // Compute c_i = (c_(i-1))^2
    let t11 = circuit_mul(in18, in18); // Square f evaluation in Z, the result of previous bit.
    let t12 = circuit_add(in7, in8); // Doubling slope numerator start
    let t13 = circuit_sub(in7, in8);
    let t14 = circuit_mul(t12, t13);
    let t15 = circuit_mul(in7, in8);
    let t16 = circuit_mul(t14, in1);
    let t17 = circuit_mul(t15, in2); // Doubling slope numerator end
    let t18 = circuit_add(in9, in9); // Fp2 add coeff 0/1
    let t19 = circuit_add(in10, in10); // Fp2 add coeff 1/1
    let t20 = circuit_mul(t18, t18); // Fp2 Div x/y start : Fp2 Inv y start
    let t21 = circuit_mul(t19, t19);
    let t22 = circuit_add(t20, t21);
    let t23 = circuit_inverse(t22);
    let t24 = circuit_mul(t18, t23); // Fp2 Inv y real part end
    let t25 = circuit_mul(t19, t23);
    let t26 = circuit_sub(in0, t25); // Fp2 Inv y imag part end
    let t27 = circuit_mul(t16, t24); // Fp2 mul start
    let t28 = circuit_mul(t17, t26);
    let t29 = circuit_sub(t27, t28); // Fp2 mul real part end
    let t30 = circuit_mul(t16, t26);
    let t31 = circuit_mul(t17, t24);
    let t32 = circuit_add(t30, t31); // Fp2 mul imag part end
    let t33 = circuit_add(t29, t32);
    let t34 = circuit_sub(t29, t32);
    let t35 = circuit_mul(t33, t34);
    let t36 = circuit_mul(t29, t32);
    let t37 = circuit_add(t36, t36);
    let t38 = circuit_add(in7, in7); // Fp2 add coeff 0/1
    let t39 = circuit_add(in8, in8); // Fp2 add coeff 1/1
    let t40 = circuit_sub(t35, t38); // Fp2 sub coeff 0/1
    let t41 = circuit_sub(t37, t39); // Fp2 sub coeff 1/1
    let t42 = circuit_sub(in7, t40); // Fp2 sub coeff 0/1
    let t43 = circuit_sub(in8, t41); // Fp2 sub coeff 1/1
    let t44 = circuit_mul(t29, t42); // Fp2 mul start
    let t45 = circuit_mul(t32, t43);
    let t46 = circuit_sub(t44, t45); // Fp2 mul real part end
    let t47 = circuit_mul(t29, t43);
    let t48 = circuit_mul(t32, t42);
    let t49 = circuit_add(t47, t48); // Fp2 mul imag part end
    let t50 = circuit_sub(t46, in9); // Fp2 sub coeff 0/1
    let t51 = circuit_sub(t49, in10); // Fp2 sub coeff 1/1
    let t52 = circuit_mul(t29, in7); // Fp2 mul start
    let t53 = circuit_mul(t32, in8);
    let t54 = circuit_sub(t52, t53); // Fp2 mul real part end
    let t55 = circuit_mul(t29, in8);
    let t56 = circuit_mul(t32, in7);
    let t57 = circuit_add(t55, t56); // Fp2 mul imag part end
    let t58 = circuit_sub(t54, in9); // Fp2 sub coeff 0/1
    let t59 = circuit_sub(t57, in10); // Fp2 sub coeff 1/1
    let t60 = circuit_mul(in3, t32);
    let t61 = circuit_add(t29, t60);
    let t62 = circuit_mul(t61, in6);
    let t63 = circuit_mul(in3, t59);
    let t64 = circuit_add(t58, t63);
    let t65 = circuit_mul(t64, in5);
    let t66 = circuit_mul(t32, in6);
    let t67 = circuit_mul(t59, in5);
    let t68 = circuit_mul(t62, in32); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t69 = circuit_add(in4, t68); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t70 = circuit_mul(t65, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t71 = circuit_add(t69, t70); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t72 = circuit_mul(t66, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t73 = circuit_add(t71, t72); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t74 = circuit_mul(t67, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t75 = circuit_add(t73, t74); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t76 = circuit_mul(t11, t75); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_0(z)
    let t77 = circuit_add(in13, in14); // Doubling slope numerator start
    let t78 = circuit_sub(in13, in14);
    let t79 = circuit_mul(t77, t78);
    let t80 = circuit_mul(in13, in14);
    let t81 = circuit_mul(t79, in1);
    let t82 = circuit_mul(t80, in2); // Doubling slope numerator end
    let t83 = circuit_add(in15, in15); // Fp2 add coeff 0/1
    let t84 = circuit_add(in16, in16); // Fp2 add coeff 1/1
    let t85 = circuit_mul(t83, t83); // Fp2 Div x/y start : Fp2 Inv y start
    let t86 = circuit_mul(t84, t84);
    let t87 = circuit_add(t85, t86);
    let t88 = circuit_inverse(t87);
    let t89 = circuit_mul(t83, t88); // Fp2 Inv y real part end
    let t90 = circuit_mul(t84, t88);
    let t91 = circuit_sub(in0, t90); // Fp2 Inv y imag part end
    let t92 = circuit_mul(t81, t89); // Fp2 mul start
    let t93 = circuit_mul(t82, t91);
    let t94 = circuit_sub(t92, t93); // Fp2 mul real part end
    let t95 = circuit_mul(t81, t91);
    let t96 = circuit_mul(t82, t89);
    let t97 = circuit_add(t95, t96); // Fp2 mul imag part end
    let t98 = circuit_add(t94, t97);
    let t99 = circuit_sub(t94, t97);
    let t100 = circuit_mul(t98, t99);
    let t101 = circuit_mul(t94, t97);
    let t102 = circuit_add(t101, t101);
    let t103 = circuit_add(in13, in13); // Fp2 add coeff 0/1
    let t104 = circuit_add(in14, in14); // Fp2 add coeff 1/1
    let t105 = circuit_sub(t100, t103); // Fp2 sub coeff 0/1
    let t106 = circuit_sub(t102, t104); // Fp2 sub coeff 1/1
    let t107 = circuit_sub(in13, t105); // Fp2 sub coeff 0/1
    let t108 = circuit_sub(in14, t106); // Fp2 sub coeff 1/1
    let t109 = circuit_mul(t94, t107); // Fp2 mul start
    let t110 = circuit_mul(t97, t108);
    let t111 = circuit_sub(t109, t110); // Fp2 mul real part end
    let t112 = circuit_mul(t94, t108);
    let t113 = circuit_mul(t97, t107);
    let t114 = circuit_add(t112, t113); // Fp2 mul imag part end
    let t115 = circuit_sub(t111, in15); // Fp2 sub coeff 0/1
    let t116 = circuit_sub(t114, in16); // Fp2 sub coeff 1/1
    let t117 = circuit_mul(t94, in13); // Fp2 mul start
    let t118 = circuit_mul(t97, in14);
    let t119 = circuit_sub(t117, t118); // Fp2 mul real part end
    let t120 = circuit_mul(t94, in14);
    let t121 = circuit_mul(t97, in13);
    let t122 = circuit_add(t120, t121); // Fp2 mul imag part end
    let t123 = circuit_sub(t119, in15); // Fp2 sub coeff 0/1
    let t124 = circuit_sub(t122, in16); // Fp2 sub coeff 1/1
    let t125 = circuit_mul(in3, t97);
    let t126 = circuit_add(t94, t125);
    let t127 = circuit_mul(t126, in12);
    let t128 = circuit_mul(in3, t124);
    let t129 = circuit_add(t123, t128);
    let t130 = circuit_mul(t129, in11);
    let t131 = circuit_mul(t97, in12);
    let t132 = circuit_mul(t124, in11);
    let t133 = circuit_mul(t127, in32); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t134 = circuit_add(in4, t133); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t135 = circuit_mul(t130, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t136 = circuit_add(t134, t135); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t137 = circuit_mul(t131, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t138 = circuit_add(t136, t137); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t139 = circuit_mul(t132, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t140 = circuit_add(t138, t139); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t141 = circuit_mul(t76, t140); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_1(z)
    let t142 = circuit_mul(in20, in32); // Eval UnnamedPoly step coeff_1 * z^1
    let t143 = circuit_add(in19, t142); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t144 = circuit_mul(in21, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t145 = circuit_add(t143, t144); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t146 = circuit_mul(in22, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t147 = circuit_add(t145, t146); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t148 = circuit_mul(in23, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t149 = circuit_add(t147, t148); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t150 = circuit_mul(in24, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t151 = circuit_add(t149, t150); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t152 = circuit_mul(in25, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t153 = circuit_add(t151, t152); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t154 = circuit_mul(in26, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t155 = circuit_add(t153, t154); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t156 = circuit_mul(in27, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t157 = circuit_add(t155, t156); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t158 = circuit_mul(in28, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t159 = circuit_add(t157, t158); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t160 = circuit_mul(in29, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t161 = circuit_add(t159, t160); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t162 = circuit_mul(in30, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t163 = circuit_add(t161, t162); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t164 = circuit_sub(t141, t163); // (Π(i,k) (Pk(z))) - Ri(z)
    let t165 = circuit_mul(t10, t164); // ci * ((Π(i,k) (Pk(z)) - Ri(z))
    let t166 = circuit_add(in17, t165); // LHS = LHS + ci * ((Π(i,k) (Pk(z)) - Ri(z))

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [32324006162389411176778628423, 57042285082623239461879769745, 3486998266802970665, 0]
    )
        .unwrap();

    let mut circuit_inputs = (t40, t41, t50, t51, t105, t106, t115, t116, t163, t166, t10,)
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x6, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x6871ca8d3c208c16d87cfd3e, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0]);
    circuit_inputs = circuit_inputs.next([0x1, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(Q0.x0);
    circuit_inputs = circuit_inputs.next(Q0.x1);
    circuit_inputs = circuit_inputs.next(Q0.y0);
    circuit_inputs = circuit_inputs.next(Q0.y1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(Q1.x0);
    circuit_inputs = circuit_inputs.next(Q1.x1);
    circuit_inputs = circuit_inputs.next(Q1.y0);
    circuit_inputs = circuit_inputs.next(Q1.y1);
    circuit_inputs = circuit_inputs.next(lhs_i);
    circuit_inputs = circuit_inputs.next(f_i_of_z);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w0);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w1);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w2);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w3);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w4);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w5);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w6);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w7);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w8);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w9);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w10);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w11);
    circuit_inputs = circuit_inputs.next(ci);
    circuit_inputs = circuit_inputs.next(z);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let Q0: G2Point = G2Point {
        x0: outputs.get_output(t40),
        x1: outputs.get_output(t41),
        y0: outputs.get_output(t50),
        y1: outputs.get_output(t51)
    };

    let Q1: G2Point = G2Point {
        x0: outputs.get_output(t105),
        x1: outputs.get_output(t106),
        y0: outputs.get_output(t115),
        y1: outputs.get_output(t116)
    };

    let f_i_plus_one_of_z: u384 = outputs.get_output(t163);

    let lhs_i_plus_one: u384 = outputs.get_output(t166);

    let ci_plus_one: u384 = outputs.get_output(t10);
    return (Q0, Q1, f_i_plus_one_of_z, lhs_i_plus_one, ci_plus_one);
}
fn run_BN254_MP_CHECK_BIT0_LOOP_3_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    Q0: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q1: G2Point,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q2: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one: E12D,
    ci: u384,
    z: u384
) -> (G2Point, G2Point, G2Point, u384, u384, u384) {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0x0
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 0x3
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 0x6
    let in3 = CircuitElement::<CircuitInput<3>> {}; // -0x9 % p
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 0x1

    // INPUT stack
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
    let in9 = CircuitElement::<CircuitInput<9>> {}; // 
    let in10 = CircuitElement::<CircuitInput<10>> {}; // 
    let in11 = CircuitElement::<CircuitInput<11>> {}; // 
    let in12 = CircuitElement::<CircuitInput<12>> {}; // 
    let in13 = CircuitElement::<CircuitInput<13>> {}; // 
    let in14 = CircuitElement::<CircuitInput<14>> {}; // 
    let in15 = CircuitElement::<CircuitInput<15>> {}; // 
    let in16 = CircuitElement::<CircuitInput<16>> {}; // 
    let in17 = CircuitElement::<CircuitInput<17>> {}; // 
    let in18 = CircuitElement::<CircuitInput<18>> {}; // 
    let in19 = CircuitElement::<CircuitInput<19>> {}; // 
    let in20 = CircuitElement::<CircuitInput<20>> {}; // 
    let in21 = CircuitElement::<CircuitInput<21>> {}; // 
    let in22 = CircuitElement::<CircuitInput<22>> {}; // 
    let in23 = CircuitElement::<CircuitInput<23>> {}; // 
    let in24 = CircuitElement::<CircuitInput<24>> {}; // 
    let in25 = CircuitElement::<CircuitInput<25>> {}; // 
    let in26 = CircuitElement::<CircuitInput<26>> {}; // 
    let in27 = CircuitElement::<CircuitInput<27>> {}; // 
    let in28 = CircuitElement::<CircuitInput<28>> {}; // 
    let in29 = CircuitElement::<CircuitInput<29>> {}; // 
    let in30 = CircuitElement::<CircuitInput<30>> {}; // 
    let in31 = CircuitElement::<CircuitInput<31>> {}; // 
    let in32 = CircuitElement::<CircuitInput<32>> {}; // 
    let in33 = CircuitElement::<CircuitInput<33>> {}; // 
    let in34 = CircuitElement::<CircuitInput<34>> {}; // 
    let in35 = CircuitElement::<CircuitInput<35>> {}; // 
    let in36 = CircuitElement::<CircuitInput<36>> {}; // 
    let in37 = CircuitElement::<CircuitInput<37>> {}; // 
    let in38 = CircuitElement::<CircuitInput<38>> {}; // 
    let t0 = circuit_mul(in38, in38); // Compute z^2
    let t1 = circuit_mul(t0, in38); // Compute z^3
    let t2 = circuit_mul(t1, in38); // Compute z^4
    let t3 = circuit_mul(t2, in38); // Compute z^5
    let t4 = circuit_mul(t3, in38); // Compute z^6
    let t5 = circuit_mul(t4, in38); // Compute z^7
    let t6 = circuit_mul(t5, in38); // Compute z^8
    let t7 = circuit_mul(t6, in38); // Compute z^9
    let t8 = circuit_mul(t7, in38); // Compute z^10
    let t9 = circuit_mul(t8, in38); // Compute z^11
    let t10 = circuit_mul(in37, in37); // Compute c_i = (c_(i-1))^2
    let t11 = circuit_mul(in24, in24); // Square f evaluation in Z, the result of previous bit.
    let t12 = circuit_add(in7, in8); // Doubling slope numerator start
    let t13 = circuit_sub(in7, in8);
    let t14 = circuit_mul(t12, t13);
    let t15 = circuit_mul(in7, in8);
    let t16 = circuit_mul(t14, in1);
    let t17 = circuit_mul(t15, in2); // Doubling slope numerator end
    let t18 = circuit_add(in9, in9); // Fp2 add coeff 0/1
    let t19 = circuit_add(in10, in10); // Fp2 add coeff 1/1
    let t20 = circuit_mul(t18, t18); // Fp2 Div x/y start : Fp2 Inv y start
    let t21 = circuit_mul(t19, t19);
    let t22 = circuit_add(t20, t21);
    let t23 = circuit_inverse(t22);
    let t24 = circuit_mul(t18, t23); // Fp2 Inv y real part end
    let t25 = circuit_mul(t19, t23);
    let t26 = circuit_sub(in0, t25); // Fp2 Inv y imag part end
    let t27 = circuit_mul(t16, t24); // Fp2 mul start
    let t28 = circuit_mul(t17, t26);
    let t29 = circuit_sub(t27, t28); // Fp2 mul real part end
    let t30 = circuit_mul(t16, t26);
    let t31 = circuit_mul(t17, t24);
    let t32 = circuit_add(t30, t31); // Fp2 mul imag part end
    let t33 = circuit_add(t29, t32);
    let t34 = circuit_sub(t29, t32);
    let t35 = circuit_mul(t33, t34);
    let t36 = circuit_mul(t29, t32);
    let t37 = circuit_add(t36, t36);
    let t38 = circuit_add(in7, in7); // Fp2 add coeff 0/1
    let t39 = circuit_add(in8, in8); // Fp2 add coeff 1/1
    let t40 = circuit_sub(t35, t38); // Fp2 sub coeff 0/1
    let t41 = circuit_sub(t37, t39); // Fp2 sub coeff 1/1
    let t42 = circuit_sub(in7, t40); // Fp2 sub coeff 0/1
    let t43 = circuit_sub(in8, t41); // Fp2 sub coeff 1/1
    let t44 = circuit_mul(t29, t42); // Fp2 mul start
    let t45 = circuit_mul(t32, t43);
    let t46 = circuit_sub(t44, t45); // Fp2 mul real part end
    let t47 = circuit_mul(t29, t43);
    let t48 = circuit_mul(t32, t42);
    let t49 = circuit_add(t47, t48); // Fp2 mul imag part end
    let t50 = circuit_sub(t46, in9); // Fp2 sub coeff 0/1
    let t51 = circuit_sub(t49, in10); // Fp2 sub coeff 1/1
    let t52 = circuit_mul(t29, in7); // Fp2 mul start
    let t53 = circuit_mul(t32, in8);
    let t54 = circuit_sub(t52, t53); // Fp2 mul real part end
    let t55 = circuit_mul(t29, in8);
    let t56 = circuit_mul(t32, in7);
    let t57 = circuit_add(t55, t56); // Fp2 mul imag part end
    let t58 = circuit_sub(t54, in9); // Fp2 sub coeff 0/1
    let t59 = circuit_sub(t57, in10); // Fp2 sub coeff 1/1
    let t60 = circuit_mul(in3, t32);
    let t61 = circuit_add(t29, t60);
    let t62 = circuit_mul(t61, in6);
    let t63 = circuit_mul(in3, t59);
    let t64 = circuit_add(t58, t63);
    let t65 = circuit_mul(t64, in5);
    let t66 = circuit_mul(t32, in6);
    let t67 = circuit_mul(t59, in5);
    let t68 = circuit_mul(t62, in38); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t69 = circuit_add(in4, t68); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t70 = circuit_mul(t65, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t71 = circuit_add(t69, t70); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t72 = circuit_mul(t66, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t73 = circuit_add(t71, t72); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t74 = circuit_mul(t67, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t75 = circuit_add(t73, t74); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t76 = circuit_mul(t11, t75); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_0(z)
    let t77 = circuit_add(in13, in14); // Doubling slope numerator start
    let t78 = circuit_sub(in13, in14);
    let t79 = circuit_mul(t77, t78);
    let t80 = circuit_mul(in13, in14);
    let t81 = circuit_mul(t79, in1);
    let t82 = circuit_mul(t80, in2); // Doubling slope numerator end
    let t83 = circuit_add(in15, in15); // Fp2 add coeff 0/1
    let t84 = circuit_add(in16, in16); // Fp2 add coeff 1/1
    let t85 = circuit_mul(t83, t83); // Fp2 Div x/y start : Fp2 Inv y start
    let t86 = circuit_mul(t84, t84);
    let t87 = circuit_add(t85, t86);
    let t88 = circuit_inverse(t87);
    let t89 = circuit_mul(t83, t88); // Fp2 Inv y real part end
    let t90 = circuit_mul(t84, t88);
    let t91 = circuit_sub(in0, t90); // Fp2 Inv y imag part end
    let t92 = circuit_mul(t81, t89); // Fp2 mul start
    let t93 = circuit_mul(t82, t91);
    let t94 = circuit_sub(t92, t93); // Fp2 mul real part end
    let t95 = circuit_mul(t81, t91);
    let t96 = circuit_mul(t82, t89);
    let t97 = circuit_add(t95, t96); // Fp2 mul imag part end
    let t98 = circuit_add(t94, t97);
    let t99 = circuit_sub(t94, t97);
    let t100 = circuit_mul(t98, t99);
    let t101 = circuit_mul(t94, t97);
    let t102 = circuit_add(t101, t101);
    let t103 = circuit_add(in13, in13); // Fp2 add coeff 0/1
    let t104 = circuit_add(in14, in14); // Fp2 add coeff 1/1
    let t105 = circuit_sub(t100, t103); // Fp2 sub coeff 0/1
    let t106 = circuit_sub(t102, t104); // Fp2 sub coeff 1/1
    let t107 = circuit_sub(in13, t105); // Fp2 sub coeff 0/1
    let t108 = circuit_sub(in14, t106); // Fp2 sub coeff 1/1
    let t109 = circuit_mul(t94, t107); // Fp2 mul start
    let t110 = circuit_mul(t97, t108);
    let t111 = circuit_sub(t109, t110); // Fp2 mul real part end
    let t112 = circuit_mul(t94, t108);
    let t113 = circuit_mul(t97, t107);
    let t114 = circuit_add(t112, t113); // Fp2 mul imag part end
    let t115 = circuit_sub(t111, in15); // Fp2 sub coeff 0/1
    let t116 = circuit_sub(t114, in16); // Fp2 sub coeff 1/1
    let t117 = circuit_mul(t94, in13); // Fp2 mul start
    let t118 = circuit_mul(t97, in14);
    let t119 = circuit_sub(t117, t118); // Fp2 mul real part end
    let t120 = circuit_mul(t94, in14);
    let t121 = circuit_mul(t97, in13);
    let t122 = circuit_add(t120, t121); // Fp2 mul imag part end
    let t123 = circuit_sub(t119, in15); // Fp2 sub coeff 0/1
    let t124 = circuit_sub(t122, in16); // Fp2 sub coeff 1/1
    let t125 = circuit_mul(in3, t97);
    let t126 = circuit_add(t94, t125);
    let t127 = circuit_mul(t126, in12);
    let t128 = circuit_mul(in3, t124);
    let t129 = circuit_add(t123, t128);
    let t130 = circuit_mul(t129, in11);
    let t131 = circuit_mul(t97, in12);
    let t132 = circuit_mul(t124, in11);
    let t133 = circuit_mul(t127, in38); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t134 = circuit_add(in4, t133); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t135 = circuit_mul(t130, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t136 = circuit_add(t134, t135); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t137 = circuit_mul(t131, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t138 = circuit_add(t136, t137); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t139 = circuit_mul(t132, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t140 = circuit_add(t138, t139); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t141 = circuit_mul(t76, t140); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_1(z)
    let t142 = circuit_add(in19, in20); // Doubling slope numerator start
    let t143 = circuit_sub(in19, in20);
    let t144 = circuit_mul(t142, t143);
    let t145 = circuit_mul(in19, in20);
    let t146 = circuit_mul(t144, in1);
    let t147 = circuit_mul(t145, in2); // Doubling slope numerator end
    let t148 = circuit_add(in21, in21); // Fp2 add coeff 0/1
    let t149 = circuit_add(in22, in22); // Fp2 add coeff 1/1
    let t150 = circuit_mul(t148, t148); // Fp2 Div x/y start : Fp2 Inv y start
    let t151 = circuit_mul(t149, t149);
    let t152 = circuit_add(t150, t151);
    let t153 = circuit_inverse(t152);
    let t154 = circuit_mul(t148, t153); // Fp2 Inv y real part end
    let t155 = circuit_mul(t149, t153);
    let t156 = circuit_sub(in0, t155); // Fp2 Inv y imag part end
    let t157 = circuit_mul(t146, t154); // Fp2 mul start
    let t158 = circuit_mul(t147, t156);
    let t159 = circuit_sub(t157, t158); // Fp2 mul real part end
    let t160 = circuit_mul(t146, t156);
    let t161 = circuit_mul(t147, t154);
    let t162 = circuit_add(t160, t161); // Fp2 mul imag part end
    let t163 = circuit_add(t159, t162);
    let t164 = circuit_sub(t159, t162);
    let t165 = circuit_mul(t163, t164);
    let t166 = circuit_mul(t159, t162);
    let t167 = circuit_add(t166, t166);
    let t168 = circuit_add(in19, in19); // Fp2 add coeff 0/1
    let t169 = circuit_add(in20, in20); // Fp2 add coeff 1/1
    let t170 = circuit_sub(t165, t168); // Fp2 sub coeff 0/1
    let t171 = circuit_sub(t167, t169); // Fp2 sub coeff 1/1
    let t172 = circuit_sub(in19, t170); // Fp2 sub coeff 0/1
    let t173 = circuit_sub(in20, t171); // Fp2 sub coeff 1/1
    let t174 = circuit_mul(t159, t172); // Fp2 mul start
    let t175 = circuit_mul(t162, t173);
    let t176 = circuit_sub(t174, t175); // Fp2 mul real part end
    let t177 = circuit_mul(t159, t173);
    let t178 = circuit_mul(t162, t172);
    let t179 = circuit_add(t177, t178); // Fp2 mul imag part end
    let t180 = circuit_sub(t176, in21); // Fp2 sub coeff 0/1
    let t181 = circuit_sub(t179, in22); // Fp2 sub coeff 1/1
    let t182 = circuit_mul(t159, in19); // Fp2 mul start
    let t183 = circuit_mul(t162, in20);
    let t184 = circuit_sub(t182, t183); // Fp2 mul real part end
    let t185 = circuit_mul(t159, in20);
    let t186 = circuit_mul(t162, in19);
    let t187 = circuit_add(t185, t186); // Fp2 mul imag part end
    let t188 = circuit_sub(t184, in21); // Fp2 sub coeff 0/1
    let t189 = circuit_sub(t187, in22); // Fp2 sub coeff 1/1
    let t190 = circuit_mul(in3, t162);
    let t191 = circuit_add(t159, t190);
    let t192 = circuit_mul(t191, in18);
    let t193 = circuit_mul(in3, t189);
    let t194 = circuit_add(t188, t193);
    let t195 = circuit_mul(t194, in17);
    let t196 = circuit_mul(t162, in18);
    let t197 = circuit_mul(t189, in17);
    let t198 = circuit_mul(t192, in38); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t199 = circuit_add(in4, t198); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t200 = circuit_mul(t195, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t201 = circuit_add(t199, t200); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t202 = circuit_mul(t196, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t203 = circuit_add(t201, t202); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t204 = circuit_mul(t197, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t205 = circuit_add(t203, t204); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t206 = circuit_mul(t141, t205); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_2(z)
    let t207 = circuit_mul(in26, in38); // Eval UnnamedPoly step coeff_1 * z^1
    let t208 = circuit_add(in25, t207); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t209 = circuit_mul(in27, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t210 = circuit_add(t208, t209); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t211 = circuit_mul(in28, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t212 = circuit_add(t210, t211); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t213 = circuit_mul(in29, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t214 = circuit_add(t212, t213); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t215 = circuit_mul(in30, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t216 = circuit_add(t214, t215); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t217 = circuit_mul(in31, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t218 = circuit_add(t216, t217); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t219 = circuit_mul(in32, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t220 = circuit_add(t218, t219); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t221 = circuit_mul(in33, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t222 = circuit_add(t220, t221); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t223 = circuit_mul(in34, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t224 = circuit_add(t222, t223); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t225 = circuit_mul(in35, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t226 = circuit_add(t224, t225); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t227 = circuit_mul(in36, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t228 = circuit_add(t226, t227); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t229 = circuit_sub(t206, t228); // (Π(i,k) (Pk(z))) - Ri(z)
    let t230 = circuit_mul(t10, t229); // ci * ((Π(i,k) (Pk(z)) - Ri(z))
    let t231 = circuit_add(in23, t230); // LHS = LHS + ci * ((Π(i,k) (Pk(z)) - Ri(z))

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [32324006162389411176778628423, 57042285082623239461879769745, 3486998266802970665, 0]
    )
        .unwrap();

    let mut circuit_inputs = (
        t40, t41, t50, t51, t105, t106, t115, t116, t170, t171, t180, t181, t228, t231, t10,
    )
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x6, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x6871ca8d3c208c16d87cfd3e, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0]);
    circuit_inputs = circuit_inputs.next([0x1, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(Q0.x0);
    circuit_inputs = circuit_inputs.next(Q0.x1);
    circuit_inputs = circuit_inputs.next(Q0.y0);
    circuit_inputs = circuit_inputs.next(Q0.y1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(Q1.x0);
    circuit_inputs = circuit_inputs.next(Q1.x1);
    circuit_inputs = circuit_inputs.next(Q1.y0);
    circuit_inputs = circuit_inputs.next(Q1.y1);
    circuit_inputs = circuit_inputs.next(yInv_2);
    circuit_inputs = circuit_inputs.next(xNegOverY_2);
    circuit_inputs = circuit_inputs.next(Q2.x0);
    circuit_inputs = circuit_inputs.next(Q2.x1);
    circuit_inputs = circuit_inputs.next(Q2.y0);
    circuit_inputs = circuit_inputs.next(Q2.y1);
    circuit_inputs = circuit_inputs.next(lhs_i);
    circuit_inputs = circuit_inputs.next(f_i_of_z);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w0);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w1);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w2);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w3);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w4);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w5);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w6);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w7);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w8);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w9);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w10);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w11);
    circuit_inputs = circuit_inputs.next(ci);
    circuit_inputs = circuit_inputs.next(z);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let Q0: G2Point = G2Point {
        x0: outputs.get_output(t40),
        x1: outputs.get_output(t41),
        y0: outputs.get_output(t50),
        y1: outputs.get_output(t51)
    };

    let Q1: G2Point = G2Point {
        x0: outputs.get_output(t105),
        x1: outputs.get_output(t106),
        y0: outputs.get_output(t115),
        y1: outputs.get_output(t116)
    };

    let Q2: G2Point = G2Point {
        x0: outputs.get_output(t170),
        x1: outputs.get_output(t171),
        y0: outputs.get_output(t180),
        y1: outputs.get_output(t181)
    };

    let f_i_plus_one_of_z: u384 = outputs.get_output(t228);

    let lhs_i_plus_one: u384 = outputs.get_output(t231);

    let ci_plus_one: u384 = outputs.get_output(t10);
    return (Q0, Q1, Q2, f_i_plus_one_of_z, lhs_i_plus_one, ci_plus_one);
}
fn run_BN254_MP_CHECK_BIT1_LOOP_2_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    Q0: G2Point,
    Q_or_Qneg_0: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q1: G2Point,
    Q_or_Qneg_1: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one: E12D,
    c_or_cinv_of_z: u384,
    z: u384,
    ci: u384
) -> (G2Point, G2Point, u384, u384, u384) {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0x0
    let in1 = CircuitElement::<CircuitInput<1>> {}; // -0x9 % p
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 0x1

    // INPUT stack
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
    let in9 = CircuitElement::<CircuitInput<9>> {}; // 
    let in10 = CircuitElement::<CircuitInput<10>> {}; // 
    let in11 = CircuitElement::<CircuitInput<11>> {}; // 
    let in12 = CircuitElement::<CircuitInput<12>> {}; // 
    let in13 = CircuitElement::<CircuitInput<13>> {}; // 
    let in14 = CircuitElement::<CircuitInput<14>> {}; // 
    let in15 = CircuitElement::<CircuitInput<15>> {}; // 
    let in16 = CircuitElement::<CircuitInput<16>> {}; // 
    let in17 = CircuitElement::<CircuitInput<17>> {}; // 
    let in18 = CircuitElement::<CircuitInput<18>> {}; // 
    let in19 = CircuitElement::<CircuitInput<19>> {}; // 
    let in20 = CircuitElement::<CircuitInput<20>> {}; // 
    let in21 = CircuitElement::<CircuitInput<21>> {}; // 
    let in22 = CircuitElement::<CircuitInput<22>> {}; // 
    let in23 = CircuitElement::<CircuitInput<23>> {}; // 
    let in24 = CircuitElement::<CircuitInput<24>> {}; // 
    let in25 = CircuitElement::<CircuitInput<25>> {}; // 
    let in26 = CircuitElement::<CircuitInput<26>> {}; // 
    let in27 = CircuitElement::<CircuitInput<27>> {}; // 
    let in28 = CircuitElement::<CircuitInput<28>> {}; // 
    let in29 = CircuitElement::<CircuitInput<29>> {}; // 
    let in30 = CircuitElement::<CircuitInput<30>> {}; // 
    let in31 = CircuitElement::<CircuitInput<31>> {}; // 
    let in32 = CircuitElement::<CircuitInput<32>> {}; // 
    let in33 = CircuitElement::<CircuitInput<33>> {}; // 
    let in34 = CircuitElement::<CircuitInput<34>> {}; // 
    let in35 = CircuitElement::<CircuitInput<35>> {}; // 
    let in36 = CircuitElement::<CircuitInput<36>> {}; // 
    let in37 = CircuitElement::<CircuitInput<37>> {}; // 
    let in38 = CircuitElement::<CircuitInput<38>> {}; // 
    let in39 = CircuitElement::<CircuitInput<39>> {}; // 
    let t0 = circuit_mul(in38, in38); // Compute z^2
    let t1 = circuit_mul(t0, in38); // Compute z^3
    let t2 = circuit_mul(t1, in38); // Compute z^4
    let t3 = circuit_mul(t2, in38); // Compute z^5
    let t4 = circuit_mul(t3, in38); // Compute z^6
    let t5 = circuit_mul(t4, in38); // Compute z^7
    let t6 = circuit_mul(t5, in38); // Compute z^8
    let t7 = circuit_mul(t6, in38); // Compute z^9
    let t8 = circuit_mul(t7, in38); // Compute z^10
    let t9 = circuit_mul(t8, in38); // Compute z^11
    let t10 = circuit_mul(in39, in39);
    let t11 = circuit_mul(in24, in24);
    let t12 = circuit_sub(in7, in11); // Fp2 sub coeff 0/1
    let t13 = circuit_sub(in8, in12); // Fp2 sub coeff 1/1
    let t14 = circuit_sub(in5, in9); // Fp2 sub coeff 0/1
    let t15 = circuit_sub(in6, in10); // Fp2 sub coeff 1/1
    let t16 = circuit_mul(t14, t14); // Fp2 Div x/y start : Fp2 Inv y start
    let t17 = circuit_mul(t15, t15);
    let t18 = circuit_add(t16, t17);
    let t19 = circuit_inverse(t18);
    let t20 = circuit_mul(t14, t19); // Fp2 Inv y real part end
    let t21 = circuit_mul(t15, t19);
    let t22 = circuit_sub(in0, t21); // Fp2 Inv y imag part end
    let t23 = circuit_mul(t12, t20); // Fp2 mul start
    let t24 = circuit_mul(t13, t22);
    let t25 = circuit_sub(t23, t24); // Fp2 mul real part end
    let t26 = circuit_mul(t12, t22);
    let t27 = circuit_mul(t13, t20);
    let t28 = circuit_add(t26, t27); // Fp2 mul imag part end
    let t29 = circuit_add(t25, t28);
    let t30 = circuit_sub(t25, t28);
    let t31 = circuit_mul(t29, t30);
    let t32 = circuit_mul(t25, t28);
    let t33 = circuit_add(t32, t32);
    let t34 = circuit_add(in5, in9); // Fp2 add coeff 0/1
    let t35 = circuit_add(in6, in10); // Fp2 add coeff 1/1
    let t36 = circuit_sub(t31, t34); // Fp2 sub coeff 0/1
    let t37 = circuit_sub(t33, t35); // Fp2 sub coeff 1/1
    let t38 = circuit_mul(t25, in5); // Fp2 mul start
    let t39 = circuit_mul(t28, in6);
    let t40 = circuit_sub(t38, t39); // Fp2 mul real part end
    let t41 = circuit_mul(t25, in6);
    let t42 = circuit_mul(t28, in5);
    let t43 = circuit_add(t41, t42); // Fp2 mul imag part end
    let t44 = circuit_sub(t40, in7); // Fp2 sub coeff 0/1
    let t45 = circuit_sub(t43, in8); // Fp2 sub coeff 1/1
    let t46 = circuit_mul(in1, t28);
    let t47 = circuit_add(t25, t46);
    let t48 = circuit_mul(t47, in4);
    let t49 = circuit_mul(in1, t45);
    let t50 = circuit_add(t44, t49);
    let t51 = circuit_mul(t50, in3);
    let t52 = circuit_mul(t28, in4);
    let t53 = circuit_mul(t45, in3);
    let t54 = circuit_add(in7, in7); // Fp2 add coeff 0/1
    let t55 = circuit_add(in8, in8); // Fp2 add coeff 1/1
    let t56 = circuit_sub(t36, in5); // Fp2 sub coeff 0/1
    let t57 = circuit_sub(t37, in6); // Fp2 sub coeff 1/1
    let t58 = circuit_mul(t56, t56); // Fp2 Div x/y start : Fp2 Inv y start
    let t59 = circuit_mul(t57, t57);
    let t60 = circuit_add(t58, t59);
    let t61 = circuit_inverse(t60);
    let t62 = circuit_mul(t56, t61); // Fp2 Inv y real part end
    let t63 = circuit_mul(t57, t61);
    let t64 = circuit_sub(in0, t63); // Fp2 Inv y imag part end
    let t65 = circuit_mul(t54, t62); // Fp2 mul start
    let t66 = circuit_mul(t55, t64);
    let t67 = circuit_sub(t65, t66); // Fp2 mul real part end
    let t68 = circuit_mul(t54, t64);
    let t69 = circuit_mul(t55, t62);
    let t70 = circuit_add(t68, t69); // Fp2 mul imag part end
    let t71 = circuit_add(t25, t67); // Fp2 add coeff 0/1
    let t72 = circuit_add(t28, t70); // Fp2 add coeff 1/1
    let t73 = circuit_sub(in0, t71); // Fp2 neg coeff 0/1
    let t74 = circuit_sub(in0, t72); // Fp2 neg coeff 1/1
    let t75 = circuit_add(t73, t74);
    let t76 = circuit_sub(t73, t74);
    let t77 = circuit_mul(t75, t76);
    let t78 = circuit_mul(t73, t74);
    let t79 = circuit_add(t78, t78);
    let t80 = circuit_sub(t77, in5); // Fp2 sub coeff 0/1
    let t81 = circuit_sub(t79, in6); // Fp2 sub coeff 1/1
    let t82 = circuit_sub(t80, t36); // Fp2 sub coeff 0/1
    let t83 = circuit_sub(t81, t37); // Fp2 sub coeff 1/1
    let t84 = circuit_sub(in5, t82); // Fp2 sub coeff 0/1
    let t85 = circuit_sub(in6, t83); // Fp2 sub coeff 1/1
    let t86 = circuit_mul(t73, t84); // Fp2 mul start
    let t87 = circuit_mul(t74, t85);
    let t88 = circuit_sub(t86, t87); // Fp2 mul real part end
    let t89 = circuit_mul(t73, t85);
    let t90 = circuit_mul(t74, t84);
    let t91 = circuit_add(t89, t90); // Fp2 mul imag part end
    let t92 = circuit_sub(t88, in7); // Fp2 sub coeff 0/1
    let t93 = circuit_sub(t91, in8); // Fp2 sub coeff 1/1
    let t94 = circuit_mul(t73, in5); // Fp2 mul start
    let t95 = circuit_mul(t74, in6);
    let t96 = circuit_sub(t94, t95); // Fp2 mul real part end
    let t97 = circuit_mul(t73, in6);
    let t98 = circuit_mul(t74, in5);
    let t99 = circuit_add(t97, t98); // Fp2 mul imag part end
    let t100 = circuit_sub(t96, in7); // Fp2 sub coeff 0/1
    let t101 = circuit_sub(t99, in8); // Fp2 sub coeff 1/1
    let t102 = circuit_mul(in1, t74);
    let t103 = circuit_add(t73, t102);
    let t104 = circuit_mul(t103, in4);
    let t105 = circuit_mul(in1, t101);
    let t106 = circuit_add(t100, t105);
    let t107 = circuit_mul(t106, in3);
    let t108 = circuit_mul(t74, in4);
    let t109 = circuit_mul(t101, in3);
    let t110 = circuit_mul(t48, in38); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t111 = circuit_add(in2, t110); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t112 = circuit_mul(t51, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t113 = circuit_add(t111, t112); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t114 = circuit_mul(t52, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t115 = circuit_add(t113, t114); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t116 = circuit_mul(t53, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t117 = circuit_add(t115, t116); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t118 = circuit_mul(t11, t117);
    let t119 = circuit_mul(t104, in38); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t120 = circuit_add(in2, t119); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t121 = circuit_mul(t107, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t122 = circuit_add(t120, t121); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t123 = circuit_mul(t108, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t124 = circuit_add(t122, t123); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t125 = circuit_mul(t109, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t126 = circuit_add(t124, t125); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t127 = circuit_mul(t118, t126);
    let t128 = circuit_sub(in17, in21); // Fp2 sub coeff 0/1
    let t129 = circuit_sub(in18, in22); // Fp2 sub coeff 1/1
    let t130 = circuit_sub(in15, in19); // Fp2 sub coeff 0/1
    let t131 = circuit_sub(in16, in20); // Fp2 sub coeff 1/1
    let t132 = circuit_mul(t130, t130); // Fp2 Div x/y start : Fp2 Inv y start
    let t133 = circuit_mul(t131, t131);
    let t134 = circuit_add(t132, t133);
    let t135 = circuit_inverse(t134);
    let t136 = circuit_mul(t130, t135); // Fp2 Inv y real part end
    let t137 = circuit_mul(t131, t135);
    let t138 = circuit_sub(in0, t137); // Fp2 Inv y imag part end
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
    let t150 = circuit_add(in15, in19); // Fp2 add coeff 0/1
    let t151 = circuit_add(in16, in20); // Fp2 add coeff 1/1
    let t152 = circuit_sub(t147, t150); // Fp2 sub coeff 0/1
    let t153 = circuit_sub(t149, t151); // Fp2 sub coeff 1/1
    let t154 = circuit_mul(t141, in15); // Fp2 mul start
    let t155 = circuit_mul(t144, in16);
    let t156 = circuit_sub(t154, t155); // Fp2 mul real part end
    let t157 = circuit_mul(t141, in16);
    let t158 = circuit_mul(t144, in15);
    let t159 = circuit_add(t157, t158); // Fp2 mul imag part end
    let t160 = circuit_sub(t156, in17); // Fp2 sub coeff 0/1
    let t161 = circuit_sub(t159, in18); // Fp2 sub coeff 1/1
    let t162 = circuit_mul(in1, t144);
    let t163 = circuit_add(t141, t162);
    let t164 = circuit_mul(t163, in14);
    let t165 = circuit_mul(in1, t161);
    let t166 = circuit_add(t160, t165);
    let t167 = circuit_mul(t166, in13);
    let t168 = circuit_mul(t144, in14);
    let t169 = circuit_mul(t161, in13);
    let t170 = circuit_add(in17, in17); // Fp2 add coeff 0/1
    let t171 = circuit_add(in18, in18); // Fp2 add coeff 1/1
    let t172 = circuit_sub(t152, in15); // Fp2 sub coeff 0/1
    let t173 = circuit_sub(t153, in16); // Fp2 sub coeff 1/1
    let t174 = circuit_mul(t172, t172); // Fp2 Div x/y start : Fp2 Inv y start
    let t175 = circuit_mul(t173, t173);
    let t176 = circuit_add(t174, t175);
    let t177 = circuit_inverse(t176);
    let t178 = circuit_mul(t172, t177); // Fp2 Inv y real part end
    let t179 = circuit_mul(t173, t177);
    let t180 = circuit_sub(in0, t179); // Fp2 Inv y imag part end
    let t181 = circuit_mul(t170, t178); // Fp2 mul start
    let t182 = circuit_mul(t171, t180);
    let t183 = circuit_sub(t181, t182); // Fp2 mul real part end
    let t184 = circuit_mul(t170, t180);
    let t185 = circuit_mul(t171, t178);
    let t186 = circuit_add(t184, t185); // Fp2 mul imag part end
    let t187 = circuit_add(t141, t183); // Fp2 add coeff 0/1
    let t188 = circuit_add(t144, t186); // Fp2 add coeff 1/1
    let t189 = circuit_sub(in0, t187); // Fp2 neg coeff 0/1
    let t190 = circuit_sub(in0, t188); // Fp2 neg coeff 1/1
    let t191 = circuit_add(t189, t190);
    let t192 = circuit_sub(t189, t190);
    let t193 = circuit_mul(t191, t192);
    let t194 = circuit_mul(t189, t190);
    let t195 = circuit_add(t194, t194);
    let t196 = circuit_sub(t193, in15); // Fp2 sub coeff 0/1
    let t197 = circuit_sub(t195, in16); // Fp2 sub coeff 1/1
    let t198 = circuit_sub(t196, t152); // Fp2 sub coeff 0/1
    let t199 = circuit_sub(t197, t153); // Fp2 sub coeff 1/1
    let t200 = circuit_sub(in15, t198); // Fp2 sub coeff 0/1
    let t201 = circuit_sub(in16, t199); // Fp2 sub coeff 1/1
    let t202 = circuit_mul(t189, t200); // Fp2 mul start
    let t203 = circuit_mul(t190, t201);
    let t204 = circuit_sub(t202, t203); // Fp2 mul real part end
    let t205 = circuit_mul(t189, t201);
    let t206 = circuit_mul(t190, t200);
    let t207 = circuit_add(t205, t206); // Fp2 mul imag part end
    let t208 = circuit_sub(t204, in17); // Fp2 sub coeff 0/1
    let t209 = circuit_sub(t207, in18); // Fp2 sub coeff 1/1
    let t210 = circuit_mul(t189, in15); // Fp2 mul start
    let t211 = circuit_mul(t190, in16);
    let t212 = circuit_sub(t210, t211); // Fp2 mul real part end
    let t213 = circuit_mul(t189, in16);
    let t214 = circuit_mul(t190, in15);
    let t215 = circuit_add(t213, t214); // Fp2 mul imag part end
    let t216 = circuit_sub(t212, in17); // Fp2 sub coeff 0/1
    let t217 = circuit_sub(t215, in18); // Fp2 sub coeff 1/1
    let t218 = circuit_mul(in1, t190);
    let t219 = circuit_add(t189, t218);
    let t220 = circuit_mul(t219, in14);
    let t221 = circuit_mul(in1, t217);
    let t222 = circuit_add(t216, t221);
    let t223 = circuit_mul(t222, in13);
    let t224 = circuit_mul(t190, in14);
    let t225 = circuit_mul(t217, in13);
    let t226 = circuit_mul(t164, in38); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t227 = circuit_add(in2, t226); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t228 = circuit_mul(t167, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t229 = circuit_add(t227, t228); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t230 = circuit_mul(t168, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t231 = circuit_add(t229, t230); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t232 = circuit_mul(t169, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t233 = circuit_add(t231, t232); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t234 = circuit_mul(t127, t233);
    let t235 = circuit_mul(t220, in38); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t236 = circuit_add(in2, t235); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t237 = circuit_mul(t223, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t238 = circuit_add(t236, t237); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t239 = circuit_mul(t224, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t240 = circuit_add(t238, t239); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t241 = circuit_mul(t225, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t242 = circuit_add(t240, t241); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t243 = circuit_mul(t234, t242);
    let t244 = circuit_mul(t243, in37);
    let t245 = circuit_mul(in26, in38); // Eval UnnamedPoly step coeff_1 * z^1
    let t246 = circuit_add(in25, t245); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t247 = circuit_mul(in27, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t248 = circuit_add(t246, t247); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t249 = circuit_mul(in28, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t250 = circuit_add(t248, t249); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t251 = circuit_mul(in29, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t252 = circuit_add(t250, t251); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t253 = circuit_mul(in30, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t254 = circuit_add(t252, t253); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t255 = circuit_mul(in31, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t256 = circuit_add(t254, t255); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t257 = circuit_mul(in32, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t258 = circuit_add(t256, t257); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t259 = circuit_mul(in33, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t260 = circuit_add(t258, t259); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t261 = circuit_mul(in34, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t262 = circuit_add(t260, t261); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t263 = circuit_mul(in35, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t264 = circuit_add(t262, t263); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t265 = circuit_mul(in36, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t266 = circuit_add(t264, t265); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t267 = circuit_sub(t244, t266);
    let t268 = circuit_mul(t10, t267); // ci * ((Π(i,k) (Pk(z)) - Ri(z))
    let t269 = circuit_add(in23, t268);

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [32324006162389411176778628423, 57042285082623239461879769745, 3486998266802970665, 0]
    )
        .unwrap();

    let mut circuit_inputs = (t82, t83, t92, t93, t198, t199, t208, t209, t266, t269, t10,)
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x6871ca8d3c208c16d87cfd3e, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0]);
    circuit_inputs = circuit_inputs.next([0x1, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(Q0.x0);
    circuit_inputs = circuit_inputs.next(Q0.x1);
    circuit_inputs = circuit_inputs.next(Q0.y0);
    circuit_inputs = circuit_inputs.next(Q0.y1);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_0.x0);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_0.x1);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_0.y0);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_0.y1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(Q1.x0);
    circuit_inputs = circuit_inputs.next(Q1.x1);
    circuit_inputs = circuit_inputs.next(Q1.y0);
    circuit_inputs = circuit_inputs.next(Q1.y1);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_1.x0);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_1.x1);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_1.y0);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_1.y1);
    circuit_inputs = circuit_inputs.next(lhs_i);
    circuit_inputs = circuit_inputs.next(f_i_of_z);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w0);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w1);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w2);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w3);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w4);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w5);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w6);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w7);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w8);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w9);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w10);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w11);
    circuit_inputs = circuit_inputs.next(c_or_cinv_of_z);
    circuit_inputs = circuit_inputs.next(z);
    circuit_inputs = circuit_inputs.next(ci);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let Q0: G2Point = G2Point {
        x0: outputs.get_output(t82),
        x1: outputs.get_output(t83),
        y0: outputs.get_output(t92),
        y1: outputs.get_output(t93)
    };

    let Q1: G2Point = G2Point {
        x0: outputs.get_output(t198),
        x1: outputs.get_output(t199),
        y0: outputs.get_output(t208),
        y1: outputs.get_output(t209)
    };

    let f_i_plus_one_of_z: u384 = outputs.get_output(t266);

    let lhs_i_plus_one: u384 = outputs.get_output(t269);

    let ci_plus_one: u384 = outputs.get_output(t10);
    return (Q0, Q1, f_i_plus_one_of_z, lhs_i_plus_one, ci_plus_one);
}
fn run_BN254_MP_CHECK_BIT1_LOOP_3_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    Q0: G2Point,
    Q_or_Qneg_0: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q1: G2Point,
    Q_or_Qneg_1: G2Point,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q2: G2Point,
    Q_or_Qneg_2: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one: E12D,
    c_or_cinv_of_z: u384,
    z: u384,
    ci: u384
) -> (G2Point, G2Point, G2Point, u384, u384, u384) {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0x0
    let in1 = CircuitElement::<CircuitInput<1>> {}; // -0x9 % p
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 0x1

    // INPUT stack
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
    let in9 = CircuitElement::<CircuitInput<9>> {}; // 
    let in10 = CircuitElement::<CircuitInput<10>> {}; // 
    let in11 = CircuitElement::<CircuitInput<11>> {}; // 
    let in12 = CircuitElement::<CircuitInput<12>> {}; // 
    let in13 = CircuitElement::<CircuitInput<13>> {}; // 
    let in14 = CircuitElement::<CircuitInput<14>> {}; // 
    let in15 = CircuitElement::<CircuitInput<15>> {}; // 
    let in16 = CircuitElement::<CircuitInput<16>> {}; // 
    let in17 = CircuitElement::<CircuitInput<17>> {}; // 
    let in18 = CircuitElement::<CircuitInput<18>> {}; // 
    let in19 = CircuitElement::<CircuitInput<19>> {}; // 
    let in20 = CircuitElement::<CircuitInput<20>> {}; // 
    let in21 = CircuitElement::<CircuitInput<21>> {}; // 
    let in22 = CircuitElement::<CircuitInput<22>> {}; // 
    let in23 = CircuitElement::<CircuitInput<23>> {}; // 
    let in24 = CircuitElement::<CircuitInput<24>> {}; // 
    let in25 = CircuitElement::<CircuitInput<25>> {}; // 
    let in26 = CircuitElement::<CircuitInput<26>> {}; // 
    let in27 = CircuitElement::<CircuitInput<27>> {}; // 
    let in28 = CircuitElement::<CircuitInput<28>> {}; // 
    let in29 = CircuitElement::<CircuitInput<29>> {}; // 
    let in30 = CircuitElement::<CircuitInput<30>> {}; // 
    let in31 = CircuitElement::<CircuitInput<31>> {}; // 
    let in32 = CircuitElement::<CircuitInput<32>> {}; // 
    let in33 = CircuitElement::<CircuitInput<33>> {}; // 
    let in34 = CircuitElement::<CircuitInput<34>> {}; // 
    let in35 = CircuitElement::<CircuitInput<35>> {}; // 
    let in36 = CircuitElement::<CircuitInput<36>> {}; // 
    let in37 = CircuitElement::<CircuitInput<37>> {}; // 
    let in38 = CircuitElement::<CircuitInput<38>> {}; // 
    let in39 = CircuitElement::<CircuitInput<39>> {}; // 
    let in40 = CircuitElement::<CircuitInput<40>> {}; // 
    let in41 = CircuitElement::<CircuitInput<41>> {}; // 
    let in42 = CircuitElement::<CircuitInput<42>> {}; // 
    let in43 = CircuitElement::<CircuitInput<43>> {}; // 
    let in44 = CircuitElement::<CircuitInput<44>> {}; // 
    let in45 = CircuitElement::<CircuitInput<45>> {}; // 
    let in46 = CircuitElement::<CircuitInput<46>> {}; // 
    let in47 = CircuitElement::<CircuitInput<47>> {}; // 
    let in48 = CircuitElement::<CircuitInput<48>> {}; // 
    let in49 = CircuitElement::<CircuitInput<49>> {}; // 
    let t0 = circuit_mul(in48, in48); // Compute z^2
    let t1 = circuit_mul(t0, in48); // Compute z^3
    let t2 = circuit_mul(t1, in48); // Compute z^4
    let t3 = circuit_mul(t2, in48); // Compute z^5
    let t4 = circuit_mul(t3, in48); // Compute z^6
    let t5 = circuit_mul(t4, in48); // Compute z^7
    let t6 = circuit_mul(t5, in48); // Compute z^8
    let t7 = circuit_mul(t6, in48); // Compute z^9
    let t8 = circuit_mul(t7, in48); // Compute z^10
    let t9 = circuit_mul(t8, in48); // Compute z^11
    let t10 = circuit_mul(in49, in49);
    let t11 = circuit_mul(in34, in34);
    let t12 = circuit_sub(in7, in11); // Fp2 sub coeff 0/1
    let t13 = circuit_sub(in8, in12); // Fp2 sub coeff 1/1
    let t14 = circuit_sub(in5, in9); // Fp2 sub coeff 0/1
    let t15 = circuit_sub(in6, in10); // Fp2 sub coeff 1/1
    let t16 = circuit_mul(t14, t14); // Fp2 Div x/y start : Fp2 Inv y start
    let t17 = circuit_mul(t15, t15);
    let t18 = circuit_add(t16, t17);
    let t19 = circuit_inverse(t18);
    let t20 = circuit_mul(t14, t19); // Fp2 Inv y real part end
    let t21 = circuit_mul(t15, t19);
    let t22 = circuit_sub(in0, t21); // Fp2 Inv y imag part end
    let t23 = circuit_mul(t12, t20); // Fp2 mul start
    let t24 = circuit_mul(t13, t22);
    let t25 = circuit_sub(t23, t24); // Fp2 mul real part end
    let t26 = circuit_mul(t12, t22);
    let t27 = circuit_mul(t13, t20);
    let t28 = circuit_add(t26, t27); // Fp2 mul imag part end
    let t29 = circuit_add(t25, t28);
    let t30 = circuit_sub(t25, t28);
    let t31 = circuit_mul(t29, t30);
    let t32 = circuit_mul(t25, t28);
    let t33 = circuit_add(t32, t32);
    let t34 = circuit_add(in5, in9); // Fp2 add coeff 0/1
    let t35 = circuit_add(in6, in10); // Fp2 add coeff 1/1
    let t36 = circuit_sub(t31, t34); // Fp2 sub coeff 0/1
    let t37 = circuit_sub(t33, t35); // Fp2 sub coeff 1/1
    let t38 = circuit_mul(t25, in5); // Fp2 mul start
    let t39 = circuit_mul(t28, in6);
    let t40 = circuit_sub(t38, t39); // Fp2 mul real part end
    let t41 = circuit_mul(t25, in6);
    let t42 = circuit_mul(t28, in5);
    let t43 = circuit_add(t41, t42); // Fp2 mul imag part end
    let t44 = circuit_sub(t40, in7); // Fp2 sub coeff 0/1
    let t45 = circuit_sub(t43, in8); // Fp2 sub coeff 1/1
    let t46 = circuit_mul(in1, t28);
    let t47 = circuit_add(t25, t46);
    let t48 = circuit_mul(t47, in4);
    let t49 = circuit_mul(in1, t45);
    let t50 = circuit_add(t44, t49);
    let t51 = circuit_mul(t50, in3);
    let t52 = circuit_mul(t28, in4);
    let t53 = circuit_mul(t45, in3);
    let t54 = circuit_add(in7, in7); // Fp2 add coeff 0/1
    let t55 = circuit_add(in8, in8); // Fp2 add coeff 1/1
    let t56 = circuit_sub(t36, in5); // Fp2 sub coeff 0/1
    let t57 = circuit_sub(t37, in6); // Fp2 sub coeff 1/1
    let t58 = circuit_mul(t56, t56); // Fp2 Div x/y start : Fp2 Inv y start
    let t59 = circuit_mul(t57, t57);
    let t60 = circuit_add(t58, t59);
    let t61 = circuit_inverse(t60);
    let t62 = circuit_mul(t56, t61); // Fp2 Inv y real part end
    let t63 = circuit_mul(t57, t61);
    let t64 = circuit_sub(in0, t63); // Fp2 Inv y imag part end
    let t65 = circuit_mul(t54, t62); // Fp2 mul start
    let t66 = circuit_mul(t55, t64);
    let t67 = circuit_sub(t65, t66); // Fp2 mul real part end
    let t68 = circuit_mul(t54, t64);
    let t69 = circuit_mul(t55, t62);
    let t70 = circuit_add(t68, t69); // Fp2 mul imag part end
    let t71 = circuit_add(t25, t67); // Fp2 add coeff 0/1
    let t72 = circuit_add(t28, t70); // Fp2 add coeff 1/1
    let t73 = circuit_sub(in0, t71); // Fp2 neg coeff 0/1
    let t74 = circuit_sub(in0, t72); // Fp2 neg coeff 1/1
    let t75 = circuit_add(t73, t74);
    let t76 = circuit_sub(t73, t74);
    let t77 = circuit_mul(t75, t76);
    let t78 = circuit_mul(t73, t74);
    let t79 = circuit_add(t78, t78);
    let t80 = circuit_sub(t77, in5); // Fp2 sub coeff 0/1
    let t81 = circuit_sub(t79, in6); // Fp2 sub coeff 1/1
    let t82 = circuit_sub(t80, t36); // Fp2 sub coeff 0/1
    let t83 = circuit_sub(t81, t37); // Fp2 sub coeff 1/1
    let t84 = circuit_sub(in5, t82); // Fp2 sub coeff 0/1
    let t85 = circuit_sub(in6, t83); // Fp2 sub coeff 1/1
    let t86 = circuit_mul(t73, t84); // Fp2 mul start
    let t87 = circuit_mul(t74, t85);
    let t88 = circuit_sub(t86, t87); // Fp2 mul real part end
    let t89 = circuit_mul(t73, t85);
    let t90 = circuit_mul(t74, t84);
    let t91 = circuit_add(t89, t90); // Fp2 mul imag part end
    let t92 = circuit_sub(t88, in7); // Fp2 sub coeff 0/1
    let t93 = circuit_sub(t91, in8); // Fp2 sub coeff 1/1
    let t94 = circuit_mul(t73, in5); // Fp2 mul start
    let t95 = circuit_mul(t74, in6);
    let t96 = circuit_sub(t94, t95); // Fp2 mul real part end
    let t97 = circuit_mul(t73, in6);
    let t98 = circuit_mul(t74, in5);
    let t99 = circuit_add(t97, t98); // Fp2 mul imag part end
    let t100 = circuit_sub(t96, in7); // Fp2 sub coeff 0/1
    let t101 = circuit_sub(t99, in8); // Fp2 sub coeff 1/1
    let t102 = circuit_mul(in1, t74);
    let t103 = circuit_add(t73, t102);
    let t104 = circuit_mul(t103, in4);
    let t105 = circuit_mul(in1, t101);
    let t106 = circuit_add(t100, t105);
    let t107 = circuit_mul(t106, in3);
    let t108 = circuit_mul(t74, in4);
    let t109 = circuit_mul(t101, in3);
    let t110 = circuit_mul(t48, in48); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t111 = circuit_add(in2, t110); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t112 = circuit_mul(t51, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t113 = circuit_add(t111, t112); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t114 = circuit_mul(t52, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t115 = circuit_add(t113, t114); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t116 = circuit_mul(t53, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t117 = circuit_add(t115, t116); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t118 = circuit_mul(t11, t117);
    let t119 = circuit_mul(t104, in48); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t120 = circuit_add(in2, t119); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t121 = circuit_mul(t107, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t122 = circuit_add(t120, t121); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t123 = circuit_mul(t108, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t124 = circuit_add(t122, t123); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t125 = circuit_mul(t109, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t126 = circuit_add(t124, t125); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t127 = circuit_mul(t118, t126);
    let t128 = circuit_sub(in17, in21); // Fp2 sub coeff 0/1
    let t129 = circuit_sub(in18, in22); // Fp2 sub coeff 1/1
    let t130 = circuit_sub(in15, in19); // Fp2 sub coeff 0/1
    let t131 = circuit_sub(in16, in20); // Fp2 sub coeff 1/1
    let t132 = circuit_mul(t130, t130); // Fp2 Div x/y start : Fp2 Inv y start
    let t133 = circuit_mul(t131, t131);
    let t134 = circuit_add(t132, t133);
    let t135 = circuit_inverse(t134);
    let t136 = circuit_mul(t130, t135); // Fp2 Inv y real part end
    let t137 = circuit_mul(t131, t135);
    let t138 = circuit_sub(in0, t137); // Fp2 Inv y imag part end
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
    let t150 = circuit_add(in15, in19); // Fp2 add coeff 0/1
    let t151 = circuit_add(in16, in20); // Fp2 add coeff 1/1
    let t152 = circuit_sub(t147, t150); // Fp2 sub coeff 0/1
    let t153 = circuit_sub(t149, t151); // Fp2 sub coeff 1/1
    let t154 = circuit_mul(t141, in15); // Fp2 mul start
    let t155 = circuit_mul(t144, in16);
    let t156 = circuit_sub(t154, t155); // Fp2 mul real part end
    let t157 = circuit_mul(t141, in16);
    let t158 = circuit_mul(t144, in15);
    let t159 = circuit_add(t157, t158); // Fp2 mul imag part end
    let t160 = circuit_sub(t156, in17); // Fp2 sub coeff 0/1
    let t161 = circuit_sub(t159, in18); // Fp2 sub coeff 1/1
    let t162 = circuit_mul(in1, t144);
    let t163 = circuit_add(t141, t162);
    let t164 = circuit_mul(t163, in14);
    let t165 = circuit_mul(in1, t161);
    let t166 = circuit_add(t160, t165);
    let t167 = circuit_mul(t166, in13);
    let t168 = circuit_mul(t144, in14);
    let t169 = circuit_mul(t161, in13);
    let t170 = circuit_add(in17, in17); // Fp2 add coeff 0/1
    let t171 = circuit_add(in18, in18); // Fp2 add coeff 1/1
    let t172 = circuit_sub(t152, in15); // Fp2 sub coeff 0/1
    let t173 = circuit_sub(t153, in16); // Fp2 sub coeff 1/1
    let t174 = circuit_mul(t172, t172); // Fp2 Div x/y start : Fp2 Inv y start
    let t175 = circuit_mul(t173, t173);
    let t176 = circuit_add(t174, t175);
    let t177 = circuit_inverse(t176);
    let t178 = circuit_mul(t172, t177); // Fp2 Inv y real part end
    let t179 = circuit_mul(t173, t177);
    let t180 = circuit_sub(in0, t179); // Fp2 Inv y imag part end
    let t181 = circuit_mul(t170, t178); // Fp2 mul start
    let t182 = circuit_mul(t171, t180);
    let t183 = circuit_sub(t181, t182); // Fp2 mul real part end
    let t184 = circuit_mul(t170, t180);
    let t185 = circuit_mul(t171, t178);
    let t186 = circuit_add(t184, t185); // Fp2 mul imag part end
    let t187 = circuit_add(t141, t183); // Fp2 add coeff 0/1
    let t188 = circuit_add(t144, t186); // Fp2 add coeff 1/1
    let t189 = circuit_sub(in0, t187); // Fp2 neg coeff 0/1
    let t190 = circuit_sub(in0, t188); // Fp2 neg coeff 1/1
    let t191 = circuit_add(t189, t190);
    let t192 = circuit_sub(t189, t190);
    let t193 = circuit_mul(t191, t192);
    let t194 = circuit_mul(t189, t190);
    let t195 = circuit_add(t194, t194);
    let t196 = circuit_sub(t193, in15); // Fp2 sub coeff 0/1
    let t197 = circuit_sub(t195, in16); // Fp2 sub coeff 1/1
    let t198 = circuit_sub(t196, t152); // Fp2 sub coeff 0/1
    let t199 = circuit_sub(t197, t153); // Fp2 sub coeff 1/1
    let t200 = circuit_sub(in15, t198); // Fp2 sub coeff 0/1
    let t201 = circuit_sub(in16, t199); // Fp2 sub coeff 1/1
    let t202 = circuit_mul(t189, t200); // Fp2 mul start
    let t203 = circuit_mul(t190, t201);
    let t204 = circuit_sub(t202, t203); // Fp2 mul real part end
    let t205 = circuit_mul(t189, t201);
    let t206 = circuit_mul(t190, t200);
    let t207 = circuit_add(t205, t206); // Fp2 mul imag part end
    let t208 = circuit_sub(t204, in17); // Fp2 sub coeff 0/1
    let t209 = circuit_sub(t207, in18); // Fp2 sub coeff 1/1
    let t210 = circuit_mul(t189, in15); // Fp2 mul start
    let t211 = circuit_mul(t190, in16);
    let t212 = circuit_sub(t210, t211); // Fp2 mul real part end
    let t213 = circuit_mul(t189, in16);
    let t214 = circuit_mul(t190, in15);
    let t215 = circuit_add(t213, t214); // Fp2 mul imag part end
    let t216 = circuit_sub(t212, in17); // Fp2 sub coeff 0/1
    let t217 = circuit_sub(t215, in18); // Fp2 sub coeff 1/1
    let t218 = circuit_mul(in1, t190);
    let t219 = circuit_add(t189, t218);
    let t220 = circuit_mul(t219, in14);
    let t221 = circuit_mul(in1, t217);
    let t222 = circuit_add(t216, t221);
    let t223 = circuit_mul(t222, in13);
    let t224 = circuit_mul(t190, in14);
    let t225 = circuit_mul(t217, in13);
    let t226 = circuit_mul(t164, in48); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t227 = circuit_add(in2, t226); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t228 = circuit_mul(t167, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t229 = circuit_add(t227, t228); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t230 = circuit_mul(t168, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t231 = circuit_add(t229, t230); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t232 = circuit_mul(t169, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t233 = circuit_add(t231, t232); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t234 = circuit_mul(t127, t233);
    let t235 = circuit_mul(t220, in48); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t236 = circuit_add(in2, t235); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t237 = circuit_mul(t223, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t238 = circuit_add(t236, t237); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t239 = circuit_mul(t224, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t240 = circuit_add(t238, t239); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t241 = circuit_mul(t225, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t242 = circuit_add(t240, t241); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t243 = circuit_mul(t234, t242);
    let t244 = circuit_sub(in27, in31); // Fp2 sub coeff 0/1
    let t245 = circuit_sub(in28, in32); // Fp2 sub coeff 1/1
    let t246 = circuit_sub(in25, in29); // Fp2 sub coeff 0/1
    let t247 = circuit_sub(in26, in30); // Fp2 sub coeff 1/1
    let t248 = circuit_mul(t246, t246); // Fp2 Div x/y start : Fp2 Inv y start
    let t249 = circuit_mul(t247, t247);
    let t250 = circuit_add(t248, t249);
    let t251 = circuit_inverse(t250);
    let t252 = circuit_mul(t246, t251); // Fp2 Inv y real part end
    let t253 = circuit_mul(t247, t251);
    let t254 = circuit_sub(in0, t253); // Fp2 Inv y imag part end
    let t255 = circuit_mul(t244, t252); // Fp2 mul start
    let t256 = circuit_mul(t245, t254);
    let t257 = circuit_sub(t255, t256); // Fp2 mul real part end
    let t258 = circuit_mul(t244, t254);
    let t259 = circuit_mul(t245, t252);
    let t260 = circuit_add(t258, t259); // Fp2 mul imag part end
    let t261 = circuit_add(t257, t260);
    let t262 = circuit_sub(t257, t260);
    let t263 = circuit_mul(t261, t262);
    let t264 = circuit_mul(t257, t260);
    let t265 = circuit_add(t264, t264);
    let t266 = circuit_add(in25, in29); // Fp2 add coeff 0/1
    let t267 = circuit_add(in26, in30); // Fp2 add coeff 1/1
    let t268 = circuit_sub(t263, t266); // Fp2 sub coeff 0/1
    let t269 = circuit_sub(t265, t267); // Fp2 sub coeff 1/1
    let t270 = circuit_mul(t257, in25); // Fp2 mul start
    let t271 = circuit_mul(t260, in26);
    let t272 = circuit_sub(t270, t271); // Fp2 mul real part end
    let t273 = circuit_mul(t257, in26);
    let t274 = circuit_mul(t260, in25);
    let t275 = circuit_add(t273, t274); // Fp2 mul imag part end
    let t276 = circuit_sub(t272, in27); // Fp2 sub coeff 0/1
    let t277 = circuit_sub(t275, in28); // Fp2 sub coeff 1/1
    let t278 = circuit_mul(in1, t260);
    let t279 = circuit_add(t257, t278);
    let t280 = circuit_mul(t279, in24);
    let t281 = circuit_mul(in1, t277);
    let t282 = circuit_add(t276, t281);
    let t283 = circuit_mul(t282, in23);
    let t284 = circuit_mul(t260, in24);
    let t285 = circuit_mul(t277, in23);
    let t286 = circuit_add(in27, in27); // Fp2 add coeff 0/1
    let t287 = circuit_add(in28, in28); // Fp2 add coeff 1/1
    let t288 = circuit_sub(t268, in25); // Fp2 sub coeff 0/1
    let t289 = circuit_sub(t269, in26); // Fp2 sub coeff 1/1
    let t290 = circuit_mul(t288, t288); // Fp2 Div x/y start : Fp2 Inv y start
    let t291 = circuit_mul(t289, t289);
    let t292 = circuit_add(t290, t291);
    let t293 = circuit_inverse(t292);
    let t294 = circuit_mul(t288, t293); // Fp2 Inv y real part end
    let t295 = circuit_mul(t289, t293);
    let t296 = circuit_sub(in0, t295); // Fp2 Inv y imag part end
    let t297 = circuit_mul(t286, t294); // Fp2 mul start
    let t298 = circuit_mul(t287, t296);
    let t299 = circuit_sub(t297, t298); // Fp2 mul real part end
    let t300 = circuit_mul(t286, t296);
    let t301 = circuit_mul(t287, t294);
    let t302 = circuit_add(t300, t301); // Fp2 mul imag part end
    let t303 = circuit_add(t257, t299); // Fp2 add coeff 0/1
    let t304 = circuit_add(t260, t302); // Fp2 add coeff 1/1
    let t305 = circuit_sub(in0, t303); // Fp2 neg coeff 0/1
    let t306 = circuit_sub(in0, t304); // Fp2 neg coeff 1/1
    let t307 = circuit_add(t305, t306);
    let t308 = circuit_sub(t305, t306);
    let t309 = circuit_mul(t307, t308);
    let t310 = circuit_mul(t305, t306);
    let t311 = circuit_add(t310, t310);
    let t312 = circuit_sub(t309, in25); // Fp2 sub coeff 0/1
    let t313 = circuit_sub(t311, in26); // Fp2 sub coeff 1/1
    let t314 = circuit_sub(t312, t268); // Fp2 sub coeff 0/1
    let t315 = circuit_sub(t313, t269); // Fp2 sub coeff 1/1
    let t316 = circuit_sub(in25, t314); // Fp2 sub coeff 0/1
    let t317 = circuit_sub(in26, t315); // Fp2 sub coeff 1/1
    let t318 = circuit_mul(t305, t316); // Fp2 mul start
    let t319 = circuit_mul(t306, t317);
    let t320 = circuit_sub(t318, t319); // Fp2 mul real part end
    let t321 = circuit_mul(t305, t317);
    let t322 = circuit_mul(t306, t316);
    let t323 = circuit_add(t321, t322); // Fp2 mul imag part end
    let t324 = circuit_sub(t320, in27); // Fp2 sub coeff 0/1
    let t325 = circuit_sub(t323, in28); // Fp2 sub coeff 1/1
    let t326 = circuit_mul(t305, in25); // Fp2 mul start
    let t327 = circuit_mul(t306, in26);
    let t328 = circuit_sub(t326, t327); // Fp2 mul real part end
    let t329 = circuit_mul(t305, in26);
    let t330 = circuit_mul(t306, in25);
    let t331 = circuit_add(t329, t330); // Fp2 mul imag part end
    let t332 = circuit_sub(t328, in27); // Fp2 sub coeff 0/1
    let t333 = circuit_sub(t331, in28); // Fp2 sub coeff 1/1
    let t334 = circuit_mul(in1, t306);
    let t335 = circuit_add(t305, t334);
    let t336 = circuit_mul(t335, in24);
    let t337 = circuit_mul(in1, t333);
    let t338 = circuit_add(t332, t337);
    let t339 = circuit_mul(t338, in23);
    let t340 = circuit_mul(t306, in24);
    let t341 = circuit_mul(t333, in23);
    let t342 = circuit_mul(t280, in48); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t343 = circuit_add(in2, t342); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t344 = circuit_mul(t283, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t345 = circuit_add(t343, t344); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t346 = circuit_mul(t284, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t347 = circuit_add(t345, t346); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t348 = circuit_mul(t285, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t349 = circuit_add(t347, t348); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t350 = circuit_mul(t243, t349);
    let t351 = circuit_mul(t336, in48); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t352 = circuit_add(in2, t351); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t353 = circuit_mul(t339, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t354 = circuit_add(t352, t353); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t355 = circuit_mul(t340, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t356 = circuit_add(t354, t355); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t357 = circuit_mul(t341, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t358 = circuit_add(t356, t357); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t359 = circuit_mul(t350, t358);
    let t360 = circuit_mul(t359, in47);
    let t361 = circuit_mul(in36, in48); // Eval UnnamedPoly step coeff_1 * z^1
    let t362 = circuit_add(in35, t361); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t363 = circuit_mul(in37, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t364 = circuit_add(t362, t363); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t365 = circuit_mul(in38, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t366 = circuit_add(t364, t365); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t367 = circuit_mul(in39, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t368 = circuit_add(t366, t367); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t369 = circuit_mul(in40, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t370 = circuit_add(t368, t369); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t371 = circuit_mul(in41, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t372 = circuit_add(t370, t371); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t373 = circuit_mul(in42, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t374 = circuit_add(t372, t373); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t375 = circuit_mul(in43, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t376 = circuit_add(t374, t375); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t377 = circuit_mul(in44, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t378 = circuit_add(t376, t377); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t379 = circuit_mul(in45, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t380 = circuit_add(t378, t379); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t381 = circuit_mul(in46, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t382 = circuit_add(t380, t381); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t383 = circuit_sub(t360, t382);
    let t384 = circuit_mul(t10, t383); // ci * ((Π(i,k) (Pk(z)) - Ri(z))
    let t385 = circuit_add(in33, t384);

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [32324006162389411176778628423, 57042285082623239461879769745, 3486998266802970665, 0]
    )
        .unwrap();

    let mut circuit_inputs = (
        t82, t83, t92, t93, t198, t199, t208, t209, t314, t315, t324, t325, t382, t385, t10,
    )
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x6871ca8d3c208c16d87cfd3e, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0]);
    circuit_inputs = circuit_inputs.next([0x1, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(Q0.x0);
    circuit_inputs = circuit_inputs.next(Q0.x1);
    circuit_inputs = circuit_inputs.next(Q0.y0);
    circuit_inputs = circuit_inputs.next(Q0.y1);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_0.x0);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_0.x1);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_0.y0);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_0.y1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(Q1.x0);
    circuit_inputs = circuit_inputs.next(Q1.x1);
    circuit_inputs = circuit_inputs.next(Q1.y0);
    circuit_inputs = circuit_inputs.next(Q1.y1);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_1.x0);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_1.x1);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_1.y0);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_1.y1);
    circuit_inputs = circuit_inputs.next(yInv_2);
    circuit_inputs = circuit_inputs.next(xNegOverY_2);
    circuit_inputs = circuit_inputs.next(Q2.x0);
    circuit_inputs = circuit_inputs.next(Q2.x1);
    circuit_inputs = circuit_inputs.next(Q2.y0);
    circuit_inputs = circuit_inputs.next(Q2.y1);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_2.x0);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_2.x1);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_2.y0);
    circuit_inputs = circuit_inputs.next(Q_or_Qneg_2.y1);
    circuit_inputs = circuit_inputs.next(lhs_i);
    circuit_inputs = circuit_inputs.next(f_i_of_z);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w0);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w1);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w2);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w3);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w4);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w5);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w6);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w7);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w8);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w9);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w10);
    circuit_inputs = circuit_inputs.next(f_i_plus_one.w11);
    circuit_inputs = circuit_inputs.next(c_or_cinv_of_z);
    circuit_inputs = circuit_inputs.next(z);
    circuit_inputs = circuit_inputs.next(ci);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let Q0: G2Point = G2Point {
        x0: outputs.get_output(t82),
        x1: outputs.get_output(t83),
        y0: outputs.get_output(t92),
        y1: outputs.get_output(t93)
    };

    let Q1: G2Point = G2Point {
        x0: outputs.get_output(t198),
        x1: outputs.get_output(t199),
        y0: outputs.get_output(t208),
        y1: outputs.get_output(t209)
    };

    let Q2: G2Point = G2Point {
        x0: outputs.get_output(t314),
        x1: outputs.get_output(t315),
        y0: outputs.get_output(t324),
        y1: outputs.get_output(t325)
    };

    let f_i_plus_one_of_z: u384 = outputs.get_output(t382);

    let lhs_i_plus_one: u384 = outputs.get_output(t385);

    let ci_plus_one: u384 = outputs.get_output(t10);
    return (Q0, Q1, Q2, f_i_plus_one_of_z, lhs_i_plus_one, ci_plus_one);
}
fn run_BN254_MP_CHECK_FINALIZE_BN_2_circuit(
    original_Q0: G2Point,
    yInv_0: u384,
    xNegOverY_0: u384,
    Q0: G2Point,
    original_Q1: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q1: G2Point,
    R_n_minus_2: E12D,
    R_n_minus_1: E12D,
    c_n_minus_3: u384,
    w_of_z: u384,
    z: u384,
    c_inv_frob_1_of_z: u384,
    c_frob_2_of_z: u384,
    c_inv_frob_3_of_z: u384,
    previous_lhs: u384,
    R_n_minus_3_of_z: u384,
    Q: Array<u384>
) -> (u384,) {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0x0
    let in1 = CircuitElement::<
        CircuitInput<1>
    > {}; // 0x2fb347984f7911f74c0bec3cf559b143b78cc310c2c3330c99e39557176f553d
    let in2 = CircuitElement::<
        CircuitInput<2>
    > {}; // 0x16c9e55061ebae204ba4cc8bd75a079432ae2a1d0b7c9dce1665d51c640fcba2
    let in3 = CircuitElement::<
        CircuitInput<3>
    > {}; // 0x63cf305489af5dcdc5ec698b6e2f9b9dbaae0eda9c95998dc54014671a0135a
    let in4 = CircuitElement::<
        CircuitInput<4>
    > {}; // 0x7c03cbcac41049a0704b5a7ec796f2b21807dc98fa25bd282d37f632623b0e3
    let in5 = CircuitElement::<
        CircuitInput<5>
    > {}; // 0x30644e72e131a0295e6dd9e7e0acccb0c28f069fbb966e3de4bd44e5607cfd48
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 0x1
    let in7 = CircuitElement::<CircuitInput<7>> {}; // -0x9 % p
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 0x52
    let in9 = CircuitElement::<CircuitInput<9>> {}; // -0x12 % p

    // INPUT stack
    let in10 = CircuitElement::<CircuitInput<10>> {}; // 
    let in11 = CircuitElement::<CircuitInput<11>> {}; // 
    let in12 = CircuitElement::<CircuitInput<12>> {}; // 
    let in13 = CircuitElement::<CircuitInput<13>> {}; // 
    let in14 = CircuitElement::<CircuitInput<14>> {}; // 
    let in15 = CircuitElement::<CircuitInput<15>> {}; // 
    let in16 = CircuitElement::<CircuitInput<16>> {}; // 
    let in17 = CircuitElement::<CircuitInput<17>> {}; // 
    let in18 = CircuitElement::<CircuitInput<18>> {}; // 
    let in19 = CircuitElement::<CircuitInput<19>> {}; // 
    let in20 = CircuitElement::<CircuitInput<20>> {}; // 
    let in21 = CircuitElement::<CircuitInput<21>> {}; // 
    let in22 = CircuitElement::<CircuitInput<22>> {}; // 
    let in23 = CircuitElement::<CircuitInput<23>> {}; // 
    let in24 = CircuitElement::<CircuitInput<24>> {}; // 
    let in25 = CircuitElement::<CircuitInput<25>> {}; // 
    let in26 = CircuitElement::<CircuitInput<26>> {}; // 
    let in27 = CircuitElement::<CircuitInput<27>> {}; // 
    let in28 = CircuitElement::<CircuitInput<28>> {}; // 
    let in29 = CircuitElement::<CircuitInput<29>> {}; // 
    let in30 = CircuitElement::<CircuitInput<30>> {}; // 
    let in31 = CircuitElement::<CircuitInput<31>> {}; // 
    let in32 = CircuitElement::<CircuitInput<32>> {}; // 
    let in33 = CircuitElement::<CircuitInput<33>> {}; // 
    let in34 = CircuitElement::<CircuitInput<34>> {}; // 
    let in35 = CircuitElement::<CircuitInput<35>> {}; // 
    let in36 = CircuitElement::<CircuitInput<36>> {}; // 
    let in37 = CircuitElement::<CircuitInput<37>> {}; // 
    let in38 = CircuitElement::<CircuitInput<38>> {}; // 
    let in39 = CircuitElement::<CircuitInput<39>> {}; // 
    let in40 = CircuitElement::<CircuitInput<40>> {}; // 
    let in41 = CircuitElement::<CircuitInput<41>> {}; // 
    let in42 = CircuitElement::<CircuitInput<42>> {}; // 
    let in43 = CircuitElement::<CircuitInput<43>> {}; // 
    let in44 = CircuitElement::<CircuitInput<44>> {}; // 
    let in45 = CircuitElement::<CircuitInput<45>> {}; // 
    let in46 = CircuitElement::<CircuitInput<46>> {}; // 
    let in47 = CircuitElement::<CircuitInput<47>> {}; // 
    let in48 = CircuitElement::<CircuitInput<48>> {}; // 
    let in49 = CircuitElement::<CircuitInput<49>> {}; // 
    let in50 = CircuitElement::<CircuitInput<50>> {}; // 
    let in51 = CircuitElement::<CircuitInput<51>> {}; // 
    let in52 = CircuitElement::<CircuitInput<52>> {}; // 
    let in53 = CircuitElement::<CircuitInput<53>> {}; // 
    let in54 = CircuitElement::<CircuitInput<54>> {}; // 
    let in55 = CircuitElement::<CircuitInput<55>> {}; // 
    let in56 = CircuitElement::<CircuitInput<56>> {}; // 
    let in57 = CircuitElement::<CircuitInput<57>> {}; // 
    let in58 = CircuitElement::<CircuitInput<58>> {}; // 
    let in59 = CircuitElement::<CircuitInput<59>> {}; // 
    let in60 = CircuitElement::<CircuitInput<60>> {}; // 
    let in61 = CircuitElement::<CircuitInput<61>> {}; // 
    let in62 = CircuitElement::<CircuitInput<62>> {}; // 
    let in63 = CircuitElement::<CircuitInput<63>> {}; // 
    let in64 = CircuitElement::<CircuitInput<64>> {}; // 
    let in65 = CircuitElement::<CircuitInput<65>> {}; // 
    let in66 = CircuitElement::<CircuitInput<66>> {}; // 
    let in67 = CircuitElement::<CircuitInput<67>> {}; // 
    let in68 = CircuitElement::<CircuitInput<68>> {}; // 
    let in69 = CircuitElement::<CircuitInput<69>> {}; // 
    let in70 = CircuitElement::<CircuitInput<70>> {}; // 
    let in71 = CircuitElement::<CircuitInput<71>> {}; // 
    let in72 = CircuitElement::<CircuitInput<72>> {}; // 
    let in73 = CircuitElement::<CircuitInput<73>> {}; // 
    let in74 = CircuitElement::<CircuitInput<74>> {}; // 
    let in75 = CircuitElement::<CircuitInput<75>> {}; // 
    let in76 = CircuitElement::<CircuitInput<76>> {}; // 
    let in77 = CircuitElement::<CircuitInput<77>> {}; // 
    let in78 = CircuitElement::<CircuitInput<78>> {}; // 
    let in79 = CircuitElement::<CircuitInput<79>> {}; // 
    let in80 = CircuitElement::<CircuitInput<80>> {}; // 
    let in81 = CircuitElement::<CircuitInput<81>> {}; // 
    let in82 = CircuitElement::<CircuitInput<82>> {}; // 
    let in83 = CircuitElement::<CircuitInput<83>> {}; // 
    let in84 = CircuitElement::<CircuitInput<84>> {}; // 
    let in85 = CircuitElement::<CircuitInput<85>> {}; // 
    let in86 = CircuitElement::<CircuitInput<86>> {}; // 
    let in87 = CircuitElement::<CircuitInput<87>> {}; // 
    let in88 = CircuitElement::<CircuitInput<88>> {}; // 
    let in89 = CircuitElement::<CircuitInput<89>> {}; // 
    let in90 = CircuitElement::<CircuitInput<90>> {}; // 
    let in91 = CircuitElement::<CircuitInput<91>> {}; // 
    let in92 = CircuitElement::<CircuitInput<92>> {}; // 
    let in93 = CircuitElement::<CircuitInput<93>> {}; // 
    let in94 = CircuitElement::<CircuitInput<94>> {}; // 
    let in95 = CircuitElement::<CircuitInput<95>> {}; // 
    let in96 = CircuitElement::<CircuitInput<96>> {}; // 
    let in97 = CircuitElement::<CircuitInput<97>> {}; // 
    let in98 = CircuitElement::<CircuitInput<98>> {}; // 
    let in99 = CircuitElement::<CircuitInput<99>> {}; // 
    let in100 = CircuitElement::<CircuitInput<100>> {}; // 
    let in101 = CircuitElement::<CircuitInput<101>> {}; // 
    let in102 = CircuitElement::<CircuitInput<102>> {}; // 
    let in103 = CircuitElement::<CircuitInput<103>> {}; // 
    let in104 = CircuitElement::<CircuitInput<104>> {}; // 
    let in105 = CircuitElement::<CircuitInput<105>> {}; // 
    let in106 = CircuitElement::<CircuitInput<106>> {}; // 
    let in107 = CircuitElement::<CircuitInput<107>> {}; // 
    let in108 = CircuitElement::<CircuitInput<108>> {}; // 
    let in109 = CircuitElement::<CircuitInput<109>> {}; // 
    let in110 = CircuitElement::<CircuitInput<110>> {}; // 
    let in111 = CircuitElement::<CircuitInput<111>> {}; // 
    let in112 = CircuitElement::<CircuitInput<112>> {}; // 
    let in113 = CircuitElement::<CircuitInput<113>> {}; // 
    let in114 = CircuitElement::<CircuitInput<114>> {}; // 
    let in115 = CircuitElement::<CircuitInput<115>> {}; // 
    let in116 = CircuitElement::<CircuitInput<116>> {}; // 
    let in117 = CircuitElement::<CircuitInput<117>> {}; // 
    let in118 = CircuitElement::<CircuitInput<118>> {}; // 
    let in119 = CircuitElement::<CircuitInput<119>> {}; // 
    let t0 = circuit_mul(in56, in56); // Compute z^2
    let t1 = circuit_mul(t0, in56); // Compute z^3
    let t2 = circuit_mul(t1, in56); // Compute z^4
    let t3 = circuit_mul(t2, in56); // Compute z^5
    let t4 = circuit_mul(t3, in56); // Compute z^6
    let t5 = circuit_mul(t4, in56); // Compute z^7
    let t6 = circuit_mul(t5, in56); // Compute z^8
    let t7 = circuit_mul(t6, in56); // Compute z^9
    let t8 = circuit_mul(t7, in56); // Compute z^10
    let t9 = circuit_mul(t8, in56); // Compute z^11
    let t10 = circuit_mul(t9, in56); // Compute z^12
    let t11 = circuit_mul(t10, in56); // Compute z^13
    let t12 = circuit_mul(t11, in56); // Compute z^14
    let t13 = circuit_mul(t12, in56); // Compute z^15
    let t14 = circuit_mul(t13, in56); // Compute z^16
    let t15 = circuit_mul(t14, in56); // Compute z^17
    let t16 = circuit_mul(t15, in56); // Compute z^18
    let t17 = circuit_mul(t16, in56); // Compute z^19
    let t18 = circuit_mul(t17, in56); // Compute z^20
    let t19 = circuit_mul(t18, in56); // Compute z^21
    let t20 = circuit_mul(t19, in56); // Compute z^22
    let t21 = circuit_mul(t20, in56); // Compute z^23
    let t22 = circuit_mul(t21, in56); // Compute z^24
    let t23 = circuit_mul(t22, in56); // Compute z^25
    let t24 = circuit_mul(t23, in56); // Compute z^26
    let t25 = circuit_mul(t24, in56); // Compute z^27
    let t26 = circuit_mul(t25, in56); // Compute z^28
    let t27 = circuit_mul(t26, in56); // Compute z^29
    let t28 = circuit_mul(t27, in56); // Compute z^30
    let t29 = circuit_mul(t28, in56); // Compute z^31
    let t30 = circuit_mul(t29, in56); // Compute z^32
    let t31 = circuit_mul(t30, in56); // Compute z^33
    let t32 = circuit_mul(t31, in56); // Compute z^34
    let t33 = circuit_mul(t32, in56); // Compute z^35
    let t34 = circuit_mul(t33, in56); // Compute z^36
    let t35 = circuit_mul(t34, in56); // Compute z^37
    let t36 = circuit_mul(t35, in56); // Compute z^38
    let t37 = circuit_mul(t36, in56); // Compute z^39
    let t38 = circuit_mul(t37, in56); // Compute z^40
    let t39 = circuit_mul(t38, in56); // Compute z^41
    let t40 = circuit_mul(t39, in56); // Compute z^42
    let t41 = circuit_mul(t40, in56); // Compute z^43
    let t42 = circuit_mul(t41, in56); // Compute z^44
    let t43 = circuit_mul(t42, in56); // Compute z^45
    let t44 = circuit_mul(t43, in56); // Compute z^46
    let t45 = circuit_mul(t44, in56); // Compute z^47
    let t46 = circuit_mul(t45, in56); // Compute z^48
    let t47 = circuit_mul(t46, in56); // Compute z^49
    let t48 = circuit_mul(t47, in56); // Compute z^50
    let t49 = circuit_mul(t48, in56); // Compute z^51
    let t50 = circuit_mul(t49, in56); // Compute z^52
    let t51 = circuit_mul(t50, in56); // Compute z^53
    let t52 = circuit_mul(t51, in56); // Compute z^54
    let t53 = circuit_mul(t52, in56); // Compute z^55
    let t54 = circuit_mul(t53, in56); // Compute z^56
    let t55 = circuit_mul(t54, in56); // Compute z^57
    let t56 = circuit_mul(in54, in54);
    let t57 = circuit_mul(t56, in54);
    let t58 = circuit_mul(in31, in56); // Eval UnnamedPoly step coeff_1 * z^1
    let t59 = circuit_add(in30, t58); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t60 = circuit_mul(in32, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t61 = circuit_add(t59, t60); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t62 = circuit_mul(in33, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t63 = circuit_add(t61, t62); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t64 = circuit_mul(in34, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t65 = circuit_add(t63, t64); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t66 = circuit_mul(in35, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t67 = circuit_add(t65, t66); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t68 = circuit_mul(in36, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t69 = circuit_add(t67, t68); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t70 = circuit_mul(in37, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t71 = circuit_add(t69, t70); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t72 = circuit_mul(in38, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t73 = circuit_add(t71, t72); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t74 = circuit_mul(in39, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t75 = circuit_add(t73, t74); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t76 = circuit_mul(in40, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t77 = circuit_add(t75, t76); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t78 = circuit_mul(in41, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t79 = circuit_add(t77, t78); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t80 = circuit_mul(in43, in56); // Eval UnnamedPoly step coeff_1 * z^1
    let t81 = circuit_add(in42, t80); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t82 = circuit_mul(in44, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t83 = circuit_add(t81, t82); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t84 = circuit_mul(in45, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t85 = circuit_add(t83, t84); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t86 = circuit_mul(in46, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t87 = circuit_add(t85, t86); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t88 = circuit_mul(in47, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t89 = circuit_add(t87, t88); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t90 = circuit_mul(in48, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t91 = circuit_add(t89, t90); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t92 = circuit_mul(in49, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t93 = circuit_add(t91, t92); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t94 = circuit_mul(in50, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t95 = circuit_add(t93, t94); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t96 = circuit_mul(in51, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t97 = circuit_add(t95, t96); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t98 = circuit_mul(in52, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t99 = circuit_add(t97, t98); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t100 = circuit_mul(in53, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t101 = circuit_add(t99, t100); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t102 = circuit_sub(in0, in11);
    let t103 = circuit_sub(in0, in13);
    let t104 = circuit_mul(in10, in1); // Fp2 mul start
    let t105 = circuit_mul(t102, in2);
    let t106 = circuit_sub(t104, t105); // Fp2 mul real part end
    let t107 = circuit_mul(in10, in2);
    let t108 = circuit_mul(t102, in1);
    let t109 = circuit_add(t107, t108); // Fp2 mul imag part end
    let t110 = circuit_mul(in12, in3); // Fp2 mul start
    let t111 = circuit_mul(t103, in4);
    let t112 = circuit_sub(t110, t111); // Fp2 mul real part end
    let t113 = circuit_mul(in12, in4);
    let t114 = circuit_mul(t103, in3);
    let t115 = circuit_add(t113, t114); // Fp2 mul imag part end
    let t116 = circuit_mul(in10, in5); // Fp2 scalar mul coeff 0/1
    let t117 = circuit_mul(in11, in5); // Fp2 scalar mul coeff 1/1
    let t118 = circuit_mul(in12, in6); // Fp2 scalar mul coeff 0/1
    let t119 = circuit_mul(in13, in6); // Fp2 scalar mul coeff 1/1
    let t120 = circuit_sub(in18, t112); // Fp2 sub coeff 0/1
    let t121 = circuit_sub(in19, t115); // Fp2 sub coeff 1/1
    let t122 = circuit_sub(in16, t106); // Fp2 sub coeff 0/1
    let t123 = circuit_sub(in17, t109); // Fp2 sub coeff 1/1
    let t124 = circuit_mul(t122, t122); // Fp2 Div x/y start : Fp2 Inv y start
    let t125 = circuit_mul(t123, t123);
    let t126 = circuit_add(t124, t125);
    let t127 = circuit_inverse(t126);
    let t128 = circuit_mul(t122, t127); // Fp2 Inv y real part end
    let t129 = circuit_mul(t123, t127);
    let t130 = circuit_sub(in0, t129); // Fp2 Inv y imag part end
    let t131 = circuit_mul(t120, t128); // Fp2 mul start
    let t132 = circuit_mul(t121, t130);
    let t133 = circuit_sub(t131, t132); // Fp2 mul real part end
    let t134 = circuit_mul(t120, t130);
    let t135 = circuit_mul(t121, t128);
    let t136 = circuit_add(t134, t135); // Fp2 mul imag part end
    let t137 = circuit_add(t133, t136);
    let t138 = circuit_sub(t133, t136);
    let t139 = circuit_mul(t137, t138);
    let t140 = circuit_mul(t133, t136);
    let t141 = circuit_add(t140, t140);
    let t142 = circuit_add(in16, t106); // Fp2 add coeff 0/1
    let t143 = circuit_add(in17, t109); // Fp2 add coeff 1/1
    let t144 = circuit_sub(t139, t142); // Fp2 sub coeff 0/1
    let t145 = circuit_sub(t141, t143); // Fp2 sub coeff 1/1
    let t146 = circuit_sub(in16, t144); // Fp2 sub coeff 0/1
    let t147 = circuit_sub(in17, t145); // Fp2 sub coeff 1/1
    let t148 = circuit_mul(t133, t146); // Fp2 mul start
    let t149 = circuit_mul(t136, t147);
    let t150 = circuit_sub(t148, t149); // Fp2 mul real part end
    let t151 = circuit_mul(t133, t147);
    let t152 = circuit_mul(t136, t146);
    let t153 = circuit_add(t151, t152); // Fp2 mul imag part end
    let t154 = circuit_sub(t150, in18); // Fp2 sub coeff 0/1
    let t155 = circuit_sub(t153, in19); // Fp2 sub coeff 1/1
    let t156 = circuit_mul(t133, in16); // Fp2 mul start
    let t157 = circuit_mul(t136, in17);
    let t158 = circuit_sub(t156, t157); // Fp2 mul real part end
    let t159 = circuit_mul(t133, in17);
    let t160 = circuit_mul(t136, in16);
    let t161 = circuit_add(t159, t160); // Fp2 mul imag part end
    let t162 = circuit_sub(t158, in18); // Fp2 sub coeff 0/1
    let t163 = circuit_sub(t161, in19); // Fp2 sub coeff 1/1
    let t164 = circuit_mul(in7, t136);
    let t165 = circuit_add(t133, t164);
    let t166 = circuit_mul(t165, in15);
    let t167 = circuit_mul(in7, t163);
    let t168 = circuit_add(t162, t167);
    let t169 = circuit_mul(t168, in14);
    let t170 = circuit_mul(t136, in15);
    let t171 = circuit_mul(t163, in14);
    let t172 = circuit_sub(t154, t118); // Fp2 sub coeff 0/1
    let t173 = circuit_sub(t155, t119); // Fp2 sub coeff 1/1
    let t174 = circuit_sub(t144, t116); // Fp2 sub coeff 0/1
    let t175 = circuit_sub(t145, t117); // Fp2 sub coeff 1/1
    let t176 = circuit_mul(t174, t174); // Fp2 Div x/y start : Fp2 Inv y start
    let t177 = circuit_mul(t175, t175);
    let t178 = circuit_add(t176, t177);
    let t179 = circuit_inverse(t178);
    let t180 = circuit_mul(t174, t179); // Fp2 Inv y real part end
    let t181 = circuit_mul(t175, t179);
    let t182 = circuit_sub(in0, t181); // Fp2 Inv y imag part end
    let t183 = circuit_mul(t172, t180); // Fp2 mul start
    let t184 = circuit_mul(t173, t182);
    let t185 = circuit_sub(t183, t184); // Fp2 mul real part end
    let t186 = circuit_mul(t172, t182);
    let t187 = circuit_mul(t173, t180);
    let t188 = circuit_add(t186, t187); // Fp2 mul imag part end
    let t189 = circuit_mul(t185, t144); // Fp2 mul start
    let t190 = circuit_mul(t188, t145);
    let t191 = circuit_sub(t189, t190); // Fp2 mul real part end
    let t192 = circuit_mul(t185, t145);
    let t193 = circuit_mul(t188, t144);
    let t194 = circuit_add(t192, t193); // Fp2 mul imag part end
    let t195 = circuit_sub(t191, t154); // Fp2 sub coeff 0/1
    let t196 = circuit_sub(t194, t155); // Fp2 sub coeff 1/1
    let t197 = circuit_mul(in7, t188);
    let t198 = circuit_add(t185, t197);
    let t199 = circuit_mul(t198, in15);
    let t200 = circuit_mul(in7, t196);
    let t201 = circuit_add(t195, t200);
    let t202 = circuit_mul(t201, in14);
    let t203 = circuit_mul(t188, in15);
    let t204 = circuit_mul(t196, in14);
    let t205 = circuit_sub(in0, in21);
    let t206 = circuit_sub(in0, in23);
    let t207 = circuit_mul(in20, in1); // Fp2 mul start
    let t208 = circuit_mul(t205, in2);
    let t209 = circuit_sub(t207, t208); // Fp2 mul real part end
    let t210 = circuit_mul(in20, in2);
    let t211 = circuit_mul(t205, in1);
    let t212 = circuit_add(t210, t211); // Fp2 mul imag part end
    let t213 = circuit_mul(in22, in3); // Fp2 mul start
    let t214 = circuit_mul(t206, in4);
    let t215 = circuit_sub(t213, t214); // Fp2 mul real part end
    let t216 = circuit_mul(in22, in4);
    let t217 = circuit_mul(t206, in3);
    let t218 = circuit_add(t216, t217); // Fp2 mul imag part end
    let t219 = circuit_mul(in20, in5); // Fp2 scalar mul coeff 0/1
    let t220 = circuit_mul(in21, in5); // Fp2 scalar mul coeff 1/1
    let t221 = circuit_mul(in22, in6); // Fp2 scalar mul coeff 0/1
    let t222 = circuit_mul(in23, in6); // Fp2 scalar mul coeff 1/1
    let t223 = circuit_sub(in28, t215); // Fp2 sub coeff 0/1
    let t224 = circuit_sub(in29, t218); // Fp2 sub coeff 1/1
    let t225 = circuit_sub(in26, t209); // Fp2 sub coeff 0/1
    let t226 = circuit_sub(in27, t212); // Fp2 sub coeff 1/1
    let t227 = circuit_mul(t225, t225); // Fp2 Div x/y start : Fp2 Inv y start
    let t228 = circuit_mul(t226, t226);
    let t229 = circuit_add(t227, t228);
    let t230 = circuit_inverse(t229);
    let t231 = circuit_mul(t225, t230); // Fp2 Inv y real part end
    let t232 = circuit_mul(t226, t230);
    let t233 = circuit_sub(in0, t232); // Fp2 Inv y imag part end
    let t234 = circuit_mul(t223, t231); // Fp2 mul start
    let t235 = circuit_mul(t224, t233);
    let t236 = circuit_sub(t234, t235); // Fp2 mul real part end
    let t237 = circuit_mul(t223, t233);
    let t238 = circuit_mul(t224, t231);
    let t239 = circuit_add(t237, t238); // Fp2 mul imag part end
    let t240 = circuit_add(t236, t239);
    let t241 = circuit_sub(t236, t239);
    let t242 = circuit_mul(t240, t241);
    let t243 = circuit_mul(t236, t239);
    let t244 = circuit_add(t243, t243);
    let t245 = circuit_add(in26, t209); // Fp2 add coeff 0/1
    let t246 = circuit_add(in27, t212); // Fp2 add coeff 1/1
    let t247 = circuit_sub(t242, t245); // Fp2 sub coeff 0/1
    let t248 = circuit_sub(t244, t246); // Fp2 sub coeff 1/1
    let t249 = circuit_sub(in26, t247); // Fp2 sub coeff 0/1
    let t250 = circuit_sub(in27, t248); // Fp2 sub coeff 1/1
    let t251 = circuit_mul(t236, t249); // Fp2 mul start
    let t252 = circuit_mul(t239, t250);
    let t253 = circuit_sub(t251, t252); // Fp2 mul real part end
    let t254 = circuit_mul(t236, t250);
    let t255 = circuit_mul(t239, t249);
    let t256 = circuit_add(t254, t255); // Fp2 mul imag part end
    let t257 = circuit_sub(t253, in28); // Fp2 sub coeff 0/1
    let t258 = circuit_sub(t256, in29); // Fp2 sub coeff 1/1
    let t259 = circuit_mul(t236, in26); // Fp2 mul start
    let t260 = circuit_mul(t239, in27);
    let t261 = circuit_sub(t259, t260); // Fp2 mul real part end
    let t262 = circuit_mul(t236, in27);
    let t263 = circuit_mul(t239, in26);
    let t264 = circuit_add(t262, t263); // Fp2 mul imag part end
    let t265 = circuit_sub(t261, in28); // Fp2 sub coeff 0/1
    let t266 = circuit_sub(t264, in29); // Fp2 sub coeff 1/1
    let t267 = circuit_mul(in7, t239);
    let t268 = circuit_add(t236, t267);
    let t269 = circuit_mul(t268, in25);
    let t270 = circuit_mul(in7, t266);
    let t271 = circuit_add(t265, t270);
    let t272 = circuit_mul(t271, in24);
    let t273 = circuit_mul(t239, in25);
    let t274 = circuit_mul(t266, in24);
    let t275 = circuit_sub(t257, t221); // Fp2 sub coeff 0/1
    let t276 = circuit_sub(t258, t222); // Fp2 sub coeff 1/1
    let t277 = circuit_sub(t247, t219); // Fp2 sub coeff 0/1
    let t278 = circuit_sub(t248, t220); // Fp2 sub coeff 1/1
    let t279 = circuit_mul(t277, t277); // Fp2 Div x/y start : Fp2 Inv y start
    let t280 = circuit_mul(t278, t278);
    let t281 = circuit_add(t279, t280);
    let t282 = circuit_inverse(t281);
    let t283 = circuit_mul(t277, t282); // Fp2 Inv y real part end
    let t284 = circuit_mul(t278, t282);
    let t285 = circuit_sub(in0, t284); // Fp2 Inv y imag part end
    let t286 = circuit_mul(t275, t283); // Fp2 mul start
    let t287 = circuit_mul(t276, t285);
    let t288 = circuit_sub(t286, t287); // Fp2 mul real part end
    let t289 = circuit_mul(t275, t285);
    let t290 = circuit_mul(t276, t283);
    let t291 = circuit_add(t289, t290); // Fp2 mul imag part end
    let t292 = circuit_mul(t288, t247); // Fp2 mul start
    let t293 = circuit_mul(t291, t248);
    let t294 = circuit_sub(t292, t293); // Fp2 mul real part end
    let t295 = circuit_mul(t288, t248);
    let t296 = circuit_mul(t291, t247);
    let t297 = circuit_add(t295, t296); // Fp2 mul imag part end
    let t298 = circuit_sub(t294, t257); // Fp2 sub coeff 0/1
    let t299 = circuit_sub(t297, t258); // Fp2 sub coeff 1/1
    let t300 = circuit_mul(in7, t291);
    let t301 = circuit_add(t288, t300);
    let t302 = circuit_mul(t301, in25);
    let t303 = circuit_mul(in7, t299);
    let t304 = circuit_add(t298, t303);
    let t305 = circuit_mul(t304, in24);
    let t306 = circuit_mul(t291, in25);
    let t307 = circuit_mul(t299, in24);
    let t308 = circuit_mul(t166, in56); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t309 = circuit_add(in6, t308); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t310 = circuit_mul(t169, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t311 = circuit_add(t309, t310); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t312 = circuit_mul(t170, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t313 = circuit_add(t311, t312); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t314 = circuit_mul(t171, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t315 = circuit_add(t313, t314); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t316 = circuit_mul(in61, t315);
    let t317 = circuit_mul(t199, in56); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t318 = circuit_add(in6, t317); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t319 = circuit_mul(t202, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t320 = circuit_add(t318, t319); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t321 = circuit_mul(t203, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t322 = circuit_add(t320, t321); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t323 = circuit_mul(t204, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t324 = circuit_add(t322, t323); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t325 = circuit_mul(t316, t324);
    let t326 = circuit_mul(t269, in56); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t327 = circuit_add(in6, t326); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t328 = circuit_mul(t272, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t329 = circuit_add(t327, t328); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t330 = circuit_mul(t273, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t331 = circuit_add(t329, t330); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t332 = circuit_mul(t274, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t333 = circuit_add(t331, t332); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t334 = circuit_mul(t325, t333);
    let t335 = circuit_mul(t302, in56); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t336 = circuit_add(in6, t335); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t337 = circuit_mul(t305, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t338 = circuit_add(t336, t337); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t339 = circuit_mul(t306, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t340 = circuit_add(t338, t339); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t341 = circuit_mul(t307, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t342 = circuit_add(t340, t341); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t343 = circuit_mul(t334, t342);
    let t344 = circuit_sub(t343, t79);
    let t345 = circuit_mul(t56, t344); // c_n_minus_2 * ((Π(n-2,k) (Pk(z)) - R_n_minus_2(z))
    let t346 = circuit_mul(t79, in57);
    let t347 = circuit_mul(t346, in58);
    let t348 = circuit_mul(t347, in59);
    let t349 = circuit_mul(t348, in55);
    let t350 = circuit_sub(t349, t101);
    let t351 = circuit_mul(t57, t350); // c_n_minus_1 * ((Π(n-1,k) (Pk(z)) - R_n_minus_1(z))
    let t352 = circuit_add(t345, t351);
    let t353 = circuit_add(in60, t352);
    let t354 = circuit_mul(in63, in56); // Eval UnnamedPoly step coeff_1 * z^1
    let t355 = circuit_add(in62, t354); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t356 = circuit_mul(in64, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t357 = circuit_add(t355, t356); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t358 = circuit_mul(in65, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t359 = circuit_add(t357, t358); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t360 = circuit_mul(in66, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t361 = circuit_add(t359, t360); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t362 = circuit_mul(in67, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t363 = circuit_add(t361, t362); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t364 = circuit_mul(in68, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t365 = circuit_add(t363, t364); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t366 = circuit_mul(in69, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t367 = circuit_add(t365, t366); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t368 = circuit_mul(in70, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t369 = circuit_add(t367, t368); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t370 = circuit_mul(in71, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t371 = circuit_add(t369, t370); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t372 = circuit_mul(in72, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t373 = circuit_add(t371, t372); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t374 = circuit_mul(in73, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t375 = circuit_add(t373, t374); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t376 = circuit_mul(in74, t10); // Eval UnnamedPoly step coeff_12 * z^12
    let t377 = circuit_add(t375, t376); // Eval UnnamedPoly step + (coeff_12 * z^12)
    let t378 = circuit_mul(in75, t11); // Eval UnnamedPoly step coeff_13 * z^13
    let t379 = circuit_add(t377, t378); // Eval UnnamedPoly step + (coeff_13 * z^13)
    let t380 = circuit_mul(in76, t12); // Eval UnnamedPoly step coeff_14 * z^14
    let t381 = circuit_add(t379, t380); // Eval UnnamedPoly step + (coeff_14 * z^14)
    let t382 = circuit_mul(in77, t13); // Eval UnnamedPoly step coeff_15 * z^15
    let t383 = circuit_add(t381, t382); // Eval UnnamedPoly step + (coeff_15 * z^15)
    let t384 = circuit_mul(in78, t14); // Eval UnnamedPoly step coeff_16 * z^16
    let t385 = circuit_add(t383, t384); // Eval UnnamedPoly step + (coeff_16 * z^16)
    let t386 = circuit_mul(in79, t15); // Eval UnnamedPoly step coeff_17 * z^17
    let t387 = circuit_add(t385, t386); // Eval UnnamedPoly step + (coeff_17 * z^17)
    let t388 = circuit_mul(in80, t16); // Eval UnnamedPoly step coeff_18 * z^18
    let t389 = circuit_add(t387, t388); // Eval UnnamedPoly step + (coeff_18 * z^18)
    let t390 = circuit_mul(in81, t17); // Eval UnnamedPoly step coeff_19 * z^19
    let t391 = circuit_add(t389, t390); // Eval UnnamedPoly step + (coeff_19 * z^19)
    let t392 = circuit_mul(in82, t18); // Eval UnnamedPoly step coeff_20 * z^20
    let t393 = circuit_add(t391, t392); // Eval UnnamedPoly step + (coeff_20 * z^20)
    let t394 = circuit_mul(in83, t19); // Eval UnnamedPoly step coeff_21 * z^21
    let t395 = circuit_add(t393, t394); // Eval UnnamedPoly step + (coeff_21 * z^21)
    let t396 = circuit_mul(in84, t20); // Eval UnnamedPoly step coeff_22 * z^22
    let t397 = circuit_add(t395, t396); // Eval UnnamedPoly step + (coeff_22 * z^22)
    let t398 = circuit_mul(in85, t21); // Eval UnnamedPoly step coeff_23 * z^23
    let t399 = circuit_add(t397, t398); // Eval UnnamedPoly step + (coeff_23 * z^23)
    let t400 = circuit_mul(in86, t22); // Eval UnnamedPoly step coeff_24 * z^24
    let t401 = circuit_add(t399, t400); // Eval UnnamedPoly step + (coeff_24 * z^24)
    let t402 = circuit_mul(in87, t23); // Eval UnnamedPoly step coeff_25 * z^25
    let t403 = circuit_add(t401, t402); // Eval UnnamedPoly step + (coeff_25 * z^25)
    let t404 = circuit_mul(in88, t24); // Eval UnnamedPoly step coeff_26 * z^26
    let t405 = circuit_add(t403, t404); // Eval UnnamedPoly step + (coeff_26 * z^26)
    let t406 = circuit_mul(in89, t25); // Eval UnnamedPoly step coeff_27 * z^27
    let t407 = circuit_add(t405, t406); // Eval UnnamedPoly step + (coeff_27 * z^27)
    let t408 = circuit_mul(in90, t26); // Eval UnnamedPoly step coeff_28 * z^28
    let t409 = circuit_add(t407, t408); // Eval UnnamedPoly step + (coeff_28 * z^28)
    let t410 = circuit_mul(in91, t27); // Eval UnnamedPoly step coeff_29 * z^29
    let t411 = circuit_add(t409, t410); // Eval UnnamedPoly step + (coeff_29 * z^29)
    let t412 = circuit_mul(in92, t28); // Eval UnnamedPoly step coeff_30 * z^30
    let t413 = circuit_add(t411, t412); // Eval UnnamedPoly step + (coeff_30 * z^30)
    let t414 = circuit_mul(in93, t29); // Eval UnnamedPoly step coeff_31 * z^31
    let t415 = circuit_add(t413, t414); // Eval UnnamedPoly step + (coeff_31 * z^31)
    let t416 = circuit_mul(in94, t30); // Eval UnnamedPoly step coeff_32 * z^32
    let t417 = circuit_add(t415, t416); // Eval UnnamedPoly step + (coeff_32 * z^32)
    let t418 = circuit_mul(in95, t31); // Eval UnnamedPoly step coeff_33 * z^33
    let t419 = circuit_add(t417, t418); // Eval UnnamedPoly step + (coeff_33 * z^33)
    let t420 = circuit_mul(in96, t32); // Eval UnnamedPoly step coeff_34 * z^34
    let t421 = circuit_add(t419, t420); // Eval UnnamedPoly step + (coeff_34 * z^34)
    let t422 = circuit_mul(in97, t33); // Eval UnnamedPoly step coeff_35 * z^35
    let t423 = circuit_add(t421, t422); // Eval UnnamedPoly step + (coeff_35 * z^35)
    let t424 = circuit_mul(in98, t34); // Eval UnnamedPoly step coeff_36 * z^36
    let t425 = circuit_add(t423, t424); // Eval UnnamedPoly step + (coeff_36 * z^36)
    let t426 = circuit_mul(in99, t35); // Eval UnnamedPoly step coeff_37 * z^37
    let t427 = circuit_add(t425, t426); // Eval UnnamedPoly step + (coeff_37 * z^37)
    let t428 = circuit_mul(in100, t36); // Eval UnnamedPoly step coeff_38 * z^38
    let t429 = circuit_add(t427, t428); // Eval UnnamedPoly step + (coeff_38 * z^38)
    let t430 = circuit_mul(in101, t37); // Eval UnnamedPoly step coeff_39 * z^39
    let t431 = circuit_add(t429, t430); // Eval UnnamedPoly step + (coeff_39 * z^39)
    let t432 = circuit_mul(in102, t38); // Eval UnnamedPoly step coeff_40 * z^40
    let t433 = circuit_add(t431, t432); // Eval UnnamedPoly step + (coeff_40 * z^40)
    let t434 = circuit_mul(in103, t39); // Eval UnnamedPoly step coeff_41 * z^41
    let t435 = circuit_add(t433, t434); // Eval UnnamedPoly step + (coeff_41 * z^41)
    let t436 = circuit_mul(in104, t40); // Eval UnnamedPoly step coeff_42 * z^42
    let t437 = circuit_add(t435, t436); // Eval UnnamedPoly step + (coeff_42 * z^42)
    let t438 = circuit_mul(in105, t41); // Eval UnnamedPoly step coeff_43 * z^43
    let t439 = circuit_add(t437, t438); // Eval UnnamedPoly step + (coeff_43 * z^43)
    let t440 = circuit_mul(in106, t42); // Eval UnnamedPoly step coeff_44 * z^44
    let t441 = circuit_add(t439, t440); // Eval UnnamedPoly step + (coeff_44 * z^44)
    let t442 = circuit_mul(in107, t43); // Eval UnnamedPoly step coeff_45 * z^45
    let t443 = circuit_add(t441, t442); // Eval UnnamedPoly step + (coeff_45 * z^45)
    let t444 = circuit_mul(in108, t44); // Eval UnnamedPoly step coeff_46 * z^46
    let t445 = circuit_add(t443, t444); // Eval UnnamedPoly step + (coeff_46 * z^46)
    let t446 = circuit_mul(in109, t45); // Eval UnnamedPoly step coeff_47 * z^47
    let t447 = circuit_add(t445, t446); // Eval UnnamedPoly step + (coeff_47 * z^47)
    let t448 = circuit_mul(in110, t46); // Eval UnnamedPoly step coeff_48 * z^48
    let t449 = circuit_add(t447, t448); // Eval UnnamedPoly step + (coeff_48 * z^48)
    let t450 = circuit_mul(in111, t47); // Eval UnnamedPoly step coeff_49 * z^49
    let t451 = circuit_add(t449, t450); // Eval UnnamedPoly step + (coeff_49 * z^49)
    let t452 = circuit_mul(in112, t48); // Eval UnnamedPoly step coeff_50 * z^50
    let t453 = circuit_add(t451, t452); // Eval UnnamedPoly step + (coeff_50 * z^50)
    let t454 = circuit_mul(in113, t49); // Eval UnnamedPoly step coeff_51 * z^51
    let t455 = circuit_add(t453, t454); // Eval UnnamedPoly step + (coeff_51 * z^51)
    let t456 = circuit_mul(in114, t50); // Eval UnnamedPoly step coeff_52 * z^52
    let t457 = circuit_add(t455, t456); // Eval UnnamedPoly step + (coeff_52 * z^52)
    let t458 = circuit_mul(in115, t51); // Eval UnnamedPoly step coeff_53 * z^53
    let t459 = circuit_add(t457, t458); // Eval UnnamedPoly step + (coeff_53 * z^53)
    let t460 = circuit_mul(in116, t52); // Eval UnnamedPoly step coeff_54 * z^54
    let t461 = circuit_add(t459, t460); // Eval UnnamedPoly step + (coeff_54 * z^54)
    let t462 = circuit_mul(in117, t53); // Eval UnnamedPoly step coeff_55 * z^55
    let t463 = circuit_add(t461, t462); // Eval UnnamedPoly step + (coeff_55 * z^55)
    let t464 = circuit_mul(in118, t54); // Eval UnnamedPoly step coeff_56 * z^56
    let t465 = circuit_add(t463, t464); // Eval UnnamedPoly step + (coeff_56 * z^56)
    let t466 = circuit_mul(in119, t55); // Eval UnnamedPoly step coeff_57 * z^57
    let t467 = circuit_add(t465, t466); // Eval UnnamedPoly step + (coeff_57 * z^57)
    let t468 = circuit_mul(in9, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t469 = circuit_add(in8, t468); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t470 = circuit_add(t469, t10); // Eval sparse poly UnnamedPoly step + 1*z^12
    let t471 = circuit_mul(t467, t470);
    let t472 = circuit_sub(t353, t471);

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [32324006162389411176778628423, 57042285082623239461879769745, 3486998266802970665, 0]
    )
        .unwrap();

    let mut circuit_inputs = (t472,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0xc2c3330c99e39557176f553d, 0x4c0bec3cf559b143b78cc310, 0x2fb347984f7911f7, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0xb7c9dce1665d51c640fcba2, 0x4ba4cc8bd75a079432ae2a1d, 0x16c9e55061ebae20, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0xa9c95998dc54014671a0135a, 0xdc5ec698b6e2f9b9dbaae0ed, 0x63cf305489af5dc, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x8fa25bd282d37f632623b0e3, 0x704b5a7ec796f2b21807dc9, 0x7c03cbcac41049a, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0xbb966e3de4bd44e5607cfd48, 0x5e6dd9e7e0acccb0c28f069f, 0x30644e72e131a029, 0x0]);
    circuit_inputs = circuit_inputs.next([0x1, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x6871ca8d3c208c16d87cfd3e, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0]);
    circuit_inputs = circuit_inputs.next([0x52, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x6871ca8d3c208c16d87cfd35, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0]);
    circuit_inputs = circuit_inputs.next(original_Q0.x0);
    circuit_inputs = circuit_inputs.next(original_Q0.x1);
    circuit_inputs = circuit_inputs.next(original_Q0.y0);
    circuit_inputs = circuit_inputs.next(original_Q0.y1);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(Q0.x0);
    circuit_inputs = circuit_inputs.next(Q0.x1);
    circuit_inputs = circuit_inputs.next(Q0.y0);
    circuit_inputs = circuit_inputs.next(Q0.y1);
    circuit_inputs = circuit_inputs.next(original_Q1.x0);
    circuit_inputs = circuit_inputs.next(original_Q1.x1);
    circuit_inputs = circuit_inputs.next(original_Q1.y0);
    circuit_inputs = circuit_inputs.next(original_Q1.y1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(Q1.x0);
    circuit_inputs = circuit_inputs.next(Q1.x1);
    circuit_inputs = circuit_inputs.next(Q1.y0);
    circuit_inputs = circuit_inputs.next(Q1.y1);
    circuit_inputs = circuit_inputs.next(R_n_minus_2.w0);
    circuit_inputs = circuit_inputs.next(R_n_minus_2.w1);
    circuit_inputs = circuit_inputs.next(R_n_minus_2.w2);
    circuit_inputs = circuit_inputs.next(R_n_minus_2.w3);
    circuit_inputs = circuit_inputs.next(R_n_minus_2.w4);
    circuit_inputs = circuit_inputs.next(R_n_minus_2.w5);
    circuit_inputs = circuit_inputs.next(R_n_minus_2.w6);
    circuit_inputs = circuit_inputs.next(R_n_minus_2.w7);
    circuit_inputs = circuit_inputs.next(R_n_minus_2.w8);
    circuit_inputs = circuit_inputs.next(R_n_minus_2.w9);
    circuit_inputs = circuit_inputs.next(R_n_minus_2.w10);
    circuit_inputs = circuit_inputs.next(R_n_minus_2.w11);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w0);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w1);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w2);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w3);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w4);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w5);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w6);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w7);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w8);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w9);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w10);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w11);
    circuit_inputs = circuit_inputs.next(c_n_minus_3);
    circuit_inputs = circuit_inputs.next(w_of_z);
    circuit_inputs = circuit_inputs.next(z);
    circuit_inputs = circuit_inputs.next(c_inv_frob_1_of_z);
    circuit_inputs = circuit_inputs.next(c_frob_2_of_z);
    circuit_inputs = circuit_inputs.next(c_inv_frob_3_of_z);
    circuit_inputs = circuit_inputs.next(previous_lhs);
    circuit_inputs = circuit_inputs.next(R_n_minus_3_of_z);

    let mut Q = Q;
    while let Option::Some(val) = Q.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let final_check: u384 = outputs.get_output(t472);
    return (final_check,);
}
fn run_BN254_MP_CHECK_FINALIZE_BN_3_circuit(
    original_Q0: G2Point,
    yInv_0: u384,
    xNegOverY_0: u384,
    Q0: G2Point,
    original_Q1: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q1: G2Point,
    original_Q2: G2Point,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q2: G2Point,
    R_n_minus_2: E12D,
    R_n_minus_1: E12D,
    c_n_minus_3: u384,
    w_of_z: u384,
    z: u384,
    c_inv_frob_1_of_z: u384,
    c_frob_2_of_z: u384,
    c_inv_frob_3_of_z: u384,
    previous_lhs: u384,
    R_n_minus_3_of_z: u384,
    Q: Array<u384>
) -> (u384,) {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0x0
    let in1 = CircuitElement::<
        CircuitInput<1>
    > {}; // 0x2fb347984f7911f74c0bec3cf559b143b78cc310c2c3330c99e39557176f553d
    let in2 = CircuitElement::<
        CircuitInput<2>
    > {}; // 0x16c9e55061ebae204ba4cc8bd75a079432ae2a1d0b7c9dce1665d51c640fcba2
    let in3 = CircuitElement::<
        CircuitInput<3>
    > {}; // 0x63cf305489af5dcdc5ec698b6e2f9b9dbaae0eda9c95998dc54014671a0135a
    let in4 = CircuitElement::<
        CircuitInput<4>
    > {}; // 0x7c03cbcac41049a0704b5a7ec796f2b21807dc98fa25bd282d37f632623b0e3
    let in5 = CircuitElement::<
        CircuitInput<5>
    > {}; // 0x30644e72e131a0295e6dd9e7e0acccb0c28f069fbb966e3de4bd44e5607cfd48
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 0x1
    let in7 = CircuitElement::<CircuitInput<7>> {}; // -0x9 % p
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 0x52
    let in9 = CircuitElement::<CircuitInput<9>> {}; // -0x12 % p

    // INPUT stack
    let in10 = CircuitElement::<CircuitInput<10>> {}; // 
    let in11 = CircuitElement::<CircuitInput<11>> {}; // 
    let in12 = CircuitElement::<CircuitInput<12>> {}; // 
    let in13 = CircuitElement::<CircuitInput<13>> {}; // 
    let in14 = CircuitElement::<CircuitInput<14>> {}; // 
    let in15 = CircuitElement::<CircuitInput<15>> {}; // 
    let in16 = CircuitElement::<CircuitInput<16>> {}; // 
    let in17 = CircuitElement::<CircuitInput<17>> {}; // 
    let in18 = CircuitElement::<CircuitInput<18>> {}; // 
    let in19 = CircuitElement::<CircuitInput<19>> {}; // 
    let in20 = CircuitElement::<CircuitInput<20>> {}; // 
    let in21 = CircuitElement::<CircuitInput<21>> {}; // 
    let in22 = CircuitElement::<CircuitInput<22>> {}; // 
    let in23 = CircuitElement::<CircuitInput<23>> {}; // 
    let in24 = CircuitElement::<CircuitInput<24>> {}; // 
    let in25 = CircuitElement::<CircuitInput<25>> {}; // 
    let in26 = CircuitElement::<CircuitInput<26>> {}; // 
    let in27 = CircuitElement::<CircuitInput<27>> {}; // 
    let in28 = CircuitElement::<CircuitInput<28>> {}; // 
    let in29 = CircuitElement::<CircuitInput<29>> {}; // 
    let in30 = CircuitElement::<CircuitInput<30>> {}; // 
    let in31 = CircuitElement::<CircuitInput<31>> {}; // 
    let in32 = CircuitElement::<CircuitInput<32>> {}; // 
    let in33 = CircuitElement::<CircuitInput<33>> {}; // 
    let in34 = CircuitElement::<CircuitInput<34>> {}; // 
    let in35 = CircuitElement::<CircuitInput<35>> {}; // 
    let in36 = CircuitElement::<CircuitInput<36>> {}; // 
    let in37 = CircuitElement::<CircuitInput<37>> {}; // 
    let in38 = CircuitElement::<CircuitInput<38>> {}; // 
    let in39 = CircuitElement::<CircuitInput<39>> {}; // 
    let in40 = CircuitElement::<CircuitInput<40>> {}; // 
    let in41 = CircuitElement::<CircuitInput<41>> {}; // 
    let in42 = CircuitElement::<CircuitInput<42>> {}; // 
    let in43 = CircuitElement::<CircuitInput<43>> {}; // 
    let in44 = CircuitElement::<CircuitInput<44>> {}; // 
    let in45 = CircuitElement::<CircuitInput<45>> {}; // 
    let in46 = CircuitElement::<CircuitInput<46>> {}; // 
    let in47 = CircuitElement::<CircuitInput<47>> {}; // 
    let in48 = CircuitElement::<CircuitInput<48>> {}; // 
    let in49 = CircuitElement::<CircuitInput<49>> {}; // 
    let in50 = CircuitElement::<CircuitInput<50>> {}; // 
    let in51 = CircuitElement::<CircuitInput<51>> {}; // 
    let in52 = CircuitElement::<CircuitInput<52>> {}; // 
    let in53 = CircuitElement::<CircuitInput<53>> {}; // 
    let in54 = CircuitElement::<CircuitInput<54>> {}; // 
    let in55 = CircuitElement::<CircuitInput<55>> {}; // 
    let in56 = CircuitElement::<CircuitInput<56>> {}; // 
    let in57 = CircuitElement::<CircuitInput<57>> {}; // 
    let in58 = CircuitElement::<CircuitInput<58>> {}; // 
    let in59 = CircuitElement::<CircuitInput<59>> {}; // 
    let in60 = CircuitElement::<CircuitInput<60>> {}; // 
    let in61 = CircuitElement::<CircuitInput<61>> {}; // 
    let in62 = CircuitElement::<CircuitInput<62>> {}; // 
    let in63 = CircuitElement::<CircuitInput<63>> {}; // 
    let in64 = CircuitElement::<CircuitInput<64>> {}; // 
    let in65 = CircuitElement::<CircuitInput<65>> {}; // 
    let in66 = CircuitElement::<CircuitInput<66>> {}; // 
    let in67 = CircuitElement::<CircuitInput<67>> {}; // 
    let in68 = CircuitElement::<CircuitInput<68>> {}; // 
    let in69 = CircuitElement::<CircuitInput<69>> {}; // 
    let in70 = CircuitElement::<CircuitInput<70>> {}; // 
    let in71 = CircuitElement::<CircuitInput<71>> {}; // 
    let in72 = CircuitElement::<CircuitInput<72>> {}; // 
    let in73 = CircuitElement::<CircuitInput<73>> {}; // 
    let in74 = CircuitElement::<CircuitInput<74>> {}; // 
    let in75 = CircuitElement::<CircuitInput<75>> {}; // 
    let in76 = CircuitElement::<CircuitInput<76>> {}; // 
    let in77 = CircuitElement::<CircuitInput<77>> {}; // 
    let in78 = CircuitElement::<CircuitInput<78>> {}; // 
    let in79 = CircuitElement::<CircuitInput<79>> {}; // 
    let in80 = CircuitElement::<CircuitInput<80>> {}; // 
    let in81 = CircuitElement::<CircuitInput<81>> {}; // 
    let in82 = CircuitElement::<CircuitInput<82>> {}; // 
    let in83 = CircuitElement::<CircuitInput<83>> {}; // 
    let in84 = CircuitElement::<CircuitInput<84>> {}; // 
    let in85 = CircuitElement::<CircuitInput<85>> {}; // 
    let in86 = CircuitElement::<CircuitInput<86>> {}; // 
    let in87 = CircuitElement::<CircuitInput<87>> {}; // 
    let in88 = CircuitElement::<CircuitInput<88>> {}; // 
    let in89 = CircuitElement::<CircuitInput<89>> {}; // 
    let in90 = CircuitElement::<CircuitInput<90>> {}; // 
    let in91 = CircuitElement::<CircuitInput<91>> {}; // 
    let in92 = CircuitElement::<CircuitInput<92>> {}; // 
    let in93 = CircuitElement::<CircuitInput<93>> {}; // 
    let in94 = CircuitElement::<CircuitInput<94>> {}; // 
    let in95 = CircuitElement::<CircuitInput<95>> {}; // 
    let in96 = CircuitElement::<CircuitInput<96>> {}; // 
    let in97 = CircuitElement::<CircuitInput<97>> {}; // 
    let in98 = CircuitElement::<CircuitInput<98>> {}; // 
    let in99 = CircuitElement::<CircuitInput<99>> {}; // 
    let in100 = CircuitElement::<CircuitInput<100>> {}; // 
    let in101 = CircuitElement::<CircuitInput<101>> {}; // 
    let in102 = CircuitElement::<CircuitInput<102>> {}; // 
    let in103 = CircuitElement::<CircuitInput<103>> {}; // 
    let in104 = CircuitElement::<CircuitInput<104>> {}; // 
    let in105 = CircuitElement::<CircuitInput<105>> {}; // 
    let in106 = CircuitElement::<CircuitInput<106>> {}; // 
    let in107 = CircuitElement::<CircuitInput<107>> {}; // 
    let in108 = CircuitElement::<CircuitInput<108>> {}; // 
    let in109 = CircuitElement::<CircuitInput<109>> {}; // 
    let in110 = CircuitElement::<CircuitInput<110>> {}; // 
    let in111 = CircuitElement::<CircuitInput<111>> {}; // 
    let in112 = CircuitElement::<CircuitInput<112>> {}; // 
    let in113 = CircuitElement::<CircuitInput<113>> {}; // 
    let in114 = CircuitElement::<CircuitInput<114>> {}; // 
    let in115 = CircuitElement::<CircuitInput<115>> {}; // 
    let in116 = CircuitElement::<CircuitInput<116>> {}; // 
    let in117 = CircuitElement::<CircuitInput<117>> {}; // 
    let in118 = CircuitElement::<CircuitInput<118>> {}; // 
    let in119 = CircuitElement::<CircuitInput<119>> {}; // 
    let in120 = CircuitElement::<CircuitInput<120>> {}; // 
    let in121 = CircuitElement::<CircuitInput<121>> {}; // 
    let in122 = CircuitElement::<CircuitInput<122>> {}; // 
    let in123 = CircuitElement::<CircuitInput<123>> {}; // 
    let in124 = CircuitElement::<CircuitInput<124>> {}; // 
    let in125 = CircuitElement::<CircuitInput<125>> {}; // 
    let in126 = CircuitElement::<CircuitInput<126>> {}; // 
    let in127 = CircuitElement::<CircuitInput<127>> {}; // 
    let in128 = CircuitElement::<CircuitInput<128>> {}; // 
    let in129 = CircuitElement::<CircuitInput<129>> {}; // 
    let in130 = CircuitElement::<CircuitInput<130>> {}; // 
    let in131 = CircuitElement::<CircuitInput<131>> {}; // 
    let in132 = CircuitElement::<CircuitInput<132>> {}; // 
    let in133 = CircuitElement::<CircuitInput<133>> {}; // 
    let in134 = CircuitElement::<CircuitInput<134>> {}; // 
    let in135 = CircuitElement::<CircuitInput<135>> {}; // 
    let in136 = CircuitElement::<CircuitInput<136>> {}; // 
    let in137 = CircuitElement::<CircuitInput<137>> {}; // 
    let in138 = CircuitElement::<CircuitInput<138>> {}; // 
    let in139 = CircuitElement::<CircuitInput<139>> {}; // 
    let in140 = CircuitElement::<CircuitInput<140>> {}; // 
    let in141 = CircuitElement::<CircuitInput<141>> {}; // 
    let in142 = CircuitElement::<CircuitInput<142>> {}; // 
    let in143 = CircuitElement::<CircuitInput<143>> {}; // 
    let in144 = CircuitElement::<CircuitInput<144>> {}; // 
    let in145 = CircuitElement::<CircuitInput<145>> {}; // 
    let in146 = CircuitElement::<CircuitInput<146>> {}; // 
    let in147 = CircuitElement::<CircuitInput<147>> {}; // 
    let t0 = circuit_mul(in66, in66); // Compute z^2
    let t1 = circuit_mul(t0, in66); // Compute z^3
    let t2 = circuit_mul(t1, in66); // Compute z^4
    let t3 = circuit_mul(t2, in66); // Compute z^5
    let t4 = circuit_mul(t3, in66); // Compute z^6
    let t5 = circuit_mul(t4, in66); // Compute z^7
    let t6 = circuit_mul(t5, in66); // Compute z^8
    let t7 = circuit_mul(t6, in66); // Compute z^9
    let t8 = circuit_mul(t7, in66); // Compute z^10
    let t9 = circuit_mul(t8, in66); // Compute z^11
    let t10 = circuit_mul(t9, in66); // Compute z^12
    let t11 = circuit_mul(t10, in66); // Compute z^13
    let t12 = circuit_mul(t11, in66); // Compute z^14
    let t13 = circuit_mul(t12, in66); // Compute z^15
    let t14 = circuit_mul(t13, in66); // Compute z^16
    let t15 = circuit_mul(t14, in66); // Compute z^17
    let t16 = circuit_mul(t15, in66); // Compute z^18
    let t17 = circuit_mul(t16, in66); // Compute z^19
    let t18 = circuit_mul(t17, in66); // Compute z^20
    let t19 = circuit_mul(t18, in66); // Compute z^21
    let t20 = circuit_mul(t19, in66); // Compute z^22
    let t21 = circuit_mul(t20, in66); // Compute z^23
    let t22 = circuit_mul(t21, in66); // Compute z^24
    let t23 = circuit_mul(t22, in66); // Compute z^25
    let t24 = circuit_mul(t23, in66); // Compute z^26
    let t25 = circuit_mul(t24, in66); // Compute z^27
    let t26 = circuit_mul(t25, in66); // Compute z^28
    let t27 = circuit_mul(t26, in66); // Compute z^29
    let t28 = circuit_mul(t27, in66); // Compute z^30
    let t29 = circuit_mul(t28, in66); // Compute z^31
    let t30 = circuit_mul(t29, in66); // Compute z^32
    let t31 = circuit_mul(t30, in66); // Compute z^33
    let t32 = circuit_mul(t31, in66); // Compute z^34
    let t33 = circuit_mul(t32, in66); // Compute z^35
    let t34 = circuit_mul(t33, in66); // Compute z^36
    let t35 = circuit_mul(t34, in66); // Compute z^37
    let t36 = circuit_mul(t35, in66); // Compute z^38
    let t37 = circuit_mul(t36, in66); // Compute z^39
    let t38 = circuit_mul(t37, in66); // Compute z^40
    let t39 = circuit_mul(t38, in66); // Compute z^41
    let t40 = circuit_mul(t39, in66); // Compute z^42
    let t41 = circuit_mul(t40, in66); // Compute z^43
    let t42 = circuit_mul(t41, in66); // Compute z^44
    let t43 = circuit_mul(t42, in66); // Compute z^45
    let t44 = circuit_mul(t43, in66); // Compute z^46
    let t45 = circuit_mul(t44, in66); // Compute z^47
    let t46 = circuit_mul(t45, in66); // Compute z^48
    let t47 = circuit_mul(t46, in66); // Compute z^49
    let t48 = circuit_mul(t47, in66); // Compute z^50
    let t49 = circuit_mul(t48, in66); // Compute z^51
    let t50 = circuit_mul(t49, in66); // Compute z^52
    let t51 = circuit_mul(t50, in66); // Compute z^53
    let t52 = circuit_mul(t51, in66); // Compute z^54
    let t53 = circuit_mul(t52, in66); // Compute z^55
    let t54 = circuit_mul(t53, in66); // Compute z^56
    let t55 = circuit_mul(t54, in66); // Compute z^57
    let t56 = circuit_mul(t55, in66); // Compute z^58
    let t57 = circuit_mul(t56, in66); // Compute z^59
    let t58 = circuit_mul(t57, in66); // Compute z^60
    let t59 = circuit_mul(t58, in66); // Compute z^61
    let t60 = circuit_mul(t59, in66); // Compute z^62
    let t61 = circuit_mul(t60, in66); // Compute z^63
    let t62 = circuit_mul(t61, in66); // Compute z^64
    let t63 = circuit_mul(t62, in66); // Compute z^65
    let t64 = circuit_mul(t63, in66); // Compute z^66
    let t65 = circuit_mul(t64, in66); // Compute z^67
    let t66 = circuit_mul(t65, in66); // Compute z^68
    let t67 = circuit_mul(t66, in66); // Compute z^69
    let t68 = circuit_mul(t67, in66); // Compute z^70
    let t69 = circuit_mul(t68, in66); // Compute z^71
    let t70 = circuit_mul(t69, in66); // Compute z^72
    let t71 = circuit_mul(t70, in66); // Compute z^73
    let t72 = circuit_mul(t71, in66); // Compute z^74
    let t73 = circuit_mul(t72, in66); // Compute z^75
    let t74 = circuit_mul(in64, in64);
    let t75 = circuit_mul(t74, in64);
    let t76 = circuit_mul(in41, in66); // Eval UnnamedPoly step coeff_1 * z^1
    let t77 = circuit_add(in40, t76); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t78 = circuit_mul(in42, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t79 = circuit_add(t77, t78); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t80 = circuit_mul(in43, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t81 = circuit_add(t79, t80); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t82 = circuit_mul(in44, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t83 = circuit_add(t81, t82); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t84 = circuit_mul(in45, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t85 = circuit_add(t83, t84); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t86 = circuit_mul(in46, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t87 = circuit_add(t85, t86); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t88 = circuit_mul(in47, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t89 = circuit_add(t87, t88); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t90 = circuit_mul(in48, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t91 = circuit_add(t89, t90); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t92 = circuit_mul(in49, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t93 = circuit_add(t91, t92); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t94 = circuit_mul(in50, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t95 = circuit_add(t93, t94); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t96 = circuit_mul(in51, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t97 = circuit_add(t95, t96); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t98 = circuit_mul(in53, in66); // Eval UnnamedPoly step coeff_1 * z^1
    let t99 = circuit_add(in52, t98); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t100 = circuit_mul(in54, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t101 = circuit_add(t99, t100); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t102 = circuit_mul(in55, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t103 = circuit_add(t101, t102); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t104 = circuit_mul(in56, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t105 = circuit_add(t103, t104); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t106 = circuit_mul(in57, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t107 = circuit_add(t105, t106); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t108 = circuit_mul(in58, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t109 = circuit_add(t107, t108); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t110 = circuit_mul(in59, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t111 = circuit_add(t109, t110); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t112 = circuit_mul(in60, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t113 = circuit_add(t111, t112); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t114 = circuit_mul(in61, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t115 = circuit_add(t113, t114); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t116 = circuit_mul(in62, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t117 = circuit_add(t115, t116); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t118 = circuit_mul(in63, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t119 = circuit_add(t117, t118); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t120 = circuit_sub(in0, in11);
    let t121 = circuit_sub(in0, in13);
    let t122 = circuit_mul(in10, in1); // Fp2 mul start
    let t123 = circuit_mul(t120, in2);
    let t124 = circuit_sub(t122, t123); // Fp2 mul real part end
    let t125 = circuit_mul(in10, in2);
    let t126 = circuit_mul(t120, in1);
    let t127 = circuit_add(t125, t126); // Fp2 mul imag part end
    let t128 = circuit_mul(in12, in3); // Fp2 mul start
    let t129 = circuit_mul(t121, in4);
    let t130 = circuit_sub(t128, t129); // Fp2 mul real part end
    let t131 = circuit_mul(in12, in4);
    let t132 = circuit_mul(t121, in3);
    let t133 = circuit_add(t131, t132); // Fp2 mul imag part end
    let t134 = circuit_mul(in10, in5); // Fp2 scalar mul coeff 0/1
    let t135 = circuit_mul(in11, in5); // Fp2 scalar mul coeff 1/1
    let t136 = circuit_mul(in12, in6); // Fp2 scalar mul coeff 0/1
    let t137 = circuit_mul(in13, in6); // Fp2 scalar mul coeff 1/1
    let t138 = circuit_sub(in18, t130); // Fp2 sub coeff 0/1
    let t139 = circuit_sub(in19, t133); // Fp2 sub coeff 1/1
    let t140 = circuit_sub(in16, t124); // Fp2 sub coeff 0/1
    let t141 = circuit_sub(in17, t127); // Fp2 sub coeff 1/1
    let t142 = circuit_mul(t140, t140); // Fp2 Div x/y start : Fp2 Inv y start
    let t143 = circuit_mul(t141, t141);
    let t144 = circuit_add(t142, t143);
    let t145 = circuit_inverse(t144);
    let t146 = circuit_mul(t140, t145); // Fp2 Inv y real part end
    let t147 = circuit_mul(t141, t145);
    let t148 = circuit_sub(in0, t147); // Fp2 Inv y imag part end
    let t149 = circuit_mul(t138, t146); // Fp2 mul start
    let t150 = circuit_mul(t139, t148);
    let t151 = circuit_sub(t149, t150); // Fp2 mul real part end
    let t152 = circuit_mul(t138, t148);
    let t153 = circuit_mul(t139, t146);
    let t154 = circuit_add(t152, t153); // Fp2 mul imag part end
    let t155 = circuit_add(t151, t154);
    let t156 = circuit_sub(t151, t154);
    let t157 = circuit_mul(t155, t156);
    let t158 = circuit_mul(t151, t154);
    let t159 = circuit_add(t158, t158);
    let t160 = circuit_add(in16, t124); // Fp2 add coeff 0/1
    let t161 = circuit_add(in17, t127); // Fp2 add coeff 1/1
    let t162 = circuit_sub(t157, t160); // Fp2 sub coeff 0/1
    let t163 = circuit_sub(t159, t161); // Fp2 sub coeff 1/1
    let t164 = circuit_sub(in16, t162); // Fp2 sub coeff 0/1
    let t165 = circuit_sub(in17, t163); // Fp2 sub coeff 1/1
    let t166 = circuit_mul(t151, t164); // Fp2 mul start
    let t167 = circuit_mul(t154, t165);
    let t168 = circuit_sub(t166, t167); // Fp2 mul real part end
    let t169 = circuit_mul(t151, t165);
    let t170 = circuit_mul(t154, t164);
    let t171 = circuit_add(t169, t170); // Fp2 mul imag part end
    let t172 = circuit_sub(t168, in18); // Fp2 sub coeff 0/1
    let t173 = circuit_sub(t171, in19); // Fp2 sub coeff 1/1
    let t174 = circuit_mul(t151, in16); // Fp2 mul start
    let t175 = circuit_mul(t154, in17);
    let t176 = circuit_sub(t174, t175); // Fp2 mul real part end
    let t177 = circuit_mul(t151, in17);
    let t178 = circuit_mul(t154, in16);
    let t179 = circuit_add(t177, t178); // Fp2 mul imag part end
    let t180 = circuit_sub(t176, in18); // Fp2 sub coeff 0/1
    let t181 = circuit_sub(t179, in19); // Fp2 sub coeff 1/1
    let t182 = circuit_mul(in7, t154);
    let t183 = circuit_add(t151, t182);
    let t184 = circuit_mul(t183, in15);
    let t185 = circuit_mul(in7, t181);
    let t186 = circuit_add(t180, t185);
    let t187 = circuit_mul(t186, in14);
    let t188 = circuit_mul(t154, in15);
    let t189 = circuit_mul(t181, in14);
    let t190 = circuit_sub(t172, t136); // Fp2 sub coeff 0/1
    let t191 = circuit_sub(t173, t137); // Fp2 sub coeff 1/1
    let t192 = circuit_sub(t162, t134); // Fp2 sub coeff 0/1
    let t193 = circuit_sub(t163, t135); // Fp2 sub coeff 1/1
    let t194 = circuit_mul(t192, t192); // Fp2 Div x/y start : Fp2 Inv y start
    let t195 = circuit_mul(t193, t193);
    let t196 = circuit_add(t194, t195);
    let t197 = circuit_inverse(t196);
    let t198 = circuit_mul(t192, t197); // Fp2 Inv y real part end
    let t199 = circuit_mul(t193, t197);
    let t200 = circuit_sub(in0, t199); // Fp2 Inv y imag part end
    let t201 = circuit_mul(t190, t198); // Fp2 mul start
    let t202 = circuit_mul(t191, t200);
    let t203 = circuit_sub(t201, t202); // Fp2 mul real part end
    let t204 = circuit_mul(t190, t200);
    let t205 = circuit_mul(t191, t198);
    let t206 = circuit_add(t204, t205); // Fp2 mul imag part end
    let t207 = circuit_mul(t203, t162); // Fp2 mul start
    let t208 = circuit_mul(t206, t163);
    let t209 = circuit_sub(t207, t208); // Fp2 mul real part end
    let t210 = circuit_mul(t203, t163);
    let t211 = circuit_mul(t206, t162);
    let t212 = circuit_add(t210, t211); // Fp2 mul imag part end
    let t213 = circuit_sub(t209, t172); // Fp2 sub coeff 0/1
    let t214 = circuit_sub(t212, t173); // Fp2 sub coeff 1/1
    let t215 = circuit_mul(in7, t206);
    let t216 = circuit_add(t203, t215);
    let t217 = circuit_mul(t216, in15);
    let t218 = circuit_mul(in7, t214);
    let t219 = circuit_add(t213, t218);
    let t220 = circuit_mul(t219, in14);
    let t221 = circuit_mul(t206, in15);
    let t222 = circuit_mul(t214, in14);
    let t223 = circuit_sub(in0, in21);
    let t224 = circuit_sub(in0, in23);
    let t225 = circuit_mul(in20, in1); // Fp2 mul start
    let t226 = circuit_mul(t223, in2);
    let t227 = circuit_sub(t225, t226); // Fp2 mul real part end
    let t228 = circuit_mul(in20, in2);
    let t229 = circuit_mul(t223, in1);
    let t230 = circuit_add(t228, t229); // Fp2 mul imag part end
    let t231 = circuit_mul(in22, in3); // Fp2 mul start
    let t232 = circuit_mul(t224, in4);
    let t233 = circuit_sub(t231, t232); // Fp2 mul real part end
    let t234 = circuit_mul(in22, in4);
    let t235 = circuit_mul(t224, in3);
    let t236 = circuit_add(t234, t235); // Fp2 mul imag part end
    let t237 = circuit_mul(in20, in5); // Fp2 scalar mul coeff 0/1
    let t238 = circuit_mul(in21, in5); // Fp2 scalar mul coeff 1/1
    let t239 = circuit_mul(in22, in6); // Fp2 scalar mul coeff 0/1
    let t240 = circuit_mul(in23, in6); // Fp2 scalar mul coeff 1/1
    let t241 = circuit_sub(in28, t233); // Fp2 sub coeff 0/1
    let t242 = circuit_sub(in29, t236); // Fp2 sub coeff 1/1
    let t243 = circuit_sub(in26, t227); // Fp2 sub coeff 0/1
    let t244 = circuit_sub(in27, t230); // Fp2 sub coeff 1/1
    let t245 = circuit_mul(t243, t243); // Fp2 Div x/y start : Fp2 Inv y start
    let t246 = circuit_mul(t244, t244);
    let t247 = circuit_add(t245, t246);
    let t248 = circuit_inverse(t247);
    let t249 = circuit_mul(t243, t248); // Fp2 Inv y real part end
    let t250 = circuit_mul(t244, t248);
    let t251 = circuit_sub(in0, t250); // Fp2 Inv y imag part end
    let t252 = circuit_mul(t241, t249); // Fp2 mul start
    let t253 = circuit_mul(t242, t251);
    let t254 = circuit_sub(t252, t253); // Fp2 mul real part end
    let t255 = circuit_mul(t241, t251);
    let t256 = circuit_mul(t242, t249);
    let t257 = circuit_add(t255, t256); // Fp2 mul imag part end
    let t258 = circuit_add(t254, t257);
    let t259 = circuit_sub(t254, t257);
    let t260 = circuit_mul(t258, t259);
    let t261 = circuit_mul(t254, t257);
    let t262 = circuit_add(t261, t261);
    let t263 = circuit_add(in26, t227); // Fp2 add coeff 0/1
    let t264 = circuit_add(in27, t230); // Fp2 add coeff 1/1
    let t265 = circuit_sub(t260, t263); // Fp2 sub coeff 0/1
    let t266 = circuit_sub(t262, t264); // Fp2 sub coeff 1/1
    let t267 = circuit_sub(in26, t265); // Fp2 sub coeff 0/1
    let t268 = circuit_sub(in27, t266); // Fp2 sub coeff 1/1
    let t269 = circuit_mul(t254, t267); // Fp2 mul start
    let t270 = circuit_mul(t257, t268);
    let t271 = circuit_sub(t269, t270); // Fp2 mul real part end
    let t272 = circuit_mul(t254, t268);
    let t273 = circuit_mul(t257, t267);
    let t274 = circuit_add(t272, t273); // Fp2 mul imag part end
    let t275 = circuit_sub(t271, in28); // Fp2 sub coeff 0/1
    let t276 = circuit_sub(t274, in29); // Fp2 sub coeff 1/1
    let t277 = circuit_mul(t254, in26); // Fp2 mul start
    let t278 = circuit_mul(t257, in27);
    let t279 = circuit_sub(t277, t278); // Fp2 mul real part end
    let t280 = circuit_mul(t254, in27);
    let t281 = circuit_mul(t257, in26);
    let t282 = circuit_add(t280, t281); // Fp2 mul imag part end
    let t283 = circuit_sub(t279, in28); // Fp2 sub coeff 0/1
    let t284 = circuit_sub(t282, in29); // Fp2 sub coeff 1/1
    let t285 = circuit_mul(in7, t257);
    let t286 = circuit_add(t254, t285);
    let t287 = circuit_mul(t286, in25);
    let t288 = circuit_mul(in7, t284);
    let t289 = circuit_add(t283, t288);
    let t290 = circuit_mul(t289, in24);
    let t291 = circuit_mul(t257, in25);
    let t292 = circuit_mul(t284, in24);
    let t293 = circuit_sub(t275, t239); // Fp2 sub coeff 0/1
    let t294 = circuit_sub(t276, t240); // Fp2 sub coeff 1/1
    let t295 = circuit_sub(t265, t237); // Fp2 sub coeff 0/1
    let t296 = circuit_sub(t266, t238); // Fp2 sub coeff 1/1
    let t297 = circuit_mul(t295, t295); // Fp2 Div x/y start : Fp2 Inv y start
    let t298 = circuit_mul(t296, t296);
    let t299 = circuit_add(t297, t298);
    let t300 = circuit_inverse(t299);
    let t301 = circuit_mul(t295, t300); // Fp2 Inv y real part end
    let t302 = circuit_mul(t296, t300);
    let t303 = circuit_sub(in0, t302); // Fp2 Inv y imag part end
    let t304 = circuit_mul(t293, t301); // Fp2 mul start
    let t305 = circuit_mul(t294, t303);
    let t306 = circuit_sub(t304, t305); // Fp2 mul real part end
    let t307 = circuit_mul(t293, t303);
    let t308 = circuit_mul(t294, t301);
    let t309 = circuit_add(t307, t308); // Fp2 mul imag part end
    let t310 = circuit_mul(t306, t265); // Fp2 mul start
    let t311 = circuit_mul(t309, t266);
    let t312 = circuit_sub(t310, t311); // Fp2 mul real part end
    let t313 = circuit_mul(t306, t266);
    let t314 = circuit_mul(t309, t265);
    let t315 = circuit_add(t313, t314); // Fp2 mul imag part end
    let t316 = circuit_sub(t312, t275); // Fp2 sub coeff 0/1
    let t317 = circuit_sub(t315, t276); // Fp2 sub coeff 1/1
    let t318 = circuit_mul(in7, t309);
    let t319 = circuit_add(t306, t318);
    let t320 = circuit_mul(t319, in25);
    let t321 = circuit_mul(in7, t317);
    let t322 = circuit_add(t316, t321);
    let t323 = circuit_mul(t322, in24);
    let t324 = circuit_mul(t309, in25);
    let t325 = circuit_mul(t317, in24);
    let t326 = circuit_sub(in0, in31);
    let t327 = circuit_sub(in0, in33);
    let t328 = circuit_mul(in30, in1); // Fp2 mul start
    let t329 = circuit_mul(t326, in2);
    let t330 = circuit_sub(t328, t329); // Fp2 mul real part end
    let t331 = circuit_mul(in30, in2);
    let t332 = circuit_mul(t326, in1);
    let t333 = circuit_add(t331, t332); // Fp2 mul imag part end
    let t334 = circuit_mul(in32, in3); // Fp2 mul start
    let t335 = circuit_mul(t327, in4);
    let t336 = circuit_sub(t334, t335); // Fp2 mul real part end
    let t337 = circuit_mul(in32, in4);
    let t338 = circuit_mul(t327, in3);
    let t339 = circuit_add(t337, t338); // Fp2 mul imag part end
    let t340 = circuit_mul(in30, in5); // Fp2 scalar mul coeff 0/1
    let t341 = circuit_mul(in31, in5); // Fp2 scalar mul coeff 1/1
    let t342 = circuit_mul(in32, in6); // Fp2 scalar mul coeff 0/1
    let t343 = circuit_mul(in33, in6); // Fp2 scalar mul coeff 1/1
    let t344 = circuit_sub(in38, t336); // Fp2 sub coeff 0/1
    let t345 = circuit_sub(in39, t339); // Fp2 sub coeff 1/1
    let t346 = circuit_sub(in36, t330); // Fp2 sub coeff 0/1
    let t347 = circuit_sub(in37, t333); // Fp2 sub coeff 1/1
    let t348 = circuit_mul(t346, t346); // Fp2 Div x/y start : Fp2 Inv y start
    let t349 = circuit_mul(t347, t347);
    let t350 = circuit_add(t348, t349);
    let t351 = circuit_inverse(t350);
    let t352 = circuit_mul(t346, t351); // Fp2 Inv y real part end
    let t353 = circuit_mul(t347, t351);
    let t354 = circuit_sub(in0, t353); // Fp2 Inv y imag part end
    let t355 = circuit_mul(t344, t352); // Fp2 mul start
    let t356 = circuit_mul(t345, t354);
    let t357 = circuit_sub(t355, t356); // Fp2 mul real part end
    let t358 = circuit_mul(t344, t354);
    let t359 = circuit_mul(t345, t352);
    let t360 = circuit_add(t358, t359); // Fp2 mul imag part end
    let t361 = circuit_add(t357, t360);
    let t362 = circuit_sub(t357, t360);
    let t363 = circuit_mul(t361, t362);
    let t364 = circuit_mul(t357, t360);
    let t365 = circuit_add(t364, t364);
    let t366 = circuit_add(in36, t330); // Fp2 add coeff 0/1
    let t367 = circuit_add(in37, t333); // Fp2 add coeff 1/1
    let t368 = circuit_sub(t363, t366); // Fp2 sub coeff 0/1
    let t369 = circuit_sub(t365, t367); // Fp2 sub coeff 1/1
    let t370 = circuit_sub(in36, t368); // Fp2 sub coeff 0/1
    let t371 = circuit_sub(in37, t369); // Fp2 sub coeff 1/1
    let t372 = circuit_mul(t357, t370); // Fp2 mul start
    let t373 = circuit_mul(t360, t371);
    let t374 = circuit_sub(t372, t373); // Fp2 mul real part end
    let t375 = circuit_mul(t357, t371);
    let t376 = circuit_mul(t360, t370);
    let t377 = circuit_add(t375, t376); // Fp2 mul imag part end
    let t378 = circuit_sub(t374, in38); // Fp2 sub coeff 0/1
    let t379 = circuit_sub(t377, in39); // Fp2 sub coeff 1/1
    let t380 = circuit_mul(t357, in36); // Fp2 mul start
    let t381 = circuit_mul(t360, in37);
    let t382 = circuit_sub(t380, t381); // Fp2 mul real part end
    let t383 = circuit_mul(t357, in37);
    let t384 = circuit_mul(t360, in36);
    let t385 = circuit_add(t383, t384); // Fp2 mul imag part end
    let t386 = circuit_sub(t382, in38); // Fp2 sub coeff 0/1
    let t387 = circuit_sub(t385, in39); // Fp2 sub coeff 1/1
    let t388 = circuit_mul(in7, t360);
    let t389 = circuit_add(t357, t388);
    let t390 = circuit_mul(t389, in35);
    let t391 = circuit_mul(in7, t387);
    let t392 = circuit_add(t386, t391);
    let t393 = circuit_mul(t392, in34);
    let t394 = circuit_mul(t360, in35);
    let t395 = circuit_mul(t387, in34);
    let t396 = circuit_sub(t378, t342); // Fp2 sub coeff 0/1
    let t397 = circuit_sub(t379, t343); // Fp2 sub coeff 1/1
    let t398 = circuit_sub(t368, t340); // Fp2 sub coeff 0/1
    let t399 = circuit_sub(t369, t341); // Fp2 sub coeff 1/1
    let t400 = circuit_mul(t398, t398); // Fp2 Div x/y start : Fp2 Inv y start
    let t401 = circuit_mul(t399, t399);
    let t402 = circuit_add(t400, t401);
    let t403 = circuit_inverse(t402);
    let t404 = circuit_mul(t398, t403); // Fp2 Inv y real part end
    let t405 = circuit_mul(t399, t403);
    let t406 = circuit_sub(in0, t405); // Fp2 Inv y imag part end
    let t407 = circuit_mul(t396, t404); // Fp2 mul start
    let t408 = circuit_mul(t397, t406);
    let t409 = circuit_sub(t407, t408); // Fp2 mul real part end
    let t410 = circuit_mul(t396, t406);
    let t411 = circuit_mul(t397, t404);
    let t412 = circuit_add(t410, t411); // Fp2 mul imag part end
    let t413 = circuit_mul(t409, t368); // Fp2 mul start
    let t414 = circuit_mul(t412, t369);
    let t415 = circuit_sub(t413, t414); // Fp2 mul real part end
    let t416 = circuit_mul(t409, t369);
    let t417 = circuit_mul(t412, t368);
    let t418 = circuit_add(t416, t417); // Fp2 mul imag part end
    let t419 = circuit_sub(t415, t378); // Fp2 sub coeff 0/1
    let t420 = circuit_sub(t418, t379); // Fp2 sub coeff 1/1
    let t421 = circuit_mul(in7, t412);
    let t422 = circuit_add(t409, t421);
    let t423 = circuit_mul(t422, in35);
    let t424 = circuit_mul(in7, t420);
    let t425 = circuit_add(t419, t424);
    let t426 = circuit_mul(t425, in34);
    let t427 = circuit_mul(t412, in35);
    let t428 = circuit_mul(t420, in34);
    let t429 = circuit_mul(t184, in66); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t430 = circuit_add(in6, t429); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t431 = circuit_mul(t187, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t432 = circuit_add(t430, t431); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t433 = circuit_mul(t188, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t434 = circuit_add(t432, t433); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t435 = circuit_mul(t189, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t436 = circuit_add(t434, t435); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t437 = circuit_mul(in71, t436);
    let t438 = circuit_mul(t217, in66); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t439 = circuit_add(in6, t438); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t440 = circuit_mul(t220, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t441 = circuit_add(t439, t440); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t442 = circuit_mul(t221, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t443 = circuit_add(t441, t442); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t444 = circuit_mul(t222, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t445 = circuit_add(t443, t444); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t446 = circuit_mul(t437, t445);
    let t447 = circuit_mul(t287, in66); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t448 = circuit_add(in6, t447); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t449 = circuit_mul(t290, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t450 = circuit_add(t448, t449); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t451 = circuit_mul(t291, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t452 = circuit_add(t450, t451); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t453 = circuit_mul(t292, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t454 = circuit_add(t452, t453); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t455 = circuit_mul(t446, t454);
    let t456 = circuit_mul(t320, in66); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t457 = circuit_add(in6, t456); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t458 = circuit_mul(t323, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t459 = circuit_add(t457, t458); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t460 = circuit_mul(t324, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t461 = circuit_add(t459, t460); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t462 = circuit_mul(t325, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t463 = circuit_add(t461, t462); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t464 = circuit_mul(t455, t463);
    let t465 = circuit_mul(t390, in66); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t466 = circuit_add(in6, t465); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t467 = circuit_mul(t393, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t468 = circuit_add(t466, t467); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t469 = circuit_mul(t394, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t470 = circuit_add(t468, t469); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t471 = circuit_mul(t395, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t472 = circuit_add(t470, t471); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t473 = circuit_mul(t464, t472);
    let t474 = circuit_mul(t423, in66); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t475 = circuit_add(in6, t474); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t476 = circuit_mul(t426, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t477 = circuit_add(t475, t476); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t478 = circuit_mul(t427, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t479 = circuit_add(t477, t478); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t480 = circuit_mul(t428, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t481 = circuit_add(t479, t480); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t482 = circuit_mul(t473, t481);
    let t483 = circuit_sub(t482, t97);
    let t484 = circuit_mul(t74, t483); // c_n_minus_2 * ((Π(n-2,k) (Pk(z)) - R_n_minus_2(z))
    let t485 = circuit_mul(t97, in67);
    let t486 = circuit_mul(t485, in68);
    let t487 = circuit_mul(t486, in69);
    let t488 = circuit_mul(t487, in65);
    let t489 = circuit_sub(t488, t119);
    let t490 = circuit_mul(t75, t489); // c_n_minus_1 * ((Π(n-1,k) (Pk(z)) - R_n_minus_1(z))
    let t491 = circuit_add(t484, t490);
    let t492 = circuit_add(in70, t491);
    let t493 = circuit_mul(in73, in66); // Eval UnnamedPoly step coeff_1 * z^1
    let t494 = circuit_add(in72, t493); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t495 = circuit_mul(in74, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t496 = circuit_add(t494, t495); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t497 = circuit_mul(in75, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t498 = circuit_add(t496, t497); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t499 = circuit_mul(in76, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t500 = circuit_add(t498, t499); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t501 = circuit_mul(in77, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t502 = circuit_add(t500, t501); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t503 = circuit_mul(in78, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t504 = circuit_add(t502, t503); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t505 = circuit_mul(in79, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t506 = circuit_add(t504, t505); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t507 = circuit_mul(in80, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t508 = circuit_add(t506, t507); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t509 = circuit_mul(in81, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t510 = circuit_add(t508, t509); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t511 = circuit_mul(in82, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t512 = circuit_add(t510, t511); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t513 = circuit_mul(in83, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t514 = circuit_add(t512, t513); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t515 = circuit_mul(in84, t10); // Eval UnnamedPoly step coeff_12 * z^12
    let t516 = circuit_add(t514, t515); // Eval UnnamedPoly step + (coeff_12 * z^12)
    let t517 = circuit_mul(in85, t11); // Eval UnnamedPoly step coeff_13 * z^13
    let t518 = circuit_add(t516, t517); // Eval UnnamedPoly step + (coeff_13 * z^13)
    let t519 = circuit_mul(in86, t12); // Eval UnnamedPoly step coeff_14 * z^14
    let t520 = circuit_add(t518, t519); // Eval UnnamedPoly step + (coeff_14 * z^14)
    let t521 = circuit_mul(in87, t13); // Eval UnnamedPoly step coeff_15 * z^15
    let t522 = circuit_add(t520, t521); // Eval UnnamedPoly step + (coeff_15 * z^15)
    let t523 = circuit_mul(in88, t14); // Eval UnnamedPoly step coeff_16 * z^16
    let t524 = circuit_add(t522, t523); // Eval UnnamedPoly step + (coeff_16 * z^16)
    let t525 = circuit_mul(in89, t15); // Eval UnnamedPoly step coeff_17 * z^17
    let t526 = circuit_add(t524, t525); // Eval UnnamedPoly step + (coeff_17 * z^17)
    let t527 = circuit_mul(in90, t16); // Eval UnnamedPoly step coeff_18 * z^18
    let t528 = circuit_add(t526, t527); // Eval UnnamedPoly step + (coeff_18 * z^18)
    let t529 = circuit_mul(in91, t17); // Eval UnnamedPoly step coeff_19 * z^19
    let t530 = circuit_add(t528, t529); // Eval UnnamedPoly step + (coeff_19 * z^19)
    let t531 = circuit_mul(in92, t18); // Eval UnnamedPoly step coeff_20 * z^20
    let t532 = circuit_add(t530, t531); // Eval UnnamedPoly step + (coeff_20 * z^20)
    let t533 = circuit_mul(in93, t19); // Eval UnnamedPoly step coeff_21 * z^21
    let t534 = circuit_add(t532, t533); // Eval UnnamedPoly step + (coeff_21 * z^21)
    let t535 = circuit_mul(in94, t20); // Eval UnnamedPoly step coeff_22 * z^22
    let t536 = circuit_add(t534, t535); // Eval UnnamedPoly step + (coeff_22 * z^22)
    let t537 = circuit_mul(in95, t21); // Eval UnnamedPoly step coeff_23 * z^23
    let t538 = circuit_add(t536, t537); // Eval UnnamedPoly step + (coeff_23 * z^23)
    let t539 = circuit_mul(in96, t22); // Eval UnnamedPoly step coeff_24 * z^24
    let t540 = circuit_add(t538, t539); // Eval UnnamedPoly step + (coeff_24 * z^24)
    let t541 = circuit_mul(in97, t23); // Eval UnnamedPoly step coeff_25 * z^25
    let t542 = circuit_add(t540, t541); // Eval UnnamedPoly step + (coeff_25 * z^25)
    let t543 = circuit_mul(in98, t24); // Eval UnnamedPoly step coeff_26 * z^26
    let t544 = circuit_add(t542, t543); // Eval UnnamedPoly step + (coeff_26 * z^26)
    let t545 = circuit_mul(in99, t25); // Eval UnnamedPoly step coeff_27 * z^27
    let t546 = circuit_add(t544, t545); // Eval UnnamedPoly step + (coeff_27 * z^27)
    let t547 = circuit_mul(in100, t26); // Eval UnnamedPoly step coeff_28 * z^28
    let t548 = circuit_add(t546, t547); // Eval UnnamedPoly step + (coeff_28 * z^28)
    let t549 = circuit_mul(in101, t27); // Eval UnnamedPoly step coeff_29 * z^29
    let t550 = circuit_add(t548, t549); // Eval UnnamedPoly step + (coeff_29 * z^29)
    let t551 = circuit_mul(in102, t28); // Eval UnnamedPoly step coeff_30 * z^30
    let t552 = circuit_add(t550, t551); // Eval UnnamedPoly step + (coeff_30 * z^30)
    let t553 = circuit_mul(in103, t29); // Eval UnnamedPoly step coeff_31 * z^31
    let t554 = circuit_add(t552, t553); // Eval UnnamedPoly step + (coeff_31 * z^31)
    let t555 = circuit_mul(in104, t30); // Eval UnnamedPoly step coeff_32 * z^32
    let t556 = circuit_add(t554, t555); // Eval UnnamedPoly step + (coeff_32 * z^32)
    let t557 = circuit_mul(in105, t31); // Eval UnnamedPoly step coeff_33 * z^33
    let t558 = circuit_add(t556, t557); // Eval UnnamedPoly step + (coeff_33 * z^33)
    let t559 = circuit_mul(in106, t32); // Eval UnnamedPoly step coeff_34 * z^34
    let t560 = circuit_add(t558, t559); // Eval UnnamedPoly step + (coeff_34 * z^34)
    let t561 = circuit_mul(in107, t33); // Eval UnnamedPoly step coeff_35 * z^35
    let t562 = circuit_add(t560, t561); // Eval UnnamedPoly step + (coeff_35 * z^35)
    let t563 = circuit_mul(in108, t34); // Eval UnnamedPoly step coeff_36 * z^36
    let t564 = circuit_add(t562, t563); // Eval UnnamedPoly step + (coeff_36 * z^36)
    let t565 = circuit_mul(in109, t35); // Eval UnnamedPoly step coeff_37 * z^37
    let t566 = circuit_add(t564, t565); // Eval UnnamedPoly step + (coeff_37 * z^37)
    let t567 = circuit_mul(in110, t36); // Eval UnnamedPoly step coeff_38 * z^38
    let t568 = circuit_add(t566, t567); // Eval UnnamedPoly step + (coeff_38 * z^38)
    let t569 = circuit_mul(in111, t37); // Eval UnnamedPoly step coeff_39 * z^39
    let t570 = circuit_add(t568, t569); // Eval UnnamedPoly step + (coeff_39 * z^39)
    let t571 = circuit_mul(in112, t38); // Eval UnnamedPoly step coeff_40 * z^40
    let t572 = circuit_add(t570, t571); // Eval UnnamedPoly step + (coeff_40 * z^40)
    let t573 = circuit_mul(in113, t39); // Eval UnnamedPoly step coeff_41 * z^41
    let t574 = circuit_add(t572, t573); // Eval UnnamedPoly step + (coeff_41 * z^41)
    let t575 = circuit_mul(in114, t40); // Eval UnnamedPoly step coeff_42 * z^42
    let t576 = circuit_add(t574, t575); // Eval UnnamedPoly step + (coeff_42 * z^42)
    let t577 = circuit_mul(in115, t41); // Eval UnnamedPoly step coeff_43 * z^43
    let t578 = circuit_add(t576, t577); // Eval UnnamedPoly step + (coeff_43 * z^43)
    let t579 = circuit_mul(in116, t42); // Eval UnnamedPoly step coeff_44 * z^44
    let t580 = circuit_add(t578, t579); // Eval UnnamedPoly step + (coeff_44 * z^44)
    let t581 = circuit_mul(in117, t43); // Eval UnnamedPoly step coeff_45 * z^45
    let t582 = circuit_add(t580, t581); // Eval UnnamedPoly step + (coeff_45 * z^45)
    let t583 = circuit_mul(in118, t44); // Eval UnnamedPoly step coeff_46 * z^46
    let t584 = circuit_add(t582, t583); // Eval UnnamedPoly step + (coeff_46 * z^46)
    let t585 = circuit_mul(in119, t45); // Eval UnnamedPoly step coeff_47 * z^47
    let t586 = circuit_add(t584, t585); // Eval UnnamedPoly step + (coeff_47 * z^47)
    let t587 = circuit_mul(in120, t46); // Eval UnnamedPoly step coeff_48 * z^48
    let t588 = circuit_add(t586, t587); // Eval UnnamedPoly step + (coeff_48 * z^48)
    let t589 = circuit_mul(in121, t47); // Eval UnnamedPoly step coeff_49 * z^49
    let t590 = circuit_add(t588, t589); // Eval UnnamedPoly step + (coeff_49 * z^49)
    let t591 = circuit_mul(in122, t48); // Eval UnnamedPoly step coeff_50 * z^50
    let t592 = circuit_add(t590, t591); // Eval UnnamedPoly step + (coeff_50 * z^50)
    let t593 = circuit_mul(in123, t49); // Eval UnnamedPoly step coeff_51 * z^51
    let t594 = circuit_add(t592, t593); // Eval UnnamedPoly step + (coeff_51 * z^51)
    let t595 = circuit_mul(in124, t50); // Eval UnnamedPoly step coeff_52 * z^52
    let t596 = circuit_add(t594, t595); // Eval UnnamedPoly step + (coeff_52 * z^52)
    let t597 = circuit_mul(in125, t51); // Eval UnnamedPoly step coeff_53 * z^53
    let t598 = circuit_add(t596, t597); // Eval UnnamedPoly step + (coeff_53 * z^53)
    let t599 = circuit_mul(in126, t52); // Eval UnnamedPoly step coeff_54 * z^54
    let t600 = circuit_add(t598, t599); // Eval UnnamedPoly step + (coeff_54 * z^54)
    let t601 = circuit_mul(in127, t53); // Eval UnnamedPoly step coeff_55 * z^55
    let t602 = circuit_add(t600, t601); // Eval UnnamedPoly step + (coeff_55 * z^55)
    let t603 = circuit_mul(in128, t54); // Eval UnnamedPoly step coeff_56 * z^56
    let t604 = circuit_add(t602, t603); // Eval UnnamedPoly step + (coeff_56 * z^56)
    let t605 = circuit_mul(in129, t55); // Eval UnnamedPoly step coeff_57 * z^57
    let t606 = circuit_add(t604, t605); // Eval UnnamedPoly step + (coeff_57 * z^57)
    let t607 = circuit_mul(in130, t56); // Eval UnnamedPoly step coeff_58 * z^58
    let t608 = circuit_add(t606, t607); // Eval UnnamedPoly step + (coeff_58 * z^58)
    let t609 = circuit_mul(in131, t57); // Eval UnnamedPoly step coeff_59 * z^59
    let t610 = circuit_add(t608, t609); // Eval UnnamedPoly step + (coeff_59 * z^59)
    let t611 = circuit_mul(in132, t58); // Eval UnnamedPoly step coeff_60 * z^60
    let t612 = circuit_add(t610, t611); // Eval UnnamedPoly step + (coeff_60 * z^60)
    let t613 = circuit_mul(in133, t59); // Eval UnnamedPoly step coeff_61 * z^61
    let t614 = circuit_add(t612, t613); // Eval UnnamedPoly step + (coeff_61 * z^61)
    let t615 = circuit_mul(in134, t60); // Eval UnnamedPoly step coeff_62 * z^62
    let t616 = circuit_add(t614, t615); // Eval UnnamedPoly step + (coeff_62 * z^62)
    let t617 = circuit_mul(in135, t61); // Eval UnnamedPoly step coeff_63 * z^63
    let t618 = circuit_add(t616, t617); // Eval UnnamedPoly step + (coeff_63 * z^63)
    let t619 = circuit_mul(in136, t62); // Eval UnnamedPoly step coeff_64 * z^64
    let t620 = circuit_add(t618, t619); // Eval UnnamedPoly step + (coeff_64 * z^64)
    let t621 = circuit_mul(in137, t63); // Eval UnnamedPoly step coeff_65 * z^65
    let t622 = circuit_add(t620, t621); // Eval UnnamedPoly step + (coeff_65 * z^65)
    let t623 = circuit_mul(in138, t64); // Eval UnnamedPoly step coeff_66 * z^66
    let t624 = circuit_add(t622, t623); // Eval UnnamedPoly step + (coeff_66 * z^66)
    let t625 = circuit_mul(in139, t65); // Eval UnnamedPoly step coeff_67 * z^67
    let t626 = circuit_add(t624, t625); // Eval UnnamedPoly step + (coeff_67 * z^67)
    let t627 = circuit_mul(in140, t66); // Eval UnnamedPoly step coeff_68 * z^68
    let t628 = circuit_add(t626, t627); // Eval UnnamedPoly step + (coeff_68 * z^68)
    let t629 = circuit_mul(in141, t67); // Eval UnnamedPoly step coeff_69 * z^69
    let t630 = circuit_add(t628, t629); // Eval UnnamedPoly step + (coeff_69 * z^69)
    let t631 = circuit_mul(in142, t68); // Eval UnnamedPoly step coeff_70 * z^70
    let t632 = circuit_add(t630, t631); // Eval UnnamedPoly step + (coeff_70 * z^70)
    let t633 = circuit_mul(in143, t69); // Eval UnnamedPoly step coeff_71 * z^71
    let t634 = circuit_add(t632, t633); // Eval UnnamedPoly step + (coeff_71 * z^71)
    let t635 = circuit_mul(in144, t70); // Eval UnnamedPoly step coeff_72 * z^72
    let t636 = circuit_add(t634, t635); // Eval UnnamedPoly step + (coeff_72 * z^72)
    let t637 = circuit_mul(in145, t71); // Eval UnnamedPoly step coeff_73 * z^73
    let t638 = circuit_add(t636, t637); // Eval UnnamedPoly step + (coeff_73 * z^73)
    let t639 = circuit_mul(in146, t72); // Eval UnnamedPoly step coeff_74 * z^74
    let t640 = circuit_add(t638, t639); // Eval UnnamedPoly step + (coeff_74 * z^74)
    let t641 = circuit_mul(in147, t73); // Eval UnnamedPoly step coeff_75 * z^75
    let t642 = circuit_add(t640, t641); // Eval UnnamedPoly step + (coeff_75 * z^75)
    let t643 = circuit_mul(in9, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t644 = circuit_add(in8, t643); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t645 = circuit_add(t644, t10); // Eval sparse poly UnnamedPoly step + 1*z^12
    let t646 = circuit_mul(t642, t645);
    let t647 = circuit_sub(t492, t646);

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [32324006162389411176778628423, 57042285082623239461879769745, 3486998266802970665, 0]
    )
        .unwrap();

    let mut circuit_inputs = (t647,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0xc2c3330c99e39557176f553d, 0x4c0bec3cf559b143b78cc310, 0x2fb347984f7911f7, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0xb7c9dce1665d51c640fcba2, 0x4ba4cc8bd75a079432ae2a1d, 0x16c9e55061ebae20, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0xa9c95998dc54014671a0135a, 0xdc5ec698b6e2f9b9dbaae0ed, 0x63cf305489af5dc, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x8fa25bd282d37f632623b0e3, 0x704b5a7ec796f2b21807dc9, 0x7c03cbcac41049a, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0xbb966e3de4bd44e5607cfd48, 0x5e6dd9e7e0acccb0c28f069f, 0x30644e72e131a029, 0x0]);
    circuit_inputs = circuit_inputs.next([0x1, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x6871ca8d3c208c16d87cfd3e, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0]);
    circuit_inputs = circuit_inputs.next([0x52, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x6871ca8d3c208c16d87cfd35, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0]);
    circuit_inputs = circuit_inputs.next(original_Q0.x0);
    circuit_inputs = circuit_inputs.next(original_Q0.x1);
    circuit_inputs = circuit_inputs.next(original_Q0.y0);
    circuit_inputs = circuit_inputs.next(original_Q0.y1);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(Q0.x0);
    circuit_inputs = circuit_inputs.next(Q0.x1);
    circuit_inputs = circuit_inputs.next(Q0.y0);
    circuit_inputs = circuit_inputs.next(Q0.y1);
    circuit_inputs = circuit_inputs.next(original_Q1.x0);
    circuit_inputs = circuit_inputs.next(original_Q1.x1);
    circuit_inputs = circuit_inputs.next(original_Q1.y0);
    circuit_inputs = circuit_inputs.next(original_Q1.y1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(Q1.x0);
    circuit_inputs = circuit_inputs.next(Q1.x1);
    circuit_inputs = circuit_inputs.next(Q1.y0);
    circuit_inputs = circuit_inputs.next(Q1.y1);
    circuit_inputs = circuit_inputs.next(original_Q2.x0);
    circuit_inputs = circuit_inputs.next(original_Q2.x1);
    circuit_inputs = circuit_inputs.next(original_Q2.y0);
    circuit_inputs = circuit_inputs.next(original_Q2.y1);
    circuit_inputs = circuit_inputs.next(yInv_2);
    circuit_inputs = circuit_inputs.next(xNegOverY_2);
    circuit_inputs = circuit_inputs.next(Q2.x0);
    circuit_inputs = circuit_inputs.next(Q2.x1);
    circuit_inputs = circuit_inputs.next(Q2.y0);
    circuit_inputs = circuit_inputs.next(Q2.y1);
    circuit_inputs = circuit_inputs.next(R_n_minus_2.w0);
    circuit_inputs = circuit_inputs.next(R_n_minus_2.w1);
    circuit_inputs = circuit_inputs.next(R_n_minus_2.w2);
    circuit_inputs = circuit_inputs.next(R_n_minus_2.w3);
    circuit_inputs = circuit_inputs.next(R_n_minus_2.w4);
    circuit_inputs = circuit_inputs.next(R_n_minus_2.w5);
    circuit_inputs = circuit_inputs.next(R_n_minus_2.w6);
    circuit_inputs = circuit_inputs.next(R_n_minus_2.w7);
    circuit_inputs = circuit_inputs.next(R_n_minus_2.w8);
    circuit_inputs = circuit_inputs.next(R_n_minus_2.w9);
    circuit_inputs = circuit_inputs.next(R_n_minus_2.w10);
    circuit_inputs = circuit_inputs.next(R_n_minus_2.w11);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w0);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w1);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w2);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w3);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w4);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w5);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w6);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w7);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w8);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w9);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w10);
    circuit_inputs = circuit_inputs.next(R_n_minus_1.w11);
    circuit_inputs = circuit_inputs.next(c_n_minus_3);
    circuit_inputs = circuit_inputs.next(w_of_z);
    circuit_inputs = circuit_inputs.next(z);
    circuit_inputs = circuit_inputs.next(c_inv_frob_1_of_z);
    circuit_inputs = circuit_inputs.next(c_frob_2_of_z);
    circuit_inputs = circuit_inputs.next(c_inv_frob_3_of_z);
    circuit_inputs = circuit_inputs.next(previous_lhs);
    circuit_inputs = circuit_inputs.next(R_n_minus_3_of_z);

    let mut Q = Q;
    while let Option::Some(val) = Q.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let final_check: u384 = outputs.get_output(t647);
    return (final_check,);
}
fn run_BN254_MP_CHECK_INIT_BIT_2_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    Q0: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q1: G2Point,
    R_i: E12D,
    c0: u384,
    z: u384,
    c_inv_of_z: u384,
    previous_lhs: u384
) -> (G2Point, G2Point, u384, u384, u384) {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0x0
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 0x3
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 0x6
    let in3 = CircuitElement::<CircuitInput<3>> {}; // -0x9 % p
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 0x1

    // INPUT stack
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
    let in9 = CircuitElement::<CircuitInput<9>> {}; // 
    let in10 = CircuitElement::<CircuitInput<10>> {}; // 
    let in11 = CircuitElement::<CircuitInput<11>> {}; // 
    let in12 = CircuitElement::<CircuitInput<12>> {}; // 
    let in13 = CircuitElement::<CircuitInput<13>> {}; // 
    let in14 = CircuitElement::<CircuitInput<14>> {}; // 
    let in15 = CircuitElement::<CircuitInput<15>> {}; // 
    let in16 = CircuitElement::<CircuitInput<16>> {}; // 
    let in17 = CircuitElement::<CircuitInput<17>> {}; // 
    let in18 = CircuitElement::<CircuitInput<18>> {}; // 
    let in19 = CircuitElement::<CircuitInput<19>> {}; // 
    let in20 = CircuitElement::<CircuitInput<20>> {}; // 
    let in21 = CircuitElement::<CircuitInput<21>> {}; // 
    let in22 = CircuitElement::<CircuitInput<22>> {}; // 
    let in23 = CircuitElement::<CircuitInput<23>> {}; // 
    let in24 = CircuitElement::<CircuitInput<24>> {}; // 
    let in25 = CircuitElement::<CircuitInput<25>> {}; // 
    let in26 = CircuitElement::<CircuitInput<26>> {}; // 
    let in27 = CircuitElement::<CircuitInput<27>> {}; // 
    let in28 = CircuitElement::<CircuitInput<28>> {}; // 
    let in29 = CircuitElement::<CircuitInput<29>> {}; // 
    let in30 = CircuitElement::<CircuitInput<30>> {}; // 
    let in31 = CircuitElement::<CircuitInput<31>> {}; // 
    let in32 = CircuitElement::<CircuitInput<32>> {}; // 
    let t0 = circuit_mul(in30, in30); // Compute z^2
    let t1 = circuit_mul(t0, in30); // Compute z^3
    let t2 = circuit_mul(t1, in30); // Compute z^4
    let t3 = circuit_mul(t2, in30); // Compute z^5
    let t4 = circuit_mul(t3, in30); // Compute z^6
    let t5 = circuit_mul(t4, in30); // Compute z^7
    let t6 = circuit_mul(t5, in30); // Compute z^8
    let t7 = circuit_mul(t6, in30); // Compute z^9
    let t8 = circuit_mul(t7, in30); // Compute z^10
    let t9 = circuit_mul(t8, in30); // Compute z^11
    let t10 = circuit_mul(in18, in30); // Eval UnnamedPoly step coeff_1 * z^1
    let t11 = circuit_add(in17, t10); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t12 = circuit_mul(in19, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t13 = circuit_add(t11, t12); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t14 = circuit_mul(in20, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t15 = circuit_add(t13, t14); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t16 = circuit_mul(in21, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t17 = circuit_add(t15, t16); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t18 = circuit_mul(in22, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t19 = circuit_add(t17, t18); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t20 = circuit_mul(in23, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t21 = circuit_add(t19, t20); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t22 = circuit_mul(in24, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t23 = circuit_add(t21, t22); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t24 = circuit_mul(in25, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t25 = circuit_add(t23, t24); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t26 = circuit_mul(in26, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t27 = circuit_add(t25, t26); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t28 = circuit_mul(in27, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t29 = circuit_add(t27, t28); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t30 = circuit_mul(in28, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t31 = circuit_add(t29, t30); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t32 = circuit_mul(in31, in31);
    let t33 = circuit_mul(in29, in29);
    let t34 = circuit_add(in7, in8); // Doubling slope numerator start
    let t35 = circuit_sub(in7, in8);
    let t36 = circuit_mul(t34, t35);
    let t37 = circuit_mul(in7, in8);
    let t38 = circuit_mul(t36, in1);
    let t39 = circuit_mul(t37, in2); // Doubling slope numerator end
    let t40 = circuit_add(in9, in9); // Fp2 add coeff 0/1
    let t41 = circuit_add(in10, in10); // Fp2 add coeff 1/1
    let t42 = circuit_mul(t40, t40); // Fp2 Div x/y start : Fp2 Inv y start
    let t43 = circuit_mul(t41, t41);
    let t44 = circuit_add(t42, t43);
    let t45 = circuit_inverse(t44);
    let t46 = circuit_mul(t40, t45); // Fp2 Inv y real part end
    let t47 = circuit_mul(t41, t45);
    let t48 = circuit_sub(in0, t47); // Fp2 Inv y imag part end
    let t49 = circuit_mul(t38, t46); // Fp2 mul start
    let t50 = circuit_mul(t39, t48);
    let t51 = circuit_sub(t49, t50); // Fp2 mul real part end
    let t52 = circuit_mul(t38, t48);
    let t53 = circuit_mul(t39, t46);
    let t54 = circuit_add(t52, t53); // Fp2 mul imag part end
    let t55 = circuit_add(t51, t54);
    let t56 = circuit_sub(t51, t54);
    let t57 = circuit_mul(t55, t56);
    let t58 = circuit_mul(t51, t54);
    let t59 = circuit_add(t58, t58);
    let t60 = circuit_add(in7, in7); // Fp2 add coeff 0/1
    let t61 = circuit_add(in8, in8); // Fp2 add coeff 1/1
    let t62 = circuit_sub(t57, t60); // Fp2 sub coeff 0/1
    let t63 = circuit_sub(t59, t61); // Fp2 sub coeff 1/1
    let t64 = circuit_sub(in7, t62); // Fp2 sub coeff 0/1
    let t65 = circuit_sub(in8, t63); // Fp2 sub coeff 1/1
    let t66 = circuit_mul(t51, t64); // Fp2 mul start
    let t67 = circuit_mul(t54, t65);
    let t68 = circuit_sub(t66, t67); // Fp2 mul real part end
    let t69 = circuit_mul(t51, t65);
    let t70 = circuit_mul(t54, t64);
    let t71 = circuit_add(t69, t70); // Fp2 mul imag part end
    let t72 = circuit_sub(t68, in9); // Fp2 sub coeff 0/1
    let t73 = circuit_sub(t71, in10); // Fp2 sub coeff 1/1
    let t74 = circuit_mul(t51, in7); // Fp2 mul start
    let t75 = circuit_mul(t54, in8);
    let t76 = circuit_sub(t74, t75); // Fp2 mul real part end
    let t77 = circuit_mul(t51, in8);
    let t78 = circuit_mul(t54, in7);
    let t79 = circuit_add(t77, t78); // Fp2 mul imag part end
    let t80 = circuit_sub(t76, in9); // Fp2 sub coeff 0/1
    let t81 = circuit_sub(t79, in10); // Fp2 sub coeff 1/1
    let t82 = circuit_mul(in3, t54);
    let t83 = circuit_add(t51, t82);
    let t84 = circuit_mul(t83, in6);
    let t85 = circuit_mul(in3, t81);
    let t86 = circuit_add(t80, t85);
    let t87 = circuit_mul(t86, in5);
    let t88 = circuit_mul(t54, in6);
    let t89 = circuit_mul(t81, in5);
    let t90 = circuit_mul(t84, in30); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t91 = circuit_add(in4, t90); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t92 = circuit_mul(t87, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t93 = circuit_add(t91, t92); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t94 = circuit_mul(t88, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t95 = circuit_add(t93, t94); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t96 = circuit_mul(t89, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t97 = circuit_add(t95, t96); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t98 = circuit_mul(t32, t97);
    let t99 = circuit_add(in13, in14); // Doubling slope numerator start
    let t100 = circuit_sub(in13, in14);
    let t101 = circuit_mul(t99, t100);
    let t102 = circuit_mul(in13, in14);
    let t103 = circuit_mul(t101, in1);
    let t104 = circuit_mul(t102, in2); // Doubling slope numerator end
    let t105 = circuit_add(in15, in15); // Fp2 add coeff 0/1
    let t106 = circuit_add(in16, in16); // Fp2 add coeff 1/1
    let t107 = circuit_mul(t105, t105); // Fp2 Div x/y start : Fp2 Inv y start
    let t108 = circuit_mul(t106, t106);
    let t109 = circuit_add(t107, t108);
    let t110 = circuit_inverse(t109);
    let t111 = circuit_mul(t105, t110); // Fp2 Inv y real part end
    let t112 = circuit_mul(t106, t110);
    let t113 = circuit_sub(in0, t112); // Fp2 Inv y imag part end
    let t114 = circuit_mul(t103, t111); // Fp2 mul start
    let t115 = circuit_mul(t104, t113);
    let t116 = circuit_sub(t114, t115); // Fp2 mul real part end
    let t117 = circuit_mul(t103, t113);
    let t118 = circuit_mul(t104, t111);
    let t119 = circuit_add(t117, t118); // Fp2 mul imag part end
    let t120 = circuit_add(t116, t119);
    let t121 = circuit_sub(t116, t119);
    let t122 = circuit_mul(t120, t121);
    let t123 = circuit_mul(t116, t119);
    let t124 = circuit_add(t123, t123);
    let t125 = circuit_add(in13, in13); // Fp2 add coeff 0/1
    let t126 = circuit_add(in14, in14); // Fp2 add coeff 1/1
    let t127 = circuit_sub(t122, t125); // Fp2 sub coeff 0/1
    let t128 = circuit_sub(t124, t126); // Fp2 sub coeff 1/1
    let t129 = circuit_sub(in13, t127); // Fp2 sub coeff 0/1
    let t130 = circuit_sub(in14, t128); // Fp2 sub coeff 1/1
    let t131 = circuit_mul(t116, t129); // Fp2 mul start
    let t132 = circuit_mul(t119, t130);
    let t133 = circuit_sub(t131, t132); // Fp2 mul real part end
    let t134 = circuit_mul(t116, t130);
    let t135 = circuit_mul(t119, t129);
    let t136 = circuit_add(t134, t135); // Fp2 mul imag part end
    let t137 = circuit_sub(t133, in15); // Fp2 sub coeff 0/1
    let t138 = circuit_sub(t136, in16); // Fp2 sub coeff 1/1
    let t139 = circuit_mul(t116, in13); // Fp2 mul start
    let t140 = circuit_mul(t119, in14);
    let t141 = circuit_sub(t139, t140); // Fp2 mul real part end
    let t142 = circuit_mul(t116, in14);
    let t143 = circuit_mul(t119, in13);
    let t144 = circuit_add(t142, t143); // Fp2 mul imag part end
    let t145 = circuit_sub(t141, in15); // Fp2 sub coeff 0/1
    let t146 = circuit_sub(t144, in16); // Fp2 sub coeff 1/1
    let t147 = circuit_mul(in3, t119);
    let t148 = circuit_add(t116, t147);
    let t149 = circuit_mul(t148, in12);
    let t150 = circuit_mul(in3, t146);
    let t151 = circuit_add(t145, t150);
    let t152 = circuit_mul(t151, in11);
    let t153 = circuit_mul(t119, in12);
    let t154 = circuit_mul(t146, in11);
    let t155 = circuit_mul(t149, in30); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t156 = circuit_add(in4, t155); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t157 = circuit_mul(t152, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t158 = circuit_add(t156, t157); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t159 = circuit_mul(t153, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t160 = circuit_add(t158, t159); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t161 = circuit_mul(t154, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t162 = circuit_add(t160, t161); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t163 = circuit_mul(t98, t162);
    let t164 = circuit_sub(t163, t31);
    let t165 = circuit_mul(t33, t164); // ci * ((Π(i,k) (Pk(z)) - Ri(z))
    let t166 = circuit_add(t165, in32);

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [32324006162389411176778628423, 57042285082623239461879769745, 3486998266802970665, 0]
    )
        .unwrap();

    let mut circuit_inputs = (t62, t63, t72, t73, t127, t128, t137, t138, t166, t33, t31,)
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x6, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x6871ca8d3c208c16d87cfd3e, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0]);
    circuit_inputs = circuit_inputs.next([0x1, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(Q0.x0);
    circuit_inputs = circuit_inputs.next(Q0.x1);
    circuit_inputs = circuit_inputs.next(Q0.y0);
    circuit_inputs = circuit_inputs.next(Q0.y1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(Q1.x0);
    circuit_inputs = circuit_inputs.next(Q1.x1);
    circuit_inputs = circuit_inputs.next(Q1.y0);
    circuit_inputs = circuit_inputs.next(Q1.y1);
    circuit_inputs = circuit_inputs.next(R_i.w0);
    circuit_inputs = circuit_inputs.next(R_i.w1);
    circuit_inputs = circuit_inputs.next(R_i.w2);
    circuit_inputs = circuit_inputs.next(R_i.w3);
    circuit_inputs = circuit_inputs.next(R_i.w4);
    circuit_inputs = circuit_inputs.next(R_i.w5);
    circuit_inputs = circuit_inputs.next(R_i.w6);
    circuit_inputs = circuit_inputs.next(R_i.w7);
    circuit_inputs = circuit_inputs.next(R_i.w8);
    circuit_inputs = circuit_inputs.next(R_i.w9);
    circuit_inputs = circuit_inputs.next(R_i.w10);
    circuit_inputs = circuit_inputs.next(R_i.w11);
    circuit_inputs = circuit_inputs.next(c0);
    circuit_inputs = circuit_inputs.next(z);
    circuit_inputs = circuit_inputs.next(c_inv_of_z);
    circuit_inputs = circuit_inputs.next(previous_lhs);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let Q0: G2Point = G2Point {
        x0: outputs.get_output(t62),
        x1: outputs.get_output(t63),
        y0: outputs.get_output(t72),
        y1: outputs.get_output(t73)
    };

    let Q1: G2Point = G2Point {
        x0: outputs.get_output(t127),
        x1: outputs.get_output(t128),
        y0: outputs.get_output(t137),
        y1: outputs.get_output(t138)
    };

    let new_lhs: u384 = outputs.get_output(t166);

    let c_i: u384 = outputs.get_output(t33);

    let f_i_plus_one_of_z: u384 = outputs.get_output(t31);
    return (Q0, Q1, new_lhs, c_i, f_i_plus_one_of_z);
}
fn run_BN254_MP_CHECK_INIT_BIT_3_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    Q0: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q1: G2Point,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q2: G2Point,
    R_i: E12D,
    c0: u384,
    z: u384,
    c_inv_of_z: u384,
    previous_lhs: u384
) -> (G2Point, G2Point, G2Point, u384, u384, u384) {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0x0
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 0x3
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 0x6
    let in3 = CircuitElement::<CircuitInput<3>> {}; // -0x9 % p
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 0x1

    // INPUT stack
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
    let in9 = CircuitElement::<CircuitInput<9>> {}; // 
    let in10 = CircuitElement::<CircuitInput<10>> {}; // 
    let in11 = CircuitElement::<CircuitInput<11>> {}; // 
    let in12 = CircuitElement::<CircuitInput<12>> {}; // 
    let in13 = CircuitElement::<CircuitInput<13>> {}; // 
    let in14 = CircuitElement::<CircuitInput<14>> {}; // 
    let in15 = CircuitElement::<CircuitInput<15>> {}; // 
    let in16 = CircuitElement::<CircuitInput<16>> {}; // 
    let in17 = CircuitElement::<CircuitInput<17>> {}; // 
    let in18 = CircuitElement::<CircuitInput<18>> {}; // 
    let in19 = CircuitElement::<CircuitInput<19>> {}; // 
    let in20 = CircuitElement::<CircuitInput<20>> {}; // 
    let in21 = CircuitElement::<CircuitInput<21>> {}; // 
    let in22 = CircuitElement::<CircuitInput<22>> {}; // 
    let in23 = CircuitElement::<CircuitInput<23>> {}; // 
    let in24 = CircuitElement::<CircuitInput<24>> {}; // 
    let in25 = CircuitElement::<CircuitInput<25>> {}; // 
    let in26 = CircuitElement::<CircuitInput<26>> {}; // 
    let in27 = CircuitElement::<CircuitInput<27>> {}; // 
    let in28 = CircuitElement::<CircuitInput<28>> {}; // 
    let in29 = CircuitElement::<CircuitInput<29>> {}; // 
    let in30 = CircuitElement::<CircuitInput<30>> {}; // 
    let in31 = CircuitElement::<CircuitInput<31>> {}; // 
    let in32 = CircuitElement::<CircuitInput<32>> {}; // 
    let in33 = CircuitElement::<CircuitInput<33>> {}; // 
    let in34 = CircuitElement::<CircuitInput<34>> {}; // 
    let in35 = CircuitElement::<CircuitInput<35>> {}; // 
    let in36 = CircuitElement::<CircuitInput<36>> {}; // 
    let in37 = CircuitElement::<CircuitInput<37>> {}; // 
    let in38 = CircuitElement::<CircuitInput<38>> {}; // 
    let t0 = circuit_mul(in36, in36); // Compute z^2
    let t1 = circuit_mul(t0, in36); // Compute z^3
    let t2 = circuit_mul(t1, in36); // Compute z^4
    let t3 = circuit_mul(t2, in36); // Compute z^5
    let t4 = circuit_mul(t3, in36); // Compute z^6
    let t5 = circuit_mul(t4, in36); // Compute z^7
    let t6 = circuit_mul(t5, in36); // Compute z^8
    let t7 = circuit_mul(t6, in36); // Compute z^9
    let t8 = circuit_mul(t7, in36); // Compute z^10
    let t9 = circuit_mul(t8, in36); // Compute z^11
    let t10 = circuit_mul(in24, in36); // Eval UnnamedPoly step coeff_1 * z^1
    let t11 = circuit_add(in23, t10); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t12 = circuit_mul(in25, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t13 = circuit_add(t11, t12); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t14 = circuit_mul(in26, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t15 = circuit_add(t13, t14); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t16 = circuit_mul(in27, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t17 = circuit_add(t15, t16); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t18 = circuit_mul(in28, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t19 = circuit_add(t17, t18); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t20 = circuit_mul(in29, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t21 = circuit_add(t19, t20); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t22 = circuit_mul(in30, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t23 = circuit_add(t21, t22); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t24 = circuit_mul(in31, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t25 = circuit_add(t23, t24); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t26 = circuit_mul(in32, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t27 = circuit_add(t25, t26); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t28 = circuit_mul(in33, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t29 = circuit_add(t27, t28); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t30 = circuit_mul(in34, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t31 = circuit_add(t29, t30); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t32 = circuit_mul(in37, in37);
    let t33 = circuit_mul(in35, in35);
    let t34 = circuit_add(in7, in8); // Doubling slope numerator start
    let t35 = circuit_sub(in7, in8);
    let t36 = circuit_mul(t34, t35);
    let t37 = circuit_mul(in7, in8);
    let t38 = circuit_mul(t36, in1);
    let t39 = circuit_mul(t37, in2); // Doubling slope numerator end
    let t40 = circuit_add(in9, in9); // Fp2 add coeff 0/1
    let t41 = circuit_add(in10, in10); // Fp2 add coeff 1/1
    let t42 = circuit_mul(t40, t40); // Fp2 Div x/y start : Fp2 Inv y start
    let t43 = circuit_mul(t41, t41);
    let t44 = circuit_add(t42, t43);
    let t45 = circuit_inverse(t44);
    let t46 = circuit_mul(t40, t45); // Fp2 Inv y real part end
    let t47 = circuit_mul(t41, t45);
    let t48 = circuit_sub(in0, t47); // Fp2 Inv y imag part end
    let t49 = circuit_mul(t38, t46); // Fp2 mul start
    let t50 = circuit_mul(t39, t48);
    let t51 = circuit_sub(t49, t50); // Fp2 mul real part end
    let t52 = circuit_mul(t38, t48);
    let t53 = circuit_mul(t39, t46);
    let t54 = circuit_add(t52, t53); // Fp2 mul imag part end
    let t55 = circuit_add(t51, t54);
    let t56 = circuit_sub(t51, t54);
    let t57 = circuit_mul(t55, t56);
    let t58 = circuit_mul(t51, t54);
    let t59 = circuit_add(t58, t58);
    let t60 = circuit_add(in7, in7); // Fp2 add coeff 0/1
    let t61 = circuit_add(in8, in8); // Fp2 add coeff 1/1
    let t62 = circuit_sub(t57, t60); // Fp2 sub coeff 0/1
    let t63 = circuit_sub(t59, t61); // Fp2 sub coeff 1/1
    let t64 = circuit_sub(in7, t62); // Fp2 sub coeff 0/1
    let t65 = circuit_sub(in8, t63); // Fp2 sub coeff 1/1
    let t66 = circuit_mul(t51, t64); // Fp2 mul start
    let t67 = circuit_mul(t54, t65);
    let t68 = circuit_sub(t66, t67); // Fp2 mul real part end
    let t69 = circuit_mul(t51, t65);
    let t70 = circuit_mul(t54, t64);
    let t71 = circuit_add(t69, t70); // Fp2 mul imag part end
    let t72 = circuit_sub(t68, in9); // Fp2 sub coeff 0/1
    let t73 = circuit_sub(t71, in10); // Fp2 sub coeff 1/1
    let t74 = circuit_mul(t51, in7); // Fp2 mul start
    let t75 = circuit_mul(t54, in8);
    let t76 = circuit_sub(t74, t75); // Fp2 mul real part end
    let t77 = circuit_mul(t51, in8);
    let t78 = circuit_mul(t54, in7);
    let t79 = circuit_add(t77, t78); // Fp2 mul imag part end
    let t80 = circuit_sub(t76, in9); // Fp2 sub coeff 0/1
    let t81 = circuit_sub(t79, in10); // Fp2 sub coeff 1/1
    let t82 = circuit_mul(in3, t54);
    let t83 = circuit_add(t51, t82);
    let t84 = circuit_mul(t83, in6);
    let t85 = circuit_mul(in3, t81);
    let t86 = circuit_add(t80, t85);
    let t87 = circuit_mul(t86, in5);
    let t88 = circuit_mul(t54, in6);
    let t89 = circuit_mul(t81, in5);
    let t90 = circuit_mul(t84, in36); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t91 = circuit_add(in4, t90); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t92 = circuit_mul(t87, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t93 = circuit_add(t91, t92); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t94 = circuit_mul(t88, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t95 = circuit_add(t93, t94); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t96 = circuit_mul(t89, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t97 = circuit_add(t95, t96); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t98 = circuit_mul(t32, t97);
    let t99 = circuit_add(in13, in14); // Doubling slope numerator start
    let t100 = circuit_sub(in13, in14);
    let t101 = circuit_mul(t99, t100);
    let t102 = circuit_mul(in13, in14);
    let t103 = circuit_mul(t101, in1);
    let t104 = circuit_mul(t102, in2); // Doubling slope numerator end
    let t105 = circuit_add(in15, in15); // Fp2 add coeff 0/1
    let t106 = circuit_add(in16, in16); // Fp2 add coeff 1/1
    let t107 = circuit_mul(t105, t105); // Fp2 Div x/y start : Fp2 Inv y start
    let t108 = circuit_mul(t106, t106);
    let t109 = circuit_add(t107, t108);
    let t110 = circuit_inverse(t109);
    let t111 = circuit_mul(t105, t110); // Fp2 Inv y real part end
    let t112 = circuit_mul(t106, t110);
    let t113 = circuit_sub(in0, t112); // Fp2 Inv y imag part end
    let t114 = circuit_mul(t103, t111); // Fp2 mul start
    let t115 = circuit_mul(t104, t113);
    let t116 = circuit_sub(t114, t115); // Fp2 mul real part end
    let t117 = circuit_mul(t103, t113);
    let t118 = circuit_mul(t104, t111);
    let t119 = circuit_add(t117, t118); // Fp2 mul imag part end
    let t120 = circuit_add(t116, t119);
    let t121 = circuit_sub(t116, t119);
    let t122 = circuit_mul(t120, t121);
    let t123 = circuit_mul(t116, t119);
    let t124 = circuit_add(t123, t123);
    let t125 = circuit_add(in13, in13); // Fp2 add coeff 0/1
    let t126 = circuit_add(in14, in14); // Fp2 add coeff 1/1
    let t127 = circuit_sub(t122, t125); // Fp2 sub coeff 0/1
    let t128 = circuit_sub(t124, t126); // Fp2 sub coeff 1/1
    let t129 = circuit_sub(in13, t127); // Fp2 sub coeff 0/1
    let t130 = circuit_sub(in14, t128); // Fp2 sub coeff 1/1
    let t131 = circuit_mul(t116, t129); // Fp2 mul start
    let t132 = circuit_mul(t119, t130);
    let t133 = circuit_sub(t131, t132); // Fp2 mul real part end
    let t134 = circuit_mul(t116, t130);
    let t135 = circuit_mul(t119, t129);
    let t136 = circuit_add(t134, t135); // Fp2 mul imag part end
    let t137 = circuit_sub(t133, in15); // Fp2 sub coeff 0/1
    let t138 = circuit_sub(t136, in16); // Fp2 sub coeff 1/1
    let t139 = circuit_mul(t116, in13); // Fp2 mul start
    let t140 = circuit_mul(t119, in14);
    let t141 = circuit_sub(t139, t140); // Fp2 mul real part end
    let t142 = circuit_mul(t116, in14);
    let t143 = circuit_mul(t119, in13);
    let t144 = circuit_add(t142, t143); // Fp2 mul imag part end
    let t145 = circuit_sub(t141, in15); // Fp2 sub coeff 0/1
    let t146 = circuit_sub(t144, in16); // Fp2 sub coeff 1/1
    let t147 = circuit_mul(in3, t119);
    let t148 = circuit_add(t116, t147);
    let t149 = circuit_mul(t148, in12);
    let t150 = circuit_mul(in3, t146);
    let t151 = circuit_add(t145, t150);
    let t152 = circuit_mul(t151, in11);
    let t153 = circuit_mul(t119, in12);
    let t154 = circuit_mul(t146, in11);
    let t155 = circuit_mul(t149, in36); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t156 = circuit_add(in4, t155); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t157 = circuit_mul(t152, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t158 = circuit_add(t156, t157); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t159 = circuit_mul(t153, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t160 = circuit_add(t158, t159); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t161 = circuit_mul(t154, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t162 = circuit_add(t160, t161); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t163 = circuit_mul(t98, t162);
    let t164 = circuit_add(in19, in20); // Doubling slope numerator start
    let t165 = circuit_sub(in19, in20);
    let t166 = circuit_mul(t164, t165);
    let t167 = circuit_mul(in19, in20);
    let t168 = circuit_mul(t166, in1);
    let t169 = circuit_mul(t167, in2); // Doubling slope numerator end
    let t170 = circuit_add(in21, in21); // Fp2 add coeff 0/1
    let t171 = circuit_add(in22, in22); // Fp2 add coeff 1/1
    let t172 = circuit_mul(t170, t170); // Fp2 Div x/y start : Fp2 Inv y start
    let t173 = circuit_mul(t171, t171);
    let t174 = circuit_add(t172, t173);
    let t175 = circuit_inverse(t174);
    let t176 = circuit_mul(t170, t175); // Fp2 Inv y real part end
    let t177 = circuit_mul(t171, t175);
    let t178 = circuit_sub(in0, t177); // Fp2 Inv y imag part end
    let t179 = circuit_mul(t168, t176); // Fp2 mul start
    let t180 = circuit_mul(t169, t178);
    let t181 = circuit_sub(t179, t180); // Fp2 mul real part end
    let t182 = circuit_mul(t168, t178);
    let t183 = circuit_mul(t169, t176);
    let t184 = circuit_add(t182, t183); // Fp2 mul imag part end
    let t185 = circuit_add(t181, t184);
    let t186 = circuit_sub(t181, t184);
    let t187 = circuit_mul(t185, t186);
    let t188 = circuit_mul(t181, t184);
    let t189 = circuit_add(t188, t188);
    let t190 = circuit_add(in19, in19); // Fp2 add coeff 0/1
    let t191 = circuit_add(in20, in20); // Fp2 add coeff 1/1
    let t192 = circuit_sub(t187, t190); // Fp2 sub coeff 0/1
    let t193 = circuit_sub(t189, t191); // Fp2 sub coeff 1/1
    let t194 = circuit_sub(in19, t192); // Fp2 sub coeff 0/1
    let t195 = circuit_sub(in20, t193); // Fp2 sub coeff 1/1
    let t196 = circuit_mul(t181, t194); // Fp2 mul start
    let t197 = circuit_mul(t184, t195);
    let t198 = circuit_sub(t196, t197); // Fp2 mul real part end
    let t199 = circuit_mul(t181, t195);
    let t200 = circuit_mul(t184, t194);
    let t201 = circuit_add(t199, t200); // Fp2 mul imag part end
    let t202 = circuit_sub(t198, in21); // Fp2 sub coeff 0/1
    let t203 = circuit_sub(t201, in22); // Fp2 sub coeff 1/1
    let t204 = circuit_mul(t181, in19); // Fp2 mul start
    let t205 = circuit_mul(t184, in20);
    let t206 = circuit_sub(t204, t205); // Fp2 mul real part end
    let t207 = circuit_mul(t181, in20);
    let t208 = circuit_mul(t184, in19);
    let t209 = circuit_add(t207, t208); // Fp2 mul imag part end
    let t210 = circuit_sub(t206, in21); // Fp2 sub coeff 0/1
    let t211 = circuit_sub(t209, in22); // Fp2 sub coeff 1/1
    let t212 = circuit_mul(in3, t184);
    let t213 = circuit_add(t181, t212);
    let t214 = circuit_mul(t213, in18);
    let t215 = circuit_mul(in3, t211);
    let t216 = circuit_add(t210, t215);
    let t217 = circuit_mul(t216, in17);
    let t218 = circuit_mul(t184, in18);
    let t219 = circuit_mul(t211, in17);
    let t220 = circuit_mul(t214, in36); // Eval sparse poly UnnamedPoly step coeff_1 * z^1
    let t221 = circuit_add(in4, t220); // Eval sparse poly UnnamedPoly step + coeff_1 * z^1
    let t222 = circuit_mul(t217, t1); // Eval sparse poly UnnamedPoly step coeff_3 * z^3
    let t223 = circuit_add(t221, t222); // Eval sparse poly UnnamedPoly step + coeff_3 * z^3
    let t224 = circuit_mul(t218, t5); // Eval sparse poly UnnamedPoly step coeff_7 * z^7
    let t225 = circuit_add(t223, t224); // Eval sparse poly UnnamedPoly step + coeff_7 * z^7
    let t226 = circuit_mul(t219, t7); // Eval sparse poly UnnamedPoly step coeff_9 * z^9
    let t227 = circuit_add(t225, t226); // Eval sparse poly UnnamedPoly step + coeff_9 * z^9
    let t228 = circuit_mul(t163, t227);
    let t229 = circuit_sub(t228, t31);
    let t230 = circuit_mul(t33, t229); // ci * ((Π(i,k) (Pk(z)) - Ri(z))
    let t231 = circuit_add(t230, in38);

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [32324006162389411176778628423, 57042285082623239461879769745, 3486998266802970665, 0]
    )
        .unwrap();

    let mut circuit_inputs = (
        t62, t63, t72, t73, t127, t128, t137, t138, t192, t193, t202, t203, t231, t33, t31,
    )
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x6, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x6871ca8d3c208c16d87cfd3e, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0]);
    circuit_inputs = circuit_inputs.next([0x1, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(Q0.x0);
    circuit_inputs = circuit_inputs.next(Q0.x1);
    circuit_inputs = circuit_inputs.next(Q0.y0);
    circuit_inputs = circuit_inputs.next(Q0.y1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(Q1.x0);
    circuit_inputs = circuit_inputs.next(Q1.x1);
    circuit_inputs = circuit_inputs.next(Q1.y0);
    circuit_inputs = circuit_inputs.next(Q1.y1);
    circuit_inputs = circuit_inputs.next(yInv_2);
    circuit_inputs = circuit_inputs.next(xNegOverY_2);
    circuit_inputs = circuit_inputs.next(Q2.x0);
    circuit_inputs = circuit_inputs.next(Q2.x1);
    circuit_inputs = circuit_inputs.next(Q2.y0);
    circuit_inputs = circuit_inputs.next(Q2.y1);
    circuit_inputs = circuit_inputs.next(R_i.w0);
    circuit_inputs = circuit_inputs.next(R_i.w1);
    circuit_inputs = circuit_inputs.next(R_i.w2);
    circuit_inputs = circuit_inputs.next(R_i.w3);
    circuit_inputs = circuit_inputs.next(R_i.w4);
    circuit_inputs = circuit_inputs.next(R_i.w5);
    circuit_inputs = circuit_inputs.next(R_i.w6);
    circuit_inputs = circuit_inputs.next(R_i.w7);
    circuit_inputs = circuit_inputs.next(R_i.w8);
    circuit_inputs = circuit_inputs.next(R_i.w9);
    circuit_inputs = circuit_inputs.next(R_i.w10);
    circuit_inputs = circuit_inputs.next(R_i.w11);
    circuit_inputs = circuit_inputs.next(c0);
    circuit_inputs = circuit_inputs.next(z);
    circuit_inputs = circuit_inputs.next(c_inv_of_z);
    circuit_inputs = circuit_inputs.next(previous_lhs);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let Q0: G2Point = G2Point {
        x0: outputs.get_output(t62),
        x1: outputs.get_output(t63),
        y0: outputs.get_output(t72),
        y1: outputs.get_output(t73)
    };

    let Q1: G2Point = G2Point {
        x0: outputs.get_output(t127),
        x1: outputs.get_output(t128),
        y0: outputs.get_output(t137),
        y1: outputs.get_output(t138)
    };

    let Q2: G2Point = G2Point {
        x0: outputs.get_output(t192),
        x1: outputs.get_output(t193),
        y0: outputs.get_output(t202),
        y1: outputs.get_output(t203)
    };

    let new_lhs: u384 = outputs.get_output(t231);

    let c_i: u384 = outputs.get_output(t33);

    let f_i_plus_one_of_z: u384 = outputs.get_output(t31);
    return (Q0, Q1, Q2, new_lhs, c_i, f_i_plus_one_of_z);
}
fn run_BN254_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit(
    lambda_root: E12D,
    z: u384,
    scaling_factor: MillerLoopResultScalingFactor,
    c_inv: E12D,
    c_0: u384
) -> (u384, u384, u384, u384, u384, u384, u384) {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0x0
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 0x1
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 0x12
    let in3 = CircuitElement::<
        CircuitInput<3>
    > {}; // 0x1d8c8daef3eee1e81b2522ec5eb28ded6895e1cdfde6a43f5daa971f3fa65955
    let in4 = CircuitElement::<
        CircuitInput<4>
    > {}; // 0x217e400dc9351e774e34e2ac06ead4000d14d1e242b29c567e9c385ce480a71a
    let in5 = CircuitElement::<
        CircuitInput<5>
    > {}; // 0x242b719062f6737b8481d22c6934ce844d72f250fd28d102c0d147b2f4d521a7
    let in6 = CircuitElement::<
        CircuitInput<6>
    > {}; // 0x359809094bd5c8e1b9c22d81246ffc2e794e17643ac198484b8d9094aa82536
    let in7 = CircuitElement::<
        CircuitInput<7>
    > {}; // 0x21436d48fcb50cc60dd4ef1e69a0c1f0dd2949fa6df7b44cbb259ef7cb58d5ed
    let in8 = CircuitElement::<
        CircuitInput<8>
    > {}; // 0x18857a58f3b5bb3038a4311a86919d9c7c6c15f88a4f4f0831364cf35f78f771
    let in9 = CircuitElement::<
        CircuitInput<9>
    > {}; // 0x2c84bbad27c3671562b7adefd44038ab3c0bbad96fc008e7d6998c82f7fc048b
    let in10 = CircuitElement::<
        CircuitInput<10>
    > {}; // 0xc33b1c70e4fd11b6d1eab6fcd18b99ad4afd096a8697e0c9c36d8ca3339a7b5
    let in11 = CircuitElement::<
        CircuitInput<11>
    > {}; // 0x1b007294a55accce13fe08bea73305ff6bdac77c5371c546d428780a6e3dcfa8
    let in12 = CircuitElement::<
        CircuitInput<12>
    > {}; // 0x215d42e7ac7bd17cefe88dd8e6965b3adae92c974f501fe811493d72543a3977
    let in13 = CircuitElement::<CircuitInput<13>> {}; // -0x1 % p
    let in14 = CircuitElement::<
        CircuitInput<14>
    > {}; // 0x246996f3b4fae7e6a6327cfe12150b8e747992778eeec7e5ca5cf05f80f362ac
    let in15 = CircuitElement::<
        CircuitInput<15>
    > {}; // 0x12d7c0c3ed42be419d2b22ca22ceca702eeb88c36a8b264dde75f4f798d6a3f2
    let in16 = CircuitElement::<
        CircuitInput<16>
    > {}; // 0x16c9e55061ebae204ba4cc8bd75a079432ae2a1d0b7c9dce1665d51c640fcba2
    let in17 = CircuitElement::<
        CircuitInput<17>
    > {}; // 0xc38dce27e3b2cae33ce738a184c89d94a0e78406b48f98a7b4f4463e3a7dba0
    let in18 = CircuitElement::<
        CircuitInput<18>
    > {}; // 0x7c03cbcac41049a0704b5a7ec796f2b21807dc98fa25bd282d37f632623b0e3
    let in19 = CircuitElement::<
        CircuitInput<19>
    > {}; // 0xf20e129e47c9363aa7b569817e0966cba582096fa7a164080faed1f0d24275a
    let in20 = CircuitElement::<
        CircuitInput<20>
    > {}; // 0x2c145edbe7fd8aee9f3a80b03b0b1c923685d2ea1bdec763c13b4711cd2b8126
    let in21 = CircuitElement::<
        CircuitInput<21>
    > {}; // 0x3df92c5b96e3914559897c6ad411fb25b75afb7f8b1c1a56586ff93e080f8bc
    let in22 = CircuitElement::<
        CircuitInput<22>
    > {}; // 0x12acf2ca76fd0675a27fb246c7729f7db080cb99678e2ac024c6b8ee6e0c2c4b
    let in23 = CircuitElement::<
        CircuitInput<23>
    > {}; // 0x1563dbde3bd6d35ba4523cf7da4e525e2ba6a3151500054667f8140c6a3f2d9f
    let in24 = CircuitElement::<
        CircuitInput<24>
    > {}; // 0x30644e72e131a0295e6dd9e7e0acccb0c28f069fbb966e3de4bd44e5607cfd49
    let in25 = CircuitElement::<
        CircuitInput<25>
    > {}; // 0x30644e72e131a0295e6dd9e7e0acccb0c28f069fbb966e3de4bd44e5607cfd48
    let in26 = CircuitElement::<
        CircuitInput<26>
    > {}; // 0x59e26bcea0d48bacd4f263f1acdb5c4f5763473177fffffe
    let in27 = CircuitElement::<
        CircuitInput<27>
    > {}; // 0x59e26bcea0d48bacd4f263f1acdb5c4f5763473177ffffff
    let in28 = CircuitElement::<
        CircuitInput<28>
    > {}; // 0x13d0c369615f7bb0b2bdfa8fef85fa07122bde8d67dfc8fabd3581ad840ddd76
    let in29 = CircuitElement::<
        CircuitInput<29>
    > {}; // 0x18a0f4219f4fdff6fc2bf531eb331a053a35744cac285af5685d3f90eacf7a66
    let in30 = CircuitElement::<
        CircuitInput<30>
    > {}; // 0xc3a5e9c462a654779c3e050c9ca2a428908a81264e2b5a5bf22f67654883ae6
    let in31 = CircuitElement::<
        CircuitInput<31>
    > {}; // 0x2ce02aa5f9bf8cd65bdd2055c255cf9d9e08c1d9345582cc92fd973c74bd77f4
    let in32 = CircuitElement::<
        CircuitInput<32>
    > {}; // 0x17ded419ed7be4f97fac149bfaefbac11b155498de227b850aea3f23790405d6
    let in33 = CircuitElement::<
        CircuitInput<33>
    > {}; // 0x1bfe7b214c0294242fb81a8dccd8a9b4441d64f34150a79753fb0cd31cc99cc0
    let in34 = CircuitElement::<
        CircuitInput<34>
    > {}; // 0x697b9c523e0390ed15da0ec97a9b8346513297b9efaf0f0f1a228f0d5662fbd
    let in35 = CircuitElement::<
        CircuitInput<35>
    > {}; // 0x7a0e052f2b1c443b5186d6ac4c723b85d3f78a3182d2db0c413901c32b0c6fe
    let in36 = CircuitElement::<
        CircuitInput<36>
    > {}; // 0x1b76a37fba85f3cd5dc79824a3792597356c892c39c0d06b220500933945267f
    let in37 = CircuitElement::<
        CircuitInput<37>
    > {}; // 0xabf8b60be77d7306cbeee33576139d7f03a5e397d439ec7694aa2bf4c0c101
    let in38 = CircuitElement::<
        CircuitInput<38>
    > {}; // 0x1c938b097fd2247905924b2691fb5e5685558c04009201927eeb0a69546f1fd1
    let in39 = CircuitElement::<
        CircuitInput<39>
    > {}; // 0x4f1de41b3d1766fa9f30e6dec26094f0fdf31bf98ff2631380cab2baaa586de
    let in40 = CircuitElement::<
        CircuitInput<40>
    > {}; // 0x2429efd69b073ae23e8c6565b7b72e1b0e78c27f038f14e77cfd95a083f4c261
    let in41 = CircuitElement::<
        CircuitInput<41>
    > {}; // 0x28a411b634f09b8fb14b900e9507e9327600ecc7d8cf6ebab94d0cb3b2594c64
    let in42 = CircuitElement::<
        CircuitInput<42>
    > {}; // 0x23d5e999e1910a12feb0f6ef0cd21d04a44a9e08737f96e55fe3ed9d730c239f
    let in43 = CircuitElement::<
        CircuitInput<43>
    > {}; // 0x1465d351952f0c0588982b28b4a8aea95364059e272122f5e8257f43bbb36087
    let in44 = CircuitElement::<
        CircuitInput<44>
    > {}; // 0x16db366a59b1dd0b9fb1b2282a48633d3e2ddaea200280211f25041384282499
    let in45 = CircuitElement::<
        CircuitInput<45>
    > {}; // 0x28c36e1fee7fdbe60337d84bbcba34a53a41f1ee50449cdc780cfbfaa5cc3649

    // INPUT stack
    let in46 = CircuitElement::<CircuitInput<46>> {}; // 
    let in47 = CircuitElement::<CircuitInput<47>> {}; // 
    let in48 = CircuitElement::<CircuitInput<48>> {}; // 
    let in49 = CircuitElement::<CircuitInput<49>> {}; // 
    let in50 = CircuitElement::<CircuitInput<50>> {}; // 
    let in51 = CircuitElement::<CircuitInput<51>> {}; // 
    let in52 = CircuitElement::<CircuitInput<52>> {}; // 
    let in53 = CircuitElement::<CircuitInput<53>> {}; // 
    let in54 = CircuitElement::<CircuitInput<54>> {}; // 
    let in55 = CircuitElement::<CircuitInput<55>> {}; // 
    let in56 = CircuitElement::<CircuitInput<56>> {}; // 
    let in57 = CircuitElement::<CircuitInput<57>> {}; // 
    let in58 = CircuitElement::<CircuitInput<58>> {}; // 
    let in59 = CircuitElement::<CircuitInput<59>> {}; // 
    let in60 = CircuitElement::<CircuitInput<60>> {}; // 
    let in61 = CircuitElement::<CircuitInput<61>> {}; // 
    let in62 = CircuitElement::<CircuitInput<62>> {}; // 
    let in63 = CircuitElement::<CircuitInput<63>> {}; // 
    let in64 = CircuitElement::<CircuitInput<64>> {}; // 
    let in65 = CircuitElement::<CircuitInput<65>> {}; // 
    let in66 = CircuitElement::<CircuitInput<66>> {}; // 
    let in67 = CircuitElement::<CircuitInput<67>> {}; // 
    let in68 = CircuitElement::<CircuitInput<68>> {}; // 
    let in69 = CircuitElement::<CircuitInput<69>> {}; // 
    let in70 = CircuitElement::<CircuitInput<70>> {}; // 
    let in71 = CircuitElement::<CircuitInput<71>> {}; // 
    let in72 = CircuitElement::<CircuitInput<72>> {}; // 
    let in73 = CircuitElement::<CircuitInput<73>> {}; // 
    let in74 = CircuitElement::<CircuitInput<74>> {}; // 
    let in75 = CircuitElement::<CircuitInput<75>> {}; // 
    let in76 = CircuitElement::<CircuitInput<76>> {}; // 
    let in77 = CircuitElement::<CircuitInput<77>> {}; // 
    let t0 = circuit_mul(in58, in58); // Compute z^2
    let t1 = circuit_mul(t0, in58); // Compute z^3
    let t2 = circuit_mul(t1, in58); // Compute z^4
    let t3 = circuit_mul(t2, in58); // Compute z^5
    let t4 = circuit_mul(t3, in58); // Compute z^6
    let t5 = circuit_mul(t4, in58); // Compute z^7
    let t6 = circuit_mul(t5, in58); // Compute z^8
    let t7 = circuit_mul(t6, in58); // Compute z^9
    let t8 = circuit_mul(t7, in58); // Compute z^10
    let t9 = circuit_mul(t8, in58); // Compute z^11
    let t10 = circuit_mul(in47, in58); // Eval UnnamedPoly step coeff_1 * z^1
    let t11 = circuit_add(in46, t10); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t12 = circuit_mul(in48, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t13 = circuit_add(t11, t12); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t14 = circuit_mul(in49, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t15 = circuit_add(t13, t14); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t16 = circuit_mul(in50, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t17 = circuit_add(t15, t16); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t18 = circuit_mul(in51, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t19 = circuit_add(t17, t18); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t20 = circuit_mul(in52, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t21 = circuit_add(t19, t20); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t22 = circuit_mul(in53, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t23 = circuit_add(t21, t22); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t24 = circuit_mul(in54, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t25 = circuit_add(t23, t24); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t26 = circuit_mul(in55, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t27 = circuit_add(t25, t26); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t28 = circuit_mul(in56, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t29 = circuit_add(t27, t28); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t30 = circuit_mul(in57, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t31 = circuit_add(t29, t30); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t32 = circuit_mul(in60, t0); // Eval sparse poly UnnamedPoly step coeff_2 * z^2
    let t33 = circuit_add(in59, t32); // Eval sparse poly UnnamedPoly step + coeff_2 * z^2
    let t34 = circuit_mul(in61, t2); // Eval sparse poly UnnamedPoly step coeff_4 * z^4
    let t35 = circuit_add(t33, t34); // Eval sparse poly UnnamedPoly step + coeff_4 * z^4
    let t36 = circuit_mul(in62, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t37 = circuit_add(t35, t36); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t38 = circuit_mul(in63, t6); // Eval sparse poly UnnamedPoly step coeff_8 * z^8
    let t39 = circuit_add(t37, t38); // Eval sparse poly UnnamedPoly step + coeff_8 * z^8
    let t40 = circuit_mul(in64, t8); // Eval sparse poly UnnamedPoly step coeff_10 * z^10
    let t41 = circuit_add(t39, t40); // Eval sparse poly UnnamedPoly step + coeff_10 * z^10
    let t42 = circuit_mul(in66, in58); // Eval UnnamedPoly step coeff_1 * z^1
    let t43 = circuit_add(in65, t42); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t44 = circuit_mul(in67, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t45 = circuit_add(t43, t44); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t46 = circuit_mul(in68, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t47 = circuit_add(t45, t46); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t48 = circuit_mul(in69, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t49 = circuit_add(t47, t48); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t50 = circuit_mul(in70, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t51 = circuit_add(t49, t50); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t52 = circuit_mul(in71, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t53 = circuit_add(t51, t52); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t54 = circuit_mul(in72, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t55 = circuit_add(t53, t54); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t56 = circuit_mul(in73, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t57 = circuit_add(t55, t56); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t58 = circuit_mul(in74, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t59 = circuit_add(t57, t58); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t60 = circuit_mul(in75, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t61 = circuit_add(t59, t60); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t62 = circuit_mul(in76, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t63 = circuit_add(t61, t62); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t64 = circuit_mul(t31, t63);
    let t65 = circuit_sub(t64, in1); // c_of_z * c_inv_of_z - 1
    let t66 = circuit_mul(t65, in77); // c_0 * (c_of_z * c_inv_of_z - 1)
    let t67 = circuit_mul(in71, in2);
    let t68 = circuit_add(in65, t67);
    let t69 = circuit_mul(in66, in3);
    let t70 = circuit_mul(in72, in4);
    let t71 = circuit_add(t69, t70);
    let t72 = circuit_mul(in67, in5);
    let t73 = circuit_mul(in73, in6);
    let t74 = circuit_add(t72, t73);
    let t75 = circuit_mul(in68, in7);
    let t76 = circuit_mul(in74, in8);
    let t77 = circuit_add(t75, t76);
    let t78 = circuit_mul(in69, in9);
    let t79 = circuit_mul(in75, in10);
    let t80 = circuit_add(t78, t79);
    let t81 = circuit_mul(in70, in11);
    let t82 = circuit_mul(in76, in12);
    let t83 = circuit_add(t81, t82);
    let t84 = circuit_mul(in71, in13);
    let t85 = circuit_mul(in66, in14);
    let t86 = circuit_mul(in72, in15);
    let t87 = circuit_add(t85, t86);
    let t88 = circuit_mul(in67, in16);
    let t89 = circuit_mul(in73, in17);
    let t90 = circuit_add(t88, t89);
    let t91 = circuit_mul(in68, in18);
    let t92 = circuit_mul(in74, in19);
    let t93 = circuit_add(t91, t92);
    let t94 = circuit_mul(in69, in20);
    let t95 = circuit_mul(in75, in21);
    let t96 = circuit_add(t94, t95);
    let t97 = circuit_mul(in70, in22);
    let t98 = circuit_mul(in76, in23);
    let t99 = circuit_add(t97, t98);
    let t100 = circuit_mul(in47, in24);
    let t101 = circuit_mul(in48, in25);
    let t102 = circuit_mul(in49, in13);
    let t103 = circuit_mul(in50, in26);
    let t104 = circuit_mul(in51, in27);
    let t105 = circuit_mul(in53, in24);
    let t106 = circuit_mul(in54, in25);
    let t107 = circuit_mul(in55, in13);
    let t108 = circuit_mul(in56, in26);
    let t109 = circuit_mul(in57, in27);
    let t110 = circuit_mul(in71, in2);
    let t111 = circuit_add(in65, t110);
    let t112 = circuit_mul(in66, in28);
    let t113 = circuit_mul(in72, in29);
    let t114 = circuit_add(t112, t113);
    let t115 = circuit_mul(in67, in30);
    let t116 = circuit_mul(in73, in31);
    let t117 = circuit_add(t115, t116);
    let t118 = circuit_mul(in68, in19);
    let t119 = circuit_mul(in74, in32);
    let t120 = circuit_add(t118, t119);
    let t121 = circuit_mul(in69, in33);
    let t122 = circuit_mul(in75, in34);
    let t123 = circuit_add(t121, t122);
    let t124 = circuit_mul(in70, in35);
    let t125 = circuit_mul(in76, in36);
    let t126 = circuit_add(t124, t125);
    let t127 = circuit_mul(in71, in13);
    let t128 = circuit_mul(in66, in37);
    let t129 = circuit_mul(in72, in38);
    let t130 = circuit_add(t128, t129);
    let t131 = circuit_mul(in67, in39);
    let t132 = circuit_mul(in73, in40);
    let t133 = circuit_add(t131, t132);
    let t134 = circuit_mul(in68, in41);
    let t135 = circuit_mul(in74, in7);
    let t136 = circuit_add(t134, t135);
    let t137 = circuit_mul(in69, in42);
    let t138 = circuit_mul(in75, in43);
    let t139 = circuit_add(t137, t138);
    let t140 = circuit_mul(in70, in44);
    let t141 = circuit_mul(in76, in45);
    let t142 = circuit_add(t140, t141);
    let t143 = circuit_mul(t71, in58); // Eval UnnamedPoly step coeff_1 * z^1
    let t144 = circuit_add(t68, t143); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t145 = circuit_mul(t74, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t146 = circuit_add(t144, t145); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t147 = circuit_mul(t77, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t148 = circuit_add(t146, t147); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t149 = circuit_mul(t80, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t150 = circuit_add(t148, t149); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t151 = circuit_mul(t83, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t152 = circuit_add(t150, t151); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t153 = circuit_mul(t84, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t154 = circuit_add(t152, t153); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t155 = circuit_mul(t87, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t156 = circuit_add(t154, t155); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t157 = circuit_mul(t90, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t158 = circuit_add(t156, t157); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t159 = circuit_mul(t93, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t160 = circuit_add(t158, t159); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t161 = circuit_mul(t96, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t162 = circuit_add(t160, t161); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t163 = circuit_mul(t99, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t164 = circuit_add(t162, t163); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t165 = circuit_mul(t100, in58); // Eval UnnamedPoly step coeff_1 * z^1
    let t166 = circuit_add(in46, t165); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t167 = circuit_mul(t101, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t168 = circuit_add(t166, t167); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t169 = circuit_mul(t102, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t170 = circuit_add(t168, t169); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t171 = circuit_mul(t103, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t172 = circuit_add(t170, t171); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t173 = circuit_mul(t104, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t174 = circuit_add(t172, t173); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t175 = circuit_mul(in52, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t176 = circuit_add(t174, t175); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t177 = circuit_mul(t105, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t178 = circuit_add(t176, t177); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t179 = circuit_mul(t106, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t180 = circuit_add(t178, t179); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t181 = circuit_mul(t107, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t182 = circuit_add(t180, t181); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t183 = circuit_mul(t108, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t184 = circuit_add(t182, t183); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t185 = circuit_mul(t109, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t186 = circuit_add(t184, t185); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t187 = circuit_mul(t114, in58); // Eval UnnamedPoly step coeff_1 * z^1
    let t188 = circuit_add(t111, t187); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t189 = circuit_mul(t117, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t190 = circuit_add(t188, t189); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t191 = circuit_mul(t120, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t192 = circuit_add(t190, t191); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t193 = circuit_mul(t123, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t194 = circuit_add(t192, t193); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t195 = circuit_mul(t126, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t196 = circuit_add(t194, t195); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t197 = circuit_mul(t127, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t198 = circuit_add(t196, t197); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t199 = circuit_mul(t130, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t200 = circuit_add(t198, t199); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t201 = circuit_mul(t133, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t202 = circuit_add(t200, t201); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t203 = circuit_mul(t136, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t204 = circuit_add(t202, t203); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t205 = circuit_mul(t139, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t206 = circuit_add(t204, t205); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t207 = circuit_mul(t142, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t208 = circuit_add(t206, t207); // Eval UnnamedPoly step + (coeff_11 * z^11)

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [32324006162389411176778628423, 57042285082623239461879769745, 3486998266802970665, 0]
    )
        .unwrap();

    let mut circuit_inputs = (t31, t41, t63, t66, t164, t186, t208,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x1, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x12, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0xfde6a43f5daa971f3fa65955, 0x1b2522ec5eb28ded6895e1cd, 0x1d8c8daef3eee1e8, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x42b29c567e9c385ce480a71a, 0x4e34e2ac06ead4000d14d1e2, 0x217e400dc9351e77, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0xfd28d102c0d147b2f4d521a7, 0x8481d22c6934ce844d72f250, 0x242b719062f6737b, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x43ac198484b8d9094aa82536, 0x1b9c22d81246ffc2e794e176, 0x359809094bd5c8e, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x6df7b44cbb259ef7cb58d5ed, 0xdd4ef1e69a0c1f0dd2949fa, 0x21436d48fcb50cc6, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x8a4f4f0831364cf35f78f771, 0x38a4311a86919d9c7c6c15f8, 0x18857a58f3b5bb30, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x6fc008e7d6998c82f7fc048b, 0x62b7adefd44038ab3c0bbad9, 0x2c84bbad27c36715, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0xa8697e0c9c36d8ca3339a7b5, 0x6d1eab6fcd18b99ad4afd096, 0xc33b1c70e4fd11b, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x5371c546d428780a6e3dcfa8, 0x13fe08bea73305ff6bdac77c, 0x1b007294a55accce, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x4f501fe811493d72543a3977, 0xefe88dd8e6965b3adae92c97, 0x215d42e7ac7bd17c, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x6871ca8d3c208c16d87cfd46, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x8eeec7e5ca5cf05f80f362ac, 0xa6327cfe12150b8e74799277, 0x246996f3b4fae7e6, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x6a8b264dde75f4f798d6a3f2, 0x9d2b22ca22ceca702eeb88c3, 0x12d7c0c3ed42be41, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0xb7c9dce1665d51c640fcba2, 0x4ba4cc8bd75a079432ae2a1d, 0x16c9e55061ebae20, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x6b48f98a7b4f4463e3a7dba0, 0x33ce738a184c89d94a0e7840, 0xc38dce27e3b2cae, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x8fa25bd282d37f632623b0e3, 0x704b5a7ec796f2b21807dc9, 0x7c03cbcac41049a, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0xfa7a164080faed1f0d24275a, 0xaa7b569817e0966cba582096, 0xf20e129e47c9363, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x1bdec763c13b4711cd2b8126, 0x9f3a80b03b0b1c923685d2ea, 0x2c145edbe7fd8aee, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0xf8b1c1a56586ff93e080f8bc, 0x559897c6ad411fb25b75afb7, 0x3df92c5b96e3914, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x678e2ac024c6b8ee6e0c2c4b, 0xa27fb246c7729f7db080cb99, 0x12acf2ca76fd0675, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x1500054667f8140c6a3f2d9f, 0xa4523cf7da4e525e2ba6a315, 0x1563dbde3bd6d35b, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0xbb966e3de4bd44e5607cfd49, 0x5e6dd9e7e0acccb0c28f069f, 0x30644e72e131a029, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0xbb966e3de4bd44e5607cfd48, 0x5e6dd9e7e0acccb0c28f069f, 0x30644e72e131a029, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0xacdb5c4f5763473177fffffe, 0x59e26bcea0d48bacd4f263f1, 0x0, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0xacdb5c4f5763473177ffffff, 0x59e26bcea0d48bacd4f263f1, 0x0, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x67dfc8fabd3581ad840ddd76, 0xb2bdfa8fef85fa07122bde8d, 0x13d0c369615f7bb0, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0xac285af5685d3f90eacf7a66, 0xfc2bf531eb331a053a35744c, 0x18a0f4219f4fdff6, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x64e2b5a5bf22f67654883ae6, 0x79c3e050c9ca2a428908a812, 0xc3a5e9c462a6547, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x345582cc92fd973c74bd77f4, 0x5bdd2055c255cf9d9e08c1d9, 0x2ce02aa5f9bf8cd6, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0xde227b850aea3f23790405d6, 0x7fac149bfaefbac11b155498, 0x17ded419ed7be4f9, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x4150a79753fb0cd31cc99cc0, 0x2fb81a8dccd8a9b4441d64f3, 0x1bfe7b214c029424, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x9efaf0f0f1a228f0d5662fbd, 0xd15da0ec97a9b8346513297b, 0x697b9c523e0390e, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x182d2db0c413901c32b0c6fe, 0xb5186d6ac4c723b85d3f78a3, 0x7a0e052f2b1c443, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x39c0d06b220500933945267f, 0x5dc79824a3792597356c892c, 0x1b76a37fba85f3cd, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x97d439ec7694aa2bf4c0c101, 0x6cbeee33576139d7f03a5e3, 0xabf8b60be77d73, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x9201927eeb0a69546f1fd1, 0x5924b2691fb5e5685558c04, 0x1c938b097fd22479, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x98ff2631380cab2baaa586de, 0xa9f30e6dec26094f0fdf31bf, 0x4f1de41b3d1766f, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x38f14e77cfd95a083f4c261, 0x3e8c6565b7b72e1b0e78c27f, 0x2429efd69b073ae2, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0xd8cf6ebab94d0cb3b2594c64, 0xb14b900e9507e9327600ecc7, 0x28a411b634f09b8f, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x737f96e55fe3ed9d730c239f, 0xfeb0f6ef0cd21d04a44a9e08, 0x23d5e999e1910a12, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x272122f5e8257f43bbb36087, 0x88982b28b4a8aea95364059e, 0x1465d351952f0c05, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x200280211f25041384282499, 0x9fb1b2282a48633d3e2ddaea, 0x16db366a59b1dd0b, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x50449cdc780cfbfaa5cc3649, 0x337d84bbcba34a53a41f1ee, 0x28c36e1fee7fdbe6, 0x0]);
    circuit_inputs = circuit_inputs.next(lambda_root.w0);
    circuit_inputs = circuit_inputs.next(lambda_root.w1);
    circuit_inputs = circuit_inputs.next(lambda_root.w2);
    circuit_inputs = circuit_inputs.next(lambda_root.w3);
    circuit_inputs = circuit_inputs.next(lambda_root.w4);
    circuit_inputs = circuit_inputs.next(lambda_root.w5);
    circuit_inputs = circuit_inputs.next(lambda_root.w6);
    circuit_inputs = circuit_inputs.next(lambda_root.w7);
    circuit_inputs = circuit_inputs.next(lambda_root.w8);
    circuit_inputs = circuit_inputs.next(lambda_root.w9);
    circuit_inputs = circuit_inputs.next(lambda_root.w10);
    circuit_inputs = circuit_inputs.next(lambda_root.w11);
    circuit_inputs = circuit_inputs.next(z);
    circuit_inputs = circuit_inputs.next(scaling_factor.w0);
    circuit_inputs = circuit_inputs.next(scaling_factor.w2);
    circuit_inputs = circuit_inputs.next(scaling_factor.w4);
    circuit_inputs = circuit_inputs.next(scaling_factor.w6);
    circuit_inputs = circuit_inputs.next(scaling_factor.w8);
    circuit_inputs = circuit_inputs.next(scaling_factor.w10);
    circuit_inputs = circuit_inputs.next(c_inv.w0);
    circuit_inputs = circuit_inputs.next(c_inv.w1);
    circuit_inputs = circuit_inputs.next(c_inv.w2);
    circuit_inputs = circuit_inputs.next(c_inv.w3);
    circuit_inputs = circuit_inputs.next(c_inv.w4);
    circuit_inputs = circuit_inputs.next(c_inv.w5);
    circuit_inputs = circuit_inputs.next(c_inv.w6);
    circuit_inputs = circuit_inputs.next(c_inv.w7);
    circuit_inputs = circuit_inputs.next(c_inv.w8);
    circuit_inputs = circuit_inputs.next(c_inv.w9);
    circuit_inputs = circuit_inputs.next(c_inv.w10);
    circuit_inputs = circuit_inputs.next(c_inv.w11);
    circuit_inputs = circuit_inputs.next(c_0);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let c_of_z: u384 = outputs.get_output(t31);

    let scaling_factor_of_z: u384 = outputs.get_output(t41);

    let c_inv_of_z: u384 = outputs.get_output(t63);

    let lhs: u384 = outputs.get_output(t66);

    let c_inv_frob_1_of_z: u384 = outputs.get_output(t164);

    let c_frob_2_of_z: u384 = outputs.get_output(t186);

    let c_inv_frob_3_of_z: u384 = outputs.get_output(t208);
    return (
        c_of_z,
        scaling_factor_of_z,
        c_inv_of_z,
        lhs,
        c_inv_frob_1_of_z,
        c_frob_2_of_z,
        c_inv_frob_3_of_z
    );
}
fn run_BN254_MP_CHECK_PREPARE_PAIRS_2_circuit(
    p_0: G1Point, Qy0_0: u384, Qy1_0: u384, p_1: G1Point, Qy0_1: u384, Qy1_1: u384
) -> (BNProcessedPair, BNProcessedPair) {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0x0

    // INPUT stack
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
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

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [32324006162389411176778628423, 57042285082623239461879769745, 3486998266802970665, 0]
    )
        .unwrap();

    let mut circuit_inputs = (t0, t2, t3, t4, t5, t7, t8, t9,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(p_0.x);
    circuit_inputs = circuit_inputs.next(p_0.y);
    circuit_inputs = circuit_inputs.next(Qy0_0);
    circuit_inputs = circuit_inputs.next(Qy1_0);
    circuit_inputs = circuit_inputs.next(p_1.x);
    circuit_inputs = circuit_inputs.next(p_1.y);
    circuit_inputs = circuit_inputs.next(Qy0_1);
    circuit_inputs = circuit_inputs.next(Qy1_1);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let p_0: BNProcessedPair = BNProcessedPair {
        yInv: outputs.get_output(t0),
        xNegOverY: outputs.get_output(t2),
        QyNeg0: outputs.get_output(t3),
        QyNeg1: outputs.get_output(t4)
    };

    let p_1: BNProcessedPair = BNProcessedPair {
        yInv: outputs.get_output(t5),
        xNegOverY: outputs.get_output(t7),
        QyNeg0: outputs.get_output(t8),
        QyNeg1: outputs.get_output(t9)
    };
    return (p_0, p_1);
}
fn run_BN254_MP_CHECK_PREPARE_PAIRS_3_circuit(
    p_0: G1Point,
    Qy0_0: u384,
    Qy1_0: u384,
    p_1: G1Point,
    Qy0_1: u384,
    Qy1_1: u384,
    p_2: G1Point,
    Qy0_2: u384,
    Qy1_2: u384
) -> (BNProcessedPair, BNProcessedPair, BNProcessedPair) {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0x0

    // INPUT stack
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
    let in9 = CircuitElement::<CircuitInput<9>> {}; // 
    let in10 = CircuitElement::<CircuitInput<10>> {}; // 
    let in11 = CircuitElement::<CircuitInput<11>> {}; // 
    let in12 = CircuitElement::<CircuitInput<12>> {}; // 
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

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [32324006162389411176778628423, 57042285082623239461879769745, 3486998266802970665, 0]
    )
        .unwrap();

    let mut circuit_inputs = (t0, t2, t3, t4, t5, t7, t8, t9, t10, t12, t13, t14,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(p_0.x);
    circuit_inputs = circuit_inputs.next(p_0.y);
    circuit_inputs = circuit_inputs.next(Qy0_0);
    circuit_inputs = circuit_inputs.next(Qy1_0);
    circuit_inputs = circuit_inputs.next(p_1.x);
    circuit_inputs = circuit_inputs.next(p_1.y);
    circuit_inputs = circuit_inputs.next(Qy0_1);
    circuit_inputs = circuit_inputs.next(Qy1_1);
    circuit_inputs = circuit_inputs.next(p_2.x);
    circuit_inputs = circuit_inputs.next(p_2.y);
    circuit_inputs = circuit_inputs.next(Qy0_2);
    circuit_inputs = circuit_inputs.next(Qy1_2);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let p_0: BNProcessedPair = BNProcessedPair {
        yInv: outputs.get_output(t0),
        xNegOverY: outputs.get_output(t2),
        QyNeg0: outputs.get_output(t3),
        QyNeg1: outputs.get_output(t4)
    };

    let p_1: BNProcessedPair = BNProcessedPair {
        yInv: outputs.get_output(t5),
        xNegOverY: outputs.get_output(t7),
        QyNeg0: outputs.get_output(t8),
        QyNeg1: outputs.get_output(t9)
    };

    let p_2: BNProcessedPair = BNProcessedPair {
        yInv: outputs.get_output(t10),
        xNegOverY: outputs.get_output(t12),
        QyNeg0: outputs.get_output(t13),
        QyNeg1: outputs.get_output(t14)
    };
    return (p_0, p_1, p_2);
}

#[cfg(test)]
mod tests {
    use core::traits::TryInto;

    use core::circuit::{
        RangeCheck96, AddMod, MulMod, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
        circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, u384,
        CircuitOutputsTrait, CircuitModulus, AddInputResultTrait, CircuitInputs
    };
    use garaga::definitions::{
        G1Point, G2Point, E12D, E12DMulQuotient, G1G2Pair, BNProcessedPair, BLSProcessedPair,
        MillerLoopResultScalingFactor
    };

    use super::{
        run_BLS12_381_MP_CHECK_BIT0_LOOP_2_circuit, run_BLS12_381_MP_CHECK_BIT0_LOOP_3_circuit,
        run_BLS12_381_MP_CHECK_BIT1_LOOP_2_circuit, run_BLS12_381_MP_CHECK_BIT1_LOOP_3_circuit,
        run_BLS12_381_MP_CHECK_FINALIZE_BLS_2_circuit,
        run_BLS12_381_MP_CHECK_FINALIZE_BLS_3_circuit, run_BLS12_381_MP_CHECK_INIT_BIT_2_circuit,
        run_BLS12_381_MP_CHECK_INIT_BIT_3_circuit,
        run_BLS12_381_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit,
        run_BLS12_381_MP_CHECK_PREPARE_PAIRS_2_circuit,
        run_BLS12_381_MP_CHECK_PREPARE_PAIRS_3_circuit, run_BN254_MP_CHECK_BIT0_LOOP_2_circuit,
        run_BN254_MP_CHECK_BIT0_LOOP_3_circuit, run_BN254_MP_CHECK_BIT1_LOOP_2_circuit,
        run_BN254_MP_CHECK_BIT1_LOOP_3_circuit, run_BN254_MP_CHECK_FINALIZE_BN_2_circuit,
        run_BN254_MP_CHECK_FINALIZE_BN_3_circuit, run_BN254_MP_CHECK_INIT_BIT_2_circuit,
        run_BN254_MP_CHECK_INIT_BIT_3_circuit, run_BN254_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit,
        run_BN254_MP_CHECK_PREPARE_PAIRS_2_circuit, run_BN254_MP_CHECK_PREPARE_PAIRS_3_circuit
    };


    #[test]
    fn test_run_BLS12_381_MP_CHECK_BIT0_LOOP_2_circuit_BLS12_381() {
        let yInv_0: u384 = u384 {
            limb0: 73966720706824074988619236662,
            limb1: 42448594940999343979073568840,
            limb2: 46077737715233813594529879446,
            limb3: 2347359106167037307984686096
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 7705988297302680206128137863,
            limb1: 41125653623563882997086893471,
            limb2: 57261452220586076769144182696,
            limb3: 6526638415958020458124787407
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 25576924477982438069760885999,
                limb1: 69014809299970710643520579795,
                limb2: 65519603140533672223653736312,
                limb3: 5684167619725138342305291668
            },
            x1: u384 {
                limb0: 11492494132931834620477878046,
                limb1: 38059333402710455767753075899,
                limb2: 24828275629250228679482053469,
                limb3: 5006067880420078677238758545
            },
            y0: u384 {
                limb0: 50667892757008143429265168368,
                limb1: 72921272383399479451659361579,
                limb2: 17757657870781321129275033682,
                limb3: 7145339992469545219993838400
            },
            y1: u384 {
                limb0: 35249472804683011986670698701,
                limb1: 74924331137460388269391350335,
                limb2: 30739545230180619663342001256,
                limb3: 7955853719234306273110128105
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 6552301747374431499106032889,
            limb1: 13550208009464935184283742147,
            limb2: 68487436848685660449182206332,
            limb3: 2522475858052970579396304770
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 55982199838669628782110946172,
            limb1: 42801836005633744871927297494,
            limb2: 53002018604580736772341030297,
            limb3: 7348229895199666822081891099
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 73808626024657452385272751606,
                limb1: 49252570097045874680029383354,
                limb2: 21341235208478830945972945285,
                limb3: 7542055373133413141260093143
            },
            x1: u384 {
                limb0: 27526563326521543409548092264,
                limb1: 3612706777157626655459126014,
                limb2: 63106674586712851266316821140,
                limb3: 208130262573538742119855564
            },
            y0: u384 {
                limb0: 53490648328201348213967783752,
                limb1: 28914730537270299249087548925,
                limb2: 14283139033441850899321182336,
                limb3: 2362333969099325049821901516
            },
            y1: u384 {
                limb0: 31200965383160327959743599258,
                limb1: 3572873405884610738544768450,
                limb2: 24793496656343873733210237356,
                limb3: 822242150823796419952416537
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 66015176054347817673144700752,
            limb1: 1419461796763841330947413132,
            limb2: 49651253489627368952822717908,
            limb3: 2240827021594023337730599960
        };

        let f_i_of_z: u384 = u384 {
            limb0: 27282199693189762258060367485,
            limb1: 8137383696947510148487006021,
            limb2: 46639296962617728513459903783,
            limb3: 646571295585350065799925522
        };

        let f_i_plus_one: E12D = E12D {
            w0: u384 {
                limb0: 23626016319624040931666652651,
                limb1: 36122203514898571836120792811,
                limb2: 47249292660028011029598515490,
                limb3: 4294812392860205892154200829
            },
            w1: u384 {
                limb0: 78869450351409308192186975300,
                limb1: 78922255588819786692888102459,
                limb2: 28462787193147925439866541648,
                limb3: 1632927150210253716523029302
            },
            w2: u384 {
                limb0: 72747727407078594644041639914,
                limb1: 1515217723924821708099274489,
                limb2: 57612249587446338981379809018,
                limb3: 2091526728290551790942883995
            },
            w3: u384 {
                limb0: 46720279617513404542864880157,
                limb1: 9757897624505213000954653240,
                limb2: 51541119075713085635026284540,
                limb3: 3715725851675629328737556606
            },
            w4: u384 {
                limb0: 20265706166623812597481550405,
                limb1: 49369823921294819368717295152,
                limb2: 78806687608828628167010824683,
                limb3: 1070703732845470587751440775
            },
            w5: u384 {
                limb0: 1564104426054424627512358158,
                limb1: 9173815498813690692700283384,
                limb2: 30126807008702051699039260086,
                limb3: 2502998850043283855437458719
            },
            w6: u384 {
                limb0: 12131978802332850238679812544,
                limb1: 54329922212631780695320776841,
                limb2: 23856903607645104917943424410,
                limb3: 1000055968111231568717953882
            },
            w7: u384 {
                limb0: 21389793674035680744306146271,
                limb1: 55517261152617217072538037441,
                limb2: 65811088761058984078943790603,
                limb3: 5066490274139094090334869048
            },
            w8: u384 {
                limb0: 9327893569120451405535055910,
                limb1: 62175098457646296800253933704,
                limb2: 15738409941419775583988226359,
                limb3: 7704531918475443943944719084
            },
            w9: u384 {
                limb0: 41447904437980442498966983090,
                limb1: 28357489022135787720846237645,
                limb2: 23400133233485402194106936906,
                limb3: 5428503382626088043945016969
            },
            w10: u384 {
                limb0: 16455212497229763843237943862,
                limb1: 38082121256046928638314946986,
                limb2: 216926907784119823257202769,
                limb3: 881441411652806633672903524
            },
            w11: u384 {
                limb0: 66173909555754783924252396135,
                limb1: 39146954682889547443561278710,
                limb2: 7137084757217986966065141081,
                limb3: 743241482708687989548976079
            }
        };

        let ci: u384 = u384 {
            limb0: 8025058476432680984296257292,
            limb1: 51049619996825670574535581501,
            limb2: 78330184687275624302614761995,
            limb3: 2615767555066728731410152820
        };

        let z: u384 = u384 {
            limb0: 63508986178613188473085140062,
            limb1: 33750817435060414724410741316,
            limb2: 133624819526727804,
            limb3: 0
        };

        let (
            Q0_result,
            Q1_result,
            f_i_plus_one_of_z_result,
            lhs_i_plus_one_result,
            ci_plus_one_result
        ) =
            run_BLS12_381_MP_CHECK_BIT0_LOOP_2_circuit(
            yInv_0, xNegOverY_0, Q0, yInv_1, xNegOverY_1, Q1, lhs_i, f_i_of_z, f_i_plus_one, ci, z
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 78504346655283717611601019884,
                limb1: 48585380626263748361173591022,
                limb2: 74482470374860536882230970549,
                limb3: 3112263331161207636597242321
            },
            x1: u384 {
                limb0: 70946979196980286937281548936,
                limb1: 37630853958242741434623647112,
                limb2: 10458704777536792799953428685,
                limb3: 161029280155937377895135514
            },
            y0: u384 {
                limb0: 63609392294563737484894273467,
                limb1: 45802876733359294963882025662,
                limb2: 73261610627326638140960968253,
                limb3: 1525661964099928275229755926
            },
            y1: u384 {
                limb0: 58612777834031351057505602145,
                limb1: 19852640537875362138338795461,
                limb2: 36565691159195418747066782052,
                limb3: 429660795955964063565853862
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 40587178928896243754116124186,
                limb1: 36479352318648910133945685425,
                limb2: 5837525431050467990712947417,
                limb3: 1155655290051025541501409649
            },
            x1: u384 {
                limb0: 10035139388927854693508924090,
                limb1: 15824279481437739002640797152,
                limb2: 14105946480147889183014560216,
                limb3: 6364735961285148535534675084
            },
            y0: u384 {
                limb0: 33004654580449463882511715717,
                limb1: 71272689196695583137566542732,
                limb2: 75001311586222408849637610656,
                limb3: 1598838902257261112987037618
            },
            y1: u384 {
                limb0: 33821789002356008202642027124,
                limb1: 70950527391302408639177409214,
                limb2: 1493574860825848846576249882,
                limb3: 7165707705884903811359281444
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 49835695876828206513927212659,
            limb1: 23334923981852779392028550754,
            limb2: 43484124272915207693546996815,
            limb3: 6620860867595882529041419565
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 69870077628982748424790123904,
            limb1: 10889999114054728202136382750,
            limb2: 33139372936082612649391633495,
            limb3: 194642949765947879787886684
        };

        let ci_plus_one: u384 = u384 {
            limb0: 7869379583535287973587765450,
            limb1: 72736016143797463885171530816,
            limb2: 24008725460000075666173701707,
            limb3: 37591700460008080787821834
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
        assert_eq!(lhs_i_plus_one_result, lhs_i_plus_one);
        assert_eq!(ci_plus_one_result, ci_plus_one);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_BIT0_LOOP_3_circuit_BLS12_381() {
        let yInv_0: u384 = u384 {
            limb0: 67645190188774287996388183090,
            limb1: 52657602848291146208502418266,
            limb2: 63603927553689066789144763940,
            limb3: 6338051547980557206832279155
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 4705385642774848942144548685,
            limb1: 29471600637527950823516135835,
            limb2: 7258755488100893876985677839,
            limb3: 2271939953583864467709812427
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 72136333375632148948251243396,
                limb1: 55373592774912796215448316664,
                limb2: 75107311719821888650804028508,
                limb3: 4858383089285600791102332080
            },
            x1: u384 {
                limb0: 70138607296977309774531820623,
                limb1: 45336060716454350384616122138,
                limb2: 49406454830217940861015452635,
                limb3: 4193510996978566350819129800
            },
            y0: u384 {
                limb0: 33466028378991911433433255815,
                limb1: 78307292161293928127249032483,
                limb2: 869888261216397239039779596,
                limb3: 2934617676377146432287454136
            },
            y1: u384 {
                limb0: 26182874427330299594581933379,
                limb1: 54063479596963045795174164167,
                limb2: 48492373114505132393729236674,
                limb3: 5559170957761898760583348658
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 57250133847884356384884471856,
            limb1: 51943117992509234426260248075,
            limb2: 53647304781969674245973362823,
            limb3: 4733047238140457919099386004
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 64362148428388793202253511888,
            limb1: 18618901000839345281757086299,
            limb2: 43110191744225712341907154515,
            limb3: 8017507280698249471939817957
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 63521879065894347275814207488,
                limb1: 25425093580821921393294147326,
                limb2: 21154873529816172906054973144,
                limb3: 3939560150177862172465237811
            },
            x1: u384 {
                limb0: 52454400847227534843331364876,
                limb1: 56403350820294173574665211253,
                limb2: 24805395293854825618097782338,
                limb3: 4585680638028217332413404671
            },
            y0: u384 {
                limb0: 16011903230190839297838950175,
                limb1: 78013949064657796354569835600,
                limb2: 4235139205568324472001721348,
                limb3: 2479535867334512737060388860
            },
            y1: u384 {
                limb0: 27826125445872256821300712256,
                limb1: 14588477606122288214447395523,
                limb2: 52303693192654731816017739314,
                limb3: 1944723648630403238778433833
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 77107503623253901750428994373,
            limb1: 26665084459409584569499694063,
            limb2: 15373304979505168328081951462,
            limb3: 5494060964470458262802014947
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 58075050555062230893512357942,
            limb1: 39984014701464321737056386502,
            limb2: 28044350399257281786571186487,
            limb3: 189158860746913101731791216
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 733914154557256708501082161,
                limb1: 18927676773624466103183753834,
                limb2: 37755989911654655285379951270,
                limb3: 1496829910258336721387127014
            },
            x1: u384 {
                limb0: 73427031768388013585298810087,
                limb1: 48051034499266079144833947656,
                limb2: 66516504806420318058601206341,
                limb3: 2083651689615959383784084647
            },
            y0: u384 {
                limb0: 28689247672908926748640205652,
                limb1: 67617943497493846978974278145,
                limb2: 74236474231465676797080184146,
                limb3: 1979711704692059766495889699
            },
            y1: u384 {
                limb0: 40032240807759237717895640070,
                limb1: 13766297827823042203452183395,
                limb2: 24937057537393301013125501786,
                limb3: 2769815011639412537710771166
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 2283056993468865802459226988,
            limb1: 69716840744201578088393458707,
            limb2: 77124225367352814393960846210,
            limb3: 4784189143176113769637646650
        };

        let f_i_of_z: u384 = u384 {
            limb0: 8947828768432171273903092683,
            limb1: 34914891178869867414564723482,
            limb2: 20727106707183038815556392890,
            limb3: 122409574203775513327851788
        };

        let f_i_plus_one: E12D = E12D {
            w0: u384 {
                limb0: 26802938229540759452023188326,
                limb1: 54528120650166359425634514804,
                limb2: 7545859729841264336372840718,
                limb3: 7196412543010820562300640978
            },
            w1: u384 {
                limb0: 4323173215483431568250235233,
                limb1: 74028530849435334128319539305,
                limb2: 67252475027747847549158712432,
                limb3: 4910511279305339733696270809
            },
            w2: u384 {
                limb0: 5931435599843401876953499114,
                limb1: 25403228354258987098753054580,
                limb2: 76862809613796514260264359444,
                limb3: 5020384942163346914689764943
            },
            w3: u384 {
                limb0: 50968848811957839573415054181,
                limb1: 64737593512803948756340729018,
                limb2: 36373220901384849739565561308,
                limb3: 5675063076031134715803491489
            },
            w4: u384 {
                limb0: 67865990208338337486645663434,
                limb1: 25040974144796177829520396919,
                limb2: 39405976213522692194317865569,
                limb3: 175976933001405656331713297
            },
            w5: u384 {
                limb0: 24132736565883038865261534869,
                limb1: 44552576314647229356379623104,
                limb2: 53199680720860277671126643716,
                limb3: 3375656489063191435834690263
            },
            w6: u384 {
                limb0: 4300125322400193412493214509,
                limb1: 66893719349587472352352662748,
                limb2: 44379722276642792553141730631,
                limb3: 5941628430449660124206556863
            },
            w7: u384 {
                limb0: 52066150231854372737326729718,
                limb1: 35853315184938890278838787867,
                limb2: 60159524392412879719060513424,
                limb3: 21757551343827120882079673
            },
            w8: u384 {
                limb0: 65750175360450004576429616670,
                limb1: 63375615049514521327427886703,
                limb2: 41355919226912717718662639452,
                limb3: 1052964422147184395367696206
            },
            w9: u384 {
                limb0: 13005728042041963228784237880,
                limb1: 65112766949148342657773166770,
                limb2: 57167801326905104843554415061,
                limb3: 2518359316583766766567688525
            },
            w10: u384 {
                limb0: 14858719261728665255295371291,
                limb1: 67517794057531307655900508768,
                limb2: 36210915031012528109150068060,
                limb3: 1887400678175423132721347322
            },
            w11: u384 {
                limb0: 8538081791089968876672215481,
                limb1: 3684137949228109205779810832,
                limb2: 66350910926279852355896173927,
                limb3: 1220303745327452935660075947
            }
        };

        let ci: u384 = u384 {
            limb0: 35692651665805873767103811159,
            limb1: 46690436505139854990525292345,
            limb2: 10666963490371142212370621331,
            limb3: 42957753782950998589779826
        };

        let z: u384 = u384 {
            limb0: 69934371500382649984149709376,
            limb1: 69830954992939235768547957337,
            limb2: 482687581930733628,
            limb3: 0
        };

        let (
            Q0_result,
            Q1_result,
            Q2_result,
            f_i_plus_one_of_z_result,
            lhs_i_plus_one_result,
            ci_plus_one_result
        ) =
            run_BLS12_381_MP_CHECK_BIT0_LOOP_3_circuit(
            yInv_0,
            xNegOverY_0,
            Q0,
            yInv_1,
            xNegOverY_1,
            Q1,
            yInv_2,
            xNegOverY_2,
            Q2,
            lhs_i,
            f_i_of_z,
            f_i_plus_one,
            ci,
            z
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 67961184674174432372689634720,
                limb1: 20587213131950098531630813830,
                limb2: 15075585547145173939492439534,
                limb3: 2532310210367679492262896089
            },
            x1: u384 {
                limb0: 55485362068462078441046035270,
                limb1: 46007572888767313183441604972,
                limb2: 50964778393464418678771266676,
                limb3: 624304738983415292841354997
            },
            y0: u384 {
                limb0: 21816901825667580484655819798,
                limb1: 60058105376738842204861911817,
                limb2: 76918168039014370077333320500,
                limb3: 998481880023913278337398412
            },
            y1: u384 {
                limb0: 31155314234647652465870863207,
                limb1: 900967003837906141443360240,
                limb2: 39351626727152442413249047784,
                limb3: 1042910930038278434792683116
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 59448724559369281514097617805,
                limb1: 51219087157974249687337340986,
                limb2: 68561634271470765031731107991,
                limb3: 3293990250601846792939320413
            },
            x1: u384 {
                limb0: 70037005937487644766762075082,
                limb1: 7866274820218829567132534617,
                limb2: 67303211978686286165778749668,
                limb3: 1927649236630335597663434908
            },
            y0: u384 {
                limb0: 62885107833569744038124974595,
                limb1: 64742053801638859752114628203,
                limb2: 11750824240175715750728103089,
                limb3: 6919028758564724379133011701
            },
            y1: u384 {
                limb0: 62491795249911464360887098687,
                limb1: 51056398470445987179640346310,
                limb2: 62263264381067300746878465927,
                limb3: 944951346131320906056129118
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 37231335707426507538748205177,
                limb1: 15911474260262004705492585613,
                limb2: 63409989173607161214863417673,
                limb3: 1468648026693776914515111679
            },
            x1: u384 {
                limb0: 72562782554582066270159055121,
                limb1: 50928565250562419606176579999,
                limb2: 4538792876187708347177824045,
                limb3: 6055364146872099737401286836
            },
            y0: u384 {
                limb0: 36596209547149152213451788663,
                limb1: 29352078496979641673436282388,
                limb2: 73722282685200864291643642912,
                limb3: 771750757345766528490678626
            },
            y1: u384 {
                limb0: 78932217192701075899256410324,
                limb1: 688256810671761416153194623,
                limb2: 55911584805068144952026078612,
                limb3: 6452091451737338104887130173
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 54006251063029110980762639332,
            limb1: 17375387077508308745352810849,
            limb2: 21677033842552565680924792334,
            limb3: 4940778904141617115232181200
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 1855698137564660676307554099,
            limb1: 3412263109861105522665938658,
            limb2: 28614308373960287979272703421,
            limb3: 1527439033642317426197264756
        };

        let ci_plus_one: u384 = u384 {
            limb0: 66596851160405243245870511665,
            limb1: 46603541310530417532137577993,
            limb2: 58304222388573211961702036192,
            limb3: 588893144023315916673730267
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(Q2_result, Q2);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
        assert_eq!(lhs_i_plus_one_result, lhs_i_plus_one);
        assert_eq!(ci_plus_one_result, ci_plus_one);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_BIT1_LOOP_2_circuit_BLS12_381() {
        let yInv_0: u384 = u384 {
            limb0: 15138591577633076090381769337,
            limb1: 30442861086635478222545517694,
            limb2: 10990051659609970991113351946,
            limb3: 3573309265039720144655551130
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 52478004955476185185818971177,
            limb1: 53143210075912349865282388747,
            limb2: 43405015115967962103130888881,
            limb3: 4288256425741239497433345285
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 43166082856005700688321955178,
                limb1: 45243325037267884275235808785,
                limb2: 63249085171807425043137248077,
                limb3: 7545707008094128873407391214
            },
            x1: u384 {
                limb0: 69891185089753309309306336109,
                limb1: 11047528211280235532478896000,
                limb2: 11420578191168390755892536720,
                limb3: 6844334467524323667728661394
            },
            y0: u384 {
                limb0: 62695985821202505946448680552,
                limb1: 22060240038257067645682764638,
                limb2: 63917037375341469209505903675,
                limb3: 7473960485746558204515799825
            },
            y1: u384 {
                limb0: 20415175427666494274903709121,
                limb1: 70326939858458603134525029840,
                limb2: 34214523716650665878474428796,
                limb3: 1506158271456638925509169793
            }
        };

        let Q_or_Qneg_0: G2Point = G2Point {
            x0: u384 {
                limb0: 37761079370945636480915320591,
                limb1: 71992923044522837321664137362,
                limb2: 45847041420612021026817332419,
                limb3: 6891958981188426673835700341
            },
            x1: u384 {
                limb0: 67386251085262656456474721030,
                limb1: 9539056997075631427509056394,
                limb2: 67138577187786111338987067701,
                limb3: 1311047571089536844783536772
            },
            y0: u384 {
                limb0: 66121156054957376648806150007,
                limb1: 66300817096525274803978021144,
                limb2: 51220239291800899349491341853,
                limb3: 7638063429802404473111470038
            },
            y1: u384 {
                limb0: 27774457204705044550716447217,
                limb1: 60924820522581799752280460872,
                limb2: 6129889848965742835551417836,
                limb3: 5389170678577769082764661514
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 49302556074848581763221404188,
            limb1: 10782810871956421728034131020,
            limb2: 61516487129115933650916775289,
            limb3: 2805433092698206152513846036
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 11120580650745088686759514323,
            limb1: 9518920190649488693196336106,
            limb2: 56273553252780181009021745007,
            limb3: 7902783865657408724437063784
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 35246074356258299231841843529,
                limb1: 69472201364237267652107897992,
                limb2: 50718856013452700385765690375,
                limb3: 3208696481394873994940700409
            },
            x1: u384 {
                limb0: 26197902621734007239752672573,
                limb1: 40617715802459779676401281474,
                limb2: 61834477571811274376435987698,
                limb3: 4230116039470551609387944738
            },
            y0: u384 {
                limb0: 55800561186643927968781757955,
                limb1: 8236647384829409113887318081,
                limb2: 25523165807356739020910396479,
                limb3: 1843213015777098612133895476
            },
            y1: u384 {
                limb0: 48830493899608844484398410155,
                limb1: 44963907355498985921721781566,
                limb2: 54961452045289432336993557730,
                limb3: 6985228897805703493993596262
            }
        };

        let Q_or_Qneg_1: G2Point = G2Point {
            x0: u384 {
                limb0: 35333494143680094403188216107,
                limb1: 16965756778308636711811306309,
                limb2: 71806874816470682407281294146,
                limb3: 436202529735731380485066344
            },
            x1: u384 {
                limb0: 68998654202830485450033629448,
                limb1: 66261345407292194754539062911,
                limb2: 73835320286988285470925805332,
                limb3: 4118514468477497160315353555
            },
            y0: u384 {
                limb0: 6027479470046047375839310354,
                limb1: 15110311549892476555346255842,
                limb2: 59769038845354544971295265635,
                limb3: 2713522216518730198643835197
            },
            y1: u384 {
                limb0: 13604782687158752182546622208,
                limb1: 48766591408250510025030411997,
                limb2: 44798154869944884347328281619,
                limb3: 3590709828151202064874799269
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 27907154055827194519246025433,
            limb1: 46174670112346345151543744646,
            limb2: 52857641695621740134072145978,
            limb3: 6677384063668578439370811795
        };

        let f_i_of_z: u384 = u384 {
            limb0: 66661728533700774743673951004,
            limb1: 69520908497097025009339980465,
            limb2: 64040502934314154160617470332,
            limb3: 1054432484518826560358510003
        };

        let f_i_plus_one: E12D = E12D {
            w0: u384 {
                limb0: 19851488218591966679227409148,
                limb1: 4914746743747996240528037052,
                limb2: 23383444784626738357703725803,
                limb3: 5359508772935582816411412265
            },
            w1: u384 {
                limb0: 64493801342303179030378396463,
                limb1: 48813170555381058002180979654,
                limb2: 58588630520715725224201916667,
                limb3: 2221432771874500812060733857
            },
            w2: u384 {
                limb0: 44468434537827845999854273242,
                limb1: 40479434978570550516481135496,
                limb2: 63289179654225499533989141206,
                limb3: 6862506490552387309053246012
            },
            w3: u384 {
                limb0: 1027212054485100097747552695,
                limb1: 16090227365099713049835677608,
                limb2: 61871244330377744072753095042,
                limb3: 4387891869369932369919089460
            },
            w4: u384 {
                limb0: 72215390479267622831034846262,
                limb1: 56215982609929204743377254013,
                limb2: 59825795938646333142772431982,
                limb3: 7313254863486553786236824562
            },
            w5: u384 {
                limb0: 61492680402114535390524707234,
                limb1: 15330468247616447525323800419,
                limb2: 14057127384311770951155923758,
                limb3: 737505194091342497415665880
            },
            w6: u384 {
                limb0: 13769468663787519938945462890,
                limb1: 9456183182859292627943959385,
                limb2: 33949886593964381152237064252,
                limb3: 2616902237548233628893570666
            },
            w7: u384 {
                limb0: 46268142267432377698422098509,
                limb1: 447253692536579233173234408,
                limb2: 56227378893341660723627934540,
                limb3: 395552466117058727122019060
            },
            w8: u384 {
                limb0: 25561384344987642490712038100,
                limb1: 61295735304298724037107721813,
                limb2: 48773544265531651452711244798,
                limb3: 2982492873838100748667717012
            },
            w9: u384 {
                limb0: 5401496343607837137015278494,
                limb1: 12626631229412923166964594763,
                limb2: 42548372030197500714996627521,
                limb3: 3460319207107169237835601731
            },
            w10: u384 {
                limb0: 16903630413923527257967587326,
                limb1: 26229793195713123343024540124,
                limb2: 17307018157743418700619136795,
                limb3: 6123154521848988837836449590
            },
            w11: u384 {
                limb0: 78961249222770517673069430429,
                limb1: 59590175316068702357984354612,
                limb2: 697501104662389926543461248,
                limb3: 3426690249902115126807259886
            }
        };

        let c_or_cinv_of_z: u384 = u384 {
            limb0: 72567642995272969908864478605,
            limb1: 8982416219083861547134759372,
            limb2: 42802009775305306776845992948,
            limb3: 244673634114237713901582129
        };

        let z: u384 = u384 {
            limb0: 3474286627835046091373413466,
            limb1: 51619381991889417948692158632,
            limb2: 369295462328991224,
            limb3: 0
        };

        let ci: u384 = u384 {
            limb0: 75125080661776565001566198369,
            limb1: 76980361745644602108505266633,
            limb2: 42622757293990029659342799991,
            limb3: 6208844485816239646153125197
        };

        let (
            Q0_result,
            Q1_result,
            f_i_plus_one_of_z_result,
            lhs_i_plus_one_result,
            ci_plus_one_result
        ) =
            run_BLS12_381_MP_CHECK_BIT1_LOOP_2_circuit(
            yInv_0,
            xNegOverY_0,
            Q0,
            Q_or_Qneg_0,
            yInv_1,
            xNegOverY_1,
            Q1,
            Q_or_Qneg_1,
            lhs_i,
            f_i_of_z,
            f_i_plus_one,
            c_or_cinv_of_z,
            z,
            ci
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 38808396594097986386226718226,
                limb1: 73843737136498196904985758477,
                limb2: 67208780564713420873732533275,
                limb3: 7837680209918349118233540419
            },
            x1: u384 {
                limb0: 30724456565290305283225751798,
                limb1: 36958107391818719522731055032,
                limb2: 47944246041506328735426666129,
                limb3: 187342321565792988131942330
            },
            y0: u384 {
                limb0: 66430081215720489661721135091,
                limb1: 77884098090317217747267325571,
                limb2: 4635219808934046705756145908,
                limb3: 2441067004758271272042590625
            },
            y1: u384 {
                limb0: 14243739477697752887291393275,
                limb1: 7203457858238240129880023876,
                limb2: 29479391223983553051221477899,
                limb3: 1717635083709556871694639585
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 54538172263776323911455826607,
                limb1: 72149400395723826185613936713,
                limb2: 49950785470704148885020054381,
                limb3: 5151049882501030934263068130
            },
            x1: u384 {
                limb0: 61911778814155674413495609319,
                limb1: 53389198605825636559375953773,
                limb2: 55830099372913201295034020593,
                limb3: 5824172629874044787791523002
            },
            y0: u384 {
                limb0: 33932168919722265164970822860,
                limb1: 26815745069673410454539469323,
                limb2: 63128253197965649815378938967,
                limb3: 3658684748292112182712543074
            },
            y1: u384 {
                limb0: 1104934073327508603782368949,
                limb1: 19856363832467483008670219996,
                limb2: 16206260272112294765292742409,
                limb3: 5011004530591447578579138419
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 2286769791047821924140907838,
            limb1: 42507113242918905402045036194,
            limb2: 45316853924566261877974810904,
            limb3: 4384332741569667026321812478
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 14964239645602181025381128338,
            limb1: 18666391283135037154202952611,
            limb2: 78840432833106784164179229964,
            limb3: 4278278536560038057658785414
        };

        let ci_plus_one: u384 = u384 {
            limb0: 4993721508526531884066723942,
            limb1: 56088881672879984575947223780,
            limb2: 3347721240624424355312627316,
            limb3: 1947385284510427967989333333
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
        assert_eq!(lhs_i_plus_one_result, lhs_i_plus_one);
        assert_eq!(ci_plus_one_result, ci_plus_one);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_BIT1_LOOP_3_circuit_BLS12_381() {
        let yInv_0: u384 = u384 {
            limb0: 71227217342685105383838547549,
            limb1: 62981911938657914632345724501,
            limb2: 78403052728807393597081682623,
            limb3: 22673707740791083028662400
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 3307366801472793328148471551,
            limb1: 12369284622245236415417264180,
            limb2: 46795286769470789010591758653,
            limb3: 5104216386366275457083878189
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 34470885501167253089817189663,
                limb1: 77409596378261189796330748718,
                limb2: 55621928970248556326962438579,
                limb3: 180842138169675637510251915
            },
            x1: u384 {
                limb0: 66148806616095449594467673624,
                limb1: 31295845385885243736971876808,
                limb2: 69226877827980141010608020668,
                limb3: 5700578145402173388665961159
            },
            y0: u384 {
                limb0: 27471083652748014204102421124,
                limb1: 19888459327345899191444734180,
                limb2: 45938721111283366996787061867,
                limb3: 3609704746729170017349303605
            },
            y1: u384 {
                limb0: 9143947813328137630130381560,
                limb1: 61180184404809712074370090810,
                limb2: 65792818287057306068196050338,
                limb3: 2161870028847519674273059243
            }
        };

        let Q_or_Qneg_0: G2Point = G2Point {
            x0: u384 {
                limb0: 34994925886789130228082022121,
                limb1: 66832737276056174336484384330,
                limb2: 64910468669513663643537191700,
                limb3: 4421098352827395543673902789
            },
            x1: u384 {
                limb0: 25117903832690379774455877538,
                limb1: 71367815296528310539664306164,
                limb2: 71010029869882953791635710652,
                limb3: 2865087831303631792724230868
            },
            y0: u384 {
                limb0: 50067424881832111344692971847,
                limb1: 61837602910233019860316023623,
                limb2: 46103787493636961648523857336,
                limb3: 353603414913567665377733014
            },
            y1: u384 {
                limb0: 60718322530546292949038965954,
                limb1: 2144042940926615359001754242,
                limb2: 14223585271412920951637187951,
                limb3: 5799725319996024692091903395
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 2171475348828675247121157480,
            limb1: 38123609233388061684886173423,
            limb2: 26247995558031917437916559590,
            limb3: 4332756896828943526883061502
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 52052894253444569216646640952,
            limb1: 17658690119642910777295026792,
            limb2: 31458334084941012689583550317,
            limb3: 2860207571990942390921076373
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 33167639617011430866966629304,
                limb1: 69152544170871066929564740563,
                limb2: 48307525640067381144118927373,
                limb3: 2550823999445150201782417817
            },
            x1: u384 {
                limb0: 5753534864342660154491607148,
                limb1: 46162152350749856658886131847,
                limb2: 40729506375509715495415387006,
                limb3: 5914622490010548468340025652
            },
            y0: u384 {
                limb0: 51238026199302069279605427214,
                limb1: 43806315124848668482734179492,
                limb2: 7301810606429924847837450785,
                limb3: 4787107123813425957299248297
            },
            y1: u384 {
                limb0: 20688157614188857869340895091,
                limb1: 23359941914214562836899954380,
                limb2: 50420954332928270395182964728,
                limb3: 5179848290766192998541997741
            }
        };

        let Q_or_Qneg_1: G2Point = G2Point {
            x0: u384 {
                limb0: 68983730842559781462563487978,
                limb1: 79079802217513940092941770913,
                limb2: 24007263968374872744356969877,
                limb3: 1410620471557496116583855810
            },
            x1: u384 {
                limb0: 35724738792663861820852438867,
                limb1: 4998272335320639393798466780,
                limb2: 42336799418220362040379388278,
                limb3: 1127342593560504629411120572
            },
            y0: u384 {
                limb0: 36922141654468683833166169671,
                limb1: 49307674514095662588046443087,
                limb2: 51878668062351287931837934321,
                limb3: 3013404048414865508371361100
            },
            y1: u384 {
                limb0: 39307983335575790797569174351,
                limb1: 17454314141570295940215518893,
                limb2: 35351436122357056314584246989,
                limb3: 1073398729291334425160227757
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 11437032973939379863860054686,
            limb1: 21391960940396038351648301835,
            limb2: 75429818415672169280580055573,
            limb3: 645422383119883201634595431
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 73513645440663018386476345463,
            limb1: 22478984282289735485437255036,
            limb2: 68260660296921453078095510221,
            limb3: 7013137311384157673917779612
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 61343080714515357343850354537,
                limb1: 32039610766632434336981090738,
                limb2: 1605867713481293145155247848,
                limb3: 4360220307354946642880041154
            },
            x1: u384 {
                limb0: 49939850275198913695638438973,
                limb1: 35585751158496004297517641421,
                limb2: 79161403850438913343030714723,
                limb3: 3697051814882004581238511903
            },
            y0: u384 {
                limb0: 78321037928552747557847560097,
                limb1: 22143459857676622316535479953,
                limb2: 65071684110329513736476568638,
                limb3: 2433748612480409407575736607
            },
            y1: u384 {
                limb0: 4288309432447665364354162959,
                limb1: 47131625562827541250988554876,
                limb2: 24966153397499998228604149549,
                limb3: 3547529587073137118365717743
            }
        };

        let Q_or_Qneg_2: G2Point = G2Point {
            x0: u384 {
                limb0: 47379759294949148802402115278,
                limb1: 4972823974216992385553828393,
                limb2: 45749860387064818673222043745,
                limb3: 5139986952275990394104815254
            },
            x1: u384 {
                limb0: 74337342354015795233982082580,
                limb1: 58586455485521609742145703419,
                limb2: 48349787202775590792479098938,
                limb3: 1689620779632660237265443274
            },
            y0: u384 {
                limb0: 5558755807246943022354938766,
                limb1: 73811381736328324214656742215,
                limb2: 31755858299375819329434239789,
                limb3: 4563445559770702183499502181
            },
            y1: u384 {
                limb0: 55604315837808293653600706118,
                limb1: 9791505860363971401183977246,
                limb2: 23505444102001986273638735729,
                limb3: 4170862044131145975231118316
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 62343999063237851445933617900,
            limb1: 48057097456815535931352530553,
            limb2: 60631271449061068368800724170,
            limb3: 3777337117269314077374258451
        };

        let f_i_of_z: u384 = u384 {
            limb0: 52347882375416711861047272564,
            limb1: 12385221529944208303047558042,
            limb2: 10805252195299343761012774909,
            limb3: 7890832194338029127349257140
        };

        let f_i_plus_one: E12D = E12D {
            w0: u384 {
                limb0: 57783046213348532466150161898,
                limb1: 75852380943796839105374941061,
                limb2: 43854703806045641301161944357,
                limb3: 1400099012549885068636633535
            },
            w1: u384 {
                limb0: 398504846974229228559292128,
                limb1: 31222368734356768385786556319,
                limb2: 75027437257822017611221879800,
                limb3: 2080263057325664696825208751
            },
            w2: u384 {
                limb0: 71586319050533256412523421034,
                limb1: 16775528908212184715768563625,
                limb2: 51175965927936180407293426065,
                limb3: 1410807143786187565034976514
            },
            w3: u384 {
                limb0: 17492625310094939848845839893,
                limb1: 20024267067206259844684983171,
                limb2: 14368659570732166894369856758,
                limb3: 5618194217439312477398840645
            },
            w4: u384 {
                limb0: 67453884927596885341933216086,
                limb1: 78441935495922885572857972415,
                limb2: 36545194278797449627840498891,
                limb3: 724388781838373124624180118
            },
            w5: u384 {
                limb0: 5337027429274099069720475292,
                limb1: 15641032874051701601769164891,
                limb2: 38599200438487804571040102314,
                limb3: 3536927045466041393289371294
            },
            w6: u384 {
                limb0: 51931919915221064431684465960,
                limb1: 22590891849857798510253594702,
                limb2: 71314742198074617175796651549,
                limb3: 4811736591890538323425959752
            },
            w7: u384 {
                limb0: 48831678325450656939167811827,
                limb1: 54941413287852378557175031177,
                limb2: 44807646060769548386576378166,
                limb3: 7999071028799123431408655481
            },
            w8: u384 {
                limb0: 33934007893407971405859599792,
                limb1: 24815431847381168616079357324,
                limb2: 17551074567661055945216447868,
                limb3: 6346557523512360707525095065
            },
            w9: u384 {
                limb0: 66560376133629659284492374960,
                limb1: 53841888629370538609307240019,
                limb2: 69553281113388908262858169056,
                limb3: 4410611720408540136217658215
            },
            w10: u384 {
                limb0: 24201968932917039040224984397,
                limb1: 8622609867679845681239566363,
                limb2: 48061995700905790187293853176,
                limb3: 2779085666217058180842404445
            },
            w11: u384 {
                limb0: 11092074985387155235246745709,
                limb1: 15562941247471033246760569578,
                limb2: 70222759100483919143996971164,
                limb3: 7204071915502156628168939645
            }
        };

        let c_or_cinv_of_z: u384 = u384 {
            limb0: 1476043729162975625326979418,
            limb1: 50042606671560568339859148092,
            limb2: 46102114499241260453929441358,
            limb3: 7617790332561903674083956631
        };

        let z: u384 = u384 {
            limb0: 37403928215552190718554187333,
            limb1: 11775918347622240499777570327,
            limb2: 452519787397270074,
            limb3: 0
        };

        let ci: u384 = u384 {
            limb0: 61175617298180174936644689860,
            limb1: 67911541097422909572801106741,
            limb2: 36817417761825518267712596930,
            limb3: 896803617335713796194933695
        };

        let (
            Q0_result,
            Q1_result,
            Q2_result,
            f_i_plus_one_of_z_result,
            lhs_i_plus_one_result,
            ci_plus_one_result
        ) =
            run_BLS12_381_MP_CHECK_BIT1_LOOP_3_circuit(
            yInv_0,
            xNegOverY_0,
            Q0,
            Q_or_Qneg_0,
            yInv_1,
            xNegOverY_1,
            Q1,
            Q_or_Qneg_1,
            yInv_2,
            xNegOverY_2,
            Q2,
            Q_or_Qneg_2,
            lhs_i,
            f_i_of_z,
            f_i_plus_one,
            c_or_cinv_of_z,
            z,
            ci
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 15084118772175327171821031275,
                limb1: 62888554332603600324741169709,
                limb2: 16072491814775261407984248023,
                limb3: 2469768056536795286522650059
            },
            x1: u384 {
                limb0: 45740165721060067286942347396,
                limb1: 51001691032336877440622413319,
                limb2: 17472127020718751454881019416,
                limb3: 7257386816077206261062623034
            },
            y0: u384 {
                limb0: 78551898791398680882315357881,
                limb1: 17153749476359796671419944547,
                limb2: 25001735554484957525225796308,
                limb3: 3494465550770952967030622469
            },
            y1: u384 {
                limb0: 60688128673324186932121552376,
                limb1: 44585627350841398033974426468,
                limb2: 65889837116115232678126908238,
                limb3: 5384491006521491657409089992
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 42508303975364401225937159644,
                limb1: 40524916459287843255825737369,
                limb2: 5925177054757494067379812049,
                limb3: 472436373740118280495558695
            },
            x1: u384 {
                limb0: 64095887622861479831453303560,
                limb1: 59428653475030421250439690002,
                limb2: 48954022105730032615486275553,
                limb3: 4972901184108054408456956956
            },
            y0: u384 {
                limb0: 28564217961697562084149501953,
                limb1: 42695470893915552843081495428,
                limb2: 856565180973317119165448256,
                limb3: 6516613961208118884502561798
            },
            y1: u384 {
                limb0: 14490171548350024334351642629,
                limb1: 25070791091897407510582428848,
                limb2: 33414749568336886460476878322,
                limb3: 688311396636307779773809089
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 76934903187457786179568206900,
                limb1: 74834100803402164550411130686,
                limb2: 62620940055545207944055166297,
                limb3: 1963439303868780644135306723
            },
            x1: u384 {
                limb0: 35466893887148472080811264345,
                limb1: 27865711592650709071295900892,
                limb2: 34136205166606801798698742268,
                limb3: 5946795888786284358509703001
            },
            y0: u384 {
                limb0: 68505489258388367435131920350,
                limb1: 52165562005253543596896153125,
                limb2: 62825906370249702392441432429,
                limb3: 3005533828611332631347151118
            },
            y1: u384 {
                limb0: 47295415947992767619463795871,
                limb1: 72202746056164561406178670248,
                limb2: 57844702573459567962432867132,
                limb3: 2475524642026140637914511800
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 41342924563810037945929684424,
            limb1: 40053487760576372405284431000,
            limb2: 16400454906497301610956216375,
            limb3: 6403941801210632197000428070
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 29429711985866286756014404914,
            limb1: 47877202212530420447648429640,
            limb2: 33846832772054519759194661039,
            limb3: 256602289929363142592057383
        };

        let ci_plus_one: u384 = u384 {
            limb0: 38032561439652176266292862272,
            limb1: 22802766666041954911327960704,
            limb2: 49460894359258770739592579949,
            limb3: 7972368844221244547742306221
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(Q2_result, Q2);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
        assert_eq!(lhs_i_plus_one_result, lhs_i_plus_one);
        assert_eq!(ci_plus_one_result, ci_plus_one);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_FINALIZE_BLS_2_circuit_BLS12_381() {
        let R_n_minus_1: E12D = E12D {
            w0: u384 {
                limb0: 5054154438142243532781310358,
                limb1: 37489640889017175514163557768,
                limb2: 2088843260555989844194895718,
                limb3: 5189274206158696702552041821
            },
            w1: u384 {
                limb0: 6595840205269359177179254100,
                limb1: 48971099572260734544545254722,
                limb2: 51881189181474613257197064073,
                limb3: 3860849834042729262588143490
            },
            w2: u384 {
                limb0: 19600771446407744114551614036,
                limb1: 35110786356769135019011795179,
                limb2: 10400844186353998778345785819,
                limb3: 1689619688338013901033084389
            },
            w3: u384 {
                limb0: 21582894715155173455494887740,
                limb1: 10704905637930800623173596814,
                limb2: 55271378696458858577215613947,
                limb3: 5851306079748286798990589976
            },
            w4: u384 {
                limb0: 49996735576413539624696891175,
                limb1: 69506368872106790443917290425,
                limb2: 41472758429932696471852894607,
                limb3: 5286342010965850099284511850
            },
            w5: u384 {
                limb0: 27505506514355532720362616567,
                limb1: 17994969412454492893277423174,
                limb2: 35007780453694431289768236051,
                limb3: 4082268805244292429872395021
            },
            w6: u384 {
                limb0: 24051524673976791186618365668,
                limb1: 41461384159514634436195109192,
                limb2: 67181242653468026618521631445,
                limb3: 2839955761958100248662677032
            },
            w7: u384 {
                limb0: 658949086095406810674322284,
                limb1: 38974840754625706435816829221,
                limb2: 37797147538603871489395248831,
                limb3: 7584801201173204536315299427
            },
            w8: u384 {
                limb0: 31275481851329239208293334411,
                limb1: 56643222751046890580329705780,
                limb2: 30877058322226702963948372328,
                limb3: 2184641580395679242108782672
            },
            w9: u384 {
                limb0: 33453250364215737130895453418,
                limb1: 40930065933237687466897779547,
                limb2: 72094015082822779457760708623,
                limb3: 6872295984309251676202319079
            },
            w10: u384 {
                limb0: 22554423765244983836210927109,
                limb1: 42144966312055100607691835331,
                limb2: 32713615694079088218382144871,
                limb3: 678034185620919364339420934
            },
            w11: u384 {
                limb0: 22944103539015061808423779491,
                limb1: 36075990221520051557558669381,
                limb2: 21560686763305557824410715088,
                limb3: 4872492572436443043766348824
            }
        };

        let c_n_minus_2: u384 = u384 {
            limb0: 1536661748789430005364095001,
            limb1: 76828834137118756548786733512,
            limb2: 14731493853980595191664596970,
            limb3: 2793927054306810391712942646
        };

        let w_of_z: u384 = u384 {
            limb0: 56663660322376042743683741947,
            limb1: 649994929383489660214055558,
            limb2: 11938392442187246668913145877,
            limb3: 2150926634398318338089746942
        };

        let z: u384 = u384 {
            limb0: 24685648053119625227072412121,
            limb1: 39486979755670645578712566709,
            limb2: 36736868250428139881539209293,
            limb3: 314309216930710845739651493
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 66832623287861230092746960099,
            limb1: 11574270387473012148289229802,
            limb2: 61453554803885873572359997296,
            limb3: 5379512538751782466117550318
        };

        let previous_lhs: u384 = u384 {
            limb0: 19724830568516106811137667533,
            limb1: 77245257241489451331044384097,
            limb2: 58440198805071447685532607339,
            limb3: 1972581917786924191177105257
        };

        let R_n_minus_2_of_z: u384 = u384 {
            limb0: 25595702870716512214597396022,
            limb1: 57696885986842674423639229009,
            limb2: 74270137469191502826566365756,
            limb3: 1209630956016240092700034430
        };

        let Q: Array<u384> = array![
            u384 {
                limb0: 50144214671776250787072106799,
                limb1: 1193786767206993737363568590,
                limb2: 21874898923618322729192136906,
                limb3: 3919895541852746986925502859
            },
            u384 {
                limb0: 707495672235467889558508450,
                limb1: 46037664789411966802005954800,
                limb2: 37654822495166007647621207389,
                limb3: 1534965870903100341896309044
            },
            u384 {
                limb0: 49528085829314403883453882647,
                limb1: 28167012219857730790460724999,
                limb2: 55564939853396036197462236235,
                limb3: 1063555455884997123319427991
            },
            u384 {
                limb0: 15288286442614916454934372776,
                limb1: 29929938914800367632941277448,
                limb2: 10674582645371629134314265974,
                limb3: 391075602626068185051144442
            },
            u384 {
                limb0: 34662321279046293003305796284,
                limb1: 42999823288509043046654689184,
                limb2: 15035590486256648224186110299,
                limb3: 5383757136688983285926419838
            },
            u384 {
                limb0: 58026897365689193231594589541,
                limb1: 68743253239056723544065488738,
                limb2: 72452094678885946428742652837,
                limb3: 1587964251301502191640885090
            },
            u384 {
                limb0: 12282383976500276474650158423,
                limb1: 64921026015426583323610896350,
                limb2: 29085664990450599925826378653,
                limb3: 7684318728964532700056552753
            },
            u384 {
                limb0: 30030925335149584305500826885,
                limb1: 69953109492339350293936406124,
                limb2: 67885010360813240021404013322,
                limb3: 6142136738440602161239033907
            },
            u384 {
                limb0: 57123787590678272243583229359,
                limb1: 76626559788853894453071915612,
                limb2: 30700187493699207924626820585,
                limb3: 6766324544124151456576784605
            },
            u384 {
                limb0: 43691781032608121820343656874,
                limb1: 22431797287867864458183649698,
                limb2: 50777640559406037512033266326,
                limb3: 953276214010815376314608425
            },
            u384 {
                limb0: 5282921597590139168091043946,
                limb1: 74300134330141170764665388164,
                limb2: 69205228017172180086145213158,
                limb3: 1060223059142550372082617987
            },
            u384 {
                limb0: 7824065233503068935459781162,
                limb1: 50844805249785890706592967481,
                limb2: 52125892201648000888515049920,
                limb3: 6179504377082404933368199106
            },
            u384 {
                limb0: 38933154502306944381180959754,
                limb1: 65923987067781818164276092331,
                limb2: 63463338439566832568720952477,
                limb3: 3574438494556528182826109888
            },
            u384 {
                limb0: 74335336692887028433619149875,
                limb1: 65127650506772182446325842600,
                limb2: 56127907211603191434873358438,
                limb3: 6109811753362285823349538835
            },
            u384 {
                limb0: 3220874574134931503507603035,
                limb1: 66112455407726182207053306737,
                limb2: 74839198519170596792676692061,
                limb3: 5144733003462332328911911410
            },
            u384 {
                limb0: 57454039811802102943937515190,
                limb1: 30529074199098007480980209389,
                limb2: 41689226853552258433048148573,
                limb3: 5645280576171407774036070204
            },
            u384 {
                limb0: 14173751306660034785584696677,
                limb1: 44220534095659994433778407243,
                limb2: 8359694386282320485998496166,
                limb3: 5710009931616564589091300971
            },
            u384 {
                limb0: 36343589778240065419306302645,
                limb1: 33836366707515820218403936264,
                limb2: 13215995766945967215850078551,
                limb3: 5446594144033484840869217145
            },
            u384 {
                limb0: 48203473588933207026954303220,
                limb1: 43228964819187836868693589593,
                limb2: 60665654945808222375796539013,
                limb3: 7373946816759240461752496525
            },
            u384 {
                limb0: 76189903049013293298307824681,
                limb1: 76045126233181674326402840263,
                limb2: 57544466837745662410906647088,
                limb3: 2817374948305565187552815864
            },
            u384 {
                limb0: 41009238469239924961191389617,
                limb1: 70538778763506618699416402442,
                limb2: 23794907384283347085383007909,
                limb3: 2127502068317957920496109025
            },
            u384 {
                limb0: 1719359888409573037450493567,
                limb1: 74739721163510390352829909305,
                limb2: 21863576423301876455419506615,
                limb3: 5063387558510596678751022566
            },
            u384 {
                limb0: 73359134458362973087622443141,
                limb1: 7470195899466877853918111551,
                limb2: 28177952031926823650887013914,
                limb3: 2624315810256509016173093548
            },
            u384 {
                limb0: 46123126799454082253306012923,
                limb1: 20301728259960822024417746753,
                limb2: 7281473849022007709958049720,
                limb3: 5635746121028602007527322203
            },
            u384 {
                limb0: 45653838896655352449410354660,
                limb1: 7555518782418446404262019218,
                limb2: 23799605726385021881199694432,
                limb3: 8005423190324616607025934150
            },
            u384 {
                limb0: 6217619608875161300142347283,
                limb1: 73038184861391415418098684365,
                limb2: 27565870725173607630435372303,
                limb3: 4301142457270976885422691530
            },
            u384 {
                limb0: 61593448516697723135790505237,
                limb1: 4288458246667000560162926826,
                limb2: 3262794357235032361020049616,
                limb3: 5594626375718401199275162254
            },
            u384 {
                limb0: 47151229791268738446749067212,
                limb1: 7137107014234509328368527082,
                limb2: 22958976877508070869600737936,
                limb3: 1465843814205875297767616211
            },
            u384 {
                limb0: 6539897711575709952316482610,
                limb1: 59049940939206865625589849166,
                limb2: 31627193139037453978429269734,
                limb3: 3946820630225947185213013989
            },
            u384 {
                limb0: 61308743623254939693894564549,
                limb1: 60374468105470122122893829237,
                limb2: 44312008672220934529391977464,
                limb3: 3915047799642711781264539008
            },
            u384 {
                limb0: 15536587270260081821694410977,
                limb1: 78996718385071340434785611316,
                limb2: 19509605447472720756474165441,
                limb3: 2636882450510956536151956663
            },
            u384 {
                limb0: 25623309668264604997198185969,
                limb1: 45636866494237073561034095837,
                limb2: 53221324386363070692027509983,
                limb3: 3617435574289304259924099952
            },
            u384 {
                limb0: 25411510973686182192251319357,
                limb1: 51926918817007123290138003678,
                limb2: 24150237474038724330957990710,
                limb3: 3463423460169503244996071437
            },
            u384 {
                limb0: 78448492610421177070689233077,
                limb1: 49373577131030790317241797191,
                limb2: 3555565766827319665301412890,
                limb3: 2312369021190978586713603200
            },
            u384 {
                limb0: 29617134690012347945862468082,
                limb1: 57716666469778090561972931147,
                limb2: 8903006345751758673818861644,
                limb3: 2407033805427697258130127047
            },
            u384 {
                limb0: 73423090925861761276439284400,
                limb1: 65953068304086131166705232417,
                limb2: 1088063366493091882861874317,
                limb3: 7965211003108707351637565937
            },
            u384 {
                limb0: 35657551264147865679850944237,
                limb1: 26293982804979214743276350870,
                limb2: 42625183888771571153532724786,
                limb3: 5411523305312755317819143665
            },
            u384 {
                limb0: 20492998205373140969247260834,
                limb1: 49362472062724135070142966020,
                limb2: 11198696209962053026191263129,
                limb3: 6618132296788990381052145320
            },
            u384 {
                limb0: 46190410237535001352781241362,
                limb1: 41737324312431750812097724810,
                limb2: 13494112902918695937256825608,
                limb3: 1987597461403428592332005194
            },
            u384 {
                limb0: 48960213676974752424039825886,
                limb1: 36837991155746086208299774853,
                limb2: 660301904083392823279105574,
                limb3: 6540015734812322716919303570
            },
            u384 {
                limb0: 18315064599260385437053603602,
                limb1: 40290715805771972685281342540,
                limb2: 7891419083379642134920641900,
                limb3: 4799861463456619419257809092
            },
            u384 {
                limb0: 42114573693637016542807118228,
                limb1: 15756516614023615060931806658,
                limb2: 36285409730500982709164877547,
                limb3: 7055953172450666281544792058
            },
            u384 {
                limb0: 19600424109166011929778472083,
                limb1: 24158847173808354910489142507,
                limb2: 31168344361761975432443646419,
                limb3: 181949702874942852972962811
            },
            u384 {
                limb0: 27881427136773593036239573336,
                limb1: 23952750503137207178460008371,
                limb2: 77504495279955141127904422474,
                limb3: 2732166089682534282257808223
            },
            u384 {
                limb0: 22199243526514995046734922063,
                limb1: 27079088742027668653376260534,
                limb2: 52047496527785632906466904093,
                limb3: 7228477124141421236454654998
            },
            u384 {
                limb0: 76107023749316063346772431717,
                limb1: 69142534016875185670582244037,
                limb2: 18018700598011998082359779669,
                limb3: 5673712468870246490176904076
            },
            u384 {
                limb0: 76893877068526091774753149343,
                limb1: 47962264564536230933295550737,
                limb2: 42960184097589156873541255474,
                limb3: 6461776098524477482606514563
            },
            u384 {
                limb0: 10715806823700665454416108978,
                limb1: 72018565357521146109394203012,
                limb2: 11500157564541037014126724077,
                limb3: 5593946823364888891112738253
            },
            u384 {
                limb0: 57605175573235144274926892749,
                limb1: 25249020219681121418112415861,
                limb2: 32803640448279426407758582515,
                limb3: 3004214131722359249323488269
            },
            u384 {
                limb0: 73980764483281449545105980908,
                limb1: 50456248812408641184960533878,
                limb2: 21692366969575718568275310942,
                limb3: 1861204309299737093074233418
            },
            u384 {
                limb0: 14637125589086652653003693933,
                limb1: 78115449650034045941768842535,
                limb2: 21143034125994993252221768572,
                limb3: 6064539749323155690586957224
            },
            u384 {
                limb0: 18395395764800374948572758401,
                limb1: 2066626235041522897123087055,
                limb2: 54520169338970596124585921821,
                limb3: 1327929611348656042639798641
            },
            u384 {
                limb0: 47910201524353844828532398093,
                limb1: 51464122827134792641982554746,
                limb2: 67512649320630432140392910245,
                limb3: 4692752660848349400854993133
            },
            u384 {
                limb0: 68701037517780443705428285388,
                limb1: 54498098278426792826431314471,
                limb2: 36250443962157776200025267201,
                limb3: 4234306388089307635645998457
            }
        ];

        let (final_check_result) = run_BLS12_381_MP_CHECK_FINALIZE_BLS_2_circuit(
            R_n_minus_1,
            c_n_minus_2,
            w_of_z,
            z,
            c_inv_frob_1_of_z,
            previous_lhs,
            R_n_minus_2_of_z,
            Q
        );
        let final_check: u384 = u384 {
            limb0: 19875210744276112495080267674,
            limb1: 25649179571014925054195085280,
            limb2: 65873170560410511338811085036,
            limb3: 235919030056186864261847654
        };
        assert_eq!(final_check_result, final_check);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_FINALIZE_BLS_3_circuit_BLS12_381() {
        let R_n_minus_1: E12D = E12D {
            w0: u384 {
                limb0: 47046142486972972261709078415,
                limb1: 50816454005252626321141513683,
                limb2: 62346215115138956850411819022,
                limb3: 1082616121052529102528703413
            },
            w1: u384 {
                limb0: 44185621387348334223333530447,
                limb1: 60622210873868440731036451198,
                limb2: 3905587764636636541466324707,
                limb3: 4353130703477435045036820538
            },
            w2: u384 {
                limb0: 40958555296007559508041057575,
                limb1: 36728508495381374859444963735,
                limb2: 35787209966544118853013857927,
                limb3: 4958274638141632097942970618
            },
            w3: u384 {
                limb0: 61697437490137262306021134399,
                limb1: 70855965398634124575202338507,
                limb2: 10720099355900835050372237640,
                limb3: 3203401889805400857259279679
            },
            w4: u384 {
                limb0: 14172220892412643303792394620,
                limb1: 71037357631596182949171850154,
                limb2: 15998701697997020377002226951,
                limb3: 893096134343532822446125553
            },
            w5: u384 {
                limb0: 54803500633343273683105703096,
                limb1: 56368440433982197747298147024,
                limb2: 56915508979119761919006115185,
                limb3: 903114296687111175046370452
            },
            w6: u384 {
                limb0: 75247255947858933266234774164,
                limb1: 43602893470687655538719665990,
                limb2: 60867854220943682527271286282,
                limb3: 3319592092307096882663857717
            },
            w7: u384 {
                limb0: 52253376920976009507255881285,
                limb1: 12844794316429012098730171019,
                limb2: 14171285128187260011889222745,
                limb3: 508154501275282942860948921
            },
            w8: u384 {
                limb0: 16071568016934262467149603739,
                limb1: 60640903312089822222359169060,
                limb2: 36337415013592298157691888008,
                limb3: 4938313529509003754865984990
            },
            w9: u384 {
                limb0: 455605189405480173068018757,
                limb1: 39096467442487792882327803302,
                limb2: 46654480029658638242179029132,
                limb3: 4493608307706445938258284814
            },
            w10: u384 {
                limb0: 6291105904354476314872229399,
                limb1: 520768511935066287456736307,
                limb2: 43364869920763745455906850217,
                limb3: 6225703695945661705404704969
            },
            w11: u384 {
                limb0: 65383239598101981159147405832,
                limb1: 14644532730071297524572339438,
                limb2: 51757926579741786309869706710,
                limb3: 1439718421847462759127145767
            }
        };

        let c_n_minus_2: u384 = u384 {
            limb0: 52844910492387579712230428272,
            limb1: 47797198799150290595638796872,
            limb2: 72920388404478357552629197389,
            limb3: 1078371000032522920418062075
        };

        let w_of_z: u384 = u384 {
            limb0: 14122292952774372229350535258,
            limb1: 22530947763590105500316681197,
            limb2: 54787353171451670210945245402,
            limb3: 5667612229380157329593936165
        };

        let z: u384 = u384 {
            limb0: 14056602336726365855500008776,
            limb1: 59368419822980326445104955096,
            limb2: 73799434918835248398593368704,
            limb3: 7610974033510204037573431344
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 29201077833921904662567358522,
            limb1: 64988068808283840490408018687,
            limb2: 33856082238812893422948620915,
            limb3: 642994626556830966566036431
        };

        let previous_lhs: u384 = u384 {
            limb0: 10659815763808439508550489527,
            limb1: 68089312147988139054510959133,
            limb2: 41757419838770400519037930282,
            limb3: 2078207854285635172780739029
        };

        let R_n_minus_2_of_z: u384 = u384 {
            limb0: 48491893853758107134453735877,
            limb1: 45268363159309418635618234211,
            limb2: 49832818629875373925160942844,
            limb3: 868239101186979978549988266
        };

        let Q: Array<u384> = array![
            u384 {
                limb0: 41625781252339807539492644089,
                limb1: 49378488439264085478825823488,
                limb2: 10276933694938779887963873781,
                limb3: 4916077007145037834550909870
            },
            u384 {
                limb0: 50060917338098541951588200563,
                limb1: 64014799592903434996646934060,
                limb2: 48282098529343382206710441587,
                limb3: 2876854403474683137027712319
            },
            u384 {
                limb0: 125253137576538546057027933,
                limb1: 36832034701547913763889533624,
                limb2: 9343038275520595944726737397,
                limb3: 2053305161580608789125184056
            },
            u384 {
                limb0: 79147905261602354367455838149,
                limb1: 3604262698830801923480048686,
                limb2: 44400690229788867132065540303,
                limb3: 2102893049479250610983853600
            },
            u384 {
                limb0: 15939687515285274032894927018,
                limb1: 20157032387725382133127378263,
                limb2: 24384253778748248040204288188,
                limb3: 5446872825015251521287186815
            },
            u384 {
                limb0: 13914770344036142278138674324,
                limb1: 66062446621382239657482977624,
                limb2: 53278796652861255549425223555,
                limb3: 4699224837968473112577496810
            },
            u384 {
                limb0: 62114010613781332508810002191,
                limb1: 73507094775116389221294487875,
                limb2: 66163893194080026360347756303,
                limb3: 5594920891996254076022361611
            },
            u384 {
                limb0: 28014725359095095564487222838,
                limb1: 11829153773037413937886484086,
                limb2: 2469792797662545025044331110,
                limb3: 3716204691266880712607969613
            },
            u384 {
                limb0: 66742261865051677229450462154,
                limb1: 47987633590648648769824684521,
                limb2: 47155958068725536093946682758,
                limb3: 7747959071170542974748166050
            },
            u384 {
                limb0: 35803707880829455290951147358,
                limb1: 23976716334574667221748372229,
                limb2: 23952123256651386191776903535,
                limb3: 3706052694059093275808998063
            },
            u384 {
                limb0: 15070122083987989312347279142,
                limb1: 38304593693320589767404017149,
                limb2: 41486081211554615451363394032,
                limb3: 3241798093295792521854823196
            },
            u384 {
                limb0: 69071031783411088426846321642,
                limb1: 77823722307262642138326172583,
                limb2: 53615067305263228630356612271,
                limb3: 2032074679949785158236957601
            },
            u384 {
                limb0: 36394915046398890764826146327,
                limb1: 68517323096644823583357991721,
                limb2: 325617778008501268669555924,
                limb3: 436051606097540582096009407
            },
            u384 {
                limb0: 47084312642479042983373220160,
                limb1: 26405934989144551701458662598,
                limb2: 3655569669905551839088422363,
                limb3: 7587881023658015968194785917
            },
            u384 {
                limb0: 24757280142112946517986980256,
                limb1: 60094071663947246164894630946,
                limb2: 70682263029501166523679021272,
                limb3: 1986205581456163876726403692
            },
            u384 {
                limb0: 21918434466196448847906647005,
                limb1: 61226501893280894153373465144,
                limb2: 9321259936469641995718816795,
                limb3: 1559765019756058645699013267
            },
            u384 {
                limb0: 1208761147641704855957737789,
                limb1: 44338120944967582021718312295,
                limb2: 16366745919137836049203034821,
                limb3: 5440653963534857284222134654
            },
            u384 {
                limb0: 11215287124490256517270354470,
                limb1: 63699667614353942476953921449,
                limb2: 19397040796616583048822274907,
                limb3: 3083733980868367912617422157
            },
            u384 {
                limb0: 26837660278008610180747414488,
                limb1: 4018942259526979151571665610,
                limb2: 37295514496047989893372872625,
                limb3: 499692167437676087221300165
            },
            u384 {
                limb0: 4262465511462328005941921475,
                limb1: 31050844891181413431323127508,
                limb2: 47229599675772805737562100827,
                limb3: 6233975750445648064188950582
            },
            u384 {
                limb0: 55409443476839822684907865728,
                limb1: 28175460875803332675251622733,
                limb2: 64764425887170447328713382996,
                limb3: 7510855024012459081163457858
            },
            u384 {
                limb0: 42267031167380068126544504650,
                limb1: 73110480047975937411085209752,
                limb2: 36896187971642712109344120439,
                limb3: 920197180889936306101724096
            },
            u384 {
                limb0: 72865272659378694735950971144,
                limb1: 7705968648091064844965865770,
                limb2: 54229932108897270514344602125,
                limb3: 7590983880189885559313309219
            },
            u384 {
                limb0: 18356706742050923486474680995,
                limb1: 11386804857782137839827023942,
                limb2: 48879188275766481818919947810,
                limb3: 3599427982431392894924340975
            },
            u384 {
                limb0: 55429180598206686218124470076,
                limb1: 26171277012159814586663556952,
                limb2: 69911238660822029290452117158,
                limb3: 4828032835486359820936907519
            },
            u384 {
                limb0: 37659868166195917736401396718,
                limb1: 37922725014257917631255685791,
                limb2: 13532292416718509718201691972,
                limb3: 3452520083756681934365918421
            },
            u384 {
                limb0: 10093192496014733583654361177,
                limb1: 32141754505223108767439715650,
                limb2: 63125654468470919577601779052,
                limb3: 5507841450665635737155870815
            },
            u384 {
                limb0: 62782847358967593880516719266,
                limb1: 36522190801258813330854223104,
                limb2: 32756242491559423117178431638,
                limb3: 2413399344532747098183124262
            },
            u384 {
                limb0: 77159652550224786219386430216,
                limb1: 5233807302440353836367144908,
                limb2: 64485045574006641363191925507,
                limb3: 4269887894807089990492612650
            },
            u384 {
                limb0: 34492274511748489938477829369,
                limb1: 27111943401072218801461051575,
                limb2: 18710073092160195163679235359,
                limb3: 6631448687074431878130783254
            },
            u384 {
                limb0: 73750585383425246052337378111,
                limb1: 66294021848996742441696471049,
                limb2: 46915996806828507928137551299,
                limb3: 3222388534094990566235858776
            },
            u384 {
                limb0: 65127376050242268170626415185,
                limb1: 24405103951105803450953871586,
                limb2: 5514884953982893298260690692,
                limb3: 6788949099134278272314475419
            },
            u384 {
                limb0: 61112118342314023505275301153,
                limb1: 25939953397348716960121272440,
                limb2: 52303641029328368324789805176,
                limb3: 2155122597157404110294436993
            },
            u384 {
                limb0: 70296100945875310470972906771,
                limb1: 59816352433044208788534277210,
                limb2: 14604615816704680542181818,
                limb3: 6545052355564599604065327224
            },
            u384 {
                limb0: 45181952028093399314484464712,
                limb1: 53840205562809393449142996343,
                limb2: 74738563576760781880337825615,
                limb3: 7108659901525501401056806830
            },
            u384 {
                limb0: 23307710534391095773209525624,
                limb1: 71390571769417206745370600294,
                limb2: 4209179574779910258581290088,
                limb3: 5546271006155430672381461631
            },
            u384 {
                limb0: 28462292202229009631382659861,
                limb1: 22358919703741012426272092247,
                limb2: 18637725724437117556607495757,
                limb3: 5844699959895311746343430194
            },
            u384 {
                limb0: 25204641962539179078906201281,
                limb1: 32169221122015509846169144396,
                limb2: 43188760359479768924606578465,
                limb3: 1717370542600204431968584126
            },
            u384 {
                limb0: 14912866320600872791881886801,
                limb1: 66815301690110224018854386636,
                limb2: 66548700250063757205798836987,
                limb3: 2856877085926294763579896335
            },
            u384 {
                limb0: 62505349608841241979766328096,
                limb1: 73706832083623234409576340716,
                limb2: 14245015795401811287883838173,
                limb3: 4200327416563246622573801540
            },
            u384 {
                limb0: 35656299016425635102126712465,
                limb1: 17885038177568675130291038711,
                limb2: 47899228341741552414453923928,
                limb3: 4933507594157014969072676506
            },
            u384 {
                limb0: 18757264512758726069372593072,
                limb1: 21332218065024951499992475343,
                limb2: 43271749115738409552812223150,
                limb3: 331390303817348477606417400
            },
            u384 {
                limb0: 45013446845320535503727854062,
                limb1: 29201805509683156071833105876,
                limb2: 38150967505240260454236313355,
                limb3: 792906632753900934103593464
            },
            u384 {
                limb0: 57939015147512599307834349633,
                limb1: 68084773571746840620984085903,
                limb2: 61708424565904605480500703424,
                limb3: 5119620390147242919536891884
            },
            u384 {
                limb0: 70506368305113468603384409819,
                limb1: 19429225615253565281904989810,
                limb2: 58762427736663709401299981852,
                limb3: 6622653838395827455483619839
            },
            u384 {
                limb0: 50205909317534819288029670694,
                limb1: 45922896189942511061661438990,
                limb2: 4181208419706788004442930009,
                limb3: 5298712761016655617692097867
            },
            u384 {
                limb0: 37147614164879515275127262704,
                limb1: 71785079485527250677423382385,
                limb2: 58138778441086420558196743487,
                limb3: 3495096269483803850563262925
            },
            u384 {
                limb0: 63241758999954351563947419617,
                limb1: 13271364447461061343002236132,
                limb2: 73116859996847952643012371437,
                limb3: 3011371751362319950452536563
            },
            u384 {
                limb0: 44661412515614400814557876576,
                limb1: 49858286925680440187009394396,
                limb2: 13395837363309657177888722044,
                limb3: 6499877255251134464056030182
            },
            u384 {
                limb0: 64087326394620414988701437117,
                limb1: 2162777267924807436762149083,
                limb2: 6537129300753142709360574522,
                limb3: 761206914223330782120205540
            },
            u384 {
                limb0: 22013449706488532075751690473,
                limb1: 48788525134004001921678338491,
                limb2: 67966543838012421749311653597,
                limb3: 7342758815944447463160011187
            },
            u384 {
                limb0: 13834333828801627238163185771,
                limb1: 58547016195620171196760219797,
                limb2: 35387509956032738651517539017,
                limb3: 1737071188336872402436295151
            },
            u384 {
                limb0: 11493649556871294349148378507,
                limb1: 65103664565496479454885942211,
                limb2: 39293070644831104710007481552,
                limb3: 4089637682340092425205511894
            },
            u384 {
                limb0: 50885166771628217654958285308,
                limb1: 64929936299358295842083531846,
                limb2: 13278671659591187443875958406,
                limb3: 4716372700353782504909024946
            },
            u384 {
                limb0: 59116136156222511726949983604,
                limb1: 73084751189343297355695300815,
                limb2: 30090919104028461165798705419,
                limb3: 3863070984732004448651084347
            },
            u384 {
                limb0: 11499954585655657769725768676,
                limb1: 34443202352008595038238608938,
                limb2: 73462137013787176858618000576,
                limb3: 3783185270301837469140414980
            },
            u384 {
                limb0: 76198693382915459595455544954,
                limb1: 75731883201659331388307845153,
                limb2: 72708646378405259385541501287,
                limb3: 3504143663574219243108095818
            },
            u384 {
                limb0: 34209601786589920540347626407,
                limb1: 51661985061286814558282369072,
                limb2: 26538852232226556936384754320,
                limb3: 7945756431747912253387839413
            },
            u384 {
                limb0: 51842415788793637990667168485,
                limb1: 36532786479315635908125695229,
                limb2: 59349096622812864881764415874,
                limb3: 6654074800595111012351764473
            },
            u384 {
                limb0: 15443603619631936878878827143,
                limb1: 53694364560523385390356994144,
                limb2: 14254465681833821989886104716,
                limb3: 104759346397426443390972828
            },
            u384 {
                limb0: 65893230905811234197623062068,
                limb1: 32582484426548711654062116019,
                limb2: 8232382849818185959624329531,
                limb3: 3481250014714674212509640201
            },
            u384 {
                limb0: 22445102354589100069020740369,
                limb1: 2697066818412675914660594544,
                limb2: 7284339409026165841996102654,
                limb3: 5884063508326351563641573387
            },
            u384 {
                limb0: 66191892249541520025980456069,
                limb1: 47488170108511885542176183046,
                limb2: 56099489067615750776266778215,
                limb3: 855529167842488935024563026
            },
            u384 {
                limb0: 10292313126907065514476942498,
                limb1: 60519046999055105114939248623,
                limb2: 44848591127138903145276484090,
                limb3: 1829859752812693255677183212
            },
            u384 {
                limb0: 55115359513832582829536468219,
                limb1: 23338130200440097602001427475,
                limb2: 74171984408456552602783082143,
                limb3: 4490689482399746122273915161
            },
            u384 {
                limb0: 21897361435348315720476115934,
                limb1: 54843436452655378302279923780,
                limb2: 60996218022460897416635001392,
                limb3: 2548538212327761301685571343
            },
            u384 {
                limb0: 5862651484125861641115310863,
                limb1: 4942837444474654290735812594,
                limb2: 26355623068218716649653476762,
                limb3: 2557471227755029244004475920
            },
            u384 {
                limb0: 20968910073420807018427618098,
                limb1: 5498314059955637953483295091,
                limb2: 73570186118267422118386956933,
                limb3: 3888463202892542858758130964
            },
            u384 {
                limb0: 38984795553409362188999484096,
                limb1: 42833292056974129290111228286,
                limb2: 17302360929253606621511811287,
                limb3: 1052246123295806507979695387
            },
            u384 {
                limb0: 56679852917056611661618659853,
                limb1: 2761964731357129445003334704,
                limb2: 45266579229312890208986520139,
                limb3: 7697384045892515424144221743
            }
        ];

        let (final_check_result) = run_BLS12_381_MP_CHECK_FINALIZE_BLS_3_circuit(
            R_n_minus_1,
            c_n_minus_2,
            w_of_z,
            z,
            c_inv_frob_1_of_z,
            previous_lhs,
            R_n_minus_2_of_z,
            Q
        );
        let final_check: u384 = u384 {
            limb0: 78717607179258458972887966236,
            limb1: 57236149130185677116133520300,
            limb2: 73764605267871304409839067147,
            limb3: 7864078458845373285591249716
        };
        assert_eq!(final_check_result, final_check);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_INIT_BIT_2_circuit_BLS12_381() {
        let yInv_0: u384 = u384 {
            limb0: 51336162621550734210035417468,
            limb1: 415250006649270599173986746,
            limb2: 26447631210891709283945988616,
            limb3: 6568456756269630467207533536
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 13032341109029743902683319123,
            limb1: 10723169215078783342162775617,
            limb2: 40464312170043011027976354467,
            limb3: 6011421598045701294843628209
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 35856694556580458772597834777,
                limb1: 5227748236259293558895161969,
                limb2: 40371665883936326384079209715,
                limb3: 7546120403599398191414383622
            },
            x1: u384 {
                limb0: 23936110202241319314607177628,
                limb1: 6525211420537118205390022661,
                limb2: 14847338785688929289141089698,
                limb3: 4420938905311944424949504318
            },
            y0: u384 {
                limb0: 28884325157281233147803835785,
                limb1: 70657110080690277600027289714,
                limb2: 60912717192387279519498791453,
                limb3: 512136465463816539161171987
            },
            y1: u384 {
                limb0: 50293544524810663939148401830,
                limb1: 29636141903684128710066468966,
                limb2: 44794755821910018669271527790,
                limb3: 1626702908604226054677363589
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 31833852669033812343121332037,
            limb1: 46259262133624975372469588883,
            limb2: 71577571181590998682585121544,
            limb3: 4167500126036868818220947502
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 34502703974235714101804777959,
            limb1: 6100368243607073093469633045,
            limb2: 62909054123967778603720311351,
            limb3: 3077233512658781708805196690
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 56131618349590797133812577950,
                limb1: 60190139614768165901902591780,
                limb2: 76270544567366434724739910360,
                limb3: 4837722625586568549708161960
            },
            x1: u384 {
                limb0: 4381684805713368923546957945,
                limb1: 34192187068398935948806702241,
                limb2: 78026040558534254530218713598,
                limb3: 181486465969759433705366906
            },
            y0: u384 {
                limb0: 57294565870005653636098980424,
                limb1: 49387658135456037512348561677,
                limb2: 14710741208908940160960229557,
                limb3: 6269587628905762387147318190
            },
            y1: u384 {
                limb0: 20923641918028442305843513575,
                limb1: 72307868276534307494619134746,
                limb2: 76528471893256148132234596012,
                limb3: 1262718971162436140946830724
            }
        };

        let R_i: E12D = E12D {
            w0: u384 {
                limb0: 47336653367531199957301972145,
                limb1: 61291575930505501027622839719,
                limb2: 50729104072368725663288033958,
                limb3: 106070686536074596723911954
            },
            w1: u384 {
                limb0: 52043729932450173259081782771,
                limb1: 41052332494448377428781182925,
                limb2: 2662806971947410378838227215,
                limb3: 5056220980837032032660984033
            },
            w2: u384 {
                limb0: 78975990562204539201247923412,
                limb1: 31646397476714325609439022193,
                limb2: 31306463162290929562303238934,
                limb3: 1983777957934648323839074938
            },
            w3: u384 {
                limb0: 58385256243483184668244363556,
                limb1: 72824738489839153320371982595,
                limb2: 22539919648905316993363942403,
                limb3: 5537195487104192141890697711
            },
            w4: u384 {
                limb0: 27578946778082037872073770794,
                limb1: 64611745555418850739679928472,
                limb2: 48041058380393802940384098272,
                limb3: 4503715070683265771833584055
            },
            w5: u384 {
                limb0: 45548803333300261466274904544,
                limb1: 13867684631874476444975421035,
                limb2: 8435023007894805192885533071,
                limb3: 4983146094479858598232091692
            },
            w6: u384 {
                limb0: 75030295576987440955713132144,
                limb1: 40666760678943698193355132222,
                limb2: 69412827049246708586945111913,
                limb3: 7857346657711888775190415690
            },
            w7: u384 {
                limb0: 54999545599785338320913710793,
                limb1: 29875377749027863683097250068,
                limb2: 61003086110821155118076645716,
                limb3: 3363837213855265999152424957
            },
            w8: u384 {
                limb0: 36353717835811608132253367712,
                limb1: 71029935305026358362756676884,
                limb2: 2166945719961538536899494707,
                limb3: 2553323312366244058980574622
            },
            w9: u384 {
                limb0: 50203859435986509537739488377,
                limb1: 17460486651198866068701797447,
                limb2: 18216942149032252515329649468,
                limb3: 4084468929039911627481637007
            },
            w10: u384 {
                limb0: 40921680211496816837995796141,
                limb1: 55524566070724529729063386052,
                limb2: 19668994461041911560720190983,
                limb3: 3950817615537897316803137383
            },
            w11: u384 {
                limb0: 65052239079440445965178730338,
                limb1: 43936096265438404689156429941,
                limb2: 37756613242828581777727028202,
                limb3: 2164574104929802902203660155
            }
        };

        let c0: u384 = u384 {
            limb0: 21318380038371740515795331304,
            limb1: 59116589050921949316839568937,
            limb2: 72091880870723968041394118345,
            limb3: 7300006134313298018652049709
        };

        let z: u384 = u384 {
            limb0: 12359242221772712509777403341,
            limb1: 9497752341269599538706416441,
            limb2: 53543352683464478738680476442,
            limb3: 4879116448495409293645707810
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 60549664597734584543904777167,
            limb1: 75900032797554362866008208618,
            limb2: 38211115498861540698093633932,
            limb3: 3123737747775662138392493174
        };

        let (Q0_result, Q1_result, new_lhs_result, f_i_plus_one_of_z_result) =
            run_BLS12_381_MP_CHECK_INIT_BIT_2_circuit(
            yInv_0, xNegOverY_0, Q0, yInv_1, xNegOverY_1, Q1, R_i, c0, z, c_inv_of_z
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 45760513716931023192877946202,
                limb1: 64256162522778110737977991000,
                limb2: 19018734045312550693327142385,
                limb3: 5850535663316248658973165417
            },
            x1: u384 {
                limb0: 17918285447936073650860466639,
                limb1: 15034762631005276315717301587,
                limb2: 67609192406073666855090319447,
                limb3: 1774147650594488101384512135
            },
            y0: u384 {
                limb0: 71781190824042458959232056759,
                limb1: 41077081086386697139391005029,
                limb2: 65376799912843668672209880045,
                limb3: 7654039458132994330646440006
            },
            y1: u384 {
                limb0: 29919417558763630263594752624,
                limb1: 28420496556233702115724611791,
                limb2: 19438907000411757044026636058,
                limb3: 3907125794454736675087801757
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 15157761987186585303459405402,
                limb1: 52896573218026959093679913854,
                limb2: 14677459565358288774398085085,
                limb3: 7259850653521147546379296758
            },
            x1: u384 {
                limb0: 76506359461212436139541435358,
                limb1: 31067872185687821364782321218,
                limb2: 57610829390156939145283472120,
                limb3: 1610589913749850201424137830
            },
            y0: u384 {
                limb0: 45750694608830920565914416732,
                limb1: 25088223760827148160314207021,
                limb2: 10407917333023478119802986111,
                limb3: 6918046786145633527456934225
            },
            y1: u384 {
                limb0: 34494604027283567569281725432,
                limb1: 42117146839009126395858382484,
                limb2: 78699496826558508143271098587,
                limb3: 4654813243373496998563549910
            }
        };

        let new_lhs: u384 = u384 {
            limb0: 8675349664660619677157633795,
            limb1: 37033730380488255832739315861,
            limb2: 7349163128459769356149809544,
            limb3: 3304924832799462856765761345
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 31050897202384744126874156129,
            limb1: 23227214375446908267829007237,
            limb2: 69582406723348697010063671175,
            limb3: 588789066521800480223094180
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(new_lhs_result, new_lhs);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_INIT_BIT_3_circuit_BLS12_381() {
        let yInv_0: u384 = u384 {
            limb0: 6588581750763890338432528863,
            limb1: 10852851215134462975232470789,
            limb2: 67590751421330085220181371009,
            limb3: 7813985598479276526616658515
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 33961264036539294436390028988,
            limb1: 27136693015833957173281303294,
            limb2: 18756133531082795442502568818,
            limb3: 7840430256137596890637269568
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 19319252615784412641606822664,
                limb1: 23284805224868683376492259444,
                limb2: 47509719868853946287947598536,
                limb3: 1385952268841306759379489001
            },
            x1: u384 {
                limb0: 8046741601328979843133836410,
                limb1: 31267813302639238660009189319,
                limb2: 61741452030070728218634060848,
                limb3: 1680875449088700569387092724
            },
            y0: u384 {
                limb0: 46961843804391069336342813528,
                limb1: 62275679222578331558081622102,
                limb2: 29773980387348351793310076484,
                limb3: 7709370866268377404144266730
            },
            y1: u384 {
                limb0: 10697155972171311518768735767,
                limb1: 70257754131226994877202534817,
                limb2: 2846743634615809631599818881,
                limb3: 1230750268011742024251710910
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 66510711061965790780174368642,
            limb1: 68965220870156961799517279339,
            limb2: 17916951915920026636606577661,
            limb3: 1822443206515963250258675229
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 48384751802951962119972133634,
            limb1: 46848231829192755538299745714,
            limb2: 62407868921130755929696674696,
            limb3: 1047785842546316340659441573
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 28623823273743964797316716517,
                limb1: 16873185131862317592709482877,
                limb2: 5768764366126072667190233248,
                limb3: 1115600207736792868519221073
            },
            x1: u384 {
                limb0: 16812442664324886487477008175,
                limb1: 28104319278739396730958637013,
                limb2: 4496532861172340042785307140,
                limb3: 3589995113616697679157554300
            },
            y0: u384 {
                limb0: 37720553498033187509300777970,
                limb1: 70537345492751585861243337321,
                limb2: 66670402262726434448285231699,
                limb3: 2662479263731234503899912221
            },
            y1: u384 {
                limb0: 50069235125743455280419991826,
                limb1: 35553260988900216901618262734,
                limb2: 15499621990756062308278490770,
                limb3: 4614100057278152596396573720
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 19352010466471441945943617921,
            limb1: 4563043385432648796108789209,
            limb2: 32028305877247802310472255600,
            limb3: 1461657312648996179796773536
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 22368294696324762496329782233,
            limb1: 14899342090724915675553047015,
            limb2: 66076423648838917384187706476,
            limb3: 2671233790946828177072033658
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 56134082668386451980916913067,
                limb1: 29567419115276912466665304199,
                limb2: 31207287604163041599147282174,
                limb3: 5437937172134477325131643029
            },
            x1: u384 {
                limb0: 67091664295942810028750057429,
                limb1: 51619366765989972484123878750,
                limb2: 38477651136590699050911178193,
                limb3: 7101956512340010857467575538
            },
            y0: u384 {
                limb0: 68671496606652248848010915843,
                limb1: 43686265123960025438904554572,
                limb2: 39668589988332851767189928105,
                limb3: 3041921826188413612107073997
            },
            y1: u384 {
                limb0: 69190686047563662364617221315,
                limb1: 34653111544826191401415705457,
                limb2: 66515212948831927345414204097,
                limb3: 3945034108093706113492293848
            }
        };

        let R_i: E12D = E12D {
            w0: u384 {
                limb0: 25783712163137826680504906874,
                limb1: 68282159961494958519792826437,
                limb2: 43461670322721153085920231419,
                limb3: 2668089898871198389463814926
            },
            w1: u384 {
                limb0: 48573522573230812337032271594,
                limb1: 14571142604429433589825088376,
                limb2: 16680101467626089928994022488,
                limb3: 7449386045315488002106567878
            },
            w2: u384 {
                limb0: 67686686237739222530979245840,
                limb1: 35710430109943571067358231691,
                limb2: 10389914978314436205641283680,
                limb3: 6793932919938265869949442410
            },
            w3: u384 {
                limb0: 7912496224405517422611880374,
                limb1: 63706381575547379852220259503,
                limb2: 34243897027058563377541265986,
                limb3: 1941716075694188883036540071
            },
            w4: u384 {
                limb0: 75991527048062882655912723412,
                limb1: 37473892927044625049028990702,
                limb2: 13992269989108209246630070331,
                limb3: 1331743014941487746710554454
            },
            w5: u384 {
                limb0: 67295601899230557049670410969,
                limb1: 42306459066750666931401025667,
                limb2: 62220485623696226310673572949,
                limb3: 2485526403090391124596171838
            },
            w6: u384 {
                limb0: 44988485611821787016694615584,
                limb1: 7841591378181550778785115470,
                limb2: 4756571896037025225940365314,
                limb3: 2518363055865271807996648898
            },
            w7: u384 {
                limb0: 49902825921060219883083431116,
                limb1: 58992752802155291454453792148,
                limb2: 28598357863565276864167283974,
                limb3: 5521128220472213228807327071
            },
            w8: u384 {
                limb0: 20418272069544568405078400426,
                limb1: 32623060143212908357235610572,
                limb2: 68720019178911897349249395613,
                limb3: 5997334541726594718265595531
            },
            w9: u384 {
                limb0: 45627059442364717416240311096,
                limb1: 42659473709550228909733025166,
                limb2: 61822456070095740475827721122,
                limb3: 3219538251892637543719247398
            },
            w10: u384 {
                limb0: 38623233703923200918744882598,
                limb1: 35409451677006119765588419991,
                limb2: 30191554944523775318574429142,
                limb3: 4592778147930750843553911205
            },
            w11: u384 {
                limb0: 11476067448387483119442715608,
                limb1: 50752027877980654101674205742,
                limb2: 26730655936735645385103936766,
                limb3: 6064025861111590431586265671
            }
        };

        let c0: u384 = u384 {
            limb0: 67256848232399553109719176967,
            limb1: 6267892773031441494497947776,
            limb2: 18081287922465040407729851507,
            limb3: 6467128515582558047312043075
        };

        let z: u384 = u384 {
            limb0: 46500575145851741116472778475,
            limb1: 35675542754760213149593111191,
            limb2: 14568965405349755067549036518,
            limb3: 1238335298096787603795583153
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 52450830119926593620181732099,
            limb1: 58935876444817818859925663789,
            limb2: 6343382082723824996091748266,
            limb3: 3932149050729934859157373796
        };

        let (Q0_result, Q1_result, Q2_result, new_lhs_result, f_i_plus_one_of_z_result) =
            run_BLS12_381_MP_CHECK_INIT_BIT_3_circuit(
            yInv_0,
            xNegOverY_0,
            Q0,
            yInv_1,
            xNegOverY_1,
            Q1,
            yInv_2,
            xNegOverY_2,
            Q2,
            R_i,
            c0,
            z,
            c_inv_of_z
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 25064553951934183637782950539,
                limb1: 12949903928746133338051987330,
                limb2: 36643849027823942320337763060,
                limb3: 1847625544161780679495444926
            },
            x1: u384 {
                limb0: 46640670464853188625217802238,
                limb1: 1139225069024842272969678475,
                limb2: 624981577759958370640972536,
                limb3: 819059214307238683322322130
            },
            y0: u384 {
                limb0: 24030021248356463055225968700,
                limb1: 19427677782546028003325835821,
                limb2: 76078225596323172757341553010,
                limb3: 6660965574776223949918453825
            },
            y1: u384 {
                limb0: 33012180414191810441881558208,
                limb1: 70863369616948601944250534282,
                limb2: 27657382445905179922572599985,
                limb3: 6613028574126188649471054619
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 28431449859764006889415192912,
                limb1: 74584442900024162485644804364,
                limb2: 69114515989055324755287748368,
                limb3: 2969833091484648910386531603
            },
            x1: u384 {
                limb0: 52168846676644394967072013585,
                limb1: 27137674113409994304834146171,
                limb2: 12578975736772022651303750734,
                limb3: 5574217121943859512408166399
            },
            y0: u384 {
                limb0: 68621207055948673668031593473,
                limb1: 74424108014120131714667650059,
                limb2: 19828579672565719318339093154,
                limb3: 5140627046328838159656218794
            },
            y1: u384 {
                limb0: 64942642012839124234047099056,
                limb1: 45381411319893304156433602394,
                limb2: 54124459807344378640170839178,
                limb3: 3861669014808707402616756826
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 19292718024175845265272397153,
                limb1: 26501039634160599259387513337,
                limb2: 32226769511184386634841825210,
                limb3: 2241819266071912034354862034
            },
            x1: u384 {
                limb0: 52377581047703393585474417753,
                limb1: 58885164085301358328236486158,
                limb2: 25238801305582783847799170432,
                limb3: 193656456741965690967413584
            },
            y0: u384 {
                limb0: 64295088293676175109223569392,
                limb1: 30668920932961857373972860853,
                limb2: 36801852028559856301197585843,
                limb3: 3149336448467546120628204733
            },
            y1: u384 {
                limb0: 73372060922473590751201571359,
                limb1: 25293444163212365070417165547,
                limb2: 11220919126549970320424363578,
                limb3: 6812300167437153660306784030
            }
        };

        let new_lhs: u384 = u384 {
            limb0: 555668661877701241734149117,
            limb1: 580449877565253931963582668,
            limb2: 45543240931277200603599928304,
            limb3: 6490558197604346354347758240
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 44775623469565365601991884159,
            limb1: 57585909542031470238860903826,
            limb2: 24887495228895446286044883386,
            limb3: 7015433627172203126290712324
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(Q2_result, Q2);
        assert_eq!(new_lhs_result, new_lhs);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit_BLS12_381() {
        let lambda_root_inverse: E12D = E12D {
            w0: u384 {
                limb0: 13120645161765865415767190853,
                limb1: 40766159322681760278328159451,
                limb2: 16758111417507889616179095743,
                limb3: 1558391715693323117779101642
            },
            w1: u384 {
                limb0: 56830575639585519172310443158,
                limb1: 52378502592537334576572528577,
                limb2: 64267716922716155636446919201,
                limb3: 1122452108369469029751561271
            },
            w2: u384 {
                limb0: 37935604555389771274713869520,
                limb1: 46807277768014781448657641882,
                limb2: 66025977598658859467882852180,
                limb3: 2413193836764703080284467396
            },
            w3: u384 {
                limb0: 45436282635023337270090105310,
                limb1: 10673938400891100959737125048,
                limb2: 3105019889911598047111516066,
                limb3: 1454481508582726538374107364
            },
            w4: u384 {
                limb0: 20461436848507539246170521560,
                limb1: 40932492472195346451541621365,
                limb2: 47485994803056403885117610898,
                limb3: 6314709493319733476497316519
            },
            w5: u384 {
                limb0: 57008410263443323572858406995,
                limb1: 65070352009627736398913898077,
                limb2: 6793696660890573843947617133,
                limb3: 6006741486280445790147226263
            },
            w6: u384 {
                limb0: 68714775454320839475153243767,
                limb1: 17379791575416037645854088909,
                limb2: 47603347768522733301609444634,
                limb3: 5770247832607035600287615053
            },
            w7: u384 {
                limb0: 46791835433818909294082825858,
                limb1: 29964990726884597897629773886,
                limb2: 8601810842404442902048383319,
                limb3: 5176682399722833932749468379
            },
            w8: u384 {
                limb0: 3092795234221971523443368645,
                limb1: 42104218432828946535255664026,
                limb2: 9310609193768817775771004631,
                limb3: 6530308137470070525047557167
            },
            w9: u384 {
                limb0: 47812187942035100286502910751,
                limb1: 95090066379491595198047610,
                limb2: 61391559681314512562248729026,
                limb3: 4273337566150817880567320820
            },
            w10: u384 {
                limb0: 29344324883133402018235068619,
                limb1: 55272957702609638042010680401,
                limb2: 18181773961389733749687717410,
                limb3: 4774719335028095185959282251
            },
            w11: u384 {
                limb0: 30204667327219607860223692941,
                limb1: 63748646171159590106610501888,
                limb2: 60335353459210830579717898236,
                limb3: 5705624274624720203645328904
            }
        };

        let z: u384 = u384 {
            limb0: 10607312547755983145242196403,
            limb1: 60677592592097836512588601323,
            limb2: 68061210695635543822155773665,
            limb3: 5925200399606488058352177581
        };

        let scaling_factor: MillerLoopResultScalingFactor = MillerLoopResultScalingFactor {
            w0: u384 {
                limb0: 32376327479959863007414305232,
                limb1: 433334405430461214620615121,
                limb2: 62544492730002836629251344184,
                limb3: 5174991781004531502190574198
            },
            w2: u384 {
                limb0: 569971658494808173899809777,
                limb1: 16274945855014726981994542413,
                limb2: 25028312214019791300223662858,
                limb3: 1055549081424384041431994934
            },
            w4: u384 {
                limb0: 51623164229796577623381348779,
                limb1: 20702547730204580244287574550,
                limb2: 33558003197239064792865424537,
                limb3: 6059772719557727795182189205
            },
            w6: u384 {
                limb0: 53923139303262759264858088111,
                limb1: 16138274778575369006489767428,
                limb2: 62098115849276483801444864527,
                limb3: 1769953204622463214473211262
            },
            w8: u384 {
                limb0: 43964607266841801509740889835,
                limb1: 78317693618355862602054612159,
                limb2: 27282717321753477245594292491,
                limb3: 3942886098733625764954086422
            },
            w10: u384 {
                limb0: 16991124284296588034113759167,
                limb1: 62279762872282935355890650495,
                limb2: 43621141458881726900322163916,
                limb3: 6779597920460191862413640750
            }
        };

        let (c_inv_of_z_result, scaling_factor_of_z_result, c_inv_frob_1_of_z_result) =
            run_BLS12_381_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit(
            lambda_root_inverse, z, scaling_factor
        );
        let c_inv_of_z: u384 = u384 {
            limb0: 40015400218090672060309220267,
            limb1: 57804240421701520783265970444,
            limb2: 55157895183643144829010476252,
            limb3: 6049583740085141255630948188
        };

        let scaling_factor_of_z: u384 = u384 {
            limb0: 78189758206203802687043941461,
            limb1: 34486660913791391215665557303,
            limb2: 67465832834709956266886670786,
            limb3: 6415427947297138952634134496
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 78776459443821174743327083261,
            limb1: 47658468003661216149116949876,
            limb2: 54719564022017901936093684608,
            limb3: 2821777038909730152580375456
        };
        assert_eq!(c_inv_of_z_result, c_inv_of_z);
        assert_eq!(scaling_factor_of_z_result, scaling_factor_of_z);
        assert_eq!(c_inv_frob_1_of_z_result, c_inv_frob_1_of_z);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_PREPARE_PAIRS_2_circuit_BLS12_381() {
        let p_0: G1Point = G1Point {
            x: u384 {
                limb0: 47355647857501980919651343671,
                limb1: 43691656119609808443857940325,
                limb2: 78003530666174369372021017657,
                limb3: 6791474983025536583132272629
            },
            y: u384 {
                limb0: 48509503108813785395171320531,
                limb1: 17478963471488707806395027342,
                limb2: 43362971311464944267671991180,
                limb3: 4598824938039031890199762791
            }
        };

        let p_1: G1Point = G1Point {
            x: u384 {
                limb0: 74686807676832800963320058295,
                limb1: 3550465846114562321773778894,
                limb2: 66127335161285868894881450653,
                limb3: 4075455139655354513251324180
            },
            y: u384 {
                limb0: 70287214926915493517795186652,
                limb1: 19329039838720819857773495059,
                limb2: 21483335126139147659804415786,
                limb3: 5508847689494683090745972780
            }
        };

        let (p_0_result, p_1_result) = run_BLS12_381_MP_CHECK_PREPARE_PAIRS_2_circuit(p_0, p_1);
        let p_0: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 28918067512192784173511065013,
                limb1: 4883953481567583067122711378,
                limb2: 63967037907142041597658367989,
                limb3: 3625488830592547716873001876
            },
            xNegOverY: u384 {
                limb0: 53857847109656066635710212940,
                limb1: 46985565409993207201595296635,
                limb2: 64890648736737169594785173755,
                limb3: 891496301641163409835878284
            }
        };

        let p_1: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 56399845219292146413917967880,
                limb1: 51640262309815692526576087087,
                limb2: 35502609062530299272926911598,
                limb3: 2869580965910347815841098494
            },
            xNegOverY: u384 {
                limb0: 41944575614990207323486889948,
                limb1: 67820252121850345069021729620,
                limb2: 17541971342048559520823852961,
                limb3: 6021559184070528888387668251
            }
        };
        assert_eq!(p_0_result, p_0);
        assert_eq!(p_1_result, p_1);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_PREPARE_PAIRS_3_circuit_BLS12_381() {
        let p_0: G1Point = G1Point {
            x: u384 {
                limb0: 9049298284467066708074923911,
                limb1: 75537045914399608548793837319,
                limb2: 25415579067709923707604377698,
                limb3: 2402759366985981874586641565
            },
            y: u384 {
                limb0: 61964460468729757147507452601,
                limb1: 73702514194375832845357685670,
                limb2: 31371146934048810783191664750,
                limb3: 7512931816214438876009417015
            }
        };

        let p_1: G1Point = G1Point {
            x: u384 {
                limb0: 45669946471918214305569173533,
                limb1: 77353377068918444033582884233,
                limb2: 27330175476705375759905814478,
                limb3: 4483498802259961401606470960
            },
            y: u384 {
                limb0: 2128936876065432234813244827,
                limb1: 73901259430039098090366071268,
                limb2: 16049203479690357641015556929,
                limb3: 2217195155752562919067496716
            }
        };

        let p_2: G1Point = G1Point {
            x: u384 {
                limb0: 23016435387927453058451152306,
                limb1: 11173102281041574147366529922,
                limb2: 39406658630671849263824619282,
                limb3: 2780619473091855644856593334
            },
            y: u384 {
                limb0: 25704364641608073098463886247,
                limb1: 61820325401928077500472329714,
                limb2: 58583730687784708337874422031,
                limb3: 1816756814677715052158529456
            }
        };

        let (p_0_result, p_1_result, p_2_result) = run_BLS12_381_MP_CHECK_PREPARE_PAIRS_3_circuit(
            p_0, p_1, p_2
        );
        let p_0: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 71370867427604975395300314435,
                limb1: 7001477108280766506012390082,
                limb2: 35358334008207490093045702375,
                limb3: 2471641853994331621146244308
            },
            xNegOverY: u384 {
                limb0: 24120048830171483622580943618,
                limb1: 44255229793942820750484177578,
                limb2: 35255298917295126513779928608,
                limb3: 2241667822588812945845875185
            }
        };

        let p_1: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 36315965190230532409091991567,
                limb1: 59787962201466890740410122765,
                limb2: 68955208335980181049103820556,
                limb3: 1054412092926450084764274370
            },
            xNegOverY: u384 {
                limb0: 29788907572484980300382849720,
                limb1: 55761253990600631299403220854,
                limb2: 37333609180841782120669108360,
                limb3: 5058830185281903546774532829
            }
        };

        let p_2: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 17326331726049392008710287610,
                limb1: 14960700921780786509097832736,
                limb2: 27152315477017715281302052116,
                limb3: 7442982744983606664882989375
            },
            xNegOverY: u384 {
                limb0: 25629095258782912832041972253,
                limb1: 61955064785142152953824138262,
                limb2: 48484335943098489510903797855,
                limb3: 2099131969984970119041121822
            }
        };
        assert_eq!(p_0_result, p_0);
        assert_eq!(p_1_result, p_1);
        assert_eq!(p_2_result, p_2);
    }


    #[test]
    fn test_run_BN254_MP_CHECK_BIT0_LOOP_2_circuit_BN254() {
        let yInv_0: u384 = u384 {
            limb0: 45904455082422184508017933152,
            limb1: 42809392610448672033298684481,
            limb2: 1121760338594296470,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 58851415194971721183842825561,
            limb1: 43093784379383056281586394604,
            limb2: 546625929037997222,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 23098056393827424829033455064,
                limb1: 14854793436744012663336315643,
                limb2: 1983068093398607066,
                limb3: 0
            },
            x1: u384 {
                limb0: 27886832245657499061429464201,
                limb1: 68868358318031521496501673344,
                limb2: 2802639614945818070,
                limb3: 0
            },
            y0: u384 {
                limb0: 43644006453602514338627208793,
                limb1: 51539482679065915292567052102,
                limb2: 2272880056679833804,
                limb3: 0
            },
            y1: u384 {
                limb0: 53295256888468577060810182053,
                limb1: 68710112356588354799132405563,
                limb2: 1339794488316981648,
                limb3: 0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 65492976240758050166952298642,
            limb1: 26160799584377947809225279495,
            limb2: 23810020326205781,
            limb3: 0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 34385313053596660350669374455,
            limb1: 7669904517352189407016966841,
            limb2: 915334262870569598,
            limb3: 0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 14519482463764326621371899876,
                limb1: 43381151498497205069989285874,
                limb2: 2810366459018523650,
                limb3: 0
            },
            x1: u384 {
                limb0: 75098438053138995883609305181,
                limb1: 74710938015896287688120542548,
                limb2: 302837407364805961,
                limb3: 0
            },
            y0: u384 {
                limb0: 47202571068388031465205951915,
                limb1: 8984984719415448163791899049,
                limb2: 581133712774113491,
                limb3: 0
            },
            y1: u384 {
                limb0: 6036490884008780429341814006,
                limb1: 49072065657556672693846407787,
                limb2: 1400224662202354960,
                limb3: 0
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 25895392816573013226001751644,
            limb1: 69692259979524089064548888479,
            limb2: 1283232145435683428,
            limb3: 0
        };

        let f_i_of_z: u384 = u384 {
            limb0: 65911832564585192002479699770,
            limb1: 66148457903043253596297342001,
            limb2: 2168907464915275405,
            limb3: 0
        };

        let f_i_plus_one: E12D = E12D {
            w0: u384 {
                limb0: 42737180528569716363769564550,
                limb1: 75418848398490361211580152673,
                limb2: 1034042210130526275,
                limb3: 0
            },
            w1: u384 {
                limb0: 61895659024119489132885956599,
                limb1: 3189578125551420491655326547,
                limb2: 143100608370797933,
                limb3: 0
            },
            w2: u384 {
                limb0: 15794980437723318835459244325,
                limb1: 49227282526148210316988101560,
                limb2: 1100094369593198475,
                limb3: 0
            },
            w3: u384 {
                limb0: 53039994392964625739614782612,
                limb1: 75089047723124581503093743729,
                limb2: 2144590722174322235,
                limb3: 0
            },
            w4: u384 {
                limb0: 9074228703870892464689122879,
                limb1: 12974863833870524236003368544,
                limb2: 1434413841423790284,
                limb3: 0
            },
            w5: u384 {
                limb0: 31426202061001385571049459874,
                limb1: 15713303945190229094581942149,
                limb2: 2730569426338611526,
                limb3: 0
            },
            w6: u384 {
                limb0: 49695262510951843324402342715,
                limb1: 55237320346578370543133352081,
                limb2: 1390804632460152500,
                limb3: 0
            },
            w7: u384 {
                limb0: 47569508826431287883610247512,
                limb1: 63083619142384197715382178991,
                limb2: 2609903230294767923,
                limb3: 0
            },
            w8: u384 {
                limb0: 27508316177276550613275691590,
                limb1: 52411120131127840049092230680,
                limb2: 318006810480851903,
                limb3: 0
            },
            w9: u384 {
                limb0: 27035119202680581644972631414,
                limb1: 33280482250162556250286271438,
                limb2: 2260656361904031596,
                limb3: 0
            },
            w10: u384 {
                limb0: 76121433735435437184720869475,
                limb1: 70637849836752321870577556205,
                limb2: 2120173522187069826,
                limb3: 0
            },
            w11: u384 {
                limb0: 34502846380857958732890516984,
                limb1: 41337035833393065575612633033,
                limb2: 2999705382439962961,
                limb3: 0
            }
        };

        let ci: u384 = u384 {
            limb0: 64032138815186176976330432166,
            limb1: 61373418500185767315409473558,
            limb2: 2143851885860650527,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 57917863429990723593993047887,
            limb1: 25535599381708547340892924584,
            limb2: 283036656247365536,
            limb3: 0
        };

        let (
            Q0_result,
            Q1_result,
            f_i_plus_one_of_z_result,
            lhs_i_plus_one_result,
            ci_plus_one_result
        ) =
            run_BN254_MP_CHECK_BIT0_LOOP_2_circuit(
            yInv_0, xNegOverY_0, Q0, yInv_1, xNegOverY_1, Q1, lhs_i, f_i_of_z, f_i_plus_one, ci, z
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 32757608495295396676201852511,
                limb1: 64401564281755265448765888463,
                limb2: 1779248865150682941,
                limb3: 0
            },
            x1: u384 {
                limb0: 12915503143701275565175611593,
                limb1: 3111945262546913922832120764,
                limb2: 816688557407178980,
                limb3: 0
            },
            y0: u384 {
                limb0: 33530281963663782671614071698,
                limb1: 21243678143375671115756954932,
                limb2: 198950282318148690,
                limb3: 0
            },
            y1: u384 {
                limb0: 37765861125452910121897448909,
                limb1: 2214052014753649311346382986,
                limb2: 3416705928861327567,
                limb3: 0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 37016942874750348033985522175,
                limb1: 4150310253406508778371638787,
                limb2: 2247025100002639692,
                limb3: 0
            },
            x1: u384 {
                limb0: 49793870395055583274684817025,
                limb1: 11410933103668900140066318289,
                limb2: 1823665977429927994,
                limb3: 0
            },
            y0: u384 {
                limb0: 28358207096999160442136923558,
                limb1: 7594305981082800228422992340,
                limb2: 2154203530564254342,
                limb3: 0
            },
            y1: u384 {
                limb0: 71443678344352528094654160990,
                limb1: 9961870105297976429990925077,
                limb2: 2562122223951723531,
                limb3: 0
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 44087691998523345152093192160,
            limb1: 56434647292693206236797825791,
            limb2: 2506343774310786524,
            limb3: 0
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 45754734298098863445331957442,
            limb1: 66597425393998949408232431596,
            limb2: 1511605272628684654,
            limb3: 0
        };

        let ci_plus_one: u384 = u384 {
            limb0: 26734857497673858111646414827,
            limb1: 29836835632387595123930504835,
            limb2: 2544699736218514636,
            limb3: 0
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
        assert_eq!(lhs_i_plus_one_result, lhs_i_plus_one);
        assert_eq!(ci_plus_one_result, ci_plus_one);
    }


    #[test]
    fn test_run_BN254_MP_CHECK_BIT0_LOOP_3_circuit_BN254() {
        let yInv_0: u384 = u384 {
            limb0: 27970996744179409761802775677,
            limb1: 60391875030601110530636255676,
            limb2: 3385329738130157467,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 60409105868185344593543756716,
            limb1: 20927645068145934077182878783,
            limb2: 2697492089942254414,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 31976348081031216527030187003,
                limb1: 7576138688039094553106887256,
                limb2: 1620581743194137482,
                limb3: 0
            },
            x1: u384 {
                limb0: 45569213871171717702115045755,
                limb1: 16750506120877708283097489485,
                limb2: 175461254344384553,
                limb3: 0
            },
            y0: u384 {
                limb0: 46218804560692775341166662790,
                limb1: 20717158003279951749759733061,
                limb2: 84445347632019427,
                limb3: 0
            },
            y1: u384 {
                limb0: 77776330340642982109414052850,
                limb1: 2156219200230598278594557879,
                limb2: 89340742080580359,
                limb3: 0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 46618783255966593664360156366,
            limb1: 38182178610031156106144182914,
            limb2: 1378771870523936328,
            limb3: 0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 67755076603079460979755476203,
            limb1: 14436509892296385586869326680,
            limb2: 2761272299975390862,
            limb3: 0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 59114515782464464297363426551,
                limb1: 28316078793022984461955734929,
                limb2: 2666984567499667990,
                limb3: 0
            },
            x1: u384 {
                limb0: 22517115852356078569441224123,
                limb1: 48292817598587977881469416429,
                limb2: 1801048175972666361,
                limb3: 0
            },
            y0: u384 {
                limb0: 33736304433212520050847181847,
                limb1: 3252940177451315963957603331,
                limb2: 1531797568941280884,
                limb3: 0
            },
            y1: u384 {
                limb0: 2563134058070886383172399223,
                limb1: 22383276006436252285363455751,
                limb2: 2094043810363566490,
                limb3: 0
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 61815749168188416087116462397,
            limb1: 64766864812841874031248133276,
            limb2: 453921824505602704,
            limb3: 0
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 70157786711520347953380254473,
            limb1: 46613296059350113744439847650,
            limb2: 2706850710888284548,
            limb3: 0
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 34425721296362579801955252523,
                limb1: 57118951466117256377085718147,
                limb2: 1735139521808801803,
                limb3: 0
            },
            x1: u384 {
                limb0: 62265174043989469448421800329,
                limb1: 38218139749223759903001291941,
                limb2: 1936208430469564508,
                limb3: 0
            },
            y0: u384 {
                limb0: 6785006414083716126560653219,
                limb1: 7068635531045670043895127785,
                limb2: 1994919135584891932,
                limb3: 0
            },
            y1: u384 {
                limb0: 16482713906979531172953097242,
                limb1: 52499476354585351015995121388,
                limb2: 2653874266693372458,
                limb3: 0
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 62822614487865859990729684869,
            limb1: 23311744417482232966219959797,
            limb2: 1864971012437347004,
            limb3: 0
        };

        let f_i_of_z: u384 = u384 {
            limb0: 24260141228611832289301165709,
            limb1: 29236812391698943878714968242,
            limb2: 2552443476283726195,
            limb3: 0
        };

        let f_i_plus_one: E12D = E12D {
            w0: u384 {
                limb0: 33711885176437257773169410037,
                limb1: 43606267423846917454843559263,
                limb2: 1622439677194583323,
                limb3: 0
            },
            w1: u384 {
                limb0: 21464210568519259449451236667,
                limb1: 18265105538047459110483318823,
                limb2: 3326336890053021124,
                limb3: 0
            },
            w2: u384 {
                limb0: 9472102553316238055030207553,
                limb1: 75336281648900054400484865034,
                limb2: 3182817618559949756,
                limb3: 0
            },
            w3: u384 {
                limb0: 17143757461046157361134566138,
                limb1: 21906557515223499209448960456,
                limb2: 2718989681898186499,
                limb3: 0
            },
            w4: u384 {
                limb0: 18023073391495333781932454041,
                limb1: 23948106176605149970129138594,
                limb2: 3265158945934621221,
                limb3: 0
            },
            w5: u384 {
                limb0: 21733182851417588356383314897,
                limb1: 4319996194758150100124887737,
                limb2: 1347242470452817636,
                limb3: 0
            },
            w6: u384 {
                limb0: 10004891868104810382079160868,
                limb1: 59642340606206240899990252790,
                limb2: 473101997066303984,
                limb3: 0
            },
            w7: u384 {
                limb0: 45482053616623421869246812051,
                limb1: 37927647050474547485157783121,
                limb2: 1571228811205447743,
                limb3: 0
            },
            w8: u384 {
                limb0: 4070483228411864245693740318,
                limb1: 68272727040501225110915673184,
                limb2: 526134058452547028,
                limb3: 0
            },
            w9: u384 {
                limb0: 31747314121681548232927620060,
                limb1: 45716325699526605075711728209,
                limb2: 3165696589857774220,
                limb3: 0
            },
            w10: u384 {
                limb0: 11820650196313720465735111425,
                limb1: 75197480949842702751341412813,
                limb2: 392827575737002526,
                limb3: 0
            },
            w11: u384 {
                limb0: 9384699591256219912009509652,
                limb1: 32972702935408319256957149133,
                limb2: 2749149839390908971,
                limb3: 0
            }
        };

        let ci: u384 = u384 {
            limb0: 68149424508679378297203075566,
            limb1: 33975399915824387332413953359,
            limb2: 2622340559316805189,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 16719138692514152845858150029,
            limb1: 6432333996546943036795377969,
            limb2: 276545720729003200,
            limb3: 0
        };

        let (
            Q0_result,
            Q1_result,
            Q2_result,
            f_i_plus_one_of_z_result,
            lhs_i_plus_one_result,
            ci_plus_one_result
        ) =
            run_BN254_MP_CHECK_BIT0_LOOP_3_circuit(
            yInv_0,
            xNegOverY_0,
            Q0,
            yInv_1,
            xNegOverY_1,
            Q1,
            yInv_2,
            xNegOverY_2,
            Q2,
            lhs_i,
            f_i_of_z,
            f_i_plus_one,
            ci,
            z
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 39556469844535361517107191740,
                limb1: 45064393730012698696819560765,
                limb2: 326317962953023378,
                limb3: 0
            },
            x1: u384 {
                limb0: 79051040921777148970083629759,
                limb1: 69155527681569742667574675066,
                limb2: 680830824824498479,
                limb3: 0
            },
            y0: u384 {
                limb0: 27453701599296264186424666515,
                limb1: 63127837281453698768326663003,
                limb2: 2515041077062565700,
                limb3: 0
            },
            y1: u384 {
                limb0: 64754620420513270250822738653,
                limb1: 14794537498542601670244013340,
                limb2: 224534356809250423,
                limb3: 0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 73523306483791272572663298292,
                limb1: 18586159510551113763417812347,
                limb2: 1078766478111863729,
                limb3: 0
            },
            x1: u384 {
                limb0: 63264587900160522123712385753,
                limb1: 73939318147096112909455278861,
                limb2: 581541744246166115,
                limb3: 0
            },
            y0: u384 {
                limb0: 61729936385874552033885891951,
                limb1: 33648755753828228816501818225,
                limb2: 3398117448922959956,
                limb3: 0
            },
            y1: u384 {
                limb0: 43833536568566448149686138764,
                limb1: 3680020374147124529865402128,
                limb2: 306351755723156397,
                limb3: 0
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 28394444375360966817817863146,
                limb1: 74090535875515716654165121901,
                limb2: 3287997988828602322,
                limb3: 0
            },
            x1: u384 {
                limb0: 56085016645206952720731718056,
                limb1: 15146864674966301258962566820,
                limb2: 3246499400898421450,
                limb3: 0
            },
            y0: u384 {
                limb0: 77194202683909373781831301182,
                limb1: 31708416673078653640837365216,
                limb2: 1163590442022301658,
                limb3: 0
            },
            y1: u384 {
                limb0: 12792793425077482357477998977,
                limb1: 68489899974856607517131277905,
                limb2: 1968424968102856222,
                limb3: 0
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 72816042890474265729085295964,
            limb1: 56032632830151968809990392295,
            limb2: 2605320961456402474,
            limb3: 0
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 31377936469979804494537060466,
            limb1: 49344139964436320962223069071,
            limb2: 134871052054797260,
            limb3: 0
        };

        let ci_plus_one: u384 = u384 {
            limb0: 43220568138813430141174787405,
            limb1: 39622552266897535812196256003,
            limb2: 2742001143606202525,
            limb3: 0
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(Q2_result, Q2);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
        assert_eq!(lhs_i_plus_one_result, lhs_i_plus_one);
        assert_eq!(ci_plus_one_result, ci_plus_one);
    }


    #[test]
    fn test_run_BN254_MP_CHECK_BIT1_LOOP_2_circuit_BN254() {
        let yInv_0: u384 = u384 {
            limb0: 70605388969122605840619758679,
            limb1: 27768852731033222128842541514,
            limb2: 934514221956956122,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 3921418245944927687425380494,
            limb1: 67813620286850788959095407463,
            limb2: 1050854625238337676,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 63868387724619755703515271669,
                limb1: 36963399776968974385652736186,
                limb2: 1619072113244973133,
                limb3: 0
            },
            x1: u384 {
                limb0: 41592685316287303120432407352,
                limb1: 79022700892169318958813892085,
                limb2: 997871910287800917,
                limb3: 0
            },
            y0: u384 {
                limb0: 7248427579396195347018030372,
                limb1: 2578312788889673012368964579,
                limb2: 2452649542515399083,
                limb3: 0
            },
            y1: u384 {
                limb0: 776883269950175885749604235,
                limb1: 46680844342760007404838628981,
                limb2: 3208135102384237753,
                limb3: 0
            }
        };

        let Q_or_Qneg_0: G2Point = G2Point {
            x0: u384 {
                limb0: 46805779946470278621871504266,
                limb1: 4636459820747816876236708785,
                limb2: 3461359370149890782,
                limb3: 0
            },
            x1: u384 {
                limb0: 31733474372447895682008541594,
                limb1: 19569395620567191814185447564,
                limb2: 2692764438242369387,
                limb3: 0
            },
            y0: u384 {
                limb0: 55732259384334677541757861323,
                limb1: 5091369897007753876767911655,
                limb2: 2236132146100676432,
                limb3: 0
            },
            y1: u384 {
                limb0: 18423353126888241046835447528,
                limb1: 74441576000842278553458648656,
                limb2: 170195908775308606,
                limb3: 0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 44203324425676449641115951942,
            limb1: 78346503358733359498560404026,
            limb2: 1492391341598434616,
            limb3: 0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 61111993890478178020162669234,
            limb1: 30610047914171526747464470225,
            limb2: 384926425466365118,
            limb3: 0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 30182649701511067443016793201,
                limb1: 62711654181112712072186909825,
                limb2: 1530878634499503014,
                limb3: 0
            },
            x1: u384 {
                limb0: 23674031265310497877636997085,
                limb1: 56134012141972736817466401171,
                limb2: 2326057075648155135,
                limb3: 0
            },
            y0: u384 {
                limb0: 65077180668563977895628838046,
                limb1: 49650148811710536137981160803,
                limb2: 1155542716921212610,
                limb3: 0
            },
            y1: u384 {
                limb0: 59936320106703523622791254073,
                limb1: 59311836659569795093875097832,
                limb2: 868047839020857479,
                limb3: 0
            }
        };

        let Q_or_Qneg_1: G2Point = G2Point {
            x0: u384 {
                limb0: 11451248979732632699752290649,
                limb1: 61659055120337762904261362754,
                limb2: 1703529750160001659,
                limb3: 0
            },
            x1: u384 {
                limb0: 61044642718857298668260179481,
                limb1: 30063753854647798378902914123,
                limb2: 2066362397636924019,
                limb3: 0
            },
            y0: u384 {
                limb0: 56843349801335264961926007822,
                limb1: 51167235506672695975468297627,
                limb2: 3158438629726577545,
                limb3: 0
            },
            y1: u384 {
                limb0: 51219961517627530589010904606,
                limb1: 6744601431884665774308493558,
                limb2: 1940092667072109619,
                limb3: 0
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 45097228337400805048123634047,
            limb1: 34793321137969367722019210774,
            limb2: 2161487853259170851,
            limb3: 0
        };

        let f_i_of_z: u384 = u384 {
            limb0: 55438613896418324894463112054,
            limb1: 21569565448519877295145143388,
            limb2: 2490225437689442778,
            limb3: 0
        };

        let f_i_plus_one: E12D = E12D {
            w0: u384 {
                limb0: 6373260213004748791134903565,
                limb1: 70467341478988486054740815430,
                limb2: 3387439844922322494,
                limb3: 0
            },
            w1: u384 {
                limb0: 19836189114776755072265333447,
                limb1: 18137260799566833205186073841,
                limb2: 3109652349019213377,
                limb3: 0
            },
            w2: u384 {
                limb0: 21352863297954650371999311188,
                limb1: 60459723974295053734527691819,
                limb2: 807924643441333644,
                limb3: 0
            },
            w3: u384 {
                limb0: 50292826515662347692536244608,
                limb1: 76776465720416580670921530204,
                limb2: 2167540376865057165,
                limb3: 0
            },
            w4: u384 {
                limb0: 26407411952081983439205824979,
                limb1: 8287256160725686738134032317,
                limb2: 741673738249201008,
                limb3: 0
            },
            w5: u384 {
                limb0: 54958490492260617804107875162,
                limb1: 52495276038127754898283368151,
                limb2: 1846760040677520446,
                limb3: 0
            },
            w6: u384 {
                limb0: 43583143821676632764211125532,
                limb1: 6976815487978236021815180223,
                limb2: 1163984242200556098,
                limb3: 0
            },
            w7: u384 {
                limb0: 52105223650783927953043841416,
                limb1: 36601537239017506102041304587,
                limb2: 249972222298068946,
                limb3: 0
            },
            w8: u384 {
                limb0: 28663114038156270142503610578,
                limb1: 39494692246340579116733230829,
                limb2: 2038554080239602066,
                limb3: 0
            },
            w9: u384 {
                limb0: 16127545401377632367714155888,
                limb1: 10379937263162840528394767416,
                limb2: 1328299999837812310,
                limb3: 0
            },
            w10: u384 {
                limb0: 55321066881941561895893360710,
                limb1: 2287272600407630227816452749,
                limb2: 2905464909416375884,
                limb3: 0
            },
            w11: u384 {
                limb0: 18959098346817874123974181751,
                limb1: 24620162586442748086646494154,
                limb2: 63062337158105374,
                limb3: 0
            }
        };

        let c_or_cinv_of_z: u384 = u384 {
            limb0: 7384794193692561174490536246,
            limb1: 66663026042600427526121978722,
            limb2: 523247069204694479,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 40316994666805695645985493194,
            limb1: 32918536128413513857291901774,
            limb2: 556284137698260960,
            limb3: 0
        };

        let ci: u384 = u384 {
            limb0: 19310351630681970556500266992,
            limb1: 11459717187747487754581177669,
            limb2: 879035174114996602,
            limb3: 0
        };

        let (
            Q0_result,
            Q1_result,
            f_i_plus_one_of_z_result,
            lhs_i_plus_one_result,
            ci_plus_one_result
        ) =
            run_BN254_MP_CHECK_BIT1_LOOP_2_circuit(
            yInv_0,
            xNegOverY_0,
            Q0,
            Q_or_Qneg_0,
            yInv_1,
            xNegOverY_1,
            Q1,
            Q_or_Qneg_1,
            lhs_i,
            f_i_of_z,
            f_i_plus_one,
            c_or_cinv_of_z,
            z,
            ci
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 434535361952981813157407672,
                limb1: 4398914301581471370413180387,
                limb2: 676825804443986708,
                limb3: 0
            },
            x1: u384 {
                limb0: 59216903316812928827639015890,
                limb1: 25716305395340741676590556615,
                limb2: 1546998764757255232,
                limb3: 0
            },
            y0: u384 {
                limb0: 28843043011292448381091230607,
                limb1: 63798362630788596715533258756,
                limb2: 719108417036619467,
                limb3: 0
            },
            y1: u384 {
                limb0: 38786227324423008523590701068,
                limb1: 30689950683419745999094123473,
                limb2: 2386731841231196683,
                limb3: 0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 12252166854995374918701673300,
                limb1: 62984774073583978635534533548,
                limb2: 2024497782609757466,
                limb3: 0
            },
            x1: u384 {
                limb0: 31720232061887200998730558721,
                limb1: 57803230314095347105848063009,
                limb2: 295311185717068902,
                limb3: 0
            },
            y0: u384 {
                limb0: 71791548612347608626361847052,
                limb1: 3419812860597192042038532097,
                limb2: 2328151312607669096,
                limb3: 0
            },
            y1: u384 {
                limb0: 59077132091652124577461966202,
                limb1: 45315998175449505506859084804,
                limb2: 490614156236574286,
                limb3: 0
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 7895276005445729390211267761,
            limb1: 49399281334362276056945648025,
            limb2: 1974758364568777414,
            limb3: 0
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 26938381804622932533750014044,
            limb1: 27420998492630630378718947633,
            limb2: 1737060042722876991,
            limb3: 0
        };

        let ci_plus_one: u384 = u384 {
            limb0: 62174436240316316220224635308,
            limb1: 73980005624635691627710344245,
            limb2: 2780204461257729168,
            limb3: 0
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
        assert_eq!(lhs_i_plus_one_result, lhs_i_plus_one);
        assert_eq!(ci_plus_one_result, ci_plus_one);
    }


    #[test]
    fn test_run_BN254_MP_CHECK_BIT1_LOOP_3_circuit_BN254() {
        let yInv_0: u384 = u384 {
            limb0: 32734122786475188413203532118,
            limb1: 38615841936836244773735164788,
            limb2: 616247898672574751,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 1430756383231761687013212156,
            limb1: 21481849534581113525205835676,
            limb2: 2475942381213378214,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 31622808637467355704958261183,
                limb1: 59617236371791664413135580960,
                limb2: 1125510048356549912,
                limb3: 0
            },
            x1: u384 {
                limb0: 60180397924009528471632905418,
                limb1: 55615595319413435119665037829,
                limb2: 916681520452193297,
                limb3: 0
            },
            y0: u384 {
                limb0: 77656812766230337500851655720,
                limb1: 25897006534925091990056673094,
                limb2: 2560517235482880331,
                limb3: 0
            },
            y1: u384 {
                limb0: 39278057470738206836884927807,
                limb1: 23018232917886381522201805277,
                limb2: 175397408503885243,
                limb3: 0
            }
        };

        let Q_or_Qneg_0: G2Point = G2Point {
            x0: u384 {
                limb0: 68425242061890834384785558114,
                limb1: 56938962257310803883933576478,
                limb2: 2259695859569536029,
                limb3: 0
            },
            x1: u384 {
                limb0: 47677395548806103652039374109,
                limb1: 16403476982864539748258294422,
                limb2: 137735885208914139,
                limb3: 0
            },
            y0: u384 {
                limb0: 68710127787605728430423782311,
                limb1: 68298077698674160843107640089,
                limb2: 1579460166023915376,
                limb3: 0
            },
            y1: u384 {
                limb0: 43298098796604622861222201192,
                limb1: 23458746827119122964674987602,
                limb2: 2474518932741553320,
                limb3: 0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 22003543526465619375991967592,
            limb1: 37256932064579886360324775336,
            limb2: 1608024775420958157,
            limb3: 0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 76117744402158888339663490320,
            limb1: 26618665346182137877076851086,
            limb2: 3018284997682024610,
            limb3: 0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 33054037566404995332106300825,
                limb1: 70897931852419226150083391904,
                limb2: 2814279009413368977,
                limb3: 0
            },
            x1: u384 {
                limb0: 72847641972775785169894968531,
                limb1: 13457841357932660955346612623,
                limb2: 215485824496267180,
                limb3: 0
            },
            y0: u384 {
                limb0: 30610357392289436564556872048,
                limb1: 40952045359921762768739599195,
                limb2: 2246522681838346870,
                limb3: 0
            },
            y1: u384 {
                limb0: 42399474693173784311993398450,
                limb1: 42904415170238737560102892575,
                limb2: 515848440370850567,
                limb3: 0
            }
        };

        let Q_or_Qneg_1: G2Point = G2Point {
            x0: u384 {
                limb0: 78573458558600722552152791763,
                limb1: 69689291848719744622298253250,
                limb2: 1778374476317321768,
                limb3: 0
            },
            x1: u384 {
                limb0: 4677975528529937520363444164,
                limb1: 59736220456804337149828364598,
                limb2: 2859644294090689898,
                limb3: 0
            },
            y0: u384 {
                limb0: 58474250441674462491782805750,
                limb1: 27618447739596395273615247326,
                limb2: 1373133510831398745,
                limb3: 0
            },
            y1: u384 {
                limb0: 67951621537723899758313973028,
                limb1: 61235314565569553996188762791,
                limb2: 1153158231018609708,
                limb3: 0
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 2904901898241016921778479024,
            limb1: 2349461055556003990159775675,
            limb2: 2910529618087537879,
            limb3: 0
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 69195446257546160358736024695,
            limb1: 49148187411726485195590959055,
            limb2: 2610703503955171718,
            limb3: 0
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 17777257301609871750245126793,
                limb1: 20280858736985170990688115103,
                limb2: 532976621028913834,
                limb3: 0
            },
            x1: u384 {
                limb0: 21875837649435494681885929285,
                limb1: 40644163816731986038086968744,
                limb2: 199658044052087953,
                limb3: 0
            },
            y0: u384 {
                limb0: 71616042212525791663649027525,
                limb1: 1572789795226311243431610156,
                limb2: 69998775728438781,
                limb3: 0
            },
            y1: u384 {
                limb0: 5921036507309880762113949838,
                limb1: 2919748913893524874951790089,
                limb2: 910063050551793057,
                limb3: 0
            }
        };

        let Q_or_Qneg_2: G2Point = G2Point {
            x0: u384 {
                limb0: 55198809892449412822981461760,
                limb1: 55013033611951868980885936822,
                limb2: 1010464752554597045,
                limb3: 0
            },
            x1: u384 {
                limb0: 41193455868341478598291910205,
                limb1: 12849815974522955861883143647,
                limb2: 3203712735207993582,
                limb3: 0
            },
            y0: u384 {
                limb0: 67513099481243038217819550263,
                limb1: 21173112575791399927188434169,
                limb2: 1813557808139014818,
                limb3: 0
            },
            y1: u384 {
                limb0: 6541706882361741289975239764,
                limb1: 42913102459123369372956569751,
                limb2: 2748008194930246652,
                limb3: 0
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 67483799385750190652978344434,
            limb1: 53428104874804885393353007053,
            limb2: 2460898569310034302,
            limb3: 0
        };

        let f_i_of_z: u384 = u384 {
            limb0: 25088481345435104812294753203,
            limb1: 70310135811311089830803663143,
            limb2: 2250260573682411582,
            limb3: 0
        };

        let f_i_plus_one: E12D = E12D {
            w0: u384 {
                limb0: 2844219767380653250385837648,
                limb1: 18600415137646330917285909197,
                limb2: 3156235923668321458,
                limb3: 0
            },
            w1: u384 {
                limb0: 50210675846930408150502969740,
                limb1: 7963003982605479441203343472,
                limb2: 767222138977708770,
                limb3: 0
            },
            w2: u384 {
                limb0: 71576628857038068011443556202,
                limb1: 25699608917996656873823606367,
                limb2: 258804252956167922,
                limb3: 0
            },
            w3: u384 {
                limb0: 29697970714589908059807164059,
                limb1: 19347314103626596586600103239,
                limb2: 1900253272455414810,
                limb3: 0
            },
            w4: u384 {
                limb0: 62789861689330070018699864411,
                limb1: 13870423455179649741246444884,
                limb2: 2810784739537405193,
                limb3: 0
            },
            w5: u384 {
                limb0: 49098513578529650800428275727,
                limb1: 39429261635599743586870093931,
                limb2: 2689337602157259165,
                limb3: 0
            },
            w6: u384 {
                limb0: 36536060404521445189421849842,
                limb1: 36410926067949143315534690245,
                limb2: 3075260021699581770,
                limb3: 0
            },
            w7: u384 {
                limb0: 63749599928884349400640904883,
                limb1: 22788528140820084088792340053,
                limb2: 2520739003539908655,
                limb3: 0
            },
            w8: u384 {
                limb0: 34997438876635847821899142963,
                limb1: 78249828860258613756052567653,
                limb2: 1379605457197013348,
                limb3: 0
            },
            w9: u384 {
                limb0: 33617217604060724219239038105,
                limb1: 36194261569353773651697623791,
                limb2: 1393290280670975642,
                limb3: 0
            },
            w10: u384 {
                limb0: 30478538780486786939799724692,
                limb1: 8449942826310512614676115794,
                limb2: 1758732389392679760,
                limb3: 0
            },
            w11: u384 {
                limb0: 45541293386256639299791980184,
                limb1: 55402596844231035557102111487,
                limb2: 101178534429736496,
                limb3: 0
            }
        };

        let c_or_cinv_of_z: u384 = u384 {
            limb0: 58998743960201253442804551228,
            limb1: 72146507898670244884339624149,
            limb2: 3436500011552961725,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 71634561918104957049161483509,
            limb1: 61460532045387308280572198435,
            limb2: 265308444066715866,
            limb3: 0
        };

        let ci: u384 = u384 {
            limb0: 27913742052977914165884132488,
            limb1: 15063808288901686344782229094,
            limb2: 1155812101868140862,
            limb3: 0
        };

        let (
            Q0_result,
            Q1_result,
            Q2_result,
            f_i_plus_one_of_z_result,
            lhs_i_plus_one_result,
            ci_plus_one_result
        ) =
            run_BN254_MP_CHECK_BIT1_LOOP_3_circuit(
            yInv_0,
            xNegOverY_0,
            Q0,
            Q_or_Qneg_0,
            yInv_1,
            xNegOverY_1,
            Q1,
            Q_or_Qneg_1,
            yInv_2,
            xNegOverY_2,
            Q2,
            Q_or_Qneg_2,
            lhs_i,
            f_i_of_z,
            f_i_plus_one,
            c_or_cinv_of_z,
            z,
            ci
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 6073025180148763243793262281,
                limb1: 9727226695970267712621138796,
                limb2: 2336213765451990715,
                limb3: 0
            },
            x1: u384 {
                limb0: 46465389592559959644103469133,
                limb1: 64167060851053673899227518522,
                limb2: 363655683735310684,
                limb3: 0
            },
            y0: u384 {
                limb0: 47840751959632034334917919276,
                limb1: 12595237434158322769920164492,
                limb2: 1494381350874671989,
                limb3: 0
            },
            y1: u384 {
                limb0: 61123863757024934164596632366,
                limb1: 43854725990372306033429682037,
                limb2: 433352695676985370,
                limb3: 0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 70608862283064507763053501569,
                limb1: 75690225005961181708189879820,
                limb2: 661301477197679927,
                limb3: 0
            },
            x1: u384 {
                limb0: 41201618776606216173090221155,
                limb1: 2398262440770820032940902589,
                limb2: 2698769990853209487,
                limb3: 0
            },
            y0: u384 {
                limb0: 20575823006133249993773177261,
                limb1: 20079931225351315715002361958,
                limb2: 986894171489966008,
                limb3: 0
            },
            y1: u384 {
                limb0: 62748162050260725528941385849,
                limb1: 19490217669069703474336562416,
                limb2: 1678268662925419793,
                limb3: 0
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 37697179342458507998419792433,
                limb1: 36215581944950889583748910700,
                limb2: 2310999562478007389,
                limb3: 0
            },
            x1: u384 {
                limb0: 31991735721052118101157157851,
                limb1: 78877064133560669711927483087,
                limb2: 2721031058808379958,
                limb3: 0
            },
            y0: u384 {
                limb0: 47709095263314423184683068557,
                limb1: 68341702252561653401430837839,
                limb2: 2868960398995480427,
                limb3: 0
            },
            y1: u384 {
                limb0: 17788871091325524522357998028,
                limb1: 53937747051277144671216627679,
                limb2: 760093254749411510,
                limb3: 0
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 52044844061076388150336336435,
            limb1: 44940368751525978447477378955,
            limb2: 1465788209324436967,
            limb3: 0
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 11892256289116549058563406054,
            limb1: 44778607830060895565092861858,
            limb2: 75851898468949924,
            limb3: 0
        };

        let ci_plus_one: u384 = u384 {
            limb0: 62152610675019321107142650575,
            limb1: 6977606151505008672285529208,
            limb2: 2135307383536667599,
            limb3: 0
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(Q2_result, Q2);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
        assert_eq!(lhs_i_plus_one_result, lhs_i_plus_one);
        assert_eq!(ci_plus_one_result, ci_plus_one);
    }


    #[test]
    fn test_run_BN254_MP_CHECK_FINALIZE_BN_2_circuit_BN254() {
        let original_Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 76515695102675204048755966784,
                limb1: 8789427822349953205127318085,
                limb2: 3132301610469730844,
                limb3: 0
            },
            x1: u384 {
                limb0: 71602378690251733111109565401,
                limb1: 67946286478213044965024488935,
                limb2: 1698416111388999269,
                limb3: 0
            },
            y0: u384 {
                limb0: 13623113014983576143702230338,
                limb1: 29943728693761816743688707340,
                limb2: 310802234888461257,
                limb3: 0
            },
            y1: u384 {
                limb0: 18313535473256873131490064943,
                limb1: 2818288805952498874200333750,
                limb2: 1824649992344979256,
                limb3: 0
            }
        };

        let yInv_0: u384 = u384 {
            limb0: 23166703453848831439327410090,
            limb1: 2247015053382923582978384446,
            limb2: 1890457356230139538,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 11186522069442555795508182452,
            limb1: 78287792939907214424904096934,
            limb2: 178636239482845279,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 57876267232304136644333376937,
                limb1: 1596532614826004406910637192,
                limb2: 1481484438429462378,
                limb3: 0
            },
            x1: u384 {
                limb0: 49853802570553720603796662632,
                limb1: 46041660571639725563896212494,
                limb2: 1729886993466479809,
                limb3: 0
            },
            y0: u384 {
                limb0: 38061835052847029002018967109,
                limb1: 28955487877030942932447938484,
                limb2: 1947472383023093225,
                limb3: 0
            },
            y1: u384 {
                limb0: 65827023944973226188992738544,
                limb1: 64516570764484257677150127758,
                limb2: 3079030277447749789,
                limb3: 0
            }
        };

        let original_Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 58258925447716308170673377289,
                limb1: 72266249388956975361603910610,
                limb2: 1668190572248431663,
                limb3: 0
            },
            x1: u384 {
                limb0: 41640787474881381368052564306,
                limb1: 41249169869768113938957975355,
                limb2: 2170858555725253233,
                limb3: 0
            },
            y0: u384 {
                limb0: 43489193977551903923239976994,
                limb1: 72678855800613320571605968578,
                limb2: 787465114555987084,
                limb3: 0
            },
            y1: u384 {
                limb0: 46983787548009396064142112928,
                limb1: 28317980872447856193879703243,
                limb2: 92433532075689705,
                limb3: 0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 1854093962894720796269145841,
            limb1: 75630402618114943898172738030,
            limb2: 2797472107140641943,
            limb3: 0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 69590518734594701914759819750,
            limb1: 62557667051737795121819434436,
            limb2: 3312278418727692055,
            limb3: 0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 35621952727394351358771056199,
                limb1: 45026736226066222398856662534,
                limb2: 2757497682680950786,
                limb3: 0
            },
            x1: u384 {
                limb0: 73350662928589602370991797058,
                limb1: 77910890398186895065089068656,
                limb2: 1068294048461530392,
                limb3: 0
            },
            y0: u384 {
                limb0: 50614652045130802783218276002,
                limb1: 16234024592451629525026828266,
                limb2: 1344934162676563834,
                limb3: 0
            },
            y1: u384 {
                limb0: 73354982752945501140949182406,
                limb1: 44124543853285614294968809791,
                limb2: 2543535777368888997,
                limb3: 0
            }
        };

        let R_n_minus_2: E12D = E12D {
            w0: u384 {
                limb0: 39773101200371937909888138844,
                limb1: 30595231670372858115443650737,
                limb2: 376338658088269475,
                limb3: 0
            },
            w1: u384 {
                limb0: 2233247364686633141202994927,
                limb1: 7850173846363797919620224227,
                limb2: 3295991699357319628,
                limb3: 0
            },
            w2: u384 {
                limb0: 55148504353553587254564962653,
                limb1: 60121590047493979086002563122,
                limb2: 2163388632186881228,
                limb3: 0
            },
            w3: u384 {
                limb0: 416042324719650857876425693,
                limb1: 1505643101454254541111707335,
                limb2: 994531955167214339,
                limb3: 0
            },
            w4: u384 {
                limb0: 43480751431182610473496355917,
                limb1: 48240451478383261019039507921,
                limb2: 1951918069699577988,
                limb3: 0
            },
            w5: u384 {
                limb0: 22825758685568696302895021558,
                limb1: 9653820561923806317388365183,
                limb2: 1099608123011321543,
                limb3: 0
            },
            w6: u384 {
                limb0: 47278537740323439124848030918,
                limb1: 50068628728056233518528385586,
                limb2: 2651938343791602163,
                limb3: 0
            },
            w7: u384 {
                limb0: 11375329534802032929293707337,
                limb1: 123939641512362347806641420,
                limb2: 1627076795690133810,
                limb3: 0
            },
            w8: u384 {
                limb0: 33003885603163818009279438399,
                limb1: 52941439142942542086389616100,
                limb2: 2414146390976023503,
                limb3: 0
            },
            w9: u384 {
                limb0: 43904441402315001835563469530,
                limb1: 69192444888604997060425720065,
                limb2: 200767105809434064,
                limb3: 0
            },
            w10: u384 {
                limb0: 77725950829400600531907072555,
                limb1: 59208520729957554322383355606,
                limb2: 1646804810565448568,
                limb3: 0
            },
            w11: u384 {
                limb0: 27318068339092155805585928888,
                limb1: 52061173983133184103546514856,
                limb2: 478065214618956488,
                limb3: 0
            }
        };

        let R_n_minus_1: E12D = E12D {
            w0: u384 {
                limb0: 58247514047000673326953733421,
                limb1: 10569797218150830971634955722,
                limb2: 1624692575289578850,
                limb3: 0
            },
            w1: u384 {
                limb0: 64452812713493456098087636609,
                limb1: 65789771145708935948654231793,
                limb2: 3157541014541296533,
                limb3: 0
            },
            w2: u384 {
                limb0: 55094412901496937758124508843,
                limb1: 14441550450632449228311430366,
                limb2: 621897777453879273,
                limb3: 0
            },
            w3: u384 {
                limb0: 61496138862618191686202252115,
                limb1: 2930157926054207264281074558,
                limb2: 929674371450998139,
                limb3: 0
            },
            w4: u384 {
                limb0: 15803628281376891259659412310,
                limb1: 25004076609337883524182780074,
                limb2: 1429972621766780564,
                limb3: 0
            },
            w5: u384 {
                limb0: 78366374191249322583174163911,
                limb1: 37506593588203027909687800814,
                limb2: 168883475285879758,
                limb3: 0
            },
            w6: u384 {
                limb0: 15140773916091266809263008883,
                limb1: 68305651497972452750161514573,
                limb2: 220457174259022779,
                limb3: 0
            },
            w7: u384 {
                limb0: 26297783011955575666134807719,
                limb1: 63330430785875879189319616025,
                limb2: 2015082568192786727,
                limb3: 0
            },
            w8: u384 {
                limb0: 58890903660178833014066078560,
                limb1: 75780051214563697589738443901,
                limb2: 1563530464348284631,
                limb3: 0
            },
            w9: u384 {
                limb0: 63473490859708176821457470244,
                limb1: 33632328342368402773362738968,
                limb2: 1985824979147853666,
                limb3: 0
            },
            w10: u384 {
                limb0: 65152588707662257476314226947,
                limb1: 23274573922924754222521148775,
                limb2: 473149356941961619,
                limb3: 0
            },
            w11: u384 {
                limb0: 52363415686955225535270053232,
                limb1: 35329086454714729214377922398,
                limb2: 3309636006281832765,
                limb3: 0
            }
        };

        let c_n_minus_3: u384 = u384 {
            limb0: 54648798265643634481983517039,
            limb1: 35425261544146600534303046354,
            limb2: 3351839778455144866,
            limb3: 0
        };

        let w_of_z: u384 = u384 {
            limb0: 27932626337397459746134081926,
            limb1: 34459536854010982405788592149,
            limb2: 2949031675982070422,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 75100722321157481286745657675,
            limb1: 53176666183328136800674710709,
            limb2: 1873314039735780746,
            limb3: 0
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 63469362261568189860109481311,
            limb1: 12675454082593576445804105853,
            limb2: 143610774028943748,
            limb3: 0
        };

        let c_frob_2_of_z: u384 = u384 {
            limb0: 48136884541864499493955514860,
            limb1: 34715627796004496673821113191,
            limb2: 582133236019795415,
            limb3: 0
        };

        let c_inv_frob_3_of_z: u384 = u384 {
            limb0: 47940551549985601805073445368,
            limb1: 35646538251239261247168297276,
            limb2: 1710771849864288607,
            limb3: 0
        };

        let previous_lhs: u384 = u384 {
            limb0: 60457780691040955719155991772,
            limb1: 10909330115400199985293083510,
            limb2: 1692257949152095961,
            limb3: 0
        };

        let R_n_minus_3_of_z: u384 = u384 {
            limb0: 51463503968429560985001758516,
            limb1: 76100239050291470512271406715,
            limb2: 119504179848476663,
            limb3: 0
        };

        let Q: Array<u384> = array![
            u384 {
                limb0: 39538336125492398871180292107,
                limb1: 72378294177222663564906132544,
                limb2: 543076755608029291,
                limb3: 0
            },
            u384 {
                limb0: 20622279998058407577092606913,
                limb1: 17000019956307445195151757951,
                limb2: 2821785460392708282,
                limb3: 0
            },
            u384 {
                limb0: 72610939649202879177407828201,
                limb1: 15859762142335958207391212496,
                limb2: 625936839049816711,
                limb3: 0
            },
            u384 {
                limb0: 54028002011768179470718563375,
                limb1: 78164497736277560271584761799,
                limb2: 3079867418077593865,
                limb3: 0
            },
            u384 {
                limb0: 5145003797034348287477472547,
                limb1: 23004869611785338708424432874,
                limb2: 1383306010913820727,
                limb3: 0
            },
            u384 {
                limb0: 56395327029256240576481910029,
                limb1: 55477085090742760778378901734,
                limb2: 802853081124458248,
                limb3: 0
            },
            u384 {
                limb0: 62619805224234996782561324868,
                limb1: 28593168513449141547709249737,
                limb2: 2639163715354909019,
                limb3: 0
            },
            u384 {
                limb0: 24504535570528170370877503433,
                limb1: 56801331562370825563239469027,
                limb2: 2207453188519876490,
                limb3: 0
            },
            u384 {
                limb0: 60939494298144154337380924829,
                limb1: 45548310905203463306664256168,
                limb2: 577967753565131686,
                limb3: 0
            },
            u384 {
                limb0: 50891306258730312298377633994,
                limb1: 36907108364546723236705761927,
                limb2: 2385901941266554729,
                limb3: 0
            },
            u384 {
                limb0: 69559169642389728474220863204,
                limb1: 43678758572344040341995576685,
                limb2: 2710684430259292388,
                limb3: 0
            },
            u384 {
                limb0: 9837057596165635728288483672,
                limb1: 24095229013581028692158732140,
                limb2: 746940769631663984,
                limb3: 0
            },
            u384 {
                limb0: 56199081873274326210458543365,
                limb1: 75067347430544468194587339698,
                limb2: 2392993685011633796,
                limb3: 0
            },
            u384 {
                limb0: 9917012175727560973789426042,
                limb1: 48680023639006438682731312928,
                limb2: 430862462771921967,
                limb3: 0
            },
            u384 {
                limb0: 13360712457909615285158584893,
                limb1: 46003555835430672216589648405,
                limb2: 789523510605727365,
                limb3: 0
            },
            u384 {
                limb0: 45696525051081139037123530701,
                limb1: 16701960642183369175995546947,
                limb2: 2638517147597761731,
                limb3: 0
            },
            u384 {
                limb0: 50626098383967241516060339821,
                limb1: 70433589350681490042378047766,
                limb2: 2516032049879306779,
                limb3: 0
            },
            u384 {
                limb0: 23565139193136454016255627079,
                limb1: 54557587950461613316358502389,
                limb2: 729017398209181176,
                limb3: 0
            },
            u384 {
                limb0: 38366327317858770061531675757,
                limb1: 26952831995428561848025591416,
                limb2: 662554890480784971,
                limb3: 0
            },
            u384 {
                limb0: 56914571454665398548473145359,
                limb1: 78279275921501344736986707982,
                limb2: 1592740564734568401,
                limb3: 0
            },
            u384 {
                limb0: 10360361760042969780406328942,
                limb1: 40800929632893017027277156576,
                limb2: 489686979224035264,
                limb3: 0
            },
            u384 {
                limb0: 36957764448097415134643852348,
                limb1: 35620666002553850463914924175,
                limb2: 649683443184540846,
                limb3: 0
            },
            u384 {
                limb0: 22992963391562842382394762774,
                limb1: 68466113969786803418602716809,
                limb2: 1928306143768698951,
                limb3: 0
            },
            u384 {
                limb0: 39515814869766926725758124491,
                limb1: 39405733073037185795314358855,
                limb2: 415278124502016468,
                limb3: 0
            },
            u384 {
                limb0: 40045436017096087305216247527,
                limb1: 19072488161436698459058802990,
                limb2: 2690199886859842662,
                limb3: 0
            },
            u384 {
                limb0: 37283731539461438294040876529,
                limb1: 647880615405432083589811807,
                limb2: 495742789848418782,
                limb3: 0
            },
            u384 {
                limb0: 69915346460617944663644522573,
                limb1: 28979890201216361489201659621,
                limb2: 1859681187015695852,
                limb3: 0
            },
            u384 {
                limb0: 31737346164896103598597739009,
                limb1: 44511718308746384119772523413,
                limb2: 1671845819287137801,
                limb3: 0
            },
            u384 {
                limb0: 5825785306528226935687873685,
                limb1: 35680749671807472152129028518,
                limb2: 2535768271302425854,
                limb3: 0
            },
            u384 {
                limb0: 78363838989302665816523392567,
                limb1: 48411825622227047920593322655,
                limb2: 593355135521547816,
                limb3: 0
            },
            u384 {
                limb0: 31208267720369294151931332356,
                limb1: 78181373462458384548182486290,
                limb2: 2572545266977491778,
                limb3: 0
            },
            u384 {
                limb0: 59814503413734095368147103486,
                limb1: 47732032767784423939988436134,
                limb2: 1851071198127315553,
                limb3: 0
            },
            u384 {
                limb0: 36206364077278664510748969978,
                limb1: 70761182774839840794482899369,
                limb2: 644626034443431702,
                limb3: 0
            },
            u384 {
                limb0: 48572261018349377195691315676,
                limb1: 31133069532473504054221942561,
                limb2: 2843106687342673459,
                limb3: 0
            },
            u384 {
                limb0: 23707786858539703201169672349,
                limb1: 40193634114222454687519364805,
                limb2: 2350641389979223529,
                limb3: 0
            },
            u384 {
                limb0: 56152152499593787993515060310,
                limb1: 37624867797930191950221921775,
                limb2: 76724431695964775,
                limb3: 0
            },
            u384 {
                limb0: 53384442823922334036260598407,
                limb1: 33001720239659766290880334812,
                limb2: 1418913556219134180,
                limb3: 0
            },
            u384 {
                limb0: 57466104163159058530556190598,
                limb1: 49855152079105017314422154037,
                limb2: 2752759722553792787,
                limb3: 0
            },
            u384 {
                limb0: 76619233989241289600562806407,
                limb1: 77014279065904053305176543056,
                limb2: 2667742003494817263,
                limb3: 0
            },
            u384 {
                limb0: 57155205437830241562675632391,
                limb1: 38065074594952668164735212714,
                limb2: 2417594923661831603,
                limb3: 0
            },
            u384 {
                limb0: 2501273557335717884662652449,
                limb1: 55500984637409607831466014469,
                limb2: 879837438470659306,
                limb3: 0
            },
            u384 {
                limb0: 24853278948010071179419784286,
                limb1: 32718070765074852457160716165,
                limb2: 940284415551250460,
                limb3: 0
            },
            u384 {
                limb0: 4934432018599897586808640733,
                limb1: 41094317769739882213229309833,
                limb2: 2586633682560506000,
                limb3: 0
            },
            u384 {
                limb0: 72265921096225073271030525687,
                limb1: 43280223428508128796238087141,
                limb2: 3116893656975576394,
                limb3: 0
            },
            u384 {
                limb0: 57117528196228585689477881692,
                limb1: 63671913379964328046684888262,
                limb2: 1219155366487325473,
                limb3: 0
            },
            u384 {
                limb0: 15232736669234454278731332247,
                limb1: 22105163975080311519217717336,
                limb2: 1376584424319009869,
                limb3: 0
            },
            u384 {
                limb0: 77081921102631858949365752521,
                limb1: 61098720374347849544704026915,
                limb2: 3250781797494828248,
                limb3: 0
            },
            u384 {
                limb0: 55854924635483007179675412562,
                limb1: 38013943406751334947150057048,
                limb2: 2584792778580634170,
                limb3: 0
            },
            u384 {
                limb0: 63018504641119593953180974283,
                limb1: 22801023474060290608118824765,
                limb2: 2644694935591396397,
                limb3: 0
            },
            u384 {
                limb0: 30082472345626922296731442590,
                limb1: 31258081103002322554055593634,
                limb2: 1591652752415600503,
                limb3: 0
            },
            u384 {
                limb0: 27441744682519875975323449019,
                limb1: 51971460525366986326995100983,
                limb2: 3446490494822404077,
                limb3: 0
            },
            u384 {
                limb0: 16009476576207287279669276754,
                limb1: 21481346931245835267859588251,
                limb2: 2591850645012785154,
                limb3: 0
            },
            u384 {
                limb0: 10875884225909980400960686153,
                limb1: 58699430500508817336957289974,
                limb2: 1103493782239348247,
                limb3: 0
            },
            u384 {
                limb0: 53069714211243737439559334654,
                limb1: 17879549960853822273689888428,
                limb2: 1073769112667182564,
                limb3: 0
            },
            u384 {
                limb0: 32745107861770695754086616740,
                limb1: 37427693583495099272966053739,
                limb2: 3141443547215777683,
                limb3: 0
            },
            u384 {
                limb0: 410515929634231926253481128,
                limb1: 77478068392387527374826812320,
                limb2: 728374660086463002,
                limb3: 0
            },
            u384 {
                limb0: 74080874961659145828912797242,
                limb1: 37688808466314259399665917059,
                limb2: 3000080189254930657,
                limb3: 0
            },
            u384 {
                limb0: 76369138410138386831978236897,
                limb1: 22612933222794424303577785368,
                limb2: 272839273426292967,
                limb3: 0
            }
        ];

        let (final_check_result) = run_BN254_MP_CHECK_FINALIZE_BN_2_circuit(
            original_Q0,
            yInv_0,
            xNegOverY_0,
            Q0,
            original_Q1,
            yInv_1,
            xNegOverY_1,
            Q1,
            R_n_minus_2,
            R_n_minus_1,
            c_n_minus_3,
            w_of_z,
            z,
            c_inv_frob_1_of_z,
            c_frob_2_of_z,
            c_inv_frob_3_of_z,
            previous_lhs,
            R_n_minus_3_of_z,
            Q
        );
        let final_check: u384 = u384 {
            limb0: 4332281523367735651598531760,
            limb1: 12099461003142266974284075941,
            limb2: 168544470423153801,
            limb3: 0
        };
        assert_eq!(final_check_result, final_check);
    }


    #[test]
    fn test_run_BN254_MP_CHECK_FINALIZE_BN_3_circuit_BN254() {
        let original_Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 66065923952928074454213327759,
                limb1: 15882759161495554578483803677,
                limb2: 2915620199412678418,
                limb3: 0
            },
            x1: u384 {
                limb0: 19163106606486024800345091780,
                limb1: 70385247219624604525014569247,
                limb2: 2139282154871526834,
                limb3: 0
            },
            y0: u384 {
                limb0: 531068804258251873187384469,
                limb1: 65496079605978218808101858954,
                limb2: 871196268974053031,
                limb3: 0
            },
            y1: u384 {
                limb0: 23367799990104276871110395519,
                limb1: 22771840660275421621730762126,
                limb2: 2557490494911733231,
                limb3: 0
            }
        };

        let yInv_0: u384 = u384 {
            limb0: 50817155581722961150019346974,
            limb1: 32191975163827509482693838072,
            limb2: 3091908999453694873,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 23945853069618677906900880069,
            limb1: 76259844478779650715252869683,
            limb2: 979143479077535174,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 16933036523089150240942325029,
                limb1: 69348242801574463196943114845,
                limb2: 1641788245341145598,
                limb3: 0
            },
            x1: u384 {
                limb0: 75953528367983810561843998971,
                limb1: 47314954544989719774667292416,
                limb2: 2927888466642967453,
                limb3: 0
            },
            y0: u384 {
                limb0: 76259861803775751354921944229,
                limb1: 66047824445675783605203515753,
                limb2: 1231780166552540361,
                limb3: 0
            },
            y1: u384 {
                limb0: 35726011316286944960001875518,
                limb1: 37081686721132647069894564016,
                limb2: 543948203541280545,
                limb3: 0
            }
        };

        let original_Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 29813919396156585488454179737,
                limb1: 39640686381219987304642822951,
                limb2: 2413260078643946973,
                limb3: 0
            },
            x1: u384 {
                limb0: 36782230673479557189505077480,
                limb1: 57147052976565598575695803016,
                limb2: 2123414761002259671,
                limb3: 0
            },
            y0: u384 {
                limb0: 32291895685966117975376011306,
                limb1: 10181713977736530080329769109,
                limb2: 35264973256236401,
                limb3: 0
            },
            y1: u384 {
                limb0: 40350860803533913420481106003,
                limb1: 16612874977457357355366777417,
                limb2: 3288487236312305282,
                limb3: 0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 26788873401984976600947403669,
            limb1: 71964375465991070413344792649,
            limb2: 1619150423479615016,
            limb3: 0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 6451351954643020206948375212,
            limb1: 51588477067420202387686404438,
            limb2: 741019332098317702,
            limb3: 0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 15572891405710596451261182837,
                limb1: 46452731471039194522059766414,
                limb2: 1504367690205188086,
                limb3: 0
            },
            x1: u384 {
                limb0: 54732438941839576034431344767,
                limb1: 68449192843426580912130060568,
                limb2: 1331078739169779316,
                limb3: 0
            },
            y0: u384 {
                limb0: 71022334349699154152199211609,
                limb1: 76176830754833327664276467878,
                limb2: 2338160552459356364,
                limb3: 0
            },
            y1: u384 {
                limb0: 29460752125103056885189892373,
                limb1: 75470467194626026752603719438,
                limb2: 2397971521163258439,
                limb3: 0
            }
        };

        let original_Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 50519307244078081469217968815,
                limb1: 63618997072871021870514562524,
                limb2: 2690845589937212142,
                limb3: 0
            },
            x1: u384 {
                limb0: 24520140365711840621551322713,
                limb1: 56955547569811554239981794154,
                limb2: 2002709549439821561,
                limb3: 0
            },
            y0: u384 {
                limb0: 64497338090795550820450128811,
                limb1: 35503390707645593984528120438,
                limb2: 2817071957566872376,
                limb3: 0
            },
            y1: u384 {
                limb0: 40249071045301337661011499444,
                limb1: 3802263201606410321712739066,
                limb2: 3039477216753688301,
                limb3: 0
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 73685147707999158636375081206,
            limb1: 60403070413635685203053451863,
            limb2: 3417877362076067551,
            limb3: 0
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 68562371453852990094109718482,
            limb1: 67300430160631988803607158284,
            limb2: 3067884093432158137,
            limb3: 0
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 19739916001986077184418558618,
                limb1: 60074904283843105417343758194,
                limb2: 446754332220173342,
                limb3: 0
            },
            x1: u384 {
                limb0: 30453736951766028243485700073,
                limb1: 76810116248127118197438390380,
                limb2: 3442437098654368499,
                limb3: 0
            },
            y0: u384 {
                limb0: 77388031758512175083317452732,
                limb1: 39367790629768356998603345911,
                limb2: 2469707418060019505,
                limb3: 0
            },
            y1: u384 {
                limb0: 21213153245418479092724608863,
                limb1: 22974159139985900553794009461,
                limb2: 1718314276922763851,
                limb3: 0
            }
        };

        let R_n_minus_2: E12D = E12D {
            w0: u384 {
                limb0: 53023911856056787776895742555,
                limb1: 77777114069399309639574300800,
                limb2: 2201868401406583763,
                limb3: 0
            },
            w1: u384 {
                limb0: 19652314761434753749812219664,
                limb1: 30389894377062064275522035315,
                limb2: 2060203960732163820,
                limb3: 0
            },
            w2: u384 {
                limb0: 75586426115960909028459426345,
                limb1: 46147295048615896284167033575,
                limb2: 2641930473882702923,
                limb3: 0
            },
            w3: u384 {
                limb0: 51790132126839830984914727886,
                limb1: 18721819130210934134810581776,
                limb2: 3079619906596462921,
                limb3: 0
            },
            w4: u384 {
                limb0: 55741530953779778851879418411,
                limb1: 54690438712446250668742954392,
                limb2: 2945536074439390534,
                limb3: 0
            },
            w5: u384 {
                limb0: 12136610886323938858483421264,
                limb1: 78343814715138227301839895393,
                limb2: 1723040456831513904,
                limb3: 0
            },
            w6: u384 {
                limb0: 17304351137299447384400598992,
                limb1: 53902239774132764012656016238,
                limb2: 2747709243572788325,
                limb3: 0
            },
            w7: u384 {
                limb0: 6486433945825208539202045815,
                limb1: 41846185776335495842834651817,
                limb2: 1668438220190909526,
                limb3: 0
            },
            w8: u384 {
                limb0: 9209483177797550297687857769,
                limb1: 56800093033323431422815884338,
                limb2: 2254321125201357442,
                limb3: 0
            },
            w9: u384 {
                limb0: 40436101356884092827290039175,
                limb1: 4407922744904605902700226379,
                limb2: 608485851476009909,
                limb3: 0
            },
            w10: u384 {
                limb0: 36191303803011983827250984419,
                limb1: 44272475022915055199882869725,
                limb2: 3102593439273741493,
                limb3: 0
            },
            w11: u384 {
                limb0: 57304152272388153107807338806,
                limb1: 20160177799506491383844356005,
                limb2: 13906403236451364,
                limb3: 0
            }
        };

        let R_n_minus_1: E12D = E12D {
            w0: u384 {
                limb0: 45818538908177839709135637241,
                limb1: 33568765442952840335747846189,
                limb2: 3229955166307552048,
                limb3: 0
            },
            w1: u384 {
                limb0: 2514295874534295129234860623,
                limb1: 14259589604709115780350789329,
                limb2: 624555404249750114,
                limb3: 0
            },
            w2: u384 {
                limb0: 77511548219992220818677254260,
                limb1: 76358722103579329556317910909,
                limb2: 1726896189910865692,
                limb3: 0
            },
            w3: u384 {
                limb0: 30303157447570908267697396103,
                limb1: 72661341838849407925441746008,
                limb2: 1740894650058794774,
                limb3: 0
            },
            w4: u384 {
                limb0: 54091470917421618006732721751,
                limb1: 69289284083444536757743397499,
                limb2: 613307218922542344,
                limb3: 0
            },
            w5: u384 {
                limb0: 27553169542837390388031783593,
                limb1: 78661425855711162931454328404,
                limb2: 1812662989347210667,
                limb3: 0
            },
            w6: u384 {
                limb0: 23638751655344493221777636195,
                limb1: 56972494209142387254703385698,
                limb2: 1955945305985828113,
                limb3: 0
            },
            w7: u384 {
                limb0: 65233334909713182185390656798,
                limb1: 36494494264149105586626839459,
                limb2: 715371090043333808,
                limb3: 0
            },
            w8: u384 {
                limb0: 74269299958302919334432930581,
                limb1: 60648361019014293894296609949,
                limb2: 148576113392837368,
                limb3: 0
            },
            w9: u384 {
                limb0: 16327468376337349357410016493,
                limb1: 47057103939440827472105044498,
                limb2: 2058846015759873122,
                limb3: 0
            },
            w10: u384 {
                limb0: 55720078161204908314853928519,
                limb1: 19389837001322364617894744119,
                limb2: 204005916038928810,
                limb3: 0
            },
            w11: u384 {
                limb0: 23908241693810703177879067635,
                limb1: 78094848038129380868026955577,
                limb2: 2403846224349474407,
                limb3: 0
            }
        };

        let c_n_minus_3: u384 = u384 {
            limb0: 23808138318977881007021507037,
            limb1: 44107753216901545714716277974,
            limb2: 2728582986236836159,
            limb3: 0
        };

        let w_of_z: u384 = u384 {
            limb0: 72222623364786838198572871164,
            limb1: 53776125276394775079854376793,
            limb2: 2563408750930887799,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 77032769072462189177839091994,
            limb1: 50968749557242331669954531822,
            limb2: 1757765482449803919,
            limb3: 0
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 25252745424521194644427144572,
            limb1: 32345624587646139253376763010,
            limb2: 1382991577465692184,
            limb3: 0
        };

        let c_frob_2_of_z: u384 = u384 {
            limb0: 59771001339276502909923078635,
            limb1: 19091466605364248184515570352,
            limb2: 1039218304997025871,
            limb3: 0
        };

        let c_inv_frob_3_of_z: u384 = u384 {
            limb0: 56060009986710708580612116417,
            limb1: 36684632631694240386976595042,
            limb2: 265743507571636817,
            limb3: 0
        };

        let previous_lhs: u384 = u384 {
            limb0: 76675921611257434175297848989,
            limb1: 41990277612872434944128860781,
            limb2: 1791266718972372742,
            limb3: 0
        };

        let R_n_minus_3_of_z: u384 = u384 {
            limb0: 16109995707773253347583982025,
            limb1: 6264604965108503460820295044,
            limb2: 2074275590803227288,
            limb3: 0
        };

        let Q: Array<u384> = array![
            u384 {
                limb0: 7325752289550721091379248064,
                limb1: 65712335985421788708392102162,
                limb2: 237670756400719702,
                limb3: 0
            },
            u384 {
                limb0: 53373788132966541171493561858,
                limb1: 3133280119030438170955040521,
                limb2: 335658496867800866,
                limb3: 0
            },
            u384 {
                limb0: 60347807592100898461356619825,
                limb1: 53197791314384436735068856949,
                limb2: 1000812061943452478,
                limb3: 0
            },
            u384 {
                limb0: 74249446207702044789227448575,
                limb1: 58745718128592943307792147598,
                limb2: 3444372478347472672,
                limb3: 0
            },
            u384 {
                limb0: 37944020883832562943516734310,
                limb1: 55113192097621221645657625388,
                limb2: 3245559745682738965,
                limb3: 0
            },
            u384 {
                limb0: 72503787746268904017303894324,
                limb1: 25480966126187085250357938988,
                limb2: 1305380151022326782,
                limb3: 0
            },
            u384 {
                limb0: 42280119052185244992070159432,
                limb1: 24435730954541507293564017180,
                limb2: 1658568052732965877,
                limb3: 0
            },
            u384 {
                limb0: 39398366155023859807039255002,
                limb1: 63605685389727592511768890106,
                limb2: 3331544575955677102,
                limb3: 0
            },
            u384 {
                limb0: 66530358825855400605528393265,
                limb1: 16093417741717256403875974906,
                limb2: 1443098103831233685,
                limb3: 0
            },
            u384 {
                limb0: 44567800385550642679563899889,
                limb1: 58728064045893413324436318744,
                limb2: 74801090924327138,
                limb3: 0
            },
            u384 {
                limb0: 74059178692652694320799946647,
                limb1: 57045222820202162282668694872,
                limb2: 1361334150193636738,
                limb3: 0
            },
            u384 {
                limb0: 26134620592915913797724827429,
                limb1: 45143376198364124050589122595,
                limb2: 1133229667249504833,
                limb3: 0
            },
            u384 {
                limb0: 76574674185946085727384361318,
                limb1: 58596680605418433660042549243,
                limb2: 2125198653946047503,
                limb3: 0
            },
            u384 {
                limb0: 62984449383741148955023596598,
                limb1: 11088656828480991330872866738,
                limb2: 2520500048922834858,
                limb3: 0
            },
            u384 {
                limb0: 60557162425210043757344337051,
                limb1: 10893201091059193213645643473,
                limb2: 2908597967238791849,
                limb3: 0
            },
            u384 {
                limb0: 56027745528402833630111414272,
                limb1: 17328757677280912690264006912,
                limb2: 2102973375075300961,
                limb3: 0
            },
            u384 {
                limb0: 38651806883135503573949039739,
                limb1: 42166217039879128525060898628,
                limb2: 1896964049149133607,
                limb3: 0
            },
            u384 {
                limb0: 41944786954337648045869017694,
                limb1: 42445545483455565553421360982,
                limb2: 1322117540658026024,
                limb3: 0
            },
            u384 {
                limb0: 8478714668604153397229578304,
                limb1: 41546091886777243953262837700,
                limb2: 1111272610376590677,
                limb3: 0
            },
            u384 {
                limb0: 29556191118966623068407660805,
                limb1: 36365547947329617981884107348,
                limb2: 1121598439392803775,
                limb3: 0
            },
            u384 {
                limb0: 17894255523827696133929429363,
                limb1: 65605836511669437962813907797,
                limb2: 371779927630795163,
                limb3: 0
            },
            u384 {
                limb0: 67995126656895830833898404186,
                limb1: 2510305332586026846090394506,
                limb2: 1869016256899687969,
                limb3: 0
            },
            u384 {
                limb0: 43789519530941675261788648048,
                limb1: 50448380061564188167017035874,
                limb2: 3241301162794374019,
                limb3: 0
            },
            u384 {
                limb0: 39602861579976946897175694145,
                limb1: 51094815759021956141144311947,
                limb2: 1527716086689882818,
                limb3: 0
            },
            u384 {
                limb0: 16750184629276910442523175953,
                limb1: 54848683286656484238025151258,
                limb2: 2613830513616929347,
                limb3: 0
            },
            u384 {
                limb0: 3689019213319622367894987530,
                limb1: 54226031392934695683365385132,
                limb2: 1292992289164173395,
                limb3: 0
            },
            u384 {
                limb0: 31556261649969598876976693517,
                limb1: 23711158079128878060915048340,
                limb2: 2600798158092392162,
                limb3: 0
            },
            u384 {
                limb0: 66127829984856886641276458484,
                limb1: 53640236317236006751288233728,
                limb2: 2492904227672864376,
                limb3: 0
            },
            u384 {
                limb0: 59865533398518170805240348467,
                limb1: 62629710681295342018427351187,
                limb2: 3178883794560934963,
                limb3: 0
            },
            u384 {
                limb0: 39676897033835903782039505063,
                limb1: 27401812644757148737331412384,
                limb2: 450496169265532079,
                limb3: 0
            },
            u384 {
                limb0: 66446652103167651470498923531,
                limb1: 47946407234769551424935554704,
                limb2: 2830953711354613237,
                limb3: 0
            },
            u384 {
                limb0: 31430053136485270871744813446,
                limb1: 25858222245764710351959174378,
                limb2: 2924375947015982111,
                limb3: 0
            },
            u384 {
                limb0: 78640755201780325721893814925,
                limb1: 18074985447489569851914535397,
                limb2: 2550436321597747544,
                limb3: 0
            },
            u384 {
                limb0: 34214519237190053437742431438,
                limb1: 46417809344748153632398803941,
                limb2: 1752776048960981836,
                limb3: 0
            },
            u384 {
                limb0: 49011800606914760516360473780,
                limb1: 19525763287699131176029388120,
                limb2: 338989750122596346,
                limb3: 0
            },
            u384 {
                limb0: 12218643498001805356461748592,
                limb1: 62106186745474177113940012523,
                limb2: 711476565259015197,
                limb3: 0
            },
            u384 {
                limb0: 28515601770119186098034482616,
                limb1: 8099607534694123031583234712,
                limb2: 402587428619811497,
                limb3: 0
            },
            u384 {
                limb0: 35561059779314423023665735806,
                limb1: 40599746659964672147205820967,
                limb2: 476354553968956741,
                limb3: 0
            },
            u384 {
                limb0: 71395352876893255750875274767,
                limb1: 78652189418338635060705347967,
                limb2: 1119452301844122834,
                limb3: 0
            },
            u384 {
                limb0: 13435743572647055742768775077,
                limb1: 13429312260310293751025163888,
                limb2: 1240169840221291959,
                limb3: 0
            },
            u384 {
                limb0: 39069303825744241023876788297,
                limb1: 13247535031532482552802311196,
                limb2: 1272649500875747761,
                limb3: 0
            },
            u384 {
                limb0: 49520270496539531187641681602,
                limb1: 48857535315983094992182503565,
                limb2: 2111514118074626752,
                limb3: 0
            },
            u384 {
                limb0: 63705500099909868401665043016,
                limb1: 34878053047893529695159387998,
                limb2: 1985866791753172452,
                limb3: 0
            },
            u384 {
                limb0: 68097276310759111007450365976,
                limb1: 47092659150862513455619529189,
                limb2: 1385513195658612147,
                limb3: 0
            },
            u384 {
                limb0: 75051168515484721103142067336,
                limb1: 37951061700687702575594515731,
                limb2: 819207305880817863,
                limb3: 0
            },
            u384 {
                limb0: 76750319395875708731978046683,
                limb1: 58222745579928207268097753474,
                limb2: 2918747433886859421,
                limb3: 0
            },
            u384 {
                limb0: 45625857385944902514458666922,
                limb1: 25819367988051833855222446333,
                limb2: 1292656261447624969,
                limb3: 0
            },
            u384 {
                limb0: 31131528466079143364376512726,
                limb1: 73845967527194007307430242456,
                limb2: 921415077487739359,
                limb3: 0
            },
            u384 {
                limb0: 43229190320195498489467908303,
                limb1: 60816956345395838877652989363,
                limb2: 124128620256119906,
                limb3: 0
            },
            u384 {
                limb0: 39558876473320275797421686999,
                limb1: 23992874219235629822201904672,
                limb2: 1165288601982146919,
                limb3: 0
            },
            u384 {
                limb0: 56666864946633634305269441266,
                limb1: 29868290045521462088191581459,
                limb2: 2070954709856772353,
                limb3: 0
            },
            u384 {
                limb0: 60922816388352606084196819023,
                limb1: 52662475654572076896719999127,
                limb2: 767100883080174509,
                limb3: 0
            },
            u384 {
                limb0: 3509545312504371447920183333,
                limb1: 51104636963280900272195318885,
                limb2: 2982578464670796887,
                limb3: 0
            },
            u384 {
                limb0: 59633673608231629403131304226,
                limb1: 63083924045751506426866664825,
                limb2: 488583026036594088,
                limb3: 0
            },
            u384 {
                limb0: 20499366064744978234855342676,
                limb1: 59171793322588323215960248351,
                limb2: 2573290431690305081,
                limb3: 0
            },
            u384 {
                limb0: 45574844072187026823781865684,
                limb1: 29640805990310106465903675705,
                limb2: 2135502129738112614,
                limb3: 0
            },
            u384 {
                limb0: 8283253674974066890469129462,
                limb1: 72933289929721772305702548019,
                limb2: 395935378243308589,
                limb3: 0
            },
            u384 {
                limb0: 74528043391931758026046224452,
                limb1: 27597439022133617788294211691,
                limb2: 1582115818309159867,
                limb3: 0
            },
            u384 {
                limb0: 16389717846579004346238807531,
                limb1: 27595192399467847342948337669,
                limb2: 450206780478572970,
                limb3: 0
            },
            u384 {
                limb0: 55203273552968352400025560223,
                limb1: 5322099874740231045765108823,
                limb2: 206064199915150187,
                limb3: 0
            },
            u384 {
                limb0: 9117994323468993366797604984,
                limb1: 27181435552212574529368105803,
                limb2: 504346330041244501,
                limb3: 0
            },
            u384 {
                limb0: 13021472815938077376296583389,
                limb1: 58667621587456678701554427304,
                limb2: 2379601879499871283,
                limb3: 0
            },
            u384 {
                limb0: 12687257985753680919877187459,
                limb1: 33780462685511401705291103480,
                limb2: 2130848698318311021,
                limb3: 0
            },
            u384 {
                limb0: 32091163750569126729927549576,
                limb1: 14767093435152743958889101540,
                limb2: 3031297691594681441,
                limb3: 0
            },
            u384 {
                limb0: 2312850012247299494028270867,
                limb1: 69966182707770158190134918112,
                limb2: 2073298800457538212,
                limb3: 0
            },
            u384 {
                limb0: 30806744808508136482032754769,
                limb1: 17017900832827741341074301768,
                limb2: 1283638946813594301,
                limb3: 0
            },
            u384 {
                limb0: 14812484367118804660795345290,
                limb1: 15613833006542909884818824377,
                limb2: 525524538082068038,
                limb3: 0
            },
            u384 {
                limb0: 68345108554377785570321078144,
                limb1: 76527781179726066042274763374,
                limb2: 1445321360445054662,
                limb3: 0
            },
            u384 {
                limb0: 48432843099172859022968820875,
                limb1: 9050397555693225591432922002,
                limb2: 1623243939959117532,
                limb3: 0
            },
            u384 {
                limb0: 48684479055569648058473207843,
                limb1: 53250046722689931684741465651,
                limb2: 1444314330178414246,
                limb3: 0
            },
            u384 {
                limb0: 24194696792237031274610175613,
                limb1: 29576353781092996693196037400,
                limb2: 651901228770725560,
                limb3: 0
            },
            u384 {
                limb0: 33136315734738665630524074785,
                limb1: 45540826605766173148438289610,
                limb2: 1950922040395092220,
                limb3: 0
            },
            u384 {
                limb0: 43964703994449881320715283151,
                limb1: 22883848879323800598260200175,
                limb2: 862839895073913174,
                limb3: 0
            },
            u384 {
                limb0: 10817394603448816425422294899,
                limb1: 30419191303313185485939273920,
                limb2: 2589840218198474951,
                limb3: 0
            },
            u384 {
                limb0: 39215551870359166704186319563,
                limb1: 38958538237257276364966135643,
                limb2: 3274953646347305348,
                limb3: 0
            },
            u384 {
                limb0: 23141746808062260117243206486,
                limb1: 17813930939854560561551291529,
                limb2: 1331256829742725099,
                limb3: 0
            }
        ];

        let (final_check_result) = run_BN254_MP_CHECK_FINALIZE_BN_3_circuit(
            original_Q0,
            yInv_0,
            xNegOverY_0,
            Q0,
            original_Q1,
            yInv_1,
            xNegOverY_1,
            Q1,
            original_Q2,
            yInv_2,
            xNegOverY_2,
            Q2,
            R_n_minus_2,
            R_n_minus_1,
            c_n_minus_3,
            w_of_z,
            z,
            c_inv_frob_1_of_z,
            c_frob_2_of_z,
            c_inv_frob_3_of_z,
            previous_lhs,
            R_n_minus_3_of_z,
            Q
        );
        let final_check: u384 = u384 {
            limb0: 50801170460009427382248693841,
            limb1: 72924171155181406255929528425,
            limb2: 1543434376278168115,
            limb3: 0
        };
        assert_eq!(final_check_result, final_check);
    }


    #[test]
    fn test_run_BN254_MP_CHECK_INIT_BIT_2_circuit_BN254() {
        let yInv_0: u384 = u384 {
            limb0: 30234473638225319530009760858,
            limb1: 74384307462784120735046718239,
            limb2: 1441228053028963263,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 17456219967606268679977829277,
            limb1: 65984530803955978122561797588,
            limb2: 2849126111207940923,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 29721785300803886058609294390,
                limb1: 26284554431805019373869874564,
                limb2: 1552534505033406359,
                limb3: 0
            },
            x1: u384 {
                limb0: 24125107179209079637070854668,
                limb1: 9358385910142293562064784335,
                limb2: 3094691180473231713,
                limb3: 0
            },
            y0: u384 {
                limb0: 68127081121255448055037323873,
                limb1: 36963613409827791021689803501,
                limb2: 607454655022777410,
                limb3: 0
            },
            y1: u384 {
                limb0: 74364493706330226543095633120,
                limb1: 74312728767276618227889214295,
                limb2: 1983952458965918667,
                limb3: 0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 38285654519563132659296532849,
            limb1: 39047142119306285724421940831,
            limb2: 1429829815471556041,
            limb3: 0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 5312586153868579156724620225,
            limb1: 54053822640165900558489616579,
            limb2: 1840781639280580166,
            limb3: 0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 18015871188612021816098643153,
                limb1: 29643480479606962864145632224,
                limb2: 906129076030139846,
                limb3: 0
            },
            x1: u384 {
                limb0: 41810818834458729986647897421,
                limb1: 19724314208447480539003709764,
                limb2: 479194239669756553,
                limb3: 0
            },
            y0: u384 {
                limb0: 39411273298498505703578336863,
                limb1: 17548362112213934842435961756,
                limb2: 1394571152065672527,
                limb3: 0
            },
            y1: u384 {
                limb0: 1056152636602344559905930138,
                limb1: 77160140300154809871818229867,
                limb2: 3048042988790456656,
                limb3: 0
            }
        };

        let R_i: E12D = E12D {
            w0: u384 {
                limb0: 48950184091056392163319088082,
                limb1: 6463554465505433407553616899,
                limb2: 2043497895317506089,
                limb3: 0
            },
            w1: u384 {
                limb0: 38478084703374874537639596153,
                limb1: 32815016693131147500705109325,
                limb2: 994136384458343213,
                limb3: 0
            },
            w2: u384 {
                limb0: 9017551945901160541165188134,
                limb1: 8785592936750571612133998470,
                limb2: 3127727965077690172,
                limb3: 0
            },
            w3: u384 {
                limb0: 38555018789562111634395186800,
                limb1: 24435501704085413701917943635,
                limb2: 1016961802491164904,
                limb3: 0
            },
            w4: u384 {
                limb0: 10872861035061796836021071381,
                limb1: 22932364180853739960192207983,
                limb2: 553330142915580834,
                limb3: 0
            },
            w5: u384 {
                limb0: 59184556126505658868915934798,
                limb1: 10235146068813342402762729530,
                limb2: 2456102566251284071,
                limb3: 0
            },
            w6: u384 {
                limb0: 39634866370069687440400174302,
                limb1: 52928229229714358210403009006,
                limb2: 1633307806216168118,
                limb3: 0
            },
            w7: u384 {
                limb0: 68276007046030082301855238691,
                limb1: 34560877345361549460034186149,
                limb2: 2120242238185029342,
                limb3: 0
            },
            w8: u384 {
                limb0: 68303392430757510286924664108,
                limb1: 34011405204049429992602648006,
                limb2: 1865071348679332442,
                limb3: 0
            },
            w9: u384 {
                limb0: 63487281348680149131386421756,
                limb1: 36452631875620878995636541936,
                limb2: 3180264978061960806,
                limb3: 0
            },
            w10: u384 {
                limb0: 6982368638758900147038848969,
                limb1: 8387341851605878842233477085,
                limb2: 2009203337249553673,
                limb3: 0
            },
            w11: u384 {
                limb0: 41512589782797861685987132624,
                limb1: 68970049872239205242722465599,
                limb2: 3439417701824341835,
                limb3: 0
            }
        };

        let c0: u384 = u384 {
            limb0: 26388415011974121649596946355,
            limb1: 6051397654297148830189372619,
            limb2: 2920233345750075484,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 40402564892663277268394629520,
            limb1: 61499136351352329933995355213,
            limb2: 1619161723874355289,
            limb3: 0
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 64883792658241509173914600526,
            limb1: 11701194222123139740097822756,
            limb2: 474102207956655493,
            limb3: 0
        };

        let previous_lhs: u384 = u384 {
            limb0: 14034961843530626418932150364,
            limb1: 49751227477989704891583947197,
            limb2: 2139605885532402713,
            limb3: 0
        };

        let (Q0_result, Q1_result, new_lhs_result, c_i_result, f_i_plus_one_of_z_result) =
            run_BN254_MP_CHECK_INIT_BIT_2_circuit(
            yInv_0, xNegOverY_0, Q0, yInv_1, xNegOverY_1, Q1, R_i, c0, z, c_inv_of_z, previous_lhs
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 13384320744069878297178470556,
                limb1: 73725473303924488444894495485,
                limb2: 209932012237007324,
                limb3: 0
            },
            x1: u384 {
                limb0: 21837512857870961091434585321,
                limb1: 74979485709268761197271916385,
                limb2: 1438766481009641954,
                limb3: 0
            },
            y0: u384 {
                limb0: 18895807297020507736203134822,
                limb1: 23620911739681991459322296854,
                limb2: 700991498023044194,
                limb3: 0
            },
            y1: u384 {
                limb0: 25058423168264072372226814488,
                limb1: 43455565414997427803476057503,
                limb2: 1056188691689858179,
                limb3: 0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 41817627688033328906377267077,
                limb1: 36028913795806482477582445063,
                limb2: 715042158596260247,
                limb3: 0
            },
            x1: u384 {
                limb0: 18213018763222400127246677474,
                limb1: 39382991030014039102829726280,
                limb2: 447598492905333076,
                limb3: 0
            },
            y0: u384 {
                limb0: 18063261753490915712164433878,
                limb1: 32972263657361875193867917809,
                limb2: 2899891784415139031,
                limb3: 0
            },
            y1: u384 {
                limb0: 29164477435322808786585687932,
                limb1: 46944242117116129152997860192,
                limb2: 516552567574282560,
                limb3: 0
            }
        };

        let new_lhs: u384 = u384 {
            limb0: 35763281436540021312789977847,
            limb1: 19084184022949587469963896490,
            limb2: 3236754758811252634,
            limb3: 0
        };

        let c_i: u384 = u384 {
            limb0: 15164296025777040492108371447,
            limb1: 64578417636670072652808614158,
            limb2: 1288045277525238356,
            limb3: 0
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 46902973165296857149869746010,
            limb1: 14123577316418206824965696524,
            limb2: 1570582732106774750,
            limb3: 0
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(new_lhs_result, new_lhs);
        assert_eq!(c_i_result, c_i);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
    }


    #[test]
    fn test_run_BN254_MP_CHECK_INIT_BIT_3_circuit_BN254() {
        let yInv_0: u384 = u384 {
            limb0: 62092235637613735025731567135,
            limb1: 48079506013028707828201197151,
            limb2: 1139297591294160618,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 31643018694490749755878403266,
            limb1: 23819096624488279136937392331,
            limb2: 2037837161857900072,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 33769858552255441168088865944,
                limb1: 41001261958718026281252691595,
                limb2: 1619238742028650343,
                limb3: 0
            },
            x1: u384 {
                limb0: 25432568039855132509412031761,
                limb1: 65023853641104396217016830974,
                limb2: 3404534744047011985,
                limb3: 0
            },
            y0: u384 {
                limb0: 15729129222775416500413086798,
                limb1: 2468812004693193398373681292,
                limb2: 176279352179769721,
                limb3: 0
            },
            y1: u384 {
                limb0: 60062404240411510169675291848,
                limb1: 21139123540183846552951271878,
                limb2: 2458486727270046083,
                limb3: 0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 78034755754520431113076531816,
            limb1: 21390443745400751298634584764,
            limb2: 2196063173665496630,
            limb3: 0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 36642615358539555374235545670,
            limb1: 59671002186911373967155114512,
            limb2: 1020871898604328868,
            limb3: 0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 69540819765736613075064950449,
                limb1: 55038729236782904695420455624,
                limb2: 48305127733908771,
                limb3: 0
            },
            x1: u384 {
                limb0: 71288605114793263249088807254,
                limb1: 15279050933681144216954598933,
                limb2: 1444500076149710163,
                limb3: 0
            },
            y0: u384 {
                limb0: 34958080940162507156959219285,
                limb1: 52793688793529330162134312526,
                limb2: 230123252682789375,
                limb3: 0
            },
            y1: u384 {
                limb0: 50761894301801390182268329545,
                limb1: 8291749282062842684110000230,
                limb2: 3078569634761421621,
                limb3: 0
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 61300277429627758196588745792,
            limb1: 65371702344221602371746612207,
            limb2: 1201715663805072000,
            limb3: 0
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 51324685172287042751258424223,
            limb1: 21947049935458474193614297183,
            limb2: 1590499684733687622,
            limb3: 0
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 61006692264021327587583740886,
                limb1: 5452840047198647813936378193,
                limb2: 905495562604064068,
                limb3: 0
            },
            x1: u384 {
                limb0: 5623048473775077427032016316,
                limb1: 16474942938119103132672044561,
                limb2: 1323758991818633581,
                limb3: 0
            },
            y0: u384 {
                limb0: 38264501596283009616878207336,
                limb1: 12802603797697691894285356421,
                limb2: 2525430768964335568,
                limb3: 0
            },
            y1: u384 {
                limb0: 16037613092941217002962625503,
                limb1: 46241588865978471759099665735,
                limb2: 2110662394902654450,
                limb3: 0
            }
        };

        let R_i: E12D = E12D {
            w0: u384 {
                limb0: 37683213711367430600081249279,
                limb1: 75878582990126893923558857619,
                limb2: 2077671149597553790,
                limb3: 0
            },
            w1: u384 {
                limb0: 71236166552923914896542734683,
                limb1: 77832604571724359931940198877,
                limb2: 388899464835588695,
                limb3: 0
            },
            w2: u384 {
                limb0: 32386047933525779174386284223,
                limb1: 53787818865071521340915405568,
                limb2: 241493313403685979,
                limb3: 0
            },
            w3: u384 {
                limb0: 51284813869307326018676770476,
                limb1: 26120793132515949475084866669,
                limb2: 2573151152668510883,
                limb3: 0
            },
            w4: u384 {
                limb0: 69188343332762451578483774268,
                limb1: 6457252387363983399172627918,
                limb2: 3060370677160635067,
                limb3: 0
            },
            w5: u384 {
                limb0: 27715658260901228010582353528,
                limb1: 51978009774839646770852223176,
                limb2: 3053559460821701933,
                limb3: 0
            },
            w6: u384 {
                limb0: 47144022747530892273128004548,
                limb1: 6712131780807089477576435038,
                limb2: 2577573093006426671,
                limb3: 0
            },
            w7: u384 {
                limb0: 62721922625347861428420087324,
                limb1: 10124864822119198723182889495,
                limb2: 3241235298013462423,
                limb3: 0
            },
            w8: u384 {
                limb0: 58531759711808383649221879720,
                limb1: 72291577403896224041541182895,
                limb2: 430975742503925451,
                limb3: 0
            },
            w9: u384 {
                limb0: 33545708500132510870861373929,
                limb1: 1444372227779776890998115634,
                limb2: 1424393362308543337,
                limb3: 0
            },
            w10: u384 {
                limb0: 16970091156379210610406438382,
                limb1: 60701148816258494319717762394,
                limb2: 885467854449426510,
                limb3: 0
            },
            w11: u384 {
                limb0: 61074987645848044802490522730,
                limb1: 58521406751332346541577759379,
                limb2: 2428198578208439955,
                limb3: 0
            }
        };

        let c0: u384 = u384 {
            limb0: 26681222254814605844287181249,
            limb1: 48965497803442129444833806021,
            limb2: 2754313075234205212,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 12854548382922917635362436769,
            limb1: 54892886997441064982891195332,
            limb2: 2881106942127155841,
            limb3: 0
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 13115363849027183435967200570,
            limb1: 3461671064677420322483303155,
            limb2: 1680034501783062454,
            limb3: 0
        };

        let previous_lhs: u384 = u384 {
            limb0: 18819081064573781521648197317,
            limb1: 48376353285332691747329209713,
            limb2: 3469791796332136813,
            limb3: 0
        };

        let (
            Q0_result, Q1_result, Q2_result, new_lhs_result, c_i_result, f_i_plus_one_of_z_result
        ) =
            run_BN254_MP_CHECK_INIT_BIT_3_circuit(
            yInv_0,
            xNegOverY_0,
            Q0,
            yInv_1,
            xNegOverY_1,
            Q1,
            yInv_2,
            xNegOverY_2,
            Q2,
            R_i,
            c0,
            z,
            c_inv_of_z,
            previous_lhs
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 114858644870650597231200147,
                limb1: 18267584061566108831833788781,
                limb2: 2813839632915688647,
                limb3: 0
            },
            x1: u384 {
                limb0: 21000744876217345411380989839,
                limb1: 17409271236355688983755019315,
                limb2: 2838862442373317344,
                limb3: 0
            },
            y0: u384 {
                limb0: 2965287108278113353927554802,
                limb1: 27632061619934763414419065984,
                limb2: 491792928364395528,
                limb3: 0
            },
            y1: u384 {
                limb0: 23213129055946261837224660914,
                limb1: 2669651130609949595526032212,
                limb2: 574053958570116093,
                limb3: 0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 44699511033900221245357284853,
                limb1: 73860392616477063665188413651,
                limb2: 1079505370343957676,
                limb3: 0
            },
            x1: u384 {
                limb0: 3985740842997349724119586740,
                limb1: 77185057960430424093070359606,
                limb2: 673030160716745877,
                limb3: 0
            },
            y0: u384 {
                limb0: 24652278188506567341959519109,
                limb1: 13385606199308430123912278263,
                limb2: 2180499106893702233,
                limb3: 0
            },
            y1: u384 {
                limb0: 1047452106883285053489777120,
                limb1: 53706348299633935578325906583,
                limb2: 272956823010348300,
                limb3: 0
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 77080257543473396202347334540,
                limb1: 69776519454874455612777674903,
                limb2: 2295455060528427657,
                limb3: 0
            },
            x1: u384 {
                limb0: 61135438425628028842479370137,
                limb1: 13572696621205425251438865229,
                limb2: 500931024915100743,
                limb3: 0
            },
            y0: u384 {
                limb0: 10004684074309091880716331079,
                limb1: 6874764866333197357450579239,
                limb2: 252697978114749348,
                limb3: 0
            },
            y1: u384 {
                limb0: 75725673656714922867651446672,
                limb1: 28532552437587813595131482540,
                limb2: 1572205008641256146,
                limb3: 0
            }
        };

        let new_lhs: u384 = u384 {
            limb0: 36232203672429545643899144412,
            limb1: 33978739666853465087499357989,
            limb2: 2489689600560002150,
            limb3: 0
        };

        let c_i: u384 = u384 {
            limb0: 40426779447366812394780880320,
            limb1: 35465779397411600813918612349,
            limb2: 1789470518153613385,
            limb3: 0
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 70353999240075856332259510833,
            limb1: 34954325272728568703760868365,
            limb2: 346209706157690403,
            limb3: 0
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(Q2_result, Q2);
        assert_eq!(new_lhs_result, new_lhs);
        assert_eq!(c_i_result, c_i);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
    }


    #[test]
    fn test_run_BN254_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit_BN254() {
        let lambda_root: E12D = E12D {
            w0: u384 {
                limb0: 32348530858024728078868829639,
                limb1: 3592744325410968664056691049,
                limb2: 171610653646008893,
                limb3: 0
            },
            w1: u384 {
                limb0: 39029743339205774992390936133,
                limb1: 18602774827232231696440627815,
                limb2: 2478996165750910234,
                limb3: 0
            },
            w2: u384 {
                limb0: 35941361193217777779108143374,
                limb1: 75217693713392782649365011547,
                limb2: 3211965469867011671,
                limb3: 0
            },
            w3: u384 {
                limb0: 2592051239993596463807916599,
                limb1: 17213877892003692861889854415,
                limb2: 2050797652534201807,
                limb3: 0
            },
            w4: u384 {
                limb0: 67775746894387172603709592928,
                limb1: 77717100777266378177987018266,
                limb2: 1694033489303223788,
                limb3: 0
            },
            w5: u384 {
                limb0: 77472666712588545743124569409,
                limb1: 4797272463723103367575330464,
                limb2: 1272278604523010765,
                limb3: 0
            },
            w6: u384 {
                limb0: 9678490069161370079171398443,
                limb1: 65299145282709910585301163759,
                limb2: 422769034650999704,
                limb3: 0
            },
            w7: u384 {
                limb0: 50841065774546846668552877642,
                limb1: 76937938853888598110497001166,
                limb2: 233252209284329129,
                limb3: 0
            },
            w8: u384 {
                limb0: 19297515645726961054274772699,
                limb1: 62350828911867254326094421487,
                limb2: 946343686152138415,
                limb3: 0
            },
            w9: u384 {
                limb0: 26031169352814878388446845977,
                limb1: 62482795222269126185267823854,
                limb2: 2748480190828589993,
                limb3: 0
            },
            w10: u384 {
                limb0: 68009940043291454900803327139,
                limb1: 78239974089360065623061251225,
                limb2: 2491304091364829717,
                limb3: 0
            },
            w11: u384 {
                limb0: 13825086332014962754447925148,
                limb1: 68647074228414932436004381198,
                limb2: 607835110554306353,
                limb3: 0
            }
        };

        let z: u384 = u384 {
            limb0: 62589033474817270750032814819,
            limb1: 46653735021394180396859958843,
            limb2: 72777410472488921,
            limb3: 0
        };

        let scaling_factor: MillerLoopResultScalingFactor = MillerLoopResultScalingFactor {
            w0: u384 {
                limb0: 4151478183251406727761585710,
                limb1: 33351931671505497125534515053,
                limb2: 524114904340073100,
                limb3: 0
            },
            w2: u384 {
                limb0: 37732092629447400187236707193,
                limb1: 28683682660648908599479904790,
                limb2: 2737801276969684999,
                limb3: 0
            },
            w4: u384 {
                limb0: 39918213878711579092428977836,
                limb1: 48733784934022290576311286791,
                limb2: 3353816348178905230,
                limb3: 0
            },
            w6: u384 {
                limb0: 68689304087490863220555616357,
                limb1: 23897616927875537737037504310,
                limb2: 2966885224459421254,
                limb3: 0
            },
            w8: u384 {
                limb0: 4819084699530860024356825995,
                limb1: 67129906945978494766775755198,
                limb2: 1965840089683616625,
                limb3: 0
            },
            w10: u384 {
                limb0: 48194287442401190975179239260,
                limb1: 9997927726397883000550929599,
                limb2: 2879156264634905294,
                limb3: 0
            }
        };

        let c_inv: E12D = E12D {
            w0: u384 {
                limb0: 43445272631878126506295251193,
                limb1: 30178355159993152693592892746,
                limb2: 2754983660777106602,
                limb3: 0
            },
            w1: u384 {
                limb0: 67565201436882084061382168800,
                limb1: 69539050526138233778943509686,
                limb2: 2542584972831276507,
                limb3: 0
            },
            w2: u384 {
                limb0: 17035882260747629317826606829,
                limb1: 70361819709461090037174702146,
                limb2: 1908378266947718676,
                limb3: 0
            },
            w3: u384 {
                limb0: 35929884725506956604622518500,
                limb1: 57805858740019930776271531625,
                limb2: 1441374862984055727,
                limb3: 0
            },
            w4: u384 {
                limb0: 52695274180530494441361795060,
                limb1: 75551383096477959168832075052,
                limb2: 3167402939661899820,
                limb3: 0
            },
            w5: u384 {
                limb0: 5318848934111001807298281301,
                limb1: 6763261652414254970859848172,
                limb2: 1991678899374648705,
                limb3: 0
            },
            w6: u384 {
                limb0: 58533449540510171611906208325,
                limb1: 10308808319958257447821756622,
                limb2: 276613436898430979,
                limb3: 0
            },
            w7: u384 {
                limb0: 44493459691695508293649863496,
                limb1: 53083920220020036007065451370,
                limb2: 1894520442841631905,
                limb3: 0
            },
            w8: u384 {
                limb0: 76724443588163983100324835013,
                limb1: 24754752271414615725266048174,
                limb2: 477773275913878545,
                limb3: 0
            },
            w9: u384 {
                limb0: 66977382272283866770139525938,
                limb1: 9102152327114214361285487105,
                limb2: 1284669144355708780,
                limb3: 0
            },
            w10: u384 {
                limb0: 48612283253047197369389837369,
                limb1: 44109468313663035901026715162,
                limb2: 2808493327013941809,
                limb3: 0
            },
            w11: u384 {
                limb0: 65716654330084571604934227912,
                limb1: 2293907638690150291935286246,
                limb2: 1260237224686894967,
                limb3: 0
            }
        };

        let c_0: u384 = u384 {
            limb0: 24480288611119754958680101130,
            limb1: 27810940922274926112453288455,
            limb2: 836585472381691424,
            limb3: 0
        };

        let (
            c_of_z_result,
            scaling_factor_of_z_result,
            c_inv_of_z_result,
            lhs_result,
            c_inv_frob_1_of_z_result,
            c_frob_2_of_z_result,
            c_inv_frob_3_of_z_result
        ) =
            run_BN254_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit(
            lambda_root, z, scaling_factor, c_inv, c_0
        );
        let c_of_z: u384 = u384 {
            limb0: 55294240156276719054463270236,
            limb1: 667546056183488857237683399,
            limb2: 895977177379364823,
            limb3: 0
        };

        let scaling_factor_of_z: u384 = u384 {
            limb0: 23419728984145634651914716790,
            limb1: 73376596255697195864875614587,
            limb2: 696294771534627827,
            limb3: 0
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 51425125390013603783211302120,
            limb1: 28150569468004767968249357925,
            limb2: 371015650984907105,
            limb3: 0
        };

        let lhs: u384 = u384 {
            limb0: 17012615046585564243934612914,
            limb1: 62843028762366946447931336406,
            limb2: 613422644348128316,
            limb3: 0
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 75528119862349441109365690401,
            limb1: 70251829204840027895545984361,
            limb2: 2796096591874704940,
            limb3: 0
        };

        let c_frob_2_of_z: u384 = u384 {
            limb0: 47420838089935972142893710267,
            limb1: 39947934131573152509554539939,
            limb2: 1739337804948088113,
            limb3: 0
        };

        let c_inv_frob_3_of_z: u384 = u384 {
            limb0: 12894054534322000608060639685,
            limb1: 8060154595841384276242846687,
            limb2: 2072675743511113239,
            limb3: 0
        };
        assert_eq!(c_of_z_result, c_of_z);
        assert_eq!(scaling_factor_of_z_result, scaling_factor_of_z);
        assert_eq!(c_inv_of_z_result, c_inv_of_z);
        assert_eq!(lhs_result, lhs);
        assert_eq!(c_inv_frob_1_of_z_result, c_inv_frob_1_of_z);
        assert_eq!(c_frob_2_of_z_result, c_frob_2_of_z);
        assert_eq!(c_inv_frob_3_of_z_result, c_inv_frob_3_of_z);
    }


    #[test]
    fn test_run_BN254_MP_CHECK_PREPARE_PAIRS_2_circuit_BN254() {
        let p_0: G1Point = G1Point {
            x: u384 {
                limb0: 70556734050842565848291241581,
                limb1: 58050264873474175134803095378,
                limb2: 925931021986593588,
                limb3: 0
            },
            y: u384 {
                limb0: 14038949321681701724284220804,
                limb1: 79086964293215410597809039987,
                limb2: 692840025956076736,
                limb3: 0
            }
        };

        let Qy0_0: u384 = u384 {
            limb0: 35164172637413633709427913299,
            limb1: 32788174005925879893088924887,
            limb2: 1147070028174346510,
            limb3: 0
        };

        let Qy1_0: u384 = u384 {
            limb0: 14465280333466500616340334339,
            limb1: 56366146424070553874245182265,
            limb2: 1162009387839751450,
            limb3: 0
        };

        let p_1: G1Point = G1Point {
            x: u384 {
                limb0: 73008541784748497387092230171,
                limb1: 51094529715297593352353656666,
                limb2: 1471959629879265301,
                limb3: 0
            },
            y: u384 {
                limb0: 12515826679991286710914193096,
                limb1: 37258088270956290443497093944,
                limb2: 2947275057470926218,
                limb3: 0
            }
        };

        let Qy0_1: u384 = u384 {
            limb0: 12197621641096932281273716365,
            limb1: 23460145356398347127480075226,
            limb2: 2832970238638287316,
            limb3: 0
        };

        let Qy1_1: u384 = u384 {
            limb0: 14515889760088572654607931857,
            limb1: 65828950749331816210515352210,
            limb2: 168339560509673848,
            limb3: 0
        };

        let (p_0_result, p_1_result) = run_BN254_MP_CHECK_PREPARE_PAIRS_2_circuit(
            p_0, Qy0_0, Qy1_0, p_1, Qy0_1, Qy1_1
        );
        let p_0: BNProcessedPair = BNProcessedPair {
            yInv: u384 {
                limb0: 9259161435090404268079345020,
                limb1: 65687451014403256091598314103,
                limb2: 2325223505750453868,
                limb3: 0
            },
            xNegOverY: u384 {
                limb0: 54697452236070132465655645274,
                limb1: 50746066496101437777605617471,
                limb2: 1148622336019555805,
                limb3: 0
            },
            QyNeg0: u384 {
                limb0: 76387996039240115060894665460,
                limb1: 24254111076697359568790844857,
                limb2: 2339928238628624155,
                limb3: 0
            },
            QyNeg1: u384 {
                limb0: 17858725828922910560438294084,
                limb1: 676138658552685587634587480,
                limb2: 2324988878963219215,
                limb3: 0
            }
        };

        let p_1: BNProcessedPair = BNProcessedPair {
            yInv: u384 {
                limb0: 41362225379810841058801015822,
                limb1: 54474187635863045878091692174,
                limb2: 2413890021205557679,
                limb3: 0
            },
            xNegOverY: u384 {
                limb0: 35137550185854697786183474820,
                limb1: 11275058708583437680907525440,
                limb2: 1783406261418935870,
                limb3: 0
            },
            QyNeg0: u384 {
                limb0: 20126384521292478895504912058,
                limb1: 33582139726224892334399694519,
                limb2: 654028028164683349,
                limb3: 0
            },
            QyNeg1: u384 {
                limb0: 17808116402300838522170696566,
                limb1: 70441496847555760844908367871,
                limb2: 3318658706293296816,
                limb3: 0
            }
        };
        assert_eq!(p_0_result, p_0);
        assert_eq!(p_1_result, p_1);
    }


    #[test]
    fn test_run_BN254_MP_CHECK_PREPARE_PAIRS_3_circuit_BN254() {
        let p_0: G1Point = G1Point {
            x: u384 {
                limb0: 12377941077409553786097612947,
                limb1: 17782104531748736835525248671,
                limb2: 2784392756598634541,
                limb3: 0
            },
            y: u384 {
                limb0: 10051682615325258802350045923,
                limb1: 75010617618362871145782529740,
                limb2: 1008451027441420102,
                limb3: 0
            }
        };

        let Qy0_0: u384 = u384 {
            limb0: 56480597269194861113570348681,
            limb1: 12489015124085476300510160086,
            limb2: 591876590189962090,
            limb3: 0
        };

        let Qy1_0: u384 = u384 {
            limb0: 36693168962073156390778268101,
            limb1: 10989635017856757589619451303,
            limb2: 3188783918270009862,
            limb3: 0
        };

        let p_1: G1Point = G1Point {
            x: u384 {
                limb0: 2759776095823551941717050512,
                limb1: 57963889380965878628050708589,
                limb2: 2295185507317062952,
                limb3: 0
            },
            y: u384 {
                limb0: 57386324596293561251343305038,
                limb1: 7618976517038308641445925057,
                limb2: 2960922182843640226,
                limb3: 0
            }
        };

        let Qy0_1: u384 = u384 {
            limb0: 75447057788347766527569989757,
            limb1: 54509634512360888398764029013,
            limb2: 1404184422289668471,
            limb3: 0
        };

        let Qy1_1: u384 = u384 {
            limb0: 56828850124404589943193640763,
            limb1: 47551865498185077485618623635,
            limb2: 2174290563938186224,
            limb3: 0
        };

        let p_2: G1Point = G1Point {
            x: u384 {
                limb0: 54179543564690978914219750011,
                limb1: 61677089311691040596880313521,
                limb2: 848072952140179033,
                limb3: 0
            },
            y: u384 {
                limb0: 68815624253022498187661610823,
                limb1: 30030758402493479614858353112,
                limb2: 3049366972651778149,
                limb3: 0
            }
        };

        let Qy0_2: u384 = u384 {
            limb0: 32243610585906546138145771024,
            limb1: 12968364091712473131679789054,
            limb2: 2442887428653685264,
            limb3: 0
        };

        let Qy1_2: u384 = u384 {
            limb0: 21316573109193472944601748709,
            limb1: 15906312413545085219758845509,
            limb2: 2322420816178698199,
            limb3: 0
        };

        let (p_0_result, p_1_result, p_2_result) = run_BN254_MP_CHECK_PREPARE_PAIRS_3_circuit(
            p_0, Qy0_0, Qy1_0, p_1, Qy0_1, Qy1_1, p_2, Qy0_2, Qy1_2
        );
        let p_0: BNProcessedPair = BNProcessedPair {
            yInv: u384 {
                limb0: 69235951820255006636880856583,
                limb1: 15736639199465179280183191079,
                limb2: 2779440461336401692,
                limb3: 0
            },
            xNegOverY: u384 {
                limb0: 66377917728082143614209761880,
                limb1: 57343768467191655464316084079,
                limb2: 770479960038009127,
                limb3: 0
            },
            QyNeg0: u384 {
                limb0: 55071571407458887656752230078,
                limb1: 44553269958537763161369609658,
                limb2: 2895121676613008575,
                limb3: 0
            },
            QyNeg1: u384 {
                limb0: 74858999714580592379544310658,
                limb1: 46052650064766481872260318441,
                limb2: 298214348532960803,
                limb3: 0
            }
        };

        let p_1: BNProcessedPair = BNProcessedPair {
            yInv: u384 {
                limb0: 10724115895020906773141841650,
                limb1: 79201288351168061570522515765,
                limb2: 3288591774162421434,
                limb3: 0
            },
            xNegOverY: u384 {
                limb0: 34412879486520593581026876931,
                limb1: 34077431610325845560180362114,
                limb2: 2561980876531962515,
                limb3: 0
            },
            QyNeg0: u384 {
                limb0: 36105110888305982242752589002,
                limb1: 2532650570262351063115740731,
                limb2: 2082813844513302194,
                limb3: 0
            },
            QyNeg1: u384 {
                limb0: 54723318552249158827128937996,
                limb1: 9490419584438161976261146109,
                limb2: 1312707702864784441,
                limb3: 0
            }
        };

        let p_2: BNProcessedPair = BNProcessedPair {
            yInv: u384 {
                limb0: 66738026748174456353769930274,
                limb1: 99075119527383636843903856,
                limb2: 1954233585386313548,
                limb3: 0
            },
            xNegOverY: u384 {
                limb0: 62865381927369834414774850383,
                limb1: 18517464550186051365286650464,
                limb2: 838977593065962433,
                limb3: 0
            },
            QyNeg0: u384 {
                limb0: 80395576482865038632857399,
                limb1: 44073920990910766330199980691,
                limb2: 1044110838149285401,
                limb3: 0
            },
            QyNeg1: u384 {
                limb0: 11007433053195938232176879714,
                limb1: 41135972669078154242120924236,
                limb2: 1164577450624272466,
                limb3: 0
            }
        };
        assert_eq!(p_0_result, p_0);
        assert_eq!(p_1_result, p_1);
        assert_eq!(p_2_result, p_2);
    }
}
