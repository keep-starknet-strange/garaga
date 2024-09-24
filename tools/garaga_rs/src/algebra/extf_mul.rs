use crate::algebra::polynomial::{pad_with_zero_coefficients_to_length, Polynomial};
use crate::definitions::{CurveID, get_irreducible_poly, CurveParamsProvider};
use crate::io::{element_to_biguint, element_from_biguint};
use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::traits::IsPrimeField;
use lambdaworks_math::traits::ByteConversion;
use num_bigint::BigUint;

// Returns (Q(X), R(X)) such that Π(Pi)(X) = Q(X) * P_irr(X) + R(X), for a given curve and extension degree.
// R(X) is the result of the multiplication in the extension field.
// Q(X) is used for verification.
pub fn nondeterministic_extension_field_mul_divmod<F: IsPrimeField + CurveParamsProvider<F>>(
    ext_degree: usize,
    ps: Vec<Polynomial<F>>,
) -> (Polynomial<F>, Polynomial<F>) {
    let mut z_poly = Polynomial::one();
    for poly in ps {
        z_poly = z_poly.mul_with_ref(&poly);
    }

    let p_irr = get_irreducible_poly(ext_degree);

    let (z_polyq, mut z_polyr) = z_poly.divmod(&p_irr);
    assert!(z_polyr.coefficients.len() <= ext_degree);

    // Extend polynomial with 0 coefficients to match the expected length.
    if z_polyr.coefficients.len() < ext_degree {
        pad_with_zero_coefficients_to_length(&mut z_polyr, ext_degree);
    }

    (z_polyq, z_polyr)
}

pub fn nondeterministic_extension_field_div<F>(x: Polynomial<F>, y: Polynomial<F>, ext_degree: usize) -> Polynomial<F>
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let mut x = x;
    let mut y = y;
    pad_with_zero_coefficients_to_length(&mut x, ext_degree);
    pad_with_zero_coefficients_to_length(&mut y, ext_degree);
    let a = direct_to_tower(&x.coefficients, ext_degree);
    let b = direct_to_tower(&x.coefficients, ext_degree);
    let div = tower_div(&a, &b, ext_degree);
    return Polynomial::new(tower_to_direct(&div, ext_degree));
}

