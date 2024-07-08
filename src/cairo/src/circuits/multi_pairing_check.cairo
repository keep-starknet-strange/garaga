use core::circuit::{
    RangeCheck96, AddMod, MulMod, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
    circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, u384, CircuitOutputsTrait,
    CircuitModulus, AddInputResultTrait, CircuitInputs, CircuitDefinition, CircuitData,
    CircuitInputAccumulator
};
use garaga::definitions::{get_a, get_b, get_p, get_g, get_min_one, G1Point};
use core::option::Option;
fn get_BLS12_381_MP_CHECK_BIT0_LOOP_2_circuit(mut input: Array<u384>) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 3
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 6
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 0

    // INPUT stack
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
    let in9 = CircuitElement::<CircuitInput<9>> {}; // 
    let in10 = CircuitElement::<CircuitInput<10>> {}; // 
    let in11 = CircuitElement::<CircuitInput<11>> {}; // 
    let in12 = CircuitElement::<CircuitInput<12>> {}; // 
    let in13 = CircuitElement::<CircuitInput<13>> {}; // 
    let in14 = CircuitElement::<CircuitInput<14>> {}; // 
    let in15 = CircuitElement::<CircuitInput<15>> {}; // 
    let in16 = CircuitElement::<CircuitInput<16>> {}; // 
    let in17 = CircuitElement::<CircuitInput<17>> {}; // 
    let in18 = CircuitElement::<CircuitInput<18>> {}; // 
    let in19 = CircuitElement::<CircuitInput<19>> {}; // 
    let in20 = CircuitElement::<CircuitInput<20>> {}; // 
    let in21 = CircuitElement::<CircuitInput<21>> {}; // 
    let in22 = CircuitElement::<CircuitInput<22>> {}; // 
    let in23 = CircuitElement::<CircuitInput<23>> {}; // 
    let in24 = CircuitElement::<CircuitInput<24>> {}; // 
    let in25 = CircuitElement::<CircuitInput<25>> {}; // 
    let in26 = CircuitElement::<CircuitInput<26>> {}; // 
    let in27 = CircuitElement::<CircuitInput<27>> {}; // 
    let in28 = CircuitElement::<CircuitInput<28>> {}; // 
    let in29 = CircuitElement::<CircuitInput<29>> {}; // 

    // FELT stack
    let in30 = CircuitElement::<CircuitInput<30>> {}; // 
    let t0 = circuit_mul(in30, in30);
    let t1 = circuit_mul(t0, in30);
    let t2 = circuit_mul(t1, in30);
    let t3 = circuit_mul(t2, in30);
    let t4 = circuit_mul(t3, in30);
    let t5 = circuit_mul(t4, in30);
    let t6 = circuit_mul(t5, in30);
    let t7 = circuit_mul(t6, in30);
    let t8 = circuit_mul(t7, in30);
    let t9 = circuit_mul(t8, in30);
    let t10 = circuit_mul(in16, in16);
    let t11 = circuit_add(in5, in6);
    let t12 = circuit_sub(in5, in6);
    let t13 = circuit_mul(t11, t12);
    let t14 = circuit_mul(in5, in6);
    let t15 = circuit_mul(t13, in0);
    let t16 = circuit_mul(t14, in1);
    let t17 = circuit_add(in7, in7);
    let t18 = circuit_add(in8, in8);
    let t19 = circuit_mul(t17, t17);
    let t20 = circuit_mul(t18, t18);
    let t21 = circuit_add(t19, t20);
    let t22 = circuit_inverse(t21);
    let t23 = circuit_mul(t17, t22);
    let t24 = circuit_mul(t18, t22);
    let t25 = circuit_sub(in2, t24);
    let t26 = circuit_mul(t15, t23);
    let t27 = circuit_mul(t16, t25);
    let t28 = circuit_sub(t26, t27);
    let t29 = circuit_mul(t15, t25);
    let t30 = circuit_mul(t16, t23);
    let t31 = circuit_add(t29, t30);
    let t32 = circuit_add(t28, t31);
    let t33 = circuit_sub(t28, t31);
    let t34 = circuit_mul(t32, t33);
    let t35 = circuit_mul(t28, t31);
    let t36 = circuit_add(t35, t35);
    let t37 = circuit_add(in5, in5);
    let t38 = circuit_add(in6, in6);
    let t39 = circuit_sub(t34, t37);
    let t40 = circuit_sub(t36, t38);
    let t41 = circuit_sub(in5, t39);
    let t42 = circuit_sub(in6, t40);
    let t43 = circuit_mul(t28, t41);
    let t44 = circuit_mul(t31, t42);
    let t45 = circuit_sub(t43, t44);
    let t46 = circuit_mul(t28, t42);
    let t47 = circuit_mul(t31, t41);
    let t48 = circuit_add(t46, t47);
    let t49 = circuit_sub(t45, in7);
    let t50 = circuit_sub(t48, in8);
    let t51 = circuit_mul(t28, in5);
    let t52 = circuit_mul(t31, in6);
    let t53 = circuit_sub(t51, t52);
    let t54 = circuit_mul(t28, in6);
    let t55 = circuit_mul(t31, in5);
    let t56 = circuit_add(t54, t55);
    let t57 = circuit_sub(t53, in7);
    let t58 = circuit_sub(t56, in8);
    let t59 = circuit_sub(t57, t58);
    let t60 = circuit_mul(t59, in3);
    let t61 = circuit_sub(t28, t31);
    let t62 = circuit_mul(t61, in4);
    let t63 = circuit_mul(t58, in3);
    let t64 = circuit_mul(t31, in4);
    let t65 = circuit_mul(t62, t0);
    let t66 = circuit_add(t60, t65);
    let t67 = circuit_add(t66, t1);
    let t68 = circuit_mul(t63, t4);
    let t69 = circuit_add(t67, t68);
    let t70 = circuit_mul(t64, t6);
    let t71 = circuit_add(t69, t70);
    let t72 = circuit_mul(t10, t71);
    let t73 = circuit_add(in11, in12);
    let t74 = circuit_sub(in11, in12);
    let t75 = circuit_mul(t73, t74);
    let t76 = circuit_mul(in11, in12);
    let t77 = circuit_mul(t75, in0);
    let t78 = circuit_mul(t76, in1);
    let t79 = circuit_add(in13, in13);
    let t80 = circuit_add(in14, in14);
    let t81 = circuit_mul(t79, t79);
    let t82 = circuit_mul(t80, t80);
    let t83 = circuit_add(t81, t82);
    let t84 = circuit_inverse(t83);
    let t85 = circuit_mul(t79, t84);
    let t86 = circuit_mul(t80, t84);
    let t87 = circuit_sub(in2, t86);
    let t88 = circuit_mul(t77, t85);
    let t89 = circuit_mul(t78, t87);
    let t90 = circuit_sub(t88, t89);
    let t91 = circuit_mul(t77, t87);
    let t92 = circuit_mul(t78, t85);
    let t93 = circuit_add(t91, t92);
    let t94 = circuit_add(t90, t93);
    let t95 = circuit_sub(t90, t93);
    let t96 = circuit_mul(t94, t95);
    let t97 = circuit_mul(t90, t93);
    let t98 = circuit_add(t97, t97);
    let t99 = circuit_add(in11, in11);
    let t100 = circuit_add(in12, in12);
    let t101 = circuit_sub(t96, t99);
    let t102 = circuit_sub(t98, t100);
    let t103 = circuit_sub(in11, t101);
    let t104 = circuit_sub(in12, t102);
    let t105 = circuit_mul(t90, t103);
    let t106 = circuit_mul(t93, t104);
    let t107 = circuit_sub(t105, t106);
    let t108 = circuit_mul(t90, t104);
    let t109 = circuit_mul(t93, t103);
    let t110 = circuit_add(t108, t109);
    let t111 = circuit_sub(t107, in13);
    let t112 = circuit_sub(t110, in14);
    let t113 = circuit_mul(t90, in11);
    let t114 = circuit_mul(t93, in12);
    let t115 = circuit_sub(t113, t114);
    let t116 = circuit_mul(t90, in12);
    let t117 = circuit_mul(t93, in11);
    let t118 = circuit_add(t116, t117);
    let t119 = circuit_sub(t115, in13);
    let t120 = circuit_sub(t118, in14);
    let t121 = circuit_sub(t119, t120);
    let t122 = circuit_mul(t121, in9);
    let t123 = circuit_sub(t90, t93);
    let t124 = circuit_mul(t123, in10);
    let t125 = circuit_mul(t120, in9);
    let t126 = circuit_mul(t93, in10);
    let t127 = circuit_mul(t124, t0);
    let t128 = circuit_add(t122, t127);
    let t129 = circuit_add(t128, t1);
    let t130 = circuit_mul(t125, t4);
    let t131 = circuit_add(t129, t130);
    let t132 = circuit_mul(t126, t6);
    let t133 = circuit_add(t131, t132);
    let t134 = circuit_mul(t72, t133);
    let t135 = circuit_mul(in18, in30);
    let t136 = circuit_add(in17, t135);
    let t137 = circuit_mul(in19, t0);
    let t138 = circuit_add(t136, t137);
    let t139 = circuit_mul(in20, t1);
    let t140 = circuit_add(t138, t139);
    let t141 = circuit_mul(in21, t2);
    let t142 = circuit_add(t140, t141);
    let t143 = circuit_mul(in22, t3);
    let t144 = circuit_add(t142, t143);
    let t145 = circuit_mul(in23, t4);
    let t146 = circuit_add(t144, t145);
    let t147 = circuit_mul(in24, t5);
    let t148 = circuit_add(t146, t147);
    let t149 = circuit_mul(in25, t6);
    let t150 = circuit_add(t148, t149);
    let t151 = circuit_mul(in26, t7);
    let t152 = circuit_add(t150, t151);
    let t153 = circuit_mul(in27, t8);
    let t154 = circuit_add(t152, t153);
    let t155 = circuit_mul(in28, t9);
    let t156 = circuit_add(t154, t155);
    let t157 = circuit_sub(t134, t156);
    let t158 = circuit_mul(in29, t157);
    let t159 = circuit_add(in15, t158);
    // commit_start_index=30, commit_end_index-1=29
    let p = get_p(1);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t49, t50, t111, t112,).new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t39);
    let o1 = outputs.get_output(t40);
    let o2 = outputs.get_output(t49);
    let o3 = outputs.get_output(t50);
    let o4 = outputs.get_output(t101);
    let o5 = outputs.get_output(t102);
    let o6 = outputs.get_output(t111);
    let o7 = outputs.get_output(t112);
    let o8 = outputs.get_output(t156);
    let o9 = outputs.get_output(t159);

    let res = array![o0, o1, o2, o3, o4, o5, o6, o7, o8, o9];
    return res;
}

fn get_BLS12_381_MP_CHECK_BIT0_LOOP_3_circuit(mut input: Array<u384>) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 3
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 6
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 0

    // INPUT stack
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
    let in9 = CircuitElement::<CircuitInput<9>> {}; // 
    let in10 = CircuitElement::<CircuitInput<10>> {}; // 
    let in11 = CircuitElement::<CircuitInput<11>> {}; // 
    let in12 = CircuitElement::<CircuitInput<12>> {}; // 
    let in13 = CircuitElement::<CircuitInput<13>> {}; // 
    let in14 = CircuitElement::<CircuitInput<14>> {}; // 
    let in15 = CircuitElement::<CircuitInput<15>> {}; // 
    let in16 = CircuitElement::<CircuitInput<16>> {}; // 
    let in17 = CircuitElement::<CircuitInput<17>> {}; // 
    let in18 = CircuitElement::<CircuitInput<18>> {}; // 
    let in19 = CircuitElement::<CircuitInput<19>> {}; // 
    let in20 = CircuitElement::<CircuitInput<20>> {}; // 
    let in21 = CircuitElement::<CircuitInput<21>> {}; // 
    let in22 = CircuitElement::<CircuitInput<22>> {}; // 
    let in23 = CircuitElement::<CircuitInput<23>> {}; // 
    let in24 = CircuitElement::<CircuitInput<24>> {}; // 
    let in25 = CircuitElement::<CircuitInput<25>> {}; // 
    let in26 = CircuitElement::<CircuitInput<26>> {}; // 
    let in27 = CircuitElement::<CircuitInput<27>> {}; // 
    let in28 = CircuitElement::<CircuitInput<28>> {}; // 
    let in29 = CircuitElement::<CircuitInput<29>> {}; // 
    let in30 = CircuitElement::<CircuitInput<30>> {}; // 
    let in31 = CircuitElement::<CircuitInput<31>> {}; // 
    let in32 = CircuitElement::<CircuitInput<32>> {}; // 
    let in33 = CircuitElement::<CircuitInput<33>> {}; // 
    let in34 = CircuitElement::<CircuitInput<34>> {}; // 
    let in35 = CircuitElement::<CircuitInput<35>> {}; // 

    // FELT stack
    let in36 = CircuitElement::<CircuitInput<36>> {}; // 
    let t0 = circuit_mul(in36, in36);
    let t1 = circuit_mul(t0, in36);
    let t2 = circuit_mul(t1, in36);
    let t3 = circuit_mul(t2, in36);
    let t4 = circuit_mul(t3, in36);
    let t5 = circuit_mul(t4, in36);
    let t6 = circuit_mul(t5, in36);
    let t7 = circuit_mul(t6, in36);
    let t8 = circuit_mul(t7, in36);
    let t9 = circuit_mul(t8, in36);
    let t10 = circuit_mul(in22, in22);
    let t11 = circuit_add(in5, in6);
    let t12 = circuit_sub(in5, in6);
    let t13 = circuit_mul(t11, t12);
    let t14 = circuit_mul(in5, in6);
    let t15 = circuit_mul(t13, in0);
    let t16 = circuit_mul(t14, in1);
    let t17 = circuit_add(in7, in7);
    let t18 = circuit_add(in8, in8);
    let t19 = circuit_mul(t17, t17);
    let t20 = circuit_mul(t18, t18);
    let t21 = circuit_add(t19, t20);
    let t22 = circuit_inverse(t21);
    let t23 = circuit_mul(t17, t22);
    let t24 = circuit_mul(t18, t22);
    let t25 = circuit_sub(in2, t24);
    let t26 = circuit_mul(t15, t23);
    let t27 = circuit_mul(t16, t25);
    let t28 = circuit_sub(t26, t27);
    let t29 = circuit_mul(t15, t25);
    let t30 = circuit_mul(t16, t23);
    let t31 = circuit_add(t29, t30);
    let t32 = circuit_add(t28, t31);
    let t33 = circuit_sub(t28, t31);
    let t34 = circuit_mul(t32, t33);
    let t35 = circuit_mul(t28, t31);
    let t36 = circuit_add(t35, t35);
    let t37 = circuit_add(in5, in5);
    let t38 = circuit_add(in6, in6);
    let t39 = circuit_sub(t34, t37);
    let t40 = circuit_sub(t36, t38);
    let t41 = circuit_sub(in5, t39);
    let t42 = circuit_sub(in6, t40);
    let t43 = circuit_mul(t28, t41);
    let t44 = circuit_mul(t31, t42);
    let t45 = circuit_sub(t43, t44);
    let t46 = circuit_mul(t28, t42);
    let t47 = circuit_mul(t31, t41);
    let t48 = circuit_add(t46, t47);
    let t49 = circuit_sub(t45, in7);
    let t50 = circuit_sub(t48, in8);
    let t51 = circuit_mul(t28, in5);
    let t52 = circuit_mul(t31, in6);
    let t53 = circuit_sub(t51, t52);
    let t54 = circuit_mul(t28, in6);
    let t55 = circuit_mul(t31, in5);
    let t56 = circuit_add(t54, t55);
    let t57 = circuit_sub(t53, in7);
    let t58 = circuit_sub(t56, in8);
    let t59 = circuit_sub(t57, t58);
    let t60 = circuit_mul(t59, in3);
    let t61 = circuit_sub(t28, t31);
    let t62 = circuit_mul(t61, in4);
    let t63 = circuit_mul(t58, in3);
    let t64 = circuit_mul(t31, in4);
    let t65 = circuit_mul(t62, t0);
    let t66 = circuit_add(t60, t65);
    let t67 = circuit_add(t66, t1);
    let t68 = circuit_mul(t63, t4);
    let t69 = circuit_add(t67, t68);
    let t70 = circuit_mul(t64, t6);
    let t71 = circuit_add(t69, t70);
    let t72 = circuit_mul(t10, t71);
    let t73 = circuit_add(in11, in12);
    let t74 = circuit_sub(in11, in12);
    let t75 = circuit_mul(t73, t74);
    let t76 = circuit_mul(in11, in12);
    let t77 = circuit_mul(t75, in0);
    let t78 = circuit_mul(t76, in1);
    let t79 = circuit_add(in13, in13);
    let t80 = circuit_add(in14, in14);
    let t81 = circuit_mul(t79, t79);
    let t82 = circuit_mul(t80, t80);
    let t83 = circuit_add(t81, t82);
    let t84 = circuit_inverse(t83);
    let t85 = circuit_mul(t79, t84);
    let t86 = circuit_mul(t80, t84);
    let t87 = circuit_sub(in2, t86);
    let t88 = circuit_mul(t77, t85);
    let t89 = circuit_mul(t78, t87);
    let t90 = circuit_sub(t88, t89);
    let t91 = circuit_mul(t77, t87);
    let t92 = circuit_mul(t78, t85);
    let t93 = circuit_add(t91, t92);
    let t94 = circuit_add(t90, t93);
    let t95 = circuit_sub(t90, t93);
    let t96 = circuit_mul(t94, t95);
    let t97 = circuit_mul(t90, t93);
    let t98 = circuit_add(t97, t97);
    let t99 = circuit_add(in11, in11);
    let t100 = circuit_add(in12, in12);
    let t101 = circuit_sub(t96, t99);
    let t102 = circuit_sub(t98, t100);
    let t103 = circuit_sub(in11, t101);
    let t104 = circuit_sub(in12, t102);
    let t105 = circuit_mul(t90, t103);
    let t106 = circuit_mul(t93, t104);
    let t107 = circuit_sub(t105, t106);
    let t108 = circuit_mul(t90, t104);
    let t109 = circuit_mul(t93, t103);
    let t110 = circuit_add(t108, t109);
    let t111 = circuit_sub(t107, in13);
    let t112 = circuit_sub(t110, in14);
    let t113 = circuit_mul(t90, in11);
    let t114 = circuit_mul(t93, in12);
    let t115 = circuit_sub(t113, t114);
    let t116 = circuit_mul(t90, in12);
    let t117 = circuit_mul(t93, in11);
    let t118 = circuit_add(t116, t117);
    let t119 = circuit_sub(t115, in13);
    let t120 = circuit_sub(t118, in14);
    let t121 = circuit_sub(t119, t120);
    let t122 = circuit_mul(t121, in9);
    let t123 = circuit_sub(t90, t93);
    let t124 = circuit_mul(t123, in10);
    let t125 = circuit_mul(t120, in9);
    let t126 = circuit_mul(t93, in10);
    let t127 = circuit_mul(t124, t0);
    let t128 = circuit_add(t122, t127);
    let t129 = circuit_add(t128, t1);
    let t130 = circuit_mul(t125, t4);
    let t131 = circuit_add(t129, t130);
    let t132 = circuit_mul(t126, t6);
    let t133 = circuit_add(t131, t132);
    let t134 = circuit_mul(t72, t133);
    let t135 = circuit_add(in17, in18);
    let t136 = circuit_sub(in17, in18);
    let t137 = circuit_mul(t135, t136);
    let t138 = circuit_mul(in17, in18);
    let t139 = circuit_mul(t137, in0);
    let t140 = circuit_mul(t138, in1);
    let t141 = circuit_add(in19, in19);
    let t142 = circuit_add(in20, in20);
    let t143 = circuit_mul(t141, t141);
    let t144 = circuit_mul(t142, t142);
    let t145 = circuit_add(t143, t144);
    let t146 = circuit_inverse(t145);
    let t147 = circuit_mul(t141, t146);
    let t148 = circuit_mul(t142, t146);
    let t149 = circuit_sub(in2, t148);
    let t150 = circuit_mul(t139, t147);
    let t151 = circuit_mul(t140, t149);
    let t152 = circuit_sub(t150, t151);
    let t153 = circuit_mul(t139, t149);
    let t154 = circuit_mul(t140, t147);
    let t155 = circuit_add(t153, t154);
    let t156 = circuit_add(t152, t155);
    let t157 = circuit_sub(t152, t155);
    let t158 = circuit_mul(t156, t157);
    let t159 = circuit_mul(t152, t155);
    let t160 = circuit_add(t159, t159);
    let t161 = circuit_add(in17, in17);
    let t162 = circuit_add(in18, in18);
    let t163 = circuit_sub(t158, t161);
    let t164 = circuit_sub(t160, t162);
    let t165 = circuit_sub(in17, t163);
    let t166 = circuit_sub(in18, t164);
    let t167 = circuit_mul(t152, t165);
    let t168 = circuit_mul(t155, t166);
    let t169 = circuit_sub(t167, t168);
    let t170 = circuit_mul(t152, t166);
    let t171 = circuit_mul(t155, t165);
    let t172 = circuit_add(t170, t171);
    let t173 = circuit_sub(t169, in19);
    let t174 = circuit_sub(t172, in20);
    let t175 = circuit_mul(t152, in17);
    let t176 = circuit_mul(t155, in18);
    let t177 = circuit_sub(t175, t176);
    let t178 = circuit_mul(t152, in18);
    let t179 = circuit_mul(t155, in17);
    let t180 = circuit_add(t178, t179);
    let t181 = circuit_sub(t177, in19);
    let t182 = circuit_sub(t180, in20);
    let t183 = circuit_sub(t181, t182);
    let t184 = circuit_mul(t183, in15);
    let t185 = circuit_sub(t152, t155);
    let t186 = circuit_mul(t185, in16);
    let t187 = circuit_mul(t182, in15);
    let t188 = circuit_mul(t155, in16);
    let t189 = circuit_mul(t186, t0);
    let t190 = circuit_add(t184, t189);
    let t191 = circuit_add(t190, t1);
    let t192 = circuit_mul(t187, t4);
    let t193 = circuit_add(t191, t192);
    let t194 = circuit_mul(t188, t6);
    let t195 = circuit_add(t193, t194);
    let t196 = circuit_mul(t134, t195);
    let t197 = circuit_mul(in24, in36);
    let t198 = circuit_add(in23, t197);
    let t199 = circuit_mul(in25, t0);
    let t200 = circuit_add(t198, t199);
    let t201 = circuit_mul(in26, t1);
    let t202 = circuit_add(t200, t201);
    let t203 = circuit_mul(in27, t2);
    let t204 = circuit_add(t202, t203);
    let t205 = circuit_mul(in28, t3);
    let t206 = circuit_add(t204, t205);
    let t207 = circuit_mul(in29, t4);
    let t208 = circuit_add(t206, t207);
    let t209 = circuit_mul(in30, t5);
    let t210 = circuit_add(t208, t209);
    let t211 = circuit_mul(in31, t6);
    let t212 = circuit_add(t210, t211);
    let t213 = circuit_mul(in32, t7);
    let t214 = circuit_add(t212, t213);
    let t215 = circuit_mul(in33, t8);
    let t216 = circuit_add(t214, t215);
    let t217 = circuit_mul(in34, t9);
    let t218 = circuit_add(t216, t217);
    let t219 = circuit_sub(t196, t218);
    let t220 = circuit_mul(in35, t219);
    let t221 = circuit_add(in21, t220);
    // commit_start_index=36, commit_end_index-1=35
    let p = get_p(1);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t49, t50, t111, t112, t173, t174,).new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t39);
    let o1 = outputs.get_output(t40);
    let o2 = outputs.get_output(t49);
    let o3 = outputs.get_output(t50);
    let o4 = outputs.get_output(t101);
    let o5 = outputs.get_output(t102);
    let o6 = outputs.get_output(t111);
    let o7 = outputs.get_output(t112);
    let o8 = outputs.get_output(t163);
    let o9 = outputs.get_output(t164);
    let o10 = outputs.get_output(t173);
    let o11 = outputs.get_output(t174);
    let o12 = outputs.get_output(t218);
    let o13 = outputs.get_output(t221);

    let res = array![o0, o1, o2, o3, o4, o5, o6, o7, o8, o9, o10, o11, o12, o13];
    return res;
}

