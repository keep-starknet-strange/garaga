use core::circuit::{u96, u384, U384Zero, CircuitModulus};
use garaga::basic_field_ops::{neg_mod_p};
use core::result::Result;
use core::serde::{Serde};
use core::num;
use core::num::traits::{Zero, One};

extern fn downcast<felt252, u96>(x: felt252) -> Option<u96> implicits(RangeCheck) nopanic;

pub impl u384Serde of Serde<u384> {
    fn serialize(self: @u384, ref output: Array<felt252>) {
        output.append((*self.limb0).into());
        output.append((*self.limb1).into());
        output.append((*self.limb2).into());
        output.append((*self.limb3).into());
    }
    fn deserialize(ref serialized: Span<felt252>) -> Option<u384> {
        let [l0, l1, l2, l3] = (*serialized.multi_pop_front::<4>().unwrap()).unbox();
        let limb0 = downcast(l0).unwrap();
        let limb1 = downcast(l1).unwrap();
        let limb2 = downcast(l2).unwrap();
        let limb3 = downcast(l3).unwrap();
        return Option::Some(u384 { limb0: limb0, limb1: limb1, limb2: limb2, limb3: limb3 });
    }
}

#[derive(Copy, Drop, Debug, PartialEq)]
pub struct u288 {
    limb0: u96,
    limb1: u96,
    limb2: u96,
}

pub impl u288Serde of Serde<u288> {
    fn serialize(self: @u288, ref output: Array<felt252>) {
        output.append((*self.limb0).into());
        output.append((*self.limb1).into());
        output.append((*self.limb2).into());
    }
    fn deserialize(ref serialized: Span<felt252>) -> Option<u288> {
        let [l0, l1, l2] = (*serialized.multi_pop_front::<3>().unwrap()).unbox();
        let limb0 = downcast(l0).unwrap();
        let limb1 = downcast(l1).unwrap();
        let limb2 = downcast(l2).unwrap();
        return Option::Some(u288 { limb0: limb0, limb1: limb1, limb2: limb2 });
    }
}


#[derive(Copy, Drop, Debug, PartialEq, Serde)]
struct G1Point {
    x: u384,
    y: u384,
}
#[derive(Copy, Drop, Debug, PartialEq, Serde)]
struct G2Point {
    x0: u384,
    x1: u384,
    y0: u384,
    y1: u384,
}

#[derive(Copy, Drop, Debug, PartialEq)]
struct G2Line<T> {
    r0a0: T,
    r0a1: T,
    r1a0: T,
    r1a1: T,
}

#[derive(Copy, Drop, Debug, PartialEq, Serde)]
struct G1G2Pair {
    p: G1Point,
    q: G2Point,
}

#[derive(Copy, Drop, Debug, PartialEq)]
struct E12D<T> {
    w0: T,
    w1: T,
    w2: T,
    w3: T,
    w4: T,
    w5: T,
    w6: T,
    w7: T,
    w8: T,
    w9: T,
    w10: T,
    w11: T,
}

// Fp12 tower struct.
#[derive(Drop, Copy, Debug, PartialEq)]
struct E12T {
    c0b0a0: u384,
    c0b0a1: u384,
    c0b1a0: u384,
    c0b1a1: u384,
    c0b2a0: u384,
    c0b2a1: u384,
    c1b0a0: u384,
    c1b0a1: u384,
    c1b1a0: u384,
    c1b1a1: u384,
    c1b2a0: u384,
    c1b2a1: u384,
}

// Represents the point at infinity
impl G1PointZero of num::traits::Zero<G1Point> {
    fn zero() -> G1Point {
        G1Point { x: Zero::zero(), y: Zero::zero() }
    }
    fn is_zero(self: @G1Point) -> bool {
        *self == Self::zero()
    }
    fn is_non_zero(self: @G1Point) -> bool {
        !self.is_zero()
    }
}

// Represents the point at infinity
impl G2PointZero of num::traits::Zero<G2Point> {
    fn zero() -> G2Point {
        G2Point { x0: Zero::zero(), x1: Zero::zero(), y0: Zero::zero(), y1: Zero::zero() }
    }
    fn is_zero(self: @G2Point) -> bool {
        *self == Self::zero()
    }
    fn is_non_zero(self: @G2Point) -> bool {
        !self.is_zero()
    }
}


