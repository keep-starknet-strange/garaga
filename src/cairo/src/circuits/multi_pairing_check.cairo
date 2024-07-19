use core::circuit::{
    RangeCheck96, AddMod, MulMod, u384, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
    circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, CircuitOutputsTrait,
    CircuitModulus, AddInputResultTrait, CircuitInputs, CircuitDefinition, CircuitData,
    CircuitInputAccumulator
};
use garaga::definitions::{
    get_a, get_b, get_p, get_g, get_min_one, G1Point, G2Point, E12D, G1G2Pair, BNProcessedPair,
    BLSProcessedPair
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
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 3
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 6
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 0

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
    let t0 = circuit_mul(in30, in30); //Compute z^2
    let t1 = circuit_mul(t0, in30); //Compute z^3
    let t2 = circuit_mul(t1, in30); //Compute z^4
    let t3 = circuit_mul(t2, in30); //Compute z^5
    let t4 = circuit_mul(t3, in30); //Compute z^6
    let t5 = circuit_mul(t4, in30); //Compute z^7
    let t6 = circuit_mul(t5, in30); //Compute z^8
    let t7 = circuit_mul(t6, in30); //Compute z^9
    let t8 = circuit_mul(t7, in30); //Compute z^10
    let t9 = circuit_mul(t8, in30); //Compute z^11
    let t10 = circuit_mul(in29, in29); //Compute c_i = (c_(i-1))^2
    let t11 = circuit_mul(in16, in16); //Square f evaluation in Z, the result of previous bit.
    let t12 = circuit_add(in5, in6); //Doubling slope numerator start
    let t13 = circuit_sub(in5, in6);
    let t14 = circuit_mul(t12, t13);
    let t15 = circuit_mul(in5, in6);
    let t16 = circuit_mul(t14, in0);
    let t17 = circuit_mul(t15, in1); //Doubling slope numerator end
    let t18 = circuit_add(in7, in7); //Fp2 add coeff 0/1
    let t19 = circuit_add(in8, in8); //Fp2 add coeff 1/1
    let t20 = circuit_mul(t18, t18); //Fp2 Div x/y start : Fp2 Inv y start
    let t21 = circuit_mul(t19, t19);
    let t22 = circuit_add(t20, t21);
    let t23 = circuit_inverse(t22);
    let t24 = circuit_mul(t18, t23); //Fp2 Inv y real part end
    let t25 = circuit_mul(t19, t23);
    let t26 = circuit_sub(in2, t25); //Fp2 Inv y imag part end
    let t27 = circuit_mul(t16, t24); //Fp2 mul start
    let t28 = circuit_mul(t17, t26);
    let t29 = circuit_sub(t27, t28); //Fp2 mul real part end
    let t30 = circuit_mul(t16, t26);
    let t31 = circuit_mul(t17, t24);
    let t32 = circuit_add(t30, t31); //Fp2 mul imag part end
    let t33 = circuit_add(t29, t32);
    let t34 = circuit_sub(t29, t32);
    let t35 = circuit_mul(t33, t34);
    let t36 = circuit_mul(t29, t32);
    let t37 = circuit_add(t36, t36);
    let t38 = circuit_add(in5, in5); //Fp2 add coeff 0/1
    let t39 = circuit_add(in6, in6); //Fp2 add coeff 1/1
    let t40 = circuit_sub(t35, t38); //Fp2 sub coeff 0/1
    let t41 = circuit_sub(t37, t39); //Fp2 sub coeff 1/1
    let t42 = circuit_sub(in5, t40); //Fp2 sub coeff 0/1
    let t43 = circuit_sub(in6, t41); //Fp2 sub coeff 1/1
    let t44 = circuit_mul(t29, t42); //Fp2 mul start
    let t45 = circuit_mul(t32, t43);
    let t46 = circuit_sub(t44, t45); //Fp2 mul real part end
    let t47 = circuit_mul(t29, t43);
    let t48 = circuit_mul(t32, t42);
    let t49 = circuit_add(t47, t48); //Fp2 mul imag part end
    let t50 = circuit_sub(t46, in7); //Fp2 sub coeff 0/1
    let t51 = circuit_sub(t49, in8); //Fp2 sub coeff 1/1
    let t52 = circuit_mul(t29, in5); //Fp2 mul start
    let t53 = circuit_mul(t32, in6);
    let t54 = circuit_sub(t52, t53); //Fp2 mul real part end
    let t55 = circuit_mul(t29, in6);
    let t56 = circuit_mul(t32, in5);
    let t57 = circuit_add(t55, t56); //Fp2 mul imag part end
    let t58 = circuit_sub(t54, in7); //Fp2 sub coeff 0/1
    let t59 = circuit_sub(t57, in8); //Fp2 sub coeff 1/1
    let t60 = circuit_sub(t58, t59);
    let t61 = circuit_mul(t60, in3);
    let t62 = circuit_sub(t29, t32);
    let t63 = circuit_mul(t62, in4);
    let t64 = circuit_mul(t59, in3);
    let t65 = circuit_mul(t32, in4);
    let t66 = circuit_mul(t63, t0);
    let t67 = circuit_add(t61, t66);
    let t68 = circuit_add(t67, t1);
    let t69 = circuit_mul(t64, t4);
    let t70 = circuit_add(t68, t69);
    let t71 = circuit_mul(t65, t6);
    let t72 = circuit_add(t70, t71);
    let t73 = circuit_mul(t11, t72); //Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_0(z)
    let t74 = circuit_add(in11, in12); //Doubling slope numerator start
    let t75 = circuit_sub(in11, in12);
    let t76 = circuit_mul(t74, t75);
    let t77 = circuit_mul(in11, in12);
    let t78 = circuit_mul(t76, in0);
    let t79 = circuit_mul(t77, in1); //Doubling slope numerator end
    let t80 = circuit_add(in13, in13); //Fp2 add coeff 0/1
    let t81 = circuit_add(in14, in14); //Fp2 add coeff 1/1
    let t82 = circuit_mul(t80, t80); //Fp2 Div x/y start : Fp2 Inv y start
    let t83 = circuit_mul(t81, t81);
    let t84 = circuit_add(t82, t83);
    let t85 = circuit_inverse(t84);
    let t86 = circuit_mul(t80, t85); //Fp2 Inv y real part end
    let t87 = circuit_mul(t81, t85);
    let t88 = circuit_sub(in2, t87); //Fp2 Inv y imag part end
    let t89 = circuit_mul(t78, t86); //Fp2 mul start
    let t90 = circuit_mul(t79, t88);
    let t91 = circuit_sub(t89, t90); //Fp2 mul real part end
    let t92 = circuit_mul(t78, t88);
    let t93 = circuit_mul(t79, t86);
    let t94 = circuit_add(t92, t93); //Fp2 mul imag part end
    let t95 = circuit_add(t91, t94);
    let t96 = circuit_sub(t91, t94);
    let t97 = circuit_mul(t95, t96);
    let t98 = circuit_mul(t91, t94);
    let t99 = circuit_add(t98, t98);
    let t100 = circuit_add(in11, in11); //Fp2 add coeff 0/1
    let t101 = circuit_add(in12, in12); //Fp2 add coeff 1/1
    let t102 = circuit_sub(t97, t100); //Fp2 sub coeff 0/1
    let t103 = circuit_sub(t99, t101); //Fp2 sub coeff 1/1
    let t104 = circuit_sub(in11, t102); //Fp2 sub coeff 0/1
    let t105 = circuit_sub(in12, t103); //Fp2 sub coeff 1/1
    let t106 = circuit_mul(t91, t104); //Fp2 mul start
    let t107 = circuit_mul(t94, t105);
    let t108 = circuit_sub(t106, t107); //Fp2 mul real part end
    let t109 = circuit_mul(t91, t105);
    let t110 = circuit_mul(t94, t104);
    let t111 = circuit_add(t109, t110); //Fp2 mul imag part end
    let t112 = circuit_sub(t108, in13); //Fp2 sub coeff 0/1
    let t113 = circuit_sub(t111, in14); //Fp2 sub coeff 1/1
    let t114 = circuit_mul(t91, in11); //Fp2 mul start
    let t115 = circuit_mul(t94, in12);
    let t116 = circuit_sub(t114, t115); //Fp2 mul real part end
    let t117 = circuit_mul(t91, in12);
    let t118 = circuit_mul(t94, in11);
    let t119 = circuit_add(t117, t118); //Fp2 mul imag part end
    let t120 = circuit_sub(t116, in13); //Fp2 sub coeff 0/1
    let t121 = circuit_sub(t119, in14); //Fp2 sub coeff 1/1
    let t122 = circuit_sub(t120, t121);
    let t123 = circuit_mul(t122, in9);
    let t124 = circuit_sub(t91, t94);
    let t125 = circuit_mul(t124, in10);
    let t126 = circuit_mul(t121, in9);
    let t127 = circuit_mul(t94, in10);
    let t128 = circuit_mul(t125, t0);
    let t129 = circuit_add(t123, t128);
    let t130 = circuit_add(t129, t1);
    let t131 = circuit_mul(t126, t4);
    let t132 = circuit_add(t130, t131);
    let t133 = circuit_mul(t127, t6);
    let t134 = circuit_add(t132, t133);
    let t135 = circuit_mul(t73, t134); //Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_1(z)
    let t136 = circuit_mul(in18, in30);
    let t137 = circuit_add(in17, t136);
    let t138 = circuit_mul(in19, t0);
    let t139 = circuit_add(t137, t138);
    let t140 = circuit_mul(in20, t1);
    let t141 = circuit_add(t139, t140);
    let t142 = circuit_mul(in21, t2);
    let t143 = circuit_add(t141, t142);
    let t144 = circuit_mul(in22, t3);
    let t145 = circuit_add(t143, t144);
    let t146 = circuit_mul(in23, t4);
    let t147 = circuit_add(t145, t146);
    let t148 = circuit_mul(in24, t5);
    let t149 = circuit_add(t147, t148);
    let t150 = circuit_mul(in25, t6);
    let t151 = circuit_add(t149, t150);
    let t152 = circuit_mul(in26, t7);
    let t153 = circuit_add(t151, t152);
    let t154 = circuit_mul(in27, t8);
    let t155 = circuit_add(t153, t154);
    let t156 = circuit_mul(in28, t9);
    let t157 = circuit_add(t155, t156);
    let t158 = circuit_sub(t135, t157);
    let t159 = circuit_mul(t10, t158); //ci * ((Π(i,k) (Pk(z)) - Ri(z))
    let t160 = circuit_add(in15, t159); //LHS = LHS + ci * ((Π(i,k) (Pk(z)) - Ri(z))

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
    circuit_inputs = circuit_inputs.next(u384 { limb0: 3, limb1: 0, limb2: 0, limb3: 0 });
    circuit_inputs = circuit_inputs.next(u384 { limb0: 6, limb1: 0, limb2: 0, limb3: 0 });
    circuit_inputs = circuit_inputs.next(u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 });
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
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 3
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 6
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 0

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
    let t0 = circuit_mul(in36, in36); //Compute z^2
    let t1 = circuit_mul(t0, in36); //Compute z^3
    let t2 = circuit_mul(t1, in36); //Compute z^4
    let t3 = circuit_mul(t2, in36); //Compute z^5
    let t4 = circuit_mul(t3, in36); //Compute z^6
    let t5 = circuit_mul(t4, in36); //Compute z^7
    let t6 = circuit_mul(t5, in36); //Compute z^8
    let t7 = circuit_mul(t6, in36); //Compute z^9
    let t8 = circuit_mul(t7, in36); //Compute z^10
    let t9 = circuit_mul(t8, in36); //Compute z^11
    let t10 = circuit_mul(in35, in35); //Compute c_i = (c_(i-1))^2
    let t11 = circuit_mul(in22, in22); //Square f evaluation in Z, the result of previous bit.
    let t12 = circuit_add(in5, in6); //Doubling slope numerator start
    let t13 = circuit_sub(in5, in6);
    let t14 = circuit_mul(t12, t13);
    let t15 = circuit_mul(in5, in6);
    let t16 = circuit_mul(t14, in0);
    let t17 = circuit_mul(t15, in1); //Doubling slope numerator end
    let t18 = circuit_add(in7, in7); //Fp2 add coeff 0/1
    let t19 = circuit_add(in8, in8); //Fp2 add coeff 1/1
    let t20 = circuit_mul(t18, t18); //Fp2 Div x/y start : Fp2 Inv y start
    let t21 = circuit_mul(t19, t19);
    let t22 = circuit_add(t20, t21);
    let t23 = circuit_inverse(t22);
    let t24 = circuit_mul(t18, t23); //Fp2 Inv y real part end
    let t25 = circuit_mul(t19, t23);
    let t26 = circuit_sub(in2, t25); //Fp2 Inv y imag part end
    let t27 = circuit_mul(t16, t24); //Fp2 mul start
    let t28 = circuit_mul(t17, t26);
    let t29 = circuit_sub(t27, t28); //Fp2 mul real part end
    let t30 = circuit_mul(t16, t26);
    let t31 = circuit_mul(t17, t24);
    let t32 = circuit_add(t30, t31); //Fp2 mul imag part end
    let t33 = circuit_add(t29, t32);
    let t34 = circuit_sub(t29, t32);
    let t35 = circuit_mul(t33, t34);
    let t36 = circuit_mul(t29, t32);
    let t37 = circuit_add(t36, t36);
    let t38 = circuit_add(in5, in5); //Fp2 add coeff 0/1
    let t39 = circuit_add(in6, in6); //Fp2 add coeff 1/1
    let t40 = circuit_sub(t35, t38); //Fp2 sub coeff 0/1
    let t41 = circuit_sub(t37, t39); //Fp2 sub coeff 1/1
    let t42 = circuit_sub(in5, t40); //Fp2 sub coeff 0/1
    let t43 = circuit_sub(in6, t41); //Fp2 sub coeff 1/1
    let t44 = circuit_mul(t29, t42); //Fp2 mul start
    let t45 = circuit_mul(t32, t43);
    let t46 = circuit_sub(t44, t45); //Fp2 mul real part end
    let t47 = circuit_mul(t29, t43);
    let t48 = circuit_mul(t32, t42);
    let t49 = circuit_add(t47, t48); //Fp2 mul imag part end
    let t50 = circuit_sub(t46, in7); //Fp2 sub coeff 0/1
    let t51 = circuit_sub(t49, in8); //Fp2 sub coeff 1/1
    let t52 = circuit_mul(t29, in5); //Fp2 mul start
    let t53 = circuit_mul(t32, in6);
    let t54 = circuit_sub(t52, t53); //Fp2 mul real part end
    let t55 = circuit_mul(t29, in6);
    let t56 = circuit_mul(t32, in5);
    let t57 = circuit_add(t55, t56); //Fp2 mul imag part end
    let t58 = circuit_sub(t54, in7); //Fp2 sub coeff 0/1
    let t59 = circuit_sub(t57, in8); //Fp2 sub coeff 1/1
    let t60 = circuit_sub(t58, t59);
    let t61 = circuit_mul(t60, in3);
    let t62 = circuit_sub(t29, t32);
    let t63 = circuit_mul(t62, in4);
    let t64 = circuit_mul(t59, in3);
    let t65 = circuit_mul(t32, in4);
    let t66 = circuit_mul(t63, t0);
    let t67 = circuit_add(t61, t66);
    let t68 = circuit_add(t67, t1);
    let t69 = circuit_mul(t64, t4);
    let t70 = circuit_add(t68, t69);
    let t71 = circuit_mul(t65, t6);
    let t72 = circuit_add(t70, t71);
    let t73 = circuit_mul(t11, t72); //Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_0(z)
    let t74 = circuit_add(in11, in12); //Doubling slope numerator start
    let t75 = circuit_sub(in11, in12);
    let t76 = circuit_mul(t74, t75);
    let t77 = circuit_mul(in11, in12);
    let t78 = circuit_mul(t76, in0);
    let t79 = circuit_mul(t77, in1); //Doubling slope numerator end
    let t80 = circuit_add(in13, in13); //Fp2 add coeff 0/1
    let t81 = circuit_add(in14, in14); //Fp2 add coeff 1/1
    let t82 = circuit_mul(t80, t80); //Fp2 Div x/y start : Fp2 Inv y start
    let t83 = circuit_mul(t81, t81);
    let t84 = circuit_add(t82, t83);
    let t85 = circuit_inverse(t84);
    let t86 = circuit_mul(t80, t85); //Fp2 Inv y real part end
    let t87 = circuit_mul(t81, t85);
    let t88 = circuit_sub(in2, t87); //Fp2 Inv y imag part end
    let t89 = circuit_mul(t78, t86); //Fp2 mul start
    let t90 = circuit_mul(t79, t88);
    let t91 = circuit_sub(t89, t90); //Fp2 mul real part end
    let t92 = circuit_mul(t78, t88);
    let t93 = circuit_mul(t79, t86);
    let t94 = circuit_add(t92, t93); //Fp2 mul imag part end
    let t95 = circuit_add(t91, t94);
    let t96 = circuit_sub(t91, t94);
    let t97 = circuit_mul(t95, t96);
    let t98 = circuit_mul(t91, t94);
    let t99 = circuit_add(t98, t98);
    let t100 = circuit_add(in11, in11); //Fp2 add coeff 0/1
    let t101 = circuit_add(in12, in12); //Fp2 add coeff 1/1
    let t102 = circuit_sub(t97, t100); //Fp2 sub coeff 0/1
    let t103 = circuit_sub(t99, t101); //Fp2 sub coeff 1/1
    let t104 = circuit_sub(in11, t102); //Fp2 sub coeff 0/1
    let t105 = circuit_sub(in12, t103); //Fp2 sub coeff 1/1
    let t106 = circuit_mul(t91, t104); //Fp2 mul start
    let t107 = circuit_mul(t94, t105);
    let t108 = circuit_sub(t106, t107); //Fp2 mul real part end
    let t109 = circuit_mul(t91, t105);
    let t110 = circuit_mul(t94, t104);
    let t111 = circuit_add(t109, t110); //Fp2 mul imag part end
    let t112 = circuit_sub(t108, in13); //Fp2 sub coeff 0/1
    let t113 = circuit_sub(t111, in14); //Fp2 sub coeff 1/1
    let t114 = circuit_mul(t91, in11); //Fp2 mul start
    let t115 = circuit_mul(t94, in12);
    let t116 = circuit_sub(t114, t115); //Fp2 mul real part end
    let t117 = circuit_mul(t91, in12);
    let t118 = circuit_mul(t94, in11);
    let t119 = circuit_add(t117, t118); //Fp2 mul imag part end
    let t120 = circuit_sub(t116, in13); //Fp2 sub coeff 0/1
    let t121 = circuit_sub(t119, in14); //Fp2 sub coeff 1/1
    let t122 = circuit_sub(t120, t121);
    let t123 = circuit_mul(t122, in9);
    let t124 = circuit_sub(t91, t94);
    let t125 = circuit_mul(t124, in10);
    let t126 = circuit_mul(t121, in9);
    let t127 = circuit_mul(t94, in10);
    let t128 = circuit_mul(t125, t0);
    let t129 = circuit_add(t123, t128);
    let t130 = circuit_add(t129, t1);
    let t131 = circuit_mul(t126, t4);
    let t132 = circuit_add(t130, t131);
    let t133 = circuit_mul(t127, t6);
    let t134 = circuit_add(t132, t133);
    let t135 = circuit_mul(t73, t134); //Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_1(z)
    let t136 = circuit_add(in17, in18); //Doubling slope numerator start
    let t137 = circuit_sub(in17, in18);
    let t138 = circuit_mul(t136, t137);
    let t139 = circuit_mul(in17, in18);
    let t140 = circuit_mul(t138, in0);
    let t141 = circuit_mul(t139, in1); //Doubling slope numerator end
    let t142 = circuit_add(in19, in19); //Fp2 add coeff 0/1
    let t143 = circuit_add(in20, in20); //Fp2 add coeff 1/1
    let t144 = circuit_mul(t142, t142); //Fp2 Div x/y start : Fp2 Inv y start
    let t145 = circuit_mul(t143, t143);
    let t146 = circuit_add(t144, t145);
    let t147 = circuit_inverse(t146);
    let t148 = circuit_mul(t142, t147); //Fp2 Inv y real part end
    let t149 = circuit_mul(t143, t147);
    let t150 = circuit_sub(in2, t149); //Fp2 Inv y imag part end
    let t151 = circuit_mul(t140, t148); //Fp2 mul start
    let t152 = circuit_mul(t141, t150);
    let t153 = circuit_sub(t151, t152); //Fp2 mul real part end
    let t154 = circuit_mul(t140, t150);
    let t155 = circuit_mul(t141, t148);
    let t156 = circuit_add(t154, t155); //Fp2 mul imag part end
    let t157 = circuit_add(t153, t156);
    let t158 = circuit_sub(t153, t156);
    let t159 = circuit_mul(t157, t158);
    let t160 = circuit_mul(t153, t156);
    let t161 = circuit_add(t160, t160);
    let t162 = circuit_add(in17, in17); //Fp2 add coeff 0/1
    let t163 = circuit_add(in18, in18); //Fp2 add coeff 1/1
    let t164 = circuit_sub(t159, t162); //Fp2 sub coeff 0/1
    let t165 = circuit_sub(t161, t163); //Fp2 sub coeff 1/1
    let t166 = circuit_sub(in17, t164); //Fp2 sub coeff 0/1
    let t167 = circuit_sub(in18, t165); //Fp2 sub coeff 1/1
    let t168 = circuit_mul(t153, t166); //Fp2 mul start
    let t169 = circuit_mul(t156, t167);
    let t170 = circuit_sub(t168, t169); //Fp2 mul real part end
    let t171 = circuit_mul(t153, t167);
    let t172 = circuit_mul(t156, t166);
    let t173 = circuit_add(t171, t172); //Fp2 mul imag part end
    let t174 = circuit_sub(t170, in19); //Fp2 sub coeff 0/1
    let t175 = circuit_sub(t173, in20); //Fp2 sub coeff 1/1
    let t176 = circuit_mul(t153, in17); //Fp2 mul start
    let t177 = circuit_mul(t156, in18);
    let t178 = circuit_sub(t176, t177); //Fp2 mul real part end
    let t179 = circuit_mul(t153, in18);
    let t180 = circuit_mul(t156, in17);
    let t181 = circuit_add(t179, t180); //Fp2 mul imag part end
    let t182 = circuit_sub(t178, in19); //Fp2 sub coeff 0/1
    let t183 = circuit_sub(t181, in20); //Fp2 sub coeff 1/1
    let t184 = circuit_sub(t182, t183);
    let t185 = circuit_mul(t184, in15);
    let t186 = circuit_sub(t153, t156);
    let t187 = circuit_mul(t186, in16);
    let t188 = circuit_mul(t183, in15);
    let t189 = circuit_mul(t156, in16);
    let t190 = circuit_mul(t187, t0);
    let t191 = circuit_add(t185, t190);
    let t192 = circuit_add(t191, t1);
    let t193 = circuit_mul(t188, t4);
    let t194 = circuit_add(t192, t193);
    let t195 = circuit_mul(t189, t6);
    let t196 = circuit_add(t194, t195);
    let t197 = circuit_mul(t135, t196); //Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_2(z)
    let t198 = circuit_mul(in24, in36);
    let t199 = circuit_add(in23, t198);
    let t200 = circuit_mul(in25, t0);
    let t201 = circuit_add(t199, t200);
    let t202 = circuit_mul(in26, t1);
    let t203 = circuit_add(t201, t202);
    let t204 = circuit_mul(in27, t2);
    let t205 = circuit_add(t203, t204);
    let t206 = circuit_mul(in28, t3);
    let t207 = circuit_add(t205, t206);
    let t208 = circuit_mul(in29, t4);
    let t209 = circuit_add(t207, t208);
    let t210 = circuit_mul(in30, t5);
    let t211 = circuit_add(t209, t210);
    let t212 = circuit_mul(in31, t6);
    let t213 = circuit_add(t211, t212);
    let t214 = circuit_mul(in32, t7);
    let t215 = circuit_add(t213, t214);
    let t216 = circuit_mul(in33, t8);
    let t217 = circuit_add(t215, t216);
    let t218 = circuit_mul(in34, t9);
    let t219 = circuit_add(t217, t218);
    let t220 = circuit_sub(t197, t219);
    let t221 = circuit_mul(t10, t220); //ci * ((Π(i,k) (Pk(z)) - Ri(z))
    let t222 = circuit_add(in21, t221); //LHS = LHS + ci * ((Π(i,k) (Pk(z)) - Ri(z))

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
    circuit_inputs = circuit_inputs.next(u384 { limb0: 3, limb1: 0, limb2: 0, limb3: 0 });
    circuit_inputs = circuit_inputs.next(u384 { limb0: 6, limb1: 0, limb2: 0, limb3: 0 });
    circuit_inputs = circuit_inputs.next(u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 });
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
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0

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
    let t0 = circuit_mul(in36, in36); //Compute z^2
    let t1 = circuit_mul(t0, in36); //Compute z^3
    let t2 = circuit_mul(t1, in36); //Compute z^4
    let t3 = circuit_mul(t2, in36); //Compute z^5
    let t4 = circuit_mul(t3, in36); //Compute z^6
    let t5 = circuit_mul(t4, in36); //Compute z^7
    let t6 = circuit_mul(t5, in36); //Compute z^8
    let t7 = circuit_mul(t6, in36); //Compute z^9
    let t8 = circuit_mul(t7, in36); //Compute z^10
    let t9 = circuit_mul(t8, in36); //Compute z^11
    let t10 = circuit_mul(in37, in37);
    let t11 = circuit_mul(in22, in22);
    let t12 = circuit_sub(in5, in9); //Fp2 sub coeff 0/1
    let t13 = circuit_sub(in6, in10); //Fp2 sub coeff 1/1
    let t14 = circuit_sub(in3, in7); //Fp2 sub coeff 0/1
    let t15 = circuit_sub(in4, in8); //Fp2 sub coeff 1/1
    let t16 = circuit_mul(t14, t14); //Fp2 Div x/y start : Fp2 Inv y start
    let t17 = circuit_mul(t15, t15);
    let t18 = circuit_add(t16, t17);
    let t19 = circuit_inverse(t18);
    let t20 = circuit_mul(t14, t19); //Fp2 Inv y real part end
    let t21 = circuit_mul(t15, t19);
    let t22 = circuit_sub(in0, t21); //Fp2 Inv y imag part end
    let t23 = circuit_mul(t12, t20); //Fp2 mul start
    let t24 = circuit_mul(t13, t22);
    let t25 = circuit_sub(t23, t24); //Fp2 mul real part end
    let t26 = circuit_mul(t12, t22);
    let t27 = circuit_mul(t13, t20);
    let t28 = circuit_add(t26, t27); //Fp2 mul imag part end
    let t29 = circuit_add(t25, t28);
    let t30 = circuit_sub(t25, t28);
    let t31 = circuit_mul(t29, t30);
    let t32 = circuit_mul(t25, t28);
    let t33 = circuit_add(t32, t32);
    let t34 = circuit_add(in3, in7); //Fp2 add coeff 0/1
    let t35 = circuit_add(in4, in8); //Fp2 add coeff 1/1
    let t36 = circuit_sub(t31, t34); //Fp2 sub coeff 0/1
    let t37 = circuit_sub(t33, t35); //Fp2 sub coeff 1/1
    let t38 = circuit_mul(t25, in3); //Fp2 mul start
    let t39 = circuit_mul(t28, in4);
    let t40 = circuit_sub(t38, t39); //Fp2 mul real part end
    let t41 = circuit_mul(t25, in4);
    let t42 = circuit_mul(t28, in3);
    let t43 = circuit_add(t41, t42); //Fp2 mul imag part end
    let t44 = circuit_sub(t40, in5); //Fp2 sub coeff 0/1
    let t45 = circuit_sub(t43, in6); //Fp2 sub coeff 1/1
    let t46 = circuit_sub(t44, t45);
    let t47 = circuit_mul(t46, in1);
    let t48 = circuit_sub(t25, t28);
    let t49 = circuit_mul(t48, in2);
    let t50 = circuit_mul(t45, in1);
    let t51 = circuit_mul(t28, in2);
    let t52 = circuit_add(in5, in5); //Fp2 add coeff 0/1
    let t53 = circuit_add(in6, in6); //Fp2 add coeff 1/1
    let t54 = circuit_sub(t36, in3); //Fp2 sub coeff 0/1
    let t55 = circuit_sub(t37, in4); //Fp2 sub coeff 1/1
    let t56 = circuit_mul(t54, t54); //Fp2 Div x/y start : Fp2 Inv y start
    let t57 = circuit_mul(t55, t55);
    let t58 = circuit_add(t56, t57);
    let t59 = circuit_inverse(t58);
    let t60 = circuit_mul(t54, t59); //Fp2 Inv y real part end
    let t61 = circuit_mul(t55, t59);
    let t62 = circuit_sub(in0, t61); //Fp2 Inv y imag part end
    let t63 = circuit_mul(t52, t60); //Fp2 mul start
    let t64 = circuit_mul(t53, t62);
    let t65 = circuit_sub(t63, t64); //Fp2 mul real part end
    let t66 = circuit_mul(t52, t62);
    let t67 = circuit_mul(t53, t60);
    let t68 = circuit_add(t66, t67); //Fp2 mul imag part end
    let t69 = circuit_add(t25, t65); //Fp2 add coeff 0/1
    let t70 = circuit_add(t28, t68); //Fp2 add coeff 1/1
    let t71 = circuit_sub(in0, t69); //Fp2 neg coeff 0/1
    let t72 = circuit_sub(in0, t70); //Fp2 neg coeff 1/1
    let t73 = circuit_add(t71, t72);
    let t74 = circuit_sub(t71, t72);
    let t75 = circuit_mul(t73, t74);
    let t76 = circuit_mul(t71, t72);
    let t77 = circuit_add(t76, t76);
    let t78 = circuit_sub(t75, in3); //Fp2 sub coeff 0/1
    let t79 = circuit_sub(t77, in4); //Fp2 sub coeff 1/1
    let t80 = circuit_sub(t78, t36); //Fp2 sub coeff 0/1
    let t81 = circuit_sub(t79, t37); //Fp2 sub coeff 1/1
    let t82 = circuit_sub(in3, t80); //Fp2 sub coeff 0/1
    let t83 = circuit_sub(in4, t81); //Fp2 sub coeff 1/1
    let t84 = circuit_mul(t71, t82); //Fp2 mul start
    let t85 = circuit_mul(t72, t83);
    let t86 = circuit_sub(t84, t85); //Fp2 mul real part end
    let t87 = circuit_mul(t71, t83);
    let t88 = circuit_mul(t72, t82);
    let t89 = circuit_add(t87, t88); //Fp2 mul imag part end
    let t90 = circuit_sub(t86, in5); //Fp2 sub coeff 0/1
    let t91 = circuit_sub(t89, in6); //Fp2 sub coeff 1/1
    let t92 = circuit_mul(t71, in3); //Fp2 mul start
    let t93 = circuit_mul(t72, in4);
    let t94 = circuit_sub(t92, t93); //Fp2 mul real part end
    let t95 = circuit_mul(t71, in4);
    let t96 = circuit_mul(t72, in3);
    let t97 = circuit_add(t95, t96); //Fp2 mul imag part end
    let t98 = circuit_sub(t94, in5); //Fp2 sub coeff 0/1
    let t99 = circuit_sub(t97, in6); //Fp2 sub coeff 1/1
    let t100 = circuit_sub(t98, t99);
    let t101 = circuit_mul(t100, in1);
    let t102 = circuit_sub(t71, t72);
    let t103 = circuit_mul(t102, in2);
    let t104 = circuit_mul(t99, in1);
    let t105 = circuit_mul(t72, in2);
    let t106 = circuit_mul(t49, t0);
    let t107 = circuit_add(t47, t106);
    let t108 = circuit_add(t107, t1);
    let t109 = circuit_mul(t50, t4);
    let t110 = circuit_add(t108, t109);
    let t111 = circuit_mul(t51, t6);
    let t112 = circuit_add(t110, t111);
    let t113 = circuit_mul(t11, t112);
    let t114 = circuit_mul(t103, t0);
    let t115 = circuit_add(t101, t114);
    let t116 = circuit_add(t115, t1);
    let t117 = circuit_mul(t104, t4);
    let t118 = circuit_add(t116, t117);
    let t119 = circuit_mul(t105, t6);
    let t120 = circuit_add(t118, t119);
    let t121 = circuit_mul(t113, t120);
    let t122 = circuit_sub(in15, in19); //Fp2 sub coeff 0/1
    let t123 = circuit_sub(in16, in20); //Fp2 sub coeff 1/1
    let t124 = circuit_sub(in13, in17); //Fp2 sub coeff 0/1
    let t125 = circuit_sub(in14, in18); //Fp2 sub coeff 1/1
    let t126 = circuit_mul(t124, t124); //Fp2 Div x/y start : Fp2 Inv y start
    let t127 = circuit_mul(t125, t125);
    let t128 = circuit_add(t126, t127);
    let t129 = circuit_inverse(t128);
    let t130 = circuit_mul(t124, t129); //Fp2 Inv y real part end
    let t131 = circuit_mul(t125, t129);
    let t132 = circuit_sub(in0, t131); //Fp2 Inv y imag part end
    let t133 = circuit_mul(t122, t130); //Fp2 mul start
    let t134 = circuit_mul(t123, t132);
    let t135 = circuit_sub(t133, t134); //Fp2 mul real part end
    let t136 = circuit_mul(t122, t132);
    let t137 = circuit_mul(t123, t130);
    let t138 = circuit_add(t136, t137); //Fp2 mul imag part end
    let t139 = circuit_add(t135, t138);
    let t140 = circuit_sub(t135, t138);
    let t141 = circuit_mul(t139, t140);
    let t142 = circuit_mul(t135, t138);
    let t143 = circuit_add(t142, t142);
    let t144 = circuit_add(in13, in17); //Fp2 add coeff 0/1
    let t145 = circuit_add(in14, in18); //Fp2 add coeff 1/1
    let t146 = circuit_sub(t141, t144); //Fp2 sub coeff 0/1
    let t147 = circuit_sub(t143, t145); //Fp2 sub coeff 1/1
    let t148 = circuit_mul(t135, in13); //Fp2 mul start
    let t149 = circuit_mul(t138, in14);
    let t150 = circuit_sub(t148, t149); //Fp2 mul real part end
    let t151 = circuit_mul(t135, in14);
    let t152 = circuit_mul(t138, in13);
    let t153 = circuit_add(t151, t152); //Fp2 mul imag part end
    let t154 = circuit_sub(t150, in15); //Fp2 sub coeff 0/1
    let t155 = circuit_sub(t153, in16); //Fp2 sub coeff 1/1
    let t156 = circuit_sub(t154, t155);
    let t157 = circuit_mul(t156, in11);
    let t158 = circuit_sub(t135, t138);
    let t159 = circuit_mul(t158, in12);
    let t160 = circuit_mul(t155, in11);
    let t161 = circuit_mul(t138, in12);
    let t162 = circuit_add(in15, in15); //Fp2 add coeff 0/1
    let t163 = circuit_add(in16, in16); //Fp2 add coeff 1/1
    let t164 = circuit_sub(t146, in13); //Fp2 sub coeff 0/1
    let t165 = circuit_sub(t147, in14); //Fp2 sub coeff 1/1
    let t166 = circuit_mul(t164, t164); //Fp2 Div x/y start : Fp2 Inv y start
    let t167 = circuit_mul(t165, t165);
    let t168 = circuit_add(t166, t167);
    let t169 = circuit_inverse(t168);
    let t170 = circuit_mul(t164, t169); //Fp2 Inv y real part end
    let t171 = circuit_mul(t165, t169);
    let t172 = circuit_sub(in0, t171); //Fp2 Inv y imag part end
    let t173 = circuit_mul(t162, t170); //Fp2 mul start
    let t174 = circuit_mul(t163, t172);
    let t175 = circuit_sub(t173, t174); //Fp2 mul real part end
    let t176 = circuit_mul(t162, t172);
    let t177 = circuit_mul(t163, t170);
    let t178 = circuit_add(t176, t177); //Fp2 mul imag part end
    let t179 = circuit_add(t135, t175); //Fp2 add coeff 0/1
    let t180 = circuit_add(t138, t178); //Fp2 add coeff 1/1
    let t181 = circuit_sub(in0, t179); //Fp2 neg coeff 0/1
    let t182 = circuit_sub(in0, t180); //Fp2 neg coeff 1/1
    let t183 = circuit_add(t181, t182);
    let t184 = circuit_sub(t181, t182);
    let t185 = circuit_mul(t183, t184);
    let t186 = circuit_mul(t181, t182);
    let t187 = circuit_add(t186, t186);
    let t188 = circuit_sub(t185, in13); //Fp2 sub coeff 0/1
    let t189 = circuit_sub(t187, in14); //Fp2 sub coeff 1/1
    let t190 = circuit_sub(t188, t146); //Fp2 sub coeff 0/1
    let t191 = circuit_sub(t189, t147); //Fp2 sub coeff 1/1
    let t192 = circuit_sub(in13, t190); //Fp2 sub coeff 0/1
    let t193 = circuit_sub(in14, t191); //Fp2 sub coeff 1/1
    let t194 = circuit_mul(t181, t192); //Fp2 mul start
    let t195 = circuit_mul(t182, t193);
    let t196 = circuit_sub(t194, t195); //Fp2 mul real part end
    let t197 = circuit_mul(t181, t193);
    let t198 = circuit_mul(t182, t192);
    let t199 = circuit_add(t197, t198); //Fp2 mul imag part end
    let t200 = circuit_sub(t196, in15); //Fp2 sub coeff 0/1
    let t201 = circuit_sub(t199, in16); //Fp2 sub coeff 1/1
    let t202 = circuit_mul(t181, in13); //Fp2 mul start
    let t203 = circuit_mul(t182, in14);
    let t204 = circuit_sub(t202, t203); //Fp2 mul real part end
    let t205 = circuit_mul(t181, in14);
    let t206 = circuit_mul(t182, in13);
    let t207 = circuit_add(t205, t206); //Fp2 mul imag part end
    let t208 = circuit_sub(t204, in15); //Fp2 sub coeff 0/1
    let t209 = circuit_sub(t207, in16); //Fp2 sub coeff 1/1
    let t210 = circuit_sub(t208, t209);
    let t211 = circuit_mul(t210, in11);
    let t212 = circuit_sub(t181, t182);
    let t213 = circuit_mul(t212, in12);
    let t214 = circuit_mul(t209, in11);
    let t215 = circuit_mul(t182, in12);
    let t216 = circuit_mul(t159, t0);
    let t217 = circuit_add(t157, t216);
    let t218 = circuit_add(t217, t1);
    let t219 = circuit_mul(t160, t4);
    let t220 = circuit_add(t218, t219);
    let t221 = circuit_mul(t161, t6);
    let t222 = circuit_add(t220, t221);
    let t223 = circuit_mul(t121, t222);
    let t224 = circuit_mul(t213, t0);
    let t225 = circuit_add(t211, t224);
    let t226 = circuit_add(t225, t1);
    let t227 = circuit_mul(t214, t4);
    let t228 = circuit_add(t226, t227);
    let t229 = circuit_mul(t215, t6);
    let t230 = circuit_add(t228, t229);
    let t231 = circuit_mul(t223, t230);
    let t232 = circuit_mul(t231, in35);
    let t233 = circuit_mul(in24, in36);
    let t234 = circuit_add(in23, t233);
    let t235 = circuit_mul(in25, t0);
    let t236 = circuit_add(t234, t235);
    let t237 = circuit_mul(in26, t1);
    let t238 = circuit_add(t236, t237);
    let t239 = circuit_mul(in27, t2);
    let t240 = circuit_add(t238, t239);
    let t241 = circuit_mul(in28, t3);
    let t242 = circuit_add(t240, t241);
    let t243 = circuit_mul(in29, t4);
    let t244 = circuit_add(t242, t243);
    let t245 = circuit_mul(in30, t5);
    let t246 = circuit_add(t244, t245);
    let t247 = circuit_mul(in31, t6);
    let t248 = circuit_add(t246, t247);
    let t249 = circuit_mul(in32, t7);
    let t250 = circuit_add(t248, t249);
    let t251 = circuit_mul(in33, t8);
    let t252 = circuit_add(t250, t251);
    let t253 = circuit_mul(in34, t9);
    let t254 = circuit_add(t252, t253);
    let t255 = circuit_sub(t232, t254);
    let t256 = circuit_mul(t10, t255); //ci * ((Π(i,k) (Pk(z)) - Ri(z))
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
    circuit_inputs = circuit_inputs.next(u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 });
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
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0

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
    let t0 = circuit_mul(in46, in46); //Compute z^2
    let t1 = circuit_mul(t0, in46); //Compute z^3
    let t2 = circuit_mul(t1, in46); //Compute z^4
    let t3 = circuit_mul(t2, in46); //Compute z^5
    let t4 = circuit_mul(t3, in46); //Compute z^6
    let t5 = circuit_mul(t4, in46); //Compute z^7
    let t6 = circuit_mul(t5, in46); //Compute z^8
    let t7 = circuit_mul(t6, in46); //Compute z^9
    let t8 = circuit_mul(t7, in46); //Compute z^10
    let t9 = circuit_mul(t8, in46); //Compute z^11
    let t10 = circuit_mul(in47, in47);
    let t11 = circuit_mul(in32, in32);
    let t12 = circuit_sub(in5, in9); //Fp2 sub coeff 0/1
    let t13 = circuit_sub(in6, in10); //Fp2 sub coeff 1/1
    let t14 = circuit_sub(in3, in7); //Fp2 sub coeff 0/1
    let t15 = circuit_sub(in4, in8); //Fp2 sub coeff 1/1
    let t16 = circuit_mul(t14, t14); //Fp2 Div x/y start : Fp2 Inv y start
    let t17 = circuit_mul(t15, t15);
    let t18 = circuit_add(t16, t17);
    let t19 = circuit_inverse(t18);
    let t20 = circuit_mul(t14, t19); //Fp2 Inv y real part end
    let t21 = circuit_mul(t15, t19);
    let t22 = circuit_sub(in0, t21); //Fp2 Inv y imag part end
    let t23 = circuit_mul(t12, t20); //Fp2 mul start
    let t24 = circuit_mul(t13, t22);
    let t25 = circuit_sub(t23, t24); //Fp2 mul real part end
    let t26 = circuit_mul(t12, t22);
    let t27 = circuit_mul(t13, t20);
    let t28 = circuit_add(t26, t27); //Fp2 mul imag part end
    let t29 = circuit_add(t25, t28);
    let t30 = circuit_sub(t25, t28);
    let t31 = circuit_mul(t29, t30);
    let t32 = circuit_mul(t25, t28);
    let t33 = circuit_add(t32, t32);
    let t34 = circuit_add(in3, in7); //Fp2 add coeff 0/1
    let t35 = circuit_add(in4, in8); //Fp2 add coeff 1/1
    let t36 = circuit_sub(t31, t34); //Fp2 sub coeff 0/1
    let t37 = circuit_sub(t33, t35); //Fp2 sub coeff 1/1
    let t38 = circuit_mul(t25, in3); //Fp2 mul start
    let t39 = circuit_mul(t28, in4);
    let t40 = circuit_sub(t38, t39); //Fp2 mul real part end
    let t41 = circuit_mul(t25, in4);
    let t42 = circuit_mul(t28, in3);
    let t43 = circuit_add(t41, t42); //Fp2 mul imag part end
    let t44 = circuit_sub(t40, in5); //Fp2 sub coeff 0/1
    let t45 = circuit_sub(t43, in6); //Fp2 sub coeff 1/1
    let t46 = circuit_sub(t44, t45);
    let t47 = circuit_mul(t46, in1);
    let t48 = circuit_sub(t25, t28);
    let t49 = circuit_mul(t48, in2);
    let t50 = circuit_mul(t45, in1);
    let t51 = circuit_mul(t28, in2);
    let t52 = circuit_add(in5, in5); //Fp2 add coeff 0/1
    let t53 = circuit_add(in6, in6); //Fp2 add coeff 1/1
    let t54 = circuit_sub(t36, in3); //Fp2 sub coeff 0/1
    let t55 = circuit_sub(t37, in4); //Fp2 sub coeff 1/1
    let t56 = circuit_mul(t54, t54); //Fp2 Div x/y start : Fp2 Inv y start
    let t57 = circuit_mul(t55, t55);
    let t58 = circuit_add(t56, t57);
    let t59 = circuit_inverse(t58);
    let t60 = circuit_mul(t54, t59); //Fp2 Inv y real part end
    let t61 = circuit_mul(t55, t59);
    let t62 = circuit_sub(in0, t61); //Fp2 Inv y imag part end
    let t63 = circuit_mul(t52, t60); //Fp2 mul start
    let t64 = circuit_mul(t53, t62);
    let t65 = circuit_sub(t63, t64); //Fp2 mul real part end
    let t66 = circuit_mul(t52, t62);
    let t67 = circuit_mul(t53, t60);
    let t68 = circuit_add(t66, t67); //Fp2 mul imag part end
    let t69 = circuit_add(t25, t65); //Fp2 add coeff 0/1
    let t70 = circuit_add(t28, t68); //Fp2 add coeff 1/1
    let t71 = circuit_sub(in0, t69); //Fp2 neg coeff 0/1
    let t72 = circuit_sub(in0, t70); //Fp2 neg coeff 1/1
    let t73 = circuit_add(t71, t72);
    let t74 = circuit_sub(t71, t72);
    let t75 = circuit_mul(t73, t74);
    let t76 = circuit_mul(t71, t72);
    let t77 = circuit_add(t76, t76);
    let t78 = circuit_sub(t75, in3); //Fp2 sub coeff 0/1
    let t79 = circuit_sub(t77, in4); //Fp2 sub coeff 1/1
    let t80 = circuit_sub(t78, t36); //Fp2 sub coeff 0/1
    let t81 = circuit_sub(t79, t37); //Fp2 sub coeff 1/1
    let t82 = circuit_sub(in3, t80); //Fp2 sub coeff 0/1
    let t83 = circuit_sub(in4, t81); //Fp2 sub coeff 1/1
    let t84 = circuit_mul(t71, t82); //Fp2 mul start
    let t85 = circuit_mul(t72, t83);
    let t86 = circuit_sub(t84, t85); //Fp2 mul real part end
    let t87 = circuit_mul(t71, t83);
    let t88 = circuit_mul(t72, t82);
    let t89 = circuit_add(t87, t88); //Fp2 mul imag part end
    let t90 = circuit_sub(t86, in5); //Fp2 sub coeff 0/1
    let t91 = circuit_sub(t89, in6); //Fp2 sub coeff 1/1
    let t92 = circuit_mul(t71, in3); //Fp2 mul start
    let t93 = circuit_mul(t72, in4);
    let t94 = circuit_sub(t92, t93); //Fp2 mul real part end
    let t95 = circuit_mul(t71, in4);
    let t96 = circuit_mul(t72, in3);
    let t97 = circuit_add(t95, t96); //Fp2 mul imag part end
    let t98 = circuit_sub(t94, in5); //Fp2 sub coeff 0/1
    let t99 = circuit_sub(t97, in6); //Fp2 sub coeff 1/1
    let t100 = circuit_sub(t98, t99);
    let t101 = circuit_mul(t100, in1);
    let t102 = circuit_sub(t71, t72);
    let t103 = circuit_mul(t102, in2);
    let t104 = circuit_mul(t99, in1);
    let t105 = circuit_mul(t72, in2);
    let t106 = circuit_mul(t49, t0);
    let t107 = circuit_add(t47, t106);
    let t108 = circuit_add(t107, t1);
    let t109 = circuit_mul(t50, t4);
    let t110 = circuit_add(t108, t109);
    let t111 = circuit_mul(t51, t6);
    let t112 = circuit_add(t110, t111);
    let t113 = circuit_mul(t11, t112);
    let t114 = circuit_mul(t103, t0);
    let t115 = circuit_add(t101, t114);
    let t116 = circuit_add(t115, t1);
    let t117 = circuit_mul(t104, t4);
    let t118 = circuit_add(t116, t117);
    let t119 = circuit_mul(t105, t6);
    let t120 = circuit_add(t118, t119);
    let t121 = circuit_mul(t113, t120);
    let t122 = circuit_sub(in15, in19); //Fp2 sub coeff 0/1
    let t123 = circuit_sub(in16, in20); //Fp2 sub coeff 1/1
    let t124 = circuit_sub(in13, in17); //Fp2 sub coeff 0/1
    let t125 = circuit_sub(in14, in18); //Fp2 sub coeff 1/1
    let t126 = circuit_mul(t124, t124); //Fp2 Div x/y start : Fp2 Inv y start
    let t127 = circuit_mul(t125, t125);
    let t128 = circuit_add(t126, t127);
    let t129 = circuit_inverse(t128);
    let t130 = circuit_mul(t124, t129); //Fp2 Inv y real part end
    let t131 = circuit_mul(t125, t129);
    let t132 = circuit_sub(in0, t131); //Fp2 Inv y imag part end
    let t133 = circuit_mul(t122, t130); //Fp2 mul start
    let t134 = circuit_mul(t123, t132);
    let t135 = circuit_sub(t133, t134); //Fp2 mul real part end
    let t136 = circuit_mul(t122, t132);
    let t137 = circuit_mul(t123, t130);
    let t138 = circuit_add(t136, t137); //Fp2 mul imag part end
    let t139 = circuit_add(t135, t138);
    let t140 = circuit_sub(t135, t138);
    let t141 = circuit_mul(t139, t140);
    let t142 = circuit_mul(t135, t138);
    let t143 = circuit_add(t142, t142);
    let t144 = circuit_add(in13, in17); //Fp2 add coeff 0/1
    let t145 = circuit_add(in14, in18); //Fp2 add coeff 1/1
    let t146 = circuit_sub(t141, t144); //Fp2 sub coeff 0/1
    let t147 = circuit_sub(t143, t145); //Fp2 sub coeff 1/1
    let t148 = circuit_mul(t135, in13); //Fp2 mul start
    let t149 = circuit_mul(t138, in14);
    let t150 = circuit_sub(t148, t149); //Fp2 mul real part end
    let t151 = circuit_mul(t135, in14);
    let t152 = circuit_mul(t138, in13);
    let t153 = circuit_add(t151, t152); //Fp2 mul imag part end
    let t154 = circuit_sub(t150, in15); //Fp2 sub coeff 0/1
    let t155 = circuit_sub(t153, in16); //Fp2 sub coeff 1/1
    let t156 = circuit_sub(t154, t155);
    let t157 = circuit_mul(t156, in11);
    let t158 = circuit_sub(t135, t138);
    let t159 = circuit_mul(t158, in12);
    let t160 = circuit_mul(t155, in11);
    let t161 = circuit_mul(t138, in12);
    let t162 = circuit_add(in15, in15); //Fp2 add coeff 0/1
    let t163 = circuit_add(in16, in16); //Fp2 add coeff 1/1
    let t164 = circuit_sub(t146, in13); //Fp2 sub coeff 0/1
    let t165 = circuit_sub(t147, in14); //Fp2 sub coeff 1/1
    let t166 = circuit_mul(t164, t164); //Fp2 Div x/y start : Fp2 Inv y start
    let t167 = circuit_mul(t165, t165);
    let t168 = circuit_add(t166, t167);
    let t169 = circuit_inverse(t168);
    let t170 = circuit_mul(t164, t169); //Fp2 Inv y real part end
    let t171 = circuit_mul(t165, t169);
    let t172 = circuit_sub(in0, t171); //Fp2 Inv y imag part end
    let t173 = circuit_mul(t162, t170); //Fp2 mul start
    let t174 = circuit_mul(t163, t172);
    let t175 = circuit_sub(t173, t174); //Fp2 mul real part end
    let t176 = circuit_mul(t162, t172);
    let t177 = circuit_mul(t163, t170);
    let t178 = circuit_add(t176, t177); //Fp2 mul imag part end
    let t179 = circuit_add(t135, t175); //Fp2 add coeff 0/1
    let t180 = circuit_add(t138, t178); //Fp2 add coeff 1/1
    let t181 = circuit_sub(in0, t179); //Fp2 neg coeff 0/1
    let t182 = circuit_sub(in0, t180); //Fp2 neg coeff 1/1
    let t183 = circuit_add(t181, t182);
    let t184 = circuit_sub(t181, t182);
    let t185 = circuit_mul(t183, t184);
    let t186 = circuit_mul(t181, t182);
    let t187 = circuit_add(t186, t186);
    let t188 = circuit_sub(t185, in13); //Fp2 sub coeff 0/1
    let t189 = circuit_sub(t187, in14); //Fp2 sub coeff 1/1
    let t190 = circuit_sub(t188, t146); //Fp2 sub coeff 0/1
    let t191 = circuit_sub(t189, t147); //Fp2 sub coeff 1/1
    let t192 = circuit_sub(in13, t190); //Fp2 sub coeff 0/1
    let t193 = circuit_sub(in14, t191); //Fp2 sub coeff 1/1
    let t194 = circuit_mul(t181, t192); //Fp2 mul start
    let t195 = circuit_mul(t182, t193);
    let t196 = circuit_sub(t194, t195); //Fp2 mul real part end
    let t197 = circuit_mul(t181, t193);
    let t198 = circuit_mul(t182, t192);
    let t199 = circuit_add(t197, t198); //Fp2 mul imag part end
    let t200 = circuit_sub(t196, in15); //Fp2 sub coeff 0/1
    let t201 = circuit_sub(t199, in16); //Fp2 sub coeff 1/1
    let t202 = circuit_mul(t181, in13); //Fp2 mul start
    let t203 = circuit_mul(t182, in14);
    let t204 = circuit_sub(t202, t203); //Fp2 mul real part end
    let t205 = circuit_mul(t181, in14);
    let t206 = circuit_mul(t182, in13);
    let t207 = circuit_add(t205, t206); //Fp2 mul imag part end
    let t208 = circuit_sub(t204, in15); //Fp2 sub coeff 0/1
    let t209 = circuit_sub(t207, in16); //Fp2 sub coeff 1/1
    let t210 = circuit_sub(t208, t209);
    let t211 = circuit_mul(t210, in11);
    let t212 = circuit_sub(t181, t182);
    let t213 = circuit_mul(t212, in12);
    let t214 = circuit_mul(t209, in11);
    let t215 = circuit_mul(t182, in12);
    let t216 = circuit_mul(t159, t0);
    let t217 = circuit_add(t157, t216);
    let t218 = circuit_add(t217, t1);
    let t219 = circuit_mul(t160, t4);
    let t220 = circuit_add(t218, t219);
    let t221 = circuit_mul(t161, t6);
    let t222 = circuit_add(t220, t221);
    let t223 = circuit_mul(t121, t222);
    let t224 = circuit_mul(t213, t0);
    let t225 = circuit_add(t211, t224);
    let t226 = circuit_add(t225, t1);
    let t227 = circuit_mul(t214, t4);
    let t228 = circuit_add(t226, t227);
    let t229 = circuit_mul(t215, t6);
    let t230 = circuit_add(t228, t229);
    let t231 = circuit_mul(t223, t230);
    let t232 = circuit_sub(in25, in29); //Fp2 sub coeff 0/1
    let t233 = circuit_sub(in26, in30); //Fp2 sub coeff 1/1
    let t234 = circuit_sub(in23, in27); //Fp2 sub coeff 0/1
    let t235 = circuit_sub(in24, in28); //Fp2 sub coeff 1/1
    let t236 = circuit_mul(t234, t234); //Fp2 Div x/y start : Fp2 Inv y start
    let t237 = circuit_mul(t235, t235);
    let t238 = circuit_add(t236, t237);
    let t239 = circuit_inverse(t238);
    let t240 = circuit_mul(t234, t239); //Fp2 Inv y real part end
    let t241 = circuit_mul(t235, t239);
    let t242 = circuit_sub(in0, t241); //Fp2 Inv y imag part end
    let t243 = circuit_mul(t232, t240); //Fp2 mul start
    let t244 = circuit_mul(t233, t242);
    let t245 = circuit_sub(t243, t244); //Fp2 mul real part end
    let t246 = circuit_mul(t232, t242);
    let t247 = circuit_mul(t233, t240);
    let t248 = circuit_add(t246, t247); //Fp2 mul imag part end
    let t249 = circuit_add(t245, t248);
    let t250 = circuit_sub(t245, t248);
    let t251 = circuit_mul(t249, t250);
    let t252 = circuit_mul(t245, t248);
    let t253 = circuit_add(t252, t252);
    let t254 = circuit_add(in23, in27); //Fp2 add coeff 0/1
    let t255 = circuit_add(in24, in28); //Fp2 add coeff 1/1
    let t256 = circuit_sub(t251, t254); //Fp2 sub coeff 0/1
    let t257 = circuit_sub(t253, t255); //Fp2 sub coeff 1/1
    let t258 = circuit_mul(t245, in23); //Fp2 mul start
    let t259 = circuit_mul(t248, in24);
    let t260 = circuit_sub(t258, t259); //Fp2 mul real part end
    let t261 = circuit_mul(t245, in24);
    let t262 = circuit_mul(t248, in23);
    let t263 = circuit_add(t261, t262); //Fp2 mul imag part end
    let t264 = circuit_sub(t260, in25); //Fp2 sub coeff 0/1
    let t265 = circuit_sub(t263, in26); //Fp2 sub coeff 1/1
    let t266 = circuit_sub(t264, t265);
    let t267 = circuit_mul(t266, in21);
    let t268 = circuit_sub(t245, t248);
    let t269 = circuit_mul(t268, in22);
    let t270 = circuit_mul(t265, in21);
    let t271 = circuit_mul(t248, in22);
    let t272 = circuit_add(in25, in25); //Fp2 add coeff 0/1
    let t273 = circuit_add(in26, in26); //Fp2 add coeff 1/1
    let t274 = circuit_sub(t256, in23); //Fp2 sub coeff 0/1
    let t275 = circuit_sub(t257, in24); //Fp2 sub coeff 1/1
    let t276 = circuit_mul(t274, t274); //Fp2 Div x/y start : Fp2 Inv y start
    let t277 = circuit_mul(t275, t275);
    let t278 = circuit_add(t276, t277);
    let t279 = circuit_inverse(t278);
    let t280 = circuit_mul(t274, t279); //Fp2 Inv y real part end
    let t281 = circuit_mul(t275, t279);
    let t282 = circuit_sub(in0, t281); //Fp2 Inv y imag part end
    let t283 = circuit_mul(t272, t280); //Fp2 mul start
    let t284 = circuit_mul(t273, t282);
    let t285 = circuit_sub(t283, t284); //Fp2 mul real part end
    let t286 = circuit_mul(t272, t282);
    let t287 = circuit_mul(t273, t280);
    let t288 = circuit_add(t286, t287); //Fp2 mul imag part end
    let t289 = circuit_add(t245, t285); //Fp2 add coeff 0/1
    let t290 = circuit_add(t248, t288); //Fp2 add coeff 1/1
    let t291 = circuit_sub(in0, t289); //Fp2 neg coeff 0/1
    let t292 = circuit_sub(in0, t290); //Fp2 neg coeff 1/1
    let t293 = circuit_add(t291, t292);
    let t294 = circuit_sub(t291, t292);
    let t295 = circuit_mul(t293, t294);
    let t296 = circuit_mul(t291, t292);
    let t297 = circuit_add(t296, t296);
    let t298 = circuit_sub(t295, in23); //Fp2 sub coeff 0/1
    let t299 = circuit_sub(t297, in24); //Fp2 sub coeff 1/1
    let t300 = circuit_sub(t298, t256); //Fp2 sub coeff 0/1
    let t301 = circuit_sub(t299, t257); //Fp2 sub coeff 1/1
    let t302 = circuit_sub(in23, t300); //Fp2 sub coeff 0/1
    let t303 = circuit_sub(in24, t301); //Fp2 sub coeff 1/1
    let t304 = circuit_mul(t291, t302); //Fp2 mul start
    let t305 = circuit_mul(t292, t303);
    let t306 = circuit_sub(t304, t305); //Fp2 mul real part end
    let t307 = circuit_mul(t291, t303);
    let t308 = circuit_mul(t292, t302);
    let t309 = circuit_add(t307, t308); //Fp2 mul imag part end
    let t310 = circuit_sub(t306, in25); //Fp2 sub coeff 0/1
    let t311 = circuit_sub(t309, in26); //Fp2 sub coeff 1/1
    let t312 = circuit_mul(t291, in23); //Fp2 mul start
    let t313 = circuit_mul(t292, in24);
    let t314 = circuit_sub(t312, t313); //Fp2 mul real part end
    let t315 = circuit_mul(t291, in24);
    let t316 = circuit_mul(t292, in23);
    let t317 = circuit_add(t315, t316); //Fp2 mul imag part end
    let t318 = circuit_sub(t314, in25); //Fp2 sub coeff 0/1
    let t319 = circuit_sub(t317, in26); //Fp2 sub coeff 1/1
    let t320 = circuit_sub(t318, t319);
    let t321 = circuit_mul(t320, in21);
    let t322 = circuit_sub(t291, t292);
    let t323 = circuit_mul(t322, in22);
    let t324 = circuit_mul(t319, in21);
    let t325 = circuit_mul(t292, in22);
    let t326 = circuit_mul(t269, t0);
    let t327 = circuit_add(t267, t326);
    let t328 = circuit_add(t327, t1);
    let t329 = circuit_mul(t270, t4);
    let t330 = circuit_add(t328, t329);
    let t331 = circuit_mul(t271, t6);
    let t332 = circuit_add(t330, t331);
    let t333 = circuit_mul(t231, t332);
    let t334 = circuit_mul(t323, t0);
    let t335 = circuit_add(t321, t334);
    let t336 = circuit_add(t335, t1);
    let t337 = circuit_mul(t324, t4);
    let t338 = circuit_add(t336, t337);
    let t339 = circuit_mul(t325, t6);
    let t340 = circuit_add(t338, t339);
    let t341 = circuit_mul(t333, t340);
    let t342 = circuit_mul(t341, in45);
    let t343 = circuit_mul(in34, in46);
    let t344 = circuit_add(in33, t343);
    let t345 = circuit_mul(in35, t0);
    let t346 = circuit_add(t344, t345);
    let t347 = circuit_mul(in36, t1);
    let t348 = circuit_add(t346, t347);
    let t349 = circuit_mul(in37, t2);
    let t350 = circuit_add(t348, t349);
    let t351 = circuit_mul(in38, t3);
    let t352 = circuit_add(t350, t351);
    let t353 = circuit_mul(in39, t4);
    let t354 = circuit_add(t352, t353);
    let t355 = circuit_mul(in40, t5);
    let t356 = circuit_add(t354, t355);
    let t357 = circuit_mul(in41, t6);
    let t358 = circuit_add(t356, t357);
    let t359 = circuit_mul(in42, t7);
    let t360 = circuit_add(t358, t359);
    let t361 = circuit_mul(in43, t8);
    let t362 = circuit_add(t360, t361);
    let t363 = circuit_mul(in44, t9);
    let t364 = circuit_add(t362, t363);
    let t365 = circuit_sub(t342, t364);
    let t366 = circuit_mul(t10, t365); //ci * ((Π(i,k) (Pk(z)) - Ri(z))
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
    circuit_inputs = circuit_inputs.next(u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 });
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
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 3
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 6
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 0

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
    let t0 = circuit_mul(in28, in28); //Compute z^2
    let t1 = circuit_mul(t0, in28); //Compute z^3
    let t2 = circuit_mul(t1, in28); //Compute z^4
    let t3 = circuit_mul(t2, in28); //Compute z^5
    let t4 = circuit_mul(t3, in28); //Compute z^6
    let t5 = circuit_mul(t4, in28); //Compute z^7
    let t6 = circuit_mul(t5, in28); //Compute z^8
    let t7 = circuit_mul(t6, in28); //Compute z^9
    let t8 = circuit_mul(t7, in28); //Compute z^10
    let t9 = circuit_mul(t8, in28); //Compute z^11
    let t10 = circuit_mul(in16, in28);
    let t11 = circuit_add(in15, t10);
    let t12 = circuit_mul(in17, t0);
    let t13 = circuit_add(t11, t12);
    let t14 = circuit_mul(in18, t1);
    let t15 = circuit_add(t13, t14);
    let t16 = circuit_mul(in19, t2);
    let t17 = circuit_add(t15, t16);
    let t18 = circuit_mul(in20, t3);
    let t19 = circuit_add(t17, t18);
    let t20 = circuit_mul(in21, t4);
    let t21 = circuit_add(t19, t20);
    let t22 = circuit_mul(in22, t5);
    let t23 = circuit_add(t21, t22);
    let t24 = circuit_mul(in23, t6);
    let t25 = circuit_add(t23, t24);
    let t26 = circuit_mul(in24, t7);
    let t27 = circuit_add(t25, t26);
    let t28 = circuit_mul(in25, t8);
    let t29 = circuit_add(t27, t28);
    let t30 = circuit_mul(in26, t9);
    let t31 = circuit_add(t29, t30);
    let t32 = circuit_mul(in29, in29);
    let t33 = circuit_mul(in29, t32);
    let t34 = circuit_add(in5, in6);
    let t35 = circuit_sub(in5, in6);
    let t36 = circuit_mul(t34, t35);
    let t37 = circuit_mul(in5, in6);
    let t38 = circuit_mul(t36, in0);
    let t39 = circuit_mul(t37, in1);
    let t40 = circuit_add(in7, in7); //Fp2 add coeff 0/1
    let t41 = circuit_add(in8, in8); //Fp2 add coeff 1/1
    let t42 = circuit_mul(t40, t40); //Fp2 Div x/y start : Fp2 Inv y start
    let t43 = circuit_mul(t41, t41);
    let t44 = circuit_add(t42, t43);
    let t45 = circuit_inverse(t44);
    let t46 = circuit_mul(t40, t45); //Fp2 Inv y real part end
    let t47 = circuit_mul(t41, t45);
    let t48 = circuit_sub(in2, t47); //Fp2 Inv y imag part end
    let t49 = circuit_mul(t38, t46); //Fp2 mul start
    let t50 = circuit_mul(t39, t48);
    let t51 = circuit_sub(t49, t50); //Fp2 mul real part end
    let t52 = circuit_mul(t38, t48);
    let t53 = circuit_mul(t39, t46);
    let t54 = circuit_add(t52, t53); //Fp2 mul imag part end
    let t55 = circuit_mul(t51, in5); //Fp2 mul start
    let t56 = circuit_mul(t54, in6);
    let t57 = circuit_sub(t55, t56); //Fp2 mul real part end
    let t58 = circuit_mul(t51, in6);
    let t59 = circuit_mul(t54, in5);
    let t60 = circuit_add(t58, t59); //Fp2 mul imag part end
    let t61 = circuit_sub(t57, in7); //Fp2 sub coeff 0/1
    let t62 = circuit_sub(t60, in8); //Fp2 sub coeff 1/1
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
    let t74 = circuit_add(in5, in5); //Fp2 add coeff 0/1
    let t75 = circuit_add(in6, in6); //Fp2 add coeff 1/1
    let t76 = circuit_sub(t71, t74); //Fp2 sub coeff 0/1
    let t77 = circuit_sub(t73, t75); //Fp2 sub coeff 1/1
    let t78 = circuit_sub(in5, t76); //Fp2 sub coeff 0/1
    let t79 = circuit_sub(in6, t77); //Fp2 sub coeff 1/1
    let t80 = circuit_mul(t78, t78); //Fp2 Div x/y start : Fp2 Inv y start
    let t81 = circuit_mul(t79, t79);
    let t82 = circuit_add(t80, t81);
    let t83 = circuit_inverse(t82);
    let t84 = circuit_mul(t78, t83); //Fp2 Inv y real part end
    let t85 = circuit_mul(t79, t83);
    let t86 = circuit_sub(in2, t85); //Fp2 Inv y imag part end
    let t87 = circuit_mul(t40, t84); //Fp2 mul start
    let t88 = circuit_mul(t41, t86);
    let t89 = circuit_sub(t87, t88); //Fp2 mul real part end
    let t90 = circuit_mul(t40, t86);
    let t91 = circuit_mul(t41, t84);
    let t92 = circuit_add(t90, t91); //Fp2 mul imag part end
    let t93 = circuit_sub(t89, t51); //Fp2 sub coeff 0/1
    let t94 = circuit_sub(t92, t54); //Fp2 sub coeff 1/1
    let t95 = circuit_mul(t93, in5); //Fp2 mul start
    let t96 = circuit_mul(t94, in6);
    let t97 = circuit_sub(t95, t96); //Fp2 mul real part end
    let t98 = circuit_mul(t93, in6);
    let t99 = circuit_mul(t94, in5);
    let t100 = circuit_add(t98, t99); //Fp2 mul imag part end
    let t101 = circuit_sub(t97, in7); //Fp2 sub coeff 0/1
    let t102 = circuit_sub(t100, in8); //Fp2 sub coeff 1/1
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
    let t114 = circuit_add(in5, t76); //Fp2 add coeff 0/1
    let t115 = circuit_add(in6, t77); //Fp2 add coeff 1/1
    let t116 = circuit_sub(t111, t114); //Fp2 sub coeff 0/1
    let t117 = circuit_sub(t113, t115); //Fp2 sub coeff 1/1
    let t118 = circuit_sub(in5, t116); //Fp2 sub coeff 0/1
    let t119 = circuit_sub(in6, t117); //Fp2 sub coeff 1/1
    let t120 = circuit_mul(t93, t118); //Fp2 mul start
    let t121 = circuit_mul(t94, t119);
    let t122 = circuit_sub(t120, t121); //Fp2 mul real part end
    let t123 = circuit_mul(t93, t119);
    let t124 = circuit_mul(t94, t118);
    let t125 = circuit_add(t123, t124); //Fp2 mul imag part end
    let t126 = circuit_sub(t122, in7); //Fp2 sub coeff 0/1
    let t127 = circuit_sub(t125, in8); //Fp2 sub coeff 1/1
    let t128 = circuit_mul(t66, t0);
    let t129 = circuit_add(t64, t128);
    let t130 = circuit_add(t129, t1);
    let t131 = circuit_mul(t67, t4);
    let t132 = circuit_add(t130, t131);
    let t133 = circuit_mul(t68, t6);
    let t134 = circuit_add(t132, t133);
    let t135 = circuit_mul(t33, t134);
    let t136 = circuit_mul(t106, t0);
    let t137 = circuit_add(t104, t136);
    let t138 = circuit_add(t137, t1);
    let t139 = circuit_mul(t107, t4);
    let t140 = circuit_add(t138, t139);
    let t141 = circuit_mul(t108, t6);
    let t142 = circuit_add(t140, t141);
    let t143 = circuit_mul(t135, t142);
    let t144 = circuit_add(in11, in12);
    let t145 = circuit_sub(in11, in12);
    let t146 = circuit_mul(t144, t145);
    let t147 = circuit_mul(in11, in12);
    let t148 = circuit_mul(t146, in0);
    let t149 = circuit_mul(t147, in1);
    let t150 = circuit_add(in13, in13); //Fp2 add coeff 0/1
    let t151 = circuit_add(in14, in14); //Fp2 add coeff 1/1
    let t152 = circuit_mul(t150, t150); //Fp2 Div x/y start : Fp2 Inv y start
    let t153 = circuit_mul(t151, t151);
    let t154 = circuit_add(t152, t153);
    let t155 = circuit_inverse(t154);
    let t156 = circuit_mul(t150, t155); //Fp2 Inv y real part end
    let t157 = circuit_mul(t151, t155);
    let t158 = circuit_sub(in2, t157); //Fp2 Inv y imag part end
    let t159 = circuit_mul(t148, t156); //Fp2 mul start
    let t160 = circuit_mul(t149, t158);
    let t161 = circuit_sub(t159, t160); //Fp2 mul real part end
    let t162 = circuit_mul(t148, t158);
    let t163 = circuit_mul(t149, t156);
    let t164 = circuit_add(t162, t163); //Fp2 mul imag part end
    let t165 = circuit_mul(t161, in11); //Fp2 mul start
    let t166 = circuit_mul(t164, in12);
    let t167 = circuit_sub(t165, t166); //Fp2 mul real part end
    let t168 = circuit_mul(t161, in12);
    let t169 = circuit_mul(t164, in11);
    let t170 = circuit_add(t168, t169); //Fp2 mul imag part end
    let t171 = circuit_sub(t167, in13); //Fp2 sub coeff 0/1
    let t172 = circuit_sub(t170, in14); //Fp2 sub coeff 1/1
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
    let t184 = circuit_add(in11, in11); //Fp2 add coeff 0/1
    let t185 = circuit_add(in12, in12); //Fp2 add coeff 1/1
    let t186 = circuit_sub(t181, t184); //Fp2 sub coeff 0/1
    let t187 = circuit_sub(t183, t185); //Fp2 sub coeff 1/1
    let t188 = circuit_sub(in11, t186); //Fp2 sub coeff 0/1
    let t189 = circuit_sub(in12, t187); //Fp2 sub coeff 1/1
    let t190 = circuit_mul(t188, t188); //Fp2 Div x/y start : Fp2 Inv y start
    let t191 = circuit_mul(t189, t189);
    let t192 = circuit_add(t190, t191);
    let t193 = circuit_inverse(t192);
    let t194 = circuit_mul(t188, t193); //Fp2 Inv y real part end
    let t195 = circuit_mul(t189, t193);
    let t196 = circuit_sub(in2, t195); //Fp2 Inv y imag part end
    let t197 = circuit_mul(t150, t194); //Fp2 mul start
    let t198 = circuit_mul(t151, t196);
    let t199 = circuit_sub(t197, t198); //Fp2 mul real part end
    let t200 = circuit_mul(t150, t196);
    let t201 = circuit_mul(t151, t194);
    let t202 = circuit_add(t200, t201); //Fp2 mul imag part end
    let t203 = circuit_sub(t199, t161); //Fp2 sub coeff 0/1
    let t204 = circuit_sub(t202, t164); //Fp2 sub coeff 1/1
    let t205 = circuit_mul(t203, in11); //Fp2 mul start
    let t206 = circuit_mul(t204, in12);
    let t207 = circuit_sub(t205, t206); //Fp2 mul real part end
    let t208 = circuit_mul(t203, in12);
    let t209 = circuit_mul(t204, in11);
    let t210 = circuit_add(t208, t209); //Fp2 mul imag part end
    let t211 = circuit_sub(t207, in13); //Fp2 sub coeff 0/1
    let t212 = circuit_sub(t210, in14); //Fp2 sub coeff 1/1
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
    let t224 = circuit_add(in11, t186); //Fp2 add coeff 0/1
    let t225 = circuit_add(in12, t187); //Fp2 add coeff 1/1
    let t226 = circuit_sub(t221, t224); //Fp2 sub coeff 0/1
    let t227 = circuit_sub(t223, t225); //Fp2 sub coeff 1/1
    let t228 = circuit_sub(in11, t226); //Fp2 sub coeff 0/1
    let t229 = circuit_sub(in12, t227); //Fp2 sub coeff 1/1
    let t230 = circuit_mul(t203, t228); //Fp2 mul start
    let t231 = circuit_mul(t204, t229);
    let t232 = circuit_sub(t230, t231); //Fp2 mul real part end
    let t233 = circuit_mul(t203, t229);
    let t234 = circuit_mul(t204, t228);
    let t235 = circuit_add(t233, t234); //Fp2 mul imag part end
    let t236 = circuit_sub(t232, in13); //Fp2 sub coeff 0/1
    let t237 = circuit_sub(t235, in14); //Fp2 sub coeff 1/1
    let t238 = circuit_mul(t176, t0);
    let t239 = circuit_add(t174, t238);
    let t240 = circuit_add(t239, t1);
    let t241 = circuit_mul(t177, t4);
    let t242 = circuit_add(t240, t241);
    let t243 = circuit_mul(t178, t6);
    let t244 = circuit_add(t242, t243);
    let t245 = circuit_mul(t143, t244);
    let t246 = circuit_mul(t216, t0);
    let t247 = circuit_add(t214, t246);
    let t248 = circuit_add(t247, t1);
    let t249 = circuit_mul(t217, t4);
    let t250 = circuit_add(t248, t249);
    let t251 = circuit_mul(t218, t6);
    let t252 = circuit_add(t250, t251);
    let t253 = circuit_mul(t245, t252);
    let t254 = circuit_sub(t253, t31);
    let t255 = circuit_mul(in27, t254); //ci * ((Π(i,k) (Pk(z)) - Ri(z))

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
    circuit_inputs = circuit_inputs.next(u384 { limb0: 3, limb1: 0, limb2: 0, limb3: 0 });
    circuit_inputs = circuit_inputs.next(u384 { limb0: 6, limb1: 0, limb2: 0, limb3: 0 });
    circuit_inputs = circuit_inputs.next(u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 });
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
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 3
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 6
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 0

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
    let t0 = circuit_mul(in34, in34); //Compute z^2
    let t1 = circuit_mul(t0, in34); //Compute z^3
    let t2 = circuit_mul(t1, in34); //Compute z^4
    let t3 = circuit_mul(t2, in34); //Compute z^5
    let t4 = circuit_mul(t3, in34); //Compute z^6
    let t5 = circuit_mul(t4, in34); //Compute z^7
    let t6 = circuit_mul(t5, in34); //Compute z^8
    let t7 = circuit_mul(t6, in34); //Compute z^9
    let t8 = circuit_mul(t7, in34); //Compute z^10
    let t9 = circuit_mul(t8, in34); //Compute z^11
    let t10 = circuit_mul(in22, in34);
    let t11 = circuit_add(in21, t10);
    let t12 = circuit_mul(in23, t0);
    let t13 = circuit_add(t11, t12);
    let t14 = circuit_mul(in24, t1);
    let t15 = circuit_add(t13, t14);
    let t16 = circuit_mul(in25, t2);
    let t17 = circuit_add(t15, t16);
    let t18 = circuit_mul(in26, t3);
    let t19 = circuit_add(t17, t18);
    let t20 = circuit_mul(in27, t4);
    let t21 = circuit_add(t19, t20);
    let t22 = circuit_mul(in28, t5);
    let t23 = circuit_add(t21, t22);
    let t24 = circuit_mul(in29, t6);
    let t25 = circuit_add(t23, t24);
    let t26 = circuit_mul(in30, t7);
    let t27 = circuit_add(t25, t26);
    let t28 = circuit_mul(in31, t8);
    let t29 = circuit_add(t27, t28);
    let t30 = circuit_mul(in32, t9);
    let t31 = circuit_add(t29, t30);
    let t32 = circuit_mul(in35, in35);
    let t33 = circuit_mul(in35, t32);
    let t34 = circuit_add(in5, in6);
    let t35 = circuit_sub(in5, in6);
    let t36 = circuit_mul(t34, t35);
    let t37 = circuit_mul(in5, in6);
    let t38 = circuit_mul(t36, in0);
    let t39 = circuit_mul(t37, in1);
    let t40 = circuit_add(in7, in7); //Fp2 add coeff 0/1
    let t41 = circuit_add(in8, in8); //Fp2 add coeff 1/1
    let t42 = circuit_mul(t40, t40); //Fp2 Div x/y start : Fp2 Inv y start
    let t43 = circuit_mul(t41, t41);
    let t44 = circuit_add(t42, t43);
    let t45 = circuit_inverse(t44);
    let t46 = circuit_mul(t40, t45); //Fp2 Inv y real part end
    let t47 = circuit_mul(t41, t45);
    let t48 = circuit_sub(in2, t47); //Fp2 Inv y imag part end
    let t49 = circuit_mul(t38, t46); //Fp2 mul start
    let t50 = circuit_mul(t39, t48);
    let t51 = circuit_sub(t49, t50); //Fp2 mul real part end
    let t52 = circuit_mul(t38, t48);
    let t53 = circuit_mul(t39, t46);
    let t54 = circuit_add(t52, t53); //Fp2 mul imag part end
    let t55 = circuit_mul(t51, in5); //Fp2 mul start
    let t56 = circuit_mul(t54, in6);
    let t57 = circuit_sub(t55, t56); //Fp2 mul real part end
    let t58 = circuit_mul(t51, in6);
    let t59 = circuit_mul(t54, in5);
    let t60 = circuit_add(t58, t59); //Fp2 mul imag part end
    let t61 = circuit_sub(t57, in7); //Fp2 sub coeff 0/1
    let t62 = circuit_sub(t60, in8); //Fp2 sub coeff 1/1
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
    let t74 = circuit_add(in5, in5); //Fp2 add coeff 0/1
    let t75 = circuit_add(in6, in6); //Fp2 add coeff 1/1
    let t76 = circuit_sub(t71, t74); //Fp2 sub coeff 0/1
    let t77 = circuit_sub(t73, t75); //Fp2 sub coeff 1/1
    let t78 = circuit_sub(in5, t76); //Fp2 sub coeff 0/1
    let t79 = circuit_sub(in6, t77); //Fp2 sub coeff 1/1
    let t80 = circuit_mul(t78, t78); //Fp2 Div x/y start : Fp2 Inv y start
    let t81 = circuit_mul(t79, t79);
    let t82 = circuit_add(t80, t81);
    let t83 = circuit_inverse(t82);
    let t84 = circuit_mul(t78, t83); //Fp2 Inv y real part end
    let t85 = circuit_mul(t79, t83);
    let t86 = circuit_sub(in2, t85); //Fp2 Inv y imag part end
    let t87 = circuit_mul(t40, t84); //Fp2 mul start
    let t88 = circuit_mul(t41, t86);
    let t89 = circuit_sub(t87, t88); //Fp2 mul real part end
    let t90 = circuit_mul(t40, t86);
    let t91 = circuit_mul(t41, t84);
    let t92 = circuit_add(t90, t91); //Fp2 mul imag part end
    let t93 = circuit_sub(t89, t51); //Fp2 sub coeff 0/1
    let t94 = circuit_sub(t92, t54); //Fp2 sub coeff 1/1
    let t95 = circuit_mul(t93, in5); //Fp2 mul start
    let t96 = circuit_mul(t94, in6);
    let t97 = circuit_sub(t95, t96); //Fp2 mul real part end
    let t98 = circuit_mul(t93, in6);
    let t99 = circuit_mul(t94, in5);
    let t100 = circuit_add(t98, t99); //Fp2 mul imag part end
    let t101 = circuit_sub(t97, in7); //Fp2 sub coeff 0/1
    let t102 = circuit_sub(t100, in8); //Fp2 sub coeff 1/1
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
    let t114 = circuit_add(in5, t76); //Fp2 add coeff 0/1
    let t115 = circuit_add(in6, t77); //Fp2 add coeff 1/1
    let t116 = circuit_sub(t111, t114); //Fp2 sub coeff 0/1
    let t117 = circuit_sub(t113, t115); //Fp2 sub coeff 1/1
    let t118 = circuit_sub(in5, t116); //Fp2 sub coeff 0/1
    let t119 = circuit_sub(in6, t117); //Fp2 sub coeff 1/1
    let t120 = circuit_mul(t93, t118); //Fp2 mul start
    let t121 = circuit_mul(t94, t119);
    let t122 = circuit_sub(t120, t121); //Fp2 mul real part end
    let t123 = circuit_mul(t93, t119);
    let t124 = circuit_mul(t94, t118);
    let t125 = circuit_add(t123, t124); //Fp2 mul imag part end
    let t126 = circuit_sub(t122, in7); //Fp2 sub coeff 0/1
    let t127 = circuit_sub(t125, in8); //Fp2 sub coeff 1/1
    let t128 = circuit_mul(t66, t0);
    let t129 = circuit_add(t64, t128);
    let t130 = circuit_add(t129, t1);
    let t131 = circuit_mul(t67, t4);
    let t132 = circuit_add(t130, t131);
    let t133 = circuit_mul(t68, t6);
    let t134 = circuit_add(t132, t133);
    let t135 = circuit_mul(t33, t134);
    let t136 = circuit_mul(t106, t0);
    let t137 = circuit_add(t104, t136);
    let t138 = circuit_add(t137, t1);
    let t139 = circuit_mul(t107, t4);
    let t140 = circuit_add(t138, t139);
    let t141 = circuit_mul(t108, t6);
    let t142 = circuit_add(t140, t141);
    let t143 = circuit_mul(t135, t142);
    let t144 = circuit_add(in11, in12);
    let t145 = circuit_sub(in11, in12);
    let t146 = circuit_mul(t144, t145);
    let t147 = circuit_mul(in11, in12);
    let t148 = circuit_mul(t146, in0);
    let t149 = circuit_mul(t147, in1);
    let t150 = circuit_add(in13, in13); //Fp2 add coeff 0/1
    let t151 = circuit_add(in14, in14); //Fp2 add coeff 1/1
    let t152 = circuit_mul(t150, t150); //Fp2 Div x/y start : Fp2 Inv y start
    let t153 = circuit_mul(t151, t151);
    let t154 = circuit_add(t152, t153);
    let t155 = circuit_inverse(t154);
    let t156 = circuit_mul(t150, t155); //Fp2 Inv y real part end
    let t157 = circuit_mul(t151, t155);
    let t158 = circuit_sub(in2, t157); //Fp2 Inv y imag part end
    let t159 = circuit_mul(t148, t156); //Fp2 mul start
    let t160 = circuit_mul(t149, t158);
    let t161 = circuit_sub(t159, t160); //Fp2 mul real part end
    let t162 = circuit_mul(t148, t158);
    let t163 = circuit_mul(t149, t156);
    let t164 = circuit_add(t162, t163); //Fp2 mul imag part end
    let t165 = circuit_mul(t161, in11); //Fp2 mul start
    let t166 = circuit_mul(t164, in12);
    let t167 = circuit_sub(t165, t166); //Fp2 mul real part end
    let t168 = circuit_mul(t161, in12);
    let t169 = circuit_mul(t164, in11);
    let t170 = circuit_add(t168, t169); //Fp2 mul imag part end
    let t171 = circuit_sub(t167, in13); //Fp2 sub coeff 0/1
    let t172 = circuit_sub(t170, in14); //Fp2 sub coeff 1/1
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
    let t184 = circuit_add(in11, in11); //Fp2 add coeff 0/1
    let t185 = circuit_add(in12, in12); //Fp2 add coeff 1/1
    let t186 = circuit_sub(t181, t184); //Fp2 sub coeff 0/1
    let t187 = circuit_sub(t183, t185); //Fp2 sub coeff 1/1
    let t188 = circuit_sub(in11, t186); //Fp2 sub coeff 0/1
    let t189 = circuit_sub(in12, t187); //Fp2 sub coeff 1/1
    let t190 = circuit_mul(t188, t188); //Fp2 Div x/y start : Fp2 Inv y start
    let t191 = circuit_mul(t189, t189);
    let t192 = circuit_add(t190, t191);
    let t193 = circuit_inverse(t192);
    let t194 = circuit_mul(t188, t193); //Fp2 Inv y real part end
    let t195 = circuit_mul(t189, t193);
    let t196 = circuit_sub(in2, t195); //Fp2 Inv y imag part end
    let t197 = circuit_mul(t150, t194); //Fp2 mul start
    let t198 = circuit_mul(t151, t196);
    let t199 = circuit_sub(t197, t198); //Fp2 mul real part end
    let t200 = circuit_mul(t150, t196);
    let t201 = circuit_mul(t151, t194);
    let t202 = circuit_add(t200, t201); //Fp2 mul imag part end
    let t203 = circuit_sub(t199, t161); //Fp2 sub coeff 0/1
    let t204 = circuit_sub(t202, t164); //Fp2 sub coeff 1/1
    let t205 = circuit_mul(t203, in11); //Fp2 mul start
    let t206 = circuit_mul(t204, in12);
    let t207 = circuit_sub(t205, t206); //Fp2 mul real part end
    let t208 = circuit_mul(t203, in12);
    let t209 = circuit_mul(t204, in11);
    let t210 = circuit_add(t208, t209); //Fp2 mul imag part end
    let t211 = circuit_sub(t207, in13); //Fp2 sub coeff 0/1
    let t212 = circuit_sub(t210, in14); //Fp2 sub coeff 1/1
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
    let t224 = circuit_add(in11, t186); //Fp2 add coeff 0/1
    let t225 = circuit_add(in12, t187); //Fp2 add coeff 1/1
    let t226 = circuit_sub(t221, t224); //Fp2 sub coeff 0/1
    let t227 = circuit_sub(t223, t225); //Fp2 sub coeff 1/1
    let t228 = circuit_sub(in11, t226); //Fp2 sub coeff 0/1
    let t229 = circuit_sub(in12, t227); //Fp2 sub coeff 1/1
    let t230 = circuit_mul(t203, t228); //Fp2 mul start
    let t231 = circuit_mul(t204, t229);
    let t232 = circuit_sub(t230, t231); //Fp2 mul real part end
    let t233 = circuit_mul(t203, t229);
    let t234 = circuit_mul(t204, t228);
    let t235 = circuit_add(t233, t234); //Fp2 mul imag part end
    let t236 = circuit_sub(t232, in13); //Fp2 sub coeff 0/1
    let t237 = circuit_sub(t235, in14); //Fp2 sub coeff 1/1
    let t238 = circuit_mul(t176, t0);
    let t239 = circuit_add(t174, t238);
    let t240 = circuit_add(t239, t1);
    let t241 = circuit_mul(t177, t4);
    let t242 = circuit_add(t240, t241);
    let t243 = circuit_mul(t178, t6);
    let t244 = circuit_add(t242, t243);
    let t245 = circuit_mul(t143, t244);
    let t246 = circuit_mul(t216, t0);
    let t247 = circuit_add(t214, t246);
    let t248 = circuit_add(t247, t1);
    let t249 = circuit_mul(t217, t4);
    let t250 = circuit_add(t248, t249);
    let t251 = circuit_mul(t218, t6);
    let t252 = circuit_add(t250, t251);
    let t253 = circuit_mul(t245, t252);
    let t254 = circuit_add(in17, in18);
    let t255 = circuit_sub(in17, in18);
    let t256 = circuit_mul(t254, t255);
    let t257 = circuit_mul(in17, in18);
    let t258 = circuit_mul(t256, in0);
    let t259 = circuit_mul(t257, in1);
    let t260 = circuit_add(in19, in19); //Fp2 add coeff 0/1
    let t261 = circuit_add(in20, in20); //Fp2 add coeff 1/1
    let t262 = circuit_mul(t260, t260); //Fp2 Div x/y start : Fp2 Inv y start
    let t263 = circuit_mul(t261, t261);
    let t264 = circuit_add(t262, t263);
    let t265 = circuit_inverse(t264);
    let t266 = circuit_mul(t260, t265); //Fp2 Inv y real part end
    let t267 = circuit_mul(t261, t265);
    let t268 = circuit_sub(in2, t267); //Fp2 Inv y imag part end
    let t269 = circuit_mul(t258, t266); //Fp2 mul start
    let t270 = circuit_mul(t259, t268);
    let t271 = circuit_sub(t269, t270); //Fp2 mul real part end
    let t272 = circuit_mul(t258, t268);
    let t273 = circuit_mul(t259, t266);
    let t274 = circuit_add(t272, t273); //Fp2 mul imag part end
    let t275 = circuit_mul(t271, in17); //Fp2 mul start
    let t276 = circuit_mul(t274, in18);
    let t277 = circuit_sub(t275, t276); //Fp2 mul real part end
    let t278 = circuit_mul(t271, in18);
    let t279 = circuit_mul(t274, in17);
    let t280 = circuit_add(t278, t279); //Fp2 mul imag part end
    let t281 = circuit_sub(t277, in19); //Fp2 sub coeff 0/1
    let t282 = circuit_sub(t280, in20); //Fp2 sub coeff 1/1
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
    let t294 = circuit_add(in17, in17); //Fp2 add coeff 0/1
    let t295 = circuit_add(in18, in18); //Fp2 add coeff 1/1
    let t296 = circuit_sub(t291, t294); //Fp2 sub coeff 0/1
    let t297 = circuit_sub(t293, t295); //Fp2 sub coeff 1/1
    let t298 = circuit_sub(in17, t296); //Fp2 sub coeff 0/1
    let t299 = circuit_sub(in18, t297); //Fp2 sub coeff 1/1
    let t300 = circuit_mul(t298, t298); //Fp2 Div x/y start : Fp2 Inv y start
    let t301 = circuit_mul(t299, t299);
    let t302 = circuit_add(t300, t301);
    let t303 = circuit_inverse(t302);
    let t304 = circuit_mul(t298, t303); //Fp2 Inv y real part end
    let t305 = circuit_mul(t299, t303);
    let t306 = circuit_sub(in2, t305); //Fp2 Inv y imag part end
    let t307 = circuit_mul(t260, t304); //Fp2 mul start
    let t308 = circuit_mul(t261, t306);
    let t309 = circuit_sub(t307, t308); //Fp2 mul real part end
    let t310 = circuit_mul(t260, t306);
    let t311 = circuit_mul(t261, t304);
    let t312 = circuit_add(t310, t311); //Fp2 mul imag part end
    let t313 = circuit_sub(t309, t271); //Fp2 sub coeff 0/1
    let t314 = circuit_sub(t312, t274); //Fp2 sub coeff 1/1
    let t315 = circuit_mul(t313, in17); //Fp2 mul start
    let t316 = circuit_mul(t314, in18);
    let t317 = circuit_sub(t315, t316); //Fp2 mul real part end
    let t318 = circuit_mul(t313, in18);
    let t319 = circuit_mul(t314, in17);
    let t320 = circuit_add(t318, t319); //Fp2 mul imag part end
    let t321 = circuit_sub(t317, in19); //Fp2 sub coeff 0/1
    let t322 = circuit_sub(t320, in20); //Fp2 sub coeff 1/1
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
    let t334 = circuit_add(in17, t296); //Fp2 add coeff 0/1
    let t335 = circuit_add(in18, t297); //Fp2 add coeff 1/1
    let t336 = circuit_sub(t331, t334); //Fp2 sub coeff 0/1
    let t337 = circuit_sub(t333, t335); //Fp2 sub coeff 1/1
    let t338 = circuit_sub(in17, t336); //Fp2 sub coeff 0/1
    let t339 = circuit_sub(in18, t337); //Fp2 sub coeff 1/1
    let t340 = circuit_mul(t313, t338); //Fp2 mul start
    let t341 = circuit_mul(t314, t339);
    let t342 = circuit_sub(t340, t341); //Fp2 mul real part end
    let t343 = circuit_mul(t313, t339);
    let t344 = circuit_mul(t314, t338);
    let t345 = circuit_add(t343, t344); //Fp2 mul imag part end
    let t346 = circuit_sub(t342, in19); //Fp2 sub coeff 0/1
    let t347 = circuit_sub(t345, in20); //Fp2 sub coeff 1/1
    let t348 = circuit_mul(t286, t0);
    let t349 = circuit_add(t284, t348);
    let t350 = circuit_add(t349, t1);
    let t351 = circuit_mul(t287, t4);
    let t352 = circuit_add(t350, t351);
    let t353 = circuit_mul(t288, t6);
    let t354 = circuit_add(t352, t353);
    let t355 = circuit_mul(t253, t354);
    let t356 = circuit_mul(t326, t0);
    let t357 = circuit_add(t324, t356);
    let t358 = circuit_add(t357, t1);
    let t359 = circuit_mul(t327, t4);
    let t360 = circuit_add(t358, t359);
    let t361 = circuit_mul(t328, t6);
    let t362 = circuit_add(t360, t361);
    let t363 = circuit_mul(t355, t362);
    let t364 = circuit_sub(t363, t31);
    let t365 = circuit_mul(in33, t364); //ci * ((Π(i,k) (Pk(z)) - Ri(z))

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
    circuit_inputs = circuit_inputs.next(u384 { limb0: 3, limb1: 0, limb2: 0, limb3: 0 });
    circuit_inputs = circuit_inputs.next(u384 { limb0: 6, limb1: 0, limb2: 0, limb3: 0 });
    circuit_inputs = circuit_inputs.next(u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 });
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
    lambda_root_inverse: E12D, z: u384
) -> (u384,) {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0

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
    let t0 = circuit_mul(in13, in13); //Compute z^2
    let t1 = circuit_mul(t0, in13); //Compute z^3
    let t2 = circuit_mul(t1, in13); //Compute z^4
    let t3 = circuit_mul(t2, in13); //Compute z^5
    let t4 = circuit_mul(t3, in13); //Compute z^6
    let t5 = circuit_mul(t4, in13); //Compute z^7
    let t6 = circuit_mul(t5, in13); //Compute z^8
    let t7 = circuit_mul(t6, in13); //Compute z^9
    let t8 = circuit_mul(t7, in13); //Compute z^10
    let t9 = circuit_mul(t8, in13); //Compute z^11
    let t10 = circuit_sub(in0, in2);
    let t11 = circuit_sub(in0, in4);
    let t12 = circuit_sub(in0, in6);
    let t13 = circuit_sub(in0, in8);
    let t14 = circuit_sub(in0, in10);
    let t15 = circuit_sub(in0, in12);
    let t16 = circuit_mul(t10, in13);
    let t17 = circuit_add(in1, t16);
    let t18 = circuit_mul(in3, t0);
    let t19 = circuit_add(t17, t18);
    let t20 = circuit_mul(t11, t1);
    let t21 = circuit_add(t19, t20);
    let t22 = circuit_mul(in5, t2);
    let t23 = circuit_add(t21, t22);
    let t24 = circuit_mul(t12, t3);
    let t25 = circuit_add(t23, t24);
    let t26 = circuit_mul(in7, t4);
    let t27 = circuit_add(t25, t26);
    let t28 = circuit_mul(t13, t5);
    let t29 = circuit_add(t27, t28);
    let t30 = circuit_mul(in9, t6);
    let t31 = circuit_add(t29, t30);
    let t32 = circuit_mul(t14, t7);
    let t33 = circuit_add(t31, t32);
    let t34 = circuit_mul(in11, t8);
    let t35 = circuit_add(t33, t34);
    let t36 = circuit_mul(t15, t9);
    let t37 = circuit_add(t35, t36);

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

    let mut circuit_inputs = (t37,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next(u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 });
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

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let c_inv_of_z: u384 = outputs.get_output(t37);
    return (c_inv_of_z,);
}
fn run_BLS12_381_MP_CHECK_PREPARE_PAIRS_2_circuit(
    p_0: G1Point, p_1: G1Point
) -> (BLSProcessedPair, BLSProcessedPair) {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0

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
    circuit_inputs = circuit_inputs.next(u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 });
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
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0

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
    circuit_inputs = circuit_inputs.next(u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 });
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
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 3
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 6
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 0
    let in3 = CircuitElement::<
        CircuitInput<3>
    > {}; // 21888242871839275222246405745257275088696311157297823662689037894645226208574
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 1

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
    let t0 = circuit_mul(in32, in32); //Compute z^2
    let t1 = circuit_mul(t0, in32); //Compute z^3
    let t2 = circuit_mul(t1, in32); //Compute z^4
    let t3 = circuit_mul(t2, in32); //Compute z^5
    let t4 = circuit_mul(t3, in32); //Compute z^6
    let t5 = circuit_mul(t4, in32); //Compute z^7
    let t6 = circuit_mul(t5, in32); //Compute z^8
    let t7 = circuit_mul(t6, in32); //Compute z^9
    let t8 = circuit_mul(t7, in32); //Compute z^10
    let t9 = circuit_mul(t8, in32); //Compute z^11
    let t10 = circuit_mul(in31, in31); //Compute c_i = (c_(i-1))^2
    let t11 = circuit_mul(in18, in18); //Square f evaluation in Z, the result of previous bit.
    let t12 = circuit_add(in7, in8); //Doubling slope numerator start
    let t13 = circuit_sub(in7, in8);
    let t14 = circuit_mul(t12, t13);
    let t15 = circuit_mul(in7, in8);
    let t16 = circuit_mul(t14, in0);
    let t17 = circuit_mul(t15, in1); //Doubling slope numerator end
    let t18 = circuit_add(in9, in9); //Fp2 add coeff 0/1
    let t19 = circuit_add(in10, in10); //Fp2 add coeff 1/1
    let t20 = circuit_mul(t18, t18); //Fp2 Div x/y start : Fp2 Inv y start
    let t21 = circuit_mul(t19, t19);
    let t22 = circuit_add(t20, t21);
    let t23 = circuit_inverse(t22);
    let t24 = circuit_mul(t18, t23); //Fp2 Inv y real part end
    let t25 = circuit_mul(t19, t23);
    let t26 = circuit_sub(in2, t25); //Fp2 Inv y imag part end
    let t27 = circuit_mul(t16, t24); //Fp2 mul start
    let t28 = circuit_mul(t17, t26);
    let t29 = circuit_sub(t27, t28); //Fp2 mul real part end
    let t30 = circuit_mul(t16, t26);
    let t31 = circuit_mul(t17, t24);
    let t32 = circuit_add(t30, t31); //Fp2 mul imag part end
    let t33 = circuit_add(t29, t32);
    let t34 = circuit_sub(t29, t32);
    let t35 = circuit_mul(t33, t34);
    let t36 = circuit_mul(t29, t32);
    let t37 = circuit_add(t36, t36);
    let t38 = circuit_add(in7, in7); //Fp2 add coeff 0/1
    let t39 = circuit_add(in8, in8); //Fp2 add coeff 1/1
    let t40 = circuit_sub(t35, t38); //Fp2 sub coeff 0/1
    let t41 = circuit_sub(t37, t39); //Fp2 sub coeff 1/1
    let t42 = circuit_sub(in7, t40); //Fp2 sub coeff 0/1
    let t43 = circuit_sub(in8, t41); //Fp2 sub coeff 1/1
    let t44 = circuit_mul(t29, t42); //Fp2 mul start
    let t45 = circuit_mul(t32, t43);
    let t46 = circuit_sub(t44, t45); //Fp2 mul real part end
    let t47 = circuit_mul(t29, t43);
    let t48 = circuit_mul(t32, t42);
    let t49 = circuit_add(t47, t48); //Fp2 mul imag part end
    let t50 = circuit_sub(t46, in9); //Fp2 sub coeff 0/1
    let t51 = circuit_sub(t49, in10); //Fp2 sub coeff 1/1
    let t52 = circuit_mul(t29, in7); //Fp2 mul start
    let t53 = circuit_mul(t32, in8);
    let t54 = circuit_sub(t52, t53); //Fp2 mul real part end
    let t55 = circuit_mul(t29, in8);
    let t56 = circuit_mul(t32, in7);
    let t57 = circuit_add(t55, t56); //Fp2 mul imag part end
    let t58 = circuit_sub(t54, in9); //Fp2 sub coeff 0/1
    let t59 = circuit_sub(t57, in10); //Fp2 sub coeff 1/1
    let t60 = circuit_mul(in3, t32);
    let t61 = circuit_add(t29, t60);
    let t62 = circuit_mul(t61, in6);
    let t63 = circuit_mul(in3, t59);
    let t64 = circuit_add(t58, t63);
    let t65 = circuit_mul(t64, in5);
    let t66 = circuit_mul(t32, in6);
    let t67 = circuit_mul(t59, in5);
    let t68 = circuit_mul(t62, in32);
    let t69 = circuit_add(in4, t68);
    let t70 = circuit_mul(t65, t1);
    let t71 = circuit_add(t69, t70);
    let t72 = circuit_mul(t66, t5);
    let t73 = circuit_add(t71, t72);
    let t74 = circuit_mul(t67, t7);
    let t75 = circuit_add(t73, t74);
    let t76 = circuit_mul(t11, t75); //Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_0(z)
    let t77 = circuit_add(in13, in14); //Doubling slope numerator start
    let t78 = circuit_sub(in13, in14);
    let t79 = circuit_mul(t77, t78);
    let t80 = circuit_mul(in13, in14);
    let t81 = circuit_mul(t79, in0);
    let t82 = circuit_mul(t80, in1); //Doubling slope numerator end
    let t83 = circuit_add(in15, in15); //Fp2 add coeff 0/1
    let t84 = circuit_add(in16, in16); //Fp2 add coeff 1/1
    let t85 = circuit_mul(t83, t83); //Fp2 Div x/y start : Fp2 Inv y start
    let t86 = circuit_mul(t84, t84);
    let t87 = circuit_add(t85, t86);
    let t88 = circuit_inverse(t87);
    let t89 = circuit_mul(t83, t88); //Fp2 Inv y real part end
    let t90 = circuit_mul(t84, t88);
    let t91 = circuit_sub(in2, t90); //Fp2 Inv y imag part end
    let t92 = circuit_mul(t81, t89); //Fp2 mul start
    let t93 = circuit_mul(t82, t91);
    let t94 = circuit_sub(t92, t93); //Fp2 mul real part end
    let t95 = circuit_mul(t81, t91);
    let t96 = circuit_mul(t82, t89);
    let t97 = circuit_add(t95, t96); //Fp2 mul imag part end
    let t98 = circuit_add(t94, t97);
    let t99 = circuit_sub(t94, t97);
    let t100 = circuit_mul(t98, t99);
    let t101 = circuit_mul(t94, t97);
    let t102 = circuit_add(t101, t101);
    let t103 = circuit_add(in13, in13); //Fp2 add coeff 0/1
    let t104 = circuit_add(in14, in14); //Fp2 add coeff 1/1
    let t105 = circuit_sub(t100, t103); //Fp2 sub coeff 0/1
    let t106 = circuit_sub(t102, t104); //Fp2 sub coeff 1/1
    let t107 = circuit_sub(in13, t105); //Fp2 sub coeff 0/1
    let t108 = circuit_sub(in14, t106); //Fp2 sub coeff 1/1
    let t109 = circuit_mul(t94, t107); //Fp2 mul start
    let t110 = circuit_mul(t97, t108);
    let t111 = circuit_sub(t109, t110); //Fp2 mul real part end
    let t112 = circuit_mul(t94, t108);
    let t113 = circuit_mul(t97, t107);
    let t114 = circuit_add(t112, t113); //Fp2 mul imag part end
    let t115 = circuit_sub(t111, in15); //Fp2 sub coeff 0/1
    let t116 = circuit_sub(t114, in16); //Fp2 sub coeff 1/1
    let t117 = circuit_mul(t94, in13); //Fp2 mul start
    let t118 = circuit_mul(t97, in14);
    let t119 = circuit_sub(t117, t118); //Fp2 mul real part end
    let t120 = circuit_mul(t94, in14);
    let t121 = circuit_mul(t97, in13);
    let t122 = circuit_add(t120, t121); //Fp2 mul imag part end
    let t123 = circuit_sub(t119, in15); //Fp2 sub coeff 0/1
    let t124 = circuit_sub(t122, in16); //Fp2 sub coeff 1/1
    let t125 = circuit_mul(in3, t97);
    let t126 = circuit_add(t94, t125);
    let t127 = circuit_mul(t126, in12);
    let t128 = circuit_mul(in3, t124);
    let t129 = circuit_add(t123, t128);
    let t130 = circuit_mul(t129, in11);
    let t131 = circuit_mul(t97, in12);
    let t132 = circuit_mul(t124, in11);
    let t133 = circuit_mul(t127, in32);
    let t134 = circuit_add(in4, t133);
    let t135 = circuit_mul(t130, t1);
    let t136 = circuit_add(t134, t135);
    let t137 = circuit_mul(t131, t5);
    let t138 = circuit_add(t136, t137);
    let t139 = circuit_mul(t132, t7);
    let t140 = circuit_add(t138, t139);
    let t141 = circuit_mul(t76, t140); //Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_1(z)
    let t142 = circuit_mul(in20, in32);
    let t143 = circuit_add(in19, t142);
    let t144 = circuit_mul(in21, t0);
    let t145 = circuit_add(t143, t144);
    let t146 = circuit_mul(in22, t1);
    let t147 = circuit_add(t145, t146);
    let t148 = circuit_mul(in23, t2);
    let t149 = circuit_add(t147, t148);
    let t150 = circuit_mul(in24, t3);
    let t151 = circuit_add(t149, t150);
    let t152 = circuit_mul(in25, t4);
    let t153 = circuit_add(t151, t152);
    let t154 = circuit_mul(in26, t5);
    let t155 = circuit_add(t153, t154);
    let t156 = circuit_mul(in27, t6);
    let t157 = circuit_add(t155, t156);
    let t158 = circuit_mul(in28, t7);
    let t159 = circuit_add(t157, t158);
    let t160 = circuit_mul(in29, t8);
    let t161 = circuit_add(t159, t160);
    let t162 = circuit_mul(in30, t9);
    let t163 = circuit_add(t161, t162);
    let t164 = circuit_sub(t141, t163);
    let t165 = circuit_mul(t10, t164); //ci * ((Π(i,k) (Pk(z)) - Ri(z))
    let t166 = circuit_add(in17, t165); //LHS = LHS + ci * ((Π(i,k) (Pk(z)) - Ri(z))

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [32324006162389411176778628423, 57042285082623239461879769745, 3486998266802970665, 0]
    )
        .unwrap();

    let mut circuit_inputs = (t40, t41, t50, t51, t105, t106, t115, t116, t163, t166, t10,)
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next(u384 { limb0: 3, limb1: 0, limb2: 0, limb3: 0 });
    circuit_inputs = circuit_inputs.next(u384 { limb0: 6, limb1: 0, limb2: 0, limb3: 0 });
    circuit_inputs = circuit_inputs.next(u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 });
    circuit_inputs = circuit_inputs
        .next(
            u384 {
                limb0: 32324006162389411176778628414,
                limb1: 57042285082623239461879769745,
                limb2: 3486998266802970665,
                limb3: 0
            }
        );
    circuit_inputs = circuit_inputs.next(u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 });
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
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 3
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 6
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 0
    let in3 = CircuitElement::<
        CircuitInput<3>
    > {}; // 21888242871839275222246405745257275088696311157297823662689037894645226208574
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 1

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
    let t0 = circuit_mul(in38, in38); //Compute z^2
    let t1 = circuit_mul(t0, in38); //Compute z^3
    let t2 = circuit_mul(t1, in38); //Compute z^4
    let t3 = circuit_mul(t2, in38); //Compute z^5
    let t4 = circuit_mul(t3, in38); //Compute z^6
    let t5 = circuit_mul(t4, in38); //Compute z^7
    let t6 = circuit_mul(t5, in38); //Compute z^8
    let t7 = circuit_mul(t6, in38); //Compute z^9
    let t8 = circuit_mul(t7, in38); //Compute z^10
    let t9 = circuit_mul(t8, in38); //Compute z^11
    let t10 = circuit_mul(in37, in37); //Compute c_i = (c_(i-1))^2
    let t11 = circuit_mul(in24, in24); //Square f evaluation in Z, the result of previous bit.
    let t12 = circuit_add(in7, in8); //Doubling slope numerator start
    let t13 = circuit_sub(in7, in8);
    let t14 = circuit_mul(t12, t13);
    let t15 = circuit_mul(in7, in8);
    let t16 = circuit_mul(t14, in0);
    let t17 = circuit_mul(t15, in1); //Doubling slope numerator end
    let t18 = circuit_add(in9, in9); //Fp2 add coeff 0/1
    let t19 = circuit_add(in10, in10); //Fp2 add coeff 1/1
    let t20 = circuit_mul(t18, t18); //Fp2 Div x/y start : Fp2 Inv y start
    let t21 = circuit_mul(t19, t19);
    let t22 = circuit_add(t20, t21);
    let t23 = circuit_inverse(t22);
    let t24 = circuit_mul(t18, t23); //Fp2 Inv y real part end
    let t25 = circuit_mul(t19, t23);
    let t26 = circuit_sub(in2, t25); //Fp2 Inv y imag part end
    let t27 = circuit_mul(t16, t24); //Fp2 mul start
    let t28 = circuit_mul(t17, t26);
    let t29 = circuit_sub(t27, t28); //Fp2 mul real part end
    let t30 = circuit_mul(t16, t26);
    let t31 = circuit_mul(t17, t24);
    let t32 = circuit_add(t30, t31); //Fp2 mul imag part end
    let t33 = circuit_add(t29, t32);
    let t34 = circuit_sub(t29, t32);
    let t35 = circuit_mul(t33, t34);
    let t36 = circuit_mul(t29, t32);
    let t37 = circuit_add(t36, t36);
    let t38 = circuit_add(in7, in7); //Fp2 add coeff 0/1
    let t39 = circuit_add(in8, in8); //Fp2 add coeff 1/1
    let t40 = circuit_sub(t35, t38); //Fp2 sub coeff 0/1
    let t41 = circuit_sub(t37, t39); //Fp2 sub coeff 1/1
    let t42 = circuit_sub(in7, t40); //Fp2 sub coeff 0/1
    let t43 = circuit_sub(in8, t41); //Fp2 sub coeff 1/1
    let t44 = circuit_mul(t29, t42); //Fp2 mul start
    let t45 = circuit_mul(t32, t43);
    let t46 = circuit_sub(t44, t45); //Fp2 mul real part end
    let t47 = circuit_mul(t29, t43);
    let t48 = circuit_mul(t32, t42);
    let t49 = circuit_add(t47, t48); //Fp2 mul imag part end
    let t50 = circuit_sub(t46, in9); //Fp2 sub coeff 0/1
    let t51 = circuit_sub(t49, in10); //Fp2 sub coeff 1/1
    let t52 = circuit_mul(t29, in7); //Fp2 mul start
    let t53 = circuit_mul(t32, in8);
    let t54 = circuit_sub(t52, t53); //Fp2 mul real part end
    let t55 = circuit_mul(t29, in8);
    let t56 = circuit_mul(t32, in7);
    let t57 = circuit_add(t55, t56); //Fp2 mul imag part end
    let t58 = circuit_sub(t54, in9); //Fp2 sub coeff 0/1
    let t59 = circuit_sub(t57, in10); //Fp2 sub coeff 1/1
    let t60 = circuit_mul(in3, t32);
    let t61 = circuit_add(t29, t60);
    let t62 = circuit_mul(t61, in6);
    let t63 = circuit_mul(in3, t59);
    let t64 = circuit_add(t58, t63);
    let t65 = circuit_mul(t64, in5);
    let t66 = circuit_mul(t32, in6);
    let t67 = circuit_mul(t59, in5);
    let t68 = circuit_mul(t62, in38);
    let t69 = circuit_add(in4, t68);
    let t70 = circuit_mul(t65, t1);
    let t71 = circuit_add(t69, t70);
    let t72 = circuit_mul(t66, t5);
    let t73 = circuit_add(t71, t72);
    let t74 = circuit_mul(t67, t7);
    let t75 = circuit_add(t73, t74);
    let t76 = circuit_mul(t11, t75); //Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_0(z)
    let t77 = circuit_add(in13, in14); //Doubling slope numerator start
    let t78 = circuit_sub(in13, in14);
    let t79 = circuit_mul(t77, t78);
    let t80 = circuit_mul(in13, in14);
    let t81 = circuit_mul(t79, in0);
    let t82 = circuit_mul(t80, in1); //Doubling slope numerator end
    let t83 = circuit_add(in15, in15); //Fp2 add coeff 0/1
    let t84 = circuit_add(in16, in16); //Fp2 add coeff 1/1
    let t85 = circuit_mul(t83, t83); //Fp2 Div x/y start : Fp2 Inv y start
    let t86 = circuit_mul(t84, t84);
    let t87 = circuit_add(t85, t86);
    let t88 = circuit_inverse(t87);
    let t89 = circuit_mul(t83, t88); //Fp2 Inv y real part end
    let t90 = circuit_mul(t84, t88);
    let t91 = circuit_sub(in2, t90); //Fp2 Inv y imag part end
    let t92 = circuit_mul(t81, t89); //Fp2 mul start
    let t93 = circuit_mul(t82, t91);
    let t94 = circuit_sub(t92, t93); //Fp2 mul real part end
    let t95 = circuit_mul(t81, t91);
    let t96 = circuit_mul(t82, t89);
    let t97 = circuit_add(t95, t96); //Fp2 mul imag part end
    let t98 = circuit_add(t94, t97);
    let t99 = circuit_sub(t94, t97);
    let t100 = circuit_mul(t98, t99);
    let t101 = circuit_mul(t94, t97);
    let t102 = circuit_add(t101, t101);
    let t103 = circuit_add(in13, in13); //Fp2 add coeff 0/1
    let t104 = circuit_add(in14, in14); //Fp2 add coeff 1/1
    let t105 = circuit_sub(t100, t103); //Fp2 sub coeff 0/1
    let t106 = circuit_sub(t102, t104); //Fp2 sub coeff 1/1
    let t107 = circuit_sub(in13, t105); //Fp2 sub coeff 0/1
    let t108 = circuit_sub(in14, t106); //Fp2 sub coeff 1/1
    let t109 = circuit_mul(t94, t107); //Fp2 mul start
    let t110 = circuit_mul(t97, t108);
    let t111 = circuit_sub(t109, t110); //Fp2 mul real part end
    let t112 = circuit_mul(t94, t108);
    let t113 = circuit_mul(t97, t107);
    let t114 = circuit_add(t112, t113); //Fp2 mul imag part end
    let t115 = circuit_sub(t111, in15); //Fp2 sub coeff 0/1
    let t116 = circuit_sub(t114, in16); //Fp2 sub coeff 1/1
    let t117 = circuit_mul(t94, in13); //Fp2 mul start
    let t118 = circuit_mul(t97, in14);
    let t119 = circuit_sub(t117, t118); //Fp2 mul real part end
    let t120 = circuit_mul(t94, in14);
    let t121 = circuit_mul(t97, in13);
    let t122 = circuit_add(t120, t121); //Fp2 mul imag part end
    let t123 = circuit_sub(t119, in15); //Fp2 sub coeff 0/1
    let t124 = circuit_sub(t122, in16); //Fp2 sub coeff 1/1
    let t125 = circuit_mul(in3, t97);
    let t126 = circuit_add(t94, t125);
    let t127 = circuit_mul(t126, in12);
    let t128 = circuit_mul(in3, t124);
    let t129 = circuit_add(t123, t128);
    let t130 = circuit_mul(t129, in11);
    let t131 = circuit_mul(t97, in12);
    let t132 = circuit_mul(t124, in11);
    let t133 = circuit_mul(t127, in38);
    let t134 = circuit_add(in4, t133);
    let t135 = circuit_mul(t130, t1);
    let t136 = circuit_add(t134, t135);
    let t137 = circuit_mul(t131, t5);
    let t138 = circuit_add(t136, t137);
    let t139 = circuit_mul(t132, t7);
    let t140 = circuit_add(t138, t139);
    let t141 = circuit_mul(t76, t140); //Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_1(z)
    let t142 = circuit_add(in19, in20); //Doubling slope numerator start
    let t143 = circuit_sub(in19, in20);
    let t144 = circuit_mul(t142, t143);
    let t145 = circuit_mul(in19, in20);
    let t146 = circuit_mul(t144, in0);
    let t147 = circuit_mul(t145, in1); //Doubling slope numerator end
    let t148 = circuit_add(in21, in21); //Fp2 add coeff 0/1
    let t149 = circuit_add(in22, in22); //Fp2 add coeff 1/1
    let t150 = circuit_mul(t148, t148); //Fp2 Div x/y start : Fp2 Inv y start
    let t151 = circuit_mul(t149, t149);
    let t152 = circuit_add(t150, t151);
    let t153 = circuit_inverse(t152);
    let t154 = circuit_mul(t148, t153); //Fp2 Inv y real part end
    let t155 = circuit_mul(t149, t153);
    let t156 = circuit_sub(in2, t155); //Fp2 Inv y imag part end
    let t157 = circuit_mul(t146, t154); //Fp2 mul start
    let t158 = circuit_mul(t147, t156);
    let t159 = circuit_sub(t157, t158); //Fp2 mul real part end
    let t160 = circuit_mul(t146, t156);
    let t161 = circuit_mul(t147, t154);
    let t162 = circuit_add(t160, t161); //Fp2 mul imag part end
    let t163 = circuit_add(t159, t162);
    let t164 = circuit_sub(t159, t162);
    let t165 = circuit_mul(t163, t164);
    let t166 = circuit_mul(t159, t162);
    let t167 = circuit_add(t166, t166);
    let t168 = circuit_add(in19, in19); //Fp2 add coeff 0/1
    let t169 = circuit_add(in20, in20); //Fp2 add coeff 1/1
    let t170 = circuit_sub(t165, t168); //Fp2 sub coeff 0/1
    let t171 = circuit_sub(t167, t169); //Fp2 sub coeff 1/1
    let t172 = circuit_sub(in19, t170); //Fp2 sub coeff 0/1
    let t173 = circuit_sub(in20, t171); //Fp2 sub coeff 1/1
    let t174 = circuit_mul(t159, t172); //Fp2 mul start
    let t175 = circuit_mul(t162, t173);
    let t176 = circuit_sub(t174, t175); //Fp2 mul real part end
    let t177 = circuit_mul(t159, t173);
    let t178 = circuit_mul(t162, t172);
    let t179 = circuit_add(t177, t178); //Fp2 mul imag part end
    let t180 = circuit_sub(t176, in21); //Fp2 sub coeff 0/1
    let t181 = circuit_sub(t179, in22); //Fp2 sub coeff 1/1
    let t182 = circuit_mul(t159, in19); //Fp2 mul start
    let t183 = circuit_mul(t162, in20);
    let t184 = circuit_sub(t182, t183); //Fp2 mul real part end
    let t185 = circuit_mul(t159, in20);
    let t186 = circuit_mul(t162, in19);
    let t187 = circuit_add(t185, t186); //Fp2 mul imag part end
    let t188 = circuit_sub(t184, in21); //Fp2 sub coeff 0/1
    let t189 = circuit_sub(t187, in22); //Fp2 sub coeff 1/1
    let t190 = circuit_mul(in3, t162);
    let t191 = circuit_add(t159, t190);
    let t192 = circuit_mul(t191, in18);
    let t193 = circuit_mul(in3, t189);
    let t194 = circuit_add(t188, t193);
    let t195 = circuit_mul(t194, in17);
    let t196 = circuit_mul(t162, in18);
    let t197 = circuit_mul(t189, in17);
    let t198 = circuit_mul(t192, in38);
    let t199 = circuit_add(in4, t198);
    let t200 = circuit_mul(t195, t1);
    let t201 = circuit_add(t199, t200);
    let t202 = circuit_mul(t196, t5);
    let t203 = circuit_add(t201, t202);
    let t204 = circuit_mul(t197, t7);
    let t205 = circuit_add(t203, t204);
    let t206 = circuit_mul(t141, t205); //Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_2(z)
    let t207 = circuit_mul(in26, in38);
    let t208 = circuit_add(in25, t207);
    let t209 = circuit_mul(in27, t0);
    let t210 = circuit_add(t208, t209);
    let t211 = circuit_mul(in28, t1);
    let t212 = circuit_add(t210, t211);
    let t213 = circuit_mul(in29, t2);
    let t214 = circuit_add(t212, t213);
    let t215 = circuit_mul(in30, t3);
    let t216 = circuit_add(t214, t215);
    let t217 = circuit_mul(in31, t4);
    let t218 = circuit_add(t216, t217);
    let t219 = circuit_mul(in32, t5);
    let t220 = circuit_add(t218, t219);
    let t221 = circuit_mul(in33, t6);
    let t222 = circuit_add(t220, t221);
    let t223 = circuit_mul(in34, t7);
    let t224 = circuit_add(t222, t223);
    let t225 = circuit_mul(in35, t8);
    let t226 = circuit_add(t224, t225);
    let t227 = circuit_mul(in36, t9);
    let t228 = circuit_add(t226, t227);
    let t229 = circuit_sub(t206, t228);
    let t230 = circuit_mul(t10, t229); //ci * ((Π(i,k) (Pk(z)) - Ri(z))
    let t231 = circuit_add(in23, t230); //LHS = LHS + ci * ((Π(i,k) (Pk(z)) - Ri(z))

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
    circuit_inputs = circuit_inputs.next(u384 { limb0: 3, limb1: 0, limb2: 0, limb3: 0 });
    circuit_inputs = circuit_inputs.next(u384 { limb0: 6, limb1: 0, limb2: 0, limb3: 0 });
    circuit_inputs = circuit_inputs.next(u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 });
    circuit_inputs = circuit_inputs
        .next(
            u384 {
                limb0: 32324006162389411176778628414,
                limb1: 57042285082623239461879769745,
                limb2: 3486998266802970665,
                limb3: 0
            }
        );
    circuit_inputs = circuit_inputs.next(u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 });
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
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0
    let in1 = CircuitElement::<
        CircuitInput<1>
    > {}; // 21888242871839275222246405745257275088696311157297823662689037894645226208574
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 1

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
    let t0 = circuit_mul(in38, in38); //Compute z^2
    let t1 = circuit_mul(t0, in38); //Compute z^3
    let t2 = circuit_mul(t1, in38); //Compute z^4
    let t3 = circuit_mul(t2, in38); //Compute z^5
    let t4 = circuit_mul(t3, in38); //Compute z^6
    let t5 = circuit_mul(t4, in38); //Compute z^7
    let t6 = circuit_mul(t5, in38); //Compute z^8
    let t7 = circuit_mul(t6, in38); //Compute z^9
    let t8 = circuit_mul(t7, in38); //Compute z^10
    let t9 = circuit_mul(t8, in38); //Compute z^11
    let t10 = circuit_mul(in39, in39);
    let t11 = circuit_mul(in24, in24);
    let t12 = circuit_sub(in7, in11); //Fp2 sub coeff 0/1
    let t13 = circuit_sub(in8, in12); //Fp2 sub coeff 1/1
    let t14 = circuit_sub(in5, in9); //Fp2 sub coeff 0/1
    let t15 = circuit_sub(in6, in10); //Fp2 sub coeff 1/1
    let t16 = circuit_mul(t14, t14); //Fp2 Div x/y start : Fp2 Inv y start
    let t17 = circuit_mul(t15, t15);
    let t18 = circuit_add(t16, t17);
    let t19 = circuit_inverse(t18);
    let t20 = circuit_mul(t14, t19); //Fp2 Inv y real part end
    let t21 = circuit_mul(t15, t19);
    let t22 = circuit_sub(in0, t21); //Fp2 Inv y imag part end
    let t23 = circuit_mul(t12, t20); //Fp2 mul start
    let t24 = circuit_mul(t13, t22);
    let t25 = circuit_sub(t23, t24); //Fp2 mul real part end
    let t26 = circuit_mul(t12, t22);
    let t27 = circuit_mul(t13, t20);
    let t28 = circuit_add(t26, t27); //Fp2 mul imag part end
    let t29 = circuit_add(t25, t28);
    let t30 = circuit_sub(t25, t28);
    let t31 = circuit_mul(t29, t30);
    let t32 = circuit_mul(t25, t28);
    let t33 = circuit_add(t32, t32);
    let t34 = circuit_add(in5, in9); //Fp2 add coeff 0/1
    let t35 = circuit_add(in6, in10); //Fp2 add coeff 1/1
    let t36 = circuit_sub(t31, t34); //Fp2 sub coeff 0/1
    let t37 = circuit_sub(t33, t35); //Fp2 sub coeff 1/1
    let t38 = circuit_mul(t25, in5); //Fp2 mul start
    let t39 = circuit_mul(t28, in6);
    let t40 = circuit_sub(t38, t39); //Fp2 mul real part end
    let t41 = circuit_mul(t25, in6);
    let t42 = circuit_mul(t28, in5);
    let t43 = circuit_add(t41, t42); //Fp2 mul imag part end
    let t44 = circuit_sub(t40, in7); //Fp2 sub coeff 0/1
    let t45 = circuit_sub(t43, in8); //Fp2 sub coeff 1/1
    let t46 = circuit_mul(in1, t28);
    let t47 = circuit_add(t25, t46);
    let t48 = circuit_mul(t47, in4);
    let t49 = circuit_mul(in1, t45);
    let t50 = circuit_add(t44, t49);
    let t51 = circuit_mul(t50, in3);
    let t52 = circuit_mul(t28, in4);
    let t53 = circuit_mul(t45, in3);
    let t54 = circuit_add(in7, in7); //Fp2 add coeff 0/1
    let t55 = circuit_add(in8, in8); //Fp2 add coeff 1/1
    let t56 = circuit_sub(t36, in5); //Fp2 sub coeff 0/1
    let t57 = circuit_sub(t37, in6); //Fp2 sub coeff 1/1
    let t58 = circuit_mul(t56, t56); //Fp2 Div x/y start : Fp2 Inv y start
    let t59 = circuit_mul(t57, t57);
    let t60 = circuit_add(t58, t59);
    let t61 = circuit_inverse(t60);
    let t62 = circuit_mul(t56, t61); //Fp2 Inv y real part end
    let t63 = circuit_mul(t57, t61);
    let t64 = circuit_sub(in0, t63); //Fp2 Inv y imag part end
    let t65 = circuit_mul(t54, t62); //Fp2 mul start
    let t66 = circuit_mul(t55, t64);
    let t67 = circuit_sub(t65, t66); //Fp2 mul real part end
    let t68 = circuit_mul(t54, t64);
    let t69 = circuit_mul(t55, t62);
    let t70 = circuit_add(t68, t69); //Fp2 mul imag part end
    let t71 = circuit_add(t25, t67); //Fp2 add coeff 0/1
    let t72 = circuit_add(t28, t70); //Fp2 add coeff 1/1
    let t73 = circuit_sub(in0, t71); //Fp2 neg coeff 0/1
    let t74 = circuit_sub(in0, t72); //Fp2 neg coeff 1/1
    let t75 = circuit_add(t73, t74);
    let t76 = circuit_sub(t73, t74);
    let t77 = circuit_mul(t75, t76);
    let t78 = circuit_mul(t73, t74);
    let t79 = circuit_add(t78, t78);
    let t80 = circuit_sub(t77, in5); //Fp2 sub coeff 0/1
    let t81 = circuit_sub(t79, in6); //Fp2 sub coeff 1/1
    let t82 = circuit_sub(t80, t36); //Fp2 sub coeff 0/1
    let t83 = circuit_sub(t81, t37); //Fp2 sub coeff 1/1
    let t84 = circuit_sub(in5, t82); //Fp2 sub coeff 0/1
    let t85 = circuit_sub(in6, t83); //Fp2 sub coeff 1/1
    let t86 = circuit_mul(t73, t84); //Fp2 mul start
    let t87 = circuit_mul(t74, t85);
    let t88 = circuit_sub(t86, t87); //Fp2 mul real part end
    let t89 = circuit_mul(t73, t85);
    let t90 = circuit_mul(t74, t84);
    let t91 = circuit_add(t89, t90); //Fp2 mul imag part end
    let t92 = circuit_sub(t88, in7); //Fp2 sub coeff 0/1
    let t93 = circuit_sub(t91, in8); //Fp2 sub coeff 1/1
    let t94 = circuit_mul(t73, in5); //Fp2 mul start
    let t95 = circuit_mul(t74, in6);
    let t96 = circuit_sub(t94, t95); //Fp2 mul real part end
    let t97 = circuit_mul(t73, in6);
    let t98 = circuit_mul(t74, in5);
    let t99 = circuit_add(t97, t98); //Fp2 mul imag part end
    let t100 = circuit_sub(t96, in7); //Fp2 sub coeff 0/1
    let t101 = circuit_sub(t99, in8); //Fp2 sub coeff 1/1
    let t102 = circuit_mul(in1, t74);
    let t103 = circuit_add(t73, t102);
    let t104 = circuit_mul(t103, in4);
    let t105 = circuit_mul(in1, t101);
    let t106 = circuit_add(t100, t105);
    let t107 = circuit_mul(t106, in3);
    let t108 = circuit_mul(t74, in4);
    let t109 = circuit_mul(t101, in3);
    let t110 = circuit_mul(t48, in38);
    let t111 = circuit_add(in2, t110);
    let t112 = circuit_mul(t51, t1);
    let t113 = circuit_add(t111, t112);
    let t114 = circuit_mul(t52, t5);
    let t115 = circuit_add(t113, t114);
    let t116 = circuit_mul(t53, t7);
    let t117 = circuit_add(t115, t116);
    let t118 = circuit_mul(t11, t117);
    let t119 = circuit_mul(t104, in38);
    let t120 = circuit_add(in2, t119);
    let t121 = circuit_mul(t107, t1);
    let t122 = circuit_add(t120, t121);
    let t123 = circuit_mul(t108, t5);
    let t124 = circuit_add(t122, t123);
    let t125 = circuit_mul(t109, t7);
    let t126 = circuit_add(t124, t125);
    let t127 = circuit_mul(t118, t126);
    let t128 = circuit_sub(in17, in21); //Fp2 sub coeff 0/1
    let t129 = circuit_sub(in18, in22); //Fp2 sub coeff 1/1
    let t130 = circuit_sub(in15, in19); //Fp2 sub coeff 0/1
    let t131 = circuit_sub(in16, in20); //Fp2 sub coeff 1/1
    let t132 = circuit_mul(t130, t130); //Fp2 Div x/y start : Fp2 Inv y start
    let t133 = circuit_mul(t131, t131);
    let t134 = circuit_add(t132, t133);
    let t135 = circuit_inverse(t134);
    let t136 = circuit_mul(t130, t135); //Fp2 Inv y real part end
    let t137 = circuit_mul(t131, t135);
    let t138 = circuit_sub(in0, t137); //Fp2 Inv y imag part end
    let t139 = circuit_mul(t128, t136); //Fp2 mul start
    let t140 = circuit_mul(t129, t138);
    let t141 = circuit_sub(t139, t140); //Fp2 mul real part end
    let t142 = circuit_mul(t128, t138);
    let t143 = circuit_mul(t129, t136);
    let t144 = circuit_add(t142, t143); //Fp2 mul imag part end
    let t145 = circuit_add(t141, t144);
    let t146 = circuit_sub(t141, t144);
    let t147 = circuit_mul(t145, t146);
    let t148 = circuit_mul(t141, t144);
    let t149 = circuit_add(t148, t148);
    let t150 = circuit_add(in15, in19); //Fp2 add coeff 0/1
    let t151 = circuit_add(in16, in20); //Fp2 add coeff 1/1
    let t152 = circuit_sub(t147, t150); //Fp2 sub coeff 0/1
    let t153 = circuit_sub(t149, t151); //Fp2 sub coeff 1/1
    let t154 = circuit_mul(t141, in15); //Fp2 mul start
    let t155 = circuit_mul(t144, in16);
    let t156 = circuit_sub(t154, t155); //Fp2 mul real part end
    let t157 = circuit_mul(t141, in16);
    let t158 = circuit_mul(t144, in15);
    let t159 = circuit_add(t157, t158); //Fp2 mul imag part end
    let t160 = circuit_sub(t156, in17); //Fp2 sub coeff 0/1
    let t161 = circuit_sub(t159, in18); //Fp2 sub coeff 1/1
    let t162 = circuit_mul(in1, t144);
    let t163 = circuit_add(t141, t162);
    let t164 = circuit_mul(t163, in14);
    let t165 = circuit_mul(in1, t161);
    let t166 = circuit_add(t160, t165);
    let t167 = circuit_mul(t166, in13);
    let t168 = circuit_mul(t144, in14);
    let t169 = circuit_mul(t161, in13);
    let t170 = circuit_add(in17, in17); //Fp2 add coeff 0/1
    let t171 = circuit_add(in18, in18); //Fp2 add coeff 1/1
    let t172 = circuit_sub(t152, in15); //Fp2 sub coeff 0/1
    let t173 = circuit_sub(t153, in16); //Fp2 sub coeff 1/1
    let t174 = circuit_mul(t172, t172); //Fp2 Div x/y start : Fp2 Inv y start
    let t175 = circuit_mul(t173, t173);
    let t176 = circuit_add(t174, t175);
    let t177 = circuit_inverse(t176);
    let t178 = circuit_mul(t172, t177); //Fp2 Inv y real part end
    let t179 = circuit_mul(t173, t177);
    let t180 = circuit_sub(in0, t179); //Fp2 Inv y imag part end
    let t181 = circuit_mul(t170, t178); //Fp2 mul start
    let t182 = circuit_mul(t171, t180);
    let t183 = circuit_sub(t181, t182); //Fp2 mul real part end
    let t184 = circuit_mul(t170, t180);
    let t185 = circuit_mul(t171, t178);
    let t186 = circuit_add(t184, t185); //Fp2 mul imag part end
    let t187 = circuit_add(t141, t183); //Fp2 add coeff 0/1
    let t188 = circuit_add(t144, t186); //Fp2 add coeff 1/1
    let t189 = circuit_sub(in0, t187); //Fp2 neg coeff 0/1
    let t190 = circuit_sub(in0, t188); //Fp2 neg coeff 1/1
    let t191 = circuit_add(t189, t190);
    let t192 = circuit_sub(t189, t190);
    let t193 = circuit_mul(t191, t192);
    let t194 = circuit_mul(t189, t190);
    let t195 = circuit_add(t194, t194);
    let t196 = circuit_sub(t193, in15); //Fp2 sub coeff 0/1
    let t197 = circuit_sub(t195, in16); //Fp2 sub coeff 1/1
    let t198 = circuit_sub(t196, t152); //Fp2 sub coeff 0/1
    let t199 = circuit_sub(t197, t153); //Fp2 sub coeff 1/1
    let t200 = circuit_sub(in15, t198); //Fp2 sub coeff 0/1
    let t201 = circuit_sub(in16, t199); //Fp2 sub coeff 1/1
    let t202 = circuit_mul(t189, t200); //Fp2 mul start
    let t203 = circuit_mul(t190, t201);
    let t204 = circuit_sub(t202, t203); //Fp2 mul real part end
    let t205 = circuit_mul(t189, t201);
    let t206 = circuit_mul(t190, t200);
    let t207 = circuit_add(t205, t206); //Fp2 mul imag part end
    let t208 = circuit_sub(t204, in17); //Fp2 sub coeff 0/1
    let t209 = circuit_sub(t207, in18); //Fp2 sub coeff 1/1
    let t210 = circuit_mul(t189, in15); //Fp2 mul start
    let t211 = circuit_mul(t190, in16);
    let t212 = circuit_sub(t210, t211); //Fp2 mul real part end
    let t213 = circuit_mul(t189, in16);
    let t214 = circuit_mul(t190, in15);
    let t215 = circuit_add(t213, t214); //Fp2 mul imag part end
    let t216 = circuit_sub(t212, in17); //Fp2 sub coeff 0/1
    let t217 = circuit_sub(t215, in18); //Fp2 sub coeff 1/1
    let t218 = circuit_mul(in1, t190);
    let t219 = circuit_add(t189, t218);
    let t220 = circuit_mul(t219, in14);
    let t221 = circuit_mul(in1, t217);
    let t222 = circuit_add(t216, t221);
    let t223 = circuit_mul(t222, in13);
    let t224 = circuit_mul(t190, in14);
    let t225 = circuit_mul(t217, in13);
    let t226 = circuit_mul(t164, in38);
    let t227 = circuit_add(in2, t226);
    let t228 = circuit_mul(t167, t1);
    let t229 = circuit_add(t227, t228);
    let t230 = circuit_mul(t168, t5);
    let t231 = circuit_add(t229, t230);
    let t232 = circuit_mul(t169, t7);
    let t233 = circuit_add(t231, t232);
    let t234 = circuit_mul(t127, t233);
    let t235 = circuit_mul(t220, in38);
    let t236 = circuit_add(in2, t235);
    let t237 = circuit_mul(t223, t1);
    let t238 = circuit_add(t236, t237);
    let t239 = circuit_mul(t224, t5);
    let t240 = circuit_add(t238, t239);
    let t241 = circuit_mul(t225, t7);
    let t242 = circuit_add(t240, t241);
    let t243 = circuit_mul(t234, t242);
    let t244 = circuit_mul(t243, in37);
    let t245 = circuit_mul(in26, in38);
    let t246 = circuit_add(in25, t245);
    let t247 = circuit_mul(in27, t0);
    let t248 = circuit_add(t246, t247);
    let t249 = circuit_mul(in28, t1);
    let t250 = circuit_add(t248, t249);
    let t251 = circuit_mul(in29, t2);
    let t252 = circuit_add(t250, t251);
    let t253 = circuit_mul(in30, t3);
    let t254 = circuit_add(t252, t253);
    let t255 = circuit_mul(in31, t4);
    let t256 = circuit_add(t254, t255);
    let t257 = circuit_mul(in32, t5);
    let t258 = circuit_add(t256, t257);
    let t259 = circuit_mul(in33, t6);
    let t260 = circuit_add(t258, t259);
    let t261 = circuit_mul(in34, t7);
    let t262 = circuit_add(t260, t261);
    let t263 = circuit_mul(in35, t8);
    let t264 = circuit_add(t262, t263);
    let t265 = circuit_mul(in36, t9);
    let t266 = circuit_add(t264, t265);
    let t267 = circuit_sub(t244, t266);
    let t268 = circuit_mul(t10, t267); //ci * ((Π(i,k) (Pk(z)) - Ri(z))
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
    circuit_inputs = circuit_inputs.next(u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 });
    circuit_inputs = circuit_inputs
        .next(
            u384 {
                limb0: 32324006162389411176778628414,
                limb1: 57042285082623239461879769745,
                limb2: 3486998266802970665,
                limb3: 0
            }
        );
    circuit_inputs = circuit_inputs.next(u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 });
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
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0
    let in1 = CircuitElement::<
        CircuitInput<1>
    > {}; // 21888242871839275222246405745257275088696311157297823662689037894645226208574
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 1

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
    let t0 = circuit_mul(in48, in48); //Compute z^2
    let t1 = circuit_mul(t0, in48); //Compute z^3
    let t2 = circuit_mul(t1, in48); //Compute z^4
    let t3 = circuit_mul(t2, in48); //Compute z^5
    let t4 = circuit_mul(t3, in48); //Compute z^6
    let t5 = circuit_mul(t4, in48); //Compute z^7
    let t6 = circuit_mul(t5, in48); //Compute z^8
    let t7 = circuit_mul(t6, in48); //Compute z^9
    let t8 = circuit_mul(t7, in48); //Compute z^10
    let t9 = circuit_mul(t8, in48); //Compute z^11
    let t10 = circuit_mul(in49, in49);
    let t11 = circuit_mul(in34, in34);
    let t12 = circuit_sub(in7, in11); //Fp2 sub coeff 0/1
    let t13 = circuit_sub(in8, in12); //Fp2 sub coeff 1/1
    let t14 = circuit_sub(in5, in9); //Fp2 sub coeff 0/1
    let t15 = circuit_sub(in6, in10); //Fp2 sub coeff 1/1
    let t16 = circuit_mul(t14, t14); //Fp2 Div x/y start : Fp2 Inv y start
    let t17 = circuit_mul(t15, t15);
    let t18 = circuit_add(t16, t17);
    let t19 = circuit_inverse(t18);
    let t20 = circuit_mul(t14, t19); //Fp2 Inv y real part end
    let t21 = circuit_mul(t15, t19);
    let t22 = circuit_sub(in0, t21); //Fp2 Inv y imag part end
    let t23 = circuit_mul(t12, t20); //Fp2 mul start
    let t24 = circuit_mul(t13, t22);
    let t25 = circuit_sub(t23, t24); //Fp2 mul real part end
    let t26 = circuit_mul(t12, t22);
    let t27 = circuit_mul(t13, t20);
    let t28 = circuit_add(t26, t27); //Fp2 mul imag part end
    let t29 = circuit_add(t25, t28);
    let t30 = circuit_sub(t25, t28);
    let t31 = circuit_mul(t29, t30);
    let t32 = circuit_mul(t25, t28);
    let t33 = circuit_add(t32, t32);
    let t34 = circuit_add(in5, in9); //Fp2 add coeff 0/1
    let t35 = circuit_add(in6, in10); //Fp2 add coeff 1/1
    let t36 = circuit_sub(t31, t34); //Fp2 sub coeff 0/1
    let t37 = circuit_sub(t33, t35); //Fp2 sub coeff 1/1
    let t38 = circuit_mul(t25, in5); //Fp2 mul start
    let t39 = circuit_mul(t28, in6);
    let t40 = circuit_sub(t38, t39); //Fp2 mul real part end
    let t41 = circuit_mul(t25, in6);
    let t42 = circuit_mul(t28, in5);
    let t43 = circuit_add(t41, t42); //Fp2 mul imag part end
    let t44 = circuit_sub(t40, in7); //Fp2 sub coeff 0/1
    let t45 = circuit_sub(t43, in8); //Fp2 sub coeff 1/1
    let t46 = circuit_mul(in1, t28);
    let t47 = circuit_add(t25, t46);
    let t48 = circuit_mul(t47, in4);
    let t49 = circuit_mul(in1, t45);
    let t50 = circuit_add(t44, t49);
    let t51 = circuit_mul(t50, in3);
    let t52 = circuit_mul(t28, in4);
    let t53 = circuit_mul(t45, in3);
    let t54 = circuit_add(in7, in7); //Fp2 add coeff 0/1
    let t55 = circuit_add(in8, in8); //Fp2 add coeff 1/1
    let t56 = circuit_sub(t36, in5); //Fp2 sub coeff 0/1
    let t57 = circuit_sub(t37, in6); //Fp2 sub coeff 1/1
    let t58 = circuit_mul(t56, t56); //Fp2 Div x/y start : Fp2 Inv y start
    let t59 = circuit_mul(t57, t57);
    let t60 = circuit_add(t58, t59);
    let t61 = circuit_inverse(t60);
    let t62 = circuit_mul(t56, t61); //Fp2 Inv y real part end
    let t63 = circuit_mul(t57, t61);
    let t64 = circuit_sub(in0, t63); //Fp2 Inv y imag part end
    let t65 = circuit_mul(t54, t62); //Fp2 mul start
    let t66 = circuit_mul(t55, t64);
    let t67 = circuit_sub(t65, t66); //Fp2 mul real part end
    let t68 = circuit_mul(t54, t64);
    let t69 = circuit_mul(t55, t62);
    let t70 = circuit_add(t68, t69); //Fp2 mul imag part end
    let t71 = circuit_add(t25, t67); //Fp2 add coeff 0/1
    let t72 = circuit_add(t28, t70); //Fp2 add coeff 1/1
    let t73 = circuit_sub(in0, t71); //Fp2 neg coeff 0/1
    let t74 = circuit_sub(in0, t72); //Fp2 neg coeff 1/1
    let t75 = circuit_add(t73, t74);
    let t76 = circuit_sub(t73, t74);
    let t77 = circuit_mul(t75, t76);
    let t78 = circuit_mul(t73, t74);
    let t79 = circuit_add(t78, t78);
    let t80 = circuit_sub(t77, in5); //Fp2 sub coeff 0/1
    let t81 = circuit_sub(t79, in6); //Fp2 sub coeff 1/1
    let t82 = circuit_sub(t80, t36); //Fp2 sub coeff 0/1
    let t83 = circuit_sub(t81, t37); //Fp2 sub coeff 1/1
    let t84 = circuit_sub(in5, t82); //Fp2 sub coeff 0/1
    let t85 = circuit_sub(in6, t83); //Fp2 sub coeff 1/1
    let t86 = circuit_mul(t73, t84); //Fp2 mul start
    let t87 = circuit_mul(t74, t85);
    let t88 = circuit_sub(t86, t87); //Fp2 mul real part end
    let t89 = circuit_mul(t73, t85);
    let t90 = circuit_mul(t74, t84);
    let t91 = circuit_add(t89, t90); //Fp2 mul imag part end
    let t92 = circuit_sub(t88, in7); //Fp2 sub coeff 0/1
    let t93 = circuit_sub(t91, in8); //Fp2 sub coeff 1/1
    let t94 = circuit_mul(t73, in5); //Fp2 mul start
    let t95 = circuit_mul(t74, in6);
    let t96 = circuit_sub(t94, t95); //Fp2 mul real part end
    let t97 = circuit_mul(t73, in6);
    let t98 = circuit_mul(t74, in5);
    let t99 = circuit_add(t97, t98); //Fp2 mul imag part end
    let t100 = circuit_sub(t96, in7); //Fp2 sub coeff 0/1
    let t101 = circuit_sub(t99, in8); //Fp2 sub coeff 1/1
    let t102 = circuit_mul(in1, t74);
    let t103 = circuit_add(t73, t102);
    let t104 = circuit_mul(t103, in4);
    let t105 = circuit_mul(in1, t101);
    let t106 = circuit_add(t100, t105);
    let t107 = circuit_mul(t106, in3);
    let t108 = circuit_mul(t74, in4);
    let t109 = circuit_mul(t101, in3);
    let t110 = circuit_mul(t48, in48);
    let t111 = circuit_add(in2, t110);
    let t112 = circuit_mul(t51, t1);
    let t113 = circuit_add(t111, t112);
    let t114 = circuit_mul(t52, t5);
    let t115 = circuit_add(t113, t114);
    let t116 = circuit_mul(t53, t7);
    let t117 = circuit_add(t115, t116);
    let t118 = circuit_mul(t11, t117);
    let t119 = circuit_mul(t104, in48);
    let t120 = circuit_add(in2, t119);
    let t121 = circuit_mul(t107, t1);
    let t122 = circuit_add(t120, t121);
    let t123 = circuit_mul(t108, t5);
    let t124 = circuit_add(t122, t123);
    let t125 = circuit_mul(t109, t7);
    let t126 = circuit_add(t124, t125);
    let t127 = circuit_mul(t118, t126);
    let t128 = circuit_sub(in17, in21); //Fp2 sub coeff 0/1
    let t129 = circuit_sub(in18, in22); //Fp2 sub coeff 1/1
    let t130 = circuit_sub(in15, in19); //Fp2 sub coeff 0/1
    let t131 = circuit_sub(in16, in20); //Fp2 sub coeff 1/1
    let t132 = circuit_mul(t130, t130); //Fp2 Div x/y start : Fp2 Inv y start
    let t133 = circuit_mul(t131, t131);
    let t134 = circuit_add(t132, t133);
    let t135 = circuit_inverse(t134);
    let t136 = circuit_mul(t130, t135); //Fp2 Inv y real part end
    let t137 = circuit_mul(t131, t135);
    let t138 = circuit_sub(in0, t137); //Fp2 Inv y imag part end
    let t139 = circuit_mul(t128, t136); //Fp2 mul start
    let t140 = circuit_mul(t129, t138);
    let t141 = circuit_sub(t139, t140); //Fp2 mul real part end
    let t142 = circuit_mul(t128, t138);
    let t143 = circuit_mul(t129, t136);
    let t144 = circuit_add(t142, t143); //Fp2 mul imag part end
    let t145 = circuit_add(t141, t144);
    let t146 = circuit_sub(t141, t144);
    let t147 = circuit_mul(t145, t146);
    let t148 = circuit_mul(t141, t144);
    let t149 = circuit_add(t148, t148);
    let t150 = circuit_add(in15, in19); //Fp2 add coeff 0/1
    let t151 = circuit_add(in16, in20); //Fp2 add coeff 1/1
    let t152 = circuit_sub(t147, t150); //Fp2 sub coeff 0/1
    let t153 = circuit_sub(t149, t151); //Fp2 sub coeff 1/1
    let t154 = circuit_mul(t141, in15); //Fp2 mul start
    let t155 = circuit_mul(t144, in16);
    let t156 = circuit_sub(t154, t155); //Fp2 mul real part end
    let t157 = circuit_mul(t141, in16);
    let t158 = circuit_mul(t144, in15);
    let t159 = circuit_add(t157, t158); //Fp2 mul imag part end
    let t160 = circuit_sub(t156, in17); //Fp2 sub coeff 0/1
    let t161 = circuit_sub(t159, in18); //Fp2 sub coeff 1/1
    let t162 = circuit_mul(in1, t144);
    let t163 = circuit_add(t141, t162);
    let t164 = circuit_mul(t163, in14);
    let t165 = circuit_mul(in1, t161);
    let t166 = circuit_add(t160, t165);
    let t167 = circuit_mul(t166, in13);
    let t168 = circuit_mul(t144, in14);
    let t169 = circuit_mul(t161, in13);
    let t170 = circuit_add(in17, in17); //Fp2 add coeff 0/1
    let t171 = circuit_add(in18, in18); //Fp2 add coeff 1/1
    let t172 = circuit_sub(t152, in15); //Fp2 sub coeff 0/1
    let t173 = circuit_sub(t153, in16); //Fp2 sub coeff 1/1
    let t174 = circuit_mul(t172, t172); //Fp2 Div x/y start : Fp2 Inv y start
    let t175 = circuit_mul(t173, t173);
    let t176 = circuit_add(t174, t175);
    let t177 = circuit_inverse(t176);
    let t178 = circuit_mul(t172, t177); //Fp2 Inv y real part end
    let t179 = circuit_mul(t173, t177);
    let t180 = circuit_sub(in0, t179); //Fp2 Inv y imag part end
    let t181 = circuit_mul(t170, t178); //Fp2 mul start
    let t182 = circuit_mul(t171, t180);
    let t183 = circuit_sub(t181, t182); //Fp2 mul real part end
    let t184 = circuit_mul(t170, t180);
    let t185 = circuit_mul(t171, t178);
    let t186 = circuit_add(t184, t185); //Fp2 mul imag part end
    let t187 = circuit_add(t141, t183); //Fp2 add coeff 0/1
    let t188 = circuit_add(t144, t186); //Fp2 add coeff 1/1
    let t189 = circuit_sub(in0, t187); //Fp2 neg coeff 0/1
    let t190 = circuit_sub(in0, t188); //Fp2 neg coeff 1/1
    let t191 = circuit_add(t189, t190);
    let t192 = circuit_sub(t189, t190);
    let t193 = circuit_mul(t191, t192);
    let t194 = circuit_mul(t189, t190);
    let t195 = circuit_add(t194, t194);
    let t196 = circuit_sub(t193, in15); //Fp2 sub coeff 0/1
    let t197 = circuit_sub(t195, in16); //Fp2 sub coeff 1/1
    let t198 = circuit_sub(t196, t152); //Fp2 sub coeff 0/1
    let t199 = circuit_sub(t197, t153); //Fp2 sub coeff 1/1
    let t200 = circuit_sub(in15, t198); //Fp2 sub coeff 0/1
    let t201 = circuit_sub(in16, t199); //Fp2 sub coeff 1/1
    let t202 = circuit_mul(t189, t200); //Fp2 mul start
    let t203 = circuit_mul(t190, t201);
    let t204 = circuit_sub(t202, t203); //Fp2 mul real part end
    let t205 = circuit_mul(t189, t201);
    let t206 = circuit_mul(t190, t200);
    let t207 = circuit_add(t205, t206); //Fp2 mul imag part end
    let t208 = circuit_sub(t204, in17); //Fp2 sub coeff 0/1
    let t209 = circuit_sub(t207, in18); //Fp2 sub coeff 1/1
    let t210 = circuit_mul(t189, in15); //Fp2 mul start
    let t211 = circuit_mul(t190, in16);
    let t212 = circuit_sub(t210, t211); //Fp2 mul real part end
    let t213 = circuit_mul(t189, in16);
    let t214 = circuit_mul(t190, in15);
    let t215 = circuit_add(t213, t214); //Fp2 mul imag part end
    let t216 = circuit_sub(t212, in17); //Fp2 sub coeff 0/1
    let t217 = circuit_sub(t215, in18); //Fp2 sub coeff 1/1
    let t218 = circuit_mul(in1, t190);
    let t219 = circuit_add(t189, t218);
    let t220 = circuit_mul(t219, in14);
    let t221 = circuit_mul(in1, t217);
    let t222 = circuit_add(t216, t221);
    let t223 = circuit_mul(t222, in13);
    let t224 = circuit_mul(t190, in14);
    let t225 = circuit_mul(t217, in13);
    let t226 = circuit_mul(t164, in48);
    let t227 = circuit_add(in2, t226);
    let t228 = circuit_mul(t167, t1);
    let t229 = circuit_add(t227, t228);
    let t230 = circuit_mul(t168, t5);
    let t231 = circuit_add(t229, t230);
    let t232 = circuit_mul(t169, t7);
    let t233 = circuit_add(t231, t232);
    let t234 = circuit_mul(t127, t233);
    let t235 = circuit_mul(t220, in48);
    let t236 = circuit_add(in2, t235);
    let t237 = circuit_mul(t223, t1);
    let t238 = circuit_add(t236, t237);
    let t239 = circuit_mul(t224, t5);
    let t240 = circuit_add(t238, t239);
    let t241 = circuit_mul(t225, t7);
    let t242 = circuit_add(t240, t241);
    let t243 = circuit_mul(t234, t242);
    let t244 = circuit_sub(in27, in31); //Fp2 sub coeff 0/1
    let t245 = circuit_sub(in28, in32); //Fp2 sub coeff 1/1
    let t246 = circuit_sub(in25, in29); //Fp2 sub coeff 0/1
    let t247 = circuit_sub(in26, in30); //Fp2 sub coeff 1/1
    let t248 = circuit_mul(t246, t246); //Fp2 Div x/y start : Fp2 Inv y start
    let t249 = circuit_mul(t247, t247);
    let t250 = circuit_add(t248, t249);
    let t251 = circuit_inverse(t250);
    let t252 = circuit_mul(t246, t251); //Fp2 Inv y real part end
    let t253 = circuit_mul(t247, t251);
    let t254 = circuit_sub(in0, t253); //Fp2 Inv y imag part end
    let t255 = circuit_mul(t244, t252); //Fp2 mul start
    let t256 = circuit_mul(t245, t254);
    let t257 = circuit_sub(t255, t256); //Fp2 mul real part end
    let t258 = circuit_mul(t244, t254);
    let t259 = circuit_mul(t245, t252);
    let t260 = circuit_add(t258, t259); //Fp2 mul imag part end
    let t261 = circuit_add(t257, t260);
    let t262 = circuit_sub(t257, t260);
    let t263 = circuit_mul(t261, t262);
    let t264 = circuit_mul(t257, t260);
    let t265 = circuit_add(t264, t264);
    let t266 = circuit_add(in25, in29); //Fp2 add coeff 0/1
    let t267 = circuit_add(in26, in30); //Fp2 add coeff 1/1
    let t268 = circuit_sub(t263, t266); //Fp2 sub coeff 0/1
    let t269 = circuit_sub(t265, t267); //Fp2 sub coeff 1/1
    let t270 = circuit_mul(t257, in25); //Fp2 mul start
    let t271 = circuit_mul(t260, in26);
    let t272 = circuit_sub(t270, t271); //Fp2 mul real part end
    let t273 = circuit_mul(t257, in26);
    let t274 = circuit_mul(t260, in25);
    let t275 = circuit_add(t273, t274); //Fp2 mul imag part end
    let t276 = circuit_sub(t272, in27); //Fp2 sub coeff 0/1
    let t277 = circuit_sub(t275, in28); //Fp2 sub coeff 1/1
    let t278 = circuit_mul(in1, t260);
    let t279 = circuit_add(t257, t278);
    let t280 = circuit_mul(t279, in24);
    let t281 = circuit_mul(in1, t277);
    let t282 = circuit_add(t276, t281);
    let t283 = circuit_mul(t282, in23);
    let t284 = circuit_mul(t260, in24);
    let t285 = circuit_mul(t277, in23);
    let t286 = circuit_add(in27, in27); //Fp2 add coeff 0/1
    let t287 = circuit_add(in28, in28); //Fp2 add coeff 1/1
    let t288 = circuit_sub(t268, in25); //Fp2 sub coeff 0/1
    let t289 = circuit_sub(t269, in26); //Fp2 sub coeff 1/1
    let t290 = circuit_mul(t288, t288); //Fp2 Div x/y start : Fp2 Inv y start
    let t291 = circuit_mul(t289, t289);
    let t292 = circuit_add(t290, t291);
    let t293 = circuit_inverse(t292);
    let t294 = circuit_mul(t288, t293); //Fp2 Inv y real part end
    let t295 = circuit_mul(t289, t293);
    let t296 = circuit_sub(in0, t295); //Fp2 Inv y imag part end
    let t297 = circuit_mul(t286, t294); //Fp2 mul start
    let t298 = circuit_mul(t287, t296);
    let t299 = circuit_sub(t297, t298); //Fp2 mul real part end
    let t300 = circuit_mul(t286, t296);
    let t301 = circuit_mul(t287, t294);
    let t302 = circuit_add(t300, t301); //Fp2 mul imag part end
    let t303 = circuit_add(t257, t299); //Fp2 add coeff 0/1
    let t304 = circuit_add(t260, t302); //Fp2 add coeff 1/1
    let t305 = circuit_sub(in0, t303); //Fp2 neg coeff 0/1
    let t306 = circuit_sub(in0, t304); //Fp2 neg coeff 1/1
    let t307 = circuit_add(t305, t306);
    let t308 = circuit_sub(t305, t306);
    let t309 = circuit_mul(t307, t308);
    let t310 = circuit_mul(t305, t306);
    let t311 = circuit_add(t310, t310);
    let t312 = circuit_sub(t309, in25); //Fp2 sub coeff 0/1
    let t313 = circuit_sub(t311, in26); //Fp2 sub coeff 1/1
    let t314 = circuit_sub(t312, t268); //Fp2 sub coeff 0/1
    let t315 = circuit_sub(t313, t269); //Fp2 sub coeff 1/1
    let t316 = circuit_sub(in25, t314); //Fp2 sub coeff 0/1
    let t317 = circuit_sub(in26, t315); //Fp2 sub coeff 1/1
    let t318 = circuit_mul(t305, t316); //Fp2 mul start
    let t319 = circuit_mul(t306, t317);
    let t320 = circuit_sub(t318, t319); //Fp2 mul real part end
    let t321 = circuit_mul(t305, t317);
    let t322 = circuit_mul(t306, t316);
    let t323 = circuit_add(t321, t322); //Fp2 mul imag part end
    let t324 = circuit_sub(t320, in27); //Fp2 sub coeff 0/1
    let t325 = circuit_sub(t323, in28); //Fp2 sub coeff 1/1
    let t326 = circuit_mul(t305, in25); //Fp2 mul start
    let t327 = circuit_mul(t306, in26);
    let t328 = circuit_sub(t326, t327); //Fp2 mul real part end
    let t329 = circuit_mul(t305, in26);
    let t330 = circuit_mul(t306, in25);
    let t331 = circuit_add(t329, t330); //Fp2 mul imag part end
    let t332 = circuit_sub(t328, in27); //Fp2 sub coeff 0/1
    let t333 = circuit_sub(t331, in28); //Fp2 sub coeff 1/1
    let t334 = circuit_mul(in1, t306);
    let t335 = circuit_add(t305, t334);
    let t336 = circuit_mul(t335, in24);
    let t337 = circuit_mul(in1, t333);
    let t338 = circuit_add(t332, t337);
    let t339 = circuit_mul(t338, in23);
    let t340 = circuit_mul(t306, in24);
    let t341 = circuit_mul(t333, in23);
    let t342 = circuit_mul(t280, in48);
    let t343 = circuit_add(in2, t342);
    let t344 = circuit_mul(t283, t1);
    let t345 = circuit_add(t343, t344);
    let t346 = circuit_mul(t284, t5);
    let t347 = circuit_add(t345, t346);
    let t348 = circuit_mul(t285, t7);
    let t349 = circuit_add(t347, t348);
    let t350 = circuit_mul(t243, t349);
    let t351 = circuit_mul(t336, in48);
    let t352 = circuit_add(in2, t351);
    let t353 = circuit_mul(t339, t1);
    let t354 = circuit_add(t352, t353);
    let t355 = circuit_mul(t340, t5);
    let t356 = circuit_add(t354, t355);
    let t357 = circuit_mul(t341, t7);
    let t358 = circuit_add(t356, t357);
    let t359 = circuit_mul(t350, t358);
    let t360 = circuit_mul(t359, in47);
    let t361 = circuit_mul(in36, in48);
    let t362 = circuit_add(in35, t361);
    let t363 = circuit_mul(in37, t0);
    let t364 = circuit_add(t362, t363);
    let t365 = circuit_mul(in38, t1);
    let t366 = circuit_add(t364, t365);
    let t367 = circuit_mul(in39, t2);
    let t368 = circuit_add(t366, t367);
    let t369 = circuit_mul(in40, t3);
    let t370 = circuit_add(t368, t369);
    let t371 = circuit_mul(in41, t4);
    let t372 = circuit_add(t370, t371);
    let t373 = circuit_mul(in42, t5);
    let t374 = circuit_add(t372, t373);
    let t375 = circuit_mul(in43, t6);
    let t376 = circuit_add(t374, t375);
    let t377 = circuit_mul(in44, t7);
    let t378 = circuit_add(t376, t377);
    let t379 = circuit_mul(in45, t8);
    let t380 = circuit_add(t378, t379);
    let t381 = circuit_mul(in46, t9);
    let t382 = circuit_add(t380, t381);
    let t383 = circuit_sub(t360, t382);
    let t384 = circuit_mul(t10, t383); //ci * ((Π(i,k) (Pk(z)) - Ri(z))
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
    circuit_inputs = circuit_inputs.next(u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 });
    circuit_inputs = circuit_inputs
        .next(
            u384 {
                limb0: 32324006162389411176778628414,
                limb1: 57042285082623239461879769745,
                limb2: 3486998266802970665,
                limb3: 0
            }
        );
    circuit_inputs = circuit_inputs.next(u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 });
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
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 3
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 6
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 0
    let in3 = CircuitElement::<
        CircuitInput<3>
    > {}; // 21888242871839275222246405745257275088696311157297823662689037894645226208574
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 1

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
    let t0 = circuit_mul(in30, in30); //Compute z^2
    let t1 = circuit_mul(t0, in30); //Compute z^3
    let t2 = circuit_mul(t1, in30); //Compute z^4
    let t3 = circuit_mul(t2, in30); //Compute z^5
    let t4 = circuit_mul(t3, in30); //Compute z^6
    let t5 = circuit_mul(t4, in30); //Compute z^7
    let t6 = circuit_mul(t5, in30); //Compute z^8
    let t7 = circuit_mul(t6, in30); //Compute z^9
    let t8 = circuit_mul(t7, in30); //Compute z^10
    let t9 = circuit_mul(t8, in30); //Compute z^11
    let t10 = circuit_mul(in18, in30);
    let t11 = circuit_add(in17, t10);
    let t12 = circuit_mul(in19, t0);
    let t13 = circuit_add(t11, t12);
    let t14 = circuit_mul(in20, t1);
    let t15 = circuit_add(t13, t14);
    let t16 = circuit_mul(in21, t2);
    let t17 = circuit_add(t15, t16);
    let t18 = circuit_mul(in22, t3);
    let t19 = circuit_add(t17, t18);
    let t20 = circuit_mul(in23, t4);
    let t21 = circuit_add(t19, t20);
    let t22 = circuit_mul(in24, t5);
    let t23 = circuit_add(t21, t22);
    let t24 = circuit_mul(in25, t6);
    let t25 = circuit_add(t23, t24);
    let t26 = circuit_mul(in26, t7);
    let t27 = circuit_add(t25, t26);
    let t28 = circuit_mul(in27, t8);
    let t29 = circuit_add(t27, t28);
    let t30 = circuit_mul(in28, t9);
    let t31 = circuit_add(t29, t30);
    let t32 = circuit_mul(in31, in31);
    let t33 = circuit_mul(in29, in29);
    let t34 = circuit_add(in7, in8); //Doubling slope numerator start
    let t35 = circuit_sub(in7, in8);
    let t36 = circuit_mul(t34, t35);
    let t37 = circuit_mul(in7, in8);
    let t38 = circuit_mul(t36, in0);
    let t39 = circuit_mul(t37, in1); //Doubling slope numerator end
    let t40 = circuit_add(in9, in9); //Fp2 add coeff 0/1
    let t41 = circuit_add(in10, in10); //Fp2 add coeff 1/1
    let t42 = circuit_mul(t40, t40); //Fp2 Div x/y start : Fp2 Inv y start
    let t43 = circuit_mul(t41, t41);
    let t44 = circuit_add(t42, t43);
    let t45 = circuit_inverse(t44);
    let t46 = circuit_mul(t40, t45); //Fp2 Inv y real part end
    let t47 = circuit_mul(t41, t45);
    let t48 = circuit_sub(in2, t47); //Fp2 Inv y imag part end
    let t49 = circuit_mul(t38, t46); //Fp2 mul start
    let t50 = circuit_mul(t39, t48);
    let t51 = circuit_sub(t49, t50); //Fp2 mul real part end
    let t52 = circuit_mul(t38, t48);
    let t53 = circuit_mul(t39, t46);
    let t54 = circuit_add(t52, t53); //Fp2 mul imag part end
    let t55 = circuit_add(t51, t54);
    let t56 = circuit_sub(t51, t54);
    let t57 = circuit_mul(t55, t56);
    let t58 = circuit_mul(t51, t54);
    let t59 = circuit_add(t58, t58);
    let t60 = circuit_add(in7, in7); //Fp2 add coeff 0/1
    let t61 = circuit_add(in8, in8); //Fp2 add coeff 1/1
    let t62 = circuit_sub(t57, t60); //Fp2 sub coeff 0/1
    let t63 = circuit_sub(t59, t61); //Fp2 sub coeff 1/1
    let t64 = circuit_sub(in7, t62); //Fp2 sub coeff 0/1
    let t65 = circuit_sub(in8, t63); //Fp2 sub coeff 1/1
    let t66 = circuit_mul(t51, t64); //Fp2 mul start
    let t67 = circuit_mul(t54, t65);
    let t68 = circuit_sub(t66, t67); //Fp2 mul real part end
    let t69 = circuit_mul(t51, t65);
    let t70 = circuit_mul(t54, t64);
    let t71 = circuit_add(t69, t70); //Fp2 mul imag part end
    let t72 = circuit_sub(t68, in9); //Fp2 sub coeff 0/1
    let t73 = circuit_sub(t71, in10); //Fp2 sub coeff 1/1
    let t74 = circuit_mul(t51, in7); //Fp2 mul start
    let t75 = circuit_mul(t54, in8);
    let t76 = circuit_sub(t74, t75); //Fp2 mul real part end
    let t77 = circuit_mul(t51, in8);
    let t78 = circuit_mul(t54, in7);
    let t79 = circuit_add(t77, t78); //Fp2 mul imag part end
    let t80 = circuit_sub(t76, in9); //Fp2 sub coeff 0/1
    let t81 = circuit_sub(t79, in10); //Fp2 sub coeff 1/1
    let t82 = circuit_mul(in3, t54);
    let t83 = circuit_add(t51, t82);
    let t84 = circuit_mul(t83, in6);
    let t85 = circuit_mul(in3, t81);
    let t86 = circuit_add(t80, t85);
    let t87 = circuit_mul(t86, in5);
    let t88 = circuit_mul(t54, in6);
    let t89 = circuit_mul(t81, in5);
    let t90 = circuit_mul(t84, in30);
    let t91 = circuit_add(in4, t90);
    let t92 = circuit_mul(t87, t1);
    let t93 = circuit_add(t91, t92);
    let t94 = circuit_mul(t88, t5);
    let t95 = circuit_add(t93, t94);
    let t96 = circuit_mul(t89, t7);
    let t97 = circuit_add(t95, t96);
    let t98 = circuit_mul(t32, t97);
    let t99 = circuit_add(in13, in14); //Doubling slope numerator start
    let t100 = circuit_sub(in13, in14);
    let t101 = circuit_mul(t99, t100);
    let t102 = circuit_mul(in13, in14);
    let t103 = circuit_mul(t101, in0);
    let t104 = circuit_mul(t102, in1); //Doubling slope numerator end
    let t105 = circuit_add(in15, in15); //Fp2 add coeff 0/1
    let t106 = circuit_add(in16, in16); //Fp2 add coeff 1/1
    let t107 = circuit_mul(t105, t105); //Fp2 Div x/y start : Fp2 Inv y start
    let t108 = circuit_mul(t106, t106);
    let t109 = circuit_add(t107, t108);
    let t110 = circuit_inverse(t109);
    let t111 = circuit_mul(t105, t110); //Fp2 Inv y real part end
    let t112 = circuit_mul(t106, t110);
    let t113 = circuit_sub(in2, t112); //Fp2 Inv y imag part end
    let t114 = circuit_mul(t103, t111); //Fp2 mul start
    let t115 = circuit_mul(t104, t113);
    let t116 = circuit_sub(t114, t115); //Fp2 mul real part end
    let t117 = circuit_mul(t103, t113);
    let t118 = circuit_mul(t104, t111);
    let t119 = circuit_add(t117, t118); //Fp2 mul imag part end
    let t120 = circuit_add(t116, t119);
    let t121 = circuit_sub(t116, t119);
    let t122 = circuit_mul(t120, t121);
    let t123 = circuit_mul(t116, t119);
    let t124 = circuit_add(t123, t123);
    let t125 = circuit_add(in13, in13); //Fp2 add coeff 0/1
    let t126 = circuit_add(in14, in14); //Fp2 add coeff 1/1
    let t127 = circuit_sub(t122, t125); //Fp2 sub coeff 0/1
    let t128 = circuit_sub(t124, t126); //Fp2 sub coeff 1/1
    let t129 = circuit_sub(in13, t127); //Fp2 sub coeff 0/1
    let t130 = circuit_sub(in14, t128); //Fp2 sub coeff 1/1
    let t131 = circuit_mul(t116, t129); //Fp2 mul start
    let t132 = circuit_mul(t119, t130);
    let t133 = circuit_sub(t131, t132); //Fp2 mul real part end
    let t134 = circuit_mul(t116, t130);
    let t135 = circuit_mul(t119, t129);
    let t136 = circuit_add(t134, t135); //Fp2 mul imag part end
    let t137 = circuit_sub(t133, in15); //Fp2 sub coeff 0/1
    let t138 = circuit_sub(t136, in16); //Fp2 sub coeff 1/1
    let t139 = circuit_mul(t116, in13); //Fp2 mul start
    let t140 = circuit_mul(t119, in14);
    let t141 = circuit_sub(t139, t140); //Fp2 mul real part end
    let t142 = circuit_mul(t116, in14);
    let t143 = circuit_mul(t119, in13);
    let t144 = circuit_add(t142, t143); //Fp2 mul imag part end
    let t145 = circuit_sub(t141, in15); //Fp2 sub coeff 0/1
    let t146 = circuit_sub(t144, in16); //Fp2 sub coeff 1/1
    let t147 = circuit_mul(in3, t119);
    let t148 = circuit_add(t116, t147);
    let t149 = circuit_mul(t148, in12);
    let t150 = circuit_mul(in3, t146);
    let t151 = circuit_add(t145, t150);
    let t152 = circuit_mul(t151, in11);
    let t153 = circuit_mul(t119, in12);
    let t154 = circuit_mul(t146, in11);
    let t155 = circuit_mul(t149, in30);
    let t156 = circuit_add(in4, t155);
    let t157 = circuit_mul(t152, t1);
    let t158 = circuit_add(t156, t157);
    let t159 = circuit_mul(t153, t5);
    let t160 = circuit_add(t158, t159);
    let t161 = circuit_mul(t154, t7);
    let t162 = circuit_add(t160, t161);
    let t163 = circuit_mul(t98, t162);
    let t164 = circuit_sub(t163, t31);
    let t165 = circuit_mul(t33, t164); //ci * ((Π(i,k) (Pk(z)) - Ri(z))
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
    circuit_inputs = circuit_inputs.next(u384 { limb0: 3, limb1: 0, limb2: 0, limb3: 0 });
    circuit_inputs = circuit_inputs.next(u384 { limb0: 6, limb1: 0, limb2: 0, limb3: 0 });
    circuit_inputs = circuit_inputs.next(u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 });
    circuit_inputs = circuit_inputs
        .next(
            u384 {
                limb0: 32324006162389411176778628414,
                limb1: 57042285082623239461879769745,
                limb2: 3486998266802970665,
                limb3: 0
            }
        );
    circuit_inputs = circuit_inputs.next(u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 });
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
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 3
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 6
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 0
    let in3 = CircuitElement::<
        CircuitInput<3>
    > {}; // 21888242871839275222246405745257275088696311157297823662689037894645226208574
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 1

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
    let t0 = circuit_mul(in36, in36); //Compute z^2
    let t1 = circuit_mul(t0, in36); //Compute z^3
    let t2 = circuit_mul(t1, in36); //Compute z^4
    let t3 = circuit_mul(t2, in36); //Compute z^5
    let t4 = circuit_mul(t3, in36); //Compute z^6
    let t5 = circuit_mul(t4, in36); //Compute z^7
    let t6 = circuit_mul(t5, in36); //Compute z^8
    let t7 = circuit_mul(t6, in36); //Compute z^9
    let t8 = circuit_mul(t7, in36); //Compute z^10
    let t9 = circuit_mul(t8, in36); //Compute z^11
    let t10 = circuit_mul(in24, in36);
    let t11 = circuit_add(in23, t10);
    let t12 = circuit_mul(in25, t0);
    let t13 = circuit_add(t11, t12);
    let t14 = circuit_mul(in26, t1);
    let t15 = circuit_add(t13, t14);
    let t16 = circuit_mul(in27, t2);
    let t17 = circuit_add(t15, t16);
    let t18 = circuit_mul(in28, t3);
    let t19 = circuit_add(t17, t18);
    let t20 = circuit_mul(in29, t4);
    let t21 = circuit_add(t19, t20);
    let t22 = circuit_mul(in30, t5);
    let t23 = circuit_add(t21, t22);
    let t24 = circuit_mul(in31, t6);
    let t25 = circuit_add(t23, t24);
    let t26 = circuit_mul(in32, t7);
    let t27 = circuit_add(t25, t26);
    let t28 = circuit_mul(in33, t8);
    let t29 = circuit_add(t27, t28);
    let t30 = circuit_mul(in34, t9);
    let t31 = circuit_add(t29, t30);
    let t32 = circuit_mul(in37, in37);
    let t33 = circuit_mul(in35, in35);
    let t34 = circuit_add(in7, in8); //Doubling slope numerator start
    let t35 = circuit_sub(in7, in8);
    let t36 = circuit_mul(t34, t35);
    let t37 = circuit_mul(in7, in8);
    let t38 = circuit_mul(t36, in0);
    let t39 = circuit_mul(t37, in1); //Doubling slope numerator end
    let t40 = circuit_add(in9, in9); //Fp2 add coeff 0/1
    let t41 = circuit_add(in10, in10); //Fp2 add coeff 1/1
    let t42 = circuit_mul(t40, t40); //Fp2 Div x/y start : Fp2 Inv y start
    let t43 = circuit_mul(t41, t41);
    let t44 = circuit_add(t42, t43);
    let t45 = circuit_inverse(t44);
    let t46 = circuit_mul(t40, t45); //Fp2 Inv y real part end
    let t47 = circuit_mul(t41, t45);
    let t48 = circuit_sub(in2, t47); //Fp2 Inv y imag part end
    let t49 = circuit_mul(t38, t46); //Fp2 mul start
    let t50 = circuit_mul(t39, t48);
    let t51 = circuit_sub(t49, t50); //Fp2 mul real part end
    let t52 = circuit_mul(t38, t48);
    let t53 = circuit_mul(t39, t46);
    let t54 = circuit_add(t52, t53); //Fp2 mul imag part end
    let t55 = circuit_add(t51, t54);
    let t56 = circuit_sub(t51, t54);
    let t57 = circuit_mul(t55, t56);
    let t58 = circuit_mul(t51, t54);
    let t59 = circuit_add(t58, t58);
    let t60 = circuit_add(in7, in7); //Fp2 add coeff 0/1
    let t61 = circuit_add(in8, in8); //Fp2 add coeff 1/1
    let t62 = circuit_sub(t57, t60); //Fp2 sub coeff 0/1
    let t63 = circuit_sub(t59, t61); //Fp2 sub coeff 1/1
    let t64 = circuit_sub(in7, t62); //Fp2 sub coeff 0/1
    let t65 = circuit_sub(in8, t63); //Fp2 sub coeff 1/1
    let t66 = circuit_mul(t51, t64); //Fp2 mul start
    let t67 = circuit_mul(t54, t65);
    let t68 = circuit_sub(t66, t67); //Fp2 mul real part end
    let t69 = circuit_mul(t51, t65);
    let t70 = circuit_mul(t54, t64);
    let t71 = circuit_add(t69, t70); //Fp2 mul imag part end
    let t72 = circuit_sub(t68, in9); //Fp2 sub coeff 0/1
    let t73 = circuit_sub(t71, in10); //Fp2 sub coeff 1/1
    let t74 = circuit_mul(t51, in7); //Fp2 mul start
    let t75 = circuit_mul(t54, in8);
    let t76 = circuit_sub(t74, t75); //Fp2 mul real part end
    let t77 = circuit_mul(t51, in8);
    let t78 = circuit_mul(t54, in7);
    let t79 = circuit_add(t77, t78); //Fp2 mul imag part end
    let t80 = circuit_sub(t76, in9); //Fp2 sub coeff 0/1
    let t81 = circuit_sub(t79, in10); //Fp2 sub coeff 1/1
    let t82 = circuit_mul(in3, t54);
    let t83 = circuit_add(t51, t82);
    let t84 = circuit_mul(t83, in6);
    let t85 = circuit_mul(in3, t81);
    let t86 = circuit_add(t80, t85);
    let t87 = circuit_mul(t86, in5);
    let t88 = circuit_mul(t54, in6);
    let t89 = circuit_mul(t81, in5);
    let t90 = circuit_mul(t84, in36);
    let t91 = circuit_add(in4, t90);
    let t92 = circuit_mul(t87, t1);
    let t93 = circuit_add(t91, t92);
    let t94 = circuit_mul(t88, t5);
    let t95 = circuit_add(t93, t94);
    let t96 = circuit_mul(t89, t7);
    let t97 = circuit_add(t95, t96);
    let t98 = circuit_mul(t32, t97);
    let t99 = circuit_add(in13, in14); //Doubling slope numerator start
    let t100 = circuit_sub(in13, in14);
    let t101 = circuit_mul(t99, t100);
    let t102 = circuit_mul(in13, in14);
    let t103 = circuit_mul(t101, in0);
    let t104 = circuit_mul(t102, in1); //Doubling slope numerator end
    let t105 = circuit_add(in15, in15); //Fp2 add coeff 0/1
    let t106 = circuit_add(in16, in16); //Fp2 add coeff 1/1
    let t107 = circuit_mul(t105, t105); //Fp2 Div x/y start : Fp2 Inv y start
    let t108 = circuit_mul(t106, t106);
    let t109 = circuit_add(t107, t108);
    let t110 = circuit_inverse(t109);
    let t111 = circuit_mul(t105, t110); //Fp2 Inv y real part end
    let t112 = circuit_mul(t106, t110);
    let t113 = circuit_sub(in2, t112); //Fp2 Inv y imag part end
    let t114 = circuit_mul(t103, t111); //Fp2 mul start
    let t115 = circuit_mul(t104, t113);
    let t116 = circuit_sub(t114, t115); //Fp2 mul real part end
    let t117 = circuit_mul(t103, t113);
    let t118 = circuit_mul(t104, t111);
    let t119 = circuit_add(t117, t118); //Fp2 mul imag part end
    let t120 = circuit_add(t116, t119);
    let t121 = circuit_sub(t116, t119);
    let t122 = circuit_mul(t120, t121);
    let t123 = circuit_mul(t116, t119);
    let t124 = circuit_add(t123, t123);
    let t125 = circuit_add(in13, in13); //Fp2 add coeff 0/1
    let t126 = circuit_add(in14, in14); //Fp2 add coeff 1/1
    let t127 = circuit_sub(t122, t125); //Fp2 sub coeff 0/1
    let t128 = circuit_sub(t124, t126); //Fp2 sub coeff 1/1
    let t129 = circuit_sub(in13, t127); //Fp2 sub coeff 0/1
    let t130 = circuit_sub(in14, t128); //Fp2 sub coeff 1/1
    let t131 = circuit_mul(t116, t129); //Fp2 mul start
    let t132 = circuit_mul(t119, t130);
    let t133 = circuit_sub(t131, t132); //Fp2 mul real part end
    let t134 = circuit_mul(t116, t130);
    let t135 = circuit_mul(t119, t129);
    let t136 = circuit_add(t134, t135); //Fp2 mul imag part end
    let t137 = circuit_sub(t133, in15); //Fp2 sub coeff 0/1
    let t138 = circuit_sub(t136, in16); //Fp2 sub coeff 1/1
    let t139 = circuit_mul(t116, in13); //Fp2 mul start
    let t140 = circuit_mul(t119, in14);
    let t141 = circuit_sub(t139, t140); //Fp2 mul real part end
    let t142 = circuit_mul(t116, in14);
    let t143 = circuit_mul(t119, in13);
    let t144 = circuit_add(t142, t143); //Fp2 mul imag part end
    let t145 = circuit_sub(t141, in15); //Fp2 sub coeff 0/1
    let t146 = circuit_sub(t144, in16); //Fp2 sub coeff 1/1
    let t147 = circuit_mul(in3, t119);
    let t148 = circuit_add(t116, t147);
    let t149 = circuit_mul(t148, in12);
    let t150 = circuit_mul(in3, t146);
    let t151 = circuit_add(t145, t150);
    let t152 = circuit_mul(t151, in11);
    let t153 = circuit_mul(t119, in12);
    let t154 = circuit_mul(t146, in11);
    let t155 = circuit_mul(t149, in36);
    let t156 = circuit_add(in4, t155);
    let t157 = circuit_mul(t152, t1);
    let t158 = circuit_add(t156, t157);
    let t159 = circuit_mul(t153, t5);
    let t160 = circuit_add(t158, t159);
    let t161 = circuit_mul(t154, t7);
    let t162 = circuit_add(t160, t161);
    let t163 = circuit_mul(t98, t162);
    let t164 = circuit_add(in19, in20); //Doubling slope numerator start
    let t165 = circuit_sub(in19, in20);
    let t166 = circuit_mul(t164, t165);
    let t167 = circuit_mul(in19, in20);
    let t168 = circuit_mul(t166, in0);
    let t169 = circuit_mul(t167, in1); //Doubling slope numerator end
    let t170 = circuit_add(in21, in21); //Fp2 add coeff 0/1
    let t171 = circuit_add(in22, in22); //Fp2 add coeff 1/1
    let t172 = circuit_mul(t170, t170); //Fp2 Div x/y start : Fp2 Inv y start
    let t173 = circuit_mul(t171, t171);
    let t174 = circuit_add(t172, t173);
    let t175 = circuit_inverse(t174);
    let t176 = circuit_mul(t170, t175); //Fp2 Inv y real part end
    let t177 = circuit_mul(t171, t175);
    let t178 = circuit_sub(in2, t177); //Fp2 Inv y imag part end
    let t179 = circuit_mul(t168, t176); //Fp2 mul start
    let t180 = circuit_mul(t169, t178);
    let t181 = circuit_sub(t179, t180); //Fp2 mul real part end
    let t182 = circuit_mul(t168, t178);
    let t183 = circuit_mul(t169, t176);
    let t184 = circuit_add(t182, t183); //Fp2 mul imag part end
    let t185 = circuit_add(t181, t184);
    let t186 = circuit_sub(t181, t184);
    let t187 = circuit_mul(t185, t186);
    let t188 = circuit_mul(t181, t184);
    let t189 = circuit_add(t188, t188);
    let t190 = circuit_add(in19, in19); //Fp2 add coeff 0/1
    let t191 = circuit_add(in20, in20); //Fp2 add coeff 1/1
    let t192 = circuit_sub(t187, t190); //Fp2 sub coeff 0/1
    let t193 = circuit_sub(t189, t191); //Fp2 sub coeff 1/1
    let t194 = circuit_sub(in19, t192); //Fp2 sub coeff 0/1
    let t195 = circuit_sub(in20, t193); //Fp2 sub coeff 1/1
    let t196 = circuit_mul(t181, t194); //Fp2 mul start
    let t197 = circuit_mul(t184, t195);
    let t198 = circuit_sub(t196, t197); //Fp2 mul real part end
    let t199 = circuit_mul(t181, t195);
    let t200 = circuit_mul(t184, t194);
    let t201 = circuit_add(t199, t200); //Fp2 mul imag part end
    let t202 = circuit_sub(t198, in21); //Fp2 sub coeff 0/1
    let t203 = circuit_sub(t201, in22); //Fp2 sub coeff 1/1
    let t204 = circuit_mul(t181, in19); //Fp2 mul start
    let t205 = circuit_mul(t184, in20);
    let t206 = circuit_sub(t204, t205); //Fp2 mul real part end
    let t207 = circuit_mul(t181, in20);
    let t208 = circuit_mul(t184, in19);
    let t209 = circuit_add(t207, t208); //Fp2 mul imag part end
    let t210 = circuit_sub(t206, in21); //Fp2 sub coeff 0/1
    let t211 = circuit_sub(t209, in22); //Fp2 sub coeff 1/1
    let t212 = circuit_mul(in3, t184);
    let t213 = circuit_add(t181, t212);
    let t214 = circuit_mul(t213, in18);
    let t215 = circuit_mul(in3, t211);
    let t216 = circuit_add(t210, t215);
    let t217 = circuit_mul(t216, in17);
    let t218 = circuit_mul(t184, in18);
    let t219 = circuit_mul(t211, in17);
    let t220 = circuit_mul(t214, in36);
    let t221 = circuit_add(in4, t220);
    let t222 = circuit_mul(t217, t1);
    let t223 = circuit_add(t221, t222);
    let t224 = circuit_mul(t218, t5);
    let t225 = circuit_add(t223, t224);
    let t226 = circuit_mul(t219, t7);
    let t227 = circuit_add(t225, t226);
    let t228 = circuit_mul(t163, t227);
    let t229 = circuit_sub(t228, t31);
    let t230 = circuit_mul(t33, t229); //ci * ((Π(i,k) (Pk(z)) - Ri(z))
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
    circuit_inputs = circuit_inputs.next(u384 { limb0: 3, limb1: 0, limb2: 0, limb3: 0 });
    circuit_inputs = circuit_inputs.next(u384 { limb0: 6, limb1: 0, limb2: 0, limb3: 0 });
    circuit_inputs = circuit_inputs.next(u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 });
    circuit_inputs = circuit_inputs
        .next(
            u384 {
                limb0: 32324006162389411176778628414,
                limb1: 57042285082623239461879769745,
                limb2: 3486998266802970665,
                limb3: 0
            }
        );
    circuit_inputs = circuit_inputs.next(u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 });
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
    lambda_root: E12D, z: u384, c_inv: E12D, c_0: u384
) -> (u384, u384, u384) {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 1

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
    let t0 = circuit_mul(in13, in13); //Compute z^2
    let t1 = circuit_mul(t0, in13); //Compute z^3
    let t2 = circuit_mul(t1, in13); //Compute z^4
    let t3 = circuit_mul(t2, in13); //Compute z^5
    let t4 = circuit_mul(t3, in13); //Compute z^6
    let t5 = circuit_mul(t4, in13); //Compute z^7
    let t6 = circuit_mul(t5, in13); //Compute z^8
    let t7 = circuit_mul(t6, in13); //Compute z^9
    let t8 = circuit_mul(t7, in13); //Compute z^10
    let t9 = circuit_mul(t8, in13); //Compute z^11
    let t10 = circuit_mul(in2, in13);
    let t11 = circuit_add(in1, t10);
    let t12 = circuit_mul(in3, t0);
    let t13 = circuit_add(t11, t12);
    let t14 = circuit_mul(in4, t1);
    let t15 = circuit_add(t13, t14);
    let t16 = circuit_mul(in5, t2);
    let t17 = circuit_add(t15, t16);
    let t18 = circuit_mul(in6, t3);
    let t19 = circuit_add(t17, t18);
    let t20 = circuit_mul(in7, t4);
    let t21 = circuit_add(t19, t20);
    let t22 = circuit_mul(in8, t5);
    let t23 = circuit_add(t21, t22);
    let t24 = circuit_mul(in9, t6);
    let t25 = circuit_add(t23, t24);
    let t26 = circuit_mul(in10, t7);
    let t27 = circuit_add(t25, t26);
    let t28 = circuit_mul(in11, t8);
    let t29 = circuit_add(t27, t28);
    let t30 = circuit_mul(in12, t9);
    let t31 = circuit_add(t29, t30);
    let t32 = circuit_mul(in15, in13);
    let t33 = circuit_add(in14, t32);
    let t34 = circuit_mul(in16, t0);
    let t35 = circuit_add(t33, t34);
    let t36 = circuit_mul(in17, t1);
    let t37 = circuit_add(t35, t36);
    let t38 = circuit_mul(in18, t2);
    let t39 = circuit_add(t37, t38);
    let t40 = circuit_mul(in19, t3);
    let t41 = circuit_add(t39, t40);
    let t42 = circuit_mul(in20, t4);
    let t43 = circuit_add(t41, t42);
    let t44 = circuit_mul(in21, t5);
    let t45 = circuit_add(t43, t44);
    let t46 = circuit_mul(in22, t6);
    let t47 = circuit_add(t45, t46);
    let t48 = circuit_mul(in23, t7);
    let t49 = circuit_add(t47, t48);
    let t50 = circuit_mul(in24, t8);
    let t51 = circuit_add(t49, t50);
    let t52 = circuit_mul(in25, t9);
    let t53 = circuit_add(t51, t52);
    let t54 = circuit_mul(t31, t53);
    let t55 = circuit_sub(t54, in0);
    let t56 = circuit_mul(t55, in26);

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [32324006162389411176778628423, 57042285082623239461879769745, 3486998266802970665, 0]
    )
        .unwrap();

    let mut circuit_inputs = (t31, t53, t56,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next(u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 });
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

    let c_inv_of_z: u384 = outputs.get_output(t53);

    let lhs: u384 = outputs.get_output(t56);
    return (c_of_z, c_inv_of_z, lhs);
}
fn run_BN254_MP_CHECK_PREPARE_PAIRS_2_circuit(
    p_0: G1Point, Qy0_0: u384, Qy1_0: u384, p_1: G1Point, Qy0_1: u384, Qy1_1: u384
) -> (BNProcessedPair, BNProcessedPair) {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0

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
    circuit_inputs = circuit_inputs.next(u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 });
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
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0

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
    circuit_inputs = circuit_inputs.next(u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 });
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
    use garaga::definitions::{G1Point, G2Point, E12D, G1G2Pair, BNProcessedPair, BLSProcessedPair};

    use super::{
        run_BLS12_381_MP_CHECK_BIT0_LOOP_2_circuit, run_BLS12_381_MP_CHECK_BIT0_LOOP_3_circuit,
        run_BLS12_381_MP_CHECK_BIT1_LOOP_2_circuit, run_BLS12_381_MP_CHECK_BIT1_LOOP_3_circuit,
        run_BLS12_381_MP_CHECK_INIT_BIT_2_circuit, run_BLS12_381_MP_CHECK_INIT_BIT_3_circuit,
        run_BLS12_381_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit,
        run_BLS12_381_MP_CHECK_PREPARE_PAIRS_2_circuit,
        run_BLS12_381_MP_CHECK_PREPARE_PAIRS_3_circuit, run_BN254_MP_CHECK_BIT0_LOOP_2_circuit,
        run_BN254_MP_CHECK_BIT0_LOOP_3_circuit, run_BN254_MP_CHECK_BIT1_LOOP_2_circuit,
        run_BN254_MP_CHECK_BIT1_LOOP_3_circuit, run_BN254_MP_CHECK_INIT_BIT_2_circuit,
        run_BN254_MP_CHECK_INIT_BIT_3_circuit, run_BN254_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit,
        run_BN254_MP_CHECK_PREPARE_PAIRS_2_circuit, run_BN254_MP_CHECK_PREPARE_PAIRS_3_circuit
    };

    #[test]
    fn test_run_BLS12_381_MP_CHECK_BIT0_LOOP_2_circuit_BLS12_381() {
        let yInv_0: u384 = u384 {
            limb0: 47088660665051639323314904946,
            limb1: 11343857265095926237689300501,
            limb2: 13642033336194308973192438618,
            limb3: 1414861483587575643183425065
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 12622980785135870370349387532,
            limb1: 55956565876568950325210237280,
            limb2: 18671687011382651591787996878,
            limb3: 2550368669628435998581203648
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 71748575666667524779763406414,
                limb1: 4400787913938860623202478428,
                limb2: 30395438834006772742415078167,
                limb3: 2631176083833731421721126721
            },
            x1: u384 {
                limb0: 47500207701806360179989350131,
                limb1: 31294225550209865998621313047,
                limb2: 55873096655807981536953024992,
                limb3: 216367933022331547968003430
            },
            y0: u384 {
                limb0: 72739772177199368875012111997,
                limb1: 50646238511179090516392886957,
                limb2: 37905917079515061844551827615,
                limb3: 7929833589997806968256182486
            },
            y1: u384 {
                limb0: 48282503915786966619728240560,
                limb1: 42602163310215721088597179280,
                limb2: 75213112001549193674534087601,
                limb3: 3009780361777360037717185439
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 52232819895707243583090466179,
            limb1: 41128810680288520668519268493,
            limb2: 48149368306159191575096527521,
            limb3: 4899826980232960785376229875
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 33903917845639907238424610517,
            limb1: 37803383143010877678245510289,
            limb2: 35092082232192219818020684861,
            limb3: 183933349458379669738904352
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 33255935080999593322010739847,
                limb1: 29654451111769722055732702646,
                limb2: 50303354856283600149796628712,
                limb3: 916181643161307175265925628
            },
            x1: u384 {
                limb0: 14992568962268653302838617066,
                limb1: 8989598582407023706435623159,
                limb2: 4963342253325647727168479064,
                limb3: 7556968721124907549173241262
            },
            y0: u384 {
                limb0: 76770779635821044543853263759,
                limb1: 10184139909084910444072142078,
                limb2: 71942627077241151157769003474,
                limb3: 6004273571921005667717015014
            },
            y1: u384 {
                limb0: 58212833235768401452619462058,
                limb1: 43587602715795463455487771906,
                limb2: 56834610926090630251506506492,
                limb3: 1787584750546672954403423122
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 43135403876906686023966817413,
            limb1: 30049377669065918600277370769,
            limb2: 19609924093633503824664051707,
            limb3: 1536247712089382972878981570
        };

        let f_i_of_z: u384 = u384 {
            limb0: 74269299958302919334432930581,
            limb1: 60648361019014293894296609949,
            limb2: 64133468835651126793800475384,
            limb3: 6089904425526401174207641407
        };

        let f_i_plus_one: E12D = E12D {
            w0: u384 {
                limb0: 70018412935563191787366126718,
                limb1: 19067548216510616574671468219,
                limb2: 7993861035600990430325490666,
                limb3: 4421338143680592246255434076
            },
            w1: u384 {
                limb0: 55720078161204908314853928519,
                limb1: 19389837001322364617894744119,
                limb2: 31870744329602161082283334058,
                limb3: 5345522220639409288232558069
            },
            w2: u384 {
                limb0: 52307417047231693147131918114,
                limb1: 32765615238513840021604185503,
                limb2: 4829561550775333585773502820,
                limb3: 5859587353903169931615474701
            },
            w3: u384 {
                limb0: 72222623364786838198572871164,
                limb1: 53776125276394775079854376793,
                limb2: 39267124759138234012238939255,
                limb3: 3410919230098893743264405642
            },
            w4: u384 {
                limb0: 53189234716864883716434677404,
                limb1: 41552244423600262869607995792,
                limb2: 32984635856191571190322074840,
                limb3: 2969951790082216753392495726
            },
            w5: u384 {
                limb0: 59771001339276502909923078635,
                limb1: 19091466605364248184515570352,
                limb2: 23826793378660448892540053583,
                limb3: 1429590433856337614391988892
            },
            w6: u384 {
                limb0: 72473262665696276460318709950,
                limb1: 32695678878767106912814133565,
                limb2: 44152805558937558042888164855,
                limb3: 3846715980213197109283621670
            },
            w7: u384 {
                limb0: 16109995707773253347583982025,
                limb1: 6264604965108503460820295044,
                limb2: 67116821360149629032266662552,
                limb3: 5304677400400776422301298511
            },
            w8: u384 {
                limb0: 15091509011716987383820739108,
                limb1: 29882325776101867141156929838,
                limb2: 47768406120576943380124517188,
                limb3: 720821132170216047720253919
            },
            w9: u384 {
                limb0: 75822917065002336103373284901,
                limb1: 16781140604613505672218400611,
                limb2: 76223636754339171586158474192,
                limb3: 7396733566731110493667283376
            },
            w10: u384 {
                limb0: 37944020883832562943516734310,
                limb1: 55113192097621221645657625388,
                limb2: 16203200675942425561795268373,
                limb3: 2370219008518807251113848225
            },
            w11: u384 {
                limb0: 61442540272462832164834447774,
                limb1: 36940167363618433895314657619,
                limb2: 28463474798457868849692625782,
                limb3: 3561747765528354116192224077
            }
        };

        let ci: u384 = u384 {
            limb0: 39398366155023859807039255002,
            limb1: 63605685389727592511768890106,
            limb2: 37196863332228252891354738606,
            limb3: 3171436844580382428855147944
        };

        let z: u384 = u384 {
            limb0: 33083943349947317358023587302,
            limb1: 15543914752000320347242084555,
            limb2: 265193418533244205,
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
                limb0: 58622281313683911508443130742,
                limb1: 77971978542210827109229460279,
                limb2: 9098009217206285358639573032,
                limb3: 760466590330028640345894687
            },
            x1: u384 {
                limb0: 44774404830235592189598626204,
                limb1: 7302469575553260629655043275,
                limb2: 11399098030979505247978820393,
                limb3: 4549780407931028160813291520
            },
            y0: u384 {
                limb0: 5049189166682449577842590881,
                limb1: 70879848842249825799858957161,
                limb2: 68435126637335354686414579051,
                limb3: 7706277801220871423992091511
            },
            y1: u384 {
                limb0: 9438200657476154709288319302,
                limb1: 10930758121053580827917907618,
                limb2: 54420988786012243210694317082,
                limb3: 2341952466247285626327572815
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 3627763885611717495149519862,
                limb1: 55781565076190839594729187371,
                limb2: 17817863890254024343629747155,
                limb3: 5418483791071612423363222006
            },
            x1: u384 {
                limb0: 45114691886211683560514178778,
                limb1: 34363020576374688163462879639,
                limb2: 38161225916160412286110577781,
                limb3: 2557413960143159359931518407
            },
            y0: u384 {
                limb0: 10596159088654815773387690183,
                limb1: 13637123253969615111736522770,
                limb2: 66757949058856842354707711313,
                limb3: 4283842230140703999062732567
            },
            y1: u384 {
                limb0: 34842174925452941938339896148,
                limb1: 36641869178582721043738654317,
                limb2: 35930905190094997436093999591,
                limb3: 3429405053641323008073249820
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 67905690879529877021561844369,
            limb1: 42333147875485788487826302536,
            limb2: 36334623251245222740038114681,
            limb3: 7230035741077641196098632632
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 70362509902949483239832105109,
            limb1: 31348555587373081454404604576,
            limb2: 64954451581788530096881751440,
            limb3: 5411035809492687040862460844
        };

        let ci_plus_one: u384 = u384 {
            limb0: 21527989314898240346485525692,
            limb1: 29818663562710018924858485876,
            limb2: 36626580144255113956862086289,
            limb3: 2977881014463513865976223439
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
            limb0: 37215391062038370983582426243,
            limb1: 47552915740670660472234075082,
            limb2: 67414925069523384126686049660,
            limb3: 3401552798329380630102199181
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 6959518136797077528166260762,
            limb1: 28023445867815883765515434129,
            limb2: 65627057815622490221728987417,
            limb3: 2454801582622700088857986274
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 27689810172292237359225208209,
                limb1: 77600286970345334442252617655,
                limb2: 17082350664710062909727978799,
                limb3: 3217384217857134669771648348
            },
            x1: u384 {
                limb0: 64186722863892472401960101849,
                limb1: 15330133778985174415291539804,
                limb2: 51432022049219699636866513049,
                limb3: 2879074864588290199719730029
            },
            y0: u384 {
                limb0: 78278426448700969668669102929,
                limb1: 30495672018423312982946214992,
                limb2: 71340081997915272250476670447,
                limb3: 3738347447523600034720008168
            },
            y1: u384 {
                limb0: 71352998290085952245728002444,
                limb1: 17810110302548140161885046155,
                limb2: 77200296319509876112306755392,
                limb3: 5220099122968685198306066421
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 64072569333352649359188163275,
            limb1: 11311173269008972620562721889,
            limb2: 15296289301303604376316389629,
            limb3: 4061873623979142317110482259
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 39644929370407172916098256884,
            limb1: 71298616808354531611400154850,
            limb2: 55689937833925228975402830457,
            limb3: 7862022692775342217658060474
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 27636163182654519607089030635,
                limb1: 78007934444279548999327017301,
                limb2: 18438265467434423619156765355,
                limb3: 2111813866862191267939397202
            },
            x1: u384 {
                limb0: 57794259810457724198804277096,
                limb1: 44573741539447232459412389746,
                limb2: 43218801675218238525669220744,
                limb3: 6434928672862097240297456914
            },
            y0: u384 {
                limb0: 50816674567615727083688073449,
                limb1: 55733440910285242121243249709,
                limb2: 25644708750709493445388992323,
                limb3: 901582789709461640142095580
            },
            y1: u384 {
                limb0: 68160802856056694428491412660,
                limb1: 14436836050778089367631587771,
                limb2: 58083164238336050895851101433,
                limb3: 2488743334405297539439741747
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 35057435854627907016501580562,
            limb1: 64205866251173712175241182470,
            limb2: 2443139304462343909038362208,
            limb3: 98069065588236572381999161
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 28029341350794248350148536386,
            limb1: 49571474119333245372450945186,
            limb2: 72196401564271019371127430377,
            limb3: 4898134480939567562341452295
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 49556061022902061949748623663,
                limb1: 27743913080390964592509951450,
                limb2: 33836888761681110917102021436,
                limb3: 2263659976975883087166598987
            },
            x1: u384 {
                limb0: 51409782376085465307868358071,
                limb1: 23477912703267760871934370723,
                limb2: 23713331533934161696556881822,
                limb3: 3765197345782912701157149427
            },
            y0: u384 {
                limb0: 74468098209001319323925934985,
                limb1: 69538534580980886478677287654,
                limb2: 12456253103772212631304808590,
                limb3: 3958854949633432958051171143
            },
            y1: u384 {
                limb0: 18678178161573544392114978011,
                limb1: 67600643156213863085663181820,
                limb2: 33139046637593774765363735225,
                limb3: 3347423679915529395499958164
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 38651806883135503573949039739,
            limb1: 42166217039879128525060898628,
            limb2: 938930979904839197444834087,
            limb3: 7152250315834917542005582370
        };

        let f_i_of_z: u384 = u384 {
            limb0: 8478714668604153397229578304,
            limb1: 41546091886777243953262837700,
            limb2: 15206424173661026713421620565,
            limb3: 2499828684456317308650517768
        };

        let f_i_plus_one: E12D = E12D {
            w0: u384 {
                limb0: 21179647753745700031023932395,
                limb1: 6260549849644097331548713608,
                limb2: 32168805582846460272670953195,
                limb3: 2408614313429590537867944016
            },
            w1: u384 {
                limb0: 17894255523827696133929429363,
                limb1: 65605836511669437962813907797,
                limb2: 51794279726333167648056922523,
                limb3: 6436242883711506376197825711
            },
            w2: u384 {
                limb0: 7407873018942019753299163115,
                limb1: 29882452064555739968236966283,
                limb2: 4445883334166209302101874546,
                limb3: 6960641245431466611278212099
            },
            w3: u384 {
                limb0: 41845081304245765387231797783,
                limb1: 18203977599127078082072907586,
                limb2: 68779305899262486619646553488,
                limb3: 5613158294822040655812478070
            },
            w4: u384 {
                limb0: 3689019213319622367894987530,
                limb1: 54226031392934695683365385132,
                limb2: 71250809679262361924914061395,
                limb3: 6517598295408943730675421011
            },
            w5: u384 {
                limb0: 71030089302436184398749484145,
                limb1: 30411430214207053454165298365,
                limb2: 11088028192413191953777138636,
                limb3: 6826600967605527088679752987
            },
            w6: u384 {
                limb0: 39676897033835903782039505063,
                limb1: 27401812644757148737331412384,
                limb2: 34629699197043153688099490991,
                limb3: 752848276352633966443743757
            },
            w7: u384 {
                limb0: 60926904915408242053844375049,
                limb1: 47188980042171238920535557529,
                limb2: 61287334600195892044645684386,
                limb3: 6280049527094584476718427020
            },
            w8: u384 {
                limb0: 78640755201780325721893814925,
                limb1: 18074985447489569851914535397,
                limb2: 74565018317320902205391663448,
                limb3: 1839458487769837879925930955
            },
            w9: u384 {
                limb0: 52343821265010659943897922430,
                limb1: 61177404588350133967323427357,
                limb2: 63228445326532604519069359226,
                limb3: 727974942581774962874864948
            },
            w10: u384 {
                limb0: 12218643498001805356461748592,
                limb1: 62106186745474177113940012523,
                limb2: 58601529765828798958017139741,
                limb3: 3572202089813969403266352157
            },
            w11: u384 {
                limb0: 411607662441181101798386652,
                limb1: 35235605642245758550607779705,
                limb2: 21373099817817183977400929677,
                limb3: 864549921073573812356503196
            }
        };

        let ci: u384 = u384 {
            limb0: 35561059779314423023665735806,
            limb1: 40599746659964672147205820967,
            limb2: 2080682532570759304926565701,
            limb3: 5488727119441229414690538146
        };

        let z: u384 = u384 {
            limb0: 47381910934720358798899482418,
            limb1: 68430804022836017467925527013,
            limb2: 14227763722384344,
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
                limb0: 35197946970235666248235856023,
                limb1: 8306364571264387637442195229,
                limb2: 65898557784141556764257843365,
                limb3: 2817923417681326210077188823
            },
            x1: u384 {
                limb0: 23830324131346647992868470340,
                limb1: 72268109718295228699865141589,
                limb2: 926241404823810125224827020,
                limb3: 2489664872133121598064582842
            },
            y0: u384 {
                limb0: 15836465020822662092207080239,
                limb1: 44096802308617956036579825658,
                limb2: 6988113785904054704886206148,
                limb3: 5368768873257879487354786733
            },
            y1: u384 {
                limb0: 46488025935386566106253151511,
                limb1: 16963852607014216938992835463,
                limb2: 25242304164926009880411287626,
                limb3: 7515462784575566798263953767
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 2384564798779569355159382034,
                limb1: 60215600648826797626096178396,
                limb2: 54957589714874469519396840424,
                limb3: 5436601215120058025870906439
            },
            x1: u384 {
                limb0: 22606055591134355559401731779,
                limb1: 1782053740969549288197373866,
                limb2: 61692837206667779361406095010,
                limb3: 3777641097281103330445203944
            },
            y0: u384 {
                limb0: 4343763931366866767948101689,
                limb1: 28316517661573966864166604557,
                limb2: 52133108185086368611206807713,
                limb3: 6576219747622118899348254456
            },
            y1: u384 {
                limb0: 57135996339637097852245683173,
                limb1: 76130673833732286102150359500,
                limb2: 40270894763161559278807710721,
                limb3: 1333985392129749077003635281
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 64632988323992512823133291845,
                limb1: 54724196257618147139622430704,
                limb2: 14229007931136592145077822008,
                limb3: 1049534732694276794551552850
            },
            x1: u384 {
                limb0: 5453561019760244119945967700,
                limb1: 8430506644136781492271145470,
                limb2: 2806855024719302795862002290,
                limb3: 2089646547234073753422908709
            },
            y0: u384 {
                limb0: 41329895822491606455076565707,
                limb1: 39124667441056980484589378782,
                limb2: 12997837521179961009636485765,
                limb3: 5138228034786062618611891890
            },
            y1: u384 {
                limb0: 63279977945122005871255600162,
                limb1: 46319574783033918271766816753,
                limb2: 32721985590407543050635397187,
                limb3: 2133640960737363043210969
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 58376972949335714457720540904,
            limb1: 53030591329920672628877798768,
            limb2: 19869459837856355512426168170,
            limb3: 2712640790757574647780646890
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 40350336090358621472947047798,
            limb1: 51927940064944107962542880616,
            limb2: 40059191816185268045405716728,
            limb3: 7927964759278433055076888597
        };

        let ci_plus_one: u384 = u384 {
            limb0: 44729392058352499194871779261,
            limb1: 28346247772799292438092017140,
            limb2: 57248350693842651391939879003,
            limb3: 2462672312488863419519495840
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
            limb0: 19829648569840764904404260100,
            limb1: 27002760895600554890521108006,
            limb2: 3265191537841501219120317699,
            limb3: 7511092674084711019815655154
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 16917223218748272307561360267,
            limb1: 23544124825052330615442279120,
            limb2: 30221634481852102062813871482,
            limb3: 3093438706857129563314311516
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 44228751411278796658778295168,
                limb1: 67503095977297891381084751091,
                limb2: 22223099022135043818354342432,
                limb3: 4379023817363819863876177247
            },
            x1: u384 {
                limb0: 41866924202384491639106934791,
                limb1: 45577397782351072953048602678,
                limb2: 37505057948051990047457718333,
                limb3: 988367526097145686997899042
            },
            y0: u384 {
                limb0: 20563818247614228919638698714,
                limb1: 69450697944790993442081180293,
                limb2: 64533599482368455912786877627,
                limb3: 7487178529157103843185262990
            },
            y1: u384 {
                limb0: 51747129649091754734351173498,
                limb1: 19844967807531250530793890379,
                limb2: 32712076866097346472677415475,
                limb3: 235430727244597776955452655
            }
        };

        let Q_or_Qneg_0: G2Point = G2Point {
            x0: u384 {
                limb0: 63892276529700526516498436370,
                limb1: 31400519618635734977976392236,
                limb2: 20200104773669693486487280014,
                limb3: 7323714921551863054779580316
            },
            x1: u384 {
                limb0: 52073027615366567699055575145,
                limb1: 44456673592436578335265162723,
                limb2: 35359658494035415610757840606,
                limb3: 3202929755811603110121612122
            },
            y0: u384 {
                limb0: 45576802683499094156818229468,
                limb1: 44079355996442357605168632261,
                limb2: 22715107491442469128552908658,
                limb3: 837668797331048410574413424
            },
            y1: u384 {
                limb0: 79168851049139655421275628223,
                limb1: 45707886362314676616524353486,
                limb2: 13760171017551606724443463950,
                limb3: 5002133144218044978885893712
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 60576271868711767728393654187,
            limb1: 37889702761793860743944295855,
            limb2: 62095095510182495182724279091,
            limb3: 2683721945368429065450886361
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 54763898711649111717252677565,
            limb1: 28122049354512412109957779607,
            limb2: 16990868544494816096316804289,
            limb3: 4522181860969789885595100601
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 30406128399222674855090597854,
                limb1: 13960653474564215880864828079,
                limb2: 68561724189471400726976976768,
                limb3: 3167147928810055211140948998
            },
            x1: u384 {
                limb0: 58295122211413226979799103270,
                limb1: 9572092318369745779239638946,
                limb2: 40471922423955454667401563021,
                limb3: 3813753321198581558140689738
            },
            y0: u384 {
                limb0: 11253820150265516684001749724,
                limb1: 8916091837975744422551457149,
                limb2: 27408962187740434644864453417,
                limb3: 5321753006302687168612240297
            },
            y1: u384 {
                limb0: 34933894265269580042075797682,
                limb1: 61657583062800599483407748231,
                limb2: 639600877038213552662389807,
                limb3: 3721568099315892955820336801
            }
        };

        let Q_or_Qneg_1: G2Point = G2Point {
            x0: u384 {
                limb0: 76288635767857977392992019050,
                limb1: 53385058452976412498553604649,
                limb2: 11704930419217172855625728035,
                limb3: 122012669497589048081524376
            },
            x1: u384 {
                limb0: 7451906912748847690003529852,
                limb1: 77138265170723468376909224685,
                limb2: 30544403580627601562160095090,
                limb3: 306824317733053982203404260
            },
            y0: u384 {
                limb0: 39030602982478998885462864519,
                limb1: 56482862565984550720370104604,
                limb2: 41825742032779681914924465450,
                limb3: 6462719138750473216655029764
            },
            y1: u384 {
                limb0: 55291612600107637804701342180,
                limb1: 34695473894176641949427607643,
                limb2: 5476081988562714525385486005,
                limb3: 2245706096252358690584819719
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 26320959201264999163194906664,
            limb1: 30097983070440795525981927821,
            limb2: 26108984648453497556164932704,
            limb3: 4264616456260183762658292484
        };

        let f_i_of_z: u384 = u384 {
            limb0: 68097276310759111007450365976,
            limb1: 47092659150862513455619529189,
            limb2: 25405710839762199274780691891,
            limb3: 6885841412612916197764894137
        };

        let f_i_plus_one: E12D = E12D {
            w0: u384 {
                limb0: 24892164094922085070136869067,
                limb1: 31551790272536881111246676689,
                limb2: 23090901643362524211697311823,
                limb3: 6267962384100473714899991026
            },
            w1: u384 {
                limb0: 45625857385944902514458666922,
                limb1: 25819367988051833855222446333,
                limb2: 64689360107829623266069522697,
                limb3: 3614938843807844534735244435
            },
            w2: u384 {
                limb0: 44672840202493600035804528794,
                limb1: 79011467571090719751834835079,
                limb2: 54010839352363926320902461726,
                limb3: 266564187322588257952373617
            },
            w3: u384 {
                limb0: 36573480464110046442964917297,
                limb1: 16610057082696090222835715535,
                limb2: 23081636387597527925613565311,
                limb3: 684914283241425492329292412
            },
            w4: u384 {
                limb0: 63038428857113857329272961568,
                limb1: 53318782635953183120708607026,
                limb2: 50178050905455957855641425390,
                limb3: 2502438210966320128821981373
            },
            w5: u384 {
                limb0: 56666864946633634305269441266,
                limb1: 29868290045521462088191581459,
                limb2: 78491388938919610483773235457,
                limb3: 5766265451444923384447775082
            },
            w6: u384 {
                limb0: 70948939198017637917443891179,
                limb1: 47047262646413943125805543876,
                limb2: 6732962710776733075907791297,
                limb3: 2458360445145406045734019705
            },
            w7: u384 {
                limb0: 28126696595142259056653669599,
                limb1: 48541344602077553166382344387,
                limb2: 77929470974560362735622096672,
                limb3: 6405038478782685328894378960
            },
            w8: u384 {
                limb0: 59633673608231629403131304226,
                limb1: 63083924045751506426866664825,
                limb2: 835680969022412450803373480,
                limb3: 2198592223542733538619967363
            },
            w9: u384 {
                limb0: 41103393929542119213292563844,
                limb1: 54482387427977708600408188941,
                limb2: 35318215879089277793577640095,
                limb3: 4585955898265975260801551568
            },
            w10: u384 {
                limb0: 46632900907848974060236585067,
                limb1: 11943244054127220234844667852,
                limb2: 1946054004962126927978547291,
                limb3: 2925819005526295050829882065
            },
            w11: u384 {
                limb0: 76195931842698326556890979734,
                limb1: 65863777212894414656264377475,
                limb2: 11224663760545750381470164751,
                limb3: 3397567851937740535372714247
            }
        };

        let c_or_cinv_of_z: u384 = u384 {
            limb0: 16389717846579004346238807531,
            limb1: 27595192399467847342948337669,
            limb2: 34715082313170402213395548586,
            limb3: 4480819995774558746071832648
        };

        let z: u384 = u384 {
            limb0: 23789371757312474206636870954,
            limb1: 56313713554212618860563028275,
            limb2: 26038858201578086,
            limb3: 0
        };

        let ci: u384 = u384 {
            limb0: 51337466239587086441981926514,
            limb1: 63386501316442999367833432386,
            limb2: 77952626404397300044623191071,
            limb3: 5110156118002367820670744602
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
                limb0: 1103665581379970310277812319,
                limb1: 37541437905376664332393327216,
                limb2: 36669983045980045388858479812,
                limb3: 5971690271474487607058288418
            },
            x1: u384 {
                limb0: 59694352214177244099663252025,
                limb1: 73780000911541496524818416439,
                limb2: 96933195686811130590844933,
                limb3: 6283191938946958505312721091
            },
            y0: u384 {
                limb0: 17149556489629416426995801453,
                limb1: 78925251007530642755200005786,
                limb2: 61151470776633559888526880044,
                limb3: 4067235538704299520584972050
            },
            y1: u384 {
                limb0: 66009021162545350651863615800,
                limb1: 42463039955564181541396966715,
                limb2: 40706484837365029090501596202,
                limb3: 3543320194886702647368063219
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 68053849960519034955424427606,
                limb1: 36344120367064607350215084963,
                limb2: 60069102435149385023345111870,
                limb3: 6239315138946604550530654130
            },
            x1: u384 {
                limb0: 565518066867558218888112595,
                limb1: 35089213795487358522004533123,
                limb2: 21108117365454682625013801802,
                limb3: 7252222692011162039545264566
            },
            y0: u384 {
                limb0: 3958105550647604489023557577,
                limb1: 4076772980826142997448865907,
                limb2: 39938443932041998833480171620,
                limb3: 953890011536288421792003614
            },
            y1: u384 {
                limb0: 77765733171857314981222797814,
                limb1: 12410834329291007439001914815,
                limb2: 52202458594285238567076407091,
                limb3: 5620035781686033313049862787
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 39664203513280128245686536049,
            limb1: 564398632820753792233723545,
            limb2: 42411359487062708154844565163,
            limb3: 2646406878503213571512582741
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 24586558276818696305376635650,
            limb1: 60783539434071996588672011096,
            limb2: 25577205326166463600144134163,
            limb3: 1015937372136613352007311657
        };

        let ci_plus_one: u384 = u384 {
            limb0: 71476503334112422809124074376,
            limb1: 75383419260363872372937611397,
            limb2: 866234254616268862478564427,
            limb3: 4649288912884834873570430703
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
            limb0: 22222368339769233111253769482,
            limb1: 72737879420247784850538775826,
            limb2: 75519414177429220612314792089,
            limb3: 5599452117437871736563657221
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 41236009385153176642504188187,
            limb1: 40296139494567903111598685549,
            limb2: 6606241335014948734200518286,
            limb3: 5401014187606813885865061058
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 3425244934450121347198936392,
                limb1: 40349394691619711885830123166,
                limb2: 1217900951165172199223106736,
                limb3: 6349932931151823409819370873
            },
            x1: u384 {
                limb0: 76357522719969451516389343222,
                limb1: 12821033698408033574674923655,
                limb2: 41458399409917327407783454976,
                limb3: 2306115373764953990488949591
            },
            y0: u384 {
                limb0: 63135779722614155699947829564,
                limb1: 68686859481217317876116301804,
                limb2: 42044764765910611023320536655,
                limb3: 7690945026174402264474875911
            },
            y1: u384 {
                limb0: 40195951743082424043283932795,
                limb1: 43147041168965698122548977734,
                limb2: 6534330921588034973376860403,
                limb3: 6425807609239769482905355824
            }
        };

        let Q_or_Qneg_0: G2Point = G2Point {
            x0: u384 {
                limb0: 53887056261935077327325822190,
                limb1: 49714784832411093266376388517,
                limb2: 40002191483678792956848350381,
                limb3: 1501692374994541720240395367
            },
            x1: u384 {
                limb0: 32421703544272210936624927018,
                limb1: 56618509032370988528966426715,
                limb2: 44854802142923465384568666425,
                limb3: 2595335961813463752515537606
            },
            y0: u384 {
                limb0: 17328779424590549575014652139,
                limb1: 69576337958318099900555216959,
                limb2: 51889443711157960105404508350,
                limb3: 4126593173004759074655662305
            },
            y1: u384 {
                limb0: 60452245060559468006531035324,
                limb1: 23500765096267617968652424243,
                limb2: 64044696091037221174997295013,
                limb3: 790045811799401689391535087
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 944545271016965832637976719,
            limb1: 63921470543285088090815428885,
            limb2: 62845000465640460342389503170,
            limb3: 3123909739855689038586241342
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 39322775392592645743498658770,
            limb1: 5736213525076231468611397099,
            limb2: 77976511813888319285139208948,
            limb3: 912536959289976220182767900
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 75308100839723422387010615338,
                limb1: 73211136963956218496079476753,
                limb2: 72999726272448852648553484600,
                limb3: 5172222022696443485905829880
            },
            x1: u384 {
                limb0: 59492623125974925376622866414,
                limb1: 7065359286340865148847664913,
                limb2: 41207889459834097840105019692,
                limb3: 7583510831167839527543693871
            },
            y0: u384 {
                limb0: 29091702482955329283963377560,
                limb1: 6195056429287215190904002529,
                limb2: 55461154019181035404980961777,
                limb3: 904880666498715763237128960
            },
            y1: u384 {
                limb0: 54272875692620994024851349266,
                limb1: 75795715588480541052484309118,
                limb2: 52866335169327230635087721760,
                limb3: 2224417088522676061704198267
            }
        };

        let Q_or_Qneg_1: G2Point = G2Point {
            x0: u384 {
                limb0: 19574238087081342615729555148,
                limb1: 46955855013209797151137220712,
                limb2: 65955250659296359791294935342,
                limb3: 1292390884847013404086662726
            },
            x1: u384 {
                limb0: 59965554226064741749405338970,
                limb1: 7564716186670142443075636035,
                limb2: 74030077789451419600973455846,
                limb3: 1869387146137759095550650036
            },
            y0: u384 {
                limb0: 70491928554892922203743986233,
                limb1: 19127035528620299479479811181,
                limb2: 52866328714665752474914426147,
                limb3: 6861869186298545017787638771
            },
            y1: u384 {
                limb0: 314784573215907695383619974,
                limb1: 63572945970602583045178473163,
                limb2: 26384513421171629266183670304,
                limb3: 5030857969187719843674432563
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 33889232766829312264515266790,
            limb1: 22565136794384650398515808424,
            limb2: 63482595604974732827428971705,
            limb3: 3594417390722076478971396429
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 36897892631970377403110358158,
            limb1: 4900553017445041340013885140,
            limb2: 28650122136089108911397582526,
            limb3: 5018937367964459040482364691
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 66387404691204017484684343513,
                limb1: 62866067032418315420231261043,
                limb2: 72218974064218924063775571463,
                limb3: 7769214010905023409581959004
            },
            x1: u384 {
                limb0: 51987039942371625731775087020,
                limb1: 44026395121422750438531913292,
                limb2: 20742383525337162094774411582,
                limb3: 2673790380884808577320440239
            },
            y0: u384 {
                limb0: 25634767373303041844023359587,
                limb1: 56926217487266557723228483770,
                limb2: 19930776322631279967495924603,
                limb3: 2701369796952726957786320646
            },
            y1: u384 {
                limb0: 12657960983908636371810992592,
                limb1: 31610763292802856118653796557,
                limb2: 26987259123785944398983281460,
                limb3: 5753266089453940980915129306
            }
        };

        let Q_or_Qneg_2: G2Point = G2Point {
            x0: u384 {
                limb0: 77784731718999483134801831650,
                limb1: 44242428148054349918075655641,
                limb2: 41725271247645340316986602286,
                limb3: 3269642142406229454182649933
            },
            x1: u384 {
                limb0: 65864497591473779191328470860,
                limb1: 18657057544986997132644891743,
                limb2: 38465666525326841529656112381,
                limb3: 381853809686478033091927674
            },
            y0: u384 {
                limb0: 43122324409668727294076306741,
                limb1: 69637583703440584530927457965,
                limb2: 4152803678582786568876365705,
                limb3: 6201369982416714165514561618
            },
            y1: u384 {
                limb0: 23027755523849526546709167619,
                limb1: 13855034038401649193645755106,
                limb2: 11712992936188706481986534621,
                limb3: 1741891949082811508279278976
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 48684479055569648058473207843,
            limb1: 53250046722689931684741465651,
            limb2: 9337962571181874290381973158,
            limb3: 1158205893674677157269543485
        };

        let f_i_of_z: u384 = u384 {
            limb0: 54939703386604774069899100542,
            limb1: 30777230868039632818839491290,
            limb2: 10922972442288526261664987083,
            limb3: 4189573183810355776929037605
        };

        let f_i_plus_one: E12D = E12D {
            w0: u384 {
                limb0: 50349627269782334495915871725,
                limb1: 72823436474828015026629095450,
                limb2: 79220204440018533881612321772,
                limb3: 1652556097531898569439124904
            },
            w1: u384 {
                limb0: 10817394603448816425422294899,
                limb1: 30419191303313185485939273920,
                limb2: 40044925395878705844497252551,
                limb3: 4051870344281321012636652669
            },
            w2: u384 {
                limb0: 32929635335435422565428381680,
                limb1: 35165558273503257271567377397,
                limb2: 6549841831681086619739973982,
                limb3: 7882022502340511080963238144
            },
            w3: u384 {
                limb0: 23141746808062260117243206486,
                limb1: 17813930939854560561551291529,
                limb2: 13326887818947426958260090859,
                limb3: 5601930805232389385296451306
            },
            w4: u384 {
                limb0: 60682398730694831193512586514,
                limb1: 40470219304583769753419307764,
                limb2: 9048383060296295987447293279,
                limb3: 5378663079168684594837085705
            },
            w5: u384 {
                limb0: 29065784223227238872988690784,
                limb1: 59958783856173609552913324740,
                limb2: 56963483234512519382096608441,
                limb3: 2164334466834356699274241650
            },
            w6: u384 {
                limb0: 8114266371865912016449433915,
                limb1: 51789207937002292067800039765,
                limb2: 23586931601811135861691526565,
                limb3: 319194416658375002234784170
            },
            w7: u384 {
                limb0: 27617113067218678882081286322,
                limb1: 6891503490724160194739772767,
                limb2: 78749441131974237024722281097,
                limb3: 8040558390994356124330558133
            },
            w8: u384 {
                limb0: 64230486427224550312304475953,
                limb1: 54598787858958950925841216591,
                limb2: 56311730050547601503338819923,
                limb3: 4240361225357053069503372811
            },
            w9: u384 {
                limb0: 11031330314441819984664315260,
                limb1: 64454476496694805543892279930,
                limb2: 4702812118905784511372079798,
                limb3: 5271453675391636671489401981
            },
            w10: u384 {
                limb0: 78078427233016903726119976440,
                limb1: 64585285632714581698908558240,
                limb2: 76278655975315784920320748840,
                limb3: 4076251521966866838713674587
            },
            w11: u384 {
                limb0: 78632860055743473892449348922,
                limb1: 51965457040342003631219715284,
                limb2: 68617831712584199644494151201,
                limb3: 1448324920244096959337989933
            }
        };

        let c_or_cinv_of_z: u384 = u384 {
            limb0: 65639091059276963372207044870,
            limb1: 66833364416817988916805091151,
            limb2: 38778915939145231047447131447,
            limb3: 6263005870926989311632301113
        };

        let z: u384 = u384 {
            limb0: 17258265093731386856714537661,
            limb1: 65351163433072870104958977629,
            limb2: 570367500290352587,
            limb3: 0
        };

        let ci: u384 = u384 {
            limb0: 65628142806002927419227296902,
            limb1: 43362407805342841415090671199,
            limb2: 44854398798266634948658296214,
            limb3: 7806981284959493764649868725
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
                limb0: 4793362398236211343609671508,
                limb1: 27616415895049857331363612680,
                limb2: 26531320624240762781685172276,
                limb3: 4181756139738215625403326154
            },
            x1: u384 {
                limb0: 67330928263179597566218466822,
                limb1: 14716413202856097275071273022,
                limb2: 32989160629918150293895629688,
                limb3: 1289658311481651328006316874
            },
            y0: u384 {
                limb0: 49738601878090503316969407002,
                limb1: 41619814159420901159070746007,
                limb2: 48671836788242979712490527105,
                limb3: 1753136604271195070544760283
            },
            y1: u384 {
                limb0: 78496615294460762331981569568,
                limb1: 50880047141304755549276758028,
                limb2: 64560868503313215226185200392,
                limb3: 1658879241655518919072325797
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 20774847906915587829128382550,
                limb1: 75415962092408907324728722996,
                limb2: 65059974079802925027670735982,
                limb3: 7458122372748676678738296949
            },
            x1: u384 {
                limb0: 69437569892018745096950346975,
                limb1: 68535925014207106817378050927,
                limb2: 54109084031805384213618762847,
                limb3: 7492090567654974721747030086
            },
            y0: u384 {
                limb0: 55773596817855138666899663420,
                limb1: 35312783841757123966279533260,
                limb2: 69370679127326858155562881762,
                limb3: 1710616851486199984355664438
            },
            y1: u384 {
                limb0: 75324181127147770263452712946,
                limb1: 57818843727788834181968321011,
                limb2: 45850805998112167200559185361,
                limb3: 1064491833595546223565026686
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 41702635719264465040612239800,
                limb1: 75496208352774504406861451922,
                limb2: 16400962404330467028748232202,
                limb3: 3639986043356610703749627324
            },
            x1: u384 {
                limb0: 56796683931551161567936696754,
                limb1: 15874537100503313908465017842,
                limb2: 17308137961907295738134273322,
                limb3: 3828345610103407121351476472
            },
            y0: u384 {
                limb0: 75321137176206932520665930900,
                limb1: 28092835788239901040402401259,
                limb2: 60877568004158492952099586154,
                limb3: 1281827495110393735473954189
            },
            y1: u384 {
                limb0: 51543237734322375333251196601,
                limb1: 44405820849839988140259984890,
                limb2: 65358905401284131210836026842,
                limb3: 7444611253469106966980669000
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 49712690724083670303600575712,
            limb1: 19855481235697054093969975126,
            limb2: 39297748198136886767491252695,
            limb3: 5180855241183710350912722540
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 34456614306648980544587077198,
            limb1: 69657581012423265774441733897,
            limb2: 21757463931858354424444224544,
            limb3: 7100179521672530549735016957
        };

        let ci_plus_one: u384 = u384 {
            limb0: 4548689953589544323510884788,
            limb1: 43242418490629956850888473039,
            limb2: 656789188659739766785384320,
            limb3: 4273568767754072077730817471
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(Q2_result, Q2);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
        assert_eq!(lhs_i_plus_one_result, lhs_i_plus_one);
        assert_eq!(ci_plus_one_result, ci_plus_one);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_INIT_BIT_2_circuit_BLS12_381() {
        let yInv_0: u384 = u384 {
            limb0: 6460629157439893653787266297,
            limb1: 16836283155626114375621433877,
            limb2: 52588150897570688560263934028,
            limb3: 5885416803749989099686589107
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 12865950502190514886539114203,
            limb1: 45576015996862525815270880463,
            limb2: 26188178655650430208489175660,
            limb3: 480166479856229197628455804
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 62998802530722181734810769956,
                limb1: 54574347199856952811695782748,
                limb2: 75155844231108013093266329892,
                limb3: 5725165070450647740408488900
            },
            x1: u384 {
                limb0: 35456541085200873061850341815,
                limb1: 49175737776321509357311919799,
                limb2: 21879276630269704627496613811,
                limb3: 4393954941793918486447512445
            },
            y0: u384 {
                limb0: 50525231485634844672457275254,
                limb1: 12082504268129181917920261250,
                limb2: 75776881538346185543696953659,
                limb3: 2477016534486503747700818530
            },
            y1: u384 {
                limb0: 51705718302348977530904627914,
                limb1: 62681392144798003746207303560,
                limb2: 54201867013362808322811371392,
                limb3: 4736516155157237641519540127
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 41397623749234856272010696687,
            limb1: 44001507926170019610116206384,
            limb2: 41885067728230072417785869822,
            limb3: 3666929413181268040765588745
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 11318701894375976503465620849,
            limb1: 55938788021859020569064561603,
            limb2: 3627829484036500558950616475,
            limb3: 5035559071906807587350314271
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 50431104481534431931420751153,
                limb1: 20513510736153811194788891156,
                limb2: 63422135925358253771288630954,
                limb3: 6610879764957320135676384012
            },
            x1: u384 {
                limb0: 34325329172240293031092376395,
                limb1: 49738451512182967644456414319,
                limb2: 23038041118582304133197681749,
                limb3: 3612059967693557280275673147
            },
            y0: u384 {
                limb0: 44391489384795570241782159913,
                limb1: 60109230409391966953637044226,
                limb2: 67689951321580282513620430447,
                limb3: 725122538251580966297162380
            },
            y1: u384 {
                limb0: 6705596560221559588481202622,
                limb1: 75763365176212751034576329145,
                limb2: 29250087275566558132978077503,
                limb3: 7920450467192393290064329215
            }
        };

        let R_i: E12D = E12D {
            w0: u384 {
                limb0: 70229012952542046329949241309,
                limb1: 71297219685715119096982992657,
                limb2: 63945671929214981537085514812,
                limb3: 5188000880449088889750566666
            },
            w1: u384 {
                limb0: 56436061813994442625050602024,
                limb1: 49718273343760273572886276700,
                limb2: 36064483545798951563647704209,
                limb3: 549042348658858274679069168
            },
            w2: u384 {
                limb0: 44913346415415193260941275379,
                limb1: 12463380603984557499685059891,
                limb2: 8152966891038729248051251604,
                limb3: 6676165400853797752563222140
            },
            w3: u384 {
                limb0: 18096062505878242703387918579,
                limb1: 203498347241549738566467938,
                limb2: 68368239133153753602248282483,
                limb3: 455378985045918642455531453
            },
            w4: u384 {
                limb0: 30342759941037994388194955379,
                limb1: 14178745655674493063562262412,
                limb2: 67936976597592666962873319852,
                limb3: 7953670477608813919732602453
            },
            w5: u384 {
                limb0: 58681592574590638774032038256,
                limb1: 17787935975239186632826170304,
                limb2: 32979245100565703294504246764,
                limb3: 3168484127393396634401731885
            },
            w6: u384 {
                limb0: 6170849151853539503012653401,
                limb1: 9459916376982993164991213145,
                limb2: 71459129173163831485366911303,
                limb3: 2210317728927929159537912836
            },
            w7: u384 {
                limb0: 77755617143852009941738526899,
                limb1: 31764539320310237713412520421,
                limb2: 36848556728080127032713095604,
                limb3: 7660645068258413493714438620
            },
            w8: u384 {
                limb0: 25931451033492414976385080403,
                limb1: 36187160353237884000276405383,
                limb2: 15898807053542266727563936919,
                limb3: 7769383187976185666158852563
            },
            w9: u384 {
                limb0: 49336765146084121130048487433,
                limb1: 29177642521004522530456337437,
                limb2: 39088059805565237823362633348,
                limb3: 7684002363095845199059810797
            },
            w10: u384 {
                limb0: 71340467633755259940219860030,
                limb1: 63063521205150311407306886776,
                limb2: 505307660245121265920156293,
                limb3: 236795733043188210586458834
            },
            w11: u384 {
                limb0: 27446513174394839845547916662,
                limb1: 54941625103216522139181847952,
                limb2: 75345211080808886447157286582,
                limb3: 7516070292820032529547637467
            }
        };

        let c0: u384 = u384 {
            limb0: 67265183983479375960272605345,
            limb1: 24363503251417312230150175803,
            limb2: 41976227902008152972947384106,
            limb3: 4157654687621112832935688511
        };

        let z: u384 = u384 {
            limb0: 4745376637116532048405043903,
            limb1: 11279989295633601330432025693,
            limb2: 7370329896385946009027402569,
            limb3: 2292393283743136608077810742
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 41179567842552912655777309102,
            limb1: 70954994507766005171299948346,
            limb2: 77212185377988988310384255573,
            limb3: 5751673737567079236967486935
        };

        let (Q0_result, Q1_result, new_lhs_result, f_i_plus_one_of_z_result) =
            run_BLS12_381_MP_CHECK_INIT_BIT_2_circuit(
            yInv_0, xNegOverY_0, Q0, yInv_1, xNegOverY_1, Q1, R_i, c0, z, c_inv_of_z
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 6509349541973319021885580780,
                limb1: 52840623655539345132493815613,
                limb2: 28545695499567174820851070328,
                limb3: 2213241706130816510066754218
            },
            x1: u384 {
                limb0: 46711790949850547387834346518,
                limb1: 3944062382291239511722024731,
                limb2: 21883401370032114867462852632,
                limb3: 3867151304341713424692308961
            },
            y0: u384 {
                limb0: 54634180841399832605653532792,
                limb1: 12401829096390786221056201302,
                limb2: 17395379154329814657641124137,
                limb3: 843943444874904362136584369
            },
            y1: u384 {
                limb0: 60462384914780960255491322657,
                limb1: 38873675835121752184216755431,
                limb2: 27434011942664465539372472849,
                limb3: 6110988651271802857965620248
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 7010376641280773138180356398,
                limb1: 58986541910269739150484472862,
                limb2: 16612623043783494490344049951,
                limb3: 6288250823474879301840506293
            },
            x1: u384 {
                limb0: 42385825798760197451645963771,
                limb1: 48159494324333116832525552398,
                limb2: 70226839066129515472117713123,
                limb3: 5737597339183295900449901000
            },
            y0: u384 {
                limb0: 79068611689705684724710577575,
                limb1: 70729735288086956144429209612,
                limb2: 35529443909124027577874836712,
                limb3: 6055055858749107406266956754
            },
            y1: u384 {
                limb0: 50362146410184639720188107121,
                limb1: 31949230282338794922862289099,
                limb2: 16255438756934792465427247347,
                limb3: 2015194047938289598359763366
            }
        };

        let new_lhs: u384 = u384 {
            limb0: 29615968943273950610022796326,
            limb1: 12117331809153936747619410505,
            limb2: 27845358975071653051575419940,
            limb3: 7407811966674813000359304924
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 47342899131899633248733952414,
            limb1: 77957244725700327472733540378,
            limb2: 56936349133696802462572954604,
            limb3: 6463865385419294780682609554
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(new_lhs_result, new_lhs);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_INIT_BIT_3_circuit_BLS12_381() {
        let yInv_0: u384 = u384 {
            limb0: 53593674142467379180737908457,
            limb1: 71627384371775878747981922181,
            limb2: 74123467596051888207889079631,
            limb3: 7536163192858177015487701080
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 9643943799415746603492430576,
            limb1: 803911600391174266640080943,
            limb2: 77119186233351070761145078064,
            limb3: 532993669425289797954976042
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 58849940906862966037707266613,
                limb1: 11681282509460707096928773335,
                limb2: 33024738804126187678610473050,
                limb3: 4174812025645949452585183798
            },
            x1: u384 {
                limb0: 67814050726209214265319261043,
                limb1: 66103506264911876970896465646,
                limb2: 60266545518658483914303253687,
                limb3: 1958644724639559827992136638
            },
            y0: u384 {
                limb0: 50019657433945249304493849377,
                limb1: 29738522008888360830973412298,
                limb2: 24911462056383783291422238308,
                limb3: 2176289989126865258607707588
            },
            y1: u384 {
                limb0: 25054893296640226944055816062,
                limb1: 16150848082380836817640438196,
                limb2: 48259637222690644092732909097,
                limb3: 6140294836258303159536842702
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 46878311704307333727940017391,
            limb1: 55825869420351207447644548144,
            limb2: 76526208982849438746308689191,
            limb3: 6320154896148087438959496304
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 32315781219557629915553944836,
            limb1: 3251432680347489985545565450,
            limb2: 15457194510447891484227478460,
            limb3: 4391610492180462372487068716
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 69469653947361199046890080325,
                limb1: 56690254575204764020683373175,
                limb2: 57158354363205964824544363597,
                limb3: 4354145649751240062230419012
            },
            x1: u384 {
                limb0: 58090039090647344872037480909,
                limb1: 29626924167397447085911179552,
                limb2: 26819550028926826677853470400,
                limb3: 7402649661848955568363705792
            },
            y0: u384 {
                limb0: 34448642928701073248325020886,
                limb1: 35150753484566715222435225342,
                limb2: 23685907722658211048585042861,
                limb3: 1712107919390695245055548229
            },
            y1: u384 {
                limb0: 7802581777512727701190292816,
                limb1: 20328810301236348869489064598,
                limb2: 41401501745890526053841860096,
                limb3: 7200978318441934068418555990
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 44238845856914827246244464015,
            limb1: 73893949218072110676567573675,
            limb2: 46905173645811412482387117421,
            limb3: 3066983767058699521250958636
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 77855415767299328992358793324,
            limb1: 13453938873673797559060452232,
            limb2: 78545052327152558587742173527,
            limb3: 4082538029802453584340915484
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 25428021977448240974020278895,
                limb1: 27483403387812319389169638679,
                limb2: 57407068297911227078333644933,
                limb3: 7095117253944123702215311106
            },
            x1: u384 {
                limb0: 70182746428640213483898692644,
                limb1: 12465774585076893133817019546,
                limb2: 18986298083901134911299421445,
                limb3: 2135732519991589863389040591
            },
            y0: u384 {
                limb0: 37192117657959109628754085932,
                limb1: 26260300386518923801838722935,
                limb2: 74758343103432220743114548502,
                limb3: 6303654824456925578387291421
            },
            y1: u384 {
                limb0: 75580022939567166777745506238,
                limb1: 47889606758522819407717944681,
                limb2: 33869976201975873931293774613,
                limb3: 2557427252982309238548943663
            }
        };

        let R_i: E12D = E12D {
            w0: u384 {
                limb0: 12487576602775560534464047032,
                limb1: 24102394126193724039842671530,
                limb2: 55212361986753379753842840548,
                limb3: 2129462714056186800951658556
            },
            w1: u384 {
                limb0: 25970489666684303139460295199,
                limb1: 56343694296223144500226722932,
                limb2: 28184845202177046412746507315,
                limb3: 484783432101286176271386346
            },
            w2: u384 {
                limb0: 20612536972458063115342046152,
                limb1: 13775221539701546847311062149,
                limb2: 32039252900045594826814848741,
                limb3: 5505899324439727097210414774
            },
            w3: u384 {
                limb0: 19795365140987450728068026812,
                limb1: 8073931736525736613278378608,
                limb2: 11075546130246055428734332266,
                limb3: 610741978796386840233873299
            },
            w4: u384 {
                limb0: 46136444466817891745772737500,
                limb1: 72686180276243672851712565492,
                limb2: 1727188110319692485953073546,
                limb3: 1958424448109865035551340706
            },
            w5: u384 {
                limb0: 35132248873471981342092295078,
                limb1: 7287298147045047071711048342,
                limb2: 65708365565830840072623304837,
                limb3: 1213455202377015721836362597
            },
            w6: u384 {
                limb0: 36523780807472091795098051927,
                limb1: 73217258605355828739577386917,
                limb2: 65100624108560156800943002404,
                limb3: 4913397854283672596631538910
            },
            w7: u384 {
                limb0: 54129704087490407134841808590,
                limb1: 28042273881223598845722221173,
                limb2: 14827638890735592385807884908,
                limb3: 4417083240682326848369407127
            },
            w8: u384 {
                limb0: 4831259540434697355093733033,
                limb1: 30345597030276561573393001317,
                limb2: 15802675205037707343759009358,
                limb3: 7895066044804013403580719157
            },
            w9: u384 {
                limb0: 49973510992671755962144243727,
                limb1: 43072919757193834573781041385,
                limb2: 78388630236328812714301000506,
                limb3: 7064880895855910876569363686
            },
            w10: u384 {
                limb0: 43141145034201676152459674992,
                limb1: 27257190955396926390609387925,
                limb2: 39803694778051184316364698472,
                limb3: 2678265347053110190188833491
            },
            w11: u384 {
                limb0: 25264083946379914286041950657,
                limb1: 2321659122495493467860147723,
                limb2: 61682157897638694436067137334,
                limb3: 8008520109553564515813766157
            }
        };

        let c0: u384 = u384 {
            limb0: 41945947705654240419610165025,
            limb1: 46268368657052778213874383057,
            limb2: 77166635068492095796946545044,
            limb3: 2454657359615527266897701885
        };

        let z: u384 = u384 {
            limb0: 67067042546888105348083440518,
            limb1: 30774002766899916360364583108,
            limb2: 66490036958183581980420241903,
            limb3: 1720360652504923510232428792
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 46944232336346389212696996340,
            limb1: 58478710691729301556758625266,
            limb2: 72412955996198512824013006722,
            limb3: 6966659883413134360961917915
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
                limb0: 32876157570006717947796897608,
                limb1: 9177201625353257273253415677,
                limb2: 13987229720097292724938578008,
                limb3: 382441326091451219673243482
            },
            x1: u384 {
                limb0: 8219419082578853724512708319,
                limb1: 3776511426232150743423038963,
                limb2: 4377003814112514378034913872,
                limb3: 4724681614459064632983938265
            },
            y0: u384 {
                limb0: 57292173769516579075511783282,
                limb1: 55783641076114923935995674237,
                limb2: 32196651657410883380095225384,
                limb3: 4157598637131955802591728934
            },
            y1: u384 {
                limb0: 16532907720748680279003148024,
                limb1: 52908451792423195605966749359,
                limb2: 23606948445211894168545374464,
                limb3: 5281639388058509163182787386
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 9380224770850688843357496753,
                limb1: 40867914400341396977759417027,
                limb2: 4523291715681139028623568363,
                limb3: 650022809543274904767750071
            },
            x1: u384 {
                limb0: 70670087391482791391967843255,
                limb1: 78662380377313027227247295995,
                limb2: 30182803489440667309217408722,
                limb3: 7313294123846485110617368004
            },
            y0: u384 {
                limb0: 32118519912470175526332076244,
                limb1: 21338819397731485599405390651,
                limb2: 20583392989255407779118059222,
                limb3: 7801006706539584891053235062
            },
            y1: u384 {
                limb0: 23093406392630335669397360129,
                limb1: 57863676950332242739531621919,
                limb2: 26758141283587018797687193650,
                limb3: 4963275170911033123337058788
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 21333970905706681671756028185,
                limb1: 59973203012851340782487772172,
                limb2: 56202541329119639010229065687,
                limb3: 846675227442430543868382340
            },
            x1: u384 {
                limb0: 27266474084790157023974477926,
                limb1: 20714162789467953047998895174,
                limb2: 15618493708919906925691423009,
                limb3: 6289751341468151094856512815
            },
            y0: u384 {
                limb0: 24644652553704226980037776212,
                limb1: 67366027910496365042689545134,
                limb2: 42856015826017267320174407238,
                limb3: 469222041263318620724501445
            },
            y1: u384 {
                limb0: 47706779644214706169360699710,
                limb1: 124429260623062425896258497,
                limb2: 12597021939816927078397485276,
                limb3: 2570466910011869798305209625
            }
        };

        let new_lhs: u384 = u384 {
            limb0: 46050953449120253603189378144,
            limb1: 69161707823390977260773822035,
            limb2: 40059980341999232817997536663,
            limb3: 2598477729556090904399123281
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 57264652886715671885471776048,
            limb1: 72057364163286660706682611125,
            limb2: 69717386679623881850293344234,
            limb3: 1492211190547922872832877527
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
                limb0: 69799139374407600818221469035,
                limb1: 30322285563564598523493875548,
                limb2: 59671308652660284027597586827,
                limb3: 6353862367634231394654162437
            },
            w1: u384 {
                limb0: 11317986096091134960168162170,
                limb1: 44628527979874603465470864463,
                limb2: 51499907036898051469477635715,
                limb3: 3477994717680206388369001172
            },
            w2: u384 {
                limb0: 49761627243910020748324982332,
                limb1: 72881521037612513657669716986,
                limb2: 54395376350447233558208958929,
                limb3: 2151487145475570906848825761
            },
            w3: u384 {
                limb0: 7959666708791103085138227142,
                limb1: 9757520214884418904380663457,
                limb2: 30426142532970461454712852709,
                limb3: 4252460174190082588550249811
            },
            w4: u384 {
                limb0: 11078488847043997400530374639,
                limb1: 51072103608314502015173455261,
                limb2: 43844598278185882106519966450,
                limb3: 7142217206822362965377487618
            },
            w5: u384 {
                limb0: 61716333949324409191743043758,
                limb1: 2125248106197027834555772194,
                limb2: 52164247307572657279787300073,
                limb3: 2034635847459971715741136380
            },
            w6: u384 {
                limb0: 40368537015381881859003331824,
                limb1: 31037713268746269798580298608,
                limb2: 4323411861624973628260525258,
                limb3: 7861196863698595539927382187
            },
            w7: u384 {
                limb0: 78188889610784037067589048559,
                limb1: 25073546934847101430326685335,
                limb2: 68200711753070549068619030877,
                limb3: 4168030562978811738084275292
            },
            w8: u384 {
                limb0: 54108243664962268894251953111,
                limb1: 37317623172162993321833835740,
                limb2: 61034766004983317620680230854,
                limb3: 5816966337445803453144078308
            },
            w9: u384 {
                limb0: 20772457897447145237635518614,
                limb1: 73094262188315325375645937144,
                limb2: 62533996167472229946169680642,
                limb3: 2837237711007574476279886069
            },
            w10: u384 {
                limb0: 39697188759163840139602035281,
                limb1: 33559087420842719080874070580,
                limb2: 6530604150897154877595180202,
                limb3: 5324680762718616158601887849
            },
            w11: u384 {
                limb0: 21983259310774226131094946435,
                limb1: 6260732950421099314279783990,
                limb2: 16098963700104429390545608010,
                limb3: 1538780587698469338195204618
            }
        };

        let z: u384 = u384 {
            limb0: 30956938934729670351901482454,
            limb1: 60468845309902212942010564326,
            limb2: 53958790433782269349602756313,
            limb3: 3071769846842682669577652022
        };

        let (c_inv_of_z_result) = run_BLS12_381_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit(
            lambda_root_inverse, z
        );
        let c_inv_of_z: u384 = u384 {
            limb0: 32827375856062066595937969774,
            limb1: 72915569075600771617312849088,
            limb2: 61809971586199655830106843293,
            limb3: 4204795883475715100728744276
        };
        assert_eq!(c_inv_of_z_result, c_inv_of_z);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_PREPARE_PAIRS_2_circuit_BLS12_381() {
        let p_0: G1Point = G1Point {
            x: u384 {
                limb0: 55652205759803741181601491042,
                limb1: 58192054821810126220762283040,
                limb2: 30761316527513200096210847471,
                limb3: 5828173793907172375805770723
            },
            y: u384 {
                limb0: 77808929346133449801804103422,
                limb1: 519491450420654311285698494,
                limb2: 5034946156281871971745395585,
                limb3: 691453059012538886059078669
            }
        };

        let p_1: G1Point = G1Point {
            x: u384 {
                limb0: 6608945911687227908327548670,
                limb1: 34661844934287171719463459881,
                limb2: 31420310110857994050003160365,
                limb3: 6405561152992977734489205879
            },
            y: u384 {
                limb0: 41350536291719357989190549375,
                limb1: 75171472354683752798119548346,
                limb2: 13984158160056253609420128006,
                limb3: 1246393885605790442360233377
            }
        };

        let (p_0_result, p_1_result) = run_BLS12_381_MP_CHECK_PREPARE_PAIRS_2_circuit(p_0, p_1);
        let p_0: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 29767560002978892185072408597,
                limb1: 35835423858940955981096839168,
                limb2: 55441558332409800789737443484,
                limb3: 6493620498306019467709489015
            },
            xNegOverY: u384 {
                limb0: 63617633302213931978686511920,
                limb1: 65208971590759222397074233552,
                limb2: 38207017897225400108448392998,
                limb3: 2852950793331306264643831592
            }
        };

        let p_1: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 15898178790600614456129403785,
                limb1: 57410682121552144058475283618,
                limb2: 78806011907027855689048721488,
                limb3: 521590275369856818445779042
            },
            xNegOverY: u384 {
                limb0: 30768145589799957515654922567,
                limb1: 1465147258454298056245972667,
                limb2: 29988236108847991626500448940,
                limb3: 1829169664293024406172452966
            }
        };
        assert_eq!(p_0_result, p_0);
        assert_eq!(p_1_result, p_1);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_PREPARE_PAIRS_3_circuit_BLS12_381() {
        let p_0: G1Point = G1Point {
            x: u384 {
                limb0: 32858675599892885752425018976,
                limb1: 12235326453281084595504078541,
                limb2: 24671539073883100496086183123,
                limb3: 2997363346673785952680310033
            },
            y: u384 {
                limb0: 49753937216197863336009170337,
                limb1: 56063545790847647574786071431,
                limb2: 46230981618308443986541991576,
                limb3: 6154044297147210776916807147
            }
        };

        let p_1: G1Point = G1Point {
            x: u384 {
                limb0: 4928495948769662967833980694,
                limb1: 40158548572959521982261362491,
                limb2: 42710085837407533108057586919,
                limb3: 7454910161861744677732904342
            },
            y: u384 {
                limb0: 71764570167310333734398573977,
                limb1: 19992960555589004061389877488,
                limb2: 38441198447339123902673600170,
                limb3: 6082624040521001375250654279
            }
        };

        let p_2: G1Point = G1Point {
            x: u384 {
                limb0: 65049691944629176450652902647,
                limb1: 10015321235072699354349276084,
                limb2: 14889508674076376987917633604,
                limb3: 3406915817780793436418206122
            },
            y: u384 {
                limb0: 18392186600816465107172535233,
                limb1: 67708749945655385856049150067,
                limb2: 59671607742579534125391985644,
                limb3: 3515489750435997317383992351
            }
        };

        let (p_0_result, p_1_result, p_2_result) = run_BLS12_381_MP_CHECK_PREPARE_PAIRS_3_circuit(
            p_0, p_1, p_2
        );
        let p_0: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 64593184269009141637646523270,
                limb1: 6314012987544369685678959204,
                limb2: 39476935992418162979679793911,
                limb3: 898375816866196930043149380
            },
            xNegOverY: u384 {
                limb0: 52856229136037045267578331241,
                limb1: 29955857358448810782228147780,
                limb2: 71857346001530282229500456803,
                limb3: 74962822584395952222885916
            }
        };

        let p_1: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 24471119168151266554895272404,
                limb1: 22127095840508672765854989995,
                limb2: 36876983724669146622844616409,
                limb3: 5337079672052066324261431515
            },
            xNegOverY: u384 {
                limb0: 58222223925996860920077549030,
                limb1: 34795590568244170145305614438,
                limb2: 10313103825694098737656418807,
                limb3: 6170727317548656328370044138
            }
        };

        let p_2: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 67574934621899177515986409467,
                limb1: 26040952561276454883884013104,
                limb2: 73513649802621411883912322908,
                limb3: 540173036008152765110414153
            },
            xNegOverY: u384 {
                limb0: 20019266401079065990063490887,
                limb1: 5162894343830613390431029079,
                limb2: 15406582184240061557267339487,
                limb3: 6569175708450906775135451270
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
    fn test_run_BN254_MP_CHECK_INIT_BIT_2_circuit_BN254() {
        let yInv_0: u384 = u384 {
            limb0: 38098565055651431566677877711,
            limb1: 55868773324834851491688542197,
            limb2: 1837827759148860804,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 31110755776536374445952353711,
            limb1: 65814805611894994539328830069,
            limb2: 613487197724175677,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 18091176557444096235353059133,
                limb1: 14980389858300471996458653615,
                limb2: 2394679716929941776,
                limb3: 0
            },
            x1: u384 {
                limb0: 33119909287485862401113372968,
                limb1: 76205011730197354213355099851,
                limb2: 1921811161343760307,
                limb3: 0
            },
            y0: u384 {
                limb0: 69996099145750968751068514561,
                limb1: 22717228013385867989391153385,
                limb2: 1424279328163394203,
                limb3: 0
            },
            y1: u384 {
                limb0: 43807764530982942882707748174,
                limb1: 24899476686952530582158829909,
                limb2: 1702410267203683518,
                limb3: 0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 25819679097393190858071167027,
            limb1: 21415169043578728799749819194,
            limb2: 2190655869283397862,
            limb3: 0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 66255404060915083219290462132,
            limb1: 16917747239820990093710646623,
            limb2: 2003966913287398758,
            limb3: 0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 12649523882156054065305024117,
                limb1: 50236430242273460023147760109,
                limb2: 3163364827290261547,
                limb3: 0
            },
            x1: u384 {
                limb0: 24020172256512339369072089070,
                limb1: 42847392441592469625748661429,
                limb2: 426039352327952071,
                limb3: 0
            },
            y0: u384 {
                limb0: 12578179498138466053973449993,
                limb1: 59425813453384575011640604515,
                limb2: 454680069187465042,
                limb3: 0
            },
            y1: u384 {
                limb0: 62637258715730746842133025581,
                limb1: 50430476679567163359752771013,
                limb2: 955569327806932452,
                limb3: 0
            }
        };

        let R_i: E12D = E12D {
            w0: u384 {
                limb0: 65716654330084571604934227912,
                limb1: 2293907638690150291935286246,
                limb2: 1260237224686894967,
                limb3: 0
            },
            w1: u384 {
                limb0: 24480288611119754958680101130,
                limb1: 27810940922274926112453288455,
                limb2: 836585472381691424,
                limb3: 0
            },
            w2: u384 {
                limb0: 44868579769900272229951689357,
                limb1: 5513125318973295878526713063,
                limb2: 3417116658942207396,
                limb3: 0
            },
            w3: u384 {
                limb0: 2428905794755188800334827396,
                limb1: 42029168573291594130225196670,
                limb2: 1734890476081967825,
                limb3: 0
            },
            w4: u384 {
                limb0: 27008562565359017668122387552,
                limb1: 24690455900888691458525886818,
                limb2: 1495952028717450088,
                limb3: 0
            },
            w5: u384 {
                limb0: 44969394469166686028024427248,
                limb1: 69985578231917462188613312284,
                limb2: 717485681570989472,
                limb3: 0
            },
            w6: u384 {
                limb0: 48950184091056392163319088082,
                limb1: 6463554465505433407553616899,
                limb2: 2043497895317506089,
                limb3: 0
            },
            w7: u384 {
                limb0: 38478084703374874537639596153,
                limb1: 32815016693131147500705109325,
                limb2: 994136384458343213,
                limb3: 0
            },
            w8: u384 {
                limb0: 9017551945901160541165188134,
                limb1: 8785592936750571612133998470,
                limb2: 3127727965077690172,
                limb3: 0
            },
            w9: u384 {
                limb0: 38555018789562111634395186800,
                limb1: 24435501704085413701917943635,
                limb2: 1016961802491164904,
                limb3: 0
            },
            w10: u384 {
                limb0: 10872861035061796836021071381,
                limb1: 22932364180853739960192207983,
                limb2: 553330142915580834,
                limb3: 0
            },
            w11: u384 {
                limb0: 59184556126505658868915934798,
                limb1: 10235146068813342402762729530,
                limb2: 2456102566251284071,
                limb3: 0
            }
        };

        let c0: u384 = u384 {
            limb0: 39634866370069687440400174302,
            limb1: 52928229229714358210403009006,
            limb2: 1633307806216168118,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 68276007046030082301855238691,
            limb1: 34560877345361549460034186149,
            limb2: 2120242238185029342,
            limb3: 0
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 68303392430757510286924664108,
            limb1: 34011405204049429992602648006,
            limb2: 1865071348679332442,
            limb3: 0
        };

        let previous_lhs: u384 = u384 {
            limb0: 63487281348680149131386421756,
            limb1: 36452631875620878995636541936,
            limb2: 3180264978061960806,
            limb3: 0
        };

        let (Q0_result, Q1_result, new_lhs_result, c_i_result, f_i_plus_one_of_z_result) =
            run_BN254_MP_CHECK_INIT_BIT_2_circuit(
            yInv_0, xNegOverY_0, Q0, yInv_1, xNegOverY_1, Q1, R_i, c0, z, c_inv_of_z, previous_lhs
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 55109813484808087497347360446,
                limb1: 15484325292420965714874729821,
                limb2: 1380949737503716310,
                limb3: 0
            },
            x1: u384 {
                limb0: 39598795813336910213833980526,
                limb1: 16756728553829878108276024947,
                limb2: 2884297434843711028,
                limb3: 0
            },
            y0: u384 {
                limb0: 59821539678661820288990945658,
                limb1: 76221865283454969347371675406,
                limb2: 1213895883323834353,
                limb3: 0
            },
            y1: u384 {
                limb0: 13606497865235275786121385727,
                limb1: 15888914092443121323005845803,
                limb2: 2337056179781783418,
                limb3: 0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 41989444787569528405512713793,
                limb1: 63772210356305864412892011207,
                limb2: 2348173644041852155,
                limb3: 0
            },
            x1: u384 {
                limb0: 30336777363247147368705409323,
                limb1: 68067486518407539058278110661,
                limb2: 3178460036912682292,
                limb3: 0
            },
            y0: u384 {
                limb0: 56952175541102510496645453279,
                limb1: 60848219280846295178747517119,
                limb2: 3030887514255038655,
                limb3: 0
            },
            y1: u384 {
                limb0: 36392227509231624893848019734,
                limb1: 46318158588783578324931863424,
                limb2: 2472593700758297611,
                limb3: 0
            }
        };

        let new_lhs: u384 = u384 {
            limb0: 19860844647259179204085583266,
            limb1: 35016606140463947456636726544,
            limb2: 2252328168100836500,
            limb3: 0
        };

        let c_i: u384 = u384 {
            limb0: 75192644710550693281743542625,
            limb1: 63930671319761159401476466643,
            limb2: 612036387883530465,
            limb3: 0
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 67485146762919894199127230797,
            limb1: 65304702371862382702343861549,
            limb2: 3051169659845773961,
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
            limb0: 30791475933910060781001787399,
            limb1: 9126507715352179359753140125,
            limb2: 2170303529127563555,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 57883630688267580239061444716,
            limb1: 75301732834638153947585388757,
            limb2: 825352555173380861,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 25951306507879521320877502816,
                limb1: 29745021044444933015273947389,
                limb2: 2148796802407048946,
                limb3: 0
            },
            x1: u384 {
                limb0: 30288153227975396709955188389,
                limb1: 57103488771460713432051640601,
                limb2: 1251557892496336613,
                limb3: 0
            },
            y0: u384 {
                limb0: 34718681813764211092303514624,
                limb1: 6507620172197847116994697600,
                limb2: 1971138770957297281,
                limb3: 0
            },
            y1: u384 {
                limb0: 69365454518955920905826431540,
                limb1: 51900895191345928674533300732,
                limb2: 1057946402413758081,
                limb3: 0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 37672851592774030148869273004,
            limb1: 71935827224714955561352060254,
            limb2: 3389296691002492678,
            limb3: 0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 18680576664330477849782273913,
            limb1: 8723141619939179723016351595,
            limb2: 1655808370928533012,
            limb3: 0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 13342275292562822775758947283,
                limb1: 64862222983441654266282440827,
                limb2: 2356776080160517076,
                limb3: 0
            },
            x1: u384 {
                limb0: 20829316054411905908033945257,
                limb1: 2081657909911250975745616466,
                limb2: 801634510976122910,
                limb3: 0
            },
            y0: u384 {
                limb0: 61858276873398551878921847167,
                limb1: 7257582486609231305464649366,
                limb2: 162918781114287084,
                limb3: 0
            },
            y1: u384 {
                limb0: 65240279692599597027411636114,
                limb1: 29786816964011954360791641114,
                limb2: 2284891422955438439,
                limb3: 0
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 18157777877753877463358477750,
            limb1: 31730353077924450002818580875,
            limb2: 371524426885529700,
            limb3: 0
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 46104811284735931330434759149,
            limb1: 61365809087311696336380585154,
            limb2: 1025525729305091053,
            limb3: 0
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 65471886996833522658680749332,
                limb1: 50412575439168682574570546684,
                limb2: 2658406105332083850,
                limb3: 0
            },
            x1: u384 {
                limb0: 50177287815733744024478149619,
                limb1: 48553986937419828752920691123,
                limb2: 2674433392279645098,
                limb3: 0
            },
            y0: u384 {
                limb0: 77680301811513563332322536576,
                limb1: 30667823430464232135932408432,
                limb2: 1495242881751850903,
                limb3: 0
            },
            y1: u384 {
                limb0: 36521205195362148300346931277,
                limb1: 32382226904365536063675955629,
                limb2: 1407036234955634527,
                limb3: 0
            }
        };

        let R_i: E12D = E12D {
            w0: u384 {
                limb0: 11960077331883547802333172192,
                limb1: 37151755976493637729095273435,
                limb2: 2911749926053776426,
                limb3: 0
            },
            w1: u384 {
                limb0: 21761889760686717831139926994,
                limb1: 27883735366272412575550884096,
                limb2: 342144033350538377,
                limb3: 0
            },
            w2: u384 {
                limb0: 35804305335639652922530653064,
                limb1: 29214402336535882897205272822,
                limb2: 1323909151279682058,
                limb3: 0
            },
            w3: u384 {
                limb0: 68472942129145091168147907730,
                limb1: 7154026208344983842789315304,
                limb2: 2739709591505940612,
                limb3: 0
            },
            w4: u384 {
                limb0: 36659794451962375190550098514,
                limb1: 75602006149071999957147350978,
                limb2: 3407671835376259643,
                limb3: 0
            },
            w5: u384 {
                limb0: 35631574628058545152503328278,
                limb1: 45291308911164205836461899643,
                limb2: 868101318107910616,
                limb3: 0
            },
            w6: u384 {
                limb0: 37683213711367430600081249279,
                limb1: 75878582990126893923558857619,
                limb2: 2077671149597553790,
                limb3: 0
            },
            w7: u384 {
                limb0: 71236166552923914896542734683,
                limb1: 77832604571724359931940198877,
                limb2: 388899464835588695,
                limb3: 0
            },
            w8: u384 {
                limb0: 32386047933525779174386284223,
                limb1: 53787818865071521340915405568,
                limb2: 241493313403685979,
                limb3: 0
            },
            w9: u384 {
                limb0: 51284813869307326018676770476,
                limb1: 26120793132515949475084866669,
                limb2: 2573151152668510883,
                limb3: 0
            },
            w10: u384 {
                limb0: 69188343332762451578483774268,
                limb1: 6457252387363983399172627918,
                limb2: 3060370677160635067,
                limb3: 0
            },
            w11: u384 {
                limb0: 27715658260901228010582353528,
                limb1: 51978009774839646770852223176,
                limb2: 3053559460821701933,
                limb3: 0
            }
        };

        let c0: u384 = u384 {
            limb0: 47144022747530892273128004548,
            limb1: 6712131780807089477576435038,
            limb2: 2577573093006426671,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 62721922625347861428420087324,
            limb1: 10124864822119198723182889495,
            limb2: 3241235298013462423,
            limb3: 0
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 58531759711808383649221879720,
            limb1: 72291577403896224041541182895,
            limb2: 430975742503925451,
            limb3: 0
        };

        let previous_lhs: u384 = u384 {
            limb0: 33545708500132510870861373929,
            limb1: 1444372227779776890998115634,
            limb2: 1424393362308543337,
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
                limb0: 60575570025539261024112170538,
                limb1: 45753723113003638900689794135,
                limb2: 2866692485250494844,
                limb3: 0
            },
            x1: u384 {
                limb0: 71927294757475245172316731673,
                limb1: 76817636919172710195278466774,
                limb2: 2796106163705573723,
                limb3: 0
            },
            y0: u384 {
                limb0: 11471035416029676865633462071,
                limb1: 64926202353272169149965792226,
                limb2: 1928362639820122339,
                limb3: 0
            },
            y1: u384 {
                limb0: 38130905197409377773354736154,
                limb1: 7814302617485406571599752705,
                limb2: 385147009899316917,
                limb3: 0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 63986959410464792646206643750,
                limb1: 20950481598090949383624255249,
                limb2: 887881222939859910,
                limb3: 0
            },
            x1: u384 {
                limb0: 44067404814066542590030886806,
                limb1: 1463910005570762506910269583,
                limb2: 2821432584090828224,
                limb3: 0
            },
            y0: u384 {
                limb0: 32910740142797732347610549955,
                limb1: 3569022975307779830191625253,
                limb2: 2764307930837747592,
                limb3: 0
            },
            y1: u384 {
                limb0: 38326626501238100854377900815,
                limb1: 36157217755016591022794844550,
                limb2: 1935296517351514593,
                limb3: 0
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 8021212465732113494369803562,
                limb1: 70136889437236718080816518174,
                limb2: 2002550475099939002,
                limb3: 0
            },
            x1: u384 {
                limb0: 69489367787820550453498419907,
                limb1: 61554107759879609178246420611,
                limb2: 1946529345997877338,
                limb3: 0
            },
            y0: u384 {
                limb0: 46343322713958763672534949294,
                limb1: 38293065643566534515870805817,
                limb2: 320867285801421563,
                limb3: 0
            },
            y1: u384 {
                limb0: 52978636618951535628868322764,
                limb1: 9148047351763379729161264450,
                limb2: 1330001217171691625,
                limb3: 0
            }
        };

        let new_lhs: u384 = u384 {
            limb0: 27851545724138894970866521837,
            limb1: 7066817154602500790779362039,
            limb2: 1536859225214739340,
            limb3: 0
        };

        let c_i: u384 = u384 {
            limb0: 16918318419551547904417524777,
            limb1: 38293176686681264112855168200,
            limb2: 2063428934699657273,
            limb3: 0
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 19620595671655212662599637956,
            limb1: 45522137745679267670485971549,
            limb2: 2921738791633274128,
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

        let c_inv: E12D = E12D {
            w0: u384 {
                limb0: 4151478183251406727761585710,
                limb1: 33351931671505497125534515053,
                limb2: 524114904340073100,
                limb3: 0
            },
            w1: u384 {
                limb0: 37732092629447400187236707193,
                limb1: 28683682660648908599479904790,
                limb2: 2737801276969684999,
                limb3: 0
            },
            w2: u384 {
                limb0: 39918213878711579092428977836,
                limb1: 48733784934022290576311286791,
                limb2: 3353816348178905230,
                limb3: 0
            },
            w3: u384 {
                limb0: 68689304087490863220555616357,
                limb1: 23897616927875537737037504310,
                limb2: 2966885224459421254,
                limb3: 0
            },
            w4: u384 {
                limb0: 4819084699530860024356825995,
                limb1: 67129906945978494766775755198,
                limb2: 1965840089683616625,
                limb3: 0
            },
            w5: u384 {
                limb0: 48194287442401190975179239260,
                limb1: 9997927726397883000550929599,
                limb2: 2879156264634905294,
                limb3: 0
            },
            w6: u384 {
                limb0: 43445272631878126506295251193,
                limb1: 30178355159993152693592892746,
                limb2: 2754983660777106602,
                limb3: 0
            },
            w7: u384 {
                limb0: 67565201436882084061382168800,
                limb1: 69539050526138233778943509686,
                limb2: 2542584972831276507,
                limb3: 0
            },
            w8: u384 {
                limb0: 17035882260747629317826606829,
                limb1: 70361819709461090037174702146,
                limb2: 1908378266947718676,
                limb3: 0
            },
            w9: u384 {
                limb0: 35929884725506956604622518500,
                limb1: 57805858740019930776271531625,
                limb2: 1441374862984055727,
                limb3: 0
            },
            w10: u384 {
                limb0: 52695274180530494441361795060,
                limb1: 75551383096477959168832075052,
                limb2: 3167402939661899820,
                limb3: 0
            },
            w11: u384 {
                limb0: 5318848934111001807298281301,
                limb1: 6763261652414254970859848172,
                limb2: 1991678899374648705,
                limb3: 0
            }
        };

        let c_0: u384 = u384 {
            limb0: 58533449540510171611906208325,
            limb1: 10308808319958257447821756622,
            limb2: 276613436898430979,
            limb3: 0
        };

        let (c_of_z_result, c_inv_of_z_result, lhs_result) =
            run_BN254_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit(
            lambda_root, z, c_inv, c_0
        );
        let c_of_z: u384 = u384 {
            limb0: 55294240156276719054463270236,
            limb1: 667546056183488857237683399,
            limb2: 895977177379364823,
            limb3: 0
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 13140352949420521600793149182,
            limb1: 24641262820104870956413826814,
            limb2: 2077117659164571710,
            limb3: 0
        };

        let lhs: u384 = u384 {
            limb0: 54393083694678116456850972426,
            limb1: 28384089437371780343316498557,
            limb2: 2180541391488117100,
            limb3: 0
        };
        assert_eq!(c_of_z_result, c_of_z);
        assert_eq!(c_inv_of_z_result, c_inv_of_z);
        assert_eq!(lhs_result, lhs);
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
