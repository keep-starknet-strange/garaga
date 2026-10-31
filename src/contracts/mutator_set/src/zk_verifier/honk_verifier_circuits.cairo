use core::circuit::{
    CircuitElement as CE, CircuitInput as CI, CircuitInputs, CircuitModulus, circuit_add,
    circuit_inverse, circuit_mul, circuit_sub, u384,
};
use garaga::core::circuit::{
    AddInputResultTrait2, CircuitOutputsTrait, EvalCircuitTrait, u288IntoCircuitInputValue,
};
use garaga::definitions::G1Point;

#[inline(always)]
pub fn run_GRUMPKIN_ZK_HONK_SUMCHECK_SIZE_17_PUB_11_circuit(
    p_public_inputs: Span<u256>,
    p_pairing_point_object: Span<u256>,
    libra_sum: u384,
    sumcheck_univariates_flat: Span<u256>,
    sumcheck_evaluations: Span<u256>,
    libra_evaluation: u384,
    tp_sum_check_u_challenges: Span<u256>,
    tp_gate_challenge: u256,
    tp_eta_1: u384,
    tp_rom_logup_gamma: u384,
    tp_beta: u384,
    tp_gamma: u384,
    tp_base_rlc: u384,
    tp_alpha: u256,
    tp_libra_challenge: u384,
    modulus: core::circuit::CircuitModulus,
) -> (u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x5
    let in1 = CE::<CI<1>> {}; // 0x1
    let in2 = CE::<CI<2>> {}; // 0x10000000
    let in3 = CE::<CI<3>> {}; // 0x9d80
    let in4 = CE::<CI<4>> {}; // 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593efffec51
    let in5 = CE::<CI<5>> {}; // 0x5a0
    let in6 = CE::<CI<6>> {}; // 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593effffd31
    let in7 = CE::<CI<7>> {}; // 0x240
    let in8 = CE::<CI<8>> {}; // 0x0
    let in9 = CE::<CI<9>> {}; // 0x2
    let in10 = CE::<CI<10>> {}; // 0x3
    let in11 = CE::<CI<11>> {}; // 0x4
    let in12 = CE::<CI<12>> {}; // 0x6
    let in13 = CE::<CI<13>> {}; // 0x7
    let in14 = CE::<CI<14>> {}; // 0x8
    let in15 = CE::<
        CI<15>,
    > {}; // 0x183227397098d014dc2822db40c0ac2e9419f4243cdcb848a1f0fac9f8000000
    let in16 = CE::<CI<16>> {}; // -0x1 % p

    // INPUT stack
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
    let (in56, in57, in58) = (CE::<CI<56>> {}, CE::<CI<57>> {}, CE::<CI<58>> {});
    let (in59, in60, in61) = (CE::<CI<59>> {}, CE::<CI<60>> {}, CE::<CI<61>> {});
    let (in62, in63, in64) = (CE::<CI<62>> {}, CE::<CI<63>> {}, CE::<CI<64>> {});
    let (in65, in66, in67) = (CE::<CI<65>> {}, CE::<CI<66>> {}, CE::<CI<67>> {});
    let (in68, in69, in70) = (CE::<CI<68>> {}, CE::<CI<69>> {}, CE::<CI<70>> {});
    let (in71, in72, in73) = (CE::<CI<71>> {}, CE::<CI<72>> {}, CE::<CI<73>> {});
    let (in74, in75, in76) = (CE::<CI<74>> {}, CE::<CI<75>> {}, CE::<CI<76>> {});
    let (in77, in78, in79) = (CE::<CI<77>> {}, CE::<CI<78>> {}, CE::<CI<79>> {});
    let (in80, in81, in82) = (CE::<CI<80>> {}, CE::<CI<81>> {}, CE::<CI<82>> {});
    let (in83, in84, in85) = (CE::<CI<83>> {}, CE::<CI<84>> {}, CE::<CI<85>> {});
    let (in86, in87, in88) = (CE::<CI<86>> {}, CE::<CI<87>> {}, CE::<CI<88>> {});
    let (in89, in90, in91) = (CE::<CI<89>> {}, CE::<CI<90>> {}, CE::<CI<91>> {});
    let (in92, in93, in94) = (CE::<CI<92>> {}, CE::<CI<93>> {}, CE::<CI<94>> {});
    let (in95, in96, in97) = (CE::<CI<95>> {}, CE::<CI<96>> {}, CE::<CI<97>> {});
    let (in98, in99, in100) = (CE::<CI<98>> {}, CE::<CI<99>> {}, CE::<CI<100>> {});
    let (in101, in102, in103) = (CE::<CI<101>> {}, CE::<CI<102>> {}, CE::<CI<103>> {});
    let (in104, in105, in106) = (CE::<CI<104>> {}, CE::<CI<105>> {}, CE::<CI<106>> {});
    let (in107, in108, in109) = (CE::<CI<107>> {}, CE::<CI<108>> {}, CE::<CI<109>> {});
    let (in110, in111, in112) = (CE::<CI<110>> {}, CE::<CI<111>> {}, CE::<CI<112>> {});
    let (in113, in114, in115) = (CE::<CI<113>> {}, CE::<CI<114>> {}, CE::<CI<115>> {});
    let (in116, in117, in118) = (CE::<CI<116>> {}, CE::<CI<117>> {}, CE::<CI<118>> {});
    let (in119, in120, in121) = (CE::<CI<119>> {}, CE::<CI<120>> {}, CE::<CI<121>> {});
    let (in122, in123, in124) = (CE::<CI<122>> {}, CE::<CI<123>> {}, CE::<CI<124>> {});
    let (in125, in126, in127) = (CE::<CI<125>> {}, CE::<CI<126>> {}, CE::<CI<127>> {});
    let (in128, in129, in130) = (CE::<CI<128>> {}, CE::<CI<129>> {}, CE::<CI<130>> {});
    let (in131, in132, in133) = (CE::<CI<131>> {}, CE::<CI<132>> {}, CE::<CI<133>> {});
    let (in134, in135, in136) = (CE::<CI<134>> {}, CE::<CI<135>> {}, CE::<CI<136>> {});
    let (in137, in138, in139) = (CE::<CI<137>> {}, CE::<CI<138>> {}, CE::<CI<139>> {});
    let (in140, in141, in142) = (CE::<CI<140>> {}, CE::<CI<141>> {}, CE::<CI<142>> {});
    let (in143, in144, in145) = (CE::<CI<143>> {}, CE::<CI<144>> {}, CE::<CI<145>> {});
    let (in146, in147, in148) = (CE::<CI<146>> {}, CE::<CI<147>> {}, CE::<CI<148>> {});
    let (in149, in150, in151) = (CE::<CI<149>> {}, CE::<CI<150>> {}, CE::<CI<151>> {});
    let (in152, in153, in154) = (CE::<CI<152>> {}, CE::<CI<153>> {}, CE::<CI<154>> {});
    let (in155, in156, in157) = (CE::<CI<155>> {}, CE::<CI<156>> {}, CE::<CI<157>> {});
    let (in158, in159, in160) = (CE::<CI<158>> {}, CE::<CI<159>> {}, CE::<CI<160>> {});
    let (in161, in162, in163) = (CE::<CI<161>> {}, CE::<CI<162>> {}, CE::<CI<163>> {});
    let (in164, in165, in166) = (CE::<CI<164>> {}, CE::<CI<165>> {}, CE::<CI<166>> {});
    let (in167, in168, in169) = (CE::<CI<167>> {}, CE::<CI<168>> {}, CE::<CI<169>> {});
    let (in170, in171, in172) = (CE::<CI<170>> {}, CE::<CI<171>> {}, CE::<CI<172>> {});
    let (in173, in174, in175) = (CE::<CI<173>> {}, CE::<CI<174>> {}, CE::<CI<175>> {});
    let (in176, in177, in178) = (CE::<CI<176>> {}, CE::<CI<177>> {}, CE::<CI<178>> {});
    let (in179, in180, in181) = (CE::<CI<179>> {}, CE::<CI<180>> {}, CE::<CI<181>> {});
    let (in182, in183, in184) = (CE::<CI<182>> {}, CE::<CI<183>> {}, CE::<CI<184>> {});
    let (in185, in186, in187) = (CE::<CI<185>> {}, CE::<CI<186>> {}, CE::<CI<187>> {});
    let (in188, in189, in190) = (CE::<CI<188>> {}, CE::<CI<189>> {}, CE::<CI<190>> {});
    let (in191, in192, in193) = (CE::<CI<191>> {}, CE::<CI<192>> {}, CE::<CI<193>> {});
    let (in194, in195, in196) = (CE::<CI<194>> {}, CE::<CI<195>> {}, CE::<CI<196>> {});
    let (in197, in198, in199) = (CE::<CI<197>> {}, CE::<CI<198>> {}, CE::<CI<199>> {});
    let (in200, in201, in202) = (CE::<CI<200>> {}, CE::<CI<201>> {}, CE::<CI<202>> {});
    let (in203, in204, in205) = (CE::<CI<203>> {}, CE::<CI<204>> {}, CE::<CI<205>> {});
    let (in206, in207, in208) = (CE::<CI<206>> {}, CE::<CI<207>> {}, CE::<CI<208>> {});
    let (in209, in210, in211) = (CE::<CI<209>> {}, CE::<CI<210>> {}, CE::<CI<211>> {});
    let (in212, in213, in214) = (CE::<CI<212>> {}, CE::<CI<213>> {}, CE::<CI<214>> {});
    let (in215, in216, in217) = (CE::<CI<215>> {}, CE::<CI<216>> {}, CE::<CI<217>> {});
    let (in218, in219, in220) = (CE::<CI<218>> {}, CE::<CI<219>> {}, CE::<CI<220>> {});
    let (in221, in222, in223) = (CE::<CI<221>> {}, CE::<CI<222>> {}, CE::<CI<223>> {});
    let (in224, in225, in226) = (CE::<CI<224>> {}, CE::<CI<225>> {}, CE::<CI<226>> {});
    let (in227, in228, in229) = (CE::<CI<227>> {}, CE::<CI<228>> {}, CE::<CI<229>> {});
    let (in230, in231, in232) = (CE::<CI<230>> {}, CE::<CI<231>> {}, CE::<CI<232>> {});
    let (in233, in234, in235) = (CE::<CI<233>> {}, CE::<CI<234>> {}, CE::<CI<235>> {});
    let (in236, in237, in238) = (CE::<CI<236>> {}, CE::<CI<237>> {}, CE::<CI<238>> {});
    let (in239, in240, in241) = (CE::<CI<239>> {}, CE::<CI<240>> {}, CE::<CI<241>> {});
    let (in242, in243, in244) = (CE::<CI<242>> {}, CE::<CI<243>> {}, CE::<CI<244>> {});
    let t0 = circuit_add(in2, in0);
    let t1 = circuit_mul(in240, t0);
    let t2 = circuit_add(in241, t1);
    let t3 = circuit_add(in0, in1);
    let t4 = circuit_mul(in240, t3);
    let t5 = circuit_sub(in241, t4);
    let t6 = circuit_add(t2, in17);
    let t7 = circuit_mul(in1, t6);
    let t8 = circuit_add(t5, in17);
    let t9 = circuit_mul(in1, t8);
    let t10 = circuit_add(t2, in240);
    let t11 = circuit_sub(t5, in240);
    let t12 = circuit_add(t10, in18);
    let t13 = circuit_mul(t7, t12);
    let t14 = circuit_add(t11, in18);
    let t15 = circuit_mul(t9, t14);
    let t16 = circuit_add(t10, in240);
    let t17 = circuit_sub(t11, in240);
    let t18 = circuit_add(t16, in19);
    let t19 = circuit_mul(t13, t18);
    let t20 = circuit_add(t17, in19);
    let t21 = circuit_mul(t15, t20);
    let t22 = circuit_add(t16, in240);
    let t23 = circuit_sub(t17, in240);
    let t24 = circuit_add(t22, in20);
    let t25 = circuit_mul(t19, t24);
    let t26 = circuit_add(t23, in20);
    let t27 = circuit_mul(t21, t26);
    let t28 = circuit_add(t22, in240);
    let t29 = circuit_sub(t23, in240);
    let t30 = circuit_add(t28, in21);
    let t31 = circuit_mul(t25, t30);
    let t32 = circuit_add(t29, in21);
    let t33 = circuit_mul(t27, t32);
    let t34 = circuit_add(t28, in240);
    let t35 = circuit_sub(t29, in240);
    let t36 = circuit_add(t34, in22);
    let t37 = circuit_mul(t31, t36);
    let t38 = circuit_add(t35, in22);
    let t39 = circuit_mul(t33, t38);
    let t40 = circuit_add(t34, in240);
    let t41 = circuit_sub(t35, in240);
    let t42 = circuit_add(t40, in23);
    let t43 = circuit_mul(t37, t42);
    let t44 = circuit_add(t41, in23);
    let t45 = circuit_mul(t39, t44);
    let t46 = circuit_add(t40, in240);
    let t47 = circuit_sub(t41, in240);
    let t48 = circuit_add(t46, in24);
    let t49 = circuit_mul(t43, t48);
    let t50 = circuit_add(t47, in24);
    let t51 = circuit_mul(t45, t50);
    let t52 = circuit_add(t46, in240);
    let t53 = circuit_sub(t47, in240);
    let t54 = circuit_add(t52, in25);
    let t55 = circuit_mul(t49, t54);
    let t56 = circuit_add(t53, in25);
    let t57 = circuit_mul(t51, t56);
    let t58 = circuit_add(t52, in240);
    let t59 = circuit_sub(t53, in240);
    let t60 = circuit_add(t58, in26);
    let t61 = circuit_mul(t55, t60);
    let t62 = circuit_add(t59, in26);
    let t63 = circuit_mul(t57, t62);
    let t64 = circuit_add(t58, in240);
    let t65 = circuit_sub(t59, in240);
    let t66 = circuit_add(t64, in27);
    let t67 = circuit_mul(t61, t66);
    let t68 = circuit_add(t65, in27);
    let t69 = circuit_mul(t63, t68);
    let t70 = circuit_inverse(t69);
    let t71 = circuit_mul(t67, t70);
    let t72 = circuit_mul(in238, in238);
    let t73 = circuit_mul(t72, in238);
    let t74 = circuit_mul(in244, in28);
    let t75 = circuit_add(in29, in30);
    let t76 = circuit_sub(t75, t74);
    let t77 = circuit_mul(t76, in242);
    let t78 = circuit_sub(in220, in8);
    let t79 = circuit_mul(in1, t78);
    let t80 = circuit_sub(in220, in8);
    let t81 = circuit_mul(in3, t80);
    let t82 = circuit_inverse(t81);
    let t83 = circuit_mul(in29, t82);
    let t84 = circuit_add(in8, t83);
    let t85 = circuit_sub(in220, in1);
    let t86 = circuit_mul(t79, t85);
    let t87 = circuit_sub(in220, in1);
    let t88 = circuit_mul(in4, t87);
    let t89 = circuit_inverse(t88);
    let t90 = circuit_mul(in30, t89);
    let t91 = circuit_add(t84, t90);
    let t92 = circuit_sub(in220, in9);
    let t93 = circuit_mul(t86, t92);
    let t94 = circuit_sub(in220, in9);
    let t95 = circuit_mul(in5, t94);
    let t96 = circuit_inverse(t95);
    let t97 = circuit_mul(in31, t96);
    let t98 = circuit_add(t91, t97);
    let t99 = circuit_sub(in220, in10);
    let t100 = circuit_mul(t93, t99);
    let t101 = circuit_sub(in220, in10);
    let t102 = circuit_mul(in6, t101);
    let t103 = circuit_inverse(t102);
    let t104 = circuit_mul(in32, t103);
    let t105 = circuit_add(t98, t104);
    let t106 = circuit_sub(in220, in11);
    let t107 = circuit_mul(t100, t106);
    let t108 = circuit_sub(in220, in11);
    let t109 = circuit_mul(in7, t108);
    let t110 = circuit_inverse(t109);
    let t111 = circuit_mul(in33, t110);
    let t112 = circuit_add(t105, t111);
    let t113 = circuit_sub(in220, in0);
    let t114 = circuit_mul(t107, t113);
    let t115 = circuit_sub(in220, in0);
    let t116 = circuit_mul(in6, t115);
    let t117 = circuit_inverse(t116);
    let t118 = circuit_mul(in34, t117);
    let t119 = circuit_add(t112, t118);
    let t120 = circuit_sub(in220, in12);
    let t121 = circuit_mul(t114, t120);
    let t122 = circuit_sub(in220, in12);
    let t123 = circuit_mul(in5, t122);
    let t124 = circuit_inverse(t123);
    let t125 = circuit_mul(in35, t124);
    let t126 = circuit_add(t119, t125);
    let t127 = circuit_sub(in220, in13);
    let t128 = circuit_mul(t121, t127);
    let t129 = circuit_sub(in220, in13);
    let t130 = circuit_mul(in4, t129);
    let t131 = circuit_inverse(t130);
    let t132 = circuit_mul(in36, t131);
    let t133 = circuit_add(t126, t132);
    let t134 = circuit_sub(in220, in14);
    let t135 = circuit_mul(t128, t134);
    let t136 = circuit_sub(in220, in14);
    let t137 = circuit_mul(in3, t136);
    let t138 = circuit_inverse(t137);
    let t139 = circuit_mul(in37, t138);
    let t140 = circuit_add(t133, t139);
    let t141 = circuit_mul(t140, t135);
    let t142 = circuit_sub(in237, in1);
    let t143 = circuit_mul(in220, t142);
    let t144 = circuit_add(in1, t143);
    let t145 = circuit_mul(in1, t144);
    let t146 = circuit_mul(in242, in242);
    let t147 = circuit_mul(in237, in237);
    let t148 = circuit_add(in38, in39);
    let t149 = circuit_sub(t148, t141);
    let t150 = circuit_mul(t149, t146);
    let t151 = circuit_add(t77, t150);
    let t152 = circuit_sub(in221, in8);
    let t153 = circuit_mul(in1, t152);
    let t154 = circuit_sub(in221, in8);
    let t155 = circuit_mul(in3, t154);
    let t156 = circuit_inverse(t155);
    let t157 = circuit_mul(in38, t156);
    let t158 = circuit_add(in8, t157);
    let t159 = circuit_sub(in221, in1);
    let t160 = circuit_mul(t153, t159);
    let t161 = circuit_sub(in221, in1);
    let t162 = circuit_mul(in4, t161);
    let t163 = circuit_inverse(t162);
    let t164 = circuit_mul(in39, t163);
    let t165 = circuit_add(t158, t164);
    let t166 = circuit_sub(in221, in9);
    let t167 = circuit_mul(t160, t166);
    let t168 = circuit_sub(in221, in9);
    let t169 = circuit_mul(in5, t168);
    let t170 = circuit_inverse(t169);
    let t171 = circuit_mul(in40, t170);
    let t172 = circuit_add(t165, t171);
    let t173 = circuit_sub(in221, in10);
    let t174 = circuit_mul(t167, t173);
    let t175 = circuit_sub(in221, in10);
    let t176 = circuit_mul(in6, t175);
    let t177 = circuit_inverse(t176);
    let t178 = circuit_mul(in41, t177);
    let t179 = circuit_add(t172, t178);
    let t180 = circuit_sub(in221, in11);
    let t181 = circuit_mul(t174, t180);
    let t182 = circuit_sub(in221, in11);
    let t183 = circuit_mul(in7, t182);
    let t184 = circuit_inverse(t183);
    let t185 = circuit_mul(in42, t184);
    let t186 = circuit_add(t179, t185);
    let t187 = circuit_sub(in221, in0);
    let t188 = circuit_mul(t181, t187);
    let t189 = circuit_sub(in221, in0);
    let t190 = circuit_mul(in6, t189);
    let t191 = circuit_inverse(t190);
    let t192 = circuit_mul(in43, t191);
    let t193 = circuit_add(t186, t192);
    let t194 = circuit_sub(in221, in12);
    let t195 = circuit_mul(t188, t194);
    let t196 = circuit_sub(in221, in12);
    let t197 = circuit_mul(in5, t196);
    let t198 = circuit_inverse(t197);
    let t199 = circuit_mul(in44, t198);
    let t200 = circuit_add(t193, t199);
    let t201 = circuit_sub(in221, in13);
    let t202 = circuit_mul(t195, t201);
    let t203 = circuit_sub(in221, in13);
    let t204 = circuit_mul(in4, t203);
    let t205 = circuit_inverse(t204);
    let t206 = circuit_mul(in45, t205);
    let t207 = circuit_add(t200, t206);
    let t208 = circuit_sub(in221, in14);
    let t209 = circuit_mul(t202, t208);
    let t210 = circuit_sub(in221, in14);
    let t211 = circuit_mul(in3, t210);
    let t212 = circuit_inverse(t211);
    let t213 = circuit_mul(in46, t212);
    let t214 = circuit_add(t207, t213);
    let t215 = circuit_mul(t214, t209);
    let t216 = circuit_sub(t147, in1);
    let t217 = circuit_mul(in221, t216);
    let t218 = circuit_add(in1, t217);
    let t219 = circuit_mul(t145, t218);
    let t220 = circuit_mul(t146, in242);
    let t221 = circuit_mul(t147, t147);
    let t222 = circuit_add(in47, in48);
    let t223 = circuit_sub(t222, t215);
    let t224 = circuit_mul(t223, t220);
    let t225 = circuit_add(t151, t224);
    let t226 = circuit_sub(in222, in8);
    let t227 = circuit_mul(in1, t226);
    let t228 = circuit_sub(in222, in8);
    let t229 = circuit_mul(in3, t228);
    let t230 = circuit_inverse(t229);
    let t231 = circuit_mul(in47, t230);
    let t232 = circuit_add(in8, t231);
    let t233 = circuit_sub(in222, in1);
    let t234 = circuit_mul(t227, t233);
    let t235 = circuit_sub(in222, in1);
    let t236 = circuit_mul(in4, t235);
    let t237 = circuit_inverse(t236);
    let t238 = circuit_mul(in48, t237);
    let t239 = circuit_add(t232, t238);
    let t240 = circuit_sub(in222, in9);
    let t241 = circuit_mul(t234, t240);
    let t242 = circuit_sub(in222, in9);
    let t243 = circuit_mul(in5, t242);
    let t244 = circuit_inverse(t243);
    let t245 = circuit_mul(in49, t244);
    let t246 = circuit_add(t239, t245);
    let t247 = circuit_sub(in222, in10);
    let t248 = circuit_mul(t241, t247);
    let t249 = circuit_sub(in222, in10);
    let t250 = circuit_mul(in6, t249);
    let t251 = circuit_inverse(t250);
    let t252 = circuit_mul(in50, t251);
    let t253 = circuit_add(t246, t252);
    let t254 = circuit_sub(in222, in11);
    let t255 = circuit_mul(t248, t254);
    let t256 = circuit_sub(in222, in11);
    let t257 = circuit_mul(in7, t256);
    let t258 = circuit_inverse(t257);
    let t259 = circuit_mul(in51, t258);
    let t260 = circuit_add(t253, t259);
    let t261 = circuit_sub(in222, in0);
    let t262 = circuit_mul(t255, t261);
    let t263 = circuit_sub(in222, in0);
    let t264 = circuit_mul(in6, t263);
    let t265 = circuit_inverse(t264);
    let t266 = circuit_mul(in52, t265);
    let t267 = circuit_add(t260, t266);
    let t268 = circuit_sub(in222, in12);
    let t269 = circuit_mul(t262, t268);
    let t270 = circuit_sub(in222, in12);
    let t271 = circuit_mul(in5, t270);
    let t272 = circuit_inverse(t271);
    let t273 = circuit_mul(in53, t272);
    let t274 = circuit_add(t267, t273);
    let t275 = circuit_sub(in222, in13);
    let t276 = circuit_mul(t269, t275);
    let t277 = circuit_sub(in222, in13);
    let t278 = circuit_mul(in4, t277);
    let t279 = circuit_inverse(t278);
    let t280 = circuit_mul(in54, t279);
    let t281 = circuit_add(t274, t280);
    let t282 = circuit_sub(in222, in14);
    let t283 = circuit_mul(t276, t282);
    let t284 = circuit_sub(in222, in14);
    let t285 = circuit_mul(in3, t284);
    let t286 = circuit_inverse(t285);
    let t287 = circuit_mul(in55, t286);
    let t288 = circuit_add(t281, t287);
    let t289 = circuit_mul(t288, t283);
    let t290 = circuit_sub(t221, in1);
    let t291 = circuit_mul(in222, t290);
    let t292 = circuit_add(in1, t291);
    let t293 = circuit_mul(t219, t292);
    let t294 = circuit_mul(t220, in242);
    let t295 = circuit_mul(t221, t221);
    let t296 = circuit_add(in56, in57);
    let t297 = circuit_sub(t296, t289);
    let t298 = circuit_mul(t297, t294);
    let t299 = circuit_add(t225, t298);
    let t300 = circuit_sub(in223, in8);
    let t301 = circuit_mul(in1, t300);
    let t302 = circuit_sub(in223, in8);
    let t303 = circuit_mul(in3, t302);
    let t304 = circuit_inverse(t303);
    let t305 = circuit_mul(in56, t304);
    let t306 = circuit_add(in8, t305);
    let t307 = circuit_sub(in223, in1);
    let t308 = circuit_mul(t301, t307);
    let t309 = circuit_sub(in223, in1);
    let t310 = circuit_mul(in4, t309);
    let t311 = circuit_inverse(t310);
    let t312 = circuit_mul(in57, t311);
    let t313 = circuit_add(t306, t312);
    let t314 = circuit_sub(in223, in9);
    let t315 = circuit_mul(t308, t314);
    let t316 = circuit_sub(in223, in9);
    let t317 = circuit_mul(in5, t316);
    let t318 = circuit_inverse(t317);
    let t319 = circuit_mul(in58, t318);
    let t320 = circuit_add(t313, t319);
    let t321 = circuit_sub(in223, in10);
    let t322 = circuit_mul(t315, t321);
    let t323 = circuit_sub(in223, in10);
    let t324 = circuit_mul(in6, t323);
    let t325 = circuit_inverse(t324);
    let t326 = circuit_mul(in59, t325);
    let t327 = circuit_add(t320, t326);
    let t328 = circuit_sub(in223, in11);
    let t329 = circuit_mul(t322, t328);
    let t330 = circuit_sub(in223, in11);
    let t331 = circuit_mul(in7, t330);
    let t332 = circuit_inverse(t331);
    let t333 = circuit_mul(in60, t332);
    let t334 = circuit_add(t327, t333);
    let t335 = circuit_sub(in223, in0);
    let t336 = circuit_mul(t329, t335);
    let t337 = circuit_sub(in223, in0);
    let t338 = circuit_mul(in6, t337);
    let t339 = circuit_inverse(t338);
    let t340 = circuit_mul(in61, t339);
    let t341 = circuit_add(t334, t340);
    let t342 = circuit_sub(in223, in12);
    let t343 = circuit_mul(t336, t342);
    let t344 = circuit_sub(in223, in12);
    let t345 = circuit_mul(in5, t344);
    let t346 = circuit_inverse(t345);
    let t347 = circuit_mul(in62, t346);
    let t348 = circuit_add(t341, t347);
    let t349 = circuit_sub(in223, in13);
    let t350 = circuit_mul(t343, t349);
    let t351 = circuit_sub(in223, in13);
    let t352 = circuit_mul(in4, t351);
    let t353 = circuit_inverse(t352);
    let t354 = circuit_mul(in63, t353);
    let t355 = circuit_add(t348, t354);
    let t356 = circuit_sub(in223, in14);
    let t357 = circuit_mul(t350, t356);
    let t358 = circuit_sub(in223, in14);
    let t359 = circuit_mul(in3, t358);
    let t360 = circuit_inverse(t359);
    let t361 = circuit_mul(in64, t360);
    let t362 = circuit_add(t355, t361);
    let t363 = circuit_mul(t362, t357);
    let t364 = circuit_sub(t295, in1);
    let t365 = circuit_mul(in223, t364);
    let t366 = circuit_add(in1, t365);
    let t367 = circuit_mul(t293, t366);
    let t368 = circuit_mul(t294, in242);
    let t369 = circuit_mul(t295, t295);
    let t370 = circuit_add(in65, in66);
    let t371 = circuit_sub(t370, t363);
    let t372 = circuit_mul(t371, t368);
    let t373 = circuit_add(t299, t372);
    let t374 = circuit_sub(in224, in8);
    let t375 = circuit_mul(in1, t374);
    let t376 = circuit_sub(in224, in8);
    let t377 = circuit_mul(in3, t376);
    let t378 = circuit_inverse(t377);
    let t379 = circuit_mul(in65, t378);
    let t380 = circuit_add(in8, t379);
    let t381 = circuit_sub(in224, in1);
    let t382 = circuit_mul(t375, t381);
    let t383 = circuit_sub(in224, in1);
    let t384 = circuit_mul(in4, t383);
    let t385 = circuit_inverse(t384);
    let t386 = circuit_mul(in66, t385);
    let t387 = circuit_add(t380, t386);
    let t388 = circuit_sub(in224, in9);
    let t389 = circuit_mul(t382, t388);
    let t390 = circuit_sub(in224, in9);
    let t391 = circuit_mul(in5, t390);
    let t392 = circuit_inverse(t391);
    let t393 = circuit_mul(in67, t392);
    let t394 = circuit_add(t387, t393);
    let t395 = circuit_sub(in224, in10);
    let t396 = circuit_mul(t389, t395);
    let t397 = circuit_sub(in224, in10);
    let t398 = circuit_mul(in6, t397);
    let t399 = circuit_inverse(t398);
    let t400 = circuit_mul(in68, t399);
    let t401 = circuit_add(t394, t400);
    let t402 = circuit_sub(in224, in11);
    let t403 = circuit_mul(t396, t402);
    let t404 = circuit_sub(in224, in11);
    let t405 = circuit_mul(in7, t404);
    let t406 = circuit_inverse(t405);
    let t407 = circuit_mul(in69, t406);
    let t408 = circuit_add(t401, t407);
    let t409 = circuit_sub(in224, in0);
    let t410 = circuit_mul(t403, t409);
    let t411 = circuit_sub(in224, in0);
    let t412 = circuit_mul(in6, t411);
    let t413 = circuit_inverse(t412);
    let t414 = circuit_mul(in70, t413);
    let t415 = circuit_add(t408, t414);
    let t416 = circuit_sub(in224, in12);
    let t417 = circuit_mul(t410, t416);
    let t418 = circuit_sub(in224, in12);
    let t419 = circuit_mul(in5, t418);
    let t420 = circuit_inverse(t419);
    let t421 = circuit_mul(in71, t420);
    let t422 = circuit_add(t415, t421);
    let t423 = circuit_sub(in224, in13);
    let t424 = circuit_mul(t417, t423);
    let t425 = circuit_sub(in224, in13);
    let t426 = circuit_mul(in4, t425);
    let t427 = circuit_inverse(t426);
    let t428 = circuit_mul(in72, t427);
    let t429 = circuit_add(t422, t428);
    let t430 = circuit_sub(in224, in14);
    let t431 = circuit_mul(t424, t430);
    let t432 = circuit_sub(in224, in14);
    let t433 = circuit_mul(in3, t432);
    let t434 = circuit_inverse(t433);
    let t435 = circuit_mul(in73, t434);
    let t436 = circuit_add(t429, t435);
    let t437 = circuit_mul(t436, t431);
    let t438 = circuit_sub(t369, in1);
    let t439 = circuit_mul(in224, t438);
    let t440 = circuit_add(in1, t439);
    let t441 = circuit_mul(t367, t440);
    let t442 = circuit_mul(t368, in242);
    let t443 = circuit_mul(t369, t369);
    let t444 = circuit_add(in74, in75);
    let t445 = circuit_sub(t444, t437);
    let t446 = circuit_mul(t445, t442);
    let t447 = circuit_add(t373, t446);
    let t448 = circuit_sub(in225, in8);
    let t449 = circuit_mul(in1, t448);
    let t450 = circuit_sub(in225, in8);
    let t451 = circuit_mul(in3, t450);
    let t452 = circuit_inverse(t451);
    let t453 = circuit_mul(in74, t452);
    let t454 = circuit_add(in8, t453);
    let t455 = circuit_sub(in225, in1);
    let t456 = circuit_mul(t449, t455);
    let t457 = circuit_sub(in225, in1);
    let t458 = circuit_mul(in4, t457);
    let t459 = circuit_inverse(t458);
    let t460 = circuit_mul(in75, t459);
    let t461 = circuit_add(t454, t460);
    let t462 = circuit_sub(in225, in9);
    let t463 = circuit_mul(t456, t462);
    let t464 = circuit_sub(in225, in9);
    let t465 = circuit_mul(in5, t464);
    let t466 = circuit_inverse(t465);
    let t467 = circuit_mul(in76, t466);
    let t468 = circuit_add(t461, t467);
    let t469 = circuit_sub(in225, in10);
    let t470 = circuit_mul(t463, t469);
    let t471 = circuit_sub(in225, in10);
    let t472 = circuit_mul(in6, t471);
    let t473 = circuit_inverse(t472);
    let t474 = circuit_mul(in77, t473);
    let t475 = circuit_add(t468, t474);
    let t476 = circuit_sub(in225, in11);
    let t477 = circuit_mul(t470, t476);
    let t478 = circuit_sub(in225, in11);
    let t479 = circuit_mul(in7, t478);
    let t480 = circuit_inverse(t479);
    let t481 = circuit_mul(in78, t480);
    let t482 = circuit_add(t475, t481);
    let t483 = circuit_sub(in225, in0);
    let t484 = circuit_mul(t477, t483);
    let t485 = circuit_sub(in225, in0);
    let t486 = circuit_mul(in6, t485);
    let t487 = circuit_inverse(t486);
    let t488 = circuit_mul(in79, t487);
    let t489 = circuit_add(t482, t488);
    let t490 = circuit_sub(in225, in12);
    let t491 = circuit_mul(t484, t490);
    let t492 = circuit_sub(in225, in12);
    let t493 = circuit_mul(in5, t492);
    let t494 = circuit_inverse(t493);
    let t495 = circuit_mul(in80, t494);
    let t496 = circuit_add(t489, t495);
    let t497 = circuit_sub(in225, in13);
    let t498 = circuit_mul(t491, t497);
    let t499 = circuit_sub(in225, in13);
    let t500 = circuit_mul(in4, t499);
    let t501 = circuit_inverse(t500);
    let t502 = circuit_mul(in81, t501);
    let t503 = circuit_add(t496, t502);
    let t504 = circuit_sub(in225, in14);
    let t505 = circuit_mul(t498, t504);
    let t506 = circuit_sub(in225, in14);
    let t507 = circuit_mul(in3, t506);
    let t508 = circuit_inverse(t507);
    let t509 = circuit_mul(in82, t508);
    let t510 = circuit_add(t503, t509);
    let t511 = circuit_mul(t510, t505);
    let t512 = circuit_sub(t443, in1);
    let t513 = circuit_mul(in225, t512);
    let t514 = circuit_add(in1, t513);
    let t515 = circuit_mul(t441, t514);
    let t516 = circuit_mul(t442, in242);
    let t517 = circuit_mul(t443, t443);
    let t518 = circuit_add(in83, in84);
    let t519 = circuit_sub(t518, t511);
    let t520 = circuit_mul(t519, t516);
    let t521 = circuit_add(t447, t520);
    let t522 = circuit_sub(in226, in8);
    let t523 = circuit_mul(in1, t522);
    let t524 = circuit_sub(in226, in8);
    let t525 = circuit_mul(in3, t524);
    let t526 = circuit_inverse(t525);
    let t527 = circuit_mul(in83, t526);
    let t528 = circuit_add(in8, t527);
    let t529 = circuit_sub(in226, in1);
    let t530 = circuit_mul(t523, t529);
    let t531 = circuit_sub(in226, in1);
    let t532 = circuit_mul(in4, t531);
    let t533 = circuit_inverse(t532);
    let t534 = circuit_mul(in84, t533);
    let t535 = circuit_add(t528, t534);
    let t536 = circuit_sub(in226, in9);
    let t537 = circuit_mul(t530, t536);
    let t538 = circuit_sub(in226, in9);
    let t539 = circuit_mul(in5, t538);
    let t540 = circuit_inverse(t539);
    let t541 = circuit_mul(in85, t540);
    let t542 = circuit_add(t535, t541);
    let t543 = circuit_sub(in226, in10);
    let t544 = circuit_mul(t537, t543);
    let t545 = circuit_sub(in226, in10);
    let t546 = circuit_mul(in6, t545);
    let t547 = circuit_inverse(t546);
    let t548 = circuit_mul(in86, t547);
    let t549 = circuit_add(t542, t548);
    let t550 = circuit_sub(in226, in11);
    let t551 = circuit_mul(t544, t550);
    let t552 = circuit_sub(in226, in11);
    let t553 = circuit_mul(in7, t552);
    let t554 = circuit_inverse(t553);
    let t555 = circuit_mul(in87, t554);
    let t556 = circuit_add(t549, t555);
    let t557 = circuit_sub(in226, in0);
    let t558 = circuit_mul(t551, t557);
    let t559 = circuit_sub(in226, in0);
    let t560 = circuit_mul(in6, t559);
    let t561 = circuit_inverse(t560);
    let t562 = circuit_mul(in88, t561);
    let t563 = circuit_add(t556, t562);
    let t564 = circuit_sub(in226, in12);
    let t565 = circuit_mul(t558, t564);
    let t566 = circuit_sub(in226, in12);
    let t567 = circuit_mul(in5, t566);
    let t568 = circuit_inverse(t567);
    let t569 = circuit_mul(in89, t568);
    let t570 = circuit_add(t563, t569);
    let t571 = circuit_sub(in226, in13);
    let t572 = circuit_mul(t565, t571);
    let t573 = circuit_sub(in226, in13);
    let t574 = circuit_mul(in4, t573);
    let t575 = circuit_inverse(t574);
    let t576 = circuit_mul(in90, t575);
    let t577 = circuit_add(t570, t576);
    let t578 = circuit_sub(in226, in14);
    let t579 = circuit_mul(t572, t578);
    let t580 = circuit_sub(in226, in14);
    let t581 = circuit_mul(in3, t580);
    let t582 = circuit_inverse(t581);
    let t583 = circuit_mul(in91, t582);
    let t584 = circuit_add(t577, t583);
    let t585 = circuit_mul(t584, t579);
    let t586 = circuit_sub(t517, in1);
    let t587 = circuit_mul(in226, t586);
    let t588 = circuit_add(in1, t587);
    let t589 = circuit_mul(t515, t588);
    let t590 = circuit_mul(t516, in242);
    let t591 = circuit_mul(t517, t517);
    let t592 = circuit_add(in92, in93);
    let t593 = circuit_sub(t592, t585);
    let t594 = circuit_mul(t593, t590);
    let t595 = circuit_add(t521, t594);
    let t596 = circuit_sub(in227, in8);
    let t597 = circuit_mul(in1, t596);
    let t598 = circuit_sub(in227, in8);
    let t599 = circuit_mul(in3, t598);
    let t600 = circuit_inverse(t599);
    let t601 = circuit_mul(in92, t600);
    let t602 = circuit_add(in8, t601);
    let t603 = circuit_sub(in227, in1);
    let t604 = circuit_mul(t597, t603);
    let t605 = circuit_sub(in227, in1);
    let t606 = circuit_mul(in4, t605);
    let t607 = circuit_inverse(t606);
    let t608 = circuit_mul(in93, t607);
    let t609 = circuit_add(t602, t608);
    let t610 = circuit_sub(in227, in9);
    let t611 = circuit_mul(t604, t610);
    let t612 = circuit_sub(in227, in9);
    let t613 = circuit_mul(in5, t612);
    let t614 = circuit_inverse(t613);
    let t615 = circuit_mul(in94, t614);
    let t616 = circuit_add(t609, t615);
    let t617 = circuit_sub(in227, in10);
    let t618 = circuit_mul(t611, t617);
    let t619 = circuit_sub(in227, in10);
    let t620 = circuit_mul(in6, t619);
    let t621 = circuit_inverse(t620);
    let t622 = circuit_mul(in95, t621);
    let t623 = circuit_add(t616, t622);
    let t624 = circuit_sub(in227, in11);
    let t625 = circuit_mul(t618, t624);
    let t626 = circuit_sub(in227, in11);
    let t627 = circuit_mul(in7, t626);
    let t628 = circuit_inverse(t627);
    let t629 = circuit_mul(in96, t628);
    let t630 = circuit_add(t623, t629);
    let t631 = circuit_sub(in227, in0);
    let t632 = circuit_mul(t625, t631);
    let t633 = circuit_sub(in227, in0);
    let t634 = circuit_mul(in6, t633);
    let t635 = circuit_inverse(t634);
    let t636 = circuit_mul(in97, t635);
    let t637 = circuit_add(t630, t636);
    let t638 = circuit_sub(in227, in12);
    let t639 = circuit_mul(t632, t638);
    let t640 = circuit_sub(in227, in12);
    let t641 = circuit_mul(in5, t640);
    let t642 = circuit_inverse(t641);
    let t643 = circuit_mul(in98, t642);
    let t644 = circuit_add(t637, t643);
    let t645 = circuit_sub(in227, in13);
    let t646 = circuit_mul(t639, t645);
    let t647 = circuit_sub(in227, in13);
    let t648 = circuit_mul(in4, t647);
    let t649 = circuit_inverse(t648);
    let t650 = circuit_mul(in99, t649);
    let t651 = circuit_add(t644, t650);
    let t652 = circuit_sub(in227, in14);
    let t653 = circuit_mul(t646, t652);
    let t654 = circuit_sub(in227, in14);
    let t655 = circuit_mul(in3, t654);
    let t656 = circuit_inverse(t655);
    let t657 = circuit_mul(in100, t656);
    let t658 = circuit_add(t651, t657);
    let t659 = circuit_mul(t658, t653);
    let t660 = circuit_sub(t591, in1);
    let t661 = circuit_mul(in227, t660);
    let t662 = circuit_add(in1, t661);
    let t663 = circuit_mul(t589, t662);
    let t664 = circuit_mul(t590, in242);
    let t665 = circuit_mul(t591, t591);
    let t666 = circuit_add(in101, in102);
    let t667 = circuit_sub(t666, t659);
    let t668 = circuit_mul(t667, t664);
    let t669 = circuit_add(t595, t668);
    let t670 = circuit_sub(in228, in8);
    let t671 = circuit_mul(in1, t670);
    let t672 = circuit_sub(in228, in8);
    let t673 = circuit_mul(in3, t672);
    let t674 = circuit_inverse(t673);
    let t675 = circuit_mul(in101, t674);
    let t676 = circuit_add(in8, t675);
    let t677 = circuit_sub(in228, in1);
    let t678 = circuit_mul(t671, t677);
    let t679 = circuit_sub(in228, in1);
    let t680 = circuit_mul(in4, t679);
    let t681 = circuit_inverse(t680);
    let t682 = circuit_mul(in102, t681);
    let t683 = circuit_add(t676, t682);
    let t684 = circuit_sub(in228, in9);
    let t685 = circuit_mul(t678, t684);
    let t686 = circuit_sub(in228, in9);
    let t687 = circuit_mul(in5, t686);
    let t688 = circuit_inverse(t687);
    let t689 = circuit_mul(in103, t688);
    let t690 = circuit_add(t683, t689);
    let t691 = circuit_sub(in228, in10);
    let t692 = circuit_mul(t685, t691);
    let t693 = circuit_sub(in228, in10);
    let t694 = circuit_mul(in6, t693);
    let t695 = circuit_inverse(t694);
    let t696 = circuit_mul(in104, t695);
    let t697 = circuit_add(t690, t696);
    let t698 = circuit_sub(in228, in11);
    let t699 = circuit_mul(t692, t698);
    let t700 = circuit_sub(in228, in11);
    let t701 = circuit_mul(in7, t700);
    let t702 = circuit_inverse(t701);
    let t703 = circuit_mul(in105, t702);
    let t704 = circuit_add(t697, t703);
    let t705 = circuit_sub(in228, in0);
    let t706 = circuit_mul(t699, t705);
    let t707 = circuit_sub(in228, in0);
    let t708 = circuit_mul(in6, t707);
    let t709 = circuit_inverse(t708);
    let t710 = circuit_mul(in106, t709);
    let t711 = circuit_add(t704, t710);
    let t712 = circuit_sub(in228, in12);
    let t713 = circuit_mul(t706, t712);
    let t714 = circuit_sub(in228, in12);
    let t715 = circuit_mul(in5, t714);
    let t716 = circuit_inverse(t715);
    let t717 = circuit_mul(in107, t716);
    let t718 = circuit_add(t711, t717);
    let t719 = circuit_sub(in228, in13);
    let t720 = circuit_mul(t713, t719);
    let t721 = circuit_sub(in228, in13);
    let t722 = circuit_mul(in4, t721);
    let t723 = circuit_inverse(t722);
    let t724 = circuit_mul(in108, t723);
    let t725 = circuit_add(t718, t724);
    let t726 = circuit_sub(in228, in14);
    let t727 = circuit_mul(t720, t726);
    let t728 = circuit_sub(in228, in14);
    let t729 = circuit_mul(in3, t728);
    let t730 = circuit_inverse(t729);
    let t731 = circuit_mul(in109, t730);
    let t732 = circuit_add(t725, t731);
    let t733 = circuit_mul(t732, t727);
    let t734 = circuit_sub(t665, in1);
    let t735 = circuit_mul(in228, t734);
    let t736 = circuit_add(in1, t735);
    let t737 = circuit_mul(t663, t736);
    let t738 = circuit_mul(t664, in242);
    let t739 = circuit_mul(t665, t665);
    let t740 = circuit_add(in110, in111);
    let t741 = circuit_sub(t740, t733);
    let t742 = circuit_mul(t741, t738);
    let t743 = circuit_add(t669, t742);
    let t744 = circuit_sub(in229, in8);
    let t745 = circuit_mul(in1, t744);
    let t746 = circuit_sub(in229, in8);
    let t747 = circuit_mul(in3, t746);
    let t748 = circuit_inverse(t747);
    let t749 = circuit_mul(in110, t748);
    let t750 = circuit_add(in8, t749);
    let t751 = circuit_sub(in229, in1);
    let t752 = circuit_mul(t745, t751);
    let t753 = circuit_sub(in229, in1);
    let t754 = circuit_mul(in4, t753);
    let t755 = circuit_inverse(t754);
    let t756 = circuit_mul(in111, t755);
    let t757 = circuit_add(t750, t756);
    let t758 = circuit_sub(in229, in9);
    let t759 = circuit_mul(t752, t758);
    let t760 = circuit_sub(in229, in9);
    let t761 = circuit_mul(in5, t760);
    let t762 = circuit_inverse(t761);
    let t763 = circuit_mul(in112, t762);
    let t764 = circuit_add(t757, t763);
    let t765 = circuit_sub(in229, in10);
    let t766 = circuit_mul(t759, t765);
    let t767 = circuit_sub(in229, in10);
    let t768 = circuit_mul(in6, t767);
    let t769 = circuit_inverse(t768);
    let t770 = circuit_mul(in113, t769);
    let t771 = circuit_add(t764, t770);
    let t772 = circuit_sub(in229, in11);
    let t773 = circuit_mul(t766, t772);
    let t774 = circuit_sub(in229, in11);
    let t775 = circuit_mul(in7, t774);
    let t776 = circuit_inverse(t775);
    let t777 = circuit_mul(in114, t776);
    let t778 = circuit_add(t771, t777);
    let t779 = circuit_sub(in229, in0);
    let t780 = circuit_mul(t773, t779);
    let t781 = circuit_sub(in229, in0);
    let t782 = circuit_mul(in6, t781);
    let t783 = circuit_inverse(t782);
    let t784 = circuit_mul(in115, t783);
    let t785 = circuit_add(t778, t784);
    let t786 = circuit_sub(in229, in12);
    let t787 = circuit_mul(t780, t786);
    let t788 = circuit_sub(in229, in12);
    let t789 = circuit_mul(in5, t788);
    let t790 = circuit_inverse(t789);
    let t791 = circuit_mul(in116, t790);
    let t792 = circuit_add(t785, t791);
    let t793 = circuit_sub(in229, in13);
    let t794 = circuit_mul(t787, t793);
    let t795 = circuit_sub(in229, in13);
    let t796 = circuit_mul(in4, t795);
    let t797 = circuit_inverse(t796);
    let t798 = circuit_mul(in117, t797);
    let t799 = circuit_add(t792, t798);
    let t800 = circuit_sub(in229, in14);
    let t801 = circuit_mul(t794, t800);
    let t802 = circuit_sub(in229, in14);
    let t803 = circuit_mul(in3, t802);
    let t804 = circuit_inverse(t803);
    let t805 = circuit_mul(in118, t804);
    let t806 = circuit_add(t799, t805);
    let t807 = circuit_mul(t806, t801);
    let t808 = circuit_sub(t739, in1);
    let t809 = circuit_mul(in229, t808);
    let t810 = circuit_add(in1, t809);
    let t811 = circuit_mul(t737, t810);
    let t812 = circuit_mul(t738, in242);
    let t813 = circuit_mul(t739, t739);
    let t814 = circuit_add(in119, in120);
    let t815 = circuit_sub(t814, t807);
    let t816 = circuit_mul(t815, t812);
    let t817 = circuit_add(t743, t816);
    let t818 = circuit_sub(in230, in8);
    let t819 = circuit_mul(in1, t818);
    let t820 = circuit_sub(in230, in8);
    let t821 = circuit_mul(in3, t820);
    let t822 = circuit_inverse(t821);
    let t823 = circuit_mul(in119, t822);
    let t824 = circuit_add(in8, t823);
    let t825 = circuit_sub(in230, in1);
    let t826 = circuit_mul(t819, t825);
    let t827 = circuit_sub(in230, in1);
    let t828 = circuit_mul(in4, t827);
    let t829 = circuit_inverse(t828);
    let t830 = circuit_mul(in120, t829);
    let t831 = circuit_add(t824, t830);
    let t832 = circuit_sub(in230, in9);
    let t833 = circuit_mul(t826, t832);
    let t834 = circuit_sub(in230, in9);
    let t835 = circuit_mul(in5, t834);
    let t836 = circuit_inverse(t835);
    let t837 = circuit_mul(in121, t836);
    let t838 = circuit_add(t831, t837);
    let t839 = circuit_sub(in230, in10);
    let t840 = circuit_mul(t833, t839);
    let t841 = circuit_sub(in230, in10);
    let t842 = circuit_mul(in6, t841);
    let t843 = circuit_inverse(t842);
    let t844 = circuit_mul(in122, t843);
    let t845 = circuit_add(t838, t844);
    let t846 = circuit_sub(in230, in11);
    let t847 = circuit_mul(t840, t846);
    let t848 = circuit_sub(in230, in11);
    let t849 = circuit_mul(in7, t848);
    let t850 = circuit_inverse(t849);
    let t851 = circuit_mul(in123, t850);
    let t852 = circuit_add(t845, t851);
    let t853 = circuit_sub(in230, in0);
    let t854 = circuit_mul(t847, t853);
    let t855 = circuit_sub(in230, in0);
    let t856 = circuit_mul(in6, t855);
    let t857 = circuit_inverse(t856);
    let t858 = circuit_mul(in124, t857);
    let t859 = circuit_add(t852, t858);
    let t860 = circuit_sub(in230, in12);
    let t861 = circuit_mul(t854, t860);
    let t862 = circuit_sub(in230, in12);
    let t863 = circuit_mul(in5, t862);
    let t864 = circuit_inverse(t863);
    let t865 = circuit_mul(in125, t864);
    let t866 = circuit_add(t859, t865);
    let t867 = circuit_sub(in230, in13);
    let t868 = circuit_mul(t861, t867);
    let t869 = circuit_sub(in230, in13);
    let t870 = circuit_mul(in4, t869);
    let t871 = circuit_inverse(t870);
    let t872 = circuit_mul(in126, t871);
    let t873 = circuit_add(t866, t872);
    let t874 = circuit_sub(in230, in14);
    let t875 = circuit_mul(t868, t874);
    let t876 = circuit_sub(in230, in14);
    let t877 = circuit_mul(in3, t876);
    let t878 = circuit_inverse(t877);
    let t879 = circuit_mul(in127, t878);
    let t880 = circuit_add(t873, t879);
    let t881 = circuit_mul(t880, t875);
    let t882 = circuit_sub(t813, in1);
    let t883 = circuit_mul(in230, t882);
    let t884 = circuit_add(in1, t883);
    let t885 = circuit_mul(t811, t884);
    let t886 = circuit_mul(t812, in242);
    let t887 = circuit_mul(t813, t813);
    let t888 = circuit_add(in128, in129);
    let t889 = circuit_sub(t888, t881);
    let t890 = circuit_mul(t889, t886);
    let t891 = circuit_add(t817, t890);
    let t892 = circuit_sub(in231, in8);
    let t893 = circuit_mul(in1, t892);
    let t894 = circuit_sub(in231, in8);
    let t895 = circuit_mul(in3, t894);
    let t896 = circuit_inverse(t895);
    let t897 = circuit_mul(in128, t896);
    let t898 = circuit_add(in8, t897);
    let t899 = circuit_sub(in231, in1);
    let t900 = circuit_mul(t893, t899);
    let t901 = circuit_sub(in231, in1);
    let t902 = circuit_mul(in4, t901);
    let t903 = circuit_inverse(t902);
    let t904 = circuit_mul(in129, t903);
    let t905 = circuit_add(t898, t904);
    let t906 = circuit_sub(in231, in9);
    let t907 = circuit_mul(t900, t906);
    let t908 = circuit_sub(in231, in9);
    let t909 = circuit_mul(in5, t908);
    let t910 = circuit_inverse(t909);
    let t911 = circuit_mul(in130, t910);
    let t912 = circuit_add(t905, t911);
    let t913 = circuit_sub(in231, in10);
    let t914 = circuit_mul(t907, t913);
    let t915 = circuit_sub(in231, in10);
    let t916 = circuit_mul(in6, t915);
    let t917 = circuit_inverse(t916);
    let t918 = circuit_mul(in131, t917);
    let t919 = circuit_add(t912, t918);
    let t920 = circuit_sub(in231, in11);
    let t921 = circuit_mul(t914, t920);
    let t922 = circuit_sub(in231, in11);
    let t923 = circuit_mul(in7, t922);
    let t924 = circuit_inverse(t923);
    let t925 = circuit_mul(in132, t924);
    let t926 = circuit_add(t919, t925);
    let t927 = circuit_sub(in231, in0);
    let t928 = circuit_mul(t921, t927);
    let t929 = circuit_sub(in231, in0);
    let t930 = circuit_mul(in6, t929);
    let t931 = circuit_inverse(t930);
    let t932 = circuit_mul(in133, t931);
    let t933 = circuit_add(t926, t932);
    let t934 = circuit_sub(in231, in12);
    let t935 = circuit_mul(t928, t934);
    let t936 = circuit_sub(in231, in12);
    let t937 = circuit_mul(in5, t936);
    let t938 = circuit_inverse(t937);
    let t939 = circuit_mul(in134, t938);
    let t940 = circuit_add(t933, t939);
    let t941 = circuit_sub(in231, in13);
    let t942 = circuit_mul(t935, t941);
    let t943 = circuit_sub(in231, in13);
    let t944 = circuit_mul(in4, t943);
    let t945 = circuit_inverse(t944);
    let t946 = circuit_mul(in135, t945);
    let t947 = circuit_add(t940, t946);
    let t948 = circuit_sub(in231, in14);
    let t949 = circuit_mul(t942, t948);
    let t950 = circuit_sub(in231, in14);
    let t951 = circuit_mul(in3, t950);
    let t952 = circuit_inverse(t951);
    let t953 = circuit_mul(in136, t952);
    let t954 = circuit_add(t947, t953);
    let t955 = circuit_mul(t954, t949);
    let t956 = circuit_sub(t887, in1);
    let t957 = circuit_mul(in231, t956);
    let t958 = circuit_add(in1, t957);
    let t959 = circuit_mul(t885, t958);
    let t960 = circuit_mul(t886, in242);
    let t961 = circuit_mul(t887, t887);
    let t962 = circuit_add(in137, in138);
    let t963 = circuit_sub(t962, t955);
    let t964 = circuit_mul(t963, t960);
    let t965 = circuit_add(t891, t964);
    let t966 = circuit_sub(in232, in8);
    let t967 = circuit_mul(in1, t966);
    let t968 = circuit_sub(in232, in8);
    let t969 = circuit_mul(in3, t968);
    let t970 = circuit_inverse(t969);
    let t971 = circuit_mul(in137, t970);
    let t972 = circuit_add(in8, t971);
    let t973 = circuit_sub(in232, in1);
    let t974 = circuit_mul(t967, t973);
    let t975 = circuit_sub(in232, in1);
    let t976 = circuit_mul(in4, t975);
    let t977 = circuit_inverse(t976);
    let t978 = circuit_mul(in138, t977);
    let t979 = circuit_add(t972, t978);
    let t980 = circuit_sub(in232, in9);
    let t981 = circuit_mul(t974, t980);
    let t982 = circuit_sub(in232, in9);
    let t983 = circuit_mul(in5, t982);
    let t984 = circuit_inverse(t983);
    let t985 = circuit_mul(in139, t984);
    let t986 = circuit_add(t979, t985);
    let t987 = circuit_sub(in232, in10);
    let t988 = circuit_mul(t981, t987);
    let t989 = circuit_sub(in232, in10);
    let t990 = circuit_mul(in6, t989);
    let t991 = circuit_inverse(t990);
    let t992 = circuit_mul(in140, t991);
    let t993 = circuit_add(t986, t992);
    let t994 = circuit_sub(in232, in11);
    let t995 = circuit_mul(t988, t994);
    let t996 = circuit_sub(in232, in11);
    let t997 = circuit_mul(in7, t996);
    let t998 = circuit_inverse(t997);
    let t999 = circuit_mul(in141, t998);
    let t1000 = circuit_add(t993, t999);
    let t1001 = circuit_sub(in232, in0);
    let t1002 = circuit_mul(t995, t1001);
    let t1003 = circuit_sub(in232, in0);
    let t1004 = circuit_mul(in6, t1003);
    let t1005 = circuit_inverse(t1004);
    let t1006 = circuit_mul(in142, t1005);
    let t1007 = circuit_add(t1000, t1006);
    let t1008 = circuit_sub(in232, in12);
    let t1009 = circuit_mul(t1002, t1008);
    let t1010 = circuit_sub(in232, in12);
    let t1011 = circuit_mul(in5, t1010);
    let t1012 = circuit_inverse(t1011);
    let t1013 = circuit_mul(in143, t1012);
    let t1014 = circuit_add(t1007, t1013);
    let t1015 = circuit_sub(in232, in13);
    let t1016 = circuit_mul(t1009, t1015);
    let t1017 = circuit_sub(in232, in13);
    let t1018 = circuit_mul(in4, t1017);
    let t1019 = circuit_inverse(t1018);
    let t1020 = circuit_mul(in144, t1019);
    let t1021 = circuit_add(t1014, t1020);
    let t1022 = circuit_sub(in232, in14);
    let t1023 = circuit_mul(t1016, t1022);
    let t1024 = circuit_sub(in232, in14);
    let t1025 = circuit_mul(in3, t1024);
    let t1026 = circuit_inverse(t1025);
    let t1027 = circuit_mul(in145, t1026);
    let t1028 = circuit_add(t1021, t1027);
    let t1029 = circuit_mul(t1028, t1023);
    let t1030 = circuit_sub(t961, in1);
    let t1031 = circuit_mul(in232, t1030);
    let t1032 = circuit_add(in1, t1031);
    let t1033 = circuit_mul(t959, t1032);
    let t1034 = circuit_mul(t960, in242);
    let t1035 = circuit_mul(t961, t961);
    let t1036 = circuit_add(in146, in147);
    let t1037 = circuit_sub(t1036, t1029);
    let t1038 = circuit_mul(t1037, t1034);
    let t1039 = circuit_add(t965, t1038);
    let t1040 = circuit_sub(in233, in8);
    let t1041 = circuit_mul(in1, t1040);
    let t1042 = circuit_sub(in233, in8);
    let t1043 = circuit_mul(in3, t1042);
    let t1044 = circuit_inverse(t1043);
    let t1045 = circuit_mul(in146, t1044);
    let t1046 = circuit_add(in8, t1045);
    let t1047 = circuit_sub(in233, in1);
    let t1048 = circuit_mul(t1041, t1047);
    let t1049 = circuit_sub(in233, in1);
    let t1050 = circuit_mul(in4, t1049);
    let t1051 = circuit_inverse(t1050);
    let t1052 = circuit_mul(in147, t1051);
    let t1053 = circuit_add(t1046, t1052);
    let t1054 = circuit_sub(in233, in9);
    let t1055 = circuit_mul(t1048, t1054);
    let t1056 = circuit_sub(in233, in9);
    let t1057 = circuit_mul(in5, t1056);
    let t1058 = circuit_inverse(t1057);
    let t1059 = circuit_mul(in148, t1058);
    let t1060 = circuit_add(t1053, t1059);
    let t1061 = circuit_sub(in233, in10);
    let t1062 = circuit_mul(t1055, t1061);
    let t1063 = circuit_sub(in233, in10);
    let t1064 = circuit_mul(in6, t1063);
    let t1065 = circuit_inverse(t1064);
    let t1066 = circuit_mul(in149, t1065);
    let t1067 = circuit_add(t1060, t1066);
    let t1068 = circuit_sub(in233, in11);
    let t1069 = circuit_mul(t1062, t1068);
    let t1070 = circuit_sub(in233, in11);
    let t1071 = circuit_mul(in7, t1070);
    let t1072 = circuit_inverse(t1071);
    let t1073 = circuit_mul(in150, t1072);
    let t1074 = circuit_add(t1067, t1073);
    let t1075 = circuit_sub(in233, in0);
    let t1076 = circuit_mul(t1069, t1075);
    let t1077 = circuit_sub(in233, in0);
    let t1078 = circuit_mul(in6, t1077);
    let t1079 = circuit_inverse(t1078);
    let t1080 = circuit_mul(in151, t1079);
    let t1081 = circuit_add(t1074, t1080);
    let t1082 = circuit_sub(in233, in12);
    let t1083 = circuit_mul(t1076, t1082);
    let t1084 = circuit_sub(in233, in12);
    let t1085 = circuit_mul(in5, t1084);
    let t1086 = circuit_inverse(t1085);
    let t1087 = circuit_mul(in152, t1086);
    let t1088 = circuit_add(t1081, t1087);
    let t1089 = circuit_sub(in233, in13);
    let t1090 = circuit_mul(t1083, t1089);
    let t1091 = circuit_sub(in233, in13);
    let t1092 = circuit_mul(in4, t1091);
    let t1093 = circuit_inverse(t1092);
    let t1094 = circuit_mul(in153, t1093);
    let t1095 = circuit_add(t1088, t1094);
    let t1096 = circuit_sub(in233, in14);
    let t1097 = circuit_mul(t1090, t1096);
    let t1098 = circuit_sub(in233, in14);
    let t1099 = circuit_mul(in3, t1098);
    let t1100 = circuit_inverse(t1099);
    let t1101 = circuit_mul(in154, t1100);
    let t1102 = circuit_add(t1095, t1101);
    let t1103 = circuit_mul(t1102, t1097);
    let t1104 = circuit_sub(t1035, in1);
    let t1105 = circuit_mul(in233, t1104);
    let t1106 = circuit_add(in1, t1105);
    let t1107 = circuit_mul(t1033, t1106);
    let t1108 = circuit_mul(t1034, in242);
    let t1109 = circuit_mul(t1035, t1035);
    let t1110 = circuit_add(in155, in156);
    let t1111 = circuit_sub(t1110, t1103);
    let t1112 = circuit_mul(t1111, t1108);
    let t1113 = circuit_add(t1039, t1112);
    let t1114 = circuit_sub(in234, in8);
    let t1115 = circuit_mul(in1, t1114);
    let t1116 = circuit_sub(in234, in8);
    let t1117 = circuit_mul(in3, t1116);
    let t1118 = circuit_inverse(t1117);
    let t1119 = circuit_mul(in155, t1118);
    let t1120 = circuit_add(in8, t1119);
    let t1121 = circuit_sub(in234, in1);
    let t1122 = circuit_mul(t1115, t1121);
    let t1123 = circuit_sub(in234, in1);
    let t1124 = circuit_mul(in4, t1123);
    let t1125 = circuit_inverse(t1124);
    let t1126 = circuit_mul(in156, t1125);
    let t1127 = circuit_add(t1120, t1126);
    let t1128 = circuit_sub(in234, in9);
    let t1129 = circuit_mul(t1122, t1128);
    let t1130 = circuit_sub(in234, in9);
    let t1131 = circuit_mul(in5, t1130);
    let t1132 = circuit_inverse(t1131);
    let t1133 = circuit_mul(in157, t1132);
    let t1134 = circuit_add(t1127, t1133);
    let t1135 = circuit_sub(in234, in10);
    let t1136 = circuit_mul(t1129, t1135);
    let t1137 = circuit_sub(in234, in10);
    let t1138 = circuit_mul(in6, t1137);
    let t1139 = circuit_inverse(t1138);
    let t1140 = circuit_mul(in158, t1139);
    let t1141 = circuit_add(t1134, t1140);
    let t1142 = circuit_sub(in234, in11);
    let t1143 = circuit_mul(t1136, t1142);
    let t1144 = circuit_sub(in234, in11);
    let t1145 = circuit_mul(in7, t1144);
    let t1146 = circuit_inverse(t1145);
    let t1147 = circuit_mul(in159, t1146);
    let t1148 = circuit_add(t1141, t1147);
    let t1149 = circuit_sub(in234, in0);
    let t1150 = circuit_mul(t1143, t1149);
    let t1151 = circuit_sub(in234, in0);
    let t1152 = circuit_mul(in6, t1151);
    let t1153 = circuit_inverse(t1152);
    let t1154 = circuit_mul(in160, t1153);
    let t1155 = circuit_add(t1148, t1154);
    let t1156 = circuit_sub(in234, in12);
    let t1157 = circuit_mul(t1150, t1156);
    let t1158 = circuit_sub(in234, in12);
    let t1159 = circuit_mul(in5, t1158);
    let t1160 = circuit_inverse(t1159);
    let t1161 = circuit_mul(in161, t1160);
    let t1162 = circuit_add(t1155, t1161);
    let t1163 = circuit_sub(in234, in13);
    let t1164 = circuit_mul(t1157, t1163);
    let t1165 = circuit_sub(in234, in13);
    let t1166 = circuit_mul(in4, t1165);
    let t1167 = circuit_inverse(t1166);
    let t1168 = circuit_mul(in162, t1167);
    let t1169 = circuit_add(t1162, t1168);
    let t1170 = circuit_sub(in234, in14);
    let t1171 = circuit_mul(t1164, t1170);
    let t1172 = circuit_sub(in234, in14);
    let t1173 = circuit_mul(in3, t1172);
    let t1174 = circuit_inverse(t1173);
    let t1175 = circuit_mul(in163, t1174);
    let t1176 = circuit_add(t1169, t1175);
    let t1177 = circuit_mul(t1176, t1171);
    let t1178 = circuit_sub(t1109, in1);
    let t1179 = circuit_mul(in234, t1178);
    let t1180 = circuit_add(in1, t1179);
    let t1181 = circuit_mul(t1107, t1180);
    let t1182 = circuit_mul(t1108, in242);
    let t1183 = circuit_mul(t1109, t1109);
    let t1184 = circuit_add(in164, in165);
    let t1185 = circuit_sub(t1184, t1177);
    let t1186 = circuit_mul(t1185, t1182);
    let t1187 = circuit_add(t1113, t1186);
    let t1188 = circuit_sub(in235, in8);
    let t1189 = circuit_mul(in1, t1188);
    let t1190 = circuit_sub(in235, in8);
    let t1191 = circuit_mul(in3, t1190);
    let t1192 = circuit_inverse(t1191);
    let t1193 = circuit_mul(in164, t1192);
    let t1194 = circuit_add(in8, t1193);
    let t1195 = circuit_sub(in235, in1);
    let t1196 = circuit_mul(t1189, t1195);
    let t1197 = circuit_sub(in235, in1);
    let t1198 = circuit_mul(in4, t1197);
    let t1199 = circuit_inverse(t1198);
    let t1200 = circuit_mul(in165, t1199);
    let t1201 = circuit_add(t1194, t1200);
    let t1202 = circuit_sub(in235, in9);
    let t1203 = circuit_mul(t1196, t1202);
    let t1204 = circuit_sub(in235, in9);
    let t1205 = circuit_mul(in5, t1204);
    let t1206 = circuit_inverse(t1205);
    let t1207 = circuit_mul(in166, t1206);
    let t1208 = circuit_add(t1201, t1207);
    let t1209 = circuit_sub(in235, in10);
    let t1210 = circuit_mul(t1203, t1209);
    let t1211 = circuit_sub(in235, in10);
    let t1212 = circuit_mul(in6, t1211);
    let t1213 = circuit_inverse(t1212);
    let t1214 = circuit_mul(in167, t1213);
    let t1215 = circuit_add(t1208, t1214);
    let t1216 = circuit_sub(in235, in11);
    let t1217 = circuit_mul(t1210, t1216);
    let t1218 = circuit_sub(in235, in11);
    let t1219 = circuit_mul(in7, t1218);
    let t1220 = circuit_inverse(t1219);
    let t1221 = circuit_mul(in168, t1220);
    let t1222 = circuit_add(t1215, t1221);
    let t1223 = circuit_sub(in235, in0);
    let t1224 = circuit_mul(t1217, t1223);
    let t1225 = circuit_sub(in235, in0);
    let t1226 = circuit_mul(in6, t1225);
    let t1227 = circuit_inverse(t1226);
    let t1228 = circuit_mul(in169, t1227);
    let t1229 = circuit_add(t1222, t1228);
    let t1230 = circuit_sub(in235, in12);
    let t1231 = circuit_mul(t1224, t1230);
    let t1232 = circuit_sub(in235, in12);
    let t1233 = circuit_mul(in5, t1232);
    let t1234 = circuit_inverse(t1233);
    let t1235 = circuit_mul(in170, t1234);
    let t1236 = circuit_add(t1229, t1235);
    let t1237 = circuit_sub(in235, in13);
    let t1238 = circuit_mul(t1231, t1237);
    let t1239 = circuit_sub(in235, in13);
    let t1240 = circuit_mul(in4, t1239);
    let t1241 = circuit_inverse(t1240);
    let t1242 = circuit_mul(in171, t1241);
    let t1243 = circuit_add(t1236, t1242);
    let t1244 = circuit_sub(in235, in14);
    let t1245 = circuit_mul(t1238, t1244);
    let t1246 = circuit_sub(in235, in14);
    let t1247 = circuit_mul(in3, t1246);
    let t1248 = circuit_inverse(t1247);
    let t1249 = circuit_mul(in172, t1248);
    let t1250 = circuit_add(t1243, t1249);
    let t1251 = circuit_mul(t1250, t1245);
    let t1252 = circuit_sub(t1183, in1);
    let t1253 = circuit_mul(in235, t1252);
    let t1254 = circuit_add(in1, t1253);
    let t1255 = circuit_mul(t1181, t1254);
    let t1256 = circuit_mul(t1182, in242);
    let t1257 = circuit_mul(t1183, t1183);
    let t1258 = circuit_add(in173, in174);
    let t1259 = circuit_sub(t1258, t1251);
    let t1260 = circuit_mul(t1259, t1256);
    let t1261 = circuit_add(t1187, t1260);
    let t1262 = circuit_sub(in236, in8);
    let t1263 = circuit_mul(in1, t1262);
    let t1264 = circuit_sub(in236, in8);
    let t1265 = circuit_mul(in3, t1264);
    let t1266 = circuit_inverse(t1265);
    let t1267 = circuit_mul(in173, t1266);
    let t1268 = circuit_add(in8, t1267);
    let t1269 = circuit_sub(in236, in1);
    let t1270 = circuit_mul(t1263, t1269);
    let t1271 = circuit_sub(in236, in1);
    let t1272 = circuit_mul(in4, t1271);
    let t1273 = circuit_inverse(t1272);
    let t1274 = circuit_mul(in174, t1273);
    let t1275 = circuit_add(t1268, t1274);
    let t1276 = circuit_sub(in236, in9);
    let t1277 = circuit_mul(t1270, t1276);
    let t1278 = circuit_sub(in236, in9);
    let t1279 = circuit_mul(in5, t1278);
    let t1280 = circuit_inverse(t1279);
    let t1281 = circuit_mul(in175, t1280);
    let t1282 = circuit_add(t1275, t1281);
    let t1283 = circuit_sub(in236, in10);
    let t1284 = circuit_mul(t1277, t1283);
    let t1285 = circuit_sub(in236, in10);
    let t1286 = circuit_mul(in6, t1285);
    let t1287 = circuit_inverse(t1286);
    let t1288 = circuit_mul(in176, t1287);
    let t1289 = circuit_add(t1282, t1288);
    let t1290 = circuit_sub(in236, in11);
    let t1291 = circuit_mul(t1284, t1290);
    let t1292 = circuit_sub(in236, in11);
    let t1293 = circuit_mul(in7, t1292);
    let t1294 = circuit_inverse(t1293);
    let t1295 = circuit_mul(in177, t1294);
    let t1296 = circuit_add(t1289, t1295);
    let t1297 = circuit_sub(in236, in0);
    let t1298 = circuit_mul(t1291, t1297);
    let t1299 = circuit_sub(in236, in0);
    let t1300 = circuit_mul(in6, t1299);
    let t1301 = circuit_inverse(t1300);
    let t1302 = circuit_mul(in178, t1301);
    let t1303 = circuit_add(t1296, t1302);
    let t1304 = circuit_sub(in236, in12);
    let t1305 = circuit_mul(t1298, t1304);
    let t1306 = circuit_sub(in236, in12);
    let t1307 = circuit_mul(in5, t1306);
    let t1308 = circuit_inverse(t1307);
    let t1309 = circuit_mul(in179, t1308);
    let t1310 = circuit_add(t1303, t1309);
    let t1311 = circuit_sub(in236, in13);
    let t1312 = circuit_mul(t1305, t1311);
    let t1313 = circuit_sub(in236, in13);
    let t1314 = circuit_mul(in4, t1313);
    let t1315 = circuit_inverse(t1314);
    let t1316 = circuit_mul(in180, t1315);
    let t1317 = circuit_add(t1310, t1316);
    let t1318 = circuit_sub(in236, in14);
    let t1319 = circuit_mul(t1312, t1318);
    let t1320 = circuit_sub(in236, in14);
    let t1321 = circuit_mul(in3, t1320);
    let t1322 = circuit_inverse(t1321);
    let t1323 = circuit_mul(in181, t1322);
    let t1324 = circuit_add(t1317, t1323);
    let t1325 = circuit_mul(t1324, t1319);
    let t1326 = circuit_sub(t1257, in1);
    let t1327 = circuit_mul(in236, t1326);
    let t1328 = circuit_add(in1, t1327);
    let t1329 = circuit_mul(t1255, t1328);
    let t1330 = circuit_sub(in203, in10);
    let t1331 = circuit_mul(t1330, in197);
    let t1332 = circuit_mul(t1331, in207);
    let t1333 = circuit_mul(t1332, in206);
    let t1334 = circuit_mul(t1333, in15);
    let t1335 = circuit_mul(in201, in206);
    let t1336 = circuit_mul(in198, in207);
    let t1337 = circuit_mul(in199, in208);
    let t1338 = circuit_mul(in202, in209);
    let t1339 = circuit_add(t1334, t1335);
    let t1340 = circuit_add(t1339, t1336);
    let t1341 = circuit_add(t1340, t1337);
    let t1342 = circuit_add(t1341, t1338);
    let t1343 = circuit_add(t1342, in200);
    let t1344 = circuit_sub(in203, in1);
    let t1345 = circuit_mul(t1344, in217);
    let t1346 = circuit_add(t1343, t1345);
    let t1347 = circuit_mul(t1346, in203);
    let t1348 = circuit_mul(t1347, t1329);
    let t1349 = circuit_add(in206, in209);
    let t1350 = circuit_add(t1349, in197);
    let t1351 = circuit_sub(t1350, in214);
    let t1352 = circuit_sub(in203, in9);
    let t1353 = circuit_mul(t1351, t1352);
    let t1354 = circuit_sub(in203, in1);
    let t1355 = circuit_mul(t1353, t1354);
    let t1356 = circuit_mul(t1355, in203);
    let t1357 = circuit_mul(t1356, t1329);
    let t1358 = circuit_mul(in186, in240);
    let t1359 = circuit_add(in206, t1358);
    let t1360 = circuit_add(t1359, in241);
    let t1361 = circuit_mul(in187, in240);
    let t1362 = circuit_add(in207, t1361);
    let t1363 = circuit_add(t1362, in241);
    let t1364 = circuit_mul(t1360, t1363);
    let t1365 = circuit_mul(in188, in240);
    let t1366 = circuit_add(in208, t1365);
    let t1367 = circuit_add(t1366, in241);
    let t1368 = circuit_mul(t1364, t1367);
    let t1369 = circuit_mul(in189, in240);
    let t1370 = circuit_add(in209, t1369);
    let t1371 = circuit_add(t1370, in241);
    let t1372 = circuit_mul(t1368, t1371);
    let t1373 = circuit_mul(in182, in240);
    let t1374 = circuit_add(in206, t1373);
    let t1375 = circuit_add(t1374, in241);
    let t1376 = circuit_mul(in183, in240);
    let t1377 = circuit_add(in207, t1376);
    let t1378 = circuit_add(t1377, in241);
    let t1379 = circuit_mul(t1375, t1378);
    let t1380 = circuit_mul(in184, in240);
    let t1381 = circuit_add(in208, t1380);
    let t1382 = circuit_add(t1381, in241);
    let t1383 = circuit_mul(t1379, t1382);
    let t1384 = circuit_mul(in185, in240);
    let t1385 = circuit_add(in209, t1384);
    let t1386 = circuit_add(t1385, in241);
    let t1387 = circuit_mul(t1383, t1386);
    let t1388 = circuit_add(in210, in190);
    let t1389 = circuit_mul(t1372, t1388);
    let t1390 = circuit_mul(in191, t71);
    let t1391 = circuit_add(in218, t1390);
    let t1392 = circuit_mul(t1387, t1391);
    let t1393 = circuit_sub(t1389, t1392);
    let t1394 = circuit_mul(t1393, t1329);
    let t1395 = circuit_mul(in191, in218);
    let t1396 = circuit_mul(t1395, t1329);
    let t1397 = circuit_mul(in190, in210);
    let t1398 = circuit_mul(t1397, t1329);
    let t1399 = circuit_mul(in240, in240);
    let t1400 = circuit_mul(in240, in240);
    let t1401 = circuit_mul(t1400, in240);
    let t1402 = circuit_mul(in194, in240);
    let t1403 = circuit_mul(in195, t1399);
    let t1404 = circuit_mul(in196, t1401);
    let t1405 = circuit_add(in193, in241);
    let t1406 = circuit_add(t1405, t1402);
    let t1407 = circuit_add(t1406, t1403);
    let t1408 = circuit_add(t1407, t1404);
    let t1409 = circuit_mul(in198, in214);
    let t1410 = circuit_add(in206, in241);
    let t1411 = circuit_add(t1410, t1409);
    let t1412 = circuit_mul(in197, in215);
    let t1413 = circuit_add(in207, t1412);
    let t1414 = circuit_mul(in200, in216);
    let t1415 = circuit_add(in208, t1414);
    let t1416 = circuit_mul(t1413, in240);
    let t1417 = circuit_mul(t1415, t1399);
    let t1418 = circuit_mul(in199, t1401);
    let t1419 = circuit_add(t1411, t1416);
    let t1420 = circuit_add(t1419, t1417);
    let t1421 = circuit_add(t1420, t1418);
    let t1422 = circuit_mul(in211, t1408);
    let t1423 = circuit_mul(in211, t1421);
    let t1424 = circuit_add(in213, in192);
    let t1425 = circuit_mul(in213, in192);
    let t1426 = circuit_sub(t1424, t1425);
    let t1427 = circuit_mul(t1421, t1408);
    let t1428 = circuit_mul(t1427, in211);
    let t1429 = circuit_sub(t1428, t1426);
    let t1430 = circuit_mul(t1429, t1329);
    let t1431 = circuit_mul(in192, t1422);
    let t1432 = circuit_mul(in212, t1423);
    let t1433 = circuit_sub(t1431, t1432);
    let t1434 = circuit_mul(in213, in213);
    let t1435 = circuit_sub(t1434, in213);
    let t1436 = circuit_mul(t1435, t1329);
    let t1437 = circuit_mul(in204, t1329);
    let t1438 = circuit_sub(in207, in206);
    let t1439 = circuit_sub(in208, in207);
    let t1440 = circuit_sub(in209, in208);
    let t1441 = circuit_sub(in214, in209);
    let t1442 = circuit_add(t1438, in16);
    let t1443 = circuit_add(t1442, in16);
    let t1444 = circuit_add(t1443, in16);
    let t1445 = circuit_mul(t1438, t1442);
    let t1446 = circuit_mul(t1445, t1443);
    let t1447 = circuit_mul(t1446, t1444);
    let t1448 = circuit_mul(t1447, t1437);
    let t1449 = circuit_add(t1439, in16);
    let t1450 = circuit_add(t1449, in16);
    let t1451 = circuit_add(t1450, in16);
    let t1452 = circuit_mul(t1439, t1449);
    let t1453 = circuit_mul(t1452, t1450);
    let t1454 = circuit_mul(t1453, t1451);
    let t1455 = circuit_mul(t1454, t1437);
    let t1456 = circuit_add(t1440, in16);
    let t1457 = circuit_add(t1456, in16);
    let t1458 = circuit_add(t1457, in16);
    let t1459 = circuit_mul(t1440, t1456);
    let t1460 = circuit_mul(t1459, t1457);
    let t1461 = circuit_mul(t1460, t1458);
    let t1462 = circuit_mul(t1461, t1437);
    let t1463 = circuit_add(t1441, in16);
    let t1464 = circuit_add(t1463, in16);
    let t1465 = circuit_add(t1464, in16);
    let t1466 = circuit_mul(t1441, t1463);
    let t1467 = circuit_mul(t1466, t1464);
    let t1468 = circuit_mul(t1467, t1465);
    let t1469 = circuit_mul(t1468, t1437);
    let t1470 = circuit_mul(in208, t73);
    let t1471 = circuit_mul(in207, t72);
    let t1472 = circuit_add(t1470, t1471);
    let t1473 = circuit_mul(in206, in238);
    let t1474 = circuit_add(t1472, t1473);
    let t1475 = circuit_add(t1474, in200);
    let t1476 = circuit_sub(t1475, in209);
    let t1477 = circuit_sub(in214, in206);
    let t1478 = circuit_sub(in217, in209);
    let t1479 = circuit_sub(t1477, in1);
    let t1480 = circuit_mul(t1477, t1479);
    let t1481 = circuit_mul(t1477, in16);
    let t1482 = circuit_add(t1481, in1);
    let t1483 = circuit_mul(t1482, t1478);
    let t1484 = circuit_mul(in201, in198);
    let t1485 = circuit_mul(in205, t1329);
    let t1486 = circuit_mul(t1484, t1485);
    let t1487 = circuit_mul(t1483, t1486);
    let t1488 = circuit_mul(t1480, t1486);
    let t1489 = circuit_mul(t1476, t1484);
    let t1490 = circuit_sub(in209, t1475);
    let t1491 = circuit_sub(t1490, in1);
    let t1492 = circuit_mul(t1490, t1491);
    let t1493 = circuit_mul(in216, t73);
    let t1494 = circuit_mul(in215, t72);
    let t1495 = circuit_mul(in214, in238);
    let t1496 = circuit_add(t1493, t1494);
    let t1497 = circuit_add(t1496, t1495);
    let t1498 = circuit_sub(in217, t1497);
    let t1499 = circuit_sub(in216, in208);
    let t1500 = circuit_mul(t1477, in16);
    let t1501 = circuit_add(t1500, in1);
    let t1502 = circuit_mul(t1498, in16);
    let t1503 = circuit_add(t1502, in1);
    let t1504 = circuit_mul(t1501, t1499);
    let t1505 = circuit_mul(t1504, t1503);
    let t1506 = circuit_mul(t1498, t1498);
    let t1507 = circuit_sub(t1506, t1498);
    let t1508 = circuit_mul(in199, t1485);
    let t1509 = circuit_mul(t1505, t1508);
    let t1510 = circuit_mul(t1480, t1508);
    let t1511 = circuit_mul(t1507, t1508);
    let t1512 = circuit_mul(t1492, in199);
    let t1513 = circuit_sub(in215, in207);
    let t1514 = circuit_mul(t1477, in16);
    let t1515 = circuit_add(t1514, in1);
    let t1516 = circuit_mul(t1515, t1513);
    let t1517 = circuit_sub(t1516, in208);
    let t1518 = circuit_mul(in202, in201);
    let t1519 = circuit_mul(t1517, t1518);
    let t1520 = circuit_mul(in197, in201);
    let t1521 = circuit_mul(t1476, t1520);
    let t1522 = circuit_add(t1489, t1519);
    let t1523 = circuit_add(t1522, t1521);
    let t1524 = circuit_add(t1523, t1512);
    let t1525 = circuit_mul(t1524, t1485);
    let t1526 = circuit_sub(in1, in201);
    let t1527 = circuit_mul(in198, t1526);
    let t1528 = circuit_mul(in202, t1526);
    let t1529 = circuit_mul(in207, in238);
    let t1530 = circuit_mul(in200, t72);
    let t1531 = circuit_add(in239, in206);
    let t1532 = circuit_add(t1531, t1529);
    let t1533 = circuit_add(t1532, t1530);
    let t1534 = circuit_mul(in209, t1533);
    let t1535 = circuit_sub(t1534, in1);
    let t1536 = circuit_add(t1527, t1528);
    let t1537 = circuit_mul(t1536, t1535);
    let t1538 = circuit_mul(t1537, in205);
    let t1539 = circuit_mul(t1538, t1329);
    let t1540 = circuit_mul(t1527, in208);
    let t1541 = circuit_sub(t1528, t1540);
    let t1542 = circuit_mul(t1541, in209);
    let t1543 = circuit_mul(t1542, in205);
    let t1544 = circuit_mul(t1396, in243);
    let t1545 = circuit_add(t1394, t1544);
    let t1546 = circuit_mul(in243, in243);
    let t1547 = circuit_mul(t1398, t1546);
    let t1548 = circuit_add(t1545, t1547);
    let t1549 = circuit_mul(t1546, in243);
    let t1550 = circuit_mul(t1430, t1549);
    let t1551 = circuit_add(t1548, t1550);
    let t1552 = circuit_mul(t1549, in243);
    let t1553 = circuit_mul(t1433, t1552);
    let t1554 = circuit_add(t1551, t1553);
    let t1555 = circuit_mul(t1552, in243);
    let t1556 = circuit_mul(t1436, t1555);
    let t1557 = circuit_add(t1554, t1556);
    let t1558 = circuit_mul(t1555, in243);
    let t1559 = circuit_mul(t1348, t1558);
    let t1560 = circuit_add(t1557, t1559);
    let t1561 = circuit_mul(t1558, in243);
    let t1562 = circuit_mul(t1357, t1561);
    let t1563 = circuit_add(t1560, t1562);
    let t1564 = circuit_mul(t1561, in243);
    let t1565 = circuit_mul(t1448, t1564);
    let t1566 = circuit_add(t1563, t1565);
    let t1567 = circuit_mul(t1564, in243);
    let t1568 = circuit_mul(t1455, t1567);
    let t1569 = circuit_add(t1566, t1568);
    let t1570 = circuit_mul(t1567, in243);
    let t1571 = circuit_mul(t1462, t1570);
    let t1572 = circuit_add(t1569, t1571);
    let t1573 = circuit_mul(t1570, in243);
    let t1574 = circuit_mul(t1469, t1573);
    let t1575 = circuit_add(t1572, t1574);
    let t1576 = circuit_mul(t1573, in243);
    let t1577 = circuit_mul(t1576, in243);
    let t1578 = circuit_mul(t1577, in243);
    let t1579 = circuit_mul(t1525, t1578);
    let t1580 = circuit_add(t1575, t1579);
    let t1581 = circuit_mul(t1578, in243);
    let t1582 = circuit_mul(t1487, t1581);
    let t1583 = circuit_add(t1580, t1582);
    let t1584 = circuit_mul(t1581, in243);
    let t1585 = circuit_mul(t1488, t1584);
    let t1586 = circuit_add(t1583, t1585);
    let t1587 = circuit_mul(t1584, in243);
    let t1588 = circuit_mul(t1509, t1587);
    let t1589 = circuit_add(t1586, t1588);
    let t1590 = circuit_mul(t1587, in243);
    let t1591 = circuit_mul(t1510, t1590);
    let t1592 = circuit_add(t1589, t1591);
    let t1593 = circuit_mul(t1590, in243);
    let t1594 = circuit_mul(t1511, t1593);
    let t1595 = circuit_add(t1592, t1594);
    let t1596 = circuit_mul(t1593, in243);
    let t1597 = circuit_mul(t1539, t1596);
    let t1598 = circuit_add(t1595, t1597);
    let t1599 = circuit_mul(t1596, in243);
    let t1600 = circuit_mul(t1543, t1599);
    let t1601 = circuit_add(t1598, t1600);
    let t1602 = circuit_sub(in1, in222);
    let t1603 = circuit_sub(in1, in223);
    let t1604 = circuit_mul(t1602, t1603);
    let t1605 = circuit_sub(in1, in224);
    let t1606 = circuit_mul(t1604, t1605);
    let t1607 = circuit_sub(in1, in225);
    let t1608 = circuit_mul(t1606, t1607);
    let t1609 = circuit_sub(in1, in226);
    let t1610 = circuit_mul(t1608, t1609);
    let t1611 = circuit_sub(in1, in227);
    let t1612 = circuit_mul(t1610, t1611);
    let t1613 = circuit_sub(in1, in228);
    let t1614 = circuit_mul(t1612, t1613);
    let t1615 = circuit_sub(in1, in229);
    let t1616 = circuit_mul(t1614, t1615);
    let t1617 = circuit_sub(in1, in230);
    let t1618 = circuit_mul(t1616, t1617);
    let t1619 = circuit_sub(in1, in231);
    let t1620 = circuit_mul(t1618, t1619);
    let t1621 = circuit_sub(in1, in232);
    let t1622 = circuit_mul(t1620, t1621);
    let t1623 = circuit_sub(in1, in233);
    let t1624 = circuit_mul(t1622, t1623);
    let t1625 = circuit_sub(in1, in234);
    let t1626 = circuit_mul(t1624, t1625);
    let t1627 = circuit_sub(in1, in235);
    let t1628 = circuit_mul(t1626, t1627);
    let t1629 = circuit_sub(in1, in236);
    let t1630 = circuit_mul(t1628, t1629);
    let t1631 = circuit_sub(in1, t1630);
    let t1632 = circuit_mul(t1601, t1631);
    let t1633 = circuit_mul(in219, in244);
    let t1634 = circuit_add(t1632, t1633);
    let t1635 = circuit_sub(t1634, t1325);

    let modulus = modulus;

    let mut circuit_inputs = (t1261, t1635).new_inputs();
    // Prefill constants:

    circuit_inputs = circuit_inputs
        .next_span(ZK_HONK_SUMCHECK_SIZE_17_PUB_11_GRUMPKIN_CONSTANTS.span()); // in0 - in16

    // Fill inputs:

    for val in p_public_inputs {
        circuit_inputs = circuit_inputs.next_u256(*val);
    }

    for val in p_pairing_point_object {
        circuit_inputs = circuit_inputs.next_u256(*val);
    }
    circuit_inputs = circuit_inputs.next_2(libra_sum);

    for val in sumcheck_univariates_flat {
        circuit_inputs = circuit_inputs.next_u256(*val);
    }
    for value in sumcheck_evaluations.slice(0, 23) {
        circuit_inputs = circuit_inputs.next_u256(*value);
    }
    for value in sumcheck_evaluations.slice(24, 1) {
        circuit_inputs = circuit_inputs.next_u256(*value);
    }
    for value in sumcheck_evaluations.slice(28, 13) {
        circuit_inputs = circuit_inputs.next_u256(*value);
    }
    circuit_inputs = circuit_inputs.next_2(libra_evaluation);

    for val in tp_sum_check_u_challenges {
        circuit_inputs = circuit_inputs.next_u256(*val);
    }
    circuit_inputs = circuit_inputs.next_u256(tp_gate_challenge);

    circuit_inputs = circuit_inputs.next_2(tp_eta_1);

    circuit_inputs = circuit_inputs.next_2(tp_rom_logup_gamma);

    circuit_inputs = circuit_inputs.next_2(tp_beta);

    circuit_inputs = circuit_inputs.next_2(tp_gamma);

    circuit_inputs = circuit_inputs.next_2(tp_base_rlc);

    circuit_inputs = circuit_inputs.next_u256(tp_alpha);

    circuit_inputs = circuit_inputs.next_2(tp_libra_challenge);

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let check_rlc: u384 = outputs.get_output(t1261);
    let check: u384 = outputs.get_output(t1635);
    return (check_rlc, check);
}
const ZK_HONK_SUMCHECK_SIZE_17_PUB_11_GRUMPKIN_CONSTANTS: [u384; 17] = [
    u384 { limb0: 0x5, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x10000000, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
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
];
#[inline(always)]
pub fn run_GRUMPKIN_ZKHONK_PREP_MSM_SCALARS_SIZE_17_circuit(
    p_sumcheck_evaluations: Span<u256>,
    p_gemini_masking_eval: u384,
    p_gemini_a_evaluations: Span<u256>,
    p_libra_poly_evals: Span<u256>,
    tp_gemini_r: u384,
    tp_rho: u384,
    tp_shplonk_z: u384,
    tp_shplonk_nu: u384,
    tp_sum_check_u_challenges: Span<u256>,
    modulus: core::circuit::CircuitModulus,
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
    let (in60, in61, in62) = (CE::<CI<60>> {}, CE::<CI<61>> {}, CE::<CI<62>> {});
    let (in63, in64, in65) = (CE::<CI<63>> {}, CE::<CI<64>> {}, CE::<CI<65>> {});
    let (in66, in67, in68) = (CE::<CI<66>> {}, CE::<CI<67>> {}, CE::<CI<68>> {});
    let (in69, in70, in71) = (CE::<CI<69>> {}, CE::<CI<70>> {}, CE::<CI<71>> {});
    let (in72, in73, in74) = (CE::<CI<72>> {}, CE::<CI<73>> {}, CE::<CI<74>> {});
    let (in75, in76, in77) = (CE::<CI<75>> {}, CE::<CI<76>> {}, CE::<CI<77>> {});
    let (in78, in79, in80) = (CE::<CI<78>> {}, CE::<CI<79>> {}, CE::<CI<80>> {});
    let (in81, in82, in83) = (CE::<CI<81>> {}, CE::<CI<82>> {}, CE::<CI<83>> {});
    let (in84, in85, in86) = (CE::<CI<84>> {}, CE::<CI<85>> {}, CE::<CI<86>> {});
    let t0 = circuit_mul(in66, in66);
    let t1 = circuit_mul(t0, t0);
    let t2 = circuit_mul(t1, t1);
    let t3 = circuit_mul(t2, t2);
    let t4 = circuit_mul(t3, t3);
    let t5 = circuit_mul(t4, t4);
    let t6 = circuit_mul(t5, t5);
    let t7 = circuit_mul(t6, t6);
    let t8 = circuit_mul(t7, t7);
    let t9 = circuit_mul(t8, t8);
    let t10 = circuit_mul(t9, t9);
    let t11 = circuit_mul(t10, t10);
    let t12 = circuit_mul(t11, t11);
    let t13 = circuit_mul(t12, t12);
    let t14 = circuit_mul(t13, t13);
    let t15 = circuit_mul(t14, t14);
    let t16 = circuit_sub(in68, in66);
    let t17 = circuit_inverse(t16);
    let t18 = circuit_add(in68, in66);
    let t19 = circuit_inverse(t18);
    let t20 = circuit_mul(in69, t19);
    let t21 = circuit_add(t17, t20);
    let t22 = circuit_inverse(in66);
    let t23 = circuit_mul(in69, t19);
    let t24 = circuit_sub(t17, t23);
    let t25 = circuit_mul(t22, t24);
    let t26 = circuit_sub(in0, t25);
    let t27 = circuit_sub(in0, t21);
    let t28 = circuit_mul(t27, in67);
    let t29 = circuit_mul(in3, in67);
    let t30 = circuit_add(in44, t29);
    let t31 = circuit_mul(in67, in67);
    let t32 = circuit_mul(t27, t31);
    let t33 = circuit_mul(in4, t31);
    let t34 = circuit_add(t30, t33);
    let t35 = circuit_mul(t31, in67);
    let t36 = circuit_mul(t27, t35);
    let t37 = circuit_mul(in5, t35);
    let t38 = circuit_add(t34, t37);
    let t39 = circuit_mul(t35, in67);
    let t40 = circuit_mul(t27, t39);
    let t41 = circuit_mul(in6, t39);
    let t42 = circuit_add(t38, t41);
    let t43 = circuit_mul(t39, in67);
    let t44 = circuit_mul(t27, t43);
    let t45 = circuit_mul(in7, t43);
    let t46 = circuit_add(t42, t45);
    let t47 = circuit_mul(t43, in67);
    let t48 = circuit_mul(t27, t47);
    let t49 = circuit_mul(in8, t47);
    let t50 = circuit_add(t46, t49);
    let t51 = circuit_mul(t47, in67);
    let t52 = circuit_mul(t27, t51);
    let t53 = circuit_mul(in9, t51);
    let t54 = circuit_add(t50, t53);
    let t55 = circuit_mul(t51, in67);
    let t56 = circuit_mul(t27, t55);
    let t57 = circuit_mul(in10, t55);
    let t58 = circuit_add(t54, t57);
    let t59 = circuit_mul(t55, in67);
    let t60 = circuit_mul(t27, t59);
    let t61 = circuit_mul(in11, t59);
    let t62 = circuit_add(t58, t61);
    let t63 = circuit_mul(t59, in67);
    let t64 = circuit_mul(t27, t63);
    let t65 = circuit_mul(in12, t63);
    let t66 = circuit_add(t62, t65);
    let t67 = circuit_mul(t63, in67);
    let t68 = circuit_mul(t27, t67);
    let t69 = circuit_mul(in13, t67);
    let t70 = circuit_add(t66, t69);
    let t71 = circuit_mul(t67, in67);
    let t72 = circuit_mul(t27, t71);
    let t73 = circuit_mul(in14, t71);
    let t74 = circuit_add(t70, t73);
    let t75 = circuit_mul(t71, in67);
    let t76 = circuit_mul(t27, t75);
    let t77 = circuit_mul(in15, t75);
    let t78 = circuit_add(t74, t77);
    let t79 = circuit_mul(t75, in67);
    let t80 = circuit_mul(t27, t79);
    let t81 = circuit_mul(in16, t79);
    let t82 = circuit_add(t78, t81);
    let t83 = circuit_mul(t79, in67);
    let t84 = circuit_mul(t27, t83);
    let t85 = circuit_mul(in17, t83);
    let t86 = circuit_add(t82, t85);
    let t87 = circuit_mul(t83, in67);
    let t88 = circuit_mul(t27, t87);
    let t89 = circuit_mul(in18, t87);
    let t90 = circuit_add(t86, t89);
    let t91 = circuit_mul(t87, in67);
    let t92 = circuit_mul(t27, t91);
    let t93 = circuit_mul(in19, t91);
    let t94 = circuit_add(t90, t93);
    let t95 = circuit_mul(t91, in67);
    let t96 = circuit_mul(t27, t95);
    let t97 = circuit_mul(in20, t95);
    let t98 = circuit_add(t94, t97);
    let t99 = circuit_mul(t95, in67);
    let t100 = circuit_mul(t27, t99);
    let t101 = circuit_mul(in21, t99);
    let t102 = circuit_add(t98, t101);
    let t103 = circuit_mul(t99, in67);
    let t104 = circuit_mul(t27, t103);
    let t105 = circuit_mul(in22, t103);
    let t106 = circuit_add(t102, t105);
    let t107 = circuit_mul(t103, in67);
    let t108 = circuit_mul(t27, t107);
    let t109 = circuit_mul(in23, t107);
    let t110 = circuit_add(t106, t109);
    let t111 = circuit_mul(t107, in67);
    let t112 = circuit_mul(t27, t111);
    let t113 = circuit_mul(in24, t111);
    let t114 = circuit_add(t110, t113);
    let t115 = circuit_mul(t111, in67);
    let t116 = circuit_mul(t27, t115);
    let t117 = circuit_mul(in25, t115);
    let t118 = circuit_add(t114, t117);
    let t119 = circuit_mul(t115, in67);
    let t121 = circuit_mul(in26, t119);
    let t122 = circuit_add(t118, t121);
    let t123 = circuit_mul(t119, in67);
    let t124 = circuit_mul(t27, t123);
    let t125 = circuit_mul(in27, t123);
    let t126 = circuit_add(t122, t125);
    let t127 = circuit_mul(t123, in67);
    let t129 = circuit_mul(in28, t127);
    let t130 = circuit_add(t126, t129);
    let t131 = circuit_mul(t127, in67);
    let t133 = circuit_mul(in29, t131);
    let t134 = circuit_add(t130, t133);
    let t135 = circuit_mul(t131, in67);
    let t137 = circuit_mul(in30, t135);
    let t138 = circuit_add(t134, t137);
    let t139 = circuit_mul(t135, in67);
    let t140 = circuit_mul(t27, t139);
    let t141 = circuit_mul(in31, t139);
    let t142 = circuit_add(t138, t141);
    let t143 = circuit_mul(t139, in67);
    let t144 = circuit_mul(t27, t143);
    let t145 = circuit_mul(in32, t143);
    let t146 = circuit_add(t142, t145);
    let t147 = circuit_mul(t143, in67);
    let t148 = circuit_mul(t27, t147);
    let t149 = circuit_mul(in33, t147);
    let t150 = circuit_add(t146, t149);
    let t151 = circuit_mul(t147, in67);
    let t152 = circuit_mul(t27, t151);
    let t153 = circuit_mul(in34, t151);
    let t154 = circuit_add(t150, t153);
    let t155 = circuit_mul(t151, in67);
    let t156 = circuit_mul(t27, t155);
    let t157 = circuit_mul(in35, t155);
    let t158 = circuit_add(t154, t157);
    let t159 = circuit_mul(t155, in67);
    let t160 = circuit_mul(t27, t159);
    let t161 = circuit_mul(in36, t159);
    let t162 = circuit_add(t158, t161);
    let t163 = circuit_mul(t159, in67);
    let t164 = circuit_mul(t27, t163);
    let t165 = circuit_mul(in37, t163);
    let t166 = circuit_add(t162, t165);
    let t167 = circuit_mul(t163, in67);
    let t168 = circuit_mul(t27, t167);
    let t169 = circuit_mul(in38, t167);
    let t170 = circuit_add(t166, t169);
    let t171 = circuit_mul(t167, in67);
    let t172 = circuit_mul(t26, t171);
    let t173 = circuit_add(t140, t172);
    let t174 = circuit_mul(in39, t171);
    let t175 = circuit_add(t170, t174);
    let t176 = circuit_mul(t171, in67);
    let t177 = circuit_mul(t26, t176);
    let t178 = circuit_add(t144, t177);
    let t179 = circuit_mul(in40, t176);
    let t180 = circuit_add(t175, t179);
    let t181 = circuit_mul(t176, in67);
    let t182 = circuit_mul(t26, t181);
    let t183 = circuit_add(t148, t182);
    let t184 = circuit_mul(in41, t181);
    let t185 = circuit_add(t180, t184);
    let t186 = circuit_mul(t181, in67);
    let t187 = circuit_mul(t26, t186);
    let t188 = circuit_add(t152, t187);
    let t189 = circuit_mul(in42, t186);
    let t190 = circuit_add(t185, t189);
    let t191 = circuit_mul(t186, in67);
    let t192 = circuit_mul(t26, t191);
    let t193 = circuit_add(t156, t192);
    let t194 = circuit_mul(in43, t191);
    let t195 = circuit_add(t190, t194);
    let t196 = circuit_sub(in1, in86);
    let t197 = circuit_mul(t15, t196);
    let t198 = circuit_mul(t15, t195);
    let t199 = circuit_add(t198, t198);
    let t200 = circuit_sub(t197, in86);
    let t201 = circuit_mul(in61, t200);
    let t202 = circuit_sub(t199, t201);
    let t203 = circuit_add(t197, in86);
    let t204 = circuit_inverse(t203);
    let t205 = circuit_mul(t202, t204);
    let t206 = circuit_sub(in1, in85);
    let t207 = circuit_mul(t14, t206);
    let t208 = circuit_mul(t14, t205);
    let t209 = circuit_add(t208, t208);
    let t210 = circuit_sub(t207, in85);
    let t211 = circuit_mul(in60, t210);
    let t212 = circuit_sub(t209, t211);
    let t213 = circuit_add(t207, in85);
    let t214 = circuit_inverse(t213);
    let t215 = circuit_mul(t212, t214);
    let t216 = circuit_sub(in1, in84);
    let t217 = circuit_mul(t13, t216);
    let t218 = circuit_mul(t13, t215);
    let t219 = circuit_add(t218, t218);
    let t220 = circuit_sub(t217, in84);
    let t221 = circuit_mul(in59, t220);
    let t222 = circuit_sub(t219, t221);
    let t223 = circuit_add(t217, in84);
    let t224 = circuit_inverse(t223);
    let t225 = circuit_mul(t222, t224);
    let t226 = circuit_sub(in1, in83);
    let t227 = circuit_mul(t12, t226);
    let t228 = circuit_mul(t12, t225);
    let t229 = circuit_add(t228, t228);
    let t230 = circuit_sub(t227, in83);
    let t231 = circuit_mul(in58, t230);
    let t232 = circuit_sub(t229, t231);
    let t233 = circuit_add(t227, in83);
    let t234 = circuit_inverse(t233);
    let t235 = circuit_mul(t232, t234);
    let t236 = circuit_sub(in1, in82);
    let t237 = circuit_mul(t11, t236);
    let t238 = circuit_mul(t11, t235);
    let t239 = circuit_add(t238, t238);
    let t240 = circuit_sub(t237, in82);
    let t241 = circuit_mul(in57, t240);
    let t242 = circuit_sub(t239, t241);
    let t243 = circuit_add(t237, in82);
    let t244 = circuit_inverse(t243);
    let t245 = circuit_mul(t242, t244);
    let t246 = circuit_sub(in1, in81);
    let t247 = circuit_mul(t10, t246);
    let t248 = circuit_mul(t10, t245);
    let t249 = circuit_add(t248, t248);
    let t250 = circuit_sub(t247, in81);
    let t251 = circuit_mul(in56, t250);
    let t252 = circuit_sub(t249, t251);
    let t253 = circuit_add(t247, in81);
    let t254 = circuit_inverse(t253);
    let t255 = circuit_mul(t252, t254);
    let t256 = circuit_sub(in1, in80);
    let t257 = circuit_mul(t9, t256);
    let t258 = circuit_mul(t9, t255);
    let t259 = circuit_add(t258, t258);
    let t260 = circuit_sub(t257, in80);
    let t261 = circuit_mul(in55, t260);
    let t262 = circuit_sub(t259, t261);
    let t263 = circuit_add(t257, in80);
    let t264 = circuit_inverse(t263);
    let t265 = circuit_mul(t262, t264);
    let t266 = circuit_sub(in1, in79);
    let t267 = circuit_mul(t8, t266);
    let t268 = circuit_mul(t8, t265);
    let t269 = circuit_add(t268, t268);
    let t270 = circuit_sub(t267, in79);
    let t271 = circuit_mul(in54, t270);
    let t272 = circuit_sub(t269, t271);
    let t273 = circuit_add(t267, in79);
    let t274 = circuit_inverse(t273);
    let t275 = circuit_mul(t272, t274);
    let t276 = circuit_sub(in1, in78);
    let t277 = circuit_mul(t7, t276);
    let t278 = circuit_mul(t7, t275);
    let t279 = circuit_add(t278, t278);
    let t280 = circuit_sub(t277, in78);
    let t281 = circuit_mul(in53, t280);
    let t282 = circuit_sub(t279, t281);
    let t283 = circuit_add(t277, in78);
    let t284 = circuit_inverse(t283);
    let t285 = circuit_mul(t282, t284);
    let t286 = circuit_sub(in1, in77);
    let t287 = circuit_mul(t6, t286);
    let t288 = circuit_mul(t6, t285);
    let t289 = circuit_add(t288, t288);
    let t290 = circuit_sub(t287, in77);
    let t291 = circuit_mul(in52, t290);
    let t292 = circuit_sub(t289, t291);
    let t293 = circuit_add(t287, in77);
    let t294 = circuit_inverse(t293);
    let t295 = circuit_mul(t292, t294);
    let t296 = circuit_sub(in1, in76);
    let t297 = circuit_mul(t5, t296);
    let t298 = circuit_mul(t5, t295);
    let t299 = circuit_add(t298, t298);
    let t300 = circuit_sub(t297, in76);
    let t301 = circuit_mul(in51, t300);
    let t302 = circuit_sub(t299, t301);
    let t303 = circuit_add(t297, in76);
    let t304 = circuit_inverse(t303);
    let t305 = circuit_mul(t302, t304);
    let t306 = circuit_sub(in1, in75);
    let t307 = circuit_mul(t4, t306);
    let t308 = circuit_mul(t4, t305);
    let t309 = circuit_add(t308, t308);
    let t310 = circuit_sub(t307, in75);
    let t311 = circuit_mul(in50, t310);
    let t312 = circuit_sub(t309, t311);
    let t313 = circuit_add(t307, in75);
    let t314 = circuit_inverse(t313);
    let t315 = circuit_mul(t312, t314);
    let t316 = circuit_sub(in1, in74);
    let t317 = circuit_mul(t3, t316);
    let t318 = circuit_mul(t3, t315);
    let t319 = circuit_add(t318, t318);
    let t320 = circuit_sub(t317, in74);
    let t321 = circuit_mul(in49, t320);
    let t322 = circuit_sub(t319, t321);
    let t323 = circuit_add(t317, in74);
    let t324 = circuit_inverse(t323);
    let t325 = circuit_mul(t322, t324);
    let t326 = circuit_sub(in1, in73);
    let t327 = circuit_mul(t2, t326);
    let t328 = circuit_mul(t2, t325);
    let t329 = circuit_add(t328, t328);
    let t330 = circuit_sub(t327, in73);
    let t331 = circuit_mul(in48, t330);
    let t332 = circuit_sub(t329, t331);
    let t333 = circuit_add(t327, in73);
    let t334 = circuit_inverse(t333);
    let t335 = circuit_mul(t332, t334);
    let t336 = circuit_sub(in1, in72);
    let t337 = circuit_mul(t1, t336);
    let t338 = circuit_mul(t1, t335);
    let t339 = circuit_add(t338, t338);
    let t340 = circuit_sub(t337, in72);
    let t341 = circuit_mul(in47, t340);
    let t342 = circuit_sub(t339, t341);
    let t343 = circuit_add(t337, in72);
    let t344 = circuit_inverse(t343);
    let t345 = circuit_mul(t342, t344);
    let t346 = circuit_sub(in1, in71);
    let t347 = circuit_mul(t0, t346);
    let t348 = circuit_mul(t0, t345);
    let t349 = circuit_add(t348, t348);
    let t350 = circuit_sub(t347, in71);
    let t351 = circuit_mul(in46, t350);
    let t352 = circuit_sub(t349, t351);
    let t353 = circuit_add(t347, in71);
    let t354 = circuit_inverse(t353);
    let t355 = circuit_mul(t352, t354);
    let t356 = circuit_sub(in1, in70);
    let t357 = circuit_mul(in66, t356);
    let t358 = circuit_mul(in66, t355);
    let t359 = circuit_add(t358, t358);
    let t360 = circuit_sub(t357, in70);
    let t361 = circuit_mul(in45, t360);
    let t362 = circuit_sub(t359, t361);
    let t363 = circuit_add(t357, in70);
    let t364 = circuit_inverse(t363);
    let t365 = circuit_mul(t362, t364);
    let t366 = circuit_mul(t365, t17);
    let t367 = circuit_mul(in45, in69);
    let t368 = circuit_mul(t367, t19);
    let t369 = circuit_add(t366, t368);
    let t370 = circuit_mul(in69, in69);
    let t371 = circuit_sub(in68, t0);
    let t372 = circuit_inverse(t371);
    let t373 = circuit_add(in68, t0);
    let t374 = circuit_inverse(t373);
    let t375 = circuit_mul(t370, t372);
    let t376 = circuit_mul(in69, t374);
    let t377 = circuit_mul(t370, t376);
    let t378 = circuit_add(t377, t375);
    let t379 = circuit_sub(in0, t378);
    let t380 = circuit_mul(t377, in46);
    let t381 = circuit_mul(t375, t355);
    let t382 = circuit_add(t380, t381);
    let t383 = circuit_add(t369, t382);
    let t384 = circuit_mul(in69, in69);
    let t385 = circuit_mul(t370, t384);
    let t386 = circuit_sub(in68, t1);
    let t387 = circuit_inverse(t386);
    let t388 = circuit_add(in68, t1);
    let t389 = circuit_inverse(t388);
    let t390 = circuit_mul(t385, t387);
    let t391 = circuit_mul(in69, t389);
    let t392 = circuit_mul(t385, t391);
    let t393 = circuit_add(t392, t390);
    let t394 = circuit_sub(in0, t393);
    let t395 = circuit_mul(t392, in47);
    let t396 = circuit_mul(t390, t345);
    let t397 = circuit_add(t395, t396);
    let t398 = circuit_add(t383, t397);
    let t399 = circuit_mul(in69, in69);
    let t400 = circuit_mul(t385, t399);
    let t401 = circuit_sub(in68, t2);
    let t402 = circuit_inverse(t401);
    let t403 = circuit_add(in68, t2);
    let t404 = circuit_inverse(t403);
    let t405 = circuit_mul(t400, t402);
    let t406 = circuit_mul(in69, t404);
    let t407 = circuit_mul(t400, t406);
    let t408 = circuit_add(t407, t405);
    let t409 = circuit_sub(in0, t408);
    let t410 = circuit_mul(t407, in48);
    let t411 = circuit_mul(t405, t335);
    let t412 = circuit_add(t410, t411);
    let t413 = circuit_add(t398, t412);
    let t414 = circuit_mul(in69, in69);
    let t415 = circuit_mul(t400, t414);
    let t416 = circuit_sub(in68, t3);
    let t417 = circuit_inverse(t416);
    let t418 = circuit_add(in68, t3);
    let t419 = circuit_inverse(t418);
    let t420 = circuit_mul(t415, t417);
    let t421 = circuit_mul(in69, t419);
    let t422 = circuit_mul(t415, t421);
    let t423 = circuit_add(t422, t420);
    let t424 = circuit_sub(in0, t423);
    let t425 = circuit_mul(t422, in49);
    let t426 = circuit_mul(t420, t325);
    let t427 = circuit_add(t425, t426);
    let t428 = circuit_add(t413, t427);
    let t429 = circuit_mul(in69, in69);
    let t430 = circuit_mul(t415, t429);
    let t431 = circuit_sub(in68, t4);
    let t432 = circuit_inverse(t431);
    let t433 = circuit_add(in68, t4);
    let t434 = circuit_inverse(t433);
    let t435 = circuit_mul(t430, t432);
    let t436 = circuit_mul(in69, t434);
    let t437 = circuit_mul(t430, t436);
    let t438 = circuit_add(t437, t435);
    let t439 = circuit_sub(in0, t438);
    let t440 = circuit_mul(t437, in50);
    let t441 = circuit_mul(t435, t315);
    let t442 = circuit_add(t440, t441);
    let t443 = circuit_add(t428, t442);
    let t444 = circuit_mul(in69, in69);
    let t445 = circuit_mul(t430, t444);
    let t446 = circuit_sub(in68, t5);
    let t447 = circuit_inverse(t446);
    let t448 = circuit_add(in68, t5);
    let t449 = circuit_inverse(t448);
    let t450 = circuit_mul(t445, t447);
    let t451 = circuit_mul(in69, t449);
    let t452 = circuit_mul(t445, t451);
    let t453 = circuit_add(t452, t450);
    let t454 = circuit_sub(in0, t453);
    let t455 = circuit_mul(t452, in51);
    let t456 = circuit_mul(t450, t305);
    let t457 = circuit_add(t455, t456);
    let t458 = circuit_add(t443, t457);
    let t459 = circuit_mul(in69, in69);
    let t460 = circuit_mul(t445, t459);
    let t461 = circuit_sub(in68, t6);
    let t462 = circuit_inverse(t461);
    let t463 = circuit_add(in68, t6);
    let t464 = circuit_inverse(t463);
    let t465 = circuit_mul(t460, t462);
    let t466 = circuit_mul(in69, t464);
    let t467 = circuit_mul(t460, t466);
    let t468 = circuit_add(t467, t465);
    let t469 = circuit_sub(in0, t468);
    let t470 = circuit_mul(t467, in52);
    let t471 = circuit_mul(t465, t295);
    let t472 = circuit_add(t470, t471);
    let t473 = circuit_add(t458, t472);
    let t474 = circuit_mul(in69, in69);
    let t475 = circuit_mul(t460, t474);
    let t476 = circuit_sub(in68, t7);
    let t477 = circuit_inverse(t476);
    let t478 = circuit_add(in68, t7);
    let t479 = circuit_inverse(t478);
    let t480 = circuit_mul(t475, t477);
    let t481 = circuit_mul(in69, t479);
    let t482 = circuit_mul(t475, t481);
    let t483 = circuit_add(t482, t480);
    let t484 = circuit_sub(in0, t483);
    let t485 = circuit_mul(t482, in53);
    let t486 = circuit_mul(t480, t285);
    let t487 = circuit_add(t485, t486);
    let t488 = circuit_add(t473, t487);
    let t489 = circuit_mul(in69, in69);
    let t490 = circuit_mul(t475, t489);
    let t491 = circuit_sub(in68, t8);
    let t492 = circuit_inverse(t491);
    let t493 = circuit_add(in68, t8);
    let t494 = circuit_inverse(t493);
    let t495 = circuit_mul(t490, t492);
    let t496 = circuit_mul(in69, t494);
    let t497 = circuit_mul(t490, t496);
    let t498 = circuit_add(t497, t495);
    let t499 = circuit_sub(in0, t498);
    let t500 = circuit_mul(t497, in54);
    let t501 = circuit_mul(t495, t275);
    let t502 = circuit_add(t500, t501);
    let t503 = circuit_add(t488, t502);
    let t504 = circuit_mul(in69, in69);
    let t505 = circuit_mul(t490, t504);
    let t506 = circuit_sub(in68, t9);
    let t507 = circuit_inverse(t506);
    let t508 = circuit_add(in68, t9);
    let t509 = circuit_inverse(t508);
    let t510 = circuit_mul(t505, t507);
    let t511 = circuit_mul(in69, t509);
    let t512 = circuit_mul(t505, t511);
    let t513 = circuit_add(t512, t510);
    let t514 = circuit_sub(in0, t513);
    let t515 = circuit_mul(t512, in55);
    let t516 = circuit_mul(t510, t265);
    let t517 = circuit_add(t515, t516);
    let t518 = circuit_add(t503, t517);
    let t519 = circuit_mul(in69, in69);
    let t520 = circuit_mul(t505, t519);
    let t521 = circuit_sub(in68, t10);
    let t522 = circuit_inverse(t521);
    let t523 = circuit_add(in68, t10);
    let t524 = circuit_inverse(t523);
    let t525 = circuit_mul(t520, t522);
    let t526 = circuit_mul(in69, t524);
    let t527 = circuit_mul(t520, t526);
    let t528 = circuit_add(t527, t525);
    let t529 = circuit_sub(in0, t528);
    let t530 = circuit_mul(t527, in56);
    let t531 = circuit_mul(t525, t255);
    let t532 = circuit_add(t530, t531);
    let t533 = circuit_add(t518, t532);
    let t534 = circuit_mul(in69, in69);
    let t535 = circuit_mul(t520, t534);
    let t536 = circuit_sub(in68, t11);
    let t537 = circuit_inverse(t536);
    let t538 = circuit_add(in68, t11);
    let t539 = circuit_inverse(t538);
    let t540 = circuit_mul(t535, t537);
    let t541 = circuit_mul(in69, t539);
    let t542 = circuit_mul(t535, t541);
    let t543 = circuit_add(t542, t540);
    let t544 = circuit_sub(in0, t543);
    let t545 = circuit_mul(t542, in57);
    let t546 = circuit_mul(t540, t245);
    let t547 = circuit_add(t545, t546);
    let t548 = circuit_add(t533, t547);
    let t549 = circuit_mul(in69, in69);
    let t550 = circuit_mul(t535, t549);
    let t551 = circuit_sub(in68, t12);
    let t552 = circuit_inverse(t551);
    let t553 = circuit_add(in68, t12);
    let t554 = circuit_inverse(t553);
    let t555 = circuit_mul(t550, t552);
    let t556 = circuit_mul(in69, t554);
    let t557 = circuit_mul(t550, t556);
    let t558 = circuit_add(t557, t555);
    let t559 = circuit_sub(in0, t558);
    let t560 = circuit_mul(t557, in58);
    let t561 = circuit_mul(t555, t235);
    let t562 = circuit_add(t560, t561);
    let t563 = circuit_add(t548, t562);
    let t564 = circuit_mul(in69, in69);
    let t565 = circuit_mul(t550, t564);
    let t566 = circuit_sub(in68, t13);
    let t567 = circuit_inverse(t566);
    let t568 = circuit_add(in68, t13);
    let t569 = circuit_inverse(t568);
    let t570 = circuit_mul(t565, t567);
    let t571 = circuit_mul(in69, t569);
    let t572 = circuit_mul(t565, t571);
    let t573 = circuit_add(t572, t570);
    let t574 = circuit_sub(in0, t573);
    let t575 = circuit_mul(t572, in59);
    let t576 = circuit_mul(t570, t225);
    let t577 = circuit_add(t575, t576);
    let t578 = circuit_add(t563, t577);
    let t579 = circuit_mul(in69, in69);
    let t580 = circuit_mul(t565, t579);
    let t581 = circuit_sub(in68, t14);
    let t582 = circuit_inverse(t581);
    let t583 = circuit_add(in68, t14);
    let t584 = circuit_inverse(t583);
    let t585 = circuit_mul(t580, t582);
    let t586 = circuit_mul(in69, t584);
    let t587 = circuit_mul(t580, t586);
    let t588 = circuit_add(t587, t585);
    let t589 = circuit_sub(in0, t588);
    let t590 = circuit_mul(t587, in60);
    let t591 = circuit_mul(t585, t215);
    let t592 = circuit_add(t590, t591);
    let t593 = circuit_add(t578, t592);
    let t594 = circuit_mul(in69, in69);
    let t595 = circuit_mul(t580, t594);
    let t596 = circuit_sub(in68, t15);
    let t597 = circuit_inverse(t596);
    let t598 = circuit_add(in68, t15);
    let t599 = circuit_inverse(t598);
    let t600 = circuit_mul(t595, t597);
    let t601 = circuit_mul(in69, t599);
    let t602 = circuit_mul(t595, t601);
    let t603 = circuit_add(t602, t600);
    let t604 = circuit_sub(in0, t603);
    let t605 = circuit_mul(t602, in61);
    let t606 = circuit_mul(t600, t205);
    let t607 = circuit_add(t605, t606);
    let t608 = circuit_add(t593, t607);
    let t609 = circuit_mul(in69, in69);
    let t610 = circuit_mul(t595, t609);
    let t611 = circuit_sub(in68, in66);
    let t612 = circuit_inverse(t611);
    let t613 = circuit_mul(in2, in66);
    let t614 = circuit_sub(in68, t613);
    let t615 = circuit_inverse(t614);
    let t616 = circuit_sub(in68, in1);
    let t617 = circuit_inverse(t616);
    let t618 = circuit_mul(t612, t610);
    let t619 = circuit_sub(in0, t618);
    let t620 = circuit_mul(t618, in62);
    let t621 = circuit_add(t608, t620);
    let t622 = circuit_mul(t610, in69);
    let t623 = circuit_mul(t615, t622);
    let t624 = circuit_sub(in0, t623);
    let t625 = circuit_mul(t623, in63);
    let t626 = circuit_add(t621, t625);
    let t627 = circuit_mul(t622, in69);
    let t628 = circuit_mul(t612, t627);
    let t629 = circuit_sub(in0, t628);
    let t630 = circuit_mul(t628, in64);
    let t631 = circuit_add(t626, t630);
    let t632 = circuit_mul(t627, in69);
    let t633 = circuit_mul(t617, t632);
    let t634 = circuit_sub(in0, t633);
    let t635 = circuit_mul(t632, in69);
    let t636 = circuit_mul(t612, t635);
    let t637 = circuit_sub(in0, t636);
    let t638 = circuit_mul(t636, in65);
    let t639 = circuit_add(t631, t638);
    let t640 = circuit_add(t624, t629);
    let t641 = circuit_add(t640, t634);

    let modulus = modulus;

    let mut circuit_inputs = (
        t27,
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
        t124,
        t173,
        t178,
        t183,
        t188,
        t193,
        t160,
        t164,
        t168,
        t379,
        t394,
        t409,
        t424,
        t439,
        t454,
        t469,
        t484,
        t499,
        t514,
        t529,
        t544,
        t559,
        t574,
        t589,
        t604,
        t619,
        t641,
        t637,
        t639,
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
    }
    circuit_inputs = circuit_inputs.next_2(p_gemini_masking_eval);

    for val in p_gemini_a_evaluations {
        circuit_inputs = circuit_inputs.next_u256(*val);
    }

    for val in p_libra_poly_evals {
        circuit_inputs = circuit_inputs.next_u256(*val);
    }
    circuit_inputs = circuit_inputs.next_2(tp_gemini_r);

    circuit_inputs = circuit_inputs.next_2(tp_rho);

    circuit_inputs = circuit_inputs.next_2(tp_shplonk_z);

    circuit_inputs = circuit_inputs.next_2(tp_shplonk_nu);

    for val in tp_sum_check_u_challenges {
        circuit_inputs = circuit_inputs.next_u256(*val);
    }

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let scalar_1: u384 = outputs.get_output(t27);
    let scalar_2: u384 = outputs.get_output(t28);
    let scalar_3: u384 = outputs.get_output(t32);
    let scalar_4: u384 = outputs.get_output(t36);
    let scalar_5: u384 = outputs.get_output(t40);
    let scalar_6: u384 = outputs.get_output(t44);
    let scalar_7: u384 = outputs.get_output(t48);
    let scalar_8: u384 = outputs.get_output(t52);
    let scalar_9: u384 = outputs.get_output(t56);
    let scalar_10: u384 = outputs.get_output(t60);
    let scalar_11: u384 = outputs.get_output(t64);
    let scalar_12: u384 = outputs.get_output(t68);
    let scalar_13: u384 = outputs.get_output(t72);
    let scalar_14: u384 = outputs.get_output(t76);
    let scalar_15: u384 = outputs.get_output(t80);
    let scalar_16: u384 = outputs.get_output(t84);
    let scalar_17: u384 = outputs.get_output(t88);
    let scalar_18: u384 = outputs.get_output(t92);
    let scalar_19: u384 = outputs.get_output(t96);
    let scalar_20: u384 = outputs.get_output(t100);
    let scalar_21: u384 = outputs.get_output(t104);
    let scalar_22: u384 = outputs.get_output(t108);
    let scalar_23: u384 = outputs.get_output(t112);
    let scalar_24: u384 = outputs.get_output(t116);
    let scalar_26: u384 = outputs.get_output(t124);
    let scalar_30: u384 = outputs.get_output(t173);
    let scalar_31: u384 = outputs.get_output(t178);
    let scalar_32: u384 = outputs.get_output(t183);
    let scalar_33: u384 = outputs.get_output(t188);
    let scalar_34: u384 = outputs.get_output(t193);
    let scalar_35: u384 = outputs.get_output(t160);
    let scalar_36: u384 = outputs.get_output(t164);
    let scalar_37: u384 = outputs.get_output(t168);
    let scalar_38: u384 = outputs.get_output(t379);
    let scalar_39: u384 = outputs.get_output(t394);
    let scalar_40: u384 = outputs.get_output(t409);
    let scalar_41: u384 = outputs.get_output(t424);
    let scalar_42: u384 = outputs.get_output(t439);
    let scalar_43: u384 = outputs.get_output(t454);
    let scalar_44: u384 = outputs.get_output(t469);
    let scalar_45: u384 = outputs.get_output(t484);
    let scalar_46: u384 = outputs.get_output(t499);
    let scalar_47: u384 = outputs.get_output(t514);
    let scalar_48: u384 = outputs.get_output(t529);
    let scalar_49: u384 = outputs.get_output(t544);
    let scalar_50: u384 = outputs.get_output(t559);
    let scalar_51: u384 = outputs.get_output(t574);
    let scalar_52: u384 = outputs.get_output(t589);
    let scalar_53: u384 = outputs.get_output(t604);
    let scalar_54: u384 = outputs.get_output(t619);
    let scalar_55: u384 = outputs.get_output(t641);
    let scalar_56: u384 = outputs.get_output(t637);
    let scalar_57: u384 = outputs.get_output(t639);
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
        scalar_26,
        scalar_30,
        scalar_31,
        scalar_32,
        scalar_33,
        scalar_34,
        scalar_35,
        scalar_36,
        scalar_37,
        scalar_38,
        scalar_39,
        scalar_40,
        scalar_41,
        scalar_42,
        scalar_43,
        scalar_44,
        scalar_45,
        scalar_46,
        scalar_47,
        scalar_48,
        scalar_49,
        scalar_50,
        scalar_51,
        scalar_52,
        scalar_53,
        scalar_54,
        scalar_55,
        scalar_56,
        scalar_57,
    );
}
#[inline(always)]
pub fn run_GRUMPKIN_ZK_HONK_EVALS_CONS_INIT_SIZE_17_circuit(
    tp_gemini_r: u384, modulus: core::circuit::CircuitModulus,
) -> (u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x1
    let in1 = CE::<CI<1>> {}; // 0x204bd3277422fad364751ad938e2b5e6a54cf8c68712848a692c553d0329f5d6

    // INPUT stack
    let in2 = CE::<CI<2>> {};
    let t0 = circuit_sub(in2, in0);
    let t1 = circuit_inverse(t0);
    let t2 = circuit_mul(in1, in2);

    let modulus = modulus;

    let mut circuit_inputs = (t1, t2).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x1, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs
        .next_2(
            [0x8712848a692c553d0329f5d6, 0x64751ad938e2b5e6a54cf8c6, 0x204bd3277422fad3, 0x0],
        ); // in1
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(tp_gemini_r);

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let challenge_poly_eval: u384 = outputs.get_output(t1);
    let root_power_times_tp_gemini_r: u384 = outputs.get_output(t2);
    return (challenge_poly_eval, root_power_times_tp_gemini_r);
}
#[inline(always)]
pub fn run_GRUMPKIN_ZK_HONK_EVALS_CONS_LOOP_SIZE_17_circuit(
    challenge_poly_eval: u384,
    root_power_times_tp_gemini_r: u384,
    tp_sumcheck_u_challenge: u384,
    modulus: core::circuit::CircuitModulus,
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

    let modulus = modulus;

    let mut circuit_inputs = (t51, t52).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x1, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs
        .next_2(
            [0x8712848a692c553d0329f5d6, 0x64751ad938e2b5e6a54cf8c6, 0x204bd3277422fad3, 0x0],
        ); // in1
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(challenge_poly_eval);

    circuit_inputs = circuit_inputs.next_2(root_power_times_tp_gemini_r);

    circuit_inputs = circuit_inputs.next_2(tp_sumcheck_u_challenge);

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let challenge_poly_eval: u384 = outputs.get_output(t51);
    let root_power_times_tp_gemini_r: u384 = outputs.get_output(t52);
    return (challenge_poly_eval, root_power_times_tp_gemini_r);
}
#[inline(always)]
pub fn run_GRUMPKIN_ZK_HONK_EVALS_CONS_DONE_SIZE_17_circuit(
    p_libra_evaluation: u384,
    p_libra_poly_evals: Span<u256>,
    tp_gemini_r: u384,
    challenge_poly_eval: u384,
    root_power_times_tp_gemini_r: u384,
    modulus: core::circuit::CircuitModulus,
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
    let t2 = circuit_mul(t1, in0);
    let t3 = circuit_mul(t2, in0);
    let t4 = circuit_mul(t3, in0);
    let t5 = circuit_mul(t4, in0);
    let t6 = circuit_mul(t5, in0);
    let t7 = circuit_mul(t6, in0);
    let t8 = circuit_mul(t7, in0);
    let t9 = circuit_mul(t8, in0);
    let t10 = circuit_mul(t9, in0);
    let t11 = circuit_mul(t10, in0);
    let t12 = circuit_mul(t11, in0);
    let t13 = circuit_mul(t12, in0);
    let t14 = circuit_mul(t13, in0);
    let t15 = circuit_mul(t14, in0);
    let t16 = circuit_mul(t15, in0);
    let t17 = circuit_mul(t16, in0);
    let t18 = circuit_mul(t17, in0);
    let t19 = circuit_mul(t18, in0);
    let t20 = circuit_mul(t19, in0);
    let t21 = circuit_mul(t20, in0);
    let t22 = circuit_mul(t21, in0);
    let t23 = circuit_mul(t22, in0);
    let t24 = circuit_mul(t23, in0);
    let t25 = circuit_mul(t24, in0);
    let t26 = circuit_mul(t25, in0);
    let t27 = circuit_mul(t26, in0);
    let t28 = circuit_mul(t27, in0);
    let t29 = circuit_mul(t28, in0);
    let t30 = circuit_mul(t29, in0);
    let t31 = circuit_mul(t30, in0);
    let t32 = circuit_mul(t31, in0);
    let t33 = circuit_mul(t32, in0);
    let t34 = circuit_mul(t33, in0);
    let t35 = circuit_mul(t34, in0);
    let t36 = circuit_mul(t35, in0);
    let t37 = circuit_mul(t36, in0);
    let t38 = circuit_mul(t37, in0);
    let t39 = circuit_mul(t38, in0);
    let t40 = circuit_mul(t39, in0);
    let t41 = circuit_mul(t40, in0);
    let t42 = circuit_mul(t41, in0);
    let t43 = circuit_mul(t42, in0);
    let t44 = circuit_mul(t43, in0);
    let t45 = circuit_mul(t44, in0);
    let t46 = circuit_mul(t45, in0);
    let t47 = circuit_mul(t46, in0);
    let t48 = circuit_mul(t47, in0);
    let t49 = circuit_mul(t48, in0);
    let t50 = circuit_mul(t49, in0);
    let t51 = circuit_mul(t50, in0);
    let t52 = circuit_mul(t51, in0);
    let t53 = circuit_mul(t52, in0);
    let t54 = circuit_mul(t53, in0);
    let t55 = circuit_mul(t54, in0);
    let t56 = circuit_mul(t55, in0);
    let t57 = circuit_mul(t56, in0);
    let t58 = circuit_mul(t57, in0);
    let t59 = circuit_mul(t58, in0);
    let t60 = circuit_mul(t59, in0);
    let t61 = circuit_mul(t60, in0);
    let t62 = circuit_mul(t61, in0);
    let t63 = circuit_mul(t62, in0);
    let t64 = circuit_mul(t63, in0);
    let t65 = circuit_mul(t64, in0);
    let t66 = circuit_mul(t65, in0);
    let t67 = circuit_mul(t66, in0);
    let t68 = circuit_mul(t67, in0);
    let t69 = circuit_mul(t68, in0);
    let t70 = circuit_mul(t69, in0);
    let t71 = circuit_mul(t70, in0);
    let t72 = circuit_mul(t71, in0);
    let t73 = circuit_mul(t72, in0);
    let t74 = circuit_mul(t73, in0);
    let t75 = circuit_mul(t74, in0);
    let t76 = circuit_mul(t75, in0);
    let t77 = circuit_mul(t76, in0);
    let t78 = circuit_mul(t77, in0);
    let t79 = circuit_mul(t78, in0);
    let t80 = circuit_mul(t79, in0);
    let t81 = circuit_mul(t80, in0);
    let t82 = circuit_mul(t81, in0);
    let t83 = circuit_mul(t82, in0);
    let t84 = circuit_mul(t83, in0);
    let t85 = circuit_mul(t84, in0);
    let t86 = circuit_mul(t85, in0);
    let t87 = circuit_mul(t86, in0);
    let t88 = circuit_mul(t87, in0);
    let t89 = circuit_mul(t88, in0);
    let t90 = circuit_mul(t89, in0);
    let t91 = circuit_mul(t90, in0);
    let t92 = circuit_mul(t91, in0);
    let t93 = circuit_mul(t92, in0);
    let t94 = circuit_mul(t93, in0);
    let t95 = circuit_mul(t94, in0);
    let t96 = circuit_mul(t95, in0);
    let t97 = circuit_mul(t96, in0);
    let t98 = circuit_mul(t97, in0);
    let t99 = circuit_mul(t98, in0);
    let t100 = circuit_mul(t99, in0);
    let t101 = circuit_sub(in8, in1);
    let t102 = circuit_inverse(t101);
    let t103 = circuit_sub(t100, in1);
    let t104 = circuit_inverse(t103);
    let t105 = circuit_mul(in8, in8);
    let t106 = circuit_mul(t105, t105);
    let t107 = circuit_mul(t106, t106);
    let t108 = circuit_mul(t107, t107);
    let t109 = circuit_mul(t108, t108);
    let t110 = circuit_mul(t109, t109);
    let t111 = circuit_mul(t110, t110);
    let t112 = circuit_mul(t111, t111);
    let t113 = circuit_sub(t112, in1);
    let t114 = circuit_mul(t113, in2);
    let t115 = circuit_mul(in9, t114);
    let t116 = circuit_mul(t102, t114);
    let t117 = circuit_mul(t104, t114);
    let t118 = circuit_mul(t116, in6);
    let t119 = circuit_sub(in8, in0);
    let t120 = circuit_sub(in5, in6);
    let t121 = circuit_mul(in4, t115);
    let t122 = circuit_sub(t120, t121);
    let t123 = circuit_mul(t119, t122);
    let t124 = circuit_add(t118, t123);
    let t125 = circuit_sub(in6, in3);
    let t126 = circuit_mul(t117, t125);
    let t127 = circuit_add(t124, t126);
    let t128 = circuit_mul(t113, in7);
    let t129 = circuit_sub(t127, t128);

    let modulus = modulus;

    let mut circuit_inputs = (t113, t129).new_inputs();
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
    circuit_inputs = circuit_inputs.next_2(p_libra_evaluation);

    for val in p_libra_poly_evals {
        circuit_inputs = circuit_inputs.next_u256(*val);
    }
    circuit_inputs = circuit_inputs.next_2(tp_gemini_r);

    circuit_inputs = circuit_inputs.next_2(challenge_poly_eval);

    circuit_inputs = circuit_inputs.next_2(root_power_times_tp_gemini_r);

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let vanishing_check: u384 = outputs.get_output(t113);
    let diff_check: u384 = outputs.get_output(t129);
    return (vanishing_check, diff_check);
}