impl U288Zero of num::traits::Zero<u288> {
    fn zero() -> u288 {
        u288 { limb0: 0, limb1: 0, limb2: 0 }
    }
    fn is_zero(self: @u288) -> bool {
        *self == Self::zero()
    }
    fn is_non_zero(self: @u288) -> bool {
        !self.is_zero()
    }
}

impl U288One of num::traits::One<u288> {
    fn one() -> u288 {
        u288 { limb0: 1, limb1: 0, limb2: 0 }
    }
    fn is_one(self: @u288) -> bool {
        *self == Self::one()
    }
    fn is_non_one(self: @u288) -> bool {
        !self.is_one()
    }
}


impl U384One of num::traits::One<u384> {
    fn one() -> u384 {
        u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 }
    }
    fn is_one(self: @u384) -> bool {
        *self == Self::one()
    }
    fn is_non_one(self: @u384) -> bool {
        !self.is_one()
    }
}

impl E12DOneU384 of num::traits::One<E12D<u384>> {
    fn one() -> E12D<u384> {
        E12D {
            w0: One::one(),
            w1: Zero::zero(),
            w2: Zero::zero(),
            w3: Zero::zero(),
            w4: Zero::zero(),
            w5: Zero::zero(),
            w6: Zero::zero(),
            w7: Zero::zero(),
            w8: Zero::zero(),
            w9: Zero::zero(),
            w10: Zero::zero(),
            w11: Zero::zero(),
        }
    }

    fn is_one(self: @E12D<u384>) -> bool {
        *self == Self::one()
    }

    fn is_non_one(self: @E12D<u384>) -> bool {
        !self.is_one()
    }
}

impl E12DOneU288 of num::traits::One<E12D<u288>> {
    fn one() -> E12D<u288> {
        E12D {
            w0: U288One::one(),
            w1: U288Zero::zero(),
            w2: U288Zero::zero(),
            w3: U288Zero::zero(),
            w4: U288Zero::zero(),
            w5: U288Zero::zero(),
            w6: U288Zero::zero(),
            w7: U288Zero::zero(),
            w8: U288Zero::zero(),
            w9: U288Zero::zero(),
            w10: U288Zero::zero(),
            w11: U288Zero::zero(),
        }
    }

    fn is_one(self: @E12D<u288>) -> bool {
        *self == Self::one()
    }

    fn is_non_one(self: @E12D<u288>) -> bool {
        !self.is_one()
    }
}

impl E12DSerde384 of Serde<E12D<u384>> {
    fn serialize(self: @E12D<u384>, ref output: Array<felt252>) {
        let val = *self;
        output.append(val.w0.limb0.into());
        output.append(val.w0.limb1.into());
        output.append(val.w0.limb2.into());
        output.append(val.w0.limb3.into());
        output.append(val.w1.limb0.into());
        output.append(val.w1.limb1.into());
        output.append(val.w1.limb2.into());
        output.append(val.w1.limb3.into());

        output.append(val.w2.limb0.into());
        output.append(val.w2.limb1.into());
        output.append(val.w2.limb2.into());
        output.append(val.w2.limb3.into());

        output.append(val.w3.limb0.into());
        output.append(val.w3.limb1.into());
        output.append(val.w3.limb2.into());
        output.append(val.w3.limb3.into());

        output.append(val.w4.limb0.into());
        output.append(val.w4.limb1.into());
        output.append(val.w4.limb2.into());
        output.append(val.w4.limb3.into());

        output.append(val.w5.limb0.into());
        output.append(val.w5.limb1.into());
        output.append(val.w5.limb2.into());
        output.append(val.w5.limb3.into());

        output.append(val.w6.limb0.into());
        output.append(val.w6.limb1.into());
        output.append(val.w6.limb2.into());
        output.append(val.w6.limb3.into());

        output.append(val.w7.limb0.into());
        output.append(val.w7.limb1.into());
        output.append(val.w7.limb2.into());
        output.append(val.w7.limb3.into());

        output.append(val.w8.limb0.into());
        output.append(val.w8.limb1.into());
        output.append(val.w8.limb2.into());
        output.append(val.w8.limb3.into());

        output.append(val.w9.limb0.into());
        output.append(val.w9.limb1.into());
        output.append(val.w9.limb2.into());
        output.append(val.w9.limb3.into());

        output.append(val.w10.limb0.into());
        output.append(val.w10.limb1.into());
        output.append(val.w10.limb2.into());
        output.append(val.w10.limb3.into());

        output.append(val.w11.limb0.into());
        output.append(val.w11.limb1.into());
        output.append(val.w11.limb2.into());
        output.append(val.w11.limb3.into());
    }

