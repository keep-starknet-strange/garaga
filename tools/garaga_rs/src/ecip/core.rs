use crate::ecip::polynomial::Polynomial;
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::BLS12381PrimeField;
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::BN254PrimeField;
use lambdaworks_math::field::traits::IsPrimeField;
use lambdaworks_math::field::{
    element::FieldElement, fields::fft_friendly::stark_252_prime_field::Stark252PrimeField,
};

use crate::ecip::curve::{SECP256K1PrimeField, SECP256R1PrimeField, X25519PrimeField};
use crate::ecip::ff::FF;
use crate::ecip::g1point::G1Point;
use crate::ecip::rational_function::FunctionFelt;
use crate::ecip::rational_function::RationalFunction;

use num_bigint::{BigUint, ToBigInt};
use pyo3::{
    types::PyList,
    {prelude::*, wrap_pyfunction},
};

use super::curve::{CurveParamsProvider, FromBigUint};

#[pyfunction]
fn zk_ecip_hint(
    py: Python,
    py_list_1: &PyList,
    py_list_2: &PyList,
    curve_id: usize,
) -> PyResult<PyObject> {

    match curve_id {
        0 => {
            let points: Vec<G1Point<BN254PrimeField>> = extract_points::<BN254PrimeField>(py_list_1)?;
            let scalars: Vec<FieldElement<BN254PrimeField>> = extract_scalars::<BN254PrimeField>(py_list_2)?;
            run_ecip::<BN254PrimeField>(points, scalars, py)
        }
        1 => {
            let points: Vec<G1Point<BLS12381PrimeField>> = extract_points::<BLS12381PrimeField>(py_list_1)?;
            let scalars: Vec<FieldElement<BLS12381PrimeField>> = extract_scalars::<BLS12381PrimeField>(py_list_2)?;
            run_ecip::<BLS12381PrimeField>(points, scalars, py)
        }
        2 => {
            let points: Vec<G1Point<SECP256K1PrimeField>> = extract_points::<SECP256K1PrimeField>(py_list_1)?;
            let scalars: Vec<FieldElement<SECP256K1PrimeField>> = extract_scalars::<SECP256K1PrimeField>(py_list_2)?;
            run_ecip::<SECP256K1PrimeField>(points, scalars, py)
        }
        3 => {
            let points: Vec<G1Point<SECP256R1PrimeField>> = extract_points::<SECP256R1PrimeField>(py_list_1)?;
            let scalars: Vec<FieldElement<SECP256R1PrimeField>> = extract_scalars::<SECP256R1PrimeField>(py_list_2)?;
            run_ecip::<SECP256R1PrimeField>(points, scalars, py)
        }
        4 => {
            let points: Vec<G1Point<X25519PrimeField>> = extract_points::<X25519PrimeField>(py_list_1)?;
            let scalars: Vec<FieldElement<X25519PrimeField>> = extract_scalars::<X25519PrimeField>(py_list_2)?;
            run_ecip::<X25519PrimeField>(points, scalars, py)
        }
        _ => Err(PyErr::new::<pyo3::exceptions::PyValueError, _>("Invalid curve ID")),
    }
}

fn extract_points<F: IsPrimeField + FromBigUint>(py_list: &PyList) -> PyResult<Vec<G1Point<F>>> {
    let mut points = Vec::new();

    assert!(py_list.len() % 2 == 0, "The list must contain an even number of elements.");

    for i in (0..py_list.len()).step_by(2) {
        let x: BigUint = py_list[i].extract()?;
        let y: BigUint = py_list[i + 1].extract()?;
        let x_fe = F::from_biguint(x);
        let y_fe = F::from_biguint(y);
        points.push(G1Point::<F>::new(x_fe, y_fe));
    }

    Ok(points)
}


fn extract_scalars<F: IsPrimeField + FromBigUint>(py_list: &PyList) -> PyResult<Vec<Vec<FieldElement<F>>>> {
    let mut scalars = Vec::new();
    
    for i in 0..py_list.len() {
        let scalar: BigUint = py_list[i].extract()?;
        let neg_3_digits = neg_3_base_le(scalar);
        let field_elements: Vec<FieldElement<F>> = neg_3_digits.iter()
            .map(|&d| FieldElement::<F>::from_biguint(BigUint::from(d.abs())))
            .collect();
        scalars.push(field_elements);
    }

    Ok(scalars)
}

