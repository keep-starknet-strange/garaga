pub use core::circuit::{CircuitModulus, u384, u96};
use garaga::definitions::{G1Point, G1PointZero, G2Point};

/// Square of the BLS12-381 x seed parameter used in curve generation
pub const BLS_X_SEED_SQ: u128 = 0xac45a4010001a4020000000100000000;


// Curve indices used throughout Garaga:
// curve_index 0: BN254
// curve_index 1: BLS12_381
// curve_index 2: SECP256K1
// curve_index 3: SECP256R1
// curve_index 4: ED25519 (stored in Weierstrass form)
// curve_index 5: GRUMPKIN

/// Complete curve parameters for elliptic curves in Weierstrass form: y² = x³ + ax + b
///
/// # Fields
/// * `p`: Prime modulus of the base field Fp
/// * `n`: Order of the curve (number of points in the prime-order subgroup)
/// * `a`: Weierstrass a parameter
/// * `b`: Weierstrass b parameter
/// * `g`: Generator of the multiplicative group Fp* (for field operations)
/// * `min_one`: (-1) mod p, precomputed for efficiency
/// * `min_one_order`: (-1) mod n, precomputed for efficiency
/// * `G`: Generator point of the curve's prime-order subgroup
/// * `b_twist`: Twist curve b parameter (b₀, b₁) where b = b₀ + i·b₁ in Fp2 (for pairing
/// curves only)
/// * `modulus`: Prime modulus p as 4 limbs of u96 for CircuitModulus operations
/// * `order_modulus`: Curve order n as 4 limbs of u96 for CircuitModulus operations
/// * `eigenvalue`: GLV endomorphism eigenvalue λ (for curves with efficient endomorphism)
/// * `nG_glv_fake_glv`: Precomputed point 2^(nbits-1)·G for GLV decomposition
/// * `third_root_of_unity`: Cubic root of unity in Fp (for curves supporting GLV/fake-GLV)
pub struct Curve {
    pub p: u384, // Prime modulus
    pub n: u256, // Order of the curve
    pub a: u384, // Weierstrass a parameter in eqn: y^2 = x^3 + ax + b
    pub b: u384, // Weierstrass b parameter in eqn: y^2 = x^3 + ax + b
    pub g: u384, // Generator of Fp* (the multiplicative group of the field)
    pub min_one: u384, // (-1) % p
    pub min_one_order: u384, // (-1) % n
    pub G: G1Point, // Generator of the curve
    pub b_twist: Option<
        (u384, u384),
    >, // b parameter for twisted curve (b0, b1) such that b = b0 + i*b1
    pub modulus: [u96; 4], // Prime modulus as 4 limbs for CircuitModulus
    pub order_modulus: [u96; 4], // Curve order as 4 limbs for CircuitModulus
    pub eigenvalue: Option<u384>, // Eigenvalue for endomorphism (if available)
    pub nG_glv_fake_glv: Option<G1Point>, // 2^(nbits-1)*G for GLV/fake GLV (if available)
    pub third_root_of_unity: Option<u384> // Third root of unity in the base field (if available)
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
    b_twist: Some(
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
    ),
    modulus: [0x6871ca8d3c208c16d87cfd47, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0],
    order_modulus: [
        0x79b9709143e1f593f0000001, 0xb85045b68181585d2833e848, 0x30644e72e131a029, 0x0,
    ],
    eigenvalue: Some(
        u384 {
            limb0: 0x8d8daaa78b17ea66b99c90dd,
            limb1: 0xb3c4d79d41a917585bfc4108,
            limb2: 0x0,
            limb3: 0x0,
        },
    ),
    nG_glv_fake_glv: Some(
        G1Point {
            x: u384 {
                limb0: 0x804f4c2700adf08a0214e529,
                limb1: 0xa68b293da254e1b0049b5825,
                limb2: 0x2715e750e68b52fa,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x15c090b1de77447950003fc9,
                limb1: 0xfb5afe510e7c4e23f41e4bad,
                limb2: 0x3921d1862445f32,
                limb3: 0x0,
            },
        },
    ),
    third_root_of_unity: Some(
        u384 {
            limb0: 0xacdb5c4f5763473177fffffe,
            limb1: 0x59e26bcea0d48bacd4f263f1,
            limb2: 0x0,
            limb3: 0x0,
        },
    ),
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
    b_twist: Some(
        (
            u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 },
        ),
    ),
    modulus: [
        0xb153ffffb9feffffffffaaab, 0x6730d2a0f6b0f6241eabfffe, 0x434bacd764774b84f38512bf,
        0x1a0111ea397fe69a4b1ba7b6,
    ],
    order_modulus: [
        0xfffe5bfeffffffff00000001, 0x3339d80809a1d80553bda402, 0x73eda753299d7d48, 0x0,
    ],
    eigenvalue: Some(
        u384 { limb0: 0x1a40200000000ffffffff, limb1: 0xac45a401, limb2: 0x0, limb3: 0x0 },
    ),
    nG_glv_fake_glv: Some(
        G1Point {
            x: u384 {
                limb0: 0xcf4357bd59d6560f96d34480,
                limb1: 0x1c2b3f4bb7a8579e7473612d,
                limb2: 0x44f04a3ee426074a0864fc6e,
                limb3: 0x60aa1307100d28a9c44cc51,
            },
            y: u384 {
                limb0: 0x365913fecd5eb4667fe5e1ea,
                limb1: 0xa456de882c324863cdfcf5b5,
                limb2: 0xbaaa2be88ae9a807b36465b8,
                limb3: 0x31152c621ab7ca0e5a2ab1c,
            },
        },
    ),
    third_root_of_unity: Some(
        u384 {
            limb0: 0x4f49fffd8bfd00000000aaac,
            limb1: 0x897d29650fb85f9b409427eb,
            limb2: 0x63d4de85aa0d857d89759ad4,
            limb3: 0x1a0111ea397fe699ec024086,
        },
    ),
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
    b_twist: Option::None,
    modulus: [0xfffffffffffffffefffffc2f, 0xffffffffffffffffffffffff, 0xffffffffffffffff, 0x0],
    order_modulus: [
        0xaf48a03bbfd25e8cd0364141, 0xfffffffffffffffebaaedce6, 0xffffffffffffffff, 0x0,
    ],
    eigenvalue: Some(
        u384 {
            limb0: 0x20816678df02967c1b23bd72,
            limb1: 0xa5261c028812645a122e22ea,
            limb2: 0x5363ad4cc05c30e0,
            limb3: 0x0,
        },
    ),
    nG_glv_fake_glv: Some(
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
    third_root_of_unity: Some(
        u384 {
            limb0: 0x12f58995c1396c28719501ee,
            limb1: 0x6e64479eac3434e99cf04975,
            limb2: 0x7ae96a2b657c0710,
            limb3: 0x0,
        },
    ),
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
    b_twist: None,
    modulus: [0xffffffffffffffffffffffff, 0x0, 0xffffffff00000001, 0x0],
    order_modulus: [
        0xa7179e84f3b9cac2fc632551, 0xffffffffffffffffbce6faad, 0xffffffff00000000, 0x0,
    ],
    eigenvalue: None,
    nG_glv_fake_glv: None,
    third_root_of_unity: None,
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
    b_twist: None,
    modulus: [0xffffffffffffffffffffffed, 0xffffffffffffffffffffffff, 0x7fffffffffffffff, 0x0],
    order_modulus: [0xa2f79cd65812631a5cf5d3ed, 0x14def9de, 0x1000000000000000, 0x0],
    eigenvalue: None,
    nG_glv_fake_glv: None,
    third_root_of_unity: None,
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
    b_twist: None,
    modulus: [0x79b9709143e1f593f0000001, 0xb85045b68181585d2833e848, 0x30644e72e131a029, 0x0],
    order_modulus: [
        0x6871ca8d3c208c16d87cfd47, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0,
    ],
    eigenvalue: None,
    nG_glv_fake_glv: None,
    third_root_of_unity: None,
};

