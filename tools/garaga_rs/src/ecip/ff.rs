use crate::algebra::polynomial::Polynomial;
use crate::definitions::FieldElement;
use lambdaworks_math::field::traits::IsPrimeField;
use std::ops::{Add, Mul};

use crate::definitions::CurveParamsProvider;

#[derive(Debug, Clone)]
pub struct FF<F: IsPrimeField> {
    pub coeffs: Vec<Polynomial<F>>,
}

impl<F: IsPrimeField + CurveParamsProvider<F>> FF<F> {
    pub fn new(coeffs: Vec<Polynomial<F>>) -> Self {
        FF { coeffs }
    }

    pub fn degree(&self) -> usize {
        self.coeffs.len() - 1
    }

    pub fn neg_y(self) -> FF<F> {
        if self.coeffs.len() < 2 {
            self
        } else {
            let mut coeff_neg = self.coeffs.clone();
            for i in (1..coeff_neg.len()).step_by(2) {
                coeff_neg[i] = -&coeff_neg[i];
            }
            FF { coeffs: coeff_neg }
        }
    }

    pub fn reduce(&self) -> FF<F> {
        match self.coeffs.len() {
            0 => FF {
                coeffs: vec![Polynomial::zero(), Polynomial::zero()],
            },
            1 => FF {
                coeffs: vec![self.coeffs[0].clone(), Polynomial::zero()],
            },
            _ => {
                let mut deg_0_coeff = self.coeffs[0].clone();
                let mut deg_1_coeff = self.coeffs[1].clone();
                let curve_params = F::get_curve_params();
                let a = curve_params.a;
                let b = curve_params.b;

                let mut y2 = Polynomial::new(vec![b, a, FieldElement::zero(), FieldElement::one()]);

                for (i, poly) in self.coeffs.iter().enumerate().skip(2) {
                    if i % 2 == 0 {
                        deg_0_coeff = deg_0_coeff + poly * &y2;
                    } else {
                        deg_1_coeff = deg_1_coeff + poly * &y2;

                        y2 = &y2 * &y2;
                    }
                }

                FF {
                    coeffs: vec![deg_0_coeff, deg_1_coeff],
                }
            }
        }
    }

    pub fn normalize(&self) -> FF<F> {
        let coeff = self.coeffs[0].coefficients[0].clone();
        let inv_coeff: FieldElement<F> = coeff.inv().unwrap();

        FF {
            coeffs: self
                .coeffs
                .iter()
                .map(|c| c.scale_by_coeff(&inv_coeff))
                .collect(),
        }
    }

    pub fn to_poly(&self) -> Polynomial<F> {
        assert!(self.coeffs.len() == 1);
        self.coeffs[0].clone()
    }

    pub fn div_by_poly(&self, poly: &Polynomial<F>) -> FF<F> {
        let coeffs: Vec<Polynomial<F>> = self
            .coeffs
            .iter()
            .map(|c| c.clone().div_with_ref(poly))
            .collect();

        // println!("Final coefficients after division: {:?}", coeffs);

        FF { coeffs }
    }

    pub fn print_as_sage_poly(&self) -> String {
        let mut string = String::new();
        let coeffs = &self.coeffs;

        for (i, p) in coeffs.iter().rev().enumerate() {
            let coeff_str = p.print_as_sage_poly();

            if i == coeffs.len() - 1 {
                if coeff_str.is_empty() {
                    string.truncate(string.len().saturating_sub(2));
                } else {
                    string.push_str(&coeff_str);
                }
            } else if i == coeffs.len() - 2 {
                string.push_str(&format!("({})*y + ", coeff_str));
            } else {
                string.push_str(&format!("({})*y^{} + ", coeff_str, coeffs.len() - i - 1));
            }
        }

        string
    }
}

impl<F: IsPrimeField + CurveParamsProvider<F>> Add for FF<F> {
    type Output = Self;

    fn add(self, other: Self) -> Self::Output {
        let max_degree = self.coeffs.len().max(other.coeffs.len());
        let mut coeffs = vec![Polynomial::zero(); max_degree];

        for i in 0..self.coeffs.len() {
            coeffs[i] = &coeffs[i] + &self.coeffs[i];
        }

        for i in 0..other.coeffs.len() {
            coeffs[i] = &coeffs[i] + &other.coeffs[i];
        }

        FF::new(coeffs)
    }
}

impl<F: IsPrimeField + CurveParamsProvider<F>> Mul for FF<F> {
    type Output = Self;

    fn mul(self, other: Self) -> Self::Output {
        let max_degree = self.coeffs.len() + other.coeffs.len() - 1;
        let mut coeffs = vec![Polynomial::zero(); max_degree];

        if self.coeffs.is_empty() || other.coeffs.is_empty() {
            return FF::new(vec![Polynomial::zero()]);
        }

        for (i, self_poly) in self.coeffs.iter().enumerate() {
            for (j, other_poly) in other.coeffs.iter().enumerate() {
                let product = self_poly * other_poly;
                coeffs[i + j] = &coeffs[i + j] + &product;
            }
        }

        FF::new(coeffs)
    }
}

impl<F: IsPrimeField + CurveParamsProvider<F>> Mul for &FF<F> {
    type Output = FF<F>;

    fn mul(self, other: Self) -> Self::Output {
        let max_degree = self.coeffs.len() + other.coeffs.len() - 1;
        let mut coeffs = vec![Polynomial::zero(); max_degree];

        if self.coeffs.is_empty() || other.coeffs.is_empty() {
            return FF::new(vec![Polynomial::zero()]);
        }

        for (i, self_poly) in self.coeffs.iter().enumerate() {
            for (j, other_poly) in other.coeffs.iter().enumerate() {
                let product = self_poly * other_poly;
                coeffs[i + j] = &coeffs[i + j] + &product;
            }
        }

        FF::new(coeffs)
    }
}
