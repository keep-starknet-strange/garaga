use core::circuit::{
    CircuitElement as CE, CircuitInput as CI, CircuitInputs, CircuitModulus, CircuitOutputsTrait,
    EvalCircuitTrait, circuit_add, circuit_inverse, circuit_mul, circuit_sub, u384,
};
use garaga::core::circuit::{AddInputResultTrait2, IntoCircuitInputValue, u288IntoCircuitInputValue};
use garaga::definitions::{G1Point, get_BN254_modulus, get_GRUMPKIN_modulus};
use garaga::ec_ops::FunctionFelt;

#[inline(always)]
pub fn run_GRUMPKIN_HONK_SUMCHECK_SIZE_5_PUB_1_circuit(
    p_public_inputs: Span<u256>,
    p_public_inputs_offset: u384,
    sumcheck_univariates_flat: Span<u256>,
    sumcheck_evaluations: Span<u256>,
    tp_sum_check_u_challenges: Span<u128>,
    tp_gate_challenges: Span<u128>,
    tp_eta_1: u128,
    tp_eta_2: u128,
    tp_eta_3: u128,
    tp_beta: u128,
    tp_gamma: u128,
    tp_base_rlc: u384,
    tp_alphas: Span<u128>,
) -> (u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x1
    let in1 = CE::<CI<1>> {}; // 0x20
    let in2 = CE::<CI<2>> {}; // 0x0
    let in3 = CE::<CI<3>> {}; // 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593efffec51
    let in4 = CE::<CI<4>> {}; // 0x2d0
    let in5 = CE::<CI<5>> {}; // 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593efffff11
    let in6 = CE::<CI<6>> {}; // 0x90
    let in7 = CE::<CI<7>> {}; // 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593efffff71
    let in8 = CE::<CI<8>> {}; // 0xf0
    let in9 = CE::<CI<9>> {}; // 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593effffd31
    let in10 = CE::<CI<10>> {}; // 0x13b0
    let in11 = CE::<CI<11>> {}; // 0x2
    let in12 = CE::<CI<12>> {}; // 0x3
    let in13 = CE::<CI<13>> {}; // 0x4
    let in14 = CE::<CI<14>> {}; // 0x5
    let in15 = CE::<CI<15>> {}; // 0x6
    let in16 = CE::<CI<16>> {}; // 0x7
    let in17 = CE::<
        CI<17>,
    > {}; // 0x183227397098d014dc2822db40c0ac2e9419f4243cdcb848a1f0fac9f8000000
    let in18 = CE::<CI<18>> {}; // -0x1 % p
    let in19 = CE::<CI<19>> {}; // 0x11
    let in20 = CE::<CI<20>> {}; // 0x9
    let in21 = CE::<CI<21>> {}; // 0x100000000000000000
    let in22 = CE::<CI<22>> {}; // 0x4000
    let in23 = CE::<
        CI<23>,
    > {}; // 0x10dc6e9c006ea38b04b1e03b4bd9490c0d03f98929ca1d7fb56821fd19d3b6e7
    let in24 = CE::<CI<24>> {}; // 0xc28145b6a44df3e0149b3d0a30b3bb599df9756d4dd9b84a86b38cfb45a740b
    let in25 = CE::<CI<25>> {}; // 0x544b8338791518b2c7645a50392798b21f75bb60e3596170067d00141cac15
    let in26 = CE::<
        CI<26>,
    > {}; // 0x222c01175718386f2e2e82eb122789e352e105a3b8fa852613bc534433ee428b

    // INPUT stack
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
    let (in126, in127, in128) = (CE::<CI<126>> {}, CE::<CI<127>> {}, CE::<CI<128>> {});
    let (in129, in130, in131) = (CE::<CI<129>> {}, CE::<CI<130>> {}, CE::<CI<131>> {});
    let (in132, in133, in134) = (CE::<CI<132>> {}, CE::<CI<133>> {}, CE::<CI<134>> {});
    let (in135, in136, in137) = (CE::<CI<135>> {}, CE::<CI<136>> {}, CE::<CI<137>> {});
    let (in138, in139, in140) = (CE::<CI<138>> {}, CE::<CI<139>> {}, CE::<CI<140>> {});
    let (in141, in142, in143) = (CE::<CI<141>> {}, CE::<CI<142>> {}, CE::<CI<143>> {});
    let (in144, in145, in146) = (CE::<CI<144>> {}, CE::<CI<145>> {}, CE::<CI<146>> {});
    let (in147, in148, in149) = (CE::<CI<147>> {}, CE::<CI<148>> {}, CE::<CI<149>> {});
    let t0 = circuit_add(in1, in28);
    let t1 = circuit_mul(in122, t0);
    let t2 = circuit_add(in123, t1);
    let t3 = circuit_add(in28, in0);
    let t4 = circuit_mul(in122, t3);
    let t5 = circuit_sub(in123, t4);
    let t6 = circuit_add(t2, in27);
    let t7 = circuit_mul(in0, t6);
    let t8 = circuit_add(t5, in27);
    let t9 = circuit_mul(in0, t8);
    let t10 = circuit_inverse(t9);
    let t11 = circuit_mul(t7, t10);
    let t12 = circuit_add(in29, in30);
    let t13 = circuit_sub(t12, in2);
    let t14 = circuit_mul(t13, in124);
    let t15 = circuit_mul(in124, in124);
    let t16 = circuit_sub(in109, in2);
    let t17 = circuit_mul(in0, t16);
    let t18 = circuit_sub(in109, in2);
    let t19 = circuit_mul(in3, t18);
    let t20 = circuit_inverse(t19);
    let t21 = circuit_mul(in29, t20);
    let t22 = circuit_add(in2, t21);
    let t23 = circuit_sub(in109, in0);
    let t24 = circuit_mul(t17, t23);
    let t25 = circuit_sub(in109, in0);
    let t26 = circuit_mul(in4, t25);
    let t27 = circuit_inverse(t26);
    let t28 = circuit_mul(in30, t27);
    let t29 = circuit_add(t22, t28);
    let t30 = circuit_sub(in109, in11);
    let t31 = circuit_mul(t24, t30);
    let t32 = circuit_sub(in109, in11);
    let t33 = circuit_mul(in5, t32);
    let t34 = circuit_inverse(t33);
    let t35 = circuit_mul(in31, t34);
    let t36 = circuit_add(t29, t35);
    let t37 = circuit_sub(in109, in12);
    let t38 = circuit_mul(t31, t37);
    let t39 = circuit_sub(in109, in12);
    let t40 = circuit_mul(in6, t39);
    let t41 = circuit_inverse(t40);
    let t42 = circuit_mul(in32, t41);
    let t43 = circuit_add(t36, t42);
    let t44 = circuit_sub(in109, in13);
    let t45 = circuit_mul(t38, t44);
    let t46 = circuit_sub(in109, in13);
    let t47 = circuit_mul(in7, t46);
    let t48 = circuit_inverse(t47);
    let t49 = circuit_mul(in33, t48);
    let t50 = circuit_add(t43, t49);
    let t51 = circuit_sub(in109, in14);
    let t52 = circuit_mul(t45, t51);
    let t53 = circuit_sub(in109, in14);
    let t54 = circuit_mul(in8, t53);
    let t55 = circuit_inverse(t54);
    let t56 = circuit_mul(in34, t55);
    let t57 = circuit_add(t50, t56);
    let t58 = circuit_sub(in109, in15);
    let t59 = circuit_mul(t52, t58);
    let t60 = circuit_sub(in109, in15);
    let t61 = circuit_mul(in9, t60);
    let t62 = circuit_inverse(t61);
    let t63 = circuit_mul(in35, t62);
    let t64 = circuit_add(t57, t63);
    let t65 = circuit_sub(in109, in16);
    let t66 = circuit_mul(t59, t65);
    let t67 = circuit_sub(in109, in16);
    let t68 = circuit_mul(in10, t67);
    let t69 = circuit_inverse(t68);
    let t70 = circuit_mul(in36, t69);
    let t71 = circuit_add(t64, t70);
    let t72 = circuit_mul(t71, t66);
    let t73 = circuit_sub(in114, in0);
    let t74 = circuit_mul(in109, t73);
    let t75 = circuit_add(in0, t74);
    let t76 = circuit_mul(in0, t75);
    let t77 = circuit_add(in37, in38);
    let t78 = circuit_sub(t77, t72);
    let t79 = circuit_mul(t78, t15);
    let t80 = circuit_add(t14, t79);
    let t81 = circuit_mul(t15, in124);
    let t82 = circuit_sub(in110, in2);
    let t83 = circuit_mul(in0, t82);
    let t84 = circuit_sub(in110, in2);
    let t85 = circuit_mul(in3, t84);
    let t86 = circuit_inverse(t85);
    let t87 = circuit_mul(in37, t86);
    let t88 = circuit_add(in2, t87);
    let t89 = circuit_sub(in110, in0);
    let t90 = circuit_mul(t83, t89);
    let t91 = circuit_sub(in110, in0);
    let t92 = circuit_mul(in4, t91);
    let t93 = circuit_inverse(t92);
    let t94 = circuit_mul(in38, t93);
    let t95 = circuit_add(t88, t94);
    let t96 = circuit_sub(in110, in11);
    let t97 = circuit_mul(t90, t96);
    let t98 = circuit_sub(in110, in11);
    let t99 = circuit_mul(in5, t98);
    let t100 = circuit_inverse(t99);
    let t101 = circuit_mul(in39, t100);
    let t102 = circuit_add(t95, t101);
    let t103 = circuit_sub(in110, in12);
    let t104 = circuit_mul(t97, t103);
    let t105 = circuit_sub(in110, in12);
    let t106 = circuit_mul(in6, t105);
    let t107 = circuit_inverse(t106);
    let t108 = circuit_mul(in40, t107);
    let t109 = circuit_add(t102, t108);
    let t110 = circuit_sub(in110, in13);
    let t111 = circuit_mul(t104, t110);
    let t112 = circuit_sub(in110, in13);
    let t113 = circuit_mul(in7, t112);
    let t114 = circuit_inverse(t113);
    let t115 = circuit_mul(in41, t114);
    let t116 = circuit_add(t109, t115);
    let t117 = circuit_sub(in110, in14);
    let t118 = circuit_mul(t111, t117);
    let t119 = circuit_sub(in110, in14);
    let t120 = circuit_mul(in8, t119);
    let t121 = circuit_inverse(t120);
    let t122 = circuit_mul(in42, t121);
    let t123 = circuit_add(t116, t122);
    let t124 = circuit_sub(in110, in15);
    let t125 = circuit_mul(t118, t124);
    let t126 = circuit_sub(in110, in15);
    let t127 = circuit_mul(in9, t126);
    let t128 = circuit_inverse(t127);
    let t129 = circuit_mul(in43, t128);
    let t130 = circuit_add(t123, t129);
    let t131 = circuit_sub(in110, in16);
    let t132 = circuit_mul(t125, t131);
    let t133 = circuit_sub(in110, in16);
    let t134 = circuit_mul(in10, t133);
    let t135 = circuit_inverse(t134);
    let t136 = circuit_mul(in44, t135);
    let t137 = circuit_add(t130, t136);
    let t138 = circuit_mul(t137, t132);
    let t139 = circuit_sub(in115, in0);
    let t140 = circuit_mul(in110, t139);
    let t141 = circuit_add(in0, t140);
    let t142 = circuit_mul(t76, t141);
    let t143 = circuit_add(in45, in46);
    let t144 = circuit_sub(t143, t138);
    let t145 = circuit_mul(t144, t81);
    let t146 = circuit_add(t80, t145);
    let t147 = circuit_mul(t81, in124);
    let t148 = circuit_sub(in111, in2);
    let t149 = circuit_mul(in0, t148);
    let t150 = circuit_sub(in111, in2);
    let t151 = circuit_mul(in3, t150);
    let t152 = circuit_inverse(t151);
    let t153 = circuit_mul(in45, t152);
    let t154 = circuit_add(in2, t153);
    let t155 = circuit_sub(in111, in0);
    let t156 = circuit_mul(t149, t155);
    let t157 = circuit_sub(in111, in0);
    let t158 = circuit_mul(in4, t157);
    let t159 = circuit_inverse(t158);
    let t160 = circuit_mul(in46, t159);
    let t161 = circuit_add(t154, t160);
    let t162 = circuit_sub(in111, in11);
    let t163 = circuit_mul(t156, t162);
    let t164 = circuit_sub(in111, in11);
    let t165 = circuit_mul(in5, t164);
    let t166 = circuit_inverse(t165);
    let t167 = circuit_mul(in47, t166);
    let t168 = circuit_add(t161, t167);
    let t169 = circuit_sub(in111, in12);
    let t170 = circuit_mul(t163, t169);
    let t171 = circuit_sub(in111, in12);
    let t172 = circuit_mul(in6, t171);
    let t173 = circuit_inverse(t172);
    let t174 = circuit_mul(in48, t173);
    let t175 = circuit_add(t168, t174);
    let t176 = circuit_sub(in111, in13);
    let t177 = circuit_mul(t170, t176);
    let t178 = circuit_sub(in111, in13);
    let t179 = circuit_mul(in7, t178);
    let t180 = circuit_inverse(t179);
    let t181 = circuit_mul(in49, t180);
    let t182 = circuit_add(t175, t181);
    let t183 = circuit_sub(in111, in14);
    let t184 = circuit_mul(t177, t183);
    let t185 = circuit_sub(in111, in14);
    let t186 = circuit_mul(in8, t185);
    let t187 = circuit_inverse(t186);
    let t188 = circuit_mul(in50, t187);
    let t189 = circuit_add(t182, t188);
    let t190 = circuit_sub(in111, in15);
    let t191 = circuit_mul(t184, t190);
    let t192 = circuit_sub(in111, in15);
    let t193 = circuit_mul(in9, t192);
    let t194 = circuit_inverse(t193);
    let t195 = circuit_mul(in51, t194);
    let t196 = circuit_add(t189, t195);
    let t197 = circuit_sub(in111, in16);
    let t198 = circuit_mul(t191, t197);
    let t199 = circuit_sub(in111, in16);
    let t200 = circuit_mul(in10, t199);
    let t201 = circuit_inverse(t200);
    let t202 = circuit_mul(in52, t201);
    let t203 = circuit_add(t196, t202);
    let t204 = circuit_mul(t203, t198);
    let t205 = circuit_sub(in116, in0);
    let t206 = circuit_mul(in111, t205);
    let t207 = circuit_add(in0, t206);
    let t208 = circuit_mul(t142, t207);
    let t209 = circuit_add(in53, in54);
    let t210 = circuit_sub(t209, t204);
    let t211 = circuit_mul(t210, t147);
    let t212 = circuit_add(t146, t211);
    let t213 = circuit_mul(t147, in124);
    let t214 = circuit_sub(in112, in2);
    let t215 = circuit_mul(in0, t214);
    let t216 = circuit_sub(in112, in2);
    let t217 = circuit_mul(in3, t216);
    let t218 = circuit_inverse(t217);
    let t219 = circuit_mul(in53, t218);
    let t220 = circuit_add(in2, t219);
    let t221 = circuit_sub(in112, in0);
    let t222 = circuit_mul(t215, t221);
    let t223 = circuit_sub(in112, in0);
    let t224 = circuit_mul(in4, t223);
    let t225 = circuit_inverse(t224);
    let t226 = circuit_mul(in54, t225);
    let t227 = circuit_add(t220, t226);
    let t228 = circuit_sub(in112, in11);
    let t229 = circuit_mul(t222, t228);
    let t230 = circuit_sub(in112, in11);
    let t231 = circuit_mul(in5, t230);
    let t232 = circuit_inverse(t231);
    let t233 = circuit_mul(in55, t232);
    let t234 = circuit_add(t227, t233);
    let t235 = circuit_sub(in112, in12);
    let t236 = circuit_mul(t229, t235);
    let t237 = circuit_sub(in112, in12);
    let t238 = circuit_mul(in6, t237);
    let t239 = circuit_inverse(t238);
    let t240 = circuit_mul(in56, t239);
    let t241 = circuit_add(t234, t240);
    let t242 = circuit_sub(in112, in13);
    let t243 = circuit_mul(t236, t242);
    let t244 = circuit_sub(in112, in13);
    let t245 = circuit_mul(in7, t244);
    let t246 = circuit_inverse(t245);
    let t247 = circuit_mul(in57, t246);
    let t248 = circuit_add(t241, t247);
    let t249 = circuit_sub(in112, in14);
    let t250 = circuit_mul(t243, t249);
    let t251 = circuit_sub(in112, in14);
    let t252 = circuit_mul(in8, t251);
    let t253 = circuit_inverse(t252);
    let t254 = circuit_mul(in58, t253);
    let t255 = circuit_add(t248, t254);
    let t256 = circuit_sub(in112, in15);
    let t257 = circuit_mul(t250, t256);
    let t258 = circuit_sub(in112, in15);
    let t259 = circuit_mul(in9, t258);
    let t260 = circuit_inverse(t259);
    let t261 = circuit_mul(in59, t260);
    let t262 = circuit_add(t255, t261);
    let t263 = circuit_sub(in112, in16);
    let t264 = circuit_mul(t257, t263);
    let t265 = circuit_sub(in112, in16);
    let t266 = circuit_mul(in10, t265);
    let t267 = circuit_inverse(t266);
    let t268 = circuit_mul(in60, t267);
    let t269 = circuit_add(t262, t268);
    let t270 = circuit_mul(t269, t264);
    let t271 = circuit_sub(in117, in0);
    let t272 = circuit_mul(in112, t271);
    let t273 = circuit_add(in0, t272);
    let t274 = circuit_mul(t208, t273);
    let t275 = circuit_add(in61, in62);
    let t276 = circuit_sub(t275, t270);
    let t277 = circuit_mul(t276, t213);
    let t278 = circuit_add(t212, t277);
    let t279 = circuit_sub(in113, in2);
    let t280 = circuit_mul(in0, t279);
    let t281 = circuit_sub(in113, in2);
    let t282 = circuit_mul(in3, t281);
    let t283 = circuit_inverse(t282);
    let t284 = circuit_mul(in61, t283);
    let t285 = circuit_add(in2, t284);
    let t286 = circuit_sub(in113, in0);
    let t287 = circuit_mul(t280, t286);
    let t288 = circuit_sub(in113, in0);
    let t289 = circuit_mul(in4, t288);
    let t290 = circuit_inverse(t289);
    let t291 = circuit_mul(in62, t290);
    let t292 = circuit_add(t285, t291);
    let t293 = circuit_sub(in113, in11);
    let t294 = circuit_mul(t287, t293);
    let t295 = circuit_sub(in113, in11);
    let t296 = circuit_mul(in5, t295);
    let t297 = circuit_inverse(t296);
    let t298 = circuit_mul(in63, t297);
    let t299 = circuit_add(t292, t298);
    let t300 = circuit_sub(in113, in12);
    let t301 = circuit_mul(t294, t300);
    let t302 = circuit_sub(in113, in12);
    let t303 = circuit_mul(in6, t302);
    let t304 = circuit_inverse(t303);
    let t305 = circuit_mul(in64, t304);
    let t306 = circuit_add(t299, t305);
    let t307 = circuit_sub(in113, in13);
    let t308 = circuit_mul(t301, t307);
    let t309 = circuit_sub(in113, in13);
    let t310 = circuit_mul(in7, t309);
    let t311 = circuit_inverse(t310);
    let t312 = circuit_mul(in65, t311);
    let t313 = circuit_add(t306, t312);
    let t314 = circuit_sub(in113, in14);
    let t315 = circuit_mul(t308, t314);
    let t316 = circuit_sub(in113, in14);
    let t317 = circuit_mul(in8, t316);
    let t318 = circuit_inverse(t317);
    let t319 = circuit_mul(in66, t318);
    let t320 = circuit_add(t313, t319);
    let t321 = circuit_sub(in113, in15);
    let t322 = circuit_mul(t315, t321);
    let t323 = circuit_sub(in113, in15);
    let t324 = circuit_mul(in9, t323);
    let t325 = circuit_inverse(t324);
    let t326 = circuit_mul(in67, t325);
    let t327 = circuit_add(t320, t326);
    let t328 = circuit_sub(in113, in16);
    let t329 = circuit_mul(t322, t328);
    let t330 = circuit_sub(in113, in16);
    let t331 = circuit_mul(in10, t330);
    let t332 = circuit_inverse(t331);
    let t333 = circuit_mul(in68, t332);
    let t334 = circuit_add(t327, t333);
    let t335 = circuit_mul(t334, t329);
    let t336 = circuit_sub(in118, in0);
    let t337 = circuit_mul(in113, t336);
    let t338 = circuit_add(in0, t337);
    let t339 = circuit_mul(t274, t338);
    let t340 = circuit_sub(in76, in12);
    let t341 = circuit_mul(t340, in69);
    let t342 = circuit_mul(t341, in97);
    let t343 = circuit_mul(t342, in96);
    let t344 = circuit_mul(t343, in17);
    let t345 = circuit_mul(in71, in96);
    let t346 = circuit_mul(in72, in97);
    let t347 = circuit_mul(in73, in98);
    let t348 = circuit_mul(in74, in99);
    let t349 = circuit_add(t344, t345);
    let t350 = circuit_add(t349, t346);
    let t351 = circuit_add(t350, t347);
    let t352 = circuit_add(t351, t348);
    let t353 = circuit_add(t352, in70);
    let t354 = circuit_sub(in76, in0);
    let t355 = circuit_mul(t354, in107);
    let t356 = circuit_add(t353, t355);
    let t357 = circuit_mul(t356, in76);
    let t358 = circuit_mul(t357, t339);
    let t359 = circuit_add(in96, in99);
    let t360 = circuit_add(t359, in69);
    let t361 = circuit_sub(t360, in104);
    let t362 = circuit_sub(in76, in11);
    let t363 = circuit_mul(t361, t362);
    let t364 = circuit_sub(in76, in0);
    let t365 = circuit_mul(t363, t364);
    let t366 = circuit_mul(t365, in76);
    let t367 = circuit_mul(t366, t339);
    let t368 = circuit_mul(in86, in122);
    let t369 = circuit_add(in96, t368);
    let t370 = circuit_add(t369, in123);
    let t371 = circuit_mul(in87, in122);
    let t372 = circuit_add(in97, t371);
    let t373 = circuit_add(t372, in123);
    let t374 = circuit_mul(t370, t373);
    let t375 = circuit_mul(in88, in122);
    let t376 = circuit_add(in98, t375);
    let t377 = circuit_add(t376, in123);
    let t378 = circuit_mul(t374, t377);
    let t379 = circuit_mul(in89, in122);
    let t380 = circuit_add(in99, t379);
    let t381 = circuit_add(t380, in123);
    let t382 = circuit_mul(t378, t381);
    let t383 = circuit_mul(in82, in122);
    let t384 = circuit_add(in96, t383);
    let t385 = circuit_add(t384, in123);
    let t386 = circuit_mul(in83, in122);
    let t387 = circuit_add(in97, t386);
    let t388 = circuit_add(t387, in123);
    let t389 = circuit_mul(t385, t388);
    let t390 = circuit_mul(in84, in122);
    let t391 = circuit_add(in98, t390);
    let t392 = circuit_add(t391, in123);
    let t393 = circuit_mul(t389, t392);
    let t394 = circuit_mul(in85, in122);
    let t395 = circuit_add(in99, t394);
    let t396 = circuit_add(t395, in123);
    let t397 = circuit_mul(t393, t396);
    let t398 = circuit_add(in100, in94);
    let t399 = circuit_mul(t382, t398);
    let t400 = circuit_mul(in95, t11);
    let t401 = circuit_add(in108, t400);
    let t402 = circuit_mul(t397, t401);
    let t403 = circuit_sub(t399, t402);
    let t404 = circuit_mul(t403, t339);
    let t405 = circuit_mul(in95, in108);
    let t406 = circuit_mul(t405, t339);
    let t407 = circuit_mul(in91, in119);
    let t408 = circuit_mul(in92, in120);
    let t409 = circuit_mul(in93, in121);
    let t410 = circuit_add(in90, in123);
    let t411 = circuit_add(t410, t407);
    let t412 = circuit_add(t411, t408);
    let t413 = circuit_add(t412, t409);
    let t414 = circuit_mul(in72, in104);
    let t415 = circuit_add(in96, in123);
    let t416 = circuit_add(t415, t414);
    let t417 = circuit_mul(in69, in105);
    let t418 = circuit_add(in97, t417);
    let t419 = circuit_mul(in70, in106);
    let t420 = circuit_add(in98, t419);
    let t421 = circuit_mul(t418, in119);
    let t422 = circuit_mul(t420, in120);
    let t423 = circuit_mul(in73, in121);
    let t424 = circuit_add(t416, t421);
    let t425 = circuit_add(t424, t422);
    let t426 = circuit_add(t425, t423);
    let t427 = circuit_mul(in101, t413);
    let t428 = circuit_mul(in101, t426);
    let t429 = circuit_add(in103, in75);
    let t430 = circuit_mul(in103, in75);
    let t431 = circuit_sub(t429, t430);
    let t432 = circuit_mul(t426, t413);
    let t433 = circuit_mul(t432, in101);
    let t434 = circuit_sub(t433, t431);
    let t435 = circuit_mul(t434, t339);
    let t436 = circuit_mul(in75, t427);
    let t437 = circuit_mul(in102, t428);
    let t438 = circuit_sub(t436, t437);
    let t439 = circuit_mul(in77, t339);
    let t440 = circuit_sub(in97, in96);
    let t441 = circuit_sub(in98, in97);
    let t442 = circuit_sub(in99, in98);
    let t443 = circuit_sub(in104, in99);
    let t444 = circuit_add(t440, in18);
    let t445 = circuit_add(t444, in18);
    let t446 = circuit_add(t445, in18);
    let t447 = circuit_mul(t440, t444);
    let t448 = circuit_mul(t447, t445);
    let t449 = circuit_mul(t448, t446);
    let t450 = circuit_mul(t449, t439);
    let t451 = circuit_add(t441, in18);
    let t452 = circuit_add(t451, in18);
    let t453 = circuit_add(t452, in18);
    let t454 = circuit_mul(t441, t451);
    let t455 = circuit_mul(t454, t452);
    let t456 = circuit_mul(t455, t453);
    let t457 = circuit_mul(t456, t439);
    let t458 = circuit_add(t442, in18);
    let t459 = circuit_add(t458, in18);
    let t460 = circuit_add(t459, in18);
    let t461 = circuit_mul(t442, t458);
    let t462 = circuit_mul(t461, t459);
    let t463 = circuit_mul(t462, t460);
    let t464 = circuit_mul(t463, t439);
    let t465 = circuit_add(t443, in18);
    let t466 = circuit_add(t465, in18);
    let t467 = circuit_add(t466, in18);
    let t468 = circuit_mul(t443, t465);
    let t469 = circuit_mul(t468, t466);
    let t470 = circuit_mul(t469, t467);
    let t471 = circuit_mul(t470, t439);
    let t472 = circuit_sub(in104, in97);
    let t473 = circuit_mul(in98, in98);
    let t474 = circuit_mul(in107, in107);
    let t475 = circuit_mul(in98, in107);
    let t476 = circuit_mul(t475, in71);
    let t477 = circuit_add(in105, in104);
    let t478 = circuit_add(t477, in97);
    let t479 = circuit_mul(t478, t472);
    let t480 = circuit_mul(t479, t472);
    let t481 = circuit_sub(t480, t474);
    let t482 = circuit_sub(t481, t473);
    let t483 = circuit_add(t482, t476);
    let t484 = circuit_add(t483, t476);
    let t485 = circuit_sub(in0, in69);
    let t486 = circuit_mul(t484, t339);
    let t487 = circuit_mul(t486, in78);
    let t488 = circuit_mul(t487, t485);
    let t489 = circuit_add(in98, in106);
    let t490 = circuit_mul(in107, in71);
    let t491 = circuit_sub(t490, in98);
    let t492 = circuit_mul(t489, t472);
    let t493 = circuit_sub(in105, in97);
    let t494 = circuit_mul(t493, t491);
    let t495 = circuit_add(t492, t494);
    let t496 = circuit_mul(t495, t339);
    let t497 = circuit_mul(t496, in78);
    let t498 = circuit_mul(t497, t485);
    let t499 = circuit_add(t473, in19);
    let t500 = circuit_mul(t499, in97);
    let t501 = circuit_add(t473, t473);
    let t502 = circuit_add(t501, t501);
    let t503 = circuit_mul(t500, in20);
    let t504 = circuit_add(in105, in97);
    let t505 = circuit_add(t504, in97);
    let t506 = circuit_mul(t505, t502);
    let t507 = circuit_sub(t506, t503);
    let t508 = circuit_mul(t507, t339);
    let t509 = circuit_mul(t508, in78);
    let t510 = circuit_mul(t509, in69);
    let t511 = circuit_add(t488, t510);
    let t512 = circuit_add(in97, in97);
    let t513 = circuit_add(t512, in97);
    let t514 = circuit_mul(t513, in97);
    let t515 = circuit_sub(in97, in105);
    let t516 = circuit_mul(t514, t515);
    let t517 = circuit_add(in98, in98);
    let t518 = circuit_add(in98, in106);
    let t519 = circuit_mul(t517, t518);
    let t520 = circuit_sub(t516, t519);
    let t521 = circuit_mul(t520, t339);
    let t522 = circuit_mul(t521, in78);
    let t523 = circuit_mul(t522, in69);
    let t524 = circuit_add(t498, t523);
    let t525 = circuit_mul(in96, in105);
    let t526 = circuit_mul(in104, in97);
    let t527 = circuit_add(t525, t526);
    let t528 = circuit_mul(in96, in99);
    let t529 = circuit_mul(in97, in98);
    let t530 = circuit_add(t528, t529);
    let t531 = circuit_sub(t530, in106);
    let t532 = circuit_mul(t531, in21);
    let t533 = circuit_sub(t532, in107);
    let t534 = circuit_add(t533, t527);
    let t535 = circuit_mul(t534, in74);
    let t536 = circuit_mul(t527, in21);
    let t537 = circuit_mul(in104, in105);
    let t538 = circuit_add(t536, t537);
    let t539 = circuit_add(in98, in99);
    let t540 = circuit_sub(t538, t539);
    let t541 = circuit_mul(t540, in73);
    let t542 = circuit_add(t538, in99);
    let t543 = circuit_add(in106, in107);
    let t544 = circuit_sub(t542, t543);
    let t545 = circuit_mul(t544, in69);
    let t546 = circuit_add(t541, t535);
    let t547 = circuit_add(t546, t545);
    let t548 = circuit_mul(t547, in72);
    let t549 = circuit_mul(in105, in22);
    let t550 = circuit_add(t549, in104);
    let t551 = circuit_mul(t550, in22);
    let t552 = circuit_add(t551, in98);
    let t553 = circuit_mul(t552, in22);
    let t554 = circuit_add(t553, in97);
    let t555 = circuit_mul(t554, in22);
    let t556 = circuit_add(t555, in96);
    let t557 = circuit_sub(t556, in99);
    let t558 = circuit_mul(t557, in74);
    let t559 = circuit_mul(in106, in22);
    let t560 = circuit_add(t559, in105);
    let t561 = circuit_mul(t560, in22);
    let t562 = circuit_add(t561, in104);
    let t563 = circuit_mul(t562, in22);
    let t564 = circuit_add(t563, in99);
    let t565 = circuit_mul(t564, in22);
    let t566 = circuit_add(t565, in98);
    let t567 = circuit_sub(t566, in107);
    let t568 = circuit_mul(t567, in69);
    let t569 = circuit_add(t558, t568);
    let t570 = circuit_mul(t569, in73);
    let t571 = circuit_mul(in98, in121);
    let t572 = circuit_mul(in97, in120);
    let t573 = circuit_mul(in96, in119);
    let t574 = circuit_add(t571, t572);
    let t575 = circuit_add(t574, t573);
    let t576 = circuit_add(t575, in70);
    let t577 = circuit_sub(t576, in99);
    let t578 = circuit_sub(in104, in96);
    let t579 = circuit_sub(in107, in99);
    let t580 = circuit_mul(t578, t578);
    let t581 = circuit_sub(t580, t578);
    let t582 = circuit_sub(in2, t578);
    let t583 = circuit_add(t582, in0);
    let t584 = circuit_mul(t583, t579);
    let t585 = circuit_mul(in71, in72);
    let t586 = circuit_mul(t585, in79);
    let t587 = circuit_mul(t586, t339);
    let t588 = circuit_mul(t584, t587);
    let t589 = circuit_mul(t581, t587);
    let t590 = circuit_mul(t577, t585);
    let t591 = circuit_sub(in99, t576);
    let t592 = circuit_mul(t591, t591);
    let t593 = circuit_sub(t592, t591);
    let t594 = circuit_mul(in106, in121);
    let t595 = circuit_mul(in105, in120);
    let t596 = circuit_mul(in104, in119);
    let t597 = circuit_add(t594, t595);
    let t598 = circuit_add(t597, t596);
    let t599 = circuit_sub(in107, t598);
    let t600 = circuit_sub(in106, in98);
    let t601 = circuit_sub(in2, t578);
    let t602 = circuit_add(t601, in0);
    let t603 = circuit_sub(in2, t599);
    let t604 = circuit_add(t603, in0);
    let t605 = circuit_mul(t600, t604);
    let t606 = circuit_mul(t602, t605);
    let t607 = circuit_mul(t599, t599);
    let t608 = circuit_sub(t607, t599);
    let t609 = circuit_mul(in76, in79);
    let t610 = circuit_mul(t609, t339);
    let t611 = circuit_mul(t606, t610);
    let t612 = circuit_mul(t581, t610);
    let t613 = circuit_mul(t608, t610);
    let t614 = circuit_mul(t593, in76);
    let t615 = circuit_sub(in105, in97);
    let t616 = circuit_sub(in2, t578);
    let t617 = circuit_add(t616, in0);
    let t618 = circuit_mul(t617, t615);
    let t619 = circuit_sub(t618, in98);
    let t620 = circuit_mul(t619, in74);
    let t621 = circuit_mul(t620, in71);
    let t622 = circuit_add(t590, t621);
    let t623 = circuit_mul(t577, in69);
    let t624 = circuit_mul(t623, in71);
    let t625 = circuit_add(t622, t624);
    let t626 = circuit_add(t625, t614);
    let t627 = circuit_add(t626, t548);
    let t628 = circuit_add(t627, t570);
    let t629 = circuit_mul(t628, in79);
    let t630 = circuit_mul(t629, t339);
    let t631 = circuit_add(in96, in71);
    let t632 = circuit_add(in97, in72);
    let t633 = circuit_add(in98, in73);
    let t634 = circuit_add(in99, in74);
    let t635 = circuit_mul(t631, t631);
    let t636 = circuit_mul(t635, t635);
    let t637 = circuit_mul(t636, t631);
    let t638 = circuit_mul(t632, t632);
    let t639 = circuit_mul(t638, t638);
    let t640 = circuit_mul(t639, t632);
    let t641 = circuit_mul(t633, t633);
    let t642 = circuit_mul(t641, t641);
    let t643 = circuit_mul(t642, t633);
    let t644 = circuit_mul(t634, t634);
    let t645 = circuit_mul(t644, t644);
    let t646 = circuit_mul(t645, t634);
    let t647 = circuit_add(t637, t640);
    let t648 = circuit_add(t643, t646);
    let t649 = circuit_add(t640, t640);
    let t650 = circuit_add(t649, t648);
    let t651 = circuit_add(t646, t646);
    let t652 = circuit_add(t651, t647);
    let t653 = circuit_add(t648, t648);
    let t654 = circuit_add(t653, t653);
    let t655 = circuit_add(t654, t652);
    let t656 = circuit_add(t647, t647);
    let t657 = circuit_add(t656, t656);
    let t658 = circuit_add(t657, t650);
    let t659 = circuit_add(t652, t658);
    let t660 = circuit_add(t650, t655);
    let t661 = circuit_mul(in80, t339);
    let t662 = circuit_sub(t659, in104);
    let t663 = circuit_mul(t661, t662);
    let t664 = circuit_sub(t658, in105);
    let t665 = circuit_mul(t661, t664);
    let t666 = circuit_sub(t660, in106);
    let t667 = circuit_mul(t661, t666);
    let t668 = circuit_sub(t655, in107);
    let t669 = circuit_mul(t661, t668);
    let t670 = circuit_add(in96, in71);
    let t671 = circuit_mul(t670, t670);
    let t672 = circuit_mul(t671, t671);
    let t673 = circuit_mul(t672, t670);
    let t674 = circuit_add(t673, in97);
    let t675 = circuit_add(t674, in98);
    let t676 = circuit_add(t675, in99);
    let t677 = circuit_mul(in81, t339);
    let t678 = circuit_mul(t673, in23);
    let t679 = circuit_add(t678, t676);
    let t680 = circuit_sub(t679, in104);
    let t681 = circuit_mul(t677, t680);
    let t682 = circuit_mul(in97, in24);
    let t683 = circuit_add(t682, t676);
    let t684 = circuit_sub(t683, in105);
    let t685 = circuit_mul(t677, t684);
    let t686 = circuit_mul(in98, in25);
    let t687 = circuit_add(t686, t676);
    let t688 = circuit_sub(t687, in106);
    let t689 = circuit_mul(t677, t688);
    let t690 = circuit_mul(in99, in26);
    let t691 = circuit_add(t690, t676);
    let t692 = circuit_sub(t691, in107);
    let t693 = circuit_mul(t677, t692);
    let t694 = circuit_mul(t367, in125);
    let t695 = circuit_add(t358, t694);
    let t696 = circuit_mul(t404, in126);
    let t697 = circuit_add(t695, t696);
    let t698 = circuit_mul(t406, in127);
    let t699 = circuit_add(t697, t698);
    let t700 = circuit_mul(t435, in128);
    let t701 = circuit_add(t699, t700);
    let t702 = circuit_mul(t438, in129);
    let t703 = circuit_add(t701, t702);
    let t704 = circuit_mul(t450, in130);
    let t705 = circuit_add(t703, t704);
    let t706 = circuit_mul(t457, in131);
    let t707 = circuit_add(t705, t706);
    let t708 = circuit_mul(t464, in132);
    let t709 = circuit_add(t707, t708);
    let t710 = circuit_mul(t471, in133);
    let t711 = circuit_add(t709, t710);
    let t712 = circuit_mul(t511, in134);
    let t713 = circuit_add(t711, t712);
    let t714 = circuit_mul(t524, in135);
    let t715 = circuit_add(t713, t714);
    let t716 = circuit_mul(t630, in136);
    let t717 = circuit_add(t715, t716);
    let t718 = circuit_mul(t588, in137);
    let t719 = circuit_add(t717, t718);
    let t720 = circuit_mul(t589, in138);
    let t721 = circuit_add(t719, t720);
    let t722 = circuit_mul(t611, in139);
    let t723 = circuit_add(t721, t722);
    let t724 = circuit_mul(t612, in140);
    let t725 = circuit_add(t723, t724);
    let t726 = circuit_mul(t613, in141);
    let t727 = circuit_add(t725, t726);
    let t728 = circuit_mul(t663, in142);
    let t729 = circuit_add(t727, t728);
    let t730 = circuit_mul(t665, in143);
    let t731 = circuit_add(t729, t730);
    let t732 = circuit_mul(t667, in144);
    let t733 = circuit_add(t731, t732);
    let t734 = circuit_mul(t669, in145);
    let t735 = circuit_add(t733, t734);
    let t736 = circuit_mul(t681, in146);
    let t737 = circuit_add(t735, t736);
    let t738 = circuit_mul(t685, in147);
    let t739 = circuit_add(t737, t738);
    let t740 = circuit_mul(t689, in148);
    let t741 = circuit_add(t739, t740);
    let t742 = circuit_mul(t693, in149);
    let t743 = circuit_add(t741, t742);
    let t744 = circuit_sub(t743, t335);

    let modulus = get_GRUMPKIN_modulus(); // GRUMPKIN prime field modulus

    let mut circuit_inputs = (t278, t744).new_inputs();
    // Prefill constants:

    circuit_inputs = circuit_inputs
        .next_span(HONK_SUMCHECK_SIZE_5_PUB_1_GRUMPKIN_CONSTANTS.span()); // in0 - in26

    // Fill inputs:

    for val in p_public_inputs {
        circuit_inputs = circuit_inputs.next_u256(*val);
    } // in27 - in27

    circuit_inputs = circuit_inputs.next_2(p_public_inputs_offset); // in28

    for val in sumcheck_univariates_flat {
        circuit_inputs = circuit_inputs.next_u256(*val);
    } // in29 - in68

    for val in sumcheck_evaluations {
        circuit_inputs = circuit_inputs.next_u256(*val);
    } // in69 - in108

    for val in tp_sum_check_u_challenges {
        circuit_inputs = circuit_inputs.next_u128(*val);
    } // in109 - in113

    for val in tp_gate_challenges {
        circuit_inputs = circuit_inputs.next_u128(*val);
    } // in114 - in118

    circuit_inputs = circuit_inputs.next_u128(tp_eta_1); // in119
    circuit_inputs = circuit_inputs.next_u128(tp_eta_2); // in120
    circuit_inputs = circuit_inputs.next_u128(tp_eta_3); // in121
    circuit_inputs = circuit_inputs.next_u128(tp_beta); // in122
    circuit_inputs = circuit_inputs.next_u128(tp_gamma); // in123
    circuit_inputs = circuit_inputs.next_2(tp_base_rlc); // in124

    for val in tp_alphas {
        circuit_inputs = circuit_inputs.next_u128(*val);
    } // in125 - in149

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let check_rlc: u384 = outputs.get_output(t278);
    let check: u384 = outputs.get_output(t744);
    return (check_rlc, check);
}
const HONK_SUMCHECK_SIZE_5_PUB_1_GRUMPKIN_CONSTANTS: [u384; 27] = [
    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x20, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 {
        limb0: 0x79b9709143e1f593efffec51,
        limb1: 0xb85045b68181585d2833e848,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    u384 { limb0: 0x2d0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 {
        limb0: 0x79b9709143e1f593efffff11,
        limb1: 0xb85045b68181585d2833e848,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    u384 { limb0: 0x90, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 {
        limb0: 0x79b9709143e1f593efffff71,
        limb1: 0xb85045b68181585d2833e848,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    u384 { limb0: 0xf0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 {
        limb0: 0x79b9709143e1f593effffd31,
        limb1: 0xb85045b68181585d2833e848,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    u384 { limb0: 0x13b0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x2, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x3, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x4, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x5, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x6, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x7, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 {
        limb0: 0x3cdcb848a1f0fac9f8000000,
        limb1: 0xdc2822db40c0ac2e9419f424,
        limb2: 0x183227397098d014,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x79b9709143e1f593f0000000,
        limb1: 0xb85045b68181585d2833e848,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    u384 { limb0: 0x11, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x9, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x100000000000000000, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x4000, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 {
        limb0: 0x29ca1d7fb56821fd19d3b6e7,
        limb1: 0x4b1e03b4bd9490c0d03f989,
        limb2: 0x10dc6e9c006ea38b,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xd4dd9b84a86b38cfb45a740b,
        limb1: 0x149b3d0a30b3bb599df9756,
        limb2: 0xc28145b6a44df3e,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x60e3596170067d00141cac15,
        limb1: 0xb2c7645a50392798b21f75bb,
        limb2: 0x544b8338791518,
        limb3: 0x0,
    },
    u384 {
        limb0: 0xb8fa852613bc534433ee428b,
        limb1: 0x2e2e82eb122789e352e105a3,
        limb2: 0x222c01175718386f,
        limb3: 0x0,
    },
];
#[inline(always)]
pub fn run_GRUMPKIN_HONK_PREP_MSM_SCALARS_SIZE_5_circuit(
    p_sumcheck_evaluations: Span<u256>,
    p_gemini_a_evaluations: Span<u256>,
    tp_gemini_r: u384,
    tp_rho: u384,
    tp_shplonk_z: u384,
    tp_shplonk_nu: u384,
    tp_sum_check_u_challenges: Span<u128>,
) -> (
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
) {
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
    let (in23, in24, in25) = (CE::<CI<23>> {}, CE::<CI<24>> {}, CE::<CI<25>> {});
    let (in26, in27, in28) = (CE::<CI<26>> {}, CE::<CI<27>> {}, CE::<CI<28>> {});
    let (in29, in30, in31) = (CE::<CI<29>> {}, CE::<CI<30>> {}, CE::<CI<31>> {});
    let (in32, in33, in34) = (CE::<CI<32>> {}, CE::<CI<33>> {}, CE::<CI<34>> {});
    let (in35, in36, in37) = (CE::<CI<35>> {}, CE::<CI<36>> {}, CE::<CI<37>> {});
    let (in38, in39, in40) = (CE::<CI<38>> {}, CE::<CI<39>> {}, CE::<CI<40>> {});
    let (in41, in42, in43) = (CE::<CI<41>> {}, CE::<CI<42>> {}, CE::<CI<43>> {});
    let (in44, in45, in46) = (CE::<CI<44>> {}, CE::<CI<45>> {}, CE::<CI<46>> {});
    let (in47, in48, in49) = (CE::<CI<47>> {}, CE::<CI<48>> {}, CE::<CI<49>> {});
    let (in50, in51, in52) = (CE::<CI<50>> {}, CE::<CI<51>> {}, CE::<CI<52>> {});
    let (in53, in54, in55) = (CE::<CI<53>> {}, CE::<CI<54>> {}, CE::<CI<55>> {});
    let t0 = circuit_mul(in47, in47);
    let t1 = circuit_mul(t0, t0);
    let t2 = circuit_mul(t1, t1);
    let t3 = circuit_mul(t2, t2);
    let t4 = circuit_sub(in49, in47);
    let t5 = circuit_inverse(t4);
    let t6 = circuit_add(in49, in47);
    let t7 = circuit_inverse(t6);
    let t8 = circuit_mul(in50, t7);
    let t9 = circuit_add(t5, t8);
    let t10 = circuit_sub(in0, t9);
    let t11 = circuit_inverse(in47);
    let t12 = circuit_mul(in50, t7);
    let t13 = circuit_sub(t5, t12);
    let t14 = circuit_mul(t11, t13);
    let t15 = circuit_sub(in0, t14);
    let t16 = circuit_mul(t10, in1);
    let t17 = circuit_mul(in2, in1);
    let t18 = circuit_add(in0, t17);
    let t19 = circuit_mul(in1, in48);
    let t20 = circuit_mul(t10, t19);
    let t21 = circuit_mul(in3, t19);
    let t22 = circuit_add(t18, t21);
    let t23 = circuit_mul(t19, in48);
    let t24 = circuit_mul(t10, t23);
    let t25 = circuit_mul(in4, t23);
    let t26 = circuit_add(t22, t25);
    let t27 = circuit_mul(t23, in48);
    let t28 = circuit_mul(t10, t27);
    let t29 = circuit_mul(in5, t27);
    let t30 = circuit_add(t26, t29);
    let t31 = circuit_mul(t27, in48);
    let t32 = circuit_mul(t10, t31);
    let t33 = circuit_mul(in6, t31);
    let t34 = circuit_add(t30, t33);
    let t35 = circuit_mul(t31, in48);
    let t36 = circuit_mul(t10, t35);
    let t37 = circuit_mul(in7, t35);
    let t38 = circuit_add(t34, t37);
    let t39 = circuit_mul(t35, in48);
    let t40 = circuit_mul(t10, t39);
    let t41 = circuit_mul(in8, t39);
    let t42 = circuit_add(t38, t41);
    let t43 = circuit_mul(t39, in48);
    let t44 = circuit_mul(t10, t43);
    let t45 = circuit_mul(in9, t43);
    let t46 = circuit_add(t42, t45);
    let t47 = circuit_mul(t43, in48);
    let t48 = circuit_mul(t10, t47);
    let t49 = circuit_mul(in10, t47);
    let t50 = circuit_add(t46, t49);
    let t51 = circuit_mul(t47, in48);
    let t52 = circuit_mul(t10, t51);
    let t53 = circuit_mul(in11, t51);
    let t54 = circuit_add(t50, t53);
    let t55 = circuit_mul(t51, in48);
    let t56 = circuit_mul(t10, t55);
    let t57 = circuit_mul(in12, t55);
    let t58 = circuit_add(t54, t57);
    let t59 = circuit_mul(t55, in48);
    let t60 = circuit_mul(t10, t59);
    let t61 = circuit_mul(in13, t59);
    let t62 = circuit_add(t58, t61);
    let t63 = circuit_mul(t59, in48);
    let t64 = circuit_mul(t10, t63);
    let t65 = circuit_mul(in14, t63);
    let t66 = circuit_add(t62, t65);
    let t67 = circuit_mul(t63, in48);
    let t68 = circuit_mul(t10, t67);
    let t69 = circuit_mul(in15, t67);
    let t70 = circuit_add(t66, t69);
    let t71 = circuit_mul(t67, in48);
    let t72 = circuit_mul(t10, t71);
    let t73 = circuit_mul(in16, t71);
    let t74 = circuit_add(t70, t73);
    let t75 = circuit_mul(t71, in48);
    let t76 = circuit_mul(t10, t75);
    let t77 = circuit_mul(in17, t75);
    let t78 = circuit_add(t74, t77);
    let t79 = circuit_mul(t75, in48);
    let t80 = circuit_mul(t10, t79);
    let t81 = circuit_mul(in18, t79);
    let t82 = circuit_add(t78, t81);
    let t83 = circuit_mul(t79, in48);
    let t84 = circuit_mul(t10, t83);
    let t85 = circuit_mul(in19, t83);
    let t86 = circuit_add(t82, t85);
    let t87 = circuit_mul(t83, in48);
    let t88 = circuit_mul(t10, t87);
    let t89 = circuit_mul(in20, t87);
    let t90 = circuit_add(t86, t89);
    let t91 = circuit_mul(t87, in48);
    let t92 = circuit_mul(t10, t91);
    let t93 = circuit_mul(in21, t91);
    let t94 = circuit_add(t90, t93);
    let t95 = circuit_mul(t91, in48);
    let t96 = circuit_mul(t10, t95);
    let t97 = circuit_mul(in22, t95);
    let t98 = circuit_add(t94, t97);
    let t99 = circuit_mul(t95, in48);
    let t100 = circuit_mul(t10, t99);
    let t101 = circuit_mul(in23, t99);
    let t102 = circuit_add(t98, t101);
    let t103 = circuit_mul(t99, in48);
    let t104 = circuit_mul(t10, t103);
    let t105 = circuit_mul(in24, t103);
    let t106 = circuit_add(t102, t105);
    let t107 = circuit_mul(t103, in48);
    let t108 = circuit_mul(t10, t107);
    let t109 = circuit_mul(in25, t107);
    let t110 = circuit_add(t106, t109);
    let t111 = circuit_mul(t107, in48);
    let t112 = circuit_mul(t10, t111);
    let t113 = circuit_mul(in26, t111);
    let t114 = circuit_add(t110, t113);
    let t115 = circuit_mul(t111, in48);
    let t116 = circuit_mul(t10, t115);
    let t117 = circuit_mul(in27, t115);
    let t118 = circuit_add(t114, t117);
    let t119 = circuit_mul(t115, in48);
    let t120 = circuit_mul(t10, t119);
    let t121 = circuit_mul(in28, t119);
    let t122 = circuit_add(t118, t121);
    let t123 = circuit_mul(t119, in48);
    let t124 = circuit_mul(t10, t123);
    let t125 = circuit_mul(in29, t123);
    let t126 = circuit_add(t122, t125);
    let t127 = circuit_mul(t123, in48);
    let t128 = circuit_mul(t10, t127);
    let t129 = circuit_mul(in30, t127);
    let t130 = circuit_add(t126, t129);
    let t131 = circuit_mul(t127, in48);
    let t132 = circuit_mul(t10, t131);
    let t133 = circuit_mul(in31, t131);
    let t134 = circuit_add(t130, t133);
    let t135 = circuit_mul(t131, in48);
    let t136 = circuit_mul(t10, t135);
    let t137 = circuit_mul(in32, t135);
    let t138 = circuit_add(t134, t137);
    let t139 = circuit_mul(t135, in48);
    let t140 = circuit_mul(t10, t139);
    let t141 = circuit_mul(in33, t139);
    let t142 = circuit_add(t138, t141);
    let t143 = circuit_mul(t139, in48);
    let t144 = circuit_mul(t10, t143);
    let t145 = circuit_mul(in34, t143);
    let t146 = circuit_add(t142, t145);
    let t147 = circuit_mul(t143, in48);
    let t148 = circuit_mul(t10, t147);
    let t149 = circuit_mul(in35, t147);
    let t150 = circuit_add(t146, t149);
    let t151 = circuit_mul(t147, in48);
    let t152 = circuit_mul(t10, t151);
    let t153 = circuit_mul(in36, t151);
    let t154 = circuit_add(t150, t153);
    let t155 = circuit_mul(t151, in48);
    let t156 = circuit_mul(t15, t155);
    let t157 = circuit_mul(in37, t155);
    let t158 = circuit_add(t154, t157);
    let t159 = circuit_mul(t155, in48);
    let t160 = circuit_mul(t15, t159);
    let t161 = circuit_mul(in38, t159);
    let t162 = circuit_add(t158, t161);
    let t163 = circuit_mul(t159, in48);
    let t164 = circuit_mul(t15, t163);
    let t165 = circuit_mul(in39, t163);
    let t166 = circuit_add(t162, t165);
    let t167 = circuit_mul(t163, in48);
    let t168 = circuit_mul(t15, t167);
    let t169 = circuit_mul(in40, t167);
    let t170 = circuit_add(t166, t169);
    let t171 = circuit_mul(t167, in48);
    let t172 = circuit_mul(t15, t171);
    let t173 = circuit_mul(in41, t171);
    let t174 = circuit_add(t170, t173);
    let t175 = circuit_sub(in1, in55);
    let t176 = circuit_mul(t3, t175);
    let t177 = circuit_mul(t3, t174);
    let t178 = circuit_add(t177, t177);
    let t179 = circuit_sub(t176, in55);
    let t180 = circuit_mul(in46, t179);
    let t181 = circuit_sub(t178, t180);
    let t182 = circuit_add(t176, in55);
    let t183 = circuit_inverse(t182);
    let t184 = circuit_mul(t181, t183);
    let t185 = circuit_sub(in1, in54);
    let t186 = circuit_mul(t2, t185);
    let t187 = circuit_mul(t2, t184);
    let t188 = circuit_add(t187, t187);
    let t189 = circuit_sub(t186, in54);
    let t190 = circuit_mul(in45, t189);
    let t191 = circuit_sub(t188, t190);
    let t192 = circuit_add(t186, in54);
    let t193 = circuit_inverse(t192);
    let t194 = circuit_mul(t191, t193);
    let t195 = circuit_sub(in1, in53);
    let t196 = circuit_mul(t1, t195);
    let t197 = circuit_mul(t1, t194);
    let t198 = circuit_add(t197, t197);
    let t199 = circuit_sub(t196, in53);
    let t200 = circuit_mul(in44, t199);
    let t201 = circuit_sub(t198, t200);
    let t202 = circuit_add(t196, in53);
    let t203 = circuit_inverse(t202);
    let t204 = circuit_mul(t201, t203);
    let t205 = circuit_sub(in1, in52);
    let t206 = circuit_mul(t0, t205);
    let t207 = circuit_mul(t0, t204);
    let t208 = circuit_add(t207, t207);
    let t209 = circuit_sub(t206, in52);
    let t210 = circuit_mul(in43, t209);
    let t211 = circuit_sub(t208, t210);
    let t212 = circuit_add(t206, in52);
    let t213 = circuit_inverse(t212);
    let t214 = circuit_mul(t211, t213);
    let t215 = circuit_sub(in1, in51);
    let t216 = circuit_mul(in47, t215);
    let t217 = circuit_mul(in47, t214);
    let t218 = circuit_add(t217, t217);
    let t219 = circuit_sub(t216, in51);
    let t220 = circuit_mul(in42, t219);
    let t221 = circuit_sub(t218, t220);
    let t222 = circuit_add(t216, in51);
    let t223 = circuit_inverse(t222);
    let t224 = circuit_mul(t221, t223);
    let t225 = circuit_mul(t224, t5);
    let t226 = circuit_mul(in42, in50);
    let t227 = circuit_mul(t226, t7);
    let t228 = circuit_add(t225, t227);
    let t229 = circuit_mul(in50, in50);
    let t230 = circuit_sub(in49, t0);
    let t231 = circuit_inverse(t230);
    let t232 = circuit_add(in49, t0);
    let t233 = circuit_inverse(t232);
    let t234 = circuit_mul(t229, t231);
    let t235 = circuit_mul(in50, t233);
    let t236 = circuit_mul(t229, t235);
    let t237 = circuit_add(t236, t234);
    let t238 = circuit_sub(in0, t237);
    let t239 = circuit_mul(t236, in43);
    let t240 = circuit_mul(t234, t214);
    let t241 = circuit_add(t239, t240);
    let t242 = circuit_add(t228, t241);
    let t243 = circuit_mul(in50, in50);
    let t244 = circuit_mul(t229, t243);
    let t245 = circuit_sub(in49, t1);
    let t246 = circuit_inverse(t245);
    let t247 = circuit_add(in49, t1);
    let t248 = circuit_inverse(t247);
    let t249 = circuit_mul(t244, t246);
    let t250 = circuit_mul(in50, t248);
    let t251 = circuit_mul(t244, t250);
    let t252 = circuit_add(t251, t249);
    let t253 = circuit_sub(in0, t252);
    let t254 = circuit_mul(t251, in44);
    let t255 = circuit_mul(t249, t204);
    let t256 = circuit_add(t254, t255);
    let t257 = circuit_add(t242, t256);
    let t258 = circuit_mul(in50, in50);
    let t259 = circuit_mul(t244, t258);
    let t260 = circuit_sub(in49, t2);
    let t261 = circuit_inverse(t260);
    let t262 = circuit_add(in49, t2);
    let t263 = circuit_inverse(t262);
    let t264 = circuit_mul(t259, t261);
    let t265 = circuit_mul(in50, t263);
    let t266 = circuit_mul(t259, t265);
    let t267 = circuit_add(t266, t264);
    let t268 = circuit_sub(in0, t267);
    let t269 = circuit_mul(t266, in45);
    let t270 = circuit_mul(t264, t194);
    let t271 = circuit_add(t269, t270);
    let t272 = circuit_add(t257, t271);
    let t273 = circuit_mul(in50, in50);
    let t274 = circuit_mul(t259, t273);
    let t275 = circuit_sub(in49, t3);
    let t276 = circuit_inverse(t275);
    let t277 = circuit_add(in49, t3);
    let t278 = circuit_inverse(t277);
    let t279 = circuit_mul(t274, t276);
    let t280 = circuit_mul(in50, t278);
    let t281 = circuit_mul(t274, t280);
    let t282 = circuit_add(t281, t279);
    let t283 = circuit_sub(in0, t282);
    let t284 = circuit_mul(t281, in46);
    let t285 = circuit_mul(t279, t184);
    let t286 = circuit_add(t284, t285);
    let t287 = circuit_add(t272, t286);
    let t288 = circuit_add(t124, t156);
    let t289 = circuit_add(t128, t160);
    let t290 = circuit_add(t132, t164);
    let t291 = circuit_add(t136, t168);
    let t292 = circuit_add(t140, t172);

    let modulus = get_GRUMPKIN_modulus(); // GRUMPKIN prime field modulus

    let mut circuit_inputs = (
        t16,
        t20,
        t24,
        t28,
        t32,
        t36,
        t40,
        t44,
        t48,
        t52,
        t56,
        t60,
        t64,
        t68,
        t72,
        t76,
        t80,
        t84,
        t88,
        t92,
        t96,
        t100,
        t104,
        t108,
        t112,
        t116,
        t120,
        t288,
        t289,
        t290,
        t291,
        t292,
        t144,
        t148,
        t152,
        t238,
        t253,
        t268,
        t283,
        t287,
    )
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs.next_2([0x1, 0x0, 0x0, 0x0]); // in1
    // Fill inputs:

    for val in p_sumcheck_evaluations {
        circuit_inputs = circuit_inputs.next_u256(*val);
    } // in2 - in41

    for val in p_gemini_a_evaluations {
        circuit_inputs = circuit_inputs.next_u256(*val);
    } // in42 - in46

    circuit_inputs = circuit_inputs.next_2(tp_gemini_r); // in47
    circuit_inputs = circuit_inputs.next_2(tp_rho); // in48
    circuit_inputs = circuit_inputs.next_2(tp_shplonk_z); // in49
    circuit_inputs = circuit_inputs.next_2(tp_shplonk_nu); // in50

    for val in tp_sum_check_u_challenges {
        circuit_inputs = circuit_inputs.next_u128(*val);
    } // in51 - in55

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let scalar_1: u384 = outputs.get_output(t16);
    let scalar_2: u384 = outputs.get_output(t20);
    let scalar_3: u384 = outputs.get_output(t24);
    let scalar_4: u384 = outputs.get_output(t28);
    let scalar_5: u384 = outputs.get_output(t32);
    let scalar_6: u384 = outputs.get_output(t36);
    let scalar_7: u384 = outputs.get_output(t40);
    let scalar_8: u384 = outputs.get_output(t44);
    let scalar_9: u384 = outputs.get_output(t48);
    let scalar_10: u384 = outputs.get_output(t52);
    let scalar_11: u384 = outputs.get_output(t56);
    let scalar_12: u384 = outputs.get_output(t60);
    let scalar_13: u384 = outputs.get_output(t64);
    let scalar_14: u384 = outputs.get_output(t68);
    let scalar_15: u384 = outputs.get_output(t72);
    let scalar_16: u384 = outputs.get_output(t76);
    let scalar_17: u384 = outputs.get_output(t80);
    let scalar_18: u384 = outputs.get_output(t84);
    let scalar_19: u384 = outputs.get_output(t88);
    let scalar_20: u384 = outputs.get_output(t92);
    let scalar_21: u384 = outputs.get_output(t96);
    let scalar_22: u384 = outputs.get_output(t100);
    let scalar_23: u384 = outputs.get_output(t104);
    let scalar_24: u384 = outputs.get_output(t108);
    let scalar_25: u384 = outputs.get_output(t112);
    let scalar_26: u384 = outputs.get_output(t116);
    let scalar_27: u384 = outputs.get_output(t120);
    let scalar_28: u384 = outputs.get_output(t288);
    let scalar_29: u384 = outputs.get_output(t289);
    let scalar_30: u384 = outputs.get_output(t290);
    let scalar_31: u384 = outputs.get_output(t291);
    let scalar_32: u384 = outputs.get_output(t292);
    let scalar_33: u384 = outputs.get_output(t144);
    let scalar_34: u384 = outputs.get_output(t148);
    let scalar_35: u384 = outputs.get_output(t152);
    let scalar_41: u384 = outputs.get_output(t238);
    let scalar_42: u384 = outputs.get_output(t253);
    let scalar_43: u384 = outputs.get_output(t268);
    let scalar_44: u384 = outputs.get_output(t283);
    let scalar_68: u384 = outputs.get_output(t287);
    return (
        scalar_1,
        scalar_2,
        scalar_3,
        scalar_4,
        scalar_5,
        scalar_6,
        scalar_7,
        scalar_8,
        scalar_9,
        scalar_10,
        scalar_11,
        scalar_12,
        scalar_13,
        scalar_14,
        scalar_15,
        scalar_16,
        scalar_17,
        scalar_18,
        scalar_19,
        scalar_20,
        scalar_21,
        scalar_22,
        scalar_23,
        scalar_24,
        scalar_25,
        scalar_26,
        scalar_27,
        scalar_28,
        scalar_29,
        scalar_30,
        scalar_31,
        scalar_32,
        scalar_33,
        scalar_34,
        scalar_35,
        scalar_41,
        scalar_42,
        scalar_43,
        scalar_44,
        scalar_68,
    );
}
pub fn run_BN254_EVAL_FN_CHALLENGE_SING_41P_RLC_circuit<
    T, +IntoCircuitInputValue<T>, +Drop<T>, +Copy<T>,
>(
    A: G1Point, coeff: u384, SumDlogDivBatched: FunctionFelt<T>,
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
    let (in126, in127, in128) = (CE::<CI<126>> {}, CE::<CI<127>> {}, CE::<CI<128>> {});
    let (in129, in130, in131) = (CE::<CI<129>> {}, CE::<CI<130>> {}, CE::<CI<131>> {});
    let (in132, in133, in134) = (CE::<CI<132>> {}, CE::<CI<133>> {}, CE::<CI<134>> {});
    let (in135, in136, in137) = (CE::<CI<135>> {}, CE::<CI<136>> {}, CE::<CI<137>> {});
    let (in138, in139, in140) = (CE::<CI<138>> {}, CE::<CI<139>> {}, CE::<CI<140>> {});
    let (in141, in142, in143) = (CE::<CI<141>> {}, CE::<CI<142>> {}, CE::<CI<143>> {});
    let (in144, in145, in146) = (CE::<CI<144>> {}, CE::<CI<145>> {}, CE::<CI<146>> {});
    let (in147, in148, in149) = (CE::<CI<147>> {}, CE::<CI<148>> {}, CE::<CI<149>> {});
    let (in150, in151, in152) = (CE::<CI<150>> {}, CE::<CI<151>> {}, CE::<CI<152>> {});
    let (in153, in154, in155) = (CE::<CI<153>> {}, CE::<CI<154>> {}, CE::<CI<155>> {});
    let (in156, in157, in158) = (CE::<CI<156>> {}, CE::<CI<157>> {}, CE::<CI<158>> {});
    let (in159, in160, in161) = (CE::<CI<159>> {}, CE::<CI<160>> {}, CE::<CI<161>> {});
    let (in162, in163, in164) = (CE::<CI<162>> {}, CE::<CI<163>> {}, CE::<CI<164>> {});
    let (in165, in166, in167) = (CE::<CI<165>> {}, CE::<CI<166>> {}, CE::<CI<167>> {});
    let (in168, in169, in170) = (CE::<CI<168>> {}, CE::<CI<169>> {}, CE::<CI<170>> {});
    let (in171, in172, in173) = (CE::<CI<171>> {}, CE::<CI<172>> {}, CE::<CI<173>> {});
    let (in174, in175, in176) = (CE::<CI<174>> {}, CE::<CI<175>> {}, CE::<CI<176>> {});
    let (in177, in178, in179) = (CE::<CI<177>> {}, CE::<CI<178>> {}, CE::<CI<179>> {});
    let (in180, in181, in182) = (CE::<CI<180>> {}, CE::<CI<181>> {}, CE::<CI<182>> {});
    let (in183, in184) = (CE::<CI<183>> {}, CE::<CI<184>> {});
    let t0 = circuit_mul(in46, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t1 = circuit_add(in45, t0); // Eval sumdlogdiv_a_num Horner step: add coefficient_42
    let t2 = circuit_mul(t1, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t3 = circuit_add(in44, t2); // Eval sumdlogdiv_a_num Horner step: add coefficient_41
    let t4 = circuit_mul(t3, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t5 = circuit_add(in43, t4); // Eval sumdlogdiv_a_num Horner step: add coefficient_40
    let t6 = circuit_mul(t5, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t7 = circuit_add(in42, t6); // Eval sumdlogdiv_a_num Horner step: add coefficient_39
    let t8 = circuit_mul(t7, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t9 = circuit_add(in41, t8); // Eval sumdlogdiv_a_num Horner step: add coefficient_38
    let t10 = circuit_mul(t9, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t11 = circuit_add(in40, t10); // Eval sumdlogdiv_a_num Horner step: add coefficient_37
    let t12 = circuit_mul(t11, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t13 = circuit_add(in39, t12); // Eval sumdlogdiv_a_num Horner step: add coefficient_36
    let t14 = circuit_mul(t13, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t15 = circuit_add(in38, t14); // Eval sumdlogdiv_a_num Horner step: add coefficient_35
    let t16 = circuit_mul(t15, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t17 = circuit_add(in37, t16); // Eval sumdlogdiv_a_num Horner step: add coefficient_34
    let t18 = circuit_mul(t17, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t19 = circuit_add(in36, t18); // Eval sumdlogdiv_a_num Horner step: add coefficient_33
    let t20 = circuit_mul(t19, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t21 = circuit_add(in35, t20); // Eval sumdlogdiv_a_num Horner step: add coefficient_32
    let t22 = circuit_mul(t21, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t23 = circuit_add(in34, t22); // Eval sumdlogdiv_a_num Horner step: add coefficient_31
    let t24 = circuit_mul(t23, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t25 = circuit_add(in33, t24); // Eval sumdlogdiv_a_num Horner step: add coefficient_30
    let t26 = circuit_mul(t25, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t27 = circuit_add(in32, t26); // Eval sumdlogdiv_a_num Horner step: add coefficient_29
    let t28 = circuit_mul(t27, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t29 = circuit_add(in31, t28); // Eval sumdlogdiv_a_num Horner step: add coefficient_28
    let t30 = circuit_mul(t29, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t31 = circuit_add(in30, t30); // Eval sumdlogdiv_a_num Horner step: add coefficient_27
    let t32 = circuit_mul(t31, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t33 = circuit_add(in29, t32); // Eval sumdlogdiv_a_num Horner step: add coefficient_26
    let t34 = circuit_mul(t33, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t35 = circuit_add(in28, t34); // Eval sumdlogdiv_a_num Horner step: add coefficient_25
    let t36 = circuit_mul(t35, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t37 = circuit_add(in27, t36); // Eval sumdlogdiv_a_num Horner step: add coefficient_24
    let t38 = circuit_mul(t37, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t39 = circuit_add(in26, t38); // Eval sumdlogdiv_a_num Horner step: add coefficient_23
    let t40 = circuit_mul(t39, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t41 = circuit_add(in25, t40); // Eval sumdlogdiv_a_num Horner step: add coefficient_22
    let t42 = circuit_mul(t41, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t43 = circuit_add(in24, t42); // Eval sumdlogdiv_a_num Horner step: add coefficient_21
    let t44 = circuit_mul(t43, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t45 = circuit_add(in23, t44); // Eval sumdlogdiv_a_num Horner step: add coefficient_20
    let t46 = circuit_mul(t45, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t47 = circuit_add(in22, t46); // Eval sumdlogdiv_a_num Horner step: add coefficient_19
    let t48 = circuit_mul(t47, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t49 = circuit_add(in21, t48); // Eval sumdlogdiv_a_num Horner step: add coefficient_18
    let t50 = circuit_mul(t49, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t51 = circuit_add(in20, t50); // Eval sumdlogdiv_a_num Horner step: add coefficient_17
    let t52 = circuit_mul(t51, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t53 = circuit_add(in19, t52); // Eval sumdlogdiv_a_num Horner step: add coefficient_16
    let t54 = circuit_mul(t53, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t55 = circuit_add(in18, t54); // Eval sumdlogdiv_a_num Horner step: add coefficient_15
    let t56 = circuit_mul(t55, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t57 = circuit_add(in17, t56); // Eval sumdlogdiv_a_num Horner step: add coefficient_14
    let t58 = circuit_mul(t57, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t59 = circuit_add(in16, t58); // Eval sumdlogdiv_a_num Horner step: add coefficient_13
    let t60 = circuit_mul(t59, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t61 = circuit_add(in15, t60); // Eval sumdlogdiv_a_num Horner step: add coefficient_12
    let t62 = circuit_mul(t61, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t63 = circuit_add(in14, t62); // Eval sumdlogdiv_a_num Horner step: add coefficient_11
    let t64 = circuit_mul(t63, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t65 = circuit_add(in13, t64); // Eval sumdlogdiv_a_num Horner step: add coefficient_10
    let t66 = circuit_mul(t65, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t67 = circuit_add(in12, t66); // Eval sumdlogdiv_a_num Horner step: add coefficient_9
    let t68 = circuit_mul(t67, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t69 = circuit_add(in11, t68); // Eval sumdlogdiv_a_num Horner step: add coefficient_8
    let t70 = circuit_mul(t69, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t71 = circuit_add(in10, t70); // Eval sumdlogdiv_a_num Horner step: add coefficient_7
    let t72 = circuit_mul(t71, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t73 = circuit_add(in9, t72); // Eval sumdlogdiv_a_num Horner step: add coefficient_6
    let t74 = circuit_mul(t73, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t75 = circuit_add(in8, t74); // Eval sumdlogdiv_a_num Horner step: add coefficient_5
    let t76 = circuit_mul(t75, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t77 = circuit_add(in7, t76); // Eval sumdlogdiv_a_num Horner step: add coefficient_4
    let t78 = circuit_mul(t77, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t79 = circuit_add(in6, t78); // Eval sumdlogdiv_a_num Horner step: add coefficient_3
    let t80 = circuit_mul(t79, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t81 = circuit_add(in5, t80); // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    let t82 = circuit_mul(t81, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t83 = circuit_add(in4, t82); // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    let t84 = circuit_mul(t83, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t85 = circuit_add(in3, t84); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t86 = circuit_mul(in91, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t87 = circuit_add(in90, t86); // Eval sumdlogdiv_a_den Horner step: add coefficient_43
    let t88 = circuit_mul(t87, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t89 = circuit_add(in89, t88); // Eval sumdlogdiv_a_den Horner step: add coefficient_42
    let t90 = circuit_mul(t89, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t91 = circuit_add(in88, t90); // Eval sumdlogdiv_a_den Horner step: add coefficient_41
    let t92 = circuit_mul(t91, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t93 = circuit_add(in87, t92); // Eval sumdlogdiv_a_den Horner step: add coefficient_40
    let t94 = circuit_mul(t93, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t95 = circuit_add(in86, t94); // Eval sumdlogdiv_a_den Horner step: add coefficient_39
    let t96 = circuit_mul(t95, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t97 = circuit_add(in85, t96); // Eval sumdlogdiv_a_den Horner step: add coefficient_38
    let t98 = circuit_mul(t97, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t99 = circuit_add(in84, t98); // Eval sumdlogdiv_a_den Horner step: add coefficient_37
    let t100 = circuit_mul(t99, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t101 = circuit_add(in83, t100); // Eval sumdlogdiv_a_den Horner step: add coefficient_36
    let t102 = circuit_mul(t101, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t103 = circuit_add(in82, t102); // Eval sumdlogdiv_a_den Horner step: add coefficient_35
    let t104 = circuit_mul(t103, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t105 = circuit_add(in81, t104); // Eval sumdlogdiv_a_den Horner step: add coefficient_34
    let t106 = circuit_mul(t105, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t107 = circuit_add(in80, t106); // Eval sumdlogdiv_a_den Horner step: add coefficient_33
    let t108 = circuit_mul(t107, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t109 = circuit_add(in79, t108); // Eval sumdlogdiv_a_den Horner step: add coefficient_32
    let t110 = circuit_mul(t109, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t111 = circuit_add(in78, t110); // Eval sumdlogdiv_a_den Horner step: add coefficient_31
    let t112 = circuit_mul(t111, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t113 = circuit_add(in77, t112); // Eval sumdlogdiv_a_den Horner step: add coefficient_30
    let t114 = circuit_mul(t113, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t115 = circuit_add(in76, t114); // Eval sumdlogdiv_a_den Horner step: add coefficient_29
    let t116 = circuit_mul(t115, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t117 = circuit_add(in75, t116); // Eval sumdlogdiv_a_den Horner step: add coefficient_28
    let t118 = circuit_mul(t117, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t119 = circuit_add(in74, t118); // Eval sumdlogdiv_a_den Horner step: add coefficient_27
    let t120 = circuit_mul(t119, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t121 = circuit_add(in73, t120); // Eval sumdlogdiv_a_den Horner step: add coefficient_26
    let t122 = circuit_mul(t121, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t123 = circuit_add(in72, t122); // Eval sumdlogdiv_a_den Horner step: add coefficient_25
    let t124 = circuit_mul(t123, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t125 = circuit_add(in71, t124); // Eval sumdlogdiv_a_den Horner step: add coefficient_24
    let t126 = circuit_mul(t125, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t127 = circuit_add(in70, t126); // Eval sumdlogdiv_a_den Horner step: add coefficient_23
    let t128 = circuit_mul(t127, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t129 = circuit_add(in69, t128); // Eval sumdlogdiv_a_den Horner step: add coefficient_22
    let t130 = circuit_mul(t129, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t131 = circuit_add(in68, t130); // Eval sumdlogdiv_a_den Horner step: add coefficient_21
    let t132 = circuit_mul(t131, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t133 = circuit_add(in67, t132); // Eval sumdlogdiv_a_den Horner step: add coefficient_20
    let t134 = circuit_mul(t133, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t135 = circuit_add(in66, t134); // Eval sumdlogdiv_a_den Horner step: add coefficient_19
    let t136 = circuit_mul(t135, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t137 = circuit_add(in65, t136); // Eval sumdlogdiv_a_den Horner step: add coefficient_18
    let t138 = circuit_mul(t137, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t139 = circuit_add(in64, t138); // Eval sumdlogdiv_a_den Horner step: add coefficient_17
    let t140 = circuit_mul(t139, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t141 = circuit_add(in63, t140); // Eval sumdlogdiv_a_den Horner step: add coefficient_16
    let t142 = circuit_mul(t141, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t143 = circuit_add(in62, t142); // Eval sumdlogdiv_a_den Horner step: add coefficient_15
    let t144 = circuit_mul(t143, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t145 = circuit_add(in61, t144); // Eval sumdlogdiv_a_den Horner step: add coefficient_14
    let t146 = circuit_mul(t145, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t147 = circuit_add(in60, t146); // Eval sumdlogdiv_a_den Horner step: add coefficient_13
    let t148 = circuit_mul(t147, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t149 = circuit_add(in59, t148); // Eval sumdlogdiv_a_den Horner step: add coefficient_12
    let t150 = circuit_mul(t149, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t151 = circuit_add(in58, t150); // Eval sumdlogdiv_a_den Horner step: add coefficient_11
    let t152 = circuit_mul(t151, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t153 = circuit_add(in57, t152); // Eval sumdlogdiv_a_den Horner step: add coefficient_10
    let t154 = circuit_mul(t153, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t155 = circuit_add(in56, t154); // Eval sumdlogdiv_a_den Horner step: add coefficient_9
    let t156 = circuit_mul(t155, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t157 = circuit_add(in55, t156); // Eval sumdlogdiv_a_den Horner step: add coefficient_8
    let t158 = circuit_mul(t157, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t159 = circuit_add(in54, t158); // Eval sumdlogdiv_a_den Horner step: add coefficient_7
    let t160 = circuit_mul(t159, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t161 = circuit_add(in53, t160); // Eval sumdlogdiv_a_den Horner step: add coefficient_6
    let t162 = circuit_mul(t161, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t163 = circuit_add(in52, t162); // Eval sumdlogdiv_a_den Horner step: add coefficient_5
    let t164 = circuit_mul(t163, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t165 = circuit_add(in51, t164); // Eval sumdlogdiv_a_den Horner step: add coefficient_4
    let t166 = circuit_mul(t165, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t167 = circuit_add(in50, t166); // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    let t168 = circuit_mul(t167, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t169 = circuit_add(in49, t168); // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    let t170 = circuit_mul(t169, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t171 = circuit_add(in48, t170); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t172 = circuit_mul(t171, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t173 = circuit_add(in47, t172); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t174 = circuit_inverse(t173);
    let t175 = circuit_mul(t85, t174);
    let t176 = circuit_mul(in136, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t177 = circuit_add(in135, t176); // Eval sumdlogdiv_b_num Horner step: add coefficient_43
    let t178 = circuit_mul(t177, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t179 = circuit_add(in134, t178); // Eval sumdlogdiv_b_num Horner step: add coefficient_42
    let t180 = circuit_mul(t179, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t181 = circuit_add(in133, t180); // Eval sumdlogdiv_b_num Horner step: add coefficient_41
    let t182 = circuit_mul(t181, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t183 = circuit_add(in132, t182); // Eval sumdlogdiv_b_num Horner step: add coefficient_40
    let t184 = circuit_mul(t183, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t185 = circuit_add(in131, t184); // Eval sumdlogdiv_b_num Horner step: add coefficient_39
    let t186 = circuit_mul(t185, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t187 = circuit_add(in130, t186); // Eval sumdlogdiv_b_num Horner step: add coefficient_38
    let t188 = circuit_mul(t187, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t189 = circuit_add(in129, t188); // Eval sumdlogdiv_b_num Horner step: add coefficient_37
    let t190 = circuit_mul(t189, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t191 = circuit_add(in128, t190); // Eval sumdlogdiv_b_num Horner step: add coefficient_36
    let t192 = circuit_mul(t191, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t193 = circuit_add(in127, t192); // Eval sumdlogdiv_b_num Horner step: add coefficient_35
    let t194 = circuit_mul(t193, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t195 = circuit_add(in126, t194); // Eval sumdlogdiv_b_num Horner step: add coefficient_34
    let t196 = circuit_mul(t195, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t197 = circuit_add(in125, t196); // Eval sumdlogdiv_b_num Horner step: add coefficient_33
    let t198 = circuit_mul(t197, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t199 = circuit_add(in124, t198); // Eval sumdlogdiv_b_num Horner step: add coefficient_32
    let t200 = circuit_mul(t199, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t201 = circuit_add(in123, t200); // Eval sumdlogdiv_b_num Horner step: add coefficient_31
    let t202 = circuit_mul(t201, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t203 = circuit_add(in122, t202); // Eval sumdlogdiv_b_num Horner step: add coefficient_30
    let t204 = circuit_mul(t203, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t205 = circuit_add(in121, t204); // Eval sumdlogdiv_b_num Horner step: add coefficient_29
    let t206 = circuit_mul(t205, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t207 = circuit_add(in120, t206); // Eval sumdlogdiv_b_num Horner step: add coefficient_28
    let t208 = circuit_mul(t207, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t209 = circuit_add(in119, t208); // Eval sumdlogdiv_b_num Horner step: add coefficient_27
    let t210 = circuit_mul(t209, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t211 = circuit_add(in118, t210); // Eval sumdlogdiv_b_num Horner step: add coefficient_26
    let t212 = circuit_mul(t211, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t213 = circuit_add(in117, t212); // Eval sumdlogdiv_b_num Horner step: add coefficient_25
    let t214 = circuit_mul(t213, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t215 = circuit_add(in116, t214); // Eval sumdlogdiv_b_num Horner step: add coefficient_24
    let t216 = circuit_mul(t215, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t217 = circuit_add(in115, t216); // Eval sumdlogdiv_b_num Horner step: add coefficient_23
    let t218 = circuit_mul(t217, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t219 = circuit_add(in114, t218); // Eval sumdlogdiv_b_num Horner step: add coefficient_22
    let t220 = circuit_mul(t219, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t221 = circuit_add(in113, t220); // Eval sumdlogdiv_b_num Horner step: add coefficient_21
    let t222 = circuit_mul(t221, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t223 = circuit_add(in112, t222); // Eval sumdlogdiv_b_num Horner step: add coefficient_20
    let t224 = circuit_mul(t223, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t225 = circuit_add(in111, t224); // Eval sumdlogdiv_b_num Horner step: add coefficient_19
    let t226 = circuit_mul(t225, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t227 = circuit_add(in110, t226); // Eval sumdlogdiv_b_num Horner step: add coefficient_18
    let t228 = circuit_mul(t227, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t229 = circuit_add(in109, t228); // Eval sumdlogdiv_b_num Horner step: add coefficient_17
    let t230 = circuit_mul(t229, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t231 = circuit_add(in108, t230); // Eval sumdlogdiv_b_num Horner step: add coefficient_16
    let t232 = circuit_mul(t231, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t233 = circuit_add(in107, t232); // Eval sumdlogdiv_b_num Horner step: add coefficient_15
    let t234 = circuit_mul(t233, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t235 = circuit_add(in106, t234); // Eval sumdlogdiv_b_num Horner step: add coefficient_14
    let t236 = circuit_mul(t235, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t237 = circuit_add(in105, t236); // Eval sumdlogdiv_b_num Horner step: add coefficient_13
    let t238 = circuit_mul(t237, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t239 = circuit_add(in104, t238); // Eval sumdlogdiv_b_num Horner step: add coefficient_12
    let t240 = circuit_mul(t239, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t241 = circuit_add(in103, t240); // Eval sumdlogdiv_b_num Horner step: add coefficient_11
    let t242 = circuit_mul(t241, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t243 = circuit_add(in102, t242); // Eval sumdlogdiv_b_num Horner step: add coefficient_10
    let t244 = circuit_mul(t243, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t245 = circuit_add(in101, t244); // Eval sumdlogdiv_b_num Horner step: add coefficient_9
    let t246 = circuit_mul(t245, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t247 = circuit_add(in100, t246); // Eval sumdlogdiv_b_num Horner step: add coefficient_8
    let t248 = circuit_mul(t247, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t249 = circuit_add(in99, t248); // Eval sumdlogdiv_b_num Horner step: add coefficient_7
    let t250 = circuit_mul(t249, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t251 = circuit_add(in98, t250); // Eval sumdlogdiv_b_num Horner step: add coefficient_6
    let t252 = circuit_mul(t251, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t253 = circuit_add(in97, t252); // Eval sumdlogdiv_b_num Horner step: add coefficient_5
    let t254 = circuit_mul(t253, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t255 = circuit_add(in96, t254); // Eval sumdlogdiv_b_num Horner step: add coefficient_4
    let t256 = circuit_mul(t255, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t257 = circuit_add(in95, t256); // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    let t258 = circuit_mul(t257, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t259 = circuit_add(in94, t258); // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    let t260 = circuit_mul(t259, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t261 = circuit_add(in93, t260); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t262 = circuit_mul(t261, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t263 = circuit_add(in92, t262); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t264 = circuit_mul(in184, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t265 = circuit_add(in183, t264); // Eval sumdlogdiv_b_den Horner step: add coefficient_46
    let t266 = circuit_mul(t265, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t267 = circuit_add(in182, t266); // Eval sumdlogdiv_b_den Horner step: add coefficient_45
    let t268 = circuit_mul(t267, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t269 = circuit_add(in181, t268); // Eval sumdlogdiv_b_den Horner step: add coefficient_44
    let t270 = circuit_mul(t269, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t271 = circuit_add(in180, t270); // Eval sumdlogdiv_b_den Horner step: add coefficient_43
    let t272 = circuit_mul(t271, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t273 = circuit_add(in179, t272); // Eval sumdlogdiv_b_den Horner step: add coefficient_42
    let t274 = circuit_mul(t273, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t275 = circuit_add(in178, t274); // Eval sumdlogdiv_b_den Horner step: add coefficient_41
    let t276 = circuit_mul(t275, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t277 = circuit_add(in177, t276); // Eval sumdlogdiv_b_den Horner step: add coefficient_40
    let t278 = circuit_mul(t277, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t279 = circuit_add(in176, t278); // Eval sumdlogdiv_b_den Horner step: add coefficient_39
    let t280 = circuit_mul(t279, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t281 = circuit_add(in175, t280); // Eval sumdlogdiv_b_den Horner step: add coefficient_38
    let t282 = circuit_mul(t281, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t283 = circuit_add(in174, t282); // Eval sumdlogdiv_b_den Horner step: add coefficient_37
    let t284 = circuit_mul(t283, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t285 = circuit_add(in173, t284); // Eval sumdlogdiv_b_den Horner step: add coefficient_36
    let t286 = circuit_mul(t285, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t287 = circuit_add(in172, t286); // Eval sumdlogdiv_b_den Horner step: add coefficient_35
    let t288 = circuit_mul(t287, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t289 = circuit_add(in171, t288); // Eval sumdlogdiv_b_den Horner step: add coefficient_34
    let t290 = circuit_mul(t289, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t291 = circuit_add(in170, t290); // Eval sumdlogdiv_b_den Horner step: add coefficient_33
    let t292 = circuit_mul(t291, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t293 = circuit_add(in169, t292); // Eval sumdlogdiv_b_den Horner step: add coefficient_32
    let t294 = circuit_mul(t293, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t295 = circuit_add(in168, t294); // Eval sumdlogdiv_b_den Horner step: add coefficient_31
    let t296 = circuit_mul(t295, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t297 = circuit_add(in167, t296); // Eval sumdlogdiv_b_den Horner step: add coefficient_30
    let t298 = circuit_mul(t297, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t299 = circuit_add(in166, t298); // Eval sumdlogdiv_b_den Horner step: add coefficient_29
    let t300 = circuit_mul(t299, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t301 = circuit_add(in165, t300); // Eval sumdlogdiv_b_den Horner step: add coefficient_28
    let t302 = circuit_mul(t301, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t303 = circuit_add(in164, t302); // Eval sumdlogdiv_b_den Horner step: add coefficient_27
    let t304 = circuit_mul(t303, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t305 = circuit_add(in163, t304); // Eval sumdlogdiv_b_den Horner step: add coefficient_26
    let t306 = circuit_mul(t305, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t307 = circuit_add(in162, t306); // Eval sumdlogdiv_b_den Horner step: add coefficient_25
    let t308 = circuit_mul(t307, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t309 = circuit_add(in161, t308); // Eval sumdlogdiv_b_den Horner step: add coefficient_24
    let t310 = circuit_mul(t309, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t311 = circuit_add(in160, t310); // Eval sumdlogdiv_b_den Horner step: add coefficient_23
    let t312 = circuit_mul(t311, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t313 = circuit_add(in159, t312); // Eval sumdlogdiv_b_den Horner step: add coefficient_22
    let t314 = circuit_mul(t313, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t315 = circuit_add(in158, t314); // Eval sumdlogdiv_b_den Horner step: add coefficient_21
    let t316 = circuit_mul(t315, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t317 = circuit_add(in157, t316); // Eval sumdlogdiv_b_den Horner step: add coefficient_20
    let t318 = circuit_mul(t317, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t319 = circuit_add(in156, t318); // Eval sumdlogdiv_b_den Horner step: add coefficient_19
    let t320 = circuit_mul(t319, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t321 = circuit_add(in155, t320); // Eval sumdlogdiv_b_den Horner step: add coefficient_18
    let t322 = circuit_mul(t321, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t323 = circuit_add(in154, t322); // Eval sumdlogdiv_b_den Horner step: add coefficient_17
    let t324 = circuit_mul(t323, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t325 = circuit_add(in153, t324); // Eval sumdlogdiv_b_den Horner step: add coefficient_16
    let t326 = circuit_mul(t325, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t327 = circuit_add(in152, t326); // Eval sumdlogdiv_b_den Horner step: add coefficient_15
    let t328 = circuit_mul(t327, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t329 = circuit_add(in151, t328); // Eval sumdlogdiv_b_den Horner step: add coefficient_14
    let t330 = circuit_mul(t329, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t331 = circuit_add(in150, t330); // Eval sumdlogdiv_b_den Horner step: add coefficient_13
    let t332 = circuit_mul(t331, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t333 = circuit_add(in149, t332); // Eval sumdlogdiv_b_den Horner step: add coefficient_12
    let t334 = circuit_mul(t333, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t335 = circuit_add(in148, t334); // Eval sumdlogdiv_b_den Horner step: add coefficient_11
    let t336 = circuit_mul(t335, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t337 = circuit_add(in147, t336); // Eval sumdlogdiv_b_den Horner step: add coefficient_10
    let t338 = circuit_mul(t337, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t339 = circuit_add(in146, t338); // Eval sumdlogdiv_b_den Horner step: add coefficient_9
    let t340 = circuit_mul(t339, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t341 = circuit_add(in145, t340); // Eval sumdlogdiv_b_den Horner step: add coefficient_8
    let t342 = circuit_mul(t341, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t343 = circuit_add(in144, t342); // Eval sumdlogdiv_b_den Horner step: add coefficient_7
    let t344 = circuit_mul(t343, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t345 = circuit_add(in143, t344); // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    let t346 = circuit_mul(t345, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t347 = circuit_add(in142, t346); // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    let t348 = circuit_mul(t347, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t349 = circuit_add(in141, t348); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t350 = circuit_mul(t349, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t351 = circuit_add(in140, t350); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t352 = circuit_mul(t351, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t353 = circuit_add(in139, t352); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t354 = circuit_mul(t353, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t355 = circuit_add(in138, t354); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t356 = circuit_mul(t355, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t357 = circuit_add(in137, t356); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t358 = circuit_inverse(t357);
    let t359 = circuit_mul(t263, t358);
    let t360 = circuit_mul(in1, t359);
    let t361 = circuit_add(t175, t360);
    let t362 = circuit_mul(in2, t361);

    let modulus = get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (t362,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(A.x); // in0
    circuit_inputs = circuit_inputs.next_2(A.y); // in1
    circuit_inputs = circuit_inputs.next_2(coeff); // in2

    for val in SumDlogDivBatched.a_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.a_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.b_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.b_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }
    // in3 - in184

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: u384 = outputs.get_output(t362);
    return (res,);
}

impl CircuitDefinition40<
    E0,
    E1,
    E2,
    E3,
    E4,
    E5,
    E6,
    E7,
    E8,
    E9,
    E10,
    E11,
    E12,
    E13,
    E14,
    E15,
    E16,
    E17,
    E18,
    E19,
    E20,
    E21,
    E22,
    E23,
    E24,
    E25,
    E26,
    E27,
    E28,
    E29,
    E30,
    E31,
    E32,
    E33,
    E34,
    E35,
    E36,
    E37,
    E38,
    E39,
> of core::circuit::CircuitDefinition<
    (
        CE<E0>,
        CE<E1>,
        CE<E2>,
        CE<E3>,
        CE<E4>,
        CE<E5>,
        CE<E6>,
        CE<E7>,
        CE<E8>,
        CE<E9>,
        CE<E10>,
        CE<E11>,
        CE<E12>,
        CE<E13>,
        CE<E14>,
        CE<E15>,
        CE<E16>,
        CE<E17>,
        CE<E18>,
        CE<E19>,
        CE<E20>,
        CE<E21>,
        CE<E22>,
        CE<E23>,
        CE<E24>,
        CE<E25>,
        CE<E26>,
        CE<E27>,
        CE<E28>,
        CE<E29>,
        CE<E30>,
        CE<E31>,
        CE<E32>,
        CE<E33>,
        CE<E34>,
        CE<E35>,
        CE<E36>,
        CE<E37>,
        CE<E38>,
        CE<E39>,
    ),
> {
    type CircuitType =
        core::circuit::Circuit<
            (
                E0,
                E1,
                E2,
                E3,
                E4,
                E5,
                E6,
                E7,
                E8,
                E9,
                E10,
                E11,
                E12,
                E13,
                E14,
                E15,
                E16,
                E17,
                E18,
                E19,
                E20,
                E21,
                E22,
                E23,
                E24,
                E25,
                E26,
                E27,
                E28,
                E29,
                E30,
                E31,
                E32,
                E33,
                E34,
                E35,
                E36,
                E37,
                E38,
                E39,
            ),
        >;
}
impl MyDrp_40<
    E0,
    E1,
    E2,
    E3,
    E4,
    E5,
    E6,
    E7,
    E8,
    E9,
    E10,
    E11,
    E12,
    E13,
    E14,
    E15,
    E16,
    E17,
    E18,
    E19,
    E20,
    E21,
    E22,
    E23,
    E24,
    E25,
    E26,
    E27,
    E28,
    E29,
    E30,
    E31,
    E32,
    E33,
    E34,
    E35,
    E36,
    E37,
    E38,
    E39,
> of Drop<
    (
        CE<E0>,
        CE<E1>,
        CE<E2>,
        CE<E3>,
        CE<E4>,
        CE<E5>,
        CE<E6>,
        CE<E7>,
        CE<E8>,
        CE<E9>,
        CE<E10>,
        CE<E11>,
        CE<E12>,
        CE<E13>,
        CE<E14>,
        CE<E15>,
        CE<E16>,
        CE<E17>,
        CE<E18>,
        CE<E19>,
        CE<E20>,
        CE<E21>,
        CE<E22>,
        CE<E23>,
        CE<E24>,
        CE<E25>,
        CE<E26>,
        CE<E27>,
        CE<E28>,
        CE<E29>,
        CE<E30>,
        CE<E31>,
        CE<E32>,
        CE<E33>,
        CE<E34>,
        CE<E35>,
        CE<E36>,
        CE<E37>,
        CE<E38>,
        CE<E39>,
    ),
>;

#[inline(never)]
pub fn is_on_curve_bn254(p: G1Point, modulus: CircuitModulus) -> bool {
    // INPUT stack
    // y^2 = x^3 + 3
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let y2 = circuit_mul(in1, in1);
    let x2 = circuit_mul(in0, in0);
    let x3 = circuit_mul(in0, x2);
    let x3_plus_3 = circuit_add(x3, in2);
    let y2_minus_x3_plus_3 = circuit_sub(y2, x3_plus_3);

    let mut circuit_inputs = (y2_minus_x3_plus_3,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(p.x); // in0
    circuit_inputs = circuit_inputs.next_2(p.y); // in1
    circuit_inputs = circuit_inputs.next_2([3, 0, 0, 0]); // in2

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let zero_check: u384 = outputs.get_output(y2_minus_x3_plus_3);
    return zero_check == u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };
}