fn get_BLS12_381_MP_CHECK_BIT1_LOOP_2_circuit(mut input: Array<u384>) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0

    // INPUT stack
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
    let in9 = CircuitElement::<CircuitInput<9>> {}; // 
    let in10 = CircuitElement::<CircuitInput<10>> {}; // 
    let in11 = CircuitElement::<CircuitInput<11>> {}; // 
    let in12 = CircuitElement::<CircuitInput<12>> {}; // 
    let in13 = CircuitElement::<CircuitInput<13>> {}; // 
    let in14 = CircuitElement::<CircuitInput<14>> {}; // 
    let in15 = CircuitElement::<CircuitInput<15>> {}; // 
    let in16 = CircuitElement::<CircuitInput<16>> {}; // 
    let in17 = CircuitElement::<CircuitInput<17>> {}; // 
    let in18 = CircuitElement::<CircuitInput<18>> {}; // 
    let in19 = CircuitElement::<CircuitInput<19>> {}; // 
    let in20 = CircuitElement::<CircuitInput<20>> {}; // 
    let in21 = CircuitElement::<CircuitInput<21>> {}; // 
    let in22 = CircuitElement::<CircuitInput<22>> {}; // 
    let in23 = CircuitElement::<CircuitInput<23>> {}; // 
    let in24 = CircuitElement::<CircuitInput<24>> {}; // 
    let in25 = CircuitElement::<CircuitInput<25>> {}; // 
    let in26 = CircuitElement::<CircuitInput<26>> {}; // 
    let in27 = CircuitElement::<CircuitInput<27>> {}; // 
    let in28 = CircuitElement::<CircuitInput<28>> {}; // 
    let in29 = CircuitElement::<CircuitInput<29>> {}; // 
    let in30 = CircuitElement::<CircuitInput<30>> {}; // 
    let in31 = CircuitElement::<CircuitInput<31>> {}; // 
    let in32 = CircuitElement::<CircuitInput<32>> {}; // 
    let in33 = CircuitElement::<CircuitInput<33>> {}; // 
    let in34 = CircuitElement::<CircuitInput<34>> {}; // 
    let in35 = CircuitElement::<CircuitInput<35>> {}; // 
    let in36 = CircuitElement::<CircuitInput<36>> {}; // 
    let in37 = CircuitElement::<CircuitInput<37>> {}; // 
    let in38 = CircuitElement::<CircuitInput<38>> {}; // 
    let in39 = CircuitElement::<CircuitInput<39>> {}; // 
    let in40 = CircuitElement::<CircuitInput<40>> {}; // 
    let in41 = CircuitElement::<CircuitInput<41>> {}; // 
    let in42 = CircuitElement::<CircuitInput<42>> {}; // 
    let in43 = CircuitElement::<CircuitInput<43>> {}; // 
    let in44 = CircuitElement::<CircuitInput<44>> {}; // 
    let in45 = CircuitElement::<CircuitInput<45>> {}; // 
    let in46 = CircuitElement::<CircuitInput<46>> {}; // 
    let in47 = CircuitElement::<CircuitInput<47>> {}; // 

    // FELT stack
    let in48 = CircuitElement::<CircuitInput<48>> {}; // 
    let t0 = circuit_mul(in48, in48);
    let t1 = circuit_mul(t0, in48);
    let t2 = circuit_mul(t1, in48);
    let t3 = circuit_mul(t2, in48);
    let t4 = circuit_mul(t3, in48);
    let t5 = circuit_mul(t4, in48);
    let t6 = circuit_mul(t5, in48);
    let t7 = circuit_mul(t6, in48);
    let t8 = circuit_mul(t7, in48);
    let t9 = circuit_mul(t8, in48);
    let t10 = circuit_mul(in22, in22);
    let t11 = circuit_sub(in5, in9);
    let t12 = circuit_sub(in6, in10);
    let t13 = circuit_sub(in3, in7);
    let t14 = circuit_sub(in4, in8);
    let t15 = circuit_mul(t13, t13);
    let t16 = circuit_mul(t14, t14);
    let t17 = circuit_add(t15, t16);
    let t18 = circuit_inverse(t17);
    let t19 = circuit_mul(t13, t18);
    let t20 = circuit_mul(t14, t18);
    let t21 = circuit_sub(in0, t20);
    let t22 = circuit_mul(t11, t19);
    let t23 = circuit_mul(t12, t21);
    let t24 = circuit_sub(t22, t23);
    let t25 = circuit_mul(t11, t21);
    let t26 = circuit_mul(t12, t19);
    let t27 = circuit_add(t25, t26);
    let t28 = circuit_add(t24, t27);
    let t29 = circuit_sub(t24, t27);
    let t30 = circuit_mul(t28, t29);
    let t31 = circuit_mul(t24, t27);
    let t32 = circuit_add(t31, t31);
    let t33 = circuit_add(in3, in7);
    let t34 = circuit_add(in4, in8);
    let t35 = circuit_sub(t30, t33);
    let t36 = circuit_sub(t32, t34);
    let t37 = circuit_mul(t24, in3);
    let t38 = circuit_mul(t27, in4);
    let t39 = circuit_sub(t37, t38);
    let t40 = circuit_mul(t24, in4);
    let t41 = circuit_mul(t27, in3);
    let t42 = circuit_add(t40, t41);
    let t43 = circuit_sub(t39, in5);
    let t44 = circuit_sub(t42, in6);
    let t45 = circuit_sub(t43, t44);
    let t46 = circuit_mul(t45, in1);
    let t47 = circuit_sub(t24, t27);
    let t48 = circuit_mul(t47, in2);
    let t49 = circuit_mul(t44, in1);
    let t50 = circuit_mul(t27, in2);
    let t51 = circuit_add(in5, in5);
    let t52 = circuit_add(in6, in6);
    let t53 = circuit_sub(t35, in3);
    let t54 = circuit_sub(t36, in4);
    let t55 = circuit_mul(t53, t53);
    let t56 = circuit_mul(t54, t54);
    let t57 = circuit_add(t55, t56);
    let t58 = circuit_inverse(t57);
    let t59 = circuit_mul(t53, t58);
    let t60 = circuit_mul(t54, t58);
    let t61 = circuit_sub(in0, t60);
    let t62 = circuit_mul(t51, t59);
    let t63 = circuit_mul(t52, t61);
    let t64 = circuit_sub(t62, t63);
    let t65 = circuit_mul(t51, t61);
    let t66 = circuit_mul(t52, t59);
    let t67 = circuit_add(t65, t66);
    let t68 = circuit_add(t24, t64);
    let t69 = circuit_add(t27, t67);
    let t70 = circuit_sub(in0, t68);
    let t71 = circuit_sub(in0, t69);
    let t72 = circuit_add(t70, t71);
    let t73 = circuit_sub(t70, t71);
    let t74 = circuit_mul(t72, t73);
    let t75 = circuit_mul(t70, t71);
    let t76 = circuit_add(t75, t75);
    let t77 = circuit_sub(t74, in3);
    let t78 = circuit_sub(t76, in4);
    let t79 = circuit_sub(t77, t35);
    let t80 = circuit_sub(t78, t36);
    let t81 = circuit_sub(in3, t79);
    let t82 = circuit_sub(in4, t80);
    let t83 = circuit_mul(t70, t81);
    let t84 = circuit_mul(t71, t82);
    let t85 = circuit_sub(t83, t84);
    let t86 = circuit_mul(t70, t82);
    let t87 = circuit_mul(t71, t81);
    let t88 = circuit_add(t86, t87);
    let t89 = circuit_sub(t85, in5);
    let t90 = circuit_sub(t88, in6);
    let t91 = circuit_mul(t70, in3);
    let t92 = circuit_mul(t71, in4);
    let t93 = circuit_sub(t91, t92);
    let t94 = circuit_mul(t70, in4);
    let t95 = circuit_mul(t71, in3);
    let t96 = circuit_add(t94, t95);
    let t97 = circuit_sub(t93, in5);
    let t98 = circuit_sub(t96, in6);
    let t99 = circuit_sub(t97, t98);
    let t100 = circuit_mul(t99, in1);
    let t101 = circuit_sub(t70, t71);
    let t102 = circuit_mul(t101, in2);
    let t103 = circuit_mul(t98, in1);
    let t104 = circuit_mul(t71, in2);
    let t105 = circuit_mul(t48, t0);
    let t106 = circuit_add(t46, t105);
    let t107 = circuit_add(t106, t1);
    let t108 = circuit_mul(t49, t4);
    let t109 = circuit_add(t107, t108);
    let t110 = circuit_mul(t50, t6);
    let t111 = circuit_add(t109, t110);
    let t112 = circuit_mul(t10, t111);
    let t113 = circuit_mul(t102, t0);
    let t114 = circuit_add(t100, t113);
    let t115 = circuit_add(t114, t1);
    let t116 = circuit_mul(t103, t4);
    let t117 = circuit_add(t115, t116);
    let t118 = circuit_mul(t104, t6);
    let t119 = circuit_add(t117, t118);
    let t120 = circuit_mul(t112, t119);
    let t121 = circuit_sub(in15, in19);
    let t122 = circuit_sub(in16, in20);
    let t123 = circuit_sub(in13, in17);
    let t124 = circuit_sub(in14, in18);
    let t125 = circuit_mul(t123, t123);
    let t126 = circuit_mul(t124, t124);
    let t127 = circuit_add(t125, t126);
    let t128 = circuit_inverse(t127);
    let t129 = circuit_mul(t123, t128);
    let t130 = circuit_mul(t124, t128);
    let t131 = circuit_sub(in0, t130);
    let t132 = circuit_mul(t121, t129);
    let t133 = circuit_mul(t122, t131);
    let t134 = circuit_sub(t132, t133);
    let t135 = circuit_mul(t121, t131);
    let t136 = circuit_mul(t122, t129);
    let t137 = circuit_add(t135, t136);
    let t138 = circuit_add(t134, t137);
    let t139 = circuit_sub(t134, t137);
    let t140 = circuit_mul(t138, t139);
    let t141 = circuit_mul(t134, t137);
    let t142 = circuit_add(t141, t141);
    let t143 = circuit_add(in13, in17);
    let t144 = circuit_add(in14, in18);
    let t145 = circuit_sub(t140, t143);
    let t146 = circuit_sub(t142, t144);
    let t147 = circuit_mul(t134, in13);
    let t148 = circuit_mul(t137, in14);
    let t149 = circuit_sub(t147, t148);
    let t150 = circuit_mul(t134, in14);
    let t151 = circuit_mul(t137, in13);
    let t152 = circuit_add(t150, t151);
    let t153 = circuit_sub(t149, in15);
    let t154 = circuit_sub(t152, in16);
    let t155 = circuit_sub(t153, t154);
    let t156 = circuit_mul(t155, in11);
    let t157 = circuit_sub(t134, t137);
    let t158 = circuit_mul(t157, in12);
    let t159 = circuit_mul(t154, in11);
    let t160 = circuit_mul(t137, in12);
    let t161 = circuit_add(in15, in15);
    let t162 = circuit_add(in16, in16);
    let t163 = circuit_sub(t145, in13);
    let t164 = circuit_sub(t146, in14);
    let t165 = circuit_mul(t163, t163);
    let t166 = circuit_mul(t164, t164);
    let t167 = circuit_add(t165, t166);
    let t168 = circuit_inverse(t167);
    let t169 = circuit_mul(t163, t168);
    let t170 = circuit_mul(t164, t168);
    let t171 = circuit_sub(in0, t170);
    let t172 = circuit_mul(t161, t169);
    let t173 = circuit_mul(t162, t171);
    let t174 = circuit_sub(t172, t173);
    let t175 = circuit_mul(t161, t171);
    let t176 = circuit_mul(t162, t169);
    let t177 = circuit_add(t175, t176);
    let t178 = circuit_add(t134, t174);
    let t179 = circuit_add(t137, t177);
    let t180 = circuit_sub(in0, t178);
    let t181 = circuit_sub(in0, t179);
    let t182 = circuit_add(t180, t181);
    let t183 = circuit_sub(t180, t181);
    let t184 = circuit_mul(t182, t183);
    let t185 = circuit_mul(t180, t181);
    let t186 = circuit_add(t185, t185);
    let t187 = circuit_sub(t184, in13);
    let t188 = circuit_sub(t186, in14);
    let t189 = circuit_sub(t187, t145);
    let t190 = circuit_sub(t188, t146);
    let t191 = circuit_sub(in13, t189);
    let t192 = circuit_sub(in14, t190);
    let t193 = circuit_mul(t180, t191);
    let t194 = circuit_mul(t181, t192);
    let t195 = circuit_sub(t193, t194);
    let t196 = circuit_mul(t180, t192);
    let t197 = circuit_mul(t181, t191);
    let t198 = circuit_add(t196, t197);
    let t199 = circuit_sub(t195, in15);
    let t200 = circuit_sub(t198, in16);
    let t201 = circuit_mul(t180, in13);
    let t202 = circuit_mul(t181, in14);
    let t203 = circuit_sub(t201, t202);
    let t204 = circuit_mul(t180, in14);
    let t205 = circuit_mul(t181, in13);
    let t206 = circuit_add(t204, t205);
    let t207 = circuit_sub(t203, in15);
    let t208 = circuit_sub(t206, in16);
    let t209 = circuit_sub(t207, t208);
    let t210 = circuit_mul(t209, in11);
    let t211 = circuit_sub(t180, t181);
    let t212 = circuit_mul(t211, in12);
    let t213 = circuit_mul(t208, in11);
    let t214 = circuit_mul(t181, in12);
    let t215 = circuit_mul(t158, t0);
    let t216 = circuit_add(t156, t215);
    let t217 = circuit_add(t216, t1);
    let t218 = circuit_mul(t159, t4);
    let t219 = circuit_add(t217, t218);
    let t220 = circuit_mul(t160, t6);
    let t221 = circuit_add(t219, t220);
    let t222 = circuit_mul(t120, t221);
    let t223 = circuit_mul(t212, t0);
    let t224 = circuit_add(t210, t223);
    let t225 = circuit_add(t224, t1);
    let t226 = circuit_mul(t213, t4);
    let t227 = circuit_add(t225, t226);
    let t228 = circuit_mul(t214, t6);
    let t229 = circuit_add(t227, t228);
    let t230 = circuit_mul(t222, t229);
    let t231 = circuit_mul(in36, in48);
    let t232 = circuit_add(in35, t231);
    let t233 = circuit_mul(in37, t0);
    let t234 = circuit_add(t232, t233);
    let t235 = circuit_mul(in38, t1);
    let t236 = circuit_add(t234, t235);
    let t237 = circuit_mul(in39, t2);
    let t238 = circuit_add(t236, t237);
    let t239 = circuit_mul(in40, t3);
    let t240 = circuit_add(t238, t239);
    let t241 = circuit_mul(in41, t4);
    let t242 = circuit_add(t240, t241);
    let t243 = circuit_mul(in42, t5);
    let t244 = circuit_add(t242, t243);
    let t245 = circuit_mul(in43, t6);
    let t246 = circuit_add(t244, t245);
    let t247 = circuit_mul(in44, t7);
    let t248 = circuit_add(t246, t247);
    let t249 = circuit_mul(in45, t8);
    let t250 = circuit_add(t248, t249);
    let t251 = circuit_mul(in46, t9);
    let t252 = circuit_add(t250, t251);
    let t253 = circuit_mul(t230, t252);
    let t254 = circuit_mul(in24, in48);
    let t255 = circuit_add(in23, t254);
    let t256 = circuit_mul(in25, t0);
    let t257 = circuit_add(t255, t256);
    let t258 = circuit_mul(in26, t1);
    let t259 = circuit_add(t257, t258);
    let t260 = circuit_mul(in27, t2);
    let t261 = circuit_add(t259, t260);
    let t262 = circuit_mul(in28, t3);
    let t263 = circuit_add(t261, t262);
    let t264 = circuit_mul(in29, t4);
    let t265 = circuit_add(t263, t264);
    let t266 = circuit_mul(in30, t5);
    let t267 = circuit_add(t265, t266);
    let t268 = circuit_mul(in31, t6);
    let t269 = circuit_add(t267, t268);
    let t270 = circuit_mul(in32, t7);
    let t271 = circuit_add(t269, t270);
    let t272 = circuit_mul(in33, t8);
    let t273 = circuit_add(t271, t272);
    let t274 = circuit_mul(in34, t9);
    let t275 = circuit_add(t273, t274);
    let t276 = circuit_sub(t253, t275);
    let t277 = circuit_mul(in47, t276);
    let t278 = circuit_add(in21, t277);
    // commit_start_index=48, commit_end_index-1=47
    let p = get_p(1);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t89, t90, t199, t200,).new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t79);
    let o1 = outputs.get_output(t80);
    let o2 = outputs.get_output(t89);
    let o3 = outputs.get_output(t90);
    let o4 = outputs.get_output(t189);
    let o5 = outputs.get_output(t190);
    let o6 = outputs.get_output(t199);
    let o7 = outputs.get_output(t200);
    let o8 = outputs.get_output(t275);
    let o9 = outputs.get_output(t278);

    let res = array![o0, o1, o2, o3, o4, o5, o6, o7, o8, o9];
    return res;
}

