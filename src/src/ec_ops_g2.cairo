use core::circuit::CircuitElement as CE;
use core::circuit::CircuitInput as CI;

use core::circuit::{
    u384, circuit_add, circuit_sub, circuit_mul, circuit_inverse, EvalCircuitTrait,
    CircuitOutputsTrait, CircuitModulus, CircuitInputs,
};
use core::option::Option;
use garaga::core::circuit::AddInputResultTrait2;
use garaga::definitions::{G2Point, G2PointZero, get_BLS12_381_modulus, get_b2, get_a, get_modulus};
use garaga::circuits::ec;
use garaga::utils::u384_assert_zero;
use garaga::basic_field_ops::neg_mod_p;


#[generate_trait]
impl G2PointImpl of G2PointTrait {
    fn assert_on_curve(self: @G2Point, curve_index: usize) {
        let (b20, b21) = get_b2(curve_index).unwrap();
        let (check0, check1) = ec::run_IS_ON_CURVE_G2_circuit(
            *self, get_a(curve_index), b20, b21, curve_index,
        );
        u384_assert_zero(check0);
        u384_assert_zero(check1);
    }
    fn is_on_curve(self: @G2Point, curve_index: usize) -> bool {
        let (b20, b21) = get_b2(curve_index).unwrap();
        let (check0, check1) = ec::run_IS_ON_CURVE_G2_circuit(
            *self, get_a(curve_index), b20, b21, curve_index,
        );
        return check0.is_zero() && check1.is_zero();
    }
    fn negate(self: @G2Point, curve_index: usize) -> G2Point {
        let modulus = get_modulus(curve_index);
        G2Point {
            x0: *self.x0,
            x1: *self.x1,
            y0: neg_mod_p(*self.y0, modulus),
            y1: neg_mod_p(*self.y1, modulus),
        }
    }
}

// G2 Ops for BLS12-381.

// Returns Option::None in case of error.
fn ec_mul(pt: G2Point, s: u256, curve_index: usize) -> Option<G2Point> {
    if pt.is_zero() {
        // Input point is at infinity, return it
        return Option::Some(pt);
    } else {
        // Point is not at infinity
        if pt.is_on_curve(curve_index) {
            if s == 0 {
                return Option::Some(G2PointZero::zero());
            } else if s == 1 {
                return Option::Some(pt);
            } else {
                // Point is on the curve.
                // s is >= 2.
                let bits = get_bits_little(s);
                let pt = ec_mul_inner(pt, bits, curve_index);
                match pt {
                    Option::Some(r) => Option::Some(r),
                    Option::None => Option::Some(G2PointZero::zero()),
                }
            }
        } else {
            // Point is not on the curve
            return Option::None;
        }
    }
}

// Returns the bits of the 256 bit number in little endian format.
fn get_bits_little(s: u256) -> Array<felt252> {
    let mut bits = ArrayTrait::new();
    let mut s_low = s.low;
    while s_low != 0 {
        let (q, r) = core::traits::DivRem::div_rem(s_low, 2);
        bits.append(r.into());
        s_low = q;
    };
    let mut s_high = s.high;
    if s_high != 0 {
        while bits.len() != 128 {
            bits.append(0);
        }
    }
    while s_high != 0 {
        let (q, r) = core::traits::DivRem::div_rem(s_high, 2);
        bits.append(r.into());
        s_high = q;
    };
    bits
}

#[inline]
fn ec_safe_add(P: G2Point, Q: G2Point, curve_index: usize) -> Option<G2Point> {
    // assumes that the points are on the curve and not the point at infinity.
    // Returns None if the points are the same and opposite y coordinates (Point at infinity)
    let same_x = eq_mod_p(P.x0, P.x1, Q.x0, Q.x1);

    if same_x {
        let opposite_y = eq_neg_mod_p(P.y0, P.y1, Q.y0, Q.y1);

        if opposite_y {
            return Option::None;
        } else {
            let (R) = ec::run_DOUBLE_EC_POINT_G2_A_EQ_0_circuit(P, curve_index);
            return Option::Some(R);
        }
    } else {
        let (R) = ec::run_ADD_EC_POINTS_G2_circuit(P, Q, curve_index);
        return Option::Some(R);
    }
}
// Should not be called outside of ec_mul.
// Returns Option::None in case of point at infinity.
// The size of bits array must be at minimum 2 and the point must be on the curve.
fn ec_mul_inner(pt: G2Point, mut bits: Array<felt252>, curve_index: usize) -> Option<G2Point> {
    let mut temp = pt;
    let mut result: Option<G2Point> = Option::None;
    for bit in bits {
        if bit != 0 {
            match result {
                Option::Some(R) => result = ec_safe_add(temp, R, curve_index),
                Option::None => result = Option::Some(temp),
            };
        };
        let (_temp) = ec::run_DOUBLE_EC_POINT_G2_A_EQ_0_circuit(temp, curve_index);
        temp = _temp;
    };

    return result;
}


