use crate::ecip::polynomial::Polynomial;
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::BLS12381PrimeField;
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::BN254PrimeField;
use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::traits::IsPrimeField;
use lambdaworks_math::traits::ByteConversion;

use crate::ecip::curve::{SECP256K1PrimeField, SECP256R1PrimeField, X25519PrimeField};
use crate::ecip::ff::FF;
use crate::ecip::g1point::G1Point;
use crate::ecip::rational_function::FunctionFelt;
use crate::ecip::rational_function::RationalFunction;

use num_bigint::{BigInt, BigUint, ToBigInt};

use super::curve::CurveParamsProvider;

pub fn zk_ecip_hint(
    list_bytes: Vec<Vec<u8>>,
    list_scalars: Vec<BigUint>,
    curve_id: usize,
) -> Result<[Vec<String>; 5], String> {
    match curve_id {
        0 => {
            let list_felts: Vec<FieldElement<BN254PrimeField>> = list_bytes
                .into_iter()
                .map(|x| {
                    FieldElement::<BN254PrimeField>::from_bytes_be(&x)
                        .map_err(|e| format!("Byte conversion error: {:?}", e))
                })
                .collect::<Result<Vec<FieldElement<BN254PrimeField>>, _>>()?;

            let points: Vec<G1Point<BN254PrimeField>> = list_felts
                .chunks(2)
                .map(|chunk| G1Point::new(chunk[0].clone(), chunk[1].clone()))
                .collect();

            let scalars: Vec<Vec<i8>> = extract_scalars::<BN254PrimeField>(list_scalars);
            Ok(run_ecip::<BN254PrimeField>(points, scalars))
        }
        1 => {
            let list_felts: Vec<FieldElement<BLS12381PrimeField>> = list_bytes
                .into_iter()
                .map(|x| {
                    FieldElement::<BLS12381PrimeField>::from_bytes_be(&x)
                        .map_err(|e| format!("Byte conversion error: {:?}", e))
                })
                .collect::<Result<Vec<FieldElement<BLS12381PrimeField>>, _>>()?;

            let points: Vec<G1Point<BLS12381PrimeField>> = list_felts
                .chunks(2)
                .map(|chunk| G1Point::new(chunk[0].clone(), chunk[1].clone()))
                .collect();

            let scalars: Vec<Vec<i8>> = extract_scalars::<BLS12381PrimeField>(list_scalars);
            Ok(run_ecip::<BLS12381PrimeField>(points, scalars))
        }
        2 => {
            let list_felts: Vec<FieldElement<SECP256K1PrimeField>> = list_bytes
                .into_iter()
                .map(|x| {
                    FieldElement::<SECP256K1PrimeField>::from_bytes_be(&x)
                        .map_err(|e| format!("Byte conversion error: {:?}", e))
                })
                .collect::<Result<Vec<FieldElement<SECP256K1PrimeField>>, _>>()?;

            let points: Vec<G1Point<SECP256K1PrimeField>> = list_felts
                .chunks(2)
                .map(|chunk| G1Point::new(chunk[0].clone(), chunk[1].clone()))
                .collect();

            let scalars: Vec<Vec<i8>> = extract_scalars::<SECP256K1PrimeField>(list_scalars);
            Ok(run_ecip::<SECP256K1PrimeField>(points, scalars))
        }
        3 => {
            let list_felts: Vec<FieldElement<SECP256R1PrimeField>> = list_bytes
                .into_iter()
                .map(|x| {
                    FieldElement::<SECP256R1PrimeField>::from_bytes_be(&x)
                        .map_err(|e| format!("Byte conversion error: {:?}", e))
                })
                .collect::<Result<Vec<FieldElement<SECP256R1PrimeField>>, _>>()?;

            let points: Vec<G1Point<SECP256R1PrimeField>> = list_felts
                .chunks(2)
                .map(|chunk| G1Point::new(chunk[0].clone(), chunk[1].clone()))
                .collect();

            let scalars: Vec<Vec<i8>> = extract_scalars::<SECP256R1PrimeField>(list_scalars);
            Ok(run_ecip::<SECP256R1PrimeField>(points, scalars))
        }
        4 => {
            let list_felts: Vec<FieldElement<X25519PrimeField>> = list_bytes
                .into_iter()
                .map(|x| {
                    FieldElement::<X25519PrimeField>::from_bytes_be(&x)
                        .map_err(|e| format!("Byte conversion error: {:?}", e))
                })
                .collect::<Result<Vec<FieldElement<X25519PrimeField>>, _>>()?;

            let points: Vec<G1Point<X25519PrimeField>> = list_felts
                .chunks(2)
                .map(|chunk| G1Point::new(chunk[0].clone(), chunk[1].clone()))
                .collect();

            let scalars: Vec<Vec<i8>> = extract_scalars::<X25519PrimeField>(list_scalars);
            Ok(run_ecip::<X25519PrimeField>(points, scalars))
        }
        _ => Err(String::from("Invalid curve ID")),
    }
}

