use core::circuit::{
    RangeCheck96, AddMod, MulMod, u384, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
    circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, CircuitOutputsTrait,
    CircuitModulus, AddInputResultTrait, CircuitInputs, CircuitDefinition, CircuitData,
    CircuitInputAccumulator
};
use garaga::definitions::{
    get_a, get_b, get_p, get_g, get_min_one, G1Point, G2Point, E12D, E12DMulQuotient, G1G2Pair,
    BNProcessedPair, BLSProcessedPair, MillerLoopResultScalingFactor
};
use core::option::Option;

fn run_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit(
    mut input: Array<u384>, curve_index: usize
) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0x0

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

    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t15,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);

    let mut input = input;
    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res = array![outputs.get_output(t15)];
    return res;
}

fn run_ADD_EC_POINT_circuit(mut input: Array<u384>, curve_index: usize) -> Array<u384> {
    // INPUT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
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

    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t6, t9,).new_inputs();
    // Prefill constants:

    let mut input = input;
    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res = array![outputs.get_output(t6), outputs.get_output(t9)];
    return res;
}

fn run_DOUBLE_EC_POINT_circuit(mut input: Array<u384>, curve_index: usize) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0x3

    // INPUT stack
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
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

    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t8, t11,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);

    let mut input = input;
    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res = array![outputs.get_output(t8), outputs.get_output(t11)];
    return res;
}

fn run_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit(
    mut input: Array<u384>, curve_index: usize
) -> Array<u384> {
    // INPUT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 
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

    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t62,).new_inputs();
    // Prefill constants:

    let mut input = input;
    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res = array![outputs.get_output(t62)];
    return res;
}

fn run_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit(
    mut input: Array<u384>, curve_index: usize
) -> Array<u384> {
    // INPUT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 
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

    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t80,).new_inputs();
    // Prefill constants:

    let mut input = input;
    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res = array![outputs.get_output(t80)];
    return res;
}

fn run_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit(
    mut input: Array<u384>, curve_index: usize
) -> Array<u384> {
    // INPUT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 
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

    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t98,).new_inputs();
    // Prefill constants:

    let mut input = input;
    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res = array![outputs.get_output(t98)];
    return res;
}

fn run_IS_ON_CURVE_G1_G2_circuit(mut input: Array<u384>, curve_index: usize) -> Array<u384> {
    // INPUT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
    let in9 = CircuitElement::<CircuitInput<9>> {}; // 
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

    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t26, t27, t28,).new_inputs();
    // Prefill constants:

    let mut input = input;
    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res = array![outputs.get_output(t26), outputs.get_output(t27), outputs.get_output(t28)];
    return res;
}

fn run_IS_ON_CURVE_G1_circuit(mut input: Array<u384>, curve_index: usize) -> Array<u384> {
    // INPUT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let t0 = circuit_mul(in1, in1);
    let t1 = circuit_mul(in0, in0);
    let t2 = circuit_mul(in0, t1);
    let t3 = circuit_mul(in2, in0);
    let t4 = circuit_add(t3, in3);
    let t5 = circuit_add(t2, t4);
    let t6 = circuit_sub(t0, t5);

    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t6,).new_inputs();
    // Prefill constants:

    let mut input = input;
    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res = array![outputs.get_output(t6)];
    return res;
}

fn run_RHS_FINALIZE_ACC_circuit(mut input: Array<u384>, curve_index: usize) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0x0

    // INPUT stack
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let t0 = circuit_sub(in4, in5);
    let t1 = circuit_mul(in2, in5);
    let t2 = circuit_add(t1, in3);
    let t3 = circuit_sub(in0, in6);
    let t4 = circuit_sub(t3, t2);
    let t5 = circuit_inverse(t4);
    let t6 = circuit_mul(t0, t5);
    let t7 = circuit_add(in1, t6);

    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t7,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);

    let mut input = input;
    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res = array![outputs.get_output(t7)];
    return res;
}

