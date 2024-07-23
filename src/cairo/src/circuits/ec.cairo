use core::circuit::{
    RangeCheck96, AddMod, MulMod, u384, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
    circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, CircuitOutputsTrait,
    CircuitModulus, AddInputResultTrait, CircuitInputs, CircuitDefinition, CircuitData,
    CircuitInputAccumulator
};
use core::circuit::CircuitElement as CE;
use core::circuit::CircuitInput as CI;
use garaga::definitions::{
    get_a, get_b, get_p, get_g, get_min_one, G1Point, G2Point, E12D, E12DMulQuotient, G1G2Pair,
    BNProcessedPair, BLSProcessedPair, MillerLoopResultScalingFactor
};
use garaga::ec_ops::{SlopeInterceptOutput, FunctionFeltEvaluations};
use core::option::Option;

fn run_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit(
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
    let (in1, in2) = (CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4) = (CE::<CI<3>> {}, CE::<CI<4>> {});
    let (in5, in6) = (CE::<CI<5>> {}, CE::<CI<6>> {});
    let (in7, in8) = (CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10) = (CE::<CI<9>> {}, CE::<CI<10>> {});
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
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(acc);
    circuit_inputs = circuit_inputs.next(m);
    circuit_inputs = circuit_inputs.next(b);
    circuit_inputs = circuit_inputs.next(xA);
    circuit_inputs = circuit_inputs.next(p.x);
    circuit_inputs = circuit_inputs.next(p.y);
    circuit_inputs = circuit_inputs.next(ep);
    circuit_inputs = circuit_inputs.next(en);
    circuit_inputs = circuit_inputs.next(sp);
    circuit_inputs = circuit_inputs.next(sn);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
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
    let (in0, in1) = (CE::<CI<0>> {}, CE::<CI<1>> {});
    let (in2, in3) = (CE::<CI<2>> {}, CE::<CI<3>> {});
    let (in4, in5) = (CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7) = (CE::<CI<6>> {}, CE::<CI<7>> {});
    let (in8, in9) = (CE::<CI<8>> {}, CE::<CI<9>> {});
    let (in10, in11) = (CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13) = (CE::<CI<12>> {}, CE::<CI<13>> {});
    let (in14, in15) = (CE::<CI<14>> {}, CE::<CI<15>> {});
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

    circuit_inputs = circuit_inputs.next(f_a0_accs.a_num);
    circuit_inputs = circuit_inputs.next(f_a0_accs.a_den);
    circuit_inputs = circuit_inputs.next(f_a0_accs.b_num);
    circuit_inputs = circuit_inputs.next(f_a0_accs.b_den);
    circuit_inputs = circuit_inputs.next(f_a1_accs.a_num);
    circuit_inputs = circuit_inputs.next(f_a1_accs.a_den);
    circuit_inputs = circuit_inputs.next(f_a1_accs.b_num);
    circuit_inputs = circuit_inputs.next(f_a1_accs.b_den);
    circuit_inputs = circuit_inputs.next(xA0);
    circuit_inputs = circuit_inputs.next(xA2);
    circuit_inputs = circuit_inputs.next(xA0_power);
    circuit_inputs = circuit_inputs.next(xA2_power);
    circuit_inputs = circuit_inputs.next(next_a_num_coeff);
    circuit_inputs = circuit_inputs.next(next_a_den_coeff);
    circuit_inputs = circuit_inputs.next(next_b_num_coeff);
    circuit_inputs = circuit_inputs.next(next_b_den_coeff);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
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
    let (in0, in1) = (CE::<CI<0>> {}, CE::<CI<1>> {});
    let (in2, in3) = (CE::<CI<2>> {}, CE::<CI<3>> {});
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

    circuit_inputs = circuit_inputs.next(p.x);
    circuit_inputs = circuit_inputs.next(p.y);
    circuit_inputs = circuit_inputs.next(q.x);
    circuit_inputs = circuit_inputs.next(q.y);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let r: G1Point = G1Point { x: outputs.get_output(t6), y: outputs.get_output(t9) };
    return (r,);
}
fn run_DOUBLE_EC_POINT_circuit(p: G1Point, A_weirstrass: u384, curve_index: usize) -> (G1Point,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x3

    // INPUT stack
    let (in1, in2) = (CE::<CI<1>> {}, CE::<CI<2>> {});
    let in3 = CE::<CI<3>> {};
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
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(p.x);
    circuit_inputs = circuit_inputs.next(p.y);
    circuit_inputs = circuit_inputs.next(A_weirstrass);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let r: G1Point = G1Point { x: outputs.get_output(t8), y: outputs.get_output(t11) };
    return (r,);
}
fn run_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit(
    A0: G1Point,
    A2: G1Point,
    coeff0: u384,
    coeff2: u384,
    log_div_a_num: Span<u384>,
    log_div_a_den: Span<u384>,
    log_div_b_num: Span<u384>,
    log_div_b_den: Span<u384>,
    curve_index: usize
) -> (u384,) {
    // INPUT stack
    let (in0, in1) = (CE::<CI<0>> {}, CE::<CI<1>> {});
    let (in2, in3) = (CE::<CI<2>> {}, CE::<CI<3>> {});
    let (in4, in5) = (CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7) = (CE::<CI<6>> {}, CE::<CI<7>> {});
    let (in8, in9) = (CE::<CI<8>> {}, CE::<CI<9>> {});
    let (in10, in11) = (CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13) = (CE::<CI<12>> {}, CE::<CI<13>> {});
    let (in14, in15) = (CE::<CI<14>> {}, CE::<CI<15>> {});
    let (in16, in17) = (CE::<CI<16>> {}, CE::<CI<17>> {});
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

    circuit_inputs = circuit_inputs.next(A0.x);
    circuit_inputs = circuit_inputs.next(A0.y);
    circuit_inputs = circuit_inputs.next(A2.x);
    circuit_inputs = circuit_inputs.next(A2.y);
    circuit_inputs = circuit_inputs.next(coeff0);
    circuit_inputs = circuit_inputs.next(coeff2);

    let mut log_div_a_num = log_div_a_num;
    while let Option::Some(val) = log_div_a_num.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };

    let mut log_div_a_den = log_div_a_den;
    while let Option::Some(val) = log_div_a_den.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };

    let mut log_div_b_num = log_div_b_num;
    while let Option::Some(val) = log_div_b_num.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };

    let mut log_div_b_den = log_div_b_den;
    while let Option::Some(val) = log_div_b_den.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res: u384 = outputs.get_output(t62);
    return (res,);
}
fn run_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit(
    A0: G1Point,
    A2: G1Point,
    coeff0: u384,
    coeff2: u384,
    log_div_a_num: Span<u384>,
    log_div_a_den: Span<u384>,
    log_div_b_num: Span<u384>,
    log_div_b_den: Span<u384>,
    curve_index: usize
) -> (u384,) {
    // INPUT stack
    let (in0, in1) = (CE::<CI<0>> {}, CE::<CI<1>> {});
    let (in2, in3) = (CE::<CI<2>> {}, CE::<CI<3>> {});
    let (in4, in5) = (CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7) = (CE::<CI<6>> {}, CE::<CI<7>> {});
    let (in8, in9) = (CE::<CI<8>> {}, CE::<CI<9>> {});
    let (in10, in11) = (CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13) = (CE::<CI<12>> {}, CE::<CI<13>> {});
    let (in14, in15) = (CE::<CI<14>> {}, CE::<CI<15>> {});
    let (in16, in17) = (CE::<CI<16>> {}, CE::<CI<17>> {});
    let (in18, in19) = (CE::<CI<18>> {}, CE::<CI<19>> {});
    let (in20, in21) = (CE::<CI<20>> {}, CE::<CI<21>> {});
    let (in22, in23) = (CE::<CI<22>> {}, CE::<CI<23>> {});
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

    circuit_inputs = circuit_inputs.next(A0.x);
    circuit_inputs = circuit_inputs.next(A0.y);
    circuit_inputs = circuit_inputs.next(A2.x);
    circuit_inputs = circuit_inputs.next(A2.y);
    circuit_inputs = circuit_inputs.next(coeff0);
    circuit_inputs = circuit_inputs.next(coeff2);

    let mut log_div_a_num = log_div_a_num;
    while let Option::Some(val) = log_div_a_num.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };

    let mut log_div_a_den = log_div_a_den;
    while let Option::Some(val) = log_div_a_den.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };

    let mut log_div_b_num = log_div_b_num;
    while let Option::Some(val) = log_div_b_num.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };

    let mut log_div_b_den = log_div_b_den;
    while let Option::Some(val) = log_div_b_den.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res: u384 = outputs.get_output(t80);
    return (res,);
}
fn run_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit(
    A0: G1Point,
    A2: G1Point,
    coeff0: u384,
    coeff2: u384,
    log_div_a_num: Span<u384>,
    log_div_a_den: Span<u384>,
    log_div_b_num: Span<u384>,
    log_div_b_den: Span<u384>,
    curve_index: usize
) -> (u384,) {
    // INPUT stack
    let (in0, in1) = (CE::<CI<0>> {}, CE::<CI<1>> {});
    let (in2, in3) = (CE::<CI<2>> {}, CE::<CI<3>> {});
    let (in4, in5) = (CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7) = (CE::<CI<6>> {}, CE::<CI<7>> {});
    let (in8, in9) = (CE::<CI<8>> {}, CE::<CI<9>> {});
    let (in10, in11) = (CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13) = (CE::<CI<12>> {}, CE::<CI<13>> {});
    let (in14, in15) = (CE::<CI<14>> {}, CE::<CI<15>> {});
    let (in16, in17) = (CE::<CI<16>> {}, CE::<CI<17>> {});
    let (in18, in19) = (CE::<CI<18>> {}, CE::<CI<19>> {});
    let (in20, in21) = (CE::<CI<20>> {}, CE::<CI<21>> {});
    let (in22, in23) = (CE::<CI<22>> {}, CE::<CI<23>> {});
    let (in24, in25) = (CE::<CI<24>> {}, CE::<CI<25>> {});
    let (in26, in27) = (CE::<CI<26>> {}, CE::<CI<27>> {});
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

    circuit_inputs = circuit_inputs.next(A0.x);
    circuit_inputs = circuit_inputs.next(A0.y);
    circuit_inputs = circuit_inputs.next(A2.x);
    circuit_inputs = circuit_inputs.next(A2.y);
    circuit_inputs = circuit_inputs.next(coeff0);
    circuit_inputs = circuit_inputs.next(coeff2);

    let mut log_div_a_num = log_div_a_num;
    while let Option::Some(val) = log_div_a_num.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };

    let mut log_div_a_den = log_div_a_den;
    while let Option::Some(val) = log_div_a_den.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };

    let mut log_div_b_num = log_div_b_num;
    while let Option::Some(val) = log_div_b_num.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };

    let mut log_div_b_den = log_div_b_den;
    while let Option::Some(val) = log_div_b_den.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res: u384 = outputs.get_output(t98);
    return (res,);
}
fn run_EVAL_FUNCTION_CHALLENGE_DUPL_4_circuit(
    A0: G1Point,
    A2: G1Point,
    coeff0: u384,
    coeff2: u384,
    log_div_a_num: Span<u384>,
    log_div_a_den: Span<u384>,
    log_div_b_num: Span<u384>,
    log_div_b_den: Span<u384>,
    curve_index: usize
) -> (u384,) {
    // INPUT stack
    let (in0, in1) = (CE::<CI<0>> {}, CE::<CI<1>> {});
    let (in2, in3) = (CE::<CI<2>> {}, CE::<CI<3>> {});
    let (in4, in5) = (CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7) = (CE::<CI<6>> {}, CE::<CI<7>> {});
    let (in8, in9) = (CE::<CI<8>> {}, CE::<CI<9>> {});
    let (in10, in11) = (CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13) = (CE::<CI<12>> {}, CE::<CI<13>> {});
    let (in14, in15) = (CE::<CI<14>> {}, CE::<CI<15>> {});
    let (in16, in17) = (CE::<CI<16>> {}, CE::<CI<17>> {});
    let (in18, in19) = (CE::<CI<18>> {}, CE::<CI<19>> {});
    let (in20, in21) = (CE::<CI<20>> {}, CE::<CI<21>> {});
    let (in22, in23) = (CE::<CI<22>> {}, CE::<CI<23>> {});
    let (in24, in25) = (CE::<CI<24>> {}, CE::<CI<25>> {});
    let (in26, in27) = (CE::<CI<26>> {}, CE::<CI<27>> {});
    let (in28, in29) = (CE::<CI<28>> {}, CE::<CI<29>> {});
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

    circuit_inputs = circuit_inputs.next(A0.x);
    circuit_inputs = circuit_inputs.next(A0.y);
    circuit_inputs = circuit_inputs.next(A2.x);
    circuit_inputs = circuit_inputs.next(A2.y);
    circuit_inputs = circuit_inputs.next(coeff0);
    circuit_inputs = circuit_inputs.next(coeff2);

    let mut log_div_a_num = log_div_a_num;
    while let Option::Some(val) = log_div_a_num.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };

    let mut log_div_a_den = log_div_a_den;
    while let Option::Some(val) = log_div_a_den.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };

    let mut log_div_b_num = log_div_b_num;
    while let Option::Some(val) = log_div_b_num.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };

    let mut log_div_b_den = log_div_b_den;
    while let Option::Some(val) = log_div_b_den.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res: u384 = outputs.get_output(t116);
    return (res,);
}
fn run_FINALIZE_FUNCTION_CHALLENGE_DUPL_circuit(
    f_a0_accs: FunctionFeltEvaluations,
    f_a1_accs: FunctionFeltEvaluations,
    yA0: u384,
    yA2: u384,
    coeff_A0: u384,
    coeff_A2: u384,
    curve_index: usize
) -> (u384,) {
    // INPUT stack
    let (in0, in1) = (CE::<CI<0>> {}, CE::<CI<1>> {});
    let (in2, in3) = (CE::<CI<2>> {}, CE::<CI<3>> {});
    let (in4, in5) = (CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7) = (CE::<CI<6>> {}, CE::<CI<7>> {});
    let (in8, in9) = (CE::<CI<8>> {}, CE::<CI<9>> {});
    let (in10, in11) = (CE::<CI<10>> {}, CE::<CI<11>> {});
    let t0 = circuit_inverse(in1);
    let t1 = circuit_mul(in0, t0);
    let t2 = circuit_inverse(in3);
    let t3 = circuit_mul(in2, t2);
    let t4 = circuit_mul(in8, t3);
    let t5 = circuit_add(t1, t4);
    let t6 = circuit_inverse(in5);
    let t7 = circuit_mul(in4, t6);
    let t8 = circuit_inverse(in7);
    let t9 = circuit_mul(in6, t8);
    let t10 = circuit_mul(in9, t9);
    let t11 = circuit_add(t7, t10);
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

    circuit_inputs = circuit_inputs.next(f_a0_accs.a_num);
    circuit_inputs = circuit_inputs.next(f_a0_accs.a_den);
    circuit_inputs = circuit_inputs.next(f_a0_accs.b_num);
    circuit_inputs = circuit_inputs.next(f_a0_accs.b_den);
    circuit_inputs = circuit_inputs.next(f_a1_accs.a_num);
    circuit_inputs = circuit_inputs.next(f_a1_accs.a_den);
    circuit_inputs = circuit_inputs.next(f_a1_accs.b_num);
    circuit_inputs = circuit_inputs.next(f_a1_accs.b_den);
    circuit_inputs = circuit_inputs.next(yA0);
    circuit_inputs = circuit_inputs.next(yA2);
    circuit_inputs = circuit_inputs.next(coeff_A0);
    circuit_inputs = circuit_inputs.next(coeff_A2);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res: u384 = outputs.get_output(t14);
    return (res,);
}
fn run_INIT_FUNCTION_CHALLENGE_DUPL_5_circuit(
    xA0: u384,
    xA2: u384,
    log_div_a_num: Span<u384>,
    log_div_a_den: Span<u384>,
    log_div_b_num: Span<u384>,
    log_div_b_den: Span<u384>,
    curve_index: usize
) -> (FunctionFeltEvaluations, FunctionFeltEvaluations, u384, u384) {
    // INPUT stack
    let (in0, in1) = (CE::<CI<0>> {}, CE::<CI<1>> {});
    let (in2, in3) = (CE::<CI<2>> {}, CE::<CI<3>> {});
    let (in4, in5) = (CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7) = (CE::<CI<6>> {}, CE::<CI<7>> {});
    let (in8, in9) = (CE::<CI<8>> {}, CE::<CI<9>> {});
    let (in10, in11) = (CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13) = (CE::<CI<12>> {}, CE::<CI<13>> {});
    let (in14, in15) = (CE::<CI<14>> {}, CE::<CI<15>> {});
    let (in16, in17) = (CE::<CI<16>> {}, CE::<CI<17>> {});
    let (in18, in19) = (CE::<CI<18>> {}, CE::<CI<19>> {});
    let (in20, in21) = (CE::<CI<20>> {}, CE::<CI<21>> {});
    let (in22, in23) = (CE::<CI<22>> {}, CE::<CI<23>> {});
    let (in24, in25) = (CE::<CI<24>> {}, CE::<CI<25>> {});
    let (in26, in27) = (CE::<CI<26>> {}, CE::<CI<27>> {});
    let (in28, in29) = (CE::<CI<28>> {}, CE::<CI<29>> {});
    let (in30, in31) = (CE::<CI<30>> {}, CE::<CI<31>> {});
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
    let t16 = circuit_mul(in3, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t17 = circuit_add(in2, t16); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t18 = circuit_mul(in4, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t19 = circuit_add(t17, t18); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t20 = circuit_mul(in5, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t21 = circuit_add(t19, t20); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t22 = circuit_mul(in6, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t23 = circuit_add(t21, t22); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t24 = circuit_mul(in7, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t25 = circuit_add(t23, t24); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t26 = circuit_mul(in9, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t27 = circuit_add(in8, t26); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t28 = circuit_mul(in10, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t29 = circuit_add(t27, t28); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t30 = circuit_mul(in11, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t31 = circuit_add(t29, t30); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t32 = circuit_mul(in12, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t33 = circuit_add(t31, t32); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t34 = circuit_mul(in13, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t35 = circuit_add(t33, t34); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t36 = circuit_mul(in14, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t37 = circuit_add(t35, t36); // Eval UnnamedPoly step + (coeff_6 * x^6)
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
    let t50 = circuit_mul(in23, in0); // Eval UnnamedPoly step coeff_1 * x^1
    let t51 = circuit_add(in22, t50); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t52 = circuit_mul(in24, t0); // Eval UnnamedPoly step coeff_2 * x^2
    let t53 = circuit_add(t51, t52); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t54 = circuit_mul(in25, t2); // Eval UnnamedPoly step coeff_3 * x^3
    let t55 = circuit_add(t53, t54); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t56 = circuit_mul(in26, t4); // Eval UnnamedPoly step coeff_4 * x^4
    let t57 = circuit_add(t55, t56); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t58 = circuit_mul(in27, t6); // Eval UnnamedPoly step coeff_5 * x^5
    let t59 = circuit_add(t57, t58); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t60 = circuit_mul(in28, t8); // Eval UnnamedPoly step coeff_6 * x^6
    let t61 = circuit_add(t59, t60); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t62 = circuit_mul(in29, t10); // Eval UnnamedPoly step coeff_7 * x^7
    let t63 = circuit_add(t61, t62); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t64 = circuit_mul(in30, t12); // Eval UnnamedPoly step coeff_8 * x^8
    let t65 = circuit_add(t63, t64); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t66 = circuit_mul(in31, t14); // Eval UnnamedPoly step coeff_9 * x^9
    let t67 = circuit_add(t65, t66); // Eval UnnamedPoly step + (coeff_9 * x^9)
    let t68 = circuit_mul(in3, in1); // Eval UnnamedPoly step coeff_1 * x^1
    let t69 = circuit_add(in2, t68); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t70 = circuit_mul(in4, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t71 = circuit_add(t69, t70); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t72 = circuit_mul(in5, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t73 = circuit_add(t71, t72); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t74 = circuit_mul(in6, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t75 = circuit_add(t73, t74); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t76 = circuit_mul(in7, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t77 = circuit_add(t75, t76); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t78 = circuit_mul(in9, in1); // Eval UnnamedPoly step coeff_1 * x^1
    let t79 = circuit_add(in8, t78); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t80 = circuit_mul(in10, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t81 = circuit_add(t79, t80); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t82 = circuit_mul(in11, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t83 = circuit_add(t81, t82); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t84 = circuit_mul(in12, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t85 = circuit_add(t83, t84); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t86 = circuit_mul(in13, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t87 = circuit_add(t85, t86); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t88 = circuit_mul(in14, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t89 = circuit_add(t87, t88); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t90 = circuit_mul(in16, in1); // Eval UnnamedPoly step coeff_1 * x^1
    let t91 = circuit_add(in15, t90); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t92 = circuit_mul(in17, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t93 = circuit_add(t91, t92); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t94 = circuit_mul(in18, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t95 = circuit_add(t93, t94); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t96 = circuit_mul(in19, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t97 = circuit_add(t95, t96); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t98 = circuit_mul(in20, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t99 = circuit_add(t97, t98); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t100 = circuit_mul(in21, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t101 = circuit_add(t99, t100); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t102 = circuit_mul(in23, in1); // Eval UnnamedPoly step coeff_1 * x^1
    let t103 = circuit_add(in22, t102); // Eval UnnamedPoly step + (coeff_1 * x^1)
    let t104 = circuit_mul(in24, t1); // Eval UnnamedPoly step coeff_2 * x^2
    let t105 = circuit_add(t103, t104); // Eval UnnamedPoly step + (coeff_2 * x^2)
    let t106 = circuit_mul(in25, t3); // Eval UnnamedPoly step coeff_3 * x^3
    let t107 = circuit_add(t105, t106); // Eval UnnamedPoly step + (coeff_3 * x^3)
    let t108 = circuit_mul(in26, t5); // Eval UnnamedPoly step coeff_4 * x^4
    let t109 = circuit_add(t107, t108); // Eval UnnamedPoly step + (coeff_4 * x^4)
    let t110 = circuit_mul(in27, t7); // Eval UnnamedPoly step coeff_5 * x^5
    let t111 = circuit_add(t109, t110); // Eval UnnamedPoly step + (coeff_5 * x^5)
    let t112 = circuit_mul(in28, t9); // Eval UnnamedPoly step coeff_6 * x^6
    let t113 = circuit_add(t111, t112); // Eval UnnamedPoly step + (coeff_6 * x^6)
    let t114 = circuit_mul(in29, t11); // Eval UnnamedPoly step coeff_7 * x^7
    let t115 = circuit_add(t113, t114); // Eval UnnamedPoly step + (coeff_7 * x^7)
    let t116 = circuit_mul(in30, t13); // Eval UnnamedPoly step coeff_8 * x^8
    let t117 = circuit_add(t115, t116); // Eval UnnamedPoly step + (coeff_8 * x^8)
    let t118 = circuit_mul(in31, t15); // Eval UnnamedPoly step coeff_9 * x^9
    let t119 = circuit_add(t117, t118); // Eval UnnamedPoly step + (coeff_9 * x^9)

    let modulus = get_p(curve_index);
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([modulus.limb0, modulus.limb1, modulus.limb2, modulus.limb3])
        .unwrap();

    let mut circuit_inputs = (t25, t37, t49, t67, t77, t89, t101, t119, t10, t11,).new_inputs();
    // Prefill constants:

    circuit_inputs = circuit_inputs.next(xA0);
    circuit_inputs = circuit_inputs.next(xA2);

    let mut log_div_a_num = log_div_a_num;
    while let Option::Some(val) = log_div_a_num.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };

    let mut log_div_a_den = log_div_a_den;
    while let Option::Some(val) = log_div_a_den.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };

    let mut log_div_b_num = log_div_b_num;
    while let Option::Some(val) = log_div_b_num.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };

    let mut log_div_b_den = log_div_b_den;
    while let Option::Some(val) = log_div_b_den.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let A0_evals: FunctionFeltEvaluations = FunctionFeltEvaluations {
        a_num: outputs.get_output(t25),
        a_den: outputs.get_output(t37),
        b_num: outputs.get_output(t49),
        b_den: outputs.get_output(t67)
    };
    let A2_evals: FunctionFeltEvaluations = FunctionFeltEvaluations {
        a_num: outputs.get_output(t77),
        a_den: outputs.get_output(t89),
        b_num: outputs.get_output(t101),
        b_den: outputs.get_output(t119)
    };
    let xA0_power: u384 = outputs.get_output(t10);
    let xA2_power: u384 = outputs.get_output(t11);
    return (A0_evals, A2_evals, xA0_power, xA2_power);
}
fn run_IS_ON_CURVE_G1_G2_circuit(
    p: G1Point, q: G2Point, a: u384, b: u384, b20: u384, b21: u384, curve_index: usize
) -> (u384, u384, u384) {
    // INPUT stack
    let (in0, in1) = (CE::<CI<0>> {}, CE::<CI<1>> {});
    let (in2, in3) = (CE::<CI<2>> {}, CE::<CI<3>> {});
    let (in4, in5) = (CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7) = (CE::<CI<6>> {}, CE::<CI<7>> {});
    let (in8, in9) = (CE::<CI<8>> {}, CE::<CI<9>> {});
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

    circuit_inputs = circuit_inputs.next(p.x);
    circuit_inputs = circuit_inputs.next(p.y);
    circuit_inputs = circuit_inputs.next(q.x0);
    circuit_inputs = circuit_inputs.next(q.x1);
    circuit_inputs = circuit_inputs.next(q.y0);
    circuit_inputs = circuit_inputs.next(q.y1);
    circuit_inputs = circuit_inputs.next(a);
    circuit_inputs = circuit_inputs.next(b);
    circuit_inputs = circuit_inputs.next(b20);
    circuit_inputs = circuit_inputs.next(b21);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let zero_check_0: u384 = outputs.get_output(t26);
    let zero_check_1: u384 = outputs.get_output(t27);
    let zero_check_2: u384 = outputs.get_output(t28);
    return (zero_check_0, zero_check_1, zero_check_2);
}
fn run_IS_ON_CURVE_G1_circuit(p: G1Point, a: u384, b: u384, curve_index: usize) -> (u384,) {
    // INPUT stack
    let (in0, in1) = (CE::<CI<0>> {}, CE::<CI<1>> {});
    let (in2, in3) = (CE::<CI<2>> {}, CE::<CI<3>> {});
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

    circuit_inputs = circuit_inputs.next(p.x);
    circuit_inputs = circuit_inputs.next(p.y);
    circuit_inputs = circuit_inputs.next(a);
    circuit_inputs = circuit_inputs.next(b);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let zero_check: u384 = outputs.get_output(t6);
    return (zero_check,);
}
fn run_IS_ON_CURVE_G2_circuit(
    p: G2Point, a: u384, b20: u384, b21: u384, curve_index: usize
) -> (u384, u384) {
    // INPUT stack
    let (in0, in1) = (CE::<CI<0>> {}, CE::<CI<1>> {});
    let (in2, in3) = (CE::<CI<2>> {}, CE::<CI<3>> {});
    let (in4, in5) = (CE::<CI<4>> {}, CE::<CI<5>> {});
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

    circuit_inputs = circuit_inputs.next(p.x0);
    circuit_inputs = circuit_inputs.next(p.x1);
    circuit_inputs = circuit_inputs.next(p.y0);
    circuit_inputs = circuit_inputs.next(p.y1);
    circuit_inputs = circuit_inputs.next(a);
    circuit_inputs = circuit_inputs.next(b20);
    circuit_inputs = circuit_inputs.next(b21);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
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
    let (in1, in2) = (CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4) = (CE::<CI<3>> {}, CE::<CI<4>> {});
    let (in5, in6) = (CE::<CI<5>> {}, CE::<CI<6>> {});
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
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(acc);
    circuit_inputs = circuit_inputs.next(m);
    circuit_inputs = circuit_inputs.next(b);
    circuit_inputs = circuit_inputs.next(xA);
    circuit_inputs = circuit_inputs.next(Q_result.x);
    circuit_inputs = circuit_inputs.next(Q_result.y);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
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
    let (in2, in3) = (CE::<CI<2>> {}, CE::<CI<3>> {});
    let in4 = CE::<CI<4>> {};
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
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(p.x);
    circuit_inputs = circuit_inputs.next(p.y);
    circuit_inputs = circuit_inputs.next(a);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
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
        MillerLoopResultScalingFactor
    };
    use garaga::ec_ops::{SlopeInterceptOutput, FunctionFeltEvaluations};

    use super::{
        run_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit, run_ACC_FUNCTION_CHALLENGE_DUPL_circuit,
        run_ADD_EC_POINT_circuit, run_DOUBLE_EC_POINT_circuit,
        run_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit, run_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit,
        run_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit, run_EVAL_FUNCTION_CHALLENGE_DUPL_4_circuit,
        run_FINALIZE_FUNCTION_CHALLENGE_DUPL_circuit, run_INIT_FUNCTION_CHALLENGE_DUPL_5_circuit,
        run_IS_ON_CURVE_G1_G2_circuit, run_IS_ON_CURVE_G1_circuit, run_IS_ON_CURVE_G2_circuit,
        run_RHS_FINALIZE_ACC_circuit, run_SLOPE_INTERCEPT_SAME_POINT_circuit
    };

    #[test]
    fn test_run_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit_BLS12_381() {
        let acc: u384 = u384 {
            limb0: 19810622137112247197907222309,
            limb1: 13949829356326980055993606151,
            limb2: 55107524867879450997190834961,
            limb3: 3963825035423832093295592605
        };

        let m: u384 = u384 {
            limb0: 31053108138040436674729129554,
            limb1: 36840050990872229935393398650,
            limb2: 49253601792028308041844962126,
            limb3: 7164544154162499002674255779
        };

        let b: u384 = u384 {
            limb0: 41997912830939420264087550837,
            limb1: 13433964319470697008461909961,
            limb2: 5290431739583807388282457006,
            limb3: 3634618912426067682339811562
        };

        let xA: u384 = u384 {
            limb0: 3203300834232228364118543905,
            limb1: 5983187896426808170558818998,
            limb2: 39825200540504584272892685436,
            limb3: 111895808215459903523237277
        };

        let p: G1Point = G1Point {
            x: u384 {
                limb0: 73928849850957586304434882373,
                limb1: 62403613622583151174416730636,
                limb2: 14789160887090903791443394793,
                limb3: 1676137539699393088890560393
            },
            y: u384 {
                limb0: 24223059977053185847889130548,
                limb1: 78823362552325137370061488399,
                limb2: 67428306151240320612652520138,
                limb3: 3263212216173856919914429859
            }
        };

        let ep: u384 = u384 {
            limb0: 71963122480311421720207286875, limb1: 105329, limb2: 0, limb3: 0
        };

        let en: u384 = u384 {
            limb0: 46466281465763485144644681735, limb1: 54592673, limb2: 0, limb3: 0
        };

        let sp: u384 = u384 {
            limb0: 54880396502181392957329877674,
            limb1: 31935979117156477062286671870,
            limb2: 20826981314825584179608359615,
            limb3: 8047903782086192180586325942
        };

        let sn: u384 = u384 {
            limb0: 54880396502181392957329877674,
            limb1: 31935979117156477062286671870,
            limb2: 20826981314825584179608359615,
            limb3: 8047903782086192180586325942
        };

        let (res_acc_result) = run_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit(
            acc, m, b, xA, p, ep, en, sp, sn, 1
        );
        let res_acc: u384 = u384 {
            limb0: 31832098235052790436765483859,
            limb1: 76105358684692375989006522080,
            limb2: 75613970160502882880229543158,
            limb3: 7442866907202158780424227665
        };
        assert_eq!(res_acc_result, res_acc);
    }


    #[test]
    fn test_run_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit_BN254() {
        let acc: u384 = u384 {
            limb0: 44962833349231405535205115340,
            limb1: 63647552159553458055189468718,
            limb2: 657139397831997394,
            limb3: 0
        };

        let m: u384 = u384 {
            limb0: 23834546630586236441457169873,
            limb1: 63142044068385616067126408705,
            limb2: 2771321714894224673,
            limb3: 0
        };

        let b: u384 = u384 {
            limb0: 67662059274113917144334674787,
            limb1: 7007062363991965631562297667,
            limb2: 952905271153146248,
            limb3: 0
        };

        let xA: u384 = u384 {
            limb0: 79151202497022096574680781888,
            limb1: 27855742316335792713888636153,
            limb2: 2832216618801458470,
            limb3: 0
        };

        let p: G1Point = G1Point {
            x: u384 {
                limb0: 64312132840204938797507353927,
                limb1: 75030634435816891896646251238,
                limb2: 1357389798614860830,
                limb3: 0
            },
            y: u384 {
                limb0: 71456350299612486562277415900,
                limb1: 38647649612082196610222287445,
                limb2: 3317576273299603468,
                limb3: 0
            }
        };

        let ep: u384 = u384 {
            limb0: 61230396717721534908260092755, limb1: 201317335, limb2: 0, limb3: 0
        };

        let en: u384 = u384 {
            limb0: 7735439647149380971218439287, limb1: 69198069, limb2: 0, limb3: 0
        };

        let sp: u384 = u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 };

        let sn: u384 = u384 {
            limb0: 32324006162389411176778628422,
            limb1: 57042285082623239461879769745,
            limb2: 3486998266802970665,
            limb3: 0
        };

        let (res_acc_result) = run_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit(
            acc, m, b, xA, p, ep, en, sp, sn, 0
        );
        let res_acc: u384 = u384 {
            limb0: 26506561827560973798740398467,
            limb1: 65406299512716581578605220062,
            limb2: 2159062081397335518,
            limb3: 0
        };
        assert_eq!(res_acc_result, res_acc);
    }


    #[test]
    fn test_run_ACC_FUNCTION_CHALLENGE_DUPL_circuit_BLS12_381() {
        let f_a0_accs: FunctionFeltEvaluations = FunctionFeltEvaluations {
            a_num: u384 {
                limb0: 12108246340442429455971122644,
                limb1: 36573992723376078553845399626,
                limb2: 23772335124274775229954098498,
                limb3: 2863569299286716314494810078
            },
            a_den: u384 {
                limb0: 33875646533936559234872809775,
                limb1: 78504313903278613976349702955,
                limb2: 10928763983555625777832409826,
                limb3: 1382242378138602446805086908
            },
            b_num: u384 {
                limb0: 77820720629424806009019504358,
                limb1: 25129522554439892503182453198,
                limb2: 73755848318658190723354415348,
                limb3: 1434823775076896096245150309
            },
            b_den: u384 {
                limb0: 25786100892102041398555537288,
                limb1: 9688927942274723458760705785,
                limb2: 22938303269890629181013757689,
                limb3: 478926814095195537286572739
            }
        };

        let f_a1_accs: FunctionFeltEvaluations = FunctionFeltEvaluations {
            a_num: u384 {
                limb0: 34694988415059553205942033992,
                limb1: 77263929789656935575577621941,
                limb2: 50605482325959137133224655107,
                limb3: 163430648919606487753511787
            },
            a_den: u384 {
                limb0: 28212222609585886906853123633,
                limb1: 23532623940105012734361898218,
                limb2: 67365120472097392426905098257,
                limb3: 3357851176268082037335105674
            },
            b_num: u384 {
                limb0: 52293061812384466408305828874,
                limb1: 78921144064263136073971338402,
                limb2: 51090796273196843346160009363,
                limb3: 3711054840487085193997117763
            },
            b_den: u384 {
                limb0: 36880896032498523141231777761,
                limb1: 548870523643093760961939326,
                limb2: 41706344732079418021235659440,
                limb3: 1077859243540896794547046208
            }
        };

        let xA0: u384 = u384 {
            limb0: 7883094338375970564381775266,
            limb1: 67341875155230732209969635344,
            limb2: 44938239000025171879243587797,
            limb3: 5670333930418086673658116755
        };

        let xA2: u384 = u384 {
            limb0: 68894933265880722394019213294,
            limb1: 2502439027959160600217219698,
            limb2: 73545631181998657745079280097,
            limb3: 1757419049930726713472737204
        };

        let xA0_power: u384 = u384 {
            limb0: 14121208228699269516919110448,
            limb1: 874973420913452197171104072,
            limb2: 3590101988466229350967840378,
            limb3: 4661176354771332880652175936
        };

        let xA2_power: u384 = u384 {
            limb0: 30773822776250261440661563403,
            limb1: 51824538137531976673887283560,
            limb2: 64452858638021103047684688956,
            limb3: 6091289221105689584377452926
        };

        let next_a_num_coeff: u384 = u384 {
            limb0: 51724032430519362254783717615,
            limb1: 60231235870227440279854038059,
            limb2: 53231759367535954283700670702,
            limb3: 6496371611460324880129521596
        };

        let next_a_den_coeff: u384 = u384 {
            limb0: 38445971634047730524652604279,
            limb1: 21179994813098858427337462173,
            limb2: 60461802833533768996458336992,
            limb3: 462388318467056943993442765
        };

        let next_b_num_coeff: u384 = u384 {
            limb0: 73651298421213632996275590989,
            limb1: 25937099489720806902956942366,
            limb2: 18651622255431763454450187574,
            limb3: 228596103238405175955455070
        };

        let next_b_den_coeff: u384 = u384 {
            limb0: 75154308597034933191701533796,
            limb1: 44913914927744970354560248654,
            limb2: 69559631700243442183360436480,
            limb3: 1546726612799563332665020921
        };

        let (
            next_f_a0_accs_result,
            next_f_a1_accs_result,
            next_xA0_power_result,
            next_xA2_power_result
        ) =
            run_ACC_FUNCTION_CHALLENGE_DUPL_circuit(
            f_a0_accs,
            f_a1_accs,
            xA0,
            xA2,
            xA0_power,
            xA2_power,
            next_a_num_coeff,
            next_a_den_coeff,
            next_b_num_coeff,
            next_b_den_coeff,
            1
        );
        let next_f_a0_accs: FunctionFeltEvaluations = FunctionFeltEvaluations {
            a_num: u384 {
                limb0: 31448122092719716995848518667,
                limb1: 57953657845439179933416208913,
                limb2: 44627945821521075014253432738,
                limb3: 4558522551144338373287929047
            },
            a_den: u384 {
                limb0: 75196631134266894151430674545,
                limb1: 33729945480267778777440997929,
                limb2: 21583091731750224199490995220,
                limb3: 2088831330558073102514207902
            },
            b_num: u384 {
                limb0: 22853032758296755654635993989,
                limb1: 62207943013951400652811630448,
                limb2: 56594823313767368622836281977,
                limb3: 4959579538431375549238473807
            },
            b_den: u384 {
                limb0: 77012490448400821428584662246,
                limb1: 65492667021862932169082189867,
                limb2: 19875655886458886773940523549,
                limb3: 2796876503428529267696099010
            }
        };

        let next_f_a1_accs: FunctionFeltEvaluations = FunctionFeltEvaluations {
            a_num: u384 {
                limb0: 66421375513170572727916247757,
                limb1: 50745224475195360655044598375,
                limb2: 73610463246752593424311395453,
                limb3: 7335320505099146000939656489
            },
            a_den: u384 {
                limb0: 27040144243902402208743709614,
                limb1: 70900162238629659201824938667,
                limb2: 58038864580702886867700031326,
                limb3: 3087066545264049473255486244
            },
            b_num: u384 {
                limb0: 42915569038074432139233079429,
                limb1: 67285627742477967014734970318,
                limb2: 48646048481105623761379108744,
                limb3: 6105608072173562368059704405
            },
            b_den: u384 {
                limb0: 73456520697575806417271113713,
                limb1: 28729232678221943574580394470,
                limb2: 34080658787962467249308509015,
                limb3: 4714836782139058417951276971
            }
        };

        let next_xA0_power: u384 = u384 {
            limb0: 15580082960333239011179411029,
            limb1: 14431143603339515511671270899,
            limb2: 2077071374430543683749228294,
            limb3: 5045791552220884191929556457
        };

        let next_xA2_power: u384 = u384 {
            limb0: 78888903959244946111572815485,
            limb1: 63508566222265648559989018722,
            limb2: 61809550073642674886389507273,
            limb3: 1773538514881343474585695695
        };
        assert_eq!(next_f_a0_accs_result, next_f_a0_accs);
        assert_eq!(next_f_a1_accs_result, next_f_a1_accs);
        assert_eq!(next_xA0_power_result, next_xA0_power);
        assert_eq!(next_xA2_power_result, next_xA2_power);
    }


    #[test]
    fn test_run_ACC_FUNCTION_CHALLENGE_DUPL_circuit_BN254() {
        let f_a0_accs: FunctionFeltEvaluations = FunctionFeltEvaluations {
            a_num: u384 {
                limb0: 26160804169303701108574467383,
                limb1: 26200398398246981547555445397,
                limb2: 2988395391184350717,
                limb3: 0
            },
            a_den: u384 {
                limb0: 34485664336970624705514895001,
                limb1: 73938261058057061540403910557,
                limb2: 680227002010418286,
                limb3: 0
            },
            b_num: u384 {
                limb0: 10238103933028082051602938081,
                limb1: 14801756928247077350447529830,
                limb2: 1610249538293080548,
                limb3: 0
            },
            b_den: u384 {
                limb0: 30809862244687846771967265197,
                limb1: 38976969894147591396940506124,
                limb2: 3365530714051750039,
                limb3: 0
            }
        };

        let f_a1_accs: FunctionFeltEvaluations = FunctionFeltEvaluations {
            a_num: u384 {
                limb0: 15544142913195453928731074524,
                limb1: 16183834845650327124827185620,
                limb2: 3274283301470656708,
                limb3: 0
            },
            a_den: u384 {
                limb0: 4515251077250220512798260103,
                limb1: 53676494393428771485733874429,
                limb2: 1074818787794107075,
                limb3: 0
            },
            b_num: u384 {
                limb0: 48527784689210241541249700331,
                limb1: 68836875509116639126726990962,
                limb2: 3465645697873360170,
                limb3: 0
            },
            b_den: u384 {
                limb0: 69519341455143905783924654782,
                limb1: 32597027569167625847189348169,
                limb2: 248754431759402728,
                limb3: 0
            }
        };

        let xA0: u384 = u384 {
            limb0: 40891579853875313629521435071,
            limb1: 51380432001370256856125453412,
            limb2: 2523429827510821026,
            limb3: 0
        };

        let xA2: u384 = u384 {
            limb0: 74005152646713663672151227870,
            limb1: 36017309965444930923992455369,
            limb2: 1174837212995248629,
            limb3: 0
        };

        let xA0_power: u384 = u384 {
            limb0: 17067298552900150679423746016,
            limb1: 3346210529167654900940823776,
            limb2: 242359391179174861,
            limb3: 0
        };

        let xA2_power: u384 = u384 {
            limb0: 306973362941213357609388067,
            limb1: 564901591820726767813982157,
            limb2: 293718971296888446,
            limb3: 0
        };

        let next_a_num_coeff: u384 = u384 {
            limb0: 53915081349218031573804503368,
            limb1: 48221263659303828121639184235,
            limb2: 2572253192268151092,
            limb3: 0
        };

        let next_a_den_coeff: u384 = u384 {
            limb0: 35946147954191190128290977580,
            limb1: 48195982237333787309495976064,
            limb2: 2796316601135325512,
            limb3: 0
        };

        let next_b_num_coeff: u384 = u384 {
            limb0: 2284078124869378290657040945,
            limb1: 15063791196291306759315859498,
            limb2: 369469589649843398,
            limb3: 0
        };

        let next_b_den_coeff: u384 = u384 {
            limb0: 41556328054675005026691696365,
            limb1: 66337016738192611695858475963,
            limb2: 1158810910657968373,
            limb3: 0
        };

        let (
            next_f_a0_accs_result,
            next_f_a1_accs_result,
            next_xA0_power_result,
            next_xA2_power_result
        ) =
            run_ACC_FUNCTION_CHALLENGE_DUPL_circuit(
            f_a0_accs,
            f_a1_accs,
            xA0,
            xA2,
            xA0_power,
            xA2_power,
            next_a_num_coeff,
            next_a_den_coeff,
            next_b_num_coeff,
            next_b_den_coeff,
            0
        );
        let next_f_a0_accs: FunctionFeltEvaluations = FunctionFeltEvaluations {
            a_num: u384 {
                limb0: 30808963433765998110074714258,
                limb1: 6706184585891884013535342116,
                limb2: 2042061178505947717,
                limb3: 0
            },
            a_den: u384 {
                limb0: 78019483234223392047399986470,
                limb1: 44779490088590909616758779328,
                limb2: 476764642837471437,
                limb3: 0
            },
            b_num: u384 {
                limb0: 23688121263111382210983361301,
                limb1: 52280140532702717950590657618,
                limb2: 1191886752708427522,
                limb3: 0
            },
            b_den: u384 {
                limb0: 19135515725509749782388544291,
                limb1: 52396909026069950741400084648,
                limb2: 2580854289756285308,
                limb3: 0
            }
        };

        let next_f_a1_accs: FunctionFeltEvaluations = FunctionFeltEvaluations {
            a_num: u384 {
                limb0: 63411557572934585210177540957,
                limb1: 14503239548061152056217755855,
                limb2: 374065118833427589,
                limb3: 0
            },
            a_den: u384 {
                limb0: 24836411582707293744402409929,
                limb1: 67686852375784657022872133023,
                limb2: 1910386601568393159,
                limb3: 0
            },
            b_num: u384 {
                limb0: 51051616182486192110384745198,
                limb1: 14482347880876559971871384720,
                limb2: 976223590270110063,
                limb3: 0
            },
            b_den: u384 {
                limb0: 142446536857281040590132644,
                limb1: 34932201872287348552210674411,
                limb2: 1015785014968012746,
                limb3: 0
            }
        };

        let next_xA0_power: u384 = u384 {
            limb0: 44075197729202727530667257374,
            limb1: 25092767447294075943880642846,
            limb2: 370954766988097393,
            limb3: 0
        };

        let next_xA2_power: u384 = u384 {
            limb0: 17829392197683674155933553512,
            limb1: 44822392040537623475564856141,
            limb2: 2770025443621462598,
            limb3: 0
        };
        assert_eq!(next_f_a0_accs_result, next_f_a0_accs);
        assert_eq!(next_f_a1_accs_result, next_f_a1_accs);
        assert_eq!(next_xA0_power_result, next_xA0_power);
        assert_eq!(next_xA2_power_result, next_xA2_power);
    }


    #[test]
    fn test_run_ADD_EC_POINT_circuit_BLS12_381() {
        let p: G1Point = G1Point {
            x: u384 {
                limb0: 12875407038990063061628700034,
                limb1: 25033933193506348906088482406,
                limb2: 1823331722497262066456451357,
                limb3: 6604230986040125537844944638
            },
            y: u384 {
                limb0: 26638281648743243479381974620,
                limb1: 22326581668532872379125961844,
                limb2: 69293571505496601526114705217,
                limb3: 6704695418355896300620047860
            }
        };

        let q: G1Point = G1Point {
            x: u384 {
                limb0: 28765586392982865289008667021,
                limb1: 75046504195749649273445159422,
                limb2: 60751416629908160919025511613,
                limb3: 2338144822313237663375753863
            },
            y: u384 {
                limb0: 19346375897247670342864009388,
                limb1: 54027869929152963906375829689,
                limb2: 47046536620844573968083555972,
                limb3: 6041093272305266754594556219
            }
        };

        let (r_result) = run_ADD_EC_POINT_circuit(p, q, 1);
        let r: G1Point = G1Point {
            x: u384 {
                limb0: 31283346705253657118389816881,
                limb1: 70171886285897530921320001411,
                limb2: 58253503732716673534618492523,
                limb3: 1464574464513963277821927457
            },
            y: u384 {
                limb0: 45184039913936445247613811195,
                limb1: 42722242019564988590184854508,
                limb2: 38184525525705115168170238692,
                limb3: 7120141904745954606121753411
            }
        };
        assert_eq!(r_result, r);
    }


    #[test]
    fn test_run_ADD_EC_POINT_circuit_BN254() {
        let p: G1Point = G1Point {
            x: u384 {
                limb0: 38128859801821715256649374396,
                limb1: 24786117657263552426232126063,
                limb2: 572509101272353298,
                limb3: 0
            },
            y: u384 {
                limb0: 37756010677368974818184730130,
                limb1: 73957050073687763043103620926,
                limb2: 3020155982118805993,
                limb3: 0
            }
        };

        let q: G1Point = G1Point {
            x: u384 {
                limb0: 63314342017339320422970882655,
                limb1: 13997162768002931416456204394,
                limb2: 2538442321033240546,
                limb3: 0
            },
            y: u384 {
                limb0: 44010778514703578787352720968,
                limb1: 72952826293633259921434670571,
                limb2: 2986924236004579438,
                limb3: 0
            }
        };

        let (r_result) = run_ADD_EC_POINT_circuit(p, q, 0);
        let r: G1Point = G1Point {
            x: u384 {
                limb0: 75305423221040578200953077116,
                limb1: 832313931183756826830246841,
                limb2: 2231136249080500033,
                limb3: 0
            },
            y: u384 {
                limb0: 17259010355531170206393473013,
                limb1: 50755733036493923234206796873,
                limb2: 1683017369454101010,
                limb3: 0
            }
        };
        assert_eq!(r_result, r);
    }


    #[test]
    fn test_run_DOUBLE_EC_POINT_circuit_BLS12_381() {
        let p: G1Point = G1Point {
            x: u384 {
                limb0: 53201722009518044555307082091,
                limb1: 26182850778364290173584345611,
                limb2: 9082985586092171798576086462,
                limb3: 2084374856198844811858663259
            },
            y: u384 {
                limb0: 51886784475864541116635883746,
                limb1: 62035932232041883870749760628,
                limb2: 12492049999768513336754604933,
                limb3: 4394375882336316738076748308
            }
        };

        let A_weirstrass: u384 = u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };

        let (r_result) = run_DOUBLE_EC_POINT_circuit(p, A_weirstrass, 1);
        let r: G1Point = G1Point {
            x: u384 {
                limb0: 52801209862070083900761052907,
                limb1: 24378733725315305851389977888,
                limb2: 19067271398967530173083992422,
                limb3: 3730713727070623480657215589
            },
            y: u384 {
                limb0: 77613487060203594703641215278,
                limb1: 67102371626988986346855039891,
                limb2: 24336370853912611161482144046,
                limb3: 190034365233135648884944196
            }
        };
        assert_eq!(r_result, r);
    }


    #[test]
    fn test_run_DOUBLE_EC_POINT_circuit_BN254() {
        let p: G1Point = G1Point {
            x: u384 {
                limb0: 60560778576565062309466296994,
                limb1: 44170652868564955715381828788,
                limb2: 1045034824854055803,
                limb3: 0
            },
            y: u384 {
                limb0: 41767294739936930185340814487,
                limb1: 53310733056225888426673919700,
                limb2: 936318755319797418,
                limb3: 0
            }
        };

        let A_weirstrass: u384 = u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };

        let (r_result) = run_DOUBLE_EC_POINT_circuit(p, A_weirstrass, 0);
        let r: G1Point = G1Point {
            x: u384 {
                limb0: 20967046187375045694021543651,
                limb1: 38022320345279303713894724950,
                limb2: 2926745554410149490,
                limb3: 0
            },
            y: u384 {
                limb0: 76298873595898171174636962047,
                limb1: 37441345285275686030650352179,
                limb2: 259212382702286577,
                limb3: 0
            }
        };
        assert_eq!(r_result, r);
    }


    #[test]
    fn test_run_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit_BLS12_381() {
        let A0: G1Point = G1Point {
            x: u384 {
                limb0: 7583328894958836472689261456,
                limb1: 23995865134773481226042240427,
                limb2: 63478017613684307128330244549,
                limb3: 465853556340900511023207144
            },
            y: u384 {
                limb0: 21356761267284286476218331659,
                limb1: 73182300382538380670716259875,
                limb2: 24004053148595986095787300223,
                limb3: 1022001039698887202091521156
            }
        };

        let A2: G1Point = G1Point {
            x: u384 {
                limb0: 79029124468210850465870597326,
                limb1: 75140792944319733023209253791,
                limb2: 42093390057118540119052572179,
                limb3: 606518660342947232036779274
            },
            y: u384 {
                limb0: 44414617103315706325286783695,
                limb1: 66318307486276839929230289785,
                limb2: 55167842879295115445151139563,
                limb3: 1634264047067373269877374575
            }
        };

        let coeff0: u384 = u384 {
            limb0: 58730436280971129538423813519,
            limb1: 19897324256127475360933650989,
            limb2: 24116796458902841012958318566,
            limb3: 4063790723355910080844289468
        };

        let coeff2: u384 = u384 {
            limb0: 2993190523304409550412932749,
            limb1: 13553940758264748173523256973,
            limb2: 54355150871207218923970903132,
            limb3: 7918207502505106887190889135
        };

        let log_div_a_num: Span<u384> = array![
            u384 {
                limb0: 77045150093437199561876682613,
                limb1: 63247810549753043747824592935,
                limb2: 45322351653447410223048358586,
                limb3: 4891241564897686133014575236
            },
            u384 {
                limb0: 49616765702940610815673434313,
                limb1: 30983336537290843698603394424,
                limb2: 68000082468172739504683525935,
                limb3: 6735570505808929410455319391
            }
        ]
            .span();

        let log_div_a_den: Span<u384> = array![
            u384 {
                limb0: 10755738364987529307384484837,
                limb1: 47424080954943794970182125181,
                limb2: 44668170795920675695082189575,
                limb3: 411775674055255699216064733
            },
            u384 {
                limb0: 74075366540320784004279194557,
                limb1: 45901111491814875426965294020,
                limb2: 11056244753771885820499269497,
                limb3: 1848821835838869900975009596
            },
            u384 {
                limb0: 1483797698072156512478727902,
                limb1: 27276796206714531879437399722,
                limb2: 60549614635777558349423897566,
                limb3: 5825147675425241565654114497
            }
        ]
            .span();

        let log_div_b_num: Span<u384> = array![
            u384 {
                limb0: 29122809252277220054000063647,
                limb1: 29103957579290275626226096329,
                limb2: 78143372271151155558685637529,
                limb3: 6787205099077257704993852800
            },
            u384 {
                limb0: 5127215115757810441247982977,
                limb1: 28593107642171724789447702460,
                limb2: 45568633039957397606573258935,
                limb3: 1488628575882954060993118356
            },
            u384 {
                limb0: 41544852851071536982002373132,
                limb1: 10690239667602887455029393258,
                limb2: 40056190273901790560895741554,
                limb3: 1104740673718121061161636698
            }
        ]
            .span();

        let log_div_b_den: Span<u384> = array![
            u384 {
                limb0: 46168775291129622906430448332,
                limb1: 49174190409785741241747568928,
                limb2: 13111914892901844165005383698,
                limb3: 4634489426994256239540617855
            },
            u384 {
                limb0: 14651105791937006148379740973,
                limb1: 28552790313455794321272600344,
                limb2: 11861619440276751017934021007,
                limb3: 7834141835042731797038955420
            },
            u384 {
                limb0: 35464068568113085230973736790,
                limb1: 29644601032237693127650457879,
                limb2: 21239007568751521325653049117,
                limb3: 3484280708079790606737295977
            },
            u384 {
                limb0: 32802292381907600413177143846,
                limb1: 15823925868741025030511585232,
                limb2: 36423797732402664118035652490,
                limb3: 4227913601559714836560741706
            },
            u384 {
                limb0: 46476941897652146523272430059,
                limb1: 60637876526449722671128730265,
                limb2: 10813098114750570157480288434,
                limb3: 4052176282537828063744703996
            },
            u384 {
                limb0: 44970782327975554560280922237,
                limb1: 7504749009073105970898744732,
                limb2: 78909737051083213042363736038,
                limb3: 6188261761555933459261274855
            }
        ]
            .span();

        let (res_result) = run_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit(
            A0, A2, coeff0, coeff2, log_div_a_num, log_div_a_den, log_div_b_num, log_div_b_den, 1
        );
        let res: u384 = u384 {
            limb0: 77827560147760129965629779634,
            limb1: 65612201965488062574129661709,
            limb2: 10931349107081260327699080751,
            limb3: 5965783541631010229032091089
        };
        assert_eq!(res_result, res);
    }


    #[test]
    fn test_run_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit_BN254() {
        let A0: G1Point = G1Point {
            x: u384 {
                limb0: 40148766616263035635840333009,
                limb1: 46474846459933975019459911928,
                limb2: 2470655728952642587,
                limb3: 0
            },
            y: u384 {
                limb0: 21537482342478193065340640997,
                limb1: 40177993449419617772957987144,
                limb2: 1250679888354201219,
                limb3: 0
            }
        };

        let A2: G1Point = G1Point {
            x: u384 {
                limb0: 30823735281157389256209543712,
                limb1: 19847866653076010386205779801,
                limb2: 2591716463645850631,
                limb3: 0
            },
            y: u384 {
                limb0: 76161780491498106238776533197,
                limb1: 50778725087196949720068307515,
                limb2: 1606868050735217786,
                limb3: 0
            }
        };

        let coeff0: u384 = u384 {
            limb0: 74898788220810224024822405784,
            limb1: 35009367531731238551044390234,
            limb2: 3284164467375196939,
            limb3: 0
        };

        let coeff2: u384 = u384 {
            limb0: 28090742850908769527384262520,
            limb1: 61051006903507127804053417947,
            limb2: 826123398259764642,
            limb3: 0
        };

        let log_div_a_num: Span<u384> = array![
            u384 {
                limb0: 14794237793914580203825001254,
                limb1: 77746575381799877451713667420,
                limb2: 1199297585036842103,
                limb3: 0
            },
            u384 {
                limb0: 7116618687170970882165043068,
                limb1: 10317443627241611822001871482,
                limb2: 689679177778202091,
                limb3: 0
            }
        ]
            .span();

        let log_div_a_den: Span<u384> = array![
            u384 {
                limb0: 31001666614092081990723748281,
                limb1: 41561029444172340142595266045,
                limb2: 2406332089639105853,
                limb3: 0
            },
            u384 {
                limb0: 45928170697383674157136595572,
                limb1: 39032180734333527280233756481,
                limb2: 2956998425360848720,
                limb3: 0
            },
            u384 {
                limb0: 72647567559691066767355592945,
                limb1: 28313574455853548884130432525,
                limb2: 1495684346430252400,
                limb3: 0
            }
        ]
            .span();

        let log_div_b_num: Span<u384> = array![
            u384 {
                limb0: 38540080312249748070424599174,
                limb1: 26562863849074228394866673420,
                limb2: 877967472997105922,
                limb3: 0
            },
            u384 {
                limb0: 57954547034597705093744137517,
                limb1: 55882246706301200147329236607,
                limb2: 1715824789860391444,
                limb3: 0
            },
            u384 {
                limb0: 55275162859819575949303201786,
                limb1: 64738939897155674525545892679,
                limb2: 2924760851437642345,
                limb3: 0
            }
        ]
            .span();

        let log_div_b_den: Span<u384> = array![
            u384 {
                limb0: 42323523345775160595175624498,
                limb1: 5862638532664225004255696984,
                limb2: 573895368452184552,
                limb3: 0
            },
            u384 {
                limb0: 48039078213954386823895538352,
                limb1: 9483252545001263778693678687,
                limb2: 422116173579439317,
                limb3: 0
            },
            u384 {
                limb0: 77684532510750867207844101566,
                limb1: 47972982863049221836870333236,
                limb2: 897392360999745655,
                limb3: 0
            },
            u384 {
                limb0: 14654986812089486663978722625,
                limb1: 37968801859256819202234140283,
                limb2: 3353411595474065306,
                limb3: 0
            },
            u384 {
                limb0: 74234344814779244185063897755,
                limb1: 43118771910670269873180488372,
                limb2: 2862012233304857365,
                limb3: 0
            },
            u384 {
                limb0: 20592975280186094583652543261,
                limb1: 5702184612159354371419393353,
                limb2: 1388401297071074456,
                limb3: 0
            }
        ]
            .span();

        let (res_result) = run_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit(
            A0, A2, coeff0, coeff2, log_div_a_num, log_div_a_den, log_div_b_num, log_div_b_den, 0
        );
        let res: u384 = u384 {
            limb0: 34274908065456138543612886707,
            limb1: 40709557787971075893842667357,
            limb2: 3454714656220187162,
            limb3: 0
        };
        assert_eq!(res_result, res);
    }


    #[test]
    fn test_run_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit_BLS12_381() {
        let A0: G1Point = G1Point {
            x: u384 {
                limb0: 65767048862188894000880605195,
                limb1: 37534452217635903559608298170,
                limb2: 58180994003131892199361724239,
                limb3: 5078765531492571287458606084
            },
            y: u384 {
                limb0: 64246926876373679213975432056,
                limb1: 12690130362744280704764922450,
                limb2: 23556261097436500272783865001,
                limb3: 452536755869646735778726332
            }
        };

        let A2: G1Point = G1Point {
            x: u384 {
                limb0: 54862404535087871815357405032,
                limb1: 67503468372694447312203147827,
                limb2: 28111716523619362390979032720,
                limb3: 7484365428015675707046981596
            },
            y: u384 {
                limb0: 78022090284692562586867737247,
                limb1: 73764645971838121016101973484,
                limb2: 26993018956584650067795467161,
                limb3: 4300951883010802285627173656
            }
        };

        let coeff0: u384 = u384 {
            limb0: 53532230052431160482256072373,
            limb1: 73349623192491526085785572767,
            limb2: 37624412445827650158888211983,
            limb3: 2344766373122814366232550839
        };

        let coeff2: u384 = u384 {
            limb0: 38083203350872957721690776707,
            limb1: 28863323375216826176563820008,
            limb2: 61148298492018667540447579125,
            limb3: 1957739006883122080707665727
        };

        let log_div_a_num: Span<u384> = array![
            u384 {
                limb0: 24558429725501122402824819678,
                limb1: 68342697813896506535660598425,
                limb2: 9654576325383816539580605054,
                limb3: 4449419614608327995090571407
            },
            u384 {
                limb0: 68758036188588496868104646286,
                limb1: 56891258595389737155916225187,
                limb2: 1408531604035569123486374745,
                limb3: 4532148950439698131066013996
            },
            u384 {
                limb0: 55118746527527852686024124923,
                limb1: 16401455574156521911685578456,
                limb2: 68356218296824579607395147997,
                limb3: 4274633836826767384269480656
            }
        ]
            .span();

        let log_div_a_den: Span<u384> = array![
            u384 {
                limb0: 37207096201433968482887965473,
                limb1: 63363061334648502844886171306,
                limb2: 58983605035591813724277703872,
                limb3: 6510798269055198746020224502
            },
            u384 {
                limb0: 27331451642951025804547581919,
                limb1: 11290408363496075061178534039,
                limb2: 39513673746779885991039965221,
                limb3: 7026518597061253491006183919
            },
            u384 {
                limb0: 19102404456994819588605793834,
                limb1: 36598782241760553575219661742,
                limb2: 75008771170587373912728886483,
                limb3: 1810475945971433314583134829
            },
            u384 {
                limb0: 74610124760961754812477629140,
                limb1: 58377991344230990131790349664,
                limb2: 58791772470354736399436051453,
                limb3: 5215668431180415388089886330
            }
        ]
            .span();

        let log_div_b_num: Span<u384> = array![
            u384 {
                limb0: 68446193742335393103502843782,
                limb1: 24489951206429553575321595129,
                limb2: 11937728545212543206473989888,
                limb3: 3043633768618361479769065920
            },
            u384 {
                limb0: 27500370927060974449436176169,
                limb1: 45709591675001960052223002937,
                limb2: 12611881827017711348035166380,
                limb3: 1252741210600307690466672089
            },
            u384 {
                limb0: 43948655267847633428523537973,
                limb1: 64098478544670958175717141502,
                limb2: 27054787921471140642372181164,
                limb3: 6015500424179645355722665708
            },
            u384 {
                limb0: 46950086666011485177431786799,
                limb1: 19814746698209126702265054217,
                limb2: 43218602751870738958780960164,
                limb3: 7174346422794958966058494771
            }
        ]
            .span();

        let log_div_b_den: Span<u384> = array![
            u384 {
                limb0: 11904566295323965385403362114,
                limb1: 9986855602182309707838076955,
                limb2: 28921975690744242248405216063,
                limb3: 3689819613064055325765335341
            },
            u384 {
                limb0: 40909585418941611689912040087,
                limb1: 72843418030114205336704153134,
                limb2: 64002727902485385509362189132,
                limb3: 5338714747924693295334618134
            },
            u384 {
                limb0: 56511832214648574483122896254,
                limb1: 48948480134880266575529786400,
                limb2: 16736011681533189035513036360,
                limb3: 5495837588287940286021134583
            },
            u384 {
                limb0: 55035795486934388231748583316,
                limb1: 32608796974892492723105506831,
                limb2: 7171966635098953791864187580,
                limb3: 7186019043680078440958258514
            },
            u384 {
                limb0: 34483334433821763113694168530,
                limb1: 16106282905813707710782261535,
                limb2: 41380576554605698964309903892,
                limb3: 7078346790967887486358951501
            },
            u384 {
                limb0: 76150993900916235157900039913,
                limb1: 64335514309225783328886852074,
                limb2: 28756481183620185941632902755,
                limb3: 6285267001457104347005350571
            },
            u384 {
                limb0: 79021865442540334634863477409,
                limb1: 18497443262091280994972764093,
                limb2: 16799814604529470286869836524,
                limb3: 5607079376244643758395550033
            }
        ]
            .span();

        let (res_result) = run_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit(
            A0, A2, coeff0, coeff2, log_div_a_num, log_div_a_den, log_div_b_num, log_div_b_den, 1
        );
        let res: u384 = u384 {
            limb0: 1796994533811096489092080494,
            limb1: 15779093703550958270341160034,
            limb2: 19422510478301347858927052822,
            limb3: 646169933846028905286379664
        };
        assert_eq!(res_result, res);
    }


    #[test]
    fn test_run_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit_BN254() {
        let A0: G1Point = G1Point {
            x: u384 {
                limb0: 3636555079963102501892527788,
                limb1: 52006742040801998052484378944,
                limb2: 3162220113988809833,
                limb3: 0
            },
            y: u384 {
                limb0: 21062701446761812807006463558,
                limb1: 17848105974468817471197934249,
                limb2: 1375301049194764590,
                limb3: 0
            }
        };

        let A2: G1Point = G1Point {
            x: u384 {
                limb0: 34783326805436326333945577803,
                limb1: 41388841398860147980780662671,
                limb2: 28618089295067099,
                limb3: 0
            },
            y: u384 {
                limb0: 67237513623925518976819596804,
                limb1: 51223730934775618345943155728,
                limb2: 2095740029227068279,
                limb3: 0
            }
        };

        let coeff0: u384 = u384 {
            limb0: 62884373561056291920603020388,
            limb1: 26268149660478049885105057237,
            limb2: 631865055005170855,
            limb3: 0
        };

        let coeff2: u384 = u384 {
            limb0: 74927920881351490685071244293,
            limb1: 54762055536472718786476825349,
            limb2: 567132222870126647,
            limb3: 0
        };

        let log_div_a_num: Span<u384> = array![
            u384 {
                limb0: 66419072860110050339869820619,
                limb1: 45141714820742065952512633064,
                limb2: 3217559834104654130,
                limb3: 0
            },
            u384 {
                limb0: 76577893561800932074888244242,
                limb1: 62483154821447055814624866535,
                limb2: 729608530089971552,
                limb3: 0
            },
            u384 {
                limb0: 40295453289252839295368126301,
                limb1: 51413807683524257252659823198,
                limb2: 1792296000252955367,
                limb3: 0
            }
        ]
            .span();

        let log_div_a_den: Span<u384> = array![
            u384 {
                limb0: 19880933925577897152525432424,
                limb1: 54732617916798524637621653282,
                limb2: 2111940998382683850,
                limb3: 0
            },
            u384 {
                limb0: 26614051192530018189186683291,
                limb1: 43125433639120527991266879770,
                limb2: 621828703510853011,
                limb3: 0
            },
            u384 {
                limb0: 75514686386904432448194031521,
                limb1: 48339926940835590207610357019,
                limb2: 3105525320639471085,
                limb3: 0
            },
            u384 {
                limb0: 75021609102054288987421711364,
                limb1: 67642975409787310927882119548,
                limb2: 610330270066730084,
                limb3: 0
            }
        ]
            .span();

        let log_div_b_num: Span<u384> = array![
            u384 {
                limb0: 30741892565845760404528223343,
                limb1: 65672443567475252421635917125,
                limb2: 372269656135498629,
                limb3: 0
            },
            u384 {
                limb0: 15236331609649488866924815407,
                limb1: 12682826686433224834405519535,
                limb2: 1028857084617842001,
                limb3: 0
            },
            u384 {
                limb0: 3706268753334235950603414369,
                limb1: 5061594938817017066124061895,
                limb2: 3235172318550209024,
                limb3: 0
            },
            u384 {
                limb0: 41798649402294191906248074676,
                limb1: 71942329400551128942659750399,
                limb2: 2785354068451146667,
                limb3: 0
            }
        ]
            .span();

        let log_div_b_den: Span<u384> = array![
            u384 {
                limb0: 64099216478858599863310237669,
                limb1: 77182244161772445466351224287,
                limb2: 1914483419438017757,
                limb3: 0
            },
            u384 {
                limb0: 78184053005800223115117981229,
                limb1: 75230906188879501586958994545,
                limb2: 1925310095113267403,
                limb3: 0
            },
            u384 {
                limb0: 41859880883168051933292168851,
                limb1: 15089790425756061617928280001,
                limb2: 2805563635729988690,
                limb3: 0
            },
            u384 {
                limb0: 69217987206139527826383454812,
                limb1: 54551758949173673132118713167,
                limb2: 840346734038087871,
                limb3: 0
            },
            u384 {
                limb0: 67655947212642963726507798811,
                limb1: 49726692784924059127858766612,
                limb2: 100744595785321916,
                limb3: 0
            },
            u384 {
                limb0: 35888629229617088004824999264,
                limb1: 9172988570062838870103379281,
                limb2: 1182845696508826919,
                limb3: 0
            },
            u384 {
                limb0: 41267218447368985898299939181,
                limb1: 51097464328089926730815951184,
                limb2: 530848132391008118,
                limb3: 0
            }
        ]
            .span();

        let (res_result) = run_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit(
            A0, A2, coeff0, coeff2, log_div_a_num, log_div_a_den, log_div_b_num, log_div_b_den, 0
        );
        let res: u384 = u384 {
            limb0: 20283816950282402479515032885,
            limb1: 1276425155692095747129076835,
            limb2: 3446911725191841057,
            limb3: 0
        };
        assert_eq!(res_result, res);
    }


    #[test]
    fn test_run_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit_BLS12_381() {
        let A0: G1Point = G1Point {
            x: u384 {
                limb0: 74030770910997380809928801067,
                limb1: 72870080271422360238772842985,
                limb2: 35332984386744009571551879383,
                limb3: 213117707751331445367042061
            },
            y: u384 {
                limb0: 53911856427670238980127554068,
                limb1: 47598882184083941743928375155,
                limb2: 64469875182187854453896945401,
                limb3: 4710791057645923943273563152
            }
        };

        let A2: G1Point = G1Point {
            x: u384 {
                limb0: 9382021819409651063148689085,
                limb1: 18016552063903564748945195561,
                limb2: 32546583337437134217571882382,
                limb3: 1876280894767790922122346829
            },
            y: u384 {
                limb0: 17039220970301599246975031449,
                limb1: 4712133905483429955536263540,
                limb2: 252058361399094932752293537,
                limb3: 5435335018421901824913512718
            }
        };

        let coeff0: u384 = u384 {
            limb0: 17632551922464131811238072914,
            limb1: 12593775649135027097051712668,
            limb2: 73832140458294252783978741095,
            limb3: 3572109152464814668621958321
        };

        let coeff2: u384 = u384 {
            limb0: 17530848419114014704737826365,
            limb1: 10048650392297785556763940622,
            limb2: 27415000093256223375397880278,
            limb3: 4356312786196187608735053950
        };

        let log_div_a_num: Span<u384> = array![
            u384 {
                limb0: 62505647863352096926662303463,
                limb1: 7662952973292534722750046066,
                limb2: 11819334322330838424606312378,
                limb3: 2228144000998654854136880212
            },
            u384 {
                limb0: 10926904322282820847706390438,
                limb1: 45182068785185827134676054734,
                limb2: 37761923604613353371701557318,
                limb3: 2328601210277656834509591410
            },
            u384 {
                limb0: 19609363213726272674414457324,
                limb1: 64623442223733833178221935997,
                limb2: 13839342760447473857713462593,
                limb3: 1010285289685609669771462635
            },
            u384 {
                limb0: 15994045547115158217586200975,
                limb1: 37712177793605455750901464997,
                limb2: 37949689568867541480607656110,
                limb3: 4483360040641239178141238925
            }
        ]
            .span();

        let log_div_a_den: Span<u384> = array![
            u384 {
                limb0: 47751076890492997424778896023,
                limb1: 45158898588446714307151412146,
                limb2: 34068755536928411790602903133,
                limb3: 1655406669862454914709205631
            },
            u384 {
                limb0: 47264448029119937476921761400,
                limb1: 8708733859256235966098767032,
                limb2: 48215692544544501482302062863,
                limb3: 6756407073149860618835829093
            },
            u384 {
                limb0: 21908364541332061992697578757,
                limb1: 35340861620182570595707588062,
                limb2: 77637270239381904164352190365,
                limb3: 3916549285729575534585079457
            },
            u384 {
                limb0: 45898171511413672372932753935,
                limb1: 28548016344158474816179781599,
                limb2: 33785855249417352047592175280,
                limb3: 7445903263701933392069999204
            },
            u384 {
                limb0: 35893455273938352309107615221,
                limb1: 2080646700516431058346219020,
                limb2: 30263546600258042597952466309,
                limb3: 2708085524016270248720043216
            }
        ]
            .span();

        let log_div_b_num: Span<u384> = array![
            u384 {
                limb0: 3459226470770777809730037651,
                limb1: 3521799239736851097521099371,
                limb2: 51786206015678820515596664525,
                limb3: 7575258638946376416989219168
            },
            u384 {
                limb0: 49160664602046435964785293661,
                limb1: 69036182821263326465350473092,
                limb2: 49929859459179433735872323690,
                limb3: 973011804790503889155143481
            },
            u384 {
                limb0: 59767581910396035802124702410,
                limb1: 16816425500136253702812516731,
                limb2: 32631880372008947478762200427,
                limb3: 997437003020617104963749911
            },
            u384 {
                limb0: 16170890331099353878348031414,
                limb1: 41987460868189397116651864065,
                limb2: 5954707858792147804249629551,
                limb3: 1288156010025796053068522766
            },
            u384 {
                limb0: 74016182581385052958198151027,
                limb1: 5257464847259323752304478529,
                limb2: 69226420135741979532223718098,
                limb3: 1172952122986783618438994043
            }
        ]
            .span();

        let log_div_b_den: Span<u384> = array![
            u384 {
                limb0: 69116238475054280746352657554,
                limb1: 33304670868753677946402592534,
                limb2: 64351075069538312587227091978,
                limb3: 365776845916897694131175296
            },
            u384 {
                limb0: 55248761476452341723828038140,
                limb1: 12293956483460203526708774625,
                limb2: 58754719300948559412338253396,
                limb3: 1375008475364259274254964916
            },
            u384 {
                limb0: 24300686353668847428332719991,
                limb1: 38014631825699413785961682855,
                limb2: 47251032500406031276512661332,
                limb3: 4167966723124564055768198087
            },
            u384 {
                limb0: 50704064528320123503506606737,
                limb1: 18328329858539334651902821560,
                limb2: 23679380924341780085679280360,
                limb3: 4967409425445932931684662208
            },
            u384 {
                limb0: 73263438150749671104119509678,
                limb1: 57283302427702266423321493523,
                limb2: 68349986252946238723149811727,
                limb3: 2697427346029370939638037315
            },
            u384 {
                limb0: 30153976504965215982943491419,
                limb1: 25350399447970833472518361392,
                limb2: 65788099606275616882529504563,
                limb3: 945438427330809830625164736
            },
            u384 {
                limb0: 15457273367721198620101569167,
                limb1: 32372676642390061355626449664,
                limb2: 12981191522992192054561334015,
                limb3: 4143290004629368981031116766
            },
            u384 {
                limb0: 68694010858285961426496213143,
                limb1: 21754144885013154319689718197,
                limb2: 28882572635855842335400376167,
                limb3: 655357640203230020680299384
            }
        ]
            .span();

        let (res_result) = run_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit(
            A0, A2, coeff0, coeff2, log_div_a_num, log_div_a_den, log_div_b_num, log_div_b_den, 1
        );
        let res: u384 = u384 {
            limb0: 40253013248657078199561468996,
            limb1: 576757340187103649310802047,
            limb2: 33128776915581077661975437225,
            limb3: 2264493704705425408907739265
        };
        assert_eq!(res_result, res);
    }


    #[test]
    fn test_run_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit_BN254() {
        let A0: G1Point = G1Point {
            x: u384 {
                limb0: 50856419053858407715966739414,
                limb1: 34425437744508680919790030278,
                limb2: 3281703676259823627,
                limb3: 0
            },
            y: u384 {
                limb0: 34165780966617237114827658811,
                limb1: 14157494819384016169227211930,
                limb2: 2638569629760286652,
                limb3: 0
            }
        };

        let A2: G1Point = G1Point {
            x: u384 {
                limb0: 73235677144903878850189826972,
                limb1: 65834203744362665442113831233,
                limb2: 2432335405087577852,
                limb3: 0
            },
            y: u384 {
                limb0: 61302751785256451920898767404,
                limb1: 57900798207103215347751754776,
                limb2: 510979647399546275,
                limb3: 0
            }
        };

        let coeff0: u384 = u384 {
            limb0: 18926594921877902213758803518,
            limb1: 22171130911848535840675118249,
            limb2: 533113395777468169,
            limb3: 0
        };

        let coeff2: u384 = u384 {
            limb0: 11789905667864267216113783162,
            limb1: 34787431084162724474295026005,
            limb2: 1992818134334709100,
            limb3: 0
        };

        let log_div_a_num: Span<u384> = array![
            u384 {
                limb0: 44237499188219561716965821951,
                limb1: 29068321073993617097620523996,
                limb2: 2616983273233811050,
                limb3: 0
            },
            u384 {
                limb0: 3327941640918447977403253171,
                limb1: 76154340205481000024933075760,
                limb2: 2802044260424746491,
                limb3: 0
            },
            u384 {
                limb0: 56438787601403580141325896583,
                limb1: 36339134672395207067442779593,
                limb2: 2008115423737826107,
                limb3: 0
            },
            u384 {
                limb0: 42619109157011030380406953397,
                limb1: 29756427779698272461891325345,
                limb2: 1342164311720450935,
                limb3: 0
            }
        ]
            .span();

        let log_div_a_den: Span<u384> = array![
            u384 {
                limb0: 11965288496913229204009981023,
                limb1: 26740381750208847421560634035,
                limb2: 1693417900677054029,
                limb3: 0
            },
            u384 {
                limb0: 26799399022844720180326536220,
                limb1: 2825709733994950568492654075,
                limb2: 1243412673254409927,
                limb3: 0
            },
            u384 {
                limb0: 14228335690190514799848884079,
                limb1: 57730452658079174027488182234,
                limb2: 1395822044601651686,
                limb3: 0
            },
            u384 {
                limb0: 26028092557699137744351401945,
                limb1: 8608252081711461107372788449,
                limb2: 2586371792171060451,
                limb3: 0
            },
            u384 {
                limb0: 37957144974302941991426166046,
                limb1: 39434591554061410561806218322,
                limb2: 174434171504126794,
                limb3: 0
            }
        ]
            .span();

        let log_div_b_num: Span<u384> = array![
            u384 {
                limb0: 58212970743282169726523508188,
                limb1: 12332980192462000635087583498,
                limb2: 768104795456191077,
                limb3: 0
            },
            u384 {
                limb0: 29755827658352229821663292064,
                limb1: 78554703376256060102591498247,
                limb2: 400855940499081980,
                limb3: 0
            },
            u384 {
                limb0: 6708214298706075286435957397,
                limb1: 17514076504261263985432773778,
                limb2: 1774631670371577349,
                limb3: 0
            },
            u384 {
                limb0: 46339656966918220197016248105,
                limb1: 17212599077166632154236671478,
                limb2: 385828622097463605,
                limb3: 0
            },
            u384 {
                limb0: 78313794566333946292624619618,
                limb1: 46366537921589010624955118549,
                limb2: 768219788298160435,
                limb3: 0
            }
        ]
            .span();

        let log_div_b_den: Span<u384> = array![
            u384 {
                limb0: 71543879203571184504048880471,
                limb1: 59614311822361137145238510546,
                limb2: 930121350344520021,
                limb3: 0
            },
            u384 {
                limb0: 17104913831185493009514731615,
                limb1: 8289618182855331407667405192,
                limb2: 2114033962512689696,
                limb3: 0
            },
            u384 {
                limb0: 43289575798982591282833437677,
                limb1: 8298855205574663293831046320,
                limb2: 2749673857108068302,
                limb3: 0
            },
            u384 {
                limb0: 11757619356668888688405851737,
                limb1: 50576370329908438454647915835,
                limb2: 1951844819685858248,
                limb3: 0
            },
            u384 {
                limb0: 39506853045469557056557666931,
                limb1: 69300794907239421869097720635,
                limb2: 2503264995772838862,
                limb3: 0
            },
            u384 {
                limb0: 17332990945355737742538566964,
                limb1: 55902894981161597246855971135,
                limb2: 3445108781106250088,
                limb3: 0
            },
            u384 {
                limb0: 62128076719890833771235312473,
                limb1: 30027878234381547235596397026,
                limb2: 1357598950990550926,
                limb3: 0
            },
            u384 {
                limb0: 63941514833161185630774327756,
                limb1: 63378238159955251401717592303,
                limb2: 2382064037537721377,
                limb3: 0
            }
        ]
            .span();

        let (res_result) = run_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit(
            A0, A2, coeff0, coeff2, log_div_a_num, log_div_a_den, log_div_b_num, log_div_b_den, 0
        );
        let res: u384 = u384 {
            limb0: 25383102035936540363761097664,
            limb1: 9285330303478073459034036981,
            limb2: 3413067269632576702,
            limb3: 0
        };
        assert_eq!(res_result, res);
    }


    #[test]
    fn test_run_EVAL_FUNCTION_CHALLENGE_DUPL_4_circuit_BLS12_381() {
        let A0: G1Point = G1Point {
            x: u384 {
                limb0: 43165186690971047560311708381,
                limb1: 69917515310259397080114460258,
                limb2: 20394762378384094161904970392,
                limb3: 4222285109988260429586839512
            },
            y: u384 {
                limb0: 43285662375831402482400778207,
                limb1: 48879202687908768173306266272,
                limb2: 4100500076510934582371919056,
                limb3: 5459623500106549711382236508
            }
        };

        let A2: G1Point = G1Point {
            x: u384 {
                limb0: 1373675024443218656325893331,
                limb1: 31053564592595310707404278793,
                limb2: 13330855748347886480343185276,
                limb3: 3106190604025412660535424586
            },
            y: u384 {
                limb0: 64506774694992841008139080625,
                limb1: 39412839001481924145197617233,
                limb2: 23099520114894680353887403496,
                limb3: 3686191629990135809261256203
            }
        };

        let coeff0: u384 = u384 {
            limb0: 18576700323940639157485601256,
            limb1: 70981406061094947898122715548,
            limb2: 74443420867489229448657163806,
            limb3: 1065541839327058890252772653
        };

        let coeff2: u384 = u384 {
            limb0: 10882451445033789762918705450,
            limb1: 59997043538183169019635781983,
            limb2: 67547598261196281708809119931,
            limb3: 6904919142843347521171393047
        };

        let log_div_a_num: Span<u384> = array![
            u384 {
                limb0: 64028141673307812555223566243,
                limb1: 21126490056480020626846435772,
                limb2: 30918762893938642159593046477,
                limb3: 245725871741041374975102778
            },
            u384 {
                limb0: 62330338029423412496024706882,
                limb1: 33716663198078541915875724976,
                limb2: 33827156916522587369966676453,
                limb3: 3761533852198246395553511273
            },
            u384 {
                limb0: 73243097072286306572800791064,
                limb1: 75437708324936351502965177558,
                limb2: 1123668982341118334134880831,
                limb3: 350911528660749289271831729
            },
            u384 {
                limb0: 48836062851493724024987896278,
                limb1: 18744478960593497574895814400,
                limb2: 68088412227359826052813168972,
                limb3: 4211186181426771329323694298
            },
            u384 {
                limb0: 23124626316359900677101984069,
                limb1: 73103433387629399026277172836,
                limb2: 50536436095979029689679785312,
                limb3: 1456507416663684358942367285
            }
        ]
            .span();

        let log_div_a_den: Span<u384> = array![
            u384 {
                limb0: 19524314450822527329497564280,
                limb1: 70908906485605465790186705542,
                limb2: 35002619754538527134808343764,
                limb3: 7212893300244950935021814958
            },
            u384 {
                limb0: 30187116140319496974912862001,
                limb1: 48799470798753569389336700409,
                limb2: 51668570527759383170487341079,
                limb3: 1655248224282238163164773051
            },
            u384 {
                limb0: 38695727774643509759953756866,
                limb1: 17126375216654223283413846690,
                limb2: 68159746454656712574471549378,
                limb3: 938019970927493419520858982
            },
            u384 {
                limb0: 49814761337857653975061997140,
                limb1: 67275263087720024936888562079,
                limb2: 44298718131932898230174584856,
                limb3: 3186117696183744775673821990
            },
            u384 {
                limb0: 58430584158846741026080282444,
                limb1: 25245680165387615629998818017,
                limb2: 78421505021122680314575527994,
                limb3: 857881252721704264314864561
            },
            u384 {
                limb0: 75844527636037548442201950558,
                limb1: 46379609936348424644016896851,
                limb2: 14695681396320810545968202622,
                limb3: 7692526044345365657645297247
            }
        ]
            .span();

        let log_div_b_num: Span<u384> = array![
            u384 {
                limb0: 59378131572103455961175517342,
                limb1: 55808192543544592862447852362,
                limb2: 68678398609668437002709395420,
                limb3: 2978175072802498965141806417
            },
            u384 {
                limb0: 42145476866416089225354984960,
                limb1: 4330545704645134294977064338,
                limb2: 45344372948240479100413782848,
                limb3: 6621663855108047960368046401
            },
            u384 {
                limb0: 64351998269330256232691803832,
                limb1: 64318413114071263899404704554,
                limb2: 48438382570386753447379819564,
                limb3: 5195337556525424482696534362
            },
            u384 {
                limb0: 29664041058092961469921300538,
                limb1: 5285980666757143594718071424,
                limb2: 42523071728521032734343793405,
                limb3: 7258519357538542310305261189
            },
            u384 {
                limb0: 12164800029416215335299577246,
                limb1: 32867488546962500085874239205,
                limb2: 19896716127516382156212910620,
                limb3: 6204886798574107078918662465
            },
            u384 {
                limb0: 52391896317815037768168024882,
                limb1: 8803023274489797136583137175,
                limb2: 56309197846896651023794986111,
                limb3: 7826206923877451394407937457
            }
        ]
            .span();

        let log_div_b_den: Span<u384> = array![
            u384 {
                limb0: 7897438533363568857874672851,
                limb1: 66250301347808051994700389267,
                limb2: 30255629545301289661070704087,
                limb3: 4044759229396296089747754939
            },
            u384 {
                limb0: 75906342119350169619458182248,
                limb1: 33730279642446571396203195621,
                limb2: 11180052238657403612612166225,
                limb3: 6285120259310007705890799075
            },
            u384 {
                limb0: 43264629198570518863064010733,
                limb1: 72407269251548227379565248645,
                limb2: 14935285505642613887456089787,
                limb3: 7882442472631512258057233282
            },
            u384 {
                limb0: 74145408479393214750289035988,
                limb1: 17431498364682868199822761649,
                limb2: 57312691130570348363810232350,
                limb3: 4044175930849623451381377296
            },
            u384 {
                limb0: 42772810005318944661768652636,
                limb1: 15590402383752320998704693882,
                limb2: 44036747589447627060742987962,
                limb3: 546270077974573836650002957
            },
            u384 {
                limb0: 23322832688108859044772399466,
                limb1: 33925894869330820421611849483,
                limb2: 54774771899660228275798792954,
                limb3: 6860967141537636341842744542
            },
            u384 {
                limb0: 8180433722233846113276826286,
                limb1: 18263761769620988804436683631,
                limb2: 21296152914339763094002639050,
                limb3: 4955802473365182050273334235
            },
            u384 {
                limb0: 22062101326248438963738967678,
                limb1: 15471588330549963945434935132,
                limb2: 59926227748979981662152323421,
                limb3: 5803474454340310615429123769
            },
            u384 {
                limb0: 61923664243190382334500654334,
                limb1: 19564630540317843168975393922,
                limb2: 12730877225579453547549887747,
                limb3: 4468238513650587045294874142
            }
        ]
            .span();

        let (res_result) = run_EVAL_FUNCTION_CHALLENGE_DUPL_4_circuit(
            A0, A2, coeff0, coeff2, log_div_a_num, log_div_a_den, log_div_b_num, log_div_b_den, 1
        );
        let res: u384 = u384 {
            limb0: 76539844859838743713384262922,
            limb1: 6268610119141610121057002242,
            limb2: 41790163228452064756497269787,
            limb3: 5859254972929823052723913943
        };
        assert_eq!(res_result, res);
    }


    #[test]
    fn test_run_EVAL_FUNCTION_CHALLENGE_DUPL_4_circuit_BN254() {
        let A0: G1Point = G1Point {
            x: u384 {
                limb0: 55668785107385345975752051280,
                limb1: 64883914332629146444197111757,
                limb2: 3389193101876737875,
                limb3: 0
            },
            y: u384 {
                limb0: 51423999903897577686947789751,
                limb1: 5183952842749797492611248045,
                limb2: 359714847378698731,
                limb3: 0
            }
        };

        let A2: G1Point = G1Point {
            x: u384 {
                limb0: 44072274133839950303252629486,
                limb1: 64525881541802110150723770773,
                limb2: 2983494767123261625,
                limb3: 0
            },
            y: u384 {
                limb0: 27810531813873559107007780312,
                limb1: 75043292133600441181275178414,
                limb2: 3192437768491137341,
                limb3: 0
            }
        };

        let coeff0: u384 = u384 {
            limb0: 10609285974367965880368994737,
            limb1: 59765436325149099051264815070,
            limb2: 839820320230654168,
            limb3: 0
        };

        let coeff2: u384 = u384 {
            limb0: 57435018450721878992032589945,
            limb1: 56158962864896780296006864635,
            limb2: 1210721556463011116,
            limb3: 0
        };

        let log_div_a_num: Span<u384> = array![
            u384 {
                limb0: 51980303238257340939075389625,
                limb1: 29419149037721018532034165792,
                limb2: 1762736554193168628,
                limb3: 0
            },
            u384 {
                limb0: 60042776488008117419880722474,
                limb1: 6049712153568245481145035953,
                limb2: 1966269248594059195,
                limb3: 0
            },
            u384 {
                limb0: 16329307157267357311241895640,
                limb1: 71395564642020900531805318618,
                limb2: 1926949878923970758,
                limb3: 0
            },
            u384 {
                limb0: 38204894262933024875592342121,
                limb1: 77028297798340164216119503244,
                limb2: 2801276035461103669,
                limb3: 0
            },
            u384 {
                limb0: 14417063359116162959087224381,
                limb1: 45181177729831640333313431426,
                limb2: 1534242523443380315,
                limb3: 0
            }
        ]
            .span();

        let log_div_a_den: Span<u384> = array![
            u384 {
                limb0: 33106758832017106593895347638,
                limb1: 70510013012226003162572674973,
                limb2: 2776081437219283200,
                limb3: 0
            },
            u384 {
                limb0: 53363638359990400134671871630,
                limb1: 64197668598527049072889414785,
                limb2: 1626872940959679097,
                limb3: 0
            },
            u384 {
                limb0: 48469481536116538599742143463,
                limb1: 36356404449337761124562374339,
                limb2: 467996245412698471,
                limb3: 0
            },
            u384 {
                limb0: 11992589081199988514061300214,
                limb1: 47402229920671397129896176339,
                limb2: 611979743651034203,
                limb3: 0
            },
            u384 {
                limb0: 8342157188030492896997505177,
                limb1: 51418464347089486288707415102,
                limb2: 899157108623096734,
                limb3: 0
            },
            u384 {
                limb0: 61514321690367231113489247420,
                limb1: 8794082332401772384053866233,
                limb2: 277442843723388983,
                limb3: 0
            }
        ]
            .span();

        let log_div_b_num: Span<u384> = array![
            u384 {
                limb0: 37014479358602183893993967274,
                limb1: 73992410814615679596704876862,
                limb2: 2999773476450883682,
                limb3: 0
            },
            u384 {
                limb0: 72238916972117140272551967038,
                limb1: 23277513766764053423386836857,
                limb2: 3439322102752682523,
                limb3: 0
            },
            u384 {
                limb0: 14984222068724942946017071379,
                limb1: 31059530731656514522994603031,
                limb2: 1713617869122566164,
                limb3: 0
            },
            u384 {
                limb0: 74022047303277785982704653841,
                limb1: 20233789422716363622468824175,
                limb2: 122929110412205450,
                limb3: 0
            },
            u384 {
                limb0: 52806453983716513022545318079,
                limb1: 69394147900438600148709986176,
                limb2: 1059097841874136265,
                limb3: 0
            },
            u384 {
                limb0: 64919098044389771697189686960,
                limb1: 49709947946535787933782952169,
                limb2: 2316970353702107704,
                limb3: 0
            }
        ]
            .span();

        let log_div_b_den: Span<u384> = array![
            u384 {
                limb0: 33284631820784061601209716285,
                limb1: 74909083127844480788536082182,
                limb2: 671878480678009236,
                limb3: 0
            },
            u384 {
                limb0: 44844167694643577857231315651,
                limb1: 6657705289327963379468068188,
                limb2: 483141536571039728,
                limb3: 0
            },
            u384 {
                limb0: 35392693917830988380623340209,
                limb1: 33039689813208976084348677152,
                limb2: 2290277515286470798,
                limb3: 0
            },
            u384 {
                limb0: 76236704126680070464657036953,
                limb1: 20011919312715580846535499773,
                limb2: 1625633272058550811,
                limb3: 0
            },
            u384 {
                limb0: 28462980010160556092527025322,
                limb1: 27368980853969169741822569763,
                limb2: 820454272470516698,
                limb3: 0
            },
            u384 {
                limb0: 77193861551429763154225988651,
                limb1: 28981858341369669693974093771,
                limb2: 2751281296214683942,
                limb3: 0
            },
            u384 {
                limb0: 16477718064252151028071803271,
                limb1: 52212823863210503242987590063,
                limb2: 3376222138707704498,
                limb3: 0
            },
            u384 {
                limb0: 9759968469496453740635485369,
                limb1: 23234685153225415835212540078,
                limb2: 3179602911160127548,
                limb3: 0
            },
            u384 {
                limb0: 47921014619946634484315551373,
                limb1: 11241481142989006382248553109,
                limb2: 2093927154673692725,
                limb3: 0
            }
        ]
            .span();

        let (res_result) = run_EVAL_FUNCTION_CHALLENGE_DUPL_4_circuit(
            A0, A2, coeff0, coeff2, log_div_a_num, log_div_a_den, log_div_b_num, log_div_b_den, 0
        );
        let res: u384 = u384 {
            limb0: 41224817083161208159053381458,
            limb1: 1477753262266382275975380999,
            limb2: 183623896991182508,
            limb3: 0
        };
        assert_eq!(res_result, res);
    }


    #[test]
    fn test_run_FINALIZE_FUNCTION_CHALLENGE_DUPL_circuit_BLS12_381() {
        let f_a0_accs: FunctionFeltEvaluations = FunctionFeltEvaluations {
            a_num: u384 {
                limb0: 42271408514907683370518582092,
                limb1: 14396112118311311694672865421,
                limb2: 73021132189690225677253128861,
                limb3: 1048550636737098170061806412
            },
            a_den: u384 {
                limb0: 20303182462314789564649187944,
                limb1: 4977046164711247374833454931,
                limb2: 29284724587724128201714478486,
                limb3: 1478375517602823137596723108
            },
            b_num: u384 {
                limb0: 53564469164459051657762941437,
                limb1: 32576147524319959113051814711,
                limb2: 38808799870087519220815163588,
                limb3: 2616364045448869513294551625
            },
            b_den: u384 {
                limb0: 53208008738795411778691224452,
                limb1: 16508421892486818019881466929,
                limb2: 29073454590936142509934208962,
                limb3: 3136837029253294661723679724
            }
        };

        let f_a1_accs: FunctionFeltEvaluations = FunctionFeltEvaluations {
            a_num: u384 {
                limb0: 68208468221357365382743023196,
                limb1: 16113920624525914013554852373,
                limb2: 78015269508817691586389582412,
                limb3: 6441687755236137217566165141
            },
            a_den: u384 {
                limb0: 57956437528449004511724155667,
                limb1: 52836025426460305704757577324,
                limb2: 9190032983906381011009169118,
                limb3: 6288974341851372922204073724
            },
            b_num: u384 {
                limb0: 16959443513509557303687662045,
                limb1: 6782782958067228623161607648,
                limb2: 18652085059780072590525908281,
                limb3: 7665421399096715323414994435
            },
            b_den: u384 {
                limb0: 50514724484581989291399566572,
                limb1: 71277649175615385679950490834,
                limb2: 12386173778644937752477465303,
                limb3: 5157326700574666717676617699
            }
        };

        let yA0: u384 = u384 {
            limb0: 59575162492125636541485549440,
            limb1: 50799233065043704230843701664,
            limb2: 241741852192371553246115751,
            limb3: 4390031635852628168389271869
        };

        let yA2: u384 = u384 {
            limb0: 15649206260542250993424966033,
            limb1: 43033760513471438345556853487,
            limb2: 49782425448450166101884571353,
            limb3: 6798152211613935112448481331
        };

        let coeff_A0: u384 = u384 {
            limb0: 24162973061342599419346993478,
            limb1: 61309776783894135378589284391,
            limb2: 76602683038046597135468289049,
            limb3: 3467158119872887846242941153
        };

        let coeff_A2: u384 = u384 {
            limb0: 67432242477464238976461199936,
            limb1: 47112979755842005795579719056,
            limb2: 20921084387966758251738094780,
            limb3: 6460334415612278233574008456
        };

        let (res_result) = run_FINALIZE_FUNCTION_CHALLENGE_DUPL_circuit(
            f_a0_accs, f_a1_accs, yA0, yA2, coeff_A0, coeff_A2, 1
        );
        let res: u384 = u384 {
            limb0: 77731549246874363306461661032,
            limb1: 63679870086771379532368437702,
            limb2: 63028366636436485111043615542,
            limb3: 653251983679609111687188036
        };
        assert_eq!(res_result, res);
    }


    #[test]
    fn test_run_FINALIZE_FUNCTION_CHALLENGE_DUPL_circuit_BN254() {
        let f_a0_accs: FunctionFeltEvaluations = FunctionFeltEvaluations {
            a_num: u384 {
                limb0: 58280446892782192859377038916,
                limb1: 40953080295398762391344997717,
                limb2: 1773985397188630470,
                limb3: 0
            },
            a_den: u384 {
                limb0: 27249764037930567846218172537,
                limb1: 19011748802343590489610636458,
                limb2: 1410321390223264461,
                limb3: 0
            },
            b_num: u384 {
                limb0: 5731185999004768069004731831,
                limb1: 39241751224020400654597717087,
                limb2: 2020834351272407995,
                limb3: 0
            },
            b_den: u384 {
                limb0: 64095796044230917814179259865,
                limb1: 39105593325256618226441303393,
                limb2: 2029642705291974621,
                limb3: 0
            }
        };

        let f_a1_accs: FunctionFeltEvaluations = FunctionFeltEvaluations {
            a_num: u384 {
                limb0: 6455272549092671826509519312,
                limb1: 65463462261161940834466898863,
                limb2: 709257394876839757,
                limb3: 0
            },
            a_den: u384 {
                limb0: 38822865599411371039404195807,
                limb1: 66588022967208120556755172040,
                limb2: 1286642042344041850,
                limb3: 0
            },
            b_num: u384 {
                limb0: 47906885162578058538164730737,
                limb1: 50258883807440287578679063824,
                limb2: 1256897600197499811,
                limb3: 0
            },
            b_den: u384 {
                limb0: 9406778144477039479288656734,
                limb1: 56403056411038013192065792670,
                limb2: 795867129819795335,
                limb3: 0
            }
        };

        let yA0: u384 = u384 {
            limb0: 58781081570818241434142697606,
            limb1: 33931014974790147367144790947,
            limb2: 229525276486120494,
            limb3: 0
        };

        let yA2: u384 = u384 {
            limb0: 51117769816528266524923650677,
            limb1: 76942385322032925123146780840,
            limb2: 2604066695098047042,
            limb3: 0
        };

        let coeff_A0: u384 = u384 {
            limb0: 53469669196190738206678920457,
            limb1: 43309084602205469172728579506,
            limb2: 1301266048600613581,
            limb3: 0
        };

        let coeff_A2: u384 = u384 {
            limb0: 65901976594455383272796456465,
            limb1: 5132969593710279245653947797,
            limb2: 1418178523824501187,
            limb3: 0
        };

        let (res_result) = run_FINALIZE_FUNCTION_CHALLENGE_DUPL_circuit(
            f_a0_accs, f_a1_accs, yA0, yA2, coeff_A0, coeff_A2, 0
        );
        let res: u384 = u384 {
            limb0: 17148880327411391378206614289,
            limb1: 7362917175057308169844650417,
            limb2: 376579925199716583,
            limb3: 0
        };
        assert_eq!(res_result, res);
    }


    #[test]
    fn test_run_INIT_FUNCTION_CHALLENGE_DUPL_5_circuit_BLS12_381() {
        let xA0: u384 = u384 {
            limb0: 6210046568564226032541208774,
            limb1: 31366727136021378885085918549,
            limb2: 49925458758641884641919295920,
            limb3: 1441464553579516803637197434
        };

        let xA2: u384 = u384 {
            limb0: 56258951507108720113815726715,
            limb1: 24441917448919747271948601114,
            limb2: 44951314097778979520718801861,
            limb3: 4815015057564019798444854528
        };

        let log_div_a_num: Span<u384> = array![
            u384 {
                limb0: 48584540078443168847451735286,
                limb1: 54623667447823607479651605422,
                limb2: 52754475164594155363525584740,
                limb3: 2217121426499620907169003223
            },
            u384 {
                limb0: 3509646953493546455335968282,
                limb1: 28377025265953310667455869879,
                limb2: 67932517346257342899638093795,
                limb3: 2863972352210674288491767607
            },
            u384 {
                limb0: 61167003318164758015914710473,
                limb1: 67952024586398202530696823107,
                limb2: 34477046274830489121500992180,
                limb3: 4905186559274787093392101982
            },
            u384 {
                limb0: 65087853520896742076133370523,
                limb1: 57731661826547070798977776087,
                limb2: 37457283337925852102721294449,
                limb3: 1528405518152763465799825455
            },
            u384 {
                limb0: 6344455894065058999421513308,
                limb1: 76408511067119718759827293380,
                limb2: 36078869033374480975867845999,
                limb3: 7063006732685810807796313783
            },
            u384 {
                limb0: 73642699226173251177232726966,
                limb1: 153093432215530225840134318,
                limb2: 39065217515938826988366952780,
                limb3: 2883871503658441656059568580
            }
        ]
            .span();

        let log_div_a_den: Span<u384> = array![
            u384 {
                limb0: 54199747261734630097113781797,
                limb1: 74175391682687870333370896162,
                limb2: 5538750469960644257132186369,
                limb3: 2085254727890494248865792175
            },
            u384 {
                limb0: 77735393985802253590713426664,
                limb1: 27867213086285639966374638160,
                limb2: 11466720957048582816848528487,
                limb3: 4770536589068349725772393272
            },
            u384 {
                limb0: 5099497905033299758211782831,
                limb1: 44797628104370347625472444756,
                limb2: 10731180887662674351963878969,
                limb3: 5204813563846424413575540003
            },
            u384 {
                limb0: 6424415750015539551999299858,
                limb1: 336314705731102706893713482,
                limb2: 46300711495617005168594687082,
                limb3: 6668929189443698681991140452
            },
            u384 {
                limb0: 71355009610885168679324013008,
                limb1: 23909838630567568388570160712,
                limb2: 55578836447830561028228089345,
                limb3: 459213579616700199633725942
            },
            u384 {
                limb0: 61040362146433004083819844141,
                limb1: 7257754017407416582674802251,
                limb2: 29743740455198348944654581816,
                limb3: 2078538771761084077370041928
            },
            u384 {
                limb0: 60375912085372234586006975480,
                limb1: 12563630257594957592161588716,
                limb2: 17195688857120241604535604023,
                limb3: 2167950011965939442205082499
            }
        ]
            .span();

        let log_div_b_num: Span<u384> = array![
            u384 {
                limb0: 52144287777238114509798836599,
                limb1: 63510619300248595428902552392,
                limb2: 26296018614694695603906408174,
                limb3: 711809303195370418743417193
            },
            u384 {
                limb0: 52211325999951158962226509102,
                limb1: 71072897838146636591452903567,
                limb2: 18093036843645968723774375556,
                limb3: 3977076293236353785977746202
            },
            u384 {
                limb0: 20926956347428121717371229307,
                limb1: 39167973702580879200974338043,
                limb2: 73931421140987771804125842665,
                limb3: 1484058777916331965415752268
            },
            u384 {
                limb0: 57445862264436883147005423381,
                limb1: 41390949042004739784811118143,
                limb2: 77644488020290889109489418623,
                limb3: 5290117841942491865296992395
            },
            u384 {
                limb0: 69513087544810953073841529100,
                limb1: 62162880911692143874423856153,
                limb2: 40785395577884217937351308794,
                limb3: 5185859564447180790525020311
            },
            u384 {
                limb0: 14682042323034463933939933721,
                limb1: 8017626049779495126315098747,
                limb2: 69458594678563595559297832057,
                limb3: 2518095019042531763189647466
            },
            u384 {
                limb0: 24985860576774460604370372961,
                limb1: 1340834478975055899509824165,
                limb2: 2625504717648492795833838351,
                limb3: 7868451162675615375146853142
            }
        ]
            .span();

        let log_div_b_den: Span<u384> = array![
            u384 {
                limb0: 8878201068795142160987708636,
                limb1: 64601439170827553953848125390,
                limb2: 76926423991386813855122803354,
                limb3: 2819829916792690773213149690
            },
            u384 {
                limb0: 4564921427879793319223494995,
                limb1: 8448234367804894448472819878,
                limb2: 20982351743978657551564628278,
                limb3: 7636029264776670039065027691
            },
            u384 {
                limb0: 77327534125681170775259418623,
                limb1: 58799396636027713162390332626,
                limb2: 10695659750691371741041111241,
                limb3: 3667300216936875257472481775
            },
            u384 {
                limb0: 22169091740652787885613017918,
                limb1: 561305495775730961846808566,
                limb2: 26577495029113835893127935971,
                limb3: 749893059359583788881600801
            },
            u384 {
                limb0: 42300368557468181639453904579,
                limb1: 12816291217720245058877262811,
                limb2: 49001010808670926191958200438,
                limb3: 5479236131009814999137589659
            },
            u384 {
                limb0: 75780736278525312131732800705,
                limb1: 60341850856133427522636637635,
                limb2: 4635370242855441537546401758,
                limb3: 2131534916452135004432463825
            },
            u384 {
                limb0: 71312498493826879170995335379,
                limb1: 1949919922263504932659085206,
                limb2: 33593943677901085986550411528,
                limb3: 6408742349028922710301753127
            },
            u384 {
                limb0: 30725170511976440801341992659,
                limb1: 70158530836372615678944532181,
                limb2: 64936192179739830216981969791,
                limb3: 1875632686408204864460826024
            },
            u384 {
                limb0: 5416441650074344389735515789,
                limb1: 66436954800048167066356196460,
                limb2: 15318443593956385032213790664,
                limb3: 8003705200892113318032210576
            },
            u384 {
                limb0: 29925452837584511339814435065,
                limb1: 71781451021120638292092266438,
                limb2: 62304929999554921948177070664,
                limb3: 6122962266117534665966812562
            }
        ]
            .span();

        let (A0_evals_result, A2_evals_result, xA0_power_result, xA2_power_result) =
            run_INIT_FUNCTION_CHALLENGE_DUPL_5_circuit(
            xA0, xA2, log_div_a_num, log_div_a_den, log_div_b_num, log_div_b_den, 1
        );
        let A0_evals: FunctionFeltEvaluations = FunctionFeltEvaluations {
            a_num: u384 {
                limb0: 64902187493294033540768325715,
                limb1: 15950601108647667513772229416,
                limb2: 57582136022964311648992012000,
                limb3: 7375733385644613798201618293
            },
            a_den: u384 {
                limb0: 34299130683631952299852156585,
                limb1: 40894805946249410471625316459,
                limb2: 72085593839231940090594501666,
                limb3: 2844432858194609384226692458
            },
            b_num: u384 {
                limb0: 30965429968535519044995426836,
                limb1: 71191706862005207051662581366,
                limb2: 68079069706087038979064394209,
                limb3: 6973004489314339681238199594
            },
            b_den: u384 {
                limb0: 11819077986061901816222206247,
                limb1: 675335603754996456902551061,
                limb2: 60520652336668462467378697703,
                limb3: 5891773308810639172940317845
            }
        };

        let A2_evals: FunctionFeltEvaluations = FunctionFeltEvaluations {
            a_num: u384 {
                limb0: 27682765710887954439632305488,
                limb1: 45003753610584698958149877541,
                limb2: 57271656978382498394085898860,
                limb3: 5904333526878782933283361578
            },
            a_den: u384 {
                limb0: 55368691062503216513365937705,
                limb1: 45151857154300304305285509271,
                limb2: 72526468335663814700554045707,
                limb3: 7519291077826291285011034943
            },
            b_num: u384 {
                limb0: 48199038388326707756835222963,
                limb1: 47016055677800560635405192190,
                limb2: 10697647853687460502626282948,
                limb3: 6474945206711153780479066282
            },
            b_den: u384 {
                limb0: 77562492683072098261096568722,
                limb1: 28573949915445840183324952506,
                limb2: 13031065762642707134833732938,
                limb3: 1241827870533733864750134498
            }
        };

        let xA0_power: u384 = u384 {
            limb0: 10463696390670101974292313964,
            limb1: 30429263133734304747496569650,
            limb2: 30097597178977969005762279654,
            limb3: 210814577139448243452821427
        };

        let xA2_power: u384 = u384 {
            limb0: 7591104035111200908915915917,
            limb1: 37048947165078362429020124923,
            limb2: 73856301685358249969714604322,
            limb3: 6525251288239246219286750560
        };
        assert_eq!(A0_evals_result, A0_evals);
        assert_eq!(A2_evals_result, A2_evals);
        assert_eq!(xA0_power_result, xA0_power);
        assert_eq!(xA2_power_result, xA2_power);
    }


    #[test]
    fn test_run_INIT_FUNCTION_CHALLENGE_DUPL_5_circuit_BN254() {
        let xA0: u384 = u384 {
            limb0: 27290109391410081994834815136,
            limb1: 20458204772210031427067932888,
            limb2: 128833153829831623,
            limb3: 0
        };

        let xA2: u384 = u384 {
            limb0: 28699599091218773155358035566,
            limb1: 76130904368364903419070344253,
            limb2: 1366657658541174289,
            limb3: 0
        };

        let log_div_a_num: Span<u384> = array![
            u384 {
                limb0: 75912296863312730401649691488,
                limb1: 25906352713099587006356180921,
                limb2: 2734819241107495919,
                limb3: 0
            },
            u384 {
                limb0: 8127259587956589804165142205,
                limb1: 24383457645184196255582101314,
                limb2: 1736709905580689390,
                limb3: 0
            },
            u384 {
                limb0: 74924361437787663200903105702,
                limb1: 17653415259453100103746680659,
                limb2: 2344269640586117778,
                limb3: 0
            },
            u384 {
                limb0: 59806045210262725526458903870,
                limb1: 29509473950301411060749892432,
                limb2: 3058449503229513201,
                limb3: 0
            },
            u384 {
                limb0: 10476641705282468463695587695,
                limb1: 31200143367046477848573954088,
                limb2: 3238185370473636732,
                limb3: 0
            },
            u384 {
                limb0: 33449238538863374300517019804,
                limb1: 28091463497917425999984431614,
                limb2: 1143967936971895084,
                limb3: 0
            }
        ]
            .span();

        let log_div_a_den: Span<u384> = array![
            u384 {
                limb0: 29255477601507623507580626137,
                limb1: 41928122072257155865494509888,
                limb2: 1735985052116826459,
                limb3: 0
            },
            u384 {
                limb0: 33056007753616374312162015845,
                limb1: 71405358686088291453851846899,
                limb2: 2035124994221506231,
                limb3: 0
            },
            u384 {
                limb0: 23238543001322742099746534628,
                limb1: 7214238052564246677276106122,
                limb2: 855274996560611601,
                limb3: 0
            },
            u384 {
                limb0: 21943843819857678654134323775,
                limb1: 47976285835987914057491836775,
                limb2: 709640853520246060,
                limb3: 0
            },
            u384 {
                limb0: 35348783784662968277035659241,
                limb1: 14687371388926487293352672332,
                limb2: 1944767865010002573,
                limb3: 0
            },
            u384 {
                limb0: 19645230072419461733827279082,
                limb1: 26968307988203981880869251219,
                limb2: 2413519660120413979,
                limb3: 0
            },
            u384 {
                limb0: 36637903275957912864540282263,
                limb1: 6853188419381636462799427520,
                limb2: 3481984702531289841,
                limb3: 0
            }
        ]
            .span();

        let log_div_b_num: Span<u384> = array![
            u384 {
                limb0: 146030076227949400334384815,
                limb1: 35580446869557986432712590466,
                limb2: 2130648967995028332,
                limb3: 0
            },
            u384 {
                limb0: 23654370222835508320059369112,
                limb1: 77548724462177553720355393920,
                limb2: 1388850589227609364,
                limb3: 0
            },
            u384 {
                limb0: 12377111439852444926837178951,
                limb1: 59528278038927077385096984381,
                limb2: 426825584089232782,
                limb3: 0
            },
            u384 {
                limb0: 60220520864918782001528250178,
                limb1: 43079585957269161858761144926,
                limb2: 1869139898994399990,
                limb3: 0
            },
            u384 {
                limb0: 77961711457252601247294545729,
                limb1: 21397815731389161869616404765,
                limb2: 3082859848769689614,
                limb3: 0
            },
            u384 {
                limb0: 20328030822406169353743584227,
                limb1: 70557575839523426311564389084,
                limb2: 3274134364868627524,
                limb3: 0
            },
            u384 {
                limb0: 72000520137764837462644246783,
                limb1: 6754932813977657815572878489,
                limb2: 324919404285612167,
                limb3: 0
            }
        ]
            .span();

        let log_div_b_den: Span<u384> = array![
            u384 {
                limb0: 41185501208956454960575889511,
                limb1: 41441081333085364229295923751,
                limb2: 969737703267252736,
                limb3: 0
            },
            u384 {
                limb0: 32547285568714278926809579196,
                limb1: 43066301929325963142500830262,
                limb2: 3419228804722594027,
                limb3: 0
            },
            u384 {
                limb0: 62445849303983111602915185101,
                limb1: 35047735588588409803790043474,
                limb2: 2620511921441247591,
                limb3: 0
            },
            u384 {
                limb0: 12444365308571306300689465460,
                limb1: 9548407978382876998078855381,
                limb2: 1850284698872659933,
                limb3: 0
            },
            u384 {
                limb0: 11054951090793082353328578268,
                limb1: 23686152292513057062841929406,
                limb2: 2915099647978735914,
                limb3: 0
            },
            u384 {
                limb0: 32888196795532285724015500385,
                limb1: 38731333929415952739291070501,
                limb2: 2313070265335517856,
                limb3: 0
            },
            u384 {
                limb0: 51661077824120714546854244402,
                limb1: 35175858496736535724116618844,
                limb2: 658601457667862308,
                limb3: 0
            },
            u384 {
                limb0: 4152021204302326432509857790,
                limb1: 17090619335270315747726354131,
                limb2: 1638999484934011960,
                limb3: 0
            },
            u384 {
                limb0: 508918245973802653761934510,
                limb1: 9202518011885788722949307490,
                limb2: 17249403076200518,
                limb3: 0
            },
            u384 {
                limb0: 59548990623035107422698481953,
                limb1: 15148768562330170180113945047,
                limb2: 2001558943410647470,
                limb3: 0
            }
        ]
            .span();

        let (A0_evals_result, A2_evals_result, xA0_power_result, xA2_power_result) =
            run_INIT_FUNCTION_CHALLENGE_DUPL_5_circuit(
            xA0, xA2, log_div_a_num, log_div_a_den, log_div_b_num, log_div_b_den, 0
        );
        let A0_evals: FunctionFeltEvaluations = FunctionFeltEvaluations {
            a_num: u384 {
                limb0: 74037956619719218159549545727,
                limb1: 8499628927385777706825871287,
                limb2: 324981415238014309,
                limb3: 0
            },
            a_den: u384 {
                limb0: 15380202336538040303009249000,
                limb1: 51992279251305427622342876813,
                limb2: 2254836442867049731,
                limb3: 0
            },
            b_num: u384 {
                limb0: 50405096265545450426112274787,
                limb1: 16751363170559432961445271799,
                limb2: 2515413418878441317,
                limb3: 0
            },
            b_den: u384 {
                limb0: 1035602185887654477767517454,
                limb1: 17350564691950392823542201248,
                limb2: 695180571329552589,
                limb3: 0
            }
        };

        let A2_evals: FunctionFeltEvaluations = FunctionFeltEvaluations {
            a_num: u384 {
                limb0: 27984242891080319737422820064,
                limb1: 70459093132793228698553141495,
                limb2: 2729857507380205981,
                limb3: 0
            },
            a_den: u384 {
                limb0: 74341429909358964645477719435,
                limb1: 42118907297821551193759978990,
                limb2: 2882409449471177801,
                limb3: 0
            },
            b_num: u384 {
                limb0: 8419389438224182868896304556,
                limb1: 26813412074092926457112676932,
                limb2: 2532246290770814272,
                limb3: 0
            },
            b_den: u384 {
                limb0: 71758308160409097247063747887,
                limb1: 22434174062286101109838048002,
                limb2: 3382667580317365356,
                limb3: 0
            }
        };

        let xA0_power: u384 = u384 {
            limb0: 35843924950317277134702964905,
            limb1: 39347112850905874100238885252,
            limb2: 918821032765845819,
            limb3: 0
        };

        let xA2_power: u384 = u384 {
            limb0: 74702301996156906931342402798,
            limb1: 19137614285120830185895774782,
            limb2: 2360770325090495545,
            limb3: 0
        };
        assert_eq!(A0_evals_result, A0_evals);
        assert_eq!(A2_evals_result, A2_evals);
        assert_eq!(xA0_power_result, xA0_power);
        assert_eq!(xA2_power_result, xA2_power);
    }


    #[test]
    fn test_run_IS_ON_CURVE_G1_G2_circuit_BLS12_381() {
        let p: G1Point = G1Point {
            x: u384 {
                limb0: 46706571765956834237956044675,
                limb1: 21071548932965993517679544958,
                limb2: 63088171608313565047035281560,
                limb3: 583501615451560598771570574
            },
            y: u384 {
                limb0: 31535595461224325559383171522,
                limb1: 19779723463599699491052634388,
                limb2: 67706574956172288067559165016,
                limb3: 879075777356640452634108283
            }
        };

        let q: G2Point = G2Point {
            x0: u384 {
                limb0: 47837949294783728318374736614,
                limb1: 58261748940919076050102374728,
                limb2: 39232996742252933316448149762,
                limb3: 2314525803145132837087697143
            },
            x1: u384 {
                limb0: 47676155659479947194844013071,
                limb1: 36346678414599632621205670133,
                limb2: 7037347297487389790110409195,
                limb3: 311353638324422075418771830
            },
            y0: u384 {
                limb0: 63901942634575512646468896532,
                limb1: 18887555207295220095855463067,
                limb2: 24801194390196266031126834343,
                limb3: 1983292358201868009950242958
            },
            y1: u384 {
                limb0: 66496766513552587160552112528,
                limb1: 3008376668367883050557359700,
                limb2: 66116940471546115968881653930,
                limb3: 7411712140303150979112406458
            }
        };

        let a: u384 = u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };

        let b: u384 = u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 };

        let b20: u384 = u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 };

        let b21: u384 = u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 };

        let (zero_check_0_result, zero_check_1_result, zero_check_2_result) =
            run_IS_ON_CURVE_G1_G2_circuit(
            p, q, a, b, b20, b21, 1
        );
        let zero_check_0: u384 = u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };

        let zero_check_1: u384 = u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };

        let zero_check_2: u384 = u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };
        assert_eq!(zero_check_0_result, zero_check_0);
        assert_eq!(zero_check_1_result, zero_check_1);
        assert_eq!(zero_check_2_result, zero_check_2);
    }


    #[test]
    fn test_run_IS_ON_CURVE_G1_G2_circuit_BN254() {
        let p: G1Point = G1Point {
            x: u384 {
                limb0: 28610756795125421341789836686,
                limb1: 867082125726060679479563787,
                limb2: 517675042607557601,
                limb3: 0
            },
            y: u384 {
                limb0: 36882700424042850430562664053,
                limb1: 63811137145513906528257638731,
                limb2: 2919654018211177231,
                limb3: 0
            }
        };

        let q: G2Point = G2Point {
            x0: u384 {
                limb0: 3153729208240962009983500478,
                limb1: 40550523289894208045731503372,
                limb2: 1084946966667758900,
                limb3: 0
            },
            x1: u384 {
                limb0: 68880333305383555718983970599,
                limb1: 67893486303700750840295828244,
                limb2: 105039074904354629,
                limb3: 0
            },
            y0: u384 {
                limb0: 24042802651694448496166439628,
                limb1: 16645378487191828916630937066,
                limb2: 757214260369138307,
                limb3: 0
            },
            y1: u384 {
                limb0: 73170982836049039157350892353,
                limb1: 7425931233989092027273176614,
                limb2: 81769889353580197,
                limb3: 0
            }
        };

        let a: u384 = u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };

        let b: u384 = u384 { limb0: 3, limb1: 0, limb2: 0, limb3: 0 };

        let b20: u384 = u384 {
            limb0: 27810052284636130223308486885,
            limb1: 40153378333836448380344387045,
            limb2: 3104278944836790958,
            limb3: 0
        };

        let b21: u384 = u384 {
            limb0: 70926583776874220189091304914,
            limb1: 63498449372070794915149226116,
            limb2: 42524369107353300,
            limb3: 0
        };

        let (zero_check_0_result, zero_check_1_result, zero_check_2_result) =
            run_IS_ON_CURVE_G1_G2_circuit(
            p, q, a, b, b20, b21, 0
        );
        let zero_check_0: u384 = u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };

        let zero_check_1: u384 = u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };

        let zero_check_2: u384 = u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };
        assert_eq!(zero_check_0_result, zero_check_0);
        assert_eq!(zero_check_1_result, zero_check_1);
        assert_eq!(zero_check_2_result, zero_check_2);
    }


    #[test]
    fn test_run_IS_ON_CURVE_G1_circuit_BLS12_381() {
        let p: G1Point = G1Point {
            x: u384 {
                limb0: 17564266934605299855822610573,
                limb1: 50198698710541599701136206773,
                limb2: 34036089961288892525655927724,
                limb3: 4442424905039454268724687265
            },
            y: u384 {
                limb0: 12040449229476942965584002276,
                limb1: 51377377766659944516165422963,
                limb2: 53515021902729268805145735579,
                limb3: 356850841752104041781197947
            }
        };

        let a: u384 = u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };

        let b: u384 = u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 };

        let (zero_check_result) = run_IS_ON_CURVE_G1_circuit(p, a, b, 1);
        let zero_check: u384 = u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };
        assert_eq!(zero_check_result, zero_check);
    }


    #[test]
    fn test_run_IS_ON_CURVE_G1_circuit_BN254() {
        let p: G1Point = G1Point {
            x: u384 {
                limb0: 10963338319382868633705196911,
                limb1: 47121869529842916575828973009,
                limb2: 546547428558054340,
                limb3: 0
            },
            y: u384 {
                limb0: 61794659804043923952658021753,
                limb1: 71835376005474770439080422094,
                limb2: 3287615896151516919,
                limb3: 0
            }
        };

        let a: u384 = u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };

        let b: u384 = u384 { limb0: 3, limb1: 0, limb2: 0, limb3: 0 };

        let (zero_check_result) = run_IS_ON_CURVE_G1_circuit(p, a, b, 0);
        let zero_check: u384 = u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };
        assert_eq!(zero_check_result, zero_check);
    }


    #[test]
    fn test_run_IS_ON_CURVE_G2_circuit_BLS12_381() {
        let p: G2Point = G2Point {
            x0: u384 {
                limb0: 64881592413091416687078558238,
                limb1: 19518258141337761496482490367,
                limb2: 33231141266022101244155856946,
                limb3: 4625146693117872657470299757
            },
            x1: u384 {
                limb0: 35579312178133858856861960446,
                limb1: 27884491798851879092994773017,
                limb2: 44305637564309654505023120892,
                limb3: 4066475203517568804151101476
            },
            y0: u384 {
                limb0: 32810783144623114968661508608,
                limb1: 13797236876990102053773715180,
                limb2: 6716940154599378287763740748,
                limb3: 1821033457768109755618432202
            },
            y1: u384 {
                limb0: 17823320023165485199857944615,
                limb1: 72240172101096947300324564285,
                limb2: 75259141057546570123969821663,
                limb3: 295351730220377715821559634
            }
        };

        let a: u384 = u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };

        let b20: u384 = u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 };

        let b21: u384 = u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 };

        let (zero_check_0_result, zero_check_1_result) = run_IS_ON_CURVE_G2_circuit(
            p, a, b20, b21, 1
        );
        let zero_check_0: u384 = u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };

        let zero_check_1: u384 = u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };
        assert_eq!(zero_check_0_result, zero_check_0);
        assert_eq!(zero_check_1_result, zero_check_1);
    }


    #[test]
    fn test_run_IS_ON_CURVE_G2_circuit_BN254() {
        let p: G2Point = G2Point {
            x0: u384 {
                limb0: 20327502423815408938443636277,
                limb1: 34883481233784974488228836322,
                limb2: 2208072115582449063,
                limb3: 0
            },
            x1: u384 {
                limb0: 21646904630757137888313408794,
                limb1: 68601244667221384891181276448,
                limb2: 511797177109400272,
                limb3: 0
            },
            y0: u384 {
                limb0: 19840162471593555304970554708,
                limb1: 16766632680317987843754811088,
                limb2: 54467295440720537,
                limb3: 0
            },
            y1: u384 {
                limb0: 58101386057589905723335529491,
                limb1: 11726529671901099747471822727,
                limb2: 1842652047096844660,
                limb3: 0
            }
        };

        let a: u384 = u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };

        let b20: u384 = u384 {
            limb0: 27810052284636130223308486885,
            limb1: 40153378333836448380344387045,
            limb2: 3104278944836790958,
            limb3: 0
        };

        let b21: u384 = u384 {
            limb0: 70926583776874220189091304914,
            limb1: 63498449372070794915149226116,
            limb2: 42524369107353300,
            limb3: 0
        };

        let (zero_check_0_result, zero_check_1_result) = run_IS_ON_CURVE_G2_circuit(
            p, a, b20, b21, 0
        );
        let zero_check_0: u384 = u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };

        let zero_check_1: u384 = u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };
        assert_eq!(zero_check_0_result, zero_check_0);
        assert_eq!(zero_check_1_result, zero_check_1);
    }


    #[test]
    fn test_run_RHS_FINALIZE_ACC_circuit_BLS12_381() {
        let acc: u384 = u384 {
            limb0: 38157741182005799900184837164,
            limb1: 21034546365543617462479199525,
            limb2: 3746049627734751290374905709,
            limb3: 2357835886399510165326018053
        };

        let m: u384 = u384 {
            limb0: 11356374310780364945260251406,
            limb1: 62112023593808780121452856136,
            limb2: 53066015316882389699382175946,
            limb3: 5924233522996958176877005726
        };

        let b: u384 = u384 {
            limb0: 25796207199530035643538332337,
            limb1: 29320810034753438950605948659,
            limb2: 20971016232154145511367662385,
            limb3: 4943994934408967740434654438
        };

        let xA: u384 = u384 {
            limb0: 38063656504223713435982820696,
            limb1: 73014951734193334839374496489,
            limb2: 9567661219474734034161053420,
            limb3: 4407538340680793600617351221
        };

        let Q_result: G1Point = G1Point {
            x: u384 {
                limb0: 10775465580624724323789472813,
                limb1: 9239986989238181577480993255,
                limb2: 15242563262099350368507780854,
                limb3: 6940664962368958791336705021
            },
            y: u384 {
                limb0: 71031002811457601953299610671,
                limb1: 44393936195669730347789712107,
                limb2: 57883879237603655085150977346,
                limb3: 5794097063921577531414081325
            }
        };

        let (rhs_result) = run_RHS_FINALIZE_ACC_circuit(acc, m, b, xA, Q_result, 1);
        let rhs: u384 = u384 {
            limb0: 53470620556289164236164964190,
            limb1: 25578890405596373910077891605,
            limb2: 24215474126731079757985420055,
            limb3: 774186665953038054567838611
        };
        assert_eq!(rhs_result, rhs);
    }


    #[test]
    fn test_run_RHS_FINALIZE_ACC_circuit_BN254() {
        let acc: u384 = u384 {
            limb0: 47789288982153625936211091314,
            limb1: 22790556483673439019797530023,
            limb2: 422578445435456773,
            limb3: 0
        };

        let m: u384 = u384 {
            limb0: 63564193557056427700519061379,
            limb1: 3859985502446194295734397458,
            limb2: 1682330943181674747,
            limb3: 0
        };

        let b: u384 = u384 {
            limb0: 21880591190601213304220125238,
            limb1: 18347763852893937204971538731,
            limb2: 147454637293368614,
            limb3: 0
        };

        let xA: u384 = u384 {
            limb0: 38981705189576391036754545370,
            limb1: 38200451437623260512273298100,
            limb2: 285869279439476269,
            limb3: 0
        };

        let Q_result: G1Point = G1Point {
            x: u384 {
                limb0: 25400260734572114057948715438,
                limb1: 13567092499965229133149434143,
                limb2: 2351498053255379660,
                limb3: 0
            },
            y: u384 {
                limb0: 64112886788031393132256331831,
                limb1: 68767686677431571826198867926,
                limb2: 1330063957552371479,
                limb3: 0
            }
        };

        let (rhs_result) = run_RHS_FINALIZE_ACC_circuit(acc, m, b, xA, Q_result, 0);
        let rhs: u384 = u384 {
            limb0: 37824128036192435284787862216,
            limb1: 60273805252635637930144321149,
            limb2: 106993060423381348,
            limb3: 0
        };
        assert_eq!(rhs_result, rhs);
    }


    #[test]
    fn test_run_SLOPE_INTERCEPT_SAME_POINT_circuit_BLS12_381() {
        let p: G1Point = G1Point {
            x: u384 {
                limb0: 57303175307189037764297937708,
                limb1: 73106508321698251017485664038,
                limb2: 36793121413931487827180057784,
                limb3: 3266939425752615898574298090
            },
            y: u384 {
                limb0: 18613945139075541652920345123,
                limb1: 56611515683690161296536335302,
                limb2: 21283575734373330014634889317,
                limb3: 1412229885350243271775825786
            }
        };

        let a: u384 = u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };

        let (mb_result) = run_SLOPE_INTERCEPT_SAME_POINT_circuit(p, a, 1);
        let mb: SlopeInterceptOutput = SlopeInterceptOutput {
            m_A0: u384 {
                limb0: 65846997732454955595092043312,
                limb1: 26627465443229855016669492136,
                limb2: 28463554513647268440466197168,
                limb3: 69976150926958678245773216
            },
            b_A0: u384 {
                limb0: 46964243900178343949541445657,
                limb1: 65963591892046693499592648615,
                limb2: 51374162385112757859785454485,
                limb3: 6308467601376506530696934513
            },
            x_A2: u384 {
                limb0: 44507506887630250661091339020,
                limb1: 55857783702891349760407812186,
                limb2: 26520296244536592498519178701,
                limb3: 7439232549821460768853231880
            },
            y_A2: u384 {
                limb0: 40196357241977364833183346030,
                limb1: 63482662936138720048287710924,
                limb2: 50364001971291799943175786443,
                limb3: 7339735993563594467193642894
            },
            coeff0: u384 {
                limb0: 5387063649868152077233064558,
                limb1: 74258815117388337125885546656,
                limb2: 23193107587430871020743357538,
                limb3: 5601919292082981525840403753
            },
            coeff2: u384 {
                limb0: 32149393213486916074136878606,
                limb1: 21003884230928627092546562382,
                limb2: 45494161074400671733354913538,
                limb3: 5461966990229064169348857320
            }
        };
        assert_eq!(mb_result, mb);
    }


    #[test]
    fn test_run_SLOPE_INTERCEPT_SAME_POINT_circuit_BN254() {
        let p: G1Point = G1Point {
            x: u384 {
                limb0: 1785535559409110691393306617,
                limb1: 7597092814299530264289532476,
                limb2: 878181267796675057,
                limb3: 0
            },
            y: u384 {
                limb0: 48727289524028805321369454187,
                limb1: 78638986380330519667851975673,
                limb2: 1484979689236301097,
                limb3: 0
            }
        };

        let a: u384 = u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };

        let (mb_result) = run_SLOPE_INTERCEPT_SAME_POINT_circuit(p, a, 0);
        let mb: SlopeInterceptOutput = SlopeInterceptOutput {
            m_A0: u384 {
                limb0: 76540976842320287450430347706,
                limb1: 60923805408749182380655088218,
                limb2: 3075486977755850459,
                limb3: 0
            },
            b_A0: u384 {
                limb0: 73189073861277227804485911093,
                limb1: 37842561589438245231792258147,
                limb2: 3419555488085548717,
                limb3: 0
            },
            x_A2: u384 {
                limb0: 59926939870950637113741528741,
                limb1: 17069599079331594437118205800,
                limb2: 502224407897912239,
                limb3: 0
            },
            y_A2: u384 {
                limb0: 25758561730493458002295481710,
                limb1: 28566268529224859488705341933,
                limb2: 2741209599044821711,
                limb3: 0
            },
            coeff0: u384 {
                limb0: 42583975492174175219962759506,
                limb1: 51578617680329020921599326557,
                limb2: 3069107625101629141,
                limb3: 0
            },
            coeff2: u384 {
                limb0: 1054190484187349089424642853,
                limb1: 66001454459718233215712870201,
                limb2: 405131936392898887,
                limb3: 0
            }
        };
        assert_eq!(mb_result, mb);
    }
}
