use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::fields::fft_friendly::stark_252_prime_field::Stark252PrimeField;
use lambdaworks_math::polynomial::Polynomial;
use lambdaworks_math::traits::IsField;

pub type FunctionFelt = Polynomial<FieldElement<Stark252PrimeField>>;


pub fn interpolate(
    xs: &[FieldElement<Stark252PrimeField>],
    ys: &[FieldElement<Stark252PrimeField>],
) -> Result<Polynomial<FieldElement<Stark252PrimeField>>, String> {
    if xs.len() != ys.len() {
        return Err(format!(
            "xs and ys must be the same length. Got: {} != {}",
            xs.len(),
            ys.len()
        ));
    }
    if xs.is_empty() {
        return Ok(Polynomial::new(&[]));
    }

    let mut denominators = Vec::with_capacity(xs.len() * (xs.len() - 1) / 2);
    let mut indexes = Vec::with_capacity(xs.len());

    let mut idx = 0;

    for (i, xi) in xs.iter().enumerate().skip(1) {
        indexes.push(idx);
        for xj in xs.iter().take(i) {
            if xi == xj {
                return Err("xs values should be unique.".to_string());
            }
            denominators.push(xi - xj);
            idx += 1;
        }
    }

    FieldElement::inplace_batch_inverse(&mut denominators).unwrap();

    let mut result = Polynomial::zero();

    for (i, y) in ys.iter().enumerate() {
        let mut y_term = Polynomial::new(&[y.clone()]);
        for (j, x) in xs.iter().enumerate() {
            if i == j {
                continue;
            }
            let denominator = if i > j {
                denominators[indexes[i - 1] + j].clone()
            } else {
                -&denominators[indexes[j - 1] + i]
            };
            let denominator_poly = Polynomial::new(&[denominator]);
            let numerator = Polynomial::new(&[-x, FieldElement::one()]);
            y_term = y_term.mul_with_ref(&(numerator * denominator_poly));
        }
        result = result + y_term;
    }
    Ok(result)
}

impl std::ops::Add for FunctionFelt {
    type Output = Self;

    fn add(self, other: Self) -> Self::Output {
        &self + &other
    }
}

impl std::ops::Mul<FieldElement<Stark252PrimeField>> for FunctionFelt {
    type Output = Self;

    fn mul(self, other: FieldElement<Stark252PrimeField>) -> Self::Output {
        &self * &other
    }
}