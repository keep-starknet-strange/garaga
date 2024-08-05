use lambdaworks_math::field::{element::FieldElement, traits::IsPrimeField};
use crate::ecip::curve::BaseField;

#[derive(Debug, Clone)]
pub struct Polynomial<F: IsPrimeField> {
    coefficients: Vec<FieldElement<F>>,
    p: u64,
    field: BaseField<F>,
}

impl<F: IsPrimeField> Polynomial<F> {
    pub fn new(coefficients: Vec<FieldElement<F>>) -> Self {
        let p = coefficients[0].modulus();
        let field = BaseField::new(p);
        Self { coefficients, p, field }
    }

    pub fn degree(&self) -> usize {
        for i in (0..self.coefficients.len()).rev() {
            if !self.coefficients[i].is_zero() {
                return i;
            }
        }
        0
    }

    pub fn evaluate(&self, point: FieldElement<F>) -> FieldElement<F> {
        let mut xi = self.field.one();
        let mut value = self.field.zero();
        for c in &self.coefficients {
            value = value + *c * xi;
            xi = xi * point;
        }
        value
    }

    pub fn leading_coefficient(&self) -> FieldElement<F> {
        self.coefficients[self.degree()].clone()
    }

    pub fn zero(p: u64) -> Self {
        Polynomial::new(vec![FieldElement::<F>::zero()])
    }

    pub fn long_division_with_remainder(self, dividend: &Self) -> (Self, Self) {
        if dividend.degree() > self.degree() {
            (Polynomial::zero(self.p), self)
        } else {
            let mut n = self;
            let mut q: Vec<FieldElement<F>> = vec![FieldElement::zero(); n.degree() + 1];
            let denominator = dividend.leading_coefficient().inv().unwrap();
            while !n.is_zero() && n.degree() >= dividend.degree() {
                let new_coefficient = n.leading_coefficient() * &denominator;
                q[n.degree() - dividend.degree()] = new_coefficient.clone();
                let d = dividend.mul_with_ref(&Polynomial::new_monomial(
                    new_coefficient,
                    n.degree() - dividend.degree(),
                ));
                n = n - d;
            }
            (Polynomial::new(q), n)
        }
    }

    pub fn xgcd(&self, other: &Polynomial<F>) -> (Polynomial<F>, Polynomial<F>, Polynomial<F>) {
        let mut old_r = self.clone();
        let mut r = other.clone();
        let mut old_s = Polynomial::new(vec![self.field.one()]);
        let mut s = Polynomial::zero(self.p);
        let mut old_t = Polynomial::zero(self.p);
        let mut t = Polynomial::new(vec![self.field.one()]);

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

impl<F: IsPrimeField> std::ops::Add for Polynomial<F> {
    type Output = Polynomial<F>;

    fn add(self, other: Polynomial<F>) -> Polynomial<F> {
        let mut coeffs = self.coefficients.clone();
        let min_len = std::cmp::min(self.coefficients.len(), other.coefficients.len());

        for i in 0..min_len {
            coeffs[i] = coeffs[i] + other.coefficients[i].clone();
        }

        Polynomial::new(coeffs)
    }
}

impl<F: IsPrimeField> std::ops::Neg for Polynomial<F> {
    type Output = Polynomial<F>;

    fn neg(self) -> Polynomial<F> {
        Polynomial::new(self.coefficients.into_iter().map(|c| -c).collect())
    }
}

impl<F: IsPrimeField> std::ops::Sub for Polynomial<F> {
    type Output = Polynomial<F>;

    fn sub(self, other: Polynomial<F>) -> Polynomial<F> {
        self + (-other)
    }
}

impl<F: IsPrimeField> std::ops::Mul<FieldElement<F>> for Polynomial<F> {
    type Output = Polynomial<F>;

    fn mul(self, other: FieldElement<F>) -> Polynomial<F> {
        Polynomial::new(self.coefficients.into_iter().map(|c| c * other.clone()).collect())
    }
}
