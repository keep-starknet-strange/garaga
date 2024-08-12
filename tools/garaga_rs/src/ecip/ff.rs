use crate::ecip::polynomial::Polynomial;
use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::traits::IsPrimeField;
use std::ops::{Add, Mul, Neg};

#[derive(Debug, Clone)]
pub struct FF<F: IsPrimeField + PartialEq> {
    pub coeffs: Vec<Polynomial<F>>,
    pub y2: Polynomial<F>,
}

impl<F: IsPrimeField + PartialEq> FF<F> {
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
            coeff_neg[1] = -self.coeffs[1].clone();
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
                        deg_0_coeff = deg_0_coeff + poly.clone() * y2.clone();
                    } else {
                        deg_1_coeff = deg_1_coeff + poly.clone() * y2.clone();
                        y2 = y2.clone() * y2.clone();
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
        let inv_coeff = coeff.inv().expect("Coefficient must be invertible");

        FF {
            coeffs: self
                .coeffs
                .iter()
                .map(|c| c.clone() * inv_coeff.clone())
                .collect(),
            y2: self.y2.clone(),
        }
    }
}

impl<F: IsPrimeField + PartialEq> Add for FF<F> {
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

impl<F: IsPrimeField + PartialEq> Mul for FF<F> {
    type Output = Self;

    fn mul(self, other: Self) -> Self::Output {
        let max_degree = self.coeffs.len() + other.coeffs.len() - 1;
        let mut coeffs = vec![Polynomial::zero(); max_degree];

        for i in 0..self.coeffs.len() {
            for j in 0..other.coeffs.len() {
                coeffs[i + j] =
                    coeffs[i + j].clone() + (self.coeffs[i].clone() * other.coeffs[j].clone());
            }
        }

        FF::new(coeffs)
    }
}

impl<F: IsPrimeField + PartialEq> Neg for FF<F> {
    type Output = Self;

    fn neg(self) -> Self::Output {
        FF::new(self.coeffs.iter().map(|c| -c.clone()).collect())
    }
}