fn get_BLS12_381_MP_CHECK_BIT1_LOOP_3_circuit(mut input: Array<u384>) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0

    // INPUT stack
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
    let in9 = CircuitElement::<CircuitInput<9>> {}; // 
    let in10 = CircuitElement::<CircuitInput<10>> {}; // 
    let in11 = CircuitElement::<CircuitInput<11>> {}; // 
    let in12 = CircuitElement::<CircuitInput<12>> {}; // 
    let in13 = CircuitElement::<CircuitInput<13>> {}; // 
    let in14 = CircuitElement::<CircuitInput<14>> {}; // 
    let in15 = CircuitElement::<CircuitInput<15>> {}; // 
    let in16 = CircuitElement::<CircuitInput<16>> {}; // 
    let in17 = CircuitElement::<CircuitInput<17>> {}; // 
    let in18 = CircuitElement::<CircuitInput<18>> {}; // 
    let in19 = CircuitElement::<CircuitInput<19>> {}; // 
    let in20 = CircuitElement::<CircuitInput<20>> {}; // 
    let in21 = CircuitElement::<CircuitInput<21>> {}; // 
    let in22 = CircuitElement::<CircuitInput<22>> {}; // 
    let in23 = CircuitElement::<CircuitInput<23>> {}; // 
    let in24 = CircuitElement::<CircuitInput<24>> {}; // 
    let in25 = CircuitElement::<CircuitInput<25>> {}; // 
    let in26 = CircuitElement::<CircuitInput<26>> {}; // 
    let in27 = CircuitElement::<CircuitInput<27>> {}; // 
    let in28 = CircuitElement::<CircuitInput<28>> {}; // 
    let in29 = CircuitElement::<CircuitInput<29>> {}; // 
    let in30 = CircuitElement::<CircuitInput<30>> {}; // 
    let in31 = CircuitElement::<CircuitInput<31>> {}; // 
    let in32 = CircuitElement::<CircuitInput<32>> {}; // 
    let in33 = CircuitElement::<CircuitInput<33>> {}; // 
    let in34 = CircuitElement::<CircuitInput<34>> {}; // 
    let in35 = CircuitElement::<CircuitInput<35>> {}; // 
    let in36 = CircuitElement::<CircuitInput<36>> {}; // 
    let in37 = CircuitElement::<CircuitInput<37>> {}; // 
    let in38 = CircuitElement::<CircuitInput<38>> {}; // 
    let in39 = CircuitElement::<CircuitInput<39>> {}; // 
    let in40 = CircuitElement::<CircuitInput<40>> {}; // 
    let in41 = CircuitElement::<CircuitInput<41>> {}; // 
    let in42 = CircuitElement::<CircuitInput<42>> {}; // 
    let in43 = CircuitElement::<CircuitInput<43>> {}; // 
    let in44 = CircuitElement::<CircuitInput<44>> {}; // 
    let in45 = CircuitElement::<CircuitInput<45>> {}; // 
    let in46 = CircuitElement::<CircuitInput<46>> {}; // 
    let in47 = CircuitElement::<CircuitInput<47>> {}; // 
    let in48 = CircuitElement::<CircuitInput<48>> {}; // 
    let in49 = CircuitElement::<CircuitInput<49>> {}; // 
    let in50 = CircuitElement::<CircuitInput<50>> {}; // 
    let in51 = CircuitElement::<CircuitInput<51>> {}; // 
    let in52 = CircuitElement::<CircuitInput<52>> {}; // 
    let in53 = CircuitElement::<CircuitInput<53>> {}; // 
    let in54 = CircuitElement::<CircuitInput<54>> {}; // 
    let in55 = CircuitElement::<CircuitInput<55>> {}; // 
    let in56 = CircuitElement::<CircuitInput<56>> {}; // 
    let in57 = CircuitElement::<CircuitInput<57>> {}; // 

    // FELT stack
    let in58 = CircuitElement::<CircuitInput<58>> {}; // 
    let t0 = circuit_mul(in58, in58);
    let t1 = circuit_mul(t0, in58);
    let t2 = circuit_mul(t1, in58);
    let t3 = circuit_mul(t2, in58);
    let t4 = circuit_mul(t3, in58);
    let t5 = circuit_mul(t4, in58);
    let t6 = circuit_mul(t5, in58);
    let t7 = circuit_mul(t6, in58);
    let t8 = circuit_mul(t7, in58);
    let t9 = circuit_mul(t8, in58);
    let t10 = circuit_mul(in32, in32);
    let t11 = circuit_sub(in5, in9);
    let t12 = circuit_sub(in6, in10);
    let t13 = circuit_sub(in3, in7);
    let t14 = circuit_sub(in4, in8);
    let t15 = circuit_mul(t13, t13);
    let t16 = circuit_mul(t14, t14);
    let t17 = circuit_add(t15, t16);
    let t18 = circuit_inverse(t17);
    let t19 = circuit_mul(t13, t18);
    let t20 = circuit_mul(t14, t18);
    let t21 = circuit_sub(in0, t20);
    let t22 = circuit_mul(t11, t19);
    let t23 = circuit_mul(t12, t21);
    let t24 = circuit_sub(t22, t23);
    let t25 = circuit_mul(t11, t21);
    let t26 = circuit_mul(t12, t19);
    let t27 = circuit_add(t25, t26);
    let t28 = circuit_add(t24, t27);
    let t29 = circuit_sub(t24, t27);
    let t30 = circuit_mul(t28, t29);
    let t31 = circuit_mul(t24, t27);
    let t32 = circuit_add(t31, t31);
    let t33 = circuit_add(in3, in7);
    let t34 = circuit_add(in4, in8);
    let t35 = circuit_sub(t30, t33);
    let t36 = circuit_sub(t32, t34);
    let t37 = circuit_mul(t24, in3);
    let t38 = circuit_mul(t27, in4);
    let t39 = circuit_sub(t37, t38);
    let t40 = circuit_mul(t24, in4);
    let t41 = circuit_mul(t27, in3);
    let t42 = circuit_add(t40, t41);
    let t43 = circuit_sub(t39, in5);
    let t44 = circuit_sub(t42, in6);
    let t45 = circuit_sub(t43, t44);
    let t46 = circuit_mul(t45, in1);
    let t47 = circuit_sub(t24, t27);
    let t48 = circuit_mul(t47, in2);
    let t49 = circuit_mul(t44, in1);
    let t50 = circuit_mul(t27, in2);
    let t51 = circuit_add(in5, in5);
    let t52 = circuit_add(in6, in6);
    let t53 = circuit_sub(t35, in3);
    let t54 = circuit_sub(t36, in4);
    let t55 = circuit_mul(t53, t53);
    let t56 = circuit_mul(t54, t54);
    let t57 = circuit_add(t55, t56);
    let t58 = circuit_inverse(t57);
    let t59 = circuit_mul(t53, t58);
    let t60 = circuit_mul(t54, t58);
    let t61 = circuit_sub(in0, t60);
    let t62 = circuit_mul(t51, t59);
    let t63 = circuit_mul(t52, t61);
    let t64 = circuit_sub(t62, t63);
    let t65 = circuit_mul(t51, t61);
    let t66 = circuit_mul(t52, t59);
    let t67 = circuit_add(t65, t66);
    let t68 = circuit_add(t24, t64);
    let t69 = circuit_add(t27, t67);
    let t70 = circuit_sub(in0, t68);
    let t71 = circuit_sub(in0, t69);
    let t72 = circuit_add(t70, t71);
    let t73 = circuit_sub(t70, t71);
    let t74 = circuit_mul(t72, t73);
    let t75 = circuit_mul(t70, t71);
    let t76 = circuit_add(t75, t75);
    let t77 = circuit_sub(t74, in3);
    let t78 = circuit_sub(t76, in4);
    let t79 = circuit_sub(t77, t35);
    let t80 = circuit_sub(t78, t36);
    let t81 = circuit_sub(in3, t79);
    let t82 = circuit_sub(in4, t80);
    let t83 = circuit_mul(t70, t81);
    let t84 = circuit_mul(t71, t82);
    let t85 = circuit_sub(t83, t84);
    let t86 = circuit_mul(t70, t82);
    let t87 = circuit_mul(t71, t81);
    let t88 = circuit_add(t86, t87);
    let t89 = circuit_sub(t85, in5);
    let t90 = circuit_sub(t88, in6);
    let t91 = circuit_mul(t70, in3);
    let t92 = circuit_mul(t71, in4);
    let t93 = circuit_sub(t91, t92);
    let t94 = circuit_mul(t70, in4);
    let t95 = circuit_mul(t71, in3);
    let t96 = circuit_add(t94, t95);
    let t97 = circuit_sub(t93, in5);
    let t98 = circuit_sub(t96, in6);
    let t99 = circuit_sub(t97, t98);
    let t100 = circuit_mul(t99, in1);
    let t101 = circuit_sub(t70, t71);
    let t102 = circuit_mul(t101, in2);
    let t103 = circuit_mul(t98, in1);
    let t104 = circuit_mul(t71, in2);
    let t105 = circuit_mul(t48, t0);
    let t106 = circuit_add(t46, t105);
    let t107 = circuit_add(t106, t1);
    let t108 = circuit_mul(t49, t4);
    let t109 = circuit_add(t107, t108);
    let t110 = circuit_mul(t50, t6);
    let t111 = circuit_add(t109, t110);
    let t112 = circuit_mul(t10, t111);
    let t113 = circuit_mul(t102, t0);
    let t114 = circuit_add(t100, t113);
    let t115 = circuit_add(t114, t1);
    let t116 = circuit_mul(t103, t4);
    let t117 = circuit_add(t115, t116);
    let t118 = circuit_mul(t104, t6);
    let t119 = circuit_add(t117, t118);
    let t120 = circuit_mul(t112, t119);
    let t121 = circuit_sub(in15, in19);
    let t122 = circuit_sub(in16, in20);
    let t123 = circuit_sub(in13, in17);
    let t124 = circuit_sub(in14, in18);
    let t125 = circuit_mul(t123, t123);
    let t126 = circuit_mul(t124, t124);
    let t127 = circuit_add(t125, t126);
    let t128 = circuit_inverse(t127);
    let t129 = circuit_mul(t123, t128);
    let t130 = circuit_mul(t124, t128);
    let t131 = circuit_sub(in0, t130);
    let t132 = circuit_mul(t121, t129);
    let t133 = circuit_mul(t122, t131);
    let t134 = circuit_sub(t132, t133);
    let t135 = circuit_mul(t121, t131);
    let t136 = circuit_mul(t122, t129);
    let t137 = circuit_add(t135, t136);
    let t138 = circuit_add(t134, t137);
    let t139 = circuit_sub(t134, t137);
    let t140 = circuit_mul(t138, t139);
    let t141 = circuit_mul(t134, t137);
    let t142 = circuit_add(t141, t141);
    let t143 = circuit_add(in13, in17);
    let t144 = circuit_add(in14, in18);
    let t145 = circuit_sub(t140, t143);
    let t146 = circuit_sub(t142, t144);
    let t147 = circuit_mul(t134, in13);
    let t148 = circuit_mul(t137, in14);
    let t149 = circuit_sub(t147, t148);
    let t150 = circuit_mul(t134, in14);
    let t151 = circuit_mul(t137, in13);
    let t152 = circuit_add(t150, t151);
    let t153 = circuit_sub(t149, in15);
    let t154 = circuit_sub(t152, in16);
    let t155 = circuit_sub(t153, t154);
    let t156 = circuit_mul(t155, in11);
    let t157 = circuit_sub(t134, t137);
    let t158 = circuit_mul(t157, in12);
    let t159 = circuit_mul(t154, in11);
    let t160 = circuit_mul(t137, in12);
    let t161 = circuit_add(in15, in15);
    let t162 = circuit_add(in16, in16);
    let t163 = circuit_sub(t145, in13);
    let t164 = circuit_sub(t146, in14);
    let t165 = circuit_mul(t163, t163);
    let t166 = circuit_mul(t164, t164);
    let t167 = circuit_add(t165, t166);
    let t168 = circuit_inverse(t167);
    let t169 = circuit_mul(t163, t168);
    let t170 = circuit_mul(t164, t168);
    let t171 = circuit_sub(in0, t170);
    let t172 = circuit_mul(t161, t169);
    let t173 = circuit_mul(t162, t171);
    let t174 = circuit_sub(t172, t173);
    let t175 = circuit_mul(t161, t171);
    let t176 = circuit_mul(t162, t169);
    let t177 = circuit_add(t175, t176);
    let t178 = circuit_add(t134, t174);
    let t179 = circuit_add(t137, t177);
    let t180 = circuit_sub(in0, t178);
    let t181 = circuit_sub(in0, t179);
    let t182 = circuit_add(t180, t181);
    let t183 = circuit_sub(t180, t181);
    let t184 = circuit_mul(t182, t183);
    let t185 = circuit_mul(t180, t181);
    let t186 = circuit_add(t185, t185);
    let t187 = circuit_sub(t184, in13);
    let t188 = circuit_sub(t186, in14);
    let t189 = circuit_sub(t187, t145);
    let t190 = circuit_sub(t188, t146);
    let t191 = circuit_sub(in13, t189);
    let t192 = circuit_sub(in14, t190);
    let t193 = circuit_mul(t180, t191);
    let t194 = circuit_mul(t181, t192);
    let t195 = circuit_sub(t193, t194);
    let t196 = circuit_mul(t180, t192);
    let t197 = circuit_mul(t181, t191);
    let t198 = circuit_add(t196, t197);
    let t199 = circuit_sub(t195, in15);
    let t200 = circuit_sub(t198, in16);
    let t201 = circuit_mul(t180, in13);
    let t202 = circuit_mul(t181, in14);
    let t203 = circuit_sub(t201, t202);
    let t204 = circuit_mul(t180, in14);
    let t205 = circuit_mul(t181, in13);
    let t206 = circuit_add(t204, t205);
    let t207 = circuit_sub(t203, in15);
    let t208 = circuit_sub(t206, in16);
    let t209 = circuit_sub(t207, t208);
    let t210 = circuit_mul(t209, in11);
    let t211 = circuit_sub(t180, t181);
    let t212 = circuit_mul(t211, in12);
    let t213 = circuit_mul(t208, in11);
    let t214 = circuit_mul(t181, in12);
    let t215 = circuit_mul(t158, t0);
    let t216 = circuit_add(t156, t215);
    let t217 = circuit_add(t216, t1);
    let t218 = circuit_mul(t159, t4);
    let t219 = circuit_add(t217, t218);
    let t220 = circuit_mul(t160, t6);
    let t221 = circuit_add(t219, t220);
    let t222 = circuit_mul(t120, t221);
    let t223 = circuit_mul(t212, t0);
    let t224 = circuit_add(t210, t223);
    let t225 = circuit_add(t224, t1);
    let t226 = circuit_mul(t213, t4);
    let t227 = circuit_add(t225, t226);
    let t228 = circuit_mul(t214, t6);
    let t229 = circuit_add(t227, t228);
    let t230 = circuit_mul(t222, t229);
    let t231 = circuit_sub(in25, in29);
    let t232 = circuit_sub(in26, in30);
    let t233 = circuit_sub(in23, in27);
    let t234 = circuit_sub(in24, in28);
    let t235 = circuit_mul(t233, t233);
    let t236 = circuit_mul(t234, t234);
    let t237 = circuit_add(t235, t236);
    let t238 = circuit_inverse(t237);
    let t239 = circuit_mul(t233, t238);
    let t240 = circuit_mul(t234, t238);
    let t241 = circuit_sub(in0, t240);
    let t242 = circuit_mul(t231, t239);
    let t243 = circuit_mul(t232, t241);
    let t244 = circuit_sub(t242, t243);
    let t245 = circuit_mul(t231, t241);
    let t246 = circuit_mul(t232, t239);
    let t247 = circuit_add(t245, t246);
    let t248 = circuit_add(t244, t247);
    let t249 = circuit_sub(t244, t247);
    let t250 = circuit_mul(t248, t249);
    let t251 = circuit_mul(t244, t247);
    let t252 = circuit_add(t251, t251);
    let t253 = circuit_add(in23, in27);
    let t254 = circuit_add(in24, in28);
    let t255 = circuit_sub(t250, t253);
    let t256 = circuit_sub(t252, t254);
    let t257 = circuit_mul(t244, in23);
    let t258 = circuit_mul(t247, in24);
    let t259 = circuit_sub(t257, t258);
    let t260 = circuit_mul(t244, in24);
    let t261 = circuit_mul(t247, in23);
    let t262 = circuit_add(t260, t261);
    let t263 = circuit_sub(t259, in25);
    let t264 = circuit_sub(t262, in26);
    let t265 = circuit_sub(t263, t264);
    let t266 = circuit_mul(t265, in21);
    let t267 = circuit_sub(t244, t247);
    let t268 = circuit_mul(t267, in22);
    let t269 = circuit_mul(t264, in21);
    let t270 = circuit_mul(t247, in22);
    let t271 = circuit_add(in25, in25);
    let t272 = circuit_add(in26, in26);
    let t273 = circuit_sub(t255, in23);
    let t274 = circuit_sub(t256, in24);
    let t275 = circuit_mul(t273, t273);
    let t276 = circuit_mul(t274, t274);
    let t277 = circuit_add(t275, t276);
    let t278 = circuit_inverse(t277);
    let t279 = circuit_mul(t273, t278);
    let t280 = circuit_mul(t274, t278);
    let t281 = circuit_sub(in0, t280);
    let t282 = circuit_mul(t271, t279);
    let t283 = circuit_mul(t272, t281);
    let t284 = circuit_sub(t282, t283);
    let t285 = circuit_mul(t271, t281);
    let t286 = circuit_mul(t272, t279);
    let t287 = circuit_add(t285, t286);
    let t288 = circuit_add(t244, t284);
    let t289 = circuit_add(t247, t287);
    let t290 = circuit_sub(in0, t288);
    let t291 = circuit_sub(in0, t289);
    let t292 = circuit_add(t290, t291);
    let t293 = circuit_sub(t290, t291);
    let t294 = circuit_mul(t292, t293);
    let t295 = circuit_mul(t290, t291);
    let t296 = circuit_add(t295, t295);
    let t297 = circuit_sub(t294, in23);
    let t298 = circuit_sub(t296, in24);
    let t299 = circuit_sub(t297, t255);
    let t300 = circuit_sub(t298, t256);
    let t301 = circuit_sub(in23, t299);
    let t302 = circuit_sub(in24, t300);
    let t303 = circuit_mul(t290, t301);
    let t304 = circuit_mul(t291, t302);
    let t305 = circuit_sub(t303, t304);
    let t306 = circuit_mul(t290, t302);
    let t307 = circuit_mul(t291, t301);
    let t308 = circuit_add(t306, t307);
    let t309 = circuit_sub(t305, in25);
    let t310 = circuit_sub(t308, in26);
    let t311 = circuit_mul(t290, in23);
    let t312 = circuit_mul(t291, in24);
    let t313 = circuit_sub(t311, t312);
    let t314 = circuit_mul(t290, in24);
    let t315 = circuit_mul(t291, in23);
    let t316 = circuit_add(t314, t315);
    let t317 = circuit_sub(t313, in25);
    let t318 = circuit_sub(t316, in26);
    let t319 = circuit_sub(t317, t318);
    let t320 = circuit_mul(t319, in21);
    let t321 = circuit_sub(t290, t291);
    let t322 = circuit_mul(t321, in22);
    let t323 = circuit_mul(t318, in21);
    let t324 = circuit_mul(t291, in22);
    let t325 = circuit_mul(t268, t0);
    let t326 = circuit_add(t266, t325);
    let t327 = circuit_add(t326, t1);
    let t328 = circuit_mul(t269, t4);
    let t329 = circuit_add(t327, t328);
    let t330 = circuit_mul(t270, t6);
    let t331 = circuit_add(t329, t330);
    let t332 = circuit_mul(t230, t331);
    let t333 = circuit_mul(t322, t0);
    let t334 = circuit_add(t320, t333);
    let t335 = circuit_add(t334, t1);
    let t336 = circuit_mul(t323, t4);
    let t337 = circuit_add(t335, t336);
    let t338 = circuit_mul(t324, t6);
    let t339 = circuit_add(t337, t338);
    let t340 = circuit_mul(t332, t339);
    let t341 = circuit_mul(in46, in58);
    let t342 = circuit_add(in45, t341);
    let t343 = circuit_mul(in47, t0);
    let t344 = circuit_add(t342, t343);
    let t345 = circuit_mul(in48, t1);
    let t346 = circuit_add(t344, t345);
    let t347 = circuit_mul(in49, t2);
    let t348 = circuit_add(t346, t347);
    let t349 = circuit_mul(in50, t3);
    let t350 = circuit_add(t348, t349);
    let t351 = circuit_mul(in51, t4);
    let t352 = circuit_add(t350, t351);
    let t353 = circuit_mul(in52, t5);
    let t354 = circuit_add(t352, t353);
    let t355 = circuit_mul(in53, t6);
    let t356 = circuit_add(t354, t355);
    let t357 = circuit_mul(in54, t7);
    let t358 = circuit_add(t356, t357);
    let t359 = circuit_mul(in55, t8);
    let t360 = circuit_add(t358, t359);
    let t361 = circuit_mul(in56, t9);
    let t362 = circuit_add(t360, t361);
    let t363 = circuit_mul(t340, t362);
    let t364 = circuit_mul(in34, in58);
    let t365 = circuit_add(in33, t364);
    let t366 = circuit_mul(in35, t0);
    let t367 = circuit_add(t365, t366);
    let t368 = circuit_mul(in36, t1);
    let t369 = circuit_add(t367, t368);
    let t370 = circuit_mul(in37, t2);
    let t371 = circuit_add(t369, t370);
    let t372 = circuit_mul(in38, t3);
    let t373 = circuit_add(t371, t372);
    let t374 = circuit_mul(in39, t4);
    let t375 = circuit_add(t373, t374);
    let t376 = circuit_mul(in40, t5);
    let t377 = circuit_add(t375, t376);
    let t378 = circuit_mul(in41, t6);
    let t379 = circuit_add(t377, t378);
    let t380 = circuit_mul(in42, t7);
    let t381 = circuit_add(t379, t380);
    let t382 = circuit_mul(in43, t8);
    let t383 = circuit_add(t381, t382);
    let t384 = circuit_mul(in44, t9);
    let t385 = circuit_add(t383, t384);
    let t386 = circuit_sub(t363, t385);
    let t387 = circuit_mul(in57, t386);
    let t388 = circuit_add(in31, t387);
    // commit_start_index=58, commit_end_index-1=57
    let p = get_p(1);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t89, t90, t199, t200, t309, t310,).new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t79);
    let o1 = outputs.get_output(t80);
    let o2 = outputs.get_output(t89);
    let o3 = outputs.get_output(t90);
    let o4 = outputs.get_output(t189);
    let o5 = outputs.get_output(t190);
    let o6 = outputs.get_output(t199);
    let o7 = outputs.get_output(t200);
    let o8 = outputs.get_output(t299);
    let o9 = outputs.get_output(t300);
    let o10 = outputs.get_output(t309);
    let o11 = outputs.get_output(t310);
    let o12 = outputs.get_output(t385);
    let o13 = outputs.get_output(t388);

    let res = array![o0, o1, o2, o3, o4, o5, o6, o7, o8, o9, o10, o11, o12, o13];
    return res;
}