fn run_SLOPE_INTERCEPT_SAME_POINT_circuit(
    mut input: Array<u384>, curve_index: usize
) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0x3
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 0x0

    // INPUT stack
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
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

    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t5, t7, t10, t14, t31, t29,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x3, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next([0x0, 0x0, 0x0, 0x0]);

    let mut input = input;
    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res = array![
        outputs.get_output(t5),
        outputs.get_output(t7),
        outputs.get_output(t10),
        outputs.get_output(t14),
        outputs.get_output(t31),
        outputs.get_output(t29)
    ];
    return res;
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

    use super::{
        run_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit, run_ADD_EC_POINT_circuit,
        run_DOUBLE_EC_POINT_circuit, run_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit,
        run_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit, run_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit,
        run_IS_ON_CURVE_G1_G2_circuit, run_IS_ON_CURVE_G1_circuit, run_RHS_FINALIZE_ACC_circuit,
        run_SLOPE_INTERCEPT_SAME_POINT_circuit
    };

    #[test]
    fn test_run_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 48236672974334179109977992541,
                limb1: 52772261131906895400324717330,
                limb2: 58680986727142590413291888698,
                limb3: 125427789982295314476245312
            },
            u384 {
                limb0: 27907682019264955577444723898,
                limb1: 4355263602740404459285443583,
                limb2: 34370910611551282479913645959,
                limb3: 2405913213433732924241100710
            },
            u384 {
                limb0: 40094056984486425297894868013,
                limb1: 19140770129557362845433890742,
                limb2: 75252737910947413936148373983,
                limb3: 2662291159799633884827814773
            },
            u384 {
                limb0: 37916324419527928981375003573,
                limb1: 8304321158085738349121383472,
                limb2: 29689845389109744227457670868,
                limb3: 5450104296033158396567160121
            },
            u384 {
                limb0: 53957612108257091122007993452,
                limb1: 22997572988440093112322792644,
                limb2: 48724865905504296440658757309,
                limb3: 1736900013437018037278270961
            },
            u384 {
                limb0: 912990825318660284105510326,
                limb1: 21182635136874798837860311805,
                limb2: 57155051022259716099317127520,
                limb3: 6185271417459784204086313826
            },
            u384 { limb0: 53449051946651914701307420860, limb1: 14501757, limb2: 0, limb3: 0 },
            u384 { limb0: 60202447271442483542105352682, limb1: 483656830, limb2: 0, limb3: 0 },
            u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 },
            u384 {
                limb0: 54880396502181392957329877674,
                limb1: 31935979117156477062286671870,
                limb2: 20826981314825584179608359615,
                limb3: 8047903782086192180586325942
            }
        ];
        let got = run_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit(input, 1);
        let exp = array![
            u384 {
                limb0: 47191975890257107940052057228,
                limb1: 53268955230954544998016981221,
                limb2: 14052689568156691726722692993,
                limb3: 3283879197162547654486347240
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 45742550057374806329167237825,
                limb1: 5510726952699698538507522860,
                limb2: 3049538818873697689,
                limb3: 0
            },
            u384 {
                limb0: 15596568577007144946107732102,
                limb1: 19297690964877084931055598137,
                limb2: 1819563013969841841,
                limb3: 0
            },
            u384 {
                limb0: 43822460752391213489611866548,
                limb1: 75118984786188757236103963672,
                limb2: 3309626825146705442,
                limb3: 0
            },
            u384 {
                limb0: 7862869637678795077519372023,
                limb1: 4699109503247496940657468379,
                limb2: 767913315398900925,
                limb3: 0
            },
            u384 {
                limb0: 65917823739508736469247779160,
                limb1: 3098786748851022159658983169,
                limb2: 2488262035068768042,
                limb3: 0
            },
            u384 {
                limb0: 50853918540922815225247809382,
                limb1: 28712599458085412945819279336,
                limb2: 2179096613753899535,
                limb3: 0
            },
            u384 { limb0: 29223359368920413333441117546, limb1: 1266803654, limb2: 0, limb3: 0 },
            u384 { limb0: 60619417850417312561337014615, limb1: 130695199, limb2: 0, limb3: 0 },
            u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let got = run_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit(input, 0);
        let exp = array![
            u384 {
                limb0: 1340259879001784236130471393,
                limb1: 13660712802589127909524135549,
                limb2: 3365427384532902420,
                limb3: 0
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_ADD_EC_POINT_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 33309241899903041961513358397,
                limb1: 32760540889815297279239601937,
                limb2: 38086476236853588376511117836,
                limb3: 270965764379814188804131387
            },
            u384 {
                limb0: 72581860487504126768318944525,
                limb1: 31621145103658231914301769097,
                limb2: 55536431980683803821116358010,
                limb3: 6240987171472239626341717516
            },
            u384 {
                limb0: 72082562993444989327518483877,
                limb1: 13024464066649067809181363132,
                limb2: 56793349399505384299966686653,
                limb3: 184238452370141420282339148
            },
            u384 {
                limb0: 42199985773271920620978677540,
                limb1: 13916040143665985832289290704,
                limb2: 35162392551902207456764900673,
                limb3: 7418744371791558175413717229
            }
        ];
        let got = run_ADD_EC_POINT_circuit(input, 1);
        let exp = array![
            u384 {
                limb0: 26606800313786008572849856966,
                limb1: 55900062338705847244460856213,
                limb2: 8207948494874813321608342817,
                limb3: 3591115672623043846304312833
            },
            u384 {
                limb0: 39277942834501501310368560175,
                limb1: 8237852828377446336318041496,
                limb2: 56007541505134428411022168356,
                limb3: 1369959118870367205394143246
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_ADD_EC_POINT_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 49613233139976166820933933033,
                limb1: 43972812792898214110431846422,
                limb2: 3124149996396808164,
                limb3: 0
            },
            u384 {
                limb0: 63824609037301126063922625889,
                limb1: 20640785082980109702919037119,
                limb2: 2767657580781827941,
                limb3: 0
            },
            u384 {
                limb0: 16776647801889250781294719899,
                limb1: 53819387450153218721863223941,
                limb2: 3238971312040363041,
                limb3: 0
            },
            u384 {
                limb0: 73131808072361950503339604242,
                limb1: 72831540730642989035268380153,
                limb2: 1664095061258156717,
                limb3: 0
            }
        ];
        let got = run_ADD_EC_POINT_circuit(input, 0);
        let exp = array![
            u384 {
                limb0: 64557636454391543536058816495,
                limb1: 2087384318367081968443430132,
                limb2: 109001327450590800,
                limb3: 0
            },
            u384 {
                limb0: 8085146166888010828227289768,
                limb1: 37697351098583322000520696350,
                limb2: 2463462585271942076,
                limb3: 0
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_DOUBLE_EC_POINT_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 59993145362510832463963941446,
                limb1: 24093260381820070467875359559,
                limb2: 7664095297330292033859842374,
                limb3: 1594063512469875549599004872
            },
            u384 {
                limb0: 33576405834226714838700397072,
                limb1: 19109806014962667324703690329,
                limb2: 48993055774894028472456981736,
                limb3: 4139717787125758448256353972
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let got = run_DOUBLE_EC_POINT_circuit(input, 1);
        let exp = array![
            u384 {
                limb0: 6525088909606839605246043827,
                limb1: 16542261013743505285701806308,
                limb2: 65143067225854220899819657322,
                limb3: 4828985442979386055503344831
            },
            u384 {
                limb0: 68378118528657894197845811815,
                limb1: 22043262988598989471653792412,
                limb2: 25239935902906465557239002507,
                limb3: 3851126098992526465940689310
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_DOUBLE_EC_POINT_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 14851398790425281408725747707,
                limb1: 54165005602420261392867141973,
                limb2: 145287008867519146,
                limb3: 0
            },
            u384 {
                limb0: 64053397048797885251156030001,
                limb1: 34360415572814481112505250496,
                limb2: 630702696590238794,
                limb3: 0
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let got = run_DOUBLE_EC_POINT_circuit(input, 0);
        let exp = array![
            u384 {
                limb0: 64738051925517883470757500090,
                limb1: 74489092163442293378499844594,
                limb2: 1888842806392784043,
                limb3: 0
            },
            u384 {
                limb0: 61882520224793610057118644897,
                limb1: 51600441633547976350293086647,
                limb2: 2850111636632650310,
                limb3: 0
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 43841242362053459684090785305,
                limb1: 64240255443488604587374821128,
                limb2: 62374824215224853082901276642,
                limb3: 3430396176849037064580626027
            },
            u384 {
                limb0: 14795524108603081055843032705,
                limb1: 61594660931365678498565157644,
                limb2: 31476263509966268363435484884,
                limb3: 5801018881769889249070624680
            },
            u384 {
                limb0: 72181972195416164195345326146,
                limb1: 63673113199459344708055087488,
                limb2: 35543558094683217749894530541,
                limb3: 5998994623843089936411013246
            },
            u384 {
                limb0: 67881050017810763600865571352,
                limb1: 8898457633503693906605515203,
                limb2: 59407007050452817875359089909,
                limb3: 29726280058791523002213605
            },
            u384 {
                limb0: 73817756250123608230764455319,
                limb1: 65759471872075335618784711602,
                limb2: 42230562009807371284121866825,
                limb3: 5531882691531171699098511008
            },
            u384 {
                limb0: 37792171835193238017808722513,
                limb1: 79052609589392826466178763377,
                limb2: 51112107438967302768310466512,
                limb3: 3457290828953570698204716284
            },
            u384 {
                limb0: 44913346415415193260941275379,
                limb1: 12463380603984557499685059891,
                limb2: 8152966891038729248051251604,
                limb3: 6676165400853797752563222140
            },
            u384 {
                limb0: 18096062505878242703387918579,
                limb1: 203498347241549738566467938,
                limb2: 68368239133153753602248282483,
                limb3: 455378985045918642455531453
            },
            u384 {
                limb0: 30342759941037994388194955379,
                limb1: 14178745655674493063562262412,
                limb2: 67936976597592666962873319852,
                limb3: 7953670477608813919732602453
            },
            u384 {
                limb0: 58681592574590638774032038256,
                limb1: 17787935975239186632826170304,
                limb2: 32979245100565703294504246764,
                limb3: 3168484127393396634401731885
            },
            u384 {
                limb0: 6170849151853539503012653401,
                limb1: 9459916376982993164991213145,
                limb2: 71459129173163831485366911303,
                limb3: 2210317728927929159537912836
            },
            u384 {
                limb0: 77755617143852009941738526899,
                limb1: 31764539320310237713412520421,
                limb2: 36848556728080127032713095604,
                limb3: 7660645068258413493714438620
            },
            u384 {
                limb0: 25931451033492414976385080403,
                limb1: 36187160353237884000276405383,
                limb2: 15898807053542266727563936919,
                limb3: 7769383187976185666158852563
            },
            u384 {
                limb0: 49336765146084121130048487433,
                limb1: 29177642521004522530456337437,
                limb2: 39088059805565237823362633348,
                limb3: 7684002363095845199059810797
            },
            u384 {
                limb0: 71340467633755259940219860030,
                limb1: 63063521205150311407306886776,
                limb2: 505307660245121265920156293,
                limb3: 236795733043188210586458834
            },
            u384 {
                limb0: 27446513174394839845547916662,
                limb1: 54941625103216522139181847952,
                limb2: 75345211080808886447157286582,
                limb3: 7516070292820032529547637467
            },
            u384 {
                limb0: 67265183983479375960272605345,
                limb1: 24363503251417312230150175803,
                limb2: 41976227902008152972947384106,
                limb3: 4157654687621112832935688511
            },
            u384 {
                limb0: 4745376637116532048405043903,
                limb1: 11279989295633601330432025693,
                limb2: 7370329896385946009027402569,
                limb3: 2292393283743136608077810742
            },
            u384 {
                limb0: 41179567842552912655777309102,
                limb1: 70954994507766005171299948346,
                limb2: 77212185377988988310384255573,
                limb3: 5751673737567079236967486935
            },
            u384 {
                limb0: 10578056732552701320470445062,
                limb1: 31243728407906463024764981526,
                limb2: 44987393412080654169984735014,
                limb3: 6560526836423357238680339743
            }
        ];
        let got = run_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit(input, 1);
        let exp = array![
            u384 {
                limb0: 69150440884776464509805210617,
                limb1: 54308803248596749988098758151,
                limb2: 62245147033224538712863470546,
                limb3: 4877088602094363064461316595
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 13268259472981868365421112389,
                limb1: 46352131756625236806836889929,
                limb2: 2843863423214240149,
                limb3: 0
            },
            u384 {
                limb0: 76737231855177948808203514245,
                limb1: 54634224157169326523931280027,
                limb2: 609293085769401994,
                limb3: 0
            },
            u384 {
                limb0: 32588232865761331317945543626,
                limb1: 42920692865198747596796644719,
                limb2: 1292288524620745949,
                limb3: 0
            },
            u384 {
                limb0: 22109629374835879147832829060,
                limb1: 77111384800343837264156671167,
                limb2: 3063898201025651161,
                limb3: 0
            },
            u384 {
                limb0: 24107147632521216287129241473,
                limb1: 46679700613611998209717953614,
                limb2: 2329384646076374441,
                limb3: 0
            },
            u384 {
                limb0: 34705519720342937325384114955,
                limb1: 7544545746441526561568429662,
                limb2: 321838271172728463,
                limb3: 0
            },
            u384 {
                limb0: 54240729226336754529891271225,
                limb1: 60872072766243616304862081407,
                limb2: 257968258960322105,
                limb3: 0
            },
            u384 {
                limb0: 2543242936061279358354121977,
                limb1: 31783549287040172917293284174,
                limb2: 305241059133926046,
                limb3: 0
            },
            u384 {
                limb0: 74705003839443619688298510508,
                limb1: 56879028618946847021972239934,
                limb2: 980566852076747479,
                limb3: 0
            },
            u384 {
                limb0: 31345188335193998570564539413,
                limb1: 50931972522891471604441323597,
                limb2: 658878908941684905,
                limb3: 0
            },
            u384 {
                limb0: 19539844265600609273886224350,
                limb1: 42702180300091913904288405785,
                limb2: 3444993136106080444,
                limb3: 0
            },
            u384 {
                limb0: 49711396943153995822956410677,
                limb1: 53913276305137721624552051841,
                limb2: 2750451209395678440,
                limb3: 0
            },
            u384 {
                limb0: 30234994542158251909307390480,
                limb1: 37082732317122305754957358281,
                limb2: 1159442963746785705,
                limb3: 0
            },
            u384 {
                limb0: 68197993831314783171983742905,
                limb1: 53897604287461337563561928239,
                limb2: 528276659766376889,
                limb3: 0
            },
            u384 {
                limb0: 42543172544982570052857664023,
                limb1: 60894664981146960725259421456,
                limb2: 1568782484594102931,
                limb3: 0
            },
            u384 {
                limb0: 34445652327236331720596696809,
                limb1: 257120338022751237048174282,
                limb2: 3330061854342727628,
                limb3: 0
            },
            u384 {
                limb0: 20867829993853018589638419949,
                limb1: 60368865098254360087322536075,
                limb2: 2341268480058990900,
                limb3: 0
            },
            u384 {
                limb0: 68969586761391561090281896559,
                limb1: 66683915952894400650221431918,
                limb2: 2341181818185855399,
                limb3: 0
            },
            u384 {
                limb0: 42018946958951763195093848207,
                limb1: 47453279052251022910409565149,
                limb2: 2253296117258904635,
                limb3: 0
            },
            u384 {
                limb0: 4589304846514288715766513407,
                limb1: 44950647632290901991879197353,
                limb2: 363202783876958070,
                limb3: 0
            }
        ];
        let got = run_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit(input, 0);
        let exp = array![
            u384 {
                limb0: 11700412489472584404906732428,
                limb1: 7017305906384258990996142651,
                limb2: 2188885089417606049,
                limb3: 0
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 60496054216794627907230883847,
                limb1: 61531619852785734994828031727,
                limb2: 39570610369239161867772003339,
                limb3: 5359885371985722808745182284
            },
            u384 {
                limb0: 55978050899771680915421509269,
                limb1: 20462354923328373145661101232,
                limb2: 40002096590721721009002242104,
                limb3: 3144109407828011100147314035
            },
            u384 {
                limb0: 69366444930671093997631557939,
                limb1: 6389788789772898712115050332,
                limb2: 17307784731118680092022161416,
                limb3: 40768416743364839609168258
            },
            u384 {
                limb0: 22497279753562664145434202668,
                limb1: 60386529417454953343223531453,
                limb2: 75088256275539322718177877,
                limb3: 1250337252585059137435895456
            },
            u384 {
                limb0: 30957467822565004701889134690,
                limb1: 10508725227063415207534086273,
                limb2: 63475809437467638138399163432,
                limb3: 3410768704590173371839257043
            },
            u384 {
                limb0: 52001922848060176808540064098,
                limb1: 31738402110962243170210078849,
                limb2: 31201437160781594938206481223,
                limb3: 319679280150480155137692892
            },
            u384 {
                limb0: 5917347804205769420250736244,
                limb1: 10783891381854403309469486300,
                limb2: 46325343455327234567189427004,
                limb3: 1046383683688273545515082947
            },
            u384 {
                limb0: 36924690380590967862976608918,
                limb1: 9565749738680690558728698969,
                limb2: 76426236609734878917236513267,
                limb3: 4475569969601403289527962120
            },
            u384 {
                limb0: 20996090809411546440115503396,
                limb1: 7163880851292165933199279562,
                limb2: 54354864813683854307720002356,
                limb3: 6979058360657268536196008059
            },
            u384 {
                limb0: 35827067536715676292544348083,
                limb1: 43585067484812994337723055170,
                limb2: 36606837810431653954207504286,
                limb3: 7861510954675653030454925708
            },
            u384 {
                limb0: 947325183894885814892067358,
                limb1: 61874025028763116286065085742,
                limb2: 10356328394643466366004856520,
                limb3: 3967170132682034132995856554
            },
            u384 {
                limb0: 49937316515061285623366883991,
                limb1: 6658289289666790543342233751,
                limb2: 20505884212309692175204166690,
                limb3: 742637117585841045972490592
            },
            u384 {
                limb0: 26268088921910470497576988578,
                limb1: 74655165590840111721485302034,
                limb2: 13309475840591605532939502444,
                limb3: 4289772931201045569880712598
            },
            u384 {
                limb0: 22172361885597528058522837674,
                limb1: 11775793557395009521987735059,
                limb2: 49056220142367616538349848865,
                limb3: 6410334770850698483171735342
            },
            u384 {
                limb0: 32641384981592063353943753503,
                limb1: 37952740471532231441661150929,
                limb2: 22166137323503418555850576640,
                limb3: 4151900611327085766794627615
            },
            u384 {
                limb0: 70089392902290126982618262179,
                limb1: 19739518692767069416071703067,
                limb2: 63554302996753127300981661331,
                limb3: 193415565121207755944564106
            },
            u384 {
                limb0: 61949749587453403001623514656,
                limb1: 38004516660137147237050316229,
                limb2: 38400265330758997095668352206,
                limb3: 5601937306886132012848160434
            },
            u384 {
                limb0: 30770735046537759660141500473,
                limb1: 2064921156230435128443880958,
                limb2: 17352567509445626353173001695,
                limb3: 8028678616239976086914494065
            },
            u384 {
                limb0: 4642075577178335597235685631,
                limb1: 37370687283300325309437702344,
                limb2: 60755496049358214252410232813,
                limb3: 2305164445725669914889440298
            },
            u384 {
                limb0: 7933459682592082500819271317,
                limb1: 19106093050569165904094138192,
                limb2: 64672773040040426273431559439,
                limb3: 7299490094363373731631236492
            },
            u384 {
                limb0: 66965298965771569064876393725,
                limb1: 18741511684061559311908234319,
                limb2: 63874554805216446065278933982,
                limb3: 3553216006864289057115239594
            },
            u384 {
                limb0: 78277916509034314249914029264,
                limb1: 76882035263351195442112525123,
                limb2: 24485707356574611790861865501,
                limb3: 375974721461996055111485899
            },
            u384 {
                limb0: 18430320993837076618076167040,
                limb1: 1578858175917430512009253525,
                limb2: 54152067805937494428832892,
                limb3: 6082096186212988915211338958
            },
            u384 {
                limb0: 10338447293859088791413926764,
                limb1: 14059819414854158758910360599,
                limb2: 66891076716614965935073474464,
                limb3: 589813710671499342754576843
            }
        ];
        let got = run_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit(input, 1);
        let exp = array![
            u384 {
                limb0: 67125973487036301729081121576,
                limb1: 67067346472218439998724380615,
                limb2: 43749532206529297295258947757,
                limb3: 7412785537965395872713593480
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 72352229351541557974185256159,
                limb1: 109695862189705609719928842,
                limb2: 586385101556276692,
                limb3: 0
            },
            u384 {
                limb0: 67992600012982420926133220046,
                limb1: 23077548885373181195572604447,
                limb2: 2828225239011667775,
                limb3: 0
            },
            u384 {
                limb0: 53667012199774782546845025478,
                limb1: 13988392951643632014579812896,
                limb2: 2855263762372963376,
                limb3: 0
            },
            u384 {
                limb0: 44657725054425516182046824655,
                limb1: 11558627534921529854849092531,
                limb2: 652105213504402783,
                limb3: 0
            },
            u384 {
                limb0: 1840421064017092026928335363,
                limb1: 27948250785264884498918334154,
                limb2: 1068426233884146722,
                limb3: 0
            },
            u384 {
                limb0: 72458689863252062882649001148,
                limb1: 57036135675129203477209168166,
                limb2: 2976109614092192022,
                limb3: 0
            },
            u384 {
                limb0: 10172219962658913022154488244,
                limb1: 75017080977665226557673008652,
                limb2: 761513689810464176,
                limb3: 0
            },
            u384 {
                limb0: 57831097157244995651582775035,
                limb1: 56485637013277440733112642140,
                limb2: 1840027204273873818,
                limb3: 0
            },
            u384 {
                limb0: 51488644415329370925019831230,
                limb1: 71274770803685296705510079601,
                limb2: 2082112336717404596,
                limb3: 0
            },
            u384 {
                limb0: 17802357378338648940166652311,
                limb1: 1666505890335566830781071452,
                limb2: 2554512134891071074,
                limb3: 0
            },
            u384 {
                limb0: 17447419136232834430860315795,
                limb1: 56080937434418198093665616470,
                limb2: 271507322399880886,
                limb3: 0
            },
            u384 {
                limb0: 71734764027497687440959466964,
                limb1: 26179242522752084688581078523,
                limb2: 2371126598316569875,
                limb3: 0
            },
            u384 {
                limb0: 53001879985015283259353718573,
                limb1: 42722513826086271939214843879,
                limb2: 3335874891481034863,
                limb3: 0
            },
            u384 {
                limb0: 45242695156380974609575304310,
                limb1: 19252224704182182869429558083,
                limb2: 2181202683696566687,
                limb3: 0
            },
            u384 {
                limb0: 15085828163067877367322517405,
                limb1: 52209992599600172477278698580,
                limb2: 1633909151565962963,
                limb3: 0
            },
            u384 {
                limb0: 37001506145532468353282582033,
                limb1: 4291883352266323174688581548,
                limb2: 3013531520861314659,
                limb3: 0
            },
            u384 {
                limb0: 19700584396745388153764221534,
                limb1: 42488934677374555174315232256,
                limb2: 646476748448880253,
                limb3: 0
            },
            u384 {
                limb0: 22068620180697579185898549089,
                limb1: 69283915317002778409893284629,
                limb2: 347651441635828348,
                limb3: 0
            },
            u384 {
                limb0: 68243106492345335480105108532,
                limb1: 7757128702044682744238220654,
                limb2: 3007487481293790040,
                limb3: 0
            },
            u384 {
                limb0: 66236929673530884233645586901,
                limb1: 7389038283343813755265297320,
                limb2: 3475207490854347497,
                limb3: 0
            },
            u384 {
                limb0: 4645575212695119035598803845,
                limb1: 170766220800888265123408008,
                limb2: 1800502560172094280,
                limb3: 0
            },
            u384 {
                limb0: 62120472738151456561021868284,
                limb1: 22599772358810472611047161037,
                limb2: 3212461292401604586,
                limb3: 0
            },
            u384 {
                limb0: 78865510699530816999690257603,
                limb1: 52438847471388457525305827726,
                limb2: 2244375768231156426,
                limb3: 0
            },
            u384 {
                limb0: 23507616024573787281496785879,
                limb1: 4633523845333701238548283116,
                limb2: 3392988848811485376,
                limb3: 0
            }
        ];
        let got = run_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit(input, 0);
        let exp = array![
            u384 {
                limb0: 56149420417655143552764995406,
                limb1: 59978217342842349576011470883,
                limb2: 3373506507271656045,
                limb3: 0
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 72760998883449091149937441771,
                limb1: 21799115456472667259088848348,
                limb2: 18093308432641166571953276813,
                limb3: 7474509786715543554740175447
            },
            u384 {
                limb0: 18568083059267431098794435162,
                limb1: 56054121190334040926346579969,
                limb2: 70142048487786816544466224608,
                limb3: 3120400755846491416320989737
            },
            u384 {
                limb0: 36748355101792542484939135636,
                limb1: 55862876098882738471339268708,
                limb2: 69787559107053596606012408124,
                limb3: 2193680074847360319431644522
            },
            u384 {
                limb0: 67178456715103861143048689732,
                limb1: 43264715172298749383509115771,
                limb2: 45207824928811352908365188878,
                limb3: 1447361342121276061096237789
            },
            u384 {
                limb0: 64577279908721386174794789181,
                limb1: 24907108233454494342466945937,
                limb2: 67908111770168902057747159494,
                limb3: 1994725789710580726331558872
            },
            u384 {
                limb0: 21871730784553316576434950652,
                limb1: 56202904434260642162509897076,
                limb2: 22825280702436729203895731307,
                limb3: 4865002098046641712899338761
            },
            u384 {
                limb0: 68189260662558153477366937782,
                limb1: 5746545669548060694591138760,
                limb2: 74626845220763029329559135537,
                limb3: 5803627964964290928411015764
            },
            u384 {
                limb0: 23908298603854518433034878604,
                limb1: 77315647957576627474484567987,
                limb2: 75163245493069305002155191458,
                limb3: 6330983676320406590079802170
            },
            u384 {
                limb0: 51433359944212393700415632258,
                limb1: 56028803026860032023718362118,
                limb2: 54949515655979808097747044564,
                limb3: 6077879426740409369525802739
            },
            u384 {
                limb0: 17686674048232355211437951826,
                limb1: 64527712955412260762175948946,
                limb2: 24309040432143254626251298850,
                limb3: 2916757735801575256638298165
            },
            u384 {
                limb0: 57743937535221270498258839327,
                limb1: 55618838948399163629915984853,
                limb2: 31025861287790800140530213365,
                limb3: 7633934417334254822694270272
            },
            u384 {
                limb0: 2565625325185230080191122291,
                limb1: 25211740988660702817566910719,
                limb2: 76655757371937296099830212884,
                limb3: 6334754770572764971339577774
            },
            u384 {
                limb0: 74212052866143791354856597164,
                limb1: 26237865948560622423822957557,
                limb2: 18855980204032897641702412826,
                limb3: 3164359735401159457495354440
            },
            u384 {
                limb0: 70142296522414031281204145019,
                limb1: 65098754930523037147146773222,
                limb2: 50634931589877877188794960003,
                limb3: 3325101673121088961000930254
            },
            u384 {
                limb0: 21012294365728636844673226467,
                limb1: 54919067362214587532625960584,
                limb2: 20334537087735252513690681260,
                limb3: 7134630623758607583482094765
            },
            u384 {
                limb0: 43260475469718456486356799164,
                limb1: 65664853888660161622342813507,
                limb2: 68457151091686200214546271935,
                limb3: 7509280335008960300696957392
            },
            u384 {
                limb0: 12886976524388451785367994000,
                limb1: 63318716991772148875701752458,
                limb2: 23365067570925703507485123576,
                limb3: 2586083534537305091630945533
            },
            u384 {
                limb0: 7376513018071596959638714157,
                limb1: 78061614724362819960498810336,
                limb2: 38246348411941524597680624152,
                limb3: 4271619388109816389470677683
            },
            u384 {
                limb0: 55237613803053228775908232936,
                limb1: 73331495372468222532108570610,
                limb2: 21016440078298361658532139927,
                limb3: 2945313380354027487850459538
            },
            u384 {
                limb0: 3932525030958027086582773483,
                limb1: 43548760452300846246942555487,
                limb2: 12168648380009916449494709345,
                limb3: 37787608488790655080073144
            },
            u384 {
                limb0: 23336611144902354034992059797,
                limb1: 49524807343031121413784923928,
                limb2: 15819868032809983940305074587,
                limb3: 2049563058355173548656697912
            },
            u384 {
                limb0: 23119685745786444708415514781,
                limb1: 37520132512170000727658230787,
                limb2: 24430272835174852208046981124,
                limb3: 4664007946374922456718486493
            },
            u384 {
                limb0: 52372989059525912160221098700,
                limb1: 50853893748824685616158954515,
                limb2: 14647799525565763895044069351,
                limb3: 3777650148330258044018176878
            },
            u384 {
                limb0: 35317956037616787345837726609,
                limb1: 34839825434652449351049937864,
                limb2: 17924759845035124888429267419,
                limb3: 5588027564529014563175844639
            },
            u384 {
                limb0: 59598208049049563435480094995,
                limb1: 7661571267936587783644900246,
                limb2: 27237959379534127513560214041,
                limb3: 4099925164915135700938319122
            },
            u384 {
                limb0: 68682419463365306209464187112,
                limb1: 45375100620501870089432556039,
                limb2: 37733385749381356428918526321,
                limb3: 3909953041194240936801047136
            },
            u384 {
                limb0: 9529711529043345246188615707,
                limb1: 35576593308901046269539147030,
                limb2: 77989667559084082161783000019,
                limb3: 2098458495270831050315222973
            },
            u384 {
                limb0: 66084853748912315779251299764,
                limb1: 25333164350881196743777913630,
                limb2: 72428320775747153895761804183,
                limb3: 861878056560279115845735205
            }
        ];
        let got = run_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit(input, 1);
        let exp = array![
            u384 {
                limb0: 49947855263014921995659587960,
                limb1: 36379035630600189095985257755,
                limb2: 7621805622580998446107130818,
                limb3: 3852240263722057852491640157
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 60560709830483091375804020284,
                limb1: 43197816287652788845584008834,
                limb2: 952729612994221368,
                limb3: 0
            },
            u384 {
                limb0: 10492971140459274210700811770,
                limb1: 44513061576255265500981326083,
                limb2: 1067917977423273551,
                limb3: 0
            },
            u384 {
                limb0: 39116622780220397755667403458,
                limb1: 22352500441126699540646417604,
                limb2: 3063271674606767109,
                limb3: 0
            },
            u384 {
                limb0: 37270314562710266601265233496,
                limb1: 70170752127981054059805844972,
                limb2: 859714678417469440,
                limb3: 0
            },
            u384 {
                limb0: 7623391984462887236582266015,
                limb1: 42491402479383729878308216988,
                limb2: 3452782009672681354,
                limb3: 0
            },
            u384 {
                limb0: 64559904209742266183304320555,
                limb1: 69704337930866810693557616486,
                limb2: 3299664043155415477,
                limb3: 0
            },
            u384 {
                limb0: 67559430074253106794595011940,
                limb1: 4506464022247638802529509883,
                limb2: 2341945580717447970,
                limb3: 0
            },
            u384 {
                limb0: 9498395769183164685220205206,
                limb1: 45134336288613177510213742987,
                limb2: 2669792903937128468,
                limb3: 0
            },
            u384 {
                limb0: 49072459003494725393436534870,
                limb1: 52082467902580653677531159892,
                limb2: 2606649103654554636,
                limb3: 0
            },
            u384 {
                limb0: 74055059530330231771921454741,
                limb1: 53061158448153114658671266402,
                limb2: 1448917347914504333,
                limb3: 0
            },
            u384 {
                limb0: 31357385428746531424018531805,
                limb1: 51141841383992554608876666149,
                limb2: 2108576180504140738,
                limb3: 0
            },
            u384 {
                limb0: 59568841990531844953896713482,
                limb1: 738046613222001001099970651,
                limb2: 2864591434320851751,
                limb3: 0
            },
            u384 {
                limb0: 78918891441719414915281368514,
                limb1: 42595786019864910729645154069,
                limb2: 2332981375169284075,
                limb3: 0
            },
            u384 {
                limb0: 73940426017474097647230135471,
                limb1: 5450208962476772138591757465,
                limb2: 1126563023504792259,
                limb3: 0
            },
            u384 {
                limb0: 12497991859429624369378841554,
                limb1: 43038160816172651229416840480,
                limb2: 1395114064909906243,
                limb3: 0
            },
            u384 {
                limb0: 78216661607741669574274640364,
                limb1: 41906999438047143355081431569,
                limb2: 3079975387921428976,
                limb3: 0
            },
            u384 {
                limb0: 9145201159815867598203053839,
                limb1: 58820309865218752061636884055,
                limb2: 716876953711284375,
                limb3: 0
            },
            u384 {
                limb0: 47919555913202845524736646361,
                limb1: 27165775241744433059614937901,
                limb2: 3170520892864132107,
                limb3: 0
            },
            u384 {
                limb0: 7312637792304348806296256704,
                limb1: 65707725566676067595956811555,
                limb2: 203314316937823219,
                limb3: 0
            },
            u384 {
                limb0: 61094359288010675957661195982,
                limb1: 77627591411109742420212671904,
                limb2: 745165346533507101,
                limb3: 0
            },
            u384 {
                limb0: 43708626113706013141793591071,
                limb1: 44439620535069455225037692732,
                limb2: 515927216987158182,
                limb3: 0
            },
            u384 {
                limb0: 69966896750444602556632215137,
                limb1: 11809297346016666377576163689,
                limb2: 166150464296701499,
                limb3: 0
            },
            u384 {
                limb0: 46151162575772561405597189355,
                limb1: 34051211886365655982861863138,
                limb2: 192901580404573442,
                limb3: 0
            },
            u384 {
                limb0: 71224651109362605387179230439,
                limb1: 77025323316292258909086735111,
                limb2: 183982628697211185,
                limb3: 0
            },
            u384 {
                limb0: 16643977945356356981949983936,
                limb1: 52839909067565107751874718774,
                limb2: 1631054796495564483,
                limb3: 0
            },
            u384 {
                limb0: 70048367821558724187387179708,
                limb1: 77155317606823885789624872003,
                limb2: 3456355443560131626,
                limb3: 0
            },
            u384 {
                limb0: 73746832228116322001147796294,
                limb1: 53075510893070141178755025066,
                limb2: 3389854563291057351,
                limb3: 0
            },
            u384 {
                limb0: 21138526233002691845902124138,
                limb1: 55560982282160920599510200465,
                limb2: 1764162309832058791,
                limb3: 0
            }
        ];
        let got = run_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit(input, 0);
        let exp = array![
            u384 {
                limb0: 2416167632796175225590722157,
                limb1: 48551152508610380532404214460,
                limb2: 2551930387880968103,
                limb3: 0
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_IS_ON_CURVE_G1_G2_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 3881018809921271934541826864,
                limb1: 64593930856761652403104488417,
                limb2: 51687612831028480094434490859,
                limb3: 6451395243134363385557637476
            },
            u384 {
                limb0: 73771732899400505226642774976,
                limb1: 77292648387036829692092888319,
                limb2: 67705688267726945654399135199,
                limb3: 843100134544885894591661870
            },
            u384 {
                limb0: 66609547339788937829063625846,
                limb1: 64502230214108702476017876154,
                limb2: 62551902897932773703424157198,
                limb3: 200159311825981504095706053
            },
            u384 {
                limb0: 58203289413273329398830008060,
                limb1: 10708502072587145958307542236,
                limb2: 62245259645274544392753755759,
                limb3: 3547280536548719816039237904
            },
            u384 {
                limb0: 11874497649279717125574075734,
                limb1: 76725924308597637572217578237,
                limb2: 72943459051995571486494287251,
                limb3: 2666709455792795377086696533
            },
            u384 {
                limb0: 77799268205487882445330517287,
                limb1: 10556565736115980790216886046,
                limb2: 56292284761257825999332855736,
                limb3: 3148537045961255164390913973
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let got = run_IS_ON_CURVE_G1_G2_circuit(input, 1);
        let exp = array![
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_IS_ON_CURVE_G1_G2_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 72303579505629692943460764225,
                limb1: 64383731061350301183472899978,
                limb2: 89326107581585284,
                limb3: 0
            },
            u384 {
                limb0: 2656445009483745034477298029,
                limb1: 40135187278221230646314852042,
                limb2: 748615905220004737,
                limb3: 0
            },
            u384 {
                limb0: 42079130131667592628129761030,
                limb1: 60081133978822882519077118249,
                limb2: 2876942460693786388,
                limb3: 0
            },
            u384 {
                limb0: 73767780233257603821087361087,
                limb1: 51865286289539495173932594223,
                limb2: 1030923927894331265,
                limb3: 0
            },
            u384 {
                limb0: 53907605619747425403594570682,
                limb1: 79164282061086811078259526201,
                limb2: 651114202088725253,
                limb3: 0
            },
            u384 {
                limb0: 72347515962958596214393340424,
                limb1: 71402752684547027195259763041,
                limb2: 176111217446792037,
                limb3: 0
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 3, limb1: 0, limb2: 0, limb3: 0 },
            u384 {
                limb0: 27810052284636130223308486885,
                limb1: 40153378333836448380344387045,
                limb2: 3104278944836790958,
                limb3: 0
            },
            u384 {
                limb0: 70926583776874220189091304914,
                limb1: 63498449372070794915149226116,
                limb2: 42524369107353300,
                limb3: 0
            }
        ];
        let got = run_IS_ON_CURVE_G1_G2_circuit(input, 0);
        let exp = array![
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_IS_ON_CURVE_G1_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 54315213640199676388484165664,
                limb1: 64615415478039789431052978499,
                limb2: 38289215076037097073681034912,
                limb3: 2766009169873783676650746428
            },
            u384 {
                limb0: 36163206015648980324790509040,
                limb1: 76871435785270656253319980793,
                limb2: 50183367621085513992950798907,
                limb3: 6507713653583326966784429613
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let got = run_IS_ON_CURVE_G1_circuit(input, 1);
        let exp = array![u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_IS_ON_CURVE_G1_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 52644011630690813522148617426,
                limb1: 77877746910620474679324982432,
                limb2: 488734493197095745,
                limb3: 0
            },
            u384 {
                limb0: 28626170957394882810848530650,
                limb1: 21031546388754091774793504063,
                limb2: 762300332427566472,
                limb3: 0
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 3, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let got = run_IS_ON_CURVE_G1_circuit(input, 0);
        let exp = array![u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_RHS_FINALIZE_ACC_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 61887017142914473275644872255,
                limb1: 58069159593218796186366579742,
                limb2: 61119004337032066715169330164,
                limb3: 3317788482512211835665493383
            },
            u384 {
                limb0: 41382289987431581744016102595,
                limb1: 19919202319845217730294557086,
                limb2: 51684320573642410086349200972,
                limb3: 637082786619363188068467331
            },
            u384 {
                limb0: 18860739372985077608702117557,
                limb1: 1597339562471310782720133099,
                limb2: 41999171353374307946274724142,
                limb3: 6421250430828036230872829080
            },
            u384 {
                limb0: 33531412186594188375450419478,
                limb1: 61501478416996508496401873448,
                limb2: 56243081304159867019996728910,
                limb3: 3554071927697800872237178435
            },
            u384 {
                limb0: 31733428187966668850473496906,
                limb1: 29940719153222705894421166076,
                limb2: 57705291141298402154268081267,
                limb3: 7069208859630757260952725013
            },
            u384 {
                limb0: 63285664815933159240534141829,
                limb1: 68407573407485116259723203122,
                limb2: 1356299378798219525379986798,
                limb3: 1006125680322252358066580687
            }
        ];
        let got = run_RHS_FINALIZE_ACC_circuit(input, 1);
        let exp = array![
            u384 {
                limb0: 65705911173912320345901936047,
                limb1: 60702219827707070483185943298,
                limb2: 48649405992156815700574841248,
                limb3: 4595269416342216134155663990
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_RHS_FINALIZE_ACC_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 48260330286441674708424697259,
                limb1: 42318920684542540519119384547,
                limb2: 1128991126786149844,
                limb3: 0
            },
            u384 {
                limb0: 7938632032443998648511649961,
                limb1: 17356141526537130956730385433,
                limb2: 1071065699868464167,
                limb3: 0
            },
            u384 {
                limb0: 37619741555986601766966302341,
                limb1: 43774217688409160760116850140,
                limb2: 765995078829870260,
                limb3: 0
            },
            u384 {
                limb0: 25465506521267819856047091585,
                limb1: 36391637133555566268841396773,
                limb2: 847591488136361640,
                limb3: 0
            },
            u384 {
                limb0: 22807643629428285123183151353,
                limb1: 55708330713379591852963876440,
                limb2: 2683820433665504527,
                limb3: 0
            },
            u384 {
                limb0: 17858926073002335585446583990,
                limb1: 62282319402827862502223658486,
                limb2: 641547017572429827,
                limb3: 0
            }
        ];
        let got = run_RHS_FINALIZE_ACC_circuit(input, 0);
        let exp = array![
            u384 {
                limb0: 43020444810219973869643857067,
                limb1: 78487722760902767733668096942,
                limb2: 2450254110215152594,
                limb3: 0
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_SLOPE_INTERCEPT_SAME_POINT_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 10010207970548938423340187084,
                limb1: 7695130924251007745837131087,
                limb2: 10527721448494185790979828754,
                limb3: 2149731889427934112167082300
            },
            u384 {
                limb0: 37908424340347145152672916671,
                limb1: 40702460771288876327129173232,
                limb2: 35345233775361055390801829118,
                limb3: 6169516742962103203582227669
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let got = run_SLOPE_INTERCEPT_SAME_POINT_circuit(input, 1);
        let exp = array![
            u384 {
                limb0: 78849410085420736430300157562,
                limb1: 8788679138520933549090517482,
                limb2: 59451873475780250655343496866,
                limb3: 5833740416966162252301903396
            },
            u384 {
                limb0: 21675914025731754325157203463,
                limb1: 7874374851252702876782445364,
                limb2: 42239819010751327448395907278,
                limb3: 4626427321528444424984045586
            },
            u384 {
                limb0: 25443909781982522954719853322,
                limb1: 49510209134068618526843056024,
                limb2: 45213746093304262665924935879,
                limb3: 2721658076122121951681203019
            },
            u384 {
                limb0: 11180277778261171684704629184,
                limb1: 18343088927615677118300462259,
                limb2: 9594216486435462281493370043,
                limb3: 1172307550991555583868494305
            },
            u384 {
                limb0: 75155629151361031840445329950,
                limb1: 22472539885849054517756914794,
                limb2: 77364879924080831520412887399,
                limb3: 220185985603050420176263820
            },
            u384 {
                limb0: 27217601984882344894504770176,
                limb1: 68767139843120141544149223570,
                limb2: 115095602171498568942612897,
                limb3: 4648512715843110276745108912
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_SLOPE_INTERCEPT_SAME_POINT_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 6754777447406199233880053248,
                limb1: 29592157390458577971370257756,
                limb2: 3000117645115658293,
                limb3: 0
            },
            u384 {
                limb0: 74292046482889929051988509288,
                limb1: 63954496481719982841226773346,
                limb2: 2481793984440015144,
                limb3: 0
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let got = run_SLOPE_INTERCEPT_SAME_POINT_circuit(input, 0);
        let exp = array![
            u384 {
                limb0: 28410243153404370084288088563,
                limb1: 39482639662138611135709072649,
                limb2: 763429169832334703,
                limb3: 0
            },
            u384 {
                limb0: 63347016304765991054776207810,
                limb1: 25366636730535729198773503339,
                limb2: 3045097332156004237,
                limb3: 0
            },
            u384 {
                limb0: 7029259507251224309510592606,
                limb1: 4394235099959160960573638211,
                limb2: 2360694219009690802,
                limb3: 0
            },
            u384 {
                limb0: 10873665323371506257584653620,
                limb1: 26056128684821873069202969974,
                limb2: 190976246494716538,
                limb3: 0
            },
            u384 {
                limb0: 1010842944790402801638352442,
                limb1: 36815218695260472920363455031,
                limb2: 114829169171683136,
                limb3: 0
            },
            u384 {
                limb0: 55742525314635411403384754075,
                limb1: 14892224453606490110825079477,
                limb2: 2074969096309984395,
                limb3: 0
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }
}