pub fn tower_mul<F>(a: &[FieldElement<F>], b: &[FieldElement<F>], ext_degree: usize) -> Vec<FieldElement<F>>
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    assert_eq!(a.len(), ext_degree);
    assert_eq!(b.len(), ext_degree);
    let curve_id = F::get_curve_params().curve_id;
    let a: Vec<BigUint> = a.iter().map(element_to_biguint).collect();
    let b: Vec<BigUint> = b.iter().map(element_to_biguint).collect();
    if ext_degree == 2 {
        let [a0, a1] = a.try_into().unwrap();
        let [b0, b1] = b.try_into().unwrap();
        let [c0, c1] = match curve_id {
            CurveID::BN254 => {
                use ark_ff::PrimeField;
                use ark_bn254::{Fq, Fq2};
                let a = Fq2::new(Fq::from(a0), Fq::from(a1));
                let b = Fq2::new(Fq::from(b0), Fq::from(b1));
                let c = a * b;
                [BigUint::from(c.c0.into_bigint()), BigUint::from(c.c1.into_bigint())]
            },
            CurveID::BLS12_381 => {
                use ark_ff::PrimeField;
                use ark_bls12_381::{Fq, Fq2};
                let a = Fq2::new(Fq::from(a0), Fq::from(a1));
                let b = Fq2::new(Fq::from(b0), Fq::from(b1));
                let c = a * b;
                [BigUint::from(c.c0.into_bigint()), BigUint::from(c.c1.into_bigint())]
            },
            _ => unimplemented!("Unsupported curve")
        };
        return vec![element_from_biguint(&c0), element_from_biguint(&c1)];
    }
    if ext_degree == 6 {
        let [a0, a1, a2, a3, a4, a5] = a.try_into().unwrap();
        let [b0, b1, b2, b3, b4, b5] = b.try_into().unwrap();
        let [c0, c1, c2, c3, c4, c5] = match curve_id {
            CurveID::BN254 => {
                use ark_ff::PrimeField;
                use ark_bn254::{Fq, Fq2, Fq6};
                let a = Fq6::new(
                    Fq2::new(Fq::from(a0), Fq::from(a1)),
                    Fq2::new(Fq::from(a2), Fq::from(a3)),
                    Fq2::new(Fq::from(a4), Fq::from(a5)),
                );
                let b = Fq6::new(
                    Fq2::new(Fq::from(b0), Fq::from(b1)),
                    Fq2::new(Fq::from(b2), Fq::from(b3)),
                    Fq2::new(Fq::from(b4), Fq::from(b5)),
                );
                let c = a * b;
                [
                    BigUint::from(c.c0.c0.into_bigint()), BigUint::from(c.c0.c1.into_bigint()),
                    BigUint::from(c.c1.c0.into_bigint()), BigUint::from(c.c1.c1.into_bigint()),
                    BigUint::from(c.c2.c0.into_bigint()), BigUint::from(c.c2.c1.into_bigint()),
                ]
            },
            CurveID::BLS12_381 => {
                use ark_ff::PrimeField;
                use ark_bls12_381::{Fq, Fq2, Fq6};
                let a = Fq6::new(
                    Fq2::new(Fq::from(a0), Fq::from(a1)),
                    Fq2::new(Fq::from(a2), Fq::from(a3)),
                    Fq2::new(Fq::from(a4), Fq::from(a5)),
                );
                let b = Fq6::new(
                    Fq2::new(Fq::from(b0), Fq::from(b1)),
                    Fq2::new(Fq::from(b2), Fq::from(b3)),
                    Fq2::new(Fq::from(b4), Fq::from(b5)),
                );
                let c = a * b;
                [
                    BigUint::from(c.c0.c0.into_bigint()), BigUint::from(c.c0.c1.into_bigint()),
                    BigUint::from(c.c1.c0.into_bigint()), BigUint::from(c.c1.c1.into_bigint()),
                    BigUint::from(c.c2.c0.into_bigint()), BigUint::from(c.c2.c1.into_bigint()),
                ]
            },
            _ => unimplemented!("Unsupported curve")
        };
        return vec![
            element_from_biguint(&c0), element_from_biguint(&c1),
            element_from_biguint(&c2), element_from_biguint(&c3),
            element_from_biguint(&c4), element_from_biguint(&c5),
        ];
    }
    if ext_degree == 12 {
        let [a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11] = a.try_into().unwrap();
        let [b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11] = b.try_into().unwrap();
        let [c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11] = match curve_id {
            CurveID::BN254 => {
                use ark_ff::PrimeField;
                use ark_bn254::{Fq, Fq2, Fq6, Fq12};
                let a = Fq12::new(
                    Fq6::new(
                        Fq2::new(Fq::from(a0), Fq::from(a1)),
                        Fq2::new(Fq::from(a2), Fq::from(a3)),
                        Fq2::new(Fq::from(a4), Fq::from(a5)),
                    ),
                    Fq6::new(
                        Fq2::new(Fq::from(a6), Fq::from(a7)),
                        Fq2::new(Fq::from(a8), Fq::from(a9)),
                        Fq2::new(Fq::from(a10), Fq::from(a11)),
                    ),
                );
                let b = Fq12::new(
                    Fq6::new(
                        Fq2::new(Fq::from(b0), Fq::from(b1)),
                        Fq2::new(Fq::from(b2), Fq::from(b3)),
                        Fq2::new(Fq::from(b4), Fq::from(b5)),
                    ),
                    Fq6::new(
                        Fq2::new(Fq::from(b6), Fq::from(b7)),
                        Fq2::new(Fq::from(b8), Fq::from(b9)),
                        Fq2::new(Fq::from(b10), Fq::from(b11)),
                    ),
                );
                let c = a * b;
                [
                    BigUint::from(c.c0.c0.c0.into_bigint()), BigUint::from(c.c0.c0.c1.into_bigint()),
                    BigUint::from(c.c0.c1.c0.into_bigint()), BigUint::from(c.c0.c1.c1.into_bigint()),
                    BigUint::from(c.c0.c2.c0.into_bigint()), BigUint::from(c.c0.c2.c1.into_bigint()),
                    BigUint::from(c.c1.c0.c0.into_bigint()), BigUint::from(c.c1.c0.c1.into_bigint()),
                    BigUint::from(c.c1.c1.c0.into_bigint()), BigUint::from(c.c1.c1.c1.into_bigint()),
                    BigUint::from(c.c1.c2.c0.into_bigint()), BigUint::from(c.c1.c2.c1.into_bigint()),
                ]
            },
            CurveID::BLS12_381 => {
                use ark_ff::PrimeField;
                use ark_bls12_381::{Fq, Fq2, Fq6, Fq12};
                let a = Fq12::new(
                    Fq6::new(
                        Fq2::new(Fq::from(a0), Fq::from(a1)),
                        Fq2::new(Fq::from(a2), Fq::from(a3)),
                        Fq2::new(Fq::from(a4), Fq::from(a5)),
                    ),
                    Fq6::new(
                        Fq2::new(Fq::from(a6), Fq::from(a7)),
                        Fq2::new(Fq::from(a8), Fq::from(a9)),
                        Fq2::new(Fq::from(a10), Fq::from(a11)),
                    ),
                );
                let b = Fq12::new(
                    Fq6::new(
                        Fq2::new(Fq::from(b0), Fq::from(b1)),
                        Fq2::new(Fq::from(b2), Fq::from(b3)),
                        Fq2::new(Fq::from(b4), Fq::from(b5)),
                    ),
                    Fq6::new(
                        Fq2::new(Fq::from(b6), Fq::from(b7)),
                        Fq2::new(Fq::from(b8), Fq::from(b9)),
                        Fq2::new(Fq::from(b10), Fq::from(b11)),
                    ),
                );
                let c = a * b;
                [
                    BigUint::from(c.c0.c0.c0.into_bigint()), BigUint::from(c.c0.c0.c1.into_bigint()),
                    BigUint::from(c.c0.c1.c0.into_bigint()), BigUint::from(c.c0.c1.c1.into_bigint()),
                    BigUint::from(c.c0.c2.c0.into_bigint()), BigUint::from(c.c0.c2.c1.into_bigint()),
                    BigUint::from(c.c1.c0.c0.into_bigint()), BigUint::from(c.c1.c0.c1.into_bigint()),
                    BigUint::from(c.c1.c1.c0.into_bigint()), BigUint::from(c.c1.c1.c1.into_bigint()),
                    BigUint::from(c.c1.c2.c0.into_bigint()), BigUint::from(c.c1.c2.c1.into_bigint()),
                ]
            },
            _ => unimplemented!("Unsupported curve")
        };
        return vec![
            element_from_biguint(&c0), element_from_biguint(&c1),
            element_from_biguint(&c2), element_from_biguint(&c3),
            element_from_biguint(&c4), element_from_biguint(&c5),
            element_from_biguint(&c6), element_from_biguint(&c7),
            element_from_biguint(&c8), element_from_biguint(&c9),
            element_from_biguint(&c10), element_from_biguint(&c11),
        ];
    }
    else {
        unimplemented!("Unsupported extension degree")
    }
}

