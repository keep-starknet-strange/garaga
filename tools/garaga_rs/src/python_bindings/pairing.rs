use super::*;

use crate::definitions::{BLS12381PrimeField, BN254PrimeField};
use crate::io::element_from_biguint;
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::curve::BN254Curve;
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::twist::BN254TwistCurve;
use lambdaworks_math::elliptic_curve::short_weierstrass::point::ShortWeierstrassProjectivePoint;
use lambdaworks_math::elliptic_curve::traits::FromAffine;
use lambdaworks_math::elliptic_curve::{
    short_weierstrass::curves::bn_254::pairing::BN254AtePairing, traits::IsPairing,
};

use itertools::Itertools;
use lambdaworks_math::cyclic_group::IsGroup;
use lambdaworks_math::field::element::FieldElement;

use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381;
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254;
use lambdaworks_math::unsigned_integer::element::U256;

use crate::pairing::final_exp_witness::{to_bls, to_bn};

#[pyfunction]
pub fn multi_pairing(
    py: Python,
    curve_id: usize,
    py_list_1: &Bound<'_, PyList>,
) -> PyResult<PyObject> {
    assert!(py_list_1.len() % 6 == 0, "invalid length");

    if curve_id == CURVE_BN254 {
        let pairs = py_list_1
            .iter()
            .chunks(6)
            .into_iter()
            .map(|chunk| {
                let [a_0, a_1, b_0, b_1, b_2, b_3] = chunk
                    .map(|item| item.extract::<BigUint>().unwrap())
                    .collect::<Vec<_>>()
                    .try_into()
                    .unwrap();

                let ap = ShortWeierstrassProjectivePoint::<BN254Curve>::from_affine(
                    element_from_biguint::<BN254PrimeField>(&a_0),
                    element_from_biguint::<BN254PrimeField>(&a_1),
                )
                .unwrap();

                let bp = ShortWeierstrassProjectivePoint::<BN254TwistCurve>::from_affine(
                    FieldElement::new([
                        element_from_biguint::<BN254PrimeField>(&b_0),
                        element_from_biguint::<BN254PrimeField>(&b_1),
                    ]),
                    FieldElement::new([
                        element_from_biguint::<BN254PrimeField>(&b_2),
                        element_from_biguint::<BN254PrimeField>(&b_3),
                    ]),
                )
                .unwrap();

                (ap, bp)
            })
            .collect::<Vec<_>>();

        let cx =
            BN254AtePairing::compute_batch(&pairs.iter().map(|(a, b)| (a, b)).collect::<Vec<_>>())
                .unwrap();

        let cx = match cx == FieldElement::one() {
            true => cx,
            false => {
                let final_exp_cofactor =
                    U256::from_hex_unchecked("3bec47df15e307c81ea96b02d9d9e38d2e5d4e223ddedaf4");
                cx.pow(final_exp_cofactor)
            }
        };

        let py_list = PyList::new(py, to_bn(cx));
        return Ok(py_list?.into());
    }

    if curve_id == CURVE_BLS12_381 {
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::{
            curve::BLS12381Curve, pairing::BLS12381AtePairing, twist::BLS12381TwistCurve,
        };

        let pairs = py_list_1
            .iter()
            .chunks(6)
            .into_iter()
            .map(|chunk| {
                let [a_0, a_1, b_0, b_1, b_2, b_3] = chunk
                    .map(|item| item.extract::<BigUint>().unwrap())
                    .collect::<Vec<_>>()
                    .try_into()
                    .unwrap();

                let ap = ShortWeierstrassProjectivePoint::<BLS12381Curve>::from_affine(
                    element_from_biguint::<BLS12381PrimeField>(&a_0),
                    element_from_biguint::<BLS12381PrimeField>(&a_1),
                )
                .unwrap();

                let bp = ShortWeierstrassProjectivePoint::<BLS12381TwistCurve>::from_affine(
                    FieldElement::new([
                        element_from_biguint::<BLS12381PrimeField>(&b_0),
                        element_from_biguint::<BLS12381PrimeField>(&b_1),
                    ]),
                    FieldElement::new([
                        element_from_biguint::<BLS12381PrimeField>(&b_2),
                        element_from_biguint::<BLS12381PrimeField>(&b_3),
                    ]),
                )
                .unwrap();

                (ap, bp)
            })
            .collect::<Vec<_>>();

        let cx = BLS12381AtePairing::compute_batch(
            &pairs.iter().map(|(a, b)| (a, b)).collect::<Vec<_>>(),
        )
        .unwrap();

        let py_list = PyList::new(py, to_bls(cx));
        return Ok(py_list?.into());
    }

    panic!("Curve ID {} not supported", curve_id);
}

