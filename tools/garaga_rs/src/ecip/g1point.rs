use lambdaworks_math::field::{
    element::FieldElement,
    fields::fft_friendly::stark_252_prime_field::Stark252PrimeField,
};
use crate::ecip::curve::CurveID;

#[derive(Debug, Clone, Copy)]
pub struct G1Point {
    pub x: FieldElement<Stark252PrimeField>,
    pub y: FieldElement<Stark252PrimeField>,
    pub curve_id: CurveID,
}

impl G1Point {
    pub fn new(x: FieldElement<Stark252PrimeField>, y: FieldElement<Stark252PrimeField>, curve_id: CurveID) -> Self {
        let point = Self { x, y, curve_id };
        if !point.is_infinity() && !point.is_on_curve() {
            panic!("Point ({:?}, {:?}) is not on the curve", x, y);
        }
        point
    }

    pub fn is_infinity(&self) -> bool {
        self.x.is_zero() && self.y.is_zero()
    }

    pub fn add(&self, other: &G1Point) -> G1Point {
        if self.is_infinity() {
            return *other;
        }
        if other.is_infinity() {
            return *self;
        }
        if self.curve_id != other.curve_id {
            panic!("Points are not on the same curve");
        }

        if self.x == other.x && self.y != other.y {
            return G1Point::new(
                FieldElement::<Stark252PrimeField>::zero(),
                FieldElement::<Stark252PrimeField>::zero(),
                self.curve_id,
            );
        }

        let lambda = if self == other {
            (FieldElement::<Stark252PrimeField>::from(3) * self.x.pow(2))
                / (FieldElement::<Stark252PrimeField>::from(2) * self.y)
        } else {
            (other.y - self.y) / (other.x - self.x)
        };

        let x3 = lambda.pow(2) - self.x - other.x;
        let y3 = lambda * (self.x - x3) - self.y;

        G1Point::new(x3, y3, self.curve_id)
    }

    pub fn neg(&self) -> Self {
        if self.is_infinity() {
            *self
        } else {
            G1Point::new(self.x, -self.y, self.curve_id)
        }
    }

    pub fn scalar_mul(&self, scalar: i32) -> G1Point {
        G1Point::default()
    }

    pub fn is_on_curve(&self) -> bool {
        if self.is_infinity() {
            return true;
        }
        let a = CURVES[self.curve_id as usize].a;
        let b = CURVES[self.curve_id as usize].b;
        self.y.pow(2) == self.x.pow(3) + a * self.x + b
    }
}

impl PartialEq for G1Point {
    fn eq(&self, other: &Self) -> bool {
        self.x == other.x && self.y == other.y && self.curve_id == other.curve_id
    }
}