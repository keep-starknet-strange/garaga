use core::circuit::{
    CircuitElement as CE, CircuitInput as CI, CircuitInputs, CircuitOutputsTrait, EvalCircuitTrait,
    circuit_add, circuit_inverse, circuit_mul, circuit_sub, u384,
};
use garaga::core::circuit::{AddInputResultTrait2, u288IntoCircuitInputValue};
use garaga::definitions::RSA2048Chunks;

pub fn run_RSA_BATCHED_SQUARING_circuit(
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
    step: u384,
    prev_res: u384,
    mod_res: u384,
    modulus: core::circuit::CircuitModulus,
) -> (u384, u384, u384, u384, u384, u384) {
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
    let t0 = circuit_mul(in5, in60); // Eval quot_0 Horner step: multiply by STEP
    let t1 = circuit_add(in4, t0); // Eval quot_0 Horner step: add coefficient_4
    let t2 = circuit_mul(t1, in60); // Eval quot_0 Horner step: multiply by STEP
    let t3 = circuit_add(in3, t2); // Eval quot_0 Horner step: add coefficient_3
    let t4 = circuit_mul(t3, in60); // Eval quot_0 Horner step: multiply by STEP
    let t5 = circuit_add(in2, t4); // Eval quot_0 Horner step: add coefficient_2
    let t6 = circuit_mul(t5, in60); // Eval quot_0 Horner step: multiply by STEP
    let t7 = circuit_add(in1, t6); // Eval quot_0 Horner step: add coefficient_1
    let t8 = circuit_mul(t7, in60); // Eval quot_0 Horner step: multiply by STEP
    let t9 = circuit_add(in0, t8); // Eval quot_0 Horner step: add coefficient_0
    let t10 = circuit_mul(in11, in60); // Eval rem_0 Horner step: multiply by STEP
    let t11 = circuit_add(in10, t10); // Eval rem_0 Horner step: add coefficient_4
    let t12 = circuit_mul(t11, in60); // Eval rem_0 Horner step: multiply by STEP
    let t13 = circuit_add(in9, t12); // Eval rem_0 Horner step: add coefficient_3
    let t14 = circuit_mul(t13, in60); // Eval rem_0 Horner step: multiply by STEP
    let t15 = circuit_add(in8, t14); // Eval rem_0 Horner step: add coefficient_2
    let t16 = circuit_mul(t15, in60); // Eval rem_0 Horner step: multiply by STEP
    let t17 = circuit_add(in7, t16); // Eval rem_0 Horner step: add coefficient_1
    let t18 = circuit_mul(t17, in60); // Eval rem_0 Horner step: multiply by STEP
    let t19 = circuit_add(in6, t18); // Eval rem_0 Horner step: add coefficient_0
    let t20 = circuit_mul(in61, in61); // square_0
    let t21 = circuit_mul(t9, in62); // quot*mod_0
    let t22 = circuit_sub(t20, t21); // ab-qn_0
    let t23 = circuit_sub(t22, t19); // ab-qn-rem_0
    let t24 = circuit_mul(in17, in60); // Eval quot_1 Horner step: multiply by STEP
    let t25 = circuit_add(in16, t24); // Eval quot_1 Horner step: add coefficient_4
    let t26 = circuit_mul(t25, in60); // Eval quot_1 Horner step: multiply by STEP
    let t27 = circuit_add(in15, t26); // Eval quot_1 Horner step: add coefficient_3
    let t28 = circuit_mul(t27, in60); // Eval quot_1 Horner step: multiply by STEP
    let t29 = circuit_add(in14, t28); // Eval quot_1 Horner step: add coefficient_2
    let t30 = circuit_mul(t29, in60); // Eval quot_1 Horner step: multiply by STEP
    let t31 = circuit_add(in13, t30); // Eval quot_1 Horner step: add coefficient_1
    let t32 = circuit_mul(t31, in60); // Eval quot_1 Horner step: multiply by STEP
    let t33 = circuit_add(in12, t32); // Eval quot_1 Horner step: add coefficient_0
    let t34 = circuit_mul(in23, in60); // Eval rem_1 Horner step: multiply by STEP
    let t35 = circuit_add(in22, t34); // Eval rem_1 Horner step: add coefficient_4
    let t36 = circuit_mul(t35, in60); // Eval rem_1 Horner step: multiply by STEP
    let t37 = circuit_add(in21, t36); // Eval rem_1 Horner step: add coefficient_3
    let t38 = circuit_mul(t37, in60); // Eval rem_1 Horner step: multiply by STEP
    let t39 = circuit_add(in20, t38); // Eval rem_1 Horner step: add coefficient_2
    let t40 = circuit_mul(t39, in60); // Eval rem_1 Horner step: multiply by STEP
    let t41 = circuit_add(in19, t40); // Eval rem_1 Horner step: add coefficient_1
    let t42 = circuit_mul(t41, in60); // Eval rem_1 Horner step: multiply by STEP
    let t43 = circuit_add(in18, t42); // Eval rem_1 Horner step: add coefficient_0
    let t44 = circuit_mul(t19, t19); // square_1
    let t45 = circuit_mul(t33, in62); // quot*mod_1
    let t46 = circuit_sub(t44, t45); // ab-qn_1
    let t47 = circuit_sub(t46, t43); // ab-qn-rem_1
    let t48 = circuit_mul(in29, in60); // Eval quot_2 Horner step: multiply by STEP
    let t49 = circuit_add(in28, t48); // Eval quot_2 Horner step: add coefficient_4
    let t50 = circuit_mul(t49, in60); // Eval quot_2 Horner step: multiply by STEP
    let t51 = circuit_add(in27, t50); // Eval quot_2 Horner step: add coefficient_3
    let t52 = circuit_mul(t51, in60); // Eval quot_2 Horner step: multiply by STEP
    let t53 = circuit_add(in26, t52); // Eval quot_2 Horner step: add coefficient_2
    let t54 = circuit_mul(t53, in60); // Eval quot_2 Horner step: multiply by STEP
    let t55 = circuit_add(in25, t54); // Eval quot_2 Horner step: add coefficient_1
    let t56 = circuit_mul(t55, in60); // Eval quot_2 Horner step: multiply by STEP
    let t57 = circuit_add(in24, t56); // Eval quot_2 Horner step: add coefficient_0
    let t58 = circuit_mul(in35, in60); // Eval rem_2 Horner step: multiply by STEP
    let t59 = circuit_add(in34, t58); // Eval rem_2 Horner step: add coefficient_4
    let t60 = circuit_mul(t59, in60); // Eval rem_2 Horner step: multiply by STEP
    let t61 = circuit_add(in33, t60); // Eval rem_2 Horner step: add coefficient_3
    let t62 = circuit_mul(t61, in60); // Eval rem_2 Horner step: multiply by STEP
    let t63 = circuit_add(in32, t62); // Eval rem_2 Horner step: add coefficient_2
    let t64 = circuit_mul(t63, in60); // Eval rem_2 Horner step: multiply by STEP
    let t65 = circuit_add(in31, t64); // Eval rem_2 Horner step: add coefficient_1
    let t66 = circuit_mul(t65, in60); // Eval rem_2 Horner step: multiply by STEP
    let t67 = circuit_add(in30, t66); // Eval rem_2 Horner step: add coefficient_0
    let t68 = circuit_mul(t43, t43); // square_2
    let t69 = circuit_mul(t57, in62); // quot*mod_2
    let t70 = circuit_sub(t68, t69); // ab-qn_2
    let t71 = circuit_sub(t70, t67); // ab-qn-rem_2
    let t72 = circuit_mul(in41, in60); // Eval quot_3 Horner step: multiply by STEP
    let t73 = circuit_add(in40, t72); // Eval quot_3 Horner step: add coefficient_4
    let t74 = circuit_mul(t73, in60); // Eval quot_3 Horner step: multiply by STEP
    let t75 = circuit_add(in39, t74); // Eval quot_3 Horner step: add coefficient_3
    let t76 = circuit_mul(t75, in60); // Eval quot_3 Horner step: multiply by STEP
    let t77 = circuit_add(in38, t76); // Eval quot_3 Horner step: add coefficient_2
    let t78 = circuit_mul(t77, in60); // Eval quot_3 Horner step: multiply by STEP
    let t79 = circuit_add(in37, t78); // Eval quot_3 Horner step: add coefficient_1
    let t80 = circuit_mul(t79, in60); // Eval quot_3 Horner step: multiply by STEP
    let t81 = circuit_add(in36, t80); // Eval quot_3 Horner step: add coefficient_0
    let t82 = circuit_mul(in47, in60); // Eval rem_3 Horner step: multiply by STEP
    let t83 = circuit_add(in46, t82); // Eval rem_3 Horner step: add coefficient_4
    let t84 = circuit_mul(t83, in60); // Eval rem_3 Horner step: multiply by STEP
    let t85 = circuit_add(in45, t84); // Eval rem_3 Horner step: add coefficient_3
    let t86 = circuit_mul(t85, in60); // Eval rem_3 Horner step: multiply by STEP
    let t87 = circuit_add(in44, t86); // Eval rem_3 Horner step: add coefficient_2
    let t88 = circuit_mul(t87, in60); // Eval rem_3 Horner step: multiply by STEP
    let t89 = circuit_add(in43, t88); // Eval rem_3 Horner step: add coefficient_1
    let t90 = circuit_mul(t89, in60); // Eval rem_3 Horner step: multiply by STEP
    let t91 = circuit_add(in42, t90); // Eval rem_3 Horner step: add coefficient_0
    let t92 = circuit_mul(t67, t67); // square_3
    let t93 = circuit_mul(t81, in62); // quot*mod_3
    let t94 = circuit_sub(t92, t93); // ab-qn_3
    let t95 = circuit_sub(t94, t91); // ab-qn-rem_3
    let t96 = circuit_mul(in53, in60); // Eval quot_4 Horner step: multiply by STEP
    let t97 = circuit_add(in52, t96); // Eval quot_4 Horner step: add coefficient_4
    let t98 = circuit_mul(t97, in60); // Eval quot_4 Horner step: multiply by STEP
    let t99 = circuit_add(in51, t98); // Eval quot_4 Horner step: add coefficient_3
    let t100 = circuit_mul(t99, in60); // Eval quot_4 Horner step: multiply by STEP
    let t101 = circuit_add(in50, t100); // Eval quot_4 Horner step: add coefficient_2
    let t102 = circuit_mul(t101, in60); // Eval quot_4 Horner step: multiply by STEP
    let t103 = circuit_add(in49, t102); // Eval quot_4 Horner step: add coefficient_1
    let t104 = circuit_mul(t103, in60); // Eval quot_4 Horner step: multiply by STEP
    let t105 = circuit_add(in48, t104); // Eval quot_4 Horner step: add coefficient_0
    let t106 = circuit_mul(in59, in60); // Eval rem_4 Horner step: multiply by STEP
    let t107 = circuit_add(in58, t106); // Eval rem_4 Horner step: add coefficient_4
    let t108 = circuit_mul(t107, in60); // Eval rem_4 Horner step: multiply by STEP
    let t109 = circuit_add(in57, t108); // Eval rem_4 Horner step: add coefficient_3
    let t110 = circuit_mul(t109, in60); // Eval rem_4 Horner step: multiply by STEP
    let t111 = circuit_add(in56, t110); // Eval rem_4 Horner step: add coefficient_2
    let t112 = circuit_mul(t111, in60); // Eval rem_4 Horner step: multiply by STEP
    let t113 = circuit_add(in55, t112); // Eval rem_4 Horner step: add coefficient_1
    let t114 = circuit_mul(t113, in60); // Eval rem_4 Horner step: multiply by STEP
    let t115 = circuit_add(in54, t114); // Eval rem_4 Horner step: add coefficient_0
    let t116 = circuit_mul(t91, t91); // square_4
    let t117 = circuit_mul(t105, in62); // quot*mod_4
    let t118 = circuit_sub(t116, t117); // ab-qn_4
    let t119 = circuit_sub(t118, t115); // ab-qn-rem_4

    let modulus = modulus;

    let mut circuit_inputs = (t115, t23, t47, t71, t95, t119).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(quot_chunks_0.w0); // in0
    circuit_inputs = circuit_inputs.next_2(quot_chunks_0.w1); // in1
    circuit_inputs = circuit_inputs.next_2(quot_chunks_0.w2); // in2
    circuit_inputs = circuit_inputs.next_2(quot_chunks_0.w3); // in3
    circuit_inputs = circuit_inputs.next_2(quot_chunks_0.w4); // in4
    circuit_inputs = circuit_inputs.next_2(quot_chunks_0.w5); // in5
    circuit_inputs = circuit_inputs.next_2(rem_chunks_0.w0); // in6
    circuit_inputs = circuit_inputs.next_2(rem_chunks_0.w1); // in7
    circuit_inputs = circuit_inputs.next_2(rem_chunks_0.w2); // in8
    circuit_inputs = circuit_inputs.next_2(rem_chunks_0.w3); // in9
    circuit_inputs = circuit_inputs.next_2(rem_chunks_0.w4); // in10
    circuit_inputs = circuit_inputs.next_2(rem_chunks_0.w5); // in11
    circuit_inputs = circuit_inputs.next_2(quot_chunks_1.w0); // in12
    circuit_inputs = circuit_inputs.next_2(quot_chunks_1.w1); // in13
    circuit_inputs = circuit_inputs.next_2(quot_chunks_1.w2); // in14
    circuit_inputs = circuit_inputs.next_2(quot_chunks_1.w3); // in15
    circuit_inputs = circuit_inputs.next_2(quot_chunks_1.w4); // in16
    circuit_inputs = circuit_inputs.next_2(quot_chunks_1.w5); // in17
    circuit_inputs = circuit_inputs.next_2(rem_chunks_1.w0); // in18
    circuit_inputs = circuit_inputs.next_2(rem_chunks_1.w1); // in19
    circuit_inputs = circuit_inputs.next_2(rem_chunks_1.w2); // in20
    circuit_inputs = circuit_inputs.next_2(rem_chunks_1.w3); // in21
    circuit_inputs = circuit_inputs.next_2(rem_chunks_1.w4); // in22
    circuit_inputs = circuit_inputs.next_2(rem_chunks_1.w5); // in23
    circuit_inputs = circuit_inputs.next_2(quot_chunks_2.w0); // in24
    circuit_inputs = circuit_inputs.next_2(quot_chunks_2.w1); // in25
    circuit_inputs = circuit_inputs.next_2(quot_chunks_2.w2); // in26
    circuit_inputs = circuit_inputs.next_2(quot_chunks_2.w3); // in27
    circuit_inputs = circuit_inputs.next_2(quot_chunks_2.w4); // in28
    circuit_inputs = circuit_inputs.next_2(quot_chunks_2.w5); // in29
    circuit_inputs = circuit_inputs.next_2(rem_chunks_2.w0); // in30
    circuit_inputs = circuit_inputs.next_2(rem_chunks_2.w1); // in31
    circuit_inputs = circuit_inputs.next_2(rem_chunks_2.w2); // in32
    circuit_inputs = circuit_inputs.next_2(rem_chunks_2.w3); // in33
    circuit_inputs = circuit_inputs.next_2(rem_chunks_2.w4); // in34
    circuit_inputs = circuit_inputs.next_2(rem_chunks_2.w5); // in35
    circuit_inputs = circuit_inputs.next_2(quot_chunks_3.w0); // in36
    circuit_inputs = circuit_inputs.next_2(quot_chunks_3.w1); // in37
    circuit_inputs = circuit_inputs.next_2(quot_chunks_3.w2); // in38
    circuit_inputs = circuit_inputs.next_2(quot_chunks_3.w3); // in39
    circuit_inputs = circuit_inputs.next_2(quot_chunks_3.w4); // in40
    circuit_inputs = circuit_inputs.next_2(quot_chunks_3.w5); // in41
    circuit_inputs = circuit_inputs.next_2(rem_chunks_3.w0); // in42
    circuit_inputs = circuit_inputs.next_2(rem_chunks_3.w1); // in43
    circuit_inputs = circuit_inputs.next_2(rem_chunks_3.w2); // in44
    circuit_inputs = circuit_inputs.next_2(rem_chunks_3.w3); // in45
    circuit_inputs = circuit_inputs.next_2(rem_chunks_3.w4); // in46
    circuit_inputs = circuit_inputs.next_2(rem_chunks_3.w5); // in47
    circuit_inputs = circuit_inputs.next_2(quot_chunks_4.w0); // in48
    circuit_inputs = circuit_inputs.next_2(quot_chunks_4.w1); // in49
    circuit_inputs = circuit_inputs.next_2(quot_chunks_4.w2); // in50
    circuit_inputs = circuit_inputs.next_2(quot_chunks_4.w3); // in51
    circuit_inputs = circuit_inputs.next_2(quot_chunks_4.w4); // in52
    circuit_inputs = circuit_inputs.next_2(quot_chunks_4.w5); // in53
    circuit_inputs = circuit_inputs.next_2(rem_chunks_4.w0); // in54
    circuit_inputs = circuit_inputs.next_2(rem_chunks_4.w1); // in55
    circuit_inputs = circuit_inputs.next_2(rem_chunks_4.w2); // in56
    circuit_inputs = circuit_inputs.next_2(rem_chunks_4.w3); // in57
    circuit_inputs = circuit_inputs.next_2(rem_chunks_4.w4); // in58
    circuit_inputs = circuit_inputs.next_2(rem_chunks_4.w5); // in59
    circuit_inputs = circuit_inputs.next_2(step); // in60
    circuit_inputs = circuit_inputs.next_2(prev_res); // in61
    circuit_inputs = circuit_inputs.next_2(mod_res); // in62

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let rem_res: u384 = outputs.get_output(t115);
    let diff_0: u384 = outputs.get_output(t23);
    let diff_1: u384 = outputs.get_output(t47);
    let diff_2: u384 = outputs.get_output(t71);
    let diff_3: u384 = outputs.get_output(t95);
    let diff_4: u384 = outputs.get_output(t119);
    return (rem_res, diff_0, diff_1, diff_2, diff_3, diff_4);
}

