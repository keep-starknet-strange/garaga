use crate::algebra::g1point::G1Point;
use crate::algebra::g2point::G2Point;
use crate::definitions::{CurveParamsProvider, FieldElement};
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
    F: IsPrimeField + IsSubFieldOf<E2> + CurveParamsProvider<F>,
    E2: IsField<BaseType = [FieldElement<F>; 2]>,
{
    pub fn new(g1: G1Point<F>, g2: G2Point<F, E2>) -> Self {
        Self { g1, g2 }
    }
    pub fn flatten(&self) -> Vec<FieldElement<F>> {
        let mut elements = vec![];
        let (x, y) = self.g1.get_coords();
        elements.push(x[0].clone());
        elements.push(y[0].clone());
        let (x, y) = self.g2.get_coords();
        elements.push(x[0].clone());
        elements.push(x[1].clone());
        elements.push(y[0].clone());
        elements.push(y[1].clone());
        elements
    }
}
