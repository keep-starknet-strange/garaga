use core::array::ArrayTrait;
use core::circuit::{
    RangeCheck96, AddMod, MulMod, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
    circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, u384, CircuitOutputsTrait,
    CircuitModulus, AddInputResultTrait, CircuitInputs, CircuitDefinition, CircuitData,
    CircuitInputAccumulator
};
use garaga::definitions::{get_a, get_b, get_p, get_g, get_min_one, G1Point};
use core::option::Option;
use core::poseidon::hades_permutation;

#[derive(Drop)]
struct DerivePointFromXOutput {
    rhs: u384,
    g_rhs: u384,
    should_be_rhs_or_g_rhs: u384,
}

fn get_DERIVE_POINT_FROM_X_circuit(
    x: u384, sqrt_rhs_or_g_rhs: u384, curve_index: usize
) -> DerivePointFromXOutput {
    // INPUT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // x - "random" x coordinate
    let in1 = CircuitElement::<CircuitInput<1>> {}; // a - a in Weierstrass equation
    let in2 = CircuitElement::<CircuitInput<2>> {}; // b - b in Weierstrass equation
    let in3 = CircuitElement::<CircuitInput<3>> {}; // g - Fp* Generator

    // WITNESS stack
    let in4 = CircuitElement::<CircuitInput<4>> {}; // sqrt(rhs) or sqrt(g*rhs) 
    let t0 = circuit_mul(in0, in0); // x^2
    let t1 = circuit_mul(in0, t0); // x^3
    let t2 = circuit_mul(in1, in0); // a*x
    let t3 = circuit_add(t2, in2); // a*x + b
    let t4 = circuit_add(t1, t3); // x^3 + (a*x + b) = rhs
    let t5 = circuit_mul(in3, t4); // g * (x^3 + (a*x + b)) = g*rhs
    let t6 = circuit_mul(in4, in4); // should be rhs if sqrt(rhs) or g*rhs if sqrt(g*rhs) exists

    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t4, t5, t6,).new_inputs();

    circuit_inputs = circuit_inputs.next(x);
    circuit_inputs = circuit_inputs.next(get_a(curve_index));
    circuit_inputs = circuit_inputs.next(get_b(curve_index));
    circuit_inputs = circuit_inputs.next(get_g(curve_index));
    circuit_inputs = circuit_inputs.next(sqrt_rhs_or_g_rhs);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let rhs = outputs.get_output(t4); // rhs
    let g_rhs = outputs.get_output(t5); // g*rhs
    let should_be_rhs_or_grhs = outputs
        .get_output(t6); // should be rhs if sqrt(rhs) or g*rhs if sqrt(g*rhs) exists

    return DerivePointFromXOutput {
        rhs: rhs, g_rhs: g_rhs, should_be_rhs_or_g_rhs: should_be_rhs_or_grhs,
    };
}

// Derives a random elliptic curve (EC) point on a given curve from a (random) x coordinate.
//
// This function attempts to find a valid y-coordinate from a given x-coordinate on an elliptic
// curve defined by the equation y^2 = x^3 + ax + b.
// Parameters:
// - x: felt252 - The x-coordinate for which we want to derive the corresponding y-coordinate.
// - y_last_attempt: u384 - The valid y-coordinate of the last attempt.
// - g_rhs_sqrt: Array<u384> - An array of square roots of g*rhs, where g is a generator
// in Fp.
// - curve_index: usize - The index of the elliptic curve parameters to use.
//
// Returns:
// - G1Point - A point on the elliptic curve with the given x-coordinate and a valid y-coordinate.
//
// The inner principle of this function is that, if Fp is a prime field, z any element of Fp*,
// and g a generator of Fp*, then:
// If z has a square root in Fp, then g*z does not have a square root in Fp*.
// If z does not have a square root in Fp, then g*z has a square root in Fp*.
// Note: there is exactly (p-1)//2 square roots in Fp*.
fn derive_ec_point_from_X(
    mut x: felt252, y_last_attempt: u384, mut g_rhs_sqrt: Array<u384>, curve_index: usize,
) -> G1Point {
    let mut attempt: felt252 = 0;
    while let Option::Some(root) = g_rhs_sqrt.pop_front() {
        let x_u384: u384 = x.into();
        let res: DerivePointFromXOutput = get_DERIVE_POINT_FROM_X_circuit(
            x_u384, root, curve_index
        );
        assert!(
            res.should_be_rhs_or_g_rhs == res.g_rhs, "grhs!=(sqrt(g*rhs))^2 in attempt {attempt}"
        );

        let (new_x, _, _) = hades_permutation(x, attempt.into(), 2);
        x = new_x;
        attempt += 1;
    };

    let x_u384: u384 = x.into();
    let res: DerivePointFromXOutput = get_DERIVE_POINT_FROM_X_circuit(
        x_u384, y_last_attempt, curve_index
    );
    assert!(res.should_be_rhs_or_g_rhs == res.rhs, "unvalid y coordinate");
    return G1Point { x: x_u384, y: y_last_attempt };
}

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
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };

    let x = outputs.get_output(t6);
    let y = outputs.get_output(t9);

    return G1Point { x: x, y: y };
}


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
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let x = outputs.get_output(t6);
    let y = outputs.get_output(t9);

    return G1Point { x: x, y: y };
}

