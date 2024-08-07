use garaga::definitions::{
    u384, E12D, E12DMulQuotient, MillerLoopResultScalingFactor, G1Point, G2Point
};
use garaga::groth16::{Groth16Proof, MPCheckHintBN254, MPCheckHintBLS12_381};
use garaga::ec_ops::{MSMHint, DerivePointFromXHint, FunctionFelt};

extern fn downcast<felt252, u96>(x: felt252) -> Option<u96> implicits(RangeCheck) nopanic;

// Return Ris len (# of E12D) * 12  and BigQ len (# of u384)
fn pairing_type_to_lengths(n_pair: usize, pairing_curve: usize) -> (usize, usize) {
    match pairing_curve {
        0 => match n_pair {
            // BN254 case
            0 => { // 2 pairing check
             (53 * 12, 87) },
            _ => { // 3 pairing check
             (53 * 12, 114) },
        },
        _ => match n_pair {
            // BLS12-381 case
            0 => { // 2 pairing check
             (36 * 12, 81) },
            _ => { // 3 pairing check
             (36 * 12, 105) },
        },
    }
}


fn parse_E12D(hint: Span<felt252>) -> E12D {
    E12D {
        w0: u384 {
            limb0: downcast(*hint.at(0)).unwrap(),
            limb1: downcast(*hint.at(1)).unwrap(),
            limb2: downcast(*hint.at(2)).unwrap(),
            limb3: downcast(*hint.at(3)).unwrap()
        },
        w1: u384 {
            limb0: downcast(*hint.at(4)).unwrap(),
            limb1: downcast(*hint.at(5)).unwrap(),
            limb2: downcast(*hint.at(6)).unwrap(),
            limb3: downcast(*hint.at(7)).unwrap()
        },
        w2: u384 {
            limb0: downcast(*hint.at(8)).unwrap(),
            limb1: downcast(*hint.at(9)).unwrap(),
            limb2: downcast(*hint.at(10)).unwrap(),
            limb3: downcast(*hint.at(11)).unwrap()
        },
        w3: u384 {
            limb0: downcast(*hint.at(12)).unwrap(),
            limb1: downcast(*hint.at(13)).unwrap(),
            limb2: downcast(*hint.at(14)).unwrap(),
            limb3: downcast(*hint.at(15)).unwrap()
        },
        w4: u384 {
            limb0: downcast(*hint.at(16)).unwrap(),
            limb1: downcast(*hint.at(17)).unwrap(),
            limb2: downcast(*hint.at(18)).unwrap(),
            limb3: downcast(*hint.at(19)).unwrap()
        },
        w5: u384 {
            limb0: downcast(*hint.at(20)).unwrap(),
            limb1: downcast(*hint.at(21)).unwrap(),
            limb2: downcast(*hint.at(22)).unwrap(),
            limb3: downcast(*hint.at(23)).unwrap()
        },
        w6: u384 {
            limb0: downcast(*hint.at(24)).unwrap(),
            limb1: downcast(*hint.at(25)).unwrap(),
            limb2: downcast(*hint.at(26)).unwrap(),
            limb3: downcast(*hint.at(27)).unwrap()
        },
        w7: u384 {
            limb0: downcast(*hint.at(28)).unwrap(),
            limb1: downcast(*hint.at(29)).unwrap(),
            limb2: downcast(*hint.at(30)).unwrap(),
            limb3: downcast(*hint.at(31)).unwrap()
        },
        w8: u384 {
            limb0: downcast(*hint.at(32)).unwrap(),
            limb1: downcast(*hint.at(33)).unwrap(),
            limb2: downcast(*hint.at(34)).unwrap(),
            limb3: downcast(*hint.at(35)).unwrap()
        },
        w9: u384 {
            limb0: downcast(*hint.at(36)).unwrap(),
            limb1: downcast(*hint.at(37)).unwrap(),
            limb2: downcast(*hint.at(38)).unwrap(),
            limb3: downcast(*hint.at(39)).unwrap()
        },
        w10: u384 {
            limb0: downcast(*hint.at(40)).unwrap(),
            limb1: downcast(*hint.at(41)).unwrap(),
            limb2: downcast(*hint.at(42)).unwrap(),
            limb3: downcast(*hint.at(43)).unwrap()
        },
        w11: u384 {
            limb0: downcast(*hint.at(44)).unwrap(),
            limb1: downcast(*hint.at(45)).unwrap(),
            limb2: downcast(*hint.at(46)).unwrap(),
            limb3: downcast(*hint.at(47)).unwrap()
        },
    }
}

