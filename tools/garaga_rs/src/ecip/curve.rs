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

impl CurveID {
    pub fn from_string(s: &str) -> Option<CurveID> {
        match s {
            "BN254" => Some(CurveID::BN254),
            "BLS12_381" => Some(CurveID::BLS12_381),
            "SECP256K1" => Some(CurveID::SECP256K1),
            "SECP256R1" => Some(CurveID::SECP256R1),
            "X25519" => Some(CurveID::X25519),
            _ => None,
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
