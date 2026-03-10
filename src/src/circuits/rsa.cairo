use core::circuit::{
    CircuitElement as CE, CircuitInput as CI, CircuitInputs, CircuitOutputsTrait, EvalCircuitTrait,
    circuit_add, circuit_inverse, circuit_mul, circuit_sub, u384,
};
use garaga::core::circuit::{AddInputResultTrait2, u288IntoCircuitInputValue};
use garaga::definitions::RSA2048Chunks;

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
