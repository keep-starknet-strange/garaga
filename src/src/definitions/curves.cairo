pub use core::circuit::{CircuitModulus, u384, u96};
use garaga::definitions::{G1Point, G1PointZero, G2Point};
// scalar_to_base_neg3_le(0xD201000000010000**2)
pub const BLS_X_SEED_SQ: u128 = 0xac45a4010001a4020000000100000000;
pub const BLS_X_SEED_SQ_EPNS: (felt252, felt252, felt252, felt252) = (
    49064175553473225114813626085204666029, 278052985706122803179667203045598799533, -1, -1,
);

pub const THIRD_ROOT_OF_UNITY_BLS12_381_G1: u384 = u384 {
    limb0: 0x4f49fffd8bfd00000000aaac,
    limb1: 0x897d29650fb85f9b409427eb,
    limb2: 0x63d4de85aa0d857d89759ad4,
    limb3: 0x1a0111ea397fe699ec024086,
};


// From a G1G2Pair(Px, Py, Qx0, Qx1, Qy0, Qy1), returns (1/Py, -Px/Py)
#[derive(Drop, Debug, PartialEq)]
pub struct BLSProcessedPair {
    pub yInv: u384,
    pub xNegOverY: u384,
}


// From a G1G2Pair(Px, Py, Qx0, Qx1, Qy0, Qy1), returns (1/Py, -Px/Py,-Qy0, -Qy1)
#[derive(Drop, Debug, PartialEq)]
pub struct BNProcessedPair {
    pub yInv: u384,
    pub xNegOverY: u384,
    pub QyNeg0: u384,
    pub QyNeg1: u384,
}

// curve_index 0: BN254
// curve_index 1: BLS12_381
// curve_index 2: SECP256K1
// curve_index 3: SECP256R1
// curve_index 4: ED25519

pub struct Curve {
    pub p: u384, // Prime modulus
    pub n: u256, // Order of the curve
    pub a: u384, // Weierstrass a parameter in eqn: y^2 = x^3 + ax + b
    pub b: u384, // Weierstrass b parameter in eqn: y^2 = x^3 + ax + b
    pub g: u384, // Generator of Fp. (Used to verify square roots)
    pub min_one: u384, // (-1) % p
    pub min_one_order: u384, // (-1) % n
    pub G: G1Point // Generator of the curve
}


