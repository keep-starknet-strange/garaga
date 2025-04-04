use core::circuit::{
    CircuitElement as CE, CircuitInput as CI, CircuitInputs, CircuitOutputsTrait, EvalCircuitTrait,
    circuit_add, circuit_inverse, circuit_mul, circuit_sub, u384,
};
use garaga::core::circuit::{AddInputResultTrait2, IntoCircuitInputValue, u288IntoCircuitInputValue};
use garaga::definitions::{G1Point, get_BN254_modulus, get_GRUMPKIN_modulus};
use garaga::ec_ops::FunctionFelt;

#[inline(always)]
pub fn run_GRUMPKIN_ZK_HONK_SUMCHECK_SIZE_17_PUB_3_circuit(
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
    let in1 = CE::<CI<1>> {}; // 0x20000
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
    let (in247, in248, in249) = (CE::<CI<247>> {}, CE::<CI<248>> {}, CE::<CI<249>> {});
    let (in250, in251, in252) = (CE::<CI<250>> {}, CE::<CI<251>> {}, CE::<CI<252>> {});
    let (in253, in254, in255) = (CE::<CI<253>> {}, CE::<CI<254>> {}, CE::<CI<255>> {});
    let (in256, in257, in258) = (CE::<CI<256>> {}, CE::<CI<257>> {}, CE::<CI<258>> {});
    let (in259, in260, in261) = (CE::<CI<259>> {}, CE::<CI<260>> {}, CE::<CI<261>> {});
    let (in262, in263, in264) = (CE::<CI<262>> {}, CE::<CI<263>> {}, CE::<CI<264>> {});
    let (in265, in266, in267) = (CE::<CI<265>> {}, CE::<CI<266>> {}, CE::<CI<267>> {});
    let (in268, in269, in270) = (CE::<CI<268>> {}, CE::<CI<269>> {}, CE::<CI<270>> {});
    let (in271, in272, in273) = (CE::<CI<271>> {}, CE::<CI<272>> {}, CE::<CI<273>> {});
    let (in274, in275, in276) = (CE::<CI<274>> {}, CE::<CI<275>> {}, CE::<CI<276>> {});
    let (in277, in278, in279) = (CE::<CI<277>> {}, CE::<CI<278>> {}, CE::<CI<279>> {});
    let (in280, in281, in282) = (CE::<CI<280>> {}, CE::<CI<281>> {}, CE::<CI<282>> {});
    let (in283, in284, in285) = (CE::<CI<283>> {}, CE::<CI<284>> {}, CE::<CI<285>> {});
    let (in286, in287, in288) = (CE::<CI<286>> {}, CE::<CI<287>> {}, CE::<CI<288>> {});
    let in289 = CE::<CI<289>> {};
    let t0 = circuit_add(in1, in28);
    let t1 = circuit_mul(in261, t0);
    let t2 = circuit_add(in262, t1);
    let t3 = circuit_add(in28, in0);
    let t4 = circuit_mul(in261, t3);
    let t5 = circuit_sub(in262, t4);
    let t6 = circuit_add(t2, in25);
    let t7 = circuit_mul(in0, t6);
    let t8 = circuit_add(t5, in25);
    let t9 = circuit_mul(in0, t8);
    let t10 = circuit_add(t2, in261);
    let t11 = circuit_sub(t5, in261);
    let t12 = circuit_add(t10, in26);
    let t13 = circuit_mul(t7, t12);
    let t14 = circuit_add(t11, in26);
    let t15 = circuit_mul(t9, t14);
    let t16 = circuit_add(t10, in261);
    let t17 = circuit_sub(t11, in261);
    let t18 = circuit_add(t16, in27);
    let t19 = circuit_mul(t13, t18);
    let t20 = circuit_add(t17, in27);
    let t21 = circuit_mul(t15, t20);
    let t22 = circuit_inverse(t21);
    let t23 = circuit_mul(t19, t22);
    let t24 = circuit_mul(in289, in29);
    let t25 = circuit_add(in30, in31);
    let t26 = circuit_sub(t25, t24);
    let t27 = circuit_mul(t26, in263);
    let t28 = circuit_mul(in263, in263);
    let t29 = circuit_sub(in224, in7);
    let t30 = circuit_mul(in0, t29);
    let t31 = circuit_sub(in224, in7);
    let t32 = circuit_mul(in2, t31);
    let t33 = circuit_inverse(t32);
    let t34 = circuit_mul(in30, t33);
    let t35 = circuit_add(in7, t34);
    let t36 = circuit_sub(in224, in0);
    let t37 = circuit_mul(t30, t36);
    let t38 = circuit_sub(in224, in0);
    let t39 = circuit_mul(in3, t38);
    let t40 = circuit_inverse(t39);
    let t41 = circuit_mul(in31, t40);
    let t42 = circuit_add(t35, t41);
    let t43 = circuit_sub(in224, in8);
    let t44 = circuit_mul(t37, t43);
    let t45 = circuit_sub(in224, in8);
    let t46 = circuit_mul(in4, t45);
    let t47 = circuit_inverse(t46);
    let t48 = circuit_mul(in32, t47);
    let t49 = circuit_add(t42, t48);
    let t50 = circuit_sub(in224, in9);
    let t51 = circuit_mul(t44, t50);
    let t52 = circuit_sub(in224, in9);
    let t53 = circuit_mul(in5, t52);
    let t54 = circuit_inverse(t53);
    let t55 = circuit_mul(in33, t54);
    let t56 = circuit_add(t49, t55);
    let t57 = circuit_sub(in224, in10);
    let t58 = circuit_mul(t51, t57);
    let t59 = circuit_sub(in224, in10);
    let t60 = circuit_mul(in6, t59);
    let t61 = circuit_inverse(t60);
    let t62 = circuit_mul(in34, t61);
    let t63 = circuit_add(t56, t62);
    let t64 = circuit_sub(in224, in11);
    let t65 = circuit_mul(t58, t64);
    let t66 = circuit_sub(in224, in11);
    let t67 = circuit_mul(in5, t66);
    let t68 = circuit_inverse(t67);
    let t69 = circuit_mul(in35, t68);
    let t70 = circuit_add(t63, t69);
    let t71 = circuit_sub(in224, in12);
    let t72 = circuit_mul(t65, t71);
    let t73 = circuit_sub(in224, in12);
    let t74 = circuit_mul(in4, t73);
    let t75 = circuit_inverse(t74);
    let t76 = circuit_mul(in36, t75);
    let t77 = circuit_add(t70, t76);
    let t78 = circuit_sub(in224, in13);
    let t79 = circuit_mul(t72, t78);
    let t80 = circuit_sub(in224, in13);
    let t81 = circuit_mul(in3, t80);
    let t82 = circuit_inverse(t81);
    let t83 = circuit_mul(in37, t82);
    let t84 = circuit_add(t77, t83);
    let t85 = circuit_sub(in224, in14);
    let t86 = circuit_mul(t79, t85);
    let t87 = circuit_sub(in224, in14);
    let t88 = circuit_mul(in2, t87);
    let t89 = circuit_inverse(t88);
    let t90 = circuit_mul(in38, t89);
    let t91 = circuit_add(t84, t90);
    let t92 = circuit_mul(t91, t86);
    let t93 = circuit_sub(in241, in0);
    let t94 = circuit_mul(in224, t93);
    let t95 = circuit_add(in0, t94);
    let t96 = circuit_mul(in0, t95);
    let t97 = circuit_add(in39, in40);
    let t98 = circuit_sub(t97, t92);
    let t99 = circuit_mul(t98, t28);
    let t100 = circuit_add(t27, t99);
    let t101 = circuit_mul(t28, in263);
    let t102 = circuit_sub(in225, in7);
    let t103 = circuit_mul(in0, t102);
    let t104 = circuit_sub(in225, in7);
    let t105 = circuit_mul(in2, t104);
    let t106 = circuit_inverse(t105);
    let t107 = circuit_mul(in39, t106);
    let t108 = circuit_add(in7, t107);
    let t109 = circuit_sub(in225, in0);
    let t110 = circuit_mul(t103, t109);
    let t111 = circuit_sub(in225, in0);
    let t112 = circuit_mul(in3, t111);
    let t113 = circuit_inverse(t112);
    let t114 = circuit_mul(in40, t113);
    let t115 = circuit_add(t108, t114);
    let t116 = circuit_sub(in225, in8);
    let t117 = circuit_mul(t110, t116);
    let t118 = circuit_sub(in225, in8);
    let t119 = circuit_mul(in4, t118);
    let t120 = circuit_inverse(t119);
    let t121 = circuit_mul(in41, t120);
    let t122 = circuit_add(t115, t121);
    let t123 = circuit_sub(in225, in9);
    let t124 = circuit_mul(t117, t123);
    let t125 = circuit_sub(in225, in9);
    let t126 = circuit_mul(in5, t125);
    let t127 = circuit_inverse(t126);
    let t128 = circuit_mul(in42, t127);
    let t129 = circuit_add(t122, t128);
    let t130 = circuit_sub(in225, in10);
    let t131 = circuit_mul(t124, t130);
    let t132 = circuit_sub(in225, in10);
    let t133 = circuit_mul(in6, t132);
    let t134 = circuit_inverse(t133);
    let t135 = circuit_mul(in43, t134);
    let t136 = circuit_add(t129, t135);
    let t137 = circuit_sub(in225, in11);
    let t138 = circuit_mul(t131, t137);
    let t139 = circuit_sub(in225, in11);
    let t140 = circuit_mul(in5, t139);
    let t141 = circuit_inverse(t140);
    let t142 = circuit_mul(in44, t141);
    let t143 = circuit_add(t136, t142);
    let t144 = circuit_sub(in225, in12);
    let t145 = circuit_mul(t138, t144);
    let t146 = circuit_sub(in225, in12);
    let t147 = circuit_mul(in4, t146);
    let t148 = circuit_inverse(t147);
    let t149 = circuit_mul(in45, t148);
    let t150 = circuit_add(t143, t149);
    let t151 = circuit_sub(in225, in13);
    let t152 = circuit_mul(t145, t151);
    let t153 = circuit_sub(in225, in13);
    let t154 = circuit_mul(in3, t153);
    let t155 = circuit_inverse(t154);
    let t156 = circuit_mul(in46, t155);
    let t157 = circuit_add(t150, t156);
    let t158 = circuit_sub(in225, in14);
    let t159 = circuit_mul(t152, t158);
    let t160 = circuit_sub(in225, in14);
    let t161 = circuit_mul(in2, t160);
    let t162 = circuit_inverse(t161);
    let t163 = circuit_mul(in47, t162);
    let t164 = circuit_add(t157, t163);
    let t165 = circuit_mul(t164, t159);
    let t166 = circuit_sub(in242, in0);
    let t167 = circuit_mul(in225, t166);
    let t168 = circuit_add(in0, t167);
    let t169 = circuit_mul(t96, t168);
    let t170 = circuit_add(in48, in49);
    let t171 = circuit_sub(t170, t165);
    let t172 = circuit_mul(t171, t101);
    let t173 = circuit_add(t100, t172);
    let t174 = circuit_mul(t101, in263);
    let t175 = circuit_sub(in226, in7);
    let t176 = circuit_mul(in0, t175);
    let t177 = circuit_sub(in226, in7);
    let t178 = circuit_mul(in2, t177);
    let t179 = circuit_inverse(t178);
    let t180 = circuit_mul(in48, t179);
    let t181 = circuit_add(in7, t180);
    let t182 = circuit_sub(in226, in0);
    let t183 = circuit_mul(t176, t182);
    let t184 = circuit_sub(in226, in0);
    let t185 = circuit_mul(in3, t184);
    let t186 = circuit_inverse(t185);
    let t187 = circuit_mul(in49, t186);
    let t188 = circuit_add(t181, t187);
    let t189 = circuit_sub(in226, in8);
    let t190 = circuit_mul(t183, t189);
    let t191 = circuit_sub(in226, in8);
    let t192 = circuit_mul(in4, t191);
    let t193 = circuit_inverse(t192);
    let t194 = circuit_mul(in50, t193);
    let t195 = circuit_add(t188, t194);
    let t196 = circuit_sub(in226, in9);
    let t197 = circuit_mul(t190, t196);
    let t198 = circuit_sub(in226, in9);
    let t199 = circuit_mul(in5, t198);
    let t200 = circuit_inverse(t199);
    let t201 = circuit_mul(in51, t200);
    let t202 = circuit_add(t195, t201);
    let t203 = circuit_sub(in226, in10);
    let t204 = circuit_mul(t197, t203);
    let t205 = circuit_sub(in226, in10);
    let t206 = circuit_mul(in6, t205);
    let t207 = circuit_inverse(t206);
    let t208 = circuit_mul(in52, t207);
    let t209 = circuit_add(t202, t208);
    let t210 = circuit_sub(in226, in11);
    let t211 = circuit_mul(t204, t210);
    let t212 = circuit_sub(in226, in11);
    let t213 = circuit_mul(in5, t212);
    let t214 = circuit_inverse(t213);
    let t215 = circuit_mul(in53, t214);
    let t216 = circuit_add(t209, t215);
    let t217 = circuit_sub(in226, in12);
    let t218 = circuit_mul(t211, t217);
    let t219 = circuit_sub(in226, in12);
    let t220 = circuit_mul(in4, t219);
    let t221 = circuit_inverse(t220);
    let t222 = circuit_mul(in54, t221);
    let t223 = circuit_add(t216, t222);
    let t224 = circuit_sub(in226, in13);
    let t225 = circuit_mul(t218, t224);
    let t226 = circuit_sub(in226, in13);
    let t227 = circuit_mul(in3, t226);
    let t228 = circuit_inverse(t227);
    let t229 = circuit_mul(in55, t228);
    let t230 = circuit_add(t223, t229);
    let t231 = circuit_sub(in226, in14);
    let t232 = circuit_mul(t225, t231);
    let t233 = circuit_sub(in226, in14);
    let t234 = circuit_mul(in2, t233);
    let t235 = circuit_inverse(t234);
    let t236 = circuit_mul(in56, t235);
    let t237 = circuit_add(t230, t236);
    let t238 = circuit_mul(t237, t232);
    let t239 = circuit_sub(in243, in0);
    let t240 = circuit_mul(in226, t239);
    let t241 = circuit_add(in0, t240);
    let t242 = circuit_mul(t169, t241);
    let t243 = circuit_add(in57, in58);
    let t244 = circuit_sub(t243, t238);
    let t245 = circuit_mul(t244, t174);
    let t246 = circuit_add(t173, t245);
    let t247 = circuit_mul(t174, in263);
    let t248 = circuit_sub(in227, in7);
    let t249 = circuit_mul(in0, t248);
    let t250 = circuit_sub(in227, in7);
    let t251 = circuit_mul(in2, t250);
    let t252 = circuit_inverse(t251);
    let t253 = circuit_mul(in57, t252);
    let t254 = circuit_add(in7, t253);
    let t255 = circuit_sub(in227, in0);
    let t256 = circuit_mul(t249, t255);
    let t257 = circuit_sub(in227, in0);
    let t258 = circuit_mul(in3, t257);
    let t259 = circuit_inverse(t258);
    let t260 = circuit_mul(in58, t259);
    let t261 = circuit_add(t254, t260);
    let t262 = circuit_sub(in227, in8);
    let t263 = circuit_mul(t256, t262);
    let t264 = circuit_sub(in227, in8);
    let t265 = circuit_mul(in4, t264);
    let t266 = circuit_inverse(t265);
    let t267 = circuit_mul(in59, t266);
    let t268 = circuit_add(t261, t267);
    let t269 = circuit_sub(in227, in9);
    let t270 = circuit_mul(t263, t269);
    let t271 = circuit_sub(in227, in9);
    let t272 = circuit_mul(in5, t271);
    let t273 = circuit_inverse(t272);
    let t274 = circuit_mul(in60, t273);
    let t275 = circuit_add(t268, t274);
    let t276 = circuit_sub(in227, in10);
    let t277 = circuit_mul(t270, t276);
    let t278 = circuit_sub(in227, in10);
    let t279 = circuit_mul(in6, t278);
    let t280 = circuit_inverse(t279);
    let t281 = circuit_mul(in61, t280);
    let t282 = circuit_add(t275, t281);
    let t283 = circuit_sub(in227, in11);
    let t284 = circuit_mul(t277, t283);
    let t285 = circuit_sub(in227, in11);
    let t286 = circuit_mul(in5, t285);
    let t287 = circuit_inverse(t286);
    let t288 = circuit_mul(in62, t287);
    let t289 = circuit_add(t282, t288);
    let t290 = circuit_sub(in227, in12);
    let t291 = circuit_mul(t284, t290);
    let t292 = circuit_sub(in227, in12);
    let t293 = circuit_mul(in4, t292);
    let t294 = circuit_inverse(t293);
    let t295 = circuit_mul(in63, t294);
    let t296 = circuit_add(t289, t295);
    let t297 = circuit_sub(in227, in13);
    let t298 = circuit_mul(t291, t297);
    let t299 = circuit_sub(in227, in13);
    let t300 = circuit_mul(in3, t299);
    let t301 = circuit_inverse(t300);
    let t302 = circuit_mul(in64, t301);
    let t303 = circuit_add(t296, t302);
    let t304 = circuit_sub(in227, in14);
    let t305 = circuit_mul(t298, t304);
    let t306 = circuit_sub(in227, in14);
    let t307 = circuit_mul(in2, t306);
    let t308 = circuit_inverse(t307);
    let t309 = circuit_mul(in65, t308);
    let t310 = circuit_add(t303, t309);
    let t311 = circuit_mul(t310, t305);
    let t312 = circuit_sub(in244, in0);
    let t313 = circuit_mul(in227, t312);
    let t314 = circuit_add(in0, t313);
    let t315 = circuit_mul(t242, t314);
    let t316 = circuit_add(in66, in67);
    let t317 = circuit_sub(t316, t311);
    let t318 = circuit_mul(t317, t247);
    let t319 = circuit_add(t246, t318);
    let t320 = circuit_mul(t247, in263);
    let t321 = circuit_sub(in228, in7);
    let t322 = circuit_mul(in0, t321);
    let t323 = circuit_sub(in228, in7);
    let t324 = circuit_mul(in2, t323);
    let t325 = circuit_inverse(t324);
    let t326 = circuit_mul(in66, t325);
    let t327 = circuit_add(in7, t326);
    let t328 = circuit_sub(in228, in0);
    let t329 = circuit_mul(t322, t328);
    let t330 = circuit_sub(in228, in0);
    let t331 = circuit_mul(in3, t330);
    let t332 = circuit_inverse(t331);
    let t333 = circuit_mul(in67, t332);
    let t334 = circuit_add(t327, t333);
    let t335 = circuit_sub(in228, in8);
    let t336 = circuit_mul(t329, t335);
    let t337 = circuit_sub(in228, in8);
    let t338 = circuit_mul(in4, t337);
    let t339 = circuit_inverse(t338);
    let t340 = circuit_mul(in68, t339);
    let t341 = circuit_add(t334, t340);
    let t342 = circuit_sub(in228, in9);
    let t343 = circuit_mul(t336, t342);
    let t344 = circuit_sub(in228, in9);
    let t345 = circuit_mul(in5, t344);
    let t346 = circuit_inverse(t345);
    let t347 = circuit_mul(in69, t346);
    let t348 = circuit_add(t341, t347);
    let t349 = circuit_sub(in228, in10);
    let t350 = circuit_mul(t343, t349);
    let t351 = circuit_sub(in228, in10);
    let t352 = circuit_mul(in6, t351);
    let t353 = circuit_inverse(t352);
    let t354 = circuit_mul(in70, t353);
    let t355 = circuit_add(t348, t354);
    let t356 = circuit_sub(in228, in11);
    let t357 = circuit_mul(t350, t356);
    let t358 = circuit_sub(in228, in11);
    let t359 = circuit_mul(in5, t358);
    let t360 = circuit_inverse(t359);
    let t361 = circuit_mul(in71, t360);
    let t362 = circuit_add(t355, t361);
    let t363 = circuit_sub(in228, in12);
    let t364 = circuit_mul(t357, t363);
    let t365 = circuit_sub(in228, in12);
    let t366 = circuit_mul(in4, t365);
    let t367 = circuit_inverse(t366);
    let t368 = circuit_mul(in72, t367);
    let t369 = circuit_add(t362, t368);
    let t370 = circuit_sub(in228, in13);
    let t371 = circuit_mul(t364, t370);
    let t372 = circuit_sub(in228, in13);
    let t373 = circuit_mul(in3, t372);
    let t374 = circuit_inverse(t373);
    let t375 = circuit_mul(in73, t374);
    let t376 = circuit_add(t369, t375);
    let t377 = circuit_sub(in228, in14);
    let t378 = circuit_mul(t371, t377);
    let t379 = circuit_sub(in228, in14);
    let t380 = circuit_mul(in2, t379);
    let t381 = circuit_inverse(t380);
    let t382 = circuit_mul(in74, t381);
    let t383 = circuit_add(t376, t382);
    let t384 = circuit_mul(t383, t378);
    let t385 = circuit_sub(in245, in0);
    let t386 = circuit_mul(in228, t385);
    let t387 = circuit_add(in0, t386);
    let t388 = circuit_mul(t315, t387);
    let t389 = circuit_add(in75, in76);
    let t390 = circuit_sub(t389, t384);
    let t391 = circuit_mul(t390, t320);
    let t392 = circuit_add(t319, t391);
    let t393 = circuit_mul(t320, in263);
    let t394 = circuit_sub(in229, in7);
    let t395 = circuit_mul(in0, t394);
    let t396 = circuit_sub(in229, in7);
    let t397 = circuit_mul(in2, t396);
    let t398 = circuit_inverse(t397);
    let t399 = circuit_mul(in75, t398);
    let t400 = circuit_add(in7, t399);
    let t401 = circuit_sub(in229, in0);
    let t402 = circuit_mul(t395, t401);
    let t403 = circuit_sub(in229, in0);
    let t404 = circuit_mul(in3, t403);
    let t405 = circuit_inverse(t404);
    let t406 = circuit_mul(in76, t405);
    let t407 = circuit_add(t400, t406);
    let t408 = circuit_sub(in229, in8);
    let t409 = circuit_mul(t402, t408);
    let t410 = circuit_sub(in229, in8);
    let t411 = circuit_mul(in4, t410);
    let t412 = circuit_inverse(t411);
    let t413 = circuit_mul(in77, t412);
    let t414 = circuit_add(t407, t413);
    let t415 = circuit_sub(in229, in9);
    let t416 = circuit_mul(t409, t415);
    let t417 = circuit_sub(in229, in9);
    let t418 = circuit_mul(in5, t417);
    let t419 = circuit_inverse(t418);
    let t420 = circuit_mul(in78, t419);
    let t421 = circuit_add(t414, t420);
    let t422 = circuit_sub(in229, in10);
    let t423 = circuit_mul(t416, t422);
    let t424 = circuit_sub(in229, in10);
    let t425 = circuit_mul(in6, t424);
    let t426 = circuit_inverse(t425);
    let t427 = circuit_mul(in79, t426);
    let t428 = circuit_add(t421, t427);
    let t429 = circuit_sub(in229, in11);
    let t430 = circuit_mul(t423, t429);
    let t431 = circuit_sub(in229, in11);
    let t432 = circuit_mul(in5, t431);
    let t433 = circuit_inverse(t432);
    let t434 = circuit_mul(in80, t433);
    let t435 = circuit_add(t428, t434);
    let t436 = circuit_sub(in229, in12);
    let t437 = circuit_mul(t430, t436);
    let t438 = circuit_sub(in229, in12);
    let t439 = circuit_mul(in4, t438);
    let t440 = circuit_inverse(t439);
    let t441 = circuit_mul(in81, t440);
    let t442 = circuit_add(t435, t441);
    let t443 = circuit_sub(in229, in13);
    let t444 = circuit_mul(t437, t443);
    let t445 = circuit_sub(in229, in13);
    let t446 = circuit_mul(in3, t445);
    let t447 = circuit_inverse(t446);
    let t448 = circuit_mul(in82, t447);
    let t449 = circuit_add(t442, t448);
    let t450 = circuit_sub(in229, in14);
    let t451 = circuit_mul(t444, t450);
    let t452 = circuit_sub(in229, in14);
    let t453 = circuit_mul(in2, t452);
    let t454 = circuit_inverse(t453);
    let t455 = circuit_mul(in83, t454);
    let t456 = circuit_add(t449, t455);
    let t457 = circuit_mul(t456, t451);
    let t458 = circuit_sub(in246, in0);
    let t459 = circuit_mul(in229, t458);
    let t460 = circuit_add(in0, t459);
    let t461 = circuit_mul(t388, t460);
    let t462 = circuit_add(in84, in85);
    let t463 = circuit_sub(t462, t457);
    let t464 = circuit_mul(t463, t393);
    let t465 = circuit_add(t392, t464);
    let t466 = circuit_mul(t393, in263);
    let t467 = circuit_sub(in230, in7);
    let t468 = circuit_mul(in0, t467);
    let t469 = circuit_sub(in230, in7);
    let t470 = circuit_mul(in2, t469);
    let t471 = circuit_inverse(t470);
    let t472 = circuit_mul(in84, t471);
    let t473 = circuit_add(in7, t472);
    let t474 = circuit_sub(in230, in0);
    let t475 = circuit_mul(t468, t474);
    let t476 = circuit_sub(in230, in0);
    let t477 = circuit_mul(in3, t476);
    let t478 = circuit_inverse(t477);
    let t479 = circuit_mul(in85, t478);
    let t480 = circuit_add(t473, t479);
    let t481 = circuit_sub(in230, in8);
    let t482 = circuit_mul(t475, t481);
    let t483 = circuit_sub(in230, in8);
    let t484 = circuit_mul(in4, t483);
    let t485 = circuit_inverse(t484);
    let t486 = circuit_mul(in86, t485);
    let t487 = circuit_add(t480, t486);
    let t488 = circuit_sub(in230, in9);
    let t489 = circuit_mul(t482, t488);
    let t490 = circuit_sub(in230, in9);
    let t491 = circuit_mul(in5, t490);
    let t492 = circuit_inverse(t491);
    let t493 = circuit_mul(in87, t492);
    let t494 = circuit_add(t487, t493);
    let t495 = circuit_sub(in230, in10);
    let t496 = circuit_mul(t489, t495);
    let t497 = circuit_sub(in230, in10);
    let t498 = circuit_mul(in6, t497);
    let t499 = circuit_inverse(t498);
    let t500 = circuit_mul(in88, t499);
    let t501 = circuit_add(t494, t500);
    let t502 = circuit_sub(in230, in11);
    let t503 = circuit_mul(t496, t502);
    let t504 = circuit_sub(in230, in11);
    let t505 = circuit_mul(in5, t504);
    let t506 = circuit_inverse(t505);
    let t507 = circuit_mul(in89, t506);
    let t508 = circuit_add(t501, t507);
    let t509 = circuit_sub(in230, in12);
    let t510 = circuit_mul(t503, t509);
    let t511 = circuit_sub(in230, in12);
    let t512 = circuit_mul(in4, t511);
    let t513 = circuit_inverse(t512);
    let t514 = circuit_mul(in90, t513);
    let t515 = circuit_add(t508, t514);
    let t516 = circuit_sub(in230, in13);
    let t517 = circuit_mul(t510, t516);
    let t518 = circuit_sub(in230, in13);
    let t519 = circuit_mul(in3, t518);
    let t520 = circuit_inverse(t519);
    let t521 = circuit_mul(in91, t520);
    let t522 = circuit_add(t515, t521);
    let t523 = circuit_sub(in230, in14);
    let t524 = circuit_mul(t517, t523);
    let t525 = circuit_sub(in230, in14);
    let t526 = circuit_mul(in2, t525);
    let t527 = circuit_inverse(t526);
    let t528 = circuit_mul(in92, t527);
    let t529 = circuit_add(t522, t528);
    let t530 = circuit_mul(t529, t524);
    let t531 = circuit_sub(in247, in0);
    let t532 = circuit_mul(in230, t531);
    let t533 = circuit_add(in0, t532);
    let t534 = circuit_mul(t461, t533);
    let t535 = circuit_add(in93, in94);
    let t536 = circuit_sub(t535, t530);
    let t537 = circuit_mul(t536, t466);
    let t538 = circuit_add(t465, t537);
    let t539 = circuit_mul(t466, in263);
    let t540 = circuit_sub(in231, in7);
    let t541 = circuit_mul(in0, t540);
    let t542 = circuit_sub(in231, in7);
    let t543 = circuit_mul(in2, t542);
    let t544 = circuit_inverse(t543);
    let t545 = circuit_mul(in93, t544);
    let t546 = circuit_add(in7, t545);
    let t547 = circuit_sub(in231, in0);
    let t548 = circuit_mul(t541, t547);
    let t549 = circuit_sub(in231, in0);
    let t550 = circuit_mul(in3, t549);
    let t551 = circuit_inverse(t550);
    let t552 = circuit_mul(in94, t551);
    let t553 = circuit_add(t546, t552);
    let t554 = circuit_sub(in231, in8);
    let t555 = circuit_mul(t548, t554);
    let t556 = circuit_sub(in231, in8);
    let t557 = circuit_mul(in4, t556);
    let t558 = circuit_inverse(t557);
    let t559 = circuit_mul(in95, t558);
    let t560 = circuit_add(t553, t559);
    let t561 = circuit_sub(in231, in9);
    let t562 = circuit_mul(t555, t561);
    let t563 = circuit_sub(in231, in9);
    let t564 = circuit_mul(in5, t563);
    let t565 = circuit_inverse(t564);
    let t566 = circuit_mul(in96, t565);
    let t567 = circuit_add(t560, t566);
    let t568 = circuit_sub(in231, in10);
    let t569 = circuit_mul(t562, t568);
    let t570 = circuit_sub(in231, in10);
    let t571 = circuit_mul(in6, t570);
    let t572 = circuit_inverse(t571);
    let t573 = circuit_mul(in97, t572);
    let t574 = circuit_add(t567, t573);
    let t575 = circuit_sub(in231, in11);
    let t576 = circuit_mul(t569, t575);
    let t577 = circuit_sub(in231, in11);
    let t578 = circuit_mul(in5, t577);
    let t579 = circuit_inverse(t578);
    let t580 = circuit_mul(in98, t579);
    let t581 = circuit_add(t574, t580);
    let t582 = circuit_sub(in231, in12);
    let t583 = circuit_mul(t576, t582);
    let t584 = circuit_sub(in231, in12);
    let t585 = circuit_mul(in4, t584);
    let t586 = circuit_inverse(t585);
    let t587 = circuit_mul(in99, t586);
    let t588 = circuit_add(t581, t587);
    let t589 = circuit_sub(in231, in13);
    let t590 = circuit_mul(t583, t589);
    let t591 = circuit_sub(in231, in13);
    let t592 = circuit_mul(in3, t591);
    let t593 = circuit_inverse(t592);
    let t594 = circuit_mul(in100, t593);
    let t595 = circuit_add(t588, t594);
    let t596 = circuit_sub(in231, in14);
    let t597 = circuit_mul(t590, t596);
    let t598 = circuit_sub(in231, in14);
    let t599 = circuit_mul(in2, t598);
    let t600 = circuit_inverse(t599);
    let t601 = circuit_mul(in101, t600);
    let t602 = circuit_add(t595, t601);
    let t603 = circuit_mul(t602, t597);
    let t604 = circuit_sub(in248, in0);
    let t605 = circuit_mul(in231, t604);
    let t606 = circuit_add(in0, t605);
    let t607 = circuit_mul(t534, t606);
    let t608 = circuit_add(in102, in103);
    let t609 = circuit_sub(t608, t603);
    let t610 = circuit_mul(t609, t539);
    let t611 = circuit_add(t538, t610);
    let t612 = circuit_mul(t539, in263);
    let t613 = circuit_sub(in232, in7);
    let t614 = circuit_mul(in0, t613);
    let t615 = circuit_sub(in232, in7);
    let t616 = circuit_mul(in2, t615);
    let t617 = circuit_inverse(t616);
    let t618 = circuit_mul(in102, t617);
    let t619 = circuit_add(in7, t618);
    let t620 = circuit_sub(in232, in0);
    let t621 = circuit_mul(t614, t620);
    let t622 = circuit_sub(in232, in0);
    let t623 = circuit_mul(in3, t622);
    let t624 = circuit_inverse(t623);
    let t625 = circuit_mul(in103, t624);
    let t626 = circuit_add(t619, t625);
    let t627 = circuit_sub(in232, in8);
    let t628 = circuit_mul(t621, t627);
    let t629 = circuit_sub(in232, in8);
    let t630 = circuit_mul(in4, t629);
    let t631 = circuit_inverse(t630);
    let t632 = circuit_mul(in104, t631);
    let t633 = circuit_add(t626, t632);
    let t634 = circuit_sub(in232, in9);
    let t635 = circuit_mul(t628, t634);
    let t636 = circuit_sub(in232, in9);
    let t637 = circuit_mul(in5, t636);
    let t638 = circuit_inverse(t637);
    let t639 = circuit_mul(in105, t638);
    let t640 = circuit_add(t633, t639);
    let t641 = circuit_sub(in232, in10);
    let t642 = circuit_mul(t635, t641);
    let t643 = circuit_sub(in232, in10);
    let t644 = circuit_mul(in6, t643);
    let t645 = circuit_inverse(t644);
    let t646 = circuit_mul(in106, t645);
    let t647 = circuit_add(t640, t646);
    let t648 = circuit_sub(in232, in11);
    let t649 = circuit_mul(t642, t648);
    let t650 = circuit_sub(in232, in11);
    let t651 = circuit_mul(in5, t650);
    let t652 = circuit_inverse(t651);
    let t653 = circuit_mul(in107, t652);
    let t654 = circuit_add(t647, t653);
    let t655 = circuit_sub(in232, in12);
    let t656 = circuit_mul(t649, t655);
    let t657 = circuit_sub(in232, in12);
    let t658 = circuit_mul(in4, t657);
    let t659 = circuit_inverse(t658);
    let t660 = circuit_mul(in108, t659);
    let t661 = circuit_add(t654, t660);
    let t662 = circuit_sub(in232, in13);
    let t663 = circuit_mul(t656, t662);
    let t664 = circuit_sub(in232, in13);
    let t665 = circuit_mul(in3, t664);
    let t666 = circuit_inverse(t665);
    let t667 = circuit_mul(in109, t666);
    let t668 = circuit_add(t661, t667);
    let t669 = circuit_sub(in232, in14);
    let t670 = circuit_mul(t663, t669);
    let t671 = circuit_sub(in232, in14);
    let t672 = circuit_mul(in2, t671);
    let t673 = circuit_inverse(t672);
    let t674 = circuit_mul(in110, t673);
    let t675 = circuit_add(t668, t674);
    let t676 = circuit_mul(t675, t670);
    let t677 = circuit_sub(in249, in0);
    let t678 = circuit_mul(in232, t677);
    let t679 = circuit_add(in0, t678);
    let t680 = circuit_mul(t607, t679);
    let t681 = circuit_add(in111, in112);
    let t682 = circuit_sub(t681, t676);
    let t683 = circuit_mul(t682, t612);
    let t684 = circuit_add(t611, t683);
    let t685 = circuit_mul(t612, in263);
    let t686 = circuit_sub(in233, in7);
    let t687 = circuit_mul(in0, t686);
    let t688 = circuit_sub(in233, in7);
    let t689 = circuit_mul(in2, t688);
    let t690 = circuit_inverse(t689);
    let t691 = circuit_mul(in111, t690);
    let t692 = circuit_add(in7, t691);
    let t693 = circuit_sub(in233, in0);
    let t694 = circuit_mul(t687, t693);
    let t695 = circuit_sub(in233, in0);
    let t696 = circuit_mul(in3, t695);
    let t697 = circuit_inverse(t696);
    let t698 = circuit_mul(in112, t697);
    let t699 = circuit_add(t692, t698);
    let t700 = circuit_sub(in233, in8);
    let t701 = circuit_mul(t694, t700);
    let t702 = circuit_sub(in233, in8);
    let t703 = circuit_mul(in4, t702);
    let t704 = circuit_inverse(t703);
    let t705 = circuit_mul(in113, t704);
    let t706 = circuit_add(t699, t705);
    let t707 = circuit_sub(in233, in9);
    let t708 = circuit_mul(t701, t707);
    let t709 = circuit_sub(in233, in9);
    let t710 = circuit_mul(in5, t709);
    let t711 = circuit_inverse(t710);
    let t712 = circuit_mul(in114, t711);
    let t713 = circuit_add(t706, t712);
    let t714 = circuit_sub(in233, in10);
    let t715 = circuit_mul(t708, t714);
    let t716 = circuit_sub(in233, in10);
    let t717 = circuit_mul(in6, t716);
    let t718 = circuit_inverse(t717);
    let t719 = circuit_mul(in115, t718);
    let t720 = circuit_add(t713, t719);
    let t721 = circuit_sub(in233, in11);
    let t722 = circuit_mul(t715, t721);
    let t723 = circuit_sub(in233, in11);
    let t724 = circuit_mul(in5, t723);
    let t725 = circuit_inverse(t724);
    let t726 = circuit_mul(in116, t725);
    let t727 = circuit_add(t720, t726);
    let t728 = circuit_sub(in233, in12);
    let t729 = circuit_mul(t722, t728);
    let t730 = circuit_sub(in233, in12);
    let t731 = circuit_mul(in4, t730);
    let t732 = circuit_inverse(t731);
    let t733 = circuit_mul(in117, t732);
    let t734 = circuit_add(t727, t733);
    let t735 = circuit_sub(in233, in13);
    let t736 = circuit_mul(t729, t735);
    let t737 = circuit_sub(in233, in13);
    let t738 = circuit_mul(in3, t737);
    let t739 = circuit_inverse(t738);
    let t740 = circuit_mul(in118, t739);
    let t741 = circuit_add(t734, t740);
    let t742 = circuit_sub(in233, in14);
    let t743 = circuit_mul(t736, t742);
    let t744 = circuit_sub(in233, in14);
    let t745 = circuit_mul(in2, t744);
    let t746 = circuit_inverse(t745);
    let t747 = circuit_mul(in119, t746);
    let t748 = circuit_add(t741, t747);
    let t749 = circuit_mul(t748, t743);
    let t750 = circuit_sub(in250, in0);
    let t751 = circuit_mul(in233, t750);
    let t752 = circuit_add(in0, t751);
    let t753 = circuit_mul(t680, t752);
    let t754 = circuit_add(in120, in121);
    let t755 = circuit_sub(t754, t749);
    let t756 = circuit_mul(t755, t685);
    let t757 = circuit_add(t684, t756);
    let t758 = circuit_mul(t685, in263);
    let t759 = circuit_sub(in234, in7);
    let t760 = circuit_mul(in0, t759);
    let t761 = circuit_sub(in234, in7);
    let t762 = circuit_mul(in2, t761);
    let t763 = circuit_inverse(t762);
    let t764 = circuit_mul(in120, t763);
    let t765 = circuit_add(in7, t764);
    let t766 = circuit_sub(in234, in0);
    let t767 = circuit_mul(t760, t766);
    let t768 = circuit_sub(in234, in0);
    let t769 = circuit_mul(in3, t768);
    let t770 = circuit_inverse(t769);
    let t771 = circuit_mul(in121, t770);
    let t772 = circuit_add(t765, t771);
    let t773 = circuit_sub(in234, in8);
    let t774 = circuit_mul(t767, t773);
    let t775 = circuit_sub(in234, in8);
    let t776 = circuit_mul(in4, t775);
    let t777 = circuit_inverse(t776);
    let t778 = circuit_mul(in122, t777);
    let t779 = circuit_add(t772, t778);
    let t780 = circuit_sub(in234, in9);
    let t781 = circuit_mul(t774, t780);
    let t782 = circuit_sub(in234, in9);
    let t783 = circuit_mul(in5, t782);
    let t784 = circuit_inverse(t783);
    let t785 = circuit_mul(in123, t784);
    let t786 = circuit_add(t779, t785);
    let t787 = circuit_sub(in234, in10);
    let t788 = circuit_mul(t781, t787);
    let t789 = circuit_sub(in234, in10);
    let t790 = circuit_mul(in6, t789);
    let t791 = circuit_inverse(t790);
    let t792 = circuit_mul(in124, t791);
    let t793 = circuit_add(t786, t792);
    let t794 = circuit_sub(in234, in11);
    let t795 = circuit_mul(t788, t794);
    let t796 = circuit_sub(in234, in11);
    let t797 = circuit_mul(in5, t796);
    let t798 = circuit_inverse(t797);
    let t799 = circuit_mul(in125, t798);
    let t800 = circuit_add(t793, t799);
    let t801 = circuit_sub(in234, in12);
    let t802 = circuit_mul(t795, t801);
    let t803 = circuit_sub(in234, in12);
    let t804 = circuit_mul(in4, t803);
    let t805 = circuit_inverse(t804);
    let t806 = circuit_mul(in126, t805);
    let t807 = circuit_add(t800, t806);
    let t808 = circuit_sub(in234, in13);
    let t809 = circuit_mul(t802, t808);
    let t810 = circuit_sub(in234, in13);
    let t811 = circuit_mul(in3, t810);
    let t812 = circuit_inverse(t811);
    let t813 = circuit_mul(in127, t812);
    let t814 = circuit_add(t807, t813);
    let t815 = circuit_sub(in234, in14);
    let t816 = circuit_mul(t809, t815);
    let t817 = circuit_sub(in234, in14);
    let t818 = circuit_mul(in2, t817);
    let t819 = circuit_inverse(t818);
    let t820 = circuit_mul(in128, t819);
    let t821 = circuit_add(t814, t820);
    let t822 = circuit_mul(t821, t816);
    let t823 = circuit_sub(in251, in0);
    let t824 = circuit_mul(in234, t823);
    let t825 = circuit_add(in0, t824);
    let t826 = circuit_mul(t753, t825);
    let t827 = circuit_add(in129, in130);
    let t828 = circuit_sub(t827, t822);
    let t829 = circuit_mul(t828, t758);
    let t830 = circuit_add(t757, t829);
    let t831 = circuit_mul(t758, in263);
    let t832 = circuit_sub(in235, in7);
    let t833 = circuit_mul(in0, t832);
    let t834 = circuit_sub(in235, in7);
    let t835 = circuit_mul(in2, t834);
    let t836 = circuit_inverse(t835);
    let t837 = circuit_mul(in129, t836);
    let t838 = circuit_add(in7, t837);
    let t839 = circuit_sub(in235, in0);
    let t840 = circuit_mul(t833, t839);
    let t841 = circuit_sub(in235, in0);
    let t842 = circuit_mul(in3, t841);
    let t843 = circuit_inverse(t842);
    let t844 = circuit_mul(in130, t843);
    let t845 = circuit_add(t838, t844);
    let t846 = circuit_sub(in235, in8);
    let t847 = circuit_mul(t840, t846);
    let t848 = circuit_sub(in235, in8);
    let t849 = circuit_mul(in4, t848);
    let t850 = circuit_inverse(t849);
    let t851 = circuit_mul(in131, t850);
    let t852 = circuit_add(t845, t851);
    let t853 = circuit_sub(in235, in9);
    let t854 = circuit_mul(t847, t853);
    let t855 = circuit_sub(in235, in9);
    let t856 = circuit_mul(in5, t855);
    let t857 = circuit_inverse(t856);
    let t858 = circuit_mul(in132, t857);
    let t859 = circuit_add(t852, t858);
    let t860 = circuit_sub(in235, in10);
    let t861 = circuit_mul(t854, t860);
    let t862 = circuit_sub(in235, in10);
    let t863 = circuit_mul(in6, t862);
    let t864 = circuit_inverse(t863);
    let t865 = circuit_mul(in133, t864);
    let t866 = circuit_add(t859, t865);
    let t867 = circuit_sub(in235, in11);
    let t868 = circuit_mul(t861, t867);
    let t869 = circuit_sub(in235, in11);
    let t870 = circuit_mul(in5, t869);
    let t871 = circuit_inverse(t870);
    let t872 = circuit_mul(in134, t871);
    let t873 = circuit_add(t866, t872);
    let t874 = circuit_sub(in235, in12);
    let t875 = circuit_mul(t868, t874);
    let t876 = circuit_sub(in235, in12);
    let t877 = circuit_mul(in4, t876);
    let t878 = circuit_inverse(t877);
    let t879 = circuit_mul(in135, t878);
    let t880 = circuit_add(t873, t879);
    let t881 = circuit_sub(in235, in13);
    let t882 = circuit_mul(t875, t881);
    let t883 = circuit_sub(in235, in13);
    let t884 = circuit_mul(in3, t883);
    let t885 = circuit_inverse(t884);
    let t886 = circuit_mul(in136, t885);
    let t887 = circuit_add(t880, t886);
    let t888 = circuit_sub(in235, in14);
    let t889 = circuit_mul(t882, t888);
    let t890 = circuit_sub(in235, in14);
    let t891 = circuit_mul(in2, t890);
    let t892 = circuit_inverse(t891);
    let t893 = circuit_mul(in137, t892);
    let t894 = circuit_add(t887, t893);
    let t895 = circuit_mul(t894, t889);
    let t896 = circuit_sub(in252, in0);
    let t897 = circuit_mul(in235, t896);
    let t898 = circuit_add(in0, t897);
    let t899 = circuit_mul(t826, t898);
    let t900 = circuit_add(in138, in139);
    let t901 = circuit_sub(t900, t895);
    let t902 = circuit_mul(t901, t831);
    let t903 = circuit_add(t830, t902);
    let t904 = circuit_mul(t831, in263);
    let t905 = circuit_sub(in236, in7);
    let t906 = circuit_mul(in0, t905);
    let t907 = circuit_sub(in236, in7);
    let t908 = circuit_mul(in2, t907);
    let t909 = circuit_inverse(t908);
    let t910 = circuit_mul(in138, t909);
    let t911 = circuit_add(in7, t910);
    let t912 = circuit_sub(in236, in0);
    let t913 = circuit_mul(t906, t912);
    let t914 = circuit_sub(in236, in0);
    let t915 = circuit_mul(in3, t914);
    let t916 = circuit_inverse(t915);
    let t917 = circuit_mul(in139, t916);
    let t918 = circuit_add(t911, t917);
    let t919 = circuit_sub(in236, in8);
    let t920 = circuit_mul(t913, t919);
    let t921 = circuit_sub(in236, in8);
    let t922 = circuit_mul(in4, t921);
    let t923 = circuit_inverse(t922);
    let t924 = circuit_mul(in140, t923);
    let t925 = circuit_add(t918, t924);
    let t926 = circuit_sub(in236, in9);
    let t927 = circuit_mul(t920, t926);
    let t928 = circuit_sub(in236, in9);
    let t929 = circuit_mul(in5, t928);
    let t930 = circuit_inverse(t929);
    let t931 = circuit_mul(in141, t930);
    let t932 = circuit_add(t925, t931);
    let t933 = circuit_sub(in236, in10);
    let t934 = circuit_mul(t927, t933);
    let t935 = circuit_sub(in236, in10);
    let t936 = circuit_mul(in6, t935);
    let t937 = circuit_inverse(t936);
    let t938 = circuit_mul(in142, t937);
    let t939 = circuit_add(t932, t938);
    let t940 = circuit_sub(in236, in11);
    let t941 = circuit_mul(t934, t940);
    let t942 = circuit_sub(in236, in11);
    let t943 = circuit_mul(in5, t942);
    let t944 = circuit_inverse(t943);
    let t945 = circuit_mul(in143, t944);
    let t946 = circuit_add(t939, t945);
    let t947 = circuit_sub(in236, in12);
    let t948 = circuit_mul(t941, t947);
    let t949 = circuit_sub(in236, in12);
    let t950 = circuit_mul(in4, t949);
    let t951 = circuit_inverse(t950);
    let t952 = circuit_mul(in144, t951);
    let t953 = circuit_add(t946, t952);
    let t954 = circuit_sub(in236, in13);
    let t955 = circuit_mul(t948, t954);
    let t956 = circuit_sub(in236, in13);
    let t957 = circuit_mul(in3, t956);
    let t958 = circuit_inverse(t957);
    let t959 = circuit_mul(in145, t958);
    let t960 = circuit_add(t953, t959);
    let t961 = circuit_sub(in236, in14);
    let t962 = circuit_mul(t955, t961);
    let t963 = circuit_sub(in236, in14);
    let t964 = circuit_mul(in2, t963);
    let t965 = circuit_inverse(t964);
    let t966 = circuit_mul(in146, t965);
    let t967 = circuit_add(t960, t966);
    let t968 = circuit_mul(t967, t962);
    let t969 = circuit_sub(in253, in0);
    let t970 = circuit_mul(in236, t969);
    let t971 = circuit_add(in0, t970);
    let t972 = circuit_mul(t899, t971);
    let t973 = circuit_add(in147, in148);
    let t974 = circuit_sub(t973, t968);
    let t975 = circuit_mul(t974, t904);
    let t976 = circuit_add(t903, t975);
    let t977 = circuit_mul(t904, in263);
    let t978 = circuit_sub(in237, in7);
    let t979 = circuit_mul(in0, t978);
    let t980 = circuit_sub(in237, in7);
    let t981 = circuit_mul(in2, t980);
    let t982 = circuit_inverse(t981);
    let t983 = circuit_mul(in147, t982);
    let t984 = circuit_add(in7, t983);
    let t985 = circuit_sub(in237, in0);
    let t986 = circuit_mul(t979, t985);
    let t987 = circuit_sub(in237, in0);
    let t988 = circuit_mul(in3, t987);
    let t989 = circuit_inverse(t988);
    let t990 = circuit_mul(in148, t989);
    let t991 = circuit_add(t984, t990);
    let t992 = circuit_sub(in237, in8);
    let t993 = circuit_mul(t986, t992);
    let t994 = circuit_sub(in237, in8);
    let t995 = circuit_mul(in4, t994);
    let t996 = circuit_inverse(t995);
    let t997 = circuit_mul(in149, t996);
    let t998 = circuit_add(t991, t997);
    let t999 = circuit_sub(in237, in9);
    let t1000 = circuit_mul(t993, t999);
    let t1001 = circuit_sub(in237, in9);
    let t1002 = circuit_mul(in5, t1001);
    let t1003 = circuit_inverse(t1002);
    let t1004 = circuit_mul(in150, t1003);
    let t1005 = circuit_add(t998, t1004);
    let t1006 = circuit_sub(in237, in10);
    let t1007 = circuit_mul(t1000, t1006);
    let t1008 = circuit_sub(in237, in10);
    let t1009 = circuit_mul(in6, t1008);
    let t1010 = circuit_inverse(t1009);
    let t1011 = circuit_mul(in151, t1010);
    let t1012 = circuit_add(t1005, t1011);
    let t1013 = circuit_sub(in237, in11);
    let t1014 = circuit_mul(t1007, t1013);
    let t1015 = circuit_sub(in237, in11);
    let t1016 = circuit_mul(in5, t1015);
    let t1017 = circuit_inverse(t1016);
    let t1018 = circuit_mul(in152, t1017);
    let t1019 = circuit_add(t1012, t1018);
    let t1020 = circuit_sub(in237, in12);
    let t1021 = circuit_mul(t1014, t1020);
    let t1022 = circuit_sub(in237, in12);
    let t1023 = circuit_mul(in4, t1022);
    let t1024 = circuit_inverse(t1023);
    let t1025 = circuit_mul(in153, t1024);
    let t1026 = circuit_add(t1019, t1025);
    let t1027 = circuit_sub(in237, in13);
    let t1028 = circuit_mul(t1021, t1027);
    let t1029 = circuit_sub(in237, in13);
    let t1030 = circuit_mul(in3, t1029);
    let t1031 = circuit_inverse(t1030);
    let t1032 = circuit_mul(in154, t1031);
    let t1033 = circuit_add(t1026, t1032);
    let t1034 = circuit_sub(in237, in14);
    let t1035 = circuit_mul(t1028, t1034);
    let t1036 = circuit_sub(in237, in14);
    let t1037 = circuit_mul(in2, t1036);
    let t1038 = circuit_inverse(t1037);
    let t1039 = circuit_mul(in155, t1038);
    let t1040 = circuit_add(t1033, t1039);
    let t1041 = circuit_mul(t1040, t1035);
    let t1042 = circuit_sub(in254, in0);
    let t1043 = circuit_mul(in237, t1042);
    let t1044 = circuit_add(in0, t1043);
    let t1045 = circuit_mul(t972, t1044);
    let t1046 = circuit_add(in156, in157);
    let t1047 = circuit_sub(t1046, t1041);
    let t1048 = circuit_mul(t1047, t977);
    let t1049 = circuit_add(t976, t1048);
    let t1050 = circuit_mul(t977, in263);
    let t1051 = circuit_sub(in238, in7);
    let t1052 = circuit_mul(in0, t1051);
    let t1053 = circuit_sub(in238, in7);
    let t1054 = circuit_mul(in2, t1053);
    let t1055 = circuit_inverse(t1054);
    let t1056 = circuit_mul(in156, t1055);
    let t1057 = circuit_add(in7, t1056);
    let t1058 = circuit_sub(in238, in0);
    let t1059 = circuit_mul(t1052, t1058);
    let t1060 = circuit_sub(in238, in0);
    let t1061 = circuit_mul(in3, t1060);
    let t1062 = circuit_inverse(t1061);
    let t1063 = circuit_mul(in157, t1062);
    let t1064 = circuit_add(t1057, t1063);
    let t1065 = circuit_sub(in238, in8);
    let t1066 = circuit_mul(t1059, t1065);
    let t1067 = circuit_sub(in238, in8);
    let t1068 = circuit_mul(in4, t1067);
    let t1069 = circuit_inverse(t1068);
    let t1070 = circuit_mul(in158, t1069);
    let t1071 = circuit_add(t1064, t1070);
    let t1072 = circuit_sub(in238, in9);
    let t1073 = circuit_mul(t1066, t1072);
    let t1074 = circuit_sub(in238, in9);
    let t1075 = circuit_mul(in5, t1074);
    let t1076 = circuit_inverse(t1075);
    let t1077 = circuit_mul(in159, t1076);
    let t1078 = circuit_add(t1071, t1077);
    let t1079 = circuit_sub(in238, in10);
    let t1080 = circuit_mul(t1073, t1079);
    let t1081 = circuit_sub(in238, in10);
    let t1082 = circuit_mul(in6, t1081);
    let t1083 = circuit_inverse(t1082);
    let t1084 = circuit_mul(in160, t1083);
    let t1085 = circuit_add(t1078, t1084);
    let t1086 = circuit_sub(in238, in11);
    let t1087 = circuit_mul(t1080, t1086);
    let t1088 = circuit_sub(in238, in11);
    let t1089 = circuit_mul(in5, t1088);
    let t1090 = circuit_inverse(t1089);
    let t1091 = circuit_mul(in161, t1090);
    let t1092 = circuit_add(t1085, t1091);
    let t1093 = circuit_sub(in238, in12);
    let t1094 = circuit_mul(t1087, t1093);
    let t1095 = circuit_sub(in238, in12);
    let t1096 = circuit_mul(in4, t1095);
    let t1097 = circuit_inverse(t1096);
    let t1098 = circuit_mul(in162, t1097);
    let t1099 = circuit_add(t1092, t1098);
    let t1100 = circuit_sub(in238, in13);
    let t1101 = circuit_mul(t1094, t1100);
    let t1102 = circuit_sub(in238, in13);
    let t1103 = circuit_mul(in3, t1102);
    let t1104 = circuit_inverse(t1103);
    let t1105 = circuit_mul(in163, t1104);
    let t1106 = circuit_add(t1099, t1105);
    let t1107 = circuit_sub(in238, in14);
    let t1108 = circuit_mul(t1101, t1107);
    let t1109 = circuit_sub(in238, in14);
    let t1110 = circuit_mul(in2, t1109);
    let t1111 = circuit_inverse(t1110);
    let t1112 = circuit_mul(in164, t1111);
    let t1113 = circuit_add(t1106, t1112);
    let t1114 = circuit_mul(t1113, t1108);
    let t1115 = circuit_sub(in255, in0);
    let t1116 = circuit_mul(in238, t1115);
    let t1117 = circuit_add(in0, t1116);
    let t1118 = circuit_mul(t1045, t1117);
    let t1119 = circuit_add(in165, in166);
    let t1120 = circuit_sub(t1119, t1114);
    let t1121 = circuit_mul(t1120, t1050);
    let t1122 = circuit_add(t1049, t1121);
    let t1123 = circuit_mul(t1050, in263);
    let t1124 = circuit_sub(in239, in7);
    let t1125 = circuit_mul(in0, t1124);
    let t1126 = circuit_sub(in239, in7);
    let t1127 = circuit_mul(in2, t1126);
    let t1128 = circuit_inverse(t1127);
    let t1129 = circuit_mul(in165, t1128);
    let t1130 = circuit_add(in7, t1129);
    let t1131 = circuit_sub(in239, in0);
    let t1132 = circuit_mul(t1125, t1131);
    let t1133 = circuit_sub(in239, in0);
    let t1134 = circuit_mul(in3, t1133);
    let t1135 = circuit_inverse(t1134);
    let t1136 = circuit_mul(in166, t1135);
    let t1137 = circuit_add(t1130, t1136);
    let t1138 = circuit_sub(in239, in8);
    let t1139 = circuit_mul(t1132, t1138);
    let t1140 = circuit_sub(in239, in8);
    let t1141 = circuit_mul(in4, t1140);
    let t1142 = circuit_inverse(t1141);
    let t1143 = circuit_mul(in167, t1142);
    let t1144 = circuit_add(t1137, t1143);
    let t1145 = circuit_sub(in239, in9);
    let t1146 = circuit_mul(t1139, t1145);
    let t1147 = circuit_sub(in239, in9);
    let t1148 = circuit_mul(in5, t1147);
    let t1149 = circuit_inverse(t1148);
    let t1150 = circuit_mul(in168, t1149);
    let t1151 = circuit_add(t1144, t1150);
    let t1152 = circuit_sub(in239, in10);
    let t1153 = circuit_mul(t1146, t1152);
    let t1154 = circuit_sub(in239, in10);
    let t1155 = circuit_mul(in6, t1154);
    let t1156 = circuit_inverse(t1155);
    let t1157 = circuit_mul(in169, t1156);
    let t1158 = circuit_add(t1151, t1157);
    let t1159 = circuit_sub(in239, in11);
    let t1160 = circuit_mul(t1153, t1159);
    let t1161 = circuit_sub(in239, in11);
    let t1162 = circuit_mul(in5, t1161);
    let t1163 = circuit_inverse(t1162);
    let t1164 = circuit_mul(in170, t1163);
    let t1165 = circuit_add(t1158, t1164);
    let t1166 = circuit_sub(in239, in12);
    let t1167 = circuit_mul(t1160, t1166);
    let t1168 = circuit_sub(in239, in12);
    let t1169 = circuit_mul(in4, t1168);
    let t1170 = circuit_inverse(t1169);
    let t1171 = circuit_mul(in171, t1170);
    let t1172 = circuit_add(t1165, t1171);
    let t1173 = circuit_sub(in239, in13);
    let t1174 = circuit_mul(t1167, t1173);
    let t1175 = circuit_sub(in239, in13);
    let t1176 = circuit_mul(in3, t1175);
    let t1177 = circuit_inverse(t1176);
    let t1178 = circuit_mul(in172, t1177);
    let t1179 = circuit_add(t1172, t1178);
    let t1180 = circuit_sub(in239, in14);
    let t1181 = circuit_mul(t1174, t1180);
    let t1182 = circuit_sub(in239, in14);
    let t1183 = circuit_mul(in2, t1182);
    let t1184 = circuit_inverse(t1183);
    let t1185 = circuit_mul(in173, t1184);
    let t1186 = circuit_add(t1179, t1185);
    let t1187 = circuit_mul(t1186, t1181);
    let t1188 = circuit_sub(in256, in0);
    let t1189 = circuit_mul(in239, t1188);
    let t1190 = circuit_add(in0, t1189);
    let t1191 = circuit_mul(t1118, t1190);
    let t1192 = circuit_add(in174, in175);
    let t1193 = circuit_sub(t1192, t1187);
    let t1194 = circuit_mul(t1193, t1123);
    let t1195 = circuit_add(t1122, t1194);
    let t1196 = circuit_sub(in240, in7);
    let t1197 = circuit_mul(in0, t1196);
    let t1198 = circuit_sub(in240, in7);
    let t1199 = circuit_mul(in2, t1198);
    let t1200 = circuit_inverse(t1199);
    let t1201 = circuit_mul(in174, t1200);
    let t1202 = circuit_add(in7, t1201);
    let t1203 = circuit_sub(in240, in0);
    let t1204 = circuit_mul(t1197, t1203);
    let t1205 = circuit_sub(in240, in0);
    let t1206 = circuit_mul(in3, t1205);
    let t1207 = circuit_inverse(t1206);
    let t1208 = circuit_mul(in175, t1207);
    let t1209 = circuit_add(t1202, t1208);
    let t1210 = circuit_sub(in240, in8);
    let t1211 = circuit_mul(t1204, t1210);
    let t1212 = circuit_sub(in240, in8);
    let t1213 = circuit_mul(in4, t1212);
    let t1214 = circuit_inverse(t1213);
    let t1215 = circuit_mul(in176, t1214);
    let t1216 = circuit_add(t1209, t1215);
    let t1217 = circuit_sub(in240, in9);
    let t1218 = circuit_mul(t1211, t1217);
    let t1219 = circuit_sub(in240, in9);
    let t1220 = circuit_mul(in5, t1219);
    let t1221 = circuit_inverse(t1220);
    let t1222 = circuit_mul(in177, t1221);
    let t1223 = circuit_add(t1216, t1222);
    let t1224 = circuit_sub(in240, in10);
    let t1225 = circuit_mul(t1218, t1224);
    let t1226 = circuit_sub(in240, in10);
    let t1227 = circuit_mul(in6, t1226);
    let t1228 = circuit_inverse(t1227);
    let t1229 = circuit_mul(in178, t1228);
    let t1230 = circuit_add(t1223, t1229);
    let t1231 = circuit_sub(in240, in11);
    let t1232 = circuit_mul(t1225, t1231);
    let t1233 = circuit_sub(in240, in11);
    let t1234 = circuit_mul(in5, t1233);
    let t1235 = circuit_inverse(t1234);
    let t1236 = circuit_mul(in179, t1235);
    let t1237 = circuit_add(t1230, t1236);
    let t1238 = circuit_sub(in240, in12);
    let t1239 = circuit_mul(t1232, t1238);
    let t1240 = circuit_sub(in240, in12);
    let t1241 = circuit_mul(in4, t1240);
    let t1242 = circuit_inverse(t1241);
    let t1243 = circuit_mul(in180, t1242);
    let t1244 = circuit_add(t1237, t1243);
    let t1245 = circuit_sub(in240, in13);
    let t1246 = circuit_mul(t1239, t1245);
    let t1247 = circuit_sub(in240, in13);
    let t1248 = circuit_mul(in3, t1247);
    let t1249 = circuit_inverse(t1248);
    let t1250 = circuit_mul(in181, t1249);
    let t1251 = circuit_add(t1244, t1250);
    let t1252 = circuit_sub(in240, in14);
    let t1253 = circuit_mul(t1246, t1252);
    let t1254 = circuit_sub(in240, in14);
    let t1255 = circuit_mul(in2, t1254);
    let t1256 = circuit_inverse(t1255);
    let t1257 = circuit_mul(in182, t1256);
    let t1258 = circuit_add(t1251, t1257);
    let t1259 = circuit_mul(t1258, t1253);
    let t1260 = circuit_sub(in257, in0);
    let t1261 = circuit_mul(in240, t1260);
    let t1262 = circuit_add(in0, t1261);
    let t1263 = circuit_mul(t1191, t1262);
    let t1264 = circuit_sub(in190, in9);
    let t1265 = circuit_mul(t1264, in183);
    let t1266 = circuit_mul(t1265, in211);
    let t1267 = circuit_mul(t1266, in210);
    let t1268 = circuit_mul(t1267, in15);
    let t1269 = circuit_mul(in185, in210);
    let t1270 = circuit_mul(in186, in211);
    let t1271 = circuit_mul(in187, in212);
    let t1272 = circuit_mul(in188, in213);
    let t1273 = circuit_add(t1268, t1269);
    let t1274 = circuit_add(t1273, t1270);
    let t1275 = circuit_add(t1274, t1271);
    let t1276 = circuit_add(t1275, t1272);
    let t1277 = circuit_add(t1276, in184);
    let t1278 = circuit_sub(in190, in0);
    let t1279 = circuit_mul(t1278, in221);
    let t1280 = circuit_add(t1277, t1279);
    let t1281 = circuit_mul(t1280, in190);
    let t1282 = circuit_mul(t1281, t1263);
    let t1283 = circuit_add(in210, in213);
    let t1284 = circuit_add(t1283, in183);
    let t1285 = circuit_sub(t1284, in218);
    let t1286 = circuit_sub(in190, in8);
    let t1287 = circuit_mul(t1285, t1286);
    let t1288 = circuit_sub(in190, in0);
    let t1289 = circuit_mul(t1287, t1288);
    let t1290 = circuit_mul(t1289, in190);
    let t1291 = circuit_mul(t1290, t1263);
    let t1292 = circuit_mul(in200, in261);
    let t1293 = circuit_add(in210, t1292);
    let t1294 = circuit_add(t1293, in262);
    let t1295 = circuit_mul(in201, in261);
    let t1296 = circuit_add(in211, t1295);
    let t1297 = circuit_add(t1296, in262);
    let t1298 = circuit_mul(t1294, t1297);
    let t1299 = circuit_mul(in202, in261);
    let t1300 = circuit_add(in212, t1299);
    let t1301 = circuit_add(t1300, in262);
    let t1302 = circuit_mul(t1298, t1301);
    let t1303 = circuit_mul(in203, in261);
    let t1304 = circuit_add(in213, t1303);
    let t1305 = circuit_add(t1304, in262);
    let t1306 = circuit_mul(t1302, t1305);
    let t1307 = circuit_mul(in196, in261);
    let t1308 = circuit_add(in210, t1307);
    let t1309 = circuit_add(t1308, in262);
    let t1310 = circuit_mul(in197, in261);
    let t1311 = circuit_add(in211, t1310);
    let t1312 = circuit_add(t1311, in262);
    let t1313 = circuit_mul(t1309, t1312);
    let t1314 = circuit_mul(in198, in261);
    let t1315 = circuit_add(in212, t1314);
    let t1316 = circuit_add(t1315, in262);
    let t1317 = circuit_mul(t1313, t1316);
    let t1318 = circuit_mul(in199, in261);
    let t1319 = circuit_add(in213, t1318);
    let t1320 = circuit_add(t1319, in262);
    let t1321 = circuit_mul(t1317, t1320);
    let t1322 = circuit_add(in214, in208);
    let t1323 = circuit_mul(t1306, t1322);
    let t1324 = circuit_mul(in209, t23);
    let t1325 = circuit_add(in222, t1324);
    let t1326 = circuit_mul(t1321, t1325);
    let t1327 = circuit_sub(t1323, t1326);
    let t1328 = circuit_mul(t1327, t1263);
    let t1329 = circuit_mul(in209, in222);
    let t1330 = circuit_mul(t1329, t1263);
    let t1331 = circuit_mul(in205, in258);
    let t1332 = circuit_mul(in206, in259);
    let t1333 = circuit_mul(in207, in260);
    let t1334 = circuit_add(in204, in262);
    let t1335 = circuit_add(t1334, t1331);
    let t1336 = circuit_add(t1335, t1332);
    let t1337 = circuit_add(t1336, t1333);
    let t1338 = circuit_mul(in186, in218);
    let t1339 = circuit_add(in210, in262);
    let t1340 = circuit_add(t1339, t1338);
    let t1341 = circuit_mul(in183, in219);
    let t1342 = circuit_add(in211, t1341);
    let t1343 = circuit_mul(in184, in220);
    let t1344 = circuit_add(in212, t1343);
    let t1345 = circuit_mul(t1342, in258);
    let t1346 = circuit_mul(t1344, in259);
    let t1347 = circuit_mul(in187, in260);
    let t1348 = circuit_add(t1340, t1345);
    let t1349 = circuit_add(t1348, t1346);
    let t1350 = circuit_add(t1349, t1347);
    let t1351 = circuit_mul(in215, t1337);
    let t1352 = circuit_mul(in215, t1350);
    let t1353 = circuit_add(in217, in189);
    let t1354 = circuit_mul(in217, in189);
    let t1355 = circuit_sub(t1353, t1354);
    let t1356 = circuit_mul(t1350, t1337);
    let t1357 = circuit_mul(t1356, in215);
    let t1358 = circuit_sub(t1357, t1355);
    let t1359 = circuit_mul(t1358, t1263);
    let t1360 = circuit_mul(in189, t1351);
    let t1361 = circuit_mul(in216, t1352);
    let t1362 = circuit_sub(t1360, t1361);
    let t1363 = circuit_mul(in191, t1263);
    let t1364 = circuit_sub(in211, in210);
    let t1365 = circuit_sub(in212, in211);
    let t1366 = circuit_sub(in213, in212);
    let t1367 = circuit_sub(in218, in213);
    let t1368 = circuit_add(t1364, in16);
    let t1369 = circuit_add(t1368, in16);
    let t1370 = circuit_add(t1369, in16);
    let t1371 = circuit_mul(t1364, t1368);
    let t1372 = circuit_mul(t1371, t1369);
    let t1373 = circuit_mul(t1372, t1370);
    let t1374 = circuit_mul(t1373, t1363);
    let t1375 = circuit_add(t1365, in16);
    let t1376 = circuit_add(t1375, in16);
    let t1377 = circuit_add(t1376, in16);
    let t1378 = circuit_mul(t1365, t1375);
    let t1379 = circuit_mul(t1378, t1376);
    let t1380 = circuit_mul(t1379, t1377);
    let t1381 = circuit_mul(t1380, t1363);
    let t1382 = circuit_add(t1366, in16);
    let t1383 = circuit_add(t1382, in16);
    let t1384 = circuit_add(t1383, in16);
    let t1385 = circuit_mul(t1366, t1382);
    let t1386 = circuit_mul(t1385, t1383);
    let t1387 = circuit_mul(t1386, t1384);
    let t1388 = circuit_mul(t1387, t1363);
    let t1389 = circuit_add(t1367, in16);
    let t1390 = circuit_add(t1389, in16);
    let t1391 = circuit_add(t1390, in16);
    let t1392 = circuit_mul(t1367, t1389);
    let t1393 = circuit_mul(t1392, t1390);
    let t1394 = circuit_mul(t1393, t1391);
    let t1395 = circuit_mul(t1394, t1363);
    let t1396 = circuit_sub(in218, in211);
    let t1397 = circuit_mul(in212, in212);
    let t1398 = circuit_mul(in221, in221);
    let t1399 = circuit_mul(in212, in221);
    let t1400 = circuit_mul(t1399, in185);
    let t1401 = circuit_add(in219, in218);
    let t1402 = circuit_add(t1401, in211);
    let t1403 = circuit_mul(t1402, t1396);
    let t1404 = circuit_mul(t1403, t1396);
    let t1405 = circuit_sub(t1404, t1398);
    let t1406 = circuit_sub(t1405, t1397);
    let t1407 = circuit_add(t1406, t1400);
    let t1408 = circuit_add(t1407, t1400);
    let t1409 = circuit_sub(in0, in183);
    let t1410 = circuit_mul(t1408, t1263);
    let t1411 = circuit_mul(t1410, in192);
    let t1412 = circuit_mul(t1411, t1409);
    let t1413 = circuit_add(in212, in220);
    let t1414 = circuit_mul(in221, in185);
    let t1415 = circuit_sub(t1414, in212);
    let t1416 = circuit_mul(t1413, t1396);
    let t1417 = circuit_sub(in219, in211);
    let t1418 = circuit_mul(t1417, t1415);
    let t1419 = circuit_add(t1416, t1418);
    let t1420 = circuit_mul(t1419, t1263);
    let t1421 = circuit_mul(t1420, in192);
    let t1422 = circuit_mul(t1421, t1409);
    let t1423 = circuit_add(t1397, in17);
    let t1424 = circuit_mul(t1423, in211);
    let t1425 = circuit_add(t1397, t1397);
    let t1426 = circuit_add(t1425, t1425);
    let t1427 = circuit_mul(t1424, in18);
    let t1428 = circuit_add(in219, in211);
    let t1429 = circuit_add(t1428, in211);
    let t1430 = circuit_mul(t1429, t1426);
    let t1431 = circuit_sub(t1430, t1427);
    let t1432 = circuit_mul(t1431, t1263);
    let t1433 = circuit_mul(t1432, in192);
    let t1434 = circuit_mul(t1433, in183);
    let t1435 = circuit_add(t1412, t1434);
    let t1436 = circuit_add(in211, in211);
    let t1437 = circuit_add(t1436, in211);
    let t1438 = circuit_mul(t1437, in211);
    let t1439 = circuit_sub(in211, in219);
    let t1440 = circuit_mul(t1438, t1439);
    let t1441 = circuit_add(in212, in212);
    let t1442 = circuit_add(in212, in220);
    let t1443 = circuit_mul(t1441, t1442);
    let t1444 = circuit_sub(t1440, t1443);
    let t1445 = circuit_mul(t1444, t1263);
    let t1446 = circuit_mul(t1445, in192);
    let t1447 = circuit_mul(t1446, in183);
    let t1448 = circuit_add(t1422, t1447);
    let t1449 = circuit_mul(in210, in219);
    let t1450 = circuit_mul(in218, in211);
    let t1451 = circuit_add(t1449, t1450);
    let t1452 = circuit_mul(in210, in213);
    let t1453 = circuit_mul(in211, in212);
    let t1454 = circuit_add(t1452, t1453);
    let t1455 = circuit_sub(t1454, in220);
    let t1456 = circuit_mul(t1455, in19);
    let t1457 = circuit_sub(t1456, in221);
    let t1458 = circuit_add(t1457, t1451);
    let t1459 = circuit_mul(t1458, in188);
    let t1460 = circuit_mul(t1451, in19);
    let t1461 = circuit_mul(in218, in219);
    let t1462 = circuit_add(t1460, t1461);
    let t1463 = circuit_add(in212, in213);
    let t1464 = circuit_sub(t1462, t1463);
    let t1465 = circuit_mul(t1464, in187);
    let t1466 = circuit_add(t1462, in213);
    let t1467 = circuit_add(in220, in221);
    let t1468 = circuit_sub(t1466, t1467);
    let t1469 = circuit_mul(t1468, in183);
    let t1470 = circuit_add(t1465, t1459);
    let t1471 = circuit_add(t1470, t1469);
    let t1472 = circuit_mul(t1471, in186);
    let t1473 = circuit_mul(in219, in20);
    let t1474 = circuit_add(t1473, in218);
    let t1475 = circuit_mul(t1474, in20);
    let t1476 = circuit_add(t1475, in212);
    let t1477 = circuit_mul(t1476, in20);
    let t1478 = circuit_add(t1477, in211);
    let t1479 = circuit_mul(t1478, in20);
    let t1480 = circuit_add(t1479, in210);
    let t1481 = circuit_sub(t1480, in213);
    let t1482 = circuit_mul(t1481, in188);
    let t1483 = circuit_mul(in220, in20);
    let t1484 = circuit_add(t1483, in219);
    let t1485 = circuit_mul(t1484, in20);
    let t1486 = circuit_add(t1485, in218);
    let t1487 = circuit_mul(t1486, in20);
    let t1488 = circuit_add(t1487, in213);
    let t1489 = circuit_mul(t1488, in20);
    let t1490 = circuit_add(t1489, in212);
    let t1491 = circuit_sub(t1490, in221);
    let t1492 = circuit_mul(t1491, in183);
    let t1493 = circuit_add(t1482, t1492);
    let t1494 = circuit_mul(t1493, in187);
    let t1495 = circuit_mul(in212, in260);
    let t1496 = circuit_mul(in211, in259);
    let t1497 = circuit_mul(in210, in258);
    let t1498 = circuit_add(t1495, t1496);
    let t1499 = circuit_add(t1498, t1497);
    let t1500 = circuit_add(t1499, in184);
    let t1501 = circuit_sub(t1500, in213);
    let t1502 = circuit_sub(in218, in210);
    let t1503 = circuit_sub(in221, in213);
    let t1504 = circuit_mul(t1502, t1502);
    let t1505 = circuit_sub(t1504, t1502);
    let t1506 = circuit_sub(in7, t1502);
    let t1507 = circuit_add(t1506, in0);
    let t1508 = circuit_mul(t1507, t1503);
    let t1509 = circuit_mul(in185, in186);
    let t1510 = circuit_mul(t1509, in193);
    let t1511 = circuit_mul(t1510, t1263);
    let t1512 = circuit_mul(t1508, t1511);
    let t1513 = circuit_mul(t1505, t1511);
    let t1514 = circuit_mul(t1501, t1509);
    let t1515 = circuit_sub(in213, t1500);
    let t1516 = circuit_mul(t1515, t1515);
    let t1517 = circuit_sub(t1516, t1515);
    let t1518 = circuit_mul(in220, in260);
    let t1519 = circuit_mul(in219, in259);
    let t1520 = circuit_mul(in218, in258);
    let t1521 = circuit_add(t1518, t1519);
    let t1522 = circuit_add(t1521, t1520);
    let t1523 = circuit_sub(in221, t1522);
    let t1524 = circuit_sub(in220, in212);
    let t1525 = circuit_sub(in7, t1502);
    let t1526 = circuit_add(t1525, in0);
    let t1527 = circuit_sub(in7, t1523);
    let t1528 = circuit_add(t1527, in0);
    let t1529 = circuit_mul(t1524, t1528);
    let t1530 = circuit_mul(t1526, t1529);
    let t1531 = circuit_mul(t1523, t1523);
    let t1532 = circuit_sub(t1531, t1523);
    let t1533 = circuit_mul(in190, in193);
    let t1534 = circuit_mul(t1533, t1263);
    let t1535 = circuit_mul(t1530, t1534);
    let t1536 = circuit_mul(t1505, t1534);
    let t1537 = circuit_mul(t1532, t1534);
    let t1538 = circuit_mul(t1517, in190);
    let t1539 = circuit_sub(in219, in211);
    let t1540 = circuit_sub(in7, t1502);
    let t1541 = circuit_add(t1540, in0);
    let t1542 = circuit_mul(t1541, t1539);
    let t1543 = circuit_sub(t1542, in212);
    let t1544 = circuit_mul(t1543, in188);
    let t1545 = circuit_mul(t1544, in185);
    let t1546 = circuit_add(t1514, t1545);
    let t1547 = circuit_mul(t1501, in183);
    let t1548 = circuit_mul(t1547, in185);
    let t1549 = circuit_add(t1546, t1548);
    let t1550 = circuit_add(t1549, t1538);
    let t1551 = circuit_add(t1550, t1472);
    let t1552 = circuit_add(t1551, t1494);
    let t1553 = circuit_mul(t1552, in193);
    let t1554 = circuit_mul(t1553, t1263);
    let t1555 = circuit_add(in210, in185);
    let t1556 = circuit_add(in211, in186);
    let t1557 = circuit_add(in212, in187);
    let t1558 = circuit_add(in213, in188);
    let t1559 = circuit_mul(t1555, t1555);
    let t1560 = circuit_mul(t1559, t1559);
    let t1561 = circuit_mul(t1560, t1555);
    let t1562 = circuit_mul(t1556, t1556);
    let t1563 = circuit_mul(t1562, t1562);
    let t1564 = circuit_mul(t1563, t1556);
    let t1565 = circuit_mul(t1557, t1557);
    let t1566 = circuit_mul(t1565, t1565);
    let t1567 = circuit_mul(t1566, t1557);
    let t1568 = circuit_mul(t1558, t1558);
    let t1569 = circuit_mul(t1568, t1568);
    let t1570 = circuit_mul(t1569, t1558);
    let t1571 = circuit_add(t1561, t1564);
    let t1572 = circuit_add(t1567, t1570);
    let t1573 = circuit_add(t1564, t1564);
    let t1574 = circuit_add(t1573, t1572);
    let t1575 = circuit_add(t1570, t1570);
    let t1576 = circuit_add(t1575, t1571);
    let t1577 = circuit_add(t1572, t1572);
    let t1578 = circuit_add(t1577, t1577);
    let t1579 = circuit_add(t1578, t1576);
    let t1580 = circuit_add(t1571, t1571);
    let t1581 = circuit_add(t1580, t1580);
    let t1582 = circuit_add(t1581, t1574);
    let t1583 = circuit_add(t1576, t1582);
    let t1584 = circuit_add(t1574, t1579);
    let t1585 = circuit_mul(in194, t1263);
    let t1586 = circuit_sub(t1583, in218);
    let t1587 = circuit_mul(t1585, t1586);
    let t1588 = circuit_sub(t1582, in219);
    let t1589 = circuit_mul(t1585, t1588);
    let t1590 = circuit_sub(t1584, in220);
    let t1591 = circuit_mul(t1585, t1590);
    let t1592 = circuit_sub(t1579, in221);
    let t1593 = circuit_mul(t1585, t1592);
    let t1594 = circuit_add(in210, in185);
    let t1595 = circuit_mul(t1594, t1594);
    let t1596 = circuit_mul(t1595, t1595);
    let t1597 = circuit_mul(t1596, t1594);
    let t1598 = circuit_add(t1597, in211);
    let t1599 = circuit_add(t1598, in212);
    let t1600 = circuit_add(t1599, in213);
    let t1601 = circuit_mul(in195, t1263);
    let t1602 = circuit_mul(t1597, in21);
    let t1603 = circuit_add(t1602, t1600);
    let t1604 = circuit_sub(t1603, in218);
    let t1605 = circuit_mul(t1601, t1604);
    let t1606 = circuit_mul(in211, in22);
    let t1607 = circuit_add(t1606, t1600);
    let t1608 = circuit_sub(t1607, in219);
    let t1609 = circuit_mul(t1601, t1608);
    let t1610 = circuit_mul(in212, in23);
    let t1611 = circuit_add(t1610, t1600);
    let t1612 = circuit_sub(t1611, in220);
    let t1613 = circuit_mul(t1601, t1612);
    let t1614 = circuit_mul(in213, in24);
    let t1615 = circuit_add(t1614, t1600);
    let t1616 = circuit_sub(t1615, in221);
    let t1617 = circuit_mul(t1601, t1616);
    let t1618 = circuit_mul(t1291, in264);
    let t1619 = circuit_add(t1282, t1618);
    let t1620 = circuit_mul(t1328, in265);
    let t1621 = circuit_add(t1619, t1620);
    let t1622 = circuit_mul(t1330, in266);
    let t1623 = circuit_add(t1621, t1622);
    let t1624 = circuit_mul(t1359, in267);
    let t1625 = circuit_add(t1623, t1624);
    let t1626 = circuit_mul(t1362, in268);
    let t1627 = circuit_add(t1625, t1626);
    let t1628 = circuit_mul(t1374, in269);
    let t1629 = circuit_add(t1627, t1628);
    let t1630 = circuit_mul(t1381, in270);
    let t1631 = circuit_add(t1629, t1630);
    let t1632 = circuit_mul(t1388, in271);
    let t1633 = circuit_add(t1631, t1632);
    let t1634 = circuit_mul(t1395, in272);
    let t1635 = circuit_add(t1633, t1634);
    let t1636 = circuit_mul(t1435, in273);
    let t1637 = circuit_add(t1635, t1636);
    let t1638 = circuit_mul(t1448, in274);
    let t1639 = circuit_add(t1637, t1638);
    let t1640 = circuit_mul(t1554, in275);
    let t1641 = circuit_add(t1639, t1640);
    let t1642 = circuit_mul(t1512, in276);
    let t1643 = circuit_add(t1641, t1642);
    let t1644 = circuit_mul(t1513, in277);
    let t1645 = circuit_add(t1643, t1644);
    let t1646 = circuit_mul(t1535, in278);
    let t1647 = circuit_add(t1645, t1646);
    let t1648 = circuit_mul(t1536, in279);
    let t1649 = circuit_add(t1647, t1648);
    let t1650 = circuit_mul(t1537, in280);
    let t1651 = circuit_add(t1649, t1650);
    let t1652 = circuit_mul(t1587, in281);
    let t1653 = circuit_add(t1651, t1652);
    let t1654 = circuit_mul(t1589, in282);
    let t1655 = circuit_add(t1653, t1654);
    let t1656 = circuit_mul(t1591, in283);
    let t1657 = circuit_add(t1655, t1656);
    let t1658 = circuit_mul(t1593, in284);
    let t1659 = circuit_add(t1657, t1658);
    let t1660 = circuit_mul(t1605, in285);
    let t1661 = circuit_add(t1659, t1660);
    let t1662 = circuit_mul(t1609, in286);
    let t1663 = circuit_add(t1661, t1662);
    let t1664 = circuit_mul(t1613, in287);
    let t1665 = circuit_add(t1663, t1664);
    let t1666 = circuit_mul(t1617, in288);
    let t1667 = circuit_add(t1665, t1666);
    let t1668 = circuit_mul(in0, in226);
    let t1669 = circuit_mul(t1668, in227);
    let t1670 = circuit_mul(t1669, in228);
    let t1671 = circuit_mul(t1670, in229);
    let t1672 = circuit_mul(t1671, in230);
    let t1673 = circuit_mul(t1672, in231);
    let t1674 = circuit_mul(t1673, in232);
    let t1675 = circuit_mul(t1674, in233);
    let t1676 = circuit_mul(t1675, in234);
    let t1677 = circuit_mul(t1676, in235);
    let t1678 = circuit_mul(t1677, in236);
    let t1679 = circuit_mul(t1678, in237);
    let t1680 = circuit_mul(t1679, in238);
    let t1681 = circuit_mul(t1680, in239);
    let t1682 = circuit_mul(t1681, in240);
    let t1683 = circuit_sub(in0, t1682);
    let t1684 = circuit_mul(t1667, t1683);
    let t1685 = circuit_mul(in223, in289);
    let t1686 = circuit_add(t1684, t1685);
    let t1687 = circuit_sub(t1686, t1259);

    let modulus = get_GRUMPKIN_modulus(); // GRUMPKIN prime field modulus

    let mut circuit_inputs = (t1195, t1687).new_inputs();
    // Prefill constants:

    circuit_inputs = circuit_inputs
        .next_span(ZK_HONK_SUMCHECK_SIZE_17_PUB_3_GRUMPKIN_CONSTANTS.span()); // in0 - in24

    // Fill inputs:

    for val in p_public_inputs {
        circuit_inputs = circuit_inputs.next_u256(*val);
    } // in25 - in27

    circuit_inputs = circuit_inputs.next_2(p_public_inputs_offset); // in28
    circuit_inputs = circuit_inputs.next_2(libra_sum); // in29

    for val in sumcheck_univariates_flat {
        circuit_inputs = circuit_inputs.next_u256(*val);
    } // in30 - in182

    for val in sumcheck_evaluations {
        circuit_inputs = circuit_inputs.next_u256(*val);
    } // in183 - in222

    circuit_inputs = circuit_inputs.next_2(libra_evaluation); // in223

    for val in tp_sum_check_u_challenges {
        circuit_inputs = circuit_inputs.next_u128(*val);
    } // in224 - in240

    for val in tp_gate_challenges {
        circuit_inputs = circuit_inputs.next_u128(*val);
    } // in241 - in257

    circuit_inputs = circuit_inputs.next_2(tp_eta_1); // in258
    circuit_inputs = circuit_inputs.next_2(tp_eta_2); // in259
    circuit_inputs = circuit_inputs.next_2(tp_eta_3); // in260
    circuit_inputs = circuit_inputs.next_2(tp_beta); // in261
    circuit_inputs = circuit_inputs.next_2(tp_gamma); // in262
    circuit_inputs = circuit_inputs.next_2(tp_base_rlc); // in263

    for val in tp_alphas {
        circuit_inputs = circuit_inputs.next_u128(*val);
    } // in264 - in288

    circuit_inputs = circuit_inputs.next_2(tp_libra_challenge); // in289

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let check_rlc: u384 = outputs.get_output(t1195);
    let check: u384 = outputs.get_output(t1687);
    return (check_rlc, check);
}
const ZK_HONK_SUMCHECK_SIZE_17_PUB_3_GRUMPKIN_CONSTANTS: [u384; 25] = [
    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x20000, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
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
pub fn run_GRUMPKIN_ZKHONK_PREP_MSM_SCALARS_SIZE_17_circuit(
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
    let (in84, in85) = (CE::<CI<84>> {}, CE::<CI<85>> {});
    let t0 = circuit_mul(in65, in65);
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
    let t16 = circuit_sub(in67, in65);
    let t17 = circuit_inverse(t16);
    let t18 = circuit_add(in67, in65);
    let t19 = circuit_inverse(t18);
    let t20 = circuit_mul(in68, t19);
    let t21 = circuit_add(t17, t20);
    let t22 = circuit_sub(in0, t21);
    let t23 = circuit_inverse(in65);
    let t24 = circuit_mul(in68, t19);
    let t25 = circuit_sub(t17, t24);
    let t26 = circuit_mul(t23, t25);
    let t27 = circuit_sub(in0, t26);
    let t28 = circuit_mul(t22, in66);
    let t29 = circuit_mul(in3, in66);
    let t30 = circuit_add(in43, t29);
    let t31 = circuit_mul(in66, in66);
    let t32 = circuit_mul(t22, t31);
    let t33 = circuit_mul(in4, t31);
    let t34 = circuit_add(t30, t33);
    let t35 = circuit_mul(t31, in66);
    let t36 = circuit_mul(t22, t35);
    let t37 = circuit_mul(in5, t35);
    let t38 = circuit_add(t34, t37);
    let t39 = circuit_mul(t35, in66);
    let t40 = circuit_mul(t22, t39);
    let t41 = circuit_mul(in6, t39);
    let t42 = circuit_add(t38, t41);
    let t43 = circuit_mul(t39, in66);
    let t44 = circuit_mul(t22, t43);
    let t45 = circuit_mul(in7, t43);
    let t46 = circuit_add(t42, t45);
    let t47 = circuit_mul(t43, in66);
    let t48 = circuit_mul(t22, t47);
    let t49 = circuit_mul(in8, t47);
    let t50 = circuit_add(t46, t49);
    let t51 = circuit_mul(t47, in66);
    let t52 = circuit_mul(t22, t51);
    let t53 = circuit_mul(in9, t51);
    let t54 = circuit_add(t50, t53);
    let t55 = circuit_mul(t51, in66);
    let t56 = circuit_mul(t22, t55);
    let t57 = circuit_mul(in10, t55);
    let t58 = circuit_add(t54, t57);
    let t59 = circuit_mul(t55, in66);
    let t60 = circuit_mul(t22, t59);
    let t61 = circuit_mul(in11, t59);
    let t62 = circuit_add(t58, t61);
    let t63 = circuit_mul(t59, in66);
    let t64 = circuit_mul(t22, t63);
    let t65 = circuit_mul(in12, t63);
    let t66 = circuit_add(t62, t65);
    let t67 = circuit_mul(t63, in66);
    let t68 = circuit_mul(t22, t67);
    let t69 = circuit_mul(in13, t67);
    let t70 = circuit_add(t66, t69);
    let t71 = circuit_mul(t67, in66);
    let t72 = circuit_mul(t22, t71);
    let t73 = circuit_mul(in14, t71);
    let t74 = circuit_add(t70, t73);
    let t75 = circuit_mul(t71, in66);
    let t76 = circuit_mul(t22, t75);
    let t77 = circuit_mul(in15, t75);
    let t78 = circuit_add(t74, t77);
    let t79 = circuit_mul(t75, in66);
    let t80 = circuit_mul(t22, t79);
    let t81 = circuit_mul(in16, t79);
    let t82 = circuit_add(t78, t81);
    let t83 = circuit_mul(t79, in66);
    let t84 = circuit_mul(t22, t83);
    let t85 = circuit_mul(in17, t83);
    let t86 = circuit_add(t82, t85);
    let t87 = circuit_mul(t83, in66);
    let t88 = circuit_mul(t22, t87);
    let t89 = circuit_mul(in18, t87);
    let t90 = circuit_add(t86, t89);
    let t91 = circuit_mul(t87, in66);
    let t92 = circuit_mul(t22, t91);
    let t93 = circuit_mul(in19, t91);
    let t94 = circuit_add(t90, t93);
    let t95 = circuit_mul(t91, in66);
    let t96 = circuit_mul(t22, t95);
    let t97 = circuit_mul(in20, t95);
    let t98 = circuit_add(t94, t97);
    let t99 = circuit_mul(t95, in66);
    let t100 = circuit_mul(t22, t99);
    let t101 = circuit_mul(in21, t99);
    let t102 = circuit_add(t98, t101);
    let t103 = circuit_mul(t99, in66);
    let t104 = circuit_mul(t22, t103);
    let t105 = circuit_mul(in22, t103);
    let t106 = circuit_add(t102, t105);
    let t107 = circuit_mul(t103, in66);
    let t108 = circuit_mul(t22, t107);
    let t109 = circuit_mul(in23, t107);
    let t110 = circuit_add(t106, t109);
    let t111 = circuit_mul(t107, in66);
    let t112 = circuit_mul(t22, t111);
    let t113 = circuit_mul(in24, t111);
    let t114 = circuit_add(t110, t113);
    let t115 = circuit_mul(t111, in66);
    let t116 = circuit_mul(t22, t115);
    let t117 = circuit_mul(in25, t115);
    let t118 = circuit_add(t114, t117);
    let t119 = circuit_mul(t115, in66);
    let t120 = circuit_mul(t22, t119);
    let t121 = circuit_mul(in26, t119);
    let t122 = circuit_add(t118, t121);
    let t123 = circuit_mul(t119, in66);
    let t124 = circuit_mul(t22, t123);
    let t125 = circuit_mul(in27, t123);
    let t126 = circuit_add(t122, t125);
    let t127 = circuit_mul(t123, in66);
    let t128 = circuit_mul(t22, t127);
    let t129 = circuit_mul(in28, t127);
    let t130 = circuit_add(t126, t129);
    let t131 = circuit_mul(t127, in66);
    let t132 = circuit_mul(t22, t131);
    let t133 = circuit_mul(in29, t131);
    let t134 = circuit_add(t130, t133);
    let t135 = circuit_mul(t131, in66);
    let t136 = circuit_mul(t22, t135);
    let t137 = circuit_mul(in30, t135);
    let t138 = circuit_add(t134, t137);
    let t139 = circuit_mul(t135, in66);
    let t140 = circuit_mul(t22, t139);
    let t141 = circuit_mul(in31, t139);
    let t142 = circuit_add(t138, t141);
    let t143 = circuit_mul(t139, in66);
    let t144 = circuit_mul(t22, t143);
    let t145 = circuit_mul(in32, t143);
    let t146 = circuit_add(t142, t145);
    let t147 = circuit_mul(t143, in66);
    let t148 = circuit_mul(t22, t147);
    let t149 = circuit_mul(in33, t147);
    let t150 = circuit_add(t146, t149);
    let t151 = circuit_mul(t147, in66);
    let t152 = circuit_mul(t22, t151);
    let t153 = circuit_mul(in34, t151);
    let t154 = circuit_add(t150, t153);
    let t155 = circuit_mul(t151, in66);
    let t156 = circuit_mul(t22, t155);
    let t157 = circuit_mul(in35, t155);
    let t158 = circuit_add(t154, t157);
    let t159 = circuit_mul(t155, in66);
    let t160 = circuit_mul(t22, t159);
    let t161 = circuit_mul(in36, t159);
    let t162 = circuit_add(t158, t161);
    let t163 = circuit_mul(t159, in66);
    let t164 = circuit_mul(t22, t163);
    let t165 = circuit_mul(in37, t163);
    let t166 = circuit_add(t162, t165);
    let t167 = circuit_mul(t163, in66);
    let t168 = circuit_mul(t27, t167);
    let t169 = circuit_mul(in38, t167);
    let t170 = circuit_add(t166, t169);
    let t171 = circuit_mul(t167, in66);
    let t172 = circuit_mul(t27, t171);
    let t173 = circuit_mul(in39, t171);
    let t174 = circuit_add(t170, t173);
    let t175 = circuit_mul(t171, in66);
    let t176 = circuit_mul(t27, t175);
    let t177 = circuit_mul(in40, t175);
    let t178 = circuit_add(t174, t177);
    let t179 = circuit_mul(t175, in66);
    let t180 = circuit_mul(t27, t179);
    let t181 = circuit_mul(in41, t179);
    let t182 = circuit_add(t178, t181);
    let t183 = circuit_mul(t179, in66);
    let t184 = circuit_mul(t27, t183);
    let t185 = circuit_mul(in42, t183);
    let t186 = circuit_add(t182, t185);
    let t187 = circuit_sub(in1, in85);
    let t188 = circuit_mul(t15, t187);
    let t189 = circuit_mul(t15, t186);
    let t190 = circuit_add(t189, t189);
    let t191 = circuit_sub(t188, in85);
    let t192 = circuit_mul(in60, t191);
    let t193 = circuit_sub(t190, t192);
    let t194 = circuit_add(t188, in85);
    let t195 = circuit_inverse(t194);
    let t196 = circuit_mul(t193, t195);
    let t197 = circuit_sub(in1, in84);
    let t198 = circuit_mul(t14, t197);
    let t199 = circuit_mul(t14, t196);
    let t200 = circuit_add(t199, t199);
    let t201 = circuit_sub(t198, in84);
    let t202 = circuit_mul(in59, t201);
    let t203 = circuit_sub(t200, t202);
    let t204 = circuit_add(t198, in84);
    let t205 = circuit_inverse(t204);
    let t206 = circuit_mul(t203, t205);
    let t207 = circuit_sub(in1, in83);
    let t208 = circuit_mul(t13, t207);
    let t209 = circuit_mul(t13, t206);
    let t210 = circuit_add(t209, t209);
    let t211 = circuit_sub(t208, in83);
    let t212 = circuit_mul(in58, t211);
    let t213 = circuit_sub(t210, t212);
    let t214 = circuit_add(t208, in83);
    let t215 = circuit_inverse(t214);
    let t216 = circuit_mul(t213, t215);
    let t217 = circuit_sub(in1, in82);
    let t218 = circuit_mul(t12, t217);
    let t219 = circuit_mul(t12, t216);
    let t220 = circuit_add(t219, t219);
    let t221 = circuit_sub(t218, in82);
    let t222 = circuit_mul(in57, t221);
    let t223 = circuit_sub(t220, t222);
    let t224 = circuit_add(t218, in82);
    let t225 = circuit_inverse(t224);
    let t226 = circuit_mul(t223, t225);
    let t227 = circuit_sub(in1, in81);
    let t228 = circuit_mul(t11, t227);
    let t229 = circuit_mul(t11, t226);
    let t230 = circuit_add(t229, t229);
    let t231 = circuit_sub(t228, in81);
    let t232 = circuit_mul(in56, t231);
    let t233 = circuit_sub(t230, t232);
    let t234 = circuit_add(t228, in81);
    let t235 = circuit_inverse(t234);
    let t236 = circuit_mul(t233, t235);
    let t237 = circuit_sub(in1, in80);
    let t238 = circuit_mul(t10, t237);
    let t239 = circuit_mul(t10, t236);
    let t240 = circuit_add(t239, t239);
    let t241 = circuit_sub(t238, in80);
    let t242 = circuit_mul(in55, t241);
    let t243 = circuit_sub(t240, t242);
    let t244 = circuit_add(t238, in80);
    let t245 = circuit_inverse(t244);
    let t246 = circuit_mul(t243, t245);
    let t247 = circuit_sub(in1, in79);
    let t248 = circuit_mul(t9, t247);
    let t249 = circuit_mul(t9, t246);
    let t250 = circuit_add(t249, t249);
    let t251 = circuit_sub(t248, in79);
    let t252 = circuit_mul(in54, t251);
    let t253 = circuit_sub(t250, t252);
    let t254 = circuit_add(t248, in79);
    let t255 = circuit_inverse(t254);
    let t256 = circuit_mul(t253, t255);
    let t257 = circuit_sub(in1, in78);
    let t258 = circuit_mul(t8, t257);
    let t259 = circuit_mul(t8, t256);
    let t260 = circuit_add(t259, t259);
    let t261 = circuit_sub(t258, in78);
    let t262 = circuit_mul(in53, t261);
    let t263 = circuit_sub(t260, t262);
    let t264 = circuit_add(t258, in78);
    let t265 = circuit_inverse(t264);
    let t266 = circuit_mul(t263, t265);
    let t267 = circuit_sub(in1, in77);
    let t268 = circuit_mul(t7, t267);
    let t269 = circuit_mul(t7, t266);
    let t270 = circuit_add(t269, t269);
    let t271 = circuit_sub(t268, in77);
    let t272 = circuit_mul(in52, t271);
    let t273 = circuit_sub(t270, t272);
    let t274 = circuit_add(t268, in77);
    let t275 = circuit_inverse(t274);
    let t276 = circuit_mul(t273, t275);
    let t277 = circuit_sub(in1, in76);
    let t278 = circuit_mul(t6, t277);
    let t279 = circuit_mul(t6, t276);
    let t280 = circuit_add(t279, t279);
    let t281 = circuit_sub(t278, in76);
    let t282 = circuit_mul(in51, t281);
    let t283 = circuit_sub(t280, t282);
    let t284 = circuit_add(t278, in76);
    let t285 = circuit_inverse(t284);
    let t286 = circuit_mul(t283, t285);
    let t287 = circuit_sub(in1, in75);
    let t288 = circuit_mul(t5, t287);
    let t289 = circuit_mul(t5, t286);
    let t290 = circuit_add(t289, t289);
    let t291 = circuit_sub(t288, in75);
    let t292 = circuit_mul(in50, t291);
    let t293 = circuit_sub(t290, t292);
    let t294 = circuit_add(t288, in75);
    let t295 = circuit_inverse(t294);
    let t296 = circuit_mul(t293, t295);
    let t297 = circuit_sub(in1, in74);
    let t298 = circuit_mul(t4, t297);
    let t299 = circuit_mul(t4, t296);
    let t300 = circuit_add(t299, t299);
    let t301 = circuit_sub(t298, in74);
    let t302 = circuit_mul(in49, t301);
    let t303 = circuit_sub(t300, t302);
    let t304 = circuit_add(t298, in74);
    let t305 = circuit_inverse(t304);
    let t306 = circuit_mul(t303, t305);
    let t307 = circuit_sub(in1, in73);
    let t308 = circuit_mul(t3, t307);
    let t309 = circuit_mul(t3, t306);
    let t310 = circuit_add(t309, t309);
    let t311 = circuit_sub(t308, in73);
    let t312 = circuit_mul(in48, t311);
    let t313 = circuit_sub(t310, t312);
    let t314 = circuit_add(t308, in73);
    let t315 = circuit_inverse(t314);
    let t316 = circuit_mul(t313, t315);
    let t317 = circuit_sub(in1, in72);
    let t318 = circuit_mul(t2, t317);
    let t319 = circuit_mul(t2, t316);
    let t320 = circuit_add(t319, t319);
    let t321 = circuit_sub(t318, in72);
    let t322 = circuit_mul(in47, t321);
    let t323 = circuit_sub(t320, t322);
    let t324 = circuit_add(t318, in72);
    let t325 = circuit_inverse(t324);
    let t326 = circuit_mul(t323, t325);
    let t327 = circuit_sub(in1, in71);
    let t328 = circuit_mul(t1, t327);
    let t329 = circuit_mul(t1, t326);
    let t330 = circuit_add(t329, t329);
    let t331 = circuit_sub(t328, in71);
    let t332 = circuit_mul(in46, t331);
    let t333 = circuit_sub(t330, t332);
    let t334 = circuit_add(t328, in71);
    let t335 = circuit_inverse(t334);
    let t336 = circuit_mul(t333, t335);
    let t337 = circuit_sub(in1, in70);
    let t338 = circuit_mul(t0, t337);
    let t339 = circuit_mul(t0, t336);
    let t340 = circuit_add(t339, t339);
    let t341 = circuit_sub(t338, in70);
    let t342 = circuit_mul(in45, t341);
    let t343 = circuit_sub(t340, t342);
    let t344 = circuit_add(t338, in70);
    let t345 = circuit_inverse(t344);
    let t346 = circuit_mul(t343, t345);
    let t347 = circuit_sub(in1, in69);
    let t348 = circuit_mul(in65, t347);
    let t349 = circuit_mul(in65, t346);
    let t350 = circuit_add(t349, t349);
    let t351 = circuit_sub(t348, in69);
    let t352 = circuit_mul(in44, t351);
    let t353 = circuit_sub(t350, t352);
    let t354 = circuit_add(t348, in69);
    let t355 = circuit_inverse(t354);
    let t356 = circuit_mul(t353, t355);
    let t357 = circuit_mul(t356, t17);
    let t358 = circuit_mul(in44, in68);
    let t359 = circuit_mul(t358, t19);
    let t360 = circuit_add(t357, t359);
    let t361 = circuit_mul(in68, in68);
    let t362 = circuit_sub(in67, t0);
    let t363 = circuit_inverse(t362);
    let t364 = circuit_add(in67, t0);
    let t365 = circuit_inverse(t364);
    let t366 = circuit_mul(t361, t363);
    let t367 = circuit_mul(in68, t365);
    let t368 = circuit_mul(t361, t367);
    let t369 = circuit_add(t368, t366);
    let t370 = circuit_sub(in0, t369);
    let t371 = circuit_mul(t368, in45);
    let t372 = circuit_mul(t366, t346);
    let t373 = circuit_add(t371, t372);
    let t374 = circuit_add(t360, t373);
    let t375 = circuit_mul(in68, in68);
    let t376 = circuit_mul(t361, t375);
    let t377 = circuit_sub(in67, t1);
    let t378 = circuit_inverse(t377);
    let t379 = circuit_add(in67, t1);
    let t380 = circuit_inverse(t379);
    let t381 = circuit_mul(t376, t378);
    let t382 = circuit_mul(in68, t380);
    let t383 = circuit_mul(t376, t382);
    let t384 = circuit_add(t383, t381);
    let t385 = circuit_sub(in0, t384);
    let t386 = circuit_mul(t383, in46);
    let t387 = circuit_mul(t381, t336);
    let t388 = circuit_add(t386, t387);
    let t389 = circuit_add(t374, t388);
    let t390 = circuit_mul(in68, in68);
    let t391 = circuit_mul(t376, t390);
    let t392 = circuit_sub(in67, t2);
    let t393 = circuit_inverse(t392);
    let t394 = circuit_add(in67, t2);
    let t395 = circuit_inverse(t394);
    let t396 = circuit_mul(t391, t393);
    let t397 = circuit_mul(in68, t395);
    let t398 = circuit_mul(t391, t397);
    let t399 = circuit_add(t398, t396);
    let t400 = circuit_sub(in0, t399);
    let t401 = circuit_mul(t398, in47);
    let t402 = circuit_mul(t396, t326);
    let t403 = circuit_add(t401, t402);
    let t404 = circuit_add(t389, t403);
    let t405 = circuit_mul(in68, in68);
    let t406 = circuit_mul(t391, t405);
    let t407 = circuit_sub(in67, t3);
    let t408 = circuit_inverse(t407);
    let t409 = circuit_add(in67, t3);
    let t410 = circuit_inverse(t409);
    let t411 = circuit_mul(t406, t408);
    let t412 = circuit_mul(in68, t410);
    let t413 = circuit_mul(t406, t412);
    let t414 = circuit_add(t413, t411);
    let t415 = circuit_sub(in0, t414);
    let t416 = circuit_mul(t413, in48);
    let t417 = circuit_mul(t411, t316);
    let t418 = circuit_add(t416, t417);
    let t419 = circuit_add(t404, t418);
    let t420 = circuit_mul(in68, in68);
    let t421 = circuit_mul(t406, t420);
    let t422 = circuit_sub(in67, t4);
    let t423 = circuit_inverse(t422);
    let t424 = circuit_add(in67, t4);
    let t425 = circuit_inverse(t424);
    let t426 = circuit_mul(t421, t423);
    let t427 = circuit_mul(in68, t425);
    let t428 = circuit_mul(t421, t427);
    let t429 = circuit_add(t428, t426);
    let t430 = circuit_sub(in0, t429);
    let t431 = circuit_mul(t428, in49);
    let t432 = circuit_mul(t426, t306);
    let t433 = circuit_add(t431, t432);
    let t434 = circuit_add(t419, t433);
    let t435 = circuit_mul(in68, in68);
    let t436 = circuit_mul(t421, t435);
    let t437 = circuit_sub(in67, t5);
    let t438 = circuit_inverse(t437);
    let t439 = circuit_add(in67, t5);
    let t440 = circuit_inverse(t439);
    let t441 = circuit_mul(t436, t438);
    let t442 = circuit_mul(in68, t440);
    let t443 = circuit_mul(t436, t442);
    let t444 = circuit_add(t443, t441);
    let t445 = circuit_sub(in0, t444);
    let t446 = circuit_mul(t443, in50);
    let t447 = circuit_mul(t441, t296);
    let t448 = circuit_add(t446, t447);
    let t449 = circuit_add(t434, t448);
    let t450 = circuit_mul(in68, in68);
    let t451 = circuit_mul(t436, t450);
    let t452 = circuit_sub(in67, t6);
    let t453 = circuit_inverse(t452);
    let t454 = circuit_add(in67, t6);
    let t455 = circuit_inverse(t454);
    let t456 = circuit_mul(t451, t453);
    let t457 = circuit_mul(in68, t455);
    let t458 = circuit_mul(t451, t457);
    let t459 = circuit_add(t458, t456);
    let t460 = circuit_sub(in0, t459);
    let t461 = circuit_mul(t458, in51);
    let t462 = circuit_mul(t456, t286);
    let t463 = circuit_add(t461, t462);
    let t464 = circuit_add(t449, t463);
    let t465 = circuit_mul(in68, in68);
    let t466 = circuit_mul(t451, t465);
    let t467 = circuit_sub(in67, t7);
    let t468 = circuit_inverse(t467);
    let t469 = circuit_add(in67, t7);
    let t470 = circuit_inverse(t469);
    let t471 = circuit_mul(t466, t468);
    let t472 = circuit_mul(in68, t470);
    let t473 = circuit_mul(t466, t472);
    let t474 = circuit_add(t473, t471);
    let t475 = circuit_sub(in0, t474);
    let t476 = circuit_mul(t473, in52);
    let t477 = circuit_mul(t471, t276);
    let t478 = circuit_add(t476, t477);
    let t479 = circuit_add(t464, t478);
    let t480 = circuit_mul(in68, in68);
    let t481 = circuit_mul(t466, t480);
    let t482 = circuit_sub(in67, t8);
    let t483 = circuit_inverse(t482);
    let t484 = circuit_add(in67, t8);
    let t485 = circuit_inverse(t484);
    let t486 = circuit_mul(t481, t483);
    let t487 = circuit_mul(in68, t485);
    let t488 = circuit_mul(t481, t487);
    let t489 = circuit_add(t488, t486);
    let t490 = circuit_sub(in0, t489);
    let t491 = circuit_mul(t488, in53);
    let t492 = circuit_mul(t486, t266);
    let t493 = circuit_add(t491, t492);
    let t494 = circuit_add(t479, t493);
    let t495 = circuit_mul(in68, in68);
    let t496 = circuit_mul(t481, t495);
    let t497 = circuit_sub(in67, t9);
    let t498 = circuit_inverse(t497);
    let t499 = circuit_add(in67, t9);
    let t500 = circuit_inverse(t499);
    let t501 = circuit_mul(t496, t498);
    let t502 = circuit_mul(in68, t500);
    let t503 = circuit_mul(t496, t502);
    let t504 = circuit_add(t503, t501);
    let t505 = circuit_sub(in0, t504);
    let t506 = circuit_mul(t503, in54);
    let t507 = circuit_mul(t501, t256);
    let t508 = circuit_add(t506, t507);
    let t509 = circuit_add(t494, t508);
    let t510 = circuit_mul(in68, in68);
    let t511 = circuit_mul(t496, t510);
    let t512 = circuit_sub(in67, t10);
    let t513 = circuit_inverse(t512);
    let t514 = circuit_add(in67, t10);
    let t515 = circuit_inverse(t514);
    let t516 = circuit_mul(t511, t513);
    let t517 = circuit_mul(in68, t515);
    let t518 = circuit_mul(t511, t517);
    let t519 = circuit_add(t518, t516);
    let t520 = circuit_sub(in0, t519);
    let t521 = circuit_mul(t518, in55);
    let t522 = circuit_mul(t516, t246);
    let t523 = circuit_add(t521, t522);
    let t524 = circuit_add(t509, t523);
    let t525 = circuit_mul(in68, in68);
    let t526 = circuit_mul(t511, t525);
    let t527 = circuit_sub(in67, t11);
    let t528 = circuit_inverse(t527);
    let t529 = circuit_add(in67, t11);
    let t530 = circuit_inverse(t529);
    let t531 = circuit_mul(t526, t528);
    let t532 = circuit_mul(in68, t530);
    let t533 = circuit_mul(t526, t532);
    let t534 = circuit_add(t533, t531);
    let t535 = circuit_sub(in0, t534);
    let t536 = circuit_mul(t533, in56);
    let t537 = circuit_mul(t531, t236);
    let t538 = circuit_add(t536, t537);
    let t539 = circuit_add(t524, t538);
    let t540 = circuit_mul(in68, in68);
    let t541 = circuit_mul(t526, t540);
    let t542 = circuit_sub(in67, t12);
    let t543 = circuit_inverse(t542);
    let t544 = circuit_add(in67, t12);
    let t545 = circuit_inverse(t544);
    let t546 = circuit_mul(t541, t543);
    let t547 = circuit_mul(in68, t545);
    let t548 = circuit_mul(t541, t547);
    let t549 = circuit_add(t548, t546);
    let t550 = circuit_sub(in0, t549);
    let t551 = circuit_mul(t548, in57);
    let t552 = circuit_mul(t546, t226);
    let t553 = circuit_add(t551, t552);
    let t554 = circuit_add(t539, t553);
    let t555 = circuit_mul(in68, in68);
    let t556 = circuit_mul(t541, t555);
    let t557 = circuit_sub(in67, t13);
    let t558 = circuit_inverse(t557);
    let t559 = circuit_add(in67, t13);
    let t560 = circuit_inverse(t559);
    let t561 = circuit_mul(t556, t558);
    let t562 = circuit_mul(in68, t560);
    let t563 = circuit_mul(t556, t562);
    let t564 = circuit_add(t563, t561);
    let t565 = circuit_sub(in0, t564);
    let t566 = circuit_mul(t563, in58);
    let t567 = circuit_mul(t561, t216);
    let t568 = circuit_add(t566, t567);
    let t569 = circuit_add(t554, t568);
    let t570 = circuit_mul(in68, in68);
    let t571 = circuit_mul(t556, t570);
    let t572 = circuit_sub(in67, t14);
    let t573 = circuit_inverse(t572);
    let t574 = circuit_add(in67, t14);
    let t575 = circuit_inverse(t574);
    let t576 = circuit_mul(t571, t573);
    let t577 = circuit_mul(in68, t575);
    let t578 = circuit_mul(t571, t577);
    let t579 = circuit_add(t578, t576);
    let t580 = circuit_sub(in0, t579);
    let t581 = circuit_mul(t578, in59);
    let t582 = circuit_mul(t576, t206);
    let t583 = circuit_add(t581, t582);
    let t584 = circuit_add(t569, t583);
    let t585 = circuit_mul(in68, in68);
    let t586 = circuit_mul(t571, t585);
    let t587 = circuit_sub(in67, t15);
    let t588 = circuit_inverse(t587);
    let t589 = circuit_add(in67, t15);
    let t590 = circuit_inverse(t589);
    let t591 = circuit_mul(t586, t588);
    let t592 = circuit_mul(in68, t590);
    let t593 = circuit_mul(t586, t592);
    let t594 = circuit_add(t593, t591);
    let t595 = circuit_sub(in0, t594);
    let t596 = circuit_mul(t593, in60);
    let t597 = circuit_mul(t591, t196);
    let t598 = circuit_add(t596, t597);
    let t599 = circuit_add(t584, t598);
    let t600 = circuit_mul(in68, in68);
    let t601 = circuit_mul(t586, t600);
    let t602 = circuit_mul(in68, in68);
    let t603 = circuit_mul(t601, t602);
    let t604 = circuit_mul(in68, in68);
    let t605 = circuit_mul(t603, t604);
    let t606 = circuit_mul(in68, in68);
    let t607 = circuit_mul(t605, t606);
    let t608 = circuit_mul(in68, in68);
    let t609 = circuit_mul(t607, t608);
    let t610 = circuit_mul(in68, in68);
    let t611 = circuit_mul(t609, t610);
    let t612 = circuit_mul(in68, in68);
    let t613 = circuit_mul(t611, t612);
    let t614 = circuit_mul(in68, in68);
    let t615 = circuit_mul(t613, t614);
    let t616 = circuit_mul(in68, in68);
    let t617 = circuit_mul(t615, t616);
    let t618 = circuit_mul(in68, in68);
    let t619 = circuit_mul(t617, t618);
    let t620 = circuit_mul(in68, in68);
    let t621 = circuit_mul(t619, t620);
    let t622 = circuit_mul(in68, in68);
    let t623 = circuit_mul(t621, t622);
    let t624 = circuit_sub(in67, in65);
    let t625 = circuit_inverse(t624);
    let t626 = circuit_mul(in1, t625);
    let t627 = circuit_mul(in2, in65);
    let t628 = circuit_sub(in67, t627);
    let t629 = circuit_inverse(t628);
    let t630 = circuit_mul(in1, t629);
    let t631 = circuit_mul(in68, in68);
    let t632 = circuit_mul(t623, t631);
    let t633 = circuit_mul(t626, t632);
    let t634 = circuit_sub(in0, t633);
    let t635 = circuit_mul(t632, in68);
    let t636 = circuit_mul(t633, in61);
    let t637 = circuit_add(t599, t636);
    let t638 = circuit_mul(t630, t635);
    let t639 = circuit_sub(in0, t638);
    let t640 = circuit_mul(t635, in68);
    let t641 = circuit_mul(t638, in62);
    let t642 = circuit_add(t637, t641);
    let t643 = circuit_mul(t626, t640);
    let t644 = circuit_sub(in0, t643);
    let t645 = circuit_mul(t640, in68);
    let t646 = circuit_mul(t643, in63);
    let t647 = circuit_add(t642, t646);
    let t648 = circuit_mul(t626, t645);
    let t649 = circuit_sub(in0, t648);
    let t650 = circuit_mul(t648, in64);
    let t651 = circuit_add(t647, t650);
    let t652 = circuit_add(t639, t644);
    let t653 = circuit_add(t136, t168);
    let t654 = circuit_add(t140, t172);
    let t655 = circuit_add(t144, t176);
    let t656 = circuit_add(t148, t180);
    let t657 = circuit_add(t152, t184);

    let modulus = get_GRUMPKIN_modulus(); // GRUMPKIN prime field modulus

    let mut circuit_inputs = (
        t22,
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
        t124,
        t128,
        t132,
        t653,
        t654,
        t655,
        t656,
        t657,
        t156,
        t160,
        t164,
        t370,
        t385,
        t400,
        t415,
        t430,
        t445,
        t460,
        t475,
        t490,
        t505,
        t520,
        t535,
        t550,
        t565,
        t580,
        t595,
        t634,
        t652,
        t649,
        t651,
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
    } // in44 - in60

    for val in p_libra_poly_evals {
        circuit_inputs = circuit_inputs.next_u256(*val);
    } // in61 - in64

    circuit_inputs = circuit_inputs.next_2(tp_gemini_r); // in65
    circuit_inputs = circuit_inputs.next_2(tp_rho); // in66
    circuit_inputs = circuit_inputs.next_2(tp_shplonk_z); // in67
    circuit_inputs = circuit_inputs.next_2(tp_shplonk_nu); // in68

    for val in tp_sum_check_u_challenges {
        circuit_inputs = circuit_inputs.next_u128(*val);
    } // in69 - in85

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let scalar_1: u384 = outputs.get_output(t22);
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
    let scalar_25: u384 = outputs.get_output(t120);
    let scalar_26: u384 = outputs.get_output(t124);
    let scalar_27: u384 = outputs.get_output(t128);
    let scalar_28: u384 = outputs.get_output(t132);
    let scalar_29: u384 = outputs.get_output(t653);
    let scalar_30: u384 = outputs.get_output(t654);
    let scalar_31: u384 = outputs.get_output(t655);
    let scalar_32: u384 = outputs.get_output(t656);
    let scalar_33: u384 = outputs.get_output(t657);
    let scalar_34: u384 = outputs.get_output(t156);
    let scalar_35: u384 = outputs.get_output(t160);
    let scalar_36: u384 = outputs.get_output(t164);
    let scalar_42: u384 = outputs.get_output(t370);
    let scalar_43: u384 = outputs.get_output(t385);
    let scalar_44: u384 = outputs.get_output(t400);
    let scalar_45: u384 = outputs.get_output(t415);
    let scalar_46: u384 = outputs.get_output(t430);
    let scalar_47: u384 = outputs.get_output(t445);
    let scalar_48: u384 = outputs.get_output(t460);
    let scalar_49: u384 = outputs.get_output(t475);
    let scalar_50: u384 = outputs.get_output(t490);
    let scalar_51: u384 = outputs.get_output(t505);
    let scalar_52: u384 = outputs.get_output(t520);
    let scalar_53: u384 = outputs.get_output(t535);
    let scalar_54: u384 = outputs.get_output(t550);
    let scalar_55: u384 = outputs.get_output(t565);
    let scalar_56: u384 = outputs.get_output(t580);
    let scalar_57: u384 = outputs.get_output(t595);
    let scalar_69: u384 = outputs.get_output(t634);
    let scalar_70: u384 = outputs.get_output(t652);
    let scalar_71: u384 = outputs.get_output(t649);
    let scalar_72: u384 = outputs.get_output(t651);
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
        scalar_53,
        scalar_54,
        scalar_55,
        scalar_56,
        scalar_57,
        scalar_69,
        scalar_70,
        scalar_71,
        scalar_72,
    );
}
#[inline(always)]
pub fn run_GRUMPKIN_ZK_HONK_EVALS_CONS_INIT_SIZE_17_circuit(tp_gemini_r: u384) -> (u384, u384) {
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
pub fn run_GRUMPKIN_ZK_HONK_EVALS_CONS_LOOP_SIZE_17_circuit(
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
pub fn run_GRUMPKIN_ZK_HONK_EVALS_CONS_DONE_SIZE_17_circuit(
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
pub fn run_BN254_EVAL_FN_CHALLENGE_SING_57P_RLC_circuit<
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
    let (in183, in184, in185) = (CE::<CI<183>> {}, CE::<CI<184>> {}, CE::<CI<185>> {});
    let (in186, in187, in188) = (CE::<CI<186>> {}, CE::<CI<187>> {}, CE::<CI<188>> {});
    let (in189, in190, in191) = (CE::<CI<189>> {}, CE::<CI<190>> {}, CE::<CI<191>> {});
    let (in192, in193, in194) = (CE::<CI<192>> {}, CE::<CI<193>> {}, CE::<CI<194>> {});
    let (in195, in196, in197) = (CE::<CI<195>> {}, CE::<CI<196>> {}, CE::<CI<197>> {});
    let (in198, in199, in200) = (CE::<CI<198>> {}, CE::<CI<199>> {}, CE::<CI<200>> {});
    let (in201, in202, in203) = (CE::<CI<201>> {}, CE::<CI<202>> {}, CE::<CI<203>> {});
    let (in204, in205, in206) = (CE::<CI<204>> {}, CE::<CI<205>> {}, CE::<CI<206>> {});
    let (in207, in208, in209) = (CE::<CI<207>> {}, CE::<CI<208>> {}, CE::<CI<209>> {});
    let (in210, in211, in212) = (CE::<CI<210>> {}, CE::<CI<211>> {}, CE::<CI<212>> {});
    let (in213, in214, in215) = (CE::<CI<213>> {}, CE::<CI<214>> {}, CE::<CI<215>> {});
    let (in216, in217, in218) = (CE::<CI<216>> {}, CE::<CI<217>> {}, CE::<CI<218>> {});
    let (in219, in220, in221) = (CE::<CI<219>> {}, CE::<CI<220>> {}, CE::<CI<221>> {});
    let (in222, in223, in224) = (CE::<CI<222>> {}, CE::<CI<223>> {}, CE::<CI<224>> {});
    let (in225, in226, in227) = (CE::<CI<225>> {}, CE::<CI<226>> {}, CE::<CI<227>> {});
    let (in228, in229, in230) = (CE::<CI<228>> {}, CE::<CI<229>> {}, CE::<CI<230>> {});
    let (in231, in232, in233) = (CE::<CI<231>> {}, CE::<CI<232>> {}, CE::<CI<233>> {});
    let (in234, in235, in236) = (CE::<CI<234>> {}, CE::<CI<235>> {}, CE::<CI<236>> {});
    let (in237, in238, in239) = (CE::<CI<237>> {}, CE::<CI<238>> {}, CE::<CI<239>> {});
    let (in240, in241, in242) = (CE::<CI<240>> {}, CE::<CI<241>> {}, CE::<CI<242>> {});
    let (in243, in244, in245) = (CE::<CI<243>> {}, CE::<CI<244>> {}, CE::<CI<245>> {});
    let (in246, in247, in248) = (CE::<CI<246>> {}, CE::<CI<247>> {}, CE::<CI<248>> {});
    let t0 = circuit_mul(in62, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t1 = circuit_add(in61, t0); // Eval sumdlogdiv_a_num Horner step: add coefficient_58
    let t2 = circuit_mul(t1, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t3 = circuit_add(in60, t2); // Eval sumdlogdiv_a_num Horner step: add coefficient_57
    let t4 = circuit_mul(t3, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t5 = circuit_add(in59, t4); // Eval sumdlogdiv_a_num Horner step: add coefficient_56
    let t6 = circuit_mul(t5, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t7 = circuit_add(in58, t6); // Eval sumdlogdiv_a_num Horner step: add coefficient_55
    let t8 = circuit_mul(t7, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t9 = circuit_add(in57, t8); // Eval sumdlogdiv_a_num Horner step: add coefficient_54
    let t10 = circuit_mul(t9, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t11 = circuit_add(in56, t10); // Eval sumdlogdiv_a_num Horner step: add coefficient_53
    let t12 = circuit_mul(t11, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t13 = circuit_add(in55, t12); // Eval sumdlogdiv_a_num Horner step: add coefficient_52
    let t14 = circuit_mul(t13, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t15 = circuit_add(in54, t14); // Eval sumdlogdiv_a_num Horner step: add coefficient_51
    let t16 = circuit_mul(t15, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t17 = circuit_add(in53, t16); // Eval sumdlogdiv_a_num Horner step: add coefficient_50
    let t18 = circuit_mul(t17, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t19 = circuit_add(in52, t18); // Eval sumdlogdiv_a_num Horner step: add coefficient_49
    let t20 = circuit_mul(t19, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t21 = circuit_add(in51, t20); // Eval sumdlogdiv_a_num Horner step: add coefficient_48
    let t22 = circuit_mul(t21, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t23 = circuit_add(in50, t22); // Eval sumdlogdiv_a_num Horner step: add coefficient_47
    let t24 = circuit_mul(t23, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t25 = circuit_add(in49, t24); // Eval sumdlogdiv_a_num Horner step: add coefficient_46
    let t26 = circuit_mul(t25, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t27 = circuit_add(in48, t26); // Eval sumdlogdiv_a_num Horner step: add coefficient_45
    let t28 = circuit_mul(t27, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t29 = circuit_add(in47, t28); // Eval sumdlogdiv_a_num Horner step: add coefficient_44
    let t30 = circuit_mul(t29, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t31 = circuit_add(in46, t30); // Eval sumdlogdiv_a_num Horner step: add coefficient_43
    let t32 = circuit_mul(t31, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t33 = circuit_add(in45, t32); // Eval sumdlogdiv_a_num Horner step: add coefficient_42
    let t34 = circuit_mul(t33, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t35 = circuit_add(in44, t34); // Eval sumdlogdiv_a_num Horner step: add coefficient_41
    let t36 = circuit_mul(t35, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t37 = circuit_add(in43, t36); // Eval sumdlogdiv_a_num Horner step: add coefficient_40
    let t38 = circuit_mul(t37, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t39 = circuit_add(in42, t38); // Eval sumdlogdiv_a_num Horner step: add coefficient_39
    let t40 = circuit_mul(t39, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t41 = circuit_add(in41, t40); // Eval sumdlogdiv_a_num Horner step: add coefficient_38
    let t42 = circuit_mul(t41, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t43 = circuit_add(in40, t42); // Eval sumdlogdiv_a_num Horner step: add coefficient_37
    let t44 = circuit_mul(t43, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t45 = circuit_add(in39, t44); // Eval sumdlogdiv_a_num Horner step: add coefficient_36
    let t46 = circuit_mul(t45, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t47 = circuit_add(in38, t46); // Eval sumdlogdiv_a_num Horner step: add coefficient_35
    let t48 = circuit_mul(t47, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t49 = circuit_add(in37, t48); // Eval sumdlogdiv_a_num Horner step: add coefficient_34
    let t50 = circuit_mul(t49, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t51 = circuit_add(in36, t50); // Eval sumdlogdiv_a_num Horner step: add coefficient_33
    let t52 = circuit_mul(t51, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t53 = circuit_add(in35, t52); // Eval sumdlogdiv_a_num Horner step: add coefficient_32
    let t54 = circuit_mul(t53, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t55 = circuit_add(in34, t54); // Eval sumdlogdiv_a_num Horner step: add coefficient_31
    let t56 = circuit_mul(t55, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t57 = circuit_add(in33, t56); // Eval sumdlogdiv_a_num Horner step: add coefficient_30
    let t58 = circuit_mul(t57, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t59 = circuit_add(in32, t58); // Eval sumdlogdiv_a_num Horner step: add coefficient_29
    let t60 = circuit_mul(t59, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t61 = circuit_add(in31, t60); // Eval sumdlogdiv_a_num Horner step: add coefficient_28
    let t62 = circuit_mul(t61, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t63 = circuit_add(in30, t62); // Eval sumdlogdiv_a_num Horner step: add coefficient_27
    let t64 = circuit_mul(t63, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t65 = circuit_add(in29, t64); // Eval sumdlogdiv_a_num Horner step: add coefficient_26
    let t66 = circuit_mul(t65, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t67 = circuit_add(in28, t66); // Eval sumdlogdiv_a_num Horner step: add coefficient_25
    let t68 = circuit_mul(t67, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t69 = circuit_add(in27, t68); // Eval sumdlogdiv_a_num Horner step: add coefficient_24
    let t70 = circuit_mul(t69, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t71 = circuit_add(in26, t70); // Eval sumdlogdiv_a_num Horner step: add coefficient_23
    let t72 = circuit_mul(t71, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t73 = circuit_add(in25, t72); // Eval sumdlogdiv_a_num Horner step: add coefficient_22
    let t74 = circuit_mul(t73, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t75 = circuit_add(in24, t74); // Eval sumdlogdiv_a_num Horner step: add coefficient_21
    let t76 = circuit_mul(t75, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t77 = circuit_add(in23, t76); // Eval sumdlogdiv_a_num Horner step: add coefficient_20
    let t78 = circuit_mul(t77, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t79 = circuit_add(in22, t78); // Eval sumdlogdiv_a_num Horner step: add coefficient_19
    let t80 = circuit_mul(t79, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t81 = circuit_add(in21, t80); // Eval sumdlogdiv_a_num Horner step: add coefficient_18
    let t82 = circuit_mul(t81, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t83 = circuit_add(in20, t82); // Eval sumdlogdiv_a_num Horner step: add coefficient_17
    let t84 = circuit_mul(t83, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t85 = circuit_add(in19, t84); // Eval sumdlogdiv_a_num Horner step: add coefficient_16
    let t86 = circuit_mul(t85, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t87 = circuit_add(in18, t86); // Eval sumdlogdiv_a_num Horner step: add coefficient_15
    let t88 = circuit_mul(t87, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t89 = circuit_add(in17, t88); // Eval sumdlogdiv_a_num Horner step: add coefficient_14
    let t90 = circuit_mul(t89, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t91 = circuit_add(in16, t90); // Eval sumdlogdiv_a_num Horner step: add coefficient_13
    let t92 = circuit_mul(t91, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t93 = circuit_add(in15, t92); // Eval sumdlogdiv_a_num Horner step: add coefficient_12
    let t94 = circuit_mul(t93, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t95 = circuit_add(in14, t94); // Eval sumdlogdiv_a_num Horner step: add coefficient_11
    let t96 = circuit_mul(t95, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t97 = circuit_add(in13, t96); // Eval sumdlogdiv_a_num Horner step: add coefficient_10
    let t98 = circuit_mul(t97, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t99 = circuit_add(in12, t98); // Eval sumdlogdiv_a_num Horner step: add coefficient_9
    let t100 = circuit_mul(t99, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t101 = circuit_add(in11, t100); // Eval sumdlogdiv_a_num Horner step: add coefficient_8
    let t102 = circuit_mul(t101, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t103 = circuit_add(in10, t102); // Eval sumdlogdiv_a_num Horner step: add coefficient_7
    let t104 = circuit_mul(t103, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t105 = circuit_add(in9, t104); // Eval sumdlogdiv_a_num Horner step: add coefficient_6
    let t106 = circuit_mul(t105, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t107 = circuit_add(in8, t106); // Eval sumdlogdiv_a_num Horner step: add coefficient_5
    let t108 = circuit_mul(t107, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t109 = circuit_add(in7, t108); // Eval sumdlogdiv_a_num Horner step: add coefficient_4
    let t110 = circuit_mul(t109, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t111 = circuit_add(in6, t110); // Eval sumdlogdiv_a_num Horner step: add coefficient_3
    let t112 = circuit_mul(t111, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t113 = circuit_add(in5, t112); // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    let t114 = circuit_mul(t113, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t115 = circuit_add(in4, t114); // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    let t116 = circuit_mul(t115, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA
    let t117 = circuit_add(in3, t116); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t118 = circuit_mul(in123, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t119 = circuit_add(in122, t118); // Eval sumdlogdiv_a_den Horner step: add coefficient_59
    let t120 = circuit_mul(t119, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t121 = circuit_add(in121, t120); // Eval sumdlogdiv_a_den Horner step: add coefficient_58
    let t122 = circuit_mul(t121, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t123 = circuit_add(in120, t122); // Eval sumdlogdiv_a_den Horner step: add coefficient_57
    let t124 = circuit_mul(t123, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t125 = circuit_add(in119, t124); // Eval sumdlogdiv_a_den Horner step: add coefficient_56
    let t126 = circuit_mul(t125, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t127 = circuit_add(in118, t126); // Eval sumdlogdiv_a_den Horner step: add coefficient_55
    let t128 = circuit_mul(t127, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t129 = circuit_add(in117, t128); // Eval sumdlogdiv_a_den Horner step: add coefficient_54
    let t130 = circuit_mul(t129, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t131 = circuit_add(in116, t130); // Eval sumdlogdiv_a_den Horner step: add coefficient_53
    let t132 = circuit_mul(t131, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t133 = circuit_add(in115, t132); // Eval sumdlogdiv_a_den Horner step: add coefficient_52
    let t134 = circuit_mul(t133, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t135 = circuit_add(in114, t134); // Eval sumdlogdiv_a_den Horner step: add coefficient_51
    let t136 = circuit_mul(t135, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t137 = circuit_add(in113, t136); // Eval sumdlogdiv_a_den Horner step: add coefficient_50
    let t138 = circuit_mul(t137, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t139 = circuit_add(in112, t138); // Eval sumdlogdiv_a_den Horner step: add coefficient_49
    let t140 = circuit_mul(t139, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t141 = circuit_add(in111, t140); // Eval sumdlogdiv_a_den Horner step: add coefficient_48
    let t142 = circuit_mul(t141, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t143 = circuit_add(in110, t142); // Eval sumdlogdiv_a_den Horner step: add coefficient_47
    let t144 = circuit_mul(t143, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t145 = circuit_add(in109, t144); // Eval sumdlogdiv_a_den Horner step: add coefficient_46
    let t146 = circuit_mul(t145, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t147 = circuit_add(in108, t146); // Eval sumdlogdiv_a_den Horner step: add coefficient_45
    let t148 = circuit_mul(t147, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t149 = circuit_add(in107, t148); // Eval sumdlogdiv_a_den Horner step: add coefficient_44
    let t150 = circuit_mul(t149, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t151 = circuit_add(in106, t150); // Eval sumdlogdiv_a_den Horner step: add coefficient_43
    let t152 = circuit_mul(t151, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t153 = circuit_add(in105, t152); // Eval sumdlogdiv_a_den Horner step: add coefficient_42
    let t154 = circuit_mul(t153, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t155 = circuit_add(in104, t154); // Eval sumdlogdiv_a_den Horner step: add coefficient_41
    let t156 = circuit_mul(t155, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t157 = circuit_add(in103, t156); // Eval sumdlogdiv_a_den Horner step: add coefficient_40
    let t158 = circuit_mul(t157, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t159 = circuit_add(in102, t158); // Eval sumdlogdiv_a_den Horner step: add coefficient_39
    let t160 = circuit_mul(t159, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t161 = circuit_add(in101, t160); // Eval sumdlogdiv_a_den Horner step: add coefficient_38
    let t162 = circuit_mul(t161, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t163 = circuit_add(in100, t162); // Eval sumdlogdiv_a_den Horner step: add coefficient_37
    let t164 = circuit_mul(t163, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t165 = circuit_add(in99, t164); // Eval sumdlogdiv_a_den Horner step: add coefficient_36
    let t166 = circuit_mul(t165, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t167 = circuit_add(in98, t166); // Eval sumdlogdiv_a_den Horner step: add coefficient_35
    let t168 = circuit_mul(t167, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t169 = circuit_add(in97, t168); // Eval sumdlogdiv_a_den Horner step: add coefficient_34
    let t170 = circuit_mul(t169, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t171 = circuit_add(in96, t170); // Eval sumdlogdiv_a_den Horner step: add coefficient_33
    let t172 = circuit_mul(t171, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t173 = circuit_add(in95, t172); // Eval sumdlogdiv_a_den Horner step: add coefficient_32
    let t174 = circuit_mul(t173, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t175 = circuit_add(in94, t174); // Eval sumdlogdiv_a_den Horner step: add coefficient_31
    let t176 = circuit_mul(t175, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t177 = circuit_add(in93, t176); // Eval sumdlogdiv_a_den Horner step: add coefficient_30
    let t178 = circuit_mul(t177, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t179 = circuit_add(in92, t178); // Eval sumdlogdiv_a_den Horner step: add coefficient_29
    let t180 = circuit_mul(t179, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t181 = circuit_add(in91, t180); // Eval sumdlogdiv_a_den Horner step: add coefficient_28
    let t182 = circuit_mul(t181, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t183 = circuit_add(in90, t182); // Eval sumdlogdiv_a_den Horner step: add coefficient_27
    let t184 = circuit_mul(t183, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t185 = circuit_add(in89, t184); // Eval sumdlogdiv_a_den Horner step: add coefficient_26
    let t186 = circuit_mul(t185, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t187 = circuit_add(in88, t186); // Eval sumdlogdiv_a_den Horner step: add coefficient_25
    let t188 = circuit_mul(t187, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t189 = circuit_add(in87, t188); // Eval sumdlogdiv_a_den Horner step: add coefficient_24
    let t190 = circuit_mul(t189, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t191 = circuit_add(in86, t190); // Eval sumdlogdiv_a_den Horner step: add coefficient_23
    let t192 = circuit_mul(t191, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t193 = circuit_add(in85, t192); // Eval sumdlogdiv_a_den Horner step: add coefficient_22
    let t194 = circuit_mul(t193, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t195 = circuit_add(in84, t194); // Eval sumdlogdiv_a_den Horner step: add coefficient_21
    let t196 = circuit_mul(t195, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t197 = circuit_add(in83, t196); // Eval sumdlogdiv_a_den Horner step: add coefficient_20
    let t198 = circuit_mul(t197, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t199 = circuit_add(in82, t198); // Eval sumdlogdiv_a_den Horner step: add coefficient_19
    let t200 = circuit_mul(t199, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t201 = circuit_add(in81, t200); // Eval sumdlogdiv_a_den Horner step: add coefficient_18
    let t202 = circuit_mul(t201, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t203 = circuit_add(in80, t202); // Eval sumdlogdiv_a_den Horner step: add coefficient_17
    let t204 = circuit_mul(t203, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t205 = circuit_add(in79, t204); // Eval sumdlogdiv_a_den Horner step: add coefficient_16
    let t206 = circuit_mul(t205, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t207 = circuit_add(in78, t206); // Eval sumdlogdiv_a_den Horner step: add coefficient_15
    let t208 = circuit_mul(t207, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t209 = circuit_add(in77, t208); // Eval sumdlogdiv_a_den Horner step: add coefficient_14
    let t210 = circuit_mul(t209, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t211 = circuit_add(in76, t210); // Eval sumdlogdiv_a_den Horner step: add coefficient_13
    let t212 = circuit_mul(t211, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t213 = circuit_add(in75, t212); // Eval sumdlogdiv_a_den Horner step: add coefficient_12
    let t214 = circuit_mul(t213, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t215 = circuit_add(in74, t214); // Eval sumdlogdiv_a_den Horner step: add coefficient_11
    let t216 = circuit_mul(t215, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t217 = circuit_add(in73, t216); // Eval sumdlogdiv_a_den Horner step: add coefficient_10
    let t218 = circuit_mul(t217, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t219 = circuit_add(in72, t218); // Eval sumdlogdiv_a_den Horner step: add coefficient_9
    let t220 = circuit_mul(t219, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t221 = circuit_add(in71, t220); // Eval sumdlogdiv_a_den Horner step: add coefficient_8
    let t222 = circuit_mul(t221, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t223 = circuit_add(in70, t222); // Eval sumdlogdiv_a_den Horner step: add coefficient_7
    let t224 = circuit_mul(t223, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t225 = circuit_add(in69, t224); // Eval sumdlogdiv_a_den Horner step: add coefficient_6
    let t226 = circuit_mul(t225, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t227 = circuit_add(in68, t226); // Eval sumdlogdiv_a_den Horner step: add coefficient_5
    let t228 = circuit_mul(t227, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t229 = circuit_add(in67, t228); // Eval sumdlogdiv_a_den Horner step: add coefficient_4
    let t230 = circuit_mul(t229, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t231 = circuit_add(in66, t230); // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    let t232 = circuit_mul(t231, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t233 = circuit_add(in65, t232); // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    let t234 = circuit_mul(t233, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t235 = circuit_add(in64, t234); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t236 = circuit_mul(t235, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA
    let t237 = circuit_add(in63, t236); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t238 = circuit_inverse(t237);
    let t239 = circuit_mul(t117, t238);
    let t240 = circuit_mul(in184, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t241 = circuit_add(in183, t240); // Eval sumdlogdiv_b_num Horner step: add coefficient_59
    let t242 = circuit_mul(t241, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t243 = circuit_add(in182, t242); // Eval sumdlogdiv_b_num Horner step: add coefficient_58
    let t244 = circuit_mul(t243, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t245 = circuit_add(in181, t244); // Eval sumdlogdiv_b_num Horner step: add coefficient_57
    let t246 = circuit_mul(t245, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t247 = circuit_add(in180, t246); // Eval sumdlogdiv_b_num Horner step: add coefficient_56
    let t248 = circuit_mul(t247, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t249 = circuit_add(in179, t248); // Eval sumdlogdiv_b_num Horner step: add coefficient_55
    let t250 = circuit_mul(t249, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t251 = circuit_add(in178, t250); // Eval sumdlogdiv_b_num Horner step: add coefficient_54
    let t252 = circuit_mul(t251, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t253 = circuit_add(in177, t252); // Eval sumdlogdiv_b_num Horner step: add coefficient_53
    let t254 = circuit_mul(t253, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t255 = circuit_add(in176, t254); // Eval sumdlogdiv_b_num Horner step: add coefficient_52
    let t256 = circuit_mul(t255, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t257 = circuit_add(in175, t256); // Eval sumdlogdiv_b_num Horner step: add coefficient_51
    let t258 = circuit_mul(t257, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t259 = circuit_add(in174, t258); // Eval sumdlogdiv_b_num Horner step: add coefficient_50
    let t260 = circuit_mul(t259, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t261 = circuit_add(in173, t260); // Eval sumdlogdiv_b_num Horner step: add coefficient_49
    let t262 = circuit_mul(t261, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t263 = circuit_add(in172, t262); // Eval sumdlogdiv_b_num Horner step: add coefficient_48
    let t264 = circuit_mul(t263, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t265 = circuit_add(in171, t264); // Eval sumdlogdiv_b_num Horner step: add coefficient_47
    let t266 = circuit_mul(t265, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t267 = circuit_add(in170, t266); // Eval sumdlogdiv_b_num Horner step: add coefficient_46
    let t268 = circuit_mul(t267, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t269 = circuit_add(in169, t268); // Eval sumdlogdiv_b_num Horner step: add coefficient_45
    let t270 = circuit_mul(t269, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t271 = circuit_add(in168, t270); // Eval sumdlogdiv_b_num Horner step: add coefficient_44
    let t272 = circuit_mul(t271, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t273 = circuit_add(in167, t272); // Eval sumdlogdiv_b_num Horner step: add coefficient_43
    let t274 = circuit_mul(t273, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t275 = circuit_add(in166, t274); // Eval sumdlogdiv_b_num Horner step: add coefficient_42
    let t276 = circuit_mul(t275, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t277 = circuit_add(in165, t276); // Eval sumdlogdiv_b_num Horner step: add coefficient_41
    let t278 = circuit_mul(t277, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t279 = circuit_add(in164, t278); // Eval sumdlogdiv_b_num Horner step: add coefficient_40
    let t280 = circuit_mul(t279, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t281 = circuit_add(in163, t280); // Eval sumdlogdiv_b_num Horner step: add coefficient_39
    let t282 = circuit_mul(t281, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t283 = circuit_add(in162, t282); // Eval sumdlogdiv_b_num Horner step: add coefficient_38
    let t284 = circuit_mul(t283, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t285 = circuit_add(in161, t284); // Eval sumdlogdiv_b_num Horner step: add coefficient_37
    let t286 = circuit_mul(t285, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t287 = circuit_add(in160, t286); // Eval sumdlogdiv_b_num Horner step: add coefficient_36
    let t288 = circuit_mul(t287, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t289 = circuit_add(in159, t288); // Eval sumdlogdiv_b_num Horner step: add coefficient_35
    let t290 = circuit_mul(t289, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t291 = circuit_add(in158, t290); // Eval sumdlogdiv_b_num Horner step: add coefficient_34
    let t292 = circuit_mul(t291, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t293 = circuit_add(in157, t292); // Eval sumdlogdiv_b_num Horner step: add coefficient_33
    let t294 = circuit_mul(t293, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t295 = circuit_add(in156, t294); // Eval sumdlogdiv_b_num Horner step: add coefficient_32
    let t296 = circuit_mul(t295, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t297 = circuit_add(in155, t296); // Eval sumdlogdiv_b_num Horner step: add coefficient_31
    let t298 = circuit_mul(t297, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t299 = circuit_add(in154, t298); // Eval sumdlogdiv_b_num Horner step: add coefficient_30
    let t300 = circuit_mul(t299, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t301 = circuit_add(in153, t300); // Eval sumdlogdiv_b_num Horner step: add coefficient_29
    let t302 = circuit_mul(t301, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t303 = circuit_add(in152, t302); // Eval sumdlogdiv_b_num Horner step: add coefficient_28
    let t304 = circuit_mul(t303, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t305 = circuit_add(in151, t304); // Eval sumdlogdiv_b_num Horner step: add coefficient_27
    let t306 = circuit_mul(t305, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t307 = circuit_add(in150, t306); // Eval sumdlogdiv_b_num Horner step: add coefficient_26
    let t308 = circuit_mul(t307, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t309 = circuit_add(in149, t308); // Eval sumdlogdiv_b_num Horner step: add coefficient_25
    let t310 = circuit_mul(t309, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t311 = circuit_add(in148, t310); // Eval sumdlogdiv_b_num Horner step: add coefficient_24
    let t312 = circuit_mul(t311, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t313 = circuit_add(in147, t312); // Eval sumdlogdiv_b_num Horner step: add coefficient_23
    let t314 = circuit_mul(t313, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t315 = circuit_add(in146, t314); // Eval sumdlogdiv_b_num Horner step: add coefficient_22
    let t316 = circuit_mul(t315, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t317 = circuit_add(in145, t316); // Eval sumdlogdiv_b_num Horner step: add coefficient_21
    let t318 = circuit_mul(t317, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t319 = circuit_add(in144, t318); // Eval sumdlogdiv_b_num Horner step: add coefficient_20
    let t320 = circuit_mul(t319, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t321 = circuit_add(in143, t320); // Eval sumdlogdiv_b_num Horner step: add coefficient_19
    let t322 = circuit_mul(t321, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t323 = circuit_add(in142, t322); // Eval sumdlogdiv_b_num Horner step: add coefficient_18
    let t324 = circuit_mul(t323, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t325 = circuit_add(in141, t324); // Eval sumdlogdiv_b_num Horner step: add coefficient_17
    let t326 = circuit_mul(t325, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t327 = circuit_add(in140, t326); // Eval sumdlogdiv_b_num Horner step: add coefficient_16
    let t328 = circuit_mul(t327, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t329 = circuit_add(in139, t328); // Eval sumdlogdiv_b_num Horner step: add coefficient_15
    let t330 = circuit_mul(t329, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t331 = circuit_add(in138, t330); // Eval sumdlogdiv_b_num Horner step: add coefficient_14
    let t332 = circuit_mul(t331, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t333 = circuit_add(in137, t332); // Eval sumdlogdiv_b_num Horner step: add coefficient_13
    let t334 = circuit_mul(t333, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t335 = circuit_add(in136, t334); // Eval sumdlogdiv_b_num Horner step: add coefficient_12
    let t336 = circuit_mul(t335, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t337 = circuit_add(in135, t336); // Eval sumdlogdiv_b_num Horner step: add coefficient_11
    let t338 = circuit_mul(t337, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t339 = circuit_add(in134, t338); // Eval sumdlogdiv_b_num Horner step: add coefficient_10
    let t340 = circuit_mul(t339, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t341 = circuit_add(in133, t340); // Eval sumdlogdiv_b_num Horner step: add coefficient_9
    let t342 = circuit_mul(t341, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t343 = circuit_add(in132, t342); // Eval sumdlogdiv_b_num Horner step: add coefficient_8
    let t344 = circuit_mul(t343, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t345 = circuit_add(in131, t344); // Eval sumdlogdiv_b_num Horner step: add coefficient_7
    let t346 = circuit_mul(t345, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t347 = circuit_add(in130, t346); // Eval sumdlogdiv_b_num Horner step: add coefficient_6
    let t348 = circuit_mul(t347, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t349 = circuit_add(in129, t348); // Eval sumdlogdiv_b_num Horner step: add coefficient_5
    let t350 = circuit_mul(t349, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t351 = circuit_add(in128, t350); // Eval sumdlogdiv_b_num Horner step: add coefficient_4
    let t352 = circuit_mul(t351, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t353 = circuit_add(in127, t352); // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    let t354 = circuit_mul(t353, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t355 = circuit_add(in126, t354); // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    let t356 = circuit_mul(t355, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t357 = circuit_add(in125, t356); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t358 = circuit_mul(t357, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA
    let t359 = circuit_add(in124, t358); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t360 = circuit_mul(in248, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t361 = circuit_add(in247, t360); // Eval sumdlogdiv_b_den Horner step: add coefficient_62
    let t362 = circuit_mul(t361, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t363 = circuit_add(in246, t362); // Eval sumdlogdiv_b_den Horner step: add coefficient_61
    let t364 = circuit_mul(t363, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t365 = circuit_add(in245, t364); // Eval sumdlogdiv_b_den Horner step: add coefficient_60
    let t366 = circuit_mul(t365, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t367 = circuit_add(in244, t366); // Eval sumdlogdiv_b_den Horner step: add coefficient_59
    let t368 = circuit_mul(t367, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t369 = circuit_add(in243, t368); // Eval sumdlogdiv_b_den Horner step: add coefficient_58
    let t370 = circuit_mul(t369, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t371 = circuit_add(in242, t370); // Eval sumdlogdiv_b_den Horner step: add coefficient_57
    let t372 = circuit_mul(t371, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t373 = circuit_add(in241, t372); // Eval sumdlogdiv_b_den Horner step: add coefficient_56
    let t374 = circuit_mul(t373, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t375 = circuit_add(in240, t374); // Eval sumdlogdiv_b_den Horner step: add coefficient_55
    let t376 = circuit_mul(t375, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t377 = circuit_add(in239, t376); // Eval sumdlogdiv_b_den Horner step: add coefficient_54
    let t378 = circuit_mul(t377, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t379 = circuit_add(in238, t378); // Eval sumdlogdiv_b_den Horner step: add coefficient_53
    let t380 = circuit_mul(t379, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t381 = circuit_add(in237, t380); // Eval sumdlogdiv_b_den Horner step: add coefficient_52
    let t382 = circuit_mul(t381, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t383 = circuit_add(in236, t382); // Eval sumdlogdiv_b_den Horner step: add coefficient_51
    let t384 = circuit_mul(t383, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t385 = circuit_add(in235, t384); // Eval sumdlogdiv_b_den Horner step: add coefficient_50
    let t386 = circuit_mul(t385, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t387 = circuit_add(in234, t386); // Eval sumdlogdiv_b_den Horner step: add coefficient_49
    let t388 = circuit_mul(t387, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t389 = circuit_add(in233, t388); // Eval sumdlogdiv_b_den Horner step: add coefficient_48
    let t390 = circuit_mul(t389, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t391 = circuit_add(in232, t390); // Eval sumdlogdiv_b_den Horner step: add coefficient_47
    let t392 = circuit_mul(t391, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t393 = circuit_add(in231, t392); // Eval sumdlogdiv_b_den Horner step: add coefficient_46
    let t394 = circuit_mul(t393, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t395 = circuit_add(in230, t394); // Eval sumdlogdiv_b_den Horner step: add coefficient_45
    let t396 = circuit_mul(t395, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t397 = circuit_add(in229, t396); // Eval sumdlogdiv_b_den Horner step: add coefficient_44
    let t398 = circuit_mul(t397, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t399 = circuit_add(in228, t398); // Eval sumdlogdiv_b_den Horner step: add coefficient_43
    let t400 = circuit_mul(t399, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t401 = circuit_add(in227, t400); // Eval sumdlogdiv_b_den Horner step: add coefficient_42
    let t402 = circuit_mul(t401, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t403 = circuit_add(in226, t402); // Eval sumdlogdiv_b_den Horner step: add coefficient_41
    let t404 = circuit_mul(t403, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t405 = circuit_add(in225, t404); // Eval sumdlogdiv_b_den Horner step: add coefficient_40
    let t406 = circuit_mul(t405, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t407 = circuit_add(in224, t406); // Eval sumdlogdiv_b_den Horner step: add coefficient_39
    let t408 = circuit_mul(t407, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t409 = circuit_add(in223, t408); // Eval sumdlogdiv_b_den Horner step: add coefficient_38
    let t410 = circuit_mul(t409, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t411 = circuit_add(in222, t410); // Eval sumdlogdiv_b_den Horner step: add coefficient_37
    let t412 = circuit_mul(t411, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t413 = circuit_add(in221, t412); // Eval sumdlogdiv_b_den Horner step: add coefficient_36
    let t414 = circuit_mul(t413, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t415 = circuit_add(in220, t414); // Eval sumdlogdiv_b_den Horner step: add coefficient_35
    let t416 = circuit_mul(t415, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t417 = circuit_add(in219, t416); // Eval sumdlogdiv_b_den Horner step: add coefficient_34
    let t418 = circuit_mul(t417, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t419 = circuit_add(in218, t418); // Eval sumdlogdiv_b_den Horner step: add coefficient_33
    let t420 = circuit_mul(t419, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t421 = circuit_add(in217, t420); // Eval sumdlogdiv_b_den Horner step: add coefficient_32
    let t422 = circuit_mul(t421, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t423 = circuit_add(in216, t422); // Eval sumdlogdiv_b_den Horner step: add coefficient_31
    let t424 = circuit_mul(t423, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t425 = circuit_add(in215, t424); // Eval sumdlogdiv_b_den Horner step: add coefficient_30
    let t426 = circuit_mul(t425, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t427 = circuit_add(in214, t426); // Eval sumdlogdiv_b_den Horner step: add coefficient_29
    let t428 = circuit_mul(t427, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t429 = circuit_add(in213, t428); // Eval sumdlogdiv_b_den Horner step: add coefficient_28
    let t430 = circuit_mul(t429, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t431 = circuit_add(in212, t430); // Eval sumdlogdiv_b_den Horner step: add coefficient_27
    let t432 = circuit_mul(t431, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t433 = circuit_add(in211, t432); // Eval sumdlogdiv_b_den Horner step: add coefficient_26
    let t434 = circuit_mul(t433, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t435 = circuit_add(in210, t434); // Eval sumdlogdiv_b_den Horner step: add coefficient_25
    let t436 = circuit_mul(t435, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t437 = circuit_add(in209, t436); // Eval sumdlogdiv_b_den Horner step: add coefficient_24
    let t438 = circuit_mul(t437, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t439 = circuit_add(in208, t438); // Eval sumdlogdiv_b_den Horner step: add coefficient_23
    let t440 = circuit_mul(t439, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t441 = circuit_add(in207, t440); // Eval sumdlogdiv_b_den Horner step: add coefficient_22
    let t442 = circuit_mul(t441, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t443 = circuit_add(in206, t442); // Eval sumdlogdiv_b_den Horner step: add coefficient_21
    let t444 = circuit_mul(t443, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t445 = circuit_add(in205, t444); // Eval sumdlogdiv_b_den Horner step: add coefficient_20
    let t446 = circuit_mul(t445, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t447 = circuit_add(in204, t446); // Eval sumdlogdiv_b_den Horner step: add coefficient_19
    let t448 = circuit_mul(t447, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t449 = circuit_add(in203, t448); // Eval sumdlogdiv_b_den Horner step: add coefficient_18
    let t450 = circuit_mul(t449, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t451 = circuit_add(in202, t450); // Eval sumdlogdiv_b_den Horner step: add coefficient_17
    let t452 = circuit_mul(t451, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t453 = circuit_add(in201, t452); // Eval sumdlogdiv_b_den Horner step: add coefficient_16
    let t454 = circuit_mul(t453, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t455 = circuit_add(in200, t454); // Eval sumdlogdiv_b_den Horner step: add coefficient_15
    let t456 = circuit_mul(t455, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t457 = circuit_add(in199, t456); // Eval sumdlogdiv_b_den Horner step: add coefficient_14
    let t458 = circuit_mul(t457, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t459 = circuit_add(in198, t458); // Eval sumdlogdiv_b_den Horner step: add coefficient_13
    let t460 = circuit_mul(t459, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t461 = circuit_add(in197, t460); // Eval sumdlogdiv_b_den Horner step: add coefficient_12
    let t462 = circuit_mul(t461, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t463 = circuit_add(in196, t462); // Eval sumdlogdiv_b_den Horner step: add coefficient_11
    let t464 = circuit_mul(t463, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t465 = circuit_add(in195, t464); // Eval sumdlogdiv_b_den Horner step: add coefficient_10
    let t466 = circuit_mul(t465, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t467 = circuit_add(in194, t466); // Eval sumdlogdiv_b_den Horner step: add coefficient_9
    let t468 = circuit_mul(t467, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t469 = circuit_add(in193, t468); // Eval sumdlogdiv_b_den Horner step: add coefficient_8
    let t470 = circuit_mul(t469, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t471 = circuit_add(in192, t470); // Eval sumdlogdiv_b_den Horner step: add coefficient_7
    let t472 = circuit_mul(t471, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t473 = circuit_add(in191, t472); // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    let t474 = circuit_mul(t473, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t475 = circuit_add(in190, t474); // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    let t476 = circuit_mul(t475, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t477 = circuit_add(in189, t476); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t478 = circuit_mul(t477, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t479 = circuit_add(in188, t478); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t480 = circuit_mul(t479, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t481 = circuit_add(in187, t480); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t482 = circuit_mul(t481, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t483 = circuit_add(in186, t482); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t484 = circuit_mul(t483, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA
    let t485 = circuit_add(in185, t484); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t486 = circuit_inverse(t485);
    let t487 = circuit_mul(t359, t486);
    let t488 = circuit_mul(in1, t487);
    let t489 = circuit_add(t239, t488);
    let t490 = circuit_mul(in2, t489);

    let modulus = get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (t490,).new_inputs();
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
    // in3 - in248

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: u384 = outputs.get_output(t490);
    return (res,);
}

impl CircuitDefinition56<
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
    E53,
    E54,
    E55,
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
        CE<E53>,
        CE<E54>,
        CE<E55>,
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
                E53,
                E54,
                E55,
            ),
        >;
}
impl MyDrp_56<
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
    E53,
    E54,
    E55,
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
        CE<E53>,
        CE<E54>,
        CE<E55>,
    ),
>;

