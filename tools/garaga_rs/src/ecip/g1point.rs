use lambdaworks_math::field::{
    element::FieldElement,
    traits::IsPrimeField,
};
use crate::ecip::curve::CurveParams;

#[derive(Debug, Clone, Copy)]
pub struct G1Point<F: IsPrimeField> {
    pub x: FieldElement<F>,
    pub y: FieldElement<F>,
}

impl<F: IsPrimeField> G1Point<F> {
    pub fn new(x: FieldElement<F>, y: FieldElement<F>) -> Self {
        let point = Self { x, y };
        if !point.is_infinity() && !point.is_on_curve() {
            panic!("Point ({:?}, {:?}) is not on the curve", x, y);
        }
        point
    }

    pub fn is_infinity(&self) -> bool {
        self.x.is_zero() && self.y.is_zero()
    }

    pub fn add(&self, other: &G1Point<F>) -> G1Point<F> {
        if self.is_infinity() {
            return *other;
        }
        if other.is_infinity() {
            return *self;
        }

        if self.x == other.x && self.y != other.y {
            return G1Point::new(
                FieldElement::<F>::zero(),
                FieldElement::<F>::zero(),
            );
        }

        let lambda = if self == other {
            (FieldElement::<F>::from(3_u64) * self.x.square())
                / (FieldElement::<F>::from(2_u64) * self.y)
        } else {
            (other.y - self.y) / (other.x - self.x)
        };

        let x3 = lambda.square() - self.x - other.x;
        let y3 = lambda * (self.x - x3) - self.y;

        G1Point::new(x3, y3)
    }

    pub fn neg(&self) -> Self {
        if self.is_infinity() {
            *self
        } else {
            G1Point::new(self.x, -self.y)
        }
    }

    pub fn scalar_mul(&self, scalar: i32) -> G1Point<F> {
        let mut result = G1Point::new(FieldElement::<F>::zero(), FieldElement::<F>::zero());
        let mut base = *self;
        let mut scalar = scalar.abs();

        while scalar != 0 {
            if scalar % 2 != 0 {
                result = result.add(&base);
            }
            base = base.add(&base);
            scalar /= 2;
        }

        if scalar < 0 {
            result = result.neg();
        }

        result
    }

    pub fn is_on_curve(&self) -> bool {
        if self.is_infinity() {
            return true;
        }

        let curve_params = CurveParams::<F>::get(); 
        let a = curve_params.a;
        let b = curve_params.b;

        self.y.square() == self.x.pow(3_u64) + a * self.x + b
    }
}

impl<F: IsPrimeField> PartialEq for G1Point<F> {
    fn eq(&self, other: &Self) -> bool {
        self.x == other.x && self.y == other.y
    }
}
