//! Definition and implementation of the Bulletproofs++ weight norm linear argument protocol.
use crate::transcript;
use crate::util::*;
use k256::elliptic_curve::ops::Invert;
use k256::{AffinePoint, ProjectivePoint, Scalar};
use merlin::Transcript;
use serde::{Deserialize, Serialize};
use std::ops::{Add, Mul};

/// Represents public information to be used in weight norm linear argument protocol.
#[derive(Clone, Debug)]
pub struct WeightNormLinearArgument {
    pub g: ProjectivePoint,
    pub g_vec: Vec<ProjectivePoint>,
    pub h_vec: Vec<ProjectivePoint>,
    pub c: Vec<Scalar>,
    pub rho: Scalar,
    pub mu: Scalar,
}

/// Represents weight norm linear argument proof - zk-proof of knowledge of vectors `l`, `n` that
/// satisfies commitment `C = v*g + <h_vec, l> + <g_vec, n>`, where `v = |n|_{mu}^2 + <c, l>`
/// with respect to public `g`, `g_vec`, `h_vec`, `c`
#[derive(Clone, Debug)]
pub struct Proof {
    pub r: Vec<ProjectivePoint>,
    pub x: Vec<ProjectivePoint>,
    pub l: Vec<Scalar>,
    pub n: Vec<Scalar>,
}

/// Represent serializable version of  weight norm linear argument proof (uses AffinePoint instead of ProjectivePoint).
#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct SerializableProof {
    pub r: Vec<AffinePoint>,
    pub x: Vec<AffinePoint>,
    pub l: Vec<Scalar>,
    pub n: Vec<Scalar>,
}

impl From<&SerializableProof> for Proof {
    fn from(value: &SerializableProof) -> Self {
        return Proof {
            r: value
                .r
                .iter()
                .map(ProjectivePoint::from)
                .collect::<Vec<ProjectivePoint>>(),
            x: value
                .x
                .iter()
                .map(ProjectivePoint::from)
                .collect::<Vec<ProjectivePoint>>(),
            l: value.l.clone(),
            n: value.n.clone(),
        };
    }
}

impl From<&Proof> for SerializableProof {
    fn from(value: &Proof) -> Self {
        return SerializableProof {
            r: value
                .r
                .iter()
                .map(|r_val| r_val.to_affine())
                .collect::<Vec<AffinePoint>>(),
            x: value
                .x
                .iter()
                .map(|x_val| x_val.to_affine())
                .collect::<Vec<AffinePoint>>(),
            l: value.l.clone(),
            n: value.n.clone(),
        };
    }
}

impl WeightNormLinearArgument {
    /// Creates weight norm linear argument commitment to vectors `l`, `n`:
    /// `C = v*g + <h_vec, l> + <g_vec, n>`, where `v = |n|_{mu}^2 + <c, l>`
    pub fn commit(&self, l: &[Scalar], n: &[Scalar]) -> ProjectivePoint {
        let v = vector_mul(&self.c, l).add(weight_vector_mul(n, n, &self.mu));
        self.g
            .mul(v)
            .add(vector_mul(&self.h_vec, l))
            .add(vector_mul(&self.g_vec, n))
    }

