use lambdaworks_math::field::{element::FieldElement, traits::IsPrimeField};


#[derive(Debug, Clone)]
pub struct Polynomial<F: IsPrimeField> {
    pub coefficients: Vec<FieldElement<F>>,
}

impl<F: IsPrimeField> Polynomial<F> {
    pub fn new(coefficients: Vec<FieldElement<F>>) -> Self {
        // Removes trailing zero coefficients at the end
        let mut unpadded_coefficients = coefficients
            .iter()
            .rev()
            .skip_while(|x| **x == FieldElement::zero())
            .cloned()
            .collect::<Vec<FieldElement<F>>>();
        unpadded_coefficients.reverse();

        Self {
            coefficients: unpadded_coefficients,
        }
    }

    pub fn degree(&self) -> isize {
        for (i, coeff) in self.coefficients.iter().rev().enumerate() {
            if *coeff != FieldElement::<F>::zero() {
                return (self.coefficients.len() - 1 - i) as isize;
            }
        }
        -1
    }

    pub fn evaluate(&self, x: &FieldElement<F>) -> FieldElement<F> {
        self.coefficients
            .iter()
            .rev()
            .fold(FieldElement::zero(), |acc, coeff| coeff + acc * x)
    }

    pub fn leading_coefficient(&self) -> FieldElement<F> {
        let index: usize = self.degree().try_into().unwrap();
        self.coefficients[index].clone()
    }

    pub fn zero() -> Self {
        Polynomial::new(vec![FieldElement::<F>::zero()])
    }

    pub fn divmod(self, denominator: &Self) -> (Self, Self) {
        let den_deg = denominator.degree();
        if den_deg == -1 {
            panic!("Division by zero polynomial");
        }
        let num_deg = self.degree();
        let mut remainder = self.clone();
        if num_deg < den_deg {
            return (Polynomial::zero(), self);
        }

        let mut quotient_coeffs = vec![FieldElement::<F>::zero(); (num_deg - den_deg + 1) as usize];
        let denom_lead_inv = denominator.leading_coefficient().inv().unwrap();

        let mut rem_deg = num_deg;
        while rem_deg >= den_deg {
            let shift = rem_deg - den_deg;
            let coefficient = self.coefficients[rem_deg as usize].clone() * denom_lead_inv.clone();
            quotient_coeffs[shift as usize] = coefficient.clone();

            let mut subtractee_coeffs = vec![FieldElement::<F>::zero(); (shift) as usize];
            subtractee_coeffs.push(coefficient);
            let subtractee = Polynomial::new(subtractee_coeffs) * denominator.clone();
            remainder = remainder - subtractee;
            rem_deg = remainder.degree();
        }

        let quotient = Polynomial::new(quotient_coeffs);
        (quotient, remainder)
    }

    pub fn divfloor(&self, denominator: &Self) -> Self {
        let (quotient, _remainder) = self.clone().divmod(denominator);
        quotient
    }

    pub fn differentiate(&self) -> Self {
        if self.coefficients.len() <= 1 {
            return Polynomial::zero();
        }

        let mut new_coeffs = vec![FieldElement::<F>::zero(); self.coefficients.len() - 1];

        for (i, coeff) in self.coefficients.iter().enumerate().skip(1) {
            let u_64 = i as u64;
            let degree = FieldElement::<F>::from(u_64);
            new_coeffs[i - 1] = coeff.clone() * degree;
        }
        Polynomial::new(new_coeffs)
    }

    pub fn xgcd(&self, other: &Polynomial<F>) -> (Polynomial<F>, Polynomial<F>, Polynomial<F>) {
        let mut old_r = self.clone();
        let mut r = other.clone();
        let mut old_s = Polynomial::new(vec![FieldElement::<F>::one()]);
        let mut s = Polynomial::zero();
        let mut old_t = Polynomial::zero();
        let mut t = Polynomial::new(vec![FieldElement::<F>::one()]);

        while r != Polynomial::zero() {
            let quotient = old_r.clone().div_with_ref(&r);

            let new_r = old_r.clone() - quotient.clone() * r.clone();
            old_r = r;
            r = new_r;

            let new_s = old_s.clone() - quotient.clone() * s.clone();
            old_s = s;
            s = new_s;

            let new_t = old_t.clone() - quotient.clone() * t.clone();
            old_t = t;
            t = new_t;
        }

        (old_r, old_s, old_t)
    }

    pub fn div_with_ref(self, dividend: &Self) -> Self {
        let (quotient, _remainder) = self.divmod(dividend);
        quotient
    }

    pub fn scale_by_coeff(&self, coeff: FieldElement<F>) -> Polynomial<F> {
        Polynomial::new(
            self.coefficients
                .iter()
                .map(|c| c.clone() * coeff.clone())
                .collect(),
        )
    }
}

impl<F: IsPrimeField> std::ops::Add for Polynomial<F> {
    type Output = Polynomial<F>;

    fn add(self, other: Polynomial<F>) -> Polynomial<F> {
        let (ns, no) = (self.coefficients.len(), other.coefficients.len());
        if ns >= no {
            let mut coeffs = self.coefficients.clone();
            for i in 0..no {
                coeffs[i] += other.coefficients[i].clone();
            }
            Polynomial::new(coeffs)
        } else {
            let mut coeffs = other.coefficients.clone();
            for i in 0..no {
                coeffs[i] += other.coefficients[i].clone();
            }
            Polynomial::new(coeffs)
        }
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

impl<F: IsPrimeField> std::ops::Mul for Polynomial<F> {
    type Output = Polynomial<F>;

    fn mul(self, other: Polynomial<F>) -> Polynomial<F> {
        let mut result_coeffs =
            vec![FieldElement::<F>::zero(); self.coefficients.len() + other.coefficients.len() - 1];

        for (i, self_coeff) in self.coefficients.iter().enumerate() {
            for (j, other_coeff) in other.coefficients.iter().enumerate() {
                result_coeffs[i + j] =
                    result_coeffs[i + j].clone() + self_coeff.clone() * other_coeff.clone();
            }
        }

        Polynomial::new(result_coeffs)
    }
}

impl<F: IsPrimeField> PartialEq for Polynomial<F> {
    fn eq(&self, other: &Self) -> bool {
        if self.coefficients.len() != other.coefficients.len() {
            return false;
        }

        for (a, b) in self.coefficients.iter().zip(other.coefficients.iter()) {
            if a != b {
                return false;
            }
        }

        true
    }

    fn ne(&self, other: &Self) -> bool {
        !self.eq(other)
    }
}
