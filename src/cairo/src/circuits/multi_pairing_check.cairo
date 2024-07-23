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
            limb0: 7344375013155839704235761907,
            limb1: 48273819813794874126598246896,
            limb2: 8212944115960915612535652144,
            limb3: 789118759631779438967974766
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 11199451867686411030904116961,
            limb1: 23560028193285502915579917362,
            limb2: 10205980404403332575893249337,
            limb3: 6555324516621652209185464006
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 13322938056982841566354048681,
                limb1: 67120715755219753377435418049,
                limb2: 56741575974787021219112902926,
                limb3: 7966334379181375395605664618
            },
            x1: u384 {
                limb0: 70406565377771408063421978991,
                limb1: 33696328349706465951703434627,
                limb2: 48890225480852673905029901012,
                limb3: 7537094107950334827451857815
            },
            y0: u384 {
                limb0: 13998717374346555009553398208,
                limb1: 6188020863925428834550824929,
                limb2: 54189499951819063143212931861,
                limb3: 764848010860223842672972002
            },
            y1: u384 {
                limb0: 71286351052240350032884527152,
                limb1: 67858259665079789987883550363,
                limb2: 50484796833791973214974988181,
                limb3: 7376486033534650187790959586
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 3847347028240307929246399105,
            limb1: 60194970441408476461693590109,
            limb2: 41355117943048391081747246607,
            limb3: 1183267223458063459632782176
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 53784328999925180959612869201,
            limb1: 50926788905811066866496819592,
            limb2: 3517343427745822223697238218,
            limb3: 3914365279398980996613340968
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 74150806274773668696412968848,
                limb1: 7686098532583279797629449976,
                limb2: 26913068544381136591393694309,
                limb3: 5126599295521789751268176334
            },
            x1: u384 {
                limb0: 10073462748672601989498419307,
                limb1: 54654415088456144294999564343,
                limb2: 37545080928110030572454027642,
                limb3: 1679830964493808139838706960
            },
            y0: u384 {
                limb0: 21208629679393236999076415741,
                limb1: 36687453609278002520965083956,
                limb2: 28142932631205916663818815322,
                limb3: 5195821438935458098714276532
            },
            y1: u384 {
                limb0: 22149704405714006878620096118,
                limb1: 72945427846282826319270372708,
                limb2: 78049924360066542745432526213,
                limb3: 5792264195891124168177567243
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 49982668527670591791059261963,
            limb1: 42967166419165953449936869781,
            limb2: 41482657112546627783395518321,
            limb3: 7622042126728444169206184623
        };

        let f_i_of_z: u384 = u384 {
            limb0: 58204414064505455420866124647,
            limb1: 73153589601613689156375267321,
            limb2: 21968407784898399973182034977,
            limb3: 5915880208989073166479306160
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 75834859930122649566331474716,
                limb1: 22107946145179706521044956801,
                limb2: 70293036018382830471602169984,
                limb3: 7925488250449650257093015563
            },
            w1: u384 {
                limb0: 66213185873935939886185491887,
                limb1: 8512265680627107983630990646,
                limb2: 1815684477943851375504057262,
                limb3: 2477395319112873323618396314
            },
            w2: u384 {
                limb0: 13733158054783705139029581344,
                limb1: 41742718178206473532417000575,
                limb2: 12712349049658973026798525814,
                limb3: 7061162935542359164985792314
            },
            w3: u384 {
                limb0: 73304916473177943818114629347,
                limb1: 57996239034632217999064063088,
                limb2: 47949313112734450911023209891,
                limb3: 5731468658094848977391747886
            },
            w4: u384 {
                limb0: 18222947585319780720874063305,
                limb1: 60907350997149395137198381388,
                limb2: 59817832410992920215861147744,
                limb3: 2552587355456280819129893757
            },
            w5: u384 {
                limb0: 50960506429047088541928462508,
                limb1: 9003354723369032131910273213,
                limb2: 7715315562854861341619218230,
                limb3: 1628597145330323242427857260
            },
            w6: u384 {
                limb0: 45613207976562493705236190269,
                limb1: 33317040226367365341840503416,
                limb2: 5870151008104524133305326782,
                limb3: 7150434705568940705534372565
            },
            w7: u384 {
                limb0: 49713437368568408465958301167,
                limb1: 58220128375993941639637268691,
                limb2: 68759225742249681882374654808,
                limb3: 336485674369308822160667671
            },
            w8: u384 {
                limb0: 63427004947453722986484747233,
                limb1: 44389808160445879851412315862,
                limb2: 53086363961042498922605184075,
                limb3: 436515910710610609408240751
            },
            w9: u384 {
                limb0: 35216425251085549583356748669,
                limb1: 49853272411876124192218639439,
                limb2: 10810551671647617275596190907,
                limb3: 337329549855947204382395047
            },
            w10: u384 {
                limb0: 73468994460072017165699042992,
                limb1: 16322586100843699485616083467,
                limb2: 40680255971072468006922858313,
                limb3: 7234890367282600292153020257
            },
            w11: u384 {
                limb0: 10411529522952050124971590161,
                limb1: 49486387728646292700381512678,
                limb2: 16401843298178622311075890899,
                limb3: 31814016576296661412465916
            }
        };

        let ci: u384 = u384 {
            limb0: 34570267907358593199727400635,
            limb1: 74997625163783029950476202302,
            limb2: 13192491231654348512964216956,
            limb3: 3634849995762871431045387557
        };

        let z: u384 = u384 {
            limb0: 31165246239988695484247940304,
            limb1: 29765569664200681455665327480,
            limb2: 379778966766573485,
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
                limb0: 30752609711344858566688608908,
                limb1: 1497975434082701038946480452,
                limb2: 68231779853369120207791776956,
                limb3: 2059283811017879860402694228
            },
            x1: u384 {
                limb0: 60650244343591815938978082756,
                limb1: 4367010037230095190731012093,
                limb2: 33343124607734669192425347422,
                limb3: 408138305341003389338374875
            },
            y0: u384 {
                limb0: 69170271881282864269813296967,
                limb1: 65110107158013504109588457959,
                limb2: 77717039879528855789429159518,
                limb3: 2044681853999956645594306024
            },
            y1: u384 {
                limb0: 9623653043006144297520629580,
                limb1: 30155614312356065260320238730,
                limb2: 41806424855044996098540199783,
                limb3: 2112776272665180650615335897
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 51870375837097121029649467439,
                limb1: 47022597054077365936625220793,
                limb2: 63246762465112715132597159149,
                limb3: 1537749529073135118798172838
            },
            x1: u384 {
                limb0: 21945061653282731409158570298,
                limb1: 74234973062573181077419229694,
                limb2: 16568955155192762634128399784,
                limb3: 2718214480593142213642566165
            },
            y0: u384 {
                limb0: 45166542188039648717209928436,
                limb1: 47895595084239233698211838413,
                limb2: 65076599825461227353318804840,
                limb3: 6261310281352722439907550525
            },
            y1: u384 {
                limb0: 62536539990496209727283312403,
                limb1: 69308101679313346153872091697,
                limb2: 71572493130718644058018641036,
                limb3: 3781453053013851609434902419
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 20705458396310602503526387243,
            limb1: 7501278780569076553812933036,
            limb2: 40710132772782076821810430112,
            limb3: 5604544072070965760002411963
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 69048522459521629722449911445,
            limb1: 46693778539163203432996421943,
            limb2: 60778440948463335071589305931,
            limb3: 6722923875355948971867589068
        };

        let ci_plus_one: u384 = u384 {
            limb0: 52003763477875349748172991707,
            limb1: 23100571288286447064210556237,
            limb2: 39877300447391627451008994725,
            limb3: 2193771993860780808816632928
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
            limb0: 815894725481902667074648193,
            limb1: 47208528053011196752562709988,
            limb2: 22529201445295185575091678869,
            limb3: 5920799479445628175778622511
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 56357068461107729834364795331,
            limb1: 38200062578760278260722815804,
            limb2: 40588293199267004468414571935,
            limb3: 646896919949626320411763461
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 7009561245346038720077110016,
                limb1: 12139853903083794143438819714,
                limb2: 62026473730160023474626861106,
                limb3: 1945040853441885722860208949
            },
            x1: u384 {
                limb0: 76077618560384805781229436729,
                limb1: 12673348618602849456301767861,
                limb2: 39494866985954198578206953940,
                limb3: 2421847756502534492786033816
            },
            y0: u384 {
                limb0: 6202439326225025374759874545,
                limb1: 72698342699992008007264626028,
                limb2: 27640858905596583660823197396,
                limb3: 4429763421702546755274559606
            },
            y1: u384 {
                limb0: 55830960468852471565214726216,
                limb1: 72793356308879072269416385756,
                limb2: 15895970899188913513220913018,
                limb3: 705405775717659174878324614
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 61304318483650783638623483353,
            limb1: 49645327949933366642776003497,
            limb2: 34614668614368479314479830140,
            limb3: 2953110887144864612804175418
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 39929013079309805546928031946,
            limb1: 53922727088364717644554259348,
            limb2: 4123582075179158883899400302,
            limb3: 4453607279068019466033928739
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 26065947307662396045633472449,
                limb1: 32230763426215821572634037426,
                limb2: 67663876279607154702852180658,
                limb3: 8045324249089060062782800315
            },
            x1: u384 {
                limb0: 40480281207323463805453132979,
                limb1: 37787831680841616498674625317,
                limb2: 19754267738029484702899678136,
                limb3: 1740478055090748958509967456
            },
            y0: u384 {
                limb0: 3595222672689865053019927263,
                limb1: 54148142728856632718914838279,
                limb2: 64229925031110320165662797506,
                limb3: 2133166620509929243596810276
            },
            y1: u384 {
                limb0: 18116853768159412343120336822,
                limb1: 63000865417180871922102420668,
                limb2: 70399990666027203551356458458,
                limb3: 702592287089056937487543479
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 20127374873337477882305704674,
            limb1: 53908060923323052783783004855,
            limb2: 13480786820631452314013400938,
            limb3: 3818088391041955112433529920
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 20173949663431652856998563101,
            limb1: 55828910985722536456382284801,
            limb2: 13951686912085555677801385263,
            limb3: 1332500384342745427198887837
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 42811470812399008562446030430,
                limb1: 22891377305726857788548751366,
                limb2: 19807375948712055145251381803,
                limb3: 5232463849133383202790178207
            },
            x1: u384 {
                limb0: 40244951330184841449789215089,
                limb1: 27761122337575846586217636408,
                limb2: 23385861739524948465105119328,
                limb3: 2135114932673449758318973142
            },
            y0: u384 {
                limb0: 58539199347015098104376316130,
                limb1: 11581801070717944926704163831,
                limb2: 7895104975914800764585117874,
                limb3: 431638768359181972350771182
            },
            y1: u384 {
                limb0: 14568757707348615206782700479,
                limb1: 22891359365712138830725021758,
                limb2: 59146509987076999660030006892,
                limb3: 7196130621820947583976935483
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 3509646953493546455335968282,
            limb1: 28377025265953310667455869879,
            limb2: 67932517346257342899638093795,
            limb3: 2863972352210674288491767607
        };

        let f_i_of_z: u384 = u384 {
            limb0: 61167003318164758015914710473,
            limb1: 67952024586398202530696823107,
            limb2: 34477046274830489121500992180,
            limb3: 4905186559274787093392101982
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 65087853520896742076133370523,
                limb1: 57731661826547070798977776087,
                limb2: 37457283337925852102721294449,
                limb3: 1528405518152763465799825455
            },
            w1: u384 {
                limb0: 6344455894065058999421513308,
                limb1: 76408511067119718759827293380,
                limb2: 36078869033374480975867845999,
                limb3: 7063006732685810807796313783
            },
            w2: u384 {
                limb0: 73642699226173251177232726966,
                limb1: 153093432215530225840134318,
                limb2: 39065217515938826988366952780,
                limb3: 2883871503658441656059568580
            },
            w3: u384 {
                limb0: 54199747261734630097113781797,
                limb1: 74175391682687870333370896162,
                limb2: 5538750469960644257132186369,
                limb3: 2085254727890494248865792175
            },
            w4: u384 {
                limb0: 77735393985802253590713426664,
                limb1: 27867213086285639966374638160,
                limb2: 11466720957048582816848528487,
                limb3: 4770536589068349725772393272
            },
            w5: u384 {
                limb0: 5099497905033299758211782831,
                limb1: 44797628104370347625472444756,
                limb2: 10731180887662674351963878969,
                limb3: 5204813563846424413575540003
            },
            w6: u384 {
                limb0: 6424415750015539551999299858,
                limb1: 336314705731102706893713482,
                limb2: 46300711495617005168594687082,
                limb3: 6668929189443698681991140452
            },
            w7: u384 {
                limb0: 71355009610885168679324013008,
                limb1: 23909838630567568388570160712,
                limb2: 55578836447830561028228089345,
                limb3: 459213579616700199633725942
            },
            w8: u384 {
                limb0: 61040362146433004083819844141,
                limb1: 7257754017407416582674802251,
                limb2: 29743740455198348944654581816,
                limb3: 2078538771761084077370041928
            },
            w9: u384 {
                limb0: 60375912085372234586006975480,
                limb1: 12563630257594957592161588716,
                limb2: 17195688857120241604535604023,
                limb3: 2167950011965939442205082499
            },
            w10: u384 {
                limb0: 52144287777238114509798836599,
                limb1: 63510619300248595428902552392,
                limb2: 26296018614694695603906408174,
                limb3: 711809303195370418743417193
            },
            w11: u384 {
                limb0: 52211325999951158962226509102,
                limb1: 71072897838146636591452903567,
                limb2: 18093036843645968723774375556,
                limb3: 3977076293236353785977746202
            }
        };

        let ci: u384 = u384 {
            limb0: 20926956347428121717371229307,
            limb1: 39167973702580879200974338043,
            limb2: 73931421140987771804125842665,
            limb3: 1484058777916331965415752268
        };

        let z: u384 = u384 {
            limb0: 14682042323034463933939933721,
            limb1: 8017626049779495126315098747,
            limb2: 477813781465355385,
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
                limb0: 20157873104478919362592126067,
                limb1: 40222906608429735131003011883,
                limb2: 61831473345411020446526725397,
                limb3: 6209474790886677731333350352
            },
            x1: u384 {
                limb0: 69488134415439078965197344194,
                limb1: 33246570740653471632702555102,
                limb2: 38122796205350373097991856795,
                limb3: 2485533263398023687989615549
            },
            y0: u384 {
                limb0: 9849405530040488725767348030,
                limb1: 37572508343929501063546553394,
                limb2: 23273733134349584891897383084,
                limb3: 2860393110465070954076231834
            },
            y1: u384 {
                limb0: 9718644715686464516660429254,
                limb1: 75900241895427752656136797152,
                limb2: 53083629913200443768497609020,
                limb3: 2199545733061576514707447607
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 64394607224370722075516996237,
                limb1: 31812986195311185629445839862,
                limb2: 35011433142430159656677773969,
                limb3: 6212111330110698627671770900
            },
            x1: u384 {
                limb0: 30977306158128988839012104357,
                limb1: 61787078473560258478566248917,
                limb2: 53041245935159140263314445269,
                limb3: 7099034973341343769277016427
            },
            y0: u384 {
                limb0: 48372011104432898258418252989,
                limb1: 44210346247216841300823405738,
                limb2: 61753696383511049614683104865,
                limb3: 8019474214065066317277237777
            },
            y1: u384 {
                limb0: 69174161601535480715464173249,
                limb1: 78300883335888917480140439567,
                limb2: 64442060147416162077459861451,
                limb3: 1675066377058378593447556204
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 15378772576144566712045835301,
                limb1: 42364740821340384422373594349,
                limb2: 35296286705503394493433332898,
                limb3: 282415432652709402441671129
            },
            x1: u384 {
                limb0: 19403367623587393013817318965,
                limb1: 8838113635437916369496888980,
                limb2: 32072848032889587311332418730,
                limb3: 1321507933735618420826091390
            },
            y0: u384 {
                limb0: 17841116971509830888506420499,
                limb1: 35274004381213317731449664015,
                limb2: 1497193487319152832979494184,
                limb3: 3646634838457584100252603061
            },
            y1: u384 {
                limb0: 2355080127165977773777447559,
                limb1: 34149693696722420440167953800,
                limb2: 53047278538895570043372294201,
                limb3: 6115478174435058352290090559
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 42256504819064755422111963351,
            limb1: 29761453230117505477999157003,
            limb2: 29705495727073375885868822942,
            limb3: 853123419404265486335312980
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 43163390103570940925990053742,
            limb1: 74327897947957911765361556040,
            limb2: 9732150839569370962730809898,
            limb3: 726294655891014272519420196
        };

        let ci_plus_one: u384 = u384 {
            limb0: 38499560939830311465678390100,
            limb1: 5889332938788778571709369510,
            limb2: 1894609403691134727641282615,
            limb3: 4228219148679601593897624500
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
            limb0: 66898794098186850507101313338,
            limb1: 42150618823834854549050963349,
            limb2: 48910610037904207709279538446,
            limb3: 1990908837832857854307248508
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 17066942671172346121508901055,
            limb1: 48566145015853239983191527876,
            limb2: 14202938106184663934976623755,
            limb3: 1867495393979071192735655245
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 78385801750995130862342629040,
                limb1: 54541118466024503173720233057,
                limb2: 17336247689297051837021615235,
                limb3: 6610171574772757147866166761
            },
            x1: u384 {
                limb0: 54038715493742999405629905312,
                limb1: 69879835061615375525083140168,
                limb2: 15244102582009593761981124103,
                limb3: 2493743846382671139934471351
            },
            y0: u384 {
                limb0: 56816026858187455380109943976,
                limb1: 54124196284688233403522512119,
                limb2: 59824021255212481077255962264,
                limb3: 6337234536823458345126497125
            },
            y1: u384 {
                limb0: 27134614225674870008332420314,
                limb1: 37600371060870141941295564950,
                limb2: 14086571943643142145009035287,
                limb3: 4197640599402875974071770728
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 1482940270920587211128055870,
            limb1: 7784112316723220206908123854,
            limb2: 22423046166058794157691651484,
            limb3: 5247334755628967375116311373
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 27847100426264234941653273808,
            limb1: 34095441235993692661895767409,
            limb2: 28712012792479195381198448868,
            limb3: 4128526702116342476327779159
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 70932496320398269913084690191,
                limb1: 77830747173845609234294847872,
                limb2: 41904059187762897941093520566,
                limb3: 1971868805537018494695761861
            },
            x1: u384 {
                limb0: 6788758202480235327772044529,
                limb1: 70175107294689117924583843173,
                limb2: 42099225665399811589318733987,
                limb3: 2874156694463943431016942238
            },
            y0: u384 {
                limb0: 749820297255324434935753619,
                limb1: 76144570152273425725449122688,
                limb2: 35512992890562466483485896272,
                limb3: 477385270306841327069054167
            },
            y1: u384 {
                limb0: 20722483254621476473557894747,
                limb1: 37931353347301853064547504903,
                limb2: 7008292954972454397002049669,
                limb3: 4762925461951636069072986702
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 8299048747128474719710367195,
            limb1: 74047261163399890154020794920,
            limb2: 22707504058081626697253010161,
            limb3: 604916666244038192203793074
        };

        let f_i_of_z: u384 = u384 {
            limb0: 74839978954702524468895316803,
            limb1: 8544868477973609986080914647,
            limb2: 26488815936766815911228582779,
            limb3: 5556743036314115533458151697
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 20651615686382921080344775143,
                limb1: 76126035029926038123464197701,
                limb2: 44160777236766933356527057343,
                limb3: 293934313377157921598407884
            },
            w1: u384 {
                limb0: 33604803162354153869279965744,
                limb1: 62962812621177267229831413275,
                limb2: 53036070427694343012725253423,
                limb3: 2266874682967133333298701079
            },
            w2: u384 {
                limb0: 33423094758638770509214116291,
                limb1: 6624924498063016167804008197,
                limb2: 69119881219132732519207941010,
                limb3: 7609001187017846915225509842
            },
            w3: u384 {
                limb0: 31613441737782608886556905679,
                limb1: 72328577131602201408606086800,
                limb2: 8321896922174809904273522162,
                limb3: 1911906158907962703127067609
            },
            w4: u384 {
                limb0: 50901242745105314366211994707,
                limb1: 11433645682179747024546588417,
                limb2: 71264764873526871362447162342,
                limb3: 323610362803009169402127693
            },
            w5: u384 {
                limb0: 16464491881773765808701327312,
                limb1: 45168704666923177900355814073,
                limb2: 9179317848163247398254316291,
                limb3: 3351271410768461893086305626
            },
            w6: u384 {
                limb0: 73999690185212585619617514242,
                limb1: 62073519573212403014685496771,
                limb2: 18669868221221592475689181099,
                limb3: 7282233418740874790279960847
            },
            w7: u384 {
                limb0: 33169592589145400145144526317,
                limb1: 17049029622741054857978352103,
                limb2: 8060876810601453530127441971,
                limb3: 6100338537325009080565176083
            },
            w8: u384 {
                limb0: 69844556005101128201521515968,
                limb1: 26380752061867380165563672693,
                limb2: 40353766627053614916986821349,
                limb3: 5736394878934628709867764216
            },
            w9: u384 {
                limb0: 4052955733568832946657852190,
                limb1: 52372092363491647239088015859,
                limb2: 34242689700757564951285045920,
                limb3: 7744053161949629428315892408
            },
            w10: u384 {
                limb0: 62505647863352096926662303463,
                limb1: 7662952973292534722750046066,
                limb2: 11819334322330838424606312378,
                limb3: 2228144000998654854136880212
            },
            w11: u384 {
                limb0: 10926904322282820847706390438,
                limb1: 45182068785185827134676054734,
                limb2: 37761923604613353371701557318,
                limb3: 2328601210277656834509591410
            }
        };

        let ci: u384 = u384 {
            limb0: 19609363213726272674414457324,
            limb1: 64623442223733833178221935997,
            limb2: 13839342760447473857713462593,
            limb3: 1010285289685609669771462635
        };

        let z: u384 = u384 {
            limb0: 63770474546560321334267559769,
            limb1: 12656197913646106927140463440,
            limb2: 246716921369248729,
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
                limb0: 1764917729389260788340678551,
                limb1: 41906025388715132281055355848,
                limb2: 32650311352979461835603744248,
                limb3: 6330394484541481858795881700
            },
            x1: u384 {
                limb0: 13773397247449577197368889606,
                limb1: 75166658657935597480890240507,
                limb2: 17413341146262408648340795068,
                limb3: 7046591710508549804070652693
            },
            y0: u384 {
                limb0: 65933837255322453651046702945,
                limb1: 59604594459623028614207053029,
                limb2: 46890305010565938272107777917,
                limb3: 4321859431472121146636262190
            },
            y1: u384 {
                limb0: 48778953845203987517786870688,
                limb1: 2732793233678598502901556840,
                limb2: 21287924273940918074763731958,
                limb3: 7406241203646838325179036336
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 63409754051482504592672183259,
                limb1: 64227418276388045375701165714,
                limb2: 348567066288940018710175488,
                limb3: 1792707050592466988381905395
            },
            x1: u384 {
                limb0: 4910279081287454414663006724,
                limb1: 57188260139997937080663816538,
                limb2: 4107145635414972607267673237,
                limb3: 3692280047665402730316118199
            },
            y0: u384 {
                limb0: 32517643402024035642007567604,
                limb1: 31976860077219050483254439326,
                limb2: 61307690815938127993784554155,
                limb3: 6675416782498854933575530079
            },
            y1: u384 {
                limb0: 75011743218022966131609257812,
                limb1: 68836367586537803968946370062,
                limb2: 32438299485705636624117276226,
                limb3: 1381983680164244983389922020
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 37854968589584359016992144089,
            limb1: 27241795902383752751036470943,
            limb2: 6481310379453313397313856249,
            limb3: 1933055661384403217464789592
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 46081879251564179479568446462,
            limb1: 70420586679211265732301149541,
            limb2: 42333970785813813479764849731,
            limb3: 6092793536833080349635212101
        };

        let ci_plus_one: u384 = u384 {
            limb0: 12720219368279773367952062042,
            limb1: 42811262843795972870244602866,
            limb2: 49920895411621415019021126299,
            limb3: 2957074206562805298047535680
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
            limb0: 72738479218131622180615117992,
            limb1: 59804115567261302874304661591,
            limb2: 51072553878076750621938481284,
            limb3: 5654862758190121472867223881
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 21592807249069649586656649767,
            limb1: 1441881871070187369908768339,
            limb2: 34341981141715134965176983548,
            limb3: 2714315832938403848427028986
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 72353752541323059791065179958,
                limb1: 38883000815523402855197278331,
                limb2: 19185412057095720247840317591,
                limb3: 3591070408147414020454190266
            },
            x1: u384 {
                limb0: 24206875542118945404160986225,
                limb1: 12188743531917697326201063110,
                limb2: 6991085446778445081432464165,
                limb3: 71618796902660994442161820
            },
            y0: u384 {
                limb0: 65337408065816357714603591009,
                limb1: 26554733919250365769729609728,
                limb2: 28105435973800385912814146113,
                limb3: 644016408016751219591174983
            },
            y1: u384 {
                limb0: 68494221541488119384076704258,
                limb1: 59853947420563340344305821633,
                limb2: 57224491765505274795723228877,
                limb3: 692256262145389825724315930
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 68068444480316725466112032995,
            limb1: 19081927832531501629206135166,
            limb2: 11215887672711433802161913937,
            limb3: 6084601513164224177033957371
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 51645191413948245126085199785,
            limb1: 32454210612353186690108173457,
            limb2: 48752434189767786613468722437,
            limb3: 1040013299572536302438718253
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 33931471133770716511927176878,
                limb1: 32911962541499641767491347623,
                limb2: 27210236838495186427523820444,
                limb3: 6878872432706327047878836662
            },
            x1: u384 {
                limb0: 71184498443171767594864601566,
                limb1: 77982702133296176073848605995,
                limb2: 10776346594549485907136045869,
                limb3: 76172731124399930128256998
            },
            y0: u384 {
                limb0: 385134097327127039987515418,
                limb1: 9332006848538130751963997196,
                limb2: 47344169504231735314127121174,
                limb3: 2322535315488785530829732114
            },
            y1: u384 {
                limb0: 36996411242937511652372135410,
                limb1: 14955966714591600199652852907,
                limb2: 21490117928037792305664863946,
                limb3: 3645230735660073235081951638
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 62051836363987824979756719224,
            limb1: 43601545830475804329064662689,
            limb2: 78434798797464920687682375932,
            limb3: 5945928230865598799817033798
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 69993942537227679645050668785,
            limb1: 69170994114204920810334784812,
            limb2: 28446910752735793915171366548,
            limb3: 4070628250823961232958991871
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 55627430382730384432603157095,
                limb1: 54185643196832391186544285626,
                limb2: 64533184270906835092236750393,
                limb3: 879329241075302220709082491
            },
            x1: u384 {
                limb0: 56644680091288238027122202266,
                limb1: 4857935508345403038150336921,
                limb2: 45653519279362264603765471812,
                limb3: 2074187078508866712257295349
            },
            y0: u384 {
                limb0: 16923343092092885459833887555,
                limb1: 31624545119846362493180038324,
                limb2: 28078886448776699946510508747,
                limb3: 2873952964984428400078260638
            },
            y1: u384 {
                limb0: 36222755428013198867474072336,
                limb1: 70669302985929407532653435342,
                limb2: 60502464000186282893495262928,
                limb3: 4713967876358453341922177876
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 1737522026450273883824319056,
            limb1: 4228837939380050561566534820,
            limb2: 49376034283701021117143702216,
            limb3: 3284135560158534327039083510
        };

        let f_i_of_z: u384 = u384 {
            limb0: 71336509724213167588964555417,
            limb1: 8411161902335625284534478008,
            limb2: 62997613580581643063651613133,
            limb3: 7924217382056663923565272991
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 4950545568991458625397084361,
                limb1: 63728568865228369526582341412,
                limb2: 52608189102351847999189841122,
                limb3: 6832936993131641903680714017
            },
            w1: u384 {
                limb0: 1102693434644604330872299695,
                limb1: 41655008833887834191035194133,
                limb2: 66097805686626316724979471872,
                limb3: 5354446672781477516440592164
            },
            w2: u384 {
                limb0: 18943978450077712086184385978,
                limb1: 72742716046084932770404633325,
                limb2: 20592718281585446914964335984,
                limb3: 506011017137527028183953312
            },
            w3: u384 {
                limb0: 38665846291835952367889889865,
                limb1: 69065502598874679108716442762,
                limb2: 31201428332365468218028963977,
                limb3: 6529716060662997079135227004
            },
            w4: u384 {
                limb0: 19509809312441657592726355037,
                limb1: 60624118698077951119808591365,
                limb2: 12314442214924876231767309263,
                limb3: 6661081559070522569876230513
            },
            w5: u384 {
                limb0: 20308537251802697933647364386,
                limb1: 15208586696006599468533852384,
                limb2: 43767544176704844033736144689,
                limb3: 6577731676738635294157464814
            },
            w6: u384 {
                limb0: 55502229833345927150109666143,
                limb1: 45387725411046155329621704887,
                limb2: 3820883086112976178131057083,
                limb3: 3825924160089998892866206548
            },
            w7: u384 {
                limb0: 24062837592966677945473288428,
                limb1: 40504130531836849409969900593,
                limb2: 23134407568974648475900777478,
                limb3: 3191574316512631319852406797
            },
            w8: u384 {
                limb0: 77948576871652827497046123986,
                limb1: 16454376489312713159024393165,
                limb2: 24028508338243165164240751916,
                limb3: 1005946115567801197943179688
            },
            w9: u384 {
                limb0: 41417455752323617189133954826,
                limb1: 31093815141512925547680896813,
                limb2: 46371300719742527964177788593,
                limb3: 4357562408032308888462320901
            },
            w10: u384 {
                limb0: 78031652960062609133206848159,
                limb1: 9546959834111117922109271109,
                limb2: 64289873253702344866950993507,
                limb3: 85406935762468361493245000
            },
            w11: u384 {
                limb0: 57167504851974543412527180570,
                limb1: 21151950496685766033247288880,
                limb2: 52384931935034000495736341784,
                limb3: 5847442656305909253632203802
            }
        };

        let ci: u384 = u384 {
            limb0: 26318966110430421029400701470,
            limb1: 40061213549519556874937780967,
            limb2: 59489073528430065712100818456,
            limb3: 2443856189344276257038515752
        };

        let z: u384 = u384 {
            limb0: 21344131886807265697776452250,
            limb1: 15338225853469552636414286735,
            limb2: 155071994303750759,
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
                limb0: 27378767301922833686143517038,
                limb1: 51337410913827188572679279390,
                limb2: 42718443479486482657851872760,
                limb3: 5091822877018088668895436787
            },
            x1: u384 {
                limb0: 75231692528042422779959300519,
                limb1: 41272936512319394731406143254,
                limb2: 60590709168556354329508023765,
                limb3: 4880923781167111932186984244
            },
            y0: u384 {
                limb0: 37300092076274937425884627267,
                limb1: 68743388896121737689982091635,
                limb2: 7315511109914459276413974598,
                limb3: 2860409150295296122096133404
            },
            y1: u384 {
                limb0: 7140455586794352029841759021,
                limb1: 11636064495696247320320646379,
                limb2: 36407291327802861937884185893,
                limb3: 4263118177163014765354559675
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 26554842753665639454174537067,
                limb1: 78513137270101280272270041354,
                limb2: 44465592243921404048921786365,
                limb3: 7858696388144940807694113260
            },
            x1: u384 {
                limb0: 42593326799676778396511600702,
                limb1: 11083608459754007959427123120,
                limb2: 72227916289850602307382401737,
                limb3: 2653053258585777000789824267
            },
            y0: u384 {
                limb0: 45545286079687225971419611616,
                limb1: 48596312292420610009055930095,
                limb2: 19084757260430453316473238559,
                limb3: 3150162585303398813752011213
            },
            y1: u384 {
                limb0: 44442507082942709774539463279,
                limb1: 70236386180319763579765207417,
                limb2: 39153403449742544520660434471,
                limb3: 939019391553685492975886133
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 58112456561750509143004019472,
                limb1: 33430700041779329147013955397,
                limb2: 35709487731604570412364660917,
                limb3: 3954651794252796262230165270
            },
            x1: u384 {
                limb0: 27387060481364623689571819043,
                limb1: 57546915448566073426970305793,
                limb2: 37071975457226735463725518688,
                limb3: 5112528261442937060188699335
            },
            y0: u384 {
                limb0: 69898133634053084054299812404,
                limb1: 44906755089547555058528925737,
                limb2: 63068677498652347068144764858,
                limb3: 666268163075904248017874006
            },
            y1: u384 {
                limb0: 2677644854233873298388363203,
                limb1: 11252877525596586504181240979,
                limb2: 77453045243938274025594263578,
                limb3: 3435640740769824208448272853
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 56488832881111714771149788714,
            limb1: 73639913562043507392820158706,
            limb2: 54420394058539101815910554499,
            limb3: 1972939589268313999203650363
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 6623107519891967018121631633,
            limb1: 6769104495990424866440127044,
            limb2: 53653570388033223278127742810,
            limb3: 5431900679186942831905567391
        };

        let ci_plus_one: u384 = u384 {
            limb0: 77401213388580003243282897707,
            limb1: 77351999013419473514729153060,
            limb2: 63782658127125164461847408545,
            limb3: 3550726233448241184164868121
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
            limb0: 10270525777075133315700224504,
            limb1: 41273627772016857693293055395,
            limb2: 48495343232210209936213616796,
            limb3: 3918131980174143410700957376
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 10866878106957674985426320683,
            limb1: 60814141268779366113937245594,
            limb2: 65255122644499280021609414364,
            limb3: 3382890008280704524057269670
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 61569562842833326569635693048,
                limb1: 14002922645198855308228496136,
                limb2: 851706915890244793295312008,
                limb3: 4913318351856332449828594016
            },
            x1: u384 {
                limb0: 4031195088403449262183790517,
                limb1: 817514199874961996430670589,
                limb2: 61388600382383045252818006789,
                limb3: 6465775098127045948665810451
            },
            y0: u384 {
                limb0: 416940567047984492916305837,
                limb1: 5640261571132854236110928094,
                limb2: 47640737247279044054281182842,
                limb3: 334953285401241559908016812
            },
            y1: u384 {
                limb0: 62573716580423026628703590306,
                limb1: 17243495528221491441036605246,
                limb2: 69241837181544296146904884380,
                limb3: 2333617825806806478829776227
            }
        };

        let Q_or_Qneg_0: G2Point = G2Point {
            x0: u384 {
                limb0: 28832884305707186472331019383,
                limb1: 75352872769653825324569060759,
                limb2: 43500912818506717599093667527,
                limb3: 3317422609559076190256630926
            },
            x1: u384 {
                limb0: 76274573925369262914841737673,
                limb1: 22335234546393731695807515797,
                limb2: 74480753452933685520145134968,
                limb3: 5503072229424092167492878486
            },
            y0: u384 {
                limb0: 14703945616479682761682197552,
                limb1: 66567259738529382701723786422,
                limb2: 75359742298265893137713727942,
                limb3: 4409585945595711469786654977
            },
            y1: u384 {
                limb0: 1546631683566543300994822571,
                limb1: 55291378241212975926458368183,
                limb2: 9939375766051829449217316998,
                limb3: 3470275672302539030956168312
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 37493528488191583576504021652,
            limb1: 13254474555893715421976593190,
            limb2: 43922617329982233428753994144,
            limb3: 4215721233752249652214948583
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 53744403841485302647108495074,
            limb1: 18887874813634934675164754286,
            limb2: 6196361778141201612504976707,
            limb3: 3274798192586703991185501871
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 30687536668176394375456703336,
                limb1: 3781874451263404152497050236,
                limb2: 54879464428999536222443454387,
                limb3: 6333426372390470411591669477
            },
            x1: u384 {
                limb0: 42031191961224779389788905563,
                limb1: 63797656052403472538155455741,
                limb2: 6015094480530939914449022363,
                limb3: 7219068560908406587743567681
            },
            y0: u384 {
                limb0: 59774008864869882053472844747,
                limb1: 55494070418672716528146301373,
                limb2: 13974037278681743855635724025,
                limb3: 4659035877877816188070130982
            },
            y1: u384 {
                limb0: 3630407599690021214451045400,
                limb1: 32558899824297663866986102709,
                limb2: 32195487297937452909102975555,
                limb3: 6397873234008683741719128355
            }
        };

        let Q_or_Qneg_1: G2Point = G2Point {
            x0: u384 {
                limb0: 26636642406891112036142813971,
                limb1: 22101491518070189307805344505,
                limb2: 27329981067941661487103626184,
                limb3: 7344947780444752110217509226
            },
            x1: u384 {
                limb0: 35841648475365911955602994303,
                limb1: 14123437664839883907142289247,
                limb2: 71086894883378454156557235352,
                limb3: 6234177787685010310773380266
            },
            y0: u384 {
                limb0: 4217314271872491872576185341,
                limb1: 35635138836873756703547805217,
                limb2: 6016189052409329336125450926,
                limb3: 1184265810325184594266941338
            },
            y1: u384 {
                limb0: 13403200920350082548552488898,
                limb1: 4352298733847178082484445858,
                limb2: 47767829495283212306124049549,
                limb3: 1727463755568118226180803285
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 77327534125681170775259418623,
            limb1: 58799396636027713162390332626,
            limb2: 10695659750691371741041111241,
            limb3: 3667300216936875257472481775
        };

        let f_i_of_z: u384 = u384 {
            limb0: 22169091740652787885613017918,
            limb1: 561305495775730961846808566,
            limb2: 26577495029113835893127935971,
            limb3: 749893059359583788881600801
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 42300368557468181639453904579,
                limb1: 12816291217720245058877262811,
                limb2: 49001010808670926191958200438,
                limb3: 5479236131009814999137589659
            },
            w1: u384 {
                limb0: 75780736278525312131732800705,
                limb1: 60341850856133427522636637635,
                limb2: 4635370242855441537546401758,
                limb3: 2131534916452135004432463825
            },
            w2: u384 {
                limb0: 71312498493826879170995335379,
                limb1: 1949919922263504932659085206,
                limb2: 33593943677901085986550411528,
                limb3: 6408742349028922710301753127
            },
            w3: u384 {
                limb0: 30725170511976440801341992659,
                limb1: 70158530836372615678944532181,
                limb2: 64936192179739830216981969791,
                limb3: 1875632686408204864460826024
            },
            w4: u384 {
                limb0: 5416441650074344389735515789,
                limb1: 66436954800048167066356196460,
                limb2: 15318443593956385032213790664,
                limb3: 8003705200892113318032210576
            },
            w5: u384 {
                limb0: 29925452837584511339814435065,
                limb1: 71781451021120638292092266438,
                limb2: 62304929999554921948177070664,
                limb3: 6122962266117534665966812562
            },
            w6: u384 {
                limb0: 12108246340442429455971122644,
                limb1: 36573992723376078553845399626,
                limb2: 23772335124274775229954098498,
                limb3: 2863569299286716314494810078
            },
            w7: u384 {
                limb0: 33875646533936559234872809775,
                limb1: 78504313903278613976349702955,
                limb2: 10928763983555625777832409826,
                limb3: 1382242378138602446805086908
            },
            w8: u384 {
                limb0: 77820720629424806009019504358,
                limb1: 25129522554439892503182453198,
                limb2: 73755848318658190723354415348,
                limb3: 1434823775076896096245150309
            },
            w9: u384 {
                limb0: 25786100892102041398555537288,
                limb1: 9688927942274723458760705785,
                limb2: 22938303269890629181013757689,
                limb3: 478926814095195537286572739
            },
            w10: u384 {
                limb0: 34694988415059553205942033992,
                limb1: 77263929789656935575577621941,
                limb2: 50605482325959137133224655107,
                limb3: 163430648919606487753511787
            },
            w11: u384 {
                limb0: 28212222609585886906853123633,
                limb1: 23532623940105012734361898218,
                limb2: 67365120472097392426905098257,
                limb3: 3357851176268082037335105674
            }
        };

        let c_or_cinv_of_z: u384 = u384 {
            limb0: 52293061812384466408305828874,
            limb1: 78921144064263136073971338402,
            limb2: 51090796273196843346160009363,
            limb3: 3711054840487085193997117763
        };

        let z: u384 = u384 {
            limb0: 36880896032498523141231777761,
            limb1: 548870523643093760961939326,
            limb2: 285341065541849776,
            limb3: 0
        };

        let ci: u384 = u384 {
            limb0: 53402248372583665571828248070,
            limb1: 30009280800305497440341765267,
            limb2: 10096741978574011589218319912,
            limb3: 5694580481589293809476822207
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
                limb0: 14042667016545301194786461143,
                limb1: 55733678628503947269730059507,
                limb2: 33992596258161151053067127352,
                limb3: 828572713875099410828936617
            },
            x1: u384 {
                limb0: 77769745135619439405823361826,
                limb1: 76167825092037376660498035972,
                limb2: 54824343745132782099741888812,
                limb3: 494707088538115505710770122
            },
            y0: u384 {
                limb0: 57685810173755762111794816687,
                limb1: 5383700548004513568226942084,
                limb2: 66573987758945269586431321693,
                limb3: 5908267976700499209668293387
            },
            y1: u384 {
                limb0: 49685823189323440886005887987,
                limb1: 57539076523796554175933906423,
                limb2: 33479399920058647214363326918,
                limb3: 7257794604610476285284851391
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 33552962787828955461684428973,
                limb1: 289899194144243075040383678,
                limb2: 39498490761827727571038013343,
                limb3: 7176887415254611072938782604
            },
            x1: u384 {
                limb0: 41238180883792243091342155047,
                limb1: 39041080030316788776670332645,
                limb2: 9628190053693352803227367454,
                limb3: 3502107492795376094927331306
            },
            y0: u384 {
                limb0: 58346786067511716965128573874,
                limb1: 32709912215702209009185599799,
                limb2: 73849051364840042609480101761,
                limb3: 5916077668139205664455025178
            },
            y1: u384 {
                limb0: 13586913276400053897929481047,
                limb1: 77791958441834265347198497054,
                limb2: 13878849068541634317271637819,
                limb3: 7353540119403550382345759790
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 43754069954388239584719971286,
            limb1: 63350849922442070516538313031,
            limb2: 55253096624037056557217462851,
            limb3: 5458750726474743904195467181
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 47724643563232300292876266348,
            limb1: 16031841888916154700440824015,
            limb2: 39657889938248000409928637826,
            limb3: 1038197336319072443931100890
        };

        let ci_plus_one: u384 = u384 {
            limb0: 60988524963784831516809138641,
            limb1: 31862403368334053869129654035,
            limb2: 61347443955292173728670355212,
            limb3: 2494409620579144666359959227
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
            limb0: 14454689829351116072134801828,
            limb1: 78759557729622088513820178464,
            limb2: 24460579687512179227318865526,
            limb3: 2285899098753378325199941760
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 1716528238342883776339619401,
            limb1: 12356345320086183676586310510,
            limb2: 37998904945074056288888344638,
            limb3: 826165966821634221464184085
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 63812040960298775403466292699,
                limb1: 13735601558832440022514320166,
                limb2: 70998201499523483505092712280,
                limb3: 2090759183394077640028735149
            },
            x1: u384 {
                limb0: 17842324039176315991122397956,
                limb1: 48652763046060764972600931104,
                limb2: 33189400860005616984170125877,
                limb3: 557581759227700426906009228
            },
            y0: u384 {
                limb0: 42317664355513929731310372329,
                limb1: 28534937478219201128841366738,
                limb2: 16750897851707481478737388220,
                limb3: 7303877582345229464448773559
            },
            y1: u384 {
                limb0: 46909156434398527273290216972,
                limb1: 423038672330560568741823094,
                limb2: 39557733071457947917374316405,
                limb3: 4963372096402665195418909440
            }
        };

        let Q_or_Qneg_0: G2Point = G2Point {
            x0: u384 {
                limb0: 48445588494706530723777876215,
                limb1: 18019304796318080556279150925,
                limb2: 63517167963993611907021877986,
                limb3: 421162466524909900785915189
            },
            x1: u384 {
                limb0: 57785888476184267814048913659,
                limb1: 50382711582570768689470883112,
                limb2: 78616245268791062365750572308,
                limb3: 1845713742838411979879081830
            },
            y0: u384 {
                limb0: 27393912370547270113154843726,
                limb1: 40547504210301365256082058313,
                limb2: 5334319328153273372646397164,
                limb3: 5933087639331459606572376355
            },
            y1: u384 {
                limb0: 57578824581472105163490662369,
                limb1: 1175543731062062093430564300,
                limb2: 10261508349983793805928484901,
                limb3: 4571338167451366303459940898
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 10553850492366303173615987087,
            limb1: 76216902431453819572779389229,
            limb2: 53128998782492959282133071233,
            limb3: 884315398324497059481484883
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 16994457071576410906610043784,
            limb1: 12671686908327368871024692691,
            limb2: 22045787647512778747935420619,
            limb3: 4604950007657616354628525290
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 53336505614356896682848246392,
                limb1: 72366345031288823765163126302,
                limb2: 21749609983445654032051779549,
                limb3: 7261963587051738919308172329
            },
            x1: u384 {
                limb0: 68630432347544568266431477362,
                limb1: 4330734888040178645071264948,
                limb2: 12875422857643560100825987829,
                limb3: 3696210125269533410132764003
            },
            y0: u384 {
                limb0: 64230442693667611472747013364,
                limb1: 18949033884198649257010777613,
                limb2: 77078372468164437681992834831,
                limb3: 6210902167122460165026238456
            },
            y1: u384 {
                limb0: 21067684933072738352748184032,
                limb1: 55162310761075644381761812898,
                limb2: 20552329839645978197147060454,
                limb3: 2384699152832620986215339152
            }
        };

        let Q_or_Qneg_1: G2Point = G2Point {
            x0: u384 {
                limb0: 69744308489355343009011031680,
                limb1: 78276809476379431828584364792,
                limb2: 25421273179724382640807742666,
                limb3: 629332363893194702724242147
            },
            x1: u384 {
                limb0: 9077585745323353651113955592,
                limb1: 28801061112021383577447956867,
                limb2: 9105103064300810208305129179,
                limb3: 1798386197310028193798726885
            },
            y0: u384 {
                limb0: 53834910180802468499366280294,
                limb1: 28754559101201230030764847602,
                limb2: 17967099487866863327467040612,
                limb3: 3158624751975132178053277673
            },
            y1: u384 {
                limb0: 33198040167565188028146666337,
                limb1: 73700832140940917994986570501,
                limb2: 66081209531009233988334580996,
                limb3: 5872002828490787399876989862
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 47468425175971097337373985443,
            limb1: 28807615511803665251097717034,
            limb2: 72125375599547252760680059759,
            limb3: 6942269568488219344950079283
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 34833879385875259710675708996,
            limb1: 35850984696865657168450227647,
            limb2: 51512210514675007787899416982,
            limb3: 6711142208545727339012346595
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 52517770384567095716379708876,
                limb1: 10426568963990827648286936293,
                limb2: 73575184961942115375421479689,
                limb3: 4564989597830912894329253944
            },
            x1: u384 {
                limb0: 4835878655583572187039789486,
                limb1: 45928657993977151826719713570,
                limb2: 23169209875697424541700676410,
                limb3: 7036934315505425410413129206
            },
            y0: u384 {
                limb0: 70527640951350717131886313147,
                limb1: 8967572263911713061376719077,
                limb2: 32604422014688996097420735298,
                limb3: 6632073968278743126005515285
            },
            y1: u384 {
                limb0: 46044213591418091423620492848,
                limb1: 76928589039152883416383957610,
                limb2: 61228132501615218685111852851,
                limb3: 4648575281754311653148124060
            }
        };

        let Q_or_Qneg_2: G2Point = G2Point {
            x0: u384 {
                limb0: 74785828218095172669530860093,
                limb1: 58201448657620473559698463887,
                limb2: 53785390717136751320806174439,
                limb3: 354692878285165878960072151
            },
            x1: u384 {
                limb0: 45290662914676220501737387734,
                limb1: 8184883731102392918707676957,
                limb2: 1562342200442521446348722055,
                limb3: 4036278542917621461513753754
            },
            y0: u384 {
                limb0: 17299920296087035216658881619,
                limb1: 36523711200768638570639409888,
                limb2: 55923584175263022156470505261,
                limb3: 4414463732780112332972415754
            },
            y1: u384 {
                limb0: 25651857055553133538474268028,
                limb1: 40630456684683662441024087699,
                limb2: 55600449248268813605320105452,
                limb3: 1939677616245515303819298314
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 46557635626576675460769661604,
            limb1: 49720811448954604970006067416,
            limb2: 77208734762162560413889605600,
            limb3: 3315452289985898780760730478
        };

        let f_i_of_z: u384 = u384 {
            limb0: 31431249854717413110463840676,
            limb1: 63934418722419798225544745353,
            limb2: 67644951910423101776283794827,
            limb3: 5300389117457602808408857487
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 8273905499682469385299419912,
                limb1: 28315457049920191994324428062,
                limb2: 29081222522156640314250691403,
                limb3: 7609388752594630235315146712
            },
            w1: u384 {
                limb0: 64802315518375623762432022214,
                limb1: 32601161953173324598585345260,
                limb2: 560422807335113413781922333,
                limb3: 4531666863617654518816666192
            },
            w2: u384 {
                limb0: 7326219856290449920067960699,
                limb1: 29726985315263812606159607970,
                limb2: 33156876503975941201673369847,
                limb3: 4210121993451966383543885675
            },
            w3: u384 {
                limb0: 74079489917311338989808302058,
                limb1: 70769882259780109135845229440,
                limb2: 50973871992181589814571987205,
                limb3: 3151667129159933774211379093
            },
            w4: u384 {
                limb0: 16403612491907960754591093038,
                limb1: 5911444533694328207857217781,
                limb2: 73817454988641032735487198683,
                limb3: 1583560287621109251792606760
            },
            w5: u384 {
                limb0: 51421265295014291580234603089,
                limb1: 552828692925557346971702087,
                limb2: 38496386985597789721551924062,
                limb3: 657414964215336384877306886
            },
            w6: u384 {
                limb0: 66834946142963619185358796500,
                limb1: 21208053827986969099740302041,
                limb2: 74976186114757178244511873107,
                limb3: 1390123685456129995741901119
            },
            w7: u384 {
                limb0: 66230644264750654148277112483,
                limb1: 27002408003556345776298419661,
                limb2: 14654693272098065698952258706,
                limb3: 3995387849613544928493322811
            },
            w8: u384 {
                limb0: 23439422147536678857946186008,
                limb1: 38172293765231310010933295702,
                limb2: 14060990187230503937887085765,
                limb3: 2072870767198236141434892678
            },
            w9: u384 {
                limb0: 33235040705264855724460704753,
                limb1: 64386510939362339600476334130,
                limb2: 4886837293144413864990088485,
                limb3: 7840065915352450861335704803
            },
            w10: u384 {
                limb0: 7407666857510714772564114008,
                limb1: 68062314176884212330641092513,
                limb2: 51468691690351352234484794813,
                limb3: 6175993035101935971930202930
            },
            w11: u384 {
                limb0: 27042747746641356892763719199,
                limb1: 51238683893932060873599964775,
                limb2: 8834301925303865925890568141,
                limb3: 4425888819771461779548778747
            }
        };

        let c_or_cinv_of_z: u384 = u384 {
            limb0: 32673940628352978930730917159,
            limb1: 31555748483907410857920868726,
            limb2: 50515659991227946663030782166,
            limb3: 7668856969752940484122730370
        };

        let z: u384 = u384 {
            limb0: 32079148735126304612101011070,
            limb1: 4254465290740283508417425338,
            limb2: 367478373635187865,
            limb3: 0
        };

        let ci: u384 = u384 {
            limb0: 35773541342483668874580110925,
            limb1: 61221886949754362469845386098,
            limb2: 46613988527903909403233710286,
            limb3: 6451935985259656803892167468
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
                limb0: 40149905552397261085393337903,
                limb1: 57704479453406200471917837627,
                limb2: 28009283156426851578200703283,
                limb3: 2569949162883398021693559475
            },
            x1: u384 {
                limb0: 13098617939632519364038605063,
                limb1: 12743810375333441605409464956,
                limb2: 23556475542780728037473473486,
                limb3: 3140556539973953559655641866
            },
            y0: u384 {
                limb0: 16592722872332139815522989723,
                limb1: 50274580246191855345848479859,
                limb2: 35804123707871180631871336372,
                limb3: 1902411200336832733398636917
            },
            y1: u384 {
                limb0: 72071785749158476841565818935,
                limb1: 67411284337898348795291754195,
                limb2: 79101405471150140879853182634,
                limb3: 7481442105714627249358307304
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 66915298484147677244567444372,
                limb1: 38410135504828009469280472848,
                limb2: 28910674689930505107100333102,
                limb3: 674608301620579523715569154
            },
            x1: u384 {
                limb0: 76561883140538758992075473594,
                limb1: 61928325450721596290458925143,
                limb2: 70852348343696419622508245235,
                limb3: 4195370574579735919926364759
            },
            y0: u384 {
                limb0: 52441805693187725274002312614,
                limb1: 76393119674310301633904029527,
                limb2: 3529894638312655675573686915,
                limb3: 7895888023852160265550630636
            },
            y1: u384 {
                limb0: 26330032431622342325558581185,
                limb1: 19180333726099103287508727075,
                limb2: 29146557696394040534073410021,
                limb3: 5186519350655441532321440375
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 40318316499939300335991561367,
                limb1: 10020067537950356636285991866,
                limb2: 5353497619597619065559853984,
                limb3: 2271638777901392576594338012
            },
            x1: u384 {
                limb0: 23928362011646961310966145882,
                limb1: 56968651474418057573634100472,
                limb2: 62975485587303844287913291223,
                limb3: 5913105156252172918539564065
            },
            y0: u384 {
                limb0: 22203984371268922859741758979,
                limb1: 45119107169348338468415360474,
                limb2: 57098190927341451378538317858,
                limb3: 6563035793597197163731270809
            },
            y1: u384 {
                limb0: 38249422232001246599565892037,
                limb1: 8617979378320315718307470700,
                limb2: 65353868317278215061315610686,
                limb3: 412498783174258861335736845
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 19736288436507508048503453697,
            limb1: 71144083822294788427174029842,
            limb2: 28482662591295371727235449900,
            limb3: 4311473328299140253961535794
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 16766380736641168458122793836,
            limb1: 75443533302623545270167820630,
            limb2: 67020460225630026250980599791,
            limb3: 7292800955520465047504485704
        };

        let ci_plus_one: u384 = u384 {
            limb0: 16606090038639555547711100892,
            limb1: 76382847240035079955909184834,
            limb2: 24627674983581790089912167861,
            limb3: 4578221553500017261239202805
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
                limb0: 38588574116873990392796570194,
                limb1: 69013258730967681718418100913,
                limb2: 39875379816853053409463494903,
                limb3: 2014569215500031603482632456
            },
            w1: u384 {
                limb0: 42634866079719415855442553587,
                limb1: 14191802145205861488279928314,
                limb2: 26359133103912083747617257624,
                limb3: 1921151016903545744774132827
            },
            w2: u384 {
                limb0: 40723851430392775900375921650,
                limb1: 4333493233285079384689943341,
                limb2: 20331612504552931502475658858,
                limb3: 2667864076601633044279115338
            },
            w3: u384 {
                limb0: 42731065345319909507990910459,
                limb1: 46592987788193785647980576638,
                limb2: 74507099065578186686200915367,
                limb3: 6556981620997058046271398189
            },
            w4: u384 {
                limb0: 46276960512068032901654177702,
                limb1: 2973477235711544995434689409,
                limb2: 39365110877136828239157406319,
                limb3: 3082232781419238908370309166
            },
            w5: u384 {
                limb0: 69591957077637491297256717036,
                limb1: 56778357815360239857271569736,
                limb2: 53944034924439362490565592452,
                limb3: 7927098045462716761330234660
            },
            w6: u384 {
                limb0: 17479897529864896052527290987,
                limb1: 22158678476011203087177515172,
                limb2: 24248704288490970133784740316,
                limb3: 1907949936272813117835570380
            },
            w7: u384 {
                limb0: 10697416587478527682599914635,
                limb1: 62299702070065394794010155223,
                limb2: 40568078573791093930037148771,
                limb3: 4263012427525334954359269862
            },
            w8: u384 {
                limb0: 78541242829580449002907795874,
                limb1: 51394441849552013319859728493,
                limb2: 53756980799654681466117563020,
                limb3: 4283182594389998470265367333
            },
            w9: u384 {
                limb0: 32397626586980623613638821045,
                limb1: 70769245802489391874760624902,
                limb2: 20244909204248824236559733792,
                limb3: 7371826116266658476584073504
            },
            w10: u384 {
                limb0: 38156957810112486398796418665,
                limb1: 3726517452033591794456039780,
                limb2: 47329841181557617262757398594,
                limb3: 275096076223046614456633333
            },
            w11: u384 {
                limb0: 19967121300182212854770400504,
                limb1: 5454934691710506410086988049,
                limb2: 21610730429476256535972784024,
                limb3: 221256962413239040130597286
            }
        };

        let c_n_minus_2: u384 = u384 {
            limb0: 67131678420389703515591524730,
            limb1: 30040485463505841433446870034,
            limb2: 26202072137171791964254339977,
            limb3: 6869000167228138645172769687
        };

        let w_of_z: u384 = u384 {
            limb0: 62065827301002633054856058158,
            limb1: 68854153974020208167368828758,
            limb2: 65235965047666334768245797602,
            limb3: 3110405488271654730244603381
        };

        let z: u384 = u384 {
            limb0: 42379037134471671700458811037,
            limb1: 11723926143404111478039766849,
            limb2: 7727198675667668899874904562,
            limb3: 2797422687880055628748334026
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 66902295561826737314231949558,
            limb1: 62345041449024276244848427800,
            limb2: 42365023392636228509475221793,
            limb3: 4954559886876816457627409538
        };

        let previous_lhs: u384 = u384 {
            limb0: 53817987821968998031367389234,
            limb1: 45365357224723959383132384831,
            limb2: 5356862495539662669209108149,
            limb3: 4879850051523771519059663203
        };

        let R_n_minus_2_of_z: u384 = u384 {
            limb0: 11664463771775002593510079402,
            limb1: 20280626705334552412557966477,
            limb2: 10068975284019657308803504537,
            limb3: 2370677483840252492829215731
        };

        let Q: Array<u384> = array![
            u384 {
                limb0: 27029109764466074161914061883,
                limb1: 17566124264780973019732239371,
                limb2: 59841352180967583532573004016,
                limb3: 449765352048913120923432427
            },
            u384 {
                limb0: 40762450305358762718807071076,
                limb1: 43129633504330056088575537031,
                limb2: 29545666416892304397782689102,
                limb3: 4642585650196805146968782706
            },
            u384 {
                limb0: 65081967676105365077018718621,
                limb1: 30447570396625313636698170966,
                limb2: 74434119663341934199227922404,
                limb3: 5110184431485773908071812062
            },
            u384 {
                limb0: 62691861162234392713228166095,
                limb1: 67835234441393408381612115584,
                limb2: 25042155360383839391044215231,
                limb3: 7583007256943671555272123447
            },
            u384 {
                limb0: 66138402258027421361551098108,
                limb1: 42255363964890334130998164173,
                limb2: 36421469798985398079655318701,
                limb3: 7396646136708672202674898652
            },
            u384 {
                limb0: 2058866177580385129884288892,
                limb1: 15607365427928564981346334308,
                limb2: 26978794437919531919773272210,
                limb3: 4764418414406476984936509996
            },
            u384 {
                limb0: 61832520036472145277232939969,
                limb1: 48963354884880073607443666939,
                limb2: 46669290645642779158822189198,
                limb3: 4271008206054784543982677236
            },
            u384 {
                limb0: 6270718960932422865326057891,
                limb1: 52158524634223087884882693796,
                limb2: 30428922765290345703120630445,
                limb3: 3188697352227321344878727531
            },
            u384 {
                limb0: 60507856344536609124780807638,
                limb1: 21642134225689185538616812135,
                limb2: 77330864065419510808307610615,
                limb3: 7809272166338306590076492246
            },
            u384 {
                limb0: 4450006418516313371845985500,
                limb1: 77983522784988272354940295232,
                limb2: 68127446301765899157753641606,
                limb3: 1332773917366252550380811102
            },
            u384 {
                limb0: 48845228857425658569182524468,
                limb1: 29868519819868335757898398549,
                limb2: 64718396587408239025482495342,
                limb3: 799824631525537627385406408
            },
            u384 {
                limb0: 74143435269660449989207540472,
                limb1: 77308579932416032305772558040,
                limb2: 66873740938275180216898374912,
                limb3: 3260681451575239422436962376
            },
            u384 {
                limb0: 69937191768296076260082540361,
                limb1: 70204365992116897313084359340,
                limb2: 51299849887506310155472760914,
                limb3: 6230797498228847785320707155
            },
            u384 {
                limb0: 41899909497951011879915032535,
                limb1: 24640977437282958112713872404,
                limb2: 35273834964979092657205784866,
                limb3: 4369847501272970538195882100
            },
            u384 {
                limb0: 21791338091729104327916654758,
                limb1: 54808044953279052078786707640,
                limb2: 78824316786292861693048202078,
                limb3: 8040812271064816500307630799
            },
            u384 {
                limb0: 49106292948060166586382849962,
                limb1: 47174217664602113413047947096,
                limb2: 75866338379947741989876418105,
                limb3: 1734141475560888575848530268
            },
            u384 {
                limb0: 52821950256408135340204194912,
                limb1: 19124534391285995845552544038,
                limb2: 74680365594472667242880106763,
                limb3: 5803329304484466339567518872
            },
            u384 {
                limb0: 46334601073158590730596874670,
                limb1: 5037674667895983860971545698,
                limb2: 15213048635583359874874614992,
                limb3: 2151664128959861630901647146
            },
            u384 {
                limb0: 41810622021000946800309451379,
                limb1: 6495553437254272906654511976,
                limb2: 6979789769686907418025602412,
                limb3: 7866197051908250483507576455
            },
            u384 {
                limb0: 40474602132415789707445736725,
                limb1: 5928300112428972997197428812,
                limb2: 23294437312437702037920905080,
                limb3: 357297452493630667104991394
            },
            u384 {
                limb0: 13449654637979585984947069858,
                limb1: 75498308419559054405742110964,
                limb2: 13593361773021016543080375734,
                limb3: 4218854093094895181784156454
            },
            u384 {
                limb0: 51526504946694515100502184095,
                limb1: 19321544861610132247177626261,
                limb2: 32893538444676154108545046550,
                limb3: 5841796272589197987376686508
            },
            u384 {
                limb0: 35951990984270662709300261723,
                limb1: 55027382110860319229405491616,
                limb2: 14129670892521484628913291022,
                limb3: 7078108820246868506522303937
            },
            u384 {
                limb0: 73794422543461544059073406675,
                limb1: 38103754953415854187067193063,
                limb2: 69774541597452851039558088205,
                limb3: 504699239035672861113641941
            },
            u384 {
                limb0: 334195598469803759631807896,
                limb1: 79149564244987801647617347880,
                limb2: 54504075603420241191644958647,
                limb3: 6021768682997307898122534832
            },
            u384 {
                limb0: 55833751754177992324530496239,
                limb1: 4269450861634727464874790976,
                limb2: 39101190862914588852208887250,
                limb3: 1210996505886499131512153724
            },
            u384 {
                limb0: 16647210878829647487578090095,
                limb1: 9481415501109302107772184572,
                limb2: 17682689941884105058559587113,
                limb3: 1887519344802989915678012560
            },
            u384 {
                limb0: 70690657698781592992908775275,
                limb1: 16147726492873210962372200644,
                limb2: 352772708258291043936239213,
                limb3: 3626082721552694815092239660
            },
            u384 {
                limb0: 24363381031386005418742714466,
                limb1: 2650075804368082142913244639,
                limb2: 70321674502752391421160998239,
                limb3: 3359742955011736737740262875
            },
            u384 {
                limb0: 23231591599599942513070121307,
                limb1: 4685600888390620095451417955,
                limb2: 3986063898718691899498444248,
                limb3: 661060557955865235549157575
            },
            u384 {
                limb0: 8801743645580361392840030631,
                limb1: 9434328338864023636315939464,
                limb2: 68198000579574092126836288840,
                limb3: 6082257651394682041567364028
            },
            u384 {
                limb0: 34948395329022275081928784312,
                limb1: 48103902710553211506660024351,
                limb2: 40341219490369543608284367831,
                limb3: 7986122274959916484165252288
            },
            u384 {
                limb0: 72209267985644234116530878173,
                limb1: 47419784256979066200149023991,
                limb2: 24989287317098139211558689958,
                limb3: 1182053970985815152130059560
            },
            u384 {
                limb0: 37541583992207732888548884121,
                limb1: 47704284507780072057849917726,
                limb2: 17212836793305178092780226487,
                limb3: 2554456314034605818632202394
            },
            u384 {
                limb0: 71485745866039696548602755730,
                limb1: 17630770573583039507931956663,
                limb2: 53759698713812657864614838151,
                limb3: 4324276145263574886117213509
            },
            u384 {
                limb0: 23967739973764583794639340361,
                limb1: 17366210884561431973419457552,
                limb2: 33234899749610099984051139692,
                limb3: 3882845409460933834732912494
            },
            u384 {
                limb0: 58766706504909912492887120763,
                limb1: 49995136988160536144712934912,
                limb2: 44589216679228492429941122195,
                limb3: 6527479760885863980966095770
            },
            u384 {
                limb0: 1569418617559133317336439657,
                limb1: 5417874048450218105438708835,
                limb2: 32253472794818883727150001667,
                limb3: 7116995150755585725049110662
            },
            u384 {
                limb0: 34517052941146905300776408661,
                limb1: 68687250561574618959505138758,
                limb2: 38932927316722506040174481449,
                limb3: 3032088701609944337525443334
            },
            u384 {
                limb0: 76645324346919946379882232909,
                limb1: 22055863090958181729182360701,
                limb2: 12226051070531629519682620863,
                limb3: 164497698886253109310927712
            },
            u384 {
                limb0: 31778058980521967208788306074,
                limb1: 60902529493893002870060175048,
                limb2: 30402882789381277882334829607,
                limb3: 6507368507646601052117082126
            },
            u384 {
                limb0: 45021271916485542195312926398,
                limb1: 45180073505807603865959948049,
                limb2: 74752494371793133670778993840,
                limb3: 1091763936481394429688787696
            },
            u384 {
                limb0: 22706188705599173291939387592,
                limb1: 52097115174776407531349536510,
                limb2: 46061075952944171288392013772,
                limb3: 4008061541529944690114190184
            },
            u384 {
                limb0: 51851007154789721740105408601,
                limb1: 70569241736727500237095879367,
                limb2: 24054673483004299230140275643,
                limb3: 6112870179455909121710241056
            },
            u384 {
                limb0: 16214891517560111787607808658,
                limb1: 22513337084653553482389797820,
                limb2: 1051603799545214942463231869,
                limb3: 6689128408135135334485298626
            },
            u384 {
                limb0: 7718610733794530277258396315,
                limb1: 59537507960211503635542188042,
                limb2: 30282162430441817130103689370,
                limb3: 7165512544128988785099522931
            },
            u384 {
                limb0: 66052842792560225080141561243,
                limb1: 16656523068431807061404180345,
                limb2: 71112728765418210011805676740,
                limb3: 1011633852991179172080355983
            },
            u384 {
                limb0: 55498676092974534850730672730,
                limb1: 51470462774654767051178968356,
                limb2: 32849644712072285407176208955,
                limb3: 2175138117596334386120992702
            },
            u384 {
                limb0: 76745288543308615856134894259,
                limb1: 29271508425593837980937276134,
                limb2: 26898213457177190176214663972,
                limb3: 3392315195845687669399369592
            },
            u384 {
                limb0: 70378180797324508947711707316,
                limb1: 50603889576152012647487034230,
                limb2: 22317063557687945132426570941,
                limb3: 4086277407912697692298296804
            },
            u384 {
                limb0: 22551345585202666179968053658,
                limb1: 75000073497690600571224607586,
                limb2: 745007214930584846243435225,
                limb3: 3302183078113681408216957178
            },
            u384 {
                limb0: 18056620306752645308847082046,
                limb1: 8429368851827510059640702309,
                limb2: 37095849566146804419915458570,
                limb3: 7869950203892144445847219752
            },
            u384 {
                limb0: 74518230896045036241223084160,
                limb1: 14693233287242345706263479586,
                limb2: 9301701888653202319081025546,
                limb3: 2695274149255536619170932281
            },
            u384 {
                limb0: 73634770802074893811193869568,
                limb1: 77713009276802612465671458129,
                limb2: 29623329449053393002312923258,
                limb3: 2682867690344858108660820406
            },
            u384 {
                limb0: 65812577107476878669494467837,
                limb1: 13846698528716822695906288535,
                limb2: 7793780494806622109201066609,
                limb3: 3828792065664990523416116224
            },
            u384 {
                limb0: 36835514759412486577604808167,
                limb1: 53143883275770738517288833203,
                limb2: 66678091589563078736267394632,
                limb3: 2410672490335795250877694546
            },
            u384 {
                limb0: 15006028600601359094874283449,
                limb1: 59934673399736349523713984603,
                limb2: 10813056289901539062646066901,
                limb3: 6886315015432975345590668685
            },
            u384 {
                limb0: 70765418064528293810571213373,
                limb1: 55522169592611389828299884661,
                limb2: 37461105099720676907951327633,
                limb3: 349347724306531451342296888
            },
            u384 {
                limb0: 56905186282749508834722065372,
                limb1: 21835360161871130933396295952,
                limb2: 78015485984433352144913808998,
                limb3: 852872768930012543725314250
            },
            u384 {
                limb0: 78616205224870426004212465152,
                limb1: 75131014308175998536053054063,
                limb2: 42802200156164313483135191673,
                limb3: 4685456918318165658601493555
            },
            u384 {
                limb0: 44976420767058062455995020797,
                limb1: 6577628164896160848822250464,
                limb2: 76290333999707849875207024230,
                limb3: 2439001475170960665190912204
            },
            u384 {
                limb0: 34958020589096318008271050066,
                limb1: 46795257125796991952003861271,
                limb2: 50932530185003050677229918513,
                limb3: 5360199090159929700817596577
            },
            u384 {
                limb0: 60661655521367959257762413781,
                limb1: 52047300910044509339661185029,
                limb2: 44451508934343266587075922473,
                limb3: 1650710607336644929646190238
            },
            u384 {
                limb0: 26583985279878157258398099897,
                limb1: 38096908503859327190293841058,
                limb2: 7671851315626509649846284923,
                limb3: 4512142649531844734647222400
            },
            u384 {
                limb0: 56368452406734526691513591694,
                limb1: 61539716539844616957263174227,
                limb2: 54738699131498751365443809615,
                limb3: 3089035228827765683585813765
            },
            u384 {
                limb0: 72722230324199226102259952663,
                limb1: 52857515402619398551233225173,
                limb2: 73135132330998690342716108319,
                limb3: 4676392998025225450967870650
            },
            u384 {
                limb0: 1576392498108886882916335461,
                limb1: 61565390004368641719743162313,
                limb2: 45125605841427349480217378417,
                limb3: 3661607407444348557702999626
            },
            u384 {
                limb0: 30259908201284130449396472718,
                limb1: 6313552176542168019235871565,
                limb2: 17857971774353915482396069109,
                limb3: 205263054369531016158352299
            },
            u384 {
                limb0: 1429228658153836640434211637,
                limb1: 26565160771091779349168708665,
                limb2: 23650132616940004394531254282,
                limb3: 1019728911121494133762912718
            },
            u384 {
                limb0: 7772001891971043368440029706,
                limb1: 37128138282440209006899687717,
                limb2: 58241952643744128713684835329,
                limb3: 2519337055291034319341021262
            },
            u384 {
                limb0: 20554537975279290885828870636,
                limb1: 45807165645668505117852133706,
                limb2: 24688482138873578291873220245,
                limb3: 4778222888265080622554236835
            },
            u384 {
                limb0: 55742020795085868609956354699,
                limb1: 52839878776715240929204400799,
                limb2: 10624843039491706463375939480,
                limb3: 1802791730981445457612506555
            },
            u384 {
                limb0: 74677457175180801370425070305,
                limb1: 22297985848000005257008452200,
                limb2: 25099424344204104476796750709,
                limb3: 1949651249305132985574199876
            },
            u384 {
                limb0: 45696520205018690375875202497,
                limb1: 41985169760363983777313474100,
                limb2: 21111741704433430882864702801,
                limb3: 4815019288390536830353076503
            },
            u384 {
                limb0: 2962844917739936582619614221,
                limb1: 91117103022928286016046195,
                limb2: 7505093961257095458185572803,
                limb3: 491731825735194741140424813
            },
            u384 {
                limb0: 39230375771187169433388037650,
                limb1: 15570157314324109614568682780,
                limb2: 56718481688844325076634607758,
                limb3: 4225127535146388529324227091
            },
            u384 {
                limb0: 30475779598681387648564839684,
                limb1: 66609480899418056152776223760,
                limb2: 60556844135524328760388922446,
                limb3: 4231467275016315759494026863
            },
            u384 {
                limb0: 54233424346723222393634020697,
                limb1: 45501126649058183643984184976,
                limb2: 13413742663214212629998809590,
                limb3: 6154089032636424593347515676
            },
            u384 {
                limb0: 32599616279335727879705545403,
                limb1: 65006685252210800575794996850,
                limb2: 48836251740235796358645355833,
                limb3: 4130955763531180336491113174
            },
            u384 {
                limb0: 32094711269912272232051236417,
                limb1: 33032004750184724471059415938,
                limb2: 74303645185840854257543904614,
                limb3: 4561062078617460853125736327
            },
            u384 {
                limb0: 54270658861820447790497951267,
                limb1: 37715380424025548809607947951,
                limb2: 25724229307507727405653781573,
                limb3: 7732312061621310164131359193
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
            limb0: 870065953532868937378623247,
            limb1: 67044379915717130443098639844,
            limb2: 27585209399964940917848522235,
            limb3: 1586310955951092471271290583
        };
        assert_eq!(final_check_result, final_check);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_FINALIZE_BLS_3_circuit_BLS12_381() {
        let R_n_minus_1 = E12D {
            w0: u384 {
                limb0: 25692355417549110901646582719,
                limb1: 50220892146756988424597254345,
                limb2: 60288772140751955183276540991,
                limb3: 7547993089602133149678489071
            },
            w1: u384 {
                limb0: 69342166696651803805221189828,
                limb1: 4839114949749985830269133305,
                limb2: 55580806855607249823389598839,
                limb3: 1825970715411622267502422151
            },
            w2: u384 {
                limb0: 58941150559554023411796177478,
                limb1: 6941227221550502975393858743,
                limb2: 45259946626321210044613443576,
                limb3: 3005049393335152484739713001
            },
            w3: u384 {
                limb0: 6691277041523964272119155495,
                limb1: 74775735309872823162937061365,
                limb2: 58356164381531708476570227440,
                limb3: 2315823595494904483561125034
            },
            w4: u384 {
                limb0: 10384140904909513508841763907,
                limb1: 46954451123043549539934977045,
                limb2: 71955500027572674873178915827,
                limb3: 757987862301834967739659094
            },
            w5: u384 {
                limb0: 75640207036055575567643054603,
                limb1: 61793007309582557746537919727,
                limb2: 7198482069852998678801123195,
                limb3: 5176535869935002548514002992
            },
            w6: u384 {
                limb0: 75294419185698092276277554280,
                limb1: 69348173207302386417940588876,
                limb2: 47799031051884987180075008276,
                limb3: 1379017532838957142432355886
            },
            w7: u384 {
                limb0: 38511436340688454093993705705,
                limb1: 52753647817327570873559709996,
                limb2: 71336116753828341273243423972,
                limb3: 4276311597603011713499788681
            },
            w8: u384 {
                limb0: 35933803774757302866850842555,
                limb1: 62084023488174143711694644973,
                limb2: 30584888813107714435961665965,
                limb3: 7782958976976439402655977665
            },
            w9: u384 {
                limb0: 19594948515337091079728201544,
                limb1: 28988864188983423083492397884,
                limb2: 10421998075911325399179374529,
                limb3: 1048678539249457069051772148
            },
            w10: u384 {
                limb0: 55801034649624631107021477086,
                limb1: 76262525049458382114373958025,
                limb2: 29446891620385803413773052552,
                limb3: 4051768362870543403354334512
            },
            w11: u384 {
                limb0: 56441740993467173415479240741,
                limb1: 56493167526553760281611937800,
                limb2: 48641187730251296808444163197,
                limb3: 3496141662668496370719592491
            }
        };

        let c_n_minus_2: u384 = u384 {
            limb0: 55728262696943343216315435049,
            limb1: 52066376254209998231914626426,
            limb2: 10837862639025893175539842782,
            limb3: 2791054229825006796429348377
        };

        let w_of_z: u384 = u384 {
            limb0: 69228945225248362581995933934,
            limb1: 2753376804997583257160069022,
            limb2: 65328631007423396801395271330,
            limb3: 6400019736901635555448295245
        };

        let z: u384 = u384 {
            limb0: 55912232865146288356424089367,
            limb1: 66647700590359170170279742701,
            limb2: 36503647134980173775214092748,
            limb3: 2257647854424618374477349123
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 60628688772931878616593748335,
            limb1: 53458211842170579355180628732,
            limb2: 48766563167164299710908089059,
            limb3: 1425432152299636854680603026
        };

        let previous_lhs: u384 = u384 {
            limb0: 47406652472006612635416123928,
            limb1: 10516918446960408045983478382,
            limb2: 65900325686361460122411073552,
            limb3: 6700783920580359627883005451
        };

        let R_n_minus_2_of_z: u384 = u384 {
            limb0: 16717249003565328805429819175,
            limb1: 61665272489545425716732891791,
            limb2: 42844215119073943564700067264,
            limb3: 4587273251639631555640776012
        };

        let Q: Array<u384> = array![
            u384 {
                limb0: 61073202043818587133062758700,
                limb1: 67691796947265535994800516392,
                limb2: 10887191419878148382329775772,
                limb3: 1345176343547479166242795730
            },
            u384 {
                limb0: 74313524284083269806698678734,
                limb1: 27945659866898425491641461577,
                limb2: 52207215575654309148536878743,
                limb3: 1957899140533751425511356256
            },
            u384 {
                limb0: 58446651428588844339375925813,
                limb1: 73794131743597715331202080,
                limb2: 32788905649732793473622803941,
                limb3: 2053179085897001048094006194
            },
            u384 {
                limb0: 18569164808621399343054347066,
                limb1: 37879920035449590175964617412,
                limb2: 43376772341296084165351755497,
                limb3: 3877021049476416002980352039
            },
            u384 {
                limb0: 38391214514905195952683498004,
                limb1: 1362160853547496751383211778,
                limb2: 137725829862300119041954349,
                limb3: 3058817763601297343920594166
            },
            u384 {
                limb0: 64139627282000889732520600194,
                limb1: 47328394917587960003216169981,
                limb2: 16242976179498418235582158424,
                limb3: 2716665010616496158703751657
            },
            u384 {
                limb0: 48090665927620186588187899433,
                limb1: 46346050658450664104904051699,
                limb2: 37756275252366897842697210153,
                limb3: 7351814313945754503952153747
            },
            u384 {
                limb0: 65526128631192641108081275829,
                limb1: 51108238290555743453321064698,
                limb2: 71111413046182086808013181613,
                limb3: 2569101193583107002242067453
            },
            u384 {
                limb0: 4756007446086287998490880011,
                limb1: 2669289834236186747570390207,
                limb2: 431455349236542418123055506,
                limb3: 3475258514452974513640326012
            },
            u384 {
                limb0: 77911333330463875867983217364,
                limb1: 60819999035527075805684463926,
                limb2: 14694674833498459708589710636,
                limb3: 5903205231289840300648997367
            },
            u384 {
                limb0: 9803060742479928685143218763,
                limb1: 11058469728902035449657038660,
                limb2: 35596037330304329475155359999,
                limb3: 6437511733539267866822190178
            },
            u384 {
                limb0: 15489773521093418678269338176,
                limb1: 19543725673847685987562558854,
                limb2: 1473544454024930587479741056,
                limb3: 1856818468197765491335261425
            },
            u384 {
                limb0: 2927038546888080412452603167,
                limb1: 77441367501336336589282862481,
                limb2: 46029662847278853727721669016,
                limb3: 6473100248873157149259481694
            },
            u384 {
                limb0: 21422976191115175006463854029,
                limb1: 27016172731773224921821444378,
                limb2: 66438874958081227897424455230,
                limb3: 5211971186986717613506918742
            },
            u384 {
                limb0: 52454908235151948439532043131,
                limb1: 67196250255399755363445647329,
                limb2: 15585585738766555076797559261,
                limb3: 2759541602856429448748284966
            },
            u384 {
                limb0: 30360873436344224240328291398,
                limb1: 74560064412688465201271749352,
                limb2: 62256431128292747557387326479,
                limb3: 7603698800455486721227535958
            },
            u384 {
                limb0: 13729633608223388306850339979,
                limb1: 32153918615608380241626957113,
                limb2: 24100545915324230839289631139,
                limb3: 2613579261550700578298863480
            },
            u384 {
                limb0: 73373288297471771528456598011,
                limb1: 8646171336709831027550459020,
                limb2: 54201945816636104026235961628,
                limb3: 5137027943506767308295730035
            },
            u384 {
                limb0: 25910072207736081531589651447,
                limb1: 47613580703559495182812464931,
                limb2: 59176688870992696980381194448,
                limb3: 2352792380312370559678241916
            },
            u384 {
                limb0: 40625377847554051211794687848,
                limb1: 56309555150900228441026238802,
                limb2: 16523459175396971657448338261,
                limb3: 3406044480451966153574474789
            },
            u384 {
                limb0: 68262812469567572085739292997,
                limb1: 27301883946581413247302425188,
                limb2: 30008385554364830489037983982,
                limb3: 3273273192464943539270875302
            },
            u384 {
                limb0: 32053033364658852529969493870,
                limb1: 18495616947901179258335097484,
                limb2: 55444711139904980435858224443,
                limb3: 2760475910627651416222935145
            },
            u384 {
                limb0: 27067254269038406269563405707,
                limb1: 72212958391055975030976800708,
                limb2: 70733622924906216909614281690,
                limb3: 4830889001790608734657237811
            },
            u384 {
                limb0: 6598156910626475321502916138,
                limb1: 12939195659509401526788123955,
                limb2: 25773531279050407613580303518,
                limb3: 3375262338692043008650107659
            },
            u384 {
                limb0: 47226467657298303411443117,
                limb1: 38107736080695166325732004371,
                limb2: 19265608464951493925441719374,
                limb3: 2286365620906038456035503669
            },
            u384 {
                limb0: 2443698108737622430569120326,
                limb1: 61047330553137252378087501185,
                limb2: 141502420910561654226241765,
                limb3: 3841438190446097504874729629
            },
            u384 {
                limb0: 54418748870383303394563882440,
                limb1: 65847368572270400635655805659,
                limb2: 69464280534676032419994195397,
                limb3: 269467775594240023194660313
            },
            u384 {
                limb0: 33488973427637373112598307469,
                limb1: 5110088020272894063456287220,
                limb2: 53636484022663668209975487325,
                limb3: 3345286048562445000643863077
            },
            u384 {
                limb0: 71402729831051960022958789216,
                limb1: 48892116270658859643649380573,
                limb2: 55191701100103344604313468724,
                limb3: 2356491892774991612243135383
            },
            u384 {
                limb0: 42321390774533748835929154129,
                limb1: 62102222650638372857229717440,
                limb2: 61848124502124622604733842660,
                limb3: 6095177469505221731686594459
            },
            u384 {
                limb0: 79069949946701223435385718754,
                limb1: 64995744170704478988881645184,
                limb2: 31856562955736472173405715457,
                limb3: 5898135204919462491298571572
            },
            u384 {
                limb0: 62776698776738970231944213748,
                limb1: 12691054048174824881615050452,
                limb2: 16482106156017854929287579066,
                limb3: 4673535006513413340139987509
            },
            u384 {
                limb0: 33052456600191982767242220293,
                limb1: 58520095821299497652564221037,
                limb2: 73926098170719915134122481913,
                limb3: 6430236531651067115476418355
            },
            u384 {
                limb0: 38264982501671486661177071701,
                limb1: 65261303476750415664012159567,
                limb2: 69988148794680050502306625089,
                limb3: 4818870567133329126088923702
            },
            u384 {
                limb0: 15968475439207864323712152554,
                limb1: 3908999041672246436619194480,
                limb2: 70420732835052868175121470780,
                limb3: 5222978472646080432657617917
            },
            u384 {
                limb0: 77385356695647580477584212640,
                limb1: 24853822489043390814719421839,
                limb2: 66541368384682238303908761455,
                limb3: 2802099651898278019378300681
            },
            u384 {
                limb0: 20064406501945637066680712135,
                limb1: 12857810260663246545562282039,
                limb2: 8788960143186989644943717477,
                limb3: 917985865295109274393033464
            },
            u384 {
                limb0: 17543477664942652792541702646,
                limb1: 35095884071609768363756153182,
                limb2: 49541450673748510485568169315,
                limb3: 5169351577872824417247783642
            },
            u384 {
                limb0: 14824777165173269366173068001,
                limb1: 10354783414876108801516345158,
                limb2: 44213889333696942873394942892,
                limb3: 3562934604448653337723011457
            },
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
            limb0: 11084033048630483515319647844,
            limb1: 18658859407767613834768243985,
            limb2: 63700007113285529425036776896,
            limb3: 7936455745568186535822144696
        };
        assert_eq!(final_check_result, final_check);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_INIT_BIT_2_circuit_BLS12_381() {
        let yInv_0: u384 = u384 {
            limb0: 71229928116029751491267650142,
            limb1: 857474623136561614114968050,
            limb2: 7511493382068605140480809529,
            limb3: 2961359566146049437330946264
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 47636229997997478076745353769,
            limb1: 46065232159682426941640914865,
            limb2: 10367199767046453762965396210,
            limb3: 4040676806223585621953627787
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 33816562806368889200105415760,
                limb1: 68835230102165628254994269218,
                limb2: 39768608117153179695588535183,
                limb3: 6991806490576155988831491875
            },
            x1: u384 {
                limb0: 68335086197766500578924141776,
                limb1: 7080754119519026799088112876,
                limb2: 30690494996784481629090430717,
                limb3: 2239828120052540390737024042
            },
            y0: u384 {
                limb0: 62288588480645815265749668032,
                limb1: 22070008432295042125533059769,
                limb2: 17258770374775703929866469498,
                limb3: 3893434246093546225728428761
            },
            y1: u384 {
                limb0: 73749392390374487755538404285,
                limb1: 14239437759177320815794920545,
                limb2: 58989038600047800467479483963,
                limb3: 2204262708921513677802847254
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 69478243588243592592734174290,
            limb1: 62602810233549785910400617940,
            limb2: 39705691397676023882470725725,
            limb3: 2115029803169338742380356604
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 70431686682176656374113453728,
            limb1: 26594083728512286214816787800,
            limb2: 31267534062425011200454505894,
            limb3: 2518797584560127818209663539
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 60876613424475892181789327408,
                limb1: 67978190707414898874943920584,
                limb2: 79140045045518589331046153688,
                limb3: 6999986472633837468946007486
            },
            x1: u384 {
                limb0: 43427586477787590506480339289,
                limb1: 77045049673160212741542545110,
                limb2: 66047139518816102344766313487,
                limb3: 6961207303644275099651863671
            },
            y0: u384 {
                limb0: 38204778490747344268478285881,
                limb1: 14671959117177148061982855471,
                limb2: 14303692641405491302934845041,
                limb3: 6125899468594395265974727264
            },
            y1: u384 {
                limb0: 10451689036205679352967491975,
                limb1: 74666276505845846776071452645,
                limb2: 50721080030314440837084095722,
                limb3: 6712619056648700562911027915
            }
        };

        let R_i = E12D {
            w0: u384 {
                limb0: 24495904893861828463468823627,
                limb1: 23262811303295041992328967642,
                limb2: 44729948640696642053041471874,
                limb3: 3189906525024352687324242130
            },
            w1: u384 {
                limb0: 10359756695097788655316592256,
                limb1: 50506781285178107955266541901,
                limb2: 26092548051688795450859527589,
                limb3: 6606885966612123790400554491
            },
            w2: u384 {
                limb0: 10045085410412559662783231972,
                limb1: 72695268680127034338131283351,
                limb2: 30040273849316403791828559880,
                limb3: 1803555721808479167966733987
            },
            w3: u384 {
                limb0: 6068067813431417781911139579,
                limb1: 1560463100703269964713991804,
                limb2: 29997394189351001937624071325,
                limb3: 4686992871141212267741728681
            },
            w4: u384 {
                limb0: 57162605525600674160305430471,
                limb1: 59646234204899874572322768566,
                limb2: 30976837412110426378400910356,
                limb3: 2059018724097794925257879430
            },
            w5: u384 {
                limb0: 78305329977431642524471905367,
                limb1: 1397209639273066130960635327,
                limb2: 8342012572699699456579891983,
                limb3: 2169467670755113729804530512
            },
            w6: u384 {
                limb0: 47368906824222376721057694458,
                limb1: 42405312227631295266350639723,
                limb2: 49763555058903664501628669623,
                limb3: 1850184390869678786797367590
            },
            w7: u384 {
                limb0: 36327251105521596768028521391,
                limb1: 72015052984559092758857031008,
                limb2: 61122313313534575774785542921,
                limb3: 1799213468183419614305220994
            },
            w8: u384 {
                limb0: 63930484425784814898301785842,
                limb1: 46279410768609044446400170855,
                limb2: 55829645316694726819053022770,
                limb3: 7428012633299857747731102024
            },
            w9: u384 {
                limb0: 64928436138704450384657494189,
                limb1: 10671738562935222965183920755,
                limb2: 60146909863436216691722101572,
                limb3: 6127607124350827299473284288
            },
            w10: u384 {
                limb0: 17598653045701539587563491067,
                limb1: 15640565772137493516349936191,
                limb2: 65396348427266195199815797287,
                limb3: 1017618501338552407747549586
            },
            w11: u384 {
                limb0: 33614885610955586879958568111,
                limb1: 108214728331713988730030954,
                limb2: 63328594477441994584409003566,
                limb3: 1265926085579448692973246113
            }
        };

        let c0: u384 = u384 {
            limb0: 56194485731544036856226605702,
            limb1: 30916152175834837567789641436,
            limb2: 56957035407707225591803882406,
            limb3: 1966158568013073323398747707
        };

        let z: u384 = u384 {
            limb0: 32759116165647246550452428698,
            limb1: 54028367751566454093616369646,
            limb2: 3329312171552834721649780141,
            limb3: 1993946554698577629925768946
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 12926631538356143784401012319,
            limb1: 65463661563962759478166353884,
            limb2: 38872426551901586999500012373,
            limb3: 5514806881225716323971980900
        };

        let (Q0_result, Q1_result, new_lhs_result, f_i_plus_one_of_z_result) =
            run_BLS12_381_MP_CHECK_INIT_BIT_2_circuit(
            yInv_0, xNegOverY_0, Q0, yInv_1, xNegOverY_1, Q1, R_i, c0, z, c_inv_of_z
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 75747436618588800605960212777,
                limb1: 78691532185927417990232751732,
                limb2: 75370796408684182904821015394,
                limb3: 4966767594856391104991781876
            },
            x1: u384 {
                limb0: 36697322920048800410262931921,
                limb1: 234917666721443267876980557,
                limb2: 57429202369022505780530651741,
                limb3: 7639168584293572604181698448
            },
            y0: u384 {
                limb0: 27018324606989475573661769067,
                limb1: 22879507105415534757947661797,
                limb2: 38515199588946914631738878736,
                limb3: 4126853920732415331976021411
            },
            y1: u384 {
                limb0: 75132292665023065429744647749,
                limb1: 70852651799466582419860703888,
                limb2: 53879885596590665235084661004,
                limb3: 5443755110030470246511092815
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 33297241360034632835894308193,
                limb1: 2765451933478108646472225484,
                limb2: 22543983443735751879904562894,
                limb3: 6638131378253552378902224542
            },
            x1: u384 {
                limb0: 7435007734194328142801567109,
                limb1: 68625235334146705516536059254,
                limb2: 45158303394860781964864314846,
                limb3: 4671570450563215077547830748
            },
            y0: u384 {
                limb0: 50123168685948663103099615835,
                limb1: 65238109207497687389088358545,
                limb2: 54472627378742677882772846976,
                limb3: 3022039982330950801618248535
            },
            y1: u384 {
                limb0: 28082677632119936871426650125,
                limb1: 13617309653389842438524440143,
                limb2: 58611873298695255459408276869,
                limb3: 5576207667258120860482785513
            }
        };

        let new_lhs: u384 = u384 {
            limb0: 12125323133328163438881825892,
            limb1: 25959576875021342443193424308,
            limb2: 28579255237627195307168245374,
            limb3: 6350796506653110449441998838
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 492702058117989287478981673,
            limb1: 38492197875264634516870427448,
            limb2: 43552836496998090179802674068,
            limb3: 6865962617998115138398685106
        };
        assert_eq!(Q0_result, Q0);
        assert_eq!(Q1_result, Q1);
        assert_eq!(new_lhs_result, new_lhs);
        assert_eq!(f_i_plus_one_of_z_result, f_i_plus_one_of_z);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_INIT_BIT_3_circuit_BLS12_381() {
        let yInv_0: u384 = u384 {
            limb0: 4770097775408202613726298614,
            limb1: 65356711170806441918163670734,
            limb2: 67121773567956627810137500258,
            limb3: 1552850755817024718190429619
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 55428474144189692934414138923,
            limb1: 75369551036362006272844041515,
            limb2: 40826843806891290759446151185,
            limb3: 2890583372625455025315521346
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 1205473017497294403877964596,
                limb1: 8471924506523091864081378674,
                limb2: 31555812589717190940508567852,
                limb3: 7607684383263716789308039076
            },
            x1: u384 {
                limb0: 13426091741510175793680570178,
                limb1: 45154354915374794085909946092,
                limb2: 56308842284910408205763335448,
                limb3: 6093088355228283856782144437
            },
            y0: u384 {
                limb0: 58713445666322263156418815277,
                limb1: 74746276214903446678538093507,
                limb2: 39193419296139724681910635584,
                limb3: 6475925637769884651866598982
            },
            y1: u384 {
                limb0: 38090739592266857106608325986,
                limb1: 42064710563281711818210331268,
                limb2: 44688163859048601300420371467,
                limb3: 1804086853141607731347060020
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 61817557845088233724216147194,
            limb1: 5959520355003125518265366093,
            limb2: 58806966673822152919454865679,
            limb3: 4612466951508328374680816756
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 76547966973071098123546106224,
            limb1: 33589719896424734475127152794,
            limb2: 38406653639946885891214008423,
            limb3: 2779739172056096802878173167
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 61955748035637406816728039868,
                limb1: 27914106218615944098782334493,
                limb2: 25862284730111757149932940050,
                limb3: 7998312924187195507416301279
            },
            x1: u384 {
                limb0: 74941087918980128938908789388,
                limb1: 19492783777118563395317579736,
                limb2: 28324281772678400732116785525,
                limb3: 5932572519296468558153399916
            },
            y0: u384 {
                limb0: 38888189023354271975799388239,
                limb1: 29267421321292700083319887688,
                limb2: 35214838122493296228512760555,
                limb3: 2429545151362327252104228055
            },
            y1: u384 {
                limb0: 52870205482917261238043415882,
                limb1: 19539161843884275755749785415,
                limb2: 4864659887310997092380711653,
                limb3: 3640840811443597346922040599
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 61940196839971027297595214844,
            limb1: 27371169144827089206524570050,
            limb2: 65826302164642265145632645521,
            limb3: 22224929293812456813468458
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 19237022755753283041609065088,
            limb1: 17457553988590341737373418686,
            limb2: 31887840469783434327429696015,
            limb3: 1517172928172144944819557295
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 25854899460898885650787233284,
                limb1: 2081967893214385807440511003,
                limb2: 58476815032406786116447008241,
                limb3: 5054647114064818233154355084
            },
            x1: u384 {
                limb0: 64870403525479367926719399904,
                limb1: 14209183794877313872851283213,
                limb2: 7785835516899133378960743476,
                limb3: 6963688615925803288979330379
            },
            y0: u384 {
                limb0: 6010777315382417414788238916,
                limb1: 25661143893829999732637838715,
                limb2: 33954297894368285498441199901,
                limb3: 1844525304207748310542796346
            },
            y1: u384 {
                limb0: 12853552346862605560387094699,
                limb1: 56077795959562149168109901065,
                limb2: 690620060427394016465365595,
                limb3: 6246505564478604560991468667
            }
        };

        let R_i = E12D {
            w0: u384 {
                limb0: 24642273999402853913022755326,
                limb1: 73169296312712883653397304083,
                limb2: 6346219433095432629058086055,
                limb3: 8006177228532556230595401643
            },
            w1: u384 {
                limb0: 2735480897806558035658349245,
                limb1: 49817440111728763919066711267,
                limb2: 26434855669541682175005015143,
                limb3: 7817274463830341059880885988
            },
            w2: u384 {
                limb0: 67766670931272214015924170208,
                limb1: 18905707736711567341237780402,
                limb2: 65665678278245564230487965532,
                limb3: 4155902485496629231742006441
            },
            w3: u384 {
                limb0: 4176823034322921389391343080,
                limb1: 21236610352661760528164199192,
                limb2: 61033117013161881310008589809,
                limb3: 2114963840757994053637495384
            },
            w4: u384 {
                limb0: 12018918792705345872382327876,
                limb1: 949621708783023509808561786,
                limb2: 64865675547223113582631362774,
                limb3: 2454691655019566704754000762
            },
            w5: u384 {
                limb0: 64559829717101684322716556746,
                limb1: 51851764728585534598699495735,
                limb2: 55193556375977094693738356428,
                limb3: 5079101205761067400329773063
            },
            w6: u384 {
                limb0: 21233983632060680194830084201,
                limb1: 66937868602768737894161529797,
                limb2: 23593180737582240683692318342,
                limb3: 7871280684051965789058155557
            },
            w7: u384 {
                limb0: 65499079079298573055700308823,
                limb1: 68214940056737955495177147417,
                limb2: 74886781592480052471070928895,
                limb3: 4382223196981980333231907151
            },
            w8: u384 {
                limb0: 2500186062373642764514692670,
                limb1: 53822575846393829717996934825,
                limb2: 62193806805794974587274868149,
                limb3: 5486172329871254484253314367
            },
            w9: u384 {
                limb0: 74542547048876159856876632093,
                limb1: 7525434441202573167713527918,
                limb2: 23417329012954814085252223332,
                limb3: 4623221698974164547838321914
            },
            w10: u384 {
                limb0: 4727877613205019106615922487,
                limb1: 51943150936268307854952050994,
                limb2: 68589446015026991944608198970,
                limb3: 6148481562380381120806863687
            },
            w11: u384 {
                limb0: 46964212793041241742350687968,
                limb1: 2742133200807647006339769254,
                limb2: 30588527328041235124315329773,
                limb3: 4122437450084918606098810435
            }
        };

        let c0: u384 = u384 {
            limb0: 46864733453142587178908769807,
            limb1: 10208840961612396338446583225,
            limb2: 18304675259657465319687797479,
            limb3: 4568144127694510711256082136
        };

        let z: u384 = u384 {
            limb0: 35965895312459884808163407512,
            limb1: 54186242963571708019116304747,
            limb2: 20561464542614745090512265132,
            limb3: 7249495031521092434465897488
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 2863054239074127716361135772,
            limb1: 41505837366794021320001793018,
            limb2: 18842744539419025852740507269,
            limb3: 1122240685411734784271613127
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
                limb0: 48981656995978219835180931823,
                limb1: 18715946391424083115978590878,
                limb2: 50570241173087913492034799902,
                limb3: 3477827845010386367476392261
            },
            x1: u384 {
                limb0: 39287811074121278861302769227,
                limb1: 6753907166111587961093439971,
                limb2: 1246678269411717345576158904,
                limb3: 7947149260568175551770441473
            },
            y0: u384 {
                limb0: 47675699224485933314206180700,
                limb1: 57540337740038727137907651228,
                limb2: 7457267533616698067312048485,
                limb3: 5633268506538923967284457750
            },
            y1: u384 {
                limb0: 76500628088939916734940412098,
                limb1: 75068103830201232121111841379,
                limb2: 4910144763366012958280236759,
                limb3: 5569030770652860932027099876
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 60684323820669795207724667256,
                limb1: 60592549784693318108724639291,
                limb2: 38641979319127349744149712140,
                limb3: 7728923584815330377328388007
            },
            x1: u384 {
                limb0: 31477952066487426930340004491,
                limb1: 557300042180144868010394113,
                limb2: 9380593830978909556149201579,
                limb3: 991529356891870050861453253
            },
            y0: u384 {
                limb0: 64037300101838167009318762122,
                limb1: 9301217767015404696736602732,
                limb2: 25321922169915245322452890197,
                limb3: 7572498493356377691083220924
            },
            y1: u384 {
                limb0: 62877012789163609932793846329,
                limb1: 56644565888574229479048604144,
                limb2: 29577509647022619906855781533,
                limb3: 605093812701583950477309447
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 60330254540161823465660039741,
                limb1: 4938002210231142589983544232,
                limb2: 21550872822076020760085294893,
                limb3: 166348493508137760365571927
            },
            x1: u384 {
                limb0: 3112374056649100024924515773,
                limb1: 49842449929659212350110683676,
                limb2: 9950338510290954984922145125,
                limb3: 2591350256800530965312024570
            },
            y0: u384 {
                limb0: 46306501163349575090739509393,
                limb1: 69075343680805512111341741367,
                limb2: 18996920266080813585107470467,
                limb3: 6087197626894465230428778179
            },
            y1: u384 {
                limb0: 25382900557023210020081253480,
                limb1: 77219048453067882418119751730,
                limb2: 48315876427510196530964911964,
                limb3: 1168568259982368229690519972
            }
        };

        let new_lhs: u384 = u384 {
            limb0: 69211418492923693371419451447,
            limb1: 16077318197917107890597111707,
            limb2: 13627777219868853101677425420,
            limb3: 1105143355567709418700576017
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 67331528729557336834428153353,
            limb1: 18084209543064189404561951271,
            limb2: 13105424298559814169617984648,
            limb3: 4217872182463525013773208277
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
                limb0: 11536302762810502427313224118,
                limb1: 48320162972374134993842993753,
                limb2: 69738122843262858663806104944,
                limb3: 3470481083717413188813756844
            },
            w1: u384 {
                limb0: 42298985031730439996205438743,
                limb1: 10830249276031119602537530368,
                limb2: 6029321491013039000734605087,
                limb3: 2549885336912641069985037572
            },
            w2: u384 {
                limb0: 71153308406477045153586694590,
                limb1: 51878787768382641628607360768,
                limb2: 28199709643086205753066390523,
                limb3: 5537298946772857081613235442
            },
            w3: u384 {
                limb0: 68711041823715703148720532281,
                limb1: 55383413099474566141304212843,
                limb2: 39862146371408228393983061179,
                limb3: 7195590333331871190551078797
            },
            w4: u384 {
                limb0: 61341443882219355373380515850,
                limb1: 63701397344123368503479409399,
                limb2: 32657344081172243680961116742,
                limb3: 5834795824105331661235137496
            },
            w5: u384 {
                limb0: 19337606991797667010226019884,
                limb1: 6363527204274183594088852664,
                limb2: 26699241723004147548401560905,
                limb3: 3035329548449027583377443970
            },
            w6: u384 {
                limb0: 39085436129629553082189305468,
                limb1: 49987434169411331162854349079,
                limb2: 52849000022343374857955118016,
                limb3: 2840891791129937236632082242
            },
            w7: u384 {
                limb0: 37153843843047683690959164122,
                limb1: 28856793514660098958424155333,
                limb2: 70141629713176087207146091348,
                limb3: 3372539506773595380901708576
            },
            w8: u384 {
                limb0: 36392020979348358273630045962,
                limb1: 21696197450626985389688639247,
                limb2: 75681754624367611168956156104,
                limb3: 7885445169344097270787659190
            },
            w9: u384 {
                limb0: 78904308145554809014500261569,
                limb1: 23882544487417562577148370014,
                limb2: 12062009210166820548277902151,
                limb3: 697131873584918561086393833
            },
            w10: u384 {
                limb0: 73612525053195922996659719185,
                limb1: 56255307249476817479211738726,
                limb2: 3010772798693915901605209558,
                limb3: 5120410064687726337103480186
            },
            w11: u384 {
                limb0: 26605707115402350729306011567,
                limb1: 17951236956457951410202562241,
                limb2: 66253977058150157564728764986,
                limb3: 7354124459590958309073997955
            }
        };

        let z: u384 = u384 {
            limb0: 77987664459792371478765992625,
            limb1: 40671550611707621956293669978,
            limb2: 76656657633559001049701618473,
            limb3: 7055264512611433113107806038
        };

        let scaling_factor: MillerLoopResultScalingFactor = MillerLoopResultScalingFactor {
            w0: u384 {
                limb0: 76307625596885500826626523053,
                limb1: 27029295388169301006672040136,
                limb2: 9386462606189984758521015227,
                limb3: 6653784229040877364212130981
            },
            w2: u384 {
                limb0: 44429062179056289297209863354,
                limb1: 68686979454448049800506489783,
                limb2: 8137425622411721505758184466,
                limb3: 3679003526285285589048805510
            },
            w4: u384 {
                limb0: 61510258391475858182806797429,
                limb1: 14385186002269794640108182149,
                limb2: 52516534177092114541698966228,
                limb3: 3368180894963295132057263630
            },
            w6: u384 {
                limb0: 73134304836962941892283687680,
                limb1: 69801675528701499816552070692,
                limb2: 36224143209424896681889207395,
                limb3: 7335261128548467988219036498
            },
            w8: u384 {
                limb0: 25062387053895218355543897618,
                limb1: 37870294831124718358625658017,
                limb2: 38046871985718008878434002503,
                limb3: 1901092404946245708354588534
            },
            w10: u384 {
                limb0: 67150586502705501009510853602,
                limb1: 8272722717966857946443052743,
                limb2: 16783383682650061563407698202,
                limb3: 1110216014467981803816377473
            }
        };

        let (c_inv_of_z_result, scaling_factor_of_z_result, c_inv_frob_1_of_z_result) =
            run_BLS12_381_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit(
            lambda_root_inverse, z, scaling_factor
        );
        let c_inv_of_z: u384 = u384 {
            limb0: 69376228184893836008281016943,
            limb1: 78506958399698086848361385031,
            limb2: 71663108430625964706712659552,
            limb3: 3184028700479444101090097870
        };

        let scaling_factor_of_z: u384 = u384 {
            limb0: 9799742483551255027262094330,
            limb1: 39784236017751831534029310808,
            limb2: 45336602058993678362026113283,
            limb3: 6404181341696823446186891483
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 33185800275277187166647996793,
            limb1: 8787072236294328676580626335,
            limb2: 5889423345407502232514931849,
            limb3: 3776231080374153571940096173
        };
        assert_eq!(c_inv_of_z_result, c_inv_of_z);
        assert_eq!(scaling_factor_of_z_result, scaling_factor_of_z);
        assert_eq!(c_inv_frob_1_of_z_result, c_inv_frob_1_of_z);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_PREPARE_PAIRS_2_circuit_BLS12_381() {
        let p_0: G1Point = G1Point {
            x: u384 {
                limb0: 8087637096430009750579545463,
                limb1: 45197734022250574432615113582,
                limb2: 15611418450859980409090215578,
                limb3: 1037527552402250104456396619
            },
            y: u384 {
                limb0: 9086465249991103896119590057,
                limb1: 79000873895776060558494974526,
                limb2: 61437936818824971160838876969,
                limb3: 4267855361484029164369513171
            }
        };

        let p_1: G1Point = G1Point {
            x: u384 {
                limb0: 16288857537882314089900813638,
                limb1: 72919424215987966909135372078,
                limb2: 62723230650102085967203404828,
                limb3: 1531645040016278448329077181
            },
            y: u384 {
                limb0: 65576248179265677288329348858,
                limb1: 63800264213160434124983079436,
                limb2: 59173293347792565228232838750,
                limb3: 7640962863098529654389257726
            }
        };

        let (p_0_result, p_1_result) = run_BLS12_381_MP_CHECK_PREPARE_PAIRS_2_circuit(p_0, p_1);
        let p_0: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 15712969672302209249038429066,
                limb1: 21077666251455712397110176284,
                limb2: 69622472216653370048754621668,
                limb3: 2136822977547319581530771368
            },
            xNegOverY: u384 {
                limb0: 32899640503283700241232414402,
                limb1: 60084159730001356709737705959,
                limb2: 77645921319446209067500240089,
                limb3: 4166856178057764592821166818
            }
        };
        let p_1: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 67331560161516219353350767533,
                limb1: 57975260107680490727064578264,
                limb2: 76106914842922433133081304177,
                limb3: 7360383716942981100190240616
            },
            xNegOverY: u384 {
                limb0: 21061631494865254842081635589,
                limb1: 57596234211169052595120390134,
                limb2: 33091513251644990392479743257,
                limb3: 1599361290098363532564097538
            }
        };
        assert_eq!(p_0_result, p_0);
        assert_eq!(p_1_result, p_1);
    }


    #[test]
    fn test_run_BLS12_381_MP_CHECK_PREPARE_PAIRS_3_circuit_BLS12_381() {
        let p_0: G1Point = G1Point {
            x: u384 {
                limb0: 50980418261052459146624285516,
                limb1: 55808416738793037191887341251,
                limb2: 20640529662733711640101821102,
                limb3: 7451975005605946185586173403
            },
            y: u384 {
                limb0: 2314876068235204858166483326,
                limb1: 54724087726953231705261851537,
                limb2: 50652324825585633096730387319,
                limb3: 2597561318121124349494326431
            }
        };

        let p_1: G1Point = G1Point {
            x: u384 {
                limb0: 63709429559201513400099818143,
                limb1: 31347528908406808059142218043,
                limb2: 24884827198074396480662991947,
                limb3: 4655932696183746975619882126
            },
            y: u384 {
                limb0: 17084426157381046224579031913,
                limb1: 41632942925916312581014688531,
                limb2: 18682174753995463300228286084,
                limb3: 4432695421521804959686781164
            }
        };

        let p_2: G1Point = G1Point {
            x: u384 {
                limb0: 45764008709412411035054438648,
                limb1: 70836761834472662738053129666,
                limb2: 28801002752160646375133870191,
                limb3: 5661984930358099762503593049
            },
            y: u384 {
                limb0: 29200112268207250075360935873,
                limb1: 34934882304820993342545616103,
                limb2: 22636587275466817001726191192,
                limb3: 6796590164675138002463095427
            }
        };

        let (p_0_result, p_1_result, p_2_result) = run_BLS12_381_MP_CHECK_PREPARE_PAIRS_3_circuit(
            p_0, p_1, p_2
        );
        let p_0: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 76234307838338241034438367515,
                limb1: 64004036279697404396945703743,
                limb2: 64932633198626462093899452489,
                limb3: 1351888395597913912503237979
            },
            xNegOverY: u384 {
                limb0: 9342510917395523767287046017,
                limb1: 28068931381947087974100500492,
                limb2: 52719512230001100335223790426,
                limb3: 4048906654236620368410829814
            }
        };
        let p_1: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 47581349017043883670887386513,
                limb1: 10321625339574891315035054280,
                limb2: 25437083755827626362712292270,
                limb3: 646126154486995184830848109
            },
            xNegOverY: u384 {
                limb0: 23114642051059951239782137368,
                limb1: 66598160350505091503707044046,
                limb2: 10031711899141404645108903373,
                limb3: 1545314600759718868739131775
            }
        };
        let p_2: BLSProcessedPair = BLSProcessedPair {
            yInv: u384 {
                limb0: 23716656240240593794923534314,
                limb1: 63757535315436379129213048022,
                limb2: 38604720139111032509166290915,
                limb3: 4371282200765666751733316383
            },
            xNegOverY: u384 {
                limb0: 65955942946379161616337507683,
                limb1: 66436116132122643491527613683,
                limb2: 75011493362587683502963570390,
                limb3: 2924282853997035098546587890
            }
        };
        assert_eq!(p_0_result, p_0);
        assert_eq!(p_1_result, p_1);
        assert_eq!(p_2_result, p_2);
    }


    #[test]
    fn test_run_BN254_MP_CHECK_BIT00_LOOP_2_circuit_BN254() {
        let yInv_0: u384 = u384 {
            limb0: 31856760263208984726179120585,
            limb1: 18302410504278765944347728499,
            limb2: 1777036268156364049,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 53746623716480339218657872339,
            limb1: 2665962725876116898241309138,
            limb2: 3050908754056501448,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 75689444356124290441600953649,
                limb1: 17989763129835920932315549497,
                limb2: 2117764773547207938,
                limb3: 0
            },
            x1: u384 {
                limb0: 79017139234678908622765506368,
                limb1: 17839293860469538404433834586,
                limb2: 2294780044923640868,
                limb3: 0
            },
            y0: u384 {
                limb0: 59192617695529499479513058410,
                limb1: 65429976047832691594997412420,
                limb2: 3471624693652610525,
                limb3: 0
            },
            y1: u384 {
                limb0: 67112131037228465290621407724,
                limb1: 23368063716759917089478805467,
                limb2: 939117765463076055,
                limb3: 0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 30359963284888885323693517481,
            limb1: 5596377337847237719405435551,
            limb2: 1676742891710502510,
            limb3: 0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 55720900661326384605212211652,
            limb1: 35848531682099468796603784267,
            limb2: 331426720018576208,
            limb3: 0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 71868105488994878880843524196,
                limb1: 18768421114113590216121451833,
                limb2: 819631917425408436,
                limb3: 0
            },
            x1: u384 {
                limb0: 73181792711662501860836266434,
                limb1: 76582933774955723164253869875,
                limb2: 409901020141353803,
                limb3: 0
            },
            y0: u384 {
                limb0: 22859859154136284308393795100,
                limb1: 28000855034728171306036414699,
                limb2: 614425251668742614,
                limb3: 0
            },
            y1: u384 {
                limb0: 23972813845063086774859544213,
                limb1: 8406961366874232703726535902,
                limb2: 652348407379311210,
                limb3: 0
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 58280446892782192859377038916,
            limb1: 40953080295398762391344997717,
            limb2: 1773985397188630470,
            limb3: 0
        };

        let f_i_of_z: u384 = u384 {
            limb0: 27249764037930567846218172537,
            limb1: 19011748802343590489610636458,
            limb2: 1410321390223264461,
            limb3: 0
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 5731185999004768069004731831,
                limb1: 39241751224020400654597717087,
                limb2: 2020834351272407995,
                limb3: 0
            },
            w1: u384 {
                limb0: 64095796044230917814179259865,
                limb1: 39105593325256618226441303393,
                limb2: 2029642705291974621,
                limb3: 0
            },
            w2: u384 {
                limb0: 6455272549092671826509519312,
                limb1: 65463462261161940834466898863,
                limb2: 709257394876839757,
                limb3: 0
            },
            w3: u384 {
                limb0: 38822865599411371039404195807,
                limb1: 66588022967208120556755172040,
                limb2: 1286642042344041850,
                limb3: 0
            },
            w4: u384 {
                limb0: 47906885162578058538164730737,
                limb1: 50258883807440287578679063824,
                limb2: 1256897600197499811,
                limb3: 0
            },
            w5: u384 {
                limb0: 9406778144477039479288656734,
                limb1: 56403056411038013192065792670,
                limb2: 795867129819795335,
                limb3: 0
            },
            w6: u384 {
                limb0: 58781081570818241434142697606,
                limb1: 33931014974790147367144790947,
                limb2: 229525276486120494,
                limb3: 0
            },
            w7: u384 {
                limb0: 51117769816528266524923650677,
                limb1: 76942385322032925123146780840,
                limb2: 2604066695098047042,
                limb3: 0
            },
            w8: u384 {
                limb0: 53469669196190738206678920457,
                limb1: 43309084602205469172728579506,
                limb2: 1301266048600613581,
                limb3: 0
            },
            w9: u384 {
                limb0: 65901976594455383272796456465,
                limb1: 5132969593710279245653947797,
                limb2: 1418178523824501187,
                limb3: 0
            },
            w10: u384 {
                limb0: 18507950302796935819867559327,
                limb1: 38050883552460141895373935949,
                limb2: 2684279815916077691,
                limb3: 0
            },
            w11: u384 {
                limb0: 64154912163004101211174450983,
                limb1: 39998314734646276193108081157,
                limb2: 1692429991791313049,
                limb3: 0
            }
        };

        let ci: u384 = u384 {
            limb0: 2003394466289312727448866158,
            limb1: 69470466942458991315857109763,
            limb2: 715932567035234685,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 40443957756524008307692351208,
            limb1: 10741815352417431977484953904,
            limb2: 238083174513095600,
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
                limb0: 71034154725970103158033658879,
                limb1: 66533763720010285851903725587,
                limb2: 817741010207865259,
                limb3: 0
            },
            x1: u384 {
                limb0: 29086806810220199064176865772,
                limb1: 12593869671565630560351683057,
                limb2: 1724790640703392089,
                limb3: 0
            },
            y0: u384 {
                limb0: 78456663779451002677827448083,
                limb1: 9803143166366264036871908211,
                limb2: 420408949608590925,
                limb3: 0
            },
            y1: u384 {
                limb0: 48621073084733039921528748197,
                limb1: 30849634937796682946216154295,
                limb2: 911115538249094063,
                limb3: 0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 28442918889029692431086967998,
                limb1: 70095872218915404824263899151,
                limb2: 2673306572450996271,
                limb3: 0
            },
            x1: u384 {
                limb0: 25578590123297097495122036260,
                limb1: 76002385167315687617466940760,
                limb2: 1253264132395416942,
                limb3: 0
            },
            y0: u384 {
                limb0: 45204869157749191864796933347,
                limb1: 35645757272299088030998554173,
                limb2: 469686366781629484,
                limb3: 0
            },
            y1: u384 {
                limb0: 21302086685230589193323122043,
                limb1: 34612128738847257300217968711,
                limb2: 3039084027333559272,
                limb3: 0
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 44755191292294301752649064992,
            limb1: 63003080502086392813532824096,
            limb2: 1145062312887754007,
            limb3: 0
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 25271696589591755592169916191,
            limb1: 20597482761298984311897189260,
            limb2: 1993797012992703379,
            limb3: 0
        };

        let ci_plus_one: u384 = u384 {
            limb0: 28904383365603707664947650164,
            limb1: 12293696527536246418798651088,
            limb2: 2365789450372725716,
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
            limb0: 74160332027730249552331498205,
            limb1: 13265876604046909396720145324,
            limb2: 808686839099775279,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 73547558571290950307166932759,
            limb1: 34697483692938930982243482162,
            limb2: 3206164740514950212,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 52054916125950481705494674659,
                limb1: 7646539685459627440313037034,
                limb2: 1783172606133649053,
                limb3: 0
            },
            x1: u384 {
                limb0: 57772803722979836854515485428,
                limb1: 35313749160173861356287648727,
                limb2: 47627007644183742,
                limb3: 0
            },
            y0: u384 {
                limb0: 5319259062566720319530951007,
                limb1: 11946586216935660733770171435,
                limb2: 2301707641636753250,
                limb3: 0
            },
            y1: u384 {
                limb0: 9568560568169705841472450700,
                limb1: 12240066254828772365871655429,
                limb2: 3348941402152504503,
                limb3: 0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 40482201862602040348902191594,
            limb1: 68588115436759865194083685528,
            limb2: 1073712581941085376,
            limb3: 0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 60139650230564788144581671932,
            limb1: 39386967185949941576360216989,
            limb2: 754001824102373042,
            limb3: 0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 45752929727891445416990617196,
                limb1: 68545198764012822230925534153,
                limb2: 631245218471276900,
                limb3: 0
            },
            x1: u384 {
                limb0: 14868897864212288818298250796,
                limb1: 50199507224233381231534885317,
                limb2: 236680559295432950,
                limb3: 0
            },
            y0: u384 {
                limb0: 34665292409337531459791541032,
                limb1: 64563139376014138978768830989,
                limb2: 1820912104107005151,
                limb3: 0
            },
            y1: u384 {
                limb0: 39772624240223228374228699308,
                limb1: 35425873239589042380580383631,
                limb2: 1030798415582678032,
                limb3: 0
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 73170181951580788973107646644,
            limb1: 1805588033284865383594167483,
            limb2: 2955304611475230372,
            limb3: 0
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 54699685952450831386499895084,
            limb1: 30265345897492465278486595892,
            limb2: 2685342250454219911,
            limb3: 0
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 69097556126300130973500202894,
                limb1: 10880612585363764114185675950,
                limb2: 544006891991707591,
                limb3: 0
            },
            x1: u384 {
                limb0: 18345271066608876239647148246,
                limb1: 48227043196369103558558151913,
                limb2: 1247129245341953258,
                limb3: 0
            },
            y0: u384 {
                limb0: 71549398640022017272735627484,
                limb1: 23345607396624122712665341321,
                limb2: 3436805003868096423,
                limb3: 0
            },
            y1: u384 {
                limb0: 17049052477671369488309807940,
                limb1: 58591882325771351198815536941,
                limb2: 3480992168836397176,
                limb3: 0
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 34955077031784815180794933133,
            limb1: 52272325340017410098912454548,
            limb2: 1041859099176182000,
            limb3: 0
        };

        let f_i_of_z: u384 = u384 {
            limb0: 53208433418495774549853231219,
            limb1: 1345018542764029817729751673,
            limb2: 2645231309294290325,
            limb3: 0
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 58019878522245527445513800514,
                limb1: 28000782892205661399214743384,
                limb2: 2264831719513322529,
                limb3: 0
            },
            w1: u384 {
                limb0: 5272245778136717271364827529,
                limb1: 27328051532422336103693564514,
                limb2: 3062047154892380749,
                limb3: 0
            },
            w2: u384 {
                limb0: 70705504294441847629938883327,
                limb1: 35570818490355040117043174641,
                limb2: 655112883946529174,
                limb3: 0
            },
            w3: u384 {
                limb0: 30318104872283026060993340579,
                limb1: 70586260764210815576518906622,
                limb2: 2461282562598012428,
                limb3: 0
            },
            w4: u384 {
                limb0: 73009370503131768456612709502,
                limb1: 75579971750401791876434913943,
                limb2: 790053841296597119,
                limb3: 0
            },
            w5: u384 {
                limb0: 62406549176842617668616412238,
                limb1: 44479386518032399959118950711,
                limb2: 3310235053570043140,
                limb3: 0
            },
            w6: u384 {
                limb0: 73495959859468839901193557241,
                limb1: 8212669369168428990323141831,
                limb2: 2898590971658354980,
                limb3: 0
            },
            w7: u384 {
                limb0: 11889847854344251023632072276,
                limb1: 3172993339565912645574624431,
                limb2: 1569127600727658517,
                limb3: 0
            },
            w8: u384 {
                limb0: 7100373994159122329872630320,
                limb1: 53213234625413967443012735476,
                limb2: 2112690938921577531,
                limb3: 0
            },
            w9: u384 {
                limb0: 28190132141205787746107654425,
                limb1: 59657078058082158449791827549,
                limb2: 1557116252891851240,
                limb3: 0
            },
            w10: u384 {
                limb0: 39005066498916168870263011286,
                limb1: 1171302806874650212070428484,
                limb2: 2445770906158382593,
                limb3: 0
            },
            w11: u384 {
                limb0: 43611019554931504927786788328,
                limb1: 2767306979904307391571360447,
                limb2: 2452462995471439483,
                limb3: 0
            }
        };

        let ci: u384 = u384 {
            limb0: 20793160632910756694259940841,
            limb1: 3034506088651893135189771078,
            limb2: 1821916955598587420,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 31990653221887022298253024641,
            limb1: 4052712456614125767270992883,
            limb2: 314804863614289942,
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
                limb0: 32144485396930042132898267997,
                limb1: 72727899580541417943311256594,
                limb2: 1423181837421547847,
                limb3: 0
            },
            x1: u384 {
                limb0: 18898873508157628243204267899,
                limb1: 44542515337482147073238148587,
                limb2: 2428995807672266664,
                limb3: 0
            },
            y0: u384 {
                limb0: 11337945864172411941028225973,
                limb1: 21351594593613529417400166457,
                limb2: 354006858740788016,
                limb3: 0
            },
            y1: u384 {
                limb0: 30835625558724003819770922571,
                limb1: 13761412698471203285059046517,
                limb2: 1880602962793053965,
                limb3: 0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 32856610774651996491638223368,
                limb1: 56211241927607984959699607820,
                limb2: 1288755044572108818,
                limb3: 0
            },
            x1: u384 {
                limb0: 13937704637051096007616104105,
                limb1: 41029498862082474999413087349,
                limb2: 1970060877295792235,
                limb3: 0
            },
            y0: u384 {
                limb0: 16664852369036965263409202991,
                limb1: 37278637590038564375246641432,
                limb2: 791115989446411845,
                limb3: 0
            },
            y1: u384 {
                limb0: 35084237116359586833840674499,
                limb1: 21132164837201184748367669426,
                limb2: 564103344240933256,
                limb3: 0
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 50155142340011267367267153519,
                limb1: 53209908216678272545989252762,
                limb2: 2537691848673132310,
                limb3: 0
            },
            x1: u384 {
                limb0: 1841458253689882337414660168,
                limb1: 15600864600562807810374454007,
                limb2: 2278868154783361851,
                limb3: 0
            },
            y0: u384 {
                limb0: 10698008053447083657185955777,
                limb1: 63393929389421821781523852543,
                limb2: 24546302042241769,
                limb3: 0
            },
            y1: u384 {
                limb0: 7545130933106657646432536857,
                limb1: 54149611507664544890406187443,
                limb2: 2137555887711662090,
                limb3: 0
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 5509124376322798741865649443,
            limb1: 66293147935880291184808941491,
            limb2: 2822483702193861842,
            limb3: 0
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 30406765761230442328423034284,
            limb1: 19805095822338403207120303987,
            limb2: 1986458578212634800,
            limb3: 0
        };

        let ci_plus_one: u384 = u384 {
            limb0: 1957698102011889513664562605,
            limb1: 3384814666953273918960744714,
            limb2: 2950728647126562680,
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
            limb0: 19197797497302128332894999030,
            limb1: 15327885207922208124960461606,
            limb2: 1555287479192216068,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 58470569522961604987784669596,
            limb1: 78906831350455391591919079453,
            limb2: 1670146967802492098,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 62094859891355104790810864365,
                limb1: 40892798923035179562363900082,
                limb2: 1744741476320600506,
                limb3: 0
            },
            x1: u384 {
                limb0: 77154281736092072524772446107,
                limb1: 24099806402659087089981744508,
                limb2: 941537619733448870,
                limb3: 0
            },
            y0: u384 {
                limb0: 66473844383418063387689140841,
                limb1: 29853108471218392389416173195,
                limb2: 1262721605363404347,
                limb3: 0
            },
            y1: u384 {
                limb0: 37704305767765975979454038997,
                limb1: 10291899242573404782822723346,
                limb2: 488170164449867393,
                limb3: 0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 40382799679709352521933065146,
            limb1: 60430586650321992048067014400,
            limb2: 794995169498020168,
            limb3: 0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 78293164734794170574535566138,
            limb1: 22973583966530356479499540367,
            limb2: 1254432115361256441,
            limb3: 0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 20039775871891094214545707147,
                limb1: 60709169157920386164200004677,
                limb2: 1687162325855902343,
                limb3: 0
            },
            x1: u384 {
                limb0: 34523202245319399689048302709,
                limb1: 35505446026402422457036359847,
                limb2: 3396026398678676939,
                limb3: 0
            },
            y0: u384 {
                limb0: 36548016655870789580713560061,
                limb1: 38087127490399565119607803526,
                limb2: 886332126051101050,
                limb3: 0
            },
            y1: u384 {
                limb0: 22170998325549671815167644634,
                limb1: 13726388575816895253555910058,
                limb2: 226727116816523658,
                limb3: 0
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 74924361437787663200903105702,
            limb1: 17653415259453100103746680659,
            limb2: 2344269640586117778,
            limb3: 0
        };

        let f_i_of_z: u384 = u384 {
            limb0: 59806045210262725526458903870,
            limb1: 29509473950301411060749892432,
            limb2: 3058449503229513201,
            limb3: 0
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 10476641705282468463695587695,
                limb1: 31200143367046477848573954088,
                limb2: 3238185370473636732,
                limb3: 0
            },
            w1: u384 {
                limb0: 33449238538863374300517019804,
                limb1: 28091463497917425999984431614,
                limb2: 1143967936971895084,
                limb3: 0
            },
            w2: u384 {
                limb0: 29255477601507623507580626137,
                limb1: 41928122072257155865494509888,
                limb2: 1735985052116826459,
                limb3: 0
            },
            w3: u384 {
                limb0: 33056007753616374312162015845,
                limb1: 71405358686088291453851846899,
                limb2: 2035124994221506231,
                limb3: 0
            },
            w4: u384 {
                limb0: 23238543001322742099746534628,
                limb1: 7214238052564246677276106122,
                limb2: 855274996560611601,
                limb3: 0
            },
            w5: u384 {
                limb0: 21943843819857678654134323775,
                limb1: 47976285835987914057491836775,
                limb2: 709640853520246060,
                limb3: 0
            },
            w6: u384 {
                limb0: 35348783784662968277035659241,
                limb1: 14687371388926487293352672332,
                limb2: 1944767865010002573,
                limb3: 0
            },
            w7: u384 {
                limb0: 19645230072419461733827279082,
                limb1: 26968307988203981880869251219,
                limb2: 2413519660120413979,
                limb3: 0
            },
            w8: u384 {
                limb0: 36637903275957912864540282263,
                limb1: 6853188419381636462799427520,
                limb2: 3481984702531289841,
                limb3: 0
            },
            w9: u384 {
                limb0: 146030076227949400334384815,
                limb1: 35580446869557986432712590466,
                limb2: 2130648967995028332,
                limb3: 0
            },
            w10: u384 {
                limb0: 23654370222835508320059369112,
                limb1: 77548724462177553720355393920,
                limb2: 1388850589227609364,
                limb3: 0
            },
            w11: u384 {
                limb0: 12377111439852444926837178951,
                limb1: 59528278038927077385096984381,
                limb2: 426825584089232782,
                limb3: 0
            }
        };

        let ci: u384 = u384 {
            limb0: 60220520864918782001528250178,
            limb1: 43079585957269161858761144926,
            limb2: 1869139898994399990,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 72000520137764837462644246783,
            limb1: 6754932813977657815572878489,
            limb2: 81229849038114951,
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
                limb0: 15878049727729343699393496094,
                limb1: 11095662824265925549159453878,
                limb2: 1383585382359577949,
                limb3: 0
            },
            x1: u384 {
                limb0: 33115204274989928150979664687,
                limb1: 18857113187971016489976443851,
                limb2: 29600772664601191,
                limb3: 0
            },
            y0: u384 {
                limb0: 41313344521780701421051910405,
                limb1: 40158518039993505230171242376,
                limb2: 1459030594151211511,
                limb3: 0
            },
            y1: u384 {
                limb0: 61419412511135182483853381043,
                limb1: 59341849503175007624010097877,
                limb2: 1926869650371453771,
                limb3: 0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 32955569765320481928061979657,
                limb1: 32869831330106862022615682749,
                limb2: 2704747737979042995,
                limb3: 0
            },
            x1: u384 {
                limb0: 52626760378691586054913570887,
                limb1: 78723118601060714170524296253,
                limb2: 1255505273966922925,
                limb3: 0
            },
            y0: u384 {
                limb0: 77243559172188976051503625449,
                limb1: 25260353835106060531091276952,
                limb2: 2129488192592418099,
                limb3: 0
            },
            y1: u384 {
                limb0: 11759697268389231105650505681,
                limb1: 10819050577814677168822968595,
                limb2: 2849272508051377086,
                limb3: 0
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 44614068279084466511702162684,
            limb1: 59102637743795131556808157527,
            limb2: 3118585482562618402,
            limb3: 0
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 373502052670811314692930580,
            limb1: 29131628586845569721492266492,
            limb2: 250586911575267412,
            limb3: 0
        };

        let ci_plus_one: u384 = u384 {
            limb0: 22794669060936949532179410188,
            limb1: 60015877790213429785644314556,
            limb2: 1499774710495053534,
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
            limb0: 73269019098533449395697897347,
            limb1: 56031909652869435031728211629,
            limb2: 142909527645175094,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 69912873840447728122375624761,
            limb1: 30536912740072055627829442363,
            limb2: 1710249014292274880,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 4970363281007758240700020482,
                limb1: 5915429634235340995490783403,
                limb2: 521729671418855295,
                limb3: 0
            },
            x1: u384 {
                limb0: 28010072736004427913614754344,
                limb1: 49984240987142221110726048413,
                limb2: 1730682607634966172,
                limb3: 0
            },
            y0: u384 {
                limb0: 446852293678898830326163527,
                limb1: 17234413268181379633664811956,
                limb2: 777334738397763583,
                limb3: 0
            },
            y1: u384 {
                limb0: 46942043628942551324275758229,
                limb1: 52320963072790628466408315981,
                limb2: 2191301501537624128,
                limb3: 0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 7390127179861838736333414437,
            limb1: 64437618819627948603071597875,
            limb2: 2661944575651324895,
            limb3: 0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 14530345556919554724197164974,
            limb1: 46286450218341982125939654682,
            limb2: 1217736341329628222,
            limb3: 0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 70370851650106659432397868105,
                limb1: 45574585679632417503166562439,
                limb2: 1551746106997261488,
                limb3: 0
            },
            x1: u384 {
                limb0: 29367511985422476642147408605,
                limb1: 14428662095801583920984476828,
                limb2: 840367569595991292,
                limb3: 0
            },
            y0: u384 {
                limb0: 78296723330092176572745454991,
                limb1: 77801284953443621777315953475,
                limb2: 6945934100532022,
                limb3: 0
            },
            y1: u384 {
                limb0: 56756008299694398929655605345,
                limb1: 24519564426086640327069604026,
                limb2: 1847354196675412498,
                limb3: 0
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 27050005244377286082488042696,
            limb1: 2612822264612189770085284721,
            limb2: 3434147554852412005,
            limb3: 0
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 39446158475831431219341424156,
            limb1: 52957968360546894462452267684,
            limb2: 2327918911557552098,
            limb3: 0
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 72273874964820305268689939544,
                limb1: 41039209367832228356047567900,
                limb2: 1357799962712253211,
                limb3: 0
            },
            x1: u384 {
                limb0: 71780441104493553769643697239,
                limb1: 37185487410308168264178541764,
                limb2: 633932235637503233,
                limb3: 0
            },
            y0: u384 {
                limb0: 20992538070866390435829540443,
                limb1: 67524340189870561831040419796,
                limb2: 1301543626503019711,
                limb3: 0
            },
            y1: u384 {
                limb0: 32804852571574833414059215751,
                limb1: 11315870564976642014388039108,
                limb2: 1771215331936702126,
                limb3: 0
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 51661077824120714546854244402,
            limb1: 35175858496736535724116618844,
            limb2: 658601457667862308,
            limb3: 0
        };

        let f_i_of_z: u384 = u384 {
            limb0: 4152021204302326432509857790,
            limb1: 17090619335270315747726354131,
            limb2: 1638999484934011960,
            limb3: 0
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 508918245973802653761934510,
                limb1: 9202518011885788722949307490,
                limb2: 17249403076200518,
                limb3: 0
            },
            w1: u384 {
                limb0: 59548990623035107422698481953,
                limb1: 15148768562330170180113945047,
                limb2: 2001558943410647470,
                limb3: 0
            },
            w2: u384 {
                limb0: 26160804169303701108574467383,
                limb1: 26200398398246981547555445397,
                limb2: 2988395391184350717,
                limb3: 0
            },
            w3: u384 {
                limb0: 34485664336970624705514895001,
                limb1: 73938261058057061540403910557,
                limb2: 680227002010418286,
                limb3: 0
            },
            w4: u384 {
                limb0: 10238103933028082051602938081,
                limb1: 14801756928247077350447529830,
                limb2: 1610249538293080548,
                limb3: 0
            },
            w5: u384 {
                limb0: 30809862244687846771967265197,
                limb1: 38976969894147591396940506124,
                limb2: 3365530714051750039,
                limb3: 0
            },
            w6: u384 {
                limb0: 15544142913195453928731074524,
                limb1: 16183834845650327124827185620,
                limb2: 3274283301470656708,
                limb3: 0
            },
            w7: u384 {
                limb0: 4515251077250220512798260103,
                limb1: 53676494393428771485733874429,
                limb2: 1074818787794107075,
                limb3: 0
            },
            w8: u384 {
                limb0: 48527784689210241541249700331,
                limb1: 68836875509116639126726990962,
                limb2: 3465645697873360170,
                limb3: 0
            },
            w9: u384 {
                limb0: 69519341455143905783924654782,
                limb1: 32597027569167625847189348169,
                limb2: 248754431759402728,
                limb3: 0
            },
            w10: u384 {
                limb0: 40891579853875313629521435071,
                limb1: 51380432001370256856125453412,
                limb2: 2523429827510821026,
                limb3: 0
            },
            w11: u384 {
                limb0: 74005152646713663672151227870,
                limb1: 36017309965444930923992455369,
                limb2: 1174837212995248629,
                limb3: 0
            }
        };

        let ci: u384 = u384 {
            limb0: 17067298552900150679423746016,
            limb1: 3346210529167654900940823776,
            limb2: 242359391179174861,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 306973362941213357609388067,
            limb1: 564901591820726767813982157,
            limb2: 73429742202762878,
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
                limb0: 40894247018247153674929663591,
                limb1: 71445197397543477221064688334,
                limb2: 1225057854208875542,
                limb3: 0
            },
            x1: u384 {
                limb0: 57219055994846718072501623628,
                limb1: 11603444397010892276995855610,
                limb2: 494660662778433425,
                limb3: 0
            },
            y0: u384 {
                limb0: 2102126742179284482151203990,
                limb1: 40070598602516356595073616595,
                limb2: 2716467777686365068,
                limb3: 0
            },
            y1: u384 {
                limb0: 5733089872469051704047500564,
                limb1: 46471100644429600434676200549,
                limb2: 690251189265168324,
                limb3: 0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 42029077105376240626437779586,
                limb1: 10749243371118684958345987696,
                limb2: 1922014830180962728,
                limb3: 0
            },
            x1: u384 {
                limb0: 50899054157557072250178385430,
                limb1: 14185488124109460498889556686,
                limb2: 3180441599582512345,
                limb3: 0
            },
            y0: u384 {
                limb0: 75553786816359508022901411459,
                limb1: 10567674190940405188130074111,
                limb2: 600330428308173596,
                limb3: 0
            },
            y1: u384 {
                limb0: 77523607243530468504081766823,
                limb1: 64607110594996775279535943725,
                limb2: 2312302862908315766,
                limb3: 0
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 74107932085730817227641817484,
                limb1: 30974520959005062316446729466,
                limb2: 2912085107357485509,
                limb3: 0
            },
            x1: u384 {
                limb0: 44156627208724553605908959691,
                limb1: 12177503629519146914998474100,
                limb2: 3397463326089914008,
                limb3: 0
            },
            y0: u384 {
                limb0: 61105902926456185899198478482,
                limb1: 59945626809729878104443879643,
                limb2: 2033902159146430891,
                limb3: 0
            },
            y1: u384 {
                limb0: 75821408203057146250378769581,
                limb1: 53028744384088651912560848728,
                limb2: 1011294972015586752,
                limb3: 0
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 47488814754068626038948848276,
            limb1: 2159000341597291313554508407,
            limb2: 735553569172915836,
            limb3: 0
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 34329180710074808411775696317,
            limb1: 26366757824463291441053823180,
            limb2: 3077629331597871310,
            limb3: 0
        };

        let ci_plus_one: u384 = u384 {
            limb0: 31741995075830715461673614044,
            limb1: 25102301615190045502529758243,
            limb2: 2934018428644187511,
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
            limb0: 10336788403926004387203284642,
            limb1: 61909585120263167920386195542,
            limb2: 120951067736084592,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 15749870715841178288886163500,
            limb1: 51625189898135425123144693508,
            limb2: 674348626250325195,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 7646953017989955615756989519,
                limb1: 15919761147728249444354948124,
                limb2: 2023701065330938003,
                limb3: 0
            },
            x1: u384 {
                limb0: 44561566849991446545713351955,
                limb1: 74788057203024371938705936198,
                limb2: 1881224457033426696,
                limb3: 0
            },
            y0: u384 {
                limb0: 29864130002179232237161915898,
                limb1: 72505591659904954681008070808,
                limb2: 2108222270337085611,
                limb3: 0
            },
            y1: u384 {
                limb0: 51634483700677284758468797321,
                limb1: 64320993950831404609304645742,
                limb2: 2164440020515378079,
                limb3: 0
            }
        };

        let Q_or_Qneg_0: G2Point = G2Point {
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

        let Q_or_Qneg_1: G2Point = G2Point {
            x0: u384 {
                limb0: 2228163094117947211021223332,
                limb1: 10529642001620646220147450049,
                limb2: 2848488276803166018,
                limb3: 0
            },
            x1: u384 {
                limb0: 23980121951876638307800184072,
                limb1: 58362257594818707782165762975,
                limb2: 3042307382754445811,
                limb3: 0
            },
            y0: u384 {
                limb0: 44560291305011316306118044092,
                limb1: 64413273889369720346356595291,
                limb2: 1620432877693563571,
                limb3: 0
            },
            y1: u384 {
                limb0: 64298627375747741846350224027,
                limb1: 19012434639071835959255919507,
                limb2: 24444013393417516,
                limb3: 0
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 75249961544109463509781404021,
            limb1: 41953659324626388125284063199,
            limb2: 291859607066500761,
            limb3: 0
        };

        let f_i_of_z: u384 = u384 {
            limb0: 12470654473779493550900849137,
            limb1: 74605501607480428090093886789,
            limb2: 2915181205756386395,
            limb3: 0
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 47936656584741649271334500668,
                limb1: 34435534296620533705544015335,
                limb2: 1436068762335363148,
                limb3: 0
            },
            w1: u384 {
                limb0: 33965401854758827358743122716,
                limb1: 64947362518551314185623294556,
                limb2: 1293304807272578472,
                limb3: 0
            },
            w2: u384 {
                limb0: 42614487941160749076441838342,
                limb1: 25189018362215397697942903566,
                limb2: 1578413340369522531,
                limb3: 0
            },
            w3: u384 {
                limb0: 62003202151866399579328156241,
                limb1: 11227204044357346327875790770,
                limb2: 27336061717904587,
                limb3: 0
            },
            w4: u384 {
                limb0: 41919216047182465214441612480,
                limb1: 12558979242415415767683493177,
                limb2: 897016373801476810,
                limb3: 0
            },
            w5: u384 {
                limb0: 49740640219765361424413700059,
                limb1: 1516543327127282185838070382,
                limb2: 3390779977847637623,
                limb3: 0
            },
            w6: u384 {
                limb0: 6173816635189533500278498159,
                limb1: 18755965635399492264324060977,
                limb2: 3291894557846350181,
                limb3: 0
            },
            w7: u384 {
                limb0: 40319134702582145609807726458,
                limb1: 64199497162571021157368859867,
                limb2: 463113059401620942,
                limb3: 0
            },
            w8: u384 {
                limb0: 13031923161871817281242121181,
                limb1: 5168039338665039897238459817,
                limb2: 1968023344079995329,
                limb3: 0
            },
            w9: u384 {
                limb0: 48304539205139311118174567712,
                limb1: 24324560982343155430342538851,
                limb2: 2271338732440707727,
                limb3: 0
            },
            w10: u384 {
                limb0: 19851254444464131326071465345,
                limb1: 31524763925617403688578049374,
                limb2: 2008905481883081650,
                limb3: 0
            },
            w11: u384 {
                limb0: 36865893138752381863691925071,
                limb1: 45064079077235270960965612784,
                limb2: 2602906089233504562,
                limb3: 0
            }
        };

        let c_or_cinv_of_z: u384 = u384 {
            limb0: 3294802236484690023520511962,
            limb1: 68528299589172556746033201596,
            limb2: 1664917225946049681,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 15114624557355386634521442185,
            limb1: 53193498561254066597432142589,
            limb2: 543143911626257241,
            limb3: 0
        };

        let ci: u384 = u384 {
            limb0: 73534238087275706114904812609,
            limb1: 75623937230210125944179634521,
            limb2: 117088341626652380,
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
                limb0: 47317046935598785155382042486,
                limb1: 21457560903209923575986446503,
                limb2: 3254004408293177918,
                limb3: 0
            },
            x1: u384 {
                limb0: 15494514456732570178586821065,
                limb1: 24032173842097443660430575984,
                limb2: 1521071909225387325,
                limb3: 0
            },
            y0: u384 {
                limb0: 30955628307359579963205060662,
                limb1: 76370242806002882010492894713,
                limb2: 1949872664570836045,
                limb3: 0
            },
            y1: u384 {
                limb0: 50921087499680672886779236633,
                limb1: 61645581959497803442030421052,
                limb2: 3276918362672705707,
                limb3: 0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 59855354678317664646273147559,
                limb1: 30324258555574355109079703061,
                limb2: 3401225822801329314,
                limb3: 0
            },
            x1: u384 {
                limb0: 56971039989240026597919915863,
                limb1: 14678545251838305476753929227,
                limb2: 3247193731397665832,
                limb3: 0
            },
            y0: u384 {
                limb0: 31822555683671328140687659202,
                limb1: 50038914254252094617121589172,
                limb2: 229229434153486958,
                limb3: 0
            },
            y1: u384 {
                limb0: 40288354252014522986798076346,
                limb1: 74905453615050093797697134979,
                limb2: 2640444300134590918,
                limb3: 0
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 30737188073999387712805979544,
            limb1: 18024685824196982956438870886,
            limb2: 1730493714114819900,
            limb3: 0
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 6049348177878962666242297809,
            limb1: 76148208586943479806754854660,
            limb2: 2184699643749933480,
            limb3: 0
        };

        let ci_plus_one: u384 = u384 {
            limb0: 66369627012805072908661097825,
            limb1: 6420137317826612210709799355,
            limb2: 2359846115911555775,
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
            limb0: 17064849834975020934055456399,
            limb1: 74671939736202130735107756211,
            limb2: 2794853688606092197,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 11311009233185433147091736067,
            limb1: 10464344270139619298991590136,
            limb2: 846930522370490180,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
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

        let Q_or_Qneg_0: G2Point = G2Point {
            x0: u384 {
                limb0: 1128380390195550658705804179,
                limb1: 37715590176798341574107257306,
                limb2: 2198519251530354921,
                limb3: 0
            },
            x1: u384 {
                limb0: 39511615404294817352020566757,
                limb1: 37339246098087732194155046325,
                limb2: 1549673539973446698,
                limb3: 0
            },
            y0: u384 {
                limb0: 25960248522053357970904533052,
                limb1: 73364095794521682165617424302,
                limb2: 885339701623416837,
                limb3: 0
            },
            y1: u384 {
                limb0: 26803692523849804808771274231,
                limb1: 36563139327826239651052455508,
                limb2: 1562693907001836004,
                limb3: 0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 47852925632430981335868156398,
            limb1: 7336778831737786009813454472,
            limb2: 1878706517781884143,
            limb3: 0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 50428998048312243530087256558,
            limb1: 53868846857515727083335827196,
            limb2: 93960238037386949,
            limb3: 0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 8997938067019260183959665735,
                limb1: 65193546670819046363689233590,
                limb2: 3331302639862789034,
                limb3: 0
            },
            x1: u384 {
                limb0: 28933586855985380443110378036,
                limb1: 52571844939583636487355491504,
                limb2: 1396898723881618371,
                limb3: 0
            },
            y0: u384 {
                limb0: 31157381147106051456022437321,
                limb1: 50613782681330316871145458030,
                limb2: 2712657782630447657,
                limb3: 0
            },
            y1: u384 {
                limb0: 48906091048196394979343331785,
                limb1: 54093829342229577887790577645,
                limb2: 727201185009830285,
                limb3: 0
            }
        };

        let Q_or_Qneg_1: G2Point = G2Point {
            x0: u384 {
                limb0: 43087280092373723374816553179,
                limb1: 44777627041255597126951042916,
                limb2: 2943025921523931550,
                limb3: 0
            },
            x1: u384 {
                limb0: 39210768809721153056940698797,
                limb1: 57034093615939789097216428890,
                limb2: 234572016126974310,
                limb3: 0
            },
            y0: u384 {
                limb0: 62775087487814073419797482511,
                limb1: 9482206200572575901731058250,
                limb2: 136596601538159168,
                limb3: 0
            },
            y1: u384 {
                limb0: 65916488635152686467226199068,
                limb1: 47128670903384391576305086622,
                limb2: 815684293922028493,
                limb3: 0
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 37457973439965313407008148022,
            limb1: 25756010242404504726332568790,
            limb2: 3307315709457540458,
            limb3: 0
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 21798494000903328263097969344,
            limb1: 43602328721278327976062312224,
            limb2: 3442809358158807439,
            limb3: 0
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 17970719942900312387987638207,
                limb1: 69449903913962383477860666959,
                limb2: 327530652326727604,
                limb3: 0
            },
            x1: u384 {
                limb0: 53853312605152600770195621913,
                limb1: 13806540068445910801601237577,
                limb2: 1028993035535055926,
                limb3: 0
            },
            y0: u384 {
                limb0: 37244904249338756022336863437,
                limb1: 38385522438554043667755278591,
                limb2: 1994309600768240233,
                limb3: 0
            },
            y1: u384 {
                limb0: 64899441710512421812466681051,
                limb1: 18178724079409428298571943135,
                limb2: 979889805754421300,
                limb3: 0
            }
        };

        let Q_or_Qneg_2: G2Point = G2Point {
            x0: u384 {
                limb0: 75259678967804835116635317015,
                limb1: 73665661859362530328134777283,
                limb2: 1028642302768472716,
                limb3: 0
            },
            x1: u384 {
                limb0: 36592732534258840494573780496,
                limb1: 25794206162336303855306003902,
                limb2: 3386136291420992374,
                limb3: 0
            },
            y0: u384 {
                limb0: 44222381230531728666010929754,
                limb1: 47004385085330828225505385072,
                limb2: 2622321986746213427,
                limb3: 0
            },
            y1: u384 {
                limb0: 77159306081172756049595328501,
                limb1: 48598460237926250135397570655,
                limb2: 2584866744407620726,
                limb3: 0
            }
        };

        let lhs_i: u384 = u384 {
            limb0: 6337230112485467030508423307,
            limb1: 48134346612603190950584288583,
            limb2: 2629925514712819366,
            limb3: 0
        };

        let f_i_of_z: u384 = u384 {
            limb0: 9416009238690081890042949788,
            limb1: 73327110131206408904159789424,
            limb2: 842090525309884086,
            limb3: 0
        };

        let f_i_plus_one = E12D {
            w0: u384 {
                limb0: 1521244786588960082248549299,
                limb1: 48129361997212224422393408606,
                limb2: 203557544872831773,
                limb3: 0
            },
            w1: u384 {
                limb0: 6133987080371847192281820612,
                limb1: 34916380138120651780984504744,
                limb2: 2786112421350079748,
                limb3: 0
            },
            w2: u384 {
                limb0: 32659963674391348732124959762,
                limb1: 35948119188199523611310040372,
                limb2: 1218174091482783244,
                limb3: 0
            },
            w3: u384 {
                limb0: 30713498703518704024315768161,
                limb1: 7630086101181271511421968851,
                limb2: 120764701252838344,
                limb3: 0
            },
            w4: u384 {
                limb0: 36165742904356990050587531045,
                limb1: 59105121330069844772275550158,
                limb2: 3204418568634846813,
                limb3: 0
            },
            w5: u384 {
                limb0: 6373940289833763056316573815,
                limb1: 42435688055817474272143891294,
                limb2: 1853589523652619850,
                limb3: 0
            },
            w6: u384 {
                limb0: 68013252073298320616311307782,
                limb1: 2202275134508436563373561093,
                limb2: 2379007547955947439,
                limb3: 0
            },
            w7: u384 {
                limb0: 65487869088070178398374263371,
                limb1: 28407228105866978034509213751,
                limb2: 454186095505344397,
                limb3: 0
            },
            w8: u384 {
                limb0: 11637323752077453075261692207,
                limb1: 61744531492706732635850430639,
                limb2: 733143838981233217,
                limb3: 0
            },
            w9: u384 {
                limb0: 19219279450277374605033138207,
                limb1: 74010234137075339363594961935,
                limb2: 1513880424385699936,
                limb3: 0
            },
            w10: u384 {
                limb0: 38260610145596781040189492335,
                limb1: 49583975832216628770168470784,
                limb2: 1835932031841631813,
                limb3: 0
            },
            w11: u384 {
                limb0: 17908745951439458958132761086,
                limb1: 33335073120829856816071644845,
                limb2: 1675362999222700315,
                limb3: 0
            }
        };

        let c_or_cinv_of_z: u384 = u384 {
            limb0: 10933318906872140736760058960,
            limb1: 61065852099815409490735551121,
            limb2: 747742686621113907,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 446618355839444511325961143,
            limb1: 56922828061039770272509152779,
            limb2: 198259022425799895,
            limb3: 0
        };

        let ci: u384 = u384 {
            limb0: 1545721402804127367186365676,
            limb1: 25616324502294827115035576632,
            limb2: 17048479735291872,
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
                limb0: 5527369776462270313918181369,
                limb1: 52759645159023130738349589076,
                limb2: 1533022110805331631,
                limb3: 0
            },
            x1: u384 {
                limb0: 14970854066223182146219423629,
                limb1: 1871349909338781515056825243,
                limb2: 3426400066148451022,
                limb3: 0
            },
            y0: u384 {
                limb0: 57388090821918174480672839910,
                limb1: 44373990303629647439604014238,
                limb2: 765332963069475756,
                limb3: 0
            },
            y1: u384 {
                limb0: 69418729147708225635057012313,
                limb1: 16697064017087369656726462482,
                limb2: 2784263596142978926,
                limb3: 0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 77870978002017607619186568754,
                limb1: 52946380247174100352707741067,
                limb2: 881326810185846071,
                limb3: 0
            },
            x1: u384 {
                limb0: 66931526907912895161590204494,
                limb1: 56794942002535403705159344229,
                limb2: 402495863276593386,
                limb3: 0
            },
            y0: u384 {
                limb0: 32045384712591139565512293602,
                limb1: 53961806061562921228094149007,
                limb2: 36868033834789877,
                limb3: 0
            },
            y1: u384 {
                limb0: 47243768842146278527140596688,
                limb1: 37912596054498049918342333201,
                limb2: 1812060015954855626,
                limb3: 0
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 45689954170980040926599683350,
                limb1: 53818095964963617288487863088,
                limb2: 2523560506615880823,
                limb3: 0
            },
            x1: u384 {
                limb0: 55838384598203553610852110886,
                limb1: 78611343214727914953559675197,
                limb2: 2389674649773939228,
                limb3: 0
            },
            y0: u384 {
                limb0: 65193074109090581885164450608,
                limb1: 4191099266672678661411470176,
                limb2: 1690580698500394703,
                limb3: 0
            },
            y1: u384 {
                limb0: 51352744600619480827097392328,
                limb1: 59431879025229818845404710966,
                limb2: 2324269386554995768,
                limb3: 0
            }
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 4022468600126103138392951172,
            limb1: 12395935566449550066211283114,
            limb2: 725544544845234187,
            limb3: 0
        };

        let lhs_i_plus_one: u384 = u384 {
            limb0: 40817829819540344734358226746,
            limb1: 33390099999561614500047099607,
            limb2: 3075345342171920264,
            limb3: 0
        };

        let ci_plus_one: u384 = u384 {
            limb0: 71313319560191444433145313285,
            limb1: 38534303956520299179372200486,
            limb2: 1433299495311634354,
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
                limb0: 26295278385926780820205785130,
                limb1: 32157431086021116356518408281,
                limb2: 3146901090620274159,
                limb3: 0
            },
            x1: u384 {
                limb0: 3889744729817033167243127128,
                limb1: 20269385341929606930174376024,
                limb2: 1993150351625727644,
                limb3: 0
            },
            y0: u384 {
                limb0: 25253349648566933768760410044,
                limb1: 73566897778428010582391649787,
                limb2: 3358578544633816503,
                limb3: 0
            },
            y1: u384 {
                limb0: 47482930688677355290677700142,
                limb1: 44643252631879750949249804836,
                limb2: 2625662491115220455,
                limb3: 0
            }
        };

        let yInv_0: u384 = u384 {
            limb0: 55341698905249139947617528614,
            limb1: 33817208697124411931548235000,
            limb2: 3180483584241258512,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 11456353399606942720795767777,
            limb1: 77341522679900248887205048022,
            limb2: 1658911255606188426,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 44312378323769457053601779929,
                limb1: 19260194377426229466981125954,
                limb2: 67746524320822193,
                limb3: 0
            },
            x1: u384 {
                limb0: 10525341065742022836541164583,
                limb1: 51655441614570801932087329092,
                limb2: 1920667238812590348,
                limb3: 0
            },
            y0: u384 {
                limb0: 2199488233999391734532875638,
                limb1: 28447338386320891337412774184,
                limb2: 442793278190378819,
                limb3: 0
            },
            y1: u384 {
                limb0: 27929089759784879351335196989,
                limb1: 42101673423621812993830128019,
                limb2: 943541656831396621,
                limb3: 0
            }
        };

        let original_Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 60278719333146281187324878389,
                limb1: 6168813685886024067315661975,
                limb2: 3250161496402840136,
                limb3: 0
            },
            x1: u384 {
                limb0: 76233533622490975609520696183,
                limb1: 54595969310315861231707446322,
                limb2: 514335680443544927,
                limb3: 0
            },
            y0: u384 {
                limb0: 12732060931036905438578012372,
                limb1: 5852429782961836985443828050,
                limb2: 1595249460472644675,
                limb3: 0
            },
            y1: u384 {
                limb0: 26169738079278623136382325211,
                limb1: 68095117536337962493067508479,
                limb2: 1966916318905771957,
                limb3: 0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 51164915768214758466973573956,
            limb1: 58723314951310779488600032487,
            limb2: 102918274785741234,
            limb3: 0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 24178191609559982124836364373,
            limb1: 15587998901532707390211025856,
            limb2: 972387668456940627,
            limb3: 0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 74854548306776478299664295144,
                limb1: 35180380127250380834428268278,
                limb2: 2975693483073566559,
                limb3: 0
            },
            x1: u384 {
                limb0: 52396239479101070366921196469,
                limb1: 8391926318390336785036810968,
                limb2: 3187978583917900403,
                limb3: 0
            },
            y0: u384 {
                limb0: 42015862590169423994704037690,
                limb1: 35077548731033309914383234277,
                limb2: 1076122992080341589,
                limb3: 0
            },
            y1: u384 {
                limb0: 5248882447573951397919702923,
                limb1: 60597278410189017099896470559,
                limb2: 1237330800050105316,
                limb3: 0
            }
        };

        let R_n_minus_2 = E12D {
            w0: u384 {
                limb0: 42935412151147242112014230752,
                limb1: 40833559044880818193943384058,
                limb2: 64350350611534528,
                limb3: 0
            },
            w1: u384 {
                limb0: 39253969211844336127678024211,
                limb1: 50480678243771746284395487635,
                limb2: 1189160028585324374,
                limb3: 0
            },
            w2: u384 {
                limb0: 27257890154383066821310971558,
                limb1: 7869154016122493797638259005,
                limb2: 2588264217099071326,
                limb3: 0
            },
            w3: u384 {
                limb0: 62642279219389931510834092594,
                limb1: 19927730832546508280428586723,
                limb2: 480494452168495182,
                limb3: 0
            },
            w4: u384 {
                limb0: 68233524963251930463610906774,
                limb1: 10161934970547487908787256647,
                limb2: 159836857817550903,
                limb3: 0
            },
            w5: u384 {
                limb0: 78876029687611291161836619617,
                limb1: 52556973173410171301394146325,
                limb2: 1061396992610873468,
                limb3: 0
            },
            w6: u384 {
                limb0: 48232599021772632667808268598,
                limb1: 34779922187815069867601112082,
                limb2: 728469249952172468,
                limb3: 0
            },
            w7: u384 {
                limb0: 77075779384248039252423124484,
                limb1: 77155539649215278280190693461,
                limb2: 2523872089077292852,
                limb3: 0
            },
            w8: u384 {
                limb0: 17118679868965121397560864364,
                limb1: 24856663213266800450142344187,
                limb2: 592437291839847632,
                limb3: 0
            },
            w9: u384 {
                limb0: 52643501940580234278115061932,
                limb1: 36173156987756276738169180,
                limb2: 3045036490717526041,
                limb3: 0
            },
            w10: u384 {
                limb0: 24430854188235605795646978746,
                limb1: 61959490654890542406562369930,
                limb2: 1490811263083364915,
                limb3: 0
            },
            w11: u384 {
                limb0: 48464887891924887920183142319,
                limb1: 63647833454946064423924359354,
                limb2: 767765390797981516,
                limb3: 0
            }
        };

        let R_n_minus_1 = E12D {
            w0: u384 {
                limb0: 32849413149699568885642529056,
                limb1: 65876951073525875808285154060,
                limb2: 565891492380393342,
                limb3: 0
            },
            w1: u384 {
                limb0: 77598259980424677085607578149,
                limb1: 25680272431206916503934104472,
                limb2: 1367673525171918109,
                limb3: 0
            },
            w2: u384 {
                limb0: 34619243684524445982078061441,
                limb1: 22717274452153856440117958812,
                limb2: 105631989180545225,
                limb3: 0
            },
            w3: u384 {
                limb0: 25109328460256562969970016727,
                limb1: 51774954741392963969030491078,
                limb2: 1325557186699415564,
                limb3: 0
            },
            w4: u384 {
                limb0: 56130143694652296098205801033,
                limb1: 70379995828691691700214706354,
                limb2: 2382420479483555150,
                limb3: 0
            },
            w5: u384 {
                limb0: 47311066207882218405560336162,
                limb1: 30789179050612363042368504908,
                limb2: 1295312153442064915,
                limb3: 0
            },
            w6: u384 {
                limb0: 20081800292463345456551429400,
                limb1: 72139378624331867418033380322,
                limb2: 2457082555073983468,
                limb3: 0
            },
            w7: u384 {
                limb0: 35558528876036842478088732671,
                limb1: 33565357648224252815203168801,
                limb2: 781845608970146601,
                limb3: 0
            },
            w8: u384 {
                limb0: 18302682824859394250099259830,
                limb1: 37817175889035485831047545154,
                limb2: 141151215612999086,
                limb3: 0
            },
            w9: u384 {
                limb0: 24425844140222924336248236752,
                limb1: 14468513654171819090067465788,
                limb2: 593432066053763710,
                limb3: 0
            },
            w10: u384 {
                limb0: 1203799016341512417965380726,
                limb1: 28694363048321436275835764055,
                limb2: 1908798161406009129,
                limb3: 0
            },
            w11: u384 {
                limb0: 19532402468811548792549747542,
                limb1: 21276812047655471859824398365,
                limb2: 1989963035505770167,
                limb3: 0
            }
        };

        let c_n_minus_3: u384 = u384 {
            limb0: 11511693070273995284882377693,
            limb1: 77875361638018122631716278388,
            limb2: 2509538534450933386,
            limb3: 0
        };

        let w_of_z: u384 = u384 {
            limb0: 74760932869453648057179532930,
            limb1: 60075446736607414489312587559,
            limb2: 594078452858641118,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 46064864601932086963308698062,
            limb1: 59023955925725274619236298042,
            limb2: 2416593706988199217,
            limb3: 0
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 23719870747466911958995106585,
            limb1: 67779148596325614483389103014,
            limb2: 3269216409187904934,
            limb3: 0
        };

        let c_frob_2_of_z: u384 = u384 {
            limb0: 57198158640702977667010573729,
            limb1: 71687878799965043967393536784,
            limb2: 921345792293189065,
            limb3: 0
        };

        let c_inv_frob_3_of_z: u384 = u384 {
            limb0: 13295263885328123897987940133,
            limb1: 30732878069893442254500677475,
            limb2: 1774612657201329829,
            limb3: 0
        };

        let previous_lhs: u384 = u384 {
            limb0: 39073930735080714804698085885,
            limb1: 67803843054481874289422274317,
            limb2: 2457147552005459142,
            limb3: 0
        };

        let R_n_minus_3_of_z: u384 = u384 {
            limb0: 65366096302421835663172939132,
            limb1: 835650531448226490533056190,
            limb2: 3444362320080872757,
            limb3: 0
        };

        let Q: Array<u384> = array![
            u384 {
                limb0: 27356951067035585084921379676,
                limb1: 20461005198938112919197330420,
                limb2: 353417296945346432,
                limb3: 0
            },
            u384 {
                limb0: 67676742380086990432758385534,
                limb1: 64104115241619972125628345637,
                limb2: 3196463074566025458,
                limb3: 0
            },
            u384 {
                limb0: 35701064642071881562327992565,
                limb1: 71067092790380178675270923920,
                limb2: 3050644578457284978,
                limb3: 0
            },
            u384 {
                limb0: 49666202815800374209268276944,
                limb1: 22909189928344113849700488112,
                limb2: 2759474543087333987,
                limb3: 0
            },
            u384 {
                limb0: 52833175583578586446520517603,
                limb1: 65735074376355193258500197024,
                limb2: 1371300422286054923,
                limb3: 0
            },
            u384 {
                limb0: 66035221433447195884366291583,
                limb1: 48215449102220885623882731917,
                limb2: 1565100970723749323,
                limb3: 0
            },
            u384 {
                limb0: 72341488040200614128084603528,
                limb1: 67594641799115042014008569335,
                limb2: 2781266380900191294,
                limb3: 0
            },
            u384 {
                limb0: 45853456734871012773356499306,
                limb1: 70935123748738866917077004827,
                limb2: 1373840975061016306,
                limb3: 0
            },
            u384 {
                limb0: 59987266053155913619999910172,
                limb1: 18637706370336642005189317188,
                limb2: 1989130532479686734,
                limb3: 0
            },
            u384 {
                limb0: 40752697390388119035665776685,
                limb1: 11112962707473480058991766119,
                limb2: 2754856009251363083,
                limb3: 0
            },
            u384 {
                limb0: 37701193218643795012106197979,
                limb1: 20518050444260407527409517567,
                limb2: 1391120633222715060,
                limb3: 0
            },
            u384 {
                limb0: 51540450938244412325080206422,
                limb1: 62547279651341779702117789844,
                limb2: 896162233866851509,
                limb3: 0
            },
            u384 {
                limb0: 36351273042359421665518951009,
                limb1: 1448178449759044487788488905,
                limb2: 2754051159840098759,
                limb3: 0
            },
            u384 {
                limb0: 28552257520623663022396423630,
                limb1: 21207341065849910545468194397,
                limb2: 3110580203891361289,
                limb3: 0
            },
            u384 {
                limb0: 1306489111607322672789488725,
                limb1: 72610531697863705015207158230,
                limb2: 772356383620131897,
                limb3: 0
            },
            u384 {
                limb0: 28781848225990331404683268137,
                limb1: 6957143952038344788196827074,
                limb2: 1991954342021882325,
                limb3: 0
            },
            u384 {
                limb0: 55419396868170503288878635921,
                limb1: 13642347608890548228178900069,
                limb2: 2738763875781929386,
                limb3: 0
            },
            u384 {
                limb0: 27950792771406312151346646753,
                limb1: 68976406838155591938931538988,
                limb2: 1770666083514905078,
                limb3: 0
            },
            u384 {
                limb0: 14615612206400765347540108072,
                limb1: 39321458825195509075292327571,
                limb2: 697039904675784822,
                limb3: 0
            },
            u384 {
                limb0: 71775527903744597711262335923,
                limb1: 34554122535282079308077868458,
                limb2: 2787674958551898093,
                limb3: 0
            },
            u384 {
                limb0: 51311560707716095739496405146,
                limb1: 10739191613981306907532700259,
                limb2: 392999336627237238,
                limb3: 0
            },
            u384 {
                limb0: 56602895881581335582663967345,
                limb1: 76971549978976164606346265368,
                limb2: 1457858668478295009,
                limb3: 0
            },
            u384 {
                limb0: 52054654779208637269686603470,
                limb1: 38508569974338392631231184470,
                limb2: 2219369752485307863,
                limb3: 0
            },
            u384 {
                limb0: 26191649065926652268141442049,
                limb1: 51178397079496831350855620600,
                limb2: 2115188032594331722,
                limb3: 0
            },
            u384 {
                limb0: 12643151824413271624945304507,
                limb1: 40598893563591335499031517451,
                limb2: 2577592140968896664,
                limb3: 0
            },
            u384 {
                limb0: 48171380480045546351584267930,
                limb1: 53157520627635632175268918810,
                limb2: 2801495210951393371,
                limb3: 0
            },
            u384 {
                limb0: 8907227139761396193519005693,
                limb1: 8828975589970112692376272638,
                limb2: 857890644049704400,
                limb3: 0
            },
            u384 {
                limb0: 38209942657006366348783871042,
                limb1: 57754630494956049208435613403,
                limb2: 3157049263638845769,
                limb3: 0
            },
            u384 {
                limb0: 20775824454286947232363848492,
                limb1: 8765718624152260703094314544,
                limb2: 1640360378005322309,
                limb3: 0
            },
            u384 {
                limb0: 42467654156190031614017992483,
                limb1: 639923216445955130295308267,
                limb2: 2803111423817304351,
                limb3: 0
            },
            u384 {
                limb0: 61444804603880188457232600862,
                limb1: 70382727944395577052724485524,
                limb2: 1882038005161799280,
                limb3: 0
            },
            u384 {
                limb0: 77461609861143541299237058944,
                limb1: 2142947650060670887597219977,
                limb2: 2914208085607429540,
                limb3: 0
            },
            u384 {
                limb0: 6740555394807156857764728744,
                limb1: 51015226100351963069986993616,
                limb2: 3456480448405230739,
                limb3: 0
            },
            u384 {
                limb0: 47464196112954551825536745080,
                limb1: 10496658885951485180021716428,
                limb2: 3371800911770665239,
                limb3: 0
            },
            u384 {
                limb0: 4339999891477638360047867335,
                limb1: 35311033650643641856455435382,
                limb2: 2501377558119777601,
                limb3: 0
            },
            u384 {
                limb0: 74587729044872893159576258424,
                limb1: 51042064023610099024529763461,
                limb2: 2714220543696079110,
                limb3: 0
            },
            u384 {
                limb0: 65821423212764509398120707494,
                limb1: 37205773641880746675182188260,
                limb2: 1235339939683356309,
                limb3: 0
            },
            u384 {
                limb0: 61310882930700014088094901063,
                limb1: 69420016221568265953358518901,
                limb2: 2949076321031948284,
                limb3: 0
            },
            u384 {
                limb0: 61218971062315893066299295758,
                limb1: 60348615836708746137793640129,
                limb2: 620652557754079240,
                limb3: 0
            },
            u384 {
                limb0: 11516664929868624248881616905,
                limb1: 59505181108120106257510842052,
                limb2: 397234752312367477,
                limb3: 0
            },
            u384 {
                limb0: 20113553687270141460253378515,
                limb1: 54057024911024917150202128074,
                limb2: 2169896756529391339,
                limb3: 0
            },
            u384 {
                limb0: 51045598493867986602332366817,
                limb1: 69283926801557474195943517096,
                limb2: 1445261260419351979,
                limb3: 0
            },
            u384 {
                limb0: 5582971433925081757616423849,
                limb1: 2729142422150463344892904419,
                limb2: 2972399257775041017,
                limb3: 0
            },
            u384 {
                limb0: 52627880362488810314465893949,
                limb1: 21202400339955532776927652839,
                limb2: 1395993918431486868,
                limb3: 0
            },
            u384 {
                limb0: 52734019973134373870986065918,
                limb1: 37788783526058627853666103848,
                limb2: 2727696476870389920,
                limb3: 0
            },
            u384 {
                limb0: 58940367422329565759856843451,
                limb1: 49306726747782465586006575591,
                limb2: 2363078759017140520,
                limb3: 0
            },
            u384 {
                limb0: 27116938255086176221444789661,
                limb1: 546281316600448382683657850,
                limb2: 2648786536735237497,
                limb3: 0
            },
            u384 {
                limb0: 8790503055031737040661302293,
                limb1: 60735128853087214729835093553,
                limb2: 1124764852724101013,
                limb3: 0
            },
            u384 {
                limb0: 41094238944703350089480284927,
                limb1: 77211132984842121525550103489,
                limb2: 2628222902437047991,
                limb3: 0
            },
            u384 {
                limb0: 74671345672734644143886926738,
                limb1: 27009742045123851315683933190,
                limb2: 2241487675673432177,
                limb3: 0
            },
            u384 {
                limb0: 18710373775480682078334123131,
                limb1: 37824729717222481282134673463,
                limb2: 3344710127162438258,
                limb3: 0
            },
            u384 {
                limb0: 54145911045635798131118149923,
                limb1: 65437667657775098069556409419,
                limb2: 3346431687672442094,
                limb3: 0
            },
            u384 {
                limb0: 3461697397115788198561493337,
                limb1: 38048292875309751594278345040,
                limb2: 3036792792520236795,
                limb3: 0
            },
            u384 {
                limb0: 13063974522476725659969527068,
                limb1: 55090774676070823517988707894,
                limb2: 3158774724606832438,
                limb3: 0
            },
            u384 {
                limb0: 38322326523617833010307681971,
                limb1: 2162541339405348724315590137,
                limb2: 2094804837769832300,
                limb3: 0
            },
            u384 {
                limb0: 47519389390589294628725441225,
                limb1: 53152526587741788478716608630,
                limb2: 2820372687495650178,
                limb3: 0
            },
            u384 {
                limb0: 49795340709874095007501255021,
                limb1: 34031123296555948256184688954,
                limb2: 1094021948288368800,
                limb3: 0
            },
            u384 {
                limb0: 23389582968169796381567798538,
                limb1: 20196641382878395938052318756,
                limb2: 1115095280793645737,
                limb3: 0
            },
            u384 {
                limb0: 68601251998263727150071121342,
                limb1: 29478018407241824505432268456,
                limb2: 2100784640141463625,
                limb3: 0
            },
            u384 {
                limb0: 26757639256044174904766529520,
                limb1: 11604044828485164110511426463,
                limb2: 1123291179449983558,
                limb3: 0
            },
            u384 {
                limb0: 60202249500430906012554786977,
                limb1: 13704532298570443083201586248,
                limb2: 3249640612862464664,
                limb3: 0
            },
            u384 {
                limb0: 9090659308802206601949834777,
                limb1: 35406434272710716703654808105,
                limb2: 944540465243729793,
                limb3: 0
            },
            u384 {
                limb0: 39355259797163742965775683504,
                limb1: 23272712308223252131313687522,
                limb2: 1260982445361222205,
                limb3: 0
            },
            u384 {
                limb0: 28042700001550849198008681913,
                limb1: 24982595235019596923961321231,
                limb2: 95632608240224482,
                limb3: 0
            },
            u384 {
                limb0: 6412376275938174193000375174,
                limb1: 22799158752248267430776274938,
                limb2: 2243313154539529760,
                limb3: 0
            },
            u384 {
                limb0: 24892008244559442082623033631,
                limb1: 58845357491964699885838999338,
                limb2: 3228301310083127681,
                limb3: 0
            },
            u384 {
                limb0: 77896097028732007700706644014,
                limb1: 21084753540801275091853963777,
                limb2: 3321347213920035253,
                limb3: 0
            },
            u384 {
                limb0: 17460523883752519092187278502,
                limb1: 7104296291779367761314070538,
                limb2: 369752805623695814,
                limb3: 0
            },
            u384 {
                limb0: 62620209405991610067701039006,
                limb1: 40099823487861722434077875039,
                limb2: 80841987526017892,
                limb3: 0
            },
            u384 {
                limb0: 7587331061174797911962954874,
                limb1: 18612757199156096520193860668,
                limb2: 190229835407925329,
                limb3: 0
            },
            u384 {
                limb0: 31009551309357584157808348993,
                limb1: 61177417538752129964281456790,
                limb2: 2655261365901462018,
                limb3: 0
            },
            u384 {
                limb0: 58186884940731683530576328238,
                limb1: 16197121838603405620708112703,
                limb2: 628810244995447976,
                limb3: 0
            },
            u384 {
                limb0: 52594768710104835041029866389,
                limb1: 75445704071926598129635180546,
                limb2: 917148657199307890,
                limb3: 0
            },
            u384 {
                limb0: 1362371658405356094629197826,
                limb1: 52170996504356009094468373097,
                limb2: 3127198546777892456,
                limb3: 0
            },
            u384 {
                limb0: 64580357531098132081498023959,
                limb1: 6462104193496910347775616392,
                limb2: 3321490422231975892,
                limb3: 0
            },
            u384 {
                limb0: 67530960341566620951506633330,
                limb1: 22125949685505124253046287262,
                limb2: 2762983886898219530,
                limb3: 0
            },
            u384 {
                limb0: 322499708343051417505398840,
                limb1: 65277051917929843363544909195,
                limb2: 3414191155133717237,
                limb3: 0
            },
            u384 {
                limb0: 267364815221167323178459963,
                limb1: 11525642836424219912752266497,
                limb2: 2483628041438676770,
                limb3: 0
            },
            u384 {
                limb0: 25253690358596365164667416632,
                limb1: 53067786640290111076947170062,
                limb2: 2105814468748767435,
                limb3: 0
            },
            u384 {
                limb0: 69817185405331131517142634842,
                limb1: 74523698158065733126488688061,
                limb2: 2939204410165642690,
                limb3: 0
            },
            u384 {
                limb0: 53501239858733417655337176603,
                limb1: 7953171541805036367312206459,
                limb2: 2260388091922254428,
                limb3: 0
            },
            u384 {
                limb0: 42675959190324458143924098404,
                limb1: 22399684814969690759336336937,
                limb2: 1317736666458652486,
                limb3: 0
            },
            u384 {
                limb0: 5187593910603894523924327009,
                limb1: 9015783822958565701157778714,
                limb2: 2720879751962340782,
                limb3: 0
            },
            u384 {
                limb0: 36509562462470225025547700235,
                limb1: 20725905240474450258718950166,
                limb2: 3382939687557154791,
                limb3: 0
            },
            u384 {
                limb0: 60321747459675039209086884630,
                limb1: 58554748933969348161092874762,
                limb2: 1222376060994509051,
                limb3: 0
            },
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
            limb0: 59724178876430620254281684935,
            limb1: 2971525965040502559172056253,
            limb2: 1011441304069634726,
            limb3: 0
        };
        assert_eq!(final_check_result, final_check);
    }


    #[test]
    fn test_run_BN254_MP_CHECK_FINALIZE_BN_3_circuit_BN254() {
        let original_Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 31929096813449206370305068365,
                limb1: 54785622682546144097089037839,
                limb2: 2668515653967507911,
                limb3: 0
            },
            x1: u384 {
                limb0: 67122667308314899450406384126,
                limb1: 75862282366552548948707479055,
                limb2: 3690122030873112,
                limb3: 0
            },
            y0: u384 {
                limb0: 67439911035932614148305743914,
                limb1: 36100094869982443221751151032,
                limb2: 3327230255729175051,
                limb3: 0
            },
            y1: u384 {
                limb0: 35190718873570430099501771512,
                limb1: 56966110383132731270552202569,
                limb2: 104245794371856868,
                limb3: 0
            }
        };

        let yInv_0: u384 = u384 {
            limb0: 37420491393722979366613420524,
            limb1: 60540143985500829748111079477,
            limb2: 3198666630119054832,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 75249532875794182585248044844,
            limb1: 15083678361629862037768953253,
            limb2: 939813328389222397,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 22074689588541089661588854764,
                limb1: 5911746202327111176647582919,
                limb2: 2279060493320119042,
                limb3: 0
            },
            x1: u384 {
                limb0: 3700258132620708577193736204,
                limb1: 58097125885905331504323694264,
                limb2: 2091088751295830302,
                limb3: 0
            },
            y0: u384 {
                limb0: 11197687105267344278320426064,
                limb1: 36703310962535190712568939717,
                limb2: 2017461864137699130,
                limb3: 0
            },
            y1: u384 {
                limb0: 12256769557021499061184749632,
                limb1: 42409108383762289806377246663,
                limb2: 3088031728240528873,
                limb3: 0
            }
        };

        let original_Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 48897386752358818127122781152,
                limb1: 59068416927686681925773724385,
                limb2: 191864074014702781,
                limb3: 0
            },
            x1: u384 {
                limb0: 54683670688519566691615792941,
                limb1: 20713746278382159900411297021,
                limb2: 2217526574167606735,
                limb3: 0
            },
            y0: u384 {
                limb0: 62732799703088563058592140666,
                limb1: 75063100652356451568020612426,
                limb2: 1965088584895884148,
                limb3: 0
            },
            y1: u384 {
                limb0: 6386362768748905711725725474,
                limb1: 61431711785590890916707704012,
                limb2: 1479248642712134365,
                limb3: 0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 10549879517878995656235909244,
            limb1: 54379339571712200960234651580,
            limb2: 473359745308805752,
            limb3: 0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 38836787771916138402466972777,
            limb1: 73640661363729188498090545507,
            limb2: 1957991927492307333,
            limb3: 0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 32591445933854261969059408437,
                limb1: 5582380112442234006362456441,
                limb2: 1486628533498629373,
                limb3: 0
            },
            x1: u384 {
                limb0: 46261533625755130938973128956,
                limb1: 27989990300064996289565592024,
                limb2: 1454553534862477373,
                limb3: 0
            },
            y0: u384 {
                limb0: 60305243931028638155814083384,
                limb1: 14261481657700868901053534,
                limb2: 2598264423191497483,
                limb3: 0
            },
            y1: u384 {
                limb0: 76214920434671259435557242956,
                limb1: 73375977262811977687713785554,
                limb2: 914726560373933870,
                limb3: 0
            }
        };

        let original_Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 27546225357481458594237984158,
                limb1: 8894165015892236228501643581,
                limb2: 1249082867940918523,
                limb3: 0
            },
            x1: u384 {
                limb0: 76846345478068611969532435407,
                limb1: 61541125220050198184939639723,
                limb2: 2723530810249470305,
                limb3: 0
            },
            y0: u384 {
                limb0: 59521332321718852406745241680,
                limb1: 17122967215563888003689262272,
                limb2: 2257941555485107441,
                limb3: 0
            },
            y1: u384 {
                limb0: 55096630417534955700825409824,
                limb1: 5419938436407173465933196480,
                limb2: 1954849332599381664,
                limb3: 0
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 74706152284443301989180207395,
            limb1: 61021045913500718111461423805,
            limb2: 1455293556098639187,
            limb3: 0
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 20070398376915029013146209591,
            limb1: 14029877122675162126192468707,
            limb2: 3235361613833154774,
            limb3: 0
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 9674472617641963990586543652,
                limb1: 31814501873488309031790630193,
                limb2: 1397642105064027733,
                limb3: 0
            },
            x1: u384 {
                limb0: 53836556613951864628792134394,
                limb1: 39002918830805359559078806183,
                limb2: 1430389255309894750,
                limb3: 0
            },
            y0: u384 {
                limb0: 46145971605070437476865846041,
                limb1: 55530888455457371064962342363,
                limb2: 1393519731502708716,
                limb3: 0
            },
            y1: u384 {
                limb0: 77131117375723520214261385121,
                limb1: 12924056764415171557540226936,
                limb2: 1704101022747020397,
                limb3: 0
            }
        };

        let R_n_minus_2 = E12D {
            w0: u384 {
                limb0: 37383013646024319685933261912,
                limb1: 21872122076385597906942856842,
                limb2: 2992784132280383636,
                limb3: 0
            },
            w1: u384 {
                limb0: 73003670198092490535771516843,
                limb1: 67888363344692981944101150358,
                limb2: 2236299994050094127,
                limb3: 0
            },
            w2: u384 {
                limb0: 40976799466313116179810284758,
                limb1: 29326934606462606937691699763,
                limb2: 3122877196612193633,
                limb3: 0
            },
            w3: u384 {
                limb0: 40238094969228054774224866857,
                limb1: 54150418673126965892568824411,
                limb2: 348572062727855075,
                limb3: 0
            },
            w4: u384 {
                limb0: 64265398139114145781165576262,
                limb1: 15863804999027842727236700904,
                limb2: 1361339409712335466,
                limb3: 0
            },
            w5: u384 {
                limb0: 33580471057793518331970261323,
                limb1: 58442146033755799485011303083,
                limb2: 1820515129481757154,
                limb3: 0
            },
            w6: u384 {
                limb0: 34929829070565526664400675774,
                limb1: 49870137782332084818578047406,
                limb2: 715098846304479894,
                limb3: 0
            },
            w7: u384 {
                limb0: 65767148926012623806793172004,
                limb1: 27723768806769711747251338458,
                limb2: 2699706968511397773,
                limb3: 0
            },
            w8: u384 {
                limb0: 45367880701402297637685358322,
                limb1: 58712989791715767560474237510,
                limb2: 538526176124821226,
                limb3: 0
            },
            w9: u384 {
                limb0: 11036186669618128695965821968,
                limb1: 67259027706196896920459442947,
                limb2: 1954509730311714093,
                limb3: 0
            },
            w10: u384 {
                limb0: 66475049407404751274051712830,
                limb1: 59425420904917962646960926954,
                limb2: 2642025687927410364,
                limb3: 0
            },
            w11: u384 {
                limb0: 29050697197408790698343603017,
                limb1: 7805810127767194991131829129,
                limb2: 2279439663835585915,
                limb3: 0
            }
        };

        let R_n_minus_1 = E12D {
            w0: u384 {
                limb0: 36892817997244993874903913503,
                limb1: 58401080270891477426231888312,
                limb2: 1184538445016061826,
                limb3: 0
            },
            w1: u384 {
                limb0: 62827905292876128559644879637,
                limb1: 18823781801195703833607129257,
                limb2: 562498258691417438,
                limb3: 0
            },
            w2: u384 {
                limb0: 46045328632761851470334625511,
                limb1: 61770480685372803311988178197,
                limb2: 737217158463715299,
                limb3: 0
            },
            w3: u384 {
                limb0: 51512992011349297672313064065,
                limb1: 19267605454683082571600302906,
                limb2: 1044427138957987513,
                limb3: 0
            },
            w4: u384 {
                limb0: 12228579240931951690388025984,
                limb1: 64226491315387103387012414378,
                limb2: 2730303644078080381,
                limb3: 0
            },
            w5: u384 {
                limb0: 5380693409027682082213629679,
                limb1: 7563114697317580210415664577,
                limb2: 2872893789976920225,
                limb3: 0
            },
            w6: u384 {
                limb0: 61803127785597368088073072719,
                limb1: 33263761286226839428548686954,
                limb2: 191402597581641221,
                limb3: 0
            },
            w7: u384 {
                limb0: 11199618788494150873362968432,
                limb1: 35772264033257249520481696213,
                limb2: 1600429016605605710,
                limb3: 0
            },
            w8: u384 {
                limb0: 19162653073669152565786733051,
                limb1: 7062896007640458320999428927,
                limb2: 3324275385087139151,
                limb3: 0
            },
            w9: u384 {
                limb0: 60626686099997136385754390398,
                limb1: 45812951411588050919291322676,
                limb2: 2525897804043189794,
                limb3: 0
            },
            w10: u384 {
                limb0: 56315881753501772626589831724,
                limb1: 45119043916109298368001777264,
                limb2: 2459297481937213224,
                limb3: 0
            },
            w11: u384 {
                limb0: 73207529981061687121347949126,
                limb1: 7521658278243136467419240356,
                limb2: 2993196962858524462,
                limb3: 0
            }
        };

        let c_n_minus_3: u384 = u384 {
            limb0: 4117425054325549108766492475,
            limb1: 61107708467002276126521089353,
            limb2: 2353769128861118759,
            limb3: 0
        };

        let w_of_z: u384 = u384 {
            limb0: 33582306178164472062595025527,
            limb1: 66785709076960808621204858370,
            limb2: 3429216567196819252,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 20369361355853926579481108364,
            limb1: 69737560141908704570217176631,
            limb2: 1220894088552277906,
            limb3: 0
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 1231472605168128212498603308,
            limb1: 20735118299237990720825393985,
            limb2: 3260283692884440815,
            limb3: 0
        };

        let c_frob_2_of_z: u384 = u384 {
            limb0: 8657098532431853044595567235,
            limb1: 34549579673642344537038075635,
            limb2: 1487726279815143201,
            limb3: 0
        };

        let c_inv_frob_3_of_z: u384 = u384 {
            limb0: 50783078282365790575598563086,
            limb1: 28323292670223673189107078761,
            limb2: 3325120837238690902,
            limb3: 0
        };

        let previous_lhs: u384 = u384 {
            limb0: 34971836057591475902785590436,
            limb1: 66380465544313959026815398297,
            limb2: 1972361035245565291,
            limb3: 0
        };

        let R_n_minus_3_of_z: u384 = u384 {
            limb0: 32494142866328035675340591534,
            limb1: 8363929977093637692030742647,
            limb2: 404892356551657426,
            limb3: 0
        };

        let Q: Array<u384> = array![
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
            },
            u384 {
                limb0: 28866776670982651674429166265,
                limb1: 74662975485556655194899826885,
                limb2: 2330771615095705061,
                limb3: 0
            },
            u384 {
                limb0: 632013528296514755416804096,
                limb1: 20425327733936575879849259107,
                limb2: 3142824068417742723,
                limb3: 0
            },
            u384 {
                limb0: 38338839738165935079253297209,
                limb1: 21828737317746345794440077012,
                limb2: 1202495322660547490,
                limb3: 0
            },
            u384 {
                limb0: 69104145854106128965634455740,
                limb1: 72691689579230710681415428521,
                limb2: 1620074044966749392,
                limb3: 0
            },
            u384 {
                limb0: 25631485344871526365393839379,
                limb1: 50135257887461643479661813105,
                limb2: 2313572786818699625,
                limb3: 0
            },
            u384 {
                limb0: 11457280740752097577477934840,
                limb1: 25424371841862185224559773091,
                limb2: 2927462573194627183,
                limb3: 0
            },
            u384 {
                limb0: 53153589666988183069730610554,
                limb1: 27937593424499576057431419869,
                limb2: 1841873406649948046,
                limb3: 0
            },
            u384 {
                limb0: 75854751898832276157500118391,
                limb1: 73571166577385078711998200023,
                limb2: 1788691490322688264,
                limb3: 0
            },
            u384 {
                limb0: 2534549364385340546528110418,
                limb1: 18346754628833872673916672260,
                limb2: 155634188977073263,
                limb3: 0
            },
            u384 {
                limb0: 33365344225620418300483762107,
                limb1: 61669251328028818598214401415,
                limb2: 734382232151272636,
                limb3: 0
            },
            u384 {
                limb0: 3697961715062195101967506413,
                limb1: 21208906385886138405320451794,
                limb2: 366917525897845849,
                limb3: 0
            },
            u384 {
                limb0: 51384015934023935640218475337,
                limb1: 61287679020071410716488263415,
                limb2: 1229786024660873765,
                limb3: 0
            },
            u384 {
                limb0: 20075911297692410695836682242,
                limb1: 75320735976135140363410755867,
                limb2: 2415528789495178864,
                limb3: 0
            },
            u384 {
                limb0: 13544265944979405951229043199,
                limb1: 69058729971310762189577984920,
                limb2: 2814089903651004249,
                limb3: 0
            },
            u384 {
                limb0: 32325984775637033452329663866,
                limb1: 54966759658533286051101803750,
                limb2: 196602272621928906,
                limb3: 0
            },
            u384 {
                limb0: 2380341882351557165844524472,
                limb1: 12572265171621387226593626884,
                limb2: 793134402033118394,
                limb3: 0
            },
            u384 {
                limb0: 50938918480510485813628996742,
                limb1: 67951499623144928274471750182,
                limb2: 873790222361372928,
                limb3: 0
            },
            u384 {
                limb0: 28814089384047499620563443367,
                limb1: 68883500388481643085983416890,
                limb2: 1051681892290220441,
                limb3: 0
            },
            u384 {
                limb0: 58137963613476351273975217795,
                limb1: 63812476850260035592453914132,
                limb2: 3450400438247453672,
                limb3: 0
            },
            u384 {
                limb0: 50030575269394277072712783575,
                limb1: 30505552541548071380706634862,
                limb2: 2766449105048849461,
                limb3: 0
            },
            u384 {
                limb0: 68819117473531699502032432810,
                limb1: 48696902204805108335293828631,
                limb2: 2279702102002729671,
                limb3: 0
            },
            u384 {
                limb0: 31081599290562405746053704439,
                limb1: 53774368270652558711364016654,
                limb2: 1758318411203088138,
                limb3: 0
            },
            u384 {
                limb0: 65544707852764210527666409203,
                limb1: 57098843080913037403190639527,
                limb2: 3453719093945273117,
                limb3: 0
            },
            u384 {
                limb0: 5004721907736741480475458642,
                limb1: 12540106802669398813604111453,
                limb2: 2621892678422792863,
                limb3: 0
            },
            u384 {
                limb0: 13973445976662057785291907245,
                limb1: 41326209541174119695269154586,
                limb2: 2973927465201661556,
                limb3: 0
            },
            u384 {
                limb0: 42662557740841501963406439067,
                limb1: 38860703102907847382416873781,
                limb2: 553248268538025122,
                limb3: 0
            },
            u384 {
                limb0: 24966454190043522741558369444,
                limb1: 57178172095830049764621899738,
                limb2: 1731298625296730532,
                limb3: 0
            },
            u384 {
                limb0: 33424607147745241576594153718,
                limb1: 51984097601846168312677030386,
                limb2: 1875460909735140404,
                limb3: 0
            },
            u384 {
                limb0: 56447912740539441840606134247,
                limb1: 2322705178440946695859182086,
                limb2: 3130071248594892821,
                limb3: 0
            },
            u384 {
                limb0: 75129641846285220828599377172,
                limb1: 43519802011487355017993993763,
                limb2: 2416178625130043797,
                limb3: 0
            },
            u384 {
                limb0: 58952956480976101579132584455,
                limb1: 71293750442196727725220758666,
                limb2: 2666310639925015996,
                limb3: 0
            },
            u384 {
                limb0: 46518098871267527078920936546,
                limb1: 48104610675088002114718810509,
                limb2: 969597673282878098,
                limb3: 0
            },
            u384 {
                limb0: 5283327071257305812768393240,
                limb1: 13097284696814904934284512801,
                limb2: 2796253884674152378,
                limb3: 0
            },
            u384 {
                limb0: 61421455605293778540467791599,
                limb1: 73077698493797017249069924062,
                limb2: 1216575404618065704,
                limb3: 0
            },
            u384 {
                limb0: 42395421483881524831781561112,
                limb1: 47153797802041227143409572710,
                limb2: 1414485597461953171,
                limb3: 0
            },
            u384 {
                limb0: 39923695507235711151696979108,
                limb1: 5058746645318451340765082729,
                limb2: 1567813266352340119,
                limb3: 0
            },
            u384 {
                limb0: 2137382159614158857332258116,
                limb1: 6177677041600800985613646594,
                limb2: 2414416421961072073,
                limb3: 0
            },
            u384 {
                limb0: 49824485057935950079272697937,
                limb1: 10725992906473255777847575680,
                limb2: 1191151569273001162,
                limb3: 0
            },
            u384 {
                limb0: 26132179255741140992801178489,
                limb1: 7976585730141206524078235383,
                limb2: 3122829839809020727,
                limb3: 0
            },
            u384 {
                limb0: 52082085019880137836913796196,
                limb1: 45961779402901139126530077491,
                limb2: 832377664399722071,
                limb3: 0
            },
            u384 {
                limb0: 52064657877169960843575624052,
                limb1: 32084046972305912667870267667,
                limb2: 2918592749392623273,
                limb3: 0
            },
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
            limb0: 24526927939551269587992109034,
            limb1: 4016562779802078940005132838,
            limb2: 3069135618690925336,
            limb3: 0
        };
        assert_eq!(final_check_result, final_check);
    }


    #[test]
    fn test_run_BN254_MP_CHECK_INIT_BIT_2_circuit_BN254() {
        let yInv_0: u384 = u384 {
            limb0: 8436736687330539318791550220,
            limb1: 14893282171954378934371235271,
            limb2: 217312682037417590,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 20169690185504152538593895356,
            limb1: 24627590954014138784258986803,
            limb2: 177416878818280418,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 44399814541956825741234811494,
                limb1: 51338162914211177306418257884,
                limb2: 1263142333440202247,
                limb3: 0
            },
            x1: u384 {
                limb0: 33241493633556792548263266205,
                limb1: 58213394946693329387754946189,
                limb2: 1825074075170186156,
                limb3: 0
            },
            y0: u384 {
                limb0: 37950966781329938835011766782,
                limb1: 42428840709666089535363157638,
                limb2: 2019548025316975755,
                limb3: 0
            },
            y1: u384 {
                limb0: 2662162581436215061160468738,
                limb1: 41319727535882258318374758051,
                limb2: 2349358027132720653,
                limb3: 0
            }
        };

        let yInv_1: u384 = u384 {
            limb0: 24504361670110187154243459873,
            limb1: 41330714160711574837501003389,
            limb2: 1602171186428807617,
            limb3: 0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 31068674151227685874282217044,
            limb1: 77159390331424787984504208935,
            limb2: 847440450561048653,
            limb3: 0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 32302619734423098930542685956,
                limb1: 25065779761686729548796304009,
                limb2: 3459744820240614426,
                limb3: 0
            },
            x1: u384 {
                limb0: 17464532406627659303395661671,
                limb1: 50838038698646719537214482093,
                limb2: 879110948454948392,
                limb3: 0
            },
            y0: u384 {
                limb0: 7766050973058504395126359892,
                limb1: 13496660373176857920382759414,
                limb2: 2971419355571939611,
                limb3: 0
            },
            y1: u384 {
                limb0: 70488807004167945851580558525,
                limb1: 60266322006558371884650139803,
                limb2: 1447031213145768050,
                limb3: 0
            }
        };

        let R_i = E12D {
            w0: u384 {
                limb0: 68652363622391896691548157163,
                limb1: 71590476185503395459284349466,
                limb2: 556296320186746532,
                limb3: 0
            },
            w1: u384 {
                limb0: 48970255773288294031132880826,
                limb1: 31634871561716177005379903234,
                limb2: 1435182316460810781,
                limb3: 0
            },
            w2: u384 {
                limb0: 24919153742992842556802789114,
                limb1: 130034321325176858648922344,
                limb2: 2175637043055850216,
                limb3: 0
            },
            w3: u384 {
                limb0: 70590593608968827887267376732,
                limb1: 65027798886365151293818140789,
                limb2: 1989256348301490822,
                limb3: 0
            },
            w4: u384 {
                limb0: 45586510869709030398016785436,
                limb1: 32206473263892644171114627753,
                limb2: 1215007074043178982,
                limb3: 0
            },
            w5: u384 {
                limb0: 25892680486105489857545959366,
                limb1: 14326292638442238490394943009,
                limb2: 3221947841678541130,
                limb3: 0
            },
            w6: u384 {
                limb0: 18518290914818918512858840057,
                limb1: 641147932105966346159805219,
                limb2: 2465301084834809975,
                limb3: 0
            },
            w7: u384 {
                limb0: 58712917790692182310368421174,
                limb1: 67166948205804054822679327738,
                limb2: 2399094484452375856,
                limb3: 0
            },
            w8: u384 {
                limb0: 73549195812559701950068368734,
                limb1: 37608413100817446569655225095,
                limb2: 1705616585298464,
                limb3: 0
            },
            w9: u384 {
                limb0: 46175012992090631706023952691,
                limb1: 29113664974231617401603587914,
                limb2: 1555639245517579223,
                limb3: 0
            },
            w10: u384 {
                limb0: 50765213597479777785721101234,
                limb1: 40963402582106368657991311623,
                limb2: 1160845638058944183,
                limb3: 0
            },
            w11: u384 {
                limb0: 56635611217506672887878641935,
                limb1: 1911913716890414130495628653,
                limb2: 654385467914839345,
                limb3: 0
            }
        };

        let c0: u384 = u384 {
            limb0: 15976839731542164805609032545,
            limb1: 39643406941001030750618906694,
            limb2: 2580691199795836389,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 72181655488159272013108874211,
            limb1: 40326887468098580618380581546,
            limb2: 2064607997252674786,
            limb3: 0
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 36041098325779233182029497004,
            limb1: 10211065230958409234146588318,
            limb2: 1173371722591452804,
            limb3: 0
        };

        let previous_lhs: u384 = u384 {
            limb0: 19685831582634456606235603946,
            limb1: 61419260299906231527930745625,
            limb2: 1892091242894949548,
            limb3: 0
        };

        let (Q0_result, Q1_result, new_lhs_result, c_i_result, f_i_plus_one_of_z_result) =
            run_BN254_MP_CHECK_INIT_BIT_2_circuit(
            yInv_0, xNegOverY_0, Q0, yInv_1, xNegOverY_1, Q1, R_i, c0, z, c_inv_of_z, previous_lhs
        );
        let Q0: G2Point = G2Point {
            x0: u384 {
                limb0: 35979061174568858872210709706,
                limb1: 54015644715047811118239555437,
                limb2: 2753357348605503653,
                limb3: 0
            },
            x1: u384 {
                limb0: 32476673015836046054056895124,
                limb1: 60679169268160490704027697232,
                limb2: 3179553710389041463,
                limb3: 0
            },
            y0: u384 {
                limb0: 69713342386186006343860126318,
                limb1: 9003465679953651529173572572,
                limb2: 877983206971440110,
                limb3: 0
            },
            y1: u384 {
                limb0: 19983554935071813661935280609,
                limb1: 64370498564390543558403126061,
                limb2: 3426339749143287146,
                limb3: 0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 7479639266809992592536168147,
                limb1: 64158502386793107345192535523,
                limb2: 600290742046710915,
                limb3: 0
            },
            x1: u384 {
                limb0: 15333813775210744759683541796,
                limb1: 9555468603043992771932484476,
                limb2: 1311560053879586174,
                limb3: 0
            },
            y0: u384 {
                limb0: 18068682888026273093622921,
                limb1: 23876276017950312850804430188,
                limb2: 531853916401029333,
                limb3: 0
            },
            y1: u384 {
                limb0: 75697871580026675203923863627,
                limb1: 41682847266337500596742395046,
                limb2: 3481347153331003037,
                limb3: 0
            }
        };

        let new_lhs: u384 = u384 {
            limb0: 812077316939372236513945037,
            limb1: 6512209281933347541097811827,
            limb2: 2519514860943327781,
            limb3: 0
        };

        let c_i: u384 = u384 {
            limb0: 41348179085229001866877532914,
            limb1: 19948580139174606941964807942,
            limb2: 2065289114160507314,
            limb3: 0
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 57184833788492784102073450595,
            limb1: 52455064633207685933157811245,
            limb2: 1507667772388064498,
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
            limb0: 42614890725717984271195967867,
            limb1: 49265756029185915352823390771,
            limb2: 742778130523002825,
            limb3: 0
        };

        let xNegOverY_0: u384 = u384 {
            limb0: 35959512528527022700017035821,
            limb1: 8596087296127202567195763781,
            limb2: 235393588143160956,
            limb3: 0
        };

        let Q0: G2Point = G2Point {
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

        let yInv_1: u384 = u384 {
            limb0: 75781454632302476965322751821,
            limb1: 2683333440586778895183679049,
            limb2: 56073559126439557,
            limb3: 0
        };

        let xNegOverY_1: u384 = u384 {
            limb0: 62666600962572378431255034614,
            limb1: 60931300856343389865144345777,
            limb2: 2215229874800095982,
            limb3: 0
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 31512483911210207970476733575,
                limb1: 12755456016173942442305645318,
                limb2: 1670073148330615779,
                limb3: 0
            },
            x1: u384 {
                limb0: 39677605067094766095519514752,
                limb1: 38029896677842630225141759135,
                limb2: 1988961841116757001,
                limb3: 0
            },
            y0: u384 {
                limb0: 36065897565026407402822424969,
                limb1: 5642778421096624600511880406,
                limb2: 1374133222330426886,
                limb3: 0
            },
            y1: u384 {
                limb0: 4866520791238069053055753473,
                limb1: 41885997802588735672954636507,
                limb2: 2675358903281057145,
                limb3: 0
            }
        };

        let yInv_2: u384 = u384 {
            limb0: 57586357294587522539965950398,
            limb1: 53666321073120892400135537485,
            limb2: 3119722154478468708,
            limb3: 0
        };

        let xNegOverY_2: u384 = u384 {
            limb0: 65822080864228896420962152147,
            limb1: 10691993175746280139660318242,
            limb2: 3382606722338183660,
            limb3: 0
        };

        let Q2: G2Point = G2Point {
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

        let R_i = E12D {
            w0: u384 {
                limb0: 57355407802952232347002109325,
                limb1: 41136087046772969438560595665,
                limb2: 2503121083105756304,
                limb3: 0
            },
            w1: u384 {
                limb0: 47099998407085857757075303179,
                limb1: 12054436728086864517720143117,
                limb2: 3176228236232214552,
                limb3: 0
            },
            w2: u384 {
                limb0: 71214560539815909844506915169,
                limb1: 73587625385874626062469017234,
                limb2: 2758082330296836740,
                limb3: 0
            },
            w3: u384 {
                limb0: 19249948755232897653393997052,
                limb1: 47851313726077813442024944844,
                limb2: 1465074839335292610,
                limb3: 0
            },
            w4: u384 {
                limb0: 15559743507936529575039347037,
                limb1: 4933121752200094085296535090,
                limb2: 1119946687609630195,
                limb3: 0
            },
            w5: u384 {
                limb0: 53415950094176208175010075009,
                limb1: 52356443885689500673772039249,
                limb2: 502923712475740624,
                limb3: 0
            },
            w6: u384 {
                limb0: 59994819647147234910502696701,
                limb1: 73254895354466208318312831185,
                limb2: 2924111405446491279,
                limb3: 0
            },
            w7: u384 {
                limb0: 70149534095998784879408293365,
                limb1: 39093529419513935678603442101,
                limb2: 886117937259836742,
                limb3: 0
            },
            w8: u384 {
                limb0: 44159279369173998090423121632,
                limb1: 56846673481420923847174942749,
                limb2: 1802328820865981287,
                limb3: 0
            },
            w9: u384 {
                limb0: 52546727230028840960173780162,
                limb1: 78582390663913760313492206645,
                limb2: 310473554228695835,
                limb3: 0
            },
            w10: u384 {
                limb0: 36752281456572119649762728627,
                limb1: 16639497179252436776216649737,
                limb2: 1696530043009905383,
                limb3: 0
            },
            w11: u384 {
                limb0: 1685826783340539348513163453,
                limb1: 6937873060060689181816957783,
                limb2: 1901569277590821463,
                limb3: 0
            }
        };

        let c0: u384 = u384 {
            limb0: 69238161660661937232108690614,
            limb1: 42850067641650218881786886268,
            limb2: 2920942860173916462,
            limb3: 0
        };

        let z: u384 = u384 {
            limb0: 30118537958020207789746262065,
            limb1: 5232646377878285644055052519,
            limb2: 2789361769079530542,
            limb3: 0
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 39038642117437292429920446803,
            limb1: 16159100659374509497653780633,
            limb2: 2845472305631074125,
            limb3: 0
        };

        let previous_lhs: u384 = u384 {
            limb0: 12151975343442127049480534287,
            limb1: 8729794004627307850677060432,
            limb2: 2062128962316845007,
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
                limb0: 19251192001347628047728699154,
                limb1: 63143911230450336092700152960,
                limb2: 3442555680242623703,
                limb3: 0
            },
            x1: u384 {
                limb0: 44786618999801383165931836215,
                limb1: 14384520143422552559303688824,
                limb2: 3203431721500245216,
                limb3: 0
            },
            y0: u384 {
                limb0: 22704708157614631553358224521,
                limb1: 68364880463274458861820037848,
                limb2: 1348472765744500318,
                limb3: 0
            },
            y1: u384 {
                limb0: 46585022162272559020736082,
                limb1: 32538928614493388437197272433,
                limb2: 1532720394943760146,
                limb3: 0
            }
        };

        let Q1: G2Point = G2Point {
            x0: u384 {
                limb0: 18744368379070650790001745951,
                limb1: 77984972866710145916156554266,
                limb2: 2227383209925463996,
                limb3: 0
            },
            x1: u384 {
                limb0: 57564723241604907459808333123,
                limb1: 27787634208160212889606174128,
                limb2: 370636501365627048,
                limb3: 0
            },
            y0: u384 {
                limb0: 41325540127050167594082984105,
                limb1: 885439653924479587871622609,
                limb2: 722079692841878352,
                limb3: 0
            },
            y1: u384 {
                limb0: 26459057241028324962499598171,
                limb1: 3871883677630902646846950621,
                limb2: 906874523907229381,
                limb3: 0
            }
        };

        let Q2: G2Point = G2Point {
            x0: u384 {
                limb0: 67270890016137884064853655819,
                limb1: 49088054909869782536336699278,
                limb2: 504089350346896475,
                limb3: 0
            },
            x1: u384 {
                limb0: 34398739751257789402747675688,
                limb1: 32226414856372423564390257011,
                limb2: 304409488928690665,
                limb3: 0
            },
            y0: u384 {
                limb0: 73425767737133513168006657185,
                limb1: 29560731902110064219378607864,
                limb2: 1423746059154951283,
                limb3: 0
            },
            y1: u384 {
                limb0: 35939822483355883618890250998,
                limb1: 49958749001378723071458669360,
                limb2: 2131277108588970910,
                limb3: 0
            }
        };

        let new_lhs: u384 = u384 {
            limb0: 3718128980213553535037556628,
            limb1: 7964142153066354541314875581,
            limb2: 277496136779861141,
            limb3: 0
        };

        let c_i: u384 = u384 {
            limb0: 75292785982145018084782423814,
            limb1: 70105346298443986114814411235,
            limb2: 924924918540852994,
            limb3: 0
        };

        let f_i_plus_one_of_z: u384 = u384 {
            limb0: 6134980251612219339270883039,
            limb1: 34884967620921470171284255290,
            limb2: 282977932475493674,
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
                limb0: 73955362770057848882111020916,
                limb1: 11305331660430972841921856160,
                limb2: 1649237130484661850,
                limb3: 0
            },
            w1: u384 {
                limb0: 14015287804042660151540585764,
                limb1: 25723101760383619261592269199,
                limb2: 1752963995163783886,
                limb3: 0
            },
            w2: u384 {
                limb0: 23064143363136065070009257005,
                limb1: 2765135843393035962008918388,
                limb2: 1893313542256730901,
                limb3: 0
            },
            w3: u384 {
                limb0: 57668269013120043253904814220,
                limb1: 10629463913098397361201934781,
                limb2: 508664097103215486,
                limb3: 0
            },
            w4: u384 {
                limb0: 13132704165771850143472419052,
                limb1: 45690579751419802437512227406,
                limb2: 2137605581412589417,
                limb3: 0
            },
            w5: u384 {
                limb0: 56312988188237726813438070059,
                limb1: 6165932981199454388095043920,
                limb2: 1961939925987070678,
                limb3: 0
            },
            w6: u384 {
                limb0: 43885808331711628552423042426,
                limb1: 12119389645993665012307570078,
                limb2: 758491092220664492,
                limb3: 0
            },
            w7: u384 {
                limb0: 58302283039662639128435121361,
                limb1: 62845779268386337754279900328,
                limb2: 3155281507649443630,
                limb3: 0
            },
            w8: u384 {
                limb0: 55076052719734784260582682052,
                limb1: 29800798926802856777603037758,
                limb2: 3411721698306364697,
                limb3: 0
            },
            w9: u384 {
                limb0: 24183791119880028431831289387,
                limb1: 72479818074391934199740929246,
                limb2: 1745830259340366309,
                limb3: 0
            },
            w10: u384 {
                limb0: 75164736444848672102482833490,
                limb1: 24256376622029447206460022123,
                limb2: 1891257903402342694,
                limb3: 0
            },
            w11: u384 {
                limb0: 64407908820215540787274869508,
                limb1: 77106348553075271644473439327,
                limb2: 680897993778232857,
                limb3: 0
            }
        };

        let z: u384 = u384 {
            limb0: 55209875852685193781652355136,
            limb1: 55306856926399327576239573858,
            limb2: 2747577437254952230,
            limb3: 0
        };

        let scaling_factor: MillerLoopResultScalingFactor = MillerLoopResultScalingFactor {
            w0: u384 {
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
            w4: u384 {
                limb0: 64758244199314254565995779732,
                limb1: 25222577286414459867275418662,
                limb2: 3117382642239996401,
                limb3: 0
            },
            w6: u384 {
                limb0: 67848466570559193034261753427,
                limb1: 70191544040125742712630265117,
                limb2: 118896270411703166,
                limb3: 0
            },
            w8: u384 {
                limb0: 67309566965325298154031429163,
                limb1: 78731803720596620846254286313,
                limb2: 1885724716587762026,
                limb3: 0
            },
            w10: u384 {
                limb0: 16486053105978210888132758738,
                limb1: 54165843460295958344539892670,
                limb2: 1218073467282208473,
                limb3: 0
            }
        };

        let c_inv = E12D {
            w0: u384 {
                limb0: 10637736581276740872202573407,
                limb1: 13574556094113647884803951072,
                limb2: 2033581497069020375,
                limb3: 0
            },
            w1: u384 {
                limb0: 72593361513602150287445855969,
                limb1: 63568218407633871508674389779,
                limb2: 2970189470054756956,
                limb3: 0
            },
            w2: u384 {
                limb0: 26504041808206168725568964881,
                limb1: 69199175886302684603409507936,
                limb2: 180344751002568193,
                limb3: 0
            },
            w3: u384 {
                limb0: 8065887409496938898341597165,
                limb1: 40208310316078105698257927424,
                limb2: 2540080683578227919,
                limb3: 0
            },
            w4: u384 {
                limb0: 37449469184147634284849391499,
                limb1: 18204306027512824630904301582,
                limb2: 1680139565832012718,
                limb3: 0
            },
            w5: u384 {
                limb0: 67516596723133538645904431284,
                limb1: 72636819603573513631064533405,
                limb2: 2107175956069581514,
                limb3: 0
            },
            w6: u384 {
                limb0: 5426488480244224812914819524,
                limb1: 44852668295603369426664393406,
                limb2: 1890710114633680403,
                limb3: 0
            },
            w7: u384 {
                limb0: 21037182806557947695051257850,
                limb1: 64529124235386424376472075250,
                limb2: 1368258125783773058,
                limb3: 0
            },
            w8: u384 {
                limb0: 64322434779221628227453533735,
                limb1: 52166777173220298294694650254,
                limb2: 261521769250366329,
                limb3: 0
            },
            w9: u384 {
                limb0: 10839110021676362708303216760,
                limb1: 15727024575208981722372016133,
                limb2: 152478803691462598,
                limb3: 0
            },
            w10: u384 {
                limb0: 44231270463284578087009674878,
                limb1: 47673388752408039179187209260,
                limb2: 3293285524865238374,
                limb3: 0
            },
            w11: u384 {
                limb0: 7727324451163395984018494332,
                limb1: 19148580741642502529474139817,
                limb2: 2295425438161682615,
                limb3: 0
            }
        };

        let c_0: u384 = u384 {
            limb0: 24679213248894779945634340966,
            limb1: 710840269509446185907310043,
            limb2: 1636526625172595363,
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
            limb0: 10113454306249608874013815587,
            limb1: 8469659913684241835975024193,
            limb2: 3354241974032641102,
            limb3: 0
        };

        let scaling_factor_of_z: u384 = u384 {
            limb0: 40004111974245422455084827081,
            limb1: 26777386998462487132721494230,
            limb2: 2421617065081589416,
            limb3: 0
        };

        let c_inv_of_z: u384 = u384 {
            limb0: 52481048651057678051398988582,
            limb1: 7636492054791143979373548420,
            limb2: 1797880032790175150,
            limb3: 0
        };

        let lhs: u384 = u384 {
            limb0: 72136202568765376236465559721,
            limb1: 60147387928287444386264455240,
            limb2: 1799483691734666777,
            limb3: 0
        };

        let c_inv_frob_1_of_z: u384 = u384 {
            limb0: 70223080942565258915380792109,
            limb1: 68159850705241073977643607613,
            limb2: 1507246194560406457,
            limb3: 0
        };

        let c_frob_2_of_z: u384 = u384 {
            limb0: 11462910544081125922508675873,
            limb1: 42819823630259236739771881003,
            limb2: 3469400611012510638,
            limb3: 0
        };

        let c_inv_frob_3_of_z: u384 = u384 {
            limb0: 33956324626302579502480183840,
            limb1: 10520394465303686011257649284,
            limb2: 3181713012624468364,
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
                limb0: 1460919488391403584707437445,
                limb1: 32740733855413454919989260855,
                limb2: 3312386017676031604,
                limb3: 0
            },
            y: u384 {
                limb0: 64239921957959740773185726562,
                limb1: 17046125465325680736363791779,
                limb2: 2344307043140535701,
                limb3: 0
            }
        };

        let Qy0_0: u384 = u384 {
            limb0: 23470482717836997631536197043,
            limb1: 46303497922699478825839031908,
            limb2: 3357104927878383050,
            limb3: 0
        };

        let Qy1_0: u384 = u384 {
            limb0: 3693059289487175868275819995,
            limb1: 32796102247879431765420080329,
            limb2: 822273181009806519,
            limb3: 0
        };

        let p_1: G1Point = G1Point {
            x: u384 {
                limb0: 46896721706606870132051272417,
                limb1: 1352959753330217202863730983,
                limb2: 2498961738221087250,
                limb3: 0
            },
            y: u384 {
                limb0: 38319424800458183675506071907,
                limb1: 22267536658110947240240909700,
                limb2: 3231788605519469929,
                limb3: 0
            }
        };

        let Qy0_1: u384 = u384 {
            limb0: 41978728299607522992283864882,
            limb1: 42671996334397429921255623748,
            limb2: 425070741442700381,
            limb3: 0
        };

        let Qy1_1: u384 = u384 {
            limb0: 13509286536817450982807349151,
            limb1: 32382112185483478884475776596,
            limb2: 858945581748338412,
            limb3: 0
        };

        let (p_0_result, p_1_result) = run_BN254_MP_CHECK_PREPARE_PAIRS_2_circuit(
            p_0, Qy0_0, Qy1_0, p_1, Qy0_1, Qy1_1
        );
        let p_0: BNProcessedPair = BNProcessedPair {
            yInv: u384 {
                limb0: 57011380306817652490709681975,
                limb1: 78821727495295582906218196669,
                limb2: 1301834067660943918,
                limb3: 0
            },
            xNegOverY: u384 {
                limb0: 20939397936465622929922317450,
                limb1: 55443948572467482667897130297,
                limb2: 1383732076845488628,
                limb3: 0
            },
            QyNeg0: u384 {
                limb0: 8853523444552413545242431380,
                limb1: 10738787159923760636040737837,
                limb2: 129893338924587615,
                limb3: 0
            },
            QyNeg1: u384 {
                limb0: 28630946872902235308502808428,
                limb1: 24246182834743807696459689416,
                limb2: 2664725085793164146,
                limb3: 0
            }
        };

        let p_1: BNProcessedPair = BNProcessedPair {
            yInv: u384 {
                limb0: 72402353196382020788150983616,
                limb1: 45192978955482715708105240391,
                limb2: 3413036606119788248,
                limb3: 0
            },
            xNegOverY: u384 {
                limb0: 25675156318222312945815757675,
                limb1: 6826057401433888291868297225,
                limb2: 1502655196920756476,
                limb3: 0
            },
            QyNeg0: u384 {
                limb0: 69573440377046225778038713877,
                limb1: 14370288748225809540624145996,
                limb2: 3061927525360270284,
                limb3: 0
            },
            QyNeg1: u384 {
                limb0: 18814719625571960193971279272,
                limb1: 24660172897139760577403993149,
                limb2: 2628052685054632253,
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
                limb0: 17463371978957606967426645910,
                limb1: 46633192462276396956509381322,
                limb2: 2039381653746947174,
                limb3: 0
            },
            y: u384 {
                limb0: 46826665369323305637219806716,
                limb1: 15827076858150522101941310339,
                limb2: 79675863563346525,
                limb3: 0
            }
        };

        let Qy0_0: u384 = u384 {
            limb0: 60464185271160186329667085333,
            limb1: 47362811318260235809669271215,
            limb2: 2759540647010765696,
            limb3: 0
        };

        let Qy1_0: u384 = u384 {
            limb0: 75367372857432921812806258040,
            limb1: 48923144314324076921700985484,
            limb2: 772041197732904878,
            limb3: 0
        };

        let p_1: G1Point = G1Point {
            x: u384 {
                limb0: 34469268177532267239172196943,
                limb1: 64085060327039124260764414987,
                limb2: 2778381038406882375,
                limb3: 0
            },
            y: u384 {
                limb0: 16174288217937365390881565706,
                limb1: 54544482347055253032647517285,
                limb2: 1783571935245424777,
                limb3: 0
            }
        };

        let Qy0_1: u384 = u384 {
            limb0: 13297768232700519033928087638,
            limb1: 48329425422938152995668851685,
            limb2: 1569681888374257932,
            limb3: 0
        };

        let Qy1_1: u384 = u384 {
            limb0: 22129694352507552413722987028,
            limb1: 4050596519157542830646697090,
            limb2: 2704965446325434880,
            limb3: 0
        };

        let p_2: G1Point = G1Point {
            x: u384 {
                limb0: 21283337468805558033905394712,
                limb1: 54303367948408393254155425412,
                limb2: 943103654983769995,
                limb3: 0
            },
            y: u384 {
                limb0: 70596304535654254379897033196,
                limb1: 12281396721914970534044442752,
                limb2: 3352623565113347547,
                limb3: 0
            }
        };

        let Qy0_2: u384 = u384 {
            limb0: 74052818514397875358906432980,
            limb1: 75925806636686796497163771692,
            limb2: 939361765672686198,
            limb3: 0
        };

        let Qy1_2: u384 = u384 {
            limb0: 30224732042144277812581889451,
            limb1: 24765172145772633258597651056,
            limb2: 184585862802225558,
            limb3: 0
        };

        let (p_0_result, p_1_result, p_2_result) = run_BN254_MP_CHECK_PREPARE_PAIRS_3_circuit(
            p_0, Qy0_0, Qy1_0, p_1, Qy0_1, Qy1_1, p_2, Qy0_2, Qy1_2
        );
        let p_0: BNProcessedPair = BNProcessedPair {
            yInv: u384 {
                limb0: 46749866867682761464687842785,
                limb1: 57081181046757595125079477460,
                limb2: 2180233761696385884,
                limb3: 0
            },
            xNegOverY: u384 {
                limb0: 58008282851868232713016740245,
                limb1: 6400647170887386018933774572,
                limb2: 3454011542180854243,
                limb3: 0
            },
            QyNeg0: u384 {
                limb0: 51087983405493562440655493426,
                limb1: 9679473764363003652210498529,
                limb2: 727457619792204969,
                limb3: 0
            },
            QyNeg1: u384 {
                limb0: 36184795819220826957516320719,
                limb1: 8119140768299162540178784260,
                limb2: 2714957069070065787,
                limb3: 0
            }
        };

        let p_1: BNProcessedPair = BNProcessedPair {
            yInv: u384 {
                limb0: 54248374338152169713965634784,
                limb1: 32527530049632567891507557521,
                limb2: 2737438786982809714,
                limb3: 0
            },
            xNegOverY: u384 {
                limb0: 55592572178659692972316780345,
                limb1: 46661440435435862330997290882,
                limb2: 413922791001683955,
                limb3: 0
            },
            QyNeg0: u384 {
                limb0: 19026237929688892142850540785,
                limb1: 8712859659685086466210918060,
                limb2: 1917316378428712733,
                limb3: 0
            },
            QyNeg1: u384 {
                limb0: 10194311809881858763055641395,
                limb1: 52991688563465696631233072655,
                limb2: 782032820477535785,
                limb3: 0
            }
        };

        let p_2: BNProcessedPair = BNProcessedPair {
            yInv: u384 {
                limb0: 52598709843883579211074535735,
                limb1: 14509582835089137227087182999,
                limb2: 11404515082357178,
                limb3: 0
            },
            xNegOverY: u384 {
                limb0: 11064484307331630916135323474,
                limb1: 28682439524117427189510419961,
                limb2: 2821273818780162002,
                limb3: 0
            },
            QyNeg0: u384 {
                limb0: 37499350162255873411416145779,
                limb1: 60344640960200780558259948388,
                limb2: 2547636501130284466,
                limb3: 0
            },
            QyNeg1: u384 {
                limb0: 2099274120245133364196738972,
                limb1: 32277112936850606203282118689,
                limb2: 3302412404000745107,
                limb3: 0
            }
        };
        assert_eq!(p_0_result, p_0);
        assert_eq!(p_1_result, p_1);
        assert_eq!(p_2_result, p_2);
    }
}
