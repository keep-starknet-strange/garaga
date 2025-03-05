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
use lambdaworks_math::field::element::FieldElement;

#[pyfunction]
pub fn multi_pairing(
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

        let cx =
            BN254AtePairing::compute_batch(&pairs.iter().map(|(a, b)| (a, b)).collect::<Vec<_>>())
                .unwrap();

        fn to(v: FieldElement<Degree12ExtensionField>) -> [BigUint; 12] {
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
        let py_list = PyList::new(py, to(cx));
        return Ok(py_list?.into());
    }

    if curve_id == CURVE_BLS12_381 {
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::{
            curve::BLS12381Curve, field_extension::Degree12ExtensionField,
            pairing::BLS12381AtePairing, twist::BLS12381TwistCurve,
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

        fn to(v: FieldElement<Degree12ExtensionField>) -> [BigUint; 12] {
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
        let py_list = PyList::new(py, to(cx));
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
        use ark_bn254::{Bn254, Fq, Fq12, Fq2, G1Affine, G2Affine};
        let mut a_list = Vec::new();
        let mut b_list = Vec::new();
        for i in (0..py_list_1.len()).step_by(6) {
            let a_0: BigUint = py_list_1.get_item(i)?.extract()?;
            let a_1: BigUint = py_list_1.get_item(i + 1)?.extract()?;
            let b_0: BigUint = py_list_1.get_item(i + 2)?.extract()?;
            let b_1: BigUint = py_list_1.get_item(i + 3)?.extract()?;
            let b_2: BigUint = py_list_1.get_item(i + 4)?.extract()?;
            let b_3: BigUint = py_list_1.get_item(i + 5)?.extract()?;
            let a = G1Affine::new(Fq::from(a_0), Fq::from(a_1));
            let b = G2Affine::new(
                Fq2::new(Fq::from(b_0), Fq::from(b_1)),
                Fq2::new(Fq::from(b_2), Fq::from(b_3)),
            );
            a_list.push(a);
            b_list.push(b);
        }
        let c = Bn254::multi_miller_loop(a_list, b_list);
        fn to(v: Fq12) -> [BigUint; 12] {
            [
                BigUint::from(v.c0.c0.c0.into_bigint()),
                BigUint::from(v.c0.c0.c1.into_bigint()),
                BigUint::from(v.c0.c1.c0.into_bigint()),
                BigUint::from(v.c0.c1.c1.into_bigint()),
                BigUint::from(v.c0.c2.c0.into_bigint()),
                BigUint::from(v.c0.c2.c1.into_bigint()),
                BigUint::from(v.c1.c0.c0.into_bigint()),
                BigUint::from(v.c1.c0.c1.into_bigint()),
                BigUint::from(v.c1.c1.c0.into_bigint()),
                BigUint::from(v.c1.c1.c1.into_bigint()),
                BigUint::from(v.c1.c2.c0.into_bigint()),
                BigUint::from(v.c1.c2.c1.into_bigint()),
            ]
        }
        let py_list = PyList::new(py, to(c.0));
        return Ok(py_list?.into());
    }

    if curve_id == CURVE_BLS12_381 {
        use ark_bls12_381::{Bls12_381, Fq, Fq12, Fq2, G1Affine, G2Affine};
        let mut a_list = Vec::new();
        let mut b_list = Vec::new();
        for i in (0..py_list_1.len()).step_by(6) {
            let a_0: BigUint = py_list_1.get_item(i)?.extract()?;
            let a_1: BigUint = py_list_1.get_item(i + 1)?.extract()?;
            let b_0: BigUint = py_list_1.get_item(i + 2)?.extract()?;
            let b_1: BigUint = py_list_1.get_item(i + 3)?.extract()?;
            let b_2: BigUint = py_list_1.get_item(i + 4)?.extract()?;
            let b_3: BigUint = py_list_1.get_item(i + 5)?.extract()?;
            let a = G1Affine::new(Fq::from(a_0), Fq::from(a_1));
            let b = G2Affine::new(
                Fq2::new(Fq::from(b_0), Fq::from(b_1)),
                Fq2::new(Fq::from(b_2), Fq::from(b_3)),
            );
            a_list.push(a);
            b_list.push(b);
        }
        let c = Bls12_381::multi_miller_loop(a_list, b_list);
        fn to(v: Fq12) -> [BigUint; 12] {
            [
                BigUint::from(v.c0.c0.c0.into_bigint()),
                BigUint::from(v.c0.c0.c1.into_bigint()),
                BigUint::from(v.c0.c1.c0.into_bigint()),
                BigUint::from(v.c0.c1.c1.into_bigint()),
                BigUint::from(v.c0.c2.c0.into_bigint()),
                BigUint::from(v.c0.c2.c1.into_bigint()),
                BigUint::from(v.c1.c0.c0.into_bigint()),
                BigUint::from(v.c1.c0.c1.into_bigint()),
                BigUint::from(v.c1.c1.c0.into_bigint()),
                BigUint::from(v.c1.c1.c1.into_bigint()),
                BigUint::from(v.c1.c2.c0.into_bigint()),
                BigUint::from(v.c1.c2.c1.into_bigint()),
            ]
        }
        let py_list = PyList::new(py, to(c.0));
        return Ok(py_list?.into());
    }

    panic!("Curve ID {} not supported", curve_id);
}
