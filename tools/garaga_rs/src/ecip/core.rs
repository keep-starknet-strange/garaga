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
            let list_bytes: Vec<&[u8]> = py_list_1
                .into_iter()
                .map(|x| x.extract())
                .collect::<Result<Vec<&[u8]>, _>>()?;

            let list_felts: Vec<FieldElement<BN254PrimeField>> = list_bytes
                .into_iter()
                .map(|x| {
                    FieldElement::<BN254PrimeField>::from_bytes_be(x).map_err(|e| {
                        PyErr::new::<pyo3::exceptions::PyValueError, _>(format!(
                            "Byte conversion error: {:?}",
                            e
                        ))
                    })
                })
                .collect::<Result<Vec<FieldElement<BN254PrimeField>>, _>>()?;

            let points: Vec<G1Point<BN254PrimeField>> = list_felts
                .chunks(2)
                .map(|chunk| G1Point::new(chunk[0].clone(), chunk[1].clone()))
                .collect();

            let scalars: Vec<Vec<i8>> = extract_scalars::<BN254PrimeField>(py_list_2)?;
            run_ecip::<BN254PrimeField>(py, points, scalars)
        }
        1 => {
            let list_bytes: Vec<&[u8]> = py_list_1
                .into_iter()
                .map(|x| x.extract())
                .collect::<Result<Vec<&[u8]>, _>>()?;

            let list_felts: Vec<FieldElement<BLS12381PrimeField>> = list_bytes
                .into_iter()
                .map(|x| {
                    FieldElement::<BLS12381PrimeField>::from_bytes_be(x).map_err(|e| {
                        PyErr::new::<pyo3::exceptions::PyValueError, _>(format!(
                            "Byte conversion error: {:?}",
                            e
                        ))
                    })
                })
                .collect::<Result<Vec<FieldElement<BLS12381PrimeField>>, _>>()?;

            let points: Vec<G1Point<BLS12381PrimeField>> = list_felts
                .chunks(2)
                .map(|chunk| G1Point::new(chunk[0].clone(), chunk[1].clone()))
                .collect();

            let scalars: Vec<Vec<i8>> = extract_scalars::<BLS12381PrimeField>(py_list_2)?;
            run_ecip::<BLS12381PrimeField>(py, points, scalars)
        }
        2 => {
            let list_bytes: Vec<&[u8]> = py_list_1
                .into_iter()
                .map(|x| x.extract())
                .collect::<Result<Vec<&[u8]>, _>>()?;

            let list_felts: Vec<FieldElement<SECP256K1PrimeField>> = list_bytes
                .into_iter()
                .map(|x| {
                    FieldElement::<SECP256K1PrimeField>::from_bytes_be(x).map_err(|e| {
                        PyErr::new::<pyo3::exceptions::PyValueError, _>(format!(
                            "Byte conversion error: {:?}",
                            e
                        ))
                    })
                })
                .collect::<Result<Vec<FieldElement<SECP256K1PrimeField>>, _>>()?;

            let points: Vec<G1Point<SECP256K1PrimeField>> = list_felts
                .chunks(2)
                .map(|chunk| G1Point::new(chunk[0].clone(), chunk[1].clone()))
                .collect();

            let scalars: Vec<Vec<i8>> = extract_scalars::<SECP256K1PrimeField>(py_list_2)?;
            run_ecip::<SECP256K1PrimeField>(py, points, scalars)
        }
        3 => {
            let list_bytes: Vec<&[u8]> = py_list_1
                .into_iter()
                .map(|x| x.extract())
                .collect::<Result<Vec<&[u8]>, _>>()?;

            let list_felts: Vec<FieldElement<SECP256R1PrimeField>> = list_bytes
                .into_iter()
                .map(|x| {
                    FieldElement::<SECP256R1PrimeField>::from_bytes_be(x).map_err(|e| {
                        PyErr::new::<pyo3::exceptions::PyValueError, _>(format!(
                            "Byte conversion error: {:?}",
                            e
                        ))
                    })
                })
                .collect::<Result<Vec<FieldElement<SECP256R1PrimeField>>, _>>()?;

            let points: Vec<G1Point<SECP256R1PrimeField>> = list_felts
                .chunks(2)
                .map(|chunk| G1Point::new(chunk[0].clone(), chunk[1].clone()))
                .collect();

            let scalars: Vec<Vec<i8>> = extract_scalars::<SECP256R1PrimeField>(py_list_2)?;
            run_ecip::<SECP256R1PrimeField>(py, points, scalars)
        }
        4 => {
            let list_bytes: Vec<&[u8]> = py_list_1
                .into_iter()
                .map(|x| x.extract())
                .collect::<Result<Vec<&[u8]>, _>>()?;

            let list_felts: Vec<FieldElement<X25519PrimeField>> = list_bytes
                .into_iter()
                .map(|x| {
                    FieldElement::<X25519PrimeField>::from_bytes_be(x).map_err(|e| {
                        PyErr::new::<pyo3::exceptions::PyValueError, _>(format!(
                            "Byte conversion error: {:?}",
                            e
                        ))
                    })
                })
                .collect::<Result<Vec<FieldElement<X25519PrimeField>>, _>>()?;

            let points: Vec<G1Point<X25519PrimeField>> = list_felts
                .chunks(2)
                .map(|chunk| G1Point::new(chunk[0].clone(), chunk[1].clone()))
                .collect();

            let scalars: Vec<Vec<i8>> = extract_scalars::<X25519PrimeField>(py_list_2)?;
            run_ecip::<X25519PrimeField>(py, points, scalars)
        }
        _ => Err(PyErr::new::<pyo3::exceptions::PyValueError, _>(
            "Invalid curve ID",
        )),
    }
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

