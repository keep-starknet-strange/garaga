use crate::ecip::polynomial::Polynomial;
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::BLS12381PrimeField;
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::BN254PrimeField;
use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::traits::IsPrimeField;
use num_traits::FromPrimitive;

use crate::ecip::curve::{SECP256K1PrimeField, SECP256R1PrimeField, X25519PrimeField};
use crate::ecip::ff::FF;
use crate::ecip::g1point::G1Point;
use crate::ecip::rational_function::FunctionFelt;
use crate::ecip::rational_function::RationalFunction;

use num_bigint::{BigInt, BigUint, ToBigInt};
use pyo3::{prelude::*, types::PyList};

use super::curve::CurveParamsProvider;

#[pyfunction]
pub fn zk_ecip_hint(
    py: Python,
    py_list_1: &PyList,
    py_list_2: &PyList,
    curve_id: usize,
) -> PyResult<PyObject> {
    match curve_id {
        0 => {
            let points: Vec<G1Point<BN254PrimeField>> =
                extract_points::<BN254PrimeField>(py_list_1)?;
            let scalars: Vec<Vec<i8>> = extract_scalars::<BN254PrimeField>(py_list_2)?;
            run_ecip::<BN254PrimeField>(py, points, scalars)
        }
        1 => {
            let points: Vec<G1Point<BLS12381PrimeField>> =
                extract_points::<BLS12381PrimeField>(py_list_1)?;
            let scalars: Vec<Vec<i8>> = extract_scalars::<BLS12381PrimeField>(py_list_2)?;
            run_ecip::<BLS12381PrimeField>(py, points, scalars)
        }
        2 => {
            let points: Vec<G1Point<SECP256K1PrimeField>> =
                extract_points::<SECP256K1PrimeField>(py_list_1)?;
            let scalars: Vec<Vec<i8>> = extract_scalars::<SECP256K1PrimeField>(py_list_2)?;
            run_ecip::<SECP256K1PrimeField>(py, points, scalars)
        }
        3 => {
            let points: Vec<G1Point<SECP256R1PrimeField>> =
                extract_points::<SECP256R1PrimeField>(py_list_1)?;
            let scalars: Vec<Vec<i8>> = extract_scalars::<SECP256R1PrimeField>(py_list_2)?;
            run_ecip::<SECP256R1PrimeField>(py, points, scalars)
        }
        4 => {
            let points: Vec<G1Point<X25519PrimeField>> =
                extract_points::<X25519PrimeField>(py_list_1)?;
            let scalars: Vec<Vec<i8>> = extract_scalars::<X25519PrimeField>(py_list_2)?;
            run_ecip::<X25519PrimeField>(py, points, scalars)
        }
        _ => Err(PyErr::new::<pyo3::exceptions::PyValueError, _>(
            "Invalid curve ID",
        )),
    }
}

fn extract_points<F: IsPrimeField + CurveParamsProvider<F>>(
    py_list: &PyList,
) -> Result<Vec<G1Point<F>>, PyErr> {
    let mut points = Vec::new();

    assert!(
        py_list.len() % 2 == 0,
        "The list must contain an even number of elements."
    );

    for i in (0..py_list.len()).step_by(2) {
        let x: BigUint = py_list[i].extract()?;
        let y: BigUint = py_list[i + 1].extract()?;
        let x_fe = F::from_biguint(x);
        let y_fe = F::from_biguint(y);
        points.push(G1Point::<F>::new(x_fe, y_fe));
    }

    Ok(points)
}

fn extract_scalars<F: IsPrimeField + CurveParamsProvider<F>>(
    py_list: &PyList,
) -> Result<Vec<Vec<i8>>, PyErr> {
    let mut dss_ = Vec::new();

    for i in 0..py_list.len() {
        let scalar_biguint: BigUint = py_list[i].extract()?;
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
        let mut ds = Vec::new();
        for j in 0..dss_.len() {
            ds.push(dss_[j][i]);
        }
        dss.push(ds);
    }

    Ok(dss)
}

