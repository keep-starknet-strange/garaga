use crate::algebra::polynomial::Polynomial;
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::BLS12381PrimeField as BLSPF;
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::BN254PrimeField as BNPF;
use lambdaworks_math::field::element::FieldElement as Felt;
use lambdaworks_math::field::fields::fft_friendly::stark_252_prime_field::Stark252PrimeField as StrkPF;
use lambdaworks_math::field::fields::montgomery_backed_prime_fields::{
    IsModulus, MontgomeryBackendPrimeField,
};
use lambdaworks_math::field::traits::IsPrimeField;
use lambdaworks_math::unsigned_integer::element::U256;
use num_bigint::BigUint;
use num_traits::Num;
use std::cmp::PartialEq;
use std::collections::HashMap;

use crate::io::{biguint_from_hex, element_from_biguint};

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum CurveID {
    BN254 = 0,
    BLS12_381 = 1,
    SECP256K1 = 2,
    SECP256R1 = 3,
    X25519 = 4,
    GRUMPKIN = 5,
}

impl TryFrom<u8> for CurveID {
    type Error = String;

    fn try_from(value: u8) -> Result<Self, Self::Error> {
        match value {
            0 => Ok(CurveID::BN254),
            1 => Ok(CurveID::BLS12_381),
            2 => Ok(CurveID::SECP256K1),
            3 => Ok(CurveID::SECP256R1),
            4 => Ok(CurveID::X25519),
            5 => Ok(CurveID::GRUMPKIN),
            _ => Err(format!("Invalid curve ID: {}", value)),
        }
    }
}

impl TryFrom<usize> for CurveID {
    type Error = String;

    fn try_from(value: usize) -> Result<Self, Self::Error> {
        match value {
            0 => Ok(CurveID::BN254),
            1 => Ok(CurveID::BLS12_381),
            2 => Ok(CurveID::SECP256K1),
            3 => Ok(CurveID::SECP256R1),
            4 => Ok(CurveID::X25519),
            5 => Ok(CurveID::GRUMPKIN),
            _ => Err(format!("Invalid curve ID: {}", value)),
        }
    }
}
pub type FieldElement<F> = Felt<F>;
pub type BN254PrimeField = BNPF;
pub type BLS12381PrimeField = BLSPF;
pub type Stark252PrimeField = StrkPF;

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

pub const GRUMPKIN_PRIME_FIELD_ORDER: U256 =
    U256::from_hex_unchecked("0x30644E72E131A029B85045B68181585D2833E84879B9709143E1F593F0000001");

#[derive(Clone, Debug)]
pub struct GrumpkinFieldModulus;
impl IsModulus<U256> for GrumpkinFieldModulus {
    const MODULUS: U256 = GRUMPKIN_PRIME_FIELD_ORDER;
}

pub type GrumpkinPrimeField = MontgomeryBackendPrimeField<GrumpkinFieldModulus, 4>;

pub struct CurveParams<F: IsPrimeField> {
    pub curve_id: CurveID,
    pub a: FieldElement<F>,
    pub b: FieldElement<F>,
    pub b20: FieldElement<F>,
    pub b21: FieldElement<F>,
    pub g_x: FieldElement<F>,
    pub g_y: FieldElement<F>,
    pub n: BigUint, // Order of the curve
    pub h: u32,     // Cofactor
    pub fp_generator: FieldElement<F>,
    pub irreducible_polys: HashMap<usize, &'static [i8]>,
    pub loop_counter: &'static [i8],
    pub nr_a0: u64, // E2 non residue
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
            curve_id: CurveID::SECP256K1,
            a: FieldElement::zero(),
            b: FieldElement::from_hex_unchecked("7"),
            b20: FieldElement::zero(), // Provide appropriate values here
            b21: FieldElement::zero(), // Provide appropriate values here
            g_x: FieldElement::from_hex_unchecked(
                "79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798",
            ),
            g_y: FieldElement::from_hex_unchecked(
                "483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8",
            ),
            n: BigUint::from_str_radix(
                "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141",
                16,
            )
            .unwrap(),
            h: 1,
            fp_generator: FieldElement::from(3),
            irreducible_polys: HashMap::from([]), // Provide appropriate values here
            loop_counter: &[],                    // Provide appropriate values here
            nr_a0: 0,                             // Provide appropriate values here
        }
    }
}

