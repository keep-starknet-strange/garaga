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
    BNProcessedPair, BLSProcessedPair, MillerLoopResultScalingFactor, G2Line
};
use garaga::ec_ops::{SlopeInterceptOutput, FunctionFeltEvaluations, FunctionFelt};
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
    SumDlogDiv: FunctionFelt,
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
    let mut SumDlogDiv_a_num = SumDlogDiv.a_num;
    while let Option::Some(val) = SumDlogDiv_a_num.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };
    let mut SumDlogDiv_a_den = SumDlogDiv.a_den;
    while let Option::Some(val) = SumDlogDiv_a_den.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };
    let mut SumDlogDiv_b_num = SumDlogDiv.b_num;
    while let Option::Some(val) = SumDlogDiv_b_num.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };
    let mut SumDlogDiv_b_den = SumDlogDiv.b_den;
    while let Option::Some(val) = SumDlogDiv_b_den.pop_front() {
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
    SumDlogDiv: FunctionFelt,
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
    let mut SumDlogDiv_a_num = SumDlogDiv.a_num;
    while let Option::Some(val) = SumDlogDiv_a_num.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };
    let mut SumDlogDiv_a_den = SumDlogDiv.a_den;
    while let Option::Some(val) = SumDlogDiv_a_den.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };
    let mut SumDlogDiv_b_num = SumDlogDiv.b_num;
    while let Option::Some(val) = SumDlogDiv_b_num.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };
    let mut SumDlogDiv_b_den = SumDlogDiv.b_den;
    while let Option::Some(val) = SumDlogDiv_b_den.pop_front() {
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
    SumDlogDiv: FunctionFelt,
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
    let mut SumDlogDiv_a_num = SumDlogDiv.a_num;
    while let Option::Some(val) = SumDlogDiv_a_num.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };
    let mut SumDlogDiv_a_den = SumDlogDiv.a_den;
    while let Option::Some(val) = SumDlogDiv_a_den.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };
    let mut SumDlogDiv_b_num = SumDlogDiv.b_num;
    while let Option::Some(val) = SumDlogDiv_b_num.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };
    let mut SumDlogDiv_b_den = SumDlogDiv.b_den;
    while let Option::Some(val) = SumDlogDiv_b_den.pop_front() {
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
    SumDlogDiv: FunctionFelt,
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
    let mut SumDlogDiv_a_num = SumDlogDiv.a_num;
    while let Option::Some(val) = SumDlogDiv_a_num.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };
    let mut SumDlogDiv_a_den = SumDlogDiv.a_den;
    while let Option::Some(val) = SumDlogDiv_a_den.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };
    let mut SumDlogDiv_b_num = SumDlogDiv.b_num;
    while let Option::Some(val) = SumDlogDiv_b_num.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };
    let mut SumDlogDiv_b_den = SumDlogDiv.b_den;
    while let Option::Some(val) = SumDlogDiv_b_den.pop_front() {
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
    xA0: u384, xA2: u384, SumDlogDiv: FunctionFelt, curve_index: usize
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
    let mut SumDlogDiv_a_num = SumDlogDiv.a_num;
    while let Option::Some(val) = SumDlogDiv_a_num.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };
    let mut SumDlogDiv_a_den = SumDlogDiv.a_den;
    while let Option::Some(val) = SumDlogDiv_a_den.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };
    let mut SumDlogDiv_b_num = SumDlogDiv.b_num;
    while let Option::Some(val) = SumDlogDiv_b_num.pop_front() {
        circuit_inputs = circuit_inputs.next(*val);
    };
    let mut SumDlogDiv_b_den = SumDlogDiv.b_den;
    while let Option::Some(val) = SumDlogDiv_b_den.pop_front() {
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
        MillerLoopResultScalingFactor, G2Line
    };
    use garaga::ec_ops::{SlopeInterceptOutput, FunctionFeltEvaluations, FunctionFelt};

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
            limb0: 0x4b10b8e0210d8698368f215b,
            limb1: 0xf23d695213122a21662cd63,
            limb2: 0xce131dceecec05154b635d8,
            limb3: 0x222d104a76d4b32212178c7
        };

        let m: u384 = u384 {
            limb0: 0x5e66a1f84959a5c26cbbb7e,
            limb1: 0xb29f0db62e86298f35f37fcc,
            limb2: 0x8862026a7d4214256e9178d3,
            limb3: 0x141e72db29a65cc3d378ca6a
        };

        let b: u384 = u384 {
            limb0: 0x586657de166b0371ff6232,
            limb1: 0x6bbbc6376c513d9fd31b4117,
            limb2: 0xebfe04321ce6118bf9cb8fbd,
            limb3: 0x18abf89978be151e611ad179
        };

        let xA: u384 = u384 {
            limb0: 0xd7ab053d4ebfe16717fe1dbe,
            limb1: 0x8ffc8a62b4a887ead72093d0,
            limb2: 0x611989e068b5390b8e5df11c,
            limb3: 0xb6c5d0922b2f19d9c468dff
        };

        let p: G1Point = G1Point {
            x: u384 {
                limb0: 0xbdcea6023cc83026e5b8d0ad,
                limb1: 0x31e1220f76852a256b2cd72a,
                limb2: 0x54610149d359e69a04016d08,
                limb3: 0x14e348fc656629242f0605d4
            },
            y: u384 {
                limb0: 0x9f70af83145eb6022216cf31,
                limb1: 0x7ca733c5336b71372549af16,
                limb2: 0xf8e27e6cd1886ac5d6a8180c,
                limb3: 0xc0d07fa0175336031634ce9
            }
        };

        let ep: u384 = u384 {
            limb0: 0xd929603fcf161273072547f0, limb1: 0x567cd52d, limb2: 0x0, limb3: 0x0
        };

        let en: u384 = u384 {
            limb0: 0xb14a6fe8998a7b68dc1371dd, limb1: 0x5c14c5, limb2: 0x0, limb3: 0x0
        };

        let sp: u384 = u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 };

        let sn: u384 = u384 {
            limb0: 0xb153ffffb9feffffffffaaaa,
            limb1: 0x6730d2a0f6b0f6241eabfffe,
            limb2: 0x434bacd764774b84f38512bf,
            limb3: 0x1a0111ea397fe69a4b1ba7b6
        };

        let (res_acc_result) = run_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit(
            acc, m, b, xA, p, ep, en, sp, sn, 1
        );
        let res_acc: u384 = u384 {
            limb0: 0x289c15c86494dc266a30455d,
            limb1: 0xc5c420d6aba3c56aeb9e05c,
            limb2: 0x150980edd90a331026239d13,
            limb3: 0x1467f285ade745b6d3984128
        };
        assert_eq!(res_acc_result, res_acc);
    }


    #[test]
    fn test_run_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit_BN254() {
        let acc: u384 = u384 {
            limb0: 0x9148624feac1c14f30e9c5cc,
            limb1: 0xcda8056c3d15eef738c1962e,
            limb2: 0x91ea0ccf7b0b7d2,
            limb3: 0x0
        };

        let m: u384 = u384 {
            limb0: 0x4d037991dabc1cb21ac995d1,
            limb1: 0xcc05dfebb4b99c4c3cd0b601,
            limb2: 0x2675b66aa698bd21,
            limb3: 0x0
        };

        let b: u384 = u384 {
            limb0: 0xdaa0be5efdeace5c8fcd2b63,
            limb1: 0x16a41b2be39a6e507f36b143,
            limb2: 0xd39664b9fae3988,
            limb3: 0x0
        };

        let xA: u384 = u384 {
            limb0: 0xffc057151b06c496e6fdd440,
            limb1: 0x5a01bae0c7441f08c7af1cf9,
            limb2: 0x274e0e02529e6d26,
            limb3: 0x0
        };

        let p: G1Point = G1Point {
            x: u384 {
                limb0: 0xcfcdbfdb2056ff1a64bf1d47,
                limb1: 0xf26fe2dae9f693d9b4aab2e6,
                limb2: 0x12d66ad4802d841e,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0xe6e34ebfa2e18dce86cadbdc,
                limb1: 0x7ce096238b3d4b1b8fba6a55,
                limb2: 0x2e0a660b1549800c,
                limb3: 0x0
            }
        };

        let ep: u384 = u384 {
            limb0: 0xc5d898d92cd6976f3c770b53, limb1: 0xbffdbd7, limb2: 0x0, limb3: 0x0
        };

        let en: u384 = u384 {
            limb0: 0x18fe9b0f874b537c16c98c77, limb1: 0x41fe0f5, limb2: 0x0, limb3: 0x0
        };

        let sp: u384 = u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 };

        let sn: u384 = u384 {
            limb0: 0x6871ca8d3c208c16d87cfd46,
            limb1: 0xb85045b68181585d97816a91,
            limb2: 0x30644e72e131a029,
            limb3: 0x0
        };

        let (res_acc_result) = run_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit(
            acc, m, b, xA, p, ep, en, sp, sn, 0
        );
        let res_acc: u384 = u384 {
            limb0: 0x55a5b6cbed9b138d08e51183,
            limb1: 0xd356d2a94bd6bce4383a50de,
            limb2: 0x1df6878619b425de,
            limb3: 0x0
        };
        assert_eq!(res_acc_result, res_acc);
    }


    #[test]
    fn test_run_ACC_FUNCTION_CHALLENGE_DUPL_circuit_BLS12_381() {
        let f_a0_accs: FunctionFeltEvaluations = FunctionFeltEvaluations {
            a_num: u384 {
                limb0: 0x7115f5f47bf2363d7f5ba46e,
                limb1: 0x36da4d7dc327e42d2d2d06c9,
                limb2: 0xb457cb7b2c3996aebdc165bf,
                limb3: 0x142e516dfacff0be1cc3f06a
            },
            a_den: u384 {
                limb0: 0xa0bed1ceb43d4820d50f88d0,
                limb1: 0xc8f707ca20d086a6592270c8,
                limb2: 0x84060a4a93345811d4800956,
                limb3: 0x14b75b1095bf7b5a2eaeb35c
            },
            b_num: u384 {
                limb0: 0x38dff07f714a51398e924aa1,
                limb1: 0x687c817e8e850b2f3934e03c,
                limb2: 0xe5a9ff7ea25df0687846cf56,
                limb3: 0x16e70c9f0ebb8702e0be868
            },
            b_den: u384 {
                limb0: 0x87825b139f1999a7fba66f02,
                limb1: 0x801941f14a90a0b744413f73,
                limb2: 0x5733f5bcb4ff2e2182c539b,
                limb3: 0xda7097b46c8a6427dd82bab
            }
        };

        let f_a1_accs: FunctionFeltEvaluations = FunctionFeltEvaluations {
            a_num: u384 {
                limb0: 0xb7b3aa30e3d936bf0a1ee938,
                limb1: 0xad6ae8a7a5fc0bb40473f98,
                limb2: 0xd5700b5a8be015fcd1dfc26b,
                limb3: 0x182ebbc979010563f200e63a
            },
            a_den: u384 {
                limb0: 0x87b92b789469d5227b592d5e,
                limb1: 0xafde15eca7b4913b56243f64,
                limb2: 0xf5b9cc006c51144179d7e05a,
                limb3: 0x13e62ed8468bdb708b6e6609
            },
            b_num: u384 {
                limb0: 0xf8d1cd15e01768c509c0fbd4,
                limb1: 0x3a6d7a7e16706465126bbdd7,
                limb2: 0x461e3ae937448afb302373be,
                limb3: 0x14a3d281d74a4e60a432e35d
            },
            b_den: u384 {
                limb0: 0xa7e93a80fd99ff2c50f0bf57,
                limb1: 0x2cc52234d8a7019f898b7301,
                limb2: 0x3a6301f567b899768b15d458,
                limb3: 0x2d31e1c836cf99b3e486b65
            }
        };

        let xA0: u384 = u384 {
            limb0: 0xce86794b5d463576b07607d1,
            limb1: 0xfb98c8d5988d3b07c2ef4084,
            limb2: 0x25453a554e5386091f92c54b,
            limb3: 0x1565b044fbf7ade9620fe455
        };

        let xA2: u384 = u384 {
            limb0: 0xa99768166b81487fb2205194,
            limb1: 0x782122aa7cc6485fdb293525,
            limb2: 0xd9a0c080b8849fbd52e074e5,
            limb3: 0x56deee4f0909b4a9159ed0d
        };

        let xA0_power: u384 = u384 {
            limb0: 0x5803c1dde322948f3fed4eaa,
            limb1: 0x9e698cbd517f6437e532f186,
            limb2: 0x9370f0482bf9da1efc2e6c12,
            limb3: 0xc3b71cdbe10dce5680df4f9
        };

        let xA2_power: u384 = u384 {
            limb0: 0x53a1f55ccb1dfd4755621de1,
            limb1: 0x8af57da2beb0656ed87302dc,
            limb2: 0x2498d5546852c598d0b8d4d1,
            limb3: 0x28c0d15e01ce89d71760ea0
        };

        let next_a_num_coeff: u384 = u384 {
            limb0: 0x4dcc5dcbb032378fa6d79654,
            limb1: 0x66e3924320919da621570db,
            limb2: 0x85946349b1d0261ef260abe5,
            limb3: 0x7142a11706f0d4ac4092209
        };

        let next_a_den_coeff: u384 = u384 {
            limb0: 0x99983c29fcce2fd20fc98aa3,
            limb1: 0x83c8fd273d95edb7f9405fc1,
            limb2: 0xdfa149a35ca8788254d9159b,
            limb3: 0x2b1ea45c95e4d5759c6d80f
        };

        let next_b_num_coeff: u384 = u384 {
            limb0: 0xe076afccc5a26b0e83f2eddc,
            limb1: 0xd5bc077c94ebdc26e237c5d9,
            limb2: 0xf9dded0c058c4c3d47be16e8,
            limb3: 0x197d45830f2f37b022dddf28
        };

        let next_b_den_coeff: u384 = u384 {
            limb0: 0xe5665a4df4296e6011a82989,
            limb1: 0x557e71ee8d05f9d4df909777,
            limb2: 0xcb1cdc4313896d5fe051d913,
            limb3: 0x8980186bb8cc59b9713e4d3
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
                limb0: 0x4ee3965d40b33e28af8bc45d,
                limb1: 0x647001db607ea66504bcb320,
                limb2: 0xa2049d0c940a6a9de5ed132a,
                limb3: 0x52ea83ee7ef59cff295f632
            },
            a_den: u384 {
                limb0: 0x1c72dfe0d126088df1d33f66,
                limb1: 0xdcdeca5aaf4da0657b451bf4,
                limb2: 0xadcfe0e90fa46e8945786d99,
                limb3: 0x5067a7a3da6f8851f9f5a53
            },
            b_num: u384 {
                limb0: 0xb65a624493dd52276275c6b6,
                limb1: 0x74ce909e05fdf3cc22cd63cd,
                limb2: 0x68f11b6349f4d9bac2d10c2b,
                limb3: 0x22b58a0d023676fccf63c49
            },
            b_den: u384 {
                limb0: 0xe52bf3b92881200444eec8f0,
                limb1: 0xdba0253f18388caa86be7752,
                limb2: 0x25d5a5012afcea8cf453fda7,
                limb3: 0x161266b48cb31c06eb014ecb
            }
        };

        let next_f_a1_accs: FunctionFeltEvaluations = FunctionFeltEvaluations {
            a_num: u384 {
                limb0: 0xb9980d5b0e084e4cc9ebeb36,
                limb1: 0xdc87bbaa047b09de2048f640,
                limb2: 0x5ac8840bb401c1376bd1c577,
                limb3: 0xc3b83b23038de65851b13d2
            },
            a_den: u384 {
                limb0: 0x502699c82082f90a2c49c97d,
                limb1: 0x300c3f8c951e52b3401e1d40,
                limb2: 0xdac7a725d77b21ecf7081351,
                limb3: 0x1365916b006ec1841df2d7a5
            },
            b_num: u384 {
                limb0: 0x63a401459ba753e25bbf2374,
                limb1: 0xa95461db37fd934ae64a9ecc,
                limb2: 0x9ecfd7e34e3e6e97562955db,
                limb3: 0xbf20aea561b468cfc34582b
            },
            b_den: u384 {
                limb0: 0x821b4ce6f6108bd2cdf19af2,
                limb1: 0x962e6241d8ae22e739aeb8cb,
                limb2: 0x6adce790f7555cffe5419c5c,
                limb3: 0x74477d0495bc3553c6c82f8
            }
        };

        let next_xA0_power: u384 = u384 {
            limb0: 0x115629280cdf9a541b3c3df,
            limb1: 0x51e138027fc25285de9bc16f,
            limb2: 0x969d291c209c79c28b48baa9,
            limb3: 0x800f9e1ab2461e766b4855c
        };

        let next_xA2_power: u384 = u384 {
            limb0: 0x8f16e462919c744197f11407,
            limb1: 0x38e7664ff55b789770dfc756,
            limb2: 0xe00b3cd54ec6125f50bf6f28,
            limb3: 0x4af1a4f23331add5505ee29
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
                limb0: 0x5487b5c3b7626f4975fd3537,
                limb1: 0x54a8762b2b12c92c62565a95,
                limb2: 0x2978e9c66bf52dfd,
                limb3: 0x0
            },
            a_den: u384 {
                limb0: 0x6f6ddf79affe2554e5aef699,
                limb1: 0xeee84bcb7281b8a925e4979d,
                limb2: 0x970a6dab575bc6e,
                limb3: 0x0
            },
            b_num: u384 {
                limb0: 0x2114c2d650ea1324862f78e1,
                limb1: 0x2fd3b9f2e90f79f835783f66,
                limb2: 0x1658c16c71b221e4,
                limb3: 0x0
            },
            b_den: u384 {
                limb0: 0x638d521afbc59e92ca1209ad,
                limb1: 0x7df0fe6bce8d75f26d62e40c,
                limb2: 0x2eb4c45a63b8a897,
                limb3: 0x0
            }
        };

        let f_a1_accs: FunctionFeltEvaluations = FunctionFeltEvaluations {
            a_num: u384 {
                limb0: 0x3239d04bcbab5b51385c5fdc,
                limb1: 0x344af454f0a61c5e707421d4,
                limb2: 0x2d7097509626d8c4,
                limb3: 0x0
            },
            a_den: u384 {
                limb0: 0xe96ed9b5d158e442fcf3b87,
                limb1: 0xad7027cfa358cb1dbe3feafd,
                limb2: 0xeea85fe2c623ac3,
                limb3: 0x0
            },
            b_num: u384 {
                limb0: 0x9ccd3e1f4c2abdaa9c5c11eb,
                limb1: 0xde6c8762b475e15e162d5c72,
                limb2: 0x30187266831a352a,
                limb3: 0x0
            },
            b_den: u384 {
                limb0: 0xe0a10d2bc57c799848d002be,
                limb1: 0x6953a1155a62ddc4e2091f49,
                limb2: 0x373c0d67552c6e8,
                limb3: 0x0
            }
        };

        let xA0: u384 = u384 {
            limb0: 0x8420b8d9b261d0d2a1c2d9bf,
            limb1: 0xa604e5aff4db1c1eaa66b464,
            limb2: 0x2305060ef46860a2,
            limb3: 0x0
        };

        let xA2: u384 = u384 {
            limb0: 0xef1fa0a3bc02ba67ee04bdde,
            limb1: 0x7460d20d94b9cdb56e3c18c9,
            limb2: 0x104ddc387d7de1f5,
            limb3: 0x0
        };

        let xA0_power: u384 = u384 {
            limb0: 0x3725bd0c79c45c38b440ffe0,
            limb1: 0xacfeba4441030ae56525ce0,
            limb2: 0x35d08950b36f3cd,
            limb3: 0x0
        };

        let xA2_power: u384 = u384 {
            limb0: 0xfdec23598ca3b429b10823,
            limb1: 0x1d34690a795ac544a30f7cd,
            limb2: 0x4137fd923f1b67e,
            limb3: 0x0
        };

        let next_a_num_coeff: u384 = u384 {
            limb0: 0xae3582906d80ab08c963d148,
            limb1: 0x9bcfb1c4f87e356038dfe76b,
            limb2: 0x23b27aa66581f934,
            limb3: 0x0
        };

        let next_a_den_coeff: u384 = u384 {
            limb0: 0x7425f4e93891aef5ebe0572c,
            limb1: 0x9bbac83856e9b78d315e8080,
            limb2: 0x26ce83221a32e148,
            limb3: 0x0
        };

        let next_b_num_coeff: u384 = u384 {
            limb0: 0x761585b4168705a533c9a31,
            limb1: 0x30ac79dd0b5aafef85a1282a,
            limb2: 0x5209ea25e6364c6,
            limb3: 0x0
        };

        let next_b_den_coeff: u384 = u384 {
            limb0: 0x864696c1deb4e6c435a7c6ed,
            limb1: 0xd658b1b33012ae1c5882e3bb,
            limb2: 0x1014ec62339d78f5,
            limb3: 0x0
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
                limb0: 0x638c93c65884e992eda3b892,
                limb1: 0x15ab39d2db0b2b4de823ae24,
                limb2: 0x1c56dbd292766a45,
                limb3: 0x0
            },
            a_den: u384 {
                limb0: 0xfc183434efe3ca9ddb346526,
                limb1: 0x90b0b9ddd7986138dce4edc0,
                limb2: 0x69dceeaa9cb20cd,
                limb3: 0x0
            },
            b_num: u384 {
                limb0: 0x4c8a5acac73cceb89951fb15,
                limb1: 0xa8ed1e612b917415918f2452,
                limb2: 0x108a6eafcbadff02,
                limb3: 0x0
            },
            b_den: u384 {
                limb0: 0x3dd487120fb89466f8ae1323,
                limb1: 0xa94db511e128259ecf3560a8,
                limb2: 0x23d1094d75f7697c,
                limb3: 0x0
            }
        };

        let next_f_a1_accs: FunctionFeltEvaluations = FunctionFeltEvaluations {
            a_num: u384 {
                limb0: 0xcce4cfa0103231ba0187535d,
                limb1: 0x2edccc6f4de54001cc94e0cf,
                limb2: 0x530f23e62ee4485,
                limb3: 0x0
            },
            a_den: u384 {
                limb0: 0x504032b9bc5b66bc3f2e29c9,
                limb1: 0xdab54083ba0055d0f4cb1d9f,
                limb2: 0x1a830e7e122657c7,
                limb3: 0x0
            },
            b_num: u384 {
                limb0: 0xa4f4e83ab287b477fd2c8aee,
                limb1: 0x2ecb8473c1c19a2870586490,
                limb2: 0xd8c3e2edf68096f,
                limb3: 0x0
            },
            b_den: u384 {
                limb0: 0x75d43a3c769f401b2d55a4,
                limb1: 0x70df3d79fb57bb7f497d72eb,
                limb2: 0xe18cb16d9554fca,
                limb3: 0x0
            }
        };

        let next_xA0_power: u384 = u384 {
            limb0: 0x8e6a262889574e8f7b812e1e,
            limb1: 0x511440310061976318fa511e,
            limb2: 0x525e5652a103771,
            limb3: 0x0
        };

        let next_xA2_power: u384 = u384 {
            limb0: 0x399c20a7bdc1b6d0407cd368,
            limb1: 0x90d436b55140b63dbe94434d,
            limb2: 0x26711b76f9d9e246,
            limb3: 0x0
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
                limb0: 0xf6c07664d1e3a7bd617c8097,
                limb1: 0x5f954d767a9960e8838d1bf2,
                limb2: 0xe0357ef5fb57db00df75caa4,
                limb3: 0x187581f4ef5ba1bad0fca4e9
            },
            y: u384 {
                limb0: 0x5c4d6ad8bd78208a3e5d70aa,
                limb1: 0x1edff8e7b52c80507df1b914,
                limb2: 0xb4444507cb8595903366a82c,
                limb3: 0x39fcf3c317cd80f354d683
            }
        };

        let q: G1Point = G1Point {
            x: u384 {
                limb0: 0xd3eb86358597da8e952cc8b7,
                limb1: 0x9c84b47c24fd078de269e139,
                limb2: 0x1f0ff6a0b0a3496e6512a515,
                limb3: 0x73b7c77a46f8cbca37efcac
            },
            y: u384 {
                limb0: 0x10bdba13e6790e8f3fb0a5c6,
                limb1: 0x172cbedeb7721aaff957a1fe,
                limb2: 0xd77ab519db009471214d99cd,
                limb3: 0xabebf4a09a359f24d20eda4
            }
        };

        let (r_result) = run_ADD_EC_POINT_circuit(p, q, 1);
        let r: G1Point = G1Point {
            x: u384 {
                limb0: 0xdd8d6dfe06f15108b08f7f80,
                limb1: 0x8f0c581a8148297c0bc54a29,
                limb2: 0x6d417cb8010be4ce56c5e111,
                limb3: 0x34df700ee8f2ce4a65f9b0e
            },
            y: u384 {
                limb0: 0x74ccce801eb65cac01aba53e,
                limb1: 0xea00c5e5236d7abdc68fed04,
                limb2: 0x2cfb21d70504d624a65e197d,
                limb3: 0x16e5612ebe5e08ec824ed9b4
            }
        };
        assert_eq!(r_result, r);
    }


    #[test]
    fn test_run_ADD_EC_POINT_circuit_BN254() {
        let p: G1Point = G1Point {
            x: u384 {
                limb0: 0x3470ba8644c33b703efe8f3c,
                limb1: 0x43d7037685cc7c656cd41af8,
                limb2: 0xe7ffb7475161377,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x93057f8dcf3cde62664768c8,
                limb1: 0x7e1a6d5ce4088da6c54e877a,
                limb2: 0x2b4cd07afc430fa2,
                limb3: 0x0
            }
        };

        let q: G1Point = G1Point {
            x: u384 {
                limb0: 0x676263cbc037bc46be3d0aed,
                limb1: 0x3b8ba7add91c4a5872b46df7,
                limb2: 0x1eb5803e5318e517,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x6c9742c6e13915ae1dae05ca,
                limb1: 0xfe08b3cd31407c21de8f7767,
                limb2: 0x29b1ec208adb5275,
                limb3: 0x0
            }
        };

        let (r_result) = run_ADD_EC_POINT_circuit(p, q, 0);
        let r: G1Point = G1Point {
            x: u384 {
                limb0: 0xe832a26d5fc4a44ac2ba851a,
                limb1: 0x5bf4a12dd052de78c3f2bf4,
                limb2: 0x1612f7efcfa2a88b,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x130e25f42beb57d6979d3b64,
                limb1: 0x1620cb9e8841bc6d97e143d8,
                limb2: 0x1abfef313d3bc55d,
                limb3: 0x0
            }
        };
        assert_eq!(r_result, r);
    }


    #[test]
    fn test_run_DOUBLE_EC_POINT_circuit_BLS12_381() {
        let p: G1Point = G1Point {
            x: u384 {
                limb0: 0x205f9fd0f1446b72a4382c2a,
                limb1: 0x8c2ddaf0519f4a29b9fb62fa,
                limb2: 0xb4c55c7c2fa34f341d89c454,
                limb3: 0x5bc4c139517e2b2ee8985c5
            },
            y: u384 {
                limb0: 0x85f5b5ddedd2da9f7494d256,
                limb1: 0x306ce7fca5e3829af12f76c5,
                limb2: 0xcba6d5d891000574b327016a,
                limb3: 0x6cbfc1f0601ddebc51b602d
            }
        };

        let A_weirstrass: u384 = u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 };

        let (r_result) = run_DOUBLE_EC_POINT_circuit(p, A_weirstrass, 1);
        let r: G1Point = G1Point {
            x: u384 {
                limb0: 0xe5d2d5c82142a891e99058fa,
                limb1: 0x101d8b96a0efa75fc2e67981,
                limb2: 0xe2ee4c8104910f8ed8a043de,
                limb3: 0x10b618bbe032da92810b239c
            },
            y: u384 {
                limb0: 0x76bbeb8a6813c13f38f4f4c9,
                limb1: 0x292a0bec4cf45ac25af86b0d,
                limb2: 0x502ddc6793eae607988cf3b0,
                limb3: 0x13efc4af18b62b2ca6b29fab
            }
        };
        assert_eq!(r_result, r);
    }


    #[test]
    fn test_run_DOUBLE_EC_POINT_circuit_BN254() {
        let p: G1Point = G1Point {
            x: u384 {
                limb0: 0x83c062c4257d236c396cb97b,
                limb1: 0xb6f14e6dcea406e52ae9430,
                limb2: 0x2d6dbdd9d816344e,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x311005d95b1e9cf1ed13b18e,
                limb1: 0xd3c8514a54e078209191826e,
                limb2: 0x270addfccf65755b,
                limb3: 0x0
            }
        };

        let A_weirstrass: u384 = u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 };

        let (r_result) = run_DOUBLE_EC_POINT_circuit(p, A_weirstrass, 0);
        let r: G1Point = G1Point {
            x: u384 {
                limb0: 0x174fd4acd8cca469c09a9086,
                limb1: 0x45416f4083bb8bcb89b0d01e,
                limb2: 0xe64d3872f07456d,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x8b5dcbaf58dfe6d801d7144a,
                limb1: 0x349ad7e1266e5cd0a26933d,
                limb2: 0x2f324aa53efe28cb,
                limb3: 0x0
            }
        };
        assert_eq!(r_result, r);
    }


    #[test]
    fn test_run_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit_BLS12_381() {
        let A0: G1Point = G1Point {
            x: u384 {
                limb0: 0x3a4475842c81fd947e453233,
                limb1: 0x8ecd4c4daef4537997617f13,
                limb2: 0x21ba44189a65ff74427e9613,
                limb3: 0x98252c9d498a36f23910ea6
            },
            y: u384 {
                limb0: 0x8646fa77c834d02f3930663e,
                limb1: 0x5ee506f14da10d602f02cf4e,
                limb2: 0xe1104a28338dd6c949b44797,
                limb3: 0x46055bc743564db5f49e9f4
            }
        };

        let A2: G1Point = G1Point {
            x: u384 {
                limb0: 0x3f733c0fa3c6edbeb49ee956,
                limb1: 0x9a8c6e601702f11027cdb9e,
                limb2: 0x7f8aa9485c6de6e630142351,
                limb3: 0xaa53ad9d90a572b760035e8
            },
            y: u384 {
                limb0: 0x529246b1ad9e4c114f8cb416,
                limb1: 0x440b25ed07a258c51f79657f,
                limb2: 0xdc363f2952971207789124d2,
                limb3: 0x1657c156598ebc2b68b045c3
            }
        };

        let coeff0: u384 = u384 {
            limb0: 0xd408b8e3f7662df27fd64efe,
            limb1: 0x4bc3e5859c7038d76180edd3,
            limb2: 0x9266ae3cd5614be31385058f,
            limb3: 0x1f38f954b44b50cb6fedc68
        };

        let coeff2: u384 = u384 {
            limb0: 0xfc6cc59055da629c69a7dbfc,
            limb1: 0xef7f0c2eab65a4d0653b05fb,
            limb2: 0xb4d4b7e8ca1934f5a9767a1,
            limb3: 0x99daf5791d571d4a514ef24
        };

        let SumDlogDiv: FunctionFelt = FunctionFelt {
            a_num: array![
                u384 {
                    limb0: 0xe9521b452e615d43f5a6b6dd,
                    limb1: 0x9938b9e782b22d43d8795cf7,
                    limb2: 0x50bea76be7326e1f64b21ca6,
                    limb3: 0x3d1c5aa2ab9c1851af0ed28
                },
                u384 {
                    limb0: 0x794daba2251a54b78cff3e99,
                    limb1: 0x9a240f2d0295156027e6311e,
                    limb2: 0x379e1ff84c07db5d08a987b7,
                    limb3: 0x840ff2a42810d571e63e89a
                }
            ]
                .span(),
            a_den: array![
                u384 {
                    limb0: 0xe6fb9f807c3f9774732eba92,
                    limb1: 0x38f7d4e3ec71d172ce6185b7,
                    limb2: 0xadb4fb02e253ed08450f7f87,
                    limb3: 0xdf8f5178e5c9abf9adf0545
                },
                u384 {
                    limb0: 0x4d71a65b74c6ff01e6738349,
                    limb1: 0x381cfe3271b38bddf7c69c10,
                    limb2: 0x6b6343c58b132540984af46c,
                    limb3: 0xc8bd07f6b0b97731b1abf6e
                },
                u384 {
                    limb0: 0xbde2ae271f3fd2cd335a1b7b,
                    limb1: 0xa18b020ed04ed07f5d29a600,
                    limb2: 0x901355e7a6fe834fa6bda493,
                    limb3: 0x1517679ae160a1c93e0c2b9a
                }
            ]
                .span(),
            b_num: array![
                u384 {
                    limb0: 0x5123151bc1e8145dc309b69,
                    limb1: 0x11818f74addb5678801fa463,
                    limb2: 0x68377287b79cdee60547ae03,
                    limb3: 0x16ff0a58336e33e25b608086
                },
                u384 {
                    limb0: 0x6f87d6455455ac24347a5655,
                    limb1: 0xddf0c3120bb789b41be62446,
                    limb2: 0x7dcc900ae689bad6b97c9029,
                    limb3: 0x9cc15c1df6a19856ecb0b06
                },
                u384 {
                    limb0: 0xf7a786be63ab906545f17c4d,
                    limb1: 0x47442eadf6863ab09bb7247d,
                    limb2: 0x2781270494573a6962034dbf,
                    limb3: 0x8811be200465b8a0d83360
                }
            ]
                .span(),
            b_den: array![
                u384 {
                    limb0: 0x66ae31bd33e57e85cd4aa89a,
                    limb1: 0xc4c964435b689ec70f8b4ec8,
                    limb2: 0x623cacda80e331ecadbbdc27,
                    limb3: 0x1506c4e1a85fae82fae1200e
                },
                u384 {
                    limb0: 0x9178b928fee7078a75471ebe,
                    limb1: 0x91fc14b4670ec70b99aa5f11,
                    limb2: 0xf189d067d496ecb240dafcb0,
                    limb3: 0x387160196b687fe99f3b2f0
                },
                u384 {
                    limb0: 0x495e1e7c2c7f9f90a2d6d8c8,
                    limb1: 0xa855b940a2d14af12bdeeefe,
                    limb2: 0x94d4d43ac29593688d7a97cc,
                    limb3: 0xcf3640b8a03a812bf505b68
                },
                u384 {
                    limb0: 0xa78a25da23a4164941eae059,
                    limb1: 0xe405823414ab0236933cc2c7,
                    limb2: 0x4db98f3e6f6510194f9d9bbb,
                    limb3: 0x13c0729c6f34ae62c0123520
                },
                u384 {
                    limb0: 0x3464a4d67f6e05a600b35a92,
                    limb1: 0x48be9890da9f454686003bbc,
                    limb2: 0x365ddc433fadd78cabd877d,
                    limb3: 0x159d1e099b52b71cc0f98dc2
                },
                u384 {
                    limb0: 0x18f0af664eb8331a83db829b,
                    limb1: 0xc06045b5bde11e836812200a,
                    limb2: 0x61d8d152bb7144375cbb509a,
                    limb3: 0x17272c4d5da7a2f1ed5dc373
                }
            ]
                .span()
        };

        let (res_result) = run_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit(
            A0, A2, coeff0, coeff2, SumDlogDiv, 1
        );
        let res: u384 = u384 {
            limb0: 0x2c571eec85a94a4dcae2d3ca,
            limb1: 0xffb9e95d525abc32ea7d1c42,
            limb2: 0x9d745a06f5e894e400b2d8fc,
            limb3: 0x7126f37557420ead3dd55c
        };
        assert_eq!(res_result, res);
    }


    #[test]
    fn test_run_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit_BN254() {
        let A0: G1Point = G1Point {
            x: u384 {
                limb0: 0x81ba480765f696c4a4e834d1,
                limb1: 0x962b178ae3b878458f0b20f8,
                limb2: 0x2249884b9e818c1b,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x4597634947768813bb871ee5,
                limb1: 0x81d2750d32cdff91dc9df148,
                limb2: 0x115b4ebb6913ce83,
                limb3: 0x0
            }
        };

        let A2: G1Point = G1Point {
            x: u384 {
                limb0: 0x6398cbd5cc25761284f93220,
                limb1: 0x4021c53f392f75651f5d2759,
                limb2: 0x23f7a06466247c07,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0xf6178c59765a75f7abfa60cd,
                limb1: 0xa4132d4ac776c3380f64ba3b,
                limb2: 0x164cbdfa84ff3c7a,
                limb3: 0x0
            }
        };

        let coeff0: u384 = u384 {
            limb0: 0xf202d35546d651142476da98,
            limb1: 0x711f11f0c327b3933dde7d5a,
            limb2: 0x2d93b22ecddbcb0b,
            limb3: 0x0
        };

        let coeff2: u384 = u384 {
            limb0: 0x5ac41e2d48caf74b06384778,
            limb1: 0xc5443593dc49963e0ccfefdb,
            limb2: 0xb76fada8de96da2,
            limb3: 0x0
        };

        let SumDlogDiv: FunctionFelt = FunctionFelt {
            a_num: array![
                u384 {
                    limb0: 0x2fcd81b5d24bace4307bf326,
                    limb1: 0xfb3675b89cdeb3e60870e15c,
                    limb2: 0x10a4c2cca81ad477,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x16febaa011af923d79fdef7c,
                    limb1: 0x215663abc1f254b8adc0da7a,
                    limb2: 0x9923b8ee07405eb,
                    limb3: 0x0
                }
            ]
                .span(),
            a_den: array![
                u384 {
                    limb0: 0x642bfa42aef9c00b8a64c1b9,
                    limb1: 0x864a7a50b48d73f1d67e55fd,
                    limb2: 0x21650249468ff53d,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x9466e4726b5f5241f323ca74,
                    limb1: 0x7e1ea9c573581a8146743741,
                    limb2: 0x29095e66a905d750,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xeabca8d0b341facdff0ac0f1,
                    limb1: 0x5b7c709acb175a5afb82860d,
                    limb2: 0x14c1bcfd15166570,
                    limb3: 0x0
                }
            ]
                .span(),
            b_num: array![
                u384 {
                    limb0: 0x7c879b741d878f9f9cdf5a86,
                    limb1: 0x55d44936a1515607964a870c,
                    limb2: 0xc2f2ac3d8570102,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xbb42e0b20426465e3e37952d,
                    limb1: 0xb490b6081dfc83524562be7f,
                    limb2: 0x17cfd58e38701a14,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xb29a8b06daf66c5f2577bffa,
                    limb1: 0xd12ecbc40b9475b138018b47,
                    limb2: 0x2896d67f92e8e269,
                    limb3: 0x0
                }
            ]
                .span(),
            b_den: array![
                u384 {
                    limb0: 0x88c132adefbfc19ee8f6cf32,
                    limb1: 0x12f175ffae3b16ec9a27d858,
                    limb2: 0x7f6e2cc06d599e8,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x9b38fe803042e325a28f5ab0,
                    limb1: 0x1ea45cd69371a71fd480865f,
                    limb2: 0x5dba86c64264cd5,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xfb0323a1d576d4155ec17dbe,
                    limb1: 0x9b0252440950fd131db53334,
                    limb2: 0xc742d990589f877,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x2f5a522af87f43fdf6062541,
                    limb1: 0x7aaf0e891fb797fab7d6467b,
                    limb2: 0x2e89b61435e8579a,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xefdd35f80fa34266ccfdba9b,
                    limb1: 0x8b53031d05d51433ade9b2b4,
                    limb2: 0x27b7e8f66cf55b15,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x428a1c22d5fdb76a19fbeb1d,
                    limb1: 0x126cbc8f3888447911ebcd49,
                    limb2: 0x1344979fa59cec98,
                    limb3: 0x0
                }
            ]
                .span()
        };

        let (res_result) = run_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit(
            A0, A2, coeff0, coeff2, SumDlogDiv, 0
        );
        let res: u384 = u384 {
            limb0: 0x6ebf8a1950bfa372f64cfeb3,
            limb1: 0x838a282dbb6c4dd585fbe75d,
            limb2: 0x2ff19cad0c570a1a,
            limb3: 0x0
        };
        assert_eq!(res_result, res);
    }


    #[test]
    fn test_run_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit_BLS12_381() {
        let A0: G1Point = G1Point {
            x: u384 {
                limb0: 0x45229428641ad77af55bb469,
                limb1: 0x88151141caf5329c958de912,
                limb2: 0xb68fa5fc8842bcadda5550e7,
                limb3: 0x556711a61d344a149e56c32
            },
            y: u384 {
                limb0: 0xb51ed4a726dd1c0b30614468,
                limb1: 0xb8bd27aad78116b2a06eb726,
                limb2: 0x4e8fad56adffcb168165715c,
                limb3: 0x19d7bce9b89aa0019fe15421
            }
        };

        let A2: G1Point = G1Point {
            x: u384 {
                limb0: 0xc76596ded5d9e1e95bd50809,
                limb1: 0x74fdfb141e5c2aab56a3f2df,
                limb2: 0xaaf8eb5491a458c69a361242,
                limb3: 0xe8a57e6b125a4326373d851
            },
            y: u384 {
                limb0: 0x69e5dedde4d5be55365b80df,
                limb1: 0x2d96e29308f1d6f5e2091e53,
                limb2: 0xcdc3d3551478ab22f5901180,
                limb3: 0x1280ee07d412e3c7f327ac22
            }
        };

        let coeff0: u384 = u384 {
            limb0: 0x60c515e3e7d7532b4af9866a,
            limb1: 0x8547d983f8fb01cb98386997,
            limb2: 0x131b53419450cb6cedd9afe,
            limb3: 0x18d3adc9f49c63f060a5aed3
        };

        let coeff2: u384 = u384 {
            limb0: 0xe8817b577a22eaed0f96db91,
            limb1: 0xc12f706228959724988b5ef1,
            limb2: 0x61ea1c66d346008bb5245639,
            limb3: 0x81b589d6611711a72c1286a
        };

        let SumDlogDiv: FunctionFelt = FunctionFelt {
            a_num: array![
                u384 {
                    limb0: 0x6aceb23ba64f5e71f4abf9d5,
                    limb1: 0x560ba7be6a2496d81c3bc04f,
                    limb2: 0x571532b33839db4da0b0dea7,
                    limb3: 0x16ad595cf7fa36fc5587e3c5
                },
                u384 {
                    limb0: 0x4632acbda3828e6ebbe956ac,
                    limb1: 0xe1de3de4481c3e07a31a2285,
                    limb2: 0x95b3069069a0b73326e0e537,
                    limb3: 0x137cd43838820ff2656930b8
                },
                u384 {
                    limb0: 0x46ab92d9f2569b532370539b,
                    limb1: 0x3d2e80fa0268416a0c18f41d,
                    limb2: 0xf0591d22555c03bf5c9e04dd,
                    limb3: 0x3bbe633a03cf061a8a7d3da
                }
            ]
                .span(),
            a_den: array![
                u384 {
                    limb0: 0x73869418b1db0a78f2fd8e7a,
                    limb1: 0x46038cab0f3d16e0a323d79e,
                    limb2: 0x7cb9ca3ef0d3f406274f48f9,
                    limb3: 0xaabc8ac3a58161437630524
                },
                u384 {
                    limb0: 0x433ca80a1b3c9c49177677c7,
                    limb1: 0x4e1bae2877dcf7b27d97613f,
                    limb2: 0xbfdee880cb6ef63a6bae69b1,
                    limb3: 0x128d20a4f0c8092f5d094f37
                },
                u384 {
                    limb0: 0x1749300a2f79f52c8b10bb3c,
                    limb1: 0x203da6391e0e2ffdc646af96,
                    limb2: 0x15fc5f4045abd40367418726,
                    limb3: 0x12f1485f8b172998d83ec1e5
                },
                u384 {
                    limb0: 0x4a2b233adba630a8b5a2466e,
                    limb1: 0xfe68155c8594fc23db7c2739,
                    limb2: 0x2a9df500ff2abd86faa507d4,
                    limb3: 0xf22b9aaeded413bb43f355f
                }
            ]
                .span(),
            b_num: array![
                u384 {
                    limb0: 0xe15e787afb1ab1d26a2edd95,
                    limb1: 0x460c29b65fb7d8033ef1b23b,
                    limb2: 0xe199bcfd4559baa3eb0c1582,
                    limb3: 0x181dd472d4a6e349d6fdcfe2
                },
                u384 {
                    limb0: 0x425fea712cbdb877544f06dd,
                    limb1: 0x4a9bfc00192edd37379c05da,
                    limb2: 0x667c4de762f8d20ac78ad66d,
                    limb3: 0x17604a1677059fa856be7bee
                },
                u384 {
                    limb0: 0x11bf3e48abb797051867e06d,
                    limb1: 0xd93c0252d772d31bedf962db,
                    limb2: 0x2a4e9db93e507e0f8f040c54,
                    limb3: 0x129f810b307cb2287523fcc1
                },
                u384 {
                    limb0: 0x440c4ed5c1a8ccc35c33da30,
                    limb1: 0xca2b0d8d22f059bc0934fe22,
                    limb2: 0xf48697b7b201cf6f01f203a0,
                    limb3: 0x924dcc671bd78ea5e321e82
                }
            ]
                .span(),
            b_den: array![
                u384 {
                    limb0: 0x4bf637b49430715803cd6178,
                    limb1: 0x70b600c406b1b0ea29db292a,
                    limb2: 0xdb627a3de37f656971899b94,
                    limb3: 0xdff410ee4a7c8281ecdbd2c
                },
                u384 {
                    limb0: 0xd8900991b366dcbcabbfb882,
                    limb1: 0xc46e1738790b1990a428da2e,
                    limb2: 0x77082bdc0907ca131511a3f9,
                    limb3: 0xdfa9a22b7dedde9ac26cf5b
                },
                u384 {
                    limb0: 0x20bdbe66468dc95e39a71648,
                    limb1: 0x7a67a0cafc14e5c1977d2260,
                    limb2: 0xa5f8be00160bd6aa72461d4b,
                    limb3: 0xb4fcb4dfe05cd00de5892d6
                },
                u384 {
                    limb0: 0x1d60ee661540e2f14f22070d,
                    limb1: 0x1370d0ccf681e29d1b3d0270,
                    limb2: 0xb00c15523f0bf534e75e78e8,
                    limb3: 0x22fa16270f498cd6cb008dc
                },
                u384 {
                    limb0: 0x7721193197342123e3ed9637,
                    limb1: 0x5cc70a1a49266c9d693bf11,
                    limb2: 0x2da2bcd58a8ed273ece12e8b,
                    limb3: 0x19752600c40225372447e1ba
                },
                u384 {
                    limb0: 0x6943ca29a82c84abef10e37f,
                    limb1: 0xaedb5e9e8fa16d27d7fc0059,
                    limb2: 0xee5be9b92aab7c8854b9fb20,
                    limb3: 0x509109455e5c1d9b0364ad9
                },
                u384 {
                    limb0: 0x645d327b7b19062c3e48287d,
                    limb1: 0x5d93408018ca01b52b5deb8a,
                    limb2: 0x18cde78e74a2daf828caeb62,
                    limb3: 0x4dfab4ab622e417f38cc555
                }
            ]
                .span()
        };

        let (res_result) = run_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit(
            A0, A2, coeff0, coeff2, SumDlogDiv, 1
        );
        let res: u384 = u384 {
            limb0: 0xd31e7cca1215c5bfb7a98d81,
            limb1: 0x670ec600bccf5ee3008e6115,
            limb2: 0xc10fbd39fe19e0e45d5b984f,
            limb3: 0xd9e29b9669ad3f8e38618c1
        };
        assert_eq!(res_result, res);
    }


    #[test]
    fn test_run_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit_BN254() {
        let A0: G1Point = G1Point {
            x: u384 {
                limb0: 0xbc0167de7285d1c6c5416ac,
                limb1: 0xa80af7ff39fe56811642f140,
                limb2: 0x2be2767083e5f469,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x440ea8855981cb12754ea646,
                limb1: 0x39ab9b739d104fe17957f2a9,
                limb2: 0x13160d048079d92e,
                limb3: 0x0
            }
        };

        let A2: G1Point = G1Point {
            x: u384 {
                limb0: 0x706417f46fb5c44a492d814b,
                limb1: 0x85bc0c1410aae847c5cb6f8f,
                limb2: 0x65ac00269537db,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0xd94191552ddf3b4156330e04,
                limb1: 0xa58346f21d65b599b94fc410,
                limb2: 0x1d159073efa56b77,
                limb3: 0x0
            }
        };

        let coeff0: u384 = u384 {
            limb0: 0xcb30bc1183ad418370887c64,
            limb1: 0x54e0810e74071a20af8a6dd5,
            limb2: 0x8c4d5eb7590dca7,
            limb3: 0x0
        };

        let coeff2: u384 = u384 {
            limb0: 0xf21aec69f81b205a9eabbc05,
            limb1: 0xb0f21c531eeb550eca5adb05,
            limb2: 0x7dedbc07cda0037,
            limb3: 0x0
        };

        let SumDlogDiv: FunctionFelt = FunctionFelt {
            a_num: array![
                u384 {
                    limb0: 0xd69c91c278601602bb4a06cb,
                    limb1: 0x91dc59efeb21a3f6e6fd68e8,
                    limb2: 0x2ca7119f2b5f6932,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xf76fbfb83412fc12ac322c12,
                    limb1: 0xc9e4dab20edc6d2bc470f0e7,
                    limb2: 0xa201717ad1b8f60,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x82339e23dff3334b91b15f5d,
                    limb1: 0xa62081434fbaecc0eae2025e,
                    limb2: 0x18df83b75b6e4ae7,
                    limb3: 0x0
                }
            ]
                .span(),
            a_den: array![
                u384 {
                    limb0: 0x403d1f83a859890cd670f668,
                    limb1: 0xb0d9c2aa8f837ef727460f22,
                    limb2: 0x1d4f1f26032f06ca,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x55fea08e143e2e04bdd7d19b,
                    limb1: 0x8b5885ca0bb2c3f0bd30291a,
                    limb2: 0x8a12de947e7f593,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xf40048d7c31d5a973d792fa1,
                    limb1: 0x9c31d9b25a2b745b7b59051b,
                    limb2: 0x2b190ad349b25ded,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xf2686baa971c702d5bf49c04,
                    limb1: 0xda90f534a23d4c9de456697c,
                    limb2: 0x87854259efee464,
                    limb3: 0x0
                }
            ]
                .span(),
            b_num: array![
                u384 {
                    limb0: 0x635518f74f6fa985b732d46f,
                    limb1: 0xd432f8db6a174c1cbf9cc545,
                    limb2: 0x52a9147a69cfb85,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x313b32b7983631890063e42f,
                    limb1: 0x28fafd04559b5975b2d650af,
                    limb2: 0xe473c113d4a5d51,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xbf9c0efb5816b74a985ab61,
                    limb1: 0x105ada6b720299e32a69acc7,
                    limb2: 0x2ce5a415425cb200,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x870f084c7244f536285e25b4,
                    limb1: 0xe8754cd37cbd7025e28bc9ff,
                    limb2: 0x26a790c48fb83bab,
                    limb3: 0x0
                }
            ]
                .span(),
            b_den: array![
                u384 {
                    limb0: 0xcf1da1100cc36d8c77863fe5,
                    limb1: 0xf963a7efe00111e5d29dc5df,
                    limb2: 0x1a919c86cffa6cdd,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xfca055362169df82b9bdee2d,
                    limb1: 0xf3158c0c66dd779403c54c71,
                    limb2: 0x1ab81354adb328cb,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x8741ae91acfebb4bd29e8693,
                    limb1: 0x30c1fb6a190865159cb017c1,
                    limb2: 0x26ef5d431e707c52,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xdfa7c6ed32d1f81ba636425c,
                    limb1: 0xb044284a47acf2f64d6b234f,
                    limb2: 0xba982e6fa7ff8bf,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xda9bb01779c147c719a5711b,
                    limb1: 0xa0acf4c9658de17eec3aa314,
                    limb2: 0x165eaad14d30dbc,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x73f660d8e9f41cc04653a560,
                    limb1: 0x1da3b7e2cad6e514ccc14d51,
                    limb2: 0x106a4fe4dc821527,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x8557716aa7502a812227d96d,
                    limb1: 0xa51ad4f3a699bae0d138d150,
                    limb2: 0x75df39058d87776,
                    limb3: 0x0
                }
            ]
                .span()
        };

        let (res_result) = run_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit(
            A0, A2, coeff0, coeff2, SumDlogDiv, 0
        );
        let res: u384 = u384 {
            limb0: 0x418a61503091c066f946dd35,
            limb1: 0x41fd58a57405e1db35bec63,
            limb2: 0x2fd5e3f398304521,
            limb3: 0x0
        };
        assert_eq!(res_result, res);
    }


    #[test]
    fn test_run_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit_BLS12_381() {
        let A0: G1Point = G1Point {
            x: u384 {
                limb0: 0xae397d196da13f6771764b99,
                limb1: 0x6ac29b4cba5440907d6fe82a,
                limb2: 0x3ec2ce0bd16520d6e4d50cf0,
                limb3: 0xf13d77450fe8308251468ba
            },
            y: u384 {
                limb0: 0x25b03728d2c52f362630f75e,
                limb1: 0x1475d923bb9ef295cccbc926,
                limb2: 0x9389d6a9460aedfb6c23cc42,
                limb3: 0x15e5c8c242c8faf51716b622
            }
        };

        let A2: G1Point = G1Point {
            x: u384 {
                limb0: 0x97192f7b8d4874bcfe831286,
                limb1: 0x42066d6932ac532af9823451,
                limb2: 0xeae0f535f063eab61f46e843,
                limb3: 0x8a81f31377957095ddc2f4e
            },
            y: u384 {
                limb0: 0x931d189c9a30793bd9ba7cd9,
                limb1: 0x6384b327f66f31d68c31cc4e,
                limb2: 0xa728152c6e68e056d9d0fd1f,
                limb3: 0x15e3778ee984a81ef9c24736
            }
        };

        let coeff0: u384 = u384 {
            limb0: 0x79efb37e4c53a014fe7160f5,
            limb1: 0xb69b571177af33f0ee5679ca,
            limb2: 0xb38ecf261e926cf7f93a1181,
            limb3: 0x76f6730617ab4267a2b2559
        };

        let coeff2: u384 = u384 {
            limb0: 0xf72e606f37fec235845eb748,
            limb1: 0x3409c256b6efcca4b46a5a9b,
            limb2: 0xf457dde1c607cc47053b6c2e,
            limb3: 0x16ce2b4a86b2d990426612cf
        };

        let SumDlogDiv: FunctionFelt = FunctionFelt {
            a_num: array![
                u384 {
                    limb0: 0xeafa6b45463f2d8ccf80ac17,
                    limb1: 0xaacab64395d61abe2c8de1d5,
                    limb2: 0xec4ff6abea07cfddee9cee1f,
                    limb3: 0xf1c38bc648b1a3635152cba
                },
                u384 {
                    limb0: 0x517f6188e95ef6ab6757f65,
                    limb1: 0xc6edb26fa1f81ae844fe27c9,
                    limb2: 0x91cf06ba6666bba2f7f1fe71,
                    limb3: 0xbd4cf874c08c6ba1cb42e4a
                },
                u384 {
                    limb0: 0x61c668ce8d5d97908a2a1b8e,
                    limb1: 0x146672ad4b9e091349e19b4d,
                    limb2: 0x39b3c49db26c687c72f28cf5,
                    limb3: 0xa9ca24795300f74a1393ab
                },
                u384 {
                    limb0: 0x49e3af0ceb4d20e3d0d4b35,
                    limb1: 0x55d62f9b05b03a351c16dc39,
                    limb2: 0x4c6aee622490a4296c77700a,
                    limb3: 0x34b7fff0a09ac26fc1771ce
                }
            ]
                .span(),
            a_den: array![
                u384 {
                    limb0: 0x191cd96acab4e61dd109e20a,
                    limb1: 0x77f7ad194ee5ddf0d996f125,
                    limb2: 0xbc309d334ea8c3b1d2865c01,
                    limb3: 0x823f25f6db16e7a23e0e84e
                },
                u384 {
                    limb0: 0x426a50b85c9716dfc45181ec,
                    limb1: 0x9402cca16bfee0d56b2f694a,
                    limb2: 0x4fc5d572844e028fcfc08695,
                    limb3: 0xf70740dcdc8fd4e93cf47a3
                },
                u384 {
                    limb0: 0xb41cb80a3cfb8a406fda1a8b,
                    limb1: 0xaabc1f902de48434a0ec729f,
                    limb2: 0x2254aa07496679f874655798,
                    limb3: 0x5d33bff903e36cf18f205bb
                },
                u384 {
                    limb0: 0xf14bbea9404f72f3211312e1,
                    limb1: 0x480c762aec319b23c7ff1268,
                    limb2: 0x5119c1d81b2836ea46e98b75,
                    limb3: 0x64cb6b60118d4e31c8b9244
                },
                u384 {
                    limb0: 0x93a7468c10c15f57fed68dc1,
                    limb1: 0x87a951855166465bb0464634,
                    limb2: 0x443739330b83a6e8fef5a551,
                    limb3: 0xf8ee3fea6d150709a46f117
                }
            ]
                .span(),
            b_num: array![
                u384 {
                    limb0: 0x992ced0d3db37b82e0fcc0d,
                    limb1: 0x4b5ecc0d6a3b56eaa78473,
                    limb2: 0x18401176e0091eab320871c3,
                    limb3: 0x196c043afe6f875b98d086d
                },
                u384 {
                    limb0: 0x7ec29b33ed5c684be273b612,
                    limb1: 0x324f550f4e7aef59176fb51c,
                    limb2: 0xb7446dad5b30f8948122a08e,
                    limb3: 0xda6f18ea1b73801e5ebfa13
                },
                u384 {
                    limb0: 0x6278f95a74389b472a83c504,
                    limb1: 0xd73a123af6cb38c13390ac10,
                    limb2: 0xc3ab728a87b32db20dbcac4e,
                    limb3: 0xdac300c9e63256a9e2dd66f
                },
                u384 {
                    limb0: 0xaf3cd650e6fbb698d951dd59,
                    limb1: 0x9305a65a2c1f024f13ae4690,
                    limb2: 0x2b57967ed4b6fe7ed23731f6,
                    limb3: 0x13e28b0af153916b50ed151c
                },
                u384 {
                    limb0: 0x6955c5439ccb884629074abb,
                    limb1: 0xd20c450cd3901a57e5456672,
                    limb2: 0x9dcc668fa4007b485c531539,
                    limb3: 0xd590be8a9c0fdec6c25aad6
                }
            ]
                .span(),
            b_den: array![
                u384 {
                    limb0: 0x67b41f7834e9ecf54a51de41,
                    limb1: 0x6abb6f1595c864e768498382,
                    limb2: 0xf01688e4b43bcab8802b7d66,
                    limb3: 0xebcd276b9527fba397ce787
                },
                u384 {
                    limb0: 0xaf5ba30802a1213415f66e23,
                    limb1: 0x79dd6e7597a03443af3da6af,
                    limb2: 0x531e9571092770d286c56c45,
                    limb3: 0x18fc04c4c6fc21665637a9d9
                },
                u384 {
                    limb0: 0x530437e1ffb2e1c5e8b463bf,
                    limb1: 0xa245bf927bd434fafbbbb0c9,
                    limb2: 0xc2cdb416930807cfb766443f,
                    limb3: 0x18638db54859274be576cdef
                },
                u384 {
                    limb0: 0xe00e7ef4de3b68b89314f8c4,
                    limb1: 0xfa2d2731240c5fa87b8a1f9,
                    limb2: 0xb3975da9113c88f4d3ca4477,
                    limb3: 0x5e66856d3c401d04bab6887
                },
                u384 {
                    limb0: 0xbe72fa1e45ef60dbe3787246,
                    limb1: 0x166da609aa80ddfc3e5984b7,
                    limb2: 0x923e267ef117f2741840bff8,
                    limb3: 0x9b5b7f608b4f16f30a407e9
                },
                u384 {
                    limb0: 0x159ee5074191ef716fcc8b27,
                    limb1: 0xf19d09dd9bb6cafb82acaff5,
                    limb2: 0xbc8f167a04d6466e085c52f0,
                    limb3: 0x77b9ab8aa9bb48d2134b4aa
                },
                u384 {
                    limb0: 0x218d8f5e6cc7d727158eb443,
                    limb1: 0x97b7cfc7c5fe5c77b4e0bc15,
                    limb2: 0xe88031d09bd74388beab03f3,
                    limb3: 0x272fe2c59ec7ac9db81f356
                },
                u384 {
                    limb0: 0xf4681cdfc98889dc34fe120b,
                    limb1: 0xc7a9fa46791d4b0c3a9f74ef,
                    limb2: 0x174271deefc6e4359105877b,
                    limb3: 0x10b9ee1bce7f88c7df171830
                }
            ]
                .span()
        };

        let (res_result) = run_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit(
            A0, A2, coeff0, coeff2, SumDlogDiv, 1
        );
        let res: u384 = u384 {
            limb0: 0x2308f2a95e41ae74ce112271,
            limb1: 0xb7899f10f18ed36a5df95158,
            limb2: 0x5e7e83f36b22794e84526788,
            limb3: 0x17e3a2be3dd620c11ae2e79b
        };
        assert_eq!(res_result, res);
    }


    #[test]
    fn test_run_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit_BN254() {
        let A0: G1Point = G1Point {
            x: u384 {
                limb0: 0xa45371a126bd31c9b63ae3d6,
                limb1: 0x6f3c0dff916b0e1492da8dc6,
                limb2: 0x2d8af41b398f700b,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x6e6545896efadbee4355563b,
                limb1: 0x2dbece2401a4d2506577549a,
                limb2: 0x249e151938feefbc,
                limb3: 0x0
            }
        };

        let A2: G1Point = G1Point {
            x: u384 {
                limb0: 0xeca321dd329539db51ed9b9c,
                limb1: 0xd4b8c6e82cb065efbf014141,
                limb2: 0x21c16429f2d9d6fc,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0xc61472a13ee86cdd66273a2c,
                limb1: 0xbb166af03d431cd9d6b89c18,
                limb2: 0x7175d4832b44da3,
                limb3: 0x0
            }
        };

        let coeff0: u384 = u384 {
            limb0: 0x3d27b65e9a47b8b1f2a35e3e,
            limb1: 0x47a387970de8ea9c27bcbca9,
            limb2: 0x765ffcf14517709,
            limb3: 0x0
        };

        let coeff2: u384 = u384 {
            limb0: 0x261861a2ecc4f00889a6517a,
            limb1: 0x70677d11d4faa6bd95ce0155,
            limb2: 0x1ba7e988e6fa1d6c,
            limb3: 0x0
        };

        let SumDlogDiv: FunctionFelt = FunctionFelt {
            a_num: array![
                u384 {
                    limb0: 0x8ef066d44279b14dae55cdff,
                    limb1: 0x5decc06af24dfdd850910bdc,
                    limb2: 0x2451646bf03d866a,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xac0cf0dd974c146e8ec01b3,
                    limb1: 0xf61164cebfc74ca9d8ab0b30,
                    limb2: 0x26e2dc68b38a05fb,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xb65d12267e969cf3a7c5cb87,
                    limb1: 0x756b0715e7180322a4e695c9,
                    limb2: 0x1bde4256a3e04b3b,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x89b5b368df14c6125f58d5b5,
                    limb1: 0x6025f0ae353545792da44da1,
                    limb2: 0x12a05354964ddb77,
                    limb3: 0x0
                }
            ]
                .span(),
            a_den: array![
                u384 {
                    limb0: 0x26a974652371ea2c0247145f,
                    limb1: 0x56672017555a40854578bab3,
                    limb2: 0x17803a9bca24be4d,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x5697f17c17fd3736b7ef941c,
                    limb1: 0x9215f4f9edb95f2c787ddfb,
                    limb2: 0x11417d3d0a8c46c7,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x2df967474ed135530c5a876f,
                    limb1: 0xba8982dd85e69ea9db66bfda,
                    limb2: 0x135ef4c1122411e6,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x5419eefcd5e73e3f673617d9,
                    limb1: 0x1bd094486a2b32004c9a0ae1,
                    limb2: 0x23e4a37119724ce3,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x7aa56a181fd3c01757f98d1e,
                    limb1: 0x7f6b8793b318ad4c1db2b452,
                    limb2: 0x26bb6f46d316b4a,
                    limb3: 0x0
                }
            ]
                .span(),
            b_num: array![
                u384 {
                    limb0: 0xbc18a40b55c7ed9d4d4985dc,
                    limb1: 0x27d99a23e4f7625eafe6790a,
                    limb2: 0xaa8db3deb70ba65,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x6025719990823edaa0722aa0,
                    limb1: 0xfdd2ed7af97ccc57ce5dc807,
                    limb2: 0x590205aa38d8afc,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x15ace7a1ceca2ee310da8a95,
                    limb1: 0x38974df5bff773ce32b2c492,
                    limb2: 0x18a0c21a0fa7ee05,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x95bb440dc9cd4af97d161f29,
                    limb1: 0x379deda1ade6c5e9b6e355f6,
                    limb2: 0x55abd166c4c3935,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xfd0ba70e385af4635e4af862,
                    limb1: 0x95d1805142cb6d1dffc573d5,
                    limb2: 0xaa943d3c6f00933,
                    limb3: 0x0
                }
            ]
                .span(),
            b_den: array![
                u384 {
                    limb0: 0xe72bb5b707120911b3b68b57,
                    limb1: 0xc09fcd8f739cd488869bdbd2,
                    limb2: 0xce87470ad4ab155,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x3744da64cc249558f2ad985f,
                    limb1: 0x1ac902ee25777cf09f982188,
                    limb2: 0x1d568eb032ae2a20,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x8be04c3e5c94938160c6b3ed,
                    limb1: 0x1ad0a6f226bdd974d3b564b0,
                    limb2: 0x2628cdcdfd1ac7ce,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x25fdacbe7ce71b48fba52e59,
                    limb1: 0xa36bcb0167e98363905c053b,
                    limb2: 0x1b165885ae0fdbc8,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x7fa74d8aff88ec827f99d273,
                    limb1: 0xdfec4623ab899605a2939b3b,
                    limb2: 0x22bd624033b5b3ce,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x38018399ee6a8e2f9c19ed34,
                    limb1: 0xb4a1ca795718ada2027c013f,
                    limb2: 0x2fcf7c2ef66ac168,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xc8bf23fb9a431f7a41c30359,
                    limb1: 0x61067a8cd7a3283c27e969e2,
                    limb2: 0x12d7290d953c178e,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xce9b2e70b4d4dfccb7d779cc,
                    limb1: 0xccc93ff710fce97d786e30ef,
                    limb2: 0x210eca9f15ab2c21,
                    limb3: 0x0
                }
            ]
                .span()
        };

        let (res_result) = run_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit(
            A0, A2, coeff0, coeff2, SumDlogDiv, 0
        );
        let res: u384 = u384 {
            limb0: 0x520468ee96d4975cd1379bc0,
            limb1: 0x1e00a52c5d235babace01af5,
            limb2: 0x2f5da69938f64cbe,
            limb3: 0x0
        };
        assert_eq!(res_result, res);
    }


    #[test]
    fn test_run_EVAL_FUNCTION_CHALLENGE_DUPL_4_circuit_BLS12_381() {
        let A0: G1Point = G1Point {
            x: u384 {
                limb0: 0xf55fce60ea3cfb8a41ca4164,
                limb1: 0xed7b4cd77d0b73dd1d14b5f4,
                limb2: 0x27f07496025297603b97f68c,
                limb3: 0x42a40564d93e35b4e0aaf8f
            },
            y: u384 {
                limb0: 0x17352673bcdcbaaacbddc498,
                limb1: 0x6c1e2956add6858df02b67ec,
                limb2: 0x776bbd40e10197ed3ece2a69,
                limb3: 0xd3e82f6de62ff259ab18d26
            }
        };

        let A2: G1Point = G1Point {
            x: u384 {
                limb0: 0xe3ca2d8310d016cc83ab2685,
                limb1: 0x75877093d6114defc8ae8568,
                limb2: 0x9c9d72604c77cbe77794aef0,
                limb3: 0x7573abcb5f746f8abab325c
            },
            y: u384 {
                limb0: 0xf3eab97e9f39f9fadca21c39,
                limb1: 0xa815a1f739399926997c5963,
                limb2: 0xb07e1e1a68515dbb7a1db959,
                limb3: 0xa47ffe952b7e486289876e0
            }
        };

        let coeff0: u384 = u384 {
            limb0: 0x45b4f40a74337906ec766077,
            limb1: 0xd34d3350628a83c35c07938f,
            limb2: 0x909ea536eea214d2d3bda45d,
            limb3: 0x2265f816f1c0358e8bbb6d3
        };

        let coeff2: u384 = u384 {
            limb0: 0x6508982d8079f359231dc88a,
            limb1: 0xab75134b120fc62adee3bdb4,
            limb2: 0xb5dbebbd2d59dc3cee451030,
            limb3: 0xab0b71e3356abb99c261e15
        };

        let SumDlogDiv: FunctionFelt = FunctionFelt {
            a_num: array![
                u384 {
                    limb0: 0x3ffeae995fe5162e9a726e89,
                    limb1: 0x4e3a94521cf880e923a59293,
                    limb2: 0x810bd9bde2ce792c7c6fe9db,
                    limb3: 0x1e3711bb61c14e4aa74cb72
                },
                u384 {
                    limb0: 0x8f6759680a0110c162d33a20,
                    limb1: 0x80e5a69800d2ff48c92f4d5b,
                    limb2: 0x9443659688ebd33c3f508fbf,
                    limb3: 0x18de555907ecafc15dab06c4
                },
                u384 {
                    limb0: 0x865012fa16d67cf421acdfef,
                    limb1: 0xb3fe2504387094de1b1b928a,
                    limb2: 0xe484a48ef8eaf989b44d88b5,
                    limb3: 0xc6d8fba2a236a88f66ae1d6
                },
                u384 {
                    limb0: 0x12554a8e34e6a5305f25e5d9,
                    limb1: 0x32f5cd3ff089682568bc5a9a,
                    limb2: 0x24d3ce32c30b2808b65f838e,
                    limb3: 0xf0fdbeb3b88f47db68a0d8c
                },
                u384 {
                    limb0: 0xf99d4c7767a84e192304deae,
                    limb1: 0xe980e670c0773fe04825a5c2,
                    limb2: 0x34cb41e1e60d2adad2c8ffad,
                    limb3: 0x15567a8d6f3d9032b284222
                }
            ]
                .span(),
            a_den: array![
                u384 {
                    limb0: 0x5726adc9aa2505aa51688dc6,
                    limb1: 0x9ace7bd2aae1d0eee5efdaa5,
                    limb2: 0xaeb6eef8eef72f9edfb0d760,
                    limb3: 0x600f4d64a4fa6a208e58a37
                },
                u384 {
                    limb0: 0x228b9fac7cbb8f4dd31693b7,
                    limb1: 0xb9c2479f152ff17a56fc729,
                    limb2: 0x8fc13ebc2a68ccedb4a983d9,
                    limb3: 0xbd2d8ee358221ccd759af90
                },
                u384 {
                    limb0: 0x6c78f197eecb810375f31bf4,
                    limb1: 0x20c5716a876a516f3a5bdc38,
                    limb2: 0xd2d657be2e567afcc3e6e03c,
                    limb3: 0x10c929307b7c42e3acbb98ae
                },
                u384 {
                    limb0: 0x33d44b08dcb1c60bd4ef78c5,
                    limb1: 0x61e0967891bcb727ad361185,
                    limb2: 0xf840fe7a3e128f36042f2c,
                    limb3: 0x10dba76c673ba5c0c7405160
                },
                u384 {
                    limb0: 0x42b7c57e1fc5554c8a6fe773,
                    limb1: 0xd3e5013e0cf5412c76940729,
                    limb2: 0x7bd042c350962d28c5569194,
                    limb3: 0xf8411760de5a69cdab95791
                },
                u384 {
                    limb0: 0xb3d7f89fdfd030d2232dac75,
                    limb1: 0xb15fd5e8fc3a49ce22c5a15c,
                    limb2: 0xf62c38ed9d99eb49f01eb4df,
                    limb3: 0xa78343d74d036975a4c1ba8
                }
            ]
                .span(),
            b_num: array![
                u384 {
                    limb0: 0x45856260c5dfdbb269f258d8,
                    limb1: 0x566221a71d8a5b3a3512ccaf,
                    limb2: 0xccf2ea43558c5ac43c000d99,
                    limb3: 0xc8c3a878e1ccee97a658913
                },
                u384 {
                    limb0: 0x3b10563a313890278c286cd4,
                    limb1: 0x12240705d35a3a146437f920,
                    limb2: 0xd5a4c1ef7c146f027c0c77e5,
                    limb3: 0x64f7e367039d22d0466c0c7
                },
                u384 {
                    limb0: 0x3a08493c3271dcf60071ec94,
                    limb1: 0x842645209be1b42f4f118ed8,
                    limb2: 0x7c0910961770a5062ab6df22,
                    limb3: 0xc938e62991cbb26c189fcb9
                },
                u384 {
                    limb0: 0x74fbe492c73746464022306,
                    limb1: 0x13ea5afc0fdde282ec31a254,
                    limb2: 0x7ebada36194a5bfdcf3f0e62,
                    limb3: 0x24ed765185f965898ed2175
                },
                u384 {
                    limb0: 0x523fef19647611e9347bdfff,
                    limb1: 0xc0016aeb0e22b6294639618c,
                    limb2: 0x8032a324a21b4bf39b63aa9f,
                    limb3: 0x15b916d3c723092995c08df8
                },
                u384 {
                    limb0: 0x8b64670185cf3c9379ff4246,
                    limb1: 0xd33f3d89cdce73b5be0a39e6,
                    limb2: 0x538ceb94ad7b70fad3b9f176,
                    limb3: 0x15186fed190112ada523be6d
                }
            ]
                .span(),
            b_den: array![
                u384 {
                    limb0: 0xc55965e157326bfde5c5fb71,
                    limb1: 0x452bca940505a80b4268e2b0,
                    limb2: 0xdd1605b7a8fe84bf0f5e13c0,
                    limb3: 0xb2809f7673d6192089ffc1b
                },
                u384 {
                    limb0: 0xd1d2172a8222a1f72f7b266e,
                    limb1: 0x2a3c0c489d734dcb989822a6,
                    limb2: 0xaffb6b09467365a7d11b3ec4,
                    limb3: 0xeb633a8d4d288517042924d
                },
                u384 {
                    limb0: 0x453225fe375c61ff2331b262,
                    limb1: 0xb340a3342fd35a4bd18de3c5,
                    limb2: 0x38d7874fa91e17441face6db,
                    limb3: 0x8a02e991558f8ff23bb5a0d
                },
                u384 {
                    limb0: 0xa092979e1b14425e94bad83e,
                    limb1: 0x6028562ff6e405cda753625c,
                    limb2: 0x66cfd52f52b1791a4538abaa,
                    limb3: 0xb45678e604e263e574b411a
                },
                u384 {
                    limb0: 0xb4718ad0c1b3c26325c1827,
                    limb1: 0xe280c519dd8edc4247551d51,
                    limb2: 0xdf99baf1f7c6a9f75b4e9592,
                    limb3: 0x17e2b8759f97d5bd280915ba
                },
                u384 {
                    limb0: 0xe1f23a207959a6a0950489bd,
                    limb1: 0xe97ee52a4dc8b446f4884a16,
                    limb2: 0xd844bf783ef53ae86219ed06,
                    limb3: 0xc85e56e84f540ff0eaa3c6
                },
                u384 {
                    limb0: 0xaab47c6e9cef1f784ddf811b,
                    limb1: 0xb9e8ae5604d071fb438f3778,
                    limb2: 0x58ddd411f5d2148ced14f628,
                    limb3: 0xbbdd597905d811c1beff1ff
                },
                u384 {
                    limb0: 0xd2cce62e57fb7373af22cc7a,
                    limb1: 0xd81cabd0b4fc6bf784c9ffd0,
                    limb2: 0xee3f65bdb430472353b84f34,
                    limb3: 0x1716240b391158d099d907e5
                },
                u384 {
                    limb0: 0x81d1596adf595c7cbf35cf4b,
                    limb1: 0x4a4211a40e1a7683cd17950,
                    limb2: 0x509e72632a8a995283448662,
                    limb3: 0x17e7ceef85573355b5f22c1d
                }
            ]
                .span()
        };

        let (res_result) = run_EVAL_FUNCTION_CHALLENGE_DUPL_4_circuit(
            A0, A2, coeff0, coeff2, SumDlogDiv, 1
        );
        let res: u384 = u384 {
            limb0: 0x2bdb79326ac76cdad6a123bf,
            limb1: 0x39f8ece2e3173068fb2e0c3,
            limb2: 0x90a0562b0ffd9f50e2374390,
            limb3: 0x12d05a4f69ada951a2e50e78
        };
        assert_eq!(res_result, res);
    }


    #[test]
    fn test_run_EVAL_FUNCTION_CHALLENGE_DUPL_4_circuit_BN254() {
        let A0: G1Point = G1Point {
            x: u384 {
                limb0: 0xb3e023c7a71d881c23bfca50,
                limb1: 0xd1a6b74bf0a371a9ce01a7cd,
                limb2: 0x2f08d52b60913753,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0xa628ef8caf5c91c907f2fbb7,
                limb1: 0x10c010b6b565f29fe17a6fad,
                limb2: 0x4fdf6bf7270f1eb,
                limb3: 0x0
            }
        };

        let A2: G1Point = G1Point {
            x: u384 {
                limb0: 0x8e67bb101d42b0c5248ec7ee,
                limb1: 0xd07e8ee7754d1d17bc941995,
                limb2: 0x296780aef79e68b9,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x59dc552e876919a467f595d8,
                limb1: 0xf27a5b3a15f050dc9ee045ae,
                limb2: 0x2c4dd13c7674793d,
                limb3: 0x0
            }
        };

        let coeff0: u384 = u384 {
            limb0: 0x2247cbb118b35f818c7399b1,
            limb1: 0xc11ccf6b29dd8c025270afde,
            limb2: 0xba7a421b680c0d8,
            limb3: 0x0
        };

        let coeff2: u384 = u384 {
            limb0: 0xb995223d0d06c62c7af36879,
            limb1: 0xb5759af521f828cd2dcf0efb,
            limb2: 0x10cd58d746e2c52c,
            limb3: 0x0
        };

        let SumDlogDiv: FunctionFelt = FunctionFelt {
            a_num: array![
                u384 {
                    limb0: 0xa7f5195cde62d43f261908b9,
                    limb1: 0x5f0ef320f7f60e7f75f2bc20,
                    limb2: 0x18767f8e8147a8f4,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xc202387b849b8a44ce1bb02a,
                    limb1: 0x138c3460fd938adc99a2ecb1,
                    limb2: 0x1b499776bf391fbb,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x34c3494ac12ea9b8e7e13ed8,
                    limb1: 0xe6b106e289110af04a276dda,
                    limb2: 0x1abde6b4993ec8c6,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x7b72590bf8f8f071d360da69,
                    limb1: 0xf8e45086ca819c6fd872298c,
                    limb2: 0x26e021b663794035,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x2e9583eabda17da2000fc63d,
                    limb1: 0x91fcfe8881c16e984d6cd782,
                    limb2: 0x154ab9724124405b,
                    limb3: 0x0
                }
            ]
                .span(),
            a_den: array![
                u384 {
                    limb0: 0x6af944e07b38785b0932f5b6,
                    limb1: 0xe3d484087de8a2342412579d,
                    limb2: 0x26869f5bdd02e100,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xac6d5df814e5064cb799ae8e,
                    limb1: 0xcf6f111c26c06e67b2ddc481,
                    limb2: 0x1693d051fc98c279,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x9c9d03f309018aee69407be7,
                    limb1: 0x7579501a62fda854775e0ec3,
                    limb2: 0x67ea81b0c0a5967,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x26c00984c734bb05788c31f6,
                    limb1: 0x992a34a1084fa819052daad3,
                    limb2: 0x87e30559e0df45b,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x1af4787f52ebdac5a1457899,
                    limb1: 0xa6245b598c94af98b3386c3e,
                    limb2: 0xc7a72a058bf3b9e,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xc6c3744cc88e03b662276cbc,
                    limb1: 0x1c6a4b5e7d859725c707aef9,
                    limb2: 0x3d9accbe19b5837,
                    limb3: 0x0
                }
            ]
                .span(),
            b_num: array![
                u384 {
                    limb0: 0x7799a8e2b368c5539c30ceaa,
                    limb1: 0xef151673a1df3da79d44c93e,
                    limb2: 0x29a15615567e5862,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xe96aa1aff55e3aa2208a393e,
                    limb1: 0x4b36b545cca1a034633cbf79,
                    limb2: 0x2fbaed3aeab9221b,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x306aa871feef71cbc915d113,
                    limb1: 0x645bd776c838a14509c67417,
                    limb2: 0x17c7fe5f71cff814,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xef2d9a38e6e4b8df0b6d9611,
                    limb1: 0x4160ff927c7550f20a3c2c6f,
                    limb2: 0x1b4bb5fe6ac9d8a,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xaaa079968522dc4ef1dd50bf,
                    limb1: 0xe0397e67926146de91bacf80,
                    limb2: 0xeb2abe0374a6cc9,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xd1c3d1bcc6be643217ee0eb0,
                    limb1: 0xa09f1aede38690e7e27ac8e9,
                    limb2: 0x20278842c7867a38,
                    limb3: 0x0
                }
            ]
                .span(),
            b_den: array![
                u384 {
                    limb0: 0x6b8c66f28611f583b2d10e3d,
                    limb1: 0xf20b575d4e28e67481d1bf06,
                    limb2: 0x952fdeb1d0ab994,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x90e639e1e44fc3a96d0c62c3,
                    limb1: 0x15831feeec41e6f66c0be55c,
                    limb2: 0x6b476aaef8d9ff0,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x725c2675ca9571e407dc02b1,
                    limb1: 0x6ac1ca75afb918c86e5bac20,
                    limb2: 0x1fc8b34407b6e08e,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xf655860bdd32e231eb561699,
                    limb1: 0x40a978bfb8f8903b53125ffd,
                    limb2: 0x168f68d9141b1a1b,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x5bf806761f12a0e912011caa,
                    limb1: 0x586f1721078548d7b1182d23,
                    limb2: 0xb62d6d0590e83da,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xf96d4403d48c93f3028d042b,
                    limb1: 0x5da53b38d1aa6c5e3b019fcb,
                    limb2: 0x262e83c3120d7126,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x353e0c8624aeba79e4b82987,
                    limb1: 0xa8b56f85346d2b7e00d3d1af,
                    limb2: 0x2edac025ac7b7ab2,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x1f8941b6e6a1a40bf031f4b9,
                    limb1: 0x4b1347f601d6d903bf7b68ae,
                    limb2: 0x2c2038005e7f503c,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x9ad7558feecb325b064f768d,
                    limb1: 0x2452bc39dbf2eed13b9cea95,
                    limb2: 0x1d0f1fa72fdeb035,
                    limb3: 0x0
                }
            ]
                .span()
        };

        let (res_result) = run_EVAL_FUNCTION_CHALLENGE_DUPL_4_circuit(
            A0, A2, coeff0, coeff2, SumDlogDiv, 0
        );
        let res: u384 = u384 {
            limb0: 0x85345e941813646039517f52,
            limb1: 0x4c65e6cde09d727cff10007,
            limb2: 0x28c5cf6206eaeac,
            limb3: 0x0
        };
        assert_eq!(res_result, res);
    }


    #[test]
    fn test_run_FINALIZE_FUNCTION_CHALLENGE_DUPL_circuit_BLS12_381() {
        let f_a0_accs: FunctionFeltEvaluations = FunctionFeltEvaluations {
            a_num: u384 {
                limb0: 0x58369021250f33c8f4c0153a,
                limb1: 0x94a7ef30a0327140c90da7ab,
                limb2: 0x3ef8aea6a4e8f069e7f82a1d,
                limb3: 0xdffde7d018f44bb980bf457
            },
            a_den: u384 {
                limb0: 0x6d83cb04570b1a6d8bb05656,
                limb1: 0xafdbd44c65c22565bf0f959f,
                limb2: 0xad100cbf767bf585627a91fe,
                limb3: 0x2b4a1786d34bfe1de45628
            },
            b_num: u384 {
                limb0: 0xadc7bc5442b37a4b711e02d4,
                limb1: 0x12f93f995be5e6a41d1a9ea3,
                limb2: 0x55ad61b9f0706a797d86fe66,
                limb3: 0xca2fee98714501fe3c849a6
            },
            b_den: u384 {
                limb0: 0x4a6e9dde750e37a7feafe5b2,
                limb1: 0x7ba690739da63119f6c958fe,
                limb2: 0x500f9914b66da8e3a713a2e3,
                limb3: 0x14e2c33c4c661c0fc6ff4b76
            }
        };

        let f_a1_accs: FunctionFeltEvaluations = FunctionFeltEvaluations {
            a_num: u384 {
                limb0: 0xf22c260d5d02833319e86575,
                limb1: 0x96017247e7c6aec2c5f4867,
                limb2: 0xc958a77075333dbab3918ab7,
                limb3: 0xbd07ca84492cc126e8181f8
            },
            a_den: u384 {
                limb0: 0x5f7e494a01cf843631cc32bb,
                limb1: 0xe3b9c7bd9c1fdb593f33296d,
                limb2: 0x1d915117fe4e460f875dd2e3,
                limb3: 0x1959817efb9faa0b34b37284
            },
            b_num: u384 {
                limb0: 0xd92266b562133ac2fd3c0dcd,
                limb1: 0x79f4a6e2b96d0ed4ed41517,
                limb2: 0xce60296bc984912c6b536f56,
                limb3: 0xbedc72efd0293cd9d6dd706
            },
            b_den: u384 {
                limb0: 0x2d92532d754ab5b69dd516b4,
                limb1: 0x68159dd7e78016019430efd1,
                limb2: 0xd0ae95b431fc47284bc10248,
                limb3: 0x8904f25a9155dd48f8b7281
            }
        };

        let yA0: u384 = u384 {
            limb0: 0xb82bb18b6b4e648694f4c7e0,
            limb1: 0x1cec53a1cdb4b13ec6cdc9e8,
            limb2: 0x3486312bef77324560ac257b,
            limb3: 0x1998dbc3b0ee761b0935d6cf
        };

        let yA2: u384 = u384 {
            limb0: 0xa87ffde47d93094a35609f2a,
            limb1: 0xc6f4d4babc9b805ae54b9b00,
            limb2: 0x3a65b6e281fc446b5658b8ef,
            limb3: 0x7fdcc4ebf90c4b98e87e850
        };

        let coeff_A0: u384 = u384 {
            limb0: 0xc0f4c7a47db4aa2cf9a31bd2,
            limb1: 0xbde63c4fdf333f14b69da0da,
            limb2: 0x3fe6fd18f54c01fd7a0bdb39,
            limb3: 0x44698091c0e54d7c307fd76
        };

        let coeff_A2: u384 = u384 {
            limb0: 0x9348e42daed86de191d5a041,
            limb1: 0x60194c32806a5ab8b5c4a0e4,
            limb2: 0x76ee73db601a57ec2a7dd02c,
            limb3: 0x14a1062d91d15a8df0b2a70
        };

        let (res_result) = run_FINALIZE_FUNCTION_CHALLENGE_DUPL_circuit(
            f_a0_accs, f_a1_accs, yA0, yA2, coeff_A0, coeff_A2, 1
        );
        let res: u384 = u384 {
            limb0: 0x17cb93f97831b8c4e6200b55,
            limb1: 0x6c458e5c548c30b42f068d60,
            limb2: 0x13924007105eff9f86a2d595,
            limb3: 0x14fc81522371b7401f379aa2
        };
        assert_eq!(res_result, res);
    }


    #[test]
    fn test_run_FINALIZE_FUNCTION_CHALLENGE_DUPL_circuit_BN254() {
        let f_a0_accs: FunctionFeltEvaluations = FunctionFeltEvaluations {
            a_num: u384 {
                limb0: 0xbc5074acbaa172acac33f644,
                limb1: 0x845398134fee71444d236555,
                limb2: 0x189e7651dc2897c6,
                limb3: 0x0
            },
            a_den: u384 {
                limb0: 0x580c79fc7b69e69041300879,
                limb1: 0x3d6e2667b6651d6edf39ccaa,
                limb2: 0x139277d50b648acd,
                limb3: 0x0
            },
            b_num: u384 {
                limb0: 0x1284b9d78d4e2753ef26a5b7,
                limb1: 0x7ecc040c75ff93f0025b7c5f,
                limb2: 0x1c0b7222b97fb3bb,
                limb3: 0x0
            },
            b_den: u384 {
                limb0: 0xcf1accc1eaca38110c26e5d9,
                limb1: 0x7e5b637dfa98c1156980b561,
                limb2: 0x1c2abd4975e417dd,
                limb3: 0x0
            }
        };

        let f_a1_accs: FunctionFeltEvaluations = FunctionFeltEvaluations {
            a_num: u384 {
                limb0: 0x14dbad2215eae9d21e3d59d0,
                limb1: 0xd3861b58194665d33dbba3af,
                limb2: 0x9d7c9d7c3f3f74d,
                limb3: 0x0
            },
            a_den: u384 {
                limb0: 0x7d7185913fee2fc72e2dffdf,
                limb1: 0xd728525620ca35ab38553ac8,
                limb2: 0x11db121edeffed7a,
                limb3: 0x0
            },
            b_num: u384 {
                limb0: 0x9acba5888397d4127118bb71,
                limb1: 0xa2652c9e89421c6d764ab510,
                limb2: 0x117165b542d01ba3,
                limb3: 0x0
            },
            b_den: u384 {
                limb0: 0x1e651ac1043d2c473b56735e,
                limb1: 0xb63f83c6c89309e99d683a9e,
                limb2: 0xb0b7cf019518f87,
                limb3: 0x0
            }
        };

        let yA0: u384 = u384 {
            limb0: 0xbdee923101a6009ea8dce886,
            limb1: 0x6da313e783e9973b89181ba3,
            limb2: 0x32f7005dbedb42e,
            limb3: 0x0
        };

        let yA2: u384 = u384 {
            limb0: 0xa52ba0ce627b585f1f2de275,
            limb1: 0xf89d3fda1e45424145c190a8,
            limb2: 0x242380dcbcbe9a42,
            limb3: 0x0
        };

        let coeff_A0: u384 = u384 {
            limb0: 0xacc512df3ac49efa5be12d09,
            limb1: 0x8bf06f64b4178592b76fc5b2,
            limb2: 0x120f0693a91da2cd,
            limb3: 0x0
        };

        let coeff_A2: u384 = u384 {
            limb0: 0xd4f0d65dbd6817b638b80611,
            limb1: 0x1095e4973d798f0be6cd3595,
            limb2: 0x13ae61da84a5b1c3,
            limb3: 0x0
        };

        let (res_result) = run_FINALIZE_FUNCTION_CHALLENGE_DUPL_circuit(
            f_a0_accs, f_a1_accs, yA0, yA2, coeff_A0, coeff_A2, 0
        );
        let res: u384 = u384 {
            limb0: 0x376938a9556b435bf465e311,
            limb1: 0x17ca765bd9f53dbff4cd71b1,
            limb2: 0x539e1725f1280e7,
            limb3: 0x0
        };
        assert_eq!(res_result, res);
    }


    #[test]
    fn test_run_INIT_FUNCTION_CHALLENGE_DUPL_5_circuit_BLS12_381() {
        let xA0: u384 = u384 {
            limb0: 0x43b0a5429f4e64253563e294,
            limb1: 0xf94a1dee3e9f0945580b4fce,
            limb2: 0x643b9776cf92da64dc91acce,
            limb3: 0x1151e92adb5f50ee583796ce
        };

        let xA2: u384 = u384 {
            limb0: 0x5209308edf7a78a660f65ad0,
            limb1: 0x6f8859a5aa02f76e549cb47e,
            limb2: 0xd196e4394aef728c6791a5d4,
            limb3: 0x11255e07a5adf53b3bc3373b
        };

        let SumDlogDiv: FunctionFelt = FunctionFelt {
            a_num: array![
                u384 {
                    limb0: 0xf84620541b152869b326ca45,
                    limb1: 0x15e00003d84d858b475b4c14,
                    limb2: 0x759bf9c4d625e7c45775820a,
                    limb3: 0x4b9e077ddb2f3dae95528be
                },
                u384 {
                    limb0: 0x89f464adf094d333e48d7b46,
                    limb1: 0xd856bbb08bb2de2a7ce0244b,
                    limb2: 0x36771ea6418b6d331551de12,
                    limb3: 0x8975e841e49dc9e29cf0d42
                },
                u384 {
                    limb0: 0x41363f58ca9db0b53475d8a,
                    limb1: 0xf10f835c81fa55ad573f9cd6,
                    limb2: 0x5c151b782751d21300271097,
                    limb3: 0x1320fc981a254c4e7b21fb00
                },
                u384 {
                    limb0: 0xaa0415586326ee353e402347,
                    limb1: 0xd08fd1343b545203b19e603,
                    limb2: 0xd3590f679a04159e017a666a,
                    limb3: 0x1221a0d689fd6af9586d4572
                },
                u384 {
                    limb0: 0x44bffcf4ae299c08e1f18c64,
                    limb1: 0xeb6b10ac51dec246ddf443de,
                    limb2: 0x81f27798f0bfad8107e56133,
                    limb3: 0x13760ad4e50f48e5c5412b14
                },
                u384 {
                    limb0: 0x93d87e8ef437109d00750c4d,
                    limb1: 0x75ec11f33d867dc8634c816e,
                    limb2: 0xeceb437aabbddadbafd6224f,
                    limb3: 0x9575d467bfed5c5d4c3aaaa
                }
            ]
                .span(),
            a_den: array![
                u384 {
                    limb0: 0x62bd99ae20726dd9e0738191,
                    limb1: 0x3a49cb0437baa28d06f7302d,
                    limb2: 0xa89a150dc26ff9f46c356df7,
                    limb3: 0x2f83767cd66eb5d1082f73a
                },
                u384 {
                    limb0: 0x126446724f926225ad4f0f49,
                    limb1: 0xb486af13cba51fd656793f06,
                    limb2: 0x1d7493366de5e02721ece55e,
                    limb3: 0x3475f59365c6e111cda0f4b
                },
                u384 {
                    limb0: 0x31733582c87e73092c992175,
                    limb1: 0xf28f30c0335480acf1e80db5,
                    limb2: 0xdc3cdafc5e49c60a89096b5e,
                    limb3: 0x7fd036986814d6b140b3e21
                },
                u384 {
                    limb0: 0xc844a165f060f172a84aeaff,
                    limb1: 0xacc99b97fd77a1a8e9e9d60b,
                    limb2: 0xf129ddcbc6bad39c463804a1,
                    limb3: 0x1002ff72320eed22b6e3e228
                },
                u384 {
                    limb0: 0xcbbeea054653ff61315b14ae,
                    limb1: 0x360ae10c1436d260d434092d,
                    limb2: 0xe73243e6d087d0dde6b6f42c,
                    limb3: 0x1971b9d7b3bebf349dfa9c55
                },
                u384 {
                    limb0: 0x2c15323ba9f5e7b14e4bf176,
                    limb1: 0x493604f35ede251e738dc60,
                    limb2: 0xb3353fe7a615afc088bf6f17,
                    limb3: 0xef8d22cf1bd04e4c8a9c12b
                },
                u384 {
                    limb0: 0xb4c3d309bfd0b79bc7d791cb,
                    limb1: 0x86d4603aa20047e29d8e8045,
                    limb2: 0x9c07b917586c4e80ff7d212f,
                    limb3: 0x73fc902c81abc01d203382f
                }
            ]
                .span(),
            b_num: array![
                u384 {
                    limb0: 0x23ac2b84be35a53466ef219a,
                    limb1: 0xc2ab36a75dff74f4987695b0,
                    limb2: 0x82132bfe821096d4cad7ab0b,
                    limb3: 0x262d2727edd05ba2901cb3a
                },
                u384 {
                    limb0: 0x5cc931187fb5a2353541adbd,
                    limb1: 0x9875f4f2bfd8130578cedc41,
                    limb2: 0x2cf6c298413b5c6d6acc59ee,
                    limb3: 0x1d2a9ef57458f9bd16b04f
                },
                u384 {
                    limb0: 0xdc4f6fb6dcd4ff33eede3c34,
                    limb1: 0x439ccea17d41213aa637bc63,
                    limb2: 0x124131ef0a5ee510fc99c09c,
                    limb3: 0x174463d9a7a9606699cf6fee
                },
                u384 {
                    limb0: 0x582f94e1cb4612010838d851,
                    limb1: 0xebee1a428f535855d36a9a90,
                    limb2: 0x6fb9e40bd9a56a4f7ba40d39,
                    limb3: 0x124a136eeff7f641d2dee28e
                },
                u384 {
                    limb0: 0xe3ffb4bca2fa5a36e224d6fc,
                    limb1: 0x1f9f9dd2c7b2f3ea7c909c40,
                    limb2: 0xa9470a0ddd9990703398d034,
                    limb3: 0xc74fcf35eb5d53c0ca172be
                },
                u384 {
                    limb0: 0x582a4726428353fde38aaa38,
                    limb1: 0x56d830a398c5c7d98702c5b3,
                    limb2: 0x542ffd6123e868bad3b2b828,
                    limb3: 0x175387fe1f0d918f2662a1d2
                },
                u384 {
                    limb0: 0x453875f4176088e55b5b1743,
                    limb1: 0x663b179959de82a0e8a3b05f,
                    limb2: 0xdc07f7ba1aa1ad8ffa0baab0,
                    limb3: 0x48778fd95a58f6f504e99a0
                }
            ]
                .span(),
            b_den: array![
                u384 {
                    limb0: 0x8165226563c1c709d701bad8,
                    limb1: 0xf3bbf976ee663bc7486ebd76,
                    limb2: 0xe69fc01b5b8ea83740d4e357,
                    limb3: 0x1cf9a799067f465298bbb3a
                },
                u384 {
                    limb0: 0x792372e231a2baf81c660eb4,
                    limb1: 0xdd34d576507a69f617bab888,
                    limb2: 0xc974a4b34130e95e38af9fe5,
                    limb3: 0xdb2d4082b1625637166a287
                },
                u384 {
                    limb0: 0x8db5bc77341b6adaa013ba3e,
                    limb1: 0x746863208c47eae1859fe637,
                    limb2: 0xb386ea067c1197462fe6c4ac,
                    limb3: 0xf67963b792613ac217546ad
                },
                u384 {
                    limb0: 0xeda86200bbf601818edcdf3f,
                    limb1: 0xaf2b8e1bfe5f2e3b5c1985fc,
                    limb2: 0x8099d335ad4802579c1697c5,
                    limb3: 0x16695cdbfa4e828fc357d8f1
                },
                u384 {
                    limb0: 0x2a16813835cfb04b087a49f5,
                    limb1: 0xd7c8c77fb470589210c23883,
                    limb2: 0x7f6bb6fb60fd118850791d41,
                    limb3: 0x10c901779f76d9fa65a6b899
                },
                u384 {
                    limb0: 0x97502228092ceb57673c2c14,
                    limb1: 0x24c7fc02515cd165ef530f4f,
                    limb2: 0xa3563cf0432094c328e7222e,
                    limb3: 0x12a5d2bd29bd9a88b3bd45a7
                },
                u384 {
                    limb0: 0xd9912bedf9fcb9882b363a8c,
                    limb1: 0xd0b5e858c68323a9762a14bb,
                    limb2: 0xbc851c1498041d601991aa3a,
                    limb3: 0x13a3d9a7d2b4668659ed244b
                },
                u384 {
                    limb0: 0x9f804627e3c88c7ad35666e5,
                    limb1: 0xa3a94da989b923d4395d4e8b,
                    limb2: 0x52046405677ea36d9c150ae0,
                    limb3: 0x10ab4311948340fa2304b471
                },
                u384 {
                    limb0: 0x71cdf65e9b736c70ca28e67f,
                    limb1: 0x65db0d811bc6b50686d74019,
                    limb2: 0x4adf0dda600ae5d2d6c4086d,
                    limb3: 0x1201b0317121865c5503fa84
                },
                u384 {
                    limb0: 0xcdb8f0ead9911672a88c33a8,
                    limb1: 0x51aba4b6a3cee7faf8d8cf61,
                    limb2: 0x1b36fdbc74b6ee7f62d6587c,
                    limb3: 0x4071710f7b7b3f1da91ef4c
                }
            ]
                .span()
        };

        let (A0_evals_result, A2_evals_result, xA0_power_result, xA2_power_result) =
            run_INIT_FUNCTION_CHALLENGE_DUPL_5_circuit(
            xA0, xA2, SumDlogDiv, 1
        );
        let A0_evals: FunctionFeltEvaluations = FunctionFeltEvaluations {
            a_num: u384 {
                limb0: 0x83db3b0e83c50cdac73e7a4d,
                limb1: 0x33de0da9b8237996c1bf167f,
                limb2: 0x6fa185bf063a1f544fd4b9b2,
                limb3: 0x10ca40c1bbd6930d3fd946e6
            },
            a_den: u384 {
                limb0: 0x5fc6849e547d9892a1f2efb2,
                limb1: 0x130e855f9d0c5e93fde4d63d,
                limb2: 0xe767046ccbf79b69172ac02b,
                limb3: 0x579f6fcced1d18e44dba0b7
            },
            b_num: u384 {
                limb0: 0xef63575e3e97c624426d7a0c,
                limb1: 0xaa41c8266fa50d536801f9df,
                limb2: 0xbb5a9941157f9d5e6184fcd7,
                limb3: 0x1505200b787c6f5dbca09df1
            },
            b_den: u384 {
                limb0: 0xcdb635edf26be6658057cd62,
                limb1: 0x669b16288f3a4ae589594157,
                limb2: 0xa4df78286b7415fbe2488791,
                limb3: 0x141f543c1b0907ba55cdf68e
            }
        };

        let A2_evals: FunctionFeltEvaluations = FunctionFeltEvaluations {
            a_num: u384 {
                limb0: 0x57371e1d7cf1f6e748b3c52f,
                limb1: 0xb2e88fa863862b244a9ca362,
                limb2: 0x4ef8e55172e98d6e4808e06d,
                limb3: 0x10797c5ad88c652d79cda2da
            },
            a_den: u384 {
                limb0: 0xb54c39a30528e02dd0934040,
                limb1: 0x60d9e8a96827b43d87c747c2,
                limb2: 0xefe565c2a3920cf91bae4098,
                limb3: 0x44486bf4e48ca9514e9e7c3
            },
            b_num: u384 {
                limb0: 0x4d4fe144319e125f53e1d42e,
                limb1: 0xbd27e561ca76e3d0e97f5efe,
                limb2: 0x33aaf4681d1f6da49e6b8e03,
                limb3: 0xf3b07b2a682a0fee19202b
            },
            b_den: u384 {
                limb0: 0xd887c6e9e582c957a72673b1,
                limb1: 0xbfc79c10af21740957552337,
                limb2: 0xa1d551c1ea080ef64a577f7e,
                limb3: 0x10856c676e8839cebe24bf65
            }
        };

        let xA0_power: u384 = u384 {
            limb0: 0xa9a96eb5ec900062e2192625,
            limb1: 0xc7dfc8acd273bf1b356aee33,
            limb2: 0x53295b0e704f87c33a15c96f,
            limb3: 0x1251542c2ec65551ce312a11
        };

        let xA2_power: u384 = u384 {
            limb0: 0x3f5c952b301851cc50ea213,
            limb1: 0x1c2b351b55f5995cb88a0438,
            limb2: 0x7dab7fac7037484e2914023a,
            limb3: 0xbc5e86309a952adaec8721c
        };
        assert_eq!(A0_evals_result, A0_evals);
        assert_eq!(A2_evals_result, A2_evals);
        assert_eq!(xA0_power_result, xA0_power);
        assert_eq!(xA2_power_result, xA2_power);
    }


    #[test]
    fn test_run_INIT_FUNCTION_CHALLENGE_DUPL_5_circuit_BN254() {
        let xA0: u384 = u384 {
            limb0: 0x582dd9727a089ca81cc5a8a0,
            limb1: 0x421aa15ef58c43ceb51d70d8,
            limb2: 0x1c9b512215203c7,
            limb3: 0x0
        };

        let xA2: u384 = u384 {
            limb0: 0x5cbbc08035475c5ef76dce6e,
            limb1: 0xf5fe0213792ecd7555c36c3d,
            limb2: 0x12f757e64ae9ee11,
            limb3: 0x0
        };

        let SumDlogDiv: FunctionFelt = FunctionFelt {
            a_num: array![
                u384 {
                    limb0: 0xf5492e22e0df7f74efe78b60,
                    limb1: 0x53b53b92a2cb5f388d9ecfb9,
                    limb2: 0x25f4079c2f1d9bef,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x1a42b62914afe646fe3216bd,
                    limb1: 0x4ec985ff94b28b9d88819f42,
                    limb2: 0x181a0875280a07ee,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xf217faac259cff81e5ce0ca6,
                    limb1: 0x390a9016cdec85da200f7753,
                    limb2: 0x208884d150de4292,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xc13e66af3c9590d33e2aad3e,
                    limb1: 0x5f59aa2c4a82e06a2f16fb50,
                    limb2: 0x2a71cb9e6b770df1,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x21da132cdc68d4fd0bd7696f,
                    limb1: 0x64d027590542bd7599e8c828,
                    limb2: 0x2cf0587013f2a37c,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x6c148fc69750ca7e246cb09c,
                    limb1: 0x5ac4b6c7a31034dd4c4b91fe,
                    limb2: 0xfe030c715a5712c,
                    limb3: 0x0
                }
            ]
                .span(),
            a_den: array![
                u384 {
                    limb0: 0x5e87905aa1fdcdf171df24d9,
                    limb1: 0x877a2133f2ed33e1a3155940,
                    limb2: 0x181775350ecfb95b,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x6acf49eb02284fd9689bba65,
                    limb1: 0xe6b920daba6a098ff642c8f3,
                    limb2: 0x1c3e376652177eb7,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x4b1678e45f20f4063438b4e4,
                    limb1: 0x174f7a54788c161ef3cc9d8a,
                    limb2: 0xbde8c13f344c911,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x46e785ad1bce35d8cbe88a3f,
                    limb1: 0x9b050db28ee4fd021cb66f67,
                    limb2: 0x9d92698b02de52c,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x7237d420b3dd77e1cbb02fe9,
                    limb1: 0x2f751bde66163e5beda2fc4c,
                    limb2: 0x1afd3411c4841a8d,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x3f7a27482cbb93c26e84f8ea,
                    limb1: 0x5723a95974151accf5a3e893,
                    limb2: 0x217e8b57efe6171b,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x766229cc5af95c78247f4d97,
                    limb1: 0x1624d318a32652e8a1ab17c0,
                    limb2: 0x30527ea37bb8c2f1,
                    limb3: 0x0
                }
            ]
                .span(),
            b_num: array![
                u384 {
                    limb0: 0x78cb124b7350d13421beaf,
                    limb1: 0x72f774b1b2f11ef9d4864482,
                    limb2: 0x1d9195f29e65736c,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x4c6e6fbb37fef6b501fda698,
                    limb1: 0xfa92cd28c4c536fb1d4d1180,
                    limb2: 0x13463040a100ed14,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x27fe1b4b9bf1f1d18b92c247,
                    limb1: 0xc058a332b4cfafa86c98f73d,
                    limb2: 0x5ec639b78aff58e,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xc2953f517f67ee1aad9d1f42,
                    limb1: 0x8b32992a3b7c1f9af5feba5e,
                    limb2: 0x19f084d5c3121af6,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xfbe86a8ea1cf0d1d47b3df41,
                    limb1: 0x4523dbbb1eeed2190588d91d,
                    limb2: 0x2ac884b2e23b580e,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x41aef3f7001098240a614be3,
                    limb1: 0xe3fbdbda86ae9d5c65ff6adc,
                    limb2: 0x2d700fdb94e4cc44,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xe8a56f31ac2c10d0c15648ff,
                    limb1: 0x15d38ca9986cc8d5322f1499,
                    limb2: 0x482587a09135087,
                    limb3: 0x0
                }
            ]
                .span(),
            b_den: array![
                u384 {
                    limb0: 0x8513d91e48622a674a294067,
                    limb1: 0x85e7425092f078b822696227,
                    limb2: 0xd75334da08c3a00,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x692a7bce1af55c2688083ebc,
                    limb1: 0x8b279c29a274c0d7f4a5cc36,
                    limb2: 0x2f738a7b674610eb,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xc9c5fef1e76f8a76c74f11cd,
                    limb1: 0x713eceb14ad12b4c47534952,
                    limb2: 0x245dedb55f2e9167,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x2835bcdb2347b24fa0f9c074,
                    limb1: 0x1eda4209b270af551f9078d5,
                    limb2: 0x19ad882161a53fdd,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x23b870f377cb1a27974fdedc,
                    limb1: 0x4c88b9d8ab12fb538f42cebe,
                    limb2: 0x287483af5aa3892a,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x6a447a90be0a5a5679009c61,
                    limb1: 0x7d25cefb7a0a02ba37cf8025,
                    limb2: 0x2019ad26b1d792a0,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xa6ed0ac07e22e1b751783032,
                    limb1: 0x71a8c9c60f6ab75bf55b2e5c,
                    limb2: 0x923d2894cd8ef24,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xd6a78b07eda9ab9bec60ffe,
                    limb1: 0x3739076a9f032cdce32866d3,
                    limb2: 0x16bee559068a3c38,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x1a4f7a165264961ab4414ae,
                    limb1: 0x1dbc24fd0a8aa1e45c7cbc62,
                    limb2: 0x3d483d9ef1c846,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xc069c542240397213a082921,
                    limb1: 0x30f2c48549b564fb92a651d7,
                    limb2: 0x1bc6f7411aff71ae,
                    limb3: 0x0
                }
            ]
                .span()
        };

        let (A0_evals_result, A2_evals_result, xA0_power_result, xA2_power_result) =
            run_INIT_FUNCTION_CHALLENGE_DUPL_5_circuit(
            xA0, xA2, SumDlogDiv, 0
        );
        let A0_evals: FunctionFeltEvaluations = FunctionFeltEvaluations {
            a_num: u384 {
                limb0: 0xef3ac326aca2905f7541fcff,
                limb1: 0x1b76ba6f6b6be1d1203aefb7,
                limb2: 0x48290e015dd9565,
                limb3: 0x0
            },
            a_den: u384 {
                limb0: 0x31b2348753ba1f080135b6e8,
                limb1: 0xa7ff0161d640428abdc2de8d,
                limb2: 0x1f4ac9cc53b22503,
                limb3: 0x0
            },
            b_num: u384 {
                limb0: 0xa2de1e4fc5b35e469285f163,
                limb1: 0x3620672114a96d1a22df18f7,
                limb2: 0x22e88b2d5f801765,
                limb3: 0x0
            },
            b_den: u384 {
                limb0: 0x358a14afd0ec4e6cd22250e,
                limb1: 0x38100cfca4a52905a5bc3ba0,
                limb2: 0x9a5c70be0d9e0cd,
                limb3: 0x0
            }
        };

        let A2_evals: FunctionFeltEvaluations = FunctionFeltEvaluations {
            a_num: u384 {
                limb0: 0x5a6c05eee4c0ba8385d632e0,
                limb1: 0xe3aa65544bf0f187bd97c8f7,
                limb2: 0x25e266f086d4999d,
                limb3: 0x0
            },
            a_den: u384 {
                limb0: 0xf035ca1eab98471369d39d8b,
                limb1: 0x8817f18bc02cde7476c095ee,
                limb2: 0x2800601f64f57449,
                limb3: 0x0
            },
            b_num: u384 {
                limb0: 0x1b345b0fff0785031a82cdac,
                limb1: 0x56a388dd1fc073575bd7ca44,
                limb2: 0x23245895c531e540,
                limb3: 0x0
            },
            b_den: u384 {
                limb0: 0xe7dd14d011eb029eded32d2f,
                limb1: 0x487d1d24cffb3b884ab5eb02,
                limb2: 0x2ef1a63dfe0bf46c,
                limb3: 0x0
            }
        };

        let xA0_power: u384 = u384 {
            limb0: 0x73d1665913bac19316eaf0a9,
            limb1: 0x7f232b3db300462596ff2184,
            limb2: 0xcc04edc762a713b,
            limb3: 0x0
        };

        let xA2_power: u384 = u384 {
            limb0: 0xf1604bc1b1f09bde62a5e4ee,
            limb1: 0x3dd6437534b4a4afa38a4a3e,
            limb2: 0x20c3241a4f4d6c39,
            limb3: 0x0
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
                limb0: 0x5194f73e4a8b27f2b93ecfb,
                limb1: 0xa483e0d35c2737c5f126e20b,
                limb2: 0xe62d839dc2f51f56dc19372f,
                limb3: 0xb06d703334528bd05c25ec8
            },
            y: u384 {
                limb0: 0x3345645d3162350034771205,
                limb1: 0xaf2e77a0c1b6ab31a190eb88,
                limb2: 0xba0dfe67b6a26cddb82cfb85,
                limb3: 0xdd96daf99eef8ea9f46e16a
            }
        };

        let q: G2Point = G2Point {
            x0: u384 {
                limb0: 0xb551b081ec6333862817767,
                limb1: 0xf8dfdcc3ba4ff15b76781a98,
                limb2: 0x5315d36ca47c32b6e6309cc6,
                limb3: 0xd9780e70a71d71b6277fee2
            },
            x1: u384 {
                limb0: 0x984dd4e906af9e5b89424412,
                limb1: 0xe823385355e5934cbf65c622,
                limb2: 0x2ef2f04d949e12d0071ca3,
                limb3: 0x15f94d65923bc2ea7111b9e7
            },
            y0: u384 {
                limb0: 0x1fb16aaa761ee737c50d0ec3,
                limb1: 0xa1bec5cf9b9c7f1fb0790711,
                limb2: 0x117fca1a4fcbda7250fda661,
                limb3: 0x141db3f0aa20b36c0a5e0aa7
            },
            y1: u384 {
                limb0: 0xed3a60308c2e89e621c9674c,
                limb1: 0x1e0071ea675d4947402d1664,
                limb2: 0xc9610f66a21ff8d51c9f8638,
                limb3: 0x288cec93395d6c055ee2046
            }
        };

        let a: u384 = u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 };

        let b: u384 = u384 { limb0: 0x4, limb1: 0x0, limb2: 0x0, limb3: 0x0 };

        let b20: u384 = u384 { limb0: 0x4, limb1: 0x0, limb2: 0x0, limb3: 0x0 };

        let b21: u384 = u384 { limb0: 0x4, limb1: 0x0, limb2: 0x0, limb3: 0x0 };

        let (zero_check_0_result, zero_check_1_result, zero_check_2_result) =
            run_IS_ON_CURVE_G1_G2_circuit(
            p, q, a, b, b20, b21, 1
        );
        let zero_check_0: u384 = u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 };

        let zero_check_1: u384 = u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 };

        let zero_check_2: u384 = u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 };
        assert_eq!(zero_check_0_result, zero_check_0);
        assert_eq!(zero_check_1_result, zero_check_1);
        assert_eq!(zero_check_2_result, zero_check_2);
    }


    #[test]
    fn test_run_IS_ON_CURVE_G1_G2_circuit_BN254() {
        let p: G1Point = G1Point {
            x: u384 {
                limb0: 0x5c724369afbc772d02aed58e,
                limb1: 0x2cd3bc838c66439a3d6160b,
                limb2: 0x72f26b55fb56be1,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x772ca79c580e121ca148fe75,
                limb1: 0xce2f55e418ca01b3d6d1014b,
                limb2: 0x2884b1dc4e84e30f,
                limb3: 0x0
            }
        };

        let q: G2Point = G2Point {
            x0: u384 {
                limb0: 0xa30b422f34656d6c94e40be,
                limb1: 0x83069b5050fd7194c7e35d0c,
                limb2: 0xf0e8184945e8d34,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xde9079ee8fa5e15901dfef27,
                limb1: 0xdb602cf367841e5047ffab14,
                limb2: 0x1752c7b6b35af45,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x4dafbd7f615fd2aa9f5a0acc,
                limb1: 0x35c8bbffe201ffd56deb5dea,
                limb2: 0xa822a5ba029a283,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xec6d9e4fafec17b8404c0341,
                limb1: 0x17fe961ad4b8ee3bf2ade626,
                limb2: 0x1228147f83e3ea5,
                limb3: 0x0
            }
        };

        let a: u384 = u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 };

        let b: u384 = u384 { limb0: 0x3, limb1: 0x0, limb2: 0x0, limb3: 0x0 };

        let b20: u384 = u384 {
            limb0: 0x59dbefa33267e6dc24a138e5,
            limb1: 0x81be18991be06ac3b5b4c5e5,
            limb2: 0x2b149d40ceb8aaae,
            limb3: 0x0
        };

        let b21: u384 = u384 {
            limb0: 0xe52d1852e4a2bd0685c315d2,
            limb1: 0xcd2cafadeed8fdf4a74fa084,
            limb2: 0x9713b03af0fed4,
            limb3: 0x0
        };

        let (zero_check_0_result, zero_check_1_result, zero_check_2_result) =
            run_IS_ON_CURVE_G1_G2_circuit(
            p, q, a, b, b20, b21, 0
        );
        let zero_check_0: u384 = u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 };

        let zero_check_1: u384 = u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 };

        let zero_check_2: u384 = u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 };
        assert_eq!(zero_check_0_result, zero_check_0);
        assert_eq!(zero_check_1_result, zero_check_1);
        assert_eq!(zero_check_2_result, zero_check_2);
    }


    #[test]
    fn test_run_IS_ON_CURVE_G1_circuit_BLS12_381() {
        let p: G1Point = G1Point {
            x: u384 {
                limb0: 0xf5480a1d0bcfe938319c377a,
                limb1: 0x886e700770deb130d1df30fd,
                limb2: 0x5d4025e67b78ee593df4d3ce,
                limb3: 0xb0b068f62ab37c678dd5686
            },
            y: u384 {
                limb0: 0xa884b6870e3d545fdc0e9075,
                limb1: 0xa4fd1e96f874d6eba6b6a84e,
                limb2: 0xa721a254bbdf5004166d7cd2,
                limb3: 0xd02c5aaf9f6ccc8ae471bcb
            }
        };

        let a: u384 = u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 };

        let b: u384 = u384 { limb0: 0x4, limb1: 0x0, limb2: 0x0, limb3: 0x0 };

        let (zero_check_result) = run_IS_ON_CURVE_G1_circuit(p, a, b, 1);
        let zero_check: u384 = u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 };
        assert_eq!(zero_check_result, zero_check);
    }


    #[test]
    fn test_run_IS_ON_CURVE_G1_circuit_BN254() {
        let p: G1Point = G1Point {
            x: u384 {
                limb0: 0x236ca9312dad3661a37f2d6f,
                limb1: 0x98424c01caad7592315715d1,
                limb2: 0x795b9fd941b23c4,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0xc7ab5834609a54b8993ffd79,
                limb1: 0xe81cd490528b814ca632aace,
                limb2: 0x2d9ff53d3009e6f7,
                limb3: 0x0
            }
        };

        let a: u384 = u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 };

        let b: u384 = u384 { limb0: 0x3, limb1: 0x0, limb2: 0x0, limb3: 0x0 };

        let (zero_check_result) = run_IS_ON_CURVE_G1_circuit(p, a, b, 0);
        let zero_check: u384 = u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 };
        assert_eq!(zero_check_result, zero_check);
    }


    #[test]
    fn test_run_IS_ON_CURVE_G2_circuit_BLS12_381() {
        let p: G2Point = G2Point {
            x0: u384 {
                limb0: 0xce6a33cf76a69f2957ee9947,
                limb1: 0x5c9b8c25805b7fed75816ece,
                limb2: 0x1412f85106303c348364aa20,
                limb3: 0xa55ed0747c63e800ecff434
            },
            x1: u384 {
                limb0: 0x309d5012ea0244f2de034c47,
                limb1: 0xc6137eaef155f66bc4838408,
                limb2: 0xd7507e459f65c5643ee1a8ee,
                limb3: 0x15bee96d90d4e98d04abb7c4
            },
            y0: u384 {
                limb0: 0xbd1dc5485dc541d0a0847d53,
                limb1: 0x1fd5c81c9c20601ac3ebe439,
                limb2: 0x457426c6dd88ab1a06127d54,
                limb3: 0xb9d702423472251c2483571
            },
            y1: u384 {
                limb0: 0x8539a8baf078135258327613,
                limb1: 0xa8fad22da278d3e94c545dcf,
                limb2: 0xc2271da6f719d6cf66831c6f,
                limb3: 0xadbf20b84fca802fd29c900
            }
        };

        let a: u384 = u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 };

        let b20: u384 = u384 { limb0: 0x4, limb1: 0x0, limb2: 0x0, limb3: 0x0 };

        let b21: u384 = u384 { limb0: 0x4, limb1: 0x0, limb2: 0x0, limb3: 0x0 };

        let (zero_check_0_result, zero_check_1_result) = run_IS_ON_CURVE_G2_circuit(
            p, a, b20, b21, 1
        );
        let zero_check_0: u384 = u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 };

        let zero_check_1: u384 = u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 };
        assert_eq!(zero_check_0_result, zero_check_0);
        assert_eq!(zero_check_1_result, zero_check_1);
    }


    #[test]
    fn test_run_IS_ON_CURVE_G2_circuit_BN254() {
        let p: G2Point = G2Point {
            x0: u384 {
                limb0: 0x41ae8412748b5742e5987e35,
                limb1: 0x70b6f07ae05874272043b3e2,
                limb2: 0x1ea4a5e3e7bcb5a7,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x45f1e65b69a4ca614200fd1a,
                limb1: 0xdda99e9d2ba9551ca08b9d20,
                limb2: 0x71a44d22aa74ad0,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x401b65d2b556c7650d8d8d54,
                limb1: 0x362d0892dd0538cad085ded0,
                limb2: 0xc181b7749ed299,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xbbbc571167245e0849e65413,
                limb1: 0x25e3f53f4caefcbb88fc8f87,
                limb2: 0x19926a4627da9174,
                limb3: 0x0
            }
        };

        let a: u384 = u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 };

        let b20: u384 = u384 {
            limb0: 0x59dbefa33267e6dc24a138e5,
            limb1: 0x81be18991be06ac3b5b4c5e5,
            limb2: 0x2b149d40ceb8aaae,
            limb3: 0x0
        };

        let b21: u384 = u384 {
            limb0: 0xe52d1852e4a2bd0685c315d2,
            limb1: 0xcd2cafadeed8fdf4a74fa084,
            limb2: 0x9713b03af0fed4,
            limb3: 0x0
        };

        let (zero_check_0_result, zero_check_1_result) = run_IS_ON_CURVE_G2_circuit(
            p, a, b20, b21, 0
        );
        let zero_check_0: u384 = u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 };

        let zero_check_1: u384 = u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 };
        assert_eq!(zero_check_0_result, zero_check_0);
        assert_eq!(zero_check_1_result, zero_check_1);
    }


    #[test]
    fn test_run_RHS_FINALIZE_ACC_circuit_BLS12_381() {
        let acc: u384 = u384 {
            limb0: 0xba164bd79b6e9d9f30cee367,
            limb1: 0x8ffe34c0825979829bd14023,
            limb2: 0x3bb80f34ce6fb96603277872,
            limb3: 0x12536b94020e76f02a336ef6
        };

        let m: u384 = u384 {
            limb0: 0x9645db5694aaa8e07c907cae,
            limb1: 0x3c5b1b3ef1b49f8935efdefa,
            limb2: 0xc832e3b1fb30588b5753919a,
            limb3: 0x11c261b62f6857630b27cb71
        };

        let b: u384 = u384 {
            limb0: 0xcfae47102cfe3703f2339d8e,
            limb1: 0xd889becab9ab2e027ac2dcbd,
            limb2: 0x4704c811f8f590673c0fd2e1,
            limb3: 0x8d93faad7c2ba7a2c5b43f9
        };

        let xA: u384 = u384 {
            limb0: 0xeca11230fb998fc675bf1993,
            limb1: 0xda72679ebe35a929ce082540,
            limb2: 0xd8b15b60c29e2f6fbde83068,
            limb3: 0xac31faf25b5dc44bfde4a51
        };

        let Q_result: G1Point = G1Point {
            x: u384 {
                limb0: 0x176b1fe8c06e70e4490d8e00,
                limb1: 0xebad200a4249571aab7d2eb7,
                limb2: 0xde7159d04141792c0eaf5218,
                limb3: 0x8c3d6b8cd9e556a46207123
            },
            y: u384 {
                limb0: 0xd7973f891896e5727378e888,
                limb1: 0xa887a4644d5235b62636364d,
                limb2: 0x5bdfbeec99bebed2da03e794,
                limb3: 0x10008cca79a320033bed3397
            }
        };

        let (rhs_result) = run_RHS_FINALIZE_ACC_circuit(acc, m, b, xA, Q_result, 1);
        let rhs: u384 = u384 {
            limb0: 0x5e41388619f90940514161eb,
            limb1: 0xbc3d4c78810170257233df81,
            limb2: 0xf2d287b8e4495e6ae4adad8d,
            limb3: 0x1983550d2a598b9ffbf4cb91
        };
        assert_eq!(rhs_result, rhs);
    }


    #[test]
    fn test_run_RHS_FINALIZE_ACC_circuit_BN254() {
        let acc: u384 = u384 {
            limb0: 0x9a6a5f92cca74147f6be1f72,
            limb1: 0x49a3e80e966e12778c1745a7,
            limb2: 0x5dd4cdb71eacd05,
            limb3: 0x0
        };

        let m: u384 = u384 {
            limb0: 0xcd63118d57ad0a45ac224783,
            limb1: 0xc78e7b96030380ad8c5ea12,
            limb2: 0x1758d71456fdd8fb,
            limb3: 0x0
        };

        let b: u384 = u384 {
            limb0: 0x46b3336934b2ab4c3fdf8836,
            limb1: 0x3b48ea1f7a59ac2ffc85892b,
            limb2: 0x20bdd361c5af526,
            limb3: 0x0
        };

        let xA: u384 = u384 {
            limb0: 0x7df4e928afb884c925ed4ada,
            limb1: 0x7b6eac3dee0e6b166627f2b4,
            limb2: 0x3f79c98552fd62d,
            limb3: 0x0
        };

        let Q_result: G1Point = G1Point {
            x: u384 {
                limb0: 0x52129a6d818d9c029e4259ae,
                limb1: 0x2bd66f962382277b00a6f11f,
                limb2: 0x20a233054a4f3acc,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0xcf28efdcfebb0ae35e168837,
                limb1: 0xde334c149faa1dc14eda6fd6,
                limb2: 0x1275561f56759717,
                limb3: 0x0
            }
        };

        let (rhs_result) = run_RHS_FINALIZE_ACC_circuit(acc, m, b, xA, Q_result, 0);
        let rhs: u384 = u384 {
            limb0: 0x7a3762a975e264bdd2181ac8,
            limb1: 0xc2c152b9f19c1d114c944e7d,
            limb2: 0x17c1d9f1ff7b164,
            limb3: 0x0
        };
        assert_eq!(rhs_result, rhs);
    }


    #[test]
    fn test_run_SLOPE_INTERCEPT_SAME_POINT_circuit_BLS12_381() {
        let p: G1Point = G1Point {
            x: u384 {
                limb0: 0xe173f6b6afb797e9fa5d48b1,
                limb1: 0x31af511cfda8e179d093b1df,
                limb2: 0x6d960ea3bbe9fc4f0ad035d4,
                limb3: 0x10ff59e29ddbfcd39524ff65
            },
            y: u384 {
                limb0: 0x12cb5d71dda2a1be1f3491ed,
                limb1: 0xa2667051c0b3b6ec7ab6644c,
                limb2: 0x320d5bd3bc09ba54ded47023,
                limb3: 0xeb99d3b79165f88a81ac1b5
            }
        };

        let a: u384 = u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 };

        let (mb_result) = run_SLOPE_INTERCEPT_SAME_POINT_circuit(p, a, 1);
        let mb: SlopeInterceptOutput = SlopeInterceptOutput {
            m_A0: u384 {
                limb0: 0xffdf949b070f0d490c2a7a92,
                limb1: 0xd444615b1c2d9eec80887772,
                limb2: 0x776995ec878deeb467c6ba10,
                limb3: 0xe298364480e7ca8ff2d6934
            },
            b_A0: u384 {
                limb0: 0x96d3ff550b28e009e1d84a49,
                limb1: 0x4c1c22772d1dd80f63ad6d33,
                limb2: 0x84570ef6b4bc5ec568b38d4d,
                limb3: 0x14e0e941f3796e463522b14d
            },
            x_A2: u384 {
                limb0: 0x1e909c3c1ec06b49e0749cf2,
                limb1: 0x4369b4db98705892458144ad,
                limb2: 0x94bbc196cc304f3455b636ec,
                limb3: 0x6871063c40ae7508b0eea0b
            },
            y_A2: u384 {
                limb0: 0x63e2b64a530b3c0fd1b487e4,
                limb1: 0x60cd270962423eaf8a3b3947,
                limb2: 0xe684fe2b5145b997a01087f,
                limb3: 0x13ec0b2ab5fe434fd50f7786
            },
            coeff0: u384 {
                limb0: 0x78fcde15675aee8038216791,
                limb1: 0x35a602ba8899638e8cde3e73,
                limb2: 0x23cf5f37c0bf939b84ec59d2,
                limb3: 0x103417d12a19026146aea0c9
            },
            coeff2: u384 {
                limb0: 0x2a91b4df133bd3ee1fcc1d18,
                limb1: 0xf44e12a546ef1bd9aa794f8c,
                limb2: 0x7847e036161b01b7a8e3f86f,
                limb3: 0xde222f2d37befa9936f7616
            }
        };
        assert_eq!(mb_result, mb);
    }


    #[test]
    fn test_run_SLOPE_INTERCEPT_SAME_POINT_circuit_BN254() {
        let p: G1Point = G1Point {
            x: u384 {
                limb0: 0x5c4f5dca0c973b7f70bfff9,
                limb1: 0x188c2afab11eef5d48ecda3c,
                limb2: 0xc2fed35d36c49f1,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x9d7244ea10697ca42e2e066b,
                limb1: 0xfe18a519c7d68770dc48dbf9,
                limb2: 0x149bb528db998529,
                limb3: 0x0
            }
        };

        let a: u384 = u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 };

        let (mb_result) = run_SLOPE_INTERCEPT_SAME_POINT_circuit(p, a, 0);
        let mb: SlopeInterceptOutput = SlopeInterceptOutput {
            m_A0: u384 {
                limb0: 0xf751364cd48fa85709d299ba,
                limb1: 0xc4dafd9d033329f9966d925a,
                limb2: 0x2aae531c947a26db,
                limb3: 0x0
            },
            b_A0: u384 {
                limb0: 0xec7c953c2143cdaca4328235,
                limb1: 0x7a46a21e625fae0d75307c63,
                limb2: 0x2f74b3994d139ead,
                limb3: 0x0
            },
            x_A2: u384 {
                limb0: 0xc1a2671fecb574535b95cea5,
                limb1: 0x3727a434436dcae697291f68,
                limb2: 0x6f84270264933af,
                limb3: 0x0
            },
            y_A2: u384 {
                limb0: 0x533afb9d6a4735e5d82d656e,
                limb1: 0x5c4d76a7f5a16cf0c7cc69ed,
                limb2: 0x260abb9b55f522cf,
                limb3: 0x0
            },
            coeff0: u384 {
                limb0: 0x8998a39115907c78e11e4952,
                limb1: 0xa6a8d52323fe468aded9795d,
                limb2: 0x2a97a91fcba016d5,
                limb3: 0x0
            },
            coeff2: u384 {
                limb0: 0x3680184a891b7e1a5f61325,
                limb1: 0xd5431f9f9f194af5497fbf39,
                limb2: 0x59f515983dd6947,
                limb3: 0x0
            }
        };
        assert_eq!(mb_result, mb);
    }
}
