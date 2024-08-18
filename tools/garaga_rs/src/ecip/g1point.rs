use super::curve::CurveParamsProvider;
use lambdaworks_math::field::{element::FieldElement, traits::IsPrimeField};
use num_bigint::{BigInt, BigUint, Sign};

#[derive(Debug, Clone)]
pub struct G1Point<F: IsPrimeField> {
    pub x: FieldElement<F>,
    pub y: FieldElement<F>,
}

impl<F: IsPrimeField + CurveParamsProvider<F>> G1Point<F> {
    pub fn new(x: FieldElement<F>, y: FieldElement<F>) -> Self {
        let point = Self {
            x: x.clone(),
            y: y.clone(),
        };
        if !point.is_infinity() && !point.is_on_curve() {
            panic!(
                "Point ({:?}, {:?}) is not on the curve",
                x.representative().to_string(),
                y.representative().to_string()
            );
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
            return G1Point::new(FieldElement::<F>::zero(), FieldElement::<F>::zero());
        }

        let lambda = if self.eq(other) {
            let alpha = F::get_curve_params().a;

            (FieldElement::<F>::from(3_u64) * self.x.square() + alpha)
                / (FieldElement::<F>::from(2_u64) * self.y.clone())
        } else {
            (other.y.clone() - self.y.clone()) / (other.x.clone() - self.x.clone())
        };

        let x3 = lambda.square() - self.x.clone() - other.x.clone();
        let y3 = lambda * (self.x.clone() - x3.clone()) - self.y.clone();

        G1Point::new(x3, y3)
    }

    pub fn neg(&self) -> Self {
        if self.is_infinity() {
            self.clone()
        } else {
            G1Point::new(self.x.clone(), -self.y.clone())
        }
    }

    pub fn scalar_mul_neg_3(&self) -> G1Point<F> {
        let double_point = self.add(self);
        let triple_point = self.add(&double_point);
        triple_point.neg()
    }
    pub fn scalar_mul(&self, scalar: BigInt) -> G1Point<F> {
        if self.is_infinity() {
            return self.clone();
        }
        if scalar == BigInt::ZERO {
            return G1Point::new(FieldElement::<F>::zero(), FieldElement::<F>::zero());
        }

        let mut result = G1Point::new(FieldElement::<F>::zero(), FieldElement::<F>::zero());
        let mut base = self.clone();

        //println!("scalar mul scalar: {:?}", scalar);
        let sign = scalar.sign();
        let abs_scalar = match sign {
            Sign::Plus => scalar,
            Sign::Minus => -scalar,
            _ => scalar,
        };
        let mut scalar: BigUint = abs_scalar.to_biguint().unwrap();

        while scalar > BigUint::ZERO {
            if &scalar & BigUint::from(1_u64) != BigUint::ZERO {
                result = result.add(&base);
            }
            base = base.add(&base);
            scalar >>= 1;
        }

        if sign == num_bigint::Sign::Minus {
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
        self.y.square() == self.x.clone().square() * self.x.clone() + a * self.x.clone() + b
    }

    pub fn print(&self) {
        println!(
            "G1Point: x = {:?}, y = {:?}",
            self.x.representative().to_string(),
            self.y.representative().to_string()
        );
    }
}

impl<F: IsPrimeField> PartialEq for G1Point<F> {
    fn eq(&self, other: &Self) -> bool {
        self.x == other.x && self.y == other.y
    }
}
