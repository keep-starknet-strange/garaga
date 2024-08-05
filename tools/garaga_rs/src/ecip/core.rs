use lambdaworks_math::field::{
    element::FieldElement,
    fields::fft_friendly::stark_252_prime_field::Stark252PrimeField,
};
use crate::ecip::polynomial::Polynomial;

use crate::ecip::ff::FF;
use crate::ecip::curve::CURVES;
use crate::ecip::curve::get_base_field;
use crate::ecip::g1point::G1Point;
use crate::ecip::utils::RationalFunction;
use crate::ecip::utils::{is_quad_residue, sqrt_mod_p, hades_permutation, line_internal};
use alloc::vec::Vec;

use pyo3::{
    types::{PyBytes, PyTuple},
    {prelude::*, wrap_pyfunction},
};

#[pyfunction]
fn zk_ecip_hint(
    py: Python,
    points: Vec<((i64, i64), u8)>,
    dss: Vec<Vec<i32>>,
) -> PyResult<(G1Point<impl IsPrimeField>, FunctionFelt)> {

    let mut bs: Vec<G1Point<impl IsPrimeField>> = Vec::new();

    for ((x, y), curve_id_u8) in points {
        let curve_id: CurveID = curve_id_u8.into(); 
        let g1_point = match curve_id {
            CurveID::BN254 => G1Point::new(
                FieldElement::<BN254PrimeField>::from(x),
                FieldElement::<BN254PrimeField>::from(y),
            ),
            CurveID::BLS12_381 => G1Point::new(
                FieldElement::<BLS12_381PrimeField>::from(x), 
                FieldElement::<BLS12_381PrimeField>::from(y),
            ),
            CurveID::SECP256K1 => G1Point::new(
                FieldElement::<SECP256K1PrimeField>::from(x), 
                FieldElement::<SECP256K1PrimeField>::from(y),
            ),
            CurveID::SECP256R1 => G1Point::new(
                FieldElement::<SECP256R1PrimeField>::from(x),
                FieldElement::<SECP256R1PrimeField>::from(y),
            ),
            CurveID::X25519 => G1Point::new(
                FieldElement::<X25519PrimeField>::from(x), 
                FieldElement::<X25519PrimeField>::from(y),
            ),
        };

        bs.push(g1_point);
    }

    let (q, ds) = ecip_functions(bs, dss);
    let dlogs: Vec<FunctionFelt> = ds.iter().map(|d| dlog(d)).collect();
    let mut sum_dlog = dlogs[0].clone();

    for (i, dlog) in dlogs.iter().enumerate().skip(1) {
        sum_dlog = sum_dlog + dlog * FieldElement::<Stark252PrimeField>::from((-3).pow(i as u32));
    }

    Ok((q, sum_dlog))
}


fn line(P: G1Point, Q: G1Point) -> FF {
    let field = get_base_field(P.curve_id);
    if P.is_infinity() {
        if Q.is_infinity() {
            return FF::new(vec![Polynomial::new(vec![field.one()])], P.curve_id);
        } else {
            let Qx = Q.x.clone();
            return FF::new(vec![Polynomial::new(vec![-Qx, field.one()])], P.curve_id);
        }
    }
    if Q.is_infinity() {
        let Px = P.x.clone();
        return FF::new(vec![Polynomial::new(vec![-Px, field.one()])], P.curve_id);
    }

    let Px = P.x.clone();
    let Py = P.y.clone();

    if P == Q {
        let m = (FieldElement::from(3) * Px.clone() * Px.clone() + FieldElement::from(CURVES[P.curve_id as usize].a)) / (FieldElement::from(2) * Py.clone());
        let b = Py.clone() - m.clone() * Px.clone();
        return FF::new(vec![Polynomial::new(vec![-b, -m]), Polynomial::new(vec![field.one()])], P.curve_id);
    }

    if P == -Q {
        return FF::new(vec![Polynomial::new(vec![-Px, field.one()])], P.curve_id);
    }

    let Qx = Q.x.clone();
    let Qy = Q.y.clone();

    let m = (Py.clone() - Qy.clone()) / (Px.clone() - Qx.clone());
    let b = Qy - m.clone() * Qx;
    FF::new(vec![Polynomial::new(vec![-b, -m]), Polynomial::new(vec![field.one()])], P.curve_id)
}

