use core::circuit::{
    RangeCheck96, AddMod, MulMod, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
    circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, u384, CircuitOutputsTrait,
    CircuitModulus, FillInputResultTrait, CircuitInputs, FillInputResult, CircuitDefinition,
    CircuitData, CircuitInputAccumulator
};
use garaga::definitions::{get_a, get_b, get_p, get_g, get_min_one, G1Point};
use core::option::Option;
fn get_BN254_FP12_MUL_circuit(mut input: Array<u384>) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {};
    let in1 = CircuitElement::<CircuitInput<1>> {};
    let in2 = CircuitElement::<CircuitInput<2>> {};
    let in3 = CircuitElement::<CircuitInput<3>> {};

    // INPUT stack
    let in4 = CircuitElement::<CircuitInput<4>> {};
    let in5 = CircuitElement::<CircuitInput<5>> {};
    let in6 = CircuitElement::<CircuitInput<6>> {};
    let in7 = CircuitElement::<CircuitInput<7>> {};
    let in8 = CircuitElement::<CircuitInput<8>> {};
    let in9 = CircuitElement::<CircuitInput<9>> {};
    let in10 = CircuitElement::<CircuitInput<10>> {};
    let in11 = CircuitElement::<CircuitInput<11>> {};
    let in12 = CircuitElement::<CircuitInput<12>> {};
    let in13 = CircuitElement::<CircuitInput<13>> {};
    let in14 = CircuitElement::<CircuitInput<14>> {};
    let in15 = CircuitElement::<CircuitInput<15>> {};
    let in16 = CircuitElement::<CircuitInput<16>> {};
    let in17 = CircuitElement::<CircuitInput<17>> {};
    let in18 = CircuitElement::<CircuitInput<18>> {};
    let in19 = CircuitElement::<CircuitInput<19>> {};
    let in20 = CircuitElement::<CircuitInput<20>> {};
    let in21 = CircuitElement::<CircuitInput<21>> {};
    let in22 = CircuitElement::<CircuitInput<22>> {};
    let in23 = CircuitElement::<CircuitInput<23>> {};
    let in24 = CircuitElement::<CircuitInput<24>> {};
    let in25 = CircuitElement::<CircuitInput<25>> {};
    let in26 = CircuitElement::<CircuitInput<26>> {};
    let in27 = CircuitElement::<CircuitInput<27>> {};

    // COMMIT stack
    let in28 = CircuitElement::<CircuitInput<28>> {};
    let in29 = CircuitElement::<CircuitInput<29>> {};
    let in30 = CircuitElement::<CircuitInput<30>> {};
    let in31 = CircuitElement::<CircuitInput<31>> {};
    let in32 = CircuitElement::<CircuitInput<32>> {};
    let in33 = CircuitElement::<CircuitInput<33>> {};
    let in34 = CircuitElement::<CircuitInput<34>> {};
    let in35 = CircuitElement::<CircuitInput<35>> {};
    let in36 = CircuitElement::<CircuitInput<36>> {};
    let in37 = CircuitElement::<CircuitInput<37>> {};
    let in38 = CircuitElement::<CircuitInput<38>> {};
    let in39 = CircuitElement::<CircuitInput<39>> {};
    let in40 = CircuitElement::<CircuitInput<40>> {};
    let in41 = CircuitElement::<CircuitInput<41>> {};
    let in42 = CircuitElement::<CircuitInput<42>> {};
    let in43 = CircuitElement::<CircuitInput<43>> {};
    let in44 = CircuitElement::<CircuitInput<44>> {};
    let in45 = CircuitElement::<CircuitInput<45>> {};
    let in46 = CircuitElement::<CircuitInput<46>> {};
    let in47 = CircuitElement::<CircuitInput<47>> {};
    let in48 = CircuitElement::<CircuitInput<48>> {};
    let in49 = CircuitElement::<CircuitInput<49>> {};
    let in50 = CircuitElement::<CircuitInput<50>> {};

    // FELT stack
    let in51 = CircuitElement::<CircuitInput<51>> {};
    let in52 = CircuitElement::<CircuitInput<52>> {};
    let t0 = circuit_mul(in51, in51);
    let t1 = circuit_mul(t0, in51);
    let t2 = circuit_mul(t1, in51);
    let t3 = circuit_mul(t2, in51);
    let t4 = circuit_mul(t3, in51);
    let t5 = circuit_mul(t4, in51);
    let t6 = circuit_mul(t5, in51);
    let t7 = circuit_mul(t6, in51);
    let t8 = circuit_mul(t7, in51);
    let t9 = circuit_mul(t8, in51);
    let t10 = circuit_mul(t9, in51);
    let t11 = circuit_mul(in5, in51);
    let t12 = circuit_add(in4, t11);
    let t13 = circuit_mul(in6, t0);
    let t14 = circuit_add(t12, t13);
    let t15 = circuit_mul(in7, t1);
    let t16 = circuit_add(t14, t15);
    let t17 = circuit_mul(in8, t2);
    let t18 = circuit_add(t16, t17);
    let t19 = circuit_mul(in9, t3);
    let t20 = circuit_add(t18, t19);
    let t21 = circuit_mul(in10, t4);
    let t22 = circuit_add(t20, t21);
    let t23 = circuit_mul(in11, t5);
    let t24 = circuit_add(t22, t23);
    let t25 = circuit_mul(in12, t6);
    let t26 = circuit_add(t24, t25);
    let t27 = circuit_mul(in13, t7);
    let t28 = circuit_add(t26, t27);
    let t29 = circuit_mul(in14, t8);
    let t30 = circuit_add(t28, t29);
    let t31 = circuit_mul(in15, t9);
    let t32 = circuit_add(t30, t31);
    let t33 = circuit_mul(in17, in51);
    let t34 = circuit_add(in16, t33);
    let t35 = circuit_mul(in18, t0);
    let t36 = circuit_add(t34, t35);
    let t37 = circuit_mul(in19, t1);
    let t38 = circuit_add(t36, t37);
    let t39 = circuit_mul(in20, t2);
    let t40 = circuit_add(t38, t39);
    let t41 = circuit_mul(in21, t3);
    let t42 = circuit_add(t40, t41);
    let t43 = circuit_mul(in22, t4);
    let t44 = circuit_add(t42, t43);
    let t45 = circuit_mul(in23, t5);
    let t46 = circuit_add(t44, t45);
    let t47 = circuit_mul(in24, t6);
    let t48 = circuit_add(t46, t47);
    let t49 = circuit_mul(in25, t7);
    let t50 = circuit_add(t48, t49);
    let t51 = circuit_mul(in26, t8);
    let t52 = circuit_add(t50, t51);
    let t53 = circuit_mul(in27, t9);
    let t54 = circuit_add(t52, t53);
    let t55 = circuit_mul(t32, t54);
    let t56 = circuit_mul(in52, t55);
    let t57 = circuit_mul(in52, in28);
    let t58 = circuit_mul(in52, in29);
    let t59 = circuit_mul(in52, in30);
    let t60 = circuit_mul(in52, in31);
    let t61 = circuit_mul(in52, in32);
    let t62 = circuit_mul(in52, in33);
    let t63 = circuit_mul(in52, in34);
    let t64 = circuit_mul(in52, in35);
    let t65 = circuit_mul(in52, in36);
    let t66 = circuit_mul(in52, in37);
    let t67 = circuit_mul(in52, in38);
    let t68 = circuit_mul(in52, in39);
    let t69 = circuit_mul(in41, in51);
    let t70 = circuit_add(in40, t69);
    let t71 = circuit_mul(in42, t0);
    let t72 = circuit_add(t70, t71);
    let t73 = circuit_mul(in43, t1);
    let t74 = circuit_add(t72, t73);
    let t75 = circuit_mul(in44, t2);
    let t76 = circuit_add(t74, t75);
    let t77 = circuit_mul(in45, t3);
    let t78 = circuit_add(t76, t77);
    let t79 = circuit_mul(in46, t4);
    let t80 = circuit_add(t78, t79);
    let t81 = circuit_mul(in47, t5);
    let t82 = circuit_add(t80, t81);
    let t83 = circuit_mul(in48, t6);
    let t84 = circuit_add(t82, t83);
    let t85 = circuit_mul(in49, t7);
    let t86 = circuit_add(t84, t85);
    let t87 = circuit_mul(in50, t8);
    let t88 = circuit_add(t86, t87);
    let t89 = circuit_mul(in1, t4);
    let t90 = circuit_add(in0, t89);
    let t91 = circuit_mul(in2, t10);
    let t92 = circuit_add(t90, t91);
    let t93 = circuit_mul(t58, in51);
    let t94 = circuit_add(t57, t93);
    let t95 = circuit_mul(t59, t0);
    let t96 = circuit_add(t94, t95);
    let t97 = circuit_mul(t60, t1);
    let t98 = circuit_add(t96, t97);
    let t99 = circuit_mul(t61, t2);
    let t100 = circuit_add(t98, t99);
    let t101 = circuit_mul(t62, t3);
    let t102 = circuit_add(t100, t101);
    let t103 = circuit_mul(t63, t4);
    let t104 = circuit_add(t102, t103);
    let t105 = circuit_mul(t64, t5);
    let t106 = circuit_add(t104, t105);
    let t107 = circuit_mul(t65, t6);
    let t108 = circuit_add(t106, t107);
    let t109 = circuit_mul(t66, t7);
    let t110 = circuit_add(t108, t109);
    let t111 = circuit_mul(t67, t8);
    let t112 = circuit_add(t110, t111);
    let t113 = circuit_mul(t68, t9);
    let t114 = circuit_add(t112, t113);
    let t115 = circuit_mul(t88, t92);
    let t116 = circuit_add(t115, t114);
    // commit_start_index=28, commit_end_index-1=50
    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (
        in28, in29, in30, in31, in32, in33, in34, in35, in36, in37, in38, in39,
    )
        .new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        EvalCircuitResult::Success(outputs) => { outputs },
        EvalCircuitResult::Failure((_, _)) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(in28);
    let o1 = outputs.get_output(in29);
    let o2 = outputs.get_output(in30);
    let o3 = outputs.get_output(in31);
    let o4 = outputs.get_output(in32);
    let o5 = outputs.get_output(in33);
    let o6 = outputs.get_output(in34);
    let o7 = outputs.get_output(in35);
    let o8 = outputs.get_output(in36);
    let o9 = outputs.get_output(in37);
    let o10 = outputs.get_output(in38);
    let o11 = outputs.get_output(in39);

    let res = array![o0, o1, o2, o3, o4, o5, o6, o7, o8, o9, o10, o11];
    return res;
}

