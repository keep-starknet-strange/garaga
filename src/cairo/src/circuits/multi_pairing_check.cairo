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


fn run_BLS12_381_MP_CHECK_BIT00_LOOP_2_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    Q_0: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q_1: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one: E12D,
    z: u384,
    ci: u384
) -> (G2Point, G2Point, u384, u384, u384) {
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
    let t0 = circuit_mul(in29, in29); // Compute z^2
    let t1 = circuit_mul(t0, in29); // Compute z^3
    let t2 = circuit_mul(t1, in29); // Compute z^4
    let t3 = circuit_mul(t2, in29); // Compute z^5
    let t4 = circuit_mul(t3, in29); // Compute z^6
    let t5 = circuit_mul(t4, in29); // Compute z^7
    let t6 = circuit_mul(t5, in29); // Compute z^8
    let t7 = circuit_mul(t6, in29); // Compute z^9
    let t8 = circuit_mul(t7, in29); // Compute z^10
    let t9 = circuit_mul(t8, in29); // Compute z^11
    let t10 = circuit_mul(in30, in30); // Compute c_i = (c_(i-1))^2
    let t11 = circuit_mul(in16, in16); // Square f evaluation in Z, the result of previous bit.
    let t12 = circuit_add(in5, in6); // Doubling slope numerator start
    let t13 = circuit_sub(in5, in6);
    let t14 = circuit_mul(t12, t13);
    let t15 = circuit_mul(in5, in6);
    let t16 = circuit_mul(t14, in0);
    let t17 = circuit_mul(t15, in1); // Doubling slope numerator end
    let t18 = circuit_add(in7, in7); // Fp2 add coeff 0/1
    let t19 = circuit_add(in8, in8); // Fp2 add coeff 1/1
    let t20 = circuit_mul(t18, t18); // Fp2 Div x/y start : Fp2 Inv y start
    let t21 = circuit_mul(t19, t19);
    let t22 = circuit_add(t20, t21);
    let t23 = circuit_inverse(t22);
    let t24 = circuit_mul(t18, t23); // Fp2 Inv y real part end
    let t25 = circuit_mul(t19, t23);
    let t26 = circuit_sub(in2, t25); // Fp2 Inv y imag part end
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
    let t66 = circuit_mul(t63, t0); // Eval sparse poly line_0p_1 step coeff_2 * z^2
    let t67 = circuit_add(t61, t66); // Eval sparse poly line_0p_1 step + coeff_2 * z^2
    let t68 = circuit_add(t67, t1); // Eval sparse poly line_0p_1 step + 1*z^3
    let t69 = circuit_mul(t64, t4); // Eval sparse poly line_0p_1 step coeff_6 * z^6
    let t70 = circuit_add(t68, t69); // Eval sparse poly line_0p_1 step + coeff_6 * z^6
    let t71 = circuit_mul(t65, t6); // Eval sparse poly line_0p_1 step coeff_8 * z^8
    let t72 = circuit_add(t70, t71); // Eval sparse poly line_0p_1 step + coeff_8 * z^8
    let t73 = circuit_mul(t11, t72); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t74 = circuit_add(in11, in12); // Doubling slope numerator start
    let t75 = circuit_sub(in11, in12);
    let t76 = circuit_mul(t74, t75);
    let t77 = circuit_mul(in11, in12);
    let t78 = circuit_mul(t76, in0);
    let t79 = circuit_mul(t77, in1); // Doubling slope numerator end
    let t80 = circuit_add(in13, in13); // Fp2 add coeff 0/1
    let t81 = circuit_add(in14, in14); // Fp2 add coeff 1/1
    let t82 = circuit_mul(t80, t80); // Fp2 Div x/y start : Fp2 Inv y start
    let t83 = circuit_mul(t81, t81);
    let t84 = circuit_add(t82, t83);
    let t85 = circuit_inverse(t84);
    let t86 = circuit_mul(t80, t85); // Fp2 Inv y real part end
    let t87 = circuit_mul(t81, t85);
    let t88 = circuit_sub(in2, t87); // Fp2 Inv y imag part end
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
    let t128 = circuit_mul(t125, t0); // Eval sparse poly line_1p_1 step coeff_2 * z^2
    let t129 = circuit_add(t123, t128); // Eval sparse poly line_1p_1 step + coeff_2 * z^2
    let t130 = circuit_add(t129, t1); // Eval sparse poly line_1p_1 step + 1*z^3
    let t131 = circuit_mul(t126, t4); // Eval sparse poly line_1p_1 step coeff_6 * z^6
    let t132 = circuit_add(t130, t131); // Eval sparse poly line_1p_1 step + coeff_6 * z^6
    let t133 = circuit_mul(t127, t6); // Eval sparse poly line_1p_1 step coeff_8 * z^8
    let t134 = circuit_add(t132, t133); // Eval sparse poly line_1p_1 step + coeff_8 * z^8
    let t135 = circuit_mul(t73, t134); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t136 = circuit_mul(
        t135, t135
    ); // Compute (f^2 * Π(i,k) (line_i,k(z))) ^ 2 = f^4 * (Π(i,k) (line_i,k(z)))^2
    let t137 = circuit_add(t40, t41); // Doubling slope numerator start
    let t138 = circuit_sub(t40, t41);
    let t139 = circuit_mul(t137, t138);
    let t140 = circuit_mul(t40, t41);
    let t141 = circuit_mul(t139, in0);
    let t142 = circuit_mul(t140, in1); // Doubling slope numerator end
    let t143 = circuit_add(t50, t50); // Fp2 add coeff 0/1
    let t144 = circuit_add(t51, t51); // Fp2 add coeff 1/1
    let t145 = circuit_mul(t143, t143); // Fp2 Div x/y start : Fp2 Inv y start
    let t146 = circuit_mul(t144, t144);
    let t147 = circuit_add(t145, t146);
    let t148 = circuit_inverse(t147);
    let t149 = circuit_mul(t143, t148); // Fp2 Inv y real part end
    let t150 = circuit_mul(t144, t148);
    let t151 = circuit_sub(in2, t150); // Fp2 Inv y imag part end
    let t152 = circuit_mul(t141, t149); // Fp2 mul start
    let t153 = circuit_mul(t142, t151);
    let t154 = circuit_sub(t152, t153); // Fp2 mul real part end
    let t155 = circuit_mul(t141, t151);
    let t156 = circuit_mul(t142, t149);
    let t157 = circuit_add(t155, t156); // Fp2 mul imag part end
    let t158 = circuit_add(t154, t157);
    let t159 = circuit_sub(t154, t157);
    let t160 = circuit_mul(t158, t159);
    let t161 = circuit_mul(t154, t157);
    let t162 = circuit_add(t161, t161);
    let t163 = circuit_add(t40, t40); // Fp2 add coeff 0/1
    let t164 = circuit_add(t41, t41); // Fp2 add coeff 1/1
    let t165 = circuit_sub(t160, t163); // Fp2 sub coeff 0/1
    let t166 = circuit_sub(t162, t164); // Fp2 sub coeff 1/1
    let t167 = circuit_sub(t40, t165); // Fp2 sub coeff 0/1
    let t168 = circuit_sub(t41, t166); // Fp2 sub coeff 1/1
    let t169 = circuit_mul(t154, t167); // Fp2 mul start
    let t170 = circuit_mul(t157, t168);
    let t171 = circuit_sub(t169, t170); // Fp2 mul real part end
    let t172 = circuit_mul(t154, t168);
    let t173 = circuit_mul(t157, t167);
    let t174 = circuit_add(t172, t173); // Fp2 mul imag part end
    let t175 = circuit_sub(t171, t50); // Fp2 sub coeff 0/1
    let t176 = circuit_sub(t174, t51); // Fp2 sub coeff 1/1
    let t177 = circuit_mul(t154, t40); // Fp2 mul start
    let t178 = circuit_mul(t157, t41);
    let t179 = circuit_sub(t177, t178); // Fp2 mul real part end
    let t180 = circuit_mul(t154, t41);
    let t181 = circuit_mul(t157, t40);
    let t182 = circuit_add(t180, t181); // Fp2 mul imag part end
    let t183 = circuit_sub(t179, t50); // Fp2 sub coeff 0/1
    let t184 = circuit_sub(t182, t51); // Fp2 sub coeff 1/1
    let t185 = circuit_sub(t183, t184);
    let t186 = circuit_mul(t185, in3);
    let t187 = circuit_sub(t154, t157);
    let t188 = circuit_mul(t187, in4);
    let t189 = circuit_mul(t184, in3);
    let t190 = circuit_mul(t157, in4);
    let t191 = circuit_mul(t188, t0); // Eval sparse poly line_0p_1 step coeff_2 * z^2
    let t192 = circuit_add(t186, t191); // Eval sparse poly line_0p_1 step + coeff_2 * z^2
    let t193 = circuit_add(t192, t1); // Eval sparse poly line_0p_1 step + 1*z^3
    let t194 = circuit_mul(t189, t4); // Eval sparse poly line_0p_1 step coeff_6 * z^6
    let t195 = circuit_add(t193, t194); // Eval sparse poly line_0p_1 step + coeff_6 * z^6
    let t196 = circuit_mul(t190, t6); // Eval sparse poly line_0p_1 step coeff_8 * z^8
    let t197 = circuit_add(t195, t196); // Eval sparse poly line_0p_1 step + coeff_8 * z^8
    let t198 = circuit_mul(t136, t197); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t199 = circuit_add(t102, t103); // Doubling slope numerator start
    let t200 = circuit_sub(t102, t103);
    let t201 = circuit_mul(t199, t200);
    let t202 = circuit_mul(t102, t103);
    let t203 = circuit_mul(t201, in0);
    let t204 = circuit_mul(t202, in1); // Doubling slope numerator end
    let t205 = circuit_add(t112, t112); // Fp2 add coeff 0/1
    let t206 = circuit_add(t113, t113); // Fp2 add coeff 1/1
    let t207 = circuit_mul(t205, t205); // Fp2 Div x/y start : Fp2 Inv y start
    let t208 = circuit_mul(t206, t206);
    let t209 = circuit_add(t207, t208);
    let t210 = circuit_inverse(t209);
    let t211 = circuit_mul(t205, t210); // Fp2 Inv y real part end
    let t212 = circuit_mul(t206, t210);
    let t213 = circuit_sub(in2, t212); // Fp2 Inv y imag part end
    let t214 = circuit_mul(t203, t211); // Fp2 mul start
    let t215 = circuit_mul(t204, t213);
    let t216 = circuit_sub(t214, t215); // Fp2 mul real part end
    let t217 = circuit_mul(t203, t213);
    let t218 = circuit_mul(t204, t211);
    let t219 = circuit_add(t217, t218); // Fp2 mul imag part end
    let t220 = circuit_add(t216, t219);
    let t221 = circuit_sub(t216, t219);
    let t222 = circuit_mul(t220, t221);
    let t223 = circuit_mul(t216, t219);
    let t224 = circuit_add(t223, t223);
    let t225 = circuit_add(t102, t102); // Fp2 add coeff 0/1
    let t226 = circuit_add(t103, t103); // Fp2 add coeff 1/1
    let t227 = circuit_sub(t222, t225); // Fp2 sub coeff 0/1
    let t228 = circuit_sub(t224, t226); // Fp2 sub coeff 1/1
    let t229 = circuit_sub(t102, t227); // Fp2 sub coeff 0/1
    let t230 = circuit_sub(t103, t228); // Fp2 sub coeff 1/1
    let t231 = circuit_mul(t216, t229); // Fp2 mul start
    let t232 = circuit_mul(t219, t230);
    let t233 = circuit_sub(t231, t232); // Fp2 mul real part end
    let t234 = circuit_mul(t216, t230);
    let t235 = circuit_mul(t219, t229);
    let t236 = circuit_add(t234, t235); // Fp2 mul imag part end
    let t237 = circuit_sub(t233, t112); // Fp2 sub coeff 0/1
    let t238 = circuit_sub(t236, t113); // Fp2 sub coeff 1/1
    let t239 = circuit_mul(t216, t102); // Fp2 mul start
    let t240 = circuit_mul(t219, t103);
    let t241 = circuit_sub(t239, t240); // Fp2 mul real part end
    let t242 = circuit_mul(t216, t103);
    let t243 = circuit_mul(t219, t102);
    let t244 = circuit_add(t242, t243); // Fp2 mul imag part end
    let t245 = circuit_sub(t241, t112); // Fp2 sub coeff 0/1
    let t246 = circuit_sub(t244, t113); // Fp2 sub coeff 1/1
    let t247 = circuit_sub(t245, t246);
    let t248 = circuit_mul(t247, in9);
    let t249 = circuit_sub(t216, t219);
    let t250 = circuit_mul(t249, in10);
    let t251 = circuit_mul(t246, in9);
    let t252 = circuit_mul(t219, in10);
    let t253 = circuit_mul(t250, t0); // Eval sparse poly line_1p_1 step coeff_2 * z^2
    let t254 = circuit_add(t248, t253); // Eval sparse poly line_1p_1 step + coeff_2 * z^2
    let t255 = circuit_add(t254, t1); // Eval sparse poly line_1p_1 step + 1*z^3
    let t256 = circuit_mul(t251, t4); // Eval sparse poly line_1p_1 step coeff_6 * z^6
    let t257 = circuit_add(t255, t256); // Eval sparse poly line_1p_1 step + coeff_6 * z^6
    let t258 = circuit_mul(t252, t6); // Eval sparse poly line_1p_1 step coeff_8 * z^8
    let t259 = circuit_add(t257, t258); // Eval sparse poly line_1p_1 step + coeff_8 * z^8
    let t260 = circuit_mul(t198, t259); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t261 = circuit_mul(in18, in29); // Eval R step coeff_1 * z^1
    let t262 = circuit_add(in17, t261); // Eval R step + (coeff_1 * z^1)
    let t263 = circuit_mul(in19, t0); // Eval R step coeff_2 * z^2
    let t264 = circuit_add(t262, t263); // Eval R step + (coeff_2 * z^2)
    let t265 = circuit_mul(in20, t1); // Eval R step coeff_3 * z^3
    let t266 = circuit_add(t264, t265); // Eval R step + (coeff_3 * z^3)
    let t267 = circuit_mul(in21, t2); // Eval R step coeff_4 * z^4
    let t268 = circuit_add(t266, t267); // Eval R step + (coeff_4 * z^4)
    let t269 = circuit_mul(in22, t3); // Eval R step coeff_5 * z^5
    let t270 = circuit_add(t268, t269); // Eval R step + (coeff_5 * z^5)
    let t271 = circuit_mul(in23, t4); // Eval R step coeff_6 * z^6
    let t272 = circuit_add(t270, t271); // Eval R step + (coeff_6 * z^6)
    let t273 = circuit_mul(in24, t5); // Eval R step coeff_7 * z^7
    let t274 = circuit_add(t272, t273); // Eval R step + (coeff_7 * z^7)
    let t275 = circuit_mul(in25, t6); // Eval R step coeff_8 * z^8
    let t276 = circuit_add(t274, t275); // Eval R step + (coeff_8 * z^8)
    let t277 = circuit_mul(in26, t7); // Eval R step coeff_9 * z^9
    let t278 = circuit_add(t276, t277); // Eval R step + (coeff_9 * z^9)
    let t279 = circuit_mul(in27, t8); // Eval R step coeff_10 * z^10
    let t280 = circuit_add(t278, t279); // Eval R step + (coeff_10 * z^10)
    let t281 = circuit_mul(in28, t9); // Eval R step coeff_11 * z^11
    let t282 = circuit_add(t280, t281); // Eval R step + (coeff_11 * z^11)
    let t283 = circuit_sub(t260, t282); // (Π(i,k) (Pk(z))) - Ri(z)
    let t284 = circuit_mul(t10, t283); // ci * ((Π(i,k) (Pk(z)) - Ri(z))
    let t285 = circuit_add(in15, t284); // LHS = LHS + ci * ((Π(i,k) (Pk(z)) - Ri(z))

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

    let mut circuit_inputs = (t165, t166, t175, t176, t227, t228, t237, t238, t282, t285, t10,)
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x6, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(Q_0.x0);
    circuit_inputs = circuit_inputs.next(Q_0.x1);
    circuit_inputs = circuit_inputs.next(Q_0.y0);
    circuit_inputs = circuit_inputs.next(Q_0.y1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(Q_1.x0);
    circuit_inputs = circuit_inputs.next(Q_1.x1);
    circuit_inputs = circuit_inputs.next(Q_1.y0);
    circuit_inputs = circuit_inputs.next(Q_1.y1);
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
    let Q0: G2Point = G2Point {
        x0: outputs.get_output(t165),
        x1: outputs.get_output(t166),
        y0: outputs.get_output(t175),
        y1: outputs.get_output(t176)
    };
    let Q1: G2Point = G2Point {
        x0: outputs.get_output(t227),
        x1: outputs.get_output(t228),
        y0: outputs.get_output(t237),
        y1: outputs.get_output(t238)
    };
    let f_i_plus_one_of_z: u384 = outputs.get_output(t282);
    let lhs_i_plus_one: u384 = outputs.get_output(t285);
    let ci_plus_one: u384 = outputs.get_output(t10);
    return (Q0, Q1, f_i_plus_one_of_z, lhs_i_plus_one, ci_plus_one);
}
fn run_BLS12_381_MP_CHECK_BIT0_LOOP_2_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    Q_0: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q_1: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one: E12D,
    z: u384,
    ci: u384
) -> (G2Point, G2Point, u384, u384, u384) {
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
    let t0 = circuit_mul(in29, in29); // Compute z^2
    let t1 = circuit_mul(t0, in29); // Compute z^3
    let t2 = circuit_mul(t1, in29); // Compute z^4
    let t3 = circuit_mul(t2, in29); // Compute z^5
    let t4 = circuit_mul(t3, in29); // Compute z^6
    let t5 = circuit_mul(t4, in29); // Compute z^7
    let t6 = circuit_mul(t5, in29); // Compute z^8
    let t7 = circuit_mul(t6, in29); // Compute z^9
    let t8 = circuit_mul(t7, in29); // Compute z^10
    let t9 = circuit_mul(t8, in29); // Compute z^11
    let t10 = circuit_mul(in30, in30); // Compute c_i = (c_(i-1))^2
    let t11 = circuit_mul(in16, in16); // Square f evaluation in Z, the result of previous bit.
    let t12 = circuit_add(in5, in6); // Doubling slope numerator start
    let t13 = circuit_sub(in5, in6);
    let t14 = circuit_mul(t12, t13);
    let t15 = circuit_mul(in5, in6);
    let t16 = circuit_mul(t14, in0);
    let t17 = circuit_mul(t15, in1); // Doubling slope numerator end
    let t18 = circuit_add(in7, in7); // Fp2 add coeff 0/1
    let t19 = circuit_add(in8, in8); // Fp2 add coeff 1/1
    let t20 = circuit_mul(t18, t18); // Fp2 Div x/y start : Fp2 Inv y start
    let t21 = circuit_mul(t19, t19);
    let t22 = circuit_add(t20, t21);
    let t23 = circuit_inverse(t22);
    let t24 = circuit_mul(t18, t23); // Fp2 Inv y real part end
    let t25 = circuit_mul(t19, t23);
    let t26 = circuit_sub(in2, t25); // Fp2 Inv y imag part end
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
    let t66 = circuit_mul(t63, t0); // Eval sparse poly line_0p_1 step coeff_2 * z^2
    let t67 = circuit_add(t61, t66); // Eval sparse poly line_0p_1 step + coeff_2 * z^2
    let t68 = circuit_add(t67, t1); // Eval sparse poly line_0p_1 step + 1*z^3
    let t69 = circuit_mul(t64, t4); // Eval sparse poly line_0p_1 step coeff_6 * z^6
    let t70 = circuit_add(t68, t69); // Eval sparse poly line_0p_1 step + coeff_6 * z^6
    let t71 = circuit_mul(t65, t6); // Eval sparse poly line_0p_1 step coeff_8 * z^8
    let t72 = circuit_add(t70, t71); // Eval sparse poly line_0p_1 step + coeff_8 * z^8
    let t73 = circuit_mul(t11, t72); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t74 = circuit_add(in11, in12); // Doubling slope numerator start
    let t75 = circuit_sub(in11, in12);
    let t76 = circuit_mul(t74, t75);
    let t77 = circuit_mul(in11, in12);
    let t78 = circuit_mul(t76, in0);
    let t79 = circuit_mul(t77, in1); // Doubling slope numerator end
    let t80 = circuit_add(in13, in13); // Fp2 add coeff 0/1
    let t81 = circuit_add(in14, in14); // Fp2 add coeff 1/1
    let t82 = circuit_mul(t80, t80); // Fp2 Div x/y start : Fp2 Inv y start
    let t83 = circuit_mul(t81, t81);
    let t84 = circuit_add(t82, t83);
    let t85 = circuit_inverse(t84);
    let t86 = circuit_mul(t80, t85); // Fp2 Inv y real part end
    let t87 = circuit_mul(t81, t85);
    let t88 = circuit_sub(in2, t87); // Fp2 Inv y imag part end
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
    let t128 = circuit_mul(t125, t0); // Eval sparse poly line_1p_1 step coeff_2 * z^2
    let t129 = circuit_add(t123, t128); // Eval sparse poly line_1p_1 step + coeff_2 * z^2
    let t130 = circuit_add(t129, t1); // Eval sparse poly line_1p_1 step + 1*z^3
    let t131 = circuit_mul(t126, t4); // Eval sparse poly line_1p_1 step coeff_6 * z^6
    let t132 = circuit_add(t130, t131); // Eval sparse poly line_1p_1 step + coeff_6 * z^6
    let t133 = circuit_mul(t127, t6); // Eval sparse poly line_1p_1 step coeff_8 * z^8
    let t134 = circuit_add(t132, t133); // Eval sparse poly line_1p_1 step + coeff_8 * z^8
    let t135 = circuit_mul(t73, t134); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t136 = circuit_mul(in18, in29); // Eval R step coeff_1 * z^1
    let t137 = circuit_add(in17, t136); // Eval R step + (coeff_1 * z^1)
    let t138 = circuit_mul(in19, t0); // Eval R step coeff_2 * z^2
    let t139 = circuit_add(t137, t138); // Eval R step + (coeff_2 * z^2)
    let t140 = circuit_mul(in20, t1); // Eval R step coeff_3 * z^3
    let t141 = circuit_add(t139, t140); // Eval R step + (coeff_3 * z^3)
    let t142 = circuit_mul(in21, t2); // Eval R step coeff_4 * z^4
    let t143 = circuit_add(t141, t142); // Eval R step + (coeff_4 * z^4)
    let t144 = circuit_mul(in22, t3); // Eval R step coeff_5 * z^5
    let t145 = circuit_add(t143, t144); // Eval R step + (coeff_5 * z^5)
    let t146 = circuit_mul(in23, t4); // Eval R step coeff_6 * z^6
    let t147 = circuit_add(t145, t146); // Eval R step + (coeff_6 * z^6)
    let t148 = circuit_mul(in24, t5); // Eval R step coeff_7 * z^7
    let t149 = circuit_add(t147, t148); // Eval R step + (coeff_7 * z^7)
    let t150 = circuit_mul(in25, t6); // Eval R step coeff_8 * z^8
    let t151 = circuit_add(t149, t150); // Eval R step + (coeff_8 * z^8)
    let t152 = circuit_mul(in26, t7); // Eval R step coeff_9 * z^9
    let t153 = circuit_add(t151, t152); // Eval R step + (coeff_9 * z^9)
    let t154 = circuit_mul(in27, t8); // Eval R step coeff_10 * z^10
    let t155 = circuit_add(t153, t154); // Eval R step + (coeff_10 * z^10)
    let t156 = circuit_mul(in28, t9); // Eval R step coeff_11 * z^11
    let t157 = circuit_add(t155, t156); // Eval R step + (coeff_11 * z^11)
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
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x6, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(Q_0.x0);
    circuit_inputs = circuit_inputs.next(Q_0.x1);
    circuit_inputs = circuit_inputs.next(Q_0.y0);
    circuit_inputs = circuit_inputs.next(Q_0.y1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(Q_1.x0);
    circuit_inputs = circuit_inputs.next(Q_1.x1);
    circuit_inputs = circuit_inputs.next(Q_1.y0);
    circuit_inputs = circuit_inputs.next(Q_1.y1);
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
fn run_BLS12_381_MP_CHECK_BIT1_LOOP_2_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    Q_0: G2Point,
    Q_or_Q_neg_0: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q_1: G2Point,
    Q_or_Q_neg_1: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one: E12D,
    c_or_cinv_of_z: u384,
    z: u384,
    ci: u384
) -> (G2Point, G2Point, u384, u384, u384) {
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
    let in37 = CE::<CI<37>> {};
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
    let t10 = circuit_mul(in37, in37); // Compute c_i = (c_(i-1))^2
    let t11 = circuit_mul(in22, in22); // Square f evaluation in Z, the result of previous bit.
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
    let t46 = circuit_add(in5, in5); // Fp2 add coeff 0/1
    let t47 = circuit_add(in6, in6); // Fp2 add coeff 1/1
    let t48 = circuit_sub(t36, in3); // Fp2 sub coeff 0/1
    let t49 = circuit_sub(t37, in4); // Fp2 sub coeff 1/1
    let t50 = circuit_mul(t48, t48); // Fp2 Div x/y start : Fp2 Inv y start
    let t51 = circuit_mul(t49, t49);
    let t52 = circuit_add(t50, t51);
    let t53 = circuit_inverse(t52);
    let t54 = circuit_mul(t48, t53); // Fp2 Inv y real part end
    let t55 = circuit_mul(t49, t53);
    let t56 = circuit_sub(in0, t55); // Fp2 Inv y imag part end
    let t57 = circuit_mul(t46, t54); // Fp2 mul start
    let t58 = circuit_mul(t47, t56);
    let t59 = circuit_sub(t57, t58); // Fp2 mul real part end
    let t60 = circuit_mul(t46, t56);
    let t61 = circuit_mul(t47, t54);
    let t62 = circuit_add(t60, t61); // Fp2 mul imag part end
    let t63 = circuit_add(t25, t59); // Fp2 add coeff 0/1
    let t64 = circuit_add(t28, t62); // Fp2 add coeff 1/1
    let t65 = circuit_sub(in0, t63); // Fp2 neg coeff 0/1
    let t66 = circuit_sub(in0, t64); // Fp2 neg coeff 1/1
    let t67 = circuit_add(t65, t66);
    let t68 = circuit_sub(t65, t66);
    let t69 = circuit_mul(t67, t68);
    let t70 = circuit_mul(t65, t66);
    let t71 = circuit_add(t70, t70);
    let t72 = circuit_sub(t69, in3); // Fp2 sub coeff 0/1
    let t73 = circuit_sub(t71, in4); // Fp2 sub coeff 1/1
    let t74 = circuit_sub(t72, t36); // Fp2 sub coeff 0/1
    let t75 = circuit_sub(t73, t37); // Fp2 sub coeff 1/1
    let t76 = circuit_sub(in3, t74); // Fp2 sub coeff 0/1
    let t77 = circuit_sub(in4, t75); // Fp2 sub coeff 1/1
    let t78 = circuit_mul(t65, t76); // Fp2 mul start
    let t79 = circuit_mul(t66, t77);
    let t80 = circuit_sub(t78, t79); // Fp2 mul real part end
    let t81 = circuit_mul(t65, t77);
    let t82 = circuit_mul(t66, t76);
    let t83 = circuit_add(t81, t82); // Fp2 mul imag part end
    let t84 = circuit_sub(t80, in5); // Fp2 sub coeff 0/1
    let t85 = circuit_sub(t83, in6); // Fp2 sub coeff 1/1
    let t86 = circuit_mul(t65, in3); // Fp2 mul start
    let t87 = circuit_mul(t66, in4);
    let t88 = circuit_sub(t86, t87); // Fp2 mul real part end
    let t89 = circuit_mul(t65, in4);
    let t90 = circuit_mul(t66, in3);
    let t91 = circuit_add(t89, t90); // Fp2 mul imag part end
    let t92 = circuit_sub(t88, in5); // Fp2 sub coeff 0/1
    let t93 = circuit_sub(t91, in6); // Fp2 sub coeff 1/1
    let t94 = circuit_sub(t44, t45);
    let t95 = circuit_mul(t94, in1);
    let t96 = circuit_sub(t25, t28);
    let t97 = circuit_mul(t96, in2);
    let t98 = circuit_mul(t45, in1);
    let t99 = circuit_mul(t28, in2);
    let t100 = circuit_sub(t92, t93);
    let t101 = circuit_mul(t100, in1);
    let t102 = circuit_sub(t65, t66);
    let t103 = circuit_mul(t102, in2);
    let t104 = circuit_mul(t93, in1);
    let t105 = circuit_mul(t66, in2);
    let t106 = circuit_mul(t97, t0); // Eval sparse poly line_0p_1 step coeff_2 * z^2
    let t107 = circuit_add(t95, t106); // Eval sparse poly line_0p_1 step + coeff_2 * z^2
    let t108 = circuit_add(t107, t1); // Eval sparse poly line_0p_1 step + 1*z^3
    let t109 = circuit_mul(t98, t4); // Eval sparse poly line_0p_1 step coeff_6 * z^6
    let t110 = circuit_add(t108, t109); // Eval sparse poly line_0p_1 step + coeff_6 * z^6
    let t111 = circuit_mul(t99, t6); // Eval sparse poly line_0p_1 step coeff_8 * z^8
    let t112 = circuit_add(t110, t111); // Eval sparse poly line_0p_1 step + coeff_8 * z^8
    let t113 = circuit_mul(t11, t112); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t114 = circuit_mul(t103, t0); // Eval sparse poly line_0p_2 step coeff_2 * z^2
    let t115 = circuit_add(t101, t114); // Eval sparse poly line_0p_2 step + coeff_2 * z^2
    let t116 = circuit_add(t115, t1); // Eval sparse poly line_0p_2 step + 1*z^3
    let t117 = circuit_mul(t104, t4); // Eval sparse poly line_0p_2 step coeff_6 * z^6
    let t118 = circuit_add(t116, t117); // Eval sparse poly line_0p_2 step + coeff_6 * z^6
    let t119 = circuit_mul(t105, t6); // Eval sparse poly line_0p_2 step coeff_8 * z^8
    let t120 = circuit_add(t118, t119); // Eval sparse poly line_0p_2 step + coeff_8 * z^8
    let t121 = circuit_mul(t113, t120); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
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
    let t156 = circuit_add(in15, in15); // Fp2 add coeff 0/1
    let t157 = circuit_add(in16, in16); // Fp2 add coeff 1/1
    let t158 = circuit_sub(t146, in13); // Fp2 sub coeff 0/1
    let t159 = circuit_sub(t147, in14); // Fp2 sub coeff 1/1
    let t160 = circuit_mul(t158, t158); // Fp2 Div x/y start : Fp2 Inv y start
    let t161 = circuit_mul(t159, t159);
    let t162 = circuit_add(t160, t161);
    let t163 = circuit_inverse(t162);
    let t164 = circuit_mul(t158, t163); // Fp2 Inv y real part end
    let t165 = circuit_mul(t159, t163);
    let t166 = circuit_sub(in0, t165); // Fp2 Inv y imag part end
    let t167 = circuit_mul(t156, t164); // Fp2 mul start
    let t168 = circuit_mul(t157, t166);
    let t169 = circuit_sub(t167, t168); // Fp2 mul real part end
    let t170 = circuit_mul(t156, t166);
    let t171 = circuit_mul(t157, t164);
    let t172 = circuit_add(t170, t171); // Fp2 mul imag part end
    let t173 = circuit_add(t135, t169); // Fp2 add coeff 0/1
    let t174 = circuit_add(t138, t172); // Fp2 add coeff 1/1
    let t175 = circuit_sub(in0, t173); // Fp2 neg coeff 0/1
    let t176 = circuit_sub(in0, t174); // Fp2 neg coeff 1/1
    let t177 = circuit_add(t175, t176);
    let t178 = circuit_sub(t175, t176);
    let t179 = circuit_mul(t177, t178);
    let t180 = circuit_mul(t175, t176);
    let t181 = circuit_add(t180, t180);
    let t182 = circuit_sub(t179, in13); // Fp2 sub coeff 0/1
    let t183 = circuit_sub(t181, in14); // Fp2 sub coeff 1/1
    let t184 = circuit_sub(t182, t146); // Fp2 sub coeff 0/1
    let t185 = circuit_sub(t183, t147); // Fp2 sub coeff 1/1
    let t186 = circuit_sub(in13, t184); // Fp2 sub coeff 0/1
    let t187 = circuit_sub(in14, t185); // Fp2 sub coeff 1/1
    let t188 = circuit_mul(t175, t186); // Fp2 mul start
    let t189 = circuit_mul(t176, t187);
    let t190 = circuit_sub(t188, t189); // Fp2 mul real part end
    let t191 = circuit_mul(t175, t187);
    let t192 = circuit_mul(t176, t186);
    let t193 = circuit_add(t191, t192); // Fp2 mul imag part end
    let t194 = circuit_sub(t190, in15); // Fp2 sub coeff 0/1
    let t195 = circuit_sub(t193, in16); // Fp2 sub coeff 1/1
    let t196 = circuit_mul(t175, in13); // Fp2 mul start
    let t197 = circuit_mul(t176, in14);
    let t198 = circuit_sub(t196, t197); // Fp2 mul real part end
    let t199 = circuit_mul(t175, in14);
    let t200 = circuit_mul(t176, in13);
    let t201 = circuit_add(t199, t200); // Fp2 mul imag part end
    let t202 = circuit_sub(t198, in15); // Fp2 sub coeff 0/1
    let t203 = circuit_sub(t201, in16); // Fp2 sub coeff 1/1
    let t204 = circuit_sub(t154, t155);
    let t205 = circuit_mul(t204, in11);
    let t206 = circuit_sub(t135, t138);
    let t207 = circuit_mul(t206, in12);
    let t208 = circuit_mul(t155, in11);
    let t209 = circuit_mul(t138, in12);
    let t210 = circuit_sub(t202, t203);
    let t211 = circuit_mul(t210, in11);
    let t212 = circuit_sub(t175, t176);
    let t213 = circuit_mul(t212, in12);
    let t214 = circuit_mul(t203, in11);
    let t215 = circuit_mul(t176, in12);
    let t216 = circuit_mul(t207, t0); // Eval sparse poly line_1p_1 step coeff_2 * z^2
    let t217 = circuit_add(t205, t216); // Eval sparse poly line_1p_1 step + coeff_2 * z^2
    let t218 = circuit_add(t217, t1); // Eval sparse poly line_1p_1 step + 1*z^3
    let t219 = circuit_mul(t208, t4); // Eval sparse poly line_1p_1 step coeff_6 * z^6
    let t220 = circuit_add(t218, t219); // Eval sparse poly line_1p_1 step + coeff_6 * z^6
    let t221 = circuit_mul(t209, t6); // Eval sparse poly line_1p_1 step coeff_8 * z^8
    let t222 = circuit_add(t220, t221); // Eval sparse poly line_1p_1 step + coeff_8 * z^8
    let t223 = circuit_mul(t121, t222); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t224 = circuit_mul(t213, t0); // Eval sparse poly line_1p_2 step coeff_2 * z^2
    let t225 = circuit_add(t211, t224); // Eval sparse poly line_1p_2 step + coeff_2 * z^2
    let t226 = circuit_add(t225, t1); // Eval sparse poly line_1p_2 step + 1*z^3
    let t227 = circuit_mul(t214, t4); // Eval sparse poly line_1p_2 step coeff_6 * z^6
    let t228 = circuit_add(t226, t227); // Eval sparse poly line_1p_2 step + coeff_6 * z^6
    let t229 = circuit_mul(t215, t6); // Eval sparse poly line_1p_2 step coeff_8 * z^8
    let t230 = circuit_add(t228, t229); // Eval sparse poly line_1p_2 step + coeff_8 * z^8
    let t231 = circuit_mul(t223, t230); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t232 = circuit_mul(t231, in35);
    let t233 = circuit_mul(in24, in36); // Eval R step coeff_1 * z^1
    let t234 = circuit_add(in23, t233); // Eval R step + (coeff_1 * z^1)
    let t235 = circuit_mul(in25, t0); // Eval R step coeff_2 * z^2
    let t236 = circuit_add(t234, t235); // Eval R step + (coeff_2 * z^2)
    let t237 = circuit_mul(in26, t1); // Eval R step coeff_3 * z^3
    let t238 = circuit_add(t236, t237); // Eval R step + (coeff_3 * z^3)
    let t239 = circuit_mul(in27, t2); // Eval R step coeff_4 * z^4
    let t240 = circuit_add(t238, t239); // Eval R step + (coeff_4 * z^4)
    let t241 = circuit_mul(in28, t3); // Eval R step coeff_5 * z^5
    let t242 = circuit_add(t240, t241); // Eval R step + (coeff_5 * z^5)
    let t243 = circuit_mul(in29, t4); // Eval R step coeff_6 * z^6
    let t244 = circuit_add(t242, t243); // Eval R step + (coeff_6 * z^6)
    let t245 = circuit_mul(in30, t5); // Eval R step coeff_7 * z^7
    let t246 = circuit_add(t244, t245); // Eval R step + (coeff_7 * z^7)
    let t247 = circuit_mul(in31, t6); // Eval R step coeff_8 * z^8
    let t248 = circuit_add(t246, t247); // Eval R step + (coeff_8 * z^8)
    let t249 = circuit_mul(in32, t7); // Eval R step coeff_9 * z^9
    let t250 = circuit_add(t248, t249); // Eval R step + (coeff_9 * z^9)
    let t251 = circuit_mul(in33, t8); // Eval R step coeff_10 * z^10
    let t252 = circuit_add(t250, t251); // Eval R step + (coeff_10 * z^10)
    let t253 = circuit_mul(in34, t9); // Eval R step coeff_11 * z^11
    let t254 = circuit_add(t252, t253); // Eval R step + (coeff_11 * z^11)
    let t255 = circuit_sub(t232, t254); // (Π(i,k) (Pk(z))) - Ri(z)
    let t256 = circuit_mul(t10, t255); // ci * ((Π(i,k) (Pk(z)) - Ri(z))
    let t257 = circuit_add(in21, t256); // LHS = LHS + ci * ((Π(i,k) (Pk(z)) - Ri(z))

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

    let mut circuit_inputs = (t74, t75, t84, t85, t184, t185, t194, t195, t254, t257, t10,)
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(Q_0.x0);
    circuit_inputs = circuit_inputs.next(Q_0.x1);
    circuit_inputs = circuit_inputs.next(Q_0.y0);
    circuit_inputs = circuit_inputs.next(Q_0.y1);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_0.x0);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_0.x1);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_0.y0);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_0.y1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(Q_1.x0);
    circuit_inputs = circuit_inputs.next(Q_1.x1);
    circuit_inputs = circuit_inputs.next(Q_1.y0);
    circuit_inputs = circuit_inputs.next(Q_1.y1);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_1.x0);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_1.x1);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_1.y0);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_1.y1);
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
        x0: outputs.get_output(t74),
        x1: outputs.get_output(t75),
        y0: outputs.get_output(t84),
        y1: outputs.get_output(t85)
    };
    let Q1: G2Point = G2Point {
        x0: outputs.get_output(t184),
        x1: outputs.get_output(t185),
        y0: outputs.get_output(t194),
        y1: outputs.get_output(t195)
    };
    let f_i_plus_one_of_z: u384 = outputs.get_output(t254);
    let lhs_i_plus_one: u384 = outputs.get_output(t257);
    let ci_plus_one: u384 = outputs.get_output(t10);
    return (Q0, Q1, f_i_plus_one_of_z, lhs_i_plus_one, ci_plus_one);
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
    let in100 = CE::<CI<100>> {};
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
    let t79 = circuit_mul(in14, in14);
    let t80 = circuit_mul(in3, in16); // Eval R_n_minus_1 step coeff_1 * z^1
    let t81 = circuit_add(in2, t80); // Eval R_n_minus_1 step + (coeff_1 * z^1)
    let t82 = circuit_mul(in4, t0); // Eval R_n_minus_1 step coeff_2 * z^2
    let t83 = circuit_add(t81, t82); // Eval R_n_minus_1 step + (coeff_2 * z^2)
    let t84 = circuit_mul(in5, t1); // Eval R_n_minus_1 step coeff_3 * z^3
    let t85 = circuit_add(t83, t84); // Eval R_n_minus_1 step + (coeff_3 * z^3)
    let t86 = circuit_mul(in6, t2); // Eval R_n_minus_1 step coeff_4 * z^4
    let t87 = circuit_add(t85, t86); // Eval R_n_minus_1 step + (coeff_4 * z^4)
    let t88 = circuit_mul(in7, t3); // Eval R_n_minus_1 step coeff_5 * z^5
    let t89 = circuit_add(t87, t88); // Eval R_n_minus_1 step + (coeff_5 * z^5)
    let t90 = circuit_mul(in8, t4); // Eval R_n_minus_1 step coeff_6 * z^6
    let t91 = circuit_add(t89, t90); // Eval R_n_minus_1 step + (coeff_6 * z^6)
    let t92 = circuit_mul(in9, t5); // Eval R_n_minus_1 step coeff_7 * z^7
    let t93 = circuit_add(t91, t92); // Eval R_n_minus_1 step + (coeff_7 * z^7)
    let t94 = circuit_mul(in10, t6); // Eval R_n_minus_1 step coeff_8 * z^8
    let t95 = circuit_add(t93, t94); // Eval R_n_minus_1 step + (coeff_8 * z^8)
    let t96 = circuit_mul(in11, t7); // Eval R_n_minus_1 step coeff_9 * z^9
    let t97 = circuit_add(t95, t96); // Eval R_n_minus_1 step + (coeff_9 * z^9)
    let t98 = circuit_mul(in12, t8); // Eval R_n_minus_1 step coeff_10 * z^10
    let t99 = circuit_add(t97, t98); // Eval R_n_minus_1 step + (coeff_10 * z^10)
    let t100 = circuit_mul(in13, t9); // Eval R_n_minus_1 step coeff_11 * z^11
    let t101 = circuit_add(t99, t100); // Eval R_n_minus_1 step + (coeff_11 * z^11)
    let t102 = circuit_mul(in19, in17);
    let t103 = circuit_mul(t102, in15);
    let t104 = circuit_sub(t103, t101);
    let t105 = circuit_mul(t79, t104); // c_n_minus_1 * ((Π(n-1,k) (Pk(z)) - R_n_minus_1(z))
    let t106 = circuit_add(in18, t105); // previous_lhs + lhs_n_minus_1
    let t107 = circuit_mul(in1, t4); // Eval sparse poly P_irr step coeff_6 * z^6
    let t108 = circuit_add(in0, t107); // Eval sparse poly P_irr step + coeff_6 * z^6
    let t109 = circuit_add(t108, t10); // Eval sparse poly P_irr step + 1*z^12
    let t110 = circuit_mul(in21, in16); // Eval big_Q step coeff_1 * z^1
    let t111 = circuit_add(in20, t110); // Eval big_Q step + (coeff_1 * z^1)
    let t112 = circuit_mul(in22, t0); // Eval big_Q step coeff_2 * z^2
    let t113 = circuit_add(t111, t112); // Eval big_Q step + (coeff_2 * z^2)
    let t114 = circuit_mul(in23, t1); // Eval big_Q step coeff_3 * z^3
    let t115 = circuit_add(t113, t114); // Eval big_Q step + (coeff_3 * z^3)
    let t116 = circuit_mul(in24, t2); // Eval big_Q step coeff_4 * z^4
    let t117 = circuit_add(t115, t116); // Eval big_Q step + (coeff_4 * z^4)
    let t118 = circuit_mul(in25, t3); // Eval big_Q step coeff_5 * z^5
    let t119 = circuit_add(t117, t118); // Eval big_Q step + (coeff_5 * z^5)
    let t120 = circuit_mul(in26, t4); // Eval big_Q step coeff_6 * z^6
    let t121 = circuit_add(t119, t120); // Eval big_Q step + (coeff_6 * z^6)
    let t122 = circuit_mul(in27, t5); // Eval big_Q step coeff_7 * z^7
    let t123 = circuit_add(t121, t122); // Eval big_Q step + (coeff_7 * z^7)
    let t124 = circuit_mul(in28, t6); // Eval big_Q step coeff_8 * z^8
    let t125 = circuit_add(t123, t124); // Eval big_Q step + (coeff_8 * z^8)
    let t126 = circuit_mul(in29, t7); // Eval big_Q step coeff_9 * z^9
    let t127 = circuit_add(t125, t126); // Eval big_Q step + (coeff_9 * z^9)
    let t128 = circuit_mul(in30, t8); // Eval big_Q step coeff_10 * z^10
    let t129 = circuit_add(t127, t128); // Eval big_Q step + (coeff_10 * z^10)
    let t130 = circuit_mul(in31, t9); // Eval big_Q step coeff_11 * z^11
    let t131 = circuit_add(t129, t130); // Eval big_Q step + (coeff_11 * z^11)
    let t132 = circuit_mul(in32, t10); // Eval big_Q step coeff_12 * z^12
    let t133 = circuit_add(t131, t132); // Eval big_Q step + (coeff_12 * z^12)
    let t134 = circuit_mul(in33, t11); // Eval big_Q step coeff_13 * z^13
    let t135 = circuit_add(t133, t134); // Eval big_Q step + (coeff_13 * z^13)
    let t136 = circuit_mul(in34, t12); // Eval big_Q step coeff_14 * z^14
    let t137 = circuit_add(t135, t136); // Eval big_Q step + (coeff_14 * z^14)
    let t138 = circuit_mul(in35, t13); // Eval big_Q step coeff_15 * z^15
    let t139 = circuit_add(t137, t138); // Eval big_Q step + (coeff_15 * z^15)
    let t140 = circuit_mul(in36, t14); // Eval big_Q step coeff_16 * z^16
    let t141 = circuit_add(t139, t140); // Eval big_Q step + (coeff_16 * z^16)
    let t142 = circuit_mul(in37, t15); // Eval big_Q step coeff_17 * z^17
    let t143 = circuit_add(t141, t142); // Eval big_Q step + (coeff_17 * z^17)
    let t144 = circuit_mul(in38, t16); // Eval big_Q step coeff_18 * z^18
    let t145 = circuit_add(t143, t144); // Eval big_Q step + (coeff_18 * z^18)
    let t146 = circuit_mul(in39, t17); // Eval big_Q step coeff_19 * z^19
    let t147 = circuit_add(t145, t146); // Eval big_Q step + (coeff_19 * z^19)
    let t148 = circuit_mul(in40, t18); // Eval big_Q step coeff_20 * z^20
    let t149 = circuit_add(t147, t148); // Eval big_Q step + (coeff_20 * z^20)
    let t150 = circuit_mul(in41, t19); // Eval big_Q step coeff_21 * z^21
    let t151 = circuit_add(t149, t150); // Eval big_Q step + (coeff_21 * z^21)
    let t152 = circuit_mul(in42, t20); // Eval big_Q step coeff_22 * z^22
    let t153 = circuit_add(t151, t152); // Eval big_Q step + (coeff_22 * z^22)
    let t154 = circuit_mul(in43, t21); // Eval big_Q step coeff_23 * z^23
    let t155 = circuit_add(t153, t154); // Eval big_Q step + (coeff_23 * z^23)
    let t156 = circuit_mul(in44, t22); // Eval big_Q step coeff_24 * z^24
    let t157 = circuit_add(t155, t156); // Eval big_Q step + (coeff_24 * z^24)
    let t158 = circuit_mul(in45, t23); // Eval big_Q step coeff_25 * z^25
    let t159 = circuit_add(t157, t158); // Eval big_Q step + (coeff_25 * z^25)
    let t160 = circuit_mul(in46, t24); // Eval big_Q step coeff_26 * z^26
    let t161 = circuit_add(t159, t160); // Eval big_Q step + (coeff_26 * z^26)
    let t162 = circuit_mul(in47, t25); // Eval big_Q step coeff_27 * z^27
    let t163 = circuit_add(t161, t162); // Eval big_Q step + (coeff_27 * z^27)
    let t164 = circuit_mul(in48, t26); // Eval big_Q step coeff_28 * z^28
    let t165 = circuit_add(t163, t164); // Eval big_Q step + (coeff_28 * z^28)
    let t166 = circuit_mul(in49, t27); // Eval big_Q step coeff_29 * z^29
    let t167 = circuit_add(t165, t166); // Eval big_Q step + (coeff_29 * z^29)
    let t168 = circuit_mul(in50, t28); // Eval big_Q step coeff_30 * z^30
    let t169 = circuit_add(t167, t168); // Eval big_Q step + (coeff_30 * z^30)
    let t170 = circuit_mul(in51, t29); // Eval big_Q step coeff_31 * z^31
    let t171 = circuit_add(t169, t170); // Eval big_Q step + (coeff_31 * z^31)
    let t172 = circuit_mul(in52, t30); // Eval big_Q step coeff_32 * z^32
    let t173 = circuit_add(t171, t172); // Eval big_Q step + (coeff_32 * z^32)
    let t174 = circuit_mul(in53, t31); // Eval big_Q step coeff_33 * z^33
    let t175 = circuit_add(t173, t174); // Eval big_Q step + (coeff_33 * z^33)
    let t176 = circuit_mul(in54, t32); // Eval big_Q step coeff_34 * z^34
    let t177 = circuit_add(t175, t176); // Eval big_Q step + (coeff_34 * z^34)
    let t178 = circuit_mul(in55, t33); // Eval big_Q step coeff_35 * z^35
    let t179 = circuit_add(t177, t178); // Eval big_Q step + (coeff_35 * z^35)
    let t180 = circuit_mul(in56, t34); // Eval big_Q step coeff_36 * z^36
    let t181 = circuit_add(t179, t180); // Eval big_Q step + (coeff_36 * z^36)
    let t182 = circuit_mul(in57, t35); // Eval big_Q step coeff_37 * z^37
    let t183 = circuit_add(t181, t182); // Eval big_Q step + (coeff_37 * z^37)
    let t184 = circuit_mul(in58, t36); // Eval big_Q step coeff_38 * z^38
    let t185 = circuit_add(t183, t184); // Eval big_Q step + (coeff_38 * z^38)
    let t186 = circuit_mul(in59, t37); // Eval big_Q step coeff_39 * z^39
    let t187 = circuit_add(t185, t186); // Eval big_Q step + (coeff_39 * z^39)
    let t188 = circuit_mul(in60, t38); // Eval big_Q step coeff_40 * z^40
    let t189 = circuit_add(t187, t188); // Eval big_Q step + (coeff_40 * z^40)
    let t190 = circuit_mul(in61, t39); // Eval big_Q step coeff_41 * z^41
    let t191 = circuit_add(t189, t190); // Eval big_Q step + (coeff_41 * z^41)
    let t192 = circuit_mul(in62, t40); // Eval big_Q step coeff_42 * z^42
    let t193 = circuit_add(t191, t192); // Eval big_Q step + (coeff_42 * z^42)
    let t194 = circuit_mul(in63, t41); // Eval big_Q step coeff_43 * z^43
    let t195 = circuit_add(t193, t194); // Eval big_Q step + (coeff_43 * z^43)
    let t196 = circuit_mul(in64, t42); // Eval big_Q step coeff_44 * z^44
    let t197 = circuit_add(t195, t196); // Eval big_Q step + (coeff_44 * z^44)
    let t198 = circuit_mul(in65, t43); // Eval big_Q step coeff_45 * z^45
    let t199 = circuit_add(t197, t198); // Eval big_Q step + (coeff_45 * z^45)
    let t200 = circuit_mul(in66, t44); // Eval big_Q step coeff_46 * z^46
    let t201 = circuit_add(t199, t200); // Eval big_Q step + (coeff_46 * z^46)
    let t202 = circuit_mul(in67, t45); // Eval big_Q step coeff_47 * z^47
    let t203 = circuit_add(t201, t202); // Eval big_Q step + (coeff_47 * z^47)
    let t204 = circuit_mul(in68, t46); // Eval big_Q step coeff_48 * z^48
    let t205 = circuit_add(t203, t204); // Eval big_Q step + (coeff_48 * z^48)
    let t206 = circuit_mul(in69, t47); // Eval big_Q step coeff_49 * z^49
    let t207 = circuit_add(t205, t206); // Eval big_Q step + (coeff_49 * z^49)
    let t208 = circuit_mul(in70, t48); // Eval big_Q step coeff_50 * z^50
    let t209 = circuit_add(t207, t208); // Eval big_Q step + (coeff_50 * z^50)
    let t210 = circuit_mul(in71, t49); // Eval big_Q step coeff_51 * z^51
    let t211 = circuit_add(t209, t210); // Eval big_Q step + (coeff_51 * z^51)
    let t212 = circuit_mul(in72, t50); // Eval big_Q step coeff_52 * z^52
    let t213 = circuit_add(t211, t212); // Eval big_Q step + (coeff_52 * z^52)
    let t214 = circuit_mul(in73, t51); // Eval big_Q step coeff_53 * z^53
    let t215 = circuit_add(t213, t214); // Eval big_Q step + (coeff_53 * z^53)
    let t216 = circuit_mul(in74, t52); // Eval big_Q step coeff_54 * z^54
    let t217 = circuit_add(t215, t216); // Eval big_Q step + (coeff_54 * z^54)
    let t218 = circuit_mul(in75, t53); // Eval big_Q step coeff_55 * z^55
    let t219 = circuit_add(t217, t218); // Eval big_Q step + (coeff_55 * z^55)
    let t220 = circuit_mul(in76, t54); // Eval big_Q step coeff_56 * z^56
    let t221 = circuit_add(t219, t220); // Eval big_Q step + (coeff_56 * z^56)
    let t222 = circuit_mul(in77, t55); // Eval big_Q step coeff_57 * z^57
    let t223 = circuit_add(t221, t222); // Eval big_Q step + (coeff_57 * z^57)
    let t224 = circuit_mul(in78, t56); // Eval big_Q step coeff_58 * z^58
    let t225 = circuit_add(t223, t224); // Eval big_Q step + (coeff_58 * z^58)
    let t226 = circuit_mul(in79, t57); // Eval big_Q step coeff_59 * z^59
    let t227 = circuit_add(t225, t226); // Eval big_Q step + (coeff_59 * z^59)
    let t228 = circuit_mul(in80, t58); // Eval big_Q step coeff_60 * z^60
    let t229 = circuit_add(t227, t228); // Eval big_Q step + (coeff_60 * z^60)
    let t230 = circuit_mul(in81, t59); // Eval big_Q step coeff_61 * z^61
    let t231 = circuit_add(t229, t230); // Eval big_Q step + (coeff_61 * z^61)
    let t232 = circuit_mul(in82, t60); // Eval big_Q step coeff_62 * z^62
    let t233 = circuit_add(t231, t232); // Eval big_Q step + (coeff_62 * z^62)
    let t234 = circuit_mul(in83, t61); // Eval big_Q step coeff_63 * z^63
    let t235 = circuit_add(t233, t234); // Eval big_Q step + (coeff_63 * z^63)
    let t236 = circuit_mul(in84, t62); // Eval big_Q step coeff_64 * z^64
    let t237 = circuit_add(t235, t236); // Eval big_Q step + (coeff_64 * z^64)
    let t238 = circuit_mul(in85, t63); // Eval big_Q step coeff_65 * z^65
    let t239 = circuit_add(t237, t238); // Eval big_Q step + (coeff_65 * z^65)
    let t240 = circuit_mul(in86, t64); // Eval big_Q step coeff_66 * z^66
    let t241 = circuit_add(t239, t240); // Eval big_Q step + (coeff_66 * z^66)
    let t242 = circuit_mul(in87, t65); // Eval big_Q step coeff_67 * z^67
    let t243 = circuit_add(t241, t242); // Eval big_Q step + (coeff_67 * z^67)
    let t244 = circuit_mul(in88, t66); // Eval big_Q step coeff_68 * z^68
    let t245 = circuit_add(t243, t244); // Eval big_Q step + (coeff_68 * z^68)
    let t246 = circuit_mul(in89, t67); // Eval big_Q step coeff_69 * z^69
    let t247 = circuit_add(t245, t246); // Eval big_Q step + (coeff_69 * z^69)
    let t248 = circuit_mul(in90, t68); // Eval big_Q step coeff_70 * z^70
    let t249 = circuit_add(t247, t248); // Eval big_Q step + (coeff_70 * z^70)
    let t250 = circuit_mul(in91, t69); // Eval big_Q step coeff_71 * z^71
    let t251 = circuit_add(t249, t250); // Eval big_Q step + (coeff_71 * z^71)
    let t252 = circuit_mul(in92, t70); // Eval big_Q step coeff_72 * z^72
    let t253 = circuit_add(t251, t252); // Eval big_Q step + (coeff_72 * z^72)
    let t254 = circuit_mul(in93, t71); // Eval big_Q step coeff_73 * z^73
    let t255 = circuit_add(t253, t254); // Eval big_Q step + (coeff_73 * z^73)
    let t256 = circuit_mul(in94, t72); // Eval big_Q step coeff_74 * z^74
    let t257 = circuit_add(t255, t256); // Eval big_Q step + (coeff_74 * z^74)
    let t258 = circuit_mul(in95, t73); // Eval big_Q step coeff_75 * z^75
    let t259 = circuit_add(t257, t258); // Eval big_Q step + (coeff_75 * z^75)
    let t260 = circuit_mul(in96, t74); // Eval big_Q step coeff_76 * z^76
    let t261 = circuit_add(t259, t260); // Eval big_Q step + (coeff_76 * z^76)
    let t262 = circuit_mul(in97, t75); // Eval big_Q step coeff_77 * z^77
    let t263 = circuit_add(t261, t262); // Eval big_Q step + (coeff_77 * z^77)
    let t264 = circuit_mul(in98, t76); // Eval big_Q step coeff_78 * z^78
    let t265 = circuit_add(t263, t264); // Eval big_Q step + (coeff_78 * z^78)
    let t266 = circuit_mul(in99, t77); // Eval big_Q step coeff_79 * z^79
    let t267 = circuit_add(t265, t266); // Eval big_Q step + (coeff_79 * z^79)
    let t268 = circuit_mul(in100, t78); // Eval big_Q step coeff_80 * z^80
    let t269 = circuit_add(t267, t268); // Eval big_Q step + (coeff_80 * z^80)
    let t270 = circuit_mul(t269, t109); // Q(z) * P(z)
    let t271 = circuit_sub(t106, t270); // final_lhs - Q(z) * P(z)

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

    let mut circuit_inputs = (t271,).new_inputs();
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
    let final_check: u384 = outputs.get_output(t271);
    return (final_check,);
}
fn run_BLS12_381_MP_CHECK_INIT_BIT_2_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    Q_0: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q_1: G2Point,
    R_i: E12D,
    c0: u384,
    z: u384,
    c_inv_of_z: u384
) -> (G2Point, G2Point, u384, u384) {
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
    let in29 = CE::<CI<29>> {};
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
    let t10 = circuit_mul(in16, in28); // Eval R step coeff_1 * z^1
    let t11 = circuit_add(in15, t10); // Eval R step + (coeff_1 * z^1)
    let t12 = circuit_mul(in17, t0); // Eval R step coeff_2 * z^2
    let t13 = circuit_add(t11, t12); // Eval R step + (coeff_2 * z^2)
    let t14 = circuit_mul(in18, t1); // Eval R step coeff_3 * z^3
    let t15 = circuit_add(t13, t14); // Eval R step + (coeff_3 * z^3)
    let t16 = circuit_mul(in19, t2); // Eval R step coeff_4 * z^4
    let t17 = circuit_add(t15, t16); // Eval R step + (coeff_4 * z^4)
    let t18 = circuit_mul(in20, t3); // Eval R step coeff_5 * z^5
    let t19 = circuit_add(t17, t18); // Eval R step + (coeff_5 * z^5)
    let t20 = circuit_mul(in21, t4); // Eval R step coeff_6 * z^6
    let t21 = circuit_add(t19, t20); // Eval R step + (coeff_6 * z^6)
    let t22 = circuit_mul(in22, t5); // Eval R step coeff_7 * z^7
    let t23 = circuit_add(t21, t22); // Eval R step + (coeff_7 * z^7)
    let t24 = circuit_mul(in23, t6); // Eval R step coeff_8 * z^8
    let t25 = circuit_add(t23, t24); // Eval R step + (coeff_8 * z^8)
    let t26 = circuit_mul(in24, t7); // Eval R step coeff_9 * z^9
    let t27 = circuit_add(t25, t26); // Eval R step + (coeff_9 * z^9)
    let t28 = circuit_mul(in25, t8); // Eval R step coeff_10 * z^10
    let t29 = circuit_add(t27, t28); // Eval R step + (coeff_10 * z^10)
    let t30 = circuit_mul(in26, t9); // Eval R step coeff_11 * z^11
    let t31 = circuit_add(t29, t30); // Eval R step + (coeff_11 * z^11)
    let t32 = circuit_mul(in29, in29);
    let t33 = circuit_mul(in29, t32);
    let t34 = circuit_add(in5, in6);
    let t35 = circuit_sub(in5, in6);
    let t36 = circuit_mul(t34, t35);
    let t37 = circuit_mul(in5, in6);
    let t38 = circuit_mul(t36, in0);
    let t39 = circuit_mul(t37, in1);
    let t40 = circuit_add(in7, in7); // Fp2 add coeff 0/1
    let t41 = circuit_add(in8, in8); // Fp2 add coeff 1/1
    let t42 = circuit_mul(t40, t40); // Fp2 Div x/y start : Fp2 Inv y start
    let t43 = circuit_mul(t41, t41);
    let t44 = circuit_add(t42, t43);
    let t45 = circuit_inverse(t44);
    let t46 = circuit_mul(t40, t45); // Fp2 Inv y real part end
    let t47 = circuit_mul(t41, t45);
    let t48 = circuit_sub(in2, t47); // Fp2 Inv y imag part end
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
    let t63 = circuit_add(t51, t54);
    let t64 = circuit_sub(t51, t54);
    let t65 = circuit_mul(t63, t64);
    let t66 = circuit_mul(t51, t54);
    let t67 = circuit_add(t66, t66);
    let t68 = circuit_add(in5, in5); // Fp2 add coeff 0/1
    let t69 = circuit_add(in6, in6); // Fp2 add coeff 1/1
    let t70 = circuit_sub(t65, t68); // Fp2 sub coeff 0/1
    let t71 = circuit_sub(t67, t69); // Fp2 sub coeff 1/1
    let t72 = circuit_sub(in5, t70); // Fp2 sub coeff 0/1
    let t73 = circuit_sub(in6, t71); // Fp2 sub coeff 1/1
    let t74 = circuit_mul(t72, t72); // Fp2 Div x/y start : Fp2 Inv y start
    let t75 = circuit_mul(t73, t73);
    let t76 = circuit_add(t74, t75);
    let t77 = circuit_inverse(t76);
    let t78 = circuit_mul(t72, t77); // Fp2 Inv y real part end
    let t79 = circuit_mul(t73, t77);
    let t80 = circuit_sub(in2, t79); // Fp2 Inv y imag part end
    let t81 = circuit_mul(t40, t78); // Fp2 mul start
    let t82 = circuit_mul(t41, t80);
    let t83 = circuit_sub(t81, t82); // Fp2 mul real part end
    let t84 = circuit_mul(t40, t80);
    let t85 = circuit_mul(t41, t78);
    let t86 = circuit_add(t84, t85); // Fp2 mul imag part end
    let t87 = circuit_sub(t83, t51); // Fp2 sub coeff 0/1
    let t88 = circuit_sub(t86, t54); // Fp2 sub coeff 1/1
    let t89 = circuit_mul(t87, in5); // Fp2 mul start
    let t90 = circuit_mul(t88, in6);
    let t91 = circuit_sub(t89, t90); // Fp2 mul real part end
    let t92 = circuit_mul(t87, in6);
    let t93 = circuit_mul(t88, in5);
    let t94 = circuit_add(t92, t93); // Fp2 mul imag part end
    let t95 = circuit_sub(t91, in7); // Fp2 sub coeff 0/1
    let t96 = circuit_sub(t94, in8); // Fp2 sub coeff 1/1
    let t97 = circuit_add(t87, t88);
    let t98 = circuit_sub(t87, t88);
    let t99 = circuit_mul(t97, t98);
    let t100 = circuit_mul(t87, t88);
    let t101 = circuit_add(t100, t100);
    let t102 = circuit_add(in5, t70); // Fp2 add coeff 0/1
    let t103 = circuit_add(in6, t71); // Fp2 add coeff 1/1
    let t104 = circuit_sub(t99, t102); // Fp2 sub coeff 0/1
    let t105 = circuit_sub(t101, t103); // Fp2 sub coeff 1/1
    let t106 = circuit_sub(in5, t104); // Fp2 sub coeff 0/1
    let t107 = circuit_sub(in6, t105); // Fp2 sub coeff 1/1
    let t108 = circuit_mul(t87, t106); // Fp2 mul start
    let t109 = circuit_mul(t88, t107);
    let t110 = circuit_sub(t108, t109); // Fp2 mul real part end
    let t111 = circuit_mul(t87, t107);
    let t112 = circuit_mul(t88, t106);
    let t113 = circuit_add(t111, t112); // Fp2 mul imag part end
    let t114 = circuit_sub(t110, in7); // Fp2 sub coeff 0/1
    let t115 = circuit_sub(t113, in8); // Fp2 sub coeff 1/1
    let t116 = circuit_sub(t61, t62);
    let t117 = circuit_mul(t116, in3);
    let t118 = circuit_sub(t51, t54);
    let t119 = circuit_mul(t118, in4);
    let t120 = circuit_mul(t62, in3);
    let t121 = circuit_mul(t54, in4);
    let t122 = circuit_sub(t95, t96);
    let t123 = circuit_mul(t122, in3);
    let t124 = circuit_sub(t87, t88);
    let t125 = circuit_mul(t124, in4);
    let t126 = circuit_mul(t96, in3);
    let t127 = circuit_mul(t88, in4);
    let t128 = circuit_mul(t119, t0); // Eval sparse poly line_0p_1 step coeff_2 * z^2
    let t129 = circuit_add(t117, t128); // Eval sparse poly line_0p_1 step + coeff_2 * z^2
    let t130 = circuit_add(t129, t1); // Eval sparse poly line_0p_1 step + 1*z^3
    let t131 = circuit_mul(t120, t4); // Eval sparse poly line_0p_1 step coeff_6 * z^6
    let t132 = circuit_add(t130, t131); // Eval sparse poly line_0p_1 step + coeff_6 * z^6
    let t133 = circuit_mul(t121, t6); // Eval sparse poly line_0p_1 step coeff_8 * z^8
    let t134 = circuit_add(t132, t133); // Eval sparse poly line_0p_1 step + coeff_8 * z^8
    let t135 = circuit_mul(t33, t134);
    let t136 = circuit_mul(t125, t0); // Eval sparse poly line_0p_2 step coeff_2 * z^2
    let t137 = circuit_add(t123, t136); // Eval sparse poly line_0p_2 step + coeff_2 * z^2
    let t138 = circuit_add(t137, t1); // Eval sparse poly line_0p_2 step + 1*z^3
    let t139 = circuit_mul(t126, t4); // Eval sparse poly line_0p_2 step coeff_6 * z^6
    let t140 = circuit_add(t138, t139); // Eval sparse poly line_0p_2 step + coeff_6 * z^6
    let t141 = circuit_mul(t127, t6); // Eval sparse poly line_0p_2 step coeff_8 * z^8
    let t142 = circuit_add(t140, t141); // Eval sparse poly line_0p_2 step + coeff_8 * z^8
    let t143 = circuit_mul(t135, t142);
    let t144 = circuit_add(in11, in12);
    let t145 = circuit_sub(in11, in12);
    let t146 = circuit_mul(t144, t145);
    let t147 = circuit_mul(in11, in12);
    let t148 = circuit_mul(t146, in0);
    let t149 = circuit_mul(t147, in1);
    let t150 = circuit_add(in13, in13); // Fp2 add coeff 0/1
    let t151 = circuit_add(in14, in14); // Fp2 add coeff 1/1
    let t152 = circuit_mul(t150, t150); // Fp2 Div x/y start : Fp2 Inv y start
    let t153 = circuit_mul(t151, t151);
    let t154 = circuit_add(t152, t153);
    let t155 = circuit_inverse(t154);
    let t156 = circuit_mul(t150, t155); // Fp2 Inv y real part end
    let t157 = circuit_mul(t151, t155);
    let t158 = circuit_sub(in2, t157); // Fp2 Inv y imag part end
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
    let t173 = circuit_add(t161, t164);
    let t174 = circuit_sub(t161, t164);
    let t175 = circuit_mul(t173, t174);
    let t176 = circuit_mul(t161, t164);
    let t177 = circuit_add(t176, t176);
    let t178 = circuit_add(in11, in11); // Fp2 add coeff 0/1
    let t179 = circuit_add(in12, in12); // Fp2 add coeff 1/1
    let t180 = circuit_sub(t175, t178); // Fp2 sub coeff 0/1
    let t181 = circuit_sub(t177, t179); // Fp2 sub coeff 1/1
    let t182 = circuit_sub(in11, t180); // Fp2 sub coeff 0/1
    let t183 = circuit_sub(in12, t181); // Fp2 sub coeff 1/1
    let t184 = circuit_mul(t182, t182); // Fp2 Div x/y start : Fp2 Inv y start
    let t185 = circuit_mul(t183, t183);
    let t186 = circuit_add(t184, t185);
    let t187 = circuit_inverse(t186);
    let t188 = circuit_mul(t182, t187); // Fp2 Inv y real part end
    let t189 = circuit_mul(t183, t187);
    let t190 = circuit_sub(in2, t189); // Fp2 Inv y imag part end
    let t191 = circuit_mul(t150, t188); // Fp2 mul start
    let t192 = circuit_mul(t151, t190);
    let t193 = circuit_sub(t191, t192); // Fp2 mul real part end
    let t194 = circuit_mul(t150, t190);
    let t195 = circuit_mul(t151, t188);
    let t196 = circuit_add(t194, t195); // Fp2 mul imag part end
    let t197 = circuit_sub(t193, t161); // Fp2 sub coeff 0/1
    let t198 = circuit_sub(t196, t164); // Fp2 sub coeff 1/1
    let t199 = circuit_mul(t197, in11); // Fp2 mul start
    let t200 = circuit_mul(t198, in12);
    let t201 = circuit_sub(t199, t200); // Fp2 mul real part end
    let t202 = circuit_mul(t197, in12);
    let t203 = circuit_mul(t198, in11);
    let t204 = circuit_add(t202, t203); // Fp2 mul imag part end
    let t205 = circuit_sub(t201, in13); // Fp2 sub coeff 0/1
    let t206 = circuit_sub(t204, in14); // Fp2 sub coeff 1/1
    let t207 = circuit_add(t197, t198);
    let t208 = circuit_sub(t197, t198);
    let t209 = circuit_mul(t207, t208);
    let t210 = circuit_mul(t197, t198);
    let t211 = circuit_add(t210, t210);
    let t212 = circuit_add(in11, t180); // Fp2 add coeff 0/1
    let t213 = circuit_add(in12, t181); // Fp2 add coeff 1/1
    let t214 = circuit_sub(t209, t212); // Fp2 sub coeff 0/1
    let t215 = circuit_sub(t211, t213); // Fp2 sub coeff 1/1
    let t216 = circuit_sub(in11, t214); // Fp2 sub coeff 0/1
    let t217 = circuit_sub(in12, t215); // Fp2 sub coeff 1/1
    let t218 = circuit_mul(t197, t216); // Fp2 mul start
    let t219 = circuit_mul(t198, t217);
    let t220 = circuit_sub(t218, t219); // Fp2 mul real part end
    let t221 = circuit_mul(t197, t217);
    let t222 = circuit_mul(t198, t216);
    let t223 = circuit_add(t221, t222); // Fp2 mul imag part end
    let t224 = circuit_sub(t220, in13); // Fp2 sub coeff 0/1
    let t225 = circuit_sub(t223, in14); // Fp2 sub coeff 1/1
    let t226 = circuit_sub(t171, t172);
    let t227 = circuit_mul(t226, in9);
    let t228 = circuit_sub(t161, t164);
    let t229 = circuit_mul(t228, in10);
    let t230 = circuit_mul(t172, in9);
    let t231 = circuit_mul(t164, in10);
    let t232 = circuit_sub(t205, t206);
    let t233 = circuit_mul(t232, in9);
    let t234 = circuit_sub(t197, t198);
    let t235 = circuit_mul(t234, in10);
    let t236 = circuit_mul(t206, in9);
    let t237 = circuit_mul(t198, in10);
    let t238 = circuit_mul(t229, t0); // Eval sparse poly line_1p_1 step coeff_2 * z^2
    let t239 = circuit_add(t227, t238); // Eval sparse poly line_1p_1 step + coeff_2 * z^2
    let t240 = circuit_add(t239, t1); // Eval sparse poly line_1p_1 step + 1*z^3
    let t241 = circuit_mul(t230, t4); // Eval sparse poly line_1p_1 step coeff_6 * z^6
    let t242 = circuit_add(t240, t241); // Eval sparse poly line_1p_1 step + coeff_6 * z^6
    let t243 = circuit_mul(t231, t6); // Eval sparse poly line_1p_1 step coeff_8 * z^8
    let t244 = circuit_add(t242, t243); // Eval sparse poly line_1p_1 step + coeff_8 * z^8
    let t245 = circuit_mul(t143, t244);
    let t246 = circuit_mul(t235, t0); // Eval sparse poly line_1p_2 step coeff_2 * z^2
    let t247 = circuit_add(t233, t246); // Eval sparse poly line_1p_2 step + coeff_2 * z^2
    let t248 = circuit_add(t247, t1); // Eval sparse poly line_1p_2 step + 1*z^3
    let t249 = circuit_mul(t236, t4); // Eval sparse poly line_1p_2 step coeff_6 * z^6
    let t250 = circuit_add(t248, t249); // Eval sparse poly line_1p_2 step + coeff_6 * z^6
    let t251 = circuit_mul(t237, t6); // Eval sparse poly line_1p_2 step coeff_8 * z^8
    let t252 = circuit_add(t250, t251); // Eval sparse poly line_1p_2 step + coeff_8 * z^8
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

    let mut circuit_inputs = (t104, t105, t114, t115, t214, t215, t224, t225, t255, t31,)
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x6, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(Q_0.x0);
    circuit_inputs = circuit_inputs.next(Q_0.x1);
    circuit_inputs = circuit_inputs.next(Q_0.y0);
    circuit_inputs = circuit_inputs.next(Q_0.y1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(Q_1.x0);
    circuit_inputs = circuit_inputs.next(Q_1.x1);
    circuit_inputs = circuit_inputs.next(Q_1.y0);
    circuit_inputs = circuit_inputs.next(Q_1.y1);
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
        x0: outputs.get_output(t104),
        x1: outputs.get_output(t105),
        y0: outputs.get_output(t114),
        y1: outputs.get_output(t115)
    };
    let Q1: G2Point = G2Point {
        x0: outputs.get_output(t214),
        x1: outputs.get_output(t215),
        y0: outputs.get_output(t224),
        y1: outputs.get_output(t225)
    };
    let new_lhs: u384 = outputs.get_output(t255);
    let f_i_plus_one_of_z: u384 = outputs.get_output(t31);
    return (Q0, Q1, new_lhs, f_i_plus_one_of_z);
}
fn run_BLS12_381_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit(
    lambda_root_inverse: E12D, z: u384, scaling_factor: MillerLoopResultScalingFactor
) -> (u384, u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0
    let in1 = CE::<CI<1>> {}; // 0x2
    let in2 = CE::<
        CI<2>
    > {}; // 0x18089593cbf626353947d5b1fd0c6d66bb34bc7585f5abdf8f17b50e12c47d65ce514a7c167b027b600febdb244714c5
    let in3 = CE::<
        CI<3>
    > {}; // 0x5f19672fdf76ce51ba69c6076a0f77eaddb3a93be6f89688de17d813620a00022e01fffffffeffff
    let in4 = CE::<
        CI<4>
    > {}; // 0xd5e1c086ffe8016d063c6dad7a2fffc9072bb5785a686bcefeedc2e0124838bdccf325ee5d80be9902109f7dbc79812
    let in5 = CE::<
        CI<5>
    > {}; // 0x1a0111ea397fe699ec02408663d4de85aa0d857d89759ad4897d29650fb85f9b409427eb4f49fffd8bfd00000000aaad
    let in6 = CE::<
        CI<6>
    > {}; // 0x1a0111ea397fe6998ce8d956845e1033efa3bf761f6622e9abc9802928bfc912627c4fd7ed3ffffb5dfb00000001aaaf
    let in7 = CE::<
        CI<7>
    > {}; // 0xb659fb20274bfb1be8ff4d69163c08be7302c4818171fdd17d5be9b1d380acd8c747cdc4aff0e653631f5d3000f022c
    let in8 = CE::<CI<8>> {}; // -0x1 % p
    let in9 = CE::<
        CI<9>
    > {}; // 0xfc3e2b36c4e03288e9e902231f9fb854a14787b6c7b36fec0c8ec971f63c5f282d5ac14d6c7ec22cf78a126ddc4af3
    let in10 = CE::<
        CI<10>
    > {}; // 0x1f87c566d89c06511d3d204463f3f70a9428f0f6d8f66dfd8191d92e3ec78be505ab5829ad8fd8459ef1424dbb895e6
    let in11 = CE::<
        CI<11>
    > {}; // 0x1a0111ea397fe699ec02408663d4de85aa0d857d89759ad4897d29650fb85f9b409427eb4f49fffd8bfd00000000aaac
    let in12 = CE::<
        CI<12>
    > {}; // 0x6af0e0437ff400b6831e36d6bd17ffe48395dabc2d3435e77f76e17009241c5ee67992f72ec05f4c81084fbede3cc09
    let in13 = CE::<
        CI<13>
    > {}; // 0x5f19672fdf76ce51ba69c6076a0f77eaddb3a93be6f89688de17d813620a00022e01fffffffefffe
    let in14 = CE::<
        CI<14>
    > {}; // 0x144e4211384586c16bd3ad4afa99cc9170df3560e77982d0db45f3536814f0bd5871c1908bd478cd1ee605167ff82995
    let in15 = CE::<
        CI<15>
    > {}; // 0xe9b7238370b26e88c8bb2dfb1e7ec4b7d471f3cdb6df2e24f5b1405d978eb56923783226654f19a83cd0a2cfff0a87f

    // INPUT stack
    let (in16, in17) = (CE::<CI<16>> {}, CE::<CI<17>> {});
    let (in18, in19) = (CE::<CI<18>> {}, CE::<CI<19>> {});
    let (in20, in21) = (CE::<CI<20>> {}, CE::<CI<21>> {});
    let (in22, in23) = (CE::<CI<22>> {}, CE::<CI<23>> {});
    let (in24, in25) = (CE::<CI<24>> {}, CE::<CI<25>> {});
    let (in26, in27) = (CE::<CI<26>> {}, CE::<CI<27>> {});
    let (in28, in29) = (CE::<CI<28>> {}, CE::<CI<29>> {});
    let (in30, in31) = (CE::<CI<30>> {}, CE::<CI<31>> {});
    let (in32, in33) = (CE::<CI<32>> {}, CE::<CI<33>> {});
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
    let t73 = circuit_mul(t52, in28); // Eval C_inv_frob_1 step coeff_1 * z^1
    let t74 = circuit_add(t49, t73); // Eval C_inv_frob_1 step + (coeff_1 * z^1)
    let t75 = circuit_mul(t53, t0); // Eval C_inv_frob_1 step coeff_2 * z^2
    let t76 = circuit_add(t74, t75); // Eval C_inv_frob_1 step + (coeff_2 * z^2)
    let t77 = circuit_mul(t54, t1); // Eval C_inv_frob_1 step coeff_3 * z^3
    let t78 = circuit_add(t76, t77); // Eval C_inv_frob_1 step + (coeff_3 * z^3)
    let t79 = circuit_mul(t57, t2); // Eval C_inv_frob_1 step coeff_4 * z^4
    let t80 = circuit_add(t78, t79); // Eval C_inv_frob_1 step + (coeff_4 * z^4)
    let t81 = circuit_mul(t60, t3); // Eval C_inv_frob_1 step coeff_5 * z^5
    let t82 = circuit_add(t80, t81); // Eval C_inv_frob_1 step + (coeff_5 * z^5)
    let t83 = circuit_mul(t61, t4); // Eval C_inv_frob_1 step coeff_6 * z^6
    let t84 = circuit_add(t82, t83); // Eval C_inv_frob_1 step + (coeff_6 * z^6)
    let t85 = circuit_mul(t64, t5); // Eval C_inv_frob_1 step coeff_7 * z^7
    let t86 = circuit_add(t84, t85); // Eval C_inv_frob_1 step + (coeff_7 * z^7)
    let t87 = circuit_mul(t67, t6); // Eval C_inv_frob_1 step coeff_8 * z^8
    let t88 = circuit_add(t86, t87); // Eval C_inv_frob_1 step + (coeff_8 * z^8)
    let t89 = circuit_mul(t68, t7); // Eval C_inv_frob_1 step coeff_9 * z^9
    let t90 = circuit_add(t88, t89); // Eval C_inv_frob_1 step + (coeff_9 * z^9)
    let t91 = circuit_mul(t69, t8); // Eval C_inv_frob_1 step coeff_10 * z^10
    let t92 = circuit_add(t90, t91); // Eval C_inv_frob_1 step + (coeff_10 * z^10)
    let t93 = circuit_mul(t72, t9); // Eval C_inv_frob_1 step coeff_11 * z^11
    let t94 = circuit_add(t92, t93); // Eval C_inv_frob_1 step + (coeff_11 * z^11)

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
    let in0 = CE::<CI<0>> {}; // 0x0

    // INPUT stack
    let (in1, in2) = (CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4) = (CE::<CI<3>> {}, CE::<CI<4>> {});
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
    let in0 = CE::<CI<0>> {}; // 0x0

    // INPUT stack
    let (in1, in2) = (CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4) = (CE::<CI<3>> {}, CE::<CI<4>> {});
    let (in5, in6) = (CE::<CI<5>> {}, CE::<CI<6>> {});
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
fn run_BN254_MP_CHECK_BIT00_LOOP_2_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    Q_0: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q_1: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one: E12D,
    z: u384,
    ci: u384
) -> (G2Point, G2Point, u384, u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x3
    let in1 = CE::<CI<1>> {}; // 0x6
    let in2 = CE::<CI<2>> {}; // 0x0
    let in3 = CE::<CI<3>> {}; // -0x9 % p
    let in4 = CE::<CI<4>> {}; // 0x1

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
    let t0 = circuit_mul(in31, in31); // Compute z^2
    let t1 = circuit_mul(t0, in31); // Compute z^3
    let t2 = circuit_mul(t1, in31); // Compute z^4
    let t3 = circuit_mul(t2, in31); // Compute z^5
    let t4 = circuit_mul(t3, in31); // Compute z^6
    let t5 = circuit_mul(t4, in31); // Compute z^7
    let t6 = circuit_mul(t5, in31); // Compute z^8
    let t7 = circuit_mul(t6, in31); // Compute z^9
    let t8 = circuit_mul(t7, in31); // Compute z^10
    let t9 = circuit_mul(t8, in31); // Compute z^11
    let t10 = circuit_mul(in32, in32); // Compute c_i = (c_(i-1))^2
    let t11 = circuit_mul(in18, in18); // Square f evaluation in Z, the result of previous bit.
    let t12 = circuit_add(in7, in8); // Doubling slope numerator start
    let t13 = circuit_sub(in7, in8);
    let t14 = circuit_mul(t12, t13);
    let t15 = circuit_mul(in7, in8);
    let t16 = circuit_mul(t14, in0);
    let t17 = circuit_mul(t15, in1); // Doubling slope numerator end
    let t18 = circuit_add(in9, in9); // Fp2 add coeff 0/1
    let t19 = circuit_add(in10, in10); // Fp2 add coeff 1/1
    let t20 = circuit_mul(t18, t18); // Fp2 Div x/y start : Fp2 Inv y start
    let t21 = circuit_mul(t19, t19);
    let t22 = circuit_add(t20, t21);
    let t23 = circuit_inverse(t22);
    let t24 = circuit_mul(t18, t23); // Fp2 Inv y real part end
    let t25 = circuit_mul(t19, t23);
    let t26 = circuit_sub(in2, t25); // Fp2 Inv y imag part end
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
    let t68 = circuit_mul(t62, in31); // Eval sparse poly line_0p_1 step coeff_1 * z^1
    let t69 = circuit_add(in4, t68); // Eval sparse poly line_0p_1 step + coeff_1 * z^1
    let t70 = circuit_mul(t65, t1); // Eval sparse poly line_0p_1 step coeff_3 * z^3
    let t71 = circuit_add(t69, t70); // Eval sparse poly line_0p_1 step + coeff_3 * z^3
    let t72 = circuit_mul(t66, t5); // Eval sparse poly line_0p_1 step coeff_7 * z^7
    let t73 = circuit_add(t71, t72); // Eval sparse poly line_0p_1 step + coeff_7 * z^7
    let t74 = circuit_mul(t67, t7); // Eval sparse poly line_0p_1 step coeff_9 * z^9
    let t75 = circuit_add(t73, t74); // Eval sparse poly line_0p_1 step + coeff_9 * z^9
    let t76 = circuit_mul(t11, t75); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t77 = circuit_add(in13, in14); // Doubling slope numerator start
    let t78 = circuit_sub(in13, in14);
    let t79 = circuit_mul(t77, t78);
    let t80 = circuit_mul(in13, in14);
    let t81 = circuit_mul(t79, in0);
    let t82 = circuit_mul(t80, in1); // Doubling slope numerator end
    let t83 = circuit_add(in15, in15); // Fp2 add coeff 0/1
    let t84 = circuit_add(in16, in16); // Fp2 add coeff 1/1
    let t85 = circuit_mul(t83, t83); // Fp2 Div x/y start : Fp2 Inv y start
    let t86 = circuit_mul(t84, t84);
    let t87 = circuit_add(t85, t86);
    let t88 = circuit_inverse(t87);
    let t89 = circuit_mul(t83, t88); // Fp2 Inv y real part end
    let t90 = circuit_mul(t84, t88);
    let t91 = circuit_sub(in2, t90); // Fp2 Inv y imag part end
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
    let t133 = circuit_mul(t127, in31); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t134 = circuit_add(in4, t133); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t135 = circuit_mul(t130, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t136 = circuit_add(t134, t135); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t137 = circuit_mul(t131, t5); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t138 = circuit_add(t136, t137); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t139 = circuit_mul(t132, t7); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t140 = circuit_add(t138, t139); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t141 = circuit_mul(t76, t140); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t142 = circuit_mul(
        t141, t141
    ); // Compute (f^2 * Π(i,k) (line_i,k(z))) ^ 2 = f^4 * (Π(i,k) (line_i,k(z)))^2
    let t143 = circuit_add(t40, t41); // Doubling slope numerator start
    let t144 = circuit_sub(t40, t41);
    let t145 = circuit_mul(t143, t144);
    let t146 = circuit_mul(t40, t41);
    let t147 = circuit_mul(t145, in0);
    let t148 = circuit_mul(t146, in1); // Doubling slope numerator end
    let t149 = circuit_add(t50, t50); // Fp2 add coeff 0/1
    let t150 = circuit_add(t51, t51); // Fp2 add coeff 1/1
    let t151 = circuit_mul(t149, t149); // Fp2 Div x/y start : Fp2 Inv y start
    let t152 = circuit_mul(t150, t150);
    let t153 = circuit_add(t151, t152);
    let t154 = circuit_inverse(t153);
    let t155 = circuit_mul(t149, t154); // Fp2 Inv y real part end
    let t156 = circuit_mul(t150, t154);
    let t157 = circuit_sub(in2, t156); // Fp2 Inv y imag part end
    let t158 = circuit_mul(t147, t155); // Fp2 mul start
    let t159 = circuit_mul(t148, t157);
    let t160 = circuit_sub(t158, t159); // Fp2 mul real part end
    let t161 = circuit_mul(t147, t157);
    let t162 = circuit_mul(t148, t155);
    let t163 = circuit_add(t161, t162); // Fp2 mul imag part end
    let t164 = circuit_add(t160, t163);
    let t165 = circuit_sub(t160, t163);
    let t166 = circuit_mul(t164, t165);
    let t167 = circuit_mul(t160, t163);
    let t168 = circuit_add(t167, t167);
    let t169 = circuit_add(t40, t40); // Fp2 add coeff 0/1
    let t170 = circuit_add(t41, t41); // Fp2 add coeff 1/1
    let t171 = circuit_sub(t166, t169); // Fp2 sub coeff 0/1
    let t172 = circuit_sub(t168, t170); // Fp2 sub coeff 1/1
    let t173 = circuit_sub(t40, t171); // Fp2 sub coeff 0/1
    let t174 = circuit_sub(t41, t172); // Fp2 sub coeff 1/1
    let t175 = circuit_mul(t160, t173); // Fp2 mul start
    let t176 = circuit_mul(t163, t174);
    let t177 = circuit_sub(t175, t176); // Fp2 mul real part end
    let t178 = circuit_mul(t160, t174);
    let t179 = circuit_mul(t163, t173);
    let t180 = circuit_add(t178, t179); // Fp2 mul imag part end
    let t181 = circuit_sub(t177, t50); // Fp2 sub coeff 0/1
    let t182 = circuit_sub(t180, t51); // Fp2 sub coeff 1/1
    let t183 = circuit_mul(t160, t40); // Fp2 mul start
    let t184 = circuit_mul(t163, t41);
    let t185 = circuit_sub(t183, t184); // Fp2 mul real part end
    let t186 = circuit_mul(t160, t41);
    let t187 = circuit_mul(t163, t40);
    let t188 = circuit_add(t186, t187); // Fp2 mul imag part end
    let t189 = circuit_sub(t185, t50); // Fp2 sub coeff 0/1
    let t190 = circuit_sub(t188, t51); // Fp2 sub coeff 1/1
    let t191 = circuit_mul(in3, t163);
    let t192 = circuit_add(t160, t191);
    let t193 = circuit_mul(t192, in6);
    let t194 = circuit_mul(in3, t190);
    let t195 = circuit_add(t189, t194);
    let t196 = circuit_mul(t195, in5);
    let t197 = circuit_mul(t163, in6);
    let t198 = circuit_mul(t190, in5);
    let t199 = circuit_mul(t193, in31); // Eval sparse poly line_0p_1 step coeff_1 * z^1
    let t200 = circuit_add(in4, t199); // Eval sparse poly line_0p_1 step + coeff_1 * z^1
    let t201 = circuit_mul(t196, t1); // Eval sparse poly line_0p_1 step coeff_3 * z^3
    let t202 = circuit_add(t200, t201); // Eval sparse poly line_0p_1 step + coeff_3 * z^3
    let t203 = circuit_mul(t197, t5); // Eval sparse poly line_0p_1 step coeff_7 * z^7
    let t204 = circuit_add(t202, t203); // Eval sparse poly line_0p_1 step + coeff_7 * z^7
    let t205 = circuit_mul(t198, t7); // Eval sparse poly line_0p_1 step coeff_9 * z^9
    let t206 = circuit_add(t204, t205); // Eval sparse poly line_0p_1 step + coeff_9 * z^9
    let t207 = circuit_mul(t142, t206); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t208 = circuit_add(t105, t106); // Doubling slope numerator start
    let t209 = circuit_sub(t105, t106);
    let t210 = circuit_mul(t208, t209);
    let t211 = circuit_mul(t105, t106);
    let t212 = circuit_mul(t210, in0);
    let t213 = circuit_mul(t211, in1); // Doubling slope numerator end
    let t214 = circuit_add(t115, t115); // Fp2 add coeff 0/1
    let t215 = circuit_add(t116, t116); // Fp2 add coeff 1/1
    let t216 = circuit_mul(t214, t214); // Fp2 Div x/y start : Fp2 Inv y start
    let t217 = circuit_mul(t215, t215);
    let t218 = circuit_add(t216, t217);
    let t219 = circuit_inverse(t218);
    let t220 = circuit_mul(t214, t219); // Fp2 Inv y real part end
    let t221 = circuit_mul(t215, t219);
    let t222 = circuit_sub(in2, t221); // Fp2 Inv y imag part end
    let t223 = circuit_mul(t212, t220); // Fp2 mul start
    let t224 = circuit_mul(t213, t222);
    let t225 = circuit_sub(t223, t224); // Fp2 mul real part end
    let t226 = circuit_mul(t212, t222);
    let t227 = circuit_mul(t213, t220);
    let t228 = circuit_add(t226, t227); // Fp2 mul imag part end
    let t229 = circuit_add(t225, t228);
    let t230 = circuit_sub(t225, t228);
    let t231 = circuit_mul(t229, t230);
    let t232 = circuit_mul(t225, t228);
    let t233 = circuit_add(t232, t232);
    let t234 = circuit_add(t105, t105); // Fp2 add coeff 0/1
    let t235 = circuit_add(t106, t106); // Fp2 add coeff 1/1
    let t236 = circuit_sub(t231, t234); // Fp2 sub coeff 0/1
    let t237 = circuit_sub(t233, t235); // Fp2 sub coeff 1/1
    let t238 = circuit_sub(t105, t236); // Fp2 sub coeff 0/1
    let t239 = circuit_sub(t106, t237); // Fp2 sub coeff 1/1
    let t240 = circuit_mul(t225, t238); // Fp2 mul start
    let t241 = circuit_mul(t228, t239);
    let t242 = circuit_sub(t240, t241); // Fp2 mul real part end
    let t243 = circuit_mul(t225, t239);
    let t244 = circuit_mul(t228, t238);
    let t245 = circuit_add(t243, t244); // Fp2 mul imag part end
    let t246 = circuit_sub(t242, t115); // Fp2 sub coeff 0/1
    let t247 = circuit_sub(t245, t116); // Fp2 sub coeff 1/1
    let t248 = circuit_mul(t225, t105); // Fp2 mul start
    let t249 = circuit_mul(t228, t106);
    let t250 = circuit_sub(t248, t249); // Fp2 mul real part end
    let t251 = circuit_mul(t225, t106);
    let t252 = circuit_mul(t228, t105);
    let t253 = circuit_add(t251, t252); // Fp2 mul imag part end
    let t254 = circuit_sub(t250, t115); // Fp2 sub coeff 0/1
    let t255 = circuit_sub(t253, t116); // Fp2 sub coeff 1/1
    let t256 = circuit_mul(in3, t228);
    let t257 = circuit_add(t225, t256);
    let t258 = circuit_mul(t257, in12);
    let t259 = circuit_mul(in3, t255);
    let t260 = circuit_add(t254, t259);
    let t261 = circuit_mul(t260, in11);
    let t262 = circuit_mul(t228, in12);
    let t263 = circuit_mul(t255, in11);
    let t264 = circuit_mul(t258, in31); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t265 = circuit_add(in4, t264); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t266 = circuit_mul(t261, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t267 = circuit_add(t265, t266); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t268 = circuit_mul(t262, t5); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t269 = circuit_add(t267, t268); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t270 = circuit_mul(t263, t7); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t271 = circuit_add(t269, t270); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t272 = circuit_mul(t207, t271); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t273 = circuit_mul(in20, in31); // Eval R step coeff_1 * z^1
    let t274 = circuit_add(in19, t273); // Eval R step + (coeff_1 * z^1)
    let t275 = circuit_mul(in21, t0); // Eval R step coeff_2 * z^2
    let t276 = circuit_add(t274, t275); // Eval R step + (coeff_2 * z^2)
    let t277 = circuit_mul(in22, t1); // Eval R step coeff_3 * z^3
    let t278 = circuit_add(t276, t277); // Eval R step + (coeff_3 * z^3)
    let t279 = circuit_mul(in23, t2); // Eval R step coeff_4 * z^4
    let t280 = circuit_add(t278, t279); // Eval R step + (coeff_4 * z^4)
    let t281 = circuit_mul(in24, t3); // Eval R step coeff_5 * z^5
    let t282 = circuit_add(t280, t281); // Eval R step + (coeff_5 * z^5)
    let t283 = circuit_mul(in25, t4); // Eval R step coeff_6 * z^6
    let t284 = circuit_add(t282, t283); // Eval R step + (coeff_6 * z^6)
    let t285 = circuit_mul(in26, t5); // Eval R step coeff_7 * z^7
    let t286 = circuit_add(t284, t285); // Eval R step + (coeff_7 * z^7)
    let t287 = circuit_mul(in27, t6); // Eval R step coeff_8 * z^8
    let t288 = circuit_add(t286, t287); // Eval R step + (coeff_8 * z^8)
    let t289 = circuit_mul(in28, t7); // Eval R step coeff_9 * z^9
    let t290 = circuit_add(t288, t289); // Eval R step + (coeff_9 * z^9)
    let t291 = circuit_mul(in29, t8); // Eval R step coeff_10 * z^10
    let t292 = circuit_add(t290, t291); // Eval R step + (coeff_10 * z^10)
    let t293 = circuit_mul(in30, t9); // Eval R step coeff_11 * z^11
    let t294 = circuit_add(t292, t293); // Eval R step + (coeff_11 * z^11)
    let t295 = circuit_sub(t272, t294); // (Π(i,k) (Pk(z))) - Ri(z)
    let t296 = circuit_mul(t10, t295); // ci * ((Π(i,k) (Pk(z)) - Ri(z))
    let t297 = circuit_add(in17, t296); // LHS = LHS + ci * ((Π(i,k) (Pk(z)) - Ri(z))

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [32324006162389411176778628423, 57042285082623239461879769745, 3486998266802970665, 0]
    )
        .unwrap();

    let mut circuit_inputs = (t171, t172, t181, t182, t236, t237, t246, t247, t294, t297, t10,)
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x6, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x6871ca8d3c208c16d87cfd3e, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0]);
    circuit_inputs = circuit_inputs.next([0x1, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(Q_0.x0);
    circuit_inputs = circuit_inputs.next(Q_0.x1);
    circuit_inputs = circuit_inputs.next(Q_0.y0);
    circuit_inputs = circuit_inputs.next(Q_0.y1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(Q_1.x0);
    circuit_inputs = circuit_inputs.next(Q_1.x1);
    circuit_inputs = circuit_inputs.next(Q_1.y0);
    circuit_inputs = circuit_inputs.next(Q_1.y1);
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
    let Q0: G2Point = G2Point {
        x0: outputs.get_output(t171),
        x1: outputs.get_output(t172),
        y0: outputs.get_output(t181),
        y1: outputs.get_output(t182)
    };
    let Q1: G2Point = G2Point {
        x0: outputs.get_output(t236),
        x1: outputs.get_output(t237),
        y0: outputs.get_output(t246),
        y1: outputs.get_output(t247)
    };
    let f_i_plus_one_of_z: u384 = outputs.get_output(t294);
    let lhs_i_plus_one: u384 = outputs.get_output(t297);
    let ci_plus_one: u384 = outputs.get_output(t10);
    return (Q0, Q1, f_i_plus_one_of_z, lhs_i_plus_one, ci_plus_one);
}
fn run_BN254_MP_CHECK_BIT0_LOOP_2_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    Q_0: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q_1: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one: E12D,
    z: u384,
    ci: u384
) -> (G2Point, G2Point, u384, u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x3
    let in1 = CE::<CI<1>> {}; // 0x6
    let in2 = CE::<CI<2>> {}; // 0x0
    let in3 = CE::<CI<3>> {}; // -0x9 % p
    let in4 = CE::<CI<4>> {}; // 0x1

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
    let t0 = circuit_mul(in31, in31); // Compute z^2
    let t1 = circuit_mul(t0, in31); // Compute z^3
    let t2 = circuit_mul(t1, in31); // Compute z^4
    let t3 = circuit_mul(t2, in31); // Compute z^5
    let t4 = circuit_mul(t3, in31); // Compute z^6
    let t5 = circuit_mul(t4, in31); // Compute z^7
    let t6 = circuit_mul(t5, in31); // Compute z^8
    let t7 = circuit_mul(t6, in31); // Compute z^9
    let t8 = circuit_mul(t7, in31); // Compute z^10
    let t9 = circuit_mul(t8, in31); // Compute z^11
    let t10 = circuit_mul(in32, in32); // Compute c_i = (c_(i-1))^2
    let t11 = circuit_mul(in18, in18); // Square f evaluation in Z, the result of previous bit.
    let t12 = circuit_add(in7, in8); // Doubling slope numerator start
    let t13 = circuit_sub(in7, in8);
    let t14 = circuit_mul(t12, t13);
    let t15 = circuit_mul(in7, in8);
    let t16 = circuit_mul(t14, in0);
    let t17 = circuit_mul(t15, in1); // Doubling slope numerator end
    let t18 = circuit_add(in9, in9); // Fp2 add coeff 0/1
    let t19 = circuit_add(in10, in10); // Fp2 add coeff 1/1
    let t20 = circuit_mul(t18, t18); // Fp2 Div x/y start : Fp2 Inv y start
    let t21 = circuit_mul(t19, t19);
    let t22 = circuit_add(t20, t21);
    let t23 = circuit_inverse(t22);
    let t24 = circuit_mul(t18, t23); // Fp2 Inv y real part end
    let t25 = circuit_mul(t19, t23);
    let t26 = circuit_sub(in2, t25); // Fp2 Inv y imag part end
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
    let t68 = circuit_mul(t62, in31); // Eval sparse poly line_0p_1 step coeff_1 * z^1
    let t69 = circuit_add(in4, t68); // Eval sparse poly line_0p_1 step + coeff_1 * z^1
    let t70 = circuit_mul(t65, t1); // Eval sparse poly line_0p_1 step coeff_3 * z^3
    let t71 = circuit_add(t69, t70); // Eval sparse poly line_0p_1 step + coeff_3 * z^3
    let t72 = circuit_mul(t66, t5); // Eval sparse poly line_0p_1 step coeff_7 * z^7
    let t73 = circuit_add(t71, t72); // Eval sparse poly line_0p_1 step + coeff_7 * z^7
    let t74 = circuit_mul(t67, t7); // Eval sparse poly line_0p_1 step coeff_9 * z^9
    let t75 = circuit_add(t73, t74); // Eval sparse poly line_0p_1 step + coeff_9 * z^9
    let t76 = circuit_mul(t11, t75); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t77 = circuit_add(in13, in14); // Doubling slope numerator start
    let t78 = circuit_sub(in13, in14);
    let t79 = circuit_mul(t77, t78);
    let t80 = circuit_mul(in13, in14);
    let t81 = circuit_mul(t79, in0);
    let t82 = circuit_mul(t80, in1); // Doubling slope numerator end
    let t83 = circuit_add(in15, in15); // Fp2 add coeff 0/1
    let t84 = circuit_add(in16, in16); // Fp2 add coeff 1/1
    let t85 = circuit_mul(t83, t83); // Fp2 Div x/y start : Fp2 Inv y start
    let t86 = circuit_mul(t84, t84);
    let t87 = circuit_add(t85, t86);
    let t88 = circuit_inverse(t87);
    let t89 = circuit_mul(t83, t88); // Fp2 Inv y real part end
    let t90 = circuit_mul(t84, t88);
    let t91 = circuit_sub(in2, t90); // Fp2 Inv y imag part end
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
    let t133 = circuit_mul(t127, in31); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t134 = circuit_add(in4, t133); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t135 = circuit_mul(t130, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t136 = circuit_add(t134, t135); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t137 = circuit_mul(t131, t5); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t138 = circuit_add(t136, t137); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t139 = circuit_mul(t132, t7); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t140 = circuit_add(t138, t139); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t141 = circuit_mul(t76, t140); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t142 = circuit_mul(in20, in31); // Eval R step coeff_1 * z^1
    let t143 = circuit_add(in19, t142); // Eval R step + (coeff_1 * z^1)
    let t144 = circuit_mul(in21, t0); // Eval R step coeff_2 * z^2
    let t145 = circuit_add(t143, t144); // Eval R step + (coeff_2 * z^2)
    let t146 = circuit_mul(in22, t1); // Eval R step coeff_3 * z^3
    let t147 = circuit_add(t145, t146); // Eval R step + (coeff_3 * z^3)
    let t148 = circuit_mul(in23, t2); // Eval R step coeff_4 * z^4
    let t149 = circuit_add(t147, t148); // Eval R step + (coeff_4 * z^4)
    let t150 = circuit_mul(in24, t3); // Eval R step coeff_5 * z^5
    let t151 = circuit_add(t149, t150); // Eval R step + (coeff_5 * z^5)
    let t152 = circuit_mul(in25, t4); // Eval R step coeff_6 * z^6
    let t153 = circuit_add(t151, t152); // Eval R step + (coeff_6 * z^6)
    let t154 = circuit_mul(in26, t5); // Eval R step coeff_7 * z^7
    let t155 = circuit_add(t153, t154); // Eval R step + (coeff_7 * z^7)
    let t156 = circuit_mul(in27, t6); // Eval R step coeff_8 * z^8
    let t157 = circuit_add(t155, t156); // Eval R step + (coeff_8 * z^8)
    let t158 = circuit_mul(in28, t7); // Eval R step coeff_9 * z^9
    let t159 = circuit_add(t157, t158); // Eval R step + (coeff_9 * z^9)
    let t160 = circuit_mul(in29, t8); // Eval R step coeff_10 * z^10
    let t161 = circuit_add(t159, t160); // Eval R step + (coeff_10 * z^10)
    let t162 = circuit_mul(in30, t9); // Eval R step coeff_11 * z^11
    let t163 = circuit_add(t161, t162); // Eval R step + (coeff_11 * z^11)
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
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x6, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x6871ca8d3c208c16d87cfd3e, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0]);
    circuit_inputs = circuit_inputs.next([0x1, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(Q_0.x0);
    circuit_inputs = circuit_inputs.next(Q_0.x1);
    circuit_inputs = circuit_inputs.next(Q_0.y0);
    circuit_inputs = circuit_inputs.next(Q_0.y1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(Q_1.x0);
    circuit_inputs = circuit_inputs.next(Q_1.x1);
    circuit_inputs = circuit_inputs.next(Q_1.y0);
    circuit_inputs = circuit_inputs.next(Q_1.y1);
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
fn run_BN254_MP_CHECK_BIT1_LOOP_2_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    Q_0: G2Point,
    Q_or_Q_neg_0: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q_1: G2Point,
    Q_or_Q_neg_1: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one: E12D,
    c_or_cinv_of_z: u384,
    z: u384,
    ci: u384
) -> (G2Point, G2Point, u384, u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0
    let in1 = CE::<CI<1>> {}; // -0x9 % p
    let in2 = CE::<CI<2>> {}; // 0x1

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
    let in39 = CE::<CI<39>> {};
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
    let t10 = circuit_mul(in39, in39); // Compute c_i = (c_(i-1))^2
    let t11 = circuit_mul(in24, in24); // Square f evaluation in Z, the result of previous bit.
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
    let t46 = circuit_add(in7, in7); // Fp2 add coeff 0/1
    let t47 = circuit_add(in8, in8); // Fp2 add coeff 1/1
    let t48 = circuit_sub(t36, in5); // Fp2 sub coeff 0/1
    let t49 = circuit_sub(t37, in6); // Fp2 sub coeff 1/1
    let t50 = circuit_mul(t48, t48); // Fp2 Div x/y start : Fp2 Inv y start
    let t51 = circuit_mul(t49, t49);
    let t52 = circuit_add(t50, t51);
    let t53 = circuit_inverse(t52);
    let t54 = circuit_mul(t48, t53); // Fp2 Inv y real part end
    let t55 = circuit_mul(t49, t53);
    let t56 = circuit_sub(in0, t55); // Fp2 Inv y imag part end
    let t57 = circuit_mul(t46, t54); // Fp2 mul start
    let t58 = circuit_mul(t47, t56);
    let t59 = circuit_sub(t57, t58); // Fp2 mul real part end
    let t60 = circuit_mul(t46, t56);
    let t61 = circuit_mul(t47, t54);
    let t62 = circuit_add(t60, t61); // Fp2 mul imag part end
    let t63 = circuit_add(t25, t59); // Fp2 add coeff 0/1
    let t64 = circuit_add(t28, t62); // Fp2 add coeff 1/1
    let t65 = circuit_sub(in0, t63); // Fp2 neg coeff 0/1
    let t66 = circuit_sub(in0, t64); // Fp2 neg coeff 1/1
    let t67 = circuit_add(t65, t66);
    let t68 = circuit_sub(t65, t66);
    let t69 = circuit_mul(t67, t68);
    let t70 = circuit_mul(t65, t66);
    let t71 = circuit_add(t70, t70);
    let t72 = circuit_sub(t69, in5); // Fp2 sub coeff 0/1
    let t73 = circuit_sub(t71, in6); // Fp2 sub coeff 1/1
    let t74 = circuit_sub(t72, t36); // Fp2 sub coeff 0/1
    let t75 = circuit_sub(t73, t37); // Fp2 sub coeff 1/1
    let t76 = circuit_sub(in5, t74); // Fp2 sub coeff 0/1
    let t77 = circuit_sub(in6, t75); // Fp2 sub coeff 1/1
    let t78 = circuit_mul(t65, t76); // Fp2 mul start
    let t79 = circuit_mul(t66, t77);
    let t80 = circuit_sub(t78, t79); // Fp2 mul real part end
    let t81 = circuit_mul(t65, t77);
    let t82 = circuit_mul(t66, t76);
    let t83 = circuit_add(t81, t82); // Fp2 mul imag part end
    let t84 = circuit_sub(t80, in7); // Fp2 sub coeff 0/1
    let t85 = circuit_sub(t83, in8); // Fp2 sub coeff 1/1
    let t86 = circuit_mul(t65, in5); // Fp2 mul start
    let t87 = circuit_mul(t66, in6);
    let t88 = circuit_sub(t86, t87); // Fp2 mul real part end
    let t89 = circuit_mul(t65, in6);
    let t90 = circuit_mul(t66, in5);
    let t91 = circuit_add(t89, t90); // Fp2 mul imag part end
    let t92 = circuit_sub(t88, in7); // Fp2 sub coeff 0/1
    let t93 = circuit_sub(t91, in8); // Fp2 sub coeff 1/1
    let t94 = circuit_mul(in1, t28);
    let t95 = circuit_add(t25, t94);
    let t96 = circuit_mul(t95, in4);
    let t97 = circuit_mul(in1, t45);
    let t98 = circuit_add(t44, t97);
    let t99 = circuit_mul(t98, in3);
    let t100 = circuit_mul(t28, in4);
    let t101 = circuit_mul(t45, in3);
    let t102 = circuit_mul(in1, t66);
    let t103 = circuit_add(t65, t102);
    let t104 = circuit_mul(t103, in4);
    let t105 = circuit_mul(in1, t93);
    let t106 = circuit_add(t92, t105);
    let t107 = circuit_mul(t106, in3);
    let t108 = circuit_mul(t66, in4);
    let t109 = circuit_mul(t93, in3);
    let t110 = circuit_mul(t96, in38); // Eval sparse poly line_0p_1 step coeff_1 * z^1
    let t111 = circuit_add(in2, t110); // Eval sparse poly line_0p_1 step + coeff_1 * z^1
    let t112 = circuit_mul(t99, t1); // Eval sparse poly line_0p_1 step coeff_3 * z^3
    let t113 = circuit_add(t111, t112); // Eval sparse poly line_0p_1 step + coeff_3 * z^3
    let t114 = circuit_mul(t100, t5); // Eval sparse poly line_0p_1 step coeff_7 * z^7
    let t115 = circuit_add(t113, t114); // Eval sparse poly line_0p_1 step + coeff_7 * z^7
    let t116 = circuit_mul(t101, t7); // Eval sparse poly line_0p_1 step coeff_9 * z^9
    let t117 = circuit_add(t115, t116); // Eval sparse poly line_0p_1 step + coeff_9 * z^9
    let t118 = circuit_mul(t11, t117); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t119 = circuit_mul(t104, in38); // Eval sparse poly line_0p_2 step coeff_1 * z^1
    let t120 = circuit_add(in2, t119); // Eval sparse poly line_0p_2 step + coeff_1 * z^1
    let t121 = circuit_mul(t107, t1); // Eval sparse poly line_0p_2 step coeff_3 * z^3
    let t122 = circuit_add(t120, t121); // Eval sparse poly line_0p_2 step + coeff_3 * z^3
    let t123 = circuit_mul(t108, t5); // Eval sparse poly line_0p_2 step coeff_7 * z^7
    let t124 = circuit_add(t122, t123); // Eval sparse poly line_0p_2 step + coeff_7 * z^7
    let t125 = circuit_mul(t109, t7); // Eval sparse poly line_0p_2 step coeff_9 * z^9
    let t126 = circuit_add(t124, t125); // Eval sparse poly line_0p_2 step + coeff_9 * z^9
    let t127 = circuit_mul(t118, t126); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
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
    let t162 = circuit_add(in17, in17); // Fp2 add coeff 0/1
    let t163 = circuit_add(in18, in18); // Fp2 add coeff 1/1
    let t164 = circuit_sub(t152, in15); // Fp2 sub coeff 0/1
    let t165 = circuit_sub(t153, in16); // Fp2 sub coeff 1/1
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
    let t179 = circuit_add(t141, t175); // Fp2 add coeff 0/1
    let t180 = circuit_add(t144, t178); // Fp2 add coeff 1/1
    let t181 = circuit_sub(in0, t179); // Fp2 neg coeff 0/1
    let t182 = circuit_sub(in0, t180); // Fp2 neg coeff 1/1
    let t183 = circuit_add(t181, t182);
    let t184 = circuit_sub(t181, t182);
    let t185 = circuit_mul(t183, t184);
    let t186 = circuit_mul(t181, t182);
    let t187 = circuit_add(t186, t186);
    let t188 = circuit_sub(t185, in15); // Fp2 sub coeff 0/1
    let t189 = circuit_sub(t187, in16); // Fp2 sub coeff 1/1
    let t190 = circuit_sub(t188, t152); // Fp2 sub coeff 0/1
    let t191 = circuit_sub(t189, t153); // Fp2 sub coeff 1/1
    let t192 = circuit_sub(in15, t190); // Fp2 sub coeff 0/1
    let t193 = circuit_sub(in16, t191); // Fp2 sub coeff 1/1
    let t194 = circuit_mul(t181, t192); // Fp2 mul start
    let t195 = circuit_mul(t182, t193);
    let t196 = circuit_sub(t194, t195); // Fp2 mul real part end
    let t197 = circuit_mul(t181, t193);
    let t198 = circuit_mul(t182, t192);
    let t199 = circuit_add(t197, t198); // Fp2 mul imag part end
    let t200 = circuit_sub(t196, in17); // Fp2 sub coeff 0/1
    let t201 = circuit_sub(t199, in18); // Fp2 sub coeff 1/1
    let t202 = circuit_mul(t181, in15); // Fp2 mul start
    let t203 = circuit_mul(t182, in16);
    let t204 = circuit_sub(t202, t203); // Fp2 mul real part end
    let t205 = circuit_mul(t181, in16);
    let t206 = circuit_mul(t182, in15);
    let t207 = circuit_add(t205, t206); // Fp2 mul imag part end
    let t208 = circuit_sub(t204, in17); // Fp2 sub coeff 0/1
    let t209 = circuit_sub(t207, in18); // Fp2 sub coeff 1/1
    let t210 = circuit_mul(in1, t144);
    let t211 = circuit_add(t141, t210);
    let t212 = circuit_mul(t211, in14);
    let t213 = circuit_mul(in1, t161);
    let t214 = circuit_add(t160, t213);
    let t215 = circuit_mul(t214, in13);
    let t216 = circuit_mul(t144, in14);
    let t217 = circuit_mul(t161, in13);
    let t218 = circuit_mul(in1, t182);
    let t219 = circuit_add(t181, t218);
    let t220 = circuit_mul(t219, in14);
    let t221 = circuit_mul(in1, t209);
    let t222 = circuit_add(t208, t221);
    let t223 = circuit_mul(t222, in13);
    let t224 = circuit_mul(t182, in14);
    let t225 = circuit_mul(t209, in13);
    let t226 = circuit_mul(t212, in38); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t227 = circuit_add(in2, t226); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t228 = circuit_mul(t215, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t229 = circuit_add(t227, t228); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t230 = circuit_mul(t216, t5); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t231 = circuit_add(t229, t230); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t232 = circuit_mul(t217, t7); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t233 = circuit_add(t231, t232); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t234 = circuit_mul(t127, t233); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t235 = circuit_mul(t220, in38); // Eval sparse poly line_1p_2 step coeff_1 * z^1
    let t236 = circuit_add(in2, t235); // Eval sparse poly line_1p_2 step + coeff_1 * z^1
    let t237 = circuit_mul(t223, t1); // Eval sparse poly line_1p_2 step coeff_3 * z^3
    let t238 = circuit_add(t236, t237); // Eval sparse poly line_1p_2 step + coeff_3 * z^3
    let t239 = circuit_mul(t224, t5); // Eval sparse poly line_1p_2 step coeff_7 * z^7
    let t240 = circuit_add(t238, t239); // Eval sparse poly line_1p_2 step + coeff_7 * z^7
    let t241 = circuit_mul(t225, t7); // Eval sparse poly line_1p_2 step coeff_9 * z^9
    let t242 = circuit_add(t240, t241); // Eval sparse poly line_1p_2 step + coeff_9 * z^9
    let t243 = circuit_mul(t234, t242); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t244 = circuit_mul(t243, in37);
    let t245 = circuit_mul(in26, in38); // Eval R step coeff_1 * z^1
    let t246 = circuit_add(in25, t245); // Eval R step + (coeff_1 * z^1)
    let t247 = circuit_mul(in27, t0); // Eval R step coeff_2 * z^2
    let t248 = circuit_add(t246, t247); // Eval R step + (coeff_2 * z^2)
    let t249 = circuit_mul(in28, t1); // Eval R step coeff_3 * z^3
    let t250 = circuit_add(t248, t249); // Eval R step + (coeff_3 * z^3)
    let t251 = circuit_mul(in29, t2); // Eval R step coeff_4 * z^4
    let t252 = circuit_add(t250, t251); // Eval R step + (coeff_4 * z^4)
    let t253 = circuit_mul(in30, t3); // Eval R step coeff_5 * z^5
    let t254 = circuit_add(t252, t253); // Eval R step + (coeff_5 * z^5)
    let t255 = circuit_mul(in31, t4); // Eval R step coeff_6 * z^6
    let t256 = circuit_add(t254, t255); // Eval R step + (coeff_6 * z^6)
    let t257 = circuit_mul(in32, t5); // Eval R step coeff_7 * z^7
    let t258 = circuit_add(t256, t257); // Eval R step + (coeff_7 * z^7)
    let t259 = circuit_mul(in33, t6); // Eval R step coeff_8 * z^8
    let t260 = circuit_add(t258, t259); // Eval R step + (coeff_8 * z^8)
    let t261 = circuit_mul(in34, t7); // Eval R step coeff_9 * z^9
    let t262 = circuit_add(t260, t261); // Eval R step + (coeff_9 * z^9)
    let t263 = circuit_mul(in35, t8); // Eval R step coeff_10 * z^10
    let t264 = circuit_add(t262, t263); // Eval R step + (coeff_10 * z^10)
    let t265 = circuit_mul(in36, t9); // Eval R step coeff_11 * z^11
    let t266 = circuit_add(t264, t265); // Eval R step + (coeff_11 * z^11)
    let t267 = circuit_sub(t244, t266); // (Π(i,k) (Pk(z))) - Ri(z)
    let t268 = circuit_mul(t10, t267); // ci * ((Π(i,k) (Pk(z)) - Ri(z))
    let t269 = circuit_add(in23, t268); // LHS = LHS + ci * ((Π(i,k) (Pk(z)) - Ri(z))

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [32324006162389411176778628423, 57042285082623239461879769745, 3486998266802970665, 0]
    )
        .unwrap();

    let mut circuit_inputs = (t74, t75, t84, t85, t190, t191, t200, t201, t266, t269, t10,)
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x6871ca8d3c208c16d87cfd3e, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0]);
    circuit_inputs = circuit_inputs.next([0x1, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(Q_0.x0);
    circuit_inputs = circuit_inputs.next(Q_0.x1);
    circuit_inputs = circuit_inputs.next(Q_0.y0);
    circuit_inputs = circuit_inputs.next(Q_0.y1);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_0.x0);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_0.x1);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_0.y0);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_0.y1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(Q_1.x0);
    circuit_inputs = circuit_inputs.next(Q_1.x1);
    circuit_inputs = circuit_inputs.next(Q_1.y0);
    circuit_inputs = circuit_inputs.next(Q_1.y1);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_1.x0);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_1.x1);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_1.y0);
    circuit_inputs = circuit_inputs.next(Q_or_Q_neg_1.y1);
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
        x0: outputs.get_output(t74),
        x1: outputs.get_output(t75),
        y0: outputs.get_output(t84),
        y1: outputs.get_output(t85)
    };
    let Q1: G2Point = G2Point {
        x0: outputs.get_output(t190),
        x1: outputs.get_output(t191),
        y0: outputs.get_output(t200),
        y1: outputs.get_output(t201)
    };
    let f_i_plus_one_of_z: u384 = outputs.get_output(t266);
    let lhs_i_plus_one: u384 = outputs.get_output(t269);
    let ci_plus_one: u384 = outputs.get_output(t10);
    return (Q0, Q1, f_i_plus_one_of_z, lhs_i_plus_one, ci_plus_one);
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
    let in148 = CE::<CI<148>> {};
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
    let t56 = circuit_mul(t55, in56); // Compute z^58
    let t57 = circuit_mul(t56, in56); // Compute z^59
    let t58 = circuit_mul(t57, in56); // Compute z^60
    let t59 = circuit_mul(t58, in56); // Compute z^61
    let t60 = circuit_mul(t59, in56); // Compute z^62
    let t61 = circuit_mul(t60, in56); // Compute z^63
    let t62 = circuit_mul(t61, in56); // Compute z^64
    let t63 = circuit_mul(t62, in56); // Compute z^65
    let t64 = circuit_mul(t63, in56); // Compute z^66
    let t65 = circuit_mul(t64, in56); // Compute z^67
    let t66 = circuit_mul(t65, in56); // Compute z^68
    let t67 = circuit_mul(t66, in56); // Compute z^69
    let t68 = circuit_mul(t67, in56); // Compute z^70
    let t69 = circuit_mul(t68, in56); // Compute z^71
    let t70 = circuit_mul(t69, in56); // Compute z^72
    let t71 = circuit_mul(t70, in56); // Compute z^73
    let t72 = circuit_mul(t71, in56); // Compute z^74
    let t73 = circuit_mul(t72, in56); // Compute z^75
    let t74 = circuit_mul(t73, in56); // Compute z^76
    let t75 = circuit_mul(t74, in56); // Compute z^77
    let t76 = circuit_mul(t75, in56); // Compute z^78
    let t77 = circuit_mul(t76, in56); // Compute z^79
    let t78 = circuit_mul(t77, in56); // Compute z^80
    let t79 = circuit_mul(t78, in56); // Compute z^81
    let t80 = circuit_mul(t79, in56); // Compute z^82
    let t81 = circuit_mul(t80, in56); // Compute z^83
    let t82 = circuit_mul(t81, in56); // Compute z^84
    let t83 = circuit_mul(t82, in56); // Compute z^85
    let t84 = circuit_mul(t83, in56); // Compute z^86
    let t85 = circuit_mul(in54, in54);
    let t86 = circuit_mul(t85, t85);
    let t87 = circuit_mul(in31, in56); // Eval R_n_minus_2 step coeff_1 * z^1
    let t88 = circuit_add(in30, t87); // Eval R_n_minus_2 step + (coeff_1 * z^1)
    let t89 = circuit_mul(in32, t0); // Eval R_n_minus_2 step coeff_2 * z^2
    let t90 = circuit_add(t88, t89); // Eval R_n_minus_2 step + (coeff_2 * z^2)
    let t91 = circuit_mul(in33, t1); // Eval R_n_minus_2 step coeff_3 * z^3
    let t92 = circuit_add(t90, t91); // Eval R_n_minus_2 step + (coeff_3 * z^3)
    let t93 = circuit_mul(in34, t2); // Eval R_n_minus_2 step coeff_4 * z^4
    let t94 = circuit_add(t92, t93); // Eval R_n_minus_2 step + (coeff_4 * z^4)
    let t95 = circuit_mul(in35, t3); // Eval R_n_minus_2 step coeff_5 * z^5
    let t96 = circuit_add(t94, t95); // Eval R_n_minus_2 step + (coeff_5 * z^5)
    let t97 = circuit_mul(in36, t4); // Eval R_n_minus_2 step coeff_6 * z^6
    let t98 = circuit_add(t96, t97); // Eval R_n_minus_2 step + (coeff_6 * z^6)
    let t99 = circuit_mul(in37, t5); // Eval R_n_minus_2 step coeff_7 * z^7
    let t100 = circuit_add(t98, t99); // Eval R_n_minus_2 step + (coeff_7 * z^7)
    let t101 = circuit_mul(in38, t6); // Eval R_n_minus_2 step coeff_8 * z^8
    let t102 = circuit_add(t100, t101); // Eval R_n_minus_2 step + (coeff_8 * z^8)
    let t103 = circuit_mul(in39, t7); // Eval R_n_minus_2 step coeff_9 * z^9
    let t104 = circuit_add(t102, t103); // Eval R_n_minus_2 step + (coeff_9 * z^9)
    let t105 = circuit_mul(in40, t8); // Eval R_n_minus_2 step coeff_10 * z^10
    let t106 = circuit_add(t104, t105); // Eval R_n_minus_2 step + (coeff_10 * z^10)
    let t107 = circuit_mul(in41, t9); // Eval R_n_minus_2 step coeff_11 * z^11
    let t108 = circuit_add(t106, t107); // Eval R_n_minus_2 step + (coeff_11 * z^11)
    let t109 = circuit_mul(in43, in56); // Eval R_n_minus_1 step coeff_1 * z^1
    let t110 = circuit_add(in42, t109); // Eval R_n_minus_1 step + (coeff_1 * z^1)
    let t111 = circuit_mul(in44, t0); // Eval R_n_minus_1 step coeff_2 * z^2
    let t112 = circuit_add(t110, t111); // Eval R_n_minus_1 step + (coeff_2 * z^2)
    let t113 = circuit_mul(in45, t1); // Eval R_n_minus_1 step coeff_3 * z^3
    let t114 = circuit_add(t112, t113); // Eval R_n_minus_1 step + (coeff_3 * z^3)
    let t115 = circuit_mul(in46, t2); // Eval R_n_minus_1 step coeff_4 * z^4
    let t116 = circuit_add(t114, t115); // Eval R_n_minus_1 step + (coeff_4 * z^4)
    let t117 = circuit_mul(in47, t3); // Eval R_n_minus_1 step coeff_5 * z^5
    let t118 = circuit_add(t116, t117); // Eval R_n_minus_1 step + (coeff_5 * z^5)
    let t119 = circuit_mul(in48, t4); // Eval R_n_minus_1 step coeff_6 * z^6
    let t120 = circuit_add(t118, t119); // Eval R_n_minus_1 step + (coeff_6 * z^6)
    let t121 = circuit_mul(in49, t5); // Eval R_n_minus_1 step coeff_7 * z^7
    let t122 = circuit_add(t120, t121); // Eval R_n_minus_1 step + (coeff_7 * z^7)
    let t123 = circuit_mul(in50, t6); // Eval R_n_minus_1 step coeff_8 * z^8
    let t124 = circuit_add(t122, t123); // Eval R_n_minus_1 step + (coeff_8 * z^8)
    let t125 = circuit_mul(in51, t7); // Eval R_n_minus_1 step coeff_9 * z^9
    let t126 = circuit_add(t124, t125); // Eval R_n_minus_1 step + (coeff_9 * z^9)
    let t127 = circuit_mul(in52, t8); // Eval R_n_minus_1 step coeff_10 * z^10
    let t128 = circuit_add(t126, t127); // Eval R_n_minus_1 step + (coeff_10 * z^10)
    let t129 = circuit_mul(in53, t9); // Eval R_n_minus_1 step coeff_11 * z^11
    let t130 = circuit_add(t128, t129); // Eval R_n_minus_1 step + (coeff_11 * z^11)
    let t131 = circuit_sub(in6, in11);
    let t132 = circuit_sub(in6, in13);
    let t133 = circuit_mul(in10, in0); // Fp2 mul start
    let t134 = circuit_mul(t131, in1);
    let t135 = circuit_sub(t133, t134); // Fp2 mul real part end
    let t136 = circuit_mul(in10, in1);
    let t137 = circuit_mul(t131, in0);
    let t138 = circuit_add(t136, t137); // Fp2 mul imag part end
    let t139 = circuit_mul(in12, in2); // Fp2 mul start
    let t140 = circuit_mul(t132, in3);
    let t141 = circuit_sub(t139, t140); // Fp2 mul real part end
    let t142 = circuit_mul(in12, in3);
    let t143 = circuit_mul(t132, in2);
    let t144 = circuit_add(t142, t143); // Fp2 mul imag part end
    let t145 = circuit_mul(in10, in4); // Fp2 scalar mul coeff 0/1
    let t146 = circuit_mul(in11, in4); // Fp2 scalar mul coeff 1/1
    let t147 = circuit_mul(in12, in5); // Fp2 scalar mul coeff 0/1
    let t148 = circuit_mul(in13, in5); // Fp2 scalar mul coeff 1/1
    let t149 = circuit_sub(in18, t141); // Fp2 sub coeff 0/1
    let t150 = circuit_sub(in19, t144); // Fp2 sub coeff 1/1
    let t151 = circuit_sub(in16, t135); // Fp2 sub coeff 0/1
    let t152 = circuit_sub(in17, t138); // Fp2 sub coeff 1/1
    let t153 = circuit_mul(t151, t151); // Fp2 Div x/y start : Fp2 Inv y start
    let t154 = circuit_mul(t152, t152);
    let t155 = circuit_add(t153, t154);
    let t156 = circuit_inverse(t155);
    let t157 = circuit_mul(t151, t156); // Fp2 Inv y real part end
    let t158 = circuit_mul(t152, t156);
    let t159 = circuit_sub(in6, t158); // Fp2 Inv y imag part end
    let t160 = circuit_mul(t149, t157); // Fp2 mul start
    let t161 = circuit_mul(t150, t159);
    let t162 = circuit_sub(t160, t161); // Fp2 mul real part end
    let t163 = circuit_mul(t149, t159);
    let t164 = circuit_mul(t150, t157);
    let t165 = circuit_add(t163, t164); // Fp2 mul imag part end
    let t166 = circuit_add(t162, t165);
    let t167 = circuit_sub(t162, t165);
    let t168 = circuit_mul(t166, t167);
    let t169 = circuit_mul(t162, t165);
    let t170 = circuit_add(t169, t169);
    let t171 = circuit_add(in16, t135); // Fp2 add coeff 0/1
    let t172 = circuit_add(in17, t138); // Fp2 add coeff 1/1
    let t173 = circuit_sub(t168, t171); // Fp2 sub coeff 0/1
    let t174 = circuit_sub(t170, t172); // Fp2 sub coeff 1/1
    let t175 = circuit_sub(in16, t173); // Fp2 sub coeff 0/1
    let t176 = circuit_sub(in17, t174); // Fp2 sub coeff 1/1
    let t177 = circuit_mul(t162, t175); // Fp2 mul start
    let t178 = circuit_mul(t165, t176);
    let t179 = circuit_sub(t177, t178); // Fp2 mul real part end
    let t180 = circuit_mul(t162, t176);
    let t181 = circuit_mul(t165, t175);
    let t182 = circuit_add(t180, t181); // Fp2 mul imag part end
    let t183 = circuit_sub(t179, in18); // Fp2 sub coeff 0/1
    let t184 = circuit_sub(t182, in19); // Fp2 sub coeff 1/1
    let t185 = circuit_mul(t162, in16); // Fp2 mul start
    let t186 = circuit_mul(t165, in17);
    let t187 = circuit_sub(t185, t186); // Fp2 mul real part end
    let t188 = circuit_mul(t162, in17);
    let t189 = circuit_mul(t165, in16);
    let t190 = circuit_add(t188, t189); // Fp2 mul imag part end
    let t191 = circuit_sub(t187, in18); // Fp2 sub coeff 0/1
    let t192 = circuit_sub(t190, in19); // Fp2 sub coeff 1/1
    let t193 = circuit_sub(t183, t147); // Fp2 sub coeff 0/1
    let t194 = circuit_sub(t184, t148); // Fp2 sub coeff 1/1
    let t195 = circuit_sub(t173, t145); // Fp2 sub coeff 0/1
    let t196 = circuit_sub(t174, t146); // Fp2 sub coeff 1/1
    let t197 = circuit_mul(t195, t195); // Fp2 Div x/y start : Fp2 Inv y start
    let t198 = circuit_mul(t196, t196);
    let t199 = circuit_add(t197, t198);
    let t200 = circuit_inverse(t199);
    let t201 = circuit_mul(t195, t200); // Fp2 Inv y real part end
    let t202 = circuit_mul(t196, t200);
    let t203 = circuit_sub(in6, t202); // Fp2 Inv y imag part end
    let t204 = circuit_mul(t193, t201); // Fp2 mul start
    let t205 = circuit_mul(t194, t203);
    let t206 = circuit_sub(t204, t205); // Fp2 mul real part end
    let t207 = circuit_mul(t193, t203);
    let t208 = circuit_mul(t194, t201);
    let t209 = circuit_add(t207, t208); // Fp2 mul imag part end
    let t210 = circuit_mul(t206, t173); // Fp2 mul start
    let t211 = circuit_mul(t209, t174);
    let t212 = circuit_sub(t210, t211); // Fp2 mul real part end
    let t213 = circuit_mul(t206, t174);
    let t214 = circuit_mul(t209, t173);
    let t215 = circuit_add(t213, t214); // Fp2 mul imag part end
    let t216 = circuit_sub(t212, t183); // Fp2 sub coeff 0/1
    let t217 = circuit_sub(t215, t184); // Fp2 sub coeff 1/1
    let t218 = circuit_sub(in6, in21);
    let t219 = circuit_sub(in6, in23);
    let t220 = circuit_mul(in20, in0); // Fp2 mul start
    let t221 = circuit_mul(t218, in1);
    let t222 = circuit_sub(t220, t221); // Fp2 mul real part end
    let t223 = circuit_mul(in20, in1);
    let t224 = circuit_mul(t218, in0);
    let t225 = circuit_add(t223, t224); // Fp2 mul imag part end
    let t226 = circuit_mul(in22, in2); // Fp2 mul start
    let t227 = circuit_mul(t219, in3);
    let t228 = circuit_sub(t226, t227); // Fp2 mul real part end
    let t229 = circuit_mul(in22, in3);
    let t230 = circuit_mul(t219, in2);
    let t231 = circuit_add(t229, t230); // Fp2 mul imag part end
    let t232 = circuit_mul(in20, in4); // Fp2 scalar mul coeff 0/1
    let t233 = circuit_mul(in21, in4); // Fp2 scalar mul coeff 1/1
    let t234 = circuit_mul(in22, in5); // Fp2 scalar mul coeff 0/1
    let t235 = circuit_mul(in23, in5); // Fp2 scalar mul coeff 1/1
    let t236 = circuit_sub(in28, t228); // Fp2 sub coeff 0/1
    let t237 = circuit_sub(in29, t231); // Fp2 sub coeff 1/1
    let t238 = circuit_sub(in26, t222); // Fp2 sub coeff 0/1
    let t239 = circuit_sub(in27, t225); // Fp2 sub coeff 1/1
    let t240 = circuit_mul(t238, t238); // Fp2 Div x/y start : Fp2 Inv y start
    let t241 = circuit_mul(t239, t239);
    let t242 = circuit_add(t240, t241);
    let t243 = circuit_inverse(t242);
    let t244 = circuit_mul(t238, t243); // Fp2 Inv y real part end
    let t245 = circuit_mul(t239, t243);
    let t246 = circuit_sub(in6, t245); // Fp2 Inv y imag part end
    let t247 = circuit_mul(t236, t244); // Fp2 mul start
    let t248 = circuit_mul(t237, t246);
    let t249 = circuit_sub(t247, t248); // Fp2 mul real part end
    let t250 = circuit_mul(t236, t246);
    let t251 = circuit_mul(t237, t244);
    let t252 = circuit_add(t250, t251); // Fp2 mul imag part end
    let t253 = circuit_add(t249, t252);
    let t254 = circuit_sub(t249, t252);
    let t255 = circuit_mul(t253, t254);
    let t256 = circuit_mul(t249, t252);
    let t257 = circuit_add(t256, t256);
    let t258 = circuit_add(in26, t222); // Fp2 add coeff 0/1
    let t259 = circuit_add(in27, t225); // Fp2 add coeff 1/1
    let t260 = circuit_sub(t255, t258); // Fp2 sub coeff 0/1
    let t261 = circuit_sub(t257, t259); // Fp2 sub coeff 1/1
    let t262 = circuit_sub(in26, t260); // Fp2 sub coeff 0/1
    let t263 = circuit_sub(in27, t261); // Fp2 sub coeff 1/1
    let t264 = circuit_mul(t249, t262); // Fp2 mul start
    let t265 = circuit_mul(t252, t263);
    let t266 = circuit_sub(t264, t265); // Fp2 mul real part end
    let t267 = circuit_mul(t249, t263);
    let t268 = circuit_mul(t252, t262);
    let t269 = circuit_add(t267, t268); // Fp2 mul imag part end
    let t270 = circuit_sub(t266, in28); // Fp2 sub coeff 0/1
    let t271 = circuit_sub(t269, in29); // Fp2 sub coeff 1/1
    let t272 = circuit_mul(t249, in26); // Fp2 mul start
    let t273 = circuit_mul(t252, in27);
    let t274 = circuit_sub(t272, t273); // Fp2 mul real part end
    let t275 = circuit_mul(t249, in27);
    let t276 = circuit_mul(t252, in26);
    let t277 = circuit_add(t275, t276); // Fp2 mul imag part end
    let t278 = circuit_sub(t274, in28); // Fp2 sub coeff 0/1
    let t279 = circuit_sub(t277, in29); // Fp2 sub coeff 1/1
    let t280 = circuit_sub(t270, t234); // Fp2 sub coeff 0/1
    let t281 = circuit_sub(t271, t235); // Fp2 sub coeff 1/1
    let t282 = circuit_sub(t260, t232); // Fp2 sub coeff 0/1
    let t283 = circuit_sub(t261, t233); // Fp2 sub coeff 1/1
    let t284 = circuit_mul(t282, t282); // Fp2 Div x/y start : Fp2 Inv y start
    let t285 = circuit_mul(t283, t283);
    let t286 = circuit_add(t284, t285);
    let t287 = circuit_inverse(t286);
    let t288 = circuit_mul(t282, t287); // Fp2 Inv y real part end
    let t289 = circuit_mul(t283, t287);
    let t290 = circuit_sub(in6, t289); // Fp2 Inv y imag part end
    let t291 = circuit_mul(t280, t288); // Fp2 mul start
    let t292 = circuit_mul(t281, t290);
    let t293 = circuit_sub(t291, t292); // Fp2 mul real part end
    let t294 = circuit_mul(t280, t290);
    let t295 = circuit_mul(t281, t288);
    let t296 = circuit_add(t294, t295); // Fp2 mul imag part end
    let t297 = circuit_mul(t293, t260); // Fp2 mul start
    let t298 = circuit_mul(t296, t261);
    let t299 = circuit_sub(t297, t298); // Fp2 mul real part end
    let t300 = circuit_mul(t293, t261);
    let t301 = circuit_mul(t296, t260);
    let t302 = circuit_add(t300, t301); // Fp2 mul imag part end
    let t303 = circuit_sub(t299, t270); // Fp2 sub coeff 0/1
    let t304 = circuit_sub(t302, t271); // Fp2 sub coeff 1/1
    let t305 = circuit_mul(in7, t165);
    let t306 = circuit_add(t162, t305);
    let t307 = circuit_mul(t306, in15);
    let t308 = circuit_mul(in7, t192);
    let t309 = circuit_add(t191, t308);
    let t310 = circuit_mul(t309, in14);
    let t311 = circuit_mul(t165, in15);
    let t312 = circuit_mul(t192, in14);
    let t313 = circuit_mul(in7, t209);
    let t314 = circuit_add(t206, t313);
    let t315 = circuit_mul(t314, in15);
    let t316 = circuit_mul(in7, t217);
    let t317 = circuit_add(t216, t316);
    let t318 = circuit_mul(t317, in14);
    let t319 = circuit_mul(t209, in15);
    let t320 = circuit_mul(t217, in14);
    let t321 = circuit_mul(in7, t252);
    let t322 = circuit_add(t249, t321);
    let t323 = circuit_mul(t322, in25);
    let t324 = circuit_mul(in7, t279);
    let t325 = circuit_add(t278, t324);
    let t326 = circuit_mul(t325, in24);
    let t327 = circuit_mul(t252, in25);
    let t328 = circuit_mul(t279, in24);
    let t329 = circuit_mul(in7, t296);
    let t330 = circuit_add(t293, t329);
    let t331 = circuit_mul(t330, in25);
    let t332 = circuit_mul(in7, t304);
    let t333 = circuit_add(t303, t332);
    let t334 = circuit_mul(t333, in24);
    let t335 = circuit_mul(t296, in25);
    let t336 = circuit_mul(t304, in24);
    let t337 = circuit_mul(t307, in56); // Eval sparse poly line_1 step coeff_1 * z^1
    let t338 = circuit_add(in5, t337); // Eval sparse poly line_1 step + coeff_1 * z^1
    let t339 = circuit_mul(t310, t1); // Eval sparse poly line_1 step coeff_3 * z^3
    let t340 = circuit_add(t338, t339); // Eval sparse poly line_1 step + coeff_3 * z^3
    let t341 = circuit_mul(t311, t5); // Eval sparse poly line_1 step coeff_7 * z^7
    let t342 = circuit_add(t340, t341); // Eval sparse poly line_1 step + coeff_7 * z^7
    let t343 = circuit_mul(t312, t7); // Eval sparse poly line_1 step coeff_9 * z^9
    let t344 = circuit_add(t342, t343); // Eval sparse poly line_1 step + coeff_9 * z^9
    let t345 = circuit_mul(in61, t344);
    let t346 = circuit_mul(t315, in56); // Eval sparse poly line_1 step coeff_1 * z^1
    let t347 = circuit_add(in5, t346); // Eval sparse poly line_1 step + coeff_1 * z^1
    let t348 = circuit_mul(t318, t1); // Eval sparse poly line_1 step coeff_3 * z^3
    let t349 = circuit_add(t347, t348); // Eval sparse poly line_1 step + coeff_3 * z^3
    let t350 = circuit_mul(t319, t5); // Eval sparse poly line_1 step coeff_7 * z^7
    let t351 = circuit_add(t349, t350); // Eval sparse poly line_1 step + coeff_7 * z^7
    let t352 = circuit_mul(t320, t7); // Eval sparse poly line_1 step coeff_9 * z^9
    let t353 = circuit_add(t351, t352); // Eval sparse poly line_1 step + coeff_9 * z^9
    let t354 = circuit_mul(t345, t353);
    let t355 = circuit_mul(t323, in56); // Eval sparse poly line_1 step coeff_1 * z^1
    let t356 = circuit_add(in5, t355); // Eval sparse poly line_1 step + coeff_1 * z^1
    let t357 = circuit_mul(t326, t1); // Eval sparse poly line_1 step coeff_3 * z^3
    let t358 = circuit_add(t356, t357); // Eval sparse poly line_1 step + coeff_3 * z^3
    let t359 = circuit_mul(t327, t5); // Eval sparse poly line_1 step coeff_7 * z^7
    let t360 = circuit_add(t358, t359); // Eval sparse poly line_1 step + coeff_7 * z^7
    let t361 = circuit_mul(t328, t7); // Eval sparse poly line_1 step coeff_9 * z^9
    let t362 = circuit_add(t360, t361); // Eval sparse poly line_1 step + coeff_9 * z^9
    let t363 = circuit_mul(t354, t362);
    let t364 = circuit_mul(t331, in56); // Eval sparse poly line_1 step coeff_1 * z^1
    let t365 = circuit_add(in5, t364); // Eval sparse poly line_1 step + coeff_1 * z^1
    let t366 = circuit_mul(t334, t1); // Eval sparse poly line_1 step coeff_3 * z^3
    let t367 = circuit_add(t365, t366); // Eval sparse poly line_1 step + coeff_3 * z^3
    let t368 = circuit_mul(t335, t5); // Eval sparse poly line_1 step coeff_7 * z^7
    let t369 = circuit_add(t367, t368); // Eval sparse poly line_1 step + coeff_7 * z^7
    let t370 = circuit_mul(t336, t7); // Eval sparse poly line_1 step coeff_9 * z^9
    let t371 = circuit_add(t369, t370); // Eval sparse poly line_1 step + coeff_9 * z^9
    let t372 = circuit_mul(t363, t371);
    let t373 = circuit_sub(t372, t108);
    let t374 = circuit_mul(t85, t373); // c_n_minus_2 * ((Π(n-2,k) (Pk(z)) - R_n_minus_2(z))
    let t375 = circuit_mul(t108, in57);
    let t376 = circuit_mul(t375, in58);
    let t377 = circuit_mul(t376, in59);
    let t378 = circuit_mul(t377, in55);
    let t379 = circuit_sub(t378, t130);
    let t380 = circuit_mul(t86, t379); // c_n_minus_1 * ((Π(n-1,k) (Pk(z)) - R_n_minus_1(z))
    let t381 = circuit_add(in60, t374);
    let t382 = circuit_add(t381, t380);
    let t383 = circuit_mul(in63, in56); // Eval big_Q step coeff_1 * z^1
    let t384 = circuit_add(in62, t383); // Eval big_Q step + (coeff_1 * z^1)
    let t385 = circuit_mul(in64, t0); // Eval big_Q step coeff_2 * z^2
    let t386 = circuit_add(t384, t385); // Eval big_Q step + (coeff_2 * z^2)
    let t387 = circuit_mul(in65, t1); // Eval big_Q step coeff_3 * z^3
    let t388 = circuit_add(t386, t387); // Eval big_Q step + (coeff_3 * z^3)
    let t389 = circuit_mul(in66, t2); // Eval big_Q step coeff_4 * z^4
    let t390 = circuit_add(t388, t389); // Eval big_Q step + (coeff_4 * z^4)
    let t391 = circuit_mul(in67, t3); // Eval big_Q step coeff_5 * z^5
    let t392 = circuit_add(t390, t391); // Eval big_Q step + (coeff_5 * z^5)
    let t393 = circuit_mul(in68, t4); // Eval big_Q step coeff_6 * z^6
    let t394 = circuit_add(t392, t393); // Eval big_Q step + (coeff_6 * z^6)
    let t395 = circuit_mul(in69, t5); // Eval big_Q step coeff_7 * z^7
    let t396 = circuit_add(t394, t395); // Eval big_Q step + (coeff_7 * z^7)
    let t397 = circuit_mul(in70, t6); // Eval big_Q step coeff_8 * z^8
    let t398 = circuit_add(t396, t397); // Eval big_Q step + (coeff_8 * z^8)
    let t399 = circuit_mul(in71, t7); // Eval big_Q step coeff_9 * z^9
    let t400 = circuit_add(t398, t399); // Eval big_Q step + (coeff_9 * z^9)
    let t401 = circuit_mul(in72, t8); // Eval big_Q step coeff_10 * z^10
    let t402 = circuit_add(t400, t401); // Eval big_Q step + (coeff_10 * z^10)
    let t403 = circuit_mul(in73, t9); // Eval big_Q step coeff_11 * z^11
    let t404 = circuit_add(t402, t403); // Eval big_Q step + (coeff_11 * z^11)
    let t405 = circuit_mul(in74, t10); // Eval big_Q step coeff_12 * z^12
    let t406 = circuit_add(t404, t405); // Eval big_Q step + (coeff_12 * z^12)
    let t407 = circuit_mul(in75, t11); // Eval big_Q step coeff_13 * z^13
    let t408 = circuit_add(t406, t407); // Eval big_Q step + (coeff_13 * z^13)
    let t409 = circuit_mul(in76, t12); // Eval big_Q step coeff_14 * z^14
    let t410 = circuit_add(t408, t409); // Eval big_Q step + (coeff_14 * z^14)
    let t411 = circuit_mul(in77, t13); // Eval big_Q step coeff_15 * z^15
    let t412 = circuit_add(t410, t411); // Eval big_Q step + (coeff_15 * z^15)
    let t413 = circuit_mul(in78, t14); // Eval big_Q step coeff_16 * z^16
    let t414 = circuit_add(t412, t413); // Eval big_Q step + (coeff_16 * z^16)
    let t415 = circuit_mul(in79, t15); // Eval big_Q step coeff_17 * z^17
    let t416 = circuit_add(t414, t415); // Eval big_Q step + (coeff_17 * z^17)
    let t417 = circuit_mul(in80, t16); // Eval big_Q step coeff_18 * z^18
    let t418 = circuit_add(t416, t417); // Eval big_Q step + (coeff_18 * z^18)
    let t419 = circuit_mul(in81, t17); // Eval big_Q step coeff_19 * z^19
    let t420 = circuit_add(t418, t419); // Eval big_Q step + (coeff_19 * z^19)
    let t421 = circuit_mul(in82, t18); // Eval big_Q step coeff_20 * z^20
    let t422 = circuit_add(t420, t421); // Eval big_Q step + (coeff_20 * z^20)
    let t423 = circuit_mul(in83, t19); // Eval big_Q step coeff_21 * z^21
    let t424 = circuit_add(t422, t423); // Eval big_Q step + (coeff_21 * z^21)
    let t425 = circuit_mul(in84, t20); // Eval big_Q step coeff_22 * z^22
    let t426 = circuit_add(t424, t425); // Eval big_Q step + (coeff_22 * z^22)
    let t427 = circuit_mul(in85, t21); // Eval big_Q step coeff_23 * z^23
    let t428 = circuit_add(t426, t427); // Eval big_Q step + (coeff_23 * z^23)
    let t429 = circuit_mul(in86, t22); // Eval big_Q step coeff_24 * z^24
    let t430 = circuit_add(t428, t429); // Eval big_Q step + (coeff_24 * z^24)
    let t431 = circuit_mul(in87, t23); // Eval big_Q step coeff_25 * z^25
    let t432 = circuit_add(t430, t431); // Eval big_Q step + (coeff_25 * z^25)
    let t433 = circuit_mul(in88, t24); // Eval big_Q step coeff_26 * z^26
    let t434 = circuit_add(t432, t433); // Eval big_Q step + (coeff_26 * z^26)
    let t435 = circuit_mul(in89, t25); // Eval big_Q step coeff_27 * z^27
    let t436 = circuit_add(t434, t435); // Eval big_Q step + (coeff_27 * z^27)
    let t437 = circuit_mul(in90, t26); // Eval big_Q step coeff_28 * z^28
    let t438 = circuit_add(t436, t437); // Eval big_Q step + (coeff_28 * z^28)
    let t439 = circuit_mul(in91, t27); // Eval big_Q step coeff_29 * z^29
    let t440 = circuit_add(t438, t439); // Eval big_Q step + (coeff_29 * z^29)
    let t441 = circuit_mul(in92, t28); // Eval big_Q step coeff_30 * z^30
    let t442 = circuit_add(t440, t441); // Eval big_Q step + (coeff_30 * z^30)
    let t443 = circuit_mul(in93, t29); // Eval big_Q step coeff_31 * z^31
    let t444 = circuit_add(t442, t443); // Eval big_Q step + (coeff_31 * z^31)
    let t445 = circuit_mul(in94, t30); // Eval big_Q step coeff_32 * z^32
    let t446 = circuit_add(t444, t445); // Eval big_Q step + (coeff_32 * z^32)
    let t447 = circuit_mul(in95, t31); // Eval big_Q step coeff_33 * z^33
    let t448 = circuit_add(t446, t447); // Eval big_Q step + (coeff_33 * z^33)
    let t449 = circuit_mul(in96, t32); // Eval big_Q step coeff_34 * z^34
    let t450 = circuit_add(t448, t449); // Eval big_Q step + (coeff_34 * z^34)
    let t451 = circuit_mul(in97, t33); // Eval big_Q step coeff_35 * z^35
    let t452 = circuit_add(t450, t451); // Eval big_Q step + (coeff_35 * z^35)
    let t453 = circuit_mul(in98, t34); // Eval big_Q step coeff_36 * z^36
    let t454 = circuit_add(t452, t453); // Eval big_Q step + (coeff_36 * z^36)
    let t455 = circuit_mul(in99, t35); // Eval big_Q step coeff_37 * z^37
    let t456 = circuit_add(t454, t455); // Eval big_Q step + (coeff_37 * z^37)
    let t457 = circuit_mul(in100, t36); // Eval big_Q step coeff_38 * z^38
    let t458 = circuit_add(t456, t457); // Eval big_Q step + (coeff_38 * z^38)
    let t459 = circuit_mul(in101, t37); // Eval big_Q step coeff_39 * z^39
    let t460 = circuit_add(t458, t459); // Eval big_Q step + (coeff_39 * z^39)
    let t461 = circuit_mul(in102, t38); // Eval big_Q step coeff_40 * z^40
    let t462 = circuit_add(t460, t461); // Eval big_Q step + (coeff_40 * z^40)
    let t463 = circuit_mul(in103, t39); // Eval big_Q step coeff_41 * z^41
    let t464 = circuit_add(t462, t463); // Eval big_Q step + (coeff_41 * z^41)
    let t465 = circuit_mul(in104, t40); // Eval big_Q step coeff_42 * z^42
    let t466 = circuit_add(t464, t465); // Eval big_Q step + (coeff_42 * z^42)
    let t467 = circuit_mul(in105, t41); // Eval big_Q step coeff_43 * z^43
    let t468 = circuit_add(t466, t467); // Eval big_Q step + (coeff_43 * z^43)
    let t469 = circuit_mul(in106, t42); // Eval big_Q step coeff_44 * z^44
    let t470 = circuit_add(t468, t469); // Eval big_Q step + (coeff_44 * z^44)
    let t471 = circuit_mul(in107, t43); // Eval big_Q step coeff_45 * z^45
    let t472 = circuit_add(t470, t471); // Eval big_Q step + (coeff_45 * z^45)
    let t473 = circuit_mul(in108, t44); // Eval big_Q step coeff_46 * z^46
    let t474 = circuit_add(t472, t473); // Eval big_Q step + (coeff_46 * z^46)
    let t475 = circuit_mul(in109, t45); // Eval big_Q step coeff_47 * z^47
    let t476 = circuit_add(t474, t475); // Eval big_Q step + (coeff_47 * z^47)
    let t477 = circuit_mul(in110, t46); // Eval big_Q step coeff_48 * z^48
    let t478 = circuit_add(t476, t477); // Eval big_Q step + (coeff_48 * z^48)
    let t479 = circuit_mul(in111, t47); // Eval big_Q step coeff_49 * z^49
    let t480 = circuit_add(t478, t479); // Eval big_Q step + (coeff_49 * z^49)
    let t481 = circuit_mul(in112, t48); // Eval big_Q step coeff_50 * z^50
    let t482 = circuit_add(t480, t481); // Eval big_Q step + (coeff_50 * z^50)
    let t483 = circuit_mul(in113, t49); // Eval big_Q step coeff_51 * z^51
    let t484 = circuit_add(t482, t483); // Eval big_Q step + (coeff_51 * z^51)
    let t485 = circuit_mul(in114, t50); // Eval big_Q step coeff_52 * z^52
    let t486 = circuit_add(t484, t485); // Eval big_Q step + (coeff_52 * z^52)
    let t487 = circuit_mul(in115, t51); // Eval big_Q step coeff_53 * z^53
    let t488 = circuit_add(t486, t487); // Eval big_Q step + (coeff_53 * z^53)
    let t489 = circuit_mul(in116, t52); // Eval big_Q step coeff_54 * z^54
    let t490 = circuit_add(t488, t489); // Eval big_Q step + (coeff_54 * z^54)
    let t491 = circuit_mul(in117, t53); // Eval big_Q step coeff_55 * z^55
    let t492 = circuit_add(t490, t491); // Eval big_Q step + (coeff_55 * z^55)
    let t493 = circuit_mul(in118, t54); // Eval big_Q step coeff_56 * z^56
    let t494 = circuit_add(t492, t493); // Eval big_Q step + (coeff_56 * z^56)
    let t495 = circuit_mul(in119, t55); // Eval big_Q step coeff_57 * z^57
    let t496 = circuit_add(t494, t495); // Eval big_Q step + (coeff_57 * z^57)
    let t497 = circuit_mul(in120, t56); // Eval big_Q step coeff_58 * z^58
    let t498 = circuit_add(t496, t497); // Eval big_Q step + (coeff_58 * z^58)
    let t499 = circuit_mul(in121, t57); // Eval big_Q step coeff_59 * z^59
    let t500 = circuit_add(t498, t499); // Eval big_Q step + (coeff_59 * z^59)
    let t501 = circuit_mul(in122, t58); // Eval big_Q step coeff_60 * z^60
    let t502 = circuit_add(t500, t501); // Eval big_Q step + (coeff_60 * z^60)
    let t503 = circuit_mul(in123, t59); // Eval big_Q step coeff_61 * z^61
    let t504 = circuit_add(t502, t503); // Eval big_Q step + (coeff_61 * z^61)
    let t505 = circuit_mul(in124, t60); // Eval big_Q step coeff_62 * z^62
    let t506 = circuit_add(t504, t505); // Eval big_Q step + (coeff_62 * z^62)
    let t507 = circuit_mul(in125, t61); // Eval big_Q step coeff_63 * z^63
    let t508 = circuit_add(t506, t507); // Eval big_Q step + (coeff_63 * z^63)
    let t509 = circuit_mul(in126, t62); // Eval big_Q step coeff_64 * z^64
    let t510 = circuit_add(t508, t509); // Eval big_Q step + (coeff_64 * z^64)
    let t511 = circuit_mul(in127, t63); // Eval big_Q step coeff_65 * z^65
    let t512 = circuit_add(t510, t511); // Eval big_Q step + (coeff_65 * z^65)
    let t513 = circuit_mul(in128, t64); // Eval big_Q step coeff_66 * z^66
    let t514 = circuit_add(t512, t513); // Eval big_Q step + (coeff_66 * z^66)
    let t515 = circuit_mul(in129, t65); // Eval big_Q step coeff_67 * z^67
    let t516 = circuit_add(t514, t515); // Eval big_Q step + (coeff_67 * z^67)
    let t517 = circuit_mul(in130, t66); // Eval big_Q step coeff_68 * z^68
    let t518 = circuit_add(t516, t517); // Eval big_Q step + (coeff_68 * z^68)
    let t519 = circuit_mul(in131, t67); // Eval big_Q step coeff_69 * z^69
    let t520 = circuit_add(t518, t519); // Eval big_Q step + (coeff_69 * z^69)
    let t521 = circuit_mul(in132, t68); // Eval big_Q step coeff_70 * z^70
    let t522 = circuit_add(t520, t521); // Eval big_Q step + (coeff_70 * z^70)
    let t523 = circuit_mul(in133, t69); // Eval big_Q step coeff_71 * z^71
    let t524 = circuit_add(t522, t523); // Eval big_Q step + (coeff_71 * z^71)
    let t525 = circuit_mul(in134, t70); // Eval big_Q step coeff_72 * z^72
    let t526 = circuit_add(t524, t525); // Eval big_Q step + (coeff_72 * z^72)
    let t527 = circuit_mul(in135, t71); // Eval big_Q step coeff_73 * z^73
    let t528 = circuit_add(t526, t527); // Eval big_Q step + (coeff_73 * z^73)
    let t529 = circuit_mul(in136, t72); // Eval big_Q step coeff_74 * z^74
    let t530 = circuit_add(t528, t529); // Eval big_Q step + (coeff_74 * z^74)
    let t531 = circuit_mul(in137, t73); // Eval big_Q step coeff_75 * z^75
    let t532 = circuit_add(t530, t531); // Eval big_Q step + (coeff_75 * z^75)
    let t533 = circuit_mul(in138, t74); // Eval big_Q step coeff_76 * z^76
    let t534 = circuit_add(t532, t533); // Eval big_Q step + (coeff_76 * z^76)
    let t535 = circuit_mul(in139, t75); // Eval big_Q step coeff_77 * z^77
    let t536 = circuit_add(t534, t535); // Eval big_Q step + (coeff_77 * z^77)
    let t537 = circuit_mul(in140, t76); // Eval big_Q step coeff_78 * z^78
    let t538 = circuit_add(t536, t537); // Eval big_Q step + (coeff_78 * z^78)
    let t539 = circuit_mul(in141, t77); // Eval big_Q step coeff_79 * z^79
    let t540 = circuit_add(t538, t539); // Eval big_Q step + (coeff_79 * z^79)
    let t541 = circuit_mul(in142, t78); // Eval big_Q step coeff_80 * z^80
    let t542 = circuit_add(t540, t541); // Eval big_Q step + (coeff_80 * z^80)
    let t543 = circuit_mul(in143, t79); // Eval big_Q step coeff_81 * z^81
    let t544 = circuit_add(t542, t543); // Eval big_Q step + (coeff_81 * z^81)
    let t545 = circuit_mul(in144, t80); // Eval big_Q step coeff_82 * z^82
    let t546 = circuit_add(t544, t545); // Eval big_Q step + (coeff_82 * z^82)
    let t547 = circuit_mul(in145, t81); // Eval big_Q step coeff_83 * z^83
    let t548 = circuit_add(t546, t547); // Eval big_Q step + (coeff_83 * z^83)
    let t549 = circuit_mul(in146, t82); // Eval big_Q step coeff_84 * z^84
    let t550 = circuit_add(t548, t549); // Eval big_Q step + (coeff_84 * z^84)
    let t551 = circuit_mul(in147, t83); // Eval big_Q step coeff_85 * z^85
    let t552 = circuit_add(t550, t551); // Eval big_Q step + (coeff_85 * z^85)
    let t553 = circuit_mul(in148, t84); // Eval big_Q step coeff_86 * z^86
    let t554 = circuit_add(t552, t553); // Eval big_Q step + (coeff_86 * z^86)
    let t555 = circuit_mul(in9, t4); // Eval sparse poly P_irr step coeff_6 * z^6
    let t556 = circuit_add(in8, t555); // Eval sparse poly P_irr step + coeff_6 * z^6
    let t557 = circuit_add(t556, t10); // Eval sparse poly P_irr step + 1*z^12
    let t558 = circuit_mul(t554, t557);
    let t559 = circuit_sub(t382, t558);

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [32324006162389411176778628423, 57042285082623239461879769745, 3486998266802970665, 0]
    )
        .unwrap();

    let mut circuit_inputs = (t559,).new_inputs();
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
    let final_check: u384 = outputs.get_output(t559);
    return (final_check,);
}
fn run_BN254_MP_CHECK_INIT_BIT_2_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    Q_0: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q_1: G2Point,
    R_i: E12D,
    c0: u384,
    z: u384,
    c_inv_of_z: u384,
    previous_lhs: u384
) -> (G2Point, G2Point, u384, u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x3
    let in1 = CE::<CI<1>> {}; // 0x6
    let in2 = CE::<CI<2>> {}; // 0x0
    let in3 = CE::<CI<3>> {}; // -0x9 % p
    let in4 = CE::<CI<4>> {}; // 0x1

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
    let t10 = circuit_mul(in18, in30); // Eval R step coeff_1 * z^1
    let t11 = circuit_add(in17, t10); // Eval R step + (coeff_1 * z^1)
    let t12 = circuit_mul(in19, t0); // Eval R step coeff_2 * z^2
    let t13 = circuit_add(t11, t12); // Eval R step + (coeff_2 * z^2)
    let t14 = circuit_mul(in20, t1); // Eval R step coeff_3 * z^3
    let t15 = circuit_add(t13, t14); // Eval R step + (coeff_3 * z^3)
    let t16 = circuit_mul(in21, t2); // Eval R step coeff_4 * z^4
    let t17 = circuit_add(t15, t16); // Eval R step + (coeff_4 * z^4)
    let t18 = circuit_mul(in22, t3); // Eval R step coeff_5 * z^5
    let t19 = circuit_add(t17, t18); // Eval R step + (coeff_5 * z^5)
    let t20 = circuit_mul(in23, t4); // Eval R step coeff_6 * z^6
    let t21 = circuit_add(t19, t20); // Eval R step + (coeff_6 * z^6)
    let t22 = circuit_mul(in24, t5); // Eval R step coeff_7 * z^7
    let t23 = circuit_add(t21, t22); // Eval R step + (coeff_7 * z^7)
    let t24 = circuit_mul(in25, t6); // Eval R step coeff_8 * z^8
    let t25 = circuit_add(t23, t24); // Eval R step + (coeff_8 * z^8)
    let t26 = circuit_mul(in26, t7); // Eval R step coeff_9 * z^9
    let t27 = circuit_add(t25, t26); // Eval R step + (coeff_9 * z^9)
    let t28 = circuit_mul(in27, t8); // Eval R step coeff_10 * z^10
    let t29 = circuit_add(t27, t28); // Eval R step + (coeff_10 * z^10)
    let t30 = circuit_mul(in28, t9); // Eval R step coeff_11 * z^11
    let t31 = circuit_add(t29, t30); // Eval R step + (coeff_11 * z^11)
    let t32 = circuit_mul(in31, in31);
    let t33 = circuit_mul(in29, in29);
    let t34 = circuit_add(in7, in8); // Doubling slope numerator start
    let t35 = circuit_sub(in7, in8);
    let t36 = circuit_mul(t34, t35);
    let t37 = circuit_mul(in7, in8);
    let t38 = circuit_mul(t36, in0);
    let t39 = circuit_mul(t37, in1); // Doubling slope numerator end
    let t40 = circuit_add(in9, in9); // Fp2 add coeff 0/1
    let t41 = circuit_add(in10, in10); // Fp2 add coeff 1/1
    let t42 = circuit_mul(t40, t40); // Fp2 Div x/y start : Fp2 Inv y start
    let t43 = circuit_mul(t41, t41);
    let t44 = circuit_add(t42, t43);
    let t45 = circuit_inverse(t44);
    let t46 = circuit_mul(t40, t45); // Fp2 Inv y real part end
    let t47 = circuit_mul(t41, t45);
    let t48 = circuit_sub(in2, t47); // Fp2 Inv y imag part end
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
    let t90 = circuit_mul(t84, in30); // Eval sparse poly line_0p_1 step coeff_1 * z^1
    let t91 = circuit_add(in4, t90); // Eval sparse poly line_0p_1 step + coeff_1 * z^1
    let t92 = circuit_mul(t87, t1); // Eval sparse poly line_0p_1 step coeff_3 * z^3
    let t93 = circuit_add(t91, t92); // Eval sparse poly line_0p_1 step + coeff_3 * z^3
    let t94 = circuit_mul(t88, t5); // Eval sparse poly line_0p_1 step coeff_7 * z^7
    let t95 = circuit_add(t93, t94); // Eval sparse poly line_0p_1 step + coeff_7 * z^7
    let t96 = circuit_mul(t89, t7); // Eval sparse poly line_0p_1 step coeff_9 * z^9
    let t97 = circuit_add(t95, t96); // Eval sparse poly line_0p_1 step + coeff_9 * z^9
    let t98 = circuit_mul(t32, t97);
    let t99 = circuit_add(in13, in14); // Doubling slope numerator start
    let t100 = circuit_sub(in13, in14);
    let t101 = circuit_mul(t99, t100);
    let t102 = circuit_mul(in13, in14);
    let t103 = circuit_mul(t101, in0);
    let t104 = circuit_mul(t102, in1); // Doubling slope numerator end
    let t105 = circuit_add(in15, in15); // Fp2 add coeff 0/1
    let t106 = circuit_add(in16, in16); // Fp2 add coeff 1/1
    let t107 = circuit_mul(t105, t105); // Fp2 Div x/y start : Fp2 Inv y start
    let t108 = circuit_mul(t106, t106);
    let t109 = circuit_add(t107, t108);
    let t110 = circuit_inverse(t109);
    let t111 = circuit_mul(t105, t110); // Fp2 Inv y real part end
    let t112 = circuit_mul(t106, t110);
    let t113 = circuit_sub(in2, t112); // Fp2 Inv y imag part end
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
    let t155 = circuit_mul(t149, in30); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t156 = circuit_add(in4, t155); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t157 = circuit_mul(t152, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t158 = circuit_add(t156, t157); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t159 = circuit_mul(t153, t5); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t160 = circuit_add(t158, t159); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t161 = circuit_mul(t154, t7); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t162 = circuit_add(t160, t161); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
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
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x6, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x6871ca8d3c208c16d87cfd3e, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0]);
    circuit_inputs = circuit_inputs.next([0x1, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(yInv_0);
    circuit_inputs = circuit_inputs.next(xNegOverY_0);
    circuit_inputs = circuit_inputs.next(Q_0.x0);
    circuit_inputs = circuit_inputs.next(Q_0.x1);
    circuit_inputs = circuit_inputs.next(Q_0.y0);
    circuit_inputs = circuit_inputs.next(Q_0.y1);
    circuit_inputs = circuit_inputs.next(yInv_1);
    circuit_inputs = circuit_inputs.next(xNegOverY_1);
    circuit_inputs = circuit_inputs.next(Q_1.x0);
    circuit_inputs = circuit_inputs.next(Q_1.x1);
    circuit_inputs = circuit_inputs.next(Q_1.y0);
    circuit_inputs = circuit_inputs.next(Q_1.y1);
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
fn run_BN254_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit(
    lambda_root: E12D,
    z: u384,
    scaling_factor: MillerLoopResultScalingFactor,
    c_inv: E12D,
    c_0: u384
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
        CI<10>
    > {}; // 0x1b007294a55accce13fe08bea73305ff6bdac77c5371c546d428780a6e3dcfa8
    let in11 = CE::<
        CI<11>
    > {}; // 0x215d42e7ac7bd17cefe88dd8e6965b3adae92c974f501fe811493d72543a3977
    let in12 = CE::<CI<12>> {}; // -0x1 % p
    let in13 = CE::<
        CI<13>
    > {}; // 0x246996f3b4fae7e6a6327cfe12150b8e747992778eeec7e5ca5cf05f80f362ac
    let in14 = CE::<
        CI<14>
    > {}; // 0x12d7c0c3ed42be419d2b22ca22ceca702eeb88c36a8b264dde75f4f798d6a3f2
    let in15 = CE::<
        CI<15>
    > {}; // 0x16c9e55061ebae204ba4cc8bd75a079432ae2a1d0b7c9dce1665d51c640fcba2
    let in16 = CE::<CI<16>> {}; // 0xc38dce27e3b2cae33ce738a184c89d94a0e78406b48f98a7b4f4463e3a7dba0
    let in17 = CE::<CI<17>> {}; // 0x7c03cbcac41049a0704b5a7ec796f2b21807dc98fa25bd282d37f632623b0e3
    let in18 = CE::<CI<18>> {}; // 0xf20e129e47c9363aa7b569817e0966cba582096fa7a164080faed1f0d24275a
    let in19 = CE::<
        CI<19>
    > {}; // 0x2c145edbe7fd8aee9f3a80b03b0b1c923685d2ea1bdec763c13b4711cd2b8126
    let in20 = CE::<CI<20>> {}; // 0x3df92c5b96e3914559897c6ad411fb25b75afb7f8b1c1a56586ff93e080f8bc
    let in21 = CE::<
        CI<21>
    > {}; // 0x12acf2ca76fd0675a27fb246c7729f7db080cb99678e2ac024c6b8ee6e0c2c4b
    let in22 = CE::<
        CI<22>
    > {}; // 0x1563dbde3bd6d35ba4523cf7da4e525e2ba6a3151500054667f8140c6a3f2d9f
    let in23 = CE::<
        CI<23>
    > {}; // 0x30644e72e131a0295e6dd9e7e0acccb0c28f069fbb966e3de4bd44e5607cfd49
    let in24 = CE::<
        CI<24>
    > {}; // 0x30644e72e131a0295e6dd9e7e0acccb0c28f069fbb966e3de4bd44e5607cfd48
    let in25 = CE::<CI<25>> {}; // 0x59e26bcea0d48bacd4f263f1acdb5c4f5763473177fffffe
    let in26 = CE::<CI<26>> {}; // 0x59e26bcea0d48bacd4f263f1acdb5c4f5763473177ffffff
    let in27 = CE::<
        CI<27>
    > {}; // 0x13d0c369615f7bb0b2bdfa8fef85fa07122bde8d67dfc8fabd3581ad840ddd76
    let in28 = CE::<
        CI<28>
    > {}; // 0x18a0f4219f4fdff6fc2bf531eb331a053a35744cac285af5685d3f90eacf7a66
    let in29 = CE::<CI<29>> {}; // 0xc3a5e9c462a654779c3e050c9ca2a428908a81264e2b5a5bf22f67654883ae6
    let in30 = CE::<
        CI<30>
    > {}; // 0x2ce02aa5f9bf8cd65bdd2055c255cf9d9e08c1d9345582cc92fd973c74bd77f4
    let in31 = CE::<
        CI<31>
    > {}; // 0x17ded419ed7be4f97fac149bfaefbac11b155498de227b850aea3f23790405d6
    let in32 = CE::<
        CI<32>
    > {}; // 0x1bfe7b214c0294242fb81a8dccd8a9b4441d64f34150a79753fb0cd31cc99cc0
    let in33 = CE::<CI<33>> {}; // 0x697b9c523e0390ed15da0ec97a9b8346513297b9efaf0f0f1a228f0d5662fbd
    let in34 = CE::<CI<34>> {}; // 0x7a0e052f2b1c443b5186d6ac4c723b85d3f78a3182d2db0c413901c32b0c6fe
    let in35 = CE::<
        CI<35>
    > {}; // 0x1b76a37fba85f3cd5dc79824a3792597356c892c39c0d06b220500933945267f
    let in36 = CE::<CI<36>> {}; // 0xabf8b60be77d7306cbeee33576139d7f03a5e397d439ec7694aa2bf4c0c101
    let in37 = CE::<
        CI<37>
    > {}; // 0x1c938b097fd2247905924b2691fb5e5685558c04009201927eeb0a69546f1fd1
    let in38 = CE::<CI<38>> {}; // 0x4f1de41b3d1766fa9f30e6dec26094f0fdf31bf98ff2631380cab2baaa586de
    let in39 = CE::<
        CI<39>
    > {}; // 0x2429efd69b073ae23e8c6565b7b72e1b0e78c27f038f14e77cfd95a083f4c261
    let in40 = CE::<
        CI<40>
    > {}; // 0x28a411b634f09b8fb14b900e9507e9327600ecc7d8cf6ebab94d0cb3b2594c64
    let in41 = CE::<
        CI<41>
    > {}; // 0x23d5e999e1910a12feb0f6ef0cd21d04a44a9e08737f96e55fe3ed9d730c239f
    let in42 = CE::<
        CI<42>
    > {}; // 0x1465d351952f0c0588982b28b4a8aea95364059e272122f5e8257f43bbb36087
    let in43 = CE::<
        CI<43>
    > {}; // 0x16db366a59b1dd0b9fb1b2282a48633d3e2ddaea200280211f25041384282499
    let in44 = CE::<
        CI<44>
    > {}; // 0x28c36e1fee7fdbe60337d84bbcba34a53a41f1ee50449cdc780cfbfaa5cc3649

    // INPUT stack
    let (in45, in46) = (CE::<CI<45>> {}, CE::<CI<46>> {});
    let (in47, in48) = (CE::<CI<47>> {}, CE::<CI<48>> {});
    let (in49, in50) = (CE::<CI<49>> {}, CE::<CI<50>> {});
    let (in51, in52) = (CE::<CI<51>> {}, CE::<CI<52>> {});
    let (in53, in54) = (CE::<CI<53>> {}, CE::<CI<54>> {});
    let (in55, in56) = (CE::<CI<55>> {}, CE::<CI<56>> {});
    let (in57, in58) = (CE::<CI<57>> {}, CE::<CI<58>> {});
    let (in59, in60) = (CE::<CI<59>> {}, CE::<CI<60>> {});
    let (in61, in62) = (CE::<CI<61>> {}, CE::<CI<62>> {});
    let (in63, in64) = (CE::<CI<63>> {}, CE::<CI<64>> {});
    let (in65, in66) = (CE::<CI<65>> {}, CE::<CI<66>> {});
    let (in67, in68) = (CE::<CI<67>> {}, CE::<CI<68>> {});
    let (in69, in70) = (CE::<CI<69>> {}, CE::<CI<70>> {});
    let (in71, in72) = (CE::<CI<71>> {}, CE::<CI<72>> {});
    let (in73, in74) = (CE::<CI<73>> {}, CE::<CI<74>> {});
    let (in75, in76) = (CE::<CI<75>> {}, CE::<CI<76>> {});
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
    let t66 = circuit_mul(t65, in76); // c_0 * (c_of_z * c_inv_of_z - 1)
    let t67 = circuit_mul(in70, in1);
    let t68 = circuit_add(in64, t67);
    let t69 = circuit_mul(in65, in2);
    let t70 = circuit_mul(in71, in3);
    let t71 = circuit_add(t69, t70);
    let t72 = circuit_mul(in66, in4);
    let t73 = circuit_mul(in72, in5);
    let t74 = circuit_add(t72, t73);
    let t75 = circuit_mul(in67, in6);
    let t76 = circuit_mul(in73, in7);
    let t77 = circuit_add(t75, t76);
    let t78 = circuit_mul(in68, in8);
    let t79 = circuit_mul(in74, in9);
    let t80 = circuit_add(t78, t79);
    let t81 = circuit_mul(in69, in10);
    let t82 = circuit_mul(in75, in11);
    let t83 = circuit_add(t81, t82);
    let t84 = circuit_mul(in70, in12);
    let t85 = circuit_mul(in65, in13);
    let t86 = circuit_mul(in71, in14);
    let t87 = circuit_add(t85, t86);
    let t88 = circuit_mul(in66, in15);
    let t89 = circuit_mul(in72, in16);
    let t90 = circuit_add(t88, t89);
    let t91 = circuit_mul(in67, in17);
    let t92 = circuit_mul(in73, in18);
    let t93 = circuit_add(t91, t92);
    let t94 = circuit_mul(in68, in19);
    let t95 = circuit_mul(in74, in20);
    let t96 = circuit_add(t94, t95);
    let t97 = circuit_mul(in69, in21);
    let t98 = circuit_mul(in75, in22);
    let t99 = circuit_add(t97, t98);
    let t100 = circuit_mul(in46, in23);
    let t101 = circuit_mul(in47, in24);
    let t102 = circuit_mul(in48, in12);
    let t103 = circuit_mul(in49, in25);
    let t104 = circuit_mul(in50, in26);
    let t105 = circuit_mul(in52, in23);
    let t106 = circuit_mul(in53, in24);
    let t107 = circuit_mul(in54, in12);
    let t108 = circuit_mul(in55, in25);
    let t109 = circuit_mul(in56, in26);
    let t110 = circuit_mul(in70, in1);
    let t111 = circuit_add(in64, t110);
    let t112 = circuit_mul(in65, in27);
    let t113 = circuit_mul(in71, in28);
    let t114 = circuit_add(t112, t113);
    let t115 = circuit_mul(in66, in29);
    let t116 = circuit_mul(in72, in30);
    let t117 = circuit_add(t115, t116);
    let t118 = circuit_mul(in67, in18);
    let t119 = circuit_mul(in73, in31);
    let t120 = circuit_add(t118, t119);
    let t121 = circuit_mul(in68, in32);
    let t122 = circuit_mul(in74, in33);
    let t123 = circuit_add(t121, t122);
    let t124 = circuit_mul(in69, in34);
    let t125 = circuit_mul(in75, in35);
    let t126 = circuit_add(t124, t125);
    let t127 = circuit_mul(in70, in12);
    let t128 = circuit_mul(in65, in36);
    let t129 = circuit_mul(in71, in37);
    let t130 = circuit_add(t128, t129);
    let t131 = circuit_mul(in66, in38);
    let t132 = circuit_mul(in72, in39);
    let t133 = circuit_add(t131, t132);
    let t134 = circuit_mul(in67, in40);
    let t135 = circuit_mul(in73, in6);
    let t136 = circuit_add(t134, t135);
    let t137 = circuit_mul(in68, in41);
    let t138 = circuit_mul(in74, in42);
    let t139 = circuit_add(t137, t138);
    let t140 = circuit_mul(in69, in43);
    let t141 = circuit_mul(in75, in44);
    let t142 = circuit_add(t140, t141);
    let t143 = circuit_mul(t71, in57); // Eval C_inv_frob_1 step coeff_1 * z^1
    let t144 = circuit_add(t68, t143); // Eval C_inv_frob_1 step + (coeff_1 * z^1)
    let t145 = circuit_mul(t74, t0); // Eval C_inv_frob_1 step coeff_2 * z^2
    let t146 = circuit_add(t144, t145); // Eval C_inv_frob_1 step + (coeff_2 * z^2)
    let t147 = circuit_mul(t77, t1); // Eval C_inv_frob_1 step coeff_3 * z^3
    let t148 = circuit_add(t146, t147); // Eval C_inv_frob_1 step + (coeff_3 * z^3)
    let t149 = circuit_mul(t80, t2); // Eval C_inv_frob_1 step coeff_4 * z^4
    let t150 = circuit_add(t148, t149); // Eval C_inv_frob_1 step + (coeff_4 * z^4)
    let t151 = circuit_mul(t83, t3); // Eval C_inv_frob_1 step coeff_5 * z^5
    let t152 = circuit_add(t150, t151); // Eval C_inv_frob_1 step + (coeff_5 * z^5)
    let t153 = circuit_mul(t84, t4); // Eval C_inv_frob_1 step coeff_6 * z^6
    let t154 = circuit_add(t152, t153); // Eval C_inv_frob_1 step + (coeff_6 * z^6)
    let t155 = circuit_mul(t87, t5); // Eval C_inv_frob_1 step coeff_7 * z^7
    let t156 = circuit_add(t154, t155); // Eval C_inv_frob_1 step + (coeff_7 * z^7)
    let t157 = circuit_mul(t90, t6); // Eval C_inv_frob_1 step coeff_8 * z^8
    let t158 = circuit_add(t156, t157); // Eval C_inv_frob_1 step + (coeff_8 * z^8)
    let t159 = circuit_mul(t93, t7); // Eval C_inv_frob_1 step coeff_9 * z^9
    let t160 = circuit_add(t158, t159); // Eval C_inv_frob_1 step + (coeff_9 * z^9)
    let t161 = circuit_mul(t96, t8); // Eval C_inv_frob_1 step coeff_10 * z^10
    let t162 = circuit_add(t160, t161); // Eval C_inv_frob_1 step + (coeff_10 * z^10)
    let t163 = circuit_mul(t99, t9); // Eval C_inv_frob_1 step coeff_11 * z^11
    let t164 = circuit_add(t162, t163); // Eval C_inv_frob_1 step + (coeff_11 * z^11)
    let t165 = circuit_mul(t100, in57); // Eval C_frob_2 step coeff_1 * z^1
    let t166 = circuit_add(in45, t165); // Eval C_frob_2 step + (coeff_1 * z^1)
    let t167 = circuit_mul(t101, t0); // Eval C_frob_2 step coeff_2 * z^2
    let t168 = circuit_add(t166, t167); // Eval C_frob_2 step + (coeff_2 * z^2)
    let t169 = circuit_mul(t102, t1); // Eval C_frob_2 step coeff_3 * z^3
    let t170 = circuit_add(t168, t169); // Eval C_frob_2 step + (coeff_3 * z^3)
    let t171 = circuit_mul(t103, t2); // Eval C_frob_2 step coeff_4 * z^4
    let t172 = circuit_add(t170, t171); // Eval C_frob_2 step + (coeff_4 * z^4)
    let t173 = circuit_mul(t104, t3); // Eval C_frob_2 step coeff_5 * z^5
    let t174 = circuit_add(t172, t173); // Eval C_frob_2 step + (coeff_5 * z^5)
    let t175 = circuit_mul(in51, t4); // Eval C_frob_2 step coeff_6 * z^6
    let t176 = circuit_add(t174, t175); // Eval C_frob_2 step + (coeff_6 * z^6)
    let t177 = circuit_mul(t105, t5); // Eval C_frob_2 step coeff_7 * z^7
    let t178 = circuit_add(t176, t177); // Eval C_frob_2 step + (coeff_7 * z^7)
    let t179 = circuit_mul(t106, t6); // Eval C_frob_2 step coeff_8 * z^8
    let t180 = circuit_add(t178, t179); // Eval C_frob_2 step + (coeff_8 * z^8)
    let t181 = circuit_mul(t107, t7); // Eval C_frob_2 step coeff_9 * z^9
    let t182 = circuit_add(t180, t181); // Eval C_frob_2 step + (coeff_9 * z^9)
    let t183 = circuit_mul(t108, t8); // Eval C_frob_2 step coeff_10 * z^10
    let t184 = circuit_add(t182, t183); // Eval C_frob_2 step + (coeff_10 * z^10)
    let t185 = circuit_mul(t109, t9); // Eval C_frob_2 step coeff_11 * z^11
    let t186 = circuit_add(t184, t185); // Eval C_frob_2 step + (coeff_11 * z^11)
    let t187 = circuit_mul(t114, in57); // Eval C_inv_frob_3 step coeff_1 * z^1
    let t188 = circuit_add(t111, t187); // Eval C_inv_frob_3 step + (coeff_1 * z^1)
    let t189 = circuit_mul(t117, t0); // Eval C_inv_frob_3 step coeff_2 * z^2
    let t190 = circuit_add(t188, t189); // Eval C_inv_frob_3 step + (coeff_2 * z^2)
    let t191 = circuit_mul(t120, t1); // Eval C_inv_frob_3 step coeff_3 * z^3
    let t192 = circuit_add(t190, t191); // Eval C_inv_frob_3 step + (coeff_3 * z^3)
    let t193 = circuit_mul(t123, t2); // Eval C_inv_frob_3 step coeff_4 * z^4
    let t194 = circuit_add(t192, t193); // Eval C_inv_frob_3 step + (coeff_4 * z^4)
    let t195 = circuit_mul(t126, t3); // Eval C_inv_frob_3 step coeff_5 * z^5
    let t196 = circuit_add(t194, t195); // Eval C_inv_frob_3 step + (coeff_5 * z^5)
    let t197 = circuit_mul(t127, t4); // Eval C_inv_frob_3 step coeff_6 * z^6
    let t198 = circuit_add(t196, t197); // Eval C_inv_frob_3 step + (coeff_6 * z^6)
    let t199 = circuit_mul(t130, t5); // Eval C_inv_frob_3 step coeff_7 * z^7
    let t200 = circuit_add(t198, t199); // Eval C_inv_frob_3 step + (coeff_7 * z^7)
    let t201 = circuit_mul(t133, t6); // Eval C_inv_frob_3 step coeff_8 * z^8
    let t202 = circuit_add(t200, t201); // Eval C_inv_frob_3 step + (coeff_8 * z^8)
    let t203 = circuit_mul(t136, t7); // Eval C_inv_frob_3 step coeff_9 * z^9
    let t204 = circuit_add(t202, t203); // Eval C_inv_frob_3 step + (coeff_9 * z^9)
    let t205 = circuit_mul(t139, t8); // Eval C_inv_frob_3 step coeff_10 * z^10
    let t206 = circuit_add(t204, t205); // Eval C_inv_frob_3 step + (coeff_10 * z^10)
    let t207 = circuit_mul(t142, t9); // Eval C_inv_frob_3 step coeff_11 * z^11
    let t208 = circuit_add(t206, t207); // Eval C_inv_frob_3 step + (coeff_11 * z^11)

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [32324006162389411176778628423, 57042285082623239461879769745, 3486998266802970665, 0]
    )
        .unwrap();

    let mut circuit_inputs = (t31, t41, t63, t66, t164, t186, t208,).new_inputs();
    // Prefill constants:
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
    let in0 = CE::<CI<0>> {}; // 0x0

    // INPUT stack
    let (in1, in2) = (CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4) = (CE::<CI<3>> {}, CE::<CI<4>> {});
    let (in5, in6) = (CE::<CI<5>> {}, CE::<CI<6>> {});
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
    let in0 = CE::<CI<0>> {}; // 0x0

    // INPUT stack
    let (in1, in2) = (CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4) = (CE::<CI<3>> {}, CE::<CI<4>> {});
    let (in5, in6) = (CE::<CI<5>> {}, CE::<CI<6>> {});
    let (in7, in8) = (CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10) = (CE::<CI<9>> {}, CE::<CI<10>> {});
    let (in11, in12) = (CE::<CI<11>> {}, CE::<CI<12>> {});
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
        MillerLoopResultScalingFactor, G2Line
    };
    use garaga::ec_ops::{SlopeInterceptOutput, FunctionFeltEvaluations, FunctionFelt};

    use super::{
        run_BLS12_381_MP_CHECK_BIT00_LOOP_2_circuit, run_BLS12_381_MP_CHECK_BIT0_LOOP_2_circuit,
        run_BLS12_381_MP_CHECK_BIT1_LOOP_2_circuit, run_BLS12_381_MP_CHECK_FINALIZE_BLS_2_circuit,
        run_BLS12_381_MP_CHECK_INIT_BIT_2_circuit,
        run_BLS12_381_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit,
        run_BLS12_381_MP_CHECK_PREPARE_PAIRS_2_circuit,
        run_BLS12_381_MP_CHECK_PREPARE_PAIRS_3_circuit, run_BN254_MP_CHECK_BIT00_LOOP_2_circuit,
        run_BN254_MP_CHECK_BIT0_LOOP_2_circuit, run_BN254_MP_CHECK_BIT1_LOOP_2_circuit,
        run_BN254_MP_CHECK_FINALIZE_BN_2_circuit, run_BN254_MP_CHECK_INIT_BIT_2_circuit,
        run_BN254_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit, run_BN254_MP_CHECK_PREPARE_PAIRS_2_circuit,
        run_BN254_MP_CHECK_PREPARE_PAIRS_3_circuit
    };


    #[test]
    fn test_run_BLS12_381_MP_CHECK_BIT00_LOOP_2_circuit_BLS12_381() {
        let yInv_0: u384 = u384 {
            limb0: 0x3df66b5e064c0fef206eb611,
            limb1: 0x7f5885309cb2915c22a0894b,
            limb2: 0xf95a16568ff27c2734586ce8,
            limb3: 0x153da052dde763638d8bd6e8
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0xf418d36fe5a620127eb873a6,
            limb1: 0x9ca41b580e01f0017ffed37b,
            limb2: 0x78c0aefd8d109ac4a87c35ff,
            limb3: 0x905af60b5be161deda995b
        };

        let Q_0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x9e0516bcb8fc3b17b28f5ba2,
                limb1: 0xd811a6c0afeb8e2419c2337d,
                limb2: 0x13c27bb7934055bf3a696460,
                limb3: 0x4d85b773dd2071a8a0492d9
            },
            x1: u384 {
                limb0: 0xa8d44ca7918a43256c910628,
                limb1: 0xc47f3f2bb964a0c7a6702775,
                limb2: 0xd35af022c914e4e54de2f84f,
                limb3: 0x14f679fca2b7b4182448c239
            },
            y0: u384 {
                limb0: 0xf971ff8f426f591636c97c16,
                limb1: 0xe64ad344e8b7862e9d32af13,
                limb2: 0x92415203d6a60cb9cbf383f6,
                limb3: 0x8f9ce4f4b2574647591789b
            },
            y1: u384 {
                limb0: 0x414c27c8aff2b72925b6d5a5,
                limb1: 0xb61219ad8c11dd8639f983b4,
                limb2: 0x3ed0141c34d784096ab66d58,
                limb3: 0x1463edcad79e4d6d5cb7471
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0x22cb5abac78b7adf8203ab52,
            limb1: 0x96d4e7ce4665f27cde223401,
            limb2: 0x439d89bb38f3fd4f5c2bee92,
            limb3: 0x199fd686f12e50e4ea4da1a9
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0xcf956635d9c165b3380d30b4,
            limb1: 0x860c7c6d04aa8f0fbeadb749,
            limb2: 0x133df6e9b5b317189a7cc3b3,
            limb3: 0x1141204b44ea95577e3aea20
        };

        let Q_1: G2Point = G2Point {
            x0: u384 {
                limb0: 0xb9a3e7d2c8dc9079c6305724,
                limb1: 0x4797817842ac906fc743aedb,
                limb2: 0xd8c2b8af4a685a008a4177e0,
                limb3: 0x1277a0a356d512a3ac7aca00
            },
            x1: u384 {
                limb0: 0xbbd1183200f151944a60133b,
                limb1: 0x5d89735200d906afd61aac3d,
                limb2: 0x6025de1c1fdbdbfab7bb0adc,
                limb3: 0xb552764d0a7b26fd7b4a55a
            },
            y0: u384 {
                limb0: 0x7f9a63fb988d1a5be29eea29,
                limb1: 0xb40aaa7c7ad4b385c874d5df,
                limb2: 0xcbacc1598e3321f65db5be3e,
                limb3: 0x947c2e2871968c27f20af9
            },
            y1: u384 {
                limb0: 0x46740c3e4d69ac143367a0a4,
                limb1: 0xb8f4665798d83675770ba616,
                limb2: 0x4d73e48039ec46d04218e573,
                limb3: 0x49fec9284f0c4370fbeb72d
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 0x216c9bc3092a2222819e5646,
            limb1: 0x3886c62eccf9ebd42645f7dd,
            limb2: 0x12ce40a3c0f7cb467d9c104f,
            limb3: 0x1769490e9b6c5fcdb4fa21f
        };

        let f_i_of_z: u384 = u384 {
            limb0: 0x74df61389ab81571186da5b,
            limb1: 0xe4627a5a00a885e9eec81ca8,
            limb2: 0x532221e2fcb0959b8b940dfd,
            limb3: 0xb94a08510c2d392a9dba34c
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 0x785f60a7376688560b9714b0,
                limb1: 0x94308f87121836b88c5574cc,
                limb2: 0xbe07a51bca2712ba332748a6,
                limb3: 0x9dda1b24f25da42c1d5ff3c
            },
            w1: u384 {
                limb0: 0xa0447a08f89ea4885801f10c,
                limb1: 0xdbb5f55f9cdc964ff7c6c8e,
                limb2: 0xdc880a29d745ddd00fc7a6d2,
                limb3: 0xa23983b73bd852ca5fbb346
            },
            w2: u384 {
                limb0: 0x606ae32b89877942eacef95f,
                limb1: 0xe8dcd8840b0e52d50be1a657,
                limb2: 0xee1914160409a9978408d6d9,
                limb3: 0x249e9ec8d03deec2f5a0b3b
            },
            w3: u384 {
                limb0: 0xade3b5be7cfc61cc3dc0a91c,
                limb1: 0xffb695548dcde1b3c8b7cf16,
                limb2: 0x3d2c163680428d4c8da8e8b1,
                limb3: 0xe287f1f38705dda0f081258
            },
            w4: u384 {
                limb0: 0xf9813b85187dd9c6790a674a,
                limb1: 0xb7345e6adf01d2aeaaa0f9b8,
                limb2: 0xadc3324b51d4e883bac07cab,
                limb3: 0x14bb177d6e015bad88560352
            },
            w5: u384 {
                limb0: 0xc27eb997718c4d399298fe29,
                limb1: 0x3f4f87383d7082f091e75aca,
                limb2: 0xbbf6da7c447a62431124e8bf,
                limb3: 0xc8b89437bc6c72c602f17a8
            },
            w6: u384 {
                limb0: 0x49d927a82e287dbfa959d2dd,
                limb1: 0x4aef5cd4b55cece1f331dc69,
                limb2: 0x9a922722efc59651dd35632a,
                limb3: 0x6ca3b3d0162a1fb430851aa
            },
            w7: u384 {
                limb0: 0x398a306adb881f17d0af525e,
                limb1: 0x1c3ba8a7790ffbb3b193b0c,
                limb2: 0x658df18fd5ee9dd716d9b315,
                limb3: 0x22daba6e4a85e2b52863cd3
            },
            w8: u384 {
                limb0: 0xb6d8d3a5028dba177f301ca3,
                limb1: 0xa8c700b57379f4cc5db914eb,
                limb2: 0x465d29d30cb220497ec94efc,
                limb3: 0x8b0e2cead44b87e906a2c81
            },
            w9: u384 {
                limb0: 0xe76fb8872c4533ea33cb1b20,
                limb1: 0x8f0d3721d764106199d081be,
                limb2: 0x834cff3c409936ef40dd73a3,
                limb3: 0x196d49c9f44002b216a31263
            },
            w10: u384 {
                limb0: 0x1b0453f8cc977c6bda927e28,
                limb1: 0xf72d378f6871e510fdeeb32f,
                limb2: 0xe11fe602874bf5fa608a806c,
                limb3: 0x2065f70f62cdc39eccd4523
            },
            w11: u384 {
                limb0: 0xa4819363590cab8ec595bcf7,
                limb1: 0xda11d2c943e6ad9b9e7e0170,
                limb2: 0x7225b32c6dfede0d43bf6504,
                limb3: 0xd158a3168a0929072c80696
            }
        };

        let z: u384 = u384 {
            limb0: 0x87da2cb58a280863e186d588,
            limb1: 0x9ceac06e8e427589e3bbcdad,
            limb2: 0xcf7740f36b42914294a2f109,
            limb3: 0x986e87d7919017b463619a
        };

        let ci: u384 = u384 {
            limb0: 0x666556392ef25fbf515bff5b,
            limb1: 0xe73c115db9c13062dd05ed91,
            limb2: 0x86a284e8fb4fd6c2b1124849,
            limb3: 0x1213a084cde0daeb6a017da
        };

        let (
            Q0_result,
            Q1_result,
            f_i_plus_one_of_z_result,
            lhs_i_plus_one_result,
            ci_plus_one_result
        ) =
            run_BLS12_381_MP_CHECK_BIT00_LOOP_2_circuit(
            yInv_0, xNegOverY_0, Q_0, yInv_1, xNegOverY_1, Q_1, lhs_i, f_i_of_z, f_i_plus_one, z, ci
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x97313769c99452d42ded6805,
                limb1: 0x3eded4e5f598a66ebc32cabd,
                limb2: 0x6a89ccf3ecc4e434af5c1617,
                limb3: 0x743ed598f1a96452d4a5c70
            },
            x1: u384 {
                limb0: 0x24e21cb136cb581780d56be8,
                limb1: 0xd44be3a94d0dde2fa7c240bb,
                limb2: 0xf537eac21dada8b221b4df7,
                limb3: 0x11cdf9068f029163dfce0473
            },
            y0: u384 {
                limb0: 0xdb582c9d80dae9fb1ec468a8,
                limb1: 0xd033653e7bf08f0dfc2e8102,
                limb2: 0xe874c1d018d4955bc77dd8b6,
                limb3: 0x103d7d1dd6a24e3210b25d10
            },
            y1: u384 {
                limb0: 0xa7f8d1b089b3aac4a7093887,
                limb1: 0xa908b29a5e98a3bbfa9923fa,
                limb2: 0x433653041bf215d0f61b25da,
                limb3: 0x3fcd471f976576643ce260
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x9484bee6c5c3beb2efd08c8b,
                limb1: 0xb5079560726f5aced56f8c9e,
                limb2: 0x9ecf31c1075e5654f5e2929,
                limb3: 0x192d9d90d6b8592440b461eb
            },
            x1: u384 {
                limb0: 0x74d4d3c335d47769e678a2e,
                limb1: 0x852fef90982c5b932d8dd258,
                limb2: 0x20c070e61585e4a28acda7a3,
                limb3: 0xc2f2672d26010d41959a995
            },
            y0: u384 {
                limb0: 0x6ad495f7c2798699bb5ef26f,
                limb1: 0x1ed5c7408a247ca58364fe27,
                limb2: 0x247846a9f969a35d3d81db4c,
                limb3: 0xdcff204f9af1c575d0d9316
            },
            y1: u384 {
                limb0: 0xa20d1cf168731eb44c234003,
                limb1: 0xacec6d521dae28a82f339325,
                limb2: 0x4a94b746840d9b416281ca10,
                limb3: 0x5d5ebf6979e2d09d7c26fc
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0xb57f60adab14c1edcd9ee9d0,
            limb1: 0x6df205907934e10147e6ee5d,
            limb2: 0x303e9664e9ae97931fae65fa,
            limb3: 0x116af16844cc8901493edf3
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 0xb25db7d9b66918c34a4f3d9f,
            limb1: 0xa782fe018df95fc94a177d7d,
            limb2: 0xf8cb3d488ddaf75b799965fe,
            limb3: 0x6eaa4051896aa5469187303
        };

        let ci_plus_one: u384 = u384 {
            limb0: 0x7797dc046bacdf22ee31d93a,
            limb1: 0x75d1ff65d82535e165e7c5bc,
            limb2: 0xace0da82de966a5a0b1a6beb,
            limb3: 0xa0eb8c844ca6848d661d52f
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
        assert_eq!(lhs_i_plus_one_result, lhs_i_plus_one);
        assert_eq!(ci_plus_one_result, ci_plus_one);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_BIT0_LOOP_2_circuit_BLS12_381() {
        let yInv_0: u384 = u384 {
            limb0: 0x599d9000ba179e2f54ed0e60,
            limb1: 0x20a22b16cf1e6ccf9ad098f6,
            limb2: 0x938d45104ed0cd4d5850e5c2,
            limb3: 0x1091ace82489373b75fa9dc0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0x4ea1871534708c02e1530b8f,
            limb1: 0x23d3f42c751c368015cb2927,
            limb2: 0x2a173c6a1dd9c6e34058edef,
            limb3: 0x10680e9af06da6da5c0336c1
        };

        let Q_0: G2Point = G2Point {
            x0: u384 {
                limb0: 0xed796d007a382a53b4273b04,
                limb1: 0xfc558b980a66713a942371e1,
                limb2: 0x9981fd1decc5abef8d73a20b,
                limb3: 0x15a281fef6d1fdda2f0cb02d
            },
            x1: u384 {
                limb0: 0xa22a45f96b5a8e04b76a548c,
                limb1: 0x260845744ab05ee33755744,
                limb2: 0x975fc838a1ba4586e54d37a1,
                limb3: 0x1525969400403cf559bbb4dc
            },
            y0: u384 {
                limb0: 0x93fde11fb674bb4c633609a2,
                limb1: 0x204ede013ef096e4499e9ebb,
                limb2: 0x1960db478ec7f527d9d2a887,
                limb3: 0x11d9e7efcd3ddc5d589e6978
            },
            y1: u384 {
                limb0: 0xd58bac20b07f037e359efb02,
                limb1: 0xc057b446a7d0178630782287,
                limb2: 0x8501bca8de7cd151befebeb5,
                limb3: 0x14b779d7d242f9266980d01d
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0xc0faf70f6fe2b89d297a2fa0,
            limb1: 0x4655114404f896dca229d3df,
            limb2: 0x15d3c9bad82d87e440408119,
            limb3: 0x97067c473bb649a009634b2
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0xe1eac6fac7382fd946b82037,
            limb1: 0x6b3beb4f0a676a615dcfaefc,
            limb2: 0xe086f500f208075cc31b16d0,
            limb3: 0x15aea089ea4246f0857cabe
        };

        let Q_1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x714bb79b8ad161327d01d0,
                limb1: 0x3389897c160b3ffa251a45b2,
                limb2: 0xa47f038282d95410d3bfecab,
                limb3: 0xd07da41e7e5bbb5653d2dd1
            },
            x1: u384 {
                limb0: 0x1bad72f550dae03db25b8444,
                limb1: 0x3def65bfa46d6bca19c502db,
                limb2: 0xa057b678157245a650d2b98b,
                limb3: 0x110b02342df0fd012ded524b
            },
            y0: u384 {
                limb0: 0xb464a07f3c4439abcbebc040,
                limb1: 0x9c5ea35b866294bf7c6000ec,
                limb2: 0x6e999c4617fafba09a4eb610,
                limb3: 0x769c26983674cb1909c0f91
            },
            y1: u384 {
                limb0: 0x55a7b1bab76ba3668250b447,
                limb1: 0x83ce962b456f7d31e5c85b51,
                limb2: 0x1bfff4d071a48a0161c02f4c,
                limb3: 0x14db2bb8000ac08690ee93b9
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 0x2ebda4e75f26595e0c054854,
            limb1: 0x3f3d0382194cceeff9e78a22,
            limb2: 0xd4f7e1c684ea82e35bdfd814,
            limb3: 0x18131a5008e5af8ef3b0eae2
        };

        let f_i_of_z: u384 = u384 {
            limb0: 0xf0b871778c51943d54e964d4,
            limb1: 0x394ba37c928b66d53c71efbd,
            limb2: 0xde13865c16e7792051207f9c,
            limb3: 0x2956a96c114d97facee452f
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 0xe21d8459194e36b30e016456,
                limb1: 0x523c9ef4eb002884ef1cc4d8,
                limb2: 0xa0cf5cdd63edc7e07ff6815e,
                limb3: 0xfec5dc36767733eb070bdcb
            },
            w1: u384 {
                limb0: 0xa185a46d5be9d91857a798d8,
                limb1: 0x21c7dfdec59690b60be31109,
                limb2: 0x8b06b16917d6f52e72c78a99,
                limb3: 0xd3912fb22f4260d57620ecd
            },
            w2: u384 {
                limb0: 0x71b2caba0800f129579704ad,
                limb1: 0x683ce69ce463f3a0ebceb340,
                limb2: 0x5b434e022c29e2c59c6a858e,
                limb3: 0xee20da2cdff3c3177736131
            },
            w3: u384 {
                limb0: 0x3f0ed11d137b75328b36e20e,
                limb1: 0x16fb588cde44ea1ce188ea61,
                limb2: 0x6aadd5ee2d9a54629b7f3e35,
                limb3: 0x7b1570b70e86f99fbf2a7a3
            },
            w4: u384 {
                limb0: 0xaca29647c7fab649e2631aac,
                limb1: 0x9d3337cbfd61c6fc4d1aa07e,
                limb2: 0x1b94cb709d1a45ceabdcc286,
                limb3: 0x19663a5c7e41e579012f127e
            },
            w5: u384 {
                limb0: 0x40874fe0efeeadca2e5ed03,
                limb1: 0xb16222de27dc7d9de43ed5f7,
                limb2: 0xd5d816ebe6ee166a528419a,
                limb3: 0xf51cdecb57302b3c9dff09c
            },
            w6: u384 {
                limb0: 0x356a509c05aa62fab72f51d3,
                limb1: 0xf57bbe581134ea8cf9e7168e,
                limb2: 0xc7a9cc2589baedaa27754a94,
                limb3: 0xcd55c4032fc4ab1012d87ce
            },
            w7: u384 {
                limb0: 0xf4bcff43a34ae853c7bfd565,
                limb1: 0x8d6efae1b4e205e4bc40bfa5,
                limb2: 0xc8ea4e96a92410dfce890d5b,
                limb3: 0xf47b5a9bb7b2188b83fe6d7
            },
            w8: u384 {
                limb0: 0xbadf79f7b45d072e7078c9f4,
                limb1: 0x7c5971932cb77d6ce07858fa,
                limb2: 0x12fdd31232b4d46ddc89a69c,
                limb3: 0xfb156976e294c431a56210
            },
            w9: u384 {
                limb0: 0xd65c037ac8a4e00653032234,
                limb1: 0xd8e0306962ed056de1ea85b2,
                limb2: 0xafed0efad277c0ac1e1b07c6,
                limb3: 0xc51130c2e94de1665e8adc8
            },
            w10: u384 {
                limb0: 0xba39597f9c06aff7e911f243,
                limb1: 0x6c4862a4bd66a2108b9db228,
                limb2: 0xf43232732d43ac7d4fc69972,
                limb3: 0x11a8916a69ad665de9e521b4
            },
            w11: u384 {
                limb0: 0xa755109fe92580904462ae96,
                limb1: 0x1ed1abd0d30e75f68627f10f,
                limb2: 0x6a6f0a87c980a520eff16463,
                limb3: 0x177846b8bd386d03d6b5059a
            }
        };

        let z: u384 = u384 {
            limb0: 0xed5156595992cd37167ff19c,
            limb1: 0xc6e8cc67025b57b4a3246a33,
            limb2: 0x4bf34dfe7b35556c8a9fca2c,
            limb3: 0x1232211663dfcae1ba9b5928
        };

        let ci: u384 = u384 {
            limb0: 0xd20a3b503ad25d095cd509a0,
            limb1: 0xf56db9ae4ecf57323f6ed3e2,
            limb2: 0x6e4d0cd140ea6c2ee0ebfc5e,
            limb3: 0x904d444471d3e476fe63236
        };

        let (
            Q0_result,
            Q1_result,
            f_i_plus_one_of_z_result,
            lhs_i_plus_one_result,
            ci_plus_one_result
        ) =
            run_BLS12_381_MP_CHECK_BIT0_LOOP_2_circuit(
            yInv_0, xNegOverY_0, Q_0, yInv_1, xNegOverY_1, Q_1, lhs_i, f_i_of_z, f_i_plus_one, z, ci
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 0xb7d2151ff1e1902c671ae90f,
                limb1: 0x1dc1d847f3ce0c39d3416799,
                limb2: 0x974fa9b23b974b2ff04faab2,
                limb3: 0xa4de305114196cd0acb7a87
            },
            x1: u384 {
                limb0: 0x4758bcaab4711bf2c7cf49e6,
                limb1: 0x39dd85684d50d750f0b858ab,
                limb2: 0x364e2a56fc016f9f4fe148fc,
                limb3: 0xaf2f050752de8504b6b330b
            },
            y0: u384 {
                limb0: 0x263cc716ce7a70c343388247,
                limb1: 0xf009451398b60c578d482a81,
                limb2: 0x43aa2baff0c039ab2430ac6e,
                limb3: 0x12dd2dac8c7e38c5ec58d5d
            },
            y1: u384 {
                limb0: 0xd3b5a24594320c9b22adcf62,
                limb1: 0xb43af9fff0b5a12e2f8c87d9,
                limb2: 0x147ca5af4fcd7a039d6c891f,
                limb3: 0x1e33f650db9380960f36f5b
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x2e2cd38f36350960740bc804,
                limb1: 0xa3505ee03dd79c7da6bd5ebe,
                limb2: 0xa835e965ac375189f01dd4bc,
                limb3: 0x5e275bdfed5e9c203c87d97
            },
            x1: u384 {
                limb0: 0xd6e93451508d6155e95f7a,
                limb1: 0xbc166476ac2ce0384e407669,
                limb2: 0x384656e8ec783c37a6c6e381,
                limb3: 0x82b6e0e870a503b94602dee
            },
            y0: u384 {
                limb0: 0x78532efa8a9b306553a11948,
                limb1: 0x88320b23443d5d6f20573e64,
                limb2: 0xfc2096fbbbb7e449166b6ac0,
                limb3: 0xab1717c92b36db56517e13e
            },
            y1: u384 {
                limb0: 0xc506c1fb9ae3a4a357704763,
                limb1: 0x6c8b111a499aede89fa89042,
                limb2: 0xb0a946262cfae801dd835f20,
                limb3: 0xb63ac7db7c04cd30a03df92
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0x81852833d4281e176d1800df,
            limb1: 0x79be4eebb8810da7078e80b,
            limb2: 0x7cd993996f30f0e4c460bd09,
            limb3: 0xb46d1e96db138720dc891aa
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 0x6b07aa1fdcc6202cdef22286,
            limb1: 0x74f6b6f69426db3a5209a233,
            limb2: 0x9f2d9ca26308c608bdfeda12,
            limb3: 0xb5e7570f63122a3ce8fffb7
        };

        let ci_plus_one: u384 = u384 {
            limb0: 0x172061705b9305319498d8f1,
            limb1: 0x554199a29c2ac274af0397fd,
            limb2: 0xa32fda06995a7eeb9bbbdc66,
            limb3: 0x5fdcd35b1408e73ba967d8f
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
        assert_eq!(lhs_i_plus_one_result, lhs_i_plus_one);
        assert_eq!(ci_plus_one_result, ci_plus_one);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_BIT1_LOOP_2_circuit_BLS12_381() {
        let yInv_0: u384 = u384 {
            limb0: 0xc617d62fd00071b1b2864c8f,
            limb1: 0xbeb40c32ade8c24452d40816,
            limb2: 0x7b31f460330dbc8ea7a5b57,
            limb3: 0xbb9b73d3f7d3e540353a7da
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0x34f3b6ae130da9ec33b76e26,
            limb1: 0x374e43770ac9a3e9d8919c61,
            limb2: 0x964a408e985f85dfa5793822,
            limb3: 0xb1789252f8c0ff9ec5148ee
        };

        let Q_0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x477453988af57b7a8cc97def,
                limb1: 0x1a78dfc0cc4010186b3c686a,
                limb2: 0x7e48a1c8ef4d478ab195c85b,
                limb3: 0x4d77d86b045ca2fe01714ba
            },
            x1: u384 {
                limb0: 0x9a01a7096cf85508e1d49a09,
                limb1: 0xf48d02d05bf3e13c01dee1a1,
                limb2: 0x7a793d3e960850162d16a10b,
                limb3: 0x61e7f01f71027555c7e9f
            },
            y0: u384 {
                limb0: 0x86b2c2d835f03ec5442041ca,
                limb1: 0xc083c02d8c00fe4c931c8594,
                limb2: 0x6485ea29b6ab174f2d36b87f,
                limb3: 0x120b11177976a0f99b5f43b0
            },
            y1: u384 {
                limb0: 0x33fd21eb7dab6e71d961edfa,
                limb1: 0x7bba38d15e17a07c3911ec3b,
                limb2: 0x5ccd955c9709703ceb5784a2,
                limb3: 0xdc9174e8bd97d52e8bb304c
            }
        };

        let Q_or_Q_neg_0: G2Point = G2Point {
            x0: u384 {
                limb0: 0xea0d57eb4b8cf4138556eaef,
                limb1: 0x40558dbbf25043396f9c2d00,
                limb2: 0x9a91e7527d6dc43948a787be,
                limb3: 0x16646b25bd1542c9180287ed
            },
            x1: u384 {
                limb0: 0xeb5d9cfb7e106f4a7d29a38,
                limb1: 0xdf4615dc9223e12d604da354,
                limb2: 0x58aab59a83344e886848137,
                limb3: 0xa6677aeac73e119addf72e4
            },
            y0: u384 {
                limb0: 0x3f1f8ad9d1ee6a0c7f28db0e,
                limb1: 0x54a969fc892b9dc95ceeb4b5,
                limb2: 0x9e875edb97182387a6e58cbc,
                limb3: 0x11747ecb596da460fd0fc30
            },
            y1: u384 {
                limb0: 0xdd602c19cbf714add8dcc8ae,
                limb1: 0x62d9ae837c091f35623190c9,
                limb2: 0x7edd248051eec4562ca1e40a,
                limb3: 0x11081e00064e5b83ef982d94
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0x316e3285b5b28dfec52d96b8,
            limb1: 0xaefe132b547950e94f1be99c,
            limb2: 0xa75a7cfed10a8fe796f99be1,
            limb3: 0x56e87133d38c859f810cd78
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0x12b269e03e6c8951068ca194,
            limb1: 0x4afc3e3aa6c19f8dd741222f,
            limb2: 0x1ce64f08ac705f76fe7a695b,
            limb3: 0xddcc4e2408aef7d90deafaa
        };

        let Q_1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x358d3e42ed1e054f5fb786f4,
                limb1: 0x750e61b1d97eb2fc26fc574c,
                limb2: 0x6057b5b78a36d03011d0fd54,
                limb3: 0x3e55c4cc8bb01febfb6230d
            },
            x1: u384 {
                limb0: 0x994907f1283d53d5bce4588e,
                limb1: 0xb6eb3b81b26d1e8a0111aca2,
                limb2: 0x6a65113d6f94ed844cb0ff1b,
                limb3: 0x178c2e9d9cd4b91d7e7ea72
            },
            y0: u384 {
                limb0: 0x12dd9cc48fe286b13133e8b9,
                limb1: 0x7ef4823bccfcd80edac72563,
                limb2: 0x2de4e15df26bfc7adcccb749,
                limb3: 0x17932f38d0fa59e7ed6177be
            },
            y1: u384 {
                limb0: 0xcac8d101759cdaec3adc2893,
                limb1: 0xb9be64e1b08d0f95cd8f1e8b,
                limb2: 0x649ddd510339d23b763b29ea,
                limb3: 0x863aef3dec340991ca7b806
            }
        };

        let Q_or_Q_neg_1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x95f45a1fe1d292ab36f4851f,
                limb1: 0xeaf3913e301c873062fe8d68,
                limb2: 0x19cf40ca16b9315aeea64d23,
                limb3: 0xcecdd87efdab5241ea32472
            },
            x1: u384 {
                limb0: 0xf7c05d5dbe9fe979e58b8570,
                limb1: 0x352c848bb8a79810bb90ead7,
                limb2: 0x3cd67d94feeae95f1f9e473,
                limb3: 0x19b679335cdaabc51dbcc13a
            },
            y0: u384 {
                limb0: 0x90fc2f5b3847cd1e8731f19c,
                limb1: 0x63f49a4207814183dd17b027,
                limb2: 0x234848be09b3f5f8de9c1d73,
                limb3: 0x16224eaf2337cb901a8ee3c5
            },
            y1: u384 {
                limb0: 0xe53d14597228ef1113638d54,
                limb1: 0xf7cf71163746e5045e17ca5f,
                limb2: 0xe65d79f1fc64e97c9f3a6204,
                limb3: 0x16a3b83bb15791b82a36d940
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 0xd0fa6c1f44898b04af8d0979,
            limb1: 0xdac513d314d0f793db265d6c,
            limb2: 0x6aa33909aff3cc60a7a2d842,
            limb3: 0x94ddc3ab7815143521a9b07
        };

        let f_i_of_z: u384 = u384 {
            limb0: 0x5061a00bfc1f14aca6bb529a,
            limb1: 0x8c65f5289169b5bbf2861dbe,
            limb2: 0xe7b1fd171d668bc2c3d7555b,
            limb3: 0x7ac0e76e385e092afe0da0e
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 0x67f2cd88eb23488130ae252f,
                limb1: 0x243f8229ece48fdc68d60b08,
                limb2: 0x13b79970dd8159b898e63241,
                limb3: 0x72186d83d550d82be187b30
            },
            w1: u384 {
                limb0: 0xb6204bebefc20d7d4aea3cde,
                limb1: 0x49fa67816f79e82cbea82e21,
                limb2: 0xcaaedfbf0cb1cb5a68ec9e22,
                limb3: 0xc91e1000ffb9b5ea0949cf4
            },
            w2: u384 {
                limb0: 0xfbac46f547c8a4cc6445d014,
                limb1: 0x6aa3930ce80af5cee6d6c4d,
                limb2: 0x1a1b7de7670b1effcc8a0555,
                limb3: 0x12089a0d1ce808700199c420
            },
            w3: u384 {
                limb0: 0xb4e3fdc490768b00530aee3,
                limb1: 0x6222cf78f66221f804e93690,
                limb2: 0xf52a29448d739eeff1810962,
                limb3: 0x1875d7a68fea470f9ed0c113
            },
            w4: u384 {
                limb0: 0x182e1a8e7cf2ffb924a6485f,
                limb1: 0x1745c170d7bcafdfc948aff1,
                limb2: 0xf7dc571d0c9a7fec92a5b895,
                limb3: 0x7ea0fcf348266db688bdcda
            },
            w5: u384 {
                limb0: 0xc801c67cd039fca63c78c6a9,
                limb1: 0x1841c24912882f6000073cc2,
                limb2: 0x37c6c427bc67b332a89dd114,
                limb3: 0x196c5143a79e431fc6adad4a
            },
            w6: u384 {
                limb0: 0xe76720f835b6a4b0ca657102,
                limb1: 0x5f226e20db51b28170938792,
                limb2: 0xb4456af356dcae4e89ec5252,
                limb3: 0x1745a8fe5937d3dbea805229
            },
            w7: u384 {
                limb0: 0x9c3ecbc8b715cf06aaae38c4,
                limb1: 0x638ed6d16f55e04602ae7872,
                limb2: 0x7bcaf16197f5e7b86109ce6d,
                limb3: 0xa779613efb1fa076a8cfe71
            },
            w8: u384 {
                limb0: 0x1d993cf26f787edd2bd504f,
                limb1: 0x3593dc66cd2af21637abd90d,
                limb2: 0xfa6b5e5d65b9af9d66fcda7b,
                limb3: 0x17cefc81215c7024f2b5c748
            },
            w9: u384 {
                limb0: 0x7d79ab44c633ff19d95807d2,
                limb1: 0xa9ed07514465259bc419f2b5,
                limb2: 0x8fc929bda5bfb1adecac7eaa,
                limb3: 0x16d9994c907af5d8a8f0865
            },
            w10: u384 {
                limb0: 0x53140bbacfdc16d06aaf3f5c,
                limb1: 0x465a6d5e086f2af3059c498,
                limb2: 0x2d85ceb25291b0496a2ca004,
                limb3: 0x7b8a2e0a76f80a91db94322
            },
            w11: u384 {
                limb0: 0xe94ed0935144634dbe6449c3,
                limb1: 0x5180d2a0acdffd0f651fff2d,
                limb2: 0x31f5382f2ecb559c510cbf3a,
                limb3: 0x7f32e5e96535180c41c9186
            }
        };

        let c_or_cinv_of_z: u384 = u384 {
            limb0: 0x1be4143d601031fad1e06f00,
            limb1: 0xcd8801dec51e4f7d62b7aabd,
            limb2: 0x8fbd413097582cd6dac24c5a,
            limb3: 0x13154076a0f0ba56ec00caa0
        };

        let z: u384 = u384 {
            limb0: 0xbe037ad53f69fe38fc8b65a7,
            limb1: 0x20c5a674cb4d9a4c0de4b89,
            limb2: 0x967006cb2ee2c023cce6ba76,
            limb3: 0xa524afb5cafd1494d09bdc7
        };

        let ci: u384 = u384 {
            limb0: 0x5620f2de824500dbebdb7c95,
            limb1: 0x68ba16e99745cba9fb21f62d,
            limb2: 0xe9052731bd387e53f882006a,
            limb3: 0x5da7bd4f3f9fd86711f02ac
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
            Q_0,
            Q_or_Q_neg_0,
            yInv_1,
            xNegOverY_1,
            Q_1,
            Q_or_Q_neg_1,
            lhs_i,
            f_i_of_z,
            f_i_plus_one,
            c_or_cinv_of_z,
            z,
            ci
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x9f664ed98115b5b1a0ecea9f,
                limb1: 0xb0c6d384b2438103428fab01,
                limb2: 0x1b499d901316d15f27b9e25b,
                limb3: 0x1166be1d7a7d8bd72c349cda
            },
            x1: u384 {
                limb0: 0x9a70012c16993301f08c7f42,
                limb1: 0xf65fedb4585c45420c8fa25,
                limb2: 0xa6688d428399603a555fbd14,
                limb3: 0x16b2a110fb2a641960b4d34a
            },
            y0: u384 {
                limb0: 0xd9bf75587eb54e8214a2cb4,
                limb1: 0x2c9157e9e11c0efad99a4ac5,
                limb2: 0xb3a03d465237f7c27232ae79,
                limb3: 0x296f472eeeaf57e2661f391
            },
            y1: u384 {
                limb0: 0x9f68a908983bbbc358840a7f,
                limb1: 0x4c0691409aebcb545fad480,
                limb2: 0xe18fddc126e3b6a74bf6f912,
                limb3: 0xc49cbdd7f8ea03062610e06
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x928dfcc3b2bd3b746a4cc98f,
                limb1: 0xf3ab2c0d1cf815d81bc6dfd0,
                limb2: 0x6c08dfbafb118d2658331766,
                limb3: 0x26bfaaa61817afeb806cb2e
            },
            x1: u384 {
                limb0: 0x57cd0f5951e0008512093a70,
                limb1: 0x3dc81d483a6a17013f69795b,
                limb2: 0x633fed6aad3bf6089c70be80,
                limb3: 0x12597fe6d6ec97263d4ea851
            },
            y0: u384 {
                limb0: 0xaac1db5f0a4ca35bcf9c8587,
                limb1: 0x993e402d5474eb6eb3fea17d,
                limb2: 0x19e4c5da28ff1cfefe98ef47,
                limb3: 0x15a45bd8489ea84d51554245
            },
            y1: u384 {
                limb0: 0x3284690c105880658af5c0b0,
                limb1: 0x72c1a1c68d31184cf5a1d885,
                limb2: 0xe31b124a455b0de07f1707e8,
                limb3: 0x530a88e3f57c4f8f7e4a16b
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0x9760228635f111dc26efdc3d,
            limb1: 0xbeb0ecfa8daf4cb9f1a253d3,
            limb2: 0x121e8371c4dee9cfefbbf515,
            limb3: 0x350c61977c0cad25d7804a0
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 0xaea1ac440afb7bb50dfdc8ad,
            limb1: 0xba843d2bd9f6fa8a2ea239a1,
            limb2: 0x523f08b15561a33b2aa74496,
            limb3: 0x78925017a2cfd2dbfdc3627
        };

        let ci_plus_one: u384 = u384 {
            limb0: 0x91b28e38c022acee1d9cfa46,
            limb1: 0xa759f8bf4ee9c89ab543003e,
            limb2: 0x3c02a6b33a6d415f37fdad0f,
            limb3: 0x17fc0d22aa471a8db471069e
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
        assert_eq!(lhs_i_plus_one_result, lhs_i_plus_one);
        assert_eq!(ci_plus_one_result, ci_plus_one);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_FINALIZE_BLS_2_circuit_BLS12_381() {
        let R_n_minus_1 = E12D {
            w0: u384 {
                limb0: 0x2162113f8285b5e801f33f11,
                limb1: 0xce71e76818f13c602bbeb100,
                limb2: 0x63528f2a2f295b10c9b94707,
                limb3: 0x118f7191d3b695528c907b5e
            },
            w1: u384 {
                limb0: 0x7097c7503260935ca9dc969f,
                limb1: 0xf3841334ebbd44b7f61ad046,
                limb2: 0x325659ab7a4883c9cd7dd454,
                limb3: 0x9b3e1bf10e2e0713b99fbc3
            },
            w2: u384 {
                limb0: 0xc3c74f42c4b9ee852253dfc5,
                limb1: 0xe58cd63c7e470d99d811b64,
                limb2: 0xdcc3339446780a816cb7c5bf,
                limb3: 0x11f0c87586e396dd4aaa3cc8
            },
            w3: u384 {
                limb0: 0x8cb10928452db5bad64d4745,
                limb1: 0xad5fd5a2e02be6509e1a608c,
                limb2: 0x65859df378b39e32ece5c7b0,
                limb3: 0x119ed2c6411b74f7b5dc436b
            },
            w4: u384 {
                limb0: 0x114d1ad3790eefa8df93e0d5,
                limb1: 0x5df270d255ff6f2220e7b30f,
                limb2: 0x69d1b180f4c1423311a3c10e,
                limb3: 0x172bd3ec46e7fd7db311e39c
            },
            w5: u384 {
                limb0: 0x4efa7ea32e0a1f4866271efd,
                limb1: 0x4de7ac1e8313eff6e644567a,
                limb2: 0xeab25f6d66aacac95d05ad6,
                limb3: 0x10a64ba84e5d3f4285a81960
            },
            w6: u384 {
                limb0: 0x311f899579eea85726b19dfe,
                limb1: 0xa2081bc46f3454e0d61c1fac,
                limb2: 0xe842be8d0a97b6f9aaf50770,
                limb3: 0x6af2809b0a11815b470b8c2
            },
            w7: u384 {
                limb0: 0xd7eaecc0955f35654a1f73ba,
                limb1: 0x1270ff80ede013c646b339a7,
                limb2: 0xa38beec4baf239b9ebcb61c0,
                limb3: 0xe7f6f8793a5e78ec99ad9bb
            },
            w8: u384 {
                limb0: 0xb1db0f7729735237bf74c160,
                limb1: 0x15777894468bc9599b09819e,
                limb2: 0x2a6ba43a0ec37460527febc2,
                limb3: 0xaf8455d6d7e8c632d2674be
            },
            w9: u384 {
                limb0: 0x5cf7f2d5067c6e856d63565f,
                limb1: 0xd5ee9df9101c0d4cb33f3fa4,
                limb2: 0x59a7a4d295dc200c9219fe1d,
                limb3: 0x1306a48bfe5f37d3a6d8179a
            },
            w10: u384 {
                limb0: 0x75fc330325671f9857916b31,
                limb1: 0xc55dcbc2fc3b28bf1b90c259,
                limb2: 0xb3e6b224cef9ae0fbd7e1f96,
                limb3: 0x15d73841bef5602eebe36227
            },
            w11: u384 {
                limb0: 0xd6846cfd8dc68e119f4bb174,
                limb1: 0xd891a86421e3aa38729730bb,
                limb2: 0x60e8610172421123bb44af62,
                limb3: 0x9e0e8768ed9acf07b66a9ac
            }
        };

        let c_n_minus_2: u384 = u384 {
            limb0: 0xbf5057febbdb799edbe26a9c,
            limb1: 0x7c63747aa71cbf0fac3a2eab,
            limb2: 0x6c3a6e073660fc39f55aae57,
            limb3: 0xf95b5620637894850da07a1
        };

        let w_of_z: u384 = u384 {
            limb0: 0x688cd288d7c3ba60f6170e9c,
            limb1: 0x4b4270089b4d3ac725e67e62,
            limb2: 0xc8bbea21dd5d3b9bd4f75de6,
            limb3: 0x3899aa8369b4563506dec11
        };

        let z: u384 = u384 {
            limb0: 0xbb5225772080dd12324e04b6,
            limb1: 0xa2312e869c458e796932eff,
            limb2: 0xbbd09a1cc3d2e249a0b3730f,
            limb3: 0xad6d35dad2f90737deb9011
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 0x54a355c444e829e9bc39066b,
            limb1: 0x7bdfcf8ba129d91bd56be3c9,
            limb2: 0x80c8261b259968f499341a,
            limb3: 0xf6c595fafd260ac5440df0
        };

        let previous_lhs: u384 = u384 {
            limb0: 0x4733ef7da55f50f65f2f25cb,
            limb1: 0x940d10cdaf73d31f6bcc4c3d,
            limb2: 0x387138d4634168653b6803ee,
            limb3: 0x22af80eb3e1990893f0e4b4
        };

        let R_n_minus_2_of_z: u384 = u384 {
            limb0: 0xa6aae7ad191fa8bc9675562f,
            limb1: 0x965f5779e2b41d8645934ce4,
            limb2: 0x65698eaad4fae26d0451ad86,
            limb3: 0x16b8fbf84af5adf3d148867a
        };

        let Q: Array<u384> = array![
            u384 {
                limb0: 0x67d7ff805feff9a8d6a77153,
                limb1: 0x6074662f5c6f76ca2f0a8e10,
                limb2: 0x9543cfd8edf50d029a44df10,
                limb3: 0x19e002a21faf39edb6a6668e
            },
            u384 {
                limb0: 0xef58e475bd33307bc984fec7,
                limb1: 0x6ce38dafc2acf2c98f7d7092,
                limb2: 0x55a0fcb3422e2e95552a41d2,
                limb3: 0x13ce604c181a00c0f9e5399e
            },
            u384 {
                limb0: 0xdfe68c5171a261d82da2f193,
                limb1: 0x1934c37730ac64c53d115920,
                limb2: 0x2a183608b3519fc472add5ea,
                limb3: 0x13f7ca0baccb54e800ff8b11
            },
            u384 {
                limb0: 0xcc19b2c95b3146b62f7acf2f,
                limb1: 0xbd6b774d0e15c9f5bdeaa0c1,
                limb2: 0x295f90503c79db9d4e210675,
                limb3: 0x178de258898122bb154959a9
            },
            u384 {
                limb0: 0xfcc6b9501a047c3d1d494ca5,
                limb1: 0xe9aebe887af51c9c6a45a145,
                limb2: 0xd9657db2f00a2a15d42986fa,
                limb3: 0xb27b89d93cf3e6861086f02
            },
            u384 {
                limb0: 0x92f424609a1c1c2646bc0d80,
                limb1: 0x907a963cf627de69131507d,
                limb2: 0x4561c0e4a2a4cdea3df4a066,
                limb3: 0x152802ffaa66242d320887f7
            },
            u384 {
                limb0: 0x539f738c590de0bba5ee17,
                limb1: 0x84f16155a11e7f4abe324a2a,
                limb2: 0xa983b50cfb15e3587eb3246e,
                limb3: 0x1027f75fc366453b015214a0
            },
            u384 {
                limb0: 0x1007f9be3e57d420711f067,
                limb1: 0xa5190d022d0b587f1320cceb,
                limb2: 0x7eae9b8675f612505c856338,
                limb3: 0x30374938df45822cefb72a4
            },
            u384 {
                limb0: 0x67672789d64c6cd6c61925b0,
                limb1: 0x8cc66bfdeebe644c28eb7deb,
                limb2: 0xf6506f8be5645fbdc832befb,
                limb3: 0x1754c77dd5367d0ef58d588b
            },
            u384 {
                limb0: 0xdd175fb5d005155c763f6720,
                limb1: 0x627bf978777f4a56070cd0e8,
                limb2: 0x1406baa69f6622e9d6b2d1e3,
                limb3: 0x18b3d0460d286925f2485045
            },
            u384 {
                limb0: 0xd274d21bde523800767243a5,
                limb1: 0x15206eedd53080d7956c7124,
                limb2: 0x272e160192596e081cd87322,
                limb3: 0xe1035dea9edaad7d9eb8211
            },
            u384 {
                limb0: 0x915c4259bab2d8ab2818e27a,
                limb1: 0xb3584ff1ff6cf9308db1e3e,
                limb2: 0x57bc57385f96c7b66e9f2924,
                limb3: 0xd48ee045f1cf4b21f4801e6
            },
            u384 {
                limb0: 0xf0382e079d55932c7f41f949,
                limb1: 0x316127250f59c95d1a34e471,
                limb2: 0xf8c6c01fde8d3dac1ff99c18,
                limb3: 0x5788f7753d547a2d5ac28c
            },
            u384 {
                limb0: 0xee8530d4af32a021b9d98f30,
                limb1: 0x1fd0b1c21c0b6453672f6eb9,
                limb2: 0x3ae7593488eefc0581b02aef,
                limb3: 0x131ac3da3f78ee36b5f5cf3e
            },
            u384 {
                limb0: 0xaa3757721d697cd0066213bd,
                limb1: 0x15247332c4f56173d7f0ab2f,
                limb2: 0xc50fc9000a06c083e848ca50,
                limb3: 0xa7756779ce81fa7a7a27fbd
            },
            u384 {
                limb0: 0x5d67751a30f1568ef154bf5f,
                limb1: 0x20d4cc6950c736d91d3cec2d,
                limb2: 0x9688778b395df4285172ef91,
                limb3: 0x15f2ccb60cbb065fda2ede5b
            },
            u384 {
                limb0: 0x2bdb6e3eb075b0850b521748,
                limb1: 0x58e9282f4757ee6eb176f15c,
                limb2: 0xe05d9b49d9aec3c5f4cd19b0,
                limb3: 0x8896a853ea2068a56e6a8c3
            },
            u384 {
                limb0: 0x49a3421c69cc71a29589eff6,
                limb1: 0x5175198fef88a6fda58db4e4,
                limb2: 0xba8c70b4045abe0c9f93b32a,
                limb3: 0xf3fff9bee653a5ba8411ab0
            },
            u384 {
                limb0: 0xedb8acba4b2aea55ce59991f,
                limb1: 0xae3fa2e526c47308c9fd57dc,
                limb2: 0xdf03854431fa81774267f803,
                limb3: 0xfab4360d8ac9d0604283ad0
            },
            u384 {
                limb0: 0xb82ecce74ed60e1cc4909ed7,
                limb1: 0xc043feeedac826fcf54afc1f,
                limb2: 0x19b0cf2602143e2e79a0d008,
                limb3: 0x19c63ef9ba294b5f5eba9229
            },
            u384 {
                limb0: 0xdc47f55e2d2f9d86189ab90d,
                limb1: 0x1980da38d8cc46b14151c48b,
                limb2: 0x8f5c14882b2209a9486f43d9,
                limb3: 0x127c62bf226fcd30db10c789
            },
            u384 {
                limb0: 0x58f21de469633870c0c9a8fe,
                limb1: 0x65e2f858789dba646720fb7b,
                limb2: 0x1dfed51f084993fb3fb1908e,
                limb3: 0x10c1124f5209b417482459ab
            },
            u384 {
                limb0: 0x500805e8e7f90dce0dba8094,
                limb1: 0x7d7d5c0a53b56c254d829f38,
                limb2: 0x9329393d9d73cbef13d0abba,
                limb3: 0x112016bd75d9659207945e3
            },
            u384 {
                limb0: 0x1ac1a074b4c7b4579c49815c,
                limb1: 0x99319c3fdd041164e51eee,
                limb2: 0x4fe97f7b3b14236a4bdd595c,
                limb3: 0xc5db86fba8f667e19bcbfa6
            },
            u384 {
                limb0: 0x1050c96246a1d79c6b5f837d,
                limb1: 0x3dc25c9b2087dcac78971a2,
                limb2: 0xfdc9dcb249c066d839f99789,
                limb3: 0x2444a2505f4f8478e02ddea
            },
            u384 {
                limb0: 0x82b3c4b0b6d4af46d1e16baa,
                limb1: 0xd32f3c68441bad98970e912d,
                limb2: 0x3420824939af42132748ecf9,
                limb3: 0x18ff792249430a013ce40468
            },
            u384 {
                limb0: 0xddbbcafc157d620e105699e2,
                limb1: 0x76be813738d0b720e2dc6a77,
                limb2: 0x7ddf698405eae756111af0c6,
                limb3: 0x183243b9214c9ccdc1a616c6
            },
            u384 {
                limb0: 0xdffa2389df417dee5aa8537f,
                limb1: 0x6cd8efb1dde06374cc777ea8,
                limb2: 0xa604f9cc61ee7c76f35a2767,
                limb3: 0x18c29ae7e05d3ab355414aa0
            },
            u384 {
                limb0: 0x1db9203fc81fd054ff72a5bd,
                limb1: 0xe7d6a5cc4d1e460c9ab97caa,
                limb2: 0x6284e14fadb7205977aa0409,
                limb3: 0xc2c9e3431c9ebb2b4f1081f
            },
            u384 {
                limb0: 0xcf923e491a2ae0533ff6c764,
                limb1: 0x1067b9cd0dace7b368768dbb,
                limb2: 0x55fd0bb851c0ccb1d0ebc1e4,
                limb3: 0x549e2f3ae72bf3e4ee79c5a
            },
            u384 {
                limb0: 0x9efd4e7b20d04ce1d581f828,
                limb1: 0xa0f6eda73de609e2074712fc,
                limb2: 0xa82b6297a5696097b24eb3ff,
                limb3: 0x2e596a8eb17fe9bf68679b9
            },
            u384 {
                limb0: 0x5537d063c96b6016aff747dd,
                limb1: 0x7910e6db1e1aec5ea49ef488,
                limb2: 0xe9ac2e08ebcf5a62988a40e8,
                limb3: 0x152fb2f41368b948d7499ff6
            },
            u384 {
                limb0: 0x789afb57a4d5412d60be768b,
                limb1: 0xc6df1bf9af149cabd9c4b4c,
                limb2: 0xd7d5a664ebaf263cf2a67c7f,
                limb3: 0x56ad9b6f7e9981d1b8df614
            },
            u384 {
                limb0: 0x690088c1b215d0af7922e937,
                limb1: 0x431c912fc1d08108c5e93d79,
                limb2: 0x6a07a3b5b3b29a3737e28bfd,
                limb3: 0x2bccb102bae5e564fa65a06
            },
            u384 {
                limb0: 0xcf1b975ba375232cd544efce,
                limb1: 0x2066cae8f3e3c451d71a4448,
                limb2: 0x3bf497b226d30fca62f8237a,
                limb3: 0xc6d14c21cd3b7c9b2c6e2e2
            },
            u384 {
                limb0: 0x29ec1824319e071d267dad13,
                limb1: 0xe847ca2b5fa7c3757c923fb0,
                limb2: 0x1acaa9719fd6d95b91ac8823,
                limb3: 0x167d4985c2c002ed04314365
            },
            u384 {
                limb0: 0x6bf127162b95e67cf5737e4,
                limb1: 0xda2a6cb9687b6b0edb12964c,
                limb2: 0xf4b41cb34106a05544aa3194,
                limb3: 0x16d7a874c5a0b4f253aff0ab
            },
            u384 {
                limb0: 0xcd6a2e6a0851828158d27bc2,
                limb1: 0xa566296880792f8a3fb6e8aa,
                limb2: 0x67e3055cd4e1f2ddae166679,
                limb3: 0x13602d461728e0d3c16bde7f
            },
            u384 {
                limb0: 0x82eaae3a10e68f8ca77ff11f,
                limb1: 0x4e18adf19e1a824f139dfab3,
                limb2: 0x7197bf163694ce209596997,
                limb3: 0x199924eaed834f1693e553e4
            },
            u384 {
                limb0: 0x82c0777ef0fd1659e352ac87,
                limb1: 0xd070edb76943216a6507943e,
                limb2: 0xd57c725d589c996b1908ecc5,
                limb3: 0x6dbfbf2c8d939fbf4c06eab
            },
            u384 {
                limb0: 0xcd63b97ed94decd0a83baf04,
                limb1: 0xc6bc1e2a7e9d98fdc0fef09a,
                limb2: 0x2ca222fdcbc6b166d5ad1c81,
                limb3: 0x6071fa51199333c0927717d
            },
            u384 {
                limb0: 0x8eeedc3c2304fc2b8c363beb,
                limb1: 0x702e935a9436ff9744d548ce,
                limb2: 0x64d5cad22f7be4543af52271,
                limb3: 0x8aba3961ef962947a410210
            },
            u384 {
                limb0: 0xd8effa8844a2f730d004e247,
                limb1: 0x6a00246fa6034d21be15b5bb,
                limb2: 0xa0e5235811f0458cf767cead,
                limb3: 0x11ef4c72ef7f2069a74c1b1c
            },
            u384 {
                limb0: 0xe5125633828a85e0ce8d3874,
                limb1: 0x9cc6d3515f1078cc61621fdc,
                limb2: 0x253b6e44191650e31800201a,
                limb3: 0x9552e1ea3f01dcdeb88fa94
            },
            u384 {
                limb0: 0x71133be338625239ca32c081,
                limb1: 0x97354c9fcac9f43ae37cc4c4,
                limb2: 0x346d43983144088aadf8dbc8,
                limb3: 0x13fe79163064f0fc7fc071bd
            },
            u384 {
                limb0: 0x447dc5a8325ac15c33912a64,
                limb1: 0x8bf831244091e5a86ecad5f5,
                limb2: 0x3cdcb82ec048ab0b8b652d30,
                limb3: 0xf503b6b92c56f2e41617be9
            },
            u384 {
                limb0: 0xcc28ae3d9db02d929f141ca2,
                limb1: 0xfae54cb4a986778f237f91cb,
                limb2: 0x7c926c46aede20d5c36b07d0,
                limb3: 0x149f1668072c511b3f4c89fc
            },
            u384 {
                limb0: 0xa07edc251345a19c54cf8fd3,
                limb1: 0xfb4e05247b11568ff1ebce9b,
                limb2: 0x2edee8e667c3203deb43f541,
                limb3: 0x117dd32081434b977fb3872
            },
            u384 {
                limb0: 0x38c8e97cb60a638470d1c6d3,
                limb1: 0x9fc3cfc8d8470ea1392047e8,
                limb2: 0xb7309855d7c92d5e8a5c4874,
                limb3: 0x1855c926a5613b89e131913f
            },
            u384 {
                limb0: 0x67db8350b36889013bc3411c,
                limb1: 0xa4e115ddd843bb4401650350,
                limb2: 0xee61157c78f630953df2a81b,
                limb3: 0x6eb336ece1be150d15417a8
            },
            u384 {
                limb0: 0x8a90fbbbc72d2b328295ec28,
                limb1: 0xb3c53c5a82e02823b040a3a1,
                limb2: 0xa3f542b9625862f8b71200ce,
                limb3: 0xb48cb1fd0cd64e2bd797714
            },
            u384 {
                limb0: 0x8b129b67aa7fc4cda908c744,
                limb1: 0xf94ce97be77e2108e51128d,
                limb2: 0x54cd927eab52f380f3c36699,
                limb3: 0x465557647e917260a51f913
            },
            u384 {
                limb0: 0x967edff2a638b53dea04c35d,
                limb1: 0x82ac0ab411392323dc01d5dc,
                limb2: 0x6121df84c661be705005341f,
                limb3: 0x125f29897726451d8626d37d
            },
            u384 {
                limb0: 0x49d1d42494296b689ce2b312,
                limb1: 0xf55953f41a1636ce12ae37a8,
                limb2: 0xf19edf125bac72c97905d1e3,
                limb3: 0x196f4fef369f36d9bfa2bd08
            },
            u384 {
                limb0: 0x1900baae05112a02c018b89f,
                limb1: 0x60d5e8218327f24cd6c556cb,
                limb2: 0x30a0292e958ef526841a8762,
                limb3: 0xaa5433892716ec5d77bc9c9
            },
            u384 {
                limb0: 0xd7ee33d76d911405e567e67c,
                limb1: 0x577352bbead026a474c9118f,
                limb2: 0xbe7c18ea65cab758443f5081,
                limb3: 0x176e102bc58d376f7bdd4130
            },
            u384 {
                limb0: 0xe6e409f46ed44b11144844d2,
                limb1: 0x416488c7ba3b8d148df54a24,
                limb2: 0x30cecf393129c945be8145d9,
                limb3: 0x4e95c5620c1885bf819468f
            },
            u384 {
                limb0: 0xc05bb2644ca36ecb40b7dbc2,
                limb1: 0x7164775dfddadf240c4b6a95,
                limb2: 0xe2d426085a01940153f23d68,
                limb3: 0xb78e01f3e7a38ac98fdda4d
            },
            u384 {
                limb0: 0x2207c8f5a2ab5123047286ac,
                limb1: 0x59e0cba212531d5b37b84200,
                limb2: 0xbb5cac482bec0b516d3b41b3,
                limb3: 0xc7578c714836831313de798
            },
            u384 {
                limb0: 0xf278d163d3128e5cbea3351d,
                limb1: 0xb48577ee914c42b7007b0a78,
                limb2: 0x265464dbbe50807bd7bbf3e9,
                limb3: 0x306d518de5ddef2c945291e
            },
            u384 {
                limb0: 0x57f7417782961fe0b710354,
                limb1: 0x8007d5a33a1be467f167e8d8,
                limb2: 0xb58dc25f39a4d24acba5aefe,
                limb3: 0x17b4646be16a2f5e764b3afe
            },
            u384 {
                limb0: 0xe4158af7eaea776a57aec533,
                limb1: 0x5ab4f9c6d084e949dc88720d,
                limb2: 0xdb726c5c8d693e576f40bc0b,
                limb3: 0x1953891f5398775858543999
            },
            u384 {
                limb0: 0x3adf6a11c62dd64a97fb334b,
                limb1: 0x4f4390d047e1918a115d3e44,
                limb2: 0xe39fbc2da8745175c158169c,
                limb3: 0x6836b0100eacf3d21ced5d3
            },
            u384 {
                limb0: 0xd7139e6dc204f255d0f66734,
                limb1: 0x48d78014f90117c9570d9d3c,
                limb2: 0x232fd99b759cc90aac7d6d40,
                limb3: 0x5256db1f3f09037f09aea3f
            },
            u384 {
                limb0: 0xbea9513a1f8339e3e2ced135,
                limb1: 0xb5d7c86a8237f1b1ddea8d86,
                limb2: 0x93244a65d1b9bef3ad454004,
                limb3: 0x1820629f8151b349fb1a391a
            },
            u384 {
                limb0: 0x62b01078277b75fd164a5c3a,
                limb1: 0xa99298b647edd5e68109efb,
                limb2: 0xd3729728a991465275379dba,
                limb3: 0xc2adad24c9ed1b89532c5da
            },
            u384 {
                limb0: 0x3429c6542d889a141bb15305,
                limb1: 0x5ab11c748ea4a186dc203f7b,
                limb2: 0xf8508b929dab2017670d3b4f,
                limb3: 0x16d71b1920c4d3f8a469da88
            },
            u384 {
                limb0: 0xce3706b3e6aafd1b841e8c4e,
                limb1: 0x5fd0091149633a4bc08c45ef,
                limb2: 0xd383ef529d14b3a5e49f8697,
                limb3: 0x10c138546b790a8cd9b6f42b
            },
            u384 {
                limb0: 0x6d989cc1d1f67ad0c2c65613,
                limb1: 0xc907727dc87ea6b542ad26e9,
                limb2: 0x90a27b0ea7ef99565684a380,
                limb3: 0x11c1d1b688ba9e704496aef
            },
            u384 {
                limb0: 0x744fe6af976545fd4982493b,
                limb1: 0xea9f95b06a655acab07612fa,
                limb2: 0x3c14e766f4a58815b7ba0d59,
                limb3: 0x3b17c9cf20cdeaf21dd3f6c
            },
            u384 {
                limb0: 0xc022e8913ef1fe17bfdec90a,
                limb1: 0x2106867b65fbd916cd68fd5e,
                limb2: 0x90bbb07f42227fd2e5da4e12,
                limb3: 0x167e0a45e46c0ba38788b2ce
            },
            u384 {
                limb0: 0xf6e65494bd3645fc7996cdd7,
                limb1: 0x4f2a3546446700953096610e,
                limb2: 0x39f35b85eb7c6a2d354b9649,
                limb3: 0x14cb03ef5cad37aa80f6f49c
            },
            u384 {
                limb0: 0xbb1b53f3c3c48dfc76d221f,
                limb1: 0x4d2e173e9d377dd5bbdb886a,
                limb2: 0x7de0cadb9948fb7d4fd31bda,
                limb3: 0x119b98594bdfc57989b05867
            },
            u384 {
                limb0: 0x6b250adbf2bb3e4265a0596c,
                limb1: 0x29eb0b1fa628625ae33a0e,
                limb2: 0x583194d420cfce4ebde2f7a4,
                limb3: 0x154a08cf1828315dce253002
            },
            u384 {
                limb0: 0x37b2185d17f78ef2d10e12bc,
                limb1: 0x6ec6b631b9c48dc844cf672e,
                limb2: 0x9b521fc7d515f5e9855226a,
                limb3: 0xd1b5646f24870b6a38a1243
            },
            u384 {
                limb0: 0xbb79a78f0399923ff869a19a,
                limb1: 0x7576227f17d368bd5f5a2540,
                limb2: 0x312ad63448e178c2b2865b86,
                limb3: 0xcbfb657769ea627550cd5de
            },
            u384 {
                limb0: 0x4127ce5b0387a5417ed55be6,
                limb1: 0xed8f302ed30cf4ed5d87f7dc,
                limb2: 0x7a6cb906ea4e5a2c1fef3dd6,
                limb3: 0x946d4a39af6b0ff53265844
            },
            u384 {
                limb0: 0xdc4f9b599e11a44fc0f7d986,
                limb1: 0x38fc7db89222abd03327b039,
                limb2: 0x101ad1f39afb681df870155c,
                limb3: 0x84ae28e561bbb4730ecb60b
            },
            u384 {
                limb0: 0x3862cbe2020636cdce6e390f,
                limb1: 0xdb9a304369b290f1796b9285,
                limb2: 0x85d6df81562520066ff7faf0,
                limb3: 0xfd359a3227cbc27bb7f99c0
            },
            u384 {
                limb0: 0xfa5e999e23ff34b7c2ce6c9b,
                limb1: 0x84eddf6ea30e30dc13493ec4,
                limb2: 0x40fc9f2d94be8ec0b1b1bfe2,
                limb3: 0x17862b7c3269871db0081c18
            },
            u384 {
                limb0: 0x48757d875304ca7f598ec4e7,
                limb1: 0xd9a0690f696195fa159a1f56,
                limb2: 0x804c465b1628791188edd6d3,
                limb3: 0xd00cc87a4a13198d65b79f6
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
            limb0: 0x7023b63b8cb2298a0adff70,
            limb1: 0x3b76f5222608c2d4c8b0cac5,
            limb2: 0x480026e4cd6e52cece326ec9,
            limb3: 0x1a87e1c06f2f10ed891790a
        };
        assert_eq!(final_check_result, final_check);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_INIT_BIT_2_circuit_BLS12_381() {
        let yInv_0: u384 = u384 {
            limb0: 0x8d24b7622aecdf5eda006805,
            limb1: 0x6735a17352ec038246501244,
            limb2: 0x677bd216406ec3989a4a2a9c,
            limb3: 0x644a2b43a89591eb7b9387b
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0xcdd67b397b76f1b254fc5281,
            limb1: 0x52c28839db514bc0a2bd6dd6,
            limb2: 0xde41538007c571562d68e33b,
            limb3: 0x4bbca684544469ec12c2611
        };

        let Q_0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x392f2cd145f6bee6c1a0b1f0,
                limb1: 0xba7e24b1c8099ccbe5a6beb5,
                limb2: 0xc7539d328362bcd6c89f403e,
                limb3: 0x1936e28da93fc9ca962af06a
            },
            x1: u384 {
                limb0: 0xab723535e9b3efea67b61c3a,
                limb1: 0x6b8acec71f7b2da2d8680e4d,
                limb2: 0x70cef13775a25457d5a7161c,
                limb3: 0xd3f7bdbaa848d8c682d4e3c
            },
            y0: u384 {
                limb0: 0x20cfbc0d66ee0a416a5b607,
                limb1: 0x170b9484f130b23360cdc9a,
                limb2: 0xd77f15039505de763ae05936,
                limb3: 0x1441632fafe9b9adfd4a6945
            },
            y1: u384 {
                limb0: 0x9f78299cb9a94a03ff8dc9f2,
                limb1: 0xf9b46573878a2aafd8dc0cb1,
                limb2: 0x2dbca078e8f4ad300a4d3590,
                limb3: 0x109dbd6e53a9fe5046a8759
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0x2216e670b3b098789ab93ad0,
            limb1: 0x44fc93cf47767f6446e2b654,
            limb2: 0xf8a2279498f3b0a1c4d8347a,
            limb3: 0x277d44432cc59b1688393f7
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0xeb064d34101efc05873e40dd,
            limb1: 0x3a8ca3ca52ad8e898836f391,
            limb2: 0x12602d108a106c979c410822,
            limb3: 0xf570ae57bfaf3a1723f31ba
        };

        let Q_1: G2Point = G2Point {
            x0: u384 {
                limb0: 0xeee13dc0e1e429cf8dba6d8f,
                limb1: 0xf51559fdb68b604992edb418,
                limb2: 0x7023128790feb07aa0e33935,
                limb3: 0xed1d4b793ca601790639376
            },
            x1: u384 {
                limb0: 0xc785b355c7a2ca293cdaff3f,
                limb1: 0x1b993db9ceaf4dac947fd8d5,
                limb2: 0x8c49a512f51038fd8b552605,
                limb3: 0x14b53037980d3cf20c42c0bf
            },
            y0: u384 {
                limb0: 0xe66bc5a09dab02bd4c3f9e8,
                limb1: 0xea8a1b089a8252066ce78a22,
                limb2: 0xe79d67bcee1f51e968c513ee,
                limb3: 0xc5f9c334ed68217ae3a848
            },
            y1: u384 {
                limb0: 0x6fe47e6901225ce9528eaf4b,
                limb1: 0x350b62e7971211a9aecb2682,
                limb2: 0x7e92596fc896e2eafd1c9a78,
                limb3: 0x2e5c3ecd2d8eb6d95c82c9e
            }
        };

        let R_i = E12D {
            w0: u384 {
                limb0: 0xbd33677abff8746d07d9fab3,
                limb1: 0x6ec59896ffcb2aa32e6db0ac,
                limb2: 0xb22d888b38130ad18c996579,
                limb3: 0x159ad3bc5feaedd7f2e573e2
            },
            w1: u384 {
                limb0: 0x24b4aaafab3a1d340e722efa,
                limb1: 0xf14a58b3eefd1aa065d6d7c1,
                limb2: 0x19e0f5b764fbfae674cac73b,
                limb3: 0x99fc3f1cc66aefe62330da6
            },
            w2: u384 {
                limb0: 0x3ab319ae45b333c70f6000f2,
                limb1: 0x93f28ab5616cd40e243c33d0,
                limb2: 0x2c337ceea97d229aeab94eba,
                limb3: 0x7060bc9c3d4540a526aea43
            },
            w3: u384 {
                limb0: 0x5d88c5860fad3771827254df,
                limb1: 0x69c45171f0d5830666b19ddd,
                limb2: 0x12d527a03cc17dde07363cd2,
                limb3: 0x530b902a937cc865f40ec47
            },
            w4: u384 {
                limb0: 0xbd6337b3d5957c157d3e3711,
                limb1: 0xb6328f01197e30de8aa97d3f,
                limb2: 0x1925b544c69d91098b2439d4,
                limb3: 0x10b1e19d7b0b48ede5961b74
            },
            w5: u384 {
                limb0: 0xa6d3b6c47810c0405cec2965,
                limb1: 0xda58e05a291b0b3f0534a252,
                limb2: 0xe9e0cd8b2da562c6869f6ec6,
                limb3: 0x1665ae8e34f75266700b2978
            },
            w6: u384 {
                limb0: 0x6d4fda9921f6383c7fca5734,
                limb1: 0x8139bf93e5fbc7cb4c730ef5,
                limb2: 0x77727399ce68d3c30fc27325,
                limb3: 0x60a22b0fec9787d2a0f12d3
            },
            w7: u384 {
                limb0: 0x7c4261f1d96bad90fc961495,
                limb1: 0x21811ff0125f0449ff5f919c,
                limb2: 0xe79ae8b592ef181c62ada603,
                limb3: 0x729cc3f1bbc403de76419b8
            },
            w8: u384 {
                limb0: 0xc3629df76898a668df181e4f,
                limb1: 0xa68fabb34cb6cfc37e49eb8d,
                limb2: 0x1f15b76d8718685c4d668807,
                limb3: 0xe0373d4b889d6c712218a43
            },
            w9: u384 {
                limb0: 0xb03dd39f42e3712604d75fe3,
                limb1: 0x50a277e03a23e0d1b16dc5b9,
                limb2: 0x2531c05eced770da15bef573,
                limb3: 0x7055e5fab046f6beebc2e29
            },
            w10: u384 {
                limb0: 0xdbc586b68225dd08115fa91,
                limb1: 0x1f59b1c483837def08cfafb,
                limb2: 0x12d06ce5dff4e562c46477d0,
                limb3: 0xd9f13b698b3f261c5f87eff
            },
            w11: u384 {
                limb0: 0x1151de92980b5c39de9f5695,
                limb1: 0x8e334a4986cdf49661533e07,
                limb2: 0xd03ce6060b7fc1618c1d76b2,
                limb3: 0x225442e9d270596b9452195
            }
        };

        let c0: u384 = u384 {
            limb0: 0x1d665a38c24d532fca10725a,
            limb1: 0xb140db0c106f4e7f311e42da,
            limb2: 0x9c25c07ab823feb16a1dbb17,
            limb3: 0x127cf7f5bcebe80c9489dd71
        };

        let z: u384 = u384 {
            limb0: 0x9ea6052d324424dc2c2861b,
            limb1: 0x516ee3ec675a4db5e29c225a,
            limb2: 0x63e55888b40dd17796417f0c,
            limb3: 0xfb7fa6f0107d458a85e8694
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 0x5f82283e4d7a28308950724d,
            limb1: 0xe3522edb63250a278a17688,
            limb2: 0xded5ea11403af7aff2d72a3b,
            limb3: 0x97cc45400ec2994caa9df00
        };

        let (Q0_result, Q1_result, new_lhs_result, f_i_plus_one_of_z_result) =
            run_BLS12_381_MP_CHECK_INIT_BIT_2_circuit(
            yInv_0, xNegOverY_0, Q_0, yInv_1, xNegOverY_1, Q_1, R_i, c0, z, c_inv_of_z
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x5d07ce0c44e9e9ff6fd027c2,
                limb1: 0x9ced82828b10bffcc7cce31c,
                limb2: 0x61bade510e93f4668be02568,
                limb3: 0x2a3149e2a7c35a507c77b0
            },
            x1: u384 {
                limb0: 0x188ce4f5e87de8de08ff4ee3,
                limb1: 0xa88976c056a11954cbcf41e5,
                limb2: 0xc34362f108f638f2d53fba75,
                limb3: 0x11117ae0df3c6189ce468fa8
            },
            y0: u384 {
                limb0: 0x35c841b4cd5f613e6d877d14,
                limb1: 0x93e32c75782bb5c0e2453831,
                limb2: 0x5920bc193606ddc4a4b0664f,
                limb3: 0x14557a27931fd3751f65187a
            },
            y1: u384 {
                limb0: 0x568f13d3e98094b3061336b8,
                limb1: 0x7634df6b1d3f11df794f9165,
                limb2: 0x95f4cd9f7ade5f20990c6928,
                limb3: 0x1aebfbe450bf76170dfce61
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x1e8861019f4e1c0cea366f2d,
                limb1: 0xd5d764b704ebe58a4922639e,
                limb2: 0x63c6c6915a1d308e31bd8ad6,
                limb3: 0x128e9fb216ed0a01eb0a6397
            },
            x1: u384 {
                limb0: 0x4c4ec1a5c6b8d1e1f4db4685,
                limb1: 0xdfabd7932465b72464f256e5,
                limb2: 0x980707c41b6f74927550a1cb,
                limb3: 0x1296ea8b8ebf1f95de5e3d2b
            },
            y0: u384 {
                limb0: 0x7b2a3052589a3b2c3261a131,
                limb1: 0x2c0642df5036d0e4ab93be88,
                limb2: 0xca0b6c01f87fede72b974e25,
                limb3: 0x24a297ba04aba5987c9a18a
            },
            y1: u384 {
                limb0: 0x4597a456c85f27dc9b171764,
                limb1: 0xf9dcfd6d9791438c3b3ab8c,
                limb2: 0xc90eb3041fc2fa2af36ce4e,
                limb3: 0xe685e72e8c9f0daab484ee2
            }
        };

        let new_lhs: u384 = u384 {
            limb0: 0x3794e70a3e4efb8131e682e5,
            limb1: 0x37de069187e9ea86fed29b0d,
            limb2: 0xba75cfb67b9ca64cbdf18bdf,
            limb3: 0xc3ccd48c87f0387715a74eb
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0x177be89520321f2a9333469b,
            limb1: 0xeca9e0ec2bb323a0586ee936,
            limb2: 0xf5e668ae638b8bb397e41186,
            limb3: 0x10b5cc8f67ba6daf84aef133
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(new_lhs_result, new_lhs);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit_BLS12_381() {
        let lambda_root_inverse = E12D {
            w0: u384 {
                limb0: 0xfedb852f1cce93d1e5c82361,
                limb1: 0x4e2cf6881adf1bdb6fed84eb,
                limb2: 0x2a9ec86843f2636e72050a31,
                limb3: 0x435b5769a62513f64029517
            },
            w1: u384 {
                limb0: 0x30fff4f66876826d9173c6c9,
                limb1: 0x846f285629562672234e8815,
                limb2: 0x17cd9a14eb8fca44ed9a79a2,
                limb3: 0x63e5921e38dbb7e3ad361de
            },
            w2: u384 {
                limb0: 0xcaa2e10f4c4070985dd64593,
                limb1: 0x75b8b565cb6450234be91cbc,
                limb2: 0x80869f58e959642a7ddf20e5,
                limb3: 0xaf1cca30a99908598f1d552
            },
            w3: u384 {
                limb0: 0x6e1625f34b4444b547006868,
                limb1: 0x7fec7d978e13c327b461cc8f,
                limb2: 0x4834bb3a05147fea96447c04,
                limb3: 0x9a6be36d096ec0fe51894d
            },
            w4: u384 {
                limb0: 0x6a686d6ffb30673605fca7b7,
                limb1: 0x971056e21584ab4ded844156,
                limb2: 0xf3692b223949ae4b87ea36aa,
                limb3: 0x1546163c4375050815303ada
            },
            w5: u384 {
                limb0: 0x61a913ed947a59ff1905ccd1,
                limb1: 0x6084b2b0b5fc791faa3091ca,
                limb2: 0x727201681f587caae13ae716,
                limb3: 0x89d16ee03b267e216396b7a
            },
            w6: u384 {
                limb0: 0x29bbd86ece89ce20ca9553d2,
                limb1: 0x3c6c0da87f42542c5baf6653,
                limb2: 0x5a24e7864af372be364ac7f4,
                limb3: 0x4d3b876c74093ac314f7e99
            },
            w7: u384 {
                limb0: 0x7f4ad1b5a72fabab25edfea9,
                limb1: 0xe688f05e7e6f332d367cf088,
                limb2: 0x53a088622732acd62f348ad2,
                limb3: 0x7fac16afbd57df46121549
            },
            w8: u384 {
                limb0: 0x728c92053d4b89bcbedda067,
                limb1: 0xea8577789cf414ba49e36c5,
                limb2: 0x1b20bbf65e4baa2aaeee1052,
                limb3: 0x122b5a9a4700a3cd6d3914c0
            },
            w9: u384 {
                limb0: 0xeda0f2f310fdb1ca941a7e9c,
                limb1: 0x5996c8b37fab391ca498fe88,
                limb2: 0x2f529eb616292b043072b121,
                limb3: 0xde4b97c07fe7ec8118dcca6
            },
            w10: u384 {
                limb0: 0x97bf86b35768ba9a1fa9abd6,
                limb1: 0xaf2dd8f01d192eec529fefba,
                limb2: 0x54c5b27de630f8e3286f793d,
                limb3: 0x10fedbf54ce31c63feb6a282
            },
            w11: u384 {
                limb0: 0x1cddac23f10f1f62e46fde3b,
                limb1: 0x229edea18b5feab3d68944a5,
                limb2: 0xa043594369cdd91a57ee3e46,
                limb3: 0x163d12f0e23d2e902f9ffc1c
            }
        };

        let z: u384 = u384 {
            limb0: 0x5695ac3c0adaf92d2534d858,
            limb1: 0x333ea67cc5ad1ab14e360157,
            limb2: 0x4937198de6c0cc8e3fec4cd1,
            limb3: 0x109c59420150e8637021e6b0
        };

        let scaling_factor: MillerLoopResultScalingFactor = MillerLoopResultScalingFactor {
            w0: u384 {
                limb0: 0xc7ff1f218839e2b5409d108c,
                limb1: 0xf131aac79f4b6e251f1472db,
                limb2: 0x35006ba6035d6edea3c9ce99,
                limb3: 0x12478d6db499acf32f57fe38
            },
            w2: u384 {
                limb0: 0x641ff106866bda9f4d7d57a,
                limb1: 0xc03f00347399a177217a56b1,
                limb2: 0x822bbc3d7149403167ef7e9e,
                limb3: 0xa361478c9e7baba75da3e50
            },
            w4: u384 {
                limb0: 0xf93b5dbfc3aea2d1ba2bdab5,
                limb1: 0xbaa5daefaba3770b85c4b44f,
                limb2: 0x7bb8be94703f1ed0add178ef,
                limb3: 0x213ab914562daff16b26435
            },
            w6: u384 {
                limb0: 0x322931d3a38685f66db7d4f3,
                limb1: 0xa5d01c19b80150f9c7a3177c,
                limb2: 0x599691d61565fe5d145581da,
                limb3: 0xc4e81a9159cebfcdef0c738
            },
            w8: u384 {
                limb0: 0xdcde33b764954fe3b1dbbb32,
                limb1: 0x304502ae6aa0cb4bb6a712d0,
                limb2: 0xcd6e3c6ff9b7d2fe57e6615c,
                limb3: 0x15be3817e3d88a3f1c1096e
            },
            w10: u384 {
                limb0: 0x2225137e808a845950bc0c18,
                limb1: 0x92eb46144b4f82484e49720d,
                limb2: 0x26d44c2b1e75fe1b94c9577,
                limb3: 0x1cd643e213a786ef22cfeb1
            }
        };

        let (c_inv_of_z_result, scaling_factor_of_z_result, c_inv_frob_1_of_z_result) =
            run_BLS12_381_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit(
            lambda_root_inverse, z, scaling_factor
        );
        let c_inv_of_z: u384 = u384 {
            limb0: 0x442c8ee0a62ea6cbf130c1d8,
            limb1: 0x12a08af575619a6415a7d8f7,
            limb2: 0xc17429c4d8c403b172fc3622,
            limb3: 0x2a93490b8010fac4592148c
        };

        let scaling_factor_of_z: u384 = u384 {
            limb0: 0xa2f4a14c317e5cbaa29720a3,
            limb1: 0xb7303c5c9fdf89ef109d6867,
            limb2: 0x3a987101ec2fe98782e73f76,
            limb3: 0xb76f5faa57f3831107e0a32
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 0xfc5ecc6a22f25297d4660391,
            limb1: 0xf55db8e3215d1113e6a3abf7,
            limb2: 0x56d960f517f01b1c974e3c60,
            limb3: 0x527909251f78e4fc8f2cf59
        };
        assert_eq!(c_inv_of_z_result, c_inv_of_z);
        assert_eq!(scaling_factor_of_z_result, scaling_factor_of_z);
        assert_eq!(c_inv_frob_1_of_z_result, c_inv_frob_1_of_z);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_PREPARE_PAIRS_2_circuit_BLS12_381() {
        let p_0: G1Point = G1Point {
            x: u384 {
                limb0: 0x3f4fdb9b15ed9d8a5948f633,
                limb1: 0x5ca5b513acf6e8e95d8ae987,
                limb2: 0xe2fe66d1cb64acd73331cc05,
                limb3: 0x107fe1675380531c09fa0833
            },
            y: u384 {
                limb0: 0xfd951b7515b5160f062384ff,
                limb1: 0x22a7c34946a6452df2510186,
                limb2: 0x46a55245f525e3d6709848fd,
                limb3: 0x96fb242ed99ac9edd75dd0f
            }
        };

        let p_1: G1Point = G1Point {
            x: u384 {
                limb0: 0x892c5c7c12c1138bd7bec639,
                limb1: 0x23b1fa5b983203de13c49a5c,
                limb2: 0x1eaca5d5964cc436f18e44f8,
                limb3: 0x1106e95010c1a29afc01694a
            },
            y: u384 {
                limb0: 0xe52cbc1987de8f23e9a772e,
                limb1: 0xe771ebab8fdf98182142373c,
                limb2: 0xdc91b762b04eb32e561f7e5e,
                limb3: 0x192f04b5137e21d5189c0ffc
            }
        };

        let (p_0_result, p_1_result) = run_BLS12_381_MP_CHECK_PREPARE_PAIRS_2_circuit(p_0, p_1);
        let p_0: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 0x7f6e69c67fdab668086214e,
                limb1: 0x65da48ca8b5e151a00b3ab4b,
                limb2: 0x639946ab6caaf4c19a719e7e,
                limb3: 0x11ae2213e6767c95378a4011
            },
            xNegOverY: u384 {
                limb0: 0x509cfb1d43fe046b2836e9d9,
                limb1: 0xa625f8f13f1ee68cff02c7bc,
                limb2: 0x73e356eab99fbac996d46d68,
                limb3: 0xba33827ce13ab85d746aba7
            }
        };
        let p_1: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 0xc5df6aba71573040638ecad5,
                limb1: 0xed950080d3c88033fe9adfe3,
                limb2: 0xc945d826706302f888cda9f8,
                limb3: 0x9caade636ec0a308af3e088
            },
            xNegOverY: u384 {
                limb0: 0x552b01c876bbc9df1d2bfb82,
                limb1: 0xf4d21d75a0df3594e9ee124e,
                limb2: 0x85cee0c4a9dae9b304676da4,
                limb3: 0x14a39c65eb519bdc5a8588fb
            }
        };
        assert_eq!(p_0_result, p_0);
        assert_eq!(p_1_result, p_1);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_PREPARE_PAIRS_3_circuit_BLS12_381() {
        let p_0: G1Point = G1Point {
            x: u384 {
                limb0: 0x93a023f2c17c182023f650e8,
                limb1: 0xd4f604c92ccd2ac3d3fafe13,
                limb2: 0x224bfb0d598d5ca2c485009c,
                limb3: 0xf2dcedf872fe36142b28540
            },
            y: u384 {
                limb0: 0x4716a271b69c39b9a73d23a6,
                limb1: 0xdda401e9b331cf4d3e903735,
                limb2: 0xdd010cc23ce92989bc84b6,
                limb3: 0xb2c607b36d642824b6a1b1d
            }
        };

        let p_1: G1Point = G1Point {
            x: u384 {
                limb0: 0x7e4e182b61f5351032068b53,
                limb1: 0xf13ef6d24161fe8753d58c58,
                limb2: 0xc9ab9a1b986079bb0344e247,
                limb3: 0x75fdad743e1dfa22522466b
            },
            y: u384 {
                limb0: 0x5662d87b7fe5c73f1b7a4ea3,
                limb1: 0x15e2eb529d3eef19d02cf526,
                limb2: 0xaac37d223bb47ebfce0efed3,
                limb3: 0x52103384b4cf406ad21e2ab
            }
        };

        let p_2: G1Point = G1Point {
            x: u384 {
                limb0: 0xa60153ea22b5df976b486220,
                limb1: 0xb09775019c689b36aa46a794,
                limb2: 0x1d04fa25a4508eb5873156b8,
                limb3: 0xd4ed853d45b875b98103029
            },
            y: u384 {
                limb0: 0x4d26d96f5b9999d77322fdfa,
                limb1: 0x1a35187c79da10b9920cd3b8,
                limb2: 0xb1a1ad3971abea96e2f4c35c,
                limb3: 0xda40045da5460b1dfa4807e
            }
        };

        let (p_0_result, p_1_result, p_2_result) = run_BLS12_381_MP_CHECK_PREPARE_PAIRS_3_circuit(
            p_0, p_1, p_2
        );
        let p_0: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 0x438b7b485f6c3c7c5536e3d7,
                limb1: 0xb0ea9fd27529e7df43381af0,
                limb2: 0x7e405e0ae33982c6701f6b60,
                limb3: 0xb8b3c45f10044ea59944c8c
            },
            xNegOverY: u384 {
                limb0: 0x4c194cc6c98a03d648612bf2,
                limb1: 0x60a5ef1b9f61b62298c37208,
                limb2: 0x9d7a715d6e8170ba35ca4c0b,
                limb3: 0xebbc86c0cc85fff4b85c41b
            }
        };
        let p_1: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 0x22fb679d67b48a9b18ca8385,
                limb1: 0xf4105cb7cefdf04c286b1689,
                limb2: 0x11774cc8fd1ad6c857e55e3d,
                limb3: 0x13887e442e3ca5182a0b4576
            },
            xNegOverY: u384 {
                limb0: 0x5ef78526f75e6fd58bed6e4,
                limb1: 0x414387582ecdc0828c3ca462,
                limb2: 0x23806e7e666b66dcae887e7f,
                limb3: 0x1420709678e30bbca316234d
            }
        };
        let p_2: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 0xf1bf714e919cef375f439338,
                limb1: 0xdf893f2960610358ddbebb7a,
                limb2: 0x66c2dd00b50281c7c2065ed8,
                limb3: 0x10c2f0e60abc0d2bb434c2ed
            },
            xNegOverY: u384 {
                limb0: 0xf0a8702a1b98a9a5b6b04cd3,
                limb1: 0x87b0371051e7d203b22d959b,
                limb2: 0x4ec6fc988cb32ab21e906e11,
                limb3: 0xb0ccf5200ec2ee829490814
            }
        };
        assert_eq!(p_0_result, p_0);
        assert_eq!(p_1_result, p_1);
        assert_eq!(p_2_result, p_2);
    }


    #[test]
    fn test_run_BN254_MP_CHECK_BIT00_LOOP_2_circuit_BN254() {
        let yInv_0: u384 = u384 {
            limb0: 0x7afc50cdb8bc6621f2d7fe55,
            limb1: 0xaa099a46f25a3c68e8ef99e9,
            limb2: 0x2a6bea1ed181d9bf,
            limb3: 0x0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0xf3254f2d47595b016c835975,
            limb1: 0x878f40ed2c805ac7d48457df,
            limb2: 0x40ce4c42b7bde99,
            limb3: 0x0
        };

        let Q_0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x284b7bcda3af11d0a8ab29f1,
                limb1: 0xf110397a1c2c7a3494665d45,
                limb2: 0x2874cddc81011c5b,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x9ae445e08b1dc2f8cbf1f93c,
                limb1: 0x6f446806c1378e75627b9de7,
                limb2: 0x13edf0ee4408c04c,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x6dbf859c037d975248f3531c,
                limb1: 0xd1db32f8fda834eac74dd25c,
                limb2: 0x11f2bddeb7c97da8,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x89b1e0d44218ca25f23db306,
                limb1: 0x5163de1d8df7a26786fadb0e,
                limb2: 0x15e7a691fd768f63,
                limb3: 0x0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0xc857d8c3b4a0697630a31251,
            limb1: 0x2446eceecaa0a6796e83a7b2,
            limb2: 0x611e00d840fccb,
            limb3: 0x0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0x8772c3475cba9be3040464c0,
            limb1: 0x28948b4cf0fcccc6fb46ed39,
            limb2: 0xc72d7a3ae2562ca,
            limb3: 0x0
        };

        let Q_1: G2Point = G2Point {
            x0: u384 {
                limb0: 0xa0b87e455abec113a1832fdb,
                limb1: 0x4e6748a7f3ab7dcb3390a6e,
                limb2: 0x2f0e786cbb1d8677,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x13f2dc866b83f00fed2ee36f,
                limb1: 0x3c9a923672bbe7b392b95731,
                limb2: 0x2daf28a8be792965,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x824734dfdd1f8e30731c877a,
                limb1: 0xcf709452ce8c037ee51c0cdb,
                limb2: 0x66d4edfb47a5dce,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x2a1bc11230331476f53fc3dd,
                limb1: 0x10b2e6e5ec6e61bd70c455a9,
                limb2: 0x1b4fd2cded9081c1,
                limb3: 0x0
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 0x9c14940d5b2d81ccc602bd20,
            limb1: 0x4e98ce2517337a7c53e83663,
            limb2: 0x1f856a8b07b6e28f,
            limb3: 0x0
        };

        let f_i_of_z: u384 = u384 {
            limb0: 0x402492a3c334f55802cee581,
            limb1: 0x65dcac6cc329870a33e9e55e,
            limb2: 0x1be110e462f9dbb2,
            limb3: 0x0
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 0x771ec087952b1ee109d5b64f,
                limb1: 0x919c21edd47133e75ac5f4f0,
                limb2: 0x241f614c2076d932,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0xaa5658322a5a421858da7da,
                limb1: 0xdd6d47e490e0172f14dc01bc,
                limb2: 0x171af96558f16c91,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0x30d6863f11c272d801267789,
                limb1: 0xabe0a1771c5e1698b7a02afd,
                limb2: 0x1e268a0a8a663359,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0xed9a189a50852f4f0b09ec41,
                limb1: 0xf45aa79bd855fb35d763b159,
                limb2: 0x19ffb39f1ff06dc,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0xe7bf9a9664849eb55096ccf2,
                limb1: 0xfe292238fbfbe6022011bc8a,
                limb2: 0x28ad3485c3c5707d,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0xa4531fe9b48f653e7b1bcb6b,
                limb1: 0xb93c2989c399fd7fb75db71e,
                limb2: 0x2eb530a20bf56ed8,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0xb20ee0f85050a17d2e1ed4d,
                limb1: 0xb0f1bb1d8e10fed6d2d07223,
                limb2: 0x2ca0d526be80793e,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0xb34dc8b053f3c15842ce91c0,
                limb1: 0xc846bf9040fe6898b56b9357,
                limb2: 0x211dabe6425de95f,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0xffa0841974dbcc40ef7dee1a,
                limb1: 0xc1b5468a27bb1580e8f58c5d,
                limb2: 0x1cb98c5be6710ad2,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0x9e1c3b0271f27728d7f7ba5,
                limb1: 0x2d4da4ef95e38180a1ee691a,
                limb2: 0x20c84084a43c991d,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0xc1f8190be55e44b808a6d5b4,
                limb1: 0xf25dcb50d15b598550eaa1d2,
                limb2: 0xc5842cf1257363c,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0x74e04bbbca8033a7a5fd89c8,
                limb1: 0xcff0c8ac3d1cd68c9c63765b,
                limb2: 0x216cc0f4756b6c0d,
                limb3: 0x0
            }
        };

        let z: u384 = u384 {
            limb0: 0x8b1f11370ea255e08e50c79a,
            limb1: 0x848610cfd21276c21519401c,
            limb2: 0x28500b57e7ef7b,
            limb3: 0x0
        };

        let ci: u384 = u384 {
            limb0: 0x147a08acc65d8e4ed01e488b,
            limb1: 0x9b87cc5e6d7fe9b21a9e8547,
            limb2: 0x247f5f525a31a6a6,
            limb3: 0x0
        };

        let (
            Q0_result,
            Q1_result,
            f_i_plus_one_of_z_result,
            lhs_i_plus_one_result,
            ci_plus_one_result
        ) =
            run_BN254_MP_CHECK_BIT00_LOOP_2_circuit(
            yInv_0, xNegOverY_0, Q_0, yInv_1, xNegOverY_1, Q_1, lhs_i, f_i_of_z, f_i_plus_one, z, ci
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x61f1e6aff16a5581eb1c9042,
                limb1: 0xceb503a68f2f33d44fcd46b5,
                limb2: 0x1c7f88b9f43ae2b1,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x8f4af62b3f71b84464d34aea,
                limb1: 0xc1c1a4023de06e3c2197885,
                limb2: 0x114bc2421c65ac2d,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x2b267b69303e8272c061c1b4,
                limb1: 0xc61bf78d32fd83f785e83827,
                limb2: 0xad60717816cd0f0,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xe57406ed85ca61a406f1461b,
                limb1: 0x493f9c3d33963c228445e5d7,
                limb2: 0x1e48a59eea29857,
                limb3: 0x0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0xa75440c85a972a58042e52cd,
                limb1: 0x6219d0b45ec2488a1f4ac258,
                limb2: 0xed6147c5077bc41,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x843db3c4d38f66ba79f6b783,
                limb1: 0x2b6eaebfe0cba1833c8b9f5a,
                limb2: 0x36e8fca4aff7404,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x9e6282f3b72184e7ee6f64be,
                limb1: 0x25ec47a0d6fa32a3af50e6b7,
                limb2: 0xd68ecc0462d6ce5,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xb2eb8695487da46715ceac85,
                limb1: 0x543ff0a5da12f7cbda559406,
                limb2: 0x1db0e866a2872cae,
                limb3: 0x0
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0xa0d4974ca56dea17096eb6dd,
            limb1: 0x46a1911ae3e3ae2043e9c5b9,
            limb2: 0x24a254c8fbabf5b7,
            limb3: 0x0
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 0xc802dc191ca2c46b8b0e38a9,
            limb1: 0x64686f3171cd1669dd78590b,
            limb2: 0x2e67a73374cdad0d,
            limb3: 0x0
        };

        let ci_plus_one: u384 = u384 {
            limb0: 0x83220dfbd6c329af8a27152,
            limb1: 0xf5aac6204c8c191cfb006a7b,
            limb2: 0x2f51f3edce1f8ab4,
            limb3: 0x0
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
        assert_eq!(lhs_i_plus_one_result, lhs_i_plus_one);
        assert_eq!(ci_plus_one_result, ci_plus_one);
    }


    #[test]
    fn test_run_BN254_MP_CHECK_BIT0_LOOP_2_circuit_BN254() {
        let yInv_0: u384 = u384 {
            limb0: 0x82ae752f2d4076bcf9cb2ee8,
            limb1: 0x22b56be11392a255fdc12930,
            limb2: 0xd375d89c3d9b3b0,
            limb3: 0x0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0xbb8917463c3da91136a52df9,
            limb1: 0x3bd3147dd0f0c75d21d32e24,
            limb2: 0x189d651ac28d2ad5,
            limb3: 0x0
        };

        let Q_0: G2Point = G2Point {
            x0: u384 {
                limb0: 0xd57caf0d9db3466d1ba6cc61,
                limb1: 0x989bb03086c47b0606a8e22f,
                limb2: 0x1f4f09e65bce228b,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x33c14694f06ea1874a26444,
                limb1: 0x8e36b82f3856be31f568c9c6,
                limb2: 0xa6f33baa71b80ef,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x7ea496f5e10b4aada92d6b05,
                limb1: 0xbcc4616df40d2a37cf2a2198,
                limb2: 0x22f222f37b1d4049,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xd9082a42b4480761505e9c9b,
                limb1: 0x232f8c5b425832c0142a6c95,
                limb2: 0x19b7fac79ab3cc27,
                limb3: 0x0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0x9cd3bdf356af7370f2670d2,
            limb1: 0xbf401e04b9f94ec650ae2652,
            limb2: 0xff997e4f631681e,
            limb3: 0x0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0x70f2297adceb201357d9af8d,
            limb1: 0xa8e6a772b9cde60cab1e6794,
            limb2: 0xe756d54a867a0f0,
            limb3: 0x0
        };

        let Q_1: G2Point = G2Point {
            x0: u384 {
                limb0: 0xabecfc0b581ba30742965873,
                limb1: 0x45892c14e0e15d3298e9a79,
                limb2: 0x24b5bfdc5b3a4595,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xbb78eb2d0ee5144d8a1d8b42,
                limb1: 0x5a79b46a26b61b06a1645f58,
                limb2: 0x1f6e4c7305a0f421,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x1109197853a081a6a7647989,
                limb1: 0x584d3c020ff9d318d22a3a62,
                limb2: 0x2a7e93a9f8db1a4d,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xe47638ec22c71d046c32faff,
                limb1: 0x72ef7dce376e22a6ec071cf1,
                limb2: 0x9176db26f6a2196,
                limb3: 0x0
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 0x61f68c6e689c0559bf4fa4a3,
            limb1: 0xe413961f68c6dd5e027752fe,
            limb2: 0x22283b734384860c,
            limb3: 0x0
        };

        let f_i_of_z: u384 = u384 {
            limb0: 0xebe7ef9190920b690abc847e,
            limb1: 0xf436498e68afe2b81f626a97,
            limb2: 0xaf6d5c863eaa07f,
            limb3: 0x0
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 0xc9a57cd1be28e8c52b395c4e,
                limb1: 0x8fb87c76af044a8dd69db137,
                limb2: 0x2df0513e2b16ad04,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0xed7a6edf6d5b7d501417d4f9,
                limb1: 0x1a895c62990e8f01dd5aacc7,
                limb2: 0x2839dd219ed9c124,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0x266b0d37b5c99b49751f7e54,
                limb1: 0xa40a3799a1ab3579d6c84af,
                limb2: 0x15c6a93d40a21015,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0x16f14aad7f107645094c0230,
                limb1: 0xabf0f4bd4af0a6fe5bbdd1f4,
                limb2: 0x1d51c937269b6c3b,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0x5b1654ad81e774de3c740119,
                limb1: 0xc0c32da9bc49b58e298b7e5d,
                limb2: 0x159bfcfb679b29e8,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0x7e083c1bcda6a326451437d6,
                limb1: 0x3c8e1046480fdc0f1c58f44,
                limb2: 0x21f11fae4f8e3e01,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0x8cea309b49c94aa5e689e5e8,
                limb1: 0x8f1100bfa3222c4780afabf,
                limb2: 0x2208e619c5dd967b,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0x432fb3088d56206d920c3de9,
                limb1: 0x9ce15a8afd4fc7bef208346,
                limb2: 0x1948bfd174b7061c,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0x675e0c521eb95739b8acdd81,
                limb1: 0xd18533e7efa2faf58ba0bf3,
                limb2: 0x1179a56c054b8816,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0x8c626a9fee4e6bcbd6deb92,
                limb1: 0xae2e45a4ae4404d74100e665,
                limb2: 0x2cf92f4e94fe31a0,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0x571c9d788429aeae877e5ea1,
                limb1: 0xd59b148ffa7bff5f62d59938,
                limb2: 0x100a623ff8cc3f3b,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0x253dc8cd1f0c570bf5545ce,
                limb1: 0xd1f0a7fd0fce92295be263b,
                limb2: 0x9fea2e2909b471c,
                limb3: 0x0
            }
        };

        let z: u384 = u384 {
            limb0: 0x5cfa38b1583678eef3ca5f64,
            limb1: 0x4b1dd9fda02ebb764a8b77da,
            limb2: 0x1fabc59e52b04994,
            limb3: 0x0
        };

        let ci: u384 = u384 {
            limb0: 0xb2975c6918ff3582408c3c2,
            limb1: 0x5762762620379089711fa10a,
            limb2: 0x98a96aedec31ef,
            limb3: 0x0
        };

        let (
            Q0_result,
            Q1_result,
            f_i_plus_one_of_z_result,
            lhs_i_plus_one_result,
            ci_plus_one_result
        ) =
            run_BN254_MP_CHECK_BIT0_LOOP_2_circuit(
            yInv_0, xNegOverY_0, Q_0, yInv_1, xNegOverY_1, Q_1, lhs_i, f_i_of_z, f_i_plus_one, z, ci
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x709b79c0016dcfd4d18d8e9,
                limb1: 0xcef9038bef3d72d673eaba29,
                limb2: 0x11dd395f5cc03090,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xf3739dee81cf309819de3fc3,
                limb1: 0xd9191ccff47562ed9362aeab,
                limb2: 0x87cddf5617b4f9d,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x5c32ac38e2ee4badfdbd17ca,
                limb1: 0x183c0c432a36a7d1fd8b75e7,
                limb2: 0x2d9f630eeeedc9cb,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xb9ae36d99b044841567b9cc3,
                limb1: 0x94cdfe418ba4ee6602cbfba,
                limb2: 0x17b437c72e72dfa4,
                limb3: 0x0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x95dbab22b620f334bd08090e,
                limb1: 0xbe0c181970dd5968254546a0,
                limb2: 0xd8499ec716c5dd6,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x7cbc7c93a10519ee31a1283a,
                limb1: 0xf05b07e217fdfcada5e4e011,
                limb2: 0xbbff95280e7ca68,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x20de46ab9a13f96d674f4f9d,
                limb1: 0x9add107b18f9f7389eff6948,
                limb2: 0x1b3d26b74ce6c4d7,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x77c082027d0d48df22d98dcf,
                limb1: 0x701d8daf3f68d0555429acea,
                limb2: 0x135039c7f87e262a,
                limb3: 0x0
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0x4b10e829f70fb67016b73d29,
            limb1: 0x419706cd37a5205994270789,
            limb2: 0x16f8f1f5a341abe,
            limb3: 0x0
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 0xb670921a0d9e11e444b472f8,
            limb1: 0x89a6405bc4366cc2907c8700,
            limb2: 0x164b7a6475a3389,
            limb3: 0x0
        };

        let ci_plus_one: u384 = u384 {
            limb0: 0x557c248f63a6d973e62aaf86,
            limb1: 0xe0212841ca665745829b5fe5,
            limb2: 0x2f8ffc498f40699f,
            limb3: 0x0
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
        assert_eq!(lhs_i_plus_one_result, lhs_i_plus_one);
        assert_eq!(ci_plus_one_result, ci_plus_one);
    }


    #[test]
    fn test_run_BN254_MP_CHECK_BIT1_LOOP_2_circuit_BN254() {
        let yInv_0: u384 = u384 {
            limb0: 0x1e6cbd83a2f62516dc88b09c,
            limb1: 0xeceec38d511fcda922d80170,
            limb2: 0xbafb4df05d156b6,
            limb3: 0x0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0x4ea581d20068c1cbbd743b3,
            limb1: 0x9b83acd5e2ccddd8567fec5e,
            limb2: 0x2d32e82317eeb1d,
            limb3: 0x0
        };

        let Q_0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x13d1ea49ed469bf4d5cf2dc4,
                limb1: 0x70d227180dd35d11688181a8,
                limb2: 0x26aa427c5adffd04,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x6987b05274219d3ecdc39412,
                limb1: 0x7427965607db34e02e402534,
                limb2: 0x10e7d2e1cd6a5e0c,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x633d9c54f30459cc30c42d61,
                limb1: 0x18a775945b8c4949106861d3,
                limb2: 0x1ad0adb1f94e3c8,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x74db99f352a33c33037e5725,
                limb1: 0xbefa9c478dd6650fca6ef7ce,
                limb2: 0x2c7861b5df254e5d,
                limb3: 0x0
            }
        };

        let Q_or_Q_neg_0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x1498665b79fe0a1b7efbe877,
                limb1: 0x891dfa7b0d3dc6aadba45b5e,
                limb2: 0x19b945d9dcb32e4a,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xdbc33e56c8a17945ca6d3e06,
                limb1: 0x71dade6432255eeeceb9505,
                limb2: 0x2103eec2a5e327af,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xd39a4bb0d62b68d41880fa4b,
                limb1: 0x5bc9e8895567a84c1480f037,
                limb2: 0x64d97d8f484878d,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x259a2b28b22b89748c5c192f,
                limb1: 0xc781e11f2cb38568291a58af,
                limb2: 0xa2ca66febbe1a41,
                limb3: 0x0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0x3e19d0baae09ccfba3dee81f,
            limb1: 0xef23d4afe0ff58a5f172840f,
            limb2: 0x150262399fed6060,
            limb3: 0x0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0x7ba06f58061ae8d1f212cc6f,
            limb1: 0xa036e74be34d7804f5657d00,
            limb2: 0x197a8a74adae7e45,
            limb3: 0x0
        };

        let Q_1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x39ddc4775a220eb23cf9d1fe,
                limb1: 0x6bb6204ee0db22d329e316ad,
                limb2: 0x174015c57680891b,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x2353d45590bccb66e0631450,
                limb1: 0xc5507d2b909e7f7862f25291,
                limb2: 0xa60840303729e33,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x1716f1d956a2f20ee283bb7,
                limb1: 0xb7ed75b463d0fccdafdb4e0b,
                limb2: 0xb016e1ccd34bcd7,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x4fe973d261cec19fff83cec,
                limb1: 0x52c553b5d2f7442906714938,
                limb2: 0x3c918082951fe0,
                limb3: 0x0
            }
        };

        let Q_or_Q_neg_1: G2Point = G2Point {
            x0: u384 {
                limb0: 0xc6f149c70c15a57509c64c1d,
                limb1: 0x92b035e01ca5a2f5ecf150e6,
                limb2: 0x973d4719c899296,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xac7074642734f9bbc7405255,
                limb1: 0xc9a6e611613f718dc96ef1a5,
                limb2: 0x1acc975206c4e109,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x829fe7ba5d30db822348e1b7,
                limb1: 0x667fceeb8889832c37773772,
                limb2: 0x84e9ab612b34a24,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x789c3c723ee29e686fa00319,
                limb1: 0xea951570399bcb7961bafa39,
                limb2: 0xf5d0e7b65141471,
                limb3: 0x0
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 0x65a5ac1f7b2ecfc5a53011a2,
            limb1: 0x11ab249d94d50a99eba08424,
            limb2: 0x1026cf16d5e8b89c,
            limb3: 0x0
        };

        let f_i_of_z: u384 = u384 {
            limb0: 0xe291f5e1469fc269ff7acd86,
            limb1: 0x8ad6cc515f2e104886ce563d,
            limb2: 0x26a87b35058fe8d5,
            limb3: 0x0
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 0x797c27bfc79385209c921e7f,
                limb1: 0x46ba68553cad275ae072caae,
                limb2: 0x271a137c0a515e87,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0xcc4e66dade0989b952526d45,
                limb1: 0xa0483bb2f6d080c46409df32,
                limb2: 0x2234ca061b4e1428,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0xdec772b7bb22fa316bc9e970,
                limb1: 0x6ed63ea464a2bc48f9fb4010,
                limb2: 0x6b559b0ecb03f48,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0x9aabd22d75ef8aabb693f4ef,
                limb1: 0x2b6b7b42295023267644d183,
                limb2: 0x1e5be620572abb53,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0xeef671391ccdd34080e97f74,
                limb1: 0x24878d19586d7f415e47c2a0,
                limb2: 0x16e3446ea0ec3e5a,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0x2d492ca241f4317df5141524,
                limb1: 0x531da6ac956c2129b934718f,
                limb2: 0x1853c7774bc972ce,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0x4a8636550a9d499ca2698c2d,
                limb1: 0x8ef444a6e63ffa48d2ad974,
                limb2: 0x1a4666a2aea62315,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0xba5612f7600aa45e44e1b08c,
                limb1: 0x22587c8958ccf9b4354af1bd,
                limb2: 0x70f234d21d4fb7e,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0x2a6f1e475b61f92b9cf600ec,
                limb1: 0x93a25c9b6e3a52d707fe6a4e,
                limb2: 0x1daa4cf365fd5f69,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0xb5f50316a45335cc137fcd2b,
                limb1: 0x13ec5718ae4a741ab5004950,
                limb2: 0x1b3a35f7c71d92d6,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0x8dcd7d64b9e8e4ee8b7f6d7a,
                limb1: 0x2728ec952b52dab12367ad9e,
                limb2: 0xa86b3a1351c5aac,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0xbc6284a89f93e802e1c25cd1,
                limb1: 0xcb10cf68b769147049bcf4a8,
                limb2: 0x2bc9cfd055cdd72e,
                limb3: 0x0
            }
        };

        let c_or_cinv_of_z: u384 = u384 {
            limb0: 0xb1f5d7d0887b4cca54f02dc4,
            limb1: 0x604aa4a2e983cc1d25033a3e,
            limb2: 0x2f58decefc0b1519,
            limb3: 0x0
        };

        let z: u384 = u384 {
            limb0: 0x4e245cf78e33dcabbe684e2b,
            limb1: 0xea31e67ae16802053c0a94de,
            limb2: 0x183a6f5efe1c51e5,
            limb3: 0x0
        };

        let ci: u384 = u384 {
            limb0: 0xf2ded00f63e8695158b5f052,
            limb1: 0x4e60678b82f4b48a78a55d6b,
            limb2: 0x1a3f190af6f25926,
            limb3: 0x0
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
            Q_0,
            Q_or_Q_neg_0,
            yInv_1,
            xNegOverY_1,
            Q_1,
            Q_or_Q_neg_1,
            lhs_i,
            f_i_of_z,
            f_i_plus_one,
            c_or_cinv_of_z,
            z,
            ci
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 0xcb49ce333375e72331104cb5,
                limb1: 0xcf3031b8487c71483ac56321,
                limb2: 0x1060d9d2bc5c8e41,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xc54d64a7f53b0123b7b94af4,
                limb1: 0x962b923044357ca22dbfaed0,
                limb2: 0x2dec8d5c756454cf,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xf5f1eaa8bebfcc47c1540fa6,
                limb1: 0x2bcc156fec72201dc9d73d97,
                limb2: 0x10ab0c1eaaeee4f9,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x2cb14dad242a01c604ed2e32,
                limb1: 0x1dbe35cb106019fe13ab4fdf,
                limb2: 0x185fa5e2ef53b91e,
                limb3: 0x0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x4701abae9b3b6db4a86f9c2a,
                limb1: 0x9b97cce2eea637b7675e2eea,
                limb2: 0x1af5f776ef510a6,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xb7009feedaff62d4d3739a65,
                limb1: 0x74223a9b8342e9dcec9f5215,
                limb2: 0xa6d5ae76cdbf7b4,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x24b245b46aa82b0c5fe5bc6c,
                limb1: 0x1c7502814a1a7b9e46580665,
                limb2: 0x2ea40408de8540be,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x64b9822b44924b5991672529,
                limb1: 0x885988834cd1eb79d708caee,
                limb2: 0xcfc9aad56c4f1d,
                limb3: 0x0
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0xff184a23fe0d7388a17d12fa,
            limb1: 0xa74bc33f49130ba876ce8d23,
            limb2: 0x27b86c6364c3b61c,
            limb3: 0x0
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 0x505688f8bf1dbb678039e1eb,
            limb1: 0x3732d6cbfb880be47790d77e,
            limb2: 0x117118cd566c8d47,
            limb3: 0x0
        };

        let ci_plus_one: u384 = u384 {
            limb0: 0xb08b9aa2fad35e267df2c712,
            limb1: 0x63610c293877597edffa97ac,
            limb2: 0x19831d2d6d14c0e,
            limb3: 0x0
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
        assert_eq!(lhs_i_plus_one_result, lhs_i_plus_one);
        assert_eq!(ci_plus_one_result, ci_plus_one);
    }


    #[test]
    fn test_run_BN254_MP_CHECK_FINALIZE_BN_2_circuit_BN254() {
        let original_Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x9c99373515a652a708fce7af,
                limb1: 0xcda840fd4adb0798039d60ba,
                limb2: 0xaa7a68e1d5a474c,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x6a2465cf16c2b4aa72f78920,
                limb1: 0xd4dc2301882ab92580b2db0c,
                limb2: 0x7da735068bfbf7e,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xfabbc6b697f43de414934a25,
                limb1: 0x52fa3935ff28355076847398,
                limb2: 0x12faf3d32c94151d,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x6fdc5e00a0d9da583db4cb81,
                limb1: 0x496749fbb2e02961ac73189c,
                limb2: 0x17747bc080638c9,
                limb3: 0x0
            }
        };

        let yInv_0: u384 = u384 {
            limb0: 0x5121f31f5028361fa94501d7,
            limb1: 0xa74b3d208c3fa29ffa4b0bc6,
            limb2: 0x1265533cfaaf500c,
            limb3: 0x0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0xb55dc442c884e6660c661a49,
            limb1: 0xe368f7d2d9732b863fb230b2,
            limb2: 0x21100ecdb13bad4e,
            limb3: 0x0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x98decbf642734d1c23d83f22,
                limb1: 0x637c3644c9345ce70e5bc44c,
                limb2: 0x11f9df8a6b291a13,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x40e3469f39b66d71951a0518,
                limb1: 0xe9184b9f501049e2f367dbe2,
                limb2: 0x22194f90cefe73ec,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x72e55360e3aeb12e7d4fbfff,
                limb1: 0x6c749cf41f7550bcb550f221,
                limb2: 0xad9ac705fdd5329,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x3b239fd80d20f686854df9b6,
                limb1: 0x7a31a27cced4dd7cb4ca0142,
                limb2: 0x1f57848623a35ae,
                limb3: 0x0
            }
        };

        let original_Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x4eec95b014c30b503d0daad0,
                limb1: 0x2ec012f0d3100ac51932263c,
                limb2: 0x83c4b51e775f27e,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x3e3c25b700b1433f5d61476,
                limb1: 0x5cb76bb9c0ff34b4e4bd7d57,
                limb2: 0x1a7d69d086861f29,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x3f1cd31b86ff76d11fe32b56,
                limb1: 0x44bfc434481ce3f97ff5101d,
                limb2: 0x1b9dc4d6677abeb7,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x25323fd3c9f35bf84d03cbdd,
                limb1: 0xfba0fd458d3ac4b92fb01074,
                limb2: 0x22d3ac00401a2e8a,
                limb3: 0x0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0xf190cb53b489f5c7e22f6e82,
            limb1: 0xc21d3ead3e4c13622826ef27,
            limb2: 0x83e97348f5a5ade,
            limb3: 0x0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0x94d7f681d5511e14e18d99ce,
            limb1: 0xbeb778d62b021118ae63ad3a,
            limb2: 0x2189772c3f79dd31,
            limb3: 0x0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x4ca49e01c6218f7ffcd4fb19,
                limb1: 0xdb0198ffde21c855cc713ba6,
                limb2: 0x2d5e9700cb85eda6,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xb8d1353905628912bdf2b5a1,
                limb1: 0xe7a2d2d0ca3c405075fc1b10,
                limb2: 0xcc9471dd8efb5c9,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x2af595a3697b85380ff73f25,
                limb1: 0x634da412816a5ea8618a4763,
                limb2: 0x18a0b0cf3665b6a5,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x7e4132ad86b0915a8880f9fd,
                limb1: 0xdb160641207417e71a608f0d,
                limb2: 0x22198aae16018cc6,
                limb3: 0x0
            }
        };

        let R_n_minus_2 = E12D {
            w0: u384 {
                limb0: 0xd335914ce62ce6a302fbad7c,
                limb1: 0x2b33be214ed05bde4d08ebe,
                limb2: 0x2fccd547f6292535,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0x586523b8f915486569967b5c,
                limb1: 0x421cf26265739938a96e2bf4,
                limb2: 0x4e79728b9e7f780,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0xdaace3a3c2f89ef40b9bcb7e,
                limb1: 0xcf21ae6a82e2f4240dbcad25,
                limb2: 0x2c5c1e3b112930f2,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0x735b3a803fbdaeed723dc8f5,
                limb1: 0xe5a15243c7281f15b5cbb690,
                limb2: 0x2a561114c2eaf172,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0xa07aeb89998df20b226dded0,
                limb1: 0x4a0609aa827acd0de15093b0,
                limb2: 0x264b9f7a03743263,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0xaab6941b59e8484c25d203e3,
                limb1: 0xd466c7725df5672b5ba48aa0,
                limb2: 0x1307d677f6b4160b,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0xd55f0e0eef6be029bbef627f,
                limb1: 0x9bcae27d331978ebdafd518d,
                limb2: 0x15b85b0a659badcb,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0xe9bf79f4b3739067cf085288,
                limb1: 0xda68fa2a59581c9454f5edf7,
                limb2: 0x26990b09a34acc3e,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0x942917266557338d6175f16a,
                limb1: 0xe53428bbb20ed71966b9b21b,
                limb2: 0x1310dd1680635ef2,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0xc1d44db0d09bf39cacb1691c,
                limb1: 0x3c38bfd6d7e239089090d244,
                limb2: 0x1b9acfae3055d84e,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0x83add75843e1592e3765002d,
                limb1: 0x23e86d638278e1e52adb6a67,
                limb2: 0x263b36f1cec7190b,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0x79d1b233a5c07ecfd38a1bdb,
                limb1: 0x424c222f577aa515eac503ff,
                limb2: 0x134e40d86ef4d6b4,
                limb3: 0x0
            }
        };

        let R_n_minus_1 = E12D {
            w0: u384 {
                limb0: 0xa6894303e807092d74ca0c56,
                limb1: 0xca19e5a80d5a2ad386d77094,
                limb2: 0xc6fcecdbac114b5,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0x7575117c41ca37f5f7de1a61,
                limb1: 0x4ade7b7119b0fb4b0fde8c9,
                limb2: 0x26385af0338589c7,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0x5c41dfb5a94a29d3f73c3dce,
                limb1: 0x44864d26cfd092769c017e5d,
                limb2: 0x2b2b0037024e8609,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0x438b3d4a81b3fe3fda48455,
                limb1: 0xea9e062a9b89bf0d054961d6,
                limb2: 0xab7f609edaeec39,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0x5cffc96ebd03c81f7ff35029,
                limb1: 0x167ad0895acecdbfdbb59fc2,
                limb2: 0x1ba4d7eb9502e1d5,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0xb311d9c41d86fd12c8359b91,
                limb1: 0x2c14af79c4a0c1cd0654f465,
                limb2: 0x26020b3c03a769aa,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0x5a505a9845c55e39881d0ee1,
                limb1: 0xdedff24b3567c813bd05bc2c,
                limb2: 0x1892ab6bebbcf1f6,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0x2f39c04551bb91c132620328,
                limb1: 0x7f0df2ca2dc6c2accbae0e93,
                limb2: 0x9ac6219a878e876,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0xe7eb533c3a0879fbdc7843b3,
                limb1: 0x6fa680100ddd49b700b425aa,
                limb2: 0x26afcf9ae5bcd7ed,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0xa5cbed9fa57949170806989a,
                limb1: 0x22b34047ee4b0498a5f3aa63,
                limb2: 0x57436d080a17176,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0xb6e4d16e30668cc99e7f0271,
                limb1: 0xf8b55fb556d1079c0fbc0318,
                limb2: 0x143b5abc235f6be1,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0xa83299e9fae46529fa9fcece,
                limb1: 0x7c6d8ae1463e4336bf3cfe56,
                limb2: 0x1eccc907fa2225d7,
                limb3: 0x0
            }
        };

        let c_n_minus_3: u384 = u384 {
            limb0: 0x54a1396ce9abfb0d9be57401,
            limb1: 0xa55dc720e55400224502d7f8,
            limb2: 0x1d5aa84f13f1484a,
            limb3: 0x0
        };

        let w_of_z: u384 = u384 {
            limb0: 0x28da2b89c1308a09cddd03bb,
            limb1: 0x832e9e1e1b908d6de5e6190b,
            limb2: 0x23c57265424a2898,
            limb3: 0x0
        };

        let z: u384 = u384 {
            limb0: 0x9ba66e98679140e0b6fece9a,
            limb1: 0xabc2ded76bd8e65f72a2761a,
            limb2: 0x26e0e90d28b7405b,
            limb3: 0x0
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 0x1cc7e2b6c99d5f9ec634effd,
            limb1: 0x1c87284dc5fa8ac995a37efe,
            limb2: 0xbe7d6fed6b6b5d0,
            limb3: 0x0
        };

        let c_frob_2_of_z: u384 = u384 {
            limb0: 0x7b768615f6b1465dbf2b6442,
            limb1: 0xba9d82b8afbae6c34b511edb,
            limb2: 0x2bd01794199a1949,
            limb3: 0x0
        };

        let c_inv_frob_3_of_z: u384 = u384 {
            limb0: 0x43215bf46cff30a0c3ac232c,
            limb1: 0x1c52d51ec8fe0b2d46b01630,
            limb2: 0x16c3bb12a2a1fa45,
            limb3: 0x0
        };

        let previous_lhs: u384 = u384 {
            limb0: 0x89386b90d34145328252f723,
            limb1: 0x211550313218ef7cd43cfeb,
            limb2: 0x26e6a6fd0a78491f,
            limb3: 0x0
        };

        let R_n_minus_3_of_z: u384 = u384 {
            limb0: 0xc689f37bf94523fe03cb8f1e,
            limb1: 0xe36b3a5f23746dddf4105d94,
            limb2: 0x1a1e57981f742e70,
            limb3: 0x0
        };

        let Q: Array<u384> = array![
            u384 {
                limb0: 0xfa4abdecc8a86e3a62937980,
                limb1: 0x6ec9ad0e2cbef407b38a089,
                limb2: 0x287158d05033b5a4,
                limb3: 0x0
            },
            u384 {
                limb0: 0x15c7a82023f3e5aed1de4fa8,
                limb1: 0xa4d6ce54645cc176b3f175d0,
                limb2: 0x2ff7e2a79446d493,
                limb3: 0x0
            },
            u384 {
                limb0: 0x995d767b0c1333ce07117e78,
                limb1: 0x21eaa1fa663eab2bc83235cc,
                limb2: 0x2ecb0b108f6dc117,
                limb3: 0x0
            },
            u384 {
                limb0: 0xe05f6b98bdd4b9dfc2cd5c7,
                limb1: 0x72189a39d63a7486be216476,
                limb2: 0x22b6ada2e0dd0541,
                limb3: 0x0
            },
            u384 {
                limb0: 0xf10185fd8f81598725394778,
                limb1: 0xa4ed017b208a888ee6e4ac85,
                limb2: 0x25aad93435128906,
                limb3: 0x0
            },
            u384 {
                limb0: 0xd4ae34862b194984f49eb5a6,
                limb1: 0x7837e5069398dbd616db36e4,
                limb2: 0x1124cf2149adce95,
                limb3: 0x0
            },
            u384 {
                limb0: 0xc61b2c77860215be0d326347,
                limb1: 0xe04ee43c11f63e9bc7361a75,
                limb2: 0x28ed394a02a007fc,
                limb3: 0x0
            },
            u384 {
                limb0: 0xc5cf255f278db4f648df480e,
                limb1: 0xc2ff347bd527b331240eb6c1,
                limb2: 0x89d003681de9808,
                limb3: 0x0
            },
            u384 {
                limb0: 0x25365ca8d66a45e952c51809,
                limb1: 0xc045883b940f737e548c3ec4,
                limb2: 0x58342e71004d975,
                limb3: 0x0
            },
            u384 {
                limb0: 0x40fd8aaa3504e26c5f7e07d3,
                limb1: 0xaeaaec4854f1a7a37378e6ca,
                limb2: 0x1e1d059a7c34e6eb,
                limb3: 0x0
            },
            u384 {
                limb0: 0xa4efedef24cb0b4e3825a7e1,
                limb1: 0xdfde522dd429e0c9664ceba8,
                limb2: 0x140e997582edc5ab,
                limb3: 0x0
            },
            u384 {
                limb0: 0x120a202fe11a15c325efc3a9,
                limb1: 0x8d17e6327e8aeae24a703e3,
                limb2: 0x294015606250e9f9,
                limb3: 0x0
            },
            u384 {
                limb0: 0xaa0cc3271daa42fc90b15e3d,
                limb1: 0x448236e9863c6992116febe7,
                limb2: 0x135f911290b6e394,
                limb3: 0x0
            },
            u384 {
                limb0: 0xaa648f16f03550885a2bf7fe,
                limb1: 0x7a1a262bba13834fde8e3228,
                limb2: 0x25dab97e66f1b0a0,
                limb3: 0x0
            },
            u384 {
                limb0: 0xbe72544851b5ab77d09e1abb,
                limb1: 0x9f519184e79d4d5fab6fc9e7,
                limb2: 0x20cb579c777cd128,
                limb3: 0x0
            },
            u384 {
                limb0: 0x579e9b085db13edffa29559d,
                limb1: 0x1c3df9183278f64cae1367a,
                limb2: 0x24c261523ff0e579,
                limb3: 0x0
            },
            u384 {
                limb0: 0x1c67556d79acd84313b2cc15,
                limb1: 0xc43eebcc6f69ed695e349e31,
                limb2: 0xf9bf7ac9e76ef95,
                limb3: 0x0
            },
            u384 {
                limb0: 0x84c85b950637da9e8bb62aff,
                limb1: 0xf97b8d621c9527d081ffbbc1,
                limb2: 0x247952ce0a4e6eb7,
                limb3: 0x0
            },
            u384 {
                limb0: 0xf146b0800a2cf6a95bd38392,
                limb1: 0x5745ef5a2e0885fc5da23c06,
                limb2: 0x1f1b5d2a44ee5071,
                limb3: 0x0
            },
            u384 {
                limb0: 0x3c74dbc2c504644fa5dc7c7b,
                limb1: 0x7a37e212a78c1cdaa7838837,
                limb2: 0x2e6acc23be2b3272,
                limb3: 0x0
            },
            u384 {
                limb0: 0xaef472a758216f30e31b9123,
                limb1: 0xd370c51fd8e2ba4ccd84344b,
                limb2: 0x2e70e9e3c8d3acee,
                limb3: 0x0
            },
            u384 {
                limb0: 0xb2f72efec0959b82924b159,
                limb1: 0x7af0cf69bd2098c6c2de5950,
                limb2: 0x2a24daf486a29efb,
                limb3: 0x0
            },
            u384 {
                limb0: 0x2a364435eda04e30ff741d1c,
                limb1: 0xb202054f62a10ce2d545de36,
                limb2: 0x2bd638e049ac2f36,
                limb3: 0x0
            },
            u384 {
                limb0: 0x7bd37c4b948c52c8e0f24eb3,
                limb1: 0x6fccff0e9e4f06c36890df9,
                limb2: 0x1d123de6b50a676c,
                limb3: 0x0
            },
            u384 {
                limb0: 0x998b1e1c9f81fca3ffb1c2c9,
                limb1: 0xabbebd4ff9e590e4d36d8076,
                limb2: 0x2723fa042c645b82,
                limb3: 0x0
            },
            u384 {
                limb0: 0xa0e5bd8cdd7524bcdd82016d,
                limb1: 0x6df5e2aa832cb6a724e2e13a,
                limb2: 0xf2ebf2a643580a0,
                limb3: 0x0
            },
            u384 {
                limb0: 0x4b9368d961880ea05e5ecd0a,
                limb1: 0x4142452b361c57ab3d992624,
                limb2: 0xf799d3ff66b72a9,
                limb3: 0x0
            },
            u384 {
                limb0: 0xdda9a02a964fbdde895585be,
                limb1: 0x5f3fa533e28cfc3ced825ea8,
                limb2: 0x1d277c7ff13a9049,
                limb3: 0x0
            },
            u384 {
                limb0: 0x56756682996d66423cf87ff0,
                limb1: 0x257ea412a21574899fbd4b9f,
                limb2: 0xf96bb6052722246,
                limb3: 0x0
            },
            u384 {
                limb0: 0xc2862234d81580dc24d878a1,
                limb1: 0x2c481f988ce67bdc41b72448,
                limb2: 0x2d190aeb89599298,
                limb3: 0x0
            },
            u384 {
                limb0: 0x1d5f9dfc98b0b4d7b5e16e19,
                limb1: 0x72678417ec023a99e4c80a29,
                limb2: 0xd1bae8c7ad5af81,
                limb3: 0x0
            },
            u384 {
                limb0: 0x7f29e86c8a730eaa16bb4fb0,
                limb1: 0x4b32bc8635d5870de79d1be2,
                limb2: 0x117fe8da63c2523d,
                limb3: 0x0
            },
            u384 {
                limb0: 0x5a9c60b533b887d38301c5b9,
                limb1: 0x50b91e51681e5658d813a70f,
                limb2: 0x153c159bb1a48e2,
                limb3: 0x0
            },
            u384 {
                limb0: 0x14b8317e75555ded8ea5e386,
                limb1: 0x49ab05a8806094aa4037fffa,
                limb2: 0x1f21d96db04a2620,
                limb3: 0x0
            },
            u384 {
                limb0: 0x506e2fc6d05d2cb96b76911f,
                limb1: 0xbe23bd25ac788719d9371f2a,
                limb2: 0x2ccd3aefef6ed981,
                limb3: 0x0
            },
            u384 {
                limb0: 0xfbb2242955ab42c50f08502e,
                limb1: 0x4420e63bc34dfc6428e2f201,
                limb2: 0x2e17cbb19d6fe1b5,
                limb3: 0x0
            },
            u384 {
                limb0: 0x386b01c05ffe6c117b51aca6,
                limb1: 0x16f48941ad283c0df230400a,
                limb2: 0x521a037b9e789c6,
                limb3: 0x0
            },
            u384 {
                limb0: 0xca563921f9422f1efed97f9e,
                limb1: 0x8191cbeb175bf448a0ce5b5f,
                limb2: 0x11f355bfd6cc364,
                limb3: 0x0
            },
            u384 {
                limb0: 0x188417d8fe9f9ff698bc2c7a,
                limb1: 0x3c241ca590425d14e6b0643c,
                limb2: 0x2a3d507052ba051,
                limb3: 0x0
            },
            u384 {
                limb0: 0x64327fe8deccac5b968d4f41,
                limb1: 0xc5acc61220de5de4b5b46896,
                limb2: 0x24d96224e4600a02,
                limb3: 0x0
            },
            u384 {
                limb0: 0xbc031029253053ae4db1762e,
                limb1: 0x3455f1f64574a37e9dbff93f,
                limb2: 0x8b9fb9614147ca8,
                limb3: 0x0
            },
            u384 {
                limb0: 0xa9f15f7cd7ea0686e5f14395,
                limb1: 0xf3c73944f95c46f7682e4002,
                limb2: 0xcba5dd82e975c72,
                limb3: 0x0
            },
            u384 {
                limb0: 0x466ed6b96bad500ded1b802,
                limb1: 0xa892d63b89aeb61659f88a69,
                limb2: 0x2b660a827ad06668,
                limb3: 0x0
            },
            u384 {
                limb0: 0xd0ab9ea4c15f47ca204e6817,
                limb1: 0x14e153ca45568d6dbdc5a588,
                limb2: 0x2e184df0e5ffc7d4,
                limb3: 0x0
            },
            u384 {
                limb0: 0xda344d179e31e1f9b30cc272,
                limb1: 0x477e2817ddd1b251b0f62b9e,
                limb2: 0x26581734cab24a0a,
                limb3: 0x0
            },
            u384 {
                limb0: 0x10ac3f8387787e2bc8a8038,
                limb1: 0xd2ebe96b24b7d424e4ed458b,
                limb2: 0x2f61a4c435069af5,
                limb3: 0x0
            },
            u384 {
                limb0: 0xdd28b3acea35a393d5e33b,
                limb1: 0x253dc9ce208d549b6b0efd01,
                limb2: 0x22779e8b7c26c722,
                limb3: 0x0
            },
            u384 {
                limb0: 0x51995cf180d9a24e0a833038,
                limb1: 0xab78a4ee385127f1f317930e,
                limb2: 0x1d395b1a2ca5f0cb,
                limb3: 0x0
            },
            u384 {
                limb0: 0xe1976c14aa069b5b510d115a,
                limb1: 0xf0cc8eec3b3fd363714d85bd,
                limb2: 0x28ca26d6a62f45c2,
                limb3: 0x0
            },
            u384 {
                limb0: 0xacdf3038467ccafabbe74e1b,
                limb1: 0x19b2b59530519f6ab51e3a7b,
                limb2: 0x1f5e82fe598c8a5c,
                limb3: 0x0
            },
            u384 {
                limb0: 0x89e4b9df5a45a71745ac1564,
                limb1: 0x486095c2f812b02296b09e29,
                limb2: 0x12498a8437c67f46,
                limb3: 0x0
            },
            u384 {
                limb0: 0x10c313bd6478a3998d682a61,
                limb1: 0x1d21ae7c60252b8d2cd9f51a,
                limb2: 0x25c281b7f444adae,
                limb3: 0x0
            },
            u384 {
                limb0: 0x75f80092ea4f44cfeafd080b,
                limb1: 0x42f811266c2c90a724e90316,
                limb2: 0x2ef29db8e56a47e7,
                limb3: 0x0
            },
            u384 {
                limb0: 0xc2e8fae231f0e15089419b16,
                limb1: 0xbd335a642d79f3f6ca92720a,
                limb2: 0x10f6c08d1184d8fb,
                limb3: 0x0
            },
            u384 {
                limb0: 0x8a849529b662f7edb5b85fb3,
                limb1: 0xa7f3c30f26e5e2da91b92f8b,
                limb2: 0x138b8b1b08e7a744,
                limb3: 0x0
            },
            u384 {
                limb0: 0x8428d34471948be49de0103a,
                limb1: 0xfd14f9d493510969c2ebbadc,
                limb2: 0xd72d83c6a75e179,
                limb3: 0x0
            },
            u384 {
                limb0: 0x64348207341514cc77fd7fd1,
                limb1: 0x18fa547216752b38fd642ae2,
                limb2: 0x19bc3dda8909c1ba,
                limb3: 0x0
            },
            u384 {
                limb0: 0xac69c00681b84ea71f217475,
                limb1: 0xa7484ffbbfd9de847770ca8d,
                limb2: 0x210e6e82afd65c3,
                limb3: 0x0
            },
            u384 {
                limb0: 0x3d9f3e803ba6857733964543,
                limb1: 0x60c36cdd9937f592185aeb98,
                limb2: 0x4755ab3680fe5e2,
                limb3: 0x0
            },
            u384 {
                limb0: 0x8c479390d41cc2bce3352f8b,
                limb1: 0x32dec6d586901942366e3cca,
                limb2: 0x1f796d2837ef373e,
                limb3: 0x0
            },
            u384 {
                limb0: 0xecb9cb393103d90417426bd0,
                limb1: 0x836150061981f0d4dbf9a793,
                limb2: 0x26a4921221566d5e,
                limb3: 0x0
            },
            u384 {
                limb0: 0x93aae4808cdc538931ffba99,
                limb1: 0x9efb00b7a397b217851143e5,
                limb2: 0x2672cdf16e7fbad2,
                limb3: 0x0
            },
            u384 {
                limb0: 0xa41a5d31dd5eb2d16518020a,
                limb1: 0xac331b9243189f26e9b74954,
                limb2: 0x1e2a690eccea521d,
                limb3: 0x0
            },
            u384 {
                limb0: 0x34b65ceec9d4e1bbc4d3fec2,
                limb1: 0x8dfc975a4fd9204b3b9e84e,
                limb2: 0xca56e9af9873b5e,
                limb3: 0x0
            },
            u384 {
                limb0: 0x84983111371a239070c742d0,
                limb1: 0xd35f581e3648431fae9e8d03,
                limb2: 0x92c9fa001cbd9c2,
                limb3: 0x0
            },
            u384 {
                limb0: 0x78ca810e742863563c91e458,
                limb1: 0x46ac32019ab1874e17668e8a,
                limb2: 0x2988814fd5ff7894,
                limb3: 0x0
            },
            u384 {
                limb0: 0xebe3387b68cbaa9e22d72fab,
                limb1: 0xdb5bf01f3d75489ae1289e96,
                limb2: 0x1f08eeff0490642f,
                limb3: 0x0
            },
            u384 {
                limb0: 0x846736ce24dbac94486cf4d6,
                limb1: 0x5ec2abf6a2237d40d836ba33,
                limb2: 0x2b56b043bd3ccd61,
                limb3: 0x0
            },
            u384 {
                limb0: 0x82042c0b1da221b825454e29,
                limb1: 0xaef82d2e51f83e44524bba5b,
                limb2: 0x4d66071b984dbe3,
                limb3: 0x0
            },
            u384 {
                limb0: 0xcfa71765e757155d5c07d046,
                limb1: 0x33423b60310dfbf4d7418ae8,
                limb2: 0x12e472fafea4ca6a,
                limb3: 0x0
            },
            u384 {
                limb0: 0x6c811d57b2835bff857d114b,
                limb1: 0xbcd635ccb9c4abb6a6a99aab,
                limb2: 0x1943c4dd60fc01e2,
                limb3: 0x0
            },
            u384 {
                limb0: 0x70dd4704248988cf091523be,
                limb1: 0xa1239c7249ace04913bd01ae,
                limb2: 0x9ec8a9ca9452a96,
                limb3: 0x0
            },
            u384 {
                limb0: 0xd4814f7f3022b8f186d6c424,
                limb1: 0x599490667d4165889a347cda,
                limb2: 0x2577492f27c4bf8d,
                limb3: 0x0
            },
            u384 {
                limb0: 0x92976e6ce04d350f260aeef2,
                limb1: 0xbdb63f3243cec8096dec9a46,
                limb2: 0x7793ab4362b5eea,
                limb3: 0x0
            },
            u384 {
                limb0: 0x23a8eb6e2864120ef118ac10,
                limb1: 0xd9535d1dea83986171027b03,
                limb2: 0x1b1fd03e8946352d,
                limb3: 0x0
            },
            u384 {
                limb0: 0xd6cadf412df1fe3fefd9373e,
                limb1: 0xc0038e5a4c8349bc09cef0ea,
                limb2: 0x24aa5c5d785ecebc,
                limb3: 0x0
            },
            u384 {
                limb0: 0x5dde2c6aaeb5964415d51b49,
                limb1: 0x1938d096ed3dffdfa5bb2389,
                limb2: 0x1fa2324c19db1d7b,
                limb3: 0x0
            },
            u384 {
                limb0: 0x773506171615975596df541f,
                limb1: 0xbcb43dc942923754d24cc9b8,
                limb2: 0x1070537095f9d782,
                limb3: 0x0
            },
            u384 {
                limb0: 0xcb0206728fff6a1ab3e52b15,
                limb1: 0x3cd2aad82997e8996059c8a9,
                limb2: 0x7ce652fa013e55e,
                limb3: 0x0
            },
            u384 {
                limb0: 0x94c7cd9ad28d65a1adc786e7,
                limb1: 0xc7975813ba4e199cf2b8fd15,
                limb2: 0xa3b1f19848d77e3,
                limb3: 0x0
            },
            u384 {
                limb0: 0xa6728c5c7f25943cf4634a81,
                limb1: 0x3e41ca28a0c7bb90eef7133a,
                limb2: 0xe7e8cf3035e4eb9,
                limb3: 0x0
            },
            u384 {
                limb0: 0x27833e60f8b2ca91a3073280,
                limb1: 0xcf86e88ec361570dd925bbaa,
                limb2: 0x25e3fcb2d23a817d,
                limb3: 0x0
            },
            u384 {
                limb0: 0x1162ce262d64584a9ee08eef,
                limb1: 0x18700fd5478947081b08fdc1,
                limb2: 0x27de91ae450000a1,
                limb3: 0x0
            },
            u384 {
                limb0: 0xc7b2595e93c3150d77c3f04f,
                limb1: 0x6b7b2370940ca324420a746a,
                limb2: 0x2a7ffa5fdf0d605,
                limb3: 0x0
            },
            u384 {
                limb0: 0x24301b871322439ab54faf70,
                limb1: 0x73961f8efaa83536d3d779d5,
                limb2: 0x1635ddb60f013f4e,
                limb3: 0x0
            },
            u384 {
                limb0: 0x3deaf9a0a724dc8f4be669fb,
                limb1: 0x16d24a67c6b1b41f3659333f,
                limb2: 0x2e2232d997b19d4f,
                limb3: 0x0
            },
            u384 {
                limb0: 0xc3e5382702bc0550dfeddf7e,
                limb1: 0x940795d06bbb961d401f8134,
                limb2: 0x230dcaab84eefe22,
                limb3: 0x0
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
            limb0: 0x218d8db4359f98e2d92ed3fc,
            limb1: 0xcfce0a90fe995677aca87aae,
            limb2: 0x1ec36fefa9b9f78d,
            limb3: 0x0
        };
        assert_eq!(final_check_result, final_check);
    }


    #[test]
    fn test_run_BN254_MP_CHECK_INIT_BIT_2_circuit_BN254() {
        let yInv_0: u384 = u384 {
            limb0: 0xac98a368dfc8b87a7176d181,
            limb1: 0xa92c3c3e3957f0829c272c51,
            limb2: 0x6fabe73af3cb9d0,
            limb3: 0x0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0xc1da8d39f7350626dca8b6fd,
            limb1: 0xecb3077a6cef5e55840658d1,
            limb2: 0x289487d4a54e6c8f,
            limb3: 0x0
        };

        let Q_0: G2Point = G2Point {
            x0: u384 {
                limb0: 0xe2aa55a7495103edfd05a5f5,
                limb1: 0x7e5168dc5690f74daedab7b5,
                limb2: 0xc4c1f91af797546,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x8eafb3235f65380029c836e0,
                limb1: 0xb7ae77585b45cf5ad7de701d,
                limb2: 0x19032883702a5b67,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xa9c9a24efd723837705bacc2,
                limb1: 0xfde9d47dd89331ac51497435,
                limb2: 0x44f060d77f4531b,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x76c0c651f361c49764e0dab3,
                limb1: 0x35c3de958a647b9fb52f6009,
                limb2: 0x178b4915e46232e7,
                limb3: 0x0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0x5727bb50bee2ebdb44788bd,
            limb1: 0x166adfc43513198c67f8ab57,
            limb2: 0x1a63bb2eda98da57,
            limb3: 0x0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0xdfb8770891d2125a95e19cb6,
            limb1: 0x8a74bec56951743eca6cb87c,
            limb2: 0x2889460e35e1392e,
            limb3: 0x0
        };

        let Q_1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x6151787e4f027fe87d5d9031,
                limb1: 0x10e857f88986148f8b3e00e7,
                limb2: 0x26b5cdc0140a642e,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x7e240205bb00d206f8542953,
                limb1: 0x34367eaa03ea038fc095e099,
                limb2: 0x277d25fc6b5a174d,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x2743e0df5e15428a833cf90f,
                limb1: 0x1c351dc942260a44773b8350,
                limb2: 0x1c9e275d97f0bfcf,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xd6a2c379e0c6a8a74748f7ea,
                limb1: 0x61f9c40838330558fb2323e7,
                limb2: 0x2fbe1d356251d74d,
                limb3: 0x0
            }
        };

        let R_i = E12D {
            w0: u384 {
                limb0: 0x27a0008c0b44361f16c7354a,
                limb1: 0x958cd60ea07f7f4750c6fa8c,
                limb2: 0x1f0ae5039045a445,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0xfe38784bf489362c10345193,
                limb1: 0x6f48744f7abc9f0b86fe0ded,
                limb2: 0x18ac8bf551c6a2e4,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0xc2fab18422324672f64e8f4a,
                limb1: 0x7f79ee0e299cb482449213a,
                limb2: 0x2d26e4f51e709e19,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0x8236adf3f7512c56e05724d,
                limb1: 0x43a061c445a16970a11b26b0,
                limb2: 0x763328e62614790,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0x5fad7a0d4aa83cd65804a881,
                limb1: 0xa31cc5d2cd96a6a19dbdc6ff,
                limb2: 0x2faef9833085ee6d,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0x8abb572c8aae0c3ad31224e0,
                limb1: 0x83f0ba7756b8002a0f424ffa,
                limb2: 0xe49e4d8d5f52c0,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0x7ed61f4ee875176629530a13,
                limb1: 0xa31ca36b059ebb2ed1cae193,
                limb2: 0x1080bebedcebef56,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0x581332c2233e383454e27ea6,
                limb1: 0x196d362dfec24805feeac13d,
                limb2: 0x23eb5c979d0b6f5e,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0xca687a98f48ef9a86aeb5a32,
                limb1: 0x4063d5251152797ec20166e3,
                limb2: 0x6ab0f28920c904e,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0xdc7972f0133894b3854ca896,
                limb1: 0x20d5c16e961139cfffbdfd47,
                limb2: 0x237dac67c3ad037,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0xfedcb8f9378b094cb5178761,
                limb1: 0xa9d21bf8b19549902d5c6415,
                limb2: 0xebad6f0f63d307c,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0x9bd91220338f4acf66270136,
                limb1: 0x706146ffbecba4c8b2c92c12,
                limb2: 0xa1c0aec5931c9b4,
                limb3: 0x0
            }
        };

        let c0: u384 = u384 {
            limb0: 0xf90b9724b883a8ea44e8a604,
            limb1: 0xf94d9109593985b5e5039055,
            limb2: 0x2306984afff99f34,
            limb3: 0x0
        };

        let z: u384 = u384 {
            limb0: 0x37503d7733672754da2e6e6c,
            limb1: 0x5050f32cd4062cce773a13fb,
            limb2: 0x838c293fbcefcd0,
            limb3: 0x0
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 0xaa19af268fa41d2246ddb0ac,
            limb1: 0x1debf6c503ccb5c6b4195c,
            limb2: 0x2a42248e1551f819,
            limb3: 0x0
        };

        let previous_lhs: u384 = u384 {
            limb0: 0x4ef0ba9b53fd2516d1bfbaba,
            limb1: 0xc833b07eb4d56ffcdf4a518a,
            limb2: 0x14b06cf1f33c4233,
            limb3: 0x0
        };

        let (Q0_result, Q1_result, new_lhs_result, c_i_result, f_i_plus_one_of_z_result) =
            run_BN254_MP_CHECK_INIT_BIT_2_circuit(
            yInv_0, xNegOverY_0, Q_0, yInv_1, xNegOverY_1, Q_1, R_i, c0, z, c_inv_of_z, previous_lhs
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x48fc009db9db93f94e57a244,
                limb1: 0xc7f1022a215dca26b318af27,
                limb2: 0xf69ea01d2f97a06,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x67ccb8b54978ea9a40869173,
                limb1: 0xb0fd8881ce474b1fc35ebadb,
                limb2: 0x2cf2ebf61cc22ce6,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xba832d88309a5327222ae003,
                limb1: 0x91a61b5a10b3c9d2f87fe366,
                limb2: 0x1ea8c469ad018231,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x897c70cd3e882943516b1d03,
                limb1: 0x1f494f595445c1a1f1cd6b74,
                limb2: 0x25e1f7fc7c171971,
                limb3: 0x0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0xda1c64b9c064d5415a266b9b,
                limb1: 0x13a701848359a3c6733d65f1,
                limb2: 0x175d69a489f41111,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xb56db28c744a679fde30e6f3,
                limb1: 0x7cacc3a6b3551d60f38e284c,
                limb2: 0x2faf3b3e0d8bb60a,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x8c67f4c149623a647294e355,
                limb1: 0x86c7b6fe8e40a0581f2d91e6,
                limb2: 0x29ed5888ed67088f,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x91b4ad985caa49e4d127dc90,
                limb1: 0xc17c6f689dd4029c5a48bd96,
                limb2: 0x165caf5b071a00cd,
                limb3: 0x0
            }
        };

        let new_lhs: u384 = u384 {
            limb0: 0xa0f3f7a90d573bb551bfd1a5,
            limb1: 0x72d901bad4277a24e7c4d402,
            limb2: 0x24d07616c4590652,
            limb3: 0x0
        };

        let c_i: u384 = u384 {
            limb0: 0x3f6c4ce1fb90989ccb17df81,
            limb1: 0xec4779970ac2dd58ee280d72,
            limb2: 0x20c7ad6d9f996f4e,
            limb3: 0x0
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0xf4cafe193e71fc65ec62c985,
            limb1: 0xc6269ae4d24a370f750282c3,
            limb2: 0x1f255cc4f5f4ccc0,
            limb3: 0x0
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(new_lhs_result, new_lhs);
        assert_eq!(c_i_result, c_i);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
    }


    #[test]
    fn test_run_BN254_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit_BN254() {
        let lambda_root = E12D {
            w0: u384 {
                limb0: 0x4fbe2aaefbf70946d6ada066,
                limb1: 0x24bfe48398071b14642cddb,
                limb2: 0x16b61c4b7ee1a2a3,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0x824c6948f474b1a4f2684ee1,
                limb1: 0x17776c3a57435d9ced3032ed,
                limb2: 0x138147ba13d72846,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0xe166c6aba8f614bd7b2aa677,
                limb1: 0x486c0adf5bf26ec8c814ed3c,
                limb2: 0x2731d4eb6264190f,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0xa7fb881e3a88a4ab78916712,
                limb1: 0xa1d534025fba6dc2b594b706,
                limb2: 0x16f5c771ea75e34d,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0x5bf572794704768e6e927501,
                limb1: 0xc46f5825669ff1b9f902d6c0,
                limb2: 0x2db83ab0c42bf4c4,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0xddd3e7794879996dfe38f4eb,
                limb1: 0xe75241027acf6bcc1af4321a,
                limb2: 0x7b85c8e4a9686a4,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0x9e3b3f04d418864590de6fba,
                limb1: 0x6637c09facf606fc387cdf02,
                limb2: 0x13eacab68091a21d,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0x5084a40f3b8f5fc77c96eefa,
                limb1: 0x6b8fd6af157ed9849648e8,
                limb2: 0x1e316a5d178672e8,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0xe4172ba364eec62b51306e5c,
                limb1: 0xd21dbc093a357442f325f875,
                limb2: 0x1b9b421bf7b37a86,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0x934c472a0c72fe13fbf28c1c,
                limb1: 0x681091fe0a5a0322c57842a9,
                limb2: 0x10dc927f17ee2fe6,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0x53a9ec5db9b5c70e3346f7c6,
                limb1: 0x2e4a6e781cf4a8ed2db6de21,
                limb2: 0x2cb6a87dcc16014a,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0x3bd5f8a2073c36ba5d393bf9,
                limb1: 0x212585b0b2f8580f3f05323,
                limb2: 0x2236824661f6c877,
                limb3: 0x0
            }
        };

        let z: u384 = u384 {
            limb0: 0xbdb62ff314e167063309a536,
            limb1: 0xd9073286329cd43a7751b3fa,
            limb2: 0x214b4bb90061fd30,
            limb3: 0x0
        };

        let scaling_factor: MillerLoopResultScalingFactor = MillerLoopResultScalingFactor {
            w0: u384 {
                limb0: 0xeda678063a19607d3bfb255e,
                limb1: 0x7984f33f61c61ae46a594b07,
                limb2: 0x60f3fceb09220,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0x95331356074f3be044f20133,
                limb1: 0x5e12425cb42fb35758d97f4a,
                limb2: 0x1596bda6d3bb63d7,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0xa408001f743397f1ad5b9bb2,
                limb1: 0x845c21e7988d0e4a2266a107,
                limb2: 0x101c26f51790a6b7,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0xb6ffe12c1a6f0c9af1f7e90f,
                limb1: 0x62d7f7a45dae1f31a7e256d,
                limb2: 0x914d81db13de531,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0x339fbb6951cd2c07a8f78b61,
                limb1: 0x801841f4820d15c66bd1f046,
                limb2: 0x23d074f91eceb5e5,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0xe93b4418b170b1ed1b040be3,
                limb1: 0x824d9e961fe253b079801aaa,
                limb2: 0x1ca6f608e4ad24e2,
                limb3: 0x0
            }
        };

        let c_inv = E12D {
            w0: u384 {
                limb0: 0x74747f6f2dbdb6e57844c2ac,
                limb1: 0x20fe652b56fe23018c3af69e,
                limb2: 0x1048a75d6a8d3e84,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0x3f9bbcfc742c59053bcab3ea,
                limb1: 0xc674d2447b056d0259de5319,
                limb2: 0x1a420ef5ef617cac,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0x72323dc9c67781b2c3a31607,
                limb1: 0x3db612f46df2fc823956fba9,
                limb2: 0x1e8af81240d2d16f,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0x3a6f36fa241813ef799fde33,
                limb1: 0x5c27761d4894d9fc70df67b9,
                limb2: 0x1f1da964a73e3f3b,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0xedf6b1e0ee8f0e0999755cb9,
                limb1: 0xd4e26a5bf807cdd926184c80,
                limb2: 0x2bced6a485bab545,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0x4cc672fc3006ff85166a1a98,
                limb1: 0xa182e35f848edc98eec9fa67,
                limb2: 0x7db3bb0ac546740,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0x27b51ee70f1a6c44f239fbb0,
                limb1: 0x559de20409642b3157c2747f,
                limb2: 0x27cb576edebaa89f,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0xc408143f290d07e4ce1f4081,
                limb1: 0x63eaa00577f63854e668bb6e,
                limb2: 0xc022946ad830951,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0xb9534807300961c3855a7d8d,
                limb1: 0x84eaf9432ee66e2153fb2ed1,
                limb2: 0x22bcdf5cec4f4490,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0x9830349dd9efbb41b66b6b0b,
                limb1: 0x26f332446f1d5baf952b750d,
                limb2: 0x2c143ac0a22fc818,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0xe61b4dc67e525e4f9e203161,
                limb1: 0xedc641cd921bc646a9c7ae92,
                limb2: 0x2646ad44369fe284,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0x3e332f35086c976870fe3cfc,
                limb1: 0x9a9dadd2e7aad0707cddb4cc,
                limb2: 0x1454fdcdd7f14ec2,
                limb3: 0x0
            }
        };

        let c_0: u384 = u384 {
            limb0: 0x3246b7d9bb2966398e4a295d,
            limb1: 0xff0952a0b2591c40021b632,
            limb2: 0xf8ad9942258edf3,
            limb3: 0x0
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
            limb0: 0x7d62538de416340ef85e3c0a,
            limb1: 0xdd176f3378928add44ae7e30,
            limb2: 0x1f712ceaff438741,
            limb3: 0x0
        };

        let scaling_factor_of_z: u384 = u384 {
            limb0: 0x3d8220b81842fb73bf80ae0c,
            limb1: 0x9fce87dbf8f7ce5ea9af8f5d,
            limb2: 0xd159dfc65003acc,
            limb3: 0x0
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 0xb9eba37e2c44e800b5653b54,
            limb1: 0x708c2c83585d05081eec0987,
            limb2: 0x1a4d9a03e127172,
            limb3: 0x0
        };

        let lhs: u384 = u384 {
            limb0: 0x1af64a3b097da9ded04f8cf1,
            limb1: 0xa35124042128bc779afd165c,
            limb2: 0x1c0aca540ac381e6,
            limb3: 0x0
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 0x97e27243077bc85f703cb4d4,
            limb1: 0x9bc23f551cff5a9592e57ea2,
            limb2: 0x259a6995bee2fd18,
            limb3: 0x0
        };

        let c_frob_2_of_z: u384 = u384 {
            limb0: 0xb54d600db03bb94c34cfff5a,
            limb1: 0xd7ddabcd210047f8e3fc7e54,
            limb2: 0x137bc3b31138d165,
            limb3: 0x0
        };

        let c_inv_frob_3_of_z: u384 = u384 {
            limb0: 0x21aeaf5b9a83348ece9a8234,
            limb1: 0xa0a6b64c16f51f9f3564ff7d,
            limb2: 0xf8d248276aaab4b,
            limb3: 0x0
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
                limb0: 0xd01cf93568032f7efef06b04,
                limb1: 0xf924e06aaef5baef1903b45f,
                limb2: 0x973091e276d7e19,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0xb26489f71b58286c8461f840,
                limb1: 0xb2b4c281a5b91ee8c77f0b62,
                limb2: 0x26215b1f3475a526,
                limb3: 0x0
            }
        };

        let Qy0_0: u384 = u384 {
            limb0: 0xfb5214d99a66d48da4f0d9c2,
            limb1: 0x444517ef1c769e1f83719849,
            limb2: 0x2ed7c570b0445ebb,
            limb3: 0x0
        };

        let Qy1_0: u384 = u384 {
            limb0: 0x603803f32b2bcfda9d4319b5,
            limb1: 0x938ad77cb18d6a415db4487,
            limb2: 0x762b06a02af3382,
            limb3: 0x0
        };

        let p_1: G1Point = G1Point {
            x: u384 {
                limb0: 0xd13ec39c5cb6f1f0e4751694,
                limb1: 0x517fa07e7b0f78c1b8f35c26,
                limb2: 0x2b432aff1baf01f1,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0xdb3aefa6c7d0286213f36e53,
                limb1: 0xe2cd159aebba80d2820bc51d,
                limb2: 0x1a667872b02237e,
                limb3: 0x0
            }
        };

        let Qy0_1: u384 = u384 {
            limb0: 0xd97d2b38a4a98266d3d6362b,
            limb1: 0xfe656befe0efc9892ab465e9,
            limb2: 0x1a2b70a38463416a,
            limb3: 0x0
        };

        let Qy1_1: u384 = u384 {
            limb0: 0x3544f189a92046339bb68cd2,
            limb1: 0xaf04ef81b5481bf2702cebbe,
            limb2: 0x10e7775d67af36d9,
            limb3: 0x0
        };

        let (p_0_result, p_1_result) = run_BN254_MP_CHECK_PREPARE_PAIRS_2_circuit(
            p_0, Qy0_0, Qy1_0, p_1, Qy0_1, Qy1_1
        );
        let p_0: BNProcessedPair = BNProcessedPair {
            yInv: u384 {
                limb0: 0x4f2e41c589c11ee165893f3b,
                limb1: 0xa51505f903f929d3e8091176,
                limb2: 0x263d4e8349401ebf,
                limb3: 0x0
            },
            xNegOverY: u384 {
                limb0: 0xb031f1c5633d924d8b16dfbb,
                limb1: 0xffb4e8d47d93a49c54041d27,
                limb2: 0x7275420d6d533e1,
                limb3: 0x0
            },
            QyNeg0: u384 {
                limb0: 0x6d1fb5b3a1b9b789338c2385,
                limb1: 0x740b2dc7650aba3e140fd247,
                limb2: 0x18c890230ed416e,
                limb3: 0x0
            },
            QyNeg1: u384 {
                limb0: 0x839c69a10f4bc3c3b39e392,
                limb1: 0xaf17983eb66881b981a6260a,
                limb2: 0x29019e08de826ca7,
                limb3: 0x0
            }
        };

        let p_1: BNProcessedPair = BNProcessedPair {
            yInv: u384 {
                limb0: 0x16bc65fab84565ce3412e9fc,
                limb1: 0xb679b68e8155f8ed40864c07,
                limb2: 0x11e56a8e925cc3f7,
                limb3: 0x0
            },
            xNegOverY: u384 {
                limb0: 0x193049f58e22098ef6a4db7a,
                limb1: 0xa3d431892a93140adaa54967,
                limb2: 0x2526b7521e42caa5,
                limb3: 0x0
            },
            QyNeg0: u384 {
                limb0: 0x8ef49f54977709b004a6c71c,
                limb1: 0xb9ead9c6a0918ed46ccd04a7,
                limb2: 0x1638ddcf5cce5ebe,
                limb3: 0x0
            },
            QyNeg1: u384 {
                limb0: 0x332cd903930045e33cc67075,
                limb1: 0x94b5634cc393c6b27547ed3,
                limb2: 0x1f7cd71579826950,
                limb3: 0x0
            }
        };
        assert_eq!(p_0_result, p_0);
        assert_eq!(p_1_result, p_1);
    }


    #[test]
    fn test_run_BN254_MP_CHECK_PREPARE_PAIRS_3_circuit_BN254() {
        let p_0: G1Point = G1Point {
            x: u384 {
                limb0: 0x225f545796625aa1056b565f,
                limb1: 0x2bdc9c10636241c3eb6ec9e0,
                limb2: 0x1c38bb98e29b24d7,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0xea8fd23d0dbc321b90a00ee1,
                limb1: 0xcd6665d8edf2a72060032713,
                limb2: 0x29383b961638325c,
                limb3: 0x0
            }
        };

        let Qy0_0: u384 = u384 {
            limb0: 0x55a3a12967ba6b1a96954911,
            limb1: 0xdf98377981bd53363bac2660,
            limb2: 0x280b698749d4601,
            limb3: 0x0
        };

        let Qy1_0: u384 = u384 {
            limb0: 0x1a0ff2189eb883257add8fed,
            limb1: 0x81eb88e5d549faad44c8fd00,
            limb2: 0x23402dec7d82fccf,
            limb3: 0x0
        };

        let p_1: G1Point = G1Point {
            x: u384 {
                limb0: 0x7901799064e322cfa51de78b,
                limb1: 0x3ad23fbf2e57386443eb280e,
                limb2: 0x17510e088a7f03ae,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0xda286b7a4d6d99a628d798b4,
                limb1: 0xeab3c4d8d4e4004b9bde299d,
                limb2: 0x1d3e315e24c582ca,
                limb3: 0x0
            }
        };

        let Qy0_1: u384 = u384 {
            limb0: 0x1188afa1f660ffd5119fc1c4,
            limb1: 0x90ed41f464aba3f67a658abe,
            limb2: 0x1a3d26d4f3fa8613,
            limb3: 0x0
        };

        let Qy1_1: u384 = u384 {
            limb0: 0x43f98cbd179d221d8e5f37fa,
            limb1: 0xd0813d923aca43f27b777bf2,
            limb2: 0x12fd07841c622f82,
            limb3: 0x0
        };

        let p_2: G1Point = G1Point {
            x: u384 {
                limb0: 0xcfd645605c05c1f3241d3e27,
                limb1: 0xa88f58c1237d7b90181a218e,
                limb2: 0x3a11ca9dd332379,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x2305e6d3aa61353ad2b00078,
                limb1: 0x32d116fe8f08963c96248805,
                limb2: 0x21db6aa01ce5fc6,
                limb3: 0x0
            }
        };

        let Qy0_2: u384 = u384 {
            limb0: 0x8eeb3fd86783b0c3dcae667e,
            limb1: 0x9a0a80bec15dfcfcb325442c,
            limb2: 0x2db419bc7d874566,
            limb3: 0x0
        };

        let Qy1_2: u384 = u384 {
            limb0: 0x18f7e499df61c53457d1d37c,
            limb1: 0x3ddf55b2015128dbaf8c96a9,
            limb2: 0x1fdafd463a05c0b7,
            limb3: 0x0
        };

        let (p_0_result, p_1_result, p_2_result) = run_BN254_MP_CHECK_PREPARE_PAIRS_3_circuit(
            p_0, Qy0_0, Qy1_0, p_1, Qy0_1, Qy1_1, p_2, Qy0_2, Qy1_2
        );
        let p_0: BNProcessedPair = BNProcessedPair {
            yInv: u384 {
                limb0: 0xeb7ad38040c037882205ec5a,
                limb1: 0xcdcf6938ca23414798bd84a4,
                limb2: 0xd675bed24893227,
                limb3: 0x0
            },
            xNegOverY: u384 {
                limb0: 0xe8c9b2f799f1e01fa10da3fe,
                limb1: 0x7d6e4ce0526a383382f5bc14,
                limb2: 0x2b516692145da9a6,
                limb3: 0x0
            },
            QyNeg0: u384 {
                limb0: 0x12ce2963d46620fc41e7b436,
                limb1: 0xd8b80e3cffc405275bd54431,
                limb2: 0x2de397da6c945a27,
                limb3: 0x0
            },
            QyNeg1: u384 {
                limb0: 0x4e61d8749d6808f15d9f6d5a,
                limb1: 0x3664bcd0ac375db052b86d91,
                limb2: 0xd24208663aea35a,
                limb3: 0x0
            }
        };

        let p_1: BNProcessedPair = BNProcessedPair {
            yInv: u384 {
                limb0: 0xb7616d153fd2f1a76b3ffaec,
                limb1: 0xe4144c9797dafcdfbe55a6ae,
                limb2: 0x247947ff6fea6978,
                limb3: 0x0
            },
            xNegOverY: u384 {
                limb0: 0xc466481b5b6b91b9558dec23,
                limb1: 0xf93bc5a660da0157a67b99c7,
                limb2: 0x24ed9a677c6f49c6,
                limb3: 0x0
            },
            QyNeg0: u384 {
                limb0: 0x56e91aeb45bf8c41c6dd3b83,
                limb1: 0x276303c21cd5b4671d1bdfd3,
                limb2: 0x1627279ded371a16,
                limb3: 0x0
            },
            QyNeg1: u384 {
                limb0: 0x24783dd0248369f94a1dc54d,
                limb1: 0xe7cf082446b7146b1c09ee9f,
                limb2: 0x1d6746eec4cf70a6,
                limb3: 0x0
            }
        };

        let p_2: BNProcessedPair = BNProcessedPair {
            yInv: u384 {
                limb0: 0xa14102741f68242d76ba0bc8,
                limb1: 0x1acbc15b2bd0ba608a28c368,
                limb2: 0x19b2c3277179dad8,
                limb3: 0x0
            },
            xNegOverY: u384 {
                limb0: 0x65cb7a2d51f12d573abf427c,
                limb1: 0x7b6135e2b23461b64b6a5546,
                limb2: 0x1cfd9aa250b71a72,
                limb3: 0x0
            },
            QyNeg0: u384 {
                limb0: 0xd9868ab4d49cdb52fbce96c9,
                limb1: 0x1e45c4f7c0235b60e45c2664,
                limb2: 0x2b034b663aa5ac3,
                limb3: 0x0
            },
            QyNeg1: u384 {
                limb0: 0x4f79e5f35cbec6e280ab29cb,
                limb1: 0x7a70f00480302f81e7f4d3e8,
                limb2: 0x1089512ca72bdf72,
                limb3: 0x0
            }
        };
        assert_eq!(p_0_result, p_0);
        assert_eq!(p_1_result, p_1);
        assert_eq!(p_2_result, p_2);
    }
}