fn get_add_ec_point_circuit(mut input: Array<u384>, curve_index: usize) -> Array<u384> {
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

    let mut circuit_inputs = (t9,).new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t6);
    let o1 = outputs.get_output(t9);

    let res = array![o0, o1];
    return res;
}


#[cfg(test)]
mod tests {
    use core::traits::TryInto;

    use core::circuit::{
        RangeCheck96, AddMod, MulMod, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
        circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, u384,
        CircuitOutputsTrait, CircuitModulus, AddInputResultTrait, CircuitInputs, CircuitDefinition,
        CircuitData, CircuitInputAccumulator
    };

    use super::{
        ec_add_unchecked, ec_add_unchecked2, get_add_ec_point_circuit, G1Point,
        derive_ec_point_from_X
    };

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

    #[test]
    fn test_ec_add_unchecked3() {
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

        let p3 = get_add_ec_point_circuit(inputs, 0);
        assert_eq!(
            p3,
            array![
                u384 {
                    limb0: 6722715950901854229040049136,
                    limb1: 75516999847165085857686607943,
                    limb2: 534168702278167103,
                    limb3: 0
                },
                u384 {
                    limb0: 3593358890951276345950085729,
                    limb1: 26402767470382383152362316724,
                    limb2: 3078097915416712233,
                    limb3: 0
                }
            ]
        );
    }

    #[test]
    fn derive_ec_point_from_X_BN254_0() {
        let x: felt252 =
            1007924606664371314454745651482312426967359991013948795084104590968267883012;
        let y: u384 = u384 {
            limb0: 27714606479635523100598951153,
            limb1: 34868386485493864315220284141,
            limb2: 1519130443637890520,
            limb3: 0
        };
        let grhs_roots: Array<u384> = array![
            u384 {
                limb0: 34873921585975737735287544514,
                limb1: 75824041826137017845509324964,
                limb2: 187208958347329739,
                limb3: 0
            }
        ];
        let result = derive_ec_point_from_X(x, y, grhs_roots, 0);
        assert!(
            result
                .x == u384 {
                    limb0: 62660379282463401875295134940,
                    limb1: 73368200585075358810639862040,
                    limb2: 177398867278533950,
                    limb3: 0
                }
        );
        assert!(result.y == y);
    }


    #[test]
    fn derive_ec_point_from_X_BLS12_381_0() {
        let x: felt252 =
            1007924606664371314454745651482312426967359991013948795084104590968267883012;
        let y: u384 = u384 {
            limb0: 67531198318575421426300025691,
            limb1: 73079231539510663354129518416,
            limb2: 13251943114660016581709012614,
            limb3: 312421328302071775409629582
        };
        let grhs_roots: Array<u384> = array![
            u384 {
                limb0: 68021603415295632383289353247,
                limb1: 14347541238121938408363115646,
                limb2: 54988998339125932059796959279,
                limb3: 494992670041001062700538471
            }
        ];
        let result = derive_ec_point_from_X(x, y, grhs_roots, 1);
        assert!(
            result
                .x == u384 {
                    limb0: 62660379282463401875295134940,
                    limb1: 73368200585075358810639862040,
                    limb2: 177398867278533950,
                    limb3: 0
                }
        );
        assert!(result.y == y);
    }