fn neg_3_base_le(scalar: BigUint) -> Vec<i64> {
    let mut digits = Vec::new();
    let mut scalar = scalar;

    while scalar != BigUint::zero() {
        let remainder = (&scalar % 3u64).to_i64().unwrap();
        let mut digit = remainder;
        if remainder == 2 {
            digit = -1;
            scalar += 1u64;
        }
        digits.push(digit);
        scalar = -(scalar.clone() / 3u64);
    }

    if digits.is_empty() {
        digits.push(0);
    }

    digits
}


fn run_ecip<F>(
    points: Vec<G1Point<F>>,
    scalars: Vec<FieldElement<F>>,
    py: Python,
) -> PyResult<PyObject>
where 
    F: IsPrimeField + CurveParamsProvider<F> + PartialEq,
{
    let (q, ds) = ecip_functions(points, scalars);
    let dlogs: Vec<_> = ds.iter().map(|d| dlog(d.clone())).collect();
    let mut sum_dlog = dlogs[0].clone();

    for (i, dlog) in dlogs.iter().enumerate().skip(1) {
        sum_dlog = sum_dlog + dlog.clone() * FieldElement::<F>::from((-3).pow(i as u32));
    }

    Ok((q, sum_dlog).to_object(py))
}

fn line<F: IsPrimeField + PartialEq + CurveParamsProvider<F>>(
    P: G1Point<F>,
    Q: G1Point<F>,
) -> FF<F> {
    if P.is_infinity() {
        if Q.is_infinity() {
            return FF::new(vec![Polynomial::new(vec![FieldElement::one()])]);
        } else {
            let Qx = Q.x.clone();
            return FF::new(vec![Polynomial::new(vec![-Qx, FieldElement::one()])]);
        }
    }
    if Q.is_infinity() {
        let Px = P.x.clone();
        return FF::new(vec![Polynomial::new(vec![-Px, FieldElement::one()])]);
    }

    let Px = P.x.clone();
    let Py: FieldElement<F> = P.y.clone();
    let three : FieldElement<F> = FieldElement::from(3);
    let two : FieldElement<F> = FieldElement::from(2);
    if P == Q {
        let m = 
            (three* Px.clone() * Px.clone() 
            + FieldElement::from(F::get_curve_params().a))
            / (two * Py.clone());
        let b = Py.clone() - m.clone() * Px.clone();
        return FF::new(vec![
            Polynomial::new(vec![-b, -m]),
            Polynomial::new(vec![FieldElement::one()]),
        ]);
    }

    if P == Q.neg() {
        return FF::new(vec![Polynomial::new(vec![-Px, FieldElement::one()])]);
    }

    let Qx = Q.x.clone();
    let Qy = Q.y.clone();

    let m = (Py.clone() - Qy.clone()) / (Px.clone() - Qx.clone());
    let b = Qy - m.clone() * Qx;
    FF::new(vec![
        Polynomial::new(vec![-b, -m]),
        Polynomial::new(vec![FieldElement::one()]),
    ])
}

fn construct_function<F: IsPrimeField + PartialEq + CurveParamsProvider<F>>(
    Ps: Vec<G1Point<F>>,
) -> FF<F> {
    let mut xs: Vec<(G1Point<F>, FF<F>)> = Ps.iter().map(|P| (P.clone(), line(P.clone(), P.neg()))).collect();

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
            let (A, a_num) = &xs[2 * n];
            let (B, b_num) = &xs[2 * n + 1];
            let num = (a_num.clone() * b_num.clone() * line(A.clone(), B.clone())).reduce();
            let den = (line(A.clone(), A.neg()) * line(B.clone(), B.neg())).to_poly();
            let D = num.div_by_poly(den);
            xs2.push((A.add(B), D));
        }

        if let Some(x0) = x0 {
            xs2.push(x0);
        }

        xs = xs2;
    }

    assert!(xs[0].0.is_infinity());

    xs[0].1.normalize()
}

