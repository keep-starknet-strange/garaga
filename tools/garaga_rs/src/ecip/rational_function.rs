#[derive(Debug, Clone)]
pub struct RationalFunction {
    numerator: Polynomial,
    denominator: Polynomial,
}

impl RationalFunction {
    pub fn new(numerator: Polynomial, denominator: Polynomial) -> Self {
        Self { numerator, denominator }
    }

    pub fn simplify(&self) -> RationalFunction {
        let (gcd, num_s, den_s) = self.numerator.clone().xgcd(&self.denominator);
        let num_simplified = self.numerator.clone().div_with_ref(&gcd);
        let den_simplified = self.denominator.clone().div_with_ref(&gcd);
        RationalFunction::new(num_simplified, den_simplified)
    }
}

#[derive(Debug, Clone)]
pub struct FunctionFelt {
    a: RationalFunction,
    b: RationalFunction,
}

impl FunctionFelt {
    pub fn new(a: RationalFunction, b: RationalFunction) -> Self {
        Self { a, b }
    }

    pub fn simplify(&self) -> FunctionFelt {
        FunctionFelt::new(self.a.simplify(), self.b.simplify())
    }

    pub fn evaluate(&self, x: PyFelt, y: PyFelt) -> PyFelt {
        self.a.evaluate(x) + y * self.b.evaluate(x)
    }
}