    #[test]
    fn derive_ec_point_from_X_SECP256K1_0() {
        let x: felt252 =
            1007924606664371314454745651482312426967359991013948795084104590968267883012;
        let y: u384 = u384 {
            limb0: 34606645619261666887882469145,
            limb1: 34310340540651960142565999300,
            limb2: 7154540730595498546,
            limb3: 0
        };
        let grhs_roots: Array<u384> = array![
            u384 {
                limb0: 29115782825123595146650267768,
                limb1: 63981367585271686949344367625,
                limb2: 6097997740176893311,
                limb3: 0
            },
            u384 {
                limb0: 66260645944799995925272212427,
                limb1: 22310207976496367248630075299,
                limb2: 1431124550686470511,
                limb3: 0
            },
            u384 {
                limb0: 33082894703518262725666078097,
                limb1: 24682596414004853981531917491,
                limb2: 4643712938487018145,
                limb3: 0
            },
            u384 {
                limb0: 66880718245691397296801121512,
                limb1: 76565997951508614922957482510,
                limb2: 5012952563093764202,
                limb3: 0
            }
        ];
        let result = derive_ec_point_from_X(x, y, grhs_roots, 2);
        assert!(
            result
                .x == u384 {
                    limb0: 42929719520991302865932943121,
                    limb1: 36914558178536778654385124821,
                    limb2: 118195263393991001,
                    limb3: 0
                }
        );
        assert!(result.y == y);
    }


    #[test]
    fn derive_ec_point_from_X_SECP256R1_0() {
        let x: felt252 =
            1007924606664371314454745651482312426967359991013948795084104590968267883012;
        let y: u384 = u384 {
            limb0: 20053638866842022551859121301,
            limb1: 32086628798319651018449199897,
            limb2: 6914626262564250074,
            limb3: 0
        };
        let grhs_roots: Array<u384> = array![
            u384 {
                limb0: 393988862542943514351259350,
                limb1: 32631280720834460460687405392,
                limb2: 7629184566207618792,
                limb3: 0
            }
        ];
        let result = derive_ec_point_from_X(x, y, grhs_roots, 3);
        assert!(
            result
                .x == u384 {
                    limb0: 62660379282463401875295134940,
                    limb1: 73368200585075358810639862040,
                    limb2: 177398867278533950,
                    limb3: 0
                }
        );
        assert!(result.y == y);
    }


    #[test]
    fn derive_ec_point_from_X_X25519_0() {
        let x: felt252 =
            1007924606664371314454745651482312426967359991013948795084104590968267883012;
        let y: u384 = u384 {
            limb0: 6641231605643607855894531310,
            limb1: 28562104663165609178035840171,
            limb2: 4565350961645903027,
            limb3: 0
        };
        let grhs_roots: Array<u384> = array![
            u384 {
                limb0: 7105175563015008315685364011,
                limb1: 76416124497522470000489060934,
                limb2: 330980194138944710,
                limb3: 0
            },
            u384 {
                limb0: 38793056481542655932181586012,
                limb1: 57451582827274319204362394172,
                limb2: 2942017708458610346,
                limb3: 0
            },
            u384 {
                limb0: 14430532572489113284395332323,
                limb1: 26241382189639247952699002461,
                limb2: 2598004041982469908,
                limb3: 0
            },
            u384 {
                limb0: 49409567804625469691750341753,
                limb1: 64866096857366305012188395545,
                limb2: 1595126387735062936,
                limb3: 0
            }
        ];
        let result = derive_ec_point_from_X(x, y, grhs_roots, 4);
        assert!(
            result
                .x == u384 {
                    limb0: 42929719520991302865932943121,
                    limb1: 36914558178536778654385124821,
                    limb2: 118195263393991001,
                    limb3: 0
                }
        );
        assert!(result.y == y);
    }


    #[test]
    fn derive_ec_point_from_X_BN254_1() {
        let x: felt252 =
            1063560484360105189252690783610884672686565418691657713591359159370969850218;
        let y: u384 = u384 {
            limb0: 7541127677702363468415682117,
            limb1: 7339146545383179916410626057,
            limb2: 1662796485815941777,
            limb3: 0
        };
        let grhs_roots: Array<u384> = array![
            u384 {
                limb0: 56593029338919184351948309166,
                limb1: 78839133926349938496323925966,
                limb2: 1166934752106015978,
                limb3: 0
            },
            u384 {
                limb0: 63223781830975669344766943642,
                limb1: 74444744836329886611135077400,
                limb2: 1380913212054945422,
                limb3: 0
            },
            u384 {
                limb0: 50887689488123923580373597173,
                limb1: 66102011561815370814199355527,
                limb2: 762754245250277144,
                limb3: 0
            },
            u384 {
                limb0: 18359012771626800922322228576,
                limb1: 19701678288333074153024467662,
                limb2: 158067669538113323,
                limb3: 0
            }
        ];
        let result = derive_ec_point_from_X(x, y, grhs_roots, 0);
        assert!(
            result
                .x == u384 {
                    limb0: 24396693794304597105208684791,
                    limb1: 4207882195617269586684036873,
                    limb2: 341894036225903616,
                    limb3: 0
                }
        );
        assert!(result.y == y);
    }