fn row_function<F: IsPrimeField + PartialEq + CurveParamsProvider<F>>(
    ds: Vec<FieldElement<F>>,
    Ps: Vec<G1Point<F>>,
    Q: G1Point<F>,
) -> (FF<F>, G1Point<F>) {
    let one = FieldElement::<F>::one();
    let minus_one = FieldElement::<F>::one().neg();  //TODO
    let zero = FieldElement::<F>::zero();

    let digits_points: Vec<G1Point<F>> = ds
        .iter()
        .zip(Ps.iter())
        .map(|(&d, P)| {
            if d == one {
                P.clone()
            } else if d == minus_one {
                P.neg()
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

    let Q2 = Q
        .scalar_mul(-3.to_bigint().unwrap())
        .add(&sum_digits_points);

    let Q_neg = Q.neg();

    let mut div_ = vec![Q_neg.clone(), Q_neg.clone(), Q_neg.clone(), Q2.neg()];
    div_.extend(digits_points.iter().cloned());

    let div: Vec<G1Point<F>> = div_.into_iter().filter(|P| !P.is_infinity()).collect();

    let D = construct_function(div);

    (D, Q2)
}

fn ecip_functions<F: IsPrimeField + PartialEq + CurveParamsProvider<F>>(
    Bs: Vec<G1Point<F>>,
    dss: Vec<Vec<FieldElement<F>>>,
) -> (G1Point<F>, Vec<FF<F>>) {
    let mut dss = dss;
    dss.reverse();

    let mut Q = G1Point::new(FieldElement::zero(), FieldElement::zero());
    let mut Ds: Vec<FF<F>> = Vec::new();

    for ds in dss {
        let (D, new_Q) = row_function(ds, Bs.clone(), Q);
        Ds.push(D);
        Q = new_Q;
    }

    Ds.reverse();
    (Q, Ds)
}

fn dlog<F: IsPrimeField + PartialEq + CurveParamsProvider<F>>(d: FF<F>) -> FunctionFelt<F> {
    let mut d = d.reduce();
    assert!(
        d.coeffs.len() == 2,
        "D has {} coeffs: {:?}",
        d.coeffs.len(),
        d.coeffs
    );

    let Dx = FF {
        coeffs: vec![d.coeffs[0].differentiate(), d.coeffs[1].differentiate()],
        y2: d.y2.clone(),
    };

    let Dy = d.coeffs[1].clone();

    let TWO_Y = FF {
        coeffs: vec![Polynomial::zero(), Polynomial::new(vec![FieldElement::from(2)])],
        y2: d.y2.clone(),
    };
    let poly =  Dy.clone() * Polynomial::new(vec![FieldElement::from(F::get_curve_params().a), FieldElement::zero(), FieldElement::from(3)]);
    let U = Dx.clone() * TWO_Y.clone()
        + FF {
            coeffs: vec![
                poly,
                Polynomial::zero()
            ],
            y2: d.y2.clone(),
        };

    let V = TWO_Y * d.clone();

    let Num = (U * V.clone().neg_y()).reduce();
    let Den_FF = (V.clone() * V.neg_y()).reduce();

    assert!(
        Den_FF.coeffs[1].eq(&Polynomial::zero()),
        "Den[1] is not zero: {:?}",
        Den_FF.coeffs[1]
    );

    let Den = Den_FF.coeffs[0].clone();

    let (_, _, gcd_0) = Polynomial::xgcd(&Num.coeffs[0], &Den);
    let (_, _, gcd_1) = Polynomial::xgcd(&Num.coeffs[1], &Den);

    let a_num = Num.coeffs[0].clone().divfloor(&gcd_0);
    let a_den = Den.clone().divfloor(&gcd_0);
    let b_num = Num.coeffs[1].clone().divfloor(&gcd_1);
    let b_den = Den.clone().divfloor(&gcd_1);

    let leading_coeff_inv = Den.leading_coefficient().inv().unwrap();
    FunctionFelt {
        a: RationalFunction::new(
            a_num * Polynomial::new(vec![leading_coeff_inv.clone()]),
            a_den.clone() * Polynomial::new(vec![a_den.clone().leading_coefficient().inv().unwrap()]),
        ),
        b: RationalFunction::new(
            b_num * Polynomial::new(vec![leading_coeff_inv.clone()]),
            b_den.clone() * Polynomial::new(vec![b_den.leading_coefficient().inv().unwrap()]),
        ),
    }
}

#[pymodule]
fn ecip(_py: Python, m: &PyModule) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(zk_ecip_hint, m)?)?;
    Ok(())
}
