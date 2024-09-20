use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::traits::IsField;

#[derive(Debug, Clone)]
pub struct G2Point<F: IsField>
{
    pub x: [FieldElement<F>; 2],
    pub y: [FieldElement<F>; 2],
}

/*
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree2ExtensionField;

pub fn test(_p: G2Point<Degree2ExtensionField>) {

}
*/
