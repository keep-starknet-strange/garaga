use core::circuit::{
    CircuitElement as CE, CircuitInput as CI, CircuitInputs, CircuitModulus, CircuitOutputsTrait,
    EvalCircuitTrait, circuit_add, circuit_inverse, circuit_mul, circuit_sub, u384,
};
use garaga::core::circuit::{AddInputResultTrait2, IntoCircuitInputValue, u288IntoCircuitInputValue};
use garaga::definitions::G1Point;

#[inline(always)]
pub fn run_GRUMPKIN_ZK_HONK_SUMCHECK_SIZE_12_PUB_17_circuit(
    p_public_inputs: Span<u256>,
    p_pairing_point_object: Span<u256>,
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
    modulus: CircuitModulus,
) -> (u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x1
    let in1 = CE::<CI<1>> {}; // 0x1000
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
    let in17 = CE::<CI<17>> {}; // 0x11
    let in18 = CE::<CI<18>> {}; // 0x9
    let in19 = CE::<CI<19>> {}; // 0x100000000000000000
    let in20 = CE::<CI<20>> {}; // 0x4000
    let in21 = CE::<
        CI<21>,
    > {}; // 0x10dc6e9c006ea38b04b1e03b4bd9490c0d03f98929ca1d7fb56821fd19d3b6e7
    let in22 = CE::<CI<22>> {}; // 0xc28145b6a44df3e0149b3d0a30b3bb599df9756d4dd9b84a86b38cfb45a740b
    let in23 = CE::<CI<23>> {}; // 0x544b8338791518b2c7645a50392798b21f75bb60e3596170067d00141cac15
    let in24 = CE::<
        CI<24>,
    > {}; // 0x222c01175718386f2e2e82eb122789e352e105a3b8fa852613bc534433ee428b

    // INPUT stack
    let (in25, in26, in27) = (CE::<CI<25>> {}, CE::<CI<26>> {}, CE::<CI<27>> {});
    let (in28, in29, in30) = (CE::<CI<28>> {}, CE::<CI<29>> {}, CE::<CI<30>> {});
    let (in31, in32, in33) = (CE::<CI<31>> {}, CE::<CI<32>> {}, CE::<CI<33>> {});
    let (in34, in35, in36) = (CE::<CI<34>> {}, CE::<CI<35>> {}, CE::<CI<36>> {});
    let (in37, in38, in39) = (CE::<CI<37>> {}, CE::<CI<38>> {}, CE::<CI<39>> {});
    let (in40, in41, in42) = (CE::<CI<40>> {}, CE::<CI<41>> {}, CE::<CI<42>> {});
    let (in43, in44, in45) = (CE::<CI<43>> {}, CE::<CI<44>> {}, CE::<CI<45>> {});
    let (in46, in47, in48) = (CE::<CI<46>> {}, CE::<CI<47>> {}, CE::<CI<48>> {});
    let (in49, in50, in51) = (CE::<CI<49>> {}, CE::<CI<50>> {}, CE::<CI<51>> {});
    let (in52, in53, in54) = (CE::<CI<52>> {}, CE::<CI<53>> {}, CE::<CI<54>> {});
    let (in55, in56, in57) = (CE::<CI<55>> {}, CE::<CI<56>> {}, CE::<CI<57>> {});
    let (in58, in59, in60) = (CE::<CI<58>> {}, CE::<CI<59>> {}, CE::<CI<60>> {});
    let (in61, in62, in63) = (CE::<CI<61>> {}, CE::<CI<62>> {}, CE::<CI<63>> {});
    let (in64, in65, in66) = (CE::<CI<64>> {}, CE::<CI<65>> {}, CE::<CI<66>> {});
    let (in67, in68, in69) = (CE::<CI<67>> {}, CE::<CI<68>> {}, CE::<CI<69>> {});
    let (in70, in71, in72) = (CE::<CI<70>> {}, CE::<CI<71>> {}, CE::<CI<72>> {});
    let (in73, in74, in75) = (CE::<CI<73>> {}, CE::<CI<74>> {}, CE::<CI<75>> {});
    let (in76, in77, in78) = (CE::<CI<76>> {}, CE::<CI<77>> {}, CE::<CI<78>> {});
    let (in79, in80, in81) = (CE::<CI<79>> {}, CE::<CI<80>> {}, CE::<CI<81>> {});
    let (in82, in83, in84) = (CE::<CI<82>> {}, CE::<CI<83>> {}, CE::<CI<84>> {});
    let (in85, in86, in87) = (CE::<CI<85>> {}, CE::<CI<86>> {}, CE::<CI<87>> {});
    let (in88, in89, in90) = (CE::<CI<88>> {}, CE::<CI<89>> {}, CE::<CI<90>> {});
    let (in91, in92, in93) = (CE::<CI<91>> {}, CE::<CI<92>> {}, CE::<CI<93>> {});
    let (in94, in95, in96) = (CE::<CI<94>> {}, CE::<CI<95>> {}, CE::<CI<96>> {});
    let (in97, in98, in99) = (CE::<CI<97>> {}, CE::<CI<98>> {}, CE::<CI<99>> {});
    let (in100, in101, in102) = (CE::<CI<100>> {}, CE::<CI<101>> {}, CE::<CI<102>> {});
    let (in103, in104, in105) = (CE::<CI<103>> {}, CE::<CI<104>> {}, CE::<CI<105>> {});
    let (in106, in107, in108) = (CE::<CI<106>> {}, CE::<CI<107>> {}, CE::<CI<108>> {});
    let (in109, in110, in111) = (CE::<CI<109>> {}, CE::<CI<110>> {}, CE::<CI<111>> {});
    let (in112, in113, in114) = (CE::<CI<112>> {}, CE::<CI<113>> {}, CE::<CI<114>> {});
    let (in115, in116, in117) = (CE::<CI<115>> {}, CE::<CI<116>> {}, CE::<CI<117>> {});
    let (in118, in119, in120) = (CE::<CI<118>> {}, CE::<CI<119>> {}, CE::<CI<120>> {});
    let (in121, in122, in123) = (CE::<CI<121>> {}, CE::<CI<122>> {}, CE::<CI<123>> {});
    let (in124, in125, in126) = (CE::<CI<124>> {}, CE::<CI<125>> {}, CE::<CI<126>> {});
    let (in127, in128, in129) = (CE::<CI<127>> {}, CE::<CI<128>> {}, CE::<CI<129>> {});
    let (in130, in131, in132) = (CE::<CI<130>> {}, CE::<CI<131>> {}, CE::<CI<132>> {});
    let (in133, in134, in135) = (CE::<CI<133>> {}, CE::<CI<134>> {}, CE::<CI<135>> {});
    let (in136, in137, in138) = (CE::<CI<136>> {}, CE::<CI<137>> {}, CE::<CI<138>> {});
    let (in139, in140, in141) = (CE::<CI<139>> {}, CE::<CI<140>> {}, CE::<CI<141>> {});
    let (in142, in143, in144) = (CE::<CI<142>> {}, CE::<CI<143>> {}, CE::<CI<144>> {});
    let (in145, in146, in147) = (CE::<CI<145>> {}, CE::<CI<146>> {}, CE::<CI<147>> {});
    let (in148, in149, in150) = (CE::<CI<148>> {}, CE::<CI<149>> {}, CE::<CI<150>> {});
    let (in151, in152, in153) = (CE::<CI<151>> {}, CE::<CI<152>> {}, CE::<CI<153>> {});
    let (in154, in155, in156) = (CE::<CI<154>> {}, CE::<CI<155>> {}, CE::<CI<156>> {});
    let (in157, in158, in159) = (CE::<CI<157>> {}, CE::<CI<158>> {}, CE::<CI<159>> {});
    let (in160, in161, in162) = (CE::<CI<160>> {}, CE::<CI<161>> {}, CE::<CI<162>> {});
    let (in163, in164, in165) = (CE::<CI<163>> {}, CE::<CI<164>> {}, CE::<CI<165>> {});
    let (in166, in167, in168) = (CE::<CI<166>> {}, CE::<CI<167>> {}, CE::<CI<168>> {});
    let (in169, in170, in171) = (CE::<CI<169>> {}, CE::<CI<170>> {}, CE::<CI<171>> {});
    let (in172, in173, in174) = (CE::<CI<172>> {}, CE::<CI<173>> {}, CE::<CI<174>> {});
    let (in175, in176, in177) = (CE::<CI<175>> {}, CE::<CI<176>> {}, CE::<CI<177>> {});
    let (in178, in179, in180) = (CE::<CI<178>> {}, CE::<CI<179>> {}, CE::<CI<180>> {});
    let (in181, in182, in183) = (CE::<CI<181>> {}, CE::<CI<182>> {}, CE::<CI<183>> {});
    let (in184, in185, in186) = (CE::<CI<184>> {}, CE::<CI<185>> {}, CE::<CI<186>> {});
    let (in187, in188, in189) = (CE::<CI<187>> {}, CE::<CI<188>> {}, CE::<CI<189>> {});
    let (in190, in191, in192) = (CE::<CI<190>> {}, CE::<CI<191>> {}, CE::<CI<192>> {});
    let (in193, in194, in195) = (CE::<CI<193>> {}, CE::<CI<194>> {}, CE::<CI<195>> {});
    let (in196, in197, in198) = (CE::<CI<196>> {}, CE::<CI<197>> {}, CE::<CI<198>> {});
    let (in199, in200, in201) = (CE::<CI<199>> {}, CE::<CI<200>> {}, CE::<CI<201>> {});
    let (in202, in203, in204) = (CE::<CI<202>> {}, CE::<CI<203>> {}, CE::<CI<204>> {});
    let (in205, in206, in207) = (CE::<CI<205>> {}, CE::<CI<206>> {}, CE::<CI<207>> {});
    let (in208, in209, in210) = (CE::<CI<208>> {}, CE::<CI<209>> {}, CE::<CI<210>> {});
    let (in211, in212, in213) = (CE::<CI<211>> {}, CE::<CI<212>> {}, CE::<CI<213>> {});
    let (in214, in215, in216) = (CE::<CI<214>> {}, CE::<CI<215>> {}, CE::<CI<216>> {});
    let (in217, in218, in219) = (CE::<CI<217>> {}, CE::<CI<218>> {}, CE::<CI<219>> {});
    let (in220, in221, in222) = (CE::<CI<220>> {}, CE::<CI<221>> {}, CE::<CI<222>> {});
    let (in223, in224, in225) = (CE::<CI<223>> {}, CE::<CI<224>> {}, CE::<CI<225>> {});
    let (in226, in227, in228) = (CE::<CI<226>> {}, CE::<CI<227>> {}, CE::<CI<228>> {});
    let (in229, in230, in231) = (CE::<CI<229>> {}, CE::<CI<230>> {}, CE::<CI<231>> {});
    let (in232, in233, in234) = (CE::<CI<232>> {}, CE::<CI<233>> {}, CE::<CI<234>> {});
    let (in235, in236, in237) = (CE::<CI<235>> {}, CE::<CI<236>> {}, CE::<CI<237>> {});
    let (in238, in239, in240) = (CE::<CI<238>> {}, CE::<CI<239>> {}, CE::<CI<240>> {});
    let (in241, in242, in243) = (CE::<CI<241>> {}, CE::<CI<242>> {}, CE::<CI<243>> {});
    let (in244, in245, in246) = (CE::<CI<244>> {}, CE::<CI<245>> {}, CE::<CI<246>> {});
    let (in247, in248) = (CE::<CI<247>> {}, CE::<CI<248>> {});
    let t0 = circuit_add(in1, in42);
    let t1 = circuit_mul(in220, t0);
    let t2 = circuit_add(in221, t1);
    let t3 = circuit_add(in42, in0);
    let t4 = circuit_mul(in220, t3);
    let t5 = circuit_sub(in221, t4);
    let t6 = circuit_add(t2, in25);
    let t7 = circuit_mul(in0, t6);
    let t8 = circuit_add(t5, in25);
    let t9 = circuit_mul(in0, t8);
    let t10 = circuit_add(t2, in220);
    let t11 = circuit_sub(t5, in220);
    let t12 = circuit_add(t10, in26);
    let t13 = circuit_mul(t7, t12);
    let t14 = circuit_add(t11, in26);
    let t15 = circuit_mul(t9, t14);
    let t16 = circuit_add(t10, in220);
    let t17 = circuit_sub(t11, in220);
    let t18 = circuit_add(t16, in27);
    let t19 = circuit_mul(t13, t18);
    let t20 = circuit_add(t17, in27);
    let t21 = circuit_mul(t15, t20);
    let t22 = circuit_add(t16, in220);
    let t23 = circuit_sub(t17, in220);
    let t24 = circuit_add(t22, in28);
    let t25 = circuit_mul(t19, t24);
    let t26 = circuit_add(t23, in28);
    let t27 = circuit_mul(t21, t26);
    let t28 = circuit_add(t22, in220);
    let t29 = circuit_sub(t23, in220);
    let t30 = circuit_add(t28, in29);
    let t31 = circuit_mul(t25, t30);
    let t32 = circuit_add(t29, in29);
    let t33 = circuit_mul(t27, t32);
    let t34 = circuit_add(t28, in220);
    let t35 = circuit_sub(t29, in220);
    let t36 = circuit_add(t34, in30);
    let t37 = circuit_mul(t31, t36);
    let t38 = circuit_add(t35, in30);
    let t39 = circuit_mul(t33, t38);
    let t40 = circuit_add(t34, in220);
    let t41 = circuit_sub(t35, in220);
    let t42 = circuit_add(t40, in31);
    let t43 = circuit_mul(t37, t42);
    let t44 = circuit_add(t41, in31);
    let t45 = circuit_mul(t39, t44);
    let t46 = circuit_add(t40, in220);
    let t47 = circuit_sub(t41, in220);
    let t48 = circuit_add(t46, in32);
    let t49 = circuit_mul(t43, t48);
    let t50 = circuit_add(t47, in32);
    let t51 = circuit_mul(t45, t50);
    let t52 = circuit_add(t46, in220);
    let t53 = circuit_sub(t47, in220);
    let t54 = circuit_add(t52, in33);
    let t55 = circuit_mul(t49, t54);
    let t56 = circuit_add(t53, in33);
    let t57 = circuit_mul(t51, t56);
    let t58 = circuit_add(t52, in220);
    let t59 = circuit_sub(t53, in220);
    let t60 = circuit_add(t58, in34);
    let t61 = circuit_mul(t55, t60);
    let t62 = circuit_add(t59, in34);
    let t63 = circuit_mul(t57, t62);
    let t64 = circuit_add(t58, in220);
    let t65 = circuit_sub(t59, in220);
    let t66 = circuit_add(t64, in35);
    let t67 = circuit_mul(t61, t66);
    let t68 = circuit_add(t65, in35);
    let t69 = circuit_mul(t63, t68);
    let t70 = circuit_add(t64, in220);
    let t71 = circuit_sub(t65, in220);
    let t72 = circuit_add(t70, in36);
    let t73 = circuit_mul(t67, t72);
    let t74 = circuit_add(t71, in36);
    let t75 = circuit_mul(t69, t74);
    let t76 = circuit_add(t70, in220);
    let t77 = circuit_sub(t71, in220);
    let t78 = circuit_add(t76, in37);
    let t79 = circuit_mul(t73, t78);
    let t80 = circuit_add(t77, in37);
    let t81 = circuit_mul(t75, t80);
    let t82 = circuit_add(t76, in220);
    let t83 = circuit_sub(t77, in220);
    let t84 = circuit_add(t82, in38);
    let t85 = circuit_mul(t79, t84);
    let t86 = circuit_add(t83, in38);
    let t87 = circuit_mul(t81, t86);
    let t88 = circuit_add(t82, in220);
    let t89 = circuit_sub(t83, in220);
    let t90 = circuit_add(t88, in39);
    let t91 = circuit_mul(t85, t90);
    let t92 = circuit_add(t89, in39);
    let t93 = circuit_mul(t87, t92);
    let t94 = circuit_add(t88, in220);
    let t95 = circuit_sub(t89, in220);
    let t96 = circuit_add(t94, in40);
    let t97 = circuit_mul(t91, t96);
    let t98 = circuit_add(t95, in40);
    let t99 = circuit_mul(t93, t98);
    let t100 = circuit_add(t94, in220);
    let t101 = circuit_sub(t95, in220);
    let t102 = circuit_add(t100, in41);
    let t103 = circuit_mul(t97, t102);
    let t104 = circuit_add(t101, in41);
    let t105 = circuit_mul(t99, t104);
    let t106 = circuit_inverse(t105);
    let t107 = circuit_mul(t103, t106);
    let t108 = circuit_mul(in248, in43);
    let t109 = circuit_add(in44, in45);
    let t110 = circuit_sub(t109, t108);
    let t111 = circuit_mul(t110, in222);
    let t112 = circuit_mul(in222, in222);
    let t113 = circuit_sub(in193, in7);
    let t114 = circuit_mul(in0, t113);
    let t115 = circuit_sub(in193, in7);
    let t116 = circuit_mul(in2, t115);
    let t117 = circuit_inverse(t116);
    let t118 = circuit_mul(in44, t117);
    let t119 = circuit_add(in7, t118);
    let t120 = circuit_sub(in193, in0);
    let t121 = circuit_mul(t114, t120);
    let t122 = circuit_sub(in193, in0);
    let t123 = circuit_mul(in3, t122);
    let t124 = circuit_inverse(t123);
    let t125 = circuit_mul(in45, t124);
    let t126 = circuit_add(t119, t125);
    let t127 = circuit_sub(in193, in8);
    let t128 = circuit_mul(t121, t127);
    let t129 = circuit_sub(in193, in8);
    let t130 = circuit_mul(in4, t129);
    let t131 = circuit_inverse(t130);
    let t132 = circuit_mul(in46, t131);
    let t133 = circuit_add(t126, t132);
    let t134 = circuit_sub(in193, in9);
    let t135 = circuit_mul(t128, t134);
    let t136 = circuit_sub(in193, in9);
    let t137 = circuit_mul(in5, t136);
    let t138 = circuit_inverse(t137);
    let t139 = circuit_mul(in47, t138);
    let t140 = circuit_add(t133, t139);
    let t141 = circuit_sub(in193, in10);
    let t142 = circuit_mul(t135, t141);
    let t143 = circuit_sub(in193, in10);
    let t144 = circuit_mul(in6, t143);
    let t145 = circuit_inverse(t144);
    let t146 = circuit_mul(in48, t145);
    let t147 = circuit_add(t140, t146);
    let t148 = circuit_sub(in193, in11);
    let t149 = circuit_mul(t142, t148);
    let t150 = circuit_sub(in193, in11);
    let t151 = circuit_mul(in5, t150);
    let t152 = circuit_inverse(t151);
    let t153 = circuit_mul(in49, t152);
    let t154 = circuit_add(t147, t153);
    let t155 = circuit_sub(in193, in12);
    let t156 = circuit_mul(t149, t155);
    let t157 = circuit_sub(in193, in12);
    let t158 = circuit_mul(in4, t157);
    let t159 = circuit_inverse(t158);
    let t160 = circuit_mul(in50, t159);
    let t161 = circuit_add(t154, t160);
    let t162 = circuit_sub(in193, in13);
    let t163 = circuit_mul(t156, t162);
    let t164 = circuit_sub(in193, in13);
    let t165 = circuit_mul(in3, t164);
    let t166 = circuit_inverse(t165);
    let t167 = circuit_mul(in51, t166);
    let t168 = circuit_add(t161, t167);
    let t169 = circuit_sub(in193, in14);
    let t170 = circuit_mul(t163, t169);
    let t171 = circuit_sub(in193, in14);
    let t172 = circuit_mul(in2, t171);
    let t173 = circuit_inverse(t172);
    let t174 = circuit_mul(in52, t173);
    let t175 = circuit_add(t168, t174);
    let t176 = circuit_mul(t175, t170);
    let t177 = circuit_sub(in205, in0);
    let t178 = circuit_mul(in193, t177);
    let t179 = circuit_add(in0, t178);
    let t180 = circuit_mul(in0, t179);
    let t181 = circuit_add(in53, in54);
    let t182 = circuit_sub(t181, t176);
    let t183 = circuit_mul(t182, t112);
    let t184 = circuit_add(t111, t183);
    let t185 = circuit_mul(t112, in222);
    let t186 = circuit_sub(in194, in7);
    let t187 = circuit_mul(in0, t186);
    let t188 = circuit_sub(in194, in7);
    let t189 = circuit_mul(in2, t188);
    let t190 = circuit_inverse(t189);
    let t191 = circuit_mul(in53, t190);
    let t192 = circuit_add(in7, t191);
    let t193 = circuit_sub(in194, in0);
    let t194 = circuit_mul(t187, t193);
    let t195 = circuit_sub(in194, in0);
    let t196 = circuit_mul(in3, t195);
    let t197 = circuit_inverse(t196);
    let t198 = circuit_mul(in54, t197);
    let t199 = circuit_add(t192, t198);
    let t200 = circuit_sub(in194, in8);
    let t201 = circuit_mul(t194, t200);
    let t202 = circuit_sub(in194, in8);
    let t203 = circuit_mul(in4, t202);
    let t204 = circuit_inverse(t203);
    let t205 = circuit_mul(in55, t204);
    let t206 = circuit_add(t199, t205);
    let t207 = circuit_sub(in194, in9);
    let t208 = circuit_mul(t201, t207);
    let t209 = circuit_sub(in194, in9);
    let t210 = circuit_mul(in5, t209);
    let t211 = circuit_inverse(t210);
    let t212 = circuit_mul(in56, t211);
    let t213 = circuit_add(t206, t212);
    let t214 = circuit_sub(in194, in10);
    let t215 = circuit_mul(t208, t214);
    let t216 = circuit_sub(in194, in10);
    let t217 = circuit_mul(in6, t216);
    let t218 = circuit_inverse(t217);
    let t219 = circuit_mul(in57, t218);
    let t220 = circuit_add(t213, t219);
    let t221 = circuit_sub(in194, in11);
    let t222 = circuit_mul(t215, t221);
    let t223 = circuit_sub(in194, in11);
    let t224 = circuit_mul(in5, t223);
    let t225 = circuit_inverse(t224);
    let t226 = circuit_mul(in58, t225);
    let t227 = circuit_add(t220, t226);
    let t228 = circuit_sub(in194, in12);
    let t229 = circuit_mul(t222, t228);
    let t230 = circuit_sub(in194, in12);
    let t231 = circuit_mul(in4, t230);
    let t232 = circuit_inverse(t231);
    let t233 = circuit_mul(in59, t232);
    let t234 = circuit_add(t227, t233);
    let t235 = circuit_sub(in194, in13);
    let t236 = circuit_mul(t229, t235);
    let t237 = circuit_sub(in194, in13);
    let t238 = circuit_mul(in3, t237);
    let t239 = circuit_inverse(t238);
    let t240 = circuit_mul(in60, t239);
    let t241 = circuit_add(t234, t240);
    let t242 = circuit_sub(in194, in14);
    let t243 = circuit_mul(t236, t242);
    let t244 = circuit_sub(in194, in14);
    let t245 = circuit_mul(in2, t244);
    let t246 = circuit_inverse(t245);
    let t247 = circuit_mul(in61, t246);
    let t248 = circuit_add(t241, t247);
    let t249 = circuit_mul(t248, t243);
    let t250 = circuit_sub(in206, in0);
    let t251 = circuit_mul(in194, t250);
    let t252 = circuit_add(in0, t251);
    let t253 = circuit_mul(t180, t252);
    let t254 = circuit_add(in62, in63);
    let t255 = circuit_sub(t254, t249);
    let t256 = circuit_mul(t255, t185);
    let t257 = circuit_add(t184, t256);
    let t258 = circuit_mul(t185, in222);
    let t259 = circuit_sub(in195, in7);
    let t260 = circuit_mul(in0, t259);
    let t261 = circuit_sub(in195, in7);
    let t262 = circuit_mul(in2, t261);
    let t263 = circuit_inverse(t262);
    let t264 = circuit_mul(in62, t263);
    let t265 = circuit_add(in7, t264);
    let t266 = circuit_sub(in195, in0);
    let t267 = circuit_mul(t260, t266);
    let t268 = circuit_sub(in195, in0);
    let t269 = circuit_mul(in3, t268);
    let t270 = circuit_inverse(t269);
    let t271 = circuit_mul(in63, t270);
    let t272 = circuit_add(t265, t271);
    let t273 = circuit_sub(in195, in8);
    let t274 = circuit_mul(t267, t273);
    let t275 = circuit_sub(in195, in8);
    let t276 = circuit_mul(in4, t275);
    let t277 = circuit_inverse(t276);
    let t278 = circuit_mul(in64, t277);
    let t279 = circuit_add(t272, t278);
    let t280 = circuit_sub(in195, in9);
    let t281 = circuit_mul(t274, t280);
    let t282 = circuit_sub(in195, in9);
    let t283 = circuit_mul(in5, t282);
    let t284 = circuit_inverse(t283);
    let t285 = circuit_mul(in65, t284);
    let t286 = circuit_add(t279, t285);
    let t287 = circuit_sub(in195, in10);
    let t288 = circuit_mul(t281, t287);
    let t289 = circuit_sub(in195, in10);
    let t290 = circuit_mul(in6, t289);
    let t291 = circuit_inverse(t290);
    let t292 = circuit_mul(in66, t291);
    let t293 = circuit_add(t286, t292);
    let t294 = circuit_sub(in195, in11);
    let t295 = circuit_mul(t288, t294);
    let t296 = circuit_sub(in195, in11);
    let t297 = circuit_mul(in5, t296);
    let t298 = circuit_inverse(t297);
    let t299 = circuit_mul(in67, t298);
    let t300 = circuit_add(t293, t299);
    let t301 = circuit_sub(in195, in12);
    let t302 = circuit_mul(t295, t301);
    let t303 = circuit_sub(in195, in12);
    let t304 = circuit_mul(in4, t303);
    let t305 = circuit_inverse(t304);
    let t306 = circuit_mul(in68, t305);
    let t307 = circuit_add(t300, t306);
    let t308 = circuit_sub(in195, in13);
    let t309 = circuit_mul(t302, t308);
    let t310 = circuit_sub(in195, in13);
    let t311 = circuit_mul(in3, t310);
    let t312 = circuit_inverse(t311);
    let t313 = circuit_mul(in69, t312);
    let t314 = circuit_add(t307, t313);
    let t315 = circuit_sub(in195, in14);
    let t316 = circuit_mul(t309, t315);
    let t317 = circuit_sub(in195, in14);
    let t318 = circuit_mul(in2, t317);
    let t319 = circuit_inverse(t318);
    let t320 = circuit_mul(in70, t319);
    let t321 = circuit_add(t314, t320);
    let t322 = circuit_mul(t321, t316);
    let t323 = circuit_sub(in207, in0);
    let t324 = circuit_mul(in195, t323);
    let t325 = circuit_add(in0, t324);
    let t326 = circuit_mul(t253, t325);
    let t327 = circuit_add(in71, in72);
    let t328 = circuit_sub(t327, t322);
    let t329 = circuit_mul(t328, t258);
    let t330 = circuit_add(t257, t329);
    let t331 = circuit_mul(t258, in222);
    let t332 = circuit_sub(in196, in7);
    let t333 = circuit_mul(in0, t332);
    let t334 = circuit_sub(in196, in7);
    let t335 = circuit_mul(in2, t334);
    let t336 = circuit_inverse(t335);
    let t337 = circuit_mul(in71, t336);
    let t338 = circuit_add(in7, t337);
    let t339 = circuit_sub(in196, in0);
    let t340 = circuit_mul(t333, t339);
    let t341 = circuit_sub(in196, in0);
    let t342 = circuit_mul(in3, t341);
    let t343 = circuit_inverse(t342);
    let t344 = circuit_mul(in72, t343);
    let t345 = circuit_add(t338, t344);
    let t346 = circuit_sub(in196, in8);
    let t347 = circuit_mul(t340, t346);
    let t348 = circuit_sub(in196, in8);
    let t349 = circuit_mul(in4, t348);
    let t350 = circuit_inverse(t349);
    let t351 = circuit_mul(in73, t350);
    let t352 = circuit_add(t345, t351);
    let t353 = circuit_sub(in196, in9);
    let t354 = circuit_mul(t347, t353);
    let t355 = circuit_sub(in196, in9);
    let t356 = circuit_mul(in5, t355);
    let t357 = circuit_inverse(t356);
    let t358 = circuit_mul(in74, t357);
    let t359 = circuit_add(t352, t358);
    let t360 = circuit_sub(in196, in10);
    let t361 = circuit_mul(t354, t360);
    let t362 = circuit_sub(in196, in10);
    let t363 = circuit_mul(in6, t362);
    let t364 = circuit_inverse(t363);
    let t365 = circuit_mul(in75, t364);
    let t366 = circuit_add(t359, t365);
    let t367 = circuit_sub(in196, in11);
    let t368 = circuit_mul(t361, t367);
    let t369 = circuit_sub(in196, in11);
    let t370 = circuit_mul(in5, t369);
    let t371 = circuit_inverse(t370);
    let t372 = circuit_mul(in76, t371);
    let t373 = circuit_add(t366, t372);
    let t374 = circuit_sub(in196, in12);
    let t375 = circuit_mul(t368, t374);
    let t376 = circuit_sub(in196, in12);
    let t377 = circuit_mul(in4, t376);
    let t378 = circuit_inverse(t377);
    let t379 = circuit_mul(in77, t378);
    let t380 = circuit_add(t373, t379);
    let t381 = circuit_sub(in196, in13);
    let t382 = circuit_mul(t375, t381);
    let t383 = circuit_sub(in196, in13);
    let t384 = circuit_mul(in3, t383);
    let t385 = circuit_inverse(t384);
    let t386 = circuit_mul(in78, t385);
    let t387 = circuit_add(t380, t386);
    let t388 = circuit_sub(in196, in14);
    let t389 = circuit_mul(t382, t388);
    let t390 = circuit_sub(in196, in14);
    let t391 = circuit_mul(in2, t390);
    let t392 = circuit_inverse(t391);
    let t393 = circuit_mul(in79, t392);
    let t394 = circuit_add(t387, t393);
    let t395 = circuit_mul(t394, t389);
    let t396 = circuit_sub(in208, in0);
    let t397 = circuit_mul(in196, t396);
    let t398 = circuit_add(in0, t397);
    let t399 = circuit_mul(t326, t398);
    let t400 = circuit_add(in80, in81);
    let t401 = circuit_sub(t400, t395);
    let t402 = circuit_mul(t401, t331);
    let t403 = circuit_add(t330, t402);
    let t404 = circuit_mul(t331, in222);
    let t405 = circuit_sub(in197, in7);
    let t406 = circuit_mul(in0, t405);
    let t407 = circuit_sub(in197, in7);
    let t408 = circuit_mul(in2, t407);
    let t409 = circuit_inverse(t408);
    let t410 = circuit_mul(in80, t409);
    let t411 = circuit_add(in7, t410);
    let t412 = circuit_sub(in197, in0);
    let t413 = circuit_mul(t406, t412);
    let t414 = circuit_sub(in197, in0);
    let t415 = circuit_mul(in3, t414);
    let t416 = circuit_inverse(t415);
    let t417 = circuit_mul(in81, t416);
    let t418 = circuit_add(t411, t417);
    let t419 = circuit_sub(in197, in8);
    let t420 = circuit_mul(t413, t419);
    let t421 = circuit_sub(in197, in8);
    let t422 = circuit_mul(in4, t421);
    let t423 = circuit_inverse(t422);
    let t424 = circuit_mul(in82, t423);
    let t425 = circuit_add(t418, t424);
    let t426 = circuit_sub(in197, in9);
    let t427 = circuit_mul(t420, t426);
    let t428 = circuit_sub(in197, in9);
    let t429 = circuit_mul(in5, t428);
    let t430 = circuit_inverse(t429);
    let t431 = circuit_mul(in83, t430);
    let t432 = circuit_add(t425, t431);
    let t433 = circuit_sub(in197, in10);
    let t434 = circuit_mul(t427, t433);
    let t435 = circuit_sub(in197, in10);
    let t436 = circuit_mul(in6, t435);
    let t437 = circuit_inverse(t436);
    let t438 = circuit_mul(in84, t437);
    let t439 = circuit_add(t432, t438);
    let t440 = circuit_sub(in197, in11);
    let t441 = circuit_mul(t434, t440);
    let t442 = circuit_sub(in197, in11);
    let t443 = circuit_mul(in5, t442);
    let t444 = circuit_inverse(t443);
    let t445 = circuit_mul(in85, t444);
    let t446 = circuit_add(t439, t445);
    let t447 = circuit_sub(in197, in12);
    let t448 = circuit_mul(t441, t447);
    let t449 = circuit_sub(in197, in12);
    let t450 = circuit_mul(in4, t449);
    let t451 = circuit_inverse(t450);
    let t452 = circuit_mul(in86, t451);
    let t453 = circuit_add(t446, t452);
    let t454 = circuit_sub(in197, in13);
    let t455 = circuit_mul(t448, t454);
    let t456 = circuit_sub(in197, in13);
    let t457 = circuit_mul(in3, t456);
    let t458 = circuit_inverse(t457);
    let t459 = circuit_mul(in87, t458);
    let t460 = circuit_add(t453, t459);
    let t461 = circuit_sub(in197, in14);
    let t462 = circuit_mul(t455, t461);
    let t463 = circuit_sub(in197, in14);
    let t464 = circuit_mul(in2, t463);
    let t465 = circuit_inverse(t464);
    let t466 = circuit_mul(in88, t465);
    let t467 = circuit_add(t460, t466);
    let t468 = circuit_mul(t467, t462);
    let t469 = circuit_sub(in209, in0);
    let t470 = circuit_mul(in197, t469);
    let t471 = circuit_add(in0, t470);
    let t472 = circuit_mul(t399, t471);
    let t473 = circuit_add(in89, in90);
    let t474 = circuit_sub(t473, t468);
    let t475 = circuit_mul(t474, t404);
    let t476 = circuit_add(t403, t475);
    let t477 = circuit_mul(t404, in222);
    let t478 = circuit_sub(in198, in7);
    let t479 = circuit_mul(in0, t478);
    let t480 = circuit_sub(in198, in7);
    let t481 = circuit_mul(in2, t480);
    let t482 = circuit_inverse(t481);
    let t483 = circuit_mul(in89, t482);
    let t484 = circuit_add(in7, t483);
    let t485 = circuit_sub(in198, in0);
    let t486 = circuit_mul(t479, t485);
    let t487 = circuit_sub(in198, in0);
    let t488 = circuit_mul(in3, t487);
    let t489 = circuit_inverse(t488);
    let t490 = circuit_mul(in90, t489);
    let t491 = circuit_add(t484, t490);
    let t492 = circuit_sub(in198, in8);
    let t493 = circuit_mul(t486, t492);
    let t494 = circuit_sub(in198, in8);
    let t495 = circuit_mul(in4, t494);
    let t496 = circuit_inverse(t495);
    let t497 = circuit_mul(in91, t496);
    let t498 = circuit_add(t491, t497);
    let t499 = circuit_sub(in198, in9);
    let t500 = circuit_mul(t493, t499);
    let t501 = circuit_sub(in198, in9);
    let t502 = circuit_mul(in5, t501);
    let t503 = circuit_inverse(t502);
    let t504 = circuit_mul(in92, t503);
    let t505 = circuit_add(t498, t504);
    let t506 = circuit_sub(in198, in10);
    let t507 = circuit_mul(t500, t506);
    let t508 = circuit_sub(in198, in10);
    let t509 = circuit_mul(in6, t508);
    let t510 = circuit_inverse(t509);
    let t511 = circuit_mul(in93, t510);
    let t512 = circuit_add(t505, t511);
    let t513 = circuit_sub(in198, in11);
    let t514 = circuit_mul(t507, t513);
    let t515 = circuit_sub(in198, in11);
    let t516 = circuit_mul(in5, t515);
    let t517 = circuit_inverse(t516);
    let t518 = circuit_mul(in94, t517);
    let t519 = circuit_add(t512, t518);
    let t520 = circuit_sub(in198, in12);
    let t521 = circuit_mul(t514, t520);
    let t522 = circuit_sub(in198, in12);
    let t523 = circuit_mul(in4, t522);
    let t524 = circuit_inverse(t523);
    let t525 = circuit_mul(in95, t524);
    let t526 = circuit_add(t519, t525);
    let t527 = circuit_sub(in198, in13);
    let t528 = circuit_mul(t521, t527);
    let t529 = circuit_sub(in198, in13);
    let t530 = circuit_mul(in3, t529);
    let t531 = circuit_inverse(t530);
    let t532 = circuit_mul(in96, t531);
    let t533 = circuit_add(t526, t532);
    let t534 = circuit_sub(in198, in14);
    let t535 = circuit_mul(t528, t534);
    let t536 = circuit_sub(in198, in14);
    let t537 = circuit_mul(in2, t536);
    let t538 = circuit_inverse(t537);
    let t539 = circuit_mul(in97, t538);
    let t540 = circuit_add(t533, t539);
    let t541 = circuit_mul(t540, t535);
    let t542 = circuit_sub(in210, in0);
    let t543 = circuit_mul(in198, t542);
    let t544 = circuit_add(in0, t543);
    let t545 = circuit_mul(t472, t544);
    let t546 = circuit_add(in98, in99);
    let t547 = circuit_sub(t546, t541);
    let t548 = circuit_mul(t547, t477);
    let t549 = circuit_add(t476, t548);
    let t550 = circuit_mul(t477, in222);
    let t551 = circuit_sub(in199, in7);
    let t552 = circuit_mul(in0, t551);
    let t553 = circuit_sub(in199, in7);
    let t554 = circuit_mul(in2, t553);
    let t555 = circuit_inverse(t554);
    let t556 = circuit_mul(in98, t555);
    let t557 = circuit_add(in7, t556);
    let t558 = circuit_sub(in199, in0);
    let t559 = circuit_mul(t552, t558);
    let t560 = circuit_sub(in199, in0);
    let t561 = circuit_mul(in3, t560);
    let t562 = circuit_inverse(t561);
    let t563 = circuit_mul(in99, t562);
    let t564 = circuit_add(t557, t563);
    let t565 = circuit_sub(in199, in8);
    let t566 = circuit_mul(t559, t565);
    let t567 = circuit_sub(in199, in8);
    let t568 = circuit_mul(in4, t567);
    let t569 = circuit_inverse(t568);
    let t570 = circuit_mul(in100, t569);
    let t571 = circuit_add(t564, t570);
    let t572 = circuit_sub(in199, in9);
    let t573 = circuit_mul(t566, t572);
    let t574 = circuit_sub(in199, in9);
    let t575 = circuit_mul(in5, t574);
    let t576 = circuit_inverse(t575);
    let t577 = circuit_mul(in101, t576);
    let t578 = circuit_add(t571, t577);
    let t579 = circuit_sub(in199, in10);
    let t580 = circuit_mul(t573, t579);
    let t581 = circuit_sub(in199, in10);
    let t582 = circuit_mul(in6, t581);
    let t583 = circuit_inverse(t582);
    let t584 = circuit_mul(in102, t583);
    let t585 = circuit_add(t578, t584);
    let t586 = circuit_sub(in199, in11);
    let t587 = circuit_mul(t580, t586);
    let t588 = circuit_sub(in199, in11);
    let t589 = circuit_mul(in5, t588);
    let t590 = circuit_inverse(t589);
    let t591 = circuit_mul(in103, t590);
    let t592 = circuit_add(t585, t591);
    let t593 = circuit_sub(in199, in12);
    let t594 = circuit_mul(t587, t593);
    let t595 = circuit_sub(in199, in12);
    let t596 = circuit_mul(in4, t595);
    let t597 = circuit_inverse(t596);
    let t598 = circuit_mul(in104, t597);
    let t599 = circuit_add(t592, t598);
    let t600 = circuit_sub(in199, in13);
    let t601 = circuit_mul(t594, t600);
    let t602 = circuit_sub(in199, in13);
    let t603 = circuit_mul(in3, t602);
    let t604 = circuit_inverse(t603);
    let t605 = circuit_mul(in105, t604);
    let t606 = circuit_add(t599, t605);
    let t607 = circuit_sub(in199, in14);
    let t608 = circuit_mul(t601, t607);
    let t609 = circuit_sub(in199, in14);
    let t610 = circuit_mul(in2, t609);
    let t611 = circuit_inverse(t610);
    let t612 = circuit_mul(in106, t611);
    let t613 = circuit_add(t606, t612);
    let t614 = circuit_mul(t613, t608);
    let t615 = circuit_sub(in211, in0);
    let t616 = circuit_mul(in199, t615);
    let t617 = circuit_add(in0, t616);
    let t618 = circuit_mul(t545, t617);
    let t619 = circuit_add(in107, in108);
    let t620 = circuit_sub(t619, t614);
    let t621 = circuit_mul(t620, t550);
    let t622 = circuit_add(t549, t621);
    let t623 = circuit_mul(t550, in222);
    let t624 = circuit_sub(in200, in7);
    let t625 = circuit_mul(in0, t624);
    let t626 = circuit_sub(in200, in7);
    let t627 = circuit_mul(in2, t626);
    let t628 = circuit_inverse(t627);
    let t629 = circuit_mul(in107, t628);
    let t630 = circuit_add(in7, t629);
    let t631 = circuit_sub(in200, in0);
    let t632 = circuit_mul(t625, t631);
    let t633 = circuit_sub(in200, in0);
    let t634 = circuit_mul(in3, t633);
    let t635 = circuit_inverse(t634);
    let t636 = circuit_mul(in108, t635);
    let t637 = circuit_add(t630, t636);
    let t638 = circuit_sub(in200, in8);
    let t639 = circuit_mul(t632, t638);
    let t640 = circuit_sub(in200, in8);
    let t641 = circuit_mul(in4, t640);
    let t642 = circuit_inverse(t641);
    let t643 = circuit_mul(in109, t642);
    let t644 = circuit_add(t637, t643);
    let t645 = circuit_sub(in200, in9);
    let t646 = circuit_mul(t639, t645);
    let t647 = circuit_sub(in200, in9);
    let t648 = circuit_mul(in5, t647);
    let t649 = circuit_inverse(t648);
    let t650 = circuit_mul(in110, t649);
    let t651 = circuit_add(t644, t650);
    let t652 = circuit_sub(in200, in10);
    let t653 = circuit_mul(t646, t652);
    let t654 = circuit_sub(in200, in10);
    let t655 = circuit_mul(in6, t654);
    let t656 = circuit_inverse(t655);
    let t657 = circuit_mul(in111, t656);
    let t658 = circuit_add(t651, t657);
    let t659 = circuit_sub(in200, in11);
    let t660 = circuit_mul(t653, t659);
    let t661 = circuit_sub(in200, in11);
    let t662 = circuit_mul(in5, t661);
    let t663 = circuit_inverse(t662);
    let t664 = circuit_mul(in112, t663);
    let t665 = circuit_add(t658, t664);
    let t666 = circuit_sub(in200, in12);
    let t667 = circuit_mul(t660, t666);
    let t668 = circuit_sub(in200, in12);
    let t669 = circuit_mul(in4, t668);
    let t670 = circuit_inverse(t669);
    let t671 = circuit_mul(in113, t670);
    let t672 = circuit_add(t665, t671);
    let t673 = circuit_sub(in200, in13);
    let t674 = circuit_mul(t667, t673);
    let t675 = circuit_sub(in200, in13);
    let t676 = circuit_mul(in3, t675);
    let t677 = circuit_inverse(t676);
    let t678 = circuit_mul(in114, t677);
    let t679 = circuit_add(t672, t678);
    let t680 = circuit_sub(in200, in14);
    let t681 = circuit_mul(t674, t680);
    let t682 = circuit_sub(in200, in14);
    let t683 = circuit_mul(in2, t682);
    let t684 = circuit_inverse(t683);
    let t685 = circuit_mul(in115, t684);
    let t686 = circuit_add(t679, t685);
    let t687 = circuit_mul(t686, t681);
    let t688 = circuit_sub(in212, in0);
    let t689 = circuit_mul(in200, t688);
    let t690 = circuit_add(in0, t689);
    let t691 = circuit_mul(t618, t690);
    let t692 = circuit_add(in116, in117);
    let t693 = circuit_sub(t692, t687);
    let t694 = circuit_mul(t693, t623);
    let t695 = circuit_add(t622, t694);
    let t696 = circuit_mul(t623, in222);
    let t697 = circuit_sub(in201, in7);
    let t698 = circuit_mul(in0, t697);
    let t699 = circuit_sub(in201, in7);
    let t700 = circuit_mul(in2, t699);
    let t701 = circuit_inverse(t700);
    let t702 = circuit_mul(in116, t701);
    let t703 = circuit_add(in7, t702);
    let t704 = circuit_sub(in201, in0);
    let t705 = circuit_mul(t698, t704);
    let t706 = circuit_sub(in201, in0);
    let t707 = circuit_mul(in3, t706);
    let t708 = circuit_inverse(t707);
    let t709 = circuit_mul(in117, t708);
    let t710 = circuit_add(t703, t709);
    let t711 = circuit_sub(in201, in8);
    let t712 = circuit_mul(t705, t711);
    let t713 = circuit_sub(in201, in8);
    let t714 = circuit_mul(in4, t713);
    let t715 = circuit_inverse(t714);
    let t716 = circuit_mul(in118, t715);
    let t717 = circuit_add(t710, t716);
    let t718 = circuit_sub(in201, in9);
    let t719 = circuit_mul(t712, t718);
    let t720 = circuit_sub(in201, in9);
    let t721 = circuit_mul(in5, t720);
    let t722 = circuit_inverse(t721);
    let t723 = circuit_mul(in119, t722);
    let t724 = circuit_add(t717, t723);
    let t725 = circuit_sub(in201, in10);
    let t726 = circuit_mul(t719, t725);
    let t727 = circuit_sub(in201, in10);
    let t728 = circuit_mul(in6, t727);
    let t729 = circuit_inverse(t728);
    let t730 = circuit_mul(in120, t729);
    let t731 = circuit_add(t724, t730);
    let t732 = circuit_sub(in201, in11);
    let t733 = circuit_mul(t726, t732);
    let t734 = circuit_sub(in201, in11);
    let t735 = circuit_mul(in5, t734);
    let t736 = circuit_inverse(t735);
    let t737 = circuit_mul(in121, t736);
    let t738 = circuit_add(t731, t737);
    let t739 = circuit_sub(in201, in12);
    let t740 = circuit_mul(t733, t739);
    let t741 = circuit_sub(in201, in12);
    let t742 = circuit_mul(in4, t741);
    let t743 = circuit_inverse(t742);
    let t744 = circuit_mul(in122, t743);
    let t745 = circuit_add(t738, t744);
    let t746 = circuit_sub(in201, in13);
    let t747 = circuit_mul(t740, t746);
    let t748 = circuit_sub(in201, in13);
    let t749 = circuit_mul(in3, t748);
    let t750 = circuit_inverse(t749);
    let t751 = circuit_mul(in123, t750);
    let t752 = circuit_add(t745, t751);
    let t753 = circuit_sub(in201, in14);
    let t754 = circuit_mul(t747, t753);
    let t755 = circuit_sub(in201, in14);
    let t756 = circuit_mul(in2, t755);
    let t757 = circuit_inverse(t756);
    let t758 = circuit_mul(in124, t757);
    let t759 = circuit_add(t752, t758);
    let t760 = circuit_mul(t759, t754);
    let t761 = circuit_sub(in213, in0);
    let t762 = circuit_mul(in201, t761);
    let t763 = circuit_add(in0, t762);
    let t764 = circuit_mul(t691, t763);
    let t765 = circuit_add(in125, in126);
    let t766 = circuit_sub(t765, t760);
    let t767 = circuit_mul(t766, t696);
    let t768 = circuit_add(t695, t767);
    let t769 = circuit_mul(t696, in222);
    let t770 = circuit_sub(in202, in7);
    let t771 = circuit_mul(in0, t770);
    let t772 = circuit_sub(in202, in7);
    let t773 = circuit_mul(in2, t772);
    let t774 = circuit_inverse(t773);
    let t775 = circuit_mul(in125, t774);
    let t776 = circuit_add(in7, t775);
    let t777 = circuit_sub(in202, in0);
    let t778 = circuit_mul(t771, t777);
    let t779 = circuit_sub(in202, in0);
    let t780 = circuit_mul(in3, t779);
    let t781 = circuit_inverse(t780);
    let t782 = circuit_mul(in126, t781);
    let t783 = circuit_add(t776, t782);
    let t784 = circuit_sub(in202, in8);
    let t785 = circuit_mul(t778, t784);
    let t786 = circuit_sub(in202, in8);
    let t787 = circuit_mul(in4, t786);
    let t788 = circuit_inverse(t787);
    let t789 = circuit_mul(in127, t788);
    let t790 = circuit_add(t783, t789);
    let t791 = circuit_sub(in202, in9);
    let t792 = circuit_mul(t785, t791);
    let t793 = circuit_sub(in202, in9);
    let t794 = circuit_mul(in5, t793);
    let t795 = circuit_inverse(t794);
    let t796 = circuit_mul(in128, t795);
    let t797 = circuit_add(t790, t796);
    let t798 = circuit_sub(in202, in10);
    let t799 = circuit_mul(t792, t798);
    let t800 = circuit_sub(in202, in10);
    let t801 = circuit_mul(in6, t800);
    let t802 = circuit_inverse(t801);
    let t803 = circuit_mul(in129, t802);
    let t804 = circuit_add(t797, t803);
    let t805 = circuit_sub(in202, in11);
    let t806 = circuit_mul(t799, t805);
    let t807 = circuit_sub(in202, in11);
    let t808 = circuit_mul(in5, t807);
    let t809 = circuit_inverse(t808);
    let t810 = circuit_mul(in130, t809);
    let t811 = circuit_add(t804, t810);
    let t812 = circuit_sub(in202, in12);
    let t813 = circuit_mul(t806, t812);
    let t814 = circuit_sub(in202, in12);
    let t815 = circuit_mul(in4, t814);
    let t816 = circuit_inverse(t815);
    let t817 = circuit_mul(in131, t816);
    let t818 = circuit_add(t811, t817);
    let t819 = circuit_sub(in202, in13);
    let t820 = circuit_mul(t813, t819);
    let t821 = circuit_sub(in202, in13);
    let t822 = circuit_mul(in3, t821);
    let t823 = circuit_inverse(t822);
    let t824 = circuit_mul(in132, t823);
    let t825 = circuit_add(t818, t824);
    let t826 = circuit_sub(in202, in14);
    let t827 = circuit_mul(t820, t826);
    let t828 = circuit_sub(in202, in14);
    let t829 = circuit_mul(in2, t828);
    let t830 = circuit_inverse(t829);
    let t831 = circuit_mul(in133, t830);
    let t832 = circuit_add(t825, t831);
    let t833 = circuit_mul(t832, t827);
    let t834 = circuit_sub(in214, in0);
    let t835 = circuit_mul(in202, t834);
    let t836 = circuit_add(in0, t835);
    let t837 = circuit_mul(t764, t836);
    let t838 = circuit_add(in134, in135);
    let t839 = circuit_sub(t838, t833);
    let t840 = circuit_mul(t839, t769);
    let t841 = circuit_add(t768, t840);
    let t842 = circuit_mul(t769, in222);
    let t843 = circuit_sub(in203, in7);
    let t844 = circuit_mul(in0, t843);
    let t845 = circuit_sub(in203, in7);
    let t846 = circuit_mul(in2, t845);
    let t847 = circuit_inverse(t846);
    let t848 = circuit_mul(in134, t847);
    let t849 = circuit_add(in7, t848);
    let t850 = circuit_sub(in203, in0);
    let t851 = circuit_mul(t844, t850);
    let t852 = circuit_sub(in203, in0);
    let t853 = circuit_mul(in3, t852);
    let t854 = circuit_inverse(t853);
    let t855 = circuit_mul(in135, t854);
    let t856 = circuit_add(t849, t855);
    let t857 = circuit_sub(in203, in8);
    let t858 = circuit_mul(t851, t857);
    let t859 = circuit_sub(in203, in8);
    let t860 = circuit_mul(in4, t859);
    let t861 = circuit_inverse(t860);
    let t862 = circuit_mul(in136, t861);
    let t863 = circuit_add(t856, t862);
    let t864 = circuit_sub(in203, in9);
    let t865 = circuit_mul(t858, t864);
    let t866 = circuit_sub(in203, in9);
    let t867 = circuit_mul(in5, t866);
    let t868 = circuit_inverse(t867);
    let t869 = circuit_mul(in137, t868);
    let t870 = circuit_add(t863, t869);
    let t871 = circuit_sub(in203, in10);
    let t872 = circuit_mul(t865, t871);
    let t873 = circuit_sub(in203, in10);
    let t874 = circuit_mul(in6, t873);
    let t875 = circuit_inverse(t874);
    let t876 = circuit_mul(in138, t875);
    let t877 = circuit_add(t870, t876);
    let t878 = circuit_sub(in203, in11);
    let t879 = circuit_mul(t872, t878);
    let t880 = circuit_sub(in203, in11);
    let t881 = circuit_mul(in5, t880);
    let t882 = circuit_inverse(t881);
    let t883 = circuit_mul(in139, t882);
    let t884 = circuit_add(t877, t883);
    let t885 = circuit_sub(in203, in12);
    let t886 = circuit_mul(t879, t885);
    let t887 = circuit_sub(in203, in12);
    let t888 = circuit_mul(in4, t887);
    let t889 = circuit_inverse(t888);
    let t890 = circuit_mul(in140, t889);
    let t891 = circuit_add(t884, t890);
    let t892 = circuit_sub(in203, in13);
    let t893 = circuit_mul(t886, t892);
    let t894 = circuit_sub(in203, in13);
    let t895 = circuit_mul(in3, t894);
    let t896 = circuit_inverse(t895);
    let t897 = circuit_mul(in141, t896);
    let t898 = circuit_add(t891, t897);
    let t899 = circuit_sub(in203, in14);
    let t900 = circuit_mul(t893, t899);
    let t901 = circuit_sub(in203, in14);
    let t902 = circuit_mul(in2, t901);
    let t903 = circuit_inverse(t902);
    let t904 = circuit_mul(in142, t903);
    let t905 = circuit_add(t898, t904);
    let t906 = circuit_mul(t905, t900);
    let t907 = circuit_sub(in215, in0);
    let t908 = circuit_mul(in203, t907);
    let t909 = circuit_add(in0, t908);
    let t910 = circuit_mul(t837, t909);
    let t911 = circuit_add(in143, in144);
    let t912 = circuit_sub(t911, t906);
    let t913 = circuit_mul(t912, t842);
    let t914 = circuit_add(t841, t913);
    let t915 = circuit_sub(in204, in7);
    let t916 = circuit_mul(in0, t915);
    let t917 = circuit_sub(in204, in7);
    let t918 = circuit_mul(in2, t917);
    let t919 = circuit_inverse(t918);
    let t920 = circuit_mul(in143, t919);
    let t921 = circuit_add(in7, t920);
    let t922 = circuit_sub(in204, in0);
    let t923 = circuit_mul(t916, t922);
    let t924 = circuit_sub(in204, in0);
    let t925 = circuit_mul(in3, t924);
    let t926 = circuit_inverse(t925);
    let t927 = circuit_mul(in144, t926);
    let t928 = circuit_add(t921, t927);
    let t929 = circuit_sub(in204, in8);
    let t930 = circuit_mul(t923, t929);
    let t931 = circuit_sub(in204, in8);
    let t932 = circuit_mul(in4, t931);
    let t933 = circuit_inverse(t932);
    let t934 = circuit_mul(in145, t933);
    let t935 = circuit_add(t928, t934);
    let t936 = circuit_sub(in204, in9);
    let t937 = circuit_mul(t930, t936);
    let t938 = circuit_sub(in204, in9);
    let t939 = circuit_mul(in5, t938);
    let t940 = circuit_inverse(t939);
    let t941 = circuit_mul(in146, t940);
    let t942 = circuit_add(t935, t941);
    let t943 = circuit_sub(in204, in10);
    let t944 = circuit_mul(t937, t943);
    let t945 = circuit_sub(in204, in10);
    let t946 = circuit_mul(in6, t945);
    let t947 = circuit_inverse(t946);
    let t948 = circuit_mul(in147, t947);
    let t949 = circuit_add(t942, t948);
    let t950 = circuit_sub(in204, in11);
    let t951 = circuit_mul(t944, t950);
    let t952 = circuit_sub(in204, in11);
    let t953 = circuit_mul(in5, t952);
    let t954 = circuit_inverse(t953);
    let t955 = circuit_mul(in148, t954);
    let t956 = circuit_add(t949, t955);
    let t957 = circuit_sub(in204, in12);
    let t958 = circuit_mul(t951, t957);
    let t959 = circuit_sub(in204, in12);
    let t960 = circuit_mul(in4, t959);
    let t961 = circuit_inverse(t960);
    let t962 = circuit_mul(in149, t961);
    let t963 = circuit_add(t956, t962);
    let t964 = circuit_sub(in204, in13);
    let t965 = circuit_mul(t958, t964);
    let t966 = circuit_sub(in204, in13);
    let t967 = circuit_mul(in3, t966);
    let t968 = circuit_inverse(t967);
    let t969 = circuit_mul(in150, t968);
    let t970 = circuit_add(t963, t969);
    let t971 = circuit_sub(in204, in14);
    let t972 = circuit_mul(t965, t971);
    let t973 = circuit_sub(in204, in14);
    let t974 = circuit_mul(in2, t973);
    let t975 = circuit_inverse(t974);
    let t976 = circuit_mul(in151, t975);
    let t977 = circuit_add(t970, t976);
    let t978 = circuit_mul(t977, t972);
    let t979 = circuit_sub(in216, in0);
    let t980 = circuit_mul(in204, t979);
    let t981 = circuit_add(in0, t980);
    let t982 = circuit_mul(t910, t981);
    let t983 = circuit_sub(in159, in9);
    let t984 = circuit_mul(t983, in152);
    let t985 = circuit_mul(t984, in180);
    let t986 = circuit_mul(t985, in179);
    let t987 = circuit_mul(t986, in15);
    let t988 = circuit_mul(in154, in179);
    let t989 = circuit_mul(in155, in180);
    let t990 = circuit_mul(in156, in181);
    let t991 = circuit_mul(in157, in182);
    let t992 = circuit_add(t987, t988);
    let t993 = circuit_add(t992, t989);
    let t994 = circuit_add(t993, t990);
    let t995 = circuit_add(t994, t991);
    let t996 = circuit_add(t995, in153);
    let t997 = circuit_sub(in159, in0);
    let t998 = circuit_mul(t997, in190);
    let t999 = circuit_add(t996, t998);
    let t1000 = circuit_mul(t999, in159);
    let t1001 = circuit_mul(t1000, t982);
    let t1002 = circuit_add(in179, in182);
    let t1003 = circuit_add(t1002, in152);
    let t1004 = circuit_sub(t1003, in187);
    let t1005 = circuit_sub(in159, in8);
    let t1006 = circuit_mul(t1004, t1005);
    let t1007 = circuit_sub(in159, in0);
    let t1008 = circuit_mul(t1006, t1007);
    let t1009 = circuit_mul(t1008, in159);
    let t1010 = circuit_mul(t1009, t982);
    let t1011 = circuit_mul(in169, in220);
    let t1012 = circuit_add(in179, t1011);
    let t1013 = circuit_add(t1012, in221);
    let t1014 = circuit_mul(in170, in220);
    let t1015 = circuit_add(in180, t1014);
    let t1016 = circuit_add(t1015, in221);
    let t1017 = circuit_mul(t1013, t1016);
    let t1018 = circuit_mul(in171, in220);
    let t1019 = circuit_add(in181, t1018);
    let t1020 = circuit_add(t1019, in221);
    let t1021 = circuit_mul(t1017, t1020);
    let t1022 = circuit_mul(in172, in220);
    let t1023 = circuit_add(in182, t1022);
    let t1024 = circuit_add(t1023, in221);
    let t1025 = circuit_mul(t1021, t1024);
    let t1026 = circuit_mul(in165, in220);
    let t1027 = circuit_add(in179, t1026);
    let t1028 = circuit_add(t1027, in221);
    let t1029 = circuit_mul(in166, in220);
    let t1030 = circuit_add(in180, t1029);
    let t1031 = circuit_add(t1030, in221);
    let t1032 = circuit_mul(t1028, t1031);
    let t1033 = circuit_mul(in167, in220);
    let t1034 = circuit_add(in181, t1033);
    let t1035 = circuit_add(t1034, in221);
    let t1036 = circuit_mul(t1032, t1035);
    let t1037 = circuit_mul(in168, in220);
    let t1038 = circuit_add(in182, t1037);
    let t1039 = circuit_add(t1038, in221);
    let t1040 = circuit_mul(t1036, t1039);
    let t1041 = circuit_add(in183, in177);
    let t1042 = circuit_mul(t1025, t1041);
    let t1043 = circuit_mul(in178, t107);
    let t1044 = circuit_add(in191, t1043);
    let t1045 = circuit_mul(t1040, t1044);
    let t1046 = circuit_sub(t1042, t1045);
    let t1047 = circuit_mul(t1046, t982);
    let t1048 = circuit_mul(in178, in191);
    let t1049 = circuit_mul(t1048, t982);
    let t1050 = circuit_mul(in174, in217);
    let t1051 = circuit_mul(in175, in218);
    let t1052 = circuit_mul(in176, in219);
    let t1053 = circuit_add(in173, in221);
    let t1054 = circuit_add(t1053, t1050);
    let t1055 = circuit_add(t1054, t1051);
    let t1056 = circuit_add(t1055, t1052);
    let t1057 = circuit_mul(in155, in187);
    let t1058 = circuit_add(in179, in221);
    let t1059 = circuit_add(t1058, t1057);
    let t1060 = circuit_mul(in152, in188);
    let t1061 = circuit_add(in180, t1060);
    let t1062 = circuit_mul(in153, in189);
    let t1063 = circuit_add(in181, t1062);
    let t1064 = circuit_mul(t1061, in217);
    let t1065 = circuit_mul(t1063, in218);
    let t1066 = circuit_mul(in156, in219);
    let t1067 = circuit_add(t1059, t1064);
    let t1068 = circuit_add(t1067, t1065);
    let t1069 = circuit_add(t1068, t1066);
    let t1070 = circuit_mul(in184, t1056);
    let t1071 = circuit_mul(in184, t1069);
    let t1072 = circuit_add(in186, in158);
    let t1073 = circuit_mul(in186, in158);
    let t1074 = circuit_sub(t1072, t1073);
    let t1075 = circuit_mul(t1069, t1056);
    let t1076 = circuit_mul(t1075, in184);
    let t1077 = circuit_sub(t1076, t1074);
    let t1078 = circuit_mul(t1077, t982);
    let t1079 = circuit_mul(in158, t1070);
    let t1080 = circuit_mul(in185, t1071);
    let t1081 = circuit_sub(t1079, t1080);
    let t1082 = circuit_mul(in160, t982);
    let t1083 = circuit_sub(in180, in179);
    let t1084 = circuit_sub(in181, in180);
    let t1085 = circuit_sub(in182, in181);
    let t1086 = circuit_sub(in187, in182);
    let t1087 = circuit_add(t1083, in16);
    let t1088 = circuit_add(t1087, in16);
    let t1089 = circuit_add(t1088, in16);
    let t1090 = circuit_mul(t1083, t1087);
    let t1091 = circuit_mul(t1090, t1088);
    let t1092 = circuit_mul(t1091, t1089);
    let t1093 = circuit_mul(t1092, t1082);
    let t1094 = circuit_add(t1084, in16);
    let t1095 = circuit_add(t1094, in16);
    let t1096 = circuit_add(t1095, in16);
    let t1097 = circuit_mul(t1084, t1094);
    let t1098 = circuit_mul(t1097, t1095);
    let t1099 = circuit_mul(t1098, t1096);
    let t1100 = circuit_mul(t1099, t1082);
    let t1101 = circuit_add(t1085, in16);
    let t1102 = circuit_add(t1101, in16);
    let t1103 = circuit_add(t1102, in16);
    let t1104 = circuit_mul(t1085, t1101);
    let t1105 = circuit_mul(t1104, t1102);
    let t1106 = circuit_mul(t1105, t1103);
    let t1107 = circuit_mul(t1106, t1082);
    let t1108 = circuit_add(t1086, in16);
    let t1109 = circuit_add(t1108, in16);
    let t1110 = circuit_add(t1109, in16);
    let t1111 = circuit_mul(t1086, t1108);
    let t1112 = circuit_mul(t1111, t1109);
    let t1113 = circuit_mul(t1112, t1110);
    let t1114 = circuit_mul(t1113, t1082);
    let t1115 = circuit_sub(in187, in180);
    let t1116 = circuit_mul(in181, in181);
    let t1117 = circuit_mul(in190, in190);
    let t1118 = circuit_mul(in181, in190);
    let t1119 = circuit_mul(t1118, in154);
    let t1120 = circuit_add(in188, in187);
    let t1121 = circuit_add(t1120, in180);
    let t1122 = circuit_mul(t1121, t1115);
    let t1123 = circuit_mul(t1122, t1115);
    let t1124 = circuit_sub(t1123, t1117);
    let t1125 = circuit_sub(t1124, t1116);
    let t1126 = circuit_add(t1125, t1119);
    let t1127 = circuit_add(t1126, t1119);
    let t1128 = circuit_sub(in0, in152);
    let t1129 = circuit_mul(t1127, t982);
    let t1130 = circuit_mul(t1129, in161);
    let t1131 = circuit_mul(t1130, t1128);
    let t1132 = circuit_add(in181, in189);
    let t1133 = circuit_mul(in190, in154);
    let t1134 = circuit_sub(t1133, in181);
    let t1135 = circuit_mul(t1132, t1115);
    let t1136 = circuit_sub(in188, in180);
    let t1137 = circuit_mul(t1136, t1134);
    let t1138 = circuit_add(t1135, t1137);
    let t1139 = circuit_mul(t1138, t982);
    let t1140 = circuit_mul(t1139, in161);
    let t1141 = circuit_mul(t1140, t1128);
    let t1142 = circuit_add(t1116, in17);
    let t1143 = circuit_mul(t1142, in180);
    let t1144 = circuit_add(t1116, t1116);
    let t1145 = circuit_add(t1144, t1144);
    let t1146 = circuit_mul(t1143, in18);
    let t1147 = circuit_add(in188, in180);
    let t1148 = circuit_add(t1147, in180);
    let t1149 = circuit_mul(t1148, t1145);
    let t1150 = circuit_sub(t1149, t1146);
    let t1151 = circuit_mul(t1150, t982);
    let t1152 = circuit_mul(t1151, in161);
    let t1153 = circuit_mul(t1152, in152);
    let t1154 = circuit_add(t1131, t1153);
    let t1155 = circuit_add(in180, in180);
    let t1156 = circuit_add(t1155, in180);
    let t1157 = circuit_mul(t1156, in180);
    let t1158 = circuit_sub(in180, in188);
    let t1159 = circuit_mul(t1157, t1158);
    let t1160 = circuit_add(in181, in181);
    let t1161 = circuit_add(in181, in189);
    let t1162 = circuit_mul(t1160, t1161);
    let t1163 = circuit_sub(t1159, t1162);
    let t1164 = circuit_mul(t1163, t982);
    let t1165 = circuit_mul(t1164, in161);
    let t1166 = circuit_mul(t1165, in152);
    let t1167 = circuit_add(t1141, t1166);
    let t1168 = circuit_mul(in179, in188);
    let t1169 = circuit_mul(in187, in180);
    let t1170 = circuit_add(t1168, t1169);
    let t1171 = circuit_mul(in179, in182);
    let t1172 = circuit_mul(in180, in181);
    let t1173 = circuit_add(t1171, t1172);
    let t1174 = circuit_sub(t1173, in189);
    let t1175 = circuit_mul(t1174, in19);
    let t1176 = circuit_sub(t1175, in190);
    let t1177 = circuit_add(t1176, t1170);
    let t1178 = circuit_mul(t1177, in157);
    let t1179 = circuit_mul(t1170, in19);
    let t1180 = circuit_mul(in187, in188);
    let t1181 = circuit_add(t1179, t1180);
    let t1182 = circuit_add(in181, in182);
    let t1183 = circuit_sub(t1181, t1182);
    let t1184 = circuit_mul(t1183, in156);
    let t1185 = circuit_add(t1181, in182);
    let t1186 = circuit_add(in189, in190);
    let t1187 = circuit_sub(t1185, t1186);
    let t1188 = circuit_mul(t1187, in152);
    let t1189 = circuit_add(t1184, t1178);
    let t1190 = circuit_add(t1189, t1188);
    let t1191 = circuit_mul(t1190, in155);
    let t1192 = circuit_mul(in188, in20);
    let t1193 = circuit_add(t1192, in187);
    let t1194 = circuit_mul(t1193, in20);
    let t1195 = circuit_add(t1194, in181);
    let t1196 = circuit_mul(t1195, in20);
    let t1197 = circuit_add(t1196, in180);
    let t1198 = circuit_mul(t1197, in20);
    let t1199 = circuit_add(t1198, in179);
    let t1200 = circuit_sub(t1199, in182);
    let t1201 = circuit_mul(t1200, in157);
    let t1202 = circuit_mul(in189, in20);
    let t1203 = circuit_add(t1202, in188);
    let t1204 = circuit_mul(t1203, in20);
    let t1205 = circuit_add(t1204, in187);
    let t1206 = circuit_mul(t1205, in20);
    let t1207 = circuit_add(t1206, in182);
    let t1208 = circuit_mul(t1207, in20);
    let t1209 = circuit_add(t1208, in181);
    let t1210 = circuit_sub(t1209, in190);
    let t1211 = circuit_mul(t1210, in152);
    let t1212 = circuit_add(t1201, t1211);
    let t1213 = circuit_mul(t1212, in156);
    let t1214 = circuit_mul(in181, in219);
    let t1215 = circuit_mul(in180, in218);
    let t1216 = circuit_mul(in179, in217);
    let t1217 = circuit_add(t1214, t1215);
    let t1218 = circuit_add(t1217, t1216);
    let t1219 = circuit_add(t1218, in153);
    let t1220 = circuit_sub(t1219, in182);
    let t1221 = circuit_sub(in187, in179);
    let t1222 = circuit_sub(in190, in182);
    let t1223 = circuit_mul(t1221, t1221);
    let t1224 = circuit_sub(t1223, t1221);
    let t1225 = circuit_sub(in7, t1221);
    let t1226 = circuit_add(t1225, in0);
    let t1227 = circuit_mul(t1226, t1222);
    let t1228 = circuit_mul(in154, in155);
    let t1229 = circuit_mul(t1228, in162);
    let t1230 = circuit_mul(t1229, t982);
    let t1231 = circuit_mul(t1227, t1230);
    let t1232 = circuit_mul(t1224, t1230);
    let t1233 = circuit_mul(t1220, t1228);
    let t1234 = circuit_sub(in182, t1219);
    let t1235 = circuit_mul(t1234, t1234);
    let t1236 = circuit_sub(t1235, t1234);
    let t1237 = circuit_mul(in189, in219);
    let t1238 = circuit_mul(in188, in218);
    let t1239 = circuit_mul(in187, in217);
    let t1240 = circuit_add(t1237, t1238);
    let t1241 = circuit_add(t1240, t1239);
    let t1242 = circuit_sub(in190, t1241);
    let t1243 = circuit_sub(in189, in181);
    let t1244 = circuit_sub(in7, t1221);
    let t1245 = circuit_add(t1244, in0);
    let t1246 = circuit_sub(in7, t1242);
    let t1247 = circuit_add(t1246, in0);
    let t1248 = circuit_mul(t1243, t1247);
    let t1249 = circuit_mul(t1245, t1248);
    let t1250 = circuit_mul(t1242, t1242);
    let t1251 = circuit_sub(t1250, t1242);
    let t1252 = circuit_mul(in159, in162);
    let t1253 = circuit_mul(t1252, t982);
    let t1254 = circuit_mul(t1249, t1253);
    let t1255 = circuit_mul(t1224, t1253);
    let t1256 = circuit_mul(t1251, t1253);
    let t1257 = circuit_mul(t1236, in159);
    let t1258 = circuit_sub(in188, in180);
    let t1259 = circuit_sub(in7, t1221);
    let t1260 = circuit_add(t1259, in0);
    let t1261 = circuit_mul(t1260, t1258);
    let t1262 = circuit_sub(t1261, in181);
    let t1263 = circuit_mul(t1262, in157);
    let t1264 = circuit_mul(t1263, in154);
    let t1265 = circuit_add(t1233, t1264);
    let t1266 = circuit_mul(t1220, in152);
    let t1267 = circuit_mul(t1266, in154);
    let t1268 = circuit_add(t1265, t1267);
    let t1269 = circuit_add(t1268, t1257);
    let t1270 = circuit_add(t1269, t1191);
    let t1271 = circuit_add(t1270, t1213);
    let t1272 = circuit_mul(t1271, in162);
    let t1273 = circuit_mul(t1272, t982);
    let t1274 = circuit_add(in179, in154);
    let t1275 = circuit_add(in180, in155);
    let t1276 = circuit_add(in181, in156);
    let t1277 = circuit_add(in182, in157);
    let t1278 = circuit_mul(t1274, t1274);
    let t1279 = circuit_mul(t1278, t1278);
    let t1280 = circuit_mul(t1279, t1274);
    let t1281 = circuit_mul(t1275, t1275);
    let t1282 = circuit_mul(t1281, t1281);
    let t1283 = circuit_mul(t1282, t1275);
    let t1284 = circuit_mul(t1276, t1276);
    let t1285 = circuit_mul(t1284, t1284);
    let t1286 = circuit_mul(t1285, t1276);
    let t1287 = circuit_mul(t1277, t1277);
    let t1288 = circuit_mul(t1287, t1287);
    let t1289 = circuit_mul(t1288, t1277);
    let t1290 = circuit_add(t1280, t1283);
    let t1291 = circuit_add(t1286, t1289);
    let t1292 = circuit_add(t1283, t1283);
    let t1293 = circuit_add(t1292, t1291);
    let t1294 = circuit_add(t1289, t1289);
    let t1295 = circuit_add(t1294, t1290);
    let t1296 = circuit_add(t1291, t1291);
    let t1297 = circuit_add(t1296, t1296);
    let t1298 = circuit_add(t1297, t1295);
    let t1299 = circuit_add(t1290, t1290);
    let t1300 = circuit_add(t1299, t1299);
    let t1301 = circuit_add(t1300, t1293);
    let t1302 = circuit_add(t1295, t1301);
    let t1303 = circuit_add(t1293, t1298);
    let t1304 = circuit_mul(in163, t982);
    let t1305 = circuit_sub(t1302, in187);
    let t1306 = circuit_mul(t1304, t1305);
    let t1307 = circuit_sub(t1301, in188);
    let t1308 = circuit_mul(t1304, t1307);
    let t1309 = circuit_sub(t1303, in189);
    let t1310 = circuit_mul(t1304, t1309);
    let t1311 = circuit_sub(t1298, in190);
    let t1312 = circuit_mul(t1304, t1311);
    let t1313 = circuit_add(in179, in154);
    let t1314 = circuit_mul(t1313, t1313);
    let t1315 = circuit_mul(t1314, t1314);
    let t1316 = circuit_mul(t1315, t1313);
    let t1317 = circuit_add(t1316, in180);
    let t1318 = circuit_add(t1317, in181);
    let t1319 = circuit_add(t1318, in182);
    let t1320 = circuit_mul(in164, t982);
    let t1321 = circuit_mul(t1316, in21);
    let t1322 = circuit_add(t1321, t1319);
    let t1323 = circuit_sub(t1322, in187);
    let t1324 = circuit_mul(t1320, t1323);
    let t1325 = circuit_mul(in180, in22);
    let t1326 = circuit_add(t1325, t1319);
    let t1327 = circuit_sub(t1326, in188);
    let t1328 = circuit_mul(t1320, t1327);
    let t1329 = circuit_mul(in181, in23);
    let t1330 = circuit_add(t1329, t1319);
    let t1331 = circuit_sub(t1330, in189);
    let t1332 = circuit_mul(t1320, t1331);
    let t1333 = circuit_mul(in182, in24);
    let t1334 = circuit_add(t1333, t1319);
    let t1335 = circuit_sub(t1334, in190);
    let t1336 = circuit_mul(t1320, t1335);
    let t1337 = circuit_mul(t1010, in223);
    let t1338 = circuit_add(t1001, t1337);
    let t1339 = circuit_mul(t1047, in224);
    let t1340 = circuit_add(t1338, t1339);
    let t1341 = circuit_mul(t1049, in225);
    let t1342 = circuit_add(t1340, t1341);
    let t1343 = circuit_mul(t1078, in226);
    let t1344 = circuit_add(t1342, t1343);
    let t1345 = circuit_mul(t1081, in227);
    let t1346 = circuit_add(t1344, t1345);
    let t1347 = circuit_mul(t1093, in228);
    let t1348 = circuit_add(t1346, t1347);
    let t1349 = circuit_mul(t1100, in229);
    let t1350 = circuit_add(t1348, t1349);
    let t1351 = circuit_mul(t1107, in230);
    let t1352 = circuit_add(t1350, t1351);
    let t1353 = circuit_mul(t1114, in231);
    let t1354 = circuit_add(t1352, t1353);
    let t1355 = circuit_mul(t1154, in232);
    let t1356 = circuit_add(t1354, t1355);
    let t1357 = circuit_mul(t1167, in233);
    let t1358 = circuit_add(t1356, t1357);
    let t1359 = circuit_mul(t1273, in234);
    let t1360 = circuit_add(t1358, t1359);
    let t1361 = circuit_mul(t1231, in235);
    let t1362 = circuit_add(t1360, t1361);
    let t1363 = circuit_mul(t1232, in236);
    let t1364 = circuit_add(t1362, t1363);
    let t1365 = circuit_mul(t1254, in237);
    let t1366 = circuit_add(t1364, t1365);
    let t1367 = circuit_mul(t1255, in238);
    let t1368 = circuit_add(t1366, t1367);
    let t1369 = circuit_mul(t1256, in239);
    let t1370 = circuit_add(t1368, t1369);
    let t1371 = circuit_mul(t1306, in240);
    let t1372 = circuit_add(t1370, t1371);
    let t1373 = circuit_mul(t1308, in241);
    let t1374 = circuit_add(t1372, t1373);
    let t1375 = circuit_mul(t1310, in242);
    let t1376 = circuit_add(t1374, t1375);
    let t1377 = circuit_mul(t1312, in243);
    let t1378 = circuit_add(t1376, t1377);
    let t1379 = circuit_mul(t1324, in244);
    let t1380 = circuit_add(t1378, t1379);
    let t1381 = circuit_mul(t1328, in245);
    let t1382 = circuit_add(t1380, t1381);
    let t1383 = circuit_mul(t1332, in246);
    let t1384 = circuit_add(t1382, t1383);
    let t1385 = circuit_mul(t1336, in247);
    let t1386 = circuit_add(t1384, t1385);
    let t1387 = circuit_mul(in0, in195);
    let t1388 = circuit_mul(t1387, in196);
    let t1389 = circuit_mul(t1388, in197);
    let t1390 = circuit_mul(t1389, in198);
    let t1391 = circuit_mul(t1390, in199);
    let t1392 = circuit_mul(t1391, in200);
    let t1393 = circuit_mul(t1392, in201);
    let t1394 = circuit_mul(t1393, in202);
    let t1395 = circuit_mul(t1394, in203);
    let t1396 = circuit_mul(t1395, in204);
    let t1397 = circuit_sub(in0, t1396);
    let t1398 = circuit_mul(t1386, t1397);
    let t1399 = circuit_mul(in192, in248);
    let t1400 = circuit_add(t1398, t1399);
    let t1401 = circuit_sub(t1400, t978);

    let modulus = modulus;

    let mut circuit_inputs = (t914, t1401).new_inputs();
    // Prefill constants:

    circuit_inputs = circuit_inputs
        .next_span(ZK_HONK_SUMCHECK_SIZE_12_PUB_17_GRUMPKIN_CONSTANTS.span()); // in0 - in24

    // Fill inputs:

    for val in p_public_inputs {
        circuit_inputs = circuit_inputs.next_u256(*val);
    } // in25 - in25

    for val in p_pairing_point_object {
        circuit_inputs = circuit_inputs.next_u256(*val);
    } // in26 - in41

    circuit_inputs = circuit_inputs.next_2(p_public_inputs_offset); // in42
    circuit_inputs = circuit_inputs.next_2(libra_sum); // in43

    for val in sumcheck_univariates_flat {
        circuit_inputs = circuit_inputs.next_u256(*val);
    } // in44 - in151

    for val in sumcheck_evaluations {
        circuit_inputs = circuit_inputs.next_u256(*val);
    } // in152 - in191

    circuit_inputs = circuit_inputs.next_2(libra_evaluation); // in192

    for val in tp_sum_check_u_challenges {
        circuit_inputs = circuit_inputs.next_u128(*val);
    } // in193 - in204

    for val in tp_gate_challenges {
        circuit_inputs = circuit_inputs.next_u128(*val);
    } // in205 - in216

    circuit_inputs = circuit_inputs.next_2(tp_eta_1); // in217
    circuit_inputs = circuit_inputs.next_2(tp_eta_2); // in218
    circuit_inputs = circuit_inputs.next_2(tp_eta_3); // in219
    circuit_inputs = circuit_inputs.next_2(tp_beta); // in220
    circuit_inputs = circuit_inputs.next_2(tp_gamma); // in221
    circuit_inputs = circuit_inputs.next_2(tp_base_rlc); // in222

    for val in tp_alphas {
        circuit_inputs = circuit_inputs.next_u128(*val);
    } // in223 - in247

    circuit_inputs = circuit_inputs.next_2(tp_libra_challenge); // in248

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let check_rlc: u384 = outputs.get_output(t914);
    let check: u384 = outputs.get_output(t1401);
    return (check_rlc, check);
}
const ZK_HONK_SUMCHECK_SIZE_12_PUB_17_GRUMPKIN_CONSTANTS: [u384; 25] = [
    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x1000, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
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
pub fn run_GRUMPKIN_ZKHONK_PREP_MSM_SCALARS_SIZE_12_circuit(
    p_sumcheck_evaluations: Span<u256>,
    p_gemini_masking_eval: u384,
    p_gemini_a_evaluations: Span<u256>,
    p_libra_poly_evals: Span<u256>,
    tp_gemini_r: u384,
    tp_rho: u384,
    tp_shplonk_z: u384,
    tp_shplonk_nu: u384,
    tp_sum_check_u_challenges: Span<u128>,
    modulus: CircuitModulus,
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
    let in75 = CE::<CI<75>> {};
    let t0 = circuit_mul(in60, in60);
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
    let t11 = circuit_sub(in62, in60);
    let t12 = circuit_inverse(t11);
    let t13 = circuit_add(in62, in60);
    let t14 = circuit_inverse(t13);
    let t15 = circuit_mul(in63, t14);
    let t16 = circuit_add(t12, t15);
    let t17 = circuit_sub(in0, t16);
    let t18 = circuit_inverse(in60);
    let t19 = circuit_mul(in63, t14);
    let t20 = circuit_sub(t12, t19);
    let t21 = circuit_mul(t18, t20);
    let t22 = circuit_sub(in0, t21);
    let t23 = circuit_mul(t17, in61);
    let t24 = circuit_mul(in3, in61);
    let t25 = circuit_add(in43, t24);
    let t26 = circuit_mul(in61, in61);
    let t27 = circuit_mul(t17, t26);
    let t28 = circuit_mul(in4, t26);
    let t29 = circuit_add(t25, t28);
    let t30 = circuit_mul(t26, in61);
    let t31 = circuit_mul(t17, t30);
    let t32 = circuit_mul(in5, t30);
    let t33 = circuit_add(t29, t32);
    let t34 = circuit_mul(t30, in61);
    let t35 = circuit_mul(t17, t34);
    let t36 = circuit_mul(in6, t34);
    let t37 = circuit_add(t33, t36);
    let t38 = circuit_mul(t34, in61);
    let t39 = circuit_mul(t17, t38);
    let t40 = circuit_mul(in7, t38);
    let t41 = circuit_add(t37, t40);
    let t42 = circuit_mul(t38, in61);
    let t43 = circuit_mul(t17, t42);
    let t44 = circuit_mul(in8, t42);
    let t45 = circuit_add(t41, t44);
    let t46 = circuit_mul(t42, in61);
    let t47 = circuit_mul(t17, t46);
    let t48 = circuit_mul(in9, t46);
    let t49 = circuit_add(t45, t48);
    let t50 = circuit_mul(t46, in61);
    let t51 = circuit_mul(t17, t50);
    let t52 = circuit_mul(in10, t50);
    let t53 = circuit_add(t49, t52);
    let t54 = circuit_mul(t50, in61);
    let t55 = circuit_mul(t17, t54);
    let t56 = circuit_mul(in11, t54);
    let t57 = circuit_add(t53, t56);
    let t58 = circuit_mul(t54, in61);
    let t59 = circuit_mul(t17, t58);
    let t60 = circuit_mul(in12, t58);
    let t61 = circuit_add(t57, t60);
    let t62 = circuit_mul(t58, in61);
    let t63 = circuit_mul(t17, t62);
    let t64 = circuit_mul(in13, t62);
    let t65 = circuit_add(t61, t64);
    let t66 = circuit_mul(t62, in61);
    let t67 = circuit_mul(t17, t66);
    let t68 = circuit_mul(in14, t66);
    let t69 = circuit_add(t65, t68);
    let t70 = circuit_mul(t66, in61);
    let t71 = circuit_mul(t17, t70);
    let t72 = circuit_mul(in15, t70);
    let t73 = circuit_add(t69, t72);
    let t74 = circuit_mul(t70, in61);
    let t75 = circuit_mul(t17, t74);
    let t76 = circuit_mul(in16, t74);
    let t77 = circuit_add(t73, t76);
    let t78 = circuit_mul(t74, in61);
    let t79 = circuit_mul(t17, t78);
    let t80 = circuit_mul(in17, t78);
    let t81 = circuit_add(t77, t80);
    let t82 = circuit_mul(t78, in61);
    let t83 = circuit_mul(t17, t82);
    let t84 = circuit_mul(in18, t82);
    let t85 = circuit_add(t81, t84);
    let t86 = circuit_mul(t82, in61);
    let t87 = circuit_mul(t17, t86);
    let t88 = circuit_mul(in19, t86);
    let t89 = circuit_add(t85, t88);
    let t90 = circuit_mul(t86, in61);
    let t91 = circuit_mul(t17, t90);
    let t92 = circuit_mul(in20, t90);
    let t93 = circuit_add(t89, t92);
    let t94 = circuit_mul(t90, in61);
    let t95 = circuit_mul(t17, t94);
    let t96 = circuit_mul(in21, t94);
    let t97 = circuit_add(t93, t96);
    let t98 = circuit_mul(t94, in61);
    let t99 = circuit_mul(t17, t98);
    let t100 = circuit_mul(in22, t98);
    let t101 = circuit_add(t97, t100);
    let t102 = circuit_mul(t98, in61);
    let t103 = circuit_mul(t17, t102);
    let t104 = circuit_mul(in23, t102);
    let t105 = circuit_add(t101, t104);
    let t106 = circuit_mul(t102, in61);
    let t107 = circuit_mul(t17, t106);
    let t108 = circuit_mul(in24, t106);
    let t109 = circuit_add(t105, t108);
    let t110 = circuit_mul(t106, in61);
    let t111 = circuit_mul(t17, t110);
    let t112 = circuit_mul(in25, t110);
    let t113 = circuit_add(t109, t112);
    let t114 = circuit_mul(t110, in61);
    let t115 = circuit_mul(t17, t114);
    let t116 = circuit_mul(in26, t114);
    let t117 = circuit_add(t113, t116);
    let t118 = circuit_mul(t114, in61);
    let t119 = circuit_mul(t17, t118);
    let t120 = circuit_mul(in27, t118);
    let t121 = circuit_add(t117, t120);
    let t122 = circuit_mul(t118, in61);
    let t123 = circuit_mul(t17, t122);
    let t124 = circuit_mul(in28, t122);
    let t125 = circuit_add(t121, t124);
    let t126 = circuit_mul(t122, in61);
    let t127 = circuit_mul(t17, t126);
    let t128 = circuit_mul(in29, t126);
    let t129 = circuit_add(t125, t128);
    let t130 = circuit_mul(t126, in61);
    let t131 = circuit_mul(t17, t130);
    let t132 = circuit_mul(in30, t130);
    let t133 = circuit_add(t129, t132);
    let t134 = circuit_mul(t130, in61);
    let t135 = circuit_mul(t17, t134);
    let t136 = circuit_mul(in31, t134);
    let t137 = circuit_add(t133, t136);
    let t138 = circuit_mul(t134, in61);
    let t139 = circuit_mul(t17, t138);
    let t140 = circuit_mul(in32, t138);
    let t141 = circuit_add(t137, t140);
    let t142 = circuit_mul(t138, in61);
    let t143 = circuit_mul(t17, t142);
    let t144 = circuit_mul(in33, t142);
    let t145 = circuit_add(t141, t144);
    let t146 = circuit_mul(t142, in61);
    let t147 = circuit_mul(t17, t146);
    let t148 = circuit_mul(in34, t146);
    let t149 = circuit_add(t145, t148);
    let t150 = circuit_mul(t146, in61);
    let t151 = circuit_mul(t17, t150);
    let t152 = circuit_mul(in35, t150);
    let t153 = circuit_add(t149, t152);
    let t154 = circuit_mul(t150, in61);
    let t155 = circuit_mul(t17, t154);
    let t156 = circuit_mul(in36, t154);
    let t157 = circuit_add(t153, t156);
    let t158 = circuit_mul(t154, in61);
    let t159 = circuit_mul(t17, t158);
    let t160 = circuit_mul(in37, t158);
    let t161 = circuit_add(t157, t160);
    let t162 = circuit_mul(t158, in61);
    let t163 = circuit_mul(t22, t162);
    let t164 = circuit_mul(in38, t162);
    let t165 = circuit_add(t161, t164);
    let t166 = circuit_mul(t162, in61);
    let t167 = circuit_mul(t22, t166);
    let t168 = circuit_mul(in39, t166);
    let t169 = circuit_add(t165, t168);
    let t170 = circuit_mul(t166, in61);
    let t171 = circuit_mul(t22, t170);
    let t172 = circuit_mul(in40, t170);
    let t173 = circuit_add(t169, t172);
    let t174 = circuit_mul(t170, in61);
    let t175 = circuit_mul(t22, t174);
    let t176 = circuit_mul(in41, t174);
    let t177 = circuit_add(t173, t176);
    let t178 = circuit_mul(t174, in61);
    let t179 = circuit_mul(t22, t178);
    let t180 = circuit_mul(in42, t178);
    let t181 = circuit_add(t177, t180);
    let t182 = circuit_sub(in1, in75);
    let t183 = circuit_mul(t10, t182);
    let t184 = circuit_mul(t10, t181);
    let t185 = circuit_add(t184, t184);
    let t186 = circuit_sub(t183, in75);
    let t187 = circuit_mul(in55, t186);
    let t188 = circuit_sub(t185, t187);
    let t189 = circuit_add(t183, in75);
    let t190 = circuit_inverse(t189);
    let t191 = circuit_mul(t188, t190);
    let t192 = circuit_sub(in1, in74);
    let t193 = circuit_mul(t9, t192);
    let t194 = circuit_mul(t9, t191);
    let t195 = circuit_add(t194, t194);
    let t196 = circuit_sub(t193, in74);
    let t197 = circuit_mul(in54, t196);
    let t198 = circuit_sub(t195, t197);
    let t199 = circuit_add(t193, in74);
    let t200 = circuit_inverse(t199);
    let t201 = circuit_mul(t198, t200);
    let t202 = circuit_sub(in1, in73);
    let t203 = circuit_mul(t8, t202);
    let t204 = circuit_mul(t8, t201);
    let t205 = circuit_add(t204, t204);
    let t206 = circuit_sub(t203, in73);
    let t207 = circuit_mul(in53, t206);
    let t208 = circuit_sub(t205, t207);
    let t209 = circuit_add(t203, in73);
    let t210 = circuit_inverse(t209);
    let t211 = circuit_mul(t208, t210);
    let t212 = circuit_sub(in1, in72);
    let t213 = circuit_mul(t7, t212);
    let t214 = circuit_mul(t7, t211);
    let t215 = circuit_add(t214, t214);
    let t216 = circuit_sub(t213, in72);
    let t217 = circuit_mul(in52, t216);
    let t218 = circuit_sub(t215, t217);
    let t219 = circuit_add(t213, in72);
    let t220 = circuit_inverse(t219);
    let t221 = circuit_mul(t218, t220);
    let t222 = circuit_sub(in1, in71);
    let t223 = circuit_mul(t6, t222);
    let t224 = circuit_mul(t6, t221);
    let t225 = circuit_add(t224, t224);
    let t226 = circuit_sub(t223, in71);
    let t227 = circuit_mul(in51, t226);
    let t228 = circuit_sub(t225, t227);
    let t229 = circuit_add(t223, in71);
    let t230 = circuit_inverse(t229);
    let t231 = circuit_mul(t228, t230);
    let t232 = circuit_sub(in1, in70);
    let t233 = circuit_mul(t5, t232);
    let t234 = circuit_mul(t5, t231);
    let t235 = circuit_add(t234, t234);
    let t236 = circuit_sub(t233, in70);
    let t237 = circuit_mul(in50, t236);
    let t238 = circuit_sub(t235, t237);
    let t239 = circuit_add(t233, in70);
    let t240 = circuit_inverse(t239);
    let t241 = circuit_mul(t238, t240);
    let t242 = circuit_sub(in1, in69);
    let t243 = circuit_mul(t4, t242);
    let t244 = circuit_mul(t4, t241);
    let t245 = circuit_add(t244, t244);
    let t246 = circuit_sub(t243, in69);
    let t247 = circuit_mul(in49, t246);
    let t248 = circuit_sub(t245, t247);
    let t249 = circuit_add(t243, in69);
    let t250 = circuit_inverse(t249);
    let t251 = circuit_mul(t248, t250);
    let t252 = circuit_sub(in1, in68);
    let t253 = circuit_mul(t3, t252);
    let t254 = circuit_mul(t3, t251);
    let t255 = circuit_add(t254, t254);
    let t256 = circuit_sub(t253, in68);
    let t257 = circuit_mul(in48, t256);
    let t258 = circuit_sub(t255, t257);
    let t259 = circuit_add(t253, in68);
    let t260 = circuit_inverse(t259);
    let t261 = circuit_mul(t258, t260);
    let t262 = circuit_sub(in1, in67);
    let t263 = circuit_mul(t2, t262);
    let t264 = circuit_mul(t2, t261);
    let t265 = circuit_add(t264, t264);
    let t266 = circuit_sub(t263, in67);
    let t267 = circuit_mul(in47, t266);
    let t268 = circuit_sub(t265, t267);
    let t269 = circuit_add(t263, in67);
    let t270 = circuit_inverse(t269);
    let t271 = circuit_mul(t268, t270);
    let t272 = circuit_sub(in1, in66);
    let t273 = circuit_mul(t1, t272);
    let t274 = circuit_mul(t1, t271);
    let t275 = circuit_add(t274, t274);
    let t276 = circuit_sub(t273, in66);
    let t277 = circuit_mul(in46, t276);
    let t278 = circuit_sub(t275, t277);
    let t279 = circuit_add(t273, in66);
    let t280 = circuit_inverse(t279);
    let t281 = circuit_mul(t278, t280);
    let t282 = circuit_sub(in1, in65);
    let t283 = circuit_mul(t0, t282);
    let t284 = circuit_mul(t0, t281);
    let t285 = circuit_add(t284, t284);
    let t286 = circuit_sub(t283, in65);
    let t287 = circuit_mul(in45, t286);
    let t288 = circuit_sub(t285, t287);
    let t289 = circuit_add(t283, in65);
    let t290 = circuit_inverse(t289);
    let t291 = circuit_mul(t288, t290);
    let t292 = circuit_sub(in1, in64);
    let t293 = circuit_mul(in60, t292);
    let t294 = circuit_mul(in60, t291);
    let t295 = circuit_add(t294, t294);
    let t296 = circuit_sub(t293, in64);
    let t297 = circuit_mul(in44, t296);
    let t298 = circuit_sub(t295, t297);
    let t299 = circuit_add(t293, in64);
    let t300 = circuit_inverse(t299);
    let t301 = circuit_mul(t298, t300);
    let t302 = circuit_mul(t301, t12);
    let t303 = circuit_mul(in44, in63);
    let t304 = circuit_mul(t303, t14);
    let t305 = circuit_add(t302, t304);
    let t306 = circuit_mul(in63, in63);
    let t307 = circuit_sub(in62, t0);
    let t308 = circuit_inverse(t307);
    let t309 = circuit_add(in62, t0);
    let t310 = circuit_inverse(t309);
    let t311 = circuit_mul(t306, t308);
    let t312 = circuit_mul(in63, t310);
    let t313 = circuit_mul(t306, t312);
    let t314 = circuit_add(t313, t311);
    let t315 = circuit_sub(in0, t314);
    let t316 = circuit_mul(t313, in45);
    let t317 = circuit_mul(t311, t291);
    let t318 = circuit_add(t316, t317);
    let t319 = circuit_add(t305, t318);
    let t320 = circuit_mul(in63, in63);
    let t321 = circuit_mul(t306, t320);
    let t322 = circuit_sub(in62, t1);
    let t323 = circuit_inverse(t322);
    let t324 = circuit_add(in62, t1);
    let t325 = circuit_inverse(t324);
    let t326 = circuit_mul(t321, t323);
    let t327 = circuit_mul(in63, t325);
    let t328 = circuit_mul(t321, t327);
    let t329 = circuit_add(t328, t326);
    let t330 = circuit_sub(in0, t329);
    let t331 = circuit_mul(t328, in46);
    let t332 = circuit_mul(t326, t281);
    let t333 = circuit_add(t331, t332);
    let t334 = circuit_add(t319, t333);
    let t335 = circuit_mul(in63, in63);
    let t336 = circuit_mul(t321, t335);
    let t337 = circuit_sub(in62, t2);
    let t338 = circuit_inverse(t337);
    let t339 = circuit_add(in62, t2);
    let t340 = circuit_inverse(t339);
    let t341 = circuit_mul(t336, t338);
    let t342 = circuit_mul(in63, t340);
    let t343 = circuit_mul(t336, t342);
    let t344 = circuit_add(t343, t341);
    let t345 = circuit_sub(in0, t344);
    let t346 = circuit_mul(t343, in47);
    let t347 = circuit_mul(t341, t271);
    let t348 = circuit_add(t346, t347);
    let t349 = circuit_add(t334, t348);
    let t350 = circuit_mul(in63, in63);
    let t351 = circuit_mul(t336, t350);
    let t352 = circuit_sub(in62, t3);
    let t353 = circuit_inverse(t352);
    let t354 = circuit_add(in62, t3);
    let t355 = circuit_inverse(t354);
    let t356 = circuit_mul(t351, t353);
    let t357 = circuit_mul(in63, t355);
    let t358 = circuit_mul(t351, t357);
    let t359 = circuit_add(t358, t356);
    let t360 = circuit_sub(in0, t359);
    let t361 = circuit_mul(t358, in48);
    let t362 = circuit_mul(t356, t261);
    let t363 = circuit_add(t361, t362);
    let t364 = circuit_add(t349, t363);
    let t365 = circuit_mul(in63, in63);
    let t366 = circuit_mul(t351, t365);
    let t367 = circuit_sub(in62, t4);
    let t368 = circuit_inverse(t367);
    let t369 = circuit_add(in62, t4);
    let t370 = circuit_inverse(t369);
    let t371 = circuit_mul(t366, t368);
    let t372 = circuit_mul(in63, t370);
    let t373 = circuit_mul(t366, t372);
    let t374 = circuit_add(t373, t371);
    let t375 = circuit_sub(in0, t374);
    let t376 = circuit_mul(t373, in49);
    let t377 = circuit_mul(t371, t251);
    let t378 = circuit_add(t376, t377);
    let t379 = circuit_add(t364, t378);
    let t380 = circuit_mul(in63, in63);
    let t381 = circuit_mul(t366, t380);
    let t382 = circuit_sub(in62, t5);
    let t383 = circuit_inverse(t382);
    let t384 = circuit_add(in62, t5);
    let t385 = circuit_inverse(t384);
    let t386 = circuit_mul(t381, t383);
    let t387 = circuit_mul(in63, t385);
    let t388 = circuit_mul(t381, t387);
    let t389 = circuit_add(t388, t386);
    let t390 = circuit_sub(in0, t389);
    let t391 = circuit_mul(t388, in50);
    let t392 = circuit_mul(t386, t241);
    let t393 = circuit_add(t391, t392);
    let t394 = circuit_add(t379, t393);
    let t395 = circuit_mul(in63, in63);
    let t396 = circuit_mul(t381, t395);
    let t397 = circuit_sub(in62, t6);
    let t398 = circuit_inverse(t397);
    let t399 = circuit_add(in62, t6);
    let t400 = circuit_inverse(t399);
    let t401 = circuit_mul(t396, t398);
    let t402 = circuit_mul(in63, t400);
    let t403 = circuit_mul(t396, t402);
    let t404 = circuit_add(t403, t401);
    let t405 = circuit_sub(in0, t404);
    let t406 = circuit_mul(t403, in51);
    let t407 = circuit_mul(t401, t231);
    let t408 = circuit_add(t406, t407);
    let t409 = circuit_add(t394, t408);
    let t410 = circuit_mul(in63, in63);
    let t411 = circuit_mul(t396, t410);
    let t412 = circuit_sub(in62, t7);
    let t413 = circuit_inverse(t412);
    let t414 = circuit_add(in62, t7);
    let t415 = circuit_inverse(t414);
    let t416 = circuit_mul(t411, t413);
    let t417 = circuit_mul(in63, t415);
    let t418 = circuit_mul(t411, t417);
    let t419 = circuit_add(t418, t416);
    let t420 = circuit_sub(in0, t419);
    let t421 = circuit_mul(t418, in52);
    let t422 = circuit_mul(t416, t221);
    let t423 = circuit_add(t421, t422);
    let t424 = circuit_add(t409, t423);
    let t425 = circuit_mul(in63, in63);
    let t426 = circuit_mul(t411, t425);
    let t427 = circuit_sub(in62, t8);
    let t428 = circuit_inverse(t427);
    let t429 = circuit_add(in62, t8);
    let t430 = circuit_inverse(t429);
    let t431 = circuit_mul(t426, t428);
    let t432 = circuit_mul(in63, t430);
    let t433 = circuit_mul(t426, t432);
    let t434 = circuit_add(t433, t431);
    let t435 = circuit_sub(in0, t434);
    let t436 = circuit_mul(t433, in53);
    let t437 = circuit_mul(t431, t211);
    let t438 = circuit_add(t436, t437);
    let t439 = circuit_add(t424, t438);
    let t440 = circuit_mul(in63, in63);
    let t441 = circuit_mul(t426, t440);
    let t442 = circuit_sub(in62, t9);
    let t443 = circuit_inverse(t442);
    let t444 = circuit_add(in62, t9);
    let t445 = circuit_inverse(t444);
    let t446 = circuit_mul(t441, t443);
    let t447 = circuit_mul(in63, t445);
    let t448 = circuit_mul(t441, t447);
    let t449 = circuit_add(t448, t446);
    let t450 = circuit_sub(in0, t449);
    let t451 = circuit_mul(t448, in54);
    let t452 = circuit_mul(t446, t201);
    let t453 = circuit_add(t451, t452);
    let t454 = circuit_add(t439, t453);
    let t455 = circuit_mul(in63, in63);
    let t456 = circuit_mul(t441, t455);
    let t457 = circuit_sub(in62, t10);
    let t458 = circuit_inverse(t457);
    let t459 = circuit_add(in62, t10);
    let t460 = circuit_inverse(t459);
    let t461 = circuit_mul(t456, t458);
    let t462 = circuit_mul(in63, t460);
    let t463 = circuit_mul(t456, t462);
    let t464 = circuit_add(t463, t461);
    let t465 = circuit_sub(in0, t464);
    let t466 = circuit_mul(t463, in55);
    let t467 = circuit_mul(t461, t191);
    let t468 = circuit_add(t466, t467);
    let t469 = circuit_add(t454, t468);
    let t470 = circuit_mul(in63, in63);
    let t471 = circuit_mul(t456, t470);
    let t472 = circuit_mul(in63, in63);
    let t473 = circuit_mul(t471, t472);
    let t474 = circuit_mul(in63, in63);
    let t475 = circuit_mul(t473, t474);
    let t476 = circuit_mul(in63, in63);
    let t477 = circuit_mul(t475, t476);
    let t478 = circuit_mul(in63, in63);
    let t479 = circuit_mul(t477, t478);
    let t480 = circuit_mul(in63, in63);
    let t481 = circuit_mul(t479, t480);
    let t482 = circuit_mul(in63, in63);
    let t483 = circuit_mul(t481, t482);
    let t484 = circuit_mul(in63, in63);
    let t485 = circuit_mul(t483, t484);
    let t486 = circuit_mul(in63, in63);
    let t487 = circuit_mul(t485, t486);
    let t488 = circuit_mul(in63, in63);
    let t489 = circuit_mul(t487, t488);
    let t490 = circuit_mul(in63, in63);
    let t491 = circuit_mul(t489, t490);
    let t492 = circuit_mul(in63, in63);
    let t493 = circuit_mul(t491, t492);
    let t494 = circuit_mul(in63, in63);
    let t495 = circuit_mul(t493, t494);
    let t496 = circuit_mul(in63, in63);
    let t497 = circuit_mul(t495, t496);
    let t498 = circuit_mul(in63, in63);
    let t499 = circuit_mul(t497, t498);
    let t500 = circuit_mul(in63, in63);
    let t501 = circuit_mul(t499, t500);
    let t502 = circuit_mul(in63, in63);
    let t503 = circuit_mul(t501, t502);
    let t504 = circuit_sub(in62, in60);
    let t505 = circuit_inverse(t504);
    let t506 = circuit_mul(in1, t505);
    let t507 = circuit_mul(in2, in60);
    let t508 = circuit_sub(in62, t507);
    let t509 = circuit_inverse(t508);
    let t510 = circuit_mul(in1, t509);
    let t511 = circuit_mul(in63, in63);
    let t512 = circuit_mul(t503, t511);
    let t513 = circuit_mul(t506, t512);
    let t514 = circuit_sub(in0, t513);
    let t515 = circuit_mul(t512, in63);
    let t516 = circuit_mul(t513, in56);
    let t517 = circuit_add(t469, t516);
    let t518 = circuit_mul(t510, t515);
    let t519 = circuit_sub(in0, t518);
    let t520 = circuit_mul(t515, in63);
    let t521 = circuit_mul(t518, in57);
    let t522 = circuit_add(t517, t521);
    let t523 = circuit_mul(t506, t520);
    let t524 = circuit_sub(in0, t523);
    let t525 = circuit_mul(t520, in63);
    let t526 = circuit_mul(t523, in58);
    let t527 = circuit_add(t522, t526);
    let t528 = circuit_mul(t506, t525);
    let t529 = circuit_sub(in0, t528);
    let t530 = circuit_mul(t528, in59);
    let t531 = circuit_add(t527, t530);
    let t532 = circuit_add(t519, t524);
    let t533 = circuit_add(t131, t163);
    let t534 = circuit_add(t135, t167);
    let t535 = circuit_add(t139, t171);
    let t536 = circuit_add(t143, t175);
    let t537 = circuit_add(t147, t179);

    let modulus = modulus;

    let mut circuit_inputs = (
        t17,
        t23,
        t27,
        t31,
        t35,
        t39,
        t43,
        t47,
        t51,
        t55,
        t59,
        t63,
        t67,
        t71,
        t75,
        t79,
        t83,
        t87,
        t91,
        t95,
        t99,
        t103,
        t107,
        t111,
        t115,
        t119,
        t123,
        t127,
        t533,
        t534,
        t535,
        t536,
        t537,
        t151,
        t155,
        t159,
        t315,
        t330,
        t345,
        t360,
        t375,
        t390,
        t405,
        t420,
        t435,
        t450,
        t465,
        t514,
        t532,
        t529,
        t531,
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
    } // in44 - in55

    for val in p_libra_poly_evals {
        circuit_inputs = circuit_inputs.next_u256(*val);
    } // in56 - in59

    circuit_inputs = circuit_inputs.next_2(tp_gemini_r); // in60
    circuit_inputs = circuit_inputs.next_2(tp_rho); // in61
    circuit_inputs = circuit_inputs.next_2(tp_shplonk_z); // in62
    circuit_inputs = circuit_inputs.next_2(tp_shplonk_nu); // in63

    for val in tp_sum_check_u_challenges {
        circuit_inputs = circuit_inputs.next_u128(*val);
    } // in64 - in75

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let scalar_1: u384 = outputs.get_output(t17);
    let scalar_2: u384 = outputs.get_output(t23);
    let scalar_3: u384 = outputs.get_output(t27);
    let scalar_4: u384 = outputs.get_output(t31);
    let scalar_5: u384 = outputs.get_output(t35);
    let scalar_6: u384 = outputs.get_output(t39);
    let scalar_7: u384 = outputs.get_output(t43);
    let scalar_8: u384 = outputs.get_output(t47);
    let scalar_9: u384 = outputs.get_output(t51);
    let scalar_10: u384 = outputs.get_output(t55);
    let scalar_11: u384 = outputs.get_output(t59);
    let scalar_12: u384 = outputs.get_output(t63);
    let scalar_13: u384 = outputs.get_output(t67);
    let scalar_14: u384 = outputs.get_output(t71);
    let scalar_15: u384 = outputs.get_output(t75);
    let scalar_16: u384 = outputs.get_output(t79);
    let scalar_17: u384 = outputs.get_output(t83);
    let scalar_18: u384 = outputs.get_output(t87);
    let scalar_19: u384 = outputs.get_output(t91);
    let scalar_20: u384 = outputs.get_output(t95);
    let scalar_21: u384 = outputs.get_output(t99);
    let scalar_22: u384 = outputs.get_output(t103);
    let scalar_23: u384 = outputs.get_output(t107);
    let scalar_24: u384 = outputs.get_output(t111);
    let scalar_25: u384 = outputs.get_output(t115);
    let scalar_26: u384 = outputs.get_output(t119);
    let scalar_27: u384 = outputs.get_output(t123);
    let scalar_28: u384 = outputs.get_output(t127);
    let scalar_29: u384 = outputs.get_output(t533);
    let scalar_30: u384 = outputs.get_output(t534);
    let scalar_31: u384 = outputs.get_output(t535);
    let scalar_32: u384 = outputs.get_output(t536);
    let scalar_33: u384 = outputs.get_output(t537);
    let scalar_34: u384 = outputs.get_output(t151);
    let scalar_35: u384 = outputs.get_output(t155);
    let scalar_36: u384 = outputs.get_output(t159);
    let scalar_42: u384 = outputs.get_output(t315);
    let scalar_43: u384 = outputs.get_output(t330);
    let scalar_44: u384 = outputs.get_output(t345);
    let scalar_45: u384 = outputs.get_output(t360);
    let scalar_46: u384 = outputs.get_output(t375);
    let scalar_47: u384 = outputs.get_output(t390);
    let scalar_48: u384 = outputs.get_output(t405);
    let scalar_49: u384 = outputs.get_output(t420);
    let scalar_50: u384 = outputs.get_output(t435);
    let scalar_51: u384 = outputs.get_output(t450);
    let scalar_52: u384 = outputs.get_output(t465);
    let scalar_69: u384 = outputs.get_output(t514);
    let scalar_70: u384 = outputs.get_output(t532);
    let scalar_71: u384 = outputs.get_output(t529);
    let scalar_72: u384 = outputs.get_output(t531);
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
        scalar_46,
        scalar_47,
        scalar_48,
        scalar_49,
        scalar_50,
        scalar_51,
        scalar_52,
        scalar_69,
        scalar_70,
        scalar_71,
        scalar_72,
    );
}
#[inline(always)]
pub fn run_GRUMPKIN_ZK_HONK_EVALS_CONS_INIT_SIZE_12_circuit(
    tp_gemini_r: u384, modulus: CircuitModulus,
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
    circuit_inputs = circuit_inputs.next_2(tp_gemini_r); // in2

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let challenge_poly_eval: u384 = outputs.get_output(t1);
    let root_power_times_tp_gemini_r: u384 = outputs.get_output(t2);
    return (challenge_poly_eval, root_power_times_tp_gemini_r);
}
#[inline(always)]
pub fn run_GRUMPKIN_ZK_HONK_EVALS_CONS_LOOP_SIZE_12_circuit(
    challenge_poly_eval: u384,
    root_power_times_tp_gemini_r: u384,
    tp_sumcheck_u_challenge: u384,
    modulus: CircuitModulus,
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
    circuit_inputs = circuit_inputs.next_2(challenge_poly_eval); // in2
    circuit_inputs = circuit_inputs.next_2(root_power_times_tp_gemini_r); // in3
    circuit_inputs = circuit_inputs.next_2(tp_sumcheck_u_challenge); // in4

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let challenge_poly_eval: u384 = outputs.get_output(t51);
    let root_power_times_tp_gemini_r: u384 = outputs.get_output(t52);
    return (challenge_poly_eval, root_power_times_tp_gemini_r);
}
#[inline(always)]
pub fn run_GRUMPKIN_ZK_HONK_EVALS_CONS_DONE_SIZE_12_circuit(
    p_libra_evaluation: u384,
    p_libra_poly_evals: Span<u256>,
    tp_gemini_r: u384,
    challenge_poly_eval: u384,
    root_power_times_tp_gemini_r: u384,
    modulus: CircuitModulus,
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

    let modulus = modulus;

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

impl CircuitDefinition51<
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
            ),
        >;
}
impl MyDrp_51<
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
    ),
>;

#[inline(never)]
pub fn is_on_curve_bn254(p: G1Point, modulus: CircuitModulus) -> bool {
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