/// Generator point for the G2 subgroup of BLS12-381's twisted curve E'(Fp2)
/// Coordinates are in Fp2 represented as (x₀ + i·x₁, y₀ + i·y₁)
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


/// Compressed NAF (Non-Adjacent Form) representation of BN254 seed parameter
/// for efficient Miller loop computation in pairing operations.
///
/// Computed as: recode_naf_bits(jy00(6·x + 2)[2:]) where x = 0x44E992B44A6909F1
/// Encoding: "00"→0, "10"→1, "-10"→2, "01"→3, "0-1"→4
/// See hydra/garaga/definitions.py for the encoding algorithm
pub const BN254_SEED_BITS_JY00_COMPRESSED: [felt252; 32] = [
    2, 1, 0, 2, 2, 0, 2, 3, 1, 4, 0, 0, 3, 0, 2, 1, 4, 0, 0, 2, 1, 0, 2, 2, 3, 0, 4, 0, 4, 4, 2, 0,
];

/// Compressed binary representation of BLS12-381 seed parameter x = 0xD201000000010000
/// for efficient Miller loop computation.
///
/// Binary digits with consecutive zeros replaced by 3 for compression
/// Format: bin(x)[2:][2:] with "00" → 3
pub const BLS12_381_SEED_BITS_COMPRESSED: [felt252; 34] = [
    0, 1, 3, 1, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 1, 3, 3, 3, 3, 3, 3,
    3, 3,
];