    fn deserialize(ref serialized: Span<felt252>) -> Option<E12D<u384>> {
        let [
            w0l0,
            w0l1,
            w0l2,
            w0l3,
            w1l0,
            w1l1,
            w1l2,
            w1l3,
            w2l0,
            w2l1,
            w2l2,
            w2l3,
            w3l0,
            w3l1,
            w3l2,
            w3l3,
            w4l0,
            w4l1,
            w4l2,
            w4l3,
            w5l0,
            w5l1,
            w5l2,
            w5l3,
            w6l0,
            w6l1,
            w6l2,
            w6l3,
            w7l0,
            w7l1,
            w7l2,
            w7l3,
            w8l0,
            w8l1,
            w8l2,
            w8l3,
            w9l0,
            w9l1,
            w9l2,
            w9l3,
            w10l0,
            w10l1,
            w10l2,
            w10l3,
            w11l0,
            w11l1,
            w11l2,
            w11l3
        ] =
            (*serialized
            .multi_pop_front::<48>()
            .unwrap())
            .unbox();
        Option::Some(
            E12D {
                w0: u384 {
                    limb0: downcast(w0l0).unwrap(),
                    limb1: downcast(w0l1).unwrap(),
                    limb2: downcast(w0l2).unwrap(),
                    limb3: downcast(w0l3).unwrap()
                },
                w1: u384 {
                    limb0: downcast(w1l0).unwrap(),
                    limb1: downcast(w1l1).unwrap(),
                    limb2: downcast(w1l2).unwrap(),
                    limb3: downcast(w1l3).unwrap()
                },
                w2: u384 {
                    limb0: downcast(w2l0).unwrap(),
                    limb1: downcast(w2l1).unwrap(),
                    limb2: downcast(w2l2).unwrap(),
                    limb3: downcast(w2l3).unwrap()
                },
                w3: u384 {
                    limb0: downcast(w3l0).unwrap(),
                    limb1: downcast(w3l1).unwrap(),
                    limb2: downcast(w3l2).unwrap(),
                    limb3: downcast(w3l3).unwrap()
                },
                w4: u384 {
                    limb0: downcast(w4l0).unwrap(),
                    limb1: downcast(w4l1).unwrap(),
                    limb2: downcast(w4l2).unwrap(),
                    limb3: downcast(w4l3).unwrap()
                },
                w5: u384 {
                    limb0: downcast(w5l0).unwrap(),
                    limb1: downcast(w5l1).unwrap(),
                    limb2: downcast(w5l2).unwrap(),
                    limb3: downcast(w5l3).unwrap()
                },
                w6: u384 {
                    limb0: downcast(w6l0).unwrap(),
                    limb1: downcast(w6l1).unwrap(),
                    limb2: downcast(w6l2).unwrap(),
                    limb3: downcast(w6l3).unwrap()
                },
                w7: u384 {
                    limb0: downcast(w7l0).unwrap(),
                    limb1: downcast(w7l1).unwrap(),
                    limb2: downcast(w7l2).unwrap(),
                    limb3: downcast(w7l3).unwrap()
                },
                w8: u384 {
                    limb0: downcast(w8l0).unwrap(),
                    limb1: downcast(w8l1).unwrap(),
                    limb2: downcast(w8l2).unwrap(),
                    limb3: downcast(w8l3).unwrap()
                },
                w9: u384 {
                    limb0: downcast(w9l0).unwrap(),
                    limb1: downcast(w9l1).unwrap(),
                    limb2: downcast(w9l2).unwrap(),
                    limb3: downcast(w9l3).unwrap()
                },
                w10: u384 {
                    limb0: downcast(w10l0).unwrap(),
                    limb1: downcast(w10l1).unwrap(),
                    limb2: downcast(w10l2).unwrap(),
                    limb3: downcast(w10l3).unwrap()
                },
                w11: u384 {
                    limb0: downcast(w11l0).unwrap(),
                    limb1: downcast(w11l1).unwrap(),
                    limb2: downcast(w11l2).unwrap(),
                    limb3: downcast(w11l3).unwrap()
                },
            }
        )
    }
}


