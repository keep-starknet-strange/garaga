use crate::algebra::g1point::G1Point;
use crate::algebra::g2point::G2Point;
use lambdaworks_math::field::traits::IsPrimeField;

#[derive(Debug, Clone)]
pub struct G1G2Pair<F: IsPrimeField> {
    pub g1: G1Point<F>,
    pub g2: G2Point<F>,
}

impl<F: IsPrimeField> G1G2Pair<F> {
    pub fn new(g1: G1Point<F>, g2: G2Point<F>) -> Self {
        Self { g1, g2 }
    }
}