    /// Verifies weight norm linear argument proof wor the provided `commitment`.
    pub fn verify(&self, commitment: &ProjectivePoint, t: &mut Transcript, proof: Proof) -> bool {
        if proof.x.len() != proof.r.len() {
            return false;
        }

        if proof.x.is_empty() {
            return commitment.eq(&self.commit(&proof.l, &proof.n));
        }

        let (c0, c1) = reduce(&self.c);
        let (g0, g1) = reduce(&self.g_vec);
        let (h0, h1) = reduce(&self.h_vec);

        transcript::app_point(b"wnla_com", commitment, t);
        transcript::app_point(b"wnla_x", proof.x.last().unwrap(), t);
        transcript::app_point(b"wnla_r", proof.r.last().unwrap(), t);
        t.append_u64(b"l.sz", self.h_vec.len() as u64);
        t.append_u64(b"n.sz", self.g_vec.len() as u64);

        let y = transcript::get_challenge(b"wnla_challenge", t);

        let h_ = vector_add(&h0, &vector_mul_on_scalar(&h1, &y));
        let g_ = vector_add(
            &vector_mul_on_scalar(&g0, &self.rho),
            &vector_mul_on_scalar(&g1, &y),
        );
        let c_ = vector_add(&c0, &vector_mul_on_scalar(&c1, &y));

        let com_ = commitment
            .add(&proof.x.last().unwrap().mul(&y))
            .add(&proof.r.last().unwrap().mul(&y.mul(&y).sub(&Scalar::ONE)));

        let wnla = WeightNormLinearArgument {
            g: self.g,
            g_vec: g_,
            h_vec: h_,
            c: c_,
            rho: self.mu,
            mu: self.mu.mul(&self.mu),
        };

        let proof_ = Proof {
            r: proof.r[..proof.r.len() - 1].to_vec(),
            x: proof.x[..proof.x.len() - 1].to_vec(),
            l: proof.l,
            n: proof.n,
        };

        wnla.verify(&com_, t, proof_)
    }

    /// Creates weight norm linear argument proof. `commitment` argument should be a weight norm
    /// linear argument with respect to `l` and `n` private vectors.
    pub fn prove(
        &self,
        commitment: &ProjectivePoint,
        t: &mut Transcript,
        l: Vec<Scalar>,
        n: Vec<Scalar>,
    ) -> Proof {
        if l.len() + n.len() < 6 {
            return Proof {
                r: vec![],
                x: vec![],
                l,
                n,
            };
        }

        let rho_inv = self.rho.invert_vartime().unwrap();

        let (c0, c1) = reduce(&self.c);
        let (l0, l1) = reduce(&l);
        let (n0, n1) = reduce(&n);
        let (g0, g1) = reduce(&self.g_vec);
        let (h0, h1) = reduce(&self.h_vec);

        let mu2 = self.mu.mul(&self.mu);

        let vx = weight_vector_mul(&n0, &n1, &mu2)
            .mul(&rho_inv.mul(&Scalar::from(2u32)))
            .add(&vector_mul(&c0, &l1))
            .add(&vector_mul(&c1, &l0));

        let vr = weight_vector_mul(&n1, &n1, &mu2).add(&vector_mul(&c1, &l1));

        let x = self
            .g
            .mul(vx)
            .add(&vector_mul(&h0, &l1))
            .add(&vector_mul(&h1, &l0))
            .add(&vector_mul(&g0, &vector_mul_on_scalar(&n1, &self.rho)))
            .add(&vector_mul(&g1, &vector_mul_on_scalar(&n0, &rho_inv)));

        let r = self
            .g
            .mul(vr)
            .add(vector_mul(&h1, &l1))
            .add(vector_mul(&g1, &n1));

        transcript::app_point(b"wnla_com", commitment, t);
        transcript::app_point(b"wnla_x", &x, t);
        transcript::app_point(b"wnla_r", &r, t);
        t.append_u64(b"l.sz", l.len() as u64);
        t.append_u64(b"n.sz", n.len() as u64);

        let y = transcript::get_challenge(b"wnla_challenge", t);

        let h_ = vector_add(&h0, &vector_mul_on_scalar(&h1, &y));
        let g_ = vector_add(
            &vector_mul_on_scalar(&g0, &self.rho),
            &vector_mul_on_scalar(&g1, &y),
        );
        let c_ = vector_add(&c0, &vector_mul_on_scalar(&c1, &y));

        let l_ = vector_add(&l0, &vector_mul_on_scalar(&l1, &y));
        let n_ = vector_add(
            &vector_mul_on_scalar(&n0, &rho_inv),
            &vector_mul_on_scalar(&n1, &y),
        );

        let wnla = WeightNormLinearArgument {
            g: self.g,
            g_vec: g_,
            h_vec: h_,
            c: c_,
            rho: self.mu,
            mu: mu2,
        };

        let mut proof = wnla.prove(&wnla.commit(&l_, &n_), t, l_, n_);
        proof.r.push(r);
        proof.x.push(x);
        proof
    }
}
