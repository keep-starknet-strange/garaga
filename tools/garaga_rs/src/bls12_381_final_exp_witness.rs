use ark_bls12_381::Fq12;
use ark_ff::Zero;

pub fn get_final_exp_witness(_f: Fq12) -> (Fq12, Fq12) {
    // c, wi = get_root_and_scaling_factor_bls(f)
    let c = Fq12::zero();
    let wi = Fq12::zero();
    return (c, wi);
}