impl E12DSerde288 of Serde<E12D<u288>> {
    fn serialize(self: @E12D<u288>, ref output: Array<felt252>) {
        let val = *self;
        output.append(val.w0.limb0.into());
        output.append(val.w0.limb1.into());
        output.append(val.w0.limb2.into());
        output.append(val.w1.limb0.into());
        output.append(val.w1.limb1.into());
        output.append(val.w1.limb2.into());

        output.append(val.w2.limb0.into());
        output.append(val.w2.limb1.into());
        output.append(val.w2.limb2.into());

        output.append(val.w3.limb0.into());
        output.append(val.w3.limb1.into());
        output.append(val.w3.limb2.into());

        output.append(val.w4.limb0.into());
        output.append(val.w4.limb1.into());
        output.append(val.w4.limb2.into());

        output.append(val.w5.limb0.into());
        output.append(val.w5.limb1.into());
        output.append(val.w5.limb2.into());

        output.append(val.w6.limb0.into());
        output.append(val.w6.limb1.into());
        output.append(val.w6.limb2.into());

        output.append(val.w7.limb0.into());
        output.append(val.w7.limb1.into());
        output.append(val.w7.limb2.into());

        output.append(val.w8.limb0.into());
        output.append(val.w8.limb1.into());
        output.append(val.w8.limb2.into());

        output.append(val.w9.limb0.into());
        output.append(val.w9.limb1.into());
        output.append(val.w9.limb2.into());

        output.append(val.w10.limb0.into());
        output.append(val.w10.limb1.into());
        output.append(val.w10.limb2.into());

        output.append(val.w11.limb0.into());
        output.append(val.w11.limb1.into());
        output.append(val.w11.limb2.into());
    }

    fn deserialize(ref serialized: Span<felt252>) -> Option<E12D<u288>> {
        let [
            w0l0,
            w0l1,
            w0l2,
            w1l0,
            w1l1,
            w1l2,
            w2l0,
            w2l1,
            w2l2,
            w3l0,
            w3l1,
            w3l2,
            w4l0,
            w4l1,
            w4l2,
            w5l0,
            w5l1,
            w5l2,
            w6l0,
            w6l1,
            w6l2,
            w7l0,
            w7l1,
            w7l2,
            w8l0,
            w8l1,
            w8l2,
            w9l0,
            w9l1,
            w9l2,
            w10l0,
            w10l1,
            w10l2,
            w11l0,
            w11l1,
            w11l2,
        ] =
            (*serialized
            .multi_pop_front::<36>()
            .unwrap())
            .unbox();
        Option::Some(
            E12D {
                w0: u288 {
                    limb0: downcast(w0l0).unwrap(),
                    limb1: downcast(w0l1).unwrap(),
                    limb2: downcast(w0l2).unwrap(),
                },
                w1: u288 {
                    limb0: downcast(w1l0).unwrap(),
                    limb1: downcast(w1l1).unwrap(),
                    limb2: downcast(w1l2).unwrap(),
                },
                w2: u288 {
                    limb0: downcast(w2l0).unwrap(),
                    limb1: downcast(w2l1).unwrap(),
                    limb2: downcast(w2l2).unwrap(),
                },
                w3: u288 {
                    limb0: downcast(w3l0).unwrap(),
                    limb1: downcast(w3l1).unwrap(),
                    limb2: downcast(w3l2).unwrap(),
                },
                w4: u288 {
                    limb0: downcast(w4l0).unwrap(),
                    limb1: downcast(w4l1).unwrap(),
                    limb2: downcast(w4l2).unwrap(),
                },
                w5: u288 {
                    limb0: downcast(w5l0).unwrap(),
                    limb1: downcast(w5l1).unwrap(),
                    limb2: downcast(w5l2).unwrap(),
                },
                w6: u288 {
                    limb0: downcast(w6l0).unwrap(),
                    limb1: downcast(w6l1).unwrap(),
                    limb2: downcast(w6l2).unwrap(),
                },
                w7: u288 {
                    limb0: downcast(w7l0).unwrap(),
                    limb1: downcast(w7l1).unwrap(),
                    limb2: downcast(w7l2).unwrap(),
                },
                w8: u288 {
                    limb0: downcast(w8l0).unwrap(),
                    limb1: downcast(w8l1).unwrap(),
                    limb2: downcast(w8l2).unwrap(),
                },
                w9: u288 {
                    limb0: downcast(w9l0).unwrap(),
                    limb1: downcast(w9l1).unwrap(),
                    limb2: downcast(w9l2).unwrap(),
                },
                w10: u288 {
                    limb0: downcast(w10l0).unwrap(),
                    limb1: downcast(w10l1).unwrap(),
                    limb2: downcast(w10l2).unwrap(),
                },
                w11: u288 {
                    limb0: downcast(w11l0).unwrap(),
                    limb1: downcast(w11l1).unwrap(),
                    limb2: downcast(w11l2).unwrap(),
                },
            }
        )
    }
}