pub fn run_RSA_EVAL_6_CHUNKS_circuit(
    chunks: RSA2048Chunks, step: u384, modulus: core::circuit::CircuitModulus,
) -> (u384,) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let in6 = CE::<CI<6>> {};
    let t0 = circuit_mul(in5, in6); // Eval chunks Horner step: multiply by STEP
    let t1 = circuit_add(in4, t0); // Eval chunks Horner step: add coefficient_4
    let t2 = circuit_mul(t1, in6); // Eval chunks Horner step: multiply by STEP
    let t3 = circuit_add(in3, t2); // Eval chunks Horner step: add coefficient_3
    let t4 = circuit_mul(t3, in6); // Eval chunks Horner step: multiply by STEP
    let t5 = circuit_add(in2, t4); // Eval chunks Horner step: add coefficient_2
    let t6 = circuit_mul(t5, in6); // Eval chunks Horner step: multiply by STEP
    let t7 = circuit_add(in1, t6); // Eval chunks Horner step: add coefficient_1
    let t8 = circuit_mul(t7, in6); // Eval chunks Horner step: multiply by STEP
    let t9 = circuit_add(in0, t8); // Eval chunks Horner step: add coefficient_0

    let modulus = modulus;

    let mut circuit_inputs = (t9,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(chunks.w0); // in0
    circuit_inputs = circuit_inputs.next_2(chunks.w1); // in1
    circuit_inputs = circuit_inputs.next_2(chunks.w2); // in2
    circuit_inputs = circuit_inputs.next_2(chunks.w3); // in3
    circuit_inputs = circuit_inputs.next_2(chunks.w4); // in4
    circuit_inputs = circuit_inputs.next_2(chunks.w5); // in5
    circuit_inputs = circuit_inputs.next_2(step); // in6

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let value: u384 = outputs.get_output(t9);
    return (value,);
}