fn get_BN254_MP_CHECK_BIT0_LOOP_2_circuit(mut input: Array<u384>) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 3
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 6
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 0
    let in3 = CircuitElement::<
        CircuitInput<3>
    > {}; // 21888242871839275222246405745257275088696311157297823662689037894645226208574

    // INPUT stack
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
    let in9 = CircuitElement::<CircuitInput<9>> {}; // 
    let in10 = CircuitElement::<CircuitInput<10>> {}; // 
    let in11 = CircuitElement::<CircuitInput<11>> {}; // 
    let in12 = CircuitElement::<CircuitInput<12>> {}; // 
    let in13 = CircuitElement::<CircuitInput<13>> {}; // 
    let in14 = CircuitElement::<CircuitInput<14>> {}; // 
    let in15 = CircuitElement::<CircuitInput<15>> {}; // 
    let in16 = CircuitElement::<CircuitInput<16>> {}; // 
    let in17 = CircuitElement::<CircuitInput<17>> {}; // 
    let in18 = CircuitElement::<CircuitInput<18>> {}; // 
    let in19 = CircuitElement::<CircuitInput<19>> {}; // 
    let in20 = CircuitElement::<CircuitInput<20>> {}; // 
    let in21 = CircuitElement::<CircuitInput<21>> {}; // 
    let in22 = CircuitElement::<CircuitInput<22>> {}; // 
    let in23 = CircuitElement::<CircuitInput<23>> {}; // 
    let in24 = CircuitElement::<CircuitInput<24>> {}; // 
    let in25 = CircuitElement::<CircuitInput<25>> {}; // 
    let in26 = CircuitElement::<CircuitInput<26>> {}; // 
    let in27 = CircuitElement::<CircuitInput<27>> {}; // 
    let in28 = CircuitElement::<CircuitInput<28>> {}; // 
    let in29 = CircuitElement::<CircuitInput<29>> {}; // 
    let in30 = CircuitElement::<CircuitInput<30>> {}; // 

    // FELT stack
    let in31 = CircuitElement::<CircuitInput<31>> {}; // 
    let t0 = circuit_mul(in31, in31);
    let t1 = circuit_mul(t0, in31);
    let t2 = circuit_mul(t1, in31);
    let t3 = circuit_mul(t2, in31);
    let t4 = circuit_mul(t3, in31);
    let t5 = circuit_mul(t4, in31);
    let t6 = circuit_mul(t5, in31);
    let t7 = circuit_mul(t6, in31);
    let t8 = circuit_mul(t7, in31);
    let t9 = circuit_mul(t8, in31);
    let t10 = circuit_mul(in17, in17);
    let t11 = circuit_add(in6, in7);
    let t12 = circuit_sub(in6, in7);
    let t13 = circuit_mul(t11, t12);
    let t14 = circuit_mul(in6, in7);
    let t15 = circuit_mul(t13, in0);
    let t16 = circuit_mul(t14, in1);
    let t17 = circuit_add(in8, in8);
    let t18 = circuit_add(in9, in9);
    let t19 = circuit_mul(t17, t17);
    let t20 = circuit_mul(t18, t18);
    let t21 = circuit_add(t19, t20);
    let t22 = circuit_inverse(t21);
    let t23 = circuit_mul(t17, t22);
    let t24 = circuit_mul(t18, t22);
    let t25 = circuit_sub(in2, t24);
    let t26 = circuit_mul(t15, t23);
    let t27 = circuit_mul(t16, t25);
    let t28 = circuit_sub(t26, t27);
    let t29 = circuit_mul(t15, t25);
    let t30 = circuit_mul(t16, t23);
    let t31 = circuit_add(t29, t30);
    let t32 = circuit_add(t28, t31);
    let t33 = circuit_sub(t28, t31);
    let t34 = circuit_mul(t32, t33);
    let t35 = circuit_mul(t28, t31);
    let t36 = circuit_add(t35, t35);
    let t37 = circuit_add(in6, in6);
    let t38 = circuit_add(in7, in7);
    let t39 = circuit_sub(t34, t37);
    let t40 = circuit_sub(t36, t38);
    let t41 = circuit_sub(in6, t39);
    let t42 = circuit_sub(in7, t40);
    let t43 = circuit_mul(t28, t41);
    let t44 = circuit_mul(t31, t42);
    let t45 = circuit_sub(t43, t44);
    let t46 = circuit_mul(t28, t42);
    let t47 = circuit_mul(t31, t41);
    let t48 = circuit_add(t46, t47);
    let t49 = circuit_sub(t45, in8);
    let t50 = circuit_sub(t48, in9);
    let t51 = circuit_mul(t28, in6);
    let t52 = circuit_mul(t31, in7);
    let t53 = circuit_sub(t51, t52);
    let t54 = circuit_mul(t28, in7);
    let t55 = circuit_mul(t31, in6);
    let t56 = circuit_add(t54, t55);
    let t57 = circuit_sub(t53, in8);
    let t58 = circuit_sub(t56, in9);
    let t59 = circuit_mul(in3, t31);
    let t60 = circuit_add(t28, t59);
    let t61 = circuit_mul(t60, in5);
    let t62 = circuit_mul(in3, t58);
    let t63 = circuit_add(t57, t62);
    let t64 = circuit_mul(t63, in4);
    let t65 = circuit_mul(t31, in5);
    let t66 = circuit_mul(t58, in4);
    let t67 = circuit_mul(t61, in31);
    let t68 = circuit_add(in4, t67);
    let t69 = circuit_mul(t64, t1);
    let t70 = circuit_add(t68, t69);
    let t71 = circuit_mul(t65, t5);
    let t72 = circuit_add(t70, t71);
    let t73 = circuit_mul(t66, t7);
    let t74 = circuit_add(t72, t73);
    let t75 = circuit_mul(t10, t74);
    let t76 = circuit_add(in12, in13);
    let t77 = circuit_sub(in12, in13);
    let t78 = circuit_mul(t76, t77);
    let t79 = circuit_mul(in12, in13);
    let t80 = circuit_mul(t78, in0);
    let t81 = circuit_mul(t79, in1);
    let t82 = circuit_add(in14, in14);
    let t83 = circuit_add(in15, in15);
    let t84 = circuit_mul(t82, t82);
    let t85 = circuit_mul(t83, t83);
    let t86 = circuit_add(t84, t85);
    let t87 = circuit_inverse(t86);
    let t88 = circuit_mul(t82, t87);
    let t89 = circuit_mul(t83, t87);
    let t90 = circuit_sub(in2, t89);
    let t91 = circuit_mul(t80, t88);
    let t92 = circuit_mul(t81, t90);
    let t93 = circuit_sub(t91, t92);
    let t94 = circuit_mul(t80, t90);
    let t95 = circuit_mul(t81, t88);
    let t96 = circuit_add(t94, t95);
    let t97 = circuit_add(t93, t96);
    let t98 = circuit_sub(t93, t96);
    let t99 = circuit_mul(t97, t98);
    let t100 = circuit_mul(t93, t96);
    let t101 = circuit_add(t100, t100);
    let t102 = circuit_add(in12, in12);
    let t103 = circuit_add(in13, in13);
    let t104 = circuit_sub(t99, t102);
    let t105 = circuit_sub(t101, t103);
    let t106 = circuit_sub(in12, t104);
    let t107 = circuit_sub(in13, t105);
    let t108 = circuit_mul(t93, t106);
    let t109 = circuit_mul(t96, t107);
    let t110 = circuit_sub(t108, t109);
    let t111 = circuit_mul(t93, t107);
    let t112 = circuit_mul(t96, t106);
    let t113 = circuit_add(t111, t112);
    let t114 = circuit_sub(t110, in14);
    let t115 = circuit_sub(t113, in15);
    let t116 = circuit_mul(t93, in12);
    let t117 = circuit_mul(t96, in13);
    let t118 = circuit_sub(t116, t117);
    let t119 = circuit_mul(t93, in13);
    let t120 = circuit_mul(t96, in12);
    let t121 = circuit_add(t119, t120);
    let t122 = circuit_sub(t118, in14);
    let t123 = circuit_sub(t121, in15);
    let t124 = circuit_mul(in3, t96);
    let t125 = circuit_add(t93, t124);
    let t126 = circuit_mul(t125, in11);
    let t127 = circuit_mul(in3, t123);
    let t128 = circuit_add(t122, t127);
    let t129 = circuit_mul(t128, in10);
    let t130 = circuit_mul(t96, in11);
    let t131 = circuit_mul(t123, in10);
    let t132 = circuit_mul(t126, in31);
    let t133 = circuit_add(in4, t132);
    let t134 = circuit_mul(t129, t1);
    let t135 = circuit_add(t133, t134);
    let t136 = circuit_mul(t130, t5);
    let t137 = circuit_add(t135, t136);
    let t138 = circuit_mul(t131, t7);
    let t139 = circuit_add(t137, t138);
    let t140 = circuit_mul(t75, t139);
    let t141 = circuit_mul(in19, in31);
    let t142 = circuit_add(in18, t141);
    let t143 = circuit_mul(in20, t0);
    let t144 = circuit_add(t142, t143);
    let t145 = circuit_mul(in21, t1);
    let t146 = circuit_add(t144, t145);
    let t147 = circuit_mul(in22, t2);
    let t148 = circuit_add(t146, t147);
    let t149 = circuit_mul(in23, t3);
    let t150 = circuit_add(t148, t149);
    let t151 = circuit_mul(in24, t4);
    let t152 = circuit_add(t150, t151);
    let t153 = circuit_mul(in25, t5);
    let t154 = circuit_add(t152, t153);
    let t155 = circuit_mul(in26, t6);
    let t156 = circuit_add(t154, t155);
    let t157 = circuit_mul(in27, t7);
    let t158 = circuit_add(t156, t157);
    let t159 = circuit_mul(in28, t8);
    let t160 = circuit_add(t158, t159);
    let t161 = circuit_mul(in29, t9);
    let t162 = circuit_add(t160, t161);
    let t163 = circuit_sub(t140, t162);
    let t164 = circuit_mul(in30, t163);
    let t165 = circuit_add(in16, t164);
    // commit_start_index=31, commit_end_index-1=30
    let p = get_p(0);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t48, t49, t114, t115,).new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t39);
    let o1 = outputs.get_output(t40);
    let o2 = outputs.get_output(t49);
    let o3 = outputs.get_output(t50);
    let o4 = outputs.get_output(t104);
    let o5 = outputs.get_output(t105);
    let o6 = outputs.get_output(t114);
    let o7 = outputs.get_output(t115);
    let o8 = outputs.get_output(t162);
    let o9 = outputs.get_output(t165);

    let res = array![o0, o1, o2, o3, o4, o5, o6, o7, o8, o9];
    return res;
}