#[derive(Copy, Drop, Debug, PartialEq, Serde)]
struct MillerLoopResultScalingFactor<T> {
    w0: T,
    w2: T,
    w4: T,
    w6: T,
    w8: T,
    w10: T,
}
#[derive(Copy, Drop, Debug, PartialEq, Serde)]
struct E12DMulQuotient<T> {
    w0: T,
    w1: T,
    w2: T,
    w3: T,
    w4: T,
    w5: T,
    w6: T,
    w7: T,
    w8: T,
    w9: T,
    w10: T,
}


// scalar_to_base_neg3_le(0xD201000000010000**2)
const BLS_X_SEED_SQ: u128 = 0xac45a4010001a4020000000100000000;
const BLS_X_SEED_SQ_EPNS: (felt252, felt252, felt252, felt252) =
    (49064175553473225114813626085204666029, 278052985706122803179667203045598799533, -1, -1);

const THIRD_ROOT_OF_UNITY_BLS12_381_G1: u384 =
    u384 {
        limb0: 0x4f49fffd8bfd00000000aaac,
        limb1: 0x897d29650fb85f9b409427eb,
        limb2: 0x63d4de85aa0d857d89759ad4,
        limb3: 0x1a0111ea397fe699ec024086
    };


// From a G1G2Pair(Px, Py, Qx0, Qx1, Qy0, Qy1), returns (1/Py, -Px/Py)
#[derive(Drop, Debug, PartialEq)]
struct BLSProcessedPair {
    yInv: u384,
    xNegOverY: u384,
}


// From a G1G2Pair(Px, Py, Qx0, Qx1, Qy0, Qy1), returns (1/Py, -Px/Py,-Qy0, -Qy1)
#[derive(Drop, Debug, PartialEq)]
struct BNProcessedPair {
    yInv: u384,
    xNegOverY: u384,
    QyNeg0: u384,
    QyNeg1: u384,
}

// curve_index 0: BN254
// curve_index 1: BLS12_381
// curve_index 2: SECP256K1
// curve_index 3: SECP256R1
// curve_index 4: ED25519

struct Curve {
    p: u384, // Prime modulus
    n: u256, // Order of the curve
    a: u384, // Weierstrass a parameter in eqn: y^2 = x^3 + ax + b
    b: u384, // Weierstrass b parameter in eqn: y^2 = x^3 + ax + b
    g: u384, // Generator of Fp. (Used to verify square roots)
    min_one: u384, // (-1) % p
}


// Returns the prime modulus for a given curve index
fn get_p(curve_index: usize) -> u384 {
    match curve_index {
        0 => BN254.p,
        1 => BLS12_381.p,
        2 => SECP256K1.p,
        3 => SECP256R1.p,
        4 => ED25519.p,
        5 => GRUMPKIN.p,
        _ => u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
    }
}

