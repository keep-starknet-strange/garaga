use core::circuit::{
    RangeCheck96, AddMod, MulMod, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
    circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, u384, CircuitOutputsTrait,
    CircuitModulus, FillInputResultTrait, CircuitInputs, FillInputResult, CircuitDefinition,
    CircuitData, CircuitInputAccumulator
};
use garaga::definitions::{get_a, get_b, get_p, get_g, get_min_one, G1Point};
use core::option::Option;
fn get_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit(
    mut input: Array<u384>, curve_index: usize
) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {};

    // INPUT stack
    let in1 = CircuitElement::<CircuitInput<1>> {};
    let in2 = CircuitElement::<CircuitInput<2>> {};
    let in3 = CircuitElement::<CircuitInput<3>> {};
    let in4 = CircuitElement::<CircuitInput<4>> {};
    let in5 = CircuitElement::<CircuitInput<5>> {};
    let in6 = CircuitElement::<CircuitInput<6>> {};
    let in7 = CircuitElement::<CircuitInput<7>> {};
    let in8 = CircuitElement::<CircuitInput<8>> {};
    let in9 = CircuitElement::<CircuitInput<9>> {};
    let in10 = CircuitElement::<CircuitInput<10>> {};
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

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        EvalCircuitResult::Success(outputs) => { outputs },
        EvalCircuitResult::Failure((_, _)) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t15);

    let res = array![o0];
    return res;
}

fn get_IS_ON_CURVE_G1_G2_circuit(mut input: Array<u384>, curve_index: usize) -> Array<u384> {
    // INPUT stack
    let in0 = CircuitElement::<CircuitInput<0>> {};
    let in1 = CircuitElement::<CircuitInput<1>> {};
    let in2 = CircuitElement::<CircuitInput<2>> {};
    let in3 = CircuitElement::<CircuitInput<3>> {};
    let in4 = CircuitElement::<CircuitInput<4>> {};
    let in5 = CircuitElement::<CircuitInput<5>> {};
    let in6 = CircuitElement::<CircuitInput<6>> {};
    let in7 = CircuitElement::<CircuitInput<7>> {};
    let in8 = CircuitElement::<CircuitInput<8>> {};
    let in9 = CircuitElement::<CircuitInput<9>> {};
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
    let t14 = circuit_mul(in2, t11);
    let t15 = circuit_mul(in3, t13);
    let t16 = circuit_sub(t14, t15);
    let t17 = circuit_mul(in2, t13);
    let t18 = circuit_mul(in3, t11);
    let t19 = circuit_add(t17, t18);
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

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        EvalCircuitResult::Success(outputs) => { outputs },
        EvalCircuitResult::Failure((_, _)) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t26);
    let o1 = outputs.get_output(t27);
    let o2 = outputs.get_output(t28);

    let res = array![o0, o1, o2];
    return res;
}

fn get_DERIVE_POINT_FROM_X_circuit(mut input: Array<u384>, curve_index: usize) -> Array<u384> {
    // INPUT stack
    let in0 = CircuitElement::<CircuitInput<0>> {};
    let in1 = CircuitElement::<CircuitInput<1>> {};
    let in2 = CircuitElement::<CircuitInput<2>> {};
    let in3 = CircuitElement::<CircuitInput<3>> {};

    // WITNESS stack
    let in4 = CircuitElement::<CircuitInput<4>> {};
    let in5 = CircuitElement::<CircuitInput<5>> {};
    let t0 = circuit_mul(in0, in0);
    let t1 = circuit_mul(in0, t0);
    let t2 = circuit_mul(in1, in0);
    let t3 = circuit_add(t2, in2);
    let t4 = circuit_add(t1, t3);
    let t5 = circuit_mul(in3, t4);
    let t6 = circuit_mul(in4, in4);
    let t7 = circuit_mul(in5, in5);

    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t4, t5, t6, t7, in4,).new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        EvalCircuitResult::Success(outputs) => { outputs },
        EvalCircuitResult::Failure((_, _)) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t4);
    let o1 = outputs.get_output(t5);
    let o2 = outputs.get_output(t6);
    let o3 = outputs.get_output(t7);
    let o4 = outputs.get_output(in4);

    let res = array![o0, o1, o2, o3, o4];
    return res;
}

