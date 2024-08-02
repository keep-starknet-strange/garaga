use ark_bn254::{Fq, Fq2, Fq6, Fq12};
use ark_ff::Zero;
use std::str::FromStr;

pub fn get_final_exp_witness(_f: Fq12) -> (Fq12, Fq12) {
    let _w27 = get_27th_bn254_root();
    // c, wi = find_c_e12(f, get_27th_bn254_root())
    let c = Fq12::zero();
    let wi = Fq12::zero();
    return (c, wi);
}

fn get_27th_bn254_root() -> Fq12 {
    let c0_b2_a0 = Fq::from_str("8204864362109909869166472767738877274689483185363591877943943203703805152849").unwrap();
    let c0_b2_a1 = Fq::from_str("17912368812864921115467448876996876278487602260484145953989158612875588124088").unwrap();
    Fq12::new(
        Fq6::new(Fq2::zero(), Fq2::zero(), Fq2::new(c0_b2_a0, c0_b2_a1)),
        Fq6::zero(),
    )
}