pub fn run_RSA_FIRST_STEP_circuit(
    mod_chunks: RSA2048Chunks,
    sig_chunks: RSA2048Chunks,
    quot_chunks: RSA2048Chunks,
    rem_chunks: RSA2048Chunks,
    step: u384,
    modulus: core::circuit::CircuitModulus,
) -> (u384, u384, u384, u384) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13, in14) = (CE::<CI<12>> {}, CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16, in17) = (CE::<CI<15>> {}, CE::<CI<16>> {}, CE::<CI<17>> {});
    let (in18, in19, in20) = (CE::<CI<18>> {}, CE::<CI<19>> {}, CE::<CI<20>> {});
    let (in21, in22, in23) = (CE::<CI<21>> {}, CE::<CI<22>> {}, CE::<CI<23>> {});
    let in24 = CE::<CI<24>> {};
    let t0 = circuit_mul(in5, in24); // Eval mod_chunks Horner step: multiply by STEP
    let t1 = circuit_add(in4, t0); // Eval mod_chunks Horner step: add coefficient_4
    let t2 = circuit_mul(t1, in24); // Eval mod_chunks Horner step: multiply by STEP
    let t3 = circuit_add(in3, t2); // Eval mod_chunks Horner step: add coefficient_3
    let t4 = circuit_mul(t3, in24); // Eval mod_chunks Horner step: multiply by STEP
    let t5 = circuit_add(in2, t4); // Eval mod_chunks Horner step: add coefficient_2
    let t6 = circuit_mul(t5, in24); // Eval mod_chunks Horner step: multiply by STEP
    let t7 = circuit_add(in1, t6); // Eval mod_chunks Horner step: add coefficient_1
    let t8 = circuit_mul(t7, in24); // Eval mod_chunks Horner step: multiply by STEP
    let t9 = circuit_add(in0, t8); // Eval mod_chunks Horner step: add coefficient_0
    let t10 = circuit_mul(in11, in24); // Eval sig_chunks Horner step: multiply by STEP
    let t11 = circuit_add(in10, t10); // Eval sig_chunks Horner step: add coefficient_4
    let t12 = circuit_mul(t11, in24); // Eval sig_chunks Horner step: multiply by STEP
    let t13 = circuit_add(in9, t12); // Eval sig_chunks Horner step: add coefficient_3
    let t14 = circuit_mul(t13, in24); // Eval sig_chunks Horner step: multiply by STEP
    let t15 = circuit_add(in8, t14); // Eval sig_chunks Horner step: add coefficient_2
    let t16 = circuit_mul(t15, in24); // Eval sig_chunks Horner step: multiply by STEP
    let t17 = circuit_add(in7, t16); // Eval sig_chunks Horner step: add coefficient_1
    let t18 = circuit_mul(t17, in24); // Eval sig_chunks Horner step: multiply by STEP
    let t19 = circuit_add(in6, t18); // Eval sig_chunks Horner step: add coefficient_0
    let t20 = circuit_mul(in17, in24); // Eval quot_chunks Horner step: multiply by STEP
    let t21 = circuit_add(in16, t20); // Eval quot_chunks Horner step: add coefficient_4
    let t22 = circuit_mul(t21, in24); // Eval quot_chunks Horner step: multiply by STEP
    let t23 = circuit_add(in15, t22); // Eval quot_chunks Horner step: add coefficient_3
    let t24 = circuit_mul(t23, in24); // Eval quot_chunks Horner step: multiply by STEP
    let t25 = circuit_add(in14, t24); // Eval quot_chunks Horner step: add coefficient_2
    let t26 = circuit_mul(t25, in24); // Eval quot_chunks Horner step: multiply by STEP
    let t27 = circuit_add(in13, t26); // Eval quot_chunks Horner step: add coefficient_1
    let t28 = circuit_mul(t27, in24); // Eval quot_chunks Horner step: multiply by STEP
    let t29 = circuit_add(in12, t28); // Eval quot_chunks Horner step: add coefficient_0
    let t30 = circuit_mul(in23, in24); // Eval rem_chunks Horner step: multiply by STEP
    let t31 = circuit_add(in22, t30); // Eval rem_chunks Horner step: add coefficient_4
    let t32 = circuit_mul(t31, in24); // Eval rem_chunks Horner step: multiply by STEP
    let t33 = circuit_add(in21, t32); // Eval rem_chunks Horner step: add coefficient_3
    let t34 = circuit_mul(t33, in24); // Eval rem_chunks Horner step: multiply by STEP
    let t35 = circuit_add(in20, t34); // Eval rem_chunks Horner step: add coefficient_2
    let t36 = circuit_mul(t35, in24); // Eval rem_chunks Horner step: multiply by STEP
    let t37 = circuit_add(in19, t36); // Eval rem_chunks Horner step: add coefficient_1
    let t38 = circuit_mul(t37, in24); // Eval rem_chunks Horner step: multiply by STEP
    let t39 = circuit_add(in18, t38); // Eval rem_chunks Horner step: add coefficient_0
    let t40 = circuit_mul(t19, t19); // sig * sig
    let t41 = circuit_mul(t29, t9); // quot * mod
    let t42 = circuit_sub(t40, t41); // ab - qn
    let t43 = circuit_sub(t42, t39); // ab - qn - rem

    let modulus = modulus;

    let mut circuit_inputs = (t9, t19, t39, t43).new_inputs();
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
    circuit_inputs = circuit_inputs.next_2(quot_chunks.w0); // in12
    circuit_inputs = circuit_inputs.next_2(quot_chunks.w1); // in13
    circuit_inputs = circuit_inputs.next_2(quot_chunks.w2); // in14
    circuit_inputs = circuit_inputs.next_2(quot_chunks.w3); // in15
    circuit_inputs = circuit_inputs.next_2(quot_chunks.w4); // in16
    circuit_inputs = circuit_inputs.next_2(quot_chunks.w5); // in17
    circuit_inputs = circuit_inputs.next_2(rem_chunks.w0); // in18
    circuit_inputs = circuit_inputs.next_2(rem_chunks.w1); // in19
    circuit_inputs = circuit_inputs.next_2(rem_chunks.w2); // in20
    circuit_inputs = circuit_inputs.next_2(rem_chunks.w3); // in21
    circuit_inputs = circuit_inputs.next_2(rem_chunks.w4); // in22
    circuit_inputs = circuit_inputs.next_2(rem_chunks.w5); // in23
    circuit_inputs = circuit_inputs.next_2(step); // in24

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let mod_res: u384 = outputs.get_output(t9);
    let sig_res: u384 = outputs.get_output(t19);
    let rem_res: u384 = outputs.get_output(t39);
    let diff: u384 = outputs.get_output(t43);
    return (mod_res, sig_res, rem_res, diff);
}