fn neg_3_base_le(scalar: BigUint) -> Vec<i8> {
    let mut iscalar = scalar.clone().to_bigint().unwrap();
    let mut digits = Vec::new();
    let zero = BigInt::from_u8(0).unwrap();
    let one = BigInt::from_u8(1).unwrap();
    let two = BigInt::from_u8(2).unwrap();
    let three = BigInt::from_u8(3).unwrap();

    while iscalar != zero {
        let remainder = iscalar.clone() % three.clone();
        if remainder == two {
            digits.push(-1);
            iscalar += one.clone();
        } else {
            digits.push(remainder.try_into().unwrap());
        }
        iscalar = -(iscalar.clone() / three.clone());
    }

    if digits.is_empty() {
        digits.push(0);
    }

    digits
}

fn run_ecip<F>(py: Python, points: Vec<G1Point<F>>, scalars: Vec<Vec<i8>>) -> PyResult<PyObject>
where
    F: IsPrimeField + CurveParamsProvider<F>,
{
    println!("Running ecip");
    let (q, divisors) = ecip_functions(points, scalars);
    println!("Calculating dlogs");
    let dlogs: Vec<_> = divisors.iter().map(|d| dlog(d.clone())).collect();
    println!("Calculating sum_dlog");
    let mut sum_dlog = dlogs[0].clone();
    println!("calculatin minus_three");
    let minus_three = FieldElement::<F>::zero() - FieldElement::<F>::from(3);
    println!("minus_three: {:?}", minus_three);
    for (i, dlog) in dlogs.iter().enumerate().skip(1) {
        sum_dlog = sum_dlog + dlog.clone().scale_by_coeff(minus_three.clone().pow(i));
    }

    let q_tuple = PyList::new(py, [q.x.to_hex(), q.y.to_hex()]);

    let a_num_list = PyList::new(
        py,
        sum_dlog.a.numerator.coefficients.iter().map(|c| c.to_hex()),
    );
    let a_den_list = PyList::new(
        py,
        sum_dlog
            .a
            .denominator
            .coefficients
            .iter()
            .map(|c| c.to_hex()),
    );
    let b_num_list = PyList::new(
        py,
        sum_dlog.b.numerator.coefficients.iter().map(|c| c.to_hex()),
    );
    let b_den_list = PyList::new(
        py,
        sum_dlog
            .b
            .denominator
            .coefficients
            .iter()
            .map(|c| c.to_hex()),
    );

    let result_tuple = PyList::new(
        py,
        [q_tuple, a_num_list, a_den_list, b_num_list, b_den_list],
    );

    Ok(result_tuple.into())
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
        let m = (three * px.clone() * px.clone() + FieldElement::from(F::get_curve_params().a))
            / (two * py.clone());
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
    println!("points: {:?}", ps);
    if ps.is_empty() {
        return FF::new(vec![Polynomial::new(vec![FieldElement::one()])]);
    }

    let mut xs: Vec<(G1Point<F>, FF<F>)> = ps
        .iter()
        .map(|p| (p.clone(), line(p.clone(), p.neg())))
        .collect();

    while xs.len() != 1 {
        println!("xs len : {}", xs.len());
        let mut xs2: Vec<(G1Point<F>, FF<F>)> = Vec::new();

        let x0 = if xs.len() % 2 != 0 {
            let x0 = xs[0].clone();
            xs.remove(0);
            Some(x0)
        } else {
            None
        };

        for n in 0..(xs.len() / 2) {
            println!("n: {}", n);
            let (a, a_num) = &xs[2 * n];
            let (b, b_num) = &xs[2 * n + 1];
            println!("a: {:?}", a);
            println!("b: {:?}", b);
            let num = (a_num.clone() * b_num.clone() * line(a.clone(), b.clone())).reduce();
            println!("num: {:?}", num);
            let den = (line(a.clone(), a.neg()) * line(b.clone(), b.neg())).to_poly();
            println!("den: {:?}", den);
            let d = num.div_by_poly(den);
            println!("d: {:?}", d);
            xs2.push((a.add(b), d));
        }

        if let Some(x0) = x0 {
            xs2.push(x0);
        }

        xs = xs2;
    }

    println!("Done construct_function: {:?}", xs);
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

    println!("Building digits points");
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

    println!("Summing digits points");
    let sum_digits_points = digits_points
        .iter()
        .cloned()
        .reduce(|x, y| x.add(&y))
        .unwrap();

    println!("Calculating q2");
    let q2 = q
        .scalar_mul(-3.to_bigint().unwrap())
        .add(&sum_digits_points);

    let q_neg = q.neg();

    println!("Building divisor");
    let mut div_ = vec![q_neg.clone(), q_neg.clone(), q_neg.clone(), q2.neg()];
    div_.extend(digits_points.iter().cloned());

    let div: Vec<G1Point<F>> = div_.into_iter().filter(|p| !p.is_infinity()).collect();

    println!("Constructing function");
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
    println!("Running ecip_functions");
    for ds in dss {
        println!("ds: {:?}", ds);
        let (div, new_q) = row_function(ds, bs.clone(), q);
        println!("Row function done");
        divisors.push(div);
        q = new_q;
    }

    divisors.reverse();
    (q, divisors)
}

