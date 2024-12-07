use crate::algebra::polynomial::Polynomial;
use crate::definitions::FieldElement;
use lambdaworks_math::field::traits::IsPrimeField;
use lambdaworks_math::traits::ByteConversion;

use crate::algebra::g1point::G1Point;
use crate::algebra::rational_function::{FunctionFelt, RationalFunction};
use crate::definitions::{
    BLS12381PrimeField, BN254PrimeField, CurveParamsProvider, GrumpkinPrimeField,
    SECP256K1PrimeField, SECP256R1PrimeField, X25519PrimeField,
};
use crate::ecip::ff::FF;
use crate::io::{
    field_elements_from_big_uints, field_elements_to_big_uints,
    parse_g1_points_from_flattened_field_elements_list,
};

use num_bigint::{BigInt, BigUint, ToBigInt};

pub fn zk_ecip_hint(
    points: Vec<BigUint>,
    scalars: Vec<BigUint>,
    curve_id: usize,
) -> Result<[Vec<BigUint>; 5], String> {
    match curve_id {
        0 => handle_curve::<BN254PrimeField>(points, scalars, field_elements_from_big_uints),
        1 => handle_curve::<BLS12381PrimeField>(points, scalars, field_elements_from_big_uints),
        2 => handle_curve::<SECP256K1PrimeField>(points, scalars, field_elements_from_big_uints),
        3 => handle_curve::<SECP256R1PrimeField>(points, scalars, field_elements_from_big_uints),
        4 => handle_curve::<X25519PrimeField>(points, scalars, field_elements_from_big_uints),
        5 => handle_curve::<GrumpkinPrimeField>(points, scalars, field_elements_from_big_uints),
        _ => Err(String::from("Invalid curve ID")),
    }
}

fn handle_curve<F>(
    values: Vec<BigUint>,
    scalars: Vec<BigUint>,
    parse_fn: fn(&[BigUint]) -> Vec<FieldElement<F>>,
) -> Result<[Vec<BigUint>; 5], String>
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let elements = parse_fn(&values);
    let points = parse_g1_points_from_flattened_field_elements_list(&elements)?;
    let (q, sum_dlog) = run_ecip(&points, &scalars);
    Ok(prepare_result(&q, &sum_dlog))
}

fn construct_digits_vectors<F: IsPrimeField + CurveParamsProvider<F>>(
    list: &[BigUint],
) -> Vec<Vec<i8>> {
    let mut dss_ = Vec::new();

    for scalar_biguint in list {
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

pub fn neg_3_base_le(scalar: &BigUint) -> Vec<i8> {
    if scalar == &BigUint::from(0u32) {
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

pub fn run_ecip<F>(points: &[G1Point<F>], scalars: &[BigUint]) -> (G1Point<F>, FunctionFelt<F>)
where
    F: IsPrimeField + CurveParamsProvider<F>,
{
    let dss = construct_digits_vectors::<F>(scalars);

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

    (q, sum_dlog)
}

fn prepare_result<F>(q: &G1Point<F>, sum_dlog: &FunctionFelt<F>) -> [Vec<BigUint>; 5]
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    let q_list = &[q.x.clone(), q.y.clone()];
    let a_num_list = &sum_dlog.a.numerator.coefficients;
    let a_den_list = &sum_dlog.a.denominator.coefficients;
    let b_num_list = &sum_dlog.b.numerator.coefficients;
    let b_den_list = &sum_dlog.b.denominator.coefficients;
    [
        field_elements_to_big_uints(q_list),
        field_elements_to_big_uints(a_num_list),
        field_elements_to_big_uints(a_den_list),
        field_elements_to_big_uints(b_num_list),
        field_elements_to_big_uints(b_den_list),
    ]
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
    ps: &[G1Point<F>],
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
    bs: &[G1Point<F>],
    dss: Vec<Vec<i8>>,
) -> (G1Point<F>, Vec<FF<F>>) {
    let mut dss = dss;
    dss.reverse();
    let mut q = G1Point::new_unchecked(FieldElement::zero(), FieldElement::zero());
    let mut divisors: Vec<FF<F>> = Vec::new();
    for ds in dss.iter() {
        let (div, new_q) = row_function(ds.clone(), bs, q);

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
