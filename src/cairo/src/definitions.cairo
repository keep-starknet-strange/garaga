use core::circuit::{u96, u384};

struct G1Point {
    x: u384,
    y: u384,
}

struct Fq2 {
    a0: u384,
    a1: u384,
}

struct G2Point {
    x: Fq2,
    y: Fq2,
}

struct Curve {
    p: u384, // Prime modulus
    n: u384, // Order of the curve
    a: u384, // Weierstrass a parameter in eqn: y^2 = x^3 + ax + b
    b: u384, // Weierstrass b parameter in eqn: y^2 = x^3 + ax + b
    g: u384, // Generator of Fp. (Used to verify square roots)
    min_one: u384, // (-1) % p
}

const all_curves: [Curve; 5] = [BN254, BLS12_381, SECP256K1, SECP256R1, X25519];


const BN254: Curve =
    Curve {
        p: u384 {
            limb0: 0x6871ca8d3c208c16d87cfd47,
            limb1: 0xb85045b68181585d97816a91,
            limb2: 0x30644e72e131a029,
            limb3: 0x0
        },
        n: u384 {
            limb0: 0x79b9709143e1f593f0000001,
            limb1: 0xb85045b68181585d2833e848,
            limb2: 0x30644e72e131a029,
            limb3: 0x0
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
        n: u384 {
            limb0: 0xfffe5bfeffffffff00000001,
            limb1: 0x3339d80809a1d80553bda402,
            limb2: 0x73eda753299d7d48,
            limb3: 0x0
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
        n: u384 {
            limb0: 0xaf48a03bbfd25e8cd0364141,
            limb1: 0xfffffffffffffffebaaedce6,
            limb2: 0xffffffffffffffff,
            limb3: 0x0
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
        n: u384 {
            limb0: 0xa7179e84f3b9cac2fc632551,
            limb1: 0xffffffffffffffffbce6faad,
            limb2: 0xffffffff00000000,
            limb3: 0x0
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

const X25519: Curve =
    Curve {
        p: u384 {
            limb0: 0xffffffffffffffffffffffed,
            limb1: 0xffffffffffffffffffffffff,
            limb2: 0x7fffffffffffffff,
            limb3: 0x0
        },
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

