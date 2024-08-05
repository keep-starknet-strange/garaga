use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::fields::fft_friendly::stark_252_prime_field::Stark252PrimeField;
use rand::Rng;
use lambdaworks_math::unsigned_integer::element::U256;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum CurveID {
    BN254 = 0,
    BLS12_381 = 1,
    SECP256K1 = 2,
    SECP256R1 = 3,
    X25519 = 4,
}

impl From<u8> for CurveID {
    fn from(value: u8) -> Self {
        match value {
            0 => CurveID::BN254,
            1 => CurveID::BLS12_381,
            2 => CurveID::SECP256K1,
            3 => CurveID::SECP256R1,
            4 => CurveID::X25519,
            _ => panic!("Invalid curve ID"),
        }
    }
}


pub struct Curve {
    pub a: U256,
    pub b: U256,
    pub fp_generator: U256,
    pub p: U256,
}

pub struct BaseField {
    p: U256,
}

impl BaseField {
    pub fn new(p: U256) -> Self {
        BaseField { p }
    }

    pub fn call(&self, integer: U256) -> U256 {
        integer % &self.p
    }

    pub fn zero(&self) -> U256 {
        U256::from(0)
    }

    pub fn one(&self) -> U256 {
        U256::from(1)
    }

    pub fn random(&self) -> U256 {
        let mut rng = rand::thread_rng();
        let mut bytes = [0u8; 32];
        rng.fill(&mut bytes);
        U256::from_bytes_be(&bytes) % &self.p
    }
}

pub fn get_base_field(curve_id: CurveID) -> BaseField {
    BaseField::new(CURVES[curve_id].p)
}

pub const CURVES: [Curve; 1] = [
    Curve {
        a: U256::from_hex_unchecked("0"),
        b: U256::from_hex_unchecked("0"),
        fp_generator: U256::from_hex_unchecked("3"),
        p: U256::from_hex_unchecked("800000000000011000000000000000000000000000000000000000000000001"),
    },
];

pub const SECP256K1_PRIME_FIELD_ORDER: U256 =
    U256::from_hex_unchecked("fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f");

#[derive(Clone, Debug)]
pub struct SECP256K1FieldModulus;
impl IsModulus<U256> for SECP256K1FieldModulus {
    const MODULUS: U256 = SECP256K1_PRIME_FIELD_ORDER;
}

pub type SECP256K1PrimeField = MontgomeryBackendPrimeField<SECP256K1FieldModulus, 4>;


pub const SECP256R1_PRIME_FIELD_ORDER: U256 =
    U256::from_hex_unchecked("ffffffff00000001000000000000000000000000ffffffffffffffffffffffff");

#[derive(Clone, Debug)]
pub struct SECP256R1FieldModulus;
impl IsModulus<U256> for SECP256R1FieldModulus {
    const MODULUS: U256 = SECP256R1_PRIME_FIELD_ORDER;
}

pub type SECP256R1PrimeField = MontgomeryBackendPrimeField<SECP256R1FieldModulus, 4>;

pub const X25519_PRIME_FIELD_ORDER: U256 =
    U256::from_hex_unchecked("7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffed");

#[derive(Clone, Debug)]
pub struct X25519FieldModulus;
impl IsModulus<U256> for X25519FieldModulus {
    const MODULUS: U256 = X25519_PRIME_FIELD_ORDER;
}

pub type X25519PrimeField = MontgomeryBackendPrimeField<X25519FieldModulus, 4>;

pub struct CurveParams<F: IsPrimeField> {
    pub a: FieldElement<F>,
    pub b: FieldElement<F>,
    pub g_x: FieldElement<F>,
    pub g_y: FieldElement<F>,
    pub n: FieldElement<F>, // Order of the curve
    pub h: u32,             // Cofactor
}

impl CurveParams<SECP256K1PrimeField> {
    pub fn get() -> Self {
        Self {
            a: FieldElement::zero(),
            b: FieldElement::from_hex_unchecked("7"),
            g_x: FieldElement::from_hex_unchecked("79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798"),
            g_y: FieldElement::from_hex_unchecked("483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8"),
            n: FieldElement::from_hex_unchecked("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141"),
            h: 1,
        }
    }
}

impl CurveParams<SECP256R1PrimeField> {
    pub fn get() -> Self {
        Self {
            a: FieldElement::from_hex_unchecked("FFFFFFFF00000001000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFC"),
            b: FieldElement::from_hex_unchecked("5AC635D8AA3A93E7B3EBBD55769886BC651D06B0CC53B0F63BCE3C3E27D2604B"),
            g_x: FieldElement::from_hex_unchecked("6B17D1F2E12C4247F8BCE6E563A440F277037D812DEB33A0F4A13945D898C296"),
            g_y: FieldElement::from_hex_unchecked("4FE342E2FE1A7F9B8EE7EB4A7C0F9E162CBCE33576B315ECECBB6406837BF51F"),
            n: FieldElement::from_hex_unchecked("FFFFFFFF00000000FFFFFFFFFFFFFFFFBCE6FAADA7179E84F3B9CAC2FC632551"),
            h: 1,
        }
    }
}

impl CurveParams<X25519PrimeField> {
    pub fn get() -> Self {
        Self {
            a: FieldElement::from(486662u64),
            b: FieldElement::zero(), 
            g_x: FieldElement::from_hex_unchecked("9"),
            g_y: FieldElement::from_hex_unchecked("20AE19A1B8A086B4E01EDD2C7748D14C923D4DF667ADCE0B9A9E39E969A2C0DF"),
            n: FieldElement::from_hex_unchecked("1000000000000000000000000000000014DEF9DEA2F79CD65812631A5CF5D3ED"),
            h: 8,
        }
    }
}

