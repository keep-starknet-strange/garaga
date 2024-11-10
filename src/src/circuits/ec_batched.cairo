use core::circuit::{
    RangeCheck96, AddMod, MulMod, u384, u96, circuit_add, circuit_sub, circuit_mul, circuit_inverse,
    EvalCircuitResult, EvalCircuitTrait, CircuitOutputsTrait, CircuitModulus, AddInputResultTrait,
    CircuitInputs, CircuitDefinition, CircuitData, CircuitInputAccumulator
};
use garaga::core::circuit::AddInputResultTrait2;
use core::circuit::CircuitElement as CE;
use core::circuit::CircuitInput as CI;
use garaga::definitions::{
    get_a, get_b, get_p, get_g, get_min_one, G1Point, G2Point, E12D, u288, E12DMulQuotient,
    G1G2Pair, BNProcessedPair, BLSProcessedPair, MillerLoopResultScalingFactor, G2Line,
    get_BN254_modulus
};
use garaga::ec_ops::{SlopeInterceptOutput, FunctionFeltEvaluations, FunctionFelt};
use core::option::Option;
use garaga::single_pairing_tower::E12T;

#[inline(always)]
fn run_FULL_ECIP_1P_circuit(
    p_0: G1Point,
    epns_low: Span<(u384, u384, u384, u384)>,
    epns_high: Span<(u384, u384, u384, u384)>,
    q_low: G1Point,
    q_high: G1Point,
    q_high_shifted: G1Point,
    a0: G1Point,
    A_weirstrass: u384,
    base_rlc: u384,
    SumDlogDiv: FunctionFelt,
    curve_index: usize
) -> (u384,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x3
    let in1 = CE::<CI<1>> {}; // 0x0
    let in2 = CE::<CI<2>> {}; // 0x3f8ba6c287b56e5a1f62db183b5d99b
    let in3 = CE::<CI<3>> {}; // 0x103f8ba6c287b56e5a1f62db183b5d99b
    let in4 = CE::<CI<4>> {}; // -0x1 % p

    // INPUT stack
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
    let t0 = circuit_mul(in21, in21);
    let t1 = circuit_mul(in0, t0);
    let t2 = circuit_add(t1, in23);
    let t3 = circuit_add(in22, in22);
    let t4 = circuit_inverse(t3);
    let t5 = circuit_mul(t2, t4);
    let t6 = circuit_mul(in21, t5);
    let t7 = circuit_sub(in22, t6);
    let t8 = circuit_mul(t5, t5);
    let t9 = circuit_add(in21, in21);
    let t10 = circuit_sub(t8, t9);
    let t11 = circuit_sub(in21, t10);
    let t12 = circuit_mul(t5, t11);
    let t13 = circuit_sub(t12, in22);
    let t14 = circuit_sub(in1, t13);
    let t15 = circuit_sub(t14, in22);
    let t16 = circuit_sub(t10, in21);
    let t17 = circuit_inverse(t16);
    let t18 = circuit_mul(t15, t17);
    let t19 = circuit_mul(t18, t14);
    let t20 = circuit_add(t14, t14);
    let t21 = circuit_sub(in21, t10);
    let t22 = circuit_mul(t20, t21);
    let t23 = circuit_mul(t10, t10);
    let t24 = circuit_mul(in0, t23);
    let t25 = circuit_add(t19, t19);
    let t26 = circuit_sub(in23, t25);
    let t27 = circuit_add(t24, t26);
    let t28 = circuit_inverse(t27);
    let t29 = circuit_mul(t22, t28);
    let t30 = circuit_add(t18, t18);
    let t31 = circuit_add(t29, t30);
    let t32 = circuit_mul(in28, in21); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t33 = circuit_add(in27, t32); // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    let t34 = circuit_mul(t33, in21); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t35 = circuit_add(in26, t34); // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    let t36 = circuit_mul(t35, in21); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t37 = circuit_add(in25, t36); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t38 = circuit_mul(in33, in21); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t39 = circuit_add(in32, t38); // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    let t40 = circuit_mul(t39, in21); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t41 = circuit_add(in31, t40); // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    let t42 = circuit_mul(t41, in21); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t43 = circuit_add(in30, t42); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t44 = circuit_mul(t43, in21); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t45 = circuit_add(in29, t44); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t46 = circuit_inverse(t45);
    let t47 = circuit_mul(t37, t46);
    let t48 = circuit_mul(in38, in21); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t49 = circuit_add(in37, t48); // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    let t50 = circuit_mul(t49, in21); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t51 = circuit_add(in36, t50); // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    let t52 = circuit_mul(t51, in21); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t53 = circuit_add(in35, t52); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t54 = circuit_mul(t53, in21); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t55 = circuit_add(in34, t54); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t56 = circuit_mul(in46, in21); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t57 = circuit_add(in45, t56); // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    let t58 = circuit_mul(t57, in21); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t59 = circuit_add(in44, t58); // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    let t60 = circuit_mul(t59, in21); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t61 = circuit_add(in43, t60); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t62 = circuit_mul(t61, in21); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t63 = circuit_add(in42, t62); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t64 = circuit_mul(t63, in21); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t65 = circuit_add(in41, t64); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t66 = circuit_mul(t65, in21); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t67 = circuit_add(in40, t66); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t68 = circuit_mul(t67, in21); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t69 = circuit_add(in39, t68); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t70 = circuit_inverse(t69);
    let t71 = circuit_mul(t55, t70);
    let t72 = circuit_mul(in22, t71);
    let t73 = circuit_add(t47, t72);
    let t74 = circuit_mul(in28, t10); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t75 = circuit_add(in27, t74); // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    let t76 = circuit_mul(t75, t10); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t77 = circuit_add(in26, t76); // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    let t78 = circuit_mul(t77, t10); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t79 = circuit_add(in25, t78); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t80 = circuit_mul(in33, t10); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t81 = circuit_add(in32, t80); // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    let t82 = circuit_mul(t81, t10); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t83 = circuit_add(in31, t82); // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    let t84 = circuit_mul(t83, t10); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t85 = circuit_add(in30, t84); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t86 = circuit_mul(t85, t10); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t87 = circuit_add(in29, t86); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t88 = circuit_inverse(t87);
    let t89 = circuit_mul(t79, t88);
    let t90 = circuit_mul(in38, t10); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t91 = circuit_add(in37, t90); // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    let t92 = circuit_mul(t91, t10); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t93 = circuit_add(in36, t92); // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    let t94 = circuit_mul(t93, t10); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t95 = circuit_add(in35, t94); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t96 = circuit_mul(t95, t10); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t97 = circuit_add(in34, t96); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t98 = circuit_mul(in46, t10); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t99 = circuit_add(in45, t98); // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    let t100 = circuit_mul(t99, t10); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t101 = circuit_add(in44, t100); // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    let t102 = circuit_mul(t101, t10); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t103 = circuit_add(in43, t102); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t104 = circuit_mul(t103, t10); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t105 = circuit_add(in42, t104); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t106 = circuit_mul(t105, t10); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t107 = circuit_add(in41, t106); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t108 = circuit_mul(t107, t10); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t109 = circuit_add(in40, t108); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t110 = circuit_mul(t109, t10); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t111 = circuit_add(in39, t110); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t112 = circuit_inverse(t111);
    let t113 = circuit_mul(t97, t112);
    let t114 = circuit_mul(t14, t113);
    let t115 = circuit_add(t89, t114);
    let t116 = circuit_mul(t31, t73);
    let t117 = circuit_mul(t29, t115);
    let t118 = circuit_sub(t116, t117);
    let t119 = circuit_sub(in21, in5);
    let t120 = circuit_mul(t5, in5);
    let t121 = circuit_add(t120, t7);
    let t122 = circuit_sub(in6, t121);
    let t123 = circuit_sub(in1, in6);
    let t124 = circuit_sub(t123, t121);
    let t125 = circuit_mul(in9, in7);
    let t126 = circuit_inverse(t122);
    let t127 = circuit_mul(t119, t126);
    let t128 = circuit_mul(t125, t127);
    let t129 = circuit_mul(in10, in8);
    let t130 = circuit_inverse(t124);
    let t131 = circuit_mul(t119, t130);
    let t132 = circuit_mul(t129, t131);
    let t133 = circuit_add(t128, t132);
    let t134 = circuit_add(in1, t133);
    let t135 = circuit_sub(in21, in15);
    let t136 = circuit_mul(t5, in15);
    let t137 = circuit_add(t136, t7);
    let t138 = circuit_sub(in1, in16);
    let t139 = circuit_sub(t138, t137);
    let t140 = circuit_inverse(t139);
    let t141 = circuit_mul(t135, t140);
    let t142 = circuit_add(t134, t141);
    let t143 = circuit_sub(in21, in5);
    let t144 = circuit_mul(t5, in5);
    let t145 = circuit_add(t144, t7);
    let t146 = circuit_sub(in6, t145);
    let t147 = circuit_sub(in1, in6);
    let t148 = circuit_sub(t147, t145);
    let t149 = circuit_mul(in13, in11);
    let t150 = circuit_inverse(t146);
    let t151 = circuit_mul(t143, t150);
    let t152 = circuit_mul(t149, t151);
    let t153 = circuit_mul(in14, in12);
    let t154 = circuit_inverse(t148);
    let t155 = circuit_mul(t143, t154);
    let t156 = circuit_mul(t153, t155);
    let t157 = circuit_add(t152, t156);
    let t158 = circuit_add(in1, t157);
    let t159 = circuit_sub(in21, in17);
    let t160 = circuit_mul(t5, in17);
    let t161 = circuit_add(t160, t7);
    let t162 = circuit_sub(in1, in18);
    let t163 = circuit_sub(t162, t161);
    let t164 = circuit_inverse(t163);
    let t165 = circuit_mul(t159, t164);
    let t166 = circuit_add(t158, t165);
    let t167 = circuit_sub(in21, in19);
    let t168 = circuit_mul(t5, in19);
    let t169 = circuit_add(t168, t7);
    let t170 = circuit_sub(in20, t169);
    let t171 = circuit_sub(in1, in20);
    let t172 = circuit_sub(t171, t169);
    let t173 = circuit_mul(in4, in2);
    let t174 = circuit_inverse(t170);
    let t175 = circuit_mul(t167, t174);
    let t176 = circuit_mul(t173, t175);
    let t177 = circuit_mul(in4, in3);
    let t178 = circuit_inverse(t172);
    let t179 = circuit_mul(t167, t178);
    let t180 = circuit_mul(t177, t179);
    let t181 = circuit_add(t176, t180);
    let t182 = circuit_add(in1, t181);
    let t183 = circuit_sub(in21, in19);
    let t184 = circuit_mul(t5, in19);
    let t185 = circuit_add(t184, t7);
    let t186 = circuit_sub(in1, in20);
    let t187 = circuit_sub(t186, t185);
    let t188 = circuit_inverse(t187);
    let t189 = circuit_mul(t183, t188);
    let t190 = circuit_add(t182, t189);
    let t191 = circuit_mul(in24, in24);
    let t192 = circuit_mul(t191, in24);
    let t193 = circuit_mul(t142, in24);
    let t194 = circuit_mul(t166, t191);
    let t195 = circuit_mul(t190, t192);
    let t196 = circuit_add(t193, t194);
    let t197 = circuit_add(t196, t195);
    let t198 = circuit_sub(t118, t197);

    let modulus = get_p(curve_index);
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([modulus.limb0, modulus.limb1, modulus.limb2, modulus.limb3])
        .unwrap();

    let mut circuit_inputs = (t198,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x3, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in1
    circuit_inputs = circuit_inputs
        .next_2([0x287b56e5a1f62db183b5d99b, 0x3f8ba6c, 0x0, 0x0]); // in2
    circuit_inputs = circuit_inputs
        .next_2([0x287b56e5a1f62db183b5d99b, 0x103f8ba6c, 0x0, 0x0]); // in3
    circuit_inputs = circuit_inputs
        .next_2(
            [0x6871ca8d3c208c16d87cfd46, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0]
        ); // in4
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(p_0.x); // in5
    circuit_inputs = circuit_inputs.next_2(p_0.y); // in6
    let mut epns_low = epns_low; // in7
    for val in epns_low { // in8
        let (ep, en, sp, sn) = *val; // in9
        circuit_inputs = circuit_inputs.next_2(ep); // in10
        circuit_inputs = circuit_inputs.next_2(en); // in11
        circuit_inputs = circuit_inputs.next_2(sp); // in12
        circuit_inputs = circuit_inputs.next_2(sn); // in13
    }; // in14
    let mut epns_high = epns_high; // in11
    for val in epns_high { // in12
        let (ep, en, sp, sn) = *val; // in13
        circuit_inputs = circuit_inputs.next_2(ep); // in14
        circuit_inputs = circuit_inputs.next_2(en); // in15
        circuit_inputs = circuit_inputs.next_2(sp); // in16
        circuit_inputs = circuit_inputs.next_2(sn); // in17
    }; // in18
    circuit_inputs = circuit_inputs.next_2(q_low.x); // in15
    circuit_inputs = circuit_inputs.next_2(q_low.y); // in16
    circuit_inputs = circuit_inputs.next_2(q_high.x); // in17
    circuit_inputs = circuit_inputs.next_2(q_high.y); // in18
    circuit_inputs = circuit_inputs.next_2(q_high_shifted.x); // in19
    circuit_inputs = circuit_inputs.next_2(q_high_shifted.y); // in20
    circuit_inputs = circuit_inputs.next_2(a0.x); // in21
    circuit_inputs = circuit_inputs.next_2(a0.y); // in22
    circuit_inputs = circuit_inputs.next_2(A_weirstrass); // in23
    circuit_inputs = circuit_inputs.next_2(base_rlc); // in24
    let mut SumDlogDiv_a_num = SumDlogDiv.a_num;
    while let Option::Some(val) = SumDlogDiv_a_num.pop_front() {
        circuit_inputs = circuit_inputs.next_2(*val);
    };
    let mut SumDlogDiv_a_den = SumDlogDiv.a_den;
    while let Option::Some(val) = SumDlogDiv_a_den.pop_front() {
        circuit_inputs = circuit_inputs.next_2(*val);
    };
    let mut SumDlogDiv_b_num = SumDlogDiv.b_num;
    while let Option::Some(val) = SumDlogDiv_b_num.pop_front() {
        circuit_inputs = circuit_inputs.next_2(*val);
    };
    let mut SumDlogDiv_b_den = SumDlogDiv.b_den;
    while let Option::Some(val) = SumDlogDiv_b_den.pop_front() {
        circuit_inputs = circuit_inputs.next_2(*val);
    };
    // in25 - in46

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let final_check: u384 = outputs.get_output(t198);
    return (final_check,);
}

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

    use super::{run_FULL_ECIP_1P_circuit};
}
