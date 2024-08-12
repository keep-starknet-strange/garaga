use lambdaworks_math::field::{
    element::FieldElement,
    traits::IsPrimeField,
};

use super::curve::CurveParamsProvider;

#[derive(Debug, Clone)]
pub struct G1Point<F: IsPrimeField> {
    pub x: FieldElement<F>,
    pub y: FieldElement<F>,
}

impl<F: IsPrimeField + CurveParamsProvider<F>> G1Point<F> {
    pub fn new(x: FieldElement<F>, y: FieldElement<F>) -> Self {
        let point = Self { x: x.clone(), y: y.clone() };
        if !point.is_infinity() && !point.is_on_curve() {
            panic!("Point ({:?}, {:?}) is not on the curve", x, y);
        }
        point
    }

    pub fn is_infinity(&self) -> bool {
        self.x.eq(&FieldElement::zero()) && self.y.eq(&FieldElement::zero())
    }

    pub fn add(&self, other: &G1Point<F>) -> G1Point<F> {
        if self.is_infinity() {
            return other.clone();
        }
        if other.is_infinity() {
            return self.clone();
        }

        if self.x == other.x && self.y != other.y {
            return G1Point::new(
                FieldElement::<F>::zero(),
                FieldElement::<F>::zero(),
            );
        }

        let lambda = if self == other {
            (FieldElement::<F>::from(3_u64) * self.x.square())
                / (FieldElement::<F>::from(2_u64) * self.y.clone())
        } else {
            (other.y.clone() - self.y.clone()) / (other.x.clone() - self.x.clone())
        };

        let x3 = lambda.square() - self.x.clone() - other.x.clone();
        let y3 = lambda * (self.x.clone() - x3.clone()) - self.y.clone();

        return G1Point::new(x3, y3);
    }

    pub fn neg(&self) -> Self {
        if self.is_infinity() {
            self.clone()
        } else {
            G1Point::new(self.x.clone(), -self.y.clone())
        }
    }

    pub fn scalar_mul(&self, mut scalar: i64) -> G1Point<F> {
        if self.is_infinity() {
            return self.clone();
        }
        if scalar == 0 {
            return G1Point::new(FieldElement::<F>::zero(), FieldElement::<F>::zero());
        }

        let mut result = G1Point::new(FieldElement::<F>::zero(), FieldElement::<F>::zero());
        let mut base = self.clone();

        let is_negative = scalar < 0;
        scalar = scalar.abs();

        while scalar > 0 {
            if scalar % 2 != 0 {
                result = result.add(&base);
            }
            base = base.add(&base);
            scalar /= 2;
        }

        if is_negative {
            result = result.neg();
        }

        result
    }

    pub fn is_on_curve(&self) -> bool {
        if self.is_infinity() {
            return true;
        }

        let curve_params = F::get_curve_params();
        let a = curve_params.a;
        let b = curve_params.b;

        self.y.square() == self.x.pow(3_u64) + a * self.x.clone() + b
    }
}

impl<F: IsPrimeField> PartialEq for G1Point<F> {
    fn eq(&self, other: &Self) -> bool {
        self.x == other.x && self.y == other.y
    }
}
