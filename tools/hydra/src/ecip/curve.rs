use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::fields::fft_friendly::stark_252_prime_field::Stark252PrimeField;

pub struct Curve {
    pub a: u64,
    pub b: u64,
    pub fp_generator: u64,
}

pub const CURVES: [Curve; 1] = [
    Curve {
        a: 0,
        b: 0, 
        fp_generator: 3,
    },
];
