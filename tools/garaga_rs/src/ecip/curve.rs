use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::BLS12381PrimeField;
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::BN254PrimeField;
use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::fields::montgomery_backed_prime_fields::{
    IsModulus, MontgomeryBackendPrimeField,
};

use crate::ecip::polynomial::Polynomial;
use lambdaworks_math::field::traits::IsPrimeField;
use lambdaworks_math::unsigned_integer::element::U256;
use num_bigint::BigUint;
use std::cmp::PartialEq;
use std::collections::HashMap;

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

pub const SECP256K1_PRIME_FIELD_ORDER: U256 =
    U256::from_hex_unchecked("0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F");

#[derive(Clone, Debug)]
pub struct SECP256K1FieldModulus;
impl IsModulus<U256> for SECP256K1FieldModulus {
    const MODULUS: U256 = SECP256K1_PRIME_FIELD_ORDER;
}

pub type SECP256K1PrimeField = MontgomeryBackendPrimeField<SECP256K1FieldModulus, 4>;

pub const SECP256R1_PRIME_FIELD_ORDER: U256 =
    U256::from_hex_unchecked("0xFFFFFFFF00000001000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF");

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
    pub irreducible_polys: HashMap<usize, &'static [i8]>,
}

pub fn get_irreducible_poly<F: IsPrimeField + CurveParamsProvider<F>>(
    ext_degree: usize,
) -> Polynomial<F> {
    let coeffs = (F::get_curve_params().irreducible_polys)[&ext_degree];
    fn lift<F: IsPrimeField>(c: i8) -> FieldElement<F> {
        if c >= 0 {
            FieldElement::from(c as u64)
        } else {
            -FieldElement::from(-c as u64)
        }
    }
    return Polynomial::new(coeffs.iter().map(|x| lift::<F>(*x)).collect());
}

/// A trait that provides curve parameters for a specific field type.
pub trait CurveParamsProvider<F: IsPrimeField> {
    fn get_curve_params() -> CurveParams<F>;
}

/// A trait to convert a BigUint into a FieldElement.
pub trait FromBigUint<F: IsPrimeField> {
    fn from_biguint(num: BigUint) -> FieldElement<F>;
}

impl CurveParamsProvider<SECP256K1PrimeField> for SECP256K1PrimeField {
    fn get_curve_params() -> CurveParams<SECP256K1PrimeField> {
        CurveParams {
            a: FieldElement::zero(),
            b: FieldElement::from_hex_unchecked("7"),
            g_x: FieldElement::from_hex_unchecked(
                "79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798",
            ),
            g_y: FieldElement::from_hex_unchecked(
                "483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8",
            ),
            n: FieldElement::from_hex_unchecked(
                "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141",
            ),
            h: 1,
            irreducible_polys: HashMap::from([]), // Provide appropriate values here
        }
    }
}

impl CurveParamsProvider<SECP256R1PrimeField> for SECP256R1PrimeField {
    fn get_curve_params() -> CurveParams<SECP256R1PrimeField> {
        CurveParams {
            a: FieldElement::from_hex_unchecked(
                "ffffffff00000001000000000000000000000000fffffffffffffffffffffffc",
            ),
            b: FieldElement::from_hex_unchecked(
                "5ac635d8aa3a93e7b3ebbd55769886bc651d06b0cc53b0f63bce3c3e27d2604b",
            ),
            g_x: FieldElement::from_hex_unchecked(
                "6B17D1F2E12C4247F8BCE6E563A440F277037D812DEB33A0F4A13945D898C296",
            ),
            g_y: FieldElement::from_hex_unchecked(
                "4FE342E2FE1A7F9B8EE7EB4A7C0F9E162CBCE33576B315ECECBB6406837BF51F",
            ),
            n: FieldElement::from_hex_unchecked(
                "FFFFFFFF00000000FFFFFFFFFFFFFFFFBCE6FAADA7179E84F3B9CAC2FC632551",
            ),
            h: 1,
            irreducible_polys: HashMap::from([]), // Provide appropriate values here
        }
    }
}

impl CurveParamsProvider<X25519PrimeField> for X25519PrimeField {
    fn get_curve_params() -> CurveParams<X25519PrimeField> {
        CurveParams {
            a: FieldElement::from_hex_unchecked(
                "0x5d4eacd3a5b9bee63197e10d617b3dd66bb8b65d0ca52af7ac71e18ef8bc172d",
            ),
            b: FieldElement::from_hex_unchecked(
                "0x1d11b29bcfd0b3e0550ddb06105780d5f54831976b9fbc329004ebc1f364b2a4",
            ),
            g_x: FieldElement::from_hex_unchecked("9"),
            g_y: FieldElement::from_hex_unchecked(
                "20AE19A1B8A086B4E01EDD2C7748D14C923D4DF667ADCE0B9A9E39E969A2C0DF",
            ),
            n: FieldElement::from_hex_unchecked(
                "1000000000000000000000000000000014DEF9DEA2F79CD65812631A5CF5D3ED",
            ),
            h: 8,
            irreducible_polys: HashMap::from([]), // Provide appropriate values here
        }
    }
}

impl CurveParamsProvider<BN254PrimeField> for BN254PrimeField {
    fn get_curve_params() -> CurveParams<BN254PrimeField> {
        // You need to provide appropriate curve parameters here
        // Replace the values with the actual curve parameters for BN254
        CurveParams {
            a: FieldElement::zero(),                    // Replace with actual 'a'
            b: FieldElement::from_hex_unchecked("3"),   // Replace with actual 'b'
            g_x: FieldElement::from_hex_unchecked("1"), // Replace with actual 'g_x'
            g_y: FieldElement::from_hex_unchecked("2"), // Replace with actual 'g_y'
            n: FieldElement::from_hex_unchecked("1"),   // Replace with actual 'n'
            h: 1,                                       // Replace with actual 'h'
            irreducible_polys: HashMap::from([
                (6, [82, 0, 0, -18, 0, 0, 1].as_slice()),
                (12, [82, 0, 0, 0, 0, 0, -18, 0, 0, 0, 0, 0, 1].as_slice()),
            ]),
        }
    }
}

impl CurveParamsProvider<BLS12381PrimeField> for BLS12381PrimeField {
    fn get_curve_params() -> CurveParams<BLS12381PrimeField> {
        // You need to provide appropriate curve parameters here
        // Replace the values with the actual curve parameters for BN254
        CurveParams {
            a: FieldElement::zero(),                    // Replace with actual 'a'
            b: FieldElement::from_hex_unchecked("4"),   // Replace with actual 'b'
            g_x: FieldElement::from_hex_unchecked("1"), // Replace with actual 'g_x'
            g_y: FieldElement::from_hex_unchecked("2"), // Replace with actual 'g_y'
            n: FieldElement::from_hex_unchecked("1"),   // Replace with actual 'n'
            h: 1,                                       // Replace with actual 'h'
            irreducible_polys: HashMap::from([
                (6, [2, 0, 0, -2, 0, 0, 1].as_slice()),
                (12, [2, 0, 0, 0, 0, 0, -2, 0, 0, 0, 0, 0, 1].as_slice()),
            ]),
        }
    }
}