/// NAF (Non-Adjacent Form) representation of BN254 seed parameter
/// for Miller loop computation in pairing operations.
///
/// Computed as: NAF(6·x + 2)[1:] where x = 0x44E992B44A6909F1
/// Encoding: -1 is replaced by 2 (values are 0, 1, or 2)
/// See hydra/garaga/definitions.py for the NAF algorithm
pub const BN254_SEED_BITS_NAF: [usize; 65] = [
    0, 2, 0, 1, 0, 0, 0, 2, 0, 2, 0, 0, 0, 2, 0, 0, 1, 1, 0, 0, 2, 0, 0, 0, 0, 0, 1, 0, 0, 2, 0, 1,
    0, 0, 2, 0, 0, 0, 0, 2, 0, 1, 0, 0, 0, 2, 0, 2, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 2, 0, 2, 2, 0, 0,
    0,
];

/// Standard binary representation of BLS12-381 seed parameter x = 0xD201000000010000
/// Used for basic Miller loop operations
/// Format: bin(x)[2:][2:] (binary digits after "0b" prefix, skipping first two)
pub const BLS12_381_SEED_BITS: [usize; 62] = [
    0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
];


/// GETTER FUNCTIONS ///

/// Returns the prime modulus p of the base field Fp for a given curve.
///
/// # Arguments
/// * `curve_index` - Index of the curve (0-5, see curve index mapping above)
///
/// # Returns
/// * The prime modulus p as u384, or zero for invalid indices
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

/// Checks if a curve has an efficient endomorphism available for GLV decomposition.
///
/// GLV (Gallant-Lambert-Vanstone) decomposition accelerates scalar multiplication
/// by utilizing the curve's endomorphism structure.
///
/// # Arguments
/// * `curve_index` - Index of the curve
///
/// # Returns
/// * `true` for BN254, BLS12_381, and SECP256K1 (curves 0, 1, 2)
/// * `false` for all other curves
pub fn has_endomorphism_available(curve_index: usize) -> bool {
    match curve_index {
        0 | 1 | 2 => true,
        _ => false,
    }
}

/// Returns the Weierstrass 'a' parameter for a given curve.
///
/// For Weierstrass curves: y² = x³ + ax + b
///
/// # Arguments
/// * `curve_index` - Index of the curve (0-5)
///
/// # Returns
/// * The 'a' parameter as u384, or zero for invalid indices
///
/// # Note
/// For ED25519 (index 4), this returns the 'a' parameter of the birationally
/// equivalent Weierstrass curve, not the Edwards curve parameter.
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

