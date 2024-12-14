use super::*;

#[pyfunction]
pub fn multi_pairing(
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
        let c = Bn254::multi_pairing(a_list, b_list);
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
        let c = Bls12_381::multi_pairing(a_list, b_list);
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
