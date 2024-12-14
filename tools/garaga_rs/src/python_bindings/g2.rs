use super::*;

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
        use ark_bn254::{Fq, Fq2, G2Affine};
        let a = G2Affine::new(
            Fq2::new(Fq::from(a_0), Fq::from(a_1)),
            Fq2::new(Fq::from(a_2), Fq::from(a_3)),
        );
        let b = G2Affine::new(
            Fq2::new(Fq::from(b_0), Fq::from(b_1)),
            Fq2::new(Fq::from(b_2), Fq::from(b_3)),
        );
        let c: G2Affine = (a + b).into();
        let py_tuple = PyTuple::new(
            py,
            [
                BigUint::from(c.x.c0.into_bigint()),
                BigUint::from(c.x.c1.into_bigint()),
                BigUint::from(c.y.c0.into_bigint()),
                BigUint::from(c.y.c1.into_bigint()),
            ],
        );
        return Ok(py_tuple?.into_any().into());
    }

    if curve_id == CURVE_BLS12_381 {
        use ark_bls12_381::{Fq, Fq2, G2Affine};
        let a = G2Affine::new(
            Fq2::new(Fq::from(a_0), Fq::from(a_1)),
            Fq2::new(Fq::from(a_2), Fq::from(a_3)),
        );
        let b = G2Affine::new(
            Fq2::new(Fq::from(b_0), Fq::from(b_1)),
            Fq2::new(Fq::from(b_2), Fq::from(b_3)),
        );
        let c: G2Affine = (a + b).into();
        let py_tuple = PyTuple::new(
            py,
            [
                BigUint::from(c.x.c0.into_bigint()),
                BigUint::from(c.x.c1.into_bigint()),
                BigUint::from(c.y.c0.into_bigint()),
                BigUint::from(c.y.c1.into_bigint()),
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
        use ark_bn254::{Fq, Fq2, G2Affine};
        let a = G2Affine::new(
            Fq2::new(Fq::from(a_0), Fq::from(a_1)),
            Fq2::new(Fq::from(a_2), Fq::from(a_3)),
        );
        let c: G2Affine = a.mul_bigint(k.to_u64_digits()).into();
        let py_tuple = PyTuple::new(
            py,
            [
                BigUint::from(c.x.c0.into_bigint()),
                BigUint::from(c.x.c1.into_bigint()),
                BigUint::from(c.y.c0.into_bigint()),
                BigUint::from(c.y.c1.into_bigint()),
            ],
        );
        return Ok(py_tuple?.into());
    }

    if curve_id == CURVE_BLS12_381 {
        use ark_bls12_381::{Fq, Fq2, G2Affine};
        let a = G2Affine::new(
            Fq2::new(Fq::from(a_0), Fq::from(a_1)),
            Fq2::new(Fq::from(a_2), Fq::from(a_3)),
        );
        let c: G2Affine = a.mul_bigint(k.to_u64_digits()).into();
        let py_tuple = PyTuple::new(
            py,
            [
                BigUint::from(c.x.c0.into_bigint()),
                BigUint::from(c.x.c1.into_bigint()),
                BigUint::from(c.y.c0.into_bigint()),
                BigUint::from(c.y.c1.into_bigint()),
            ],
        );
        return Ok(py_tuple?.into());
    }

    panic!("Curve ID {} not supported", curve_id);
}
