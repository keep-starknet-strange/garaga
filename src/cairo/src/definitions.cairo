use core::circuit::{u96, u384};
use garaga::basic_field_ops::{neg_mod_p};
<<<<<<< HEAD

#[derive(Copy, Drop, Debug, PartialEq)]
=======
use core::result::Result;
use core::serde::{Serde};


extern fn downcast<felt252, u96>(x: felt252) -> Option<u96> implicits(RangeCheck) nopanic;

pub impl u384Serde of Serde<u384> {
    fn serialize(self: @u384, ref output: Array<felt252>) {
        output.append((*self.limb0).into());
        output.append((*self.limb1).into());
        output.append((*self.limb2).into());
        output.append((*self.limb3).into());
    }
    fn deserialize(ref serialized: Span<felt252>) -> Option<u384> {
        let limb0 = downcast(serialized.pop_front().unwrap()).unwrap();
        let limb1 = downcast(serialized.pop_front().unwrap()).unwrap();
        let limb2 = downcast(serialized.pop_front().unwrap()).unwrap();
        let limb3 = downcast(serialized.pop_front().unwrap()).unwrap();
        return Option::Some(u384 { limb0: limb0, limb1: limb1, limb2: limb2, limb3: limb3 });
    }
}

#[derive(Copy, Drop, Debug, PartialEq, Serde)]
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
struct G1Point {
    x: u384,
    y: u384,
}


<<<<<<< HEAD
#[derive(Copy, Drop, Debug, PartialEq)]
=======
const G1PointInfinity: G1Point =
    G1Point {
        x: u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
        y: u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
    };

#[derive(Copy, Drop, Debug, PartialEq, Serde)]
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
struct G2Point {
    x0: u384,
    x1: u384,
    y0: u384,
    y1: u384,
}

#[derive(Copy, Drop, Debug, PartialEq)]
<<<<<<< HEAD
=======
struct G2Line {
    r0a0: u384,
    r0a1: u384,
    r1a0: u384,
    r1a1: u384,
}

#[derive(Copy, Drop, Debug, PartialEq, Serde)]
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
struct G1G2Pair {
    p: G1Point,
    q: G2Point,
}

<<<<<<< HEAD
#[derive(Copy, Drop, Debug, PartialEq)]
=======
#[derive(Copy, Drop, Debug, PartialEq, Serde)]
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
struct E12D {
    w0: u384,
    w1: u384,
    w2: u384,
    w3: u384,
    w4: u384,
    w5: u384,
    w6: u384,
    w7: u384,
    w8: u384,
    w9: u384,
    w10: u384,
    w11: u384,
}
<<<<<<< HEAD
#[derive(Copy, Drop, Debug, PartialEq)]
=======
#[derive(Copy, Drop, Debug, PartialEq, Serde)]
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
struct MillerLoopResultScalingFactor {
    w0: u384,
    w2: u384,
    w4: u384,
    w6: u384,
    w8: u384,
    w10: u384,
}
<<<<<<< HEAD
#[derive(Copy, Drop, Debug, PartialEq)]
=======
#[derive(Copy, Drop, Debug, PartialEq, Serde)]
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
struct E12DMulQuotient {
    w0: u384,
    w1: u384,
    w2: u384,
    w3: u384,
    w4: u384,
    w5: u384,
    w6: u384,
    w7: u384,
    w8: u384,
    w9: u384,
    w10: u384,
}

trait FieldDefinitions<F> {
    fn one() -> F;
    fn zero() -> F;
    fn conjugate(self: F, curve_index: usize) -> F;
}

<<<<<<< HEAD
=======
// scalar_to_base_neg3_le(0xD201000000010000**2)
const BLS_X_SEED_SQ_EPNS: (felt252, felt252, felt252, felt252) =
    (49064175553473225114813626085204666029, 278052985706122803179667203045598799533, -1, -1);

const THIRD_ROOT_OF_UNITY_BLS12_381_G1: u384 =
    u384 {
        limb0: 0x4f49fffd8bfd00000000aaac,
        limb1: 0x897d29650fb85f9b409427eb,
        limb2: 0x63d4de85aa0d857d89759ad4,
        limb3: 0x1a0111ea397fe699ec024086
    };