    #[test]
    fn derive_ec_point_from_X_BLS12_381_1() {
        let x: felt252 =
            1063560484360105189252690783610884672686565418691657713591359159370969850218;
        let y: u384 = u384 {
            limb0: 16664622114157216710127118487,
            limb1: 34496886834924133882820211311,
            limb2: 14681766861219310585427272456,
            limb3: 142278354763043665247395944
        };
        let grhs_roots: Array<u384> = array![
            u384 {
                limb0: 28763020826406771731898346108,
                limb1: 2353016884227923852537348574,
                limb2: 34082131550706258092314435685,
                limb3: 1165206251617494340182481980
            },
            u384 {
                limb0: 37033693894667150389905038999,
                limb1: 10302644005127102463907644379,
                limb2: 78737921960701689473478891399,
                limb3: 3270535059343858278495456216
            },
            u384 {
                limb0: 21453169296718612908389560992,
                limb1: 13338169335698150965007865120,
                limb2: 57124080282056246848186485796,
                limb3: 1559916207367557786314641351
            },
            u384 {
                limb0: 75800631196261115574214565845,
                limb1: 73420942871209786314270923051,
                limb2: 49289097989605023512973388539,
                limb3: 1350666271416254326454023434
            },
            u384 {
                limb0: 61619728738907003718143370427,
                limb1: 60232573073365562843282670500,
                limb2: 1504560647451545717145868368,
                limb3: 2125971161844144636941270832
            }
        ];
        let result = derive_ec_point_from_X(x, y, grhs_roots, 1);
        assert!(
            result
                .x == u384 {
                    limb0: 40674640075959635844425879065,
                    limb1: 22285289032531025076675905605,
                    limb2: 530881566500206432,
                    limb3: 0
                }
        );
        assert!(result.y == y);
    }


    #[test]
    fn derive_ec_point_from_X_SECP256K1_1() {
        let x: felt252 =
            1063560484360105189252690783610884672686565418691657713591359159370969850218;
        let y: u384 = u384 {
            limb0: 61529979452557460149067588721,
            limb1: 14841798560705171636287708415,
            limb2: 1770331318768958527,
            limb3: 0
        };
        let grhs_roots: Array<u384> = array![
            u384 {
                limb0: 10785862971079680493708771474,
                limb1: 12156662556876153363522599492,
                limb2: 1774436630115181654,
                limb3: 0
            }
        ];
        let result = derive_ec_point_from_X(x, y, grhs_roots, 2);
        assert!(
            result
                .x == u384 {
                    limb0: 57958657987920053228408344703,
                    limb1: 63683415548830384065057176824,
                    limb2: 263481919888268803,
                    limb3: 0
                }
        );
        assert!(result.y == y);
    }


    #[test]
    fn derive_ec_point_from_X_SECP256R1_1() {
        let x: felt252 =
            1063560484360105189252690783610884672686565418691657713591359159370969850218;
        let y: u384 = u384 {
            limb0: 34169071209595369166351427566,
            limb1: 16738091740365154255463055601,
            limb2: 3510049088213307128,
            limb3: 0
        };
        let grhs_roots: Array<u384> = array![
            u384 {
                limb0: 72578578591589386637147258864,
                limb1: 51259380511610139263350403321,
                limb2: 1257103837234097545,
                limb3: 0
            }
        ];
        let result = derive_ec_point_from_X(x, y, grhs_roots, 3);
        assert!(
            result
                .x == u384 {
                    limb0: 57958657987920053228408344703,
                    limb1: 63683415548830384065057176824,
                    limb2: 263481919888268803,
                    limb3: 0
                }
        );
        assert!(result.y == y);
    }


    #[test]
    fn derive_ec_point_from_X_X25519_1() {
        let x: felt252 =
            1063560484360105189252690783610884672686565418691657713591359159370969850218;
        let y: u384 = u384 {
            limb0: 23844267126761620632980646996,
            limb1: 69199219782413262757458670200,
            limb2: 8935330945789737,
            limb3: 0
        };
        let grhs_roots: Array<u384> = array![];
        let result = derive_ec_point_from_X(x, y, grhs_roots, 4);
        assert!(
            result
                .x == u384 {
                    limb0: 77864287393115290533831713130,
                    limb1: 47687594959966383440346360609,
                    limb2: 169434960463419659,
                    limb3: 0
                }
        );
        assert!(result.y == y);
    }
}