fn get_BN254_MP_CHECK_BIT0_LOOP_3_circuit(mut input: Array<u384>) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 3
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 6
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 0
    let in3 = CircuitElement::<
        CircuitInput<3>
    > {}; // 21888242871839275222246405745257275088696311157297823662689037894645226208574

    // INPUT stack
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
    let in9 = CircuitElement::<CircuitInput<9>> {}; // 
    let in10 = CircuitElement::<CircuitInput<10>> {}; // 
    let in11 = CircuitElement::<CircuitInput<11>> {}; // 
    let in12 = CircuitElement::<CircuitInput<12>> {}; // 
    let in13 = CircuitElement::<CircuitInput<13>> {}; // 
    let in14 = CircuitElement::<CircuitInput<14>> {}; // 
    let in15 = CircuitElement::<CircuitInput<15>> {}; // 
    let in16 = CircuitElement::<CircuitInput<16>> {}; // 
    let in17 = CircuitElement::<CircuitInput<17>> {}; // 
    let in18 = CircuitElement::<CircuitInput<18>> {}; // 
    let in19 = CircuitElement::<CircuitInput<19>> {}; // 
    let in20 = CircuitElement::<CircuitInput<20>> {}; // 
    let in21 = CircuitElement::<CircuitInput<21>> {}; // 
    let in22 = CircuitElement::<CircuitInput<22>> {}; // 
    let in23 = CircuitElement::<CircuitInput<23>> {}; // 
    let in24 = CircuitElement::<CircuitInput<24>> {}; // 
    let in25 = CircuitElement::<CircuitInput<25>> {}; // 
    let in26 = CircuitElement::<CircuitInput<26>> {}; // 
    let in27 = CircuitElement::<CircuitInput<27>> {}; // 
    let in28 = CircuitElement::<CircuitInput<28>> {}; // 
    let in29 = CircuitElement::<CircuitInput<29>> {}; // 
    let in30 = CircuitElement::<CircuitInput<30>> {}; // 
    let in31 = CircuitElement::<CircuitInput<31>> {}; // 
    let in32 = CircuitElement::<CircuitInput<32>> {}; // 
    let in33 = CircuitElement::<CircuitInput<33>> {}; // 
    let in34 = CircuitElement::<CircuitInput<34>> {}; // 
    let in35 = CircuitElement::<CircuitInput<35>> {}; // 
    let in36 = CircuitElement::<CircuitInput<36>> {}; // 

    // FELT stack
    let in37 = CircuitElement::<CircuitInput<37>> {}; // 
    let t0 = circuit_mul(in37, in37);
    let t1 = circuit_mul(t0, in37);
    let t2 = circuit_mul(t1, in37);
    let t3 = circuit_mul(t2, in37);
    let t4 = circuit_mul(t3, in37);
    let t5 = circuit_mul(t4, in37);
    let t6 = circuit_mul(t5, in37);
    let t7 = circuit_mul(t6, in37);
    let t8 = circuit_mul(t7, in37);
    let t9 = circuit_mul(t8, in37);
    let t10 = circuit_mul(in23, in23);
    let t11 = circuit_add(in6, in7);
    let t12 = circuit_sub(in6, in7);
    let t13 = circuit_mul(t11, t12);
    let t14 = circuit_mul(in6, in7);
    let t15 = circuit_mul(t13, in0);
    let t16 = circuit_mul(t14, in1);
    let t17 = circuit_add(in8, in8);
    let t18 = circuit_add(in9, in9);
    let t19 = circuit_mul(t17, t17);
    let t20 = circuit_mul(t18, t18);
    let t21 = circuit_add(t19, t20);
    let t22 = circuit_inverse(t21);
    let t23 = circuit_mul(t17, t22);
    let t24 = circuit_mul(t18, t22);
    let t25 = circuit_sub(in2, t24);
    let t26 = circuit_mul(t15, t23);
    let t27 = circuit_mul(t16, t25);
    let t28 = circuit_sub(t26, t27);
    let t29 = circuit_mul(t15, t25);
    let t30 = circuit_mul(t16, t23);
    let t31 = circuit_add(t29, t30);
    let t32 = circuit_add(t28, t31);
    let t33 = circuit_sub(t28, t31);
    let t34 = circuit_mul(t32, t33);
    let t35 = circuit_mul(t28, t31);
    let t36 = circuit_add(t35, t35);
    let t37 = circuit_add(in6, in6);
    let t38 = circuit_add(in7, in7);
    let t39 = circuit_sub(t34, t37);
    let t40 = circuit_sub(t36, t38);
    let t41 = circuit_sub(in6, t39);
    let t42 = circuit_sub(in7, t40);
    let t43 = circuit_mul(t28, t41);
    let t44 = circuit_mul(t31, t42);
    let t45 = circuit_sub(t43, t44);
    let t46 = circuit_mul(t28, t42);
    let t47 = circuit_mul(t31, t41);
    let t48 = circuit_add(t46, t47);
    let t49 = circuit_sub(t45, in8);
    let t50 = circuit_sub(t48, in9);
    let t51 = circuit_mul(t28, in6);
    let t52 = circuit_mul(t31, in7);
    let t53 = circuit_sub(t51, t52);
    let t54 = circuit_mul(t28, in7);
    let t55 = circuit_mul(t31, in6);
    let t56 = circuit_add(t54, t55);
    let t57 = circuit_sub(t53, in8);
    let t58 = circuit_sub(t56, in9);
    let t59 = circuit_mul(in3, t31);
    let t60 = circuit_add(t28, t59);
    let t61 = circuit_mul(t60, in5);
    let t62 = circuit_mul(in3, t58);
    let t63 = circuit_add(t57, t62);
    let t64 = circuit_mul(t63, in4);
    let t65 = circuit_mul(t31, in5);
    let t66 = circuit_mul(t58, in4);
    let t67 = circuit_mul(t61, in37);
    let t68 = circuit_add(in4, t67);
    let t69 = circuit_mul(t64, t1);
    let t70 = circuit_add(t68, t69);
    let t71 = circuit_mul(t65, t5);
    let t72 = circuit_add(t70, t71);
    let t73 = circuit_mul(t66, t7);
    let t74 = circuit_add(t72, t73);
    let t75 = circuit_mul(t10, t74);
    let t76 = circuit_add(in12, in13);
    let t77 = circuit_sub(in12, in13);
    let t78 = circuit_mul(t76, t77);
    let t79 = circuit_mul(in12, in13);
    let t80 = circuit_mul(t78, in0);
    let t81 = circuit_mul(t79, in1);
    let t82 = circuit_add(in14, in14);
    let t83 = circuit_add(in15, in15);
    let t84 = circuit_mul(t82, t82);
    let t85 = circuit_mul(t83, t83);
    let t86 = circuit_add(t84, t85);
    let t87 = circuit_inverse(t86);
    let t88 = circuit_mul(t82, t87);
    let t89 = circuit_mul(t83, t87);
    let t90 = circuit_sub(in2, t89);
    let t91 = circuit_mul(t80, t88);
    let t92 = circuit_mul(t81, t90);
    let t93 = circuit_sub(t91, t92);
    let t94 = circuit_mul(t80, t90);
    let t95 = circuit_mul(t81, t88);
    let t96 = circuit_add(t94, t95);
    let t97 = circuit_add(t93, t96);
    let t98 = circuit_sub(t93, t96);
    let t99 = circuit_mul(t97, t98);
    let t100 = circuit_mul(t93, t96);
    let t101 = circuit_add(t100, t100);
    let t102 = circuit_add(in12, in12);
    let t103 = circuit_add(in13, in13);
    let t104 = circuit_sub(t99, t102);
    let t105 = circuit_sub(t101, t103);
    let t106 = circuit_sub(in12, t104);
    let t107 = circuit_sub(in13, t105);
    let t108 = circuit_mul(t93, t106);
    let t109 = circuit_mul(t96, t107);
    let t110 = circuit_sub(t108, t109);
    let t111 = circuit_mul(t93, t107);
    let t112 = circuit_mul(t96, t106);
    let t113 = circuit_add(t111, t112);
    let t114 = circuit_sub(t110, in14);
    let t115 = circuit_sub(t113, in15);
    let t116 = circuit_mul(t93, in12);
    let t117 = circuit_mul(t96, in13);
    let t118 = circuit_sub(t116, t117);
    let t119 = circuit_mul(t93, in13);
    let t120 = circuit_mul(t96, in12);
    let t121 = circuit_add(t119, t120);
    let t122 = circuit_sub(t118, in14);
    let t123 = circuit_sub(t121, in15);
    let t124 = circuit_mul(in3, t96);
    let t125 = circuit_add(t93, t124);
    let t126 = circuit_mul(t125, in11);
    let t127 = circuit_mul(in3, t123);
    let t128 = circuit_add(t122, t127);
    let t129 = circuit_mul(t128, in10);
    let t130 = circuit_mul(t96, in11);
    let t131 = circuit_mul(t123, in10);
    let t132 = circuit_mul(t126, in37);
    let t133 = circuit_add(in4, t132);
    let t134 = circuit_mul(t129, t1);
    let t135 = circuit_add(t133, t134);
    let t136 = circuit_mul(t130, t5);
    let t137 = circuit_add(t135, t136);
    let t138 = circuit_mul(t131, t7);
    let t139 = circuit_add(t137, t138);
    let t140 = circuit_mul(t75, t139);
    let t141 = circuit_add(in18, in19);
    let t142 = circuit_sub(in18, in19);
    let t143 = circuit_mul(t141, t142);
    let t144 = circuit_mul(in18, in19);
    let t145 = circuit_mul(t143, in0);
    let t146 = circuit_mul(t144, in1);
    let t147 = circuit_add(in20, in20);
    let t148 = circuit_add(in21, in21);
    let t149 = circuit_mul(t147, t147);
    let t150 = circuit_mul(t148, t148);
    let t151 = circuit_add(t149, t150);
    let t152 = circuit_inverse(t151);
    let t153 = circuit_mul(t147, t152);
    let t154 = circuit_mul(t148, t152);
    let t155 = circuit_sub(in2, t154);
    let t156 = circuit_mul(t145, t153);
    let t157 = circuit_mul(t146, t155);
    let t158 = circuit_sub(t156, t157);
    let t159 = circuit_mul(t145, t155);
    let t160 = circuit_mul(t146, t153);
    let t161 = circuit_add(t159, t160);
    let t162 = circuit_add(t158, t161);
    let t163 = circuit_sub(t158, t161);
    let t164 = circuit_mul(t162, t163);
    let t165 = circuit_mul(t158, t161);
    let t166 = circuit_add(t165, t165);
    let t167 = circuit_add(in18, in18);
    let t168 = circuit_add(in19, in19);
    let t169 = circuit_sub(t164, t167);
    let t170 = circuit_sub(t166, t168);
    let t171 = circuit_sub(in18, t169);
    let t172 = circuit_sub(in19, t170);
    let t173 = circuit_mul(t158, t171);
    let t174 = circuit_mul(t161, t172);
    let t175 = circuit_sub(t173, t174);
    let t176 = circuit_mul(t158, t172);
    let t177 = circuit_mul(t161, t171);
    let t178 = circuit_add(t176, t177);
    let t179 = circuit_sub(t175, in20);
    let t180 = circuit_sub(t178, in21);
    let t181 = circuit_mul(t158, in18);
    let t182 = circuit_mul(t161, in19);
    let t183 = circuit_sub(t181, t182);
    let t184 = circuit_mul(t158, in19);
    let t185 = circuit_mul(t161, in18);
    let t186 = circuit_add(t184, t185);
    let t187 = circuit_sub(t183, in20);
    let t188 = circuit_sub(t186, in21);
    let t189 = circuit_mul(in3, t161);
    let t190 = circuit_add(t158, t189);
    let t191 = circuit_mul(t190, in17);
    let t192 = circuit_mul(in3, t188);
    let t193 = circuit_add(t187, t192);
    let t194 = circuit_mul(t193, in16);
    let t195 = circuit_mul(t161, in17);
    let t196 = circuit_mul(t188, in16);
    let t197 = circuit_mul(t191, in37);
    let t198 = circuit_add(in4, t197);
    let t199 = circuit_mul(t194, t1);
    let t200 = circuit_add(t198, t199);
    let t201 = circuit_mul(t195, t5);
    let t202 = circuit_add(t200, t201);
    let t203 = circuit_mul(t196, t7);
    let t204 = circuit_add(t202, t203);
    let t205 = circuit_mul(t140, t204);
    let t206 = circuit_mul(in25, in37);
    let t207 = circuit_add(in24, t206);
    let t208 = circuit_mul(in26, t0);
    let t209 = circuit_add(t207, t208);
    let t210 = circuit_mul(in27, t1);
    let t211 = circuit_add(t209, t210);
    let t212 = circuit_mul(in28, t2);
    let t213 = circuit_add(t211, t212);
    let t214 = circuit_mul(in29, t3);
    let t215 = circuit_add(t213, t214);
    let t216 = circuit_mul(in30, t4);
    let t217 = circuit_add(t215, t216);
    let t218 = circuit_mul(in31, t5);
    let t219 = circuit_add(t217, t218);
    let t220 = circuit_mul(in32, t6);
    let t221 = circuit_add(t219, t220);
    let t222 = circuit_mul(in33, t7);
    let t223 = circuit_add(t221, t222);
    let t224 = circuit_mul(in34, t8);
    let t225 = circuit_add(t223, t224);
    let t226 = circuit_mul(in35, t9);
    let t227 = circuit_add(t225, t226);
    let t228 = circuit_sub(t205, t227);
    let t229 = circuit_mul(in36, t228);
    let t230 = circuit_add(in22, t229);
    // commit_start_index=37, commit_end_index-1=36
    let p = get_p(0);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t48, t49, t114, t115, t179, t180,).new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t39);
    let o1 = outputs.get_output(t40);
    let o2 = outputs.get_output(t49);
    let o3 = outputs.get_output(t50);
    let o4 = outputs.get_output(t104);
    let o5 = outputs.get_output(t105);
    let o6 = outputs.get_output(t114);
    let o7 = outputs.get_output(t115);
    let o8 = outputs.get_output(t169);
    let o9 = outputs.get_output(t170);
    let o10 = outputs.get_output(t179);
    let o11 = outputs.get_output(t180);
    let o12 = outputs.get_output(t227);
    let o13 = outputs.get_output(t230);

    let res = array![o0, o1, o2, o3, o4, o5, o6, o7, o8, o9, o10, o11, o12, o13];
    return res;
}

