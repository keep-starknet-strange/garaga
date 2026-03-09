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
