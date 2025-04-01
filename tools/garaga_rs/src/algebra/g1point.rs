use crate::definitions::{CurveParamsProvider, FieldElement};
use lambdaworks_math::field::traits::IsPrimeField;
use num_bigint::{BigInt, BigUint, Sign};
#[derive(Debug, Clone)]
pub struct G1Point<F: IsPrimeField> {
    pub x: FieldElement<F>,
    pub y: FieldElement<F>,
}

impl<F: IsPrimeField + CurveParamsProvider<F>> G1Point<F> {
    pub fn get_coords(&self) -> ([FieldElement<F>; 1], [FieldElement<F>; 1]) {
        ([self.x.clone()], [self.y.clone()])
    }

    pub fn new(x: FieldElement<F>, y: FieldElement<F>) -> Result<Self, String> {
        let point = Self { x, y };
        if !point.is_infinity() && !point.is_on_curve() {
            return Err(format!(
                "Point ({:?}, {:?}) is not on the curve",
                point.x.representative().to_string(),
                point.y.representative().to_string(),
            ));
        }
        Ok(point)
    }

    pub fn new_unchecked(x: FieldElement<F>, y: FieldElement<F>) -> Self {
        Self { x, y }
    }

    pub fn is_infinity(&self) -> bool {
        let zero = FieldElement::zero();
        self.x.eq(&zero) && self.y.eq(&zero)
    }

    pub fn add(&self, other: &G1Point<F>) -> G1Point<F> {
        if self.is_infinity() {
            return other.clone();
        }
        if other.is_infinity() {
            return self.clone();
        }

        if self.x == other.x && self.y != other.y {
            return G1Point::new_unchecked(FieldElement::<F>::zero(), FieldElement::<F>::zero());
        }

        let lambda = if self.eq(other) {
            let alpha = F::get_curve_params().a;
            let numerator = FieldElement::<F>::from(3_u64) * &self.x.square() + alpha;
            let denominator = FieldElement::<F>::from(2_u64) * &self.y;
            numerator / denominator
        } else {
            (&other.y - &self.y) / (&other.x - &self.x)
        }
        .unwrap();

        let x3 = &lambda.square() - &self.x - &other.x;

        let y3 = &lambda * &(self.x.clone() - &x3) - &self.y;

        G1Point::new_unchecked(x3, y3)
    }

    pub fn neg(&self) -> Self {
        if self.is_infinity() {
            self.clone()
        } else {
            G1Point::new_unchecked(self.x.clone(), -self.y.clone())
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
            return G1Point::new_unchecked(FieldElement::<F>::zero(), FieldElement::<F>::zero());
        }

        let mut result =
            G1Point::new_unchecked(FieldElement::<F>::zero(), FieldElement::<F>::zero());
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
    pub fn generator() -> Self {
        let curve_params = F::get_curve_params();
        let generator_x = curve_params.g_x;
        let generator_y = curve_params.g_y;
        G1Point::new(generator_x, generator_y).unwrap()
    }

    pub fn msm(points: &[Self], scalars: &[BigUint]) -> Self {
        assert_eq!(points.len(), scalars.len());
        let mut result =
            G1Point::new_unchecked(FieldElement::<F>::zero(), FieldElement::<F>::zero());
        for i in 0..points.len() {
            result = result.add(&points[i].scalar_mul(scalars[i].clone().into()));
        }
        result
    }
}

impl<F: IsPrimeField> PartialEq for G1Point<F> {
    fn eq(&self, other: &Self) -> bool {
        self.x == other.x && self.y == other.y
    }
}
