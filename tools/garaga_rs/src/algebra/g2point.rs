use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::traits::IsPrimeField;

#[derive(Debug, Clone)]
pub struct G2Point<F: IsPrimeField>
{
    pub x: [FieldElement<F>; 2],
    pub y: [FieldElement<F>; 2],
}

impl<F: IsPrimeField> G2Point<F> {
    pub fn new(x: [FieldElement<F>; 2], y: [FieldElement<F>; 2]) -> Result<Self, String> {
        let point = Self {
            x,
            y,
        };
        if !point.is_infinity() && !point.is_on_curve() {
            return Err(format!(
                "Point (({:?}, {:?}), ({:?}, {:?})) is not on the curve",
                point.x[0].representative().to_string(),
                point.x[1].representative().to_string(),
                point.y[0].representative().to_string(),
                point.y[1].representative().to_string(),
            ));
        }
        Ok(point)
    }

    pub fn new_unchecked(x: [FieldElement<F>; 2], y: [FieldElement<F>; 2]) -> Self {
        Self { x, y }
    }

    pub fn is_infinity(&self) -> bool {
        let zero = [FieldElement::zero(), FieldElement::zero()];
        self.x.eq(&zero) && self.y.eq(&zero)
    }

    pub fn is_on_curve(&self) -> bool {
        if self.is_infinity() {
            return true;
        }
        return true; // TODO
    }
}

/*
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree2ExtensionField;

pub fn test(_p: G2Point<Degree2ExtensionField>) {

}
*/