fn run_ecip<F>(py: Python, points: Vec<G1Point<F>>, dss: Vec<Vec<i8>>) -> PyResult<PyObject>
where
    F: IsPrimeField + CurveParamsProvider<F>,
{
    // println!("Running ecip");
    let (q, divisors) = ecip_functions(points, dss);
    q.print();
    // println!("Calculating dlogs");
    let dlogs: Vec<_> = divisors.iter().map(|d| dlog(d.clone())).collect();

    for (i, dlog) in dlogs.clone().iter().enumerate() {
        println!("DLOG_{} : {}", i, dlog.print_as_sage_poly());
    }
    // println!("Calculating sum_dlog");
    let mut sum_dlog = dlogs[0].clone();
    // println!("calculatin minus_three");
    let minus_three = FieldElement::<F>::zero() - FieldElement::<F>::from(3);
    println!(
        "minus_three: {:?}",
        minus_three.representative().to_string()
    );
    // let min_3_sq = minus_three.clone() * minus_three.clone();
    // let min_3_sq_pow = minus_three.clone().pow(2 as u64);

    // println!("min_3_sq: {:?}", min_3_sq.representative().to_string());

    // println!(
    //     "min_3_sq_pow: {:?}",
    //     min_3_sq_pow.representative().to_string()
    // );
    let mut neg_3_power = FieldElement::<F>::one();
    for (i, dlog) in dlogs.iter().enumerate().skip(1) {
        neg_3_power = neg_3_power * minus_three.clone();
        println!(
            "neg_3_pow_{}: {:?}",
            i,
            neg_3_power.representative().to_string()
        );
        sum_dlog = sum_dlog + dlog.clone().scale_by_coeff(neg_3_power.clone());
    }

    // let sum_dlog = sum_dlog.simplify();

    println!("FINAL sum_dlog: {:?}", sum_dlog.print_as_sage_poly());

    let q_tuple = PyList::new(
        py,
        [
            q.x.representative().to_string(),
            q.y.representative().to_string(),
        ],
    );

    let a_num_list = PyList::new(
        py,
        sum_dlog
            .a
            .numerator
            .coefficients
            .iter()
            .map(|c| c.representative().to_string()),
    );
    let a_den_list = PyList::new(
        py,
        sum_dlog
            .a
            .denominator
            .coefficients
            .iter()
            .map(|c| c.representative().to_string()),
    );
    let b_num_list = PyList::new(
        py,
        sum_dlog
            .b
            .numerator
            .coefficients
            .iter()
            .map(|c| c.representative().to_string()),
    );
    let b_den_list = PyList::new(
        py,
        sum_dlog
            .b
            .denominator
            .coefficients
            .iter()
            .map(|c| c.representative().to_string()),
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
    if ps.is_empty() {
        return FF::new(vec![Polynomial::new(vec![FieldElement::one()])]);
    }

    let mut xs: Vec<(G1Point<F>, FF<F>)> = ps
        .iter()
        .map(|p| (p.clone(), line(p.clone(), p.neg())))
        .collect();
    // println!("xs input points : ");

    // for (i, tuple) in xs.clone().into_iter().enumerate() {
    //     println!("LINE_{} : {}", i, tuple.1.print_as_sage_poly());
    // }

    while xs.len() != 1 {
        // println!("xs len : {}", xs.len());
        let mut xs2: Vec<(G1Point<F>, FF<F>)> = Vec::new();

        let x0 = if xs.len() % 2 != 0 {
            let x0 = xs[0].clone();
            xs.remove(0);
            Some(x0)
        } else {
            None
        };

        for n in 0..(xs.len() / 2) {
            // println!("CONSTRU N: {}", n);
            let (a, a_num) = &xs[2 * n];
            let (b, b_num) = &xs[2 * n + 1];
            // Print a_num and b_num;
            // println!("CONSTRUCT A_NUM: {}", a_num.print_as_sage_poly());
            // println!("CONSTRUCT B_NUM: {}", b_num.print_as_sage_poly());
            let a_num_b_num = a_num.clone() * b_num.clone();
            // println!(
            //     "CONSTRUCT A_NUM * B_NUM: {}",
            //     a_num_b_num.print_as_sage_poly()
            // );
            let line_ab = line(a.clone(), b.clone());
            // println!("CONSTRUCT LINE(A,B): {}", line_ab.print_as_sage_poly());
            let product = a_num_b_num * line_ab;
            // println!("CONSTRUCT PRODUCT: {}", product.print_as_sage_poly());
            let num = product.reduce();
            // println!("CONSTRUCT NUM: {}", num.print_as_sage_poly());
            let den = (line(a.clone(), a.neg()) * line(b.clone(), b.neg())).to_poly();
            // println!("CONSTRUCT DEN: {}", den.print_as_sage_poly());
            let d = num.div_by_poly(den);
            // println!("d: {:?}", d);
            xs2.push((a.add(b), d));
        }

        if let Some(x0) = x0 {
            xs2.push(x0);
        }

        xs = xs2;
    }

    // println!("Done construct_function: {:?}", xs);
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

    println!("Scalar multiplying");
    let q2 = q.scalar_mul_neg_3().add(&sum_digits_points);

    println!("Negating q");
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
    // println!("dss_reverse {:?}", dss);
    let mut q = G1Point::new(FieldElement::zero(), FieldElement::zero());
    let mut divisors: Vec<FF<F>> = Vec::new();
    // println!("Running ecip_functions");
    // println!("Q_0: {:?}", q);
    for ds in dss.iter() {
        let (div, new_q) = row_function(ds.clone(), bs.clone(), q);

        divisors.push(div);
        q = new_q;
    }

    divisors.reverse();
    (q, divisors)
}

fn dlog<F: IsPrimeField + CurveParamsProvider<F>>(d: FF<F>) -> FunctionFelt<F> {
    // println!("Starting dlog");
    // println!("DLOG INPUT BEFORE REDUCE");
    // println!("coeff0 {}", d.coeffs[0].print_as_sage_poly());
    // println!("coeff1 {}", d.coeffs[1].print_as_sage_poly());
    let d = d.reduce();
    // println!("Reduced dlog");
    assert!(
        d.coeffs.len() == 2,
        "D has {} coeffs: {:?}",
        d.coeffs.len(),
        d.coeffs
    );

    // println!("DLOG INPUT AFTER REDUCE");
    // println!("coeff0 {}", d.coeffs[0].print_as_sage_poly());
    // println!("coeff1 {}", d.coeffs[1].print_as_sage_poly());

    let dx = FF::new(vec![
        d.coeffs[0].differentiate(),
        d.coeffs[1].differentiate(),
    ]);
    // println!("Calculated dx");
    // println!("dx coeffs 0: {:?}", dx.coeffs[0].print_as_sage_poly());
    // println!("dx coeffs 1: {:?}", dx.coeffs[1].print_as_sage_poly());

    let dy = d.coeffs[1].clone();
    // println!("Calculated dy");
    // println!("dy coeffs: {:?}", dy.print_as_sage_poly());

    let two_y = FF::<F>::new(vec![
        Polynomial::<F>::zero(),
        Polynomial::new(vec![FieldElement::<F>::from(2)]),
    ]);
    // println!("Calculated two_y");

    let poly = dy.clone()
        * Polynomial::<F>::new(vec![
            FieldElement::from(F::get_curve_params().a),
            FieldElement::zero(),
            FieldElement::from(3),
        ]);
    // println!("Calculated poly");
    // println!("poly coeffs: {:?}", poly.print_as_sage_poly());

    // println!("Calculated poly: {:?}", poly.coefficients.len());
    let u = dx.clone() * two_y.clone() + FF::new(vec![poly, Polynomial::zero()]);
    // println!("Calculated u");
    // println!("u coeffs 0: {:?}", u.coeffs[0].print_as_sage_poly());
    // println!("u coeffs 1: {:?}", u.coeffs[1].print_as_sage_poly());

    let v = two_y * d.clone();
    // println!("Calculated v");
    // println!("v coeffs 0: {:?}", v.coeffs[0].print_as_sage_poly());
    // println!("v coeffs 1: {:?}", v.coeffs[1].print_as_sage_poly());

    let num = (u * v.clone().neg_y()).reduce();
    // println!("Calculated num");
    // println!("num coeffs 0: {:?}", num.coeffs[0].print_as_sage_poly());
    // println!("num coeffs 1: {:?}", num.coeffs[1].print_as_sage_poly());

    let den_ff = (v.clone() * v.neg_y()).reduce();
    // println!("Calculated den_ff");
    // println!(
    //     "den_ff coeffs 0: {:?}",
    //     den_ff.coeffs[0].print_as_sage_poly()
    // );
    // println!(
    //     "den_ff coeffs 1: {:?}",
    //     den_ff.coeffs[1].print_as_sage_poly()
    // );

    assert!(
        den_ff.coeffs[1].degree() == -1,
        "Den[1] is not zero: {:?}",
        den_ff.coeffs[1].degree()
    );

    // println!("Calculated den");
    let den = den_ff.coeffs[0].clone();

    let (_, _, gcd_0) = Polynomial::xgcd(&num.coeffs[0], &den);
    let (_, _, gcd_1) = Polynomial::xgcd(&num.coeffs[1], &den);

    // println!("Calculated gcds");
    // println!("gcd_0: {:?}", gcd_0);
    // println!("gcd_1: {:?}", gcd_1);
    let a_num = num.coeffs[0].clone().divfloor(&gcd_0);
    // println!("Calculated a_num");
    let a_den = den.clone().divfloor(&gcd_0);
    // println!("Calculated a_den");
    let b_num = num.coeffs[1].clone().divfloor(&gcd_1);
    // println!("Calculated b_num");
    let b_den = den.clone().divfloor(&gcd_1);
    // println!("Calculated b_den");

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
