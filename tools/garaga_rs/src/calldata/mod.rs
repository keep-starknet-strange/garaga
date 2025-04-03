pub mod full_proof_with_hints {
    pub mod groth16;
    pub mod honk;
    pub mod zk_honk;
}
pub mod mpc_calldata;
pub mod msm_calldata;
pub mod signatures;

use crate::definitions::{get_modulus_from_curve_id, CurveID};
use num_bigint::BigUint;

#[derive(Debug)]
pub struct G1PointBigUint {
    pub x: BigUint,
    pub y: BigUint,
}

pub struct G2PointBigUint {
    pub x0: BigUint,
    pub x1: BigUint,
    pub y0: BigUint,
    pub y1: BigUint,
}

impl G1PointBigUint {
    pub fn neg(&self, curve_id: CurveID) -> Self {
        let modulus = get_modulus_from_curve_id(curve_id);
        G1PointBigUint {
            x: self.x.clone(),
            y: &modulus - &self.y,
        }
    }
    pub fn flatten(&self) -> Vec<BigUint> {
        vec![self.x.clone(), self.y.clone()]
    }
    pub fn from(values: Vec<BigUint>) -> Self {
        G1PointBigUint {
            x: values[0].clone(),
            y: values[1].clone(),
        }
    }
}

impl G2PointBigUint {
    pub fn flatten(&self) -> Vec<BigUint> {
        vec![
            self.x0.clone(),
            self.x1.clone(),
            self.y0.clone(),
            self.y1.clone(),
        ]
    }
    pub fn from(values: Vec<BigUint>) -> Self {
        G2PointBigUint {
            x0: values[0].clone(),
            x1: values[1].clone(),
            y0: values[2].clone(),
            y1: values[3].clone(),
        }
    }
}