fn get_BLS12_381_FP12_MUL_circuit(mut input: Array<u384>) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {};
    let in1 = CircuitElement::<CircuitInput<1>> {};
    let in2 = CircuitElement::<CircuitInput<2>> {};
    let in3 = CircuitElement::<CircuitInput<3>> {};

    // INPUT stack
    let in4 = CircuitElement::<CircuitInput<4>> {};
    let in5 = CircuitElement::<CircuitInput<5>> {};
    let in6 = CircuitElement::<CircuitInput<6>> {};
    let in7 = CircuitElement::<CircuitInput<7>> {};
    let in8 = CircuitElement::<CircuitInput<8>> {};
    let in9 = CircuitElement::<CircuitInput<9>> {};
    let in10 = CircuitElement::<CircuitInput<10>> {};
    let in11 = CircuitElement::<CircuitInput<11>> {};
    let in12 = CircuitElement::<CircuitInput<12>> {};
    let in13 = CircuitElement::<CircuitInput<13>> {};
    let in14 = CircuitElement::<CircuitInput<14>> {};
    let in15 = CircuitElement::<CircuitInput<15>> {};
    let in16 = CircuitElement::<CircuitInput<16>> {};
    let in17 = CircuitElement::<CircuitInput<17>> {};
    let in18 = CircuitElement::<CircuitInput<18>> {};
    let in19 = CircuitElement::<CircuitInput<19>> {};
    let in20 = CircuitElement::<CircuitInput<20>> {};
    let in21 = CircuitElement::<CircuitInput<21>> {};
    let in22 = CircuitElement::<CircuitInput<22>> {};
    let in23 = CircuitElement::<CircuitInput<23>> {};
    let in24 = CircuitElement::<CircuitInput<24>> {};
    let in25 = CircuitElement::<CircuitInput<25>> {};
    let in26 = CircuitElement::<CircuitInput<26>> {};
    let in27 = CircuitElement::<CircuitInput<27>> {};

    // COMMIT stack
    let in28 = CircuitElement::<CircuitInput<28>> {};
    let in29 = CircuitElement::<CircuitInput<29>> {};
    let in30 = CircuitElement::<CircuitInput<30>> {};
    let in31 = CircuitElement::<CircuitInput<31>> {};
    let in32 = CircuitElement::<CircuitInput<32>> {};
    let in33 = CircuitElement::<CircuitInput<33>> {};
    let in34 = CircuitElement::<CircuitInput<34>> {};
    let in35 = CircuitElement::<CircuitInput<35>> {};
    let in36 = CircuitElement::<CircuitInput<36>> {};
    let in37 = CircuitElement::<CircuitInput<37>> {};
    let in38 = CircuitElement::<CircuitInput<38>> {};
    let in39 = CircuitElement::<CircuitInput<39>> {};
    let in40 = CircuitElement::<CircuitInput<40>> {};
    let in41 = CircuitElement::<CircuitInput<41>> {};
    let in42 = CircuitElement::<CircuitInput<42>> {};
    let in43 = CircuitElement::<CircuitInput<43>> {};
    let in44 = CircuitElement::<CircuitInput<44>> {};
    let in45 = CircuitElement::<CircuitInput<45>> {};
    let in46 = CircuitElement::<CircuitInput<46>> {};
    let in47 = CircuitElement::<CircuitInput<47>> {};
    let in48 = CircuitElement::<CircuitInput<48>> {};
    let in49 = CircuitElement::<CircuitInput<49>> {};
    let in50 = CircuitElement::<CircuitInput<50>> {};

    // FELT stack
    let in51 = CircuitElement::<CircuitInput<51>> {};
    let in52 = CircuitElement::<CircuitInput<52>> {};
    let t0 = circuit_mul(in51, in51);
    let t1 = circuit_mul(t0, in51);
    let t2 = circuit_mul(t1, in51);
    let t3 = circuit_mul(t2, in51);
    let t4 = circuit_mul(t3, in51);
    let t5 = circuit_mul(t4, in51);
    let t6 = circuit_mul(t5, in51);
    let t7 = circuit_mul(t6, in51);
    let t8 = circuit_mul(t7, in51);
    let t9 = circuit_mul(t8, in51);
    let t10 = circuit_mul(t9, in51);
    let t11 = circuit_mul(in5, in51);
    let t12 = circuit_add(in4, t11);
    let t13 = circuit_mul(in6, t0);
    let t14 = circuit_add(t12, t13);
    let t15 = circuit_mul(in7, t1);
    let t16 = circuit_add(t14, t15);
    let t17 = circuit_mul(in8, t2);
    let t18 = circuit_add(t16, t17);
    let t19 = circuit_mul(in9, t3);
    let t20 = circuit_add(t18, t19);
    let t21 = circuit_mul(in10, t4);
    let t22 = circuit_add(t20, t21);
    let t23 = circuit_mul(in11, t5);
    let t24 = circuit_add(t22, t23);
    let t25 = circuit_mul(in12, t6);
    let t26 = circuit_add(t24, t25);
    let t27 = circuit_mul(in13, t7);
    let t28 = circuit_add(t26, t27);
    let t29 = circuit_mul(in14, t8);
    let t30 = circuit_add(t28, t29);
    let t31 = circuit_mul(in15, t9);
    let t32 = circuit_add(t30, t31);
    let t33 = circuit_mul(in17, in51);
    let t34 = circuit_add(in16, t33);
    let t35 = circuit_mul(in18, t0);
    let t36 = circuit_add(t34, t35);
    let t37 = circuit_mul(in19, t1);
    let t38 = circuit_add(t36, t37);
    let t39 = circuit_mul(in20, t2);
    let t40 = circuit_add(t38, t39);
    let t41 = circuit_mul(in21, t3);
    let t42 = circuit_add(t40, t41);
    let t43 = circuit_mul(in22, t4);
    let t44 = circuit_add(t42, t43);
    let t45 = circuit_mul(in23, t5);
    let t46 = circuit_add(t44, t45);
    let t47 = circuit_mul(in24, t6);
    let t48 = circuit_add(t46, t47);
    let t49 = circuit_mul(in25, t7);
    let t50 = circuit_add(t48, t49);
    let t51 = circuit_mul(in26, t8);
    let t52 = circuit_add(t50, t51);
    let t53 = circuit_mul(in27, t9);
    let t54 = circuit_add(t52, t53);
    let t55 = circuit_mul(t32, t54);
    let t56 = circuit_mul(in52, t55);
    let t57 = circuit_mul(in52, in28);
    let t58 = circuit_mul(in52, in29);
    let t59 = circuit_mul(in52, in30);
    let t60 = circuit_mul(in52, in31);
    let t61 = circuit_mul(in52, in32);
    let t62 = circuit_mul(in52, in33);
    let t63 = circuit_mul(in52, in34);
    let t64 = circuit_mul(in52, in35);
    let t65 = circuit_mul(in52, in36);
    let t66 = circuit_mul(in52, in37);
    let t67 = circuit_mul(in52, in38);
    let t68 = circuit_mul(in52, in39);
    let t69 = circuit_mul(in41, in51);
    let t70 = circuit_add(in40, t69);
    let t71 = circuit_mul(in42, t0);
    let t72 = circuit_add(t70, t71);
    let t73 = circuit_mul(in43, t1);
    let t74 = circuit_add(t72, t73);
    let t75 = circuit_mul(in44, t2);
    let t76 = circuit_add(t74, t75);
    let t77 = circuit_mul(in45, t3);
    let t78 = circuit_add(t76, t77);
    let t79 = circuit_mul(in46, t4);
    let t80 = circuit_add(t78, t79);
    let t81 = circuit_mul(in47, t5);
    let t82 = circuit_add(t80, t81);
    let t83 = circuit_mul(in48, t6);
    let t84 = circuit_add(t82, t83);
    let t85 = circuit_mul(in49, t7);
    let t86 = circuit_add(t84, t85);
    let t87 = circuit_mul(in50, t8);
    let t88 = circuit_add(t86, t87);
    let t89 = circuit_mul(in1, t4);
    let t90 = circuit_add(in0, t89);
    let t91 = circuit_mul(in2, t10);
    let t92 = circuit_add(t90, t91);
    let t93 = circuit_mul(t58, in51);
    let t94 = circuit_add(t57, t93);
    let t95 = circuit_mul(t59, t0);
    let t96 = circuit_add(t94, t95);
    let t97 = circuit_mul(t60, t1);
    let t98 = circuit_add(t96, t97);
    let t99 = circuit_mul(t61, t2);
    let t100 = circuit_add(t98, t99);
    let t101 = circuit_mul(t62, t3);
    let t102 = circuit_add(t100, t101);
    let t103 = circuit_mul(t63, t4);
    let t104 = circuit_add(t102, t103);
    let t105 = circuit_mul(t64, t5);
    let t106 = circuit_add(t104, t105);
    let t107 = circuit_mul(t65, t6);
    let t108 = circuit_add(t106, t107);
    let t109 = circuit_mul(t66, t7);
    let t110 = circuit_add(t108, t109);
    let t111 = circuit_mul(t67, t8);
    let t112 = circuit_add(t110, t111);
    let t113 = circuit_mul(t68, t9);
    let t114 = circuit_add(t112, t113);
    let t115 = circuit_mul(t88, t92);
    let t116 = circuit_add(t115, t114);
    // commit_start_index=28, commit_end_index-1=50
    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (
        in28, in29, in30, in31, in32, in33, in34, in35, in36, in37, in38, in39,
    )
        .new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        EvalCircuitResult::Success(outputs) => { outputs },
        EvalCircuitResult::Failure((_, _)) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(in28);
    let o1 = outputs.get_output(in29);
    let o2 = outputs.get_output(in30);
    let o3 = outputs.get_output(in31);
    let o4 = outputs.get_output(in32);
    let o5 = outputs.get_output(in33);
    let o6 = outputs.get_output(in34);
    let o7 = outputs.get_output(in35);
    let o8 = outputs.get_output(in36);
    let o9 = outputs.get_output(in37);
    let o10 = outputs.get_output(in38);
    let o11 = outputs.get_output(in39);

    let res = array![o0, o1, o2, o3, o4, o5, o6, o7, o8, o9, o10, o11];
    return res;
}

