use crate::definitions::FieldElement;
use lambdaworks_math::field::traits::IsPrimeField;

#[derive(Debug, Clone)]
pub struct Polynomial<F: IsPrimeField> {
    pub coefficients: Vec<FieldElement<F>>,
    // Cache the degree to avoid recomputing it
    degree: isize,
}

impl<F: IsPrimeField> Polynomial<F> {
    pub fn get_coefficients_ext_degree(&self, ext_degree: usize) -> Vec<FieldElement<F>> {
        assert!(self.coefficients.len() <= ext_degree);
        let mut coefficients = self.coefficients.clone();
        coefficients.resize(ext_degree, FieldElement::zero());
        coefficients
    }

    pub fn new(mut coefficients: Vec<FieldElement<F>>) -> Self {
        // Find the position of the last non-zero coefficient
        let last_non_zero = coefficients
            .iter()
            .rposition(|x| *x != FieldElement::zero());

        // Truncate the vector to remove trailing zeros
        let degree = if let Some(pos) = last_non_zero {
            coefficients.truncate(pos + 1);
            pos as isize
        } else {
            // All coefficients are zero, return a zero polynomial
            coefficients = vec![FieldElement::zero()];
            -1
        };

        Self {
            coefficients,
            degree,
        }
    }

    pub fn print_as_sage_poly(&self) -> String {
        let var_name = 'x';
        if self.degree == -1 {
            return String::new();
        }

        let mut string = String::new();
        let zero = FieldElement::<F>::zero();

        for (i, coeff) in self.coefficients.iter().rev().enumerate() {
            if *coeff == zero {
                continue;
            }

            let coeff_str = coeff.representative().to_string();

            if i == self.coefficients.len() - 1 {
                string.push_str(&coeff_str);
            } else if i == self.coefficients.len() - 2 {
                string.push_str(&format!("{}*{} + ", coeff_str, var_name));
            } else {
                string.push_str(&format!(
                    "{}*{}^{} + ",
                    coeff_str,
                    var_name,
                    self.coefficients.len() - 1 - i
                ));
            }
        }

        string
    }

    #[inline]
    pub fn degree(&self) -> isize {
        // Use cached degree value
        self.degree
    }

    pub fn evaluate(&self, x: &FieldElement<F>) -> FieldElement<F> {
        // Use Horner's method for polynomial evaluation
        if self.degree == -1 {
            return FieldElement::zero();
        }

        let mut result = self.coefficients[self.degree as usize].clone();
        for i in (0..self.degree as usize).rev() {
            result = &result * x + &self.coefficients[i];
        }
        result
    }

    pub fn leading_coefficient(&self) -> FieldElement<F> {
        if self.degree == -1 {
            return FieldElement::zero();
        }
        self.coefficients[self.degree as usize].clone()
    }

    pub fn zero() -> Self {
        Self {
            coefficients: vec![FieldElement::<F>::zero()],
            degree: -1,
        }
    }

    pub fn one() -> Self {
        Self {
            coefficients: vec![FieldElement::<F>::one()],
            degree: 0,
        }
    }

    pub fn mul_with_ref(&self, other: &Polynomial<F>) -> Polynomial<F> {
        if self.degree == -1 || other.degree == -1 {
            return Polynomial::zero();
        }

        let result_len = (self.degree + other.degree + 1) as usize;
        let mut result_coeffs = vec![FieldElement::<F>::zero(); result_len];

        for (i, self_coeff) in self.coefficients.iter().enumerate() {
            for (j, other_coeff) in other.coefficients.iter().enumerate() {
                result_coeffs[i + j] += self_coeff * other_coeff;
            }
        }

        // We already know the degree, so construct directly
        let degree = self.degree + other.degree;
        Polynomial {
            coefficients: result_coeffs,
            degree,
        }
    }
    pub fn divmod(self, denominator: &Self) -> (Self, Self) {
        let den_deg = denominator.degree;
        if den_deg == -1 {
            panic!("Division by zero polynomial");
        }
        let num_deg = self.degree;
        let mut remainder = self.clone();
        if num_deg < den_deg {
            return (Polynomial::zero(), self);
        }

        let mut quotient_coeffs = vec![FieldElement::<F>::zero(); (num_deg - den_deg + 1) as usize];
        let denom_lead_inv = denominator.leading_coefficient().inv().unwrap();

        let mut rem_deg = num_deg;
        while rem_deg >= den_deg {
            let shift = rem_deg - den_deg;
            let coefficient = &remainder.coefficients[rem_deg as usize] * &denom_lead_inv;
            quotient_coeffs[shift as usize] = coefficient.clone();
            let subtractee = denominator
                .scale_by_coeff(&coefficient)
                .shift(shift as usize);
            remainder = remainder - subtractee;
            rem_deg = remainder.degree;
        }

        let degree = num_deg - den_deg;
        let quotient = Polynomial {
            coefficients: quotient_coeffs,
            degree,
        };
        (quotient, remainder)
    }

