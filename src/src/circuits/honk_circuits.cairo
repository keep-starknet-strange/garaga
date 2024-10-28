use core::circuit::{
    RangeCheck96, AddMod, MulMod, u384, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
    circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, CircuitOutputsTrait,
    CircuitModulus, AddInputResultTrait, CircuitInputs, CircuitDefinition, CircuitData,
    CircuitInputAccumulator
};
use garaga::core::circuit::AddInputResultTrait2;
use core::circuit::CircuitElement as CE;
use core::circuit::CircuitInput as CI;
use garaga::definitions::{
    get_a, get_b, get_p, get_g, get_min_one, G1Point, G2Point, E12D, u288, E12DMulQuotient,
    G1G2Pair, BNProcessedPair, BLSProcessedPair, MillerLoopResultScalingFactor, G2Line,
    get_BLS12_381_modulus, get_BN254_modulus
};
use garaga::ec_ops::{SlopeInterceptOutput, FunctionFeltEvaluations, FunctionFelt};
use core::option::Option;

#[inline(always)]
fn run_GRUMPKIN_HONK_SUMCHECK_SIZE_16_PUB_6_circuit(
    p_public_inputs: Array<u288>,
    p_public_inputs_offset: u384,
    sumcheck_univariate_0: Array<u288>,
    sumcheck_univariate_1: Array<u288>,
    sumcheck_univariate_2: Array<u288>,
    sumcheck_univariate_3: Array<u288>,
    sumcheck_univariate_4: Array<u288>,
    sumcheck_univariate_5: Array<u288>,
    sumcheck_univariate_6: Array<u288>,
    sumcheck_univariate_7: Array<u288>,
    sumcheck_evaluations: Array<u288>,
    tp_sum_check_u_challenges: Array<u288>,
    tp_gate_challenges: Array<u288>,
    tp_eta_1: u384,
    tp_eta_2: u384,
    tp_eta_3: u384,
    tp_beta: u384,
    tp_gamma: u384,
    tp_base_rlc: u384,
    tp_alphas: Array<u288>
) -> (u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x1
    let in1 = CE::<CI<1>> {}; // 0x10000
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
        CI<17>
    > {}; // 0x183227397098d014dc2822db40c0ac2e9419f4243cdcb848a1f0fac9f8000000
    let in18 = CE::<CI<18>> {}; // -0x1 % p
    let in19 = CE::<CI<19>> {}; // -0x2 % p
    let in20 = CE::<CI<20>> {}; // -0x3 % p
    let in21 = CE::<CI<21>> {}; // 0x11
    let in22 = CE::<CI<22>> {}; // 0x9
    let in23 = CE::<CI<23>> {}; // 0x100000000000000000
    let in24 = CE::<CI<24>> {}; // 0x4000
    let in25 = CE::<
        CI<25>
    > {}; // 0x10dc6e9c006ea38b04b1e03b4bd9490c0d03f98929ca1d7fb56821fd19d3b6e7
    let in26 = CE::<CI<26>> {}; // 0xc28145b6a44df3e0149b3d0a30b3bb599df9756d4dd9b84a86b38cfb45a740b
    let in27 = CE::<CI<27>> {}; // 0x544b8338791518b2c7645a50392798b21f75bb60e3596170067d00141cac15
    let in28 = CE::<
        CI<28>
    > {}; // 0x222c01175718386f2e2e82eb122789e352e105a3b8fa852613bc534433ee428b

    // INPUT stack
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
    let (in245, in246, in247) = (CE::<CI<245>> {}, CE::<CI<246>> {}, CE::<CI<247>> {});
    let (in248, in249, in250) = (CE::<CI<248>> {}, CE::<CI<249>> {}, CE::<CI<250>> {});
    let (in251, in252, in253) = (CE::<CI<251>> {}, CE::<CI<252>> {}, CE::<CI<253>> {});
    let (in254, in255, in256) = (CE::<CI<254>> {}, CE::<CI<255>> {}, CE::<CI<256>> {});
    let (in257, in258, in259) = (CE::<CI<257>> {}, CE::<CI<258>> {}, CE::<CI<259>> {});
    let (in260, in261, in262) = (CE::<CI<260>> {}, CE::<CI<261>> {}, CE::<CI<262>> {});
    let (in263, in264, in265) = (CE::<CI<263>> {}, CE::<CI<264>> {}, CE::<CI<265>> {});
    let (in266, in267, in268) = (CE::<CI<266>> {}, CE::<CI<267>> {}, CE::<CI<268>> {});
    let (in269, in270, in271) = (CE::<CI<269>> {}, CE::<CI<270>> {}, CE::<CI<271>> {});
    let (in272, in273, in274) = (CE::<CI<272>> {}, CE::<CI<273>> {}, CE::<CI<274>> {});
    let (in275, in276, in277) = (CE::<CI<275>> {}, CE::<CI<276>> {}, CE::<CI<277>> {});
    let (in278, in279, in280) = (CE::<CI<278>> {}, CE::<CI<279>> {}, CE::<CI<280>> {});
    let (in281, in282, in283) = (CE::<CI<281>> {}, CE::<CI<282>> {}, CE::<CI<283>> {});
    let (in284, in285, in286) = (CE::<CI<284>> {}, CE::<CI<285>> {}, CE::<CI<286>> {});
    let (in287, in288, in289) = (CE::<CI<287>> {}, CE::<CI<288>> {}, CE::<CI<289>> {});
    let (in290, in291, in292) = (CE::<CI<290>> {}, CE::<CI<291>> {}, CE::<CI<292>> {});
    let (in293, in294, in295) = (CE::<CI<293>> {}, CE::<CI<294>> {}, CE::<CI<295>> {});
    let (in296, in297, in298) = (CE::<CI<296>> {}, CE::<CI<297>> {}, CE::<CI<298>> {});
    let (in299, in300, in301) = (CE::<CI<299>> {}, CE::<CI<300>> {}, CE::<CI<301>> {});
    let (in302, in303, in304) = (CE::<CI<302>> {}, CE::<CI<303>> {}, CE::<CI<304>> {});
    let (in305, in306, in307) = (CE::<CI<305>> {}, CE::<CI<306>> {}, CE::<CI<307>> {});
    let (in308, in309, in310) = (CE::<CI<308>> {}, CE::<CI<309>> {}, CE::<CI<310>> {});
    let (in311, in312, in313) = (CE::<CI<311>> {}, CE::<CI<312>> {}, CE::<CI<313>> {});
    let (in314, in315, in316) = (CE::<CI<314>> {}, CE::<CI<315>> {}, CE::<CI<316>> {});
    let (in317, in318, in319) = (CE::<CI<317>> {}, CE::<CI<318>> {}, CE::<CI<319>> {});
    let (in320, in321, in322) = (CE::<CI<320>> {}, CE::<CI<321>> {}, CE::<CI<322>> {});
    let (in323, in324, in325) = (CE::<CI<323>> {}, CE::<CI<324>> {}, CE::<CI<325>> {});
    let (in326, in327, in328) = (CE::<CI<326>> {}, CE::<CI<327>> {}, CE::<CI<328>> {});
    let (in329, in330, in331) = (CE::<CI<329>> {}, CE::<CI<330>> {}, CE::<CI<331>> {});
    let (in332, in333, in334) = (CE::<CI<332>> {}, CE::<CI<333>> {}, CE::<CI<334>> {});
    let (in335, in336, in337) = (CE::<CI<335>> {}, CE::<CI<336>> {}, CE::<CI<337>> {});
    let (in338, in339, in340) = (CE::<CI<338>> {}, CE::<CI<339>> {}, CE::<CI<340>> {});
    let (in341, in342, in343) = (CE::<CI<341>> {}, CE::<CI<342>> {}, CE::<CI<343>> {});
    let (in344, in345, in346) = (CE::<CI<344>> {}, CE::<CI<345>> {}, CE::<CI<346>> {});
    let (in347, in348, in349) = (CE::<CI<347>> {}, CE::<CI<348>> {}, CE::<CI<349>> {});
    let (in350, in351, in352) = (CE::<CI<350>> {}, CE::<CI<351>> {}, CE::<CI<352>> {});
    let (in353, in354, in355) = (CE::<CI<353>> {}, CE::<CI<354>> {}, CE::<CI<355>> {});
    let (in356, in357, in358) = (CE::<CI<356>> {}, CE::<CI<357>> {}, CE::<CI<358>> {});
    let (in359, in360, in361) = (CE::<CI<359>> {}, CE::<CI<360>> {}, CE::<CI<361>> {});
    let (in362, in363, in364) = (CE::<CI<362>> {}, CE::<CI<363>> {}, CE::<CI<364>> {});
    let (in365, in366, in367) = (CE::<CI<365>> {}, CE::<CI<366>> {}, CE::<CI<367>> {});
    let (in368, in369, in370) = (CE::<CI<368>> {}, CE::<CI<369>> {}, CE::<CI<370>> {});
    let (in371, in372, in373) = (CE::<CI<371>> {}, CE::<CI<372>> {}, CE::<CI<373>> {});
    let (in374, in375, in376) = (CE::<CI<374>> {}, CE::<CI<375>> {}, CE::<CI<376>> {});
    let (in377, in378, in379) = (CE::<CI<377>> {}, CE::<CI<378>> {}, CE::<CI<379>> {});
    let (in380, in381, in382) = (CE::<CI<380>> {}, CE::<CI<381>> {}, CE::<CI<382>> {});
    let (in383, in384, in385) = (CE::<CI<383>> {}, CE::<CI<384>> {}, CE::<CI<385>> {});
    let (in386, in387, in388) = (CE::<CI<386>> {}, CE::<CI<387>> {}, CE::<CI<388>> {});
    let (in389, in390) = (CE::<CI<389>> {}, CE::<CI<390>> {});
    let t0 = circuit_add(in1, in35);
    let t1 = circuit_mul(in363, t0);
    let t2 = circuit_add(in364, t1);
    let t3 = circuit_add(in35, in0);
    let t4 = circuit_mul(in363, t3);
    let t5 = circuit_sub(in364, t4);
    let t6 = circuit_add(t2, in29);
    let t7 = circuit_mul(in0, t6);
    let t8 = circuit_add(t5, in29);
    let t9 = circuit_mul(in0, t8);
    let t10 = circuit_add(t2, in363);
    let t11 = circuit_sub(t5, in363);
    let t12 = circuit_add(t10, in30);
    let t13 = circuit_mul(t7, t12);
    let t14 = circuit_add(t11, in30);
    let t15 = circuit_mul(t9, t14);
    let t16 = circuit_add(t10, in363);
    let t17 = circuit_sub(t11, in363);
    let t18 = circuit_add(t16, in31);
    let t19 = circuit_mul(t13, t18);
    let t20 = circuit_add(t17, in31);
    let t21 = circuit_mul(t15, t20);
    let t22 = circuit_add(t16, in363);
    let t23 = circuit_sub(t17, in363);
    let t24 = circuit_add(t22, in32);
    let t25 = circuit_mul(t19, t24);
    let t26 = circuit_add(t23, in32);
    let t27 = circuit_mul(t21, t26);
    let t28 = circuit_add(t22, in363);
    let t29 = circuit_sub(t23, in363);
    let t30 = circuit_add(t28, in33);
    let t31 = circuit_mul(t25, t30);
    let t32 = circuit_add(t29, in33);
    let t33 = circuit_mul(t27, t32);
    let t34 = circuit_add(t28, in363);
    let t35 = circuit_sub(t29, in363);
    let t36 = circuit_add(t34, in34);
    let t37 = circuit_mul(t31, t36);
    let t38 = circuit_add(t35, in34);
    let t39 = circuit_mul(t33, t38);
    let t40 = circuit_add(t34, in363);
    let t41 = circuit_sub(t35, in363);
    let t42 = circuit_inverse(t39);
    let t43 = circuit_mul(t37, t42);
    let t44 = circuit_add(in36, in64);
    let t45 = circuit_sub(t44, in2);
    let t46 = circuit_mul(t45, in365);
    let t47 = circuit_add(in2, t46);
    let t48 = circuit_mul(in365, in365);
    let t49 = circuit_sub(in304, in2);
    let t50 = circuit_mul(in0, t49);
    let t51 = circuit_sub(in304, in2);
    let t52 = circuit_mul(in3, t51);
    let t53 = circuit_inverse(t52);
    let t54 = circuit_mul(in36, t53);
    let t55 = circuit_add(in2, t54);
    let t56 = circuit_sub(in304, in0);
    let t57 = circuit_mul(t50, t56);
    let t58 = circuit_sub(in304, in0);
    let t59 = circuit_mul(in4, t58);
    let t60 = circuit_inverse(t59);
    let t61 = circuit_mul(in64, t60);
    let t62 = circuit_add(t55, t61);
    let t63 = circuit_sub(in304, in11);
    let t64 = circuit_mul(t57, t63);
    let t65 = circuit_sub(in304, in11);
    let t66 = circuit_mul(in5, t65);
    let t67 = circuit_inverse(t66);
    let t68 = circuit_mul(in92, t67);
    let t69 = circuit_add(t62, t68);
    let t70 = circuit_sub(in304, in12);
    let t71 = circuit_mul(t64, t70);
    let t72 = circuit_sub(in304, in12);
    let t73 = circuit_mul(in6, t72);
    let t74 = circuit_inverse(t73);
    let t75 = circuit_mul(in120, t74);
    let t76 = circuit_add(t69, t75);
    let t77 = circuit_sub(in304, in13);
    let t78 = circuit_mul(t71, t77);
    let t79 = circuit_sub(in304, in13);
    let t80 = circuit_mul(in7, t79);
    let t81 = circuit_inverse(t80);
    let t82 = circuit_mul(in148, t81);
    let t83 = circuit_add(t76, t82);
    let t84 = circuit_sub(in304, in14);
    let t85 = circuit_mul(t78, t84);
    let t86 = circuit_sub(in304, in14);
    let t87 = circuit_mul(in8, t86);
    let t88 = circuit_inverse(t87);
    let t89 = circuit_mul(in176, t88);
    let t90 = circuit_add(t83, t89);
    let t91 = circuit_sub(in304, in15);
    let t92 = circuit_mul(t85, t91);
    let t93 = circuit_sub(in304, in15);
    let t94 = circuit_mul(in9, t93);
    let t95 = circuit_inverse(t94);
    let t96 = circuit_mul(in204, t95);
    let t97 = circuit_add(t90, t96);
    let t98 = circuit_sub(in304, in16);
    let t99 = circuit_mul(t92, t98);
    let t100 = circuit_sub(in304, in16);
    let t101 = circuit_mul(in10, t100);
    let t102 = circuit_inverse(t101);
    let t103 = circuit_mul(in232, t102);
    let t104 = circuit_add(t97, t103);
    let t105 = circuit_mul(t104, t99);
    let t106 = circuit_sub(in332, in0);
    let t107 = circuit_mul(in304, t106);
    let t108 = circuit_add(in0, t107);
    let t109 = circuit_mul(in0, t108);
    let t110 = circuit_add(in37, in65);
    let t111 = circuit_sub(t110, t105);
    let t112 = circuit_mul(t111, t48);
    let t113 = circuit_add(t47, t112);
    let t114 = circuit_mul(t48, in365);
    let t115 = circuit_sub(in305, in2);
    let t116 = circuit_mul(in0, t115);
    let t117 = circuit_sub(in305, in2);
    let t118 = circuit_mul(in3, t117);
    let t119 = circuit_inverse(t118);
    let t120 = circuit_mul(in37, t119);
    let t121 = circuit_add(in2, t120);
    let t122 = circuit_sub(in305, in0);
    let t123 = circuit_mul(t116, t122);
    let t124 = circuit_sub(in305, in0);
    let t125 = circuit_mul(in4, t124);
    let t126 = circuit_inverse(t125);
    let t127 = circuit_mul(in65, t126);
    let t128 = circuit_add(t121, t127);
    let t129 = circuit_sub(in305, in11);
    let t130 = circuit_mul(t123, t129);
    let t131 = circuit_sub(in305, in11);
    let t132 = circuit_mul(in5, t131);
    let t133 = circuit_inverse(t132);
    let t134 = circuit_mul(in93, t133);
    let t135 = circuit_add(t128, t134);
    let t136 = circuit_sub(in305, in12);
    let t137 = circuit_mul(t130, t136);
    let t138 = circuit_sub(in305, in12);
    let t139 = circuit_mul(in6, t138);
    let t140 = circuit_inverse(t139);
    let t141 = circuit_mul(in121, t140);
    let t142 = circuit_add(t135, t141);
    let t143 = circuit_sub(in305, in13);
    let t144 = circuit_mul(t137, t143);
    let t145 = circuit_sub(in305, in13);
    let t146 = circuit_mul(in7, t145);
    let t147 = circuit_inverse(t146);
    let t148 = circuit_mul(in149, t147);
    let t149 = circuit_add(t142, t148);
    let t150 = circuit_sub(in305, in14);
    let t151 = circuit_mul(t144, t150);
    let t152 = circuit_sub(in305, in14);
    let t153 = circuit_mul(in8, t152);
    let t154 = circuit_inverse(t153);
    let t155 = circuit_mul(in177, t154);
    let t156 = circuit_add(t149, t155);
    let t157 = circuit_sub(in305, in15);
    let t158 = circuit_mul(t151, t157);
    let t159 = circuit_sub(in305, in15);
    let t160 = circuit_mul(in9, t159);
    let t161 = circuit_inverse(t160);
    let t162 = circuit_mul(in205, t161);
    let t163 = circuit_add(t156, t162);
    let t164 = circuit_sub(in305, in16);
    let t165 = circuit_mul(t158, t164);
    let t166 = circuit_sub(in305, in16);
    let t167 = circuit_mul(in10, t166);
    let t168 = circuit_inverse(t167);
    let t169 = circuit_mul(in233, t168);
    let t170 = circuit_add(t163, t169);
    let t171 = circuit_mul(t170, t165);
    let t172 = circuit_sub(in333, in0);
    let t173 = circuit_mul(in305, t172);
    let t174 = circuit_add(in0, t173);
    let t175 = circuit_mul(t109, t174);
    let t176 = circuit_add(in38, in66);
    let t177 = circuit_sub(t176, t171);
    let t178 = circuit_mul(t177, t114);
    let t179 = circuit_add(t113, t178);
    let t180 = circuit_mul(t114, in365);
    let t181 = circuit_sub(in306, in2);
    let t182 = circuit_mul(in0, t181);
    let t183 = circuit_sub(in306, in2);
    let t184 = circuit_mul(in3, t183);
    let t185 = circuit_inverse(t184);
    let t186 = circuit_mul(in38, t185);
    let t187 = circuit_add(in2, t186);
    let t188 = circuit_sub(in306, in0);
    let t189 = circuit_mul(t182, t188);
    let t190 = circuit_sub(in306, in0);
    let t191 = circuit_mul(in4, t190);
    let t192 = circuit_inverse(t191);
    let t193 = circuit_mul(in66, t192);
    let t194 = circuit_add(t187, t193);
    let t195 = circuit_sub(in306, in11);
    let t196 = circuit_mul(t189, t195);
    let t197 = circuit_sub(in306, in11);
    let t198 = circuit_mul(in5, t197);
    let t199 = circuit_inverse(t198);
    let t200 = circuit_mul(in94, t199);
    let t201 = circuit_add(t194, t200);
    let t202 = circuit_sub(in306, in12);
    let t203 = circuit_mul(t196, t202);
    let t204 = circuit_sub(in306, in12);
    let t205 = circuit_mul(in6, t204);
    let t206 = circuit_inverse(t205);
    let t207 = circuit_mul(in122, t206);
    let t208 = circuit_add(t201, t207);
    let t209 = circuit_sub(in306, in13);
    let t210 = circuit_mul(t203, t209);
    let t211 = circuit_sub(in306, in13);
    let t212 = circuit_mul(in7, t211);
    let t213 = circuit_inverse(t212);
    let t214 = circuit_mul(in150, t213);
    let t215 = circuit_add(t208, t214);
    let t216 = circuit_sub(in306, in14);
    let t217 = circuit_mul(t210, t216);
    let t218 = circuit_sub(in306, in14);
    let t219 = circuit_mul(in8, t218);
    let t220 = circuit_inverse(t219);
    let t221 = circuit_mul(in178, t220);
    let t222 = circuit_add(t215, t221);
    let t223 = circuit_sub(in306, in15);
    let t224 = circuit_mul(t217, t223);
    let t225 = circuit_sub(in306, in15);
    let t226 = circuit_mul(in9, t225);
    let t227 = circuit_inverse(t226);
    let t228 = circuit_mul(in206, t227);
    let t229 = circuit_add(t222, t228);
    let t230 = circuit_sub(in306, in16);
    let t231 = circuit_mul(t224, t230);
    let t232 = circuit_sub(in306, in16);
    let t233 = circuit_mul(in10, t232);
    let t234 = circuit_inverse(t233);
    let t235 = circuit_mul(in234, t234);
    let t236 = circuit_add(t229, t235);
    let t237 = circuit_mul(t236, t231);
    let t238 = circuit_sub(in334, in0);
    let t239 = circuit_mul(in306, t238);
    let t240 = circuit_add(in0, t239);
    let t241 = circuit_mul(t175, t240);
    let t242 = circuit_add(in39, in67);
    let t243 = circuit_sub(t242, t237);
    let t244 = circuit_mul(t243, t180);
    let t245 = circuit_add(t179, t244);
    let t246 = circuit_mul(t180, in365);
    let t247 = circuit_sub(in307, in2);
    let t248 = circuit_mul(in0, t247);
    let t249 = circuit_sub(in307, in2);
    let t250 = circuit_mul(in3, t249);
    let t251 = circuit_inverse(t250);
    let t252 = circuit_mul(in39, t251);
    let t253 = circuit_add(in2, t252);
    let t254 = circuit_sub(in307, in0);
    let t255 = circuit_mul(t248, t254);
    let t256 = circuit_sub(in307, in0);
    let t257 = circuit_mul(in4, t256);
    let t258 = circuit_inverse(t257);
    let t259 = circuit_mul(in67, t258);
    let t260 = circuit_add(t253, t259);
    let t261 = circuit_sub(in307, in11);
    let t262 = circuit_mul(t255, t261);
    let t263 = circuit_sub(in307, in11);
    let t264 = circuit_mul(in5, t263);
    let t265 = circuit_inverse(t264);
    let t266 = circuit_mul(in95, t265);
    let t267 = circuit_add(t260, t266);
    let t268 = circuit_sub(in307, in12);
    let t269 = circuit_mul(t262, t268);
    let t270 = circuit_sub(in307, in12);
    let t271 = circuit_mul(in6, t270);
    let t272 = circuit_inverse(t271);
    let t273 = circuit_mul(in123, t272);
    let t274 = circuit_add(t267, t273);
    let t275 = circuit_sub(in307, in13);
    let t276 = circuit_mul(t269, t275);
    let t277 = circuit_sub(in307, in13);
    let t278 = circuit_mul(in7, t277);
    let t279 = circuit_inverse(t278);
    let t280 = circuit_mul(in151, t279);
    let t281 = circuit_add(t274, t280);
    let t282 = circuit_sub(in307, in14);
    let t283 = circuit_mul(t276, t282);
    let t284 = circuit_sub(in307, in14);
    let t285 = circuit_mul(in8, t284);
    let t286 = circuit_inverse(t285);
    let t287 = circuit_mul(in179, t286);
    let t288 = circuit_add(t281, t287);
    let t289 = circuit_sub(in307, in15);
    let t290 = circuit_mul(t283, t289);
    let t291 = circuit_sub(in307, in15);
    let t292 = circuit_mul(in9, t291);
    let t293 = circuit_inverse(t292);
    let t294 = circuit_mul(in207, t293);
    let t295 = circuit_add(t288, t294);
    let t296 = circuit_sub(in307, in16);
    let t297 = circuit_mul(t290, t296);
    let t298 = circuit_sub(in307, in16);
    let t299 = circuit_mul(in10, t298);
    let t300 = circuit_inverse(t299);
    let t301 = circuit_mul(in235, t300);
    let t302 = circuit_add(t295, t301);
    let t303 = circuit_mul(t302, t297);
    let t304 = circuit_sub(in335, in0);
    let t305 = circuit_mul(in307, t304);
    let t306 = circuit_add(in0, t305);
    let t307 = circuit_mul(t241, t306);
    let t308 = circuit_add(in40, in68);
    let t309 = circuit_sub(t308, t303);
    let t310 = circuit_mul(t309, t246);
    let t311 = circuit_add(t245, t310);
    let t312 = circuit_mul(t246, in365);
    let t313 = circuit_sub(in308, in2);
    let t314 = circuit_mul(in0, t313);
    let t315 = circuit_sub(in308, in2);
    let t316 = circuit_mul(in3, t315);
    let t317 = circuit_inverse(t316);
    let t318 = circuit_mul(in40, t317);
    let t319 = circuit_add(in2, t318);
    let t320 = circuit_sub(in308, in0);
    let t321 = circuit_mul(t314, t320);
    let t322 = circuit_sub(in308, in0);
    let t323 = circuit_mul(in4, t322);
    let t324 = circuit_inverse(t323);
    let t325 = circuit_mul(in68, t324);
    let t326 = circuit_add(t319, t325);
    let t327 = circuit_sub(in308, in11);
    let t328 = circuit_mul(t321, t327);
    let t329 = circuit_sub(in308, in11);
    let t330 = circuit_mul(in5, t329);
    let t331 = circuit_inverse(t330);
    let t332 = circuit_mul(in96, t331);
    let t333 = circuit_add(t326, t332);
    let t334 = circuit_sub(in308, in12);
    let t335 = circuit_mul(t328, t334);
    let t336 = circuit_sub(in308, in12);
    let t337 = circuit_mul(in6, t336);
    let t338 = circuit_inverse(t337);
    let t339 = circuit_mul(in124, t338);
    let t340 = circuit_add(t333, t339);
    let t341 = circuit_sub(in308, in13);
    let t342 = circuit_mul(t335, t341);
    let t343 = circuit_sub(in308, in13);
    let t344 = circuit_mul(in7, t343);
    let t345 = circuit_inverse(t344);
    let t346 = circuit_mul(in152, t345);
    let t347 = circuit_add(t340, t346);
    let t348 = circuit_sub(in308, in14);
    let t349 = circuit_mul(t342, t348);
    let t350 = circuit_sub(in308, in14);
    let t351 = circuit_mul(in8, t350);
    let t352 = circuit_inverse(t351);
    let t353 = circuit_mul(in180, t352);
    let t354 = circuit_add(t347, t353);
    let t355 = circuit_sub(in308, in15);
    let t356 = circuit_mul(t349, t355);
    let t357 = circuit_sub(in308, in15);
    let t358 = circuit_mul(in9, t357);
    let t359 = circuit_inverse(t358);
    let t360 = circuit_mul(in208, t359);
    let t361 = circuit_add(t354, t360);
    let t362 = circuit_sub(in308, in16);
    let t363 = circuit_mul(t356, t362);
    let t364 = circuit_sub(in308, in16);
    let t365 = circuit_mul(in10, t364);
    let t366 = circuit_inverse(t365);
    let t367 = circuit_mul(in236, t366);
    let t368 = circuit_add(t361, t367);
    let t369 = circuit_mul(t368, t363);
    let t370 = circuit_sub(in336, in0);
    let t371 = circuit_mul(in308, t370);
    let t372 = circuit_add(in0, t371);
    let t373 = circuit_mul(t307, t372);
    let t374 = circuit_add(in41, in69);
    let t375 = circuit_sub(t374, t369);
    let t376 = circuit_mul(t375, t312);
    let t377 = circuit_add(t311, t376);
    let t378 = circuit_mul(t312, in365);
    let t379 = circuit_sub(in309, in2);
    let t380 = circuit_mul(in0, t379);
    let t381 = circuit_sub(in309, in2);
    let t382 = circuit_mul(in3, t381);
    let t383 = circuit_inverse(t382);
    let t384 = circuit_mul(in41, t383);
    let t385 = circuit_add(in2, t384);
    let t386 = circuit_sub(in309, in0);
    let t387 = circuit_mul(t380, t386);
    let t388 = circuit_sub(in309, in0);
    let t389 = circuit_mul(in4, t388);
    let t390 = circuit_inverse(t389);
    let t391 = circuit_mul(in69, t390);
    let t392 = circuit_add(t385, t391);
    let t393 = circuit_sub(in309, in11);
    let t394 = circuit_mul(t387, t393);
    let t395 = circuit_sub(in309, in11);
    let t396 = circuit_mul(in5, t395);
    let t397 = circuit_inverse(t396);
    let t398 = circuit_mul(in97, t397);
    let t399 = circuit_add(t392, t398);
    let t400 = circuit_sub(in309, in12);
    let t401 = circuit_mul(t394, t400);
    let t402 = circuit_sub(in309, in12);
    let t403 = circuit_mul(in6, t402);
    let t404 = circuit_inverse(t403);
    let t405 = circuit_mul(in125, t404);
    let t406 = circuit_add(t399, t405);
    let t407 = circuit_sub(in309, in13);
    let t408 = circuit_mul(t401, t407);
    let t409 = circuit_sub(in309, in13);
    let t410 = circuit_mul(in7, t409);
    let t411 = circuit_inverse(t410);
    let t412 = circuit_mul(in153, t411);
    let t413 = circuit_add(t406, t412);
    let t414 = circuit_sub(in309, in14);
    let t415 = circuit_mul(t408, t414);
    let t416 = circuit_sub(in309, in14);
    let t417 = circuit_mul(in8, t416);
    let t418 = circuit_inverse(t417);
    let t419 = circuit_mul(in181, t418);
    let t420 = circuit_add(t413, t419);
    let t421 = circuit_sub(in309, in15);
    let t422 = circuit_mul(t415, t421);
    let t423 = circuit_sub(in309, in15);
    let t424 = circuit_mul(in9, t423);
    let t425 = circuit_inverse(t424);
    let t426 = circuit_mul(in209, t425);
    let t427 = circuit_add(t420, t426);
    let t428 = circuit_sub(in309, in16);
    let t429 = circuit_mul(t422, t428);
    let t430 = circuit_sub(in309, in16);
    let t431 = circuit_mul(in10, t430);
    let t432 = circuit_inverse(t431);
    let t433 = circuit_mul(in237, t432);
    let t434 = circuit_add(t427, t433);
    let t435 = circuit_mul(t434, t429);
    let t436 = circuit_sub(in337, in0);
    let t437 = circuit_mul(in309, t436);
    let t438 = circuit_add(in0, t437);
    let t439 = circuit_mul(t373, t438);
    let t440 = circuit_add(in42, in70);
    let t441 = circuit_sub(t440, t435);
    let t442 = circuit_mul(t441, t378);
    let t443 = circuit_add(t377, t442);
    let t444 = circuit_mul(t378, in365);
    let t445 = circuit_sub(in310, in2);
    let t446 = circuit_mul(in0, t445);
    let t447 = circuit_sub(in310, in2);
    let t448 = circuit_mul(in3, t447);
    let t449 = circuit_inverse(t448);
    let t450 = circuit_mul(in42, t449);
    let t451 = circuit_add(in2, t450);
    let t452 = circuit_sub(in310, in0);
    let t453 = circuit_mul(t446, t452);
    let t454 = circuit_sub(in310, in0);
    let t455 = circuit_mul(in4, t454);
    let t456 = circuit_inverse(t455);
    let t457 = circuit_mul(in70, t456);
    let t458 = circuit_add(t451, t457);
    let t459 = circuit_sub(in310, in11);
    let t460 = circuit_mul(t453, t459);
    let t461 = circuit_sub(in310, in11);
    let t462 = circuit_mul(in5, t461);
    let t463 = circuit_inverse(t462);
    let t464 = circuit_mul(in98, t463);
    let t465 = circuit_add(t458, t464);
    let t466 = circuit_sub(in310, in12);
    let t467 = circuit_mul(t460, t466);
    let t468 = circuit_sub(in310, in12);
    let t469 = circuit_mul(in6, t468);
    let t470 = circuit_inverse(t469);
    let t471 = circuit_mul(in126, t470);
    let t472 = circuit_add(t465, t471);
    let t473 = circuit_sub(in310, in13);
    let t474 = circuit_mul(t467, t473);
    let t475 = circuit_sub(in310, in13);
    let t476 = circuit_mul(in7, t475);
    let t477 = circuit_inverse(t476);
    let t478 = circuit_mul(in154, t477);
    let t479 = circuit_add(t472, t478);
    let t480 = circuit_sub(in310, in14);
    let t481 = circuit_mul(t474, t480);
    let t482 = circuit_sub(in310, in14);
    let t483 = circuit_mul(in8, t482);
    let t484 = circuit_inverse(t483);
    let t485 = circuit_mul(in182, t484);
    let t486 = circuit_add(t479, t485);
    let t487 = circuit_sub(in310, in15);
    let t488 = circuit_mul(t481, t487);
    let t489 = circuit_sub(in310, in15);
    let t490 = circuit_mul(in9, t489);
    let t491 = circuit_inverse(t490);
    let t492 = circuit_mul(in210, t491);
    let t493 = circuit_add(t486, t492);
    let t494 = circuit_sub(in310, in16);
    let t495 = circuit_mul(t488, t494);
    let t496 = circuit_sub(in310, in16);
    let t497 = circuit_mul(in10, t496);
    let t498 = circuit_inverse(t497);
    let t499 = circuit_mul(in238, t498);
    let t500 = circuit_add(t493, t499);
    let t501 = circuit_mul(t500, t495);
    let t502 = circuit_sub(in338, in0);
    let t503 = circuit_mul(in310, t502);
    let t504 = circuit_add(in0, t503);
    let t505 = circuit_mul(t439, t504);
    let t506 = circuit_add(in43, in71);
    let t507 = circuit_sub(t506, t501);
    let t508 = circuit_mul(t507, t444);
    let t509 = circuit_add(t443, t508);
    let t510 = circuit_mul(t444, in365);
    let t511 = circuit_sub(in311, in2);
    let t512 = circuit_mul(in0, t511);
    let t513 = circuit_sub(in311, in2);
    let t514 = circuit_mul(in3, t513);
    let t515 = circuit_inverse(t514);
    let t516 = circuit_mul(in43, t515);
    let t517 = circuit_add(in2, t516);
    let t518 = circuit_sub(in311, in0);
    let t519 = circuit_mul(t512, t518);
    let t520 = circuit_sub(in311, in0);
    let t521 = circuit_mul(in4, t520);
    let t522 = circuit_inverse(t521);
    let t523 = circuit_mul(in71, t522);
    let t524 = circuit_add(t517, t523);
    let t525 = circuit_sub(in311, in11);
    let t526 = circuit_mul(t519, t525);
    let t527 = circuit_sub(in311, in11);
    let t528 = circuit_mul(in5, t527);
    let t529 = circuit_inverse(t528);
    let t530 = circuit_mul(in99, t529);
    let t531 = circuit_add(t524, t530);
    let t532 = circuit_sub(in311, in12);
    let t533 = circuit_mul(t526, t532);
    let t534 = circuit_sub(in311, in12);
    let t535 = circuit_mul(in6, t534);
    let t536 = circuit_inverse(t535);
    let t537 = circuit_mul(in127, t536);
    let t538 = circuit_add(t531, t537);
    let t539 = circuit_sub(in311, in13);
    let t540 = circuit_mul(t533, t539);
    let t541 = circuit_sub(in311, in13);
    let t542 = circuit_mul(in7, t541);
    let t543 = circuit_inverse(t542);
    let t544 = circuit_mul(in155, t543);
    let t545 = circuit_add(t538, t544);
    let t546 = circuit_sub(in311, in14);
    let t547 = circuit_mul(t540, t546);
    let t548 = circuit_sub(in311, in14);
    let t549 = circuit_mul(in8, t548);
    let t550 = circuit_inverse(t549);
    let t551 = circuit_mul(in183, t550);
    let t552 = circuit_add(t545, t551);
    let t553 = circuit_sub(in311, in15);
    let t554 = circuit_mul(t547, t553);
    let t555 = circuit_sub(in311, in15);
    let t556 = circuit_mul(in9, t555);
    let t557 = circuit_inverse(t556);
    let t558 = circuit_mul(in211, t557);
    let t559 = circuit_add(t552, t558);
    let t560 = circuit_sub(in311, in16);
    let t561 = circuit_mul(t554, t560);
    let t562 = circuit_sub(in311, in16);
    let t563 = circuit_mul(in10, t562);
    let t564 = circuit_inverse(t563);
    let t565 = circuit_mul(in239, t564);
    let t566 = circuit_add(t559, t565);
    let t567 = circuit_mul(t566, t561);
    let t568 = circuit_sub(in339, in0);
    let t569 = circuit_mul(in311, t568);
    let t570 = circuit_add(in0, t569);
    let t571 = circuit_mul(t505, t570);
    let t572 = circuit_add(in44, in72);
    let t573 = circuit_sub(t572, t567);
    let t574 = circuit_mul(t573, t510);
    let t575 = circuit_add(t509, t574);
    let t576 = circuit_mul(t510, in365);
    let t577 = circuit_sub(in312, in2);
    let t578 = circuit_mul(in0, t577);
    let t579 = circuit_sub(in312, in2);
    let t580 = circuit_mul(in3, t579);
    let t581 = circuit_inverse(t580);
    let t582 = circuit_mul(in44, t581);
    let t583 = circuit_add(in2, t582);
    let t584 = circuit_sub(in312, in0);
    let t585 = circuit_mul(t578, t584);
    let t586 = circuit_sub(in312, in0);
    let t587 = circuit_mul(in4, t586);
    let t588 = circuit_inverse(t587);
    let t589 = circuit_mul(in72, t588);
    let t590 = circuit_add(t583, t589);
    let t591 = circuit_sub(in312, in11);
    let t592 = circuit_mul(t585, t591);
    let t593 = circuit_sub(in312, in11);
    let t594 = circuit_mul(in5, t593);
    let t595 = circuit_inverse(t594);
    let t596 = circuit_mul(in100, t595);
    let t597 = circuit_add(t590, t596);
    let t598 = circuit_sub(in312, in12);
    let t599 = circuit_mul(t592, t598);
    let t600 = circuit_sub(in312, in12);
    let t601 = circuit_mul(in6, t600);
    let t602 = circuit_inverse(t601);
    let t603 = circuit_mul(in128, t602);
    let t604 = circuit_add(t597, t603);
    let t605 = circuit_sub(in312, in13);
    let t606 = circuit_mul(t599, t605);
    let t607 = circuit_sub(in312, in13);
    let t608 = circuit_mul(in7, t607);
    let t609 = circuit_inverse(t608);
    let t610 = circuit_mul(in156, t609);
    let t611 = circuit_add(t604, t610);
    let t612 = circuit_sub(in312, in14);
    let t613 = circuit_mul(t606, t612);
    let t614 = circuit_sub(in312, in14);
    let t615 = circuit_mul(in8, t614);
    let t616 = circuit_inverse(t615);
    let t617 = circuit_mul(in184, t616);
    let t618 = circuit_add(t611, t617);
    let t619 = circuit_sub(in312, in15);
    let t620 = circuit_mul(t613, t619);
    let t621 = circuit_sub(in312, in15);
    let t622 = circuit_mul(in9, t621);
    let t623 = circuit_inverse(t622);
    let t624 = circuit_mul(in212, t623);
    let t625 = circuit_add(t618, t624);
    let t626 = circuit_sub(in312, in16);
    let t627 = circuit_mul(t620, t626);
    let t628 = circuit_sub(in312, in16);
    let t629 = circuit_mul(in10, t628);
    let t630 = circuit_inverse(t629);
    let t631 = circuit_mul(in240, t630);
    let t632 = circuit_add(t625, t631);
    let t633 = circuit_mul(t632, t627);
    let t634 = circuit_sub(in340, in0);
    let t635 = circuit_mul(in312, t634);
    let t636 = circuit_add(in0, t635);
    let t637 = circuit_mul(t571, t636);
    let t638 = circuit_add(in45, in73);
    let t639 = circuit_sub(t638, t633);
    let t640 = circuit_mul(t639, t576);
    let t641 = circuit_add(t575, t640);
    let t642 = circuit_mul(t576, in365);
    let t643 = circuit_sub(in313, in2);
    let t644 = circuit_mul(in0, t643);
    let t645 = circuit_sub(in313, in2);
    let t646 = circuit_mul(in3, t645);
    let t647 = circuit_inverse(t646);
    let t648 = circuit_mul(in45, t647);
    let t649 = circuit_add(in2, t648);
    let t650 = circuit_sub(in313, in0);
    let t651 = circuit_mul(t644, t650);
    let t652 = circuit_sub(in313, in0);
    let t653 = circuit_mul(in4, t652);
    let t654 = circuit_inverse(t653);
    let t655 = circuit_mul(in73, t654);
    let t656 = circuit_add(t649, t655);
    let t657 = circuit_sub(in313, in11);
    let t658 = circuit_mul(t651, t657);
    let t659 = circuit_sub(in313, in11);
    let t660 = circuit_mul(in5, t659);
    let t661 = circuit_inverse(t660);
    let t662 = circuit_mul(in101, t661);
    let t663 = circuit_add(t656, t662);
    let t664 = circuit_sub(in313, in12);
    let t665 = circuit_mul(t658, t664);
    let t666 = circuit_sub(in313, in12);
    let t667 = circuit_mul(in6, t666);
    let t668 = circuit_inverse(t667);
    let t669 = circuit_mul(in129, t668);
    let t670 = circuit_add(t663, t669);
    let t671 = circuit_sub(in313, in13);
    let t672 = circuit_mul(t665, t671);
    let t673 = circuit_sub(in313, in13);
    let t674 = circuit_mul(in7, t673);
    let t675 = circuit_inverse(t674);
    let t676 = circuit_mul(in157, t675);
    let t677 = circuit_add(t670, t676);
    let t678 = circuit_sub(in313, in14);
    let t679 = circuit_mul(t672, t678);
    let t680 = circuit_sub(in313, in14);
    let t681 = circuit_mul(in8, t680);
    let t682 = circuit_inverse(t681);
    let t683 = circuit_mul(in185, t682);
    let t684 = circuit_add(t677, t683);
    let t685 = circuit_sub(in313, in15);
    let t686 = circuit_mul(t679, t685);
    let t687 = circuit_sub(in313, in15);
    let t688 = circuit_mul(in9, t687);
    let t689 = circuit_inverse(t688);
    let t690 = circuit_mul(in213, t689);
    let t691 = circuit_add(t684, t690);
    let t692 = circuit_sub(in313, in16);
    let t693 = circuit_mul(t686, t692);
    let t694 = circuit_sub(in313, in16);
    let t695 = circuit_mul(in10, t694);
    let t696 = circuit_inverse(t695);
    let t697 = circuit_mul(in241, t696);
    let t698 = circuit_add(t691, t697);
    let t699 = circuit_mul(t698, t693);
    let t700 = circuit_sub(in341, in0);
    let t701 = circuit_mul(in313, t700);
    let t702 = circuit_add(in0, t701);
    let t703 = circuit_mul(t637, t702);
    let t704 = circuit_add(in46, in74);
    let t705 = circuit_sub(t704, t699);
    let t706 = circuit_mul(t705, t642);
    let t707 = circuit_add(t641, t706);
    let t708 = circuit_mul(t642, in365);
    let t709 = circuit_sub(in314, in2);
    let t710 = circuit_mul(in0, t709);
    let t711 = circuit_sub(in314, in2);
    let t712 = circuit_mul(in3, t711);
    let t713 = circuit_inverse(t712);
    let t714 = circuit_mul(in46, t713);
    let t715 = circuit_add(in2, t714);
    let t716 = circuit_sub(in314, in0);
    let t717 = circuit_mul(t710, t716);
    let t718 = circuit_sub(in314, in0);
    let t719 = circuit_mul(in4, t718);
    let t720 = circuit_inverse(t719);
    let t721 = circuit_mul(in74, t720);
    let t722 = circuit_add(t715, t721);
    let t723 = circuit_sub(in314, in11);
    let t724 = circuit_mul(t717, t723);
    let t725 = circuit_sub(in314, in11);
    let t726 = circuit_mul(in5, t725);
    let t727 = circuit_inverse(t726);
    let t728 = circuit_mul(in102, t727);
    let t729 = circuit_add(t722, t728);
    let t730 = circuit_sub(in314, in12);
    let t731 = circuit_mul(t724, t730);
    let t732 = circuit_sub(in314, in12);
    let t733 = circuit_mul(in6, t732);
    let t734 = circuit_inverse(t733);
    let t735 = circuit_mul(in130, t734);
    let t736 = circuit_add(t729, t735);
    let t737 = circuit_sub(in314, in13);
    let t738 = circuit_mul(t731, t737);
    let t739 = circuit_sub(in314, in13);
    let t740 = circuit_mul(in7, t739);
    let t741 = circuit_inverse(t740);
    let t742 = circuit_mul(in158, t741);
    let t743 = circuit_add(t736, t742);
    let t744 = circuit_sub(in314, in14);
    let t745 = circuit_mul(t738, t744);
    let t746 = circuit_sub(in314, in14);
    let t747 = circuit_mul(in8, t746);
    let t748 = circuit_inverse(t747);
    let t749 = circuit_mul(in186, t748);
    let t750 = circuit_add(t743, t749);
    let t751 = circuit_sub(in314, in15);
    let t752 = circuit_mul(t745, t751);
    let t753 = circuit_sub(in314, in15);
    let t754 = circuit_mul(in9, t753);
    let t755 = circuit_inverse(t754);
    let t756 = circuit_mul(in214, t755);
    let t757 = circuit_add(t750, t756);
    let t758 = circuit_sub(in314, in16);
    let t759 = circuit_mul(t752, t758);
    let t760 = circuit_sub(in314, in16);
    let t761 = circuit_mul(in10, t760);
    let t762 = circuit_inverse(t761);
    let t763 = circuit_mul(in242, t762);
    let t764 = circuit_add(t757, t763);
    let t765 = circuit_mul(t764, t759);
    let t766 = circuit_sub(in342, in0);
    let t767 = circuit_mul(in314, t766);
    let t768 = circuit_add(in0, t767);
    let t769 = circuit_mul(t703, t768);
    let t770 = circuit_add(in47, in75);
    let t771 = circuit_sub(t770, t765);
    let t772 = circuit_mul(t771, t708);
    let t773 = circuit_add(t707, t772);
    let t774 = circuit_mul(t708, in365);
    let t775 = circuit_sub(in315, in2);
    let t776 = circuit_mul(in0, t775);
    let t777 = circuit_sub(in315, in2);
    let t778 = circuit_mul(in3, t777);
    let t779 = circuit_inverse(t778);
    let t780 = circuit_mul(in47, t779);
    let t781 = circuit_add(in2, t780);
    let t782 = circuit_sub(in315, in0);
    let t783 = circuit_mul(t776, t782);
    let t784 = circuit_sub(in315, in0);
    let t785 = circuit_mul(in4, t784);
    let t786 = circuit_inverse(t785);
    let t787 = circuit_mul(in75, t786);
    let t788 = circuit_add(t781, t787);
    let t789 = circuit_sub(in315, in11);
    let t790 = circuit_mul(t783, t789);
    let t791 = circuit_sub(in315, in11);
    let t792 = circuit_mul(in5, t791);
    let t793 = circuit_inverse(t792);
    let t794 = circuit_mul(in103, t793);
    let t795 = circuit_add(t788, t794);
    let t796 = circuit_sub(in315, in12);
    let t797 = circuit_mul(t790, t796);
    let t798 = circuit_sub(in315, in12);
    let t799 = circuit_mul(in6, t798);
    let t800 = circuit_inverse(t799);
    let t801 = circuit_mul(in131, t800);
    let t802 = circuit_add(t795, t801);
    let t803 = circuit_sub(in315, in13);
    let t804 = circuit_mul(t797, t803);
    let t805 = circuit_sub(in315, in13);
    let t806 = circuit_mul(in7, t805);
    let t807 = circuit_inverse(t806);
    let t808 = circuit_mul(in159, t807);
    let t809 = circuit_add(t802, t808);
    let t810 = circuit_sub(in315, in14);
    let t811 = circuit_mul(t804, t810);
    let t812 = circuit_sub(in315, in14);
    let t813 = circuit_mul(in8, t812);
    let t814 = circuit_inverse(t813);
    let t815 = circuit_mul(in187, t814);
    let t816 = circuit_add(t809, t815);
    let t817 = circuit_sub(in315, in15);
    let t818 = circuit_mul(t811, t817);
    let t819 = circuit_sub(in315, in15);
    let t820 = circuit_mul(in9, t819);
    let t821 = circuit_inverse(t820);
    let t822 = circuit_mul(in215, t821);
    let t823 = circuit_add(t816, t822);
    let t824 = circuit_sub(in315, in16);
    let t825 = circuit_mul(t818, t824);
    let t826 = circuit_sub(in315, in16);
    let t827 = circuit_mul(in10, t826);
    let t828 = circuit_inverse(t827);
    let t829 = circuit_mul(in243, t828);
    let t830 = circuit_add(t823, t829);
    let t831 = circuit_mul(t830, t825);
    let t832 = circuit_sub(in343, in0);
    let t833 = circuit_mul(in315, t832);
    let t834 = circuit_add(in0, t833);
    let t835 = circuit_mul(t769, t834);
    let t836 = circuit_add(in48, in76);
    let t837 = circuit_sub(t836, t831);
    let t838 = circuit_mul(t837, t774);
    let t839 = circuit_add(t773, t838);
    let t840 = circuit_mul(t774, in365);
    let t841 = circuit_sub(in316, in2);
    let t842 = circuit_mul(in0, t841);
    let t843 = circuit_sub(in316, in2);
    let t844 = circuit_mul(in3, t843);
    let t845 = circuit_inverse(t844);
    let t846 = circuit_mul(in48, t845);
    let t847 = circuit_add(in2, t846);
    let t848 = circuit_sub(in316, in0);
    let t849 = circuit_mul(t842, t848);
    let t850 = circuit_sub(in316, in0);
    let t851 = circuit_mul(in4, t850);
    let t852 = circuit_inverse(t851);
    let t853 = circuit_mul(in76, t852);
    let t854 = circuit_add(t847, t853);
    let t855 = circuit_sub(in316, in11);
    let t856 = circuit_mul(t849, t855);
    let t857 = circuit_sub(in316, in11);
    let t858 = circuit_mul(in5, t857);
    let t859 = circuit_inverse(t858);
    let t860 = circuit_mul(in104, t859);
    let t861 = circuit_add(t854, t860);
    let t862 = circuit_sub(in316, in12);
    let t863 = circuit_mul(t856, t862);
    let t864 = circuit_sub(in316, in12);
    let t865 = circuit_mul(in6, t864);
    let t866 = circuit_inverse(t865);
    let t867 = circuit_mul(in132, t866);
    let t868 = circuit_add(t861, t867);
    let t869 = circuit_sub(in316, in13);
    let t870 = circuit_mul(t863, t869);
    let t871 = circuit_sub(in316, in13);
    let t872 = circuit_mul(in7, t871);
    let t873 = circuit_inverse(t872);
    let t874 = circuit_mul(in160, t873);
    let t875 = circuit_add(t868, t874);
    let t876 = circuit_sub(in316, in14);
    let t877 = circuit_mul(t870, t876);
    let t878 = circuit_sub(in316, in14);
    let t879 = circuit_mul(in8, t878);
    let t880 = circuit_inverse(t879);
    let t881 = circuit_mul(in188, t880);
    let t882 = circuit_add(t875, t881);
    let t883 = circuit_sub(in316, in15);
    let t884 = circuit_mul(t877, t883);
    let t885 = circuit_sub(in316, in15);
    let t886 = circuit_mul(in9, t885);
    let t887 = circuit_inverse(t886);
    let t888 = circuit_mul(in216, t887);
    let t889 = circuit_add(t882, t888);
    let t890 = circuit_sub(in316, in16);
    let t891 = circuit_mul(t884, t890);
    let t892 = circuit_sub(in316, in16);
    let t893 = circuit_mul(in10, t892);
    let t894 = circuit_inverse(t893);
    let t895 = circuit_mul(in244, t894);
    let t896 = circuit_add(t889, t895);
    let t897 = circuit_mul(t896, t891);
    let t898 = circuit_sub(in344, in0);
    let t899 = circuit_mul(in316, t898);
    let t900 = circuit_add(in0, t899);
    let t901 = circuit_mul(t835, t900);
    let t902 = circuit_add(in49, in77);
    let t903 = circuit_sub(t902, t897);
    let t904 = circuit_mul(t903, t840);
    let t905 = circuit_add(t839, t904);
    let t906 = circuit_mul(t840, in365);
    let t907 = circuit_sub(in317, in2);
    let t908 = circuit_mul(in0, t907);
    let t909 = circuit_sub(in317, in2);
    let t910 = circuit_mul(in3, t909);
    let t911 = circuit_inverse(t910);
    let t912 = circuit_mul(in49, t911);
    let t913 = circuit_add(in2, t912);
    let t914 = circuit_sub(in317, in0);
    let t915 = circuit_mul(t908, t914);
    let t916 = circuit_sub(in317, in0);
    let t917 = circuit_mul(in4, t916);
    let t918 = circuit_inverse(t917);
    let t919 = circuit_mul(in77, t918);
    let t920 = circuit_add(t913, t919);
    let t921 = circuit_sub(in317, in11);
    let t922 = circuit_mul(t915, t921);
    let t923 = circuit_sub(in317, in11);
    let t924 = circuit_mul(in5, t923);
    let t925 = circuit_inverse(t924);
    let t926 = circuit_mul(in105, t925);
    let t927 = circuit_add(t920, t926);
    let t928 = circuit_sub(in317, in12);
    let t929 = circuit_mul(t922, t928);
    let t930 = circuit_sub(in317, in12);
    let t931 = circuit_mul(in6, t930);
    let t932 = circuit_inverse(t931);
    let t933 = circuit_mul(in133, t932);
    let t934 = circuit_add(t927, t933);
    let t935 = circuit_sub(in317, in13);
    let t936 = circuit_mul(t929, t935);
    let t937 = circuit_sub(in317, in13);
    let t938 = circuit_mul(in7, t937);
    let t939 = circuit_inverse(t938);
    let t940 = circuit_mul(in161, t939);
    let t941 = circuit_add(t934, t940);
    let t942 = circuit_sub(in317, in14);
    let t943 = circuit_mul(t936, t942);
    let t944 = circuit_sub(in317, in14);
    let t945 = circuit_mul(in8, t944);
    let t946 = circuit_inverse(t945);
    let t947 = circuit_mul(in189, t946);
    let t948 = circuit_add(t941, t947);
    let t949 = circuit_sub(in317, in15);
    let t950 = circuit_mul(t943, t949);
    let t951 = circuit_sub(in317, in15);
    let t952 = circuit_mul(in9, t951);
    let t953 = circuit_inverse(t952);
    let t954 = circuit_mul(in217, t953);
    let t955 = circuit_add(t948, t954);
    let t956 = circuit_sub(in317, in16);
    let t957 = circuit_mul(t950, t956);
    let t958 = circuit_sub(in317, in16);
    let t959 = circuit_mul(in10, t958);
    let t960 = circuit_inverse(t959);
    let t961 = circuit_mul(in245, t960);
    let t962 = circuit_add(t955, t961);
    let t963 = circuit_mul(t962, t957);
    let t964 = circuit_sub(in345, in0);
    let t965 = circuit_mul(in317, t964);
    let t966 = circuit_add(in0, t965);
    let t967 = circuit_mul(t901, t966);
    let t968 = circuit_add(in50, in78);
    let t969 = circuit_sub(t968, t963);
    let t970 = circuit_mul(t969, t906);
    let t971 = circuit_add(t905, t970);
    let t972 = circuit_mul(t906, in365);
    let t973 = circuit_sub(in318, in2);
    let t974 = circuit_mul(in0, t973);
    let t975 = circuit_sub(in318, in2);
    let t976 = circuit_mul(in3, t975);
    let t977 = circuit_inverse(t976);
    let t978 = circuit_mul(in50, t977);
    let t979 = circuit_add(in2, t978);
    let t980 = circuit_sub(in318, in0);
    let t981 = circuit_mul(t974, t980);
    let t982 = circuit_sub(in318, in0);
    let t983 = circuit_mul(in4, t982);
    let t984 = circuit_inverse(t983);
    let t985 = circuit_mul(in78, t984);
    let t986 = circuit_add(t979, t985);
    let t987 = circuit_sub(in318, in11);
    let t988 = circuit_mul(t981, t987);
    let t989 = circuit_sub(in318, in11);
    let t990 = circuit_mul(in5, t989);
    let t991 = circuit_inverse(t990);
    let t992 = circuit_mul(in106, t991);
    let t993 = circuit_add(t986, t992);
    let t994 = circuit_sub(in318, in12);
    let t995 = circuit_mul(t988, t994);
    let t996 = circuit_sub(in318, in12);
    let t997 = circuit_mul(in6, t996);
    let t998 = circuit_inverse(t997);
    let t999 = circuit_mul(in134, t998);
    let t1000 = circuit_add(t993, t999);
    let t1001 = circuit_sub(in318, in13);
    let t1002 = circuit_mul(t995, t1001);
    let t1003 = circuit_sub(in318, in13);
    let t1004 = circuit_mul(in7, t1003);
    let t1005 = circuit_inverse(t1004);
    let t1006 = circuit_mul(in162, t1005);
    let t1007 = circuit_add(t1000, t1006);
    let t1008 = circuit_sub(in318, in14);
    let t1009 = circuit_mul(t1002, t1008);
    let t1010 = circuit_sub(in318, in14);
    let t1011 = circuit_mul(in8, t1010);
    let t1012 = circuit_inverse(t1011);
    let t1013 = circuit_mul(in190, t1012);
    let t1014 = circuit_add(t1007, t1013);
    let t1015 = circuit_sub(in318, in15);
    let t1016 = circuit_mul(t1009, t1015);
    let t1017 = circuit_sub(in318, in15);
    let t1018 = circuit_mul(in9, t1017);
    let t1019 = circuit_inverse(t1018);
    let t1020 = circuit_mul(in218, t1019);
    let t1021 = circuit_add(t1014, t1020);
    let t1022 = circuit_sub(in318, in16);
    let t1023 = circuit_mul(t1016, t1022);
    let t1024 = circuit_sub(in318, in16);
    let t1025 = circuit_mul(in10, t1024);
    let t1026 = circuit_inverse(t1025);
    let t1027 = circuit_mul(in246, t1026);
    let t1028 = circuit_add(t1021, t1027);
    let t1029 = circuit_mul(t1028, t1023);
    let t1030 = circuit_sub(in346, in0);
    let t1031 = circuit_mul(in318, t1030);
    let t1032 = circuit_add(in0, t1031);
    let t1033 = circuit_mul(t967, t1032);
    let t1034 = circuit_add(in51, in79);
    let t1035 = circuit_sub(t1034, t1029);
    let t1036 = circuit_mul(t1035, t972);
    let t1037 = circuit_add(t971, t1036);
    let t1038 = circuit_mul(t972, in365);
    let t1039 = circuit_sub(in319, in2);
    let t1040 = circuit_mul(in0, t1039);
    let t1041 = circuit_sub(in319, in2);
    let t1042 = circuit_mul(in3, t1041);
    let t1043 = circuit_inverse(t1042);
    let t1044 = circuit_mul(in51, t1043);
    let t1045 = circuit_add(in2, t1044);
    let t1046 = circuit_sub(in319, in0);
    let t1047 = circuit_mul(t1040, t1046);
    let t1048 = circuit_sub(in319, in0);
    let t1049 = circuit_mul(in4, t1048);
    let t1050 = circuit_inverse(t1049);
    let t1051 = circuit_mul(in79, t1050);
    let t1052 = circuit_add(t1045, t1051);
    let t1053 = circuit_sub(in319, in11);
    let t1054 = circuit_mul(t1047, t1053);
    let t1055 = circuit_sub(in319, in11);
    let t1056 = circuit_mul(in5, t1055);
    let t1057 = circuit_inverse(t1056);
    let t1058 = circuit_mul(in107, t1057);
    let t1059 = circuit_add(t1052, t1058);
    let t1060 = circuit_sub(in319, in12);
    let t1061 = circuit_mul(t1054, t1060);
    let t1062 = circuit_sub(in319, in12);
    let t1063 = circuit_mul(in6, t1062);
    let t1064 = circuit_inverse(t1063);
    let t1065 = circuit_mul(in135, t1064);
    let t1066 = circuit_add(t1059, t1065);
    let t1067 = circuit_sub(in319, in13);
    let t1068 = circuit_mul(t1061, t1067);
    let t1069 = circuit_sub(in319, in13);
    let t1070 = circuit_mul(in7, t1069);
    let t1071 = circuit_inverse(t1070);
    let t1072 = circuit_mul(in163, t1071);
    let t1073 = circuit_add(t1066, t1072);
    let t1074 = circuit_sub(in319, in14);
    let t1075 = circuit_mul(t1068, t1074);
    let t1076 = circuit_sub(in319, in14);
    let t1077 = circuit_mul(in8, t1076);
    let t1078 = circuit_inverse(t1077);
    let t1079 = circuit_mul(in191, t1078);
    let t1080 = circuit_add(t1073, t1079);
    let t1081 = circuit_sub(in319, in15);
    let t1082 = circuit_mul(t1075, t1081);
    let t1083 = circuit_sub(in319, in15);
    let t1084 = circuit_mul(in9, t1083);
    let t1085 = circuit_inverse(t1084);
    let t1086 = circuit_mul(in219, t1085);
    let t1087 = circuit_add(t1080, t1086);
    let t1088 = circuit_sub(in319, in16);
    let t1089 = circuit_mul(t1082, t1088);
    let t1090 = circuit_sub(in319, in16);
    let t1091 = circuit_mul(in10, t1090);
    let t1092 = circuit_inverse(t1091);
    let t1093 = circuit_mul(in247, t1092);
    let t1094 = circuit_add(t1087, t1093);
    let t1095 = circuit_mul(t1094, t1089);
    let t1096 = circuit_sub(in347, in0);
    let t1097 = circuit_mul(in319, t1096);
    let t1098 = circuit_add(in0, t1097);
    let t1099 = circuit_mul(t1033, t1098);
    let t1100 = circuit_sub(in266, in12);
    let t1101 = circuit_mul(t1100, in260);
    let t1102 = circuit_mul(t1101, in288);
    let t1103 = circuit_mul(t1102, in287);
    let t1104 = circuit_mul(t1103, in17);
    let t1105 = circuit_mul(in262, in287);
    let t1106 = circuit_mul(in263, in288);
    let t1107 = circuit_mul(in264, in289);
    let t1108 = circuit_mul(in265, in290);
    let t1109 = circuit_add(t1105, t1106);
    let t1110 = circuit_add(t1109, t1107);
    let t1111 = circuit_add(t1110, t1108);
    let t1112 = circuit_add(t1111, in261);
    let t1113 = circuit_sub(in266, in0);
    let t1114 = circuit_mul(t1113, in302);
    let t1115 = circuit_add(t1112, t1114);
    let t1116 = circuit_mul(t1115, in266);
    let t1117 = circuit_mul(t1116, t1099);
    let t1118 = circuit_add(in287, in290);
    let t1119 = circuit_add(t1118, in260);
    let t1120 = circuit_sub(t1119, in299);
    let t1121 = circuit_sub(in266, in11);
    let t1122 = circuit_mul(t1120, t1121);
    let t1123 = circuit_sub(in266, in0);
    let t1124 = circuit_mul(t1122, t1123);
    let t1125 = circuit_mul(t1124, in266);
    let t1126 = circuit_mul(t1125, t1099);
    let t1127 = circuit_mul(in277, in363);
    let t1128 = circuit_add(in287, t1127);
    let t1129 = circuit_add(t1128, in364);
    let t1130 = circuit_mul(in278, in363);
    let t1131 = circuit_add(in288, t1130);
    let t1132 = circuit_add(t1131, in364);
    let t1133 = circuit_mul(t1129, t1132);
    let t1134 = circuit_mul(in279, in363);
    let t1135 = circuit_add(in289, t1134);
    let t1136 = circuit_add(t1135, in364);
    let t1137 = circuit_mul(t1133, t1136);
    let t1138 = circuit_mul(in280, in363);
    let t1139 = circuit_add(in290, t1138);
    let t1140 = circuit_add(t1139, in364);
    let t1141 = circuit_mul(t1137, t1140);
    let t1142 = circuit_mul(in273, in363);
    let t1143 = circuit_add(in287, t1142);
    let t1144 = circuit_add(t1143, in364);
    let t1145 = circuit_mul(in274, in363);
    let t1146 = circuit_add(in288, t1145);
    let t1147 = circuit_add(t1146, in364);
    let t1148 = circuit_mul(t1144, t1147);
    let t1149 = circuit_mul(in275, in363);
    let t1150 = circuit_add(in289, t1149);
    let t1151 = circuit_add(t1150, in364);
    let t1152 = circuit_mul(t1148, t1151);
    let t1153 = circuit_mul(in276, in363);
    let t1154 = circuit_add(in290, t1153);
    let t1155 = circuit_add(t1154, in364);
    let t1156 = circuit_mul(t1152, t1155);
    let t1157 = circuit_add(in291, in285);
    let t1158 = circuit_mul(t1141, t1157);
    let t1159 = circuit_mul(in286, t43);
    let t1160 = circuit_add(in303, t1159);
    let t1161 = circuit_mul(t1156, t1160);
    let t1162 = circuit_sub(t1158, t1161);
    let t1163 = circuit_mul(t1162, t1099);
    let t1164 = circuit_mul(in286, in303);
    let t1165 = circuit_mul(t1164, t1099);
    let t1166 = circuit_mul(in282, in360);
    let t1167 = circuit_mul(in283, in361);
    let t1168 = circuit_mul(in284, in362);
    let t1169 = circuit_add(in281, in364);
    let t1170 = circuit_add(t1169, t1166);
    let t1171 = circuit_add(t1170, t1167);
    let t1172 = circuit_add(t1171, t1168);
    let t1173 = circuit_mul(in263, in299);
    let t1174 = circuit_add(in287, in364);
    let t1175 = circuit_add(t1174, t1173);
    let t1176 = circuit_mul(in260, in300);
    let t1177 = circuit_add(in288, t1176);
    let t1178 = circuit_mul(in261, in301);
    let t1179 = circuit_add(in289, t1178);
    let t1180 = circuit_mul(t1177, in360);
    let t1181 = circuit_mul(t1179, in361);
    let t1182 = circuit_mul(in264, in362);
    let t1183 = circuit_add(t1175, t1180);
    let t1184 = circuit_add(t1183, t1181);
    let t1185 = circuit_add(t1184, t1182);
    let t1186 = circuit_mul(in292, t1172);
    let t1187 = circuit_mul(in292, t1185);
    let t1188 = circuit_add(in294, in270);
    let t1189 = circuit_mul(in294, in270);
    let t1190 = circuit_sub(t1188, t1189);
    let t1191 = circuit_mul(t1185, t1172);
    let t1192 = circuit_mul(t1191, in292);
    let t1193 = circuit_sub(t1192, t1190);
    let t1194 = circuit_mul(t1193, t1099);
    let t1195 = circuit_mul(in270, t1186);
    let t1196 = circuit_mul(in293, t1187);
    let t1197 = circuit_sub(t1195, t1196);
    let t1198 = circuit_sub(in288, in287);
    let t1199 = circuit_sub(in289, in288);
    let t1200 = circuit_sub(in290, in289);
    let t1201 = circuit_sub(in299, in290);
    let t1202 = circuit_add(t1198, in18);
    let t1203 = circuit_add(t1198, in19);
    let t1204 = circuit_add(t1198, in20);
    let t1205 = circuit_mul(t1198, t1202);
    let t1206 = circuit_mul(t1205, t1203);
    let t1207 = circuit_mul(t1206, t1204);
    let t1208 = circuit_mul(t1207, in267);
    let t1209 = circuit_mul(t1208, t1099);
    let t1210 = circuit_add(t1198, in18);
    let t1211 = circuit_add(t1198, in19);
    let t1212 = circuit_add(t1198, in20);
    let t1213 = circuit_mul(t1199, t1210);
    let t1214 = circuit_mul(t1213, t1211);
    let t1215 = circuit_mul(t1214, t1212);
    let t1216 = circuit_mul(t1215, in267);
    let t1217 = circuit_mul(t1216, t1099);
    let t1218 = circuit_add(t1198, in18);
    let t1219 = circuit_add(t1198, in19);
    let t1220 = circuit_add(t1198, in20);
    let t1221 = circuit_mul(t1200, t1218);
    let t1222 = circuit_mul(t1221, t1219);
    let t1223 = circuit_mul(t1222, t1220);
    let t1224 = circuit_mul(t1223, in267);
    let t1225 = circuit_mul(t1224, t1099);
    let t1226 = circuit_add(t1198, in18);
    let t1227 = circuit_add(t1198, in19);
    let t1228 = circuit_add(t1198, in20);
    let t1229 = circuit_mul(t1201, t1226);
    let t1230 = circuit_mul(t1229, t1227);
    let t1231 = circuit_mul(t1230, t1228);
    let t1232 = circuit_mul(t1231, in267);
    let t1233 = circuit_mul(t1232, t1099);
    let t1234 = circuit_sub(in299, in288);
    let t1235 = circuit_mul(in289, in289);
    let t1236 = circuit_mul(in302, in302);
    let t1237 = circuit_mul(in289, in302);
    let t1238 = circuit_mul(t1237, in262);
    let t1239 = circuit_add(in300, in299);
    let t1240 = circuit_add(t1239, in288);
    let t1241 = circuit_mul(t1240, t1234);
    let t1242 = circuit_mul(t1241, t1234);
    let t1243 = circuit_sub(t1242, t1236);
    let t1244 = circuit_sub(t1243, t1235);
    let t1245 = circuit_add(t1244, t1238);
    let t1246 = circuit_add(t1245, t1238);
    let t1247 = circuit_sub(in0, in260);
    let t1248 = circuit_mul(t1246, t1099);
    let t1249 = circuit_mul(t1248, in268);
    let t1250 = circuit_mul(t1249, t1247);
    let t1251 = circuit_add(in289, in301);
    let t1252 = circuit_mul(in302, in262);
    let t1253 = circuit_sub(t1252, in289);
    let t1254 = circuit_mul(t1251, t1234);
    let t1255 = circuit_sub(in300, in288);
    let t1256 = circuit_mul(t1255, t1253);
    let t1257 = circuit_add(t1254, t1256);
    let t1258 = circuit_mul(t1257, t1099);
    let t1259 = circuit_mul(t1258, in268);
    let t1260 = circuit_mul(t1259, t1247);
    let t1261 = circuit_add(t1235, in21);
    let t1262 = circuit_mul(t1261, in288);
    let t1263 = circuit_add(t1235, t1235);
    let t1264 = circuit_add(t1263, t1263);
    let t1265 = circuit_mul(t1262, in22);
    let t1266 = circuit_add(in300, in288);
    let t1267 = circuit_add(t1266, in288);
    let t1268 = circuit_mul(t1267, t1264);
    let t1269 = circuit_sub(t1268, t1265);
    let t1270 = circuit_mul(t1269, t1099);
    let t1271 = circuit_mul(t1270, in268);
    let t1272 = circuit_mul(t1271, in260);
    let t1273 = circuit_add(t1250, t1272);
    let t1274 = circuit_add(in288, in288);
    let t1275 = circuit_add(t1274, in288);
    let t1276 = circuit_mul(t1275, in288);
    let t1277 = circuit_sub(in288, in300);
    let t1278 = circuit_mul(t1276, t1277);
    let t1279 = circuit_add(in289, in289);
    let t1280 = circuit_add(in289, in301);
    let t1281 = circuit_mul(t1279, t1280);
    let t1282 = circuit_sub(t1278, t1281);
    let t1283 = circuit_mul(t1282, t1099);
    let t1284 = circuit_mul(t1283, in268);
    let t1285 = circuit_mul(t1284, in260);
    let t1286 = circuit_add(t1260, t1285);
    let t1287 = circuit_mul(in287, in300);
    let t1288 = circuit_mul(in299, in288);
    let t1289 = circuit_add(t1287, t1288);
    let t1290 = circuit_mul(in287, in290);
    let t1291 = circuit_mul(in288, in289);
    let t1292 = circuit_add(t1290, t1291);
    let t1293 = circuit_sub(t1292, in301);
    let t1294 = circuit_mul(t1293, in23);
    let t1295 = circuit_sub(t1294, in302);
    let t1296 = circuit_add(t1295, t1289);
    let t1297 = circuit_mul(t1296, in265);
    let t1298 = circuit_mul(t1289, in23);
    let t1299 = circuit_mul(in299, in300);
    let t1300 = circuit_add(t1298, t1299);
    let t1301 = circuit_add(in289, in290);
    let t1302 = circuit_sub(t1300, t1301);
    let t1303 = circuit_mul(t1302, in264);
    let t1304 = circuit_add(t1300, in290);
    let t1305 = circuit_add(in301, in302);
    let t1306 = circuit_sub(t1304, t1305);
    let t1307 = circuit_mul(t1306, in260);
    let t1308 = circuit_add(t1303, t1297);
    let t1309 = circuit_add(t1308, t1307);
    let t1310 = circuit_mul(t1309, in263);
    let t1311 = circuit_mul(in300, in24);
    let t1312 = circuit_add(t1311, in299);
    let t1313 = circuit_mul(t1312, in24);
    let t1314 = circuit_add(t1313, in289);
    let t1315 = circuit_mul(t1314, in24);
    let t1316 = circuit_add(t1315, in288);
    let t1317 = circuit_mul(t1316, in24);
    let t1318 = circuit_add(t1317, in287);
    let t1319 = circuit_sub(t1318, in290);
    let t1320 = circuit_mul(t1319, in265);
    let t1321 = circuit_mul(in301, in24);
    let t1322 = circuit_add(t1321, in300);
    let t1323 = circuit_mul(t1322, in24);
    let t1324 = circuit_add(t1323, in299);
    let t1325 = circuit_mul(t1324, in24);
    let t1326 = circuit_add(t1325, in290);
    let t1327 = circuit_mul(t1326, in24);
    let t1328 = circuit_add(t1327, in289);
    let t1329 = circuit_sub(t1328, in302);
    let t1330 = circuit_mul(t1329, in260);
    let t1331 = circuit_add(t1320, t1330);
    let t1332 = circuit_mul(t1331, in264);
    let t1333 = circuit_mul(in289, in362);
    let t1334 = circuit_mul(in288, in361);
    let t1335 = circuit_mul(in287, in360);
    let t1336 = circuit_add(t1333, t1334);
    let t1337 = circuit_add(t1336, t1335);
    let t1338 = circuit_add(t1337, in261);
    let t1339 = circuit_sub(t1338, in290);
    let t1340 = circuit_sub(in299, in287);
    let t1341 = circuit_sub(in302, in290);
    let t1342 = circuit_mul(t1340, t1340);
    let t1343 = circuit_sub(t1342, t1340);
    let t1344 = circuit_sub(in2, t1340);
    let t1345 = circuit_add(t1344, in0);
    let t1346 = circuit_mul(t1345, t1341);
    let t1347 = circuit_mul(in262, in263);
    let t1348 = circuit_mul(t1347, in269);
    let t1349 = circuit_mul(t1348, t1099);
    let t1350 = circuit_mul(t1346, t1349);
    let t1351 = circuit_mul(t1343, t1349);
    let t1352 = circuit_mul(t1339, t1347);
    let t1353 = circuit_sub(in290, t1338);
    let t1354 = circuit_mul(t1353, t1353);
    let t1355 = circuit_sub(t1354, t1353);
    let t1356 = circuit_mul(in301, in362);
    let t1357 = circuit_mul(in300, in361);
    let t1358 = circuit_mul(in299, in360);
    let t1359 = circuit_add(t1356, t1357);
    let t1360 = circuit_add(t1359, t1358);
    let t1361 = circuit_sub(in302, t1360);
    let t1362 = circuit_sub(in301, in289);
    let t1363 = circuit_sub(in2, t1340);
    let t1364 = circuit_add(t1363, in0);
    let t1365 = circuit_sub(in2, t1361);
    let t1366 = circuit_add(t1365, in0);
    let t1367 = circuit_mul(t1362, t1366);
    let t1368 = circuit_mul(t1364, t1367);
    let t1369 = circuit_mul(t1361, t1361);
    let t1370 = circuit_sub(t1369, t1361);
    let t1371 = circuit_mul(in266, in269);
    let t1372 = circuit_mul(t1371, t1099);
    let t1373 = circuit_mul(t1368, t1372);
    let t1374 = circuit_mul(t1343, t1372);
    let t1375 = circuit_mul(t1370, t1372);
    let t1376 = circuit_mul(t1355, in266);
    let t1377 = circuit_sub(in300, in288);
    let t1378 = circuit_sub(in2, t1340);
    let t1379 = circuit_add(t1378, in0);
    let t1380 = circuit_mul(t1379, t1377);
    let t1381 = circuit_sub(t1380, in289);
    let t1382 = circuit_mul(t1381, in265);
    let t1383 = circuit_mul(t1382, in262);
    let t1384 = circuit_add(t1352, t1383);
    let t1385 = circuit_mul(t1339, in260);
    let t1386 = circuit_mul(t1385, in262);
    let t1387 = circuit_add(t1384, t1386);
    let t1388 = circuit_add(t1387, t1376);
    let t1389 = circuit_add(t1388, t1310);
    let t1390 = circuit_add(t1389, t1332);
    let t1391 = circuit_mul(t1390, in269);
    let t1392 = circuit_mul(t1391, t1099);
    let t1393 = circuit_add(in287, in262);
    let t1394 = circuit_add(in288, in263);
    let t1395 = circuit_add(in289, in264);
    let t1396 = circuit_add(in290, in265);
    let t1397 = circuit_mul(t1393, t1393);
    let t1398 = circuit_mul(t1397, t1397);
    let t1399 = circuit_mul(t1398, t1393);
    let t1400 = circuit_mul(t1394, t1394);
    let t1401 = circuit_mul(t1400, t1400);
    let t1402 = circuit_mul(t1401, t1394);
    let t1403 = circuit_mul(t1395, t1395);
    let t1404 = circuit_mul(t1403, t1403);
    let t1405 = circuit_mul(t1404, t1395);
    let t1406 = circuit_mul(t1396, t1396);
    let t1407 = circuit_mul(t1406, t1406);
    let t1408 = circuit_mul(t1407, t1396);
    let t1409 = circuit_add(t1399, t1402);
    let t1410 = circuit_add(t1405, t1408);
    let t1411 = circuit_add(t1402, t1402);
    let t1412 = circuit_add(t1411, t1410);
    let t1413 = circuit_add(t1408, t1408);
    let t1414 = circuit_add(t1413, t1409);
    let t1415 = circuit_add(t1410, t1410);
    let t1416 = circuit_add(t1415, t1415);
    let t1417 = circuit_add(t1416, t1414);
    let t1418 = circuit_add(t1409, t1409);
    let t1419 = circuit_add(t1418, t1418);
    let t1420 = circuit_add(t1419, t1412);
    let t1421 = circuit_add(t1414, t1420);
    let t1422 = circuit_add(t1412, t1417);
    let t1423 = circuit_mul(in271, t1099);
    let t1424 = circuit_sub(t1421, in299);
    let t1425 = circuit_mul(t1423, t1424);
    let t1426 = circuit_sub(t1420, in300);
    let t1427 = circuit_mul(t1423, t1426);
    let t1428 = circuit_sub(t1422, in301);
    let t1429 = circuit_mul(t1423, t1428);
    let t1430 = circuit_sub(t1417, in302);
    let t1431 = circuit_mul(t1423, t1430);
    let t1432 = circuit_add(in287, in262);
    let t1433 = circuit_mul(t1432, t1432);
    let t1434 = circuit_mul(t1433, t1433);
    let t1435 = circuit_mul(t1434, t1432);
    let t1436 = circuit_add(t1435, in288);
    let t1437 = circuit_add(t1436, in289);
    let t1438 = circuit_add(t1437, in290);
    let t1439 = circuit_mul(in272, t1099);
    let t1440 = circuit_mul(t1435, in25);
    let t1441 = circuit_add(t1440, t1438);
    let t1442 = circuit_sub(t1441, in299);
    let t1443 = circuit_mul(t1439, t1442);
    let t1444 = circuit_mul(in288, in26);
    let t1445 = circuit_add(t1444, t1438);
    let t1446 = circuit_sub(t1445, in300);
    let t1447 = circuit_mul(t1439, t1446);
    let t1448 = circuit_mul(in289, in27);
    let t1449 = circuit_add(t1448, t1438);
    let t1450 = circuit_sub(t1449, in301);
    let t1451 = circuit_mul(t1439, t1450);
    let t1452 = circuit_mul(in290, in28);
    let t1453 = circuit_add(t1452, t1438);
    let t1454 = circuit_sub(t1453, in302);
    let t1455 = circuit_mul(t1439, t1454);
    let t1456 = circuit_mul(t1126, in366);
    let t1457 = circuit_add(t1117, t1456);
    let t1458 = circuit_mul(t1163, in367);
    let t1459 = circuit_add(t1457, t1458);
    let t1460 = circuit_mul(t1165, in368);
    let t1461 = circuit_add(t1459, t1460);
    let t1462 = circuit_mul(t1194, in369);
    let t1463 = circuit_add(t1461, t1462);
    let t1464 = circuit_mul(t1197, in370);
    let t1465 = circuit_add(t1463, t1464);
    let t1466 = circuit_mul(t1209, in371);
    let t1467 = circuit_add(t1465, t1466);
    let t1468 = circuit_mul(t1217, in372);
    let t1469 = circuit_add(t1467, t1468);
    let t1470 = circuit_mul(t1225, in373);
    let t1471 = circuit_add(t1469, t1470);
    let t1472 = circuit_mul(t1233, in374);
    let t1473 = circuit_add(t1471, t1472);
    let t1474 = circuit_mul(t1273, in375);
    let t1475 = circuit_add(t1473, t1474);
    let t1476 = circuit_mul(t1286, in376);
    let t1477 = circuit_add(t1475, t1476);
    let t1478 = circuit_mul(t1392, in377);
    let t1479 = circuit_add(t1477, t1478);
    let t1480 = circuit_mul(t1350, in378);
    let t1481 = circuit_add(t1479, t1480);
    let t1482 = circuit_mul(t1351, in379);
    let t1483 = circuit_add(t1481, t1482);
    let t1484 = circuit_mul(t1373, in380);
    let t1485 = circuit_add(t1483, t1484);
    let t1486 = circuit_mul(t1374, in381);
    let t1487 = circuit_add(t1485, t1486);
    let t1488 = circuit_mul(t1375, in382);
    let t1489 = circuit_add(t1487, t1488);
    let t1490 = circuit_mul(t1425, in383);
    let t1491 = circuit_add(t1489, t1490);
    let t1492 = circuit_mul(t1427, in384);
    let t1493 = circuit_add(t1491, t1492);
    let t1494 = circuit_mul(t1429, in385);
    let t1495 = circuit_add(t1493, t1494);
    let t1496 = circuit_mul(t1431, in386);
    let t1497 = circuit_add(t1495, t1496);
    let t1498 = circuit_mul(t1443, in387);
    let t1499 = circuit_add(t1497, t1498);
    let t1500 = circuit_mul(t1447, in388);
    let t1501 = circuit_add(t1499, t1500);
    let t1502 = circuit_mul(t1451, in389);
    let t1503 = circuit_add(t1501, t1502);
    let t1504 = circuit_mul(t1455, in390);
    let t1505 = circuit_add(t1503, t1504);
    let t1506 = circuit_sub(t1505, t1095);

    let modulus = get_GRUMPKIN_modulus(); // GRUMPKIN prime field modulus

    let mut circuit_inputs = (t1037, t1506,).new_inputs();
    // Prefill constants:

    circuit_inputs = circuit_inputs
        .next_span(HONK_SUMCHECK_SIZE_16_PUB_6_GRUMPKIN_CONSTANTS.span()); // in0 - in28

    // Fill inputs:

    let mut p_public_inputs = p_public_inputs;
    while let Option::Some(val) = p_public_inputs.pop_front() {
        circuit_inputs = circuit_inputs.next_u288(val);
    };
    // in29 - in34
    circuit_inputs = circuit_inputs.next_2(p_public_inputs_offset); // in35

    let mut sumcheck_univariate_0 = sumcheck_univariate_0;
    while let Option::Some(val) = sumcheck_univariate_0.pop_front() {
        circuit_inputs = circuit_inputs.next_u288(val);
    };
    // in36 - in63

    let mut sumcheck_univariate_1 = sumcheck_univariate_1;
    while let Option::Some(val) = sumcheck_univariate_1.pop_front() {
        circuit_inputs = circuit_inputs.next_u288(val);
    };
    // in64 - in91

    let mut sumcheck_univariate_2 = sumcheck_univariate_2;
    while let Option::Some(val) = sumcheck_univariate_2.pop_front() {
        circuit_inputs = circuit_inputs.next_u288(val);
    };
    // in92 - in119

    let mut sumcheck_univariate_3 = sumcheck_univariate_3;
    while let Option::Some(val) = sumcheck_univariate_3.pop_front() {
        circuit_inputs = circuit_inputs.next_u288(val);
    };
    // in120 - in147

    let mut sumcheck_univariate_4 = sumcheck_univariate_4;
    while let Option::Some(val) = sumcheck_univariate_4.pop_front() {
        circuit_inputs = circuit_inputs.next_u288(val);
    };
    // in148 - in175

    let mut sumcheck_univariate_5 = sumcheck_univariate_5;
    while let Option::Some(val) = sumcheck_univariate_5.pop_front() {
        circuit_inputs = circuit_inputs.next_u288(val);
    };
    // in176 - in203

    let mut sumcheck_univariate_6 = sumcheck_univariate_6;
    while let Option::Some(val) = sumcheck_univariate_6.pop_front() {
        circuit_inputs = circuit_inputs.next_u288(val);
    };
    // in204 - in231

    let mut sumcheck_univariate_7 = sumcheck_univariate_7;
    while let Option::Some(val) = sumcheck_univariate_7.pop_front() {
        circuit_inputs = circuit_inputs.next_u288(val);
    };
    // in232 - in259

    let mut sumcheck_evaluations = sumcheck_evaluations;
    while let Option::Some(val) = sumcheck_evaluations.pop_front() {
        circuit_inputs = circuit_inputs.next_u288(val);
    };
    // in260 - in303

    let mut tp_sum_check_u_challenges = tp_sum_check_u_challenges;
    while let Option::Some(val) = tp_sum_check_u_challenges.pop_front() {
        circuit_inputs = circuit_inputs.next_u288(val);
    };
    // in304 - in331

    let mut tp_gate_challenges = tp_gate_challenges;
    while let Option::Some(val) = tp_gate_challenges.pop_front() {
        circuit_inputs = circuit_inputs.next_u288(val);
    };
    // in332 - in359
    circuit_inputs = circuit_inputs.next_2(tp_eta_1); // in360
    circuit_inputs = circuit_inputs.next_2(tp_eta_2); // in361
    circuit_inputs = circuit_inputs.next_2(tp_eta_3); // in362
    circuit_inputs = circuit_inputs.next_2(tp_beta); // in363
    circuit_inputs = circuit_inputs.next_2(tp_gamma); // in364
    circuit_inputs = circuit_inputs.next_2(tp_base_rlc); // in365

    let mut tp_alphas = tp_alphas;
    while let Option::Some(val) = tp_alphas.pop_front() {
        circuit_inputs = circuit_inputs.next_u288(val);
    };
    // in366 - in390

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let check_rlc: u384 = outputs.get_output(t1037);
    let check: u384 = outputs.get_output(t1506);
    return (check_rlc, check);
}
const HONK_SUMCHECK_SIZE_16_PUB_6_GRUMPKIN_CONSTANTS: [
    u384
    ; 29] = [
    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x10000, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 {
        limb0: 0x79b9709143e1f593efffec51,
        limb1: 0xb85045b68181585d2833e848,
        limb2: 0x30644e72e131a029,
        limb3: 0x0
    },
    u384 { limb0: 0x2d0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 {
        limb0: 0x79b9709143e1f593efffff11,
        limb1: 0xb85045b68181585d2833e848,
        limb2: 0x30644e72e131a029,
        limb3: 0x0
    },
    u384 { limb0: 0x90, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 {
        limb0: 0x79b9709143e1f593efffff71,
        limb1: 0xb85045b68181585d2833e848,
        limb2: 0x30644e72e131a029,
        limb3: 0x0
    },
    u384 { limb0: 0xf0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 {
        limb0: 0x79b9709143e1f593effffd31,
        limb1: 0xb85045b68181585d2833e848,
        limb2: 0x30644e72e131a029,
        limb3: 0x0
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
        limb3: 0x0
    },
    u384 {
        limb0: 0x79b9709143e1f593f0000000,
        limb1: 0xb85045b68181585d2833e848,
        limb2: 0x30644e72e131a029,
        limb3: 0x0
    },
    u384 {
        limb0: 0x79b9709143e1f593efffffff,
        limb1: 0xb85045b68181585d2833e848,
        limb2: 0x30644e72e131a029,
        limb3: 0x0
    },
    u384 {
        limb0: 0x79b9709143e1f593effffffe,
        limb1: 0xb85045b68181585d2833e848,
        limb2: 0x30644e72e131a029,
        limb3: 0x0
    },
    u384 { limb0: 0x11, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x9, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x100000000000000000, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x4000, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 {
        limb0: 0x29ca1d7fb56821fd19d3b6e7,
        limb1: 0x4b1e03b4bd9490c0d03f989,
        limb2: 0x10dc6e9c006ea38b,
        limb3: 0x0
    },
    u384 {
        limb0: 0xd4dd9b84a86b38cfb45a740b,
        limb1: 0x149b3d0a30b3bb599df9756,
        limb2: 0xc28145b6a44df3e,
        limb3: 0x0
    },
    u384 {
        limb0: 0x60e3596170067d00141cac15,
        limb1: 0xb2c7645a50392798b21f75bb,
        limb2: 0x544b8338791518,
        limb3: 0x0
    },
    u384 {
        limb0: 0xb8fa852613bc534433ee428b,
        limb1: 0x2e2e82eb122789e352e105a3,
        limb2: 0x222c01175718386f,
        limb3: 0x0
    }
];

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

    use super::{run_GRUMPKIN_HONK_SUMCHECK_SIZE_16_PUB_6_circuit};
}