fn tower_div<F>(a: &[FieldElement<F>], b: &[FieldElement<F>], ext_degree: usize) -> Vec<FieldElement<F>>
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    assert_eq!(a.len(), ext_degree);
    assert_eq!(b.len(), ext_degree);
    let curve_id = F::get_curve_params().curve_id;
    let a: Vec<BigUint> = a.iter().map(element_to_biguint).collect();
    let b: Vec<BigUint> = b.iter().map(element_to_biguint).collect();
    if ext_degree == 2 {
        let [a0, a1] = a.try_into().unwrap();
        let [b0, b1] = b.try_into().unwrap();
        let [c0, c1] = match curve_id {
            CurveID::BN254 => {
                use ark_ff::PrimeField;
                use ark_bn254::{Fq, Fq2};
                let a = Fq2::new(Fq::from(a0), Fq::from(a1));
                let b = Fq2::new(Fq::from(b0), Fq::from(b1));
                let c = a / b;
                [BigUint::from(c.c0.into_bigint()), BigUint::from(c.c1.into_bigint())]
            },
            CurveID::BLS12_381 => {
                use ark_ff::PrimeField;
                use ark_bls12_381::{Fq, Fq2};
                let a = Fq2::new(Fq::from(a0), Fq::from(a1));
                let b = Fq2::new(Fq::from(b0), Fq::from(b1));
                let c = a / b;
                [BigUint::from(c.c0.into_bigint()), BigUint::from(c.c1.into_bigint())]
            },
            _ => unimplemented!("Unsupported curve")
        };
        return vec![element_from_biguint(&c0), element_from_biguint(&c1)];
    }
    if ext_degree == 6 {
        let [a0, a1, a2, a3, a4, a5] = a.try_into().unwrap();
        let [b0, b1, b2, b3, b4, b5] = b.try_into().unwrap();
        let [c0, c1, c2, c3, c4, c5] = match curve_id {
            CurveID::BN254 => {
                use ark_ff::PrimeField;
                use ark_bn254::{Fq, Fq2, Fq6};
                let a = Fq6::new(
                    Fq2::new(Fq::from(a0), Fq::from(a1)),
                    Fq2::new(Fq::from(a2), Fq::from(a3)),
                    Fq2::new(Fq::from(a4), Fq::from(a5)),
                );
                let b = Fq6::new(
                    Fq2::new(Fq::from(b0), Fq::from(b1)),
                    Fq2::new(Fq::from(b2), Fq::from(b3)),
                    Fq2::new(Fq::from(b4), Fq::from(b5)),
                );
                let c = a / b;
                [
                    BigUint::from(c.c0.c0.into_bigint()), BigUint::from(c.c0.c1.into_bigint()),
                    BigUint::from(c.c1.c0.into_bigint()), BigUint::from(c.c1.c1.into_bigint()),
                    BigUint::from(c.c2.c0.into_bigint()), BigUint::from(c.c2.c1.into_bigint()),
                ]
            },
            CurveID::BLS12_381 => {
                use ark_ff::PrimeField;
                use ark_bls12_381::{Fq, Fq2, Fq6};
                let a = Fq6::new(
                    Fq2::new(Fq::from(a0), Fq::from(a1)),
                    Fq2::new(Fq::from(a2), Fq::from(a3)),
                    Fq2::new(Fq::from(a4), Fq::from(a5)),
                );
                let b = Fq6::new(
                    Fq2::new(Fq::from(b0), Fq::from(b1)),
                    Fq2::new(Fq::from(b2), Fq::from(b3)),
                    Fq2::new(Fq::from(b4), Fq::from(b5)),
                );
                let c = a / b;
                [
                    BigUint::from(c.c0.c0.into_bigint()), BigUint::from(c.c0.c1.into_bigint()),
                    BigUint::from(c.c1.c0.into_bigint()), BigUint::from(c.c1.c1.into_bigint()),
                    BigUint::from(c.c2.c0.into_bigint()), BigUint::from(c.c2.c1.into_bigint()),
                ]
            },
            _ => unimplemented!("Unsupported curve")
        };
        return vec![
            element_from_biguint(&c0), element_from_biguint(&c1),
            element_from_biguint(&c2), element_from_biguint(&c3),
            element_from_biguint(&c4), element_from_biguint(&c5),
        ];
    }
    if ext_degree == 12 {
        let [a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11] = a.try_into().unwrap();
        let [b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11] = b.try_into().unwrap();
        let [c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11] = match curve_id {
            CurveID::BN254 => {
                use ark_ff::PrimeField;
                use ark_bn254::{Fq, Fq2, Fq6, Fq12};
                let a = Fq12::new(
                    Fq6::new(
                        Fq2::new(Fq::from(a0), Fq::from(a1)),
                        Fq2::new(Fq::from(a2), Fq::from(a3)),
                        Fq2::new(Fq::from(a4), Fq::from(a5)),
                    ),
                    Fq6::new(
                        Fq2::new(Fq::from(a6), Fq::from(a7)),
                        Fq2::new(Fq::from(a8), Fq::from(a9)),
                        Fq2::new(Fq::from(a10), Fq::from(a11)),
                    ),
                );
                let b = Fq12::new(
                    Fq6::new(
                        Fq2::new(Fq::from(b0), Fq::from(b1)),
                        Fq2::new(Fq::from(b2), Fq::from(b3)),
                        Fq2::new(Fq::from(b4), Fq::from(b5)),
                    ),
                    Fq6::new(
                        Fq2::new(Fq::from(b6), Fq::from(b7)),
                        Fq2::new(Fq::from(b8), Fq::from(b9)),
                        Fq2::new(Fq::from(b10), Fq::from(b11)),
                    ),
                );
                let c = a / b;
                [
                    BigUint::from(c.c0.c0.c0.into_bigint()), BigUint::from(c.c0.c0.c1.into_bigint()),
                    BigUint::from(c.c0.c1.c0.into_bigint()), BigUint::from(c.c0.c1.c1.into_bigint()),
                    BigUint::from(c.c0.c2.c0.into_bigint()), BigUint::from(c.c0.c2.c1.into_bigint()),
                    BigUint::from(c.c1.c0.c0.into_bigint()), BigUint::from(c.c1.c0.c1.into_bigint()),
                    BigUint::from(c.c1.c1.c0.into_bigint()), BigUint::from(c.c1.c1.c1.into_bigint()),
                    BigUint::from(c.c1.c2.c0.into_bigint()), BigUint::from(c.c1.c2.c1.into_bigint()),
                ]
            },
            CurveID::BLS12_381 => {
                use ark_ff::PrimeField;
                use ark_bls12_381::{Fq, Fq2, Fq6, Fq12};
                let a = Fq12::new(
                    Fq6::new(
                        Fq2::new(Fq::from(a0), Fq::from(a1)),
                        Fq2::new(Fq::from(a2), Fq::from(a3)),
                        Fq2::new(Fq::from(a4), Fq::from(a5)),
                    ),
                    Fq6::new(
                        Fq2::new(Fq::from(a6), Fq::from(a7)),
                        Fq2::new(Fq::from(a8), Fq::from(a9)),
                        Fq2::new(Fq::from(a10), Fq::from(a11)),
                    ),
                );
                let b = Fq12::new(
                    Fq6::new(
                        Fq2::new(Fq::from(b0), Fq::from(b1)),
                        Fq2::new(Fq::from(b2), Fq::from(b3)),
                        Fq2::new(Fq::from(b4), Fq::from(b5)),
                    ),
                    Fq6::new(
                        Fq2::new(Fq::from(b6), Fq::from(b7)),
                        Fq2::new(Fq::from(b8), Fq::from(b9)),
                        Fq2::new(Fq::from(b10), Fq::from(b11)),
                    ),
                );
                let c = a / b;
                [
                    BigUint::from(c.c0.c0.c0.into_bigint()), BigUint::from(c.c0.c0.c1.into_bigint()),
                    BigUint::from(c.c0.c1.c0.into_bigint()), BigUint::from(c.c0.c1.c1.into_bigint()),
                    BigUint::from(c.c0.c2.c0.into_bigint()), BigUint::from(c.c0.c2.c1.into_bigint()),
                    BigUint::from(c.c1.c0.c0.into_bigint()), BigUint::from(c.c1.c0.c1.into_bigint()),
                    BigUint::from(c.c1.c1.c0.into_bigint()), BigUint::from(c.c1.c1.c1.into_bigint()),
                    BigUint::from(c.c1.c2.c0.into_bigint()), BigUint::from(c.c1.c2.c1.into_bigint()),
                ]
            },
            _ => unimplemented!("Unsupported curve")
        };
        return vec![
            element_from_biguint(&c0), element_from_biguint(&c1),
            element_from_biguint(&c2), element_from_biguint(&c3),
            element_from_biguint(&c4), element_from_biguint(&c5),
            element_from_biguint(&c6), element_from_biguint(&c7),
            element_from_biguint(&c8), element_from_biguint(&c9),
            element_from_biguint(&c10), element_from_biguint(&c11),
        ];
    }
    else {
        unimplemented!("Unsupported extension degree")
    }
}

