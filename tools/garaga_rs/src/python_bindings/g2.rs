use super::*;
use crate::io::{biguint_to_u256, element_from_biguint};
use lambdaworks_math::cyclic_group::IsGroup;
use lambdaworks_math::elliptic_curve::short_weierstrass::point::ShortWeierstrassProjectivePoint;
use lambdaworks_math::elliptic_curve::traits::FromAffine;
#[pyfunction]
pub fn g2_add(
    py: Python,
    curve_id: usize,
    py_tuple_1: &Bound<'_, PyTuple>,
    py_tuple_2: &Bound<'_, PyTuple>,
) -> PyResult<PyObject> {
    let a_0: BigUint = py_tuple_1.get_item(0)?.extract()?;
    let a_1: BigUint = py_tuple_1.get_item(1)?.extract()?;
    let a_2: BigUint = py_tuple_1.get_item(2)?.extract()?;
    let a_3: BigUint = py_tuple_1.get_item(3)?.extract()?;
    let b_0: BigUint = py_tuple_2.get_item(0)?.extract()?;
    let b_1: BigUint = py_tuple_2.get_item(1)?.extract()?;
    let b_2: BigUint = py_tuple_2.get_item(2)?.extract()?;
    let b_3: BigUint = py_tuple_2.get_item(3)?.extract()?;

    if curve_id == CURVE_BN254 {
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::BN254PrimeField;
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::twist::BN254TwistCurve;
        let a = ShortWeierstrassProjectivePoint::<BN254TwistCurve>::from_affine(
            FieldElement::new([
                element_from_biguint::<BN254PrimeField>(&a_0),
                element_from_biguint::<BN254PrimeField>(&a_1),
            ]),
            FieldElement::new([
                element_from_biguint::<BN254PrimeField>(&a_2),
                element_from_biguint::<BN254PrimeField>(&a_3),
            ]),
        )
        .unwrap();
        let b = ShortWeierstrassProjectivePoint::<BN254TwistCurve>::from_affine(
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
        let c = a.operate_with(&b);
        let c_affine = c.to_affine();
        let [[x0, x1], [y0, y1]] = match c_affine.z() == &FieldElement::zero() {
            true => [
                &[FieldElement::zero(), FieldElement::zero()],
                &[FieldElement::zero(), FieldElement::zero()],
            ],
            false => [c_affine.x().value(), c_affine.y().value()],
        };
        let py_tuple = PyTuple::new(
            py,
            [
                element_to_biguint::<BN254PrimeField>(x0),
                element_to_biguint::<BN254PrimeField>(x1),
                element_to_biguint::<BN254PrimeField>(y0),
                element_to_biguint::<BN254PrimeField>(y1),
            ],
        );
        return Ok(py_tuple?.into());
    }

    if curve_id == CURVE_BLS12_381 {
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::twist::BLS12381TwistCurve;
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::BLS12381PrimeField;
        let a = ShortWeierstrassProjectivePoint::<BLS12381TwistCurve>::from_affine(
            FieldElement::new([
                element_from_biguint::<BLS12381PrimeField>(&a_0),
                element_from_biguint::<BLS12381PrimeField>(&a_1),
            ]),
            FieldElement::new([
                element_from_biguint::<BLS12381PrimeField>(&a_2),
                element_from_biguint::<BLS12381PrimeField>(&a_3),
            ]),
        )
        .unwrap();
        let b = ShortWeierstrassProjectivePoint::<BLS12381TwistCurve>::from_affine(
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
        let c = a.operate_with(&b);
        let c_affine = c.to_affine();
        let [[x0, x1], [y0, y1]] = match c_affine.z() == &FieldElement::zero() {
            true => [
                &[FieldElement::zero(), FieldElement::zero()],
                &[FieldElement::zero(), FieldElement::zero()],
            ],
            false => [c_affine.x().value(), c_affine.y().value()],
        };

        println!("x0: {:?}", x0.representative());
        println!("x1: {:?}", x1.representative());
        println!("y0: {:?}", y0.representative());
        println!("y1: {:?}", y1.representative());

        let py_tuple = PyTuple::new(
            py,
            [
                element_to_biguint::<BLS12381PrimeField>(x0),
                element_to_biguint::<BLS12381PrimeField>(x1),
                element_to_biguint::<BLS12381PrimeField>(y0),
                element_to_biguint::<BLS12381PrimeField>(y1),
            ],
        );
        return Ok(py_tuple?.into());
    }

    panic!("Curve ID {} not supported", curve_id);
}

#[pyfunction]
pub fn g2_scalar_mul(
    py: Python,
    curve_id: usize,
    py_tuple_1: &Bound<'_, PyTuple>,
    py_int_2: &Bound<'_, PyInt>,
) -> PyResult<PyObject> {
    let a_0: BigUint = py_tuple_1.get_item(0)?.extract()?;
    let a_1: BigUint = py_tuple_1.get_item(1)?.extract()?;
    let a_2: BigUint = py_tuple_1.get_item(2)?.extract()?;
    let a_3: BigUint = py_tuple_1.get_item(3)?.extract()?;
    let k: BigUint = py_int_2.extract()?;

    if curve_id == CURVE_BN254 {
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::BN254PrimeField;
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::twist::BN254TwistCurve;
        let a = ShortWeierstrassProjectivePoint::<BN254TwistCurve>::from_affine(
            FieldElement::new([
                element_from_biguint::<BN254PrimeField>(&a_0),
                element_from_biguint::<BN254PrimeField>(&a_1),
            ]),
            FieldElement::new([
                element_from_biguint::<BN254PrimeField>(&a_2),
                element_from_biguint::<BN254PrimeField>(&a_3),
            ]),
        )
        .unwrap();

        let c = a.operate_with_self(biguint_to_u256(&k));
        let c_affine = c.to_affine();
        let [[x0, x1], [y0, y1]] = match c_affine.z() == &FieldElement::zero() {
            true => [
                &[FieldElement::zero(), FieldElement::zero()],
                &[FieldElement::zero(), FieldElement::zero()],
            ],
            false => [c_affine.x().value(), c_affine.y().value()],
        };
        let py_tuple = PyTuple::new(
            py,
            [
                element_to_biguint::<BN254PrimeField>(x0),
                element_to_biguint::<BN254PrimeField>(x1),
                element_to_biguint::<BN254PrimeField>(y0),
                element_to_biguint::<BN254PrimeField>(y1),
            ],
        );
        return Ok(py_tuple?.into());
    }

    if curve_id == CURVE_BLS12_381 {
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::BLS12381PrimeField;
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::twist::BLS12381TwistCurve;
        let a = ShortWeierstrassProjectivePoint::<BLS12381TwistCurve>::from_affine(
            FieldElement::new([
                element_from_biguint::<BLS12381PrimeField>(&a_0),
                element_from_biguint::<BLS12381PrimeField>(&a_1),
            ]),
            FieldElement::new([
                element_from_biguint::<BLS12381PrimeField>(&a_2),
                element_from_biguint::<BLS12381PrimeField>(&a_3),
            ]),
        )
        .unwrap();

        let c = a.operate_with_self(biguint_to_u256(&k));

        let c_affine = c.to_affine();
        let [[x0, x1], [y0, y1]] = match c_affine.z() == &FieldElement::zero() {
            true => [
                &[FieldElement::zero(), FieldElement::zero()],
                &[FieldElement::zero(), FieldElement::zero()],
            ],
            false => [c_affine.x().value(), c_affine.y().value()],
        };
        let py_tuple = PyTuple::new(
            py,
            [
                element_to_biguint::<BLS12381PrimeField>(x0),
                element_to_biguint::<BLS12381PrimeField>(x1),
                element_to_biguint::<BLS12381PrimeField>(y0),
                element_to_biguint::<BLS12381PrimeField>(y1),
            ],
        );
        return Ok(py_tuple?.into());
    }

    panic!("Curve ID {} not supported", curve_id);
}