fn extract_scalars<F: IsPrimeField + CurveParamsProvider<F>>(list: Vec<BigUint>) -> Vec<Vec<i8>> {
    let mut dss_ = Vec::new();

    for i in 0..list.len() {
        let scalar_biguint = list[i].clone();
        let neg_3_digits = neg_3_base_le(scalar_biguint);
        dss_.push(neg_3_digits);
    }

    let max_len = dss_.iter().map(|ds| ds.len()).max().unwrap();
    dss_.iter_mut().for_each(|ds| {
        while ds.len() < max_len {
            ds.push(0);
        }
    });

    // Transpose the matrix
    let mut dss = Vec::new();
    for i in 0..max_len {
        let ds: Vec<_> = dss_.iter().map(|d| d[i]).collect();
        dss.push(ds);
    }

    dss
}

fn neg_3_base_le(scalar: BigUint) -> Vec<i8> {
    if scalar == BigUint::from(0u32) {
        return vec![0];
    }

    let mut iscalar = scalar.to_bigint().unwrap();
    let mut digits = Vec::new();
    let three = BigInt::from(3);
    let one = BigInt::from(1);
    let min_one = BigInt::from(-1);
    let zero = BigInt::from(0);
    let two = BigInt::from(2);

    while iscalar != zero {
        let mut remainder = iscalar.clone() % three.clone();
        if remainder < zero {
            remainder += three.clone();
        }
        if remainder == two {
            remainder = min_one.clone();
            iscalar += one.clone();
        }
        digits.push(remainder.try_into().unwrap());
        iscalar = -floor_division(iscalar.clone(), three.clone()); // Use floor division
    }

    digits
}

fn floor_division(a: BigInt, b: BigInt) -> BigInt {
    let div = &a / &b;
    let rem = &a % &b;
    if (rem != BigInt::from(0)) && ((rem < BigInt::from(0)) != (b < BigInt::from(0))) {
        div - BigInt::from(1)
    } else {
        div
    }
}

fn run_ecip<F>(points: Vec<G1Point<F>>, dss: Vec<Vec<i8>>) -> [Vec<String>; 5]
where
    F: IsPrimeField + CurveParamsProvider<F>,
{
    // println!("Running ecip");
    let (q, divisors) = ecip_functions(points, dss);
    // println!("Calculating dlogs");
    let dlogs: Vec<_> = divisors.iter().map(|d| dlog(d.clone())).collect();

    let mut sum_dlog = dlogs[0].clone();
    let minus_three = FieldElement::<F>::zero() - FieldElement::<F>::from(3);
    let mut neg_3_power = FieldElement::<F>::one();
    for dlog in dlogs.iter().skip(1) {
        neg_3_power *= minus_three.clone();
        sum_dlog = sum_dlog + dlog.clone().scale_by_coeff(neg_3_power.clone());
    }

    // let sum_dlog = sum_dlog.simplify();

    let q_tuple = vec![
        q.x.representative().to_string(),
        q.y.representative().to_string(),
    ];
    let a_num_list = sum_dlog
        .a
        .numerator
        .coefficients
        .iter()
        .map(|c| c.representative().to_string())
        .collect();
    let a_den_list = sum_dlog
        .a
        .denominator
        .coefficients
        .iter()
        .map(|c| c.representative().to_string())
        .collect();
    let b_num_list = sum_dlog
        .b
        .numerator
        .coefficients
        .iter()
        .map(|c| c.representative().to_string())
        .collect();
    let b_den_list = sum_dlog
        .b
        .denominator
        .coefficients
        .iter()
        .map(|c| c.representative().to_string())
        .collect();

    [q_tuple, a_num_list, a_den_list, b_num_list, b_den_list]
}

