use lambdaworks_math::field::{
    element::FieldElement,
    fields::fft_friendly::stark_252_prime_field::Stark252PrimeField,
    traits::IsField,
};

#[derive(Debug, Clone, Copy)]
pub struct G1Point {
    x: FieldElement<Stark252PrimeField>,
    y: FieldElement<Stark252PrimeField>,
    infinity: bool,
}

impl G1Point {
    pub fn new(x: FieldElement<Stark252PrimeField>, y: FieldElement<Stark252PrimeField>, infinity: bool) -> Self {
        Self { x, y, infinity }
    }

    pub fn is_infinity(&self) -> bool {
        self.infinity
    }

    pub fn add(&self, other: &G1Point) -> G1Point {
        if self.is_infinity() {
            return *other;
        }
        if other.is_infinity() {
            return *self;
        }

        if self.x == other.x && self.y != other.y {
            return G1Point {
                x: FieldElement::<Stark252PrimeField>::zero(),
                y: FieldElement::<Stark252PrimeField>::zero(),
                infinity: true,
            };
        }

        let lambda = if self == other {
            (FieldElement::<Stark252PrimeField>::from(3) * self.x.pow(2)) / (FieldElement::<Stark252PrimeField>::from(2) * self.y)
        } else {
            (other.y - self.y) / (other.x - self.x)
        };

        let x3 = lambda.pow(2) - self.x - other.x;
        let y3 = lambda * (self.x - x3) - self.y;

        G1Point {
            x: x3,
            y: y3,
            infinity: false,
        }
    }

    pub fn neg(&self) -> Self {
        if self.is_infinity() {
            *self
        } else {
            Self {
                x: self.x,
                y: -self.y,
                infinity: self.infinity,
            }
        }
    }

    fn scalar_mul(&self, scalar: i32) -> G1Point {
        G1Point::default()
    }

    /// Checks if a point is on the curve defined by y^2 = x^3 + ax + b
    pub fn is_on_curve(&self, a: FieldElement<Stark252PrimeField>, b: FieldElement<Stark252PrimeField>) -> bool {
        if self.is_infinity() {
            return true;
        }
        self.y.pow(2) == self.x.pow(3) + a * self.x + b
    }
}

impl PartialEq for G1Point {
    fn eq(&self, other: &Self) -> bool {
        self.x == other.x && self.y == other.y && self.infinity == other.infinity
    }
}