fn parse_scaling_factor(hint: Span<felt252>) -> MillerLoopResultScalingFactor {
    MillerLoopResultScalingFactor {
        w0: u384 {
            limb0: downcast(*hint.at(0)).unwrap(),
            limb1: downcast(*hint.at(1)).unwrap(),
            limb2: downcast(*hint.at(2)).unwrap(),
            limb3: downcast(*hint.at(3)).unwrap()
        },
        w2: u384 {
            limb0: downcast(*hint.at(4)).unwrap(),
            limb1: downcast(*hint.at(5)).unwrap(),
            limb2: downcast(*hint.at(6)).unwrap(),
            limb3: downcast(*hint.at(7)).unwrap()
        },
        w4: u384 {
            limb0: downcast(*hint.at(8)).unwrap(),
            limb1: downcast(*hint.at(9)).unwrap(),
            limb2: downcast(*hint.at(10)).unwrap(),
            limb3: downcast(*hint.at(11)).unwrap()
        },
        w6: u384 {
            limb0: downcast(*hint.at(12)).unwrap(),
            limb1: downcast(*hint.at(13)).unwrap(),
            limb2: downcast(*hint.at(14)).unwrap(),
            limb3: downcast(*hint.at(15)).unwrap()
        },
        w8: u384 {
            limb0: downcast(*hint.at(16)).unwrap(),
            limb1: downcast(*hint.at(17)).unwrap(),
            limb2: downcast(*hint.at(18)).unwrap(),
            limb3: downcast(*hint.at(19)).unwrap()
        },
        w10: u384 {
            limb0: downcast(*hint.at(20)).unwrap(),
            limb1: downcast(*hint.at(21)).unwrap(),
            limb2: downcast(*hint.at(22)).unwrap(),
            limb3: downcast(*hint.at(23)).unwrap()
        },
    }
}

fn parse_E12DMulQuotient(hint: Span<felt252>) -> Box<E12DMulQuotient> {
    BoxTrait::new(
        E12DMulQuotient {
            w0: u384 {
                limb0: downcast(*hint.at(0)).unwrap(),
                limb1: downcast(*hint.at(1)).unwrap(),
                limb2: downcast(*hint.at(2)).unwrap(),
                limb3: downcast(*hint.at(3)).unwrap()
            },
            w1: u384 {
                limb0: downcast(*hint.at(4)).unwrap(),
                limb1: downcast(*hint.at(5)).unwrap(),
                limb2: downcast(*hint.at(6)).unwrap(),
                limb3: downcast(*hint.at(7)).unwrap()
            },
            w2: u384 {
                limb0: downcast(*hint.at(8)).unwrap(),
                limb1: downcast(*hint.at(9)).unwrap(),
                limb2: downcast(*hint.at(10)).unwrap(),
                limb3: downcast(*hint.at(11)).unwrap()
            },
            w3: u384 {
                limb0: downcast(*hint.at(12)).unwrap(),
                limb1: downcast(*hint.at(13)).unwrap(),
                limb2: downcast(*hint.at(14)).unwrap(),
                limb3: downcast(*hint.at(15)).unwrap()
            },
            w4: u384 {
                limb0: downcast(*hint.at(16)).unwrap(),
                limb1: downcast(*hint.at(17)).unwrap(),
                limb2: downcast(*hint.at(18)).unwrap(),
                limb3: downcast(*hint.at(19)).unwrap()
            },
            w5: u384 {
                limb0: downcast(*hint.at(20)).unwrap(),
                limb1: downcast(*hint.at(21)).unwrap(),
                limb2: downcast(*hint.at(22)).unwrap(),
                limb3: downcast(*hint.at(23)).unwrap()
            },
            w6: u384 {
                limb0: downcast(*hint.at(24)).unwrap(),
                limb1: downcast(*hint.at(25)).unwrap(),
                limb2: downcast(*hint.at(26)).unwrap(),
                limb3: downcast(*hint.at(27)).unwrap()
            },
            w7: u384 {
                limb0: downcast(*hint.at(28)).unwrap(),
                limb1: downcast(*hint.at(29)).unwrap(),
                limb2: downcast(*hint.at(30)).unwrap(),
                limb3: downcast(*hint.at(31)).unwrap()
            },
            w8: u384 {
                limb0: downcast(*hint.at(32)).unwrap(),
                limb1: downcast(*hint.at(33)).unwrap(),
                limb2: downcast(*hint.at(34)).unwrap(),
                limb3: downcast(*hint.at(35)).unwrap()
            },
            w9: u384 {
                limb0: downcast(*hint.at(36)).unwrap(),
                limb1: downcast(*hint.at(37)).unwrap(),
                limb2: downcast(*hint.at(38)).unwrap(),
                limb3: downcast(*hint.at(39)).unwrap()
            },
            w10: u384 {
                limb0: downcast(*hint.at(40)).unwrap(),
                limb1: downcast(*hint.at(41)).unwrap(),
                limb2: downcast(*hint.at(42)).unwrap(),
                limb3: downcast(*hint.at(43)).unwrap()
            }
        }
    )
}
// Return from hint
// lambda_root_inverse: E12D,
// w: MillerLoopResultScalingFactor,
// Ris: Span<E12D>,
// big_Q: Array<u384>,
// small_Q: E12DMulQuotient

