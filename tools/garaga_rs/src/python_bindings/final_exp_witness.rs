use super::*;
use crate::final_exp_witness::bls12_381_final_exp_witness;
use crate::final_exp_witness::bn254_final_exp_witness;

#[pyfunction]
pub fn get_final_exp_witness(
    py: Python,
    curve_id: usize,
    py_list: &Bound<'_, PyList>,
) -> PyResult<PyObject> {
    let f_0: BigUint = py_list.get_item(0)?.extract()?;
    let f_1: BigUint = py_list.get_item(1)?.extract()?;
    let f_2: BigUint = py_list.get_item(2)?.extract()?;
    let f_3: BigUint = py_list.get_item(3)?.extract()?;
    let f_4: BigUint = py_list.get_item(4)?.extract()?;
    let f_5: BigUint = py_list.get_item(5)?.extract()?;
    let f_6: BigUint = py_list.get_item(6)?.extract()?;
    let f_7: BigUint = py_list.get_item(7)?.extract()?;
    let f_8: BigUint = py_list.get_item(8)?.extract()?;
    let f_9: BigUint = py_list.get_item(9)?.extract()?;
    let f_10: BigUint = py_list.get_item(10)?.extract()?;
    let f_11: BigUint = py_list.get_item(11)?.extract()?;

    if curve_id == CURVE_BN254 {
        use ark_bn254::{Fq, Fq12, Fq2, Fq6};
        let f = Fq12::new(
            Fq6::new(
                Fq2::new(Fq::from(f_0), Fq::from(f_1)),
                Fq2::new(Fq::from(f_2), Fq::from(f_3)),
                Fq2::new(Fq::from(f_4), Fq::from(f_5)),
            ),
            Fq6::new(
                Fq2::new(Fq::from(f_6), Fq::from(f_7)),
                Fq2::new(Fq::from(f_8), Fq::from(f_9)),
                Fq2::new(Fq::from(f_10), Fq::from(f_11)),
            ),
        );
        let (c, wi) = bn254_final_exp_witness::get_final_exp_witness(f);
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
        let py_tuple = PyTuple::new_bound(
            py,
            [PyList::new_bound(py, to(c)), PyList::new_bound(py, to(wi))],
        );
        return Ok(py_tuple.into());
    }

    if curve_id == CURVE_BLS12_381 {
        use ark_bls12_381::{Fq, Fq12, Fq2, Fq6};
        let f = Fq12::new(
            Fq6::new(
                Fq2::new(Fq::from(f_0), Fq::from(f_1)),
                Fq2::new(Fq::from(f_2), Fq::from(f_3)),
                Fq2::new(Fq::from(f_4), Fq::from(f_5)),
            ),
            Fq6::new(
                Fq2::new(Fq::from(f_6), Fq::from(f_7)),
                Fq2::new(Fq::from(f_8), Fq::from(f_9)),
                Fq2::new(Fq::from(f_10), Fq::from(f_11)),
            ),
        );
        let (c, wi) = bls12_381_final_exp_witness::get_final_exp_witness(f);
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
        let py_tuple = PyTuple::new_bound(
            py,
            [PyList::new_bound(py, to(c)), PyList::new_bound(py, to(wi))],
        );
        return Ok(py_tuple.into());
    }

    panic!("Curve ID {} not supported", curve_id);
}