pub fn tower_inv<F>(a: &[FieldElement<F>], ext_degree: usize) -> Vec<FieldElement<F>>
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let mut one = vec![FieldElement::<F>::from(0); ext_degree];
    one[0] = FieldElement::<F>::from(1);
    tower_div(&one, a, ext_degree)
}

pub fn tower_to_direct<F>(x: &[FieldElement<F>], ext_degree: usize) -> Vec<FieldElement<F>>
where
    F: IsPrimeField + CurveParamsProvider<F>,
{
    assert_eq!(x.len(), ext_degree);
    let nr_a0 = &FieldElement::<F>::from(F::get_curve_params().nr_a0);
    if ext_degree == 2 {
        x.to_vec()
    }
    else
    if ext_degree == 6 {
        vec![
            &x[0] - nr_a0 * &x[1],
            &x[2] - nr_a0 * &x[3],
            &x[4] - nr_a0 * &x[5],
            x[1].clone(),
            x[3].clone(),
            x[5].clone(),
        ]
    }
    else
    if ext_degree == 12 {
        vec![
            &x[0] - nr_a0 * &x[1],
            &x[6] - nr_a0 * &x[7],
            &x[2] - nr_a0 * &x[3],
            &x[8] - nr_a0 * &x[9],
            &x[4] - nr_a0 * &x[5],
            &x[10] - nr_a0 * &x[11],
            x[1].clone(),
            x[7].clone(),
            x[3].clone(),
            x[9].clone(),
            x[5].clone(),
            x[11].clone(),
        ]
    }
    else {
        panic!("Unsupported extension degree")
    }
}