fn get_BN254_MP_CHECK_BIT1_LOOP_2_circuit(mut input: Array<u384>) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0
    let in1 = CircuitElement::<
        CircuitInput<1>
    > {}; // 21888242871839275222246405745257275088696311157297823662689037894645226208574

    // INPUT stack
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
    let in9 = CircuitElement::<CircuitInput<9>> {}; // 
    let in10 = CircuitElement::<CircuitInput<10>> {}; // 
    let in11 = CircuitElement::<CircuitInput<11>> {}; // 
    let in12 = CircuitElement::<CircuitInput<12>> {}; // 
    let in13 = CircuitElement::<CircuitInput<13>> {}; // 
    let in14 = CircuitElement::<CircuitInput<14>> {}; // 
    let in15 = CircuitElement::<CircuitInput<15>> {}; // 
    let in16 = CircuitElement::<CircuitInput<16>> {}; // 
    let in17 = CircuitElement::<CircuitInput<17>> {}; // 
    let in18 = CircuitElement::<CircuitInput<18>> {}; // 
    let in19 = CircuitElement::<CircuitInput<19>> {}; // 
    let in20 = CircuitElement::<CircuitInput<20>> {}; // 
    let in21 = CircuitElement::<CircuitInput<21>> {}; // 
    let in22 = CircuitElement::<CircuitInput<22>> {}; // 
    let in23 = CircuitElement::<CircuitInput<23>> {}; // 
    let in24 = CircuitElement::<CircuitInput<24>> {}; // 
    let in25 = CircuitElement::<CircuitInput<25>> {}; // 
    let in26 = CircuitElement::<CircuitInput<26>> {}; // 
    let in27 = CircuitElement::<CircuitInput<27>> {}; // 
    let in28 = CircuitElement::<CircuitInput<28>> {}; // 
    let in29 = CircuitElement::<CircuitInput<29>> {}; // 
    let in30 = CircuitElement::<CircuitInput<30>> {}; // 
    let in31 = CircuitElement::<CircuitInput<31>> {}; // 
    let in32 = CircuitElement::<CircuitInput<32>> {}; // 
    let in33 = CircuitElement::<CircuitInput<33>> {}; // 
    let in34 = CircuitElement::<CircuitInput<34>> {}; // 
    let in35 = CircuitElement::<CircuitInput<35>> {}; // 
    let in36 = CircuitElement::<CircuitInput<36>> {}; // 
    let in37 = CircuitElement::<CircuitInput<37>> {}; // 
    let in38 = CircuitElement::<CircuitInput<38>> {}; // 
    let in39 = CircuitElement::<CircuitInput<39>> {}; // 
    let in40 = CircuitElement::<CircuitInput<40>> {}; // 
    let in41 = CircuitElement::<CircuitInput<41>> {}; // 
    let in42 = CircuitElement::<CircuitInput<42>> {}; // 
    let in43 = CircuitElement::<CircuitInput<43>> {}; // 
    let in44 = CircuitElement::<CircuitInput<44>> {}; // 
    let in45 = CircuitElement::<CircuitInput<45>> {}; // 
    let in46 = CircuitElement::<CircuitInput<46>> {}; // 
    let in47 = CircuitElement::<CircuitInput<47>> {}; // 
    let in48 = CircuitElement::<CircuitInput<48>> {}; // 

    // FELT stack
    let in49 = CircuitElement::<CircuitInput<49>> {}; // 
    let t0 = circuit_mul(in49, in49);
    let t1 = circuit_mul(t0, in49);
    let t2 = circuit_mul(t1, in49);
    let t3 = circuit_mul(t2, in49);
    let t4 = circuit_mul(t3, in49);
    let t5 = circuit_mul(t4, in49);
    let t6 = circuit_mul(t5, in49);
    let t7 = circuit_mul(t6, in49);
    let t8 = circuit_mul(t7, in49);
    let t9 = circuit_mul(t8, in49);
    let t10 = circuit_mul(in23, in23);
    let t11 = circuit_sub(in6, in10);
    let t12 = circuit_sub(in7, in11);
    let t13 = circuit_sub(in4, in8);
    let t14 = circuit_sub(in5, in9);
    let t15 = circuit_mul(t13, t13);
    let t16 = circuit_mul(t14, t14);
    let t17 = circuit_add(t15, t16);
    let t18 = circuit_inverse(t17);
    let t19 = circuit_mul(t13, t18);
    let t20 = circuit_mul(t14, t18);
    let t21 = circuit_sub(in0, t20);
    let t22 = circuit_mul(t11, t19);
    let t23 = circuit_mul(t12, t21);
    let t24 = circuit_sub(t22, t23);
    let t25 = circuit_mul(t11, t21);
    let t26 = circuit_mul(t12, t19);
    let t27 = circuit_add(t25, t26);
    let t28 = circuit_add(t24, t27);
    let t29 = circuit_sub(t24, t27);
    let t30 = circuit_mul(t28, t29);
    let t31 = circuit_mul(t24, t27);
    let t32 = circuit_add(t31, t31);
    let t33 = circuit_add(in4, in8);
    let t34 = circuit_add(in5, in9);
    let t35 = circuit_sub(t30, t33);
    let t36 = circuit_sub(t32, t34);
    let t37 = circuit_mul(t24, in4);
    let t38 = circuit_mul(t27, in5);
    let t39 = circuit_sub(t37, t38);
    let t40 = circuit_mul(t24, in5);
    let t41 = circuit_mul(t27, in4);
    let t42 = circuit_add(t40, t41);
    let t43 = circuit_sub(t39, in6);
    let t44 = circuit_sub(t42, in7);
    let t45 = circuit_mul(in1, t27);
    let t46 = circuit_add(t24, t45);
    let t47 = circuit_mul(t46, in3);
    let t48 = circuit_mul(in1, t44);
    let t49 = circuit_add(t43, t48);
    let t50 = circuit_mul(t49, in2);
    let t51 = circuit_mul(t27, in3);
    let t52 = circuit_mul(t44, in2);
    let t53 = circuit_add(in6, in6);
    let t54 = circuit_add(in7, in7);
    let t55 = circuit_sub(t35, in4);
    let t56 = circuit_sub(t36, in5);
    let t57 = circuit_mul(t55, t55);
    let t58 = circuit_mul(t56, t56);
    let t59 = circuit_add(t57, t58);
    let t60 = circuit_inverse(t59);
    let t61 = circuit_mul(t55, t60);
    let t62 = circuit_mul(t56, t60);
    let t63 = circuit_sub(in0, t62);
    let t64 = circuit_mul(t53, t61);
    let t65 = circuit_mul(t54, t63);
    let t66 = circuit_sub(t64, t65);
    let t67 = circuit_mul(t53, t63);
    let t68 = circuit_mul(t54, t61);
    let t69 = circuit_add(t67, t68);
    let t70 = circuit_add(t24, t66);
    let t71 = circuit_add(t27, t69);
    let t72 = circuit_sub(in0, t70);
    let t73 = circuit_sub(in0, t71);
    let t74 = circuit_add(t72, t73);
    let t75 = circuit_sub(t72, t73);
    let t76 = circuit_mul(t74, t75);
    let t77 = circuit_mul(t72, t73);
    let t78 = circuit_add(t77, t77);
    let t79 = circuit_sub(t76, in4);
    let t80 = circuit_sub(t78, in5);
    let t81 = circuit_sub(t79, t35);
    let t82 = circuit_sub(t80, t36);
    let t83 = circuit_sub(in4, t81);
    let t84 = circuit_sub(in5, t82);
    let t85 = circuit_mul(t72, t83);
    let t86 = circuit_mul(t73, t84);
    let t87 = circuit_sub(t85, t86);
    let t88 = circuit_mul(t72, t84);
    let t89 = circuit_mul(t73, t83);
    let t90 = circuit_add(t88, t89);
    let t91 = circuit_sub(t87, in6);
    let t92 = circuit_sub(t90, in7);
    let t93 = circuit_mul(t72, in4);
    let t94 = circuit_mul(t73, in5);
    let t95 = circuit_sub(t93, t94);
    let t96 = circuit_mul(t72, in5);
    let t97 = circuit_mul(t73, in4);
    let t98 = circuit_add(t96, t97);
    let t99 = circuit_sub(t95, in6);
    let t100 = circuit_sub(t98, in7);
    let t101 = circuit_mul(in1, t73);
    let t102 = circuit_add(t72, t101);
    let t103 = circuit_mul(t102, in3);
    let t104 = circuit_mul(in1, t100);
    let t105 = circuit_add(t99, t104);
    let t106 = circuit_mul(t105, in2);
    let t107 = circuit_mul(t73, in3);
    let t108 = circuit_mul(t100, in2);
    let t109 = circuit_mul(t47, in49);
    let t110 = circuit_add(in2, t109);
    let t111 = circuit_mul(t50, t1);
    let t112 = circuit_add(t110, t111);
    let t113 = circuit_mul(t51, t5);
    let t114 = circuit_add(t112, t113);
    let t115 = circuit_mul(t52, t7);
    let t116 = circuit_add(t114, t115);
    let t117 = circuit_mul(t10, t116);
    let t118 = circuit_mul(t103, in49);
    let t119 = circuit_add(in2, t118);
    let t120 = circuit_mul(t106, t1);
    let t121 = circuit_add(t119, t120);
    let t122 = circuit_mul(t107, t5);
    let t123 = circuit_add(t121, t122);
    let t124 = circuit_mul(t108, t7);
    let t125 = circuit_add(t123, t124);
    let t126 = circuit_mul(t117, t125);
    let t127 = circuit_sub(in16, in20);
    let t128 = circuit_sub(in17, in21);
    let t129 = circuit_sub(in14, in18);
    let t130 = circuit_sub(in15, in19);
    let t131 = circuit_mul(t129, t129);
    let t132 = circuit_mul(t130, t130);
    let t133 = circuit_add(t131, t132);
    let t134 = circuit_inverse(t133);
    let t135 = circuit_mul(t129, t134);
    let t136 = circuit_mul(t130, t134);
    let t137 = circuit_sub(in0, t136);
    let t138 = circuit_mul(t127, t135);
    let t139 = circuit_mul(t128, t137);
    let t140 = circuit_sub(t138, t139);
    let t141 = circuit_mul(t127, t137);
    let t142 = circuit_mul(t128, t135);
    let t143 = circuit_add(t141, t142);
    let t144 = circuit_add(t140, t143);
    let t145 = circuit_sub(t140, t143);
    let t146 = circuit_mul(t144, t145);
    let t147 = circuit_mul(t140, t143);
    let t148 = circuit_add(t147, t147);
    let t149 = circuit_add(in14, in18);
    let t150 = circuit_add(in15, in19);
    let t151 = circuit_sub(t146, t149);
    let t152 = circuit_sub(t148, t150);
    let t153 = circuit_mul(t140, in14);
    let t154 = circuit_mul(t143, in15);
    let t155 = circuit_sub(t153, t154);
    let t156 = circuit_mul(t140, in15);
    let t157 = circuit_mul(t143, in14);
    let t158 = circuit_add(t156, t157);
    let t159 = circuit_sub(t155, in16);
    let t160 = circuit_sub(t158, in17);
    let t161 = circuit_mul(in1, t143);
    let t162 = circuit_add(t140, t161);
    let t163 = circuit_mul(t162, in13);
    let t164 = circuit_mul(in1, t160);
    let t165 = circuit_add(t159, t164);
    let t166 = circuit_mul(t165, in12);
    let t167 = circuit_mul(t143, in13);
    let t168 = circuit_mul(t160, in12);
    let t169 = circuit_add(in16, in16);
    let t170 = circuit_add(in17, in17);
    let t171 = circuit_sub(t151, in14);
    let t172 = circuit_sub(t152, in15);
    let t173 = circuit_mul(t171, t171);
    let t174 = circuit_mul(t172, t172);
    let t175 = circuit_add(t173, t174);
    let t176 = circuit_inverse(t175);
    let t177 = circuit_mul(t171, t176);
    let t178 = circuit_mul(t172, t176);
    let t179 = circuit_sub(in0, t178);
    let t180 = circuit_mul(t169, t177);
    let t181 = circuit_mul(t170, t179);
    let t182 = circuit_sub(t180, t181);
    let t183 = circuit_mul(t169, t179);
    let t184 = circuit_mul(t170, t177);
    let t185 = circuit_add(t183, t184);
    let t186 = circuit_add(t140, t182);
    let t187 = circuit_add(t143, t185);
    let t188 = circuit_sub(in0, t186);
    let t189 = circuit_sub(in0, t187);
    let t190 = circuit_add(t188, t189);
    let t191 = circuit_sub(t188, t189);
    let t192 = circuit_mul(t190, t191);
    let t193 = circuit_mul(t188, t189);
    let t194 = circuit_add(t193, t193);
    let t195 = circuit_sub(t192, in14);
    let t196 = circuit_sub(t194, in15);
    let t197 = circuit_sub(t195, t151);
    let t198 = circuit_sub(t196, t152);
    let t199 = circuit_sub(in14, t197);
    let t200 = circuit_sub(in15, t198);
    let t201 = circuit_mul(t188, t199);
    let t202 = circuit_mul(t189, t200);
    let t203 = circuit_sub(t201, t202);
    let t204 = circuit_mul(t188, t200);
    let t205 = circuit_mul(t189, t199);
    let t206 = circuit_add(t204, t205);
    let t207 = circuit_sub(t203, in16);
    let t208 = circuit_sub(t206, in17);
    let t209 = circuit_mul(t188, in14);
    let t210 = circuit_mul(t189, in15);
    let t211 = circuit_sub(t209, t210);
    let t212 = circuit_mul(t188, in15);
    let t213 = circuit_mul(t189, in14);
    let t214 = circuit_add(t212, t213);
    let t215 = circuit_sub(t211, in16);
    let t216 = circuit_sub(t214, in17);
    let t217 = circuit_mul(in1, t189);
    let t218 = circuit_add(t188, t217);
    let t219 = circuit_mul(t218, in13);
    let t220 = circuit_mul(in1, t216);
    let t221 = circuit_add(t215, t220);
    let t222 = circuit_mul(t221, in12);
    let t223 = circuit_mul(t189, in13);
    let t224 = circuit_mul(t216, in12);
    let t225 = circuit_mul(t163, in49);
    let t226 = circuit_add(in2, t225);
    let t227 = circuit_mul(t166, t1);
    let t228 = circuit_add(t226, t227);
    let t229 = circuit_mul(t167, t5);
    let t230 = circuit_add(t228, t229);
    let t231 = circuit_mul(t168, t7);
    let t232 = circuit_add(t230, t231);
    let t233 = circuit_mul(t126, t232);
    let t234 = circuit_mul(t219, in49);
    let t235 = circuit_add(in2, t234);
    let t236 = circuit_mul(t222, t1);
    let t237 = circuit_add(t235, t236);
    let t238 = circuit_mul(t223, t5);
    let t239 = circuit_add(t237, t238);
    let t240 = circuit_mul(t224, t7);
    let t241 = circuit_add(t239, t240);
    let t242 = circuit_mul(t233, t241);
    let t243 = circuit_mul(in37, in49);
    let t244 = circuit_add(in36, t243);
    let t245 = circuit_mul(in38, t0);
    let t246 = circuit_add(t244, t245);
    let t247 = circuit_mul(in39, t1);
    let t248 = circuit_add(t246, t247);
    let t249 = circuit_mul(in40, t2);
    let t250 = circuit_add(t248, t249);
    let t251 = circuit_mul(in41, t3);
    let t252 = circuit_add(t250, t251);
    let t253 = circuit_mul(in42, t4);
    let t254 = circuit_add(t252, t253);
    let t255 = circuit_mul(in43, t5);
    let t256 = circuit_add(t254, t255);
    let t257 = circuit_mul(in44, t6);
    let t258 = circuit_add(t256, t257);
    let t259 = circuit_mul(in45, t7);
    let t260 = circuit_add(t258, t259);
    let t261 = circuit_mul(in46, t8);
    let t262 = circuit_add(t260, t261);
    let t263 = circuit_mul(in47, t9);
    let t264 = circuit_add(t262, t263);
    let t265 = circuit_mul(t242, t264);
    let t266 = circuit_mul(in25, in49);
    let t267 = circuit_add(in24, t266);
    let t268 = circuit_mul(in26, t0);
    let t269 = circuit_add(t267, t268);
    let t270 = circuit_mul(in27, t1);
    let t271 = circuit_add(t269, t270);
    let t272 = circuit_mul(in28, t2);
    let t273 = circuit_add(t271, t272);
    let t274 = circuit_mul(in29, t3);
    let t275 = circuit_add(t273, t274);
    let t276 = circuit_mul(in30, t4);
    let t277 = circuit_add(t275, t276);
    let t278 = circuit_mul(in31, t5);
    let t279 = circuit_add(t277, t278);
    let t280 = circuit_mul(in32, t6);
    let t281 = circuit_add(t279, t280);
    let t282 = circuit_mul(in33, t7);
    let t283 = circuit_add(t281, t282);
    let t284 = circuit_mul(in34, t8);
    let t285 = circuit_add(t283, t284);
    let t286 = circuit_mul(in35, t9);
    let t287 = circuit_add(t285, t286);
    let t288 = circuit_sub(t265, t287);
    let t289 = circuit_mul(in48, t288);
    let t290 = circuit_add(in22, t289);
    // commit_start_index=49, commit_end_index-1=48
    let p = get_p(0);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t91, t92, t207, t208,).new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t81);
    let o1 = outputs.get_output(t82);
    let o2 = outputs.get_output(t91);
    let o3 = outputs.get_output(t92);
    let o4 = outputs.get_output(t197);
    let o5 = outputs.get_output(t198);
    let o6 = outputs.get_output(t207);
    let o7 = outputs.get_output(t208);
    let o8 = outputs.get_output(t287);
    let o9 = outputs.get_output(t290);

    let res = array![o0, o1, o2, o3, o4, o5, o6, o7, o8, o9];
    return res;
}