impl CircuitDefinition53<
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
    E44,
    E45,
    E46,
    E47,
    E48,
    E49,
    E50,
    E51,
    E52,
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
        CE<E44>,
        CE<E45>,
        CE<E46>,
        CE<E47>,
        CE<E48>,
        CE<E49>,
        CE<E50>,
        CE<E51>,
        CE<E52>,
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
                E44,
                E45,
                E46,
                E47,
                E48,
                E49,
                E50,
                E51,
                E52,
            ),
        >;
}
impl MyDrp_53<
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
    E44,
    E45,
    E46,
    E47,
    E48,
    E49,
    E50,
    E51,
    E52,
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
        CE<E44>,
        CE<E45>,
        CE<E46>,
        CE<E47>,
        CE<E48>,
        CE<E49>,
        CE<E50>,
        CE<E51>,
        CE<E52>,
    ),
>;

#[inline(never)]
pub fn is_on_curve_excluding_infinity_bn254(p: G1Point, modulus: CircuitModulus) -> bool {
    // INPUT stack
    // y^2 = x^3 + 3
    let (in0, in1) = (CE::<CI<0>> {}, CE::<CI<1>> {});
    let y2 = circuit_mul(in1, in1);
    let x2 = circuit_mul(in0, in0);
    let x3 = circuit_mul(in0, x2);
    let y2_minus_x3 = circuit_sub(y2, x3);

    let mut circuit_inputs = (y2_minus_x3,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(p.x); // in0
    circuit_inputs = circuit_inputs.next_2(p.y); // in1

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let zero_check: u384 = outputs.get_output(y2_minus_x3);
    return zero_check == u384 { limb0: 3, limb1: 0, limb2: 0, limb3: 0 };
}
