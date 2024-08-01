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
use garaga::ec_ops::{SlopeInterceptOutput, FunctionFeltEvaluations, FunctionFelt};
use core::option::Option;

fn run_DUMMY_circuit(mut input: Array<u384>, curve_index: usize) -> Array<u384> {
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

    let modulus = get_p(curve_index);
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([modulus.limb0, modulus.limb1, modulus.limb2, modulus.limb3])
        .unwrap();

    let mut circuit_inputs = (t0, t2, t3, t4, t5, t7,).new_inputs();
    // Prefill constants:

    let mut input = input;
    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res = array![
        outputs.get_output(t0),
        outputs.get_output(t2),
        outputs.get_output(t3),
        outputs.get_output(t4),
        outputs.get_output(t5),
        outputs.get_output(t7)
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
    use garaga::ec_ops::{SlopeInterceptOutput, FunctionFeltEvaluations, FunctionFelt};

    use super::{run_DUMMY_circuit};

    #[test]
    fn test_run_DUMMY_circuit_BLS12_381() {
        let input = array![
            u384 { limb0: 0x2c, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 { limb0: 0x4, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
        ];
        let got = run_DUMMY_circuit(input, 1);
        let exp = array![
            u384 { limb0: 0x28, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 { limb0: 0xb, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 { limb0: 0x33, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 { limb0: 0x1d, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 { limb0: 0x1b8, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0xfaaa2e8b8973ffffffffe0fc,
                limb1: 0xb12906c62b2913b00b2745d0,
                limb2: 0xd2a727942488788d6fd34ca2,
                limb3: 0x974c0b2437453db040a0e70
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_DUMMY_circuit_BN254() {
        let input = array![
            u384 { limb0: 0x2c, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 { limb0: 0x4, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
        ];
        let got = run_DUMMY_circuit(input, 0);
        let exp = array![
            u384 { limb0: 0x28, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 { limb0: 0xb, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 { limb0: 0x33, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 { limb0: 0x1d, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 { limb0: 0x1b8, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x7102982b54cee4c8b84f89eb,
                limb1: 0x2f78e68b69af66c731ddfdff,
                limb2: 0x1ecb77bd78084ea6,
                limb3: 0x0
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }
}