>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
impl E12DDefinitions of FieldDefinitions<E12D> {
    fn one() -> E12D {
        E12D {
            w0: u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 },
            w1: u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            w2: u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            w3: u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            w4: u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            w5: u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            w6: u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            w7: u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            w8: u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            w9: u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            w10: u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            w11: u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
        }
    }

    fn zero() -> E12D {
        E12D {
            w0: u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            w1: u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            w2: u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            w3: u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            w4: u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            w5: u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            w6: u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            w7: u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            w8: u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            w9: u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            w10: u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            w11: u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
        }
    }

    fn conjugate(self: E12D, curve_index: usize) -> E12D {
        let p = get_p(curve_index);
        E12D {
            w0: self.w0,
            w1: neg_mod_p(self.w1, p),
            w2: self.w2,
            w3: neg_mod_p(self.w3, p),
            w4: self.w4,
            w5: neg_mod_p(self.w5, p),
            w6: self.w6,
            w7: neg_mod_p(self.w7, p),
            w8: self.w8,
            w9: neg_mod_p(self.w9, p),
            w10: self.w10,
            w11: neg_mod_p(self.w11, p),
        }
    }
}


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
<<<<<<< HEAD
// curve_index 4: X25519

struct Curve {
    p: u384, // Prime modulus
    n: u384, // Order of the curve
=======
// curve_index 4: ED25519

struct Curve {
    p: u384, // Prime modulus
    n: u256, // Order of the curve
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
    a: u384, // Weierstrass a parameter in eqn: y^2 = x^3 + ax + b
    b: u384, // Weierstrass b parameter in eqn: y^2 = x^3 + ax + b
    g: u384, // Generator of Fp. (Used to verify square roots)
    min_one: u384, // (-1) % p
}


// Returns the prime modulus for a given curve index
fn get_p(curve_index: usize) -> u384 {
    if curve_index == 0 {
        return BN254.p;
    }
    if curve_index == 1 {
        return BLS12_381.p;
    }
    if curve_index == 2 {
        return SECP256K1.p;
    }
    if curve_index == 3 {
        return SECP256R1.p;
    }
    if curve_index == 4 {
<<<<<<< HEAD
        return X25519.p;
=======
        return ED25519.p;
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
    }
    return u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };
}

// Returns the Weierstrass 'a' parameter for a given curve index
fn get_a(curve_index: usize) -> u384 {
    if curve_index == 0 {
        return BN254.a;
    }
    if curve_index == 1 {
        return BLS12_381.a;
    }
    if curve_index == 2 {
        return SECP256K1.a;
    }
    if curve_index == 3 {
        return SECP256R1.a;
    }
    if curve_index == 4 {
<<<<<<< HEAD
        return X25519.a;
=======
        return ED25519.a;
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
    }
    return u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };
}

// Returns the Weierstrass 'b' parameter for a given curve index
fn get_b(curve_index: usize) -> u384 {
    if curve_index == 0 {
        return BN254.b;
    }
    if curve_index == 1 {
        return BLS12_381.b;
    }
    if curve_index == 2 {
        return SECP256K1.b;
    }
    if curve_index == 3 {
        return SECP256R1.b;
    }
    if curve_index == 4 {
<<<<<<< HEAD
        return X25519.b;
=======
        return ED25519.b;
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
    }
    return u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };
}

<<<<<<< HEAD
=======
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

>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
// Returns a generator of the curve base field for a given curve index
fn get_g(curve_index: usize) -> u384 {
    if curve_index == 0 {
        return BN254.g;
    }
    if curve_index == 1 {
        return BLS12_381.g;
    }
    if curve_index == 2 {
        return SECP256K1.g;
    }
    if curve_index == 3 {
        return SECP256R1.g;
    }
    if curve_index == 4 {
<<<<<<< HEAD
        return X25519.g;
=======
        return ED25519.g;
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
    }
    return u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };
}

<<<<<<< HEAD
=======
fn get_n(curve_index: usize) -> u256 {
    if curve_index == 0 {
        return BN254.n;
    }
    if curve_index == 1 {
        return BLS12_381.n;
    }
    if curve_index == 2 {
        return SECP256K1.n;
    }
    if curve_index == 3 {
        return SECP256R1.n;
    }
    if curve_index == 4 {
        return ED25519.n;
    }
    return u256 { low: 0, high: 0 };
}

>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
// Returns (-1) % p for a given curve index
fn get_min_one(curve_index: usize) -> u384 {
    if curve_index == 0 {
        return BN254.min_one;
    }
    if curve_index == 1 {
        return BLS12_381.min_one;
    }
    if curve_index == 2 {
        return SECP256K1.min_one;
    }
    if curve_index == 3 {
        return SECP256R1.min_one;
    }
    if curve_index == 4 {
<<<<<<< HEAD
        return X25519.min_one;
=======
        return ED25519.min_one;
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
    }
    return u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };
}