fn line<F: IsPrimeField + CurveParamsProvider<F>>(p: G1Point<F>, q: G1Point<F>) -> FF<F> {
    if p.is_infinity() {
        if q.is_infinity() {
            return FF::new(vec![Polynomial::new(vec![FieldElement::one()])]);
        } else {
            let qx = q.x.clone();
            return FF::new(vec![Polynomial::new(vec![-qx, FieldElement::one()])]);
        }
    }
    if q.is_infinity() {
        let px = p.x.clone();
        return FF::new(vec![Polynomial::new(vec![-px, FieldElement::one()])]);
    }

    let px = p.x.clone();
    let py = p.y.clone();
    let three: FieldElement<F> = FieldElement::from(3);
    let two: FieldElement<F> = FieldElement::from(2);
    if p == q {
        let m = (three * px.clone() * px.clone() + F::get_curve_params().a) / (two * py.clone());
        let b = py.clone() - m.clone() * px.clone();
        return FF::new(vec![
            Polynomial::new(vec![-b, -m]),
            Polynomial::new(vec![FieldElement::one()]),
        ]);
    }

    if p == q.neg() {
        return FF::new(vec![Polynomial::new(vec![-px, FieldElement::one()])]);
    }

    let qx = q.x.clone();
    let qy = q.y.clone();

    let m = (py.clone() - qy.clone()) / (px.clone() - qx.clone());
    let b = qy - m.clone() * qx;
    FF::new(vec![
        Polynomial::new(vec![-b, -m]),
        Polynomial::new(vec![FieldElement::one()]),
    ])
}

fn construct_function<F: IsPrimeField + CurveParamsProvider<F>>(ps: Vec<G1Point<F>>) -> FF<F> {
    if ps.is_empty() {
        return FF::new(vec![Polynomial::new(vec![FieldElement::one()])]);
    }

    let mut xs: Vec<(G1Point<F>, FF<F>)> = ps
        .iter()
        .map(|p| (p.clone(), line(p.clone(), p.neg())))
        .collect();

    while xs.len() != 1 {
        let mut xs2: Vec<(G1Point<F>, FF<F>)> = Vec::new();

        let x0 = if xs.len() % 2 != 0 {
            let x0 = xs[0].clone();
            xs.remove(0);
            Some(x0)
        } else {
            None
        };

        for n in 0..(xs.len() / 2) {
            let (a, a_num) = &xs[2 * n];
            let (b, b_num) = &xs[2 * n + 1];
            let a_num_b_num = a_num.clone() * b_num.clone();

            let line_ab = line(a.clone(), b.clone());
            let product = a_num_b_num * line_ab;
            let num = product.reduce();
            let den = (line(a.clone(), a.neg()) * line(b.clone(), b.neg())).to_poly();
            let d = num.div_by_poly(&den);
            xs2.push((a.add(b), d));
        }

        if let Some(x0) = x0 {
            xs2.push(x0);
        }

        xs = xs2;
    }

    assert!(xs[0].0.is_infinity(), "xs[0] is not infinity");

    xs.last().unwrap().1.normalize()
}

