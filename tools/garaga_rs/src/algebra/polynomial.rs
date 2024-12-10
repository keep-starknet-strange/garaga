use crate::definitions::FieldElement;
use lambdaworks_math::field::traits::IsPrimeField;

#[derive(Debug, Clone)]
pub struct Polynomial<F: IsPrimeField> {
    pub coefficients: Vec<FieldElement<F>>,
}

impl<F: IsPrimeField> Polynomial<F> {
    pub fn get_coefficients_ext_degree(&self, ext_degree: usize) -> Vec<FieldElement<F>> {
        assert!(self.coefficients.len() <= ext_degree);
        let mut coefficients = self.coefficients.clone();
        coefficients.resize(ext_degree, FieldElement::zero());
        coefficients
    }

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

    pub fn print_as_sage_poly(&self) -> String {
        let var_name = 'x';
        if self.coefficients.is_empty()
            || self.coefficients.len() == 1 && self.coefficients[0] == FieldElement::zero()
        {
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

    pub fn degree(&self) -> isize {
        self.coefficients
            .iter()
            .rposition(|coeff| *coeff != FieldElement::<F>::zero())
            .map(|pos| pos as isize)
            .unwrap_or(-1)
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

    pub fn one() -> Self {
        Polynomial::new(vec![FieldElement::<F>::one()])
    }

    pub fn mul_with_ref(&self, other: &Polynomial<F>) -> Polynomial<F> {
        if self.degree() == -1 || other.degree() == -1 {
            return Polynomial::zero();
        }
        let mut result_coeffs =
            vec![FieldElement::<F>::zero(); self.coefficients.len() + other.coefficients.len() - 1];

        for (i, self_coeff) in self.coefficients.iter().enumerate() {
            for (j, other_coeff) in other.coefficients.iter().enumerate() {
                result_coeffs[i + j] += self_coeff * other_coeff;
            }
        }

        Polynomial::new(result_coeffs)
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
            let coefficient = &remainder.coefficients[rem_deg as usize] * &denom_lead_inv;
            quotient_coeffs[shift as usize] = coefficient.clone();
            let subtractee = denominator
                .scale_by_coeff(&coefficient)
                .shift(shift as usize);
            remainder = remainder - subtractee;
            rem_deg = remainder.degree();
        }

        let quotient = Polynomial::new(quotient_coeffs);
        (quotient, remainder)
    }

    pub fn shift(&self, shift: usize) -> Self {
        let mut shifted_coeffs = vec![FieldElement::<F>::zero(); shift];
        shifted_coeffs.extend(self.coefficients.clone());
        Self::new(shifted_coeffs)
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
            let degree = &FieldElement::<F>::from(u_64);
            new_coeffs[i - 1] = coeff * degree;
        }
        Polynomial::new(new_coeffs)
    }

    pub fn xgcd(&self, other: &Polynomial<F>) -> (Polynomial<F>, Polynomial<F>, Polynomial<F>) {
        // println!(
        //     "Computing xgcd of polynomials of degree {} and {}",
        //     self.degree(),
        //     other.degree()
        // );
        let mut old_r = self.clone();
        let mut r = other.clone();
        let mut old_s = Polynomial::new(vec![FieldElement::<F>::one()]);
        let mut s = Polynomial::zero();
        let mut old_t = Polynomial::zero();
        let mut t = Polynomial::new(vec![FieldElement::<F>::one()]);

        while r.degree() != -1 {
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
        Polynomial::new(self.coefficients.iter().map(|c| c * coeff).collect())
    }
}

pub fn pad_with_zero_coefficients_to_length<F: IsPrimeField>(pa: &mut Polynomial<F>, n: usize) {
    pa.coefficients.resize(n, FieldElement::zero());
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
        let new_coefficients = pa
            .coefficients
            .iter()
            .zip(pb.coefficients.iter())
            .map(|(x, y)| x + y)
            .collect();
        Polynomial::new(new_coefficients)
    }
}

impl<F: IsPrimeField> std::ops::Add for Polynomial<F> {
    type Output = Polynomial<F>;

    fn add(self, other: Polynomial<F>) -> Polynomial<F> {
        let (mut longer, shorter) = if self.coefficients.len() >= other.coefficients.len() {
            (self.coefficients, other.coefficients)
        } else {
            (other.coefficients, self.coefficients)
        };

        for (i, coeff) in shorter.into_iter().enumerate() {
            longer[i] += coeff;
        }

        Polynomial::new(longer)
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
