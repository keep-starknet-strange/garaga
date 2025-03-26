use crate::algebra::polynomial::Polynomial;
use crate::definitions::FieldElement;
use lambdaworks_math::field::traits::IsPrimeField;

#[derive(Debug, Clone)]
pub struct RationalFunction<F: IsPrimeField> {
    pub numerator: Polynomial<F>,
    pub denominator: Polynomial<F>,
}

impl<F: IsPrimeField> RationalFunction<F> {
    pub fn new(numerator: Polynomial<F>, denominator: Polynomial<F>) -> Self {
        Self {
            numerator,
            denominator,
        }
    }

    pub fn simplify(&self) -> RationalFunction<F> {
        let (_, _, gcd) = self.numerator.xgcd(&self.denominator);
        let num_simplified = self.numerator.clone().div_with_ref(&gcd);
        let den_simplified = self.denominator.clone().div_with_ref(&gcd);

        RationalFunction::new(
            num_simplified.scale_by_coeff(&self.denominator.leading_coefficient().inv().unwrap()),
            den_simplified.scale_by_coeff(&den_simplified.leading_coefficient().inv().unwrap()),
        )
    }

    pub fn evaluate(&self, x: FieldElement<F>) -> FieldElement<F> {
        (self.numerator.evaluate(&x.clone()) / self.denominator.evaluate(&x.clone())).unwrap()
    }

    pub fn scale_by_coeff(&self, coeff: FieldElement<F>) -> RationalFunction<F> {
        RationalFunction::new(
            self.numerator.scale_by_coeff(&coeff),
            self.denominator.clone(),
        )
    }
}

impl<F: IsPrimeField> std::ops::Add for RationalFunction<F> {
    type Output = RationalFunction<F>;

    fn add(self, other: RationalFunction<F>) -> RationalFunction<F> {
        let num_1: Polynomial<F> = self.numerator.clone() * other.denominator.clone();
        let num_2 = other.numerator.clone() * self.denominator.clone();
        let num = num_1 + num_2;
        let den: Polynomial<F> = self.denominator.clone() * other.denominator.clone();
        RationalFunction::new(num, den).simplify()
    }
}

#[derive(Debug, Clone)]
pub struct FunctionFelt<F: IsPrimeField> {
    pub a: RationalFunction<F>,
    pub b: RationalFunction<F>,
}

impl<F: IsPrimeField> FunctionFelt<F> {
    pub fn new(a: RationalFunction<F>, b: RationalFunction<F>) -> Self {
        Self { a, b }
    }

    pub fn simplify(&self) -> FunctionFelt<F> {
        FunctionFelt::new(self.a.simplify(), self.b.simplify())
    }

    pub fn evaluate(&self, x: FieldElement<F>, y: &FieldElement<F>) -> FieldElement<F> {
        self.a.evaluate(x.clone()) + y * self.b.evaluate(x.clone())
    }

    pub fn scale_by_coeff(&self, coeff: FieldElement<F>) -> FunctionFelt<F> {
        FunctionFelt::new(
            self.a.scale_by_coeff(coeff.clone()),
            self.b.scale_by_coeff(coeff),
        )
    }

    // def print_as_sage_poly(self, var: str = "x") -> str:
    //     return f"(({self.b.numerator.print_as_sage_poly(var)}) / ({self.b.denominator.print_as_sage_poly(var)}) * y + ({self.a.numerator.print_as_sage_poly(var)} / ({self.a.denominator.print_as_sage_poly(var)})"

    pub fn print_as_sage_poly(&self) -> String {
        format!(
            "(({}) / ({}) * y + ({}) / ({})",
            self.b.numerator.print_as_sage_poly(),
            self.b.denominator.print_as_sage_poly(),
            self.a.numerator.print_as_sage_poly(),
            self.a.denominator.print_as_sage_poly()
        )
    }
}

impl<F: IsPrimeField> std::ops::Add for FunctionFelt<F> {
    type Output = FunctionFelt<F>;

    fn add(self, other: FunctionFelt<F>) -> FunctionFelt<F> {
        FunctionFelt {
            a: self.a + other.a,
            b: self.b + other.b,
        }
    }
}