fn parse_mp_check_hint_bn254(
    hint: Span<felt252>, pairing_curve: usize, n_pair: usize
) -> Box<MPCheckHintBN254> {
    let lambda_root = parse_E12D(hint);
    let lambda_root_inverse = parse_E12D(hint.slice(48, 48));
    let w: MillerLoopResultScalingFactor = parse_scaling_factor(hint.slice(48 + 48, 24));

    let (Ris_len, big_Q_len) = pairing_type_to_lengths(n_pair, pairing_curve);

    let mut Ris: Array<E12D> = ArrayTrait::new();
    let mut i = 0;
    let start_index = 48 + 48 + 24;
    while i != Ris_len {
        Ris.append(parse_E12D(hint.slice(start_index + i * 48, 48)));
        i += 1;
    };
    let mut big_Q: Array<u384> = ArrayTrait::new();

    let start_index = start_index + Ris_len * 48;

    while i != big_Q_len {
        big_Q
            .append(
                u384 {
                    limb0: downcast(*hint.at(start_index + i * 4)).unwrap(),
                    limb1: downcast(*hint.at(start_index + i * 4 + 1)).unwrap(),
                    limb2: downcast(*hint.at(start_index + i * 4 + 2)).unwrap(),
                    limb3: downcast(*hint.at(start_index + i * 4 + 3)).unwrap()
                }
            );
        i += 1;
    };

    // let start_index = start_index + big_Q_len * 4;
    // let small_Q: E12DMulQuotient = parse_E12DMulQuotient(hint.slice(start_index, 11 * 4));

    BoxTrait::new(
        MPCheckHintBN254 {
            lambda_root: lambda_root,
            lambda_root_inverse: lambda_root_inverse,
            w: w,
            Ris: Ris.span(),
            big_Q: big_Q,
        }
    )
}


fn parse_mp_check_hint_bls12_381(
    hint: Span<felt252>, pairing_curve: usize, n_pair: usize
) -> Box<MPCheckHintBLS12_381> {
    let lambda_root_inverse = parse_E12D(hint);
    let w: MillerLoopResultScalingFactor = parse_scaling_factor(hint.slice(48, 24));
    let (Ris_len, big_Q_len) = pairing_type_to_lengths(n_pair, pairing_curve);

    let mut Ris: Array<E12D> = ArrayTrait::new();
    let mut i = 0;
    let start_index = 48 + 24;
    while i != Ris_len {
        Ris.append(parse_E12D(hint.slice(start_index + i * 48, 48)));
        i += 1;
    };
    let mut big_Q: Array<u384> = ArrayTrait::new();

    let start_index = start_index + Ris_len * 48;

    while i != big_Q_len {
        big_Q
            .append(
                u384 {
                    limb0: downcast(*hint.at(start_index + i * 4)).unwrap(),
                    limb1: downcast(*hint.at(start_index + i * 4 + 1)).unwrap(),
                    limb2: downcast(*hint.at(start_index + i * 4 + 2)).unwrap(),
                    limb3: downcast(*hint.at(start_index + i * 4 + 3)).unwrap()
                }
            );
        i += 1;
    };

    // let start_index = start_index + big_Q_len * 4;

    // let small_Q: E12DMulQuotient = parse_E12DMulQuotient(hint.slice(start_index, 11 * 4));

    BoxTrait::new(
        MPCheckHintBLS12_381 {
            lambda_root_inverse: lambda_root_inverse, w: w, Ris: Ris.span(), big_Q: big_Q,
        }
    )
}