pub fn run_RSA_FUSED_EVAL_RELATION_circuit(
    quot_chunks: RSA2048Chunks,
    rem_chunks: RSA2048Chunks,
    step: u384,
    lhs_res: u384,
    rhs_res: u384,
    mod_res: u384,
    modulus: core::circuit::CircuitModulus,
) -> (u384, u384) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13, in14) = (CE::<CI<12>> {}, CE::<CI<13>> {}, CE::<CI<14>> {});
    let in15 = CE::<CI<15>> {};
    let t0 = circuit_mul(in5, in12); // Eval quot_chunks Horner step: multiply by STEP
    let t1 = circuit_add(in4, t0); // Eval quot_chunks Horner step: add coefficient_4
    let t2 = circuit_mul(t1, in12); // Eval quot_chunks Horner step: multiply by STEP
    let t3 = circuit_add(in3, t2); // Eval quot_chunks Horner step: add coefficient_3
    let t4 = circuit_mul(t3, in12); // Eval quot_chunks Horner step: multiply by STEP
    let t5 = circuit_add(in2, t4); // Eval quot_chunks Horner step: add coefficient_2
    let t6 = circuit_mul(t5, in12); // Eval quot_chunks Horner step: multiply by STEP
    let t7 = circuit_add(in1, t6); // Eval quot_chunks Horner step: add coefficient_1
    let t8 = circuit_mul(t7, in12); // Eval quot_chunks Horner step: multiply by STEP
    let t9 = circuit_add(in0, t8); // Eval quot_chunks Horner step: add coefficient_0
    let t10 = circuit_mul(in11, in12); // Eval rem_chunks Horner step: multiply by STEP
    let t11 = circuit_add(in10, t10); // Eval rem_chunks Horner step: add coefficient_4
    let t12 = circuit_mul(t11, in12); // Eval rem_chunks Horner step: multiply by STEP
    let t13 = circuit_add(in9, t12); // Eval rem_chunks Horner step: add coefficient_3
    let t14 = circuit_mul(t13, in12); // Eval rem_chunks Horner step: multiply by STEP
    let t15 = circuit_add(in8, t14); // Eval rem_chunks Horner step: add coefficient_2
    let t16 = circuit_mul(t15, in12); // Eval rem_chunks Horner step: multiply by STEP
    let t17 = circuit_add(in7, t16); // Eval rem_chunks Horner step: add coefficient_1
    let t18 = circuit_mul(t17, in12); // Eval rem_chunks Horner step: multiply by STEP
    let t19 = circuit_add(in6, t18); // Eval rem_chunks Horner step: add coefficient_0
    let t20 = circuit_mul(in13, in14); // lhs * rhs
    let t21 = circuit_mul(t9, in15); // quot * mod
    let t22 = circuit_sub(t20, t21); // ab - qn
    let t23 = circuit_sub(t22, t19); // ab - qn - rem

    let modulus = modulus;

    let mut circuit_inputs = (t19, t23).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(quot_chunks.w0); // in0
    circuit_inputs = circuit_inputs.next_2(quot_chunks.w1); // in1
    circuit_inputs = circuit_inputs.next_2(quot_chunks.w2); // in2
    circuit_inputs = circuit_inputs.next_2(quot_chunks.w3); // in3
    circuit_inputs = circuit_inputs.next_2(quot_chunks.w4); // in4
    circuit_inputs = circuit_inputs.next_2(quot_chunks.w5); // in5
    circuit_inputs = circuit_inputs.next_2(rem_chunks.w0); // in6
    circuit_inputs = circuit_inputs.next_2(rem_chunks.w1); // in7
    circuit_inputs = circuit_inputs.next_2(rem_chunks.w2); // in8
    circuit_inputs = circuit_inputs.next_2(rem_chunks.w3); // in9
    circuit_inputs = circuit_inputs.next_2(rem_chunks.w4); // in10
    circuit_inputs = circuit_inputs.next_2(rem_chunks.w5); // in11
    circuit_inputs = circuit_inputs.next_2(step); // in12
    circuit_inputs = circuit_inputs.next_2(lhs_res); // in13
    circuit_inputs = circuit_inputs.next_2(rhs_res); // in14
    circuit_inputs = circuit_inputs.next_2(mod_res); // in15

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let rem_res: u384 = outputs.get_output(t19);
    let diff: u384 = outputs.get_output(t23);
    return (rem_res, diff);
}

pub fn run_RSA_RELATION_CHECK_circuit(
    a: u384, b: u384, q: u384, n: u384, r: u384, modulus: core::circuit::CircuitModulus,
) -> (u384,) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4) = (CE::<CI<3>> {}, CE::<CI<4>> {});
    let t0 = circuit_mul(in0, in1); // Evaluate a * b
    let t1 = circuit_mul(in2, in3); // Evaluate q * n
    let t2 = circuit_sub(t0, t1); // Subtract q * n
    let t3 = circuit_sub(t2, in4); // Subtract r

    let modulus = modulus;

    let mut circuit_inputs = (t3,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(a); // in0
    circuit_inputs = circuit_inputs.next_2(b); // in1
    circuit_inputs = circuit_inputs.next_2(q); // in2
    circuit_inputs = circuit_inputs.next_2(n); // in3
    circuit_inputs = circuit_inputs.next_2(r); // in4

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let diff: u384 = outputs.get_output(t3);
    return (diff,);
}
