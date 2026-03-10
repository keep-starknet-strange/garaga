use core::circuit::{
    CircuitElement as CE, CircuitInput as CI, CircuitInputs, CircuitOutputsTrait, EvalCircuitTrait,
    circuit_add, circuit_inverse, circuit_mul, circuit_sub, u384,
};
use garaga::core::circuit::{AddInputResultTrait2, u288IntoCircuitInputValue};
use garaga::definitions::RSA2048Chunks;

impl CircuitDefinition17<
    E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13, E14, E15, E16,
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
    ),
> {
    type CircuitType =
        core::circuit::Circuit<
            (E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13, E14, E15, E16),
        >;
}
impl MyDrp_17<
    E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13, E14, E15, E16,
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
    ),
>;
#[inline(always)]
pub fn run_RSA_FULL_VERIFICATION_circuit(
    mod_chunks: RSA2048Chunks,
    sig_chunks: RSA2048Chunks,
    quot_chunks_0: RSA2048Chunks,
    rem_chunks_0: RSA2048Chunks,
    quot_chunks_1: RSA2048Chunks,
    rem_chunks_1: RSA2048Chunks,
    quot_chunks_2: RSA2048Chunks,
    rem_chunks_2: RSA2048Chunks,
    quot_chunks_3: RSA2048Chunks,
    rem_chunks_3: RSA2048Chunks,
    quot_chunks_4: RSA2048Chunks,
    rem_chunks_4: RSA2048Chunks,
    quot_chunks_5: RSA2048Chunks,
    rem_chunks_5: RSA2048Chunks,
    quot_chunks_6: RSA2048Chunks,
    rem_chunks_6: RSA2048Chunks,
    quot_chunks_7: RSA2048Chunks,
    rem_chunks_7: RSA2048Chunks,
    quot_chunks_8: RSA2048Chunks,
    rem_chunks_8: RSA2048Chunks,
    quot_chunks_9: RSA2048Chunks,
    rem_chunks_9: RSA2048Chunks,
    quot_chunks_10: RSA2048Chunks,
    rem_chunks_10: RSA2048Chunks,
    quot_chunks_11: RSA2048Chunks,
    rem_chunks_11: RSA2048Chunks,
    quot_chunks_12: RSA2048Chunks,
    rem_chunks_12: RSA2048Chunks,
    quot_chunks_13: RSA2048Chunks,
    rem_chunks_13: RSA2048Chunks,
    quot_chunks_14: RSA2048Chunks,
    rem_chunks_14: RSA2048Chunks,
    quot_chunks_15: RSA2048Chunks,
    rem_chunks_15: RSA2048Chunks,
    quot_chunks_16: RSA2048Chunks,
    rem_chunks_16: RSA2048Chunks,
    step: u384,
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
) {
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
    let in216 = CE::<CI<216>> {};
    let t0 = circuit_mul(in5, in216); // Eval mod_chunks Horner step: multiply by STEP
    let t1 = circuit_add(in4, t0); // Eval mod_chunks Horner step: add coefficient_4
    let t2 = circuit_mul(t1, in216); // Eval mod_chunks Horner step: multiply by STEP
    let t3 = circuit_add(in3, t2); // Eval mod_chunks Horner step: add coefficient_3
    let t4 = circuit_mul(t3, in216); // Eval mod_chunks Horner step: multiply by STEP
    let t5 = circuit_add(in2, t4); // Eval mod_chunks Horner step: add coefficient_2
    let t6 = circuit_mul(t5, in216); // Eval mod_chunks Horner step: multiply by STEP
    let t7 = circuit_add(in1, t6); // Eval mod_chunks Horner step: add coefficient_1
    let t8 = circuit_mul(t7, in216); // Eval mod_chunks Horner step: multiply by STEP
    let t9 = circuit_add(in0, t8); // Eval mod_chunks Horner step: add coefficient_0
    let t10 = circuit_mul(in11, in216); // Eval sig_chunks Horner step: multiply by STEP
    let t11 = circuit_add(in10, t10); // Eval sig_chunks Horner step: add coefficient_4
    let t12 = circuit_mul(t11, in216); // Eval sig_chunks Horner step: multiply by STEP
    let t13 = circuit_add(in9, t12); // Eval sig_chunks Horner step: add coefficient_3
    let t14 = circuit_mul(t13, in216); // Eval sig_chunks Horner step: multiply by STEP
    let t15 = circuit_add(in8, t14); // Eval sig_chunks Horner step: add coefficient_2
    let t16 = circuit_mul(t15, in216); // Eval sig_chunks Horner step: multiply by STEP
    let t17 = circuit_add(in7, t16); // Eval sig_chunks Horner step: add coefficient_1
    let t18 = circuit_mul(t17, in216); // Eval sig_chunks Horner step: multiply by STEP
    let t19 = circuit_add(in6, t18); // Eval sig_chunks Horner step: add coefficient_0
    let t20 = circuit_mul(in17, in216); // Eval quot_0 Horner step: multiply by STEP
    let t21 = circuit_add(in16, t20); // Eval quot_0 Horner step: add coefficient_4
    let t22 = circuit_mul(t21, in216); // Eval quot_0 Horner step: multiply by STEP
    let t23 = circuit_add(in15, t22); // Eval quot_0 Horner step: add coefficient_3
    let t24 = circuit_mul(t23, in216); // Eval quot_0 Horner step: multiply by STEP
    let t25 = circuit_add(in14, t24); // Eval quot_0 Horner step: add coefficient_2
    let t26 = circuit_mul(t25, in216); // Eval quot_0 Horner step: multiply by STEP
    let t27 = circuit_add(in13, t26); // Eval quot_0 Horner step: add coefficient_1
    let t28 = circuit_mul(t27, in216); // Eval quot_0 Horner step: multiply by STEP
    let t29 = circuit_add(in12, t28); // Eval quot_0 Horner step: add coefficient_0
    let t30 = circuit_mul(in23, in216); // Eval rem_0 Horner step: multiply by STEP
    let t31 = circuit_add(in22, t30); // Eval rem_0 Horner step: add coefficient_4
    let t32 = circuit_mul(t31, in216); // Eval rem_0 Horner step: multiply by STEP
    let t33 = circuit_add(in21, t32); // Eval rem_0 Horner step: add coefficient_3
    let t34 = circuit_mul(t33, in216); // Eval rem_0 Horner step: multiply by STEP
    let t35 = circuit_add(in20, t34); // Eval rem_0 Horner step: add coefficient_2
    let t36 = circuit_mul(t35, in216); // Eval rem_0 Horner step: multiply by STEP
    let t37 = circuit_add(in19, t36); // Eval rem_0 Horner step: add coefficient_1
    let t38 = circuit_mul(t37, in216); // Eval rem_0 Horner step: multiply by STEP
    let t39 = circuit_add(in18, t38); // Eval rem_0 Horner step: add coefficient_0
    let t40 = circuit_mul(t19, t19); // square_0
    let t41 = circuit_mul(t29, t9); // quot*mod_0
    let t42 = circuit_sub(t40, t41); // ab-qn_0
    let t43 = circuit_sub(t42, t39); // ab-qn-rem_0
    let t44 = circuit_mul(in29, in216); // Eval quot_1 Horner step: multiply by STEP
    let t45 = circuit_add(in28, t44); // Eval quot_1 Horner step: add coefficient_4
    let t46 = circuit_mul(t45, in216); // Eval quot_1 Horner step: multiply by STEP
    let t47 = circuit_add(in27, t46); // Eval quot_1 Horner step: add coefficient_3
    let t48 = circuit_mul(t47, in216); // Eval quot_1 Horner step: multiply by STEP
    let t49 = circuit_add(in26, t48); // Eval quot_1 Horner step: add coefficient_2
    let t50 = circuit_mul(t49, in216); // Eval quot_1 Horner step: multiply by STEP
    let t51 = circuit_add(in25, t50); // Eval quot_1 Horner step: add coefficient_1
    let t52 = circuit_mul(t51, in216); // Eval quot_1 Horner step: multiply by STEP
    let t53 = circuit_add(in24, t52); // Eval quot_1 Horner step: add coefficient_0
    let t54 = circuit_mul(in35, in216); // Eval rem_1 Horner step: multiply by STEP
    let t55 = circuit_add(in34, t54); // Eval rem_1 Horner step: add coefficient_4
    let t56 = circuit_mul(t55, in216); // Eval rem_1 Horner step: multiply by STEP
    let t57 = circuit_add(in33, t56); // Eval rem_1 Horner step: add coefficient_3
    let t58 = circuit_mul(t57, in216); // Eval rem_1 Horner step: multiply by STEP
    let t59 = circuit_add(in32, t58); // Eval rem_1 Horner step: add coefficient_2
    let t60 = circuit_mul(t59, in216); // Eval rem_1 Horner step: multiply by STEP
    let t61 = circuit_add(in31, t60); // Eval rem_1 Horner step: add coefficient_1
    let t62 = circuit_mul(t61, in216); // Eval rem_1 Horner step: multiply by STEP
    let t63 = circuit_add(in30, t62); // Eval rem_1 Horner step: add coefficient_0
    let t64 = circuit_mul(t39, t39); // square_1
    let t65 = circuit_mul(t53, t9); // quot*mod_1
    let t66 = circuit_sub(t64, t65); // ab-qn_1
    let t67 = circuit_sub(t66, t63); // ab-qn-rem_1
    let t68 = circuit_mul(in41, in216); // Eval quot_2 Horner step: multiply by STEP
    let t69 = circuit_add(in40, t68); // Eval quot_2 Horner step: add coefficient_4
    let t70 = circuit_mul(t69, in216); // Eval quot_2 Horner step: multiply by STEP
    let t71 = circuit_add(in39, t70); // Eval quot_2 Horner step: add coefficient_3
    let t72 = circuit_mul(t71, in216); // Eval quot_2 Horner step: multiply by STEP
    let t73 = circuit_add(in38, t72); // Eval quot_2 Horner step: add coefficient_2
    let t74 = circuit_mul(t73, in216); // Eval quot_2 Horner step: multiply by STEP
    let t75 = circuit_add(in37, t74); // Eval quot_2 Horner step: add coefficient_1
    let t76 = circuit_mul(t75, in216); // Eval quot_2 Horner step: multiply by STEP
    let t77 = circuit_add(in36, t76); // Eval quot_2 Horner step: add coefficient_0
    let t78 = circuit_mul(in47, in216); // Eval rem_2 Horner step: multiply by STEP
    let t79 = circuit_add(in46, t78); // Eval rem_2 Horner step: add coefficient_4
    let t80 = circuit_mul(t79, in216); // Eval rem_2 Horner step: multiply by STEP
    let t81 = circuit_add(in45, t80); // Eval rem_2 Horner step: add coefficient_3
    let t82 = circuit_mul(t81, in216); // Eval rem_2 Horner step: multiply by STEP
    let t83 = circuit_add(in44, t82); // Eval rem_2 Horner step: add coefficient_2
    let t84 = circuit_mul(t83, in216); // Eval rem_2 Horner step: multiply by STEP
    let t85 = circuit_add(in43, t84); // Eval rem_2 Horner step: add coefficient_1
    let t86 = circuit_mul(t85, in216); // Eval rem_2 Horner step: multiply by STEP
    let t87 = circuit_add(in42, t86); // Eval rem_2 Horner step: add coefficient_0
    let t88 = circuit_mul(t63, t63); // square_2
    let t89 = circuit_mul(t77, t9); // quot*mod_2
    let t90 = circuit_sub(t88, t89); // ab-qn_2
    let t91 = circuit_sub(t90, t87); // ab-qn-rem_2
    let t92 = circuit_mul(in53, in216); // Eval quot_3 Horner step: multiply by STEP
    let t93 = circuit_add(in52, t92); // Eval quot_3 Horner step: add coefficient_4
    let t94 = circuit_mul(t93, in216); // Eval quot_3 Horner step: multiply by STEP
    let t95 = circuit_add(in51, t94); // Eval quot_3 Horner step: add coefficient_3
    let t96 = circuit_mul(t95, in216); // Eval quot_3 Horner step: multiply by STEP
    let t97 = circuit_add(in50, t96); // Eval quot_3 Horner step: add coefficient_2
    let t98 = circuit_mul(t97, in216); // Eval quot_3 Horner step: multiply by STEP
    let t99 = circuit_add(in49, t98); // Eval quot_3 Horner step: add coefficient_1
    let t100 = circuit_mul(t99, in216); // Eval quot_3 Horner step: multiply by STEP
    let t101 = circuit_add(in48, t100); // Eval quot_3 Horner step: add coefficient_0
    let t102 = circuit_mul(in59, in216); // Eval rem_3 Horner step: multiply by STEP
    let t103 = circuit_add(in58, t102); // Eval rem_3 Horner step: add coefficient_4
    let t104 = circuit_mul(t103, in216); // Eval rem_3 Horner step: multiply by STEP
    let t105 = circuit_add(in57, t104); // Eval rem_3 Horner step: add coefficient_3
    let t106 = circuit_mul(t105, in216); // Eval rem_3 Horner step: multiply by STEP
    let t107 = circuit_add(in56, t106); // Eval rem_3 Horner step: add coefficient_2
    let t108 = circuit_mul(t107, in216); // Eval rem_3 Horner step: multiply by STEP
    let t109 = circuit_add(in55, t108); // Eval rem_3 Horner step: add coefficient_1
    let t110 = circuit_mul(t109, in216); // Eval rem_3 Horner step: multiply by STEP
    let t111 = circuit_add(in54, t110); // Eval rem_3 Horner step: add coefficient_0
    let t112 = circuit_mul(t87, t87); // square_3
    let t113 = circuit_mul(t101, t9); // quot*mod_3
    let t114 = circuit_sub(t112, t113); // ab-qn_3
    let t115 = circuit_sub(t114, t111); // ab-qn-rem_3
    let t116 = circuit_mul(in65, in216); // Eval quot_4 Horner step: multiply by STEP
    let t117 = circuit_add(in64, t116); // Eval quot_4 Horner step: add coefficient_4
    let t118 = circuit_mul(t117, in216); // Eval quot_4 Horner step: multiply by STEP
    let t119 = circuit_add(in63, t118); // Eval quot_4 Horner step: add coefficient_3
    let t120 = circuit_mul(t119, in216); // Eval quot_4 Horner step: multiply by STEP
    let t121 = circuit_add(in62, t120); // Eval quot_4 Horner step: add coefficient_2
    let t122 = circuit_mul(t121, in216); // Eval quot_4 Horner step: multiply by STEP
    let t123 = circuit_add(in61, t122); // Eval quot_4 Horner step: add coefficient_1
    let t124 = circuit_mul(t123, in216); // Eval quot_4 Horner step: multiply by STEP
    let t125 = circuit_add(in60, t124); // Eval quot_4 Horner step: add coefficient_0
    let t126 = circuit_mul(in71, in216); // Eval rem_4 Horner step: multiply by STEP
    let t127 = circuit_add(in70, t126); // Eval rem_4 Horner step: add coefficient_4
    let t128 = circuit_mul(t127, in216); // Eval rem_4 Horner step: multiply by STEP
    let t129 = circuit_add(in69, t128); // Eval rem_4 Horner step: add coefficient_3
    let t130 = circuit_mul(t129, in216); // Eval rem_4 Horner step: multiply by STEP
    let t131 = circuit_add(in68, t130); // Eval rem_4 Horner step: add coefficient_2
    let t132 = circuit_mul(t131, in216); // Eval rem_4 Horner step: multiply by STEP
    let t133 = circuit_add(in67, t132); // Eval rem_4 Horner step: add coefficient_1
    let t134 = circuit_mul(t133, in216); // Eval rem_4 Horner step: multiply by STEP
    let t135 = circuit_add(in66, t134); // Eval rem_4 Horner step: add coefficient_0
    let t136 = circuit_mul(t111, t111); // square_4
    let t137 = circuit_mul(t125, t9); // quot*mod_4
    let t138 = circuit_sub(t136, t137); // ab-qn_4
    let t139 = circuit_sub(t138, t135); // ab-qn-rem_4
    let t140 = circuit_mul(in77, in216); // Eval quot_5 Horner step: multiply by STEP
    let t141 = circuit_add(in76, t140); // Eval quot_5 Horner step: add coefficient_4
    let t142 = circuit_mul(t141, in216); // Eval quot_5 Horner step: multiply by STEP
    let t143 = circuit_add(in75, t142); // Eval quot_5 Horner step: add coefficient_3
    let t144 = circuit_mul(t143, in216); // Eval quot_5 Horner step: multiply by STEP
    let t145 = circuit_add(in74, t144); // Eval quot_5 Horner step: add coefficient_2
    let t146 = circuit_mul(t145, in216); // Eval quot_5 Horner step: multiply by STEP
    let t147 = circuit_add(in73, t146); // Eval quot_5 Horner step: add coefficient_1
    let t148 = circuit_mul(t147, in216); // Eval quot_5 Horner step: multiply by STEP
    let t149 = circuit_add(in72, t148); // Eval quot_5 Horner step: add coefficient_0
    let t150 = circuit_mul(in83, in216); // Eval rem_5 Horner step: multiply by STEP
    let t151 = circuit_add(in82, t150); // Eval rem_5 Horner step: add coefficient_4
    let t152 = circuit_mul(t151, in216); // Eval rem_5 Horner step: multiply by STEP
    let t153 = circuit_add(in81, t152); // Eval rem_5 Horner step: add coefficient_3
    let t154 = circuit_mul(t153, in216); // Eval rem_5 Horner step: multiply by STEP
    let t155 = circuit_add(in80, t154); // Eval rem_5 Horner step: add coefficient_2
    let t156 = circuit_mul(t155, in216); // Eval rem_5 Horner step: multiply by STEP
    let t157 = circuit_add(in79, t156); // Eval rem_5 Horner step: add coefficient_1
    let t158 = circuit_mul(t157, in216); // Eval rem_5 Horner step: multiply by STEP
    let t159 = circuit_add(in78, t158); // Eval rem_5 Horner step: add coefficient_0
    let t160 = circuit_mul(t135, t135); // square_5
    let t161 = circuit_mul(t149, t9); // quot*mod_5
    let t162 = circuit_sub(t160, t161); // ab-qn_5
    let t163 = circuit_sub(t162, t159); // ab-qn-rem_5
    let t164 = circuit_mul(in89, in216); // Eval quot_6 Horner step: multiply by STEP
    let t165 = circuit_add(in88, t164); // Eval quot_6 Horner step: add coefficient_4
    let t166 = circuit_mul(t165, in216); // Eval quot_6 Horner step: multiply by STEP
    let t167 = circuit_add(in87, t166); // Eval quot_6 Horner step: add coefficient_3
    let t168 = circuit_mul(t167, in216); // Eval quot_6 Horner step: multiply by STEP
    let t169 = circuit_add(in86, t168); // Eval quot_6 Horner step: add coefficient_2
    let t170 = circuit_mul(t169, in216); // Eval quot_6 Horner step: multiply by STEP
    let t171 = circuit_add(in85, t170); // Eval quot_6 Horner step: add coefficient_1
    let t172 = circuit_mul(t171, in216); // Eval quot_6 Horner step: multiply by STEP
    let t173 = circuit_add(in84, t172); // Eval quot_6 Horner step: add coefficient_0
    let t174 = circuit_mul(in95, in216); // Eval rem_6 Horner step: multiply by STEP
    let t175 = circuit_add(in94, t174); // Eval rem_6 Horner step: add coefficient_4
    let t176 = circuit_mul(t175, in216); // Eval rem_6 Horner step: multiply by STEP
    let t177 = circuit_add(in93, t176); // Eval rem_6 Horner step: add coefficient_3
    let t178 = circuit_mul(t177, in216); // Eval rem_6 Horner step: multiply by STEP
    let t179 = circuit_add(in92, t178); // Eval rem_6 Horner step: add coefficient_2
    let t180 = circuit_mul(t179, in216); // Eval rem_6 Horner step: multiply by STEP
    let t181 = circuit_add(in91, t180); // Eval rem_6 Horner step: add coefficient_1
    let t182 = circuit_mul(t181, in216); // Eval rem_6 Horner step: multiply by STEP
    let t183 = circuit_add(in90, t182); // Eval rem_6 Horner step: add coefficient_0
    let t184 = circuit_mul(t159, t159); // square_6
    let t185 = circuit_mul(t173, t9); // quot*mod_6
    let t186 = circuit_sub(t184, t185); // ab-qn_6
    let t187 = circuit_sub(t186, t183); // ab-qn-rem_6
    let t188 = circuit_mul(in101, in216); // Eval quot_7 Horner step: multiply by STEP
    let t189 = circuit_add(in100, t188); // Eval quot_7 Horner step: add coefficient_4
    let t190 = circuit_mul(t189, in216); // Eval quot_7 Horner step: multiply by STEP
    let t191 = circuit_add(in99, t190); // Eval quot_7 Horner step: add coefficient_3
    let t192 = circuit_mul(t191, in216); // Eval quot_7 Horner step: multiply by STEP
    let t193 = circuit_add(in98, t192); // Eval quot_7 Horner step: add coefficient_2
    let t194 = circuit_mul(t193, in216); // Eval quot_7 Horner step: multiply by STEP
    let t195 = circuit_add(in97, t194); // Eval quot_7 Horner step: add coefficient_1
    let t196 = circuit_mul(t195, in216); // Eval quot_7 Horner step: multiply by STEP
    let t197 = circuit_add(in96, t196); // Eval quot_7 Horner step: add coefficient_0
    let t198 = circuit_mul(in107, in216); // Eval rem_7 Horner step: multiply by STEP
    let t199 = circuit_add(in106, t198); // Eval rem_7 Horner step: add coefficient_4
    let t200 = circuit_mul(t199, in216); // Eval rem_7 Horner step: multiply by STEP
    let t201 = circuit_add(in105, t200); // Eval rem_7 Horner step: add coefficient_3
    let t202 = circuit_mul(t201, in216); // Eval rem_7 Horner step: multiply by STEP
    let t203 = circuit_add(in104, t202); // Eval rem_7 Horner step: add coefficient_2
    let t204 = circuit_mul(t203, in216); // Eval rem_7 Horner step: multiply by STEP
    let t205 = circuit_add(in103, t204); // Eval rem_7 Horner step: add coefficient_1
    let t206 = circuit_mul(t205, in216); // Eval rem_7 Horner step: multiply by STEP
    let t207 = circuit_add(in102, t206); // Eval rem_7 Horner step: add coefficient_0
    let t208 = circuit_mul(t183, t183); // square_7
    let t209 = circuit_mul(t197, t9); // quot*mod_7
    let t210 = circuit_sub(t208, t209); // ab-qn_7
    let t211 = circuit_sub(t210, t207); // ab-qn-rem_7
    let t212 = circuit_mul(in113, in216); // Eval quot_8 Horner step: multiply by STEP
    let t213 = circuit_add(in112, t212); // Eval quot_8 Horner step: add coefficient_4
    let t214 = circuit_mul(t213, in216); // Eval quot_8 Horner step: multiply by STEP
    let t215 = circuit_add(in111, t214); // Eval quot_8 Horner step: add coefficient_3
    let t216 = circuit_mul(t215, in216); // Eval quot_8 Horner step: multiply by STEP
    let t217 = circuit_add(in110, t216); // Eval quot_8 Horner step: add coefficient_2
    let t218 = circuit_mul(t217, in216); // Eval quot_8 Horner step: multiply by STEP
    let t219 = circuit_add(in109, t218); // Eval quot_8 Horner step: add coefficient_1
    let t220 = circuit_mul(t219, in216); // Eval quot_8 Horner step: multiply by STEP
    let t221 = circuit_add(in108, t220); // Eval quot_8 Horner step: add coefficient_0
    let t222 = circuit_mul(in119, in216); // Eval rem_8 Horner step: multiply by STEP
    let t223 = circuit_add(in118, t222); // Eval rem_8 Horner step: add coefficient_4
    let t224 = circuit_mul(t223, in216); // Eval rem_8 Horner step: multiply by STEP
    let t225 = circuit_add(in117, t224); // Eval rem_8 Horner step: add coefficient_3
    let t226 = circuit_mul(t225, in216); // Eval rem_8 Horner step: multiply by STEP
    let t227 = circuit_add(in116, t226); // Eval rem_8 Horner step: add coefficient_2
    let t228 = circuit_mul(t227, in216); // Eval rem_8 Horner step: multiply by STEP
    let t229 = circuit_add(in115, t228); // Eval rem_8 Horner step: add coefficient_1
    let t230 = circuit_mul(t229, in216); // Eval rem_8 Horner step: multiply by STEP
    let t231 = circuit_add(in114, t230); // Eval rem_8 Horner step: add coefficient_0
    let t232 = circuit_mul(t207, t207); // square_8
    let t233 = circuit_mul(t221, t9); // quot*mod_8
    let t234 = circuit_sub(t232, t233); // ab-qn_8
    let t235 = circuit_sub(t234, t231); // ab-qn-rem_8
    let t236 = circuit_mul(in125, in216); // Eval quot_9 Horner step: multiply by STEP
    let t237 = circuit_add(in124, t236); // Eval quot_9 Horner step: add coefficient_4
    let t238 = circuit_mul(t237, in216); // Eval quot_9 Horner step: multiply by STEP
    let t239 = circuit_add(in123, t238); // Eval quot_9 Horner step: add coefficient_3
    let t240 = circuit_mul(t239, in216); // Eval quot_9 Horner step: multiply by STEP
    let t241 = circuit_add(in122, t240); // Eval quot_9 Horner step: add coefficient_2
    let t242 = circuit_mul(t241, in216); // Eval quot_9 Horner step: multiply by STEP
    let t243 = circuit_add(in121, t242); // Eval quot_9 Horner step: add coefficient_1
    let t244 = circuit_mul(t243, in216); // Eval quot_9 Horner step: multiply by STEP
    let t245 = circuit_add(in120, t244); // Eval quot_9 Horner step: add coefficient_0
    let t246 = circuit_mul(in131, in216); // Eval rem_9 Horner step: multiply by STEP
    let t247 = circuit_add(in130, t246); // Eval rem_9 Horner step: add coefficient_4
    let t248 = circuit_mul(t247, in216); // Eval rem_9 Horner step: multiply by STEP
    let t249 = circuit_add(in129, t248); // Eval rem_9 Horner step: add coefficient_3
    let t250 = circuit_mul(t249, in216); // Eval rem_9 Horner step: multiply by STEP
    let t251 = circuit_add(in128, t250); // Eval rem_9 Horner step: add coefficient_2
    let t252 = circuit_mul(t251, in216); // Eval rem_9 Horner step: multiply by STEP
    let t253 = circuit_add(in127, t252); // Eval rem_9 Horner step: add coefficient_1
    let t254 = circuit_mul(t253, in216); // Eval rem_9 Horner step: multiply by STEP
    let t255 = circuit_add(in126, t254); // Eval rem_9 Horner step: add coefficient_0
    let t256 = circuit_mul(t231, t231); // square_9
    let t257 = circuit_mul(t245, t9); // quot*mod_9
    let t258 = circuit_sub(t256, t257); // ab-qn_9
    let t259 = circuit_sub(t258, t255); // ab-qn-rem_9
    let t260 = circuit_mul(in137, in216); // Eval quot_10 Horner step: multiply by STEP
    let t261 = circuit_add(in136, t260); // Eval quot_10 Horner step: add coefficient_4
    let t262 = circuit_mul(t261, in216); // Eval quot_10 Horner step: multiply by STEP
    let t263 = circuit_add(in135, t262); // Eval quot_10 Horner step: add coefficient_3
    let t264 = circuit_mul(t263, in216); // Eval quot_10 Horner step: multiply by STEP
    let t265 = circuit_add(in134, t264); // Eval quot_10 Horner step: add coefficient_2
    let t266 = circuit_mul(t265, in216); // Eval quot_10 Horner step: multiply by STEP
    let t267 = circuit_add(in133, t266); // Eval quot_10 Horner step: add coefficient_1
    let t268 = circuit_mul(t267, in216); // Eval quot_10 Horner step: multiply by STEP
    let t269 = circuit_add(in132, t268); // Eval quot_10 Horner step: add coefficient_0
    let t270 = circuit_mul(in143, in216); // Eval rem_10 Horner step: multiply by STEP
    let t271 = circuit_add(in142, t270); // Eval rem_10 Horner step: add coefficient_4
    let t272 = circuit_mul(t271, in216); // Eval rem_10 Horner step: multiply by STEP
    let t273 = circuit_add(in141, t272); // Eval rem_10 Horner step: add coefficient_3
    let t274 = circuit_mul(t273, in216); // Eval rem_10 Horner step: multiply by STEP
    let t275 = circuit_add(in140, t274); // Eval rem_10 Horner step: add coefficient_2
    let t276 = circuit_mul(t275, in216); // Eval rem_10 Horner step: multiply by STEP
    let t277 = circuit_add(in139, t276); // Eval rem_10 Horner step: add coefficient_1
    let t278 = circuit_mul(t277, in216); // Eval rem_10 Horner step: multiply by STEP
    let t279 = circuit_add(in138, t278); // Eval rem_10 Horner step: add coefficient_0
    let t280 = circuit_mul(t255, t255); // square_10
    let t281 = circuit_mul(t269, t9); // quot*mod_10
    let t282 = circuit_sub(t280, t281); // ab-qn_10
    let t283 = circuit_sub(t282, t279); // ab-qn-rem_10
    let t284 = circuit_mul(in149, in216); // Eval quot_11 Horner step: multiply by STEP
    let t285 = circuit_add(in148, t284); // Eval quot_11 Horner step: add coefficient_4
    let t286 = circuit_mul(t285, in216); // Eval quot_11 Horner step: multiply by STEP
    let t287 = circuit_add(in147, t286); // Eval quot_11 Horner step: add coefficient_3
    let t288 = circuit_mul(t287, in216); // Eval quot_11 Horner step: multiply by STEP
    let t289 = circuit_add(in146, t288); // Eval quot_11 Horner step: add coefficient_2
    let t290 = circuit_mul(t289, in216); // Eval quot_11 Horner step: multiply by STEP
    let t291 = circuit_add(in145, t290); // Eval quot_11 Horner step: add coefficient_1
    let t292 = circuit_mul(t291, in216); // Eval quot_11 Horner step: multiply by STEP
    let t293 = circuit_add(in144, t292); // Eval quot_11 Horner step: add coefficient_0
    let t294 = circuit_mul(in155, in216); // Eval rem_11 Horner step: multiply by STEP
    let t295 = circuit_add(in154, t294); // Eval rem_11 Horner step: add coefficient_4
    let t296 = circuit_mul(t295, in216); // Eval rem_11 Horner step: multiply by STEP
    let t297 = circuit_add(in153, t296); // Eval rem_11 Horner step: add coefficient_3
    let t298 = circuit_mul(t297, in216); // Eval rem_11 Horner step: multiply by STEP
    let t299 = circuit_add(in152, t298); // Eval rem_11 Horner step: add coefficient_2
    let t300 = circuit_mul(t299, in216); // Eval rem_11 Horner step: multiply by STEP
    let t301 = circuit_add(in151, t300); // Eval rem_11 Horner step: add coefficient_1
    let t302 = circuit_mul(t301, in216); // Eval rem_11 Horner step: multiply by STEP
    let t303 = circuit_add(in150, t302); // Eval rem_11 Horner step: add coefficient_0
    let t304 = circuit_mul(t279, t279); // square_11
    let t305 = circuit_mul(t293, t9); // quot*mod_11
    let t306 = circuit_sub(t304, t305); // ab-qn_11
    let t307 = circuit_sub(t306, t303); // ab-qn-rem_11
    let t308 = circuit_mul(in161, in216); // Eval quot_12 Horner step: multiply by STEP
    let t309 = circuit_add(in160, t308); // Eval quot_12 Horner step: add coefficient_4
    let t310 = circuit_mul(t309, in216); // Eval quot_12 Horner step: multiply by STEP
    let t311 = circuit_add(in159, t310); // Eval quot_12 Horner step: add coefficient_3
    let t312 = circuit_mul(t311, in216); // Eval quot_12 Horner step: multiply by STEP
    let t313 = circuit_add(in158, t312); // Eval quot_12 Horner step: add coefficient_2
    let t314 = circuit_mul(t313, in216); // Eval quot_12 Horner step: multiply by STEP
    let t315 = circuit_add(in157, t314); // Eval quot_12 Horner step: add coefficient_1
    let t316 = circuit_mul(t315, in216); // Eval quot_12 Horner step: multiply by STEP
    let t317 = circuit_add(in156, t316); // Eval quot_12 Horner step: add coefficient_0
    let t318 = circuit_mul(in167, in216); // Eval rem_12 Horner step: multiply by STEP
    let t319 = circuit_add(in166, t318); // Eval rem_12 Horner step: add coefficient_4
    let t320 = circuit_mul(t319, in216); // Eval rem_12 Horner step: multiply by STEP
    let t321 = circuit_add(in165, t320); // Eval rem_12 Horner step: add coefficient_3
    let t322 = circuit_mul(t321, in216); // Eval rem_12 Horner step: multiply by STEP
    let t323 = circuit_add(in164, t322); // Eval rem_12 Horner step: add coefficient_2
    let t324 = circuit_mul(t323, in216); // Eval rem_12 Horner step: multiply by STEP
    let t325 = circuit_add(in163, t324); // Eval rem_12 Horner step: add coefficient_1
    let t326 = circuit_mul(t325, in216); // Eval rem_12 Horner step: multiply by STEP
    let t327 = circuit_add(in162, t326); // Eval rem_12 Horner step: add coefficient_0
    let t328 = circuit_mul(t303, t303); // square_12
    let t329 = circuit_mul(t317, t9); // quot*mod_12
    let t330 = circuit_sub(t328, t329); // ab-qn_12
    let t331 = circuit_sub(t330, t327); // ab-qn-rem_12
    let t332 = circuit_mul(in173, in216); // Eval quot_13 Horner step: multiply by STEP
    let t333 = circuit_add(in172, t332); // Eval quot_13 Horner step: add coefficient_4
    let t334 = circuit_mul(t333, in216); // Eval quot_13 Horner step: multiply by STEP
    let t335 = circuit_add(in171, t334); // Eval quot_13 Horner step: add coefficient_3
    let t336 = circuit_mul(t335, in216); // Eval quot_13 Horner step: multiply by STEP
    let t337 = circuit_add(in170, t336); // Eval quot_13 Horner step: add coefficient_2
    let t338 = circuit_mul(t337, in216); // Eval quot_13 Horner step: multiply by STEP
    let t339 = circuit_add(in169, t338); // Eval quot_13 Horner step: add coefficient_1
    let t340 = circuit_mul(t339, in216); // Eval quot_13 Horner step: multiply by STEP
    let t341 = circuit_add(in168, t340); // Eval quot_13 Horner step: add coefficient_0
    let t342 = circuit_mul(in179, in216); // Eval rem_13 Horner step: multiply by STEP
    let t343 = circuit_add(in178, t342); // Eval rem_13 Horner step: add coefficient_4
    let t344 = circuit_mul(t343, in216); // Eval rem_13 Horner step: multiply by STEP
    let t345 = circuit_add(in177, t344); // Eval rem_13 Horner step: add coefficient_3
    let t346 = circuit_mul(t345, in216); // Eval rem_13 Horner step: multiply by STEP
    let t347 = circuit_add(in176, t346); // Eval rem_13 Horner step: add coefficient_2
    let t348 = circuit_mul(t347, in216); // Eval rem_13 Horner step: multiply by STEP
    let t349 = circuit_add(in175, t348); // Eval rem_13 Horner step: add coefficient_1
    let t350 = circuit_mul(t349, in216); // Eval rem_13 Horner step: multiply by STEP
    let t351 = circuit_add(in174, t350); // Eval rem_13 Horner step: add coefficient_0
    let t352 = circuit_mul(t327, t327); // square_13
    let t353 = circuit_mul(t341, t9); // quot*mod_13
    let t354 = circuit_sub(t352, t353); // ab-qn_13
    let t355 = circuit_sub(t354, t351); // ab-qn-rem_13
    let t356 = circuit_mul(in185, in216); // Eval quot_14 Horner step: multiply by STEP
    let t357 = circuit_add(in184, t356); // Eval quot_14 Horner step: add coefficient_4
    let t358 = circuit_mul(t357, in216); // Eval quot_14 Horner step: multiply by STEP
    let t359 = circuit_add(in183, t358); // Eval quot_14 Horner step: add coefficient_3
    let t360 = circuit_mul(t359, in216); // Eval quot_14 Horner step: multiply by STEP
    let t361 = circuit_add(in182, t360); // Eval quot_14 Horner step: add coefficient_2
    let t362 = circuit_mul(t361, in216); // Eval quot_14 Horner step: multiply by STEP
    let t363 = circuit_add(in181, t362); // Eval quot_14 Horner step: add coefficient_1
    let t364 = circuit_mul(t363, in216); // Eval quot_14 Horner step: multiply by STEP
    let t365 = circuit_add(in180, t364); // Eval quot_14 Horner step: add coefficient_0
    let t366 = circuit_mul(in191, in216); // Eval rem_14 Horner step: multiply by STEP
    let t367 = circuit_add(in190, t366); // Eval rem_14 Horner step: add coefficient_4
    let t368 = circuit_mul(t367, in216); // Eval rem_14 Horner step: multiply by STEP
    let t369 = circuit_add(in189, t368); // Eval rem_14 Horner step: add coefficient_3
    let t370 = circuit_mul(t369, in216); // Eval rem_14 Horner step: multiply by STEP
    let t371 = circuit_add(in188, t370); // Eval rem_14 Horner step: add coefficient_2
    let t372 = circuit_mul(t371, in216); // Eval rem_14 Horner step: multiply by STEP
    let t373 = circuit_add(in187, t372); // Eval rem_14 Horner step: add coefficient_1
    let t374 = circuit_mul(t373, in216); // Eval rem_14 Horner step: multiply by STEP
    let t375 = circuit_add(in186, t374); // Eval rem_14 Horner step: add coefficient_0
    let t376 = circuit_mul(t351, t351); // square_14
    let t377 = circuit_mul(t365, t9); // quot*mod_14
    let t378 = circuit_sub(t376, t377); // ab-qn_14
    let t379 = circuit_sub(t378, t375); // ab-qn-rem_14
    let t380 = circuit_mul(in197, in216); // Eval quot_15 Horner step: multiply by STEP
    let t381 = circuit_add(in196, t380); // Eval quot_15 Horner step: add coefficient_4
    let t382 = circuit_mul(t381, in216); // Eval quot_15 Horner step: multiply by STEP
    let t383 = circuit_add(in195, t382); // Eval quot_15 Horner step: add coefficient_3
    let t384 = circuit_mul(t383, in216); // Eval quot_15 Horner step: multiply by STEP
    let t385 = circuit_add(in194, t384); // Eval quot_15 Horner step: add coefficient_2
    let t386 = circuit_mul(t385, in216); // Eval quot_15 Horner step: multiply by STEP
    let t387 = circuit_add(in193, t386); // Eval quot_15 Horner step: add coefficient_1
    let t388 = circuit_mul(t387, in216); // Eval quot_15 Horner step: multiply by STEP
    let t389 = circuit_add(in192, t388); // Eval quot_15 Horner step: add coefficient_0
    let t390 = circuit_mul(in203, in216); // Eval rem_15 Horner step: multiply by STEP
    let t391 = circuit_add(in202, t390); // Eval rem_15 Horner step: add coefficient_4
    let t392 = circuit_mul(t391, in216); // Eval rem_15 Horner step: multiply by STEP
    let t393 = circuit_add(in201, t392); // Eval rem_15 Horner step: add coefficient_3
    let t394 = circuit_mul(t393, in216); // Eval rem_15 Horner step: multiply by STEP
    let t395 = circuit_add(in200, t394); // Eval rem_15 Horner step: add coefficient_2
    let t396 = circuit_mul(t395, in216); // Eval rem_15 Horner step: multiply by STEP
    let t397 = circuit_add(in199, t396); // Eval rem_15 Horner step: add coefficient_1
    let t398 = circuit_mul(t397, in216); // Eval rem_15 Horner step: multiply by STEP
    let t399 = circuit_add(in198, t398); // Eval rem_15 Horner step: add coefficient_0
    let t400 = circuit_mul(t375, t375); // square_15
    let t401 = circuit_mul(t389, t9); // quot*mod_15
    let t402 = circuit_sub(t400, t401); // ab-qn_15
    let t403 = circuit_sub(t402, t399); // ab-qn-rem_15
    let t404 = circuit_mul(in209, in216); // Eval quot_16 Horner step: multiply by STEP
    let t405 = circuit_add(in208, t404); // Eval quot_16 Horner step: add coefficient_4
    let t406 = circuit_mul(t405, in216); // Eval quot_16 Horner step: multiply by STEP
    let t407 = circuit_add(in207, t406); // Eval quot_16 Horner step: add coefficient_3
    let t408 = circuit_mul(t407, in216); // Eval quot_16 Horner step: multiply by STEP
    let t409 = circuit_add(in206, t408); // Eval quot_16 Horner step: add coefficient_2
    let t410 = circuit_mul(t409, in216); // Eval quot_16 Horner step: multiply by STEP
    let t411 = circuit_add(in205, t410); // Eval quot_16 Horner step: add coefficient_1
    let t412 = circuit_mul(t411, in216); // Eval quot_16 Horner step: multiply by STEP
    let t413 = circuit_add(in204, t412); // Eval quot_16 Horner step: add coefficient_0
    let t414 = circuit_mul(in215, in216); // Eval rem_16 Horner step: multiply by STEP
    let t415 = circuit_add(in214, t414); // Eval rem_16 Horner step: add coefficient_4
    let t416 = circuit_mul(t415, in216); // Eval rem_16 Horner step: multiply by STEP
    let t417 = circuit_add(in213, t416); // Eval rem_16 Horner step: add coefficient_3
    let t418 = circuit_mul(t417, in216); // Eval rem_16 Horner step: multiply by STEP
    let t419 = circuit_add(in212, t418); // Eval rem_16 Horner step: add coefficient_2
    let t420 = circuit_mul(t419, in216); // Eval rem_16 Horner step: multiply by STEP
    let t421 = circuit_add(in211, t420); // Eval rem_16 Horner step: add coefficient_1
    let t422 = circuit_mul(t421, in216); // Eval rem_16 Horner step: multiply by STEP
    let t423 = circuit_add(in210, t422); // Eval rem_16 Horner step: add coefficient_0
    let t424 = circuit_mul(t399, t19); // final_multiply
    let t425 = circuit_mul(t413, t9); // quot*mod_16
    let t426 = circuit_sub(t424, t425); // ab-qn_16
    let t427 = circuit_sub(t426, t423); // ab-qn-rem_16

    let modulus = modulus;

    let mut circuit_inputs = (
        t43,
        t67,
        t91,
        t115,
        t139,
        t163,
        t187,
        t211,
        t235,
        t259,
        t283,
        t307,
        t331,
        t355,
        t379,
        t403,
        t427,
    )
        .new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(mod_chunks.w0); // in0
    circuit_inputs = circuit_inputs.next_2(mod_chunks.w1); // in1
    circuit_inputs = circuit_inputs.next_2(mod_chunks.w2); // in2
    circuit_inputs = circuit_inputs.next_2(mod_chunks.w3); // in3
    circuit_inputs = circuit_inputs.next_2(mod_chunks.w4); // in4
    circuit_inputs = circuit_inputs.next_2(mod_chunks.w5); // in5
    circuit_inputs = circuit_inputs.next_2(sig_chunks.w0); // in6
    circuit_inputs = circuit_inputs.next_2(sig_chunks.w1); // in7
    circuit_inputs = circuit_inputs.next_2(sig_chunks.w2); // in8
    circuit_inputs = circuit_inputs.next_2(sig_chunks.w3); // in9
    circuit_inputs = circuit_inputs.next_2(sig_chunks.w4); // in10
    circuit_inputs = circuit_inputs.next_2(sig_chunks.w5); // in11
    circuit_inputs = circuit_inputs.next_2(quot_chunks_0.w0); // in12
    circuit_inputs = circuit_inputs.next_2(quot_chunks_0.w1); // in13
    circuit_inputs = circuit_inputs.next_2(quot_chunks_0.w2); // in14
    circuit_inputs = circuit_inputs.next_2(quot_chunks_0.w3); // in15
    circuit_inputs = circuit_inputs.next_2(quot_chunks_0.w4); // in16
    circuit_inputs = circuit_inputs.next_2(quot_chunks_0.w5); // in17
    circuit_inputs = circuit_inputs.next_2(rem_chunks_0.w0); // in18
    circuit_inputs = circuit_inputs.next_2(rem_chunks_0.w1); // in19
    circuit_inputs = circuit_inputs.next_2(rem_chunks_0.w2); // in20
    circuit_inputs = circuit_inputs.next_2(rem_chunks_0.w3); // in21
    circuit_inputs = circuit_inputs.next_2(rem_chunks_0.w4); // in22
    circuit_inputs = circuit_inputs.next_2(rem_chunks_0.w5); // in23
    circuit_inputs = circuit_inputs.next_2(quot_chunks_1.w0); // in24
    circuit_inputs = circuit_inputs.next_2(quot_chunks_1.w1); // in25
    circuit_inputs = circuit_inputs.next_2(quot_chunks_1.w2); // in26
    circuit_inputs = circuit_inputs.next_2(quot_chunks_1.w3); // in27
    circuit_inputs = circuit_inputs.next_2(quot_chunks_1.w4); // in28
    circuit_inputs = circuit_inputs.next_2(quot_chunks_1.w5); // in29
    circuit_inputs = circuit_inputs.next_2(rem_chunks_1.w0); // in30
    circuit_inputs = circuit_inputs.next_2(rem_chunks_1.w1); // in31
    circuit_inputs = circuit_inputs.next_2(rem_chunks_1.w2); // in32
    circuit_inputs = circuit_inputs.next_2(rem_chunks_1.w3); // in33
    circuit_inputs = circuit_inputs.next_2(rem_chunks_1.w4); // in34
    circuit_inputs = circuit_inputs.next_2(rem_chunks_1.w5); // in35
    circuit_inputs = circuit_inputs.next_2(quot_chunks_2.w0); // in36
    circuit_inputs = circuit_inputs.next_2(quot_chunks_2.w1); // in37
    circuit_inputs = circuit_inputs.next_2(quot_chunks_2.w2); // in38
    circuit_inputs = circuit_inputs.next_2(quot_chunks_2.w3); // in39
    circuit_inputs = circuit_inputs.next_2(quot_chunks_2.w4); // in40
    circuit_inputs = circuit_inputs.next_2(quot_chunks_2.w5); // in41
    circuit_inputs = circuit_inputs.next_2(rem_chunks_2.w0); // in42
    circuit_inputs = circuit_inputs.next_2(rem_chunks_2.w1); // in43
    circuit_inputs = circuit_inputs.next_2(rem_chunks_2.w2); // in44
    circuit_inputs = circuit_inputs.next_2(rem_chunks_2.w3); // in45
    circuit_inputs = circuit_inputs.next_2(rem_chunks_2.w4); // in46
    circuit_inputs = circuit_inputs.next_2(rem_chunks_2.w5); // in47
    circuit_inputs = circuit_inputs.next_2(quot_chunks_3.w0); // in48
    circuit_inputs = circuit_inputs.next_2(quot_chunks_3.w1); // in49
    circuit_inputs = circuit_inputs.next_2(quot_chunks_3.w2); // in50
    circuit_inputs = circuit_inputs.next_2(quot_chunks_3.w3); // in51
    circuit_inputs = circuit_inputs.next_2(quot_chunks_3.w4); // in52
    circuit_inputs = circuit_inputs.next_2(quot_chunks_3.w5); // in53
    circuit_inputs = circuit_inputs.next_2(rem_chunks_3.w0); // in54
    circuit_inputs = circuit_inputs.next_2(rem_chunks_3.w1); // in55
    circuit_inputs = circuit_inputs.next_2(rem_chunks_3.w2); // in56
    circuit_inputs = circuit_inputs.next_2(rem_chunks_3.w3); // in57
    circuit_inputs = circuit_inputs.next_2(rem_chunks_3.w4); // in58
    circuit_inputs = circuit_inputs.next_2(rem_chunks_3.w5); // in59
    circuit_inputs = circuit_inputs.next_2(quot_chunks_4.w0); // in60
    circuit_inputs = circuit_inputs.next_2(quot_chunks_4.w1); // in61
    circuit_inputs = circuit_inputs.next_2(quot_chunks_4.w2); // in62
    circuit_inputs = circuit_inputs.next_2(quot_chunks_4.w3); // in63
    circuit_inputs = circuit_inputs.next_2(quot_chunks_4.w4); // in64
    circuit_inputs = circuit_inputs.next_2(quot_chunks_4.w5); // in65
    circuit_inputs = circuit_inputs.next_2(rem_chunks_4.w0); // in66
    circuit_inputs = circuit_inputs.next_2(rem_chunks_4.w1); // in67
    circuit_inputs = circuit_inputs.next_2(rem_chunks_4.w2); // in68
    circuit_inputs = circuit_inputs.next_2(rem_chunks_4.w3); // in69
    circuit_inputs = circuit_inputs.next_2(rem_chunks_4.w4); // in70
    circuit_inputs = circuit_inputs.next_2(rem_chunks_4.w5); // in71
    circuit_inputs = circuit_inputs.next_2(quot_chunks_5.w0); // in72
    circuit_inputs = circuit_inputs.next_2(quot_chunks_5.w1); // in73
    circuit_inputs = circuit_inputs.next_2(quot_chunks_5.w2); // in74
    circuit_inputs = circuit_inputs.next_2(quot_chunks_5.w3); // in75
    circuit_inputs = circuit_inputs.next_2(quot_chunks_5.w4); // in76
    circuit_inputs = circuit_inputs.next_2(quot_chunks_5.w5); // in77
    circuit_inputs = circuit_inputs.next_2(rem_chunks_5.w0); // in78
    circuit_inputs = circuit_inputs.next_2(rem_chunks_5.w1); // in79
    circuit_inputs = circuit_inputs.next_2(rem_chunks_5.w2); // in80
    circuit_inputs = circuit_inputs.next_2(rem_chunks_5.w3); // in81
    circuit_inputs = circuit_inputs.next_2(rem_chunks_5.w4); // in82
    circuit_inputs = circuit_inputs.next_2(rem_chunks_5.w5); // in83
    circuit_inputs = circuit_inputs.next_2(quot_chunks_6.w0); // in84
    circuit_inputs = circuit_inputs.next_2(quot_chunks_6.w1); // in85
    circuit_inputs = circuit_inputs.next_2(quot_chunks_6.w2); // in86
    circuit_inputs = circuit_inputs.next_2(quot_chunks_6.w3); // in87
    circuit_inputs = circuit_inputs.next_2(quot_chunks_6.w4); // in88
    circuit_inputs = circuit_inputs.next_2(quot_chunks_6.w5); // in89
    circuit_inputs = circuit_inputs.next_2(rem_chunks_6.w0); // in90
    circuit_inputs = circuit_inputs.next_2(rem_chunks_6.w1); // in91
    circuit_inputs = circuit_inputs.next_2(rem_chunks_6.w2); // in92
    circuit_inputs = circuit_inputs.next_2(rem_chunks_6.w3); // in93
    circuit_inputs = circuit_inputs.next_2(rem_chunks_6.w4); // in94
    circuit_inputs = circuit_inputs.next_2(rem_chunks_6.w5); // in95
    circuit_inputs = circuit_inputs.next_2(quot_chunks_7.w0); // in96
    circuit_inputs = circuit_inputs.next_2(quot_chunks_7.w1); // in97
    circuit_inputs = circuit_inputs.next_2(quot_chunks_7.w2); // in98
    circuit_inputs = circuit_inputs.next_2(quot_chunks_7.w3); // in99
    circuit_inputs = circuit_inputs.next_2(quot_chunks_7.w4); // in100
    circuit_inputs = circuit_inputs.next_2(quot_chunks_7.w5); // in101
    circuit_inputs = circuit_inputs.next_2(rem_chunks_7.w0); // in102
    circuit_inputs = circuit_inputs.next_2(rem_chunks_7.w1); // in103
    circuit_inputs = circuit_inputs.next_2(rem_chunks_7.w2); // in104
    circuit_inputs = circuit_inputs.next_2(rem_chunks_7.w3); // in105
    circuit_inputs = circuit_inputs.next_2(rem_chunks_7.w4); // in106
    circuit_inputs = circuit_inputs.next_2(rem_chunks_7.w5); // in107
    circuit_inputs = circuit_inputs.next_2(quot_chunks_8.w0); // in108
    circuit_inputs = circuit_inputs.next_2(quot_chunks_8.w1); // in109
    circuit_inputs = circuit_inputs.next_2(quot_chunks_8.w2); // in110
    circuit_inputs = circuit_inputs.next_2(quot_chunks_8.w3); // in111
    circuit_inputs = circuit_inputs.next_2(quot_chunks_8.w4); // in112
    circuit_inputs = circuit_inputs.next_2(quot_chunks_8.w5); // in113
    circuit_inputs = circuit_inputs.next_2(rem_chunks_8.w0); // in114
    circuit_inputs = circuit_inputs.next_2(rem_chunks_8.w1); // in115
    circuit_inputs = circuit_inputs.next_2(rem_chunks_8.w2); // in116
    circuit_inputs = circuit_inputs.next_2(rem_chunks_8.w3); // in117
    circuit_inputs = circuit_inputs.next_2(rem_chunks_8.w4); // in118
    circuit_inputs = circuit_inputs.next_2(rem_chunks_8.w5); // in119
    circuit_inputs = circuit_inputs.next_2(quot_chunks_9.w0); // in120
    circuit_inputs = circuit_inputs.next_2(quot_chunks_9.w1); // in121
    circuit_inputs = circuit_inputs.next_2(quot_chunks_9.w2); // in122
    circuit_inputs = circuit_inputs.next_2(quot_chunks_9.w3); // in123
    circuit_inputs = circuit_inputs.next_2(quot_chunks_9.w4); // in124
    circuit_inputs = circuit_inputs.next_2(quot_chunks_9.w5); // in125
    circuit_inputs = circuit_inputs.next_2(rem_chunks_9.w0); // in126
    circuit_inputs = circuit_inputs.next_2(rem_chunks_9.w1); // in127
    circuit_inputs = circuit_inputs.next_2(rem_chunks_9.w2); // in128
    circuit_inputs = circuit_inputs.next_2(rem_chunks_9.w3); // in129
    circuit_inputs = circuit_inputs.next_2(rem_chunks_9.w4); // in130
    circuit_inputs = circuit_inputs.next_2(rem_chunks_9.w5); // in131
    circuit_inputs = circuit_inputs.next_2(quot_chunks_10.w0); // in132
    circuit_inputs = circuit_inputs.next_2(quot_chunks_10.w1); // in133
    circuit_inputs = circuit_inputs.next_2(quot_chunks_10.w2); // in134
    circuit_inputs = circuit_inputs.next_2(quot_chunks_10.w3); // in135
    circuit_inputs = circuit_inputs.next_2(quot_chunks_10.w4); // in136
    circuit_inputs = circuit_inputs.next_2(quot_chunks_10.w5); // in137
    circuit_inputs = circuit_inputs.next_2(rem_chunks_10.w0); // in138
    circuit_inputs = circuit_inputs.next_2(rem_chunks_10.w1); // in139
    circuit_inputs = circuit_inputs.next_2(rem_chunks_10.w2); // in140
    circuit_inputs = circuit_inputs.next_2(rem_chunks_10.w3); // in141
    circuit_inputs = circuit_inputs.next_2(rem_chunks_10.w4); // in142
    circuit_inputs = circuit_inputs.next_2(rem_chunks_10.w5); // in143
    circuit_inputs = circuit_inputs.next_2(quot_chunks_11.w0); // in144
    circuit_inputs = circuit_inputs.next_2(quot_chunks_11.w1); // in145
    circuit_inputs = circuit_inputs.next_2(quot_chunks_11.w2); // in146
    circuit_inputs = circuit_inputs.next_2(quot_chunks_11.w3); // in147
    circuit_inputs = circuit_inputs.next_2(quot_chunks_11.w4); // in148
    circuit_inputs = circuit_inputs.next_2(quot_chunks_11.w5); // in149
    circuit_inputs = circuit_inputs.next_2(rem_chunks_11.w0); // in150
    circuit_inputs = circuit_inputs.next_2(rem_chunks_11.w1); // in151
    circuit_inputs = circuit_inputs.next_2(rem_chunks_11.w2); // in152
    circuit_inputs = circuit_inputs.next_2(rem_chunks_11.w3); // in153
    circuit_inputs = circuit_inputs.next_2(rem_chunks_11.w4); // in154
    circuit_inputs = circuit_inputs.next_2(rem_chunks_11.w5); // in155
    circuit_inputs = circuit_inputs.next_2(quot_chunks_12.w0); // in156
    circuit_inputs = circuit_inputs.next_2(quot_chunks_12.w1); // in157
    circuit_inputs = circuit_inputs.next_2(quot_chunks_12.w2); // in158
    circuit_inputs = circuit_inputs.next_2(quot_chunks_12.w3); // in159
    circuit_inputs = circuit_inputs.next_2(quot_chunks_12.w4); // in160
    circuit_inputs = circuit_inputs.next_2(quot_chunks_12.w5); // in161
    circuit_inputs = circuit_inputs.next_2(rem_chunks_12.w0); // in162
    circuit_inputs = circuit_inputs.next_2(rem_chunks_12.w1); // in163
    circuit_inputs = circuit_inputs.next_2(rem_chunks_12.w2); // in164
    circuit_inputs = circuit_inputs.next_2(rem_chunks_12.w3); // in165
    circuit_inputs = circuit_inputs.next_2(rem_chunks_12.w4); // in166
    circuit_inputs = circuit_inputs.next_2(rem_chunks_12.w5); // in167
    circuit_inputs = circuit_inputs.next_2(quot_chunks_13.w0); // in168
    circuit_inputs = circuit_inputs.next_2(quot_chunks_13.w1); // in169
    circuit_inputs = circuit_inputs.next_2(quot_chunks_13.w2); // in170
    circuit_inputs = circuit_inputs.next_2(quot_chunks_13.w3); // in171
    circuit_inputs = circuit_inputs.next_2(quot_chunks_13.w4); // in172
    circuit_inputs = circuit_inputs.next_2(quot_chunks_13.w5); // in173
    circuit_inputs = circuit_inputs.next_2(rem_chunks_13.w0); // in174
    circuit_inputs = circuit_inputs.next_2(rem_chunks_13.w1); // in175
    circuit_inputs = circuit_inputs.next_2(rem_chunks_13.w2); // in176
    circuit_inputs = circuit_inputs.next_2(rem_chunks_13.w3); // in177
    circuit_inputs = circuit_inputs.next_2(rem_chunks_13.w4); // in178
    circuit_inputs = circuit_inputs.next_2(rem_chunks_13.w5); // in179
    circuit_inputs = circuit_inputs.next_2(quot_chunks_14.w0); // in180
    circuit_inputs = circuit_inputs.next_2(quot_chunks_14.w1); // in181
    circuit_inputs = circuit_inputs.next_2(quot_chunks_14.w2); // in182
    circuit_inputs = circuit_inputs.next_2(quot_chunks_14.w3); // in183
    circuit_inputs = circuit_inputs.next_2(quot_chunks_14.w4); // in184
    circuit_inputs = circuit_inputs.next_2(quot_chunks_14.w5); // in185
    circuit_inputs = circuit_inputs.next_2(rem_chunks_14.w0); // in186
    circuit_inputs = circuit_inputs.next_2(rem_chunks_14.w1); // in187
    circuit_inputs = circuit_inputs.next_2(rem_chunks_14.w2); // in188
    circuit_inputs = circuit_inputs.next_2(rem_chunks_14.w3); // in189
    circuit_inputs = circuit_inputs.next_2(rem_chunks_14.w4); // in190
    circuit_inputs = circuit_inputs.next_2(rem_chunks_14.w5); // in191
    circuit_inputs = circuit_inputs.next_2(quot_chunks_15.w0); // in192
    circuit_inputs = circuit_inputs.next_2(quot_chunks_15.w1); // in193
    circuit_inputs = circuit_inputs.next_2(quot_chunks_15.w2); // in194
    circuit_inputs = circuit_inputs.next_2(quot_chunks_15.w3); // in195
    circuit_inputs = circuit_inputs.next_2(quot_chunks_15.w4); // in196
    circuit_inputs = circuit_inputs.next_2(quot_chunks_15.w5); // in197
    circuit_inputs = circuit_inputs.next_2(rem_chunks_15.w0); // in198
    circuit_inputs = circuit_inputs.next_2(rem_chunks_15.w1); // in199
    circuit_inputs = circuit_inputs.next_2(rem_chunks_15.w2); // in200
    circuit_inputs = circuit_inputs.next_2(rem_chunks_15.w3); // in201
    circuit_inputs = circuit_inputs.next_2(rem_chunks_15.w4); // in202
    circuit_inputs = circuit_inputs.next_2(rem_chunks_15.w5); // in203
    circuit_inputs = circuit_inputs.next_2(quot_chunks_16.w0); // in204
    circuit_inputs = circuit_inputs.next_2(quot_chunks_16.w1); // in205
    circuit_inputs = circuit_inputs.next_2(quot_chunks_16.w2); // in206
    circuit_inputs = circuit_inputs.next_2(quot_chunks_16.w3); // in207
    circuit_inputs = circuit_inputs.next_2(quot_chunks_16.w4); // in208
    circuit_inputs = circuit_inputs.next_2(quot_chunks_16.w5); // in209
    circuit_inputs = circuit_inputs.next_2(rem_chunks_16.w0); // in210
    circuit_inputs = circuit_inputs.next_2(rem_chunks_16.w1); // in211
    circuit_inputs = circuit_inputs.next_2(rem_chunks_16.w2); // in212
    circuit_inputs = circuit_inputs.next_2(rem_chunks_16.w3); // in213
    circuit_inputs = circuit_inputs.next_2(rem_chunks_16.w4); // in214
    circuit_inputs = circuit_inputs.next_2(rem_chunks_16.w5); // in215
    circuit_inputs = circuit_inputs.next_2(step); // in216

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let diff_0: u384 = outputs.get_output(t43);
    let diff_1: u384 = outputs.get_output(t67);
    let diff_2: u384 = outputs.get_output(t91);
    let diff_3: u384 = outputs.get_output(t115);
    let diff_4: u384 = outputs.get_output(t139);
    let diff_5: u384 = outputs.get_output(t163);
    let diff_6: u384 = outputs.get_output(t187);
    let diff_7: u384 = outputs.get_output(t211);
    let diff_8: u384 = outputs.get_output(t235);
    let diff_9: u384 = outputs.get_output(t259);
    let diff_10: u384 = outputs.get_output(t283);
    let diff_11: u384 = outputs.get_output(t307);
    let diff_12: u384 = outputs.get_output(t331);
    let diff_13: u384 = outputs.get_output(t355);
    let diff_14: u384 = outputs.get_output(t379);
    let diff_15: u384 = outputs.get_output(t403);
    let diff_16: u384 = outputs.get_output(t427);
    return (
        diff_0,
        diff_1,
        diff_2,
        diff_3,
        diff_4,
        diff_5,
        diff_6,
        diff_7,
        diff_8,
        diff_9,
        diff_10,
        diff_11,
        diff_12,
        diff_13,
        diff_14,
        diff_15,
        diff_16,
    );
}
