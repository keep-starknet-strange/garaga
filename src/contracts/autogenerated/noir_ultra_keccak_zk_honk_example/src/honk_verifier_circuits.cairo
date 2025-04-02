use core::circuit::{
    CircuitElement as CE, CircuitInput as CI, CircuitInputs, CircuitOutputsTrait, EvalCircuitTrait,
    circuit_add, circuit_inverse, circuit_mul, circuit_sub, u384,
};
use garaga::core::circuit::{AddInputResultTrait2, u288IntoCircuitInputValue};
use garaga::definitions::{G1Point, get_BN254_modulus, get_GRUMPKIN_modulus};
use garaga::ec_ops::FunctionFelt;

#[inline(always)]
pub fn run_GRUMPKIN_ZK_HONK_SUMCHECK_SIZE_5_PUB_1_circuit(
    p_public_inputs: Span<u256>,
    p_public_inputs_offset: u384,
    libra_sum: u384,
    sumcheck_univariates_flat: Span<u256>,
    sumcheck_evaluations: Span<u256>,
    libra_evaluation: u384,
    tp_sum_check_u_challenges: Span<u128>,
    tp_gate_challenges: Span<u128>,
    tp_eta_1: u384,
    tp_eta_2: u384,
    tp_eta_3: u384,
    tp_beta: u384,
    tp_gamma: u384,
    tp_base_rlc: u384,
    tp_alphas: Span<u128>,
    tp_libra_challenge: u384,
) -> (u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x1
    let in1 = CE::<CI<1>> {}; // 0x20
    let in2 = CE::<CI<2>> {}; // 0x9d80
    let in3 = CE::<CI<3>> {}; // 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593efffec51
    let in4 = CE::<CI<4>> {}; // 0x5a0
    let in5 = CE::<CI<5>> {}; // 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593effffd31
    let in6 = CE::<CI<6>> {}; // 0x240
    let in7 = CE::<CI<7>> {}; // 0x0
    let in8 = CE::<CI<8>> {}; // 0x2
    let in9 = CE::<CI<9>> {}; // 0x3
    let in10 = CE::<CI<10>> {}; // 0x4
    let in11 = CE::<CI<11>> {}; // 0x5
    let in12 = CE::<CI<12>> {}; // 0x6
    let in13 = CE::<CI<13>> {}; // 0x7
    let in14 = CE::<CI<14>> {}; // 0x8
    let in15 = CE::<
        CI<15>,
    > {}; // 0x183227397098d014dc2822db40c0ac2e9419f4243cdcb848a1f0fac9f8000000
    let in16 = CE::<CI<16>> {}; // -0x1 % p
    let in17 = CE::<CI<17>> {}; // -0x2 % p
    let in18 = CE::<CI<18>> {}; // -0x3 % p
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
    let (in150, in151, in152) = (CE::<CI<150>> {}, CE::<CI<151>> {}, CE::<CI<152>> {});
    let (in153, in154, in155) = (CE::<CI<153>> {}, CE::<CI<154>> {}, CE::<CI<155>> {});
    let (in156, in157) = (CE::<CI<156>> {}, CE::<CI<157>> {});
    let t0 = circuit_add(in1, in28);
    let t1 = circuit_mul(in129, t0);
    let t2 = circuit_add(in130, t1);
    let t3 = circuit_add(in28, in0);
    let t4 = circuit_mul(in129, t3);
    let t5 = circuit_sub(in130, t4);
    let t6 = circuit_add(t2, in27);
    let t7 = circuit_mul(in0, t6);
    let t8 = circuit_add(t5, in27);
    let t9 = circuit_mul(in0, t8);
    let t10 = circuit_inverse(t9);
    let t11 = circuit_mul(t7, t10);
    let t12 = circuit_mul(in157, in29);
    let t13 = circuit_add(in30, in31);
    let t14 = circuit_sub(t13, t12);
    let t15 = circuit_mul(t14, in131);
    let t16 = circuit_mul(in131, in131);
    let t17 = circuit_sub(in116, in7);
    let t18 = circuit_mul(in0, t17);
    let t19 = circuit_sub(in116, in7);
    let t20 = circuit_mul(in2, t19);
    let t21 = circuit_inverse(t20);
    let t22 = circuit_mul(in30, t21);
    let t23 = circuit_add(in7, t22);
    let t24 = circuit_sub(in116, in0);
    let t25 = circuit_mul(t18, t24);
    let t26 = circuit_sub(in116, in0);
    let t27 = circuit_mul(in3, t26);
    let t28 = circuit_inverse(t27);
    let t29 = circuit_mul(in31, t28);
    let t30 = circuit_add(t23, t29);
    let t31 = circuit_sub(in116, in8);
    let t32 = circuit_mul(t25, t31);
    let t33 = circuit_sub(in116, in8);
    let t34 = circuit_mul(in4, t33);
    let t35 = circuit_inverse(t34);
    let t36 = circuit_mul(in32, t35);
    let t37 = circuit_add(t30, t36);
    let t38 = circuit_sub(in116, in9);
    let t39 = circuit_mul(t32, t38);
    let t40 = circuit_sub(in116, in9);
    let t41 = circuit_mul(in5, t40);
    let t42 = circuit_inverse(t41);
    let t43 = circuit_mul(in33, t42);
    let t44 = circuit_add(t37, t43);
    let t45 = circuit_sub(in116, in10);
    let t46 = circuit_mul(t39, t45);
    let t47 = circuit_sub(in116, in10);
    let t48 = circuit_mul(in6, t47);
    let t49 = circuit_inverse(t48);
    let t50 = circuit_mul(in34, t49);
    let t51 = circuit_add(t44, t50);
    let t52 = circuit_sub(in116, in11);
    let t53 = circuit_mul(t46, t52);
    let t54 = circuit_sub(in116, in11);
    let t55 = circuit_mul(in5, t54);
    let t56 = circuit_inverse(t55);
    let t57 = circuit_mul(in35, t56);
    let t58 = circuit_add(t51, t57);
    let t59 = circuit_sub(in116, in12);
    let t60 = circuit_mul(t53, t59);
    let t61 = circuit_sub(in116, in12);
    let t62 = circuit_mul(in4, t61);
    let t63 = circuit_inverse(t62);
    let t64 = circuit_mul(in36, t63);
    let t65 = circuit_add(t58, t64);
    let t66 = circuit_sub(in116, in13);
    let t67 = circuit_mul(t60, t66);
    let t68 = circuit_sub(in116, in13);
    let t69 = circuit_mul(in3, t68);
    let t70 = circuit_inverse(t69);
    let t71 = circuit_mul(in37, t70);
    let t72 = circuit_add(t65, t71);
    let t73 = circuit_sub(in116, in14);
    let t74 = circuit_mul(t67, t73);
    let t75 = circuit_sub(in116, in14);
    let t76 = circuit_mul(in2, t75);
    let t77 = circuit_inverse(t76);
    let t78 = circuit_mul(in38, t77);
    let t79 = circuit_add(t72, t78);
    let t80 = circuit_mul(t79, t74);
    let t81 = circuit_sub(in121, in0);
    let t82 = circuit_mul(in116, t81);
    let t83 = circuit_add(in0, t82);
    let t84 = circuit_mul(in0, t83);
    let t85 = circuit_add(in39, in40);
    let t86 = circuit_sub(t85, t80);
    let t87 = circuit_mul(t86, t16);
    let t88 = circuit_add(t15, t87);
    let t89 = circuit_mul(t16, in131);
    let t90 = circuit_sub(in117, in7);
    let t91 = circuit_mul(in0, t90);
    let t92 = circuit_sub(in117, in7);
    let t93 = circuit_mul(in2, t92);
    let t94 = circuit_inverse(t93);
    let t95 = circuit_mul(in39, t94);
    let t96 = circuit_add(in7, t95);
    let t97 = circuit_sub(in117, in0);
    let t98 = circuit_mul(t91, t97);
    let t99 = circuit_sub(in117, in0);
    let t100 = circuit_mul(in3, t99);
    let t101 = circuit_inverse(t100);
    let t102 = circuit_mul(in40, t101);
    let t103 = circuit_add(t96, t102);
    let t104 = circuit_sub(in117, in8);
    let t105 = circuit_mul(t98, t104);
    let t106 = circuit_sub(in117, in8);
    let t107 = circuit_mul(in4, t106);
    let t108 = circuit_inverse(t107);
    let t109 = circuit_mul(in41, t108);
    let t110 = circuit_add(t103, t109);
    let t111 = circuit_sub(in117, in9);
    let t112 = circuit_mul(t105, t111);
    let t113 = circuit_sub(in117, in9);
    let t114 = circuit_mul(in5, t113);
    let t115 = circuit_inverse(t114);
    let t116 = circuit_mul(in42, t115);
    let t117 = circuit_add(t110, t116);
    let t118 = circuit_sub(in117, in10);
    let t119 = circuit_mul(t112, t118);
    let t120 = circuit_sub(in117, in10);
    let t121 = circuit_mul(in6, t120);
    let t122 = circuit_inverse(t121);
    let t123 = circuit_mul(in43, t122);
    let t124 = circuit_add(t117, t123);
    let t125 = circuit_sub(in117, in11);
    let t126 = circuit_mul(t119, t125);
    let t127 = circuit_sub(in117, in11);
    let t128 = circuit_mul(in5, t127);
    let t129 = circuit_inverse(t128);
    let t130 = circuit_mul(in44, t129);
    let t131 = circuit_add(t124, t130);
    let t132 = circuit_sub(in117, in12);
    let t133 = circuit_mul(t126, t132);
    let t134 = circuit_sub(in117, in12);
    let t135 = circuit_mul(in4, t134);
    let t136 = circuit_inverse(t135);
    let t137 = circuit_mul(in45, t136);
    let t138 = circuit_add(t131, t137);
    let t139 = circuit_sub(in117, in13);
    let t140 = circuit_mul(t133, t139);
    let t141 = circuit_sub(in117, in13);
    let t142 = circuit_mul(in3, t141);
    let t143 = circuit_inverse(t142);
    let t144 = circuit_mul(in46, t143);
    let t145 = circuit_add(t138, t144);
    let t146 = circuit_sub(in117, in14);
    let t147 = circuit_mul(t140, t146);
    let t148 = circuit_sub(in117, in14);
    let t149 = circuit_mul(in2, t148);
    let t150 = circuit_inverse(t149);
    let t151 = circuit_mul(in47, t150);
    let t152 = circuit_add(t145, t151);
    let t153 = circuit_mul(t152, t147);
    let t154 = circuit_sub(in122, in0);
    let t155 = circuit_mul(in117, t154);
    let t156 = circuit_add(in0, t155);
    let t157 = circuit_mul(t84, t156);
    let t158 = circuit_add(in48, in49);
    let t159 = circuit_sub(t158, t153);
    let t160 = circuit_mul(t159, t89);
    let t161 = circuit_add(t88, t160);
    let t162 = circuit_mul(t89, in131);
    let t163 = circuit_sub(in118, in7);
    let t164 = circuit_mul(in0, t163);
    let t165 = circuit_sub(in118, in7);
    let t166 = circuit_mul(in2, t165);
    let t167 = circuit_inverse(t166);
    let t168 = circuit_mul(in48, t167);
    let t169 = circuit_add(in7, t168);
    let t170 = circuit_sub(in118, in0);
    let t171 = circuit_mul(t164, t170);
    let t172 = circuit_sub(in118, in0);
    let t173 = circuit_mul(in3, t172);
    let t174 = circuit_inverse(t173);
    let t175 = circuit_mul(in49, t174);
    let t176 = circuit_add(t169, t175);
    let t177 = circuit_sub(in118, in8);
    let t178 = circuit_mul(t171, t177);
    let t179 = circuit_sub(in118, in8);
    let t180 = circuit_mul(in4, t179);
    let t181 = circuit_inverse(t180);
    let t182 = circuit_mul(in50, t181);
    let t183 = circuit_add(t176, t182);
    let t184 = circuit_sub(in118, in9);
    let t185 = circuit_mul(t178, t184);
    let t186 = circuit_sub(in118, in9);
    let t187 = circuit_mul(in5, t186);
    let t188 = circuit_inverse(t187);
    let t189 = circuit_mul(in51, t188);
    let t190 = circuit_add(t183, t189);
    let t191 = circuit_sub(in118, in10);
    let t192 = circuit_mul(t185, t191);
    let t193 = circuit_sub(in118, in10);
    let t194 = circuit_mul(in6, t193);
    let t195 = circuit_inverse(t194);
    let t196 = circuit_mul(in52, t195);
    let t197 = circuit_add(t190, t196);
    let t198 = circuit_sub(in118, in11);
    let t199 = circuit_mul(t192, t198);
    let t200 = circuit_sub(in118, in11);
    let t201 = circuit_mul(in5, t200);
    let t202 = circuit_inverse(t201);
    let t203 = circuit_mul(in53, t202);
    let t204 = circuit_add(t197, t203);
    let t205 = circuit_sub(in118, in12);
    let t206 = circuit_mul(t199, t205);
    let t207 = circuit_sub(in118, in12);
    let t208 = circuit_mul(in4, t207);
    let t209 = circuit_inverse(t208);
    let t210 = circuit_mul(in54, t209);
    let t211 = circuit_add(t204, t210);
    let t212 = circuit_sub(in118, in13);
    let t213 = circuit_mul(t206, t212);
    let t214 = circuit_sub(in118, in13);
    let t215 = circuit_mul(in3, t214);
    let t216 = circuit_inverse(t215);
    let t217 = circuit_mul(in55, t216);
    let t218 = circuit_add(t211, t217);
    let t219 = circuit_sub(in118, in14);
    let t220 = circuit_mul(t213, t219);
    let t221 = circuit_sub(in118, in14);
    let t222 = circuit_mul(in2, t221);
    let t223 = circuit_inverse(t222);
    let t224 = circuit_mul(in56, t223);
    let t225 = circuit_add(t218, t224);
    let t226 = circuit_mul(t225, t220);
    let t227 = circuit_sub(in123, in0);
    let t228 = circuit_mul(in118, t227);
    let t229 = circuit_add(in0, t228);
    let t230 = circuit_mul(t157, t229);
    let t231 = circuit_add(in57, in58);
    let t232 = circuit_sub(t231, t226);
    let t233 = circuit_mul(t232, t162);
    let t234 = circuit_add(t161, t233);
    let t235 = circuit_mul(t162, in131);
    let t236 = circuit_sub(in119, in7);
    let t237 = circuit_mul(in0, t236);
    let t238 = circuit_sub(in119, in7);
    let t239 = circuit_mul(in2, t238);
    let t240 = circuit_inverse(t239);
    let t241 = circuit_mul(in57, t240);
    let t242 = circuit_add(in7, t241);
    let t243 = circuit_sub(in119, in0);
    let t244 = circuit_mul(t237, t243);
    let t245 = circuit_sub(in119, in0);
    let t246 = circuit_mul(in3, t245);
    let t247 = circuit_inverse(t246);
    let t248 = circuit_mul(in58, t247);
    let t249 = circuit_add(t242, t248);
    let t250 = circuit_sub(in119, in8);
    let t251 = circuit_mul(t244, t250);
    let t252 = circuit_sub(in119, in8);
    let t253 = circuit_mul(in4, t252);
    let t254 = circuit_inverse(t253);
    let t255 = circuit_mul(in59, t254);
    let t256 = circuit_add(t249, t255);
    let t257 = circuit_sub(in119, in9);
    let t258 = circuit_mul(t251, t257);
    let t259 = circuit_sub(in119, in9);
    let t260 = circuit_mul(in5, t259);
    let t261 = circuit_inverse(t260);
    let t262 = circuit_mul(in60, t261);
    let t263 = circuit_add(t256, t262);
    let t264 = circuit_sub(in119, in10);
    let t265 = circuit_mul(t258, t264);
    let t266 = circuit_sub(in119, in10);
    let t267 = circuit_mul(in6, t266);
    let t268 = circuit_inverse(t267);
    let t269 = circuit_mul(in61, t268);
    let t270 = circuit_add(t263, t269);
    let t271 = circuit_sub(in119, in11);
    let t272 = circuit_mul(t265, t271);
    let t273 = circuit_sub(in119, in11);
    let t274 = circuit_mul(in5, t273);
    let t275 = circuit_inverse(t274);
    let t276 = circuit_mul(in62, t275);
    let t277 = circuit_add(t270, t276);
    let t278 = circuit_sub(in119, in12);
    let t279 = circuit_mul(t272, t278);
    let t280 = circuit_sub(in119, in12);
    let t281 = circuit_mul(in4, t280);
    let t282 = circuit_inverse(t281);
    let t283 = circuit_mul(in63, t282);
    let t284 = circuit_add(t277, t283);
    let t285 = circuit_sub(in119, in13);
    let t286 = circuit_mul(t279, t285);
    let t287 = circuit_sub(in119, in13);
    let t288 = circuit_mul(in3, t287);
    let t289 = circuit_inverse(t288);
    let t290 = circuit_mul(in64, t289);
    let t291 = circuit_add(t284, t290);
    let t292 = circuit_sub(in119, in14);
    let t293 = circuit_mul(t286, t292);
    let t294 = circuit_sub(in119, in14);
    let t295 = circuit_mul(in2, t294);
    let t296 = circuit_inverse(t295);
    let t297 = circuit_mul(in65, t296);
    let t298 = circuit_add(t291, t297);
    let t299 = circuit_mul(t298, t293);
    let t300 = circuit_sub(in124, in0);
    let t301 = circuit_mul(in119, t300);
    let t302 = circuit_add(in0, t301);
    let t303 = circuit_mul(t230, t302);
    let t304 = circuit_add(in66, in67);
    let t305 = circuit_sub(t304, t299);
    let t306 = circuit_mul(t305, t235);
    let t307 = circuit_add(t234, t306);
    let t308 = circuit_sub(in120, in7);
    let t309 = circuit_mul(in0, t308);
    let t310 = circuit_sub(in120, in7);
    let t311 = circuit_mul(in2, t310);
    let t312 = circuit_inverse(t311);
    let t313 = circuit_mul(in66, t312);
    let t314 = circuit_add(in7, t313);
    let t315 = circuit_sub(in120, in0);
    let t316 = circuit_mul(t309, t315);
    let t317 = circuit_sub(in120, in0);
    let t318 = circuit_mul(in3, t317);
    let t319 = circuit_inverse(t318);
    let t320 = circuit_mul(in67, t319);
    let t321 = circuit_add(t314, t320);
    let t322 = circuit_sub(in120, in8);
    let t323 = circuit_mul(t316, t322);
    let t324 = circuit_sub(in120, in8);
    let t325 = circuit_mul(in4, t324);
    let t326 = circuit_inverse(t325);
    let t327 = circuit_mul(in68, t326);
    let t328 = circuit_add(t321, t327);
    let t329 = circuit_sub(in120, in9);
    let t330 = circuit_mul(t323, t329);
    let t331 = circuit_sub(in120, in9);
    let t332 = circuit_mul(in5, t331);
    let t333 = circuit_inverse(t332);
    let t334 = circuit_mul(in69, t333);
    let t335 = circuit_add(t328, t334);
    let t336 = circuit_sub(in120, in10);
    let t337 = circuit_mul(t330, t336);
    let t338 = circuit_sub(in120, in10);
    let t339 = circuit_mul(in6, t338);
    let t340 = circuit_inverse(t339);
    let t341 = circuit_mul(in70, t340);
    let t342 = circuit_add(t335, t341);
    let t343 = circuit_sub(in120, in11);
    let t344 = circuit_mul(t337, t343);
    let t345 = circuit_sub(in120, in11);
    let t346 = circuit_mul(in5, t345);
    let t347 = circuit_inverse(t346);
    let t348 = circuit_mul(in71, t347);
    let t349 = circuit_add(t342, t348);
    let t350 = circuit_sub(in120, in12);
    let t351 = circuit_mul(t344, t350);
    let t352 = circuit_sub(in120, in12);
    let t353 = circuit_mul(in4, t352);
    let t354 = circuit_inverse(t353);
    let t355 = circuit_mul(in72, t354);
    let t356 = circuit_add(t349, t355);
    let t357 = circuit_sub(in120, in13);
    let t358 = circuit_mul(t351, t357);
    let t359 = circuit_sub(in120, in13);
    let t360 = circuit_mul(in3, t359);
    let t361 = circuit_inverse(t360);
    let t362 = circuit_mul(in73, t361);
    let t363 = circuit_add(t356, t362);
    let t364 = circuit_sub(in120, in14);
    let t365 = circuit_mul(t358, t364);
    let t366 = circuit_sub(in120, in14);
    let t367 = circuit_mul(in2, t366);
    let t368 = circuit_inverse(t367);
    let t369 = circuit_mul(in74, t368);
    let t370 = circuit_add(t363, t369);
    let t371 = circuit_mul(t370, t365);
    let t372 = circuit_sub(in125, in0);
    let t373 = circuit_mul(in120, t372);
    let t374 = circuit_add(in0, t373);
    let t375 = circuit_mul(t303, t374);
    let t376 = circuit_sub(in82, in9);
    let t377 = circuit_mul(t376, in75);
    let t378 = circuit_mul(t377, in103);
    let t379 = circuit_mul(t378, in102);
    let t380 = circuit_mul(t379, in15);
    let t381 = circuit_mul(in77, in102);
    let t382 = circuit_mul(in78, in103);
    let t383 = circuit_mul(in79, in104);
    let t384 = circuit_mul(in80, in105);
    let t385 = circuit_add(t380, t381);
    let t386 = circuit_add(t385, t382);
    let t387 = circuit_add(t386, t383);
    let t388 = circuit_add(t387, t384);
    let t389 = circuit_add(t388, in76);
    let t390 = circuit_sub(in82, in0);
    let t391 = circuit_mul(t390, in113);
    let t392 = circuit_add(t389, t391);
    let t393 = circuit_mul(t392, in82);
    let t394 = circuit_mul(t393, t375);
    let t395 = circuit_add(in102, in105);
    let t396 = circuit_add(t395, in75);
    let t397 = circuit_sub(t396, in110);
    let t398 = circuit_sub(in82, in8);
    let t399 = circuit_mul(t397, t398);
    let t400 = circuit_sub(in82, in0);
    let t401 = circuit_mul(t399, t400);
    let t402 = circuit_mul(t401, in82);
    let t403 = circuit_mul(t402, t375);
    let t404 = circuit_mul(in92, in129);
    let t405 = circuit_add(in102, t404);
    let t406 = circuit_add(t405, in130);
    let t407 = circuit_mul(in93, in129);
    let t408 = circuit_add(in103, t407);
    let t409 = circuit_add(t408, in130);
    let t410 = circuit_mul(t406, t409);
    let t411 = circuit_mul(in94, in129);
    let t412 = circuit_add(in104, t411);
    let t413 = circuit_add(t412, in130);
    let t414 = circuit_mul(t410, t413);
    let t415 = circuit_mul(in95, in129);
    let t416 = circuit_add(in105, t415);
    let t417 = circuit_add(t416, in130);
    let t418 = circuit_mul(t414, t417);
    let t419 = circuit_mul(in88, in129);
    let t420 = circuit_add(in102, t419);
    let t421 = circuit_add(t420, in130);
    let t422 = circuit_mul(in89, in129);
    let t423 = circuit_add(in103, t422);
    let t424 = circuit_add(t423, in130);
    let t425 = circuit_mul(t421, t424);
    let t426 = circuit_mul(in90, in129);
    let t427 = circuit_add(in104, t426);
    let t428 = circuit_add(t427, in130);
    let t429 = circuit_mul(t425, t428);
    let t430 = circuit_mul(in91, in129);
    let t431 = circuit_add(in105, t430);
    let t432 = circuit_add(t431, in130);
    let t433 = circuit_mul(t429, t432);
    let t434 = circuit_add(in106, in100);
    let t435 = circuit_mul(t418, t434);
    let t436 = circuit_mul(in101, t11);
    let t437 = circuit_add(in114, t436);
    let t438 = circuit_mul(t433, t437);
    let t439 = circuit_sub(t435, t438);
    let t440 = circuit_mul(t439, t375);
    let t441 = circuit_mul(in101, in114);
    let t442 = circuit_mul(t441, t375);
    let t443 = circuit_mul(in97, in126);
    let t444 = circuit_mul(in98, in127);
    let t445 = circuit_mul(in99, in128);
    let t446 = circuit_add(in96, in130);
    let t447 = circuit_add(t446, t443);
    let t448 = circuit_add(t447, t444);
    let t449 = circuit_add(t448, t445);
    let t450 = circuit_mul(in78, in110);
    let t451 = circuit_add(in102, in130);
    let t452 = circuit_add(t451, t450);
    let t453 = circuit_mul(in75, in111);
    let t454 = circuit_add(in103, t453);
    let t455 = circuit_mul(in76, in112);
    let t456 = circuit_add(in104, t455);
    let t457 = circuit_mul(t454, in126);
    let t458 = circuit_mul(t456, in127);
    let t459 = circuit_mul(in79, in128);
    let t460 = circuit_add(t452, t457);
    let t461 = circuit_add(t460, t458);
    let t462 = circuit_add(t461, t459);
    let t463 = circuit_mul(in107, t449);
    let t464 = circuit_mul(in107, t462);
    let t465 = circuit_add(in109, in81);
    let t466 = circuit_mul(in109, in81);
    let t467 = circuit_sub(t465, t466);
    let t468 = circuit_mul(t462, t449);
    let t469 = circuit_mul(t468, in107);
    let t470 = circuit_sub(t469, t467);
    let t471 = circuit_mul(t470, t375);
    let t472 = circuit_mul(in81, t463);
    let t473 = circuit_mul(in108, t464);
    let t474 = circuit_sub(t472, t473);
    let t475 = circuit_sub(in103, in102);
    let t476 = circuit_sub(in104, in103);
    let t477 = circuit_sub(in105, in104);
    let t478 = circuit_sub(in110, in105);
    let t479 = circuit_add(t475, in16);
    let t480 = circuit_add(t475, in17);
    let t481 = circuit_add(t475, in18);
    let t482 = circuit_mul(t475, t479);
    let t483 = circuit_mul(t482, t480);
    let t484 = circuit_mul(t483, t481);
    let t485 = circuit_mul(t484, in83);
    let t486 = circuit_mul(t485, t375);
    let t487 = circuit_add(t476, in16);
    let t488 = circuit_add(t476, in17);
    let t489 = circuit_add(t476, in18);
    let t490 = circuit_mul(t476, t487);
    let t491 = circuit_mul(t490, t488);
    let t492 = circuit_mul(t491, t489);
    let t493 = circuit_mul(t492, in83);
    let t494 = circuit_mul(t493, t375);
    let t495 = circuit_add(t477, in16);
    let t496 = circuit_add(t477, in17);
    let t497 = circuit_add(t477, in18);
    let t498 = circuit_mul(t477, t495);
    let t499 = circuit_mul(t498, t496);
    let t500 = circuit_mul(t499, t497);
    let t501 = circuit_mul(t500, in83);
    let t502 = circuit_mul(t501, t375);
    let t503 = circuit_add(t478, in16);
    let t504 = circuit_add(t478, in17);
    let t505 = circuit_add(t478, in18);
    let t506 = circuit_mul(t478, t503);
    let t507 = circuit_mul(t506, t504);
    let t508 = circuit_mul(t507, t505);
    let t509 = circuit_mul(t508, in83);
    let t510 = circuit_mul(t509, t375);
    let t511 = circuit_sub(in110, in103);
    let t512 = circuit_mul(in104, in104);
    let t513 = circuit_mul(in113, in113);
    let t514 = circuit_mul(in104, in113);
    let t515 = circuit_mul(t514, in77);
    let t516 = circuit_add(in111, in110);
    let t517 = circuit_add(t516, in103);
    let t518 = circuit_mul(t517, t511);
    let t519 = circuit_mul(t518, t511);
    let t520 = circuit_sub(t519, t513);
    let t521 = circuit_sub(t520, t512);
    let t522 = circuit_add(t521, t515);
    let t523 = circuit_add(t522, t515);
    let t524 = circuit_sub(in0, in75);
    let t525 = circuit_mul(t523, t375);
    let t526 = circuit_mul(t525, in84);
    let t527 = circuit_mul(t526, t524);
    let t528 = circuit_add(in104, in112);
    let t529 = circuit_mul(in113, in77);
    let t530 = circuit_sub(t529, in104);
    let t531 = circuit_mul(t528, t511);
    let t532 = circuit_sub(in111, in103);
    let t533 = circuit_mul(t532, t530);
    let t534 = circuit_add(t531, t533);
    let t535 = circuit_mul(t534, t375);
    let t536 = circuit_mul(t535, in84);
    let t537 = circuit_mul(t536, t524);
    let t538 = circuit_add(t512, in19);
    let t539 = circuit_mul(t538, in103);
    let t540 = circuit_add(t512, t512);
    let t541 = circuit_add(t540, t540);
    let t542 = circuit_mul(t539, in20);
    let t543 = circuit_add(in111, in103);
    let t544 = circuit_add(t543, in103);
    let t545 = circuit_mul(t544, t541);
    let t546 = circuit_sub(t545, t542);
    let t547 = circuit_mul(t546, t375);
    let t548 = circuit_mul(t547, in84);
    let t549 = circuit_mul(t548, in75);
    let t550 = circuit_add(t527, t549);
    let t551 = circuit_add(in103, in103);
    let t552 = circuit_add(t551, in103);
    let t553 = circuit_mul(t552, in103);
    let t554 = circuit_sub(in103, in111);
    let t555 = circuit_mul(t553, t554);
    let t556 = circuit_add(in104, in104);
    let t557 = circuit_add(in104, in112);
    let t558 = circuit_mul(t556, t557);
    let t559 = circuit_sub(t555, t558);
    let t560 = circuit_mul(t559, t375);
    let t561 = circuit_mul(t560, in84);
    let t562 = circuit_mul(t561, in75);
    let t563 = circuit_add(t537, t562);
    let t564 = circuit_mul(in102, in111);
    let t565 = circuit_mul(in110, in103);
    let t566 = circuit_add(t564, t565);
    let t567 = circuit_mul(in102, in105);
    let t568 = circuit_mul(in103, in104);
    let t569 = circuit_add(t567, t568);
    let t570 = circuit_sub(t569, in112);
    let t571 = circuit_mul(t570, in21);
    let t572 = circuit_sub(t571, in113);
    let t573 = circuit_add(t572, t566);
    let t574 = circuit_mul(t573, in80);
    let t575 = circuit_mul(t566, in21);
    let t576 = circuit_mul(in110, in111);
    let t577 = circuit_add(t575, t576);
    let t578 = circuit_add(in104, in105);
    let t579 = circuit_sub(t577, t578);
    let t580 = circuit_mul(t579, in79);
    let t581 = circuit_add(t577, in105);
    let t582 = circuit_add(in112, in113);
    let t583 = circuit_sub(t581, t582);
    let t584 = circuit_mul(t583, in75);
    let t585 = circuit_add(t580, t574);
    let t586 = circuit_add(t585, t584);
    let t587 = circuit_mul(t586, in78);
    let t588 = circuit_mul(in111, in22);
    let t589 = circuit_add(t588, in110);
    let t590 = circuit_mul(t589, in22);
    let t591 = circuit_add(t590, in104);
    let t592 = circuit_mul(t591, in22);
    let t593 = circuit_add(t592, in103);
    let t594 = circuit_mul(t593, in22);
    let t595 = circuit_add(t594, in102);
    let t596 = circuit_sub(t595, in105);
    let t597 = circuit_mul(t596, in80);
    let t598 = circuit_mul(in112, in22);
    let t599 = circuit_add(t598, in111);
    let t600 = circuit_mul(t599, in22);
    let t601 = circuit_add(t600, in110);
    let t602 = circuit_mul(t601, in22);
    let t603 = circuit_add(t602, in105);
    let t604 = circuit_mul(t603, in22);
    let t605 = circuit_add(t604, in104);
    let t606 = circuit_sub(t605, in113);
    let t607 = circuit_mul(t606, in75);
    let t608 = circuit_add(t597, t607);
    let t609 = circuit_mul(t608, in79);
    let t610 = circuit_mul(in104, in128);
    let t611 = circuit_mul(in103, in127);
    let t612 = circuit_mul(in102, in126);
    let t613 = circuit_add(t610, t611);
    let t614 = circuit_add(t613, t612);
    let t615 = circuit_add(t614, in76);
    let t616 = circuit_sub(t615, in105);
    let t617 = circuit_sub(in110, in102);
    let t618 = circuit_sub(in113, in105);
    let t619 = circuit_mul(t617, t617);
    let t620 = circuit_sub(t619, t617);
    let t621 = circuit_sub(in7, t617);
    let t622 = circuit_add(t621, in0);
    let t623 = circuit_mul(t622, t618);
    let t624 = circuit_mul(in77, in78);
    let t625 = circuit_mul(t624, in85);
    let t626 = circuit_mul(t625, t375);
    let t627 = circuit_mul(t623, t626);
    let t628 = circuit_mul(t620, t626);
    let t629 = circuit_mul(t616, t624);
    let t630 = circuit_sub(in105, t615);
    let t631 = circuit_mul(t630, t630);
    let t632 = circuit_sub(t631, t630);
    let t633 = circuit_mul(in112, in128);
    let t634 = circuit_mul(in111, in127);
    let t635 = circuit_mul(in110, in126);
    let t636 = circuit_add(t633, t634);
    let t637 = circuit_add(t636, t635);
    let t638 = circuit_sub(in113, t637);
    let t639 = circuit_sub(in112, in104);
    let t640 = circuit_sub(in7, t617);
    let t641 = circuit_add(t640, in0);
    let t642 = circuit_sub(in7, t638);
    let t643 = circuit_add(t642, in0);
    let t644 = circuit_mul(t639, t643);
    let t645 = circuit_mul(t641, t644);
    let t646 = circuit_mul(t638, t638);
    let t647 = circuit_sub(t646, t638);
    let t648 = circuit_mul(in82, in85);
    let t649 = circuit_mul(t648, t375);
    let t650 = circuit_mul(t645, t649);
    let t651 = circuit_mul(t620, t649);
    let t652 = circuit_mul(t647, t649);
    let t653 = circuit_mul(t632, in82);
    let t654 = circuit_sub(in111, in103);
    let t655 = circuit_sub(in7, t617);
    let t656 = circuit_add(t655, in0);
    let t657 = circuit_mul(t656, t654);
    let t658 = circuit_sub(t657, in104);
    let t659 = circuit_mul(t658, in80);
    let t660 = circuit_mul(t659, in77);
    let t661 = circuit_add(t629, t660);
    let t662 = circuit_mul(t616, in75);
    let t663 = circuit_mul(t662, in77);
    let t664 = circuit_add(t661, t663);
    let t665 = circuit_add(t664, t653);
    let t666 = circuit_add(t665, t587);
    let t667 = circuit_add(t666, t609);
    let t668 = circuit_mul(t667, in85);
    let t669 = circuit_mul(t668, t375);
    let t670 = circuit_add(in102, in77);
    let t671 = circuit_add(in103, in78);
    let t672 = circuit_add(in104, in79);
    let t673 = circuit_add(in105, in80);
    let t674 = circuit_mul(t670, t670);
    let t675 = circuit_mul(t674, t674);
    let t676 = circuit_mul(t675, t670);
    let t677 = circuit_mul(t671, t671);
    let t678 = circuit_mul(t677, t677);
    let t679 = circuit_mul(t678, t671);
    let t680 = circuit_mul(t672, t672);
    let t681 = circuit_mul(t680, t680);
    let t682 = circuit_mul(t681, t672);
    let t683 = circuit_mul(t673, t673);
    let t684 = circuit_mul(t683, t683);
    let t685 = circuit_mul(t684, t673);
    let t686 = circuit_add(t676, t679);
    let t687 = circuit_add(t682, t685);
    let t688 = circuit_add(t679, t679);
    let t689 = circuit_add(t688, t687);
    let t690 = circuit_add(t685, t685);
    let t691 = circuit_add(t690, t686);
    let t692 = circuit_add(t687, t687);
    let t693 = circuit_add(t692, t692);
    let t694 = circuit_add(t693, t691);
    let t695 = circuit_add(t686, t686);
    let t696 = circuit_add(t695, t695);
    let t697 = circuit_add(t696, t689);
    let t698 = circuit_add(t691, t697);
    let t699 = circuit_add(t689, t694);
    let t700 = circuit_mul(in86, t375);
    let t701 = circuit_sub(t698, in110);
    let t702 = circuit_mul(t700, t701);
    let t703 = circuit_sub(t697, in111);
    let t704 = circuit_mul(t700, t703);
    let t705 = circuit_sub(t699, in112);
    let t706 = circuit_mul(t700, t705);
    let t707 = circuit_sub(t694, in113);
    let t708 = circuit_mul(t700, t707);
    let t709 = circuit_add(in102, in77);
    let t710 = circuit_mul(t709, t709);
    let t711 = circuit_mul(t710, t710);
    let t712 = circuit_mul(t711, t709);
    let t713 = circuit_add(t712, in103);
    let t714 = circuit_add(t713, in104);
    let t715 = circuit_add(t714, in105);
    let t716 = circuit_mul(in87, t375);
    let t717 = circuit_mul(t712, in23);
    let t718 = circuit_add(t717, t715);
    let t719 = circuit_sub(t718, in110);
    let t720 = circuit_mul(t716, t719);
    let t721 = circuit_mul(in103, in24);
    let t722 = circuit_add(t721, t715);
    let t723 = circuit_sub(t722, in111);
    let t724 = circuit_mul(t716, t723);
    let t725 = circuit_mul(in104, in25);
    let t726 = circuit_add(t725, t715);
    let t727 = circuit_sub(t726, in112);
    let t728 = circuit_mul(t716, t727);
    let t729 = circuit_mul(in105, in26);
    let t730 = circuit_add(t729, t715);
    let t731 = circuit_sub(t730, in113);
    let t732 = circuit_mul(t716, t731);
    let t733 = circuit_mul(t403, in132);
    let t734 = circuit_add(t394, t733);
    let t735 = circuit_mul(t440, in133);
    let t736 = circuit_add(t734, t735);
    let t737 = circuit_mul(t442, in134);
    let t738 = circuit_add(t736, t737);
    let t739 = circuit_mul(t471, in135);
    let t740 = circuit_add(t738, t739);
    let t741 = circuit_mul(t474, in136);
    let t742 = circuit_add(t740, t741);
    let t743 = circuit_mul(t486, in137);
    let t744 = circuit_add(t742, t743);
    let t745 = circuit_mul(t494, in138);
    let t746 = circuit_add(t744, t745);
    let t747 = circuit_mul(t502, in139);
    let t748 = circuit_add(t746, t747);
    let t749 = circuit_mul(t510, in140);
    let t750 = circuit_add(t748, t749);
    let t751 = circuit_mul(t550, in141);
    let t752 = circuit_add(t750, t751);
    let t753 = circuit_mul(t563, in142);
    let t754 = circuit_add(t752, t753);
    let t755 = circuit_mul(t669, in143);
    let t756 = circuit_add(t754, t755);
    let t757 = circuit_mul(t627, in144);
    let t758 = circuit_add(t756, t757);
    let t759 = circuit_mul(t628, in145);
    let t760 = circuit_add(t758, t759);
    let t761 = circuit_mul(t650, in146);
    let t762 = circuit_add(t760, t761);
    let t763 = circuit_mul(t651, in147);
    let t764 = circuit_add(t762, t763);
    let t765 = circuit_mul(t652, in148);
    let t766 = circuit_add(t764, t765);
    let t767 = circuit_mul(t702, in149);
    let t768 = circuit_add(t766, t767);
    let t769 = circuit_mul(t704, in150);
    let t770 = circuit_add(t768, t769);
    let t771 = circuit_mul(t706, in151);
    let t772 = circuit_add(t770, t771);
    let t773 = circuit_mul(t708, in152);
    let t774 = circuit_add(t772, t773);
    let t775 = circuit_mul(t720, in153);
    let t776 = circuit_add(t774, t775);
    let t777 = circuit_mul(t724, in154);
    let t778 = circuit_add(t776, t777);
    let t779 = circuit_mul(t728, in155);
    let t780 = circuit_add(t778, t779);
    let t781 = circuit_mul(t732, in156);
    let t782 = circuit_add(t780, t781);
    let t783 = circuit_mul(in0, in118);
    let t784 = circuit_mul(t783, in119);
    let t785 = circuit_mul(t784, in120);
    let t786 = circuit_sub(in0, t785);
    let t787 = circuit_mul(t782, t786);
    let t788 = circuit_mul(in115, in157);
    let t789 = circuit_add(t787, t788);
    let t790 = circuit_sub(t789, t371);

    let modulus = get_GRUMPKIN_modulus(); // GRUMPKIN prime field modulus

    let mut circuit_inputs = (t307, t790).new_inputs();
    // Prefill constants:

    circuit_inputs = circuit_inputs
        .next_span(ZK_HONK_SUMCHECK_SIZE_5_PUB_1_GRUMPKIN_CONSTANTS.span()); // in0 - in26

    // Fill inputs:

    for val in p_public_inputs {
        circuit_inputs = circuit_inputs.next_u256(*val);
    } // in27 - in27

    circuit_inputs = circuit_inputs.next_2(p_public_inputs_offset); // in28
    circuit_inputs = circuit_inputs.next_2(libra_sum); // in29

    for val in sumcheck_univariates_flat {
        circuit_inputs = circuit_inputs.next_u256(*val);
    } // in30 - in74

    for val in sumcheck_evaluations {
        circuit_inputs = circuit_inputs.next_u256(*val);
    } // in75 - in114

    circuit_inputs = circuit_inputs.next_2(libra_evaluation); // in115

    for val in tp_sum_check_u_challenges {
        circuit_inputs = circuit_inputs.next_u128(*val);
    } // in116 - in120

    for val in tp_gate_challenges {
        circuit_inputs = circuit_inputs.next_u128(*val);
    } // in121 - in125

    circuit_inputs = circuit_inputs.next_2(tp_eta_1); // in126
    circuit_inputs = circuit_inputs.next_2(tp_eta_2); // in127
    circuit_inputs = circuit_inputs.next_2(tp_eta_3); // in128
    circuit_inputs = circuit_inputs.next_2(tp_beta); // in129
    circuit_inputs = circuit_inputs.next_2(tp_gamma); // in130
    circuit_inputs = circuit_inputs.next_2(tp_base_rlc); // in131

    for val in tp_alphas {
        circuit_inputs = circuit_inputs.next_u128(*val);
    } // in132 - in156

    circuit_inputs = circuit_inputs.next_2(tp_libra_challenge); // in157

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let check_rlc: u384 = outputs.get_output(t307);
    let check: u384 = outputs.get_output(t790);
    return (check_rlc, check);
}
const ZK_HONK_SUMCHECK_SIZE_5_PUB_1_GRUMPKIN_CONSTANTS: [u384; 27] = [
    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x20, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x9d80, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 {
        limb0: 0x79b9709143e1f593efffec51,
        limb1: 0xb85045b68181585d2833e848,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    u384 { limb0: 0x5a0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 {
        limb0: 0x79b9709143e1f593effffd31,
        limb1: 0xb85045b68181585d2833e848,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    u384 { limb0: 0x240, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x2, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x3, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x4, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x5, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x6, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x7, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x8, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
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
    u384 {
        limb0: 0x79b9709143e1f593efffffff,
        limb1: 0xb85045b68181585d2833e848,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    u384 {
        limb0: 0x79b9709143e1f593effffffe,
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
pub fn run_GRUMPKIN_ZKHONK_PREP_MSM_SCALARS_SIZE_5_circuit(
    p_sumcheck_evaluations: Span<u256>,
    p_gemini_masking_eval: u384,
    p_gemini_a_evaluations: Span<u256>,
    p_libra_poly_evals: Span<u256>,
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
    u384,
    u384,
    u384,
    u384,
) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0
    let in1 = CE::<CI<1>> {}; // 0x1
    let in2 = CE::<CI<2>> {}; // 0x7b0c561a6148404f086204a9f36ffb0617942546750f230c893619174a57a76

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
    let (in60, in61) = (CE::<CI<60>> {}, CE::<CI<61>> {});
    let t0 = circuit_mul(in53, in53);
    let t1 = circuit_mul(t0, t0);
    let t2 = circuit_mul(t1, t1);
    let t3 = circuit_mul(t2, t2);
    let t4 = circuit_sub(in55, in53);
    let t5 = circuit_inverse(t4);
    let t6 = circuit_add(in55, in53);
    let t7 = circuit_inverse(t6);
    let t8 = circuit_mul(in56, t7);
    let t9 = circuit_add(t5, t8);
    let t10 = circuit_sub(in0, t9);
    let t11 = circuit_inverse(in53);
    let t12 = circuit_mul(in56, t7);
    let t13 = circuit_sub(t5, t12);
    let t14 = circuit_mul(t11, t13);
    let t15 = circuit_sub(in0, t14);
    let t16 = circuit_mul(t10, in54);
    let t17 = circuit_mul(in3, in54);
    let t18 = circuit_add(in43, t17);
    let t19 = circuit_mul(in54, in54);
    let t20 = circuit_mul(t10, t19);
    let t21 = circuit_mul(in4, t19);
    let t22 = circuit_add(t18, t21);
    let t23 = circuit_mul(t19, in54);
    let t24 = circuit_mul(t10, t23);
    let t25 = circuit_mul(in5, t23);
    let t26 = circuit_add(t22, t25);
    let t27 = circuit_mul(t23, in54);
    let t28 = circuit_mul(t10, t27);
    let t29 = circuit_mul(in6, t27);
    let t30 = circuit_add(t26, t29);
    let t31 = circuit_mul(t27, in54);
    let t32 = circuit_mul(t10, t31);
    let t33 = circuit_mul(in7, t31);
    let t34 = circuit_add(t30, t33);
    let t35 = circuit_mul(t31, in54);
    let t36 = circuit_mul(t10, t35);
    let t37 = circuit_mul(in8, t35);
    let t38 = circuit_add(t34, t37);
    let t39 = circuit_mul(t35, in54);
    let t40 = circuit_mul(t10, t39);
    let t41 = circuit_mul(in9, t39);
    let t42 = circuit_add(t38, t41);
    let t43 = circuit_mul(t39, in54);
    let t44 = circuit_mul(t10, t43);
    let t45 = circuit_mul(in10, t43);
    let t46 = circuit_add(t42, t45);
    let t47 = circuit_mul(t43, in54);
    let t48 = circuit_mul(t10, t47);
    let t49 = circuit_mul(in11, t47);
    let t50 = circuit_add(t46, t49);
    let t51 = circuit_mul(t47, in54);
    let t52 = circuit_mul(t10, t51);
    let t53 = circuit_mul(in12, t51);
    let t54 = circuit_add(t50, t53);
    let t55 = circuit_mul(t51, in54);
    let t56 = circuit_mul(t10, t55);
    let t57 = circuit_mul(in13, t55);
    let t58 = circuit_add(t54, t57);
    let t59 = circuit_mul(t55, in54);
    let t60 = circuit_mul(t10, t59);
    let t61 = circuit_mul(in14, t59);
    let t62 = circuit_add(t58, t61);
    let t63 = circuit_mul(t59, in54);
    let t64 = circuit_mul(t10, t63);
    let t65 = circuit_mul(in15, t63);
    let t66 = circuit_add(t62, t65);
    let t67 = circuit_mul(t63, in54);
    let t68 = circuit_mul(t10, t67);
    let t69 = circuit_mul(in16, t67);
    let t70 = circuit_add(t66, t69);
    let t71 = circuit_mul(t67, in54);
    let t72 = circuit_mul(t10, t71);
    let t73 = circuit_mul(in17, t71);
    let t74 = circuit_add(t70, t73);
    let t75 = circuit_mul(t71, in54);
    let t76 = circuit_mul(t10, t75);
    let t77 = circuit_mul(in18, t75);
    let t78 = circuit_add(t74, t77);
    let t79 = circuit_mul(t75, in54);
    let t80 = circuit_mul(t10, t79);
    let t81 = circuit_mul(in19, t79);
    let t82 = circuit_add(t78, t81);
    let t83 = circuit_mul(t79, in54);
    let t84 = circuit_mul(t10, t83);
    let t85 = circuit_mul(in20, t83);
    let t86 = circuit_add(t82, t85);
    let t87 = circuit_mul(t83, in54);
    let t88 = circuit_mul(t10, t87);
    let t89 = circuit_mul(in21, t87);
    let t90 = circuit_add(t86, t89);
    let t91 = circuit_mul(t87, in54);
    let t92 = circuit_mul(t10, t91);
    let t93 = circuit_mul(in22, t91);
    let t94 = circuit_add(t90, t93);
    let t95 = circuit_mul(t91, in54);
    let t96 = circuit_mul(t10, t95);
    let t97 = circuit_mul(in23, t95);
    let t98 = circuit_add(t94, t97);
    let t99 = circuit_mul(t95, in54);
    let t100 = circuit_mul(t10, t99);
    let t101 = circuit_mul(in24, t99);
    let t102 = circuit_add(t98, t101);
    let t103 = circuit_mul(t99, in54);
    let t104 = circuit_mul(t10, t103);
    let t105 = circuit_mul(in25, t103);
    let t106 = circuit_add(t102, t105);
    let t107 = circuit_mul(t103, in54);
    let t108 = circuit_mul(t10, t107);
    let t109 = circuit_mul(in26, t107);
    let t110 = circuit_add(t106, t109);
    let t111 = circuit_mul(t107, in54);
    let t112 = circuit_mul(t10, t111);
    let t113 = circuit_mul(in27, t111);
    let t114 = circuit_add(t110, t113);
    let t115 = circuit_mul(t111, in54);
    let t116 = circuit_mul(t10, t115);
    let t117 = circuit_mul(in28, t115);
    let t118 = circuit_add(t114, t117);
    let t119 = circuit_mul(t115, in54);
    let t120 = circuit_mul(t10, t119);
    let t121 = circuit_mul(in29, t119);
    let t122 = circuit_add(t118, t121);
    let t123 = circuit_mul(t119, in54);
    let t124 = circuit_mul(t10, t123);
    let t125 = circuit_mul(in30, t123);
    let t126 = circuit_add(t122, t125);
    let t127 = circuit_mul(t123, in54);
    let t128 = circuit_mul(t10, t127);
    let t129 = circuit_mul(in31, t127);
    let t130 = circuit_add(t126, t129);
    let t131 = circuit_mul(t127, in54);
    let t132 = circuit_mul(t10, t131);
    let t133 = circuit_mul(in32, t131);
    let t134 = circuit_add(t130, t133);
    let t135 = circuit_mul(t131, in54);
    let t136 = circuit_mul(t10, t135);
    let t137 = circuit_mul(in33, t135);
    let t138 = circuit_add(t134, t137);
    let t139 = circuit_mul(t135, in54);
    let t140 = circuit_mul(t10, t139);
    let t141 = circuit_mul(in34, t139);
    let t142 = circuit_add(t138, t141);
    let t143 = circuit_mul(t139, in54);
    let t144 = circuit_mul(t10, t143);
    let t145 = circuit_mul(in35, t143);
    let t146 = circuit_add(t142, t145);
    let t147 = circuit_mul(t143, in54);
    let t148 = circuit_mul(t10, t147);
    let t149 = circuit_mul(in36, t147);
    let t150 = circuit_add(t146, t149);
    let t151 = circuit_mul(t147, in54);
    let t152 = circuit_mul(t10, t151);
    let t153 = circuit_mul(in37, t151);
    let t154 = circuit_add(t150, t153);
    let t155 = circuit_mul(t151, in54);
    let t156 = circuit_mul(t15, t155);
    let t157 = circuit_mul(in38, t155);
    let t158 = circuit_add(t154, t157);
    let t159 = circuit_mul(t155, in54);
    let t160 = circuit_mul(t15, t159);
    let t161 = circuit_mul(in39, t159);
    let t162 = circuit_add(t158, t161);
    let t163 = circuit_mul(t159, in54);
    let t164 = circuit_mul(t15, t163);
    let t165 = circuit_mul(in40, t163);
    let t166 = circuit_add(t162, t165);
    let t167 = circuit_mul(t163, in54);
    let t168 = circuit_mul(t15, t167);
    let t169 = circuit_mul(in41, t167);
    let t170 = circuit_add(t166, t169);
    let t171 = circuit_mul(t167, in54);
    let t172 = circuit_mul(t15, t171);
    let t173 = circuit_mul(in42, t171);
    let t174 = circuit_add(t170, t173);
    let t175 = circuit_sub(in1, in61);
    let t176 = circuit_mul(t3, t175);
    let t177 = circuit_mul(t3, t174);
    let t178 = circuit_add(t177, t177);
    let t179 = circuit_sub(t176, in61);
    let t180 = circuit_mul(in48, t179);
    let t181 = circuit_sub(t178, t180);
    let t182 = circuit_add(t176, in61);
    let t183 = circuit_inverse(t182);
    let t184 = circuit_mul(t181, t183);
    let t185 = circuit_sub(in1, in60);
    let t186 = circuit_mul(t2, t185);
    let t187 = circuit_mul(t2, t184);
    let t188 = circuit_add(t187, t187);
    let t189 = circuit_sub(t186, in60);
    let t190 = circuit_mul(in47, t189);
    let t191 = circuit_sub(t188, t190);
    let t192 = circuit_add(t186, in60);
    let t193 = circuit_inverse(t192);
    let t194 = circuit_mul(t191, t193);
    let t195 = circuit_sub(in1, in59);
    let t196 = circuit_mul(t1, t195);
    let t197 = circuit_mul(t1, t194);
    let t198 = circuit_add(t197, t197);
    let t199 = circuit_sub(t196, in59);
    let t200 = circuit_mul(in46, t199);
    let t201 = circuit_sub(t198, t200);
    let t202 = circuit_add(t196, in59);
    let t203 = circuit_inverse(t202);
    let t204 = circuit_mul(t201, t203);
    let t205 = circuit_sub(in1, in58);
    let t206 = circuit_mul(t0, t205);
    let t207 = circuit_mul(t0, t204);
    let t208 = circuit_add(t207, t207);
    let t209 = circuit_sub(t206, in58);
    let t210 = circuit_mul(in45, t209);
    let t211 = circuit_sub(t208, t210);
    let t212 = circuit_add(t206, in58);
    let t213 = circuit_inverse(t212);
    let t214 = circuit_mul(t211, t213);
    let t215 = circuit_sub(in1, in57);
    let t216 = circuit_mul(in53, t215);
    let t217 = circuit_mul(in53, t214);
    let t218 = circuit_add(t217, t217);
    let t219 = circuit_sub(t216, in57);
    let t220 = circuit_mul(in44, t219);
    let t221 = circuit_sub(t218, t220);
    let t222 = circuit_add(t216, in57);
    let t223 = circuit_inverse(t222);
    let t224 = circuit_mul(t221, t223);
    let t225 = circuit_mul(t224, t5);
    let t226 = circuit_mul(in44, in56);
    let t227 = circuit_mul(t226, t7);
    let t228 = circuit_add(t225, t227);
    let t229 = circuit_mul(in56, in56);
    let t230 = circuit_sub(in55, t0);
    let t231 = circuit_inverse(t230);
    let t232 = circuit_add(in55, t0);
    let t233 = circuit_inverse(t232);
    let t234 = circuit_mul(t229, t231);
    let t235 = circuit_mul(in56, t233);
    let t236 = circuit_mul(t229, t235);
    let t237 = circuit_add(t236, t234);
    let t238 = circuit_sub(in0, t237);
    let t239 = circuit_mul(t236, in45);
    let t240 = circuit_mul(t234, t214);
    let t241 = circuit_add(t239, t240);
    let t242 = circuit_add(t228, t241);
    let t243 = circuit_mul(in56, in56);
    let t244 = circuit_mul(t229, t243);
    let t245 = circuit_sub(in55, t1);
    let t246 = circuit_inverse(t245);
    let t247 = circuit_add(in55, t1);
    let t248 = circuit_inverse(t247);
    let t249 = circuit_mul(t244, t246);
    let t250 = circuit_mul(in56, t248);
    let t251 = circuit_mul(t244, t250);
    let t252 = circuit_add(t251, t249);
    let t253 = circuit_sub(in0, t252);
    let t254 = circuit_mul(t251, in46);
    let t255 = circuit_mul(t249, t204);
    let t256 = circuit_add(t254, t255);
    let t257 = circuit_add(t242, t256);
    let t258 = circuit_mul(in56, in56);
    let t259 = circuit_mul(t244, t258);
    let t260 = circuit_sub(in55, t2);
    let t261 = circuit_inverse(t260);
    let t262 = circuit_add(in55, t2);
    let t263 = circuit_inverse(t262);
    let t264 = circuit_mul(t259, t261);
    let t265 = circuit_mul(in56, t263);
    let t266 = circuit_mul(t259, t265);
    let t267 = circuit_add(t266, t264);
    let t268 = circuit_sub(in0, t267);
    let t269 = circuit_mul(t266, in47);
    let t270 = circuit_mul(t264, t194);
    let t271 = circuit_add(t269, t270);
    let t272 = circuit_add(t257, t271);
    let t273 = circuit_mul(in56, in56);
    let t274 = circuit_mul(t259, t273);
    let t275 = circuit_sub(in55, t3);
    let t276 = circuit_inverse(t275);
    let t277 = circuit_add(in55, t3);
    let t278 = circuit_inverse(t277);
    let t279 = circuit_mul(t274, t276);
    let t280 = circuit_mul(in56, t278);
    let t281 = circuit_mul(t274, t280);
    let t282 = circuit_add(t281, t279);
    let t283 = circuit_sub(in0, t282);
    let t284 = circuit_mul(t281, in48);
    let t285 = circuit_mul(t279, t184);
    let t286 = circuit_add(t284, t285);
    let t287 = circuit_add(t272, t286);
    let t288 = circuit_mul(in56, in56);
    let t289 = circuit_mul(t274, t288);
    let t290 = circuit_mul(in56, in56);
    let t291 = circuit_mul(t289, t290);
    let t292 = circuit_mul(in56, in56);
    let t293 = circuit_mul(t291, t292);
    let t294 = circuit_mul(in56, in56);
    let t295 = circuit_mul(t293, t294);
    let t296 = circuit_mul(in56, in56);
    let t297 = circuit_mul(t295, t296);
    let t298 = circuit_mul(in56, in56);
    let t299 = circuit_mul(t297, t298);
    let t300 = circuit_mul(in56, in56);
    let t301 = circuit_mul(t299, t300);
    let t302 = circuit_mul(in56, in56);
    let t303 = circuit_mul(t301, t302);
    let t304 = circuit_mul(in56, in56);
    let t305 = circuit_mul(t303, t304);
    let t306 = circuit_mul(in56, in56);
    let t307 = circuit_mul(t305, t306);
    let t308 = circuit_mul(in56, in56);
    let t309 = circuit_mul(t307, t308);
    let t310 = circuit_mul(in56, in56);
    let t311 = circuit_mul(t309, t310);
    let t312 = circuit_mul(in56, in56);
    let t313 = circuit_mul(t311, t312);
    let t314 = circuit_mul(in56, in56);
    let t315 = circuit_mul(t313, t314);
    let t316 = circuit_mul(in56, in56);
    let t317 = circuit_mul(t315, t316);
    let t318 = circuit_mul(in56, in56);
    let t319 = circuit_mul(t317, t318);
    let t320 = circuit_mul(in56, in56);
    let t321 = circuit_mul(t319, t320);
    let t322 = circuit_mul(in56, in56);
    let t323 = circuit_mul(t321, t322);
    let t324 = circuit_mul(in56, in56);
    let t325 = circuit_mul(t323, t324);
    let t326 = circuit_mul(in56, in56);
    let t327 = circuit_mul(t325, t326);
    let t328 = circuit_mul(in56, in56);
    let t329 = circuit_mul(t327, t328);
    let t330 = circuit_mul(in56, in56);
    let t331 = circuit_mul(t329, t330);
    let t332 = circuit_mul(in56, in56);
    let t333 = circuit_mul(t331, t332);
    let t334 = circuit_mul(in56, in56);
    let t335 = circuit_mul(t333, t334);
    let t336 = circuit_sub(in55, in53);
    let t337 = circuit_inverse(t336);
    let t338 = circuit_mul(in1, t337);
    let t339 = circuit_mul(in2, in53);
    let t340 = circuit_sub(in55, t339);
    let t341 = circuit_inverse(t340);
    let t342 = circuit_mul(in1, t341);
    let t343 = circuit_mul(in56, in56);
    let t344 = circuit_mul(t335, t343);
    let t345 = circuit_mul(t338, t344);
    let t346 = circuit_sub(in0, t345);
    let t347 = circuit_mul(t344, in56);
    let t348 = circuit_mul(t345, in49);
    let t349 = circuit_add(t287, t348);
    let t350 = circuit_mul(t342, t347);
    let t351 = circuit_sub(in0, t350);
    let t352 = circuit_mul(t347, in56);
    let t353 = circuit_mul(t350, in50);
    let t354 = circuit_add(t349, t353);
    let t355 = circuit_mul(t338, t352);
    let t356 = circuit_sub(in0, t355);
    let t357 = circuit_mul(t352, in56);
    let t358 = circuit_mul(t355, in51);
    let t359 = circuit_add(t354, t358);
    let t360 = circuit_mul(t338, t357);
    let t361 = circuit_sub(in0, t360);
    let t362 = circuit_mul(t360, in52);
    let t363 = circuit_add(t359, t362);
    let t364 = circuit_add(t351, t356);
    let t365 = circuit_add(t124, t156);
    let t366 = circuit_add(t128, t160);
    let t367 = circuit_add(t132, t164);
    let t368 = circuit_add(t136, t168);
    let t369 = circuit_add(t140, t172);

    let modulus = get_GRUMPKIN_modulus(); // GRUMPKIN prime field modulus

    let mut circuit_inputs = (
        t10,
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
        t365,
        t366,
        t367,
        t368,
        t369,
        t144,
        t148,
        t152,
        t238,
        t253,
        t268,
        t283,
        t346,
        t364,
        t361,
        t363,
    )
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs.next_2([0x1, 0x0, 0x0, 0x0]); // in1
    circuit_inputs = circuit_inputs
        .next_2(
            [0x6750f230c893619174a57a76, 0xf086204a9f36ffb061794254, 0x7b0c561a6148404, 0x0],
        ); // in2
    // Fill inputs:

    for val in p_sumcheck_evaluations {
        circuit_inputs = circuit_inputs.next_u256(*val);
    } // in3 - in42

    circuit_inputs = circuit_inputs.next_2(p_gemini_masking_eval); // in43

    for val in p_gemini_a_evaluations {
        circuit_inputs = circuit_inputs.next_u256(*val);
    } // in44 - in48

    for val in p_libra_poly_evals {
        circuit_inputs = circuit_inputs.next_u256(*val);
    } // in49 - in52

    circuit_inputs = circuit_inputs.next_2(tp_gemini_r); // in53
    circuit_inputs = circuit_inputs.next_2(tp_rho); // in54
    circuit_inputs = circuit_inputs.next_2(tp_shplonk_z); // in55
    circuit_inputs = circuit_inputs.next_2(tp_shplonk_nu); // in56

    for val in tp_sum_check_u_challenges {
        circuit_inputs = circuit_inputs.next_u128(*val);
    } // in57 - in61

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let scalar_1: u384 = outputs.get_output(t10);
    let scalar_2: u384 = outputs.get_output(t16);
    let scalar_3: u384 = outputs.get_output(t20);
    let scalar_4: u384 = outputs.get_output(t24);
    let scalar_5: u384 = outputs.get_output(t28);
    let scalar_6: u384 = outputs.get_output(t32);
    let scalar_7: u384 = outputs.get_output(t36);
    let scalar_8: u384 = outputs.get_output(t40);
    let scalar_9: u384 = outputs.get_output(t44);
    let scalar_10: u384 = outputs.get_output(t48);
    let scalar_11: u384 = outputs.get_output(t52);
    let scalar_12: u384 = outputs.get_output(t56);
    let scalar_13: u384 = outputs.get_output(t60);
    let scalar_14: u384 = outputs.get_output(t64);
    let scalar_15: u384 = outputs.get_output(t68);
    let scalar_16: u384 = outputs.get_output(t72);
    let scalar_17: u384 = outputs.get_output(t76);
    let scalar_18: u384 = outputs.get_output(t80);
    let scalar_19: u384 = outputs.get_output(t84);
    let scalar_20: u384 = outputs.get_output(t88);
    let scalar_21: u384 = outputs.get_output(t92);
    let scalar_22: u384 = outputs.get_output(t96);
    let scalar_23: u384 = outputs.get_output(t100);
    let scalar_24: u384 = outputs.get_output(t104);
    let scalar_25: u384 = outputs.get_output(t108);
    let scalar_26: u384 = outputs.get_output(t112);
    let scalar_27: u384 = outputs.get_output(t116);
    let scalar_28: u384 = outputs.get_output(t120);
    let scalar_29: u384 = outputs.get_output(t365);
    let scalar_30: u384 = outputs.get_output(t366);
    let scalar_31: u384 = outputs.get_output(t367);
    let scalar_32: u384 = outputs.get_output(t368);
    let scalar_33: u384 = outputs.get_output(t369);
    let scalar_34: u384 = outputs.get_output(t144);
    let scalar_35: u384 = outputs.get_output(t148);
    let scalar_36: u384 = outputs.get_output(t152);
    let scalar_42: u384 = outputs.get_output(t238);
    let scalar_43: u384 = outputs.get_output(t253);
    let scalar_44: u384 = outputs.get_output(t268);
    let scalar_45: u384 = outputs.get_output(t283);
    let scalar_69: u384 = outputs.get_output(t346);
    let scalar_70: u384 = outputs.get_output(t364);
    let scalar_71: u384 = outputs.get_output(t361);
    let scalar_72: u384 = outputs.get_output(t363);
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
        scalar_36,
        scalar_42,
        scalar_43,
        scalar_44,
        scalar_45,
        scalar_69,
        scalar_70,
        scalar_71,
        scalar_72,
    );
}
#[inline(always)]
pub fn run_GRUMPKIN_ZK_HONK_EVALS_CONS_INIT_SIZE_5_circuit(tp_gemini_r: u384) -> (u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x1
    let in1 = CE::<CI<1>> {}; // 0x204bd3277422fad364751ad938e2b5e6a54cf8c68712848a692c553d0329f5d6

    // INPUT stack
    let in2 = CE::<CI<2>> {};
    let t0 = circuit_sub(in2, in0);
    let t1 = circuit_inverse(t0);
    let t2 = circuit_mul(in1, in2);

    let modulus = get_GRUMPKIN_modulus(); // GRUMPKIN prime field modulus

    let mut circuit_inputs = (t1, t2).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x1, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs
        .next_2(
            [0x8712848a692c553d0329f5d6, 0x64751ad938e2b5e6a54cf8c6, 0x204bd3277422fad3, 0x0],
        ); // in1
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(tp_gemini_r); // in2

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let challenge_poly_eval: u384 = outputs.get_output(t1);
    let root_power_times_tp_gemini_r: u384 = outputs.get_output(t2);
    return (challenge_poly_eval, root_power_times_tp_gemini_r);
}
#[inline(always)]
pub fn run_GRUMPKIN_ZK_HONK_EVALS_CONS_LOOP_SIZE_5_circuit(
    challenge_poly_eval: u384, root_power_times_tp_gemini_r: u384, tp_sumcheck_u_challenge: u384,
) -> (u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x1
    let in1 = CE::<CI<1>> {}; // 0x204bd3277422fad364751ad938e2b5e6a54cf8c68712848a692c553d0329f5d6

    // INPUT stack
    let (in2, in3, in4) = (CE::<CI<2>> {}, CE::<CI<3>> {}, CE::<CI<4>> {});
    let t0 = circuit_sub(in3, in0);
    let t1 = circuit_inverse(t0);
    let t2 = circuit_mul(in0, t1);
    let t3 = circuit_add(in2, t2);
    let t4 = circuit_mul(in3, in1);
    let t5 = circuit_mul(in0, in4);
    let t6 = circuit_sub(t4, in0);
    let t7 = circuit_inverse(t6);
    let t8 = circuit_mul(t5, t7);
    let t9 = circuit_add(t3, t8);
    let t10 = circuit_mul(t4, in1);
    let t11 = circuit_mul(t5, in4);
    let t12 = circuit_sub(t10, in0);
    let t13 = circuit_inverse(t12);
    let t14 = circuit_mul(t11, t13);
    let t15 = circuit_add(t9, t14);
    let t16 = circuit_mul(t10, in1);
    let t17 = circuit_mul(t11, in4);
    let t18 = circuit_sub(t16, in0);
    let t19 = circuit_inverse(t18);
    let t20 = circuit_mul(t17, t19);
    let t21 = circuit_add(t15, t20);
    let t22 = circuit_mul(t16, in1);
    let t23 = circuit_mul(t17, in4);
    let t24 = circuit_sub(t22, in0);
    let t25 = circuit_inverse(t24);
    let t26 = circuit_mul(t23, t25);
    let t27 = circuit_add(t21, t26);
    let t28 = circuit_mul(t22, in1);
    let t29 = circuit_mul(t23, in4);
    let t30 = circuit_sub(t28, in0);
    let t31 = circuit_inverse(t30);
    let t32 = circuit_mul(t29, t31);
    let t33 = circuit_add(t27, t32);
    let t34 = circuit_mul(t28, in1);
    let t35 = circuit_mul(t29, in4);
    let t36 = circuit_sub(t34, in0);
    let t37 = circuit_inverse(t36);
    let t38 = circuit_mul(t35, t37);
    let t39 = circuit_add(t33, t38);
    let t40 = circuit_mul(t34, in1);
    let t41 = circuit_mul(t35, in4);
    let t42 = circuit_sub(t40, in0);
    let t43 = circuit_inverse(t42);
    let t44 = circuit_mul(t41, t43);
    let t45 = circuit_add(t39, t44);
    let t46 = circuit_mul(t40, in1);
    let t47 = circuit_mul(t41, in4);
    let t48 = circuit_sub(t46, in0);
    let t49 = circuit_inverse(t48);
    let t50 = circuit_mul(t47, t49);
    let t51 = circuit_add(t45, t50);
    let t52 = circuit_mul(t46, in1);

    let modulus = get_GRUMPKIN_modulus(); // GRUMPKIN prime field modulus

    let mut circuit_inputs = (t51, t52).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x1, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs
        .next_2(
            [0x8712848a692c553d0329f5d6, 0x64751ad938e2b5e6a54cf8c6, 0x204bd3277422fad3, 0x0],
        ); // in1
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(challenge_poly_eval); // in2
    circuit_inputs = circuit_inputs.next_2(root_power_times_tp_gemini_r); // in3
    circuit_inputs = circuit_inputs.next_2(tp_sumcheck_u_challenge); // in4

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let challenge_poly_eval: u384 = outputs.get_output(t51);
    let root_power_times_tp_gemini_r: u384 = outputs.get_output(t52);
    return (challenge_poly_eval, root_power_times_tp_gemini_r);
}
#[inline(always)]
pub fn run_GRUMPKIN_ZK_HONK_EVALS_CONS_DONE_SIZE_5_circuit(
    p_libra_evaluation: u384,
    p_libra_poly_evals: Span<u256>,
    tp_gemini_r: u384,
    challenge_poly_eval: u384,
    root_power_times_tp_gemini_r: u384,
) -> (u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x204bd3277422fad364751ad938e2b5e6a54cf8c68712848a692c553d0329f5d6
    let in1 = CE::<CI<1>> {}; // 0x1
    let in2 = CE::<CI<2>> {}; // 0x3033ea246e506e898e97f570caffd704cb0bb460313fb720b29e139e5c100001

    // INPUT stack
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10) = (CE::<CI<9>> {}, CE::<CI<10>> {});
    let t0 = circuit_mul(in10, in0);
    let t1 = circuit_mul(t0, in0);
    let t2 = circuit_sub(in8, in1);
    let t3 = circuit_inverse(t2);
    let t4 = circuit_sub(t1, in1);
    let t5 = circuit_inverse(t4);
    let t6 = circuit_mul(in8, in8);
    let t7 = circuit_mul(t6, t6);
    let t8 = circuit_mul(t7, t7);
    let t9 = circuit_mul(t8, t8);
    let t10 = circuit_mul(t9, t9);
    let t11 = circuit_mul(t10, t10);
    let t12 = circuit_mul(t11, t11);
    let t13 = circuit_mul(t12, t12);
    let t14 = circuit_sub(t13, in1);
    let t15 = circuit_mul(t14, in2);
    let t16 = circuit_mul(in9, t15);
    let t17 = circuit_mul(t3, t15);
    let t18 = circuit_mul(t5, t15);
    let t19 = circuit_mul(t17, in6);
    let t20 = circuit_sub(in8, in0);
    let t21 = circuit_sub(in5, in6);
    let t22 = circuit_mul(in4, t16);
    let t23 = circuit_sub(t21, t22);
    let t24 = circuit_mul(t20, t23);
    let t25 = circuit_add(t19, t24);
    let t26 = circuit_sub(in6, in3);
    let t27 = circuit_mul(t18, t26);
    let t28 = circuit_add(t25, t27);
    let t29 = circuit_mul(t14, in7);
    let t30 = circuit_sub(t28, t29);

    let modulus = get_GRUMPKIN_modulus(); // GRUMPKIN prime field modulus

    let mut circuit_inputs = (t14, t30).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs
        .next_2(
            [0x8712848a692c553d0329f5d6, 0x64751ad938e2b5e6a54cf8c6, 0x204bd3277422fad3, 0x0],
        ); // in0
    circuit_inputs = circuit_inputs.next_2([0x1, 0x0, 0x0, 0x0]); // in1
    circuit_inputs = circuit_inputs
        .next_2(
            [0x313fb720b29e139e5c100001, 0x8e97f570caffd704cb0bb460, 0x3033ea246e506e89, 0x0],
        ); // in2
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(p_libra_evaluation); // in3

    for val in p_libra_poly_evals {
        circuit_inputs = circuit_inputs.next_u256(*val);
    } // in4 - in7

    circuit_inputs = circuit_inputs.next_2(tp_gemini_r); // in8
    circuit_inputs = circuit_inputs.next_2(challenge_poly_eval); // in9
    circuit_inputs = circuit_inputs.next_2(root_power_times_tp_gemini_r); // in10

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let vanishing_check: u384 = outputs.get_output(t14);
    let diff_check: u384 = outputs.get_output(t30);
    return (vanishing_check, diff_check);
}
pub fn run_BN254_EVAL_FN_CHALLENGE_SING_45P_RLC_circuit(
    A: G1Point, coeff: u384, SumDlogDivBatched: FunctionFelt,
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
    let (in183, in184, in185) = (CE::<CI<183>> {}, CE::<CI<184>> {}, CE::<CI<185>> {});
    let (in186, in187, in188) = (CE::<CI<186>> {}, CE::<CI<187>> {}, CE::<CI<188>> {});
    let (in189, in190, in191) = (CE::<CI<189>> {}, CE::<CI<190>> {}, CE::<CI<191>> {});
    let (in192, in193, in194) = (CE::<CI<192>> {}, CE::<CI<193>> {}, CE::<CI<194>> {});
    let (in195, in196, in197) = (CE::<CI<195>> {}, CE::<CI<196>> {}, CE::<CI<197>> {});
    let (in198, in199, in200) = (CE::<CI<198>> {}, CE::<CI<199>> {}, CE::<CI<200>> {});
    let t0 = circuit_mul(in50, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t1 = circuit_add(in49, t0); // Eval sumdlogdiv_a_num Horner step: add coefficient_46
    let t2 = circuit_mul(t1, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t3 = circuit_add(in48, t2); // Eval sumdlogdiv_a_num Horner step: add coefficient_45
    let t4 = circuit_mul(t3, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t5 = circuit_add(in47, t4); // Eval sumdlogdiv_a_num Horner step: add coefficient_44
    let t6 = circuit_mul(t5, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t7 = circuit_add(in46, t6); // Eval sumdlogdiv_a_num Horner step: add coefficient_43
    let t8 = circuit_mul(t7, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t9 = circuit_add(in45, t8); // Eval sumdlogdiv_a_num Horner step: add coefficient_42
    let t10 = circuit_mul(t9, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t11 = circuit_add(in44, t10); // Eval sumdlogdiv_a_num Horner step: add coefficient_41
    let t12 = circuit_mul(t11, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t13 = circuit_add(in43, t12); // Eval sumdlogdiv_a_num Horner step: add coefficient_40
    let t14 = circuit_mul(t13, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t15 = circuit_add(in42, t14); // Eval sumdlogdiv_a_num Horner step: add coefficient_39
    let t16 = circuit_mul(t15, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t17 = circuit_add(in41, t16); // Eval sumdlogdiv_a_num Horner step: add coefficient_38
    let t18 = circuit_mul(t17, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t19 = circuit_add(in40, t18); // Eval sumdlogdiv_a_num Horner step: add coefficient_37
    let t20 = circuit_mul(t19, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t21 = circuit_add(in39, t20); // Eval sumdlogdiv_a_num Horner step: add coefficient_36
    let t22 = circuit_mul(t21, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t23 = circuit_add(in38, t22); // Eval sumdlogdiv_a_num Horner step: add coefficient_35
    let t24 = circuit_mul(t23, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t25 = circuit_add(in37, t24); // Eval sumdlogdiv_a_num Horner step: add coefficient_34
    let t26 = circuit_mul(t25, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t27 = circuit_add(in36, t26); // Eval sumdlogdiv_a_num Horner step: add coefficient_33
    let t28 = circuit_mul(t27, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t29 = circuit_add(in35, t28); // Eval sumdlogdiv_a_num Horner step: add coefficient_32
    let t30 = circuit_mul(t29, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t31 = circuit_add(in34, t30); // Eval sumdlogdiv_a_num Horner step: add coefficient_31
    let t32 = circuit_mul(t31, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t33 = circuit_add(in33, t32); // Eval sumdlogdiv_a_num Horner step: add coefficient_30
    let t34 = circuit_mul(t33, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t35 = circuit_add(in32, t34); // Eval sumdlogdiv_a_num Horner step: add coefficient_29
    let t36 = circuit_mul(t35, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t37 = circuit_add(in31, t36); // Eval sumdlogdiv_a_num Horner step: add coefficient_28
    let t38 = circuit_mul(t37, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t39 = circuit_add(in30, t38); // Eval sumdlogdiv_a_num Horner step: add coefficient_27
    let t40 = circuit_mul(t39, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t41 = circuit_add(in29, t40); // Eval sumdlogdiv_a_num Horner step: add coefficient_26
    let t42 = circuit_mul(t41, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t43 = circuit_add(in28, t42); // Eval sumdlogdiv_a_num Horner step: add coefficient_25
    let t44 = circuit_mul(t43, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t45 = circuit_add(in27, t44); // Eval sumdlogdiv_a_num Horner step: add coefficient_24
    let t46 = circuit_mul(t45, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t47 = circuit_add(in26, t46); // Eval sumdlogdiv_a_num Horner step: add coefficient_23
    let t48 = circuit_mul(t47, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t49 = circuit_add(in25, t48); // Eval sumdlogdiv_a_num Horner step: add coefficient_22
    let t50 = circuit_mul(t49, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t51 = circuit_add(in24, t50); // Eval sumdlogdiv_a_num Horner step: add coefficient_21
    let t52 = circuit_mul(t51, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t53 = circuit_add(in23, t52); // Eval sumdlogdiv_a_num Horner step: add coefficient_20
    let t54 = circuit_mul(t53, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t55 = circuit_add(in22, t54); // Eval sumdlogdiv_a_num Horner step: add coefficient_19
    let t56 = circuit_mul(t55, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t57 = circuit_add(in21, t56); // Eval sumdlogdiv_a_num Horner step: add coefficient_18
    let t58 = circuit_mul(t57, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t59 = circuit_add(in20, t58); // Eval sumdlogdiv_a_num Horner step: add coefficient_17
    let t60 = circuit_mul(t59, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t61 = circuit_add(in19, t60); // Eval sumdlogdiv_a_num Horner step: add coefficient_16
    let t62 = circuit_mul(t61, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t63 = circuit_add(in18, t62); // Eval sumdlogdiv_a_num Horner step: add coefficient_15
    let t64 = circuit_mul(t63, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t65 = circuit_add(in17, t64); // Eval sumdlogdiv_a_num Horner step: add coefficient_14
    let t66 = circuit_mul(t65, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t67 = circuit_add(in16, t66); // Eval sumdlogdiv_a_num Horner step: add coefficient_13
    let t68 = circuit_mul(t67, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t69 = circuit_add(in15, t68); // Eval sumdlogdiv_a_num Horner step: add coefficient_12
    let t70 = circuit_mul(t69, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t71 = circuit_add(in14, t70); // Eval sumdlogdiv_a_num Horner step: add coefficient_11
    let t72 = circuit_mul(t71, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t73 = circuit_add(in13, t72); // Eval sumdlogdiv_a_num Horner step: add coefficient_10
    let t74 = circuit_mul(t73, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t75 = circuit_add(in12, t74); // Eval sumdlogdiv_a_num Horner step: add coefficient_9
    let t76 = circuit_mul(t75, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t77 = circuit_add(in11, t76); // Eval sumdlogdiv_a_num Horner step: add coefficient_8
    let t78 = circuit_mul(t77, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t79 = circuit_add(in10, t78); // Eval sumdlogdiv_a_num Horner step: add coefficient_7
    let t80 = circuit_mul(t79, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t81 = circuit_add(in9, t80); // Eval sumdlogdiv_a_num Horner step: add coefficient_6
    let t82 = circuit_mul(t81, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t83 = circuit_add(in8, t82); // Eval sumdlogdiv_a_num Horner step: add coefficient_5
    let t84 = circuit_mul(t83, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t85 = circuit_add(in7, t84); // Eval sumdlogdiv_a_num Horner step: add coefficient_4
    let t86 = circuit_mul(t85, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t87 = circuit_add(in6, t86); // Eval sumdlogdiv_a_num Horner step: add coefficient_3
    let t88 = circuit_mul(t87, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t89 = circuit_add(in5, t88); // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    let t90 = circuit_mul(t89, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t91 = circuit_add(in4, t90); // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    let t92 = circuit_mul(t91, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t93 = circuit_add(in3, t92); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t94 = circuit_mul(in99, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t95 = circuit_add(in98, t94); // Eval sumdlogdiv_a_den Horner step: add coefficient_47
    let t96 = circuit_mul(t95, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t97 = circuit_add(in97, t96); // Eval sumdlogdiv_a_den Horner step: add coefficient_46
    let t98 = circuit_mul(t97, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t99 = circuit_add(in96, t98); // Eval sumdlogdiv_a_den Horner step: add coefficient_45
    let t100 = circuit_mul(t99, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t101 = circuit_add(in95, t100); // Eval sumdlogdiv_a_den Horner step: add coefficient_44
    let t102 = circuit_mul(t101, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t103 = circuit_add(in94, t102); // Eval sumdlogdiv_a_den Horner step: add coefficient_43
    let t104 = circuit_mul(t103, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t105 = circuit_add(in93, t104); // Eval sumdlogdiv_a_den Horner step: add coefficient_42
    let t106 = circuit_mul(t105, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t107 = circuit_add(in92, t106); // Eval sumdlogdiv_a_den Horner step: add coefficient_41
    let t108 = circuit_mul(t107, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t109 = circuit_add(in91, t108); // Eval sumdlogdiv_a_den Horner step: add coefficient_40
    let t110 = circuit_mul(t109, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t111 = circuit_add(in90, t110); // Eval sumdlogdiv_a_den Horner step: add coefficient_39
    let t112 = circuit_mul(t111, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t113 = circuit_add(in89, t112); // Eval sumdlogdiv_a_den Horner step: add coefficient_38
    let t114 = circuit_mul(t113, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t115 = circuit_add(in88, t114); // Eval sumdlogdiv_a_den Horner step: add coefficient_37
    let t116 = circuit_mul(t115, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t117 = circuit_add(in87, t116); // Eval sumdlogdiv_a_den Horner step: add coefficient_36
    let t118 = circuit_mul(t117, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t119 = circuit_add(in86, t118); // Eval sumdlogdiv_a_den Horner step: add coefficient_35
    let t120 = circuit_mul(t119, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t121 = circuit_add(in85, t120); // Eval sumdlogdiv_a_den Horner step: add coefficient_34
    let t122 = circuit_mul(t121, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t123 = circuit_add(in84, t122); // Eval sumdlogdiv_a_den Horner step: add coefficient_33
    let t124 = circuit_mul(t123, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t125 = circuit_add(in83, t124); // Eval sumdlogdiv_a_den Horner step: add coefficient_32
    let t126 = circuit_mul(t125, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t127 = circuit_add(in82, t126); // Eval sumdlogdiv_a_den Horner step: add coefficient_31
    let t128 = circuit_mul(t127, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t129 = circuit_add(in81, t128); // Eval sumdlogdiv_a_den Horner step: add coefficient_30
    let t130 = circuit_mul(t129, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t131 = circuit_add(in80, t130); // Eval sumdlogdiv_a_den Horner step: add coefficient_29
    let t132 = circuit_mul(t131, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t133 = circuit_add(in79, t132); // Eval sumdlogdiv_a_den Horner step: add coefficient_28
    let t134 = circuit_mul(t133, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t135 = circuit_add(in78, t134); // Eval sumdlogdiv_a_den Horner step: add coefficient_27
    let t136 = circuit_mul(t135, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t137 = circuit_add(in77, t136); // Eval sumdlogdiv_a_den Horner step: add coefficient_26
    let t138 = circuit_mul(t137, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t139 = circuit_add(in76, t138); // Eval sumdlogdiv_a_den Horner step: add coefficient_25
    let t140 = circuit_mul(t139, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t141 = circuit_add(in75, t140); // Eval sumdlogdiv_a_den Horner step: add coefficient_24
    let t142 = circuit_mul(t141, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t143 = circuit_add(in74, t142); // Eval sumdlogdiv_a_den Horner step: add coefficient_23
    let t144 = circuit_mul(t143, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t145 = circuit_add(in73, t144); // Eval sumdlogdiv_a_den Horner step: add coefficient_22
    let t146 = circuit_mul(t145, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t147 = circuit_add(in72, t146); // Eval sumdlogdiv_a_den Horner step: add coefficient_21
    let t148 = circuit_mul(t147, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t149 = circuit_add(in71, t148); // Eval sumdlogdiv_a_den Horner step: add coefficient_20
    let t150 = circuit_mul(t149, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t151 = circuit_add(in70, t150); // Eval sumdlogdiv_a_den Horner step: add coefficient_19
    let t152 = circuit_mul(t151, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t153 = circuit_add(in69, t152); // Eval sumdlogdiv_a_den Horner step: add coefficient_18
    let t154 = circuit_mul(t153, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t155 = circuit_add(in68, t154); // Eval sumdlogdiv_a_den Horner step: add coefficient_17
    let t156 = circuit_mul(t155, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t157 = circuit_add(in67, t156); // Eval sumdlogdiv_a_den Horner step: add coefficient_16
    let t158 = circuit_mul(t157, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t159 = circuit_add(in66, t158); // Eval sumdlogdiv_a_den Horner step: add coefficient_15
    let t160 = circuit_mul(t159, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t161 = circuit_add(in65, t160); // Eval sumdlogdiv_a_den Horner step: add coefficient_14
    let t162 = circuit_mul(t161, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t163 = circuit_add(in64, t162); // Eval sumdlogdiv_a_den Horner step: add coefficient_13
    let t164 = circuit_mul(t163, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t165 = circuit_add(in63, t164); // Eval sumdlogdiv_a_den Horner step: add coefficient_12
    let t166 = circuit_mul(t165, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t167 = circuit_add(in62, t166); // Eval sumdlogdiv_a_den Horner step: add coefficient_11
    let t168 = circuit_mul(t167, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t169 = circuit_add(in61, t168); // Eval sumdlogdiv_a_den Horner step: add coefficient_10
    let t170 = circuit_mul(t169, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t171 = circuit_add(in60, t170); // Eval sumdlogdiv_a_den Horner step: add coefficient_9
    let t172 = circuit_mul(t171, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t173 = circuit_add(in59, t172); // Eval sumdlogdiv_a_den Horner step: add coefficient_8
    let t174 = circuit_mul(t173, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t175 = circuit_add(in58, t174); // Eval sumdlogdiv_a_den Horner step: add coefficient_7
    let t176 = circuit_mul(t175, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t177 = circuit_add(in57, t176); // Eval sumdlogdiv_a_den Horner step: add coefficient_6
    let t178 = circuit_mul(t177, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t179 = circuit_add(in56, t178); // Eval sumdlogdiv_a_den Horner step: add coefficient_5
    let t180 = circuit_mul(t179, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t181 = circuit_add(in55, t180); // Eval sumdlogdiv_a_den Horner step: add coefficient_4
    let t182 = circuit_mul(t181, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t183 = circuit_add(in54, t182); // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    let t184 = circuit_mul(t183, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t185 = circuit_add(in53, t184); // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    let t186 = circuit_mul(t185, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t187 = circuit_add(in52, t186); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t188 = circuit_mul(t187, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t189 = circuit_add(in51, t188); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t190 = circuit_inverse(t189);
    let t191 = circuit_mul(t93, t190);
    let t192 = circuit_mul(in148, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t193 = circuit_add(in147, t192); // Eval sumdlogdiv_b_num Horner step: add coefficient_47
    let t194 = circuit_mul(t193, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t195 = circuit_add(in146, t194); // Eval sumdlogdiv_b_num Horner step: add coefficient_46
    let t196 = circuit_mul(t195, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t197 = circuit_add(in145, t196); // Eval sumdlogdiv_b_num Horner step: add coefficient_45
    let t198 = circuit_mul(t197, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t199 = circuit_add(in144, t198); // Eval sumdlogdiv_b_num Horner step: add coefficient_44
    let t200 = circuit_mul(t199, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t201 = circuit_add(in143, t200); // Eval sumdlogdiv_b_num Horner step: add coefficient_43
    let t202 = circuit_mul(t201, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t203 = circuit_add(in142, t202); // Eval sumdlogdiv_b_num Horner step: add coefficient_42
    let t204 = circuit_mul(t203, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t205 = circuit_add(in141, t204); // Eval sumdlogdiv_b_num Horner step: add coefficient_41
    let t206 = circuit_mul(t205, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t207 = circuit_add(in140, t206); // Eval sumdlogdiv_b_num Horner step: add coefficient_40
    let t208 = circuit_mul(t207, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t209 = circuit_add(in139, t208); // Eval sumdlogdiv_b_num Horner step: add coefficient_39
    let t210 = circuit_mul(t209, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t211 = circuit_add(in138, t210); // Eval sumdlogdiv_b_num Horner step: add coefficient_38
    let t212 = circuit_mul(t211, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t213 = circuit_add(in137, t212); // Eval sumdlogdiv_b_num Horner step: add coefficient_37
    let t214 = circuit_mul(t213, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t215 = circuit_add(in136, t214); // Eval sumdlogdiv_b_num Horner step: add coefficient_36
    let t216 = circuit_mul(t215, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t217 = circuit_add(in135, t216); // Eval sumdlogdiv_b_num Horner step: add coefficient_35
    let t218 = circuit_mul(t217, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t219 = circuit_add(in134, t218); // Eval sumdlogdiv_b_num Horner step: add coefficient_34
    let t220 = circuit_mul(t219, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t221 = circuit_add(in133, t220); // Eval sumdlogdiv_b_num Horner step: add coefficient_33
    let t222 = circuit_mul(t221, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t223 = circuit_add(in132, t222); // Eval sumdlogdiv_b_num Horner step: add coefficient_32
    let t224 = circuit_mul(t223, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t225 = circuit_add(in131, t224); // Eval sumdlogdiv_b_num Horner step: add coefficient_31
    let t226 = circuit_mul(t225, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t227 = circuit_add(in130, t226); // Eval sumdlogdiv_b_num Horner step: add coefficient_30
    let t228 = circuit_mul(t227, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t229 = circuit_add(in129, t228); // Eval sumdlogdiv_b_num Horner step: add coefficient_29
    let t230 = circuit_mul(t229, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t231 = circuit_add(in128, t230); // Eval sumdlogdiv_b_num Horner step: add coefficient_28
    let t232 = circuit_mul(t231, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t233 = circuit_add(in127, t232); // Eval sumdlogdiv_b_num Horner step: add coefficient_27
    let t234 = circuit_mul(t233, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t235 = circuit_add(in126, t234); // Eval sumdlogdiv_b_num Horner step: add coefficient_26
    let t236 = circuit_mul(t235, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t237 = circuit_add(in125, t236); // Eval sumdlogdiv_b_num Horner step: add coefficient_25
    let t238 = circuit_mul(t237, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t239 = circuit_add(in124, t238); // Eval sumdlogdiv_b_num Horner step: add coefficient_24
    let t240 = circuit_mul(t239, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t241 = circuit_add(in123, t240); // Eval sumdlogdiv_b_num Horner step: add coefficient_23
    let t242 = circuit_mul(t241, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t243 = circuit_add(in122, t242); // Eval sumdlogdiv_b_num Horner step: add coefficient_22
    let t244 = circuit_mul(t243, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t245 = circuit_add(in121, t244); // Eval sumdlogdiv_b_num Horner step: add coefficient_21
    let t246 = circuit_mul(t245, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t247 = circuit_add(in120, t246); // Eval sumdlogdiv_b_num Horner step: add coefficient_20
    let t248 = circuit_mul(t247, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t249 = circuit_add(in119, t248); // Eval sumdlogdiv_b_num Horner step: add coefficient_19
    let t250 = circuit_mul(t249, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t251 = circuit_add(in118, t250); // Eval sumdlogdiv_b_num Horner step: add coefficient_18
    let t252 = circuit_mul(t251, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t253 = circuit_add(in117, t252); // Eval sumdlogdiv_b_num Horner step: add coefficient_17
    let t254 = circuit_mul(t253, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t255 = circuit_add(in116, t254); // Eval sumdlogdiv_b_num Horner step: add coefficient_16
    let t256 = circuit_mul(t255, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t257 = circuit_add(in115, t256); // Eval sumdlogdiv_b_num Horner step: add coefficient_15
    let t258 = circuit_mul(t257, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t259 = circuit_add(in114, t258); // Eval sumdlogdiv_b_num Horner step: add coefficient_14
    let t260 = circuit_mul(t259, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t261 = circuit_add(in113, t260); // Eval sumdlogdiv_b_num Horner step: add coefficient_13
    let t262 = circuit_mul(t261, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t263 = circuit_add(in112, t262); // Eval sumdlogdiv_b_num Horner step: add coefficient_12
    let t264 = circuit_mul(t263, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t265 = circuit_add(in111, t264); // Eval sumdlogdiv_b_num Horner step: add coefficient_11
    let t266 = circuit_mul(t265, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t267 = circuit_add(in110, t266); // Eval sumdlogdiv_b_num Horner step: add coefficient_10
    let t268 = circuit_mul(t267, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t269 = circuit_add(in109, t268); // Eval sumdlogdiv_b_num Horner step: add coefficient_9
    let t270 = circuit_mul(t269, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t271 = circuit_add(in108, t270); // Eval sumdlogdiv_b_num Horner step: add coefficient_8
    let t272 = circuit_mul(t271, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t273 = circuit_add(in107, t272); // Eval sumdlogdiv_b_num Horner step: add coefficient_7
    let t274 = circuit_mul(t273, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t275 = circuit_add(in106, t274); // Eval sumdlogdiv_b_num Horner step: add coefficient_6
    let t276 = circuit_mul(t275, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t277 = circuit_add(in105, t276); // Eval sumdlogdiv_b_num Horner step: add coefficient_5
    let t278 = circuit_mul(t277, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t279 = circuit_add(in104, t278); // Eval sumdlogdiv_b_num Horner step: add coefficient_4
    let t280 = circuit_mul(t279, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t281 = circuit_add(in103, t280); // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    let t282 = circuit_mul(t281, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t283 = circuit_add(in102, t282); // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    let t284 = circuit_mul(t283, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t285 = circuit_add(in101, t284); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t286 = circuit_mul(t285, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t287 = circuit_add(in100, t286); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t288 = circuit_mul(in200, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t289 = circuit_add(in199, t288); // Eval sumdlogdiv_b_den Horner step: add coefficient_50
    let t290 = circuit_mul(t289, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t291 = circuit_add(in198, t290); // Eval sumdlogdiv_b_den Horner step: add coefficient_49
    let t292 = circuit_mul(t291, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t293 = circuit_add(in197, t292); // Eval sumdlogdiv_b_den Horner step: add coefficient_48
    let t294 = circuit_mul(t293, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t295 = circuit_add(in196, t294); // Eval sumdlogdiv_b_den Horner step: add coefficient_47
    let t296 = circuit_mul(t295, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t297 = circuit_add(in195, t296); // Eval sumdlogdiv_b_den Horner step: add coefficient_46
    let t298 = circuit_mul(t297, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t299 = circuit_add(in194, t298); // Eval sumdlogdiv_b_den Horner step: add coefficient_45
    let t300 = circuit_mul(t299, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t301 = circuit_add(in193, t300); // Eval sumdlogdiv_b_den Horner step: add coefficient_44
    let t302 = circuit_mul(t301, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t303 = circuit_add(in192, t302); // Eval sumdlogdiv_b_den Horner step: add coefficient_43
    let t304 = circuit_mul(t303, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t305 = circuit_add(in191, t304); // Eval sumdlogdiv_b_den Horner step: add coefficient_42
    let t306 = circuit_mul(t305, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t307 = circuit_add(in190, t306); // Eval sumdlogdiv_b_den Horner step: add coefficient_41
    let t308 = circuit_mul(t307, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t309 = circuit_add(in189, t308); // Eval sumdlogdiv_b_den Horner step: add coefficient_40
    let t310 = circuit_mul(t309, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t311 = circuit_add(in188, t310); // Eval sumdlogdiv_b_den Horner step: add coefficient_39
    let t312 = circuit_mul(t311, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t313 = circuit_add(in187, t312); // Eval sumdlogdiv_b_den Horner step: add coefficient_38
    let t314 = circuit_mul(t313, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t315 = circuit_add(in186, t314); // Eval sumdlogdiv_b_den Horner step: add coefficient_37
    let t316 = circuit_mul(t315, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t317 = circuit_add(in185, t316); // Eval sumdlogdiv_b_den Horner step: add coefficient_36
    let t318 = circuit_mul(t317, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t319 = circuit_add(in184, t318); // Eval sumdlogdiv_b_den Horner step: add coefficient_35
    let t320 = circuit_mul(t319, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t321 = circuit_add(in183, t320); // Eval sumdlogdiv_b_den Horner step: add coefficient_34
    let t322 = circuit_mul(t321, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t323 = circuit_add(in182, t322); // Eval sumdlogdiv_b_den Horner step: add coefficient_33
    let t324 = circuit_mul(t323, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t325 = circuit_add(in181, t324); // Eval sumdlogdiv_b_den Horner step: add coefficient_32
    let t326 = circuit_mul(t325, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t327 = circuit_add(in180, t326); // Eval sumdlogdiv_b_den Horner step: add coefficient_31
    let t328 = circuit_mul(t327, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t329 = circuit_add(in179, t328); // Eval sumdlogdiv_b_den Horner step: add coefficient_30
    let t330 = circuit_mul(t329, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t331 = circuit_add(in178, t330); // Eval sumdlogdiv_b_den Horner step: add coefficient_29
    let t332 = circuit_mul(t331, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t333 = circuit_add(in177, t332); // Eval sumdlogdiv_b_den Horner step: add coefficient_28
    let t334 = circuit_mul(t333, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t335 = circuit_add(in176, t334); // Eval sumdlogdiv_b_den Horner step: add coefficient_27
    let t336 = circuit_mul(t335, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t337 = circuit_add(in175, t336); // Eval sumdlogdiv_b_den Horner step: add coefficient_26
    let t338 = circuit_mul(t337, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t339 = circuit_add(in174, t338); // Eval sumdlogdiv_b_den Horner step: add coefficient_25
    let t340 = circuit_mul(t339, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t341 = circuit_add(in173, t340); // Eval sumdlogdiv_b_den Horner step: add coefficient_24
    let t342 = circuit_mul(t341, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t343 = circuit_add(in172, t342); // Eval sumdlogdiv_b_den Horner step: add coefficient_23
    let t344 = circuit_mul(t343, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t345 = circuit_add(in171, t344); // Eval sumdlogdiv_b_den Horner step: add coefficient_22
    let t346 = circuit_mul(t345, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t347 = circuit_add(in170, t346); // Eval sumdlogdiv_b_den Horner step: add coefficient_21
    let t348 = circuit_mul(t347, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t349 = circuit_add(in169, t348); // Eval sumdlogdiv_b_den Horner step: add coefficient_20
    let t350 = circuit_mul(t349, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t351 = circuit_add(in168, t350); // Eval sumdlogdiv_b_den Horner step: add coefficient_19
    let t352 = circuit_mul(t351, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t353 = circuit_add(in167, t352); // Eval sumdlogdiv_b_den Horner step: add coefficient_18
    let t354 = circuit_mul(t353, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t355 = circuit_add(in166, t354); // Eval sumdlogdiv_b_den Horner step: add coefficient_17
    let t356 = circuit_mul(t355, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t357 = circuit_add(in165, t356); // Eval sumdlogdiv_b_den Horner step: add coefficient_16
    let t358 = circuit_mul(t357, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t359 = circuit_add(in164, t358); // Eval sumdlogdiv_b_den Horner step: add coefficient_15
    let t360 = circuit_mul(t359, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t361 = circuit_add(in163, t360); // Eval sumdlogdiv_b_den Horner step: add coefficient_14
    let t362 = circuit_mul(t361, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t363 = circuit_add(in162, t362); // Eval sumdlogdiv_b_den Horner step: add coefficient_13
    let t364 = circuit_mul(t363, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t365 = circuit_add(in161, t364); // Eval sumdlogdiv_b_den Horner step: add coefficient_12
    let t366 = circuit_mul(t365, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t367 = circuit_add(in160, t366); // Eval sumdlogdiv_b_den Horner step: add coefficient_11
    let t368 = circuit_mul(t367, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t369 = circuit_add(in159, t368); // Eval sumdlogdiv_b_den Horner step: add coefficient_10
    let t370 = circuit_mul(t369, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t371 = circuit_add(in158, t370); // Eval sumdlogdiv_b_den Horner step: add coefficient_9
    let t372 = circuit_mul(t371, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t373 = circuit_add(in157, t372); // Eval sumdlogdiv_b_den Horner step: add coefficient_8
    let t374 = circuit_mul(t373, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t375 = circuit_add(in156, t374); // Eval sumdlogdiv_b_den Horner step: add coefficient_7
    let t376 = circuit_mul(t375, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t377 = circuit_add(in155, t376); // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    let t378 = circuit_mul(t377, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t379 = circuit_add(in154, t378); // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    let t380 = circuit_mul(t379, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t381 = circuit_add(in153, t380); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t382 = circuit_mul(t381, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t383 = circuit_add(in152, t382); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t384 = circuit_mul(t383, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t385 = circuit_add(in151, t384); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t386 = circuit_mul(t385, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t387 = circuit_add(in150, t386); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t388 = circuit_mul(t387, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t389 = circuit_add(in149, t388); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t390 = circuit_inverse(t389);
    let t391 = circuit_mul(t287, t390);
    let t392 = circuit_mul(in1, t391);
    let t393 = circuit_add(t191, t392);
    let t394 = circuit_mul(in2, t393);

    let modulus = get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (t394,).new_inputs();
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
    // in3 - in200

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: u384 = outputs.get_output(t394);
    return (res,);
}

impl CircuitDefinition44<
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
    E40,
    E41,
    E42,
    E43,
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
        CE<E40>,
        CE<E41>,
        CE<E42>,
        CE<E43>,
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
                E40,
                E41,
                E42,
                E43,
            ),
        >;
}
impl MyDrp_44<
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
    E40,
    E41,
    E42,
    E43,
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
        CE<E40>,
        CE<E41>,
        CE<E42>,
        CE<E43>,
    ),
>;

