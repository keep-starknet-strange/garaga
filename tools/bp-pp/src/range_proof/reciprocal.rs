#![allow(non_snake_case)]

//! Definition and implementation of the reciprocal range-proof protocol based on arithmetic circuits protocol.

use crate::circuit::{ArithmeticCircuit, PartitionType};
use crate::util::*;
use crate::{circuit, transcript};
use k256::elliptic_curve::ops::Invert;
use k256::elliptic_curve::rand_core::{CryptoRng, RngCore};
use k256::{AffinePoint, ProjectivePoint, Scalar};
use merlin::Transcript;
use serde::{Deserialize, Serialize};
use std::ops::{Add, Mul};

/// Represents reciprocal range-proof protocol witness.
#[derive(Clone, Debug)]
pub struct Witness {
    /// Private value in range [0..dim_np^dim_nd).
    pub x: Scalar,
    /// Blinding value
    pub s: Scalar,
    /// Witness vector: value multiplicities: i-th element corresponds to the 'i-digit' multiplicity
    pub m: Vec<Scalar>,
    /// Witness vector: value digits.
    pub digits: Vec<Scalar>,
}

/// Represents reciprocal range-proof: zk-proof that committed value lies in [0..dim_np^dim_nd) range.
#[derive(Clone, Debug)]
pub struct Proof {
    pub circuit_proof: circuit::Proof,
    pub r: ProjectivePoint,
}

/// Represent serializable version of reciprocal proof (uses AffinePoint instead of ProjectivePoint
/// and serialized version of circuit proof).
#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct SerializableProof {
    pub circuit_proof: circuit::SerializableProof,
    pub r: AffinePoint,
}

impl From<&SerializableProof> for Proof {
    fn from(value: &SerializableProof) -> Self {
        Proof {
            circuit_proof: circuit::Proof::from(&value.circuit_proof),
            r: ProjectivePoint::from(value.r),
        }
    }
}

impl From<&Proof> for SerializableProof {
    fn from(value: &Proof) -> Self {
        SerializableProof {
            circuit_proof: circuit::SerializableProof::from(&value.circuit_proof),
            r: value.r.to_affine(),
        }
    }
}

/// Represents public reciprocal range proof protocol information. Using this information and challenge
/// both prover and verifier can derive the arithmetic circuit.
#[derive(Clone, Debug)]
pub struct ReciprocalRangeProofProtocol {
    /// Count of private proles (size of committed value). Equals to: `dim_nm`. Also, `dim_nv = 1 + dim_nd`.
    pub dim_nd: usize,
    /// Count of public poles (number system base). Equals to: `dim_no`.
    pub dim_np: usize,

    /// Will be used for the value commitment: `commitment = x*g + s*h_vec[0]`
    pub g: ProjectivePoint,

    /// Dimension: `dim_nm`
    pub g_vec: Vec<ProjectivePoint>,
    /// Will be used for the value commitment: `commitment = x*g + s*h_vec[0]`
    /// Dimension: `dim_nv+9`
    pub h_vec: Vec<ProjectivePoint>,

    /// Additional points to be used in WNLA.
    /// Dimension: `2^n - dim_nm`
    pub g_vec_: Vec<ProjectivePoint>,
    /// Dimension: `2^n - (dim_nv+9)`
    pub h_vec_: Vec<ProjectivePoint>,
}

impl ReciprocalRangeProofProtocol {
    /// Creates commitment for the private value and blinding: `commitment = x*g + s*h_vec[0]`
    pub fn commit_value(&self, x: &Scalar, s: &Scalar) -> ProjectivePoint {
        self.g.mul(x).add(&self.h_vec[0].mul(s))
    }

    /// Creates commitment for the reciprocals and blinding: `commitment = s*h_vec[0] + <r, h_vec[9:]>`
    pub fn commit_poles(&self, r: &[Scalar], s: &Scalar) -> ProjectivePoint {
        self.h_vec[0].mul(s).add(&vector_mul(&self.h_vec[9..], r))
    }