impl CurveParamsProvider<SECP256R1PrimeField> for SECP256R1PrimeField {
    fn get_curve_params() -> CurveParams<SECP256R1PrimeField> {
        CurveParams {
            curve_id: CurveID::SECP256R1,
            a: FieldElement::from_hex_unchecked(
                "ffffffff00000001000000000000000000000000fffffffffffffffffffffffc",
            ),
            b: FieldElement::from_hex_unchecked(
                "5ac635d8aa3a93e7b3ebbd55769886bc651d06b0cc53b0f63bce3c3e27d2604b",
            ),
            b20: FieldElement::zero(), // Provide appropriate values here
            b21: FieldElement::zero(), // Provide appropriate values here
            g_x: FieldElement::from_hex_unchecked(
                "6B17D1F2E12C4247F8BCE6E563A440F277037D812DEB33A0F4A13945D898C296",
            ),
            g_y: FieldElement::from_hex_unchecked(
                "4FE342E2FE1A7F9B8EE7EB4A7C0F9E162CBCE33576B315ECECBB6406837BF51F",
            ),
            n: BigUint::from_str_radix(
                "FFFFFFFF00000000FFFFFFFFFFFFFFFFBCE6FAADA7179E84F3B9CAC2FC632551",
                16,
            )
            .unwrap(),
            h: 1,
            fp_generator: FieldElement::from(6),
            irreducible_polys: HashMap::from([]), // Provide appropriate values here
            loop_counter: &[],                    // Provide appropriate values here
            nr_a0: 0,                             // Provide appropriate values here
        }
    }
}

impl CurveParamsProvider<X25519PrimeField> for X25519PrimeField {
    fn get_curve_params() -> CurveParams<X25519PrimeField> {
        CurveParams {
            curve_id: CurveID::X25519,
            a: FieldElement::from_hex_unchecked(
                "0x5d4eacd3a5b9bee63197e10d617b3dd66bb8b65d0ca52af7ac71e18ef8bc172d",
            ),
            b: FieldElement::from_hex_unchecked(
                "0x1d11b29bcfd0b3e0550ddb06105780d5f54831976b9fbc329004ebc1f364b2a4",
            ),
            b20: FieldElement::zero(), // Provide appropriate values here
            b21: FieldElement::zero(), // Provide appropriate values here
            g_x: FieldElement::from_hex_unchecked("9"),
            g_y: FieldElement::from_hex_unchecked(
                "20AE19A1B8A086B4E01EDD2C7748D14C923D4DF667ADCE0B9A9E39E969A2C0DF",
            ),
            n: BigUint::from_str_radix(
                "1000000000000000000000000000000014DEF9DEA2F79CD65812631A5CF5D3ED",
                16,
            )
            .unwrap(),
            h: 8,
            fp_generator: FieldElement::from(6),
            irreducible_polys: HashMap::from([]), // Provide appropriate values here
            loop_counter: &[],                    // Provide appropriate values here
            nr_a0: 0,                             // Provide appropriate values here
        }
    }
}

impl CurveParamsProvider<GrumpkinPrimeField> for GrumpkinPrimeField {
    fn get_curve_params() -> CurveParams<GrumpkinPrimeField> {
        CurveParams {
            curve_id: CurveID::GRUMPKIN,
            a: FieldElement::from_hex_unchecked("0"),
            b: FieldElement::from_hex_unchecked(
                "0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593effffff0",
            ),
            b20: FieldElement::zero(),
            b21: FieldElement::zero(),
            g_x: FieldElement::from_hex_unchecked("0x1"),
            g_y: FieldElement::from_hex_unchecked(
                "0x2CF135E7506A45D632D270D45F1181294833FC48D823F272C",
            ),
            n: BigUint::from_str_radix(
                "30644E72E131A029B85045B68181585D97816A916871CA8D3C208C16D87CFD47",
                16,
            )
            .unwrap(),
            h: 1,
            fp_generator: FieldElement::from(5),
            irreducible_polys: HashMap::from([]), // Provide appropriate values here
            loop_counter: &[],                    // Provide appropriate values here
            nr_a0: 0,                             // Provide appropriate values here
        }
    }
}