fn dlog<F: IsPrimeField + CurveParamsProvider<F>>(d: FF<F>) -> FunctionFelt<F> {
    println!("Starting dlog");
    let d = d.reduce();
    println!("Reduced dlog");
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
    println!("Calculated dx");

    let dy = d.coeffs[1].clone();
    println!("Calculated dy");

    let two_y = FF::new(vec![
        Polynomial::zero(),
        Polynomial::new(vec![FieldElement::from(2)]),
    ]);
    println!("Calculated two_y");

    let poly = dy.clone()
        * Polynomial::new(vec![
            FieldElement::from(F::get_curve_params().a),
            FieldElement::zero(),
            FieldElement::from(3),
        ]);

    println!("Calculated poly: {:?}", poly.coefficients.len());
    let u = dx.clone() * two_y.clone() + FF::new(vec![poly, Polynomial::zero()]);
    println!("Calculated u");

    let v = two_y * d.clone();
    println!("Calculated v");

    let num = (u * v.clone().neg_y()).reduce();
    println!("Calculated num");
    let den_ff = (v.clone() * v.neg_y()).reduce();
    println!("Calculated den_ff");

    assert!(
        den_ff.coeffs[1].eq(&Polynomial::zero()),
        "Den[1] is not zero: {:?}",
        den_ff.coeffs[1]
    );

    println!("Calculated den");
    let den = den_ff.coeffs[0].clone();

    let (_, _, gcd_0) = Polynomial::xgcd(&num.coeffs[0], &den);
    let (_, _, gcd_1) = Polynomial::xgcd(&num.coeffs[1], &den);

    println!("Calculated gcds");
    println!("gcd_0: {:?}", gcd_0);
    println!("gcd_1: {:?}", gcd_1);
    let a_num = num.coeffs[0].clone().divfloor(&gcd_0);
    println!("Calculated a_num");
    let a_den = den.clone().divfloor(&gcd_0);
    println!("Calculated a_den");
    let b_num = num.coeffs[1].clone().divfloor(&gcd_1);
    println!("Calculated b_num");
    let b_den = den.clone().divfloor(&gcd_1);
    println!("Calculated b_den");

    FunctionFelt {
        a: RationalFunction::new(
            a_num.scale_by_coeff(den.leading_coefficient().inv().unwrap()),
            a_den
                .clone()
                .scale_by_coeff(a_den.leading_coefficient().inv().unwrap()),
        ),
        b: RationalFunction::new(
            b_num.scale_by_coeff(den.leading_coefficient().inv().unwrap()),
            b_den
                .clone()
                .scale_by_coeff(b_den.leading_coefficient().inv().unwrap()),
        ),
    }
}