/// Returns the Weierstrass 'b' parameter for a given curve.
///
/// For Weierstrass curves: y² = x³ + ax + b
///
/// # Arguments
/// * `curve_index` - Index of the curve (0-5)
///
/// # Returns
/// * The 'b' parameter as u384, or zero for invalid indices
///
/// # Note
/// For ED25519 (index 4), this returns the 'b' parameter of the birationally
/// equivalent Weierstrass curve, not the Edwards curve parameter.
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

/// Returns the b parameter for the twisted curve E'(Fp2) used in pairing operations.
///
/// The twisted curve has equation: y² = x³ + b' where b' is in Fp2.
///
/// # Arguments
/// * `curve_index` - Index of the curve (must be 0 for BN254 or 1 for BLS12_381)
///
/// # Returns
/// * Tuple (b₀, b₁) where b' = b₀ + i·b₁ in Fp2 = Fp[i]/(i² + 1)
///
/// # Panics
/// * Panics for curves without pairing support (not BN254 or BLS12_381)
pub fn get_b_twist(curve_index: usize) -> (u384, u384) {
    match curve_index {
        0 => BN254.b_twist.unwrap(),
        1 => BLS12_381.b_twist.unwrap(),
        _ => core::panic_with_felt252('Invalid curve index'),
    }
}

/// Returns a generator g of the multiplicative group Fp* for a given curve.
///
/// This generator is used for various field operations and exponentiations.
///
/// # Arguments
/// * `curve_index` - Index of the curve (0-5)
///
/// # Returns
/// * A generator element g ∈ Fp* as u384
///
/// # Panics
/// * Panics for invalid curve indices
pub fn get_g(curve_index: usize) -> u384 {
    match curve_index {
        0 => BN254.g,
        1 => BLS12_381.g,
        2 => SECP256K1.g,
        3 => SECP256R1.g,
        4 => ED25519.g,
        5 => GRUMPKIN.g,
        _ => core::panic_with_felt252('Invalid curve index'),
    }
}

/// Returns the order n of the curve's prime-order subgroup.
///
/// This is the number of points in the main cryptographic subgroup.
/// For most curves, this equals #E(Fp)/cofactor.
///
/// # Arguments
/// * `curve_index` - Index of the curve (0-5)
///
/// # Returns
/// * The subgroup order n as u256
///
/// # Panics
/// * Panics for invalid curve indices
pub fn get_n(curve_index: usize) -> u256 {
    match curve_index {
        0 => BN254.n,
        1 => BLS12_381.n,
        2 => SECP256K1.n,
        3 => SECP256R1.n,
        4 => ED25519.n,
        5 => GRUMPKIN.n,
        _ => core::panic_with_felt252('Invalid curve index'),
    }
}

/// Returns (-1) mod p precomputed for the base field Fp.
///
/// This is equivalent to (p - 1) and is frequently used in field arithmetic.
///
/// # Arguments
/// * `curve_index` - Index of the curve (0-5)
///
/// # Returns
/// * The value (-1) mod p as u384
///
/// # Panics
/// * Panics for invalid curve indices
pub fn get_min_one(curve_index: usize) -> u384 {
    match curve_index {
        0 => BN254.min_one,
        1 => BLS12_381.min_one,
        2 => SECP256K1.min_one,
        3 => SECP256R1.min_one,
        4 => ED25519.min_one,
        5 => GRUMPKIN.min_one,
        _ => core::panic_with_felt252('Invalid curve index'),
    }
}

/// Returns (-1) mod n precomputed for the scalar field (curve order).
///
/// This is equivalent to (n - 1) and is used for scalar arithmetic operations.
///
/// # Arguments
/// * `curve_index` - Index of the curve (0-5)
///
/// # Returns
/// * The value (-1) mod n as u384
///
/// # Panics
/// * Panics for invalid curve indices
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

