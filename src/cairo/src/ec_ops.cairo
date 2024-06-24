use core::circuit::{
    RangeCheck96, AddMod, MulMod, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
    circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, u384, CircuitOutputsTrait,
    CircuitModulus, FillInputResultTrait, CircuitInputs, FillInputResult, CircuitDefinition,
    CircuitData, CircuitInputAccumulator
};
use garaga::definitions::{get_a, get_b, get_p, get_g, get_min_one, G1Point};
use core::option::Option;


fn ec_add_unchecked(p1: G1Point, p2: G1Point, curve_index: usize) -> G1Point {
    let in1 = CircuitElement::<CircuitInput<0>> {}; // px
    let in2 = CircuitElement::<CircuitInput<1>> {}; // py
    let in3 = CircuitElement::<CircuitInput<2>> {}; // qx
    let in4 = CircuitElement::<CircuitInput<3>> {}; // qy

    let t0 = circuit_sub(in2, in4);
    let t1 = circuit_sub(in1, in3);
    let t2 = circuit_inverse(t1);
    let t3 = circuit_mul(t0, t2); // slope
    let t4 = circuit_mul(t3, t3); // slope^2

    let t5 = circuit_sub(t4, in1); // slope^2 - px
    let t6 = circuit_sub(t5, in3); // nx

    let t7 = circuit_sub(in1, t6); // px - nx
    let t8 = circuit_mul(t3, t7); // slope * (px - nx)
    let t9 = circuit_sub(t8, in2); // ny

    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();
    let outputs =
        match (t9,).new_inputs().next(p1.x).next(p1.y).next(p2.x).next(p2.y).done().eval(modulus) {
        EvalCircuitResult::Success(outputs) => { outputs },
        EvalCircuitResult::Failure((_, _)) => { panic!("Expected success") }
    };

    let x = outputs.get_output(t6);
    let y = outputs.get_output(t9);

    return G1Point { x: x, y: y };
}
impl FillInputResultDrop<C> of Drop<FillInputResult<C>>;


fn ec_add_unchecked2(mut input: Array<u384>, curve_index: usize) -> G1Point {
    let in1 = CircuitElement::<CircuitInput<0>> {}; // px
    let in2 = CircuitElement::<CircuitInput<1>> {}; // py
    let in3 = CircuitElement::<CircuitInput<2>> {}; // qx
    let in4 = CircuitElement::<CircuitInput<3>> {}; // qy

    let t0 = circuit_sub(in2, in4);
    let t1 = circuit_sub(in1, in3);
    let t2 = circuit_inverse(t1);
    let t3 = circuit_mul(t0, t2); // slope
    let t4 = circuit_mul(t3, t3); // slope^2

    let t5 = circuit_sub(t4, in1); // slope^2 - px
    let t6 = circuit_sub(t5, in3); // nx

    let t7 = circuit_sub(in1, t6); // px - nx
    let t8 = circuit_mul(t3, t7); // slope * (px - nx)
    let t9 = circuit_sub(t8, in2); // ny

    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t9,).new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        EvalCircuitResult::Success(outputs) => { outputs },
        EvalCircuitResult::Failure((_, _)) => { panic!("Expected success") }
    };

    let x = outputs.get_output(t6);
    let y = outputs.get_output(t9);

    return G1Point { x: x, y: y };
}

#[cfg(test)]
mod tests {
    use core::traits::TryInto;

    use core::circuit::{
        RangeCheck96, AddMod, MulMod, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
        circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, u384,
        CircuitOutputsTrait, CircuitModulus, FillInputResultTrait, CircuitInputs,
    };

    use super::{ec_add_unchecked, ec_add_unchecked2, G1Point};

    #[test]
    fn test_ec_add_unchecked() {
        let p1 = G1Point {
            x: u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 },
            y: u384 { limb0: 2, limb1: 0, limb2: 0, limb3: 0 }
        };
        let p2 = G1Point {
            x: u384 {
                limb0: 6972010542290859298145161171,
                limb1: 48130984231937642362735957673,
                limb2: 217937391675185666,
                limb3: 0
            },
            y: u384 {
                limb0: 70354117060174814309938406084,
                limb1: 71651066881622725552431866953,
                limb2: 1580046089645096082,
                limb3: 0
            }
        };
        let p3 = ec_add_unchecked(p1, p2, 0);
        assert_eq!(
            p3,
            G1Point {
                x: u384 {
                    limb0: 6722715950901854229040049136,
                    limb1: 75516999847165085857686607943,
                    limb2: 534168702278167103,
                    limb3: 0
                },
                y: u384 {
                    limb0: 3593358890951276345950085729,
                    limb1: 26402767470382383152362316724,
                    limb2: 3078097915416712233,
                    limb3: 0
                }
            }
        );
    }

    #[test]
    fn test_ec_add_unchecked2() {
        let inputs = array![
            u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 2, limb1: 0, limb2: 0, limb3: 0 },
            u384 {
                limb0: 6972010542290859298145161171,
                limb1: 48130984231937642362735957673,
                limb2: 217937391675185666,
                limb3: 0
            },
            u384 {
                limb0: 70354117060174814309938406084,
                limb1: 71651066881622725552431866953,
                limb2: 1580046089645096082,
                limb3: 0
            }
        ];

        let p3 = ec_add_unchecked2(inputs, 0);
        assert_eq!(
            p3,
            G1Point {
                x: u384 {
                    limb0: 6722715950901854229040049136,
                    limb1: 75516999847165085857686607943,
                    limb2: 534168702278167103,
                    limb3: 0
                },
                y: u384 {
                    limb0: 3593358890951276345950085729,
                    limb1: 26402767470382383152362316724,
                    limb2: 3078097915416712233,
                    limb3: 0
                }
            }
        );
    }
}
