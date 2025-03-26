use crate::algebra::extf_mul::{from_e2, to_e2};
use crate::definitions::{CurveParamsProvider, FieldElement};
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
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]>,
{
    pub fn get_coords(&self) -> ([FieldElement<F>; 2], [FieldElement<F>; 2]) {
        (from_e2(self.x.clone()), from_e2(self.y.clone()))
    }

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

    pub fn new_unchecked(x: FieldElement<E2>, y: FieldElement<E2>) -> Self {
        Self { x, y }
    }

    pub fn is_infinity(&self) -> bool {
        let zero = to_e2([FieldElement::zero(), FieldElement::zero()]);
        self.x.eq(&zero) && self.y.eq(&zero)
    }

    pub fn neg(&self) -> Self {
        if self.is_infinity() {
            self.clone()
        } else {
            G2Point::new_unchecked(self.x.clone(), -self.y.clone())
        }
    }

    pub fn is_on_curve(&self) -> bool {
        if self.is_infinity() {
            return true;
        }

        let curve_params = F::get_curve_params();
        let a = curve_params.a;
        let b = to_e2([curve_params.b20, curve_params.b21]);
        self.y.square() == self.x.clone().square() * self.x.clone() + a * self.x.clone() + b
    }

    pub fn generator() -> Self {
        let curve_params = F::get_curve_params();
        let generator_x = curve_params
            .g2_x
            .expect("G2 generator coordinates not defined for this curve");
        let generator_y = curve_params
            .g2_y
            .expect("G2 generator coordinates not defined for this curve");
        G2Point::new(generator_x, generator_y).unwrap()
    }

    pub fn compute_doubling_slope(a: &Self) -> FieldElement<E2> {
        let [x, y] = &from_e2(a.x.clone());
        let num = to_e2([
            (x + y) * (x - y) * FieldElement::<F>::from(3),
            x * y * FieldElement::<F>::from(6),
        ]);
        (num / (&a.y + &a.y)).unwrap()
    }

    pub fn compute_adding_slope(a: &Self, b: &Self) -> FieldElement<E2> {
        ((&a.y - &b.y) / (&a.x - &b.x)).unwrap()
    }
}