fn parse_G1Point(hint: Span<felt252>) -> G1Point {
    G1Point {
        x: u384 {
            limb0: downcast(*hint.at(0)).unwrap(),
            limb1: downcast(*hint.at(1)).unwrap(),
            limb2: downcast(*hint.at(2)).unwrap(),
            limb3: downcast(*hint.at(3)).unwrap()
        },
        y: u384 {
            limb0: downcast(*hint.at(4)).unwrap(),
            limb1: downcast(*hint.at(5)).unwrap(),
            limb2: downcast(*hint.at(6)).unwrap(),
            limb3: downcast(*hint.at(7)).unwrap()
        }
    }
}

fn parse_G2Point(hint: Span<felt252>) -> G2Point {
    G2Point {
        x0: u384 {
            limb0: downcast(*hint.at(0)).unwrap(),
            limb1: downcast(*hint.at(1)).unwrap(),
            limb2: downcast(*hint.at(2)).unwrap(),
            limb3: downcast(*hint.at(3)).unwrap()
        },
        x1: u384 {
            limb0: downcast(*hint.at(4)).unwrap(),
            limb1: downcast(*hint.at(5)).unwrap(),
            limb2: downcast(*hint.at(6)).unwrap(),
            limb3: downcast(*hint.at(7)).unwrap()
        },
        y0: u384 {
            limb0: downcast(*hint.at(8)).unwrap(),
            limb1: downcast(*hint.at(9)).unwrap(),
            limb2: downcast(*hint.at(10)).unwrap(),
            limb3: downcast(*hint.at(11)).unwrap()
        },
        y1: u384 {
            limb0: downcast(*hint.at(10)).unwrap(),
            limb1: downcast(*hint.at(11)).unwrap(),
            limb2: downcast(*hint.at(12)).unwrap(),
            limb3: downcast(*hint.at(13)).unwrap()
        }
    }
}

fn parse_groth16_proof(proof: Span<felt252>, n_public_inputs: usize) -> Box<Groth16Proof> {
    let a = parse_G1Point(proof);
    let b = parse_G2Point(proof.slice(8, 16));
    let c = parse_G1Point(proof.slice(24, 16));

    let mut public_inputs: Array<u256> = ArrayTrait::new();
    let mut i = 0;
    let start_index = 40;

    while i != n_public_inputs {
        public_inputs
            .append(
                u256 {
                    low: (*proof.at(start_index + i * 4)).try_into().unwrap(),
                    high: (*proof.at(start_index + i * 4 + 1)).try_into().unwrap()
                }
            );
        i += 1;
    };

    BoxTrait::new(Groth16Proof { a: a, b: b, c: c, public_inputs: public_inputs.span() })
}


fn parse_function_felt(hint: Span<felt252>, msm_size: usize) -> FunctionFelt {
    let mut a_num: Array<u384> = ArrayTrait::new();
    let mut a_den: Array<u384> = ArrayTrait::new();
    let mut b_num: Array<u384> = ArrayTrait::new();
    let mut b_den: Array<u384> = ArrayTrait::new();
    let an_len = msm_size + 1;
    let ad_len = msm_size + 2; // bn_len == ad_len
    let bd_len = msm_size + 5;
    let mut i = 0;
    while i != an_len {
        a_num
            .append(
                u384 {
                    limb0: downcast(*hint.at(i * 4)).unwrap(),
                    limb1: downcast(*hint.at(i * 4 + 1)).unwrap(),
                    limb2: downcast(*hint.at(i * 4 + 2)).unwrap(),
                    limb3: downcast(*hint.at(i * 4 + 3)).unwrap()
                }
            );
        i += 1;
    };
    let start_index = an_len * 4;
    let mut i = 0;
    while i != ad_len {
        a_den
            .append(
                u384 {
                    limb0: downcast(*hint.at(start_index + i * 4)).unwrap(),
                    limb1: downcast(*hint.at(start_index + i * 4 + 1)).unwrap(),
                    limb2: downcast(*hint.at(start_index + i * 4 + 2)).unwrap(),
                    limb3: downcast(*hint.at(start_index + i * 4 + 3)).unwrap()
                }
            );
        i += 1;
    };
    let start_index = start_index + ad_len * 4;
    let mut i = 0;
    while i != ad_len {
        b_num
            .append(
                u384 {
                    limb0: downcast(*hint.at(start_index + i * 4)).unwrap(),
                    limb1: downcast(*hint.at(start_index + i * 4 + 1)).unwrap(),
                    limb2: downcast(*hint.at(start_index + i * 4 + 2)).unwrap(),
                    limb3: downcast(*hint.at(start_index + i * 4 + 3)).unwrap()
                }
            );
        i += 1;
    };
    let start_index = start_index + ad_len * 4;
    let mut i = 0;
    while i != bd_len {
        b_den
            .append(
                u384 {
                    limb0: downcast(*hint.at(start_index + i * 4)).unwrap(),
                    limb1: downcast(*hint.at(start_index + i * 4 + 1)).unwrap(),
                    limb2: downcast(*hint.at(start_index + i * 4 + 2)).unwrap(),
                    limb3: downcast(*hint.at(start_index + i * 4 + 3)).unwrap()
                }
            );
        i += 1;
    };

    FunctionFelt {
        a_num: a_num.span(), a_den: a_den.span(), b_num: b_num.span(), b_den: b_den.span()
    }
}