fn get_BN254_MP_CHECK_BIT1_LOOP_3_circuit(mut input: Array<u384>) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0
    let in1 = CircuitElement::<
        CircuitInput<1>
    > {}; // 21888242871839275222246405745257275088696311157297823662689037894645226208574

    // INPUT stack
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
    let in9 = CircuitElement::<CircuitInput<9>> {}; // 
    let in10 = CircuitElement::<CircuitInput<10>> {}; // 
    let in11 = CircuitElement::<CircuitInput<11>> {}; // 
    let in12 = CircuitElement::<CircuitInput<12>> {}; // 
    let in13 = CircuitElement::<CircuitInput<13>> {}; // 
    let in14 = CircuitElement::<CircuitInput<14>> {}; // 
    let in15 = CircuitElement::<CircuitInput<15>> {}; // 
    let in16 = CircuitElement::<CircuitInput<16>> {}; // 
    let in17 = CircuitElement::<CircuitInput<17>> {}; // 
    let in18 = CircuitElement::<CircuitInput<18>> {}; // 
    let in19 = CircuitElement::<CircuitInput<19>> {}; // 
    let in20 = CircuitElement::<CircuitInput<20>> {}; // 
    let in21 = CircuitElement::<CircuitInput<21>> {}; // 
    let in22 = CircuitElement::<CircuitInput<22>> {}; // 
    let in23 = CircuitElement::<CircuitInput<23>> {}; // 
    let in24 = CircuitElement::<CircuitInput<24>> {}; // 
    let in25 = CircuitElement::<CircuitInput<25>> {}; // 
    let in26 = CircuitElement::<CircuitInput<26>> {}; // 
    let in27 = CircuitElement::<CircuitInput<27>> {}; // 
    let in28 = CircuitElement::<CircuitInput<28>> {}; // 
    let in29 = CircuitElement::<CircuitInput<29>> {}; // 
    let in30 = CircuitElement::<CircuitInput<30>> {}; // 
    let in31 = CircuitElement::<CircuitInput<31>> {}; // 
    let in32 = CircuitElement::<CircuitInput<32>> {}; // 
    let in33 = CircuitElement::<CircuitInput<33>> {}; // 
    let in34 = CircuitElement::<CircuitInput<34>> {}; // 
    let in35 = CircuitElement::<CircuitInput<35>> {}; // 
    let in36 = CircuitElement::<CircuitInput<36>> {}; // 
    let in37 = CircuitElement::<CircuitInput<37>> {}; // 
    let in38 = CircuitElement::<CircuitInput<38>> {}; // 
    let in39 = CircuitElement::<CircuitInput<39>> {}; // 
    let in40 = CircuitElement::<CircuitInput<40>> {}; // 
    let in41 = CircuitElement::<CircuitInput<41>> {}; // 
    let in42 = CircuitElement::<CircuitInput<42>> {}; // 
    let in43 = CircuitElement::<CircuitInput<43>> {}; // 
    let in44 = CircuitElement::<CircuitInput<44>> {}; // 
    let in45 = CircuitElement::<CircuitInput<45>> {}; // 
    let in46 = CircuitElement::<CircuitInput<46>> {}; // 
    let in47 = CircuitElement::<CircuitInput<47>> {}; // 
    let in48 = CircuitElement::<CircuitInput<48>> {}; // 
    let in49 = CircuitElement::<CircuitInput<49>> {}; // 
    let in50 = CircuitElement::<CircuitInput<50>> {}; // 
    let in51 = CircuitElement::<CircuitInput<51>> {}; // 
    let in52 = CircuitElement::<CircuitInput<52>> {}; // 
    let in53 = CircuitElement::<CircuitInput<53>> {}; // 
    let in54 = CircuitElement::<CircuitInput<54>> {}; // 
    let in55 = CircuitElement::<CircuitInput<55>> {}; // 
    let in56 = CircuitElement::<CircuitInput<56>> {}; // 
    let in57 = CircuitElement::<CircuitInput<57>> {}; // 
    let in58 = CircuitElement::<CircuitInput<58>> {}; // 

    // FELT stack
    let in59 = CircuitElement::<CircuitInput<59>> {}; // 
    let t0 = circuit_mul(in59, in59);
    let t1 = circuit_mul(t0, in59);
    let t2 = circuit_mul(t1, in59);
    let t3 = circuit_mul(t2, in59);
    let t4 = circuit_mul(t3, in59);
    let t5 = circuit_mul(t4, in59);
    let t6 = circuit_mul(t5, in59);
    let t7 = circuit_mul(t6, in59);
    let t8 = circuit_mul(t7, in59);
    let t9 = circuit_mul(t8, in59);
    let t10 = circuit_mul(in33, in33);
    let t11 = circuit_sub(in6, in10);
    let t12 = circuit_sub(in7, in11);
    let t13 = circuit_sub(in4, in8);
    let t14 = circuit_sub(in5, in9);
    let t15 = circuit_mul(t13, t13);
    let t16 = circuit_mul(t14, t14);
    let t17 = circuit_add(t15, t16);
    let t18 = circuit_inverse(t17);
    let t19 = circuit_mul(t13, t18);
    let t20 = circuit_mul(t14, t18);
    let t21 = circuit_sub(in0, t20);
    let t22 = circuit_mul(t11, t19);
    let t23 = circuit_mul(t12, t21);
    let t24 = circuit_sub(t22, t23);
    let t25 = circuit_mul(t11, t21);
    let t26 = circuit_mul(t12, t19);
    let t27 = circuit_add(t25, t26);
    let t28 = circuit_add(t24, t27);
    let t29 = circuit_sub(t24, t27);
    let t30 = circuit_mul(t28, t29);
    let t31 = circuit_mul(t24, t27);
    let t32 = circuit_add(t31, t31);
    let t33 = circuit_add(in4, in8);
    let t34 = circuit_add(in5, in9);
    let t35 = circuit_sub(t30, t33);
    let t36 = circuit_sub(t32, t34);
    let t37 = circuit_mul(t24, in4);
    let t38 = circuit_mul(t27, in5);
    let t39 = circuit_sub(t37, t38);
    let t40 = circuit_mul(t24, in5);
    let t41 = circuit_mul(t27, in4);
    let t42 = circuit_add(t40, t41);
    let t43 = circuit_sub(t39, in6);
    let t44 = circuit_sub(t42, in7);
    let t45 = circuit_mul(in1, t27);
    let t46 = circuit_add(t24, t45);
    let t47 = circuit_mul(t46, in3);
    let t48 = circuit_mul(in1, t44);
    let t49 = circuit_add(t43, t48);
    let t50 = circuit_mul(t49, in2);
    let t51 = circuit_mul(t27, in3);
    let t52 = circuit_mul(t44, in2);
    let t53 = circuit_add(in6, in6);
    let t54 = circuit_add(in7, in7);
    let t55 = circuit_sub(t35, in4);
    let t56 = circuit_sub(t36, in5);
    let t57 = circuit_mul(t55, t55);
    let t58 = circuit_mul(t56, t56);
    let t59 = circuit_add(t57, t58);
    let t60 = circuit_inverse(t59);
    let t61 = circuit_mul(t55, t60);
    let t62 = circuit_mul(t56, t60);
    let t63 = circuit_sub(in0, t62);
    let t64 = circuit_mul(t53, t61);
    let t65 = circuit_mul(t54, t63);
    let t66 = circuit_sub(t64, t65);
    let t67 = circuit_mul(t53, t63);
    let t68 = circuit_mul(t54, t61);
    let t69 = circuit_add(t67, t68);
    let t70 = circuit_add(t24, t66);
    let t71 = circuit_add(t27, t69);
    let t72 = circuit_sub(in0, t70);
    let t73 = circuit_sub(in0, t71);
    let t74 = circuit_add(t72, t73);
    let t75 = circuit_sub(t72, t73);
    let t76 = circuit_mul(t74, t75);
    let t77 = circuit_mul(t72, t73);
    let t78 = circuit_add(t77, t77);
    let t79 = circuit_sub(t76, in4);
    let t80 = circuit_sub(t78, in5);
    let t81 = circuit_sub(t79, t35);
    let t82 = circuit_sub(t80, t36);
    let t83 = circuit_sub(in4, t81);
    let t84 = circuit_sub(in5, t82);
    let t85 = circuit_mul(t72, t83);
    let t86 = circuit_mul(t73, t84);
    let t87 = circuit_sub(t85, t86);
    let t88 = circuit_mul(t72, t84);
    let t89 = circuit_mul(t73, t83);
    let t90 = circuit_add(t88, t89);
    let t91 = circuit_sub(t87, in6);
    let t92 = circuit_sub(t90, in7);
    let t93 = circuit_mul(t72, in4);
    let t94 = circuit_mul(t73, in5);
    let t95 = circuit_sub(t93, t94);
    let t96 = circuit_mul(t72, in5);
    let t97 = circuit_mul(t73, in4);
    let t98 = circuit_add(t96, t97);
    let t99 = circuit_sub(t95, in6);
    let t100 = circuit_sub(t98, in7);
    let t101 = circuit_mul(in1, t73);
    let t102 = circuit_add(t72, t101);
    let t103 = circuit_mul(t102, in3);
    let t104 = circuit_mul(in1, t100);
    let t105 = circuit_add(t99, t104);
    let t106 = circuit_mul(t105, in2);
    let t107 = circuit_mul(t73, in3);
    let t108 = circuit_mul(t100, in2);
    let t109 = circuit_mul(t47, in59);
    let t110 = circuit_add(in2, t109);
    let t111 = circuit_mul(t50, t1);
    let t112 = circuit_add(t110, t111);
    let t113 = circuit_mul(t51, t5);
    let t114 = circuit_add(t112, t113);
    let t115 = circuit_mul(t52, t7);
    let t116 = circuit_add(t114, t115);
    let t117 = circuit_mul(t10, t116);
    let t118 = circuit_mul(t103, in59);
    let t119 = circuit_add(in2, t118);
    let t120 = circuit_mul(t106, t1);
    let t121 = circuit_add(t119, t120);
    let t122 = circuit_mul(t107, t5);
    let t123 = circuit_add(t121, t122);
    let t124 = circuit_mul(t108, t7);
    let t125 = circuit_add(t123, t124);
    let t126 = circuit_mul(t117, t125);
    let t127 = circuit_sub(in16, in20);
    let t128 = circuit_sub(in17, in21);
    let t129 = circuit_sub(in14, in18);
    let t130 = circuit_sub(in15, in19);
    let t131 = circuit_mul(t129, t129);
    let t132 = circuit_mul(t130, t130);
    let t133 = circuit_add(t131, t132);
    let t134 = circuit_inverse(t133);
    let t135 = circuit_mul(t129, t134);
    let t136 = circuit_mul(t130, t134);
    let t137 = circuit_sub(in0, t136);
    let t138 = circuit_mul(t127, t135);
    let t139 = circuit_mul(t128, t137);
    let t140 = circuit_sub(t138, t139);
    let t141 = circuit_mul(t127, t137);
    let t142 = circuit_mul(t128, t135);
    let t143 = circuit_add(t141, t142);
    let t144 = circuit_add(t140, t143);
    let t145 = circuit_sub(t140, t143);
    let t146 = circuit_mul(t144, t145);
    let t147 = circuit_mul(t140, t143);
    let t148 = circuit_add(t147, t147);
    let t149 = circuit_add(in14, in18);
    let t150 = circuit_add(in15, in19);
    let t151 = circuit_sub(t146, t149);
    let t152 = circuit_sub(t148, t150);
    let t153 = circuit_mul(t140, in14);
    let t154 = circuit_mul(t143, in15);
    let t155 = circuit_sub(t153, t154);
    let t156 = circuit_mul(t140, in15);
    let t157 = circuit_mul(t143, in14);
    let t158 = circuit_add(t156, t157);
    let t159 = circuit_sub(t155, in16);
    let t160 = circuit_sub(t158, in17);
    let t161 = circuit_mul(in1, t143);
    let t162 = circuit_add(t140, t161);
    let t163 = circuit_mul(t162, in13);
    let t164 = circuit_mul(in1, t160);
    let t165 = circuit_add(t159, t164);
    let t166 = circuit_mul(t165, in12);
    let t167 = circuit_mul(t143, in13);
    let t168 = circuit_mul(t160, in12);
    let t169 = circuit_add(in16, in16);
    let t170 = circuit_add(in17, in17);
    let t171 = circuit_sub(t151, in14);
    let t172 = circuit_sub(t152, in15);
    let t173 = circuit_mul(t171, t171);
    let t174 = circuit_mul(t172, t172);
    let t175 = circuit_add(t173, t174);
    let t176 = circuit_inverse(t175);
    let t177 = circuit_mul(t171, t176);
    let t178 = circuit_mul(t172, t176);
    let t179 = circuit_sub(in0, t178);
    let t180 = circuit_mul(t169, t177);
    let t181 = circuit_mul(t170, t179);
    let t182 = circuit_sub(t180, t181);
    let t183 = circuit_mul(t169, t179);
    let t184 = circuit_mul(t170, t177);
    let t185 = circuit_add(t183, t184);
    let t186 = circuit_add(t140, t182);
    let t187 = circuit_add(t143, t185);
    let t188 = circuit_sub(in0, t186);
    let t189 = circuit_sub(in0, t187);
    let t190 = circuit_add(t188, t189);
    let t191 = circuit_sub(t188, t189);
    let t192 = circuit_mul(t190, t191);
    let t193 = circuit_mul(t188, t189);
    let t194 = circuit_add(t193, t193);
    let t195 = circuit_sub(t192, in14);
    let t196 = circuit_sub(t194, in15);
    let t197 = circuit_sub(t195, t151);
    let t198 = circuit_sub(t196, t152);
    let t199 = circuit_sub(in14, t197);
    let t200 = circuit_sub(in15, t198);
    let t201 = circuit_mul(t188, t199);
    let t202 = circuit_mul(t189, t200);
    let t203 = circuit_sub(t201, t202);
    let t204 = circuit_mul(t188, t200);
    let t205 = circuit_mul(t189, t199);
    let t206 = circuit_add(t204, t205);
    let t207 = circuit_sub(t203, in16);
    let t208 = circuit_sub(t206, in17);
    let t209 = circuit_mul(t188, in14);
    let t210 = circuit_mul(t189, in15);
    let t211 = circuit_sub(t209, t210);
    let t212 = circuit_mul(t188, in15);
    let t213 = circuit_mul(t189, in14);
    let t214 = circuit_add(t212, t213);
    let t215 = circuit_sub(t211, in16);
    let t216 = circuit_sub(t214, in17);
    let t217 = circuit_mul(in1, t189);
    let t218 = circuit_add(t188, t217);
    let t219 = circuit_mul(t218, in13);
    let t220 = circuit_mul(in1, t216);
    let t221 = circuit_add(t215, t220);
    let t222 = circuit_mul(t221, in12);
    let t223 = circuit_mul(t189, in13);
    let t224 = circuit_mul(t216, in12);
    let t225 = circuit_mul(t163, in59);
    let t226 = circuit_add(in2, t225);
    let t227 = circuit_mul(t166, t1);
    let t228 = circuit_add(t226, t227);
    let t229 = circuit_mul(t167, t5);
    let t230 = circuit_add(t228, t229);
    let t231 = circuit_mul(t168, t7);
    let t232 = circuit_add(t230, t231);
    let t233 = circuit_mul(t126, t232);
    let t234 = circuit_mul(t219, in59);
    let t235 = circuit_add(in2, t234);
    let t236 = circuit_mul(t222, t1);
    let t237 = circuit_add(t235, t236);
    let t238 = circuit_mul(t223, t5);
    let t239 = circuit_add(t237, t238);
    let t240 = circuit_mul(t224, t7);
    let t241 = circuit_add(t239, t240);
    let t242 = circuit_mul(t233, t241);
    let t243 = circuit_sub(in26, in30);
    let t244 = circuit_sub(in27, in31);
    let t245 = circuit_sub(in24, in28);
    let t246 = circuit_sub(in25, in29);
    let t247 = circuit_mul(t245, t245);
    let t248 = circuit_mul(t246, t246);
    let t249 = circuit_add(t247, t248);
    let t250 = circuit_inverse(t249);
    let t251 = circuit_mul(t245, t250);
    let t252 = circuit_mul(t246, t250);
    let t253 = circuit_sub(in0, t252);
    let t254 = circuit_mul(t243, t251);
    let t255 = circuit_mul(t244, t253);
    let t256 = circuit_sub(t254, t255);
    let t257 = circuit_mul(t243, t253);
    let t258 = circuit_mul(t244, t251);
    let t259 = circuit_add(t257, t258);
    let t260 = circuit_add(t256, t259);
    let t261 = circuit_sub(t256, t259);
    let t262 = circuit_mul(t260, t261);
    let t263 = circuit_mul(t256, t259);
    let t264 = circuit_add(t263, t263);
    let t265 = circuit_add(in24, in28);
    let t266 = circuit_add(in25, in29);
    let t267 = circuit_sub(t262, t265);
    let t268 = circuit_sub(t264, t266);
    let t269 = circuit_mul(t256, in24);
    let t270 = circuit_mul(t259, in25);
    let t271 = circuit_sub(t269, t270);
    let t272 = circuit_mul(t256, in25);
    let t273 = circuit_mul(t259, in24);
    let t274 = circuit_add(t272, t273);
    let t275 = circuit_sub(t271, in26);
    let t276 = circuit_sub(t274, in27);
    let t277 = circuit_mul(in1, t259);
    let t278 = circuit_add(t256, t277);
    let t279 = circuit_mul(t278, in23);
    let t280 = circuit_mul(in1, t276);
    let t281 = circuit_add(t275, t280);
    let t282 = circuit_mul(t281, in22);
    let t283 = circuit_mul(t259, in23);
    let t284 = circuit_mul(t276, in22);
    let t285 = circuit_add(in26, in26);
    let t286 = circuit_add(in27, in27);
    let t287 = circuit_sub(t267, in24);
    let t288 = circuit_sub(t268, in25);
    let t289 = circuit_mul(t287, t287);
    let t290 = circuit_mul(t288, t288);
    let t291 = circuit_add(t289, t290);
    let t292 = circuit_inverse(t291);
    let t293 = circuit_mul(t287, t292);
    let t294 = circuit_mul(t288, t292);
    let t295 = circuit_sub(in0, t294);
    let t296 = circuit_mul(t285, t293);
    let t297 = circuit_mul(t286, t295);
    let t298 = circuit_sub(t296, t297);
    let t299 = circuit_mul(t285, t295);
    let t300 = circuit_mul(t286, t293);
    let t301 = circuit_add(t299, t300);
    let t302 = circuit_add(t256, t298);
    let t303 = circuit_add(t259, t301);
    let t304 = circuit_sub(in0, t302);
    let t305 = circuit_sub(in0, t303);
    let t306 = circuit_add(t304, t305);
    let t307 = circuit_sub(t304, t305);
    let t308 = circuit_mul(t306, t307);
    let t309 = circuit_mul(t304, t305);
    let t310 = circuit_add(t309, t309);
    let t311 = circuit_sub(t308, in24);
    let t312 = circuit_sub(t310, in25);
    let t313 = circuit_sub(t311, t267);
    let t314 = circuit_sub(t312, t268);
    let t315 = circuit_sub(in24, t313);
    let t316 = circuit_sub(in25, t314);
    let t317 = circuit_mul(t304, t315);
    let t318 = circuit_mul(t305, t316);
    let t319 = circuit_sub(t317, t318);
    let t320 = circuit_mul(t304, t316);
    let t321 = circuit_mul(t305, t315);
    let t322 = circuit_add(t320, t321);
    let t323 = circuit_sub(t319, in26);
    let t324 = circuit_sub(t322, in27);
    let t325 = circuit_mul(t304, in24);
    let t326 = circuit_mul(t305, in25);
    let t327 = circuit_sub(t325, t326);
    let t328 = circuit_mul(t304, in25);
    let t329 = circuit_mul(t305, in24);
    let t330 = circuit_add(t328, t329);
    let t331 = circuit_sub(t327, in26);
    let t332 = circuit_sub(t330, in27);
    let t333 = circuit_mul(in1, t305);
    let t334 = circuit_add(t304, t333);
    let t335 = circuit_mul(t334, in23);
    let t336 = circuit_mul(in1, t332);
    let t337 = circuit_add(t331, t336);
    let t338 = circuit_mul(t337, in22);
    let t339 = circuit_mul(t305, in23);
    let t340 = circuit_mul(t332, in22);
    let t341 = circuit_mul(t279, in59);
    let t342 = circuit_add(in2, t341);
    let t343 = circuit_mul(t282, t1);
    let t344 = circuit_add(t342, t343);
    let t345 = circuit_mul(t283, t5);
    let t346 = circuit_add(t344, t345);
    let t347 = circuit_mul(t284, t7);
    let t348 = circuit_add(t346, t347);
    let t349 = circuit_mul(t242, t348);
    let t350 = circuit_mul(t335, in59);
    let t351 = circuit_add(in2, t350);
    let t352 = circuit_mul(t338, t1);
    let t353 = circuit_add(t351, t352);
    let t354 = circuit_mul(t339, t5);
    let t355 = circuit_add(t353, t354);
    let t356 = circuit_mul(t340, t7);
    let t357 = circuit_add(t355, t356);
    let t358 = circuit_mul(t349, t357);
    let t359 = circuit_mul(in47, in59);
    let t360 = circuit_add(in46, t359);
    let t361 = circuit_mul(in48, t0);
    let t362 = circuit_add(t360, t361);
    let t363 = circuit_mul(in49, t1);
    let t364 = circuit_add(t362, t363);
    let t365 = circuit_mul(in50, t2);
    let t366 = circuit_add(t364, t365);
    let t367 = circuit_mul(in51, t3);
    let t368 = circuit_add(t366, t367);
    let t369 = circuit_mul(in52, t4);
    let t370 = circuit_add(t368, t369);
    let t371 = circuit_mul(in53, t5);
    let t372 = circuit_add(t370, t371);
    let t373 = circuit_mul(in54, t6);
    let t374 = circuit_add(t372, t373);
    let t375 = circuit_mul(in55, t7);
    let t376 = circuit_add(t374, t375);
    let t377 = circuit_mul(in56, t8);
    let t378 = circuit_add(t376, t377);
    let t379 = circuit_mul(in57, t9);
    let t380 = circuit_add(t378, t379);
    let t381 = circuit_mul(t358, t380);
    let t382 = circuit_mul(in35, in59);
    let t383 = circuit_add(in34, t382);
    let t384 = circuit_mul(in36, t0);
    let t385 = circuit_add(t383, t384);
    let t386 = circuit_mul(in37, t1);
    let t387 = circuit_add(t385, t386);
    let t388 = circuit_mul(in38, t2);
    let t389 = circuit_add(t387, t388);
    let t390 = circuit_mul(in39, t3);
    let t391 = circuit_add(t389, t390);
    let t392 = circuit_mul(in40, t4);
    let t393 = circuit_add(t391, t392);
    let t394 = circuit_mul(in41, t5);
    let t395 = circuit_add(t393, t394);
    let t396 = circuit_mul(in42, t6);
    let t397 = circuit_add(t395, t396);
    let t398 = circuit_mul(in43, t7);
    let t399 = circuit_add(t397, t398);
    let t400 = circuit_mul(in44, t8);
    let t401 = circuit_add(t399, t400);
    let t402 = circuit_mul(in45, t9);
    let t403 = circuit_add(t401, t402);
    let t404 = circuit_sub(t381, t403);
    let t405 = circuit_mul(in58, t404);
    let t406 = circuit_add(in32, t405);
    // commit_start_index=59, commit_end_index-1=58
    let p = get_p(0);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t91, t92, t207, t208, t323, t324,).new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t81);
    let o1 = outputs.get_output(t82);
    let o2 = outputs.get_output(t91);
    let o3 = outputs.get_output(t92);
    let o4 = outputs.get_output(t197);
    let o5 = outputs.get_output(t198);
    let o6 = outputs.get_output(t207);
    let o7 = outputs.get_output(t208);
    let o8 = outputs.get_output(t313);
    let o9 = outputs.get_output(t314);
    let o10 = outputs.get_output(t323);
    let o11 = outputs.get_output(t324);
    let o12 = outputs.get_output(t403);
    let o13 = outputs.get_output(t406);

    let res = array![o0, o1, o2, o3, o4, o5, o6, o7, o8, o9, o10, o11, o12, o13];
    return res;
}


#[cfg(test)]
mod tests {
    use core::traits::TryInto;

    use core::circuit::{
        RangeCheck96, AddMod, MulMod, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
        circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, u384,
        CircuitOutputsTrait, CircuitModulus, AddInputResultTrait, CircuitInputs,
    };

    use super::{
        get_BLS12_381_MP_CHECK_BIT0_LOOP_2_circuit, get_BLS12_381_MP_CHECK_BIT0_LOOP_3_circuit,
        get_BLS12_381_MP_CHECK_BIT1_LOOP_2_circuit, get_BLS12_381_MP_CHECK_BIT1_LOOP_3_circuit,
        get_BN254_MP_CHECK_BIT0_LOOP_2_circuit, get_BN254_MP_CHECK_BIT0_LOOP_3_circuit,
        get_BN254_MP_CHECK_BIT1_LOOP_2_circuit, get_BN254_MP_CHECK_BIT1_LOOP_3_circuit
    };