fn get_DOUBLE_EC_POINT_circuit(mut input: Array<u384>, curve_index: usize) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {};

    // INPUT stack
    let in1 = CircuitElement::<CircuitInput<1>> {};
    let in2 = CircuitElement::<CircuitInput<2>> {};
    let in3 = CircuitElement::<CircuitInput<3>> {};
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

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        EvalCircuitResult::Success(outputs) => { outputs },
        EvalCircuitResult::Failure((_, _)) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t8);
    let o1 = outputs.get_output(t11);

    let res = array![o0, o1];
    return res;
}

fn get_RHS_FINALIZE_ACC_circuit(mut input: Array<u384>, curve_index: usize) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {};

    // INPUT stack
    let in1 = CircuitElement::<CircuitInput<1>> {};
    let in2 = CircuitElement::<CircuitInput<2>> {};
    let in3 = CircuitElement::<CircuitInput<3>> {};
    let in4 = CircuitElement::<CircuitInput<4>> {};
    let in5 = CircuitElement::<CircuitInput<5>> {};
    let in6 = CircuitElement::<CircuitInput<6>> {};
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

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        EvalCircuitResult::Success(outputs) => { outputs },
        EvalCircuitResult::Failure((_, _)) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t7);

    let res = array![o0];
    return res;
}

fn get_SLOPE_INTERCEPT_SAME_POINT_circuit(
    mut input: Array<u384>, curve_index: usize
) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {};
    let in1 = CircuitElement::<CircuitInput<1>> {};

    // INPUT stack
    let in2 = CircuitElement::<CircuitInput<2>> {};
    let in3 = CircuitElement::<CircuitInput<3>> {};
    let in4 = CircuitElement::<CircuitInput<4>> {};
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

    let mut circuit_inputs = (t5, t7, in2, in3, t10, t14, t31, t29,).new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        EvalCircuitResult::Success(outputs) => { outputs },
        EvalCircuitResult::Failure((_, _)) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t5);
    let o1 = outputs.get_output(t7);
    let o2 = outputs.get_output(in2);
    let o3 = outputs.get_output(in3);
    let o4 = outputs.get_output(t10);
    let o5 = outputs.get_output(t14);
    let o6 = outputs.get_output(t31);
    let o7 = outputs.get_output(t29);

    let res = array![o0, o1, o2, o3, o4, o5, o6, o7];
    return res;
}

fn get_IS_ON_CURVE_G1_circuit(mut input: Array<u384>, curve_index: usize) -> Array<u384> {
    // INPUT stack
    let in0 = CircuitElement::<CircuitInput<0>> {};
    let in1 = CircuitElement::<CircuitInput<1>> {};
    let in2 = CircuitElement::<CircuitInput<2>> {};
    let in3 = CircuitElement::<CircuitInput<3>> {};
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

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        EvalCircuitResult::Success(outputs) => { outputs },
        EvalCircuitResult::Failure((_, _)) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t6);

    let res = array![o0];
    return res;
}

fn get_ADD_EC_POINT_circuit(mut input: Array<u384>, curve_index: usize) -> Array<u384> {
    // INPUT stack
    let in0 = CircuitElement::<CircuitInput<0>> {};
    let in1 = CircuitElement::<CircuitInput<1>> {};
    let in2 = CircuitElement::<CircuitInput<2>> {};
    let in3 = CircuitElement::<CircuitInput<3>> {};
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

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        EvalCircuitResult::Success(outputs) => { outputs },
        EvalCircuitResult::Failure((_, _)) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t6);
    let o1 = outputs.get_output(t9);

    let res = array![o0, o1];
    return res;
}