impl CurveParamsProvider<BN254PrimeField> for BN254PrimeField {
    fn get_curve_params() -> CurveParams<BN254PrimeField> {
        CurveParams {
            curve_id: CurveID::BN254,
            a: FieldElement::zero(),
            b: FieldElement::from(3),
            b20: FieldElement::from_hex_unchecked(
                "2B149D40CEB8AAAE81BE18991BE06AC3B5B4C5E559DBEFA33267E6DC24A138E5",
            ),
            b21: FieldElement::from_hex_unchecked(
                "009713B03AF0FED4CD2CAFADEED8FDF4A74FA084E52D1852E4A2BD0685C315D2",
            ),
            g_x: FieldElement::from_hex_unchecked("1"), // Replace with actual 'g_x'
            g_y: FieldElement::from_hex_unchecked("2"), // Replace with actual 'g_y'
            n: BigUint::from_str_radix(
                "30644E72E131A029B85045B68181585D2833E84879B9709143E1F593F0000001",
                16,
            )
            .unwrap(),
            h: 1, // Replace with actual 'h'
            fp_generator: FieldElement::from(3),
            irreducible_polys: HashMap::from([
                (6, [82, 0, 0, -18, 0, 0, 1].as_slice()),
                (12, [82, 0, 0, 0, 0, 0, -18, 0, 0, 0, 0, 0, 1].as_slice()),
            ]),
            loop_counter: &[
                0, 0, 0, -1, -1, 0, -1, 0, 0, 0, -1, 0, 0, 0, 1, 0, 0, -1, 0, -1, 0, 0, 0, 1, 0,
                -1, 0, 0, 0, 0, -1, 0, 0, 1, 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, -1, 0, 0, 1, 1, 0, 0,
                -1, 0, 0, 0, -1, 0, -1, 0, 0, 0, 1, 0, -1, 0, 1,
            ],
            nr_a0: 9,
        }
    }
}

impl CurveParamsProvider<BLS12381PrimeField> for BLS12381PrimeField {
    fn get_curve_params() -> CurveParams<BLS12381PrimeField> {
        CurveParams {
            curve_id: CurveID::BLS12_381,
            a: FieldElement::zero(),
            b: FieldElement::from(4),
            b20: FieldElement::from_hex_unchecked("4"),
            b21: FieldElement::from_hex_unchecked("4"),
            g_x: FieldElement::from_hex_unchecked("1"), // Replace with actual 'g_x'
            g_y: FieldElement::from_hex_unchecked("2"), // Replace with actual 'g_y'
            n: BigUint::from_str_radix(
                "73EDA753299D7D483339D80809A1D80553BDA402FFFE5BFEFFFFFFFF00000001",
                16,
            )
            .unwrap(),
            h: 1, // Replace with actual 'h'
            fp_generator: FieldElement::from(3),
            irreducible_polys: HashMap::from([
                (6, [2, 0, 0, -2, 0, 0, 1].as_slice()),
                (12, [2, 0, 0, 0, 0, 0, -2, 0, 0, 0, 0, 0, 1].as_slice()),
            ]),
            loop_counter: &[
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
                0, 1, 0, 0, 1, 0, 1, 1,
            ],
            nr_a0: 1,
        }
    }
}

pub trait ToWeierstrassCurve {
    fn to_weirstrass(
        x_twisted: FieldElement<X25519PrimeField>,
        y_twisted: FieldElement<X25519PrimeField>,
    ) -> (
        FieldElement<X25519PrimeField>,
        FieldElement<X25519PrimeField>,
    );
}

pub trait ToTwistedEdwardsCurve {
    fn to_twistededwards(
        x_weierstrass: FieldElement<X25519PrimeField>,
        y_weierstrass: FieldElement<X25519PrimeField>,
    ) -> (
        FieldElement<X25519PrimeField>,
        FieldElement<X25519PrimeField>,
    );
}