const BN254: Curve =
    Curve {
        p: u384 {
            limb0: 0x6871ca8d3c208c16d87cfd47,
            limb1: 0xb85045b68181585d97816a91,
            limb2: 0x30644e72e131a029,
            limb3: 0x0
        },
<<<<<<< HEAD
        n: u384 {
            limb0: 0x79b9709143e1f593f0000001,
            limb1: 0xb85045b68181585d2833e848,
            limb2: 0x30644e72e131a029,
            limb3: 0x0
=======
        n: u256 {
            low: 0x2833e84879b9709143e1f593f0000001, high: 0x30644e72e131a029b85045b68181585d
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
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

const BLS12_381: Curve =
    Curve {
        p: u384 {
            limb0: 0xb153ffffb9feffffffffaaab,
            limb1: 0x6730d2a0f6b0f6241eabfffe,
            limb2: 0x434bacd764774b84f38512bf,
            limb3: 0x1a0111ea397fe69a4b1ba7b6
        },
<<<<<<< HEAD
        n: u384 {
            limb0: 0xfffe5bfeffffffff00000001,
            limb1: 0x3339d80809a1d80553bda402,
            limb2: 0x73eda753299d7d48,
            limb3: 0x0
=======
        n: u256 {
            low: 0x53bda402fffe5bfeffffffff00000001, high: 0x73eda753299d7d483339d80809a1d805
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
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

const SECP256K1: Curve =
    Curve {
        p: u384 {
            limb0: 0xfffffffffffffffefffffc2f,
            limb1: 0xffffffffffffffffffffffff,
            limb2: 0xffffffffffffffff,
            limb3: 0x0
        },
<<<<<<< HEAD
        n: u384 {
            limb0: 0xaf48a03bbfd25e8cd0364141,
            limb1: 0xfffffffffffffffebaaedce6,
            limb2: 0xffffffffffffffff,
            limb3: 0x0
=======
        n: u256 {
            low: 0xbaaedce6af48a03bbfd25e8cd0364141, high: 0xfffffffffffffffffffffffffffffffe
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
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

const SECP256R1: Curve =
    Curve {
        p: u384 {
            limb0: 0xffffffffffffffffffffffff, limb1: 0x0, limb2: 0xffffffff00000001, limb3: 0x0
        },
<<<<<<< HEAD
        n: u384 {
            limb0: 0xa7179e84f3b9cac2fc632551,
            limb1: 0xffffffffffffffffbce6faad,
            limb2: 0xffffffff00000000,
            limb3: 0x0
=======
        n: u256 {
            low: 0xbce6faada7179e84f3b9cac2fc632551, high: 0xffffffff00000000ffffffffffffffff
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
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

<<<<<<< HEAD
const X25519: Curve =
=======
const ED25519: Curve =
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
    Curve {
        p: u384 {
            limb0: 0xffffffffffffffffffffffed,
            limb1: 0xffffffffffffffffffffffff,
            limb2: 0x7fffffffffffffff,
            limb3: 0x0
        },
<<<<<<< HEAD
        n: u384 {
            limb0: 0xa2f79cd65812631a5cf5d3ed,
            limb1: 0x14def9de,
            limb2: 0x1000000000000000,
            limb3: 0x0
        },
        a: u384 {
            limb0: 0xaaaaaaaaaaaaaa984914a144,
            limb1: 0xaaaaaaaaaaaaaaaaaaaaaaaa,
            limb2: 0x2aaaaaaaaaaaaaaa,
            limb3: 0x0
        },
        b: u384 {
            limb0: 0x5ed097b4260b5e9c7710c864,
            limb1: 0x97b425ed097b425ed097b42,
            limb2: 0x7b425ed097b425ed,
=======
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
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
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

<<<<<<< HEAD
// NAF(6 * 0x44E992B44A6909F1 + 2)[2:]
const bn_bits: [
    felt252
    ; 64] = [
    -1,
    0,
    1,
    0,
    0,
    0,
    -1,
    0,
    -1,
    0,
    0,
    0,
    -1,
    0,
    1,
    0,
    -1,
    0,
    0,
    -1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    -1,
    0,
    1,
    0,
    0,
    -1,
    0,
    0,
    0,
    0,
    -1,
    0,
    1,
    0,
    0,
    0,
    -1,
    0,
    -1,
    0,
    0,
    1,
    0,
    0,
    0,
    -1,
    0,
    0,
    -1,
=======
// NAF(6 * 0x44E992B44A6909F1 + 2)[2:] with consecutive zeros replaced by 3, and -1 replaced by 2
const bn_bits: [
    felt252
    ; 50] = [
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
    0,
    1,
    0,
    2,
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
    2,
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
    0,
    1,
    0,
    1,
<<<<<<< HEAD
    0,
    0,
    0
];

// [int(x) for x in bin(0xD201000000010000)[2:]][2:]
const bls_bits: [
    felt252
    ; 62] = [
    0,
    1,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
=======
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
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
];