// Returns the prime modulus for a given curve index
pub fn get_p(curve_index: usize) -> u384 {
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
pub fn get_a(curve_index: usize) -> u384 {
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
pub fn get_b(curve_index: usize) -> u384 {
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

pub fn get_b2(curve_index: usize) -> Result<(u384, u384), felt252> {
    if curve_index == 0 {
        return Result::Ok(
            (
                u384 {
                    limb0: 27810052284636130223308486885,
                    limb1: 40153378333836448380344387045,
                    limb2: 3104278944836790958,
                    limb3: 0,
                },
                u384 {
                    limb0: 70926583776874220189091304914,
                    limb1: 63498449372070794915149226116,
                    limb2: 42524369107353300,
                    limb3: 0,
                },
            ),
        );
    }
    if curve_index == 1 {
        return Result::Ok(
            (
                u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 },
                u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 },
            ),
        );
    } else {
        return Result::Err('Invalid curve index');
    }
}

// Returns a generator of the curve base field for a given curve index
pub fn get_g(curve_index: usize) -> u384 {
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


pub fn get_n(curve_index: usize) -> u256 {
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
pub fn get_min_one(curve_index: usize) -> u384 {
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

// Returns (-1) % n for a given curve index
pub fn get_min_one_order(curve_index: usize) -> u384 {
    match curve_index {
        0 => BN254.min_one_order,
        1 => BLS12_381.min_one_order,
        2 => SECP256K1.min_one_order,
        3 => SECP256R1.min_one_order,
        4 => ED25519.min_one_order,
        5 => GRUMPKIN.min_one_order,
        _ => core::panic_with_felt252('Invalid curve index'),
    }
}


pub fn get_modulus(curve_index: usize) -> CircuitModulus {
    match curve_index {
        0 => get_BN254_modulus(),
        1 => get_BLS12_381_modulus(),
        2 => get_SECP256K1_modulus(),
        3 => get_SECP256R1_modulus(),
        4 => get_ED25519_modulus(),
        5 => get_GRUMPKIN_modulus(),
        _ => core::panic_with_felt252('Invalid curve index'),
    }
}

// Returns the order of a given curve index as CircuitModulus
pub fn get_curve_order_modulus(curve_index: usize) -> CircuitModulus {
    match curve_index {
        0 => get_BN254_order_modulus(),
        1 => get_BLS12_381_order_modulus(),
        2 => get_SECP256K1_order_modulus(),
        3 => get_SECP256R1_order_modulus(),
        4 => get_ED25519_order_modulus(),
        5 => get_GRUMPKIN_order_modulus(),
        _ => core::panic_with_felt252('Invalid curve index'),
    }
}


pub fn get_G(curve_index: usize) -> G1Point {
    match curve_index {
        0 => BN254.G,
        1 => BLS12_381.G,
        2 => SECP256K1.G,
        3 => SECP256R1.G,
        4 => ED25519.G,
        5 => GRUMPKIN.G,
        _ => G1PointZero::zero(),
    }
}

pub fn get_eigenvalue(curve_index: usize) -> u384 {
    match curve_index {
        0 => u384 {
            limb0: 0x8d8daaa78b17ea66b99c90dd,
            limb1: 0xb3c4d79d41a917585bfc4108,
            limb2: 0x0,
            limb3: 0x0,
        },
        1 => u384 { limb0: 0x1a40200000000ffffffff, limb1: 0xac45a401, limb2: 0x0, limb3: 0x0 },
        2 => u384 {
            limb0: 0x20816678df02967c1b23bd72,
            limb1: 0xa5261c028812645a122e22ea,
            limb2: 0x5363ad4cc05c30e0,
            limb3: 0x0,
        },
        _ => core::panic_with_felt252('Invalid curve index'),
    }
}

// from garaga.defintions import *
// def print_nbits_and_nG_glv_fake_glv():
// for curve_id in CURVES:
//     curve: WeierstrassCurve = CURVES[curve_id]
//     if curve.is_endomorphism_available():
//         nbits = curve.n.bit_length() // 4 + 9
//         print(f"Curve {curve_id}: {nbits}, {G1Point.get_nG(CurveID(curve_id), 2 ** (nbits -
//         1)).to_cairo_1()}")
pub fn get_nbits_and_nG_glv_fake_glv(curve_index: usize) -> (usize, G1Point) {
    match curve_index {
        0 => (
            72,
            G1Point {
                x: u384 {
                    limb0: 0x2326b48f300fc56f6982026e,
                    limb1: 0x502bbba6bf6b07e3b7cef039,
                    limb2: 0x2e5001cee2faa644,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x98cc7e0376dd079323f80764,
                    limb1: 0x4dde58a9e671fa092d3ba5db,
                    limb2: 0x180e823c991af504,
                    limb3: 0x0,
                },
            },
        ),
        1 => (
            72,
            G1Point {
                x: u384 {
                    limb0: 0x673917f8969d906fa8042a5b,
                    limb1: 0x965a736ba5d1d0cd30a1a120,
                    limb2: 0xe3aa9975f1d5a589b04d183f,
                    limb3: 0x113518a56ed2bc43d8673d10,
                },
                y: u384 {
                    limb0: 0x5fcac5b51d50e598880f3b6d,
                    limb1: 0x44404f9354bddaab9d049569,
                    limb2: 0xb6ff3f432523e67bcd95559e,
                    limb3: 0xc2d434e06ebe212cb59dddd,
                },
            },
        ),
        2 => (
            73,
            G1Point {
                x: u384 {
                    limb0: 0xf668832ffd959af60c82a0a,
                    limb1: 0x6b06c9f1919413b10f9226c6,
                    limb2: 0x948bf809b1988a4,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xc97cd2bed4cb7f88d8c8e589,
                    limb1: 0xdc6b74c5d1c3418c6d4dff08,
                    limb2: 0x53a562856dcb6646,
                    limb3: 0x0,
                },
            },
        ),
        _ => core::panic_with_felt252('Invalid curve index'),
    }
}


// Returns the modulus of BLS12_381
#[inline(always)]
pub fn get_BLS12_381_modulus() -> CircuitModulus {
    let modulus = TryInto::<
        _, CircuitModulus,
    >::try_into(
        [
            0xb153ffffb9feffffffffaaab, 0x6730d2a0f6b0f6241eabfffe, 0x434bacd764774b84f38512bf,
            0x1a0111ea397fe69a4b1ba7b6,
        ],
    )
        .unwrap();
    modulus
}
// Returns the modulus of BN254
#[inline(always)]
pub fn get_BN254_modulus() -> CircuitModulus {
    let modulus = TryInto::<
        _, CircuitModulus,
    >::try_into([0x6871ca8d3c208c16d87cfd47, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0])
        .unwrap();
    modulus
}
// Returns the modulus of SECP256K1
#[inline(always)]
pub fn get_SECP256K1_modulus() -> CircuitModulus {
    let modulus = TryInto::<
        _, CircuitModulus,
    >::try_into([0xfffffffffffffffefffffc2f, 0xffffffffffffffffffffffff, 0xffffffffffffffff, 0x0])
        .unwrap();
    modulus
}

// Returns the modulus of SECP256K1
#[inline(always)]
pub fn get_SECP256R1_modulus() -> CircuitModulus {
    let modulus = TryInto::<
        _, CircuitModulus,
    >::try_into([0xffffffffffffffffffffffff, 0x0, 0xffffffff00000001, 0x0])
        .unwrap();
    modulus
}
// Returns the modulus of SECP256K1
#[inline(always)]
pub fn get_ED25519_modulus() -> CircuitModulus {
    let modulus = TryInto::<
        _, CircuitModulus,
    >::try_into([0xffffffffffffffffffffffed, 0xffffffffffffffffffffffff, 0x7fffffffffffffff, 0x0])
        .unwrap();
    modulus
}

// Returns the modulus of GRUMPKIN
#[inline(always)]
fn get_GRUMPKIN_modulus() -> CircuitModulus {
    let modulus = TryInto::<
        _, CircuitModulus,
    >::try_into([0x79b9709143e1f593f0000001, 0xb85045b68181585d2833e848, 0x30644e72e131a029, 0x0])
        .unwrap();
    modulus
}
// Return the order of BN254 as CircuitModulus
#[inline(always)]
pub fn get_BN254_order_modulus() -> CircuitModulus {
    let modulus = TryInto::<
        _, CircuitModulus,
    >::try_into([0x79b9709143e1f593f0000001, 0xb85045b68181585d2833e848, 0x30644e72e131a029, 0x0])
        .unwrap();
    modulus
}


// Return the order of BLS12_381 as CircuitModulus
#[inline(always)]
pub fn get_BLS12_381_order_modulus() -> CircuitModulus {
    let modulus = TryInto::<
        _, CircuitModulus,
    >::try_into([0xfffe5bfeffffffff00000001, 0x3339d80809a1d80553bda402, 0x73eda753299d7d48, 0x0])
        .unwrap();
    modulus
}


// Return the order of SECP256K1 as CircuitModulus
#[inline(always)]
pub fn get_SECP256K1_order_modulus() -> CircuitModulus {
    let modulus = TryInto::<
        _, CircuitModulus,
    >::try_into([0xaf48a03bbfd25e8cd0364141, 0xfffffffffffffffebaaedce6, 0xffffffffffffffff, 0x0])
        .unwrap();
    modulus
}


// Return the order of SECP256R1 as CircuitModulus
#[inline(always)]
pub fn get_SECP256R1_order_modulus() -> CircuitModulus {
    let modulus = TryInto::<
        _, CircuitModulus,
    >::try_into([0xa7179e84f3b9cac2fc632551, 0xffffffffffffffffbce6faad, 0xffffffff00000000, 0x0])
        .unwrap();
    modulus
}


// Return the order of ED25519 as CircuitModulus
#[inline(always)]
pub fn get_ED25519_order_modulus() -> CircuitModulus {
    let modulus = TryInto::<
        _, CircuitModulus,
    >::try_into([0xa2f79cd65812631a5cf5d3ed, 0x14def9de, 0x1000000000000000, 0x0])
        .unwrap();
    modulus
}


// Return the order of GRUMPKIN as CircuitModulus
#[inline(always)]
pub fn get_GRUMPKIN_order_modulus() -> CircuitModulus {
    let modulus = TryInto::<
        _, CircuitModulus,
    >::try_into([0x6871ca8d3c208c16d87cfd47, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0])
        .unwrap();
    modulus
}
pub const BN254: Curve = Curve {
    p: u384 {
        limb0: 0x6871ca8d3c208c16d87cfd47,
        limb1: 0xb85045b68181585d97816a91,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    n: u256 { low: 0x2833e84879b9709143e1f593f0000001, high: 0x30644e72e131a029b85045b68181585d },
    a: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    b: u384 { limb0: 0x3, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    g: u384 { limb0: 0x3, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    min_one: u384 {
        limb0: 0x6871ca8d3c208c16d87cfd46,
        limb1: 0xb85045b68181585d97816a91,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    min_one_order: u384 {
        limb0: 0x79b9709143e1f593f0000000,
        limb1: 0xb85045b68181585d2833e848,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    G: G1Point {
        x: u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        y: u384 { limb0: 0x2, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    },
};

pub const BLS12_381: Curve = Curve {
    p: u384 {
        limb0: 0xb153ffffb9feffffffffaaab,
        limb1: 0x6730d2a0f6b0f6241eabfffe,
        limb2: 0x434bacd764774b84f38512bf,
        limb3: 0x1a0111ea397fe69a4b1ba7b6,
    },
    n: u256 { low: 0x53bda402fffe5bfeffffffff00000001, high: 0x73eda753299d7d483339d80809a1d805 },
    a: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    b: u384 { limb0: 0x4, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    g: u384 { limb0: 0x3, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    min_one: u384 {
        limb0: 0xb153ffffb9feffffffffaaaa,
        limb1: 0x6730d2a0f6b0f6241eabfffe,
        limb2: 0x434bacd764774b84f38512bf,
        limb3: 0x1a0111ea397fe69a4b1ba7b6,
    },
    min_one_order: u384 {
        limb0: 0xfffe5bfeffffffff00000000,
        limb1: 0x3339d80809a1d80553bda402,
        limb2: 0x73eda753299d7d48,
        limb3: 0x0,
    },
    G: G1Point {
        x: u384 {
            limb0: 0xf97a1aeffb3af00adb22c6bb,
            limb1: 0xa14e3a3f171bac586c55e83f,
            limb2: 0x4fa9ac0fc3688c4f9774b905,
            limb3: 0x17f1d3a73197d7942695638c,
        },
        y: u384 {
            limb0: 0xa2888ae40caa232946c5e7e1,
            limb1: 0xdb18cb2c04b3edd03cc744,
            limb2: 0x741d8ae4fcf5e095d5d00af6,
            limb3: 0x8b3f481e3aaa0f1a09e30ed,
        },
    },
};

pub const SECP256K1: Curve = Curve {
    p: u384 {
        limb0: 0xfffffffffffffffefffffc2f,
        limb1: 0xffffffffffffffffffffffff,
        limb2: 0xffffffffffffffff,
        limb3: 0x0,
    },
    n: u256 { low: 0xbaaedce6af48a03bbfd25e8cd0364141, high: 0xfffffffffffffffffffffffffffffffe },
    a: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    b: u384 { limb0: 0x7, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    g: u384 { limb0: 0x3, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    min_one: u384 {
        limb0: 0xfffffffffffffffefffffc2e,
        limb1: 0xffffffffffffffffffffffff,
        limb2: 0xffffffffffffffff,
        limb3: 0x0,
    },
    min_one_order: u384 {
        limb0: 0xaf48a03bbfd25e8cd0364140,
        limb1: 0xfffffffffffffffebaaedce6,
        limb2: 0xffffffffffffffff,
        limb3: 0x0,
    },
    G: G1Point {
        x: u384 {
            limb0: 0x2dce28d959f2815b16f81798,
            limb1: 0x55a06295ce870b07029bfcdb,
            limb2: 0x79be667ef9dcbbac,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0xa68554199c47d08ffb10d4b8,
            limb1: 0x5da4fbfc0e1108a8fd17b448,
            limb2: 0x483ada7726a3c465,
            limb3: 0x0,
        },
    },
};

pub const SECP256R1: Curve = Curve {
    p: u384 {
        limb0: 0xffffffffffffffffffffffff, limb1: 0x0, limb2: 0xffffffff00000001, limb3: 0x0,
    },
    n: u256 { low: 0xbce6faada7179e84f3b9cac2fc632551, high: 0xffffffff00000000ffffffffffffffff },
    a: u384 {
        limb0: 0xfffffffffffffffffffffffc, limb1: 0x0, limb2: 0xffffffff00000001, limb3: 0x0,
    },
    b: u384 {
        limb0: 0xcc53b0f63bce3c3e27d2604b,
        limb1: 0xb3ebbd55769886bc651d06b0,
        limb2: 0x5ac635d8aa3a93e7,
        limb3: 0x0,
    },
    g: u384 { limb0: 0x6, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    min_one: u384 {
        limb0: 0xfffffffffffffffffffffffe, limb1: 0x0, limb2: 0xffffffff00000001, limb3: 0x0,
    },
    min_one_order: u384 {
        limb0: 0xa7179e84f3b9cac2fc632550,
        limb1: 0xffffffffffffffffbce6faad,
        limb2: 0xffffffff00000000,
        limb3: 0x0,
    },
    G: G1Point {
        x: u384 {
            limb0: 0x2deb33a0f4a13945d898c296,
            limb1: 0xf8bce6e563a440f277037d81,
            limb2: 0x6b17d1f2e12c4247,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x6b315ececbb6406837bf51f5,
            limb1: 0x8ee7eb4a7c0f9e162bce3357,
            limb2: 0x4fe342e2fe1a7f9b,
            limb3: 0x0,
        },
    },
};

pub const ED25519: Curve = Curve {
    p: u384 {
        limb0: 0xffffffffffffffffffffffed,
        limb1: 0xffffffffffffffffffffffff,
        limb2: 0x7fffffffffffffff,
        limb3: 0x0,
    },
    n: u256 { low: 0x14def9dea2f79cd65812631a5cf5d3ed, high: 0x10000000000000000000000000000000 },
    a: u384 {
        limb0: 0xca52af7ac71e18ef8bc172d,
        limb1: 0x3197e10d617b3dd66bb8b65d,
        limb2: 0x5d4eacd3a5b9bee6,
        limb3: 0x0,
    },
    b: u384 {
        limb0: 0x6b9fbc329004ebc1f364b2a4,
        limb1: 0x550ddb06105780d5f5483197,
        limb2: 0x1d11b29bcfd0b3e0,
        limb3: 0x0,
    },
    g: u384 { limb0: 0x6, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    min_one: u384 {
        limb0: 0xffffffffffffffffffffffec,
        limb1: 0xffffffffffffffffffffffff,
        limb2: 0x7fffffffffffffff,
        limb3: 0x0,
    },
    min_one_order: u384 {
        limb0: 0xa2f79cd65812631a5cf5d3ec, limb1: 0x14def9de, limb2: 0x1000000000000000, limb3: 0x0,
    },
    G: G1Point {
        x: u384 {
            limb0: 0xd617c9aca55c89b025aef35,
            limb1: 0xf00b8f02f1c20618a9c13fdf,
            limb2: 0x2a78dd0fd02c0339,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x807131659b7830f3f62c1d14,
            limb1: 0xbe483ba563798323cf6fd061,
            limb2: 0x29c644a5c71da22e,
            limb3: 0x0,
        },
    },
};

pub const GRUMPKIN: Curve = Curve {
    p: u384 {
        limb0: 0x79b9709143e1f593f0000001,
        limb1: 0xb85045b68181585d2833e848,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    n: u256 { low: 0x97816a916871ca8d3c208c16d87cfd47, high: 0x30644e72e131a029b85045b68181585d },
    a: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    b: u384 {
        limb0: 0x79b9709143e1f593effffff0,
        limb1: 0xb85045b68181585d2833e848,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    g: u384 { limb0: 0x5, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    min_one: u384 {
        limb0: 0x79b9709143e1f593f0000000,
        limb1: 0xb85045b68181585d2833e848,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    min_one_order: u384 {
        limb0: 0x6871ca8d3c208c16d87cfd46,
        limb1: 0xb85045b68181585d97816a91,
        limb2: 0x30644e72e131a029,
        limb3: 0x0,
    },
    G: G1Point {
        x: u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        y: u384 {
            limb0: 0xf1181294833fc48d823f272c,
            limb1: 0xcf135e7506a45d632d270d45,
            limb2: 0x2,
            limb3: 0x0,
        },
    },
};

pub const BN254_G1_GENERATOR: G1Point = G1Point {
    x: u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    y: u384 { limb0: 0x2, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
};

pub const BLS_G2_GENERATOR: G2Point = G2Point {
    x0: u384 {
        limb0: 0xa805bbefd48056c8c121bdb8,
        limb1: 0xb4510b647ae3d1770bac0326,
        limb2: 0x2dc51051c6e47ad4fa403b02,
        limb3: 0x24aa2b2f08f0a9126080527,
    },
    x1: u384 {
        limb0: 0x13945d57e5ac7d055d042b7e,
        limb1: 0xb5da61bbdc7f5049334cf112,
        limb2: 0x88274f65596bd0d09920b61a,
        limb3: 0x13e02b6052719f607dacd3a0,
    },
    y0: u384 {
        limb0: 0x3baca289e193548608b82801,
        limb1: 0x6d429a695160d12c923ac9cc,
        limb2: 0xda2e351aadfd9baa8cbdd3a7,
        limb3: 0xce5d527727d6e118cc9cdc6,
    },
    y1: u384 {
        limb0: 0x5cec1da1aaa9075ff05f79be,
        limb1: 0x267492ab572e99ab3f370d27,
        limb2: 0x2bc28b99cb3e287e85a763af,
        limb3: 0x606c4a02ea734cc32acd2b0,
    },
};


// recode_naf_bits(jy00(6 * 0x44E992B44A6909F1 + 2)[2:]) (see definitions.py)
// "00" -> 0
// "10" -> 1
// "-10" -> 2
// "01" -> 3
// "0-1" -> 4
pub const bn_bits: [felt252; 32] = [
    2, 1, 0, 2, 2, 0, 2, 3, 1, 4, 0, 0, 3, 0, 2, 1, 4, 0, 0, 2, 1, 0, 2, 2, 3, 0, 4, 0, 4, 4, 2, 0,
];

// [int(x) for x in bin(0xD201000000010000)[2:]][2:] with two-consecutive zeros replaced by 3
pub const bls_bits: [felt252; 34] = [
    0, 1, 3, 1, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 1, 3, 3, 3, 3, 3, 3,
    3, 3,
];
