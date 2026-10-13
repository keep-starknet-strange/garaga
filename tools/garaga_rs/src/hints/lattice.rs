//! Exact rank-four LLL reconstruction for GLV + fake-GLV hints.

use num_bigint::BigInt;
use num_integer::Integer;
use num_rational::BigRational;
use num_traits::{One, Signed, Zero};

type Row = [BigInt; 4];
type Mu = [[BigRational; 4]; 4];

fn round_nearest(value: &BigRational) -> BigInt {
    let (mut quotient, remainder) = value.numer().abs().div_rem(value.denom());
    if remainder * 2 >= *value.denom() {
        quotient += 1;
    }
    if value.is_negative() {
        -quotient
    } else {
        quotient
    }
}

fn gram_schmidt(basis: &[Row; 4]) -> (Mu, [BigRational; 4]) {
    let mut mu: Mu = std::array::from_fn(|_| std::array::from_fn(|_| BigRational::zero()));
    let mut orthogonal: Mu = std::array::from_fn(|_| std::array::from_fn(|_| BigRational::zero()));
    let mut norms = std::array::from_fn(|_| BigRational::zero());
    for i in 0..4 {
        let mut vector = basis[i].clone().map(BigRational::from_integer);
        for j in 0..i {
            mu[i][j] = basis[i]
                .iter()
                .zip(&orthogonal[j])
                .map(|(a, b)| b * a)
                .sum::<BigRational>()
                / &norms[j];
            for (a, b) in vector.iter_mut().zip(&orthogonal[j]) {
                *a -= &mu[i][j] * b;
            }
        }
        norms[i] = vector.iter().map(|a| a * a).sum();
        orthogonal[i] = vector;
    }
    (mu, norms)
}

/// Return short (u1,u2,v1,v2) with u1+λu2+s(v1+λv2)=0 modulo n.
/// The full-rank kernel basis has determinant n. LLL uses δ=99/100, as in gnark.
/// Cached Gram-Schmidt updates avoid repeated rational orthogonalization.
pub fn rational_reconstruct_extension(
    modulus: &BigInt,
    scalar: &BigInt,
    eigenvalue: &BigInt,
) -> Result<Row, String> {
    if modulus <= &BigInt::one() {
        return Err("The lattice modulus must be greater than one".into());
    }
    let scalar = scalar.mod_floor(modulus);
    let eigenvalue = eigenvalue.mod_floor(modulus);
    let zero = BigInt::zero();
    let one = BigInt::one();
    let mut basis = [
        [modulus.clone(), zero.clone(), zero.clone(), zero.clone()],
        [-&eigenvalue, one.clone(), zero.clone(), zero.clone()],
        [-&scalar, zero.clone(), one.clone(), zero.clone()],
        [
            -(&scalar * &eigenvalue).mod_floor(modulus),
            zero.clone(),
            zero,
            one,
        ],
    ];
    let bound = modulus.sqrt().sqrt();
    let usable = |row: &Row| {
        !(&row[2] + &eigenvalue * &row[3])
            .mod_floor(modulus)
            .is_zero()
    };
    let small = |row: &Row| usable(row) && row.iter().all(|coordinate| coordinate.abs() <= bound);
    for row in &basis {
        if small(row) {
            return Ok(row.clone());
        }
    }

    let (mut mu, mut norms) = gram_schmidt(&basis);
    let half = BigRational::new(1.into(), 2.into());
    let delta = BigRational::new(99.into(), 100.into());
    let mut k = 1;
    while k < 4 {
        for j in (0..k).rev() {
            if mu[k][j].abs() > half {
                let q = round_nearest(&mu[k][j]);
                let source = basis[j].clone();
                for (a, b) in basis[k].iter_mut().zip(source) {
                    *a -= &q * b;
                }
                for i in 0..j {
                    let adjustment = &mu[j][i] * &q;
                    mu[k][i] -= adjustment;
                }
                mu[k][j] -= BigRational::from_integer(q);
                if small(&basis[k]) {
                    return Ok(basis[k].clone());
                }
            }
        }

        let old_mu = mu[k][k - 1].clone();
        if norms[k] >= (&delta - &old_mu * &old_mu) * &norms[k - 1] {
            k += 1;
            continue;
        }

        basis.swap(k, k - 1);
        let combined_norm = &norms[k] + &old_mu * &old_mu * &norms[k - 1];
        let new_mu = &old_mu * &norms[k - 1] / &combined_norm;
        norms[k] = &norms[k] * &norms[k - 1] / &combined_norm;
        norms[k - 1] = combined_norm;
        for j in 0..k - 1 {
            let previous = mu[k][j].clone();
            mu[k][j] = mu[k - 1][j].clone();
            mu[k - 1][j] = previous;
        }
        mu[k][k - 1] = new_mu.clone();
        for row in mu.iter_mut().skip(k + 1) {
            let previous = row[k].clone();
            row[k] = &row[k - 1] - &old_mu * &previous;
            row[k - 1] = previous + &new_mu * &row[k];
        }
        for row in &basis[k - 1..=k] {
            if small(row) {
                return Ok(row.clone());
            }
        }
        k = std::cmp::max(k - 1, 1);
    }

    let result = basis
        .into_iter()
        .filter(usable)
        .min_by_key(|row| row.iter().map(Signed::abs).max().unwrap())
        .ok_or("LLL produced no vector with a nonzero effective denominator")?;
    let max_bits = modulus.bits().div_ceil(4) + 1;
    if result.iter().any(|coordinate| coordinate.bits() > max_bits) {
        return Err("The reconstructed GLV coefficients exceed the circuit bound".into());
    }
    Ok(result)
}

#[cfg(test)]
mod tests {
    use super::*;
    use num_traits::Num;

    #[test]
    fn rounding_ties_match_python() {
        for (numerator, expected) in [(1, 1), (-1, -1), (3, 2), (-3, -2)] {
            assert_eq!(
                round_nearest(&BigRational::new(numerator.into(), 2.into())),
                expected.into()
            );
        }
    }

    #[test]
    fn reconstruction_is_bounded_and_has_a_nonzero_denominator() {
        let curves = [
            (
                "30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001",
                "b3c4d79d41a917585bfc41088d8daaa78b17ea66b99c90dd",
            ),
            (
                "73eda753299d7d483339d80809a1d80553bda402fffe5bfeffffffff00000001",
                "ac45a4010001a40200000000ffffffff",
            ),
            (
                "fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141",
                "5363ad4cc05c30e0a5261c028812645a122e22ea20816678df02967c1b23bd72",
            ),
        ];
        for (order, eigenvalue) in curves {
            let order = BigInt::from_str_radix(order, 16).unwrap();
            let eigenvalue = BigInt::from_str_radix(eigenvalue, 16).unwrap();
            let mut scalars = vec![0.into(), 1.into(), 2.into(), &order - 1, &order - 2];
            let mut seed = BigInt::from(42);
            for _ in 0..32 {
                seed = (&seed * BigInt::from(6364136223846793005_u64) + BigInt::one())
                    .mod_floor(&order);
                scalars.push(seed.clone());
            }
            for scalar in scalars {
                let [u1, u2, v1, v2] =
                    rational_reconstruct_extension(&order, &scalar, &eigenvalue).unwrap();
                let denominator = &v1 + &eigenvalue * &v2;
                assert!(!denominator.mod_floor(&order).is_zero());
                assert!((&u1 + &eigenvalue * &u2 + &scalar * denominator)
                    .mod_floor(&order)
                    .is_zero());
                assert!([u1, u2, v1, v2].iter().all(|value| value.bits() <= 65));
            }
        }
    }
}