fn construct_function(Ps: Vec<G1Point>) -> FF {
    let mut xs: Vec<(G1Point, FF)> = Ps.iter()
        .map(|P| (*P, line(*P, -(*P))))
        .collect();

    while xs.len() != 1 {
        let mut xs2: Vec<(G1Point, FF)> = Vec::new();

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
            let num = (a_num.clone() * b_num.clone() * line(*A, *B)).reduce();
            let den = (line(*A, -(*A)) * line(*B, -(*B))).to_poly();
            let D = num.div_by_poly(&den);
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

fn row_function(ds: Vec<i32>, Ps: Vec<G1Point>, Q: G1Point) -> (FF, G1Point) {
    let digits_points: Vec<G1Point> = ds.iter().zip(Ps.iter())
        .map(|(&d, P)| {
            if d == 1 {
                P.clone()
            } else if d == -1 {
                -P.clone()
            } else {
                G1Point { x: FieldElement::zero(), y: FieldElement::zero(), curve_id: P.curve_id }
            }
        })
        .collect();

    let sum_digits_points = digits_points.iter().cloned().reduce(|x, y| x.add(&y)).unwrap();

    let Q2 = Q.scalar_mul(-3).add(&sum_digits_points);

    let Q_neg = -Q.clone();

    let mut div_ = vec![Q_neg.clone(), Q_neg.clone(), Q_neg.clone(), -Q2.clone()];
    div_.extend(digits_points.iter().cloned());

    let div: Vec<G1Point> = div_.into_iter().filter(|P| !P.is_infinity()).collect();

    let D = construct_function(div);
    
    (D, Q2)
}

fn ecip_functions(Bs: Vec<G1Point>, dss: Vec<Vec<i32>>) -> (G1Point, Vec<FF>) {
    let mut dss = dss;
    dss.reverse();

    let curve_id = Bs[0].curve_id;
    let mut Q = G1Point::new(FieldElement::zero(), FieldElement::zero(), curve_id);
    let mut Ds: Vec<FF> = Vec::new();

    for ds in dss {
        let (D, new_Q) = row_function(ds, Bs.clone(), Q);
        Ds.push(D);
        Q = new_Q;
    }

    Ds.reverse();
    (Q, Ds)
}

fn dlog(d: FF) -> FunctionFelt {
    let field = get_base_field(d.curve_id);

    let mut d = d.reduce();
    assert!(d.coeffs.len() == 2, "D has {} coeffs: {:?}", d.coeffs.len(), d.coeffs);
    
    let Dx = FF {
        coeffs: vec![d.coeffs[0].differentiate(), d.coeffs[1].differentiate()],
        curve_id: d.curve_id,
    };
    
    let Dy = d.coeffs[1].clone(); // B(x)

    let TWO_Y = FF {
        coeffs: vec![Polynomial::zero(field.p), Polynomial::new(vec![field(2)])],
        curve_id: d.curve_id,
    };

    let U = Dx.clone() * TWO_Y.clone() + FF {
        coeffs: vec![
            Dy.clone() * Polynomial::new(vec![
                field(CURVES[d.curve_id].a),
                field.zero(),
                field(3),
            ]), // 3x^2 + A
            Polynomial::zero(field.p),
        ],
        curve_id: d.curve_id,
    };

    let V = TWO_Y * d.clone();

    let Num = (U * V.neg_y()).reduce();
    let Den_FF = (V * V.neg_y()).reduce();

    assert!(Den_FF.coeffs[1].is_zero(), "Den[1] is not zero: {:?}", Den_FF.coeffs[1]);

    let Den = Den_FF.coeffs[0].clone();

    let (_, _, gcd_0) = Polynomial::xgcd(&Num.coeffs[0], &Den);
    let (_, _, gcd_1) = Polynomial::xgcd(&Num.coeffs[1], &Den);

    let a_num = Num.coeffs[0].clone() / gcd_0;
    let a_den = Den.clone() / gcd_0;
    let b_num = Num.coeffs[1].clone() / gcd_1;
    let b_den = Den.clone() / gcd_1;

    let leading_coeff_inv = Den.leading_coefficient().inv();

    FunctionFelt {
        a: RationalFunction {
            num: a_num * leading_coeff_inv.clone(),
            den: a_den * a_den.leading_coefficient().inv(),
        },
        b: RationalFunction {
            num: b_num * leading_coeff_inv.clone(),
            den: b_den * b_den.leading_coefficient().inv(),
        },
    }
}

#[pymodule]
fn ecip(_py: Python, m: &PyModule) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(zk_ecip_hint, m)?)?;
    Ok(())
}