    #[test]
    fn test_get_BLS12_381_MP_CHECK_BIT0_LOOP_2_circuit_BLS12_381() {
        let input = array![];
        let output = array![
            u384 {
                limb0: 618487985849119746153898207,
                limb1: 50494925327844761621820530962,
                limb2: 79209977422733339904696010415,
                limb3: 707794712247162715436291605
            },
            u384 {
                limb0: 8592047408066784117010468336,
                limb1: 1200812945759698016624810566,
                limb2: 71011471462605786290699771965,
                limb3: 5356764194343744821314567583
            },
            u384 {
                limb0: 26512071291317017828261346156,
                limb1: 60874098858691418747922142058,
                limb2: 38615802239873895823699234554,
                limb3: 6165438379103124884474475383
            },
            u384 {
                limb0: 26602327191149697581561729571,
                limb1: 7576152873114963794606284522,
                limb2: 16797102000518695510255983749,
                limb3: 1027505561151160352119787428
            },
            u384 {
                limb0: 49056360857806713100987155263,
                limb1: 9925726762725689522901004676,
                limb2: 44228162109651189821987697494,
                limb3: 5828445171933981066011708031
            },
            u384 {
                limb0: 72721066873060254027581943954,
                limb1: 40914746087092191722257651992,
                limb2: 75965003318450448090290632383,
                limb3: 5808592983052040595122516529
            },
            u384 {
                limb0: 41333942124809251957753002659,
                limb1: 7833539542318487000197973845,
                limb2: 20403746555252066935559838102,
                limb3: 3907880619371083685966872543
            },
            u384 {
                limb0: 35464794103484878980454505615,
                limb1: 65449743417666811475427749275,
                limb2: 44210797858480610414542976551,
                limb3: 6283168776184254832215173527
            },
            u384 {
                limb0: 61294304294589484511230408379,
                limb1: 46452314032930837313569652265,
                limb2: 36783563239886683861805613820,
                limb3: 4348028522042405915036133568
            },
            u384 {
                limb0: 78799215823809794130719088004,
                limb1: 14468172845706345215923211397,
                limb2: 74478193793066800555568511302,
                limb3: 1034059523162198245719183030
            }
        ];
        let result = get_BLS12_381_MP_CHECK_BIT0_LOOP_2_circuit(input, 1);
        assert_eq!(result, output);
    }


    #[test]
    fn test_get_BLS12_381_MP_CHECK_BIT0_LOOP_3_circuit_BLS12_381() {
        let input = array![];
        let output = array![
            u384 {
                limb0: 77960032221170293025875840104,
                limb1: 9262423798777313190680894097,
                limb2: 42058049461695973428876665669,
                limb3: 2452708526069216495481756468
            },
            u384 {
                limb0: 32510748584130358426241591297,
                limb1: 46714508546361852686438877610,
                limb2: 55970026740331805037519764868,
                limb3: 5180454657125026111235877544
            },
            u384 {
                limb0: 58672670434443631990174915406,
                limb1: 34631294752801430968593143584,
                limb2: 53383483571266902554509294348,
                limb3: 2598710580674480624973022567
            },
            u384 {
                limb0: 53475906467903994481296977060,
                limb1: 63213501090447502046105784747,
                limb2: 26715216426083714622924632607,
                limb3: 6544819142515742657705186013
            },
            u384 {
                limb0: 36771622267222030030574120494,
                limb1: 6417730753533046619020323739,
                limb2: 73995613601182004181933822320,
                limb3: 1721145557308819370271868520
            },
            u384 {
                limb0: 68233621315315452633941390176,
                limb1: 48569034949121456567615141667,
                limb2: 65971938338202215021375632269,
                limb3: 5886090599475544669348876446
            },
            u384 {
                limb0: 25456967855206509191486379198,
                limb1: 71049429472363339198523767750,
                limb2: 76991401300201676357659969325,
                limb3: 3448648997224802382646886417
            },
            u384 {
                limb0: 72427952280044673147147930685,
                limb1: 76553118229614547593642074241,
                limb2: 24760961166853536396967143606,
                limb3: 4441920849483363143218052645
            },
            u384 {
                limb0: 7398610985195487423551448254,
                limb1: 9275660553690166850209728870,
                limb2: 38941252741930505537982589131,
                limb3: 1659860555842859761587808082
            },
            u384 {
                limb0: 50126814899403098731056068273,
                limb1: 13262257792726120758833674168,
                limb2: 11010508617903085887335282700,
                limb3: 6756918666148352284115669857
            },
            u384 {
                limb0: 46480195408766329902017016451,
                limb1: 24259674075537221419043257135,
                limb2: 13538074614092808234147435504,
                limb3: 2615871103725226730347611055
            },
            u384 {
                limb0: 68278979564094761491247131907,
                limb1: 49347605807388017695098305631,
                limb2: 62045471832911733718590562334,
                limb3: 2688682008993000269266076460
            },
            u384 {
                limb0: 48927002912492697252995951344,
                limb1: 6122266071105819532026902618,
                limb2: 40773718414337283867376622695,
                limb3: 7230834420115323289175086833
            },
            u384 {
                limb0: 15968709216788765397624166508,
                limb1: 7745232462621062082196632153,
                limb2: 11816746246707253043528405036,
                limb3: 4787181851450821755730150242
            }
        ];
        let result = get_BLS12_381_MP_CHECK_BIT0_LOOP_3_circuit(input, 1);
        assert_eq!(result, output);
    }


    #[test]
    fn test_get_BLS12_381_MP_CHECK_BIT1_LOOP_2_circuit_BLS12_381() {
        let input = array![];
        let output = array![
            u384 {
                limb0: 3000435909000046433586274973,
                limb1: 42946139233231522336603853529,
                limb2: 31192705021457818412629072680,
                limb3: 783651933022767728640107551
            },
            u384 {
                limb0: 17690247911870466030702470216,
                limb1: 51232376639812262844489868068,
                limb2: 18766006685079634207705974746,
                limb3: 5565457754853615926051543859
            },
            u384 {
                limb0: 1675501677072500824327840309,
                limb1: 36674475372886062486007006576,
                limb2: 78233178829277853540540637535,
                limb3: 7195574568702930953815496641
            },
            u384 {
                limb0: 63289188156292803086865357741,
                limb1: 27118773224140456265892878266,
                limb2: 11289292386400010868981043165,
                limb3: 7103521804877212298684265595
            },
            u384 {
                limb0: 46847423281187010114673337066,
                limb1: 74398897042745379425288970397,
                limb2: 51511158847040731899769096406,
                limb3: 2846889965399889560001064527
            },
            u384 {
                limb0: 37046749271240466827713251913,
                limb1: 32302291623142103278669639033,
                limb2: 22467473036693745072301380885,
                limb3: 3815435259287645969050564313
            },
            u384 {
                limb0: 58174939415781446671934102353,
                limb1: 64607739840020338288920836174,
                limb2: 5132068364862449358013565184,
                limb3: 3173273468466396563726311047
            },
            u384 {
                limb0: 38506614642049806498955146772,
                limb1: 6920110721189347610179966759,
                limb2: 63387978768288822011931192653,
                limb3: 7650999097373414036893585301
            },
            u384 {
                limb0: 65228295184618165648257801663,
                limb1: 50146733263327834094768586207,
                limb2: 56109714606013444172887528308,
                limb3: 3136764822489504017487753105
            },
            u384 {
                limb0: 41551388814656580226603947454,
                limb1: 51525948909318660976412492065,
                limb2: 70993551058117875115939091809,
                limb3: 2926782985019620850269272082
            }
        ];
        let result = get_BLS12_381_MP_CHECK_BIT1_LOOP_2_circuit(input, 1);
        assert_eq!(result, output);
    }


    #[test]
    fn test_get_BLS12_381_MP_CHECK_BIT1_LOOP_3_circuit_BLS12_381() {
        let input = array![];
        let output = array![
            u384 {
                limb0: 47903907703624929559264782086,
                limb1: 58135429060622844156936567186,
                limb2: 9745506356432786647363264542,
                limb3: 3747777144277348147830436207
            },
            u384 {
                limb0: 72829809136120536418523500083,
                limb1: 23876435025316271294696652734,
                limb2: 28697238569007701650368511683,
                limb3: 4847699307441180649335242647
            },
            u384 {
                limb0: 56177268929838999697254720780,
                limb1: 18630870945252961290111973062,
                limb2: 66691276634298885127262325862,
                limb3: 4546048984771394216794395901
            },
            u384 {
                limb0: 73078088174038126219776584594,
                limb1: 39027618439385157797180435668,
                limb2: 12874396961879851492461229371,
                limb3: 615819797374384023076554937
            },
            u384 {
                limb0: 10005159325788350239792290453,
                limb1: 43303640867533239293266788735,
                limb2: 52205198093909045175361331116,
                limb3: 7500246833032239823178642900
            },
            u384 {
                limb0: 54499267986633601360511268351,
                limb1: 71668531204797040706644978370,
                limb2: 48529667604996579862956476180,
                limb3: 977387679187586013027365470
            },
            u384 {
                limb0: 15230986943117299133583867484,
                limb1: 18347492058300660404960504184,
                limb2: 38256670046591324067434694990,
                limb3: 7013406174358966545499865631
            },
            u384 {
                limb0: 79217009656948401474912600882,
                limb1: 5274184736251172934977351599,
                limb2: 35507014748959612231628771996,
                limb3: 7180489793086252222638644520
            },
            u384 {
                limb0: 5534682106703014235909304208,
                limb1: 39123401333229774995705614380,
                limb2: 5116374706503435520339846834,
                limb3: 4321981777338485807053044740
            },
            u384 {
                limb0: 20557688312374780551868190956,
                limb1: 77030137198589012807193651991,
                limb2: 12182802275061504221590190337,
                limb3: 4722304308682233447032803763
            },
            u384 {
                limb0: 8162990005607767788581959007,
                limb1: 56648419810464691636596344682,
                limb2: 62543278258442501758859072967,
                limb3: 3103845784193855239661170779
            },
            u384 {
                limb0: 39394633705398376814927371450,
                limb1: 19273121878678550744899094032,
                limb2: 2998431094541904075196043039,
                limb3: 2625995505017731638323398626
            },
            u384 {
                limb0: 463125400798468703316256937,
                limb1: 67989632315058140983598433195,
                limb2: 5977028606252217949919623771,
                limb3: 4029790631252005446970546712
            },
            u384 {
                limb0: 48960245874226530902216861605,
                limb1: 2699105708861686939258970040,
                limb2: 63124963692928615059646403057,
                limb3: 3756433087080852706821715660
            }
        ];
        let result = get_BLS12_381_MP_CHECK_BIT1_LOOP_3_circuit(input, 1);
        assert_eq!(result, output);
    }


    #[test]
    fn test_get_BN254_MP_CHECK_BIT0_LOOP_2_circuit_BN254() {
        let input = array![];
        let output = array![
            u384 {
                limb0: 31957237928880287257843204740,
                limb1: 36464357750266242302140763804,
                limb2: 3466004764454010724,
                limb3: 0
            },
            u384 {
                limb0: 4169825146017910774979562048,
                limb1: 51163140545246920487586156731,
                limb2: 2714809416780703012,
                limb3: 0
            },
            u384 {
                limb0: 71407735970025914416342154664,
                limb1: 21142349671728802797109333441,
                limb2: 1983369111800154832,
                limb3: 0
            },
            u384 {
                limb0: 64675261380355965070773632151,
                limb1: 2134752314355137351568442334,
                limb2: 2190651963779748046,
                limb3: 0
            },
            u384 {
                limb0: 16395001394781919942489661018,
                limb1: 60487938120891032401631033134,
                limb2: 173754134943013354,
                limb3: 0
            },
            u384 {
                limb0: 44792015890164317261392874099,
                limb1: 79051080998616593877648359787,
                limb2: 771849977942249380,
                limb3: 0
            },
            u384 {
                limb0: 75262298131888983825835341145,
                limb1: 11118744687545481126940290157,
                limb2: 1954219131032269084,
                limb3: 0
            },
            u384 {
                limb0: 50040266701548789198928454621,
                limb1: 39334657599680662758441966474,
                limb2: 2451363392524310420,
                limb3: 0
            },
            u384 {
                limb0: 38900953913841226116577660100,
                limb1: 64361788686738187276997047546,
                limb2: 1733031104971618555,
                limb3: 0
            },
            u384 {
                limb0: 12526129394525241473454726386,
                limb1: 36828478464228479733835771467,
                limb2: 1564781034984565959,
                limb3: 0
            }
        ];
        let result = get_BN254_MP_CHECK_BIT0_LOOP_2_circuit(input, 0);
        assert_eq!(result, output);
    }


    #[test]
    fn test_get_BN254_MP_CHECK_BIT0_LOOP_3_circuit_BN254() {
        let input = array![];
        let output = array![
            u384 {
                limb0: 73110009385693236628959310134,
                limb1: 48542234489720987208133344285,
                limb2: 997459230405000478,
                limb3: 0
            },
            u384 {
                limb0: 61135568929173011351749184761,
                limb1: 68602014746416271920832107059,
                limb2: 3480197153364258520,
                limb3: 0
            },
            u384 {
                limb0: 19221356030769444572110543676,
                limb1: 8849304923021752796971504570,
                limb2: 3193354536998215088,
                limb3: 0
            },
            u384 {
                limb0: 64439330686332988691030785978,
                limb1: 71225080730316980956872393137,
                limb2: 935144165277570342,
                limb3: 0
            },
            u384 {
                limb0: 65540949803553105841417550434,
                limb1: 36944958398587684164937777337,
                limb2: 3396740178993956680,
                limb3: 0
            },
            u384 {
                limb0: 15590679009397798740588217906,
                limb1: 52207688232104245670844029743,
                limb2: 790700966894207261,
                limb3: 0
            },
            u384 {
                limb0: 18425417763937502648167402480,
                limb1: 35618452044493759630004088963,
                limb2: 1824776683807670932,
                limb3: 0
            },
            u384 {
                limb0: 52827907457313184917240852997,
                limb1: 72312351396284705961794934531,
                limb2: 304698505045556857,
                limb3: 0
            },
            u384 {
                limb0: 52137962320249470571747091213,
                limb1: 74128656133277500637308513042,
                limb2: 3466531614201835784,
                limb3: 0
            },
            u384 {
                limb0: 5419027002055287707410583927,
                limb1: 52474522848300363019914047693,
                limb2: 1725994496022748592,
                limb3: 0
            },
            u384 {
                limb0: 70717643741967760721732750603,
                limb1: 26200927499249483872616589121,
                limb2: 1142446086901356852,
                limb3: 0
            },
            u384 {
                limb0: 42369004264933421406405761574,
                limb1: 14200042407601021556421815126,
                limb2: 2784524856378259189,
                limb3: 0
            },
            u384 {
                limb0: 14587762336548837755021306198,
                limb1: 882801216080183849722452208,
                limb2: 364487128091007969,
                limb3: 0
            },
            u384 {
                limb0: 43354543229157520450708410761,
                limb1: 46532693501040029234389976439,
                limb2: 3380501187741865066,
                limb3: 0
            }
        ];
        let result = get_BN254_MP_CHECK_BIT0_LOOP_3_circuit(input, 0);
        assert_eq!(result, output);
    }


    #[test]
    fn test_get_BN254_MP_CHECK_BIT1_LOOP_2_circuit_BN254() {
        let input = array![];
        let output = array![
            u384 {
                limb0: 18272582789367327208841512588,
                limb1: 72785484546258035323116671388,
                limb2: 3051984757082741876,
                limb3: 0
            },
            u384 {
                limb0: 11469436292283935394934716175,
                limb1: 71722888388281311066501163130,
                limb2: 1250532615973513858,
                limb3: 0
            },
            u384 {
                limb0: 28194825027728255041555449622,
                limb1: 71029181907972906395282704743,
                limb2: 1940818378267543121,
                limb3: 0
            },
            u384 {
                limb0: 77063170631589932257955650740,
                limb1: 31931296654670485102382980155,
                limb2: 462269855839859794,
                limb3: 0
            },
            u384 {
                limb0: 48229767955413177808734459853,
                limb1: 49585926382404863846568328692,
                limb2: 221015987957641200,
                limb3: 0
            },
            u384 {
                limb0: 42335931481103332867036524553,
                limb1: 72426868119868815490165792468,
                limb2: 1737366703404034630,
                limb3: 0
            },
            u384 {
                limb0: 55036568123645247335692397040,
                limb1: 48702730094750560640936563842,
                limb2: 697204712964042979,
                limb3: 0
            },
            u384 {
                limb0: 7568088708919693913532550861,
                limb1: 769974477901612331497972473,
                limb2: 3060364644402622722,
                limb3: 0
            },
            u384 {
                limb0: 33886526222037925444223167122,
                limb1: 68106623677641113932373117602,
                limb2: 140446893575598682,
                limb3: 0
            },
            u384 {
                limb0: 70091637378325310583316166210,
                limb1: 29258011657750854492213989235,
                limb2: 1421193742695029010,
                limb3: 0
            }
        ];
        let result = get_BN254_MP_CHECK_BIT1_LOOP_2_circuit(input, 0);
        assert_eq!(result, output);
    }


    #[test]
    fn test_get_BN254_MP_CHECK_BIT1_LOOP_3_circuit_BN254() {
        let input = array![];
        let output = array![
            u384 {
                limb0: 49584249748506415967189081636,
                limb1: 12402601948661555683922005230,
                limb2: 426114063350142118,
                limb3: 0
            },
            u384 {
                limb0: 76974672569664075028175983368,
                limb1: 73339575641456931835631208183,
                limb2: 1837016558452640077,
                limb3: 0
            },
            u384 {
                limb0: 58868999526335985505273401567,
                limb1: 27871628340956808309116591701,
                limb2: 2002925188967957689,
                limb3: 0
            },
            u384 {
                limb0: 25519050026673305994610661651,
                limb1: 74195109290342964863566574506,
                limb2: 1597576203129429296,
                limb3: 0
            },
            u384 {
                limb0: 51008332476028670602606565356,
                limb1: 49061123660104634134721634235,
                limb2: 2880360007503728621,
                limb3: 0
            },
            u384 {
                limb0: 4151073464481825982820030392,
                limb1: 41936894989261774642309781490,
                limb2: 3145529420058421462,
                limb3: 0
            },
            u384 {
                limb0: 59294740428686008413155489428,
                limb1: 45730911581708903285359713395,
                limb2: 1699599863200844857,
                limb3: 0
            },
            u384 {
                limb0: 19995921587038396382567419781,
                limb1: 49463299389536982293488810743,
                limb2: 2517115626831783465,
                limb3: 0
            },
            u384 {
                limb0: 44617958112179285453042447801,
                limb1: 34250715050855344719137977004,
                limb2: 1640073940638512928,
                limb3: 0
            },
            u384 {
                limb0: 55066038002712853609884709907,
                limb1: 73864927432955706396856287624,
                limb2: 2087862052235279811,
                limb3: 0
            },
            u384 {
                limb0: 7581496579811682502416896733,
                limb1: 18984383619717274906702062766,
                limb2: 2407334129204698529,
                limb3: 0
            },
            u384 {
                limb0: 62888218374049838370054112806,
                limb1: 25706852416509441239597779716,
                limb2: 2107549083707845190,
                limb3: 0
            },
            u384 {
                limb0: 3685033134930152513005794090,
                limb1: 38399395927005560663522178643,
                limb2: 1596087632635349985,
                limb3: 0
            },
            u384 {
                limb0: 24808077461297222157256821843,
                limb1: 65228813510031162325763203939,
                limb2: 433350388544702277,
                limb3: 0
            }
        ];
        let result = get_BN254_MP_CHECK_BIT1_LOOP_3_circuit(input, 0);
        assert_eq!(result, output);
    }
}