    pub fn shift(&self, shift: usize) -> Self {
        if self.degree == -1 {
            return Polynomial::zero();
        }

        let mut shifted_coeffs = vec![FieldElement::<F>::zero(); shift];
        shifted_coeffs.extend(self.coefficients.clone());

        Self {
            coefficients: shifted_coeffs,
            degree: self.degree + shift as isize,
        }
    }

    pub fn divfloor(&self, denominator: &Self) -> Self {
        let (quotient, _remainder) = self.clone().divmod(denominator);
        quotient
    }

    pub fn differentiate(&self) -> Self {
        if self.degree <= 0 {
            return Polynomial::zero();
        }

        let new_deg = self.degree - 1;
        let mut new_coeffs = vec![FieldElement::<F>::zero(); new_deg as usize + 1];

        for i in 1..=self.degree as usize {
            let u_64 = i as u64;
            let degree = &FieldElement::<F>::from(u_64);
            new_coeffs[i - 1] = &self.coefficients[i] * degree;
        }

        Polynomial {
            coefficients: new_coeffs,
            degree: new_deg,
        }
    }

    pub fn xgcd(&self, other: &Polynomial<F>) -> (Polynomial<F>, Polynomial<F>, Polynomial<F>) {
        let mut old_r = self.clone();
        let mut r = other.clone();
        let mut old_s = Polynomial::one();
        let mut s = Polynomial::zero();
        let mut old_t = Polynomial::zero();
        let mut t = Polynomial::one();

        while r.degree != -1 {
            let quotient = old_r.clone().div_with_ref(&r);

            let new_r = old_r - quotient.clone().mul_with_ref(&r);
            old_r = r;
            r = new_r;

            let new_s = old_s - quotient.clone().mul_with_ref(&s);
            old_s = s;
            s = new_s;

            let new_t = old_t - quotient.clone().mul_with_ref(&t);
            old_t = t;
            t = new_t;
        }

        let lcinv = old_r.leading_coefficient().inv().unwrap();
        (
            old_s.scale_by_coeff(&lcinv),
            old_t.scale_by_coeff(&lcinv),
            old_r.scale_by_coeff(&lcinv),
        )
    }

    pub fn div_with_ref(self, dividend: &Self) -> Self {
        let (quotient, _remainder) = self.divmod(dividend);
        quotient
    }

    pub fn scale_by_coeff(&self, coeff: &FieldElement<F>) -> Polynomial<F> {
        if *coeff == FieldElement::zero() {
            return Polynomial::zero();
        }

        if self.degree == -1 {
            return Polynomial::zero();
        }

        let scaled_coeffs = self.coefficients.iter().map(|c| c * coeff).collect();

        // Degree remains the same when scaling by non-zero coefficient
        Polynomial {
            coefficients: scaled_coeffs,
            degree: self.degree,
        }
    }
}

pub fn pad_with_zero_coefficients_to_length<F: IsPrimeField>(pa: &mut Polynomial<F>, n: usize) {
    if pa.coefficients.len() < n {
        pa.coefficients.resize(n, FieldElement::zero());
        // Degree doesn't change when adding trailing zeros
    }
}
pub fn pad_with_zero_coefficients<F: IsPrimeField>(
    pa: &Polynomial<F>,
    pb: &Polynomial<F>,
) -> (Polynomial<F>, Polynomial<F>) {
    let mut pa = pa.clone();
    let mut pb = pb.clone();

    if pa.coefficients.len() > pb.coefficients.len() {
        pad_with_zero_coefficients_to_length(&mut pb, pa.coefficients.len());
    } else {
        pad_with_zero_coefficients_to_length(&mut pa, pb.coefficients.len());
    }
    (pa, pb)
}

impl<F: IsPrimeField> std::ops::Add<&Polynomial<F>> for &Polynomial<F> {
    type Output = Polynomial<F>;

