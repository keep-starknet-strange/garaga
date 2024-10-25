use crate::algebra::g1point::G1Point;
use crate::algebra::g2point::G2Point;
use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::traits::{IsField, IsPrimeField, IsSubFieldOf};

#[derive(Debug, Clone)]
pub struct G1G2Pair<F, E2>
where
    F: IsPrimeField + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]>,
{
    pub g1: G1Point<F>,
    pub g2: G2Point<F, E2>,
}

impl<F, E2> G1G2Pair<F, E2>
where
    F: IsPrimeField + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]>,
{
    pub fn new(g1: G1Point<F>, g2: G2Point<F, E2>) -> Self {
        Self { g1, g2 }
    }
}
