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
    BNProcessedPair, BLSProcessedPair, MillerLoopResultScalingFactor
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
fn run_BLS12_381_MP_CHECK_BIT00_LOOP_3_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    Q_0: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q_1: G2Point,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q_2: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one: E12D,
    z: u384,
    ci: u384
) -> (G2Point, G2Point, G2Point, u384, u384, u384) {
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
    let t136 = circuit_add(in17, in18); // Doubling slope numerator start
    let t137 = circuit_sub(in17, in18);
    let t138 = circuit_mul(t136, t137);
    let t139 = circuit_mul(in17, in18);
    let t140 = circuit_mul(t138, in0);
    let t141 = circuit_mul(t139, in1); // Doubling slope numerator end
    let t142 = circuit_add(in19, in19); // Fp2 add coeff 0/1
    let t143 = circuit_add(in20, in20); // Fp2 add coeff 1/1
    let t144 = circuit_mul(t142, t142); // Fp2 Div x/y start : Fp2 Inv y start
    let t145 = circuit_mul(t143, t143);
    let t146 = circuit_add(t144, t145);
    let t147 = circuit_inverse(t146);
    let t148 = circuit_mul(t142, t147); // Fp2 Inv y real part end
    let t149 = circuit_mul(t143, t147);
    let t150 = circuit_sub(in2, t149); // Fp2 Inv y imag part end
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
    let t190 = circuit_mul(t187, t0); // Eval sparse poly line_2p_1 step coeff_2 * z^2
    let t191 = circuit_add(t185, t190); // Eval sparse poly line_2p_1 step + coeff_2 * z^2
    let t192 = circuit_add(t191, t1); // Eval sparse poly line_2p_1 step + 1*z^3
    let t193 = circuit_mul(t188, t4); // Eval sparse poly line_2p_1 step coeff_6 * z^6
    let t194 = circuit_add(t192, t193); // Eval sparse poly line_2p_1 step + coeff_6 * z^6
    let t195 = circuit_mul(t189, t6); // Eval sparse poly line_2p_1 step coeff_8 * z^8
    let t196 = circuit_add(t194, t195); // Eval sparse poly line_2p_1 step + coeff_8 * z^8
    let t197 = circuit_mul(t135, t196); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t198 = circuit_mul(
        t197, t197
    ); // Compute (f^2 * Π(i,k) (line_i,k(z))) ^ 2 = f^4 * (Π(i,k) (line_i,k(z)))^2
    let t199 = circuit_add(t40, t41); // Doubling slope numerator start
    let t200 = circuit_sub(t40, t41);
    let t201 = circuit_mul(t199, t200);
    let t202 = circuit_mul(t40, t41);
    let t203 = circuit_mul(t201, in0);
    let t204 = circuit_mul(t202, in1); // Doubling slope numerator end
    let t205 = circuit_add(t50, t50); // Fp2 add coeff 0/1
    let t206 = circuit_add(t51, t51); // Fp2 add coeff 1/1
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
    let t225 = circuit_add(t40, t40); // Fp2 add coeff 0/1
    let t226 = circuit_add(t41, t41); // Fp2 add coeff 1/1
    let t227 = circuit_sub(t222, t225); // Fp2 sub coeff 0/1
    let t228 = circuit_sub(t224, t226); // Fp2 sub coeff 1/1
    let t229 = circuit_sub(t40, t227); // Fp2 sub coeff 0/1
    let t230 = circuit_sub(t41, t228); // Fp2 sub coeff 1/1
    let t231 = circuit_mul(t216, t229); // Fp2 mul start
    let t232 = circuit_mul(t219, t230);
    let t233 = circuit_sub(t231, t232); // Fp2 mul real part end
    let t234 = circuit_mul(t216, t230);
    let t235 = circuit_mul(t219, t229);
    let t236 = circuit_add(t234, t235); // Fp2 mul imag part end
    let t237 = circuit_sub(t233, t50); // Fp2 sub coeff 0/1
    let t238 = circuit_sub(t236, t51); // Fp2 sub coeff 1/1
    let t239 = circuit_mul(t216, t40); // Fp2 mul start
    let t240 = circuit_mul(t219, t41);
    let t241 = circuit_sub(t239, t240); // Fp2 mul real part end
    let t242 = circuit_mul(t216, t41);
    let t243 = circuit_mul(t219, t40);
    let t244 = circuit_add(t242, t243); // Fp2 mul imag part end
    let t245 = circuit_sub(t241, t50); // Fp2 sub coeff 0/1
    let t246 = circuit_sub(t244, t51); // Fp2 sub coeff 1/1
    let t247 = circuit_sub(t245, t246);
    let t248 = circuit_mul(t247, in3);
    let t249 = circuit_sub(t216, t219);
    let t250 = circuit_mul(t249, in4);
    let t251 = circuit_mul(t246, in3);
    let t252 = circuit_mul(t219, in4);
    let t253 = circuit_mul(t250, t0); // Eval sparse poly line_0p_1 step coeff_2 * z^2
    let t254 = circuit_add(t248, t253); // Eval sparse poly line_0p_1 step + coeff_2 * z^2
    let t255 = circuit_add(t254, t1); // Eval sparse poly line_0p_1 step + 1*z^3
    let t256 = circuit_mul(t251, t4); // Eval sparse poly line_0p_1 step coeff_6 * z^6
    let t257 = circuit_add(t255, t256); // Eval sparse poly line_0p_1 step + coeff_6 * z^6
    let t258 = circuit_mul(t252, t6); // Eval sparse poly line_0p_1 step coeff_8 * z^8
    let t259 = circuit_add(t257, t258); // Eval sparse poly line_0p_1 step + coeff_8 * z^8
    let t260 = circuit_mul(t198, t259); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t261 = circuit_add(t102, t103); // Doubling slope numerator start
    let t262 = circuit_sub(t102, t103);
    let t263 = circuit_mul(t261, t262);
    let t264 = circuit_mul(t102, t103);
    let t265 = circuit_mul(t263, in0);
    let t266 = circuit_mul(t264, in1); // Doubling slope numerator end
    let t267 = circuit_add(t112, t112); // Fp2 add coeff 0/1
    let t268 = circuit_add(t113, t113); // Fp2 add coeff 1/1
    let t269 = circuit_mul(t267, t267); // Fp2 Div x/y start : Fp2 Inv y start
    let t270 = circuit_mul(t268, t268);
    let t271 = circuit_add(t269, t270);
    let t272 = circuit_inverse(t271);
    let t273 = circuit_mul(t267, t272); // Fp2 Inv y real part end
    let t274 = circuit_mul(t268, t272);
    let t275 = circuit_sub(in2, t274); // Fp2 Inv y imag part end
    let t276 = circuit_mul(t265, t273); // Fp2 mul start
    let t277 = circuit_mul(t266, t275);
    let t278 = circuit_sub(t276, t277); // Fp2 mul real part end
    let t279 = circuit_mul(t265, t275);
    let t280 = circuit_mul(t266, t273);
    let t281 = circuit_add(t279, t280); // Fp2 mul imag part end
    let t282 = circuit_add(t278, t281);
    let t283 = circuit_sub(t278, t281);
    let t284 = circuit_mul(t282, t283);
    let t285 = circuit_mul(t278, t281);
    let t286 = circuit_add(t285, t285);
    let t287 = circuit_add(t102, t102); // Fp2 add coeff 0/1
    let t288 = circuit_add(t103, t103); // Fp2 add coeff 1/1
    let t289 = circuit_sub(t284, t287); // Fp2 sub coeff 0/1
    let t290 = circuit_sub(t286, t288); // Fp2 sub coeff 1/1
    let t291 = circuit_sub(t102, t289); // Fp2 sub coeff 0/1
    let t292 = circuit_sub(t103, t290); // Fp2 sub coeff 1/1
    let t293 = circuit_mul(t278, t291); // Fp2 mul start
    let t294 = circuit_mul(t281, t292);
    let t295 = circuit_sub(t293, t294); // Fp2 mul real part end
    let t296 = circuit_mul(t278, t292);
    let t297 = circuit_mul(t281, t291);
    let t298 = circuit_add(t296, t297); // Fp2 mul imag part end
    let t299 = circuit_sub(t295, t112); // Fp2 sub coeff 0/1
    let t300 = circuit_sub(t298, t113); // Fp2 sub coeff 1/1
    let t301 = circuit_mul(t278, t102); // Fp2 mul start
    let t302 = circuit_mul(t281, t103);
    let t303 = circuit_sub(t301, t302); // Fp2 mul real part end
    let t304 = circuit_mul(t278, t103);
    let t305 = circuit_mul(t281, t102);
    let t306 = circuit_add(t304, t305); // Fp2 mul imag part end
    let t307 = circuit_sub(t303, t112); // Fp2 sub coeff 0/1
    let t308 = circuit_sub(t306, t113); // Fp2 sub coeff 1/1
    let t309 = circuit_sub(t307, t308);
    let t310 = circuit_mul(t309, in9);
    let t311 = circuit_sub(t278, t281);
    let t312 = circuit_mul(t311, in10);
    let t313 = circuit_mul(t308, in9);
    let t314 = circuit_mul(t281, in10);
    let t315 = circuit_mul(t312, t0); // Eval sparse poly line_1p_1 step coeff_2 * z^2
    let t316 = circuit_add(t310, t315); // Eval sparse poly line_1p_1 step + coeff_2 * z^2
    let t317 = circuit_add(t316, t1); // Eval sparse poly line_1p_1 step + 1*z^3
    let t318 = circuit_mul(t313, t4); // Eval sparse poly line_1p_1 step coeff_6 * z^6
    let t319 = circuit_add(t317, t318); // Eval sparse poly line_1p_1 step + coeff_6 * z^6
    let t320 = circuit_mul(t314, t6); // Eval sparse poly line_1p_1 step coeff_8 * z^8
    let t321 = circuit_add(t319, t320); // Eval sparse poly line_1p_1 step + coeff_8 * z^8
    let t322 = circuit_mul(t260, t321); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t323 = circuit_add(t164, t165); // Doubling slope numerator start
    let t324 = circuit_sub(t164, t165);
    let t325 = circuit_mul(t323, t324);
    let t326 = circuit_mul(t164, t165);
    let t327 = circuit_mul(t325, in0);
    let t328 = circuit_mul(t326, in1); // Doubling slope numerator end
    let t329 = circuit_add(t174, t174); // Fp2 add coeff 0/1
    let t330 = circuit_add(t175, t175); // Fp2 add coeff 1/1
    let t331 = circuit_mul(t329, t329); // Fp2 Div x/y start : Fp2 Inv y start
    let t332 = circuit_mul(t330, t330);
    let t333 = circuit_add(t331, t332);
    let t334 = circuit_inverse(t333);
    let t335 = circuit_mul(t329, t334); // Fp2 Inv y real part end
    let t336 = circuit_mul(t330, t334);
    let t337 = circuit_sub(in2, t336); // Fp2 Inv y imag part end
    let t338 = circuit_mul(t327, t335); // Fp2 mul start
    let t339 = circuit_mul(t328, t337);
    let t340 = circuit_sub(t338, t339); // Fp2 mul real part end
    let t341 = circuit_mul(t327, t337);
    let t342 = circuit_mul(t328, t335);
    let t343 = circuit_add(t341, t342); // Fp2 mul imag part end
    let t344 = circuit_add(t340, t343);
    let t345 = circuit_sub(t340, t343);
    let t346 = circuit_mul(t344, t345);
    let t347 = circuit_mul(t340, t343);
    let t348 = circuit_add(t347, t347);
    let t349 = circuit_add(t164, t164); // Fp2 add coeff 0/1
    let t350 = circuit_add(t165, t165); // Fp2 add coeff 1/1
    let t351 = circuit_sub(t346, t349); // Fp2 sub coeff 0/1
    let t352 = circuit_sub(t348, t350); // Fp2 sub coeff 1/1
    let t353 = circuit_sub(t164, t351); // Fp2 sub coeff 0/1
    let t354 = circuit_sub(t165, t352); // Fp2 sub coeff 1/1
    let t355 = circuit_mul(t340, t353); // Fp2 mul start
    let t356 = circuit_mul(t343, t354);
    let t357 = circuit_sub(t355, t356); // Fp2 mul real part end
    let t358 = circuit_mul(t340, t354);
    let t359 = circuit_mul(t343, t353);
    let t360 = circuit_add(t358, t359); // Fp2 mul imag part end
    let t361 = circuit_sub(t357, t174); // Fp2 sub coeff 0/1
    let t362 = circuit_sub(t360, t175); // Fp2 sub coeff 1/1
    let t363 = circuit_mul(t340, t164); // Fp2 mul start
    let t364 = circuit_mul(t343, t165);
    let t365 = circuit_sub(t363, t364); // Fp2 mul real part end
    let t366 = circuit_mul(t340, t165);
    let t367 = circuit_mul(t343, t164);
    let t368 = circuit_add(t366, t367); // Fp2 mul imag part end
    let t369 = circuit_sub(t365, t174); // Fp2 sub coeff 0/1
    let t370 = circuit_sub(t368, t175); // Fp2 sub coeff 1/1
    let t371 = circuit_sub(t369, t370);
    let t372 = circuit_mul(t371, in15);
    let t373 = circuit_sub(t340, t343);
    let t374 = circuit_mul(t373, in16);
    let t375 = circuit_mul(t370, in15);
    let t376 = circuit_mul(t343, in16);
    let t377 = circuit_mul(t374, t0); // Eval sparse poly line_2p_1 step coeff_2 * z^2
    let t378 = circuit_add(t372, t377); // Eval sparse poly line_2p_1 step + coeff_2 * z^2
    let t379 = circuit_add(t378, t1); // Eval sparse poly line_2p_1 step + 1*z^3
    let t380 = circuit_mul(t375, t4); // Eval sparse poly line_2p_1 step coeff_6 * z^6
    let t381 = circuit_add(t379, t380); // Eval sparse poly line_2p_1 step + coeff_6 * z^6
    let t382 = circuit_mul(t376, t6); // Eval sparse poly line_2p_1 step coeff_8 * z^8
    let t383 = circuit_add(t381, t382); // Eval sparse poly line_2p_1 step + coeff_8 * z^8
    let t384 = circuit_mul(t322, t383); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t385 = circuit_mul(in24, in35); // Eval R step coeff_1 * z^1
    let t386 = circuit_add(in23, t385); // Eval R step + (coeff_1 * z^1)
    let t387 = circuit_mul(in25, t0); // Eval R step coeff_2 * z^2
    let t388 = circuit_add(t386, t387); // Eval R step + (coeff_2 * z^2)
    let t389 = circuit_mul(in26, t1); // Eval R step coeff_3 * z^3
    let t390 = circuit_add(t388, t389); // Eval R step + (coeff_3 * z^3)
    let t391 = circuit_mul(in27, t2); // Eval R step coeff_4 * z^4
    let t392 = circuit_add(t390, t391); // Eval R step + (coeff_4 * z^4)
    let t393 = circuit_mul(in28, t3); // Eval R step coeff_5 * z^5
    let t394 = circuit_add(t392, t393); // Eval R step + (coeff_5 * z^5)
    let t395 = circuit_mul(in29, t4); // Eval R step coeff_6 * z^6
    let t396 = circuit_add(t394, t395); // Eval R step + (coeff_6 * z^6)
    let t397 = circuit_mul(in30, t5); // Eval R step coeff_7 * z^7
    let t398 = circuit_add(t396, t397); // Eval R step + (coeff_7 * z^7)
    let t399 = circuit_mul(in31, t6); // Eval R step coeff_8 * z^8
    let t400 = circuit_add(t398, t399); // Eval R step + (coeff_8 * z^8)
    let t401 = circuit_mul(in32, t7); // Eval R step coeff_9 * z^9
    let t402 = circuit_add(t400, t401); // Eval R step + (coeff_9 * z^9)
    let t403 = circuit_mul(in33, t8); // Eval R step coeff_10 * z^10
    let t404 = circuit_add(t402, t403); // Eval R step + (coeff_10 * z^10)
    let t405 = circuit_mul(in34, t9); // Eval R step coeff_11 * z^11
    let t406 = circuit_add(t404, t405); // Eval R step + (coeff_11 * z^11)
    let t407 = circuit_sub(t384, t406); // (Π(i,k) (Pk(z))) - Ri(z)
    let t408 = circuit_mul(t10, t407); // ci * ((Π(i,k) (Pk(z)) - Ri(z))
    let t409 = circuit_add(in21, t408); // LHS = LHS + ci * ((Π(i,k) (Pk(z)) - Ri(z))

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
        t227, t228, t237, t238, t289, t290, t299, t300, t351, t352, t361, t362, t406, t409, t10,
    )
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
    let Q0: G2Point = G2Point {
        x0: outputs.get_output(t227),
        x1: outputs.get_output(t228),
        y0: outputs.get_output(t237),
        y1: outputs.get_output(t238)
    };
    let Q1: G2Point = G2Point {
        x0: outputs.get_output(t289),
        x1: outputs.get_output(t290),
        y0: outputs.get_output(t299),
        y1: outputs.get_output(t300)
    };
    let Q2: G2Point = G2Point {
        x0: outputs.get_output(t351),
        x1: outputs.get_output(t352),
        y0: outputs.get_output(t361),
        y1: outputs.get_output(t362)
    };
    let f_i_plus_one_of_z: u384 = outputs.get_output(t406);
    let lhs_i_plus_one: u384 = outputs.get_output(t409);
    let ci_plus_one: u384 = outputs.get_output(t10);
    return (Q0, Q1, Q2, f_i_plus_one_of_z, lhs_i_plus_one, ci_plus_one);
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
fn run_BLS12_381_MP_CHECK_BIT0_LOOP_3_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    Q_0: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q_1: G2Point,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q_2: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one: E12D,
    z: u384,
    ci: u384
) -> (G2Point, G2Point, G2Point, u384, u384, u384) {
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
    let t136 = circuit_add(in17, in18); // Doubling slope numerator start
    let t137 = circuit_sub(in17, in18);
    let t138 = circuit_mul(t136, t137);
    let t139 = circuit_mul(in17, in18);
    let t140 = circuit_mul(t138, in0);
    let t141 = circuit_mul(t139, in1); // Doubling slope numerator end
    let t142 = circuit_add(in19, in19); // Fp2 add coeff 0/1
    let t143 = circuit_add(in20, in20); // Fp2 add coeff 1/1
    let t144 = circuit_mul(t142, t142); // Fp2 Div x/y start : Fp2 Inv y start
    let t145 = circuit_mul(t143, t143);
    let t146 = circuit_add(t144, t145);
    let t147 = circuit_inverse(t146);
    let t148 = circuit_mul(t142, t147); // Fp2 Inv y real part end
    let t149 = circuit_mul(t143, t147);
    let t150 = circuit_sub(in2, t149); // Fp2 Inv y imag part end
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
    let t190 = circuit_mul(t187, t0); // Eval sparse poly line_2p_1 step coeff_2 * z^2
    let t191 = circuit_add(t185, t190); // Eval sparse poly line_2p_1 step + coeff_2 * z^2
    let t192 = circuit_add(t191, t1); // Eval sparse poly line_2p_1 step + 1*z^3
    let t193 = circuit_mul(t188, t4); // Eval sparse poly line_2p_1 step coeff_6 * z^6
    let t194 = circuit_add(t192, t193); // Eval sparse poly line_2p_1 step + coeff_6 * z^6
    let t195 = circuit_mul(t189, t6); // Eval sparse poly line_2p_1 step coeff_8 * z^8
    let t196 = circuit_add(t194, t195); // Eval sparse poly line_2p_1 step + coeff_8 * z^8
    let t197 = circuit_mul(t135, t196); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t198 = circuit_mul(in24, in35); // Eval R step coeff_1 * z^1
    let t199 = circuit_add(in23, t198); // Eval R step + (coeff_1 * z^1)
    let t200 = circuit_mul(in25, t0); // Eval R step coeff_2 * z^2
    let t201 = circuit_add(t199, t200); // Eval R step + (coeff_2 * z^2)
    let t202 = circuit_mul(in26, t1); // Eval R step coeff_3 * z^3
    let t203 = circuit_add(t201, t202); // Eval R step + (coeff_3 * z^3)
    let t204 = circuit_mul(in27, t2); // Eval R step coeff_4 * z^4
    let t205 = circuit_add(t203, t204); // Eval R step + (coeff_4 * z^4)
    let t206 = circuit_mul(in28, t3); // Eval R step coeff_5 * z^5
    let t207 = circuit_add(t205, t206); // Eval R step + (coeff_5 * z^5)
    let t208 = circuit_mul(in29, t4); // Eval R step coeff_6 * z^6
    let t209 = circuit_add(t207, t208); // Eval R step + (coeff_6 * z^6)
    let t210 = circuit_mul(in30, t5); // Eval R step coeff_7 * z^7
    let t211 = circuit_add(t209, t210); // Eval R step + (coeff_7 * z^7)
    let t212 = circuit_mul(in31, t6); // Eval R step coeff_8 * z^8
    let t213 = circuit_add(t211, t212); // Eval R step + (coeff_8 * z^8)
    let t214 = circuit_mul(in32, t7); // Eval R step coeff_9 * z^9
    let t215 = circuit_add(t213, t214); // Eval R step + (coeff_9 * z^9)
    let t216 = circuit_mul(in33, t8); // Eval R step coeff_10 * z^10
    let t217 = circuit_add(t215, t216); // Eval R step + (coeff_10 * z^10)
    let t218 = circuit_mul(in34, t9); // Eval R step coeff_11 * z^11
    let t219 = circuit_add(t217, t218); // Eval R step + (coeff_11 * z^11)
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
fn run_BLS12_381_MP_CHECK_BIT1_LOOP_3_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    Q_0: G2Point,
    Q_or_Q_neg_0: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q_1: G2Point,
    Q_or_Q_neg_1: G2Point,
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
) -> (G2Point, G2Point, G2Point, u384, u384, u384) {
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
    let t266 = circuit_add(in25, in25); // Fp2 add coeff 0/1
    let t267 = circuit_add(in26, in26); // Fp2 add coeff 1/1
    let t268 = circuit_sub(t256, in23); // Fp2 sub coeff 0/1
    let t269 = circuit_sub(t257, in24); // Fp2 sub coeff 1/1
    let t270 = circuit_mul(t268, t268); // Fp2 Div x/y start : Fp2 Inv y start
    let t271 = circuit_mul(t269, t269);
    let t272 = circuit_add(t270, t271);
    let t273 = circuit_inverse(t272);
    let t274 = circuit_mul(t268, t273); // Fp2 Inv y real part end
    let t275 = circuit_mul(t269, t273);
    let t276 = circuit_sub(in0, t275); // Fp2 Inv y imag part end
    let t277 = circuit_mul(t266, t274); // Fp2 mul start
    let t278 = circuit_mul(t267, t276);
    let t279 = circuit_sub(t277, t278); // Fp2 mul real part end
    let t280 = circuit_mul(t266, t276);
    let t281 = circuit_mul(t267, t274);
    let t282 = circuit_add(t280, t281); // Fp2 mul imag part end
    let t283 = circuit_add(t245, t279); // Fp2 add coeff 0/1
    let t284 = circuit_add(t248, t282); // Fp2 add coeff 1/1
    let t285 = circuit_sub(in0, t283); // Fp2 neg coeff 0/1
    let t286 = circuit_sub(in0, t284); // Fp2 neg coeff 1/1
    let t287 = circuit_add(t285, t286);
    let t288 = circuit_sub(t285, t286);
    let t289 = circuit_mul(t287, t288);
    let t290 = circuit_mul(t285, t286);
    let t291 = circuit_add(t290, t290);
    let t292 = circuit_sub(t289, in23); // Fp2 sub coeff 0/1
    let t293 = circuit_sub(t291, in24); // Fp2 sub coeff 1/1
    let t294 = circuit_sub(t292, t256); // Fp2 sub coeff 0/1
    let t295 = circuit_sub(t293, t257); // Fp2 sub coeff 1/1
    let t296 = circuit_sub(in23, t294); // Fp2 sub coeff 0/1
    let t297 = circuit_sub(in24, t295); // Fp2 sub coeff 1/1
    let t298 = circuit_mul(t285, t296); // Fp2 mul start
    let t299 = circuit_mul(t286, t297);
    let t300 = circuit_sub(t298, t299); // Fp2 mul real part end
    let t301 = circuit_mul(t285, t297);
    let t302 = circuit_mul(t286, t296);
    let t303 = circuit_add(t301, t302); // Fp2 mul imag part end
    let t304 = circuit_sub(t300, in25); // Fp2 sub coeff 0/1
    let t305 = circuit_sub(t303, in26); // Fp2 sub coeff 1/1
    let t306 = circuit_mul(t285, in23); // Fp2 mul start
    let t307 = circuit_mul(t286, in24);
    let t308 = circuit_sub(t306, t307); // Fp2 mul real part end
    let t309 = circuit_mul(t285, in24);
    let t310 = circuit_mul(t286, in23);
    let t311 = circuit_add(t309, t310); // Fp2 mul imag part end
    let t312 = circuit_sub(t308, in25); // Fp2 sub coeff 0/1
    let t313 = circuit_sub(t311, in26); // Fp2 sub coeff 1/1
    let t314 = circuit_sub(t264, t265);
    let t315 = circuit_mul(t314, in21);
    let t316 = circuit_sub(t245, t248);
    let t317 = circuit_mul(t316, in22);
    let t318 = circuit_mul(t265, in21);
    let t319 = circuit_mul(t248, in22);
    let t320 = circuit_sub(t312, t313);
    let t321 = circuit_mul(t320, in21);
    let t322 = circuit_sub(t285, t286);
    let t323 = circuit_mul(t322, in22);
    let t324 = circuit_mul(t313, in21);
    let t325 = circuit_mul(t286, in22);
    let t326 = circuit_mul(t317, t0); // Eval sparse poly line_2p_1 step coeff_2 * z^2
    let t327 = circuit_add(t315, t326); // Eval sparse poly line_2p_1 step + coeff_2 * z^2
    let t328 = circuit_add(t327, t1); // Eval sparse poly line_2p_1 step + 1*z^3
    let t329 = circuit_mul(t318, t4); // Eval sparse poly line_2p_1 step coeff_6 * z^6
    let t330 = circuit_add(t328, t329); // Eval sparse poly line_2p_1 step + coeff_6 * z^6
    let t331 = circuit_mul(t319, t6); // Eval sparse poly line_2p_1 step coeff_8 * z^8
    let t332 = circuit_add(t330, t331); // Eval sparse poly line_2p_1 step + coeff_8 * z^8
    let t333 = circuit_mul(t231, t332); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t334 = circuit_mul(t323, t0); // Eval sparse poly line_2p_2 step coeff_2 * z^2
    let t335 = circuit_add(t321, t334); // Eval sparse poly line_2p_2 step + coeff_2 * z^2
    let t336 = circuit_add(t335, t1); // Eval sparse poly line_2p_2 step + 1*z^3
    let t337 = circuit_mul(t324, t4); // Eval sparse poly line_2p_2 step coeff_6 * z^6
    let t338 = circuit_add(t336, t337); // Eval sparse poly line_2p_2 step + coeff_6 * z^6
    let t339 = circuit_mul(t325, t6); // Eval sparse poly line_2p_2 step coeff_8 * z^8
    let t340 = circuit_add(t338, t339); // Eval sparse poly line_2p_2 step + coeff_8 * z^8
    let t341 = circuit_mul(t333, t340); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t342 = circuit_mul(t341, in45);
    let t343 = circuit_mul(in34, in46); // Eval R step coeff_1 * z^1
    let t344 = circuit_add(in33, t343); // Eval R step + (coeff_1 * z^1)
    let t345 = circuit_mul(in35, t0); // Eval R step coeff_2 * z^2
    let t346 = circuit_add(t344, t345); // Eval R step + (coeff_2 * z^2)
    let t347 = circuit_mul(in36, t1); // Eval R step coeff_3 * z^3
    let t348 = circuit_add(t346, t347); // Eval R step + (coeff_3 * z^3)
    let t349 = circuit_mul(in37, t2); // Eval R step coeff_4 * z^4
    let t350 = circuit_add(t348, t349); // Eval R step + (coeff_4 * z^4)
    let t351 = circuit_mul(in38, t3); // Eval R step coeff_5 * z^5
    let t352 = circuit_add(t350, t351); // Eval R step + (coeff_5 * z^5)
    let t353 = circuit_mul(in39, t4); // Eval R step coeff_6 * z^6
    let t354 = circuit_add(t352, t353); // Eval R step + (coeff_6 * z^6)
    let t355 = circuit_mul(in40, t5); // Eval R step coeff_7 * z^7
    let t356 = circuit_add(t354, t355); // Eval R step + (coeff_7 * z^7)
    let t357 = circuit_mul(in41, t6); // Eval R step coeff_8 * z^8
    let t358 = circuit_add(t356, t357); // Eval R step + (coeff_8 * z^8)
    let t359 = circuit_mul(in42, t7); // Eval R step coeff_9 * z^9
    let t360 = circuit_add(t358, t359); // Eval R step + (coeff_9 * z^9)
    let t361 = circuit_mul(in43, t8); // Eval R step coeff_10 * z^10
    let t362 = circuit_add(t360, t361); // Eval R step + (coeff_10 * z^10)
    let t363 = circuit_mul(in44, t9); // Eval R step coeff_11 * z^11
    let t364 = circuit_add(t362, t363); // Eval R step + (coeff_11 * z^11)
    let t365 = circuit_sub(t342, t364); // (Π(i,k) (Pk(z))) - Ri(z)
    let t366 = circuit_mul(t10, t365); // ci * ((Π(i,k) (Pk(z)) - Ri(z))
    let t367 = circuit_add(in31, t366); // LHS = LHS + ci * ((Π(i,k) (Pk(z)) - Ri(z))

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
        t74, t75, t84, t85, t184, t185, t194, t195, t294, t295, t304, t305, t364, t367, t10,
    )
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
    let Q2: G2Point = G2Point {
        x0: outputs.get_output(t294),
        x1: outputs.get_output(t295),
        y0: outputs.get_output(t304),
        y1: outputs.get_output(t305)
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
fn run_BLS12_381_MP_CHECK_INIT_BIT_3_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    Q_0: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q_1: G2Point,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q_2: G2Point,
    R_i: E12D,
    c0: u384,
    z: u384,
    c_inv_of_z: u384
) -> (G2Point, G2Point, G2Point, u384, u384) {
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
    let in35 = CE::<CI<35>> {};
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
    let t10 = circuit_mul(in22, in34); // Eval R step coeff_1 * z^1
    let t11 = circuit_add(in21, t10); // Eval R step + (coeff_1 * z^1)
    let t12 = circuit_mul(in23, t0); // Eval R step coeff_2 * z^2
    let t13 = circuit_add(t11, t12); // Eval R step + (coeff_2 * z^2)
    let t14 = circuit_mul(in24, t1); // Eval R step coeff_3 * z^3
    let t15 = circuit_add(t13, t14); // Eval R step + (coeff_3 * z^3)
    let t16 = circuit_mul(in25, t2); // Eval R step coeff_4 * z^4
    let t17 = circuit_add(t15, t16); // Eval R step + (coeff_4 * z^4)
    let t18 = circuit_mul(in26, t3); // Eval R step coeff_5 * z^5
    let t19 = circuit_add(t17, t18); // Eval R step + (coeff_5 * z^5)
    let t20 = circuit_mul(in27, t4); // Eval R step coeff_6 * z^6
    let t21 = circuit_add(t19, t20); // Eval R step + (coeff_6 * z^6)
    let t22 = circuit_mul(in28, t5); // Eval R step coeff_7 * z^7
    let t23 = circuit_add(t21, t22); // Eval R step + (coeff_7 * z^7)
    let t24 = circuit_mul(in29, t6); // Eval R step coeff_8 * z^8
    let t25 = circuit_add(t23, t24); // Eval R step + (coeff_8 * z^8)
    let t26 = circuit_mul(in30, t7); // Eval R step coeff_9 * z^9
    let t27 = circuit_add(t25, t26); // Eval R step + (coeff_9 * z^9)
    let t28 = circuit_mul(in31, t8); // Eval R step coeff_10 * z^10
    let t29 = circuit_add(t27, t28); // Eval R step + (coeff_10 * z^10)
    let t30 = circuit_mul(in32, t9); // Eval R step coeff_11 * z^11
    let t31 = circuit_add(t29, t30); // Eval R step + (coeff_11 * z^11)
    let t32 = circuit_mul(in35, in35);
    let t33 = circuit_mul(in35, t32);
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
    let t254 = circuit_add(in17, in18);
    let t255 = circuit_sub(in17, in18);
    let t256 = circuit_mul(t254, t255);
    let t257 = circuit_mul(in17, in18);
    let t258 = circuit_mul(t256, in0);
    let t259 = circuit_mul(t257, in1);
    let t260 = circuit_add(in19, in19); // Fp2 add coeff 0/1
    let t261 = circuit_add(in20, in20); // Fp2 add coeff 1/1
    let t262 = circuit_mul(t260, t260); // Fp2 Div x/y start : Fp2 Inv y start
    let t263 = circuit_mul(t261, t261);
    let t264 = circuit_add(t262, t263);
    let t265 = circuit_inverse(t264);
    let t266 = circuit_mul(t260, t265); // Fp2 Inv y real part end
    let t267 = circuit_mul(t261, t265);
    let t268 = circuit_sub(in2, t267); // Fp2 Inv y imag part end
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
    let t283 = circuit_add(t271, t274);
    let t284 = circuit_sub(t271, t274);
    let t285 = circuit_mul(t283, t284);
    let t286 = circuit_mul(t271, t274);
    let t287 = circuit_add(t286, t286);
    let t288 = circuit_add(in17, in17); // Fp2 add coeff 0/1
    let t289 = circuit_add(in18, in18); // Fp2 add coeff 1/1
    let t290 = circuit_sub(t285, t288); // Fp2 sub coeff 0/1
    let t291 = circuit_sub(t287, t289); // Fp2 sub coeff 1/1
    let t292 = circuit_sub(in17, t290); // Fp2 sub coeff 0/1
    let t293 = circuit_sub(in18, t291); // Fp2 sub coeff 1/1
    let t294 = circuit_mul(t292, t292); // Fp2 Div x/y start : Fp2 Inv y start
    let t295 = circuit_mul(t293, t293);
    let t296 = circuit_add(t294, t295);
    let t297 = circuit_inverse(t296);
    let t298 = circuit_mul(t292, t297); // Fp2 Inv y real part end
    let t299 = circuit_mul(t293, t297);
    let t300 = circuit_sub(in2, t299); // Fp2 Inv y imag part end
    let t301 = circuit_mul(t260, t298); // Fp2 mul start
    let t302 = circuit_mul(t261, t300);
    let t303 = circuit_sub(t301, t302); // Fp2 mul real part end
    let t304 = circuit_mul(t260, t300);
    let t305 = circuit_mul(t261, t298);
    let t306 = circuit_add(t304, t305); // Fp2 mul imag part end
    let t307 = circuit_sub(t303, t271); // Fp2 sub coeff 0/1
    let t308 = circuit_sub(t306, t274); // Fp2 sub coeff 1/1
    let t309 = circuit_mul(t307, in17); // Fp2 mul start
    let t310 = circuit_mul(t308, in18);
    let t311 = circuit_sub(t309, t310); // Fp2 mul real part end
    let t312 = circuit_mul(t307, in18);
    let t313 = circuit_mul(t308, in17);
    let t314 = circuit_add(t312, t313); // Fp2 mul imag part end
    let t315 = circuit_sub(t311, in19); // Fp2 sub coeff 0/1
    let t316 = circuit_sub(t314, in20); // Fp2 sub coeff 1/1
    let t317 = circuit_add(t307, t308);
    let t318 = circuit_sub(t307, t308);
    let t319 = circuit_mul(t317, t318);
    let t320 = circuit_mul(t307, t308);
    let t321 = circuit_add(t320, t320);
    let t322 = circuit_add(in17, t290); // Fp2 add coeff 0/1
    let t323 = circuit_add(in18, t291); // Fp2 add coeff 1/1
    let t324 = circuit_sub(t319, t322); // Fp2 sub coeff 0/1
    let t325 = circuit_sub(t321, t323); // Fp2 sub coeff 1/1
    let t326 = circuit_sub(in17, t324); // Fp2 sub coeff 0/1
    let t327 = circuit_sub(in18, t325); // Fp2 sub coeff 1/1
    let t328 = circuit_mul(t307, t326); // Fp2 mul start
    let t329 = circuit_mul(t308, t327);
    let t330 = circuit_sub(t328, t329); // Fp2 mul real part end
    let t331 = circuit_mul(t307, t327);
    let t332 = circuit_mul(t308, t326);
    let t333 = circuit_add(t331, t332); // Fp2 mul imag part end
    let t334 = circuit_sub(t330, in19); // Fp2 sub coeff 0/1
    let t335 = circuit_sub(t333, in20); // Fp2 sub coeff 1/1
    let t336 = circuit_sub(t281, t282);
    let t337 = circuit_mul(t336, in15);
    let t338 = circuit_sub(t271, t274);
    let t339 = circuit_mul(t338, in16);
    let t340 = circuit_mul(t282, in15);
    let t341 = circuit_mul(t274, in16);
    let t342 = circuit_sub(t315, t316);
    let t343 = circuit_mul(t342, in15);
    let t344 = circuit_sub(t307, t308);
    let t345 = circuit_mul(t344, in16);
    let t346 = circuit_mul(t316, in15);
    let t347 = circuit_mul(t308, in16);
    let t348 = circuit_mul(t339, t0); // Eval sparse poly line_2p_1 step coeff_2 * z^2
    let t349 = circuit_add(t337, t348); // Eval sparse poly line_2p_1 step + coeff_2 * z^2
    let t350 = circuit_add(t349, t1); // Eval sparse poly line_2p_1 step + 1*z^3
    let t351 = circuit_mul(t340, t4); // Eval sparse poly line_2p_1 step coeff_6 * z^6
    let t352 = circuit_add(t350, t351); // Eval sparse poly line_2p_1 step + coeff_6 * z^6
    let t353 = circuit_mul(t341, t6); // Eval sparse poly line_2p_1 step coeff_8 * z^8
    let t354 = circuit_add(t352, t353); // Eval sparse poly line_2p_1 step + coeff_8 * z^8
    let t355 = circuit_mul(t253, t354);
    let t356 = circuit_mul(t345, t0); // Eval sparse poly line_2p_2 step coeff_2 * z^2
    let t357 = circuit_add(t343, t356); // Eval sparse poly line_2p_2 step + coeff_2 * z^2
    let t358 = circuit_add(t357, t1); // Eval sparse poly line_2p_2 step + 1*z^3
    let t359 = circuit_mul(t346, t4); // Eval sparse poly line_2p_2 step coeff_6 * z^6
    let t360 = circuit_add(t358, t359); // Eval sparse poly line_2p_2 step + coeff_6 * z^6
    let t361 = circuit_mul(t347, t6); // Eval sparse poly line_2p_2 step coeff_8 * z^8
    let t362 = circuit_add(t360, t361); // Eval sparse poly line_2p_2 step + coeff_8 * z^8
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
        t104, t105, t114, t115, t214, t215, t224, t225, t324, t325, t334, t335, t365, t31,
    )
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
    let Q2: G2Point = G2Point {
        x0: outputs.get_output(t324),
        x1: outputs.get_output(t325),
        y0: outputs.get_output(t334),
        y1: outputs.get_output(t335)
    };
    let new_lhs: u384 = outputs.get_output(t365);
    let f_i_plus_one_of_z: u384 = outputs.get_output(t31);
    return (Q0, Q1, Q2, new_lhs, f_i_plus_one_of_z);
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
fn run_BN254_MP_CHECK_BIT00_LOOP_3_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    Q_0: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q_1: G2Point,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q_2: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one: E12D,
    z: u384,
    ci: u384
) -> (G2Point, G2Point, G2Point, u384, u384, u384) {
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
    let t68 = circuit_mul(t62, in37); // Eval sparse poly line_0p_1 step coeff_1 * z^1
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
    let t133 = circuit_mul(t127, in37); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t134 = circuit_add(in4, t133); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t135 = circuit_mul(t130, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t136 = circuit_add(t134, t135); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t137 = circuit_mul(t131, t5); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t138 = circuit_add(t136, t137); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t139 = circuit_mul(t132, t7); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t140 = circuit_add(t138, t139); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t141 = circuit_mul(t76, t140); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t142 = circuit_add(in19, in20); // Doubling slope numerator start
    let t143 = circuit_sub(in19, in20);
    let t144 = circuit_mul(t142, t143);
    let t145 = circuit_mul(in19, in20);
    let t146 = circuit_mul(t144, in0);
    let t147 = circuit_mul(t145, in1); // Doubling slope numerator end
    let t148 = circuit_add(in21, in21); // Fp2 add coeff 0/1
    let t149 = circuit_add(in22, in22); // Fp2 add coeff 1/1
    let t150 = circuit_mul(t148, t148); // Fp2 Div x/y start : Fp2 Inv y start
    let t151 = circuit_mul(t149, t149);
    let t152 = circuit_add(t150, t151);
    let t153 = circuit_inverse(t152);
    let t154 = circuit_mul(t148, t153); // Fp2 Inv y real part end
    let t155 = circuit_mul(t149, t153);
    let t156 = circuit_sub(in2, t155); // Fp2 Inv y imag part end
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
    let t198 = circuit_mul(t192, in37); // Eval sparse poly line_2p_1 step coeff_1 * z^1
    let t199 = circuit_add(in4, t198); // Eval sparse poly line_2p_1 step + coeff_1 * z^1
    let t200 = circuit_mul(t195, t1); // Eval sparse poly line_2p_1 step coeff_3 * z^3
    let t201 = circuit_add(t199, t200); // Eval sparse poly line_2p_1 step + coeff_3 * z^3
    let t202 = circuit_mul(t196, t5); // Eval sparse poly line_2p_1 step coeff_7 * z^7
    let t203 = circuit_add(t201, t202); // Eval sparse poly line_2p_1 step + coeff_7 * z^7
    let t204 = circuit_mul(t197, t7); // Eval sparse poly line_2p_1 step coeff_9 * z^9
    let t205 = circuit_add(t203, t204); // Eval sparse poly line_2p_1 step + coeff_9 * z^9
    let t206 = circuit_mul(t141, t205); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t207 = circuit_mul(
        t206, t206
    ); // Compute (f^2 * Π(i,k) (line_i,k(z))) ^ 2 = f^4 * (Π(i,k) (line_i,k(z)))^2
    let t208 = circuit_add(t40, t41); // Doubling slope numerator start
    let t209 = circuit_sub(t40, t41);
    let t210 = circuit_mul(t208, t209);
    let t211 = circuit_mul(t40, t41);
    let t212 = circuit_mul(t210, in0);
    let t213 = circuit_mul(t211, in1); // Doubling slope numerator end
    let t214 = circuit_add(t50, t50); // Fp2 add coeff 0/1
    let t215 = circuit_add(t51, t51); // Fp2 add coeff 1/1
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
    let t234 = circuit_add(t40, t40); // Fp2 add coeff 0/1
    let t235 = circuit_add(t41, t41); // Fp2 add coeff 1/1
    let t236 = circuit_sub(t231, t234); // Fp2 sub coeff 0/1
    let t237 = circuit_sub(t233, t235); // Fp2 sub coeff 1/1
    let t238 = circuit_sub(t40, t236); // Fp2 sub coeff 0/1
    let t239 = circuit_sub(t41, t237); // Fp2 sub coeff 1/1
    let t240 = circuit_mul(t225, t238); // Fp2 mul start
    let t241 = circuit_mul(t228, t239);
    let t242 = circuit_sub(t240, t241); // Fp2 mul real part end
    let t243 = circuit_mul(t225, t239);
    let t244 = circuit_mul(t228, t238);
    let t245 = circuit_add(t243, t244); // Fp2 mul imag part end
    let t246 = circuit_sub(t242, t50); // Fp2 sub coeff 0/1
    let t247 = circuit_sub(t245, t51); // Fp2 sub coeff 1/1
    let t248 = circuit_mul(t225, t40); // Fp2 mul start
    let t249 = circuit_mul(t228, t41);
    let t250 = circuit_sub(t248, t249); // Fp2 mul real part end
    let t251 = circuit_mul(t225, t41);
    let t252 = circuit_mul(t228, t40);
    let t253 = circuit_add(t251, t252); // Fp2 mul imag part end
    let t254 = circuit_sub(t250, t50); // Fp2 sub coeff 0/1
    let t255 = circuit_sub(t253, t51); // Fp2 sub coeff 1/1
    let t256 = circuit_mul(in3, t228);
    let t257 = circuit_add(t225, t256);
    let t258 = circuit_mul(t257, in6);
    let t259 = circuit_mul(in3, t255);
    let t260 = circuit_add(t254, t259);
    let t261 = circuit_mul(t260, in5);
    let t262 = circuit_mul(t228, in6);
    let t263 = circuit_mul(t255, in5);
    let t264 = circuit_mul(t258, in37); // Eval sparse poly line_0p_1 step coeff_1 * z^1
    let t265 = circuit_add(in4, t264); // Eval sparse poly line_0p_1 step + coeff_1 * z^1
    let t266 = circuit_mul(t261, t1); // Eval sparse poly line_0p_1 step coeff_3 * z^3
    let t267 = circuit_add(t265, t266); // Eval sparse poly line_0p_1 step + coeff_3 * z^3
    let t268 = circuit_mul(t262, t5); // Eval sparse poly line_0p_1 step coeff_7 * z^7
    let t269 = circuit_add(t267, t268); // Eval sparse poly line_0p_1 step + coeff_7 * z^7
    let t270 = circuit_mul(t263, t7); // Eval sparse poly line_0p_1 step coeff_9 * z^9
    let t271 = circuit_add(t269, t270); // Eval sparse poly line_0p_1 step + coeff_9 * z^9
    let t272 = circuit_mul(t207, t271); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t273 = circuit_add(t105, t106); // Doubling slope numerator start
    let t274 = circuit_sub(t105, t106);
    let t275 = circuit_mul(t273, t274);
    let t276 = circuit_mul(t105, t106);
    let t277 = circuit_mul(t275, in0);
    let t278 = circuit_mul(t276, in1); // Doubling slope numerator end
    let t279 = circuit_add(t115, t115); // Fp2 add coeff 0/1
    let t280 = circuit_add(t116, t116); // Fp2 add coeff 1/1
    let t281 = circuit_mul(t279, t279); // Fp2 Div x/y start : Fp2 Inv y start
    let t282 = circuit_mul(t280, t280);
    let t283 = circuit_add(t281, t282);
    let t284 = circuit_inverse(t283);
    let t285 = circuit_mul(t279, t284); // Fp2 Inv y real part end
    let t286 = circuit_mul(t280, t284);
    let t287 = circuit_sub(in2, t286); // Fp2 Inv y imag part end
    let t288 = circuit_mul(t277, t285); // Fp2 mul start
    let t289 = circuit_mul(t278, t287);
    let t290 = circuit_sub(t288, t289); // Fp2 mul real part end
    let t291 = circuit_mul(t277, t287);
    let t292 = circuit_mul(t278, t285);
    let t293 = circuit_add(t291, t292); // Fp2 mul imag part end
    let t294 = circuit_add(t290, t293);
    let t295 = circuit_sub(t290, t293);
    let t296 = circuit_mul(t294, t295);
    let t297 = circuit_mul(t290, t293);
    let t298 = circuit_add(t297, t297);
    let t299 = circuit_add(t105, t105); // Fp2 add coeff 0/1
    let t300 = circuit_add(t106, t106); // Fp2 add coeff 1/1
    let t301 = circuit_sub(t296, t299); // Fp2 sub coeff 0/1
    let t302 = circuit_sub(t298, t300); // Fp2 sub coeff 1/1
    let t303 = circuit_sub(t105, t301); // Fp2 sub coeff 0/1
    let t304 = circuit_sub(t106, t302); // Fp2 sub coeff 1/1
    let t305 = circuit_mul(t290, t303); // Fp2 mul start
    let t306 = circuit_mul(t293, t304);
    let t307 = circuit_sub(t305, t306); // Fp2 mul real part end
    let t308 = circuit_mul(t290, t304);
    let t309 = circuit_mul(t293, t303);
    let t310 = circuit_add(t308, t309); // Fp2 mul imag part end
    let t311 = circuit_sub(t307, t115); // Fp2 sub coeff 0/1
    let t312 = circuit_sub(t310, t116); // Fp2 sub coeff 1/1
    let t313 = circuit_mul(t290, t105); // Fp2 mul start
    let t314 = circuit_mul(t293, t106);
    let t315 = circuit_sub(t313, t314); // Fp2 mul real part end
    let t316 = circuit_mul(t290, t106);
    let t317 = circuit_mul(t293, t105);
    let t318 = circuit_add(t316, t317); // Fp2 mul imag part end
    let t319 = circuit_sub(t315, t115); // Fp2 sub coeff 0/1
    let t320 = circuit_sub(t318, t116); // Fp2 sub coeff 1/1
    let t321 = circuit_mul(in3, t293);
    let t322 = circuit_add(t290, t321);
    let t323 = circuit_mul(t322, in12);
    let t324 = circuit_mul(in3, t320);
    let t325 = circuit_add(t319, t324);
    let t326 = circuit_mul(t325, in11);
    let t327 = circuit_mul(t293, in12);
    let t328 = circuit_mul(t320, in11);
    let t329 = circuit_mul(t323, in37); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t330 = circuit_add(in4, t329); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t331 = circuit_mul(t326, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t332 = circuit_add(t330, t331); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t333 = circuit_mul(t327, t5); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t334 = circuit_add(t332, t333); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t335 = circuit_mul(t328, t7); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t336 = circuit_add(t334, t335); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t337 = circuit_mul(t272, t336); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t338 = circuit_add(t170, t171); // Doubling slope numerator start
    let t339 = circuit_sub(t170, t171);
    let t340 = circuit_mul(t338, t339);
    let t341 = circuit_mul(t170, t171);
    let t342 = circuit_mul(t340, in0);
    let t343 = circuit_mul(t341, in1); // Doubling slope numerator end
    let t344 = circuit_add(t180, t180); // Fp2 add coeff 0/1
    let t345 = circuit_add(t181, t181); // Fp2 add coeff 1/1
    let t346 = circuit_mul(t344, t344); // Fp2 Div x/y start : Fp2 Inv y start
    let t347 = circuit_mul(t345, t345);
    let t348 = circuit_add(t346, t347);
    let t349 = circuit_inverse(t348);
    let t350 = circuit_mul(t344, t349); // Fp2 Inv y real part end
    let t351 = circuit_mul(t345, t349);
    let t352 = circuit_sub(in2, t351); // Fp2 Inv y imag part end
    let t353 = circuit_mul(t342, t350); // Fp2 mul start
    let t354 = circuit_mul(t343, t352);
    let t355 = circuit_sub(t353, t354); // Fp2 mul real part end
    let t356 = circuit_mul(t342, t352);
    let t357 = circuit_mul(t343, t350);
    let t358 = circuit_add(t356, t357); // Fp2 mul imag part end
    let t359 = circuit_add(t355, t358);
    let t360 = circuit_sub(t355, t358);
    let t361 = circuit_mul(t359, t360);
    let t362 = circuit_mul(t355, t358);
    let t363 = circuit_add(t362, t362);
    let t364 = circuit_add(t170, t170); // Fp2 add coeff 0/1
    let t365 = circuit_add(t171, t171); // Fp2 add coeff 1/1
    let t366 = circuit_sub(t361, t364); // Fp2 sub coeff 0/1
    let t367 = circuit_sub(t363, t365); // Fp2 sub coeff 1/1
    let t368 = circuit_sub(t170, t366); // Fp2 sub coeff 0/1
    let t369 = circuit_sub(t171, t367); // Fp2 sub coeff 1/1
    let t370 = circuit_mul(t355, t368); // Fp2 mul start
    let t371 = circuit_mul(t358, t369);
    let t372 = circuit_sub(t370, t371); // Fp2 mul real part end
    let t373 = circuit_mul(t355, t369);
    let t374 = circuit_mul(t358, t368);
    let t375 = circuit_add(t373, t374); // Fp2 mul imag part end
    let t376 = circuit_sub(t372, t180); // Fp2 sub coeff 0/1
    let t377 = circuit_sub(t375, t181); // Fp2 sub coeff 1/1
    let t378 = circuit_mul(t355, t170); // Fp2 mul start
    let t379 = circuit_mul(t358, t171);
    let t380 = circuit_sub(t378, t379); // Fp2 mul real part end
    let t381 = circuit_mul(t355, t171);
    let t382 = circuit_mul(t358, t170);
    let t383 = circuit_add(t381, t382); // Fp2 mul imag part end
    let t384 = circuit_sub(t380, t180); // Fp2 sub coeff 0/1
    let t385 = circuit_sub(t383, t181); // Fp2 sub coeff 1/1
    let t386 = circuit_mul(in3, t358);
    let t387 = circuit_add(t355, t386);
    let t388 = circuit_mul(t387, in18);
    let t389 = circuit_mul(in3, t385);
    let t390 = circuit_add(t384, t389);
    let t391 = circuit_mul(t390, in17);
    let t392 = circuit_mul(t358, in18);
    let t393 = circuit_mul(t385, in17);
    let t394 = circuit_mul(t388, in37); // Eval sparse poly line_2p_1 step coeff_1 * z^1
    let t395 = circuit_add(in4, t394); // Eval sparse poly line_2p_1 step + coeff_1 * z^1
    let t396 = circuit_mul(t391, t1); // Eval sparse poly line_2p_1 step coeff_3 * z^3
    let t397 = circuit_add(t395, t396); // Eval sparse poly line_2p_1 step + coeff_3 * z^3
    let t398 = circuit_mul(t392, t5); // Eval sparse poly line_2p_1 step coeff_7 * z^7
    let t399 = circuit_add(t397, t398); // Eval sparse poly line_2p_1 step + coeff_7 * z^7
    let t400 = circuit_mul(t393, t7); // Eval sparse poly line_2p_1 step coeff_9 * z^9
    let t401 = circuit_add(t399, t400); // Eval sparse poly line_2p_1 step + coeff_9 * z^9
    let t402 = circuit_mul(t337, t401); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t403 = circuit_mul(in26, in37); // Eval R step coeff_1 * z^1
    let t404 = circuit_add(in25, t403); // Eval R step + (coeff_1 * z^1)
    let t405 = circuit_mul(in27, t0); // Eval R step coeff_2 * z^2
    let t406 = circuit_add(t404, t405); // Eval R step + (coeff_2 * z^2)
    let t407 = circuit_mul(in28, t1); // Eval R step coeff_3 * z^3
    let t408 = circuit_add(t406, t407); // Eval R step + (coeff_3 * z^3)
    let t409 = circuit_mul(in29, t2); // Eval R step coeff_4 * z^4
    let t410 = circuit_add(t408, t409); // Eval R step + (coeff_4 * z^4)
    let t411 = circuit_mul(in30, t3); // Eval R step coeff_5 * z^5
    let t412 = circuit_add(t410, t411); // Eval R step + (coeff_5 * z^5)
    let t413 = circuit_mul(in31, t4); // Eval R step coeff_6 * z^6
    let t414 = circuit_add(t412, t413); // Eval R step + (coeff_6 * z^6)
    let t415 = circuit_mul(in32, t5); // Eval R step coeff_7 * z^7
    let t416 = circuit_add(t414, t415); // Eval R step + (coeff_7 * z^7)
    let t417 = circuit_mul(in33, t6); // Eval R step coeff_8 * z^8
    let t418 = circuit_add(t416, t417); // Eval R step + (coeff_8 * z^8)
    let t419 = circuit_mul(in34, t7); // Eval R step coeff_9 * z^9
    let t420 = circuit_add(t418, t419); // Eval R step + (coeff_9 * z^9)
    let t421 = circuit_mul(in35, t8); // Eval R step coeff_10 * z^10
    let t422 = circuit_add(t420, t421); // Eval R step + (coeff_10 * z^10)
    let t423 = circuit_mul(in36, t9); // Eval R step coeff_11 * z^11
    let t424 = circuit_add(t422, t423); // Eval R step + (coeff_11 * z^11)
    let t425 = circuit_sub(t402, t424); // (Π(i,k) (Pk(z))) - Ri(z)
    let t426 = circuit_mul(t10, t425); // ci * ((Π(i,k) (Pk(z)) - Ri(z))
    let t427 = circuit_add(in23, t426); // LHS = LHS + ci * ((Π(i,k) (Pk(z)) - Ri(z))

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [32324006162389411176778628423, 57042285082623239461879769745, 3486998266802970665, 0]
    )
        .unwrap();

    let mut circuit_inputs = (
        t236, t237, t246, t247, t301, t302, t311, t312, t366, t367, t376, t377, t424, t427, t10,
    )
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
    let Q0: G2Point = G2Point {
        x0: outputs.get_output(t236),
        x1: outputs.get_output(t237),
        y0: outputs.get_output(t246),
        y1: outputs.get_output(t247)
    };
    let Q1: G2Point = G2Point {
        x0: outputs.get_output(t301),
        x1: outputs.get_output(t302),
        y0: outputs.get_output(t311),
        y1: outputs.get_output(t312)
    };
    let Q2: G2Point = G2Point {
        x0: outputs.get_output(t366),
        x1: outputs.get_output(t367),
        y0: outputs.get_output(t376),
        y1: outputs.get_output(t377)
    };
    let f_i_plus_one_of_z: u384 = outputs.get_output(t424);
    let lhs_i_plus_one: u384 = outputs.get_output(t427);
    let ci_plus_one: u384 = outputs.get_output(t10);
    return (Q0, Q1, Q2, f_i_plus_one_of_z, lhs_i_plus_one, ci_plus_one);
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
fn run_BN254_MP_CHECK_BIT0_LOOP_3_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    Q_0: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q_1: G2Point,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q_2: G2Point,
    lhs_i: u384,
    f_i_of_z: u384,
    f_i_plus_one: E12D,
    z: u384,
    ci: u384
) -> (G2Point, G2Point, G2Point, u384, u384, u384) {
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
    let t68 = circuit_mul(t62, in37); // Eval sparse poly line_0p_1 step coeff_1 * z^1
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
    let t133 = circuit_mul(t127, in37); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t134 = circuit_add(in4, t133); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t135 = circuit_mul(t130, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t136 = circuit_add(t134, t135); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t137 = circuit_mul(t131, t5); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t138 = circuit_add(t136, t137); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t139 = circuit_mul(t132, t7); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t140 = circuit_add(t138, t139); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t141 = circuit_mul(t76, t140); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t142 = circuit_add(in19, in20); // Doubling slope numerator start
    let t143 = circuit_sub(in19, in20);
    let t144 = circuit_mul(t142, t143);
    let t145 = circuit_mul(in19, in20);
    let t146 = circuit_mul(t144, in0);
    let t147 = circuit_mul(t145, in1); // Doubling slope numerator end
    let t148 = circuit_add(in21, in21); // Fp2 add coeff 0/1
    let t149 = circuit_add(in22, in22); // Fp2 add coeff 1/1
    let t150 = circuit_mul(t148, t148); // Fp2 Div x/y start : Fp2 Inv y start
    let t151 = circuit_mul(t149, t149);
    let t152 = circuit_add(t150, t151);
    let t153 = circuit_inverse(t152);
    let t154 = circuit_mul(t148, t153); // Fp2 Inv y real part end
    let t155 = circuit_mul(t149, t153);
    let t156 = circuit_sub(in2, t155); // Fp2 Inv y imag part end
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
    let t198 = circuit_mul(t192, in37); // Eval sparse poly line_2p_1 step coeff_1 * z^1
    let t199 = circuit_add(in4, t198); // Eval sparse poly line_2p_1 step + coeff_1 * z^1
    let t200 = circuit_mul(t195, t1); // Eval sparse poly line_2p_1 step coeff_3 * z^3
    let t201 = circuit_add(t199, t200); // Eval sparse poly line_2p_1 step + coeff_3 * z^3
    let t202 = circuit_mul(t196, t5); // Eval sparse poly line_2p_1 step coeff_7 * z^7
    let t203 = circuit_add(t201, t202); // Eval sparse poly line_2p_1 step + coeff_7 * z^7
    let t204 = circuit_mul(t197, t7); // Eval sparse poly line_2p_1 step coeff_9 * z^9
    let t205 = circuit_add(t203, t204); // Eval sparse poly line_2p_1 step + coeff_9 * z^9
    let t206 = circuit_mul(t141, t205); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t207 = circuit_mul(in26, in37); // Eval R step coeff_1 * z^1
    let t208 = circuit_add(in25, t207); // Eval R step + (coeff_1 * z^1)
    let t209 = circuit_mul(in27, t0); // Eval R step coeff_2 * z^2
    let t210 = circuit_add(t208, t209); // Eval R step + (coeff_2 * z^2)
    let t211 = circuit_mul(in28, t1); // Eval R step coeff_3 * z^3
    let t212 = circuit_add(t210, t211); // Eval R step + (coeff_3 * z^3)
    let t213 = circuit_mul(in29, t2); // Eval R step coeff_4 * z^4
    let t214 = circuit_add(t212, t213); // Eval R step + (coeff_4 * z^4)
    let t215 = circuit_mul(in30, t3); // Eval R step coeff_5 * z^5
    let t216 = circuit_add(t214, t215); // Eval R step + (coeff_5 * z^5)
    let t217 = circuit_mul(in31, t4); // Eval R step coeff_6 * z^6
    let t218 = circuit_add(t216, t217); // Eval R step + (coeff_6 * z^6)
    let t219 = circuit_mul(in32, t5); // Eval R step coeff_7 * z^7
    let t220 = circuit_add(t218, t219); // Eval R step + (coeff_7 * z^7)
    let t221 = circuit_mul(in33, t6); // Eval R step coeff_8 * z^8
    let t222 = circuit_add(t220, t221); // Eval R step + (coeff_8 * z^8)
    let t223 = circuit_mul(in34, t7); // Eval R step coeff_9 * z^9
    let t224 = circuit_add(t222, t223); // Eval R step + (coeff_9 * z^9)
    let t225 = circuit_mul(in35, t8); // Eval R step coeff_10 * z^10
    let t226 = circuit_add(t224, t225); // Eval R step + (coeff_10 * z^10)
    let t227 = circuit_mul(in36, t9); // Eval R step coeff_11 * z^11
    let t228 = circuit_add(t226, t227); // Eval R step + (coeff_11 * z^11)
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
fn run_BN254_MP_CHECK_BIT1_LOOP_3_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    Q_0: G2Point,
    Q_or_Q_neg_0: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q_1: G2Point,
    Q_or_Q_neg_1: G2Point,
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
) -> (G2Point, G2Point, G2Point, u384, u384, u384) {
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
    let t110 = circuit_mul(t96, in48); // Eval sparse poly line_0p_1 step coeff_1 * z^1
    let t111 = circuit_add(in2, t110); // Eval sparse poly line_0p_1 step + coeff_1 * z^1
    let t112 = circuit_mul(t99, t1); // Eval sparse poly line_0p_1 step coeff_3 * z^3
    let t113 = circuit_add(t111, t112); // Eval sparse poly line_0p_1 step + coeff_3 * z^3
    let t114 = circuit_mul(t100, t5); // Eval sparse poly line_0p_1 step coeff_7 * z^7
    let t115 = circuit_add(t113, t114); // Eval sparse poly line_0p_1 step + coeff_7 * z^7
    let t116 = circuit_mul(t101, t7); // Eval sparse poly line_0p_1 step coeff_9 * z^9
    let t117 = circuit_add(t115, t116); // Eval sparse poly line_0p_1 step + coeff_9 * z^9
    let t118 = circuit_mul(t11, t117); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_0(z)
    let t119 = circuit_mul(t104, in48); // Eval sparse poly line_0p_2 step coeff_1 * z^1
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
    let t226 = circuit_mul(t212, in48); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t227 = circuit_add(in2, t226); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t228 = circuit_mul(t215, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t229 = circuit_add(t227, t228); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t230 = circuit_mul(t216, t5); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t231 = circuit_add(t229, t230); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t232 = circuit_mul(t217, t7); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t233 = circuit_add(t231, t232); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t234 = circuit_mul(t127, t233); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
    let t235 = circuit_mul(t220, in48); // Eval sparse poly line_1p_2 step coeff_1 * z^1
    let t236 = circuit_add(in2, t235); // Eval sparse poly line_1p_2 step + coeff_1 * z^1
    let t237 = circuit_mul(t223, t1); // Eval sparse poly line_1p_2 step coeff_3 * z^3
    let t238 = circuit_add(t236, t237); // Eval sparse poly line_1p_2 step + coeff_3 * z^3
    let t239 = circuit_mul(t224, t5); // Eval sparse poly line_1p_2 step coeff_7 * z^7
    let t240 = circuit_add(t238, t239); // Eval sparse poly line_1p_2 step + coeff_7 * z^7
    let t241 = circuit_mul(t225, t7); // Eval sparse poly line_1p_2 step coeff_9 * z^9
    let t242 = circuit_add(t240, t241); // Eval sparse poly line_1p_2 step + coeff_9 * z^9
    let t243 = circuit_mul(t234, t242); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_1(z)
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
    let t278 = circuit_add(in27, in27); // Fp2 add coeff 0/1
    let t279 = circuit_add(in28, in28); // Fp2 add coeff 1/1
    let t280 = circuit_sub(t268, in25); // Fp2 sub coeff 0/1
    let t281 = circuit_sub(t269, in26); // Fp2 sub coeff 1/1
    let t282 = circuit_mul(t280, t280); // Fp2 Div x/y start : Fp2 Inv y start
    let t283 = circuit_mul(t281, t281);
    let t284 = circuit_add(t282, t283);
    let t285 = circuit_inverse(t284);
    let t286 = circuit_mul(t280, t285); // Fp2 Inv y real part end
    let t287 = circuit_mul(t281, t285);
    let t288 = circuit_sub(in0, t287); // Fp2 Inv y imag part end
    let t289 = circuit_mul(t278, t286); // Fp2 mul start
    let t290 = circuit_mul(t279, t288);
    let t291 = circuit_sub(t289, t290); // Fp2 mul real part end
    let t292 = circuit_mul(t278, t288);
    let t293 = circuit_mul(t279, t286);
    let t294 = circuit_add(t292, t293); // Fp2 mul imag part end
    let t295 = circuit_add(t257, t291); // Fp2 add coeff 0/1
    let t296 = circuit_add(t260, t294); // Fp2 add coeff 1/1
    let t297 = circuit_sub(in0, t295); // Fp2 neg coeff 0/1
    let t298 = circuit_sub(in0, t296); // Fp2 neg coeff 1/1
    let t299 = circuit_add(t297, t298);
    let t300 = circuit_sub(t297, t298);
    let t301 = circuit_mul(t299, t300);
    let t302 = circuit_mul(t297, t298);
    let t303 = circuit_add(t302, t302);
    let t304 = circuit_sub(t301, in25); // Fp2 sub coeff 0/1
    let t305 = circuit_sub(t303, in26); // Fp2 sub coeff 1/1
    let t306 = circuit_sub(t304, t268); // Fp2 sub coeff 0/1
    let t307 = circuit_sub(t305, t269); // Fp2 sub coeff 1/1
    let t308 = circuit_sub(in25, t306); // Fp2 sub coeff 0/1
    let t309 = circuit_sub(in26, t307); // Fp2 sub coeff 1/1
    let t310 = circuit_mul(t297, t308); // Fp2 mul start
    let t311 = circuit_mul(t298, t309);
    let t312 = circuit_sub(t310, t311); // Fp2 mul real part end
    let t313 = circuit_mul(t297, t309);
    let t314 = circuit_mul(t298, t308);
    let t315 = circuit_add(t313, t314); // Fp2 mul imag part end
    let t316 = circuit_sub(t312, in27); // Fp2 sub coeff 0/1
    let t317 = circuit_sub(t315, in28); // Fp2 sub coeff 1/1
    let t318 = circuit_mul(t297, in25); // Fp2 mul start
    let t319 = circuit_mul(t298, in26);
    let t320 = circuit_sub(t318, t319); // Fp2 mul real part end
    let t321 = circuit_mul(t297, in26);
    let t322 = circuit_mul(t298, in25);
    let t323 = circuit_add(t321, t322); // Fp2 mul imag part end
    let t324 = circuit_sub(t320, in27); // Fp2 sub coeff 0/1
    let t325 = circuit_sub(t323, in28); // Fp2 sub coeff 1/1
    let t326 = circuit_mul(in1, t260);
    let t327 = circuit_add(t257, t326);
    let t328 = circuit_mul(t327, in24);
    let t329 = circuit_mul(in1, t277);
    let t330 = circuit_add(t276, t329);
    let t331 = circuit_mul(t330, in23);
    let t332 = circuit_mul(t260, in24);
    let t333 = circuit_mul(t277, in23);
    let t334 = circuit_mul(in1, t298);
    let t335 = circuit_add(t297, t334);
    let t336 = circuit_mul(t335, in24);
    let t337 = circuit_mul(in1, t325);
    let t338 = circuit_add(t324, t337);
    let t339 = circuit_mul(t338, in23);
    let t340 = circuit_mul(t298, in24);
    let t341 = circuit_mul(t325, in23);
    let t342 = circuit_mul(t328, in48); // Eval sparse poly line_2p_1 step coeff_1 * z^1
    let t343 = circuit_add(in2, t342); // Eval sparse poly line_2p_1 step + coeff_1 * z^1
    let t344 = circuit_mul(t331, t1); // Eval sparse poly line_2p_1 step coeff_3 * z^3
    let t345 = circuit_add(t343, t344); // Eval sparse poly line_2p_1 step + coeff_3 * z^3
    let t346 = circuit_mul(t332, t5); // Eval sparse poly line_2p_1 step coeff_7 * z^7
    let t347 = circuit_add(t345, t346); // Eval sparse poly line_2p_1 step + coeff_7 * z^7
    let t348 = circuit_mul(t333, t7); // Eval sparse poly line_2p_1 step coeff_9 * z^9
    let t349 = circuit_add(t347, t348); // Eval sparse poly line_2p_1 step + coeff_9 * z^9
    let t350 = circuit_mul(t243, t349); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t351 = circuit_mul(t336, in48); // Eval sparse poly line_2p_2 step coeff_1 * z^1
    let t352 = circuit_add(in2, t351); // Eval sparse poly line_2p_2 step + coeff_1 * z^1
    let t353 = circuit_mul(t339, t1); // Eval sparse poly line_2p_2 step coeff_3 * z^3
    let t354 = circuit_add(t352, t353); // Eval sparse poly line_2p_2 step + coeff_3 * z^3
    let t355 = circuit_mul(t340, t5); // Eval sparse poly line_2p_2 step coeff_7 * z^7
    let t356 = circuit_add(t354, t355); // Eval sparse poly line_2p_2 step + coeff_7 * z^7
    let t357 = circuit_mul(t341, t7); // Eval sparse poly line_2p_2 step coeff_9 * z^9
    let t358 = circuit_add(t356, t357); // Eval sparse poly line_2p_2 step + coeff_9 * z^9
    let t359 = circuit_mul(t350, t358); // Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_2(z)
    let t360 = circuit_mul(t359, in47);
    let t361 = circuit_mul(in36, in48); // Eval R step coeff_1 * z^1
    let t362 = circuit_add(in35, t361); // Eval R step + (coeff_1 * z^1)
    let t363 = circuit_mul(in37, t0); // Eval R step coeff_2 * z^2
    let t364 = circuit_add(t362, t363); // Eval R step + (coeff_2 * z^2)
    let t365 = circuit_mul(in38, t1); // Eval R step coeff_3 * z^3
    let t366 = circuit_add(t364, t365); // Eval R step + (coeff_3 * z^3)
    let t367 = circuit_mul(in39, t2); // Eval R step coeff_4 * z^4
    let t368 = circuit_add(t366, t367); // Eval R step + (coeff_4 * z^4)
    let t369 = circuit_mul(in40, t3); // Eval R step coeff_5 * z^5
    let t370 = circuit_add(t368, t369); // Eval R step + (coeff_5 * z^5)
    let t371 = circuit_mul(in41, t4); // Eval R step coeff_6 * z^6
    let t372 = circuit_add(t370, t371); // Eval R step + (coeff_6 * z^6)
    let t373 = circuit_mul(in42, t5); // Eval R step coeff_7 * z^7
    let t374 = circuit_add(t372, t373); // Eval R step + (coeff_7 * z^7)
    let t375 = circuit_mul(in43, t6); // Eval R step coeff_8 * z^8
    let t376 = circuit_add(t374, t375); // Eval R step + (coeff_8 * z^8)
    let t377 = circuit_mul(in44, t7); // Eval R step coeff_9 * z^9
    let t378 = circuit_add(t376, t377); // Eval R step + (coeff_9 * z^9)
    let t379 = circuit_mul(in45, t8); // Eval R step coeff_10 * z^10
    let t380 = circuit_add(t378, t379); // Eval R step + (coeff_10 * z^10)
    let t381 = circuit_mul(in46, t9); // Eval R step coeff_11 * z^11
    let t382 = circuit_add(t380, t381); // Eval R step + (coeff_11 * z^11)
    let t383 = circuit_sub(t360, t382); // (Π(i,k) (Pk(z))) - Ri(z)
    let t384 = circuit_mul(t10, t383); // ci * ((Π(i,k) (Pk(z)) - Ri(z))
    let t385 = circuit_add(in33, t384); // LHS = LHS + ci * ((Π(i,k) (Pk(z)) - Ri(z))

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [32324006162389411176778628423, 57042285082623239461879769745, 3486998266802970665, 0]
    )
        .unwrap();

    let mut circuit_inputs = (
        t74, t75, t84, t85, t190, t191, t200, t201, t306, t307, t316, t317, t382, t385, t10,
    )
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
    let Q2: G2Point = G2Point {
        x0: outputs.get_output(t306),
        x1: outputs.get_output(t307),
        y0: outputs.get_output(t316),
        y1: outputs.get_output(t317)
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
    let t158 = circuit_sub(in6, in11);
    let t159 = circuit_sub(in6, in13);
    let t160 = circuit_mul(in10, in0); // Fp2 mul start
    let t161 = circuit_mul(t158, in1);
    let t162 = circuit_sub(t160, t161); // Fp2 mul real part end
    let t163 = circuit_mul(in10, in1);
    let t164 = circuit_mul(t158, in0);
    let t165 = circuit_add(t163, t164); // Fp2 mul imag part end
    let t166 = circuit_mul(in12, in2); // Fp2 mul start
    let t167 = circuit_mul(t159, in3);
    let t168 = circuit_sub(t166, t167); // Fp2 mul real part end
    let t169 = circuit_mul(in12, in3);
    let t170 = circuit_mul(t159, in2);
    let t171 = circuit_add(t169, t170); // Fp2 mul imag part end
    let t172 = circuit_mul(in10, in4); // Fp2 scalar mul coeff 0/1
    let t173 = circuit_mul(in11, in4); // Fp2 scalar mul coeff 1/1
    let t174 = circuit_mul(in12, in5); // Fp2 scalar mul coeff 0/1
    let t175 = circuit_mul(in13, in5); // Fp2 scalar mul coeff 1/1
    let t176 = circuit_sub(in18, t168); // Fp2 sub coeff 0/1
    let t177 = circuit_sub(in19, t171); // Fp2 sub coeff 1/1
    let t178 = circuit_sub(in16, t162); // Fp2 sub coeff 0/1
    let t179 = circuit_sub(in17, t165); // Fp2 sub coeff 1/1
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
    let t198 = circuit_add(in16, t162); // Fp2 add coeff 0/1
    let t199 = circuit_add(in17, t165); // Fp2 add coeff 1/1
    let t200 = circuit_sub(t195, t198); // Fp2 sub coeff 0/1
    let t201 = circuit_sub(t197, t199); // Fp2 sub coeff 1/1
    let t202 = circuit_sub(in16, t200); // Fp2 sub coeff 0/1
    let t203 = circuit_sub(in17, t201); // Fp2 sub coeff 1/1
    let t204 = circuit_mul(t189, t202); // Fp2 mul start
    let t205 = circuit_mul(t192, t203);
    let t206 = circuit_sub(t204, t205); // Fp2 mul real part end
    let t207 = circuit_mul(t189, t203);
    let t208 = circuit_mul(t192, t202);
    let t209 = circuit_add(t207, t208); // Fp2 mul imag part end
    let t210 = circuit_sub(t206, in18); // Fp2 sub coeff 0/1
    let t211 = circuit_sub(t209, in19); // Fp2 sub coeff 1/1
    let t212 = circuit_mul(t189, in16); // Fp2 mul start
    let t213 = circuit_mul(t192, in17);
    let t214 = circuit_sub(t212, t213); // Fp2 mul real part end
    let t215 = circuit_mul(t189, in17);
    let t216 = circuit_mul(t192, in16);
    let t217 = circuit_add(t215, t216); // Fp2 mul imag part end
    let t218 = circuit_sub(t214, in18); // Fp2 sub coeff 0/1
    let t219 = circuit_sub(t217, in19); // Fp2 sub coeff 1/1
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
    let t245 = circuit_sub(in6, in21);
    let t246 = circuit_sub(in6, in23);
    let t247 = circuit_mul(in20, in0); // Fp2 mul start
    let t248 = circuit_mul(t245, in1);
    let t249 = circuit_sub(t247, t248); // Fp2 mul real part end
    let t250 = circuit_mul(in20, in1);
    let t251 = circuit_mul(t245, in0);
    let t252 = circuit_add(t250, t251); // Fp2 mul imag part end
    let t253 = circuit_mul(in22, in2); // Fp2 mul start
    let t254 = circuit_mul(t246, in3);
    let t255 = circuit_sub(t253, t254); // Fp2 mul real part end
    let t256 = circuit_mul(in22, in3);
    let t257 = circuit_mul(t246, in2);
    let t258 = circuit_add(t256, t257); // Fp2 mul imag part end
    let t259 = circuit_mul(in20, in4); // Fp2 scalar mul coeff 0/1
    let t260 = circuit_mul(in21, in4); // Fp2 scalar mul coeff 1/1
    let t261 = circuit_mul(in22, in5); // Fp2 scalar mul coeff 0/1
    let t262 = circuit_mul(in23, in5); // Fp2 scalar mul coeff 1/1
    let t263 = circuit_sub(in28, t255); // Fp2 sub coeff 0/1
    let t264 = circuit_sub(in29, t258); // Fp2 sub coeff 1/1
    let t265 = circuit_sub(in26, t249); // Fp2 sub coeff 0/1
    let t266 = circuit_sub(in27, t252); // Fp2 sub coeff 1/1
    let t267 = circuit_mul(t265, t265); // Fp2 Div x/y start : Fp2 Inv y start
    let t268 = circuit_mul(t266, t266);
    let t269 = circuit_add(t267, t268);
    let t270 = circuit_inverse(t269);
    let t271 = circuit_mul(t265, t270); // Fp2 Inv y real part end
    let t272 = circuit_mul(t266, t270);
    let t273 = circuit_sub(in6, t272); // Fp2 Inv y imag part end
    let t274 = circuit_mul(t263, t271); // Fp2 mul start
    let t275 = circuit_mul(t264, t273);
    let t276 = circuit_sub(t274, t275); // Fp2 mul real part end
    let t277 = circuit_mul(t263, t273);
    let t278 = circuit_mul(t264, t271);
    let t279 = circuit_add(t277, t278); // Fp2 mul imag part end
    let t280 = circuit_add(t276, t279);
    let t281 = circuit_sub(t276, t279);
    let t282 = circuit_mul(t280, t281);
    let t283 = circuit_mul(t276, t279);
    let t284 = circuit_add(t283, t283);
    let t285 = circuit_add(in26, t249); // Fp2 add coeff 0/1
    let t286 = circuit_add(in27, t252); // Fp2 add coeff 1/1
    let t287 = circuit_sub(t282, t285); // Fp2 sub coeff 0/1
    let t288 = circuit_sub(t284, t286); // Fp2 sub coeff 1/1
    let t289 = circuit_sub(in26, t287); // Fp2 sub coeff 0/1
    let t290 = circuit_sub(in27, t288); // Fp2 sub coeff 1/1
    let t291 = circuit_mul(t276, t289); // Fp2 mul start
    let t292 = circuit_mul(t279, t290);
    let t293 = circuit_sub(t291, t292); // Fp2 mul real part end
    let t294 = circuit_mul(t276, t290);
    let t295 = circuit_mul(t279, t289);
    let t296 = circuit_add(t294, t295); // Fp2 mul imag part end
    let t297 = circuit_sub(t293, in28); // Fp2 sub coeff 0/1
    let t298 = circuit_sub(t296, in29); // Fp2 sub coeff 1/1
    let t299 = circuit_mul(t276, in26); // Fp2 mul start
    let t300 = circuit_mul(t279, in27);
    let t301 = circuit_sub(t299, t300); // Fp2 mul real part end
    let t302 = circuit_mul(t276, in27);
    let t303 = circuit_mul(t279, in26);
    let t304 = circuit_add(t302, t303); // Fp2 mul imag part end
    let t305 = circuit_sub(t301, in28); // Fp2 sub coeff 0/1
    let t306 = circuit_sub(t304, in29); // Fp2 sub coeff 1/1
    let t307 = circuit_sub(t297, t261); // Fp2 sub coeff 0/1
    let t308 = circuit_sub(t298, t262); // Fp2 sub coeff 1/1
    let t309 = circuit_sub(t287, t259); // Fp2 sub coeff 0/1
    let t310 = circuit_sub(t288, t260); // Fp2 sub coeff 1/1
    let t311 = circuit_mul(t309, t309); // Fp2 Div x/y start : Fp2 Inv y start
    let t312 = circuit_mul(t310, t310);
    let t313 = circuit_add(t311, t312);
    let t314 = circuit_inverse(t313);
    let t315 = circuit_mul(t309, t314); // Fp2 Inv y real part end
    let t316 = circuit_mul(t310, t314);
    let t317 = circuit_sub(in6, t316); // Fp2 Inv y imag part end
    let t318 = circuit_mul(t307, t315); // Fp2 mul start
    let t319 = circuit_mul(t308, t317);
    let t320 = circuit_sub(t318, t319); // Fp2 mul real part end
    let t321 = circuit_mul(t307, t317);
    let t322 = circuit_mul(t308, t315);
    let t323 = circuit_add(t321, t322); // Fp2 mul imag part end
    let t324 = circuit_mul(t320, t287); // Fp2 mul start
    let t325 = circuit_mul(t323, t288);
    let t326 = circuit_sub(t324, t325); // Fp2 mul real part end
    let t327 = circuit_mul(t320, t288);
    let t328 = circuit_mul(t323, t287);
    let t329 = circuit_add(t327, t328); // Fp2 mul imag part end
    let t330 = circuit_sub(t326, t297); // Fp2 sub coeff 0/1
    let t331 = circuit_sub(t329, t298); // Fp2 sub coeff 1/1
    let t332 = circuit_sub(in6, in31);
    let t333 = circuit_sub(in6, in33);
    let t334 = circuit_mul(in30, in0); // Fp2 mul start
    let t335 = circuit_mul(t332, in1);
    let t336 = circuit_sub(t334, t335); // Fp2 mul real part end
    let t337 = circuit_mul(in30, in1);
    let t338 = circuit_mul(t332, in0);
    let t339 = circuit_add(t337, t338); // Fp2 mul imag part end
    let t340 = circuit_mul(in32, in2); // Fp2 mul start
    let t341 = circuit_mul(t333, in3);
    let t342 = circuit_sub(t340, t341); // Fp2 mul real part end
    let t343 = circuit_mul(in32, in3);
    let t344 = circuit_mul(t333, in2);
    let t345 = circuit_add(t343, t344); // Fp2 mul imag part end
    let t346 = circuit_mul(in30, in4); // Fp2 scalar mul coeff 0/1
    let t347 = circuit_mul(in31, in4); // Fp2 scalar mul coeff 1/1
    let t348 = circuit_mul(in32, in5); // Fp2 scalar mul coeff 0/1
    let t349 = circuit_mul(in33, in5); // Fp2 scalar mul coeff 1/1
    let t350 = circuit_sub(in38, t342); // Fp2 sub coeff 0/1
    let t351 = circuit_sub(in39, t345); // Fp2 sub coeff 1/1
    let t352 = circuit_sub(in36, t336); // Fp2 sub coeff 0/1
    let t353 = circuit_sub(in37, t339); // Fp2 sub coeff 1/1
    let t354 = circuit_mul(t352, t352); // Fp2 Div x/y start : Fp2 Inv y start
    let t355 = circuit_mul(t353, t353);
    let t356 = circuit_add(t354, t355);
    let t357 = circuit_inverse(t356);
    let t358 = circuit_mul(t352, t357); // Fp2 Inv y real part end
    let t359 = circuit_mul(t353, t357);
    let t360 = circuit_sub(in6, t359); // Fp2 Inv y imag part end
    let t361 = circuit_mul(t350, t358); // Fp2 mul start
    let t362 = circuit_mul(t351, t360);
    let t363 = circuit_sub(t361, t362); // Fp2 mul real part end
    let t364 = circuit_mul(t350, t360);
    let t365 = circuit_mul(t351, t358);
    let t366 = circuit_add(t364, t365); // Fp2 mul imag part end
    let t367 = circuit_add(t363, t366);
    let t368 = circuit_sub(t363, t366);
    let t369 = circuit_mul(t367, t368);
    let t370 = circuit_mul(t363, t366);
    let t371 = circuit_add(t370, t370);
    let t372 = circuit_add(in36, t336); // Fp2 add coeff 0/1
    let t373 = circuit_add(in37, t339); // Fp2 add coeff 1/1
    let t374 = circuit_sub(t369, t372); // Fp2 sub coeff 0/1
    let t375 = circuit_sub(t371, t373); // Fp2 sub coeff 1/1
    let t376 = circuit_sub(in36, t374); // Fp2 sub coeff 0/1
    let t377 = circuit_sub(in37, t375); // Fp2 sub coeff 1/1
    let t378 = circuit_mul(t363, t376); // Fp2 mul start
    let t379 = circuit_mul(t366, t377);
    let t380 = circuit_sub(t378, t379); // Fp2 mul real part end
    let t381 = circuit_mul(t363, t377);
    let t382 = circuit_mul(t366, t376);
    let t383 = circuit_add(t381, t382); // Fp2 mul imag part end
    let t384 = circuit_sub(t380, in38); // Fp2 sub coeff 0/1
    let t385 = circuit_sub(t383, in39); // Fp2 sub coeff 1/1
    let t386 = circuit_mul(t363, in36); // Fp2 mul start
    let t387 = circuit_mul(t366, in37);
    let t388 = circuit_sub(t386, t387); // Fp2 mul real part end
    let t389 = circuit_mul(t363, in37);
    let t390 = circuit_mul(t366, in36);
    let t391 = circuit_add(t389, t390); // Fp2 mul imag part end
    let t392 = circuit_sub(t388, in38); // Fp2 sub coeff 0/1
    let t393 = circuit_sub(t391, in39); // Fp2 sub coeff 1/1
    let t394 = circuit_sub(t384, t348); // Fp2 sub coeff 0/1
    let t395 = circuit_sub(t385, t349); // Fp2 sub coeff 1/1
    let t396 = circuit_sub(t374, t346); // Fp2 sub coeff 0/1
    let t397 = circuit_sub(t375, t347); // Fp2 sub coeff 1/1
    let t398 = circuit_mul(t396, t396); // Fp2 Div x/y start : Fp2 Inv y start
    let t399 = circuit_mul(t397, t397);
    let t400 = circuit_add(t398, t399);
    let t401 = circuit_inverse(t400);
    let t402 = circuit_mul(t396, t401); // Fp2 Inv y real part end
    let t403 = circuit_mul(t397, t401);
    let t404 = circuit_sub(in6, t403); // Fp2 Inv y imag part end
    let t405 = circuit_mul(t394, t402); // Fp2 mul start
    let t406 = circuit_mul(t395, t404);
    let t407 = circuit_sub(t405, t406); // Fp2 mul real part end
    let t408 = circuit_mul(t394, t404);
    let t409 = circuit_mul(t395, t402);
    let t410 = circuit_add(t408, t409); // Fp2 mul imag part end
    let t411 = circuit_mul(t407, t374); // Fp2 mul start
    let t412 = circuit_mul(t410, t375);
    let t413 = circuit_sub(t411, t412); // Fp2 mul real part end
    let t414 = circuit_mul(t407, t375);
    let t415 = circuit_mul(t410, t374);
    let t416 = circuit_add(t414, t415); // Fp2 mul imag part end
    let t417 = circuit_sub(t413, t384); // Fp2 sub coeff 0/1
    let t418 = circuit_sub(t416, t385); // Fp2 sub coeff 1/1
    let t419 = circuit_mul(in7, t192);
    let t420 = circuit_add(t189, t419);
    let t421 = circuit_mul(t420, in15);
    let t422 = circuit_mul(in7, t219);
    let t423 = circuit_add(t218, t422);
    let t424 = circuit_mul(t423, in14);
    let t425 = circuit_mul(t192, in15);
    let t426 = circuit_mul(t219, in14);
    let t427 = circuit_mul(in7, t236);
    let t428 = circuit_add(t233, t427);
    let t429 = circuit_mul(t428, in15);
    let t430 = circuit_mul(in7, t244);
    let t431 = circuit_add(t243, t430);
    let t432 = circuit_mul(t431, in14);
    let t433 = circuit_mul(t236, in15);
    let t434 = circuit_mul(t244, in14);
    let t435 = circuit_mul(in7, t279);
    let t436 = circuit_add(t276, t435);
    let t437 = circuit_mul(t436, in25);
    let t438 = circuit_mul(in7, t306);
    let t439 = circuit_add(t305, t438);
    let t440 = circuit_mul(t439, in24);
    let t441 = circuit_mul(t279, in25);
    let t442 = circuit_mul(t306, in24);
    let t443 = circuit_mul(in7, t323);
    let t444 = circuit_add(t320, t443);
    let t445 = circuit_mul(t444, in25);
    let t446 = circuit_mul(in7, t331);
    let t447 = circuit_add(t330, t446);
    let t448 = circuit_mul(t447, in24);
    let t449 = circuit_mul(t323, in25);
    let t450 = circuit_mul(t331, in24);
    let t451 = circuit_mul(in7, t366);
    let t452 = circuit_add(t363, t451);
    let t453 = circuit_mul(t452, in35);
    let t454 = circuit_mul(in7, t393);
    let t455 = circuit_add(t392, t454);
    let t456 = circuit_mul(t455, in34);
    let t457 = circuit_mul(t366, in35);
    let t458 = circuit_mul(t393, in34);
    let t459 = circuit_mul(in7, t410);
    let t460 = circuit_add(t407, t459);
    let t461 = circuit_mul(t460, in35);
    let t462 = circuit_mul(in7, t418);
    let t463 = circuit_add(t417, t462);
    let t464 = circuit_mul(t463, in34);
    let t465 = circuit_mul(t410, in35);
    let t466 = circuit_mul(t418, in34);
    let t467 = circuit_mul(t421, in66); // Eval sparse poly line_2 step coeff_1 * z^1
    let t468 = circuit_add(in5, t467); // Eval sparse poly line_2 step + coeff_1 * z^1
    let t469 = circuit_mul(t424, t1); // Eval sparse poly line_2 step coeff_3 * z^3
    let t470 = circuit_add(t468, t469); // Eval sparse poly line_2 step + coeff_3 * z^3
    let t471 = circuit_mul(t425, t5); // Eval sparse poly line_2 step coeff_7 * z^7
    let t472 = circuit_add(t470, t471); // Eval sparse poly line_2 step + coeff_7 * z^7
    let t473 = circuit_mul(t426, t7); // Eval sparse poly line_2 step coeff_9 * z^9
    let t474 = circuit_add(t472, t473); // Eval sparse poly line_2 step + coeff_9 * z^9
    let t475 = circuit_mul(in71, t474);
    let t476 = circuit_mul(t429, in66); // Eval sparse poly line_2 step coeff_1 * z^1
    let t477 = circuit_add(in5, t476); // Eval sparse poly line_2 step + coeff_1 * z^1
    let t478 = circuit_mul(t432, t1); // Eval sparse poly line_2 step coeff_3 * z^3
    let t479 = circuit_add(t477, t478); // Eval sparse poly line_2 step + coeff_3 * z^3
    let t480 = circuit_mul(t433, t5); // Eval sparse poly line_2 step coeff_7 * z^7
    let t481 = circuit_add(t479, t480); // Eval sparse poly line_2 step + coeff_7 * z^7
    let t482 = circuit_mul(t434, t7); // Eval sparse poly line_2 step coeff_9 * z^9
    let t483 = circuit_add(t481, t482); // Eval sparse poly line_2 step + coeff_9 * z^9
    let t484 = circuit_mul(t475, t483);
    let t485 = circuit_mul(t437, in66); // Eval sparse poly line_2 step coeff_1 * z^1
    let t486 = circuit_add(in5, t485); // Eval sparse poly line_2 step + coeff_1 * z^1
    let t487 = circuit_mul(t440, t1); // Eval sparse poly line_2 step coeff_3 * z^3
    let t488 = circuit_add(t486, t487); // Eval sparse poly line_2 step + coeff_3 * z^3
    let t489 = circuit_mul(t441, t5); // Eval sparse poly line_2 step coeff_7 * z^7
    let t490 = circuit_add(t488, t489); // Eval sparse poly line_2 step + coeff_7 * z^7
    let t491 = circuit_mul(t442, t7); // Eval sparse poly line_2 step coeff_9 * z^9
    let t492 = circuit_add(t490, t491); // Eval sparse poly line_2 step + coeff_9 * z^9
    let t493 = circuit_mul(t484, t492);
    let t494 = circuit_mul(t445, in66); // Eval sparse poly line_2 step coeff_1 * z^1
    let t495 = circuit_add(in5, t494); // Eval sparse poly line_2 step + coeff_1 * z^1
    let t496 = circuit_mul(t448, t1); // Eval sparse poly line_2 step coeff_3 * z^3
    let t497 = circuit_add(t495, t496); // Eval sparse poly line_2 step + coeff_3 * z^3
    let t498 = circuit_mul(t449, t5); // Eval sparse poly line_2 step coeff_7 * z^7
    let t499 = circuit_add(t497, t498); // Eval sparse poly line_2 step + coeff_7 * z^7
    let t500 = circuit_mul(t450, t7); // Eval sparse poly line_2 step coeff_9 * z^9
    let t501 = circuit_add(t499, t500); // Eval sparse poly line_2 step + coeff_9 * z^9
    let t502 = circuit_mul(t493, t501);
    let t503 = circuit_mul(t453, in66); // Eval sparse poly line_2 step coeff_1 * z^1
    let t504 = circuit_add(in5, t503); // Eval sparse poly line_2 step + coeff_1 * z^1
    let t505 = circuit_mul(t456, t1); // Eval sparse poly line_2 step coeff_3 * z^3
    let t506 = circuit_add(t504, t505); // Eval sparse poly line_2 step + coeff_3 * z^3
    let t507 = circuit_mul(t457, t5); // Eval sparse poly line_2 step coeff_7 * z^7
    let t508 = circuit_add(t506, t507); // Eval sparse poly line_2 step + coeff_7 * z^7
    let t509 = circuit_mul(t458, t7); // Eval sparse poly line_2 step coeff_9 * z^9
    let t510 = circuit_add(t508, t509); // Eval sparse poly line_2 step + coeff_9 * z^9
    let t511 = circuit_mul(t502, t510);
    let t512 = circuit_mul(t461, in66); // Eval sparse poly line_2 step coeff_1 * z^1
    let t513 = circuit_add(in5, t512); // Eval sparse poly line_2 step + coeff_1 * z^1
    let t514 = circuit_mul(t464, t1); // Eval sparse poly line_2 step coeff_3 * z^3
    let t515 = circuit_add(t513, t514); // Eval sparse poly line_2 step + coeff_3 * z^3
    let t516 = circuit_mul(t465, t5); // Eval sparse poly line_2 step coeff_7 * z^7
    let t517 = circuit_add(t515, t516); // Eval sparse poly line_2 step + coeff_7 * z^7
    let t518 = circuit_mul(t466, t7); // Eval sparse poly line_2 step coeff_9 * z^9
    let t519 = circuit_add(t517, t518); // Eval sparse poly line_2 step + coeff_9 * z^9
    let t520 = circuit_mul(t511, t519);
    let t521 = circuit_sub(t520, t135);
    let t522 = circuit_mul(t112, t521); // c_n_minus_2 * ((Π(n-2,k) (Pk(z)) - R_n_minus_2(z))
    let t523 = circuit_mul(t135, in67);
    let t524 = circuit_mul(t523, in68);
    let t525 = circuit_mul(t524, in69);
    let t526 = circuit_mul(t525, in65);
    let t527 = circuit_sub(t526, t157);
    let t528 = circuit_mul(t113, t527); // c_n_minus_1 * ((Π(n-1,k) (Pk(z)) - R_n_minus_1(z))
    let t529 = circuit_add(in70, t522);
    let t530 = circuit_add(t529, t528);
    let t531 = circuit_mul(in73, in66); // Eval big_Q step coeff_1 * z^1
    let t532 = circuit_add(in72, t531); // Eval big_Q step + (coeff_1 * z^1)
    let t533 = circuit_mul(in74, t0); // Eval big_Q step coeff_2 * z^2
    let t534 = circuit_add(t532, t533); // Eval big_Q step + (coeff_2 * z^2)
    let t535 = circuit_mul(in75, t1); // Eval big_Q step coeff_3 * z^3
    let t536 = circuit_add(t534, t535); // Eval big_Q step + (coeff_3 * z^3)
    let t537 = circuit_mul(in76, t2); // Eval big_Q step coeff_4 * z^4
    let t538 = circuit_add(t536, t537); // Eval big_Q step + (coeff_4 * z^4)
    let t539 = circuit_mul(in77, t3); // Eval big_Q step coeff_5 * z^5
    let t540 = circuit_add(t538, t539); // Eval big_Q step + (coeff_5 * z^5)
    let t541 = circuit_mul(in78, t4); // Eval big_Q step coeff_6 * z^6
    let t542 = circuit_add(t540, t541); // Eval big_Q step + (coeff_6 * z^6)
    let t543 = circuit_mul(in79, t5); // Eval big_Q step coeff_7 * z^7
    let t544 = circuit_add(t542, t543); // Eval big_Q step + (coeff_7 * z^7)
    let t545 = circuit_mul(in80, t6); // Eval big_Q step coeff_8 * z^8
    let t546 = circuit_add(t544, t545); // Eval big_Q step + (coeff_8 * z^8)
    let t547 = circuit_mul(in81, t7); // Eval big_Q step coeff_9 * z^9
    let t548 = circuit_add(t546, t547); // Eval big_Q step + (coeff_9 * z^9)
    let t549 = circuit_mul(in82, t8); // Eval big_Q step coeff_10 * z^10
    let t550 = circuit_add(t548, t549); // Eval big_Q step + (coeff_10 * z^10)
    let t551 = circuit_mul(in83, t9); // Eval big_Q step coeff_11 * z^11
    let t552 = circuit_add(t550, t551); // Eval big_Q step + (coeff_11 * z^11)
    let t553 = circuit_mul(in84, t10); // Eval big_Q step coeff_12 * z^12
    let t554 = circuit_add(t552, t553); // Eval big_Q step + (coeff_12 * z^12)
    let t555 = circuit_mul(in85, t11); // Eval big_Q step coeff_13 * z^13
    let t556 = circuit_add(t554, t555); // Eval big_Q step + (coeff_13 * z^13)
    let t557 = circuit_mul(in86, t12); // Eval big_Q step coeff_14 * z^14
    let t558 = circuit_add(t556, t557); // Eval big_Q step + (coeff_14 * z^14)
    let t559 = circuit_mul(in87, t13); // Eval big_Q step coeff_15 * z^15
    let t560 = circuit_add(t558, t559); // Eval big_Q step + (coeff_15 * z^15)
    let t561 = circuit_mul(in88, t14); // Eval big_Q step coeff_16 * z^16
    let t562 = circuit_add(t560, t561); // Eval big_Q step + (coeff_16 * z^16)
    let t563 = circuit_mul(in89, t15); // Eval big_Q step coeff_17 * z^17
    let t564 = circuit_add(t562, t563); // Eval big_Q step + (coeff_17 * z^17)
    let t565 = circuit_mul(in90, t16); // Eval big_Q step coeff_18 * z^18
    let t566 = circuit_add(t564, t565); // Eval big_Q step + (coeff_18 * z^18)
    let t567 = circuit_mul(in91, t17); // Eval big_Q step coeff_19 * z^19
    let t568 = circuit_add(t566, t567); // Eval big_Q step + (coeff_19 * z^19)
    let t569 = circuit_mul(in92, t18); // Eval big_Q step coeff_20 * z^20
    let t570 = circuit_add(t568, t569); // Eval big_Q step + (coeff_20 * z^20)
    let t571 = circuit_mul(in93, t19); // Eval big_Q step coeff_21 * z^21
    let t572 = circuit_add(t570, t571); // Eval big_Q step + (coeff_21 * z^21)
    let t573 = circuit_mul(in94, t20); // Eval big_Q step coeff_22 * z^22
    let t574 = circuit_add(t572, t573); // Eval big_Q step + (coeff_22 * z^22)
    let t575 = circuit_mul(in95, t21); // Eval big_Q step coeff_23 * z^23
    let t576 = circuit_add(t574, t575); // Eval big_Q step + (coeff_23 * z^23)
    let t577 = circuit_mul(in96, t22); // Eval big_Q step coeff_24 * z^24
    let t578 = circuit_add(t576, t577); // Eval big_Q step + (coeff_24 * z^24)
    let t579 = circuit_mul(in97, t23); // Eval big_Q step coeff_25 * z^25
    let t580 = circuit_add(t578, t579); // Eval big_Q step + (coeff_25 * z^25)
    let t581 = circuit_mul(in98, t24); // Eval big_Q step coeff_26 * z^26
    let t582 = circuit_add(t580, t581); // Eval big_Q step + (coeff_26 * z^26)
    let t583 = circuit_mul(in99, t25); // Eval big_Q step coeff_27 * z^27
    let t584 = circuit_add(t582, t583); // Eval big_Q step + (coeff_27 * z^27)
    let t585 = circuit_mul(in100, t26); // Eval big_Q step coeff_28 * z^28
    let t586 = circuit_add(t584, t585); // Eval big_Q step + (coeff_28 * z^28)
    let t587 = circuit_mul(in101, t27); // Eval big_Q step coeff_29 * z^29
    let t588 = circuit_add(t586, t587); // Eval big_Q step + (coeff_29 * z^29)
    let t589 = circuit_mul(in102, t28); // Eval big_Q step coeff_30 * z^30
    let t590 = circuit_add(t588, t589); // Eval big_Q step + (coeff_30 * z^30)
    let t591 = circuit_mul(in103, t29); // Eval big_Q step coeff_31 * z^31
    let t592 = circuit_add(t590, t591); // Eval big_Q step + (coeff_31 * z^31)
    let t593 = circuit_mul(in104, t30); // Eval big_Q step coeff_32 * z^32
    let t594 = circuit_add(t592, t593); // Eval big_Q step + (coeff_32 * z^32)
    let t595 = circuit_mul(in105, t31); // Eval big_Q step coeff_33 * z^33
    let t596 = circuit_add(t594, t595); // Eval big_Q step + (coeff_33 * z^33)
    let t597 = circuit_mul(in106, t32); // Eval big_Q step coeff_34 * z^34
    let t598 = circuit_add(t596, t597); // Eval big_Q step + (coeff_34 * z^34)
    let t599 = circuit_mul(in107, t33); // Eval big_Q step coeff_35 * z^35
    let t600 = circuit_add(t598, t599); // Eval big_Q step + (coeff_35 * z^35)
    let t601 = circuit_mul(in108, t34); // Eval big_Q step coeff_36 * z^36
    let t602 = circuit_add(t600, t601); // Eval big_Q step + (coeff_36 * z^36)
    let t603 = circuit_mul(in109, t35); // Eval big_Q step coeff_37 * z^37
    let t604 = circuit_add(t602, t603); // Eval big_Q step + (coeff_37 * z^37)
    let t605 = circuit_mul(in110, t36); // Eval big_Q step coeff_38 * z^38
    let t606 = circuit_add(t604, t605); // Eval big_Q step + (coeff_38 * z^38)
    let t607 = circuit_mul(in111, t37); // Eval big_Q step coeff_39 * z^39
    let t608 = circuit_add(t606, t607); // Eval big_Q step + (coeff_39 * z^39)
    let t609 = circuit_mul(in112, t38); // Eval big_Q step coeff_40 * z^40
    let t610 = circuit_add(t608, t609); // Eval big_Q step + (coeff_40 * z^40)
    let t611 = circuit_mul(in113, t39); // Eval big_Q step coeff_41 * z^41
    let t612 = circuit_add(t610, t611); // Eval big_Q step + (coeff_41 * z^41)
    let t613 = circuit_mul(in114, t40); // Eval big_Q step coeff_42 * z^42
    let t614 = circuit_add(t612, t613); // Eval big_Q step + (coeff_42 * z^42)
    let t615 = circuit_mul(in115, t41); // Eval big_Q step coeff_43 * z^43
    let t616 = circuit_add(t614, t615); // Eval big_Q step + (coeff_43 * z^43)
    let t617 = circuit_mul(in116, t42); // Eval big_Q step coeff_44 * z^44
    let t618 = circuit_add(t616, t617); // Eval big_Q step + (coeff_44 * z^44)
    let t619 = circuit_mul(in117, t43); // Eval big_Q step coeff_45 * z^45
    let t620 = circuit_add(t618, t619); // Eval big_Q step + (coeff_45 * z^45)
    let t621 = circuit_mul(in118, t44); // Eval big_Q step coeff_46 * z^46
    let t622 = circuit_add(t620, t621); // Eval big_Q step + (coeff_46 * z^46)
    let t623 = circuit_mul(in119, t45); // Eval big_Q step coeff_47 * z^47
    let t624 = circuit_add(t622, t623); // Eval big_Q step + (coeff_47 * z^47)
    let t625 = circuit_mul(in120, t46); // Eval big_Q step coeff_48 * z^48
    let t626 = circuit_add(t624, t625); // Eval big_Q step + (coeff_48 * z^48)
    let t627 = circuit_mul(in121, t47); // Eval big_Q step coeff_49 * z^49
    let t628 = circuit_add(t626, t627); // Eval big_Q step + (coeff_49 * z^49)
    let t629 = circuit_mul(in122, t48); // Eval big_Q step coeff_50 * z^50
    let t630 = circuit_add(t628, t629); // Eval big_Q step + (coeff_50 * z^50)
    let t631 = circuit_mul(in123, t49); // Eval big_Q step coeff_51 * z^51
    let t632 = circuit_add(t630, t631); // Eval big_Q step + (coeff_51 * z^51)
    let t633 = circuit_mul(in124, t50); // Eval big_Q step coeff_52 * z^52
    let t634 = circuit_add(t632, t633); // Eval big_Q step + (coeff_52 * z^52)
    let t635 = circuit_mul(in125, t51); // Eval big_Q step coeff_53 * z^53
    let t636 = circuit_add(t634, t635); // Eval big_Q step + (coeff_53 * z^53)
    let t637 = circuit_mul(in126, t52); // Eval big_Q step coeff_54 * z^54
    let t638 = circuit_add(t636, t637); // Eval big_Q step + (coeff_54 * z^54)
    let t639 = circuit_mul(in127, t53); // Eval big_Q step coeff_55 * z^55
    let t640 = circuit_add(t638, t639); // Eval big_Q step + (coeff_55 * z^55)
    let t641 = circuit_mul(in128, t54); // Eval big_Q step coeff_56 * z^56
    let t642 = circuit_add(t640, t641); // Eval big_Q step + (coeff_56 * z^56)
    let t643 = circuit_mul(in129, t55); // Eval big_Q step coeff_57 * z^57
    let t644 = circuit_add(t642, t643); // Eval big_Q step + (coeff_57 * z^57)
    let t645 = circuit_mul(in130, t56); // Eval big_Q step coeff_58 * z^58
    let t646 = circuit_add(t644, t645); // Eval big_Q step + (coeff_58 * z^58)
    let t647 = circuit_mul(in131, t57); // Eval big_Q step coeff_59 * z^59
    let t648 = circuit_add(t646, t647); // Eval big_Q step + (coeff_59 * z^59)
    let t649 = circuit_mul(in132, t58); // Eval big_Q step coeff_60 * z^60
    let t650 = circuit_add(t648, t649); // Eval big_Q step + (coeff_60 * z^60)
    let t651 = circuit_mul(in133, t59); // Eval big_Q step coeff_61 * z^61
    let t652 = circuit_add(t650, t651); // Eval big_Q step + (coeff_61 * z^61)
    let t653 = circuit_mul(in134, t60); // Eval big_Q step coeff_62 * z^62
    let t654 = circuit_add(t652, t653); // Eval big_Q step + (coeff_62 * z^62)
    let t655 = circuit_mul(in135, t61); // Eval big_Q step coeff_63 * z^63
    let t656 = circuit_add(t654, t655); // Eval big_Q step + (coeff_63 * z^63)
    let t657 = circuit_mul(in136, t62); // Eval big_Q step coeff_64 * z^64
    let t658 = circuit_add(t656, t657); // Eval big_Q step + (coeff_64 * z^64)
    let t659 = circuit_mul(in137, t63); // Eval big_Q step coeff_65 * z^65
    let t660 = circuit_add(t658, t659); // Eval big_Q step + (coeff_65 * z^65)
    let t661 = circuit_mul(in138, t64); // Eval big_Q step coeff_66 * z^66
    let t662 = circuit_add(t660, t661); // Eval big_Q step + (coeff_66 * z^66)
    let t663 = circuit_mul(in139, t65); // Eval big_Q step coeff_67 * z^67
    let t664 = circuit_add(t662, t663); // Eval big_Q step + (coeff_67 * z^67)
    let t665 = circuit_mul(in140, t66); // Eval big_Q step coeff_68 * z^68
    let t666 = circuit_add(t664, t665); // Eval big_Q step + (coeff_68 * z^68)
    let t667 = circuit_mul(in141, t67); // Eval big_Q step coeff_69 * z^69
    let t668 = circuit_add(t666, t667); // Eval big_Q step + (coeff_69 * z^69)
    let t669 = circuit_mul(in142, t68); // Eval big_Q step coeff_70 * z^70
    let t670 = circuit_add(t668, t669); // Eval big_Q step + (coeff_70 * z^70)
    let t671 = circuit_mul(in143, t69); // Eval big_Q step coeff_71 * z^71
    let t672 = circuit_add(t670, t671); // Eval big_Q step + (coeff_71 * z^71)
    let t673 = circuit_mul(in144, t70); // Eval big_Q step coeff_72 * z^72
    let t674 = circuit_add(t672, t673); // Eval big_Q step + (coeff_72 * z^72)
    let t675 = circuit_mul(in145, t71); // Eval big_Q step coeff_73 * z^73
    let t676 = circuit_add(t674, t675); // Eval big_Q step + (coeff_73 * z^73)
    let t677 = circuit_mul(in146, t72); // Eval big_Q step coeff_74 * z^74
    let t678 = circuit_add(t676, t677); // Eval big_Q step + (coeff_74 * z^74)
    let t679 = circuit_mul(in147, t73); // Eval big_Q step coeff_75 * z^75
    let t680 = circuit_add(t678, t679); // Eval big_Q step + (coeff_75 * z^75)
    let t681 = circuit_mul(in148, t74); // Eval big_Q step coeff_76 * z^76
    let t682 = circuit_add(t680, t681); // Eval big_Q step + (coeff_76 * z^76)
    let t683 = circuit_mul(in149, t75); // Eval big_Q step coeff_77 * z^77
    let t684 = circuit_add(t682, t683); // Eval big_Q step + (coeff_77 * z^77)
    let t685 = circuit_mul(in150, t76); // Eval big_Q step coeff_78 * z^78
    let t686 = circuit_add(t684, t685); // Eval big_Q step + (coeff_78 * z^78)
    let t687 = circuit_mul(in151, t77); // Eval big_Q step coeff_79 * z^79
    let t688 = circuit_add(t686, t687); // Eval big_Q step + (coeff_79 * z^79)
    let t689 = circuit_mul(in152, t78); // Eval big_Q step coeff_80 * z^80
    let t690 = circuit_add(t688, t689); // Eval big_Q step + (coeff_80 * z^80)
    let t691 = circuit_mul(in153, t79); // Eval big_Q step coeff_81 * z^81
    let t692 = circuit_add(t690, t691); // Eval big_Q step + (coeff_81 * z^81)
    let t693 = circuit_mul(in154, t80); // Eval big_Q step coeff_82 * z^82
    let t694 = circuit_add(t692, t693); // Eval big_Q step + (coeff_82 * z^82)
    let t695 = circuit_mul(in155, t81); // Eval big_Q step coeff_83 * z^83
    let t696 = circuit_add(t694, t695); // Eval big_Q step + (coeff_83 * z^83)
    let t697 = circuit_mul(in156, t82); // Eval big_Q step coeff_84 * z^84
    let t698 = circuit_add(t696, t697); // Eval big_Q step + (coeff_84 * z^84)
    let t699 = circuit_mul(in157, t83); // Eval big_Q step coeff_85 * z^85
    let t700 = circuit_add(t698, t699); // Eval big_Q step + (coeff_85 * z^85)
    let t701 = circuit_mul(in158, t84); // Eval big_Q step coeff_86 * z^86
    let t702 = circuit_add(t700, t701); // Eval big_Q step + (coeff_86 * z^86)
    let t703 = circuit_mul(in159, t85); // Eval big_Q step coeff_87 * z^87
    let t704 = circuit_add(t702, t703); // Eval big_Q step + (coeff_87 * z^87)
    let t705 = circuit_mul(in160, t86); // Eval big_Q step coeff_88 * z^88
    let t706 = circuit_add(t704, t705); // Eval big_Q step + (coeff_88 * z^88)
    let t707 = circuit_mul(in161, t87); // Eval big_Q step coeff_89 * z^89
    let t708 = circuit_add(t706, t707); // Eval big_Q step + (coeff_89 * z^89)
    let t709 = circuit_mul(in162, t88); // Eval big_Q step coeff_90 * z^90
    let t710 = circuit_add(t708, t709); // Eval big_Q step + (coeff_90 * z^90)
    let t711 = circuit_mul(in163, t89); // Eval big_Q step coeff_91 * z^91
    let t712 = circuit_add(t710, t711); // Eval big_Q step + (coeff_91 * z^91)
    let t713 = circuit_mul(in164, t90); // Eval big_Q step coeff_92 * z^92
    let t714 = circuit_add(t712, t713); // Eval big_Q step + (coeff_92 * z^92)
    let t715 = circuit_mul(in165, t91); // Eval big_Q step coeff_93 * z^93
    let t716 = circuit_add(t714, t715); // Eval big_Q step + (coeff_93 * z^93)
    let t717 = circuit_mul(in166, t92); // Eval big_Q step coeff_94 * z^94
    let t718 = circuit_add(t716, t717); // Eval big_Q step + (coeff_94 * z^94)
    let t719 = circuit_mul(in167, t93); // Eval big_Q step coeff_95 * z^95
    let t720 = circuit_add(t718, t719); // Eval big_Q step + (coeff_95 * z^95)
    let t721 = circuit_mul(in168, t94); // Eval big_Q step coeff_96 * z^96
    let t722 = circuit_add(t720, t721); // Eval big_Q step + (coeff_96 * z^96)
    let t723 = circuit_mul(in169, t95); // Eval big_Q step coeff_97 * z^97
    let t724 = circuit_add(t722, t723); // Eval big_Q step + (coeff_97 * z^97)
    let t725 = circuit_mul(in170, t96); // Eval big_Q step coeff_98 * z^98
    let t726 = circuit_add(t724, t725); // Eval big_Q step + (coeff_98 * z^98)
    let t727 = circuit_mul(in171, t97); // Eval big_Q step coeff_99 * z^99
    let t728 = circuit_add(t726, t727); // Eval big_Q step + (coeff_99 * z^99)
    let t729 = circuit_mul(in172, t98); // Eval big_Q step coeff_100 * z^100
    let t730 = circuit_add(t728, t729); // Eval big_Q step + (coeff_100 * z^100)
    let t731 = circuit_mul(in173, t99); // Eval big_Q step coeff_101 * z^101
    let t732 = circuit_add(t730, t731); // Eval big_Q step + (coeff_101 * z^101)
    let t733 = circuit_mul(in174, t100); // Eval big_Q step coeff_102 * z^102
    let t734 = circuit_add(t732, t733); // Eval big_Q step + (coeff_102 * z^102)
    let t735 = circuit_mul(in175, t101); // Eval big_Q step coeff_103 * z^103
    let t736 = circuit_add(t734, t735); // Eval big_Q step + (coeff_103 * z^103)
    let t737 = circuit_mul(in176, t102); // Eval big_Q step coeff_104 * z^104
    let t738 = circuit_add(t736, t737); // Eval big_Q step + (coeff_104 * z^104)
    let t739 = circuit_mul(in177, t103); // Eval big_Q step coeff_105 * z^105
    let t740 = circuit_add(t738, t739); // Eval big_Q step + (coeff_105 * z^105)
    let t741 = circuit_mul(in178, t104); // Eval big_Q step coeff_106 * z^106
    let t742 = circuit_add(t740, t741); // Eval big_Q step + (coeff_106 * z^106)
    let t743 = circuit_mul(in179, t105); // Eval big_Q step coeff_107 * z^107
    let t744 = circuit_add(t742, t743); // Eval big_Q step + (coeff_107 * z^107)
    let t745 = circuit_mul(in180, t106); // Eval big_Q step coeff_108 * z^108
    let t746 = circuit_add(t744, t745); // Eval big_Q step + (coeff_108 * z^108)
    let t747 = circuit_mul(in181, t107); // Eval big_Q step coeff_109 * z^109
    let t748 = circuit_add(t746, t747); // Eval big_Q step + (coeff_109 * z^109)
    let t749 = circuit_mul(in182, t108); // Eval big_Q step coeff_110 * z^110
    let t750 = circuit_add(t748, t749); // Eval big_Q step + (coeff_110 * z^110)
    let t751 = circuit_mul(in183, t109); // Eval big_Q step coeff_111 * z^111
    let t752 = circuit_add(t750, t751); // Eval big_Q step + (coeff_111 * z^111)
    let t753 = circuit_mul(in184, t110); // Eval big_Q step coeff_112 * z^112
    let t754 = circuit_add(t752, t753); // Eval big_Q step + (coeff_112 * z^112)
    let t755 = circuit_mul(in185, t111); // Eval big_Q step coeff_113 * z^113
    let t756 = circuit_add(t754, t755); // Eval big_Q step + (coeff_113 * z^113)
    let t757 = circuit_mul(in9, t4); // Eval sparse poly P_irr step coeff_6 * z^6
    let t758 = circuit_add(in8, t757); // Eval sparse poly P_irr step + coeff_6 * z^6
    let t759 = circuit_add(t758, t10); // Eval sparse poly P_irr step + 1*z^12
    let t760 = circuit_mul(t756, t759);
    let t761 = circuit_sub(t530, t760);

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [32324006162389411176778628423, 57042285082623239461879769745, 3486998266802970665, 0]
    )
        .unwrap();

    let mut circuit_inputs = (t761,).new_inputs();
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
    let final_check: u384 = outputs.get_output(t761);
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
fn run_BN254_MP_CHECK_INIT_BIT_3_circuit(
    yInv_0: u384,
    xNegOverY_0: u384,
    Q_0: G2Point,
    yInv_1: u384,
    xNegOverY_1: u384,
    Q_1: G2Point,
    yInv_2: u384,
    xNegOverY_2: u384,
    Q_2: G2Point,
    R_i: E12D,
    c0: u384,
    z: u384,
    c_inv_of_z: u384,
    previous_lhs: u384
) -> (G2Point, G2Point, G2Point, u384, u384, u384) {
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
    let t90 = circuit_mul(t84, in36); // Eval sparse poly line_0p_1 step coeff_1 * z^1
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
    let t155 = circuit_mul(t149, in36); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t156 = circuit_add(in4, t155); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t157 = circuit_mul(t152, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t158 = circuit_add(t156, t157); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t159 = circuit_mul(t153, t5); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t160 = circuit_add(t158, t159); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t161 = circuit_mul(t154, t7); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t162 = circuit_add(t160, t161); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t163 = circuit_mul(t98, t162);
    let t164 = circuit_add(in19, in20); // Doubling slope numerator start
    let t165 = circuit_sub(in19, in20);
    let t166 = circuit_mul(t164, t165);
    let t167 = circuit_mul(in19, in20);
    let t168 = circuit_mul(t166, in0);
    let t169 = circuit_mul(t167, in1); // Doubling slope numerator end
    let t170 = circuit_add(in21, in21); // Fp2 add coeff 0/1
    let t171 = circuit_add(in22, in22); // Fp2 add coeff 1/1
    let t172 = circuit_mul(t170, t170); // Fp2 Div x/y start : Fp2 Inv y start
    let t173 = circuit_mul(t171, t171);
    let t174 = circuit_add(t172, t173);
    let t175 = circuit_inverse(t174);
    let t176 = circuit_mul(t170, t175); // Fp2 Inv y real part end
    let t177 = circuit_mul(t171, t175);
    let t178 = circuit_sub(in2, t177); // Fp2 Inv y imag part end
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
    let t220 = circuit_mul(t214, in36); // Eval sparse poly line_2p_1 step coeff_1 * z^1
    let t221 = circuit_add(in4, t220); // Eval sparse poly line_2p_1 step + coeff_1 * z^1
    let t222 = circuit_mul(t217, t1); // Eval sparse poly line_2p_1 step coeff_3 * z^3
    let t223 = circuit_add(t221, t222); // Eval sparse poly line_2p_1 step + coeff_3 * z^3
    let t224 = circuit_mul(t218, t5); // Eval sparse poly line_2p_1 step coeff_7 * z^7
    let t225 = circuit_add(t223, t224); // Eval sparse poly line_2p_1 step + coeff_7 * z^7
    let t226 = circuit_mul(t219, t7); // Eval sparse poly line_2p_1 step coeff_9 * z^9
    let t227 = circuit_add(t225, t226); // Eval sparse poly line_2p_1 step + coeff_9 * z^9
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
        MillerLoopResultScalingFactor
    };
    use garaga::ec_ops::{SlopeInterceptOutput, FunctionFeltEvaluations, FunctionFelt};

    use super::{
        run_BLS12_381_MP_CHECK_BIT00_LOOP_2_circuit, run_BLS12_381_MP_CHECK_BIT00_LOOP_3_circuit,
        run_BLS12_381_MP_CHECK_BIT0_LOOP_2_circuit, run_BLS12_381_MP_CHECK_BIT0_LOOP_3_circuit,
        run_BLS12_381_MP_CHECK_BIT1_LOOP_2_circuit, run_BLS12_381_MP_CHECK_BIT1_LOOP_3_circuit,
        run_BLS12_381_MP_CHECK_FINALIZE_BLS_2_circuit,
        run_BLS12_381_MP_CHECK_FINALIZE_BLS_3_circuit, run_BLS12_381_MP_CHECK_INIT_BIT_2_circuit,
        run_BLS12_381_MP_CHECK_INIT_BIT_3_circuit,
        run_BLS12_381_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit,
        run_BLS12_381_MP_CHECK_PREPARE_PAIRS_2_circuit,
        run_BLS12_381_MP_CHECK_PREPARE_PAIRS_3_circuit, run_BN254_MP_CHECK_BIT00_LOOP_2_circuit,
        run_BN254_MP_CHECK_BIT00_LOOP_3_circuit, run_BN254_MP_CHECK_BIT0_LOOP_2_circuit,
        run_BN254_MP_CHECK_BIT0_LOOP_3_circuit, run_BN254_MP_CHECK_BIT1_LOOP_2_circuit,
        run_BN254_MP_CHECK_BIT1_LOOP_3_circuit, run_BN254_MP_CHECK_FINALIZE_BN_2_circuit,
        run_BN254_MP_CHECK_FINALIZE_BN_3_circuit, run_BN254_MP_CHECK_INIT_BIT_2_circuit,
        run_BN254_MP_CHECK_INIT_BIT_3_circuit, run_BN254_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit,
        run_BN254_MP_CHECK_PREPARE_PAIRS_2_circuit, run_BN254_MP_CHECK_PREPARE_PAIRS_3_circuit
    };


    #[test]
    fn test_run_BLS12_381_MP_CHECK_BIT00_LOOP_2_circuit_BLS12_381() {
        let yInv_0: u384 = u384 {
            limb0: 0xa687be4ac275663e85ae7d15,
            limb1: 0x58523bc0dac98b86ffdedc97,
            limb2: 0xd464fe66b86adf6c14c38bb5,
            limb3: 0xbf85ffe43a3da0de567b1cc
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0xbdaefae2b19d24ad7a79fcf0,
            limb1: 0x3e6c8951068ca194d7cb840e,
            limb2: 0xa6c19f8dd741222f12b269e0,
            limb3: 0x158e0beefe7a695b4afc3e3a
        };

        let Q_0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x408aef7d90deafaa1ce64f08,
                limb1: 0x40ae21fd0d73f5596ee62716,
                limb2: 0x1b40af69c3834e7ad0a8fd43,
                limb3: 0x1270fe2cb79307b2b3975b23
            },
            x1: u384 {
                limb0: 0x88dd9e8635a55bfe607caba4,
                limb1: 0xed1e054f5fb786f4f61ed233,
                limb2: 0xd97eb2fc26fc574c358d3e42,
                limb3: 0x1146da0611d0fd54750e61b1
            },
            y0: u384 {
                limb0: 0xc8bb01febfb6230d6057b5b7,
                limb1: 0x2e7081b480f742631f2ae264,
                limb2: 0x1ce06fbcd81daf9584d23413,
                limb3: 0x593db0235c92d9572865830
            },
            y1: u384 {
                limb0: 0x501162ddbe3344a0bb1f8311,
                limb1: 0x283d53d5bce4588edcb7c7fc,
                limb2: 0xb26d1e8a0111aca2994907f1,
                limb3: 0xdf29db04cb0ff1bb6eb3b81
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0xd0fa59e7ed6177be2de4e15d,
            limb1: 0x759cdaec3adc2893bc9979c4,
            limb2: 0xb08d0f95cd8f1e8bcac8d101,
            limb3: 0x673a47763b29eab9be64e1
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0xdec340991ca7b806649ddd51,
            limb1: 0xe1d292ab36f4851f431d779a,
            limb2: 0x301c873062fe8d6895f45a1f,
            limb3: 0x2d7262beea64d23eaf3913e
        };

        let Q_1: G2Point = G2Point {
            x0: u384 {
                limb0: 0xefdab5241ea3247219cf40ca,
                limb1: 0xbe9fe979e58b85706766ec38,
                limb2: 0xb8a79810bb90ead7f7c05d5d,
                limb3: 0x9fdd5d2f1f9e473352c848b
            },
            x1: u384 {
                limb0: 0x5cdaabc51dbcc13a03cd67d9,
                limb1: 0x3847cd1e8731f19ccdb3c99f,
                limb2: 0x7814183dd17b02790fc2f5b,
                limb3: 0x1367ebfde9c1d7363f49a42
            },
            y0: u384 {
                limb0: 0xb15791b82a36d940e65d79f1,
                limb1: 0x44898b04af8d0979b51dc1de,
                limb2: 0x14d0f793db265d6cd0fa6c1f,
                limb3: 0x15fe798ca7a2d842dac513d3
            },
            y1: u384 {
                limb0: 0xb7815143521a9b076aa33909,
                limb1: 0xfc1f14aca6bb529a4a6ee1d2,
                limb2: 0x9169b5bbf2861dbe5061a00b,
                limb3: 0x3acd178c3d7555b8c65f528
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 0x3d550d82be187b3013b79970,
            limb1: 0xefc20d7d4aea3cde390c36c3,
            limb2: 0x6f79e82cbea82e21b6204beb,
            limb3: 0x196396b68ec9e2249fa6781
        };

        let f_i_of_z: u384 = u384 {
            limb0: 0xffb9b5ea0949cf4caaedfbf,
            limb1: 0x47c8a4cc6445d014648f0804,
            limb2: 0xce80af5cee6d6c4dfbac46f5,
            limb3: 0xce163dfcc8a055506aa3930
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 0x1ce808700199c4201a1b7de7,
                limb1: 0x490768b00530aee39044d06c,
                limb2: 0xf66221f804e936900b4e3fdc,
                limb3: 0x11ae73ddf18109626222cf78
            },
            w1: u384 {
                limb0: 0x8fea470f9ed0c113f52a2944,
                limb1: 0x7cf2ffb924a6485fc3aebd36,
                limb2: 0xd7bcafdfc948aff1182e1a8e,
                limb3: 0x1934ffd92a5b8951745c170
            },
            w2: u384 {
                limb0: 0x348266db688bdcdaf7dc571d,
                limb1: 0xd039fca63c78c6a93f507e7b,
                limb2: 0x12882f6000073cc2c801c67c,
                limb3: 0x178cf666a89dd1141841c249
            },
            w3: u384 {
                limb0: 0xa79e431fc6adad4a37c6c427,
                limb1: 0x35b6a4b0ca657102cb628a19,
                limb2: 0xdb51b28170938792e76720f8,
                limb3: 0xadb95c989ec52525f226e20
            },
            w4: u384 {
                limb0: 0x5937d3dbea805229b4456af3,
                limb1: 0xb715cf06aaae38c4ba2d47f1,
                limb2: 0x6f55e04602ae78729c3ecbc8,
                limb3: 0x12febcf76109ce6d638ed6d1
            },
            w5: u384 {
                limb0: 0xefb1fa076a8cfe717bcaf161,
                limb1: 0x26f787edd2bd504f53bcb098,
                limb2: 0xcd2af21637abd90d01d993cf,
                limb3: 0xcb735f366fcda7b3593dc66
            },
            w6: u384 {
                limb0: 0x215c7024f2b5c748fa6b5e5d,
                limb1: 0xc633ff19d95807d2be77e40e,
                limb2: 0x4465259bc419f2b57d79ab44,
                limb3: 0x14b7f635ecac7eaaa9ed0751
            },
            w7: u384 {
                limb0: 0xc907af5d8a8f08658fc929bd,
                limb1: 0xcfdc16d06aaf3f5c0b6ccca2,
                limb2: 0xe086f2af3059c49853140bba,
                limb3: 0xa5236096a2ca0040465a6d5
            },
            w8: u384 {
                limb0: 0xa76f80a91db943222d85ceb2,
                limb1: 0x5144634dbe6449c33dc51701,
                limb2: 0xacdffd0f651fff2de94ed093,
                limb3: 0x5d96ab3510cbf3a5180d2a0
            },
            w9: u384 {
                limb0: 0x96535180c41c918631f5382f,
                limb1: 0x601031fad1e06f003f9972f1,
                limb2: 0xc51e4f7d62b7aabd1be4143d,
                limb3: 0x12eb059adac24c5acd8801de
            },
            w10: u384 {
                limb0: 0xa0f0ba56ec00caa08fbd4130,
                limb1: 0x3f69fe38fc8b65a798aa03b6,
                limb2: 0x4cb4d9a4c0de4b89be037ad5,
                limb3: 0x5dc5804cce6ba76020c5a67
            },
            w11: u384 {
                limb0: 0x5cafd1494d09bdc7967006cb,
                limb1: 0x824500dbebdb7c95529257df,
                limb2: 0x9745cba9fb21f62d5620f2de,
                limb3: 0x17a70fcaf882006a68ba16e9
            }
        };

        let z: u384 = u384 {
            limb0: 0xf3f9fd86711f02ace9052731,
            limb1: 0x15ed9d8a5948f6332ed3dea2,
            limb2: 0xacf6e8e95d8ae9873f4fdb9b,
            limb3: 0x196c959a3331cc055ca5b513
        };

        let ci: u384 = u384 {
            limb0: 0xed99ac9edd75dd0f46a55245,
            limb1: 0x12c1138bd7bec6394b7d9216,
            limb2: 0x983203de13c49a5c892c5c7c,
            limb3: 0x12c99886f18e44f823b1fa5b
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
                limb0: 0xcad74915bb250e59ebc53750,
                limb1: 0x6534a3133641572f4bea15f1,
                limb2: 0xdbbcfe89310d7487cc95c4e1,
                limb3: 0x9b2cb9ebcb124737fada2d2
            },
            x1: u384 {
                limb0: 0x3ab779316dadd6da8ff69de5,
                limb1: 0xc1927e55ce839a7175d64b5b,
                limb2: 0xddac82ddba1a22979aa71347,
                limb3: 0x67bab44ce22e0e136555ee8
            },
            y0: u384 {
                limb0: 0x8dcc2ebf92b83e9ac284b8a8,
                limb1: 0x5c48a1bc4fa4d898ada3d013,
                limb2: 0x8693b3b6067a05cdc14ea47f,
                limb3: 0x81e3de92451d1d869997eef
            },
            y1: u384 {
                limb0: 0xc9273bd907626de1f1a55444,
                limb1: 0x4b3809c22167583bf445e580,
                limb2: 0x141ce8a7bfaf4d67ae263dae,
                limb3: 0x2a41a68e265e4a5dd4fc47d
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0xc250d433287bb5b5249767c5,
                limb1: 0x74afcfa641609067243a95fa,
                limb2: 0xd71e707c7fac335ae34cf8,
                limb3: 0x133d3c3aff40b9e4c6ef6032
            },
            x1: u384 {
                limb0: 0x73fd219789e817ce46607607,
                limb1: 0x7e1af36b613c5cbf0d4bfa4e,
                limb2: 0xb55a2e5ddfbe10145c959205,
                limb3: 0x146c19f849cdab82798b19ab
            },
            y0: u384 {
                limb0: 0x9e4b092d7e5320544dd3ec95,
                limb1: 0x971eff3b41aa6498c5dd943,
                limb2: 0x1192a9dfd4d700f0e501315a,
                limb3: 0x1531013ddbe26c7c9ec5be70
            },
            y1: u384 {
                limb0: 0x203edb0edb0999f143659008,
                limb1: 0x1ff22f112a2e943ea4a61b34,
                limb2: 0x78e9d4539c3579b8e824b950,
                limb3: 0xf9832f80f2e9be7f1adeffc
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0x7a581ffb59c1f53d43adf25c,
            limb1: 0xcaa5f5efbaa09af2ba9e07ea,
            limb2: 0x871cf0227b8b74b35c1ce0f0,
            limb3: 0x18fec5e08bf2ad57c64d2dcb
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 0x8d00b9ca7a11aad2a233a51f,
            limb1: 0xbc31b186df2b18c60fa52c6,
            limb2: 0xf62cbdcdd6f32c37ccd4a8c9,
            limb3: 0x1c08b8c9b5d0916f9188f85
        };

        let ci_plus_one: u384 = u384 {
            limb0: 0xf6855964e93f06dbcbcfb17,
            limb1: 0xe6910eb188df00f9e32e048f,
            limb2: 0xa73638e58f72b11a0fb6369,
            limb3: 0x110a6f996e133e704fe9ae31
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
        assert_eq!(lhs_i_plus_one_result, lhs_i_plus_one);
        assert_eq!(ci_plus_one_result, ci_plus_one);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_BIT00_LOOP_3_circuit_BLS12_381() {
        let yInv_0: u384 = u384 {
            limb0: 0x10c1a29afc01694a1eaca5d5,
            limb1: 0x987de8f23e9a772e88374a86,
            limb2: 0x8fdf98182142373c0e52cbc1,
            limb3: 0x1609d665561f7e5ee771ebab
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0x137e21d5189c0ffcdc91b762,
            limb1: 0xc17c182023f650e8c97825ad,
            limb2: 0x2ccd2ac3d3fafe1393a023f2,
            limb3: 0xb31ab94c485009cd4f604c9
        };

        let Q_0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x872fe36142b28540224bfb0d,
                limb1: 0xb69c39b9a73d23a6796e76fb,
                limb2: 0xb331cf4d3e9037354716a271,
                limb3: 0x18479d2589bc84b6dda401e9
            },
            x1: u384 {
                limb0: 0x36d642824b6a1b1d00dd010c,
                limb1: 0x61f5351032068b53596303d9,
                limb2: 0x4161fe8753d58c587e4e182b,
                limb3: 0x130c0f370344e247f13ef6d2
            },
            y0: u384 {
                limb0: 0x43e1dfa22522466bc9ab9a1b,
                limb1: 0xe42ea50a4dd9d9683afed6be,
                limb2: 0x23f2da2d4cc502e1fc62a7d0,
                limb3: 0x4db13515324e2803f5a0204
            },
            y1: u384 {
                limb0: 0xdd1d62d3162227978f9875b3,
                limb1: 0x7fe5c73f1b7a4ea3ea9f3eb8,
                limb2: 0x9d3eef19d02cf5265662d87b,
                limb3: 0x7768fd7ce0efed315e2eb52
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0x4b4cf406ad21e2abaac37d22,
            limb1: 0x4696db0e0a30a255290819c1,
            limb2: 0xd7bda79106de025e03e982fa,
            limb3: 0x84b55f04eaaaa65142f4290
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0x6d195acc5167c254a9800a11,
            limb1: 0x22b5df976b486220e354f6ae,
            limb2: 0x9c689b36aa46a794a60153ea,
            limb3: 0x148a11d6873156b8b0977501
        };

        let Q_1: G2Point = G2Point {
            x0: u384 {
                limb0: 0xd45b875b981030291d04fa25,
                limb1: 0x5b9999d77322fdfa6a76c29d,
                limb2: 0x79da10b9920cd3b84d26d96f,
                limb3: 0xe357d52e2f4c35c1a35187c
            },
            x1: u384 {
                limb0: 0xda5460b1dfa4807eb1a1ad39,
                limb1: 0x1cce93d1e5c823616d20022a,
                limb2: 0x1adf1bdb6fed84ebfedb852f,
                limb3: 0x87e4c6d72050a314e2cf688
            },
            y0: u384 {
                limb0: 0xa99908598f1d55280869f58,
                limb1: 0x4b4444b547006868578e651a,
                limb2: 0x8e13c327b461cc8f6e1625f3,
                limb3: 0xa28ffd96447c047fec7d97
            },
            y1: u384 {
                limb0: 0x6d096ec0fe51894d4834bb3a,
                limb1: 0xb8daa7f23183738504d35f1f,
                limb2: 0x3d85cd4414268795b1b27d3e,
                limb3: 0x103c421da57cf826491f7bd6
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 0x398e0b7aa6ee8026f9e65cca,
            limb1: 0xfb30673605fca7b7e7fcfdcd,
            limb2: 0x1584ab4ded8441566a686d6f,
            limb3: 0x72935c987ea36aa971056e2
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 0x4375050815303adaf3692b22,
            limb1: 0x947a59ff1905ccd1aa30b1e1,
            limb2: 0xb5fc791faa3091ca61a913ed,
            limb3: 0x3eb0f95e13ae7166084b2b0
        };

        let Q_2: G2Point = G2Point {
            x0: u384 {
                limb0: 0x3b267e216396b7a72720168,
                limb1: 0xce89ce20ca9553d244e8b777,
                limb2: 0x7f42542c5baf665329bbd86e,
                limb3: 0x95e6e57364ac7f43c6c0da8
            },
            x1: u384 {
                limb0: 0xc74093ac314f7e995a24e786,
                limb1: 0xa72fabab25edfea9269dc3b6,
                limb2: 0x7e6f332d367cf0887f4ad1b5,
                limb3: 0x4e6559a2f348ad2e688f05e
            },
            y0: u384 {
                limb0: 0xafbd57df4612154953a08862,
                limb1: 0x42cea88627c8a86a03fd60b3,
                limb2: 0x1385375ca1f0c098d1935abb,
                limb3: 0x104fe566701688a2a15b79b6
            },
            y1: u384 {
                limb0: 0x6ca32e8b3df41cf488e06c19,
                limb1: 0x3d4b89bcbedda067ee8acafe,
                limb2: 0x89cf414ba49e36c5728c9205,
                limb3: 0xbc97545aeee10520ea85777
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 0x4700a3cd6d3914c01b20bbf6,
            limb1: 0x10fdb1ca941a7e9c915ad4d1,
            limb2: 0x7fab391ca498fe88eda0f2f3,
            limb3: 0x2c525603072b1215996c8b3
        };

        let f_i_of_z: u384 = u384 {
            limb0: 0x4ce31c63feb6a28254c5b27d,
            limb1: 0xf10f1f62e46fde3b87f6dfaa,
            limb2: 0x8b5feab3d68944a51cddac23,
            limb3: 0xd39bb2357ee3e46229edea1
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 0x150e8637021e6b04937198d,
                limb1: 0x8839e2b5409d108c84e2ca17,
                limb2: 0x9f4b6e251f1472dbc7ff1f21,
                limb3: 0x6baddba3c9ce99f131aac7
            },
            w1: u384 {
                limb0: 0xb499acf32f57fe3835006ba6,
                limb1: 0x6866bda9f4d7d57a923c6b6c,
                limb2: 0x7399a177217a56b10641ff10,
                limb3: 0xe29280667ef7e9ec03f0034
            },
            w2: u384 {
                limb0: 0xc9e7baba75da3e50822bbc3d,
                limb1: 0xc3aea2d1ba2bdab551b0a3c5,
                limb2: 0xaba3770b85c4b44ff93b5dbf,
                limb3: 0xe07e3daadd178efbaa5daef
            },
            w3: u384 {
                limb0: 0x4562daff16b264357bb8be94,
                limb1: 0xa38685f66db7d4f3109d5c8d,
                limb2: 0xb80150f9c7a3177c322931d3,
                limb3: 0x2acbfcb145581daa5d01c19
            },
            w4: u384 {
                limb0: 0x7e3d88a3f1c1096ecd6e3c6f,
                limb1: 0x808a845950bc0c180adf1c0a,
                limb2: 0x4b4f82484e49720d2225137e,
                limb3: 0x163cebfcb94c957792eb4614
            },
            w5: u384 {
                limb0: 0x213a786ef22cfeb1026d44c2,
                limb1: 0x2aecdf5eda0068050e6b21f3,
                limb2: 0x52ec0382465012448d24b762,
                limb3: 0x80dd8739a4a2a9c6735a173
            },
            w6: u384 {
                limb0: 0x3a89591eb7b9387b677bd216,
                limb1: 0x7b76f1b254fc5281322515a5,
                limb2: 0xdb514bc0a2bd6dd6cdd67b39,
                limb3: 0xf8ae2a2d68e33b52c28839
            },
            w7: u384 {
                limb0: 0x4544469ec12c2611de415380,
                limb1: 0x45f6bee6c1a0b1f025de5341,
                limb2: 0xc8099ccbe5a6beb5392f2cd1,
                limb3: 0x106c579ac89f403eba7e24b1
            },
            w8: u384 {
                limb0: 0xa93fc9ca962af06ac7539d32,
                limb1: 0xe9b3efea67b61c3ac9b7146e,
                limb2: 0x1f7b2da2d8680e4dab723535,
                limb3: 0xeb44a8ad5a7161c6b8acec7
            },
            w9: u384 {
                limb0: 0xaa848d8c682d4e3c70cef137,
                limb1: 0xd66ee0a416a5b60769fbdedc,
                limb2: 0x4f130b23360cdc9a020cfbc0,
                limb3: 0x12a0bbce3ae059360170b948
            },
            w10: u384 {
                limb0: 0xafe9b9adfd4a6945d77f1503,
                limb1: 0xf5ad03adae971471a20b197e,
                limb2: 0x21cf320dc6150907d3f49a2e,
                limb3: 0xc14659ae47c628a2e4d3247
            },
            w11: u384 {
                limb0: 0xe53a9fe5046a87592dbca078,
                limb1: 0xb3b098789ab93ad0084edeb0,
                limb2: 0x47767f6446e2b6542216e670,
                limb3: 0x131e7614c4d8347a44fc93cf
            }
        };

        let z: u384 = u384 {
            limb0: 0x32cc59b1688393f7f8a22794,
            limb1: 0x5b968f6155d4fed13bea224,
            limb2: 0x89aca0da37f90ba74ce85730,
            limb3: 0x926f07ab1da4e386ce8b03
        };

        let ci: u384 = u384 {
            limb0: 0xb369907d5361afa9aaf2264b,
            limb1: 0x101efc05873e40ddfdcb54ac,
            limb2: 0x52ad8e898836f391eb064d34,
            limb3: 0x11420d929c4108223a8ca3ca
        };

        let (
            Q0_result,
            Q1_result,
            Q2_result,
            f_i_plus_one_of_z_result,
            lhs_i_plus_one_result,
            ci_plus_one_result
        ) =
            run_BLS12_381_MP_CHECK_BIT00_LOOP_3_circuit(
            yInv_0,
            xNegOverY_0,
            Q_0,
            yInv_1,
            xNegOverY_1,
            Q_1,
            yInv_2,
            xNegOverY_2,
            Q_2,
            lhs_i,
            f_i_of_z,
            f_i_plus_one,
            z,
            ci
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x601ba2bb826c094705fdf181,
                limb1: 0x1ac56e391607a99e1e4b1f0d,
                limb2: 0xbce3c955de666f0e36a4f6ec,
                limb3: 0x1840b5c069606e930beb75cf
            },
            x1: u384 {
                limb0: 0x3d49b72e92b8edc177a6db5,
                limb1: 0x147402bb6c28ed9a3302ad20,
                limb2: 0xd5b63e70dbde16c2280f032c,
                limb3: 0x161855a86cc223a7fdaeb1a3
            },
            y0: u384 {
                limb0: 0x6111b043e4da6d136af65f75,
                limb1: 0xae7d32f01774e9c8769e18ae,
                limb2: 0xceb2d24c80769d80cc2a9e8c,
                limb3: 0xd08f7698f26eca2a92fc337
            },
            y1: u384 {
                limb0: 0x75221acc97888571e1427c05,
                limb1: 0xb71ae1b72178509404488246,
                limb2: 0x4cead42fb5b2b8bf9efec570,
                limb3: 0x9b69e5ddfe47ecbbdc52c40
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x9522e568a15f459c1abf0b5f,
                limb1: 0x134d05e670081878ffccb53f,
                limb2: 0x40fc6ad1cc622b4cc8a3a479,
                limb3: 0x116250e2bae0403b4ec31919
            },
            x1: u384 {
                limb0: 0x4ca4df800b313e88d27e0dc2,
                limb1: 0x22ef3813c573068d98311076,
                limb2: 0x9aa90d8b9e5441d1af378fde,
                limb3: 0x75b01c393329b94091e815a
            },
            y0: u384 {
                limb0: 0x7da17847834e57e196f795bf,
                limb1: 0xf0c74e043d8ae923079eb2c4,
                limb2: 0x5b65f97c69145fa6ecf0f137,
                limb3: 0x1166b2babd724ea34c1255ae
            },
            y1: u384 {
                limb0: 0x49744d0fd97836cbf5113fc9,
                limb1: 0xc867a7beac3c9dbf60ecb8f,
                limb2: 0xb0c9a1760b2bd638c0c08863,
                limb3: 0xaad620f4fb0c216d3464b89
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 0xbe4442b7a1f030bf5a3382e5,
                limb1: 0x85e81a622321b7e69cf40d0c,
                limb2: 0xc9fe927f337c7e86b1ef32aa,
                limb3: 0x196c76dfe49f464a3bded384
            },
            x1: u384 {
                limb0: 0x5e9044546dbe3db24975734b,
                limb1: 0xe0917aa8c81826f3193c564d,
                limb2: 0x57ea0fd5dce4c26403065aec,
                limb3: 0x99a7c7b1265d201f107ed7a
            },
            y0: u384 {
                limb0: 0x978bb4c7606402488f060bb9,
                limb1: 0x4897e4d1bf08cb252c58c2a5,
                limb2: 0x2bb9a3c891996b94c837d666,
                limb3: 0xfec977058867873474f115
            },
            y1: u384 {
                limb0: 0x6c5bfb8aad72461fd7234ba1,
                limb1: 0x4851c0a32e5f32ab33930646,
                limb2: 0xfff0adda6bf37089010165be,
                limb3: 0xd91a1f9fa0a535d361a8b34
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0x93b4d975414948a106b53983,
            limb1: 0xd114ca8f88f7cdf871058070,
            limb2: 0xa02d065dd1015bd9fbe3130f,
            limb3: 0x1816ad0adc74141628a3a81f
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 0xd214c2b58f548e0e187f6fc,
            limb1: 0x6d0379096afd3bd7d4a68c2f,
            limb2: 0xd76f776e365dd4de211f30be,
            limb3: 0x6572d8d67610e393f7cb548
        };

        let ci_plus_one: u384 = u384 {
            limb0: 0x1545ed1c83a66f256f4256c6,
            limb1: 0x797c812b8236a783624dd485,
            limb2: 0x672b414ed7c92aaa565b3931,
            limb3: 0x17d7dde2a593c46c28a310f9
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(Q2_result, Q2);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
        assert_eq!(lhs_i_plus_one_result, lhs_i_plus_one);
        assert_eq!(ci_plus_one_result, ci_plus_one);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_BIT0_LOOP_2_circuit_BLS12_381() {
        let yInv_0: u384 = u384 {
            limb0: 0xe2cf0ef50ec178acbd797e9a,
            limb1: 0x5f26595e0c054854df85e6bf,
            limb2: 0x194cceeff9e78a222ebda4e7,
            limb3: 0x109d505c5bdfd8143f3d0382
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0x8e5af8ef3b0eae2d4f7e1c6,
            limb1: 0x8c51943d54e964d4c098d286,
            limb2: 0x928b66d53c71efbdf0b87177,
            limb3: 0x2dcef2451207f9c394ba37c
        };

        let Q_0: G2Point = G2Point {
            x0: u384 {
                limb0: 0xc114d97facee452fde13865c,
                limb1: 0x194e36b30e01645614ab54b4,
                limb2: 0xeb002884ef1cc4d8e21d8459,
                limb3: 0xc7db8fc7ff6815e523c9ef4
            },
            x1: u384 {
                limb0: 0x6767733eb070bdcba0cf5cdd,
                limb1: 0x5be9d91857a798d87f62ee1d,
                limb2: 0xc59690b60be31109a185a46d,
                limb3: 0x2fadea572c78a9921c7dfde
            },
            y0: u384 {
                limb0: 0x22f4260d57620ecd8b06b169,
                limb1: 0x800f129579704ad69c897da,
                limb2: 0xe463f3a0ebceb34071b2caba,
                limb3: 0x5853c589c6a858e683ce69c
            },
            y1: u384 {
                limb0: 0xcdff3c31777361315b434e02,
                limb1: 0x5aedb7243d49659f77106d15,
                limb2: 0xf1c37d639f51958a94b643ed,
                limb3: 0x15a33594035109a9c68ba1d3
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0xc5e3f8d4384c1b4d93f90ad6,
            limb1: 0x137b75328b36e20ed0a01970,
            limb2: 0xde44ea1ce188ea613f0ed11d,
            limb3: 0x5b34a8c9b7f3e3516fb588c
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0x70e86f99fbf2a7a36aadd5ee,
            limb1: 0xc7fab649e2631aac3d8ab858,
            limb2: 0xfd61c6fc4d1aa07eaca29647,
            limb3: 0x13a348b9abdcc2869d3337cb
        };

        let Q_1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x7e41e579012f127e1b94cb70,
                limb1: 0xefeeadca2e5ed03cb31d2e4,
                limb2: 0x27dc7d9de43ed5f7040874fe,
                limb3: 0x17cddc2ca528419ab16222de
            },
            x1: u384 {
                limb0: 0xb57302b3c9dff09c0d5d816e,
                limb1: 0x31b171b6225f39f37a8e6f61,
                limb2: 0xcc01bc9b259aabbe6f187807,
                limb3: 0x14480eda335cb03e152aaa9
            },
            y0: u384 {
                limb0: 0x8f56198e2a2b8bf9345ce8cb,
                limb1: 0x5aa62fab72f51d3ff4db03d,
                limb2: 0x1134ea8cf9e7168e356a509c,
                limb3: 0x11375db527754a94f57bbe58
            },
            y1: u384 {
                limb0: 0x32fc4ab1012d87cec7a9cc25,
                limb1: 0xa34ae853c7bfd56566aae204,
                limb2: 0xb4e205e4bc40bfa5f4bcff43,
                limb3: 0x1524821bce890d5b8d6efae1
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 0xbb7b2188b83fe6d7c8ea4e96,
            limb1: 0x9fdbeaf0b1bfca2e7a3dad4c,
            limb2: 0x763f7abdb6026e8a026019f0,
            limb3: 0x8ac751d667efc9585d40ed2
        };

        let f_i_of_z: u384 = u384 {
            limb0: 0xc477cdad05b7e19cc8466f9c,
            limb1: 0xb45d072e7078c9f4db0d4810,
            limb2: 0x2cb77d6ce07858fabadf79f7,
            limb3: 0x6569a8ddc89a69c7c597193
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 0x2e94de1665e8adc8afed0efa,
                limb1: 0x9c06aff7e911f24362889866,
                limb2: 0xbd66a2108b9db228ba39597f,
                limb3: 0x5a8758f4fc699726c4862a4
            },
            w1: u384 {
                limb0: 0x69ad665de9e521b4f4323273,
                limb1: 0xe92580904462ae968d448b54,
                limb2: 0xd30e75f68627f10fa755109f,
                limb3: 0x193014a4eff164631ed1abd0
            },
            w2: u384 {
                limb0: 0xbd386d03d6b5059a6a6f0a87,
                limb1: 0x5992cd37167ff19cbbc235c6,
                limb2: 0x25b57b4a3246a33ed515659,
                limb3: 0xf66aaad8a9fca2cc6e8cc67
            },
            w3: u384 {
                limb0: 0x63dfcae1ba9b59284bf34dfe,
                limb1: 0xa2717e89710e9f7c919108b0,
                limb2: 0xceea3c095b1061e27efc5b0d,
                limb3: 0x102e699b7a0693a2ece6ce51
            },
            w4: u384 {
                limb0: 0x6e9fc333e86a8a4815db01a,
                limb1: 0x3ad25d095cd509a0e78824f5,
                limb2: 0x4ecf57323f6ed3e2d20a3b50,
                limb3: 0x81d4d85e0ebfc5ef56db9ae
            },
            w5: u384 {
                limb0: 0x471d3e476fe632366e4d0cd1,
                limb1: 0x64c0fef206eb6114826a222,
                limb2: 0x9cb2915c22a0894b3df66b5e,
                limb3: 0x11fe4f8434586ce87f588530
            },
            w6: u384 {
                limb0: 0xdde763638d8bd6e8f95a1656,
                limb1: 0xe5a620127eb873a6a9ed0290,
                limb2: 0xe01f0017ffed37bf418d36f,
                limb3: 0x11a21358a87c35ff9ca41b58
            },
            w7: u384 {
                limb0: 0xb5be161deda995b78c0aefd,
                limb1: 0xb8fc3b17b28f5ba20482d7b1,
                limb2: 0xafeb8e2419c2337d9e0516bc,
                limb3: 0x12680ab73a696460d811a6c0
            },
            w8: u384 {
                limb0: 0x3dd2071a8a0492d913c27bb7,
                limb1: 0x918a43256c91062826c2dbba,
                limb2: 0xb964a0c7a6702775a8d44ca7,
                limb3: 0x19229c9c4de2f84fc47f3f2b
            },
            w9: u384 {
                limb0: 0x4b2574647591789b92415203,
                limb1: 0xaff2b72925b6d5a547ce727b,
                limb2: 0x8c11dd8639f983b4414c27c8,
                limb3: 0x69af0816ab66d58b61219ad
            },
            w10: u384 {
                limb0: 0xad79e4d6d5cb74713ed0141c,
                limb1: 0xc78b7adf8203ab520a31f6e2,
                limb2: 0x4665f27cde22340122cb5aba,
                limb3: 0x71e7fa95c2bee9296d4e7ce
            },
            w11: u384 {
                limb0: 0xf12e50e4ea4da1a9439d89bb,
                limb1: 0xd9c165b3380d30b4ccfeb435,
                limb2: 0x4aa8f0fbeadb749cf956635,
                limb3: 0x16b662e39a7cc3b3860c7c6d
            }
        };

        let z: u384 = u384 {
            limb0: 0x44ea95577e3aea20133df6e9,
            limb1: 0x3785ec6ffd2a8ffe8a09025f,
            limb2: 0x60fb32f85b5c84a507c6bdbe,
            limb3: 0x11c42b9570b4bcad6b76e577
        };

        let ci: u384 = u384 {
            limb0: 0xb56b27966d8285675feaf4a9,
            limb1: 0xc8dc9079c6305724e7b550fa,
            limb2: 0x42ac906fc743aedbb9a3e7d2,
            limb3: 0x94d0b408a4177e047978178
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
                limb0: 0x882807892089df0f863b0638,
                limb1: 0x483f207b9463b17aedfa0d06,
                limb2: 0x54ae90f9dfeb0badefab8126,
                limb3: 0xd3b7c9593e1de56f0fd4c87
            },
            x1: u384 {
                limb0: 0x30a0496d67b8a3da4d44ed9f,
                limb1: 0x86319373d178f5dbbafb0e8,
                limb2: 0x940b2ca9f12727922358413e,
                limb3: 0x101b85b4b3ab980a11e0f51e
            },
            y0: u384 {
                limb0: 0x325841058f7ee297ba4fcf6e,
                limb1: 0x2ae55ffb5ab089f17fb30c3c,
                limb2: 0x18548fc5e2bbf394519152c4,
                limb3: 0x21a011638548baf46399d3b
            },
            y1: u384 {
                limb0: 0x7c400d302e1ee6fffe809de,
                limb1: 0x1f56413c478e28566e20217b,
                limb2: 0x50c093f0a77a69ae7b733bc3,
                limb3: 0x572e1dfbdf0dae7bcc5e40b
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x864680d6661dbe634db14509,
                limb1: 0xada135bd5dc9bff29032c944,
                limb2: 0xdbb6752f5ad1825d8b067477,
                limb3: 0x86c2c7e1b74507f4fea35ac
            },
            x1: u384 {
                limb0: 0xfd674852675b3162bff99b4c,
                limb1: 0x5ba3e7942c797e5e00a266e3,
                limb2: 0x198040881bd40011fa0dc931,
                limb3: 0x81df623d593091d8b1f667b
            },
            y0: u384 {
                limb0: 0xe4093dbb02392a2dd2447af8,
                limb1: 0x756051643d8c2a0b7152041d,
                limb2: 0xd75f392a9692af0fadc43fe4,
                limb3: 0x13928d9ad55ffbfc35a57276
            },
            y1: u384 {
                limb0: 0x9c14a18ebdb7897169ce979a,
                limb1: 0x6bb7cfa167e9fcb40f5b2236,
                limb2: 0xba50b5974145eb559bf96869,
                limb3: 0x102a5dd4c8e1cad1b10bb6c8
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0x80113794fda81ea69a23b84e,
            limb1: 0xbfd9be0d68f4afc003851e95,
            limb2: 0x14ec3913800c73a7b1bc313a,
            limb3: 0x19b3f4ca9550716220c2299
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 0x6914adbfd0a1dfd537527301,
            limb1: 0x5d7689cd9a05cb2c794ef5c,
            limb2: 0x4e4ecc0044ca4e63fd297e8,
            limb3: 0x2c68f23ac7eb87d5a7b5c2e
        };

        let ci_plus_one: u384 = u384 {
            limb0: 0xed728005e54daaf9331e88b0,
            limb1: 0x283319be1a74d3a76cf029a9,
            limb2: 0x6ac06291fcce4667cdc5b8c4,
            limb3: 0xc6671089aa92f4dc4096652
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
            limb0: 0x56d512a3ac7aca00d8c2b8af,
            limb1: 0xf151944a60133b93bd051c,
            limb2: 0xd906afd61aac3dbbd11832,
            limb3: 0x3fb7b7fb7bb0adc5d897352
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0xd0a7b26fd7b4a55a6025de1c,
            limb1: 0x988d1a5be29eea295aa93b27,
            limb2: 0x7ad4b385c874d5df7f9a63fb,
            limb3: 0x11c6643e5db5be3eb40aaa7c
        };

        let Q_0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x2871968c27f20af9cbacc159,
                limb1: 0x9738726065175f8d04a3e176,
                limb2: 0x1b2497e5d70568943ebbedc5,
                limb3: 0x47b4de6c2c5538ffe7044e7
            },
            x1: u384 {
                limb0: 0xc89a7a07e83b1d6fe20cc7a8,
                limb1: 0x4d69ac143367a0a4e7ffbb72,
                limb2: 0x98d83675770ba61646740c3e,
                limb3: 0x73d88da4218e573b8f46657
            },
            y0: u384 {
                limb0: 0xb00bc3b68cd12ac64f33f45,
                limb1: 0xfa7a4386f3f49f4f025ff13,
                limb2: 0x76b4ecc712180934615620f3,
                limb3: 0x6a14c10cfbec2e6d4e7147e
            },
            y1: u384 {
                limb0: 0x53b8b67dabc6e45ca4c6563e,
                limb1: 0xd6e41a290588accdf9f06012,
                limb2: 0x812de68e714c5bea2471d6bd,
                limb3: 0x17794752e19464bdf9168f97
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0x6b9cf6b2ada8291c7597b8d4,
            limb1: 0x92a2222819e5646f3620e69,
            limb2: 0xccf9ebd42645f7dd216c9bc3,
            limb3: 0x181ef9687d9c104f3886c62e
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0x10c2d392a9dba34c532221e2,
            limb1: 0x376688560b9714b05ca5042e,
            limb2: 0x121836b88c5574cc785f60a7,
            limb3: 0x1944e257332748a694308f87
        };

        let Q_1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x4f25da42c1d5ff3cbe07a51b,
                limb1: 0x38de757307856a204eed0d91,
                limb2: 0xeef72d97eb98f113f546e1d0,
                limb3: 0x5b6db63a33f17547c261b43
            },
            x1: u384 {
                limb0: 0x73bd852ca5fbb346dc880a29,
                limb1: 0x89877942eacef95f511cc1dd,
                limb2: 0xb0e52d50be1a657606ae32b,
                limb3: 0x8135328408d6d9e8dcd884
            },
            y0: u384 {
                limb0: 0x8d03deec2f5a0b3bee191416,
                limb1: 0x7cfc61cc3dc0a91c124f4f60,
                limb2: 0x8dcde1b3c8b7cf16ade3b5be,
                limb3: 0x100851a98da8e8b1ffb69554
            },
            y1: u384 {
                limb0: 0x38705dda0f0812583d2c1636,
                limb1: 0x201a55d602cb637d7143f8fd,
                limb2: 0xc04db309ee41eb04f811b567,
                limb3: 0x5651227e6a44bed0b33d390
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 0x3c8d2e49e3fb202273eb984b,
            limb1: 0x187dd9c6790a674ae4755b26,
            limb2: 0xdf01d2aeaaa0f9b8f9813b85,
            limb3: 0xa3a9d10bac07cabb7345e6a
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 0x6e015bad88560352adc3324b,
            limb1: 0x718c4d399298fe29a5d8bbec,
            limb2: 0x3d7082f091e75acac27eb997,
            limb3: 0x88f4c481124e8bf3f4f8738
        };

        let Q_2: G2Point = G2Point {
            x0: u384 {
                limb0: 0xe4a85e2b52863cd3658df18f,
                limb1: 0x28dba177f301ca3116d5d35,
                limb2: 0x7379f4cc5db914ebb6d8d3a5,
                limb3: 0x19644097ec94efca8c700b5
            },
            x1: u384 {
                limb0: 0xad44b87e906a2c81465d29d3,
                limb1: 0x2c4533ea33cb1b2045871674,
                limb2: 0xd764106199d081bee76fb887,
                limb3: 0x81326dd40dd73a38f0d3721
            },
            y0: u384 {
                limb0: 0xf44002b216a31263834cff3c,
                limb1: 0xcc977c6bda927e28cb6a4e4d,
                limb2: 0x6871e510fdeeb32f1b0453f8,
                limb3: 0x10e97ebf608a806cf72d378f
            },
            y1: u384 {
                limb0: 0xf62cdc39eccd4523e11fe602,
                limb1: 0x590cab8ec595bcf71032fb80,
                limb2: 0x43e6ad9b9e7e0170a4819363,
                limb3: 0xdbfdbc143bf6504da11d2c9
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 0xc39a0f17ea4028d82627c974,
            limb1: 0x8a280863e186d588e05ac0f5,
            limb2: 0x8e427589e3bbcdad87da2cb5,
            limb3: 0xd68522894a2f1099ceac06e
        };

        let f_i_of_z: u384 = u384 {
            limb0: 0x4cde0daeb6a017da86a284e8,
            limb1: 0xd00071b1b2864c8f0909d045,
            limb2: 0xade8c24452d40816c617d62f,
            limb3: 0x661b79ea7a5b57beb40c32
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 0x3f7d3e540353a7da07b31f46,
                limb1: 0x130da9ec33b76e265dcdb9e8,
                limb2: 0xac9a3e9d8919c6134f3b6ae,
                limb3: 0x130bf0bba5793822374e4377
            },
            w1: u384 {
                limb0: 0xb045ca2fe01714ba7e48a1c8,
                limb1: 0x6cf85508e1d49a0926bbec32,
                limb2: 0x5bf3e13c01dee1a19a01a709,
                limb3: 0x12c10a022d16a10bf48d02d0
            },
            w2: u384 {
                limb0: 0x1f71027555c7e9f7a793d3e,
                limb1: 0x35f03ec5442041ca0030f3fb,
                limb2: 0x8c00fe4c931c859486b2c2d8,
                limb3: 0x16d562e92d36b87fc083c02d
            },
            w3: u384 {
                limb0: 0x7976a0f99b5f43b06485ea29,
                limb1: 0x7dab6e71d961edfa905888bf,
                limb2: 0x5e17a07c3911ec3b33fd21eb,
                limb3: 0x12e12e07eb5784a27bba38d1
            },
            w4: u384 {
                limb0: 0x8bd97d52e8bb304c5ccd955c,
                limb1: 0x4b8cf4138556eaef6e48ba72,
                limb2: 0xf25043396f9c2d00ea0d57eb,
                limb3: 0xfadb88748a787be40558dbb
            },
            w5: u384 {
                limb0: 0xbd1542c9180287ed9a91e752,
                limb1: 0x12bdf9d0c04f9d2b323592e,
                limb2: 0x63ba97a1448e6d20c09881b7,
                limb3: 0x148f7845a657227e85fcb477
            },
            w6: u384 {
                limb0: 0x3112109ffeaf19d064bcedcb,
                limb1: 0xb7e106f4a7d29a38fe7654e0,
                limb2: 0x9223e12d604da3540eb5d9cf,
                limb3: 0x1506689d86848137df4615dc
            },
            w7: u384 {
                limb0: 0xac73e119addf72e4058aab59,
                limb1: 0xd1ee6a0c7f28db0e5333bd70,
                limb2: 0x892b9dc95ceeb4b53f1f8ad9,
                limb3: 0x12e30470a6e58cbc54a969fc
            },
            w8: u384 {
                limb0: 0xb596da460fd0fc309e875edb,
                limb1: 0x70f9ce5838f401f308ba3f66,
                limb2: 0x7f33d5b168c2382beab603af,
                limb3: 0x90a8d3d46dd06c1ba143f63
            },
            w9: u384 {
                limb0: 0x165f71e2d77cf2ae98d1bbfa,
                limb1: 0xdd62c575048b34b2e6d2b4cf,
                limb2: 0xd98043a817057f0d41543915,
                limb3: 0x79517f01b0eb5cfd55e69fb
            },
            w10: u384 {
                limb0: 0xbf4336a5dbaa94c488166ae5,
                limb1: 0x52e4e82593aa8737f9efe7d5,
                limb2: 0x7da41e432a13d4ce3ad0c585,
                limb3: 0x188fdccb698d01dfcac34232
            },
            w11: u384 {
                limb0: 0x5a78b2e1e1c9929f1e510001,
                limb1: 0xcf75bc58fd7889efd32eda0f,
                limb2: 0x2759eac917f76b5c0c09d6db,
                limb3: 0x3fb642fd9dba73cdf247a0c
            }
        };

        let z: u384 = u384 {
            limb0: 0x1bf91122cf2eb2eddac6c6f1,
            limb1: 0xcbf714add8dcc8aef4dfffb1,
            limb2: 0x7c091f35623190c9dd602c19,
            limb3: 0xa3dd88a2ca1e40a62d9ae83
        };

        let ci: u384 = u384 {
            limb0: 0x3d38c859f810cd78a75a7cfe,
            limb1: 0x80d559d4628d87fd2b74389d,
            limb2: 0x44a0321d4bc7051b97111924,
            limb3: 0xc7a288cdbe7afb71aa79a05
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
            Q_0,
            yInv_1,
            xNegOverY_1,
            Q_1,
            yInv_2,
            xNegOverY_2,
            Q_2,
            lhs_i,
            f_i_of_z,
            f_i_plus_one,
            z,
            ci
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x24d7beadeaa14bee4f3c4e46,
                limb1: 0x1f6fa2641257b595905bacbb,
                limb2: 0xf9897342590f669fc23a5069,
                limb3: 0x102e689b4296c4614fc8f36f
            },
            x1: u384 {
                limb0: 0x34cfefed8755afbd270db56f,
                limb1: 0x5bc707d408ee222313b43f5,
                limb2: 0x342fcf17108614dcb2ec0d4f,
                limb3: 0x16637dcceb942fccdc2df27f
            },
            y0: u384 {
                limb0: 0xbe10041c38e8b6f6cb137295,
                limb1: 0x394d31b6971b6ca3a8d91f1e,
                limb2: 0xe46463d3a6bff9adf51ef46d,
                limb3: 0x9bc79a224f379450a496947
            },
            y1: u384 {
                limb0: 0xc445340c9ad1df0178137e5d,
                limb1: 0xee613d35ebd89b5496b68030,
                limb2: 0x7bda0fbf535b5dd30b79a1fb,
                limb3: 0x833e1c26cf0f641afb7f395
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x6782f19767d9164a1af1ab64,
                limb1: 0x54f9eb0eec6f91901f0f762b,
                limb2: 0x62d89345ea08b10b59cf34ec,
                limb3: 0x15c9ebd1f669dcd8e68ac502
            },
            x1: u384 {
                limb0: 0xd58cdd9aeaf8ce2ef0558574,
                limb1: 0xf713bfa0f68e3079510d4653,
                limb2: 0xe5121b77f06e0bd4d6149b80,
                limb3: 0x9ee2f798139398a3ff83a10
            },
            y0: u384 {
                limb0: 0xd0dc0470c32fcbb3dc99c31a,
                limb1: 0xbe8e635c7ea3b236d59758d6,
                limb2: 0x51d1ba6bf6002438356c3ee0,
                limb3: 0x11e9b1b17c37a8b875b3b6e4
            },
            y1: u384 {
                limb0: 0xd123fb7f7a482f86a6038f61,
                limb1: 0x6b397d65b2f01fe4c0f68f21,
                limb2: 0x78fe10a163d38aa55694283,
                limb3: 0x16c545d8f5ffcd2b09fca1d5
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 0xe524658e593a7655114ae682,
                limb1: 0x7fb4e23042ffdc0a2afb44ca,
                limb2: 0xae2feb62a83f6345f5860730,
                limb3: 0x89d99fb6b52110f83bc88be
            },
            x1: u384 {
                limb0: 0x398ea207cfbc544c8d728088,
                limb1: 0x6737787d4d6fa542a9404c47,
                limb2: 0xfe0ad81201509b5a15ba7d56,
                limb3: 0x1b2c9e400ef8064aafa8c76
            },
            y0: u384 {
                limb0: 0xb52b2f9a41b1476064aa31a0,
                limb1: 0x94daf21ec7c34802b52780f3,
                limb2: 0x61a2c92193a6c86982b65714,
                limb3: 0x116e4bc99ca0c28bb996d12a
            },
            y1: u384 {
                limb0: 0x44c6c22ced2e16b2d529e76b,
                limb1: 0xd12c4863a948a37a9a00a017,
                limb2: 0x632d5fbcae39637b37425580,
                limb3: 0x374e5bc749ead2d3a6208e1
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0x1bfc37cc6df28123437a42e9,
            limb1: 0x1883fabdebfc4097afb23489,
            limb2: 0xd0c3932fc94a0d7d0417deff,
            limb3: 0xf06335ae1157a187b46d683
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 0x55a6d6c94bcd9fe5bafa2666,
            limb1: 0xaf253f91dc8058f03b3b2cf8,
            limb2: 0xd3c9738f42b5b56e1e838d11,
            limb3: 0x10ea7f69910a220c7434ff5e
        };

        let ci_plus_one: u384 = u384 {
            limb0: 0x8ea03c9672f6107f72224f6,
            limb1: 0x17f4491067521fc27690d1ca,
            limb2: 0xdb9de2e5e8edeb9002901423,
            limb3: 0x1081952803abd2366320fbc2
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
            limb0: 0x7bfaf3a1723f31ba12602d10,
            limb1: 0xe1e429cf8dba6d8f7ab8572c,
            limb2: 0xb68b604992edb418eee13dc0,
            limb3: 0x121fd60fa0e33935f51559fd
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0x34ed68217ae3a848e79d67bc,
            limb1: 0x1225ce9528eaf4b062fce1b,
            limb2: 0x971211a9aecb26826fe47e69,
            limb3: 0x1912dc5dfd1c9a78350b62e7
        };

        let Q_0: G2Point = G2Point {
            x0: u384 {
                limb0: 0xd2d8eb6d95c82c9e7e92596f,
                limb1: 0x1af36815924628e6172e1f60,
                limb2: 0x9e689188dfd5b831470da499,
                limb3: 0x16a15d4220fff2cb6857548c
            },
            x1: u384 {
                limb0: 0xb13b40ac30cceeb348d46113,
                limb1: 0xbff8746d07d9fab3fccdbab0,
                limb2: 0xffcb2aa32e6db0acbd33677a,
                limb3: 0x702615a8c9965796ec59896
            },
            y0: u384 {
                limb0: 0x5feaedd7f2e573e2b22d888b,
                limb1: 0xab3a1d340e722efaacd69de0,
                limb2: 0xeefd1aa065d6d7c124b4aaaf,
                limb3: 0xc9f7f5c74cac73bf14a58b3
            },
            y1: u384 {
                limb0: 0xcc66aefe62330da619e0f5b7,
                limb1: 0x45b333c70f6000f24cfe1f8a,
                limb2: 0x616cd40e243c33d03ab319ae,
                limb3: 0x152fa453eab94eba93f28ab5
            }
        };

        let Q_or_Q_neg_0: G2Point = G2Point {
            x0: u384 {
                limb0: 0xc3d4540a526aea432c337cee,
                limb1: 0xfad3771827254df38305e4b,
                limb2: 0xf0d5830666b19ddd5d88c586,
                limb3: 0x7982fbb07363cd269c45171
            },
            x1: u384 {
                limb0: 0xa937cc865f40ec4712d527a0,
                limb1: 0xd5957c157d3e37112985c817,
                limb2: 0x197e30de8aa97d3fbd6337b3,
                limb3: 0x18d3b2218b2439d4b6328f01
            },
            y0: u384 {
                limb0: 0x7b0b48ede5961b741925b544,
                limb1: 0x7810c0405cec2965858f0cef,
                limb2: 0x291b0b3f0534a252a6d3b6c4,
                limb3: 0x5b4ac58869f6ec6da58e05a
            },
            y1: u384 {
                limb0: 0x34f75266700b2978e9e0cd8b,
                limb1: 0x21f6383c7fca5734b32d7471,
                limb2: 0xe5fbc7cb4c730ef56d4fda99,
                limb3: 0x19cd1a780fc273258139bf93
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0xfec9787d2a0f12d377727399,
            limb1: 0xd96bad90fc96149530511587,
            limb2: 0x125f0449ff5f919c7c4261f1,
            limb3: 0x125de30362ada60321811ff0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0x1bbc403de76419b8e79ae8b5,
            limb1: 0x6898a668df181e4f394e61fe,
            limb2: 0x4cb6cfc37e49eb8dc3629df7,
            limb3: 0x10e30d0b4d668807a68fabb3
        };

        let Q_1: G2Point = G2Point {
            x0: u384 {
                limb0: 0xb889d6c712218a431f15b76d,
                limb1: 0xb175631d6ca62a60701b9ea6,
                limb2: 0x6138cf93d04fbfedbee4da7a,
                limb3: 0xb380f6823f6395130ae1092
            },
            x1: u384 {
                limb0: 0x1327278ceda12915fd209f32,
                limb1: 0x42e3712604d75fe3e7c52dc0,
                limb2: 0x3a23e0d1b16dc5b9b03dd39f,
                limb3: 0x19daee1b15bef57350a277e0
            },
            y0: u384 {
                limb0: 0x98b3f261c5f87eff12d06ce5,
                limb1: 0x980b5c39de9f56956cf89db3,
                limb2: 0x86cdf49661533e071151de92,
                limb3: 0x16ff82c8c1d76b28e334a49
            },
            y1: u384 {
                limb0: 0x9d270596b9452195d03ce606,
                limb1: 0xc24d532fca10725a112a2174,
                limb2: 0x106f4e7f311e42da1d665a38,
                limb3: 0x17047fd66a1dbb17b140db0c
            }
        };

        let Q_or_Q_neg_1: G2Point = G2Point {
            x0: u384 {
                limb0: 0xbcebe80c9489dd719c25c07a,
                limb1: 0xd324424dc2c2861b93e7bfa8,
                limb2: 0x675a4db5e29c225a09ea6052,
                limb3: 0x1681ba2e96417f0c516ee3ec
            },
            x1: u384 {
                limb0: 0x107d458a85e869463e55888,
                limb1: 0x4d7a28308950724d7dbfd37f,
                limb2: 0xb63250a278a176885f82283e,
                limb3: 0x8075ef5f2d72a3b0e3522ed
            },
            y0: u384 {
                limb0: 0xec2994caa9df00ded5ea11,
                limb1: 0x3f8d692c486dd2b74be622a1,
                limb2: 0x4c6bf5b8a86e890b2d3f11dc,
                limb3: 0x700641ff3020be7f86445d7
            },
            y1: u384 {
                limb0: 0x1df5f725d31b6f936a73fc45,
                limb1: 0x8285b5e801f33f11e54425d5,
                limb2: 0x18f13c602bbeb1002162113f,
                limb3: 0x5e52b62c9b94707ce71e768
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 0xd3b695528c907b5e63528f2a,
            limb1: 0x3260935ca9dc969f8c7b8c8f,
            limb2: 0xebbd44b7f61ad0467097c750,
            limb3: 0xf491079cd7dd454f3841334
        };

        let f_i_of_z: u384 = u384 {
            limb0: 0x10e2e0713b99fbc3325659ab,
            limb1: 0xc4b9ee852253dfc54d9f0dfa,
            limb2: 0xc7e470d99d811b64c3c74f42,
            limb3: 0x8cf01506cb7c5bf0e58cd63
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 0x86e396dd4aaa3cc8dcc33394,
                limb1: 0x452db5bad64d47458f8643af,
                limb2: 0xe02be6509e1a608c8cb10928,
                limb3: 0xf1673c6ece5c7b0ad5fd5a2
            },
            w1: u384 {
                limb0: 0x411b74f7b5dc436b65859df3,
                limb1: 0x60a8db84562207228cf69636,
                limb2: 0xb917e104dfa46fa3aa5d778c,
                limb3: 0x17d89542137a168eb782fe1a
            },
            w2: u384 {
                limb0: 0x4e5d3f4285a819600eab25f6,
                limb1: 0x79eea85726b19dfe85325d46,
                limb2: 0x6f3454e0d61c1fac311f8995,
                limb3: 0x152f6dfaaf50770a2081bc4
            },
            w3: u384 {
                limb0: 0xb0a11815b470b8c2e842be8d,
                limb1: 0x955f35654a1f73ba3579404f,
                limb2: 0xede013c646b339a7d7eaecc0,
                limb3: 0x175e4737ebcb61c01270ff80
            },
            w4: u384 {
                limb0: 0x93a5e78ec99ad9bba38beec4,
                limb1: 0x29735237bf74c16073fb7c3a,
                limb2: 0x468bc9599b09819eb1db0f77,
                limb3: 0x1d86e8c527febc215777894
            },
            w5: u384 {
                limb0: 0x6d7e8c632d2674be2a6ba43a,
                limb1: 0x55966408ede3739857c22aee,
                limb2: 0x25c355dd13ce2f7b02af139b,
                limb3: 0xbbe9c1dab2e8bc1a68f3d55
            },
            w6: u384 {
                limb0: 0x5a469d02f1173924b70918e8,
                limb1: 0x67c6e856d63565fe1c7087e,
                limb2: 0x101c0d4cb33f3fa45cf7f2d5,
                limb3: 0x12bb84019219fe1dd5ee9df9
            },
            w7: u384 {
                limb0: 0xfe5f37d3a6d8179a59a7a4d2,
                limb1: 0x25671f9857916b319835245a,
                limb2: 0xfc3b28bf1b90c25975fc3303,
                limb3: 0x19df35c1bd7e1f96c55dcbc2
            },
            w8: u384 {
                limb0: 0xbef5602eebe36227b3e6b224,
                limb1: 0x8dc68e119f4bb174aeb9c209,
                limb2: 0x21e3aa38729730bbd6846cfd,
                limb3: 0xe484224bb44af62d891a864
            },
            w9: u384 {
                limb0: 0x8ed9acf07b66a9ac60e86101,
                limb1: 0xbbdb799edbe26a9c4f0743b1,
                limb2: 0xa71cbf0fac3a2eabbf5057fe,
                limb3: 0x6cc1f87f55aae577c63747a
            },
            w10: u384 {
                limb0: 0x369b4563506dec11c8bbea21,
                limb1: 0x2080dd12324e04b61c4cd545,
                limb2: 0x69c458e796932effbb522577,
                limb3: 0x187a5c49a0b3730f0a2312e8
            },
            w11: u384 {
                limb0: 0xad2f90737deb9011bbd09a1c,
                limb1: 0x44e829e9bc39066b56b69aea,
                limb2: 0xa129d91bd56be3c954a355c4,
                limb3: 0x364b32df499341a7bdfcf8b
            }
        };

        let c_or_cinv_of_z: u384 = u384 {
            limb0: 0xfafd260ac5440df00080c826,
            limb1: 0xa55f50f65f2f25cb07b62caf,
            limb2: 0xaf73d31f6bcc4c3d4733ef7d,
            limb3: 0xc682d0c3b6803ee940d10cd
        };

        let z: u384 = u384 {
            limb0: 0x1faf39edb6a6668e9543cfd8,
            limb1: 0xbd33307bc984fec7cf001514,
            limb2: 0xc2acf2c98f7d7092ef58e475,
            limb3: 0x845c5d2552a41d26ce38daf
        };

        let ci: u384 = u384 {
            limb0: 0x181a00c0f9e5399e55a0fcb3,
            limb1: 0x71a261d82da2f1939e730261,
            limb2: 0x30ac64c53d115920dfe68c51,
            limb3: 0x166a33f872add5ea1934c377
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
                limb0: 0x845ff34f8ac8016765199584,
                limb1: 0x7513beb571a21514d17eb90b,
                limb2: 0x1830c6846a6075aa1a44e021,
                limb3: 0x13b62b282e8b5dfa47804136
            },
            x1: u384 {
                limb0: 0xf1beb498f03b1b8013d4dd95,
                limb1: 0x4f619681e13af19ae172a99d,
                limb2: 0xcb408784f4134b116a0bd9a8,
                limb3: 0x19a82878a69e1969cc909051
            },
            y0: u384 {
                limb0: 0x6298b4970a9823341247f445,
                limb1: 0xc396297143b2fb57984834c3,
                limb2: 0x62c211fc9dc7eb82fde059e9,
                limb3: 0x183af2c8c7ed9b9954e5964c
            },
            y1: u384 {
                limb0: 0xf4f4d677078a4211b3143160,
                limb1: 0x649f05a98488fd2e353dc4a9,
                limb2: 0x5a26a4107f38f8f91c563897,
                limb3: 0x89b0d51be80a267e89353ed
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x2aebc5203173507a2a24b3e8,
                limb1: 0x44aab794baf1dfc935a79096,
                limb2: 0x1c64cc150d0da87741106d2c,
                limb3: 0x19ebaa9725b657d617840418
            },
            x1: u384 {
                limb0: 0x485f541271aaee7929f76006,
                limb1: 0xc0ab3156cca6077cbd25ebb0,
                limb2: 0xb1d0c9c1a8fc7ca101ce0bff,
                limb3: 0x197ecd323fd261d139c4da91
            },
            y0: u384 {
                limb0: 0xac9a6c431b142b6b5e5dd825,
                limb1: 0xa2c71b8d68dc29f77853208e,
                limb2: 0x4daccdc769c201cb3683dd33,
                limb3: 0x16b8ffda6cbd0d0c45b35870
            },
            y1: u384 {
                limb0: 0x48156562ff0079181b5fdfeb,
                limb1: 0x3a8fbc6c8c9d290a0d3bfec9,
                limb2: 0xad0d9447d6e27fe12eb3644e,
                limb3: 0xcadb5bcc043d35a41631181
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0xe5b92c0460292180c38ddde3,
            limb1: 0xe04045dd899d0552dd57952f,
            limb2: 0x528221070be2fe1a2d74a3f0,
            limb3: 0x8773cf5560cab32d169b178
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 0x425782fc46d8bad7a72f29d7,
            limb1: 0x72b3e428cc890585e6aaf971,
            limb2: 0xeac4025b4f2b6a920905d911,
            limb3: 0xb47b28b8569605799c01d0e
        };

        let ci_plus_one: u384 = u384 {
            limb0: 0xbf8e59c799f61e612083b2b8,
            limb1: 0x51e86151fe7d466cbc77aa1b,
            limb2: 0x732304e800e3ca3f3ea8a3f4,
            limb3: 0x3eb98289b8d0addcc482253
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
            limb0: 0xaccb54e800ff8b112a183608,
            limb1: 0x5b3146b62f7acf2f9fbe505b,
            limb2: 0xe15c9f5bdeaa0c1cc19b2c9,
            limb3: 0x78f3b734e210675bd6b774d
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0x898122bb154959a9295f9050,
            limb1: 0x7af9439753a34be0bc6f12c0,
            limb2: 0x92747f9014dfffd59d9f2090,
            limb3: 0xf2125c537dec6395a28884
        };

        let Q_0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x93cf3e6861086f02d9657db2,
                limb1: 0x9a1c1c2646bc0d80593dc4eb,
                limb2: 0xcf627de69131507d92f42460,
                limb3: 0x145499bd3df4a0660907a963
            },
            x1: u384 {
                limb0: 0xc366453b015214a0a983b50c,
                limb1: 0xe3e57d420711f067813fbafb,
                limb2: 0x2d0b587f1320cceb01007f9b,
                limb3: 0xebec24a5c856338a5190d02
            },
            y0: u384 {
                limb0: 0xd5367d0ef58d588bf6506f8b,
                limb1: 0xd0bfe8d4bca8b8d9baa63bea,
                limb2: 0xfe757f702f809c68765d55d0,
                limb3: 0xee797275e785c79d88f5ad0
            },
            y1: u384 {
                limb0: 0xe1312ef910e8480f29bfc91d,
                limb1: 0xd005155c763f6720dde94e8a,
                limb2: 0x777f4a56070cd0e8dd175fb5,
                limb3: 0x13ecc45dd6b2d1e3627bf978
            }
        };

        let Q_or_Q_neg_0: G2Point = G2Point {
            x0: u384 {
                limb0: 0xd286925f24850451406baa6,
                limb1: 0xde523800767243a5c59e8235,
                limb2: 0xd53080d7956c7124d274d21b,
                limb3: 0x124b2dc11cd8732215206eed
            },
            x1: u384 {
                limb0: 0xa9edaad7d9eb8211272e1601,
                limb1: 0xbab2d8ab2818e27a7081aef6,
                limb2: 0x1ff6cf9308db1e3e915c4259,
                limb3: 0xbf2d8f66e9f29240b3584ff
            },
            y0: u384 {
                limb0: 0x753d547a2d5ac28cf8c6c01f,
                limb1: 0x6acff5187e76789b02bc47b9,
                limb2: 0x98a9c93322efbf628a60b6d0,
                limb3: 0x175dcce7042b565ba0ebeb14
            },
            y1: u384 {
                limb0: 0xb266a8c423d7a4feed3a7630,
                limb1: 0xaf32a021b9d98f30f25e89ae,
                limb2: 0x1c0b6453672f6eb9ee8530d4,
                limb3: 0x111ddf8081b02aef1fd0b1c2
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0x3f78ee36b5f5cf3e3ae75934,
            limb1: 0x1d697cd0066213bd98d61ed4,
            limb2: 0xc4f56173d7f0ab2faa375772,
            limb3: 0x140d810e848ca5015247332
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0x9ce81fa7a7a27fbdc50fc900,
            limb1: 0x30f1568ef154bf5f53bab3ba,
            limb2: 0x50c736d91d3cec2d5d67751a,
            limb3: 0x72bbe855172ef9120d4cc69
        };

        let Q_1: G2Point = G2Point {
            x0: u384 {
                limb0: 0xcbb065fda2ede5b9688778b,
                limb1: 0x8b18570b864364a8af9665b0,
                limb2: 0x9459014219e14e1c7d727b88,
                limb3: 0x152f0654eec3259121812e11
            },
            x1: u384 {
                limb0: 0x3ea2068a56e6a8c3e05d9b49,
                limb1: 0x69cc71a29589eff6444b542e,
                limb2: 0xef88a6fda58db4e449a3421c,
                limb3: 0x8b57c19f93b32a5175198f
            },
            y0: u384 {
                limb0: 0xee653a5ba8411ab0ba8c70b4,
                limb1: 0x4b2aea55ce59991f79fffcda,
                limb2: 0x26c47308c9fd57dcedb8acba,
                limb3: 0x63f502e4267f803ae3fa2e5
            },
            y1: u384 {
                limb0: 0xd8ac9d0604283ad0df038544,
                limb1: 0x4ed60e1cc4909ed77d5a1b03,
                limb2: 0xdac826fcf54afc1fb82ecce7,
                limb3: 0x4287c579a0d008c043feee
            }
        };

        let Q_or_Q_neg_1: G2Point = G2Point {
            x0: u384 {
                limb0: 0xba294b5f5eba922919b0cf26,
                limb1: 0xdea68ebf3f36b7c9ce31f7c9,
                limb2: 0x8f50e84fa5d5d4ea9becd0ef,
                limb3: 0x632011f639c44623d69462c
            },
            x1: u384 {
                limb0: 0x62aab24cc701315ba7cec506,
                limb1: 0x2d2f9d86189ab90def3e0728,
                limb2: 0xd8cc46b14151c48bdc47f55e,
                limb3: 0x5644135486f43d91980da38
            },
            y0: u384 {
                limb0: 0x226fcd30db10c7898f5c1488,
                limb1: 0xdda6cb0bbceeb65e93e315fd,
                limb2: 0x6213c72769aff564748f2247,
                limb3: 0x768fa19ee73d0ad6a080f1a
            },
            y1: u384 {
                limb0: 0xd7c9fbca8feb23f7d3d9bd05,
                limb1: 0x1495d728ce68a5d4d427a7e3,
                limb2: 0xe73b925017db48e4ba159c23,
                limb3: 0x9d5dbb951c244e76da2ca98
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 0x6a5838947f8e4ca5eb6809b3,
            limb1: 0x69633870c0c9a8fefd0ca4fc,
            limb2: 0x789dba646720fb7b58f21de4,
            limb3: 0x109327f3fb1908e65e2f858
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 0x5209b417482459ab1dfed51f,
            limb1: 0xe7f90dce0dba80948608927b,
            limb2: 0x53b56c254d829f38500805e8,
            limb3: 0x13ae797d13d0abba7d7d5c0a
        };

        let Q_2: G2Point = G2Point {
            x0: u384 {
                limb0: 0xd75d9659207945e39329393d,
                limb1: 0xb4c7b4579c49815c08900b58,
                limb2: 0x3fdd041164e51eee1ac1a074,
                limb3: 0x762846d4bdd595c0099319c
            },
            x1: u384 {
                limb0: 0xba8f667e19bcbfa64fe97f7b,
                limb1: 0x46a1d79c6b5f837d62edc378,
                limb2: 0xb2087dcac78971a21050c962,
                limb3: 0x9380cdb39f9978903dc25c9
            },
            y0: u384 {
                limb0: 0x5f4f8478e02ddeafdc9dcb2,
                limb1: 0xb6d4af46d1e16baa1222512c,
                limb2: 0x441bad98970e912d82b3c4b0,
                limb3: 0x735e8422748ecf9d32f3c68
            },
            y1: u384 {
                limb0: 0x49430a013ce4046834208249,
                limb1: 0x157d620e105699e2c7fbc910,
                limb2: 0x38d0b720e2dc6a77ddbbcafc,
                limb3: 0xbd5cea111af0c676be8137
            }
        };

        let Q_or_Q_neg_2: G2Point = G2Point {
            x0: u384 {
                limb0: 0x214c9ccdc1a616c67ddf6984,
                limb1: 0xdf417dee5aa8537fc1921dc9,
                limb2: 0xdde06374cc777ea8dffa2389,
                limb3: 0xc3dcf8ef35a27676cd8efb1
            },
            x1: u384 {
                limb0: 0xe05d3ab355414aa0a604f9cc,
                limb1: 0x22c86a4976ebbb2ec614d73c,
                limb2: 0x9bbe90a0a4d4ee9b9de75046,
                limb3: 0x18729f8bf63dd4de01ee3858
            },
            y0: u384 {
                limb0: 0xcacc49bd85dc362d47079ff4,
                limb1: 0xc81fd054ff72a5bdd8d5adb7,
                limb2: 0x4d1e460c9ab97caa1db9203f,
                limb3: 0x15b6e40b77aa0409e7d6a5cc
            },
            y1: u384 {
                limb0: 0x31c9ebb2b4f1081f6284e14f,
                limb1: 0x1a2ae0533ff6c7646164f1a7,
                limb2: 0xdace7b368768dbbcf923e49,
                limb3: 0xa381996d0ebc1e41067b9cd
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 0xae72bf3e4ee79c5a55fd0bb8,
            limb1: 0x20d04ce1d581f8282a4f1798,
            limb2: 0x3de609e2074712fc9efd4e7b,
            limb3: 0x14ad2c12b24eb3ffa0f6eda7
        };

        let f_i_of_z: u384 = u384 {
            limb0: 0xf7e9981d1b8df614d7d5a664,
            limb1: 0xb215d0af7922e9372b56cdb2,
            limb2: 0xc1d08108c5e93d79690088c1,
            limb3: 0x1676534637e28bfd431c912f
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 0x2bae5e564fa65a066a07a3b5,
                limb1: 0x748d738b196e9e2615e65881,
                limb2: 0x475d72ca20a4c69c94aa04b,
                limb3: 0x53f3706b3ed65834a169a17
            },
            w1: u384 {
                limb0: 0xeffcbec2de606410d11ee3f0,
                limb1: 0xa375232cd544efced8849876,
                limb2: 0xf3e3c451d71a4448cf1b975b,
                limb3: 0x4da61f962f8237a2066cae8
            },
            w2: u384 {
                limb0: 0x1cd3b7c9b2c6e2e23bf497b2,
                limb1: 0x319e071d267dad136368a611,
                limb2: 0x5fa7c3757c923fb029ec1824,
                limb3: 0x13fadb2b91ac8823e847ca2b
            },
            w3: u384 {
                limb0: 0xc2c002ed043143651acaa971,
                limb1: 0x62b95e67cf5737e4b3ea4c2d,
                limb2: 0x687b6b0edb12964c06bf1271,
                limb3: 0x820d40a44aa3194da2a6cb9
            },
            w4: u384 {
                limb0: 0xc5a0b4f253aff0abf4b41cb3,
                limb1: 0xcf676e0c82eb1c23b6bd43a7,
                limb2: 0x16b8260c8f9a028f8b749445,
                limb3: 0x1791b0435a74a8f73504bed8
            },
            w5: u384 {
                limb0: 0x1728e0d3c16bde7f67e3055c,
                limb1: 0x10e68f8ca77ff11f9b016a33,
                limb2: 0x9e1a824f139dfab382eaae3a,
                limb3: 0xc6d299c095969974e18adf1
            },
            w6: u384 {
                limb0: 0xed834f1693e553e407197bf1,
                limb1: 0xf0fd1659e352ac87ccc92754,
                limb2: 0x6943216a6507943e82c0777e,
                limb3: 0xb13932d1908ecc5d070edb7
            },
            w7: u384 {
                limb0: 0xc8d939fbf4c06eabd57c725d,
                limb1: 0xd94decd0a83baf0436dfdf93,
                limb2: 0x7e9d98fdc0fef09acd63b97e,
                limb3: 0x1978d62cd5ad1c81c6bc1e2a
            },
            w8: u384 {
                limb0: 0x1199333c0927717d2ca222fd,
                limb1: 0x2304fc2b8c363beb3038fd2f,
                limb2: 0x9436ff9744d548ce8eeedc3c,
                limb3: 0x5ef7c8a3af52271702e935a
            },
            w9: u384 {
                limb0: 0x1ef962947a41021064d5cad2,
                limb1: 0x44a2f730d004e247455d1cb2,
                limb2: 0xa6034d21be15b5bbd8effa88,
                limb3: 0x23e08b1f767cead6a00246f
            },
            w10: u384 {
                limb0: 0xef7f2069a74c1b1ca0e52358,
                limb1: 0x828a85e0ce8d38748f7a6394,
                limb2: 0x5f1078cc61621fdce5125633,
                limb3: 0x322ca1c1800201a9cc6d351
            },
            w11: u384 {
                limb0: 0xa3f01dcdeb88fa94253b6e44,
                limb1: 0x38625239ca32c0814aa970f0,
                limb2: 0xcac9f43ae37cc4c471133be3,
                limb3: 0x6288111adf8dbc897354c9f
            }
        };

        let c_or_cinv_of_z: u384 = u384 {
            limb0: 0x3064f0fc7fc071bd346d4398,
            limb1: 0x325ac15c33912a649ff3c8b2,
            limb2: 0x4091e5a86ecad5f5447dc5a8,
            limb3: 0x180915618b652d308bf83124
        };

        let z: u384 = u384 {
            limb0: 0x92c56f2e41617be93cdcb82e,
            limb1: 0x9db02d929f141ca27a81db5e,
            limb2: 0xa986778f237f91cbcc28ae3d,
            limb3: 0x15dbc41ac36b07d0fae54cb4
        };

        let ci: u384 = u384 {
            limb0: 0x72c511b3f4c89fc7c926c46,
            limb1: 0x1345a19c54cf8fd3a4f8b342,
            limb2: 0x7b11568ff1ebce9ba07edc25,
            limb3: 0xcf86407eb43f541fb4e0524
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
            Q_0,
            Q_or_Q_neg_0,
            yInv_1,
            xNegOverY_1,
            Q_1,
            Q_or_Q_neg_1,
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
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 0xea9b630a856768b137f2695,
                limb1: 0x2dd3aa6ea5f597c579f06831,
                limb2: 0x47607e3b98b9b95bb489586e,
                limb3: 0xf7c53526d64dac9e6f3d29f
            },
            x1: u384 {
                limb0: 0xe72e1e661ba3ea30038c75ec,
                limb1: 0x6f27faef2e28fc26525fae35,
                limb2: 0xfff65b72ddc37ba4050dfd41,
                limb3: 0x15a115ddeb1ec81150d76823
            },
            y0: u384 {
                limb0: 0x1164b28f9b26d89d6749bf9e,
                limb1: 0xb595879c5c6bd035ce9e7955,
                limb2: 0xfb5f878b6e85fc7f07bb28fb,
                limb3: 0xe109f4646b78d61fa03e257
            },
            y1: u384 {
                limb0: 0x9bf3be78720616098bda8cdf,
                limb1: 0x2524ccf74f7eabebce0bdf25,
                limb2: 0xba9801731a435a85c5586318,
                limb3: 0x36b9391cb47222fcd55e866
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x62e28c7fc56cbeec76dce714,
                limb1: 0xe4aa46ab31eba636af2b58a2,
                limb2: 0xa65fecb5e4575060100096c,
                limb3: 0xd42c27171d96642ca61eae7
            },
            x1: u384 {
                limb0: 0x65ef97602562345dc8ce1b33,
                limb1: 0x39ad1e6587efc77ffe2ab300,
                limb2: 0x1458d6c126bf292d068e9517,
                limb3: 0x157ba65dcaab1711ea02729e
            },
            y0: u384 {
                limb0: 0x72765576f711b5451971d2b1,
                limb1: 0x4590138663ad5c6dc637d146,
                limb2: 0x199c3459c414090b7f1baf23,
                limb3: 0xad3f1440dc89b78cdffc06d
            },
            y1: u384 {
                limb0: 0x773e70f360e5161250eb6bc8,
                limb1: 0xca7e0d4236dc057107d363f1,
                limb2: 0x8c79673cf23cea800ad09061,
                limb3: 0x14a4ef0b90651dae4460e8e3
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 0xb6b4039d23292183654cdac0,
                limb1: 0xd5fa541c615aa6138f0dba63,
                limb2: 0xc950bca12109420ab3c3e02c,
                limb3: 0x177eee7ab72b92a3af5d48f8
            },
            x1: u384 {
                limb0: 0x5008380088d27b57569e27d1,
                limb1: 0x68af0378ac92baeecb48917,
                limb2: 0xfe4603bbe6ad5c146ca5d8eb,
                limb3: 0x977375533bcc9c9cee9d999
            },
            y0: u384 {
                limb0: 0x30e98a3756c6e0ffc0fcd5a9,
                limb1: 0x99186a778888821d017ebcec,
                limb2: 0x1ac5797307747605742ea6d9,
                limb3: 0x9aa6b0bb2cb8e7ae8ff86d0
            },
            y1: u384 {
                limb0: 0xca8575f70be3c338ac760916,
                limb1: 0x86698a30b390efbe6da2a374,
                limb2: 0x3f6b47c04d423dafea82ed89,
                limb3: 0x10c8f8d451a392b1f6165389
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0xbabf4a5ec70db42a3bc5327d,
            limb1: 0x94d0cb25b65907bcbaff4d07,
            limb2: 0xfb55bceea7152fb626bec0d1,
            limb3: 0xe17136bcfd159a6ac9c43ea
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 0xcf5db656064fb9107afd8717,
            limb1: 0xbc152fba7e80b4b080807c6,
            limb2: 0xc3ffa59d8d20ffea8fabb0ad,
            limb3: 0xc4b757329510038720b9a96
        };

        let ci_plus_one: u384 = u384 {
            limb0: 0x9d4d228120f8ec8dda86a00f,
            limb1: 0x1aeb58a86b3e8d79a7ce2513,
            limb2: 0xe99ef49031274fac8bcb7577,
            limb3: 0x174a939f340cc560d0d5259d
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
        let R_n_minus_1 = E12D {
            w0: u384 {
                limb0: 0x25a9bfbcdd9e635f5b4ce327,
                limb1: 0x2ae49aaa2ea6d7bfcac57b0a,
                limb2: 0x4273de5a4028539cfe00e4e7,
                limb3: 0x97b61799efa5314a5a07481
            },
            w1: u384 {
                limb0: 0xdd18313f4dd477808b6653de,
                limb1: 0x25d273d0f1e0d2253a555244,
                limb2: 0xed8a0f5048a07c42e082509,
                limb3: 0xfc829d32bcbc88f73b470e9
            },
            w2: u384 {
                limb0: 0xa4ce14faa73a18a4a8585dde,
                limb1: 0x54bacbb01fb63e69206bce67,
                limb2: 0x308718f06fddc66b5ee45153,
                limb3: 0x62526c544889e691570c716
            },
            w3: u384 {
                limb0: 0xc8fb4d3a8dc121762880c285,
                limb1: 0x77248745125a75937e273807,
                limb2: 0x775c20e992ba0599fe4c7b1d,
                limb3: 0x10557434bc7baeeae11af49
            },
            w4: u384 {
                limb0: 0x4de55170615ab7c2d7d2b534,
                limb1: 0x42efaa5d8cda63089757197d,
                limb2: 0xd78c5c69ccfba69ea2961b71,
                limb3: 0x14a76609babcea6b973dd58b
            },
            w5: u384 {
                limb0: 0x3a858175b56a820f2c649a33,
                limb1: 0xe454a72e5e5ffbb79b6d3d8,
                limb2: 0xc9ae326db1cebeff18ff6914,
                limb3: 0x1728325451191ddb99fc1f04
            },
            w6: u384 {
                limb0: 0xf5bd2a621f55f27a2b003687,
                limb1: 0x12296f326e448971dc2fd37f,
                limb2: 0x27bace697a6060a8d4fb1630,
                limb3: 0x5a93d9065ba2571d6036419
            },
            w7: u384 {
                limb0: 0xd64cd61a3769512db812ade,
                limb1: 0x3ba2cf1686863e50b8a8d409,
                limb2: 0x2e57aaa0803fd85afcad455e,
                limb3: 0xd1cb2589f3b139d140ebcf2
            },
            w8: u384 {
                limb0: 0xa9ac3915bee9db39b0343d89,
                limb1: 0x2ae4f71bf91e6fef2d58cc88,
                limb2: 0x5ad685414605dc4a549fb214,
                limb3: 0x938f93d3bec04806ec688d4
            },
            w9: u384 {
                limb0: 0xe9350d7ac4a185472c2b9c07,
                limb1: 0x900a2b50d3582dfd87970657,
                limb2: 0x17c7e8556c0a552c9b7a43bd,
                limb3: 0x5a628a43eb853b5b2ae050e
            },
            w10: u384 {
                limb0: 0xbf6c4df4535bcb4849cff23d,
                limb1: 0xf337fa387814041d98dd12df,
                limb2: 0x3fae217e9e2d720d2fc0f1f7,
                limb3: 0x293e72e0502629d81ebb561
            },
            w11: u384 {
                limb0: 0x8e9a6a56e6aae560a18df6f5,
                limb1: 0xb6107a8789cd47109c65836e,
                limb2: 0x461c460a0eb23a8c6de8e22d,
                limb3: 0xa7f5a83b84b659db0909f10
            }
        };

        let c_n_minus_2: u384 = u384 {
            limb0: 0x53fdce6f7c7bec0092bb179,
            limb1: 0xd5243973cb8e1c51ee31aabc,
            limb2: 0xafe03071b278bbd57a299619,
            limb3: 0x14a981e4f7d2c9026490e67c
        };

        let w_of_z: u384 = u384 {
            limb0: 0x387c8fe7669a0321b88d3f79,
            limb1: 0x9c41905ab65642ef68a63a69,
            limb2: 0x6a71a0e5246b21c45efefc73,
            limb3: 0xbbd2a8e4d609cc6c2f99167
        };

        let z: u384 = u384 {
            limb0: 0x5fc8b9cd1269fc4d5dbcc6f4,
            limb1: 0xd1278f8bbb9f7d3f29162246,
            limb2: 0xd91ceddba5e4554012e6fb90,
            limb3: 0x10bd3d869abb8c145cf9cd2f
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 0xaf079b76f2b762c63ae8446f,
            limb1: 0xfe3a2fc50b81f5956109e517,
            limb2: 0xb63fcda0e7a3bbc71b078fe5,
            limb3: 0x4a25d34cd9f753a37d132f8
        };

        let previous_lhs: u384 = u384 {
            limb0: 0x36aef2f829ff46216041c0e9,
            limb1: 0xf78ef166fb2fbde51c30ebae,
            limb2: 0xbaa227b8b398d5d37da69555,
            limb3: 0xc803630301f51243d17bfd0
        };

        let R_n_minus_2_of_z: u384 = u384 {
            limb0: 0x60b8024401e323542ebe8dcb,
            limb1: 0x9babbdab0e1cae7a8122fb3a,
            limb2: 0xd44b5548066dee1ea16b347d,
            limb3: 0xf0cedf8188f4a1cf0eb1008
        };

        let Q: Array<u384> = array![
            u384 {
                limb0: 0xe10866bb4210074a2f81acd8,
                limb1: 0x821593c8c44ac09a7900f113,
                limb2: 0xbc6d374a86610b8d449c8ebf,
                limb3: 0x1391c9885a2206aa3612461f
            },
            u384 {
                limb0: 0x8332a1006aa6e238db1b03f3,
                limb1: 0x16e4dd6a125ac749c9d92fac,
                limb2: 0x84dc55da90ebda85b9f7303a,
                limb3: 0x147c99496d0f744c15261ab5
            },
            u384 {
                limb0: 0x4ddfe9ded4e3d24c834a3646,
                limb1: 0x9c9e2ae3df58908fdf40f5b5,
                limb2: 0x2d4750cca5c5063d4c444d95,
                limb3: 0x1521147520adb06ec77239f2
            },
            u384 {
                limb0: 0xbebebbfc089f8b86b99e73e5,
                limb1: 0xb26215e3c79a4ef8262b8ae6,
                limb2: 0x4bd55c6428e52c6afedaceb7,
                limb3: 0x122d229e539a42df0b1f4488
            },
            u384 {
                limb0: 0x797dc4fafd72919c88195c6a,
                limb1: 0xa4291bf9fdee42989056845b,
                limb2: 0xe6567325f7cf0135bc659d8b,
                limb3: 0x1627ba3e84cc31aa5727ff52
            },
            u384 {
                limb0: 0x249cebe029672134dfdd8e2d,
                limb1: 0x7c83153ed11c91f7017b49cf,
                limb2: 0xcb1d6d783c0665522e499493,
                limb3: 0x17ef6d67b1ca41c30061d029
            },
            u384 {
                limb0: 0x7f8717173279b20951161305,
                limb1: 0xec5b03af8b90e059cc1590c6,
                limb2: 0x8057b53792ec01d0f2bb8a67,
                limb3: 0x136493f4b2645654489d80b6
            },
            u384 {
                limb0: 0x35002e801037942231692d4e,
                limb1: 0x20794c13356b26ec43fdda8d,
                limb2: 0xefee2b4dcf557be2da4e2130,
                limb3: 0x8533e75009253058bd1d055
            },
            u384 {
                limb0: 0x6e832e1c7aeaf473182c571c,
                limb1: 0x53efae0a9604a5e1984a2ba3,
                limb2: 0xaf5c74049d2fbab283b041ae,
                limb3: 0x19b90d52f86f6f663276fd7c
            },
            u384 {
                limb0: 0xc5cf2c4d81b2ca08056d5f98,
                limb1: 0xf47fa32ec3e0237de427211a,
                limb2: 0x42ead84ceccc2372b4703ff7,
                limb3: 0x99c9c631b94f93a4683fbd4
            },
            u384 {
                limb0: 0x1eccdba65e6d0b5b590d830,
                limb1: 0x640bbb28c322b4ff856df911,
                limb2: 0x2b73a1011493c30fde9ac8b8,
                limb3: 0x4f4c06a3af1aead3f4255c3
            },
            u384 {
                limb0: 0x6195ace68506d5ba50fa59aa,
                limb1: 0x6714224cf95cad473b5a4257,
                limb2: 0x51c756d46dda6925c6d25fcc,
                limb3: 0x14f681253f2661915a094c05
            },
            u384 {
                limb0: 0x5f1e2cb74af1d4e748cf1902,
                limb1: 0xdd37a7eb07323bec29e36d71,
                limb2: 0x64864cee10710096cf60fea3,
                limb3: 0x780a05838bb43b973bce2b9
            },
            u384 {
                limb0: 0x1ef0e207914f8df656d1578d,
                limb1: 0x2c8271c45d9b354a261e1ad2,
                limb2: 0xea3e943acf6b084a5ca01e74,
                limb3: 0x7734c2e95fcab15a4d6f5c8
            },
            u384 {
                limb0: 0x3ebd35faaa2696d267a31a9a,
                limb1: 0xdc4c1c117fe932723d98c0c9,
                limb2: 0xa80774606da638b20aee4c8c,
                limb3: 0x168d8a9457630d700eb7e062
            },
            u384 {
                limb0: 0xe81807cd80a1c19ce19b6dd7,
                limb1: 0xc06e8bcd0fab981ff7b9819d,
                limb2: 0x199ac482ad2a5d175f3926a7,
                limb3: 0x146146ecb8d270ab44337b93
            },
            u384 {
                limb0: 0xc039c71e00af620cd7cff1ba,
                limb1: 0x22c88c0b563146c9cbf0c64,
                limb2: 0xc1611767728a85434a974df5,
                limb3: 0x1c43455357c402d749ef679
            },
            u384 {
                limb0: 0xf8245ab5643dfa155fdb1c8c,
                limb1: 0x8c64ba42df6b038dd15d0716,
                limb2: 0x198326f161b90490ce40bea6,
                limb3: 0x19b178956c6df33b1d936af5
            },
            u384 {
                limb0: 0xd29f27d517e03c95aa6178a7,
                limb1: 0x8fea8d99255e73aa3ac1781c,
                limb2: 0xf69c05fd61d25a03c9467b1c,
                limb3: 0x6f230fea28e9420e31d4f7e
            },
            u384 {
                limb0: 0xc5e81460b965f4c904dc6357,
                limb1: 0xf8e1e617442e0f189fc6ec71,
                limb2: 0x23371a3f90f084af134d8480,
                limb3: 0x1746249b44f10516485964e5
            },
            u384 {
                limb0: 0x97b2105ee3c763d29974088,
                limb1: 0x3e8f4d3c61636f8113d1ab6d,
                limb2: 0x6215b52235b7df751195f1f9,
                limb3: 0xe3afd8ac5b5d451cdf3b232
            },
            u384 {
                limb0: 0xbe66203207f61f43057ed87b,
                limb1: 0x36c4e48f436bd6b061718776,
                limb2: 0x9256b4ee103eaba1de750cb9,
                limb3: 0x11258695926447881a959ee0
            },
            u384 {
                limb0: 0x19a7a36e417e7aece8dd9dd6,
                limb1: 0x5380aebd6ee4fa35761211c0,
                limb2: 0x61d00b6b8974021b353df269,
                limb3: 0xdc27a1d08c70e515452dd38
            },
            u384 {
                limb0: 0x157586ff3ef5d61d8e19c50,
                limb1: 0x822adcfbbd328d136c80e406,
                limb2: 0x9f4933579b21db098119eab1,
                limb3: 0x1b6bab60286a463c5d1feeb
            },
            u384 {
                limb0: 0x6cf20ece3911f9d7af1b0f0f,
                limb1: 0x3ed2b25dc4cd88919e4f55e5,
                limb2: 0x5e0e02828ff746524db8f463,
                limb3: 0xca17893d65acedf7ef1748c
            },
            u384 {
                limb0: 0xabe757d29462fc24fb7d8c44,
                limb1: 0xb70b67bd5c00fd95a37ad445,
                limb2: 0x7296678be769b2703210b2e,
                limb3: 0x1891ecf99adfc67d122ed948
            },
            u384 {
                limb0: 0xe13b9a759ec8d0b94cf2032b,
                limb1: 0x4381c0c705aa5e4043a0944a,
                limb2: 0x5ddd1f48b7fec468ccefc4c0,
                limb3: 0xa9395722e43c67ac5dc12d6
            },
            u384 {
                limb0: 0x5afd108b76299eef55bb9c97,
                limb1: 0xaf88cf098c91cbc1724ae567,
                limb2: 0xc21dce782e9c3e526eed8317,
                limb3: 0xfa7dd50c6ef6bffb6cfbac7
            },
            u384 {
                limb0: 0x4597d0edede780b6b1190ef,
                limb1: 0x162e6aea5800fe0c2b46ef4,
                limb2: 0x3e62c557289e78f0790a3b6c,
                limb3: 0xe6540bf3d1f871988447e64
            },
            u384 {
                limb0: 0x9aa9e11ebdedc9b278d2e177,
                limb1: 0xb00deabc21d5e2df65a1158d,
                limb2: 0xec8dc105c217fb0d681877f3,
                limb3: 0x9b4e448591782010accfc9
            },
            u384 {
                limb0: 0x4116bcf75c47ac00898b79ba,
                limb1: 0x548fe2b7817f3ae784cef46d,
                limb2: 0x54101fe96ca3110c29438b5b,
                limb3: 0x2bbbc63b9e44e0e3fab9169
            },
            u384 {
                limb0: 0xa5a4f86307bfd62470b3b8d1,
                limb1: 0x18e72189e41816d6ffcc5f07,
                limb2: 0x5e688624a0ea9d77fda65740,
                limb3: 0x161427ad42b6d03fd09e999
            },
            u384 {
                limb0: 0xba64fb01676c5c21513a81ca,
                limb1: 0x95b57021ff744ba71ad9ec63,
                limb2: 0xb3a97280a27f0e232afcfb18,
                limb3: 0x11a100fb6b488c4517485c67
            },
            u384 {
                limb0: 0x39ff2d02511b6c2825903f2e,
                limb1: 0x6717d0f28169460f6224e485,
                limb2: 0xe3039a8818028380336287c5,
                limb3: 0xa2c19563023aaadd550f277
            },
            u384 {
                limb0: 0xb427f0e67d7b6e7b00def56f,
                limb1: 0xac61c15b6b4601e6609693ab,
                limb2: 0x828b66a3e1c91e7a6437daf2,
                limb3: 0x41487a96f44b80e7ccee7ad
            },
            u384 {
                limb0: 0x53719155ec2b3b43738a67ee,
                limb1: 0xf8e081d5e5d3fd8b4402d7c5,
                limb2: 0x92902d31ade2cc4429f623bb,
                limb3: 0x7674622bd0540948ca7ccd8
            },
            u384 {
                limb0: 0xc4d4f727a77d3e06d17c3a69,
                limb1: 0x61ff5114132c80e82d2ad083,
                limb2: 0x7919ce67f9921fb22e576628,
                limb3: 0x68b93c32c7fcbfeef73ba0d
            },
            u384 {
                limb0: 0xbc4481214e50ae44e08b0d97,
                limb1: 0xd329426663865c86a9771794,
                limb2: 0x27536fb5dc37e351d9940829,
                limb3: 0x194c0a47a2cb48b529fb62b0
            },
            u384 {
                limb0: 0x33c71c2c29bc0aad0c703c63,
                limb1: 0xea152c5011fd66061c9c6f09,
                limb2: 0x77bcc6ea587e681c4b6d6ec3,
                limb3: 0x295f7ae82475b362c504bd1
            },
            u384 {
                limb0: 0x34747c7592c2674a70b281be,
                limb1: 0xe6667051673cde976c045b1b,
                limb2: 0x208c5fb2fede268b601e3e70,
                limb3: 0x13a23bf4845857ef98144476
            },
            u384 {
                limb0: 0x2f9c79b11ad02fba61203611,
                limb1: 0x6fdb2d547d0dfcc63a38dc11,
                limb2: 0x40162ad0079720d163aa09e3,
                limb3: 0x16fef66d68bf06b128220647
            },
            u384 {
                limb0: 0x7b23d692e0e3ea858a011217,
                limb1: 0x1d67ce222d42ec4ed1f4d64d,
                limb2: 0x81e3e1ba88a04d54dd1d44e8,
                limb3: 0x81f5d98ac48ca59c95c2b40
            },
            u384 {
                limb0: 0x6c9cae6f84181131700c85e8,
                limb1: 0xb27678bd4d818bfd9e9ba22d,
                limb2: 0x8919bf684b624c5a23866906,
                limb3: 0xc589f13ff4751e266f136ea
            },
            u384 {
                limb0: 0xc2f2eacf4882bb7207e8455e,
                limb1: 0x90c68ef8442437cdcdce00a,
                limb2: 0x82dade1dd995ab9b9715dd88,
                limb3: 0x1e8ba033b8e4413408e1b98
            },
            u384 {
                limb0: 0xb7bce3ef85f79731c6d80cc2,
                limb1: 0xe288137e2889d205932714e0,
                limb2: 0xadc5b4d63c6a7d4a384f1130,
                limb3: 0xa3fa0396e1987f4f89f29a3
            },
            u384 {
                limb0: 0x9525f6442748af0fe38df1c,
                limb1: 0xec5a35f49cc6bc683e2d31cf,
                limb2: 0x4f2cfbfa84d586dbca2e255f,
                limb3: 0x186bbda0f3299c8410c68cfe
            },
            u384 {
                limb0: 0x51a437a8983e05143eb74425,
                limb1: 0x50a712766721a7de2fba0022,
                limb2: 0xa588907e42451cc812b53dba,
                limb3: 0xa473946b2aaf6eb4cd59c36
            },
            u384 {
                limb0: 0x16f3c7a4be8b9fbec8538af2,
                limb1: 0x7bd6049533d5a4b8804c0cf,
                limb2: 0x888b4cedeebaad699723d6fc,
                limb3: 0xef572eba717743f4adb2666
            },
            u384 {
                limb0: 0xde4d0f1518d9222877e4b1c1,
                limb1: 0x7338afecec1b6b54fe80379c,
                limb2: 0xc7bd852797c676fc70b4229,
                limb3: 0xd23f830239c25060446b47a
            },
            u384 {
                limb0: 0xe46d4b78d0584a2e2d3e176c,
                limb1: 0x3d39e62900c5e0491cf9dc02,
                limb2: 0xf69123bfc07dcd7d65519801,
                limb3: 0x1403a356f00a5cc469965ee7
            },
            u384 {
                limb0: 0x88277859bd025676d187bbae,
                limb1: 0xc43fbf37589d431a01de1868,
                limb2: 0x9b329a60ceec7e2dbbdfd2a2,
                limb3: 0x11220ceeb09ae37f8790e11d
            },
            u384 {
                limb0: 0x807948fcd352f3bb90afee6c,
                limb1: 0x240c7fd7616f54d5c964323d,
                limb2: 0xf82e0077a1960dfdd89c848,
                limb3: 0x6de30b89e7e9fa3cafe4d5f
            },
            u384 {
                limb0: 0x95954e636138a502a0c460ab,
                limb1: 0xfcb6865b2e70b419464be134,
                limb2: 0x7ada2270b8ed5f6c6d043ca0,
                limb3: 0xed126a1a7f1866f081fdb40
            },
            u384 {
                limb0: 0x17484236f44d01617e58c554,
                limb1: 0x852bc3a8066b2e6ba10680a0,
                limb2: 0xbfe50d0059cc48be94c4a878,
                limb3: 0x196b4784291de460b3046f32
            },
            u384 {
                limb0: 0xc6fc46ee0e278f2e25b7d199,
                limb1: 0x68144468fa588902e3ac24bc,
                limb2: 0xbbcfb3c40e831ee851b187c5,
                limb3: 0x12d694aea938ca56b6719865
            },
            u384 {
                limb0: 0xae59eb71a4e7fafb804999ab,
                limb1: 0xa2a2904c7a0b3e46a8b3d59e,
                limb2: 0x243974b873914b538c95b40f,
                limb3: 0x348f695ffb4d662d44db1d2
            },
            u384 {
                limb0: 0x67c0a54fce90746c27258a9c,
                limb1: 0xcf33fafd1d83973df8c743fb,
                limb2: 0x38e4b0ca97baf2d159e811da,
                limb3: 0xcdb7285f7dc765031c8276
            },
            u384 {
                limb0: 0xdc9e1b0fe4276715e43c94aa,
                limb1: 0x1946e351e19c68356ec51b3a,
                limb2: 0xef0567a918161478b9fe5c7c,
                limb3: 0xb1fb1f4ec297ce228db3bb0
            },
            u384 {
                limb0: 0xf8adeac04d4395b9ccb6bd76,
                limb1: 0xa1a29ea2af6b3ccecf2a2f32,
                limb2: 0xcb1e869a2ba78a3fe8f46e01,
                limb3: 0xc72fefed5ccb9f687b0c749
            },
            u384 {
                limb0: 0x3aaadbe669946bed26fef269,
                limb1: 0x1f0d36012ce4540049bf1bd2,
                limb2: 0x4db8f18cb0284df2843a92a7,
                limb3: 0x15e2624d820b592f9af1c0f7
            },
            u384 {
                limb0: 0x679bce42c7faa6d908162d65,
                limb1: 0x1c611bd76d89f8a4e5a60ddb,
                limb2: 0xcb269dc7d9414a69ec762f0c,
                limb3: 0x51958ac3ac78d4dc9256e17
            },
            u384 {
                limb0: 0xebfba364152ff3b3594285f4,
                limb1: 0xe10281f83c3fb3e824399726,
                limb2: 0x556f6dc4e7175d3d7e690f38,
                limb3: 0xe364b1e8e8f1cd3c5b060e5
            },
            u384 {
                limb0: 0x49f2203b73dc5dab48a0be35,
                limb1: 0x3f907230531707473fc79b2,
                limb2: 0x441c57277c7b116116111283,
                limb3: 0x12417c38e1e50327aab0208a
            },
            u384 {
                limb0: 0x996ebdeb6f24c62249a17c2f,
                limb1: 0x5d532e38ac8a3c8f17896f55,
                limb2: 0xa1c1d9753dad9e7df71ba9fa,
                limb3: 0x926457f66d3e72839739c23
            },
            u384 {
                limb0: 0x98237a2158b42b5b6ecb921c,
                limb1: 0x7268495d0f2cd3b3561fdb03,
                limb2: 0x2eefb25ba54643b771b1df59,
                limb3: 0x17cedfd53fe32ef952342183
            },
            u384 {
                limb0: 0xd56bec494fc5226c0491825f,
                limb1: 0x37a6472f3ac0eae6f0c872db,
                limb2: 0x256ab3318fe5be899e595705,
                limb3: 0x30da5b32d9e6af6d805008b
            },
            u384 {
                limb0: 0x21a44843aba7c29a82ebe83d,
                limb1: 0x64a1fc766994b61bf09baebe,
                limb2: 0x651c115f271f08e7d0b15290,
                limb3: 0x9bd3bbba81feb67acc88981
            },
            u384 {
                limb0: 0x3075506d232cef27272223bb,
                limb1: 0xd71a027999a785ed264fa1b5,
                limb2: 0x9f41e692662a908f31d19cf1,
                limb3: 0x17579111d82ba5f7f49951be
            },
            u384 {
                limb0: 0x3b5bf098654f444893ada90,
                limb1: 0x1b69222ec27b24fdd453715c,
                limb2: 0x689860327953b208462fe711,
                limb3: 0x7a0bcf849b0ef3aa4b41b9f
            },
            u384 {
                limb0: 0xa59a154d24bf82d728eac906,
                limb1: 0xd0a4a287bc20dd68a8dd31df,
                limb2: 0x5fcf06c95f80c5b20aeb94f4,
                limb3: 0x8240cf8bce5af5d4f351d34
            },
            u384 {
                limb0: 0xf9a9749ac95845edd65e5de6,
                limb1: 0x5052d8e4031d0b5810ab5ce4,
                limb2: 0x8c72ec6f9af43d91c97909c,
                limb3: 0x6c082fa0edb326baf6d44d8
            },
            u384 {
                limb0: 0x391ea5c020895e98f3b12274,
                limb1: 0xfcf347aa156f690766fe5207,
                limb2: 0x9e920681edb0598f451e21c7,
                limb3: 0x4ad4907e97098088f3479eb
            },
            u384 {
                limb0: 0xe3e92978d80fcaede244055d,
                limb1: 0x9ad4a03c465780b68516ee8,
                limb2: 0x36681492817fb15dca6b99aa,
                limb3: 0xca0a87a1049172b530a15
            },
            u384 {
                limb0: 0x55ccfce4579cce67244626e4,
                limb1: 0x548242d36fc6d195af9d872a,
                limb2: 0xa462aec9b0a1ac36afaaf44c,
                limb3: 0x178008d174b3328fcf75d1b2
            },
            u384 {
                limb0: 0xb747d230a69df9b7531517f2,
                limb1: 0xd346ceb3b072e8ef5544025d,
                limb2: 0x35439f5fc9360ad82612c21,
                limb3: 0x11995766e6c1b99aed19dd62
            },
            u384 {
                limb0: 0x308738468591540095eea37d,
                limb1: 0x2bf8efdb6266287a3c8635ac,
                limb2: 0x97858866546a0ea21199b37,
                limb3: 0x121d8e78c550027e0c1fe665
            },
            u384 {
                limb0: 0x766c5c9140a5401067e08976,
                limb1: 0xcd7a80dae3c3cfa3cdacb1c,
                limb2: 0x718f9ac3694e0a7a69005272,
                limb3: 0x6cd194263199fb00e95e99d
            },
            u384 {
                limb0: 0xb91136d16b49d6af683ea2c9,
                limb1: 0x7d8c3b7505283e90fd210213,
                limb2: 0xa529c5c421316d8a387674dc,
                limb3: 0x28750c7a6517b48e0f1f143
            },
            u384 {
                limb0: 0x128722c8c7aadf03dfb9007d,
                limb1: 0x5b252e6211c2588bbd5d40b7,
                limb2: 0xf19e4888bad4824c11eddebf,
                limb3: 0x11f5769b1429fc7b0adb0ece
            },
            u384 {
                limb0: 0x24ff83604fcf929f2f33c837,
                limb1: 0x34de4f243d8fd773795d36bb,
                limb2: 0x52fa15793a232817ac2104c5,
                limb3: 0xb973667af2ac1619b166ec5
            },
            u384 {
                limb0: 0xef1e2e311319af9fb63d0058,
                limb1: 0xc4ac8e9740ea5cc8fa4d8743,
                limb2: 0x80fccbc091bcf542a0fa5f1a,
                limb3: 0x3e2d9a51cb0aef77f296803
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
            limb0: 0x5dd3b77c5a4f41317bd8dacf,
            limb1: 0x3c8efd3a77caa75ca2491aee,
            limb2: 0x7a4ea4b8382149902cf4f632,
            limb3: 0x10edfbb562d276d5c28200bd
        };
        assert_eq!(final_check_result, final_check);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_FINALIZE_BLS_3_circuit_BLS12_381() {
        let R_n_minus_1 = E12D {
            w0: u384 {
                limb0: 0x3f55acb5645a5ab51fed0053,
                limb1: 0x844be1fe4f52ced5d70fc316,
                limb2: 0x791bcee8477c2eaa2f03a58d,
                limb3: 0x16c3f1b235f690e96daa37f7
            },
            w1: u384 {
                limb0: 0xaa8908c491f8d1c67eee7b21,
                limb1: 0x708bd13cceb3cabbef5f6f03,
                limb2: 0xcf015eef515cdc61a35882,
                limb3: 0x4a318fdf9de2a76ce3ef9d1
            },
            w2: u384 {
                limb0: 0xf21bfbb98e6ad5c25d7f0764,
                limb1: 0xda0b45b247c9ddf19c8ea77f,
                limb2: 0x19e05916c54a1e23d1ab2405,
                limb3: 0x80dc14004c99c1a38f511d9
            },
            w3: u384 {
                limb0: 0x928a23669eab86882e9c87b2,
                limb1: 0x3227ea8e2c0bf54f4e25877b,
                limb2: 0x481f3a4cefdc95845b9ffd56,
                limb3: 0x2a7d8d309efcedce5eec1bc
            },
            w4: u384 {
                limb0: 0xbad0baf2b1ace8f1d69708b6,
                limb1: 0xcc1898dce904c349d6b364ad,
                limb2: 0x81f61e9afea340257482af7f,
                limb3: 0x7112800e8ca16fbf76f7c5
            },
            w5: u384 {
                limb0: 0x8a8c150cc290f61f1616b10d,
                limb1: 0xe8ebc38d387494700305ba49,
                limb2: 0x966d3047f8d8a0c221f2f77d,
                limb3: 0xb6a35b606a2e761f2d11495
            },
            w6: u384 {
                limb0: 0x2bc72ba4f0c6319ca891e09a,
                limb1: 0x924de0111e1a439c015cd1e7,
                limb2: 0xd7dd38ce1e31fb8b5f6543e4,
                limb3: 0x425a95ece09c9558d4dd9f5
            },
            w7: u384 {
                limb0: 0xbdc50359a45b2246d30ce37c,
                limb1: 0x7d9271964c43bc4607750580,
                limb2: 0xc3ea2df10ebbe39e790404d6,
                limb3: 0xd9a86a2e19114620a246e34
            },
            w8: u384 {
                limb0: 0x5c22c91e8b4cb911f461b6ac,
                limb1: 0xf43ab91468db6ebabadac4a8,
                limb2: 0x2cedff75a2b37a67c22c08cb,
                limb3: 0x109308de33e7504e151d756e
            },
            w9: u384 {
                limb0: 0xe98992c97e2b668237b1b3c4,
                limb1: 0x8a1e6882da516fed2cb4fe96,
                limb2: 0x198024d41ceea295d1dfd5ed,
                limb3: 0xe0062a4e2ee540de163f432
            },
            w10: u384 {
                limb0: 0x5d60d2624ba6148f3aed477,
                limb1: 0x27376381ff75e55d950fd652,
                limb2: 0x40c125d7db741ac132ed2a94,
                limb3: 0x71149cf4fa51a73b4c0d639
            },
            w11: u384 {
                limb0: 0xbce3c4b29555b6d579546a17,
                limb1: 0x27be1b754868f62d52a6c2cd,
                limb2: 0x63c582e912564ae3d11dfdcc,
                limb3: 0x10eb4e6602d00226c222a34e
            }
        };

        let c_n_minus_2: u384 = u384 {
            limb0: 0x7daae99cdf4e5a0cc3d95fe5,
            limb1: 0xf30f2e1c4440f173bad6c86,
            limb2: 0x65556e8ea86058f30a443046,
            limb3: 0x13cf6c5293bbaa2817c067c4
        };

        let w_of_z: u384 = u384 {
            limb0: 0x813635b47e627fd8ea8db075,
            limb1: 0xaca228aaeefc44f556071c76,
            limb2: 0x76716ac7f78641eb927df9dd,
            limb3: 0x699e7ab51176e9b5fa70396
        };

        let z: u384 = u384 {
            limb0: 0x568417d0775e36868cb8ad13,
            limb1: 0x268ebcc528264359549bd0c2,
            limb2: 0x26dfb3f39713b6a6c00acfcf,
            limb3: 0x6ece3eb55cb195c9c190ff3
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 0x6219f57f82fad04194a5e027,
            limb1: 0xa7c7ec6cd6747da9b2b9d988,
            limb2: 0xbf284e4fa327bbde83dbcc95,
            limb3: 0x5398a178ce8be89ce0c6aca
        };

        let previous_lhs: u384 = u384 {
            limb0: 0xb0c7e10e3c4fd2fa3dab6e30,
            limb1: 0xb540bbdd3421a5054bad5842,
            limb2: 0x9cedd191fd8890c41e59a2d9,
            limb3: 0xf23e1b302e04995ca3f4bd9
        };

        let R_n_minus_2_of_z: u384 = u384 {
            limb0: 0x43b8d1d00bd0ce6d87b0ff89,
            limb1: 0xcea8c1dae9ab3ba44399d202,
            limb2: 0xd97a37da9c186c3017dd4ab3,
            limb3: 0xe9d4b2f9e4f6dc86c4cd909
        };

        let Q: Array<u384> = array![
            u384 {
                limb0: 0x89828bd1ba7f4161596a9ac5,
                limb1: 0x4b1e0d788ae8cf4f8b9f8d79,
                limb2: 0xe2437177ef6735f08f7cbc7f,
                limb3: 0x7f67911901ad9396e7847fc
            },
            u384 {
                limb0: 0xacb3e64b4b2b083950b3940c,
                limb1: 0xe6f87c17d62ccc2155f1c7f3,
                limb2: 0xc55508164fd682749f9e4255,
                limb3: 0x746f7d630d04ed69b28fcc2
            },
            u384 {
                limb0: 0x26daf4e366840eb997a15908,
                limb1: 0x1c1c516aea8598eb3bfe27c3,
                limb2: 0x1422f75b872b60cfa4e30e4,
                limb3: 0x13e69a14afba417911e180aa
            },
            u384 {
                limb0: 0x2ddc1d771479543214d71c50,
                limb1: 0xc0408a56b38d72cd7e08a22e,
                limb2: 0xbcc06cab2a2882c4303abc5,
                limb3: 0x1341dbcfd3f03d51fccf05c4
            },
            u384 {
                limb0: 0x212da1b36a02ec752028332f,
                limb1: 0xd1ea3330e274bf60155f8547,
                limb2: 0xb99187979ffbf8a0f8c6034c,
                limb3: 0x84545084de33282b25ab80e
            },
            u384 {
                limb0: 0xb88b1b711d458d569038da1a,
                limb1: 0x448f6e9f18e5c21f60dfb68b,
                limb2: 0x339bace88bb366b225a3fcce,
                limb3: 0x6b360bf3ed3bfbf68cce369
            },
            u384 {
                limb0: 0x1b323b5c91bd3fdfc4cd7d57,
                limb1: 0x95652825761fa15aa2627f4d,
                limb2: 0x9c9764179c18676034c9b3f5,
                limb3: 0x1445ca788f708e4035c8e688
            },
            u384 {
                limb0: 0xff42be6012201b28a5a71d49,
                limb1: 0x94e5ac7f655a35179a3d7e96,
                limb2: 0x16d1d003d422f5e46b375ff0,
                limb3: 0x166bd5638709d3165d9f2ccc
            },
            u384 {
                limb0: 0x64078a40cf2f1dd410e15c52,
                limb1: 0x29a64a4ddeb4e6300615377a,
                limb2: 0xa0013df020c34a55f4ade208,
                limb3: 0x291447aad095b96d80b9ba8
            },
            u384 {
                limb0: 0x5e5ca2fb673d4bebfcc6553,
                limb1: 0x7f232de8e289b52d60c4927d,
                limb2: 0xe251da176ad71e4fb9b4082e,
                limb3: 0xa31eb518dab74d2c143ddd7
            },
            u384 {
                limb0: 0xc4e59aea265bda70955947b1,
                limb1: 0x9c0df09d17e5c88d334b65c6,
                limb2: 0x9063245b63c8393eaca3decf,
                limb3: 0x184e87db9489cd2878aa08cd
            },
            u384 {
                limb0: 0x60316c76d27646905453e720,
                limb1: 0xb3cd5e52eaf680271ee29ac7,
                limb2: 0x4d3735939d486bf1914ca75a,
                limb3: 0x5019bb7049abf9d5cc9a822
            },
            u384 {
                limb0: 0x48f01ffc75833ca1fc1f605,
                limb1: 0x91eb585b43fd43e1cf5477ed,
                limb2: 0x5219d5c3ed879e848d88d356,
                limb3: 0x185d5b8990b4583f1fb975e2
            },
            u384 {
                limb0: 0x3d7527e8f43562cc89f20d3c,
                limb1: 0xe7a5c9c1b5afbee919a12bd7,
                limb2: 0x7866d51ca2672c747789ab37,
                limb3: 0x77f24c97df21e27d9703f51
            },
            u384 {
                limb0: 0x335a13911fa7d303663257fc,
                limb1: 0x8eeec71685d9ac1b2b4f425e,
                limb2: 0x9dc701aaccd3b640d87f8fab,
                limb3: 0x211c0ee95b71925686cdeaf
            },
            u384 {
                limb0: 0x7275eca74424556689f74ea,
                limb1: 0x2f12c31c01987d2723dd1c7f,
                limb2: 0xab2fead91dfe8d408829bb65,
                limb3: 0xe91875ea7be5443801072b8
            },
            u384 {
                limb0: 0x71d12f7f51517caf91c81918,
                limb1: 0xcadc401ed21f67ba41c05eab,
                limb2: 0xc72e9c73fd04da3ddbcf116b,
                limb3: 0x7350f80058f9ff4c8185e5a
            },
            u384 {
                limb0: 0x6fa3db083e0af3ee84ef3608,
                limb1: 0xab804901e24d0a036f7c9e47,
                limb2: 0xbafb3c414377eb7fd4e36136,
                limb3: 0xc3c2bb1b2da3dc4cbf47a47
            },
            u384 {
                limb0: 0x9dca9181cdeb699fa6fed2af,
                limb1: 0xbf58abbd31453f8d54f71c87,
                limb2: 0x3b547015b8ea558f1a1ea45a,
                limb3: 0xeebd26ff67473f9f1254b02
            },
            u384 {
                limb0: 0xc57745be0ad9620c26a0bb36,
                limb1: 0xc524eafd3d9daef339c185a6,
                limb2: 0x8f38b308ebc1f2ec6bc7ae68,
                limb3: 0x2112ad86a54b593368f8052
            },
            u384 {
                limb0: 0xa173d9dee1a8fc40fa2b6c87,
                limb1: 0x2fdc0e729c74161224deede9,
                limb2: 0x15172ac2baf0c1ee2d2fa617,
                limb3: 0x1030002f0cb06a3d1ba61672
            },
            u384 {
                limb0: 0x30c4b8348dcf681d449d215d,
                limb1: 0xbc1fe7d4ae02cd80ef2f527,
                limb2: 0xb3274fafc9a5b1d097df2b95,
                limb3: 0x17d01bdfec64401645e1218b
            },
            u384 {
                limb0: 0xa16807b0ae2d33bdb46c7a54,
                limb1: 0xac6586314ac61a0404f980a2,
                limb2: 0xd24e2e20e19cff3fdae4e050,
                limb3: 0x168921eac45f9d562ea00ee8
            },
            u384 {
                limb0: 0xbb920b5c4fa7306bbb9290a8,
                limb1: 0x6f4cf935cbac8973a056cbe4,
                limb2: 0x4333c0c3e1f0c5f490423063,
                limb3: 0x764f7ae49d83dc4018027d0
            },
            u384 {
                limb0: 0x2a07d254761ad23ef36dae9c,
                limb1: 0xa79f10a2760284d2a428231e,
                limb2: 0x8cee48d661d2191a09f5f7ab,
                limb3: 0x38beb6f7ce7194ba9f2a42b
            },
            u384 {
                limb0: 0x8c6171754e856df478bfe1c,
                limb1: 0xf81255fb4d0e572578370ac9,
                limb2: 0xc534792c9aaf3dde8ef80189,
                limb3: 0x5e659be074001e8a4dc54cf
            },
            u384 {
                limb0: 0x75a92150349afde31c456e92,
                limb1: 0x31389d17cd941163cdfced83,
                limb2: 0xb67418c1b4c85b46cc6cac66,
                limb3: 0x106556364f43e09120cf66ad
            },
            u384 {
                limb0: 0x8339f03582525a3694211554,
                limb1: 0xb64551cdae0f6ab08e391133,
                limb2: 0x859d4173d96502b22d8ba8bc,
                limb3: 0x59c3ebd637ab4d9ff3b5db1
            },
            u384 {
                limb0: 0x905a1a4270a090e1063a815d,
                limb1: 0x804cdee2b52d196f3bd3c68f,
                limb2: 0x620931c36fb688bbe3a56430,
                limb3: 0x7c561e7655ff99f4a8b2fae
            },
            u384 {
                limb0: 0xa91fbb4852c71bbd94b26c54,
                limb1: 0x902342f6055e22db77e07c66,
                limb2: 0x4d8c5f7ae7bb345f76883842,
                limb3: 0xe17eb4a0322d289189628c5
            },
            u384 {
                limb0: 0x64c8d42b89090502c71b3550,
                limb1: 0x51ccfaaa931f3649b56a07c3,
                limb2: 0x529817d446d159eb5c2c5dc,
                limb3: 0x14f365a31ebf8378667ee8a0
            },
            u384 {
                limb0: 0x8e89f54b81f8c72f148106b5,
                limb1: 0x911f493c450a0e6901fcbf68,
                limb2: 0x8fe5475bb771877e141e39e7,
                limb3: 0x19fa4c9f06fb64107c5246f1
            },
            u384 {
                limb0: 0x60ff1e50ce4418824338195e,
                limb1: 0x85e80c9f67b05c9669b3cbfd,
                limb2: 0xc983453cbcf9cb1aa31f5461,
                limb3: 0x9ecb634e682ad235d74923
            },
            u384 {
                limb0: 0x76a9a58a280556353869f1d5,
                limb1: 0xe9d6cff87b67e1675af28d3d,
                limb2: 0x665d751734eba27eaac43839,
                limb3: 0x6ae6f491804ab11564ae10a
            },
            u384 {
                limb0: 0xffd10c7b55b6affbf3298e1,
                limb1: 0x9e9d3b77ba34b580eda0a0af,
                limb2: 0xd6b1a336ba2831ca0e8cff18,
                limb3: 0x196973303ab882897324cb18
            },
            u384 {
                limb0: 0xc89c59fa55d925ca19d27870,
                limb1: 0x7d03dd282400bdbe2ac33886,
                limb2: 0xe3ffab8cc7c824e4408c58f9,
                limb3: 0x11a8c242dd85171ab3504b38
            },
            u384 {
                limb0: 0x30db9c4c38297c05c2d6845,
                limb1: 0x776df3b53c76449f1d27b701,
                limb2: 0x77f6cf4ebd4b353d6f2363a4,
                limb3: 0x1591441eab44be109fd5239e
            },
            u384 {
                limb0: 0x624c740a0bd549c57155e904,
                limb1: 0x72ad9dfb1f24f379db2d87eb,
                limb2: 0xc98373fa11029ff49930036a,
                limb3: 0x18a71f6153d6faebdaacae0c
            },
            u384 {
                limb0: 0xc0ca0db3b383994c68ee7038,
                limb1: 0x22ebc7efd2fc245fd484ceb9,
                limb2: 0x2bcdacf32dfc297ac2888198,
                limb3: 0xde614f4585340c4b0537fbb
            },
            u384 {
                limb0: 0xfb0a4705ce9aa076faac8f76,
                limb1: 0xa7ba2d5fdbeabc1ab81b7f03,
                limb2: 0x1873e7f034e1be49ad2e1422,
                limb3: 0x9a5f82b68a802f4f7789a6b
            },
            u384 {
                limb0: 0x18059debc3b9996fcfe36f57,
                limb1: 0x5ac07fc59398ded806f187c2,
                limb2: 0x76432a83d2c68435d8cf09e5,
                limb3: 0x606fc08991c6317eb2be416
            },
            u384 {
                limb0: 0xe72e1b7f53d495a2f619b158,
                limb1: 0x43e65fc302e254b3d72f4c94,
                limb2: 0xa8ec9c0525c5868c211d73dd,
                limb3: 0x15dcc1fe492cd84e95a219dd
            },
            u384 {
                limb0: 0x4700feb83408850e0fdc26f4,
                limb1: 0x485184e3f6b5d6740d0c61fd,
                limb2: 0x900caefde0bd2721d0d67780,
                limb3: 0x271d5b6e460a6754278b8db
            },
            u384 {
                limb0: 0x1549cdeec30b4d6d9575d095,
                limb1: 0x8a2de86e6910124a603fa8f0,
                limb2: 0x5e2aa857e558abe17fc8c2e7,
                limb3: 0x1726bb49b8b12e28977f500b
            },
            u384 {
                limb0: 0x1a47dfabb3daba5e4734fb3e,
                limb1: 0x92c6cedf29e672e49685da72,
                limb2: 0x943a764ef11048754eb43ad4,
                limb3: 0x18b5e505b143f50ca25a2423
            },
            u384 {
                limb0: 0x8dc643912869ef610215785d,
                limb1: 0xaa0d9271ce65e7256591e4b8,
                limb2: 0x6ce1c8403caf0f71877cac55,
                limb3: 0xd55f62ff4b346d92ae3d68a
            },
            u384 {
                limb0: 0xf005398fe0cece0aed472d9b,
                limb1: 0xb54d83e59e241b8e268b25f6,
                limb2: 0x7166c54b930575711e69b4b0,
                limb3: 0x11448dd3ede19ece5a2e6a99
            },
            u384 {
                limb0: 0x8c0fe4e7d03a354ebd063866,
                limb1: 0xa231a721dce83f1592fb4636,
                limb2: 0xa35d9f4e2be57d814dc59d0e,
                limb3: 0x1fa524eb440d4eb03ed8da8
            },
            u384 {
                limb0: 0x9bec11a0d5bccf5eb9d2aef5,
                limb1: 0xef9f1d906706e1999aaacaa8,
                limb2: 0x53e04d41c84724e1687e3c82,
                limb3: 0x18780db3422b80efbded53f6
            },
            u384 {
                limb0: 0xad645c15acb76fb8a022f3b7,
                limb1: 0xfce3c44f5bca7ecb70fe4514,
                limb2: 0x57ad185e1d38f988922dcb59,
                limb3: 0x64c7ba233f232a262b7e3e7
            },
            u384 {
                limb0: 0xc0f2b58bcc728558f887a123,
                limb1: 0xc402bb0eb2f9904b5e2800be,
                limb2: 0xacadd87eda6c650f016e5a82,
                limb3: 0xb0572875f55260f938e0f3e
            },
            u384 {
                limb0: 0xeec051bb329d35ae81e1ec3f,
                limb1: 0x584ca7a83f0aa14998aa622e,
                limb2: 0xb4fecb14b2b4f0cc2636c72f,
                limb3: 0xc2731c6880243b7f2a5b075
            },
            u384 {
                limb0: 0xb3e2e59b68f111c6ddefd680,
                limb1: 0xde7d0a5fc4ebb04b993cabb7,
                limb2: 0xe595e68f0a4dd54b46828f04,
                limb3: 0x5aac677fbec6400b71ee27c
            },
            u384 {
                limb0: 0x2d6b5f4d38b285579276de42,
                limb1: 0x7f512cb65df2c440652f2cc0,
                limb2: 0x9935948de99f469eb723b681,
                limb3: 0xf9fd3692a31ca24077e3249
            },
            u384 {
                limb0: 0x12905a3a5a2b80218a0f9093,
                limb1: 0x38b7db84c39a51ec52b46ef2,
                limb2: 0xd360282d9d5dd3b309a76a9f,
                limb3: 0x16f8fde84afafa7aab9d275a
            },
            u384 {
                limb0: 0xe9c5c1300a5bb410ff6891a9,
                limb1: 0x43419acefebd6b726e24df89,
                limb2: 0x8aca54105c10126197762b3a,
                limb3: 0xa7e1879c20da5bd10d44b3d
            },
            u384 {
                limb0: 0xcb4c7788897ad387171c391a,
                limb1: 0x9ec485cdc00afee8541ee03,
                limb2: 0x630942bedb13f39481d1e8f9,
                limb3: 0x164fd7a96736a84f178ed5d7
            },
            u384 {
                limb0: 0x861530f273dab074bbd5ba6e,
                limb1: 0xf29b76e936580684bbfc4e14,
                limb2: 0x5c51399ea8efc7f9d4ad527d,
                limb3: 0x1037497d06e22c3eaba88303
            },
            u384 {
                limb0: 0x80857fb264e036b5a4fd1a17,
                limb1: 0x722219dcb01e0a8db8f8c77d,
                limb2: 0x9fa1c6c982ebd7728623ee6d,
                limb3: 0x642a2016272e2af92126ff1
            },
            u384 {
                limb0: 0x3c1650afb3be516709463e6f,
                limb1: 0x495c15cc4a8dfea10e2a04bd,
                limb2: 0x7635abe4611b4891857f4ecb,
                limb3: 0xc3de88669eafdb85541b40f
            },
            u384 {
                limb0: 0x691fcf9ad89589611d03e632,
                limb1: 0x7838c85e4ab0d893745c759a,
                limb2: 0xc821082dbb783da9d6874618,
                limb3: 0x12192ca60186b0d835f01b7b
            },
            u384 {
                limb0: 0xc82f1b36fbcddc66ce18533d,
                limb1: 0xd92c203767941a9d462693ff,
                limb2: 0xa442ff4c35f246538968e51e,
                limb3: 0xa02c63a10ae23626d93be7f
            },
            u384 {
                limb0: 0xe73383ff67b7e14cc9c5bd9f,
                limb1: 0x8ed3f8d9e055162c7a06b37a,
                limb2: 0x73dccc48641ec93502a923d9,
                limb3: 0x1968b4143bed05a9c9e51944
            },
            u384 {
                limb0: 0x2b1863cf7564319cff239f2,
                limb1: 0x89440eca2ab65b1daa5611a2,
                limb2: 0xc0251deb9f2c16ea87dbfdda,
                limb3: 0x19ee2fd39adfb3058a070e39
            },
            u384 {
                limb0: 0x359aca2086565c4d3dfc5aed,
                limb1: 0x8230088e4b2903f37d2c1e7e,
                limb2: 0x78b5c1dece9c85a7a7176911,
                limb3: 0x304e3bcf929fb273e4ac540
            },
            u384 {
                limb0: 0x818a3491c106ac8f3108d27b,
                limb1: 0x3a831ec48d704dd8b9ceefe7,
                limb2: 0xff86e9fd5f0f52f4bc22f275,
                limb3: 0x101ca06cda110afa372e33be
            },
            u384 {
                limb0: 0x431d69d88fc7301ce0a82395,
                limb1: 0x1c476113666b2ee249af952d,
                limb2: 0xce518ffcd43dda2a7bacbd85,
                limb3: 0x16f722b59a46cb397766f556
            },
            u384 {
                limb0: 0x5dc4d442e6cd146c6c414b3b,
                limb1: 0x83a009fd917b7c4090899a2a,
                limb2: 0xc5bafa34a5565599125a2b84,
                limb3: 0xcd676c9cd49b013cd0bdb15
            },
            u384 {
                limb0: 0x1f0b373542f076a39c1f7a63,
                limb1: 0xb31eed442d1ce27e7d3c661,
                limb2: 0x46637bffb0df50beb8c9a6d3,
                limb3: 0x19ea2fdceb3689adbba16224
            },
            u384 {
                limb0: 0xe19ffc36d8c24a82a9813e48,
                limb1: 0xd11de57619cefbfa85bb8af0,
                limb2: 0x73140fe939da09d5119b988c,
                limb3: 0xc45030dc698782e21f8dc27
            },
            u384 {
                limb0: 0x77dfbe635fc75d5233ccec76,
                limb1: 0xc5c1144658df0b5f42db17dc,
                limb2: 0x7ca6a63322320962c7b46529,
                limb3: 0x93839c8ee12ea332a883ae1
            },
            u384 {
                limb0: 0x645101b86354319584025665,
                limb1: 0x31b7297904d67b6f8feaa2f4,
                limb2: 0x59860017dfed740455de290d,
                limb3: 0xc4b1bdb63901ff6ede334bf
            },
            u384 {
                limb0: 0x45f9f24b5225c7bbc8dd01fa,
                limb1: 0xb4236475e54acd13391c0603,
                limb2: 0x7dd1c306bdcaca2cff1b17e5,
                limb3: 0x998af68ca6b0cda52825876
            },
            u384 {
                limb0: 0xff690a7e08f46f442b3a60ca,
                limb1: 0x614ec0bcc5f820871e4e7c47,
                limb2: 0xf551bbcdef9917209203d693,
                limb3: 0x5a3495dddff17cfe74c987c
            },
            u384 {
                limb0: 0xb9ef3e8f233a8aa0dd0ff93d,
                limb1: 0x8b252c5a357d72055b8cdd56,
                limb2: 0x93caf93b3b251899215da72f,
                limb3: 0x14acc194af6b5d120f38f1af
            },
            u384 {
                limb0: 0xf04abb9d614b3ebb3845b6bd,
                limb1: 0xce3a664743710cf10ee7aed3,
                limb2: 0x72627f2d94b385d8d5050eae,
                limb3: 0xbeecad950e81e7c7b1a7528
            },
            u384 {
                limb0: 0xf8f31873fbf25b96db62bcf5,
                limb1: 0x79d06ea37ab395ccb0799c74,
                limb2: 0x4ebe97441b6043ff8cb8bbd1,
                limb3: 0x32dfd2f9e268ce0cb496926
            },
            u384 {
                limb0: 0xe0a50e9e0c5084dd0fdc0b68,
                limb1: 0x1089f14abda9ed3e92553233,
                limb2: 0x7aae6c5f53be7a0476f2aa3f,
                limb3: 0x162973cbc7ca5771866c73e8
            },
            u384 {
                limb0: 0xc8fdb279ba6c8f8f22df2127,
                limb1: 0x9502e8d09fbacebe7ab2d2be,
                limb2: 0xdda743eaf38d5f863431d279,
                limb3: 0x129dca238b599c634a10574e
            },
            u384 {
                limb0: 0x7b81739d308f3d08410e50fc,
                limb1: 0xb11a2e815957985b5bf19061,
                limb2: 0xff68f181c196dc5d9e88271f,
                limb3: 0xfa4d143a8b1bb31e9652686
            },
            u384 {
                limb0: 0x8f1934102f0d40d06a33e0f9,
                limb1: 0x197dfe228c35d1a7d8628271,
                limb2: 0xb2e454ecf7e39094af23e437,
                limb3: 0xd0c71578a0f4fa5b852b133
            },
            u384 {
                limb0: 0x93c58335100399b3780a5542,
                limb1: 0x9a7a1d9141ed7ecd333d64a1,
                limb2: 0x1e44da9835e3c06b68b156a2,
                limb3: 0x12688e836fdf26e8f9c42258
            },
            u384 {
                limb0: 0x75c8fe6c39ea86e7a5b6a7d3,
                limb1: 0xcdccdc668a40c0909c2151a2,
                limb2: 0x948fa23c39dbede7dc93ee55,
                limb3: 0x1603bcbc04b45598411d9ac8
            },
            u384 {
                limb0: 0x4db7be08bed61fe3c918c98d,
                limb1: 0xfc99f0b062877b0968786cbc,
                limb2: 0xd84c108758121beef7892518,
                limb3: 0x19c8e44ff0394df15fefa4
            },
            u384 {
                limb0: 0x6659150a428706403b86058b,
                limb1: 0xb7bb46083731b449f7f38542,
                limb2: 0x1192ee49ff5b7985c0c8489e,
                limb3: 0x45d93b700301adb5b88b1fd
            },
            u384 {
                limb0: 0xc5ec6753434e3c70487b7c,
                limb1: 0x8df76120a4c866ba85bb98a2,
                limb2: 0xe8c46fa14dddbc7b3884ab6,
                limb3: 0x17978541ed410331bb4750e5
            },
            u384 {
                limb0: 0xfd9e77ffc970d40545e4a876,
                limb1: 0xf29fb90ee54d1fb56205163e,
                limb2: 0x6173a7b0cadf5c3e706744a8,
                limb3: 0xe0df4a68b20c56fd304d06c
            },
            u384 {
                limb0: 0x1dceca8827cdf6d1a3ccd99f,
                limb1: 0x9d4fd1f303b160eaeb1e1e48,
                limb2: 0x6a9099989ad42520f5b449e1,
                limb3: 0x11dd9dbf35e06a055632aace
            },
            u384 {
                limb0: 0xc89f3182e22365cbbaccdef,
                limb1: 0x4c781201e41e011174cfcb94,
                limb2: 0x35cb4e445282f2cc390ab629,
                limb3: 0x17c7ef08525d00de7a860be2
            },
            u384 {
                limb0: 0x7baa138ddc07f940909bfb6c,
                limb1: 0x57a8f035d2b85cc60a9b5b1d,
                limb2: 0x7db6dd3595855342b5e6e55b,
                limb3: 0x13984bca4016bf225a56de70
            },
            u384 {
                limb0: 0x4d5149a5a8f67572e5afeba5,
                limb1: 0xa45fa9d992a971e671cd9bb7,
                limb2: 0x882fb74a52f783b1b2540830,
                limb3: 0x3576569be99d695871d7732
            },
            u384 {
                limb0: 0x22d706178fe0cb1a17bb725f,
                limb1: 0x9308dc6a40bf3e549fdb86be,
                limb2: 0x78dfcadfe9ac3942bb2c3947,
                limb3: 0x2666f76168c320245d33f09
            },
            u384 {
                limb0: 0x61c00eeed460ee39419a8fc9,
                limb1: 0x17c5c2b485b0040231775bb8,
                limb2: 0xee24e998b9a83e16bc9b5dfd,
                limb3: 0x171b048077aa80d0427b4a96
            },
            u384 {
                limb0: 0x8993782e510cf7ff80c450e,
                limb1: 0xe32bc098aa7c1ea386716104,
                limb2: 0x2429a8172c39222f52ce2c28,
                limb3: 0x14da739088ba469caf363055
            },
            u384 {
                limb0: 0x33af6a90a2d5d71b74a65138,
                limb1: 0x69ddbf7fb17ed8203f1ca1a9,
                limb2: 0x28a96c642ee639e605a80eca,
                limb3: 0x80d681ffcde10feff9f52c7
            },
            u384 {
                limb0: 0x8d32d5a2047148621cf58a1d,
                limb1: 0x6ebb89d6099ee1f47734474,
                limb2: 0x8deb9a9022fe37dc8a7cea0,
                limb3: 0x64021fa39298ad32fd184fc
            },
            u384 {
                limb0: 0x41f2eda4a3764a660fc9d2de,
                limb1: 0x69a4e1957c158228804de8e9,
                limb2: 0x835ce55ea78504c804f1f5d1,
                limb3: 0x16dbf7ed1c209f98a406b471
            },
            u384 {
                limb0: 0x96154be95b698ec79fa25586,
                limb1: 0x9e00559b2802e6053fe60c84,
                limb2: 0x1010e76813f140803c0dd51a,
                limb3: 0xe55315cf76f2688a2885899
            },
            u384 {
                limb0: 0xb28624b5ee2bab3eede6591,
                limb1: 0x288dcf56a6b9b0355ff0094f,
                limb2: 0xa1b22a92bcdbe1056c441570,
                limb3: 0x67d679ed96bab4927bea4db
            },
            u384 {
                limb0: 0x7f292f48045dfa1ff368f569,
                limb1: 0x637ae52286b337a0d0d4226a,
                limb2: 0x6b25ac204b4851318f2f9889,
                limb3: 0x1396e6f032657763fd2cf8f2
            },
            u384 {
                limb0: 0xc4ea7478f09910884a2fa7e2,
                limb1: 0xdfcba9751435fa0c9953ded8,
                limb2: 0x4c17fd24d5f9bf663790da5,
                limb3: 0x14552963f355089cd42d8dd6
            },
            u384 {
                limb0: 0x43a69ea1a6ed48d0d100f2e,
                limb1: 0x259504cada6b236d18a8af2e,
                limb2: 0x4bc1343e05eb09baa0287d1e,
                limb3: 0x13d111a60c4b5dfa2d01b7b1
            },
            u384 {
                limb0: 0xb95a9bfb827f2f523905b6dc,
                limb1: 0x74e0420accca24df24e60c17,
                limb2: 0xed14276e0c6b1e0b0a7ff0b,
                limb3: 0xbb72947cd4335decd1dd781
            },
            u384 {
                limb0: 0x4e030209c3d442a0d3339005,
                limb1: 0xf443bc003f6f865376863578,
                limb2: 0x5a938325839b1788bb3d5921,
                limb3: 0xc5d6100e4c83737efa70888
            },
            u384 {
                limb0: 0x7a665233539498a79e686423,
                limb1: 0x3d1e9521a3f28f4512fc925c,
                limb2: 0xd6fc07d4f498ecbd90ff1e7a,
                limb3: 0x150515374f0b87f1357827e
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
            limb0: 0x34b706215c47b5a3aab6d12,
            limb1: 0x9bab5d0b9030dfd93df6eee2,
            limb2: 0xdce01b68f503e02893bdd17b,
            limb3: 0x5c4d66337cfa90a58b1782d
        };
        assert_eq!(final_check_result, final_check);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_INIT_BIT_2_circuit_BLS12_381() {
        let yInv_0: u384 = u384 {
            limb0: 0x561bbb4730ecb60b101ad1f3,
            limb1: 0x20636cdce6e390f42571472,
            limb2: 0x69b290f1796b92853862cbe2,
            limb3: 0xac4a4006ff7faf0db9a3043
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0x227cbc27bb7f99c085d6df81,
            limb1: 0x23ff34b7c2ce6c9b7e9acd18,
            limb2: 0xa30e30dc13493ec4fa5e999e,
            limb3: 0x1297d1d8b1b1bfe284eddf6e
        };

        let Q_0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x3269871db0081c1840fc9f2d,
                limb1: 0x5304ca7f598ec4e7bc315be3,
                limb2: 0x696195fa159a1f5648757d87,
                limb3: 0x2c50f2288edd6d3d9a0690f
            },
            x1: u384 {
                limb0: 0xa4a13198d65b79f6804c465b,
                limb1: 0x40d7a39d3bb130956806643b,
                limb2: 0x3c73246d228a7cc429a6bc74,
                limb3: 0x7702c40184f368d2f889483
            },
            y0: u384 {
                limb0: 0x41ed0ad7f799e29648d44935,
                limb1: 0x19b0912a8f926d4409d1a23b,
                limb2: 0x4897a1d068c029bec9665aa5,
                limb3: 0x19311c829d2370bb9d1ef275
            },
            y1: u384 {
                limb0: 0x1abc918ec785b14453158ee1,
                limb1: 0xb99479d365ef945c10f143e2,
                limb2: 0x890cc685e609c17f13641b28,
                limb3: 0x15339c99fc9fe8b02a72895f
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0x7bd85802aa4a4a8b057de4a3,
            limb1: 0x2f167c5d387f89969d91e4c0,
            limb2: 0x6c1f2da66dcd732af4d20476,
            limb3: 0x1986ac8998e8f1d2496fd519
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0x6fb69b0ffc2960d663961970,
            limb1: 0x23128102153284797ca0d4f3,
            limb2: 0xd99e10e71138b1e2488dcd7a,
            limb3: 0xe10bb77735574531da17e1a
        };

        let Q_1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x48d988a1e8e32274b7e0d571,
                limb1: 0xf247bba6ce56ffbe75bcb90f,
                limb2: 0xfda34376f5e617cea1e262d7,
                limb3: 0x11a80d07532bf37f97017fd0
            },
            x1: u384 {
                limb0: 0x2aa9d516a6c44ed2b5c2fec9,
                limb1: 0x51d3668af99a6433a77d7c3,
                limb2: 0x89750e817947c92f7f079d7d,
                limb3: 0x146eaa8bcc14577ba816e6c7
            },
            y0: u384 {
                limb0: 0x81200651598c3b625edbd437,
                limb1: 0xbb86c87b95ac437ca13efb41,
                limb2: 0x75afa0b9ae26a22c947c1b26,
                limb3: 0x14a3fb0d51c23926c70c3488
            },
            y1: u384 {
                limb0: 0x50aac729717209cf29a60326,
                limb1: 0x88ffdf979f91621522d31e12,
                limb2: 0xb8629d147432e5596fd3dfaa,
                limb3: 0x294a471aabd201acc972c86
            }
        };

        let R_i = E12D {
            w0: u384 {
                limb0: 0x815aea9d540145658b51f270,
                limb1: 0xfa4619f20a8f4a806a615a6e,
                limb2: 0xc446e1fc481aff3082d6d502,
                limb3: 0x153de6c491d498fab6cdf678
            },
            w1: u384 {
                limb0: 0xaba6d11140bb628fdad39cfe,
                limb1: 0xe77b4418ba1c28c124b76d47,
                limb2: 0x70cf574572ce48784975c699,
                limb3: 0x995f62b7f0cb2da99d8bfd3
            },
            w2: u384 {
                limb0: 0x1f205c087e566ac00362bf93,
                limb1: 0x1dc55c552c587b1721c41579,
                limb2: 0x3fab8471ce28d9c30c9df307,
                limb3: 0x651d8fb09bb3cd269241cb8
            },
            w3: u384 {
                limb0: 0x3220a4a8b610cb2461020a09,
                limb1: 0x36c3f9d08061c53013bb05c5,
                limb2: 0x88c9a3a5fa3c27b849c97f69,
                limb3: 0x116954e39b73f94e83ffeb81
            },
            w4: u384 {
                limb0: 0x9da1e38f352bb050c96f1cb3,
                limb1: 0xcf719d9a67d061c9bc004167,
                limb2: 0xe7f8927724101196ae6f1a15,
                limb3: 0x2a2a5cee7c1b6a8bc653fdb
            },
            w5: u384 {
                limb0: 0x1e804c7bfba4dc0fa6e6a506,
                limb1: 0x6e835df99c47f80beba6ec38,
                limb2: 0xcc4e04603cff353094ee035c,
                limb3: 0x59786090d06d0f4fe245b6
            },
            w6: u384 {
                limb0: 0xcfd646bbfa2f30811914c4d0,
                limb1: 0xad81d77175a67ba8eb687a5e,
                limb2: 0x5a1e69847eaabf2694090322,
                limb3: 0x1d778ec692e0c149d3670f5
            },
            w7: u384 {
                limb0: 0x81ed065930878e290b31389b,
                limb1: 0xbbaab4a887956f11efaab54,
                limb2: 0x5c3d2d4d263f1dfcd2fcfbfd,
                limb3: 0xe94522319ee3bc56d7027b
            },
            w8: u384 {
                limb0: 0x922975ca6fa18e7c45f7ea98,
                limb1: 0x5056acbb7a4e863fdfa72399,
                limb2: 0x1a6157a95f94d967249984fe,
                limb3: 0x107e316e9d746cebf5f11fc8
            },
            w9: u384 {
                limb0: 0x25e7f23824742ec74af05b76,
                limb1: 0xbcb28b77f5d2e1e649cf808d,
                limb2: 0x30bea7420f3b07e39d7a774c,
                limb3: 0x16b9415036b1b2ccd55bcf68
            },
            w10: u384 {
                limb0: 0xb2ef2d5c61b13f252c650537,
                limb1: 0x43293bd7c422f20ea4bd1afa,
                limb2: 0x381768ca8e8031e04c17a70a,
                limb3: 0x4447583276dfcb408d9bbb6
            },
            w11: u384 {
                limb0: 0x8f18d598e01b1b37b4d7d268,
                limb1: 0x5ed292730b3fa8b6a2761af8,
                limb2: 0x3df32ab0f71415906a69ef71,
                limb3: 0x11da5767188213351f156eb8
            }
        };

        let c0: u384 = u384 {
            limb0: 0x264731d72165099277247d38,
            limb1: 0x74cead4a6e4091528c16567f,
            limb2: 0x8f53483845846caabb8bfcbd,
            limb3: 0x1f2bc2ad3fd1719b4aa1dca
        };

        let z: u384 = u384 {
            limb0: 0x54c57344988884eed7819ccc,
            limb1: 0x558f9def985a955b67f69d5b,
            limb2: 0x58f5f2d45af5c2ae30347c71,
            limb3: 0xf2415396916312b8b3530de
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 0xcd2fe15174c88f4235677412,
            limb1: 0x5e66ddc3a775cc44ee079366,
            limb2: 0x659185b7664ef10799a6f416,
            limb3: 0xcad56b6255753d930795b5a
        };

        let (Q0_result, Q1_result, new_lhs_result, f_i_plus_one_of_z_result) =
            run_BLS12_381_MP_CHECK_INIT_BIT_2_circuit(
            yInv_0, xNegOverY_0, Q_0, yInv_1, xNegOverY_1, Q_1, R_i, c0, z, c_inv_of_z
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x693a2fb94307096b7f0414bc,
                limb1: 0xb6a359c17223c896f437ca27,
                limb2: 0xdb31e9a5c70d092c1cdb8b0f,
                limb3: 0x52afb8442c0550fe9f87421
            },
            x1: u384 {
                limb0: 0x99432868ea9164330286b15b,
                limb1: 0x834a8fd01ff141d5e5d234e6,
                limb2: 0x4a3504496e62fe56acf221b7,
                limb3: 0xcc120b428268bda13037054
            },
            y0: u384 {
                limb0: 0x57cd11ee9b14099649e0f892,
                limb1: 0xdac220e0a06d2b9b3368368c,
                limb2: 0x491282c3420568e4b61d55a6,
                limb3: 0x539c883136d94498db8843d
            },
            y1: u384 {
                limb0: 0x98da8637c92809c9915fc28f,
                limb1: 0xab2e104f117d34ea163fed84,
                limb2: 0xaa9e0b3a84f84794ff431b1d,
                limb3: 0x908cec35834e27a7d7c50da
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0xd0d925384606d6fb6f4b13cc,
                limb1: 0x52a4443b04a675b814bc1c0c,
                limb2: 0xd04a3d98ed19e4d45f8997e3,
                limb3: 0x56d2f398b7cd909cb204e8b
            },
            x1: u384 {
                limb0: 0xc576e9a0127720738b098e92,
                limb1: 0x677f809fe1ea593f6e44892c,
                limb2: 0xb41b3878a0c351db6892a009,
                limb3: 0x1707ecc89a64426f88360bfc
            },
            y0: u384 {
                limb0: 0xc858e8f63078002c3bb1bb2f,
                limb1: 0xb3436cef7c8a77ba25424b30,
                limb2: 0xc38df6f2c47db979f85a2343,
                limb3: 0xd52bf0776c9ff42acbe9f50
            },
            y1: u384 {
                limb0: 0xd3a244bd524b0c65127c5e0d,
                limb1: 0xc8744abbfb166dab6b78a0ae,
                limb2: 0x197e121ae90934da1d4d1c7d,
                limb3: 0x13bdf85c36d7c71a287c2ebe
            }
        };

        let new_lhs: u384 = u384 {
            limb0: 0xf871f1c7e8113a0c02c2f860,
            limb1: 0x6d464a975e47214b6bab682b,
            limb2: 0xcfbdd20525b236ed4667c25a,
            limb3: 0x7f71f0b2f42ea01c830d560
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0xd85b1b1b231531a3d3d7ec81,
            limb1: 0xd713afe90ba0cfcd24bc416e,
            limb2: 0x1e80f3ebad5201f139f64b6,
            limb3: 0x12ef2c5468107724d5a719cb
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(new_lhs_result, new_lhs);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_INIT_BIT_3_circuit_BLS12_381() {
        let yInv_0: u384 = u384 {
            limb0: 0x3230a8af3ce372c73866bdcd,
            limb1: 0x38bcbceca5e1f3c4ef230bf,
            limb2: 0xca54448b6de25fe10f69a7fa,
            limb3: 0x34bee9a77839c208d3fc6e0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0xd6bf582857986708bb3dffe1,
            limb1: 0x49f35d6ba37df6b90bd357e1,
            limb2: 0x304ec17f35c44ff79ea91fe1,
            limb3: 0x2dd53ab3987c9a0d8d0b8c8
        };

        let Q_0: G2Point = G2Point {
            x0: u384 {
                limb0: 0xf0d63eb046299940a6a48f65,
                limb1: 0xe709813f8955f852a2ab116f,
                limb2: 0xd8ffd19ec596bb33047ee7a0,
                limb3: 0x1e535a5e8f6777b13c8aca1
            },
            x1: u384 {
                limb0: 0x65d6fb7f4f9afd63236e747e,
                limb1: 0x19bbf03db6d06615f1521976,
                limb2: 0x77f141cd3b6f2ad26ec1b7b0,
                limb3: 0x17bc649cd06a3c9d149fe63
            },
            y0: u384 {
                limb0: 0x8525d1322c3c6326cb8c2c5e,
                limb1: 0xc40031e4ad91c6baa0c8c192,
                limb2: 0x9532c9589e67de704d5d547a,
                limb3: 0x5f95576a2156d67c49763c6
            },
            y1: u384 {
                limb0: 0x796a1163c122050416f723f,
                limb1: 0x8c126005d422666afcaf1285,
                limb2: 0xfc84d80373fa96135fb91518,
                limb3: 0x1ecbf411d1cef4607f82dca
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0xfcc2a98ea4a661c3965fb6d4,
            limb1: 0xdddfc6481840941954135521,
            limb2: 0x7ffd5e755fee0d7880521e37,
            limb3: 0x827d56863b67b1d63f7bd7a
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0xa6c1c1cadcc300784466d8e8,
            limb1: 0x4cacbf66db5bd443dd5eae5c,
            limb2: 0x4768e189dc0d10e686cefc79,
            limb3: 0x1385735ab604184cdf198e4a
        };

        let Q_1: G2Point = G2Point {
            x0: u384 {
                limb0: 0xd3290b13ac234f140f4c96d1,
                limb1: 0x4afe17f878ec4ac45fd65f49,
                limb2: 0x7342d96b1ae3be4f38159ed2,
                limb3: 0x15fe83d82b2bb5b98bb0155e
            },
            x1: u384 {
                limb0: 0x880b6a4cfcec2c1d9a044f6a,
                limb1: 0xf839108e29ae1d3a25128961,
                limb2: 0xbad7373d594c1f7ccdbdb337,
                limb3: 0xfd8f424063aa9e2566d8cf0
            },
            y0: u384 {
                limb0: 0xc72a5ac130c97d347ae624a6,
                limb1: 0x2da4d7f2a2c1e1d4131bf956,
                limb2: 0xea6d556538102725952a4ff5,
                limb3: 0x14bfc0ee6b08e349ce5000d3
            },
            y1: u384 {
                limb0: 0xd929dfa02639b34bb2cbcafe,
                limb1: 0xa562dbcf07b65bfe7e40d229,
                limb2: 0x29b75064f2669283666a9594,
                limb3: 0x134cd508e744e88837124754
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 0xcb346925128c8b2b867b77e6,
            limb1: 0x8ded3a7c0eeae85f650bb629,
            limb2: 0x2b62d41c065963f2947115e5,
            limb3: 0x9c449247bc1a87f820297b1
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 0x8c44605e8ccde8ad4a88549d,
            limb1: 0xa093e30f1e1eedd97b192256,
            limb2: 0x6499c09040c4d58954af019,
            limb3: 0xb1016a29b9f56b832717896
        };

        let Q_2: G2Point = G2Point {
            x0: u384 {
                limb0: 0x2e0795780e4bb53cf3dacf72,
                limb1: 0x8646356bc28611fdf3e50e26,
                limb2: 0xab32b76692738995ca89ad11,
                limb3: 0xe63304ad71a78e3decf51f5
            },
            x1: u384 {
                limb0: 0xb7abe7b612d570a998d8d5e2,
                limb1: 0x51c17a71520d96298545671f,
                limb2: 0xb6513595803c51a1ea8f3d1f,
                limb3: 0xb739f13a85b4692f24c863b
            },
            y0: u384 {
                limb0: 0xae1012f5d00d9045578239df,
                limb1: 0x5e31f6379a1b62f84588d2ef,
                limb2: 0x8eb76bcaf7c188ec70ad6c34,
                limb3: 0x158ed378e0614d8834412a92
            },
            y1: u384 {
                limb0: 0x559395d0084722316fab7a98,
                limb1: 0x6aa2b88ca946a3a25d87a7c1,
                limb2: 0xd8a485f5a72125ce183696c5,
                limb3: 0x18f282d4e5a2a4efa5fd6acb
            }
        };

        let R_i = E12D {
            w0: u384 {
                limb0: 0xf696899e22e4e6b8749d6142,
                limb1: 0x80f62b31c5b0bb0d6db9a07d,
                limb2: 0x314f38d8f89d41231718a90a,
                limb3: 0x106020e5f68866c61161524e
            },
            w1: u384 {
                limb0: 0x1236cd47d10a39092c29feb0,
                limb1: 0xc4d1a82e64486f704499bad7,
                limb2: 0x80e1397c35640c72bae842c8,
                limb3: 0xa77bf7515325a148642891b
            },
            w2: u384 {
                limb0: 0xabe520ec1fe159cdca54e759,
                limb1: 0xc650232095017a2402160910,
                limb2: 0x3fed9392764269529f20864,
                limb3: 0x4e5100dd70b067120b6d547
            },
            w3: u384 {
                limb0: 0x2fe5d8224ad874e82faf32d4,
                limb1: 0xe069d95f92bb7f1f3775bba9,
                limb2: 0xa6acd24c07b109a9baf9167,
                limb3: 0xa7185b82df129b798f5e381
            },
            w4: u384 {
                limb0: 0x69923a40539a7e42e8e94603,
                limb1: 0x9747c10cdeecbce8830b988c,
                limb2: 0xc3d0df99ba72a8e8b0cc68a0,
                limb3: 0x18269c8a2d24fd9b84533b66
            },
            w5: u384 {
                limb0: 0x914caa43b6b09b75a4784cd5,
                limb1: 0xd5637e42845dda87512aa9b7,
                limb2: 0x25117440e5db55724aeb6ac6,
                limb3: 0xe9d2aadab79bf066415346c
            },
            w6: u384 {
                limb0: 0x1e0d2abef8afa902e0687ebd,
                limb1: 0x4210a16d2d44a2ccfa2aa9eb,
                limb2: 0x2844a59ec246065ac5086c32,
                limb3: 0x14618689d7fbbb2cbe224337
            },
            w7: u384 {
                limb0: 0x708a3ed4ee29afcc5e2e9fed,
                limb1: 0xb3ea0713d5b624b4e5afa7f,
                limb2: 0xfa53b5a763d8ccb172fa5cfb,
                limb3: 0x1428251bd173e554bbd4dbca
            },
            w8: u384 {
                limb0: 0x1715558743568c9a2eaff555,
                limb1: 0xe64b57ce2b9193025633c34e,
                limb2: 0x9526d2fced9ac510d30b748a,
                limb3: 0x12f85563eb91da1aa4e5a7e7
            },
            w9: u384 {
                limb0: 0x13165fde18baf495154ba146,
                limb1: 0xf6f715caa59db0acb60d4fbc,
                limb2: 0x11ed22768f4d77a5cbe7c002,
                limb3: 0x6e171cb9300d20cf09014c7
            },
            w10: u384 {
                limb0: 0x3f9a99c3fa117c3766206306,
                limb1: 0xaaf124955c52c6158c59dbeb,
                limb2: 0x9d9656fd14f1609c1b0ca574,
                limb3: 0x1741c4e583f5baf8cd2771da
            },
            w11: u384 {
                limb0: 0x13d77fa7df0674c4bd4ad557,
                limb1: 0xd8b23694708f455b079aec91,
                limb2: 0x584c1484a8ef6278997536a8,
                limb3: 0x19820ca0cf671bcfaebb192a
            }
        };

        let c0: u384 = u384 {
            limb0: 0x48cbdf4caa99e8641ee1ecba,
            limb1: 0xcb6bbb82acea0c221d638731,
            limb2: 0x250b962113495931f4bfa0fa,
            limb3: 0x723e495306db017a9a7cc55
        };

        let z: u384 = u384 {
            limb0: 0xa5c8e6fa0a3a265e88439f8a,
            limb1: 0xc3908adf7cf8ff3fc693135a,
            limb2: 0x3342a08acf57e7701e12620c,
            limb3: 0x7d714ef743cb61733130c57
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 0x3c0e61e8141393fe356fbfc5,
            limb1: 0x1d8bc25277bb1ab4286ade3a,
            limb2: 0x8909625abc78f9bcab652a72,
            limb3: 0xeb9db0f4e988ff0cad0e800
        };

        let (Q0_result, Q1_result, Q2_result, new_lhs_result, f_i_plus_one_of_z_result) =
            run_BLS12_381_MP_CHECK_INIT_BIT_3_circuit(
            yInv_0,
            xNegOverY_0,
            Q_0,
            yInv_1,
            xNegOverY_1,
            Q_1,
            yInv_2,
            xNegOverY_2,
            Q_2,
            R_i,
            c0,
            z,
            c_inv_of_z
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 0xd5a01b47e7a0a96c4e9828ac,
                limb1: 0x9691fc1d850f475b07cddb85,
                limb2: 0x4f641e073e94c44d8ab4514b,
                limb3: 0x5426e6c69353ef8f97721eb
            },
            x1: u384 {
                limb0: 0x7efed52714f1d0660db0cea8,
                limb1: 0x36199c4c07db0fc89756674a,
                limb2: 0x6e762fe3d4cd4ce6f6344b42,
                limb3: 0x91b1c0ee40950a779f642c4
            },
            y0: u384 {
                limb0: 0xc8de7e44a32259e1845765db,
                limb1: 0x5f215f248c730f771fb012c7,
                limb2: 0x917bf8b85d60d08f3d8de7b2,
                limb3: 0x58934e1adca733ea9ec7e87
            },
            y1: u384 {
                limb0: 0x99550f9f3debb363d330f342,
                limb1: 0xc05b48a852d31b09fc12ae24,
                limb2: 0x34749b17d700d1d27dcb4094,
                limb3: 0x66e61c706ae76cda2d80367
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x47f36e51e1f4d702ae9cd58d,
                limb1: 0xf50ff610effab6db231de4c6,
                limb2: 0xc30c9ff75e8830f152471e6c,
                limb3: 0xc43f055b8e188ba4ddfcb4
            },
            x1: u384 {
                limb0: 0xbac6eb100f7b7f925039b421,
                limb1: 0xb7e608df41e967db6d924bbf,
                limb2: 0x6a2ae9a218eeaffa0c591d01,
                limb3: 0x100a8ae62794dbb12ad6ca67
            },
            y0: u384 {
                limb0: 0x2e323038e96d6cec088911c5,
                limb1: 0x2b2b980e9bba9e9dda48d151,
                limb2: 0x39e09591ff4e91a2c336704f,
                limb3: 0x14b84e3b1a1c681f0d757734
            },
            y1: u384 {
                limb0: 0x451263ba4905858685d65569,
                limb1: 0xede8b8424b4d1fec6a15ec5d,
                limb2: 0xb5c0cb33aaa280eb30a52e51,
                limb3: 0x177e42be3b652d02c9ce9d02
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 0xa07a59d05ab4d8db77702406,
                limb1: 0x6b6bc0a330cdf67fd6d70f1e,
                limb2: 0xf35ba03df58d7a3b289bb689,
                limb3: 0xc36dd6627c7f7262e631500
            },
            x1: u384 {
                limb0: 0xfd0be630b98e3da23b6e6432,
                limb1: 0xc1b6b714fb64b4510f647dae,
                limb2: 0x6bd0cd909a5374311af80f0d,
                limb3: 0x15c353984e41079871f7fd48
            },
            y0: u384 {
                limb0: 0x3dcd6dc617032b1927104722,
                limb1: 0x87978741e6420a2ac4b555e6,
                limb2: 0xc036e701a5ae5395b6e87304,
                limb3: 0x1247186e467cc82f631ebff9
            },
            y1: u384 {
                limb0: 0xeb0dc996b9087899b4334d96,
                limb1: 0x7401bcc31ab40debbb26bdeb,
                limb2: 0x345ae652a4607a19c4bca113,
                limb3: 0xdd705faa314048a4da2ea19
            }
        };

        let new_lhs: u384 = u384 {
            limb0: 0x550a5c79358a75eed80afb9e,
            limb1: 0xbbd39a05a89446b365cbd0c6,
            limb2: 0xed757719f0fd666a2df050b,
            limb3: 0x10470b27271e75a4ca08ffc6
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0x327094a7f0a7d8c02a92055d,
            limb1: 0x232695744aa8c7241d4a4fbb,
            limb2: 0x5f154e36f335044bb8ef0fe3,
            limb3: 0x18dff3ef4f59d2c57a6dc5c6
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(Q2_result, Q2);
        assert_eq!(new_lhs_result, new_lhs);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit_BLS12_381() {
        let lambda_root_inverse = E12D {
            w0: u384 {
                limb0: 0x20c1885bf819468f30cecf39,
                limb1: 0x5d8756b2a63d256f274ae2b3,
                limb2: 0x7c82fa18a2501f76f80a2fd2,
                limb3: 0x15f5ea76f1761eb2efffe6e5
            },
            w1: u384 {
                limb0: 0x746b456ac40c8da35bc4c858,
                limb1: 0x4ca36ecb40b7dbc2e82a4d22,
                limb2: 0xfddadf240c4b6a95c05bb264,
                limb3: 0xb40328053f23d687164775d
            },
            w2: u384 {
                limb0: 0x3e7a38ac98fdda4de2d42608,
                limb1: 0xa2ab5123047286ac5bc700fd,
                limb2: 0x12531d5b37b842002207c8f5,
                limb3: 0x57d816a6d3b41b359e0cba2
            },
            w3: u384 {
                limb0: 0x14836831313de798bb5cac48,
                limb1: 0x5344900593572d5163abc639,
                limb2: 0x58acab37934c7ac7427b3842,
                limb3: 0x5d68835cdce9658d8621586
            },
            w4: u384 {
                limb0: 0xac917e14629d1140dfea9ee1,
                limb1: 0xd3128e5cbea3351de7ab1597,
                limb2: 0x914c42b7007b0a78f278d163,
                limb3: 0x17ca100fd7bbf3e9b48577ee
            },
            w5: u384 {
                limb0: 0xde5ddef2c945291e265464db,
                limb1: 0x782961fe0b7103541836a8c6,
                limb2: 0x3a1be467f167e8d8057f7417,
                limb3: 0x7349a49cba5aefe8007d5a3
            },
            w6: u384 {
                limb0: 0xe16a2f5e764b3afeb58dc25f,
                limb1: 0xeaea776a57aec533bda3235a,
                limb2: 0xd084e949dc88720de4158af7,
                limb3: 0x11ad27ca6f40bc0b5ab4f9c6
            },
            w7: u384 {
                limb0: 0x5398775858543999db726c5c,
                limb1: 0xc62dd64a97fb334bca9c48fc,
                limb2: 0x47e1918a115d3e443adf6a11,
                limb3: 0x150e8a2ec158169c4f4390d0
            },
            w8: u384 {
                limb0: 0xeacf3d21ced5d3e39fbc2d,
                limb1: 0xc204f255d0f66734341b580f,
                limb2: 0xf90117c9570d9d3cd7139e6d,
                limb3: 0xeb39921ac7d6d4048d78014
            },
            w9: u384 {
                limb0: 0x8151b349fb1a391a93244a65,
                limb1: 0x277b75fd164a5c3ac10314f9,
                limb2: 0x647edd5e68109efb62b01078,
                limb3: 0x153228ca75379dba0a99298b
            },
            w10: u384 {
                limb0: 0x4c9ed1b89532c5dad3729728,
                limb1: 0x2d889a141bb153056156d690,
                limb2: 0x8ea4a186dc203f7b3429c654,
                limb3: 0x13b56402670d3b4f5ab11c74
            },
            w11: u384 {
                limb0: 0x20c4d3f8a469da88f8508b92,
                limb1: 0xe6aafd1b841e8c4eb6b8d8c9,
                limb2: 0x49633a4bc08c45efce3706b3,
                limb3: 0x13a29674e49f86975fd00911
            }
        };

        let z: u384 = u384 {
            limb0: 0x6b790a8cd9b6f42bd383ef52,
            limb1: 0xd1f67ad0c2c656138609c2a4,
            limb2: 0xc87ea6b542ad26e96d989cc1,
            limb3: 0x14fdf32a5684a380c907727d
        };

        let scaling_factor: MillerLoopResultScalingFactor = MillerLoopResultScalingFactor {
            w0: u384 {
                limb0: 0xf20cdeaf21dd3f6c3c14e766,
                limb1: 0x3ef1fe17bfdec90a1d8be4e2,
                limb2: 0x65fbd916cd68fd5ec022e891,
                limb3: 0x8444ffae5da4e122106867b
            },
            w2: u384 {
                limb0: 0x5cad37aa80f6f49c39f35b85,
                limb1: 0x3c3c48dfc76d221fa6581f79,
                limb2: 0x9d377dd5bbdb886a0bb1b53f,
                limb3: 0x13291f6f4fd31bda4d2e173e
            },
            w4: u384 {
                limb0: 0x4bdfc57989b058677de0cadb,
                limb1: 0xf2bb3e4265a0596c8cdcc2ce,
                limb2: 0x1fa628625ae33a0e6b250adb,
                limb3: 0x419f9c9bde2f7a40029eb0b
            },
            w6: u384 {
                limb0: 0x1828315dce253002583194d4,
                limb1: 0x17f78ef2d10e12bcaa504678,
                limb2: 0xb9c48dc844cf672e37b2185d,
                limb3: 0xfaa2beb9855226a6ec6b631
            },
            w8: u384 {
                limb0: 0xf24870b6a38a124309b521fc,
                limb1: 0x399923ff869a19a68dab234,
                limb2: 0x17d368bd5f5a2540bb79a78f,
                limb3: 0x91c2f18b2865b867576227f
            },
            w10: u384 {
                limb0: 0x9af6b0ff532658447a6cb906,
                limb1: 0x9e11a44fc0f7d9864a36a519,
                limb2: 0x9222abd03327b039dc4f9b59,
                limb3: 0x135f6d03f870155c38fc7db8
            }
        };

        let (c_inv_of_z_result, scaling_factor_of_z_result, c_inv_frob_1_of_z_result) =
            run_BLS12_381_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit(
            lambda_root_inverse, z, scaling_factor
        );
        let c_inv_of_z: u384 = u384 {
            limb0: 0xf14ef2e773b19642cedbab0c,
            limb1: 0x3173b6aed7e948a370c53bc9,
            limb2: 0x4c1c46589748f276cfb1babb,
            limb3: 0x692d42e4dce06734c018374
        };

        let scaling_factor_of_z: u384 = u384 {
            limb0: 0xb87649c9f158dcbe20320023,
            limb1: 0xfc7d3308f4a8002d50918a4,
            limb2: 0xfa78d24657901c57240f2af0,
            limb3: 0x13826762146e9923ac366b28
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 0x444ab818d1de9e5a250211ac,
            limb1: 0xd9976f834e9669971c66a94e,
            limb2: 0xeafeae822cbec7a0b0b6e472,
            limb3: 0x1662f729bad73aac86795f17
        };
        assert_eq!(c_inv_of_z_result, c_inv_of_z);
        assert_eq!(scaling_factor_of_z_result, scaling_factor_of_z);
        assert_eq!(c_inv_frob_1_of_z_result, c_inv_frob_1_of_z);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_PREPARE_PAIRS_2_circuit_BLS12_381() {
        let p_0: G1Point = G1Point {
            x: u384 {
                limb0: 0xa5613b89e131913fb7309855,
                limb1: 0xb36889013bc3411cc2ae4936,
                limb2: 0xd843bb440165035067db8350,
                limb3: 0xf1ec6123df2a81ba4e115dd
            },
            y: u384 {
                limb0: 0xce1be150d15417a8ee61157c,
                limb1: 0xc72d2b328295ec2837599b77,
                limb2: 0x82e02823b040a3a18a90fbbb,
                limb3: 0xc4b0c5fb71200ceb3c53c5a
            }
        };

        let p_1: G1Point = G1Point {
            x: u384 {
                limb0: 0xd0cd64e2bd797714a3f542b9,
                limb1: 0x7d31df968684f88a5a4658f9,
                limb2: 0x15222401d3a9fcd6e4f94a2a,
                limb3: 0xfee76e1ca2dd546090ba179
            },
            y: u384 {
                limb0: 0xca06a5743f1b63ade1658924,
                limb1: 0x337b4f8d1e5a83ede9e05c90,
                limb2: 0x2098054e77e398e683f5df77,
                limb3: 0x3aaf556aa63a5464c5fb152
            }
        };

        let (p_0_result, p_1_result) = run_BLS12_381_MP_CHECK_PREPARE_PAIRS_2_circuit(p_0, p_1);
        let p_0: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 0xe2cfd466379787e87f7092ed,
                limb1: 0x5dff1d9f95c3e3fdadf0eebd,
                limb2: 0xd1720f78387b811c6a759ca6,
                limb3: 0x111656740a7fd957ed351849
            },
            xNegOverY: u384 {
                limb0: 0x616eeb90aac38d53abbd7916,
                limb1: 0x81c22ad0a362178a699add27,
                limb2: 0x8e64fb4ecc96a4ddce1b55d2,
                limb3: 0xb0f2637cacedf988cb0c41b
            }
        };
        let p_1: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 0xba068cdafab3ee334e2d1bcc,
                limb1: 0xeab1aa24570f47f12b9357fd,
                limb2: 0x8a24b1668bfa4791df0f4876,
                limb3: 0x13ae8926ecbb3b234112287
            },
            xNegOverY: u384 {
                limb0: 0xdf38f4796bf855a49dc16604,
                limb1: 0xa08d65118281ff1bb95926bc,
                limb2: 0xa15dd7a6b14965724a9d96cb,
                limb3: 0x117bf0ed540d6de87e7aaf38
            }
        };
        assert_eq!(p_0_result, p_0);
        assert_eq!(p_1_result, p_1);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_PREPARE_PAIRS_3_circuit_BLS12_381() {
        let p_0: G1Point = G1Point {
            x: u384 {
                limb0: 0xb432df57bae747f795f0307c,
                limb1: 0xaa7fc4cda908c744fc56b9dc,
                limb2: 0xbe77e2108e51128d8b129b67,
                limb3: 0x156a5e70f3c366990f94ce97
            },
            y: u384 {
                limb0: 0x47e917260a51f91354cd927e,
                limb1: 0xa638b53dea04c35d232aabb1,
                limb2: 0x11392323dc01d5dc967edff2,
                limb3: 0x18cc37ce5005341f82ac0ab4
            }
        };

        let p_1: G1Point = G1Point {
            x: u384 {
                limb0: 0x7726451d8626d37d6121df84,
                limb1: 0x94296b689ce2b31292f94c4d,
                limb2: 0x1a1636ce12ae37a849d1d424,
                limb3: 0xb758e597905d1e3f55953f4
            },
            y: u384 {
                limb0: 0x369f36d9bfa2bd08f19edf12,
                limb1: 0x5112a02c018b89fcb7a7f7a,
                limb2: 0x8327f24cd6c556cb1900baae,
                limb3: 0x12b1dea4841a876260d5e821
            }
        };

        let p_2: G1Point = G1Point {
            x: u384 {
                limb0: 0x92716ec5d77bc9c930a0292e,
                limb1: 0x6d911405e567e67c552a19c6,
                limb2: 0xead026a474c9118fd7ee33d7,
                limb3: 0xcb956eb443f5081577352bb
            },
            y: u384 {
                limb0: 0xc58d376f7bdd4130be7c18ea,
                limb1: 0x6ed44b11144844d2bb70815a,
                limb2: 0xba3b8d148df54a24e6e409f4,
                limb3: 0x6253928be8145d9416488c7
            }
        };

        let (p_0_result, p_1_result, p_2_result) = run_BLS12_381_MP_CHECK_PREPARE_PAIRS_3_circuit(
            p_0, p_1, p_2
        );
        let p_0: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 0x98361c5783bf391497c545a4,
                limb1: 0x865927e30a4bd6c90e355ceb,
                limb2: 0xd071691d541f0c7ca909672d,
                limb3: 0xbfe98245dab8c53a1f18bcb
            },
            xNegOverY: u384 {
                limb0: 0x140e999c929bfd27bf60b4e3,
                limb1: 0xb16fcd8443c7384f522d6e39,
                limb2: 0xdbc4558444d19e6bbae4036,
                limb3: 0x122e925ebbc3f40f787bf94b
            }
        };
        let p_1: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 0xe891ff8b58f61279d559ecca,
                limb1: 0x602df6c30c0c6c1d02aa72ad,
                limb2: 0x17daed96f9a16538f1745e44,
                limb3: 0x13bcb443fd5589df56212929
            },
            xNegOverY: u384 {
                limb0: 0x6da3ddc2d51794392a4aef1e,
                limb1: 0x9c7597b6cb620e1c957a5762,
                limb2: 0x24157b0352ff630502a507b3,
                limb3: 0x155ebe4c27504072b723fee
            }
        };
        let p_2: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 0xb6503365489d653e484d64cb,
                limb1: 0x4a63d3f450c45e6ea2e116aa,
                limb2: 0x3de5ba02cef0e7dc7b9614cd,
                limb3: 0xfd3005052bb535cf5fa6231
            },
            xNegOverY: u384 {
                limb0: 0xc117a783cda4938d230f52c,
                limb1: 0xe5d562d68308af9444deeb29,
                limb2: 0x6127533d2c3a520a2c7a235e,
                limb3: 0x176f52650271e043595f0e19
            }
        };
        assert_eq!(p_0_result, p_0);
        assert_eq!(p_1_result, p_1);
        assert_eq!(p_2_result, p_2);
    }


    #[test]
    fn test_run_BN254_MP_CHECK_BIT00_LOOP_2_circuit_BN254() {
        let yInv_0: u384 = u384 {
            limb0: 0x1498665b79fe0a1b7efbe877,
            limb1: 0x891dfa7b0d3dc6aadba45b5e,
            limb2: 0x19b945d9dcb32e4a,
            limb3: 0x0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0xdbc33e56c8a17945ca6d3e06,
            limb1: 0x71dade6432255eeeceb9505,
            limb2: 0x2103eec2a5e327af,
            limb3: 0x0
        };

        let Q_0: G2Point = G2Point {
            x0: u384 {
                limb0: 0xd39a4bb0d62b68d41880fa4b,
                limb1: 0x5bc9e8895567a84c1480f037,
                limb2: 0x64d97d8f484878d,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x259a2b28b22b89748c5c192f,
                limb1: 0xc781e11f2cb38568291a58af,
                limb2: 0xa2ca66febbe1a41,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x3e19d0baae09ccfba3dee81f,
                limb1: 0xef23d4afe0ff58a5f172840f,
                limb2: 0x150262399fed6060,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x7ba06f58061ae8d1f212cc6f,
                limb1: 0xa036e74be34d7804f5657d00,
                limb2: 0x197a8a74adae7e45,
                limb3: 0x0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0x39ddc4775a220eb23cf9d1fe,
            limb1: 0x6bb6204ee0db22d329e316ad,
            limb2: 0x174015c57680891b,
            limb3: 0x0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0x2353d45590bccb66e0631450,
            limb1: 0xc5507d2b909e7f7862f25291,
            limb2: 0xa60840303729e33,
            limb3: 0x0
        };

        let Q_1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x1716f1d956a2f20ee283bb7,
                limb1: 0xb7ed75b463d0fccdafdb4e0b,
                limb2: 0xb016e1ccd34bcd7,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x4fe973d261cec19fff83cec,
                limb1: 0x52c553b5d2f7442906714938,
                limb2: 0x3c918082951fe0,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xc6f149c70c15a57509c64c1d,
                limb1: 0x92b035e01ca5a2f5ecf150e6,
                limb2: 0x973d4719c899296,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xac7074642734f9bbc7405255,
                limb1: 0xc9a6e611613f718dc96ef1a5,
                limb2: 0x1acc975206c4e109,
                limb3: 0x0
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 0x829fe7ba5d30db822348e1b7,
            limb1: 0x667fceeb8889832c37773772,
            limb2: 0x84e9ab612b34a24,
            limb3: 0x0
        };

        let f_i_of_z: u384 = u384 {
            limb0: 0x789c3c723ee29e686fa00319,
            limb1: 0xea951570399bcb7961bafa39,
            limb2: 0xf5d0e7b65141471,
            limb3: 0x0
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 0x65a5ac1f7b2ecfc5a53011a2,
                limb1: 0x11ab249d94d50a99eba08424,
                limb2: 0x1026cf16d5e8b89c,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0xe291f5e1469fc269ff7acd86,
                limb1: 0x8ad6cc515f2e104886ce563d,
                limb2: 0x26a87b35058fe8d5,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0x797c27bfc79385209c921e7f,
                limb1: 0x46ba68553cad275ae072caae,
                limb2: 0x271a137c0a515e87,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0xcc4e66dade0989b952526d45,
                limb1: 0xa0483bb2f6d080c46409df32,
                limb2: 0x2234ca061b4e1428,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0xdec772b7bb22fa316bc9e970,
                limb1: 0x6ed63ea464a2bc48f9fb4010,
                limb2: 0x6b559b0ecb03f48,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0x9aabd22d75ef8aabb693f4ef,
                limb1: 0x2b6b7b42295023267644d183,
                limb2: 0x1e5be620572abb53,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0xeef671391ccdd34080e97f74,
                limb1: 0x24878d19586d7f415e47c2a0,
                limb2: 0x16e3446ea0ec3e5a,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0x2d492ca241f4317df5141524,
                limb1: 0x531da6ac956c2129b934718f,
                limb2: 0x1853c7774bc972ce,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0x4a8636550a9d499ca2698c2d,
                limb1: 0x8ef444a6e63ffa48d2ad974,
                limb2: 0x1a4666a2aea62315,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0xba5612f7600aa45e44e1b08c,
                limb1: 0x22587c8958ccf9b4354af1bd,
                limb2: 0x70f234d21d4fb7e,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0x2a6f1e475b61f92b9cf600ec,
                limb1: 0x93a25c9b6e3a52d707fe6a4e,
                limb2: 0x1daa4cf365fd5f69,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0xb5f50316a45335cc137fcd2b,
                limb1: 0x13ec5718ae4a741ab5004950,
                limb2: 0x1b3a35f7c71d92d6,
                limb3: 0x0
            }
        };

        let z: u384 = u384 {
            limb0: 0x8dcd7d64b9e8e4ee8b7f6d7a,
            limb1: 0x2728ec952b52dab12367ad9e,
            limb2: 0xa86b3a1351c5aac,
            limb3: 0x0
        };

        let ci: u384 = u384 {
            limb0: 0xbc6284a89f93e802e1c25cd1,
            limb1: 0xcb10cf68b769147049bcf4a8,
            limb2: 0x2bc9cfd055cdd72e,
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
                limb0: 0x2036e28fccfaf89acb1dba86,
                limb1: 0xb9370a1c31cff17aad80e621,
                limb2: 0x178282b12448d9d6,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xd4e6fc7489b50f265a1028f3,
                limb1: 0x513820be0c163547f9e9be59,
                limb2: 0x1ede04f779fd542a,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xf262dd7d41785fb71433534a,
                limb1: 0xca98bf40bbdc62da8ae5a06a,
                limb2: 0x185bf60f2f3259c0,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x40610afeb297baee644e5f0d,
                limb1: 0xdd07913d20db30ac74e8436,
                limb2: 0x23728dfff0f931a2,
                limb3: 0x0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x4ecf9c621611605e542e1e95,
                limb1: 0x880a87c33173ed9f7e6c185d,
                limb2: 0x3ecf6566f840d18,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x3ec7f13d57d6ad7ccfc0f870,
                limb1: 0x9d00527f3277faa061afa66c,
                limb2: 0x21ef826d99565e51,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x2ed56d4f1408aafead532c9a,
                limb1: 0xafaabc42532651b3882b082a,
                limb2: 0x75f74152c271eb0,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xedb2aee52b8514b359b4f352,
                limb1: 0xff3d0e032636334d4617b3cd,
                limb2: 0x1e1f58b537f8c1f9,
                limb3: 0x0
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0xf9a8aa166e7541faa60cea72,
            limb1: 0xa5cf9094e49a5910eabedb8d,
            limb2: 0x20148de364b36275,
            limb3: 0x0
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 0x722c953a39aa2bbca62de48a,
            limb1: 0x3a103950139e70a9143624f3,
            limb2: 0x2dc64a8a02718a54,
            limb3: 0x0
        };

        let ci_plus_one: u384 = u384 {
            limb0: 0x82acbfbe95565fe9197fad34,
            limb1: 0x666401877510b6822571728b,
            limb2: 0x1f79572fdc99393,
            limb3: 0x0
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
        assert_eq!(lhs_i_plus_one_result, lhs_i_plus_one);
        assert_eq!(ci_plus_one_result, ci_plus_one);
    }


    #[test]
    fn test_run_BN254_MP_CHECK_BIT00_LOOP_3_circuit_BN254() {
        let yInv_0: u384 = u384 {
            limb0: 0xb1f5d7d0887b4cca54f02dc4,
            limb1: 0x604aa4a2e983cc1d25033a3e,
            limb2: 0x2f58decefc0b1519,
            limb3: 0x0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0x4e245cf78e33dcabbe684e2b,
            limb1: 0xea31e67ae16802053c0a94de,
            limb2: 0x183a6f5efe1c51e5,
            limb3: 0x0
        };

        let Q_0: G2Point = G2Point {
            x0: u384 {
                limb0: 0xf2ded00f63e8695158b5f052,
                limb1: 0x4e60678b82f4b48a78a55d6b,
                limb2: 0x1a3f190af6f25926,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xd01cf93568032f7efef06b04,
                limb1: 0xf924e06aaef5baef1903b45f,
                limb2: 0x973091e276d7e19,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xb26489f71b58286c8461f840,
                limb1: 0xb2b4c281a5b91ee8c77f0b62,
                limb2: 0x26215b1f3475a526,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xfb5214d99a66d48da4f0d9c2,
                limb1: 0x444517ef1c769e1f83719849,
                limb2: 0x2ed7c570b0445ebb,
                limb3: 0x0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0x603803f32b2bcfda9d4319b5,
            limb1: 0x938ad77cb18d6a415db4487,
            limb2: 0x762b06a02af3382,
            limb3: 0x0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0xd13ec39c5cb6f1f0e4751694,
            limb1: 0x517fa07e7b0f78c1b8f35c26,
            limb2: 0x2b432aff1baf01f1,
            limb3: 0x0
        };

        let Q_1: G2Point = G2Point {
            x0: u384 {
                limb0: 0xdb3aefa6c7d0286213f36e53,
                limb1: 0xe2cd159aebba80d2820bc51d,
                limb2: 0x1a667872b02237e,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xd97d2b38a4a98266d3d6362b,
                limb1: 0xfe656befe0efc9892ab465e9,
                limb2: 0x1a2b70a38463416a,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x3544f189a92046339bb68cd2,
                limb1: 0xaf04ef81b5481bf2702cebbe,
                limb2: 0x10e7775d67af36d9,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x225f545796625aa1056b565f,
                limb1: 0x2bdc9c10636241c3eb6ec9e0,
                limb2: 0x1c38bb98e29b24d7,
                limb3: 0x0
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 0xea8fd23d0dbc321b90a00ee1,
            limb1: 0xcd6665d8edf2a72060032713,
            limb2: 0x29383b961638325c,
            limb3: 0x0
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 0x55a3a12967ba6b1a96954911,
            limb1: 0xdf98377981bd53363bac2660,
            limb2: 0x280b698749d4601,
            limb3: 0x0
        };

        let Q_2: G2Point = G2Point {
            x0: u384 {
                limb0: 0x1a0ff2189eb883257add8fed,
                limb1: 0x81eb88e5d549faad44c8fd00,
                limb2: 0x23402dec7d82fccf,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x7901799064e322cfa51de78b,
                limb1: 0x3ad23fbf2e57386443eb280e,
                limb2: 0x17510e088a7f03ae,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xda286b7a4d6d99a628d798b4,
                limb1: 0xeab3c4d8d4e4004b9bde299d,
                limb2: 0x1d3e315e24c582ca,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x1188afa1f660ffd5119fc1c4,
                limb1: 0x90ed41f464aba3f67a658abe,
                limb2: 0x1a3d26d4f3fa8613,
                limb3: 0x0
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 0x43f98cbd179d221d8e5f37fa,
            limb1: 0xd0813d923aca43f27b777bf2,
            limb2: 0x12fd07841c622f82,
            limb3: 0x0
        };

        let f_i_of_z: u384 = u384 {
            limb0: 0xcfd645605c05c1f3241d3e27,
            limb1: 0xa88f58c1237d7b90181a218e,
            limb2: 0x3a11ca9dd332379,
            limb3: 0x0
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 0x2305e6d3aa61353ad2b00078,
                limb1: 0x32d116fe8f08963c96248805,
                limb2: 0x21db6aa01ce5fc6,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0x8eeb3fd86783b0c3dcae667e,
                limb1: 0x9a0a80bec15dfcfcb325442c,
                limb2: 0x2db419bc7d874566,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0x18f7e499df61c53457d1d37c,
                limb1: 0x3ddf55b2015128dbaf8c96a9,
                limb2: 0x1fdafd463a05c0b7,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0x4fbe2aaefbf70946d6ada066,
                limb1: 0x24bfe48398071b14642cddb,
                limb2: 0x16b61c4b7ee1a2a3,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0x824c6948f474b1a4f2684ee1,
                limb1: 0x17776c3a57435d9ced3032ed,
                limb2: 0x138147ba13d72846,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0xe166c6aba8f614bd7b2aa677,
                limb1: 0x486c0adf5bf26ec8c814ed3c,
                limb2: 0x2731d4eb6264190f,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0xa7fb881e3a88a4ab78916712,
                limb1: 0xa1d534025fba6dc2b594b706,
                limb2: 0x16f5c771ea75e34d,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0x5bf572794704768e6e927501,
                limb1: 0xc46f5825669ff1b9f902d6c0,
                limb2: 0x2db83ab0c42bf4c4,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0xddd3e7794879996dfe38f4eb,
                limb1: 0xe75241027acf6bcc1af4321a,
                limb2: 0x7b85c8e4a9686a4,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0x9e3b3f04d418864590de6fba,
                limb1: 0x6637c09facf606fc387cdf02,
                limb2: 0x13eacab68091a21d,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0x5084a40f3b8f5fc77c96eefa,
                limb1: 0x6b8fd6af157ed9849648e8,
                limb2: 0x1e316a5d178672e8,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0xe4172ba364eec62b51306e5c,
                limb1: 0xd21dbc093a357442f325f875,
                limb2: 0x1b9b421bf7b37a86,
                limb3: 0x0
            }
        };

        let z: u384 = u384 {
            limb0: 0x934c472a0c72fe13fbf28c1c,
            limb1: 0x681091fe0a5a0322c57842a9,
            limb2: 0x10dc927f17ee2fe6,
            limb3: 0x0
        };

        let ci: u384 = u384 {
            limb0: 0x53a9ec5db9b5c70e3346f7c6,
            limb1: 0x2e4a6e781cf4a8ed2db6de21,
            limb2: 0x2cb6a87dcc16014a,
            limb3: 0x0
        };

        let (
            Q0_result,
            Q1_result,
            Q2_result,
            f_i_plus_one_of_z_result,
            lhs_i_plus_one_result,
            ci_plus_one_result
        ) =
            run_BN254_MP_CHECK_BIT00_LOOP_3_circuit(
            yInv_0,
            xNegOverY_0,
            Q_0,
            yInv_1,
            xNegOverY_1,
            Q_1,
            yInv_2,
            xNegOverY_2,
            Q_2,
            lhs_i,
            f_i_of_z,
            f_i_plus_one,
            z,
            ci
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x4c60820fcd3b11fb3d712eef,
                limb1: 0x3848543f94a04856fba7b602,
                limb2: 0x1c8414daa829b4cd,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xf934adee9f5a786e772d7fe5,
                limb1: 0x4268cb6c0e6ca6ae80cd8ac2,
                limb2: 0x18cb6875a3181d14,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xc151fa5e21ef46b72520b09e,
                limb1: 0x2ec8c0689ff0f943e7fd78d2,
                limb2: 0xa6522ba43440eff,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x7a0f6f47cb3807ae03968076,
                limb1: 0x86aa34ff7b97b68653648504,
                limb2: 0x2383f59f2725a85e,
                limb3: 0x0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0xc36d5f208df04f0ed84b27c8,
                limb1: 0xe3cb85bf1a1902d8445ccdb9,
                limb2: 0x11e50fee00c8f48f,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xe1931c0b2f9908e06a1e1e2c,
                limb1: 0xce712717cda8e40f30f81a90,
                limb2: 0x20b744ff8370b279,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x8038d5e49e1612b383809e13,
                limb1: 0x8386b7154ca7e050d782510d,
                limb2: 0x689d2ff57ed2c49,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xce327997add09fcdce56bea5,
                limb1: 0x6e3815c5d9625141e25f1e24,
                limb2: 0xc0d54bd45772023,
                limb3: 0x0
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 0x301ddf3161ca08d87e7fa02,
                limb1: 0x64dc2f667aec995389f5b8ef,
                limb2: 0x2f32657b6d962bc2,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x9f8bd09c3ed05e0b54ef8fce,
                limb1: 0xe14c5489b1d6fb628b9c9c84,
                limb2: 0x1c9b124899b0c461,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x7447bcee7aaacf41dc9265f4,
                limb1: 0xb744f0c72404e7b4cc538683,
                limb2: 0x2ca2bfc6d4c89c1e,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x8425ad0be1675514f60861ef,
                limb1: 0x9a1e71901a0537daa038c7a5,
                limb2: 0x1b977ea27bbb3759,
                limb3: 0x0
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0x7c2a1816f6dd8935fd24098d,
            limb1: 0x393fee680ba7c105f8de579f,
            limb2: 0x21cbb560a4cd309d,
            limb3: 0x0
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 0xef8fe1fcec192193b9a20fab,
            limb1: 0xe5c198246d73965ace33529e,
            limb2: 0x2812b79b379bde99,
            limb3: 0x0
        };

        let ci_plus_one: u384 = u384 {
            limb0: 0xbcc3d95b8a7f7786cb7c292,
            limb1: 0x2f186bfe07bd48678c0139ef,
            limb2: 0x22f45b9b61a2dd42,
            limb3: 0x0
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(Q2_result, Q2);
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
    fn test_run_BN254_MP_CHECK_BIT0_LOOP_3_circuit_BN254() {
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

        let yInv_2: u384 = u384 {
            limb0: 0x9c14940d5b2d81ccc602bd20,
            limb1: 0x4e98ce2517337a7c53e83663,
            limb2: 0x1f856a8b07b6e28f,
            limb3: 0x0
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 0x402492a3c334f55802cee581,
            limb1: 0x65dcac6cc329870a33e9e55e,
            limb2: 0x1be110e462f9dbb2,
            limb3: 0x0
        };

        let Q_2: G2Point = G2Point {
            x0: u384 {
                limb0: 0x771ec087952b1ee109d5b64f,
                limb1: 0x919c21edd47133e75ac5f4f0,
                limb2: 0x241f614c2076d932,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xaa5658322a5a421858da7da,
                limb1: 0xdd6d47e490e0172f14dc01bc,
                limb2: 0x171af96558f16c91,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x30d6863f11c272d801267789,
                limb1: 0xabe0a1771c5e1698b7a02afd,
                limb2: 0x1e268a0a8a663359,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xed9a189a50852f4f0b09ec41,
                limb1: 0xf45aa79bd855fb35d763b159,
                limb2: 0x19ffb39f1ff06dc,
                limb3: 0x0
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 0xe7bf9a9664849eb55096ccf2,
            limb1: 0xfe292238fbfbe6022011bc8a,
            limb2: 0x28ad3485c3c5707d,
            limb3: 0x0
        };

        let f_i_of_z: u384 = u384 {
            limb0: 0xa4531fe9b48f653e7b1bcb6b,
            limb1: 0xb93c2989c399fd7fb75db71e,
            limb2: 0x2eb530a20bf56ed8,
            limb3: 0x0
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 0xb20ee0f85050a17d2e1ed4d,
                limb1: 0xb0f1bb1d8e10fed6d2d07223,
                limb2: 0x2ca0d526be80793e,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0xb34dc8b053f3c15842ce91c0,
                limb1: 0xc846bf9040fe6898b56b9357,
                limb2: 0x211dabe6425de95f,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0xffa0841974dbcc40ef7dee1a,
                limb1: 0xc1b5468a27bb1580e8f58c5d,
                limb2: 0x1cb98c5be6710ad2,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0x9e1c3b0271f27728d7f7ba5,
                limb1: 0x2d4da4ef95e38180a1ee691a,
                limb2: 0x20c84084a43c991d,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0xc1f8190be55e44b808a6d5b4,
                limb1: 0xf25dcb50d15b598550eaa1d2,
                limb2: 0xc5842cf1257363c,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0x74e04bbbca8033a7a5fd89c8,
                limb1: 0xcff0c8ac3d1cd68c9c63765b,
                limb2: 0x216cc0f4756b6c0d,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0x8b1f11370ea255e08e50c79a,
                limb1: 0x848610cfd21276c21519401c,
                limb2: 0x28500b57e7ef7b,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0x147a08acc65d8e4ed01e488b,
                limb1: 0x9b87cc5e6d7fe9b21a9e8547,
                limb2: 0x247f5f525a31a6a6,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0x1e6cbd83a2f62516dc88b09c,
                limb1: 0xeceec38d511fcda922d80170,
                limb2: 0xbafb4df05d156b6,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0x4ea581d20068c1cbbd743b3,
                limb1: 0x9b83acd5e2ccddd8567fec5e,
                limb2: 0x2d32e82317eeb1d,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0x13d1ea49ed469bf4d5cf2dc4,
                limb1: 0x70d227180dd35d11688181a8,
                limb2: 0x26aa427c5adffd04,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0x6987b05274219d3ecdc39412,
                limb1: 0x7427965607db34e02e402534,
                limb2: 0x10e7d2e1cd6a5e0c,
                limb3: 0x0
            }
        };

        let z: u384 = u384 {
            limb0: 0x633d9c54f30459cc30c42d61,
            limb1: 0x18a775945b8c4949106861d3,
            limb2: 0x1ad0adb1f94e3c8,
            limb3: 0x0
        };

        let ci: u384 = u384 {
            limb0: 0x74db99f352a33c33037e5725,
            limb1: 0xbefa9c478dd6650fca6ef7ce,
            limb2: 0x2c7861b5df254e5d,
            limb3: 0x0
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
            Q_0,
            yInv_1,
            xNegOverY_1,
            Q_1,
            yInv_2,
            xNegOverY_2,
            Q_2,
            lhs_i,
            f_i_of_z,
            f_i_plus_one,
            z,
            ci
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x949bda6b97cf6cfc7f08d366,
                limb1: 0x159434b8fe74c5580a458a1a,
                limb2: 0x15349259111a577,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x8b1fec80f37907251ecf6438,
                limb1: 0xeb48c3ff9f8e510700678f94,
                limb2: 0x2719b89c03989901,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x3c95186a5bd0502fe3b33c1a,
                limb1: 0x3a7f6789f79603f943cb09bc,
                limb2: 0x23ec72a2af89e4e,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xf8cc7c2129235b9125838df9,
                limb1: 0x3d6d1661378e41126fb8b30c,
                limb2: 0x175b2605e2e8d11a,
                limb3: 0x0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0xb4209b3577ca636a470286fe,
                limb1: 0x8e2d28b19a69bfe8f82463c5,
                limb2: 0xe0c97ebfa809a87,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x61c573eb9c3487f4b25b5edc,
                limb1: 0x8cb62470d6177f2bd965e195,
                limb2: 0x2bac0eb9621f70c0,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x544d5835266c4b791ef43111,
                limb1: 0xa05254d605dbcdff16cdba7a,
                limb2: 0x14959ea22477a079,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xcae94971665d7074447863aa,
                limb1: 0xa4d8fc7ccb4f0f866335f663,
                limb2: 0x44ef9709c4f6dcd,
                limb3: 0x0
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 0x44781b87a007fb8fa097e834,
                limb1: 0x9ba880aebabf37a765cc4e6a,
                limb2: 0xe5be23a93ac81,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x89a69794daee5151f56fa8f5,
                limb1: 0x2f1b4dde549c1383478d715d,
                limb2: 0x21f38966348730ca,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x3b0d90f2bafdd1d99a882d84,
                limb1: 0x91acddca5dc97b05f4ea30cf,
                limb2: 0x7c2bed52b68c666,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x42fd9294840ab84242e9ea83,
                limb1: 0x760a286ee487134b154617cd,
                limb2: 0x53c10c655d363,
                limb3: 0x0
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0x5191aeaad75daaf5af725dab,
            limb1: 0x90bd5bec935c7d03bfc7189a,
            limb2: 0x28b409c623667d0d,
            limb3: 0x0
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 0x6ff7ec7187367ec7ffaf299,
            limb1: 0xc7f3ca1368ff6643c880e8db,
            limb2: 0x1cc69510ed41bf0a,
            limb3: 0x0
        };

        let ci_plus_one: u384 = u384 {
            limb0: 0x6cc18ceb1b6b528afe9b1a60,
            limb1: 0xff282d7aef92f95ea3a2d949,
            limb2: 0x1970e72d89b60dd7,
            limb3: 0x0
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
            limb0: 0x3bd5f8a2073c36ba5d393bf9,
            limb1: 0x212585b0b2f8580f3f05323,
            limb2: 0x2236824661f6c877,
            limb3: 0x0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0xbdb62ff314e167063309a536,
            limb1: 0xd9073286329cd43a7751b3fa,
            limb2: 0x214b4bb90061fd30,
            limb3: 0x0
        };

        let Q_0: G2Point = G2Point {
            x0: u384 {
                limb0: 0xeda678063a19607d3bfb255e,
                limb1: 0x7984f33f61c61ae46a594b07,
                limb2: 0x60f3fceb09220,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x95331356074f3be044f20133,
                limb1: 0x5e12425cb42fb35758d97f4a,
                limb2: 0x1596bda6d3bb63d7,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xa408001f743397f1ad5b9bb2,
                limb1: 0x845c21e7988d0e4a2266a107,
                limb2: 0x101c26f51790a6b7,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xb6ffe12c1a6f0c9af1f7e90f,
                limb1: 0x62d7f7a45dae1f31a7e256d,
                limb2: 0x914d81db13de531,
                limb3: 0x0
            }
        };

        let Q_or_Q_neg_0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x339fbb6951cd2c07a8f78b61,
                limb1: 0x801841f4820d15c66bd1f046,
                limb2: 0x23d074f91eceb5e5,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xe93b4418b170b1ed1b040be3,
                limb1: 0x824d9e961fe253b079801aaa,
                limb2: 0x1ca6f608e4ad24e2,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x74747f6f2dbdb6e57844c2ac,
                limb1: 0x20fe652b56fe23018c3af69e,
                limb2: 0x1048a75d6a8d3e84,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x3f9bbcfc742c59053bcab3ea,
                limb1: 0xc674d2447b056d0259de5319,
                limb2: 0x1a420ef5ef617cac,
                limb3: 0x0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0x72323dc9c67781b2c3a31607,
            limb1: 0x3db612f46df2fc823956fba9,
            limb2: 0x1e8af81240d2d16f,
            limb3: 0x0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0x3a6f36fa241813ef799fde33,
            limb1: 0x5c27761d4894d9fc70df67b9,
            limb2: 0x1f1da964a73e3f3b,
            limb3: 0x0
        };

        let Q_1: G2Point = G2Point {
            x0: u384 {
                limb0: 0xedf6b1e0ee8f0e0999755cb9,
                limb1: 0xd4e26a5bf807cdd926184c80,
                limb2: 0x2bced6a485bab545,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x4cc672fc3006ff85166a1a98,
                limb1: 0xa182e35f848edc98eec9fa67,
                limb2: 0x7db3bb0ac546740,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x27b51ee70f1a6c44f239fbb0,
                limb1: 0x559de20409642b3157c2747f,
                limb2: 0x27cb576edebaa89f,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xc408143f290d07e4ce1f4081,
                limb1: 0x63eaa00577f63854e668bb6e,
                limb2: 0xc022946ad830951,
                limb3: 0x0
            }
        };

        let Q_or_Q_neg_1: G2Point = G2Point {
            x0: u384 {
                limb0: 0xb9534807300961c3855a7d8d,
                limb1: 0x84eaf9432ee66e2153fb2ed1,
                limb2: 0x22bcdf5cec4f4490,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x9830349dd9efbb41b66b6b0b,
                limb1: 0x26f332446f1d5baf952b750d,
                limb2: 0x2c143ac0a22fc818,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xe61b4dc67e525e4f9e203161,
                limb1: 0xedc641cd921bc646a9c7ae92,
                limb2: 0x2646ad44369fe284,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x3e332f35086c976870fe3cfc,
                limb1: 0x9a9dadd2e7aad0707cddb4cc,
                limb2: 0x1454fdcdd7f14ec2,
                limb3: 0x0
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 0x3246b7d9bb2966398e4a295d,
            limb1: 0xff0952a0b2591c40021b632,
            limb2: 0xf8ad9942258edf3,
            limb3: 0x0
        };

        let f_i_of_z: u384 = u384 {
            limb0: 0xac98a368dfc8b87a7176d181,
            limb1: 0xa92c3c3e3957f0829c272c51,
            limb2: 0x6fabe73af3cb9d0,
            limb3: 0x0
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 0xc1da8d39f7350626dca8b6fd,
                limb1: 0xecb3077a6cef5e55840658d1,
                limb2: 0x289487d4a54e6c8f,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0xe2aa55a7495103edfd05a5f5,
                limb1: 0x7e5168dc5690f74daedab7b5,
                limb2: 0xc4c1f91af797546,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0x8eafb3235f65380029c836e0,
                limb1: 0xb7ae77585b45cf5ad7de701d,
                limb2: 0x19032883702a5b67,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0xa9c9a24efd723837705bacc2,
                limb1: 0xfde9d47dd89331ac51497435,
                limb2: 0x44f060d77f4531b,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0x76c0c651f361c49764e0dab3,
                limb1: 0x35c3de958a647b9fb52f6009,
                limb2: 0x178b4915e46232e7,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0x5727bb50bee2ebdb44788bd,
                limb1: 0x166adfc43513198c67f8ab57,
                limb2: 0x1a63bb2eda98da57,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0xdfb8770891d2125a95e19cb6,
                limb1: 0x8a74bec56951743eca6cb87c,
                limb2: 0x2889460e35e1392e,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0x6151787e4f027fe87d5d9031,
                limb1: 0x10e857f88986148f8b3e00e7,
                limb2: 0x26b5cdc0140a642e,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0x7e240205bb00d206f8542953,
                limb1: 0x34367eaa03ea038fc095e099,
                limb2: 0x277d25fc6b5a174d,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0x2743e0df5e15428a833cf90f,
                limb1: 0x1c351dc942260a44773b8350,
                limb2: 0x1c9e275d97f0bfcf,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0xd6a2c379e0c6a8a74748f7ea,
                limb1: 0x61f9c40838330558fb2323e7,
                limb2: 0x2fbe1d356251d74d,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0x27a0008c0b44361f16c7354a,
                limb1: 0x958cd60ea07f7f4750c6fa8c,
                limb2: 0x1f0ae5039045a445,
                limb3: 0x0
            }
        };

        let c_or_cinv_of_z: u384 = u384 {
            limb0: 0xfe38784bf489362c10345193,
            limb1: 0x6f48744f7abc9f0b86fe0ded,
            limb2: 0x18ac8bf551c6a2e4,
            limb3: 0x0
        };

        let z: u384 = u384 {
            limb0: 0xc2fab18422324672f64e8f4a,
            limb1: 0x7f79ee0e299cb482449213a,
            limb2: 0x2d26e4f51e709e19,
            limb3: 0x0
        };

        let ci: u384 = u384 {
            limb0: 0x8236adf3f7512c56e05724d,
            limb1: 0x43a061c445a16970a11b26b0,
            limb2: 0x763328e62614790,
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
                limb0: 0xea15fbc13b5c2544ea574d9a,
                limb1: 0x57c2dfbd534ad92ae077f69e,
                limb2: 0x1e530f71f339104,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xdbbbe609f5d494807aa86b,
                limb1: 0x761c94268c439f73f712a07f,
                limb2: 0x1487f112ef5261f2,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xc973faeb69491d3af4b4e1e0,
                limb1: 0xfd928a03004147409d7ab196,
                limb2: 0xc44ba1554abff10,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x1d9e7c100aeb9f8cd391cf50,
                limb1: 0xd8d6d63c2f01b64bb54f2a6,
                limb2: 0x114eebf78ecfccf1,
                limb3: 0x0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0xae5728ea3d4afd56eee5e207,
                limb1: 0x5e78bc9307f7003ec6196045,
                limb2: 0x116be6ac777b4a0e,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x8949d9fee3cabe4032d5a44,
                limb1: 0xc77bba91da167fc15bcfe7b9,
                limb2: 0x2a095d2d4f1c99bc,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x2056b62f0feb1a772d601a85,
                limb1: 0x8b7c5838b73f111d0a1b1ed,
                limb2: 0xda7faa1106a5453,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x485f9a228ae1608db9a6188e,
                limb1: 0x5787a64575f01bbe8376a4dd,
                limb2: 0xa352a4d41c76e7b,
                limb3: 0x0
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0xfb665dc4bcf71a4c4277c8c,
            limb1: 0xe93ddd3d418f8a7be3028a,
            limb2: 0x24e7dff3ba4596e0,
            limb3: 0x0
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 0xcf58663b8c023dc85f4765d4,
            limb1: 0x1cda684e04d547834e311ac1,
            limb2: 0x13dae85f338f8db0,
            limb3: 0x0
        };

        let ci_plus_one: u384 = u384 {
            limb0: 0xb88a58bebd06233386880d1d,
            limb1: 0xa7508d842de065fd65b3316c,
            limb2: 0xe86f089dd9c3e50,
            limb3: 0x0
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
            limb0: 0x5fad7a0d4aa83cd65804a881,
            limb1: 0xa31cc5d2cd96a6a19dbdc6ff,
            limb2: 0x2faef9833085ee6d,
            limb3: 0x0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0x8abb572c8aae0c3ad31224e0,
            limb1: 0x83f0ba7756b8002a0f424ffa,
            limb2: 0xe49e4d8d5f52c0,
            limb3: 0x0
        };

        let Q_0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x7ed61f4ee875176629530a13,
                limb1: 0xa31ca36b059ebb2ed1cae193,
                limb2: 0x1080bebedcebef56,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x581332c2233e383454e27ea6,
                limb1: 0x196d362dfec24805feeac13d,
                limb2: 0x23eb5c979d0b6f5e,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xca687a98f48ef9a86aeb5a32,
                limb1: 0x4063d5251152797ec20166e3,
                limb2: 0x6ab0f28920c904e,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xdc7972f0133894b3854ca896,
                limb1: 0x20d5c16e961139cfffbdfd47,
                limb2: 0x237dac67c3ad037,
                limb3: 0x0
            }
        };

        let Q_or_Q_neg_0: G2Point = G2Point {
            x0: u384 {
                limb0: 0xfedcb8f9378b094cb5178761,
                limb1: 0xa9d21bf8b19549902d5c6415,
                limb2: 0xebad6f0f63d307c,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x9bd91220338f4acf66270136,
                limb1: 0x706146ffbecba4c8b2c92c12,
                limb2: 0xa1c0aec5931c9b4,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xf90b9724b883a8ea44e8a604,
                limb1: 0xf94d9109593985b5e5039055,
                limb2: 0x2306984afff99f34,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x37503d7733672754da2e6e6c,
                limb1: 0x5050f32cd4062cce773a13fb,
                limb2: 0x838c293fbcefcd0,
                limb3: 0x0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0xaa19af268fa41d2246ddb0ac,
            limb1: 0x1debf6c503ccb5c6b4195c,
            limb2: 0x2a42248e1551f819,
            limb3: 0x0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0x4ef0ba9b53fd2516d1bfbaba,
            limb1: 0xc833b07eb4d56ffcdf4a518a,
            limb2: 0x14b06cf1f33c4233,
            limb3: 0x0
        };

        let Q_1: G2Point = G2Point {
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

        let Q_or_Q_neg_1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x5121f31f5028361fa94501d7,
                limb1: 0xa74b3d208c3fa29ffa4b0bc6,
                limb2: 0x1265533cfaaf500c,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xb55dc442c884e6660c661a49,
                limb1: 0xe368f7d2d9732b863fb230b2,
                limb2: 0x21100ecdb13bad4e,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x98decbf642734d1c23d83f22,
                limb1: 0x637c3644c9345ce70e5bc44c,
                limb2: 0x11f9df8a6b291a13,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x40e3469f39b66d71951a0518,
                limb1: 0xe9184b9f501049e2f367dbe2,
                limb2: 0x22194f90cefe73ec,
                limb3: 0x0
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 0x72e55360e3aeb12e7d4fbfff,
            limb1: 0x6c749cf41f7550bcb550f221,
            limb2: 0xad9ac705fdd5329,
            limb3: 0x0
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 0x3b239fd80d20f686854df9b6,
            limb1: 0x7a31a27cced4dd7cb4ca0142,
            limb2: 0x1f57848623a35ae,
            limb3: 0x0
        };

        let Q_2: G2Point = G2Point {
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

        let Q_or_Q_neg_2: G2Point = G2Point {
            x0: u384 {
                limb0: 0xf190cb53b489f5c7e22f6e82,
                limb1: 0xc21d3ead3e4c13622826ef27,
                limb2: 0x83e97348f5a5ade,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x94d7f681d5511e14e18d99ce,
                limb1: 0xbeb778d62b021118ae63ad3a,
                limb2: 0x2189772c3f79dd31,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x4ca49e01c6218f7ffcd4fb19,
                limb1: 0xdb0198ffde21c855cc713ba6,
                limb2: 0x2d5e9700cb85eda6,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xb8d1353905628912bdf2b5a1,
                limb1: 0xe7a2d2d0ca3c405075fc1b10,
                limb2: 0xcc9471dd8efb5c9,
                limb3: 0x0
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 0x2af595a3697b85380ff73f25,
            limb1: 0x634da412816a5ea8618a4763,
            limb2: 0x18a0b0cf3665b6a5,
            limb3: 0x0
        };

        let f_i_of_z: u384 = u384 {
            limb0: 0x7e4132ad86b0915a8880f9fd,
            limb1: 0xdb160641207417e71a608f0d,
            limb2: 0x22198aae16018cc6,
            limb3: 0x0
        };

        let f_i_plus_one = E12D {
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

        let c_or_cinv_of_z: u384 = u384 {
            limb0: 0xa6894303e807092d74ca0c56,
            limb1: 0xca19e5a80d5a2ad386d77094,
            limb2: 0xc6fcecdbac114b5,
            limb3: 0x0
        };

        let z: u384 = u384 {
            limb0: 0x7575117c41ca37f5f7de1a61,
            limb1: 0x4ade7b7119b0fb4b0fde8c9,
            limb2: 0x26385af0338589c7,
            limb3: 0x0
        };

        let ci: u384 = u384 {
            limb0: 0x5c41dfb5a94a29d3f73c3dce,
            limb1: 0x44864d26cfd092769c017e5d,
            limb2: 0x2b2b0037024e8609,
            limb3: 0x0
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
            Q_0,
            Q_or_Q_neg_0,
            yInv_1,
            xNegOverY_1,
            Q_1,
            Q_or_Q_neg_1,
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
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 0xef19a8f789ef6b2cab232c99,
                limb1: 0x65e0b83518e19f05da1dde1e,
                limb2: 0x246ebeacb68025a7,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xfca9b867299090d1b6a1f04d,
                limb1: 0x433a606e474aa56e09245006,
                limb2: 0xc3509ba386485bb,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x1ff33230ecd4f44aa3a706df,
                limb1: 0x44087b61d7bc45973731e4b7,
                limb2: 0x3129c03c1ecf580,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x9acec46141c22e8424db7b4d,
                limb1: 0x79b000b7c37d9207872ae5ea,
                limb2: 0x2d38bbd9b4bbf413,
                limb3: 0x0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0xe33e6f0f4d7ccefd971bde40,
                limb1: 0x472c1dea5b581af0f62adb1c,
                limb2: 0x25dbb70bf708b9b8,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x8bab36372b526ccd22a253f8,
                limb1: 0x71122572a7a0d4f9ca16ed23,
                limb2: 0x2bdae404691f3a6a,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xe1481814728cd2fc21239708,
                limb1: 0x4e696719cbd6fc3a988cc092,
                limb2: 0x7af6aaa9d9e6ed6,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xf3e8c6139a4dfb0e10c7e377,
                limb1: 0x65b7ba037d3af0f94003a19c,
                limb2: 0x289aa50ac8513b29,
                limb3: 0x0
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 0x29c199d57029797f7632fb96,
                limb1: 0xa304ecd0095337b8c063d33a,
                limb2: 0x2419a2624e8787e0,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xb6fbf79bdabf2c72b51fbcda,
                limb1: 0x70301a7edd49240074e8f511,
                limb2: 0x2a3229a78f9ae037,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x86604f656cd8912ec3c854b4,
                limb1: 0x28fab238379522fa7ea10069,
                limb2: 0x82df694176c2784,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x514de7c97e05ec003515e636,
                limb1: 0xd5db2ef51e24eadeefa04cd9,
                limb2: 0x14bc93145a143d91,
                limb3: 0x0
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0x7a80b9060ec14fb798ec5ec4,
            limb1: 0x3efe94ff84e03b72bda7d10c,
            limb2: 0x194df1599ee4bd88,
            limb3: 0x0
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 0x42f0b38ab1ebd93c3d20ba33,
            limb1: 0x2d2184e5f4ebf7a2c095e9c7,
            limb2: 0x165355f0b4721188,
            limb3: 0x0
        };

        let ci_plus_one: u384 = u384 {
            limb0: 0x92669393ac96307bd56f9d2,
            limb1: 0x2473129a5090f5b522963a2e,
            limb2: 0x1647163de4242e13,
            limb3: 0x0
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
                limb0: 0xb3670f54dbd61b32865fd3ce,
                limb1: 0x7ae1a24ea792b2b462e1b434,
                limb2: 0x192befd23cc919a9,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x18bcaa21b887d3e9a3171056,
                limb1: 0xace146850eaa73e96bfed001,
                limb2: 0x12f71446d7461872,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x4d26c0c52ba08a2499ccda39,
                limb1: 0x1fda2e5386def5a0474fc1f7,
                limb2: 0x2acd65058ed2b26b,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x8cccf565e5ae7ad82e067,
                limb1: 0x63b5c924fa9196f8015987,
                limb2: 0x15b7253a17d9fa66,
                limb3: 0x0
            }
        };

        let yInv_0: u384 = u384 {
            limb0: 0x7612c7e8924dbea9ab616040,
            limb1: 0x2bd43ea08bbd6b2f42f378f2,
            limb2: 0x1cc84d4cf0022e2e,
            limb3: 0x0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0x1a6ed97f03cd7bab667b94c9,
            limb1: 0x5462a18d1b6d6ce901364fc5,
            limb2: 0xd4b5bc9b98713be,
            limb3: 0x0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x1d7322518b763f634ffe0196,
                limb1: 0x4d1df659c736e1668042e02f,
                limb2: 0x5ebe809e389adef,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xaf1b70131c7bc6c8d62fee8c,
                limb1: 0x2a630fd171cf539d2a1fff41,
                limb2: 0x1dc682842a6c56cb,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x8f8b36e406fa11b492294b0b,
                limb1: 0xf5f5b0d2042e4fec60e63d0e,
                limb2: 0x66dae461f695a01,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xa15d41c9153699654f4f5a26,
                limb1: 0x356ac19061a5c06ec4be5a7f,
                limb2: 0x2e4a637d41a97327,
                limb3: 0x0
            }
        };

        let original_Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x6ceb18652fc339b95e366dc5,
                limb1: 0x2246f10ce65b211a3c9c8d7,
                limb2: 0x1af07a0f96c9b54e,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x9a3bb7bef26bf956f871af48,
                limb1: 0x58c8ba854885bc053bd4258c,
                limb2: 0x1415f7d0835b8afb,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xda595d3ea0fe9e1b79101825,
                limb1: 0x77b1ce21bcccc53ac36a4162,
                limb2: 0x2fa6e1a8e16e3336,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x40d6aebee75cb80cb7c3aa1b,
                limb1: 0xc680b96f45d739225836d762,
                limb2: 0xbefb43729ef5907,
                limb3: 0x0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0xe66bd3a038e4c448e108e5d9,
            limb1: 0xa486998f52d51d8b76579644,
            limb2: 0x17d3fe7805f1fc0a,
            limb3: 0x0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0xc9d33c479f34cc1079699973,
            limb1: 0x494c0911b3f4f5acf106dbce,
            limb2: 0xfd20affacf45d82,
            limb3: 0x0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0xd0fe4a59329ec4ac2ea5cef8,
                limb1: 0xb33425baf3871cf4638016f5,
                limb2: 0x153bbf6e9a04bb70,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x70dc4769e08aec96f4159113,
                limb1: 0x3288a67e030c98e85e2408fa,
                limb2: 0xd0ed3ec912d791d,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xfdf4ff097d87d79311705ee3,
                limb1: 0x1677013ba8e19b8321ab9e3d,
                limb2: 0x21377e1ab8163f1a,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xf0e51f30abfa4f2cb1886048,
                limb1: 0x9d0a4fac67aaa0688dcfb198,
                limb2: 0xd4d9d8e4768a5c9,
                limb3: 0x0
            }
        };

        let R_n_minus_2 = E12D {
            w0: u384 {
                limb0: 0x5d799676d9635ef1426a5dc,
                limb1: 0xb7aa3d917a282c8a8b67e0d3,
                limb2: 0x15ef49c2be633c9d,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0xc5062250e33725eeddf06a9d,
                limb1: 0x72e99ed16b3bc4cdcd4a30f2,
                limb2: 0x20e28c97b4369152,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0x106fa2ec4896c62cb397b350,
                limb1: 0x1608f0df09f49733fb813983,
                limb2: 0x184025fe589c2591,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0x618701e8699a723fa4b2f62c,
                limb1: 0xb2105ccda51e0bdec816c4aa,
                limb2: 0x28fbecf7c2f27fc1,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0x487eb3df3b71e722c579009c,
                limb1: 0x6689ef79f8c3c4617c15b016,
                limb2: 0xacbe48dc57bd9,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0xa29d06e06f5714d7a0be4a1c,
                limb1: 0x7c30634aac606a5d49dd3b0e,
                limb2: 0x198a9d9c276d105c,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0xfdb61e50e4e7f883f9576ac4,
                limb1: 0xf84907a1d5810613c46cecaa,
                limb2: 0x2e319dcf9610c047,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0xa5743bd395f7ad29e9daa8ed,
                limb1: 0x58beb6672b8059d7c5bc8847,
                limb2: 0x1b2a648d0989e9e2,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0x6071911e3b2559fb54d6aa2d,
                limb1: 0x56bf5e579ff9b0f506274afb,
                limb2: 0xbb717f727ef0967,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0x7f42af90e412eb0bd260a30d,
                limb1: 0xc696ebab11b2332ee0934e38,
                limb2: 0xb56c0a6197e85a0,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0x8302ee69a9c1d73f173d2fe,
                limb1: 0xfd577ceaa623c2783a94f14b,
                limb2: 0xa264392dd218eb,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0xfcd2f001852b29b5a779fe32,
                limb1: 0xadd7ae79eb0f6c21e97780d1,
                limb2: 0x2b3616e76ff00a21,
                limb3: 0x0
            }
        };

        let R_n_minus_1 = E12D {
            w0: u384 {
                limb0: 0x4a18bafe2df4a7486e7703ae,
                limb1: 0x4fbf545a70bef8fb659812bf,
                limb2: 0x22015012f53a7cec,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0x7a94f48328ce122009b12bc9,
                limb1: 0xe56b3b1de54e4a172868c76b,
                limb2: 0x2a4d2af41b4addce,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0xd094d2af793dd40f1de16841,
                limb1: 0xbbd4b4ed48674c9bbba6ad3c,
                limb2: 0x1389690acc4589b5,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0xf5270a2115c3e9276181f28,
                limb1: 0xb60b7264a69cfd32c3e6652c,
                limb2: 0x12cc267bd4364172,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0x5e6cc9e41768599decffd101,
                limb1: 0x4f0fa9db4b6a3fea01cf7f93,
                limb2: 0x1336bc0ed91a32,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0xb08da959fee599a0878f6db,
                limb1: 0x980dda10dffd6f1927e4bbe6,
                limb2: 0xad4d748de2d64b9,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0x14cca279a63cca7578405abf,
                limb1: 0x52d143c23a6152695e3f329,
                limb2: 0x2f85a75af290d831,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0xcbabe5d7228c77158f8ac4cd,
                limb1: 0xb580d3a313ab42c41a0408e7,
                limb2: 0x26e1b60310b8c060,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0x1da5a563a939e190c6f1c3ad,
                limb1: 0x19a0f532d2197d9333a70c3d,
                limb2: 0x1f2ec6f3ef381237,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0xd9836a1fbad8ae6a5f5ce777,
                limb1: 0x2147c6f582ee1d866c10f97f,
                limb2: 0x281907f214abd4d2,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0x8fbfe11f54e888981acd529,
                limb1: 0x8d943a55e11a4073bafcd1c4,
                limb2: 0x608597f3f84747c,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0xb2e120898fcb236252fb4fd4,
                limb1: 0x6473b9048beeb82c92659b42,
                limb2: 0x13a13841e8a74310,
                limb3: 0x0
            }
        };

        let c_n_minus_3: u384 = u384 {
            limb0: 0x5d4609baf77740fcc70312b9,
            limb1: 0xf13fc40b489b9a03bc3548c5,
            limb2: 0x2058906f5a57cde5,
            limb3: 0x0
        };

        let w_of_z: u384 = u384 {
            limb0: 0x20aca12055dfed45fa7cb00,
            limb1: 0x41ff6f6324a3b63500513063,
            limb2: 0x2b9d8dd6bd966783,
            limb3: 0x0
        };

        let z: u384 = u384 {
            limb0: 0x7be1251abc1255417d534839,
            limb1: 0x46884eed2034663baaa91ed4,
            limb2: 0x10b01f1ff7402ba2,
            limb3: 0x0
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 0xdf499c15238bc512d13d78bc,
            limb1: 0xeae128042c14c68f0a73a9a9,
            limb2: 0x167ba8c2a812c4d0,
            limb3: 0x0
        };

        let c_frob_2_of_z: u384 = u384 {
            limb0: 0x52d1de24bf3ba58ed02fe513,
            limb1: 0xa1fee9cffc3faf9f333a1d71,
            limb2: 0x201b76311856d169,
            limb3: 0x0
        };

        let c_inv_frob_3_of_z: u384 = u384 {
            limb0: 0x25053d917eb78350cb110ef8,
            limb1: 0x52268c274056125ca1ddc5a3,
            limb2: 0x28a06fb33084486f,
            limb3: 0x0
        };

        let previous_lhs: u384 = u384 {
            limb0: 0xabbf9e6d9e19e1881da11d7a,
            limb1: 0x5a456f863e3292dbb0bd6bdd,
            limb2: 0x198fa61acc9bd78e,
            limb3: 0x0
        };

        let R_n_minus_3_of_z: u384 = u384 {
            limb0: 0xf51994841a67b2f9c4fa5577,
            limb1: 0xedb8a483c65233ab465bb8d7,
            limb2: 0x18d2b56efd72a908,
            limb3: 0x0
        };

        let Q: Array<u384> = array![
            u384 {
                limb0: 0x83087b45b5eea1f8eace752,
                limb1: 0x3b48146954fe81bba3455904,
                limb2: 0x228ec7864e26c6f,
                limb3: 0x0
            },
            u384 {
                limb0: 0x6bcf2a76c1d8f799f76077bb,
                limb1: 0xc7439bed4529f10d897e7d87,
                limb2: 0xa310cbfccbc2cbc,
                limb3: 0x0
            },
            u384 {
                limb0: 0xbf2e1da430e055ceb76dbed,
                limb1: 0x4487989efb20fab5be98e6d2,
                limb2: 0x5178d8bb9019c59,
                limb3: 0x0
            },
            u384 {
                limb0: 0xa607dc9d55bdbbf6fee99b49,
                limb1: 0xc607fad901fe2e706aa066f7,
                limb2: 0x111113dfada6b225,
                limb3: 0x0
            },
            u384 {
                limb0: 0x40de67942de157ccb56ac802,
                limb1: 0xf35fda3eed38505b5e8a511b,
                limb2: 0x2185aea2d296e670,
                limb3: 0x0
            },
            u384 {
                limb0: 0x2bc38de01d0820e0a24921ff,
                limb1: 0xdf240ae53301deb47f571b98,
                limb2: 0x270da7db91219f59,
                limb3: 0x0
            },
            u384 {
                limb0: 0x68736d8a12ee6e4697e27d7a,
                limb1: 0xb19b701bd042c1c8490004e6,
                limb2: 0x2ba78b9adaa21ca,
                limb3: 0x0
            },
            u384 {
                limb0: 0x7b0f90001541c1e420fedb8,
                limb1: 0x289f88b49b566e06cc800b04,
                limb2: 0xb01c78954536cba,
                limb3: 0x0
            },
            u384 {
                limb0: 0xa497af9008153b1ff77b8c86,
                limb1: 0xdb9029bfc0ca12168b088a26,
                limb2: 0xc205393e40f2900,
                limb3: 0x0
            },
            u384 {
                limb0: 0x5d1a74c36b35da2c04465ea7,
                limb1: 0xde9318967ada5a662fa0823a,
                limb2: 0xe98531be6ab5199,
                limb3: 0x0
            },
            u384 {
                limb0: 0xbbda98aaae433b71b8ecfe83,
                limb1: 0xce307195a2fb2221dcb47e14,
                limb2: 0x2fe248eae69773e8,
                limb3: 0x0
            },
            u384 {
                limb0: 0xa1a85267e38b1adcb99456d7,
                limb1: 0x62919a04ebbd383ae6e7ac6e,
                limb2: 0x266466cdc3a24c35,
                limb3: 0x0
            },
            u384 {
                limb0: 0xde5dd6f9aabaa3a803c92eaa,
                limb1: 0x9d592226302d6194ee550e17,
                limb2: 0x1fa320fbbf9582c7,
                limb3: 0x0
            },
            u384 {
                limb0: 0x646e18a9c1f1011b69d36af7,
                limb1: 0xadc11d692762fbac29685a0e,
                limb2: 0x1866cd476dca0f0a,
                limb3: 0x0
            },
            u384 {
                limb0: 0xd3c94fc471da0538ffdb8ef3,
                limb1: 0xb87f0e55bc9b15edf5f2bba7,
                limb2: 0x2fee1337a4978b1d,
                limb3: 0x0
            },
            u384 {
                limb0: 0x102bcf1640b0dc2a36f4fc52,
                limb1: 0x2884eee7eec6c987b378e45d,
                limb2: 0x2462d57fe8968a9f,
                limb3: 0x0
            },
            u384 {
                limb0: 0x2d26904840131e33277b20ad,
                limb1: 0x85883d4441b1118065decf1a,
                limb2: 0x29458345e71f7674,
                limb3: 0x0
            },
            u384 {
                limb0: 0x89d9a4015207cce56bd2729b,
                limb1: 0x7d90d1f86ca1c7a8ba71d935,
                limb2: 0x7ad885e76cf14a2,
                limb3: 0x0
            },
            u384 {
                limb0: 0x50abc4519af1b4564034dca4,
                limb1: 0xb8c0ace840a0864341cb57da,
                limb2: 0x1806ceed48ef09a4,
                limb3: 0x0
            },
            u384 {
                limb0: 0x6c002fe033f78404808b20f6,
                limb1: 0xa7f83cd9bb2332db45b259f2,
                limb2: 0x1a06f9c2c2e4dc34,
                limb3: 0x0
            },
            u384 {
                limb0: 0xb6649e79473b8bf6cc5fbfe7,
                limb1: 0x7814bf40683e8e1cfb99a06,
                limb2: 0x2b703f377e297815,
                limb3: 0x0
            },
            u384 {
                limb0: 0xf2c1c87d63d80690cf4d5d14,
                limb1: 0x8c9ebc8a5984ae6688953e23,
                limb2: 0x2187fda878c49995,
                limb3: 0x0
            },
            u384 {
                limb0: 0xbe7cbe1e8e4e707771e54207,
                limb1: 0xe65ccee3b4159391bba9048a,
                limb2: 0x2500a366799335bc,
                limb3: 0x0
            },
            u384 {
                limb0: 0x964ede98ce6249392f5d5c62,
                limb1: 0x9b6f338a0665be98c138418d,
                limb2: 0xd74b3f25b123a92,
                limb3: 0x0
            },
            u384 {
                limb0: 0x111244066e30d1ba4ed00818,
                limb1: 0x2a51d1ea18eec8cc381dce21,
                limb2: 0x26ce4a17c9cf17ba,
                limb3: 0x0
            },
            u384 {
                limb0: 0xc676a324395ce894fdeb26ef,
                limb1: 0xec2074955c5b6d490b7ffede,
                limb2: 0x10e224e282bca728,
                limb3: 0x0
            },
            u384 {
                limb0: 0x88fcabb3d02a862b64d2a318,
                limb1: 0x985cb514e550dceaa6701b66,
                limb2: 0x13a1432818a03a93,
                limb3: 0x0
            },
            u384 {
                limb0: 0x81001b5e21366a11e4eb24a4,
                limb1: 0x10587f452539021523c0b469,
                limb2: 0x15c1fddbef137c97,
                limb3: 0x0
            },
            u384 {
                limb0: 0x6e800470b5560b631cef544,
                limb1: 0x13f60dff788afa157d58bb02,
                limb2: 0x2181baf192dbfdc9,
                limb3: 0x0
            },
            u384 {
                limb0: 0xa0fdd91b23a838090cf04051,
                limb1: 0x22a855589028ad8677698480,
                limb2: 0x1087d20a902a94ca,
                limb3: 0x0
            },
            u384 {
                limb0: 0x547008340af23ed35ee10379,
                limb1: 0x19c613bae1bd8bab1a6e9ef7,
                limb2: 0x2b5685319fce8337,
                limb3: 0x0
            },
            u384 {
                limb0: 0xa8494a7e4e72d3381c2ca464,
                limb1: 0x9482b15dff09ff3a4eeff333,
                limb2: 0xb8d33135d83c657,
                limb3: 0x0
            },
            u384 {
                limb0: 0xa83ae02701d1f888c5410174,
                limb1: 0x67ab4d37799d0336c1230913,
                limb2: 0x2880eca46793f6a9,
                limb3: 0x0
            },
            u384 {
                limb0: 0x6af26631176151c236c55e3b,
                limb1: 0xf19348ca444dd831dad389fe,
                limb2: 0x1ba4e4ce7c7e8bd2,
                limb3: 0x0
            },
            u384 {
                limb0: 0xe309b6b27e282b78ab5c3122,
                limb1: 0x6de0f539253a974c607402ca,
                limb2: 0xd29f934cf4d9f87,
                limb3: 0x0
            },
            u384 {
                limb0: 0x5264c9a6770922932308b506,
                limb1: 0xccc6315b4a97676d5ce5adf7,
                limb2: 0x1ccab919cf762ef8,
                limb3: 0x0
            },
            u384 {
                limb0: 0x298a7d8a3efc91f057f599d1,
                limb1: 0x20a7446bf9c8d852760eff62,
                limb2: 0x15c03ec6b473e514,
                limb3: 0x0
            },
            u384 {
                limb0: 0x7f49db7a38168876cda5a0a0,
                limb1: 0x896431bf18ce5ecb2783662b,
                limb2: 0x26b0d4b3961516b5,
                limb3: 0x0
            },
            u384 {
                limb0: 0x516bb4edbaaafc6c71daae43,
                limb1: 0xa9333123166533672c97f169,
                limb2: 0xa71778a50ecb7bf,
                limb3: 0x0
            },
            u384 {
                limb0: 0x5b33ffa8ef619b1345b62271,
                limb1: 0xffb9c71bb69d0faea9955b27,
                limb2: 0x73267f31ddbb059,
                limb3: 0x0
            },
            u384 {
                limb0: 0x3070e155006287fadd330a90,
                limb1: 0x4d6bbd5da64b62d5a889ea84,
                limb2: 0xbf07a9fa3b0cc06,
                limb3: 0x0
            },
            u384 {
                limb0: 0x8eca745cd90f6bbc2b7513d8,
                limb1: 0xf565e82a79a975ca28b671b8,
                limb2: 0x51438bb3da104bc,
                limb3: 0x0
            },
            u384 {
                limb0: 0xe5379893860fbe0cb6870e20,
                limb1: 0xb484db42e58000cf427585d8,
                limb2: 0x34360be1b13a405,
                limb3: 0x0
            },
            u384 {
                limb0: 0x16d91fc5be85039460fc74e8,
                limb1: 0x7c11379776bfaa9b641d2571,
                limb2: 0x9031266a9c633e2,
                limb3: 0x0
            },
            u384 {
                limb0: 0xec5c62d24020912b4f6783a,
                limb1: 0x26b4a0a71cf0589debde3e11,
                limb2: 0x7a9c1d5a1d577a4,
                limb3: 0x0
            },
            u384 {
                limb0: 0x9b85f2b467706befd5be1022,
                limb1: 0x48040c13180aa66ae45f2e18,
                limb2: 0x24e8d94d14f3578d,
                limb3: 0x0
            },
            u384 {
                limb0: 0xe6effcd167286f94d370bdf9,
                limb1: 0x73de1a9e87f3aa2b2c0eb235,
                limb2: 0x1113bd24b3e1da11,
                limb3: 0x0
            },
            u384 {
                limb0: 0xa06d8653567494dfc399daf6,
                limb1: 0xcefad840a59464532cb16080,
                limb2: 0x10b279d06757af74,
                limb3: 0x0
            },
            u384 {
                limb0: 0x2d5d2173e53b864be48f5984,
                limb1: 0xd3341b0a296e77d2ea853efa,
                limb2: 0x57ba85db97155a0,
                limb3: 0x0
            },
            u384 {
                limb0: 0x8526a82aa325872d361fbb08,
                limb1: 0xc42d4bd6e6c653b1d113df73,
                limb2: 0x2b3f404c5b8a762f,
                limb3: 0x0
            },
            u384 {
                limb0: 0xde7b2c4274b20954bc5115e7,
                limb1: 0xd5b2fd55a89d831de6ad2510,
                limb2: 0x153fb6a8173e585c,
                limb3: 0x0
            },
            u384 {
                limb0: 0x5961640123d8c4800e67287c,
                limb1: 0x39e6f58f7fdf22292ce42e41,
                limb2: 0xecb47f2eded54e3,
                limb3: 0x0
            },
            u384 {
                limb0: 0xea727bf4202aae6410afa961,
                limb1: 0x6f283a3270a22d8ec3c02b36,
                limb2: 0x1716056c197aef97,
                limb3: 0x0
            },
            u384 {
                limb0: 0x1eff10783985577fc069f48d,
                limb1: 0x330760dc224c85db5286369e,
                limb2: 0x277be37d3ca318ca,
                limb3: 0x0
            },
            u384 {
                limb0: 0x321a11284586ce142e215337,
                limb1: 0xb589931f8c662964801f9c5f,
                limb2: 0x70ca877d54f58b7,
                limb3: 0x0
            },
            u384 {
                limb0: 0x9cd78bd28fbc9bba8748cffa,
                limb1: 0xbcc0cdcf8bebbe5b9013cc05,
                limb2: 0x180ce7baa8b12cca,
                limb3: 0x0
            },
            u384 {
                limb0: 0xbd08b032f9ad520206ab5a91,
                limb1: 0x23ca4739ce5e761b7b59a1c0,
                limb2: 0x56108e9005ba4e1,
                limb3: 0x0
            },
            u384 {
                limb0: 0x4cb4dadd98efec68fdeab3c,
                limb1: 0xc3d7df292368db81da34effa,
                limb2: 0x7003e51df0644a8,
                limb3: 0x0
            },
            u384 {
                limb0: 0xe84b60ec5235fb420e11f795,
                limb1: 0x319c7b43aae0a7644fd43443,
                limb2: 0x40373f6c413b8e8,
                limb3: 0x0
            },
            u384 {
                limb0: 0x620012a7f497b5a65c1ed1f5,
                limb1: 0xf3971943a640ca97fc88e170,
                limb2: 0x27a7913187b8d77e,
                limb3: 0x0
            },
            u384 {
                limb0: 0x5e3fafbffc06d3deadb3a8a7,
                limb1: 0x35b592e56b3190f4e55ef749,
                limb2: 0x2e0fed926463137f,
                limb3: 0x0
            },
            u384 {
                limb0: 0xbca1e7cd98a98ba60a2581e9,
                limb1: 0x1e1dd8c91a7859b39147d0e,
                limb2: 0x1c8a0366e2cd8130,
                limb3: 0x0
            },
            u384 {
                limb0: 0x6a37285102c1f0b0bce77742,
                limb1: 0x337faf64c6839f4a2749913f,
                limb2: 0x250cd2ec103ba901,
                limb3: 0x0
            },
            u384 {
                limb0: 0xee628c9a211acf9ea2d9281b,
                limb1: 0xc9aadaa6e440aa7ce95361bf,
                limb2: 0x30067f7e510020c1,
                limb3: 0x0
            },
            u384 {
                limb0: 0x4b7bd27ae20e222447d35352,
                limb1: 0x73d0c8bfe2fb8f04c6eb245e,
                limb2: 0x21839c06579dc1fb,
                limb3: 0x0
            },
            u384 {
                limb0: 0x5466accc7dbcc5f769d144d1,
                limb1: 0x8431e88c4427635ecf186b91,
                limb2: 0x137aa8a6debec758,
                limb3: 0x0
            },
            u384 {
                limb0: 0xe5173c41fdf156226751d1a4,
                limb1: 0xedbc59fe47c2e637c176eadb,
                limb2: 0xe9d642b25cc9a3,
                limb3: 0x0
            },
            u384 {
                limb0: 0xe8c2215dd739bb9e36cc66a4,
                limb1: 0xc0b2ae8b77887200b6bd58d6,
                limb2: 0x19cd7cd54c7c9c38,
                limb3: 0x0
            },
            u384 {
                limb0: 0xbd60bb3ebd45242f6db6cc9a,
                limb1: 0xedb52ad7db3d977bd3d69412,
                limb2: 0x2bad017cd006434c,
                limb3: 0x0
            },
            u384 {
                limb0: 0xd7488a7680aaf97e454b57c1,
                limb1: 0x96561c9429efcdfc81992dc5,
                limb2: 0xbd656f0dad16c2b,
                limb3: 0x0
            },
            u384 {
                limb0: 0xd7fab5bc1dc11ea22f06771e,
                limb1: 0x8410ebdf0ded0f89f059a06d,
                limb2: 0x2cfe157209c9a8dc,
                limb3: 0x0
            },
            u384 {
                limb0: 0x2328d866975e2ac2f08df7c1,
                limb1: 0x35b996bd901d169d25ab3477,
                limb2: 0x16fb8478a5660feb,
                limb3: 0x0
            },
            u384 {
                limb0: 0x18867eb5199121865dbfc02b,
                limb1: 0x20283b567d00aff3606d396e,
                limb2: 0x24b3947f55ed6029,
                limb3: 0x0
            },
            u384 {
                limb0: 0x3402a47a85b3a01ee4146592,
                limb1: 0xc37418f2394993699b73b023,
                limb2: 0x247c655798e19c4a,
                limb3: 0x0
            },
            u384 {
                limb0: 0xe76a469ebfc27f001875dc2a,
                limb1: 0xb79f3b37f0c0dc323040c2cb,
                limb2: 0xb633df821583621,
                limb3: 0x0
            },
            u384 {
                limb0: 0x4405962bb016dddaecb501ee,
                limb1: 0xad26ebe4cadf4be2468f6365,
                limb2: 0xad342a4531d07a1,
                limb3: 0x0
            },
            u384 {
                limb0: 0xb5e2d9fffcb0f07f72127835,
                limb1: 0x199c47458bd657c45606356d,
                limb2: 0x5c82e2dc12c9c8d,
                limb3: 0x0
            },
            u384 {
                limb0: 0xff34b4c02f2da9e657475fd,
                limb1: 0x6f6972a557ed0cd13048d3c9,
                limb2: 0xfe2fb33e27770d5,
                limb3: 0x0
            },
            u384 {
                limb0: 0xed1a474854b58fb5cd656a21,
                limb1: 0x1fb861a396d53ecf6d6fee53,
                limb2: 0x431597554059bed,
                limb3: 0x0
            },
            u384 {
                limb0: 0x7e41b9af9ba788497b51a1fa,
                limb1: 0x6234a39f3eb913924c041d5a,
                limb2: 0x2dbb24eddf0b60b9,
                limb3: 0x0
            },
            u384 {
                limb0: 0x54e1b6c1584957f20f1f41f3,
                limb1: 0x16fca750fa679a042b44d7a2,
                limb2: 0x11ab585c8f72b28c,
                limb3: 0x0
            },
            u384 {
                limb0: 0x1975d43754c97c0f19e9ea9,
                limb1: 0x9ed03a7ecfc80b4ecab68ee4,
                limb2: 0xa386a2ba0225512,
                limb3: 0x0
            },
            u384 {
                limb0: 0xbc0f91ee242834fddb3d6636,
                limb1: 0x913e7095fff706948ecc8c9d,
                limb2: 0x2b870e1156768476,
                limb3: 0x0
            },
            u384 {
                limb0: 0xd838f3ce74448cb3be767191,
                limb1: 0x114eb0dab17b08aedeb5b9e5,
                limb2: 0x18ee9370ca907b30,
                limb3: 0x0
            },
            u384 {
                limb0: 0x6bd2623a140895d0281bb255,
                limb1: 0x830d98eec1c30b57dd56dae3,
                limb2: 0x1cfb079edd159d1d,
                limb3: 0x0
            },
            u384 {
                limb0: 0xf5a182c5d246fd226b8f76fa,
                limb1: 0xb11edb4321d98c6456eebfe7,
                limb2: 0x23f15fdeeed5c0da,
                limb3: 0x0
            },
            u384 {
                limb0: 0x9743dbc8fba435db5c0d4feb,
                limb1: 0x151a3787d03e6d922b243c58,
                limb2: 0xf81e3e917c98c2e,
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
            limb0: 0xbd91bbc74b31c504edb73ce2,
            limb1: 0x35d489576f08c5a5d1e08ab2,
            limb2: 0x2fecc8fc8c594153,
            limb3: 0x0
        };
        assert_eq!(final_check_result, final_check);
    }


    #[test]
    fn test_run_BN254_MP_CHECK_FINALIZE_BN_3_circuit_BN254() {
        let original_Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x3104f7c5f1525077a7806577,
                limb1: 0xdb690711cb1dad0d0717eb47,
                limb2: 0x151ba089604ff4fe,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x97046d7c5ae4425743a9da5b,
                limb1: 0xe89a006d71638db040af9066,
                limb2: 0x2ff8679684e9b5ff,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xe0467889390b72fad8821713,
                limb1: 0xbeb6533abca281f1c1c7f10b,
                limb2: 0xf34c8c794824ae,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x564220e6cfc2df16dad107d7,
                limb1: 0xf888932ef45a6a8736e11fc9,
                limb2: 0x165434af900e7701,
                limb3: 0x0
            }
        };

        let yInv_0: u384 = u384 {
            limb0: 0x29a9464bcd024ec04b2bac3c,
            limb1: 0xb76db463b9f15b792d53f13c,
            limb2: 0xcc7f35c47f559ef,
            limb3: 0x0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0xf26b659bf85cfc9ecf130e07,
            limb1: 0xbc6bf04b5a3d4eac1e682c1f,
            limb2: 0x9e0d90c60c3746c,
            limb3: 0x0
        };

        let Q0: G2Point = G2Point {
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

        let original_Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0xb75d980a8ed20f4cfc34ed28,
                limb1: 0x191f3240cb4ced8b9b97e907,
                limb2: 0xad9d6b8c5d21579,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x28db5021e56a3078cf7d511b,
                limb1: 0x969d78309b08492ec413e9ba,
                limb2: 0x3182a629bbab50a,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x701a484ef57b6006dfc0993b,
                limb1: 0x36bbde06429a8f86c6b23bac,
                limb2: 0x3e56e2289600a04,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x44ec9a812c19b827e5c99ac,
                limb1: 0x981f25ed0c7c9761a617fe49,
                limb2: 0xaf732b43027bdbd,
                limb3: 0x0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0xa8964ce0c132222a7e192ce3,
            limb1: 0x4a789a0e855f27d43303cc12,
            limb2: 0x2f668c93932b99a5,
            limb3: 0x0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0xe23b0e070035d58bca6838d1,
            limb1: 0x559ba0b79ec80afbfcb9d139,
            limb2: 0x13d3cbdda7d364c3,
            limb3: 0x0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0xcabfcd948beace4de4f44028,
                limb1: 0x4dc557e294ad651639e72e2a,
                limb2: 0x24bb3547031e3c42,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x19b6edfad219c7785891a706,
                limb1: 0x262acd409067f7264ce68c93,
                limb2: 0x274621f5a23c2f2,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xd659182603b62dc0b927ee07,
                limb1: 0xe8bb1f2998d38b06a4545742,
                limb2: 0x19a16d53d17d4cc0,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x3bc3f21f6e95a644022b6290,
                limb1: 0x91fd78156e3f32e8d22428c0,
                limb2: 0x12cf46ca770bd8a7,
                limb3: 0x0
            }
        };

        let original_Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 0x2cede02f0114a577d00fb068,
                limb1: 0x744d732592a90fd2b0a35f75,
                limb2: 0x452b3e389b58d29,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x3814d2bc6c6c6dea5dc21c9,
                limb1: 0xcc2fce640b31ec7eab39109c,
                limb2: 0x826ba741744bed8,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x99063e5b6237e31e64b57def,
                limb1: 0x384a28d2bbe7dec42cdd9303,
                limb2: 0x2312633aa6a1e781,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xdda6d27207a1cfb21b85e81d,
                limb1: 0x67c6e2b264fe79c20a77e6a1,
                limb2: 0x121c660cd0fce12b,
                limb3: 0x0
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 0x615acc4ad79d92bc2bd11b15,
            limb1: 0x519ff558aba1a4b506bba00e,
            limb2: 0x1ae0b9e0a14d7071,
            limb3: 0x0
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 0xec52cef13374263e84cf7446,
            limb1: 0x5b34a62acfc250da838e0b04,
            limb2: 0xfbf78509889cbe1,
            limb3: 0x0
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 0x6a4a7f7008415966ad7b787f,
                limb1: 0xf96544a7834d88db7e10fabc,
                limb2: 0x30d6909a158972b,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x3331c18cd4055fa2d660600a,
                limb1: 0xba5a29ff752d67f6569a6d1f,
                limb2: 0x245898ed2f1d4b70,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x9224fa0365d3eed327bb556,
                limb1: 0x4b2d72131e82b4bb3335219c,
                limb2: 0x14b4ee45c1e1b6e1,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x4e0422b4bb9f636e5477afc1,
                limb1: 0x2e35240924d592f6cb574070,
                limb2: 0x2e1dcb4a938dc1b9,
                limb3: 0x0
            }
        };

        let R_n_minus_2 = E12D {
            w0: u384 {
                limb0: 0xe25d61b4694e1286a430fc7,
                limb1: 0xcc35eb9161f1325bf1fb9fe5,
                limb2: 0x7129e45cebf722d,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0xf988818c91a029ccc1bbdab8,
                limb1: 0xeaf9de49db8386fbcaebe9de,
                limb2: 0xa633d4f7f68a5b3,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0xc90f3f1a61473a02cad928d4,
                limb1: 0xc3007cb168f76fd638d34dd6,
                limb2: 0x83d3aab631c3308,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0x714bb95ea1bfefca8f6262db,
                limb1: 0xb051460d9f78e41ee237056f,
                limb2: 0x17359511d05366cc,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0xa4b10a7d0bc711a9eb4194a0,
                limb1: 0x3a4bcaab8659cf439de8ddf4,
                limb2: 0x20d53813374049d3,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0x396836c77c79ed7c664aaa39,
                limb1: 0x14079f9eba95b4f6925f47cb,
                limb2: 0x71b438d8a5082e2,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0x2a4be525e134e7a5273dad16,
                limb1: 0x51b316f6073665614da72eb9,
                limb2: 0x865a2d81d2152f4,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0xa33c8dc3f69cd7e29e81d102,
                limb1: 0x9e7b6789873c6d8bfeeb9881,
                limb2: 0xb803b2fca1871c6,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0x41a449086a8640178be6aeb4,
                limb1: 0xc9e1893ec3fb37430361194e,
                limb2: 0x8d04c785dce8477,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0x3756af5183dc01010b63983c,
                limb1: 0xaac487b171db0784b71df25e,
                limb2: 0x1148931e9cf52508,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0xdc8848ba6ab09995c78e0f48,
                limb1: 0xf5a3f57c637c71aef9862da,
                limb2: 0xff27c52c05f9874,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0x5f0099167df8b7f044a1d4d0,
                limb1: 0xee1ce2b4b385492d4c6700b,
                limb2: 0x10f382e0fee2f56b,
                limb3: 0x0
            }
        };

        let R_n_minus_1 = E12D {
            w0: u384 {
                limb0: 0x5bf2b6a11b95cd28b2764173,
                limb1: 0xeaaa5a3e31dbd1d548e003be,
                limb2: 0xee2ee03572de2ff,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0xd4ae04b3fab2a7803dbe0be0,
                limb1: 0xaf5f7bd63021c8ad3302a5ca,
                limb2: 0x7c9974060e248c1,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0x405e342dfbe30bf988f1559e,
                limb1: 0xf86040142b3c1658aa3042f9,
                limb2: 0x162a6df5f61d103d,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0x6e090ea64032ee1e75711fc,
                limb1: 0xab46afee8898a682e0968f21,
                limb2: 0x2237c0c10b320459,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0x1c0989b1af56d7ba6f086f65,
                limb1: 0xb58e2a1ccdf53f9b4102364b,
                limb2: 0x20b73dcd33744da6,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0x8d87b7e8ac91b72f6c14b828,
                limb1: 0x25bc36a32df19dfb5a5915c2,
                limb2: 0x7cd5d03cc2946f5,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0xd8d02c0dbb4e01c54980588c,
                limb1: 0xc2411753bd3a98bdcc583f50,
                limb2: 0xb22506f4b7118ac,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0xb092a5ff948c2d4389fb4504,
                limb1: 0x7a440b3413e34b3d3d946990,
                limb2: 0xc55d173ccfcd746,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0xfc8ba273caa7b1c81a71a203,
                limb1: 0xd12ea61b76ad2cfc23f4fe14,
                limb2: 0x167ab9a6a09c93de,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0xd24f8f4351a2fa157b6c0adb,
                limb1: 0x7bef34f04fc3489b9c14c815,
                limb2: 0x12235a882415f2a3,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0xb0a1baa56921c1c00bae07a2,
                limb1: 0x76ad98ba10fb5581cccb4dfb,
                limb2: 0xb5c580897ec1a40,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0x1ce76bc0c34c3f471171c294,
                limb1: 0x3b34252964d63e97de6ff3f1,
                limb2: 0x280ca50f4ab878c7,
                limb3: 0x0
            }
        };

        let c_n_minus_3: u384 = u384 {
            limb0: 0xf11e71ae6ce2a4651b742111,
            limb1: 0x955e988df24bfd76a07f949e,
            limb2: 0x12e643b9f6714d76,
            limb3: 0x0
        };

        let w_of_z: u384 = u384 {
            limb0: 0x8615ad73699303f1bde82282,
            limb1: 0xe31b328e3a3262055e26b29d,
            limb2: 0xfb49e12c6950d85,
            limb3: 0x0
        };

        let z: u384 = u384 {
            limb0: 0xa6db74d1a748687529bdf604,
            limb1: 0x1ddde15af323e4341bbf9922,
            limb2: 0x26bc799b890974e4,
            limb3: 0x0
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 0x99225957ee705259262ae4c4,
            limb1: 0x2fd8e8ebe14880c0994d799a,
            limb2: 0x15ddb694f8c03d19,
            limb3: 0x0
        };

        let c_frob_2_of_z: u384 = u384 {
            limb0: 0xa886e763c2c49a972e6f1665,
            limb1: 0x55b1f1c6059251e1de0a09a6,
            limb2: 0x6952b2c265a9190,
            limb3: 0x0
        };

        let c_inv_frob_3_of_z: u384 = u384 {
            limb0: 0x9b3e660550835669836cd602,
            limb1: 0x1a29313d3f74df9ae43bd530,
            limb2: 0x2fae5a58bc16ca04,
            limb3: 0x0
        };

        let previous_lhs: u384 = u384 {
            limb0: 0xf856a0c38fda05f0e45d7a7c,
            limb1: 0xbc7838b31a9af2a3ec6b2ea2,
            limb2: 0x1e8fa641aeef4b09,
            limb3: 0x0
        };

        let R_n_minus_3_of_z: u384 = u384 {
            limb0: 0xb2b5591a9d7f542b85e2b078,
            limb1: 0x7e54ed03eef42592ec1c6fe4,
            limb2: 0x157302c349556582,
            limb3: 0x0
        };

        let Q: Array<u384> = array![
            u384 {
                limb0: 0x173235659dc257bde19dad46,
                limb1: 0xa246b8560a94891e357245f9,
                limb2: 0x19dae528ecd2742d,
                limb3: 0x0
            },
            u384 {
                limb0: 0xb916751942a699a5571cf04d,
                limb1: 0xb36cddb8beabdee5c8614c36,
                limb2: 0x43fd37ae6ff73b5,
                limb3: 0x0
            },
            u384 {
                limb0: 0x733db528d4323934cda9cfae,
                limb1: 0x9ca574d20979829cc898b6a,
                limb2: 0x632d384abe04a61,
                limb3: 0x0
            },
            u384 {
                limb0: 0xb5743132ef3822707072aa51,
                limb1: 0xc34920a7fcfa3a3b47f050aa,
                limb2: 0x10453e8455b3b1ac,
                limb3: 0x0
            },
            u384 {
                limb0: 0x5cae1234bb10d4065a55805d,
                limb1: 0xe8ebbae25bc1c77afa29fad9,
                limb2: 0x2df54b73f2aaaaf0,
                limb3: 0x0
            },
            u384 {
                limb0: 0x47595fb338b4372600cea03,
                limb1: 0xa0e38dd6f700358564d06b24,
                limb2: 0x2275e2ac94be4e35,
                limb3: 0x0
            },
            u384 {
                limb0: 0x631d91b5073039f1e6ad906,
                limb1: 0x17bcd32324b441266f1f7a15,
                limb2: 0x80097e0d5d0a12d,
                limb3: 0x0
            },
            u384 {
                limb0: 0xe9edc59ca80ab2000cfcbe46,
                limb1: 0xf6bd16ac4ab507018e6b81a3,
                limb2: 0x303e940c326e1983,
                limb3: 0x0
            },
            u384 {
                limb0: 0x3e0f74885c88c320a7b0a957,
                limb1: 0x15362c1f90b359d9ff0a837a,
                limb2: 0xe45d6bac38efb8c,
                limb3: 0x0
            },
            u384 {
                limb0: 0x5140094b6ed4e645aaed8b53,
                limb1: 0xb2363b7ea221c908a4edeefd,
                limb2: 0x125881cea0f9986a,
                limb3: 0x0
            },
            u384 {
                limb0: 0x75f98f4110a15299054efa50,
                limb1: 0xf106892ba1fa46f346685cdd,
                limb2: 0xdaf189a61af473d,
                limb3: 0x0
            },
            u384 {
                limb0: 0xe9a28f3cb9abe19f2911cf30,
                limb1: 0x28685bdd02c81d1173f19747,
                limb2: 0x2b0c5edd82ab3e,
                limb3: 0x0
            },
            u384 {
                limb0: 0xfdcb8a6e9265da012aad0659,
                limb1: 0xcb771b1e922ba0aae055b94,
                limb2: 0x17aaf63d178234e8,
                limb3: 0x0
            },
            u384 {
                limb0: 0xaaf5cc090de68b59c4841813,
                limb1: 0x39e65a53dd59195f39745c90,
                limb2: 0x1057f53c7f137c0d,
                limb3: 0x0
            },
            u384 {
                limb0: 0xca70c69290d8416a4fe569dd,
                limb1: 0xa797765abc854e3f5fe1ea9c,
                limb2: 0x14106cf489506262,
                limb3: 0x0
            },
            u384 {
                limb0: 0xc4fc4cd0a78d1e08fc4358e5,
                limb1: 0xfcc597637f449eceb2db458c,
                limb2: 0x2778684eed01d648,
                limb3: 0x0
            },
            u384 {
                limb0: 0xd7d5f9bdd3e47e37817d6729,
                limb1: 0x3e6836da0cc9b533c68ddf7d,
                limb2: 0x2f6d7fc72141b402,
                limb3: 0x0
            },
            u384 {
                limb0: 0x3b6b8130f6874f7a36834a01,
                limb1: 0x1b04eaa423f33d5519248947,
                limb2: 0x266e1fd70aa1ee6f,
                limb3: 0x0
            },
            u384 {
                limb0: 0x9708539e176f1bd98f43392b,
                limb1: 0xcdbdc97fb9fddad9d6659f3a,
                limb2: 0x1bc199d99d672b49,
                limb3: 0x0
            },
            u384 {
                limb0: 0xa0302c1d86294f4da2cb0fef,
                limb1: 0x519b756bf631dae1e1cb6691,
                limb2: 0x216a855eb409e558,
                limb3: 0x0
            },
            u384 {
                limb0: 0x9c514c712071986835f295fa,
                limb1: 0x4b3d15c68dcdfa954cab56c3,
                limb2: 0x19b8282aac3d0478,
                limb3: 0x0
            },
            u384 {
                limb0: 0xc1e75ade858e8dfb98468947,
                limb1: 0x92162634754151b00cdff20e,
                limb2: 0xfd513e0911dc9fc,
                limb3: 0x0
            },
            u384 {
                limb0: 0x438fa43064851962ecf75dbc,
                limb1: 0x4ebb7bc5a9988bcc8e83e494,
                limb2: 0x7be0087bce9ff07,
                limb3: 0x0
            },
            u384 {
                limb0: 0x92c47c9950625b3bd2385cf5,
                limb1: 0x4174dc65f9646b27b4652600,
                limb2: 0x2c8d61cbf68273bd,
                limb3: 0x0
            },
            u384 {
                limb0: 0xb020b8d4529beb354fa09d36,
                limb1: 0x6f8b6cbeb759f3ec13843901,
                limb2: 0x15d11acbddb3d8ee,
                limb3: 0x0
            },
            u384 {
                limb0: 0xcf34bb3d01bf23f5be3bcc64,
                limb1: 0xf7198e17d7523baf1bc238a3,
                limb2: 0x2dc1a2c9fef16ca9,
                limb3: 0x0
            },
            u384 {
                limb0: 0x96bead62d52da285543e882c,
                limb1: 0x32476a228ea70cf11aff2f25,
                limb2: 0x2b149c599224e274,
                limb3: 0x0
            },
            u384 {
                limb0: 0xefda59820148a3cfaaf35967,
                limb1: 0x4a0e78404aec0bdee2f75b1,
                limb2: 0x2feb4bc54f646b90,
                limb3: 0x0
            },
            u384 {
                limb0: 0x844ea6df1c34198a766c7fca,
                limb1: 0x51cd1e8e8294364aa7b6d64,
                limb2: 0x2f68b4877fe88e46,
                limb3: 0x0
            },
            u384 {
                limb0: 0x99d80fa6f0f4c87c9a7e5755,
                limb1: 0x1b52cc064b5e5471c6400708,
                limb2: 0x2c61d653577b1f95,
                limb3: 0x0
            },
            u384 {
                limb0: 0x628f2a7a27503d1e1756e0d4,
                limb1: 0xd0576ddf43237e0874d43d6d,
                limb2: 0x11d07ec55942adba,
                limb3: 0x0
            },
            u384 {
                limb0: 0xaf5c0b9ceaaf74b39fee75fe,
                limb1: 0xc4275f0abf9d32abf28cd582,
                limb2: 0x2d6a641d38b48c97,
                limb3: 0x0
            },
            u384 {
                limb0: 0xf7d9dde98d19ce5e2edd4d37,
                limb1: 0x4251bdb2776adad8744f957f,
                limb2: 0x603dc8c79cb26d2,
                limb3: 0x0
            },
            u384 {
                limb0: 0xf755b4635c340e9440400fe8,
                limb1: 0x5c273f31551a9eb6dcade3bf,
                limb2: 0x1891b3820e9920ec,
                limb3: 0x0
            },
            u384 {
                limb0: 0x2c8cb3fc5759b929ab9873c4,
                limb1: 0xe2238f5548e422fdf89ed0ff,
                limb2: 0x2d611b279e32aa0,
                limb3: 0x0
            },
            u384 {
                limb0: 0x4d86eddb811908408a6464fd,
                limb1: 0x45276f0fecbdaec951b8c4b5,
                limb2: 0x27b2f3e5c201af5a,
                limb3: 0x0
            },
            u384 {
                limb0: 0x133a2a8251e1cdaaa0766bc3,
                limb1: 0x595af0cfd16a2182fc408b2b,
                limb2: 0x14499b0d4443d7f,
                limb3: 0x0
            },
            u384 {
                limb0: 0xd4c02dad72e74f09cef22861,
                limb1: 0x5be01ab72c7db93f9f51a24a,
                limb2: 0x2764c115e6219ba4,
                limb3: 0x0
            },
            u384 {
                limb0: 0x43b1aaafb1d1958c4b69ba53,
                limb1: 0x720c0d000077c6f07dba43cf,
                limb2: 0xf9d2629286334df,
                limb3: 0x0
            },
            u384 {
                limb0: 0x3bbaa05bf77bf1ce58fb4205,
                limb1: 0xa40c0ab3dfc753aa1d0f64d2,
                limb2: 0x18527bc90c33ceda,
                limb3: 0x0
            },
            u384 {
                limb0: 0x60fcf5dacac385bb71f7088d,
                limb1: 0x994269b4dd60375aa585cd11,
                limb2: 0x25943f8d5df6c49,
                limb3: 0x0
            },
            u384 {
                limb0: 0xad9d81e70685e760530d9dac,
                limb1: 0xf7a2b187758eff25033f692f,
                limb2: 0xd94b8014002f669,
                limb3: 0x0
            },
            u384 {
                limb0: 0x77183b112d130744b253a635,
                limb1: 0xc497449db20fe04d1a4a17e1,
                limb2: 0x199d9933bcea20e0,
                limb3: 0x0
            },
            u384 {
                limb0: 0x43ab4db80e45aea58fdd2315,
                limb1: 0xef2de43231e58b01acd3824,
                limb2: 0x107cf28702af87f5,
                limb3: 0x0
            },
            u384 {
                limb0: 0x7b4b57fe556133371177fc2c,
                limb1: 0x43f75e7356a62bec95999d25,
                limb2: 0xecfb19e559a5f6d,
                limb3: 0x0
            },
            u384 {
                limb0: 0x851a3e66bd6236050c1aa8dd,
                limb1: 0x85f87f5c71347c313cf2d95c,
                limb2: 0x12459f2b5192f8e,
                limb3: 0x0
            },
            u384 {
                limb0: 0xf8f2412389f007fabbb1b775,
                limb1: 0xcc5d5cd8265244e8501de827,
                limb2: 0xf6c4758b720faba,
                limb3: 0x0
            },
            u384 {
                limb0: 0x8a6993de7e10b8849271c546,
                limb1: 0x2e001a756efa9a187e6f8581,
                limb2: 0x10cc16a8725b40ca,
                limb3: 0x0
            },
            u384 {
                limb0: 0xa05206d25774a8f0bc7300c9,
                limb1: 0x641cd0b73aa086f4462e8578,
                limb2: 0x3cbdae90166a72f,
                limb3: 0x0
            },
            u384 {
                limb0: 0x5481b307993c47c3f953249a,
                limb1: 0x2a3ee0dd9054a516e5007181,
                limb2: 0x2a939c904f56749,
                limb3: 0x0
            },
            u384 {
                limb0: 0xef59b50288a6966ccb6053bd,
                limb1: 0x9450826ff23d934c29a20bc4,
                limb2: 0x506e9ec27a91779,
                limb3: 0x0
            },
            u384 {
                limb0: 0x8c39ceab26adef3c23b982e5,
                limb1: 0x6391a567684e8ede2fca7a04,
                limb2: 0x17a1bdaa04cb5e62,
                limb3: 0x0
            },
            u384 {
                limb0: 0xc758ebde5822d64549c85564,
                limb1: 0x41760c1c3a577a29041f147,
                limb2: 0x25a4e6003cbc3241,
                limb3: 0x0
            },
            u384 {
                limb0: 0x5e19d2bd028f1175eb59d49f,
                limb1: 0x5e0a3abdc50613abc67518c9,
                limb2: 0x5859e8b57a47b99,
                limb3: 0x0
            },
            u384 {
                limb0: 0xad1c4859931e0d80fc7eaebb,
                limb1: 0x5d81778a5ef70581af71f4ae,
                limb2: 0x1a342def10912208,
                limb3: 0x0
            },
            u384 {
                limb0: 0xf277b8b75c63aa0f300ea022,
                limb1: 0x4097c094933d7d62f4b119a0,
                limb2: 0x99ebab8ccc0ae2d,
                limb3: 0x0
            },
            u384 {
                limb0: 0xec85a655c8a8135a816db439,
                limb1: 0x94f6ca78519662cc1c8e8f7f,
                limb2: 0x23d03e48952dea73,
                limb3: 0x0
            },
            u384 {
                limb0: 0x189798129ee3efdba012368c,
                limb1: 0x5b90c27f2a5debfa9dd0630e,
                limb2: 0x1df31e9e4162ca27,
                limb3: 0x0
            },
            u384 {
                limb0: 0x2f571c547257d90043240b2d,
                limb1: 0x5c4250886b28d7d6651bf718,
                limb2: 0x144d49e818ef618f,
                limb3: 0x0
            },
            u384 {
                limb0: 0xcbee3f1d5fc9707214b64d4f,
                limb1: 0xde8d4a6944a07ecb5fb2e686,
                limb2: 0x16844247a997c463,
                limb3: 0x0
            },
            u384 {
                limb0: 0x69fd6b99260098e5d1bfe226,
                limb1: 0x33213ea434f956f1f780e7d0,
                limb2: 0x25426734285f9f8a,
                limb3: 0x0
            },
            u384 {
                limb0: 0x9837e3c9fe1c054a75b10f2f,
                limb1: 0xcbbce468a8acc1eb6d49fc3c,
                limb2: 0x2d0256a6962cd344,
                limb3: 0x0
            },
            u384 {
                limb0: 0x6720b2c3ee79d13e85bc2a,
                limb1: 0x7e53dfc22f062975d96425e,
                limb2: 0x1a2fc36870eb1aee,
                limb3: 0x0
            },
            u384 {
                limb0: 0x914ef592eb0e9678f80a887d,
                limb1: 0x183fc86afad2873acf05359c,
                limb2: 0x3578225d7511fe6,
                limb3: 0x0
            },
            u384 {
                limb0: 0x4a15d9416369bae7fef89ac9,
                limb1: 0x3306f416b09b81639ff67b31,
                limb2: 0x3267c96e4dd42f,
                limb3: 0x0
            },
            u384 {
                limb0: 0x9d02e44cb5e5f25ddefa3514,
                limb1: 0x9d4fbe486769d8773ab2107c,
                limb2: 0x1f0a546df1772181,
                limb3: 0x0
            },
            u384 {
                limb0: 0x4f5a41c70fa0ab3567b113de,
                limb1: 0xdcd3c1302ad735da2d11b499,
                limb2: 0x1481a3e6d493227e,
                limb3: 0x0
            },
            u384 {
                limb0: 0x9f7642908104908f1f32140f,
                limb1: 0x9342365328beae8e7303ca03,
                limb2: 0x18f516a8de2b5082,
                limb3: 0x0
            },
            u384 {
                limb0: 0x20309b59b7d3589c3a51b13b,
                limb1: 0xf42fc92c048d1c2b4167fa2f,
                limb2: 0x1d49cfbde79c72f8,
                limb3: 0x0
            },
            u384 {
                limb0: 0x5048b85ac544b042c9e63583,
                limb1: 0x591eb142dd4f1ac37ad8ae0b,
                limb2: 0x305ff889820df53f,
                limb3: 0x0
            },
            u384 {
                limb0: 0x914d277e4ff0f84c38137f83,
                limb1: 0x7dbdd047075029fbd561d047,
                limb2: 0x8cb5fb6b2192894,
                limb3: 0x0
            },
            u384 {
                limb0: 0x5fb1a0dd34fef75045709961,
                limb1: 0x4972e2d0dcdef04303f9c3a3,
                limb2: 0x1b9fc9d89f95ecca,
                limb3: 0x0
            },
            u384 {
                limb0: 0x2210f28b630f00b19bef38fa,
                limb1: 0xb8f690fa40e54cdbdc371dfb,
                limb2: 0x28ac93f6f275212c,
                limb3: 0x0
            },
            u384 {
                limb0: 0xd312585790894dfc63e39d59,
                limb1: 0xf3e03ccade7c2fb0a96e0d2f,
                limb2: 0x2f454e9ff47f8512,
                limb3: 0x0
            },
            u384 {
                limb0: 0xe483d3945c7643497afbb7c0,
                limb1: 0xac709e3dd2c49b21dfc8ed58,
                limb2: 0x27374faa7838fd16,
                limb3: 0x0
            },
            u384 {
                limb0: 0x229204c0ccbcb225b7c8dc61,
                limb1: 0x99691df6be96183407e124e3,
                limb2: 0x2a133652656f075e,
                limb3: 0x0
            },
            u384 {
                limb0: 0xced15cd37641cd98d78f94a7,
                limb1: 0x33b9426df25dcd20ee526cf5,
                limb2: 0xbb32e63b157fce1,
                limb3: 0x0
            },
            u384 {
                limb0: 0x33d69c6168f8a67abdf76a13,
                limb1: 0xb0b033504adf1f8686d26605,
                limb2: 0x1b38bb3edd295d4d,
                limb3: 0x0
            },
            u384 {
                limb0: 0x4531ff004f219ce31a8f1af0,
                limb1: 0xc10b89c02692a85929bfce74,
                limb2: 0x13ab450a35959257,
                limb3: 0x0
            },
            u384 {
                limb0: 0x1ad0cfee0f5b7dd928c04ddb,
                limb1: 0xef427576ff7be2552061f228,
                limb2: 0x24c91eb3409c3af1,
                limb3: 0x0
            },
            u384 {
                limb0: 0x69e5ab7b1b9c26485f000fa2,
                limb1: 0xb6a49911559708f542b42bf8,
                limb2: 0x23e8dc3698849640,
                limb3: 0x0
            },
            u384 {
                limb0: 0xe7bdcaccf1d04cc8eb0f052,
                limb1: 0xba85eeec576b323007991818,
                limb2: 0x26dfcf866c953ddd,
                limb3: 0x0
            },
            u384 {
                limb0: 0x514f652fcb719e2f7be14cbd,
                limb1: 0x965d6317ab5e68c2e3d86d14,
                limb2: 0xea63ac5cd1fe22d,
                limb3: 0x0
            },
            u384 {
                limb0: 0xded78da440065fd2df56a02c,
                limb1: 0x5805ab338ba5971dc4b02563,
                limb2: 0x2e5cf5e5e34d17ba,
                limb3: 0x0
            },
            u384 {
                limb0: 0x7370a76cf8af92d5d73b293,
                limb1: 0x55bb62a1cf77fa975f612d94,
                limb2: 0x25eb1d8b842f9dad,
                limb3: 0x0
            },
            u384 {
                limb0: 0xd55fc34ceb5ea9c3f9d9c6eb,
                limb1: 0x97a6f416cecdd0cfd7fa528c,
                limb2: 0x228029a4662606ae,
                limb3: 0x0
            },
            u384 {
                limb0: 0xb6997df2e9b4cbf6f1843d7e,
                limb1: 0x9e293bd91ae3b6381c723c20,
                limb2: 0xc5afbc08dc73e48,
                limb3: 0x0
            },
            u384 {
                limb0: 0xb1d48b0391f2ad426965ff94,
                limb1: 0x695d5d5a1da8f429a54b260f,
                limb2: 0x15a836a7350a2abc,
                limb3: 0x0
            },
            u384 {
                limb0: 0xef1b1beb1a63ed52172c8302,
                limb1: 0xc892030ec1425631b9c115c3,
                limb2: 0x117e2e9c232e5fab,
                limb3: 0x0
            },
            u384 {
                limb0: 0x6b2d3e7147d0964d85b535ed,
                limb1: 0x3716a073c98b16e9b6f891e7,
                limb2: 0x209d627af60ea033,
                limb3: 0x0
            },
            u384 {
                limb0: 0xc0d46663cfe117131a0bcd0f,
                limb1: 0xd9ce72ab5ceacdc09db0a770,
                limb2: 0x289e1a1de1ae1007,
                limb3: 0x0
            },
            u384 {
                limb0: 0xff555ae5553da58add28c2a1,
                limb1: 0x3bc4b9f88263da78405087bd,
                limb2: 0x251211bb7fb032ec,
                limb3: 0x0
            },
            u384 {
                limb0: 0xd1886c290eee95136487b1e,
                limb1: 0xa9392defe7cc081690f089f3,
                limb2: 0x10fc9bb41bb19aa0,
                limb3: 0x0
            },
            u384 {
                limb0: 0x19f8b828a40aaab86ea4e398,
                limb1: 0x199459c40995e98cc82dd858,
                limb2: 0x15290a3053ec7d88,
                limb3: 0x0
            },
            u384 {
                limb0: 0xc9f775c84d924c83c9b29ee7,
                limb1: 0x18c2a569109d5b97920fdf72,
                limb2: 0x1ebb4131643d87ba,
                limb3: 0x0
            },
            u384 {
                limb0: 0x531d32b6e80c5c542630b965,
                limb1: 0x3cee7eb021653fa639989ec0,
                limb2: 0x288acb3234e85fe,
                limb3: 0x0
            },
            u384 {
                limb0: 0xddf384691fdbb38b6e2d1e4,
                limb1: 0x8c0f53727a03ee5c77b9611e,
                limb2: 0xf0c58f88d40d542,
                limb3: 0x0
            },
            u384 {
                limb0: 0x3f5c7c2dde74ae046c9ff1ec,
                limb1: 0xd0cf422e9f890d0937ac7d7d,
                limb2: 0x15469b2b18e8dd41,
                limb3: 0x0
            },
            u384 {
                limb0: 0x430928ae79dac846a63a98d1,
                limb1: 0x30cc068d7a9f3f59c92c663c,
                limb2: 0x1cf918d4ce0db340,
                limb3: 0x0
            },
            u384 {
                limb0: 0x9a4ac3d928e4f627ab48e297,
                limb1: 0x91ea90bdd513466536c83bb2,
                limb2: 0x1672f7e1676b9e5d,
                limb3: 0x0
            },
            u384 {
                limb0: 0x63fdedb4431c327f6e15039a,
                limb1: 0xb999c75c21819e782aca8ff8,
                limb2: 0x22aabf2e98b83c2d,
                limb3: 0x0
            },
            u384 {
                limb0: 0xcc49c10f1c23b2207d7cb4ba,
                limb1: 0xe76ba1659bcb160a3c0294d5,
                limb2: 0x2ba989b25863f76c,
                limb3: 0x0
            },
            u384 {
                limb0: 0x3633cb67e33666a1fadc0b74,
                limb1: 0x4a12d0df3988ba0f653d8c90,
                limb2: 0x14276ff7944e13df,
                limb3: 0x0
            },
            u384 {
                limb0: 0xd0a776b05c3e5d9b0640151e,
                limb1: 0xed6d3a646d2b012308f2bc96,
                limb2: 0x301e36b0bb2b26f3,
                limb3: 0x0
            },
            u384 {
                limb0: 0xcb691e67927b9b5a067988f6,
                limb1: 0xca7b0dc68c63ea50a00305a5,
                limb2: 0x2ff21b29059d3e99,
                limb3: 0x0
            },
            u384 {
                limb0: 0x6831dac80daa03440c5a0777,
                limb1: 0x4cfec3f69f8ae5f5f4931c8c,
                limb2: 0x1539258373fa5ecd,
                limb3: 0x0
            },
            u384 {
                limb0: 0xe6802d8506b91213a4cbda99,
                limb1: 0x1b2d8cd061c96b448e4924b8,
                limb2: 0x118026d46bb639cd,
                limb3: 0x0
            },
            u384 {
                limb0: 0xb2d67b2bc881f9fcb8e6793,
                limb1: 0xb6129ff56ca50c9ccd6126b,
                limb2: 0x1656bbc90ffefecd,
                limb3: 0x0
            },
            u384 {
                limb0: 0xac9c74e2cdeb0960a7548bad,
                limb1: 0x1e55f521a9fc795dc3d0db4b,
                limb2: 0x2c2825619ed8bfa8,
                limb3: 0x0
            },
            u384 {
                limb0: 0x390206adf116459befa60af,
                limb1: 0x86983739a1550300e07d5b15,
                limb2: 0x649b686a1619600,
                limb3: 0x0
            },
            u384 {
                limb0: 0xc11e95c392a55f24d592d2ca,
                limb1: 0x3656389d08cf9fa68a68c17b,
                limb2: 0x252e711097919d6b,
                limb3: 0x0
            },
            u384 {
                limb0: 0x3a7fb889df29a50e133d9e6f,
                limb1: 0xb0ea0c7c64d13773214c4d29,
                limb2: 0x2a328250ef28c051,
                limb3: 0x0
            },
            u384 {
                limb0: 0x3f0a22d210fcdf7c754efc5d,
                limb1: 0xc3e3187bdfaec0ab3a70f605,
                limb2: 0x7947c8aff893bcf,
                limb3: 0x0
            },
            u384 {
                limb0: 0xdf539ccb6f1ad17127ca4492,
                limb1: 0x6b9cfa617da9c122ac2f5716,
                limb2: 0x26f2aa38419ed40a,
                limb3: 0x0
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
            limb0: 0x359a88e91666fed125fc48ee,
            limb1: 0xcb33893efeb0ec94deecf734,
            limb2: 0x2924ce392bfa57d1,
            limb3: 0x0
        };
        assert_eq!(final_check_result, final_check);
    }


    #[test]
    fn test_run_BN254_MP_CHECK_INIT_BIT_2_circuit_BN254() {
        let yInv_0: u384 = u384 {
            limb0: 0xfbb2242955ab42c50f08502e,
            limb1: 0x4420e63bc34dfc6428e2f201,
            limb2: 0x2e17cbb19d6fe1b5,
            limb3: 0x0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0x386b01c05ffe6c117b51aca6,
            limb1: 0x16f48941ad283c0df230400a,
            limb2: 0x521a037b9e789c6,
            limb3: 0x0
        };

        let Q_0: G2Point = G2Point {
            x0: u384 {
                limb0: 0xca563921f9422f1efed97f9e,
                limb1: 0x8191cbeb175bf448a0ce5b5f,
                limb2: 0x11f355bfd6cc364,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x188417d8fe9f9ff698bc2c7a,
                limb1: 0x3c241ca590425d14e6b0643c,
                limb2: 0x2a3d507052ba051,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x64327fe8deccac5b968d4f41,
                limb1: 0xc5acc61220de5de4b5b46896,
                limb2: 0x24d96224e4600a02,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xbc031029253053ae4db1762e,
                limb1: 0x3455f1f64574a37e9dbff93f,
                limb2: 0x8b9fb9614147ca8,
                limb3: 0x0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0xa9f15f7cd7ea0686e5f14395,
            limb1: 0xf3c73944f95c46f7682e4002,
            limb2: 0xcba5dd82e975c72,
            limb3: 0x0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0x466ed6b96bad500ded1b802,
            limb1: 0xa892d63b89aeb61659f88a69,
            limb2: 0x2b660a827ad06668,
            limb3: 0x0
        };

        let Q_1: G2Point = G2Point {
            x0: u384 {
                limb0: 0xd0ab9ea4c15f47ca204e6817,
                limb1: 0x14e153ca45568d6dbdc5a588,
                limb2: 0x2e184df0e5ffc7d4,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xda344d179e31e1f9b30cc272,
                limb1: 0x477e2817ddd1b251b0f62b9e,
                limb2: 0x26581734cab24a0a,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x10ac3f8387787e2bc8a8038,
                limb1: 0xd2ebe96b24b7d424e4ed458b,
                limb2: 0x2f61a4c435069af5,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xdd28b3acea35a393d5e33b,
                limb1: 0x253dc9ce208d549b6b0efd01,
                limb2: 0x22779e8b7c26c722,
                limb3: 0x0
            }
        };

        let R_i = E12D {
            w0: u384 {
                limb0: 0x51995cf180d9a24e0a833038,
                limb1: 0xab78a4ee385127f1f317930e,
                limb2: 0x1d395b1a2ca5f0cb,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0xe1976c14aa069b5b510d115a,
                limb1: 0xf0cc8eec3b3fd363714d85bd,
                limb2: 0x28ca26d6a62f45c2,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0xacdf3038467ccafabbe74e1b,
                limb1: 0x19b2b59530519f6ab51e3a7b,
                limb2: 0x1f5e82fe598c8a5c,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0x89e4b9df5a45a71745ac1564,
                limb1: 0x486095c2f812b02296b09e29,
                limb2: 0x12498a8437c67f46,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0x10c313bd6478a3998d682a61,
                limb1: 0x1d21ae7c60252b8d2cd9f51a,
                limb2: 0x25c281b7f444adae,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0x75f80092ea4f44cfeafd080b,
                limb1: 0x42f811266c2c90a724e90316,
                limb2: 0x2ef29db8e56a47e7,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0xc2e8fae231f0e15089419b16,
                limb1: 0xbd335a642d79f3f6ca92720a,
                limb2: 0x10f6c08d1184d8fb,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0x8a849529b662f7edb5b85fb3,
                limb1: 0xa7f3c30f26e5e2da91b92f8b,
                limb2: 0x138b8b1b08e7a744,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0x8428d34471948be49de0103a,
                limb1: 0xfd14f9d493510969c2ebbadc,
                limb2: 0xd72d83c6a75e179,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0x64348207341514cc77fd7fd1,
                limb1: 0x18fa547216752b38fd642ae2,
                limb2: 0x19bc3dda8909c1ba,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0xac69c00681b84ea71f217475,
                limb1: 0xa7484ffbbfd9de847770ca8d,
                limb2: 0x210e6e82afd65c3,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0x3d9f3e803ba6857733964543,
                limb1: 0x60c36cdd9937f592185aeb98,
                limb2: 0x4755ab3680fe5e2,
                limb3: 0x0
            }
        };

        let c0: u384 = u384 {
            limb0: 0x8c479390d41cc2bce3352f8b,
            limb1: 0x32dec6d586901942366e3cca,
            limb2: 0x1f796d2837ef373e,
            limb3: 0x0
        };

        let z: u384 = u384 {
            limb0: 0xecb9cb393103d90417426bd0,
            limb1: 0x836150061981f0d4dbf9a793,
            limb2: 0x26a4921221566d5e,
            limb3: 0x0
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 0x93aae4808cdc538931ffba99,
            limb1: 0x9efb00b7a397b217851143e5,
            limb2: 0x2672cdf16e7fbad2,
            limb3: 0x0
        };

        let previous_lhs: u384 = u384 {
            limb0: 0xa41a5d31dd5eb2d16518020a,
            limb1: 0xac331b9243189f26e9b74954,
            limb2: 0x1e2a690eccea521d,
            limb3: 0x0
        };

        let (Q0_result, Q1_result, new_lhs_result, c_i_result, f_i_plus_one_of_z_result) =
            run_BN254_MP_CHECK_INIT_BIT_2_circuit(
            yInv_0, xNegOverY_0, Q_0, yInv_1, xNegOverY_1, Q_1, R_i, c0, z, c_inv_of_z, previous_lhs
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x1c0337c1016f14494bc2d838,
                limb1: 0x378cc1aab8a184510cd04354,
                limb2: 0x20c0e1d8b30e367b,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xca269ab84ed510c185ac2db9,
                limb1: 0x9653ed8336f7bdb244d3a65b,
                limb2: 0xddc89143a3a02a5,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xcbdff6dd1e96852e3f1d950a,
                limb1: 0x5ac98c99330dd3d54d0b9d9,
                limb2: 0x4c29f22165a580d,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x2b64f08fa020da492d682be8,
                limb1: 0xd93b224fce29be664857eaf2,
                limb2: 0x302e5c782f6a2ea2,
                limb3: 0x0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0xaa74877476d216d4bb5dfd0c,
                limb1: 0x10e5b57e71458dba3349dfc1,
                limb2: 0x1e532c796b9f5e25,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xef6957175e96d1531bcd7200,
                limb1: 0x129283f7f8d59dccaa8bb62a,
                limb2: 0x7644f0a0b0625d4,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xc91624bc4c8f7468edad70f8,
                limb1: 0x742a44b2a1629c31bd3e7b95,
                limb2: 0x2b440ab41eab30af,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x937a0214a53acc815167db6e,
                limb1: 0x29fda455bd3cb59c72540448,
                limb2: 0x8829d82bd45a331,
                limb3: 0x0
            }
        };

        let new_lhs: u384 = u384 {
            limb0: 0x856e82390ce03541de079417,
            limb1: 0x72d8eb4e9ec0149d7c6b36ca,
            limb2: 0x19757acaf0a497c6,
            limb3: 0x0
        };

        let c_i: u384 = u384 {
            limb0: 0xe5fd3f997000212aa83dea6d,
            limb1: 0xf30c04434c3c8d019a06d26f,
            limb2: 0x2cca777e43e2d7e1,
            limb3: 0x0
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0x31e2999d6969f8055c2442a4,
            limb1: 0x6ce2bca71fc0e30404947c4c,
            limb2: 0x2611f15616377dc3,
            limb3: 0x0
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
            limb0: 0x34b65ceec9d4e1bbc4d3fec2,
            limb1: 0x8dfc975a4fd9204b3b9e84e,
            limb2: 0xca56e9af9873b5e,
            limb3: 0x0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 0x84983111371a239070c742d0,
            limb1: 0xd35f581e3648431fae9e8d03,
            limb2: 0x92c9fa001cbd9c2,
            limb3: 0x0
        };

        let Q_0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x78ca810e742863563c91e458,
                limb1: 0x46ac32019ab1874e17668e8a,
                limb2: 0x2988814fd5ff7894,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xebe3387b68cbaa9e22d72fab,
                limb1: 0xdb5bf01f3d75489ae1289e96,
                limb2: 0x1f08eeff0490642f,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x846736ce24dbac94486cf4d6,
                limb1: 0x5ec2abf6a2237d40d836ba33,
                limb2: 0x2b56b043bd3ccd61,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x82042c0b1da221b825454e29,
                limb1: 0xaef82d2e51f83e44524bba5b,
                limb2: 0x4d66071b984dbe3,
                limb3: 0x0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 0xcfa71765e757155d5c07d046,
            limb1: 0x33423b60310dfbf4d7418ae8,
            limb2: 0x12e472fafea4ca6a,
            limb3: 0x0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 0x6c811d57b2835bff857d114b,
            limb1: 0xbcd635ccb9c4abb6a6a99aab,
            limb2: 0x1943c4dd60fc01e2,
            limb3: 0x0
        };

        let Q_1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x70dd4704248988cf091523be,
                limb1: 0xa1239c7249ace04913bd01ae,
                limb2: 0x9ec8a9ca9452a96,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xd4814f7f3022b8f186d6c424,
                limb1: 0x599490667d4165889a347cda,
                limb2: 0x2577492f27c4bf8d,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x92976e6ce04d350f260aeef2,
                limb1: 0xbdb63f3243cec8096dec9a46,
                limb2: 0x7793ab4362b5eea,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x23a8eb6e2864120ef118ac10,
                limb1: 0xd9535d1dea83986171027b03,
                limb2: 0x1b1fd03e8946352d,
                limb3: 0x0
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 0xd6cadf412df1fe3fefd9373e,
            limb1: 0xc0038e5a4c8349bc09cef0ea,
            limb2: 0x24aa5c5d785ecebc,
            limb3: 0x0
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 0x5dde2c6aaeb5964415d51b49,
            limb1: 0x1938d096ed3dffdfa5bb2389,
            limb2: 0x1fa2324c19db1d7b,
            limb3: 0x0
        };

        let Q_2: G2Point = G2Point {
            x0: u384 {
                limb0: 0x773506171615975596df541f,
                limb1: 0xbcb43dc942923754d24cc9b8,
                limb2: 0x1070537095f9d782,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xcb0206728fff6a1ab3e52b15,
                limb1: 0x3cd2aad82997e8996059c8a9,
                limb2: 0x7ce652fa013e55e,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x94c7cd9ad28d65a1adc786e7,
                limb1: 0xc7975813ba4e199cf2b8fd15,
                limb2: 0xa3b1f19848d77e3,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xa6728c5c7f25943cf4634a81,
                limb1: 0x3e41ca28a0c7bb90eef7133a,
                limb2: 0xe7e8cf3035e4eb9,
                limb3: 0x0
            }
        };

        let R_i = E12D {
            w0: u384 {
                limb0: 0x27833e60f8b2ca91a3073280,
                limb1: 0xcf86e88ec361570dd925bbaa,
                limb2: 0x25e3fcb2d23a817d,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0x1162ce262d64584a9ee08eef,
                limb1: 0x18700fd5478947081b08fdc1,
                limb2: 0x27de91ae450000a1,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0xc7b2595e93c3150d77c3f04f,
                limb1: 0x6b7b2370940ca324420a746a,
                limb2: 0x2a7ffa5fdf0d605,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0x24301b871322439ab54faf70,
                limb1: 0x73961f8efaa83536d3d779d5,
                limb2: 0x1635ddb60f013f4e,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0x3deaf9a0a724dc8f4be669fb,
                limb1: 0x16d24a67c6b1b41f3659333f,
                limb2: 0x2e2232d997b19d4f,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0xc3e5382702bc0550dfeddf7e,
                limb1: 0x940795d06bbb961d401f8134,
                limb2: 0x230dcaab84eefe22,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0xb5f767d3211149a5faaad22c,
                limb1: 0x91c9992fb73a068354f69e70,
                limb2: 0x22212e07a7e15728,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0xec8bd9786363a1f0fcfd3246,
                limb1: 0x184dc5184c596a49334f97a4,
                limb2: 0x2989f8c771f5df2e,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0xd4ddaab72824622a4b0c73b,
                limb1: 0xc5731c99c6d82ceba1acdd49,
                limb2: 0x20aa448d490c3127,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0x6c82a1f1c59f7dfc9f3bca77,
                limb1: 0xd7cbd7ff9c7d710f77dc6602,
                limb2: 0x2f97064c91a69f34,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0x41d1240bb53c902262885f8c,
                limb1: 0xe1558ec67c1ba84f32a59e37,
                limb2: 0x10f17cb478886792,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0x3faa677b1a8e5c62c075d2c,
                limb1: 0x42ffb01756c16359352f0341,
                limb2: 0x2d3edabeb56036ef,
                limb3: 0x0
            }
        };

        let c0: u384 = u384 {
            limb0: 0x1bf8fbebd06e62e6dc5a2a83,
            limb1: 0x6fa2be1307fce776a85536f3,
            limb2: 0x14a5772b4f651f21,
            limb3: 0x0
        };

        let z: u384 = u384 {
            limb0: 0xa416c71df64d977c20a4ef0e,
            limb1: 0x5b847a843ffd9bf21fb99669,
            limb2: 0x2e2533c8c2dc9456,
            limb3: 0x0
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 0x7100065778edd1c6e98114a4,
            limb1: 0xd67ca257afed8aae2c7bf199,
            limb2: 0x1b5f3be95aa2356b,
            limb3: 0x0
        };

        let previous_lhs: u384 = u384 {
            limb0: 0x68fe86666fb5545cd95cd1ae,
            limb1: 0x1b067b10958620855d587077,
            limb2: 0x59e7773fc8847d2,
            limb3: 0x0
        };

        let (
            Q0_result, Q1_result, Q2_result, new_lhs_result, c_i_result, f_i_plus_one_of_z_result
        ) =
            run_BN254_MP_CHECK_INIT_BIT_3_circuit(
            yInv_0,
            xNegOverY_0,
            Q_0,
            yInv_1,
            xNegOverY_1,
            Q_1,
            yInv_2,
            xNegOverY_2,
            Q_2,
            R_i,
            c0,
            z,
            c_inv_of_z,
            previous_lhs
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 0xa8537a704cb881eb8daa836e,
                limb1: 0x188e9290a09a319ffe72ccf8,
                limb2: 0x1b07451519dc12e0,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xc2c1c9794c00e6d5b78fb3b,
                limb1: 0xd85e23ee82bfba38a2594bfb,
                limb2: 0x9863c2f6db02151,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x67e534b92064cfa545fe2f41,
                limb1: 0x88a6805f35ceee8512fe8250,
                limb2: 0x1be78a9de5910209,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xa925a305b5615014407e7d62,
                limb1: 0xb16f9abc94e69d59baf8b3eb,
                limb2: 0x1177fa9dadef281c,
                limb3: 0x0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x91a010051530d8bf3c3092f9,
                limb1: 0xa68dc13a3c962e701c30b1ad,
                limb2: 0x5a8c49c38424e01,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x55567b1018078e6fff91e52c,
                limb1: 0x2f7d524249abb29ae717060a,
                limb2: 0x1461455739e082dd,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xe3f0544dd0ab617cab66c7e0,
                limb1: 0x71da0e2a4d9d0953db194f83,
                limb2: 0x284400e0bfe6fc5c,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xf8914933731054f2cdb355f5,
                limb1: 0xffa03755a382552e32d41828,
                limb2: 0x1b7e7ed803016691,
                limb3: 0x0
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 0x837a7d31123a740487e0f65d,
                limb1: 0x9e07b447682915ee74661e8b,
                limb2: 0x1865205c3a033ac1,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x66647de2522c0e5f27448e71,
                limb1: 0xf25cfb841c491d29598d5eb,
                limb2: 0xd0a43d3440e1492,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x4b0c9d987cde3b60cd192faa,
                limb1: 0xfbbe4ba526d713e3ca305005,
                limb2: 0x1ba68a41b32f7f64,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x6bc22e87a1a336b12b88f615,
                limb1: 0x79e3266b3ae661f36140ad48,
                limb2: 0x2a4b17928e0aa8b6,
                limb3: 0x0
            }
        };

        let new_lhs: u384 = u384 {
            limb0: 0x576083e00670f7c9378caf60,
            limb1: 0xa4051503b114ec09414ec60f,
            limb2: 0x1858161681c24f91,
            limb3: 0x0
        };

        let c_i: u384 = u384 {
            limb0: 0x24bf2a7481ceee35166b2d51,
            limb1: 0x5e2f6caa2a228b874ee1349f,
            limb2: 0x29fd8df362e0fac2,
            limb3: 0x0
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 0xb315f8f46cb1dda097882fc5,
            limb1: 0x7bb3da1beb24f3ba44bb2498,
            limb2: 0x9df3ea27dc0c478,
            limb3: 0x0
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
        let lambda_root = E12D {
            w0: u384 {
                limb0: 0xe05f6b98bdd4b9dfc2cd5c7,
                limb1: 0x72189a39d63a7486be216476,
                limb2: 0x22b6ada2e0dd0541,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0xf10185fd8f81598725394778,
                limb1: 0xa4ed017b208a888ee6e4ac85,
                limb2: 0x25aad93435128906,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0xd4ae34862b194984f49eb5a6,
                limb1: 0x7837e5069398dbd616db36e4,
                limb2: 0x1124cf2149adce95,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0xc61b2c77860215be0d326347,
                limb1: 0xe04ee43c11f63e9bc7361a75,
                limb2: 0x28ed394a02a007fc,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0xc5cf255f278db4f648df480e,
                limb1: 0xc2ff347bd527b331240eb6c1,
                limb2: 0x89d003681de9808,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0x25365ca8d66a45e952c51809,
                limb1: 0xc045883b940f737e548c3ec4,
                limb2: 0x58342e71004d975,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0x40fd8aaa3504e26c5f7e07d3,
                limb1: 0xaeaaec4854f1a7a37378e6ca,
                limb2: 0x1e1d059a7c34e6eb,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0xa4efedef24cb0b4e3825a7e1,
                limb1: 0xdfde522dd429e0c9664ceba8,
                limb2: 0x140e997582edc5ab,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0x120a202fe11a15c325efc3a9,
                limb1: 0x8d17e6327e8aeae24a703e3,
                limb2: 0x294015606250e9f9,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0xaa0cc3271daa42fc90b15e3d,
                limb1: 0x448236e9863c6992116febe7,
                limb2: 0x135f911290b6e394,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0xaa648f16f03550885a2bf7fe,
                limb1: 0x7a1a262bba13834fde8e3228,
                limb2: 0x25dab97e66f1b0a0,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0xbe72544851b5ab77d09e1abb,
                limb1: 0x9f519184e79d4d5fab6fc9e7,
                limb2: 0x20cb579c777cd128,
                limb3: 0x0
            }
        };

        let z: u384 = u384 {
            limb0: 0x579e9b085db13edffa29559d,
            limb1: 0x1c3df9183278f64cae1367a,
            limb2: 0x24c261523ff0e579,
            limb3: 0x0
        };

        let scaling_factor: MillerLoopResultScalingFactor = MillerLoopResultScalingFactor {
            w0: u384 {
                limb0: 0x1c67556d79acd84313b2cc15,
                limb1: 0xc43eebcc6f69ed695e349e31,
                limb2: 0xf9bf7ac9e76ef95,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0x84c85b950637da9e8bb62aff,
                limb1: 0xf97b8d621c9527d081ffbbc1,
                limb2: 0x247952ce0a4e6eb7,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0xf146b0800a2cf6a95bd38392,
                limb1: 0x5745ef5a2e0885fc5da23c06,
                limb2: 0x1f1b5d2a44ee5071,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0x3c74dbc2c504644fa5dc7c7b,
                limb1: 0x7a37e212a78c1cdaa7838837,
                limb2: 0x2e6acc23be2b3272,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0xaef472a758216f30e31b9123,
                limb1: 0xd370c51fd8e2ba4ccd84344b,
                limb2: 0x2e70e9e3c8d3acee,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0xb2f72efec0959b82924b159,
                limb1: 0x7af0cf69bd2098c6c2de5950,
                limb2: 0x2a24daf486a29efb,
                limb3: 0x0
            }
        };

        let c_inv = E12D {
            w0: u384 {
                limb0: 0x2a364435eda04e30ff741d1c,
                limb1: 0xb202054f62a10ce2d545de36,
                limb2: 0x2bd638e049ac2f36,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0x7bd37c4b948c52c8e0f24eb3,
                limb1: 0x6fccff0e9e4f06c36890df9,
                limb2: 0x1d123de6b50a676c,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0x998b1e1c9f81fca3ffb1c2c9,
                limb1: 0xabbebd4ff9e590e4d36d8076,
                limb2: 0x2723fa042c645b82,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0xa0e5bd8cdd7524bcdd82016d,
                limb1: 0x6df5e2aa832cb6a724e2e13a,
                limb2: 0xf2ebf2a643580a0,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0x4b9368d961880ea05e5ecd0a,
                limb1: 0x4142452b361c57ab3d992624,
                limb2: 0xf799d3ff66b72a9,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0xdda9a02a964fbdde895585be,
                limb1: 0x5f3fa533e28cfc3ced825ea8,
                limb2: 0x1d277c7ff13a9049,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0x56756682996d66423cf87ff0,
                limb1: 0x257ea412a21574899fbd4b9f,
                limb2: 0xf96bb6052722246,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0xc2862234d81580dc24d878a1,
                limb1: 0x2c481f988ce67bdc41b72448,
                limb2: 0x2d190aeb89599298,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0x1d5f9dfc98b0b4d7b5e16e19,
                limb1: 0x72678417ec023a99e4c80a29,
                limb2: 0xd1bae8c7ad5af81,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0x7f29e86c8a730eaa16bb4fb0,
                limb1: 0x4b32bc8635d5870de79d1be2,
                limb2: 0x117fe8da63c2523d,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0x5a9c60b533b887d38301c5b9,
                limb1: 0x50b91e51681e5658d813a70f,
                limb2: 0x153c159bb1a48e2,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0x14b8317e75555ded8ea5e386,
                limb1: 0x49ab05a8806094aa4037fffa,
                limb2: 0x1f21d96db04a2620,
                limb3: 0x0
            }
        };

        let c_0: u384 = u384 {
            limb0: 0x506e2fc6d05d2cb96b76911f,
            limb1: 0xbe23bd25ac788719d9371f2a,
            limb2: 0x2ccd3aefef6ed981,
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
            limb0: 0xcf94b541aa7c38c4057a1f45,
            limb1: 0xb9e2aae897ec93ddd1bc8b24,
            limb2: 0xaedad617e60a4b8,
            limb3: 0x0
        };

        let scaling_factor_of_z: u384 = u384 {
            limb0: 0xe8d7e82c1ce394ab6ab1e4bc,
            limb1: 0xa45c7d888cf96a0c47e6ee6b,
            limb2: 0x11a9bf5514056fb1,
            limb3: 0x0
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 0x2d19d2c796c5dca37598cae6,
            limb1: 0x90cac97a597a54914998008d,
            limb2: 0xc0df81d568c066b,
            limb3: 0x0
        };

        let lhs: u384 = u384 {
            limb0: 0x3cdb5cc21ba29229c486002d,
            limb1: 0x8f57734895528df52c2c7267,
            limb2: 0x303228264539f8ef,
            limb3: 0x0
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 0x5ae84cbfda7fda14b5888b7b,
            limb1: 0x794916b384d77225f6686733,
            limb2: 0x1f743e9b3c3e4b00,
            limb3: 0x0
        };

        let c_frob_2_of_z: u384 = u384 {
            limb0: 0x8272d2b1228c3b162fa62bdf,
            limb1: 0x7dcf9a644674dff26be24de5,
            limb2: 0xedbb53cf664f08e,
            limb3: 0x0
        };

        let c_inv_frob_3_of_z: u384 = u384 {
            limb0: 0xf2d4f957f7770f6e197f427,
            limb1: 0x935673e210824cda0b423fab,
            limb2: 0x10bc2e2a09408044,
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
                limb0: 0x438b3d4a81b3fe3fda48455,
                limb1: 0xea9e062a9b89bf0d054961d6,
                limb2: 0xab7f609edaeec39,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x5cffc96ebd03c81f7ff35029,
                limb1: 0x167ad0895acecdbfdbb59fc2,
                limb2: 0x1ba4d7eb9502e1d5,
                limb3: 0x0
            }
        };

        let Qy0_0: u384 = u384 {
            limb0: 0xb311d9c41d86fd12c8359b91,
            limb1: 0x2c14af79c4a0c1cd0654f465,
            limb2: 0x26020b3c03a769aa,
            limb3: 0x0
        };

        let Qy1_0: u384 = u384 {
            limb0: 0x5a505a9845c55e39881d0ee1,
            limb1: 0xdedff24b3567c813bd05bc2c,
            limb2: 0x1892ab6bebbcf1f6,
            limb3: 0x0
        };

        let p_1: G1Point = G1Point {
            x: u384 {
                limb0: 0x2f39c04551bb91c132620328,
                limb1: 0x7f0df2ca2dc6c2accbae0e93,
                limb2: 0x9ac6219a878e876,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0xe7eb533c3a0879fbdc7843b3,
                limb1: 0x6fa680100ddd49b700b425aa,
                limb2: 0x26afcf9ae5bcd7ed,
                limb3: 0x0
            }
        };

        let Qy0_1: u384 = u384 {
            limb0: 0xa5cbed9fa57949170806989a,
            limb1: 0x22b34047ee4b0498a5f3aa63,
            limb2: 0x57436d080a17176,
            limb3: 0x0
        };

        let Qy1_1: u384 = u384 {
            limb0: 0xb6e4d16e30668cc99e7f0271,
            limb1: 0xf8b55fb556d1079c0fbc0318,
            limb2: 0x143b5abc235f6be1,
            limb3: 0x0
        };

        let (p_0_result, p_1_result) = run_BN254_MP_CHECK_PREPARE_PAIRS_2_circuit(
            p_0, Qy0_0, Qy1_0, p_1, Qy0_1, Qy1_1
        );
        let p_0: BNProcessedPair = BNProcessedPair {
            yInv: u384 {
                limb0: 0x16b21df9c444b3f657f7fb48,
                limb1: 0x5a96d736ba8248c7b888f27e,
                limb2: 0x2251246b59185164,
                limb3: 0x0
            },
            xNegOverY: u384 {
                limb0: 0xf943f85038d4b81a2ed52cb2,
                limb1: 0x53da740bbb0a22753aa0bf8a,
                limb2: 0xdb1090e6c0e3efa,
                limb3: 0x0
            },
            QyNeg0: u384 {
                limb0: 0xb55ff0c91e998f04104761b6,
                limb1: 0x8c3b963cbce09690912c762b,
                limb2: 0xa624336dd8a367f,
                limb3: 0x0
            },
            QyNeg1: u384 {
                limb0: 0xe216ff4f65b2ddd505fee66,
                limb1: 0xd970536b4c199049da7bae65,
                limb2: 0x17d1a306f574ae32,
                limb3: 0x0
            }
        };

        let p_1: BNProcessedPair = BNProcessedPair {
            yInv: u384 {
                limb0: 0xc0537d2b18c00d01f548185b,
                limb1: 0x1e27140e7f279e3b80cc370c,
                limb2: 0x1d514b439ecb73fc,
                limb3: 0x0
            },
            xNegOverY: u384 {
                limb0: 0xbe15223b25c58a899aba3b78,
                limb1: 0x48b3865afce91cbd89064a62,
                limb2: 0x1314bbafd584953c,
                limb3: 0x0
            },
            QyNeg0: u384 {
                limb0: 0xc2a5dced96a742ffd07664ad,
                limb1: 0x959d056e933653c4f18dc02d,
                limb2: 0x2af017a260902eb3,
                limb3: 0x0
            },
            QyNeg1: u384 {
                limb0: 0xb18cf91f0bb9ff4d39fdfad6,
                limb1: 0xbf9ae6012ab050c187c56778,
                limb2: 0x1c28f3b6bdd23447,
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
                limb0: 0xa83299e9fae46529fa9fcece,
                limb1: 0x7c6d8ae1463e4336bf3cfe56,
                limb2: 0x1eccc907fa2225d7,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x54a1396ce9abfb0d9be57401,
                limb1: 0xa55dc720e55400224502d7f8,
                limb2: 0x1d5aa84f13f1484a,
                limb3: 0x0
            }
        };

        let Qy0_0: u384 = u384 {
            limb0: 0x28da2b89c1308a09cddd03bb,
            limb1: 0x832e9e1e1b908d6de5e6190b,
            limb2: 0x23c57265424a2898,
            limb3: 0x0
        };

        let Qy1_0: u384 = u384 {
            limb0: 0x9ba66e98679140e0b6fece9a,
            limb1: 0xabc2ded76bd8e65f72a2761a,
            limb2: 0x26e0e90d28b7405b,
            limb3: 0x0
        };

        let p_1: G1Point = G1Point {
            x: u384 {
                limb0: 0x1cc7e2b6c99d5f9ec634effd,
                limb1: 0x1c87284dc5fa8ac995a37efe,
                limb2: 0xbe7d6fed6b6b5d0,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x7b768615f6b1465dbf2b6442,
                limb1: 0xba9d82b8afbae6c34b511edb,
                limb2: 0x2bd01794199a1949,
                limb3: 0x0
            }
        };

        let Qy0_1: u384 = u384 {
            limb0: 0x43215bf46cff30a0c3ac232c,
            limb1: 0x1c52d51ec8fe0b2d46b01630,
            limb2: 0x16c3bb12a2a1fa45,
            limb3: 0x0
        };

        let Qy1_1: u384 = u384 {
            limb0: 0x89386b90d34145328252f723,
            limb1: 0x211550313218ef7cd43cfeb,
            limb2: 0x26e6a6fd0a78491f,
            limb3: 0x0
        };

        let p_2: G1Point = G1Point {
            x: u384 {
                limb0: 0xc689f37bf94523fe03cb8f1e,
                limb1: 0xe36b3a5f23746dddf4105d94,
                limb2: 0x1a1e57981f742e70,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0xfa4abdecc8a86e3a62937980,
                limb1: 0x6ec9ad0e2cbef407b38a089,
                limb2: 0x287158d05033b5a4,
                limb3: 0x0
            }
        };

        let Qy0_2: u384 = u384 {
            limb0: 0x15c7a82023f3e5aed1de4fa8,
            limb1: 0xa4d6ce54645cc176b3f175d0,
            limb2: 0x2ff7e2a79446d493,
            limb3: 0x0
        };

        let Qy1_2: u384 = u384 {
            limb0: 0x995d767b0c1333ce07117e78,
            limb1: 0x21eaa1fa663eab2bc83235cc,
            limb2: 0x2ecb0b108f6dc117,
            limb3: 0x0
        };

        let (p_0_result, p_1_result, p_2_result) = run_BN254_MP_CHECK_PREPARE_PAIRS_3_circuit(
            p_0, Qy0_0, Qy1_0, p_1, Qy0_1, Qy1_1, p_2, Qy0_2, Qy1_2
        );
        let p_0: BNProcessedPair = BNProcessedPair {
            yInv: u384 {
                limb0: 0x6e79369b9dd2abce2b54ae37,
                limb1: 0xa873c98d1cf71bed23fa659a,
                limb2: 0x1c09557073dced21,
                limb3: 0x0
            },
            xNegOverY: u384 {
                limb0: 0x826a2dae1d8f07ae13bd4fc1,
                limb1: 0x1d21efb6473cfffcff178ba0,
                limb2: 0x9da8d43d64b8bc9,
                limb3: 0x0
            },
            QyNeg0: u384 {
                limb0: 0x3f979f037af0020d0a9ff98c,
                limb1: 0x3521a79865f0caefb19b5186,
                limb2: 0xc9edc0d9ee77791,
                limb3: 0x0
            },
            QyNeg1: u384 {
                limb0: 0xcccb5bf4d48f4b36217e2ead,
                limb1: 0xc8d66df15a871fe24def476,
                limb2: 0x9836565b87a5fce,
                limb3: 0x0
            }
        };

        let p_1: BNProcessedPair = BNProcessedPair {
            yInv: u384 {
                limb0: 0xb67fc4799dda65deb5defe9b,
                limb1: 0x94847acded5335f84d58575c,
                limb2: 0x17eace0cb42d6fa2,
                limb3: 0x0
            },
            xNegOverY: u384 {
                limb0: 0xd0545a60ed1f815cbfbd76a4,
                limb1: 0xafb3fcb3581fe53c360608cd,
                limb2: 0x13a19d2631c2468a,
                limb3: 0x0
            },
            QyNeg0: u384 {
                limb0: 0x25506e98cf215b7614d0da1b,
                limb1: 0x9bfd7097b8834d3050d15461,
                limb2: 0x19a093603e8fa5e4,
                limb3: 0x0
            },
            QyNeg1: u384 {
                limb0: 0xdf395efc68df46e4562a0624,
                limb1: 0xb63ef0b36e5fc965ca3d9aa5,
                limb2: 0x97da775d6b9570a,
                limb3: 0x0
            }
        };

        let p_2: BNProcessedPair = BNProcessedPair {
            yInv: u384 {
                limb0: 0x34200c11bb511207f3e9ba07,
                limb1: 0xe271fe0aab44e7a022ed1b54,
                limb2: 0xf4fe8aeb1345f0b,
                limb3: 0x0
            },
            xNegOverY: u384 {
                limb0: 0xc6f2fbcedac6edc3598fc557,
                limb1: 0xe78dfa7e1ddccac0f25201ea,
                limb2: 0x303e6b03f27e8d8b,
                limb3: 0x0
            },
            QyNeg0: u384 {
                limb0: 0x52aa226d182ca668069ead9f,
                limb1: 0x137977621d2496e6e38ff4c1,
                limb2: 0x6c6bcb4ceacb96,
                limb3: 0x0
            },
            QyNeg1: u384 {
                limb0: 0xcf145412300d5848d16b7ecf,
                limb1: 0x9665a3bc1b42ad31cf4f34c4,
                limb2: 0x199436251c3df12,
                limb3: 0x0
            }
        };
        assert_eq!(p_0_result, p_0);
        assert_eq!(p_1_result, p_1);
        assert_eq!(p_2_result, p_2);
    }
}