    fn add(self, a_polynomial: &Polynomial<F>) -> Self::Output {
        let (pa, pb) = pad_with_zero_coefficients(self, a_polynomial);

        // Calculate new coefficients
        let mut new_coefficients = Vec::with_capacity(pa.coefficients.len());
        for (x, y) in pa.coefficients.iter().zip(pb.coefficients.iter()) {
            new_coefficients.push(x + y);
        }

        // Find max degree - this is a potential optimization spot if we find this is slow
        let degree = if self.degree > a_polynomial.degree {
            self.degree
        } else if self.degree < a_polynomial.degree {
            a_polynomial.degree
        } else {
            // If degrees are equal, we need to check if leading terms cancel out
            let mut max_deg = self.degree;
            // Find the actual degree by scanning backward for first non-zero term
            while max_deg >= 0 && new_coefficients[max_deg as usize] == FieldElement::<F>::zero() {
                max_deg -= 1;
            }
            max_deg
        };

        // If degree is -1, ensure we have a single zero
        if degree == -1 {
            Polynomial::zero()
        } else {
            // Trim the vector to actual degree + 1
            new_coefficients.truncate(degree as usize + 1);
            Polynomial {
                coefficients: new_coefficients,
                degree,
            }
        }
    }
}

impl<F: IsPrimeField> std::ops::Add for Polynomial<F> {
    type Output = Polynomial<F>;

    fn add(self, other: Polynomial<F>) -> Polynomial<F> {
        // Fast path for zeros
        if self.degree == -1 {
            return other;
        }
        if other.degree == -1 {
            return self;
        }

        let (mut longer, shorter, longer_deg) = if self.degree >= other.degree {
            (self.coefficients, other.coefficients, self.degree)
        } else {
            (other.coefficients, self.coefficients, other.degree)
        };

        // Add shorter polynomial terms to longer one
        for (i, coeff) in shorter.into_iter().enumerate() {
            longer[i] += coeff;
        }

        // Check if the degree has changed due to cancellations
        let mut actual_deg = longer_deg;
        while actual_deg >= 0 && longer[actual_deg as usize] == FieldElement::<F>::zero() {
            actual_deg -= 1;
        }

        if actual_deg == -1 {
            Polynomial::zero()
        } else {
            longer.truncate(actual_deg as usize + 1);

            Polynomial {
                coefficients: longer,
                degree: actual_deg,
            }
        }
    }
}

impl<F: IsPrimeField> std::ops::Neg for &Polynomial<F> {
    type Output = Polynomial<F>;

    fn neg(self) -> Polynomial<F> {
        if self.degree == -1 {
            return Polynomial::zero();
        }

        Polynomial {
            coefficients: self.coefficients.iter().map(|c| -c).collect(),
            degree: self.degree,
        }
    }
}

impl<F: IsPrimeField> std::ops::Neg for Polynomial<F> {
    type Output = Polynomial<F>;

    fn neg(self) -> Polynomial<F> {
        -&self
    }
}

impl<F: IsPrimeField> std::ops::Sub for Polynomial<F> {
    type Output = Polynomial<F>;

    fn sub(self, other: Polynomial<F>) -> Polynomial<F> {
        // Fast path for zeros
        if self.degree == -1 {
            return -other;
        }
        if other.degree == -1 {
            return self;
        }

        self + (-other)
    }
}

impl<F: IsPrimeField> PartialEq for Polynomial<F> {
    fn eq(&self, other: &Self) -> bool {
        // Quick check based on degree
        if self.degree != other.degree {
            return false;
        }

        // If both are zero polynomials
        if self.degree == -1 {
            return true;
        }

        // Compare coefficients
        for i in 0..=self.degree as usize {
            if self.coefficients[i] != other.coefficients[i] {
                return false;
            }
        }

        true
    }
}

impl<F: IsPrimeField> std::ops::Mul<&Polynomial<F>> for &Polynomial<F> {
    type Output = Polynomial<F>;
    fn mul(self, factor: &Polynomial<F>) -> Polynomial<F> {
        self.mul_with_ref(factor)
    }
}

impl<F: IsPrimeField> std::ops::Mul<Polynomial<F>> for Polynomial<F> {
    type Output = Polynomial<F>;
    fn mul(self, factor: Polynomial<F>) -> Polynomial<F> {
        &self * &factor
    }
}

impl<F: IsPrimeField> std::ops::Mul<Polynomial<F>> for &Polynomial<F> {
    type Output = Polynomial<F>;
    fn mul(self, factor: Polynomial<F>) -> Polynomial<F> {
        self * &factor
    }
}

impl<F: IsPrimeField> std::ops::Mul<&Polynomial<F>> for Polynomial<F> {
    type Output = Polynomial<F>;
    fn mul(self, factor: &Polynomial<F>) -> Polynomial<F> {
        &self * factor
    }
}
