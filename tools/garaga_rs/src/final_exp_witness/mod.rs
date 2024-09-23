pub mod bls12_381_final_exp_witness;
pub mod bn254_final_exp_witness;

use ark_ff::PrimeField;
use num_bigint::BigUint;

pub fn get_final_exp_witness(curve_id: usize, f: [BigUint; 12]) -> ([BigUint; 12], [BigUint; 12]) {
    let [f_0, f_1, f_2, f_3, f_4, f_5, f_6, f_7, f_8, f_9, f_10, f_11] = f;

    if curve_id == 0 {
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
        return (to(c), to(wi));
    }

    if curve_id == 1 {
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
        return (to(c), to(wi));
    }

    panic!("Curve ID {} not supported", curve_id);
}