/// Returns the base field modulus p as a CircuitModulus for circuit operations.
///
/// CircuitModulus is used by Cairo's circuit builtins for modular arithmetic.
///
/// # Arguments
/// * `curve_index` - Index of the curve (0-5)
///
/// # Returns
/// * The prime modulus p as CircuitModulus
///
/// # Panics
/// * Panics for invalid curve indices
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

/// Returns the curve order n as a CircuitModulus for circuit operations.
///
/// CircuitModulus is used by Cairo's circuit builtins for modular arithmetic
/// in the scalar field.
///
/// # Arguments
/// * `curve_index` - Index of the curve (0-5)
///
/// # Returns
/// * The curve order n as CircuitModulus
///
/// # Panics
/// * Panics for invalid curve indices
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

/// Returns the standard generator point G of the curve's prime-order subgroup.
///
/// This is the base point used for scalar multiplication and key generation.
///
/// # Arguments
/// * `curve_index` - Index of the curve (0-5)
///
/// # Returns
/// * The generator point G as G1Point
///
/// # Panics
/// * Panics for invalid curve indices
///
/// # Note
/// For ED25519 (index 4), returns the generator in Weierstrass form.
pub fn get_G(curve_index: usize) -> G1Point {
    match curve_index {
        0 => BN254.G,
        1 => BLS12_381.G,
        2 => SECP256K1.G,
        3 => SECP256R1.G,
        4 => ED25519.G,
        5 => GRUMPKIN.G,
        _ => core::panic_with_felt252('Invalid curve index'),
    }
}

/// Returns the eigenvalue λ for the curve's efficiently computable endomorphism.
///
/// The endomorphism φ satisfies φ(P) = λ·P for points P on the curve.
/// This eigenvalue is used in GLV decomposition to accelerate scalar multiplication.
///
/// # Arguments
/// * `curve_index` - Index of the curve (must be 0, 1, or 2)
///
/// # Returns
/// * The eigenvalue λ as u384
///
/// # Panics
/// * Panics for curves without efficient endomorphism (not BN254, BLS12_381, or SECP256K1)
pub fn get_eigenvalue(curve_index: usize) -> u384 {
    match curve_index {
        0 => BN254.eigenvalue.unwrap(),
        1 => BLS12_381.eigenvalue.unwrap(),
        2 => SECP256K1.eigenvalue.unwrap(),
        _ => core::panic_with_felt252('Invalid curve index'),
    }
}

/// Returns the precomputed point 2^(nbits-1)·G for GLV/fake-GLV decomposition.
///
/// This precomputed value is used to accelerate scalar multiplication via
/// GLV (Gallant-Lambert-Vanstone) or fake-GLV decomposition techniques.
///
/// The nbits parameter is computed as: nbits = n.bit_length() // 4 + 9
/// where n is the curve order.
///
/// # Arguments
/// * `curve_index` - Index of the curve (must be 0, 1, or 2)
///
/// # Returns
/// * The point 2^(nbits-1)·G as G1Point
///   - For BN254: 2^72·G (nbits=73)
///   - For BLS12_381: 2^72·G (nbits=73)
///   - For SECP256K1: 2^72·G (nbits=73)
///
/// # Panics
/// * Panics for curves without efficient endomorphism (not BN254, BLS12_381, or SECP256K1)
pub fn get_nG_glv_fake_glv(curve_index: usize) -> G1Point {
    match curve_index {
        0 => BN254.nG_glv_fake_glv.unwrap(),
        1 => BLS12_381.nG_glv_fake_glv.unwrap(),
        2 => SECP256K1.nG_glv_fake_glv.unwrap(),
        _ => core::panic_with_felt252('Invalid curve index'),
    }
}