impl ToWeierstrassCurve for X25519PrimeField {
    fn to_weirstrass(
        x_twisted: FieldElement<X25519PrimeField>,
        y_twisted: FieldElement<X25519PrimeField>,
    ) -> (
        FieldElement<X25519PrimeField>,
        FieldElement<X25519PrimeField>,
    ) {
        let a = element_from_biguint::<X25519PrimeField>(&biguint_from_hex(
            "0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEC",
        )); // Replace with actual a_twisted
        let d = element_from_biguint::<X25519PrimeField>(&biguint_from_hex(
            "0x52036CEE2B6FFE738CC740797779E89800700A4D4141D8AB75EB4DCA135978A3",
        )); // Replace with actual d_twisted

        let x = (FieldElement::<X25519PrimeField>::from(5) * a.clone()
            + a.clone() * y_twisted.clone()
            - FieldElement::<X25519PrimeField>::from(5) * d.clone() * y_twisted.clone()
            - d.clone())
            * (FieldElement::<X25519PrimeField>::from(12)
                - FieldElement::<X25519PrimeField>::from(12) * y_twisted.clone())
            .inv()
            .unwrap();
        let y = (a.clone() + a * y_twisted.clone() - d.clone() * y_twisted.clone() - d)
            * (FieldElement::<X25519PrimeField>::from(4) * x_twisted.clone()
                - FieldElement::<X25519PrimeField>::from(4) * x_twisted.clone() * y_twisted)
                .inv()
                .unwrap();

        (x, y)
    }
}

impl ToTwistedEdwardsCurve for X25519PrimeField {
    fn to_twistededwards(
        x_weierstrass: FieldElement<X25519PrimeField>,
        y_weierstrass: FieldElement<X25519PrimeField>,
    ) -> (
        FieldElement<X25519PrimeField>,
        FieldElement<X25519PrimeField>,
    ) {
        let a = element_from_biguint::<X25519PrimeField>(&biguint_from_hex(
            "0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEC",
        )); // Replace with actual a_twisted
        let d = element_from_biguint::<X25519PrimeField>(&biguint_from_hex(
            "0x52036CEE2B6FFE738CC740797779E89800700A4D4141D8AB75EB4DCA135978A3",
        )); // Replace with actual d_twisted

        let y = (FieldElement::<X25519PrimeField>::from(5) * a.clone()
            - FieldElement::<X25519PrimeField>::from(12) * x_weierstrass.clone()
            - d.clone())
            * (-FieldElement::<X25519PrimeField>::from(12) * x_weierstrass.clone() - a.clone()
                + FieldElement::<X25519PrimeField>::from(5) * d.clone())
            .inv()
            .unwrap();
        let x = (a.clone() + a.clone() * y.clone() - d.clone() * y.clone() - d)
            * (FieldElement::<X25519PrimeField>::from(4) * y_weierstrass.clone()
                - FieldElement::<X25519PrimeField>::from(4) * y_weierstrass.clone() * y.clone())
            .inv()
            .unwrap();

        (x, y)
    }
}

pub fn get_modulus_from_curve_id(curve_id: CurveID) -> BigUint {
    match curve_id {
        CurveID::BN254 => biguint_from_hex("0x30644E72E131A029B85045B68181585D97816A916871CA8D3C208C16D87CFD47"),
        CurveID::BLS12_381 => biguint_from_hex("0x1A0111EA397FE69A4B1BA7B6434BACD764774B84F38512BF6730D2A0F6B0F6241EABFFFEB153FFFFB9FEFFFFFFFFAAAB"),
        CurveID::SECP256K1 => biguint_from_hex("0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F"),
        CurveID::SECP256R1 => biguint_from_hex("0xFFFFFFFF00000001000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF"),
        CurveID::X25519 => biguint_from_hex("0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFED"),
        CurveID::GRUMPKIN => biguint_from_hex("0x30644E72E131A029B85045B68181585D2833E84879B9709143E1F593F0000001"),
    }
}

#[cfg(test)]
mod tests {

    use super::{CurveParamsProvider, ToTwistedEdwardsCurve, ToWeierstrassCurve, X25519PrimeField};

    #[test]
    fn test_to_weierstrass_and_back() {
        let curve = X25519PrimeField::get_curve_params();

        let x_weirstrass = curve.g_x;
        let y_weirstrass = curve.g_y;

        let (x_twisted, y_twisted) =
            X25519PrimeField::to_twistededwards(x_weirstrass.clone(), y_weirstrass.clone());
        let (x_weirstrass_back, y_weirstrass_back) =
            X25519PrimeField::to_weirstrass(x_twisted, y_twisted);

        assert_eq!(x_weirstrass, x_weirstrass_back);
        assert_eq!(y_weirstrass, y_weirstrass_back);
    }
}