    /// Verifies zk-proof that committed value lies in [0..dim_np^dim_nd) range.
    pub fn verify(&self, commitment: &ProjectivePoint, proof: Proof, t: &mut Transcript) -> bool {
        transcript::app_point(b"reciprocal_commitment", commitment, t);
        let e = transcript::get_challenge(b"reciprocal_challenge", t);

        let circuit = self.make_circuit(e);

        let circuit_commitment = commitment.add(&proof.r);

        circuit.verify(&[circuit_commitment], t, proof.circuit_proof)
    }

    /// Creates zk-proof that committed value lies in [0..dim_np^dim_nd) range.
    pub fn prove<R>(
        &self,
        commitment: &ProjectivePoint,
        witness: Witness,
        t: &mut Transcript,
        rng: &mut R,
    ) -> Proof
    where
        R: RngCore + CryptoRng,
    {
        transcript::app_point(b"reciprocal_commitment", commitment, t);
        let e = transcript::get_challenge(b"reciprocal_challenge", t);

        let r = (0..self.dim_nd)
            .map(|i| witness.digits[i].add(&e).invert().unwrap())
            .collect::<Vec<Scalar>>();

        let r_blind = Scalar::generate_biased(rng);
        let r_com = self.commit_poles(&r, &r_blind);

        let mut v = vec![witness.x];
        r.iter().for_each(|r_val| v.push(*r_val));

        let w_l = witness.digits;
        let w_r = r;
        let w_o = witness.m;

        let circuit = self.make_circuit(e);

        let circuit_witness = circuit::Witness {
            v: vec![v],
            s_v: vec![witness.s.add(r_blind)],
            w_l,
            w_r,
            w_o,
        };

        let circuit_commitment = circuit.commit(&circuit_witness.v[0], &circuit_witness.s_v[0]);
        Proof {
            circuit_proof: circuit.prove::<R>(&[circuit_commitment], circuit_witness, t, rng),
            r: r_com,
        }
    }

    /// Creates circuit parameters based on provided challenge. For the same challenge will generate same parameters.
    #[inline(always)]
    pub fn make_circuit(
        &self,
        e: Scalar,
    ) -> ArithmeticCircuit<impl Fn(PartitionType, usize) -> Option<usize> + '_> {
        let dim_nm = self.dim_nd;
        let dim_no = self.dim_np;

        let dim_nv = self.dim_nd + 1;
        let dim_nl = dim_nv;
        let dim_nw = self.dim_nd * 2 + self.dim_np;

        let a_m = vec![Scalar::ONE; dim_nm];

        let mut W_m = vec![vec![Scalar::ZERO; dim_nw]; dim_nm];
        (0..dim_nm).for_each(|i| W_m[i][i + dim_nm] = minus(&e));

        let a_l = vec![Scalar::ZERO; dim_nl];
        let base = Scalar::from(self.dim_np as u32);

        let mut W_l = vec![vec![Scalar::ZERO; dim_nw]; dim_nl];

        // fill for v-part in w vector
        (0..dim_nm).for_each(|i| W_l[0][i] = minus(&pow(&base, i)));

        // fill for r-part in w vector
        (0..dim_nm).for_each(|i| (0..dim_nm).for_each(|j| W_l[i + 1][j + dim_nm] = Scalar::ONE));

        (0..dim_nm).for_each(|i| W_l[i + 1][i + dim_nm] = Scalar::ZERO);

        (0..dim_nm).for_each(|i| {
            (0..dim_no).for_each(|j| {
                W_l[i + 1][j + 2 * dim_nm] =
                    minus(&(e.add(Scalar::from(j as u32)).invert_vartime().unwrap()))
            })
        });

        // partition function -> map all to ll
        let partition = |typ: PartitionType, index: usize| -> Option<usize> {
            if typ == PartitionType::LL && index < self.dim_np {
                Some(index)
            } else {
                None
            }
        };

        ArithmeticCircuit {
            dim_nm,
            dim_no,
            k: 1,
            dim_nl,
            dim_nv,
            dim_nw,
            g: self.g,
            g_vec: self.g_vec.clone(),
            h_vec: self.h_vec.clone(),
            W_m,
            W_l,
            a_m,
            a_l,
            f_l: true,
            f_m: false,
            g_vec_: self.g_vec_.clone(),
            h_vec_: self.h_vec_.clone(),
            partition,
        }
    }
}