fn parse_G1Points(points: Span<felt252>, n_elements: usize) -> Span<G1Point> {
    let mut array: Array<G1Point> = ArrayTrait::new();
    let mut i = 0;
    while i != n_elements {
        array
            .append(
                G1Point {
                    x: u384 {
                        limb0: downcast(*points.at(i)).unwrap(),
                        limb1: downcast(*points.at(i + 1)).unwrap(),
                        limb2: downcast(*points.at(i + 2)).unwrap(),
                        limb3: downcast(*points.at(i + 3)).unwrap()
                    },
                    y: u384 {
                        limb0: downcast(*points.at(i + 4)).unwrap(),
                        limb1: downcast(*points.at(i + 5)).unwrap(),
                        limb2: downcast(*points.at(i + 6)).unwrap(),
                        limb3: downcast(*points.at(i + 7)).unwrap()
                    }
                }
            );
        i += 8;
    };
    array.span()
}

fn parse_msm_hint(
    hint: Span<felt252>, msm_size: usize
) -> (Box<MSMHint>, Box<DerivePointFromXHint>) {
    let Q_low = parse_G1Point(hint);
    let Q_high = parse_G1Point(hint.slice(8, 8));
    let Q_high_shifted = parse_G1Point(hint.slice(16, 8));
    let ff_total_len = 4 * msm_size + 10;
    let SumDlogDivLow = parse_function_felt(hint.slice(24, ff_total_len), msm_size);
    let SumDlogDivHigh = parse_function_felt(hint.slice(24 + ff_total_len, ff_total_len), msm_size);
    let SumDlogDivHighShifted = parse_function_felt(
        hint.slice(24 + 2 * ff_total_len, 14), msm_size
    ); // Msm size = 1 for last FF 
    let start_index = 24 + 2 * ff_total_len + 14;
    let y_last_attempt = u384 {
        limb0: downcast(*hint.at(start_index)).unwrap(),
        limb1: downcast(*hint.at(start_index + 1)).unwrap(),
        limb2: downcast(*hint.at(start_index + 2)).unwrap(),
        limb3: downcast(*hint.at(start_index + 3)).unwrap()
    };

    let mut end_of_hint = hint.slice(start_index + 4, hint.len() - (start_index + 4));
    let (n_roots, rem) = core::traits::DivRem::div_rem(end_of_hint.len(), 4);
    assert!(rem == 0, "end_of_hint length must be divisible by 4");

    let mut g_rhs_sqrt: Array<u384> = ArrayTrait::new();
    let mut i = 0;

    while i != n_roots {
        g_rhs_sqrt
            .append(
                u384 {
                    limb0: downcast(*end_of_hint.at(i * 4)).unwrap(),
                    limb1: downcast(*end_of_hint.at(i * 4 + 1)).unwrap(),
                    limb2: downcast(*end_of_hint.at(i * 4 + 2)).unwrap(),
                    limb3: downcast(*end_of_hint.at(i * 4 + 3)).unwrap()
                }
            );
        i += 1;
    };

    (
        BoxTrait::new(
            MSMHint {
                Q_low: Q_low,
                Q_high: Q_high,
                Q_high_shifted: Q_high_shifted,
                SumDlogDivLow: SumDlogDivLow,
                SumDlogDivHigh: SumDlogDivHigh,
                SumDlogDivHighShifted: SumDlogDivHighShifted,
            }
        ),
        BoxTrait::new(
            DerivePointFromXHint { y_last_attempt: y_last_attempt, g_rhs_sqrt: g_rhs_sqrt, }
        )
    )
}
