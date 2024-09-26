use crate::algebra::extf_mul::{from_e2, to_e2};
use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::traits::{IsField, IsPrimeField, IsSubFieldOf};

#[derive(Debug, Clone)]
pub struct G2Point<F, E2>
where
    F: IsPrimeField + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]>,
{
    pub x: FieldElement<E2>,
    pub y: FieldElement<E2>,
}

impl<F, E2> G2Point<F, E2>
where
    F: IsPrimeField + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]>,
{
    pub fn new(x: [FieldElement<F>; 2], y: [FieldElement<F>; 2]) -> Result<Self, String> {
        let x = to_e2(x);
        let y = to_e2(y);
        let point = Self { x, y };
        if !point.is_infinity() && !point.is_on_curve() {
            let x = from_e2(point.x);
            let y = from_e2(point.y);
            return Err(format!(
                "Point (({:?}, {:?}), ({:?}, {:?})) is not on the curve",
                x[0].representative().to_string(),
                x[1].representative().to_string(),
                y[0].representative().to_string(),
                y[1].representative().to_string(),
            ));
        }
        Ok(point)
    }

    pub fn new_unchecked(x: [FieldElement<F>; 2], y: [FieldElement<F>; 2]) -> Self {
        let x = to_e2(x);
        let y = to_e2(y);
        Self { x, y }
    }

    pub fn is_infinity(&self) -> bool {
        let zero = to_e2([FieldElement::zero(), FieldElement::zero()]);
        self.x.eq(&zero) && self.y.eq(&zero)
    }

    pub fn is_on_curve(&self) -> bool {
        if self.is_infinity() {
            return true;
        }
        true // TODO
    }
}