// Returns the Weierstrass 'a' parameter for a given curve index
fn get_a(curve_index: usize) -> u384 {
    match curve_index {
        0 => BN254.a,
        1 => BLS12_381.a,
        2 => SECP256K1.a,
        3 => SECP256R1.a,
        4 => ED25519.a,
        5 => GRUMPKIN.a,
        _ => u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
    }
}

// Returns the Weierstrass 'b' parameter for a given curve index
fn get_b(curve_index: usize) -> u384 {
    match curve_index {
        0 => BN254.b,
        1 => BLS12_381.b,
        2 => SECP256K1.b,
        3 => SECP256R1.b,
        4 => ED25519.b,
        5 => GRUMPKIN.b,
        _ => u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
    }
}

fn get_b2(curve_index: usize) -> Result<(u384, u384), felt252> {
    if curve_index == 0 {
        return Result::Ok(
            (
                u384 {
                    limb0: 27810052284636130223308486885,
                    limb1: 40153378333836448380344387045,
                    limb2: 3104278944836790958,
                    limb3: 0
                },
                u384 {
                    limb0: 70926583776874220189091304914,
                    limb1: 63498449372070794915149226116,
                    limb2: 42524369107353300,
                    limb3: 0
                }
            )
        );
    }
    if curve_index == 1 {
        return Result::Ok(
            (
                u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 },
                u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 }
            )
        );
    } else {
        return Result::Err('Invalid curve index');
    }
}

// Returns a generator of the curve base field for a given curve index
fn get_g(curve_index: usize) -> u384 {
    match curve_index {
        0 => BN254.g,
        1 => BLS12_381.g,
        2 => SECP256K1.g,
        3 => SECP256R1.g,
        4 => ED25519.g,
        5 => GRUMPKIN.g,
        _ => u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
    }
}


fn get_n(curve_index: usize) -> u256 {
    match curve_index {
        0 => BN254.n,
        1 => BLS12_381.n,
        2 => SECP256K1.n,
        3 => SECP256R1.n,
        4 => ED25519.n,
        5 => GRUMPKIN.n,
        _ => u256 { low: 0, high: 0 },
    }
}

// Returns (-1) % p for a given curve index
fn get_min_one(curve_index: usize) -> u384 {
    match curve_index {
        0 => BN254.min_one,
        1 => BLS12_381.min_one,
        2 => SECP256K1.min_one,
        3 => SECP256R1.min_one,
        4 => ED25519.min_one,
        5 => GRUMPKIN.min_one,
        _ => u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
    }
}

fn get_modulus(curve_index: usize) -> CircuitModulus {
    match curve_index {
        0 => get_BN254_modulus(),
        1 => get_BLS12_381_modulus(),
        2 => get_SECP256K1_modulus(),
        3 => get_SECP256R1_modulus(),
        4 => get_ED25519_modulus(),
        _ => panic_with_felt252('Invalid curve index'),
    }
}

// Returns the modulus of BLS12_381
#[inline(always)]
fn get_BLS12_381_modulus() -> CircuitModulus {
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [
            0xb153ffffb9feffffffffaaab,
            0x6730d2a0f6b0f6241eabfffe,
            0x434bacd764774b84f38512bf,
            0x1a0111ea397fe69a4b1ba7b6
        ]
    )
        .unwrap();
    modulus
}

// Returns the modulus of BN254
#[inline(always)]
fn get_BN254_modulus() -> CircuitModulus {
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([0x6871ca8d3c208c16d87cfd47, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0])
        .unwrap();
    modulus
}
// Returns the modulus of SECP256K1
#[inline(always)]
fn get_SECP256K1_modulus() -> CircuitModulus {
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([0xfffffffffffffffefffffc2f, 0xffffffffffffffffffffffff, 0xffffffffffffffff, 0x0])
        .unwrap();
    modulus
}

// Returns the modulus of SECP256K1
#[inline(always)]
fn get_SECP256R1_modulus() -> CircuitModulus {
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([0xffffffffffffffffffffffff, 0x0, 0xffffffff00000001, 0x0])
        .unwrap();
    modulus
}
// Returns the modulus of SECP256K1
#[inline(always)]
fn get_ED25519_modulus() -> CircuitModulus {
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([0xffffffffffffffffffffffed, 0xffffffffffffffffffffffff, 0x7fffffffffffffff, 0x0])
        .unwrap();
    modulus
}