/// Returns a primitive cube root of unity ω in the base field Fp.
///
/// This element satisfies ω³ = 1 and ω ≠ 1, and is used in GLV endomorphism
/// computations for accelerating scalar multiplication.
///
/// # Arguments
/// * `curve_index` - Index of the curve (must be 0, 1, or 2)
///
/// # Returns
/// * A third root of unity ω ∈ Fp as u384
///
/// # Panics
/// * Panics for curves without efficient endomorphism (not BN254, BLS12_381, or SECP256K1)
pub fn get_third_root_of_unity(curve_index: usize) -> u384 {
    match curve_index {
        0 => BN254.third_root_of_unity.unwrap(),
        1 => BLS12_381.third_root_of_unity.unwrap(),
        2 => SECP256K1.third_root_of_unity.unwrap(),
        _ => core::panic_with_felt252('Invalid curve index'),
    }
}

/// Returns the BLS12-381 base field modulus as CircuitModulus.
#[inline(always)]
pub fn get_BLS12_381_modulus() -> CircuitModulus {
    TryInto::<_, CircuitModulus>::try_into(BLS12_381.modulus).unwrap()
}

/// Returns the BN254 base field modulus as CircuitModulus.
#[inline(always)]
pub fn get_BN254_modulus() -> CircuitModulus {
    TryInto::<_, CircuitModulus>::try_into(BN254.modulus).unwrap()
}

/// Returns the SECP256K1 base field modulus as CircuitModulus.
#[inline(always)]
pub fn get_SECP256K1_modulus() -> CircuitModulus {
    TryInto::<_, CircuitModulus>::try_into(SECP256K1.modulus).unwrap()
}

/// Returns the SECP256R1 (P-256) base field modulus as CircuitModulus.
#[inline(always)]
pub fn get_SECP256R1_modulus() -> CircuitModulus {
    TryInto::<_, CircuitModulus>::try_into(SECP256R1.modulus).unwrap()
}

/// Returns the ED25519 base field modulus as CircuitModulus.
/// (Modulus of the birationally equivalent Weierstrass curve)
#[inline(always)]
pub fn get_ED25519_modulus() -> CircuitModulus {
    TryInto::<_, CircuitModulus>::try_into(ED25519.modulus).unwrap()
}

/// Returns the GRUMPKIN base field modulus as CircuitModulus.
#[inline(always)]
pub fn get_GRUMPKIN_modulus() -> CircuitModulus {
    TryInto::<_, CircuitModulus>::try_into(GRUMPKIN.modulus).unwrap()
}

/// Returns the BN254 curve order as CircuitModulus.
#[inline(always)]
pub fn get_BN254_order_modulus() -> CircuitModulus {
    TryInto::<_, CircuitModulus>::try_into(BN254.order_modulus).unwrap()
}

/// Returns the BLS12-381 curve order as CircuitModulus.
#[inline(always)]
pub fn get_BLS12_381_order_modulus() -> CircuitModulus {
    TryInto::<_, CircuitModulus>::try_into(BLS12_381.order_modulus).unwrap()
}

/// Returns the SECP256K1 curve order as CircuitModulus.
#[inline(always)]
pub fn get_SECP256K1_order_modulus() -> CircuitModulus {
    TryInto::<_, CircuitModulus>::try_into(SECP256K1.order_modulus).unwrap()
}

/// Returns the SECP256R1 (P-256) curve order as CircuitModulus.
#[inline(always)]
pub fn get_SECP256R1_order_modulus() -> CircuitModulus {
    TryInto::<_, CircuitModulus>::try_into(SECP256R1.order_modulus).unwrap()
}

/// Returns the ED25519 curve order as CircuitModulus.
#[inline(always)]
pub fn get_ED25519_order_modulus() -> CircuitModulus {
    TryInto::<_, CircuitModulus>::try_into(ED25519.order_modulus).unwrap()
}

/// Returns the GRUMPKIN curve order as CircuitModulus.
#[inline(always)]
pub fn get_GRUMPKIN_order_modulus() -> CircuitModulus {
    TryInto::<_, CircuitModulus>::try_into(GRUMPKIN.order_modulus).unwrap()
}
