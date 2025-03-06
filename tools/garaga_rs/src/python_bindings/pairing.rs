use super::*;

use crate::definitions::{BLS12381PrimeField, BN254PrimeField};
use crate::io::{element_from_biguint, element_to_biguint};
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

fn to_bn(v: FieldElement<bn_254::field_extension::Degree12ExtensionField>) -> [BigUint; 12] {
    let [c0, c1] = v.value();
    let [c0b0, c0b1, c0b2] = c0.value();
    let [c1b0, c1b1, c1b2] = c1.value();
    let [c0b0a0, c0b0a1] = c0b0.value();
    let [c0b1a0, c0b1a1] = c0b1.value();
    let [c0b2a0, c0b2a1] = c0b2.value();
    let [c1b0a0, c1b0a1] = c1b0.value();
    let [c1b1a0, c1b1a1] = c1b1.value();
    let [c1b2a0, c1b2a1] = c1b2.value();
    [
        element_to_biguint(&c0b0a0),
        element_to_biguint(&c0b0a1),
        element_to_biguint(&c0b1a0),
        element_to_biguint(&c0b1a1),
        element_to_biguint(&c0b2a0),
        element_to_biguint(&c0b2a1),
        element_to_biguint(&c1b0a0),
        element_to_biguint(&c1b0a1),
        element_to_biguint(&c1b1a0),
        element_to_biguint(&c1b1a1),
        element_to_biguint(&c1b2a0),
        element_to_biguint(&c1b2a1),
    ]
}

fn to_bls(v: FieldElement<bls12_381::field_extension::Degree12ExtensionField>) -> [BigUint; 12] {
    let [c0, c1] = v.value();
    let [c0b0, c0b1, c0b2] = c0.value();
    let [c1b0, c1b1, c1b2] = c1.value();
    let [c0b0a0, c0b0a1] = c0b0.value();
    let [c0b1a0, c0b1a1] = c0b1.value();
    let [c0b2a0, c0b2a1] = c0b2.value();
    let [c1b0a0, c1b0a1] = c1b0.value();
    let [c1b1a0, c1b1a1] = c1b1.value();
    let [c1b2a0, c1b2a1] = c1b2.value();
    [
        element_to_biguint(&c0b0a0),
        element_to_biguint(&c0b0a1),
        element_to_biguint(&c0b1a0),
        element_to_biguint(&c0b1a1),
        element_to_biguint(&c0b2a0),
        element_to_biguint(&c0b2a1),
        element_to_biguint(&c1b0a0),
        element_to_biguint(&c1b0a1),
        element_to_biguint(&c1b1a0),
        element_to_biguint(&c1b1a1),
        element_to_biguint(&c1b2a0),
        element_to_biguint(&c1b2a1),
    ]
}

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

        let cx: FieldElement<
            lambdaworks_math::field::extensions::quadratic::QuadraticExtensionField<
                lambdaworks_math::field::extensions::cubic::CubicExtensionField<
                    bn_254::field_extension::Degree2ExtensionField,
                    bn_254::field_extension::LevelTwoResidue,
                >,
                bn_254::field_extension::LevelThreeResidue,
            >,
        > = match cx == FieldElement::one() {
            true => cx,
            false => {
                let finla_exp_cofactor =
                    U256::from_hex_unchecked("3bec47df15e307c81ea96b02d9d9e38d2e5d4e223ddedaf4");
                cx.pow(finla_exp_cofactor)
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
                result = result * bn_254::pairing::miller_optimized(&p, &q);
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
                result = result * bls12_381::pairing::miller(&q, &p);
            }
        }

        let py_list = PyList::new(py, to_bls(result));
        return Ok(py_list?.into());
    }

    panic!("Curve ID {} not supported", curve_id);
}