fn row_function<F: IsPrimeField + CurveParamsProvider<F>>(
    ds: Vec<i8>,
    ps: Vec<G1Point<F>>,
    q: G1Point<F>,
) -> (FF<F>, G1Point<F>) {
    let one = 1;
    let minus_one = -1;

    let digits_points: Vec<G1Point<F>> = ds
        .iter()
        .zip(ps.iter())
        .map(|(&d, p)| {
            if d == one {
                p.clone()
            } else if d == minus_one {
                p.neg()
            } else {
                G1Point {
                    x: FieldElement::zero(),
                    y: FieldElement::zero(),
                }
            }
        })
        .collect();

    let sum_digits_points = digits_points
        .iter()
        .cloned()
        .reduce(|x, y| x.add(&y))
        .unwrap();

    let q2 = q.scalar_mul_neg_3().add(&sum_digits_points);

    let q_neg = q.neg();

    let mut div_ = vec![q_neg.clone(), q_neg.clone(), q_neg.clone(), q2.neg()];
    div_.extend(digits_points.iter().cloned());

    let div: Vec<G1Point<F>> = div_.into_iter().filter(|p| !p.is_infinity()).collect();

    let d = construct_function(div);

    (d, q2)
}

fn ecip_functions<F: IsPrimeField + CurveParamsProvider<F>>(
    bs: Vec<G1Point<F>>,
    dss: Vec<Vec<i8>>,
) -> (G1Point<F>, Vec<FF<F>>) {
    let mut dss = dss;
    dss.reverse();
    let mut q = G1Point::new(FieldElement::zero(), FieldElement::zero());
    let mut divisors: Vec<FF<F>> = Vec::new();
    for ds in dss.iter() {
        let (div, new_q) = row_function(ds.clone(), bs.clone(), q);

        divisors.push(div);
        q = new_q;
    }

    divisors.reverse();
    (q, divisors)
}

fn dlog<F: IsPrimeField + CurveParamsProvider<F>>(d: FF<F>) -> FunctionFelt<F> {
    let d = d.reduce();
    assert!(
        d.coeffs.len() == 2,
        "D has {} coeffs: {:?}",
        d.coeffs.len(),
        d.coeffs
    );

    let dx = FF::new(vec![
        d.coeffs[0].differentiate(),
        d.coeffs[1].differentiate(),
    ]);

    let dy = d.coeffs[1].clone();

    let two_y = FF::<F>::new(vec![
        Polynomial::<F>::zero(),
        Polynomial::new(vec![FieldElement::<F>::from(2)]),
    ]);

    let poly = dy.clone()
        * Polynomial::<F>::new(vec![
            F::get_curve_params().a,
            FieldElement::zero(),
            FieldElement::from(3),
        ]);

    let u = dx.clone() * two_y.clone() + FF::new(vec![poly, Polynomial::zero()]);

    let v = two_y * d.clone();

    let num = (u * v.clone().neg_y()).reduce();

    let den_ff = (v.clone() * v.neg_y()).reduce();

    assert!(
        den_ff.coeffs[1].degree() == -1,
        "Den[1] is not zero: {:?}",
        den_ff.coeffs[1].degree()
    );

    let den = den_ff.coeffs[0].clone();

    let (_, _, gcd_0) = Polynomial::xgcd(&num.coeffs[0], &den);
    let (_, _, gcd_1) = Polynomial::xgcd(&num.coeffs[1], &den);

    let a_num = num.coeffs[0].clone().divfloor(&gcd_0);
    let a_den = den.clone().divfloor(&gcd_0);
    let b_num = num.coeffs[1].clone().divfloor(&gcd_1);
    let b_den = den.clone().divfloor(&gcd_1);

    FunctionFelt {
        a: RationalFunction::new(
            a_num.scale_by_coeff(&den.leading_coefficient().inv().unwrap()),
            a_den
                .clone()
                .scale_by_coeff(&a_den.leading_coefficient().inv().unwrap()),
        ),
        b: RationalFunction::new(
            b_num.scale_by_coeff(&den.leading_coefficient().inv().unwrap()),
            b_den
                .clone()
                .scale_by_coeff(&b_den.leading_coefficient().inv().unwrap()),
        ),
    }
}
