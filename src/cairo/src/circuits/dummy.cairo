use core::circuit::{
    RangeCheck96, AddMod, MulMod, u384, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
    circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, CircuitOutputsTrait,
    CircuitModulus, AddInputResultTrait, CircuitInputs, CircuitDefinition, CircuitData,
    CircuitInputAccumulator
};
use garaga::definitions::{
    get_a, get_b, get_p, get_g, get_min_one, G1Point, G2Point, E12D, G1G2Pair, BNProcessedPair,
    BLSProcessedPair
};
use core::option::Option;

fn run_DUMMY_circuit(mut input: Array<u384>, curve_index: usize) -> Array<u384> {
    // INPUT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 
    let t0 = circuit_sub(in0, in1);
    let t1 = circuit_inverse(in1);
    let t2 = circuit_mul(in0, t1);
    let t3 = circuit_add(t0, t2);
    let t4 = circuit_sub(t0, t2);
    let t5 = circuit_mul(t0, t2);
    let t6 = circuit_inverse(t2);
    let t7 = circuit_mul(t0, t6);

    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
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
    use garaga::definitions::{G1Point, G2Point, E12D, G1G2Pair, BNProcessedPair, BLSProcessedPair};

    use super::{run_DUMMY_circuit};

    #[test]
    fn test_run_DUMMY_circuit_BLS12_381() {
        let input = array![
            u384 { limb0: 44, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let got = run_DUMMY_circuit(input, 1);
        let exp = array![
            u384 { limb0: 40, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 11, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 51, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 29, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 440, limb1: 0, limb2: 0, limb3: 0 },
            u384 {
                limb0: 77576989647530933870697373948,
                limb1: 54828444686746539437310035408,
                limb2: 65193929579401548860616821922,
                limb3: 2926510466213160792940482160
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_DUMMY_circuit_BN254() {
        let input = array![
            u384 { limb0: 44, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let got = run_DUMMY_circuit(input, 0);
        let exp = array![
            u384 { limb0: 40, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 11, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 51, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 29, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 440, limb1: 0, limb2: 0, limb3: 0 },
            u384 {
                limb0: 34974942560477686674958027243,
                limb1: 14691955275960878495684230655,
                limb2: 2218998897056435878,
                limb3: 0
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }
}