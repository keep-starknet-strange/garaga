use crate::ecip::polynomial::Polynomial;
use lambdaworks_math::field::traits::IsPrimeField;
use lambdaworks_math::field::{
    element::FieldElement, fields::fft_friendly::stark_252_prime_field::Stark252PrimeField,
};

use crate::ecip::curve::FromBigUint;
use crate::ecip::curve::{SECP256K1PrimeField, SECP256R1PrimeField, X25519PrimeField};
use crate::ecip::ff::FF;
use crate::ecip::g1point::G1Point;
use crate::ecip::rational_function::FunctionFelt;
use crate::ecip::rational_function::RationalFunction;
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::BLS12381PrimeField;
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::BN254PrimeField;
use std::vec::Vec;

use num_bigint::{BigInt, BigUint, ToBigInt};
use pyo3::{
    types::PyList,
    {prelude::*, wrap_pyfunction},
};

use super::curve::CurveParamsProvider;

#[pyfunction]
fn zk_ecip_hint(
    py: Python,
    py_list_1: &PyList,
    py_list_2: &PyList,
    curve_id: usize,
) -> PyResult<PyObject> {
    let mut points = Vec::new();
    let mut scalars = Vec::new();

    assert!(py_list_1.len() == py_list_2.len());

    for i in (0..py_list_1.len()).step_by(2) {
        let x: BigUint = py_list_1[i + 0].extract()?;
        let y: BigUint = py_list_1[i + 1].extract()?;
        points.push(G1Point {
            x: FromBigUint::from_biguint(curve_id, x),
            y: return_field_element_from_BigUint_and_curve_id(curve_id, y),
        });
    }

    let (q, ds) = ecip_functions(bs, dss);
    let dlogs = ds.iter().map(|d| dlog(*d)).collect();
    let mut sum_dlog = dlogs[0].clone();

    for (i, dlog) in dlogs.iter().enumerate().skip(1) {
        sum_dlog = sum_dlog + dlog * FieldElement::<Stark252PrimeField>::from((-3).pow(i as u32));
    }

    Ok((q, sum_dlog))
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
    let Py = P.y.clone();

    if P == Q {
        let m = (FieldElement::from(3) * Px.clone() * Px.clone()
            + FieldElement::from(F::get_curve_params().a))
            / (FieldElement::from(2) * Py.clone());
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
    let mut xs: Vec<(G1Point<F>, FF<F>)> = Ps.iter().map(|P| (*P, line(*P, P.neg()))).collect();

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
    ds: Vec<i32>,
    Ps: Vec<G1Point<F>>,
    Q: G1Point<F>,
) -> (FF<F>, G1Point<F>) {
    let digits_points: Vec<G1Point<F>> = ds
        .iter()
        .zip(Ps.iter())
        .map(|(&d, P)| {
            if d == 1 {
                P.clone()
            } else if d == -1 {
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
    dss: Vec<Vec<i32>>,
) -> (G1Point<F>, Vec<FF<F>>) {
    let mut dss = dss;
    dss.reverse();

    let mut Q = G1Point::new(FieldElement::zero(), FieldElement::zero());
    let mut Ds: Vec<FF<F>> = Vec::new();

    for ds in dss {
        let (D, new_Q) = row_function(ds, Bs, Q);
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
        y2: d.y2,
    };

    let Dy = d.coeffs[1].clone();

    let TWO_Y = FF {
        coeffs: vec![Polynomial::zero(), Polynomial::new(vec![2])],
        y2: d.y2,
    };

    let U = Dx.clone() * TWO_Y.clone()
        + FF {
            coeffs: vec![
                Dy.clone()
                    * Polynomial::new(vec![field(CURVES[d.curve_id].a), field.zero(), field(3)]), // 3x^2 + A
                Polynomial::zero(),
            ],
            y2: d.y2,
        };

    let V = TWO_Y * d.clone();

    let Num = (U * V.neg_y()).reduce();
    let Den_FF = (V * V.neg_y()).reduce();

    assert!(
        Den_FF.coeffs[1].eq(&Polynomial::zero()),
        "Den[1] is not zero: {:?}",
        Den_FF.coeffs[1]
    );

    let Den = Den_FF.coeffs[0].clone();

    let (_, _, gcd_0) = Polynomial::xgcd(&Num.coeffs[0], &Den);
    let (_, _, gcd_1) = Polynomial::xgcd(&Num.coeffs[1], &Den);

    let a_num = Num.coeffs[0].clone() / gcd_0;
    let a_den = Den.clone() / gcd_0;
    let b_num = Num.coeffs[1].clone() / gcd_1;
    let b_den = Den.clone() / gcd_1;

    let leading_coeff_inv = Den.leading_coefficient().inv();

    FunctionFelt {
        a: RationalFunction::new(
            a_num * leading_coeff_inv,
            a_den * a_den.leading_coefficient().inv(),
        ),
        b: RationalFunction::new(
            b_num * leading_coeff_inv,
            b_den * b_den.leading_coefficient().inv(),
        ),
    }
}

#[pymodule]
fn ecip(_py: Python, m: &PyModule) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(zk_ecip_hint, m)?)?;
    Ok(())
}