// returns true if a == b mod p bls12-381
#[inline]
pub fn eq_mod_p(a0: u384, a1: u384, b0: u384, b1: u384) -> bool {
    let _a0 = CE::<CI<0>> {};
    let _a1 = CE::<CI<1>> {};
    let _b0 = CE::<CI<2>> {};
    let _b1 = CE::<CI<3>> {};
    let sub0 = circuit_sub(_a0, _b0);
    let sub1 = circuit_sub(_a1, _b1);

    let modulus = get_BLS12_381_modulus();

    let outputs = (sub0, sub1)
        .new_inputs()
        .next_2(a0)
        .next_2(a1)
        .next_2(b0)
        .next_2(b1)
        .done_2()
        .eval(modulus)
        .unwrap();

    return outputs.get_output(sub0).is_zero() && outputs.get_output(sub1).is_zero();
}

// returns true if a == -b mod p bls12-381
#[inline]
pub fn eq_neg_mod_p(a0: u384, a1: u384, b0: u384, b1: u384) -> bool {
    let _a0 = CE::<CI<0>> {};
    let _a1 = CE::<CI<1>> {};
    let _b0 = CE::<CI<2>> {};
    let _b1 = CE::<CI<3>> {};
    let check0 = circuit_add(_a0, _b0);
    let check1 = circuit_add(_a1, _b1);

    let modulus = get_BLS12_381_modulus();
    let outputs = (check0, check1)
        .new_inputs()
        .next_2(a0)
        .next_2(a1)
        .next_2(b0)
        .next_2(b1)
        .done_2()
        .eval(modulus)
        .unwrap();

    return outputs.get_output(check0).is_zero() && outputs.get_output(check1).is_zero();
}