pub fn direct_to_tower<F>(x: &[FieldElement<F>], ext_degree: usize) -> Vec<FieldElement<F>>
where
    F: IsPrimeField + CurveParamsProvider<F>,
{
    assert_eq!(x.len(), ext_degree);
    let nr_a0 = &FieldElement::<F>::from(F::get_curve_params().nr_a0);
    if ext_degree == 2 {
        x.to_vec()
    }
    else
    if ext_degree == 6 {
        vec![
            &x[0] + nr_a0 * &x[3],
            x[3].clone(),
            &x[1] + nr_a0 * &x[4],
            x[4].clone(),
            &x[2] + nr_a0 * &x[5],
            x[5].clone(),
        ]
    }
    else
    if ext_degree == 12 {
        vec![
            &x[0] + nr_a0 * &x[6],
            x[6].clone(),
            &x[2] + nr_a0 * &x[8],
            x[8].clone(),
            &x[4] + nr_a0 * &x[10],
            x[10].clone(),
            &x[1] + nr_a0 * &x[7],
            x[7].clone(),
            &x[3] + nr_a0 * &x[9],
            x[9].clone(),
            &x[5] + nr_a0 * &x[11],
            x[11].clone(),
        ]
    }
    else {
        panic!("Unsupported extension degree")
    }
}
