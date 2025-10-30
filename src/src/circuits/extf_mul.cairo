use core::circuit::{
    CircuitElement as CE, CircuitInput as CI, CircuitInputs, CircuitOutputsTrait, EvalCircuitTrait,
    circuit_add, circuit_inverse, circuit_mul, circuit_sub, u384,
};
use garaga::core::circuit::{AddInputResultTrait2, u288IntoCircuitInputValue};
use garaga::definitions::{E12D, u288};
#[inline(always)]
pub fn run_BLS12_381_EVAL_E12D_circuit(f: E12D<u384>, z: u384) -> (u384,) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let in12 = CE::<CI<12>> {};
    let t0 = circuit_mul(in11, in12); // Eval X Horner step: multiply by z
    let t1 = circuit_add(in10, t0); // Eval X Horner step: add coefficient_10
    let t2 = circuit_mul(t1, in12); // Eval X Horner step: multiply by z
    let t3 = circuit_add(in9, t2); // Eval X Horner step: add coefficient_9
    let t4 = circuit_mul(t3, in12); // Eval X Horner step: multiply by z
    let t5 = circuit_add(in8, t4); // Eval X Horner step: add coefficient_8
    let t6 = circuit_mul(t5, in12); // Eval X Horner step: multiply by z
    let t7 = circuit_add(in7, t6); // Eval X Horner step: add coefficient_7
    let t8 = circuit_mul(t7, in12); // Eval X Horner step: multiply by z
    let t9 = circuit_add(in6, t8); // Eval X Horner step: add coefficient_6
    let t10 = circuit_mul(t9, in12); // Eval X Horner step: multiply by z
    let t11 = circuit_add(in5, t10); // Eval X Horner step: add coefficient_5
    let t12 = circuit_mul(t11, in12); // Eval X Horner step: multiply by z
    let t13 = circuit_add(in4, t12); // Eval X Horner step: add coefficient_4
    let t14 = circuit_mul(t13, in12); // Eval X Horner step: multiply by z
    let t15 = circuit_add(in3, t14); // Eval X Horner step: add coefficient_3
    let t16 = circuit_mul(t15, in12); // Eval X Horner step: multiply by z
    let t17 = circuit_add(in2, t16); // Eval X Horner step: add coefficient_2
    let t18 = circuit_mul(t17, in12); // Eval X Horner step: multiply by z
    let t19 = circuit_add(in1, t18); // Eval X Horner step: add coefficient_1
    let t20 = circuit_mul(t19, in12); // Eval X Horner step: multiply by z
    let t21 = circuit_add(in0, t20); // Eval X Horner step: add coefficient_0

    let modulus = crate::definitions::get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (t21,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(f.w0); // in0
    circuit_inputs = circuit_inputs.next_2(f.w1); // in1
    circuit_inputs = circuit_inputs.next_2(f.w2); // in2
    circuit_inputs = circuit_inputs.next_2(f.w3); // in3
    circuit_inputs = circuit_inputs.next_2(f.w4); // in4
    circuit_inputs = circuit_inputs.next_2(f.w5); // in5
    circuit_inputs = circuit_inputs.next_2(f.w6); // in6
    circuit_inputs = circuit_inputs.next_2(f.w7); // in7
    circuit_inputs = circuit_inputs.next_2(f.w8); // in8
    circuit_inputs = circuit_inputs.next_2(f.w9); // in9
    circuit_inputs = circuit_inputs.next_2(f.w10); // in10
    circuit_inputs = circuit_inputs.next_2(f.w11); // in11
    circuit_inputs = circuit_inputs.next_2(z); // in12

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let f_of_z: u384 = outputs.get_output(t21);
    return (f_of_z,);
}
#[inline(always)]
pub fn run_BN254_EVAL_E12D_circuit(f: E12D<u288>, z: u384) -> (u384,) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let in12 = CE::<CI<12>> {};
    let t0 = circuit_mul(in11, in12); // Eval X Horner step: multiply by z
    let t1 = circuit_add(in10, t0); // Eval X Horner step: add coefficient_10
    let t2 = circuit_mul(t1, in12); // Eval X Horner step: multiply by z
    let t3 = circuit_add(in9, t2); // Eval X Horner step: add coefficient_9
    let t4 = circuit_mul(t3, in12); // Eval X Horner step: multiply by z
    let t5 = circuit_add(in8, t4); // Eval X Horner step: add coefficient_8
    let t6 = circuit_mul(t5, in12); // Eval X Horner step: multiply by z
    let t7 = circuit_add(in7, t6); // Eval X Horner step: add coefficient_7
    let t8 = circuit_mul(t7, in12); // Eval X Horner step: multiply by z
    let t9 = circuit_add(in6, t8); // Eval X Horner step: add coefficient_6
    let t10 = circuit_mul(t9, in12); // Eval X Horner step: multiply by z
    let t11 = circuit_add(in5, t10); // Eval X Horner step: add coefficient_5
    let t12 = circuit_mul(t11, in12); // Eval X Horner step: multiply by z
    let t13 = circuit_add(in4, t12); // Eval X Horner step: add coefficient_4
    let t14 = circuit_mul(t13, in12); // Eval X Horner step: multiply by z
    let t15 = circuit_add(in3, t14); // Eval X Horner step: add coefficient_3
    let t16 = circuit_mul(t15, in12); // Eval X Horner step: multiply by z
    let t17 = circuit_add(in2, t16); // Eval X Horner step: add coefficient_2
    let t18 = circuit_mul(t17, in12); // Eval X Horner step: multiply by z
    let t19 = circuit_add(in1, t18); // Eval X Horner step: add coefficient_1
    let t20 = circuit_mul(t19, in12); // Eval X Horner step: multiply by z
    let t21 = circuit_add(in0, t20); // Eval X Horner step: add coefficient_0

    let modulus = crate::definitions::get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (t21,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(f.w0); // in0
    circuit_inputs = circuit_inputs.next_2(f.w1); // in1
    circuit_inputs = circuit_inputs.next_2(f.w2); // in2
    circuit_inputs = circuit_inputs.next_2(f.w3); // in3
    circuit_inputs = circuit_inputs.next_2(f.w4); // in4
    circuit_inputs = circuit_inputs.next_2(f.w5); // in5
    circuit_inputs = circuit_inputs.next_2(f.w6); // in6
    circuit_inputs = circuit_inputs.next_2(f.w7); // in7
    circuit_inputs = circuit_inputs.next_2(f.w8); // in8
    circuit_inputs = circuit_inputs.next_2(f.w9); // in9
    circuit_inputs = circuit_inputs.next_2(f.w10); // in10
    circuit_inputs = circuit_inputs.next_2(f.w11); // in11
    circuit_inputs = circuit_inputs.next_2(z); // in12

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let f_of_z: u384 = outputs.get_output(t21);
    return (f_of_z,);
}
