use garaga_rs::algebra::polynomial::{pad_with_zero_coefficients_to_length, Polynomial};
use garaga_rs::definitions::*;
use lambdaworks_math::field::traits::IsPrimeField;

fn coefficients<F: IsPrimeField>(degree: usize, seed: u64) -> Polynomial<F> {
    Polynomial::new(
        (0..=degree)
            .map(|i| {
                let value = FieldElement::<F>::from(seed + i as u64 * 7919 + 1);
                if i % 2 == 0 {
                    value
                } else {
                    -value
                }
            })
            .collect(),
    )
}
fn constructed_divisions<F: IsPrimeField>() {
    for den_degree in [0, 1, 2, 12, 32] {
        for monic in [false, true] {
            let mut denominator = coefficients::<F>(den_degree, 41);
            if monic {
                *denominator.coefficients.last_mut().unwrap() = FieldElement::one();
            }
            for quotient_degree in [0, 1, 2, 12] {
                let quotient = coefficients::<F>(quotient_degree, 104729);
                for remainder in [
                    Polynomial::zero(),
                    if den_degree == 0 {
                        Polynomial::zero()
                    } else {
                        coefficients::<F>(den_degree - 1, 37)
                    },
                ] {
                    let mut numerator = &denominator * &quotient + remainder.clone();
                    let length = numerator.coefficients.len() + 3;
                    pad_with_zero_coefficients_to_length(&mut numerator, length);
                    let unchanged_denominator = denominator.coefficients.clone();
                    let (actual_quotient, actual_remainder) = numerator.divmod(&denominator);
                    assert_eq!(actual_quotient.coefficients, quotient.coefficients);
                    assert_eq!(actual_remainder.coefficients, remainder.coefficients);
                    assert_eq!(actual_quotient.degree(), quotient.degree());
                    assert_eq!(actual_remainder.degree(), remainder.degree());
                    assert_eq!(denominator.coefficients, unchanged_denominator);
                }
            }
        }
    }
    let numerator = coefficients::<F>(1, 31);
    let denominator = coefficients::<F>(2, 17);
    let (quotient, remainder) = numerator.clone().divmod(&denominator);
    assert_eq!(quotient.coefficients, Polynomial::<F>::zero().coefficients);
    assert_eq!(remainder.coefficients, numerator.coefficients);
    let (quotient, remainder) = Polynomial::<F>::zero().divmod(&denominator);
    assert_eq!(quotient.coefficients, Polynomial::<F>::zero().coefficients);
    assert_eq!(remainder.coefficients, Polynomial::<F>::zero().coefficients);
}
fn bezout<F: IsPrimeField>() {
    let common = coefficients::<F>(2, 41);
    let x = &common * coefficients::<F>(3, 7919);
    let y = &common * coefficients::<F>(4, 104729);
    let (a, b, gcd) = x.xgcd(&y);
    assert_eq!((&a * &x + &b * &y).coefficients, gcd.coefficients);
    assert_eq!(gcd.leading_coefficient(), FieldElement::<F>::one());
    assert_eq!(x.divmod(&gcd).1.degree(), -1);
    assert_eq!(y.divmod(&gcd).1.degree(), -1);
}
#[test]
fn bn254() {
    constructed_divisions::<BN254PrimeField>();
    bezout::<BN254PrimeField>();
}
#[test]
fn bls12381() {
    constructed_divisions::<BLS12381PrimeField>();
    bezout::<BLS12381PrimeField>();
}
#[test]
fn secp256k1() {
    constructed_divisions::<SECP256K1PrimeField>();
    bezout::<SECP256K1PrimeField>();
}
#[test]
fn secp256r1() {
    constructed_divisions::<SECP256R1PrimeField>();
    bezout::<SECP256R1PrimeField>();
}
#[test]
fn x25519() {
    constructed_divisions::<X25519PrimeField>();
    bezout::<X25519PrimeField>();
}
#[test]
fn grumpkin() {
    constructed_divisions::<GrumpkinPrimeField>();
    bezout::<GrumpkinPrimeField>();
}
#[test]
#[should_panic(expected = "Division by zero polynomial")]
fn zero_denominator() {
    Polynomial::<BN254PrimeField>::one().divmod(&Polynomial::zero());
}