#[pyfunction]
pub fn multi_miller_loop(
    py: Python,
    curve_id: usize,
    py_list_1: &Bound<'_, PyList>,
) -> PyResult<PyObject> {
    assert!(py_list_1.len() % 6 == 0, "invalid length");

    if curve_id == CURVE_BN254 {
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree12ExtensionField;

        let pairs = py_list_1
            .iter()
            .chunks(6)
            .into_iter()
            .map(|chunk| {
                let [a_0, a_1, b_0, b_1, b_2, b_3] = chunk
                    .map(|item| item.extract::<BigUint>().unwrap())
                    .collect::<Vec<_>>()
                    .try_into()
                    .unwrap();

                let ap = ShortWeierstrassProjectivePoint::<BN254Curve>::from_affine(
                    element_from_biguint::<BN254PrimeField>(&a_0),
                    element_from_biguint::<BN254PrimeField>(&a_1),
                )
                .unwrap();

                let bp = ShortWeierstrassProjectivePoint::<BN254TwistCurve>::from_affine(
                    FieldElement::new([
                        element_from_biguint::<BN254PrimeField>(&b_0),
                        element_from_biguint::<BN254PrimeField>(&b_1),
                    ]),
                    FieldElement::new([
                        element_from_biguint::<BN254PrimeField>(&b_2),
                        element_from_biguint::<BN254PrimeField>(&b_3),
                    ]),
                )
                .unwrap();

                (ap, bp)
            })
            .collect::<Vec<_>>();

        let mut result = FieldElement::<Degree12ExtensionField>::one();
        for (p, q) in pairs {
            // We don't need to check if p is in the subgroup because the subgroup oF G1 is G1.
            // See https://hackmd.io/@jpw/bn254#Subgroup-checks.
            if !q.is_in_subgroup() {
                return Err(PyErr::new::<pyo3::exceptions::PyValueError, _>(
                    "Point not in subgroup",
                ));
            }
            if !p.is_neutral_element() && !q.is_neutral_element() {
                let p = p.to_affine();
                let q = q.to_affine();
                result *= bn_254::pairing::miller_optimized(&p, &q);
            }
        }

        let py_list = PyList::new(py, to_bn(result));
        return Ok(py_list?.into());
    }

    if curve_id == CURVE_BLS12_381 {
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree12ExtensionField;
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::{
            curve::BLS12381Curve, twist::BLS12381TwistCurve,
        };

        let pairs = py_list_1
            .iter()
            .chunks(6)
            .into_iter()
            .map(|chunk| {
                let [a_0, a_1, b_0, b_1, b_2, b_3] = chunk
                    .map(|item| item.extract::<BigUint>().unwrap())
                    .collect::<Vec<_>>()
                    .try_into()
                    .unwrap();

                let ap = ShortWeierstrassProjectivePoint::<BLS12381Curve>::from_affine(
                    element_from_biguint::<BLS12381PrimeField>(&a_0),
                    element_from_biguint::<BLS12381PrimeField>(&a_1),
                )
                .unwrap();

                let bp = ShortWeierstrassProjectivePoint::<BLS12381TwistCurve>::from_affine(
                    FieldElement::new([
                        element_from_biguint::<BLS12381PrimeField>(&b_0),
                        element_from_biguint::<BLS12381PrimeField>(&b_1),
                    ]),
                    FieldElement::new([
                        element_from_biguint::<BLS12381PrimeField>(&b_2),
                        element_from_biguint::<BLS12381PrimeField>(&b_3),
                    ]),
                )
                .unwrap();

                (ap, bp)
            })
            .collect::<Vec<_>>();

        let mut result = FieldElement::<Degree12ExtensionField>::one();
        for (p, q) in pairs {
            // We don't need to check if p is in the subgroup because the subgroup oF G1 is G1.
            // See https://hackmd.io/@jpw/bn254#Subgroup-checks.
            if !q.is_in_subgroup() {
                return Err(PyErr::new::<pyo3::exceptions::PyValueError, _>(
                    "Point not in subgroup",
                ));
            }
            if !p.is_neutral_element() && !q.is_neutral_element() {
                let p = p.to_affine();
                let q = q.to_affine();
                result *= bls12_381::pairing::miller(&q, &p);
            }
        }

        let py_list = PyList::new(py, to_bls(result));
        return Ok(py_list?.into());
    }

    panic!("Curve ID {} not supported", curve_id);
}

