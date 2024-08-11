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
    get_a, get_b, get_p, get_g, get_min_one, G1Point, G2Point, E12D, E12DMulQuotient, G1G2Pair,
    BNProcessedPair, BLSProcessedPair, MillerLoopResultScalingFactor, G2Line
};
use garaga::ec_ops::{SlopeInterceptOutput, FunctionFeltEvaluations, FunctionFelt};
use core::option::Option;

fn run_ACC_EVAL_POINT_CHALLENGE_SIGNED_circuit(
    acc: u384,
    m: u384,
    b: u384,
    xA: u384,
    p: G1Point,
    ep: u384,
    en: u384,
    sp: u384,
    sn: u384,
    curve_index: usize
) -> (u384,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0

    // INPUT stack
    let (in1, in2, in3) = (CE::<CI<1>> {}, CE::<CI<2>> {}, CE::<CI<3>> {});
    let (in4, in5, in6) = (CE::<CI<4>> {}, CE::<CI<5>> {}, CE::<CI<6>> {});
    let (in7, in8, in9) = (CE::<CI<7>> {}, CE::<CI<8>> {}, CE::<CI<9>> {});
    let in10 = CE::<CI<10>> {};
    let t0 = circuit_sub(in4, in5);
    let t1 = circuit_mul(in2, in5);
    let t2 = circuit_add(t1, in3);
    let t3 = circuit_sub(in6, t2);
    let t4 = circuit_sub(in0, in6);
    let t5 = circuit_sub(t4, t2);
    let t6 = circuit_mul(in9, in7);
    let t7 = circuit_inverse(t3);
    let t8 = circuit_mul(t0, t7);
    let t9 = circuit_mul(t6, t8);
    let t10 = circuit_mul(in10, in8);
    let t11 = circuit_inverse(t5);
    let t12 = circuit_mul(t0, t11);
    let t13 = circuit_mul(t10, t12);
    let t14 = circuit_add(t9, t13);
    let t15 = circuit_add(in1, t14);

    let modulus = get_p(curve_index);
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([modulus.limb0, modulus.limb1, modulus.limb2, modulus.limb3])
        .unwrap();

    let mut circuit_inputs = (t15,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in0
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(acc); // in1
    circuit_inputs = circuit_inputs.next_2(m); // in2
    circuit_inputs = circuit_inputs.next_2(b); // in3
    circuit_inputs = circuit_inputs.next_2(xA); // in4
    circuit_inputs = circuit_inputs.next_2(p.x); // in5
    circuit_inputs = circuit_inputs.next_2(p.y); // in6
    circuit_inputs = circuit_inputs.next_2(ep); // in7
    circuit_inputs = circuit_inputs.next_2(en); // in8
    circuit_inputs = circuit_inputs.next_2(sp); // in9
    circuit_inputs = circuit_inputs.next_2(sn); // in10

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res_acc: u384 = outputs.get_output(t15);
    return (res_acc,);
}
fn run_ACC_FUNCTION_CHALLENGE_DUPL_circuit(
    f_a0_accs: FunctionFeltEvaluations,
    f_a1_accs: FunctionFeltEvaluations,
    xA0: u384,
    xA2: u384,
    xA0_power: u384,
    xA2_power: u384,
    next_a_num_coeff: u384,
    next_a_den_coeff: u384,
    next_b_num_coeff: u384,
    next_b_den_coeff: u384,
    curve_index: usize
) -> (FunctionFeltEvaluations, FunctionFeltEvaluations, u384, u384) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13, in14) = (CE::<CI<12>> {}, CE::<CI<13>> {}, CE::<CI<14>> {});
    let in15 = CE::<CI<15>> {};
    let t0 = circuit_mul(in12, in10);
    let t1 = circuit_add(in0, t0);
    let t2 = circuit_mul(in10, in8);
    let t3 = circuit_mul(in13, t2);
    let t4 = circuit_add(in1, t3);
    let t5 = circuit_mul(in14, t2);
    let t6 = circuit_add(in2, t5);
    let t7 = circuit_mul(t2, in8);
    let t8 = circuit_mul(t7, in8);
    let t9 = circuit_mul(t8, in8);
    let t10 = circuit_mul(in15, t9);
    let t11 = circuit_add(in3, t10);
    let t12 = circuit_mul(in12, in11);
    let t13 = circuit_add(in4, t12);
    let t14 = circuit_mul(in11, in9);
    let t15 = circuit_mul(in13, t14);
    let t16 = circuit_add(in5, t15);
    let t17 = circuit_mul(in14, t14);
    let t18 = circuit_add(in6, t17);
    let t19 = circuit_mul(t14, in9);
    let t20 = circuit_mul(t19, in9);
    let t21 = circuit_mul(t20, in9);
    let t22 = circuit_mul(in15, t21);
    let t23 = circuit_add(in7, t22);

    let modulus = get_p(curve_index);
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([modulus.limb0, modulus.limb1, modulus.limb2, modulus.limb3])
        .unwrap();

    let mut circuit_inputs = (t1, t4, t6, t11, t13, t16, t18, t23, t2, t14,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(f_a0_accs.a_num); // in0
    circuit_inputs = circuit_inputs.next_2(f_a0_accs.a_den); // in1
    circuit_inputs = circuit_inputs.next_2(f_a0_accs.b_num); // in2
    circuit_inputs = circuit_inputs.next_2(f_a0_accs.b_den); // in3
    circuit_inputs = circuit_inputs.next_2(f_a1_accs.a_num); // in4
    circuit_inputs = circuit_inputs.next_2(f_a1_accs.a_den); // in5
    circuit_inputs = circuit_inputs.next_2(f_a1_accs.b_num); // in6
    circuit_inputs = circuit_inputs.next_2(f_a1_accs.b_den); // in7
    circuit_inputs = circuit_inputs.next_2(xA0); // in8
    circuit_inputs = circuit_inputs.next_2(xA2); // in9
    circuit_inputs = circuit_inputs.next_2(xA0_power); // in10
    circuit_inputs = circuit_inputs.next_2(xA2_power); // in11
    circuit_inputs = circuit_inputs.next_2(next_a_num_coeff); // in12
    circuit_inputs = circuit_inputs.next_2(next_a_den_coeff); // in13
    circuit_inputs = circuit_inputs.next_2(next_b_num_coeff); // in14
    circuit_inputs = circuit_inputs.next_2(next_b_den_coeff); // in15

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let next_f_a0_accs: FunctionFeltEvaluations = FunctionFeltEvaluations {
        a_num: outputs.get_output(t1),
        a_den: outputs.get_output(t4),
        b_num: outputs.get_output(t6),
        b_den: outputs.get_output(t11)
    };
    let next_f_a1_accs: FunctionFeltEvaluations = FunctionFeltEvaluations {
        a_num: outputs.get_output(t13),
        a_den: outputs.get_output(t16),
        b_num: outputs.get_output(t18),
        b_den: outputs.get_output(t23)
    };
    let next_xA0_power: u384 = outputs.get_output(t2);
    let next_xA2_power: u384 = outputs.get_output(t14);
    return (next_f_a0_accs, next_f_a1_accs, next_xA0_power, next_xA2_power);
}
fn run_ADD_EC_POINT_circuit(p: G1Point, q: G1Point, curve_index: usize) -> (G1Point,) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let in3 = CE::<CI<3>> {};
    let t0 = circuit_sub(in1, in3);
    let t1 = circuit_sub(in0, in2);
    let t2 = circuit_inverse(t1);
    let t3 = circuit_mul(t0, t2);
    let t4 = circuit_mul(t3, t3);
    let t5 = circuit_sub(t4, in0);
    let t6 = circuit_sub(t5, in2);
    let t7 = circuit_sub(in0, t6);
    let t8 = circuit_mul(t3, t7);
    let t9 = circuit_sub(t8, in1);

    let modulus = get_p(curve_index);
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([modulus.limb0, modulus.limb1, modulus.limb2, modulus.limb3])
        .unwrap();

    let mut circuit_inputs = (t6, t9,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(p.x); // in0
    circuit_inputs = circuit_inputs.next_2(p.y); // in1
    circuit_inputs = circuit_inputs.next_2(q.x); // in2
    circuit_inputs = circuit_inputs.next_2(q.y); // in3

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let r: G1Point = G1Point { x: outputs.get_output(t6), y: outputs.get_output(t9) };
    return (r,);
}
fn run_DOUBLE_EC_POINT_circuit(p: G1Point, A_weirstrass: u384, curve_index: usize) -> (G1Point,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x3

    // INPUT stack
    let (in1, in2, in3) = (CE::<CI<1>> {}, CE::<CI<2>> {}, CE::<CI<3>> {});
    let t0 = circuit_mul(in1, in1);
    let t1 = circuit_mul(in0, t0);
    let t2 = circuit_add(t1, in3);
    let t3 = circuit_add(in2, in2);
    let t4 = circuit_inverse(t3);
    let t5 = circuit_mul(t2, t4);
    let t6 = circuit_mul(t5, t5);
    let t7 = circuit_sub(t6, in1);
    let t8 = circuit_sub(t7, in1);
    let t9 = circuit_sub(in1, t8);
    let t10 = circuit_mul(t5, t9);
    let t11 = circuit_sub(in2, t10);

    let modulus = get_p(curve_index);
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([modulus.limb0, modulus.limb1, modulus.limb2, modulus.limb3])
        .unwrap();

    let mut circuit_inputs = (t8, t11,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x3, 0x0, 0x0, 0x0]); // in0
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(p.x); // in1
    circuit_inputs = circuit_inputs.next_2(p.y); // in2
    circuit_inputs = circuit_inputs.next_2(A_weirstrass); // in3

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let r: G1Point = G1Point { x: outputs.get_output(t8), y: outputs.get_output(t11) };
    return (r,);
}
fn run_EVAL_FN_CHALLENGE_DUPL_10P_circuit(
    A0: G1Point,
    A2: G1Point,
    coeff0: u384,
    coeff2: u384,
    SumDlogDiv: FunctionFelt,
    curve_index: usize
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
    let (in54, in55) = (CE::<CI<54>> {}, CE::<CI<55>> {});
    let t0 = circuit_mul(in0, in0);
    let t1 = circuit_mul(in2, in2);
    let t2 = circuit_mul(t0, in0);
    let t3 = circuit_mul(t1, in2);
    let t4 = circuit_mul(t2, in0);
    let t5 = circuit_mul(t3, in2);
    let t6 = circuit_mul(t4, in0);
    let t7 = circuit_mul(t5, in2);
    let t8 = circuit_mul(t6, in0);
    let t9 = circuit_mul(t7, in2);
    let t10 = circuit_mul(t8, in0);
    let t11 = circuit_mul(t9, in2);
    let t12 = circuit_mul(t10, in0);
    let t13 = circuit_mul(t11, in2);
    let t14 = circuit_mul(t12, in0);
    let t15 = circuit_mul(t13, in2);
    let t16 = circuit_mul(t14, in0);
    let t17 = circuit_mul(t15, in2);
    let t18 = circuit_mul(t16, in0);
    let t19 = circuit_mul(t17, in2);
    let t20 = circuit_mul(t18, in0);
    let t21 = circuit_mul(t19, in2);
    let t22 = circuit_mul(t20, in0);
    let t23 = circuit_mul(t21, in2);
    let t24 = circuit_mul(t22, in0);
    let t25 = circuit_mul(t23, in2);
    let t26 = circuit_mul(in7, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t27 = circuit_add(in6, t26); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t28 = circuit_mul(in8, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t29 = circuit_add(t27, t28); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t30 = circuit_mul(in9, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t31 = circuit_add(t29, t30); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t32 = circuit_mul(in10, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t33 = circuit_add(t31, t32); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t34 = circuit_mul(in11, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t35 = circuit_add(t33, t34); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t36 = circuit_mul(in12, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t37 = circuit_add(t35, t36); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t38 = circuit_mul(in13, t10); // Eval UnnamedPoly step coeff_7 * x^7
    let t39 = circuit_add(t37, t38); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t40 = circuit_mul(in14, t12); // Eval UnnamedPoly step coeff_8 * x^8
    let t41 = circuit_add(t39, t40); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t42 = circuit_mul(in15, t14); // Eval UnnamedPoly step coeff_9 * x^9
    let t43 = circuit_add(t41, t42); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t44 = circuit_mul(in16, t16); // Eval UnnamedPoly step coeff_10 * x^10
    let t45 = circuit_add(t43, t44); // Eval UnnamedPoly step + (coeff_10 * x^10)
    let t46 = circuit_mul(in18, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t47 = circuit_add(in17, t46); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t48 = circuit_mul(in19, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t49 = circuit_add(t47, t48); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t50 = circuit_mul(in20, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t51 = circuit_add(t49, t50); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t52 = circuit_mul(in21, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t53 = circuit_add(t51, t52); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t54 = circuit_mul(in22, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t55 = circuit_add(t53, t54); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t56 = circuit_mul(in23, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t57 = circuit_add(t55, t56); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t58 = circuit_mul(in24, t10); // Eval UnnamedPoly step coeff_7 * x^7
    let t59 = circuit_add(t57, t58); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t60 = circuit_mul(in25, t12); // Eval UnnamedPoly step coeff_8 * x^8
    let t61 = circuit_add(t59, t60); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t62 = circuit_mul(in26, t14); // Eval UnnamedPoly step coeff_9 * x^9
    let t63 = circuit_add(t61, t62); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t64 = circuit_mul(in27, t16); // Eval UnnamedPoly step coeff_10 * x^10
    let t65 = circuit_add(t63, t64); // Eval UnnamedPoly step + (coeff_10 * x^10)
    let t66 = circuit_mul(in28, t18); // Eval UnnamedPoly step coeff_11 * x^11
    let t67 = circuit_add(t65, t66); // Eval UnnamedPoly step + (coeff_11 * x^11)
    let t68 = circuit_inverse(t67);
    let t69 = circuit_mul(t45, t68);
    let t70 = circuit_mul(in30, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t71 = circuit_add(in29, t70); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t72 = circuit_mul(in31, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t73 = circuit_add(t71, t72); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t74 = circuit_mul(in32, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t75 = circuit_add(t73, t74); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t76 = circuit_mul(in33, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t77 = circuit_add(t75, t76); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t78 = circuit_mul(in34, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t79 = circuit_add(t77, t78); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t80 = circuit_mul(in35, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t81 = circuit_add(t79, t80); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t82 = circuit_mul(in36, t10); // Eval UnnamedPoly step coeff_7 * x^7
    let t83 = circuit_add(t81, t82); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t84 = circuit_mul(in37, t12); // Eval UnnamedPoly step coeff_8 * x^8
    let t85 = circuit_add(t83, t84); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t86 = circuit_mul(in38, t14); // Eval UnnamedPoly step coeff_9 * x^9
    let t87 = circuit_add(t85, t86); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t88 = circuit_mul(in39, t16); // Eval UnnamedPoly step coeff_10 * x^10
    let t89 = circuit_add(t87, t88); // Eval UnnamedPoly step + (coeff_10 * x^10)
    let t90 = circuit_mul(in40, t18); // Eval UnnamedPoly step coeff_11 * x^11
    let t91 = circuit_add(t89, t90); // Eval UnnamedPoly step + (coeff_11 * x^11)
    let t92 = circuit_mul(in42, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t93 = circuit_add(in41, t92); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t94 = circuit_mul(in43, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t95 = circuit_add(t93, t94); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t96 = circuit_mul(in44, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t97 = circuit_add(t95, t96); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t98 = circuit_mul(in45, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t99 = circuit_add(t97, t98); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t100 = circuit_mul(in46, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t101 = circuit_add(t99, t100); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t102 = circuit_mul(in47, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t103 = circuit_add(t101, t102); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t104 = circuit_mul(in48, t10); // Eval UnnamedPoly step coeff_7 * x^7
    let t105 = circuit_add(t103, t104); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t106 = circuit_mul(in49, t12); // Eval UnnamedPoly step coeff_8 * x^8
    let t107 = circuit_add(t105, t106); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t108 = circuit_mul(in50, t14); // Eval UnnamedPoly step coeff_9 * x^9
    let t109 = circuit_add(t107, t108); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t110 = circuit_mul(in51, t16); // Eval UnnamedPoly step coeff_10 * x^10
    let t111 = circuit_add(t109, t110); // Eval UnnamedPoly step + (coeff_10 * x^10)
    let t112 = circuit_mul(in52, t18); // Eval UnnamedPoly step coeff_11 * x^11
    let t113 = circuit_add(t111, t112); // Eval UnnamedPoly step + (coeff_11 * x^11)
    let t114 = circuit_mul(in53, t20); // Eval UnnamedPoly step coeff_12 * x^12
    let t115 = circuit_add(t113, t114); // Eval UnnamedPoly step + (coeff_12 * x^12)
    let t116 = circuit_mul(in54, t22); // Eval UnnamedPoly step coeff_13 * x^13
    let t117 = circuit_add(t115, t116); // Eval UnnamedPoly step + (coeff_13 * x^13)
    let t118 = circuit_mul(in55, t24); // Eval UnnamedPoly step coeff_14 * x^14
    let t119 = circuit_add(t117, t118); // Eval UnnamedPoly step + (coeff_14 * x^14)
    let t120 = circuit_inverse(t119);
    let t121 = circuit_mul(t91, t120);
    let t122 = circuit_mul(in1, t121);
    let t123 = circuit_add(t69, t122);
    let t124 = circuit_mul(in7, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t125 = circuit_add(in6, t124); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t126 = circuit_mul(in8, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t127 = circuit_add(t125, t126); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t128 = circuit_mul(in9, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t129 = circuit_add(t127, t128); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t130 = circuit_mul(in10, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t131 = circuit_add(t129, t130); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t132 = circuit_mul(in11, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t133 = circuit_add(t131, t132); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t134 = circuit_mul(in12, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t135 = circuit_add(t133, t134); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t136 = circuit_mul(in13, t11); // Eval UnnamedPoly step coeff_7 * x^7
    let t137 = circuit_add(t135, t136); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t138 = circuit_mul(in14, t13); // Eval UnnamedPoly step coeff_8 * x^8
    let t139 = circuit_add(t137, t138); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t140 = circuit_mul(in15, t15); // Eval UnnamedPoly step coeff_9 * x^9
    let t141 = circuit_add(t139, t140); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t142 = circuit_mul(in16, t17); // Eval UnnamedPoly step coeff_10 * x^10
    let t143 = circuit_add(t141, t142); // Eval UnnamedPoly step + (coeff_10 * x^10)
    let t144 = circuit_mul(in18, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t145 = circuit_add(in17, t144); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t146 = circuit_mul(in19, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t147 = circuit_add(t145, t146); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t148 = circuit_mul(in20, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t149 = circuit_add(t147, t148); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t150 = circuit_mul(in21, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t151 = circuit_add(t149, t150); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t152 = circuit_mul(in22, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t153 = circuit_add(t151, t152); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t154 = circuit_mul(in23, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t155 = circuit_add(t153, t154); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t156 = circuit_mul(in24, t11); // Eval UnnamedPoly step coeff_7 * x^7
    let t157 = circuit_add(t155, t156); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t158 = circuit_mul(in25, t13); // Eval UnnamedPoly step coeff_8 * x^8
    let t159 = circuit_add(t157, t158); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t160 = circuit_mul(in26, t15); // Eval UnnamedPoly step coeff_9 * x^9
    let t161 = circuit_add(t159, t160); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t162 = circuit_mul(in27, t17); // Eval UnnamedPoly step coeff_10 * x^10
    let t163 = circuit_add(t161, t162); // Eval UnnamedPoly step + (coeff_10 * x^10)
    let t164 = circuit_mul(in28, t19); // Eval UnnamedPoly step coeff_11 * x^11
    let t165 = circuit_add(t163, t164); // Eval UnnamedPoly step + (coeff_11 * x^11)
    let t166 = circuit_inverse(t165);
    let t167 = circuit_mul(t143, t166);
    let t168 = circuit_mul(in30, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t169 = circuit_add(in29, t168); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t170 = circuit_mul(in31, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t171 = circuit_add(t169, t170); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t172 = circuit_mul(in32, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t173 = circuit_add(t171, t172); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t174 = circuit_mul(in33, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t175 = circuit_add(t173, t174); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t176 = circuit_mul(in34, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t177 = circuit_add(t175, t176); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t178 = circuit_mul(in35, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t179 = circuit_add(t177, t178); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t180 = circuit_mul(in36, t11); // Eval UnnamedPoly step coeff_7 * x^7
    let t181 = circuit_add(t179, t180); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t182 = circuit_mul(in37, t13); // Eval UnnamedPoly step coeff_8 * x^8
    let t183 = circuit_add(t181, t182); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t184 = circuit_mul(in38, t15); // Eval UnnamedPoly step coeff_9 * x^9
    let t185 = circuit_add(t183, t184); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t186 = circuit_mul(in39, t17); // Eval UnnamedPoly step coeff_10 * x^10
    let t187 = circuit_add(t185, t186); // Eval UnnamedPoly step + (coeff_10 * x^10)
    let t188 = circuit_mul(in40, t19); // Eval UnnamedPoly step coeff_11 * x^11
    let t189 = circuit_add(t187, t188); // Eval UnnamedPoly step + (coeff_11 * x^11)
    let t190 = circuit_mul(in42, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t191 = circuit_add(in41, t190); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t192 = circuit_mul(in43, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t193 = circuit_add(t191, t192); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t194 = circuit_mul(in44, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t195 = circuit_add(t193, t194); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t196 = circuit_mul(in45, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t197 = circuit_add(t195, t196); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t198 = circuit_mul(in46, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t199 = circuit_add(t197, t198); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t200 = circuit_mul(in47, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t201 = circuit_add(t199, t200); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t202 = circuit_mul(in48, t11); // Eval UnnamedPoly step coeff_7 * x^7
    let t203 = circuit_add(t201, t202); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t204 = circuit_mul(in49, t13); // Eval UnnamedPoly step coeff_8 * x^8
    let t205 = circuit_add(t203, t204); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t206 = circuit_mul(in50, t15); // Eval UnnamedPoly step coeff_9 * x^9
    let t207 = circuit_add(t205, t206); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t208 = circuit_mul(in51, t17); // Eval UnnamedPoly step coeff_10 * x^10
    let t209 = circuit_add(t207, t208); // Eval UnnamedPoly step + (coeff_10 * x^10)
    let t210 = circuit_mul(in52, t19); // Eval UnnamedPoly step coeff_11 * x^11
    let t211 = circuit_add(t209, t210); // Eval UnnamedPoly step + (coeff_11 * x^11)
    let t212 = circuit_mul(in53, t21); // Eval UnnamedPoly step coeff_12 * x^12
    let t213 = circuit_add(t211, t212); // Eval UnnamedPoly step + (coeff_12 * x^12)
    let t214 = circuit_mul(in54, t23); // Eval UnnamedPoly step coeff_13 * x^13
    let t215 = circuit_add(t213, t214); // Eval UnnamedPoly step + (coeff_13 * x^13)
    let t216 = circuit_mul(in55, t25); // Eval UnnamedPoly step coeff_14 * x^14
    let t217 = circuit_add(t215, t216); // Eval UnnamedPoly step + (coeff_14 * x^14)
    let t218 = circuit_inverse(t217);
    let t219 = circuit_mul(t189, t218);
    let t220 = circuit_mul(in3, t219);
    let t221 = circuit_add(t167, t220);
    let t222 = circuit_mul(in4, t123);
    let t223 = circuit_mul(in5, t221);
    let t224 = circuit_sub(t222, t223);

    let modulus = get_p(curve_index);
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([modulus.limb0, modulus.limb1, modulus.limb2, modulus.limb3])
        .unwrap();

    let mut circuit_inputs = (t224,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(A0.x); // in0
    circuit_inputs = circuit_inputs.next_2(A0.y); // in1
    circuit_inputs = circuit_inputs.next_2(A2.x); // in2
    circuit_inputs = circuit_inputs.next_2(A2.y); // in3
    circuit_inputs = circuit_inputs.next_2(coeff0); // in4
    circuit_inputs = circuit_inputs.next_2(coeff2); // in5
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
    // in6 - in55

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: u384 = outputs.get_output(t224);
    return (res,);
}
fn run_EVAL_FN_CHALLENGE_DUPL_1P_circuit(
    A0: G1Point,
    A2: G1Point,
    coeff0: u384,
    coeff2: u384,
    SumDlogDiv: FunctionFelt,
    curve_index: usize
) -> (u384,) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13, in14) = (CE::<CI<12>> {}, CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16, in17) = (CE::<CI<15>> {}, CE::<CI<16>> {}, CE::<CI<17>> {});
    let (in18, in19) = (CE::<CI<18>> {}, CE::<CI<19>> {});
    let t0 = circuit_mul(in0, in0);
    let t1 = circuit_mul(in2, in2);
    let t2 = circuit_mul(t0, in0);
    let t3 = circuit_mul(t1, in2);
    let t4 = circuit_mul(t2, in0);
    let t5 = circuit_mul(t3, in2);
    let t6 = circuit_mul(t4, in0);
    let t7 = circuit_mul(t5, in2);
    let t8 = circuit_mul(in7, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t9 = circuit_add(in6, t8); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t10 = circuit_mul(in9, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t11 = circuit_add(in8, t10); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t12 = circuit_mul(in10, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t13 = circuit_add(t11, t12); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t14 = circuit_inverse(t13);
    let t15 = circuit_mul(t9, t14);
    let t16 = circuit_mul(in12, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t17 = circuit_add(in11, t16); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t18 = circuit_mul(in13, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t19 = circuit_add(t17, t18); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t20 = circuit_mul(in15, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t21 = circuit_add(in14, t20); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t22 = circuit_mul(in16, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t23 = circuit_add(t21, t22); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t24 = circuit_mul(in17, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t25 = circuit_add(t23, t24); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t26 = circuit_mul(in18, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t27 = circuit_add(t25, t26); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t28 = circuit_mul(in19, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t29 = circuit_add(t27, t28); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t30 = circuit_inverse(t29);
    let t31 = circuit_mul(t19, t30);
    let t32 = circuit_mul(in1, t31);
    let t33 = circuit_add(t15, t32);
    let t34 = circuit_mul(in7, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t35 = circuit_add(in6, t34); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t36 = circuit_mul(in9, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t37 = circuit_add(in8, t36); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t38 = circuit_mul(in10, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t39 = circuit_add(t37, t38); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t40 = circuit_inverse(t39);
    let t41 = circuit_mul(t35, t40);
    let t42 = circuit_mul(in12, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t43 = circuit_add(in11, t42); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t44 = circuit_mul(in13, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t45 = circuit_add(t43, t44); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t46 = circuit_mul(in15, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t47 = circuit_add(in14, t46); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t48 = circuit_mul(in16, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t49 = circuit_add(t47, t48); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t50 = circuit_mul(in17, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t51 = circuit_add(t49, t50); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t52 = circuit_mul(in18, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t53 = circuit_add(t51, t52); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t54 = circuit_mul(in19, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t55 = circuit_add(t53, t54); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t56 = circuit_inverse(t55);
    let t57 = circuit_mul(t45, t56);
    let t58 = circuit_mul(in3, t57);
    let t59 = circuit_add(t41, t58);
    let t60 = circuit_mul(in4, t33);
    let t61 = circuit_mul(in5, t59);
    let t62 = circuit_sub(t60, t61);

    let modulus = get_p(curve_index);
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([modulus.limb0, modulus.limb1, modulus.limb2, modulus.limb3])
        .unwrap();

    let mut circuit_inputs = (t62,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(A0.x); // in0
    circuit_inputs = circuit_inputs.next_2(A0.y); // in1
    circuit_inputs = circuit_inputs.next_2(A2.x); // in2
    circuit_inputs = circuit_inputs.next_2(A2.y); // in3
    circuit_inputs = circuit_inputs.next_2(coeff0); // in4
    circuit_inputs = circuit_inputs.next_2(coeff2); // in5
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
    // in6 - in19

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: u384 = outputs.get_output(t62);
    return (res,);
}
fn run_EVAL_FN_CHALLENGE_DUPL_2P_circuit(
    A0: G1Point,
    A2: G1Point,
    coeff0: u384,
    coeff2: u384,
    SumDlogDiv: FunctionFelt,
    curve_index: usize
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
    let t0 = circuit_mul(in0, in0);
    let t1 = circuit_mul(in2, in2);
    let t2 = circuit_mul(t0, in0);
    let t3 = circuit_mul(t1, in2);
    let t4 = circuit_mul(t2, in0);
    let t5 = circuit_mul(t3, in2);
    let t6 = circuit_mul(t4, in0);
    let t7 = circuit_mul(t5, in2);
    let t8 = circuit_mul(t6, in0);
    let t9 = circuit_mul(t7, in2);
    let t10 = circuit_mul(in7, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t11 = circuit_add(in6, t10); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t12 = circuit_mul(in8, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t13 = circuit_add(t11, t12); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t14 = circuit_mul(in10, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t15 = circuit_add(in9, t14); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t16 = circuit_mul(in11, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t17 = circuit_add(t15, t16); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t18 = circuit_mul(in12, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t19 = circuit_add(t17, t18); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t20 = circuit_inverse(t19);
    let t21 = circuit_mul(t13, t20);
    let t22 = circuit_mul(in14, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t23 = circuit_add(in13, t22); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t24 = circuit_mul(in15, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t25 = circuit_add(t23, t24); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t26 = circuit_mul(in16, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t27 = circuit_add(t25, t26); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t28 = circuit_mul(in18, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t29 = circuit_add(in17, t28); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t30 = circuit_mul(in19, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t31 = circuit_add(t29, t30); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t32 = circuit_mul(in20, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t33 = circuit_add(t31, t32); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t34 = circuit_mul(in21, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t35 = circuit_add(t33, t34); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t36 = circuit_mul(in22, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t37 = circuit_add(t35, t36); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t38 = circuit_mul(in23, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t39 = circuit_add(t37, t38); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t40 = circuit_inverse(t39);
    let t41 = circuit_mul(t27, t40);
    let t42 = circuit_mul(in1, t41);
    let t43 = circuit_add(t21, t42);
    let t44 = circuit_mul(in7, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t45 = circuit_add(in6, t44); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t46 = circuit_mul(in8, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t47 = circuit_add(t45, t46); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t48 = circuit_mul(in10, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t49 = circuit_add(in9, t48); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t50 = circuit_mul(in11, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t51 = circuit_add(t49, t50); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t52 = circuit_mul(in12, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t53 = circuit_add(t51, t52); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t54 = circuit_inverse(t53);
    let t55 = circuit_mul(t47, t54);
    let t56 = circuit_mul(in14, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t57 = circuit_add(in13, t56); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t58 = circuit_mul(in15, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t59 = circuit_add(t57, t58); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t60 = circuit_mul(in16, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t61 = circuit_add(t59, t60); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t62 = circuit_mul(in18, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t63 = circuit_add(in17, t62); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t64 = circuit_mul(in19, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t65 = circuit_add(t63, t64); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t66 = circuit_mul(in20, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t67 = circuit_add(t65, t66); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t68 = circuit_mul(in21, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t69 = circuit_add(t67, t68); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t70 = circuit_mul(in22, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t71 = circuit_add(t69, t70); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t72 = circuit_mul(in23, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t73 = circuit_add(t71, t72); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t74 = circuit_inverse(t73);
    let t75 = circuit_mul(t61, t74);
    let t76 = circuit_mul(in3, t75);
    let t77 = circuit_add(t55, t76);
    let t78 = circuit_mul(in4, t43);
    let t79 = circuit_mul(in5, t77);
    let t80 = circuit_sub(t78, t79);

    let modulus = get_p(curve_index);
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([modulus.limb0, modulus.limb1, modulus.limb2, modulus.limb3])
        .unwrap();

    let mut circuit_inputs = (t80,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(A0.x); // in0
    circuit_inputs = circuit_inputs.next_2(A0.y); // in1
    circuit_inputs = circuit_inputs.next_2(A2.x); // in2
    circuit_inputs = circuit_inputs.next_2(A2.y); // in3
    circuit_inputs = circuit_inputs.next_2(coeff0); // in4
    circuit_inputs = circuit_inputs.next_2(coeff2); // in5
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
    // in6 - in23

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: u384 = outputs.get_output(t80);
    return (res,);
}
fn run_EVAL_FN_CHALLENGE_DUPL_3P_circuit(
    A0: G1Point,
    A2: G1Point,
    coeff0: u384,
    coeff2: u384,
    SumDlogDiv: FunctionFelt,
    curve_index: usize
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
    let in27 = CE::<CI<27>> {};
    let t0 = circuit_mul(in0, in0);
    let t1 = circuit_mul(in2, in2);
    let t2 = circuit_mul(t0, in0);
    let t3 = circuit_mul(t1, in2);
    let t4 = circuit_mul(t2, in0);
    let t5 = circuit_mul(t3, in2);
    let t6 = circuit_mul(t4, in0);
    let t7 = circuit_mul(t5, in2);
    let t8 = circuit_mul(t6, in0);
    let t9 = circuit_mul(t7, in2);
    let t10 = circuit_mul(t8, in0);
    let t11 = circuit_mul(t9, in2);
    let t12 = circuit_mul(in7, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t13 = circuit_add(in6, t12); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t14 = circuit_mul(in8, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t15 = circuit_add(t13, t14); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t16 = circuit_mul(in9, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t17 = circuit_add(t15, t16); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t18 = circuit_mul(in11, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t19 = circuit_add(in10, t18); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t20 = circuit_mul(in12, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t21 = circuit_add(t19, t20); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t22 = circuit_mul(in13, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t23 = circuit_add(t21, t22); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t24 = circuit_mul(in14, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t25 = circuit_add(t23, t24); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t26 = circuit_inverse(t25);
    let t27 = circuit_mul(t17, t26);
    let t28 = circuit_mul(in16, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t29 = circuit_add(in15, t28); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t30 = circuit_mul(in17, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t31 = circuit_add(t29, t30); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t32 = circuit_mul(in18, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t33 = circuit_add(t31, t32); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t34 = circuit_mul(in19, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t35 = circuit_add(t33, t34); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t36 = circuit_mul(in21, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t37 = circuit_add(in20, t36); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t38 = circuit_mul(in22, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t39 = circuit_add(t37, t38); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t40 = circuit_mul(in23, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t41 = circuit_add(t39, t40); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t42 = circuit_mul(in24, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t43 = circuit_add(t41, t42); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t44 = circuit_mul(in25, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t45 = circuit_add(t43, t44); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t46 = circuit_mul(in26, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t47 = circuit_add(t45, t46); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t48 = circuit_mul(in27, t10); // Eval UnnamedPoly step coeff_7 * x^7
    let t49 = circuit_add(t47, t48); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t50 = circuit_inverse(t49);
    let t51 = circuit_mul(t35, t50);
    let t52 = circuit_mul(in1, t51);
    let t53 = circuit_add(t27, t52);
    let t54 = circuit_mul(in7, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t55 = circuit_add(in6, t54); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t56 = circuit_mul(in8, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t57 = circuit_add(t55, t56); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t58 = circuit_mul(in9, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t59 = circuit_add(t57, t58); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t60 = circuit_mul(in11, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t61 = circuit_add(in10, t60); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t62 = circuit_mul(in12, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t63 = circuit_add(t61, t62); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t64 = circuit_mul(in13, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t65 = circuit_add(t63, t64); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t66 = circuit_mul(in14, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t67 = circuit_add(t65, t66); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t68 = circuit_inverse(t67);
    let t69 = circuit_mul(t59, t68);
    let t70 = circuit_mul(in16, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t71 = circuit_add(in15, t70); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t72 = circuit_mul(in17, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t73 = circuit_add(t71, t72); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t74 = circuit_mul(in18, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t75 = circuit_add(t73, t74); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t76 = circuit_mul(in19, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t77 = circuit_add(t75, t76); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t78 = circuit_mul(in21, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t79 = circuit_add(in20, t78); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t80 = circuit_mul(in22, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t81 = circuit_add(t79, t80); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t82 = circuit_mul(in23, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t83 = circuit_add(t81, t82); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t84 = circuit_mul(in24, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t85 = circuit_add(t83, t84); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t86 = circuit_mul(in25, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t87 = circuit_add(t85, t86); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t88 = circuit_mul(in26, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t89 = circuit_add(t87, t88); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t90 = circuit_mul(in27, t11); // Eval UnnamedPoly step coeff_7 * x^7
    let t91 = circuit_add(t89, t90); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t92 = circuit_inverse(t91);
    let t93 = circuit_mul(t77, t92);
    let t94 = circuit_mul(in3, t93);
    let t95 = circuit_add(t69, t94);
    let t96 = circuit_mul(in4, t53);
    let t97 = circuit_mul(in5, t95);
    let t98 = circuit_sub(t96, t97);

    let modulus = get_p(curve_index);
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([modulus.limb0, modulus.limb1, modulus.limb2, modulus.limb3])
        .unwrap();

    let mut circuit_inputs = (t98,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(A0.x); // in0
    circuit_inputs = circuit_inputs.next_2(A0.y); // in1
    circuit_inputs = circuit_inputs.next_2(A2.x); // in2
    circuit_inputs = circuit_inputs.next_2(A2.y); // in3
    circuit_inputs = circuit_inputs.next_2(coeff0); // in4
    circuit_inputs = circuit_inputs.next_2(coeff2); // in5
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
    // in6 - in27

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: u384 = outputs.get_output(t98);
    return (res,);
}
fn run_EVAL_FN_CHALLENGE_DUPL_4P_circuit(
    A0: G1Point,
    A2: G1Point,
    coeff0: u384,
    coeff2: u384,
    SumDlogDiv: FunctionFelt,
    curve_index: usize
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
    let (in30, in31) = (CE::<CI<30>> {}, CE::<CI<31>> {});
    let t0 = circuit_mul(in0, in0);
    let t1 = circuit_mul(in2, in2);
    let t2 = circuit_mul(t0, in0);
    let t3 = circuit_mul(t1, in2);
    let t4 = circuit_mul(t2, in0);
    let t5 = circuit_mul(t3, in2);
    let t6 = circuit_mul(t4, in0);
    let t7 = circuit_mul(t5, in2);
    let t8 = circuit_mul(t6, in0);
    let t9 = circuit_mul(t7, in2);
    let t10 = circuit_mul(t8, in0);
    let t11 = circuit_mul(t9, in2);
    let t12 = circuit_mul(t10, in0);
    let t13 = circuit_mul(t11, in2);
    let t14 = circuit_mul(in7, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t15 = circuit_add(in6, t14); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t16 = circuit_mul(in8, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t17 = circuit_add(t15, t16); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t18 = circuit_mul(in9, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t19 = circuit_add(t17, t18); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t20 = circuit_mul(in10, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t21 = circuit_add(t19, t20); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t22 = circuit_mul(in12, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t23 = circuit_add(in11, t22); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t24 = circuit_mul(in13, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t25 = circuit_add(t23, t24); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t26 = circuit_mul(in14, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t27 = circuit_add(t25, t26); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t28 = circuit_mul(in15, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t29 = circuit_add(t27, t28); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t30 = circuit_mul(in16, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t31 = circuit_add(t29, t30); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t32 = circuit_inverse(t31);
    let t33 = circuit_mul(t21, t32);
    let t34 = circuit_mul(in18, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t35 = circuit_add(in17, t34); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t36 = circuit_mul(in19, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t37 = circuit_add(t35, t36); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t38 = circuit_mul(in20, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t39 = circuit_add(t37, t38); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t40 = circuit_mul(in21, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t41 = circuit_add(t39, t40); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t42 = circuit_mul(in22, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t43 = circuit_add(t41, t42); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t44 = circuit_mul(in24, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t45 = circuit_add(in23, t44); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t46 = circuit_mul(in25, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t47 = circuit_add(t45, t46); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t48 = circuit_mul(in26, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t49 = circuit_add(t47, t48); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t50 = circuit_mul(in27, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t51 = circuit_add(t49, t50); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t52 = circuit_mul(in28, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t53 = circuit_add(t51, t52); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t54 = circuit_mul(in29, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t55 = circuit_add(t53, t54); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t56 = circuit_mul(in30, t10); // Eval UnnamedPoly step coeff_7 * x^7
    let t57 = circuit_add(t55, t56); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t58 = circuit_mul(in31, t12); // Eval UnnamedPoly step coeff_8 * x^8
    let t59 = circuit_add(t57, t58); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t60 = circuit_inverse(t59);
    let t61 = circuit_mul(t43, t60);
    let t62 = circuit_mul(in1, t61);
    let t63 = circuit_add(t33, t62);
    let t64 = circuit_mul(in7, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t65 = circuit_add(in6, t64); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t66 = circuit_mul(in8, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t67 = circuit_add(t65, t66); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t68 = circuit_mul(in9, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t69 = circuit_add(t67, t68); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t70 = circuit_mul(in10, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t71 = circuit_add(t69, t70); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t72 = circuit_mul(in12, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t73 = circuit_add(in11, t72); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t74 = circuit_mul(in13, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t75 = circuit_add(t73, t74); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t76 = circuit_mul(in14, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t77 = circuit_add(t75, t76); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t78 = circuit_mul(in15, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t79 = circuit_add(t77, t78); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t80 = circuit_mul(in16, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t81 = circuit_add(t79, t80); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t82 = circuit_inverse(t81);
    let t83 = circuit_mul(t71, t82);
    let t84 = circuit_mul(in18, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t85 = circuit_add(in17, t84); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t86 = circuit_mul(in19, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t87 = circuit_add(t85, t86); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t88 = circuit_mul(in20, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t89 = circuit_add(t87, t88); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t90 = circuit_mul(in21, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t91 = circuit_add(t89, t90); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t92 = circuit_mul(in22, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t93 = circuit_add(t91, t92); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t94 = circuit_mul(in24, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t95 = circuit_add(in23, t94); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t96 = circuit_mul(in25, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t97 = circuit_add(t95, t96); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t98 = circuit_mul(in26, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t99 = circuit_add(t97, t98); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t100 = circuit_mul(in27, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t101 = circuit_add(t99, t100); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t102 = circuit_mul(in28, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t103 = circuit_add(t101, t102); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t104 = circuit_mul(in29, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t105 = circuit_add(t103, t104); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t106 = circuit_mul(in30, t11); // Eval UnnamedPoly step coeff_7 * x^7
    let t107 = circuit_add(t105, t106); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t108 = circuit_mul(in31, t13); // Eval UnnamedPoly step coeff_8 * x^8
    let t109 = circuit_add(t107, t108); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t110 = circuit_inverse(t109);
    let t111 = circuit_mul(t93, t110);
    let t112 = circuit_mul(in3, t111);
    let t113 = circuit_add(t83, t112);
    let t114 = circuit_mul(in4, t63);
    let t115 = circuit_mul(in5, t113);
    let t116 = circuit_sub(t114, t115);

    let modulus = get_p(curve_index);
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([modulus.limb0, modulus.limb1, modulus.limb2, modulus.limb3])
        .unwrap();

    let mut circuit_inputs = (t116,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(A0.x); // in0
    circuit_inputs = circuit_inputs.next_2(A0.y); // in1
    circuit_inputs = circuit_inputs.next_2(A2.x); // in2
    circuit_inputs = circuit_inputs.next_2(A2.y); // in3
    circuit_inputs = circuit_inputs.next_2(coeff0); // in4
    circuit_inputs = circuit_inputs.next_2(coeff2); // in5
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
    // in6 - in31

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: u384 = outputs.get_output(t116);
    return (res,);
}
fn run_EVAL_FN_CHALLENGE_DUPL_5P_circuit(
    A0: G1Point,
    A2: G1Point,
    coeff0: u384,
    coeff2: u384,
    SumDlogDiv: FunctionFelt,
    curve_index: usize
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
    let t0 = circuit_mul(in0, in0);
    let t1 = circuit_mul(in2, in2);
    let t2 = circuit_mul(t0, in0);
    let t3 = circuit_mul(t1, in2);
    let t4 = circuit_mul(t2, in0);
    let t5 = circuit_mul(t3, in2);
    let t6 = circuit_mul(t4, in0);
    let t7 = circuit_mul(t5, in2);
    let t8 = circuit_mul(t6, in0);
    let t9 = circuit_mul(t7, in2);
    let t10 = circuit_mul(t8, in0);
    let t11 = circuit_mul(t9, in2);
    let t12 = circuit_mul(t10, in0);
    let t13 = circuit_mul(t11, in2);
    let t14 = circuit_mul(t12, in0);
    let t15 = circuit_mul(t13, in2);
    let t16 = circuit_mul(in7, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t17 = circuit_add(in6, t16); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t18 = circuit_mul(in8, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t19 = circuit_add(t17, t18); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t20 = circuit_mul(in9, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t21 = circuit_add(t19, t20); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t22 = circuit_mul(in10, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t23 = circuit_add(t21, t22); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t24 = circuit_mul(in11, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t25 = circuit_add(t23, t24); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t26 = circuit_mul(in13, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t27 = circuit_add(in12, t26); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t28 = circuit_mul(in14, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t29 = circuit_add(t27, t28); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t30 = circuit_mul(in15, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t31 = circuit_add(t29, t30); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t32 = circuit_mul(in16, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t33 = circuit_add(t31, t32); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t34 = circuit_mul(in17, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t35 = circuit_add(t33, t34); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t36 = circuit_mul(in18, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t37 = circuit_add(t35, t36); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t38 = circuit_inverse(t37);
    let t39 = circuit_mul(t25, t38);
    let t40 = circuit_mul(in20, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t41 = circuit_add(in19, t40); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t42 = circuit_mul(in21, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t43 = circuit_add(t41, t42); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t44 = circuit_mul(in22, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t45 = circuit_add(t43, t44); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t46 = circuit_mul(in23, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t47 = circuit_add(t45, t46); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t48 = circuit_mul(in24, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t49 = circuit_add(t47, t48); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t50 = circuit_mul(in25, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t51 = circuit_add(t49, t50); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t52 = circuit_mul(in27, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t53 = circuit_add(in26, t52); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t54 = circuit_mul(in28, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t55 = circuit_add(t53, t54); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t56 = circuit_mul(in29, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t57 = circuit_add(t55, t56); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t58 = circuit_mul(in30, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t59 = circuit_add(t57, t58); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t60 = circuit_mul(in31, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t61 = circuit_add(t59, t60); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t62 = circuit_mul(in32, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t63 = circuit_add(t61, t62); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t64 = circuit_mul(in33, t10); // Eval UnnamedPoly step coeff_7 * x^7
    let t65 = circuit_add(t63, t64); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t66 = circuit_mul(in34, t12); // Eval UnnamedPoly step coeff_8 * x^8
    let t67 = circuit_add(t65, t66); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t68 = circuit_mul(in35, t14); // Eval UnnamedPoly step coeff_9 * x^9
    let t69 = circuit_add(t67, t68); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t70 = circuit_inverse(t69);
    let t71 = circuit_mul(t51, t70);
    let t72 = circuit_mul(in1, t71);
    let t73 = circuit_add(t39, t72);
    let t74 = circuit_mul(in7, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t75 = circuit_add(in6, t74); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t76 = circuit_mul(in8, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t77 = circuit_add(t75, t76); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t78 = circuit_mul(in9, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t79 = circuit_add(t77, t78); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t80 = circuit_mul(in10, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t81 = circuit_add(t79, t80); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t82 = circuit_mul(in11, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t83 = circuit_add(t81, t82); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t84 = circuit_mul(in13, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t85 = circuit_add(in12, t84); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t86 = circuit_mul(in14, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t87 = circuit_add(t85, t86); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t88 = circuit_mul(in15, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t89 = circuit_add(t87, t88); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t90 = circuit_mul(in16, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t91 = circuit_add(t89, t90); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t92 = circuit_mul(in17, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t93 = circuit_add(t91, t92); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t94 = circuit_mul(in18, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t95 = circuit_add(t93, t94); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t96 = circuit_inverse(t95);
    let t97 = circuit_mul(t83, t96);
    let t98 = circuit_mul(in20, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t99 = circuit_add(in19, t98); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t100 = circuit_mul(in21, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t101 = circuit_add(t99, t100); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t102 = circuit_mul(in22, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t103 = circuit_add(t101, t102); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t104 = circuit_mul(in23, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t105 = circuit_add(t103, t104); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t106 = circuit_mul(in24, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t107 = circuit_add(t105, t106); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t108 = circuit_mul(in25, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t109 = circuit_add(t107, t108); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t110 = circuit_mul(in27, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t111 = circuit_add(in26, t110); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t112 = circuit_mul(in28, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t113 = circuit_add(t111, t112); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t114 = circuit_mul(in29, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t115 = circuit_add(t113, t114); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t116 = circuit_mul(in30, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t117 = circuit_add(t115, t116); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t118 = circuit_mul(in31, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t119 = circuit_add(t117, t118); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t120 = circuit_mul(in32, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t121 = circuit_add(t119, t120); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t122 = circuit_mul(in33, t11); // Eval UnnamedPoly step coeff_7 * x^7
    let t123 = circuit_add(t121, t122); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t124 = circuit_mul(in34, t13); // Eval UnnamedPoly step coeff_8 * x^8
    let t125 = circuit_add(t123, t124); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t126 = circuit_mul(in35, t15); // Eval UnnamedPoly step coeff_9 * x^9
    let t127 = circuit_add(t125, t126); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t128 = circuit_inverse(t127);
    let t129 = circuit_mul(t109, t128);
    let t130 = circuit_mul(in3, t129);
    let t131 = circuit_add(t97, t130);
    let t132 = circuit_mul(in4, t73);
    let t133 = circuit_mul(in5, t131);
    let t134 = circuit_sub(t132, t133);

    let modulus = get_p(curve_index);
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([modulus.limb0, modulus.limb1, modulus.limb2, modulus.limb3])
        .unwrap();

    let mut circuit_inputs = (t134,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(A0.x); // in0
    circuit_inputs = circuit_inputs.next_2(A0.y); // in1
    circuit_inputs = circuit_inputs.next_2(A2.x); // in2
    circuit_inputs = circuit_inputs.next_2(A2.y); // in3
    circuit_inputs = circuit_inputs.next_2(coeff0); // in4
    circuit_inputs = circuit_inputs.next_2(coeff2); // in5
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
    // in6 - in35

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: u384 = outputs.get_output(t134);
    return (res,);
}
fn run_EVAL_FN_CHALLENGE_DUPL_6P_circuit(
    A0: G1Point,
    A2: G1Point,
    coeff0: u384,
    coeff2: u384,
    SumDlogDiv: FunctionFelt,
    curve_index: usize
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
    let in39 = CE::<CI<39>> {};
    let t0 = circuit_mul(in0, in0);
    let t1 = circuit_mul(in2, in2);
    let t2 = circuit_mul(t0, in0);
    let t3 = circuit_mul(t1, in2);
    let t4 = circuit_mul(t2, in0);
    let t5 = circuit_mul(t3, in2);
    let t6 = circuit_mul(t4, in0);
    let t7 = circuit_mul(t5, in2);
    let t8 = circuit_mul(t6, in0);
    let t9 = circuit_mul(t7, in2);
    let t10 = circuit_mul(t8, in0);
    let t11 = circuit_mul(t9, in2);
    let t12 = circuit_mul(t10, in0);
    let t13 = circuit_mul(t11, in2);
    let t14 = circuit_mul(t12, in0);
    let t15 = circuit_mul(t13, in2);
    let t16 = circuit_mul(t14, in0);
    let t17 = circuit_mul(t15, in2);
    let t18 = circuit_mul(in7, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t19 = circuit_add(in6, t18); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t20 = circuit_mul(in8, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t21 = circuit_add(t19, t20); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t22 = circuit_mul(in9, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t23 = circuit_add(t21, t22); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t24 = circuit_mul(in10, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t25 = circuit_add(t23, t24); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t26 = circuit_mul(in11, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t27 = circuit_add(t25, t26); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t28 = circuit_mul(in12, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t29 = circuit_add(t27, t28); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t30 = circuit_mul(in14, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t31 = circuit_add(in13, t30); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t32 = circuit_mul(in15, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t33 = circuit_add(t31, t32); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t34 = circuit_mul(in16, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t35 = circuit_add(t33, t34); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t36 = circuit_mul(in17, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t37 = circuit_add(t35, t36); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t38 = circuit_mul(in18, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t39 = circuit_add(t37, t38); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t40 = circuit_mul(in19, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t41 = circuit_add(t39, t40); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t42 = circuit_mul(in20, t10); // Eval UnnamedPoly step coeff_7 * x^7
    let t43 = circuit_add(t41, t42); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t44 = circuit_inverse(t43);
    let t45 = circuit_mul(t29, t44);
    let t46 = circuit_mul(in22, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t47 = circuit_add(in21, t46); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t48 = circuit_mul(in23, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t49 = circuit_add(t47, t48); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t50 = circuit_mul(in24, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t51 = circuit_add(t49, t50); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t52 = circuit_mul(in25, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t53 = circuit_add(t51, t52); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t54 = circuit_mul(in26, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t55 = circuit_add(t53, t54); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t56 = circuit_mul(in27, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t57 = circuit_add(t55, t56); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t58 = circuit_mul(in28, t10); // Eval UnnamedPoly step coeff_7 * x^7
    let t59 = circuit_add(t57, t58); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t60 = circuit_mul(in30, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t61 = circuit_add(in29, t60); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t62 = circuit_mul(in31, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t63 = circuit_add(t61, t62); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t64 = circuit_mul(in32, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t65 = circuit_add(t63, t64); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t66 = circuit_mul(in33, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t67 = circuit_add(t65, t66); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t68 = circuit_mul(in34, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t69 = circuit_add(t67, t68); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t70 = circuit_mul(in35, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t71 = circuit_add(t69, t70); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t72 = circuit_mul(in36, t10); // Eval UnnamedPoly step coeff_7 * x^7
    let t73 = circuit_add(t71, t72); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t74 = circuit_mul(in37, t12); // Eval UnnamedPoly step coeff_8 * x^8
    let t75 = circuit_add(t73, t74); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t76 = circuit_mul(in38, t14); // Eval UnnamedPoly step coeff_9 * x^9
    let t77 = circuit_add(t75, t76); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t78 = circuit_mul(in39, t16); // Eval UnnamedPoly step coeff_10 * x^10
    let t79 = circuit_add(t77, t78); // Eval UnnamedPoly step + (coeff_10 * x^10)
    let t80 = circuit_inverse(t79);
    let t81 = circuit_mul(t59, t80);
    let t82 = circuit_mul(in1, t81);
    let t83 = circuit_add(t45, t82);
    let t84 = circuit_mul(in7, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t85 = circuit_add(in6, t84); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t86 = circuit_mul(in8, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t87 = circuit_add(t85, t86); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t88 = circuit_mul(in9, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t89 = circuit_add(t87, t88); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t90 = circuit_mul(in10, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t91 = circuit_add(t89, t90); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t92 = circuit_mul(in11, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t93 = circuit_add(t91, t92); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t94 = circuit_mul(in12, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t95 = circuit_add(t93, t94); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t96 = circuit_mul(in14, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t97 = circuit_add(in13, t96); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t98 = circuit_mul(in15, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t99 = circuit_add(t97, t98); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t100 = circuit_mul(in16, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t101 = circuit_add(t99, t100); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t102 = circuit_mul(in17, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t103 = circuit_add(t101, t102); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t104 = circuit_mul(in18, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t105 = circuit_add(t103, t104); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t106 = circuit_mul(in19, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t107 = circuit_add(t105, t106); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t108 = circuit_mul(in20, t11); // Eval UnnamedPoly step coeff_7 * x^7
    let t109 = circuit_add(t107, t108); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t110 = circuit_inverse(t109);
    let t111 = circuit_mul(t95, t110);
    let t112 = circuit_mul(in22, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t113 = circuit_add(in21, t112); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t114 = circuit_mul(in23, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t115 = circuit_add(t113, t114); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t116 = circuit_mul(in24, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t117 = circuit_add(t115, t116); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t118 = circuit_mul(in25, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t119 = circuit_add(t117, t118); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t120 = circuit_mul(in26, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t121 = circuit_add(t119, t120); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t122 = circuit_mul(in27, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t123 = circuit_add(t121, t122); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t124 = circuit_mul(in28, t11); // Eval UnnamedPoly step coeff_7 * x^7
    let t125 = circuit_add(t123, t124); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t126 = circuit_mul(in30, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t127 = circuit_add(in29, t126); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t128 = circuit_mul(in31, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t129 = circuit_add(t127, t128); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t130 = circuit_mul(in32, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t131 = circuit_add(t129, t130); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t132 = circuit_mul(in33, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t133 = circuit_add(t131, t132); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t134 = circuit_mul(in34, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t135 = circuit_add(t133, t134); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t136 = circuit_mul(in35, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t137 = circuit_add(t135, t136); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t138 = circuit_mul(in36, t11); // Eval UnnamedPoly step coeff_7 * x^7
    let t139 = circuit_add(t137, t138); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t140 = circuit_mul(in37, t13); // Eval UnnamedPoly step coeff_8 * x^8
    let t141 = circuit_add(t139, t140); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t142 = circuit_mul(in38, t15); // Eval UnnamedPoly step coeff_9 * x^9
    let t143 = circuit_add(t141, t142); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t144 = circuit_mul(in39, t17); // Eval UnnamedPoly step coeff_10 * x^10
    let t145 = circuit_add(t143, t144); // Eval UnnamedPoly step + (coeff_10 * x^10)
    let t146 = circuit_inverse(t145);
    let t147 = circuit_mul(t125, t146);
    let t148 = circuit_mul(in3, t147);
    let t149 = circuit_add(t111, t148);
    let t150 = circuit_mul(in4, t83);
    let t151 = circuit_mul(in5, t149);
    let t152 = circuit_sub(t150, t151);

    let modulus = get_p(curve_index);
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([modulus.limb0, modulus.limb1, modulus.limb2, modulus.limb3])
        .unwrap();

    let mut circuit_inputs = (t152,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(A0.x); // in0
    circuit_inputs = circuit_inputs.next_2(A0.y); // in1
    circuit_inputs = circuit_inputs.next_2(A2.x); // in2
    circuit_inputs = circuit_inputs.next_2(A2.y); // in3
    circuit_inputs = circuit_inputs.next_2(coeff0); // in4
    circuit_inputs = circuit_inputs.next_2(coeff2); // in5
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
    // in6 - in39

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: u384 = outputs.get_output(t152);
    return (res,);
}
fn run_EVAL_FN_CHALLENGE_DUPL_7P_circuit(
    A0: G1Point,
    A2: G1Point,
    coeff0: u384,
    coeff2: u384,
    SumDlogDiv: FunctionFelt,
    curve_index: usize
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
    let (in42, in43) = (CE::<CI<42>> {}, CE::<CI<43>> {});
    let t0 = circuit_mul(in0, in0);
    let t1 = circuit_mul(in2, in2);
    let t2 = circuit_mul(t0, in0);
    let t3 = circuit_mul(t1, in2);
    let t4 = circuit_mul(t2, in0);
    let t5 = circuit_mul(t3, in2);
    let t6 = circuit_mul(t4, in0);
    let t7 = circuit_mul(t5, in2);
    let t8 = circuit_mul(t6, in0);
    let t9 = circuit_mul(t7, in2);
    let t10 = circuit_mul(t8, in0);
    let t11 = circuit_mul(t9, in2);
    let t12 = circuit_mul(t10, in0);
    let t13 = circuit_mul(t11, in2);
    let t14 = circuit_mul(t12, in0);
    let t15 = circuit_mul(t13, in2);
    let t16 = circuit_mul(t14, in0);
    let t17 = circuit_mul(t15, in2);
    let t18 = circuit_mul(t16, in0);
    let t19 = circuit_mul(t17, in2);
    let t20 = circuit_mul(in7, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t21 = circuit_add(in6, t20); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t22 = circuit_mul(in8, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t23 = circuit_add(t21, t22); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t24 = circuit_mul(in9, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t25 = circuit_add(t23, t24); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t26 = circuit_mul(in10, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t27 = circuit_add(t25, t26); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t28 = circuit_mul(in11, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t29 = circuit_add(t27, t28); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t30 = circuit_mul(in12, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t31 = circuit_add(t29, t30); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t32 = circuit_mul(in13, t10); // Eval UnnamedPoly step coeff_7 * x^7
    let t33 = circuit_add(t31, t32); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t34 = circuit_mul(in15, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t35 = circuit_add(in14, t34); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t36 = circuit_mul(in16, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t37 = circuit_add(t35, t36); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t38 = circuit_mul(in17, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t39 = circuit_add(t37, t38); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t40 = circuit_mul(in18, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t41 = circuit_add(t39, t40); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t42 = circuit_mul(in19, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t43 = circuit_add(t41, t42); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t44 = circuit_mul(in20, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t45 = circuit_add(t43, t44); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t46 = circuit_mul(in21, t10); // Eval UnnamedPoly step coeff_7 * x^7
    let t47 = circuit_add(t45, t46); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t48 = circuit_mul(in22, t12); // Eval UnnamedPoly step coeff_8 * x^8
    let t49 = circuit_add(t47, t48); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t50 = circuit_inverse(t49);
    let t51 = circuit_mul(t33, t50);
    let t52 = circuit_mul(in24, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t53 = circuit_add(in23, t52); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t54 = circuit_mul(in25, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t55 = circuit_add(t53, t54); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t56 = circuit_mul(in26, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t57 = circuit_add(t55, t56); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t58 = circuit_mul(in27, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t59 = circuit_add(t57, t58); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t60 = circuit_mul(in28, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t61 = circuit_add(t59, t60); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t62 = circuit_mul(in29, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t63 = circuit_add(t61, t62); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t64 = circuit_mul(in30, t10); // Eval UnnamedPoly step coeff_7 * x^7
    let t65 = circuit_add(t63, t64); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t66 = circuit_mul(in31, t12); // Eval UnnamedPoly step coeff_8 * x^8
    let t67 = circuit_add(t65, t66); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t68 = circuit_mul(in33, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t69 = circuit_add(in32, t68); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t70 = circuit_mul(in34, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t71 = circuit_add(t69, t70); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t72 = circuit_mul(in35, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t73 = circuit_add(t71, t72); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t74 = circuit_mul(in36, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t75 = circuit_add(t73, t74); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t76 = circuit_mul(in37, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t77 = circuit_add(t75, t76); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t78 = circuit_mul(in38, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t79 = circuit_add(t77, t78); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t80 = circuit_mul(in39, t10); // Eval UnnamedPoly step coeff_7 * x^7
    let t81 = circuit_add(t79, t80); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t82 = circuit_mul(in40, t12); // Eval UnnamedPoly step coeff_8 * x^8
    let t83 = circuit_add(t81, t82); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t84 = circuit_mul(in41, t14); // Eval UnnamedPoly step coeff_9 * x^9
    let t85 = circuit_add(t83, t84); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t86 = circuit_mul(in42, t16); // Eval UnnamedPoly step coeff_10 * x^10
    let t87 = circuit_add(t85, t86); // Eval UnnamedPoly step + (coeff_10 * x^10)
    let t88 = circuit_mul(in43, t18); // Eval UnnamedPoly step coeff_11 * x^11
    let t89 = circuit_add(t87, t88); // Eval UnnamedPoly step + (coeff_11 * x^11)
    let t90 = circuit_inverse(t89);
    let t91 = circuit_mul(t67, t90);
    let t92 = circuit_mul(in1, t91);
    let t93 = circuit_add(t51, t92);
    let t94 = circuit_mul(in7, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t95 = circuit_add(in6, t94); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t96 = circuit_mul(in8, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t97 = circuit_add(t95, t96); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t98 = circuit_mul(in9, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t99 = circuit_add(t97, t98); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t100 = circuit_mul(in10, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t101 = circuit_add(t99, t100); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t102 = circuit_mul(in11, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t103 = circuit_add(t101, t102); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t104 = circuit_mul(in12, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t105 = circuit_add(t103, t104); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t106 = circuit_mul(in13, t11); // Eval UnnamedPoly step coeff_7 * x^7
    let t107 = circuit_add(t105, t106); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t108 = circuit_mul(in15, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t109 = circuit_add(in14, t108); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t110 = circuit_mul(in16, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t111 = circuit_add(t109, t110); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t112 = circuit_mul(in17, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t113 = circuit_add(t111, t112); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t114 = circuit_mul(in18, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t115 = circuit_add(t113, t114); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t116 = circuit_mul(in19, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t117 = circuit_add(t115, t116); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t118 = circuit_mul(in20, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t119 = circuit_add(t117, t118); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t120 = circuit_mul(in21, t11); // Eval UnnamedPoly step coeff_7 * x^7
    let t121 = circuit_add(t119, t120); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t122 = circuit_mul(in22, t13); // Eval UnnamedPoly step coeff_8 * x^8
    let t123 = circuit_add(t121, t122); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t124 = circuit_inverse(t123);
    let t125 = circuit_mul(t107, t124);
    let t126 = circuit_mul(in24, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t127 = circuit_add(in23, t126); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t128 = circuit_mul(in25, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t129 = circuit_add(t127, t128); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t130 = circuit_mul(in26, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t131 = circuit_add(t129, t130); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t132 = circuit_mul(in27, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t133 = circuit_add(t131, t132); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t134 = circuit_mul(in28, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t135 = circuit_add(t133, t134); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t136 = circuit_mul(in29, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t137 = circuit_add(t135, t136); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t138 = circuit_mul(in30, t11); // Eval UnnamedPoly step coeff_7 * x^7
    let t139 = circuit_add(t137, t138); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t140 = circuit_mul(in31, t13); // Eval UnnamedPoly step coeff_8 * x^8
    let t141 = circuit_add(t139, t140); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t142 = circuit_mul(in33, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t143 = circuit_add(in32, t142); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t144 = circuit_mul(in34, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t145 = circuit_add(t143, t144); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t146 = circuit_mul(in35, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t147 = circuit_add(t145, t146); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t148 = circuit_mul(in36, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t149 = circuit_add(t147, t148); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t150 = circuit_mul(in37, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t151 = circuit_add(t149, t150); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t152 = circuit_mul(in38, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t153 = circuit_add(t151, t152); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t154 = circuit_mul(in39, t11); // Eval UnnamedPoly step coeff_7 * x^7
    let t155 = circuit_add(t153, t154); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t156 = circuit_mul(in40, t13); // Eval UnnamedPoly step coeff_8 * x^8
    let t157 = circuit_add(t155, t156); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t158 = circuit_mul(in41, t15); // Eval UnnamedPoly step coeff_9 * x^9
    let t159 = circuit_add(t157, t158); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t160 = circuit_mul(in42, t17); // Eval UnnamedPoly step coeff_10 * x^10
    let t161 = circuit_add(t159, t160); // Eval UnnamedPoly step + (coeff_10 * x^10)
    let t162 = circuit_mul(in43, t19); // Eval UnnamedPoly step coeff_11 * x^11
    let t163 = circuit_add(t161, t162); // Eval UnnamedPoly step + (coeff_11 * x^11)
    let t164 = circuit_inverse(t163);
    let t165 = circuit_mul(t141, t164);
    let t166 = circuit_mul(in3, t165);
    let t167 = circuit_add(t125, t166);
    let t168 = circuit_mul(in4, t93);
    let t169 = circuit_mul(in5, t167);
    let t170 = circuit_sub(t168, t169);

    let modulus = get_p(curve_index);
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([modulus.limb0, modulus.limb1, modulus.limb2, modulus.limb3])
        .unwrap();

    let mut circuit_inputs = (t170,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(A0.x); // in0
    circuit_inputs = circuit_inputs.next_2(A0.y); // in1
    circuit_inputs = circuit_inputs.next_2(A2.x); // in2
    circuit_inputs = circuit_inputs.next_2(A2.y); // in3
    circuit_inputs = circuit_inputs.next_2(coeff0); // in4
    circuit_inputs = circuit_inputs.next_2(coeff2); // in5
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
    // in6 - in43

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: u384 = outputs.get_output(t170);
    return (res,);
}
fn run_EVAL_FN_CHALLENGE_DUPL_8P_circuit(
    A0: G1Point,
    A2: G1Point,
    coeff0: u384,
    coeff2: u384,
    SumDlogDiv: FunctionFelt,
    curve_index: usize
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
    let t0 = circuit_mul(in0, in0);
    let t1 = circuit_mul(in2, in2);
    let t2 = circuit_mul(t0, in0);
    let t3 = circuit_mul(t1, in2);
    let t4 = circuit_mul(t2, in0);
    let t5 = circuit_mul(t3, in2);
    let t6 = circuit_mul(t4, in0);
    let t7 = circuit_mul(t5, in2);
    let t8 = circuit_mul(t6, in0);
    let t9 = circuit_mul(t7, in2);
    let t10 = circuit_mul(t8, in0);
    let t11 = circuit_mul(t9, in2);
    let t12 = circuit_mul(t10, in0);
    let t13 = circuit_mul(t11, in2);
    let t14 = circuit_mul(t12, in0);
    let t15 = circuit_mul(t13, in2);
    let t16 = circuit_mul(t14, in0);
    let t17 = circuit_mul(t15, in2);
    let t18 = circuit_mul(t16, in0);
    let t19 = circuit_mul(t17, in2);
    let t20 = circuit_mul(t18, in0);
    let t21 = circuit_mul(t19, in2);
    let t22 = circuit_mul(in7, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t23 = circuit_add(in6, t22); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t24 = circuit_mul(in8, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t25 = circuit_add(t23, t24); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t26 = circuit_mul(in9, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t27 = circuit_add(t25, t26); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t28 = circuit_mul(in10, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t29 = circuit_add(t27, t28); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t30 = circuit_mul(in11, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t31 = circuit_add(t29, t30); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t32 = circuit_mul(in12, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t33 = circuit_add(t31, t32); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t34 = circuit_mul(in13, t10); // Eval UnnamedPoly step coeff_7 * x^7
    let t35 = circuit_add(t33, t34); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t36 = circuit_mul(in14, t12); // Eval UnnamedPoly step coeff_8 * x^8
    let t37 = circuit_add(t35, t36); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t38 = circuit_mul(in16, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t39 = circuit_add(in15, t38); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t40 = circuit_mul(in17, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t41 = circuit_add(t39, t40); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t42 = circuit_mul(in18, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t43 = circuit_add(t41, t42); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t44 = circuit_mul(in19, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t45 = circuit_add(t43, t44); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t46 = circuit_mul(in20, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t47 = circuit_add(t45, t46); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t48 = circuit_mul(in21, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t49 = circuit_add(t47, t48); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t50 = circuit_mul(in22, t10); // Eval UnnamedPoly step coeff_7 * x^7
    let t51 = circuit_add(t49, t50); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t52 = circuit_mul(in23, t12); // Eval UnnamedPoly step coeff_8 * x^8
    let t53 = circuit_add(t51, t52); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t54 = circuit_mul(in24, t14); // Eval UnnamedPoly step coeff_9 * x^9
    let t55 = circuit_add(t53, t54); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t56 = circuit_inverse(t55);
    let t57 = circuit_mul(t37, t56);
    let t58 = circuit_mul(in26, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t59 = circuit_add(in25, t58); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t60 = circuit_mul(in27, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t61 = circuit_add(t59, t60); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t62 = circuit_mul(in28, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t63 = circuit_add(t61, t62); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t64 = circuit_mul(in29, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t65 = circuit_add(t63, t64); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t66 = circuit_mul(in30, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t67 = circuit_add(t65, t66); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t68 = circuit_mul(in31, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t69 = circuit_add(t67, t68); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t70 = circuit_mul(in32, t10); // Eval UnnamedPoly step coeff_7 * x^7
    let t71 = circuit_add(t69, t70); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t72 = circuit_mul(in33, t12); // Eval UnnamedPoly step coeff_8 * x^8
    let t73 = circuit_add(t71, t72); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t74 = circuit_mul(in34, t14); // Eval UnnamedPoly step coeff_9 * x^9
    let t75 = circuit_add(t73, t74); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t76 = circuit_mul(in36, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t77 = circuit_add(in35, t76); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t78 = circuit_mul(in37, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t79 = circuit_add(t77, t78); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t80 = circuit_mul(in38, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t81 = circuit_add(t79, t80); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t82 = circuit_mul(in39, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t83 = circuit_add(t81, t82); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t84 = circuit_mul(in40, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t85 = circuit_add(t83, t84); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t86 = circuit_mul(in41, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t87 = circuit_add(t85, t86); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t88 = circuit_mul(in42, t10); // Eval UnnamedPoly step coeff_7 * x^7
    let t89 = circuit_add(t87, t88); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t90 = circuit_mul(in43, t12); // Eval UnnamedPoly step coeff_8 * x^8
    let t91 = circuit_add(t89, t90); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t92 = circuit_mul(in44, t14); // Eval UnnamedPoly step coeff_9 * x^9
    let t93 = circuit_add(t91, t92); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t94 = circuit_mul(in45, t16); // Eval UnnamedPoly step coeff_10 * x^10
    let t95 = circuit_add(t93, t94); // Eval UnnamedPoly step + (coeff_10 * x^10)
    let t96 = circuit_mul(in46, t18); // Eval UnnamedPoly step coeff_11 * x^11
    let t97 = circuit_add(t95, t96); // Eval UnnamedPoly step + (coeff_11 * x^11)
    let t98 = circuit_mul(in47, t20); // Eval UnnamedPoly step coeff_12 * x^12
    let t99 = circuit_add(t97, t98); // Eval UnnamedPoly step + (coeff_12 * x^12)
    let t100 = circuit_inverse(t99);
    let t101 = circuit_mul(t75, t100);
    let t102 = circuit_mul(in1, t101);
    let t103 = circuit_add(t57, t102);
    let t104 = circuit_mul(in7, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t105 = circuit_add(in6, t104); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t106 = circuit_mul(in8, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t107 = circuit_add(t105, t106); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t108 = circuit_mul(in9, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t109 = circuit_add(t107, t108); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t110 = circuit_mul(in10, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t111 = circuit_add(t109, t110); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t112 = circuit_mul(in11, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t113 = circuit_add(t111, t112); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t114 = circuit_mul(in12, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t115 = circuit_add(t113, t114); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t116 = circuit_mul(in13, t11); // Eval UnnamedPoly step coeff_7 * x^7
    let t117 = circuit_add(t115, t116); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t118 = circuit_mul(in14, t13); // Eval UnnamedPoly step coeff_8 * x^8
    let t119 = circuit_add(t117, t118); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t120 = circuit_mul(in16, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t121 = circuit_add(in15, t120); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t122 = circuit_mul(in17, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t123 = circuit_add(t121, t122); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t124 = circuit_mul(in18, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t125 = circuit_add(t123, t124); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t126 = circuit_mul(in19, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t127 = circuit_add(t125, t126); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t128 = circuit_mul(in20, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t129 = circuit_add(t127, t128); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t130 = circuit_mul(in21, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t131 = circuit_add(t129, t130); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t132 = circuit_mul(in22, t11); // Eval UnnamedPoly step coeff_7 * x^7
    let t133 = circuit_add(t131, t132); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t134 = circuit_mul(in23, t13); // Eval UnnamedPoly step coeff_8 * x^8
    let t135 = circuit_add(t133, t134); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t136 = circuit_mul(in24, t15); // Eval UnnamedPoly step coeff_9 * x^9
    let t137 = circuit_add(t135, t136); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t138 = circuit_inverse(t137);
    let t139 = circuit_mul(t119, t138);
    let t140 = circuit_mul(in26, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t141 = circuit_add(in25, t140); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t142 = circuit_mul(in27, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t143 = circuit_add(t141, t142); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t144 = circuit_mul(in28, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t145 = circuit_add(t143, t144); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t146 = circuit_mul(in29, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t147 = circuit_add(t145, t146); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t148 = circuit_mul(in30, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t149 = circuit_add(t147, t148); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t150 = circuit_mul(in31, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t151 = circuit_add(t149, t150); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t152 = circuit_mul(in32, t11); // Eval UnnamedPoly step coeff_7 * x^7
    let t153 = circuit_add(t151, t152); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t154 = circuit_mul(in33, t13); // Eval UnnamedPoly step coeff_8 * x^8
    let t155 = circuit_add(t153, t154); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t156 = circuit_mul(in34, t15); // Eval UnnamedPoly step coeff_9 * x^9
    let t157 = circuit_add(t155, t156); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t158 = circuit_mul(in36, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t159 = circuit_add(in35, t158); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t160 = circuit_mul(in37, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t161 = circuit_add(t159, t160); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t162 = circuit_mul(in38, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t163 = circuit_add(t161, t162); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t164 = circuit_mul(in39, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t165 = circuit_add(t163, t164); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t166 = circuit_mul(in40, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t167 = circuit_add(t165, t166); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t168 = circuit_mul(in41, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t169 = circuit_add(t167, t168); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t170 = circuit_mul(in42, t11); // Eval UnnamedPoly step coeff_7 * x^7
    let t171 = circuit_add(t169, t170); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t172 = circuit_mul(in43, t13); // Eval UnnamedPoly step coeff_8 * x^8
    let t173 = circuit_add(t171, t172); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t174 = circuit_mul(in44, t15); // Eval UnnamedPoly step coeff_9 * x^9
    let t175 = circuit_add(t173, t174); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t176 = circuit_mul(in45, t17); // Eval UnnamedPoly step coeff_10 * x^10
    let t177 = circuit_add(t175, t176); // Eval UnnamedPoly step + (coeff_10 * x^10)
    let t178 = circuit_mul(in46, t19); // Eval UnnamedPoly step coeff_11 * x^11
    let t179 = circuit_add(t177, t178); // Eval UnnamedPoly step + (coeff_11 * x^11)
    let t180 = circuit_mul(in47, t21); // Eval UnnamedPoly step coeff_12 * x^12
    let t181 = circuit_add(t179, t180); // Eval UnnamedPoly step + (coeff_12 * x^12)
    let t182 = circuit_inverse(t181);
    let t183 = circuit_mul(t157, t182);
    let t184 = circuit_mul(in3, t183);
    let t185 = circuit_add(t139, t184);
    let t186 = circuit_mul(in4, t103);
    let t187 = circuit_mul(in5, t185);
    let t188 = circuit_sub(t186, t187);

    let modulus = get_p(curve_index);
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([modulus.limb0, modulus.limb1, modulus.limb2, modulus.limb3])
        .unwrap();

    let mut circuit_inputs = (t188,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(A0.x); // in0
    circuit_inputs = circuit_inputs.next_2(A0.y); // in1
    circuit_inputs = circuit_inputs.next_2(A2.x); // in2
    circuit_inputs = circuit_inputs.next_2(A2.y); // in3
    circuit_inputs = circuit_inputs.next_2(coeff0); // in4
    circuit_inputs = circuit_inputs.next_2(coeff2); // in5
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
    // in6 - in47

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: u384 = outputs.get_output(t188);
    return (res,);
}
fn run_EVAL_FN_CHALLENGE_DUPL_9P_circuit(
    A0: G1Point,
    A2: G1Point,
    coeff0: u384,
    coeff2: u384,
    SumDlogDiv: FunctionFelt,
    curve_index: usize
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
    let in51 = CE::<CI<51>> {};
    let t0 = circuit_mul(in0, in0);
    let t1 = circuit_mul(in2, in2);
    let t2 = circuit_mul(t0, in0);
    let t3 = circuit_mul(t1, in2);
    let t4 = circuit_mul(t2, in0);
    let t5 = circuit_mul(t3, in2);
    let t6 = circuit_mul(t4, in0);
    let t7 = circuit_mul(t5, in2);
    let t8 = circuit_mul(t6, in0);
    let t9 = circuit_mul(t7, in2);
    let t10 = circuit_mul(t8, in0);
    let t11 = circuit_mul(t9, in2);
    let t12 = circuit_mul(t10, in0);
    let t13 = circuit_mul(t11, in2);
    let t14 = circuit_mul(t12, in0);
    let t15 = circuit_mul(t13, in2);
    let t16 = circuit_mul(t14, in0);
    let t17 = circuit_mul(t15, in2);
    let t18 = circuit_mul(t16, in0);
    let t19 = circuit_mul(t17, in2);
    let t20 = circuit_mul(t18, in0);
    let t21 = circuit_mul(t19, in2);
    let t22 = circuit_mul(t20, in0);
    let t23 = circuit_mul(t21, in2);
    let t24 = circuit_mul(in7, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t25 = circuit_add(in6, t24); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t26 = circuit_mul(in8, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t27 = circuit_add(t25, t26); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t28 = circuit_mul(in9, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t29 = circuit_add(t27, t28); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t30 = circuit_mul(in10, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t31 = circuit_add(t29, t30); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t32 = circuit_mul(in11, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t33 = circuit_add(t31, t32); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t34 = circuit_mul(in12, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t35 = circuit_add(t33, t34); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t36 = circuit_mul(in13, t10); // Eval UnnamedPoly step coeff_7 * x^7
    let t37 = circuit_add(t35, t36); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t38 = circuit_mul(in14, t12); // Eval UnnamedPoly step coeff_8 * x^8
    let t39 = circuit_add(t37, t38); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t40 = circuit_mul(in15, t14); // Eval UnnamedPoly step coeff_9 * x^9
    let t41 = circuit_add(t39, t40); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t42 = circuit_mul(in17, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t43 = circuit_add(in16, t42); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t44 = circuit_mul(in18, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t45 = circuit_add(t43, t44); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t46 = circuit_mul(in19, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t47 = circuit_add(t45, t46); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t48 = circuit_mul(in20, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t49 = circuit_add(t47, t48); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t50 = circuit_mul(in21, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t51 = circuit_add(t49, t50); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t52 = circuit_mul(in22, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t53 = circuit_add(t51, t52); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t54 = circuit_mul(in23, t10); // Eval UnnamedPoly step coeff_7 * x^7
    let t55 = circuit_add(t53, t54); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t56 = circuit_mul(in24, t12); // Eval UnnamedPoly step coeff_8 * x^8
    let t57 = circuit_add(t55, t56); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t58 = circuit_mul(in25, t14); // Eval UnnamedPoly step coeff_9 * x^9
    let t59 = circuit_add(t57, t58); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t60 = circuit_mul(in26, t16); // Eval UnnamedPoly step coeff_10 * x^10
    let t61 = circuit_add(t59, t60); // Eval UnnamedPoly step + (coeff_10 * x^10)
    let t62 = circuit_inverse(t61);
    let t63 = circuit_mul(t41, t62);
    let t64 = circuit_mul(in28, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t65 = circuit_add(in27, t64); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t66 = circuit_mul(in29, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t67 = circuit_add(t65, t66); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t68 = circuit_mul(in30, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t69 = circuit_add(t67, t68); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t70 = circuit_mul(in31, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t71 = circuit_add(t69, t70); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t72 = circuit_mul(in32, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t73 = circuit_add(t71, t72); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t74 = circuit_mul(in33, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t75 = circuit_add(t73, t74); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t76 = circuit_mul(in34, t10); // Eval UnnamedPoly step coeff_7 * x^7
    let t77 = circuit_add(t75, t76); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t78 = circuit_mul(in35, t12); // Eval UnnamedPoly step coeff_8 * x^8
    let t79 = circuit_add(t77, t78); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t80 = circuit_mul(in36, t14); // Eval UnnamedPoly step coeff_9 * x^9
    let t81 = circuit_add(t79, t80); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t82 = circuit_mul(in37, t16); // Eval UnnamedPoly step coeff_10 * x^10
    let t83 = circuit_add(t81, t82); // Eval UnnamedPoly step + (coeff_10 * x^10)
    let t84 = circuit_mul(in39, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t85 = circuit_add(in38, t84); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t86 = circuit_mul(in40, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t87 = circuit_add(t85, t86); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t88 = circuit_mul(in41, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t89 = circuit_add(t87, t88); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t90 = circuit_mul(in42, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t91 = circuit_add(t89, t90); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t92 = circuit_mul(in43, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t93 = circuit_add(t91, t92); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t94 = circuit_mul(in44, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t95 = circuit_add(t93, t94); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t96 = circuit_mul(in45, t10); // Eval UnnamedPoly step coeff_7 * x^7
    let t97 = circuit_add(t95, t96); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t98 = circuit_mul(in46, t12); // Eval UnnamedPoly step coeff_8 * x^8
    let t99 = circuit_add(t97, t98); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t100 = circuit_mul(in47, t14); // Eval UnnamedPoly step coeff_9 * x^9
    let t101 = circuit_add(t99, t100); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t102 = circuit_mul(in48, t16); // Eval UnnamedPoly step coeff_10 * x^10
    let t103 = circuit_add(t101, t102); // Eval UnnamedPoly step + (coeff_10 * x^10)
    let t104 = circuit_mul(in49, t18); // Eval UnnamedPoly step coeff_11 * x^11
    let t105 = circuit_add(t103, t104); // Eval UnnamedPoly step + (coeff_11 * x^11)
    let t106 = circuit_mul(in50, t20); // Eval UnnamedPoly step coeff_12 * x^12
    let t107 = circuit_add(t105, t106); // Eval UnnamedPoly step + (coeff_12 * x^12)
    let t108 = circuit_mul(in51, t22); // Eval UnnamedPoly step coeff_13 * x^13
    let t109 = circuit_add(t107, t108); // Eval UnnamedPoly step + (coeff_13 * x^13)
    let t110 = circuit_inverse(t109);
    let t111 = circuit_mul(t83, t110);
    let t112 = circuit_mul(in1, t111);
    let t113 = circuit_add(t63, t112);
    let t114 = circuit_mul(in7, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t115 = circuit_add(in6, t114); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t116 = circuit_mul(in8, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t117 = circuit_add(t115, t116); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t118 = circuit_mul(in9, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t119 = circuit_add(t117, t118); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t120 = circuit_mul(in10, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t121 = circuit_add(t119, t120); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t122 = circuit_mul(in11, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t123 = circuit_add(t121, t122); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t124 = circuit_mul(in12, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t125 = circuit_add(t123, t124); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t126 = circuit_mul(in13, t11); // Eval UnnamedPoly step coeff_7 * x^7
    let t127 = circuit_add(t125, t126); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t128 = circuit_mul(in14, t13); // Eval UnnamedPoly step coeff_8 * x^8
    let t129 = circuit_add(t127, t128); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t130 = circuit_mul(in15, t15); // Eval UnnamedPoly step coeff_9 * x^9
    let t131 = circuit_add(t129, t130); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t132 = circuit_mul(in17, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t133 = circuit_add(in16, t132); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t134 = circuit_mul(in18, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t135 = circuit_add(t133, t134); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t136 = circuit_mul(in19, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t137 = circuit_add(t135, t136); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t138 = circuit_mul(in20, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t139 = circuit_add(t137, t138); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t140 = circuit_mul(in21, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t141 = circuit_add(t139, t140); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t142 = circuit_mul(in22, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t143 = circuit_add(t141, t142); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t144 = circuit_mul(in23, t11); // Eval UnnamedPoly step coeff_7 * x^7
    let t145 = circuit_add(t143, t144); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t146 = circuit_mul(in24, t13); // Eval UnnamedPoly step coeff_8 * x^8
    let t147 = circuit_add(t145, t146); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t148 = circuit_mul(in25, t15); // Eval UnnamedPoly step coeff_9 * x^9
    let t149 = circuit_add(t147, t148); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t150 = circuit_mul(in26, t17); // Eval UnnamedPoly step coeff_10 * x^10
    let t151 = circuit_add(t149, t150); // Eval UnnamedPoly step + (coeff_10 * x^10)
    let t152 = circuit_inverse(t151);
    let t153 = circuit_mul(t131, t152);
    let t154 = circuit_mul(in28, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t155 = circuit_add(in27, t154); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t156 = circuit_mul(in29, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t157 = circuit_add(t155, t156); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t158 = circuit_mul(in30, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t159 = circuit_add(t157, t158); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t160 = circuit_mul(in31, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t161 = circuit_add(t159, t160); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t162 = circuit_mul(in32, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t163 = circuit_add(t161, t162); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t164 = circuit_mul(in33, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t165 = circuit_add(t163, t164); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t166 = circuit_mul(in34, t11); // Eval UnnamedPoly step coeff_7 * x^7
    let t167 = circuit_add(t165, t166); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t168 = circuit_mul(in35, t13); // Eval UnnamedPoly step coeff_8 * x^8
    let t169 = circuit_add(t167, t168); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t170 = circuit_mul(in36, t15); // Eval UnnamedPoly step coeff_9 * x^9
    let t171 = circuit_add(t169, t170); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t172 = circuit_mul(in37, t17); // Eval UnnamedPoly step coeff_10 * x^10
    let t173 = circuit_add(t171, t172); // Eval UnnamedPoly step + (coeff_10 * x^10)
    let t174 = circuit_mul(in39, in2); // Eval UnnamedPoly step coeff_1 * x^1
    let t175 = circuit_add(in38, t174); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t176 = circuit_mul(in40, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t177 = circuit_add(t175, t176); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t178 = circuit_mul(in41, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t179 = circuit_add(t177, t178); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t180 = circuit_mul(in42, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t181 = circuit_add(t179, t180); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t182 = circuit_mul(in43, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t183 = circuit_add(t181, t182); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t184 = circuit_mul(in44, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t185 = circuit_add(t183, t184); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t186 = circuit_mul(in45, t11); // Eval UnnamedPoly step coeff_7 * x^7
    let t187 = circuit_add(t185, t186); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t188 = circuit_mul(in46, t13); // Eval UnnamedPoly step coeff_8 * x^8
    let t189 = circuit_add(t187, t188); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t190 = circuit_mul(in47, t15); // Eval UnnamedPoly step coeff_9 * x^9
    let t191 = circuit_add(t189, t190); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t192 = circuit_mul(in48, t17); // Eval UnnamedPoly step coeff_10 * x^10
    let t193 = circuit_add(t191, t192); // Eval UnnamedPoly step + (coeff_10 * x^10)
    let t194 = circuit_mul(in49, t19); // Eval UnnamedPoly step coeff_11 * x^11
    let t195 = circuit_add(t193, t194); // Eval UnnamedPoly step + (coeff_11 * x^11)
    let t196 = circuit_mul(in50, t21); // Eval UnnamedPoly step coeff_12 * x^12
    let t197 = circuit_add(t195, t196); // Eval UnnamedPoly step + (coeff_12 * x^12)
    let t198 = circuit_mul(in51, t23); // Eval UnnamedPoly step coeff_13 * x^13
    let t199 = circuit_add(t197, t198); // Eval UnnamedPoly step + (coeff_13 * x^13)
    let t200 = circuit_inverse(t199);
    let t201 = circuit_mul(t173, t200);
    let t202 = circuit_mul(in3, t201);
    let t203 = circuit_add(t153, t202);
    let t204 = circuit_mul(in4, t113);
    let t205 = circuit_mul(in5, t203);
    let t206 = circuit_sub(t204, t205);

    let modulus = get_p(curve_index);
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([modulus.limb0, modulus.limb1, modulus.limb2, modulus.limb3])
        .unwrap();

    let mut circuit_inputs = (t206,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(A0.x); // in0
    circuit_inputs = circuit_inputs.next_2(A0.y); // in1
    circuit_inputs = circuit_inputs.next_2(A2.x); // in2
    circuit_inputs = circuit_inputs.next_2(A2.y); // in3
    circuit_inputs = circuit_inputs.next_2(coeff0); // in4
    circuit_inputs = circuit_inputs.next_2(coeff2); // in5
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
    // in6 - in51

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: u384 = outputs.get_output(t206);
    return (res,);
}
fn run_FINALIZE_FN_CHALLENGE_DUPL_circuit(
    f_a0_accs: FunctionFeltEvaluations,
    f_a1_accs: FunctionFeltEvaluations,
    yA0: u384,
    yA2: u384,
    coeff_A0: u384,
    coeff_A2: u384,
    curve_index: usize
) -> (u384,) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let t0 = circuit_inverse(in1);
    let t1 = circuit_mul(in0, t0);
    let t2 = circuit_inverse(in3);
    let t3 = circuit_mul(in2, t2);
    let t4 = circuit_mul(in8, t3);
    let t5 = circuit_add(t1, t4); // a(x0) + y0 b(x0)
    let t6 = circuit_inverse(in5);
    let t7 = circuit_mul(in4, t6);
    let t8 = circuit_inverse(in7);
    let t9 = circuit_mul(in6, t8);
    let t10 = circuit_mul(in9, t9);
    let t11 = circuit_add(t7, t10); // a(x2) + y2 b(x2)
    let t12 = circuit_mul(in10, t5);
    let t13 = circuit_mul(in11, t11);
    let t14 = circuit_sub(t12, t13);

    let modulus = get_p(curve_index);
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([modulus.limb0, modulus.limb1, modulus.limb2, modulus.limb3])
        .unwrap();

    let mut circuit_inputs = (t14,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(f_a0_accs.a_num); // in0
    circuit_inputs = circuit_inputs.next_2(f_a0_accs.a_den); // in1
    circuit_inputs = circuit_inputs.next_2(f_a0_accs.b_num); // in2
    circuit_inputs = circuit_inputs.next_2(f_a0_accs.b_den); // in3
    circuit_inputs = circuit_inputs.next_2(f_a1_accs.a_num); // in4
    circuit_inputs = circuit_inputs.next_2(f_a1_accs.a_den); // in5
    circuit_inputs = circuit_inputs.next_2(f_a1_accs.b_num); // in6
    circuit_inputs = circuit_inputs.next_2(f_a1_accs.b_den); // in7
    circuit_inputs = circuit_inputs.next_2(yA0); // in8
    circuit_inputs = circuit_inputs.next_2(yA2); // in9
    circuit_inputs = circuit_inputs.next_2(coeff_A0); // in10
    circuit_inputs = circuit_inputs.next_2(coeff_A2); // in11

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: u384 = outputs.get_output(t14);
    return (res,);
}
fn run_INIT_FN_CHALLENGE_DUPL_10P_circuit(
    xA0: u384, xA2: u384, SumDlogDiv: FunctionFelt, curve_index: usize
) -> (FunctionFeltEvaluations, FunctionFeltEvaluations, u384, u384) {
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
    let in51 = CE::<CI<51>> {};
    let t0 = circuit_mul(in0, in0);
    let t1 = circuit_mul(in1, in1);
    let t2 = circuit_mul(t0, in0);
    let t3 = circuit_mul(t1, in1);
    let t4 = circuit_mul(t2, in0);
    let t5 = circuit_mul(t3, in1);
    let t6 = circuit_mul(t4, in0);
    let t7 = circuit_mul(t5, in1);
    let t8 = circuit_mul(t6, in0);
    let t9 = circuit_mul(t7, in1);
    let t10 = circuit_mul(t8, in0);
    let t11 = circuit_mul(t9, in1);
    let t12 = circuit_mul(t10, in0);
    let t13 = circuit_mul(t11, in1);
    let t14 = circuit_mul(t12, in0);
    let t15 = circuit_mul(t13, in1);
    let t16 = circuit_mul(t14, in0);
    let t17 = circuit_mul(t15, in1);
    let t18 = circuit_mul(t16, in0);
    let t19 = circuit_mul(t17, in1);
    let t20 = circuit_mul(t18, in0);
    let t21 = circuit_mul(t19, in1);
    let t22 = circuit_mul(t20, in0);
    let t23 = circuit_mul(t21, in1);
    let t24 = circuit_mul(t22, in0);
    let t25 = circuit_mul(t23, in1);
    let t26 = circuit_mul(in3, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t27 = circuit_add(in2, t26); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t28 = circuit_mul(in4, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t29 = circuit_add(t27, t28); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t30 = circuit_mul(in5, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t31 = circuit_add(t29, t30); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t32 = circuit_mul(in6, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t33 = circuit_add(t31, t32); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t34 = circuit_mul(in7, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t35 = circuit_add(t33, t34); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t36 = circuit_mul(in8, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t37 = circuit_add(t35, t36); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t38 = circuit_mul(in9, t10); // Eval UnnamedPoly step coeff_7 * x^7
    let t39 = circuit_add(t37, t38); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t40 = circuit_mul(in10, t12); // Eval UnnamedPoly step coeff_8 * x^8
    let t41 = circuit_add(t39, t40); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t42 = circuit_mul(in11, t14); // Eval UnnamedPoly step coeff_9 * x^9
    let t43 = circuit_add(t41, t42); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t44 = circuit_mul(in12, t16); // Eval UnnamedPoly step coeff_10 * x^10
    let t45 = circuit_add(t43, t44); // Eval UnnamedPoly step + (coeff_10 * x^10)
    let t46 = circuit_mul(in14, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t47 = circuit_add(in13, t46); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t48 = circuit_mul(in15, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t49 = circuit_add(t47, t48); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t50 = circuit_mul(in16, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t51 = circuit_add(t49, t50); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t52 = circuit_mul(in17, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t53 = circuit_add(t51, t52); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t54 = circuit_mul(in18, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t55 = circuit_add(t53, t54); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t56 = circuit_mul(in19, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t57 = circuit_add(t55, t56); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t58 = circuit_mul(in20, t10); // Eval UnnamedPoly step coeff_7 * x^7
    let t59 = circuit_add(t57, t58); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t60 = circuit_mul(in21, t12); // Eval UnnamedPoly step coeff_8 * x^8
    let t61 = circuit_add(t59, t60); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t62 = circuit_mul(in22, t14); // Eval UnnamedPoly step coeff_9 * x^9
    let t63 = circuit_add(t61, t62); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t64 = circuit_mul(in23, t16); // Eval UnnamedPoly step coeff_10 * x^10
    let t65 = circuit_add(t63, t64); // Eval UnnamedPoly step + (coeff_10 * x^10)
    let t66 = circuit_mul(in24, t18); // Eval UnnamedPoly step coeff_11 * x^11
    let t67 = circuit_add(t65, t66); // Eval UnnamedPoly step + (coeff_11 * x^11)
    let t68 = circuit_mul(in26, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t69 = circuit_add(in25, t68); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t70 = circuit_mul(in27, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t71 = circuit_add(t69, t70); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t72 = circuit_mul(in28, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t73 = circuit_add(t71, t72); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t74 = circuit_mul(in29, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t75 = circuit_add(t73, t74); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t76 = circuit_mul(in30, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t77 = circuit_add(t75, t76); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t78 = circuit_mul(in31, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t79 = circuit_add(t77, t78); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t80 = circuit_mul(in32, t10); // Eval UnnamedPoly step coeff_7 * x^7
    let t81 = circuit_add(t79, t80); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t82 = circuit_mul(in33, t12); // Eval UnnamedPoly step coeff_8 * x^8
    let t83 = circuit_add(t81, t82); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t84 = circuit_mul(in34, t14); // Eval UnnamedPoly step coeff_9 * x^9
    let t85 = circuit_add(t83, t84); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t86 = circuit_mul(in35, t16); // Eval UnnamedPoly step coeff_10 * x^10
    let t87 = circuit_add(t85, t86); // Eval UnnamedPoly step + (coeff_10 * x^10)
    let t88 = circuit_mul(in36, t18); // Eval UnnamedPoly step coeff_11 * x^11
    let t89 = circuit_add(t87, t88); // Eval UnnamedPoly step + (coeff_11 * x^11)
    let t90 = circuit_mul(in38, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t91 = circuit_add(in37, t90); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t92 = circuit_mul(in39, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t93 = circuit_add(t91, t92); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t94 = circuit_mul(in40, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t95 = circuit_add(t93, t94); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t96 = circuit_mul(in41, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t97 = circuit_add(t95, t96); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t98 = circuit_mul(in42, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t99 = circuit_add(t97, t98); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t100 = circuit_mul(in43, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t101 = circuit_add(t99, t100); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t102 = circuit_mul(in44, t10); // Eval UnnamedPoly step coeff_7 * x^7
    let t103 = circuit_add(t101, t102); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t104 = circuit_mul(in45, t12); // Eval UnnamedPoly step coeff_8 * x^8
    let t105 = circuit_add(t103, t104); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t106 = circuit_mul(in46, t14); // Eval UnnamedPoly step coeff_9 * x^9
    let t107 = circuit_add(t105, t106); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t108 = circuit_mul(in47, t16); // Eval UnnamedPoly step coeff_10 * x^10
    let t109 = circuit_add(t107, t108); // Eval UnnamedPoly step + (coeff_10 * x^10)
    let t110 = circuit_mul(in48, t18); // Eval UnnamedPoly step coeff_11 * x^11
    let t111 = circuit_add(t109, t110); // Eval UnnamedPoly step + (coeff_11 * x^11)
    let t112 = circuit_mul(in49, t20); // Eval UnnamedPoly step coeff_12 * x^12
    let t113 = circuit_add(t111, t112); // Eval UnnamedPoly step + (coeff_12 * x^12)
    let t114 = circuit_mul(in50, t22); // Eval UnnamedPoly step coeff_13 * x^13
    let t115 = circuit_add(t113, t114); // Eval UnnamedPoly step + (coeff_13 * x^13)
    let t116 = circuit_mul(in51, t24); // Eval UnnamedPoly step coeff_14 * x^14
    let t117 = circuit_add(t115, t116); // Eval UnnamedPoly step + (coeff_14 * x^14)
    let t118 = circuit_mul(in3, in1); // Eval UnnamedPoly step coeff_1 * x^1
    let t119 = circuit_add(in2, t118); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t120 = circuit_mul(in4, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t121 = circuit_add(t119, t120); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t122 = circuit_mul(in5, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t123 = circuit_add(t121, t122); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t124 = circuit_mul(in6, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t125 = circuit_add(t123, t124); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t126 = circuit_mul(in7, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t127 = circuit_add(t125, t126); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t128 = circuit_mul(in8, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t129 = circuit_add(t127, t128); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t130 = circuit_mul(in9, t11); // Eval UnnamedPoly step coeff_7 * x^7
    let t131 = circuit_add(t129, t130); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t132 = circuit_mul(in10, t13); // Eval UnnamedPoly step coeff_8 * x^8
    let t133 = circuit_add(t131, t132); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t134 = circuit_mul(in11, t15); // Eval UnnamedPoly step coeff_9 * x^9
    let t135 = circuit_add(t133, t134); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t136 = circuit_mul(in12, t17); // Eval UnnamedPoly step coeff_10 * x^10
    let t137 = circuit_add(t135, t136); // Eval UnnamedPoly step + (coeff_10 * x^10)
    let t138 = circuit_mul(in14, in1); // Eval UnnamedPoly step coeff_1 * x^1
    let t139 = circuit_add(in13, t138); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t140 = circuit_mul(in15, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t141 = circuit_add(t139, t140); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t142 = circuit_mul(in16, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t143 = circuit_add(t141, t142); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t144 = circuit_mul(in17, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t145 = circuit_add(t143, t144); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t146 = circuit_mul(in18, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t147 = circuit_add(t145, t146); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t148 = circuit_mul(in19, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t149 = circuit_add(t147, t148); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t150 = circuit_mul(in20, t11); // Eval UnnamedPoly step coeff_7 * x^7
    let t151 = circuit_add(t149, t150); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t152 = circuit_mul(in21, t13); // Eval UnnamedPoly step coeff_8 * x^8
    let t153 = circuit_add(t151, t152); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t154 = circuit_mul(in22, t15); // Eval UnnamedPoly step coeff_9 * x^9
    let t155 = circuit_add(t153, t154); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t156 = circuit_mul(in23, t17); // Eval UnnamedPoly step coeff_10 * x^10
    let t157 = circuit_add(t155, t156); // Eval UnnamedPoly step + (coeff_10 * x^10)
    let t158 = circuit_mul(in24, t19); // Eval UnnamedPoly step coeff_11 * x^11
    let t159 = circuit_add(t157, t158); // Eval UnnamedPoly step + (coeff_11 * x^11)
    let t160 = circuit_mul(in26, in1); // Eval UnnamedPoly step coeff_1 * x^1
    let t161 = circuit_add(in25, t160); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t162 = circuit_mul(in27, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t163 = circuit_add(t161, t162); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t164 = circuit_mul(in28, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t165 = circuit_add(t163, t164); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t166 = circuit_mul(in29, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t167 = circuit_add(t165, t166); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t168 = circuit_mul(in30, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t169 = circuit_add(t167, t168); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t170 = circuit_mul(in31, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t171 = circuit_add(t169, t170); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t172 = circuit_mul(in32, t11); // Eval UnnamedPoly step coeff_7 * x^7
    let t173 = circuit_add(t171, t172); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t174 = circuit_mul(in33, t13); // Eval UnnamedPoly step coeff_8 * x^8
    let t175 = circuit_add(t173, t174); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t176 = circuit_mul(in34, t15); // Eval UnnamedPoly step coeff_9 * x^9
    let t177 = circuit_add(t175, t176); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t178 = circuit_mul(in35, t17); // Eval UnnamedPoly step coeff_10 * x^10
    let t179 = circuit_add(t177, t178); // Eval UnnamedPoly step + (coeff_10 * x^10)
    let t180 = circuit_mul(in36, t19); // Eval UnnamedPoly step coeff_11 * x^11
    let t181 = circuit_add(t179, t180); // Eval UnnamedPoly step + (coeff_11 * x^11)
    let t182 = circuit_mul(in38, in1); // Eval UnnamedPoly step coeff_1 * x^1
    let t183 = circuit_add(in37, t182); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t184 = circuit_mul(in39, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t185 = circuit_add(t183, t184); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t186 = circuit_mul(in40, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t187 = circuit_add(t185, t186); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t188 = circuit_mul(in41, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t189 = circuit_add(t187, t188); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t190 = circuit_mul(in42, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t191 = circuit_add(t189, t190); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t192 = circuit_mul(in43, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t193 = circuit_add(t191, t192); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t194 = circuit_mul(in44, t11); // Eval UnnamedPoly step coeff_7 * x^7
    let t195 = circuit_add(t193, t194); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t196 = circuit_mul(in45, t13); // Eval UnnamedPoly step coeff_8 * x^8
    let t197 = circuit_add(t195, t196); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t198 = circuit_mul(in46, t15); // Eval UnnamedPoly step coeff_9 * x^9
    let t199 = circuit_add(t197, t198); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t200 = circuit_mul(in47, t17); // Eval UnnamedPoly step coeff_10 * x^10
    let t201 = circuit_add(t199, t200); // Eval UnnamedPoly step + (coeff_10 * x^10)
    let t202 = circuit_mul(in48, t19); // Eval UnnamedPoly step coeff_11 * x^11
    let t203 = circuit_add(t201, t202); // Eval UnnamedPoly step + (coeff_11 * x^11)
    let t204 = circuit_mul(in49, t21); // Eval UnnamedPoly step coeff_12 * x^12
    let t205 = circuit_add(t203, t204); // Eval UnnamedPoly step + (coeff_12 * x^12)
    let t206 = circuit_mul(in50, t23); // Eval UnnamedPoly step coeff_13 * x^13
    let t207 = circuit_add(t205, t206); // Eval UnnamedPoly step + (coeff_13 * x^13)
    let t208 = circuit_mul(in51, t25); // Eval UnnamedPoly step coeff_14 * x^14
    let t209 = circuit_add(t207, t208); // Eval UnnamedPoly step + (coeff_14 * x^14)

    let modulus = get_p(curve_index);
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([modulus.limb0, modulus.limb1, modulus.limb2, modulus.limb3])
        .unwrap();

    let mut circuit_inputs = (t45, t67, t89, t117, t137, t159, t181, t209, t18, t19,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(xA0); // in0
    circuit_inputs = circuit_inputs.next_2(xA2); // in1
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
    // in2 - in51

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let A0_evals: FunctionFeltEvaluations = FunctionFeltEvaluations {
        a_num: outputs.get_output(t45),
        a_den: outputs.get_output(t67),
        b_num: outputs.get_output(t89),
        b_den: outputs.get_output(t117)
    };
    let A2_evals: FunctionFeltEvaluations = FunctionFeltEvaluations {
        a_num: outputs.get_output(t137),
        a_den: outputs.get_output(t159),
        b_num: outputs.get_output(t181),
        b_den: outputs.get_output(t209)
    };
    let xA0_power: u384 = outputs.get_output(t18);
    let xA2_power: u384 = outputs.get_output(t19);
    return (A0_evals, A2_evals, xA0_power, xA2_power);
}
fn run_IS_ON_CURVE_G1_G2_circuit(
    p: G1Point, q: G2Point, a: u384, b: u384, b20: u384, b21: u384, curve_index: usize
) -> (u384, u384, u384) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let in9 = CE::<CI<9>> {};
    let t0 = circuit_mul(in1, in1);
    let t1 = circuit_mul(in0, in0);
    let t2 = circuit_mul(in0, t1);
    let t3 = circuit_add(t2, in7);
    let t4 = circuit_add(in4, in5);
    let t5 = circuit_sub(in4, in5);
    let t6 = circuit_mul(t4, t5);
    let t7 = circuit_mul(in4, in5);
    let t8 = circuit_add(t7, t7);
    let t9 = circuit_add(in2, in3);
    let t10 = circuit_sub(in2, in3);
    let t11 = circuit_mul(t9, t10);
    let t12 = circuit_mul(in2, in3);
    let t13 = circuit_add(t12, t12);
    let t14 = circuit_mul(in2, t11); // Fp2 mul start
    let t15 = circuit_mul(in3, t13);
    let t16 = circuit_sub(t14, t15); // Fp2 mul real part end
    let t17 = circuit_mul(in2, t13);
    let t18 = circuit_mul(in3, t11);
    let t19 = circuit_add(t17, t18); // Fp2 mul imag part end
    let t20 = circuit_mul(in6, in2);
    let t21 = circuit_mul(in6, in3);
    let t22 = circuit_add(t20, in8);
    let t23 = circuit_add(t21, in9);
    let t24 = circuit_add(t16, t22);
    let t25 = circuit_add(t19, t23);
    let t26 = circuit_sub(t0, t3);
    let t27 = circuit_sub(t6, t24);
    let t28 = circuit_sub(t8, t25);

    let modulus = get_p(curve_index);
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([modulus.limb0, modulus.limb1, modulus.limb2, modulus.limb3])
        .unwrap();

    let mut circuit_inputs = (t26, t27, t28,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(p.x); // in0
    circuit_inputs = circuit_inputs.next_2(p.y); // in1
    circuit_inputs = circuit_inputs.next_2(q.x0); // in2
    circuit_inputs = circuit_inputs.next_2(q.x1); // in3
    circuit_inputs = circuit_inputs.next_2(q.y0); // in4
    circuit_inputs = circuit_inputs.next_2(q.y1); // in5
    circuit_inputs = circuit_inputs.next_2(a); // in6
    circuit_inputs = circuit_inputs.next_2(b); // in7
    circuit_inputs = circuit_inputs.next_2(b20); // in8
    circuit_inputs = circuit_inputs.next_2(b21); // in9

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let zero_check_0: u384 = outputs.get_output(t26);
    let zero_check_1: u384 = outputs.get_output(t27);
    let zero_check_2: u384 = outputs.get_output(t28);
    return (zero_check_0, zero_check_1, zero_check_2);
}
fn run_IS_ON_CURVE_G1_circuit(p: G1Point, a: u384, b: u384, curve_index: usize) -> (u384,) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let in3 = CE::<CI<3>> {};
    let t0 = circuit_mul(in1, in1);
    let t1 = circuit_mul(in0, in0);
    let t2 = circuit_mul(in0, t1);
    let t3 = circuit_mul(in2, in0);
    let t4 = circuit_add(t3, in3);
    let t5 = circuit_add(t2, t4);
    let t6 = circuit_sub(t0, t5);

    let modulus = get_p(curve_index);
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([modulus.limb0, modulus.limb1, modulus.limb2, modulus.limb3])
        .unwrap();

    let mut circuit_inputs = (t6,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(p.x); // in0
    circuit_inputs = circuit_inputs.next_2(p.y); // in1
    circuit_inputs = circuit_inputs.next_2(a); // in2
    circuit_inputs = circuit_inputs.next_2(b); // in3

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let zero_check: u384 = outputs.get_output(t6);
    return (zero_check,);
}
fn run_IS_ON_CURVE_G2_circuit(
    p: G2Point, a: u384, b20: u384, b21: u384, curve_index: usize
) -> (u384, u384) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let in6 = CE::<CI<6>> {};
    let t0 = circuit_add(in2, in3);
    let t1 = circuit_sub(in2, in3);
    let t2 = circuit_mul(t0, t1);
    let t3 = circuit_mul(in2, in3);
    let t4 = circuit_add(t3, t3);
    let t5 = circuit_add(in0, in1);
    let t6 = circuit_sub(in0, in1);
    let t7 = circuit_mul(t5, t6);
    let t8 = circuit_mul(in0, in1);
    let t9 = circuit_add(t8, t8);
    let t10 = circuit_mul(in0, t7); // Fp2 mul start
    let t11 = circuit_mul(in1, t9);
    let t12 = circuit_sub(t10, t11); // Fp2 mul real part end
    let t13 = circuit_mul(in0, t9);
    let t14 = circuit_mul(in1, t7);
    let t15 = circuit_add(t13, t14); // Fp2 mul imag part end
    let t16 = circuit_mul(in4, in0);
    let t17 = circuit_mul(in4, in1);
    let t18 = circuit_add(t16, in5);
    let t19 = circuit_add(t17, in6);
    let t20 = circuit_add(t12, t18);
    let t21 = circuit_add(t15, t19);
    let t22 = circuit_sub(t2, t20);
    let t23 = circuit_sub(t4, t21);

    let modulus = get_p(curve_index);
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([modulus.limb0, modulus.limb1, modulus.limb2, modulus.limb3])
        .unwrap();

    let mut circuit_inputs = (t22, t23,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(p.x0); // in0
    circuit_inputs = circuit_inputs.next_2(p.x1); // in1
    circuit_inputs = circuit_inputs.next_2(p.y0); // in2
    circuit_inputs = circuit_inputs.next_2(p.y1); // in3
    circuit_inputs = circuit_inputs.next_2(a); // in4
    circuit_inputs = circuit_inputs.next_2(b20); // in5
    circuit_inputs = circuit_inputs.next_2(b21); // in6

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let zero_check_0: u384 = outputs.get_output(t22);
    let zero_check_1: u384 = outputs.get_output(t23);
    return (zero_check_0, zero_check_1);
}
fn run_RHS_FINALIZE_ACC_circuit(
    acc: u384, m: u384, b: u384, xA: u384, Q_result: G1Point, curve_index: usize
) -> (u384,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0

    // INPUT stack
    let (in1, in2, in3) = (CE::<CI<1>> {}, CE::<CI<2>> {}, CE::<CI<3>> {});
    let (in4, in5, in6) = (CE::<CI<4>> {}, CE::<CI<5>> {}, CE::<CI<6>> {});
    let t0 = circuit_sub(in4, in5);
    let t1 = circuit_mul(in2, in5);
    let t2 = circuit_add(t1, in3);
    let t3 = circuit_sub(in0, in6);
    let t4 = circuit_sub(t3, t2);
    let t5 = circuit_inverse(t4);
    let t6 = circuit_mul(t0, t5);
    let t7 = circuit_add(in1, t6);

    let modulus = get_p(curve_index);
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([modulus.limb0, modulus.limb1, modulus.limb2, modulus.limb3])
        .unwrap();

    let mut circuit_inputs = (t7,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in0
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(acc); // in1
    circuit_inputs = circuit_inputs.next_2(m); // in2
    circuit_inputs = circuit_inputs.next_2(b); // in3
    circuit_inputs = circuit_inputs.next_2(xA); // in4
    circuit_inputs = circuit_inputs.next_2(Q_result.x); // in5
    circuit_inputs = circuit_inputs.next_2(Q_result.y); // in6

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let rhs: u384 = outputs.get_output(t7);
    return (rhs,);
}
fn run_SLOPE_INTERCEPT_SAME_POINT_circuit(
    p: G1Point, a: u384, curve_index: usize
) -> (SlopeInterceptOutput,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x3
    let in1 = CE::<CI<1>> {}; // 0x0

    // INPUT stack
    let (in2, in3, in4) = (CE::<CI<2>> {}, CE::<CI<3>> {}, CE::<CI<4>> {});
    let t0 = circuit_mul(in2, in2);
    let t1 = circuit_mul(in0, t0);
    let t2 = circuit_add(t1, in4);
    let t3 = circuit_add(in3, in3);
    let t4 = circuit_inverse(t3);
    let t5 = circuit_mul(t2, t4);
    let t6 = circuit_mul(in2, t5);
    let t7 = circuit_sub(in3, t6);
    let t8 = circuit_mul(t5, t5);
    let t9 = circuit_add(in2, in2);
    let t10 = circuit_sub(t8, t9);
    let t11 = circuit_sub(in2, t10);
    let t12 = circuit_mul(t5, t11);
    let t13 = circuit_sub(t12, in3);
    let t14 = circuit_sub(in1, t13);
    let t15 = circuit_sub(t14, in3);
    let t16 = circuit_sub(t10, in2);
    let t17 = circuit_inverse(t16);
    let t18 = circuit_mul(t15, t17);
    let t19 = circuit_mul(t18, t14);
    let t20 = circuit_add(t14, t14);
    let t21 = circuit_sub(in2, t10);
    let t22 = circuit_mul(t20, t21);
    let t23 = circuit_mul(t10, t10);
    let t24 = circuit_mul(in0, t23);
    let t25 = circuit_add(t19, t19);
    let t26 = circuit_sub(in4, t25);
    let t27 = circuit_add(t24, t26);
    let t28 = circuit_inverse(t27);
    let t29 = circuit_mul(t22, t28);
    let t30 = circuit_add(t18, t18);
    let t31 = circuit_add(t29, t30);

    let modulus = get_p(curve_index);
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([modulus.limb0, modulus.limb1, modulus.limb2, modulus.limb3])
        .unwrap();

    let mut circuit_inputs = (t5, t7, t10, t14, t31, t29,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x3, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in1
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(p.x); // in2
    circuit_inputs = circuit_inputs.next_2(p.y); // in3
    circuit_inputs = circuit_inputs.next_2(a); // in4

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let mb: SlopeInterceptOutput = SlopeInterceptOutput {
        m_A0: outputs.get_output(t5),
        b_A0: outputs.get_output(t7),
        x_A2: outputs.get_output(t10),
        y_A2: outputs.get_output(t14),
        coeff0: outputs.get_output(t31),
        coeff2: outputs.get_output(t29),
    };
    return (mb,);
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

    use super::{
        run_ACC_EVAL_POINT_CHALLENGE_SIGNED_circuit, run_ACC_FUNCTION_CHALLENGE_DUPL_circuit,
        run_ADD_EC_POINT_circuit, run_DOUBLE_EC_POINT_circuit,
        run_EVAL_FN_CHALLENGE_DUPL_10P_circuit, run_EVAL_FN_CHALLENGE_DUPL_1P_circuit,
        run_EVAL_FN_CHALLENGE_DUPL_2P_circuit, run_EVAL_FN_CHALLENGE_DUPL_3P_circuit,
        run_EVAL_FN_CHALLENGE_DUPL_4P_circuit, run_EVAL_FN_CHALLENGE_DUPL_5P_circuit,
        run_EVAL_FN_CHALLENGE_DUPL_6P_circuit, run_EVAL_FN_CHALLENGE_DUPL_7P_circuit,
        run_EVAL_FN_CHALLENGE_DUPL_8P_circuit, run_EVAL_FN_CHALLENGE_DUPL_9P_circuit,
        run_FINALIZE_FN_CHALLENGE_DUPL_circuit, run_INIT_FN_CHALLENGE_DUPL_10P_circuit,
        run_IS_ON_CURVE_G1_G2_circuit, run_IS_ON_CURVE_G1_circuit, run_IS_ON_CURVE_G2_circuit,
        run_RHS_FINALIZE_ACC_circuit, run_SLOPE_INTERCEPT_SAME_POINT_circuit
    };
}