#[cfg(test)]
mod tests {
    use super::{eq_mod_p, eq_neg_mod_p, G2Point, G2PointZero, ec_safe_add, u384, ec_mul};
    use garaga::definitions::BLS_G2_GENERATOR;
    #[test]
    fn test_ec_mul_g2() {
        let g = BLS_G2_GENERATOR;

        let s = 0;
        let curve_index = 1;
        let r = ec_mul(g, s, curve_index).unwrap();
        assert!(r == G2PointZero::zero());

        let s: u256 = 1;
        let r = ec_mul(g, s, curve_index).unwrap();
        assert!(r == g);

        let s: u256 = 2;
        let g2: G2Point = G2Point {
            x0: u384 {
                limb0: 0xf3611b78c952aacab827a053,
                limb1: 0xe1ea1e1e4d00dbae81f14b0b,
                limb2: 0xcc7ed5863bc0b995b8825e0e,
                limb3: 0x1638533957d540a9d2370f17,
            },
            x1: u384 {
                limb0: 0xb57ec72a6178288c47c33577,
                limb1: 0x728114d1031e1572c6c886f6,
                limb2: 0x730a124fd70662a904ba1074,
                limb3: 0xa4edef9c1ed7f729f520e47,
            },
            y0: u384 {
                limb0: 0x764bf3bd999d95d71e4c9899,
                limb1: 0xbfe6bd221e47aa8ae88dece9,
                limb2: 0x2b5256789a66da69bf91009c,
                limb3: 0x468fb440d82b0630aeb8dca,
            },
            y1: u384 {
                limb0: 0xa59c8967acdefd8b6e36ccf3,
                limb1: 0x97003f7a13c308f5422e1aa0,
                limb2: 0x3f887136a43253d9c66c4116,
                limb3: 0xf6d4552fa65dd2638b36154,
            },
        };
        let r = ec_mul(g, s, curve_index).unwrap();
        assert!(r == g2);

        let s: u256 = 3;
        let g3: G2Point = G2Point {
            x0: u384 {
                limb0: 0x866f09d516020ef82324afae,
                limb1: 0xa0c75df1c04d6d7a50a030fc,
                limb2: 0xdccb23ae691ae54329781315,
                limb3: 0x122915c824a0857e2ee414a3,
            },
            x1: u384 {
                limb0: 0x937cc6d9d6a44aaa56ca66dc,
                limb1: 0x5062650f8d251c96eb480673,
                limb2: 0x7e0550ff2ac480905396eda5,
                limb3: 0x9380275bbc8e5dcea7dc4dd,
            },
            y0: u384 {
                limb0: 0x8b52fdf2455e44813ecfd892,
                limb1: 0x326ac738fef5c721479dfd94,
                limb2: 0xbc1a6f0136961d1e3b20b1a7,
                limb3: 0xb21da7955969e61010c7a1a,
            },
            y1: u384 {
                limb0: 0xb975b9edea56d53f23a0e849,
                limb1: 0x714150a166bfbd6bcf6b3b58,
                limb2: 0xa36cfe5f62a7e42e0bf1c1ed,
                limb3: 0x8f239ba329b3967fe48d718,
            },
        };
        let r = ec_mul(g, s, curve_index).unwrap();
        assert!(r == g3);

        let s = 0xffffffffffffffffffffffffffffffff;
        let g4: G2Point = G2Point {
            x0: u384 {
                limb0: 0xae40a8b5aee95e54aedee2e7,
                limb1: 0x6e0699501c5035eed8fc5162,
                limb2: 0xbee76829b76806d1b6617bf8,
                limb3: 0x5026c3305c1267922077393,
            },
            x1: u384 {
                limb0: 0x10c08c4b0a70e02491c3c435,
                limb1: 0x591ef738050b3ce067e2016f,
                limb2: 0xdd6e0a179e2ce3c1399c5273,
                limb3: 0xd5c9af9b97e94f90cb4aba3,
            },
            y0: u384 {
                limb0: 0x93be53660cebb92c90d4fa87,
                limb1: 0xfbf63ca94e1d0ffd65801863,
                limb2: 0xd24fd9a06d72f1dc57f15f0a,
                limb3: 0x100dbfd4f271378e85171313,
            },
            y1: u384 {
                limb0: 0xb7296e587409163eecd3ef5d,
                limb1: 0x8a065d6871fa185d15703e78,
                limb2: 0x8a85fb95bb90eb5c7a0d81a9,
                limb3: 0x157cf362e91a3c96640bd973,
            },
        };
        let r = ec_mul(g, s, curve_index).unwrap();
        assert!(r == g4);

        //
        let s = 0x100000000000000000000000000000001;
        let g5: G2Point = G2Point {
            x0: u384 {
                limb0: 0x2131be4b061714de5a11407d,
                limb1: 0xd41318f9bcade1fee985310b,
                limb2: 0xb2669e638a7b78b7ba5c6751,
                limb3: 0xa5284fb2911d4e2f445e714,
            },
            x1: u384 {
                limb0: 0x712edcaf95ed642a8237e6fd,
                limb1: 0xed6fccd7b64896ebb6ffb3d9,
                limb2: 0xfcb88d23294a46657b8d2482,
                limb3: 0x143ef485b660d37036fc18e2,
            },
            y0: u384 {
                limb0: 0xaa5b7ff57bdbf47e6ab49121,
                limb1: 0xc14cded56b4a44e022320616,
                limb2: 0xdd5105feb3fdc5b10edb5afa,
                limb3: 0x175d2c78538490ce02fcead8,
            },
            y1: u384 {
                limb0: 0x23893f1bb0fdb0533584b05f,
                limb1: 0x420d425d79dcd48b26d87814,
                limb2: 0xc932fa90468e6b9dfd658cc9,
                limb3: 0xe5fac70e9096e97adc6dd89,
            },
        };
        let r = ec_mul(g, s, curve_index).unwrap();
        assert!(r == g5);
    }
}