#[pyfunction]
pub fn final_exp(py: Python, curve_id: usize, py_list_1: &Bound<'_, PyList>) -> PyResult<PyObject> {
    assert!(py_list_1.len() == 12, "invalid length");

    let [f_0, f_1, f_2, f_3, f_4, f_5, f_6, f_7, f_8, f_9, f_10, f_11] =
        py_list_1.extract::<[BigUint; 12]>().unwrap();

    if curve_id == 0 {
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::{Degree12ExtensionField, Degree6ExtensionField, Degree2ExtensionField};

        let f = FieldElement::<Degree12ExtensionField>::new([
            FieldElement::<Degree6ExtensionField>::new([
                FieldElement::<Degree2ExtensionField>::new([
                    element_from_biguint::<BN254PrimeField>(&f_0),
                    element_from_biguint::<BN254PrimeField>(&f_1),
                ]),
                FieldElement::<Degree2ExtensionField>::new([
                    element_from_biguint::<BN254PrimeField>(&f_2),
                    element_from_biguint::<BN254PrimeField>(&f_3),
                ]),
                FieldElement::<Degree2ExtensionField>::new([
                    element_from_biguint::<BN254PrimeField>(&f_4),
                    element_from_biguint::<BN254PrimeField>(&f_5),
                ]),
            ]),
            FieldElement::<Degree6ExtensionField>::new([
                FieldElement::<Degree2ExtensionField>::new([
                    element_from_biguint::<BN254PrimeField>(&f_6),
                    element_from_biguint::<BN254PrimeField>(&f_7),
                ]),
                FieldElement::<Degree2ExtensionField>::new([
                    element_from_biguint::<BN254PrimeField>(&f_8),
                    element_from_biguint::<BN254PrimeField>(&f_9),
                ]),
                FieldElement::<Degree2ExtensionField>::new([
                    element_from_biguint::<BN254PrimeField>(&f_10),
                    element_from_biguint::<BN254PrimeField>(&f_11),
                ]),
            ]),
        ]);

        let final_exp = bn_254::pairing::final_exponentiation_optimized(&f);
        let fx = match final_exp == FieldElement::one() {
            true => final_exp,
            false => {
                let final_exp_cofactor =
                    U256::from_hex_unchecked("3bec47df15e307c81ea96b02d9d9e38d2e5d4e223ddedaf4");
                final_exp.pow(final_exp_cofactor)
            }
        };
        let py_list = PyList::new(py, to_bn(fx));
        return Ok(py_list?.into());
    }

    if curve_id == 1 {
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::{Degree12ExtensionField, Degree6ExtensionField, Degree2ExtensionField};

        let f = FieldElement::<Degree12ExtensionField>::new([
            FieldElement::<Degree6ExtensionField>::new([
                FieldElement::<Degree2ExtensionField>::new([
                    element_from_biguint::<BLS12381PrimeField>(&f_0),
                    element_from_biguint::<BLS12381PrimeField>(&f_1),
                ]),
                FieldElement::<Degree2ExtensionField>::new([
                    element_from_biguint::<BLS12381PrimeField>(&f_2),
                    element_from_biguint::<BLS12381PrimeField>(&f_3),
                ]),
                FieldElement::<Degree2ExtensionField>::new([
                    element_from_biguint::<BLS12381PrimeField>(&f_4),
                    element_from_biguint::<BLS12381PrimeField>(&f_5),
                ]),
            ]),
            FieldElement::<Degree6ExtensionField>::new([
                FieldElement::<Degree2ExtensionField>::new([
                    element_from_biguint::<BLS12381PrimeField>(&f_6),
                    element_from_biguint::<BLS12381PrimeField>(&f_7),
                ]),
                FieldElement::<Degree2ExtensionField>::new([
                    element_from_biguint::<BLS12381PrimeField>(&f_8),
                    element_from_biguint::<BLS12381PrimeField>(&f_9),
                ]),
                FieldElement::<Degree2ExtensionField>::new([
                    element_from_biguint::<BLS12381PrimeField>(&f_10),
                    element_from_biguint::<BLS12381PrimeField>(&f_11),
                ]),
            ]),
        ]);

        let fx = bls12_381::pairing::final_exponentiation(&f);

        let py_list = PyList::new(py, to_bls(fx));
        return Ok(py_list?.into());
    }

    panic!("Curve ID {} not supported", curve_id);
}
