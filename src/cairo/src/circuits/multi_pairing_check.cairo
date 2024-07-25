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
    let t66 = circuit_mul(t63, t0); // Eval sparse poly line_0 step coeff_2 * z^2
    let t67 = circuit_add(t61, t66); // Eval sparse poly line_0 step + coeff_2 * z^2
    let t68 = circuit_add(t67, t1); // Eval sparse poly line_0 step + 1*z^3
    let t69 = circuit_mul(t64, t4); // Eval sparse poly line_0 step coeff_6 * z^6
    let t70 = circuit_add(t68, t69); // Eval sparse poly line_0 step + coeff_6 * z^6
    let t71 = circuit_mul(t65, t6); // Eval sparse poly line_0 step coeff_8 * z^8
    let t72 = circuit_add(t70, t71); // Eval sparse poly line_0 step + coeff_8 * z^8
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
    let t128 = circuit_mul(t125, t0); // Eval sparse poly line_1 step coeff_2 * z^2
    let t129 = circuit_add(t123, t128); // Eval sparse poly line_1 step + coeff_2 * z^2
    let t130 = circuit_add(t129, t1); // Eval sparse poly line_1 step + 1*z^3
    let t131 = circuit_mul(t126, t4); // Eval sparse poly line_1 step coeff_6 * z^6
    let t132 = circuit_add(t130, t131); // Eval sparse poly line_1 step + coeff_6 * z^6
    let t133 = circuit_mul(t127, t6); // Eval sparse poly line_1 step coeff_8 * z^8
    let t134 = circuit_add(t132, t133); // Eval sparse poly line_1 step + coeff_8 * z^8
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
    let t191 = circuit_mul(t188, t0); // Eval sparse poly line_0 step coeff_2 * z^2
    let t192 = circuit_add(t186, t191); // Eval sparse poly line_0 step + coeff_2 * z^2
    let t193 = circuit_add(t192, t1); // Eval sparse poly line_0 step + 1*z^3
    let t194 = circuit_mul(t189, t4); // Eval sparse poly line_0 step coeff_6 * z^6
    let t195 = circuit_add(t193, t194); // Eval sparse poly line_0 step + coeff_6 * z^6
    let t196 = circuit_mul(t190, t6); // Eval sparse poly line_0 step coeff_8 * z^8
    let t197 = circuit_add(t195, t196); // Eval sparse poly line_0 step + coeff_8 * z^8
    let t198 = circuit_mul(t136, t197); // Mul (f^4 * (Π(i,k) (line_i,k(z)))^2) * line_i+1_0(z)
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
    let t253 = circuit_mul(t250, t0); // Eval sparse poly line_1 step coeff_2 * z^2
    let t254 = circuit_add(t248, t253); // Eval sparse poly line_1 step + coeff_2 * z^2
    let t255 = circuit_add(t254, t1); // Eval sparse poly line_1 step + 1*z^3
    let t256 = circuit_mul(t251, t4); // Eval sparse poly line_1 step coeff_6 * z^6
    let t257 = circuit_add(t255, t256); // Eval sparse poly line_1 step + coeff_6 * z^6
    let t258 = circuit_mul(t252, t6); // Eval sparse poly line_1 step coeff_8 * z^8
    let t259 = circuit_add(t257, t258); // Eval sparse poly line_1 step + coeff_8 * z^8
    let t260 = circuit_mul(t198, t259); // Mul (f^4 * (Π(i,k) (line_i,k(z)))^2) * line_i+1_1(z)
    let t261 = circuit_mul(in18, in30); // Eval R step coeff_1 * z^1
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
    let t66 = circuit_mul(t63, t0); // Eval sparse poly line_0 step coeff_2 * z^2
    let t67 = circuit_add(t61, t66); // Eval sparse poly line_0 step + coeff_2 * z^2
    let t68 = circuit_add(t67, t1); // Eval sparse poly line_0 step + 1*z^3
    let t69 = circuit_mul(t64, t4); // Eval sparse poly line_0 step coeff_6 * z^6
    let t70 = circuit_add(t68, t69); // Eval sparse poly line_0 step + coeff_6 * z^6
    let t71 = circuit_mul(t65, t6); // Eval sparse poly line_0 step coeff_8 * z^8
    let t72 = circuit_add(t70, t71); // Eval sparse poly line_0 step + coeff_8 * z^8
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
    let t128 = circuit_mul(t125, t0); // Eval sparse poly line_1 step coeff_2 * z^2
    let t129 = circuit_add(t123, t128); // Eval sparse poly line_1 step + coeff_2 * z^2
    let t130 = circuit_add(t129, t1); // Eval sparse poly line_1 step + 1*z^3
    let t131 = circuit_mul(t126, t4); // Eval sparse poly line_1 step coeff_6 * z^6
    let t132 = circuit_add(t130, t131); // Eval sparse poly line_1 step + coeff_6 * z^6
    let t133 = circuit_mul(t127, t6); // Eval sparse poly line_1 step coeff_8 * z^8
    let t134 = circuit_add(t132, t133); // Eval sparse poly line_1 step + coeff_8 * z^8
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
    let t190 = circuit_mul(t187, t0); // Eval sparse poly line_2 step coeff_2 * z^2
    let t191 = circuit_add(t185, t190); // Eval sparse poly line_2 step + coeff_2 * z^2
    let t192 = circuit_add(t191, t1); // Eval sparse poly line_2 step + 1*z^3
    let t193 = circuit_mul(t188, t4); // Eval sparse poly line_2 step coeff_6 * z^6
    let t194 = circuit_add(t192, t193); // Eval sparse poly line_2 step + coeff_6 * z^6
    let t195 = circuit_mul(t189, t6); // Eval sparse poly line_2 step coeff_8 * z^8
    let t196 = circuit_add(t194, t195); // Eval sparse poly line_2 step + coeff_8 * z^8
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
    let t253 = circuit_mul(t250, t0); // Eval sparse poly line_0 step coeff_2 * z^2
    let t254 = circuit_add(t248, t253); // Eval sparse poly line_0 step + coeff_2 * z^2
    let t255 = circuit_add(t254, t1); // Eval sparse poly line_0 step + 1*z^3
    let t256 = circuit_mul(t251, t4); // Eval sparse poly line_0 step coeff_6 * z^6
    let t257 = circuit_add(t255, t256); // Eval sparse poly line_0 step + coeff_6 * z^6
    let t258 = circuit_mul(t252, t6); // Eval sparse poly line_0 step coeff_8 * z^8
    let t259 = circuit_add(t257, t258); // Eval sparse poly line_0 step + coeff_8 * z^8
    let t260 = circuit_mul(t198, t259); // Mul (f^4 * (Π(i,k) (line_i,k(z)))^2) * line_i+1_0(z)
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
    let t315 = circuit_mul(t312, t0); // Eval sparse poly line_1 step coeff_2 * z^2
    let t316 = circuit_add(t310, t315); // Eval sparse poly line_1 step + coeff_2 * z^2
    let t317 = circuit_add(t316, t1); // Eval sparse poly line_1 step + 1*z^3
    let t318 = circuit_mul(t313, t4); // Eval sparse poly line_1 step coeff_6 * z^6
    let t319 = circuit_add(t317, t318); // Eval sparse poly line_1 step + coeff_6 * z^6
    let t320 = circuit_mul(t314, t6); // Eval sparse poly line_1 step coeff_8 * z^8
    let t321 = circuit_add(t319, t320); // Eval sparse poly line_1 step + coeff_8 * z^8
    let t322 = circuit_mul(t260, t321); // Mul (f^4 * (Π(i,k) (line_i,k(z)))^2) * line_i+1_1(z)
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
    let t377 = circuit_mul(t374, t0); // Eval sparse poly line_2 step coeff_2 * z^2
    let t378 = circuit_add(t372, t377); // Eval sparse poly line_2 step + coeff_2 * z^2
    let t379 = circuit_add(t378, t1); // Eval sparse poly line_2 step + 1*z^3
    let t380 = circuit_mul(t375, t4); // Eval sparse poly line_2 step coeff_6 * z^6
    let t381 = circuit_add(t379, t380); // Eval sparse poly line_2 step + coeff_6 * z^6
    let t382 = circuit_mul(t376, t6); // Eval sparse poly line_2 step coeff_8 * z^8
    let t383 = circuit_add(t381, t382); // Eval sparse poly line_2 step + coeff_8 * z^8
    let t384 = circuit_mul(t322, t383); // Mul (f^4 * (Π(i,k) (line_i,k(z)))^2) * line_i+1_2(z)
    let t385 = circuit_mul(in24, in36); // Eval R step coeff_1 * z^1
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
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x6, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
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
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x6, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
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
    let t106 = circuit_mul(t49, t0); // Eval sparse poly line_0p_1 step coeff_2 * z^2
    let t107 = circuit_add(t47, t106); // Eval sparse poly line_0p_1 step + coeff_2 * z^2
    let t108 = circuit_add(t107, t1); // Eval sparse poly line_0p_1 step + 1*z^3
    let t109 = circuit_mul(t50, t4); // Eval sparse poly line_0p_1 step coeff_6 * z^6
    let t110 = circuit_add(t108, t109); // Eval sparse poly line_0p_1 step + coeff_6 * z^6
    let t111 = circuit_mul(t51, t6); // Eval sparse poly line_0p_1 step coeff_8 * z^8
    let t112 = circuit_add(t110, t111); // Eval sparse poly line_0p_1 step + coeff_8 * z^8
    let t113 = circuit_mul(t11, t112);
    let t114 = circuit_mul(t103, t0); // Eval sparse poly line_0p_2 step coeff_2 * z^2
    let t115 = circuit_add(t101, t114); // Eval sparse poly line_0p_2 step + coeff_2 * z^2
    let t116 = circuit_add(t115, t1); // Eval sparse poly line_0p_2 step + 1*z^3
    let t117 = circuit_mul(t104, t4); // Eval sparse poly line_0p_2 step coeff_6 * z^6
    let t118 = circuit_add(t116, t117); // Eval sparse poly line_0p_2 step + coeff_6 * z^6
    let t119 = circuit_mul(t105, t6); // Eval sparse poly line_0p_2 step coeff_8 * z^8
    let t120 = circuit_add(t118, t119); // Eval sparse poly line_0p_2 step + coeff_8 * z^8
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
    let t216 = circuit_mul(t159, t0); // Eval sparse poly line_1p_1 step coeff_2 * z^2
    let t217 = circuit_add(t157, t216); // Eval sparse poly line_1p_1 step + coeff_2 * z^2
    let t218 = circuit_add(t217, t1); // Eval sparse poly line_1p_1 step + 1*z^3
    let t219 = circuit_mul(t160, t4); // Eval sparse poly line_1p_1 step coeff_6 * z^6
    let t220 = circuit_add(t218, t219); // Eval sparse poly line_1p_1 step + coeff_6 * z^6
    let t221 = circuit_mul(t161, t6); // Eval sparse poly line_1p_1 step coeff_8 * z^8
    let t222 = circuit_add(t220, t221); // Eval sparse poly line_1p_1 step + coeff_8 * z^8
    let t223 = circuit_mul(t121, t222);
    let t224 = circuit_mul(t213, t0); // Eval sparse poly line_1p_2 step coeff_2 * z^2
    let t225 = circuit_add(t211, t224); // Eval sparse poly line_1p_2 step + coeff_2 * z^2
    let t226 = circuit_add(t225, t1); // Eval sparse poly line_1p_2 step + 1*z^3
    let t227 = circuit_mul(t214, t4); // Eval sparse poly line_1p_2 step coeff_6 * z^6
    let t228 = circuit_add(t226, t227); // Eval sparse poly line_1p_2 step + coeff_6 * z^6
    let t229 = circuit_mul(t215, t6); // Eval sparse poly line_1p_2 step coeff_8 * z^8
    let t230 = circuit_add(t228, t229); // Eval sparse poly line_1p_2 step + coeff_8 * z^8
    let t231 = circuit_mul(t223, t230);
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
    let t106 = circuit_mul(t49, t0); // Eval sparse poly line_0p_1 step coeff_2 * z^2
    let t107 = circuit_add(t47, t106); // Eval sparse poly line_0p_1 step + coeff_2 * z^2
    let t108 = circuit_add(t107, t1); // Eval sparse poly line_0p_1 step + 1*z^3
    let t109 = circuit_mul(t50, t4); // Eval sparse poly line_0p_1 step coeff_6 * z^6
    let t110 = circuit_add(t108, t109); // Eval sparse poly line_0p_1 step + coeff_6 * z^6
    let t111 = circuit_mul(t51, t6); // Eval sparse poly line_0p_1 step coeff_8 * z^8
    let t112 = circuit_add(t110, t111); // Eval sparse poly line_0p_1 step + coeff_8 * z^8
    let t113 = circuit_mul(t11, t112);
    let t114 = circuit_mul(t103, t0); // Eval sparse poly line_0p_2 step coeff_2 * z^2
    let t115 = circuit_add(t101, t114); // Eval sparse poly line_0p_2 step + coeff_2 * z^2
    let t116 = circuit_add(t115, t1); // Eval sparse poly line_0p_2 step + 1*z^3
    let t117 = circuit_mul(t104, t4); // Eval sparse poly line_0p_2 step coeff_6 * z^6
    let t118 = circuit_add(t116, t117); // Eval sparse poly line_0p_2 step + coeff_6 * z^6
    let t119 = circuit_mul(t105, t6); // Eval sparse poly line_0p_2 step coeff_8 * z^8
    let t120 = circuit_add(t118, t119); // Eval sparse poly line_0p_2 step + coeff_8 * z^8
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
    let t216 = circuit_mul(t159, t0); // Eval sparse poly line_1p_1 step coeff_2 * z^2
    let t217 = circuit_add(t157, t216); // Eval sparse poly line_1p_1 step + coeff_2 * z^2
    let t218 = circuit_add(t217, t1); // Eval sparse poly line_1p_1 step + 1*z^3
    let t219 = circuit_mul(t160, t4); // Eval sparse poly line_1p_1 step coeff_6 * z^6
    let t220 = circuit_add(t218, t219); // Eval sparse poly line_1p_1 step + coeff_6 * z^6
    let t221 = circuit_mul(t161, t6); // Eval sparse poly line_1p_1 step coeff_8 * z^8
    let t222 = circuit_add(t220, t221); // Eval sparse poly line_1p_1 step + coeff_8 * z^8
    let t223 = circuit_mul(t121, t222);
    let t224 = circuit_mul(t213, t0); // Eval sparse poly line_1p_2 step coeff_2 * z^2
    let t225 = circuit_add(t211, t224); // Eval sparse poly line_1p_2 step + coeff_2 * z^2
    let t226 = circuit_add(t225, t1); // Eval sparse poly line_1p_2 step + 1*z^3
    let t227 = circuit_mul(t214, t4); // Eval sparse poly line_1p_2 step coeff_6 * z^6
    let t228 = circuit_add(t226, t227); // Eval sparse poly line_1p_2 step + coeff_6 * z^6
    let t229 = circuit_mul(t215, t6); // Eval sparse poly line_1p_2 step coeff_8 * z^8
    let t230 = circuit_add(t228, t229); // Eval sparse poly line_1p_2 step + coeff_8 * z^8
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
    let t326 = circuit_mul(t269, t0); // Eval sparse poly line_2p_1 step coeff_2 * z^2
    let t327 = circuit_add(t267, t326); // Eval sparse poly line_2p_1 step + coeff_2 * z^2
    let t328 = circuit_add(t327, t1); // Eval sparse poly line_2p_1 step + 1*z^3
    let t329 = circuit_mul(t270, t4); // Eval sparse poly line_2p_1 step coeff_6 * z^6
    let t330 = circuit_add(t328, t329); // Eval sparse poly line_2p_1 step + coeff_6 * z^6
    let t331 = circuit_mul(t271, t6); // Eval sparse poly line_2p_1 step coeff_8 * z^8
    let t332 = circuit_add(t330, t331); // Eval sparse poly line_2p_1 step + coeff_8 * z^8
    let t333 = circuit_mul(t231, t332);
    let t334 = circuit_mul(t323, t0); // Eval sparse poly line_2p_2 step coeff_2 * z^2
    let t335 = circuit_add(t321, t334); // Eval sparse poly line_2p_2 step + coeff_2 * z^2
    let t336 = circuit_add(t335, t1); // Eval sparse poly line_2p_2 step + 1*z^3
    let t337 = circuit_mul(t324, t4); // Eval sparse poly line_2p_2 step coeff_6 * z^6
    let t338 = circuit_add(t336, t337); // Eval sparse poly line_2p_2 step + coeff_6 * z^6
    let t339 = circuit_mul(t325, t6); // Eval sparse poly line_2p_2 step coeff_8 * z^8
    let t340 = circuit_add(t338, t339); // Eval sparse poly line_2p_2 step + coeff_8 * z^8
    let t341 = circuit_mul(t333, t340);
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
    let t86 = circuit_sub(in2, t85); // Fp2 Inv y imag part end
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
    let t128 = circuit_mul(t66, t0); // Eval sparse poly line_0p_1 step coeff_2 * z^2
    let t129 = circuit_add(t64, t128); // Eval sparse poly line_0p_1 step + coeff_2 * z^2
    let t130 = circuit_add(t129, t1); // Eval sparse poly line_0p_1 step + 1*z^3
    let t131 = circuit_mul(t67, t4); // Eval sparse poly line_0p_1 step coeff_6 * z^6
    let t132 = circuit_add(t130, t131); // Eval sparse poly line_0p_1 step + coeff_6 * z^6
    let t133 = circuit_mul(t68, t6); // Eval sparse poly line_0p_1 step coeff_8 * z^8
    let t134 = circuit_add(t132, t133); // Eval sparse poly line_0p_1 step + coeff_8 * z^8
    let t135 = circuit_mul(t33, t134);
    let t136 = circuit_mul(t106, t0); // Eval sparse poly line_0p_2 step coeff_2 * z^2
    let t137 = circuit_add(t104, t136); // Eval sparse poly line_0p_2 step + coeff_2 * z^2
    let t138 = circuit_add(t137, t1); // Eval sparse poly line_0p_2 step + 1*z^3
    let t139 = circuit_mul(t107, t4); // Eval sparse poly line_0p_2 step coeff_6 * z^6
    let t140 = circuit_add(t138, t139); // Eval sparse poly line_0p_2 step + coeff_6 * z^6
    let t141 = circuit_mul(t108, t6); // Eval sparse poly line_0p_2 step coeff_8 * z^8
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
    let t196 = circuit_sub(in2, t195); // Fp2 Inv y imag part end
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
    let t238 = circuit_mul(t176, t0); // Eval sparse poly line_1p_1 step coeff_2 * z^2
    let t239 = circuit_add(t174, t238); // Eval sparse poly line_1p_1 step + coeff_2 * z^2
    let t240 = circuit_add(t239, t1); // Eval sparse poly line_1p_1 step + 1*z^3
    let t241 = circuit_mul(t177, t4); // Eval sparse poly line_1p_1 step coeff_6 * z^6
    let t242 = circuit_add(t240, t241); // Eval sparse poly line_1p_1 step + coeff_6 * z^6
    let t243 = circuit_mul(t178, t6); // Eval sparse poly line_1p_1 step coeff_8 * z^8
    let t244 = circuit_add(t242, t243); // Eval sparse poly line_1p_1 step + coeff_8 * z^8
    let t245 = circuit_mul(t143, t244);
    let t246 = circuit_mul(t216, t0); // Eval sparse poly line_1p_2 step coeff_2 * z^2
    let t247 = circuit_add(t214, t246); // Eval sparse poly line_1p_2 step + coeff_2 * z^2
    let t248 = circuit_add(t247, t1); // Eval sparse poly line_1p_2 step + 1*z^3
    let t249 = circuit_mul(t217, t4); // Eval sparse poly line_1p_2 step coeff_6 * z^6
    let t250 = circuit_add(t248, t249); // Eval sparse poly line_1p_2 step + coeff_6 * z^6
    let t251 = circuit_mul(t218, t6); // Eval sparse poly line_1p_2 step coeff_8 * z^8
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

    let mut circuit_inputs = (t116, t117, t126, t127, t226, t227, t236, t237, t255, t31,)
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x6, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
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
    let t86 = circuit_sub(in2, t85); // Fp2 Inv y imag part end
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
    let t128 = circuit_mul(t66, t0); // Eval sparse poly line_0p_1 step coeff_2 * z^2
    let t129 = circuit_add(t64, t128); // Eval sparse poly line_0p_1 step + coeff_2 * z^2
    let t130 = circuit_add(t129, t1); // Eval sparse poly line_0p_1 step + 1*z^3
    let t131 = circuit_mul(t67, t4); // Eval sparse poly line_0p_1 step coeff_6 * z^6
    let t132 = circuit_add(t130, t131); // Eval sparse poly line_0p_1 step + coeff_6 * z^6
    let t133 = circuit_mul(t68, t6); // Eval sparse poly line_0p_1 step coeff_8 * z^8
    let t134 = circuit_add(t132, t133); // Eval sparse poly line_0p_1 step + coeff_8 * z^8
    let t135 = circuit_mul(t33, t134);
    let t136 = circuit_mul(t106, t0); // Eval sparse poly line_0p_2 step coeff_2 * z^2
    let t137 = circuit_add(t104, t136); // Eval sparse poly line_0p_2 step + coeff_2 * z^2
    let t138 = circuit_add(t137, t1); // Eval sparse poly line_0p_2 step + 1*z^3
    let t139 = circuit_mul(t107, t4); // Eval sparse poly line_0p_2 step coeff_6 * z^6
    let t140 = circuit_add(t138, t139); // Eval sparse poly line_0p_2 step + coeff_6 * z^6
    let t141 = circuit_mul(t108, t6); // Eval sparse poly line_0p_2 step coeff_8 * z^8
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
    let t196 = circuit_sub(in2, t195); // Fp2 Inv y imag part end
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
    let t238 = circuit_mul(t176, t0); // Eval sparse poly line_1p_1 step coeff_2 * z^2
    let t239 = circuit_add(t174, t238); // Eval sparse poly line_1p_1 step + coeff_2 * z^2
    let t240 = circuit_add(t239, t1); // Eval sparse poly line_1p_1 step + 1*z^3
    let t241 = circuit_mul(t177, t4); // Eval sparse poly line_1p_1 step coeff_6 * z^6
    let t242 = circuit_add(t240, t241); // Eval sparse poly line_1p_1 step + coeff_6 * z^6
    let t243 = circuit_mul(t178, t6); // Eval sparse poly line_1p_1 step coeff_8 * z^8
    let t244 = circuit_add(t242, t243); // Eval sparse poly line_1p_1 step + coeff_8 * z^8
    let t245 = circuit_mul(t143, t244);
    let t246 = circuit_mul(t216, t0); // Eval sparse poly line_1p_2 step coeff_2 * z^2
    let t247 = circuit_add(t214, t246); // Eval sparse poly line_1p_2 step + coeff_2 * z^2
    let t248 = circuit_add(t247, t1); // Eval sparse poly line_1p_2 step + 1*z^3
    let t249 = circuit_mul(t217, t4); // Eval sparse poly line_1p_2 step coeff_6 * z^6
    let t250 = circuit_add(t248, t249); // Eval sparse poly line_1p_2 step + coeff_6 * z^6
    let t251 = circuit_mul(t218, t6); // Eval sparse poly line_1p_2 step coeff_8 * z^8
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
    let t306 = circuit_sub(in2, t305); // Fp2 Inv y imag part end
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
    let t348 = circuit_mul(t286, t0); // Eval sparse poly line_2p_1 step coeff_2 * z^2
    let t349 = circuit_add(t284, t348); // Eval sparse poly line_2p_1 step + coeff_2 * z^2
    let t350 = circuit_add(t349, t1); // Eval sparse poly line_2p_1 step + 1*z^3
    let t351 = circuit_mul(t287, t4); // Eval sparse poly line_2p_1 step coeff_6 * z^6
    let t352 = circuit_add(t350, t351); // Eval sparse poly line_2p_1 step + coeff_6 * z^6
    let t353 = circuit_mul(t288, t6); // Eval sparse poly line_2p_1 step coeff_8 * z^8
    let t354 = circuit_add(t352, t353); // Eval sparse poly line_2p_1 step + coeff_8 * z^8
    let t355 = circuit_mul(t253, t354);
    let t356 = circuit_mul(t326, t0); // Eval sparse poly line_2p_2 step coeff_2 * z^2
    let t357 = circuit_add(t324, t356); // Eval sparse poly line_2p_2 step + coeff_2 * z^2
    let t358 = circuit_add(t357, t1); // Eval sparse poly line_2p_2 step + 1*z^3
    let t359 = circuit_mul(t327, t4); // Eval sparse poly line_2p_2 step coeff_6 * z^6
    let t360 = circuit_add(t358, t359); // Eval sparse poly line_2p_2 step + coeff_6 * z^6
    let t361 = circuit_mul(t328, t6); // Eval sparse poly line_2p_2 step coeff_8 * z^8
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
        t116, t117, t126, t127, t226, t227, t236, t237, t336, t337, t346, t347, t365, t31,
    )
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x6, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
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
    let t68 = circuit_mul(t62, in32); // Eval sparse poly line_0 step coeff_1 * z^1
    let t69 = circuit_add(in4, t68); // Eval sparse poly line_0 step + coeff_1 * z^1
    let t70 = circuit_mul(t65, t1); // Eval sparse poly line_0 step coeff_3 * z^3
    let t71 = circuit_add(t69, t70); // Eval sparse poly line_0 step + coeff_3 * z^3
    let t72 = circuit_mul(t66, t5); // Eval sparse poly line_0 step coeff_7 * z^7
    let t73 = circuit_add(t71, t72); // Eval sparse poly line_0 step + coeff_7 * z^7
    let t74 = circuit_mul(t67, t7); // Eval sparse poly line_0 step coeff_9 * z^9
    let t75 = circuit_add(t73, t74); // Eval sparse poly line_0 step + coeff_9 * z^9
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
    let t133 = circuit_mul(t127, in32); // Eval sparse poly line_1 step coeff_1 * z^1
    let t134 = circuit_add(in4, t133); // Eval sparse poly line_1 step + coeff_1 * z^1
    let t135 = circuit_mul(t130, t1); // Eval sparse poly line_1 step coeff_3 * z^3
    let t136 = circuit_add(t134, t135); // Eval sparse poly line_1 step + coeff_3 * z^3
    let t137 = circuit_mul(t131, t5); // Eval sparse poly line_1 step coeff_7 * z^7
    let t138 = circuit_add(t136, t137); // Eval sparse poly line_1 step + coeff_7 * z^7
    let t139 = circuit_mul(t132, t7); // Eval sparse poly line_1 step coeff_9 * z^9
    let t140 = circuit_add(t138, t139); // Eval sparse poly line_1 step + coeff_9 * z^9
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
    let t199 = circuit_mul(t193, in32); // Eval sparse poly line_0 step coeff_1 * z^1
    let t200 = circuit_add(in4, t199); // Eval sparse poly line_0 step + coeff_1 * z^1
    let t201 = circuit_mul(t196, t1); // Eval sparse poly line_0 step coeff_3 * z^3
    let t202 = circuit_add(t200, t201); // Eval sparse poly line_0 step + coeff_3 * z^3
    let t203 = circuit_mul(t197, t5); // Eval sparse poly line_0 step coeff_7 * z^7
    let t204 = circuit_add(t202, t203); // Eval sparse poly line_0 step + coeff_7 * z^7
    let t205 = circuit_mul(t198, t7); // Eval sparse poly line_0 step coeff_9 * z^9
    let t206 = circuit_add(t204, t205); // Eval sparse poly line_0 step + coeff_9 * z^9
    let t207 = circuit_mul(t142, t206); // Mul (f^4 * (Π(i,k) (line_i,k(z)))^2) * line_i+1_0(z)
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
    let t264 = circuit_mul(t258, in32); // Eval sparse poly line_1 step coeff_1 * z^1
    let t265 = circuit_add(in4, t264); // Eval sparse poly line_1 step + coeff_1 * z^1
    let t266 = circuit_mul(t261, t1); // Eval sparse poly line_1 step coeff_3 * z^3
    let t267 = circuit_add(t265, t266); // Eval sparse poly line_1 step + coeff_3 * z^3
    let t268 = circuit_mul(t262, t5); // Eval sparse poly line_1 step coeff_7 * z^7
    let t269 = circuit_add(t267, t268); // Eval sparse poly line_1 step + coeff_7 * z^7
    let t270 = circuit_mul(t263, t7); // Eval sparse poly line_1 step coeff_9 * z^9
    let t271 = circuit_add(t269, t270); // Eval sparse poly line_1 step + coeff_9 * z^9
    let t272 = circuit_mul(t207, t271); // Mul (f^4 * (Π(i,k) (line_i,k(z)))^2) * line_i+1_1(z)
    let t273 = circuit_mul(in20, in32); // Eval R step coeff_1 * z^1
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
    let t68 = circuit_mul(t62, in38); // Eval sparse poly line_0 step coeff_1 * z^1
    let t69 = circuit_add(in4, t68); // Eval sparse poly line_0 step + coeff_1 * z^1
    let t70 = circuit_mul(t65, t1); // Eval sparse poly line_0 step coeff_3 * z^3
    let t71 = circuit_add(t69, t70); // Eval sparse poly line_0 step + coeff_3 * z^3
    let t72 = circuit_mul(t66, t5); // Eval sparse poly line_0 step coeff_7 * z^7
    let t73 = circuit_add(t71, t72); // Eval sparse poly line_0 step + coeff_7 * z^7
    let t74 = circuit_mul(t67, t7); // Eval sparse poly line_0 step coeff_9 * z^9
    let t75 = circuit_add(t73, t74); // Eval sparse poly line_0 step + coeff_9 * z^9
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
    let t133 = circuit_mul(t127, in38); // Eval sparse poly line_1 step coeff_1 * z^1
    let t134 = circuit_add(in4, t133); // Eval sparse poly line_1 step + coeff_1 * z^1
    let t135 = circuit_mul(t130, t1); // Eval sparse poly line_1 step coeff_3 * z^3
    let t136 = circuit_add(t134, t135); // Eval sparse poly line_1 step + coeff_3 * z^3
    let t137 = circuit_mul(t131, t5); // Eval sparse poly line_1 step coeff_7 * z^7
    let t138 = circuit_add(t136, t137); // Eval sparse poly line_1 step + coeff_7 * z^7
    let t139 = circuit_mul(t132, t7); // Eval sparse poly line_1 step coeff_9 * z^9
    let t140 = circuit_add(t138, t139); // Eval sparse poly line_1 step + coeff_9 * z^9
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
    let t198 = circuit_mul(t192, in38); // Eval sparse poly line_2 step coeff_1 * z^1
    let t199 = circuit_add(in4, t198); // Eval sparse poly line_2 step + coeff_1 * z^1
    let t200 = circuit_mul(t195, t1); // Eval sparse poly line_2 step coeff_3 * z^3
    let t201 = circuit_add(t199, t200); // Eval sparse poly line_2 step + coeff_3 * z^3
    let t202 = circuit_mul(t196, t5); // Eval sparse poly line_2 step coeff_7 * z^7
    let t203 = circuit_add(t201, t202); // Eval sparse poly line_2 step + coeff_7 * z^7
    let t204 = circuit_mul(t197, t7); // Eval sparse poly line_2 step coeff_9 * z^9
    let t205 = circuit_add(t203, t204); // Eval sparse poly line_2 step + coeff_9 * z^9
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
    let t264 = circuit_mul(t258, in38); // Eval sparse poly line_0 step coeff_1 * z^1
    let t265 = circuit_add(in4, t264); // Eval sparse poly line_0 step + coeff_1 * z^1
    let t266 = circuit_mul(t261, t1); // Eval sparse poly line_0 step coeff_3 * z^3
    let t267 = circuit_add(t265, t266); // Eval sparse poly line_0 step + coeff_3 * z^3
    let t268 = circuit_mul(t262, t5); // Eval sparse poly line_0 step coeff_7 * z^7
    let t269 = circuit_add(t267, t268); // Eval sparse poly line_0 step + coeff_7 * z^7
    let t270 = circuit_mul(t263, t7); // Eval sparse poly line_0 step coeff_9 * z^9
    let t271 = circuit_add(t269, t270); // Eval sparse poly line_0 step + coeff_9 * z^9
    let t272 = circuit_mul(t207, t271); // Mul (f^4 * (Π(i,k) (line_i,k(z)))^2) * line_i+1_0(z)
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
    let t329 = circuit_mul(t323, in38); // Eval sparse poly line_1 step coeff_1 * z^1
    let t330 = circuit_add(in4, t329); // Eval sparse poly line_1 step + coeff_1 * z^1
    let t331 = circuit_mul(t326, t1); // Eval sparse poly line_1 step coeff_3 * z^3
    let t332 = circuit_add(t330, t331); // Eval sparse poly line_1 step + coeff_3 * z^3
    let t333 = circuit_mul(t327, t5); // Eval sparse poly line_1 step coeff_7 * z^7
    let t334 = circuit_add(t332, t333); // Eval sparse poly line_1 step + coeff_7 * z^7
    let t335 = circuit_mul(t328, t7); // Eval sparse poly line_1 step coeff_9 * z^9
    let t336 = circuit_add(t334, t335); // Eval sparse poly line_1 step + coeff_9 * z^9
    let t337 = circuit_mul(t272, t336); // Mul (f^4 * (Π(i,k) (line_i,k(z)))^2) * line_i+1_1(z)
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
    let t394 = circuit_mul(t388, in38); // Eval sparse poly line_2 step coeff_1 * z^1
    let t395 = circuit_add(in4, t394); // Eval sparse poly line_2 step + coeff_1 * z^1
    let t396 = circuit_mul(t391, t1); // Eval sparse poly line_2 step coeff_3 * z^3
    let t397 = circuit_add(t395, t396); // Eval sparse poly line_2 step + coeff_3 * z^3
    let t398 = circuit_mul(t392, t5); // Eval sparse poly line_2 step coeff_7 * z^7
    let t399 = circuit_add(t397, t398); // Eval sparse poly line_2 step + coeff_7 * z^7
    let t400 = circuit_mul(t393, t7); // Eval sparse poly line_2 step coeff_9 * z^9
    let t401 = circuit_add(t399, t400); // Eval sparse poly line_2 step + coeff_9 * z^9
    let t402 = circuit_mul(t337, t401); // Mul (f^4 * (Π(i,k) (line_i,k(z)))^2) * line_i+1_2(z)
    let t403 = circuit_mul(in26, in38); // Eval R step coeff_1 * z^1
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
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x6, 0x0, 0x0, 0x0]);
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
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x6, 0x0, 0x0, 0x0]);
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
    let t110 = circuit_mul(t48, in38); // Eval sparse poly line_0p_1 step coeff_1 * z^1
    let t111 = circuit_add(in2, t110); // Eval sparse poly line_0p_1 step + coeff_1 * z^1
    let t112 = circuit_mul(t51, t1); // Eval sparse poly line_0p_1 step coeff_3 * z^3
    let t113 = circuit_add(t111, t112); // Eval sparse poly line_0p_1 step + coeff_3 * z^3
    let t114 = circuit_mul(t52, t5); // Eval sparse poly line_0p_1 step coeff_7 * z^7
    let t115 = circuit_add(t113, t114); // Eval sparse poly line_0p_1 step + coeff_7 * z^7
    let t116 = circuit_mul(t53, t7); // Eval sparse poly line_0p_1 step coeff_9 * z^9
    let t117 = circuit_add(t115, t116); // Eval sparse poly line_0p_1 step + coeff_9 * z^9
    let t118 = circuit_mul(t11, t117);
    let t119 = circuit_mul(t104, in38); // Eval sparse poly line_0p_2 step coeff_1 * z^1
    let t120 = circuit_add(in2, t119); // Eval sparse poly line_0p_2 step + coeff_1 * z^1
    let t121 = circuit_mul(t107, t1); // Eval sparse poly line_0p_2 step coeff_3 * z^3
    let t122 = circuit_add(t120, t121); // Eval sparse poly line_0p_2 step + coeff_3 * z^3
    let t123 = circuit_mul(t108, t5); // Eval sparse poly line_0p_2 step coeff_7 * z^7
    let t124 = circuit_add(t122, t123); // Eval sparse poly line_0p_2 step + coeff_7 * z^7
    let t125 = circuit_mul(t109, t7); // Eval sparse poly line_0p_2 step coeff_9 * z^9
    let t126 = circuit_add(t124, t125); // Eval sparse poly line_0p_2 step + coeff_9 * z^9
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
    let t226 = circuit_mul(t164, in38); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t227 = circuit_add(in2, t226); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t228 = circuit_mul(t167, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t229 = circuit_add(t227, t228); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t230 = circuit_mul(t168, t5); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t231 = circuit_add(t229, t230); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t232 = circuit_mul(t169, t7); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t233 = circuit_add(t231, t232); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t234 = circuit_mul(t127, t233);
    let t235 = circuit_mul(t220, in38); // Eval sparse poly line_1p_2 step coeff_1 * z^1
    let t236 = circuit_add(in2, t235); // Eval sparse poly line_1p_2 step + coeff_1 * z^1
    let t237 = circuit_mul(t223, t1); // Eval sparse poly line_1p_2 step coeff_3 * z^3
    let t238 = circuit_add(t236, t237); // Eval sparse poly line_1p_2 step + coeff_3 * z^3
    let t239 = circuit_mul(t224, t5); // Eval sparse poly line_1p_2 step coeff_7 * z^7
    let t240 = circuit_add(t238, t239); // Eval sparse poly line_1p_2 step + coeff_7 * z^7
    let t241 = circuit_mul(t225, t7); // Eval sparse poly line_1p_2 step coeff_9 * z^9
    let t242 = circuit_add(t240, t241); // Eval sparse poly line_1p_2 step + coeff_9 * z^9
    let t243 = circuit_mul(t234, t242);
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
    let t110 = circuit_mul(t48, in48); // Eval sparse poly line_0p_1 step coeff_1 * z^1
    let t111 = circuit_add(in2, t110); // Eval sparse poly line_0p_1 step + coeff_1 * z^1
    let t112 = circuit_mul(t51, t1); // Eval sparse poly line_0p_1 step coeff_3 * z^3
    let t113 = circuit_add(t111, t112); // Eval sparse poly line_0p_1 step + coeff_3 * z^3
    let t114 = circuit_mul(t52, t5); // Eval sparse poly line_0p_1 step coeff_7 * z^7
    let t115 = circuit_add(t113, t114); // Eval sparse poly line_0p_1 step + coeff_7 * z^7
    let t116 = circuit_mul(t53, t7); // Eval sparse poly line_0p_1 step coeff_9 * z^9
    let t117 = circuit_add(t115, t116); // Eval sparse poly line_0p_1 step + coeff_9 * z^9
    let t118 = circuit_mul(t11, t117);
    let t119 = circuit_mul(t104, in48); // Eval sparse poly line_0p_2 step coeff_1 * z^1
    let t120 = circuit_add(in2, t119); // Eval sparse poly line_0p_2 step + coeff_1 * z^1
    let t121 = circuit_mul(t107, t1); // Eval sparse poly line_0p_2 step coeff_3 * z^3
    let t122 = circuit_add(t120, t121); // Eval sparse poly line_0p_2 step + coeff_3 * z^3
    let t123 = circuit_mul(t108, t5); // Eval sparse poly line_0p_2 step coeff_7 * z^7
    let t124 = circuit_add(t122, t123); // Eval sparse poly line_0p_2 step + coeff_7 * z^7
    let t125 = circuit_mul(t109, t7); // Eval sparse poly line_0p_2 step coeff_9 * z^9
    let t126 = circuit_add(t124, t125); // Eval sparse poly line_0p_2 step + coeff_9 * z^9
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
    let t226 = circuit_mul(t164, in48); // Eval sparse poly line_1p_1 step coeff_1 * z^1
    let t227 = circuit_add(in2, t226); // Eval sparse poly line_1p_1 step + coeff_1 * z^1
    let t228 = circuit_mul(t167, t1); // Eval sparse poly line_1p_1 step coeff_3 * z^3
    let t229 = circuit_add(t227, t228); // Eval sparse poly line_1p_1 step + coeff_3 * z^3
    let t230 = circuit_mul(t168, t5); // Eval sparse poly line_1p_1 step coeff_7 * z^7
    let t231 = circuit_add(t229, t230); // Eval sparse poly line_1p_1 step + coeff_7 * z^7
    let t232 = circuit_mul(t169, t7); // Eval sparse poly line_1p_1 step coeff_9 * z^9
    let t233 = circuit_add(t231, t232); // Eval sparse poly line_1p_1 step + coeff_9 * z^9
    let t234 = circuit_mul(t127, t233);
    let t235 = circuit_mul(t220, in48); // Eval sparse poly line_1p_2 step coeff_1 * z^1
    let t236 = circuit_add(in2, t235); // Eval sparse poly line_1p_2 step + coeff_1 * z^1
    let t237 = circuit_mul(t223, t1); // Eval sparse poly line_1p_2 step coeff_3 * z^3
    let t238 = circuit_add(t236, t237); // Eval sparse poly line_1p_2 step + coeff_3 * z^3
    let t239 = circuit_mul(t224, t5); // Eval sparse poly line_1p_2 step coeff_7 * z^7
    let t240 = circuit_add(t238, t239); // Eval sparse poly line_1p_2 step + coeff_7 * z^7
    let t241 = circuit_mul(t225, t7); // Eval sparse poly line_1p_2 step coeff_9 * z^9
    let t242 = circuit_add(t240, t241); // Eval sparse poly line_1p_2 step + coeff_9 * z^9
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
    let t342 = circuit_mul(t280, in48); // Eval sparse poly line_2p_1 step coeff_1 * z^1
    let t343 = circuit_add(in2, t342); // Eval sparse poly line_2p_1 step + coeff_1 * z^1
    let t344 = circuit_mul(t283, t1); // Eval sparse poly line_2p_1 step coeff_3 * z^3
    let t345 = circuit_add(t343, t344); // Eval sparse poly line_2p_1 step + coeff_3 * z^3
    let t346 = circuit_mul(t284, t5); // Eval sparse poly line_2p_1 step coeff_7 * z^7
    let t347 = circuit_add(t345, t346); // Eval sparse poly line_2p_1 step + coeff_7 * z^7
    let t348 = circuit_mul(t285, t7); // Eval sparse poly line_2p_1 step coeff_9 * z^9
    let t349 = circuit_add(t347, t348); // Eval sparse poly line_2p_1 step + coeff_9 * z^9
    let t350 = circuit_mul(t243, t349);
    let t351 = circuit_mul(t336, in48); // Eval sparse poly line_2p_2 step coeff_1 * z^1
    let t352 = circuit_add(in2, t351); // Eval sparse poly line_2p_2 step + coeff_1 * z^1
    let t353 = circuit_mul(t339, t1); // Eval sparse poly line_2p_2 step coeff_3 * z^3
    let t354 = circuit_add(t352, t353); // Eval sparse poly line_2p_2 step + coeff_3 * z^3
    let t355 = circuit_mul(t340, t5); // Eval sparse poly line_2p_2 step coeff_7 * z^7
    let t356 = circuit_add(t354, t355); // Eval sparse poly line_2p_2 step + coeff_7 * z^7
    let t357 = circuit_mul(t341, t7); // Eval sparse poly line_2p_2 step coeff_9 * z^9
    let t358 = circuit_add(t356, t357); // Eval sparse poly line_2p_2 step + coeff_9 * z^9
    let t359 = circuit_mul(t350, t358);
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
    let t193 = circuit_mul(in7, t165);
    let t194 = circuit_add(t162, t193);
    let t195 = circuit_mul(t194, in15);
    let t196 = circuit_mul(in7, t192);
    let t197 = circuit_add(t191, t196);
    let t198 = circuit_mul(t197, in14);
    let t199 = circuit_mul(t165, in15);
    let t200 = circuit_mul(t192, in14);
    let t201 = circuit_sub(t183, t147); // Fp2 sub coeff 0/1
    let t202 = circuit_sub(t184, t148); // Fp2 sub coeff 1/1
    let t203 = circuit_sub(t173, t145); // Fp2 sub coeff 0/1
    let t204 = circuit_sub(t174, t146); // Fp2 sub coeff 1/1
    let t205 = circuit_mul(t203, t203); // Fp2 Div x/y start : Fp2 Inv y start
    let t206 = circuit_mul(t204, t204);
    let t207 = circuit_add(t205, t206);
    let t208 = circuit_inverse(t207);
    let t209 = circuit_mul(t203, t208); // Fp2 Inv y real part end
    let t210 = circuit_mul(t204, t208);
    let t211 = circuit_sub(in6, t210); // Fp2 Inv y imag part end
    let t212 = circuit_mul(t201, t209); // Fp2 mul start
    let t213 = circuit_mul(t202, t211);
    let t214 = circuit_sub(t212, t213); // Fp2 mul real part end
    let t215 = circuit_mul(t201, t211);
    let t216 = circuit_mul(t202, t209);
    let t217 = circuit_add(t215, t216); // Fp2 mul imag part end
    let t218 = circuit_mul(t214, t173); // Fp2 mul start
    let t219 = circuit_mul(t217, t174);
    let t220 = circuit_sub(t218, t219); // Fp2 mul real part end
    let t221 = circuit_mul(t214, t174);
    let t222 = circuit_mul(t217, t173);
    let t223 = circuit_add(t221, t222); // Fp2 mul imag part end
    let t224 = circuit_sub(t220, t183); // Fp2 sub coeff 0/1
    let t225 = circuit_sub(t223, t184); // Fp2 sub coeff 1/1
    let t226 = circuit_mul(in7, t217);
    let t227 = circuit_add(t214, t226);
    let t228 = circuit_mul(t227, in15);
    let t229 = circuit_mul(in7, t225);
    let t230 = circuit_add(t224, t229);
    let t231 = circuit_mul(t230, in14);
    let t232 = circuit_mul(t217, in15);
    let t233 = circuit_mul(t225, in14);
    let t234 = circuit_sub(in6, in21);
    let t235 = circuit_sub(in6, in23);
    let t236 = circuit_mul(in20, in0); // Fp2 mul start
    let t237 = circuit_mul(t234, in1);
    let t238 = circuit_sub(t236, t237); // Fp2 mul real part end
    let t239 = circuit_mul(in20, in1);
    let t240 = circuit_mul(t234, in0);
    let t241 = circuit_add(t239, t240); // Fp2 mul imag part end
    let t242 = circuit_mul(in22, in2); // Fp2 mul start
    let t243 = circuit_mul(t235, in3);
    let t244 = circuit_sub(t242, t243); // Fp2 mul real part end
    let t245 = circuit_mul(in22, in3);
    let t246 = circuit_mul(t235, in2);
    let t247 = circuit_add(t245, t246); // Fp2 mul imag part end
    let t248 = circuit_mul(in20, in4); // Fp2 scalar mul coeff 0/1
    let t249 = circuit_mul(in21, in4); // Fp2 scalar mul coeff 1/1
    let t250 = circuit_mul(in22, in5); // Fp2 scalar mul coeff 0/1
    let t251 = circuit_mul(in23, in5); // Fp2 scalar mul coeff 1/1
    let t252 = circuit_sub(in28, t244); // Fp2 sub coeff 0/1
    let t253 = circuit_sub(in29, t247); // Fp2 sub coeff 1/1
    let t254 = circuit_sub(in26, t238); // Fp2 sub coeff 0/1
    let t255 = circuit_sub(in27, t241); // Fp2 sub coeff 1/1
    let t256 = circuit_mul(t254, t254); // Fp2 Div x/y start : Fp2 Inv y start
    let t257 = circuit_mul(t255, t255);
    let t258 = circuit_add(t256, t257);
    let t259 = circuit_inverse(t258);
    let t260 = circuit_mul(t254, t259); // Fp2 Inv y real part end
    let t261 = circuit_mul(t255, t259);
    let t262 = circuit_sub(in6, t261); // Fp2 Inv y imag part end
    let t263 = circuit_mul(t252, t260); // Fp2 mul start
    let t264 = circuit_mul(t253, t262);
    let t265 = circuit_sub(t263, t264); // Fp2 mul real part end
    let t266 = circuit_mul(t252, t262);
    let t267 = circuit_mul(t253, t260);
    let t268 = circuit_add(t266, t267); // Fp2 mul imag part end
    let t269 = circuit_add(t265, t268);
    let t270 = circuit_sub(t265, t268);
    let t271 = circuit_mul(t269, t270);
    let t272 = circuit_mul(t265, t268);
    let t273 = circuit_add(t272, t272);
    let t274 = circuit_add(in26, t238); // Fp2 add coeff 0/1
    let t275 = circuit_add(in27, t241); // Fp2 add coeff 1/1
    let t276 = circuit_sub(t271, t274); // Fp2 sub coeff 0/1
    let t277 = circuit_sub(t273, t275); // Fp2 sub coeff 1/1
    let t278 = circuit_sub(in26, t276); // Fp2 sub coeff 0/1
    let t279 = circuit_sub(in27, t277); // Fp2 sub coeff 1/1
    let t280 = circuit_mul(t265, t278); // Fp2 mul start
    let t281 = circuit_mul(t268, t279);
    let t282 = circuit_sub(t280, t281); // Fp2 mul real part end
    let t283 = circuit_mul(t265, t279);
    let t284 = circuit_mul(t268, t278);
    let t285 = circuit_add(t283, t284); // Fp2 mul imag part end
    let t286 = circuit_sub(t282, in28); // Fp2 sub coeff 0/1
    let t287 = circuit_sub(t285, in29); // Fp2 sub coeff 1/1
    let t288 = circuit_mul(t265, in26); // Fp2 mul start
    let t289 = circuit_mul(t268, in27);
    let t290 = circuit_sub(t288, t289); // Fp2 mul real part end
    let t291 = circuit_mul(t265, in27);
    let t292 = circuit_mul(t268, in26);
    let t293 = circuit_add(t291, t292); // Fp2 mul imag part end
    let t294 = circuit_sub(t290, in28); // Fp2 sub coeff 0/1
    let t295 = circuit_sub(t293, in29); // Fp2 sub coeff 1/1
    let t296 = circuit_mul(in7, t268);
    let t297 = circuit_add(t265, t296);
    let t298 = circuit_mul(t297, in25);
    let t299 = circuit_mul(in7, t295);
    let t300 = circuit_add(t294, t299);
    let t301 = circuit_mul(t300, in24);
    let t302 = circuit_mul(t268, in25);
    let t303 = circuit_mul(t295, in24);
    let t304 = circuit_sub(t286, t250); // Fp2 sub coeff 0/1
    let t305 = circuit_sub(t287, t251); // Fp2 sub coeff 1/1
    let t306 = circuit_sub(t276, t248); // Fp2 sub coeff 0/1
    let t307 = circuit_sub(t277, t249); // Fp2 sub coeff 1/1
    let t308 = circuit_mul(t306, t306); // Fp2 Div x/y start : Fp2 Inv y start
    let t309 = circuit_mul(t307, t307);
    let t310 = circuit_add(t308, t309);
    let t311 = circuit_inverse(t310);
    let t312 = circuit_mul(t306, t311); // Fp2 Inv y real part end
    let t313 = circuit_mul(t307, t311);
    let t314 = circuit_sub(in6, t313); // Fp2 Inv y imag part end
    let t315 = circuit_mul(t304, t312); // Fp2 mul start
    let t316 = circuit_mul(t305, t314);
    let t317 = circuit_sub(t315, t316); // Fp2 mul real part end
    let t318 = circuit_mul(t304, t314);
    let t319 = circuit_mul(t305, t312);
    let t320 = circuit_add(t318, t319); // Fp2 mul imag part end
    let t321 = circuit_mul(t317, t276); // Fp2 mul start
    let t322 = circuit_mul(t320, t277);
    let t323 = circuit_sub(t321, t322); // Fp2 mul real part end
    let t324 = circuit_mul(t317, t277);
    let t325 = circuit_mul(t320, t276);
    let t326 = circuit_add(t324, t325); // Fp2 mul imag part end
    let t327 = circuit_sub(t323, t286); // Fp2 sub coeff 0/1
    let t328 = circuit_sub(t326, t287); // Fp2 sub coeff 1/1
    let t329 = circuit_mul(in7, t320);
    let t330 = circuit_add(t317, t329);
    let t331 = circuit_mul(t330, in25);
    let t332 = circuit_mul(in7, t328);
    let t333 = circuit_add(t327, t332);
    let t334 = circuit_mul(t333, in24);
    let t335 = circuit_mul(t320, in25);
    let t336 = circuit_mul(t328, in24);
    let t337 = circuit_mul(t195, in56); // Eval sparse poly line_1 step coeff_1 * z^1
    let t338 = circuit_add(in5, t337); // Eval sparse poly line_1 step + coeff_1 * z^1
    let t339 = circuit_mul(t198, t1); // Eval sparse poly line_1 step coeff_3 * z^3
    let t340 = circuit_add(t338, t339); // Eval sparse poly line_1 step + coeff_3 * z^3
    let t341 = circuit_mul(t199, t5); // Eval sparse poly line_1 step coeff_7 * z^7
    let t342 = circuit_add(t340, t341); // Eval sparse poly line_1 step + coeff_7 * z^7
    let t343 = circuit_mul(t200, t7); // Eval sparse poly line_1 step coeff_9 * z^9
    let t344 = circuit_add(t342, t343); // Eval sparse poly line_1 step + coeff_9 * z^9
    let t345 = circuit_mul(in61, t344);
    let t346 = circuit_mul(t228, in56); // Eval sparse poly line_1 step coeff_1 * z^1
    let t347 = circuit_add(in5, t346); // Eval sparse poly line_1 step + coeff_1 * z^1
    let t348 = circuit_mul(t231, t1); // Eval sparse poly line_1 step coeff_3 * z^3
    let t349 = circuit_add(t347, t348); // Eval sparse poly line_1 step + coeff_3 * z^3
    let t350 = circuit_mul(t232, t5); // Eval sparse poly line_1 step coeff_7 * z^7
    let t351 = circuit_add(t349, t350); // Eval sparse poly line_1 step + coeff_7 * z^7
    let t352 = circuit_mul(t233, t7); // Eval sparse poly line_1 step coeff_9 * z^9
    let t353 = circuit_add(t351, t352); // Eval sparse poly line_1 step + coeff_9 * z^9
    let t354 = circuit_mul(t345, t353);
    let t355 = circuit_mul(t298, in56); // Eval sparse poly line_1 step coeff_1 * z^1
    let t356 = circuit_add(in5, t355); // Eval sparse poly line_1 step + coeff_1 * z^1
    let t357 = circuit_mul(t301, t1); // Eval sparse poly line_1 step coeff_3 * z^3
    let t358 = circuit_add(t356, t357); // Eval sparse poly line_1 step + coeff_3 * z^3
    let t359 = circuit_mul(t302, t5); // Eval sparse poly line_1 step coeff_7 * z^7
    let t360 = circuit_add(t358, t359); // Eval sparse poly line_1 step + coeff_7 * z^7
    let t361 = circuit_mul(t303, t7); // Eval sparse poly line_1 step coeff_9 * z^9
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
    let t220 = circuit_mul(in7, t192);
    let t221 = circuit_add(t189, t220);
    let t222 = circuit_mul(t221, in15);
    let t223 = circuit_mul(in7, t219);
    let t224 = circuit_add(t218, t223);
    let t225 = circuit_mul(t224, in14);
    let t226 = circuit_mul(t192, in15);
    let t227 = circuit_mul(t219, in14);
    let t228 = circuit_sub(t210, t174); // Fp2 sub coeff 0/1
    let t229 = circuit_sub(t211, t175); // Fp2 sub coeff 1/1
    let t230 = circuit_sub(t200, t172); // Fp2 sub coeff 0/1
    let t231 = circuit_sub(t201, t173); // Fp2 sub coeff 1/1
    let t232 = circuit_mul(t230, t230); // Fp2 Div x/y start : Fp2 Inv y start
    let t233 = circuit_mul(t231, t231);
    let t234 = circuit_add(t232, t233);
    let t235 = circuit_inverse(t234);
    let t236 = circuit_mul(t230, t235); // Fp2 Inv y real part end
    let t237 = circuit_mul(t231, t235);
    let t238 = circuit_sub(in6, t237); // Fp2 Inv y imag part end
    let t239 = circuit_mul(t228, t236); // Fp2 mul start
    let t240 = circuit_mul(t229, t238);
    let t241 = circuit_sub(t239, t240); // Fp2 mul real part end
    let t242 = circuit_mul(t228, t238);
    let t243 = circuit_mul(t229, t236);
    let t244 = circuit_add(t242, t243); // Fp2 mul imag part end
    let t245 = circuit_mul(t241, t200); // Fp2 mul start
    let t246 = circuit_mul(t244, t201);
    let t247 = circuit_sub(t245, t246); // Fp2 mul real part end
    let t248 = circuit_mul(t241, t201);
    let t249 = circuit_mul(t244, t200);
    let t250 = circuit_add(t248, t249); // Fp2 mul imag part end
    let t251 = circuit_sub(t247, t210); // Fp2 sub coeff 0/1
    let t252 = circuit_sub(t250, t211); // Fp2 sub coeff 1/1
    let t253 = circuit_mul(in7, t244);
    let t254 = circuit_add(t241, t253);
    let t255 = circuit_mul(t254, in15);
    let t256 = circuit_mul(in7, t252);
    let t257 = circuit_add(t251, t256);
    let t258 = circuit_mul(t257, in14);
    let t259 = circuit_mul(t244, in15);
    let t260 = circuit_mul(t252, in14);
    let t261 = circuit_sub(in6, in21);
    let t262 = circuit_sub(in6, in23);
    let t263 = circuit_mul(in20, in0); // Fp2 mul start
    let t264 = circuit_mul(t261, in1);
    let t265 = circuit_sub(t263, t264); // Fp2 mul real part end
    let t266 = circuit_mul(in20, in1);
    let t267 = circuit_mul(t261, in0);
    let t268 = circuit_add(t266, t267); // Fp2 mul imag part end
    let t269 = circuit_mul(in22, in2); // Fp2 mul start
    let t270 = circuit_mul(t262, in3);
    let t271 = circuit_sub(t269, t270); // Fp2 mul real part end
    let t272 = circuit_mul(in22, in3);
    let t273 = circuit_mul(t262, in2);
    let t274 = circuit_add(t272, t273); // Fp2 mul imag part end
    let t275 = circuit_mul(in20, in4); // Fp2 scalar mul coeff 0/1
    let t276 = circuit_mul(in21, in4); // Fp2 scalar mul coeff 1/1
    let t277 = circuit_mul(in22, in5); // Fp2 scalar mul coeff 0/1
    let t278 = circuit_mul(in23, in5); // Fp2 scalar mul coeff 1/1
    let t279 = circuit_sub(in28, t271); // Fp2 sub coeff 0/1
    let t280 = circuit_sub(in29, t274); // Fp2 sub coeff 1/1
    let t281 = circuit_sub(in26, t265); // Fp2 sub coeff 0/1
    let t282 = circuit_sub(in27, t268); // Fp2 sub coeff 1/1
    let t283 = circuit_mul(t281, t281); // Fp2 Div x/y start : Fp2 Inv y start
    let t284 = circuit_mul(t282, t282);
    let t285 = circuit_add(t283, t284);
    let t286 = circuit_inverse(t285);
    let t287 = circuit_mul(t281, t286); // Fp2 Inv y real part end
    let t288 = circuit_mul(t282, t286);
    let t289 = circuit_sub(in6, t288); // Fp2 Inv y imag part end
    let t290 = circuit_mul(t279, t287); // Fp2 mul start
    let t291 = circuit_mul(t280, t289);
    let t292 = circuit_sub(t290, t291); // Fp2 mul real part end
    let t293 = circuit_mul(t279, t289);
    let t294 = circuit_mul(t280, t287);
    let t295 = circuit_add(t293, t294); // Fp2 mul imag part end
    let t296 = circuit_add(t292, t295);
    let t297 = circuit_sub(t292, t295);
    let t298 = circuit_mul(t296, t297);
    let t299 = circuit_mul(t292, t295);
    let t300 = circuit_add(t299, t299);
    let t301 = circuit_add(in26, t265); // Fp2 add coeff 0/1
    let t302 = circuit_add(in27, t268); // Fp2 add coeff 1/1
    let t303 = circuit_sub(t298, t301); // Fp2 sub coeff 0/1
    let t304 = circuit_sub(t300, t302); // Fp2 sub coeff 1/1
    let t305 = circuit_sub(in26, t303); // Fp2 sub coeff 0/1
    let t306 = circuit_sub(in27, t304); // Fp2 sub coeff 1/1
    let t307 = circuit_mul(t292, t305); // Fp2 mul start
    let t308 = circuit_mul(t295, t306);
    let t309 = circuit_sub(t307, t308); // Fp2 mul real part end
    let t310 = circuit_mul(t292, t306);
    let t311 = circuit_mul(t295, t305);
    let t312 = circuit_add(t310, t311); // Fp2 mul imag part end
    let t313 = circuit_sub(t309, in28); // Fp2 sub coeff 0/1
    let t314 = circuit_sub(t312, in29); // Fp2 sub coeff 1/1
    let t315 = circuit_mul(t292, in26); // Fp2 mul start
    let t316 = circuit_mul(t295, in27);
    let t317 = circuit_sub(t315, t316); // Fp2 mul real part end
    let t318 = circuit_mul(t292, in27);
    let t319 = circuit_mul(t295, in26);
    let t320 = circuit_add(t318, t319); // Fp2 mul imag part end
    let t321 = circuit_sub(t317, in28); // Fp2 sub coeff 0/1
    let t322 = circuit_sub(t320, in29); // Fp2 sub coeff 1/1
    let t323 = circuit_mul(in7, t295);
    let t324 = circuit_add(t292, t323);
    let t325 = circuit_mul(t324, in25);
    let t326 = circuit_mul(in7, t322);
    let t327 = circuit_add(t321, t326);
    let t328 = circuit_mul(t327, in24);
    let t329 = circuit_mul(t295, in25);
    let t330 = circuit_mul(t322, in24);
    let t331 = circuit_sub(t313, t277); // Fp2 sub coeff 0/1
    let t332 = circuit_sub(t314, t278); // Fp2 sub coeff 1/1
    let t333 = circuit_sub(t303, t275); // Fp2 sub coeff 0/1
    let t334 = circuit_sub(t304, t276); // Fp2 sub coeff 1/1
    let t335 = circuit_mul(t333, t333); // Fp2 Div x/y start : Fp2 Inv y start
    let t336 = circuit_mul(t334, t334);
    let t337 = circuit_add(t335, t336);
    let t338 = circuit_inverse(t337);
    let t339 = circuit_mul(t333, t338); // Fp2 Inv y real part end
    let t340 = circuit_mul(t334, t338);
    let t341 = circuit_sub(in6, t340); // Fp2 Inv y imag part end
    let t342 = circuit_mul(t331, t339); // Fp2 mul start
    let t343 = circuit_mul(t332, t341);
    let t344 = circuit_sub(t342, t343); // Fp2 mul real part end
    let t345 = circuit_mul(t331, t341);
    let t346 = circuit_mul(t332, t339);
    let t347 = circuit_add(t345, t346); // Fp2 mul imag part end
    let t348 = circuit_mul(t344, t303); // Fp2 mul start
    let t349 = circuit_mul(t347, t304);
    let t350 = circuit_sub(t348, t349); // Fp2 mul real part end
    let t351 = circuit_mul(t344, t304);
    let t352 = circuit_mul(t347, t303);
    let t353 = circuit_add(t351, t352); // Fp2 mul imag part end
    let t354 = circuit_sub(t350, t313); // Fp2 sub coeff 0/1
    let t355 = circuit_sub(t353, t314); // Fp2 sub coeff 1/1
    let t356 = circuit_mul(in7, t347);
    let t357 = circuit_add(t344, t356);
    let t358 = circuit_mul(t357, in25);
    let t359 = circuit_mul(in7, t355);
    let t360 = circuit_add(t354, t359);
    let t361 = circuit_mul(t360, in24);
    let t362 = circuit_mul(t347, in25);
    let t363 = circuit_mul(t355, in24);
    let t364 = circuit_sub(in6, in31);
    let t365 = circuit_sub(in6, in33);
    let t366 = circuit_mul(in30, in0); // Fp2 mul start
    let t367 = circuit_mul(t364, in1);
    let t368 = circuit_sub(t366, t367); // Fp2 mul real part end
    let t369 = circuit_mul(in30, in1);
    let t370 = circuit_mul(t364, in0);
    let t371 = circuit_add(t369, t370); // Fp2 mul imag part end
    let t372 = circuit_mul(in32, in2); // Fp2 mul start
    let t373 = circuit_mul(t365, in3);
    let t374 = circuit_sub(t372, t373); // Fp2 mul real part end
    let t375 = circuit_mul(in32, in3);
    let t376 = circuit_mul(t365, in2);
    let t377 = circuit_add(t375, t376); // Fp2 mul imag part end
    let t378 = circuit_mul(in30, in4); // Fp2 scalar mul coeff 0/1
    let t379 = circuit_mul(in31, in4); // Fp2 scalar mul coeff 1/1
    let t380 = circuit_mul(in32, in5); // Fp2 scalar mul coeff 0/1
    let t381 = circuit_mul(in33, in5); // Fp2 scalar mul coeff 1/1
    let t382 = circuit_sub(in38, t374); // Fp2 sub coeff 0/1
    let t383 = circuit_sub(in39, t377); // Fp2 sub coeff 1/1
    let t384 = circuit_sub(in36, t368); // Fp2 sub coeff 0/1
    let t385 = circuit_sub(in37, t371); // Fp2 sub coeff 1/1
    let t386 = circuit_mul(t384, t384); // Fp2 Div x/y start : Fp2 Inv y start
    let t387 = circuit_mul(t385, t385);
    let t388 = circuit_add(t386, t387);
    let t389 = circuit_inverse(t388);
    let t390 = circuit_mul(t384, t389); // Fp2 Inv y real part end
    let t391 = circuit_mul(t385, t389);
    let t392 = circuit_sub(in6, t391); // Fp2 Inv y imag part end
    let t393 = circuit_mul(t382, t390); // Fp2 mul start
    let t394 = circuit_mul(t383, t392);
    let t395 = circuit_sub(t393, t394); // Fp2 mul real part end
    let t396 = circuit_mul(t382, t392);
    let t397 = circuit_mul(t383, t390);
    let t398 = circuit_add(t396, t397); // Fp2 mul imag part end
    let t399 = circuit_add(t395, t398);
    let t400 = circuit_sub(t395, t398);
    let t401 = circuit_mul(t399, t400);
    let t402 = circuit_mul(t395, t398);
    let t403 = circuit_add(t402, t402);
    let t404 = circuit_add(in36, t368); // Fp2 add coeff 0/1
    let t405 = circuit_add(in37, t371); // Fp2 add coeff 1/1
    let t406 = circuit_sub(t401, t404); // Fp2 sub coeff 0/1
    let t407 = circuit_sub(t403, t405); // Fp2 sub coeff 1/1
    let t408 = circuit_sub(in36, t406); // Fp2 sub coeff 0/1
    let t409 = circuit_sub(in37, t407); // Fp2 sub coeff 1/1
    let t410 = circuit_mul(t395, t408); // Fp2 mul start
    let t411 = circuit_mul(t398, t409);
    let t412 = circuit_sub(t410, t411); // Fp2 mul real part end
    let t413 = circuit_mul(t395, t409);
    let t414 = circuit_mul(t398, t408);
    let t415 = circuit_add(t413, t414); // Fp2 mul imag part end
    let t416 = circuit_sub(t412, in38); // Fp2 sub coeff 0/1
    let t417 = circuit_sub(t415, in39); // Fp2 sub coeff 1/1
    let t418 = circuit_mul(t395, in36); // Fp2 mul start
    let t419 = circuit_mul(t398, in37);
    let t420 = circuit_sub(t418, t419); // Fp2 mul real part end
    let t421 = circuit_mul(t395, in37);
    let t422 = circuit_mul(t398, in36);
    let t423 = circuit_add(t421, t422); // Fp2 mul imag part end
    let t424 = circuit_sub(t420, in38); // Fp2 sub coeff 0/1
    let t425 = circuit_sub(t423, in39); // Fp2 sub coeff 1/1
    let t426 = circuit_mul(in7, t398);
    let t427 = circuit_add(t395, t426);
    let t428 = circuit_mul(t427, in35);
    let t429 = circuit_mul(in7, t425);
    let t430 = circuit_add(t424, t429);
    let t431 = circuit_mul(t430, in34);
    let t432 = circuit_mul(t398, in35);
    let t433 = circuit_mul(t425, in34);
    let t434 = circuit_sub(t416, t380); // Fp2 sub coeff 0/1
    let t435 = circuit_sub(t417, t381); // Fp2 sub coeff 1/1
    let t436 = circuit_sub(t406, t378); // Fp2 sub coeff 0/1
    let t437 = circuit_sub(t407, t379); // Fp2 sub coeff 1/1
    let t438 = circuit_mul(t436, t436); // Fp2 Div x/y start : Fp2 Inv y start
    let t439 = circuit_mul(t437, t437);
    let t440 = circuit_add(t438, t439);
    let t441 = circuit_inverse(t440);
    let t442 = circuit_mul(t436, t441); // Fp2 Inv y real part end
    let t443 = circuit_mul(t437, t441);
    let t444 = circuit_sub(in6, t443); // Fp2 Inv y imag part end
    let t445 = circuit_mul(t434, t442); // Fp2 mul start
    let t446 = circuit_mul(t435, t444);
    let t447 = circuit_sub(t445, t446); // Fp2 mul real part end
    let t448 = circuit_mul(t434, t444);
    let t449 = circuit_mul(t435, t442);
    let t450 = circuit_add(t448, t449); // Fp2 mul imag part end
    let t451 = circuit_mul(t447, t406); // Fp2 mul start
    let t452 = circuit_mul(t450, t407);
    let t453 = circuit_sub(t451, t452); // Fp2 mul real part end
    let t454 = circuit_mul(t447, t407);
    let t455 = circuit_mul(t450, t406);
    let t456 = circuit_add(t454, t455); // Fp2 mul imag part end
    let t457 = circuit_sub(t453, t416); // Fp2 sub coeff 0/1
    let t458 = circuit_sub(t456, t417); // Fp2 sub coeff 1/1
    let t459 = circuit_mul(in7, t450);
    let t460 = circuit_add(t447, t459);
    let t461 = circuit_mul(t460, in35);
    let t462 = circuit_mul(in7, t458);
    let t463 = circuit_add(t457, t462);
    let t464 = circuit_mul(t463, in34);
    let t465 = circuit_mul(t450, in35);
    let t466 = circuit_mul(t458, in34);
    let t467 = circuit_mul(t222, in66); // Eval sparse poly line_2 step coeff_1 * z^1
    let t468 = circuit_add(in5, t467); // Eval sparse poly line_2 step + coeff_1 * z^1
    let t469 = circuit_mul(t225, t1); // Eval sparse poly line_2 step coeff_3 * z^3
    let t470 = circuit_add(t468, t469); // Eval sparse poly line_2 step + coeff_3 * z^3
    let t471 = circuit_mul(t226, t5); // Eval sparse poly line_2 step coeff_7 * z^7
    let t472 = circuit_add(t470, t471); // Eval sparse poly line_2 step + coeff_7 * z^7
    let t473 = circuit_mul(t227, t7); // Eval sparse poly line_2 step coeff_9 * z^9
    let t474 = circuit_add(t472, t473); // Eval sparse poly line_2 step + coeff_9 * z^9
    let t475 = circuit_mul(in71, t474);
    let t476 = circuit_mul(t255, in66); // Eval sparse poly line_2 step coeff_1 * z^1
    let t477 = circuit_add(in5, t476); // Eval sparse poly line_2 step + coeff_1 * z^1
    let t478 = circuit_mul(t258, t1); // Eval sparse poly line_2 step coeff_3 * z^3
    let t479 = circuit_add(t477, t478); // Eval sparse poly line_2 step + coeff_3 * z^3
    let t480 = circuit_mul(t259, t5); // Eval sparse poly line_2 step coeff_7 * z^7
    let t481 = circuit_add(t479, t480); // Eval sparse poly line_2 step + coeff_7 * z^7
    let t482 = circuit_mul(t260, t7); // Eval sparse poly line_2 step coeff_9 * z^9
    let t483 = circuit_add(t481, t482); // Eval sparse poly line_2 step + coeff_9 * z^9
    let t484 = circuit_mul(t475, t483);
    let t485 = circuit_mul(t325, in66); // Eval sparse poly line_2 step coeff_1 * z^1
    let t486 = circuit_add(in5, t485); // Eval sparse poly line_2 step + coeff_1 * z^1
    let t487 = circuit_mul(t328, t1); // Eval sparse poly line_2 step coeff_3 * z^3
    let t488 = circuit_add(t486, t487); // Eval sparse poly line_2 step + coeff_3 * z^3
    let t489 = circuit_mul(t329, t5); // Eval sparse poly line_2 step coeff_7 * z^7
    let t490 = circuit_add(t488, t489); // Eval sparse poly line_2 step + coeff_7 * z^7
    let t491 = circuit_mul(t330, t7); // Eval sparse poly line_2 step coeff_9 * z^9
    let t492 = circuit_add(t490, t491); // Eval sparse poly line_2 step + coeff_9 * z^9
    let t493 = circuit_mul(t484, t492);
    let t494 = circuit_mul(t358, in66); // Eval sparse poly line_2 step coeff_1 * z^1
    let t495 = circuit_add(in5, t494); // Eval sparse poly line_2 step + coeff_1 * z^1
    let t496 = circuit_mul(t361, t1); // Eval sparse poly line_2 step coeff_3 * z^3
    let t497 = circuit_add(t495, t496); // Eval sparse poly line_2 step + coeff_3 * z^3
    let t498 = circuit_mul(t362, t5); // Eval sparse poly line_2 step coeff_7 * z^7
    let t499 = circuit_add(t497, t498); // Eval sparse poly line_2 step + coeff_7 * z^7
    let t500 = circuit_mul(t363, t7); // Eval sparse poly line_2 step coeff_9 * z^9
    let t501 = circuit_add(t499, t500); // Eval sparse poly line_2 step + coeff_9 * z^9
    let t502 = circuit_mul(t493, t501);
    let t503 = circuit_mul(t428, in66); // Eval sparse poly line_2 step coeff_1 * z^1
    let t504 = circuit_add(in5, t503); // Eval sparse poly line_2 step + coeff_1 * z^1
    let t505 = circuit_mul(t431, t1); // Eval sparse poly line_2 step coeff_3 * z^3
    let t506 = circuit_add(t504, t505); // Eval sparse poly line_2 step + coeff_3 * z^3
    let t507 = circuit_mul(t432, t5); // Eval sparse poly line_2 step coeff_7 * z^7
    let t508 = circuit_add(t506, t507); // Eval sparse poly line_2 step + coeff_7 * z^7
    let t509 = circuit_mul(t433, t7); // Eval sparse poly line_2 step coeff_9 * z^9
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
            limb0: 18195273793671167350212274106,
            limb1: 21920859387901189648804956677,
            limb2: 26241424352638781019653175105,
            limb3: 1048477250266513801697132897
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 78658955318162014706257423728,
            limb1: 14028184078808959926368179080,
            limb2: 77007643716147893853030817925,
            limb3: 6140404179202982464542115912
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 60481221251975305676545509164,
                limb1: 22177063544922001237101480211,
                limb2: 66027654362826343799431300954,
                limb3: 6274875708312197606814743616
            },
            x1: u384 {
                limb0: 28975082538002582003208339920,
                limb1: 70450805066182526765053011635,
                limb2: 3064688418710414828137308385,
                limb3: 6079304727843324786235637485
            },
            y0: u384 {
                limb0: 34241111578533225835483677609,
                limb1: 47545058409458067793231639555,
                limb2: 19494714168413759623390859535,
                limb3: 3886343154779101171028803103
            },
            y1: u384 {
                limb0: 71917074249618888834378571474,
                limb1: 23407495140631825202331925447,
                limb2: 40912910718238269695960836967,
                limb3: 979604140535422608937233530
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 75881059275768469875300117658,
            limb1: 18233893578457877996916816107,
            limb2: 76165408938171080770380534052,
            limb3: 5715914866135249496375052357
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 19118894065720084093878139781,
            limb1: 11188198832544147151625886212,
            limb2: 31015491205675375674575056190,
            limb3: 3703084365402493920774713644
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 77606443798590489394285655948,
                limb1: 25213885087773509095802753896,
                limb2: 71221103057724030048569246536,
                limb3: 1202784056371497921627466583
            },
            x1: u384 {
                limb0: 2893504752711780316591385161,
                limb1: 44410962787771750374005991115,
                limb2: 19988588826120134255717240436,
                limb3: 5883778201161737358191660552
            },
            y0: u384 {
                limb0: 29531686269300711702841907538,
                limb1: 768840684702335920521447952,
                limb2: 53620202468014882689968072157,
                limb3: 4243230398207105304813191644
            },
            y1: u384 {
                limb0: 58964341786779451767432310844,
                limb1: 41647948931240861649123853953,
                limb2: 70765510555699765223426247784,
                limb3: 5104367717428081057628369222
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 46864733453142587178908769807,
            limb1: 10208840961612396338446583225,
            limb2: 18304675259657465319687797479,
            limb3: 4568144127694510711256082136
        };

        let f_i_of_z: u384 = u384 {
            limb0: 35965895312459884808163407512,
            limb1: 54186242963571708019116304747,
            limb2: 20561464542614745090512265132,
            limb3: 7249495031521092434465897488
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 2863054239074127716361135772,
                limb1: 41505837366794021320001793018,
                limb2: 18842744539419025852740507269,
                limb3: 1122240685411734784271613127
            },
            w1: u384 {
                limb0: 38588574116873990392796570194,
                limb1: 69013258730967681718418100913,
                limb2: 39875379816853053409463494903,
                limb3: 2014569215500031603482632456
            },
            w2: u384 {
                limb0: 42634866079719415855442553587,
                limb1: 14191802145205861488279928314,
                limb2: 26359133103912083747617257624,
                limb3: 1921151016903545744774132827
            },
            w3: u384 {
                limb0: 40723851430392775900375921650,
                limb1: 4333493233285079384689943341,
                limb2: 20331612504552931502475658858,
                limb3: 2667864076601633044279115338
            },
            w4: u384 {
                limb0: 42731065345319909507990910459,
                limb1: 46592987788193785647980576638,
                limb2: 74507099065578186686200915367,
                limb3: 6556981620997058046271398189
            },
            w5: u384 {
                limb0: 46276960512068032901654177702,
                limb1: 2973477235711544995434689409,
                limb2: 39365110877136828239157406319,
                limb3: 3082232781419238908370309166
            },
            w6: u384 {
                limb0: 69591957077637491297256717036,
                limb1: 56778357815360239857271569736,
                limb2: 53944034924439362490565592452,
                limb3: 7927098045462716761330234660
            },
            w7: u384 {
                limb0: 17479897529864896052527290987,
                limb1: 22158678476011203087177515172,
                limb2: 24248704288490970133784740316,
                limb3: 1907949936272813117835570380
            },
            w8: u384 {
                limb0: 10697416587478527682599914635,
                limb1: 62299702070065394794010155223,
                limb2: 40568078573791093930037148771,
                limb3: 4263012427525334954359269862
            },
            w9: u384 {
                limb0: 78541242829580449002907795874,
                limb1: 51394441849552013319859728493,
                limb2: 53756980799654681466117563020,
                limb3: 4283182594389998470265367333
            },
            w10: u384 {
                limb0: 32397626586980623613638821045,
                limb1: 70769245802489391874760624902,
                limb2: 20244909204248824236559733792,
                limb3: 7371826116266658476584073504
            },
            w11: u384 {
                limb0: 38156957810112486398796418665,
                limb1: 3726517452033591794456039780,
                limb2: 47329841181557617262757398594,
                limb3: 275096076223046614456633333
            }
        };

        let ci: u384 = u384 {
            limb0: 19967121300182212854770400504,
            limb1: 5454934691710506410086988049,
            limb2: 21610730429476256535972784024,
            limb3: 221256962413239040130597286
        };

        let z: u384 = u384 {
            limb0: 16289473331837716415891757208,
            limb1: 66778197125768651341304904430,
            limb2: 286764133516027431,
            limb3: 0
        };

        let (
            Q0_result,
            Q1_result,
            f_i_plus_one_of_z_result,
            lhs_i_plus_one_result,
            ci_plus_one_result
        ) =
            run_BLS12_381_MP_CHECK_BIT00_LOOP_2_circuit(
            yInv_0, xNegOverY_0, Q0, yInv_1, xNegOverY_1, Q1, lhs_i, f_i_of_z, f_i_plus_one, ci, z
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 17323166297675379287442313230,
                limb1: 68488612463547443880109694283,
                limb2: 70110749684785476416451978978,
                limb3: 4176660808502733409663944527
            },
            x1: u384 {
                limb0: 59492568455191125318225620232,
                limb1: 66756334762643162602369191222,
                limb2: 33308659322789067386170890188,
                limb3: 1719312013388382028775915522
            },
            y0: u384 {
                limb0: 42067911172320396464118618075,
                limb1: 3575385954851253780985895782,
                limb2: 16157592956548604617743796725,
                limb3: 2397325020725577872494594804
            },
            y1: u384 {
                limb0: 54514996485915664417211940886,
                limb1: 69573890903468063365649764428,
                limb2: 27242326218266225333022290707,
                limb3: 5670650174776637406931789790
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 32892713317254770625411942606,
                limb1: 60261345135054844028996528488,
                limb2: 7541921925511974678836443416,
                limb3: 1777982800792350159604406461
            },
            x1: u384 {
                limb0: 63836197293554166306706273732,
                limb1: 74619328236318937857687013634,
                limb2: 36815560959069362158862928407,
                limb3: 4688586428768363757132282046
            },
            y0: u384 {
                limb0: 59040300579412259442247432327,
                limb1: 20638370186627680179069000949,
                limb2: 3143931999073060501425457558,
                limb3: 7136294759829709706849207758
            },
            y1: u384 {
                limb0: 49711806627675118647280416005,
                limb1: 27226910087625147290500247034,
                limb2: 47571287181671059729490159678,
                limb3: 4951975738363803833903241352
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 42500992640467373070902343542,
            limb1: 24740398383385840971586192925,
            limb2: 31387195359613617707177840301,
            limb3: 3466656891896447348230666866
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 46370346665288693019983306812,
            limb1: 74568646572298972041889719908,
            limb2: 14046089873439649652462423671,
            limb3: 3764243876807402004316979974
        };

        let ci_plus_one: u384 = u384 {
            limb0: 40277234387439256494974976999,
            limb1: 51096206618973399667754377704,
            limb2: 9664594041527420396301933225,
            limb3: 5453710866255732201637128034
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
            limb0: 45841709912698619449843104507,
            limb1: 15277030859297683920519880903,
            limb2: 50912863302358120954052046353,
            limb3: 7423312820664847168882462543
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 69868555568823958137397070110,
            limb1: 11829677205416806663514166735,
            limb2: 9956546581653655229720319960,
            limb3: 3782875254205498035767982389
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 31131478215073776896310552844,
                limb1: 75356907498223489633436842064,
                limb2: 53859621589866423828913885930,
                limb3: 7327091114215947241309269983
            },
            x1: u384 {
                limb0: 54089011687165376623717629586,
                limb1: 45512421291912780118805293291,
                limb2: 4232697171309883362220202151,
                limb3: 5390048360163490318692329695
            },
            y0: u384 {
                limb0: 73682206367635409829039264288,
                limb1: 22201913898673072006343466041,
                limb2: 28147469048830362718673930487,
                limb3: 4343372240361661181832388342
            },
            y1: u384 {
                limb0: 52898850940157730687132029423,
                limb1: 62748082603060209416495840930,
                limb2: 36780625465441717556117112986,
                limb3: 1697094099155079629657641359
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 55583907879412510389459446936,
            limb1: 31695447921396569865626165275,
            limb2: 20209610974171038655859877465,
            limb3: 153655120060161833851571320
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 74049916622081247860966980650,
            limb1: 23627422492628834033651040547,
            limb2: 6060926362593532060617457499,
            limb3: 12381790985879278282629807
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 68201046886328048807220581072,
                limb1: 16936766339214868320800198747,
                limb2: 78642190815004444752659022418,
                limb3: 7104102084184209080720498557
            },
            x1: u384 {
                limb0: 50519160964288604897140369176,
                limb1: 77125927218773277410555693744,
                limb2: 18283464958529541826162181045,
                limb3: 5435561736402682508210541756
            },
            y0: u384 {
                limb0: 24847558589257074020078626787,
                limb1: 48673880958554183348722030406,
                limb2: 45596945598560591396509544939,
                limb3: 3421269644426948157847689299
            },
            y1: u384 {
                limb0: 70195681529193306470005129270,
                limb1: 32604823420744296779928517859,
                limb2: 64196287882412976974585158039,
                limb3: 2395759408968131543132841536
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 1684987155514583474354764047,
            limb1: 61784808887061139585513746620,
            limb2: 496263530773149992147707534,
            limb3: 5867081560688211593552896365
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 8290492201503934818209870610,
            limb1: 39034593679784387122639798612,
            limb2: 77950266599439348204196677343,
            limb3: 4145144628853197061661533678
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 74364679714445316933334457716,
                limb1: 51963979396080739122652127981,
                limb2: 72460582919945517295648589987,
                limb3: 5306841859634511602030337064
            },
            x1: u384 {
                limb0: 27911948135770306777690158235,
                limb1: 57573230317810027035452383204,
                limb2: 26620951766178200333485975825,
                limb3: 380079238874704328598633079
            },
            y0: u384 {
                limb0: 47853015217303672034368088925,
                limb1: 17141165972459330844008222290,
                limb2: 57868833130641354862448855557,
                limb3: 7277066337125435140992405045
            },
            y1: u384 {
                limb0: 9744796773696978468949651933,
                limb1: 7720621070955135536108786433,
                limb2: 19823321621726094966072800956,
                limb3: 1968504606903044640623144552
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 21907065663472561663049256170,
            limb1: 63604968346864068585353956256,
            limb2: 12824456192439000859683036759,
            limb3: 6767248003205049516514528954
        };

        let f_i_of_z: u384 = u384 {
            limb0: 68347910126904910644876984668,
            limb1: 18606831924030107586256288043,
            limb2: 77538204123117318370117726801,
            limb3: 6615232354541127466854497147
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 38718443401245532833901299249,
                limb1: 13795012136132148617681690526,
                limb2: 39264331533097703473662204783,
                limb3: 4431037991203830374790042739
            },
            w1: u384 {
                limb0: 55675529176725658746738176504,
                limb1: 17991290106043951298620176910,
                limb2: 57660490540250929758479900358,
                limb3: 4107140429000741553104486213
            },
            w2: u384 {
                limb0: 58026180867079145201764218932,
                limb1: 6811863556213516597173351492,
                limb2: 11928173493386600678019514156,
                limb3: 2243347687747045677955806504
            },
            w3: u384 {
                limb0: 14252124135891589075041757427,
                limb1: 14702383756205940398279541044,
                limb2: 38086034378878249808804169629,
                limb3: 2357399667130719325458368789
            },
            w4: u384 {
                limb0: 47559182219429882390022969527,
                limb1: 27693100686174683304461572042,
                limb2: 24534135149943450719874376296,
                limb3: 3260353249123984302403975855
            },
            w5: u384 {
                limb0: 25595354806475984458500565434,
                limb1: 50348844663268430067667868198,
                limb2: 5852427636449016053953763157,
                limb3: 4852680181914194438490989471
            },
            w6: u384 {
                limb0: 50701104800723897900896404372,
                limb1: 27772562918548813602645826807,
                limb2: 7460800959364782032329639297,
                limb3: 1191818138469961769896357990
            },
            w7: u384 {
                limb0: 12148647950153744362620412678,
                limb1: 29071096361161567921118504047,
                limb2: 19176177990960515472240544274,
                limb3: 5542971296401179751106103391
            },
            w8: u384 {
                limb0: 55398666623005939216298964221,
                limb1: 26159765603956355423809176299,
                limb2: 68301913918882849714447458148,
                limb3: 814528086674855463757344489
            },
            w9: u384 {
                limb0: 61286774863673497239498366928,
                limb1: 64266034385387836159583563753,
                limb2: 63293000400172194368664296781,
                limb3: 2208380113452811915570117498
            },
            w10: u384 {
                limb0: 63335766329353912759616312017,
                limb1: 43795569998765884306266022242,
                limb2: 16399929743459793304655962722,
                limb3: 4433392677410940901641755044
            },
            w11: u384 {
                limb0: 57362684855113527098945853432,
                limb1: 25982159501029713761750173499,
                limb2: 23217870343200635770168044832,
                limb3: 4302455239469644001362527118
            }
        };

        let ci: u384 = u384 {
            limb0: 74968438359967207547582965447,
            limb1: 76236015985344271136951370180,
            limb2: 67781877529456372688196047174,
            limb3: 7505552933214469475309744436
        };

        let z: u384 = u384 {
            limb0: 41899909497951011879915032535,
            limb1: 24640977437282958112713872404,
            limb2: 53350260902310178,
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
            run_BLS12_381_MP_CHECK_BIT00_LOOP_3_circuit(
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
                limb0: 26297963844905294621944760513,
                limb1: 78595297386024141779797947960,
                limb2: 75383877134827254919210859756,
                limb3: 7315510615965843843022692339
            },
            x1: u384 {
                limb0: 61601848119541284031583235501,
                limb1: 31310757217761950572487842017,
                limb2: 21998641723604101312158417110,
                limb3: 6436916486716572255032570007
            },
            y0: u384 {
                limb0: 63800308500086818829898899764,
                limb1: 34995679424736674923799933042,
                limb2: 1013737771815454499478640301,
                limb3: 5383881961366669624671628654
            },
            y1: u384 {
                limb0: 425654426761624252065832793,
                limb1: 67316663364848462397620755851,
                limb2: 74271760776634204543669143576,
                limb3: 73759861779862626296244297
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 14354961405753148401790698117,
                limb1: 20908175420717941872248846414,
                limb2: 70826351201016985871135090915,
                limb3: 6754677728330549556758619098
            },
            x1: u384 {
                limb0: 62175040136397432684457633033,
                limb1: 29058633060516959232936885625,
                limb2: 42696339702439416104626714939,
                limb3: 3791457159566675678387455142
            },
            y0: u384 {
                limb0: 32623042764645528186872314525,
                limb1: 18179962797303192984901834341,
                limb2: 54746582119487187357337171932,
                limb3: 3881841044778767541502189875
            },
            y1: u384 {
                limb0: 72792711390432508978032219525,
                limb1: 13051967062685712820004648192,
                limb2: 50940294942367096491033668963,
                limb3: 7210690369170811185852815156
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 41975447359426039427231860901,
                limb1: 47128801584568830101435510144,
                limb2: 49091856604663232013802344065,
                limb3: 3472893425346397320782846554
            },
            x1: u384 {
                limb0: 55323227590617861931816535857,
                limb1: 24638566779368081777995103155,
                limb2: 9029136888336624961688033320,
                limb3: 3316414638358297820252047525
            },
            y0: u384 {
                limb0: 31205845039248212170323604007,
                limb1: 37127852745703184040450139359,
                limb2: 37487047211128604026741192649,
                limb3: 258608275589023298768780918
            },
            y1: u384 {
                limb0: 72462517310861269483765268319,
                limb1: 36532358716377199610135517055,
                limb2: 68363691875303981302338541815,
                limb3: 5151121230792396362549049744
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 16547311909373674913045877181,
            limb1: 10230858905175151692767055883,
            limb2: 52707738093526457174838508689,
            limb3: 7042054440991700436336322614
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 23651413560241114055129950559,
            limb1: 14252886467075120130694168283,
            limb2: 4603935309633639755715468233,
            limb3: 7840157477812598969269526590
        };

        let ci_plus_one: u384 = u384 {
            limb0: 227184730295014297091751196,
            limb1: 15294490940967781523123404364,
            limb2: 51694917647936026618816559023,
            limb3: 6443553414566063098925425418
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
            limb0: 35653175037989485227984689480,
            limb1: 7944469504324102196901510292,
            limb2: 77005485202595382992233780069,
            limb3: 4812353697207156410364976254
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 10943657087705527163433057829,
            limb1: 69222745997522170816630166350,
            limb2: 15139071848270205504286639561,
            limb3: 5722812151100414633665737128
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 2628875394203559486279542278,
                limb1: 50309648230549321236515303068,
                limb2: 68476172994121398451176869234,
                limb3: 153310835514440380388207141
            },
            x1: u384 {
                limb0: 55691349369967658331199187505,
                limb1: 23436893320773517693177497231,
                limb2: 53363013342747783952503116159,
                limb3: 665407042952535099775374406
            },
            y0: u384 {
                limb0: 20332136565030715224160208309,
                limb1: 67846911653725336370734314059,
                limb2: 192765325042289973567433544,
                limb3: 802165884372759632788112183
            },
            y1: u384 {
                limb0: 27335294850757077479051903677,
                limb1: 61126891598146169062318161506,
                limb2: 39098044350123818825817580124,
                limb3: 7953313164882577989720311147
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 42954197666952700837520073450,
            limb1: 34913659557665844225573275726,
            limb2: 75152658626332223966699611651,
            limb3: 7540108349123520318695823963
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 43435792067018662685886414688,
            limb1: 32223393909140309000478411920,
            limb2: 74274070961612686488528960385,
            limb3: 5102245198008976317858507313
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 47670104326162360254434340542,
                limb1: 31481573058362024859056121698,
                limb2: 32584430082503783488244668493,
                limb3: 3994299539931290015888251398
            },
            x1: u384 {
                limb0: 51045429554718210878889735088,
                limb1: 76857263464529085100915987728,
                limb2: 51009703266569444841620244001,
                limb3: 4790219578522665983728098666
            },
            y0: u384 {
                limb0: 74914412885666287243203020173,
                limb1: 5329891587376812457867044970,
                limb2: 54793075487943532395623976344,
                limb3: 3120791323668425029325375074
            },
            y1: u384 {
                limb0: 38388944779166587383442680789,
                limb1: 74255444005405707481934050998,
                limb2: 52273216082568966349347074565,
                limb3: 676979219371535727112039310
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 25062387053895218355543897618,
            limb1: 37870294831124718358625658017,
            limb2: 38046871985718008878434002503,
            limb3: 1901092404946245708354588534
        };

        let f_i_of_z: u384 = u384 {
            limb0: 67150586502705501009510853602,
            limb1: 8272722717966857946443052743,
            limb2: 16783383682650061563407698202,
            limb3: 1110216014467981803816377473
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 67171443196312129537075662975,
                limb1: 41859629998469701280582031405,
                limb2: 12774016850270457387242220495,
                limb3: 1179365173453047978169696174
            },
            w1: u384 {
                limb0: 26573313509596601402211209952,
                limb1: 17853993310879263524750049034,
                limb2: 4726167959426486168733265278,
                limb3: 1972161573236773864322186462
            },
            w2: u384 {
                limb0: 39245498886250008675787040892,
                limb1: 73613939256014321312976217280,
                limb2: 15824196232711275648092599868,
                limb3: 7378006727470087630518225767
            },
            w3: u384 {
                limb0: 31194101982675230167813387177,
                limb1: 4789644329598186489942072743,
                limb2: 48261068564075233189895070998,
                limb3: 2788302566719059579336258700
            },
            w4: u384 {
                limb0: 3770423247801634711109953907,
                limb1: 11857980962355892059256798342,
                limb2: 72126577996955485610475869470,
                limb3: 6592668270665506462839265295
            },
            w5: u384 {
                limb0: 45690730896461314065386173286,
                limb1: 34633683071756104352914077676,
                limb2: 16402706230237767976451297669,
                limb3: 6660237820067182224118590893
            },
            w6: u384 {
                limb0: 47660638286117310604758204462,
                limb1: 15488380889605629040097869463,
                limb2: 35461110679441666267799778018,
                limb3: 2495479006417197871305783217
            },
            w7: u384 {
                limb0: 73838116480898929758759930522,
                limb1: 78566853856578625317354542112,
                limb2: 25057253312864321057855589203,
                limb3: 5015308281447453056893885684
            },
            w8: u384 {
                limb0: 2624937237058410606970673884,
                limb1: 29058872124922695558546575968,
                limb2: 19301465681612015833802381108,
                limb3: 1869805513412350412804084015
            },
            w9: u384 {
                limb0: 49491548552555693488595621356,
                limb1: 3903561558453162353172937471,
                limb2: 63470735210412289879083263854,
                limb3: 7152483539283142772427668417
            },
            w10: u384 {
                limb0: 31022314955889181056318822421,
                limb1: 15812679597624861916310858408,
                limb2: 34731171712570854123467039078,
                limb3: 2167999132285186225918128713
            },
            w11: u384 {
                limb0: 46581248442254322013572820401,
                limb1: 39750054767581311624055374380,
                limb2: 54849375026896614531841741601,
                limb3: 3379445521436925654641940887
            }
        };

        let ci: u384 = u384 {
            limb0: 74573662011126977280267729486,
            limb1: 19275439105425821081629519116,
            limb2: 50643789868367549271799120265,
            limb3: 2503337029820374380423251816
        };

        let z: u384 = u384 {
            limb0: 64928436138704450384657494189,
            limb1: 10671738562935222965183920755,
            limb2: 128398614609077060,
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
                limb0: 33052321136443576180491630502,
                limb1: 56172474003429941566265095438,
                limb2: 241963886278209462434476264,
                limb3: 2331025642815669110878485894
            },
            x1: u384 {
                limb0: 31411531821879235613305564350,
                limb1: 74749008307139485107742696094,
                limb2: 78150063730555549440733008100,
                limb3: 5751886890328922178046017179
            },
            y0: u384 {
                limb0: 47886438349934320025209252290,
                limb1: 12397659211757965730629790120,
                limb2: 76818052540371208480635081597,
                limb3: 1071944051251352317257715804
            },
            y1: u384 {
                limb0: 6317316917246426258638832035,
                limb1: 31999665165406275488373499118,
                limb2: 42818315349359954779521257509,
                limb3: 6202672392528452847953403991
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 30723731500427868502168837574,
                limb1: 15533051248508054186809085217,
                limb2: 32028287531386352676814048791,
                limb3: 4733619063853964072814815034
            },
            x1: u384 {
                limb0: 10549953362160417568761131932,
                limb1: 13553730319593722760468465084,
                limb2: 49843120724576974300557098488,
                limb3: 784748109565145542783798391
            },
            y0: u384 {
                limb0: 59800397808657753237959749700,
                limb1: 8590694350911411034365068266,
                limb2: 40296947630078180594152258819,
                limb3: 7917418477655244899806444055
            },
            y1: u384 {
                limb0: 62133037764789349922942440464,
                limb1: 62659054930260137428293023390,
                limb2: 25292056566379385868120747351,
                limb3: 7019128315917962726428930457
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 37776229299587490184107608207,
            limb1: 59443396019036064593055285484,
            limb2: 59704999782204286645135725602,
            limb3: 6452414431683722485719632366
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 28308101364244477319036598804,
            limb1: 21115649759029392251401989906,
            limb2: 77619766260268697139271944463,
            limb3: 1716908282521982863310490823
        };

        let ci_plus_one: u384 = u384 {
            limb0: 41089790665176521559923351772,
            limb1: 65013659037375284382103870685,
            limb2: 34448408169035387841599710515,
            limb3: 592530550746029550055615324
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
            limb0: 73052999283578589637718988448,
            limb1: 11844875814611203280416379819,
            limb2: 32897391758784566537527796188,
            limb3: 4874589876840956287310160475
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 10631521940837081472133513226,
            limb1: 77263034382466156767593223599,
            limb2: 40759762796941566645137851739,
            limb3: 2066676153238195043355534201
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 29561936557407448743432837898,
                limb1: 56199043613175260955747038739,
                limb2: 26728582911531487882337340968,
                limb3: 2156430713606851927422092777
            },
            x1: u384 {
                limb0: 5588697272060004511021113965,
                limb1: 65078709893493880716028124574,
                limb2: 46712777274606841991257801267,
                limb3: 6576126598997327708923611339
            },
            y0: u384 {
                limb0: 23316414306398529779365177199,
                limb1: 13764695078959779539917676430,
                limb2: 31062796985370912309369198048,
                limb3: 5411627785576788449255803925
            },
            y1: u384 {
                limb0: 3846669036421507307360026336,
                limb1: 4357065593292422858718055907,
                limb2: 2689923097254004120142552201,
                limb3: 5811080498333420916578487562
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 33165614822616737122953470326,
            limb1: 23455108065129940086996336437,
            limb2: 29650901449791252270009536902,
            limb3: 4508881289307202321159588912
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 48027178417955897944204476682,
            limb1: 36423079032499916883100257813,
            limb2: 69533051699061845778576579008,
            limb3: 7660844635583890820187692715
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 76296317371943660145089435843,
                limb1: 9925984430905997975346257824,
                limb2: 3018177080001257853874286309,
                limb3: 4215342638229562768602161828
            },
            x1: u384 {
                limb0: 68163424444138216869155339552,
                limb1: 6654316515117918149881018730,
                limb2: 23897267371702329825695610241,
                limb3: 3955479056309044139305546524
            },
            y0: u384 {
                limb0: 47911364011023245563565721167,
                limb1: 41261487574538843330864277784,
                limb2: 30551456603974075068970950905,
                limb3: 3058363002173437224933365589
            },
            y1: u384 {
                limb0: 19856176708228283713191538164,
                limb1: 11525357535671788137122041116,
                limb2: 36694117140145672455058328349,
                limb3: 4582473167698090792459976889
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 55250603080997809682032840505,
            limb1: 12106620163563545815433271074,
            limb2: 37315022056908242444987099407,
            limb3: 1410366898043600860118701174
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 43692086172701278573487007184,
            limb1: 22341054906243496542552111690,
            limb2: 27179793715452307533247613299,
            limb3: 1052399462702361291029523648
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 54825991637748580070221596749,
                limb1: 14810391616875785254357701807,
                limb2: 29104753404888470632016280315,
                limb3: 4187637887971992438190946640
            },
            x1: u384 {
                limb0: 65687679023007254707118087811,
                limb1: 32568329874116838039688061944,
                limb2: 13038659783207678122841573374,
                limb3: 4628187161507776867812940889
            },
            y0: u384 {
                limb0: 67364828684977589506224818479,
                limb1: 73506841498263182409494393205,
                limb2: 13397963679416992421271173186,
                limb3: 6710925263875199438678785313
            },
            y1: u384 {
                limb0: 69438099012293703116741590523,
                limb1: 76110172519237409740294639232,
                limb2: 66012482230900828629143049107,
                limb3: 3577668286882338855355488503
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 50597717776658600532116182657,
            limb1: 61400846087944422044456595058,
            limb2: 47909737461968930125576254637,
            limb3: 4595241278103752178503202788
        };

        let f_i_of_z: u384 = u384 {
            limb0: 5795266173327760291087942785,
            limb1: 70616956448440973365030547015,
            limb2: 73013425362794221247936901067,
            limb3: 7613841718539086987144521371
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 65050994056954254949160997377,
                limb1: 42563439921608442879195062103,
                limb2: 52637094679192005700005527843,
                limb3: 1142344279452450191137377117
            },
            w1: u384 {
                limb0: 16320061482338326001681029192,
                limb1: 46735259780601429807790173211,
                limb2: 23003110353167523133926493104,
                limb3: 6070670121404368210726584556
            },
            w2: u384 {
                limb0: 17743037588209500618043258940,
                limb1: 48307266062466262467299536844,
                limb2: 66562893367291534121809394844,
                limb3: 3098735110564458952274740551
            },
            w3: u384 {
                limb0: 65760613344502030139206035053,
                limb1: 36721413867762424369384677902,
                limb2: 65649522586241325660410488067,
                limb3: 6020401734243648641374551962
            },
            w4: u384 {
                limb0: 57701647384022068626352000387,
                limb1: 22958801798947668260432680500,
                limb2: 2054744298407946203877033664,
                limb3: 3470212846459812259755880278
            },
            w5: u384 {
                limb0: 43092608000403059828101310782,
                limb1: 23681266546474030136319256601,
                limb2: 78047469244536787686294671629,
                limb3: 3980799913495307075300983351
            },
            w6: u384 {
                limb0: 20418098157075524126265286933,
                limb1: 3162032660868045181220538731,
                limb2: 59413908529514663113088177402,
                limb3: 5894784534427946494327693410
            },
            w7: u384 {
                limb0: 17758723534498828776578216413,
                limb1: 57740990749673748298973893781,
                limb2: 23529531423170257652935205813,
                limb3: 4969354281476000101593433670
            },
            w8: u384 {
                limb0: 6179378132132901980464417326,
                limb1: 17437451103967338075387505697,
                limb2: 2658512276053193367173748463,
                limb3: 5709290946287334483194131720
            },
            w9: u384 {
                limb0: 54243688249297070964045041909,
                limb1: 53777567003763505423783173213,
                limb2: 21723373575412357725954478463,
                limb3: 6444397073483623875478164334
            },
            w10: u384 {
                limb0: 41532336553675535492052477140,
                limb1: 34936476511652016901730016984,
                limb2: 73114936867025347702863888078,
                limb3: 2083771629993457129904103312
            },
            w11: u384 {
                limb0: 8346392845101260005778267088,
                limb1: 1756814703603796535191952402,
                limb2: 5649077998648951729229667070,
                limb3: 6925859866805470312232713667
            }
        };

        let ci: u384 = u384 {
            limb0: 73984349856808812876246909662,
            limb1: 51476358602482304035486462317,
            limb2: 39808459272379463983100077652,
            limb3: 4780153253096758790369371322
        };

        let z: u384 = u384 {
            limb0: 39257213879988109824076962893,
            limb1: 77177987797052501027010505271,
            limb2: 356860874306539270,
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
                limb0: 57745012999422662484031232728,
                limb1: 11392927091467574750394271039,
                limb2: 51335733029583578480342402513,
                limb3: 199477242931547743468604273
            },
            x1: u384 {
                limb0: 61932195911574630169262648281,
                limb1: 39753352892497668821847428626,
                limb2: 17954536679925725734112967127,
                limb3: 7258149139806806518847450859
            },
            y0: u384 {
                limb0: 40430869235673387732164280562,
                limb1: 44672351194443886295753027042,
                limb2: 17766055081922799016384590448,
                limb3: 4580527416042388013410580868
            },
            y1: u384 {
                limb0: 72429646310188191267807929054,
                limb1: 13907363615815515990763851712,
                limb2: 5165466710721633680248455274,
                limb3: 1116731954958204735949896791
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 18288967150377643667871314865,
                limb1: 95557971927965841768234177,
                limb2: 17062478055841765030562501015,
                limb3: 3866961412139179238510807762
            },
            x1: u384 {
                limb0: 28296798483014970300600089909,
                limb1: 12164912574701009179315558264,
                limb2: 28719519300078875809825339828,
                limb3: 419132068448553826838257616
            },
            y0: u384 {
                limb0: 15372142601971044556850423959,
                limb1: 20962830160980240773784374207,
                limb2: 1322923670433629632084897616,
                limb3: 4833054876386162578967450643
            },
            y1: u384 {
                limb0: 23685320518296343335848375108,
                limb1: 35603056548112330746191313943,
                limb2: 9568135541178831823949786088,
                limb3: 3977844631238577564024517537
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 485724710125570158267772992,
                limb1: 52969372739687879482166163112,
                limb2: 6640190717348077580419315555,
                limb3: 6743841206869549115013797051
            },
            x1: u384 {
                limb0: 42396932757506504677454437470,
                limb1: 46229714465748096798977026998,
                limb2: 73904151410565635280809724262,
                limb3: 2034773678077257657526201575
            },
            y0: u384 {
                limb0: 55074870480088624861100378604,
                limb1: 11934639106699829226328169964,
                limb2: 54328142489925474450902365264,
                limb3: 5718513753590994900800848458
            },
            y1: u384 {
                limb0: 40750478401510050095948355314,
                limb1: 1340538202832210681995819716,
                limb2: 72776201508586419986667242125,
                limb3: 3757622462827230126132176725
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 7267284546504695098349802583,
            limb1: 26123777301701541828485307953,
            limb2: 49159433844213753664684373396,
            limb3: 3998441275100360057583700133
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 63349076541160622525643166366,
            limb1: 73147534641783755656416174585,
            limb2: 16843657820055888520975658305,
            limb3: 1506477562174635606267405491
        };

        let ci_plus_one: u384 = u384 {
            limb0: 61326374366710510813696224026,
            limb1: 34772091016971054914101982678,
            limb2: 33421277039671218549435549722,
            limb3: 7541576657369041930998180765
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
            limb0: 6101672656027099802783592960,
            limb1: 74987386395082600071792979279,
            limb2: 7258026793177562665344874634,
            limb3: 5435963875890979589031663827
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 19310904906722487066865736869,
            limb1: 30052132048556734990119947042,
            limb2: 24439186953930837568808983665,
            limb3: 1244754879358634604870736795
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 15216014132213491048889956912,
                limb1: 14453110371482153654219108175,
                limb2: 21540030727368316856607924226,
                limb3: 5268098521368970839958237707
            },
            x1: u384 {
                limb0: 55613518345689104602438983116,
                limb1: 55246364564186713110016715642,
                limb2: 63733245202238214493517752994,
                limb3: 3537174953414431850019839862
            },
            y0: u384 {
                limb0: 27718367780074731394971560632,
                limb1: 23535009271420124561328445989,
                limb2: 54890411553351776760192342393,
                limb3: 211789312782071563308584432
            },
            y1: u384 {
                limb0: 39804716701835976172362988375,
                limb1: 62647269584016162098611210607,
                limb2: 28310062250043501633883885560,
                limb3: 5812619435941405275213039588
            }
        };

        let Q_or_Qneg_0: G2Point = G2Point {
            x0: u384 {
                limb0: 67237918143401451946318077166,
                limb1: 38695405030736743956038446484,
                limb2: 67535513608671265319087105838,
                limb3: 5109558167938589828996448200
            },
            x1: u384 {
                limb0: 49946348832030904663174366858,
                limb1: 66681629041577791531957775840,
                limb2: 27584206501242623420198193512,
                limb3: 1397254098002786317289698059
            },
            y0: u384 {
                limb0: 29568016333485777139160567936,
                limb1: 42253310609469382531878444702,
                limb2: 60334968436392846314309487687,
                limb3: 3658328767892263038276931117
            },
            y1: u384 {
                limb0: 57909349115033524890236974760,
                limb1: 58347182901403030841643764576,
                limb2: 16343022737943652663412270407,
                limb3: 2268596592749478369991773602
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 69292379328568285103738969085,
            limb1: 3686607560812883388231605943,
            limb2: 18122705648728085188593932908,
            limb3: 3819037278442160538564001218
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 68036243347332710998192656167,
            limb1: 55413582035728747732150399540,
            limb2: 27876571532492420670854125947,
            limb3: 1565650149347462542113333606
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 3281813853438506735939328557,
                limb1: 62213772916067292869034368249,
                limb2: 30524567908081991790276187333,
                limb3: 3984846020710099149454853774
            },
            x1: u384 {
                limb0: 26239231961557470854244238231,
                limb1: 47894426952917748621413813299,
                limb2: 31849067197844471116584431928,
                limb3: 4927554625222934056454265461
            },
            y0: u384 {
                limb0: 25875863905622811863874125384,
                limb1: 62302007510542311896931790670,
                limb2: 29971046793984359718667369041,
                limb3: 6414486727917771710999383496
            },
            y1: u384 {
                limb0: 78965192750455420244475651006,
                limb1: 35647380910521743610164926614,
                limb2: 37293442126037079484814930444,
                limb3: 2127512770985680601662221272
            }
        };

        let Q_or_Qneg_1: G2Point = G2Point {
            x0: u384 {
                limb0: 23385048109519341167364142297,
                limb1: 71819825860831181295412898764,
                limb2: 36775288698915490644268044151,
                limb3: 1503674315136153086770582254
            },
            x1: u384 {
                limb0: 52486079023907796578617924014,
                limb1: 64746439242130966189989408658,
                limb2: 58569460286755029166976628864,
                limb3: 3549121498904998713540964358
            },
            y0: u384 {
                limb0: 16868558838007328991927675710,
                limb1: 36753931610814737889164732417,
                limb2: 67450733661604339821384585304,
                limb3: 7681192256991378344457055299
            },
            y1: u384 {
                limb0: 76002182921258899663386856408,
                limb1: 56268890277718117774319188988,
                limb2: 63464221547069215651670005062,
                limb3: 6133837321887801155454348368
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 77528123642522518228017489546,
            limb1: 18886921350782289871391372856,
            limb2: 76090797635260036822716585325,
            limb3: 409568920124579625243709722
        };

        let f_i_of_z: u384 = u384 {
            limb0: 12190887106095874081708044379,
            limb1: 32243875555591276098410677458,
            limb2: 32351902687881120783537860505,
            limb3: 5836463242715357142413278961
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 51014995883561375089489185785,
                limb1: 9711905449907943024880918566,
                limb2: 4126015368760344773338320482,
                limb3: 481485273825671145677375073
            },
            w1: u384 {
                limb0: 56319857011512348321450865913,
                limb1: 70026634536239217070202185070,
                limb2: 29578161044111817268515916582,
                limb3: 2817944977964708854636919980
            },
            w2: u384 {
                limb0: 52024570491103425957324401234,
                limb1: 15018823692040074558842996948,
                limb2: 58366755486725116294437124566,
                limb3: 1214838537770595627186415685
            },
            w3: u384 {
                limb0: 1844540906672150968519217,
                limb1: 75006449536430224846966161092,
                limb2: 1381619959718500685413699789,
                limb3: 2049325595779752026284404727
            },
            w4: u384 {
                limb0: 45216532092145998507428554215,
                limb1: 39954812488896760040804569540,
                limb2: 63678272389768618289789909221,
                limb3: 3280151631724133592401451854
            },
            w5: u384 {
                limb0: 32922692844418506098072139506,
                limb1: 39202583637065385215097616625,
                limb2: 77265206796348237450050050259,
                limb3: 169525003732004325450029922
            },
            w6: u384 {
                limb0: 10119406428823056448491077436,
                limb1: 2580569476998370565984990182,
                limb2: 17986547878148529452030246918,
                limb3: 5139097553906537322210580436
            },
            w7: u384 {
                limb0: 17111627909380895627710549638,
                limb1: 13155189739316313795208111890,
                limb2: 17220816716254638576879856284,
                limb3: 4309342325368399261410006881
            },
            w8: u384 {
                limb0: 51816124656713362039743001052,
                limb1: 8709993957094891717347674144,
                limb2: 3715542060972367505412628919,
                limb3: 3734578481479135211223246012
            },
            w9: u384 {
                limb0: 76291555447950681592322330715,
                limb1: 2409352879373955632952049978,
                limb2: 15105393069361004748395553427,
                limb3: 6027893118453820475671747999
            },
            w10: u384 {
                limb0: 976171933711563097235880322,
                limb1: 13060549631812202931302676838,
                limb2: 34670264518360599198732023536,
                limb3: 2879577090558928197666593379
            },
            w11: u384 {
                limb0: 13222935561214667125463885675,
                limb1: 11482777499398382552139836754,
                limb2: 799200910223880642223778722,
                limb3: 2941294881715773566758424365
            }
        };

        let c_or_cinv_of_z: u384 = u384 {
            limb0: 44058823348961669845351725826,
            limb1: 36140832690065360984381827261,
            limb2: 35188864335048699925257889371,
            limb3: 5380195243960243362845228594
        };

        let z: u384 = u384 {
            limb0: 33128909435567248936886551493,
            limb1: 9671193113341656765044786169,
            limb2: 419567455592164903,
            limb3: 0
        };

        let ci: u384 = u384 {
            limb0: 51603775801665415703969058943,
            limb1: 19202783631697856576494666575,
            limb2: 68145464515908768354082529737,
            limb3: 4956541774931764246778642757
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
                limb0: 54864124446520544468654946426,
                limb1: 32351593224865868159847881959,
                limb2: 37221122114150781613515691287,
                limb3: 7007980229903870529411338611
            },
            x1: u384 {
                limb0: 70595336922297820903850438000,
                limb1: 66910779901185360760204815243,
                limb2: 55907968143289251742609963263,
                limb3: 5942866562563088556551577850
            },
            y0: u384 {
                limb0: 2851512633377736873061909086,
                limb1: 34897864143629800460616322777,
                limb2: 68047274856795463604668365695,
                limb3: 2000052706971879466892411636
            },
            y1: u384 {
                limb0: 24822387735914106729738973109,
                limb1: 17209878954537921388858116431,
                limb2: 75912323029469845625100341882,
                limb3: 7131904319111084674443485663
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 22478809338244048395586503704,
                limb1: 43026657645098849162602273840,
                limb2: 43752983418860662208118707699,
                limb3: 4389342368584596660965536416
            },
            x1: u384 {
                limb0: 6438419876622856304248257459,
                limb1: 24847656453921747320173427416,
                limb2: 67796573260404223035246931901,
                limb3: 2419334529841667405676386278
            },
            y0: u384 {
                limb0: 56107169438494071983629723801,
                limb1: 33126151668865549337873551144,
                limb2: 55527333136791329397913535254,
                limb3: 5469161028487277104870243341
            },
            y1: u384 {
                limb0: 42173004889586961503076032795,
                limb1: 55789239067090891117583688290,
                limb2: 6082549911992608215825926516,
                limb3: 6123765095780853067714600409
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 52419269223539296699488571306,
            limb1: 60332881237676316066295862066,
            limb2: 47135872874019909515349464253,
            limb3: 3179527163153529491007181684
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 55743214842590837428317610990,
            limb1: 49142262234202874896232100664,
            limb2: 49242328239443282583904126725,
            limb3: 62439717735863034166378841
        };

        let ci_plus_one: u384 = u384 {
            limb0: 79011801503457134427696541455,
            limb1: 60032654732795047877378161507,
            limb2: 13388132445631221005924927511,
            limb3: 3559019390939555559830565581
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
            limb0: 72730203457035159744535293620,
            limb1: 42368347682454506776791959480,
            limb2: 53071050675743179107961356507,
            limb3: 4041392746888753412431932432
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 54804368608916515652109243430,
            limb1: 4577052551149187340213768625,
            limb2: 9406787882564822427365127758,
            limb3: 3899506517907578771951363314
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 28030709729678147260711758376,
                limb1: 14539052016061188738735723612,
                limb2: 64206192707326805407723151042,
                limb3: 5979271271567702149766274678
            },
            x1: u384 {
                limb0: 26447809150473315352385932764,
                limb1: 29513175706231315613138151892,
                limb2: 20080360825386521647602847571,
                limb3: 6200350609823968677912369166
            },
            y0: u384 {
                limb0: 54790473208455862136431301053,
                limb1: 14086872692715540268808566252,
                limb2: 5420664184841345749978004625,
                limb3: 7717289597953057600411222684
            },
            y1: u384 {
                limb0: 48317095893612380222256567091,
                limb1: 61237757538635065714107794930,
                limb2: 26129930916770932558830012236,
                limb3: 3165046085316044690612943721
            }
        };

        let Q_or_Qneg_0: G2Point = G2Point {
            x0: u384 {
                limb0: 19182855108172666069754576322,
                limb1: 74338872185838189027079405714,
                limb2: 57611270268097394316922964795,
                limb3: 2224112574075935228843946124
            },
            x1: u384 {
                limb0: 43260726738711351734595845124,
                limb1: 457131264109257633688639742,
                limb2: 28138638155168932429894614763,
                limb3: 6200899256852772865990099236
            },
            y0: u384 {
                limb0: 76235128833295447217353397838,
                limb1: 44510167634253346659789460522,
                limb2: 55354303975154767826483147783,
                limb3: 2513722671791160460516821304
            },
            y1: u384 {
                limb0: 10100708245853845831213412517,
                limb1: 52902917904033543619253275970,
                limb2: 35332300822334766325099287543,
                limb3: 4540773374076466649613438435
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 35286332103215059200630570936,
            limb1: 73477580253709784096190444729,
            limb2: 48278957729921935252933617350,
            limb3: 1643309349328573572643425052
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 32529290245604355253032708615,
            limb1: 76204906354557653960035954263,
            limb2: 79007895419137991925395629865,
            limb3: 345100085495531051336280686
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 39767512304992387073344341635,
                limb1: 20156303497907673672395144233,
                limb2: 55620801725986247366166822029,
                limb3: 6262511448193473950229108232
            },
            x1: u384 {
                limb0: 49577124054701041703334148789,
                limb1: 26009076314327494781225011806,
                limb2: 12858129699296530674962322375,
                limb3: 5733986395236330031950988560
            },
            y0: u384 {
                limb0: 46791378762964515205800160590,
                limb1: 35455776697702828779929816006,
                limb2: 28223487542264597876944145382,
                limb3: 5601035209701228862670246419
            },
            y1: u384 {
                limb0: 55886750365530846397249250730,
                limb1: 35888859299659016863166291694,
                limb2: 39232766626598465300101234577,
                limb3: 1251133459811483936559656640
            }
        };

        let Q_or_Qneg_1: G2Point = G2Point {
            x0: u384 {
                limb0: 36991698025458258193757083572,
                limb1: 25569386368306016153224717749,
                limb2: 38908334977575892542508849343,
                limb3: 1216465303949743924297510441
            },
            x1: u384 {
                limb0: 77273958831844657263512345885,
                limb1: 9371241419208259365138207328,
                limb2: 39926644658968646302647448678,
                limb3: 5455913382226804857359099197
            },
            y0: u384 {
                limb0: 60814300552765502455382829211,
                limb1: 7888076594946348835154818838,
                limb2: 25683413748881358798563221516,
                limb3: 1681873684406732077683644921
            },
            y1: u384 {
                limb0: 53127282450022664538887448520,
                limb1: 78255583368722981215406141107,
                limb2: 50265253743739478422104261296,
                limb3: 3548022695686693894037822914
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 59393940237879713611828215455,
            limb1: 45003947732161720717735204146,
            limb2: 33520871269334183071528514163,
            limb3: 833602475731403444553398658
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 54763691714657360072675052718,
            limb1: 5976824731097632252607704559,
            limb2: 3581653537686133215232538051,
            limb3: 7931086514752200684748764705
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 77148412538141401517990215761,
                limb1: 43487067152509598935301702594,
                limb2: 20591765840703438172751042179,
                limb3: 4699694416958019767323479847
            },
            x1: u384 {
                limb0: 63546246259595325385700633423,
                limb1: 65637328850919844576695821384,
                limb2: 16860577626359041875606266510,
                limb3: 3029219848047475042283932998
            },
            y0: u384 {
                limb0: 62041314916240645596429785656,
                limb1: 32659791884224052055427389781,
                limb2: 66543558529793320913236209778,
                limb3: 4337040886812493599493326532
            },
            y1: u384 {
                limb0: 55462852640573018364346267199,
                limb1: 3924686583099097371908907300,
                limb2: 30932100057331921651747240244,
                limb3: 4737585024377529357045559162
            }
        };

        let Q_or_Qneg_2: G2Point = G2Point {
            x0: u384 {
                limb0: 47298976199908053179679581535,
                limb1: 75212707772032114244302740522,
                limb2: 61306038013671102549863514417,
                limb3: 4437192412497575962194073101
            },
            x1: u384 {
                limb0: 56031159530951016963905733456,
                limb1: 8879016937469904145335149511,
                limb2: 7011979050847407203689242288,
                limb3: 3054583079046064227995107698
            },
            y0: u384 {
                limb0: 32250544119458057266661361312,
                limb1: 59195345002901335107403663989,
                limb2: 64586965203787230400184611123,
                limb3: 1868606867471502562677197022
            },
            y1: u384 {
                limb0: 15253762193898789745969519646,
                limb1: 64604582272002868382510178411,
                limb2: 57846914880549668605145978047,
                limb3: 3476759926683426233592589885
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 43785592187407148661337049841,
            limb1: 59208782605981833225431257960,
            limb2: 20400473739495234456676182034,
            limb3: 5695968971295896084504909385
        };

        let f_i_of_z: u384 = u384 {
            limb0: 24639852562342425764108632630,
            limb1: 59443133431771384080136212505,
            limb2: 216825439305219656582999650,
            limb3: 5183909170010778388904412582
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 62745098794378860176439461190,
                limb1: 59722813847369576368804912504,
                limb2: 40807907820439384864884700956,
                limb3: 4026044120481423466618696474
            },
            w1: u384 {
                limb0: 28699070675811055201161387651,
                limb1: 73461300418773285228346688567,
                limb2: 48195327661704400331841446641,
                limb3: 3788829888854518918769003090
            },
            w2: u384 {
                limb0: 24764187902938064327656719853,
                limb1: 635340396313941278661485105,
                limb2: 49355918849866001621486627540,
                limb3: 6315280404127191545049577649
            },
            w3: u384 {
                limb0: 33055291441478943017513253333,
                limb1: 26629801176383853988931158095,
                limb2: 26950822721011771334246588071,
                limb3: 7018236388449007467812611013
            },
            w4: u384 {
                limb0: 21725212723726705960956810924,
                limb1: 69902801017166288266597114501,
                limb2: 46329695183232762494891124023,
                limb3: 6031124167021641362808844472
            },
            w5: u384 {
                limb0: 21871370488560534749338162075,
                limb1: 18934805261573608385602450461,
                limb2: 74384134337036615527841006813,
                limb3: 1155611254353346486333854682
            },
            w6: u384 {
                limb0: 35753471555060214368483249786,
                limb1: 21668241751751896091135825822,
                limb2: 38600747573556649253974001913,
                limb3: 3302524063708241411442935076
            },
            w7: u384 {
                limb0: 20808824751206175567900997575,
                limb1: 24173294201469343146272317759,
                limb2: 59381116372697547563642808753,
                limb3: 5741342875693481531166773047
            },
            w8: u384 {
                limb0: 7206633672202457954114386748,
                limb1: 9978049755745824379211526038,
                limb2: 6804284323218965649669850918,
                limb3: 5862423072161315717189124581
            },
            w9: u384 {
                limb0: 22954040905588412294482773614,
                limb1: 78735021656283759468626061113,
                limb2: 13189328764351009546068887508,
                limb3: 4684255416077327918952297823
            },
            w10: u384 {
                limb0: 69748335189421106925686152597,
                limb1: 21678654778559968294217036347,
                limb2: 69819985337125939343352665474,
                limb3: 7463702344427483351589179362
            },
            w11: u384 {
                limb0: 20541965722535171864514201309,
                limb1: 23090464266988116687409907162,
                limb2: 31717745693958153970859562605,
                limb3: 7234561974098479567553330158
            }
        };

        let c_or_cinv_of_z: u384 = u384 {
            limb0: 5492444125770296115144941677,
            limb1: 67230793653299440429643162331,
            limb2: 13093411455102125566410886228,
            limb3: 5763558773787275568628366529
        };

        let z: u384 = u384 {
            limb0: 35200864097022736421578250167,
            limb1: 59859392648554654047928772146,
            limb2: 358651027438199687,
            limb3: 0
        };

        let ci: u384 = u384 {
            limb0: 70571666737348467421687747036,
            limb1: 14174775864310595588553381481,
            limb2: 1176745123331244648700356511,
            limb3: 1619229319481912672186823000
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
                limb0: 65339731523906943051196176991,
                limb1: 12048417937426079559547660920,
                limb2: 59167630312177176109893933703,
                limb3: 7455790851846236913195515635
            },
            x1: u384 {
                limb0: 40970890183176424994077306024,
                limb1: 4026898449971528095302682620,
                limb2: 5984663664929878063007632,
                limb3: 3367517541712858531653757478
            },
            y0: u384 {
                limb0: 37218830982864602096060880012,
                limb1: 11472525229194963837458266080,
                limb2: 6476164707508838408015392419,
                limb3: 4188907981753490833063571985
            },
            y1: u384 {
                limb0: 49972044868790292433734154408,
                limb1: 43653212309123240396206153381,
                limb2: 32789990287400965051194591795,
                limb3: 289688087696702638499513484
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 72852937042034705926696742536,
                limb1: 53770046089748114621353350486,
                limb2: 47297083327536253280559311135,
                limb3: 6614894548588481497032673616
            },
            x1: u384 {
                limb0: 34268131201646875540203457134,
                limb1: 29899868925908198706894610917,
                limb2: 12217169035436932063463712133,
                limb3: 6266449249476103969129851020
            },
            y0: u384 {
                limb0: 12969196548522761197416640563,
                limb1: 63790622838590646960502779003,
                limb2: 33239523076980257386739398927,
                limb3: 1195488389360325546190415555
            },
            y1: u384 {
                limb0: 53402546591963423691403796390,
                limb1: 19380300523190898798403952436,
                limb2: 14314346829660130803957107873,
                limb3: 22194861137754395140120639
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 20381018054101382501136491259,
                limb1: 1425712863885295862922449419,
                limb2: 74767582927696721623531103704,
                limb3: 8032415201811285361547094910
            },
            x1: u384 {
                limb0: 66721147200326499457913961482,
                limb1: 62645181854952582657094914785,
                limb2: 48071161828611641918825695086,
                limb3: 3080348265857736148890662371
            },
            y0: u384 {
                limb0: 44517545402676547053361103767,
                limb1: 69472875909219975809418712182,
                limb2: 19788365270345575085600401093,
                limb3: 7699785032889210775730702468
            },
            y1: u384 {
                limb0: 48852507893029641606170968410,
                limb1: 53340611715460769107716814030,
                limb2: 28077538842843338832234384005,
                limb3: 440509165369881453933187590
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 914616854722589980275904172,
            limb1: 32681022408727894305365013613,
            limb2: 45734597503692357443213471882,
            limb3: 6625823751434744082728499266
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 33300097882379172650647815440,
            limb1: 67871709066997891029223922785,
            limb2: 6530905303229075936833752966,
            limb3: 508824262073109402905503863
        };

        let ci_plus_one: u384 = u384 {
            limb0: 34298451670460569802147208738,
            limb1: 64049829848925830747540468512,
            limb2: 65386669998672169336542278370,
            limb3: 599351839413975929173050519
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
                limb0: 32053033364658852529969493870,
                limb1: 18495616947901179258335097484,
                limb2: 55444711139904980435858224443,
                limb3: 2760475910627651416222935145
            },
            w1: u384 {
                limb0: 27067254269038406269563405707,
                limb1: 72212958391055975030976800708,
                limb2: 70733622924906216909614281690,
                limb3: 4830889001790608734657237811
            },
            w2: u384 {
                limb0: 6598156910626475321502916138,
                limb1: 12939195659509401526788123955,
                limb2: 25773531279050407613580303518,
                limb3: 3375262338692043008650107659
            },
            w3: u384 {
                limb0: 47226467657298303411443117,
                limb1: 38107736080695166325732004371,
                limb2: 19265608464951493925441719374,
                limb3: 2286365620906038456035503669
            },
            w4: u384 {
                limb0: 2443698108737622430569120326,
                limb1: 61047330553137252378087501185,
                limb2: 141502420910561654226241765,
                limb3: 3841438190446097504874729629
            },
            w5: u384 {
                limb0: 54418748870383303394563882440,
                limb1: 65847368572270400635655805659,
                limb2: 69464280534676032419994195397,
                limb3: 269467775594240023194660313
            },
            w6: u384 {
                limb0: 33488973427637373112598307469,
                limb1: 5110088020272894063456287220,
                limb2: 53636484022663668209975487325,
                limb3: 3345286048562445000643863077
            },
            w7: u384 {
                limb0: 71402729831051960022958789216,
                limb1: 48892116270658859643649380573,
                limb2: 55191701100103344604313468724,
                limb3: 2356491892774991612243135383
            },
            w8: u384 {
                limb0: 42321390774533748835929154129,
                limb1: 62102222650638372857229717440,
                limb2: 61848124502124622604733842660,
                limb3: 6095177469505221731686594459
            },
            w9: u384 {
                limb0: 79069949946701223435385718754,
                limb1: 64995744170704478988881645184,
                limb2: 31856562955736472173405715457,
                limb3: 5898135204919462491298571572
            },
            w10: u384 {
                limb0: 62776698776738970231944213748,
                limb1: 12691054048174824881615050452,
                limb2: 16482106156017854929287579066,
                limb3: 4673535006513413340139987509
            },
            w11: u384 {
                limb0: 33052456600191982767242220293,
                limb1: 58520095821299497652564221037,
                limb2: 73926098170719915134122481913,
                limb3: 6430236531651067115476418355
            }
        };

        let c_n_minus_2: u384 = u384 {
            limb0: 38264982501671486661177071701,
            limb1: 65261303476750415664012159567,
            limb2: 69988148794680050502306625089,
            limb3: 4818870567133329126088923702
        };

        let w_of_z: u384 = u384 {
            limb0: 15968475439207864323712152554,
            limb1: 3908999041672246436619194480,
            limb2: 70420732835052868175121470780,
            limb3: 5222978472646080432657617917
        };

        let z: u384 = u384 {
            limb0: 77385356695647580477584212640,
            limb1: 24853822489043390814719421839,
            limb2: 66541368384682238303908761455,
            limb3: 2802099651898278019378300681
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 20064406501945637066680712135,
            limb1: 12857810260663246545562282039,
            limb2: 8788960143186989644943717477,
            limb3: 917985865295109274393033464
        };

        let previous_lhs: u384 = u384 {
            limb0: 17543477664942652792541702646,
            limb1: 35095884071609768363756153182,
            limb2: 49541450673748510485568169315,
            limb3: 5169351577872824417247783642
        };

        let R_n_minus_2_of_z: u384 = u384 {
            limb0: 14824777165173269366173068001,
            limb1: 10354783414876108801516345158,
            limb2: 44213889333696942873394942892,
            limb3: 3562934604448653337723011457
        };

        let Q: Array<u384> = array![
            u384 {
                limb0: 48306974624131187031637175867,
                limb1: 60455777947561052682685252183,
                limb2: 2623718293688685161295544975,
                limb3: 648319825514383639307071563
            },
            u384 {
                limb0: 12658823668845791039541006693,
                limb1: 55626632673591172209565537475,
                limb2: 13373413907126898891484404360,
                limb3: 4571263001286497515245189512
            },
            u384 {
                limb0: 7913223376630174061951132585,
                limb1: 27830852695631861792163241312,
                limb2: 65405790609798025367625426566,
                limb3: 2219180825791224297111981178
            },
            u384 {
                limb0: 48305100341870281630928151508,
                limb1: 10837663163384491372774859629,
                limb2: 62565417513332866180215685370,
                limb3: 5216401638382249621207608432
            },
            u384 {
                limb0: 30588658949421083489607804922,
                limb1: 67644156434400335333086916223,
                limb2: 39415384996462602206246843377,
                limb3: 1747657399072551826854393405
            },
            u384 {
                limb0: 58726470025715286157904307245,
                limb1: 8902456146128354121109575342,
                limb2: 65939087069638670779851731134,
                limb3: 3448225254878114058688350240
            },
            u384 {
                limb0: 65765608689235214961392780966,
                limb1: 14447510554609009663791093777,
                limb2: 44123727001282359269590530906,
                limb3: 2213071072291566186415149369
            },
            u384 {
                limb0: 37223805109745411702397405999,
                limb1: 14250706159832082730849267816,
                limb2: 77881943371611878175535773808,
                limb3: 2640482562420738658519325095
            },
            u384 {
                limb0: 7481227796669216354481512631,
                limb1: 38946960421249620747408634594,
                limb2: 3132219225080190058661193282,
                limb3: 2486646847581141239391139519
            },
            u384 {
                limb0: 64952875624115477762709373115,
                limb1: 74896459606347528135942084092,
                limb2: 38174464860397110149758649699,
                limb3: 3332441441544602665746027810
            },
            u384 {
                limb0: 37708664722571618530285097275,
                limb1: 43151880070432930841333142593,
                limb2: 3018668081926138621518928752,
                limb3: 712622718388212867035261125
            },
            u384 {
                limb0: 14898139456348135242540803173,
                limb1: 50817061599472673599336516347,
                limb2: 25049846571178189063310691936,
                limb3: 5321003775423795934564843308
            },
            u384 {
                limb0: 43044806575612740935088538015,
                limb1: 19275620428477674688630790518,
                limb2: 1814231046278153617147754907,
                limb3: 130207641070578213440370650
            },
            u384 {
                limb0: 31863416310048905761271049771,
                limb1: 11484293904943853874933024486,
                limb2: 54612051903704948014878234243,
                limb3: 7541166235990088482971596150
            },
            u384 {
                limb0: 64596329400725793317447558510,
                limb1: 35114528423773423117406487960,
                limb2: 51635140587527647885191342237,
                limb3: 3794431417386774424238307215
            },
            u384 {
                limb0: 69423590301545487080666560980,
                limb1: 46756286680052692233281432927,
                limb2: 75746556398335475105940686235,
                limb3: 7777874349356550471973549000
            },
            u384 {
                limb0: 71791049757054790804276670784,
                limb1: 47056173543686334628581929065,
                limb2: 43231595027426812176081306811,
                limb3: 7391309657851645984714201709
            },
            u384 {
                limb0: 30477709353769767716251641189,
                limb1: 9251107245548913567377126789,
                limb2: 35008087239940620110854835198,
                limb3: 1125905817711225927638415947
            },
            u384 {
                limb0: 38848823651518232198054799012,
                limb1: 70495230194454720270778264185,
                limb2: 71785763728432774502390452255,
                limb3: 5290216536712999915069377885
            },
            u384 {
                limb0: 14228899546148102209382433514,
                limb1: 50871861778347238024992248768,
                limb2: 32093659800135220783903810877,
                limb3: 330490002836669217260731276
            },
            u384 {
                limb0: 51707735450428401784990347545,
                limb1: 61586664388599067930098772195,
                limb2: 8018075165007886275572014095,
                limb3: 1716566288234960805748179763
            },
            u384 {
                limb0: 55573766064869255421569559276,
                limb1: 34199916285655595488482901434,
                limb2: 15411625923123117115101596690,
                limb3: 2444925803260051205227775030
            },
            u384 {
                limb0: 41893902327887418483139402585,
                limb1: 16310159019300800327391790607,
                limb2: 78372308220937060574249855499,
                limb3: 3049527828729588758093183682
            },
            u384 {
                limb0: 33215762663560764961292996845,
                limb1: 48721934890634383298308378924,
                limb2: 48846754960882145059582153677,
                limb3: 5732867800210371726568764854
            },
            u384 {
                limb0: 23444709200185116936537904641,
                limb1: 44424937837824931738016302888,
                limb2: 27301608792660918188761243092,
                limb3: 3094993237701789789047197376
            },
            u384 {
                limb0: 47619719183607272729864545191,
                limb1: 67991148538897583251799895312,
                limb2: 46099703253061318629570366207,
                limb3: 7690851914890271500289336454
            },
            u384 {
                limb0: 26722969655302762321327915098,
                limb1: 44111173449250496862765204587,
                limb2: 77258953736430127362675360953,
                limb3: 7064604101941242253001665068
            },
            u384 {
                limb0: 37771504645627710790647889684,
                limb1: 60359236335940203476190757373,
                limb2: 11871823917457089549684331735,
                limb3: 7654759486785791450750743495
            },
            u384 {
                limb0: 10198778573733641398215263066,
                limb1: 64890082426866849470613205324,
                limb2: 45133584419357391920048022208,
                limb3: 7031812004239965458206846433
            },
            u384 {
                limb0: 13150469210758147344549173944,
                limb1: 69028655788173242554096703468,
                limb2: 20351813693770136194373195176,
                limb3: 6240541772632785412281598376
            },
            u384 {
                limb0: 30919939516595875757580122634,
                limb1: 34236790641314697770876689279,
                limb2: 75864305079495125570572872916,
                limb3: 7368999539142500978061619252
            },
            u384 {
                limb0: 1441055445764498759507990117,
                limb1: 48218514104269595152243606958,
                limb2: 78886972706278719063796662661,
                limb3: 5862080000154623893684688895
            },
            u384 {
                limb0: 30599120755981145797512290223,
                limb1: 57592764127642147399218817257,
                limb2: 64100178652818625741660721152,
                limb3: 3049032100093753872061967126
            },
            u384 {
                limb0: 11307344017871365547427185936,
                limb1: 16229281386944205731637585732,
                limb2: 36243853442590293197223724821,
                limb3: 1154792673175425205809706028
            },
            u384 {
                limb0: 76387176695850996822129638685,
                limb1: 33224370037693251783381749744,
                limb2: 21251734988871035973758764537,
                limb3: 6256534390042353339002291287
            },
            u384 {
                limb0: 77659120362567054280083512,
                limb1: 25254308972670144270559917217,
                limb2: 7829708998936298081184740981,
                limb3: 890506833820674865696831714
            },
            u384 {
                limb0: 3316563514538003483712121271,
                limb1: 56467391674193857771677682565,
                limb2: 19478925371765836454993715487,
                limb3: 5523575666048095997964246529
            },
            u384 {
                limb0: 49097067439572467528591930624,
                limb1: 48137997052982465451158622278,
                limb2: 6822270523533317607515048887,
                limb3: 5061973159453636744438188412
            },
            u384 {
                limb0: 71768767710110472271357215618,
                limb1: 25023405562579157345852379657,
                limb2: 50887823546351449353720001269,
                limb3: 829666448880256771857278399
            },
            u384 {
                limb0: 14218162419144340974446556792,
                limb1: 18651579888991308674101678501,
                limb2: 41590168488912219929363914879,
                limb3: 927696879401630456086438747
            },
            u384 {
                limb0: 40667417821363130702696651846,
                limb1: 56765883496699719609970725706,
                limb2: 21489247659908436332737180090,
                limb3: 4396340210894110318081775147
            },
            u384 {
                limb0: 12998434868010149874758864,
                limb1: 32393027210574127900869090758,
                limb2: 27304771704845742237014626890,
                limb3: 5398304351734456798300523629
            },
            u384 {
                limb0: 70193930497930535675182546586,
                limb1: 29447437139650233797318141631,
                limb2: 7829980842099156813375972583,
                limb3: 5141941003860349791651038082
            },
            u384 {
                limb0: 2753553142394464492548776390,
                limb1: 43426524407986480222081438342,
                limb2: 45353337737736079806758941047,
                limb3: 886063015475913679914640252
            },
            u384 {
                limb0: 59755812520636144212373636700,
                limb1: 7831679770230030060982326452,
                limb2: 72729168654875486375991149657,
                limb3: 3865809418541023590256254708
            },
            u384 {
                limb0: 32002019599576381893179825373,
                limb1: 28445840812277435391730183709,
                limb2: 61150569186684674646229754989,
                limb3: 922252891889048285430144990
            },
            u384 {
                limb0: 10817647929942335364994085225,
                limb1: 2477018931521157702020011994,
                limb2: 70683416398934628608343460538,
                limb3: 1708497159688889553141950108
            },
            u384 {
                limb0: 63752987351864231496058621442,
                limb1: 28141031164735047743438875925,
                limb2: 74822220035287157602214364141,
                limb3: 6696493130626128878919983571
            },
            u384 {
                limb0: 61244148157511642044241087190,
                limb1: 6029466511665308901499214192,
                limb2: 68788984702589722560385962269,
                limb3: 1764174819686389434640193676
            },
            u384 {
                limb0: 34943318913327440842082604526,
                limb1: 61890609242976437228469401688,
                limb2: 78417912972001965738113013319,
                limb3: 6077613530621148070751188939
            },
            u384 {
                limb0: 39074775069830346874069240688,
                limb1: 4640966399459683089964454628,
                limb2: 12336472271743672522858067198,
                limb3: 7367024763095740274635317982
            },
            u384 {
                limb0: 56155826008165904602036535662,
                limb1: 15379282338514445454457859937,
                limb2: 63137041596227786527523502087,
                limb3: 392300812103821855829437097
            },
            u384 {
                limb0: 44360444706577609420588247243,
                limb1: 1753409855242410959752245309,
                limb2: 5325216943891375136824774812,
                limb3: 5328178608828515734752312920
            },
            u384 {
                limb0: 15779252517888446678774172709,
                limb1: 50536614246027970202240213508,
                limb2: 55980546834330134515084492611,
                limb3: 6543320956341677268034058977
            },
            u384 {
                limb0: 58022553072531840003788656278,
                limb1: 49473980789873217070006381900,
                limb2: 36595973113815146379232680432,
                limb3: 2684368378764168811974495954
            },
            u384 {
                limb0: 60803895374345533325287255964,
                limb1: 55819765782286329944801626128,
                limb2: 13839166161362154724746295799,
                limb3: 1961607540735620790967955859
            },
            u384 {
                limb0: 14416280251615715231928225530,
                limb1: 48287746074322277746956867686,
                limb2: 58616742618413433257289406847,
                limb3: 1751079747313332025037447844
            },
            u384 {
                limb0: 32705553611816928863704986227,
                limb1: 72155344667867789125036051284,
                limb2: 65318819098222912365122621599,
                limb3: 7795251174760525221109803984
            },
            u384 {
                limb0: 58560881510890780490894084743,
                limb1: 27721638145084639353650689478,
                limb2: 729396447281202017801950809,
                limb3: 4766391584498605590326070375
            },
            u384 {
                limb0: 30909564512080619504747630078,
                limb1: 50273777762201758036988594352,
                limb2: 64037084179558428508784712461,
                limb3: 5007869461362704429816925777
            },
            u384 {
                limb0: 2139780756541383821565472794,
                limb1: 18204444344549953061329052917,
                limb2: 24390490183517180587275860816,
                limb3: 2511305019183052730714143150
            },
            u384 {
                limb0: 22008788650588278669120965841,
                limb1: 1948863667824864332880454178,
                limb2: 48495536770756850743816645470,
                limb3: 5568687830839230844076852528
            },
            u384 {
                limb0: 68675918385557188996870313558,
                limb1: 71072900392044069740541182608,
                limb2: 4335132458944119996113539951,
                limb3: 5457182510157727171768228696
            },
            u384 {
                limb0: 3515411695470863870360334077,
                limb1: 57250170170434585613612275633,
                limb2: 54444645528324281637101967036,
                limb3: 5696509065652132550374696640
            },
            u384 {
                limb0: 19132493567347082661042748343,
                limb1: 45042475276108777581923457978,
                limb2: 57376378660442759636974849191,
                limb3: 7778968295876248380542762795
            },
            u384 {
                limb0: 23256655639584726667252290051,
                limb1: 54453301719182593785297007227,
                limb2: 43349499232955693325687203784,
                limb3: 2044220390424051170197772717
            },
            u384 {
                limb0: 53688267385832928052564202524,
                limb1: 61756137895077460684169148130,
                limb2: 21787197311366765156617640634,
                limb3: 2203265708022591647022114766
            },
            u384 {
                limb0: 74641879966706041208541383099,
                limb1: 67392050079438400366084797493,
                limb2: 1444133017467918265328428597,
                limb3: 7029161705697667533809417325
            },
            u384 {
                limb0: 21328574556209809710945007337,
                limb1: 17183579218503825442147467871,
                limb2: 30014242023272354882303475134,
                limb3: 5498400446052287345105233271
            },
            u384 {
                limb0: 56146328787557681909618898089,
                limb1: 62163647911694808545567789306,
                limb2: 20634627971903128460278884306,
                limb3: 2878505513087740004361798008
            },
            u384 {
                limb0: 26873300066058035819482101935,
                limb1: 291736369689665684553663772,
                limb2: 262368480663317502609135666,
                limb3: 1232478617240384927664010066
            },
            u384 {
                limb0: 64575615299081190367079816732,
                limb1: 47212304509922125240372640551,
                limb2: 38014311243424200300103885819,
                limb3: 5501085866345494672256445052
            },
            u384 {
                limb0: 12516719950865231791675720025,
                limb1: 46800476456872398808464744822,
                limb2: 8400333911819654780728110533,
                limb3: 1387005794103013270950528231
            },
            u384 {
                limb0: 62083752815061786457340168104,
                limb1: 23958095586977147256982977394,
                limb2: 47303106644518474462621076542,
                limb3: 2240785811740595092293183063
            },
            u384 {
                limb0: 3405224008843188279943839557,
                limb1: 4844941268332885030690225939,
                limb2: 36737955957145181478142222579,
                limb3: 2051906325856245489961735294
            },
            u384 {
                limb0: 25910559954901455673852581438,
                limb1: 66505550726883800359487168530,
                limb2: 39979056700728891949221795517,
                limb3: 7264772066972332221980381079
            },
            u384 {
                limb0: 33304653476932332324686117076,
                limb1: 2836301169805633657866686057,
                limb2: 63437078202229537553362230211,
                limb3: 7465085807067466015632180782
            },
            u384 {
                limb0: 5187290890938835376741163490,
                limb1: 17145629802871490570055124014,
                limb2: 5600002808558063820510027943,
                limb3: 7820401064645279154862854023
            },
            u384 {
                limb0: 24495076738557726611919578395,
                limb1: 17600096720745791767624617361,
                limb2: 73956252323851607890222047696,
                limb3: 1768485584527146006310427459
            },
            u384 {
                limb0: 35819892007721159075744451113,
                limb1: 42563223971921520483637182941,
                limb2: 3421651233573631873847583531,
                limb3: 156202648005173384434210948
            },
            u384 {
                limb0: 43642065884471349054122038294,
                limb1: 38681252361524046836106481504,
                limb2: 43886282026719744959828964798,
                limb3: 4961817203090963437802919252
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
            limb0: 29080697335086178282887174339,
            limb1: 15108203722927360772274845044,
            limb2: 7062611699672404635663191184,
            limb3: 2891848092403832191607072674
        };
        assert_eq!(final_check_result, final_check);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_FINALIZE_BLS_3_circuit_BLS12_381() {
        let R_n_minus_1 = E12D {
            w0: u384 {
                limb0: 17467003444348413142417282614,
                limb1: 9935357734548662250193025277,
                limb2: 59515054660597971632576902503,
                limb3: 1669612295527005424926839696
            },
            w1: u384 {
                limb0: 18739777721744655619707344971,
                limb1: 7579784377868116803450133286,
                limb2: 69017361034969537961334487941,
                limb3: 3165709515893707656570101354
            },
            w2: u384 {
                limb0: 34044992942628281369160266315,
                limb1: 35141420408805106395312077804,
                limb2: 19014603636273710085961595287,
                limb3: 2649116700029292027810121528
            },
            w3: u384 {
                limb0: 70766126478567825523390411151,
                limb1: 790307353814137028809153845,
                limb2: 35738212180939116382506242981,
                limb3: 491145178840991410359304373
            },
            w4: u384 {
                limb0: 53623984904955271798125832659,
                limb1: 13701001474653438578512041588,
                limb2: 66660247051832055097333889159,
                limb3: 2499033200474246975044007713
            },
            w5: u384 {
                limb0: 75591726378748111604270563132,
                limb1: 63318077365311484308709068365,
                limb2: 32324131374406581923176797176,
                limb3: 5234038421573203131043231631
            },
            w6: u384 {
                limb0: 76187545141267944696954480130,
                limb1: 27559483142278809409006271360,
                limb2: 21014368436608919476711297891,
                limb3: 4255247722586966336642077385
            },
            w7: u384 {
                limb0: 60535822768034834346437757300,
                limb1: 42757328009540641994684678389,
                limb2: 44027215559217934943594884277,
                limb3: 4149421395549153474311274606
            },
            w8: u384 {
                limb0: 23789306892033963369223587048,
                limb1: 64373418948190093174100316229,
                limb2: 53822294888687968881418425903,
                limb3: 123440186447679959550135346
            },
            w9: u384 {
                limb0: 19648965682684727846159720262,
                limb1: 5896733659354321178271267304,
                limb2: 3338618247389494202988738222,
                limb3: 5894650200041970933278065527
            },
            w10: u384 {
                limb0: 54553732411284050421473649096,
                limb1: 33724596228967492684814740530,
                limb2: 28457968507306839359212332809,
                limb3: 5804100123777112765549576912
            },
            w11: u384 {
                limb0: 608165970703833678374059326,
                limb1: 16693144142878316012804043771,
                limb2: 43329102268628002609164370648,
                limb3: 7066638508912192164993417261
            }
        };

        let c_n_minus_2: u384 = u384 {
            limb0: 37591099618169554678772525609,
            limb1: 38892874103281493809015851199,
            limb2: 29120154087203424888151679467,
            limb3: 5842955861141092076283902161
        };

        let w_of_z: u384 = u384 {
            limb0: 43281345093236762575467550044,
            limb1: 23381777968865011001840941682,
            limb2: 74992403900395793949574125547,
            limb3: 4852290725092107186639048123
        };

        let z: u384 = u384 {
            limb0: 58518369684159648075290371922,
            limb1: 362524804795365338225269038,
            limb2: 30864592226966197842623365559,
            limb3: 6363144557421165649942328439
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 15186604655246920716193164747,
            limb1: 56907797954016787862966916320,
            limb2: 45228187207104403224302836175,
            limb3: 6506932793111986608747714012
        };

        let previous_lhs: u384 = u384 {
            limb0: 53371511164683140700704516953,
            limb1: 64970592199100328470423780720,
            limb2: 42452175281797561206213413593,
            limb3: 5845177305364172914219903484
        };

        let R_n_minus_2_of_z: u384 = u384 {
            limb0: 56199156418910690549189533403,
            limb1: 34964318063987547298808348518,
            limb2: 39367260600794379783677281199,
            limb3: 2798121330619970008156225379
        };

        let Q: Array<u384> = array![
            u384 {
                limb0: 6924055980837258658778823674,
                limb1: 68515594365633089132318340303,
                limb2: 67313309135408780829737105685,
                limb3: 2346638059469374513177586171
            },
            u384 {
                limb0: 59192892973122562816220752613,
                limb1: 25654502174416453316310460373,
                limb2: 38884032972043272759511401861,
                limb3: 7601559300838189312753484338
            },
            u384 {
                limb0: 27999566730295875408650895361,
                limb1: 64205730800390098771145316879,
                limb2: 12178618524257677014618199771,
                limb3: 1232368529530890363909470732
            },
            u384 {
                limb0: 8657198716608933359591540465,
                limb1: 63124159325420829962766647217,
                limb2: 38387168928337320736305720345,
                limb3: 3169617153237027424367652483
            },
            u384 {
                limb0: 18947231577932277754309016830,
                limb1: 39872006665138285544692005021,
                limb2: 21238645457729865650342533412,
                limb3: 3861500560898437704044747269
            },
            u384 {
                limb0: 51538615244694281268346387733,
                limb1: 27334094958649402483929963671,
                limb2: 65732916040029841201190636469,
                limb3: 3704602026462070104784351692
            },
            u384 {
                limb0: 58704204722230467578604158192,
                limb1: 19319283056308127045287379982,
                limb2: 51608587786301311682880891360,
                limb3: 6670909027327009568612695610
            },
            u384 {
                limb0: 19975003353544292414851010312,
                limb1: 20017554227268603330869733142,
                limb2: 8434294882762473398904356163,
                limb3: 5707330174552362832333593379
            },
            u384 {
                limb0: 42357882551471358678470011812,
                limb1: 73384240178269546075295502899,
                limb2: 67311417017125996813345439298,
                limb3: 5346899562193424668448154033
            },
            u384 {
                limb0: 62123080514190694439861073335,
                limb1: 14372322658561904430453285476,
                limb2: 8936907324831619390672876563,
                limb3: 1726171383618991506250422320
            },
            u384 {
                limb0: 24779819406992189257137750801,
                limb1: 12453540767035962353767663612,
                limb2: 55220248879259617557326923761,
                limb3: 4316609839715190898162350977
            },
            u384 {
                limb0: 64675538066663372532188766557,
                limb1: 36399372410523431734229957060,
                limb2: 54639893867996596121792729345,
                limb3: 124794574914591686012069089
            },
            u384 {
                limb0: 68941717771035026172594216273,
                limb1: 69888694255781384503980554138,
                limb2: 14889768806425970195976968735,
                limb3: 879069331192696669862072638
            },
            u384 {
                limb0: 74231318590601294959455715530,
                limb1: 58995473631361291416943127608,
                limb2: 57147850527371997777995259229,
                limb3: 3092233076067932128966116491
            },
            u384 {
                limb0: 28736977893059688690516584409,
                limb1: 17417962931461106133294631327,
                limb2: 2322655885755958718329794395,
                limb3: 375365561626223052202482242
            },
            u384 {
                limb0: 54884711425067333034700536305,
                limb1: 21211260000516541392430678494,
                limb2: 6442325918890803745871522847,
                limb3: 6806826365398414732214735827
            },
            u384 {
                limb0: 56792091981569611636635023625,
                limb1: 78027796807570936147576021458,
                limb2: 45003121850504800325194588171,
                limb3: 1137379472753801834294277416
            },
            u384 {
                limb0: 18981408096308133272757967216,
                limb1: 74201512658312190032691869379,
                limb2: 34500212528761719145118059499,
                limb3: 491095039015270646185355137
            },
            u384 {
                limb0: 4946449240413281595236999103,
                limb1: 22215999099702817336155113476,
                limb2: 63909482656523220896537396981,
                limb3: 3986300069913763514377976112
            },
            u384 {
                limb0: 8946090910230794013087858151,
                limb1: 22601362570810658898588258412,
                limb2: 76251947559613459581696360412,
                limb3: 5472145425853982697024835448
            },
            u384 {
                limb0: 44539580622407471849588533572,
                limb1: 38669908884935191985589763382,
                limb2: 66767385707939206735789431438,
                limb3: 487574849850147959069852016
            },
            u384 {
                limb0: 16250866596011407847330699037,
                limb1: 64442983917428458613787098747,
                limb2: 5735367810365963886361953916,
                limb3: 7288568436509763370177643081
            },
            u384 {
                limb0: 51875323904383445762623063079,
                limb1: 16623507749015485972031375897,
                limb2: 67875983111239267738100113656,
                limb3: 3360312203048969860701908512
            },
            u384 {
                limb0: 27611657270240949499611933427,
                limb1: 56662121892359303298103986161,
                limb2: 34456653886394018336163679176,
                limb3: 5878689703203239612667320017
            },
            u384 {
                limb0: 74182077945798977944537461089,
                limb1: 12059676957194840709162381464,
                limb2: 63496345120328316132662023119,
                limb3: 3935308318249066475000421478
            },
            u384 {
                limb0: 10324756086126905050014637661,
                limb1: 61340891841709679603585901582,
                limb2: 21167259776568331988943612740,
                limb3: 6412096318302745513201305425
            },
            u384 {
                limb0: 62215777594493570392005355965,
                limb1: 64329468450006470861752421538,
                limb2: 69487784304162755002330516410,
                limb3: 3194237196883287709910935253
            },
            u384 {
                limb0: 51818794988693222998795472562,
                limb1: 25150961699663014588880066305,
                limb2: 53502207189753564547265777811,
                limb3: 1810265830617726324926632608
            },
            u384 {
                limb0: 46523477203229458142634260527,
                limb1: 29730139778729849299945485041,
                limb2: 61005190089301915195337348157,
                limb3: 5854854212787896391228195294
            },
            u384 {
                limb0: 49808623731714341074831753520,
                limb1: 19625693362106342900440368054,
                limb2: 23739495186643297830990740181,
                limb3: 1813804386224106030060296807
            },
            u384 {
                limb0: 28685171248754720245531281099,
                limb1: 40316471215160535089258059743,
                limb2: 46816614140568301237719593694,
                limb3: 7320120417413001112255600361
            },
            u384 {
                limb0: 75507077154406003054173562673,
                limb1: 6786444589119069031230594722,
                limb2: 53529917334752402089060588443,
                limb3: 7868395711145495490589996307
            },
            u384 {
                limb0: 73533728155638340688925774405,
                limb1: 5804145164576516349762572822,
                limb2: 47102186047526247981743103100,
                limb3: 5814444555501779206689389147
            },
            u384 {
                limb0: 5185850722654867703708034517,
                limb1: 47193937277943419706908560006,
                limb2: 44526665107050199771497286593,
                limb3: 6820563004200426480872844203
            },
            u384 {
                limb0: 6032699608900731912194209634,
                limb1: 59880627626834559108078118317,
                limb2: 13865372176942357349381710834,
                limb3: 3464382742143331480802559177
            },
            u384 {
                limb0: 41838369610735308671204195085,
                limb1: 56515136814932689241030686459,
                limb2: 55458033077951295752454447729,
                limb3: 7514216072897215182106001897
            },
            u384 {
                limb0: 16971214735448949045109522700,
                limb1: 30316483362652274826510795737,
                limb2: 20234993420328036124622460971,
                limb3: 5894794146744660833718957778
            },
            u384 {
                limb0: 21008560046217409598069643803,
                limb1: 70618972207515816692398610110,
                limb2: 11125565703622397452152383440,
                limb3: 1502786018921591002648674820
            },
            u384 {
                limb0: 68431712705059285962134681011,
                limb1: 39582381175057522964259880632,
                limb2: 48665229064525924490438432891,
                limb3: 2309727594769053134553803602
            },
            u384 {
                limb0: 23304406479469378277050907938,
                limb1: 21846324017684779897081829825,
                limb2: 66768555401971720220356215546,
                limb3: 2566955349080009780143014544
            },
            u384 {
                limb0: 33764517998002098233736694289,
                limb1: 10742361788190551932063250094,
                limb2: 48406122792568455422258795498,
                limb3: 6356616197108823578633532673
            },
            u384 {
                limb0: 65721473540796294780755966501,
                limb1: 28348828040561767136496108189,
                limb2: 37711310998094141244154763631,
                limb3: 4397455030735690005474515068
            },
            u384 {
                limb0: 67569738538272057013481614649,
                limb1: 8915317053638291708803285546,
                limb2: 8316332264926272372434765103,
                limb3: 2628565650605990255277176456
            },
            u384 {
                limb0: 3280498233825808296731647832,
                limb1: 23293907157232391389589693722,
                limb2: 43970762579088751084694808051,
                limb3: 196525959038786696957951383
            },
            u384 {
                limb0: 33745269423316701290545068858,
                limb1: 57209580738686009218864209695,
                limb2: 19040342074070377168840588606,
                limb3: 5024607929386525140929444822
            },
            u384 {
                limb0: 17812367234764727378426354890,
                limb1: 77739253304802434076712435149,
                limb2: 6659572376620118202571582831,
                limb3: 2216215030366466630029956834
            },
            u384 {
                limb0: 20876963739858183141643070242,
                limb1: 45951695399891841551648731617,
                limb2: 56322008074663299587016037357,
                limb3: 1212626197365121380109300400
            },
            u384 {
                limb0: 1144134399668764747244896616,
                limb1: 63920508272873235789614987127,
                limb2: 39384782848453301232740325486,
                limb3: 2899525184527889912774266280
            },
            u384 {
                limb0: 61665585571169165287427991430,
                limb1: 51741626835481441913249055670,
                limb2: 39129543678187089610752577973,
                limb3: 1516397223147872513182724190
            },
            u384 {
                limb0: 54388778663199611574135326818,
                limb1: 20675845199348942459409096883,
                limb2: 6041263759540352994872875707,
                limb3: 5048348608460342685335255478
            },
            u384 {
                limb0: 33621655766722315194285976601,
                limb1: 18969905481522510584408099582,
                limb2: 42650002339373673399813181957,
                limb3: 3647883000086203406213470071
            },
            u384 {
                limb0: 21974209232505087381215427574,
                limb1: 5258457985285774575255868625,
                limb2: 39511592265723792433302532851,
                limb3: 857304908045116755817187507
            },
            u384 {
                limb0: 23795420978317965705099981437,
                limb1: 74604169471840888693158502314,
                limb2: 43134372669213497687201917987,
                limb3: 4093097633899929156576009889
            },
            u384 {
                limb0: 407296498722197308932823437,
                limb1: 42159940705762664876257495575,
                limb2: 49299306143147150706558836513,
                limb3: 130176083739445371780311751
            },
            u384 {
                limb0: 55893084151248488884705717158,
                limb1: 32310647117428394930720238444,
                limb2: 35776504278434343820120424208,
                limb3: 4382545108932153912011456564
            },
            u384 {
                limb0: 62486630638173718179887168573,
                limb1: 60560698899930026552899707845,
                limb2: 53119553762211864964056702399,
                limb3: 4342328629342877854233647855
            },
            u384 {
                limb0: 21473974589443527575284006548,
                limb1: 50608685281254892118206143629,
                limb2: 56946833129890378656766308819,
                limb3: 827810978768901450637515801
            },
            u384 {
                limb0: 39069500978567140530528861295,
                limb1: 39781538020192487092256709642,
                limb2: 23307496117799947629117117310,
                limb3: 6882320183301661539904996884
            },
            u384 {
                limb0: 10283691752212430917884265666,
                limb1: 13284731743353838102446285299,
                limb2: 25663093869022095978266933090,
                limb3: 2492618277879364530386346355
            },
            u384 {
                limb0: 18116174264183190474983199254,
                limb1: 38210450834706646708722668965,
                limb2: 67875497873251082163589643065,
                limb3: 300636073067813422611204153
            },
            u384 {
                limb0: 21437006127565511453644510080,
                limb1: 21652762935633237995354477377,
                limb2: 61908622747054043601598098641,
                limb3: 5082737846798842027912864945
            },
            u384 {
                limb0: 52380081919169123336624250162,
                limb1: 72327537979685130398873359470,
                limb2: 9742948690732295030461052213,
                limb3: 4550748801195176901766467271
            },
            u384 {
                limb0: 52772698321542789848980451639,
                limb1: 66363834778915555388165971676,
                limb2: 24472337962021022861294894016,
                limb3: 5765045194726616650291919176
            },
            u384 {
                limb0: 54442433282043167449221633283,
                limb1: 76032988943989592607848864126,
                limb2: 10463489341169756470812908078,
                limb3: 3738478450525933277010539079
            },
            u384 {
                limb0: 70942940027519053923956334712,
                limb1: 55611307726736634085402140336,
                limb2: 22116690534355603337829082736,
                limb3: 5917040583557999999489709007
            },
            u384 {
                limb0: 15721294921490339928024950676,
                limb1: 1771571991288166843884151332,
                limb2: 42608141190558725599725639472,
                limb3: 177027493800735558029183747
            },
            u384 {
                limb0: 55525436301705122328825964107,
                limb1: 4989218070062661459845534892,
                limb2: 25587588085203432316424572212,
                limb3: 5341098366305633247341355978
            },
            u384 {
                limb0: 38370038176142587256947879184,
                limb1: 69909959742389192396262364972,
                limb2: 56494767180793225148129951168,
                limb3: 5609217751913932720870611453
            },
            u384 {
                limb0: 16380227673670489887028897724,
                limb1: 351027249444920536914185755,
                limb2: 46754080558101329068006080105,
                limb3: 7759926564698742652219908839
            },
            u384 {
                limb0: 65254091817130728301140269423,
                limb1: 8340870753557327613904428896,
                limb2: 49025047105038652578022139033,
                limb3: 7003747672973448634625905804
            },
            u384 {
                limb0: 54850478769546672483788415251,
                limb1: 59412000284914211954105367216,
                limb2: 79164290795381851141201684346,
                limb3: 2169272660275690137838786710
            },
            u384 {
                limb0: 29685087759226543653539121291,
                limb1: 52992192285887296414730853856,
                limb2: 73963416310188523809393650351,
                limb3: 3906640769234404003656915123
            },
            u384 {
                limb0: 63259078821472114682747745719,
                limb1: 21571107912084411933395918730,
                limb2: 30151611343748655867290130862,
                limb3: 6556780735866719192959060661
            },
            u384 {
                limb0: 60606266058111408206530182382,
                limb1: 4851681138151813727734750795,
                limb2: 74534522304790322110769186182,
                limb3: 2350377194616345454063145329
            },
            u384 {
                limb0: 52370423421376078125915776928,
                limb1: 66101023008919292019464325143,
                limb2: 7889680677565087061635184563,
                limb3: 7683564783653675890707173121
            },
            u384 {
                limb0: 38080298790849756924333110596,
                limb1: 37158451873327346265063623919,
                limb2: 12721579508356034160080697028,
                limb3: 1765845576686484583213490266
            },
            u384 {
                limb0: 16392214311847840165411212683,
                limb1: 10510666644265539439568974961,
                limb2: 71176451130939193899730590361,
                limb3: 7985080034828065815825858451
            },
            u384 {
                limb0: 78852755577215803265024947097,
                limb1: 67288421837864085872826193287,
                limb2: 5685598384127436571766055409,
                limb3: 5684232317650737299951001584
            },
            u384 {
                limb0: 8583676692643639296372959413,
                limb1: 32370983593374483004343083518,
                limb2: 23741866381669199638981418487,
                limb3: 5226247917449798793433164723
            },
            u384 {
                limb0: 57111878903050579002374076269,
                limb1: 54920759116339362606096293542,
                limb2: 30088726055112650862830606970,
                limb3: 3472107710483163356697858194
            },
            u384 {
                limb0: 5927550065530541511742103346,
                limb1: 20700971137998987357961137600,
                limb2: 17993504651571292531467342751,
                limb3: 8001795497061588439918606304
            },
            u384 {
                limb0: 47259263830843790126100802789,
                limb1: 47055455202082683173387935155,
                limb2: 41719976140527686684622577298,
                limb3: 444847744439416271246936649
            },
            u384 {
                limb0: 48636321041110285330000176646,
                limb1: 60133572031426582750410973556,
                limb2: 5086321613980245993151945272,
                limb3: 7123594624962424768932403980
            },
            u384 {
                limb0: 58468375235110594887962443898,
                limb1: 65345171512431026065281367976,
                limb2: 31986126312772681127533633618,
                limb3: 6965500866342994490189341676
            },
            u384 {
                limb0: 318950267698776742245521544,
                limb1: 23978024496234119433470071679,
                limb2: 56387098864849062563101681726,
                limb3: 2484790998708252069812577005
            },
            u384 {
                limb0: 285502855176421511255157265,
                limb1: 19668510824666901827148980897,
                limb2: 23651376195246991897318592988,
                limb3: 2166867894757340122693518807
            },
            u384 {
                limb0: 9272419232887265515753700421,
                limb1: 40394697438902154480329172437,
                limb2: 7719276474267961938652827967,
                limb3: 1824473945873885414080767848
            },
            u384 {
                limb0: 65522066726841364839325142826,
                limb1: 15591003266963517955423046799,
                limb2: 72957788802331972172745525072,
                limb3: 4730604536879027404996350772
            },
            u384 {
                limb0: 5226037291243410958243486123,
                limb1: 60883839580725791305169309178,
                limb2: 61863684960658732178846732098,
                limb3: 2726133929170945056576163171
            },
            u384 {
                limb0: 41746129914195810306614309780,
                limb1: 21409725534425342232041505711,
                limb2: 69377713641647834728185792808,
                limb3: 4669418257022824000660690338
            },
            u384 {
                limb0: 20149718999479246684216991219,
                limb1: 29914697119980881562337449526,
                limb2: 57283594733160724265481107340,
                limb3: 7379988054422211960473058842
            },
            u384 {
                limb0: 24252559603493581229744924150,
                limb1: 37736205498675074933206441286,
                limb2: 34416101059072738154556393877,
                limb3: 409782755127219567081298884
            },
            u384 {
                limb0: 54664112522693997083553349261,
                limb1: 46228366570129663474133450831,
                limb2: 73618840093765438337188555968,
                limb3: 7232130572516701018684194688
            },
            u384 {
                limb0: 45694862704596503219132952260,
                limb1: 12828300134349213716289649722,
                limb2: 21832942225015470494114844535,
                limb3: 571135035660120202740725908
            },
            u384 {
                limb0: 33886853684586736955515708474,
                limb1: 26488037109120436476856904430,
                limb2: 11687091377523234778834211739,
                limb3: 3634768250223431194650819925
            },
            u384 {
                limb0: 27939017157097795826634791144,
                limb1: 2007338782172600636994422910,
                limb2: 4985672885723669855290782421,
                limb3: 5797422686402354767645810169
            },
            u384 {
                limb0: 78724304081926979767855719634,
                limb1: 11575613926386084924339070042,
                limb2: 78061741518309954429443126019,
                limb3: 8006969562607273193869528002
            },
            u384 {
                limb0: 59098792904591267423379173924,
                limb1: 43877424598207031199458247177,
                limb2: 10488235328733786083120409853,
                limb3: 4420145150275843535437670500
            },
            u384 {
                limb0: 44210024980632986631214227713,
                limb1: 58139025927861466172590867377,
                limb2: 51718748824223508340166121470,
                limb3: 2103679827480508651748422778
            },
            u384 {
                limb0: 16899901707703430392605043233,
                limb1: 10059306797852662182204724549,
                limb2: 32733295332184140693189567863,
                limb3: 7575565001613733372197278440
            },
            u384 {
                limb0: 53598408363837190446215371292,
                limb1: 21325649386682104282485267178,
                limb2: 49877677806808264370456581572,
                limb3: 1050193762754591012111241099
            },
            u384 {
                limb0: 77677290336307059794349443110,
                limb1: 51180256907461740126799277231,
                limb2: 54299900186935688445442649981,
                limb3: 3839761135229396046452691149
            },
            u384 {
                limb0: 9805870882823445998595198936,
                limb1: 58554551030096274118812898580,
                limb2: 60249173677138616916314219637,
                limb3: 2560230146274340576237424047
            },
            u384 {
                limb0: 7459075866803986197486042291,
                limb1: 35168114149923577263306244705,
                limb2: 15063691587455545310789930065,
                limb3: 6937061776695394929055417207
            },
            u384 {
                limb0: 53477234589154236718839772680,
                limb1: 28222707185286015044210806875,
                limb2: 4359131308511020204275905225,
                limb3: 2339552207582153350671202125
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
            limb0: 72409602036248422670465143164,
            limb1: 34199431460911537369519189749,
            limb2: 11536356825535896820954916922,
            limb3: 1805028313861947282345531442
        };
        assert_eq!(final_check_result, final_check);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_INIT_BIT_2_circuit_BLS12_381() {
        let yInv_0: u384 = u384 {
            limb0: 20016204489633770133814749265,
            limb1: 46593096455394732881286980853,
            limb2: 24505566289296309333739154735,
            limb3: 7298380997416507273600050337
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 59838013966907965276805635994,
            limb1: 23967465472586460070771370557,
            limb2: 59029920921085929294985265665,
            limb3: 5439123924989825900912536939
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 1529983428013083203853882818,
                limb1: 59171644567912598578388911732,
                limb2: 72258653020335855476943841015,
                limb3: 6827632804271550937198472460
            },
            x1: u384 {
                limb0: 51781340729597458131257993487,
                limb1: 55627586365414916112085234773,
                limb2: 1047008751898880099058981814,
                limb3: 4440962529674274475699235458
            },
            y0: u384 {
                limb0: 61550531567020125259664911229,
                limb1: 31035537214245449133520012924,
                limb2: 23790741605739165866224935371,
                limb3: 6620343442274782837003086816
            },
            y1: u384 {
                limb0: 4654586761805988330077579510,
                limb1: 41759515993115012445950036676,
                limb2: 64748692497596755655799939665,
                limb3: 893585786836754435747986455
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 14032704481278093345532596659,
            limb1: 6757027580097883060254002408,
            limb2: 49032893530129577024140597597,
            limb3: 1029430892168899434213379904
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 32275082993701280036647562845,
            limb1: 41423145559324971245308338110,
            limb2: 4551139982430924732569821684,
            limb3: 4818796812522502329914978711
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 30787595445925186845589404594,
                limb1: 1087109894752911821054346783,
                limb2: 35284040753024568109477293727,
                limb3: 1693709245708726707530160171
            },
            x1: u384 {
                limb0: 5028108990271182265646988589,
                limb1: 66523637363187544181885789779,
                limb2: 46233515674213534266207503707,
                limb3: 1333290757660402864951004575
            },
            y0: u384 {
                limb0: 56967859245295544119229249978,
                limb1: 43294507808003652654265375323,
                limb2: 30733660844670510126934849089,
                limb3: 1060419711489898213702345312
            },
            y1: u384 {
                limb0: 58920122533452872493582690609,
                limb1: 719670277754282001247143525,
                limb2: 42678154389822904960301390088,
                limb3: 377970306989959387559160630
            }
        };

        let R_i = E12D {
            w0: u384 {
                limb0: 75294419185698092276277554280,
                limb1: 69348173207302386417940588876,
                limb2: 47799031051884987180075008276,
                limb3: 1379017532838957142432355886
            },
            w1: u384 {
                limb0: 38511436340688454093993705705,
                limb1: 52753647817327570873559709996,
                limb2: 71336116753828341273243423972,
                limb3: 4276311597603011713499788681
            },
            w2: u384 {
                limb0: 35933803774757302866850842555,
                limb1: 62084023488174143711694644973,
                limb2: 30584888813107714435961665965,
                limb3: 7782958976976439402655977665
            },
            w3: u384 {
                limb0: 19594948515337091079728201544,
                limb1: 28988864188983423083492397884,
                limb2: 10421998075911325399179374529,
                limb3: 1048678539249457069051772148
            },
            w4: u384 {
                limb0: 55801034649624631107021477086,
                limb1: 76262525049458382114373958025,
                limb2: 29446891620385803413773052552,
                limb3: 4051768362870543403354334512
            },
            w5: u384 {
                limb0: 56441740993467173415479240741,
                limb1: 56493167526553760281611937800,
                limb2: 48641187730251296808444163197,
                limb3: 3496141662668496370719592491
            },
            w6: u384 {
                limb0: 55728262696943343216315435049,
                limb1: 52066376254209998231914626426,
                limb2: 10837862639025893175539842782,
                limb3: 2791054229825006796429348377
            },
            w7: u384 {
                limb0: 69228945225248362581995933934,
                limb1: 2753376804997583257160069022,
                limb2: 65328631007423396801395271330,
                limb3: 6400019736901635555448295245
            },
            w8: u384 {
                limb0: 55912232865146288356424089367,
                limb1: 66647700590359170170279742701,
                limb2: 36503647134980173775214092748,
                limb3: 2257647854424618374477349123
            },
            w9: u384 {
                limb0: 60628688772931878616593748335,
                limb1: 53458211842170579355180628732,
                limb2: 48766563167164299710908089059,
                limb3: 1425432152299636854680603026
            },
            w10: u384 {
                limb0: 47406652472006612635416123928,
                limb1: 10516918446960408045983478382,
                limb2: 65900325686361460122411073552,
                limb3: 6700783920580359627883005451
            },
            w11: u384 {
                limb0: 16717249003565328805429819175,
                limb1: 61665272489545425716732891791,
                limb2: 42844215119073943564700067264,
                limb3: 4587273251639631555640776012
            }
        };

        let c0: u384 = u384 {
            limb0: 61073202043818587133062758700,
            limb1: 67691796947265535994800516392,
            limb2: 10887191419878148382329775772,
            limb3: 1345176343547479166242795730
        };

        let z: u384 = u384 {
            limb0: 74313524284083269806698678734,
            limb1: 27945659866898425491641461577,
            limb2: 52207215575654309148536878743,
            limb3: 1957899140533751425511356256
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 58446651428588844339375925813,
            limb1: 73794131743597715331202080,
            limb2: 32788905649732793473622803941,
            limb3: 2053179085897001048094006194
        };

        let (Q0_result, Q1_result, new_lhs_result, f_i_plus_one_of_z_result) =
            run_BLS12_381_MP_CHECK_INIT_BIT_2_circuit(
            yInv_0, xNegOverY_0, Q0, yInv_1, xNegOverY_1, Q1, R_i, c0, z, c_inv_of_z
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 44432225322428611790860390702,
                limb1: 44331189934990084592166831985,
                limb2: 26617336679680523950378423260,
                limb3: 1846079426736417993547487808
            },
            x1: u384 {
                limb0: 51542141268981536646798277759,
                limb1: 49090485767925631815392889167,
                limb2: 32522594572902920884611588266,
                limb3: 2148575664377199827021184856
            },
            y0: u384 {
                limb0: 75239549765689891579230469811,
                limb1: 22584936540858325102927922108,
                limb2: 57257560143860571117200507653,
                limb3: 5799509127707064035614856808
            },
            y1: u384 {
                limb0: 696555786213115623478726850,
                limb1: 49627754927664251209427808390,
                limb2: 15593119492252508201003653347,
                limb3: 6403160958631541543288183888
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 42846329944555386419922259471,
                limb1: 13571326548348331907133317368,
                limb2: 37602312479844285114136076197,
                limb3: 6350484748814646373307013876
            },
            x1: u384 {
                limb0: 72268762234446938905087134393,
                limb1: 16709768868485062169922970513,
                limb2: 64494519261134155387443616479,
                limb3: 7258347746183076290745789426
            },
            y0: u384 {
                limb0: 26613225796092953536550059910,
                limb1: 44391084630645007830277258576,
                limb2: 47121178280908845670945839222,
                limb3: 5643938029127913019327744055
            },
            y1: u384 {
                limb0: 72158059231541554576262467554,
                limb1: 8507974495759592953500065120,
                limb2: 19138815195543865611281888144,
                limb3: 1102624529172655319899829175
            }
        };

        let new_lhs: u384 = u384 {
            limb0: 12646828511312956600503959003,
            limb1: 34948785292463320179647169700,
            limb2: 9608308518496637565867333582,
            limb3: 7735686467454484152467467415
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 58910484219477500844577022734,
            limb1: 64936590976330294890408705063,
            limb2: 40793477961616719631793817457,
            limb3: 181480640838538688267350821
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(new_lhs_result, new_lhs);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_INIT_BIT_3_circuit_BLS12_381() {
        let yInv_0: u384 = u384 {
            limb0: 7965373810597245399637124193,
            limb1: 6053201606485360979507578037,
            limb2: 38448316902917010440297681819,
            limb3: 1211421857357752326227381336
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 15511041069950382424063017073,
            limb1: 76478130673776270176371825004,
            limb2: 60216583695544336246879651415,
            limb3: 5731506188553573343697024177
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 44156529642329822359198163657,
                limb1: 4696511192350209408454178643,
                limb2: 32736705248999178200652436185,
                limb3: 2364426610954266549776092476
            },
            x1: u384 {
                limb0: 30216643768512671200451709202,
                limb1: 74148619684651249964702932768,
                limb2: 58435670793444727270589492469,
                limb3: 3045783510952810879796153705
            },
            y0: u384 {
                limb0: 6356023896912178094433827518,
                limb1: 39430055965540641052705740810,
                limb2: 70879942682104741082339479892,
                limb3: 814210386041651810815957487
            },
            y1: u384 {
                limb0: 45970077958601647073173066286,
                limb1: 52654338151087047844248326139,
                limb2: 73443919040594709604896083379,
                limb3: 5852219728337857724329583540
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 70290365658297796022552774192,
            limb1: 63625622099932338403186816246,
            limb2: 29557179799211850507193460509,
            limb3: 6908976949966803480385576382
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 23323602885553786619190371701,
            limb1: 45158722773724294969332060532,
            limb2: 19433457244377196697856296562,
            limb3: 3274683829551873188666833036
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 7829944889235033670294891025,
                limb1: 75092927861813181274004951325,
                limb2: 53134385812119699666454259440,
                limb3: 313779758987439816172131431
            },
            x1: u384 {
                limb0: 58981063918070278537793978663,
                limb1: 37361045857718757306178763911,
                limb2: 18814914534411575984943896380,
                limb3: 1794885014884019160421238592
            },
            y0: u384 {
                limb0: 70033060936272563061708636455,
                limb1: 62806957885654591221816404974,
                limb2: 58595903282096353464491437795,
                limb3: 7244558882960430524030503827
            },
            y1: u384 {
                limb0: 44460986260296554768016211845,
                limb1: 69981529638555323627192825258,
                limb2: 46502942251201917604085099758,
                limb3: 4109734594476979224608519598
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 54368857302497746369771745167,
            limb1: 59013641599762258885491843317,
            limb2: 61297749793713768501937820427,
            limb3: 4307479448332414216200175289
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 9098827931898770814020852271,
            limb1: 44922652830412031032490117235,
            limb2: 28019017623948997673974117541,
            limb3: 6914613008035051659377168553
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 51091145637376964830091769838,
                limb1: 16441839498615926278198805393,
                limb2: 2760390621556014981863200461,
                limb3: 4008112068546843923414415359
            },
            x1: u384 {
                limb0: 45712187230733996301185898487,
                limb1: 45492839454732661744174337539,
                limb2: 26511075950766345610646758181,
                limb3: 1661405692348195096961427607
            },
            y0: u384 {
                limb0: 15274436087993919854053828680,
                limb1: 7281081142680935188577550397,
                limb2: 944071187382165733698752731,
                limb3: 2799862154521110542337135807
            },
            y1: u384 {
                limb0: 31953663380512144694151836620,
                limb1: 53788833270516290388025327335,
                limb2: 13481414616231411767165442821,
                limb3: 767991053399600844717960733
            }
        };

        let R_i = E12D {
            w0: u384 {
                limb0: 48090665927620186588187899433,
                limb1: 46346050658450664104904051699,
                limb2: 37756275252366897842697210153,
                limb3: 7351814313945754503952153747
            },
            w1: u384 {
                limb0: 65526128631192641108081275829,
                limb1: 51108238290555743453321064698,
                limb2: 71111413046182086808013181613,
                limb3: 2569101193583107002242067453
            },
            w2: u384 {
                limb0: 4756007446086287998490880011,
                limb1: 2669289834236186747570390207,
                limb2: 431455349236542418123055506,
                limb3: 3475258514452974513640326012
            },
            w3: u384 {
                limb0: 77911333330463875867983217364,
                limb1: 60819999035527075805684463926,
                limb2: 14694674833498459708589710636,
                limb3: 5903205231289840300648997367
            },
            w4: u384 {
                limb0: 9803060742479928685143218763,
                limb1: 11058469728902035449657038660,
                limb2: 35596037330304329475155359999,
                limb3: 6437511733539267866822190178
            },
            w5: u384 {
                limb0: 15489773521093418678269338176,
                limb1: 19543725673847685987562558854,
                limb2: 1473544454024930587479741056,
                limb3: 1856818468197765491335261425
            },
            w6: u384 {
                limb0: 2927038546888080412452603167,
                limb1: 77441367501336336589282862481,
                limb2: 46029662847278853727721669016,
                limb3: 6473100248873157149259481694
            },
            w7: u384 {
                limb0: 21422976191115175006463854029,
                limb1: 27016172731773224921821444378,
                limb2: 66438874958081227897424455230,
                limb3: 5211971186986717613506918742
            },
            w8: u384 {
                limb0: 52454908235151948439532043131,
                limb1: 67196250255399755363445647329,
                limb2: 15585585738766555076797559261,
                limb3: 2759541602856429448748284966
            },
            w9: u384 {
                limb0: 30360873436344224240328291398,
                limb1: 74560064412688465201271749352,
                limb2: 62256431128292747557387326479,
                limb3: 7603698800455486721227535958
            },
            w10: u384 {
                limb0: 13729633608223388306850339979,
                limb1: 32153918615608380241626957113,
                limb2: 24100545915324230839289631139,
                limb3: 2613579261550700578298863480
            },
            w11: u384 {
                limb0: 73373288297471771528456598011,
                limb1: 8646171336709831027550459020,
                limb2: 54201945816636104026235961628,
                limb3: 5137027943506767308295730035
            }
        };

        let c0: u384 = u384 {
            limb0: 25910072207736081531589651447,
            limb1: 47613580703559495182812464931,
            limb2: 59176688870992696980381194448,
            limb3: 2352792380312370559678241916
        };

        let z: u384 = u384 {
            limb0: 40625377847554051211794687848,
            limb1: 56309555150900228441026238802,
            limb2: 16523459175396971657448338261,
            limb3: 3406044480451966153574474789
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 68262812469567572085739292997,
            limb1: 27301883946581413247302425188,
            limb2: 30008385554364830489037983982,
            limb3: 3273273192464943539270875302
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
                limb0: 6900065173790261948850806024,
                limb1: 24827274407660338350200783640,
                limb2: 53171355813820702926486046397,
                limb3: 6210529288728899814955195279
            },
            x1: u384 {
                limb0: 46471653801492805655323878319,
                limb1: 29076880596237169816222469089,
                limb2: 27840120884391463297014697555,
                limb3: 4518527265372121283413094796
            },
            y0: u384 {
                limb0: 50804839703481175779810879385,
                limb1: 1824163400549042524217599406,
                limb2: 1580464028474885972617082807,
                limb3: 2570511705357483046414366685
            },
            y1: u384 {
                limb0: 65698190243562375749064218579,
                limb1: 34566960871274546709634184807,
                limb2: 5891215205132750696629782605,
                limb3: 1772706383599613830020763110
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 30814047009118336271936059143,
                limb1: 25621188732476733091385802781,
                limb2: 46840616797728231864436806297,
                limb3: 5744543898515744645915427403
            },
            x1: u384 {
                limb0: 48323093987885939799895573759,
                limb1: 33603818158462339314642890813,
                limb2: 45873540194159884500172480185,
                limb3: 2763513430197865771875944943
            },
            y0: u384 {
                limb0: 44735830978352372466084350766,
                limb1: 41535765235090342063387126396,
                limb2: 72573285803410394375524985938,
                limb3: 3865721757236681532559507011
            },
            y1: u384 {
                limb0: 53567222078659854332831159102,
                limb1: 21951896131799761607251322543,
                limb2: 14207591163421494312102678164,
                limb3: 3486501437239035389762645423
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 66178671755174822483870064342,
                limb1: 54918038106942006212346945657,
                limb2: 50379726761380532493262675857,
                limb3: 7918958778086950106629097591
            },
            x1: u384 {
                limb0: 76232377179645385287406695783,
                limb1: 8866167793564144805185746758,
                limb2: 3687056941669496048833859779,
                limb3: 7527789447803286337483236459
            },
            y0: u384 {
                limb0: 47815695027048148221262406421,
                limb1: 34024810242659139359468698099,
                limb2: 32974067176308734421254162977,
                limb3: 4021179319617295634715174867
            },
            y1: u384 {
                limb0: 48232421738763226595393214200,
                limb1: 23386373356554161232513835136,
                limb2: 33172487383620150694349110452,
                limb3: 3719472614876948120699402950
            }
        };

        let new_lhs: u384 = u384 {
            limb0: 66291907622714353947557345347,
            limb1: 73563553445531218093875535261,
            limb2: 24098939331157021875476384626,
            limb3: 1501688340363935995717663534
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 68666186142167382382161863030,
            limb1: 15361705256822594384977054502,
            limb2: 56107809975956382057330859407,
            limb3: 7924731170353962789200448498
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
                limb0: 31061169479502459662437460093,
                limb1: 28960122603292829052036836234,
                limb2: 7676563523233002599008103266,
                limb3: 1508339399911377800329479509
            },
            w1: u384 {
                limb0: 2960589968360097439480506151,
                limb1: 9076676549409480069191874258,
                limb2: 64218952214993045523364645347,
                limb3: 1723608184692746036738731404
            },
            w2: u384 {
                limb0: 73847149272718847101445216958,
                limb1: 16428304194990939763785584605,
                limb2: 56468317720754650758588865078,
                limb3: 2669029461326435872702590826
            },
            w3: u384 {
                limb0: 76735350128302396206707383016,
                limb1: 8883405526952192487257979810,
                limb2: 42759836369922405127764362938,
                limb3: 2858143422213171363826210704
            },
            w4: u384 {
                limb0: 35574516820209966321080600851,
                limb1: 22925557663776314544708413564,
                limb2: 18894656790303022745539248375,
                limb3: 1086652074916903630383927822
            },
            w5: u384 {
                limb0: 65154282607118561156654292464,
                limb1: 11103871768771329169237263281,
                limb2: 60757598459772940966803107450,
                limb3: 4146526597417236874866923231
            },
            w6: u384 {
                limb0: 64296146346723321403995513045,
                limb1: 45744882388985756288405078671,
                limb2: 34616507273371406327018487118,
                limb3: 6225431165294501808362457664
            },
            w7: u384 {
                limb0: 36022776309148957367880418356,
                limb1: 7720227347906367085192051192,
                limb2: 10236064071149134724936382159,
                limb3: 7736985012325634724930220787
            },
            w8: u384 {
                limb0: 21946288975866193310318172963,
                limb1: 8834311689653106485431383786,
                limb2: 78868572037546377400366453987,
                limb3: 6819289759017959280953352023
            },
            w9: u384 {
                limb0: 78906160014858609165053871707,
                limb1: 47746454839373110315359381224,
                limb2: 33865736706236637841986769008,
                limb3: 1687929768861704321759827132
            },
            w10: u384 {
                limb0: 15484459122173043966653119318,
                limb1: 57425225148888883276903161515,
                limb2: 70083498492536865394132449397,
                limb3: 906650156999460840823089227
            },
            w11: u384 {
                limb0: 39965427946520538616713375577,
                limb1: 71157345772012114004499560596,
                limb2: 12663804128944545281770731521,
                limb3: 2382263899671784142391088590
            }
        };

        let z: u384 = u384 {
            limb0: 39811017861294035044839269567,
            limb1: 44012945265082079317954415684,
            limb2: 13157670091836709377474424747,
            limb3: 1994829177232703362870844231
        };

        let scaling_factor: MillerLoopResultScalingFactor = MillerLoopResultScalingFactor {
            w0: u384 {
                limb0: 48306295040965083345487238121,
                limb1: 40821078966685606732326245370,
                limb2: 67257215424935590249336254359,
                limb3: 761362700277634257139775128
            },
            w2: u384 {
                limb0: 28573061982887861377251154519,
                limb1: 33469918077306904241592367944,
                limb2: 23000863290260386604426264044,
                limb3: 4034414207153163837293325557
            },
            w4: u384 {
                limb0: 39666657252444715002473506023,
                limb1: 17791645735717041308257995448,
                limb2: 6797101072318243621089476538,
                limb3: 6779301038338502453167726900
            },
            w6: u384 {
                limb0: 56759389525665514175432242426,
                limb1: 71015693003740442497074595791,
                limb2: 45519649736638840537171437387,
                limb3: 5250460460205849846690310328
            },
            w8: u384 {
                limb0: 65545863405076038749995976186,
                limb1: 23418595681120565172117473524,
                limb2: 70398707972251353893017223632,
                limb3: 2412036464457280025422422235
            },
            w10: u384 {
                limb0: 7505918036574506700521922044,
                limb1: 15053581671036014250029478516,
                limb2: 34600114091332165410120593775,
                limb3: 5055227171445641219253858161
            }
        };

        let (c_inv_of_z_result, scaling_factor_of_z_result, c_inv_frob_1_of_z_result) =
            run_BLS12_381_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit(
            lambda_root_inverse, z, scaling_factor
        );
        let c_inv_of_z: u384 = u384 {
            limb0: 27251177520501115450264473785,
            limb1: 43178483518034889051899382420,
            limb2: 2428187130265424464931308239,
            limb3: 1400950377229230420148320270
        };

        let scaling_factor_of_z: u384 = u384 {
            limb0: 7260038732901816697985551180,
            limb1: 20544626870819095938229600656,
            limb2: 26558471521318826190040799785,
            limb3: 5838656876844955020953056642
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 70550147119865733949321875651,
            limb1: 48148722079751814435224209923,
            limb2: 52345959263628885186780628637,
            limb3: 7649114161344809195405143669
        };
        assert_eq!(c_inv_of_z_result, c_inv_of_z);
        assert_eq!(scaling_factor_of_z_result, scaling_factor_of_z);
        assert_eq!(c_inv_frob_1_of_z_result, c_inv_frob_1_of_z);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_PREPARE_PAIRS_2_circuit_BLS12_381() {
        let p_0: G1Point = G1Point {
            x: u384 {
                limb0: 65704387096522028517322403462,
                limb1: 61675595663651230183622275262,
                limb2: 47600622066528175720170153521,
                limb3: 5263995543866351230158943507
            },
            y: u384 {
                limb0: 1266686201875326888374028451,
                limb1: 7767923542985308948007960728,
                limb2: 53970631889644558986699433813,
                limb3: 1215506568597175431934889401
            }
        };

        let p_1: G1Point = G1Point {
            x: u384 {
                limb0: 37737677545541065100312468101,
                limb1: 42007354613868751029272479486,
                limb2: 54424741937055588750502017903,
                limb3: 1655593104852673645399911544
            },
            y: u384 {
                limb0: 61492193675510897045740527666,
                limb1: 35788109527129715738842015356,
                limb2: 11500872326536795721838619203,
                limb3: 5568207047346144583558974689
            }
        };

        let (p_0_result, p_1_result) = run_BLS12_381_MP_CHECK_PREPARE_PAIRS_2_circuit(p_0, p_1);
        let p_0: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 27360358443142233803143722608,
                limb1: 31636121749443931542362171759,
                limb2: 45218347649672907120538415423,
                limb3: 7189597709955328187558304408
            },
            xNegOverY: u384 {
                limb0: 53926438551546385064980999144,
                limb1: 44183151858041926700734907607,
                limb2: 10312679543287498205221895025,
                limb3: 6541356855681718461631207969
            }
        };
        let p_1: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 73643975021415275802310920531,
                limb1: 65458426285642861193864425088,
                limb2: 1406623212324363033946534171,
                limb3: 995317798231839064349289548
            },
            xNegOverY: u384 {
                limb0: 67457095071690392167171213233,
                limb1: 24816357967217944656011671643,
                limb2: 59303409506449095180979239757,
                limb3: 5751929504107826865385752106
            }
        };
        assert_eq!(p_0_result, p_0);
        assert_eq!(p_1_result, p_1);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_PREPARE_PAIRS_3_circuit_BLS12_381() {
        let p_0: G1Point = G1Point {
            x: u384 {
                limb0: 61203977394272189843106204110,
                limb1: 38060376678846452669979991028,
                limb2: 8533258001844543462088238935,
                limb3: 6291741109370302778327859585
            },
            y: u384 {
                limb0: 38293590450898221460693182375,
                limb1: 56773648246900295935946101706,
                limb2: 13269048897672419427317954607,
                limb3: 6362315025312532029646602362
            }
        };

        let p_1: G1Point = G1Point {
            x: u384 {
                limb0: 54949340974139451369567631486,
                limb1: 70622223855914834279673758309,
                limb2: 30094217808049992012094184057,
                limb3: 4264829365328915101033918419
            },
            y: u384 {
                limb0: 62497052763223457713965339470,
                limb1: 35517071951989578312879501399,
                limb2: 37892469344569612687599092538,
                limb3: 957714489286706544256688883
            }
        };

        let p_2: G1Point = G1Point {
            x: u384 {
                limb0: 2450621879924065027636731963,
                limb1: 52132679799898962015507113590,
                limb2: 53605869125329604389025611479,
                limb3: 1763855155793643745272859848
            },
            y: u384 {
                limb0: 51253991152573743806236847324,
                limb1: 23699159792215460719900553579,
                limb2: 5957307746048150801991800890,
                limb3: 4178569497642778567975873218
            }
        };

        let (p_0_result, p_1_result, p_2_result) = run_BLS12_381_MP_CHECK_PREPARE_PAIRS_3_circuit(
            p_0, p_1, p_2
        );
        let p_0: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 13093233425219013198643869427,
                limb1: 16211490316938739733167655925,
                limb2: 62875213195945283583590894097,
                limb3: 5416475335241784077943858649
            },
            xNegOverY: u384 {
                limb0: 21811839353774530654459711199,
                limb1: 62742918194375826928439362958,
                limb2: 51309452334881477990105569984,
                limb3: 1700597914055303029732804933
            }
        };
        let p_1: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 19406851051570702917027053059,
                limb1: 2648457783582647987589445246,
                limb2: 20032948820145686511128825669,
                limb3: 7050774772125765162561150907
            },
            xNegOverY: u384 {
                limb0: 56567083940436438722696053669,
                limb1: 65900226418182674473370445133,
                limb2: 39212305959797305520722267756,
                limb3: 2218384375320191927020312865
            }
        };
        let p_2: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 76657224019316747338809095032,
                limb1: 20847808218465460486314170212,
                limb2: 67309290637758132559969254862,
                limb3: 5237390430871507107735644605
            },
            xNegOverY: u384 {
                limb0: 40490323190270512090722111470,
                limb1: 70894205678051660285210230089,
                limb2: 74177719233248388747582779931,
                limb3: 6692592370472455906732339547
            }
        };
        assert_eq!(p_0_result, p_0);
        assert_eq!(p_1_result, p_1);
        assert_eq!(p_2_result, p_2);
    }


    #[test]
    fn test_run_BN254_MP_CHECK_BIT00_LOOP_2_circuit_BN254() {
        let yInv_0: u384 = u384 {
            limb0: 55585451058546287739263883524,
            limb1: 34255355203443393623176683664,
            limb2: 2710677839272775103,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 57969513094032988461574612749,
            limb1: 11812106686723728338594362602,
            limb2: 2276128898902258712,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 56128967184628769895796253515,
                limb1: 35724259714425159893965595409,
                limb2: 1746759628903670112,
                limb3: 0
            },
            x1: u384 {
                limb0: 27888310956196060346198532843,
                limb1: 34508741101696963771242260633,
                limb2: 3374349749706669543,
                limb3: 0
            },
            y0: u384 {
                limb0: 31151066411151093217046772041,
                limb1: 54290658835684326060742904799,
                limb2: 1383758741937466262,
                limb3: 0
            },
            y1: u384 {
                limb0: 51412777433172853008983812456,
                limb1: 33712622652417443717215682330,
                limb2: 2853256203748572294,
                limb3: 0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 55051944887671674900335154292,
            limb1: 11726694581309105524248097629,
            limb2: 1258369851557705790,
            limb3: 0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 42519035509788404047271774805,
            limb1: 14981575812660258713168719523,
            limb2: 948106053316243659,
            limb3: 0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 23847684527921523443428514605,
                limb1: 12616067179367800258345034728,
                limb2: 1614060703602010283,
                limb3: 0
            },
            x1: u384 {
                limb0: 927431570899452569394295756,
                limb1: 59369990860592788420977852275,
                limb2: 2446229682002905367,
                limb3: 0
            },
            y0: u384 {
                limb0: 72717591697820273748008721090,
                limb1: 31253775689889556585325366941,
                limb2: 573076264820504009,
                limb3: 0
            },
            y1: u384 {
                limb0: 28294629224841315077632445859,
                limb1: 54519147856867630003425812652,
                limb2: 2317185443406854835,
                limb3: 0
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 446618355839444511325961143,
            limb1: 56922828061039770272509152779,
            limb2: 793036079374843095,
            limb3: 0
        };

        let f_i_of_z: u384 = u384 {
            limb0: 1545721402804127367186365676,
            limb1: 25616324502294827115035576632,
            limb2: 17048479735291872,
            limb3: 0
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 61569731471679553415972015133,
                limb1: 45397836797727054552047374566,
                limb2: 681121553085731478,
                limb3: 0
            },
            w1: u384 {
                limb0: 53367371023079767989194609237,
                limb1: 62408255125039540927139344805,
                limb2: 1931084718791778569,
                limb3: 0
            },
            w2: u384 {
                limb0: 40426364786560633967414403511,
                limb1: 31721981733187122470673921906,
                limb2: 598585907275319844,
                limb3: 0
            },
            w3: u384 {
                limb0: 37327079055870445326304281369,
                limb1: 72599723485199937550392425017,
                limb2: 1107057006542591089,
                limb3: 0
            },
            w4: u384 {
                limb0: 31458271579952645982382985634,
                limb1: 5468144394173660380675474468,
                limb2: 1163845250706880668,
                limb3: 0
            },
            w5: u384 {
                limb0: 70120067598862826274324925830,
                limb1: 42968606344550362691721385533,
                limb2: 2785611837185452245,
                limb3: 0
            },
            w6: u384 {
                limb0: 37597780700016901738286161535,
                limb1: 21889303588402134630156913326,
                limb2: 2817585940343643783,
                limb3: 0
            },
            w7: u384 {
                limb0: 63229723936255266448229952837,
                limb1: 49604926151355255235378011954,
                limb2: 2464817023655220264,
                limb3: 0
            },
            w8: u384 {
                limb0: 68946790157459744415539652976,
                limb1: 34302357024985019581120331792,
                limb2: 483391151432286024,
                limb3: 0
            },
            w9: u384 {
                limb0: 47868410363204291606894343407,
                limb1: 13437792556556023109842686339,
                limb2: 2187595070594267987,
                limb3: 0
            },
            w10: u384 {
                limb0: 73955362770057848882111020916,
                limb1: 11305331660430972841921856160,
                limb2: 1649237130484661850,
                limb3: 0
            },
            w11: u384 {
                limb0: 14015287804042660151540585764,
                limb1: 25723101760383619261592269199,
                limb2: 1752963995163783886,
                limb3: 0
            }
        };

        let ci: u384 = u384 {
            limb0: 23064143363136065070009257005,
            limb1: 2765135843393035962008918388,
            limb2: 1893313542256730901,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 57668269013120043253904814220,
            limb1: 10629463913098397361201934781,
            limb2: 127166023627766654,
            limb3: 0
        };

        let (
            Q0_result,
            Q1_result,
            f_i_plus_one_of_z_result,
            lhs_i_plus_one_result,
            ci_plus_one_result
        ) =
            run_BN254_MP_CHECK_BIT00_LOOP_2_circuit(
            yInv_0, xNegOverY_0, Q0, yInv_1, xNegOverY_1, Q1, lhs_i, f_i_of_z, f_i_plus_one, ci, z
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 44073475858212228399057863189,
                limb1: 32643628884776505792208005319,
                limb2: 1189064940912579828,
                limb3: 0
            },
            x1: u384 {
                limb0: 69624629100642522070735274909,
                limb1: 42107432047199502639004195300,
                limb2: 1831586077126435367,
                limb3: 0
            },
            y0: u384 {
                limb0: 10541420254114124725449062076,
                limb1: 38547623192093709554707228246,
                limb2: 1212900991797973267,
                limb3: 0
            },
            y1: u384 {
                limb0: 21466101801007510738832329887,
                limb1: 76762872274467676356794350464,
                limb2: 590708868127710498,
                limb3: 0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 51249068679767365080417291392,
                limb1: 33823196124250136673042422234,
                limb2: 1678526034329191661,
                limb3: 0
            },
            x1: u384 {
                limb0: 72723545030845669566835742387,
                limb1: 34357138428278720478413492543,
                limb2: 2285274373222203124,
                limb3: 0
            },
            y0: u384 {
                limb0: 35708846713964936804275635743,
                limb1: 37314435251095988185041872159,
                limb2: 2087166373577590261,
                limb3: 0
            },
            y1: u384 {
                limb0: 62353697862932411965006568211,
                limb1: 13834127355163650181978797694,
                limb2: 636105253099955611,
                limb3: 0
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 59349604041521332078401617226,
            limb1: 3537497696581483045516554540,
            limb2: 2388457305707382371,
            limb3: 0
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 19036756460513111428969917799,
            limb1: 67128766323282627976323506726,
            limb2: 2908124085231108922,
            limb3: 0
        };

        let ci_plus_one: u384 = u384 {
            limb0: 63884971211095474888271176247,
            limb1: 49000764346494931110987095180,
            limb2: 1303602063668134288,
            limb3: 0
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
            limb0: 4763261954226386809437988539,
            limb1: 60531775598023169222081097936,
            limb2: 2559892368643955360,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 18794665331390672789800373262,
            limb1: 78541158346292893009241532785,
            limb2: 2527131598558803326,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 41512138111599967039138187523,
                limb1: 32784152957523101412322553879,
                limb2: 716684672101825889,
                limb3: 0
            },
            x1: u384 {
                limb0: 34335309962885374496883196935,
                limb1: 26782621622313035913822846415,
                limb2: 2248337531674787751,
                limb3: 0
            },
            y0: u384 {
                limb0: 53476740616247092368135894014,
                limb1: 21263650955944164284619298301,
                limb2: 1034805535377293397,
                limb3: 0
            },
            y1: u384 {
                limb0: 25772833318423523099588649688,
                limb1: 50175011284300330101970223227,
                limb2: 810067380968407454,
                limb3: 0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 68739302025265533953162042071,
            limb1: 23915586851074008375047190960,
            limb2: 2837846224852590083,
            limb3: 0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 29839136115469108541317959843,
            limb1: 59928671267213639925642811199,
            limb2: 3389697973300195108,
            limb3: 0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 28076448180194629576542540836,
                limb1: 22951859633486775954988026889,
                limb2: 561550657235862592,
                limb3: 0
            },
            x1: u384 {
                limb0: 68430144437327601734278869348,
                limb1: 79152149615863073380655483143,
                limb2: 1592985794537855090,
                limb3: 0
            },
            y0: u384 {
                limb0: 46683124555661529986750196430,
                limb1: 10647548305496202549865875766,
                limb2: 1211284981420318909,
                limb3: 0
            },
            y1: u384 {
                limb0: 63670180867714441588990961873,
                limb1: 48613698052241828271350688995,
                limb2: 2841166606483882215,
                limb3: 0
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 73026802066261741386954378285,
            limb1: 54680557094274100905375286440,
            limb2: 3197484700973369157,
            limb3: 0
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 23099336789506360119657847227,
            limb1: 7663339323243843787938350294,
            limb2: 2865097749586082557,
            limb3: 0
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 68680858316650365928206381450,
                limb1: 52872664395790420559680186513,
                limb2: 636442364646432344,
                limb3: 0
            },
            x1: u384 {
                limb0: 70016745374547690777555064859,
                limb1: 35165512302273346169628713835,
                limb2: 3208132846931399001,
                limb3: 0
            },
            y0: u384 {
                limb0: 7551303726750904089306408178,
                limb1: 7489695155071658202603939010,
                limb2: 163183002246752337,
                limb3: 0
            },
            y1: u384 {
                limb0: 27141050246335506145179263223,
                limb1: 61359626151645290648816968639,
                limb2: 1403141982703508371,
                limb3: 0
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 75164736444848672102482833490,
            limb1: 24256376622029447206460022123,
            limb2: 1891257903402342694,
            limb3: 0
        };

        let f_i_of_z: u384 = u384 {
            limb0: 64407908820215540787274869508,
            limb1: 77106348553075271644473439327,
            limb2: 680897993778232857,
            limb3: 0
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 55209875852685193781652355136,
                limb1: 55306856926399327576239573858,
                limb2: 2747577437254952230,
                limb3: 0
            },
            w1: u384 {
                limb0: 77779967843764946864411040194,
                limb1: 21128509574656814243262863433,
                limb2: 3375383533521755835,
                limb3: 0
            },
            w2: u384 {
                limb0: 29778279441516612857196911029,
                limb1: 2853884113489289061735285895,
                limb2: 532181675341198210,
                limb3: 0
            },
            w3: u384 {
                limb0: 64758244199314254565995779732,
                limb1: 25222577286414459867275418662,
                limb2: 3117382642239996401,
                limb3: 0
            },
            w4: u384 {
                limb0: 67848466570559193034261753427,
                limb1: 70191544040125742712630265117,
                limb2: 118896270411703166,
                limb3: 0
            },
            w5: u384 {
                limb0: 67309566965325298154031429163,
                limb1: 78731803720596620846254286313,
                limb2: 1885724716587762026,
                limb3: 0
            },
            w6: u384 {
                limb0: 16486053105978210888132758738,
                limb1: 54165843460295958344539892670,
                limb2: 1218073467282208473,
                limb3: 0
            },
            w7: u384 {
                limb0: 10637736581276740872202573407,
                limb1: 13574556094113647884803951072,
                limb2: 2033581497069020375,
                limb3: 0
            },
            w8: u384 {
                limb0: 72593361513602150287445855969,
                limb1: 63568218407633871508674389779,
                limb2: 2970189470054756956,
                limb3: 0
            },
            w9: u384 {
                limb0: 26504041808206168725568964881,
                limb1: 69199175886302684603409507936,
                limb2: 180344751002568193,
                limb3: 0
            },
            w10: u384 {
                limb0: 8065887409496938898341597165,
                limb1: 40208310316078105698257927424,
                limb2: 2540080683578227919,
                limb3: 0
            },
            w11: u384 {
                limb0: 37449469184147634284849391499,
                limb1: 18204306027512824630904301582,
                limb2: 1680139565832012718,
                limb3: 0
            }
        };

        let ci: u384 = u384 {
            limb0: 67516596723133538645904431284,
            limb1: 72636819603573513631064533405,
            limb2: 2107175956069581514,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 5426488480244224812914819524,
            limb1: 44852668295603369426664393406,
            limb2: 472677531728381459,
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
            run_BN254_MP_CHECK_BIT00_LOOP_3_circuit(
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
                limb0: 41255549478244973174232396078,
                limb1: 60998641345812684807373232124,
                limb2: 2696287379458985090,
                limb3: 0
            },
            x1: u384 {
                limb0: 66451000520760080212484391701,
                limb1: 43101679827546790833179084430,
                limb2: 3201706131775171932,
                limb3: 0
            },
            y0: u384 {
                limb0: 65046304417832357303844048802,
                limb1: 72859344986806237655004237451,
                limb2: 3219083988086292902,
                limb3: 0
            },
            y1: u384 {
                limb0: 22974427521022570158941472791,
                limb1: 42826679347251494698554520572,
                limb2: 1426520387104020515,
                limb3: 0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 11231453314284778004431323363,
                limb1: 7444798056152890041056560355,
                limb2: 3361191548153999631,
                limb3: 0
            },
            x1: u384 {
                limb0: 60066381723344044250336995275,
                limb1: 7870693530410673242707089753,
                limb2: 776497026480803789,
                limb3: 0
            },
            y0: u384 {
                limb0: 39169707593049788233893096610,
                limb1: 64039592804763401870946262324,
                limb2: 1876782204714257782,
                limb3: 0
            },
            y1: u384 {
                limb0: 66111349589825105649107927339,
                limb1: 60352996128968840557397632353,
                limb2: 6151478690861116,
                limb3: 0
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 62711581075241703105999165956,
                limb1: 52864638254700616799026379439,
                limb2: 735074872005126929,
                limb3: 0
            },
            x1: u384 {
                limb0: 67307575974935294967735295794,
                limb1: 77246684757857655418444287934,
                limb2: 1317978470857871628,
                limb3: 0
            },
            y0: u384 {
                limb0: 58582924551606482102872885459,
                limb1: 75231684042278818798765353857,
                limb2: 779942863083218387,
                limb3: 0
            },
            y1: u384 {
                limb0: 53126514668324611544218326802,
                limb1: 19873971118497590081200886264,
                limb2: 2025965193061098996,
                limb3: 0
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 32677693909094688965857408868,
            limb1: 42988136214908682552445220868,
            limb2: 695335750185127878,
            limb3: 0
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 20767612648256515617646946692,
            limb1: 30073994748128959070041288970,
            limb2: 985985466099619197,
            limb3: 0
        };

        let ci_plus_one: u384 = u384 {
            limb0: 27813539805475246861973802146,
            limb1: 35484259695496126917501614679,
            limb2: 980505463061415503,
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
    fn test_run_BN254_MP_CHECK_BIT0_LOOP_2_circuit_BN254() {
        let yInv_0: u384 = u384 {
            limb0: 63828685066947630922975353776,
            limb1: 46874249935716242262888024864,
            limb2: 3158727899209380626,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 20403209401591130505264693692,
            limb1: 60742331115123688889197177088,
            limb2: 2537870228690191557,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 61632048642984016832499234434,
                limb1: 71626349267372681298354312184,
                limb2: 1637440734709691145,
                limb3: 0
            },
            x1: u384 {
                limb0: 23165924960427992418424883234,
                limb1: 43670619615576987550395292968,
                limb2: 876182643989924760,
                limb3: 0
            },
            y0: u384 {
                limb0: 31711079965203709156035949551,
                limb1: 60902100687846733972944848508,
                limb2: 1701625215950095631,
                limb3: 0
            },
            y1: u384 {
                limb0: 24576305244826198836719740984,
                limb1: 36488745483947513531105155747,
                limb2: 2604243905015219842,
                limb3: 0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 28120877726823401087810050131,
            limb1: 32732532550282283979784821930,
            limb2: 392521011729807682,
            limb3: 0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 522928358916483709887294951,
            limb1: 209750390894933643892086967,
            limb2: 2019143562535353843,
            limb3: 0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 53599540410731708683922892263,
                limb1: 12438030894538944423465099813,
                limb2: 2453176180603066763,
                limb3: 0
            },
            x1: u384 {
                limb0: 32783732587050539545039901541,
                limb1: 72654544706673280494660023601,
                limb2: 1939883284479720902,
                limb3: 0
            },
            y0: u384 {
                limb0: 51673821268896693364346958334,
                limb1: 34138937816373818623014010228,
                limb2: 562062543756109757,
                limb3: 0
            },
            y1: u384 {
                limb0: 63663109444558440967244709236,
                limb1: 36966046034983973804950385180,
                limb2: 162583768232576679,
                limb3: 0
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 38062202088959776513118961237,
            limb1: 52624060555178977357181458921,
            limb2: 3056794190185879999,
            limb3: 0
        };

        let f_i_of_z: u384 = u384 {
            limb0: 75249961544109463509781404021,
            limb1: 41953659324626388125284063199,
            limb2: 291859607066500761,
            limb3: 0
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 12470654473779493550900849137,
                limb1: 74605501607480428090093886789,
                limb2: 2915181205756386395,
                limb3: 0
            },
            w1: u384 {
                limb0: 47936656584741649271334500668,
                limb1: 34435534296620533705544015335,
                limb2: 1436068762335363148,
                limb3: 0
            },
            w2: u384 {
                limb0: 33965401854758827358743122716,
                limb1: 64947362518551314185623294556,
                limb2: 1293304807272578472,
                limb3: 0
            },
            w3: u384 {
                limb0: 42614487941160749076441838342,
                limb1: 25189018362215397697942903566,
                limb2: 1578413340369522531,
                limb3: 0
            },
            w4: u384 {
                limb0: 62003202151866399579328156241,
                limb1: 11227204044357346327875790770,
                limb2: 27336061717904587,
                limb3: 0
            },
            w5: u384 {
                limb0: 41919216047182465214441612480,
                limb1: 12558979242415415767683493177,
                limb2: 897016373801476810,
                limb3: 0
            },
            w6: u384 {
                limb0: 49740640219765361424413700059,
                limb1: 1516543327127282185838070382,
                limb2: 3390779977847637623,
                limb3: 0
            },
            w7: u384 {
                limb0: 6173816635189533500278498159,
                limb1: 18755965635399492264324060977,
                limb2: 3291894557846350181,
                limb3: 0
            },
            w8: u384 {
                limb0: 40319134702582145609807726458,
                limb1: 64199497162571021157368859867,
                limb2: 463113059401620942,
                limb3: 0
            },
            w9: u384 {
                limb0: 13031923161871817281242121181,
                limb1: 5168039338665039897238459817,
                limb2: 1968023344079995329,
                limb3: 0
            },
            w10: u384 {
                limb0: 48304539205139311118174567712,
                limb1: 24324560982343155430342538851,
                limb2: 2271338732440707727,
                limb3: 0
            },
            w11: u384 {
                limb0: 19851254444464131326071465345,
                limb1: 31524763925617403688578049374,
                limb2: 2008905481883081650,
                limb3: 0
            }
        };

        let ci: u384 = u384 {
            limb0: 36865893138752381863691925071,
            limb1: 45064079077235270960965612784,
            limb2: 2602906089233504562,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 3294802236484690023520511962,
            limb1: 68528299589172556746033201596,
            limb2: 416229306531933329,
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
                limb0: 8839248902494384524356236308,
                limb1: 71194066929622733181060184036,
                limb2: 2312237429246682721,
                limb3: 0
            },
            x1: u384 {
                limb0: 15216040481955851631585283490,
                limb1: 66217830700151382924735458844,
                limb2: 2804693737487028139,
                limb3: 0
            },
            y0: u384 {
                limb0: 75498921671312053931726671469,
                limb1: 17879293268781383432841307863,
                limb2: 2699242717070706154,
                limb3: 0
            },
            y1: u384 {
                limb0: 57945867117520283708742717751,
                limb1: 10991088171416939234449433001,
                limb2: 1293679381003323104,
                limb3: 0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 30189354641471597159498477117,
                limb1: 42790858268818715605336681093,
                limb2: 2785379502922686414,
                limb3: 0
            },
            x1: u384 {
                limb0: 59317240586527418978055706691,
                limb1: 70620042546277641011468735071,
                limb2: 1941319479831035146,
                limb3: 0
            },
            y0: u384 {
                limb0: 53686513718798775623943932579,
                limb1: 75584655942501489765808709806,
                limb2: 2328340612878443463,
                limb3: 0
            },
            y1: u384 {
                limb0: 70037723133766915938804637417,
                limb1: 52594531648610387216991582413,
                limb2: 1884621484946147013,
                limb3: 0
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 36393596189000227602842311899,
            limb1: 15383931486396112602724277199,
            limb2: 3446089001304695255,
            limb3: 0
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 24801779615888950869418801390,
            limb1: 69100893638676276024624010313,
            limb2: 2065353636270199961,
            limb3: 0
        };

        let ci_plus_one: u384 = u384 {
            limb0: 62656405684896916308549249356,
            limb1: 7183245536298074823211300409,
            limb2: 129475788558794539,
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
            limb0: 47133422353112402340849530876,
            limb1: 44752167384209374327380240683,
            limb2: 1437648320336762322,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 6756075955383050000581440064,
            limb1: 56465744955709897884594255746,
            limb2: 1108989478781188922,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 8868884650482130038210671678,
                limb1: 22409004021799231974798230841,
                limb2: 2615157671783318086,
                limb3: 0
            },
            x1: u384 {
                limb0: 34964741611229743163148634048,
                limb1: 78431353415117558085556721330,
                limb2: 3046500670292997383,
                limb3: 0
            },
            y0: u384 {
                limb0: 75760463788921729942366959296,
                limb1: 5639411576906655301498676786,
                limb2: 1199310194377072857,
                limb3: 0
            },
            y1: u384 {
                limb0: 14590780272113077514645365568,
                limb1: 15077086856692009022288764061,
                limb2: 933898375945332886,
                limb3: 0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 17064849834975020934055456399,
            limb1: 74671939736202130735107756211,
            limb2: 2794853688606092197,
            limb3: 0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 11311009233185433147091736067,
            limb1: 10464344270139619298991590136,
            limb2: 846930522370490180,
            limb3: 0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 37261635734833333731436183099,
                limb1: 24619106318614291008075679573,
                limb2: 3414104269821247500,
                limb3: 0
            },
            x1: u384 {
                limb0: 74803845761443148259350222309,
                limb1: 40675518158069903288693888951,
                limb2: 460310159371546915,
                limb3: 0
            },
            y0: u384 {
                limb0: 55811786824353126530055717282,
                limb1: 196826358874971942354012689,
                limb2: 2075931799570338039,
                limb3: 0
            },
            y1: u384 {
                limb0: 66243592746987396565246576839,
                limb1: 77693982139173374312763494759,
                limb2: 42812792277292769,
                limb3: 0
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 8926507043313375618964785517,
            limb1: 78009188183834090829167776570,
            limb2: 2757485793340214340,
            limb3: 0
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 58808501583982032093699093042,
            limb1: 68149864728234120294230848093,
            limb2: 1809846612130873852,
            limb3: 0
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 44345925271483599896711170195,
                limb1: 22240339698432406044559663775,
                limb2: 404773812622931682,
                limb3: 0
            },
            x1: u384 {
                limb0: 60911871366212462024386309219,
                limb1: 54841280432253425550758966867,
                limb2: 2271678112296477230,
                limb3: 0
            },
            y0: u384 {
                limb0: 33584277964875212908659347695,
                limb1: 15877570205041754883318074363,
                limb2: 230813162513939362,
                limb3: 0
            },
            y1: u384 {
                limb0: 366373245613493269652519249,
                limb1: 49530877932892394910267443645,
                limb2: 1286023032744387634,
                limb3: 0
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 79112729457546222336246410778,
            limb1: 59949755583037234823120129117,
            limb2: 2069839830089534162,
            limb3: 0
        };

        let f_i_of_z: u384 = u384 {
            limb0: 3058297508715529001240591269,
            limb1: 14020691617746497498302540058,
            limb2: 2362208942991120669,
            limb3: 0
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 60030538777388006090851407284,
                limb1: 75008762609210965385317884370,
                limb2: 889534383539041852,
                limb3: 0
            },
            w1: u384 {
                limb0: 36171418164488781502103783880,
                limb1: 64354486880266125270113810011,
                limb2: 2408512056910900237,
                limb3: 0
            },
            w2: u384 {
                limb0: 43055974361430650580861241242,
                limb1: 41014096747722950426777698332,
                limb2: 11347008718106491,
                limb3: 0
            },
            w3: u384 {
                limb0: 6337230112485467030508423307,
                limb1: 48134346612603190950584288583,
                limb2: 2629925514712819366,
                limb3: 0
            },
            w4: u384 {
                limb0: 9416009238690081890042949788,
                limb1: 73327110131206408904159789424,
                limb2: 842090525309884086,
                limb3: 0
            },
            w5: u384 {
                limb0: 1521244786588960082248549299,
                limb1: 48129361997212224422393408606,
                limb2: 203557544872831773,
                limb3: 0
            },
            w6: u384 {
                limb0: 6133987080371847192281820612,
                limb1: 34916380138120651780984504744,
                limb2: 2786112421350079748,
                limb3: 0
            },
            w7: u384 {
                limb0: 32659963674391348732124959762,
                limb1: 35948119188199523611310040372,
                limb2: 1218174091482783244,
                limb3: 0
            },
            w8: u384 {
                limb0: 30713498703518704024315768161,
                limb1: 7630086101181271511421968851,
                limb2: 120764701252838344,
                limb3: 0
            },
            w9: u384 {
                limb0: 36165742904356990050587531045,
                limb1: 59105121330069844772275550158,
                limb2: 3204418568634846813,
                limb3: 0
            },
            w10: u384 {
                limb0: 6373940289833763056316573815,
                limb1: 42435688055817474272143891294,
                limb2: 1853589523652619850,
                limb3: 0
            },
            w11: u384 {
                limb0: 68013252073298320616311307782,
                limb1: 2202275134508436563373561093,
                limb2: 2379007547955947439,
                limb3: 0
            }
        };

        let ci: u384 = u384 {
            limb0: 65487869088070178398374263371,
            limb1: 28407228105866978034509213751,
            limb2: 454186095505344397,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 11637323752077453075261692207,
            limb1: 61744531492706732635850430639,
            limb2: 183285959490411073,
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
                limb0: 15349811787227508480962627950,
                limb1: 12557972170205532035713911510,
                limb2: 282797396096238231,
                limb3: 0
            },
            x1: u384 {
                limb0: 53501230922287013240595800308,
                limb1: 46664400871192795007143256091,
                limb2: 1656691155563297182,
                limb3: 0
            },
            y0: u384 {
                limb0: 21539673069524604104116505201,
                limb1: 39022810512604971478655797917,
                limb2: 3440439378856949159,
                limb3: 0
            },
            y1: u384 {
                limb0: 71847800856512185109897765139,
                limb1: 61767593260706783962536292893,
                limb2: 999804785713149485,
                limb3: 0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 28892699378251662419653842602,
                limb1: 69419265334802796963463433764,
                limb2: 1935109336749237104,
                limb3: 0
            },
            x1: u384 {
                limb0: 16963786014313954199866028244,
                limb1: 59236381740561507345685020797,
                limb2: 3358980988333241263,
                limb3: 0
            },
            y0: u384 {
                limb0: 35115647017689765992967322101,
                limb1: 5539326904968394003144933846,
                limb2: 3401212762354954979,
                limb3: 0
            },
            y1: u384 {
                limb0: 20097133002418407218927009997,
                limb1: 4343793207015314051264778513,
                limb2: 1282684372399060692,
                limb3: 0
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 50738956632865738887276991488,
                limb1: 21328643802154906569664921840,
                limb2: 2719655395146400893,
                limb3: 0
            },
            x1: u384 {
                limb0: 21999089316784600515615694611,
                limb1: 394446242169629563482142745,
                limb2: 2378156581800252516,
                limb3: 0
            },
            y0: u384 {
                limb0: 54222125280922077817968147203,
                limb1: 32267869903527878619952313770,
                limb2: 374191070990319788,
                limb3: 0
            },
            y1: u384 {
                limb0: 63003946866940550062653193194,
                limb1: 20077038008779335578388326752,
                limb2: 1740072335280578414,
                limb3: 0
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 47962644641338185852815868962,
            limb1: 5709460614553615194269324653,
            limb2: 1478852929196619780,
            limb3: 0
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 25206273563518756734061781865,
            limb1: 54449644865377341647030322541,
            limb2: 2731093993063416450,
            limb3: 0
        };

        let ci_plus_one: u384 = u384 {
            limb0: 6700241050845987352741300511,
            limb1: 27170259181045729788551202989,
            limb2: 328312679456626348,
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
            limb0: 64026365846906328639163432873,
            limb1: 50820010559868434117729584070,
            limb2: 1660640564145839507,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 38774155857372102313108973546,
            limb1: 4921779821513030050014573668,
            limb2: 2987897008362226645,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 54529425592030314495987260654,
                limb1: 6851016397119326702792896336,
                limb2: 2808762025298888383,
                limb3: 0
            },
            x1: u384 {
                limb0: 15078689703736481958880555339,
                limb1: 70150642619688391694900677570,
                limb2: 3479420669516947364,
                limb3: 0
            },
            y0: u384 {
                limb0: 6046302352115806399523487471,
                limb1: 33712864956856725664916199132,
                limb2: 973406119932416487,
                limb3: 0
            },
            y1: u384 {
                limb0: 62582194420179581495105754064,
                limb1: 6226994357394040813600725338,
                limb2: 3388724652265010145,
                limb3: 0
            }
        };

        let Q_or_Qneg_0: G2Point = G2Point {
            x0: u384 {
                limb0: 35868580201980175798384945946,
                limb1: 70297520218959798067250680904,
                limb2: 2327059416361182175,
                limb3: 0
            },
            x1: u384 {
                limb0: 54748122982040470589446853424,
                limb1: 13440541833695280678918881065,
                limb2: 1586745190572168112,
                limb3: 0
            },
            y0: u384 {
                limb0: 71874488540384374795444767891,
                limb1: 16414937502867385501496863176,
                limb2: 192487944546520370,
                limb3: 0
            },
            y1: u384 {
                limb0: 38300992854652737740881276544,
                limb1: 61137472978067645050164631072,
                limb2: 1426675893481933316,
                limb3: 0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 71355692293203939278582129615,
            limb1: 50599401579287117928993886085,
            limb2: 1552357597401047089,
            limb3: 0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 50141472741814258890884423618,
            limb1: 496542412608195782218176704,
            limb2: 3248381136439272246,
            limb3: 0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 21146902647905647422790697817,
                limb1: 67677091203406501715985251694,
                limb2: 3118399561064486474,
                limb3: 0
            },
            x1: u384 {
                limb0: 65308807942722836563114867656,
                limb1: 2959934307050988080387963334,
                limb2: 2716494296280410999,
                limb3: 0
            },
            y0: u384 {
                limb0: 13440627713971969863626243692,
                limb1: 58858649209118334180124236888,
                limb2: 1080027509981497317,
                limb3: 0
            },
            y1: u384 {
                limb0: 37690719615954428163874656816,
                limb1: 4244728036168618369225663617,
                limb2: 2516575554575040528,
                limb3: 0
            }
        };

        let Q_or_Qneg_1: G2Point = G2Point {
            x0: u384 {
                limb0: 68154576695913104687195054974,
                limb1: 40849560775816445775136414532,
                limb2: 3166139698791663823,
                limb3: 0
            },
            x1: u384 {
                limb0: 1753801619810257441885522675,
                limb1: 27381864512839682625373801909,
                limb2: 1053648718334774813,
                limb3: 0
            },
            y0: u384 {
                limb0: 5190707814069189418574043727,
                limb1: 61270667221126485959803345861,
                limb2: 1719085130332750119,
                limb3: 0
            },
            y1: u384 {
                limb0: 49374192443639383975281388212,
                limb1: 745571296280297725225328335,
                limb2: 22834030792918241,
                limb3: 0
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 40325426833326744735886888673,
            limb1: 7262528490204356082612056813,
            limb2: 1405483423238662214,
            limb3: 0
        };

        let f_i_of_z: u384 = u384 {
            limb0: 69758375838535118879671887479,
            limb1: 22413536039569461843179400508,
            limb2: 2824272548771141903,
            limb3: 0
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 51988079820349692990326925074,
                limb1: 50084833387663015910181222150,
                limb2: 1654447730207351629,
                limb3: 0
            },
            w1: u384 {
                limb0: 28459863306500410890880447745,
                limb1: 60793668949135775458696287936,
                limb2: 3294447658301387972,
                limb3: 0
            },
            w2: u384 {
                limb0: 68652363622391896691548157163,
                limb1: 71590476185503395459284349466,
                limb2: 556296320186746532,
                limb3: 0
            },
            w3: u384 {
                limb0: 48970255773288294031132880826,
                limb1: 31634871561716177005379903234,
                limb2: 1435182316460810781,
                limb3: 0
            },
            w4: u384 {
                limb0: 24919153742992842556802789114,
                limb1: 130034321325176858648922344,
                limb2: 2175637043055850216,
                limb3: 0
            },
            w5: u384 {
                limb0: 70590593608968827887267376732,
                limb1: 65027798886365151293818140789,
                limb2: 1989256348301490822,
                limb3: 0
            },
            w6: u384 {
                limb0: 45586510869709030398016785436,
                limb1: 32206473263892644171114627753,
                limb2: 1215007074043178982,
                limb3: 0
            },
            w7: u384 {
                limb0: 25892680486105489857545959366,
                limb1: 14326292638442238490394943009,
                limb2: 3221947841678541130,
                limb3: 0
            },
            w8: u384 {
                limb0: 18518290914818918512858840057,
                limb1: 641147932105966346159805219,
                limb2: 2465301084834809975,
                limb3: 0
            },
            w9: u384 {
                limb0: 58712917790692182310368421174,
                limb1: 67166948205804054822679327738,
                limb2: 2399094484452375856,
                limb3: 0
            },
            w10: u384 {
                limb0: 73549195812559701950068368734,
                limb1: 37608413100817446569655225095,
                limb2: 1705616585298464,
                limb3: 0
            },
            w11: u384 {
                limb0: 46175012992090631706023952691,
                limb1: 29113664974231617401603587914,
                limb2: 1555639245517579223,
                limb3: 0
            }
        };

        let c_or_cinv_of_z: u384 = u384 {
            limb0: 50765213597479777785721101234,
            limb1: 40963402582106368657991311623,
            limb2: 1160845638058944183,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 56635611217506672887878641935,
            limb1: 1911913716890414130495628653,
            limb2: 163596368135185713,
            limb3: 0
        };

        let ci: u384 = u384 {
            limb0: 15976839731542164805609032545,
            limb1: 39643406941001030750618906694,
            limb2: 2580691199795836389,
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
                limb0: 12333857242050236899243427871,
                limb1: 58108049730832613391281274314,
                limb2: 2239763838352493418,
                limb3: 0
            },
            x1: u384 {
                limb0: 40182644633164436996549894790,
                limb1: 56584543770397183451406745580,
                limb2: 3427293284637521198,
                limb3: 0
            },
            y0: u384 {
                limb0: 50386513866786915948297890471,
                limb1: 49668220247646101272487861732,
                limb2: 596810783615550800,
                limb3: 0
            },
            y1: u384 {
                limb0: 64431849915350401938384850425,
                limb1: 49244745899350990352193645812,
                limb2: 1084164371707796256,
                limb3: 0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 58867657078070315280707223,
                limb1: 49538897662137446992057227938,
                limb2: 2963639882755194924,
                limb3: 0
            },
            x1: u384 {
                limb0: 1749650619383934156735104038,
                limb1: 16515734052904311506870206550,
                limb2: 2690253175059495577,
                limb3: 0
            },
            y0: u384 {
                limb0: 19249046182378747208908154869,
                limb1: 56374185125592427080102797729,
                limb2: 149356885581976452,
                limb3: 0
            },
            y1: u384 {
                limb0: 76725289197313456873403490096,
                limb1: 76012269174432086926312671613,
                limb2: 1830542992205246945,
                limb3: 0
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 6810831553518545957977092187,
            limb1: 8620691489199477467116262999,
            limb2: 2315839951263589350,
            limb3: 0
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 6952403210811687876636588768,
            limb1: 19994118062347261967519111535,
            limb2: 2347586832863447113,
            limb3: 0
        };

        let ci_plus_one: u384 = u384 {
            limb0: 41348179085229001866877532914,
            limb1: 19948580139174606941964807942,
            limb2: 2065289114160507314,
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
            limb0: 70939046915473242075982338704,
            limb1: 27531811077712456213560818851,
            limb2: 2422554834289164774,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 41851469434904724458295808169,
            limb1: 57976039821788336601693741787,
            limb2: 2840780784430482880,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 61769001537447365086672873350,
                limb1: 15170005479607035239714000699,
                limb2: 3182833795837427655,
                limb3: 0
            },
            x1: u384 {
                limb0: 11222049120254867507492347726,
                limb1: 40087718296520663544834658647,
                limb2: 843493828749528156,
                limb3: 0
            },
            y0: u384 {
                limb0: 74519714301022721982591136441,
                limb1: 7224912261849236419938503203,
                limb2: 825691007495586600,
                limb3: 0
            },
            y1: u384 {
                limb0: 65376771581868022656926508702,
                limb1: 22175397731029057750064052446,
                limb2: 3230385643391717876,
                limb3: 0
            }
        };

        let Q_or_Qneg_0: G2Point = G2Point {
            x0: u384 {
                limb0: 74164395698624838140418040401,
                limb1: 48031670918182583506611669513,
                limb2: 2155759635597316512,
                limb3: 0
            },
            x1: u384 {
                limb0: 56852846808489822689740123582,
                limb1: 11140774021101840986288206811,
                limb2: 887306080367567343,
                limb3: 0
            },
            y0: u384 {
                limb0: 65550237897328409315455988210,
                limb1: 42420011126595744922794256188,
                limb2: 130844116525820631,
                limb3: 0
            },
            y1: u384 {
                limb0: 61338872435875800003694136670,
                limb1: 72645270383552108796198227124,
                limb2: 2014998727793649695,
                limb3: 0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 42614890725717984271195967867,
            limb1: 49265756029185915352823390771,
            limb2: 742778130523002825,
            limb3: 0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 35959512528527022700017035821,
            limb1: 8596087296127202567195763781,
            limb2: 235393588143160956,
            limb3: 0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 1017394922389336619339981030,
                limb1: 13986297608783013371255600202,
                limb2: 1602222107939530159,
                limb3: 0
            },
            x1: u384 {
                limb0: 48887651714098511785154784367,
                limb1: 50128172093191680185877512378,
                limb2: 130174662815993653,
                limb3: 0
            },
            y0: u384 {
                limb0: 40020842434311883389608690183,
                limb1: 72688122522306899294200607525,
                limb2: 1582558109738677194,
                limb3: 0
            },
            y1: u384 {
                limb0: 35947752151104408197265010565,
                limb1: 48218600834213103759420586293,
                limb2: 1479223054529976912,
                limb3: 0
            }
        };

        let Q_or_Qneg_1: G2Point = G2Point {
            x0: u384 {
                limb0: 59392544827858641508480576456,
                limb1: 14988546300618360330595658333,
                limb2: 2665349068470537014,
                limb3: 0
            },
            x1: u384 {
                limb0: 21258957278812674637568378217,
                limb1: 62880764807685291703482816903,
                limb2: 1288510521257631396,
                limb3: 0
            },
            y0: u384 {
                limb0: 30093151956429552804163688670,
                limb1: 7445869518218918148839623794,
                limb2: 218417047284187113,
                limb3: 0
            },
            y1: u384 {
                limb0: 47183151239000661112936643636,
                limb1: 44151089465998076243278132718,
                limb2: 101337560478278112,
                limb3: 0
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 61608167966518959791748918657,
            limb1: 58227079599015331301970436335,
            limb2: 3456045054724070796,
            limb3: 0
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 12668313459677917089615325626,
            limb1: 44142478708659876329222535594,
            limb2: 2286326141983164017,
            limb3: 0
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 57602534108988932089608914162,
                limb1: 49464590362848830307156454880,
                limb2: 356123870671590270,
                limb3: 0
            },
            x1: u384 {
                limb0: 42037709779876442732231155021,
                limb1: 24649928415970865386638358133,
                limb2: 2593747288170711473,
                limb3: 0
            },
            y0: u384 {
                limb0: 72659734912180307591369635597,
                limb1: 5994769871233277257960798845,
                limb2: 68244421491599820,
                limb3: 0
            },
            y1: u384 {
                limb0: 78351196061924936196798035542,
                limb1: 8201334987430881038559045668,
                limb2: 1619787532489562507,
                limb3: 0
            }
        };

        let Q_or_Qneg_2: G2Point = G2Point {
            x0: u384 {
                limb0: 60991181882785449148801909919,
                limb1: 26054618774544967551520216684,
                limb2: 1605297473332700979,
                limb3: 0
            },
            x1: u384 {
                limb0: 24887069490639900400169044901,
                limb1: 10032634212564587979517443706,
                limb2: 2237303798981682052,
                limb3: 0
            },
            y0: u384 {
                limb0: 18450342426571093309087547907,
                limb1: 45088968851958855927952866943,
                limb2: 1266761334262939388,
                limb3: 0
            },
            y1: u384 {
                limb0: 19898969138613733781337133129,
                limb1: 42687011606697467886778407339,
                limb2: 2293909645236143451,
                limb3: 0
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 57355407802952232347002109325,
            limb1: 41136087046772969438560595665,
            limb2: 2503121083105756304,
            limb3: 0
        };

        let f_i_of_z: u384 = u384 {
            limb0: 47099998407085857757075303179,
            limb1: 12054436728086864517720143117,
            limb2: 3176228236232214552,
            limb3: 0
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 71214560539815909844506915169,
                limb1: 73587625385874626062469017234,
                limb2: 2758082330296836740,
                limb3: 0
            },
            w1: u384 {
                limb0: 19249948755232897653393997052,
                limb1: 47851313726077813442024944844,
                limb2: 1465074839335292610,
                limb3: 0
            },
            w2: u384 {
                limb0: 15559743507936529575039347037,
                limb1: 4933121752200094085296535090,
                limb2: 1119946687609630195,
                limb3: 0
            },
            w3: u384 {
                limb0: 53415950094176208175010075009,
                limb1: 52356443885689500673772039249,
                limb2: 502923712475740624,
                limb3: 0
            },
            w4: u384 {
                limb0: 59994819647147234910502696701,
                limb1: 73254895354466208318312831185,
                limb2: 2924111405446491279,
                limb3: 0
            },
            w5: u384 {
                limb0: 70149534095998784879408293365,
                limb1: 39093529419513935678603442101,
                limb2: 886117937259836742,
                limb3: 0
            },
            w6: u384 {
                limb0: 44159279369173998090423121632,
                limb1: 56846673481420923847174942749,
                limb2: 1802328820865981287,
                limb3: 0
            },
            w7: u384 {
                limb0: 52546727230028840960173780162,
                limb1: 78582390663913760313492206645,
                limb2: 310473554228695835,
                limb3: 0
            },
            w8: u384 {
                limb0: 36752281456572119649762728627,
                limb1: 16639497179252436776216649737,
                limb2: 1696530043009905383,
                limb3: 0
            },
            w9: u384 {
                limb0: 1685826783340539348513163453,
                limb1: 6937873060060689181816957783,
                limb2: 1901569277590821463,
                limb3: 0
            },
            w10: u384 {
                limb0: 69238161660661937232108690614,
                limb1: 42850067641650218881786886268,
                limb2: 2920942860173916462,
                limb3: 0
            },
            w11: u384 {
                limb0: 30118537958020207789746262065,
                limb1: 5232646377878285644055052519,
                limb2: 2789361769079530542,
                limb3: 0
            }
        };

        let c_or_cinv_of_z: u384 = u384 {
            limb0: 39038642117437292429920446803,
            limb1: 16159100659374509497653780633,
            limb2: 2845472305631074125,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 12151975343442127049480534287,
            limb1: 8729794004627307850677060432,
            limb2: 515532241417322447,
            limb3: 0
        };

        let ci: u384 = u384 {
            limb0: 66426561194262425679371499498,
            limb1: 30321994217208695740608750567,
            limb2: 3440219280477640525,
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
                limb0: 34792038891558092335745983409,
                limb1: 3265259093149837214511160000,
                limb2: 1072350651036574891,
                limb3: 0
            },
            x1: u384 {
                limb0: 60011335339483442878137307644,
                limb1: 58804794434271023469117630345,
                limb2: 1075550035001795298,
                limb3: 0
            },
            y0: u384 {
                limb0: 43912645885891011983075313115,
                limb1: 43552922912946316028520708467,
                limb2: 1971448774307224357,
                limb3: 0
            },
            y1: u384 {
                limb0: 66474202792253893392838440240,
                limb1: 37940801917205750556639568004,
                limb2: 2465292267437153170,
                limb3: 0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 25652435641459481078174307779,
                limb1: 30686148294328551486211202981,
                limb2: 1680160831340475276,
                limb3: 0
            },
            x1: u384 {
                limb0: 5863555402914327075607346098,
                limb1: 1373957323373010002843241471,
                limb2: 130749239265732400,
                limb3: 0
            },
            y0: u384 {
                limb0: 35810773654600882807654597753,
                limb1: 77871861162032350666018041184,
                limb2: 3318894951245638754,
                limb3: 0
            },
            y1: u384 {
                limb0: 30712776333655471626995820864,
                limb1: 27052849441924792069101057956,
                limb2: 2019294324986885087,
                limb3: 0
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 24997160521828094894918232887,
                limb1: 45416290278960710970254957716,
                limb2: 2855519991380638851,
                limb3: 0
            },
            x1: u384 {
                limb0: 5144658789474616056302900573,
                limb1: 9108686803754184545237361561,
                limb2: 2103405115425528840,
                limb3: 0
            },
            y0: u384 {
                limb0: 45017606692794652133614712715,
                limb1: 31118537380407200694121279785,
                limb2: 1572127213049484456,
                limb3: 0
            },
            y1: u384 {
                limb0: 16178725163898895798011640802,
                limb1: 28372438810741720837185233248,
                limb2: 1328546895324289627,
                limb3: 0
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 49780730274988013155159046887,
            limb1: 67234906926056883990042560373,
            limb2: 1214628208260853548,
            limb3: 0
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 62409644891505487221878815372,
            limb1: 45648536688080869743050172696,
            limb2: 797277971057353839,
            limb3: 0
        };

        let ci_plus_one: u384 = u384 {
            limb0: 18806296438842328632503630027,
            limb1: 23293412143817473048174928341,
            limb2: 1389342479099457309,
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
                limb0: 4098584541868602761177319229,
                limb1: 61324543880068731007191147620,
                limb2: 992837488572360829,
                limb3: 0
            },
            x1: u384 {
                limb0: 35938000301437192478720725253,
                limb1: 7107827861506311423885162893,
                limb2: 1376253992917486187,
                limb3: 0
            },
            y0: u384 {
                limb0: 29478651847044869589994751839,
                limb1: 23686440728335424799820112815,
                limb2: 1252495115542126021,
                limb3: 0
            },
            y1: u384 {
                limb0: 45602323500167005908871502003,
                limb1: 30763337912217705167530755117,
                limb2: 1477685148512601021,
                limb3: 0
            }
        };

        let yInv_0: u384 = u384 {
            limb0: 8971120108025296767864816802,
            limb1: 23544341388597582555879535019,
            limb2: 2103021862329376334,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 75580566908191417482550673165,
            limb1: 62448024711433195110629759904,
            limb2: 2134088480109940165,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 31490212527838705293357968766,
                limb1: 30607252053774557423770309905,
                limb2: 105438958259219763,
                limb3: 0
            },
            x1: u384 {
                limb0: 75021803465503288893227097357,
                limb1: 25959494729749723970796143755,
                limb2: 122369643347558666,
                limb3: 0
            },
            y0: u384 {
                limb0: 67626095766552376916485621558,
                limb1: 62289237394025472694181885609,
                limb2: 308593124916383680,
                limb3: 0
            },
            y1: u384 {
                limb0: 10281652126535449614414823023,
                limb1: 43966243472399590500176834804,
                limb2: 2846202848057157517,
                limb3: 0
            }
        };

        let original_Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 44036445658697997496849780877,
                limb1: 76314303565964447469491780892,
                limb2: 3318147632718930506,
                limb3: 0
            },
            x1: u384 {
                limb0: 7909969066926609502885215813,
                limb1: 56365530567754752970264035980,
                limb2: 2938237765392398375,
                limb3: 0
            },
            y0: u384 {
                limb0: 34509664191190257561371568465,
                limb1: 18935276271710923130766853031,
                limb2: 3195163526724198156,
                limb3: 0
            },
            y1: u384 {
                limb0: 1157029230448858756194892526,
                limb1: 25845334844021523473870476995,
                limb2: 2131549130152470773,
                limb3: 0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 27613251519734233913242449151,
            limb1: 60281537755987612198133741329,
            limb2: 3020683959231241309,
            limb3: 0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 50342357219259858266185606604,
            limb1: 58265420074851220482078498583,
            limb2: 836957523682571115,
            limb3: 0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 43950926370198811519235388654,
                limb1: 71195287463283363497117122188,
                limb2: 916755494673096109,
                limb3: 0
            },
            x1: u384 {
                limb0: 54754830503939850325064935298,
                limb1: 71202970370123592331132257785,
                limb2: 3274746222845981489,
                limb3: 0
            },
            y0: u384 {
                limb0: 27039693793971317790541578767,
                limb1: 30427005037701781107704903291,
                limb2: 2607599842900079665,
                limb3: 0
            },
            y1: u384 {
                limb0: 79135009145194894667551580350,
                limb1: 27886699205464629330446031802,
                limb2: 2922473954607570727,
                limb3: 0
            }
        };

        let R_n_minus_2 = E12D {
            w0: u384 {
                limb0: 13063974522476725659969527068,
                limb1: 55090774676070823517988707894,
                limb2: 3158774724606832438,
                limb3: 0
            },
            w1: u384 {
                limb0: 38322326523617833010307681971,
                limb1: 2162541339405348724315590137,
                limb2: 2094804837769832300,
                limb3: 0
            },
            w2: u384 {
                limb0: 47519389390589294628725441225,
                limb1: 53152526587741788478716608630,
                limb2: 2820372687495650178,
                limb3: 0
            },
            w3: u384 {
                limb0: 49795340709874095007501255021,
                limb1: 34031123296555948256184688954,
                limb2: 1094021948288368800,
                limb3: 0
            },
            w4: u384 {
                limb0: 23389582968169796381567798538,
                limb1: 20196641382878395938052318756,
                limb2: 1115095280793645737,
                limb3: 0
            },
            w5: u384 {
                limb0: 68601251998263727150071121342,
                limb1: 29478018407241824505432268456,
                limb2: 2100784640141463625,
                limb3: 0
            },
            w6: u384 {
                limb0: 26757639256044174904766529520,
                limb1: 11604044828485164110511426463,
                limb2: 1123291179449983558,
                limb3: 0
            },
            w7: u384 {
                limb0: 60202249500430906012554786977,
                limb1: 13704532298570443083201586248,
                limb2: 3249640612862464664,
                limb3: 0
            },
            w8: u384 {
                limb0: 9090659308802206601949834777,
                limb1: 35406434272710716703654808105,
                limb2: 944540465243729793,
                limb3: 0
            },
            w9: u384 {
                limb0: 39355259797163742965775683504,
                limb1: 23272712308223252131313687522,
                limb2: 1260982445361222205,
                limb3: 0
            },
            w10: u384 {
                limb0: 28042700001550849198008681913,
                limb1: 24982595235019596923961321231,
                limb2: 95632608240224482,
                limb3: 0
            },
            w11: u384 {
                limb0: 6412376275938174193000375174,
                limb1: 22799158752248267430776274938,
                limb2: 2243313154539529760,
                limb3: 0
            }
        };

        let R_n_minus_1 = E12D {
            w0: u384 {
                limb0: 24892008244559442082623033631,
                limb1: 58845357491964699885838999338,
                limb2: 3228301310083127681,
                limb3: 0
            },
            w1: u384 {
                limb0: 77896097028732007700706644014,
                limb1: 21084753540801275091853963777,
                limb2: 3321347213920035253,
                limb3: 0
            },
            w2: u384 {
                limb0: 17460523883752519092187278502,
                limb1: 7104296291779367761314070538,
                limb2: 369752805623695814,
                limb3: 0
            },
            w3: u384 {
                limb0: 62620209405991610067701039006,
                limb1: 40099823487861722434077875039,
                limb2: 80841987526017892,
                limb3: 0
            },
            w4: u384 {
                limb0: 7587331061174797911962954874,
                limb1: 18612757199156096520193860668,
                limb2: 190229835407925329,
                limb3: 0
            },
            w5: u384 {
                limb0: 31009551309357584157808348993,
                limb1: 61177417538752129964281456790,
                limb2: 2655261365901462018,
                limb3: 0
            },
            w6: u384 {
                limb0: 58186884940731683530576328238,
                limb1: 16197121838603405620708112703,
                limb2: 628810244995447976,
                limb3: 0
            },
            w7: u384 {
                limb0: 52594768710104835041029866389,
                limb1: 75445704071926598129635180546,
                limb2: 917148657199307890,
                limb3: 0
            },
            w8: u384 {
                limb0: 1362371658405356094629197826,
                limb1: 52170996504356009094468373097,
                limb2: 3127198546777892456,
                limb3: 0
            },
            w9: u384 {
                limb0: 64580357531098132081498023959,
                limb1: 6462104193496910347775616392,
                limb2: 3321490422231975892,
                limb3: 0
            },
            w10: u384 {
                limb0: 67530960341566620951506633330,
                limb1: 22125949685505124253046287262,
                limb2: 2762983886898219530,
                limb3: 0
            },
            w11: u384 {
                limb0: 322499708343051417505398840,
                limb1: 65277051917929843363544909195,
                limb2: 3414191155133717237,
                limb3: 0
            }
        };

        let c_n_minus_3: u384 = u384 {
            limb0: 267364815221167323178459963,
            limb1: 11525642836424219912752266497,
            limb2: 2483628041438676770,
            limb3: 0
        };

        let w_of_z: u384 = u384 {
            limb0: 25253690358596365164667416632,
            limb1: 53067786640290111076947170062,
            limb2: 2105814468748767435,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 69817185405331131517142634842,
            limb1: 74523698158065733126488688061,
            limb2: 2939204410165642690,
            limb3: 0
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 53501239858733417655337176603,
            limb1: 7953171541805036367312206459,
            limb2: 2260388091922254428,
            limb3: 0
        };

        let c_frob_2_of_z: u384 = u384 {
            limb0: 42675959190324458143924098404,
            limb1: 22399684814969690759336336937,
            limb2: 1317736666458652486,
            limb3: 0
        };

        let c_inv_frob_3_of_z: u384 = u384 {
            limb0: 5187593910603894523924327009,
            limb1: 9015783822958565701157778714,
            limb2: 2720879751962340782,
            limb3: 0
        };

        let previous_lhs: u384 = u384 {
            limb0: 36509562462470225025547700235,
            limb1: 20725905240474450258718950166,
            limb2: 3382939687557154791,
            limb3: 0
        };

        let R_n_minus_3_of_z: u384 = u384 {
            limb0: 60321747459675039209086884630,
            limb1: 58554748933969348161092874762,
            limb2: 1222376060994509051,
            limb3: 0
        };

        let Q: Array<u384> = array![
            u384 {
                limb0: 42869213965599544397258055603,
                limb1: 51978686755299197824435564427,
                limb2: 1408372256713189188,
                limb3: 0
            },
            u384 {
                limb0: 40901376011092936982905491514,
                limb1: 78325065791771849285482298076,
                limb2: 969074623833825657,
                limb3: 0
            },
            u384 {
                limb0: 31011979165277377892309630929,
                limb1: 7730270473947571561037048546,
                limb2: 1854425155381084602,
                limb3: 0
            },
            u384 {
                limb0: 53359265714723370804441085045,
                limb1: 51771417010086114172397996685,
                limb2: 148872672531277251,
                limb3: 0
            },
            u384 {
                limb0: 19071099956624224225200588099,
                limb1: 29946815581025132517485374360,
                limb2: 321262675018376674,
                limb3: 0
            },
            u384 {
                limb0: 43414431967669382096805506955,
                limb1: 15743570990438074772811037898,
                limb2: 2267963906862298942,
                limb3: 0
            },
            u384 {
                limb0: 73263073289858482500173720528,
                limb1: 40660179992935931966725400467,
                limb2: 2784511076188187998,
                limb3: 0
            },
            u384 {
                limb0: 45700892903963627285074918041,
                limb1: 49202075320038044633966658533,
                limb2: 2770503157610953426,
                limb3: 0
            },
            u384 {
                limb0: 50787413781935321660786213386,
                limb1: 53293207108026159340048566612,
                limb2: 2173665282448052765,
                limb3: 0
            },
            u384 {
                limb0: 16313683872464816926981619394,
                limb1: 2746421902165755418684024910,
                limb2: 911256111502801758,
                limb3: 0
            },
            u384 {
                limb0: 41036009734521807696659170000,
                limb1: 65416601150731464092315192579,
                limb2: 661078754890340802,
                limb3: 0
            },
            u384 {
                limb0: 37383013646024319685933261912,
                limb1: 21872122076385597906942856842,
                limb2: 2992784132280383636,
                limb3: 0
            },
            u384 {
                limb0: 73003670198092490535771516843,
                limb1: 67888363344692981944101150358,
                limb2: 2236299994050094127,
                limb3: 0
            },
            u384 {
                limb0: 40976799466313116179810284758,
                limb1: 29326934606462606937691699763,
                limb2: 3122877196612193633,
                limb3: 0
            },
            u384 {
                limb0: 40238094969228054774224866857,
                limb1: 54150418673126965892568824411,
                limb2: 348572062727855075,
                limb3: 0
            },
            u384 {
                limb0: 64265398139114145781165576262,
                limb1: 15863804999027842727236700904,
                limb2: 1361339409712335466,
                limb3: 0
            },
            u384 {
                limb0: 33580471057793518331970261323,
                limb1: 58442146033755799485011303083,
                limb2: 1820515129481757154,
                limb3: 0
            },
            u384 {
                limb0: 34929829070565526664400675774,
                limb1: 49870137782332084818578047406,
                limb2: 715098846304479894,
                limb3: 0
            },
            u384 {
                limb0: 65767148926012623806793172004,
                limb1: 27723768806769711747251338458,
                limb2: 2699706968511397773,
                limb3: 0
            },
            u384 {
                limb0: 45367880701402297637685358322,
                limb1: 58712989791715767560474237510,
                limb2: 538526176124821226,
                limb3: 0
            },
            u384 {
                limb0: 11036186669618128695965821968,
                limb1: 67259027706196896920459442947,
                limb2: 1954509730311714093,
                limb3: 0
            },
            u384 {
                limb0: 66475049407404751274051712830,
                limb1: 59425420904917962646960926954,
                limb2: 2642025687927410364,
                limb3: 0
            },
            u384 {
                limb0: 29050697197408790698343603017,
                limb1: 7805810127767194991131829129,
                limb2: 2279439663835585915,
                limb3: 0
            },
            u384 {
                limb0: 36892817997244993874903913503,
                limb1: 58401080270891477426231888312,
                limb2: 1184538445016061826,
                limb3: 0
            },
            u384 {
                limb0: 62827905292876128559644879637,
                limb1: 18823781801195703833607129257,
                limb2: 562498258691417438,
                limb3: 0
            },
            u384 {
                limb0: 46045328632761851470334625511,
                limb1: 61770480685372803311988178197,
                limb2: 737217158463715299,
                limb3: 0
            },
            u384 {
                limb0: 51512992011349297672313064065,
                limb1: 19267605454683082571600302906,
                limb2: 1044427138957987513,
                limb3: 0
            },
            u384 {
                limb0: 12228579240931951690388025984,
                limb1: 64226491315387103387012414378,
                limb2: 2730303644078080381,
                limb3: 0
            },
            u384 {
                limb0: 5380693409027682082213629679,
                limb1: 7563114697317580210415664577,
                limb2: 2872893789976920225,
                limb3: 0
            },
            u384 {
                limb0: 61803127785597368088073072719,
                limb1: 33263761286226839428548686954,
                limb2: 191402597581641221,
                limb3: 0
            },
            u384 {
                limb0: 11199618788494150873362968432,
                limb1: 35772264033257249520481696213,
                limb2: 1600429016605605710,
                limb3: 0
            },
            u384 {
                limb0: 19162653073669152565786733051,
                limb1: 7062896007640458320999428927,
                limb2: 3324275385087139151,
                limb3: 0
            },
            u384 {
                limb0: 60626686099997136385754390398,
                limb1: 45812951411588050919291322676,
                limb2: 2525897804043189794,
                limb3: 0
            },
            u384 {
                limb0: 56315881753501772626589831724,
                limb1: 45119043916109298368001777264,
                limb2: 2459297481937213224,
                limb3: 0
            },
            u384 {
                limb0: 73207529981061687121347949126,
                limb1: 7521658278243136467419240356,
                limb2: 2993196962858524462,
                limb3: 0
            },
            u384 {
                limb0: 4117425054325549108766492475,
                limb1: 61107708467002276126521089353,
                limb2: 2353769128861118759,
                limb3: 0
            },
            u384 {
                limb0: 33582306178164472062595025527,
                limb1: 66785709076960808621204858370,
                limb2: 3429216567196819252,
                limb3: 0
            },
            u384 {
                limb0: 20369361355853926579481108364,
                limb1: 69737560141908704570217176631,
                limb2: 1220894088552277906,
                limb3: 0
            },
            u384 {
                limb0: 1231472605168128212498603308,
                limb1: 20735118299237990720825393985,
                limb2: 3260283692884440815,
                limb3: 0
            },
            u384 {
                limb0: 8657098532431853044595567235,
                limb1: 34549579673642344537038075635,
                limb2: 1487726279815143201,
                limb3: 0
            },
            u384 {
                limb0: 50783078282365790575598563086,
                limb1: 28323292670223673189107078761,
                limb2: 3325120837238690902,
                limb3: 0
            },
            u384 {
                limb0: 34971836057591475902785590436,
                limb1: 66380465544313959026815398297,
                limb2: 1972361035245565291,
                limb3: 0
            },
            u384 {
                limb0: 32494142866328035675340591534,
                limb1: 8363929977093637692030742647,
                limb2: 404892356551657426,
                limb3: 0
            },
            u384 {
                limb0: 55522408518305697986150126542,
                limb1: 38029945981908562619358360628,
                limb2: 1813806961188739497,
                limb3: 0
            },
            u384 {
                limb0: 7655721714141303631592755286,
                limb1: 53503763018812190572454793217,
                limb2: 1366583306422196338,
                limb3: 0
            },
            u384 {
                limb0: 23877195268905884122818075193,
                limb1: 9857799902794131526778864119,
                limb2: 3084232394364072555,
                limb3: 0
            },
            u384 {
                limb0: 10638594018957385066012775,
                limb1: 120542114935408716834494855,
                limb2: 1564760326973028966,
                limb3: 0
            },
            u384 {
                limb0: 36541935864788789533360611392,
                limb1: 13564443444346451244335986930,
                limb2: 2073992621243641390,
                limb3: 0
            },
            u384 {
                limb0: 8180619192049872198614881481,
                limb1: 26115978459286231397418028997,
                limb2: 957960267705553854,
                limb3: 0
            },
            u384 {
                limb0: 9114253818770666200821006742,
                limb1: 23866567963282311723392098351,
                limb2: 426689718886444527,
                limb3: 0
            },
            u384 {
                limb0: 54193046973451653436385783436,
                limb1: 13118128767705961005657882433,
                limb2: 2145545776647657163,
                limb3: 0
            },
            u384 {
                limb0: 44424656307529235825196354315,
                limb1: 76120849242653632623674801422,
                limb2: 463217952886970881,
                limb3: 0
            },
            u384 {
                limb0: 49939827345606239704436398630,
                limb1: 16531765737509021365449939583,
                limb2: 3335587863644959527,
                limb3: 0
            },
            u384 {
                limb0: 33708593831673103603035696581,
                limb1: 663015841848809631003560151,
                limb2: 1941185646769583438,
                limb3: 0
            },
            u384 {
                limb0: 47732885851260472586430164808,
                limb1: 27477346847009857113400026508,
                limb2: 1447335330198555387,
                limb3: 0
            },
            u384 {
                limb0: 67575766874380849956533573669,
                limb1: 37043669468654343552057885026,
                limb2: 3433679881369432886,
                limb3: 0
            },
            u384 {
                limb0: 20066575967284410650236004891,
                limb1: 61433650139957473136275281762,
                limb2: 860104202870806791,
                limb3: 0
            },
            u384 {
                limb0: 71311906696514685795167692249,
                limb1: 50918262836453942542430869060,
                limb2: 1716995674407566346,
                limb3: 0
            },
            u384 {
                limb0: 62461854985208865503582984563,
                limb1: 22684326907109156264289426382,
                limb2: 1139985748912790914,
                limb3: 0
            },
            u384 {
                limb0: 64680300301549414011038453496,
                limb1: 55460859076843018214709401333,
                limb2: 1530026980173724528,
                limb3: 0
            },
            u384 {
                limb0: 34928622021414282344290160915,
                limb1: 15639450639880471258121636090,
                limb2: 940922385168431389,
                limb3: 0
            },
            u384 {
                limb0: 78595889763305535732163043043,
                limb1: 6952538211497294257883684413,
                limb2: 2393520380193423130,
                limb3: 0
            },
            u384 {
                limb0: 74553393661011555450054271048,
                limb1: 48601612047409408764416078232,
                limb2: 958595530108741065,
                limb3: 0
            },
            u384 {
                limb0: 1808068530306947561579521500,
                limb1: 56841564934576314717829587155,
                limb2: 1580563094996991133,
                limb3: 0
            },
            u384 {
                limb0: 60975962542295206456716192413,
                limb1: 35563720832604337215447380210,
                limb2: 2369610937141727570,
                limb3: 0
            },
            u384 {
                limb0: 5086720305151157128499016528,
                limb1: 6819479104923690187601557891,
                limb2: 1747438429758301585,
                limb3: 0
            },
            u384 {
                limb0: 30183259947939074713217857068,
                limb1: 55108112812510175734651077802,
                limb2: 2953214529543241665,
                limb3: 0
            },
            u384 {
                limb0: 22436094781916109185054474396,
                limb1: 31734224734635226835761606678,
                limb2: 3038932258618329,
                limb3: 0
            },
            u384 {
                limb0: 50326405419029871820185422364,
                limb1: 38434638548950200992833288974,
                limb2: 1840456691736186972,
                limb3: 0
            },
            u384 {
                limb0: 78519875147198602289262062276,
                limb1: 76840570062401205412297501866,
                limb2: 3328615114504978503,
                limb3: 0
            },
            u384 {
                limb0: 51205544538289018412065269997,
                limb1: 27465238143854271582407788615,
                limb2: 1957487544959101410,
                limb3: 0
            },
            u384 {
                limb0: 29847854861269829562534373933,
                limb1: 26847061195025633529729338107,
                limb2: 844169805449595239,
                limb3: 0
            },
            u384 {
                limb0: 39385214438305494481900708621,
                limb1: 61460483729360366875599654456,
                limb2: 817052202039149984,
                limb3: 0
            },
            u384 {
                limb0: 2534130000662423669077955326,
                limb1: 78405473933060390265726234955,
                limb2: 45709142971783403,
                limb3: 0
            },
            u384 {
                limb0: 78245230293096471525112544818,
                limb1: 53801649691071770015542247633,
                limb2: 3113701375644535329,
                limb3: 0
            },
            u384 {
                limb0: 22931787995400550217619538862,
                limb1: 24680618954548386822132077247,
                limb2: 2450327714620144876,
                limb3: 0
            },
            u384 {
                limb0: 37937246896392664887193578441,
                limb1: 71001701482888079052504614763,
                limb2: 3048139750717971918,
                limb3: 0
            },
            u384 {
                limb0: 64552797998020726950836922433,
                limb1: 58130843513412314166957878588,
                limb2: 1407771853627689397,
                limb3: 0
            },
            u384 {
                limb0: 4741938959198140559678512936,
                limb1: 56340110177959767040481191212,
                limb2: 1354499901214835058,
                limb3: 0
            },
            u384 {
                limb0: 29223108314932218610734584065,
                limb1: 24468251788387263153972412307,
                limb2: 5408205888363058,
                limb3: 0
            },
            u384 {
                limb0: 3415038750574092369339676379,
                limb1: 47058467315680790180847205350,
                limb2: 780485343407072441,
                limb3: 0
            },
            u384 {
                limb0: 6437088331033215242292189887,
                limb1: 1601922267692449364892185385,
                limb2: 3424327100743604273,
                limb3: 0
            },
            u384 {
                limb0: 63033268699351199164828140749,
                limb1: 56172528710138599401100413159,
                limb2: 2801720567482859616,
                limb3: 0
            },
            u384 {
                limb0: 9175319073946783073562641325,
                limb1: 7931711293936743828190334013,
                limb2: 2246952015097238071,
                limb3: 0
            },
            u384 {
                limb0: 67317117569761349660466538359,
                limb1: 10299778614747442920478013823,
                limb2: 2889349372245169362,
                limb3: 0
            },
            u384 {
                limb0: 2780520271651546327239415081,
                limb1: 43816582887562220386515734980,
                limb2: 434695767102616700,
                limb3: 0
            },
            u384 {
                limb0: 55360493710905517997077254100,
                limb1: 31088401173059695524075379522,
                limb2: 1414473613698351888,
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
            limb0: 61492168170685293945021967752,
            limb1: 12946179363074449716714206174,
            limb2: 1121873063154692413,
            limb3: 0
        };
        assert_eq!(final_check_result, final_check);
    }


    #[test]
    fn test_run_BN254_MP_CHECK_FINALIZE_BN_3_circuit_BN254() {
        let original_Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 54551911900289945936690958811,
                limb1: 8149486517811829973908957821,
                limb2: 2135469526307262198,
                limb3: 0
            },
            x1: u384 {
                limb0: 32669386464892226908437921504,
                limb1: 11131014105259423364719491968,
                limb2: 2443082494953916137,
                limb3: 0
            },
            y0: u384 {
                limb0: 44147410344327378301549553279,
                limb1: 28148935847097031580293963613,
                limb2: 1469943413804885801,
                limb3: 0
            },
            y1: u384 {
                limb0: 64178207999590850159042568735,
                limb1: 1367155208149580448169067204,
                limb2: 701028016847702035,
                limb3: 0
            }
        };

        let yInv_0: u384 = u384 {
            limb0: 10671058804917798179633039002,
            limb1: 62534654244462046124804772920,
            limb2: 3006265990613817206,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 74801228949239708452078544615,
            limb1: 46311506414424179184559978593,
            limb2: 620856459488567006,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 9607066267999394834036289540,
                limb1: 45470204263159137922616686543,
                limb2: 2808023560636773495,
                limb3: 0
            },
            x1: u384 {
                limb0: 45274916417575195593717711706,
                limb1: 69617224096482309685106109930,
                limb2: 436885583291968864,
                limb3: 0
            },
            y0: u384 {
                limb0: 32374444904878172583986153718,
                limb1: 26429048630304055292220450796,
                limb2: 1006802793200492653,
                limb3: 0
            },
            y1: u384 {
                limb0: 2388481871110646268166865055,
                limb1: 79203842722434451417225336412,
                limb2: 3404615514266032878,
                limb3: 0
            }
        };

        let original_Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 14784879212303087339016644878,
                limb1: 66148648846955135929426799420,
                limb2: 3019645528460982616,
                limb3: 0
            },
            x1: u384 {
                limb0: 72283466493283550853867860868,
                limb1: 31739808710107217798293972300,
                limb2: 2261659498598699574,
                limb3: 0
            },
            y0: u384 {
                limb0: 77526624060026172998744215119,
                limb1: 56798455439112220298397786958,
                limb2: 870867782956122303,
                limb3: 0
            },
            y1: u384 {
                limb0: 22453786357827086913922434075,
                limb1: 12021758531297268405149982999,
                limb2: 739522889630017756,
                limb3: 0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 55556363738542719252559407756,
            limb1: 29338279389466912988530222689,
            limb2: 3202736068360288658,
            limb3: 0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 70834331077126993656613726210,
            limb1: 75925581797796193925852888862,
            limb2: 1937645947847446864,
            limb3: 0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 66236102293013480947465310095,
                limb1: 38892490026093057815038858965,
                limb2: 146528694852835744,
                limb3: 0
            },
            x1: u384 {
                limb0: 44992189891482987708330809204,
                limb1: 58940896404756511617619718726,
                limb2: 3110438709769974850,
                limb3: 0
            },
            y0: u384 {
                limb0: 75463978912140717341620914464,
                limb1: 35870231547332785133050347252,
                limb2: 2636622294776619888,
                limb3: 0
            },
            y1: u384 {
                limb0: 69657283917742482050562860027,
                limb1: 71598827313272145688518929656,
                limb2: 347572546945254334,
                limb3: 0
            }
        };

        let original_Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 78849341942955287246159063436,
                limb1: 2220357111977771321588945510,
                limb2: 1023953731612242565,
                limb3: 0
            },
            x1: u384 {
                limb0: 1984505784331409166270180078,
                limb1: 16255691923373143637817512813,
                limb2: 1008513185886132131,
                limb3: 0
            },
            y0: u384 {
                limb0: 31837759511242932590194435621,
                limb1: 29121339872672039847079431425,
                limb2: 1639814966254481895,
                limb3: 0
            },
            y1: u384 {
                limb0: 13106426871240085772162551789,
                limb1: 69456572031718605147984505582,
                limb2: 100351716897447315,
                limb3: 0
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 8237906281483522123577572814,
            limb1: 25168251553103253955823507142,
            limb2: 1016452095636005477,
            limb3: 0
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 30326412368350222515628857285,
            limb1: 50970825046590423040829532541,
            limb2: 430446276571133538,
            limb3: 0
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 12917706548312354776651409912,
                limb1: 44260497042935866298546393389,
                limb2: 544112196620597313,
                limb3: 0
            },
            x1: u384 {
                limb0: 14779315031589592885701220869,
                limb1: 61634636058346831145805879629,
                limb2: 2365013944408329533,
                limb3: 0
            },
            y0: u384 {
                limb0: 24522487991293413052804666474,
                limb1: 47457982799924961758902757866,
                limb2: 607297768561880900,
                limb3: 0
            },
            y1: u384 {
                limb0: 57444773454069261833903576028,
                limb1: 10120715597161880985032460788,
                limb2: 3108618204509578434,
                limb3: 0
            }
        };

        let R_n_minus_2 = E12D {
            w0: u384 {
                limb0: 33365344225620418300483762107,
                limb1: 61669251328028818598214401415,
                limb2: 734382232151272636,
                limb3: 0
            },
            w1: u384 {
                limb0: 3697961715062195101967506413,
                limb1: 21208906385886138405320451794,
                limb2: 366917525897845849,
                limb3: 0
            },
            w2: u384 {
                limb0: 51384015934023935640218475337,
                limb1: 61287679020071410716488263415,
                limb2: 1229786024660873765,
                limb3: 0
            },
            w3: u384 {
                limb0: 20075911297692410695836682242,
                limb1: 75320735976135140363410755867,
                limb2: 2415528789495178864,
                limb3: 0
            },
            w4: u384 {
                limb0: 13544265944979405951229043199,
                limb1: 69058729971310762189577984920,
                limb2: 2814089903651004249,
                limb3: 0
            },
            w5: u384 {
                limb0: 32325984775637033452329663866,
                limb1: 54966759658533286051101803750,
                limb2: 196602272621928906,
                limb3: 0
            },
            w6: u384 {
                limb0: 2380341882351557165844524472,
                limb1: 12572265171621387226593626884,
                limb2: 793134402033118394,
                limb3: 0
            },
            w7: u384 {
                limb0: 50938918480510485813628996742,
                limb1: 67951499623144928274471750182,
                limb2: 873790222361372928,
                limb3: 0
            },
            w8: u384 {
                limb0: 28814089384047499620563443367,
                limb1: 68883500388481643085983416890,
                limb2: 1051681892290220441,
                limb3: 0
            },
            w9: u384 {
                limb0: 58137963613476351273975217795,
                limb1: 63812476850260035592453914132,
                limb2: 3450400438247453672,
                limb3: 0
            },
            w10: u384 {
                limb0: 50030575269394277072712783575,
                limb1: 30505552541548071380706634862,
                limb2: 2766449105048849461,
                limb3: 0
            },
            w11: u384 {
                limb0: 68819117473531699502032432810,
                limb1: 48696902204805108335293828631,
                limb2: 2279702102002729671,
                limb3: 0
            }
        };

        let R_n_minus_1 = E12D {
            w0: u384 {
                limb0: 31081599290562405746053704439,
                limb1: 53774368270652558711364016654,
                limb2: 1758318411203088138,
                limb3: 0
            },
            w1: u384 {
                limb0: 65544707852764210527666409203,
                limb1: 57098843080913037403190639527,
                limb2: 3453719093945273117,
                limb3: 0
            },
            w2: u384 {
                limb0: 5004721907736741480475458642,
                limb1: 12540106802669398813604111453,
                limb2: 2621892678422792863,
                limb3: 0
            },
            w3: u384 {
                limb0: 13973445976662057785291907245,
                limb1: 41326209541174119695269154586,
                limb2: 2973927465201661556,
                limb3: 0
            },
            w4: u384 {
                limb0: 42662557740841501963406439067,
                limb1: 38860703102907847382416873781,
                limb2: 553248268538025122,
                limb3: 0
            },
            w5: u384 {
                limb0: 24966454190043522741558369444,
                limb1: 57178172095830049764621899738,
                limb2: 1731298625296730532,
                limb3: 0
            },
            w6: u384 {
                limb0: 33424607147745241576594153718,
                limb1: 51984097601846168312677030386,
                limb2: 1875460909735140404,
                limb3: 0
            },
            w7: u384 {
                limb0: 56447912740539441840606134247,
                limb1: 2322705178440946695859182086,
                limb2: 3130071248594892821,
                limb3: 0
            },
            w8: u384 {
                limb0: 75129641846285220828599377172,
                limb1: 43519802011487355017993993763,
                limb2: 2416178625130043797,
                limb3: 0
            },
            w9: u384 {
                limb0: 58952956480976101579132584455,
                limb1: 71293750442196727725220758666,
                limb2: 2666310639925015996,
                limb3: 0
            },
            w10: u384 {
                limb0: 46518098871267527078920936546,
                limb1: 48104610675088002114718810509,
                limb2: 969597673282878098,
                limb3: 0
            },
            w11: u384 {
                limb0: 5283327071257305812768393240,
                limb1: 13097284696814904934284512801,
                limb2: 2796253884674152378,
                limb3: 0
            }
        };

        let c_n_minus_3: u384 = u384 {
            limb0: 61421455605293778540467791599,
            limb1: 73077698493797017249069924062,
            limb2: 1216575404618065704,
            limb3: 0
        };

        let w_of_z: u384 = u384 {
            limb0: 42395421483881524831781561112,
            limb1: 47153797802041227143409572710,
            limb2: 1414485597461953171,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 39923695507235711151696979108,
            limb1: 5058746645318451340765082729,
            limb2: 1567813266352340119,
            limb3: 0
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 2137382159614158857332258116,
            limb1: 6177677041600800985613646594,
            limb2: 2414416421961072073,
            limb3: 0
        };

        let c_frob_2_of_z: u384 = u384 {
            limb0: 49824485057935950079272697937,
            limb1: 10725992906473255777847575680,
            limb2: 1191151569273001162,
            limb3: 0
        };

        let c_inv_frob_3_of_z: u384 = u384 {
            limb0: 26132179255741140992801178489,
            limb1: 7976585730141206524078235383,
            limb2: 3122829839809020727,
            limb3: 0
        };

        let previous_lhs: u384 = u384 {
            limb0: 52082085019880137836913796196,
            limb1: 45961779402901139126530077491,
            limb2: 832377664399722071,
            limb3: 0
        };

        let R_n_minus_3_of_z: u384 = u384 {
            limb0: 52064657877169960843575624052,
            limb1: 32084046972305912667870267667,
            limb2: 2918592749392623273,
            limb3: 0
        };

        let Q: Array<u384> = array![
            u384 {
                limb0: 33098453676365747490883198523,
                limb1: 74763943203978409231560968702,
                limb2: 1991968510707665874,
                limb3: 0
            },
            u384 {
                limb0: 70264840325132753303945097506,
                limb1: 34005823488055627573001192138,
                limb2: 948563201749786503,
                limb3: 0
            },
            u384 {
                limb0: 25499615653711756568023315718,
                limb1: 63374542395824340316329455095,
                limb2: 2074674098863484664,
                limb3: 0
            },
            u384 {
                limb0: 12856310011781670507331819985,
                limb1: 10105734038880010053631278946,
                limb2: 1567321693476873492,
                limb3: 0
            },
            u384 {
                limb0: 39393884284946784862117142688,
                limb1: 42520573848558986352652412459,
                limb2: 2787962037124535989,
                limb3: 0
            },
            u384 {
                limb0: 25198495269523818673495256643,
                limb1: 52364853919815118454552785257,
                limb2: 752514048694466495,
                limb3: 0
            },
            u384 {
                limb0: 28225998430298122039481213553,
                limb1: 79143269043222570900785552167,
                limb2: 518591200976679001,
                limb3: 0
            },
            u384 {
                limb0: 14991744263681027761081879184,
                limb1: 23960595073737576734779894404,
                limb2: 860322354892426246,
                limb3: 0
            },
            u384 {
                limb0: 44191623917446460999141233624,
                limb1: 75947025286564563898487697848,
                limb2: 365979846567855292,
                limb3: 0
            },
            u384 {
                limb0: 70939278690203749051504463392,
                limb1: 55867915408313319460531701208,
                limb2: 235137975167722501,
                limb3: 0
            },
            u384 {
                limb0: 7071157160023900497565742312,
                limb1: 38396955480951895579875419505,
                limb2: 649383003415786466,
                limb3: 0
            },
            u384 {
                limb0: 4571884385224650727515125818,
                limb1: 11978795682070529378480963089,
                limb2: 552185552616912804,
                limb3: 0
            },
            u384 {
                limb0: 48132109796873595115563520034,
                limb1: 22287813431033615285812669976,
                limb2: 2659614505049479053,
                limb3: 0
            },
            u384 {
                limb0: 71471679428953770605312785913,
                limb1: 35859283367319609553879740981,
                limb2: 1230535088536672785,
                limb3: 0
            },
            u384 {
                limb0: 49650008820171436099699858166,
                limb1: 64057164701783933632965075072,
                limb2: 1203157986455302004,
                limb3: 0
            },
            u384 {
                limb0: 14039413519172135499580004740,
                limb1: 65364328906271703786284465914,
                limb2: 395094512821687712,
                limb3: 0
            },
            u384 {
                limb0: 41208239631472574275803659016,
                limb1: 60713821728584809477448130419,
                limb2: 3116280163861165615,
                limb3: 0
            },
            u384 {
                limb0: 68854579066170353488405534183,
                limb1: 66136692226681327451189880080,
                limb2: 1531143231389980764,
                limb3: 0
            },
            u384 {
                limb0: 27661903936280391625256413308,
                limb1: 17919858125214860153903656513,
                limb2: 1066024845502665955,
                limb3: 0
            },
            u384 {
                limb0: 72557895196031617462042601825,
                limb1: 34401467950663197490006731574,
                limb2: 1663523074202070935,
                limb3: 0
            },
            u384 {
                limb0: 9592904154259912499028161677,
                limb1: 15792655389563450083777066654,
                limb2: 2845117716642339018,
                limb3: 0
            },
            u384 {
                limb0: 15505763585487123748696970039,
                limb1: 56183104384789528883520052319,
                limb2: 507966090619345079,
                limb3: 0
            },
            u384 {
                limb0: 48540240876461674821799432186,
                limb1: 58416267517466254748215921669,
                limb2: 1733014745510915274,
                limb3: 0
            },
            u384 {
                limb0: 58503170339620450020486765201,
                limb1: 11076514713664381324942221760,
                limb2: 387600839756981473,
                limb3: 0
            },
            u384 {
                limb0: 1483718809849803193492351804,
                limb1: 60610549812973151166531956730,
                limb2: 504471679620498600,
                limb3: 0
            },
            u384 {
                limb0: 71891649421561027159645091733,
                limb1: 15353940008428061854178489411,
                limb2: 289202304770619624,
                limb3: 0
            },
            u384 {
                limb0: 30329619063319524090989957621,
                limb1: 75387524492422383148103950704,
                limb2: 2857412130506332030,
                limb3: 0
            },
            u384 {
                limb0: 29168583205465213865341200551,
                limb1: 16622214791416542588135470921,
                limb2: 3319132663400567679,
                limb3: 0
            },
            u384 {
                limb0: 58378913562611383325969187305,
                limb1: 582539555267025502297423118,
                limb2: 2056459920274719024,
                limb3: 0
            },
            u384 {
                limb0: 32872092350185671146173069122,
                limb1: 15938097353093017951313432895,
                limb2: 2669740590450321665,
                limb3: 0
            },
            u384 {
                limb0: 73776571042293996350109984795,
                limb1: 62413036917924960884447470015,
                limb2: 3460593544182374593,
                limb3: 0
            },
            u384 {
                limb0: 23361067576166653602372473682,
                limb1: 35843180712915041501661832286,
                limb2: 2414945376254411259,
                limb3: 0
            },
            u384 {
                limb0: 26120867277824856781212435665,
                limb1: 40912356838057865155781880721,
                limb2: 1403619668534413144,
                limb3: 0
            },
            u384 {
                limb0: 70900157102264995645572108708,
                limb1: 73575650363007250142586137307,
                limb2: 65819251522193827,
                limb3: 0
            },
            u384 {
                limb0: 72035211456707060637348161188,
                limb1: 59637134946068362386888022230,
                limb2: 1859279476726996024,
                limb3: 0
            },
            u384 {
                limb0: 58609607974785998416086748314,
                limb1: 73566965222249235167023895570,
                limb2: 3147173350179488588,
                limb3: 0
            },
            u384 {
                limb0: 66626973643163376888792700865,
                limb1: 46526854053090122036200156613,
                limb2: 852964771896585259,
                limb3: 0
            },
            u384 {
                limb0: 66842366784958160912211408670,
                limb1: 40872477980282261319412457581,
                limb2: 3242052361288001756,
                limb3: 0
            },
            u384 {
                limb0: 10881354300167060298381785025,
                limb1: 16627068648951536597605233783,
                limb2: 1656062941694660587,
                limb3: 0
            },
            u384 {
                limb0: 7590234654420451459084566571,
                limb1: 9952157562117499728840964462,
                limb2: 2644620680819990569,
                limb3: 0
            },
            u384 {
                limb0: 16096415090589360528829998482,
                limb1: 60489930115273232710045511715,
                limb2: 2629087709379009610,
                limb3: 0
            },
            u384 {
                limb0: 71619516899666972334330600490,
                limb1: 56828255654166394851253338827,
                limb2: 820567693032175137,
                limb3: 0
            },
            u384 {
                limb0: 21051734457820536367958262254,
                limb1: 53587959856837662321115358053,
                limb2: 780040434001708961,
                limb3: 0
            },
            u384 {
                limb0: 56291033488551202865240242229,
                limb1: 7926054244315471417199441261,
                limb2: 416633739581103245,
                limb3: 0
            },
            u384 {
                limb0: 4936399701137768251923920381,
                limb1: 34480314701056392336803156937,
                limb2: 1144753455566909653,
                limb3: 0
            },
            u384 {
                limb0: 73379716021258561579181763105,
                limb1: 9816938742507573605200555603,
                limb2: 302121010466233325,
                limb3: 0
            },
            u384 {
                limb0: 39074568292960056585386828282,
                limb1: 30393167788400458144206298458,
                limb2: 3295268156419563705,
                limb3: 0
            },
            u384 {
                limb0: 26269612171689478484347798003,
                limb1: 7114109651598202966265616290,
                limb2: 1273208474229191308,
                limb3: 0
            },
            u384 {
                limb0: 492473233050211345261043369,
                limb1: 49150364358770352847909719780,
                limb2: 736455274677818642,
                limb3: 0
            },
            u384 {
                limb0: 58202004869777588648652138038,
                limb1: 44950811496966308390952012957,
                limb2: 3136491133114680438,
                limb3: 0
            },
            u384 {
                limb0: 66917613310771546496729248145,
                limb1: 5356376551572825484190661093,
                limb2: 1796535414011493168,
                limb3: 0
            },
            u384 {
                limb0: 33369234336273040382455689813,
                limb1: 40558974526243695652945451747,
                limb2: 2088271231111765277,
                limb3: 0
            },
            u384 {
                limb0: 76019082019990929029968393978,
                limb1: 54816149949597252466150129639,
                limb2: 2589956671809110234,
                limb3: 0
            },
            u384 {
                limb0: 46814272418678525942318321643,
                limb1: 6530879513030786066040503384,
                limb2: 1117424772830563374,
                limb3: 0
            },
            u384 {
                limb0: 15170771260443267793434994039,
                limb1: 67904187746730180090139241287,
                limb2: 1520985811054490878,
                limb3: 0
            },
            u384 {
                limb0: 46737589218193894526121794139,
                limb1: 71986698873638342808514302054,
                limb2: 3456626610179519999,
                limb3: 0
            },
            u384 {
                limb0: 69409836222646707398820108051,
                limb1: 59022569405147229523907440907,
                limb2: 68482585554592942,
                limb3: 0
            },
            u384 {
                limb0: 26695655322179603618291845079,
                limb1: 76917391401191878662123757513,
                limb2: 1608968895518897921,
                limb3: 0
            },
            u384 {
                limb0: 12893525830122082867153185852,
                limb1: 56768381577237312932475564348,
                limb2: 920972226490358255,
                limb3: 0
            },
            u384 {
                limb0: 75025207275620829990510333447,
                limb1: 58313671667075772423164406815,
                limb2: 711807388310795372,
                limb3: 0
            },
            u384 {
                limb0: 20255972357890678421192884560,
                limb1: 49348914342531064816213329120,
                limb2: 773352867139739535,
                limb3: 0
            },
            u384 {
                limb0: 2194058053454429916486834940,
                limb1: 71812774844895265783839723864,
                limb2: 358125547888911027,
                limb3: 0
            },
            u384 {
                limb0: 73413941480347284105225949803,
                limb1: 6205422991185054515946365338,
                limb2: 3120260064035593970,
                limb3: 0
            },
            u384 {
                limb0: 42441932706618475243521916445,
                limb1: 25671073080874809859330074798,
                limb2: 2087710479660976460,
                limb3: 0
            },
            u384 {
                limb0: 56748904892994449934868868392,
                limb1: 7774839259506789294003448071,
                limb2: 781892099406697849,
                limb3: 0
            },
            u384 {
                limb0: 12644533561941669219936325915,
                limb1: 46613120407474176325529627066,
                limb2: 222974784562705674,
                limb3: 0
            },
            u384 {
                limb0: 34694094638222269963586017595,
                limb1: 16939308139459537032241626028,
                limb2: 280751646393240068,
                limb3: 0
            },
            u384 {
                limb0: 1333188549282914880374741420,
                limb1: 47079377293590476067840720457,
                limb2: 790156009110224317,
                limb3: 0
            },
            u384 {
                limb0: 52175183568772763490000121059,
                limb1: 23047689337436513466069535762,
                limb2: 3415571932864289189,
                limb3: 0
            },
            u384 {
                limb0: 70015005085254370314246699217,
                limb1: 26494368302687429926495834425,
                limb2: 1428709659670439107,
                limb3: 0
            },
            u384 {
                limb0: 62747847640787306790828392488,
                limb1: 24068919168269152791436930602,
                limb2: 2646767785121561666,
                limb3: 0
            },
            u384 {
                limb0: 7958273572385298703298176774,
                limb1: 11812174533761093239493266579,
                limb2: 176874172170093298,
                limb3: 0
            },
            u384 {
                limb0: 66337500537752861909738581511,
                limb1: 72026738567509765955406550850,
                limb2: 1846877528962976960,
                limb3: 0
            },
            u384 {
                limb0: 18496499506790590409693946512,
                limb1: 45181751735761230294864373952,
                limb2: 1355379848256411815,
                limb3: 0
            },
            u384 {
                limb0: 13904914528554853430755045480,
                limb1: 35993892192629410553162588021,
                limb2: 311509114091310377,
                limb3: 0
            },
            u384 {
                limb0: 1084770889946852826369761737,
                limb1: 63192736170052845945994416284,
                limb2: 587361809187782360,
                limb3: 0
            },
            u384 {
                limb0: 47358754530036506974626348527,
                limb1: 17420813842662412411190743811,
                limb2: 2527191444463150977,
                limb3: 0
            },
            u384 {
                limb0: 68597862657013464652950399005,
                limb1: 32117393869505200237546301089,
                limb2: 1305030197262475563,
                limb3: 0
            },
            u384 {
                limb0: 30129814019794090780542442261,
                limb1: 25261663616316805304148533262,
                limb2: 1936752214199332977,
                limb3: 0
            },
            u384 {
                limb0: 73138571491914259165480973382,
                limb1: 28226784738932386438719605508,
                limb2: 1134757918672538593,
                limb3: 0
            },
            u384 {
                limb0: 32895473358887575467488671871,
                limb1: 77184193164284463972954995388,
                limb2: 219947446893582123,
                limb3: 0
            },
            u384 {
                limb0: 15843886880602801959298162698,
                limb1: 57673213479924555044024380703,
                limb2: 2619011327781063536,
                limb3: 0
            },
            u384 {
                limb0: 2826844588607557945320518998,
                limb1: 23266316100949241291477426588,
                limb2: 1492079359939426017,
                limb3: 0
            },
            u384 {
                limb0: 24144830363737358644792504257,
                limb1: 14300553694089717622288892016,
                limb2: 3323035621232853433,
                limb3: 0
            },
            u384 {
                limb0: 4378531482399933778750541767,
                limb1: 63200127509952811882174455781,
                limb2: 509643730504872493,
                limb3: 0
            },
            u384 {
                limb0: 77226793135296405274973952696,
                limb1: 72721564555067937920389999070,
                limb2: 748509374722909619,
                limb3: 0
            },
            u384 {
                limb0: 62224918857097980084091431124,
                limb1: 60350165761243502348988534230,
                limb2: 593695233659384584,
                limb3: 0
            },
            u384 {
                limb0: 35063350929731661780991763163,
                limb1: 54567615536898176162633024879,
                limb2: 1672406740380116684,
                limb3: 0
            },
            u384 {
                limb0: 50969571011128885021209892000,
                limb1: 18041757088212884210135391732,
                limb2: 2365858834435557843,
                limb3: 0
            },
            u384 {
                limb0: 17766632532718197231957223993,
                limb1: 6198916461465394932111853515,
                limb2: 512077257826665186,
                limb3: 0
            },
            u384 {
                limb0: 13090121969649548004387826966,
                limb1: 25284791947721348729320976057,
                limb2: 605068774036558580,
                limb3: 0
            },
            u384 {
                limb0: 50519261618615618543978402050,
                limb1: 49047818368281578060437493889,
                limb2: 828727407876272582,
                limb3: 0
            },
            u384 {
                limb0: 20315134360807323810314759860,
                limb1: 62479143405531877906885712206,
                limb2: 635091627312841847,
                limb3: 0
            },
            u384 {
                limb0: 17126471078483079465116342332,
                limb1: 52850041923026176862924436062,
                limb2: 1245407056659555592,
                limb3: 0
            },
            u384 {
                limb0: 68251459521332482444142448456,
                limb1: 4751377599323751518706361050,
                limb2: 1149117549789550708,
                limb3: 0
            },
            u384 {
                limb0: 29401798870005237497718756560,
                limb1: 4605772053037763984032690187,
                limb2: 1221463826808108395,
                limb3: 0
            },
            u384 {
                limb0: 28456558384702540042131095923,
                limb1: 72625435847803519721099232190,
                limb2: 1072681359382536959,
                limb3: 0
            },
            u384 {
                limb0: 65821197384235905943213050848,
                limb1: 54275309473747675372901803466,
                limb2: 561145931343481025,
                limb3: 0
            },
            u384 {
                limb0: 19920926066920816168894813598,
                limb1: 76868641917881756188303966969,
                limb2: 1597209921019777085,
                limb3: 0
            },
            u384 {
                limb0: 2128393787040049200935408124,
                limb1: 53007392301125422591614816033,
                limb2: 2465651256357684313,
                limb3: 0
            },
            u384 {
                limb0: 8677110849290570775212355429,
                limb1: 56188653114790687454072550987,
                limb2: 2357420881492594086,
                limb3: 0
            },
            u384 {
                limb0: 43801459855603541334920837160,
                limb1: 11678481435397277707132278210,
                limb2: 562207799382722293,
                limb3: 0
            },
            u384 {
                limb0: 67100426729320024015634454668,
                limb1: 60118782242760137111458299728,
                limb2: 802292122562664620,
                limb3: 0
            },
            u384 {
                limb0: 54646648803313860424918320388,
                limb1: 37839431060632968400129517968,
                limb2: 888846796766107462,
                limb3: 0
            },
            u384 {
                limb0: 78159030323254019922819392003,
                limb1: 64738762059813179385672171028,
                limb2: 1619811141303440350,
                limb3: 0
            },
            u384 {
                limb0: 65088033742453462468282551003,
                limb1: 38355839474936544120376969237,
                limb2: 1306987857635046051,
                limb3: 0
            },
            u384 {
                limb0: 54664880196968822387562645410,
                limb1: 36729096557735508592533655035,
                limb2: 818626026206403136,
                limb3: 0
            },
            u384 {
                limb0: 8945350988389862978016625300,
                limb1: 18322655213221756841613063153,
                limb2: 2885862946334341319,
                limb3: 0
            },
            u384 {
                limb0: 74622691986524647788276621585,
                limb1: 46227625908579828027906561182,
                limb2: 1361850403308785014,
                limb3: 0
            },
            u384 {
                limb0: 41497197856656679879376904834,
                limb1: 70285976968530249515488686749,
                limb2: 1131703209855094149,
                limb3: 0
            },
            u384 {
                limb0: 51639818046774408736793294340,
                limb1: 9243302101139550232517777698,
                limb2: 2791239577988855012,
                limb3: 0
            },
            u384 {
                limb0: 47392731893197725839250875588,
                limb1: 14808023378882227632786471322,
                limb2: 1575616195594304793,
                limb3: 0
            },
            u384 {
                limb0: 52156570416734050353366898277,
                limb1: 26521347448065291731841190310,
                limb2: 474332804379480464,
                limb3: 0
            },
            u384 {
                limb0: 48045611702541141489692235266,
                limb1: 8096408739740746069940360496,
                limb2: 3435782902889499140,
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
            limb0: 21419397651617267190532678016,
            limb1: 49295512502152960215269673856,
            limb2: 1120396725709419598,
            limb3: 0
        };
        assert_eq!(final_check_result, final_check);
    }


    #[test]
    fn test_run_BN254_MP_CHECK_INIT_BIT_2_circuit_BN254() {
        let yInv_0: u384 = u384 {
            limb0: 17030965861427932603395216174,
            limb1: 50610309651479195606595987739,
            limb2: 2012868695337571861,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 53156576797398779118094908135,
            limb1: 46353555011178918111430084642,
            limb2: 3215650700852479072,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 3633961746356539824412552602,
                limb1: 4146818672222668174416822593,
                limb2: 1095833601339059182,
                limb3: 0
            },
            x1: u384 {
                limb0: 4473165902245014478978778034,
                limb1: 28505135188464360372758150574,
                limb2: 1150639149349685171,
                limb3: 0
            },
            y0: u384 {
                limb0: 11328067515331184302882014536,
                limb1: 45700928008523308453434162827,
                limb2: 855462793404971462,
                limb3: 0
            },
            y1: u384 {
                limb0: 28434051194464176119399835482,
                limb1: 58715449550382914019805476085,
                limb2: 236187122926389447,
                limb3: 0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 60887268623050470302017321607,
            limb1: 39674118761463042783358575680,
            limb2: 2826317993206975260,
            limb3: 0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 40426128386736489775459074259,
            limb1: 11876800051257337261840370166,
            limb2: 904539466664089310,
            limb3: 0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 21740577246771359875946060785,
                limb1: 8314883832496565482936171179,
                limb2: 5890774264790464,
                limb3: 0
            },
            x1: u384 {
                limb0: 60205826440755822723549502787,
                limb1: 59473802522471127718425889015,
                limb2: 1159670957879617527,
                limb3: 0
            },
            y0: u384 {
                limb0: 30403806542511353387490138601,
                limb1: 41187350871534977247900525332,
                limb2: 823651785410945671,
                limb3: 0
            },
            y1: u384 {
                limb0: 66048527049895429267039671320,
                limb1: 47810630735778204849899603498,
                limb2: 18694836031353677,
                limb3: 0
            }
        };

        let R_i = E12D {
            w0: u384 {
                limb0: 40752697390388119035665776685,
                limb1: 11112962707473480058991766119,
                limb2: 2754856009251363083,
                limb3: 0
            },
            w1: u384 {
                limb0: 37701193218643795012106197979,
                limb1: 20518050444260407527409517567,
                limb2: 1391120633222715060,
                limb3: 0
            },
            w2: u384 {
                limb0: 51540450938244412325080206422,
                limb1: 62547279651341779702117789844,
                limb2: 896162233866851509,
                limb3: 0
            },
            w3: u384 {
                limb0: 36351273042359421665518951009,
                limb1: 1448178449759044487788488905,
                limb2: 2754051159840098759,
                limb3: 0
            },
            w4: u384 {
                limb0: 28552257520623663022396423630,
                limb1: 21207341065849910545468194397,
                limb2: 3110580203891361289,
                limb3: 0
            },
            w5: u384 {
                limb0: 1306489111607322672789488725,
                limb1: 72610531697863705015207158230,
                limb2: 772356383620131897,
                limb3: 0
            },
            w6: u384 {
                limb0: 28781848225990331404683268137,
                limb1: 6957143952038344788196827074,
                limb2: 1991954342021882325,
                limb3: 0
            },
            w7: u384 {
                limb0: 55419396868170503288878635921,
                limb1: 13642347608890548228178900069,
                limb2: 2738763875781929386,
                limb3: 0
            },
            w8: u384 {
                limb0: 27950792771406312151346646753,
                limb1: 68976406838155591938931538988,
                limb2: 1770666083514905078,
                limb3: 0
            },
            w9: u384 {
                limb0: 14615612206400765347540108072,
                limb1: 39321458825195509075292327571,
                limb2: 697039904675784822,
                limb3: 0
            },
            w10: u384 {
                limb0: 71775527903744597711262335923,
                limb1: 34554122535282079308077868458,
                limb2: 2787674958551898093,
                limb3: 0
            },
            w11: u384 {
                limb0: 51311560707716095739496405146,
                limb1: 10739191613981306907532700259,
                limb2: 392999336627237238,
                limb3: 0
            }
        };

        let c0: u384 = u384 {
            limb0: 56602895881581335582663967345,
            limb1: 76971549978976164606346265368,
            limb2: 1457858668478295009,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 52054654779208637269686603470,
            limb1: 38508569974338392631231184470,
            limb2: 2219369752485307863,
            limb3: 0
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 26191649065926652268141442049,
            limb1: 51178397079496831350855620600,
            limb2: 2115188032594331722,
            limb3: 0
        };

        let previous_lhs: u384 = u384 {
            limb0: 12643151824413271624945304507,
            limb1: 40598893563591335499031517451,
            limb2: 2577592140968896664,
            limb3: 0
        };

        let (Q0_result, Q1_result, new_lhs_result, c_i_result, f_i_plus_one_of_z_result) =
            run_BN254_MP_CHECK_INIT_BIT_2_circuit(
            yInv_0, xNegOverY_0, Q0, yInv_1, xNegOverY_1, Q1, R_i, c0, z, c_inv_of_z, previous_lhs
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 42350886594681395306642343784,
                limb1: 18631384492966926147103237654,
                limb2: 1455642368045478834,
                limb3: 0
            },
            x1: u384 {
                limb0: 37566907967779971858503056836,
                limb1: 73965519081078084124894205808,
                limb2: 1296066636139095140,
                limb3: 0
            },
            y0: u384 {
                limb0: 48485483971935001679231398504,
                limb1: 19580075275590959485217208561,
                limb2: 1581112686713235188,
                limb3: 0
            },
            y1: u384 {
                limb0: 64520463672925927189318555311,
                limb1: 260438692236368704413011154,
                limb2: 74039703212856139,
                limb3: 0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 56583037400142823617423952558,
                limb1: 52299928476385759192786727296,
                limb2: 315855649535580588,
                limb3: 0
            },
            x1: u384 {
                limb0: 56302686199871561718436174295,
                limb1: 51603237692553503571559316847,
                limb2: 324505641467870856,
                limb3: 0
            },
            y0: u384 {
                limb0: 65569767974827784596974582152,
                limb1: 7468457124463169246931638907,
                limb2: 1243477262023240937,
                limb3: 0
            },
            y1: u384 {
                limb0: 52293660324299029298384918024,
                limb1: 41274980024072094169759913340,
                limb2: 137973748757400752,
                limb3: 0
            }
        };

        let new_lhs: u384 = u384 {
            limb0: 13604727656313614440016370925,
            limb1: 721556599909767944194950472,
            limb2: 71654152407530714,
            limb3: 0
        };

        let c_i: u384 = u384 {
            limb0: 64597578752673693881543159840,
            limb1: 37984446025811203756748416940,
            limb2: 1890841130496403307,
            limb3: 0
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 66849426995957667428172511245,
            limb1: 71293511479556194779179912791,
            limb2: 2374264684681398603,
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
            limb0: 16418866567404017162536561034,
            limb1: 79033158699919409584932469691,
            limb2: 2808970423086673936,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 58988866291078242850488663558,
            limb1: 46600016896233649373725606503,
            limb2: 92576086477615172,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 63243585123905974800789293695,
                limb1: 16151279046883002475478801117,
                limb2: 2337338139336417614,
                limb3: 0
            },
            x1: u384 {
                limb0: 12947301268589930603713357661,
                limb1: 59620958271215811126132385745,
                limb2: 1414504377978103229,
                limb3: 0
            },
            y0: u384 {
                limb0: 25256495907764531595862299957,
                limb1: 15912614921611637151089554528,
                limb2: 278950671084916358,
                limb3: 0
            },
            y1: u384 {
                limb0: 41422001481895117739146096057,
                limb1: 34103725224509175506282582890,
                limb2: 2520032456734868878,
                limb3: 0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 31729146049315672192365054515,
            limb1: 69250547997021890420543678020,
            limb2: 298753017590468020,
            limb3: 0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 17453182787496997619711397277,
            limb1: 52723430604123121541376501559,
            limb2: 3132366781350607908,
            limb3: 0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 12266091185749629122854948969,
                limb1: 952110679273398617457268935,
                limb2: 1753312521996085639,
                limb3: 0
            },
            x1: u384 {
                limb0: 49929116280386662677697330109,
                limb1: 25253717824410152953852318002,
                limb2: 2824942357092314563,
                limb3: 0
            },
            y0: u384 {
                limb0: 35887760361220100729288122640,
                limb1: 43764380930503421575595558331,
                limb2: 1092545158635851661,
                limb3: 0
            },
            y1: u384 {
                limb0: 59350774973676618702433028060,
                limb1: 9715314178277032003792974049,
                limb2: 1923994920168306020,
                limb3: 0
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 74824639101665518983554228897,
            limb1: 53329540668995404032152929281,
            limb2: 1173603778550904789,
            limb3: 0
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 30979792805752274803773888920,
            limb1: 63750930089908581422709830063,
            limb2: 44425451126878403,
            limb3: 0
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 16683061314319941424836538414,
                limb1: 3691737183364870482817978717,
                limb2: 126839962624216432,
                limb3: 0
            },
            x1: u384 {
                limb0: 29856885734619565628057352520,
                limb1: 46737597545210953960964963104,
                limb2: 661492027834073920,
                limb3: 0
            },
            y0: u384 {
                limb0: 7573077116390604357729986801,
                limb1: 59942730227629455301457843480,
                limb2: 184353320766151369,
                limb3: 0
            },
            y1: u384 {
                limb0: 26063518883796622866272269140,
                limb1: 72031303545989917000612359373,
                limb2: 1951648388651127698,
                limb3: 0
            }
        };

        let R_i = E12D {
            w0: u384 {
                limb0: 77461609861143541299237058944,
                limb1: 2142947650060670887597219977,
                limb2: 2914208085607429540,
                limb3: 0
            },
            w1: u384 {
                limb0: 6740555394807156857764728744,
                limb1: 51015226100351963069986993616,
                limb2: 3456480448405230739,
                limb3: 0
            },
            w2: u384 {
                limb0: 47464196112954551825536745080,
                limb1: 10496658885951485180021716428,
                limb2: 3371800911770665239,
                limb3: 0
            },
            w3: u384 {
                limb0: 4339999891477638360047867335,
                limb1: 35311033650643641856455435382,
                limb2: 2501377558119777601,
                limb3: 0
            },
            w4: u384 {
                limb0: 74587729044872893159576258424,
                limb1: 51042064023610099024529763461,
                limb2: 2714220543696079110,
                limb3: 0
            },
            w5: u384 {
                limb0: 65821423212764509398120707494,
                limb1: 37205773641880746675182188260,
                limb2: 1235339939683356309,
                limb3: 0
            },
            w6: u384 {
                limb0: 61310882930700014088094901063,
                limb1: 69420016221568265953358518901,
                limb2: 2949076321031948284,
                limb3: 0
            },
            w7: u384 {
                limb0: 61218971062315893066299295758,
                limb1: 60348615836708746137793640129,
                limb2: 620652557754079240,
                limb3: 0
            },
            w8: u384 {
                limb0: 11516664929868624248881616905,
                limb1: 59505181108120106257510842052,
                limb2: 397234752312367477,
                limb3: 0
            },
            w9: u384 {
                limb0: 20113553687270141460253378515,
                limb1: 54057024911024917150202128074,
                limb2: 2169896756529391339,
                limb3: 0
            },
            w10: u384 {
                limb0: 51045598493867986602332366817,
                limb1: 69283926801557474195943517096,
                limb2: 1445261260419351979,
                limb3: 0
            },
            w11: u384 {
                limb0: 5582971433925081757616423849,
                limb1: 2729142422150463344892904419,
                limb2: 2972399257775041017,
                limb3: 0
            }
        };

        let c0: u384 = u384 {
            limb0: 52627880362488810314465893949,
            limb1: 21202400339955532776927652839,
            limb2: 1395993918431486868,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 52734019973134373870986065918,
            limb1: 37788783526058627853666103848,
            limb2: 2727696476870389920,
            limb3: 0
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 58940367422329565759856843451,
            limb1: 49306726747782465586006575591,
            limb2: 2363078759017140520,
            limb3: 0
        };

        let previous_lhs: u384 = u384 {
            limb0: 27116938255086176221444789661,
            limb1: 546281316600448382683657850,
            limb2: 2648786536735237497,
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
                limb0: 1061098195121223910155713136,
                limb1: 7904482775892702196984576249,
                limb2: 1263860925229970706,
                limb3: 0
            },
            x1: u384 {
                limb0: 51779268798924991139269975868,
                limb1: 2601249143081479095897158716,
                limb2: 703160124128933833,
                limb3: 0
            },
            y0: u384 {
                limb0: 29368074267590364313774861906,
                limb1: 59941908790678595068557127050,
                limb2: 1604735345792898985,
                limb3: 0
            },
            y1: u384 {
                limb0: 20799741481609015845103577206,
                limb1: 20283882066180010247685220373,
                limb2: 2928366143485824249,
                limb3: 0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 63715675923229325928180594225,
                limb1: 64765354855180307719125928530,
                limb2: 1239895060750142123,
                limb3: 0
            },
            x1: u384 {
                limb0: 702315058073449266113713398,
                limb1: 5561504340525237609110932606,
                limb2: 1070135004068978431,
                limb3: 0
            },
            y0: u384 {
                limb0: 59855539343301688970430000589,
                limb1: 40941220998910898733615960030,
                limb2: 2292235789353021817,
                limb3: 0
            },
            y1: u384 {
                limb0: 50351232349137263868163656886,
                limb1: 5362113889054407764301425143,
                limb2: 588353545548173957,
                limb3: 0
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 24087520494527419843372737202,
                limb1: 4884756656245906139047660609,
                limb2: 178577365649162540,
                limb3: 0
            },
            x1: u384 {
                limb0: 33194336131821171463892812534,
                limb1: 35785896589306622779946173812,
                limb2: 1381449500099107238,
                limb3: 0
            },
            y0: u384 {
                limb0: 76862520697972568925202579751,
                limb1: 54583064870989774345250205716,
                limb2: 1328819069812021666,
                limb3: 0
            },
            y1: u384 {
                limb0: 48431458097335398479703033633,
                limb1: 71085573369178257103430196124,
                limb2: 2801734059811825236,
                limb3: 0
            }
        };

        let new_lhs: u384 = u384 {
            limb0: 56476775849966192061641660105,
            limb1: 78681294101378149915873154259,
            limb2: 2581020433303885754,
            limb3: 0
        };

        let c_i: u384 = u384 {
            limb0: 6747450935857074937693167737,
            limb1: 17490014918491047341546712170,
            limb2: 609717469466363572,
            limb3: 0
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 30006257211706760208276075392,
            limb1: 20285943430321500530217537735,
            limb2: 3071459204997130812,
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
        let lambda_root = E12D {
            w0: u384 {
                limb0: 78876029687611291161836619617,
                limb1: 52556973173410171301394146325,
                limb2: 1061396992610873468,
                limb3: 0
            },
            w1: u384 {
                limb0: 48232599021772632667808268598,
                limb1: 34779922187815069867601112082,
                limb2: 728469249952172468,
                limb3: 0
            },
            w2: u384 {
                limb0: 77075779384248039252423124484,
                limb1: 77155539649215278280190693461,
                limb2: 2523872089077292852,
                limb3: 0
            },
            w3: u384 {
                limb0: 17118679868965121397560864364,
                limb1: 24856663213266800450142344187,
                limb2: 592437291839847632,
                limb3: 0
            },
            w4: u384 {
                limb0: 52643501940580234278115061932,
                limb1: 36173156987756276738169180,
                limb2: 3045036490717526041,
                limb3: 0
            },
            w5: u384 {
                limb0: 24430854188235605795646978746,
                limb1: 61959490654890542406562369930,
                limb2: 1490811263083364915,
                limb3: 0
            },
            w6: u384 {
                limb0: 48464887891924887920183142319,
                limb1: 63647833454946064423924359354,
                limb2: 767765390797981516,
                limb3: 0
            },
            w7: u384 {
                limb0: 32849413149699568885642529056,
                limb1: 65876951073525875808285154060,
                limb2: 565891492380393342,
                limb3: 0
            },
            w8: u384 {
                limb0: 77598259980424677085607578149,
                limb1: 25680272431206916503934104472,
                limb2: 1367673525171918109,
                limb3: 0
            },
            w9: u384 {
                limb0: 34619243684524445982078061441,
                limb1: 22717274452153856440117958812,
                limb2: 105631989180545225,
                limb3: 0
            },
            w10: u384 {
                limb0: 25109328460256562969970016727,
                limb1: 51774954741392963969030491078,
                limb2: 1325557186699415564,
                limb3: 0
            },
            w11: u384 {
                limb0: 56130143694652296098205801033,
                limb1: 70379995828691691700214706354,
                limb2: 2382420479483555150,
                limb3: 0
            }
        };

        let z: u384 = u384 {
            limb0: 47311066207882218405560336162,
            limb1: 30789179050612363042368504908,
            limb2: 1295312153442064915,
            limb3: 0
        };

        let scaling_factor: MillerLoopResultScalingFactor = MillerLoopResultScalingFactor {
            w0: u384 {
                limb0: 20081800292463345456551429400,
                limb1: 72139378624331867418033380322,
                limb2: 2457082555073983468,
                limb3: 0
            },
            w2: u384 {
                limb0: 35558528876036842478088732671,
                limb1: 33565357648224252815203168801,
                limb2: 781845608970146601,
                limb3: 0
            },
            w4: u384 {
                limb0: 18302682824859394250099259830,
                limb1: 37817175889035485831047545154,
                limb2: 141151215612999086,
                limb3: 0
            },
            w6: u384 {
                limb0: 24425844140222924336248236752,
                limb1: 14468513654171819090067465788,
                limb2: 593432066053763710,
                limb3: 0
            },
            w8: u384 {
                limb0: 1203799016341512417965380726,
                limb1: 28694363048321436275835764055,
                limb2: 1908798161406009129,
                limb3: 0
            },
            w10: u384 {
                limb0: 19532402468811548792549747542,
                limb1: 21276812047655471859824398365,
                limb2: 1989963035505770167,
                limb3: 0
            }
        };

        let c_inv = E12D {
            w0: u384 {
                limb0: 11511693070273995284882377693,
                limb1: 77875361638018122631716278388,
                limb2: 2509538534450933386,
                limb3: 0
            },
            w1: u384 {
                limb0: 74760932869453648057179532930,
                limb1: 60075446736607414489312587559,
                limb2: 594078452858641118,
                limb3: 0
            },
            w2: u384 {
                limb0: 46064864601932086963308698062,
                limb1: 59023955925725274619236298042,
                limb2: 2416593706988199217,
                limb3: 0
            },
            w3: u384 {
                limb0: 23719870747466911958995106585,
                limb1: 67779148596325614483389103014,
                limb2: 3269216409187904934,
                limb3: 0
            },
            w4: u384 {
                limb0: 57198158640702977667010573729,
                limb1: 71687878799965043967393536784,
                limb2: 921345792293189065,
                limb3: 0
            },
            w5: u384 {
                limb0: 13295263885328123897987940133,
                limb1: 30732878069893442254500677475,
                limb2: 1774612657201329829,
                limb3: 0
            },
            w6: u384 {
                limb0: 39073930735080714804698085885,
                limb1: 67803843054481874289422274317,
                limb2: 2457147552005459142,
                limb3: 0
            },
            w7: u384 {
                limb0: 65366096302421835663172939132,
                limb1: 835650531448226490533056190,
                limb2: 3444362320080872757,
                limb3: 0
            },
            w8: u384 {
                limb0: 27356951067035585084921379676,
                limb1: 20461005198938112919197330420,
                limb2: 353417296945346432,
                limb3: 0
            },
            w9: u384 {
                limb0: 67676742380086990432758385534,
                limb1: 64104115241619972125628345637,
                limb2: 3196463074566025458,
                limb3: 0
            },
            w10: u384 {
                limb0: 35701064642071881562327992565,
                limb1: 71067092790380178675270923920,
                limb2: 3050644578457284978,
                limb3: 0
            },
            w11: u384 {
                limb0: 49666202815800374209268276944,
                limb1: 22909189928344113849700488112,
                limb2: 2759474543087333987,
                limb3: 0
            }
        };

        let c_0: u384 = u384 {
            limb0: 52833175583578586446520517603,
            limb1: 65735074376355193258500197024,
            limb2: 1371300422286054923,
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
            limb0: 30013151459389753530221699436,
            limb1: 44343941553497289642026983447,
            limb2: 225559717787311921,
            limb3: 0
        };

        let scaling_factor_of_z: u384 = u384 {
            limb0: 70692458953087519589278036852,
            limb1: 74111040088522959303430521270,
            limb2: 1283531232133042356,
            limb3: 0
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 54825711317583252965903846566,
            limb1: 78370843776569397462450179872,
            limb2: 400119275020129892,
            limb3: 0
        };

        let lhs: u384 = u384 {
            limb0: 29577328121772404596356253115,
            limb1: 34887765347174762508887027065,
            limb2: 600553848739456672,
            limb3: 0
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 77386572131730659974191576608,
            limb1: 70555608932047380599246814201,
            limb2: 1532002914584699177,
            limb3: 0
        };

        let c_frob_2_of_z: u384 = u384 {
            limb0: 14840826878505179997593335866,
            limb1: 73279023753957071697277531708,
            limb2: 2653964306652197694,
            limb3: 0
        };

        let c_inv_frob_3_of_z: u384 = u384 {
            limb0: 56706544226071247899970854720,
            limb1: 28410471288025503954875966235,
            limb2: 2027401765612281414,
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
                limb0: 42660742050171352484751842008,
                limb1: 3493156307941593312069152128,
                limb2: 1733484721164986777,
                limb3: 0
            },
            y: u384 {
                limb0: 63940033736712737300311780942,
                limb1: 15165823321813317324728175984,
                limb2: 398922922625484656,
                limb3: 0
            }
        };

        let Qy0_0: u384 = u384 {
            limb0: 2199488233999391734532875638,
            limb1: 28447338386320891337412774184,
            limb2: 442793278190378819,
            limb3: 0
        };

        let Qy1_0: u384 = u384 {
            limb0: 27929089759784879351335196989,
            limb1: 42101673423621812993830128019,
            limb2: 943541656831396621,
            limb3: 0
        };

        let p_1: G1Point = G1Point {
            x: u384 {
                limb0: 12774849389952005515525582886,
                limb1: 52713406077848070087291623457,
                limb2: 2380068267464040529,
                limb3: 0
            },
            y: u384 {
                limb0: 61569339508523039153089676135,
                limb1: 31376135714733248615847773437,
                limb2: 2613020738542630726,
                limb3: 0
            }
        };

        let Qy0_1: u384 = u384 {
            limb0: 12732060931036905438578012372,
            limb1: 5852429782961836985443828050,
            limb2: 1595249460472644675,
            limb3: 0
        };

        let Qy1_1: u384 = u384 {
            limb0: 26169738079278623136382325211,
            limb1: 68095117536337962493067508479,
            limb2: 1966916318905771957,
            limb3: 0
        };

        let (p_0_result, p_1_result) = run_BN254_MP_CHECK_PREPARE_PAIRS_2_circuit(
            p_0, Qy0_0, Qy1_0, p_1, Qy0_1, Qy1_1
        );
        let p_0: BNProcessedPair = BNProcessedPair {
            yInv: u384 {
                limb0: 60822057672646414767725755995,
                limb1: 1240480859722345498656947252,
                limb2: 1188078537868110095,
                limb3: 0
            },
            xNegOverY: u384 {
                limb0: 56693892093353096772525752387,
                limb1: 14852810880848665360302871319,
                limb2: 2973833718647386722,
                limb3: 0
            },
            QyNeg0: u384 {
                limb0: 30124517928390019442245752785,
                limb1: 28594946696302348124466995561,
                limb2: 3044204988612591846,
                limb3: 0
            },
            QyNeg1: u384 {
                limb0: 4394916402604531825443431434,
                limb1: 14940611659001426468049641726,
                limb2: 2543456609971574044,
                limb3: 0
            }
        };

        let p_1: BNProcessedPair = BNProcessedPair {
            yInv: u384 {
                limb0: 51164915768214758466973573956,
                limb1: 58723314951310779488600032487,
                limb2: 102918274785741234,
                limb3: 0
            },
            xNegOverY: u384 {
                limb0: 24178191609559982124836364373,
                limb1: 15587998901532707390211025856,
                limb2: 972387668456940627,
                limb3: 0
            },
            QyNeg0: u384 {
                limb0: 19591945231352505738200616051,
                limb1: 51189855299661402476435941695,
                limb2: 1891748806330325990,
                limb3: 0
            },
            QyNeg1: u384 {
                limb0: 6154268083110788040396303212,
                limb1: 68175330060549614562356211602,
                limb2: 1520081947897198707,
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
                limb0: 56349655478719427240765653030,
                limb1: 17286553254884325336470303544,
                limb2: 3283908801440032770,
                limb3: 0
            },
            y: u384 {
                limb0: 4085235224340127195626086125,
                limb1: 42708027764220569035315137786,
                limb2: 817961791725662386,
                limb3: 0
            }
        };

        let Qy0_0: u384 = u384 {
            limb0: 76434832132754633490163424430,
            limb1: 30273201383631429004565994049,
            limb2: 2363003962451021919,
            limb3: 0
        };

        let Qy1_0: u384 = u384 {
            limb0: 67181464348383208423372168764,
            limb1: 3794431356048308787980010153,
            limb2: 1731450124857120020,
            limb3: 0
        };

        let p_1: G1Point = G1Point {
            x: u384 {
                limb0: 3764196625586212385937169902,
                limb1: 11186560538309167767916607727,
                limb2: 2046221344628601648,
                limb3: 0
            },
            y: u384 {
                limb0: 56091468040946853524585575622,
                limb1: 39581737896398876793428554846,
                limb2: 2374778007949916174,
                limb3: 0
            }
        };

        let Qy0_1: u384 = u384 {
            limb0: 15220045083056410219412222017,
            limb1: 1059234557222186218260778608,
            limb2: 3065107383757431829,
            limb3: 0
        };

        let Qy1_1: u384 = u384 {
            limb0: 20254911813769620536888744560,
            limb1: 54926739039896865580646253890,
            limb2: 2553197388299306577,
            limb3: 0
        };

        let p_2: G1Point = G1Point {
            x: u384 {
                limb0: 16097865266992948143972547440,
                limb1: 32708505575254160625016197744,
                limb2: 177384702236068465,
                limb3: 0
            },
            y: u384 {
                limb0: 28865018654155620417909340670,
                limb1: 2963200671434223586382608355,
                limb2: 2997894556954859761,
                limb3: 0
            }
        };

        let Qy0_2: u384 = u384 {
            limb0: 70741525528038451470170934999,
            limb1: 37739490344997562917580051567,
            limb2: 468426367083159676,
            limb3: 0
        };

        let Qy1_2: u384 = u384 {
            limb0: 36127157629325685361853023793,
            limb1: 38732914286372808990758933625,
            limb2: 2582080406073169759,
            limb3: 0
        };

        let (p_0_result, p_1_result, p_2_result) = run_BN254_MP_CHECK_PREPARE_PAIRS_3_circuit(
            p_0, Qy0_0, Qy1_0, p_1, Qy0_1, Qy1_1, p_2, Qy0_2, Qy1_2
        );
        let p_0: BNProcessedPair = BNProcessedPair {
            yInv: u384 {
                limb0: 32483340715188066722195520459,
                limb1: 14168770308649062195900161916,
                limb2: 2359161929207650205,
                limb3: 0
            },
            xNegOverY: u384 {
                limb0: 73520309768983577788207998330,
                limb1: 48184693935131151177196975547,
                limb2: 1720331472298905251,
                limb3: 0
            },
            QyNeg0: u384 {
                limb0: 35117336543899115280159154329,
                limb1: 26769083698991810457313775695,
                limb2: 1123994304351948746,
                limb3: 0
            },
            QyNeg1: u384 {
                limb0: 44370704328270540346950409995,
                limb1: 53247853726574930673899759591,
                limb2: 1755548141945850645,
                limb3: 0
            }
        };

        let p_1: BNProcessedPair = BNProcessedPair {
            yInv: u384 {
                limb0: 45539777654674969029817649104,
                limb1: 75623284448265552904012816241,
                limb2: 393915794723178396,
                limb3: 0
            },
            xNegOverY: u384 {
                limb0: 22889026423030891629421694837,
                limb1: 50683952183361311910798768821,
                limb2: 1280100671025195299,
                limb3: 0
            },
            QyNeg0: u384 {
                limb0: 17103961079333000957366406406,
                limb1: 55983050525401053243618991137,
                limb2: 421890883045538836,
                limb3: 0
            },
            QyNeg1: u384 {
                limb0: 12069094348619790639889883863,
                limb1: 2115546042726373881233515855,
                limb2: 933800878503664088,
                limb3: 0
            }
        };

        let p_2: BNProcessedPair = BNProcessedPair {
            yInv: u384 {
                limb0: 69103919529646431573756764494,
                limb1: 53742263376771885413310110556,
                limb2: 2620875087929027145,
                limb3: 0
            },
            xNegOverY: u384 {
                limb0: 10981966017743740023644320760,
                limb1: 4915096678783089029774591971,
                limb2: 2917234330162231207,
                limb3: 0
            },
            QyNeg0: u384 {
                limb0: 40810643148615297300151643760,
                limb1: 19302794737625676544299718177,
                limb2: 3018571899719810989,
                limb3: 0
            },
            QyNeg1: u384 {
                limb0: 75425011047328063408469554966,
                limb1: 18309370796250430471120836119,
                limb2: 904917860729800906,
                limb3: 0
            }
        };
        assert_eq!(p_0_result, p_0);
        assert_eq!(p_1_result, p_1);
        assert_eq!(p_2_result, p_2);
    }
}