// Returns the modulus of GRUMPKIN
#[inline(always)]
fn get_GRUMPKIN_modulus() -> CircuitModulus {
    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([0x79b9709143e1f593f0000001, 0xb85045b68181585d2833e848, 0x30644e72e131a029, 0x0])
        .unwrap();
    modulus
}

pub const BN254: Curve =
    Curve {
        p: u384 {
            limb0: 0x6871ca8d3c208c16d87cfd47,
            limb1: 0xb85045b68181585d97816a91,
            limb2: 0x30644e72e131a029,
            limb3: 0x0
        },
        n: u256 {
            low: 0x2833e84879b9709143e1f593f0000001, high: 0x30644e72e131a029b85045b68181585d
        },
        a: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        b: u384 { limb0: 0x3, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        g: u384 { limb0: 0x3, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        min_one: u384 {
            limb0: 0x6871ca8d3c208c16d87cfd46,
            limb1: 0xb85045b68181585d97816a91,
            limb2: 0x30644e72e131a029,
            limb3: 0x0
        },
    };

pub const BLS12_381: Curve =
    Curve {
        p: u384 {
            limb0: 0xb153ffffb9feffffffffaaab,
            limb1: 0x6730d2a0f6b0f6241eabfffe,
            limb2: 0x434bacd764774b84f38512bf,
            limb3: 0x1a0111ea397fe69a4b1ba7b6
        },
        n: u256 {
            low: 0x53bda402fffe5bfeffffffff00000001, high: 0x73eda753299d7d483339d80809a1d805
        },
        a: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        b: u384 { limb0: 0x4, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        g: u384 { limb0: 0x3, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        min_one: u384 {
            limb0: 0xb153ffffb9feffffffffaaaa,
            limb1: 0x6730d2a0f6b0f6241eabfffe,
            limb2: 0x434bacd764774b84f38512bf,
            limb3: 0x1a0111ea397fe69a4b1ba7b6
        },
    };

pub const SECP256K1: Curve =
    Curve {
        p: u384 {
            limb0: 0xfffffffffffffffefffffc2f,
            limb1: 0xffffffffffffffffffffffff,
            limb2: 0xffffffffffffffff,
            limb3: 0x0
        },
        n: u256 {
            low: 0xbaaedce6af48a03bbfd25e8cd0364141, high: 0xfffffffffffffffffffffffffffffffe
        },
        a: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        b: u384 { limb0: 0x7, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        g: u384 { limb0: 0x3, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        min_one: u384 {
            limb0: 0xfffffffffffffffefffffc2e,
            limb1: 0xffffffffffffffffffffffff,
            limb2: 0xffffffffffffffff,
            limb3: 0x0
        },
    };

pub const SECP256R1: Curve =
    Curve {
        p: u384 {
            limb0: 0xffffffffffffffffffffffff, limb1: 0x0, limb2: 0xffffffff00000001, limb3: 0x0
        },
        n: u256 {
            low: 0xbce6faada7179e84f3b9cac2fc632551, high: 0xffffffff00000000ffffffffffffffff
        },
        a: u384 {
            limb0: 0xfffffffffffffffffffffffc, limb1: 0x0, limb2: 0xffffffff00000001, limb3: 0x0
        },
        b: u384 {
            limb0: 0xcc53b0f63bce3c3e27d2604b,
            limb1: 0xb3ebbd55769886bc651d06b0,
            limb2: 0x5ac635d8aa3a93e7,
            limb3: 0x0
        },
        g: u384 { limb0: 0x6, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        min_one: u384 {
            limb0: 0xfffffffffffffffffffffffe, limb1: 0x0, limb2: 0xffffffff00000001, limb3: 0x0
        },
    };

pub const ED25519: Curve =
    Curve {
        p: u384 {
            limb0: 0xffffffffffffffffffffffed,
            limb1: 0xffffffffffffffffffffffff,
            limb2: 0x7fffffffffffffff,
            limb3: 0x0
        },
        n: u256 {
            low: 0x14def9dea2f79cd65812631a5cf5d3ed, high: 0x10000000000000000000000000000000
        },
        a: u384 {
            limb0: 0xca52af7ac71e18ef8bc172d,
            limb1: 0x3197e10d617b3dd66bb8b65d,
            limb2: 0x5d4eacd3a5b9bee6,
            limb3: 0x0
        },
        b: u384 {
            limb0: 0x6b9fbc329004ebc1f364b2a4,
            limb1: 0x550ddb06105780d5f5483197,
            limb2: 0x1d11b29bcfd0b3e0,
            limb3: 0x0
        },
        g: u384 { limb0: 0x6, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        min_one: u384 {
            limb0: 0xffffffffffffffffffffffec,
            limb1: 0xffffffffffffffffffffffff,
            limb2: 0x7fffffffffffffff,
            limb3: 0x0
        },
    };

pub const GRUMPKIN: Curve =
    Curve {
        p: u384 {
            limb0: 0x79b9709143e1f593f0000001,
            limb1: 0xb85045b68181585d2833e848,
            limb2: 0x30644e72e131a029,
            limb3: 0x0
        },
        n: u256 {
            low: 0x97816a916871ca8d3c208c16d87cfd47, high: 0x30644e72e131a029b85045b68181585d
        },
        a: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        b: u384 {
            limb0: 0x79b9709143e1f593effffff0,
            limb1: 0xb85045b68181585d2833e848,
            limb2: 0x30644e72e131a029,
            limb3: 0x0
        },
        g: u384 { limb0: 0x5, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        min_one: u384 {
            limb0: 0x79b9709143e1f593f0000000,
            limb1: 0xb85045b68181585d2833e848,
            limb2: 0x30644e72e131a029,
            limb3: 0x0
        },
    };


pub const BN254_G1_GENERATOR: G1Point =
    G1Point {
        x: u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        y: u384 { limb0: 0x2, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
    };

pub const BLS_G2_GENERATOR: G2Point =
    G2Point {
        x0: u384 {
            limb0: 0xa805bbefd48056c8c121bdb8,
            limb1: 0xb4510b647ae3d1770bac0326,
            limb2: 0x2dc51051c6e47ad4fa403b02,
            limb3: 0x24aa2b2f08f0a9126080527
        },
        x1: u384 {
            limb0: 0x13945d57e5ac7d055d042b7e,
            limb1: 0xb5da61bbdc7f5049334cf112,
            limb2: 0x88274f65596bd0d09920b61a,
            limb3: 0x13e02b6052719f607dacd3a0
        },
        y0: u384 {
            limb0: 0x3baca289e193548608b82801,
            limb1: 0x6d429a695160d12c923ac9cc,
            limb2: 0xda2e351aadfd9baa8cbdd3a7,
            limb3: 0xce5d527727d6e118cc9cdc6
        },
        y1: u384 {
            limb0: 0x5cec1da1aaa9075ff05f79be,
            limb1: 0x267492ab572e99ab3f370d27,
            limb2: 0x2bc28b99cb3e287e85a763af,
            limb3: 0x606c4a02ea734cc32acd2b0
        }
    };


// jy00(6 * 0x44E992B44A6909F1 + 2)[2:] with consecutive zeros replaced by 3, and -1 replaced by 2
const bn_bits: [
    felt252
    ; 49] = [
    2,
    0,
    1,
    3,
    0,
    2,
    0,
    2,
    3,
    0,
    2,
    3,
    1,
    1,
    3,
    2,
    3,
    3,
    0,
    1,
    3,
    2,
    0,
    1,
    3,
    2,
    3,
    3,
    2,
    0,
    1,
    3,
    0,
    2,
    0,
    2,
    3,
    1,
    3,
    0,
    2,
    3,
    0,
    2,
    0,
    2,
    2,
    3,
    0
];

// [int(x) for x in bin(0xD201000000010000)[2:]][2:] with two-consecutive zeros replaced by 3
const bls_bits: [
    felt252
    ; 34] = [
    0,
    1,
    3,
    1,
    3,
    3,
    3,
    3,
    1,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    0,
    1,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    3
];
