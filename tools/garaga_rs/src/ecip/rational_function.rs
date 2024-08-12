use lambdaworks_math::field::{element::FieldElement, traits::IsPrimeField};
use crate::ecip::polynomial::Polynomial;

#[derive(Debug, Clone)]
pub struct RationalFunction<F: IsPrimeField + PartialEq> {
    numerator: Polynomial<F>,
    denominator: Polynomial<F>,
}

impl<F: IsPrimeField + PartialEq> RationalFunction<F> {
    pub fn new(numerator: Polynomial<F>, denominator: Polynomial<F>) -> Self {
        Self { numerator, denominator }
    }

    pub fn simplify(&self) -> RationalFunction<F> {
        let (gcd, _num_s, _den_s) = self.numerator.clone().xgcd(&self.denominator);
        let num_simplified = self.numerator.clone().div_with_ref(&gcd);
        let den_simplified = self.denominator.clone().div_with_ref(&gcd);
        RationalFunction::new(num_simplified, den_simplified)
    }

    pub fn evaluate(&self, x: FieldElement<F>) -> FieldElement<F> {
        self.numerator.evaluate(&x.clone()) / self.denominator.evaluate(&x.clone())
    }
}

#[derive(Debug, Clone)]
pub struct FunctionFelt<F: IsPrimeField + PartialEq> {
    a: RationalFunction<F>,
    b: RationalFunction<F>,
}

impl<F: IsPrimeField + PartialEq> FunctionFelt<F> {
    pub fn new(a: RationalFunction<F>, b: RationalFunction<F>) -> Self {
        Self { a, b }
    }

    pub fn simplify(&self) -> FunctionFelt<F> {
        FunctionFelt::new(self.a.simplify(), self.b.simplify())
    }

    pub fn evaluate(&self, x: FieldElement<F>, y: &FieldElement<F>) -> FieldElement<F> {
        self.a.evaluate(x.clone()) + y * self.b.evaluate(x.clone())
    }
}
