use core::circuit::{
    RangeCheck96, AddMod, MulMod, u384, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
    circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, CircuitOutputsTrait,
    CircuitModulus, AddInputResultTrait, CircuitInputs, CircuitDefinition, CircuitData,
    CircuitInputAccumulator
};
use core::circuit::CircuitElement as CE;
use core::circuit::CircuitInput as CI;
use garaga::definitions::{
    get_a, get_b, get_p, get_g, get_min_one, G1Point, G2Point, E12D, E12DMulQuotient, G1G2Pair,
    BNProcessedPair, BLSProcessedPair, MillerLoopResultScalingFactor, G2Line
};
use garaga::ec_ops::{SlopeInterceptOutput, FunctionFeltEvaluations, FunctionFelt};
use core::option::Option;


fn run_BLS12_381_GROTH16_BIT00_LOOP_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    G2_line_0: G2Line,
    G2_line_2nd_0_0: G2Line,
    yInv_1: u384,
    xNegOverY_1: u384,
    G2_line_1: G2Line,
    G2_line_2nd_0_1: G2Line,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q_2: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one: E12D,
    z: u384,
    ci: u384
) -> (G2Point, u384, u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x3
    let in1 = CE::<CI<1>> {}; // 0x6
    let in2 = CE::<CI<2>> {}; // 0x0

    // INPUT stack
    let (in3, in4) = (CE::<CI<3>> {}, CE::<CI<4>> {});
    let (in5, in6) = (CE::<CI<5>> {}, CE::<CI<6>> {});
    let (in7, in8) = (CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10) = (CE::<CI<9>> {}, CE::<CI<10>> {});
    let (in11, in12) = (CE::<CI<11>> {}, CE::<CI<12>> {});
    let (in13, in14) = (CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16) = (CE::<CI<15>> {}, CE::<CI<16>> {});
    let (in17, in18) = (CE::<CI<17>> {}, CE::<CI<18>> {});
    let (in19, in20) = (CE::<CI<19>> {}, CE::<CI<20>> {});
    let (in21, in22) = (CE::<CI<21>> {}, CE::<CI<22>> {});
    let (in23, in24) = (CE::<CI<23>> {}, CE::<CI<24>> {});
    let (in25, in26) = (CE::<CI<25>> {}, CE::<CI<26>> {});
    let (in27, in28) = (CE::<CI<27>> {}, CE::<CI<28>> {});
    let (in29, in30) = (CE::<CI<29>> {}, CE::<CI<30>> {});
    let (in31, in32) = (CE::<CI<31>> {}, CE::<CI<32>> {});
    let (in33, in34) = (CE::<CI<33>> {}, CE::<CI<34>> {});
    let (in35, in36) = (CE::<CI<35>> {}, CE::<CI<36>> {});
    let (in37, in38) = (CE::<CI<37>> {}, CE::<CI<38>> {});
    let (in39, in40) = (CE::<CI<39>> {}, CE::<CI<40>> {});
    let (in41, in42) = (CE::<CI<41>> {}, CE::<CI<42>> {});
    let (in43, in44) = (CE::<CI<43>> {}, CE::<CI<44>> {});
    let t0 = circuit_mul(in43, in43); // Compute z^2
    let t1 = circuit_mul(t0, in43); // Compute z^3
    let t2 = circuit_mul(t1, in43); // Compute z^4
    let t3 = circuit_mul(t2, in43); // Compute z^5
    let t4 = circuit_mul(t3, in43); // Compute z^6
    let t5 = circuit_mul(t4, in43); // Compute z^7
    let t6 = circuit_mul(t5, in43); // Compute z^8
    let t7 = circuit_mul(t6, in43); // Compute z^9
    let t8 = circuit_mul(t7, in43); // Compute z^10
    let t9 = circuit_mul(t8, in43); // Compute z^11
    let t10 = circuit_mul(in44, in44); // Compute c_i = (c_(i-1))^2
    let t11 = circuit_mul(in30, in30); // Square f evaluation in Z, the result of previous bit.
    let t12 = circuit_sub(in7, in8);
    let t13 = circuit_mul(t12, in3);
    let t14 = circuit_sub(in5, in6);
    let t15 = circuit_mul(t14, in4);
    let t16 = circuit_mul(in8, in3);
    let t17 = circuit_mul(in6, in4);
    let t18 = circuit_mul(t15, t0); // Eval sparse poly line_0p_1 step coeff_2 * z^2
    let t19 = circuit_add(t13, t18); // Eval sparse poly line_0p_1 step + coeff_2 * z^2
    let t20 = circuit_add(t19, t1); // Eval sparse poly line_0p_1 step + 1*z^3
    let t21 = circuit_mul(t16, t4); // Eval sparse poly line_0p_1 step coeff_6 * z^6
    let t22 = circuit_add(t20, t21); // Eval sparse poly line_0p_1 step + coeff_6 * z^6
    let t23 = circuit_mul(t17, t6); // Eval sparse poly line_0p_1 step coeff_8 * z^8
    let t24 = circuit_add(t22, t23); // Eval sparse poly line_0p_1 step + coeff_8 * z^8
    let t25 = circuit_mul(t11, t24); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t26 = circuit_sub(in11, in12);
    let t27 = circuit_mul(t26, in13);
    let t28 = circuit_sub(in9, in10);
    let t29 = circuit_mul(t28, in14);
    let t30 = circuit_mul(in12, in13);
    let t31 = circuit_mul(in10, in14);
    let t32 = circuit_mul(t29, t0); // Eval sparse poly line_1p_1 step coeff_2 * z^2
    let t33 = circuit_add(t27, t32); // Eval sparse poly line_1p_1 step + coeff_2 * z^2
    let t34 = circuit_add(t33, t1); // Eval sparse poly line_1p_1 step + 1*z^3
    let t35 = circuit_mul(t30, t4); // Eval sparse poly line_1p_1 step coeff_6 * z^6
    let t36 = circuit_add(t34, t35); // Eval sparse poly line_1p_1 step + coeff_6 * z^6
    let t37 = circuit_mul(t31, t6); // Eval sparse poly line_1p_1 step coeff_8 * z^8
    let t38 = circuit_add(t36, t37); // Eval sparse poly line_1p_1 step + coeff_8 * z^8
    let t39 = circuit_mul(t25, t38); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t40 = circuit_add(in25, in26); // Doubling slope numerator start
    let t41 = circuit_sub(in25, in26);
    let t42 = circuit_mul(t40, t41);
    let t43 = circuit_mul(in25, in26);
    let t44 = circuit_mul(t42, in0);
    let t45 = circuit_mul(t43, in1); // Doubling slope numerator end
    let t46 = circuit_add(in27, in27); // Fp2 add coeff 0/1
    let t47 = circuit_add(in28, in28); // Fp2 add coeff 1/1
    let t48 = circuit_mul(t46, t46); // Fp2 Div x/y start : Fp2 Inv y start
    let t49 = circuit_mul(t47, t47);
    let t50 = circuit_add(t48, t49);
    let t51 = circuit_inverse(t50);
    let t52 = circuit_mul(t46, t51); // Fp2 Inv y real part end
    let t53 = circuit_mul(t47, t51);
    let t54 = circuit_sub(in2, t53); // Fp2 Inv y imag part end
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
    let t66 = circuit_add(in25, in25); // Fp2 add coeff 0/1
    let t67 = circuit_add(in26, in26); // Fp2 add coeff 1/1
    let t68 = circuit_sub(t63, t66); // Fp2 sub coeff 0/1
    let t69 = circuit_sub(t65, t67); // Fp2 sub coeff 1/1
    let t70 = circuit_sub(in25, t68); // Fp2 sub coeff 0/1
    let t71 = circuit_sub(in26, t69); // Fp2 sub coeff 1/1
    let t72 = circuit_mul(t57, t70); // Fp2 mul start
    let t73 = circuit_mul(t60, t71);
    let t74 = circuit_sub(t72, t73); // Fp2 mul real part end
    let t75 = circuit_mul(t57, t71);
    let t76 = circuit_mul(t60, t70);
    let t77 = circuit_add(t75, t76); // Fp2 mul imag part end
    let t78 = circuit_sub(t74, in27); // Fp2 sub coeff 0/1
    let t79 = circuit_sub(t77, in28); // Fp2 sub coeff 1/1
    let t80 = circuit_mul(t57, in25); // Fp2 mul start
    let t81 = circuit_mul(t60, in26);
    let t82 = circuit_sub(t80, t81); // Fp2 mul real part end
    let t83 = circuit_mul(t57, in26);
    let t84 = circuit_mul(t60, in25);
    let t85 = circuit_add(t83, t84); // Fp2 mul imag part end
    let t86 = circuit_sub(t82, in27); // Fp2 sub coeff 0/1
    let t87 = circuit_sub(t85, in28); // Fp2 sub coeff 1/1
    let t88 = circuit_sub(t86, t87);
    let t89 = circuit_mul(t88, in23);
    let t90 = circuit_sub(t57, t60);
    let t91 = circuit_mul(t90, in24);
    let t92 = circuit_mul(t87, in23);
    let t93 = circuit_mul(t60, in24);
    let t94 = circuit_mul(t91, t0); // Eval sparse poly line_2p_1 step coeff_2 * z^2
    let t95 = circuit_add(t89, t94); // Eval sparse poly line_2p_1 step + coeff_2 * z^2
    let t96 = circuit_add(t95, t1); // Eval sparse poly line_2p_1 step + 1*z^3
    let t97 = circuit_mul(t92, t4); // Eval sparse poly line_2p_1 step coeff_6 * z^6
    let t98 = circuit_add(t96, t97); // Eval sparse poly line_2p_1 step + coeff_6 * z^6
    let t99 = circuit_mul(t93, t6); // Eval sparse poly line_2p_1 step coeff_8 * z^8
    let t100 = circuit_add(t98, t99); // Eval sparse poly line_2p_1 step + coeff_8 * z^8
    let t101 = circuit_mul(t39, t100); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t102 = circuit_mul(
        t101, t101
    ); // Compute (f^2 * Π(i,k) (line_i,k(z))) ^ 2 = f^4 * (Π(i,k) (line_i,k(z)))^2
    let t103 = circuit_sub(in17, in18);
    let t104 = circuit_mul(t103, in3);
    let t105 = circuit_sub(in15, in16);
    let t106 = circuit_mul(t105, in4);
    let t107 = circuit_mul(in18, in3);
    let t108 = circuit_mul(in16, in4);
    let t109 = circuit_mul(t106, t0); // Eval sparse poly line_0p_1 step coeff_2 * z^2
    let t110 = circuit_add(t104, t109); // Eval sparse poly line_0p_1 step + coeff_2 * z^2
    let t111 = circuit_add(t110, t1); // Eval sparse poly line_0p_1 step + 1*z^3
    let t112 = circuit_mul(t107, t4); // Eval sparse poly line_0p_1 step coeff_6 * z^6
    let t113 = circuit_add(t111, t112); // Eval sparse poly line_0p_1 step + coeff_6 * z^6
    let t114 = circuit_mul(t108, t6); // Eval sparse poly line_0p_1 step coeff_8 * z^8
    let t115 = circuit_add(t113, t114); // Eval sparse poly line_0p_1 step + coeff_8 * z^8
    let t116 = circuit_mul(t102, t115); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t117 = circuit_sub(in21, in22);
    let t118 = circuit_mul(t117, in13);
    let t119 = circuit_sub(in19, in20);
    let t120 = circuit_mul(t119, in14);
    let t121 = circuit_mul(in22, in13);
    let t122 = circuit_mul(in20, in14);
    let t123 = circuit_mul(t120, t0); // Eval sparse poly line_1p_1 step coeff_2 * z^2
    let t124 = circuit_add(t118, t123); // Eval sparse poly line_1p_1 step + coeff_2 * z^2
    let t125 = circuit_add(t124, t1); // Eval sparse poly line_1p_1 step + 1*z^3
    let t126 = circuit_mul(t121, t4); // Eval sparse poly line_1p_1 step coeff_6 * z^6
    let t127 = circuit_add(t125, t126); // Eval sparse poly line_1p_1 step + coeff_6 * z^6
    let t128 = circuit_mul(t122, t6); // Eval sparse poly line_1p_1 step coeff_8 * z^8
    let t129 = circuit_add(t127, t128); // Eval sparse poly line_1p_1 step + coeff_8 * z^8
    let t130 = circuit_mul(t116, t129); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t131 = circuit_add(t68, t69); // Doubling slope numerator start
    let t132 = circuit_sub(t68, t69);
    let t133 = circuit_mul(t131, t132);
    let t134 = circuit_mul(t68, t69);
    let t135 = circuit_mul(t133, in0);
    let t136 = circuit_mul(t134, in1); // Doubling slope numerator end
    let t137 = circuit_add(t78, t78); // Fp2 add coeff 0/1
    let t138 = circuit_add(t79, t79); // Fp2 add coeff 1/1
    let t139 = circuit_mul(t137, t137); // Fp2 Div x/y start : Fp2 Inv y start
    let t140 = circuit_mul(t138, t138);
    let t141 = circuit_add(t139, t140);
    let t142 = circuit_inverse(t141);
    let t143 = circuit_mul(t137, t142); // Fp2 Inv y real part end
    let t144 = circuit_mul(t138, t142);
    let t145 = circuit_sub(in2, t144); // Fp2 Inv y imag part end
    let t146 = circuit_mul(t135, t143); // Fp2 mul start
    let t147 = circuit_mul(t136, t145);
    let t148 = circuit_sub(t146, t147); // Fp2 mul real part end
    let t149 = circuit_mul(t135, t145);
    let t150 = circuit_mul(t136, t143);
    let t151 = circuit_add(t149, t150); // Fp2 mul imag part end
    let t152 = circuit_add(t148, t151);
    let t153 = circuit_sub(t148, t151);
    let t154 = circuit_mul(t152, t153);
    let t155 = circuit_mul(t148, t151);
    let t156 = circuit_add(t155, t155);
    let t157 = circuit_add(t68, t68); // Fp2 add coeff 0/1
    let t158 = circuit_add(t69, t69); // Fp2 add coeff 1/1
    let t159 = circuit_sub(t154, t157); // Fp2 sub coeff 0/1
    let t160 = circuit_sub(t156, t158); // Fp2 sub coeff 1/1
    let t161 = circuit_sub(t68, t159); // Fp2 sub coeff 0/1
    let t162 = circuit_sub(t69, t160); // Fp2 sub coeff 1/1
    let t163 = circuit_mul(t148, t161); // Fp2 mul start
    let t164 = circuit_mul(t151, t162);
    let t165 = circuit_sub(t163, t164); // Fp2 mul real part end
    let t166 = circuit_mul(t148, t162);
    let t167 = circuit_mul(t151, t161);
    let t168 = circuit_add(t166, t167); // Fp2 mul imag part end
    let t169 = circuit_sub(t165, t78); // Fp2 sub coeff 0/1
    let t170 = circuit_sub(t168, t79); // Fp2 sub coeff 1/1
    let t171 = circuit_mul(t148, t68); // Fp2 mul start
    let t172 = circuit_mul(t151, t69);
    let t173 = circuit_sub(t171, t172); // Fp2 mul real part end
    let t174 = circuit_mul(t148, t69);
    let t175 = circuit_mul(t151, t68);
    let t176 = circuit_add(t174, t175); // Fp2 mul imag part end
    let t177 = circuit_sub(t173, t78); // Fp2 sub coeff 0/1
    let t178 = circuit_sub(t176, t79); // Fp2 sub coeff 1/1
    let t179 = circuit_sub(t177, t178);
    let t180 = circuit_mul(t179, in23);
    let t181 = circuit_sub(t148, t151);
    let t182 = circuit_mul(t181, in24);
    let t183 = circuit_mul(t178, in23);
    let t184 = circuit_mul(t151, in24);
    let t185 = circuit_mul(t182, t0); // Eval sparse poly line_2p_1 step coeff_2 * z^2
    let t186 = circuit_add(t180, t185); // Eval sparse poly line_2p_1 step + coeff_2 * z^2
    let t187 = circuit_add(t186, t1); // Eval sparse poly line_2p_1 step + 1*z^3
    let t188 = circuit_mul(t183, t4); // Eval sparse poly line_2p_1 step coeff_6 * z^6
    let t189 = circuit_add(t187, t188); // Eval sparse poly line_2p_1 step + coeff_6 * z^6
    let t190 = circuit_mul(t184, t6); // Eval sparse poly line_2p_1 step coeff_8 * z^8
    let t191 = circuit_add(t189, t190); // Eval sparse poly line_2p_1 step + coeff_8 * z^8
    let t192 = circuit_mul(t130, t191); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t193 = circuit_mul(in32, in43); // Eval R step coeff_1 * z^1
    let t194 = circuit_add(in31, t193); // Eval R step + (coeff_1 * z^1)
    let t195 = circuit_mul(in33, t0); // Eval R step coeff_2 * z^2
    let t196 = circuit_add(t194, t195); // Eval R step + (coeff_2 * z^2)
    let t197 = circuit_mul(in34, t1); // Eval R step coeff_3 * z^3
    let t198 = circuit_add(t196, t197); // Eval R step + (coeff_3 * z^3)
    let t199 = circuit_mul(in35, t2); // Eval R step coeff_4 * z^4
    let t200 = circuit_add(t198, t199); // Eval R step + (coeff_4 * z^4)
    let t201 = circuit_mul(in36, t3); // Eval R step coeff_5 * z^5
    let t202 = circuit_add(t200, t201); // Eval R step + (coeff_5 * z^5)
    let t203 = circuit_mul(in37, t4); // Eval R step coeff_6 * z^6
    let t204 = circuit_add(t202, t203); // Eval R step + (coeff_6 * z^6)
    let t205 = circuit_mul(in38, t5); // Eval R step coeff_7 * z^7
    let t206 = circuit_add(t204, t205); // Eval R step + (coeff_7 * z^7)
    let t207 = circuit_mul(in39, t6); // Eval R step coeff_8 * z^8
    let t208 = circuit_add(t206, t207); // Eval R step + (coeff_8 * z^8)
    let t209 = circuit_mul(in40, t7); // Eval R step coeff_9 * z^9
    let t210 = circuit_add(t208, t209); // Eval R step + (coeff_9 * z^9)
    let t211 = circuit_mul(in41, t8); // Eval R step coeff_10 * z^10
    let t212 = circuit_add(t210, t211); // Eval R step + (coeff_10 * z^10)
    let t213 = circuit_mul(in42, t9); // Eval R step coeff_11 * z^11
    let t214 = circuit_add(t212, t213); // Eval R step + (coeff_11 * z^11)
    let t215 = circuit_sub(t192, t214); // (Π(i,k) (Pk(z))) - Ri(z)
    let t216 = circuit_mul(t10, t215); // ci * ((Π(i,k) (Pk(z)) - Ri(z))
    let t217 = circuit_add(in29, t216); // LHS = LHS + ci * ((Π(i,k) (Pk(z)) - Ri(z))

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

    let mut circuit_inputs = (t159, t160, t169, t170, t214, t217, t10,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x6, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(G2_line_0.r0a0);
    circuit_inputs = circuit_inputs.next(G2_line_0.r0a1);
    circuit_inputs = circuit_inputs.next(G2_line_0.r1a0);
    circuit_inputs = circuit_inputs.next(G2_line_0.r1a1);
    circuit_inputs = circuit_inputs.next(G2_line_2nd_0_0.r0a0);
    circuit_inputs = circuit_inputs.next(G2_line_2nd_0_0.r0a1);
    circuit_inputs = circuit_inputs.next(G2_line_2nd_0_0.r1a0);
    circuit_inputs = circuit_inputs.next(G2_line_2nd_0_0.r1a1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(G2_line_1.r0a0);
    circuit_inputs = circuit_inputs.next(G2_line_1.r0a1);
    circuit_inputs = circuit_inputs.next(G2_line_1.r1a0);
    circuit_inputs = circuit_inputs.next(G2_line_1.r1a1);
    circuit_inputs = circuit_inputs.next(G2_line_2nd_0_1.r0a0);
    circuit_inputs = circuit_inputs.next(G2_line_2nd_0_1.r0a1);
    circuit_inputs = circuit_inputs.next(G2_line_2nd_0_1.r1a0);
    circuit_inputs = circuit_inputs.next(G2_line_2nd_0_1.r1a1);
    circuit_inputs = circuit_inputs.next(yInv_2);
    circuit_inputs = circuit_inputs.next(xNegOverY_2);
    circuit_inputs = circuit_inputs.next(Q_2.x0);
    circuit_inputs = circuit_inputs.next(Q_2.x1);
    circuit_inputs = circuit_inputs.next(Q_2.y0);
    circuit_inputs = circuit_inputs.next(Q_2.y1);
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
    circuit_inputs = circuit_inputs.next(z);
    circuit_inputs = circuit_inputs.next(ci);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let Q2: G2Point = G2Point {
        x0: outputs.get_output(t159),
        x1: outputs.get_output(t160),
        y0: outputs.get_output(t169),
        y1: outputs.get_output(t170)
    };
    let f_i_plus_one_of_z: u384 = outputs.get_output(t214);
    let lhs_i_plus_one: u384 = outputs.get_output(t217);
    let ci_plus_one: u384 = outputs.get_output(t10);
    return (Q2, f_i_plus_one_of_z, lhs_i_plus_one, ci_plus_one);
}
fn run_BLS12_381_GROTH16_BIT0_LOOP_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    G2_line_0: G2Line,
    yInv_1: u384,
    xNegOverY_1: u384,
    G2_line_1: G2Line,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q_2: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one: E12D,
    z: u384,
    ci: u384
) -> (G2Point, u384, u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x3
    let in1 = CE::<CI<1>> {}; // 0x6
    let in2 = CE::<CI<2>> {}; // 0x0

    // INPUT stack
    let (in3, in4) = (CE::<CI<3>> {}, CE::<CI<4>> {});
    let (in5, in6) = (CE::<CI<5>> {}, CE::<CI<6>> {});
    let (in7, in8) = (CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10) = (CE::<CI<9>> {}, CE::<CI<10>> {});
    let (in11, in12) = (CE::<CI<11>> {}, CE::<CI<12>> {});
    let (in13, in14) = (CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16) = (CE::<CI<15>> {}, CE::<CI<16>> {});
    let (in17, in18) = (CE::<CI<17>> {}, CE::<CI<18>> {});
    let (in19, in20) = (CE::<CI<19>> {}, CE::<CI<20>> {});
    let (in21, in22) = (CE::<CI<21>> {}, CE::<CI<22>> {});
    let (in23, in24) = (CE::<CI<23>> {}, CE::<CI<24>> {});
    let (in25, in26) = (CE::<CI<25>> {}, CE::<CI<26>> {});
    let (in27, in28) = (CE::<CI<27>> {}, CE::<CI<28>> {});
    let (in29, in30) = (CE::<CI<29>> {}, CE::<CI<30>> {});
    let (in31, in32) = (CE::<CI<31>> {}, CE::<CI<32>> {});
    let (in33, in34) = (CE::<CI<33>> {}, CE::<CI<34>> {});
    let (in35, in36) = (CE::<CI<35>> {}, CE::<CI<36>> {});
    let t0 = circuit_mul(in35, in35); // Compute z^2
    let t1 = circuit_mul(t0, in35); // Compute z^3
    let t2 = circuit_mul(t1, in35); // Compute z^4
    let t3 = circuit_mul(t2, in35); // Compute z^5
    let t4 = circuit_mul(t3, in35); // Compute z^6
    let t5 = circuit_mul(t4, in35); // Compute z^7
    let t6 = circuit_mul(t5, in35); // Compute z^8
    let t7 = circuit_mul(t6, in35); // Compute z^9
    let t8 = circuit_mul(t7, in35); // Compute z^10
    let t9 = circuit_mul(t8, in35); // Compute z^11
    let t10 = circuit_mul(in36, in36); // Compute c_i = (c_(i-1))^2
    let t11 = circuit_mul(in22, in22); // Square f evaluation in Z, the result of previous bit.
    let t12 = circuit_sub(in7, in8);
    let t13 = circuit_mul(t12, in3);
    let t14 = circuit_sub(in5, in6);
    let t15 = circuit_mul(t14, in4);
    let t16 = circuit_mul(in8, in3);
    let t17 = circuit_mul(in6, in4);
    let t18 = circuit_mul(t15, t0); // Eval sparse poly line_0p_1 step coeff_2 * z^2
    let t19 = circuit_add(t13, t18); // Eval sparse poly line_0p_1 step + coeff_2 * z^2
    let t20 = circuit_add(t19, t1); // Eval sparse poly line_0p_1 step + 1*z^3
    let t21 = circuit_mul(t16, t4); // Eval sparse poly line_0p_1 step coeff_6 * z^6
    let t22 = circuit_add(t20, t21); // Eval sparse poly line_0p_1 step + coeff_6 * z^6
    let t23 = circuit_mul(t17, t6); // Eval sparse poly line_0p_1 step coeff_8 * z^8
    let t24 = circuit_add(t22, t23); // Eval sparse poly line_0p_1 step + coeff_8 * z^8
    let t25 = circuit_mul(t11, t24); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t26 = circuit_sub(in13, in14);
    let t27 = circuit_mul(t26, in9);
    let t28 = circuit_sub(in11, in12);
    let t29 = circuit_mul(t28, in10);
    let t30 = circuit_mul(in14, in9);
    let t31 = circuit_mul(in12, in10);
    let t32 = circuit_mul(t29, t0); // Eval sparse poly line_1p_1 step coeff_2 * z^2
    let t33 = circuit_add(t27, t32); // Eval sparse poly line_1p_1 step + coeff_2 * z^2
    let t34 = circuit_add(t33, t1); // Eval sparse poly line_1p_1 step + 1*z^3
    let t35 = circuit_mul(t30, t4); // Eval sparse poly line_1p_1 step coeff_6 * z^6
    let t36 = circuit_add(t34, t35); // Eval sparse poly line_1p_1 step + coeff_6 * z^6
    let t37 = circuit_mul(t31, t6); // Eval sparse poly line_1p_1 step coeff_8 * z^8
    let t38 = circuit_add(t36, t37); // Eval sparse poly line_1p_1 step + coeff_8 * z^8
    let t39 = circuit_mul(t25, t38); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t40 = circuit_add(in17, in18); // Doubling slope numerator start
    let t41 = circuit_sub(in17, in18);
    let t42 = circuit_mul(t40, t41);
    let t43 = circuit_mul(in17, in18);
    let t44 = circuit_mul(t42, in0);
    let t45 = circuit_mul(t43, in1); // Doubling slope numerator end
    let t46 = circuit_add(in19, in19); // Fp2 add coeff 0/1
    let t47 = circuit_add(in20, in20); // Fp2 add coeff 1/1
    let t48 = circuit_mul(t46, t46); // Fp2 Div x/y start : Fp2 Inv y start
    let t49 = circuit_mul(t47, t47);
    let t50 = circuit_add(t48, t49);
    let t51 = circuit_inverse(t50);
    let t52 = circuit_mul(t46, t51); // Fp2 Inv y real part end
    let t53 = circuit_mul(t47, t51);
    let t54 = circuit_sub(in2, t53); // Fp2 Inv y imag part end
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
    let t66 = circuit_add(in17, in17); // Fp2 add coeff 0/1
    let t67 = circuit_add(in18, in18); // Fp2 add coeff 1/1
    let t68 = circuit_sub(t63, t66); // Fp2 sub coeff 0/1
    let t69 = circuit_sub(t65, t67); // Fp2 sub coeff 1/1
    let t70 = circuit_sub(in17, t68); // Fp2 sub coeff 0/1
    let t71 = circuit_sub(in18, t69); // Fp2 sub coeff 1/1
    let t72 = circuit_mul(t57, t70); // Fp2 mul start
    let t73 = circuit_mul(t60, t71);
    let t74 = circuit_sub(t72, t73); // Fp2 mul real part end
    let t75 = circuit_mul(t57, t71);
    let t76 = circuit_mul(t60, t70);
    let t77 = circuit_add(t75, t76); // Fp2 mul imag part end
    let t78 = circuit_sub(t74, in19); // Fp2 sub coeff 0/1
    let t79 = circuit_sub(t77, in20); // Fp2 sub coeff 1/1
    let t80 = circuit_mul(t57, in17); // Fp2 mul start
    let t81 = circuit_mul(t60, in18);
    let t82 = circuit_sub(t80, t81); // Fp2 mul real part end
    let t83 = circuit_mul(t57, in18);
    let t84 = circuit_mul(t60, in17);
    let t85 = circuit_add(t83, t84); // Fp2 mul imag part end
    let t86 = circuit_sub(t82, in19); // Fp2 sub coeff 0/1
    let t87 = circuit_sub(t85, in20); // Fp2 sub coeff 1/1
    let t88 = circuit_sub(t86, t87);
    let t89 = circuit_mul(t88, in15);
    let t90 = circuit_sub(t57, t60);
    let t91 = circuit_mul(t90, in16);
    let t92 = circuit_mul(t87, in15);
    let t93 = circuit_mul(t60, in16);
    let t94 = circuit_mul(t91, t0); // Eval sparse poly line_2p_1 step coeff_2 * z^2
    let t95 = circuit_add(t89, t94); // Eval sparse poly line_2p_1 step + coeff_2 * z^2
    let t96 = circuit_add(t95, t1); // Eval sparse poly line_2p_1 step + 1*z^3
    let t97 = circuit_mul(t92, t4); // Eval sparse poly line_2p_1 step coeff_6 * z^6
    let t98 = circuit_add(t96, t97); // Eval sparse poly line_2p_1 step + coeff_6 * z^6
    let t99 = circuit_mul(t93, t6); // Eval sparse poly line_2p_1 step coeff_8 * z^8
    let t100 = circuit_add(t98, t99); // Eval sparse poly line_2p_1 step + coeff_8 * z^8
    let t101 = circuit_mul(t39, t100); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t102 = circuit_mul(in24, in35); // Eval R step coeff_1 * z^1
    let t103 = circuit_add(in23, t102); // Eval R step + (coeff_1 * z^1)
    let t104 = circuit_mul(in25, t0); // Eval R step coeff_2 * z^2
    let t105 = circuit_add(t103, t104); // Eval R step + (coeff_2 * z^2)
    let t106 = circuit_mul(in26, t1); // Eval R step coeff_3 * z^3
    let t107 = circuit_add(t105, t106); // Eval R step + (coeff_3 * z^3)
    let t108 = circuit_mul(in27, t2); // Eval R step coeff_4 * z^4
    let t109 = circuit_add(t107, t108); // Eval R step + (coeff_4 * z^4)
    let t110 = circuit_mul(in28, t3); // Eval R step coeff_5 * z^5
    let t111 = circuit_add(t109, t110); // Eval R step + (coeff_5 * z^5)
    let t112 = circuit_mul(in29, t4); // Eval R step coeff_6 * z^6
    let t113 = circuit_add(t111, t112); // Eval R step + (coeff_6 * z^6)
    let t114 = circuit_mul(in30, t5); // Eval R step coeff_7 * z^7
    let t115 = circuit_add(t113, t114); // Eval R step + (coeff_7 * z^7)
    let t116 = circuit_mul(in31, t6); // Eval R step coeff_8 * z^8
    let t117 = circuit_add(t115, t116); // Eval R step + (coeff_8 * z^8)
    let t118 = circuit_mul(in32, t7); // Eval R step coeff_9 * z^9
    let t119 = circuit_add(t117, t118); // Eval R step + (coeff_9 * z^9)
    let t120 = circuit_mul(in33, t8); // Eval R step coeff_10 * z^10
    let t121 = circuit_add(t119, t120); // Eval R step + (coeff_10 * z^10)
    let t122 = circuit_mul(in34, t9); // Eval R step coeff_11 * z^11
    let t123 = circuit_add(t121, t122); // Eval R step + (coeff_11 * z^11)
    let t124 = circuit_sub(t101, t123); // (Π(i,k) (Pk(z))) - Ri(z)
    let t125 = circuit_mul(t10, t124); // ci * ((Π(i,k) (Pk(z)) - Ri(z))
    let t126 = circuit_add(in21, t125); // LHS = LHS + ci * ((Π(i,k) (Pk(z)) - Ri(z))

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

    let mut circuit_inputs = (t68, t69, t78, t79, t123, t126, t10,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x6, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(G2_line_0.r0a0);
    circuit_inputs = circuit_inputs.next(G2_line_0.r0a1);
    circuit_inputs = circuit_inputs.next(G2_line_0.r1a0);
    circuit_inputs = circuit_inputs.next(G2_line_0.r1a1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(G2_line_1.r0a0);
    circuit_inputs = circuit_inputs.next(G2_line_1.r0a1);
    circuit_inputs = circuit_inputs.next(G2_line_1.r1a0);
    circuit_inputs = circuit_inputs.next(G2_line_1.r1a1);
    circuit_inputs = circuit_inputs.next(yInv_2);
    circuit_inputs = circuit_inputs.next(xNegOverY_2);
    circuit_inputs = circuit_inputs.next(Q_2.x0);
    circuit_inputs = circuit_inputs.next(Q_2.x1);
    circuit_inputs = circuit_inputs.next(Q_2.y0);
    circuit_inputs = circuit_inputs.next(Q_2.y1);
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
    circuit_inputs = circuit_inputs.next(z);
    circuit_inputs = circuit_inputs.next(ci);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let Q2: G2Point = G2Point {
        x0: outputs.get_output(t68),
        x1: outputs.get_output(t69),
        y0: outputs.get_output(t78),
        y1: outputs.get_output(t79)
    };
    let f_i_plus_one_of_z: u384 = outputs.get_output(t123);
    let lhs_i_plus_one: u384 = outputs.get_output(t126);
    let ci_plus_one: u384 = outputs.get_output(t10);
    return (Q2, f_i_plus_one_of_z, lhs_i_plus_one, ci_plus_one);
}
fn run_BLS12_381_GROTH16_BIT1_LOOP_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    G2_line_0: G2Line,
    Q_or_Q_neg_line0: G2Line,
    yInv_1: u384,
    xNegOverY_1: u384,
    G2_line_1: G2Line,
    Q_or_Q_neg_line1: G2Line,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q_2: G2Point,
    Q_or_Q_neg_2: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one: E12D,
    c_or_cinv_of_z: u384,
    z: u384,
    ci: u384
) -> (G2Point, u384, u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0

    // INPUT stack
    let (in1, in2) = (CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4) = (CE::<CI<3>> {}, CE::<CI<4>> {});
    let (in5, in6) = (CE::<CI<5>> {}, CE::<CI<6>> {});
    let (in7, in8) = (CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10) = (CE::<CI<9>> {}, CE::<CI<10>> {});
    let (in11, in12) = (CE::<CI<11>> {}, CE::<CI<12>> {});
    let (in13, in14) = (CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16) = (CE::<CI<15>> {}, CE::<CI<16>> {});
    let (in17, in18) = (CE::<CI<17>> {}, CE::<CI<18>> {});
    let (in19, in20) = (CE::<CI<19>> {}, CE::<CI<20>> {});
    let (in21, in22) = (CE::<CI<21>> {}, CE::<CI<22>> {});
    let (in23, in24) = (CE::<CI<23>> {}, CE::<CI<24>> {});
    let (in25, in26) = (CE::<CI<25>> {}, CE::<CI<26>> {});
    let (in27, in28) = (CE::<CI<27>> {}, CE::<CI<28>> {});
    let (in29, in30) = (CE::<CI<29>> {}, CE::<CI<30>> {});
    let (in31, in32) = (CE::<CI<31>> {}, CE::<CI<32>> {});
    let (in33, in34) = (CE::<CI<33>> {}, CE::<CI<34>> {});
    let (in35, in36) = (CE::<CI<35>> {}, CE::<CI<36>> {});
    let (in37, in38) = (CE::<CI<37>> {}, CE::<CI<38>> {});
    let (in39, in40) = (CE::<CI<39>> {}, CE::<CI<40>> {});
    let (in41, in42) = (CE::<CI<41>> {}, CE::<CI<42>> {});
    let (in43, in44) = (CE::<CI<43>> {}, CE::<CI<44>> {});
    let (in45, in46) = (CE::<CI<45>> {}, CE::<CI<46>> {});
    let in47 = CE::<CI<47>> {};
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
    let t10 = circuit_mul(in47, in47); // Compute c_i = (c_(i-1))^2
    let t11 = circuit_mul(in32, in32); // Square f evaluation in Z, the result of previous bit.
    let t12 = circuit_sub(in5, in6);
    let t13 = circuit_mul(t12, in1);
    let t14 = circuit_sub(in3, in4);
    let t15 = circuit_mul(t14, in2);
    let t16 = circuit_mul(in6, in1);
    let t17 = circuit_mul(in4, in2);
    let t18 = circuit_sub(in9, in10);
    let t19 = circuit_mul(t18, in1);
    let t20 = circuit_sub(in7, in8);
    let t21 = circuit_mul(t20, in2);
    let t22 = circuit_mul(in10, in1);
    let t23 = circuit_mul(in8, in2);
    let t24 = circuit_mul(t15, t0); // Eval sparse poly line_0p_1 step coeff_2 * z^2
    let t25 = circuit_add(t13, t24); // Eval sparse poly line_0p_1 step + coeff_2 * z^2
    let t26 = circuit_add(t25, t1); // Eval sparse poly line_0p_1 step + 1*z^3
    let t27 = circuit_mul(t16, t4); // Eval sparse poly line_0p_1 step coeff_6 * z^6
    let t28 = circuit_add(t26, t27); // Eval sparse poly line_0p_1 step + coeff_6 * z^6
    let t29 = circuit_mul(t17, t6); // Eval sparse poly line_0p_1 step coeff_8 * z^8
    let t30 = circuit_add(t28, t29); // Eval sparse poly line_0p_1 step + coeff_8 * z^8
    let t31 = circuit_mul(t11, t30); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t32 = circuit_mul(t21, t0); // Eval sparse poly line_0p_2 step coeff_2 * z^2
    let t33 = circuit_add(t19, t32); // Eval sparse poly line_0p_2 step + coeff_2 * z^2
    let t34 = circuit_add(t33, t1); // Eval sparse poly line_0p_2 step + 1*z^3
    let t35 = circuit_mul(t22, t4); // Eval sparse poly line_0p_2 step coeff_6 * z^6
    let t36 = circuit_add(t34, t35); // Eval sparse poly line_0p_2 step + coeff_6 * z^6
    let t37 = circuit_mul(t23, t6); // Eval sparse poly line_0p_2 step coeff_8 * z^8
    let t38 = circuit_add(t36, t37); // Eval sparse poly line_0p_2 step + coeff_8 * z^8
    let t39 = circuit_mul(t31, t38); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t40 = circuit_sub(in15, in16);
    let t41 = circuit_mul(t40, in11);
    let t42 = circuit_sub(in13, in14);
    let t43 = circuit_mul(t42, in12);
    let t44 = circuit_mul(in16, in11);
    let t45 = circuit_mul(in14, in12);
    let t46 = circuit_sub(in19, in20);
    let t47 = circuit_mul(t46, in11);
    let t48 = circuit_sub(in17, in18);
    let t49 = circuit_mul(t48, in12);
    let t50 = circuit_mul(in20, in11);
    let t51 = circuit_mul(in18, in12);
    let t52 = circuit_mul(t43, t0); // Eval sparse poly line_1p_1 step coeff_2 * z^2
    let t53 = circuit_add(t41, t52); // Eval sparse poly line_1p_1 step + coeff_2 * z^2
    let t54 = circuit_add(t53, t1); // Eval sparse poly line_1p_1 step + 1*z^3
    let t55 = circuit_mul(t44, t4); // Eval sparse poly line_1p_1 step coeff_6 * z^6
    let t56 = circuit_add(t54, t55); // Eval sparse poly line_1p_1 step + coeff_6 * z^6
    let t57 = circuit_mul(t45, t6); // Eval sparse poly line_1p_1 step coeff_8 * z^8
    let t58 = circuit_add(t56, t57); // Eval sparse poly line_1p_1 step + coeff_8 * z^8
    let t59 = circuit_mul(t39, t58); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t60 = circuit_mul(t49, t0); // Eval sparse poly line_1p_2 step coeff_2 * z^2
    let t61 = circuit_add(t47, t60); // Eval sparse poly line_1p_2 step + coeff_2 * z^2
    let t62 = circuit_add(t61, t1); // Eval sparse poly line_1p_2 step + 1*z^3
    let t63 = circuit_mul(t50, t4); // Eval sparse poly line_1p_2 step coeff_6 * z^6
    let t64 = circuit_add(t62, t63); // Eval sparse poly line_1p_2 step + coeff_6 * z^6
    let t65 = circuit_mul(t51, t6); // Eval sparse poly line_1p_2 step coeff_8 * z^8
    let t66 = circuit_add(t64, t65); // Eval sparse poly line_1p_2 step + coeff_8 * z^8
    let t67 = circuit_mul(t59, t66); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t68 = circuit_sub(in25, in29); // Fp2 sub coeff 0/1
    let t69 = circuit_sub(in26, in30); // Fp2 sub coeff 1/1
    let t70 = circuit_sub(in23, in27); // Fp2 sub coeff 0/1
    let t71 = circuit_sub(in24, in28); // Fp2 sub coeff 1/1
    let t72 = circuit_mul(t70, t70); // Fp2 Div x/y start : Fp2 Inv y start
    let t73 = circuit_mul(t71, t71);
    let t74 = circuit_add(t72, t73);
    let t75 = circuit_inverse(t74);
    let t76 = circuit_mul(t70, t75); // Fp2 Inv y real part end
    let t77 = circuit_mul(t71, t75);
    let t78 = circuit_sub(in0, t77); // Fp2 Inv y imag part end
    let t79 = circuit_mul(t68, t76); // Fp2 mul start
    let t80 = circuit_mul(t69, t78);
    let t81 = circuit_sub(t79, t80); // Fp2 mul real part end
    let t82 = circuit_mul(t68, t78);
    let t83 = circuit_mul(t69, t76);
    let t84 = circuit_add(t82, t83); // Fp2 mul imag part end
    let t85 = circuit_add(t81, t84);
    let t86 = circuit_sub(t81, t84);
    let t87 = circuit_mul(t85, t86);
    let t88 = circuit_mul(t81, t84);
    let t89 = circuit_add(t88, t88);
    let t90 = circuit_add(in23, in27); // Fp2 add coeff 0/1
    let t91 = circuit_add(in24, in28); // Fp2 add coeff 1/1
    let t92 = circuit_sub(t87, t90); // Fp2 sub coeff 0/1
    let t93 = circuit_sub(t89, t91); // Fp2 sub coeff 1/1
    let t94 = circuit_mul(t81, in23); // Fp2 mul start
    let t95 = circuit_mul(t84, in24);
    let t96 = circuit_sub(t94, t95); // Fp2 mul real part end
    let t97 = circuit_mul(t81, in24);
    let t98 = circuit_mul(t84, in23);
    let t99 = circuit_add(t97, t98); // Fp2 mul imag part end
    let t100 = circuit_sub(t96, in25); // Fp2 sub coeff 0/1
    let t101 = circuit_sub(t99, in26); // Fp2 sub coeff 1/1
    let t102 = circuit_add(in25, in25); // Fp2 add coeff 0/1
    let t103 = circuit_add(in26, in26); // Fp2 add coeff 1/1
    let t104 = circuit_sub(t92, in23); // Fp2 sub coeff 0/1
    let t105 = circuit_sub(t93, in24); // Fp2 sub coeff 1/1
    let t106 = circuit_mul(t104, t104); // Fp2 Div x/y start : Fp2 Inv y start
    let t107 = circuit_mul(t105, t105);
    let t108 = circuit_add(t106, t107);
    let t109 = circuit_inverse(t108);
    let t110 = circuit_mul(t104, t109); // Fp2 Inv y real part end
    let t111 = circuit_mul(t105, t109);
    let t112 = circuit_sub(in0, t111); // Fp2 Inv y imag part end
    let t113 = circuit_mul(t102, t110); // Fp2 mul start
    let t114 = circuit_mul(t103, t112);
    let t115 = circuit_sub(t113, t114); // Fp2 mul real part end
    let t116 = circuit_mul(t102, t112);
    let t117 = circuit_mul(t103, t110);
    let t118 = circuit_add(t116, t117); // Fp2 mul imag part end
    let t119 = circuit_add(t81, t115); // Fp2 add coeff 0/1
    let t120 = circuit_add(t84, t118); // Fp2 add coeff 1/1
    let t121 = circuit_sub(in0, t119); // Fp2 neg coeff 0/1
    let t122 = circuit_sub(in0, t120); // Fp2 neg coeff 1/1
    let t123 = circuit_add(t121, t122);
    let t124 = circuit_sub(t121, t122);
    let t125 = circuit_mul(t123, t124);
    let t126 = circuit_mul(t121, t122);
    let t127 = circuit_add(t126, t126);
    let t128 = circuit_sub(t125, in23); // Fp2 sub coeff 0/1
    let t129 = circuit_sub(t127, in24); // Fp2 sub coeff 1/1
    let t130 = circuit_sub(t128, t92); // Fp2 sub coeff 0/1
    let t131 = circuit_sub(t129, t93); // Fp2 sub coeff 1/1
    let t132 = circuit_sub(in23, t130); // Fp2 sub coeff 0/1
    let t133 = circuit_sub(in24, t131); // Fp2 sub coeff 1/1
    let t134 = circuit_mul(t121, t132); // Fp2 mul start
    let t135 = circuit_mul(t122, t133);
    let t136 = circuit_sub(t134, t135); // Fp2 mul real part end
    let t137 = circuit_mul(t121, t133);
    let t138 = circuit_mul(t122, t132);
    let t139 = circuit_add(t137, t138); // Fp2 mul imag part end
    let t140 = circuit_sub(t136, in25); // Fp2 sub coeff 0/1
    let t141 = circuit_sub(t139, in26); // Fp2 sub coeff 1/1
    let t142 = circuit_mul(t121, in23); // Fp2 mul start
    let t143 = circuit_mul(t122, in24);
    let t144 = circuit_sub(t142, t143); // Fp2 mul real part end
    let t145 = circuit_mul(t121, in24);
    let t146 = circuit_mul(t122, in23);
    let t147 = circuit_add(t145, t146); // Fp2 mul imag part end
    let t148 = circuit_sub(t144, in25); // Fp2 sub coeff 0/1
    let t149 = circuit_sub(t147, in26); // Fp2 sub coeff 1/1
    let t150 = circuit_sub(t100, t101);
    let t151 = circuit_mul(t150, in21);
    let t152 = circuit_sub(t81, t84);
    let t153 = circuit_mul(t152, in22);
    let t154 = circuit_mul(t101, in21);
    let t155 = circuit_mul(t84, in22);
    let t156 = circuit_sub(t148, t149);
    let t157 = circuit_mul(t156, in21);
    let t158 = circuit_sub(t121, t122);
    let t159 = circuit_mul(t158, in22);
    let t160 = circuit_mul(t149, in21);
    let t161 = circuit_mul(t122, in22);
    let t162 = circuit_mul(t153, t0); // Eval sparse poly line_2p_1 step coeff_2 * z^2
    let t163 = circuit_add(t151, t162); // Eval sparse poly line_2p_1 step + coeff_2 * z^2
    let t164 = circuit_add(t163, t1); // Eval sparse poly line_2p_1 step + 1*z^3
    let t165 = circuit_mul(t154, t4); // Eval sparse poly line_2p_1 step coeff_6 * z^6
    let t166 = circuit_add(t164, t165); // Eval sparse poly line_2p_1 step + coeff_6 * z^6
    let t167 = circuit_mul(t155, t6); // Eval sparse poly line_2p_1 step coeff_8 * z^8
    let t168 = circuit_add(t166, t167); // Eval sparse poly line_2p_1 step + coeff_8 * z^8
    let t169 = circuit_mul(t67, t168); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t170 = circuit_mul(t159, t0); // Eval sparse poly line_2p_2 step coeff_2 * z^2
    let t171 = circuit_add(t157, t170); // Eval sparse poly line_2p_2 step + coeff_2 * z^2
    let t172 = circuit_add(t171, t1); // Eval sparse poly line_2p_2 step + 1*z^3
    let t173 = circuit_mul(t160, t4); // Eval sparse poly line_2p_2 step coeff_6 * z^6
    let t174 = circuit_add(t172, t173); // Eval sparse poly line_2p_2 step + coeff_6 * z^6
    let t175 = circuit_mul(t161, t6); // Eval sparse poly line_2p_2 step coeff_8 * z^8
    let t176 = circuit_add(t174, t175); // Eval sparse poly line_2p_2 step + coeff_8 * z^8
    let t177 = circuit_mul(t169, t176); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t178 = circuit_mul(t177, in45);
    let t179 = circuit_mul(in34, in46); // Eval R step coeff_1 * z^1
    let t180 = circuit_add(in33, t179); // Eval R step + (coeff_1 * z^1)
    let t181 = circuit_mul(in35, t0); // Eval R step coeff_2 * z^2
    let t182 = circuit_add(t180, t181); // Eval R step + (coeff_2 * z^2)
    let t183 = circuit_mul(in36, t1); // Eval R step coeff_3 * z^3
    let t184 = circuit_add(t182, t183); // Eval R step + (coeff_3 * z^3)
    let t185 = circuit_mul(in37, t2); // Eval R step coeff_4 * z^4
    let t186 = circuit_add(t184, t185); // Eval R step + (coeff_4 * z^4)
    let t187 = circuit_mul(in38, t3); // Eval R step coeff_5 * z^5
    let t188 = circuit_add(t186, t187); // Eval R step + (coeff_5 * z^5)
    let t189 = circuit_mul(in39, t4); // Eval R step coeff_6 * z^6
    let t190 = circuit_add(t188, t189); // Eval R step + (coeff_6 * z^6)
    let t191 = circuit_mul(in40, t5); // Eval R step coeff_7 * z^7
    let t192 = circuit_add(t190, t191); // Eval R step + (coeff_7 * z^7)
    let t193 = circuit_mul(in41, t6); // Eval R step coeff_8 * z^8
    let t194 = circuit_add(t192, t193); // Eval R step + (coeff_8 * z^8)
    let t195 = circuit_mul(in42, t7); // Eval R step coeff_9 * z^9
    let t196 = circuit_add(t194, t195); // Eval R step + (coeff_9 * z^9)
    let t197 = circuit_mul(in43, t8); // Eval R step coeff_10 * z^10
    let t198 = circuit_add(t196, t197); // Eval R step + (coeff_10 * z^10)
    let t199 = circuit_mul(in44, t9); // Eval R step coeff_11 * z^11
    let t200 = circuit_add(t198, t199); // Eval R step + (coeff_11 * z^11)
    let t201 = circuit_sub(t178, t200); // (Π(i,k) (Pk(z))) - Ri(z)
    let t202 = circuit_mul(t10, t201); // ci * ((Π(i,k) (Pk(z)) - Ri(z))
    let t203 = circuit_add(in31, t202); // LHS = LHS + ci * ((Π(i,k) (Pk(z)) - Ri(z))

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

    let mut circuit_inputs = (t130, t131, t140, t141, t200, t203, t10,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(G2_line_0.r0a0);
    circuit_inputs = circuit_inputs.next(G2_line_0.r0a1);
    circuit_inputs = circuit_inputs.next(G2_line_0.r1a0);
    circuit_inputs = circuit_inputs.next(G2_line_0.r1a1);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_line0.r0a0);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_line0.r0a1);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_line0.r1a0);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_line0.r1a1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(G2_line_1.r0a0);
    circuit_inputs = circuit_inputs.next(G2_line_1.r0a1);
    circuit_inputs = circuit_inputs.next(G2_line_1.r1a0);
    circuit_inputs = circuit_inputs.next(G2_line_1.r1a1);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_line1.r0a0);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_line1.r0a1);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_line1.r1a0);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_line1.r1a1);
    circuit_inputs = circuit_inputs.next(yInv_2);
    circuit_inputs = circuit_inputs.next(xNegOverY_2);
    circuit_inputs = circuit_inputs.next(Q_2.x0);
    circuit_inputs = circuit_inputs.next(Q_2.x1);
    circuit_inputs = circuit_inputs.next(Q_2.y0);
    circuit_inputs = circuit_inputs.next(Q_2.y1);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_2.x0);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_2.x1);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_2.y0);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_2.y1);
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
    let Q2: G2Point = G2Point {
        x0: outputs.get_output(t130),
        x1: outputs.get_output(t131),
        y0: outputs.get_output(t140),
        y1: outputs.get_output(t141)
    };
    let f_i_plus_one_of_z: u384 = outputs.get_output(t200);
    let lhs_i_plus_one: u384 = outputs.get_output(t203);
    let ci_plus_one: u384 = outputs.get_output(t10);
    return (Q2, f_i_plus_one_of_z, lhs_i_plus_one, ci_plus_one);
}
fn run_BLS12_381_GROTH16_FINALIZE_BLS_circuit(
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
    let in0 = CE::<CI<0>> {}; // 0x2
    let in1 = CE::<CI<1>> {}; // -0x2 % p

    // INPUT stack
    let (in2, in3) = (CE::<CI<2>> {}, CE::<CI<3>> {});
    let (in4, in5) = (CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7) = (CE::<CI<6>> {}, CE::<CI<7>> {});
    let (in8, in9) = (CE::<CI<8>> {}, CE::<CI<9>> {});
    let (in10, in11) = (CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13) = (CE::<CI<12>> {}, CE::<CI<13>> {});
    let (in14, in15) = (CE::<CI<14>> {}, CE::<CI<15>> {});
    let (in16, in17) = (CE::<CI<16>> {}, CE::<CI<17>> {});
    let (in18, in19) = (CE::<CI<18>> {}, CE::<CI<19>> {});
    let (in20, in21) = (CE::<CI<20>> {}, CE::<CI<21>> {});
    let (in22, in23) = (CE::<CI<22>> {}, CE::<CI<23>> {});
    let (in24, in25) = (CE::<CI<24>> {}, CE::<CI<25>> {});
    let (in26, in27) = (CE::<CI<26>> {}, CE::<CI<27>> {});
    let (in28, in29) = (CE::<CI<28>> {}, CE::<CI<29>> {});
    let (in30, in31) = (CE::<CI<30>> {}, CE::<CI<31>> {});
    let (in32, in33) = (CE::<CI<32>> {}, CE::<CI<33>> {});
    let (in34, in35) = (CE::<CI<34>> {}, CE::<CI<35>> {});
    let (in36, in37) = (CE::<CI<36>> {}, CE::<CI<37>> {});
    let (in38, in39) = (CE::<CI<38>> {}, CE::<CI<39>> {});
    let (in40, in41) = (CE::<CI<40>> {}, CE::<CI<41>> {});
    let (in42, in43) = (CE::<CI<42>> {}, CE::<CI<43>> {});
    let (in44, in45) = (CE::<CI<44>> {}, CE::<CI<45>> {});
    let (in46, in47) = (CE::<CI<46>> {}, CE::<CI<47>> {});
    let (in48, in49) = (CE::<CI<48>> {}, CE::<CI<49>> {});
    let (in50, in51) = (CE::<CI<50>> {}, CE::<CI<51>> {});
    let (in52, in53) = (CE::<CI<52>> {}, CE::<CI<53>> {});
    let (in54, in55) = (CE::<CI<54>> {}, CE::<CI<55>> {});
    let (in56, in57) = (CE::<CI<56>> {}, CE::<CI<57>> {});
    let (in58, in59) = (CE::<CI<58>> {}, CE::<CI<59>> {});
    let (in60, in61) = (CE::<CI<60>> {}, CE::<CI<61>> {});
    let (in62, in63) = (CE::<CI<62>> {}, CE::<CI<63>> {});
    let (in64, in65) = (CE::<CI<64>> {}, CE::<CI<65>> {});
    let (in66, in67) = (CE::<CI<66>> {}, CE::<CI<67>> {});
    let (in68, in69) = (CE::<CI<68>> {}, CE::<CI<69>> {});
    let (in70, in71) = (CE::<CI<70>> {}, CE::<CI<71>> {});
    let (in72, in73) = (CE::<CI<72>> {}, CE::<CI<73>> {});
    let (in74, in75) = (CE::<CI<74>> {}, CE::<CI<75>> {});
    let (in76, in77) = (CE::<CI<76>> {}, CE::<CI<77>> {});
    let (in78, in79) = (CE::<CI<78>> {}, CE::<CI<79>> {});
    let (in80, in81) = (CE::<CI<80>> {}, CE::<CI<81>> {});
    let (in82, in83) = (CE::<CI<82>> {}, CE::<CI<83>> {});
    let (in84, in85) = (CE::<CI<84>> {}, CE::<CI<85>> {});
    let (in86, in87) = (CE::<CI<86>> {}, CE::<CI<87>> {});
    let (in88, in89) = (CE::<CI<88>> {}, CE::<CI<89>> {});
    let (in90, in91) = (CE::<CI<90>> {}, CE::<CI<91>> {});
    let (in92, in93) = (CE::<CI<92>> {}, CE::<CI<93>> {});
    let (in94, in95) = (CE::<CI<94>> {}, CE::<CI<95>> {});
    let (in96, in97) = (CE::<CI<96>> {}, CE::<CI<97>> {});
    let (in98, in99) = (CE::<CI<98>> {}, CE::<CI<99>> {});
    let (in100, in101) = (CE::<CI<100>> {}, CE::<CI<101>> {});
    let (in102, in103) = (CE::<CI<102>> {}, CE::<CI<103>> {});
    let (in104, in105) = (CE::<CI<104>> {}, CE::<CI<105>> {});
    let (in106, in107) = (CE::<CI<106>> {}, CE::<CI<107>> {});
    let (in108, in109) = (CE::<CI<108>> {}, CE::<CI<109>> {});
    let (in110, in111) = (CE::<CI<110>> {}, CE::<CI<111>> {});
    let (in112, in113) = (CE::<CI<112>> {}, CE::<CI<113>> {});
    let (in114, in115) = (CE::<CI<114>> {}, CE::<CI<115>> {});
    let (in116, in117) = (CE::<CI<116>> {}, CE::<CI<117>> {});
    let (in118, in119) = (CE::<CI<118>> {}, CE::<CI<119>> {});
    let (in120, in121) = (CE::<CI<120>> {}, CE::<CI<121>> {});
    let (in122, in123) = (CE::<CI<122>> {}, CE::<CI<123>> {});
    let in124 = CE::<CI<124>> {};
    let t0 = circuit_mul(in16, in16); // Compute z^2
    let t1 = circuit_mul(t0, in16); // Compute z^3
    let t2 = circuit_mul(t1, in16); // Compute z^4
    let t3 = circuit_mul(t2, in16); // Compute z^5
    let t4 = circuit_mul(t3, in16); // Compute z^6
    let t5 = circuit_mul(t4, in16); // Compute z^7
    let t6 = circuit_mul(t5, in16); // Compute z^8
    let t7 = circuit_mul(t6, in16); // Compute z^9
    let t8 = circuit_mul(t7, in16); // Compute z^10
    let t9 = circuit_mul(t8, in16); // Compute z^11
    let t10 = circuit_mul(t9, in16); // Compute z^12
    let t11 = circuit_mul(t10, in16); // Compute z^13
    let t12 = circuit_mul(t11, in16); // Compute z^14
    let t13 = circuit_mul(t12, in16); // Compute z^15
    let t14 = circuit_mul(t13, in16); // Compute z^16
    let t15 = circuit_mul(t14, in16); // Compute z^17
    let t16 = circuit_mul(t15, in16); // Compute z^18
    let t17 = circuit_mul(t16, in16); // Compute z^19
    let t18 = circuit_mul(t17, in16); // Compute z^20
    let t19 = circuit_mul(t18, in16); // Compute z^21
    let t20 = circuit_mul(t19, in16); // Compute z^22
    let t21 = circuit_mul(t20, in16); // Compute z^23
    let t22 = circuit_mul(t21, in16); // Compute z^24
    let t23 = circuit_mul(t22, in16); // Compute z^25
    let t24 = circuit_mul(t23, in16); // Compute z^26
    let t25 = circuit_mul(t24, in16); // Compute z^27
    let t26 = circuit_mul(t25, in16); // Compute z^28
    let t27 = circuit_mul(t26, in16); // Compute z^29
    let t28 = circuit_mul(t27, in16); // Compute z^30
    let t29 = circuit_mul(t28, in16); // Compute z^31
    let t30 = circuit_mul(t29, in16); // Compute z^32
    let t31 = circuit_mul(t30, in16); // Compute z^33
    let t32 = circuit_mul(t31, in16); // Compute z^34
    let t33 = circuit_mul(t32, in16); // Compute z^35
    let t34 = circuit_mul(t33, in16); // Compute z^36
    let t35 = circuit_mul(t34, in16); // Compute z^37
    let t36 = circuit_mul(t35, in16); // Compute z^38
    let t37 = circuit_mul(t36, in16); // Compute z^39
    let t38 = circuit_mul(t37, in16); // Compute z^40
    let t39 = circuit_mul(t38, in16); // Compute z^41
    let t40 = circuit_mul(t39, in16); // Compute z^42
    let t41 = circuit_mul(t40, in16); // Compute z^43
    let t42 = circuit_mul(t41, in16); // Compute z^44
    let t43 = circuit_mul(t42, in16); // Compute z^45
    let t44 = circuit_mul(t43, in16); // Compute z^46
    let t45 = circuit_mul(t44, in16); // Compute z^47
    let t46 = circuit_mul(t45, in16); // Compute z^48
    let t47 = circuit_mul(t46, in16); // Compute z^49
    let t48 = circuit_mul(t47, in16); // Compute z^50
    let t49 = circuit_mul(t48, in16); // Compute z^51
    let t50 = circuit_mul(t49, in16); // Compute z^52
    let t51 = circuit_mul(t50, in16); // Compute z^53
    let t52 = circuit_mul(t51, in16); // Compute z^54
    let t53 = circuit_mul(t52, in16); // Compute z^55
    let t54 = circuit_mul(t53, in16); // Compute z^56
    let t55 = circuit_mul(t54, in16); // Compute z^57
    let t56 = circuit_mul(t55, in16); // Compute z^58
    let t57 = circuit_mul(t56, in16); // Compute z^59
    let t58 = circuit_mul(t57, in16); // Compute z^60
    let t59 = circuit_mul(t58, in16); // Compute z^61
    let t60 = circuit_mul(t59, in16); // Compute z^62
    let t61 = circuit_mul(t60, in16); // Compute z^63
    let t62 = circuit_mul(t61, in16); // Compute z^64
    let t63 = circuit_mul(t62, in16); // Compute z^65
    let t64 = circuit_mul(t63, in16); // Compute z^66
    let t65 = circuit_mul(t64, in16); // Compute z^67
    let t66 = circuit_mul(t65, in16); // Compute z^68
    let t67 = circuit_mul(t66, in16); // Compute z^69
    let t68 = circuit_mul(t67, in16); // Compute z^70
    let t69 = circuit_mul(t68, in16); // Compute z^71
    let t70 = circuit_mul(t69, in16); // Compute z^72
    let t71 = circuit_mul(t70, in16); // Compute z^73
    let t72 = circuit_mul(t71, in16); // Compute z^74
    let t73 = circuit_mul(t72, in16); // Compute z^75
    let t74 = circuit_mul(t73, in16); // Compute z^76
    let t75 = circuit_mul(t74, in16); // Compute z^77
    let t76 = circuit_mul(t75, in16); // Compute z^78
    let t77 = circuit_mul(t76, in16); // Compute z^79
    let t78 = circuit_mul(t77, in16); // Compute z^80
    let t79 = circuit_mul(t78, in16); // Compute z^81
    let t80 = circuit_mul(t79, in16); // Compute z^82
    let t81 = circuit_mul(t80, in16); // Compute z^83
    let t82 = circuit_mul(t81, in16); // Compute z^84
    let t83 = circuit_mul(t82, in16); // Compute z^85
    let t84 = circuit_mul(t83, in16); // Compute z^86
    let t85 = circuit_mul(t84, in16); // Compute z^87
    let t86 = circuit_mul(t85, in16); // Compute z^88
    let t87 = circuit_mul(t86, in16); // Compute z^89
    let t88 = circuit_mul(t87, in16); // Compute z^90
    let t89 = circuit_mul(t88, in16); // Compute z^91
    let t90 = circuit_mul(t89, in16); // Compute z^92
    let t91 = circuit_mul(t90, in16); // Compute z^93
    let t92 = circuit_mul(t91, in16); // Compute z^94
    let t93 = circuit_mul(t92, in16); // Compute z^95
    let t94 = circuit_mul(t93, in16); // Compute z^96
    let t95 = circuit_mul(t94, in16); // Compute z^97
    let t96 = circuit_mul(t95, in16); // Compute z^98
    let t97 = circuit_mul(t96, in16); // Compute z^99
    let t98 = circuit_mul(t97, in16); // Compute z^100
    let t99 = circuit_mul(t98, in16); // Compute z^101
    let t100 = circuit_mul(t99, in16); // Compute z^102
    let t101 = circuit_mul(t100, in16); // Compute z^103
    let t102 = circuit_mul(t101, in16); // Compute z^104
    let t103 = circuit_mul(in14, in14);
    let t104 = circuit_mul(in3, in16); // Eval R_n_minus_1 step coeff_1 * z^1
    let t105 = circuit_add(in2, t104); // Eval R_n_minus_1 step + (coeff_1 * z^1)
    let t106 = circuit_mul(in4, t0); // Eval R_n_minus_1 step coeff_2 * z^2
    let t107 = circuit_add(t105, t106); // Eval R_n_minus_1 step + (coeff_2 * z^2)
    let t108 = circuit_mul(in5, t1); // Eval R_n_minus_1 step coeff_3 * z^3
    let t109 = circuit_add(t107, t108); // Eval R_n_minus_1 step + (coeff_3 * z^3)
    let t110 = circuit_mul(in6, t2); // Eval R_n_minus_1 step coeff_4 * z^4
    let t111 = circuit_add(t109, t110); // Eval R_n_minus_1 step + (coeff_4 * z^4)
    let t112 = circuit_mul(in7, t3); // Eval R_n_minus_1 step coeff_5 * z^5
    let t113 = circuit_add(t111, t112); // Eval R_n_minus_1 step + (coeff_5 * z^5)
    let t114 = circuit_mul(in8, t4); // Eval R_n_minus_1 step coeff_6 * z^6
    let t115 = circuit_add(t113, t114); // Eval R_n_minus_1 step + (coeff_6 * z^6)
    let t116 = circuit_mul(in9, t5); // Eval R_n_minus_1 step coeff_7 * z^7
    let t117 = circuit_add(t115, t116); // Eval R_n_minus_1 step + (coeff_7 * z^7)
    let t118 = circuit_mul(in10, t6); // Eval R_n_minus_1 step coeff_8 * z^8
    let t119 = circuit_add(t117, t118); // Eval R_n_minus_1 step + (coeff_8 * z^8)
    let t120 = circuit_mul(in11, t7); // Eval R_n_minus_1 step coeff_9 * z^9
    let t121 = circuit_add(t119, t120); // Eval R_n_minus_1 step + (coeff_9 * z^9)
    let t122 = circuit_mul(in12, t8); // Eval R_n_minus_1 step coeff_10 * z^10
    let t123 = circuit_add(t121, t122); // Eval R_n_minus_1 step + (coeff_10 * z^10)
    let t124 = circuit_mul(in13, t9); // Eval R_n_minus_1 step coeff_11 * z^11
    let t125 = circuit_add(t123, t124); // Eval R_n_minus_1 step + (coeff_11 * z^11)
    let t126 = circuit_mul(in19, in17);
    let t127 = circuit_mul(t126, in15);
    let t128 = circuit_sub(t127, t125);
    let t129 = circuit_mul(t103, t128); // c_n_minus_1 * ((Π(n-1,k) (Pk(z)) - R_n_minus_1(z))
    let t130 = circuit_add(in18, t129); // previous_lhs + lhs_n_minus_1
    let t131 = circuit_mul(in1, t4); // Eval sparse poly P_irr step coeff_6 * z^6
    let t132 = circuit_add(in0, t131); // Eval sparse poly P_irr step + coeff_6 * z^6
    let t133 = circuit_add(t132, t10); // Eval sparse poly P_irr step + 1*z^12
    let t134 = circuit_mul(in21, in16); // Eval big_Q step coeff_1 * z^1
    let t135 = circuit_add(in20, t134); // Eval big_Q step + (coeff_1 * z^1)
    let t136 = circuit_mul(in22, t0); // Eval big_Q step coeff_2 * z^2
    let t137 = circuit_add(t135, t136); // Eval big_Q step + (coeff_2 * z^2)
    let t138 = circuit_mul(in23, t1); // Eval big_Q step coeff_3 * z^3
    let t139 = circuit_add(t137, t138); // Eval big_Q step + (coeff_3 * z^3)
    let t140 = circuit_mul(in24, t2); // Eval big_Q step coeff_4 * z^4
    let t141 = circuit_add(t139, t140); // Eval big_Q step + (coeff_4 * z^4)
    let t142 = circuit_mul(in25, t3); // Eval big_Q step coeff_5 * z^5
    let t143 = circuit_add(t141, t142); // Eval big_Q step + (coeff_5 * z^5)
    let t144 = circuit_mul(in26, t4); // Eval big_Q step coeff_6 * z^6
    let t145 = circuit_add(t143, t144); // Eval big_Q step + (coeff_6 * z^6)
    let t146 = circuit_mul(in27, t5); // Eval big_Q step coeff_7 * z^7
    let t147 = circuit_add(t145, t146); // Eval big_Q step + (coeff_7 * z^7)
    let t148 = circuit_mul(in28, t6); // Eval big_Q step coeff_8 * z^8
    let t149 = circuit_add(t147, t148); // Eval big_Q step + (coeff_8 * z^8)
    let t150 = circuit_mul(in29, t7); // Eval big_Q step coeff_9 * z^9
    let t151 = circuit_add(t149, t150); // Eval big_Q step + (coeff_9 * z^9)
    let t152 = circuit_mul(in30, t8); // Eval big_Q step coeff_10 * z^10
    let t153 = circuit_add(t151, t152); // Eval big_Q step + (coeff_10 * z^10)
    let t154 = circuit_mul(in31, t9); // Eval big_Q step coeff_11 * z^11
    let t155 = circuit_add(t153, t154); // Eval big_Q step + (coeff_11 * z^11)
    let t156 = circuit_mul(in32, t10); // Eval big_Q step coeff_12 * z^12
    let t157 = circuit_add(t155, t156); // Eval big_Q step + (coeff_12 * z^12)
    let t158 = circuit_mul(in33, t11); // Eval big_Q step coeff_13 * z^13
    let t159 = circuit_add(t157, t158); // Eval big_Q step + (coeff_13 * z^13)
    let t160 = circuit_mul(in34, t12); // Eval big_Q step coeff_14 * z^14
    let t161 = circuit_add(t159, t160); // Eval big_Q step + (coeff_14 * z^14)
    let t162 = circuit_mul(in35, t13); // Eval big_Q step coeff_15 * z^15
    let t163 = circuit_add(t161, t162); // Eval big_Q step + (coeff_15 * z^15)
    let t164 = circuit_mul(in36, t14); // Eval big_Q step coeff_16 * z^16
    let t165 = circuit_add(t163, t164); // Eval big_Q step + (coeff_16 * z^16)
    let t166 = circuit_mul(in37, t15); // Eval big_Q step coeff_17 * z^17
    let t167 = circuit_add(t165, t166); // Eval big_Q step + (coeff_17 * z^17)
    let t168 = circuit_mul(in38, t16); // Eval big_Q step coeff_18 * z^18
    let t169 = circuit_add(t167, t168); // Eval big_Q step + (coeff_18 * z^18)
    let t170 = circuit_mul(in39, t17); // Eval big_Q step coeff_19 * z^19
    let t171 = circuit_add(t169, t170); // Eval big_Q step + (coeff_19 * z^19)
    let t172 = circuit_mul(in40, t18); // Eval big_Q step coeff_20 * z^20
    let t173 = circuit_add(t171, t172); // Eval big_Q step + (coeff_20 * z^20)
    let t174 = circuit_mul(in41, t19); // Eval big_Q step coeff_21 * z^21
    let t175 = circuit_add(t173, t174); // Eval big_Q step + (coeff_21 * z^21)
    let t176 = circuit_mul(in42, t20); // Eval big_Q step coeff_22 * z^22
    let t177 = circuit_add(t175, t176); // Eval big_Q step + (coeff_22 * z^22)
    let t178 = circuit_mul(in43, t21); // Eval big_Q step coeff_23 * z^23
    let t179 = circuit_add(t177, t178); // Eval big_Q step + (coeff_23 * z^23)
    let t180 = circuit_mul(in44, t22); // Eval big_Q step coeff_24 * z^24
    let t181 = circuit_add(t179, t180); // Eval big_Q step + (coeff_24 * z^24)
    let t182 = circuit_mul(in45, t23); // Eval big_Q step coeff_25 * z^25
    let t183 = circuit_add(t181, t182); // Eval big_Q step + (coeff_25 * z^25)
    let t184 = circuit_mul(in46, t24); // Eval big_Q step coeff_26 * z^26
    let t185 = circuit_add(t183, t184); // Eval big_Q step + (coeff_26 * z^26)
    let t186 = circuit_mul(in47, t25); // Eval big_Q step coeff_27 * z^27
    let t187 = circuit_add(t185, t186); // Eval big_Q step + (coeff_27 * z^27)
    let t188 = circuit_mul(in48, t26); // Eval big_Q step coeff_28 * z^28
    let t189 = circuit_add(t187, t188); // Eval big_Q step + (coeff_28 * z^28)
    let t190 = circuit_mul(in49, t27); // Eval big_Q step coeff_29 * z^29
    let t191 = circuit_add(t189, t190); // Eval big_Q step + (coeff_29 * z^29)
    let t192 = circuit_mul(in50, t28); // Eval big_Q step coeff_30 * z^30
    let t193 = circuit_add(t191, t192); // Eval big_Q step + (coeff_30 * z^30)
    let t194 = circuit_mul(in51, t29); // Eval big_Q step coeff_31 * z^31
    let t195 = circuit_add(t193, t194); // Eval big_Q step + (coeff_31 * z^31)
    let t196 = circuit_mul(in52, t30); // Eval big_Q step coeff_32 * z^32
    let t197 = circuit_add(t195, t196); // Eval big_Q step + (coeff_32 * z^32)
    let t198 = circuit_mul(in53, t31); // Eval big_Q step coeff_33 * z^33
    let t199 = circuit_add(t197, t198); // Eval big_Q step + (coeff_33 * z^33)
    let t200 = circuit_mul(in54, t32); // Eval big_Q step coeff_34 * z^34
    let t201 = circuit_add(t199, t200); // Eval big_Q step + (coeff_34 * z^34)
    let t202 = circuit_mul(in55, t33); // Eval big_Q step coeff_35 * z^35
    let t203 = circuit_add(t201, t202); // Eval big_Q step + (coeff_35 * z^35)
    let t204 = circuit_mul(in56, t34); // Eval big_Q step coeff_36 * z^36
    let t205 = circuit_add(t203, t204); // Eval big_Q step + (coeff_36 * z^36)
    let t206 = circuit_mul(in57, t35); // Eval big_Q step coeff_37 * z^37
    let t207 = circuit_add(t205, t206); // Eval big_Q step + (coeff_37 * z^37)
    let t208 = circuit_mul(in58, t36); // Eval big_Q step coeff_38 * z^38
    let t209 = circuit_add(t207, t208); // Eval big_Q step + (coeff_38 * z^38)
    let t210 = circuit_mul(in59, t37); // Eval big_Q step coeff_39 * z^39
    let t211 = circuit_add(t209, t210); // Eval big_Q step + (coeff_39 * z^39)
    let t212 = circuit_mul(in60, t38); // Eval big_Q step coeff_40 * z^40
    let t213 = circuit_add(t211, t212); // Eval big_Q step + (coeff_40 * z^40)
    let t214 = circuit_mul(in61, t39); // Eval big_Q step coeff_41 * z^41
    let t215 = circuit_add(t213, t214); // Eval big_Q step + (coeff_41 * z^41)
    let t216 = circuit_mul(in62, t40); // Eval big_Q step coeff_42 * z^42
    let t217 = circuit_add(t215, t216); // Eval big_Q step + (coeff_42 * z^42)
    let t218 = circuit_mul(in63, t41); // Eval big_Q step coeff_43 * z^43
    let t219 = circuit_add(t217, t218); // Eval big_Q step + (coeff_43 * z^43)
    let t220 = circuit_mul(in64, t42); // Eval big_Q step coeff_44 * z^44
    let t221 = circuit_add(t219, t220); // Eval big_Q step + (coeff_44 * z^44)
    let t222 = circuit_mul(in65, t43); // Eval big_Q step coeff_45 * z^45
    let t223 = circuit_add(t221, t222); // Eval big_Q step + (coeff_45 * z^45)
    let t224 = circuit_mul(in66, t44); // Eval big_Q step coeff_46 * z^46
    let t225 = circuit_add(t223, t224); // Eval big_Q step + (coeff_46 * z^46)
    let t226 = circuit_mul(in67, t45); // Eval big_Q step coeff_47 * z^47
    let t227 = circuit_add(t225, t226); // Eval big_Q step + (coeff_47 * z^47)
    let t228 = circuit_mul(in68, t46); // Eval big_Q step coeff_48 * z^48
    let t229 = circuit_add(t227, t228); // Eval big_Q step + (coeff_48 * z^48)
    let t230 = circuit_mul(in69, t47); // Eval big_Q step coeff_49 * z^49
    let t231 = circuit_add(t229, t230); // Eval big_Q step + (coeff_49 * z^49)
    let t232 = circuit_mul(in70, t48); // Eval big_Q step coeff_50 * z^50
    let t233 = circuit_add(t231, t232); // Eval big_Q step + (coeff_50 * z^50)
    let t234 = circuit_mul(in71, t49); // Eval big_Q step coeff_51 * z^51
    let t235 = circuit_add(t233, t234); // Eval big_Q step + (coeff_51 * z^51)
    let t236 = circuit_mul(in72, t50); // Eval big_Q step coeff_52 * z^52
    let t237 = circuit_add(t235, t236); // Eval big_Q step + (coeff_52 * z^52)
    let t238 = circuit_mul(in73, t51); // Eval big_Q step coeff_53 * z^53
    let t239 = circuit_add(t237, t238); // Eval big_Q step + (coeff_53 * z^53)
    let t240 = circuit_mul(in74, t52); // Eval big_Q step coeff_54 * z^54
    let t241 = circuit_add(t239, t240); // Eval big_Q step + (coeff_54 * z^54)
    let t242 = circuit_mul(in75, t53); // Eval big_Q step coeff_55 * z^55
    let t243 = circuit_add(t241, t242); // Eval big_Q step + (coeff_55 * z^55)
    let t244 = circuit_mul(in76, t54); // Eval big_Q step coeff_56 * z^56
    let t245 = circuit_add(t243, t244); // Eval big_Q step + (coeff_56 * z^56)
    let t246 = circuit_mul(in77, t55); // Eval big_Q step coeff_57 * z^57
    let t247 = circuit_add(t245, t246); // Eval big_Q step + (coeff_57 * z^57)
    let t248 = circuit_mul(in78, t56); // Eval big_Q step coeff_58 * z^58
    let t249 = circuit_add(t247, t248); // Eval big_Q step + (coeff_58 * z^58)
    let t250 = circuit_mul(in79, t57); // Eval big_Q step coeff_59 * z^59
    let t251 = circuit_add(t249, t250); // Eval big_Q step + (coeff_59 * z^59)
    let t252 = circuit_mul(in80, t58); // Eval big_Q step coeff_60 * z^60
    let t253 = circuit_add(t251, t252); // Eval big_Q step + (coeff_60 * z^60)
    let t254 = circuit_mul(in81, t59); // Eval big_Q step coeff_61 * z^61
    let t255 = circuit_add(t253, t254); // Eval big_Q step + (coeff_61 * z^61)
    let t256 = circuit_mul(in82, t60); // Eval big_Q step coeff_62 * z^62
    let t257 = circuit_add(t255, t256); // Eval big_Q step + (coeff_62 * z^62)
    let t258 = circuit_mul(in83, t61); // Eval big_Q step coeff_63 * z^63
    let t259 = circuit_add(t257, t258); // Eval big_Q step + (coeff_63 * z^63)
    let t260 = circuit_mul(in84, t62); // Eval big_Q step coeff_64 * z^64
    let t261 = circuit_add(t259, t260); // Eval big_Q step + (coeff_64 * z^64)
    let t262 = circuit_mul(in85, t63); // Eval big_Q step coeff_65 * z^65
    let t263 = circuit_add(t261, t262); // Eval big_Q step + (coeff_65 * z^65)
    let t264 = circuit_mul(in86, t64); // Eval big_Q step coeff_66 * z^66
    let t265 = circuit_add(t263, t264); // Eval big_Q step + (coeff_66 * z^66)
    let t266 = circuit_mul(in87, t65); // Eval big_Q step coeff_67 * z^67
    let t267 = circuit_add(t265, t266); // Eval big_Q step + (coeff_67 * z^67)
    let t268 = circuit_mul(in88, t66); // Eval big_Q step coeff_68 * z^68
    let t269 = circuit_add(t267, t268); // Eval big_Q step + (coeff_68 * z^68)
    let t270 = circuit_mul(in89, t67); // Eval big_Q step coeff_69 * z^69
    let t271 = circuit_add(t269, t270); // Eval big_Q step + (coeff_69 * z^69)
    let t272 = circuit_mul(in90, t68); // Eval big_Q step coeff_70 * z^70
    let t273 = circuit_add(t271, t272); // Eval big_Q step + (coeff_70 * z^70)
    let t274 = circuit_mul(in91, t69); // Eval big_Q step coeff_71 * z^71
    let t275 = circuit_add(t273, t274); // Eval big_Q step + (coeff_71 * z^71)
    let t276 = circuit_mul(in92, t70); // Eval big_Q step coeff_72 * z^72
    let t277 = circuit_add(t275, t276); // Eval big_Q step + (coeff_72 * z^72)
    let t278 = circuit_mul(in93, t71); // Eval big_Q step coeff_73 * z^73
    let t279 = circuit_add(t277, t278); // Eval big_Q step + (coeff_73 * z^73)
    let t280 = circuit_mul(in94, t72); // Eval big_Q step coeff_74 * z^74
    let t281 = circuit_add(t279, t280); // Eval big_Q step + (coeff_74 * z^74)
    let t282 = circuit_mul(in95, t73); // Eval big_Q step coeff_75 * z^75
    let t283 = circuit_add(t281, t282); // Eval big_Q step + (coeff_75 * z^75)
    let t284 = circuit_mul(in96, t74); // Eval big_Q step coeff_76 * z^76
    let t285 = circuit_add(t283, t284); // Eval big_Q step + (coeff_76 * z^76)
    let t286 = circuit_mul(in97, t75); // Eval big_Q step coeff_77 * z^77
    let t287 = circuit_add(t285, t286); // Eval big_Q step + (coeff_77 * z^77)
    let t288 = circuit_mul(in98, t76); // Eval big_Q step coeff_78 * z^78
    let t289 = circuit_add(t287, t288); // Eval big_Q step + (coeff_78 * z^78)
    let t290 = circuit_mul(in99, t77); // Eval big_Q step coeff_79 * z^79
    let t291 = circuit_add(t289, t290); // Eval big_Q step + (coeff_79 * z^79)
    let t292 = circuit_mul(in100, t78); // Eval big_Q step coeff_80 * z^80
    let t293 = circuit_add(t291, t292); // Eval big_Q step + (coeff_80 * z^80)
    let t294 = circuit_mul(in101, t79); // Eval big_Q step coeff_81 * z^81
    let t295 = circuit_add(t293, t294); // Eval big_Q step + (coeff_81 * z^81)
    let t296 = circuit_mul(in102, t80); // Eval big_Q step coeff_82 * z^82
    let t297 = circuit_add(t295, t296); // Eval big_Q step + (coeff_82 * z^82)
    let t298 = circuit_mul(in103, t81); // Eval big_Q step coeff_83 * z^83
    let t299 = circuit_add(t297, t298); // Eval big_Q step + (coeff_83 * z^83)
    let t300 = circuit_mul(in104, t82); // Eval big_Q step coeff_84 * z^84
    let t301 = circuit_add(t299, t300); // Eval big_Q step + (coeff_84 * z^84)
    let t302 = circuit_mul(in105, t83); // Eval big_Q step coeff_85 * z^85
    let t303 = circuit_add(t301, t302); // Eval big_Q step + (coeff_85 * z^85)
    let t304 = circuit_mul(in106, t84); // Eval big_Q step coeff_86 * z^86
    let t305 = circuit_add(t303, t304); // Eval big_Q step + (coeff_86 * z^86)
    let t306 = circuit_mul(in107, t85); // Eval big_Q step coeff_87 * z^87
    let t307 = circuit_add(t305, t306); // Eval big_Q step + (coeff_87 * z^87)
    let t308 = circuit_mul(in108, t86); // Eval big_Q step coeff_88 * z^88
    let t309 = circuit_add(t307, t308); // Eval big_Q step + (coeff_88 * z^88)
    let t310 = circuit_mul(in109, t87); // Eval big_Q step coeff_89 * z^89
    let t311 = circuit_add(t309, t310); // Eval big_Q step + (coeff_89 * z^89)
    let t312 = circuit_mul(in110, t88); // Eval big_Q step coeff_90 * z^90
    let t313 = circuit_add(t311, t312); // Eval big_Q step + (coeff_90 * z^90)
    let t314 = circuit_mul(in111, t89); // Eval big_Q step coeff_91 * z^91
    let t315 = circuit_add(t313, t314); // Eval big_Q step + (coeff_91 * z^91)
    let t316 = circuit_mul(in112, t90); // Eval big_Q step coeff_92 * z^92
    let t317 = circuit_add(t315, t316); // Eval big_Q step + (coeff_92 * z^92)
    let t318 = circuit_mul(in113, t91); // Eval big_Q step coeff_93 * z^93
    let t319 = circuit_add(t317, t318); // Eval big_Q step + (coeff_93 * z^93)
    let t320 = circuit_mul(in114, t92); // Eval big_Q step coeff_94 * z^94
    let t321 = circuit_add(t319, t320); // Eval big_Q step + (coeff_94 * z^94)
    let t322 = circuit_mul(in115, t93); // Eval big_Q step coeff_95 * z^95
    let t323 = circuit_add(t321, t322); // Eval big_Q step + (coeff_95 * z^95)
    let t324 = circuit_mul(in116, t94); // Eval big_Q step coeff_96 * z^96
    let t325 = circuit_add(t323, t324); // Eval big_Q step + (coeff_96 * z^96)
    let t326 = circuit_mul(in117, t95); // Eval big_Q step coeff_97 * z^97
    let t327 = circuit_add(t325, t326); // Eval big_Q step + (coeff_97 * z^97)
    let t328 = circuit_mul(in118, t96); // Eval big_Q step coeff_98 * z^98
    let t329 = circuit_add(t327, t328); // Eval big_Q step + (coeff_98 * z^98)
    let t330 = circuit_mul(in119, t97); // Eval big_Q step coeff_99 * z^99
    let t331 = circuit_add(t329, t330); // Eval big_Q step + (coeff_99 * z^99)
    let t332 = circuit_mul(in120, t98); // Eval big_Q step coeff_100 * z^100
    let t333 = circuit_add(t331, t332); // Eval big_Q step + (coeff_100 * z^100)
    let t334 = circuit_mul(in121, t99); // Eval big_Q step coeff_101 * z^101
    let t335 = circuit_add(t333, t334); // Eval big_Q step + (coeff_101 * z^101)
    let t336 = circuit_mul(in122, t100); // Eval big_Q step coeff_102 * z^102
    let t337 = circuit_add(t335, t336); // Eval big_Q step + (coeff_102 * z^102)
    let t338 = circuit_mul(in123, t101); // Eval big_Q step coeff_103 * z^103
    let t339 = circuit_add(t337, t338); // Eval big_Q step + (coeff_103 * z^103)
    let t340 = circuit_mul(in124, t102); // Eval big_Q step coeff_104 * z^104
    let t341 = circuit_add(t339, t340); // Eval big_Q step + (coeff_104 * z^104)
    let t342 = circuit_mul(t341, t133); // Q(z) * P(z)
    let t343 = circuit_sub(t130, t342); // final_lhs - Q(z) * P(z)

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

    let mut circuit_inputs = (t343,).new_inputs();
    // Prefill constants:
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
    let final_check: u384 = outputs.get_output(t343);
    return (final_check,);
}
fn run_BLS12_381_GROTH16_INIT_BIT_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    G2_line_0: G2Line,
    G2_line_0_2: G2Line,
    yInv_1: u384,
    xNegOverY_1: u384,
    G2_line_1: G2Line,
    G2_line_1_2: G2Line,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q_2: G2Point,
    R_i: E12D,
    c0: u384,
    z: u384,
    c_inv_of_z: u384
) -> (G2Point, u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x3
    let in1 = CE::<CI<1>> {}; // 0x6
    let in2 = CE::<CI<2>> {}; // 0x0

    // INPUT stack
    let (in3, in4) = (CE::<CI<3>> {}, CE::<CI<4>> {});
    let (in5, in6) = (CE::<CI<5>> {}, CE::<CI<6>> {});
    let (in7, in8) = (CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10) = (CE::<CI<9>> {}, CE::<CI<10>> {});
    let (in11, in12) = (CE::<CI<11>> {}, CE::<CI<12>> {});
    let (in13, in14) = (CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16) = (CE::<CI<15>> {}, CE::<CI<16>> {});
    let (in17, in18) = (CE::<CI<17>> {}, CE::<CI<18>> {});
    let (in19, in20) = (CE::<CI<19>> {}, CE::<CI<20>> {});
    let (in21, in22) = (CE::<CI<21>> {}, CE::<CI<22>> {});
    let (in23, in24) = (CE::<CI<23>> {}, CE::<CI<24>> {});
    let (in25, in26) = (CE::<CI<25>> {}, CE::<CI<26>> {});
    let (in27, in28) = (CE::<CI<27>> {}, CE::<CI<28>> {});
    let (in29, in30) = (CE::<CI<29>> {}, CE::<CI<30>> {});
    let (in31, in32) = (CE::<CI<31>> {}, CE::<CI<32>> {});
    let (in33, in34) = (CE::<CI<33>> {}, CE::<CI<34>> {});
    let (in35, in36) = (CE::<CI<35>> {}, CE::<CI<36>> {});
    let (in37, in38) = (CE::<CI<37>> {}, CE::<CI<38>> {});
    let (in39, in40) = (CE::<CI<39>> {}, CE::<CI<40>> {});
    let (in41, in42) = (CE::<CI<41>> {}, CE::<CI<42>> {});
    let in43 = CE::<CI<43>> {};
    let t0 = circuit_mul(in42, in42); // Compute z^2
    let t1 = circuit_mul(t0, in42); // Compute z^3
    let t2 = circuit_mul(t1, in42); // Compute z^4
    let t3 = circuit_mul(t2, in42); // Compute z^5
    let t4 = circuit_mul(t3, in42); // Compute z^6
    let t5 = circuit_mul(t4, in42); // Compute z^7
    let t6 = circuit_mul(t5, in42); // Compute z^8
    let t7 = circuit_mul(t6, in42); // Compute z^9
    let t8 = circuit_mul(t7, in42); // Compute z^10
    let t9 = circuit_mul(t8, in42); // Compute z^11
    let t10 = circuit_mul(in30, in42); // Eval R step coeff_1 * z^1
    let t11 = circuit_add(in29, t10); // Eval R step + (coeff_1 * z^1)
    let t12 = circuit_mul(in31, t0); // Eval R step coeff_2 * z^2
    let t13 = circuit_add(t11, t12); // Eval R step + (coeff_2 * z^2)
    let t14 = circuit_mul(in32, t1); // Eval R step coeff_3 * z^3
    let t15 = circuit_add(t13, t14); // Eval R step + (coeff_3 * z^3)
    let t16 = circuit_mul(in33, t2); // Eval R step coeff_4 * z^4
    let t17 = circuit_add(t15, t16); // Eval R step + (coeff_4 * z^4)
    let t18 = circuit_mul(in34, t3); // Eval R step coeff_5 * z^5
    let t19 = circuit_add(t17, t18); // Eval R step + (coeff_5 * z^5)
    let t20 = circuit_mul(in35, t4); // Eval R step coeff_6 * z^6
    let t21 = circuit_add(t19, t20); // Eval R step + (coeff_6 * z^6)
    let t22 = circuit_mul(in36, t5); // Eval R step coeff_7 * z^7
    let t23 = circuit_add(t21, t22); // Eval R step + (coeff_7 * z^7)
    let t24 = circuit_mul(in37, t6); // Eval R step coeff_8 * z^8
    let t25 = circuit_add(t23, t24); // Eval R step + (coeff_8 * z^8)
    let t26 = circuit_mul(in38, t7); // Eval R step coeff_9 * z^9
    let t27 = circuit_add(t25, t26); // Eval R step + (coeff_9 * z^9)
    let t28 = circuit_mul(in39, t8); // Eval R step coeff_10 * z^10
    let t29 = circuit_add(t27, t28); // Eval R step + (coeff_10 * z^10)
    let t30 = circuit_mul(in40, t9); // Eval R step coeff_11 * z^11
    let t31 = circuit_add(t29, t30); // Eval R step + (coeff_11 * z^11)
    let t32 = circuit_mul(in43, in43);
    let t33 = circuit_mul(in43, t32);
    let t34 = circuit_sub(in7, in8);
    let t35 = circuit_mul(t34, in3);
    let t36 = circuit_sub(in5, in6);
    let t37 = circuit_mul(t36, in4);
    let t38 = circuit_mul(in8, in3);
    let t39 = circuit_mul(in6, in4);
    let t40 = circuit_sub(in11, in12);
    let t41 = circuit_mul(t40, in3);
    let t42 = circuit_sub(in9, in10);
    let t43 = circuit_mul(t42, in4);
    let t44 = circuit_mul(in12, in3);
    let t45 = circuit_mul(in10, in4);
    let t46 = circuit_mul(t37, t0); // Eval sparse poly line_0p_1 step coeff_2 * z^2
    let t47 = circuit_add(t35, t46); // Eval sparse poly line_0p_1 step + coeff_2 * z^2
    let t48 = circuit_add(t47, t1); // Eval sparse poly line_0p_1 step + 1*z^3
    let t49 = circuit_mul(t38, t4); // Eval sparse poly line_0p_1 step coeff_6 * z^6
    let t50 = circuit_add(t48, t49); // Eval sparse poly line_0p_1 step + coeff_6 * z^6
    let t51 = circuit_mul(t39, t6); // Eval sparse poly line_0p_1 step coeff_8 * z^8
    let t52 = circuit_add(t50, t51); // Eval sparse poly line_0p_1 step + coeff_8 * z^8
    let t53 = circuit_mul(t33, t52);
    let t54 = circuit_mul(t43, t0); // Eval sparse poly line_0p_2 step coeff_2 * z^2
    let t55 = circuit_add(t41, t54); // Eval sparse poly line_0p_2 step + coeff_2 * z^2
    let t56 = circuit_add(t55, t1); // Eval sparse poly line_0p_2 step + 1*z^3
    let t57 = circuit_mul(t44, t4); // Eval sparse poly line_0p_2 step coeff_6 * z^6
    let t58 = circuit_add(t56, t57); // Eval sparse poly line_0p_2 step + coeff_6 * z^6
    let t59 = circuit_mul(t45, t6); // Eval sparse poly line_0p_2 step coeff_8 * z^8
    let t60 = circuit_add(t58, t59); // Eval sparse poly line_0p_2 step + coeff_8 * z^8
    let t61 = circuit_mul(t53, t60);
    let t62 = circuit_sub(in17, in18);
    let t63 = circuit_mul(t62, in13);
    let t64 = circuit_sub(in15, in16);
    let t65 = circuit_mul(t64, in14);
    let t66 = circuit_mul(in18, in13);
    let t67 = circuit_mul(in16, in14);
    let t68 = circuit_sub(in21, in22);
    let t69 = circuit_mul(t68, in13);
    let t70 = circuit_sub(in19, in20);
    let t71 = circuit_mul(t70, in14);
    let t72 = circuit_mul(in22, in13);
    let t73 = circuit_mul(in20, in14);
    let t74 = circuit_mul(t65, t0); // Eval sparse poly line_1p_1 step coeff_2 * z^2
    let t75 = circuit_add(t63, t74); // Eval sparse poly line_1p_1 step + coeff_2 * z^2
    let t76 = circuit_add(t75, t1); // Eval sparse poly line_1p_1 step + 1*z^3
    let t77 = circuit_mul(t66, t4); // Eval sparse poly line_1p_1 step coeff_6 * z^6
    let t78 = circuit_add(t76, t77); // Eval sparse poly line_1p_1 step + coeff_6 * z^6
    let t79 = circuit_mul(t67, t6); // Eval sparse poly line_1p_1 step coeff_8 * z^8
    let t80 = circuit_add(t78, t79); // Eval sparse poly line_1p_1 step + coeff_8 * z^8
    let t81 = circuit_mul(t61, t80);
    let t82 = circuit_mul(t71, t0); // Eval sparse poly line_1p_2 step coeff_2 * z^2
    let t83 = circuit_add(t69, t82); // Eval sparse poly line_1p_2 step + coeff_2 * z^2
    let t84 = circuit_add(t83, t1); // Eval sparse poly line_1p_2 step + 1*z^3
    let t85 = circuit_mul(t72, t4); // Eval sparse poly line_1p_2 step coeff_6 * z^6
    let t86 = circuit_add(t84, t85); // Eval sparse poly line_1p_2 step + coeff_6 * z^6
    let t87 = circuit_mul(t73, t6); // Eval sparse poly line_1p_2 step coeff_8 * z^8
    let t88 = circuit_add(t86, t87); // Eval sparse poly line_1p_2 step + coeff_8 * z^8
    let t89 = circuit_mul(t81, t88);
    let t90 = circuit_add(in25, in26);
    let t91 = circuit_sub(in25, in26);
    let t92 = circuit_mul(t90, t91);
    let t93 = circuit_mul(in25, in26);
    let t94 = circuit_mul(t92, in0);
    let t95 = circuit_mul(t93, in1);
    let t96 = circuit_add(in27, in27); // Fp2 add coeff 0/1
    let t97 = circuit_add(in28, in28); // Fp2 add coeff 1/1
    let t98 = circuit_mul(t96, t96); // Fp2 Div x/y start : Fp2 Inv y start
    let t99 = circuit_mul(t97, t97);
    let t100 = circuit_add(t98, t99);
    let t101 = circuit_inverse(t100);
    let t102 = circuit_mul(t96, t101); // Fp2 Inv y real part end
    let t103 = circuit_mul(t97, t101);
    let t104 = circuit_sub(in2, t103); // Fp2 Inv y imag part end
    let t105 = circuit_mul(t94, t102); // Fp2 mul start
    let t106 = circuit_mul(t95, t104);
    let t107 = circuit_sub(t105, t106); // Fp2 mul real part end
    let t108 = circuit_mul(t94, t104);
    let t109 = circuit_mul(t95, t102);
    let t110 = circuit_add(t108, t109); // Fp2 mul imag part end
    let t111 = circuit_mul(t107, in25); // Fp2 mul start
    let t112 = circuit_mul(t110, in26);
    let t113 = circuit_sub(t111, t112); // Fp2 mul real part end
    let t114 = circuit_mul(t107, in26);
    let t115 = circuit_mul(t110, in25);
    let t116 = circuit_add(t114, t115); // Fp2 mul imag part end
    let t117 = circuit_sub(t113, in27); // Fp2 sub coeff 0/1
    let t118 = circuit_sub(t116, in28); // Fp2 sub coeff 1/1
    let t119 = circuit_add(t107, t110);
    let t120 = circuit_sub(t107, t110);
    let t121 = circuit_mul(t119, t120);
    let t122 = circuit_mul(t107, t110);
    let t123 = circuit_add(t122, t122);
    let t124 = circuit_add(in25, in25); // Fp2 add coeff 0/1
    let t125 = circuit_add(in26, in26); // Fp2 add coeff 1/1
    let t126 = circuit_sub(t121, t124); // Fp2 sub coeff 0/1
    let t127 = circuit_sub(t123, t125); // Fp2 sub coeff 1/1
    let t128 = circuit_sub(in25, t126); // Fp2 sub coeff 0/1
    let t129 = circuit_sub(in26, t127); // Fp2 sub coeff 1/1
    let t130 = circuit_mul(t128, t128); // Fp2 Div x/y start : Fp2 Inv y start
    let t131 = circuit_mul(t129, t129);
    let t132 = circuit_add(t130, t131);
    let t133 = circuit_inverse(t132);
    let t134 = circuit_mul(t128, t133); // Fp2 Inv y real part end
    let t135 = circuit_mul(t129, t133);
    let t136 = circuit_sub(in2, t135); // Fp2 Inv y imag part end
    let t137 = circuit_mul(t96, t134); // Fp2 mul start
    let t138 = circuit_mul(t97, t136);
    let t139 = circuit_sub(t137, t138); // Fp2 mul real part end
    let t140 = circuit_mul(t96, t136);
    let t141 = circuit_mul(t97, t134);
    let t142 = circuit_add(t140, t141); // Fp2 mul imag part end
    let t143 = circuit_sub(t139, t107); // Fp2 sub coeff 0/1
    let t144 = circuit_sub(t142, t110); // Fp2 sub coeff 1/1
    let t145 = circuit_mul(t143, in25); // Fp2 mul start
    let t146 = circuit_mul(t144, in26);
    let t147 = circuit_sub(t145, t146); // Fp2 mul real part end
    let t148 = circuit_mul(t143, in26);
    let t149 = circuit_mul(t144, in25);
    let t150 = circuit_add(t148, t149); // Fp2 mul imag part end
    let t151 = circuit_sub(t147, in27); // Fp2 sub coeff 0/1
    let t152 = circuit_sub(t150, in28); // Fp2 sub coeff 1/1
    let t153 = circuit_add(t143, t144);
    let t154 = circuit_sub(t143, t144);
    let t155 = circuit_mul(t153, t154);
    let t156 = circuit_mul(t143, t144);
    let t157 = circuit_add(t156, t156);
    let t158 = circuit_add(in25, t126); // Fp2 add coeff 0/1
    let t159 = circuit_add(in26, t127); // Fp2 add coeff 1/1
    let t160 = circuit_sub(t155, t158); // Fp2 sub coeff 0/1
    let t161 = circuit_sub(t157, t159); // Fp2 sub coeff 1/1
    let t162 = circuit_sub(in25, t160); // Fp2 sub coeff 0/1
    let t163 = circuit_sub(in26, t161); // Fp2 sub coeff 1/1
    let t164 = circuit_mul(t143, t162); // Fp2 mul start
    let t165 = circuit_mul(t144, t163);
    let t166 = circuit_sub(t164, t165); // Fp2 mul real part end
    let t167 = circuit_mul(t143, t163);
    let t168 = circuit_mul(t144, t162);
    let t169 = circuit_add(t167, t168); // Fp2 mul imag part end
    let t170 = circuit_sub(t166, in27); // Fp2 sub coeff 0/1
    let t171 = circuit_sub(t169, in28); // Fp2 sub coeff 1/1
    let t172 = circuit_sub(t117, t118);
    let t173 = circuit_mul(t172, in23);
    let t174 = circuit_sub(t107, t110);
    let t175 = circuit_mul(t174, in24);
    let t176 = circuit_mul(t118, in23);
    let t177 = circuit_mul(t110, in24);
    let t178 = circuit_sub(t151, t152);
    let t179 = circuit_mul(t178, in23);
    let t180 = circuit_sub(t143, t144);
    let t181 = circuit_mul(t180, in24);
    let t182 = circuit_mul(t152, in23);
    let t183 = circuit_mul(t144, in24);
    let t184 = circuit_mul(t175, t0); // Eval sparse poly line_2p_1 step coeff_2 * z^2
    let t185 = circuit_add(t173, t184); // Eval sparse poly line_2p_1 step + coeff_2 * z^2
    let t186 = circuit_add(t185, t1); // Eval sparse poly line_2p_1 step + 1*z^3
    let t187 = circuit_mul(t176, t4); // Eval sparse poly line_2p_1 step coeff_6 * z^6
    let t188 = circuit_add(t186, t187); // Eval sparse poly line_2p_1 step + coeff_6 * z^6
    let t189 = circuit_mul(t177, t6); // Eval sparse poly line_2p_1 step coeff_8 * z^8
    let t190 = circuit_add(t188, t189); // Eval sparse poly line_2p_1 step + coeff_8 * z^8
    let t191 = circuit_mul(t89, t190);
    let t192 = circuit_mul(t181, t0); // Eval sparse poly line_2p_2 step coeff_2 * z^2
    let t193 = circuit_add(t179, t192); // Eval sparse poly line_2p_2 step + coeff_2 * z^2
    let t194 = circuit_add(t193, t1); // Eval sparse poly line_2p_2 step + 1*z^3
    let t195 = circuit_mul(t182, t4); // Eval sparse poly line_2p_2 step coeff_6 * z^6
    let t196 = circuit_add(t194, t195); // Eval sparse poly line_2p_2 step + coeff_6 * z^6
    let t197 = circuit_mul(t183, t6); // Eval sparse poly line_2p_2 step coeff_8 * z^8
    let t198 = circuit_add(t196, t197); // Eval sparse poly line_2p_2 step + coeff_8 * z^8
    let t199 = circuit_mul(t191, t198);
    let t200 = circuit_sub(t199, t31);
    let t201 = circuit_mul(in41, t200); // ci * ((Π(i,k) (Pk(z)) - Ri(z))

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

    let mut circuit_inputs = (t160, t161, t170, t171, t201, t31,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x6, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(G2_line_0.r0a0);
    circuit_inputs = circuit_inputs.next(G2_line_0.r0a1);
    circuit_inputs = circuit_inputs.next(G2_line_0.r1a0);
    circuit_inputs = circuit_inputs.next(G2_line_0.r1a1);
    circuit_inputs = circuit_inputs.next(G2_line_0_2.r0a0);
    circuit_inputs = circuit_inputs.next(G2_line_0_2.r0a1);
    circuit_inputs = circuit_inputs.next(G2_line_0_2.r1a0);
    circuit_inputs = circuit_inputs.next(G2_line_0_2.r1a1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(G2_line_1.r0a0);
    circuit_inputs = circuit_inputs.next(G2_line_1.r0a1);
    circuit_inputs = circuit_inputs.next(G2_line_1.r1a0);
    circuit_inputs = circuit_inputs.next(G2_line_1.r1a1);
    circuit_inputs = circuit_inputs.next(G2_line_1_2.r0a0);
    circuit_inputs = circuit_inputs.next(G2_line_1_2.r0a1);
    circuit_inputs = circuit_inputs.next(G2_line_1_2.r1a0);
    circuit_inputs = circuit_inputs.next(G2_line_1_2.r1a1);
    circuit_inputs = circuit_inputs.next(yInv_2);
    circuit_inputs = circuit_inputs.next(xNegOverY_2);
    circuit_inputs = circuit_inputs.next(Q_2.x0);
    circuit_inputs = circuit_inputs.next(Q_2.x1);
    circuit_inputs = circuit_inputs.next(Q_2.y0);
    circuit_inputs = circuit_inputs.next(Q_2.y1);
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
    let Q2: G2Point = G2Point {
        x0: outputs.get_output(t160),
        x1: outputs.get_output(t161),
        y0: outputs.get_output(t170),
        y1: outputs.get_output(t171)
    };
    let new_lhs: u384 = outputs.get_output(t201);
    let f_i_plus_one_of_z: u384 = outputs.get_output(t31);
    return (Q2, new_lhs, f_i_plus_one_of_z);
}
fn run_BN254_GROTH16_BIT00_LOOP_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    G2_line_0: G2Line,
    G2_line_2nd_0_0: G2Line,
    yInv_1: u384,
    xNegOverY_1: u384,
    G2_line_1: G2Line,
    G2_line_2nd_0_1: G2Line,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q_2: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one: E12D,
    z: u384,
    ci: u384
) -> (G2Point, u384, u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // -0x9 % p
    let in1 = CE::<CI<1>> {}; // 0x1
    let in2 = CE::<CI<2>> {}; // 0x3
    let in3 = CE::<CI<3>> {}; // 0x6
    let in4 = CE::<CI<4>> {}; // 0x0

    // INPUT stack
    let (in5, in6) = (CE::<CI<5>> {}, CE::<CI<6>> {});
    let (in7, in8) = (CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10) = (CE::<CI<9>> {}, CE::<CI<10>> {});
    let (in11, in12) = (CE::<CI<11>> {}, CE::<CI<12>> {});
    let (in13, in14) = (CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16) = (CE::<CI<15>> {}, CE::<CI<16>> {});
    let (in17, in18) = (CE::<CI<17>> {}, CE::<CI<18>> {});
    let (in19, in20) = (CE::<CI<19>> {}, CE::<CI<20>> {});
    let (in21, in22) = (CE::<CI<21>> {}, CE::<CI<22>> {});
    let (in23, in24) = (CE::<CI<23>> {}, CE::<CI<24>> {});
    let (in25, in26) = (CE::<CI<25>> {}, CE::<CI<26>> {});
    let (in27, in28) = (CE::<CI<27>> {}, CE::<CI<28>> {});
    let (in29, in30) = (CE::<CI<29>> {}, CE::<CI<30>> {});
    let (in31, in32) = (CE::<CI<31>> {}, CE::<CI<32>> {});
    let (in33, in34) = (CE::<CI<33>> {}, CE::<CI<34>> {});
    let (in35, in36) = (CE::<CI<35>> {}, CE::<CI<36>> {});
    let (in37, in38) = (CE::<CI<37>> {}, CE::<CI<38>> {});
    let (in39, in40) = (CE::<CI<39>> {}, CE::<CI<40>> {});
    let (in41, in42) = (CE::<CI<41>> {}, CE::<CI<42>> {});
    let (in43, in44) = (CE::<CI<43>> {}, CE::<CI<44>> {});
    let (in45, in46) = (CE::<CI<45>> {}, CE::<CI<46>> {});
    let t0 = circuit_mul(in45, in45); // Compute z^2
    let t1 = circuit_mul(t0, in45); // Compute z^3
    let t2 = circuit_mul(t1, in45); // Compute z^4
    let t3 = circuit_mul(t2, in45); // Compute z^5
    let t4 = circuit_mul(t3, in45); // Compute z^6
    let t5 = circuit_mul(t4, in45); // Compute z^7
    let t6 = circuit_mul(t5, in45); // Compute z^8
    let t7 = circuit_mul(t6, in45); // Compute z^9
    let t8 = circuit_mul(t7, in45); // Compute z^10
    let t9 = circuit_mul(t8, in45); // Compute z^11
    let t10 = circuit_mul(in46, in46); // Compute c_i = (c_(i-1))^2
    let t11 = circuit_mul(in32, in32); // Square f evaluation in Z, the result of previous bit.
    let t12 = circuit_mul(in0, in8);
    let t13 = circuit_add(in7, t12);
    let t14 = circuit_mul(t13, in6);
    let t15 = circuit_mul(in0, in10);
    let t16 = circuit_add(in9, t15);
    let t17 = circuit_mul(t16, in5);
    let t18 = circuit_mul(in8, in6);
    let t19 = circuit_mul(in10, in5);
    let t20 = circuit_mul(t14, in45); // Eval sparse poly line_0p_1 step coeff_1 * z^1
    let t21 = circuit_add(in1, t20); // Eval sparse poly line_0p_1 step + coeff_1 * z^1
    let t22 = circuit_mul(t17, t1); // Eval sparse poly line_0p_1 step coeff_3 * z^3
    let t23 = circuit_add(t21, t22); // Eval sparse poly line_0p_1 step + coeff_3 * z^3
    let t24 = circuit_mul(t18, t5); // Eval sparse poly line_0p_1 step coeff_7 * z^7
    let t25 = circuit_add(t23, t24); // Eval sparse poly line_0p_1 step + coeff_7 * z^7
    let t26 = circuit_mul(t19, t7); // Eval sparse poly line_0p_1 step coeff_9 * z^9
    let t27 = circuit_add(t25, t26); // Eval sparse poly line_0p_1 step + coeff_9 * z^9
    let t28 = circuit_mul(t11, t27); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t29 = circuit_mul(in0, in12);
    let t30 = circuit_add(in11, t29);
    let t31 = circuit_mul(t30, in16);
    let t32 = circuit_mul(in0, in14);
    let t33 = circuit_add(in13, t32);
    let t34 = circuit_mul(t33, in15);
    let t35 = circuit_mul(in12, in16);
    let t36 = circuit_mul(in14, in15);
    let t37 = circuit_mul(t31, in45); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t38 = circuit_add(in1, t37); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t39 = circuit_mul(t34, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t40 = circuit_add(t38, t39); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t41 = circuit_mul(t35, t5); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t42 = circuit_add(t40, t41); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t43 = circuit_mul(t36, t7); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t44 = circuit_add(t42, t43); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t45 = circuit_mul(t28, t44); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t46 = circuit_add(in27, in28); // Doubling slope numerator start
    let t47 = circuit_sub(in27, in28);
    let t48 = circuit_mul(t46, t47);
    let t49 = circuit_mul(in27, in28);
    let t50 = circuit_mul(t48, in2);
    let t51 = circuit_mul(t49, in3); // Doubling slope numerator end
    let t52 = circuit_add(in29, in29); // Fp2 add coeff 0/1
    let t53 = circuit_add(in30, in30); // Fp2 add coeff 1/1
    let t54 = circuit_mul(t52, t52); // Fp2 Div x/y start : Fp2 Inv y start
    let t55 = circuit_mul(t53, t53);
    let t56 = circuit_add(t54, t55);
    let t57 = circuit_inverse(t56);
    let t58 = circuit_mul(t52, t57); // Fp2 Inv y real part end
    let t59 = circuit_mul(t53, t57);
    let t60 = circuit_sub(in4, t59); // Fp2 Inv y imag part end
    let t61 = circuit_mul(t50, t58); // Fp2 mul start
    let t62 = circuit_mul(t51, t60);
    let t63 = circuit_sub(t61, t62); // Fp2 mul real part end
    let t64 = circuit_mul(t50, t60);
    let t65 = circuit_mul(t51, t58);
    let t66 = circuit_add(t64, t65); // Fp2 mul imag part end
    let t67 = circuit_add(t63, t66);
    let t68 = circuit_sub(t63, t66);
    let t69 = circuit_mul(t67, t68);
    let t70 = circuit_mul(t63, t66);
    let t71 = circuit_add(t70, t70);
    let t72 = circuit_add(in27, in27); // Fp2 add coeff 0/1
    let t73 = circuit_add(in28, in28); // Fp2 add coeff 1/1
    let t74 = circuit_sub(t69, t72); // Fp2 sub coeff 0/1
    let t75 = circuit_sub(t71, t73); // Fp2 sub coeff 1/1
    let t76 = circuit_sub(in27, t74); // Fp2 sub coeff 0/1
    let t77 = circuit_sub(in28, t75); // Fp2 sub coeff 1/1
    let t78 = circuit_mul(t63, t76); // Fp2 mul start
    let t79 = circuit_mul(t66, t77);
    let t80 = circuit_sub(t78, t79); // Fp2 mul real part end
    let t81 = circuit_mul(t63, t77);
    let t82 = circuit_mul(t66, t76);
    let t83 = circuit_add(t81, t82); // Fp2 mul imag part end
    let t84 = circuit_sub(t80, in29); // Fp2 sub coeff 0/1
    let t85 = circuit_sub(t83, in30); // Fp2 sub coeff 1/1
    let t86 = circuit_mul(t63, in27); // Fp2 mul start
    let t87 = circuit_mul(t66, in28);
    let t88 = circuit_sub(t86, t87); // Fp2 mul real part end
    let t89 = circuit_mul(t63, in28);
    let t90 = circuit_mul(t66, in27);
    let t91 = circuit_add(t89, t90); // Fp2 mul imag part end
    let t92 = circuit_sub(t88, in29); // Fp2 sub coeff 0/1
    let t93 = circuit_sub(t91, in30); // Fp2 sub coeff 1/1
    let t94 = circuit_mul(in0, t66);
    let t95 = circuit_add(t63, t94);
    let t96 = circuit_mul(t95, in26);
    let t97 = circuit_mul(in0, t93);
    let t98 = circuit_add(t92, t97);
    let t99 = circuit_mul(t98, in25);
    let t100 = circuit_mul(t66, in26);
    let t101 = circuit_mul(t93, in25);
    let t102 = circuit_mul(t96, in45); // Eval sparse poly line_2p_1 step coeff_1 * z^1
    let t103 = circuit_add(in1, t102); // Eval sparse poly line_2p_1 step + coeff_1 * z^1
    let t104 = circuit_mul(t99, t1); // Eval sparse poly line_2p_1 step coeff_3 * z^3
    let t105 = circuit_add(t103, t104); // Eval sparse poly line_2p_1 step + coeff_3 * z^3
    let t106 = circuit_mul(t100, t5); // Eval sparse poly line_2p_1 step coeff_7 * z^7
    let t107 = circuit_add(t105, t106); // Eval sparse poly line_2p_1 step + coeff_7 * z^7
    let t108 = circuit_mul(t101, t7); // Eval sparse poly line_2p_1 step coeff_9 * z^9
    let t109 = circuit_add(t107, t108); // Eval sparse poly line_2p_1 step + coeff_9 * z^9
    let t110 = circuit_mul(t45, t109); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t111 = circuit_mul(
        t110, t110
    ); // Compute (f^2 * Π(i,k) (line_i,k(z))) ^ 2 = f^4 * (Π(i,k) (line_i,k(z)))^2
    let t112 = circuit_mul(in0, in18);
    let t113 = circuit_add(in17, t112);
    let t114 = circuit_mul(t113, in6);
    let t115 = circuit_mul(in0, in20);
    let t116 = circuit_add(in19, t115);
    let t117 = circuit_mul(t116, in5);
    let t118 = circuit_mul(in18, in6);
    let t119 = circuit_mul(in20, in5);
    let t120 = circuit_mul(t114, in45); // Eval sparse poly line_0p_1 step coeff_1 * z^1
    let t121 = circuit_add(in1, t120); // Eval sparse poly line_0p_1 step + coeff_1 * z^1
    let t122 = circuit_mul(t117, t1); // Eval sparse poly line_0p_1 step coeff_3 * z^3
    let t123 = circuit_add(t121, t122); // Eval sparse poly line_0p_1 step + coeff_3 * z^3
    let t124 = circuit_mul(t118, t5); // Eval sparse poly line_0p_1 step coeff_7 * z^7
    let t125 = circuit_add(t123, t124); // Eval sparse poly line_0p_1 step + coeff_7 * z^7
    let t126 = circuit_mul(t119, t7); // Eval sparse poly line_0p_1 step coeff_9 * z^9
    let t127 = circuit_add(t125, t126); // Eval sparse poly line_0p_1 step + coeff_9 * z^9
    let t128 = circuit_mul(t111, t127); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t129 = circuit_mul(in0, in22);
    let t130 = circuit_add(in21, t129);
    let t131 = circuit_mul(t130, in16);
    let t132 = circuit_mul(in0, in24);
    let t133 = circuit_add(in23, t132);
    let t134 = circuit_mul(t133, in15);
    let t135 = circuit_mul(in22, in16);
    let t136 = circuit_mul(in24, in15);
    let t137 = circuit_mul(t131, in45); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t138 = circuit_add(in1, t137); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t139 = circuit_mul(t134, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t140 = circuit_add(t138, t139); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t141 = circuit_mul(t135, t5); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t142 = circuit_add(t140, t141); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t143 = circuit_mul(t136, t7); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t144 = circuit_add(t142, t143); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t145 = circuit_mul(t128, t144); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t146 = circuit_add(t74, t75); // Doubling slope numerator start
    let t147 = circuit_sub(t74, t75);
    let t148 = circuit_mul(t146, t147);
    let t149 = circuit_mul(t74, t75);
    let t150 = circuit_mul(t148, in2);
    let t151 = circuit_mul(t149, in3); // Doubling slope numerator end
    let t152 = circuit_add(t84, t84); // Fp2 add coeff 0/1
    let t153 = circuit_add(t85, t85); // Fp2 add coeff 1/1
    let t154 = circuit_mul(t152, t152); // Fp2 Div x/y start : Fp2 Inv y start
    let t155 = circuit_mul(t153, t153);
    let t156 = circuit_add(t154, t155);
    let t157 = circuit_inverse(t156);
    let t158 = circuit_mul(t152, t157); // Fp2 Inv y real part end
    let t159 = circuit_mul(t153, t157);
    let t160 = circuit_sub(in4, t159); // Fp2 Inv y imag part end
    let t161 = circuit_mul(t150, t158); // Fp2 mul start
    let t162 = circuit_mul(t151, t160);
    let t163 = circuit_sub(t161, t162); // Fp2 mul real part end
    let t164 = circuit_mul(t150, t160);
    let t165 = circuit_mul(t151, t158);
    let t166 = circuit_add(t164, t165); // Fp2 mul imag part end
    let t167 = circuit_add(t163, t166);
    let t168 = circuit_sub(t163, t166);
    let t169 = circuit_mul(t167, t168);
    let t170 = circuit_mul(t163, t166);
    let t171 = circuit_add(t170, t170);
    let t172 = circuit_add(t74, t74); // Fp2 add coeff 0/1
    let t173 = circuit_add(t75, t75); // Fp2 add coeff 1/1
    let t174 = circuit_sub(t169, t172); // Fp2 sub coeff 0/1
    let t175 = circuit_sub(t171, t173); // Fp2 sub coeff 1/1
    let t176 = circuit_sub(t74, t174); // Fp2 sub coeff 0/1
    let t177 = circuit_sub(t75, t175); // Fp2 sub coeff 1/1
    let t178 = circuit_mul(t163, t176); // Fp2 mul start
    let t179 = circuit_mul(t166, t177);
    let t180 = circuit_sub(t178, t179); // Fp2 mul real part end
    let t181 = circuit_mul(t163, t177);
    let t182 = circuit_mul(t166, t176);
    let t183 = circuit_add(t181, t182); // Fp2 mul imag part end
    let t184 = circuit_sub(t180, t84); // Fp2 sub coeff 0/1
    let t185 = circuit_sub(t183, t85); // Fp2 sub coeff 1/1
    let t186 = circuit_mul(t163, t74); // Fp2 mul start
    let t187 = circuit_mul(t166, t75);
    let t188 = circuit_sub(t186, t187); // Fp2 mul real part end
    let t189 = circuit_mul(t163, t75);
    let t190 = circuit_mul(t166, t74);
    let t191 = circuit_add(t189, t190); // Fp2 mul imag part end
    let t192 = circuit_sub(t188, t84); // Fp2 sub coeff 0/1
    let t193 = circuit_sub(t191, t85); // Fp2 sub coeff 1/1
    let t194 = circuit_mul(in0, t166);
    let t195 = circuit_add(t163, t194);
    let t196 = circuit_mul(t195, in26);
    let t197 = circuit_mul(in0, t193);
    let t198 = circuit_add(t192, t197);
    let t199 = circuit_mul(t198, in25);
    let t200 = circuit_mul(t166, in26);
    let t201 = circuit_mul(t193, in25);
    let t202 = circuit_mul(t196, in45); // Eval sparse poly line_2p_1 step coeff_1 * z^1
    let t203 = circuit_add(in1, t202); // Eval sparse poly line_2p_1 step + coeff_1 * z^1
    let t204 = circuit_mul(t199, t1); // Eval sparse poly line_2p_1 step coeff_3 * z^3
    let t205 = circuit_add(t203, t204); // Eval sparse poly line_2p_1 step + coeff_3 * z^3
    let t206 = circuit_mul(t200, t5); // Eval sparse poly line_2p_1 step coeff_7 * z^7
    let t207 = circuit_add(t205, t206); // Eval sparse poly line_2p_1 step + coeff_7 * z^7
    let t208 = circuit_mul(t201, t7); // Eval sparse poly line_2p_1 step coeff_9 * z^9
    let t209 = circuit_add(t207, t208); // Eval sparse poly line_2p_1 step + coeff_9 * z^9
    let t210 = circuit_mul(t145, t209); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t211 = circuit_mul(in34, in45); // Eval R step coeff_1 * z^1
    let t212 = circuit_add(in33, t211); // Eval R step + (coeff_1 * z^1)
    let t213 = circuit_mul(in35, t0); // Eval R step coeff_2 * z^2
    let t214 = circuit_add(t212, t213); // Eval R step + (coeff_2 * z^2)
    let t215 = circuit_mul(in36, t1); // Eval R step coeff_3 * z^3
    let t216 = circuit_add(t214, t215); // Eval R step + (coeff_3 * z^3)
    let t217 = circuit_mul(in37, t2); // Eval R step coeff_4 * z^4
    let t218 = circuit_add(t216, t217); // Eval R step + (coeff_4 * z^4)
    let t219 = circuit_mul(in38, t3); // Eval R step coeff_5 * z^5
    let t220 = circuit_add(t218, t219); // Eval R step + (coeff_5 * z^5)
    let t221 = circuit_mul(in39, t4); // Eval R step coeff_6 * z^6
    let t222 = circuit_add(t220, t221); // Eval R step + (coeff_6 * z^6)
    let t223 = circuit_mul(in40, t5); // Eval R step coeff_7 * z^7
    let t224 = circuit_add(t222, t223); // Eval R step + (coeff_7 * z^7)
    let t225 = circuit_mul(in41, t6); // Eval R step coeff_8 * z^8
    let t226 = circuit_add(t224, t225); // Eval R step + (coeff_8 * z^8)
    let t227 = circuit_mul(in42, t7); // Eval R step coeff_9 * z^9
    let t228 = circuit_add(t226, t227); // Eval R step + (coeff_9 * z^9)
    let t229 = circuit_mul(in43, t8); // Eval R step coeff_10 * z^10
    let t230 = circuit_add(t228, t229); // Eval R step + (coeff_10 * z^10)
    let t231 = circuit_mul(in44, t9); // Eval R step coeff_11 * z^11
    let t232 = circuit_add(t230, t231); // Eval R step + (coeff_11 * z^11)
    let t233 = circuit_sub(t210, t232); // (Π(i,k) (Pk(z))) - Ri(z)
    let t234 = circuit_mul(t10, t233); // ci * ((Π(i,k) (Pk(z)) - Ri(z))
    let t235 = circuit_add(in31, t234); // LHS = LHS + ci * ((Π(i,k) (Pk(z)) - Ri(z))

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [32324006162389411176778628423, 57042285082623239461879769745, 3486998266802970665, 0]
    )
        .unwrap();

    let mut circuit_inputs = (t174, t175, t184, t185, t232, t235, t10,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs
        .next([0x6871ca8d3c208c16d87cfd3e, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0]);
    circuit_inputs = circuit_inputs.next([0x1, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x6, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(G2_line_0.r0a0);
    circuit_inputs = circuit_inputs.next(G2_line_0.r0a1);
    circuit_inputs = circuit_inputs.next(G2_line_0.r1a0);
    circuit_inputs = circuit_inputs.next(G2_line_0.r1a1);
    circuit_inputs = circuit_inputs.next(G2_line_2nd_0_0.r0a0);
    circuit_inputs = circuit_inputs.next(G2_line_2nd_0_0.r0a1);
    circuit_inputs = circuit_inputs.next(G2_line_2nd_0_0.r1a0);
    circuit_inputs = circuit_inputs.next(G2_line_2nd_0_0.r1a1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(G2_line_1.r0a0);
    circuit_inputs = circuit_inputs.next(G2_line_1.r0a1);
    circuit_inputs = circuit_inputs.next(G2_line_1.r1a0);
    circuit_inputs = circuit_inputs.next(G2_line_1.r1a1);
    circuit_inputs = circuit_inputs.next(G2_line_2nd_0_1.r0a0);
    circuit_inputs = circuit_inputs.next(G2_line_2nd_0_1.r0a1);
    circuit_inputs = circuit_inputs.next(G2_line_2nd_0_1.r1a0);
    circuit_inputs = circuit_inputs.next(G2_line_2nd_0_1.r1a1);
    circuit_inputs = circuit_inputs.next(yInv_2);
    circuit_inputs = circuit_inputs.next(xNegOverY_2);
    circuit_inputs = circuit_inputs.next(Q_2.x0);
    circuit_inputs = circuit_inputs.next(Q_2.x1);
    circuit_inputs = circuit_inputs.next(Q_2.y0);
    circuit_inputs = circuit_inputs.next(Q_2.y1);
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
    circuit_inputs = circuit_inputs.next(z);
    circuit_inputs = circuit_inputs.next(ci);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let Q2: G2Point = G2Point {
        x0: outputs.get_output(t174),
        x1: outputs.get_output(t175),
        y0: outputs.get_output(t184),
        y1: outputs.get_output(t185)
    };
    let f_i_plus_one_of_z: u384 = outputs.get_output(t232);
    let lhs_i_plus_one: u384 = outputs.get_output(t235);
    let ci_plus_one: u384 = outputs.get_output(t10);
    return (Q2, f_i_plus_one_of_z, lhs_i_plus_one, ci_plus_one);
}
fn run_BN254_GROTH16_BIT0_LOOP_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    G2_line_0: G2Line,
    yInv_1: u384,
    xNegOverY_1: u384,
    G2_line_1: G2Line,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q_2: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one: E12D,
    z: u384,
    ci: u384
) -> (G2Point, u384, u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // -0x9 % p
    let in1 = CE::<CI<1>> {}; // 0x1
    let in2 = CE::<CI<2>> {}; // 0x3
    let in3 = CE::<CI<3>> {}; // 0x6
    let in4 = CE::<CI<4>> {}; // 0x0

    // INPUT stack
    let (in5, in6) = (CE::<CI<5>> {}, CE::<CI<6>> {});
    let (in7, in8) = (CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10) = (CE::<CI<9>> {}, CE::<CI<10>> {});
    let (in11, in12) = (CE::<CI<11>> {}, CE::<CI<12>> {});
    let (in13, in14) = (CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16) = (CE::<CI<15>> {}, CE::<CI<16>> {});
    let (in17, in18) = (CE::<CI<17>> {}, CE::<CI<18>> {});
    let (in19, in20) = (CE::<CI<19>> {}, CE::<CI<20>> {});
    let (in21, in22) = (CE::<CI<21>> {}, CE::<CI<22>> {});
    let (in23, in24) = (CE::<CI<23>> {}, CE::<CI<24>> {});
    let (in25, in26) = (CE::<CI<25>> {}, CE::<CI<26>> {});
    let (in27, in28) = (CE::<CI<27>> {}, CE::<CI<28>> {});
    let (in29, in30) = (CE::<CI<29>> {}, CE::<CI<30>> {});
    let (in31, in32) = (CE::<CI<31>> {}, CE::<CI<32>> {});
    let (in33, in34) = (CE::<CI<33>> {}, CE::<CI<34>> {});
    let (in35, in36) = (CE::<CI<35>> {}, CE::<CI<36>> {});
    let (in37, in38) = (CE::<CI<37>> {}, CE::<CI<38>> {});
    let t0 = circuit_mul(in37, in37); // Compute z^2
    let t1 = circuit_mul(t0, in37); // Compute z^3
    let t2 = circuit_mul(t1, in37); // Compute z^4
    let t3 = circuit_mul(t2, in37); // Compute z^5
    let t4 = circuit_mul(t3, in37); // Compute z^6
    let t5 = circuit_mul(t4, in37); // Compute z^7
    let t6 = circuit_mul(t5, in37); // Compute z^8
    let t7 = circuit_mul(t6, in37); // Compute z^9
    let t8 = circuit_mul(t7, in37); // Compute z^10
    let t9 = circuit_mul(t8, in37); // Compute z^11
    let t10 = circuit_mul(in38, in38); // Compute c_i = (c_(i-1))^2
    let t11 = circuit_mul(in24, in24); // Square f evaluation in Z, the result of previous bit.
    let t12 = circuit_mul(in0, in8);
    let t13 = circuit_add(in7, t12);
    let t14 = circuit_mul(t13, in6);
    let t15 = circuit_mul(in0, in10);
    let t16 = circuit_add(in9, t15);
    let t17 = circuit_mul(t16, in5);
    let t18 = circuit_mul(in8, in6);
    let t19 = circuit_mul(in10, in5);
    let t20 = circuit_mul(t14, in37); // Eval sparse poly line_0p_1 step coeff_1 * z^1
    let t21 = circuit_add(in1, t20); // Eval sparse poly line_0p_1 step + coeff_1 * z^1
    let t22 = circuit_mul(t17, t1); // Eval sparse poly line_0p_1 step coeff_3 * z^3
    let t23 = circuit_add(t21, t22); // Eval sparse poly line_0p_1 step + coeff_3 * z^3
    let t24 = circuit_mul(t18, t5); // Eval sparse poly line_0p_1 step coeff_7 * z^7
    let t25 = circuit_add(t23, t24); // Eval sparse poly line_0p_1 step + coeff_7 * z^7
    let t26 = circuit_mul(t19, t7); // Eval sparse poly line_0p_1 step coeff_9 * z^9
    let t27 = circuit_add(t25, t26); // Eval sparse poly line_0p_1 step + coeff_9 * z^9
    let t28 = circuit_mul(t11, t27); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t29 = circuit_mul(in0, in14);
    let t30 = circuit_add(in13, t29);
    let t31 = circuit_mul(t30, in12);
    let t32 = circuit_mul(in0, in16);
    let t33 = circuit_add(in15, t32);
    let t34 = circuit_mul(t33, in11);
    let t35 = circuit_mul(in14, in12);
    let t36 = circuit_mul(in16, in11);
    let t37 = circuit_mul(t31, in37); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t38 = circuit_add(in1, t37); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t39 = circuit_mul(t34, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t40 = circuit_add(t38, t39); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t41 = circuit_mul(t35, t5); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t42 = circuit_add(t40, t41); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t43 = circuit_mul(t36, t7); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t44 = circuit_add(t42, t43); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t45 = circuit_mul(t28, t44); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t46 = circuit_add(in19, in20); // Doubling slope numerator start
    let t47 = circuit_sub(in19, in20);
    let t48 = circuit_mul(t46, t47);
    let t49 = circuit_mul(in19, in20);
    let t50 = circuit_mul(t48, in2);
    let t51 = circuit_mul(t49, in3); // Doubling slope numerator end
    let t52 = circuit_add(in21, in21); // Fp2 add coeff 0/1
    let t53 = circuit_add(in22, in22); // Fp2 add coeff 1/1
    let t54 = circuit_mul(t52, t52); // Fp2 Div x/y start : Fp2 Inv y start
    let t55 = circuit_mul(t53, t53);
    let t56 = circuit_add(t54, t55);
    let t57 = circuit_inverse(t56);
    let t58 = circuit_mul(t52, t57); // Fp2 Inv y real part end
    let t59 = circuit_mul(t53, t57);
    let t60 = circuit_sub(in4, t59); // Fp2 Inv y imag part end
    let t61 = circuit_mul(t50, t58); // Fp2 mul start
    let t62 = circuit_mul(t51, t60);
    let t63 = circuit_sub(t61, t62); // Fp2 mul real part end
    let t64 = circuit_mul(t50, t60);
    let t65 = circuit_mul(t51, t58);
    let t66 = circuit_add(t64, t65); // Fp2 mul imag part end
    let t67 = circuit_add(t63, t66);
    let t68 = circuit_sub(t63, t66);
    let t69 = circuit_mul(t67, t68);
    let t70 = circuit_mul(t63, t66);
    let t71 = circuit_add(t70, t70);
    let t72 = circuit_add(in19, in19); // Fp2 add coeff 0/1
    let t73 = circuit_add(in20, in20); // Fp2 add coeff 1/1
    let t74 = circuit_sub(t69, t72); // Fp2 sub coeff 0/1
    let t75 = circuit_sub(t71, t73); // Fp2 sub coeff 1/1
    let t76 = circuit_sub(in19, t74); // Fp2 sub coeff 0/1
    let t77 = circuit_sub(in20, t75); // Fp2 sub coeff 1/1
    let t78 = circuit_mul(t63, t76); // Fp2 mul start
    let t79 = circuit_mul(t66, t77);
    let t80 = circuit_sub(t78, t79); // Fp2 mul real part end
    let t81 = circuit_mul(t63, t77);
    let t82 = circuit_mul(t66, t76);
    let t83 = circuit_add(t81, t82); // Fp2 mul imag part end
    let t84 = circuit_sub(t80, in21); // Fp2 sub coeff 0/1
    let t85 = circuit_sub(t83, in22); // Fp2 sub coeff 1/1
    let t86 = circuit_mul(t63, in19); // Fp2 mul start
    let t87 = circuit_mul(t66, in20);
    let t88 = circuit_sub(t86, t87); // Fp2 mul real part end
    let t89 = circuit_mul(t63, in20);
    let t90 = circuit_mul(t66, in19);
    let t91 = circuit_add(t89, t90); // Fp2 mul imag part end
    let t92 = circuit_sub(t88, in21); // Fp2 sub coeff 0/1
    let t93 = circuit_sub(t91, in22); // Fp2 sub coeff 1/1
    let t94 = circuit_mul(in0, t66);
    let t95 = circuit_add(t63, t94);
    let t96 = circuit_mul(t95, in18);
    let t97 = circuit_mul(in0, t93);
    let t98 = circuit_add(t92, t97);
    let t99 = circuit_mul(t98, in17);
    let t100 = circuit_mul(t66, in18);
    let t101 = circuit_mul(t93, in17);
    let t102 = circuit_mul(t96, in37); // Eval sparse poly line_2p_1 step coeff_1 * z^1
    let t103 = circuit_add(in1, t102); // Eval sparse poly line_2p_1 step + coeff_1 * z^1
    let t104 = circuit_mul(t99, t1); // Eval sparse poly line_2p_1 step coeff_3 * z^3
    let t105 = circuit_add(t103, t104); // Eval sparse poly line_2p_1 step + coeff_3 * z^3
    let t106 = circuit_mul(t100, t5); // Eval sparse poly line_2p_1 step coeff_7 * z^7
    let t107 = circuit_add(t105, t106); // Eval sparse poly line_2p_1 step + coeff_7 * z^7
    let t108 = circuit_mul(t101, t7); // Eval sparse poly line_2p_1 step coeff_9 * z^9
    let t109 = circuit_add(t107, t108); // Eval sparse poly line_2p_1 step + coeff_9 * z^9
    let t110 = circuit_mul(t45, t109); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t111 = circuit_mul(in26, in37); // Eval R step coeff_1 * z^1
    let t112 = circuit_add(in25, t111); // Eval R step + (coeff_1 * z^1)
    let t113 = circuit_mul(in27, t0); // Eval R step coeff_2 * z^2
    let t114 = circuit_add(t112, t113); // Eval R step + (coeff_2 * z^2)
    let t115 = circuit_mul(in28, t1); // Eval R step coeff_3 * z^3
    let t116 = circuit_add(t114, t115); // Eval R step + (coeff_3 * z^3)
    let t117 = circuit_mul(in29, t2); // Eval R step coeff_4 * z^4
    let t118 = circuit_add(t116, t117); // Eval R step + (coeff_4 * z^4)
    let t119 = circuit_mul(in30, t3); // Eval R step coeff_5 * z^5
    let t120 = circuit_add(t118, t119); // Eval R step + (coeff_5 * z^5)
    let t121 = circuit_mul(in31, t4); // Eval R step coeff_6 * z^6
    let t122 = circuit_add(t120, t121); // Eval R step + (coeff_6 * z^6)
    let t123 = circuit_mul(in32, t5); // Eval R step coeff_7 * z^7
    let t124 = circuit_add(t122, t123); // Eval R step + (coeff_7 * z^7)
    let t125 = circuit_mul(in33, t6); // Eval R step coeff_8 * z^8
    let t126 = circuit_add(t124, t125); // Eval R step + (coeff_8 * z^8)
    let t127 = circuit_mul(in34, t7); // Eval R step coeff_9 * z^9
    let t128 = circuit_add(t126, t127); // Eval R step + (coeff_9 * z^9)
    let t129 = circuit_mul(in35, t8); // Eval R step coeff_10 * z^10
    let t130 = circuit_add(t128, t129); // Eval R step + (coeff_10 * z^10)
    let t131 = circuit_mul(in36, t9); // Eval R step coeff_11 * z^11
    let t132 = circuit_add(t130, t131); // Eval R step + (coeff_11 * z^11)
    let t133 = circuit_sub(t110, t132); // (Π(i,k) (Pk(z))) - Ri(z)
    let t134 = circuit_mul(t10, t133); // ci * ((Π(i,k) (Pk(z)) - Ri(z))
    let t135 = circuit_add(in23, t134); // LHS = LHS + ci * ((Π(i,k) (Pk(z)) - Ri(z))

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [32324006162389411176778628423, 57042285082623239461879769745, 3486998266802970665, 0]
    )
        .unwrap();

    let mut circuit_inputs = (t74, t75, t84, t85, t132, t135, t10,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs
        .next([0x6871ca8d3c208c16d87cfd3e, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0]);
    circuit_inputs = circuit_inputs.next([0x1, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x6, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(G2_line_0.r0a0);
    circuit_inputs = circuit_inputs.next(G2_line_0.r0a1);
    circuit_inputs = circuit_inputs.next(G2_line_0.r1a0);
    circuit_inputs = circuit_inputs.next(G2_line_0.r1a1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(G2_line_1.r0a0);
    circuit_inputs = circuit_inputs.next(G2_line_1.r0a1);
    circuit_inputs = circuit_inputs.next(G2_line_1.r1a0);
    circuit_inputs = circuit_inputs.next(G2_line_1.r1a1);
    circuit_inputs = circuit_inputs.next(yInv_2);
    circuit_inputs = circuit_inputs.next(xNegOverY_2);
    circuit_inputs = circuit_inputs.next(Q_2.x0);
    circuit_inputs = circuit_inputs.next(Q_2.x1);
    circuit_inputs = circuit_inputs.next(Q_2.y0);
    circuit_inputs = circuit_inputs.next(Q_2.y1);
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
    circuit_inputs = circuit_inputs.next(z);
    circuit_inputs = circuit_inputs.next(ci);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let Q2: G2Point = G2Point {
        x0: outputs.get_output(t74),
        x1: outputs.get_output(t75),
        y0: outputs.get_output(t84),
        y1: outputs.get_output(t85)
    };
    let f_i_plus_one_of_z: u384 = outputs.get_output(t132);
    let lhs_i_plus_one: u384 = outputs.get_output(t135);
    let ci_plus_one: u384 = outputs.get_output(t10);
    return (Q2, f_i_plus_one_of_z, lhs_i_plus_one, ci_plus_one);
}
fn run_BN254_GROTH16_BIT1_LOOP_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    G2_line_0: G2Line,
    Q_or_Q_neg_line0: G2Line,
    yInv_1: u384,
    xNegOverY_1: u384,
    G2_line_1: G2Line,
    Q_or_Q_neg_line1: G2Line,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q_2: G2Point,
    Q_or_Q_neg_2: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one: E12D,
    c_or_cinv_of_z: u384,
    z: u384,
    ci: u384
) -> (G2Point, u384, u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // -0x9 % p
    let in1 = CE::<CI<1>> {}; // 0x1
    let in2 = CE::<CI<2>> {}; // 0x0

    // INPUT stack
    let (in3, in4) = (CE::<CI<3>> {}, CE::<CI<4>> {});
    let (in5, in6) = (CE::<CI<5>> {}, CE::<CI<6>> {});
    let (in7, in8) = (CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10) = (CE::<CI<9>> {}, CE::<CI<10>> {});
    let (in11, in12) = (CE::<CI<11>> {}, CE::<CI<12>> {});
    let (in13, in14) = (CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16) = (CE::<CI<15>> {}, CE::<CI<16>> {});
    let (in17, in18) = (CE::<CI<17>> {}, CE::<CI<18>> {});
    let (in19, in20) = (CE::<CI<19>> {}, CE::<CI<20>> {});
    let (in21, in22) = (CE::<CI<21>> {}, CE::<CI<22>> {});
    let (in23, in24) = (CE::<CI<23>> {}, CE::<CI<24>> {});
    let (in25, in26) = (CE::<CI<25>> {}, CE::<CI<26>> {});
    let (in27, in28) = (CE::<CI<27>> {}, CE::<CI<28>> {});
    let (in29, in30) = (CE::<CI<29>> {}, CE::<CI<30>> {});
    let (in31, in32) = (CE::<CI<31>> {}, CE::<CI<32>> {});
    let (in33, in34) = (CE::<CI<33>> {}, CE::<CI<34>> {});
    let (in35, in36) = (CE::<CI<35>> {}, CE::<CI<36>> {});
    let (in37, in38) = (CE::<CI<37>> {}, CE::<CI<38>> {});
    let (in39, in40) = (CE::<CI<39>> {}, CE::<CI<40>> {});
    let (in41, in42) = (CE::<CI<41>> {}, CE::<CI<42>> {});
    let (in43, in44) = (CE::<CI<43>> {}, CE::<CI<44>> {});
    let (in45, in46) = (CE::<CI<45>> {}, CE::<CI<46>> {});
    let (in47, in48) = (CE::<CI<47>> {}, CE::<CI<48>> {});
    let in49 = CE::<CI<49>> {};
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
    let t10 = circuit_mul(in49, in49); // Compute c_i = (c_(i-1))^2
    let t11 = circuit_mul(in34, in34); // Square f evaluation in Z, the result of previous bit.
    let t12 = circuit_mul(in0, in6);
    let t13 = circuit_add(in5, t12);
    let t14 = circuit_mul(t13, in4);
    let t15 = circuit_mul(in0, in8);
    let t16 = circuit_add(in7, t15);
    let t17 = circuit_mul(t16, in3);
    let t18 = circuit_mul(in6, in4);
    let t19 = circuit_mul(in8, in3);
    let t20 = circuit_mul(in0, in10);
    let t21 = circuit_add(in9, t20);
    let t22 = circuit_mul(t21, in4);
    let t23 = circuit_mul(in0, in12);
    let t24 = circuit_add(in11, t23);
    let t25 = circuit_mul(t24, in3);
    let t26 = circuit_mul(in10, in4);
    let t27 = circuit_mul(in12, in3);
    let t28 = circuit_mul(t14, in48); // Eval sparse poly line_0p_1 step coeff_1 * z^1
    let t29 = circuit_add(in1, t28); // Eval sparse poly line_0p_1 step + coeff_1 * z^1
    let t30 = circuit_mul(t17, t1); // Eval sparse poly line_0p_1 step coeff_3 * z^3
    let t31 = circuit_add(t29, t30); // Eval sparse poly line_0p_1 step + coeff_3 * z^3
    let t32 = circuit_mul(t18, t5); // Eval sparse poly line_0p_1 step coeff_7 * z^7
    let t33 = circuit_add(t31, t32); // Eval sparse poly line_0p_1 step + coeff_7 * z^7
    let t34 = circuit_mul(t19, t7); // Eval sparse poly line_0p_1 step coeff_9 * z^9
    let t35 = circuit_add(t33, t34); // Eval sparse poly line_0p_1 step + coeff_9 * z^9
    let t36 = circuit_mul(t11, t35); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t37 = circuit_mul(t22, in48); // Eval sparse poly line_0p_2 step coeff_1 * z^1
    let t38 = circuit_add(in1, t37); // Eval sparse poly line_0p_2 step + coeff_1 * z^1
    let t39 = circuit_mul(t25, t1); // Eval sparse poly line_0p_2 step coeff_3 * z^3
    let t40 = circuit_add(t38, t39); // Eval sparse poly line_0p_2 step + coeff_3 * z^3
    let t41 = circuit_mul(t26, t5); // Eval sparse poly line_0p_2 step coeff_7 * z^7
    let t42 = circuit_add(t40, t41); // Eval sparse poly line_0p_2 step + coeff_7 * z^7
    let t43 = circuit_mul(t27, t7); // Eval sparse poly line_0p_2 step coeff_9 * z^9
    let t44 = circuit_add(t42, t43); // Eval sparse poly line_0p_2 step + coeff_9 * z^9
    let t45 = circuit_mul(t36, t44); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t46 = circuit_mul(in0, in16);
    let t47 = circuit_add(in15, t46);
    let t48 = circuit_mul(t47, in14);
    let t49 = circuit_mul(in0, in18);
    let t50 = circuit_add(in17, t49);
    let t51 = circuit_mul(t50, in13);
    let t52 = circuit_mul(in16, in14);
    let t53 = circuit_mul(in18, in13);
    let t54 = circuit_mul(in0, in20);
    let t55 = circuit_add(in19, t54);
    let t56 = circuit_mul(t55, in14);
    let t57 = circuit_mul(in0, in22);
    let t58 = circuit_add(in21, t57);
    let t59 = circuit_mul(t58, in13);
    let t60 = circuit_mul(in20, in14);
    let t61 = circuit_mul(in22, in13);
    let t62 = circuit_mul(t48, in48); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t63 = circuit_add(in1, t62); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t64 = circuit_mul(t51, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t65 = circuit_add(t63, t64); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t66 = circuit_mul(t52, t5); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t67 = circuit_add(t65, t66); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t68 = circuit_mul(t53, t7); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t69 = circuit_add(t67, t68); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t70 = circuit_mul(t45, t69); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t71 = circuit_mul(t56, in48); // Eval sparse poly line_1p_2 step coeff_1 * z^1
    let t72 = circuit_add(in1, t71); // Eval sparse poly line_1p_2 step + coeff_1 * z^1
    let t73 = circuit_mul(t59, t1); // Eval sparse poly line_1p_2 step coeff_3 * z^3
    let t74 = circuit_add(t72, t73); // Eval sparse poly line_1p_2 step + coeff_3 * z^3
    let t75 = circuit_mul(t60, t5); // Eval sparse poly line_1p_2 step coeff_7 * z^7
    let t76 = circuit_add(t74, t75); // Eval sparse poly line_1p_2 step + coeff_7 * z^7
    let t77 = circuit_mul(t61, t7); // Eval sparse poly line_1p_2 step coeff_9 * z^9
    let t78 = circuit_add(t76, t77); // Eval sparse poly line_1p_2 step + coeff_9 * z^9
    let t79 = circuit_mul(t70, t78); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t80 = circuit_sub(in27, in31); // Fp2 sub coeff 0/1
    let t81 = circuit_sub(in28, in32); // Fp2 sub coeff 1/1
    let t82 = circuit_sub(in25, in29); // Fp2 sub coeff 0/1
    let t83 = circuit_sub(in26, in30); // Fp2 sub coeff 1/1
    let t84 = circuit_mul(t82, t82); // Fp2 Div x/y start : Fp2 Inv y start
    let t85 = circuit_mul(t83, t83);
    let t86 = circuit_add(t84, t85);
    let t87 = circuit_inverse(t86);
    let t88 = circuit_mul(t82, t87); // Fp2 Inv y real part end
    let t89 = circuit_mul(t83, t87);
    let t90 = circuit_sub(in2, t89); // Fp2 Inv y imag part end
    let t91 = circuit_mul(t80, t88); // Fp2 mul start
    let t92 = circuit_mul(t81, t90);
    let t93 = circuit_sub(t91, t92); // Fp2 mul real part end
    let t94 = circuit_mul(t80, t90);
    let t95 = circuit_mul(t81, t88);
    let t96 = circuit_add(t94, t95); // Fp2 mul imag part end
    let t97 = circuit_add(t93, t96);
    let t98 = circuit_sub(t93, t96);
    let t99 = circuit_mul(t97, t98);
    let t100 = circuit_mul(t93, t96);
    let t101 = circuit_add(t100, t100);
    let t102 = circuit_add(in25, in29); // Fp2 add coeff 0/1
    let t103 = circuit_add(in26, in30); // Fp2 add coeff 1/1
    let t104 = circuit_sub(t99, t102); // Fp2 sub coeff 0/1
    let t105 = circuit_sub(t101, t103); // Fp2 sub coeff 1/1
    let t106 = circuit_mul(t93, in25); // Fp2 mul start
    let t107 = circuit_mul(t96, in26);
    let t108 = circuit_sub(t106, t107); // Fp2 mul real part end
    let t109 = circuit_mul(t93, in26);
    let t110 = circuit_mul(t96, in25);
    let t111 = circuit_add(t109, t110); // Fp2 mul imag part end
    let t112 = circuit_sub(t108, in27); // Fp2 sub coeff 0/1
    let t113 = circuit_sub(t111, in28); // Fp2 sub coeff 1/1
    let t114 = circuit_add(in27, in27); // Fp2 add coeff 0/1
    let t115 = circuit_add(in28, in28); // Fp2 add coeff 1/1
    let t116 = circuit_sub(t104, in25); // Fp2 sub coeff 0/1
    let t117 = circuit_sub(t105, in26); // Fp2 sub coeff 1/1
    let t118 = circuit_mul(t116, t116); // Fp2 Div x/y start : Fp2 Inv y start
    let t119 = circuit_mul(t117, t117);
    let t120 = circuit_add(t118, t119);
    let t121 = circuit_inverse(t120);
    let t122 = circuit_mul(t116, t121); // Fp2 Inv y real part end
    let t123 = circuit_mul(t117, t121);
    let t124 = circuit_sub(in2, t123); // Fp2 Inv y imag part end
    let t125 = circuit_mul(t114, t122); // Fp2 mul start
    let t126 = circuit_mul(t115, t124);
    let t127 = circuit_sub(t125, t126); // Fp2 mul real part end
    let t128 = circuit_mul(t114, t124);
    let t129 = circuit_mul(t115, t122);
    let t130 = circuit_add(t128, t129); // Fp2 mul imag part end
    let t131 = circuit_add(t93, t127); // Fp2 add coeff 0/1
    let t132 = circuit_add(t96, t130); // Fp2 add coeff 1/1
    let t133 = circuit_sub(in2, t131); // Fp2 neg coeff 0/1
    let t134 = circuit_sub(in2, t132); // Fp2 neg coeff 1/1
    let t135 = circuit_add(t133, t134);
    let t136 = circuit_sub(t133, t134);
    let t137 = circuit_mul(t135, t136);
    let t138 = circuit_mul(t133, t134);
    let t139 = circuit_add(t138, t138);
    let t140 = circuit_sub(t137, in25); // Fp2 sub coeff 0/1
    let t141 = circuit_sub(t139, in26); // Fp2 sub coeff 1/1
    let t142 = circuit_sub(t140, t104); // Fp2 sub coeff 0/1
    let t143 = circuit_sub(t141, t105); // Fp2 sub coeff 1/1
    let t144 = circuit_sub(in25, t142); // Fp2 sub coeff 0/1
    let t145 = circuit_sub(in26, t143); // Fp2 sub coeff 1/1
    let t146 = circuit_mul(t133, t144); // Fp2 mul start
    let t147 = circuit_mul(t134, t145);
    let t148 = circuit_sub(t146, t147); // Fp2 mul real part end
    let t149 = circuit_mul(t133, t145);
    let t150 = circuit_mul(t134, t144);
    let t151 = circuit_add(t149, t150); // Fp2 mul imag part end
    let t152 = circuit_sub(t148, in27); // Fp2 sub coeff 0/1
    let t153 = circuit_sub(t151, in28); // Fp2 sub coeff 1/1
    let t154 = circuit_mul(t133, in25); // Fp2 mul start
    let t155 = circuit_mul(t134, in26);
    let t156 = circuit_sub(t154, t155); // Fp2 mul real part end
    let t157 = circuit_mul(t133, in26);
    let t158 = circuit_mul(t134, in25);
    let t159 = circuit_add(t157, t158); // Fp2 mul imag part end
    let t160 = circuit_sub(t156, in27); // Fp2 sub coeff 0/1
    let t161 = circuit_sub(t159, in28); // Fp2 sub coeff 1/1
    let t162 = circuit_mul(in0, t96);
    let t163 = circuit_add(t93, t162);
    let t164 = circuit_mul(t163, in24);
    let t165 = circuit_mul(in0, t113);
    let t166 = circuit_add(t112, t165);
    let t167 = circuit_mul(t166, in23);
    let t168 = circuit_mul(t96, in24);
    let t169 = circuit_mul(t113, in23);
    let t170 = circuit_mul(in0, t134);
    let t171 = circuit_add(t133, t170);
    let t172 = circuit_mul(t171, in24);
    let t173 = circuit_mul(in0, t161);
    let t174 = circuit_add(t160, t173);
    let t175 = circuit_mul(t174, in23);
    let t176 = circuit_mul(t134, in24);
    let t177 = circuit_mul(t161, in23);
    let t178 = circuit_mul(t164, in48); // Eval sparse poly line_2p_1 step coeff_1 * z^1
    let t179 = circuit_add(in1, t178); // Eval sparse poly line_2p_1 step + coeff_1 * z^1
    let t180 = circuit_mul(t167, t1); // Eval sparse poly line_2p_1 step coeff_3 * z^3
    let t181 = circuit_add(t179, t180); // Eval sparse poly line_2p_1 step + coeff_3 * z^3
    let t182 = circuit_mul(t168, t5); // Eval sparse poly line_2p_1 step coeff_7 * z^7
    let t183 = circuit_add(t181, t182); // Eval sparse poly line_2p_1 step + coeff_7 * z^7
    let t184 = circuit_mul(t169, t7); // Eval sparse poly line_2p_1 step coeff_9 * z^9
    let t185 = circuit_add(t183, t184); // Eval sparse poly line_2p_1 step + coeff_9 * z^9
    let t186 = circuit_mul(t79, t185); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t187 = circuit_mul(t172, in48); // Eval sparse poly line_2p_2 step coeff_1 * z^1
    let t188 = circuit_add(in1, t187); // Eval sparse poly line_2p_2 step + coeff_1 * z^1
    let t189 = circuit_mul(t175, t1); // Eval sparse poly line_2p_2 step coeff_3 * z^3
    let t190 = circuit_add(t188, t189); // Eval sparse poly line_2p_2 step + coeff_3 * z^3
    let t191 = circuit_mul(t176, t5); // Eval sparse poly line_2p_2 step coeff_7 * z^7
    let t192 = circuit_add(t190, t191); // Eval sparse poly line_2p_2 step + coeff_7 * z^7
    let t193 = circuit_mul(t177, t7); // Eval sparse poly line_2p_2 step coeff_9 * z^9
    let t194 = circuit_add(t192, t193); // Eval sparse poly line_2p_2 step + coeff_9 * z^9
    let t195 = circuit_mul(t186, t194); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t196 = circuit_mul(t195, in47);
    let t197 = circuit_mul(in36, in48); // Eval R step coeff_1 * z^1
    let t198 = circuit_add(in35, t197); // Eval R step + (coeff_1 * z^1)
    let t199 = circuit_mul(in37, t0); // Eval R step coeff_2 * z^2
    let t200 = circuit_add(t198, t199); // Eval R step + (coeff_2 * z^2)
    let t201 = circuit_mul(in38, t1); // Eval R step coeff_3 * z^3
    let t202 = circuit_add(t200, t201); // Eval R step + (coeff_3 * z^3)
    let t203 = circuit_mul(in39, t2); // Eval R step coeff_4 * z^4
    let t204 = circuit_add(t202, t203); // Eval R step + (coeff_4 * z^4)
    let t205 = circuit_mul(in40, t3); // Eval R step coeff_5 * z^5
    let t206 = circuit_add(t204, t205); // Eval R step + (coeff_5 * z^5)
    let t207 = circuit_mul(in41, t4); // Eval R step coeff_6 * z^6
    let t208 = circuit_add(t206, t207); // Eval R step + (coeff_6 * z^6)
    let t209 = circuit_mul(in42, t5); // Eval R step coeff_7 * z^7
    let t210 = circuit_add(t208, t209); // Eval R step + (coeff_7 * z^7)
    let t211 = circuit_mul(in43, t6); // Eval R step coeff_8 * z^8
    let t212 = circuit_add(t210, t211); // Eval R step + (coeff_8 * z^8)
    let t213 = circuit_mul(in44, t7); // Eval R step coeff_9 * z^9
    let t214 = circuit_add(t212, t213); // Eval R step + (coeff_9 * z^9)
    let t215 = circuit_mul(in45, t8); // Eval R step coeff_10 * z^10
    let t216 = circuit_add(t214, t215); // Eval R step + (coeff_10 * z^10)
    let t217 = circuit_mul(in46, t9); // Eval R step coeff_11 * z^11
    let t218 = circuit_add(t216, t217); // Eval R step + (coeff_11 * z^11)
    let t219 = circuit_sub(t196, t218); // (Π(i,k) (Pk(z))) - Ri(z)
    let t220 = circuit_mul(t10, t219); // ci * ((Π(i,k) (Pk(z)) - Ri(z))
    let t221 = circuit_add(in33, t220); // LHS = LHS + ci * ((Π(i,k) (Pk(z)) - Ri(z))

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [32324006162389411176778628423, 57042285082623239461879769745, 3486998266802970665, 0]
    )
        .unwrap();

    let mut circuit_inputs = (t142, t143, t152, t153, t218, t221, t10,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs
        .next([0x6871ca8d3c208c16d87cfd3e, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0]);
    circuit_inputs = circuit_inputs.next([0x1, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(G2_line_0.r0a0);
    circuit_inputs = circuit_inputs.next(G2_line_0.r0a1);
    circuit_inputs = circuit_inputs.next(G2_line_0.r1a0);
    circuit_inputs = circuit_inputs.next(G2_line_0.r1a1);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_line0.r0a0);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_line0.r0a1);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_line0.r1a0);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_line0.r1a1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(G2_line_1.r0a0);
    circuit_inputs = circuit_inputs.next(G2_line_1.r0a1);
    circuit_inputs = circuit_inputs.next(G2_line_1.r1a0);
    circuit_inputs = circuit_inputs.next(G2_line_1.r1a1);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_line1.r0a0);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_line1.r0a1);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_line1.r1a0);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_line1.r1a1);
    circuit_inputs = circuit_inputs.next(yInv_2);
    circuit_inputs = circuit_inputs.next(xNegOverY_2);
    circuit_inputs = circuit_inputs.next(Q_2.x0);
    circuit_inputs = circuit_inputs.next(Q_2.x1);
    circuit_inputs = circuit_inputs.next(Q_2.y0);
    circuit_inputs = circuit_inputs.next(Q_2.y1);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_2.x0);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_2.x1);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_2.y0);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_2.y1);
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
    let Q2: G2Point = G2Point {
        x0: outputs.get_output(t142),
        x1: outputs.get_output(t143),
        y0: outputs.get_output(t152),
        y1: outputs.get_output(t153)
    };
    let f_i_plus_one_of_z: u384 = outputs.get_output(t218);
    let lhs_i_plus_one: u384 = outputs.get_output(t221);
    let ci_plus_one: u384 = outputs.get_output(t10);
    return (Q2, f_i_plus_one_of_z, lhs_i_plus_one, ci_plus_one);
}
fn run_BN254_GROTH16_FINALIZE_BN_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    line_1_0: G2Line,
    line_2_0: G2Line,
    yInv_1: u384,
    xNegOverY_1: u384,
    line_1_1: G2Line,
    line_2_1: G2Line,
    original_Q2: G2Point,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q_2: G2Point,
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
    let (in10, in11) = (CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13) = (CE::<CI<12>> {}, CE::<CI<13>> {});
    let (in14, in15) = (CE::<CI<14>> {}, CE::<CI<15>> {});
    let (in16, in17) = (CE::<CI<16>> {}, CE::<CI<17>> {});
    let (in18, in19) = (CE::<CI<18>> {}, CE::<CI<19>> {});
    let (in20, in21) = (CE::<CI<20>> {}, CE::<CI<21>> {});
    let (in22, in23) = (CE::<CI<22>> {}, CE::<CI<23>> {});
    let (in24, in25) = (CE::<CI<24>> {}, CE::<CI<25>> {});
    let (in26, in27) = (CE::<CI<26>> {}, CE::<CI<27>> {});
    let (in28, in29) = (CE::<CI<28>> {}, CE::<CI<29>> {});
    let (in30, in31) = (CE::<CI<30>> {}, CE::<CI<31>> {});
    let (in32, in33) = (CE::<CI<32>> {}, CE::<CI<33>> {});
    let (in34, in35) = (CE::<CI<34>> {}, CE::<CI<35>> {});
    let (in36, in37) = (CE::<CI<36>> {}, CE::<CI<37>> {});
    let (in38, in39) = (CE::<CI<38>> {}, CE::<CI<39>> {});
    let (in40, in41) = (CE::<CI<40>> {}, CE::<CI<41>> {});
    let (in42, in43) = (CE::<CI<42>> {}, CE::<CI<43>> {});
    let (in44, in45) = (CE::<CI<44>> {}, CE::<CI<45>> {});
    let (in46, in47) = (CE::<CI<46>> {}, CE::<CI<47>> {});
    let (in48, in49) = (CE::<CI<48>> {}, CE::<CI<49>> {});
    let (in50, in51) = (CE::<CI<50>> {}, CE::<CI<51>> {});
    let (in52, in53) = (CE::<CI<52>> {}, CE::<CI<53>> {});
    let (in54, in55) = (CE::<CI<54>> {}, CE::<CI<55>> {});
    let (in56, in57) = (CE::<CI<56>> {}, CE::<CI<57>> {});
    let (in58, in59) = (CE::<CI<58>> {}, CE::<CI<59>> {});
    let (in60, in61) = (CE::<CI<60>> {}, CE::<CI<61>> {});
    let (in62, in63) = (CE::<CI<62>> {}, CE::<CI<63>> {});
    let (in64, in65) = (CE::<CI<64>> {}, CE::<CI<65>> {});
    let (in66, in67) = (CE::<CI<66>> {}, CE::<CI<67>> {});
    let (in68, in69) = (CE::<CI<68>> {}, CE::<CI<69>> {});
    let (in70, in71) = (CE::<CI<70>> {}, CE::<CI<71>> {});
    let (in72, in73) = (CE::<CI<72>> {}, CE::<CI<73>> {});
    let (in74, in75) = (CE::<CI<74>> {}, CE::<CI<75>> {});
    let (in76, in77) = (CE::<CI<76>> {}, CE::<CI<77>> {});
    let (in78, in79) = (CE::<CI<78>> {}, CE::<CI<79>> {});
    let (in80, in81) = (CE::<CI<80>> {}, CE::<CI<81>> {});
    let (in82, in83) = (CE::<CI<82>> {}, CE::<CI<83>> {});
    let (in84, in85) = (CE::<CI<84>> {}, CE::<CI<85>> {});
    let (in86, in87) = (CE::<CI<86>> {}, CE::<CI<87>> {});
    let (in88, in89) = (CE::<CI<88>> {}, CE::<CI<89>> {});
    let (in90, in91) = (CE::<CI<90>> {}, CE::<CI<91>> {});
    let (in92, in93) = (CE::<CI<92>> {}, CE::<CI<93>> {});
    let (in94, in95) = (CE::<CI<94>> {}, CE::<CI<95>> {});
    let (in96, in97) = (CE::<CI<96>> {}, CE::<CI<97>> {});
    let (in98, in99) = (CE::<CI<98>> {}, CE::<CI<99>> {});
    let (in100, in101) = (CE::<CI<100>> {}, CE::<CI<101>> {});
    let (in102, in103) = (CE::<CI<102>> {}, CE::<CI<103>> {});
    let (in104, in105) = (CE::<CI<104>> {}, CE::<CI<105>> {});
    let (in106, in107) = (CE::<CI<106>> {}, CE::<CI<107>> {});
    let (in108, in109) = (CE::<CI<108>> {}, CE::<CI<109>> {});
    let (in110, in111) = (CE::<CI<110>> {}, CE::<CI<111>> {});
    let (in112, in113) = (CE::<CI<112>> {}, CE::<CI<113>> {});
    let (in114, in115) = (CE::<CI<114>> {}, CE::<CI<115>> {});
    let (in116, in117) = (CE::<CI<116>> {}, CE::<CI<117>> {});
    let (in118, in119) = (CE::<CI<118>> {}, CE::<CI<119>> {});
    let (in120, in121) = (CE::<CI<120>> {}, CE::<CI<121>> {});
    let (in122, in123) = (CE::<CI<122>> {}, CE::<CI<123>> {});
    let (in124, in125) = (CE::<CI<124>> {}, CE::<CI<125>> {});
    let (in126, in127) = (CE::<CI<126>> {}, CE::<CI<127>> {});
    let (in128, in129) = (CE::<CI<128>> {}, CE::<CI<129>> {});
    let (in130, in131) = (CE::<CI<130>> {}, CE::<CI<131>> {});
    let (in132, in133) = (CE::<CI<132>> {}, CE::<CI<133>> {});
    let (in134, in135) = (CE::<CI<134>> {}, CE::<CI<135>> {});
    let (in136, in137) = (CE::<CI<136>> {}, CE::<CI<137>> {});
    let (in138, in139) = (CE::<CI<138>> {}, CE::<CI<139>> {});
    let (in140, in141) = (CE::<CI<140>> {}, CE::<CI<141>> {});
    let (in142, in143) = (CE::<CI<142>> {}, CE::<CI<143>> {});
    let (in144, in145) = (CE::<CI<144>> {}, CE::<CI<145>> {});
    let (in146, in147) = (CE::<CI<146>> {}, CE::<CI<147>> {});
    let (in148, in149) = (CE::<CI<148>> {}, CE::<CI<149>> {});
    let (in150, in151) = (CE::<CI<150>> {}, CE::<CI<151>> {});
    let (in152, in153) = (CE::<CI<152>> {}, CE::<CI<153>> {});
    let (in154, in155) = (CE::<CI<154>> {}, CE::<CI<155>> {});
    let (in156, in157) = (CE::<CI<156>> {}, CE::<CI<157>> {});
    let (in158, in159) = (CE::<CI<158>> {}, CE::<CI<159>> {});
    let (in160, in161) = (CE::<CI<160>> {}, CE::<CI<161>> {});
    let (in162, in163) = (CE::<CI<162>> {}, CE::<CI<163>> {});
    let (in164, in165) = (CE::<CI<164>> {}, CE::<CI<165>> {});
    let (in166, in167) = (CE::<CI<166>> {}, CE::<CI<167>> {});
    let (in168, in169) = (CE::<CI<168>> {}, CE::<CI<169>> {});
    let (in170, in171) = (CE::<CI<170>> {}, CE::<CI<171>> {});
    let (in172, in173) = (CE::<CI<172>> {}, CE::<CI<173>> {});
    let (in174, in175) = (CE::<CI<174>> {}, CE::<CI<175>> {});
    let (in176, in177) = (CE::<CI<176>> {}, CE::<CI<177>> {});
    let (in178, in179) = (CE::<CI<178>> {}, CE::<CI<179>> {});
    let (in180, in181) = (CE::<CI<180>> {}, CE::<CI<181>> {});
    let (in182, in183) = (CE::<CI<182>> {}, CE::<CI<183>> {});
    let (in184, in185) = (CE::<CI<184>> {}, CE::<CI<185>> {});
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
    let t74 = circuit_mul(t73, in66); // Compute z^76
    let t75 = circuit_mul(t74, in66); // Compute z^77
    let t76 = circuit_mul(t75, in66); // Compute z^78
    let t77 = circuit_mul(t76, in66); // Compute z^79
    let t78 = circuit_mul(t77, in66); // Compute z^80
    let t79 = circuit_mul(t78, in66); // Compute z^81
    let t80 = circuit_mul(t79, in66); // Compute z^82
    let t81 = circuit_mul(t80, in66); // Compute z^83
    let t82 = circuit_mul(t81, in66); // Compute z^84
    let t83 = circuit_mul(t82, in66); // Compute z^85
    let t84 = circuit_mul(t83, in66); // Compute z^86
    let t85 = circuit_mul(t84, in66); // Compute z^87
    let t86 = circuit_mul(t85, in66); // Compute z^88
    let t87 = circuit_mul(t86, in66); // Compute z^89
    let t88 = circuit_mul(t87, in66); // Compute z^90
    let t89 = circuit_mul(t88, in66); // Compute z^91
    let t90 = circuit_mul(t89, in66); // Compute z^92
    let t91 = circuit_mul(t90, in66); // Compute z^93
    let t92 = circuit_mul(t91, in66); // Compute z^94
    let t93 = circuit_mul(t92, in66); // Compute z^95
    let t94 = circuit_mul(t93, in66); // Compute z^96
    let t95 = circuit_mul(t94, in66); // Compute z^97
    let t96 = circuit_mul(t95, in66); // Compute z^98
    let t97 = circuit_mul(t96, in66); // Compute z^99
    let t98 = circuit_mul(t97, in66); // Compute z^100
    let t99 = circuit_mul(t98, in66); // Compute z^101
    let t100 = circuit_mul(t99, in66); // Compute z^102
    let t101 = circuit_mul(t100, in66); // Compute z^103
    let t102 = circuit_mul(t101, in66); // Compute z^104
    let t103 = circuit_mul(t102, in66); // Compute z^105
    let t104 = circuit_mul(t103, in66); // Compute z^106
    let t105 = circuit_mul(t104, in66); // Compute z^107
    let t106 = circuit_mul(t105, in66); // Compute z^108
    let t107 = circuit_mul(t106, in66); // Compute z^109
    let t108 = circuit_mul(t107, in66); // Compute z^110
    let t109 = circuit_mul(t108, in66); // Compute z^111
    let t110 = circuit_mul(t109, in66); // Compute z^112
    let t111 = circuit_mul(t110, in66); // Compute z^113
    let t112 = circuit_mul(in64, in64);
    let t113 = circuit_mul(t112, t112);
    let t114 = circuit_mul(in41, in66); // Eval R_n_minus_2 step coeff_1 * z^1
    let t115 = circuit_add(in40, t114); // Eval R_n_minus_2 step + (coeff_1 * z^1)
    let t116 = circuit_mul(in42, t0); // Eval R_n_minus_2 step coeff_2 * z^2
    let t117 = circuit_add(t115, t116); // Eval R_n_minus_2 step + (coeff_2 * z^2)
    let t118 = circuit_mul(in43, t1); // Eval R_n_minus_2 step coeff_3 * z^3
    let t119 = circuit_add(t117, t118); // Eval R_n_minus_2 step + (coeff_3 * z^3)
    let t120 = circuit_mul(in44, t2); // Eval R_n_minus_2 step coeff_4 * z^4
    let t121 = circuit_add(t119, t120); // Eval R_n_minus_2 step + (coeff_4 * z^4)
    let t122 = circuit_mul(in45, t3); // Eval R_n_minus_2 step coeff_5 * z^5
    let t123 = circuit_add(t121, t122); // Eval R_n_minus_2 step + (coeff_5 * z^5)
    let t124 = circuit_mul(in46, t4); // Eval R_n_minus_2 step coeff_6 * z^6
    let t125 = circuit_add(t123, t124); // Eval R_n_minus_2 step + (coeff_6 * z^6)
    let t126 = circuit_mul(in47, t5); // Eval R_n_minus_2 step coeff_7 * z^7
    let t127 = circuit_add(t125, t126); // Eval R_n_minus_2 step + (coeff_7 * z^7)
    let t128 = circuit_mul(in48, t6); // Eval R_n_minus_2 step coeff_8 * z^8
    let t129 = circuit_add(t127, t128); // Eval R_n_minus_2 step + (coeff_8 * z^8)
    let t130 = circuit_mul(in49, t7); // Eval R_n_minus_2 step coeff_9 * z^9
    let t131 = circuit_add(t129, t130); // Eval R_n_minus_2 step + (coeff_9 * z^9)
    let t132 = circuit_mul(in50, t8); // Eval R_n_minus_2 step coeff_10 * z^10
    let t133 = circuit_add(t131, t132); // Eval R_n_minus_2 step + (coeff_10 * z^10)
    let t134 = circuit_mul(in51, t9); // Eval R_n_minus_2 step coeff_11 * z^11
    let t135 = circuit_add(t133, t134); // Eval R_n_minus_2 step + (coeff_11 * z^11)
    let t136 = circuit_mul(in53, in66); // Eval R_n_minus_1 step coeff_1 * z^1
    let t137 = circuit_add(in52, t136); // Eval R_n_minus_1 step + (coeff_1 * z^1)
    let t138 = circuit_mul(in54, t0); // Eval R_n_minus_1 step coeff_2 * z^2
    let t139 = circuit_add(t137, t138); // Eval R_n_minus_1 step + (coeff_2 * z^2)
    let t140 = circuit_mul(in55, t1); // Eval R_n_minus_1 step coeff_3 * z^3
    let t141 = circuit_add(t139, t140); // Eval R_n_minus_1 step + (coeff_3 * z^3)
    let t142 = circuit_mul(in56, t2); // Eval R_n_minus_1 step coeff_4 * z^4
    let t143 = circuit_add(t141, t142); // Eval R_n_minus_1 step + (coeff_4 * z^4)
    let t144 = circuit_mul(in57, t3); // Eval R_n_minus_1 step coeff_5 * z^5
    let t145 = circuit_add(t143, t144); // Eval R_n_minus_1 step + (coeff_5 * z^5)
    let t146 = circuit_mul(in58, t4); // Eval R_n_minus_1 step coeff_6 * z^6
    let t147 = circuit_add(t145, t146); // Eval R_n_minus_1 step + (coeff_6 * z^6)
    let t148 = circuit_mul(in59, t5); // Eval R_n_minus_1 step coeff_7 * z^7
    let t149 = circuit_add(t147, t148); // Eval R_n_minus_1 step + (coeff_7 * z^7)
    let t150 = circuit_mul(in60, t6); // Eval R_n_minus_1 step coeff_8 * z^8
    let t151 = circuit_add(t149, t150); // Eval R_n_minus_1 step + (coeff_8 * z^8)
    let t152 = circuit_mul(in61, t7); // Eval R_n_minus_1 step coeff_9 * z^9
    let t153 = circuit_add(t151, t152); // Eval R_n_minus_1 step + (coeff_9 * z^9)
    let t154 = circuit_mul(in62, t8); // Eval R_n_minus_1 step coeff_10 * z^10
    let t155 = circuit_add(t153, t154); // Eval R_n_minus_1 step + (coeff_10 * z^10)
    let t156 = circuit_mul(in63, t9); // Eval R_n_minus_1 step coeff_11 * z^11
    let t157 = circuit_add(t155, t156); // Eval R_n_minus_1 step + (coeff_11 * z^11)
    let t158 = circuit_sub(in6, in31);
    let t159 = circuit_sub(in6, in33);
    let t160 = circuit_mul(in30, in0); // Fp2 mul start
    let t161 = circuit_mul(t158, in1);
    let t162 = circuit_sub(t160, t161); // Fp2 mul real part end
    let t163 = circuit_mul(in30, in1);
    let t164 = circuit_mul(t158, in0);
    let t165 = circuit_add(t163, t164); // Fp2 mul imag part end
    let t166 = circuit_mul(in32, in2); // Fp2 mul start
    let t167 = circuit_mul(t159, in3);
    let t168 = circuit_sub(t166, t167); // Fp2 mul real part end
    let t169 = circuit_mul(in32, in3);
    let t170 = circuit_mul(t159, in2);
    let t171 = circuit_add(t169, t170); // Fp2 mul imag part end
    let t172 = circuit_mul(in30, in4); // Fp2 scalar mul coeff 0/1
    let t173 = circuit_mul(in31, in4); // Fp2 scalar mul coeff 1/1
    let t174 = circuit_mul(in32, in5); // Fp2 scalar mul coeff 0/1
    let t175 = circuit_mul(in33, in5); // Fp2 scalar mul coeff 1/1
    let t176 = circuit_sub(in38, t168); // Fp2 sub coeff 0/1
    let t177 = circuit_sub(in39, t171); // Fp2 sub coeff 1/1
    let t178 = circuit_sub(in36, t162); // Fp2 sub coeff 0/1
    let t179 = circuit_sub(in37, t165); // Fp2 sub coeff 1/1
    let t180 = circuit_mul(t178, t178); // Fp2 Div x/y start : Fp2 Inv y start
    let t181 = circuit_mul(t179, t179);
    let t182 = circuit_add(t180, t181);
    let t183 = circuit_inverse(t182);
    let t184 = circuit_mul(t178, t183); // Fp2 Inv y real part end
    let t185 = circuit_mul(t179, t183);
    let t186 = circuit_sub(in6, t185); // Fp2 Inv y imag part end
    let t187 = circuit_mul(t176, t184); // Fp2 mul start
    let t188 = circuit_mul(t177, t186);
    let t189 = circuit_sub(t187, t188); // Fp2 mul real part end
    let t190 = circuit_mul(t176, t186);
    let t191 = circuit_mul(t177, t184);
    let t192 = circuit_add(t190, t191); // Fp2 mul imag part end
    let t193 = circuit_add(t189, t192);
    let t194 = circuit_sub(t189, t192);
    let t195 = circuit_mul(t193, t194);
    let t196 = circuit_mul(t189, t192);
    let t197 = circuit_add(t196, t196);
    let t198 = circuit_add(in36, t162); // Fp2 add coeff 0/1
    let t199 = circuit_add(in37, t165); // Fp2 add coeff 1/1
    let t200 = circuit_sub(t195, t198); // Fp2 sub coeff 0/1
    let t201 = circuit_sub(t197, t199); // Fp2 sub coeff 1/1
    let t202 = circuit_sub(in36, t200); // Fp2 sub coeff 0/1
    let t203 = circuit_sub(in37, t201); // Fp2 sub coeff 1/1
    let t204 = circuit_mul(t189, t202); // Fp2 mul start
    let t205 = circuit_mul(t192, t203);
    let t206 = circuit_sub(t204, t205); // Fp2 mul real part end
    let t207 = circuit_mul(t189, t203);
    let t208 = circuit_mul(t192, t202);
    let t209 = circuit_add(t207, t208); // Fp2 mul imag part end
    let t210 = circuit_sub(t206, in38); // Fp2 sub coeff 0/1
    let t211 = circuit_sub(t209, in39); // Fp2 sub coeff 1/1
    let t212 = circuit_mul(t189, in36); // Fp2 mul start
    let t213 = circuit_mul(t192, in37);
    let t214 = circuit_sub(t212, t213); // Fp2 mul real part end
    let t215 = circuit_mul(t189, in37);
    let t216 = circuit_mul(t192, in36);
    let t217 = circuit_add(t215, t216); // Fp2 mul imag part end
    let t218 = circuit_sub(t214, in38); // Fp2 sub coeff 0/1
    let t219 = circuit_sub(t217, in39); // Fp2 sub coeff 1/1
    let t220 = circuit_sub(t210, t174); // Fp2 sub coeff 0/1
    let t221 = circuit_sub(t211, t175); // Fp2 sub coeff 1/1
    let t222 = circuit_sub(t200, t172); // Fp2 sub coeff 0/1
    let t223 = circuit_sub(t201, t173); // Fp2 sub coeff 1/1
    let t224 = circuit_mul(t222, t222); // Fp2 Div x/y start : Fp2 Inv y start
    let t225 = circuit_mul(t223, t223);
    let t226 = circuit_add(t224, t225);
    let t227 = circuit_inverse(t226);
    let t228 = circuit_mul(t222, t227); // Fp2 Inv y real part end
    let t229 = circuit_mul(t223, t227);
    let t230 = circuit_sub(in6, t229); // Fp2 Inv y imag part end
    let t231 = circuit_mul(t220, t228); // Fp2 mul start
    let t232 = circuit_mul(t221, t230);
    let t233 = circuit_sub(t231, t232); // Fp2 mul real part end
    let t234 = circuit_mul(t220, t230);
    let t235 = circuit_mul(t221, t228);
    let t236 = circuit_add(t234, t235); // Fp2 mul imag part end
    let t237 = circuit_mul(t233, t200); // Fp2 mul start
    let t238 = circuit_mul(t236, t201);
    let t239 = circuit_sub(t237, t238); // Fp2 mul real part end
    let t240 = circuit_mul(t233, t201);
    let t241 = circuit_mul(t236, t200);
    let t242 = circuit_add(t240, t241); // Fp2 mul imag part end
    let t243 = circuit_sub(t239, t210); // Fp2 sub coeff 0/1
    let t244 = circuit_sub(t242, t211); // Fp2 sub coeff 1/1
    let t245 = circuit_mul(in7, in13);
    let t246 = circuit_add(in12, t245);
    let t247 = circuit_mul(t246, in11);
    let t248 = circuit_mul(in7, in15);
    let t249 = circuit_add(in14, t248);
    let t250 = circuit_mul(t249, in10);
    let t251 = circuit_mul(in13, in11);
    let t252 = circuit_mul(in15, in10);
    let t253 = circuit_mul(in7, in17);
    let t254 = circuit_add(in16, t253);
    let t255 = circuit_mul(t254, in11);
    let t256 = circuit_mul(in7, in19);
    let t257 = circuit_add(in18, t256);
    let t258 = circuit_mul(t257, in10);
    let t259 = circuit_mul(in17, in11);
    let t260 = circuit_mul(in19, in10);
    let t261 = circuit_mul(in7, in23);
    let t262 = circuit_add(in22, t261);
    let t263 = circuit_mul(t262, in21);
    let t264 = circuit_mul(in7, in25);
    let t265 = circuit_add(in24, t264);
    let t266 = circuit_mul(t265, in20);
    let t267 = circuit_mul(in23, in21);
    let t268 = circuit_mul(in25, in20);
    let t269 = circuit_mul(in7, in27);
    let t270 = circuit_add(in26, t269);
    let t271 = circuit_mul(t270, in21);
    let t272 = circuit_mul(in7, in29);
    let t273 = circuit_add(in28, t272);
    let t274 = circuit_mul(t273, in20);
    let t275 = circuit_mul(in27, in21);
    let t276 = circuit_mul(in29, in20);
    let t277 = circuit_mul(in7, t192);
    let t278 = circuit_add(t189, t277);
    let t279 = circuit_mul(t278, in35);
    let t280 = circuit_mul(in7, t219);
    let t281 = circuit_add(t218, t280);
    let t282 = circuit_mul(t281, in34);
    let t283 = circuit_mul(t192, in35);
    let t284 = circuit_mul(t219, in34);
    let t285 = circuit_mul(in7, t236);
    let t286 = circuit_add(t233, t285);
    let t287 = circuit_mul(t286, in35);
    let t288 = circuit_mul(in7, t244);
    let t289 = circuit_add(t243, t288);
    let t290 = circuit_mul(t289, in34);
    let t291 = circuit_mul(t236, in35);
    let t292 = circuit_mul(t244, in34);
    let t293 = circuit_mul(t247, in66); // Eval sparse poly line_2 step coeff_1 * z^1
    let t294 = circuit_add(in5, t293); // Eval sparse poly line_2 step + coeff_1 * z^1
    let t295 = circuit_mul(t250, t1); // Eval sparse poly line_2 step coeff_3 * z^3
    let t296 = circuit_add(t294, t295); // Eval sparse poly line_2 step + coeff_3 * z^3
    let t297 = circuit_mul(t251, t5); // Eval sparse poly line_2 step coeff_7 * z^7
    let t298 = circuit_add(t296, t297); // Eval sparse poly line_2 step + coeff_7 * z^7
    let t299 = circuit_mul(t252, t7); // Eval sparse poly line_2 step coeff_9 * z^9
    let t300 = circuit_add(t298, t299); // Eval sparse poly line_2 step + coeff_9 * z^9
    let t301 = circuit_mul(in71, t300);
    let t302 = circuit_mul(t255, in66); // Eval sparse poly line_2 step coeff_1 * z^1
    let t303 = circuit_add(in5, t302); // Eval sparse poly line_2 step + coeff_1 * z^1
    let t304 = circuit_mul(t258, t1); // Eval sparse poly line_2 step coeff_3 * z^3
    let t305 = circuit_add(t303, t304); // Eval sparse poly line_2 step + coeff_3 * z^3
    let t306 = circuit_mul(t259, t5); // Eval sparse poly line_2 step coeff_7 * z^7
    let t307 = circuit_add(t305, t306); // Eval sparse poly line_2 step + coeff_7 * z^7
    let t308 = circuit_mul(t260, t7); // Eval sparse poly line_2 step coeff_9 * z^9
    let t309 = circuit_add(t307, t308); // Eval sparse poly line_2 step + coeff_9 * z^9
    let t310 = circuit_mul(t301, t309);
    let t311 = circuit_mul(t263, in66); // Eval sparse poly line_2 step coeff_1 * z^1
    let t312 = circuit_add(in5, t311); // Eval sparse poly line_2 step + coeff_1 * z^1
    let t313 = circuit_mul(t266, t1); // Eval sparse poly line_2 step coeff_3 * z^3
    let t314 = circuit_add(t312, t313); // Eval sparse poly line_2 step + coeff_3 * z^3
    let t315 = circuit_mul(t267, t5); // Eval sparse poly line_2 step coeff_7 * z^7
    let t316 = circuit_add(t314, t315); // Eval sparse poly line_2 step + coeff_7 * z^7
    let t317 = circuit_mul(t268, t7); // Eval sparse poly line_2 step coeff_9 * z^9
    let t318 = circuit_add(t316, t317); // Eval sparse poly line_2 step + coeff_9 * z^9
    let t319 = circuit_mul(t310, t318);
    let t320 = circuit_mul(t271, in66); // Eval sparse poly line_2 step coeff_1 * z^1
    let t321 = circuit_add(in5, t320); // Eval sparse poly line_2 step + coeff_1 * z^1
    let t322 = circuit_mul(t274, t1); // Eval sparse poly line_2 step coeff_3 * z^3
    let t323 = circuit_add(t321, t322); // Eval sparse poly line_2 step + coeff_3 * z^3
    let t324 = circuit_mul(t275, t5); // Eval sparse poly line_2 step coeff_7 * z^7
    let t325 = circuit_add(t323, t324); // Eval sparse poly line_2 step + coeff_7 * z^7
    let t326 = circuit_mul(t276, t7); // Eval sparse poly line_2 step coeff_9 * z^9
    let t327 = circuit_add(t325, t326); // Eval sparse poly line_2 step + coeff_9 * z^9
    let t328 = circuit_mul(t319, t327);
    let t329 = circuit_mul(t279, in66); // Eval sparse poly line_2 step coeff_1 * z^1
    let t330 = circuit_add(in5, t329); // Eval sparse poly line_2 step + coeff_1 * z^1
    let t331 = circuit_mul(t282, t1); // Eval sparse poly line_2 step coeff_3 * z^3
    let t332 = circuit_add(t330, t331); // Eval sparse poly line_2 step + coeff_3 * z^3
    let t333 = circuit_mul(t283, t5); // Eval sparse poly line_2 step coeff_7 * z^7
    let t334 = circuit_add(t332, t333); // Eval sparse poly line_2 step + coeff_7 * z^7
    let t335 = circuit_mul(t284, t7); // Eval sparse poly line_2 step coeff_9 * z^9
    let t336 = circuit_add(t334, t335); // Eval sparse poly line_2 step + coeff_9 * z^9
    let t337 = circuit_mul(t328, t336);
    let t338 = circuit_mul(t287, in66); // Eval sparse poly line_2 step coeff_1 * z^1
    let t339 = circuit_add(in5, t338); // Eval sparse poly line_2 step + coeff_1 * z^1
    let t340 = circuit_mul(t290, t1); // Eval sparse poly line_2 step coeff_3 * z^3
    let t341 = circuit_add(t339, t340); // Eval sparse poly line_2 step + coeff_3 * z^3
    let t342 = circuit_mul(t291, t5); // Eval sparse poly line_2 step coeff_7 * z^7
    let t343 = circuit_add(t341, t342); // Eval sparse poly line_2 step + coeff_7 * z^7
    let t344 = circuit_mul(t292, t7); // Eval sparse poly line_2 step coeff_9 * z^9
    let t345 = circuit_add(t343, t344); // Eval sparse poly line_2 step + coeff_9 * z^9
    let t346 = circuit_mul(t337, t345);
    let t347 = circuit_sub(t346, t135);
    let t348 = circuit_mul(t112, t347); // c_n_minus_2 * ((Π(n-2,k) (Pk(z)) - R_n_minus_2(z))
    let t349 = circuit_mul(t135, in67);
    let t350 = circuit_mul(t349, in68);
    let t351 = circuit_mul(t350, in69);
    let t352 = circuit_mul(t351, in65);
    let t353 = circuit_sub(t352, t157);
    let t354 = circuit_mul(t113, t353); // c_n_minus_1 * ((Π(n-1,k) (Pk(z)) - R_n_minus_1(z))
    let t355 = circuit_add(in70, t348);
    let t356 = circuit_add(t355, t354);
    let t357 = circuit_mul(in73, in66); // Eval big_Q step coeff_1 * z^1
    let t358 = circuit_add(in72, t357); // Eval big_Q step + (coeff_1 * z^1)
    let t359 = circuit_mul(in74, t0); // Eval big_Q step coeff_2 * z^2
    let t360 = circuit_add(t358, t359); // Eval big_Q step + (coeff_2 * z^2)
    let t361 = circuit_mul(in75, t1); // Eval big_Q step coeff_3 * z^3
    let t362 = circuit_add(t360, t361); // Eval big_Q step + (coeff_3 * z^3)
    let t363 = circuit_mul(in76, t2); // Eval big_Q step coeff_4 * z^4
    let t364 = circuit_add(t362, t363); // Eval big_Q step + (coeff_4 * z^4)
    let t365 = circuit_mul(in77, t3); // Eval big_Q step coeff_5 * z^5
    let t366 = circuit_add(t364, t365); // Eval big_Q step + (coeff_5 * z^5)
    let t367 = circuit_mul(in78, t4); // Eval big_Q step coeff_6 * z^6
    let t368 = circuit_add(t366, t367); // Eval big_Q step + (coeff_6 * z^6)
    let t369 = circuit_mul(in79, t5); // Eval big_Q step coeff_7 * z^7
    let t370 = circuit_add(t368, t369); // Eval big_Q step + (coeff_7 * z^7)
    let t371 = circuit_mul(in80, t6); // Eval big_Q step coeff_8 * z^8
    let t372 = circuit_add(t370, t371); // Eval big_Q step + (coeff_8 * z^8)
    let t373 = circuit_mul(in81, t7); // Eval big_Q step coeff_9 * z^9
    let t374 = circuit_add(t372, t373); // Eval big_Q step + (coeff_9 * z^9)
    let t375 = circuit_mul(in82, t8); // Eval big_Q step coeff_10 * z^10
    let t376 = circuit_add(t374, t375); // Eval big_Q step + (coeff_10 * z^10)
    let t377 = circuit_mul(in83, t9); // Eval big_Q step coeff_11 * z^11
    let t378 = circuit_add(t376, t377); // Eval big_Q step + (coeff_11 * z^11)
    let t379 = circuit_mul(in84, t10); // Eval big_Q step coeff_12 * z^12
    let t380 = circuit_add(t378, t379); // Eval big_Q step + (coeff_12 * z^12)
    let t381 = circuit_mul(in85, t11); // Eval big_Q step coeff_13 * z^13
    let t382 = circuit_add(t380, t381); // Eval big_Q step + (coeff_13 * z^13)
    let t383 = circuit_mul(in86, t12); // Eval big_Q step coeff_14 * z^14
    let t384 = circuit_add(t382, t383); // Eval big_Q step + (coeff_14 * z^14)
    let t385 = circuit_mul(in87, t13); // Eval big_Q step coeff_15 * z^15
    let t386 = circuit_add(t384, t385); // Eval big_Q step + (coeff_15 * z^15)
    let t387 = circuit_mul(in88, t14); // Eval big_Q step coeff_16 * z^16
    let t388 = circuit_add(t386, t387); // Eval big_Q step + (coeff_16 * z^16)
    let t389 = circuit_mul(in89, t15); // Eval big_Q step coeff_17 * z^17
    let t390 = circuit_add(t388, t389); // Eval big_Q step + (coeff_17 * z^17)
    let t391 = circuit_mul(in90, t16); // Eval big_Q step coeff_18 * z^18
    let t392 = circuit_add(t390, t391); // Eval big_Q step + (coeff_18 * z^18)
    let t393 = circuit_mul(in91, t17); // Eval big_Q step coeff_19 * z^19
    let t394 = circuit_add(t392, t393); // Eval big_Q step + (coeff_19 * z^19)
    let t395 = circuit_mul(in92, t18); // Eval big_Q step coeff_20 * z^20
    let t396 = circuit_add(t394, t395); // Eval big_Q step + (coeff_20 * z^20)
    let t397 = circuit_mul(in93, t19); // Eval big_Q step coeff_21 * z^21
    let t398 = circuit_add(t396, t397); // Eval big_Q step + (coeff_21 * z^21)
    let t399 = circuit_mul(in94, t20); // Eval big_Q step coeff_22 * z^22
    let t400 = circuit_add(t398, t399); // Eval big_Q step + (coeff_22 * z^22)
    let t401 = circuit_mul(in95, t21); // Eval big_Q step coeff_23 * z^23
    let t402 = circuit_add(t400, t401); // Eval big_Q step + (coeff_23 * z^23)
    let t403 = circuit_mul(in96, t22); // Eval big_Q step coeff_24 * z^24
    let t404 = circuit_add(t402, t403); // Eval big_Q step + (coeff_24 * z^24)
    let t405 = circuit_mul(in97, t23); // Eval big_Q step coeff_25 * z^25
    let t406 = circuit_add(t404, t405); // Eval big_Q step + (coeff_25 * z^25)
    let t407 = circuit_mul(in98, t24); // Eval big_Q step coeff_26 * z^26
    let t408 = circuit_add(t406, t407); // Eval big_Q step + (coeff_26 * z^26)
    let t409 = circuit_mul(in99, t25); // Eval big_Q step coeff_27 * z^27
    let t410 = circuit_add(t408, t409); // Eval big_Q step + (coeff_27 * z^27)
    let t411 = circuit_mul(in100, t26); // Eval big_Q step coeff_28 * z^28
    let t412 = circuit_add(t410, t411); // Eval big_Q step + (coeff_28 * z^28)
    let t413 = circuit_mul(in101, t27); // Eval big_Q step coeff_29 * z^29
    let t414 = circuit_add(t412, t413); // Eval big_Q step + (coeff_29 * z^29)
    let t415 = circuit_mul(in102, t28); // Eval big_Q step coeff_30 * z^30
    let t416 = circuit_add(t414, t415); // Eval big_Q step + (coeff_30 * z^30)
    let t417 = circuit_mul(in103, t29); // Eval big_Q step coeff_31 * z^31
    let t418 = circuit_add(t416, t417); // Eval big_Q step + (coeff_31 * z^31)
    let t419 = circuit_mul(in104, t30); // Eval big_Q step coeff_32 * z^32
    let t420 = circuit_add(t418, t419); // Eval big_Q step + (coeff_32 * z^32)
    let t421 = circuit_mul(in105, t31); // Eval big_Q step coeff_33 * z^33
    let t422 = circuit_add(t420, t421); // Eval big_Q step + (coeff_33 * z^33)
    let t423 = circuit_mul(in106, t32); // Eval big_Q step coeff_34 * z^34
    let t424 = circuit_add(t422, t423); // Eval big_Q step + (coeff_34 * z^34)
    let t425 = circuit_mul(in107, t33); // Eval big_Q step coeff_35 * z^35
    let t426 = circuit_add(t424, t425); // Eval big_Q step + (coeff_35 * z^35)
    let t427 = circuit_mul(in108, t34); // Eval big_Q step coeff_36 * z^36
    let t428 = circuit_add(t426, t427); // Eval big_Q step + (coeff_36 * z^36)
    let t429 = circuit_mul(in109, t35); // Eval big_Q step coeff_37 * z^37
    let t430 = circuit_add(t428, t429); // Eval big_Q step + (coeff_37 * z^37)
    let t431 = circuit_mul(in110, t36); // Eval big_Q step coeff_38 * z^38
    let t432 = circuit_add(t430, t431); // Eval big_Q step + (coeff_38 * z^38)
    let t433 = circuit_mul(in111, t37); // Eval big_Q step coeff_39 * z^39
    let t434 = circuit_add(t432, t433); // Eval big_Q step + (coeff_39 * z^39)
    let t435 = circuit_mul(in112, t38); // Eval big_Q step coeff_40 * z^40
    let t436 = circuit_add(t434, t435); // Eval big_Q step + (coeff_40 * z^40)
    let t437 = circuit_mul(in113, t39); // Eval big_Q step coeff_41 * z^41
    let t438 = circuit_add(t436, t437); // Eval big_Q step + (coeff_41 * z^41)
    let t439 = circuit_mul(in114, t40); // Eval big_Q step coeff_42 * z^42
    let t440 = circuit_add(t438, t439); // Eval big_Q step + (coeff_42 * z^42)
    let t441 = circuit_mul(in115, t41); // Eval big_Q step coeff_43 * z^43
    let t442 = circuit_add(t440, t441); // Eval big_Q step + (coeff_43 * z^43)
    let t443 = circuit_mul(in116, t42); // Eval big_Q step coeff_44 * z^44
    let t444 = circuit_add(t442, t443); // Eval big_Q step + (coeff_44 * z^44)
    let t445 = circuit_mul(in117, t43); // Eval big_Q step coeff_45 * z^45
    let t446 = circuit_add(t444, t445); // Eval big_Q step + (coeff_45 * z^45)
    let t447 = circuit_mul(in118, t44); // Eval big_Q step coeff_46 * z^46
    let t448 = circuit_add(t446, t447); // Eval big_Q step + (coeff_46 * z^46)
    let t449 = circuit_mul(in119, t45); // Eval big_Q step coeff_47 * z^47
    let t450 = circuit_add(t448, t449); // Eval big_Q step + (coeff_47 * z^47)
    let t451 = circuit_mul(in120, t46); // Eval big_Q step coeff_48 * z^48
    let t452 = circuit_add(t450, t451); // Eval big_Q step + (coeff_48 * z^48)
    let t453 = circuit_mul(in121, t47); // Eval big_Q step coeff_49 * z^49
    let t454 = circuit_add(t452, t453); // Eval big_Q step + (coeff_49 * z^49)
    let t455 = circuit_mul(in122, t48); // Eval big_Q step coeff_50 * z^50
    let t456 = circuit_add(t454, t455); // Eval big_Q step + (coeff_50 * z^50)
    let t457 = circuit_mul(in123, t49); // Eval big_Q step coeff_51 * z^51
    let t458 = circuit_add(t456, t457); // Eval big_Q step + (coeff_51 * z^51)
    let t459 = circuit_mul(in124, t50); // Eval big_Q step coeff_52 * z^52
    let t460 = circuit_add(t458, t459); // Eval big_Q step + (coeff_52 * z^52)
    let t461 = circuit_mul(in125, t51); // Eval big_Q step coeff_53 * z^53
    let t462 = circuit_add(t460, t461); // Eval big_Q step + (coeff_53 * z^53)
    let t463 = circuit_mul(in126, t52); // Eval big_Q step coeff_54 * z^54
    let t464 = circuit_add(t462, t463); // Eval big_Q step + (coeff_54 * z^54)
    let t465 = circuit_mul(in127, t53); // Eval big_Q step coeff_55 * z^55
    let t466 = circuit_add(t464, t465); // Eval big_Q step + (coeff_55 * z^55)
    let t467 = circuit_mul(in128, t54); // Eval big_Q step coeff_56 * z^56
    let t468 = circuit_add(t466, t467); // Eval big_Q step + (coeff_56 * z^56)
    let t469 = circuit_mul(in129, t55); // Eval big_Q step coeff_57 * z^57
    let t470 = circuit_add(t468, t469); // Eval big_Q step + (coeff_57 * z^57)
    let t471 = circuit_mul(in130, t56); // Eval big_Q step coeff_58 * z^58
    let t472 = circuit_add(t470, t471); // Eval big_Q step + (coeff_58 * z^58)
    let t473 = circuit_mul(in131, t57); // Eval big_Q step coeff_59 * z^59
    let t474 = circuit_add(t472, t473); // Eval big_Q step + (coeff_59 * z^59)
    let t475 = circuit_mul(in132, t58); // Eval big_Q step coeff_60 * z^60
    let t476 = circuit_add(t474, t475); // Eval big_Q step + (coeff_60 * z^60)
    let t477 = circuit_mul(in133, t59); // Eval big_Q step coeff_61 * z^61
    let t478 = circuit_add(t476, t477); // Eval big_Q step + (coeff_61 * z^61)
    let t479 = circuit_mul(in134, t60); // Eval big_Q step coeff_62 * z^62
    let t480 = circuit_add(t478, t479); // Eval big_Q step + (coeff_62 * z^62)
    let t481 = circuit_mul(in135, t61); // Eval big_Q step coeff_63 * z^63
    let t482 = circuit_add(t480, t481); // Eval big_Q step + (coeff_63 * z^63)
    let t483 = circuit_mul(in136, t62); // Eval big_Q step coeff_64 * z^64
    let t484 = circuit_add(t482, t483); // Eval big_Q step + (coeff_64 * z^64)
    let t485 = circuit_mul(in137, t63); // Eval big_Q step coeff_65 * z^65
    let t486 = circuit_add(t484, t485); // Eval big_Q step + (coeff_65 * z^65)
    let t487 = circuit_mul(in138, t64); // Eval big_Q step coeff_66 * z^66
    let t488 = circuit_add(t486, t487); // Eval big_Q step + (coeff_66 * z^66)
    let t489 = circuit_mul(in139, t65); // Eval big_Q step coeff_67 * z^67
    let t490 = circuit_add(t488, t489); // Eval big_Q step + (coeff_67 * z^67)
    let t491 = circuit_mul(in140, t66); // Eval big_Q step coeff_68 * z^68
    let t492 = circuit_add(t490, t491); // Eval big_Q step + (coeff_68 * z^68)
    let t493 = circuit_mul(in141, t67); // Eval big_Q step coeff_69 * z^69
    let t494 = circuit_add(t492, t493); // Eval big_Q step + (coeff_69 * z^69)
    let t495 = circuit_mul(in142, t68); // Eval big_Q step coeff_70 * z^70
    let t496 = circuit_add(t494, t495); // Eval big_Q step + (coeff_70 * z^70)
    let t497 = circuit_mul(in143, t69); // Eval big_Q step coeff_71 * z^71
    let t498 = circuit_add(t496, t497); // Eval big_Q step + (coeff_71 * z^71)
    let t499 = circuit_mul(in144, t70); // Eval big_Q step coeff_72 * z^72
    let t500 = circuit_add(t498, t499); // Eval big_Q step + (coeff_72 * z^72)
    let t501 = circuit_mul(in145, t71); // Eval big_Q step coeff_73 * z^73
    let t502 = circuit_add(t500, t501); // Eval big_Q step + (coeff_73 * z^73)
    let t503 = circuit_mul(in146, t72); // Eval big_Q step coeff_74 * z^74
    let t504 = circuit_add(t502, t503); // Eval big_Q step + (coeff_74 * z^74)
    let t505 = circuit_mul(in147, t73); // Eval big_Q step coeff_75 * z^75
    let t506 = circuit_add(t504, t505); // Eval big_Q step + (coeff_75 * z^75)
    let t507 = circuit_mul(in148, t74); // Eval big_Q step coeff_76 * z^76
    let t508 = circuit_add(t506, t507); // Eval big_Q step + (coeff_76 * z^76)
    let t509 = circuit_mul(in149, t75); // Eval big_Q step coeff_77 * z^77
    let t510 = circuit_add(t508, t509); // Eval big_Q step + (coeff_77 * z^77)
    let t511 = circuit_mul(in150, t76); // Eval big_Q step coeff_78 * z^78
    let t512 = circuit_add(t510, t511); // Eval big_Q step + (coeff_78 * z^78)
    let t513 = circuit_mul(in151, t77); // Eval big_Q step coeff_79 * z^79
    let t514 = circuit_add(t512, t513); // Eval big_Q step + (coeff_79 * z^79)
    let t515 = circuit_mul(in152, t78); // Eval big_Q step coeff_80 * z^80
    let t516 = circuit_add(t514, t515); // Eval big_Q step + (coeff_80 * z^80)
    let t517 = circuit_mul(in153, t79); // Eval big_Q step coeff_81 * z^81
    let t518 = circuit_add(t516, t517); // Eval big_Q step + (coeff_81 * z^81)
    let t519 = circuit_mul(in154, t80); // Eval big_Q step coeff_82 * z^82
    let t520 = circuit_add(t518, t519); // Eval big_Q step + (coeff_82 * z^82)
    let t521 = circuit_mul(in155, t81); // Eval big_Q step coeff_83 * z^83
    let t522 = circuit_add(t520, t521); // Eval big_Q step + (coeff_83 * z^83)
    let t523 = circuit_mul(in156, t82); // Eval big_Q step coeff_84 * z^84
    let t524 = circuit_add(t522, t523); // Eval big_Q step + (coeff_84 * z^84)
    let t525 = circuit_mul(in157, t83); // Eval big_Q step coeff_85 * z^85
    let t526 = circuit_add(t524, t525); // Eval big_Q step + (coeff_85 * z^85)
    let t527 = circuit_mul(in158, t84); // Eval big_Q step coeff_86 * z^86
    let t528 = circuit_add(t526, t527); // Eval big_Q step + (coeff_86 * z^86)
    let t529 = circuit_mul(in159, t85); // Eval big_Q step coeff_87 * z^87
    let t530 = circuit_add(t528, t529); // Eval big_Q step + (coeff_87 * z^87)
    let t531 = circuit_mul(in160, t86); // Eval big_Q step coeff_88 * z^88
    let t532 = circuit_add(t530, t531); // Eval big_Q step + (coeff_88 * z^88)
    let t533 = circuit_mul(in161, t87); // Eval big_Q step coeff_89 * z^89
    let t534 = circuit_add(t532, t533); // Eval big_Q step + (coeff_89 * z^89)
    let t535 = circuit_mul(in162, t88); // Eval big_Q step coeff_90 * z^90
    let t536 = circuit_add(t534, t535); // Eval big_Q step + (coeff_90 * z^90)
    let t537 = circuit_mul(in163, t89); // Eval big_Q step coeff_91 * z^91
    let t538 = circuit_add(t536, t537); // Eval big_Q step + (coeff_91 * z^91)
    let t539 = circuit_mul(in164, t90); // Eval big_Q step coeff_92 * z^92
    let t540 = circuit_add(t538, t539); // Eval big_Q step + (coeff_92 * z^92)
    let t541 = circuit_mul(in165, t91); // Eval big_Q step coeff_93 * z^93
    let t542 = circuit_add(t540, t541); // Eval big_Q step + (coeff_93 * z^93)
    let t543 = circuit_mul(in166, t92); // Eval big_Q step coeff_94 * z^94
    let t544 = circuit_add(t542, t543); // Eval big_Q step + (coeff_94 * z^94)
    let t545 = circuit_mul(in167, t93); // Eval big_Q step coeff_95 * z^95
    let t546 = circuit_add(t544, t545); // Eval big_Q step + (coeff_95 * z^95)
    let t547 = circuit_mul(in168, t94); // Eval big_Q step coeff_96 * z^96
    let t548 = circuit_add(t546, t547); // Eval big_Q step + (coeff_96 * z^96)
    let t549 = circuit_mul(in169, t95); // Eval big_Q step coeff_97 * z^97
    let t550 = circuit_add(t548, t549); // Eval big_Q step + (coeff_97 * z^97)
    let t551 = circuit_mul(in170, t96); // Eval big_Q step coeff_98 * z^98
    let t552 = circuit_add(t550, t551); // Eval big_Q step + (coeff_98 * z^98)
    let t553 = circuit_mul(in171, t97); // Eval big_Q step coeff_99 * z^99
    let t554 = circuit_add(t552, t553); // Eval big_Q step + (coeff_99 * z^99)
    let t555 = circuit_mul(in172, t98); // Eval big_Q step coeff_100 * z^100
    let t556 = circuit_add(t554, t555); // Eval big_Q step + (coeff_100 * z^100)
    let t557 = circuit_mul(in173, t99); // Eval big_Q step coeff_101 * z^101
    let t558 = circuit_add(t556, t557); // Eval big_Q step + (coeff_101 * z^101)
    let t559 = circuit_mul(in174, t100); // Eval big_Q step coeff_102 * z^102
    let t560 = circuit_add(t558, t559); // Eval big_Q step + (coeff_102 * z^102)
    let t561 = circuit_mul(in175, t101); // Eval big_Q step coeff_103 * z^103
    let t562 = circuit_add(t560, t561); // Eval big_Q step + (coeff_103 * z^103)
    let t563 = circuit_mul(in176, t102); // Eval big_Q step coeff_104 * z^104
    let t564 = circuit_add(t562, t563); // Eval big_Q step + (coeff_104 * z^104)
    let t565 = circuit_mul(in177, t103); // Eval big_Q step coeff_105 * z^105
    let t566 = circuit_add(t564, t565); // Eval big_Q step + (coeff_105 * z^105)
    let t567 = circuit_mul(in178, t104); // Eval big_Q step coeff_106 * z^106
    let t568 = circuit_add(t566, t567); // Eval big_Q step + (coeff_106 * z^106)
    let t569 = circuit_mul(in179, t105); // Eval big_Q step coeff_107 * z^107
    let t570 = circuit_add(t568, t569); // Eval big_Q step + (coeff_107 * z^107)
    let t571 = circuit_mul(in180, t106); // Eval big_Q step coeff_108 * z^108
    let t572 = circuit_add(t570, t571); // Eval big_Q step + (coeff_108 * z^108)
    let t573 = circuit_mul(in181, t107); // Eval big_Q step coeff_109 * z^109
    let t574 = circuit_add(t572, t573); // Eval big_Q step + (coeff_109 * z^109)
    let t575 = circuit_mul(in182, t108); // Eval big_Q step coeff_110 * z^110
    let t576 = circuit_add(t574, t575); // Eval big_Q step + (coeff_110 * z^110)
    let t577 = circuit_mul(in183, t109); // Eval big_Q step coeff_111 * z^111
    let t578 = circuit_add(t576, t577); // Eval big_Q step + (coeff_111 * z^111)
    let t579 = circuit_mul(in184, t110); // Eval big_Q step coeff_112 * z^112
    let t580 = circuit_add(t578, t579); // Eval big_Q step + (coeff_112 * z^112)
    let t581 = circuit_mul(in185, t111); // Eval big_Q step coeff_113 * z^113
    let t582 = circuit_add(t580, t581); // Eval big_Q step + (coeff_113 * z^113)
    let t583 = circuit_mul(in9, t4); // Eval sparse poly P_irr step coeff_6 * z^6
    let t584 = circuit_add(in8, t583); // Eval sparse poly P_irr step + coeff_6 * z^6
    let t585 = circuit_add(t584, t10); // Eval sparse poly P_irr step + 1*z^12
    let t586 = circuit_mul(t582, t585);
    let t587 = circuit_sub(t356, t586);

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [32324006162389411176778628423, 57042285082623239461879769745, 3486998266802970665, 0]
    )
        .unwrap();

    let mut circuit_inputs = (t587,).new_inputs();
    // Prefill constants:
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
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x6871ca8d3c208c16d87cfd3e, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0]);
    circuit_inputs = circuit_inputs.next([0x52, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x6871ca8d3c208c16d87cfd35, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0]);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(line_1_0.r0a0);
    circuit_inputs = circuit_inputs.next(line_1_0.r0a1);
    circuit_inputs = circuit_inputs.next(line_1_0.r1a0);
    circuit_inputs = circuit_inputs.next(line_1_0.r1a1);
    circuit_inputs = circuit_inputs.next(line_2_0.r0a0);
    circuit_inputs = circuit_inputs.next(line_2_0.r0a1);
    circuit_inputs = circuit_inputs.next(line_2_0.r1a0);
    circuit_inputs = circuit_inputs.next(line_2_0.r1a1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(line_1_1.r0a0);
    circuit_inputs = circuit_inputs.next(line_1_1.r0a1);
    circuit_inputs = circuit_inputs.next(line_1_1.r1a0);
    circuit_inputs = circuit_inputs.next(line_1_1.r1a1);
    circuit_inputs = circuit_inputs.next(line_2_1.r0a0);
    circuit_inputs = circuit_inputs.next(line_2_1.r0a1);
    circuit_inputs = circuit_inputs.next(line_2_1.r1a0);
    circuit_inputs = circuit_inputs.next(line_2_1.r1a1);
    circuit_inputs = circuit_inputs.next(original_Q2.x0);
    circuit_inputs = circuit_inputs.next(original_Q2.x1);
    circuit_inputs = circuit_inputs.next(original_Q2.y0);
    circuit_inputs = circuit_inputs.next(original_Q2.y1);
    circuit_inputs = circuit_inputs.next(yInv_2);
    circuit_inputs = circuit_inputs.next(xNegOverY_2);
    circuit_inputs = circuit_inputs.next(Q_2.x0);
    circuit_inputs = circuit_inputs.next(Q_2.x1);
    circuit_inputs = circuit_inputs.next(Q_2.y0);
    circuit_inputs = circuit_inputs.next(Q_2.y1);
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
    let final_check: u384 = outputs.get_output(t587);
    return (final_check,);
}
fn run_BN254_GROTH16_INIT_BIT_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    G2_line_0: G2Line,
    yInv_1: u384,
    xNegOverY_1: u384,
    G2_line_1: G2Line,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q_2: G2Point,
    R_i: E12D,
    c0: u384,
    z: u384,
    c_inv_of_z: u384,
    previous_lhs: u384
) -> (G2Point, u384, u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // -0x9 % p
    let in1 = CE::<CI<1>> {}; // 0x1
    let in2 = CE::<CI<2>> {}; // 0x3
    let in3 = CE::<CI<3>> {}; // 0x6
    let in4 = CE::<CI<4>> {}; // 0x0

    // INPUT stack
    let (in5, in6) = (CE::<CI<5>> {}, CE::<CI<6>> {});
    let (in7, in8) = (CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10) = (CE::<CI<9>> {}, CE::<CI<10>> {});
    let (in11, in12) = (CE::<CI<11>> {}, CE::<CI<12>> {});
    let (in13, in14) = (CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16) = (CE::<CI<15>> {}, CE::<CI<16>> {});
    let (in17, in18) = (CE::<CI<17>> {}, CE::<CI<18>> {});
    let (in19, in20) = (CE::<CI<19>> {}, CE::<CI<20>> {});
    let (in21, in22) = (CE::<CI<21>> {}, CE::<CI<22>> {});
    let (in23, in24) = (CE::<CI<23>> {}, CE::<CI<24>> {});
    let (in25, in26) = (CE::<CI<25>> {}, CE::<CI<26>> {});
    let (in27, in28) = (CE::<CI<27>> {}, CE::<CI<28>> {});
    let (in29, in30) = (CE::<CI<29>> {}, CE::<CI<30>> {});
    let (in31, in32) = (CE::<CI<31>> {}, CE::<CI<32>> {});
    let (in33, in34) = (CE::<CI<33>> {}, CE::<CI<34>> {});
    let (in35, in36) = (CE::<CI<35>> {}, CE::<CI<36>> {});
    let (in37, in38) = (CE::<CI<37>> {}, CE::<CI<38>> {});
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
    let t10 = circuit_mul(in24, in36); // Eval R step coeff_1 * z^1
    let t11 = circuit_add(in23, t10); // Eval R step + (coeff_1 * z^1)
    let t12 = circuit_mul(in25, t0); // Eval R step coeff_2 * z^2
    let t13 = circuit_add(t11, t12); // Eval R step + (coeff_2 * z^2)
    let t14 = circuit_mul(in26, t1); // Eval R step coeff_3 * z^3
    let t15 = circuit_add(t13, t14); // Eval R step + (coeff_3 * z^3)
    let t16 = circuit_mul(in27, t2); // Eval R step coeff_4 * z^4
    let t17 = circuit_add(t15, t16); // Eval R step + (coeff_4 * z^4)
    let t18 = circuit_mul(in28, t3); // Eval R step coeff_5 * z^5
    let t19 = circuit_add(t17, t18); // Eval R step + (coeff_5 * z^5)
    let t20 = circuit_mul(in29, t4); // Eval R step coeff_6 * z^6
    let t21 = circuit_add(t19, t20); // Eval R step + (coeff_6 * z^6)
    let t22 = circuit_mul(in30, t5); // Eval R step coeff_7 * z^7
    let t23 = circuit_add(t21, t22); // Eval R step + (coeff_7 * z^7)
    let t24 = circuit_mul(in31, t6); // Eval R step coeff_8 * z^8
    let t25 = circuit_add(t23, t24); // Eval R step + (coeff_8 * z^8)
    let t26 = circuit_mul(in32, t7); // Eval R step coeff_9 * z^9
    let t27 = circuit_add(t25, t26); // Eval R step + (coeff_9 * z^9)
    let t28 = circuit_mul(in33, t8); // Eval R step coeff_10 * z^10
    let t29 = circuit_add(t27, t28); // Eval R step + (coeff_10 * z^10)
    let t30 = circuit_mul(in34, t9); // Eval R step coeff_11 * z^11
    let t31 = circuit_add(t29, t30); // Eval R step + (coeff_11 * z^11)
    let t32 = circuit_mul(in37, in37);
    let t33 = circuit_mul(in35, in35);
    let t34 = circuit_mul(in0, in8);
    let t35 = circuit_add(in7, t34);
    let t36 = circuit_mul(t35, in6);
    let t37 = circuit_mul(in0, in10);
    let t38 = circuit_add(in9, t37);
    let t39 = circuit_mul(t38, in5);
    let t40 = circuit_mul(in8, in6);
    let t41 = circuit_mul(in10, in5);
    let t42 = circuit_mul(t36, in36); // Eval sparse poly line_0p_1 step coeff_1 * z^1
    let t43 = circuit_add(in1, t42); // Eval sparse poly line_0p_1 step + coeff_1 * z^1
    let t44 = circuit_mul(t39, t1); // Eval sparse poly line_0p_1 step coeff_3 * z^3
    let t45 = circuit_add(t43, t44); // Eval sparse poly line_0p_1 step + coeff_3 * z^3
    let t46 = circuit_mul(t40, t5); // Eval sparse poly line_0p_1 step coeff_7 * z^7
    let t47 = circuit_add(t45, t46); // Eval sparse poly line_0p_1 step + coeff_7 * z^7
    let t48 = circuit_mul(t41, t7); // Eval sparse poly line_0p_1 step coeff_9 * z^9
    let t49 = circuit_add(t47, t48); // Eval sparse poly line_0p_1 step + coeff_9 * z^9
    let t50 = circuit_mul(t32, t49);
    let t51 = circuit_mul(in0, in14);
    let t52 = circuit_add(in13, t51);
    let t53 = circuit_mul(t52, in12);
    let t54 = circuit_mul(in0, in16);
    let t55 = circuit_add(in15, t54);
    let t56 = circuit_mul(t55, in11);
    let t57 = circuit_mul(in14, in12);
    let t58 = circuit_mul(in16, in11);
    let t59 = circuit_mul(t53, in36); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t60 = circuit_add(in1, t59); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t61 = circuit_mul(t56, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t62 = circuit_add(t60, t61); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t63 = circuit_mul(t57, t5); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t64 = circuit_add(t62, t63); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t65 = circuit_mul(t58, t7); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t66 = circuit_add(t64, t65); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t67 = circuit_mul(t50, t66);
    let t68 = circuit_add(in19, in20); // Doubling slope numerator start
    let t69 = circuit_sub(in19, in20);
    let t70 = circuit_mul(t68, t69);
    let t71 = circuit_mul(in19, in20);
    let t72 = circuit_mul(t70, in2);
    let t73 = circuit_mul(t71, in3); // Doubling slope numerator end
    let t74 = circuit_add(in21, in21); // Fp2 add coeff 0/1
    let t75 = circuit_add(in22, in22); // Fp2 add coeff 1/1
    let t76 = circuit_mul(t74, t74); // Fp2 Div x/y start : Fp2 Inv y start
    let t77 = circuit_mul(t75, t75);
    let t78 = circuit_add(t76, t77);
    let t79 = circuit_inverse(t78);
    let t80 = circuit_mul(t74, t79); // Fp2 Inv y real part end
    let t81 = circuit_mul(t75, t79);
    let t82 = circuit_sub(in4, t81); // Fp2 Inv y imag part end
    let t83 = circuit_mul(t72, t80); // Fp2 mul start
    let t84 = circuit_mul(t73, t82);
    let t85 = circuit_sub(t83, t84); // Fp2 mul real part end
    let t86 = circuit_mul(t72, t82);
    let t87 = circuit_mul(t73, t80);
    let t88 = circuit_add(t86, t87); // Fp2 mul imag part end
    let t89 = circuit_add(t85, t88);
    let t90 = circuit_sub(t85, t88);
    let t91 = circuit_mul(t89, t90);
    let t92 = circuit_mul(t85, t88);
    let t93 = circuit_add(t92, t92);
    let t94 = circuit_add(in19, in19); // Fp2 add coeff 0/1
    let t95 = circuit_add(in20, in20); // Fp2 add coeff 1/1
    let t96 = circuit_sub(t91, t94); // Fp2 sub coeff 0/1
    let t97 = circuit_sub(t93, t95); // Fp2 sub coeff 1/1
    let t98 = circuit_sub(in19, t96); // Fp2 sub coeff 0/1
    let t99 = circuit_sub(in20, t97); // Fp2 sub coeff 1/1
    let t100 = circuit_mul(t85, t98); // Fp2 mul start
    let t101 = circuit_mul(t88, t99);
    let t102 = circuit_sub(t100, t101); // Fp2 mul real part end
    let t103 = circuit_mul(t85, t99);
    let t104 = circuit_mul(t88, t98);
    let t105 = circuit_add(t103, t104); // Fp2 mul imag part end
    let t106 = circuit_sub(t102, in21); // Fp2 sub coeff 0/1
    let t107 = circuit_sub(t105, in22); // Fp2 sub coeff 1/1
    let t108 = circuit_mul(t85, in19); // Fp2 mul start
    let t109 = circuit_mul(t88, in20);
    let t110 = circuit_sub(t108, t109); // Fp2 mul real part end
    let t111 = circuit_mul(t85, in20);
    let t112 = circuit_mul(t88, in19);
    let t113 = circuit_add(t111, t112); // Fp2 mul imag part end
    let t114 = circuit_sub(t110, in21); // Fp2 sub coeff 0/1
    let t115 = circuit_sub(t113, in22); // Fp2 sub coeff 1/1
    let t116 = circuit_mul(in0, t88);
    let t117 = circuit_add(t85, t116);
    let t118 = circuit_mul(t117, in18);
    let t119 = circuit_mul(in0, t115);
    let t120 = circuit_add(t114, t119);
    let t121 = circuit_mul(t120, in17);
    let t122 = circuit_mul(t88, in18);
    let t123 = circuit_mul(t115, in17);
    let t124 = circuit_mul(t118, in36); // Eval sparse poly line_2p_1 step coeff_1 * z^1
    let t125 = circuit_add(in1, t124); // Eval sparse poly line_2p_1 step + coeff_1 * z^1
    let t126 = circuit_mul(t121, t1); // Eval sparse poly line_2p_1 step coeff_3 * z^3
    let t127 = circuit_add(t125, t126); // Eval sparse poly line_2p_1 step + coeff_3 * z^3
    let t128 = circuit_mul(t122, t5); // Eval sparse poly line_2p_1 step coeff_7 * z^7
    let t129 = circuit_add(t127, t128); // Eval sparse poly line_2p_1 step + coeff_7 * z^7
    let t130 = circuit_mul(t123, t7); // Eval sparse poly line_2p_1 step coeff_9 * z^9
    let t131 = circuit_add(t129, t130); // Eval sparse poly line_2p_1 step + coeff_9 * z^9
    let t132 = circuit_mul(t67, t131);
    let t133 = circuit_sub(t132, t31);
    let t134 = circuit_mul(t33, t133); // ci * ((Π(i,k) (Pk(z)) - Ri(z))
    let t135 = circuit_add(t134, in38);

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [32324006162389411176778628423, 57042285082623239461879769745, 3486998266802970665, 0]
    )
        .unwrap();

    let mut circuit_inputs = (t96, t97, t106, t107, t135, t33, t31,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs
        .next([0x6871ca8d3c208c16d87cfd3e, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0]);
    circuit_inputs = circuit_inputs.next([0x1, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x6, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(G2_line_0.r0a0);
    circuit_inputs = circuit_inputs.next(G2_line_0.r0a1);
    circuit_inputs = circuit_inputs.next(G2_line_0.r1a0);
    circuit_inputs = circuit_inputs.next(G2_line_0.r1a1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(G2_line_1.r0a0);
    circuit_inputs = circuit_inputs.next(G2_line_1.r0a1);
    circuit_inputs = circuit_inputs.next(G2_line_1.r1a0);
    circuit_inputs = circuit_inputs.next(G2_line_1.r1a1);
    circuit_inputs = circuit_inputs.next(yInv_2);
    circuit_inputs = circuit_inputs.next(xNegOverY_2);
    circuit_inputs = circuit_inputs.next(Q_2.x0);
    circuit_inputs = circuit_inputs.next(Q_2.x1);
    circuit_inputs = circuit_inputs.next(Q_2.y0);
    circuit_inputs = circuit_inputs.next(Q_2.y1);
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
    let Q2: G2Point = G2Point {
        x0: outputs.get_output(t96),
        x1: outputs.get_output(t97),
        y0: outputs.get_output(t106),
        y1: outputs.get_output(t107)
    };
    let new_lhs: u384 = outputs.get_output(t135);
    let c_i: u384 = outputs.get_output(t33);
    let f_i_plus_one_of_z: u384 = outputs.get_output(t31);
    return (Q2, new_lhs, c_i, f_i_plus_one_of_z);
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
        MillerLoopResultScalingFactor, G2Line
    };
    use garaga::ec_ops::{SlopeInterceptOutput, FunctionFeltEvaluations, FunctionFelt};

    use super::{
        run_BLS12_381_GROTH16_BIT00_LOOP_circuit, run_BLS12_381_GROTH16_BIT0_LOOP_circuit,
        run_BLS12_381_GROTH16_BIT1_LOOP_circuit, run_BLS12_381_GROTH16_FINALIZE_BLS_circuit,
        run_BLS12_381_GROTH16_INIT_BIT_circuit, run_BN254_GROTH16_BIT00_LOOP_circuit,
        run_BN254_GROTH16_BIT0_LOOP_circuit, run_BN254_GROTH16_BIT1_LOOP_circuit,
        run_BN254_GROTH16_FINALIZE_BN_circuit, run_BN254_GROTH16_INIT_BIT_circuit
    };


    #[test]
    fn test_run_BLS12_381_GROTH16_BIT00_LOOP_circuit_BLS12_381() {
        let yInv_0: u384 = u384 {
            limb0: 0x549fb2142ae4f71bf91e6fef,
            limb1: 0x6ec688d45ad685414605dc4a,
            limb2: 0x2c2b9c0749c7c9e83bec0480,
            limb3: 0x10f2e0cae9350d7ac4a18547
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0x9b7a43bd900a2b50d3582dfd,
            limb1: 0xb2ae050e17c7e8556c0a552c,
            limb2: 0x33f33b002d3145273eb853b5,
            limb3: 0xa1c3fbb86c30047d7589cc6
        };

        let G2_line_0: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0xac0d670f053842f54ae3696c,
                limb1: 0xcd58c31f697550869c0130a7,
                limb2: 0x49cff23df246f186355f08d7,
                limb3: 0x131ba25bbf6c4df4535bcb48
            },
            r0a1: u384 {
                limb0: 0x2fc0f1f7f337fa387814041d,
                limb1: 0x81ebb5613fae217e9e2d720d,
                limb2: 0xa18df6f5149f39720502629d,
                limb3: 0x138cb06d8e9a6a56e6aae560
            },
            r1a0: u384 {
                limb0: 0x7a299619d5243973cb8e1c51,
                limb1: 0x6490e67cafe03071b278bbd5,
                limb2: 0xb88d3f79a54c0f21f7d2c902,
                limb3: 0xd14c74d387c8fe7669a0321
            },
            r1a1: u384 {
                limb0: 0x5efefc739c41905ab65642ef,
                limb1: 0xc2f991676a71a0e5246b21c4,
                limb2: 0x5dbcc6f45de954714d609cc6,
                limb3: 0x522c4485fc8b9cd1269fc4d
            }
        };

        let G2_line_2nd_0_0: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0x12e6fb90d1278f8bbb9f7d3f,
                limb1: 0x5cf9cd2fd91ceddba5e45540,
                limb2: 0x3ae8446f85e9ec369abb8c14,
                limb3: 0xc213ca2af079b76f2b762c6
            },
            r0a1: u384 {
                limb0: 0x1b078fe5fe3a2fc50b81f595,
                limb1: 0x37d132f8b63fcda0e7a3bbc7,
                limb2: 0x6041c0e92512e9a3cd9f753a,
                limb3: 0x3861d7536aef2f829ff4621
            },
            r1a0: u384 {
                limb0: 0x7da69555f78ef166fb2fbde5,
                limb1: 0x3d17bfd0baa227b8b398d5d3,
                limb2: 0x2ebe8dcb6401b180301f5124,
                limb3: 0x10245f6760b8024401e32354
            },
            r1a1: u384 {
                limb0: 0xa16b347d9babbdab0e1cae7a,
                limb1: 0xf0eb1008d44b5548066dee1e,
                limb2: 0xba61b9c478676fc0188f4a1c,
                limb3: 0x1271dfe89080bfb52cb214c6
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0xb1d0b55dd0b6a48fd00219cc,
            limb1: 0x76ee2ddbc4c2d4c1f31a3875,
            limb2: 0x2f81acd8e4add59e050897d1,
            limb3: 0xf201e22e10866bb4210074a
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0x449c8ebf821593c8c44ac09a,
            limb1: 0x3612461fbc6d374a86610b8d,
            limb2: 0xdb1b03f39c8e4c455a2206aa,
            limb3: 0x193b25f58332a1006aa6e238
        };

        let G2_line_1: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0xb9f7303a16e4dd6a125ac749,
                limb1: 0x15261ab584dc55da90ebda85,
                limb2: 0x5f069f91a3e4ca4c6d0f744c,
                limb3: 0x7478c408520b295855d36aa
            },
            r0a1: u384 {
                limb0: 0x4c444d959c9e2ae3df58908f,
                limb1: 0xc77239f22d4750cca5c5063d,
                limb2: 0xb99e73e5a908a3aa20adb06e,
                limb3: 0x4c5715cbebebbfc089f8b86
            },
            r1a0: u384 {
                limb0: 0xfedaceb7b26215e3c79a4ef8,
                limb1: 0xb1f44884bd55c6428e52c6a,
                limb2: 0x64bd86c7916914f7539a42df,
                limb3: 0x531b4836c43988ac8480078
            },
            r1a1: u384 {
                limb0: 0x6e88e18c299e12fe095c2be6,
                limb1: 0x54ab6b3e9ea8d62e1117bacb,
                limb2: 0x88195c6af89719c4e92e63ec,
                limb3: 0x120ad08b797dc4fafd72919c
            }
        };

        let G2_line_2nd_0_1: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0xbc659d8ba4291bf9fdee4298,
                limb1: 0x5727ff52e6567325f7cf0135,
                limb2: 0xdfdd8e2db13dd1f284cc31aa,
                limb3: 0x2f6939249cebe029672134
            },
            r0a1: u384 {
                limb0: 0x2e4994937c83153ed11c91f7,
                limb1: 0x61d029cb1d6d783c066552,
                limb2: 0x51161305bf7b6b3cb1ca41c3,
                limb3: 0x1982b2187f8717173279b209
            },
            r1a0: u384 {
                limb0: 0xf2bb8a67ec5b03af8b90e059,
                limb1: 0x489d80b68057b53792ec01d0,
                limb2: 0x31692d4e9b249fa1b2645654,
                limb3: 0x87fbb5135002e8010379422
            },
            r1a1: u384 {
                limb0: 0xda4e213020794c13356b26ec,
                limb1: 0x8bd1d055efee2b4dcf557be2,
                limb2: 0x182c571c4299f3aa00925305,
                limb3: 0x130945746e832e1c7aeaf473
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 0xb4703ff7f47fa32ec3e0237d,
            limb1: 0x4683fbd442ead84ceccc2372,
            limb2: 0xb590d8304ce4e31e1b94f93a,
            limb3: 0x10adbf2201eccdba65e6d0b5
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 0xde9ac8b8640bbb28c322b4ff,
            limb1: 0x3f4255c32b73a1011493c30f,
            limb2: 0x50fa59aa27a603553af1aead,
            limb3: 0x76b484a6195ace68506d5ba
        };

        let Q_2: G2Point = G2Point {
            x0: u384 {
                limb0: 0xc6d25fcc6714224cf95cad47,
                limb1: 0x5a094c0551c756d46dda6925,
                limb2: 0x48cf1902a7b409293f266191,
                limb3: 0x53c6dae5f1e2cb74af1d4e7
            },
            x1: u384 {
                limb0: 0xcf60fea3dd37a7eb07323bec,
                limb1: 0x73bce2b964864cee10710096,
                limb2: 0x56d1578d3c0502c138bb43b9,
                limb3: 0x4c3c35a1ef0e207914f8df6
            },
            y0: u384 {
                limb0: 0x5ca01e742c8271c45d9b354a,
                limb1: 0xa4d6f5c8ea3e943acf6b084a,
                limb2: 0x67a31a9a3b9a617395fcab15,
                limb3: 0x7b318193ebd35faaa2696d2
            },
            y1: u384 {
                limb0: 0x5f3926a7c06e8bcd0fab981f,
                limb1: 0x44337b93199ac482ad2a5d17,
                limb2: 0xd7cff1baa30a3764b8d270ab,
                limb3: 0x1397e18cc039c71e00af620c
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 0xce40bea68c64ba42df6b038d,
            limb1: 0x1d936af5198326f161b90490,
            limb2: 0xaa6178a7cd8bc4a86c6df33b,
            limb3: 0x7582f03d29f27d517e03c95
        };

        let f_i_of_z: u384 = u384 {
            limb0: 0xc9467b1c8fea8d99255e73aa,
            limb1: 0xe31d4f7ef69c05fd61d25a03,
            limb2: 0x4dc6357379187f7a28e9420,
            limb3: 0x13f8dd8ec5e81460b965f4c9
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 0x134d8480f8e1e617442e0f18,
                limb1: 0x485964e523371a3f90f084af,
                limb2: 0x29974088ba3124df44f10516,
                limb3: 0x27a356d097b2105ee3c763d
            },
            w1: u384 {
                limb0: 0x1195f1f93e8f4d3c61636f81,
                limb1: 0xcdf3b2326215b52235b7df75,
                limb2: 0x57ed87b71d7ec55c5b5d451,
                limb3: 0xc2e30eebe66203207f61f43
            },
            w2: u384 {
                limb0: 0xde750cb936c4e48f436bd6b0,
                limb1: 0x1a959ee09256b4ee103eaba1,
                limb2: 0xe8dd9dd6892c34a892644788,
                limb3: 0xec2423819a7a36e417e7aec
            },
            w3: u384 {
                limb0: 0x353df2695380aebd6ee4fa35,
                limb1: 0x5452dd3861d00b6b8974021b,
                limb2: 0xd8e19c506e13d0e908c70e51,
                limb3: 0xd901c800157586ff3ef5d61
            },
            w4: u384 {
                limb0: 0x8119eab1822adcfbbd328d13,
                limb1: 0xc5d1feeb9f4933579b21db09,
                limb2: 0x251d8d80db5d5b30286a463,
                limb3: 0x14281bb4495822713aed3ef1
            },
            w5: u384 {
                limb0: 0xf0ab6022367f1513d73d4e0c,
                limb1: 0x1c6dae6f4f044779045a1c04,
                limb2: 0xaf1b0f0ffb2d92c2f13819c6,
                limb3: 0x13c9eabc6cf20ece3911f9d7
            },
            w6: u384 {
                limb0: 0x4db8f4633ed2b25dc4cd8891,
                limb1: 0x7ef1748c5e0e02828ff74652,
                limb2: 0xfb7d8c44650bc499d65acedf,
                limb3: 0x146f5a88abe757d29462fc24
            },
            w7: u384 {
                limb0: 0x3210b2eb70b67bd5c00fd95,
                limb1: 0x122ed94807296678be769b27,
                limb2: 0x44b9ddfbc48f67ce9adfc67d,
                limb3: 0xde6e4ad485ef7bb94952b3b
            },
            w8: u384 {
                limb0: 0xa7c1250b85db5447d7e9e3c2,
                limb1: 0x68fa599672034e9c29315635,
                limb2: 0x4cf2032bef1f3c47662c75fa,
                limb3: 0x8741289e13b9a759ec8d0b9
            },
            w9: u384 {
                limb0: 0xccefc4c04381c0c705aa5e40,
                limb1: 0xc5dc12d65ddd1f48b7fec468,
                limb2: 0x55bb9c97549cab972e43c67a,
                limb3: 0xe495cac5afd108b76299eef
            },
            w10: u384 {
                limb0: 0x6eed8317af88cf098c91cbc1,
                limb1: 0xb6cfbac7c21dce782e9c3e52,
                limb2: 0xed309a7d7d3eea80c6ef6bff,
                limb3: 0xb1f1b9dc62f5a04ec73711d
            },
            w11: u384 {
                limb0: 0x30c5d6702f9d66584b9d4528,
                limb1: 0x7ba554379008ada3932e3571,
                limb2: 0x6b1190efe8cf88122c575318,
                limb3: 0x18568dde04597d0edede780b
            }
        };

        let z: u384 = u384 {
            limb0: 0x790a3b6c0162e6aea5800fe0,
            limb1: 0x88447e643e62c557289e78f0,
            limb2: 0x78d2e177732a05fe3d1f8719,
            limb3: 0xcb422b19aa9e11ebdedc9b2
        };

        let ci: u384 = u384 {
            limb0: 0x681877f3b00deabc21d5e2df,
            limb1: 0x10accfc9ec8dc105c217fb0d,
            limb2: 0x898b79ba04da722485917820,
            limb3: 0x1099de8d4116bcf75c47ac00
        };

        let (Q2_result, f_i_plus_one_of_z_result, lhs_i_plus_one_result, ci_plus_one_result) =
            run_BLS12_381_GROTH16_BIT00_LOOP_circuit(
            yInv_0,
            xNegOverY_0,
            G2_line_0,
            G2_line_2nd_0_0,
            yInv_1,
            xNegOverY_1,
            G2_line_1,
            G2_line_2nd_0_1,
            yInv_2,
            xNegOverY_2,
            Q_2,
            lhs_i,
            f_i_of_z,
            f_i_plus_one,
            z,
            ci
        );
        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 0x7c915790d8b5ab001cf47864,
                limb1: 0xa31d770ca5ff7fb8572a32ec,
                limb2: 0x10fa4814e878062ba5f3dd35,
                limb3: 0xf0d735988e87b6411499dd4
            },
            x1: u384 {
                limb0: 0xf12cba1dba2d75e459b35674,
                limb1: 0xecad37e732fad058a2c38f9b,
                limb2: 0xf8ef363ea033fa0261b7b3aa,
                limb3: 0x194fbd30782298414ef530e1
            },
            y0: u384 {
                limb0: 0x534aaf167d8360d6cf243bc6,
                limb1: 0xac0c44605e1c8309dcc5d0a,
                limb2: 0xc3d6d9ca4fd8ff99c7a59786,
                limb3: 0xdb6d1969d8d0626748e0ff2
            },
            y1: u384 {
                limb0: 0xdc81230ed5a14bfc14fc93ad,
                limb1: 0xfdc384130c2291b8961ce7e0,
                limb2: 0x915b4c3fc1ead8b65e904bd4,
                limb3: 0x186487050328daf09e51b1e3
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0x48b2e185305a75b91d36560b,
            limb1: 0x3fc0e452a812bc689af6cfc8,
            limb2: 0x13eaf4b91e59e3693b01fe6c,
            limb3: 0x42eacbc3e256a5c2c1a315
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 0x91800db208f7f7d7f715069,
            limb1: 0x8e980dcd47600943232a52d5,
            limb2: 0x152bd7ecb34cab8932ef1c24,
            limb3: 0x1153105cceeaddb7f9457ec
        };

        let ci_plus_one: u384 = u384 {
            limb0: 0xa17b5240a90fe82416356e36,
            limb1: 0x67fc8e790dfbc7601e54c371,
            limb2: 0x33890ed90fb9dd78d222577c,
            limb3: 0x17853b2f30baff72e193b31f
        };
        assert_eq!(Q2_result, Q2);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
        assert_eq!(lhs_i_plus_one_result, lhs_i_plus_one);
        assert_eq!(ci_plus_one_result, ci_plus_one);
    }


    #[test]
    fn test_run_BLS12_381_GROTH16_BIT0_LOOP_circuit_BLS12_381() {
        let yInv_0: u384 = u384 {
            limb0: 0x947115e58ded3a7c0eeae85f,
            limb1: 0x820297b12b62d41c065963f2,
            limb2: 0x4a88549d4e2249237bc1a87f,
            limb3: 0xf63244a8c44605e8ccde8ad
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0xca89ad118646356bc28611fd,
            limb1: 0xdecf51f5ab32b76692738995,
            limb2: 0x98d8d5e273198250d71a78e3,
            limb3: 0x10a8ace3b7abe7b612d570a9
        };

        let G2_line_0: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0xea8f3d1f51c17a71520d9629,
                limb1: 0xf24c863bb6513595803c51a1,
                limb2: 0x578239df5b9cf89fa85b4692,
                limb3: 0x8b11a5dae1012f5d00d9045
            },
            r0a1: u384 {
                limb0: 0x70ad6c345e31f6379a1b62f8,
                limb1: 0x34412a928eb76bcaf7c188ec,
                limb2: 0x6fab7a98ac769bc0e0614d88,
                limb3: 0xbb0f4f8559395d008472231
            },
            r1a0: u384 {
                limb0: 0x32586da3b858bd5ac500cf83,
                limb1: 0x7b5564dba42e90072176f980,
                limb2: 0xba4cc0a8e0dcf37b8c013495,
                limb3: 0x9a6d8c37332c4eee98449fb
            },
            r1a1: u384 {
                limb0: 0x5a8fe4b28ffd1977c5b893b0,
                limb1: 0xc893885b2cbb85648b3941d5,
                limb2: 0x3b592941f45850e8095e2e87,
                limb3: 0x19496065c24fc3deb52739da
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0xb6eb3dc44955ededdc835261,
            limb1: 0x14943ba6562f1bd2cea9f931,
            limb2: 0x749d6142ff3fae8cda5249ff,
            limb3: 0xdb7340ff696899e22e4e6b8
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0x1718a90a80f62b31c5b0bb0d,
            limb1: 0x1161524e314f38d8f89d4123,
            limb2: 0x2c29feb08301072ef68866c6,
            limb3: 0x893375a1236cd47d10a3909
        };

        let G2_line_1: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0xbae842c8c4d1a82e64486f70,
                limb1: 0x8642891b80e1397c35640c72,
                limb2: 0xca54e75953bdfba815325a14,
                limb3: 0x42c122abe520ec1fe159cd
            },
            r0a1: u384 {
                limb0: 0x29f20864c650232095017a24,
                limb1: 0x20b6d54703fed93927642695,
                limb2: 0x2faf32d42728806cd70b0671,
                limb3: 0x6eeb7752fe5d8224ad874e8
            },
            r1a0: u384 {
                limb0: 0x9baf9167e069d95f92bb7f1f,
                limb1: 0x98f5e3810a6acd24c07b109a,
                limb2: 0xe8e94603538c2dc72df129b7,
                limb3: 0x1061731169923a40539a7e42
            },
            r1a1: u384 {
                limb0: 0xb0cc68a09747c10cdeecbce8,
                limb1: 0x84533b66c3d0df99ba72a8e8,
                limb2: 0xa4784cd5c134e4572d24fd9b,
                limb3: 0xa255536914caa43b6b09b75
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 0xc5086c324210a16d2d44a2cc,
            limb1: 0xbe2243372844a59ec246065a,
            limb2: 0x5e2e9feda30c344fd7fbbb2c,
            limb3: 0x9cb5f4f708a3ed4ee29afcc
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 0x72fa5cfb0b3ea0713d5b624b,
            limb1: 0xbbd4dbcafa53b5a763d8ccb1,
            limb2: 0x23df4a2a14128ded173e554,
            limb3: 0x1032eb97303a77db4ec29ad8
        };

        let Q_2: G2Point = G2Point {
            x0: u384 {
                limb0: 0x9826688f17107262a5b3e5fe,
                limb1: 0x59eba97d3e954ee8f8e5d3fe,
                limb2: 0x2eaff555e3621fc63bd4c612,
                limb3: 0xac678691715558743568c9a
            },
            x1: u384 {
                limb0: 0xd30b748ae64b57ce2b919302,
                limb1: 0xa4e5a7e79526d2fced9ac510,
                limb2: 0x154ba14697c2ab1deb91da1a,
                limb3: 0x16c1a9f713165fde18baf495
            },
            y0: u384 {
                limb0: 0xcbe7c002f6f715caa59db0ac,
                limb1: 0xf09014c711ed22768f4d77a5,
                limb2: 0x66206306370b8e589300d20c,
                limb3: 0x118b3b7d3f9a99c3fa117c37
            },
            y1: u384 {
                limb0: 0x1b0ca574aaf124955c52c615,
                limb1: 0xcd2771da9d9656fd14f1609c,
                limb2: 0x54e5ec7dba0e272b83f5baf8,
                limb3: 0x131543e6540d69588ab5e1b4
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 0x6345f0bc97f74a5e6cb7eb45,
            limb1: 0xb70fda7777964a03ab6c743,
            limb2: 0xbd4ad557d95629ac11f08316,
            limb3: 0xf35d9213d77fa7df0674c4
        };

        let f_i_of_z: u384 = u384 {
            limb0: 0x997536a8d8b23694708f455b,
            limb1: 0xaebb192a584c1484a8ef6278,
            limb2: 0x1ee1ecbacc106506cf671bcf,
            limb3: 0x3ac70e648cbdf4caa99e864
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 0xf4bfa0facb6bbb82acea0c22,
                limb1: 0xa9a7cc55250b962113495931,
                limb2: 0x88439f8a391f24aa306db017,
                limb3: 0x18d2626ba5c8e6fa0a3a265e
            },
            w1: u384 {
                limb0: 0x1e12620cc3908adf7cf8ff3f,
                limb1: 0x33130c573342a08acf57e770,
                limb2: 0x939bbbf53eb8a77a743cb617,
                limb3: 0x17cd7e4fdf2e4b93253c04e0
            },
            w2: u384 {
                limb0: 0x3f255a1bb454d73037b644e9,
                limb1: 0xccd4cf06adfdc3e431ebea37,
                limb2: 0x356fbfc5fe8b79722c11326c,
                limb3: 0x50d5bc73c0e61e8141393fe
            },
            w3: u384 {
                limb0: 0xab652a721d8bc25277bb1ab4,
                limb1: 0xcad0e8008909625abc78f9bc,
                limb2: 0x5b4ce32775ced87e4e988ff0,
                limb3: 0x1958af6125a9bfbcdd9e635f
            },
            w4: u384 {
                limb0: 0xfe00e4e72ae49aaa2ea6d7bf,
                limb1: 0xa5a074814273de5a4028539c,
                limb2: 0x8b6653de4bdb0bcf9efa5314,
                limb3: 0x74aaa48dd18313f4dd47780
            },
            w5: u384 {
                limb0: 0x2e08250925d273d0f1e0d225,
                limb1: 0x73b470e90ed8a0f5048a07c4,
                limb2: 0xa8585dde7e414e982bcbc88f,
                limb3: 0x40d79cca4ce14faa73a18a4
            },
            w6: u384 {
                limb0: 0x5ee4515354bacbb01fb63e69,
                limb1: 0x1570c716308718f06fddc66b,
                limb2: 0x2880c2853129362844889e69,
                limb3: 0xfc4e700c8fb4d3a8dc12176
            },
            w7: u384 {
                limb0: 0xfe4c7b1d77248745125a7593,
                limb1: 0xae11af49775c20e992ba0599,
                limb2: 0xfe963e96082aba194bc7baee,
                limb3: 0xe078be5b4f54586523923a
            },
            w8: u384 {
                limb0: 0x38e850a1ed59751a47534335,
                limb1: 0xad145b77baaf1b883386efa9,
                limb2: 0x3ccd533ae998c8c8155ba781,
                limb3: 0x1981930a62786c7a279b25b8
            },
            w9: u384 {
                limb0: 0x733a839aa6a143b5decc23a0,
                limb1: 0x98fb539b13ba77151f224a02,
                limb2: 0xd7d2b534efb207cfcaa831ba,
                limb3: 0x12eae32f4de55170615ab7c2
            },
            w10: u384 {
                limb0: 0xa2961b7142efaa5d8cda6308,
                limb1: 0x973dd58bd78c5c69ccfba69e,
                limb2: 0x9ca19890a53b304ebabcea6b,
                limb3: 0xdecab677e88a8b18afc612d
            },
            w11: u384 {
                limb0: 0xbbd339557dfb3572bb2f5948,
                limb1: 0xc1b0043dc0af956a930c68aa,
                limb2: 0x2c649a33e4889d7ca6e77931,
                limb3: 0xf36da7b3a858175b56a820f
            }
        };

        let z: u384 = u384 {
            limb0: 0xd4fb163012296f326e448971,
            limb1: 0xd603641927bace697a6060a8,
            limb2: 0xdb812ade2d49ec8065ba2571,
            limb3: 0x17151a810d64cd61a3769512
        };

        let ci: u384 = u384 {
            limb0: 0xfcad455e3ba2cf1686863e50,
            limb1: 0x140ebcf22e57aaa0803fd85a,
            limb2: 0xb0343d8968e592c79f3b139d,
            limb3: 0x5ab1991a9ac3915bee9db39
        };

        let (Q2_result, f_i_plus_one_of_z_result, lhs_i_plus_one_result, ci_plus_one_result) =
            run_BLS12_381_GROTH16_BIT0_LOOP_circuit(
            yInv_0,
            xNegOverY_0,
            G2_line_0,
            yInv_1,
            xNegOverY_1,
            G2_line_1,
            yInv_2,
            xNegOverY_2,
            Q_2,
            lhs_i,
            f_i_of_z,
            f_i_plus_one,
            z,
            ci
        );
        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 0xb517b311007c5ab45e80e41,
                limb1: 0xcee191c93adf98c5c345c3de,
                limb2: 0x31b1b77fe468ed2b747c7c67,
                limb3: 0xc3b530724d33f591d240883
            },
            x1: u384 {
                limb0: 0xb4dd3dbc833e9b306013e57b,
                limb1: 0x6d79a2961d4960943271b0c,
                limb2: 0x86dcb222038022718a6bd53b,
                limb3: 0x104c773c9b6521ed52228f2f
            },
            y0: u384 {
                limb0: 0xe191154944af08854f84d437,
                limb1: 0x19b463f6f34b86a5a36801a6,
                limb2: 0x81d23fe56d80613e80974d30,
                limb3: 0x16182701cb7faa4e15e6e62
            },
            y1: u384 {
                limb0: 0x4e84a3748034b8af015bd0b8,
                limb1: 0x210e237de33fc32bb867bd41,
                limb2: 0x445f9312cb4937d8609026b1,
                limb3: 0x127474426f97fc7eec810e44
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0x79af7708ca17a81b7cb54f40,
            limb1: 0x49ff09f0911aaaf7d47cd5fe,
            limb2: 0x7ecd8283f97e6b674dc78d04,
            limb3: 0xbb0930e99de9852fcbee651
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 0x82dd85fb236e5ef7a7120d98,
            limb1: 0x61e639e827c295f7cfc3037e,
            limb2: 0xcfbdcb1a54e4bbf32ae867e,
            limb3: 0x16f0c20ef71c5e156cd9d585
        };

        let ci_plus_one: u384 = u384 {
            limb0: 0x64c93ab6174cf3f838445469,
            limb1: 0x52cbbd1362a3220110d828dc,
            limb2: 0x49f49e329882bceb85d26117,
            limb3: 0xce497b2a3a90f125c7413e2
        };
        assert_eq!(Q2_result, Q2);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
        assert_eq!(lhs_i_plus_one_result, lhs_i_plus_one);
        assert_eq!(ci_plus_one_result, ci_plus_one);
    }


    #[test]
    fn test_run_BLS12_381_GROTH16_BIT1_LOOP_circuit_BLS12_381() {
        let yInv_0: u384 = u384 {
            limb0: 0xfda6574018e72189e41816d6,
            limb1: 0xfd09e9995e688624a0ea9d77,
            limb2: 0x513a81ca0b0a13d7d42b6d03,
            limb3: 0x35b3d8cba64fb01676c5c21
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0x2afcfb1895b57021ff744ba7,
            limb1: 0x17485c67b3a97280a27f0e23,
            limb2: 0x6d519e108d0807db6b488c45,
            limb3: 0xc2a2bae6cffc7441c7c5c2c
        };

        let G2_line_0: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0x13972b03656b91222f564b52,
                limb1: 0x946ff6f4532e95d66c8719b3,
                limb2: 0x25903f2efb793a376b636a7b,
                limb3: 0xc449c9039ff2d02511b6c28
            },
            r0a1: u384 {
                limb0: 0x336287c56717d0f28169460f,
                limb1: 0xd550f277e3039a8818028380,
                limb2: 0xdef56f5160cab33023aaad,
                limb3: 0xc12d275b427f0e67d7b6e7b
            },
            r1a0: u384 {
                limb0: 0x6437daf2ac61c15b6b4601e6,
                limb1: 0x7ccee7ad828b66a3e1c91e7a,
                limb2: 0x738a67ee20a43d4b6f44b80e,
                limb3: 0x8805af853719155ec2b3b43
            },
            r1a1: u384 {
                limb0: 0x29f623bbf8e081d5e5d3fd8b,
                limb1: 0x8ca7ccd892902d31ade2cc44,
                limb2: 0xd17c3a693b3a3114bd054094,
                limb3: 0x5a55a10c4d4f727a77d3e06
            }
        };

        let Q_or_Q_neg_line0: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0x2e57662861ff5114132c80e8,
                limb1: 0xef73ba0d7919ce67f9921fb2,
                limb2: 0xe08b0d97345c9e182c7fcbfe,
                limb3: 0x152ee2f2bc4481214e50ae44
            },
            r0a1: u384 {
                limb0: 0xd9940829d329426663865c86,
                limb1: 0x29fb62b027536fb5dc37e351,
                limb2: 0xc703c63ca60523ba2cb48b5,
                limb3: 0x3938de133c71c2c29bc0aad
            },
            r1a0: u384 {
                limb0: 0x4b6d6ec3ea152c5011fd6606,
                limb1: 0x2c504bd177bcc6ea587e681c,
                limb2: 0x70b281be14afbd7782475b36,
                limb3: 0xd808b6334747c7592c2674a
            },
            r1a1: u384 {
                limb0: 0x601e3e70e6667051673cde97,
                limb1: 0x98144476208c5fb2fede268b,
                limb2: 0x612036119d11dfa0845857ef,
                limb3: 0x7471b822f9c79b11ad02fba
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0xdd1d44e81d67ce222d42ec4e,
            limb1: 0xc95c2b4081e3e1ba88a04d54,
            limb2: 0x700c85e840faecc1ac48ca59,
            limb3: 0x13d374456c9cae6f84181131
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0x9715dd88090c68ef8442437c,
            limb1: 0x408e1b9882dade1dd995ab9b,
            limb2: 0xb7c6a34b0f45d01a3b8e4413,
            limb3: 0x18c1e0f277b20069da74f055
        };

        let G2_line_1: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0x97b1a69b171ceff18bef7bf0,
                limb1: 0x5d6fc6c0917429b09773aac7,
                limb2: 0xc6d80cc2f7b2d73a0b2ecee1,
                limb3: 0x1264e29cb7bce3ef85f79731
            },
            r0a1: u384 {
                limb0: 0x384f1130e288137e2889d205,
                limb1: 0xf89f29a3adc5b4d63c6a7d4a,
                limb2: 0xfe38df1c51fd01c86e1987f4,
                limb3: 0x7c5a63909525f6442748af0
            },
            r1a0: u384 {
                limb0: 0xca2e255fec5a35f49cc6bc68,
                limb1: 0x10c68cfe4f2cfbfa84d586db,
                limb2: 0x3eb74425c35ded07f3299c84,
                limb3: 0x5f7400451a437a8983e0514
            },
            r1a1: u384 {
                limb0: 0x12b53dba50a712766721a7de,
                limb1: 0x4cd59c36a588907e42451cc8,
                limb2: 0xc8538af25239ca37b2aaf6eb,
                limb3: 0x1100981916f3c7a4be8b9fbe
            }
        };

        let Q_or_Q_neg_line1: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0xc70b42297338afecec1b6b54,
                limb1: 0x446b47a0c7bd852797c676f,
                limb2: 0x2d3e176c691fc182239c2506,
                limb3: 0x39f3b80e46d4b78d0584a2e
            },
            r0a1: u384 {
                limb0: 0x655198013d39e62900c5e049,
                limb1: 0x69965ee7f69123bfc07dcd7d,
                limb2: 0xd187bbaea01d1ab7f00a5cc4,
                limb3: 0x3bc30d88277859bd025676
            },
            r1a0: u384 {
                limb0: 0xbbdfd2a2c43fbf37589d431a,
                limb1: 0x8790e11d9b329a60ceec7e2d,
                limb2: 0x90afee6c89106771b09ae37f,
                limb3: 0x192c8647807948fcd352f3bb
            },
            r1a1: u384 {
                limb0: 0xdd89c848240c7fd7616f54d5,
                limb1: 0xcafe4d5f0f82e0077a1960df,
                limb2: 0xa0c460ab36f185c09e7e9fa3,
                limb3: 0x8c97c2695954e636138a502
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 0x6d043ca0fcb6865b2e70b419,
            limb1: 0x81fdb407ada2270b8ed5f6c,
            limb2: 0x7e58c5547689350ea7f1866f,
            limb3: 0x1420d01417484236f44d0161
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 0x51b187c568144468fa588902,
            limb1: 0xb6719865bbcfb3c40e831ee8,
            limb2: 0x804999ab96b4a573a938ca56,
            limb3: 0x15167ab3ae59eb71a4e7fafb
        };

        let Q_2: G2Point = G2Point {
            x0: u384 {
                limb0: 0x59e811dacf33fafd1d83973d,
                limb1: 0x31c827638e4b0ca97baf2d1,
                limb2: 0x1a874912066db9415f7dc765,
                limb3: 0x11030328b427d996801688d2
            },
            x1: u384 {
                limb0: 0x45e0dcc16c54a78ed8bacbcf,
                limb1: 0xef75ecd4986280ed5d59adb3,
                limb2: 0xe43c94aada68222de6ca33ad,
                limb3: 0xdd8a367dc9e1b0fe4276715
            },
            y0: u384 {
                limb0: 0xb9fe5c7c1946e351e19c6835,
                limb1: 0x28db3bb0ef0567a918161478,
                limb2: 0xdc6ff4a458fd8fa2ec297ce2,
                limb3: 0xd626b6458d43a569bbb54f7
            },
            y1: u384 {
                limb0: 0x1daadfb96e3a3c511d6038f5,
                limb1: 0xae121069a70c825f8e534a4f,
                limb2: 0xccb6bd76e3bf50cd1283537d,
                limb3: 0x19e545e6f8adeac04d4395b9
            }
        };

        let Q_or_Q_neg_2: G2Point = G2Point {
            x0: u384 {
                limb0: 0xe8f46e01a1a29ea2af6b3cce,
                limb1: 0x87b0c749cb1e869a2ba78a3f,
                limb2: 0x26fef2696397f7f5d5ccb9f6,
                limb3: 0x937e37a3aaadbe669946bed
            },
            x1: u384 {
                limb0: 0xec762f0c1c611bd76d89f8a4,
                limb1: 0xc9256e17cb269dc7d9414a69,
                limb2: 0x594285f428cac5653ac78d4d,
                limb3: 0x48732e4ebfba364152ff3b3
            },
            y0: u384 {
                limb0: 0x7e690f38e10281f83c3fb3e8,
                limb1: 0xc5b060e5556f6dc4e7175d3d,
                limb2: 0x48a0be3571b258f38e8f1cd3,
                limb3: 0xe7f8f3649f2203b73dc5dab
            },
            y1: u384 {
                limb0: 0x1611128303f9072305317074,
                limb1: 0xaab0208a441c57277c7b1161,
                limb2: 0x49a17c2f920be1c5e1e50327,
                limb3: 0x2f12dea996ebdeb6f24c622
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 0xf71ba9fa5d532e38ac8a3c8f,
            limb1: 0x39739c23a1c1d9753dad9e7d,
            limb2: 0x6ecb921c49322bfd66d3e728,
            limb3: 0xac3fb6098237a2158b42b5b
        };

        let f_i_of_z: u384 = u384 {
            limb0: 0x71b1df597268495d0f2cd3b3,
            limb1: 0x523421832eefb25ba54643b7,
            limb2: 0x4343507fbe76feab3fe32ef9,
            limb3: 0xa7dca00cdc3e904d79209be
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 0xa180b11c65a58666adc0cd26,
                limb1: 0xea7b6bf7ef02962f5a8fc640,
                limb2: 0xd64126b2eefd3ccc40bac9ed,
                limb3: 0x10d29b9178c0fd0e430cd8bc
            },
            w1: u384 {
                limb0: 0xaa042f31e8cde8ebf4bf0983,
                limb1: 0xb07223889e49fa7d7a98a30a,
                limb2: 0x5699f506ebdf8f4bc2f1b366,
                limb3: 0x3607025e0e7ce676b68400f
            },
            w2: u384 {
                limb0: 0x9e59570537a6472f3ac0eae6,
                limb1: 0xd805008b256ab3318fe5be89,
                limb2: 0x7c7d4c3a186d2d982d9e6af6,
                limb3: 0xd294ea7579ac65a840c006f
            },
            w3: u384 {
                limb0: 0x5afc95985e0396b79b4d45c9,
                limb1: 0x7586fe0d7973a14c5f73b844,
                limb2: 0xb9bdf50ef463c38f4db90cef,
                limb3: 0xd41f3e808cda9b55e5a7b11
            },
            w4: u384 {
                limb0: 0xd0b1529064a1fc766994b61b,
                limb1: 0xacc88981651c115f271f08e7,
                limb2: 0x272223bb4de9dddaa81feb67,
                limb3: 0x4c9f4363075506d232cef27
            },
            w5: u384 {
                limb0: 0x462fe7111b69222ec27b24fd,
                limb1: 0xa4b41b9f689860327953b208,
                limb2: 0x28eac9063d05e7c449b0ef3a,
                limb3: 0x151ba63ba59a154d24bf82d7
            },
            w6: u384 {
                limb0: 0xaeb94f4d0a4a287bc20dd68,
                limb1: 0x4f351d345fcf06c95f80c5b2,
                limb2: 0xd65e5de6412067c5bce5af5d,
                limb3: 0x2156b9cf9a9749ac95845ed
            },
            w7: u384 {
                limb0: 0x1c97909c5052d8e4031d0b58,
                limb1: 0xaf6d44d808c72ec6f9af43d9,
                limb2: 0xf3b12274360417d20edb326b,
                limb3: 0xcdfca40391ea5c020895e98
            },
            w8: u384 {
                limb0: 0x451e21c7fcf347aa156f6907,
                limb1: 0x8f3479eb9e920681edb0598f,
                limb2: 0xe244055d256a483fe9709808,
                limb3: 0xd0a2ddde3e92978d80fcaed
            },
            w9: u384 {
                limb0: 0xca6b99aa09ad4a03c465780b,
                limb1: 0x2b530a1536681492817fb15d,
                limb2: 0x244626e4006505447a104917,
                limb3: 0x15f3b0e555ccfce4579cce67
            },
            w10: u384 {
                limb0: 0xafaaf44c548242d36fc6d195,
                limb1: 0xcf75d1b2a462aec9b0a1ac36,
                limb2: 0x531517f2bc00468b74b3328f,
                limb3: 0xaa8804bb747d230a69df9b7
            },
            w11: u384 {
                limb0: 0x82612c21d346ceb3b072e8ef,
                limb1: 0xed19dd62035439f5fc9360ad,
                limb2: 0x95eea37d8ccabb33e6c1b99a,
                limb3: 0x790c6b53087384685915400
            }
        };

        let c_or_cinv_of_z: u384 = u384 {
            limb0: 0x21199b372bf8efdb6266287a,
            limb1: 0xc1fe665097858866546a0ea,
            limb2: 0x67e0897690ec73c3c550027e,
            limb3: 0x79b5963766c5c9140a54010
        };

        let z: u384 = u384 {
            limb0: 0x387674dc7d8c3b7505283e90,
            limb1: 0xe0f1f143a529c5c421316d8a,
            limb2: 0xdfb9007d143a863ba6517b48,
            limb3: 0x17aba816128722c8c7aadf03
        };

        let ci: u384 = u384 {
            limb0: 0x11eddebf5b252e6211c2588b,
            limb1: 0xadb0ecef19e4888bad4824c,
            limb2: 0x2f33c8378fabb4df1429fc7b,
            limb3: 0xf2ba6d724ff83604fcf929f
        };

        let (Q2_result, f_i_plus_one_of_z_result, lhs_i_plus_one_result, ci_plus_one_result) =
            run_BLS12_381_GROTH16_BIT1_LOOP_circuit(
            yInv_0,
            xNegOverY_0,
            G2_line_0,
            Q_or_Q_neg_line0,
            yInv_1,
            xNegOverY_1,
            G2_line_1,
            Q_or_Q_neg_line1,
            yInv_2,
            xNegOverY_2,
            Q_2,
            Q_or_Q_neg_2,
            lhs_i,
            f_i_of_z,
            f_i_plus_one,
            c_or_cinv_of_z,
            z,
            ci
        );
        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 0xf74437a3c4b485ebc24f6bdd,
                limb1: 0x736c318d30097dd0ed1fdfbf,
                limb2: 0x51112065e7051e6505110884,
                limb3: 0x11a540dc9564f3d14a63df41
            },
            x1: u384 {
                limb0: 0x71661f7499d1e5e76656af49,
                limb1: 0x6c2035f5926968b075708d46,
                limb2: 0xf3fc263d0468cddb7f715ee8,
                limb3: 0x96a67ba61938baff13a1da8
            },
            y0: u384 {
                limb0: 0x3a0f8736bfb8d1873c9e3b8a,
                limb1: 0x7283e24686fd99b8c4071625,
                limb2: 0x46f94137be49ec1961e5cacd,
                limb3: 0xfe5d7a2aee5864846bd38e5
            },
            y1: u384 {
                limb0: 0xfa197671b0ac2e115a41a87d,
                limb1: 0xc7a278e78f88bb1528ac758e,
                limb2: 0xea070886c00e44b4b164b530,
                limb3: 0x12c54a6ac9121951bbd6f7d6
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0x56ef1951ca7178fa81e076de,
            limb1: 0x4623405f848a6220c0ad97c2,
            limb2: 0xc65918c245f97b9b126e5346,
            limb3: 0x69b4cfe45a101787363c26
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 0x168a1ed0a4087049b12305bf,
            limb1: 0x44a6f26757ead3243ffc5ca7,
            limb2: 0x73225e0a43aea3adabc738d3,
            limb3: 0x63e0865657587e049e641b8
        };

        let ci_plus_one: u384 = u384 {
            limb0: 0x6532b9e997d852f51d1ccc78,
            limb1: 0xb2c2d0f746139e02f230d4bc,
            limb2: 0x22377a3f61a86a2c3b64cf45,
            limb3: 0x1bf3f67302df528e2d3edf
        };
        assert_eq!(Q2_result, Q2);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
        assert_eq!(lhs_i_plus_one_result, lhs_i_plus_one);
        assert_eq!(ci_plus_one_result, ci_plus_one);
    }


    #[test]
    fn test_run_BLS12_381_GROTH16_FINALIZE_BLS_circuit_BLS12_381() {
        let R_n_minus_1 = E12D {
            w0: u384 {
                limb0: 0x79c4e17b6787d94c6a2f845d,
                limb1: 0x920a9b4396b99d632a519d7e,
                limb2: 0xfa2b6c87feb8c8396e16208a,
                limb3: 0x49bddbda173d9dee1a8fc40
            },
            w1: u384 {
                limb0: 0x2d2fa6172fdc0e729c741612,
                limb1: 0x1ba6167215172ac2baf0c1ee,
                limb2: 0x449d215d8180017d0cb06a3d,
                limb3: 0x1de5ea430c4b8348dcf681d
            },
            w2: u384 {
                limb0: 0x97df2b950bc1fe7d4ae02cd8,
                limb1: 0x45e1218bb3274fafc9a5b1d0,
                limb2: 0xb46c7a54be80def9ec644016,
                limb3: 0x9f3014a16807b0ae2d33bd
            },
            w3: u384 {
                limb0: 0xdae4e050ac6586314ac61a04,
                limb1: 0x2ea00ee8d24e2e20e19cff3f,
                limb2: 0xbb9290a8b4490f50c45f9d56,
                limb3: 0x140ad97cbb920b5c4fa7306b
            },
            w4: u384 {
                limb0: 0x904230636f4cf935cbac8973,
                limb1: 0x18027d04333c0c3e1f0c5f4,
                limb2: 0xf36dae9c3b27bd7749d83dc4,
                limb3: 0x148504632a07d254761ad23e
            },
            w5: u384 {
                limb0: 0x9f5f7aba79f10a2760284d2,
                limb1: 0xa9f2a42b8cee48d661d2191a,
                limb2: 0x478bfe1c1c5f5b7a7ce7194b,
                limb3: 0xf06e15908c6171754e856df
            },
            w6: u384 {
                limb0: 0x8ef80189f81255fb4d0e5725,
                limb1: 0xa4dc54cfc534792c9aaf3dde,
                limb2: 0x1c456e922f32cdf6074001e8,
                limb3: 0x19bf9db075a92150349afde3
            },
            w7: u384 {
                limb0: 0xcc6cac6631389d17cd941163,
                limb1: 0x20cf66adb67418c1b4c85b46,
                limb2: 0xf1cbd66e832ab1b44f43e091,
                limb3: 0xd0a0ddd9c3b99c1e95ae987
            },
            w8: u384 {
                limb0: 0x6fa8f944cab5ab887b97ca2,
                limb1: 0x3f74c6e041b40a6d9609e274,
                limb2: 0x94211554e2feb8f25d6fa81f,
                limb3: 0x11c722268339f03582525a36
            },
            w9: u384 {
                limb0: 0x95365c085c253befb8268d12,
                limb1: 0x52a868bda1109cd15d491cef,
                limb2: 0x9fe9ae14e54c718126c54436,
                limb3: 0x120bdb6fba728d7ac2c7f1a6
            },
            w10: u384 {
                limb0: 0x1776229a5b623b103dc72e,
                limb1: 0x64a2264eb6aa9141c0974b3b,
                limb2: 0x63a815df4707de5d8a40e6b,
                limb3: 0x77a78d1905a1a4270a090e1
            },
            w11: u384 {
                limb0: 0xe3a56430804cdee2b52d196f,
                limb1: 0x4a8b2fae620931c36fb688bb,
                limb2: 0x94b26c543e2b0f3a655ff99f,
                limb3: 0xefc0f8ca91fbb4852c71bbd
            }
        };

        let c_n_minus_2: u384 = u384 {
            limb0: 0x76883842902342f6055e22db,
            limb1: 0x189628c54d8c5f7ae7bb345f,
            limb2: 0xc71b355070bf5a520322d289,
            limb3: 0x16ad40f864c8d42b89090502
        };

        let w_of_z: u384 = u384 {
            limb0: 0xb5c2c5dc51ccfaaa931f3649,
            limb1: 0x667ee8a00529817d446d159e,
            limb2: 0xe059cb33a79b2d1e1ebf8378,
            limb3: 0xb638f58641d628f85e6d786
        };

        let z: u384 = u384 {
            limb0: 0xfd167e4bef55e84400e47cd6,
            limb1: 0x716077f5d07aae7f9b909128,
            limb2: 0x148106b5d49d81b954d57ee1,
            limb3: 0x3f97ed8e89f54b81f8c72f
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 0x141e39e7911f493c450a0e69,
            limb1: 0x7c5246f18fe5475bb771877e,
            limb2: 0xc7e2d825cfd264ff06fb6410,
            limb3: 0x7007ffe8f9b0bda8a624be8
        };

        let previous_lhs: u384 = u384 {
            limb0: 0x70d760135c80560b3bb97a4b,
            limb1: 0x37ab33e0d9bde1188c55591,
            limb2: 0x4338195ed19cf0080c81a049,
            limb3: 0xd36797f60ff1e50ce441882
        };

        let R_n_minus_2_of_z: u384 = u384 {
            limb0: 0xa31f546185e80c9f67b05c96,
            limb1: 0x35d74923c983453cbcf9cb1a,
            limb2: 0x3869f1d504f65b194e682ad2,
            limb3: 0xb5e51a776a9a58a28055635
        };

        let Q: Array<u384> = array![
            u384 {
                limb0: 0xe8cff189e9d3b77ba34b580,
                limb1: 0x7324cb18d6b1a336ba2831ca,
                limb2: 0x19d27870cb4b99823ab88289,
                limb3: 0x5586710c89c59fa55d925ca
            },
            u384 {
                limb0: 0x408c58f97d03dd282400bdbe,
                limb1: 0xb3504b38e3ffab8cc7c824e4,
                limb2: 0x5c2d68458d461211dd85171a,
                limb3: 0x3a4f6e0030db9c4c38297c0
            },
            u384 {
                limb0: 0xc288819822ebc7efd2fc245f,
                limb1: 0xb0537fbb2bcdacf32dfc297a,
                limb2: 0xfaac8f766f30a7a2585340c4,
                limb3: 0x17036fe0fb0a4705ce9aa076
            },
            u384 {
                limb0: 0xad2e1422a7ba2d5fdbeabc1a,
                limb1: 0xf7789a6b1873e7f034e1be49,
                limb2: 0xa956bb554d2fc15c68a802f4,
                limb3: 0x6ba4f70cec23b2c6bca8e92
            },
            u384 {
                limb0: 0xc8bf8fc4ddc94bc1a254f651,
                limb1: 0xed85977a071afe4acb6ed5e8,
                limb2: 0xcfe36f57d67550223d11c0b2,
                limb3: 0xde30f818059debc3b9996f
            },
            u384 {
                limb0: 0x211d73dd43e65fc302e254b3,
                limb1: 0x95a219dda8ec9c0525c5868c,
                limb2: 0xfdc26f4aee60ff3492cd84e,
                limb3: 0x1a18c3f4700feb83408850e
            },
            u384 {
                limb0: 0xd0d67780485184e3f6b5d674,
                limb1: 0x4278b8db900caefde0bd2721,
                limb2: 0x9575d095138eadb6e460a675,
                limb3: 0xc07f51e1549cdeec30b4d6d
            },
            u384 {
                limb0: 0x7fc8c2e78a2de86e6910124a,
                limb1: 0x977f500b5e2aa857e558abe1,
                limb2: 0x4734fb3eb935da4cb8b12e28,
                limb3: 0x12d0bb4e1a47dfabb3daba5e
            },
            u384 {
                limb0: 0x4eb43ad492c6cedf29e672e4,
                limb1: 0xa25a2423943a764ef1104875,
                limb2: 0x215785dc5af2829b143f50c,
                limb3: 0xcb23c978dc643912869ef61
            },
            u384 {
                limb0: 0x877cac55aa0d9271ce65e725,
                limb1: 0x2ae3d68a6ce1c8403caf0f71,
                limb2: 0xed472d9b6aafb17ef4b346d9,
                limb3: 0x4d164bef005398fe0cece0a
            },
            u384 {
                limb0: 0x1e69b4b0b54d83e59e241b8e,
                limb1: 0x5a2e6a997166c54b93057571,
                limb2: 0xbd0638668a246e9eede19ece,
                limb3: 0x125f68c68c0fe4e7d03a354e
            },
            u384 {
                limb0: 0x4dc59d0ea231a721dce83f15,
                limb1: 0x3ed8da8a35d9f4e2be57d81,
                limb2: 0xb9d2aef50fd29271b440d4eb,
                limb3: 0x135559559bec11a0d5bccf5e
            },
            u384 {
                limb0: 0x687e3c82ef9f1d906706e199,
                limb1: 0xbded53f653e04d41c84724e1,
                limb2: 0xa022f3b7c3c06d98422b80ef,
                limb3: 0xe1fc8a2ad645c15acb76fb8
            },
            u384 {
                limb0: 0x922dcb59fce3c44f5bca7ecb,
                limb1: 0x62b7e3e757ad185e1d38f988,
                limb2: 0xf887a1233263dd1133f232a2,
                limb3: 0xbc50017c0f2b58bcc728558
            },
            u384 {
                limb0: 0x16e5a82c402bb0eb2f9904b,
                limb1: 0x938e0f3eacadd87eda6c650f,
                limb2: 0x81e1ec3f582b943f5f55260f,
                limb3: 0x13154c45eec051bb329d35ae
            },
            u384 {
                limb0: 0x2636c72f584ca7a83f0aa149,
                limb1: 0xf2a5b075b4fecb14b2b4f0cc,
                limb2: 0x16e95a5561398e30880243b7,
                limb3: 0xf81c51166b9645fecb18ea9
            },
            u384 {
                limb0: 0x65f628ac3012d17be2dc403e,
                limb1: 0xdaac3c58e26674c0d848d32e,
                limb2: 0xddefd680deb839597f119389,
                limb3: 0x13279576b3e2e59b68f111c6
            },
            u384 {
                limb0: 0x46828f04de7d0a5fc4ebb04b,
                limb1: 0xb71ee27ce595e68f0a4dd54b,
                limb2: 0xe935b7842d5633bbfbec6400,
                limb3: 0xd3cc5bed30f8add9198047b
            },
            u384 {
                limb0: 0x1c4e5303c2e286fed887285b,
                limb1: 0x6a61fa34bde99b9e91f92746,
                limb2: 0x9276de42e93d0153fa51ac5d,
                limb3: 0xca5e5982d6b5f4d38b28557
            },
            u384 {
                limb0: 0xb723b6817f512cb65df2c440,
                limb1: 0x77e32499935948de99f469e,
                limb2: 0x8a0f90937cfe9b4d2a31ca24,
                limb3: 0xa568dde12905a3a5a2b8021
            },
            u384 {
                limb0: 0x9a76a9f38b7db84c39a51ec,
                limb1: 0xab9d275ad360282d9d5dd3b3,
                limb2: 0xff6891a9b7c7ef434afafa7a,
                limb3: 0xdc49bf1e9c5c1300a5bb410
            },
            u384 {
                limb0: 0x97762b3a43419acefebd6b72,
                limb1: 0x10d44b3d8aca54105c101261,
                limb2: 0x171c391a53f0c3c9c20da5bd,
                limb3: 0x10a83dc0cb4c7788897ad387
            },
            u384 {
                limb0: 0x81d1e8f909ec485cdc00afee,
                limb1: 0x178ed5d7630942bedb13f394,
                limb2: 0xbbd5ba6eb27ebd4f6736a84f,
                limb3: 0x177f89c2861530f273dab074
            },
            u384 {
                limb0: 0xd4ad527df29b76e936580684,
                limb1: 0xaba883035c51399ea8efc7f9,
                limb2: 0xa4fd1a1781ba4be906e22c3e,
                limb3: 0x171f18ef80857fb264e036b5
            },
            u384 {
                limb0: 0x8623ee6d722219dcb01e0a8d,
                limb1: 0x92126ff19fa1c6c982ebd772,
                limb2: 0x9463e6f3215100e6272e2af,
                limb3: 0x1c540973c1650afb3be5167
            },
            u384 {
                limb0: 0x857f4ecb495c15cc4a8dfea1,
                limb1: 0x5541b40f7635abe4611b4891,
                limb2: 0x1d03e63261ef443569eafdb8,
                limb3: 0xe8b8eb3691fcf9ad8958961
            },
            u384 {
                limb0: 0xd68746187838c85e4ab0d893,
                limb1: 0x35f01b7bc821082dbb783da9,
                limb2: 0xce18533d90c965310186b0d8,
                limb3: 0x8c4d27fc82f1b36fbcddc66
            },
            u384 {
                limb0: 0x8968e51ed92c203767941a9d,
                limb1: 0x6d93be7fa442ff4c35f24653,
                limb2: 0xc9c5bd9f501631d210ae2362,
                limb3: 0xf40d66fe73383ff67b7e14c
            },
            u384 {
                limb0: 0x2a923d98ed3f8d9e055162c,
                limb1: 0xc9e5194473dccc48641ec935,
                limb2: 0xcff239f2cb45a0a63bed05a9,
                limb3: 0x154ac23402b1863cf7564319
            },
            u384 {
                limb0: 0x87dbfdda89440eca2ab65b1d,
                limb1: 0x8a070e39c0251deb9f2c16ea,
                limb2: 0x3dfc5aedcf717e9c9adfb305,
                limb3: 0xfa583cf359aca2086565c4d
            },
            u384 {
                limb0: 0xa71769118230088e4b2903f3,
                limb1: 0x3e4ac54078b5c1dece9c85a7,
                limb2: 0x3108d27b18271de7f929fb27,
                limb3: 0x1739ddfc818a3491c106ac8f
            },
            u384 {
                limb0: 0xac875999a79a495f4fb70578,
                limb1: 0xeed24f1a1726592120696919,
                limb2: 0xe0a82395fd8d2a1e4d5880e0,
                limb3: 0x935f2a5431d69d88fc7301c
            },
            u384 {
                limb0: 0x7bacbd851c476113666b2ee2,
                limb1: 0x7766f556ce518ffcd43dda2a,
                limb2: 0x6c414b3bb7b915a89a46cb39,
                limb3: 0x121133455dc4d442e6cd146c
            },
            u384 {
                limb0: 0xb8c9a6d30b31eed442d1ce27,
                limb1: 0xbba1622446637bffb0df50be,
                limb2: 0xa9813e48cf517ee3eb3689ad,
                limb3: 0x10b7715ee19ffc36d8c24a82
            },
            u384 {
                limb0: 0x119b988cd11de57619cefbfa,
                limb1: 0x21f8dc2773140fe939da09d5,
                limb2: 0x33ccec766228186dc698782e,
                limb3: 0x85b62fb77dfbe635fc75d52
            },
            u384 {
                limb0: 0xc7b46529c5c1144658df0b5f,
                limb1: 0x2a883ae17ca6a63322320962,
                limb2: 0xc5bf578349c1ce42ee12ea33,
                limb3: 0x1313a06305f6b28226df5bb2
            },
            u384 {
                limb0: 0xb617b69560ed3cae470aa2cb,
                limb1: 0x216d8b51e65964b08865def3,
                limb2: 0x84025665d065db9409fa3808,
                limb3: 0x11fd545e645101b863543195
            },
            u384 {
                limb0: 0x55de290d31b7297904d67b6f,
                limb1: 0xede334bf59860017dfed7404,
                limb2: 0xc8dd01fa6258dedb63901ff6,
                limb3: 0x72380c045f9f24b5225c7bb
            },
            u384 {
                limb0: 0xff1b17e5b4236475e54acd13,
                limb1: 0x528258767dd1c306bdcaca2c,
                limb2: 0x93b756594cc57b45ca6b0cda,
                limb3: 0x19b2e7132ed1c95350ee5b4a
            },
            u384 {
                limb0: 0x125d93203aaa7029dd40e6a,
                limb1: 0xc7114022e4d7e3ceb51f93db,
                limb2: 0x2b3a60caf38d058d4140f891,
                limb3: 0x3c9cf88ff690a7e08f46f44
            },
            u384 {
                limb0: 0x9203d693614ec0bcc5f82087,
                limb1: 0xe74c987cf551bbcdef991720,
                limb2: 0xc664ddb42d1a4aecddff17cf,
                limb3: 0x12feefdf2ae3f2f7ec50b302
            },
            u384 {
                limb0: 0x1d6ba6d97cde58cdcbda548e,
                limb1: 0x30e021a049c84c58a1dff1c4,
                limb2: 0xdd0ff93dd743993c44f36682,
                limb3: 0xb719baab9ef3e8f233a8aa0
            },
            u384 {
                limb0: 0x215da72f8b252c5a357d7205,
                limb1: 0xf38f1af93caf93b3b251899,
                limb2: 0x3845b6bda5660ca1af6b5d12,
                limb3: 0x1dcf5daf04abb9d614b3ebb
            },
            u384 {
                limb0: 0xd5050eaece3a664743710cf1,
                limb1: 0x7b1a752872627f2d94b385d8,
                limb2: 0xdb62bcf55f7656c850e81e7c,
                limb3: 0x160f338ef8f31873fbf25b96
            },
            u384 {
                limb0: 0x8cb8bbd179d06ea37ab395cc,
                limb1: 0xcb4969264ebe97441b6043ff,
                limb2: 0x40544cb4196fe97d9e268ce0,
                limb3: 0x15db2f76aa432be30b9d0223
            },
            u384 {
                limb0: 0x88ccdc5a1dcdb3d3e90cae9c,
                limb1: 0xacd36cc2e64c704ce28806b3,
                limb2: 0xfdc0b68e39d9ccec9a5840c,
                limb3: 0x124aa646e0a50e9e0c5084dd
            },
            u384 {
                limb0: 0x76f2aa3f1089f14abda9ed3e,
                limb1: 0x866c73e87aae6c5f53be7a04,
                limb2: 0x57dc56f2b14b9e5fc7ca5771,
                limb3: 0xe2104374a20dad778f7c9ae
            },
            u384 {
                limb0: 0x41d3dee5398f3e69340b6ba,
                limb1: 0x650eb3fd6ac4efcbf826db7e,
                limb2: 0x22df2127f272dca70c2c994d,
                limb3: 0xf565a57c8fdb279ba6c8f8f
            },
            u384 {
                limb0: 0x3431d2799502e8d09fbacebe,
                limb1: 0x4a10574edda743eaf38d5f86,
                limb2: 0x410e50fc94ee511c8b599c63,
                limb3: 0xb7e320c7b81739d308f3d08
            },
            u384 {
                limb0: 0xaf23e437197dfe228c35d1a7,
                limb1: 0xb852b133b2e454ecf7e39094,
                limb2: 0x780a554268638abb8a0f4fa5,
                limb3: 0x667ac9493c58335100399b3
            },
            u384 {
                limb0: 0x68b156a29a7a1d9141ed7ecd,
                limb1: 0xf9c422581e44da9835e3c06b,
                limb2: 0xa5b6a7d39344741b6fdf26e8,
                limb3: 0x13842a3475c8fe6c39ea86e7
            },
            u384 {
                limb0: 0xdc93ee55cdccdc668a40c090,
                limb1: 0x411d9ac8948fa23c39dbede7,
                limb2: 0xc918c98db01de5e604b45598,
                limb3: 0xd0f0d974db7be08bed61fe3
            },
            u384 {
                limb0: 0xc0c8489eb7bb46083731b449,
                limb1: 0x5b88b1fd1192ee49ff5b7985,
                limb2: 0x70487b7c22ec9db800301adb,
                limb3: 0x10b7731400c5ec6753434e3c
            },
            u384 {
                limb0: 0xb3884ab68df76120a4c866ba,
                limb1: 0xbb4750e50e8c46fa14dddbc7,
                limb2: 0x45e4a876bcbc2a0bed410331,
                limb3: 0xc40a2c7fd9e77ffc970d405
            },
            u384 {
                limb0: 0xed0c46ce8361915fc93af911,
                limb1: 0x71564d3a919b5e9a5252b7cf,
                limb2: 0xbbaccdefef16d9ad830710c7,
                limb3: 0xe99f9720c89f3182e22365c
            },
            u384 {
                limb0: 0x390ab6294c781201e41e0111,
                limb1: 0x7a860be235cb4e445282f2cc,
                limb2: 0x909bfb6cbe3f7847525d00de,
                limb3: 0x1536b637baa138ddc07f940
            },
            u384 {
                limb0: 0xb5e6e55b57a8f035d2b85cc6,
                limb1: 0x5a56de707db6dd3595855342,
                limb2: 0xe5afeba59cc25e544016bf22,
                limb3: 0xe39b3764d5149a5a8f67572
            },
            u384 {
                limb0: 0xb2540830a45fa9d992a971e6,
                limb1: 0x871d7732882fb74a52f783b1,
                limb2: 0x17bb725f1abb2b4bbe99d695,
                limb3: 0x13fb70d722d706178fe0cb1a
            },
            u384 {
                limb0: 0x54b71ee9a5e032eedad11351,
                limb1: 0xd3189500377f2e472dd8914e,
                limb2: 0x419a8fc9e0623ef18d59b1bd,
                limb3: 0x62eeb7761c00eeed460ee39
            },
            u384 {
                limb0: 0xbc9b5dfd17c5c2b485b00402,
                limb1: 0x427b4a96ee24e998b9a83e16,
                limb2: 0xf80c450eb8d8240377aa80d0,
                limb3: 0x10ce2c2008993782e510cf7f
            },
            u384 {
                limb0: 0x52ce2c28e32bc098aa7c1ea3,
                limb1: 0xaf3630552429a8172c39222f,
                limb2: 0x74a65138a6d39c8688ba469c,
                limb3: 0x7e3943533af6a90a2d5d71b
            },
            u384 {
                limb0: 0x5a80eca69ddbf7fb17ed820,
                limb1: 0xff9f52c728a96c642ee639e6,
                limb2: 0x1cf58a1d406b40fefcde10fe,
                limb3: 0x8ee688e8d32d5a204714862
            },
            u384 {
                limb0: 0xc8a7cea006ebb89d6099ee1f,
                limb1: 0x2fd184fc08deb9a9022fe37d,
                limb2: 0xfc9d2de32010fd239298ad3,
                limb3: 0x1009bd1d41f2eda4a3764a66
            },
            u384 {
                limb0: 0x4f1f5d169a4e1957c158228,
                limb1: 0xa406b471835ce55ea78504c8,
                limb2: 0x9fa25586b6dfbf6d1c209f98,
                limb3: 0x7fcc19096154be95b698ec7
            },
            u384 {
                limb0: 0x3c0dd51a9e00559b2802e605,
                limb1: 0xa28858991010e76813f14080,
                limb2: 0xeede659172a98ae2f76f2688,
                limb3: 0xbfe01290b28624b5ee2bab3
            },
            u384 {
                limb0: 0x6c441570288dcf56a6b9b035,
                limb1: 0x27bea4dba1b22a92bcdbe105,
                limb2: 0x30167e5b33eb3cf4d96bab49,
                limb3: 0xf64687cba033a2add978cd2
            },
            u384 {
                limb0: 0x8f2f9889637ae52286b337a0,
                limb1: 0xfd2cf8f26b25ac204b485131,
                limb2: 0x4a2fa7e29cb7378332657763,
                limb3: 0x132a7bdbc4ea7478f0991088
            },
            u384 {
                limb0: 0x63790da5dfcba9751435fa0c,
                limb1: 0xd42d8dd604c17fd24d5f9bf6,
                limb2: 0xd100f2ea2a94b19f355089c,
                limb3: 0x31515e5043a69ea1a6ed48d
            },
            u384 {
                limb0: 0xa0287d1e259504cada6b236d,
                limb1: 0x2d01b7b14bc1343e05eb09ba,
                limb2: 0x3905b6dc9e888d320c4b5dfa,
                limb3: 0x49cc182b95a9bfb827f2f52
            },
            u384 {
                limb0: 0xb0a7ff0b74e0420accca24df,
                limb1: 0xcd1dd7810ed14276e0c6b1e0,
                limb2: 0xd33390055db94a3bcd4335de,
                limb3: 0xed0c6af4e030209c3d442a0
            },
            u384 {
                limb0: 0xbb3d5921f443bc003f6f8653,
                limb1: 0xefa708885a938325839b1788,
                limb2: 0x9e68642362eb0802e4c83737,
                limb3: 0x25f924b7a665233539498a7
            },
            u384 {
                limb0: 0x90ff1e7a3d1e9521a3f28f45,
                limb1: 0x1357827ed6fc07d4f498ecbd,
                limb2: 0xeff427700a828a9a74f0b87f,
                limb3: 0x16f7af7d4295197630ee0dd8
            },
            u384 {
                limb0: 0xf171bea9649d997c192546e9,
                limb1: 0xf7edf89b59f42ea9a2efdb5b,
                limb2: 0x4a9007ca67a1c22584e88209,
                limb3: 0x35b1fe95ff8eb5792791bf8
            },
            u384 {
                limb0: 0x8f94f05ff4b012189c6cd049,
                limb1: 0xe8ad335586e35301abde06de,
                limb2: 0xa0ece8d108359e8a9268ab5e,
                limb3: 0x1597c9fe16d93ae1ed6d5389
            },
            u384 {
                limb0: 0x3899c22ad4ed51bdd69274a2,
                limb1: 0x1bbb7e27f69cd8fa4b4da1c,
                limb2: 0x34b09a299b19122b6b5bc344,
                limb3: 0x143778a3f6b1992e3afe16a4
            },
            u384 {
                limb0: 0xab95a44be52443a5eea99a27,
                limb1: 0x7f9c4940e41b16899d26336c,
                limb2: 0x771928d28f64d8011cd855e9,
                limb3: 0x1402d6b6bc8065f547172938
            },
            u384 {
                limb0: 0x53aee7e5a625421b89e4abe1,
                limb1: 0x9026f15bdc54ed664095555c,
                limb2: 0x8e0eb593ea56143989fc9ec,
                limb3: 0x182805f4756a09bee8c7d9f1
            },
            u384 {
                limb0: 0x6b3b969554cec6a3c8ecb076,
                limb1: 0xeced15422a6cf0dd76cc2247,
                limb2: 0x8d61adb6c93d3d7b7c1351f2,
                limb3: 0xabc9bb83d71eabb1acef37c
            },
            u384 {
                limb0: 0x84b55c83deb83dd2a1dec0c1,
                limb1: 0xf847fe4cf409ec665555ee5d,
                limb2: 0xda67f9b3b7a9588d5f740d3c,
                limb3: 0xd7e0a2ce277fe1b97886cf0
            },
            u384 {
                limb0: 0x3c1e58c7b937a8955dc42729,
                limb1: 0xa255337d7ec93bc5c0673466,
                limb2: 0xdb4adf79a6c1e02d2380282e,
                limb3: 0x4a1972e1573cfa147ac0175
            },
            u384 {
                limb0: 0x17c7e2b453651805dbdb2409,
                limb1: 0xcae7e8a3f8ac453c46bc05ea,
                limb2: 0x3f11e520ac66d0089e64011,
                limb3: 0x1980cadf1339998b76d295c4
            },
            u384 {
                limb0: 0xe8d650bf502ccbbff5d21eb,
                limb1: 0x8b7f62c4a371e89d59fb09cc,
                limb2: 0xfc3b4ab7cb89ba42095b8ec0,
                limb3: 0x1933300dcfa0dd49cc8f2e5b
            },
            u384 {
                limb0: 0x8a589b3bb4d3060b69a01929,
                limb1: 0x7d71e2f445ac295869866f2,
                limb2: 0xaf7a98c53abe5a8d78a51ef9,
                limb3: 0x142e4ad5de4452be1567b3c9
            },
            u384 {
                limb0: 0xa9e80538880b3ff9f4b7d61d,
                limb1: 0x561e9d96315d78d403fa6c59,
                limb2: 0xbf21bc555f9e9192ef53c57b,
                limb3: 0x10d1b9c4b5c868f4293f7a05
            },
            u384 {
                limb0: 0xa5da81afbeca3fee251e5b95,
                limb1: 0xd1dfbcc061d80302e9773b06,
                limb2: 0x1e0350fa72ea8bd1092d92e4,
                limb3: 0xea55c3191a0dc95ec103bd3
            },
            u384 {
                limb0: 0xf4502bed532f4c55998b2f90,
                limb1: 0xf568e3fe6364972ffa6408f,
                limb2: 0x484e3e3bb895aaf32bb63944,
                limb3: 0x60b7ef0861f876b2b70cc1b
            },
            u384 {
                limb0: 0x67c016ad9e4b41023ee6f40d,
                limb1: 0x57ff0f5932c973a425803532,
                limb2: 0x77222ef69bfddc59eadd6fc5,
                limb3: 0x172ddb4e737bad2d7c6dbbc
            },
            u384 {
                limb0: 0x5f698d12f47383af2b146841,
                limb1: 0x1c598fa1f543be48696b7284,
                limb2: 0x948e40eb1fe43d64aace1c9a,
                limb3: 0xefcc05e5e573ddd6b60ef72
            },
            u384 {
                limb0: 0x98b5ee858caa33e2e16b4a51,
                limb1: 0x5b9482ed19691d4153a55d12,
                limb2: 0xc7cec878081116e5a4c0dde0,
                limb3: 0xbd0a29bd6836e8a74cf7701
            },
            u384 {
                limb0: 0xfd64e98ca4ba34dc4bcc9f73,
                limb1: 0xd5e25c7422d71432808e83a9,
                limb2: 0x1e551507ac0bab2a4929768b,
                limb3: 0x1719bd791acaf41d69ae74d3
            },
            u384 {
                limb0: 0x93dd0df417229ab9831177c2,
                limb1: 0x1bb956962ce3c46bd6e8149b,
                limb2: 0xe072e0c4b3f69e79afcc43c3,
                limb3: 0x18c695beb18376d0f3319ca4
            },
            u384 {
                limb0: 0xa1f98f232e4e8052329d0a1d,
                limb1: 0x97789958f5abdb113ff0b97a,
                limb2: 0xef4c618d4cd6b614683a9c59,
                limb3: 0x1a3c27b8cd969b4e7e6db1
            },
            u384 {
                limb0: 0x32ac96120fc5449674ab4658,
                limb1: 0x7dc5d2e767d308074d52980,
                limb2: 0xdcc139a82303166416c7e56a,
                limb3: 0xbcc9651801f75e8fd2fd1af
            },
            u384 {
                limb0: 0xd474ae8e6a4cfb4b92224a53,
                limb1: 0x9b935e6128d1af8947f9e252,
                limb2: 0xc6475e3c0e19967b8102ce40,
                limb3: 0x9bc5aae5244f1dc5073fc2b
            },
            u384 {
                limb0: 0x2822553dbedc3314a4903d37,
                limb1: 0x7d7476b1a5bf16d83a4187d0,
                limb2: 0x2aff279273286a4807be6722,
                limb3: 0x8145e80fbb8e582b9196453
            },
            u384 {
                limb0: 0x7ae8496670fd490c5bbb959,
                limb1: 0xb1aa2f9383ab80c79112c36a,
                limb2: 0x2b6bd0f812f943e8688ddd04,
                limb3: 0x2f357906449761dabf39a7d
            },
            u384 {
                limb0: 0x1d1f9863f32a7dc2ecabcd9f,
                limb1: 0x32a1b109f7d26379d9ef0af5,
                limb2: 0x4329eeef6a6db5baa7452ec1,
                limb3: 0x8e3b662aeee86d52536c20e
            },
            u384 {
                limb0: 0xb8698d5bbd4a680fdeaab1e2,
                limb1: 0x662741f22d7caa53d6113d2c,
                limb2: 0x4b4e2db2ceb1d9fd33dc02db,
                limb3: 0x145a90e1e3604ea56600bef8
            },
            u384 {
                limb0: 0xc923bc3980e9889de42d1ba0,
                limb1: 0x32aecec3fd1ba535f714f11a,
                limb2: 0x107ec1d3d0e1fed306ccff31,
                limb3: 0x6bb43cb5d565c5e771079e2
            },
            u384 {
                limb0: 0xd84554286f7a08bc65b57e18,
                limb1: 0xf2efa5e817b54b40083851f3,
                limb2: 0x33c9d1888995a1fc5f852af7,
                limb3: 0x6dd0549f65b74b88174b1ef
            },
            u384 {
                limb0: 0x390a08d3779f56505f626f6c,
                limb1: 0xde6d73507e1a38bff3fa712f,
                limb2: 0x5f9eb0cd3109f5b312be8c77,
                limb3: 0xc58f6635da9cdbca1c61284
            },
            u384 {
                limb0: 0x846266db3dd3cb3c704b2b61,
                limb1: 0x83d58e09266ffc1ec1bf5e37,
                limb2: 0xad3fa0b6de8a6d761910f49d,
                limb3: 0xdb8dd2462d55697ec3672c8
            },
            u384 {
                limb0: 0x5aeb36139cc4ff934fd9ba8f,
                limb1: 0x8d9c809781ed1bab710e0315,
                limb2: 0x455d4e28eb27e1793afc9092,
                limb3: 0xbade8e2f68193daab19f6b2
            },
            u384 {
                limb0: 0xcfd9b33934f0bdee5dcd25b7,
                limb1: 0x9eb3214e5b167354142ea869,
                limb2: 0x12ac9b7ff914744b20a231f3,
                limb3: 0x3594f5933b87dd441c88b1f
            },
            u384 {
                limb0: 0x6ba1332a0d816d4afd6b3ceb,
                limb1: 0x59bd24bafd1343d986405744,
                limb2: 0x9ae5038ab81f9891daeac25a,
                limb3: 0x109f43002c7b33ea6bca1e75
            }
        ];

        let (final_check_result) = run_BLS12_381_GROTH16_FINALIZE_BLS_circuit(
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
            limb0: 0xe50bbd2f35e36c77c099d5a,
            limb1: 0x200d196cc6b526c197f9887,
            limb2: 0x843888427f8cbc15cf37cd9a,
            limb3: 0x161965d9c0ef153ab277931d
        };
        assert_eq!(final_check_result, final_check);
    }


    #[test]
    fn test_run_BLS12_381_GROTH16_INIT_BIT_circuit_BLS12_381() {
        let yInv_0: u384 = u384 {
            limb0: 0x61a35882708bd13cceb3cabb,
            limb1: 0xce3ef9d100cf015eef515cdc,
            limb2: 0x5d7f07642518c7e8f9de2a76,
            limb3: 0x1391d4eff21bfbb98e6ad5c2
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0xd1ab2405da0b45b247c9ddf1,
            limb1: 0x38f511d919e05916c54a1e23,
            limb2: 0x2e9c87b2406e0a0604c99c1a,
            limb3: 0x9c4b0ef928a23669eab8688
        };

        let G2_line_0: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0x7482af7fcc1898dce904c349,
                limb1: 0xbf76f7c581f61e9afea34025,
                limb2: 0x1616b10d038894050e8ca16f,
                limb3: 0x60b7498a8c150cc290f61f
            },
            r0a1: u384 {
                limb0: 0x21f2f77de8ebc38d38749470,
                limb1: 0xf2d11495966d3047f8d8a0c2,
                limb2: 0xa891e09a5b51adb006a2e761,
                limb3: 0x2b9a3c2bc72ba4f0c6319c
            },
            r1a0: u384 {
                limb0: 0x5f6543e4924de0111e1a439c,
                limb1: 0x8d4dd9f5d7dd38ce1e31fb8b,
                limb2: 0xa229024d212d4af7ce09c955,
                limb3: 0x16ac46738d5f63d486a57f1a
            },
            r1a1: u384 {
                limb0: 0x3bb376c9aed6165855ec696d,
                limb1: 0xc61870450a9d59f9e27f71fd,
                limb2: 0xd30ce37ce8a7979ce0170029,
                limb3: 0xeea0b0bdc50359a45b2246
            }
        };

        let G2_line_0_2: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0x790404d67d9271964c43bc46,
                limb1: 0xa246e34c3ea2df10ebbe39e,
                limb2: 0xf461b6ac6cd43517e1911462,
                limb3: 0x175b58955c22c91e8b4cb911
            },
            r0a1: u384 {
                limb0: 0xc22c08cbf43ab91468db6eba,
                limb1: 0x151d756e2cedff75a2b37a67,
                limb2: 0x37b1b3c4849846f633e7504e,
                limb3: 0x5969fd2e98992c97e2b6682
            },
            r1a0: u384 {
                limb0: 0xd1dfd5ed8a1e6882da516fed,
                limb1: 0xe163f432198024d41ceea295,
                limb2: 0xf3aed47770031524e2ee540d,
                limb3: 0x12a1faca05d60d2624ba6148
            },
            r1a1: u384 {
                limb0: 0x32ed2a9427376381ff75e55d,
                limb1: 0xb4c0d63940c125d7db741ac1,
                limb2: 0x79546a17388a4e7b4fa51a73,
                limb3: 0xa54d859bce3c4b29555b6d5
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0xd11dfdcc27be1b754868f62d,
            limb1: 0xc222a34e63c582e912564ae3,
            limb2: 0xc3d95fe5875a733302d00226,
            limb3: 0x775ad907daae99cdf4e5a0c
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0xa4430460f30f2e1c4440f17,
            limb1: 0x17c067c465556e8ea86058f3,
            limb2: 0xea8db0759e7b629493bbaa28,
            limb3: 0xac0e38e813635b47e627fd8
        };

        let G2_line_1: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0x927df9ddaca228aaeefc44f5,
                limb1: 0x5fa7039676716ac7f78641eb,
                limb2: 0xc1297e8e34cf3d5d51176e9b,
                limb3: 0x14367b81c5bf954d0a9c40c0
            },
            r0a1: u384 {
                limb0: 0x54e44ed935b19400054639ff,
                limb1: 0xaabca6a0500fa045c46885e1,
                limb2: 0x8cb8ad13ebf7b8443a389781,
                limb3: 0xa937a18568417d0775e3686
            },
            r1a0: u384 {
                limb0: 0x6d7f362df5f1932559df4212,
                limb1: 0xa28ab6055dbd0c9ac1754788,
                limb2: 0xfaaa0c92da178bceb321287a,
                limb3: 0xab925b5c5d21bfd5efc2eb3
            },
            r1a1: u384 {
                limb0: 0xa0935b402d0f4850066dad7,
                limb1: 0xf0ae75be60986886ff8f0747,
                limb2: 0x94a5e027ddd5517ef20ef63f,
                limb3: 0x16573b316219f57f82fad041
            }
        };

        let G2_line_1_2: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0x83dbcc95a7c7ec6cd6747da9,
                limb1: 0xce0c6acabf284e4fa327bbde,
                limb2: 0x3dab6e3029cc50b98ce8be89,
                limb3: 0x975ab08b0c7e10e3c4fd2fa
            },
            r0a1: u384 {
                limb0: 0x68e5f17a43452a22656f30e6,
                limb1: 0x59ec7ed56d6f8f7b6fcbdfef,
                limb2: 0x87b0ff89de1e714917a8cd25,
                limb3: 0x8733a4043b8d1d00bd0ce6d
            },
            r1a0: u384 {
                limb0: 0x17dd4ab3cea8c1dae9ab3ba4,
                limb1: 0x6c4cd909d97a37da9c186c30,
                limb2: 0x596a9ac574ea597f9e4f6dc8,
                limb3: 0x1173f1af89828bd1ba7f4161
            },
            r1a1: u384 {
                limb0: 0xc8498c44ed0a361415754246,
                limb1: 0x2a4fab587f104df74fc8bc09,
                limb2: 0x50b3940cf3be2b732abbd70b,
                limb3: 0xabe38feacb3e64b4b2b0839
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 0x9f9e4255e6f87c17d62ccc21,
            limb1: 0x9b28fcc2c55508164fd68274,
            limb2: 0x97a159083a37beb330d04ed6,
            limb3: 0x77fc4f826daf4e366840eb9
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 0xfa4e30e41c1c516aea8598eb,
            limb1: 0x11e180aa01422f75b872b60c,
            limb2: 0x14d71c509f34d0a0afba4179,
            limb3: 0xfc114452ddc1d7714795432
        };

        let Q_2: G2Point = G2Point {
            x0: u384 {
                limb0: 0x4303abc5c0408a56b38d72cd,
                limb1: 0xfccf05c40bcc06cab2a2882c,
                limb2: 0x2028332f9a0ede79d3f03d51,
                limb3: 0x2abf0a8212da1b36a02ec75
            },
            x1: u384 {
                limb0: 0xf8c6034cd1ea3330e274bf60,
                limb1: 0xb25ab80eb99187979ffbf8a0,
                limb2: 0x9e74bde9422a28414de33282,
                limb3: 0xf76a0a09698bdcffb3762f7
            },
            y0: u384 {
                limb0: 0xa15d00f2abff0c7bd03cbbbc,
                limb1: 0x33976f54a627111ca74192a6,
                limb2: 0x9038da1ada87a62315a3899d,
                limb3: 0xc1bf6d1b88b1b711d458d56
            },
            y1: u384 {
                limb0: 0x25a3fcce448f6e9f18e5c21f,
                limb1: 0x68cce369339bace88bb366b2,
                limb2: 0xc4cd7d57359b05fa3ed3bfbf,
                limb3: 0x144c4fe91b323b5c91bd3fdf
            }
        };

        let R_i = E12D {
            w0: u384 {
                limb0: 0x34c9b3f595652825761fa15a,
                limb1: 0x35c8e6889c9764179c186760,
                limb2: 0xa5a71d49a22e53c08f708e40,
                limb3: 0x1347afd2ff42be6012201b28
            },
            w1: u384 {
                limb0: 0x6b375ff094e5ac7f655a3517,
                limb1: 0x5d9f2ccc16d1d003d422f5e4,
                limb2: 0x10e15c52b35eab188709d316,
                limb3: 0xc2a6ef64078a40cf2f1dd4
            },
            w2: u384 {
                limb0: 0xf4ade20829a64a4ddeb4e630,
                limb1: 0xd80b9ba8a0013df020c34a55,
                limb2: 0xbfcc6553148a23d2ad095b96,
                limb3: 0xc18924f05e5ca2fb673d4be
            },
            w3: u384 {
                limb0: 0xb9b4082e7f232de8e289b52d,
                limb1: 0xc143ddd7e251da176ad71e4f,
                limb2: 0x955947b1518f5a8c8dab74d2,
                limb3: 0x6696cb8c4e59aea265bda70
            },
            w4: u384 {
                limb0: 0xaca3decf9c0df09d17e5c88d,
                limb1: 0x78aa08cd9063245b63c8393e,
                limb2: 0x5453e720c2743edb9489cd28,
                limb3: 0x3dc535860316c76d2764690
            },
            w5: u384 {
                limb0: 0x914ca75ab3cd5e52eaf68027,
                limb1: 0x5cc9a8224d3735939d486bf1,
                limb2: 0x1fc1f605280cddb8049abf9d,
                limb3: 0x19ea8efd048f01ffc75833ca
            },
            w6: u384 {
                limb0: 0x8d88d35691eb585b43fd43e1,
                limb1: 0x1fb975e25219d5c3ed879e84,
                limb2: 0x89f20d3cc2eadc4d90b4583f,
                limb3: 0x334257a3d7527e8f43562cc
            },
            w7: u384 {
                limb0: 0x7789ab37e7a5c9c1b5afbee9,
                limb1: 0xd9703f517866d51ca2672c74,
                limb2: 0xfcee09333bf9264b7df21e27,
                limb3: 0x11798701d28b1966010e6b8e
            },
            w8: u384 {
                limb0: 0x578679694915bd8e3ec93645,
                limb1: 0xe9d08d3b398e97a5cd2928a3,
                limb2: 0x663257fcfb8e42b0551926d7,
                limb3: 0x569e84b335a13911fa7d303
            },
            w9: u384 {
                limb0: 0xd87f8fab8eeec71685d9ac1b,
                limb1: 0x686cdeaf9dc701aaccd3b640,
                limb2: 0x689f74ea108e077795b71925,
                limb3: 0x47ba38f07275eca74424556
            },
            w10: u384 {
                limb0: 0x8829bb652f12c31c01987d27,
                limb1: 0x801072b8ab2fead91dfe8d40,
                limb2: 0x91c81918748c3af0a7be5443,
                limb3: 0x8380bd571d12f7f51517caf
            },
            w11: u384 {
                limb0: 0xdbcf116bcadc401ed21f67ba,
                limb1: 0xc8185e5ac72e9c73fd04da3d,
                limb2: 0x9346263c39a87c03058f9ff4,
                limb3: 0xaa2364ac0d636e569a27add
            }
        };

        let c0: u384 = u384 {
            limb0: 0x4000e2b392d2037a4a5976bd,
            limb1: 0x77c7af5d8dd9c7d4d4262bbe,
            limb2: 0x84ef3608e237f217cd91d316,
            limb3: 0xdef93c86fa3db083e0af3ee
        };

        let z: u384 = u384 {
            limb0: 0xd4e36136ab804901e24d0a03,
            limb1: 0xcbf47a47bafb3c414377eb7f,
            limb2: 0xa6fed2af61e15d8ab2da3dc4,
            limb3: 0xa9ee3909dca9181cdeb699f
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 0x1a1ea45abf58abbd31453f8d,
            limb1: 0xf1254b023b547015b8ea558f,
            limb2: 0x26a0bb36775e9378f67473f9,
            limb3: 0x73830b4c57745be0ad9620c
        };

        let (Q2_result, new_lhs_result, f_i_plus_one_of_z_result) =
            run_BLS12_381_GROTH16_INIT_BIT_circuit(
            yInv_0,
            xNegOverY_0,
            G2_line_0,
            G2_line_0_2,
            yInv_1,
            xNegOverY_1,
            G2_line_1,
            G2_line_1_2,
            yInv_2,
            xNegOverY_2,
            Q_2,
            R_i,
            c0,
            z,
            c_inv_of_z
        );
        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 0xa4fd6945fb322da1456904a,
                limb1: 0x7e69f96d43f947cfa9e18510,
                limb2: 0xb87b7fed976a2e94d5e055df,
                limb3: 0x12e8e6b3777a809f3b86adb2
            },
            x1: u384 {
                limb0: 0xf1369876fb16c9323e5424c9,
                limb1: 0xed18ffa9ac20374c6f1f913e,
                limb2: 0xe311d9b2847afada84045fb6,
                limb3: 0x4a1bc1fa1048aeef6828fff
            },
            y0: u384 {
                limb0: 0xcd1f4be46bc32c648c2aad13,
                limb1: 0xf06784c05b219d383e6fc6a1,
                limb2: 0x28302f9682c3be7cba864cf4,
                limb3: 0x13fd40303015b59340490a82
            },
            y1: u384 {
                limb0: 0x8854dfccfa5abf90a6103634,
                limb1: 0xf6600d7958c26af610707f3b,
                limb2: 0x97c55a6d58d14e477b14bb20,
                limb3: 0x6007290db07f33889f7049
            }
        };

        let new_lhs: u384 = u384 {
            limb0: 0xf587c9944d08e09d66edca96,
            limb1: 0x85c05a88a6832a9d75dcc994,
            limb2: 0x57b538e35d9fc157ef1fb02c,
            limb3: 0x86d0f881ae3f0b02695bfa
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0x9b6210cf2485c5d1b2404d45,
            limb1: 0x8ea3d4e0077f9af22fa07039,
            limb2: 0x1d2789b8a15f34992ab3e55,
            limb3: 0x19599bfd88a5c50492c2ba8f
        };
        assert_eq!(Q2_result, Q2);
        assert_eq!(new_lhs_result, new_lhs);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
    }


    #[test]
    fn test_run_BN254_GROTH16_BIT00_LOOP_circuit_BN254() {
        let yInv_0: u384 = u384 {
            limb0: 0x6a4a7f7008415966ad7b787f,
            limb1: 0xf96544a7834d88db7e10fabc,
            limb2: 0x30d6909a158972b,
            limb3: 0x0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0x3331c18cd4055fa2d660600a,
            limb1: 0xba5a29ff752d67f6569a6d1f,
            limb2: 0x245898ed2f1d4b70,
            limb3: 0x0
        };

        let G2_line_0: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0x9224fa0365d3eed327bb556,
                limb1: 0x4b2d72131e82b4bb3335219c,
                limb2: 0x14b4ee45c1e1b6e1,
                limb3: 0x0
            },
            r0a1: u384 {
                limb0: 0x4e0422b4bb9f636e5477afc1,
                limb1: 0x2e35240924d592f6cb574070,
                limb2: 0x2e1dcb4a938dc1b9,
                limb3: 0x0
            },
            r1a0: u384 {
                limb0: 0xe25d61b4694e1286a430fc7,
                limb1: 0xcc35eb9161f1325bf1fb9fe5,
                limb2: 0x7129e45cebf722d,
                limb3: 0x0
            },
            r1a1: u384 {
                limb0: 0xf988818c91a029ccc1bbdab8,
                limb1: 0xeaf9de49db8386fbcaebe9de,
                limb2: 0xa633d4f7f68a5b3,
                limb3: 0x0
            }
        };

        let G2_line_2nd_0_0: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0xc90f3f1a61473a02cad928d4,
                limb1: 0xc3007cb168f76fd638d34dd6,
                limb2: 0x83d3aab631c3308,
                limb3: 0x0
            },
            r0a1: u384 {
                limb0: 0x714bb95ea1bfefca8f6262db,
                limb1: 0xb051460d9f78e41ee237056f,
                limb2: 0x17359511d05366cc,
                limb3: 0x0
            },
            r1a0: u384 {
                limb0: 0xa4b10a7d0bc711a9eb4194a0,
                limb1: 0x3a4bcaab8659cf439de8ddf4,
                limb2: 0x20d53813374049d3,
                limb3: 0x0
            },
            r1a1: u384 {
                limb0: 0x396836c77c79ed7c664aaa39,
                limb1: 0x14079f9eba95b4f6925f47cb,
                limb2: 0x71b438d8a5082e2,
                limb3: 0x0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0x2a4be525e134e7a5273dad16,
            limb1: 0x51b316f6073665614da72eb9,
            limb2: 0x865a2d81d2152f4,
            limb3: 0x0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0xa33c8dc3f69cd7e29e81d102,
            limb1: 0x9e7b6789873c6d8bfeeb9881,
            limb2: 0xb803b2fca1871c6,
            limb3: 0x0
        };

        let G2_line_1: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0x41a449086a8640178be6aeb4,
                limb1: 0xc9e1893ec3fb37430361194e,
                limb2: 0x8d04c785dce8477,
                limb3: 0x0
            },
            r0a1: u384 {
                limb0: 0x3756af5183dc01010b63983c,
                limb1: 0xaac487b171db0784b71df25e,
                limb2: 0x1148931e9cf52508,
                limb3: 0x0
            },
            r1a0: u384 {
                limb0: 0xdc8848ba6ab09995c78e0f48,
                limb1: 0xf5a3f57c637c71aef9862da,
                limb2: 0xff27c52c05f9874,
                limb3: 0x0
            },
            r1a1: u384 {
                limb0: 0x5f0099167df8b7f044a1d4d0,
                limb1: 0xee1ce2b4b385492d4c6700b,
                limb2: 0x10f382e0fee2f56b,
                limb3: 0x0
            }
        };

        let G2_line_2nd_0_1: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0x5bf2b6a11b95cd28b2764173,
                limb1: 0xeaaa5a3e31dbd1d548e003be,
                limb2: 0xee2ee03572de2ff,
                limb3: 0x0
            },
            r0a1: u384 {
                limb0: 0xd4ae04b3fab2a7803dbe0be0,
                limb1: 0xaf5f7bd63021c8ad3302a5ca,
                limb2: 0x7c9974060e248c1,
                limb3: 0x0
            },
            r1a0: u384 {
                limb0: 0x405e342dfbe30bf988f1559e,
                limb1: 0xf86040142b3c1658aa3042f9,
                limb2: 0x162a6df5f61d103d,
                limb3: 0x0
            },
            r1a1: u384 {
                limb0: 0x6e090ea64032ee1e75711fc,
                limb1: 0xab46afee8898a682e0968f21,
                limb2: 0x2237c0c10b320459,
                limb3: 0x0
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 0x1c0989b1af56d7ba6f086f65,
            limb1: 0xb58e2a1ccdf53f9b4102364b,
            limb2: 0x20b73dcd33744da6,
            limb3: 0x0
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 0x8d87b7e8ac91b72f6c14b828,
            limb1: 0x25bc36a32df19dfb5a5915c2,
            limb2: 0x7cd5d03cc2946f5,
            limb3: 0x0
        };

        let Q_2: G2Point = G2Point {
            x0: u384 {
                limb0: 0xd8d02c0dbb4e01c54980588c,
                limb1: 0xc2411753bd3a98bdcc583f50,
                limb2: 0xb22506f4b7118ac,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xb092a5ff948c2d4389fb4504,
                limb1: 0x7a440b3413e34b3d3d946990,
                limb2: 0xc55d173ccfcd746,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xfc8ba273caa7b1c81a71a203,
                limb1: 0xd12ea61b76ad2cfc23f4fe14,
                limb2: 0x167ab9a6a09c93de,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xd24f8f4351a2fa157b6c0adb,
                limb1: 0x7bef34f04fc3489b9c14c815,
                limb2: 0x12235a882415f2a3,
                limb3: 0x0
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 0xb0a1baa56921c1c00bae07a2,
            limb1: 0x76ad98ba10fb5581cccb4dfb,
            limb2: 0xb5c580897ec1a40,
            limb3: 0x0
        };

        let f_i_of_z: u384 = u384 {
            limb0: 0x1ce76bc0c34c3f471171c294,
            limb1: 0x3b34252964d63e97de6ff3f1,
            limb2: 0x280ca50f4ab878c7,
            limb3: 0x0
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 0xf11e71ae6ce2a4651b742111,
                limb1: 0x955e988df24bfd76a07f949e,
                limb2: 0x12e643b9f6714d76,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0x8615ad73699303f1bde82282,
                limb1: 0xe31b328e3a3262055e26b29d,
                limb2: 0xfb49e12c6950d85,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0xa6db74d1a748687529bdf604,
                limb1: 0x1ddde15af323e4341bbf9922,
                limb2: 0x26bc799b890974e4,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0x99225957ee705259262ae4c4,
                limb1: 0x2fd8e8ebe14880c0994d799a,
                limb2: 0x15ddb694f8c03d19,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0xa886e763c2c49a972e6f1665,
                limb1: 0x55b1f1c6059251e1de0a09a6,
                limb2: 0x6952b2c265a9190,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0x9b3e660550835669836cd602,
                limb1: 0x1a29313d3f74df9ae43bd530,
                limb2: 0x2fae5a58bc16ca04,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0xf856a0c38fda05f0e45d7a7c,
                limb1: 0xbc7838b31a9af2a3ec6b2ea2,
                limb2: 0x1e8fa641aeef4b09,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0xb2b5591a9d7f542b85e2b078,
                limb1: 0x7e54ed03eef42592ec1c6fe4,
                limb2: 0x157302c349556582,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0x173235659dc257bde19dad46,
                limb1: 0xa246b8560a94891e357245f9,
                limb2: 0x19dae528ecd2742d,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0xb916751942a699a5571cf04d,
                limb1: 0xb36cddb8beabdee5c8614c36,
                limb2: 0x43fd37ae6ff73b5,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0x733db528d4323934cda9cfae,
                limb1: 0x9ca574d20979829cc898b6a,
                limb2: 0x632d384abe04a61,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0xb5743132ef3822707072aa51,
                limb1: 0xc34920a7fcfa3a3b47f050aa,
                limb2: 0x10453e8455b3b1ac,
                limb3: 0x0
            }
        };

        let z: u384 = u384 {
            limb0: 0x5cae1234bb10d4065a55805d,
            limb1: 0xe8ebbae25bc1c77afa29fad9,
            limb2: 0x2df54b73f2aaaaf0,
            limb3: 0x0
        };

        let ci: u384 = u384 {
            limb0: 0x47595fb338b4372600cea03,
            limb1: 0xa0e38dd6f700358564d06b24,
            limb2: 0x2275e2ac94be4e35,
            limb3: 0x0
        };

        let (Q2_result, f_i_plus_one_of_z_result, lhs_i_plus_one_result, ci_plus_one_result) =
            run_BN254_GROTH16_BIT00_LOOP_circuit(
            yInv_0,
            xNegOverY_0,
            G2_line_0,
            G2_line_2nd_0_0,
            yInv_1,
            xNegOverY_1,
            G2_line_1,
            G2_line_2nd_0_1,
            yInv_2,
            xNegOverY_2,
            Q_2,
            lhs_i,
            f_i_of_z,
            f_i_plus_one,
            z,
            ci
        );
        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 0xcb5d8e4a9274c8c38450c6a3,
                limb1: 0xbe94e1fce29aacac0ec3fcb8,
                limb2: 0x208f1525ec674f68,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x7760c78c5c0fb391369a569a,
                limb1: 0xd59b91513b9569c8d34b4fbf,
                limb2: 0x300bc353b0426327,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x6722605f5f694549d6effe79,
                limb1: 0x971a6625cad9273698ecc367,
                limb2: 0x22abb31d9aa65ebc,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x445440ed3b9f9c0ed39c891f,
                limb1: 0xef98e50365d0f4de42af5b67,
                limb2: 0x2198458cf9b0f09e,
                limb3: 0x0
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0x1effc528272f6688c76e1a2a,
            limb1: 0x406843b759e273ef72d9601a,
            limb2: 0x66c4f4a007a4b1c,
            limb3: 0x0
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 0x74228d993bac66b6aaa47560,
            limb1: 0x576888278bc240148117ff22,
            limb2: 0x1ffd5fd44091db67,
            limb3: 0x0
        };

        let ci_plus_one: u384 = u384 {
            limb0: 0xc5beb0eb5b3b7cfbb6b30889,
            limb1: 0xba2dc8218fe57eefbd6681cc,
            limb2: 0x1e54870397dc6b0d,
            limb3: 0x0
        };
        assert_eq!(Q2_result, Q2);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
        assert_eq!(lhs_i_plus_one_result, lhs_i_plus_one);
        assert_eq!(ci_plus_one_result, ci_plus_one);
    }


    #[test]
    fn test_run_BN254_GROTH16_BIT0_LOOP_circuit_BN254() {
        let yInv_0: u384 = u384 {
            limb0: 0x7e41b9af9ba788497b51a1fa,
            limb1: 0x6234a39f3eb913924c041d5a,
            limb2: 0x2dbb24eddf0b60b9,
            limb3: 0x0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0x54e1b6c1584957f20f1f41f3,
            limb1: 0x16fca750fa679a042b44d7a2,
            limb2: 0x11ab585c8f72b28c,
            limb3: 0x0
        };

        let G2_line_0: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0x1975d43754c97c0f19e9ea9,
                limb1: 0x9ed03a7ecfc80b4ecab68ee4,
                limb2: 0xa386a2ba0225512,
                limb3: 0x0
            },
            r0a1: u384 {
                limb0: 0xbc0f91ee242834fddb3d6636,
                limb1: 0x913e7095fff706948ecc8c9d,
                limb2: 0x2b870e1156768476,
                limb3: 0x0
            },
            r1a0: u384 {
                limb0: 0xd838f3ce74448cb3be767191,
                limb1: 0x114eb0dab17b08aedeb5b9e5,
                limb2: 0x18ee9370ca907b30,
                limb3: 0x0
            },
            r1a1: u384 {
                limb0: 0x6bd2623a140895d0281bb255,
                limb1: 0x830d98eec1c30b57dd56dae3,
                limb2: 0x1cfb079edd159d1d,
                limb3: 0x0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0xf5a182c5d246fd226b8f76fa,
            limb1: 0xb11edb4321d98c6456eebfe7,
            limb2: 0x23f15fdeeed5c0da,
            limb3: 0x0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0x9743dbc8fba435db5c0d4feb,
            limb1: 0x151a3787d03e6d922b243c58,
            limb2: 0xf81e3e917c98c2e,
            limb3: 0x0
        };

        let G2_line_1: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0x3104f7c5f1525077a7806577,
                limb1: 0xdb690711cb1dad0d0717eb47,
                limb2: 0x151ba089604ff4fe,
                limb3: 0x0
            },
            r0a1: u384 {
                limb0: 0x97046d7c5ae4425743a9da5b,
                limb1: 0xe89a006d71638db040af9066,
                limb2: 0x2ff8679684e9b5ff,
                limb3: 0x0
            },
            r1a0: u384 {
                limb0: 0xe0467889390b72fad8821713,
                limb1: 0xbeb6533abca281f1c1c7f10b,
                limb2: 0xf34c8c794824ae,
                limb3: 0x0
            },
            r1a1: u384 {
                limb0: 0x564220e6cfc2df16dad107d7,
                limb1: 0xf888932ef45a6a8736e11fc9,
                limb2: 0x165434af900e7701,
                limb3: 0x0
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 0x29a9464bcd024ec04b2bac3c,
            limb1: 0xb76db463b9f15b792d53f13c,
            limb2: 0xcc7f35c47f559ef,
            limb3: 0x0
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 0xf26b659bf85cfc9ecf130e07,
            limb1: 0xbc6bf04b5a3d4eac1e682c1f,
            limb2: 0x9e0d90c60c3746c,
            limb3: 0x0
        };

        let Q_2: G2Point = G2Point {
            x0: u384 {
                limb0: 0x417358fdcfc30c954d42c150,
                limb1: 0x9f747716ffa857c8b5f284e0,
                limb2: 0xabb8055d3e4df8f,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x716e1dd67ddf42ddd761afc,
                limb1: 0xe80a2294f3cfeea6aac41158,
                limb2: 0x4f85149d2e922b3,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xed3696ce2f914af5d2c1d26b,
                limb1: 0x140d016e6966437363eca19a,
                limb2: 0x2b4d63ff13addef2,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x892324d63ffdd31f91c73e1d,
                limb1: 0x52f29d2c3747414b1140e8ae,
                limb2: 0x1cf9099ebe0d894c,
                limb3: 0x0
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 0xb75d980a8ed20f4cfc34ed28,
            limb1: 0x191f3240cb4ced8b9b97e907,
            limb2: 0xad9d6b8c5d21579,
            limb3: 0x0
        };

        let f_i_of_z: u384 = u384 {
            limb0: 0x28db5021e56a3078cf7d511b,
            limb1: 0x969d78309b08492ec413e9ba,
            limb2: 0x3182a629bbab50a,
            limb3: 0x0
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 0x701a484ef57b6006dfc0993b,
                limb1: 0x36bbde06429a8f86c6b23bac,
                limb2: 0x3e56e2289600a04,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0x44ec9a812c19b827e5c99ac,
                limb1: 0x981f25ed0c7c9761a617fe49,
                limb2: 0xaf732b43027bdbd,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0xa8964ce0c132222a7e192ce3,
                limb1: 0x4a789a0e855f27d43303cc12,
                limb2: 0x2f668c93932b99a5,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0xe23b0e070035d58bca6838d1,
                limb1: 0x559ba0b79ec80afbfcb9d139,
                limb2: 0x13d3cbdda7d364c3,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0xcabfcd948beace4de4f44028,
                limb1: 0x4dc557e294ad651639e72e2a,
                limb2: 0x24bb3547031e3c42,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0x19b6edfad219c7785891a706,
                limb1: 0x262acd409067f7264ce68c93,
                limb2: 0x274621f5a23c2f2,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0xd659182603b62dc0b927ee07,
                limb1: 0xe8bb1f2998d38b06a4545742,
                limb2: 0x19a16d53d17d4cc0,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0x3bc3f21f6e95a644022b6290,
                limb1: 0x91fd78156e3f32e8d22428c0,
                limb2: 0x12cf46ca770bd8a7,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0x2cede02f0114a577d00fb068,
                limb1: 0x744d732592a90fd2b0a35f75,
                limb2: 0x452b3e389b58d29,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0x3814d2bc6c6c6dea5dc21c9,
                limb1: 0xcc2fce640b31ec7eab39109c,
                limb2: 0x826ba741744bed8,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0x99063e5b6237e31e64b57def,
                limb1: 0x384a28d2bbe7dec42cdd9303,
                limb2: 0x2312633aa6a1e781,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0xdda6d27207a1cfb21b85e81d,
                limb1: 0x67c6e2b264fe79c20a77e6a1,
                limb2: 0x121c660cd0fce12b,
                limb3: 0x0
            }
        };

        let z: u384 = u384 {
            limb0: 0x615acc4ad79d92bc2bd11b15,
            limb1: 0x519ff558aba1a4b506bba00e,
            limb2: 0x1ae0b9e0a14d7071,
            limb3: 0x0
        };

        let ci: u384 = u384 {
            limb0: 0xec52cef13374263e84cf7446,
            limb1: 0x5b34a62acfc250da838e0b04,
            limb2: 0xfbf78509889cbe1,
            limb3: 0x0
        };

        let (Q2_result, f_i_plus_one_of_z_result, lhs_i_plus_one_result, ci_plus_one_result) =
            run_BN254_GROTH16_BIT0_LOOP_circuit(
            yInv_0,
            xNegOverY_0,
            G2_line_0,
            yInv_1,
            xNegOverY_1,
            G2_line_1,
            yInv_2,
            xNegOverY_2,
            Q_2,
            lhs_i,
            f_i_of_z,
            f_i_plus_one,
            z,
            ci
        );
        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 0xbf9601a2dd1a30d6aaf1a10d,
                limb1: 0xf4217b976c5af207bc489fc3,
                limb2: 0x1f6f1f49d355ffa5,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x45684e03619987246f7abe3,
                limb1: 0x1a411c80da200ee1e6c17e90,
                limb2: 0x178ba042e81e673e,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xe55a4c92e355d226c1bea5cf,
                limb1: 0x8d51cea46aa4460ed26dba05,
                limb2: 0x126d4e4dd1656a3e,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x5c2d3cb365507cb583eddab3,
                limb1: 0xe1379c2a63490ed81aa7e901,
                limb2: 0x4e53ea8fa85080b,
                limb3: 0x0
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0x200f1303681a353c7aef1a90,
            limb1: 0xa0859b93fd4a3b542b428464,
            limb2: 0x1be0ef45293f88ce,
            limb3: 0x0
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 0x6eb2dbcdc0c408f32e01bb32,
            limb1: 0x6f9d04a4b1f1dc478d5f40c5,
            limb2: 0x1b64337ca39ea84e,
            limb3: 0x0
        };

        let ci_plus_one: u384 = u384 {
            limb0: 0xe5294ad23953034c2a751b37,
            limb1: 0x90c12b2dd1479883f11cf0ed,
            limb2: 0xf1f527e21ad5052,
            limb3: 0x0
        };
        assert_eq!(Q2_result, Q2);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
        assert_eq!(lhs_i_plus_one_result, lhs_i_plus_one);
        assert_eq!(ci_plus_one_result, ci_plus_one);
    }


    #[test]
    fn test_run_BN254_GROTH16_BIT1_LOOP_circuit_BN254() {
        let yInv_0: u384 = u384 {
            limb0: 0x631d91b5073039f1e6ad906,
            limb1: 0x17bcd32324b441266f1f7a15,
            limb2: 0x80097e0d5d0a12d,
            limb3: 0x0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0xe9edc59ca80ab2000cfcbe46,
            limb1: 0xf6bd16ac4ab507018e6b81a3,
            limb2: 0x303e940c326e1983,
            limb3: 0x0
        };

        let G2_line_0: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0x3e0f74885c88c320a7b0a957,
                limb1: 0x15362c1f90b359d9ff0a837a,
                limb2: 0xe45d6bac38efb8c,
                limb3: 0x0
            },
            r0a1: u384 {
                limb0: 0x5140094b6ed4e645aaed8b53,
                limb1: 0xb2363b7ea221c908a4edeefd,
                limb2: 0x125881cea0f9986a,
                limb3: 0x0
            },
            r1a0: u384 {
                limb0: 0x75f98f4110a15299054efa50,
                limb1: 0xf106892ba1fa46f346685cdd,
                limb2: 0xdaf189a61af473d,
                limb3: 0x0
            },
            r1a1: u384 {
                limb0: 0xe9a28f3cb9abe19f2911cf30,
                limb1: 0x28685bdd02c81d1173f19747,
                limb2: 0x2b0c5edd82ab3e,
                limb3: 0x0
            }
        };

        let Q_or_Q_neg_line0: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0xfdcb8a6e9265da012aad0659,
                limb1: 0xcb771b1e922ba0aae055b94,
                limb2: 0x17aaf63d178234e8,
                limb3: 0x0
            },
            r0a1: u384 {
                limb0: 0xaaf5cc090de68b59c4841813,
                limb1: 0x39e65a53dd59195f39745c90,
                limb2: 0x1057f53c7f137c0d,
                limb3: 0x0
            },
            r1a0: u384 {
                limb0: 0xca70c69290d8416a4fe569dd,
                limb1: 0xa797765abc854e3f5fe1ea9c,
                limb2: 0x14106cf489506262,
                limb3: 0x0
            },
            r1a1: u384 {
                limb0: 0xc4fc4cd0a78d1e08fc4358e5,
                limb1: 0xfcc597637f449eceb2db458c,
                limb2: 0x2778684eed01d648,
                limb3: 0x0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0xd7d5f9bdd3e47e37817d6729,
            limb1: 0x3e6836da0cc9b533c68ddf7d,
            limb2: 0x2f6d7fc72141b402,
            limb3: 0x0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0x3b6b8130f6874f7a36834a01,
            limb1: 0x1b04eaa423f33d5519248947,
            limb2: 0x266e1fd70aa1ee6f,
            limb3: 0x0
        };

        let G2_line_1: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0x9708539e176f1bd98f43392b,
                limb1: 0xcdbdc97fb9fddad9d6659f3a,
                limb2: 0x1bc199d99d672b49,
                limb3: 0x0
            },
            r0a1: u384 {
                limb0: 0xa0302c1d86294f4da2cb0fef,
                limb1: 0x519b756bf631dae1e1cb6691,
                limb2: 0x216a855eb409e558,
                limb3: 0x0
            },
            r1a0: u384 {
                limb0: 0x9c514c712071986835f295fa,
                limb1: 0x4b3d15c68dcdfa954cab56c3,
                limb2: 0x19b8282aac3d0478,
                limb3: 0x0
            },
            r1a1: u384 {
                limb0: 0xc1e75ade858e8dfb98468947,
                limb1: 0x92162634754151b00cdff20e,
                limb2: 0xfd513e0911dc9fc,
                limb3: 0x0
            }
        };

        let Q_or_Q_neg_line1: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0x438fa43064851962ecf75dbc,
                limb1: 0x4ebb7bc5a9988bcc8e83e494,
                limb2: 0x7be0087bce9ff07,
                limb3: 0x0
            },
            r0a1: u384 {
                limb0: 0x92c47c9950625b3bd2385cf5,
                limb1: 0x4174dc65f9646b27b4652600,
                limb2: 0x2c8d61cbf68273bd,
                limb3: 0x0
            },
            r1a0: u384 {
                limb0: 0xb020b8d4529beb354fa09d36,
                limb1: 0x6f8b6cbeb759f3ec13843901,
                limb2: 0x15d11acbddb3d8ee,
                limb3: 0x0
            },
            r1a1: u384 {
                limb0: 0xcf34bb3d01bf23f5be3bcc64,
                limb1: 0xf7198e17d7523baf1bc238a3,
                limb2: 0x2dc1a2c9fef16ca9,
                limb3: 0x0
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 0x96bead62d52da285543e882c,
            limb1: 0x32476a228ea70cf11aff2f25,
            limb2: 0x2b149c599224e274,
            limb3: 0x0
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 0xefda59820148a3cfaaf35967,
            limb1: 0x4a0e78404aec0bdee2f75b1,
            limb2: 0x2feb4bc54f646b90,
            limb3: 0x0
        };

        let Q_2: G2Point = G2Point {
            x0: u384 {
                limb0: 0x844ea6df1c34198a766c7fca,
                limb1: 0x51cd1e8e8294364aa7b6d64,
                limb2: 0x2f68b4877fe88e46,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x99d80fa6f0f4c87c9a7e5755,
                limb1: 0x1b52cc064b5e5471c6400708,
                limb2: 0x2c61d653577b1f95,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x628f2a7a27503d1e1756e0d4,
                limb1: 0xd0576ddf43237e0874d43d6d,
                limb2: 0x11d07ec55942adba,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xaf5c0b9ceaaf74b39fee75fe,
                limb1: 0xc4275f0abf9d32abf28cd582,
                limb2: 0x2d6a641d38b48c97,
                limb3: 0x0
            }
        };

        let Q_or_Q_neg_2: G2Point = G2Point {
            x0: u384 {
                limb0: 0xf7d9dde98d19ce5e2edd4d37,
                limb1: 0x4251bdb2776adad8744f957f,
                limb2: 0x603dc8c79cb26d2,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xf755b4635c340e9440400fe8,
                limb1: 0x5c273f31551a9eb6dcade3bf,
                limb2: 0x1891b3820e9920ec,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x2c8cb3fc5759b929ab9873c4,
                limb1: 0xe2238f5548e422fdf89ed0ff,
                limb2: 0x2d611b279e32aa0,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x4d86eddb811908408a6464fd,
                limb1: 0x45276f0fecbdaec951b8c4b5,
                limb2: 0x27b2f3e5c201af5a,
                limb3: 0x0
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 0x133a2a8251e1cdaaa0766bc3,
            limb1: 0x595af0cfd16a2182fc408b2b,
            limb2: 0x14499b0d4443d7f,
            limb3: 0x0
        };

        let f_i_of_z: u384 = u384 {
            limb0: 0xd4c02dad72e74f09cef22861,
            limb1: 0x5be01ab72c7db93f9f51a24a,
            limb2: 0x2764c115e6219ba4,
            limb3: 0x0
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 0x43b1aaafb1d1958c4b69ba53,
                limb1: 0x720c0d000077c6f07dba43cf,
                limb2: 0xf9d2629286334df,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0x3bbaa05bf77bf1ce58fb4205,
                limb1: 0xa40c0ab3dfc753aa1d0f64d2,
                limb2: 0x18527bc90c33ceda,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0x60fcf5dacac385bb71f7088d,
                limb1: 0x994269b4dd60375aa585cd11,
                limb2: 0x25943f8d5df6c49,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0xad9d81e70685e760530d9dac,
                limb1: 0xf7a2b187758eff25033f692f,
                limb2: 0xd94b8014002f669,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0x77183b112d130744b253a635,
                limb1: 0xc497449db20fe04d1a4a17e1,
                limb2: 0x199d9933bcea20e0,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0x43ab4db80e45aea58fdd2315,
                limb1: 0xef2de43231e58b01acd3824,
                limb2: 0x107cf28702af87f5,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0x7b4b57fe556133371177fc2c,
                limb1: 0x43f75e7356a62bec95999d25,
                limb2: 0xecfb19e559a5f6d,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0x851a3e66bd6236050c1aa8dd,
                limb1: 0x85f87f5c71347c313cf2d95c,
                limb2: 0x12459f2b5192f8e,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0xf8f2412389f007fabbb1b775,
                limb1: 0xcc5d5cd8265244e8501de827,
                limb2: 0xf6c4758b720faba,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0x8a6993de7e10b8849271c546,
                limb1: 0x2e001a756efa9a187e6f8581,
                limb2: 0x10cc16a8725b40ca,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0xa05206d25774a8f0bc7300c9,
                limb1: 0x641cd0b73aa086f4462e8578,
                limb2: 0x3cbdae90166a72f,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0x5481b307993c47c3f953249a,
                limb1: 0x2a3ee0dd9054a516e5007181,
                limb2: 0x2a939c904f56749,
                limb3: 0x0
            }
        };

        let c_or_cinv_of_z: u384 = u384 {
            limb0: 0xef59b50288a6966ccb6053bd,
            limb1: 0x9450826ff23d934c29a20bc4,
            limb2: 0x506e9ec27a91779,
            limb3: 0x0
        };

        let z: u384 = u384 {
            limb0: 0x8c39ceab26adef3c23b982e5,
            limb1: 0x6391a567684e8ede2fca7a04,
            limb2: 0x17a1bdaa04cb5e62,
            limb3: 0x0
        };

        let ci: u384 = u384 {
            limb0: 0xc758ebde5822d64549c85564,
            limb1: 0x41760c1c3a577a29041f147,
            limb2: 0x25a4e6003cbc3241,
            limb3: 0x0
        };

        let (Q2_result, f_i_plus_one_of_z_result, lhs_i_plus_one_result, ci_plus_one_result) =
            run_BN254_GROTH16_BIT1_LOOP_circuit(
            yInv_0,
            xNegOverY_0,
            G2_line_0,
            Q_or_Q_neg_line0,
            yInv_1,
            xNegOverY_1,
            G2_line_1,
            Q_or_Q_neg_line1,
            yInv_2,
            xNegOverY_2,
            Q_2,
            Q_or_Q_neg_2,
            lhs_i,
            f_i_of_z,
            f_i_plus_one,
            c_or_cinv_of_z,
            z,
            ci
        );
        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 0x209fae9aacd90beba575aaf0,
                limb1: 0x6618b1f6db61a5bb3147a438,
                limb2: 0xbd1c12417bfa24e,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x4065fb4c0c88c4a97fd95693,
                limb1: 0x3f657faacb2047f724822591,
                limb2: 0x2257efc3bb4f2c1c,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x53f0dfa142aa6a700d77ac2e,
                limb1: 0x284c35548e9c53e0b1462a79,
                limb2: 0xa14a45fd29af480,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x6ba0bde69f3ec8e5b8e4e078,
                limb1: 0xd4f81f137607da6edfac1211,
                limb2: 0x10ac13fe0600c05b,
                limb3: 0x0
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0xb5b16ec0f854696904ae98fd,
            limb1: 0x21ec72c50bc60b2862ca359a,
            limb2: 0x276e4ec30cf15e2d,
            limb3: 0x0
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 0xe68aaf20da3fd43e78a78d1f,
            limb1: 0x14b48819569e65a22118b2af,
            limb2: 0x216080db8df047f6,
            limb3: 0x0
        };

        let ci_plus_one: u384 = u384 {
            limb0: 0xc100399206b2ae1d1d1b68d2,
            limb1: 0xde8eaec3a3a1fc1238ecdfb8,
            limb2: 0x7a58e735689aaae,
            limb3: 0x0
        };
        assert_eq!(Q2_result, Q2);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
        assert_eq!(lhs_i_plus_one_result, lhs_i_plus_one);
        assert_eq!(ci_plus_one_result, ci_plus_one);
    }


    #[test]
    fn test_run_BN254_GROTH16_FINALIZE_BN_circuit_BN254() {
        let yInv_0: u384 = u384 {
            limb0: 0xb1d48b0391f2ad426965ff94,
            limb1: 0x695d5d5a1da8f429a54b260f,
            limb2: 0x15a836a7350a2abc,
            limb3: 0x0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0xef1b1beb1a63ed52172c8302,
            limb1: 0xc892030ec1425631b9c115c3,
            limb2: 0x117e2e9c232e5fab,
            limb3: 0x0
        };

        let line_1_0: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0x6b2d3e7147d0964d85b535ed,
                limb1: 0x3716a073c98b16e9b6f891e7,
                limb2: 0x209d627af60ea033,
                limb3: 0x0
            },
            r0a1: u384 {
                limb0: 0xc0d46663cfe117131a0bcd0f,
                limb1: 0xd9ce72ab5ceacdc09db0a770,
                limb2: 0x289e1a1de1ae1007,
                limb3: 0x0
            },
            r1a0: u384 {
                limb0: 0xff555ae5553da58add28c2a1,
                limb1: 0x3bc4b9f88263da78405087bd,
                limb2: 0x251211bb7fb032ec,
                limb3: 0x0
            },
            r1a1: u384 {
                limb0: 0xd1886c290eee95136487b1e,
                limb1: 0xa9392defe7cc081690f089f3,
                limb2: 0x10fc9bb41bb19aa0,
                limb3: 0x0
            }
        };

        let line_2_0: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0x19f8b828a40aaab86ea4e398,
                limb1: 0x199459c40995e98cc82dd858,
                limb2: 0x15290a3053ec7d88,
                limb3: 0x0
            },
            r0a1: u384 {
                limb0: 0xc9f775c84d924c83c9b29ee7,
                limb1: 0x18c2a569109d5b97920fdf72,
                limb2: 0x1ebb4131643d87ba,
                limb3: 0x0
            },
            r1a0: u384 {
                limb0: 0x531d32b6e80c5c542630b965,
                limb1: 0x3cee7eb021653fa639989ec0,
                limb2: 0x288acb3234e85fe,
                limb3: 0x0
            },
            r1a1: u384 {
                limb0: 0xddf384691fdbb38b6e2d1e4,
                limb1: 0x8c0f53727a03ee5c77b9611e,
                limb2: 0xf0c58f88d40d542,
                limb3: 0x0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0x3f5c7c2dde74ae046c9ff1ec,
            limb1: 0xd0cf422e9f890d0937ac7d7d,
            limb2: 0x15469b2b18e8dd41,
            limb3: 0x0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0x430928ae79dac846a63a98d1,
            limb1: 0x30cc068d7a9f3f59c92c663c,
            limb2: 0x1cf918d4ce0db340,
            limb3: 0x0
        };

        let line_1_1: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0x9a4ac3d928e4f627ab48e297,
                limb1: 0x91ea90bdd513466536c83bb2,
                limb2: 0x1672f7e1676b9e5d,
                limb3: 0x0
            },
            r0a1: u384 {
                limb0: 0x63fdedb4431c327f6e15039a,
                limb1: 0xb999c75c21819e782aca8ff8,
                limb2: 0x22aabf2e98b83c2d,
                limb3: 0x0
            },
            r1a0: u384 {
                limb0: 0xcc49c10f1c23b2207d7cb4ba,
                limb1: 0xe76ba1659bcb160a3c0294d5,
                limb2: 0x2ba989b25863f76c,
                limb3: 0x0
            },
            r1a1: u384 {
                limb0: 0x3633cb67e33666a1fadc0b74,
                limb1: 0x4a12d0df3988ba0f653d8c90,
                limb2: 0x14276ff7944e13df,
                limb3: 0x0
            }
        };

        let line_2_1: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0xd0a776b05c3e5d9b0640151e,
                limb1: 0xed6d3a646d2b012308f2bc96,
                limb2: 0x301e36b0bb2b26f3,
                limb3: 0x0
            },
            r0a1: u384 {
                limb0: 0xcb691e67927b9b5a067988f6,
                limb1: 0xca7b0dc68c63ea50a00305a5,
                limb2: 0x2ff21b29059d3e99,
                limb3: 0x0
            },
            r1a0: u384 {
                limb0: 0x6831dac80daa03440c5a0777,
                limb1: 0x4cfec3f69f8ae5f5f4931c8c,
                limb2: 0x1539258373fa5ecd,
                limb3: 0x0
            },
            r1a1: u384 {
                limb0: 0xe6802d8506b91213a4cbda99,
                limb1: 0x1b2d8cd061c96b448e4924b8,
                limb2: 0x118026d46bb639cd,
                limb3: 0x0
            }
        };

        let original_Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 0xb2d67b2bc881f9fcb8e6793,
                limb1: 0xb6129ff56ca50c9ccd6126b,
                limb2: 0x1656bbc90ffefecd,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xac9c74e2cdeb0960a7548bad,
                limb1: 0x1e55f521a9fc795dc3d0db4b,
                limb2: 0x2c2825619ed8bfa8,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x390206adf116459befa60af,
                limb1: 0x86983739a1550300e07d5b15,
                limb2: 0x649b686a1619600,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xc11e95c392a55f24d592d2ca,
                limb1: 0x3656389d08cf9fa68a68c17b,
                limb2: 0x252e711097919d6b,
                limb3: 0x0
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 0x3a7fb889df29a50e133d9e6f,
            limb1: 0xb0ea0c7c64d13773214c4d29,
            limb2: 0x2a328250ef28c051,
            limb3: 0x0
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 0x3f0a22d210fcdf7c754efc5d,
            limb1: 0xc3e3187bdfaec0ab3a70f605,
            limb2: 0x7947c8aff893bcf,
            limb3: 0x0
        };

        let Q_2: G2Point = G2Point {
            x0: u384 {
                limb0: 0xdf539ccb6f1ad17127ca4492,
                limb1: 0x6b9cfa617da9c122ac2f5716,
                limb2: 0x26f2aa38419ed40a,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x8ca5773131243f80cfedf631,
                limb1: 0xfec264ee8d6ba9fc09748216,
                limb2: 0x2a81f1b8b284b450,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xb3565e5427b9528c63f72b5f,
                limb1: 0x92a7d8b4bdd8c3c37e43c0b7,
                limb2: 0x8e2c2bccf0d39bb,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x4e850e7ee077fb540c588f77,
                limb1: 0x7ad4f768953f2ad962e5d7a7,
                limb2: 0x1d31e2c5aa8c4f54,
                limb3: 0x0
            }
        };

        let R_n_minus_2 = E12D {
            w0: u384 {
                limb0: 0xd7a750e83b38d6d08870582a,
                limb1: 0xdc5a7bc04c831ff4106cb112,
                limb2: 0x2019e3b888e04d93,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0xecba187c570ad5333cc312ae,
                limb1: 0xb917a31ef683c8ecd34f0013,
                limb2: 0xf5b130c4dc0500f,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0x6f31140682e03b43dcd9c893,
                limb1: 0xc9bad80d4ac0555b45ba13ab,
                limb2: 0x14a0044c616ec8e5,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0xfbdd8d3351e95be3be46a5d2,
                limb1: 0x352abdc0d492a3f9d7413bcd,
                limb2: 0x61c18bed7d9cd2c,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0x31f1f4f44c9dc9a84da3ea8f,
                limb1: 0x689a0ced3e14a4b11a00cb00,
                limb2: 0x222bddf4f15fe2ff,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0x85d3b767464a9b5d3eaa2f0a,
                limb1: 0x647833785d531aa7f032172d,
                limb2: 0x43c32c1dcf86eb1,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0x79fb3bcdf382650595d570e1,
                limb1: 0x18c407a8adfd429f70a3eddd,
                limb2: 0xaaa2b11fc22453f,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0xcee2d6631ed90f61a38587a3,
                limb1: 0x44436c48cfbb5634862ac9bc,
                limb2: 0x8d4b3f43d3c1cd,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0x32e9933d649e0f3a63e766b7,
                limb1: 0x29af9e179a979f42065a13d4,
                limb2: 0x3de13acc966727b,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0x554829e56cf1c5266a7b1454,
                limb1: 0xcde7f7696d4d2b1ae524c559,
                limb2: 0x184eef8cb8b7da07,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0xeca9451844587bbe0a669218,
                limb1: 0xf3c09c1aa943ccd279347cd6,
                limb2: 0x25c9c84b92938a3f,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0x2a08214c3c9111d08f28b6f3,
                limb1: 0xb99cf8dadc016a1ee64c8980,
                limb2: 0x1b36d2b9550a89db,
                limb3: 0x0
            }
        };

        let R_n_minus_1 = E12D {
            w0: u384 {
                limb0: 0x4ab83e188171dbf223c61945,
                limb1: 0xec35be28c0383551ef064664,
                limb2: 0xfcb055a7c88ad60,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0x44f773bc131e1e35a34ac29a,
                limb1: 0x318f7ba99ec8c47825a65b8f,
                limb2: 0x89bb4a13f162267,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0xb79104d4e51e79030364180e,
                limb1: 0x46b004ae71197d0b0719a856,
                limb2: 0x2e9cbb224d34b9c9,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0x9d9bf3b2afebabba6f33d64,
                limb1: 0xdc3f0480a76293862ac98394,
                limb2: 0x216284ce025c922e,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0x6ed2a4ac0f21ab056084c9fc,
                limb1: 0xf57476f9734262c2dc13da67,
                limb2: 0xa9b02a87d085b15,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0xa180b1c237569b04d5bd5a0b,
                limb1: 0x8ad59b66dc3c6bbb1c28d995,
                limb2: 0x60fd2e984062771,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0x665c5421ec5f3b268f230a71,
                limb1: 0x3b1eadb046fbd74c525bf551,
                limb2: 0x263b00b8bccca57a,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0xf509203a5192bcb80f33131c,
                limb1: 0x476f43b1fd64bfa1ac98b681,
                limb2: 0x58b3ed7e592e880,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0x7582e3ae1b812e5f2f7bfb94,
                limb1: 0x7a60689a05dde624c6d8de01,
                limb2: 0x100281ba5ab8a31b,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0x32e01da3bb655d51dde97098,
                limb1: 0xf346832e9aeebe004cfbe8d1,
                limb2: 0x2509eb64882debde,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0x3ae1ab400dfe24b90d1b85c9,
                limb1: 0xc4cd61419283fc770615594c,
                limb2: 0x2aca9fb8dbdd3860,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0xcfeeb9b05e9bc37dc14826b8,
                limb1: 0xcfd2f1c1746e80c441fb9b2a,
                limb2: 0x2e64325df4235c2c,
                limb3: 0x0
            }
        };

        let c_n_minus_3: u384 = u384 {
            limb0: 0xa4a98afd111475f2217718ac,
            limb1: 0x1d176685896642b170e388bd,
            limb2: 0x2ee83685d2d56736,
            limb3: 0x0
        };

        let w_of_z: u384 = u384 {
            limb0: 0x274e7c9afcbbb96c18edf59e,
            limb1: 0x6a33596c5684797b2a1926e5,
            limb2: 0x227f7ee63787ba1c,
            limb3: 0x0
        };

        let z: u384 = u384 {
            limb0: 0x759e9cbe6ba735b1b5f1e073,
            limb1: 0xbf46ead512f7acd3ca4d7e3a,
            limb2: 0x2e3566e419849ba8,
            limb3: 0x0
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 0xa0a1fdd7d610f70074a4edef,
            limb1: 0xbc1e8fbb61c2dec4258878d3,
            limb2: 0x1a237e2b2f42cb58,
            limb3: 0x0
        };

        let c_frob_2_of_z: u384 = u384 {
            limb0: 0xf544412b8fb5f417de2c4c68,
            limb1: 0x6cfd088b581e00f808b2ace5,
            limb2: 0x1217948147468251,
            limb3: 0x0
        };

        let c_inv_frob_3_of_z: u384 = u384 {
            limb0: 0xef93a4f7a8beec6fab8802d4,
            limb1: 0x3852ff5bd555637d0b489eb1,
            limb2: 0x2f375b1371ca581e,
            limb3: 0x0
        };

        let previous_lhs: u384 = u384 {
            limb0: 0x81cd34bba115a910b92ff26b,
            limb1: 0x8dc78aa722ee475c688a1c81,
            limb2: 0x22e109e8a34d6d4,
            limb3: 0x0
        };

        let R_n_minus_3_of_z: u384 = u384 {
            limb0: 0xed6420ba3260141eb828ceb0,
            limb1: 0x34bdba0d8e4a580648a3920b,
            limb2: 0x387ba6043e3af49,
            limb3: 0x0
        };

        let Q: Array<u384> = array![
            u384 {
                limb0: 0xb1f2dfcc5dcfcf618371eb47,
                limb1: 0x625300a248d44211bb047d03,
                limb2: 0x25ac0f921a43722,
                limb3: 0x0
            },
            u384 {
                limb0: 0x4ceb46d39fe62e363162ef95,
                limb1: 0x72bbccfc34ff496ad52583c8,
                limb2: 0x34a1c24b5c31ed,
                limb3: 0x0
            },
            u384 {
                limb0: 0x6fb3dafa6d9ed7ae0acb56bb,
                limb1: 0xf25494deb0fca11e8cec313e,
                limb2: 0x2c56849c02a5887c,
                limb3: 0x0
            },
            u384 {
                limb0: 0x66cdd662c4e813db44cfc3ca,
                limb1: 0x90be68d55aa970d9801abff7,
                limb2: 0x2e53da1227ba334f,
                limb3: 0x0
            },
            u384 {
                limb0: 0x474957ad602d808cc27efe7e,
                limb1: 0x31fdcc43fd3b10215453ef5c,
                limb2: 0x2dc6d546810c715d,
                limb3: 0x0
            },
            u384 {
                limb0: 0x9168183d3c8a8eb9c1a1d053,
                limb1: 0x957f0c19157ccfe96042c21,
                limb2: 0x1f700520c8160df5,
                limb3: 0x0
            },
            u384 {
                limb0: 0x34910d033f377baac8d13ca0,
                limb1: 0xde699e1e2922bc1d47ede528,
                limb2: 0x1ce0149f2f25a8cd,
                limb3: 0x0
            },
            u384 {
                limb0: 0x1410d4830b2e3d1b3b4590c6,
                limb1: 0x6559f2d53b520373febd7555,
                limb2: 0x1b0e533965b8e1b0,
                limb3: 0x0
            },
            u384 {
                limb0: 0xa7e38bc54ef9e157e439d480,
                limb1: 0x343bcd00913edb040b652dbd,
                limb2: 0x1f1dc6334c4e1314,
                limb3: 0x0
            },
            u384 {
                limb0: 0x9cfc308b1ce4355961d944f6,
                limb1: 0xb07fa381cd849403ac791bae,
                limb2: 0x5b6bda95945e764,
                limb3: 0x0
            },
            u384 {
                limb0: 0xa8adc7e35bb0ecd619e3bfe6,
                limb1: 0x30dc2737db8076187608c47a,
                limb2: 0x12820b794f6d4f01,
                limb3: 0x0
            },
            u384 {
                limb0: 0xc5a428c6195f908dbd9695c9,
                limb1: 0xdb9098ea116cd88100c08143,
                limb2: 0x26930889abac92b4,
                limb3: 0x0
            },
            u384 {
                limb0: 0x335be677df1b925e6f66be87,
                limb1: 0x7d1d339e34536a9b7ecbcd45,
                limb2: 0x23b5ce75d24f6919,
                limb3: 0x0
            },
            u384 {
                limb0: 0x67c45071ba8a82eaad527daa,
                limb1: 0xf11ff82f7907f04684eb42d3,
                limb2: 0x9e088ea29377d76,
                limb3: 0x0
            },
            u384 {
                limb0: 0x865d2030011e33fefd3b748d,
                limb1: 0xdc0f71ff12ef4ae2746ddff4,
                limb2: 0x2810f16269ad4787,
                limb3: 0x0
            },
            u384 {
                limb0: 0x51f0536cb205b5f7e0c05353,
                limb1: 0x2ddf659fbb8e2e5cf4208999,
                limb2: 0x24403131148002cb,
                limb3: 0x0
            },
            u384 {
                limb0: 0x9cc29d6ff6e3a394c487af5d,
                limb1: 0x9e82aeb77493bdb157195343,
                limb2: 0x2da4c3b53160e9c6,
                limb3: 0x0
            },
            u384 {
                limb0: 0xa7f5794c007ea2cb970ea1aa,
                limb1: 0x119c21c47e39fd94f850cbec,
                limb2: 0x12a2f71778c65085,
                limb3: 0x0
            },
            u384 {
                limb0: 0xaf20faea77869d49b89b1625,
                limb1: 0xefac72285dde1a4b8de20f22,
                limb2: 0x27a2f8917ad60b01,
                limb3: 0x0
            },
            u384 {
                limb0: 0x4ee7f9b0a6e880af11e58c08,
                limb1: 0xebd1dbf8c0a562e835e70eef,
                limb2: 0x1ac88c94fb2d35f7,
                limb3: 0x0
            },
            u384 {
                limb0: 0x7145c4675a0b37e8769f513a,
                limb1: 0xc73cab38250d0c9ca556df18,
                limb2: 0x1ed430d5b081690a,
                limb3: 0x0
            },
            u384 {
                limb0: 0x107a34af5c724d49e375d8af,
                limb1: 0x90bfbabda5d649dc41d1c954,
                limb2: 0x25906bd5358db639,
                limb3: 0x0
            },
            u384 {
                limb0: 0xaa4b938efb6f6d2322ac9ff1,
                limb1: 0xa7e5963c493b1112868a9123,
                limb2: 0xb577c1214c226f3,
                limb3: 0x0
            },
            u384 {
                limb0: 0xdf66946a01163168bac8a760,
                limb1: 0xbad81464959b0d078f022246,
                limb2: 0x2b18d15ec47090c6,
                limb3: 0x0
            },
            u384 {
                limb0: 0x89b2f14ce5694274b0e0cfc9,
                limb1: 0xce753f5774b183dcf3430638,
                limb2: 0x1ee6e8d78e296c03,
                limb3: 0x0
            },
            u384 {
                limb0: 0x15404b72e6984c647200545,
                limb1: 0xe46cf2ada450d1d0d35e1fbb,
                limb2: 0x1bd3c792e68f7b05,
                limb3: 0x0
            },
            u384 {
                limb0: 0x6fed86014d41c1455a1a0983,
                limb1: 0xe960a9f6b395bc690c377a52,
                limb2: 0x2f7b48508633195,
                limb3: 0x0
            },
            u384 {
                limb0: 0x98d0cbb77844e648601b7208,
                limb1: 0x44744ac61df7327635ba9da1,
                limb2: 0x12b978ff0c53802,
                limb3: 0x0
            },
            u384 {
                limb0: 0xa4031a4c3d384383378ff0c0,
                limb1: 0x8a1f9e07e8510977380a4a2c,
                limb2: 0x12570d2a87cbe70,
                limb3: 0x0
            },
            u384 {
                limb0: 0x72f5eeeecd36c0c30fbc4897,
                limb1: 0x26ce196954f78e897d1271b7,
                limb2: 0x49996f7a55fa546,
                limb3: 0x0
            },
            u384 {
                limb0: 0xa8b43255dff2b98a0fccb52e,
                limb1: 0xe5a61f880c461b549897d88f,
                limb2: 0x28c59e4a0e618684,
                limb3: 0x0
            },
            u384 {
                limb0: 0x42e14ce97e8efd0d0279648d,
                limb1: 0x19b5024ceee2a362cccbcb6e,
                limb2: 0x9972b568e3f4eae,
                limb3: 0x0
            },
            u384 {
                limb0: 0xb99e1a815eca6f11147cef15,
                limb1: 0x85bdca63a100ba8f51827e3f,
                limb2: 0x29ff445bd8f5817f,
                limb3: 0x0
            },
            u384 {
                limb0: 0x361e75fac8dbee0e9ee73bcd,
                limb1: 0xf5cf489783c8e3748fa6b8f1,
                limb2: 0x218348f54c85e837,
                limb3: 0x0
            },
            u384 {
                limb0: 0x2f70b365286c6c4a3f796219,
                limb1: 0x19e8065b113ed69c5a8ce27b,
                limb2: 0x1a86246949075479,
                limb3: 0x0
            },
            u384 {
                limb0: 0x822fcf7a6c63086ae06ecd8a,
                limb1: 0x272c763d87a60c7c41175ae3,
                limb2: 0x17cc900f1c6258f0,
                limb3: 0x0
            },
            u384 {
                limb0: 0x929c8ac4bf28b0fba8cb2f6e,
                limb1: 0xf01cccc7bb87c961fa17e092,
                limb2: 0xf19a6a950bbd1c7,
                limb3: 0x0
            },
            u384 {
                limb0: 0x1cafe03453d9ba8ed3cbdcdc,
                limb1: 0xd0bd0edabc2d8aa6a15e67ce,
                limb2: 0x299bbd8bf1474a9a,
                limb3: 0x0
            },
            u384 {
                limb0: 0x1e33ae648b5ff9ef228f3e0c,
                limb1: 0xebb9aa725c9fb4405ecc2838,
                limb2: 0x111b0624c9d3cdb9,
                limb3: 0x0
            },
            u384 {
                limb0: 0x47a1d7c75cc05de0cc946b3e,
                limb1: 0x1d04d0fe5bc560fde22aff6,
                limb2: 0x1f5242b7234877e3,
                limb3: 0x0
            },
            u384 {
                limb0: 0x3458596e3872e12155e0637c,
                limb1: 0x58e3d2826c968ec313626040,
                limb2: 0x2a5002f688ae0b76,
                limb3: 0x0
            },
            u384 {
                limb0: 0x2d0c90762969633b12ad7191,
                limb1: 0x3bbd199b9e54afa6a328652a,
                limb2: 0x2368a2c2d71080d9,
                limb3: 0x0
            },
            u384 {
                limb0: 0xf4dc5b1949523e7016bb04c1,
                limb1: 0xc2f99bf18034f222b4a465c3,
                limb2: 0x184054efc65937de,
                limb3: 0x0
            },
            u384 {
                limb0: 0x5b786208a04777d10efa49d4,
                limb1: 0x97ad1730763cd2743719509c,
                limb2: 0xcea1e7f90916a5f,
                limb3: 0x0
            },
            u384 {
                limb0: 0x59fcd9c03257a80ae4e59c4f,
                limb1: 0x9b99a16ade2523c0f987dcbc,
                limb2: 0x15d9ae405028fbe2,
                limb3: 0x0
            },
            u384 {
                limb0: 0xd03f7108064cef9acb6729d4,
                limb1: 0xc08e3f276c8c4247e594cc32,
                limb2: 0x296a5ff4e2c71ba1,
                limb3: 0x0
            },
            u384 {
                limb0: 0x50cb78ae1b53d85fbaaa418b,
                limb1: 0x5fbb63036c10e43363985173,
                limb2: 0x87e8f523d302185,
                limb3: 0x0
            },
            u384 {
                limb0: 0x5f93f6e9e36b26fad9d2a060,
                limb1: 0xf4207dd9600beed3ef6c5999,
                limb2: 0x2d42b5b5634743ee,
                limb3: 0x0
            },
            u384 {
                limb0: 0x483b7b7fe2b1c6c98f2fbda2,
                limb1: 0xb1be25a8d1d1f58fb5e3cfbd,
                limb2: 0xc1ef956ab5fc283,
                limb3: 0x0
            },
            u384 {
                limb0: 0x118060223523e12dcac2868d,
                limb1: 0xd6ab5c68606db8e5ccc8a46c,
                limb2: 0xbb9b05b351e7fc8,
                limb3: 0x0
            },
            u384 {
                limb0: 0x56481f4b0c747a90317f1e9b,
                limb1: 0xf4c1c23bda47b8f9cee41404,
                limb2: 0x29a309f160b1c120,
                limb3: 0x0
            },
            u384 {
                limb0: 0xd9057a48e7f0398110237a0f,
                limb1: 0x9ae6fd92c9516e1f1a8e75a0,
                limb2: 0x279197628c6f140e,
                limb3: 0x0
            },
            u384 {
                limb0: 0x271fb4e55d67ed180be3fdd4,
                limb1: 0x762d4c365b902e062a05004a,
                limb2: 0x15bc26686a4d8542,
                limb3: 0x0
            },
            u384 {
                limb0: 0xc4791523ef31b7de4cd003c5,
                limb1: 0x527f3113f7a8992f4a058311,
                limb2: 0x2f491eca6d75472e,
                limb3: 0x0
            },
            u384 {
                limb0: 0x739c3ae2fda93f182bc246f3,
                limb1: 0xa9b932bc23500fcaad785312,
                limb2: 0x8eeba6a76c6bf55,
                limb3: 0x0
            },
            u384 {
                limb0: 0xfb73ca968a5dd63668c316e6,
                limb1: 0x5132a7635a344fd7a13429ce,
                limb2: 0x1ebf8711f3750f4,
                limb3: 0x0
            },
            u384 {
                limb0: 0xb41fdcade36a7265ee516865,
                limb1: 0x5b7cb8edb2396f882516de06,
                limb2: 0x2a8f81be5351c342,
                limb3: 0x0
            },
            u384 {
                limb0: 0xb6600ef91f4e7e4c3417ccdf,
                limb1: 0x5ce32ac34a1e1ea7ead6b26a,
                limb2: 0x31851659d7c5882,
                limb3: 0x0
            },
            u384 {
                limb0: 0x3affeda39c91536ba383dfb5,
                limb1: 0x79da713d74784fcf04397e4a,
                limb2: 0xf30083610ca65f4,
                limb3: 0x0
            },
            u384 {
                limb0: 0x5b289a8432a88b74992c6631,
                limb1: 0x4c09baf401df38055f188cea,
                limb2: 0x11e80428b1ddd811,
                limb3: 0x0
            },
            u384 {
                limb0: 0x277f78fada5a08ad9ab1f22,
                limb1: 0xf332bab9e051c9456cc652e,
                limb2: 0xa8b83a95834aeaf,
                limb3: 0x0
            },
            u384 {
                limb0: 0xa8f7ce912532687eb173a40a,
                limb1: 0xff020a5079cc9a8b74a70ca2,
                limb2: 0x2aed051f89684093,
                limb3: 0x0
            },
            u384 {
                limb0: 0x3714752506ce943a51550ef,
                limb1: 0x1514a09205ee97e15fedb375,
                limb2: 0x1f1d01df772b2984,
                limb3: 0x0
            },
            u384 {
                limb0: 0xf37412b001c603dab5153684,
                limb1: 0xeebc74086c2ae063f5bc2f1,
                limb2: 0x6f72b24ac8d4df5,
                limb3: 0x0
            },
            u384 {
                limb0: 0x1978be2860f71863ebc295a2,
                limb1: 0xd997e4bf209fd44768e72010,
                limb2: 0x24cce4a47a04a0d5,
                limb3: 0x0
            },
            u384 {
                limb0: 0x92b8a1e10815f8138802bd32,
                limb1: 0x2a865fb4eda3852f378f48ec,
                limb2: 0xb5b67ea9859792c,
                limb3: 0x0
            },
            u384 {
                limb0: 0x82519225ee220a400b99a9aa,
                limb1: 0x7c16b60ae17c280b787d13e2,
                limb2: 0x11271a5a636f8273,
                limb3: 0x0
            },
            u384 {
                limb0: 0xc0648c3ca77440d1d6a816f2,
                limb1: 0x743ad97ed04227b3e98498cd,
                limb2: 0x275d315456883b7b,
                limb3: 0x0
            },
            u384 {
                limb0: 0xa7211de88b42dbe49c1920ef,
                limb1: 0xc29e1c4f19706b9ba208bc2b,
                limb2: 0x24d36bf42b8fd0ee,
                limb3: 0x0
            },
            u384 {
                limb0: 0x6ca812e0446fae5b7acbf932,
                limb1: 0xcb53d1cdc35cd4c339b24ebb,
                limb2: 0x2fcf511f87f79b8,
                limb3: 0x0
            },
            u384 {
                limb0: 0xedfaed17bb9f69820803174d,
                limb1: 0x53ceaa74bc849a73f149e41e,
                limb2: 0x1f1911b661dbbd36,
                limb3: 0x0
            },
            u384 {
                limb0: 0x966f92d49b2c7c5e3c4442a4,
                limb1: 0xa0a8175d88f1946405e8b8d8,
                limb2: 0xcc7aad3f2d62fe0,
                limb3: 0x0
            },
            u384 {
                limb0: 0xc75b5900911feb6ef979918a,
                limb1: 0x31bd11f9e0c260f655b3d2a2,
                limb2: 0x9fed832b121c64d,
                limb3: 0x0
            },
            u384 {
                limb0: 0xea62dd1c9f4fdb4cebf1aa33,
                limb1: 0xb3583058ff222a681b1ab9d8,
                limb2: 0x188c23d4419a661e,
                limb3: 0x0
            },
            u384 {
                limb0: 0x9dd4ad961014ea85378f3834,
                limb1: 0xd22acfa45e9fc1a4eeb8ded2,
                limb2: 0x98dc462658f520c,
                limb3: 0x0
            },
            u384 {
                limb0: 0xad137d8bce954fc7c5b3a9fd,
                limb1: 0x69425b8fda9297bef2aa3b37,
                limb2: 0x2240c21bceecf0c4,
                limb3: 0x0
            },
            u384 {
                limb0: 0xabeca21d69570c92c2555384,
                limb1: 0x3557725001cf922542db3c31,
                limb2: 0x1d490391ecfd67c2,
                limb3: 0x0
            },
            u384 {
                limb0: 0x9623a24c34111f6b6b22b9b4,
                limb1: 0x3f93c895fc14b7ea6cd44010,
                limb2: 0x29a0e0e0ef5d1e2b,
                limb3: 0x0
            },
            u384 {
                limb0: 0xbb447105e4ab797ca13db313,
                limb1: 0xaab8ef95a4b49941b231466c,
                limb2: 0x145dfef36b5866de,
                limb3: 0x0
            },
            u384 {
                limb0: 0x3500c00f04502efc1db1d12e,
                limb1: 0x1319d5124c4649dda290f0f5,
                limb2: 0x1350517836cc85db,
                limb3: 0x0
            },
            u384 {
                limb0: 0xa626ac793d8abfe328059a51,
                limb1: 0x1c94a077e7e078085505347,
                limb2: 0x868b668c07f6b5e,
                limb3: 0x0
            },
            u384 {
                limb0: 0x9f0ff7a7a42424067c637708,
                limb1: 0x4ec1a13d00c7f6d410fe6843,
                limb2: 0x1c5eb2b6d7f4925a,
                limb3: 0x0
            },
            u384 {
                limb0: 0x3290b8534486e415b982a191,
                limb1: 0x8b0cb13ff242d8f983ce02ef,
                limb2: 0x8fbc447fd608ed9,
                limb3: 0x0
            },
            u384 {
                limb0: 0xd600b473d90d9833a0db0ea3,
                limb1: 0x573fde4efd62c146afba65cd,
                limb2: 0x8b21e094e132492,
                limb3: 0x0
            },
            u384 {
                limb0: 0x52db5c19c61a423b2f5a1402,
                limb1: 0xb54cf8e1f78441186747424e,
                limb2: 0x1667ee954bbca2b4,
                limb3: 0x0
            },
            u384 {
                limb0: 0xd9e2a4c57b57619f73705a40,
                limb1: 0x983af1862d6efa7d6a256d90,
                limb2: 0xd6546eb7432dcbc,
                limb3: 0x0
            },
            u384 {
                limb0: 0x6b63619ec3bde688439983f1,
                limb1: 0xd00b4607f5feaca1a6fee832,
                limb2: 0x1f64a4a46ff41d25,
                limb3: 0x0
            },
            u384 {
                limb0: 0xe48a38f057bdf4e30fca4c0c,
                limb1: 0x7dcc7312db7f780ecaa93442,
                limb2: 0x280e137757cd8e61,
                limb3: 0x0
            },
            u384 {
                limb0: 0x17ef7a78ff837007113e7a58,
                limb1: 0xdbebd3a4bf99cc5ed4e1efa1,
                limb2: 0x12213b3788e985bd,
                limb3: 0x0
            },
            u384 {
                limb0: 0x74816fcda58fa55ba7ab5912,
                limb1: 0x58b7b0fb1c8b9032fd88a54b,
                limb2: 0x1c9a04d3adc446f7,
                limb3: 0x0
            },
            u384 {
                limb0: 0x6993400ea569100cf939dd27,
                limb1: 0x65f64da9086e07058be0b176,
                limb2: 0x167dae028aab78d6,
                limb3: 0x0
            },
            u384 {
                limb0: 0x5ab5d4c101a95f82a3399317,
                limb1: 0x5e1da9ae6437b65c63c3d08,
                limb2: 0x25e15392f35fd4a8,
                limb3: 0x0
            },
            u384 {
                limb0: 0x81000edef1e5d067786873ff,
                limb1: 0x386f591a6cf81cbf9cd92293,
                limb2: 0x2def5df3af3aff3c,
                limb3: 0x0
            },
            u384 {
                limb0: 0x4e1fb078f81dbbf30f173d8b,
                limb1: 0x8953ac2accc5c21e83ce4772,
                limb2: 0x26b9575631d8a17a,
                limb3: 0x0
            },
            u384 {
                limb0: 0x37ab26b4e02204a089ccc096,
                limb1: 0x816702841d62367eaf647046,
                limb2: 0x78d3bee67a73ff9,
                limb3: 0x0
            },
            u384 {
                limb0: 0x4329e4990dbf36118c9af494,
                limb1: 0xd10f74b56faae4d5198ba27,
                limb2: 0x2bde50dc73972e0a,
                limb3: 0x0
            },
            u384 {
                limb0: 0x263d70cec5d18ed5bab2331e,
                limb1: 0x4a5832c969e30058225d841,
                limb2: 0x29b1d52c99092b7c,
                limb3: 0x0
            },
            u384 {
                limb0: 0x9b00f4f3ccd6b053f952eb70,
                limb1: 0x40136ca46810ae359c195380,
                limb2: 0x116eba077b6fbe55,
                limb3: 0x0
            },
            u384 {
                limb0: 0x884871bcbc09e7529d0c7363,
                limb1: 0x391b0ae0ac8fdf70ea6bed22,
                limb2: 0xa6095ee4b31c7de,
                limb3: 0x0
            },
            u384 {
                limb0: 0xfa6c1b68ece89b853f1eb5e4,
                limb1: 0x7d9e3927f1091282337c12f4,
                limb2: 0xf88f29abd48b258,
                limb3: 0x0
            },
            u384 {
                limb0: 0xfe4dc5c43e6afae8fb47c30a,
                limb1: 0xd15455a94550555dc43e038a,
                limb2: 0xc0ed69458721ad4,
                limb3: 0x0
            },
            u384 {
                limb0: 0xb77fd039924ab4e2ebdc732a,
                limb1: 0x10160550262894d153710d59,
                limb2: 0x189a9fcfc9ce7799,
                limb3: 0x0
            },
            u384 {
                limb0: 0x29c9bb10dde16baa6199c4e4,
                limb1: 0x4d2a3482b083d5727c7274ce,
                limb2: 0x5175cf99d7c6677,
                limb3: 0x0
            },
            u384 {
                limb0: 0x18714c59be6c482de83bf4c8,
                limb1: 0xb6cfa3f8fc72dd60c468c138,
                limb2: 0xdfae6fe4ec72b01,
                limb3: 0x0
            },
            u384 {
                limb0: 0x596888410df5d972076ef1af,
                limb1: 0x733e6301f28faeb01654012d,
                limb2: 0x13f49f704a4d2091,
                limb3: 0x0
            },
            u384 {
                limb0: 0x46801561607211ba7e0c3415,
                limb1: 0x8f356b90ad386c4b38f71af9,
                limb2: 0x21fd98e45f230e6d,
                limb3: 0x0
            },
            u384 {
                limb0: 0x1bf4331b9bd657abecb8739d,
                limb1: 0x5311cb54a0665299e7f63ec0,
                limb2: 0x19228792fccb1162,
                limb3: 0x0
            },
            u384 {
                limb0: 0x88fb786c1e46c5955e817bb5,
                limb1: 0xe4fce1fdc600b9b6fab8ee73,
                limb2: 0x27bf7e9625469b21,
                limb3: 0x0
            },
            u384 {
                limb0: 0xdad7f5709c218083799f0f96,
                limb1: 0x627899ace15605ee9619a3e8,
                limb2: 0x166d6de886dd3d81,
                limb3: 0x0
            },
            u384 {
                limb0: 0x17ee5d222743fd04137b567c,
                limb1: 0xb111abef0b7349be41e9b9ce,
                limb2: 0x2952cbc0e5e8a321,
                limb3: 0x0
            },
            u384 {
                limb0: 0x816a03fba7a120a038411fea,
                limb1: 0xba7bb4f25b1e40caecbac14d,
                limb2: 0x23c8b15263bf8948,
                limb3: 0x0
            },
            u384 {
                limb0: 0x95f0cb7ab4cfa78d80cd31d4,
                limb1: 0x66601f67853380aba006c2a,
                limb2: 0xcf726bdc6347400,
                limb3: 0x0
            },
            u384 {
                limb0: 0x69223a46cdd48f958b04fdf2,
                limb1: 0xaa45abd86985859a054b34e9,
                limb2: 0x25b4dc266cdb0daa,
                limb3: 0x0
            },
            u384 {
                limb0: 0x882a35466a408c8256451859,
                limb1: 0x36e238e5a609567c4e762047,
                limb2: 0x1d8fd6457e4ab70a,
                limb3: 0x0
            }
        ];

        let (final_check_result) = run_BN254_GROTH16_FINALIZE_BN_circuit(
            yInv_0,
            xNegOverY_0,
            line_1_0,
            line_2_0,
            yInv_1,
            xNegOverY_1,
            line_1_1,
            line_2_1,
            original_Q2,
            yInv_2,
            xNegOverY_2,
            Q_2,
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
            limb0: 0x59c0519aad60b415ba786f8a,
            limb1: 0xd9ef08d623afdc40a1779666,
            limb2: 0x1790234d7c8f9bcf,
            limb3: 0x0
        };
        assert_eq!(final_check_result, final_check);
    }


    #[test]
    fn test_run_BN254_GROTH16_INIT_BIT_circuit_BN254() {
        let yInv_0: u384 = u384 {
            limb0: 0x5e19d2bd028f1175eb59d49f,
            limb1: 0x5e0a3abdc50613abc67518c9,
            limb2: 0x5859e8b57a47b99,
            limb3: 0x0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0xad1c4859931e0d80fc7eaebb,
            limb1: 0x5d81778a5ef70581af71f4ae,
            limb2: 0x1a342def10912208,
            limb3: 0x0
        };

        let G2_line_0: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0xf277b8b75c63aa0f300ea022,
                limb1: 0x4097c094933d7d62f4b119a0,
                limb2: 0x99ebab8ccc0ae2d,
                limb3: 0x0
            },
            r0a1: u384 {
                limb0: 0xec85a655c8a8135a816db439,
                limb1: 0x94f6ca78519662cc1c8e8f7f,
                limb2: 0x23d03e48952dea73,
                limb3: 0x0
            },
            r1a0: u384 {
                limb0: 0x189798129ee3efdba012368c,
                limb1: 0x5b90c27f2a5debfa9dd0630e,
                limb2: 0x1df31e9e4162ca27,
                limb3: 0x0
            },
            r1a1: u384 {
                limb0: 0x2f571c547257d90043240b2d,
                limb1: 0x5c4250886b28d7d6651bf718,
                limb2: 0x144d49e818ef618f,
                limb3: 0x0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0xcbee3f1d5fc9707214b64d4f,
            limb1: 0xde8d4a6944a07ecb5fb2e686,
            limb2: 0x16844247a997c463,
            limb3: 0x0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0x69fd6b99260098e5d1bfe226,
            limb1: 0x33213ea434f956f1f780e7d0,
            limb2: 0x25426734285f9f8a,
            limb3: 0x0
        };

        let G2_line_1: G2Line = G2Line {
            r0a0: u384 {
                limb0: 0x9837e3c9fe1c054a75b10f2f,
                limb1: 0xcbbce468a8acc1eb6d49fc3c,
                limb2: 0x2d0256a6962cd344,
                limb3: 0x0
            },
            r0a1: u384 {
                limb0: 0x6720b2c3ee79d13e85bc2a,
                limb1: 0x7e53dfc22f062975d96425e,
                limb2: 0x1a2fc36870eb1aee,
                limb3: 0x0
            },
            r1a0: u384 {
                limb0: 0x914ef592eb0e9678f80a887d,
                limb1: 0x183fc86afad2873acf05359c,
                limb2: 0x3578225d7511fe6,
                limb3: 0x0
            },
            r1a1: u384 {
                limb0: 0x4a15d9416369bae7fef89ac9,
                limb1: 0x3306f416b09b81639ff67b31,
                limb2: 0x3267c96e4dd42f,
                limb3: 0x0
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 0x9d02e44cb5e5f25ddefa3514,
            limb1: 0x9d4fbe486769d8773ab2107c,
            limb2: 0x1f0a546df1772181,
            limb3: 0x0
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 0x4f5a41c70fa0ab3567b113de,
            limb1: 0xdcd3c1302ad735da2d11b499,
            limb2: 0x1481a3e6d493227e,
            limb3: 0x0
        };

        let Q_2: G2Point = G2Point {
            x0: u384 {
                limb0: 0x9f7642908104908f1f32140f,
                limb1: 0x9342365328beae8e7303ca03,
                limb2: 0x18f516a8de2b5082,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x20309b59b7d3589c3a51b13b,
                limb1: 0xf42fc92c048d1c2b4167fa2f,
                limb2: 0x1d49cfbde79c72f8,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x5048b85ac544b042c9e63583,
                limb1: 0x591eb142dd4f1ac37ad8ae0b,
                limb2: 0x305ff889820df53f,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x914d277e4ff0f84c38137f83,
                limb1: 0x7dbdd047075029fbd561d047,
                limb2: 0x8cb5fb6b2192894,
                limb3: 0x0
            }
        };

        let R_i = E12D {
            w0: u384 {
                limb0: 0x5fb1a0dd34fef75045709961,
                limb1: 0x4972e2d0dcdef04303f9c3a3,
                limb2: 0x1b9fc9d89f95ecca,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0x2210f28b630f00b19bef38fa,
                limb1: 0xb8f690fa40e54cdbdc371dfb,
                limb2: 0x28ac93f6f275212c,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0xd312585790894dfc63e39d59,
                limb1: 0xf3e03ccade7c2fb0a96e0d2f,
                limb2: 0x2f454e9ff47f8512,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0xe483d3945c7643497afbb7c0,
                limb1: 0xac709e3dd2c49b21dfc8ed58,
                limb2: 0x27374faa7838fd16,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0x229204c0ccbcb225b7c8dc61,
                limb1: 0x99691df6be96183407e124e3,
                limb2: 0x2a133652656f075e,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0xced15cd37641cd98d78f94a7,
                limb1: 0x33b9426df25dcd20ee526cf5,
                limb2: 0xbb32e63b157fce1,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0x33d69c6168f8a67abdf76a13,
                limb1: 0xb0b033504adf1f8686d26605,
                limb2: 0x1b38bb3edd295d4d,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0x4531ff004f219ce31a8f1af0,
                limb1: 0xc10b89c02692a85929bfce74,
                limb2: 0x13ab450a35959257,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0x1ad0cfee0f5b7dd928c04ddb,
                limb1: 0xef427576ff7be2552061f228,
                limb2: 0x24c91eb3409c3af1,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0x69e5ab7b1b9c26485f000fa2,
                limb1: 0xb6a49911559708f542b42bf8,
                limb2: 0x23e8dc3698849640,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0xe7bdcaccf1d04cc8eb0f052,
                limb1: 0xba85eeec576b323007991818,
                limb2: 0x26dfcf866c953ddd,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0x514f652fcb719e2f7be14cbd,
                limb1: 0x965d6317ab5e68c2e3d86d14,
                limb2: 0xea63ac5cd1fe22d,
                limb3: 0x0
            }
        };

        let c0: u384 = u384 {
            limb0: 0xded78da440065fd2df56a02c,
            limb1: 0x5805ab338ba5971dc4b02563,
            limb2: 0x2e5cf5e5e34d17ba,
            limb3: 0x0
        };

        let z: u384 = u384 {
            limb0: 0x7370a76cf8af92d5d73b293,
            limb1: 0x55bb62a1cf77fa975f612d94,
            limb2: 0x25eb1d8b842f9dad,
            limb3: 0x0
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 0xd55fc34ceb5ea9c3f9d9c6eb,
            limb1: 0x97a6f416cecdd0cfd7fa528c,
            limb2: 0x228029a4662606ae,
            limb3: 0x0
        };

        let previous_lhs: u384 = u384 {
            limb0: 0xb6997df2e9b4cbf6f1843d7e,
            limb1: 0x9e293bd91ae3b6381c723c20,
            limb2: 0xc5afbc08dc73e48,
            limb3: 0x0
        };

        let (Q2_result, new_lhs_result, c_i_result, f_i_plus_one_of_z_result) =
            run_BN254_GROTH16_INIT_BIT_circuit(
            yInv_0,
            xNegOverY_0,
            G2_line_0,
            yInv_1,
            xNegOverY_1,
            G2_line_1,
            yInv_2,
            xNegOverY_2,
            Q_2,
            R_i,
            c0,
            z,
            c_inv_of_z,
            previous_lhs
        );
        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 0x2eab7200793afd4cb99dde5e,
                limb1: 0x51d130f2bed1228824826a2b,
                limb2: 0x17de6c88501f94ab,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x70fe9bb612853a638e44901c,
                limb1: 0x672c92316e67332474b889aa,
                limb2: 0x2c7e139b7432052a,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x335355b0c3a2b052b9bb7e19,
                limb1: 0xfa1ad3691d262f12bc9f20d4,
                limb2: 0x2888e7e4e6510628,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x1e223c590199f7ae6195c58b,
                limb1: 0x81b64841d3106c9a3ec116cb,
                limb2: 0x2d7600a64492235d,
                limb3: 0x0
            }
        };

        let new_lhs: u384 = u384 {
            limb0: 0xda83f1c8dd33904ec6634b48,
            limb1: 0x57c0d18118d062e05a72ebd7,
            limb2: 0x4187b175fc555c,
            limb3: 0x0
        };

        let c_i: u384 = u384 {
            limb0: 0x7fd0ceb65b5846fc62096a76,
            limb1: 0xc002ce83fca219f3fbf4378b,
            limb2: 0x1356138a87f50fa3,
            limb3: 0x0
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0xca804933be3798d5e4806d69,
            limb1: 0x55a957c7d922229969f12c43,
            limb2: 0xbcd9d7377c4db1,
            limb3: 0x0
        };
        assert_eq!(Q2_result, Q2);
        assert_eq!(new_lhs_result, new_lhs);
        assert_eq!(c_i_result, c_i);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
    }
}
