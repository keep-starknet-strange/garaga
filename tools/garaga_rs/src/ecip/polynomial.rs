use lambdaworks_math::field::element::FieldElement;

#[derive(Debug, Clone)]
pub struct Polynomial {
    coefficients: Vec<PyFelt>,
    p: u64,
    field: BaseField,
}

impl Polynomial {
    pub fn new(coefficients: Vec<PyFelt>) -> Self {
        let p = coefficients[0].p;
        let field = BaseField::new(p);
        Self { coefficients, p, field }
    }

    pub fn degree(&self) -> usize {
        for i in (0..self.coefficients.len()).rev() {
            if self.coefficients[i].value != 0 {
                return i;
            }
        }
        0
    }

    pub fn evaluate(&self, point: PyFelt) -> PyFelt {
        let mut xi = self.field.one();
        let mut value = self.field.zero();
        for c in &self.coefficients {
            value = value + *c * xi;
            xi = xi * point;
        }
        value
    }

    pub fn leading_coefficient(&self) -> PyFelt {
        self.coefficients[self.degree()]
    }

    pub fn zero(p: u64) -> Self {
        Polynomial::new(vec![PyFelt::new(0, p)])
    }
    
    pub fn xgcd(&self, other: &Polynomial<F>) -> (Polynomial<F>, Polynomial<F>, Polynomial<F>) {
        let mut old_r = self.clone();
        let mut r = other.clone();
        let mut old_s = Polynomial::new(&[FieldElement::one()]);
        let mut s = Polynomial::zero();
        let mut old_t = Polynomial::zero();
        let mut t = Polynomial::new(&[FieldElement::one()]);

        while !r.is_zero() {
            let quotient = old_r.clone().div_with_ref(&r);

            let new_r = old_r.clone() - &quotient * &r;
            old_r = r;
            r = new_r;

            let new_s = old_s.clone() - &quotient * &s;
            old_s = s;
            s = new_s;

            let new_t = old_t.clone() - &quotient * &t;
            old_t = t;
            t = new_t;
        }

        (old_r, old_s, old_t)
    }
}

// Implement operations for Polynomial similar to Python code
impl std::ops::Add for Polynomial {
    type Output = Polynomial;

    fn add(self, other: Polynomial) -> Polynomial {
        let mut coeffs = self.coefficients.clone();
        let min_len = std::cmp::min(self.coefficients.len(), other.coefficients.len());

        for i in 0..min_len {
            coeffs[i] = coeffs[i] + other.coefficients[i];
        }

        Polynomial::new(coeffs)
    }
}

impl std::ops::Neg for Polynomial {
    type Output = Polynomial;

    fn neg(self) -> Polynomial {
        Polynomial::new(self.coefficients.into_iter().map(|c| -c).collect())
    }
}

impl std::ops::Sub for Polynomial {
    type Output = Polynomial;

    fn sub(self, other: Polynomial) -> Polynomial {
        self + (-other)
    }
}

impl std::ops::Mul<PyFelt> for Polynomial {
    type Output = Polynomial;

    fn mul(self, other: PyFelt) -> Polynomial {
        Polynomial::new(self.coefficients.into_iter().map(|c| c * other).collect())
    }
}



