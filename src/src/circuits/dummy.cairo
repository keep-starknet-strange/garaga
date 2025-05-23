use core::circuit::{
    AddInputResultTrait, AddMod, CircuitData, CircuitDefinition, CircuitElement as CE,
    CircuitInput as CI, CircuitInputAccumulator, CircuitInputs, CircuitModulus, CircuitOutputsTrait,
    EvalCircuitResult, EvalCircuitTrait, MulMod, RangeCheck96, circuit_add, circuit_inverse,
    circuit_mul, circuit_sub, u384, u96,
};
use core::option::Option;
use garaga::core::circuit::{AddInputResultTrait2, IntoCircuitInputValue, u288IntoCircuitInputValue};
use garaga::definitions::{
    BLSProcessedPair, BNProcessedPair, E12D, E12DMulQuotient, E12T, G1G2Pair, G1Point, G2Line,
    G2Point, MillerLoopResultScalingFactor, get_BLS12_381_modulus, get_BN254_modulus, get_a, get_b,
    get_g, get_min_one, get_modulus, u288,
};
#[inline(always)]
pub fn run_DUMMY_circuit(mut input: Array<u384>, curve_index: usize) -> Array<u384> {
    // INPUT stack
    let (in0, in1) = (CE::<CI<0>> {}, CE::<CI<1>> {});
    let t0 = circuit_sub(in0, in1);
    let t1 = circuit_inverse(in1);
    let t2 = circuit_mul(in0, t1);
    let t3 = circuit_add(t0, t2);
    let t4 = circuit_sub(t0, t2);
    let t5 = circuit_mul(t0, t2);
    let t6 = circuit_inverse(t2);
    let t7 = circuit_mul(t0, t6);

    let modulus = get_modulus(curve_index);

    let mut circuit_inputs = (t0, t2, t3, t4, t5, t7).new_inputs();
    // Prefill constants:

    // Fill inputs:

    let mut input = input;
    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    }

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res = array![
        outputs.get_output(t0),
        outputs.get_output(t2),
        outputs.get_output(t3),
        outputs.get_output(t4),
        outputs.get_output(t5),
        outputs.get_output(t7),
    ];
    return res;
}

