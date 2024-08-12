use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::traits::IsPrimeField;
use crate::ecip::curve::CurveID;
use rand::Rng;

#[derive(Debug, Clone, Copy)]
pub struct BaseField<F: IsPrimeField> {
    p: FieldElement<F>,
}

impl<F: IsPrimeField> BaseField<F> {
    pub fn new(p: FieldElement<F>) -> Self {
        Self { p }
    }

    pub fn call(&self, integer: u64) -> FieldElement<F> {
        FieldElement::from(integer) % self.p
    }

    pub fn zero(&self) -> FieldElement<F> {
        FieldElement::zero()
    }

    pub fn one(&self) -> FieldElement<F> {
        FieldElement::one()
    }

    pub fn random(&self) -> FieldElement<F> {
        let mut rng = rand::thread_rng();
        FieldElement::from(rng.gen_range(0..self.p.to_u64().unwrap()))
    }
    
    pub fn get_base_field(curve_id: CurveID) -> BaseField<F> {
        let p = match curve_id {
            CurveID::BN254 => {
                FieldElement::<F>::from_hex("30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47").unwrap()
            }
            CurveID::BLS12_381 => {
                FieldElement::<F>::from_hex("1a0111ea397fe69a4b1ba7b6434bacd7d849bd29dba07b12b1ba3a5d7d3b7c5b").unwrap()
            }
            CurveID::SECP256K1 => {
                FieldElement::<F>::from_hex("fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f").unwrap()
            }
            CurveID::SECP256R1 => {
                FieldElement::<F>::from_hex("ffffffff00000001000000000000000000000000ffffffffffffffffffffffff").unwrap()
            }
            CurveID::X25519 => {
                FieldElement::<F>::from_hex("7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffed").unwrap()
            }
        };
        BaseField::new(p)
    }
}
