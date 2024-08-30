use crate::algebra::polynomial::Polynomial;
use crate::definitions::FieldElement;
use lambdaworks_math::field::traits::IsPrimeField;
use std::ops::{Add, Mul};

use crate::definitions::CurveParamsProvider;

#[derive(Debug, Clone)]
pub struct FF<F: IsPrimeField> {
    pub coeffs: Vec<Polynomial<F>>,
    pub y2: Polynomial<F>,
}

impl<F: IsPrimeField + CurveParamsProvider<F>> FF<F> {
    pub fn new(coeffs: Vec<Polynomial<F>>) -> Self {
        let curve_params = F::get_curve_params();
        let a = curve_params.a;
        let b = curve_params.b;

        let y2 = Polynomial::new(vec![b, a, FieldElement::zero(), FieldElement::one()]);

        FF { coeffs, y2 }
    }

    pub fn degree(&self) -> usize {
        self.coeffs.len() - 1
    }

    pub fn get(&self, i: usize) -> Polynomial<F> {
        self.coeffs.get(i).cloned().unwrap_or_else(Polynomial::zero)
    }

    pub fn neg_y(self) -> FF<F> {
        if self.coeffs.len() < 2 {
            self
        } else {
            let mut coeff_neg = self.coeffs.clone();
            for i in (1..coeff_neg.len()).step_by(2) {
                coeff_neg[i] = -coeff_neg[i].clone();
            }
            FF {
                coeffs: coeff_neg,
                y2: self.y2.clone(),
            }
        }
    }

    pub fn reduce(&self) -> FF<F> {
        match self.coeffs.len() {
            0 => FF {
                coeffs: vec![Polynomial::zero(), Polynomial::zero()],
                y2: self.y2.clone(),
            },
            1 => FF {
                coeffs: vec![self.coeffs[0].clone(), Polynomial::zero()],
                y2: self.y2.clone(),
            },
            _ => {
                let mut deg_0_coeff = self.coeffs[0].clone();
                let mut deg_1_coeff = self.coeffs[1].clone();
                let mut y2 = self.y2.clone();

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
                    y2: self.y2.clone(),
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
            y2: self.y2.clone(),
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

        FF {
            coeffs,
            y2: self.y2.clone(),
        }
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
            coeffs[i] = coeffs[i].clone() + self.coeffs[i].clone();
        }

        for i in 0..other.coeffs.len() {
            coeffs[i] = coeffs[i].clone() + other.coeffs[i].clone();
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
                coeffs[i + j] = coeffs[i + j].clone() + product;
            }
        }

        FF::new(coeffs)
    }
}
