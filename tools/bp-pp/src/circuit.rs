#![allow(non_snake_case)]
//! Definition and implementation of the Bulletproofs++ arithmetic circuit protocol.

use crate::util::*;
use crate::wnla::WeightNormLinearArgument;
use crate::{transcript, wnla};
use k256::elliptic_curve::ops::Invert;
use k256::elliptic_curve::rand_core::{CryptoRng, RngCore};
use k256::{AffinePoint, ProjectivePoint, Scalar};
use merlin::Transcript;
use serde::{Deserialize, Serialize};
use std::ops::{Add, Mul, Sub};

#[derive(Clone, Debug, Copy, PartialEq)]
pub enum PartitionType {
    LO,
    LL,
    LR,
    NO,
}

/// Represents arithmetic circuit zero-knowledge proof.
#[derive(Clone, Debug)]
pub struct Proof {
    pub c_l: ProjectivePoint,
    pub c_r: ProjectivePoint,
    pub c_o: ProjectivePoint,
    pub c_s: ProjectivePoint,
    pub r: Vec<ProjectivePoint>,
    pub x: Vec<ProjectivePoint>,
    pub l: Vec<Scalar>,
    pub n: Vec<Scalar>,
}

/// Represent serializable version of arithmetic circuit proof (uses AffinePoint instead of ProjectivePoint).
#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct SerializableProof {
    pub c_l: AffinePoint,
    pub c_r: AffinePoint,
    pub c_o: AffinePoint,
    pub c_s: AffinePoint,
    pub r: Vec<AffinePoint>,
    pub x: Vec<AffinePoint>,
    pub l: Vec<Scalar>,
    pub n: Vec<Scalar>,
}

impl From<&SerializableProof> for Proof {
    fn from(value: &SerializableProof) -> Self {
        return Proof {
            c_l: ProjectivePoint::from(&value.c_l),
            c_r: ProjectivePoint::from(&value.c_r),
            c_o: ProjectivePoint::from(&value.c_o),
            c_s: ProjectivePoint::from(&value.c_s),
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
            c_l: value.c_l.to_affine(),
            c_r: value.c_r.to_affine(),
            c_o: value.c_o.to_affine(),
            c_s: value.c_s.to_affine(),
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

/// Represents arithmetic circuit witness.
#[derive(Clone, Debug)]
pub struct Witness {
    /// Dimension: `k*dim_nv`
    pub v: Vec<Vec<Scalar>>,
    /// Dimension: `k`
    pub s_v: Vec<Scalar>,
    /// Dimension: `dim_nm`
    pub w_l: Vec<Scalar>,
    /// Dimension: `dim_nm`
    pub w_r: Vec<Scalar>,
    /// Dimension: `dim_no`
    pub w_o: Vec<Scalar>,
}

/// Represents arithmetic circuit.
/// P - partition function.
pub struct ArithmeticCircuit<P>
where
    P: Fn(PartitionType, usize) -> Option<usize>,
{
    pub dim_nm: usize,
    pub dim_no: usize,
    pub k: usize,

    /// Equals to: `dim_nv * k`
    pub dim_nl: usize,
    /// Count of witness vectors v.
    pub dim_nv: usize,
    ///  Equals to: `dim_nm + dim_nm + n_o`
    pub dim_nw: usize,

    pub g: ProjectivePoint,

    /// Dimension: `dim_nm`
    pub g_vec: Vec<ProjectivePoint>,
    /// Dimension: `dim_nv+9`
    pub h_vec: Vec<ProjectivePoint>,

    /// Dimension: `dim_nm * dim_nw`
    pub W_m: Vec<Vec<Scalar>>,
    /// Dimension: `dim_nl * dim_nw`
    pub W_l: Vec<Vec<Scalar>>,

    /// Dimension: `dim_nm`
    pub a_m: Vec<Scalar>,
    /// Dimension: `dim_nl`
    pub a_l: Vec<Scalar>,

    pub f_l: bool,
    pub f_m: bool,

    /// Vector of points that will be used in WNLA protocol.
    /// Dimension: `2^n - dim_nm`
    pub g_vec_: Vec<ProjectivePoint>,
    /// Vector of points that will be used in WNLA protocol.
    /// Dimension: `2^n - (dim_nv+9)`
    pub h_vec_: Vec<ProjectivePoint>,

    /// Partition function to map `w_o` and corresponding parts of `W_m` and `W_l`
    pub partition: P,
}

impl<P> ArithmeticCircuit<P>
where
    P: Fn(PartitionType, usize) -> Option<usize>,
{
    /// Creates commitment to the arithmetic circuit witness.
    pub fn commit(&self, v: &[Scalar], s: &Scalar) -> ProjectivePoint {
        self.g
            .mul(&v[0])
            .add(&self.h_vec[0].mul(s))
            .add(&vector_mul(&self.h_vec[9..], &v[1..]))
    }

    /// Verifies arithmetic circuit proof with respect to the `v` commitments vector.
    pub fn verify(&self, v: &[ProjectivePoint], t: &mut Transcript, proof: Proof) -> bool {
        transcript::app_point(b"commitment_cl", &proof.c_l, t);
        transcript::app_point(b"commitment_cr", &proof.c_r, t);
        transcript::app_point(b"commitment_co", &proof.c_o, t);

        v.iter()
            .for_each(|v_val| transcript::app_point(b"commitment_v", v_val, t));

        let rho = transcript::get_challenge(b"circuit_rho", t);
        let lambda = transcript::get_challenge(b"circuit_lambda", t);
        let beta = transcript::get_challenge(b"circuit_beta", t);
        let delta = transcript::get_challenge(b"circuit_delta", t);

        let mu = rho.mul(rho);

        let lambda_vec = self.collect_lambda(&lambda, &mu);
        let mu_vec = vector_mul_on_scalar(&e(&mu, self.dim_nm), &mu);

        let (c_nL, c_nR, c_nO, c_lL, c_lR, c_lO) = self.collect_c(&lambda_vec, &mu_vec, &mu);

        let two = Scalar::from(2u32);

        let mut v_ = ProjectivePoint::IDENTITY;
        (0..self.k).for_each(|i| v_ = v_.add(v[i].mul(self.linear_comb_coef(i, &lambda, &mu))));
        v_ = v_.mul(&two);

        transcript::app_point(b"commitment_cs", &proof.c_s, t);

        let tau = transcript::get_challenge(b"circuit_tau", t);
        let tau_inv = tau.invert_vartime().unwrap();
        let tau2 = tau.mul(&tau);
        let tau3 = tau2.mul(&tau);

        let delta_inv = delta.invert_vartime().unwrap();

        let mut pn_tau = vector_mul_on_scalar(&c_nO, &tau3.mul(&delta_inv));
        pn_tau = vector_sub(&pn_tau, &vector_mul_on_scalar(&c_nL, &tau2));
        pn_tau = vector_add(&pn_tau, &vector_mul_on_scalar(&c_nR, &tau));

        let ps_tau = weight_vector_mul(&pn_tau, &pn_tau, &mu)
            .add(&vector_mul(&lambda_vec, &self.a_l).mul(&tau3).mul(&two))
            .sub(&vector_mul(&mu_vec, &self.a_m).mul(&tau3).mul(&two));

        let pt = self.g.mul(ps_tau).add(vector_mul(&self.g_vec, &pn_tau));

        let cr_tau = vec![
            Scalar::ONE,
            tau_inv.mul(beta),
            tau.mul(beta),
            tau2.mul(beta),
            tau3.mul(beta),
            tau.mul(tau3).mul(beta),
            tau2.mul(tau3).mul(beta),
            tau3.mul(tau3).mul(beta),
            tau3.mul(tau3).mul(tau).mul(beta),
        ];

        let c_l0 = self.collect_cl0(&lambda, &mu);

        let mut cl_tau = vector_mul_on_scalar(&c_lO, &tau3.mul(&delta_inv));
        cl_tau = vector_sub(&cl_tau, &vector_mul_on_scalar(&c_lL, &tau2));
        cl_tau = vector_add(&cl_tau, &vector_mul_on_scalar(&c_lR, &tau));
        cl_tau = vector_mul_on_scalar(&cl_tau, &two);
        cl_tau = vector_sub(&cl_tau, &c_l0);

        let mut c = [&cr_tau[..], &cl_tau[..]].concat();

        let commitment = pt
            .add(&proof.c_s.mul(&tau_inv))
            .sub(&proof.c_o.mul(&delta))
            .add(&proof.c_l.mul(&tau))
            .sub(&proof.c_r.mul(&tau2))
            .add(&v_.mul(&tau3));

        while c.len() < self.h_vec.len() + self.h_vec_.len() {
            c.push(Scalar::ZERO);
        }

        let wnla = WeightNormLinearArgument {
            g: self.g,
            g_vec: [&self.g_vec[..], &self.g_vec_[..]].concat(),
            h_vec: [&self.h_vec[..], &self.h_vec_[..]].concat(),
            c,
            rho,
            mu,
        };

        wnla.verify(
            &commitment,
            t,
            wnla::Proof {
                r: proof.r,
                x: proof.x,
                l: proof.l,
                n: proof.n,
            },
        )
    }

    /// Creates arithmetic circuit proof for the corresponding witness. Also, `v` commitments vector
    /// should correspond input witness in `witness` argument.
    pub fn prove<R>(
        &self,
        v: &[ProjectivePoint],
        witness: Witness,
        t: &mut Transcript,
        rng: &mut R,
    ) -> Proof
    where
        R: RngCore + CryptoRng,
    {
        let ro = vec![
            Scalar::generate_biased(rng),
            Scalar::generate_biased(rng),
            Scalar::generate_biased(rng),
            Scalar::generate_biased(rng),
            Scalar::ZERO,
            Scalar::generate_biased(rng),
            Scalar::generate_biased(rng),
            Scalar::generate_biased(rng),
            Scalar::ZERO,
        ];

        let rl = vec![
            Scalar::generate_biased(rng),
            Scalar::generate_biased(rng),
            Scalar::generate_biased(rng),
            Scalar::ZERO,
            Scalar::generate_biased(rng),
            Scalar::generate_biased(rng),
            Scalar::generate_biased(rng),
            Scalar::ZERO,
            Scalar::ZERO,
        ];

        let rr = vec![
            Scalar::generate_biased(rng),
            Scalar::generate_biased(rng),
            Scalar::ZERO,
            Scalar::generate_biased(rng),
            Scalar::generate_biased(rng),
            Scalar::generate_biased(rng),
            Scalar::ZERO,
            Scalar::ZERO,
            Scalar::ZERO,
        ];

        let nl = witness.w_l;
        let nr = witness.w_r;

        let no = (0..self.dim_nm)
            .map(|j| {
                if let Some(i) = (self.partition)(PartitionType::NO, j) {
                    witness.w_o[i]
                } else {
                    Scalar::ZERO
                }
            })
            .collect::<Vec<Scalar>>();

        let lo = (0..self.dim_nv)
            .map(|j| {
                if let Some(i) = (self.partition)(PartitionType::LO, j) {
                    witness.w_o[i]
                } else {
                    Scalar::ZERO
                }
            })
            .collect::<Vec<Scalar>>();

        let ll = (0..self.dim_nv)
            .map(|j| {
                if let Some(i) = (self.partition)(PartitionType::LL, j) {
                    witness.w_o[i]
                } else {
                    Scalar::ZERO
                }
            })
            .collect::<Vec<Scalar>>();

        let lr = (0..self.dim_nv)
            .map(|j| {
                if let Some(i) = (self.partition)(PartitionType::LR, j) {
                    witness.w_o[i]
                } else {
                    Scalar::ZERO
                }
            })
            .collect::<Vec<Scalar>>();

        let co =
            vector_mul(&self.h_vec, &[&ro[..], &lo[..]].concat()).add(vector_mul(&self.g_vec, &no));

        let cl =
            vector_mul(&self.h_vec, &[&rl[..], &ll[..]].concat()).add(vector_mul(&self.g_vec, &nl));

        let cr =
            vector_mul(&self.h_vec, &[&rr[..], &lr[..]].concat()).add(vector_mul(&self.g_vec, &nr));

        transcript::app_point(b"commitment_cl", &cl, t);
        transcript::app_point(b"commitment_cr", &cr, t);
        transcript::app_point(b"commitment_co", &co, t);
        v.iter()
            .for_each(|v_val| transcript::app_point(b"commitment_v", v_val, t));

        let rho = transcript::get_challenge(b"circuit_rho", t);
        let lambda = transcript::get_challenge(b"circuit_lambda", t);
        let beta = transcript::get_challenge(b"circuit_beta", t);
        let delta = transcript::get_challenge(b"circuit_delta", t);

        let mu = rho.mul(rho);

        let lambda_vec = self.collect_lambda(&lambda, &mu);
        let mu_vec = vector_mul_on_scalar(&e(&mu, self.dim_nm), &mu);

        let (c_nL, c_nR, c_nO, c_lL, c_lR, c_lO) = self.collect_c(&lambda_vec, &mu_vec, &mu);

        let ls = (0..self.dim_nv)
            .map(|_| Scalar::generate_biased(rng))
            .collect::<Vec<Scalar>>();
        let ns = (0..self.dim_nm)
            .map(|_| Scalar::generate_biased(rng))
            .collect::<Vec<Scalar>>();

        let two = Scalar::from(2u32);

        let mut v_0 = Scalar::ZERO;
        (0..self.k).for_each(|i| {
            v_0 = v_0.add(witness.v[i][0].mul(self.linear_comb_coef(i, &lambda, &mu)))
        });
        v_0 = v_0.mul(&two);

        let mut rv = vec![Scalar::ZERO; 9];
        (0..self.k).for_each(|i| {
            rv[0] = rv[0].add(witness.s_v[i].mul(self.linear_comb_coef(i, &lambda, &mu)))
        });
        rv[0] = rv[0].mul(&two);

        let mut v_1 = vec![Scalar::ZERO; self.dim_nv - 1];
        (0..self.k).for_each(|i| {
            v_1 = vector_add(
                &v_1,
                &vector_mul_on_scalar(&witness.v[i][1..], &self.linear_comb_coef(i, &lambda, &mu)),
            )
        });
        v_1 = vector_mul_on_scalar(&v_1, &two);

        let c_l0 = self.collect_cl0(&lambda, &mu);

        // [-2 -1 0 1 2 4 5 6] -> f(tau) coefficients vector
        let mut f_ = vec![Scalar::ZERO; 8];

        let delta2 = delta.mul(&delta);
        let delta_inv = delta.invert_vartime().unwrap();

        // -2
        f_[0] = minus(&weight_vector_mul(&ns, &ns, &mu));

        // -1
        f_[1] = vector_mul(&c_l0, &ls).add(delta.mul(&two).mul(&weight_vector_mul(&ns, &no, &mu)));

        // 0
        f_[2] = minus(&vector_mul(&c_lR, &ls).mul(&two))
            .sub(&vector_mul(&c_l0, &lo).mul(&delta))
            .sub(&weight_vector_mul(&ns, &vector_add(&nl, &c_nR), &mu).mul(&two))
            .sub(&weight_vector_mul(&no, &no, &mu).mul(&delta2));

        //1
        f_[3] = vector_mul(&c_lL, &ls)
            .mul(&two)
            .add(&vector_mul(&c_lR, &lo).mul(&delta).mul(&two))
            .add(&vector_mul(&c_l0, &ll))
            .add(&weight_vector_mul(&ns, &vector_add(&nr, &c_nL), &mu).mul(&two))
            .add(
                &weight_vector_mul(&no, &vector_add(&nl, &c_nR), &mu)
                    .mul(&two)
                    .mul(&delta),
            );

        // 2
        f_[4] = weight_vector_mul(&c_nR, &c_nR, &mu)
            .sub(&vector_mul(&c_lO, &ls).mul(&delta_inv).mul(&two))
            .sub(&vector_mul(&c_lL, &lo).mul(&delta).mul(&two))
            .sub(&vector_mul(&c_lR, &ll).mul(&two))
            .sub(&vector_mul(&c_l0, &lr))
            .sub(&weight_vector_mul(&ns, &c_nO, &mu).mul(&delta_inv).mul(&two))
            .sub(
                &weight_vector_mul(&no, &vector_add(&nr, &c_nL), &mu)
                    .mul(&delta)
                    .mul(&two),
            )
            .sub(&weight_vector_mul(
                &vector_add(&nl, &c_nR),
                &vector_add(&nl, &c_nR),
                &mu,
            ));

        // 3 should be zero

        // 4
        f_[5] = weight_vector_mul(&c_nO, &c_nR, &mu)
            .mul(&delta_inv)
            .mul(&two)
            .add(&weight_vector_mul(&c_nL, &c_nL, &mu))
            .sub(&vector_mul(&c_lO, &ll).mul(&delta_inv).mul(&two))
            .sub(&vector_mul(&c_lL, &lr).mul(&two))
            .sub(&vector_mul(&c_lR, &v_1).mul(&two))
            .sub(
                &weight_vector_mul(&vector_add(&nl, &c_nR), &c_nO, &mu)
                    .mul(&delta_inv)
                    .mul(&two),
            )
            .sub(&weight_vector_mul(
                &vector_add(&nr, &c_nL),
                &vector_add(&nr, &c_nL),
                &mu,
            ));

        // 5
        f_[6] = minus(
            &weight_vector_mul(&c_nO, &c_nL, &mu)
                .mul(&delta_inv)
                .mul(&two),
        )
        .add(&vector_mul(&c_nO, &lr).mul(&delta_inv).mul(&two))
        .add(&vector_mul(&c_lL, &v_1).mul(&two))
        .add(
            &weight_vector_mul(&vector_add(&nr, &c_nL), &c_nO, &mu)
                .mul(&delta_inv)
                .mul(&two),
        );

        // 6
        f_[7] = minus(&vector_mul(&c_lO, &v_1).mul(&delta_inv).mul(&two));

        let beta_inv = beta.invert_vartime().unwrap();

        let rs = vec![
            f_[1].add(ro[1].mul(&delta).mul(&beta)),
            f_[0].mul(&beta_inv),
            ro[0].mul(&delta).add(&f_[2]).mul(&beta_inv).sub(&rl[1]),
            f_[3]
                .sub(&rl[0])
                .mul(&beta_inv)
                .add(&ro[2].mul(&delta).add(rr[1])),
            f_[4]
                .add(&rr[0])
                .mul(&beta_inv)
                .add(&ro[3].mul(&delta).sub(rl[2])),
            minus(&rv[0].mul(&beta_inv)),
            f_[5]
                .mul(&beta_inv)
                .add(&ro[5].mul(&delta))
                .add(&rr[3])
                .sub(&rl[4]),
            f_[6]
                .mul(&beta_inv)
                .add(&rr[4])
                .add(&ro[6].mul(&delta))
                .sub(&rl[5]),
            f_[7]
                .mul(&beta_inv)
                .add(&ro[7].mul(&delta))
                .sub(&rl[6])
                .add(&rr[5]),
        ];

        let cs =
            vector_mul(&self.h_vec, &[&rs[..], &ls[..]].concat()).add(vector_mul(&self.g_vec, &ns));

        transcript::app_point(b"commitment_cs", &cs, t);

        let tau = transcript::get_challenge(b"circuit_tau", t);
        let tau_inv = tau.invert_vartime().unwrap();
        let tau2 = tau.mul(&tau);
        let tau3 = tau2.mul(&tau);

        let mut l = vector_mul_on_scalar(&[&rs[..], &ls[..]].concat(), &tau_inv);
        l = vector_sub(
            &l,
            &vector_mul_on_scalar(&[&ro[..], &lo[..]].concat(), &delta),
        );
        l = vector_add(
            &l,
            &vector_mul_on_scalar(&[&rl[..], &ll[..]].concat(), &tau),
        );
        l = vector_sub(
            &l,
            &vector_mul_on_scalar(&[&rr[..], &lr[..]].concat(), &tau2),
        );
        l = vector_add(
            &l,
            &vector_mul_on_scalar(&[&rv[..], &v_1[..]].concat(), &tau3),
        );

        let mut pn_tau = vector_mul_on_scalar(&c_nO, &tau3.mul(&delta_inv));
        pn_tau = vector_sub(&pn_tau, &vector_mul_on_scalar(&c_nL, &tau2));
        pn_tau = vector_add(&pn_tau, &vector_mul_on_scalar(&c_nR, &tau));

        let ps_tau = weight_vector_mul(&pn_tau, &pn_tau, &mu)
            .add(&vector_mul(&lambda_vec, &self.a_l).mul(&tau3).mul(&two))
            .sub(&vector_mul(&mu_vec, &self.a_m).mul(&tau3).mul(&two));

        let mut n_tau = vector_mul_on_scalar(&ns, &tau_inv);
        n_tau = vector_sub(&n_tau, &vector_mul_on_scalar(&no, &delta));
        n_tau = vector_add(&n_tau, &vector_mul_on_scalar(&nl, &tau));
        n_tau = vector_sub(&n_tau, &vector_mul_on_scalar(&nr, &tau2));

        let mut n = vector_add(&pn_tau, &n_tau);

        let cr_tau = vec![
            Scalar::ONE,
            tau_inv.mul(beta),
            tau.mul(beta),
            tau2.mul(beta),
            tau3.mul(beta),
            tau.mul(tau3).mul(beta),
            tau2.mul(tau3).mul(beta),
            tau3.mul(tau3).mul(beta),
            tau3.mul(tau3).mul(tau).mul(beta),
        ];

        let mut cl_tau = vector_mul_on_scalar(&c_lO, &tau3.mul(&delta_inv));
        cl_tau = vector_sub(&cl_tau, &vector_mul_on_scalar(&c_lL, &tau2));
        cl_tau = vector_add(&cl_tau, &vector_mul_on_scalar(&c_lR, &tau));
        cl_tau = vector_mul_on_scalar(&cl_tau, &two);
        cl_tau = vector_sub(&cl_tau, &c_l0);

        let mut c = [&cr_tau[..], &cl_tau[..]].concat();

        let v = ps_tau.add(&tau3.mul(&v_0));

        let commitment = self
            .g
            .mul(v)
            .add(&vector_mul(&self.h_vec, &l))
            .add(&vector_mul(&self.g_vec, &n));

        while l.len() < self.h_vec.len() + self.h_vec_.len() {
            l.push(Scalar::ZERO);
            c.push(Scalar::ZERO);
        }

        while n.len() < self.g_vec.len() + self.g_vec_.len() {
            n.push(Scalar::ZERO);
        }

        let wnla = WeightNormLinearArgument {
            g: self.g,
            g_vec: [&self.g_vec[..], &self.g_vec_[..]].concat(),
            h_vec: [&self.h_vec[..], &self.h_vec_[..]].concat(),
            c,
            rho,
            mu,
        };

        let proof_wnla = wnla.prove(&commitment, t, l, n);

        Proof {
            c_l: cl,
            c_r: cr,
            c_o: co,
            c_s: cs,
            r: proof_wnla.r,
            x: proof_wnla.x,
            l: proof_wnla.l,
            n: proof_wnla.n,
        }
    }

    fn linear_comb_coef(&self, i: usize, lambda: &Scalar, mu: &Scalar) -> Scalar {
        let mut coef = Scalar::ZERO;
        if self.f_l {
            coef = coef.add(pow(lambda, self.dim_nv * i))
        }

        if self.f_m {
            coef = coef.add(pow(mu, self.dim_nv * i + 1))
        }

        coef
    }

    fn collect_cl0(&self, lambda: &Scalar, mu: &Scalar) -> Vec<Scalar> {
        let mut c_l0 = vec![Scalar::ZERO; self.dim_nv - 1];
        if self.f_l {
            c_l0 = e(lambda, self.dim_nv)[1..].to_vec();
        }
        if self.f_m {
            c_l0 = vector_sub(&c_l0, &vector_mul_on_scalar(&e(mu, self.dim_nv)[1..], mu));
        }

        c_l0
    }

    fn collect_c(
        &self,
        lambda_vec: &[Scalar],
        mu_vec: &[Scalar],
        mu: &Scalar,
    ) -> (
        Vec<Scalar>,
        Vec<Scalar>,
        Vec<Scalar>,
        Vec<Scalar>,
        Vec<Scalar>,
        Vec<Scalar>,
    ) {
        let (M_lnL, M_mnL, M_lnR, M_mnR) = self.collect_m_rl();
        let (M_lnO, M_mnO, M_llL, M_mlL, M_llR, M_mlR, M_llO, M_mlO) = self.collect_m_o();

        let mu_diag_inv = diag_inv(mu, self.dim_nm);

        let c_nL = vector_mul_on_matrix(
            &vector_sub(
                &vector_mul_on_matrix(lambda_vec, &M_lnL),
                &vector_mul_on_matrix(mu_vec, &M_mnL),
            ),
            &mu_diag_inv,
        );
        let c_nR = vector_mul_on_matrix(
            &vector_sub(
                &vector_mul_on_matrix(lambda_vec, &M_lnR),
                &vector_mul_on_matrix(mu_vec, &M_mnR),
            ),
            &mu_diag_inv,
        );
        let c_nO = vector_mul_on_matrix(
            &vector_sub(
                &vector_mul_on_matrix(lambda_vec, &M_lnO),
                &vector_mul_on_matrix(mu_vec, &M_mnO),
            ),
            &mu_diag_inv,
        );

        let c_lL = vector_sub(
            &vector_mul_on_matrix(lambda_vec, &M_llL),
            &vector_mul_on_matrix(mu_vec, &M_mlL),
        );
        let c_lR = vector_sub(
            &vector_mul_on_matrix(lambda_vec, &M_llR),
            &vector_mul_on_matrix(mu_vec, &M_mlR),
        );
        let c_lO = vector_sub(
            &vector_mul_on_matrix(lambda_vec, &M_llO),
            &vector_mul_on_matrix(mu_vec, &M_mlO),
        );

        (c_nL, c_nR, c_nO, c_lL, c_lR, c_lO)
    }

    fn collect_lambda(&self, lambda: &Scalar, mu: &Scalar) -> Vec<Scalar> {
        let mut lambda_vec = e(lambda, self.dim_nl);
        if self.f_l && self.f_m {
            lambda_vec = vector_sub(
                &lambda_vec,
                &vector_add(
                    &vector_tensor_mul(
                        &vector_mul_on_scalar(&e(lambda, self.dim_nv), mu),
                        &e(&pow(mu, self.dim_nv), self.k),
                    ),
                    &vector_tensor_mul(&e(mu, self.dim_nv), &e(&pow(lambda, self.dim_nv), self.k)),
                ),
            );
        }

        lambda_vec
    }

    fn collect_m_rl(
        &self,
    ) -> (
        Vec<Vec<Scalar>>,
        Vec<Vec<Scalar>>,
        Vec<Vec<Scalar>>,
        Vec<Vec<Scalar>>,
    ) {
        let M_lnL = (0..self.dim_nl)
            .map(|i| Vec::from(&self.W_l[i][..self.dim_nm]))
            .collect::<Vec<Vec<Scalar>>>();
        let M_mnL = (0..self.dim_nm)
            .map(|i| Vec::from(&self.W_m[i][..self.dim_nm]))
            .collect::<Vec<Vec<Scalar>>>();
        let M_lnR = (0..self.dim_nl)
            .map(|i| Vec::from(&self.W_l[i][self.dim_nm..self.dim_nm * 2]))
            .collect::<Vec<Vec<Scalar>>>();
        let M_mnR = (0..self.dim_nm)
            .map(|i| Vec::from(&self.W_m[i][self.dim_nm..self.dim_nm * 2]))
            .collect::<Vec<Vec<Scalar>>>();
        (M_lnL, M_mnL, M_lnR, M_mnR)
    }

    fn collect_m_o(
        &self,
    ) -> (
        Vec<Vec<Scalar>>,
        Vec<Vec<Scalar>>,
        Vec<Vec<Scalar>>,
        Vec<Vec<Scalar>>,
        Vec<Vec<Scalar>>,
        Vec<Vec<Scalar>>,
        Vec<Vec<Scalar>>,
        Vec<Vec<Scalar>>,
    ) {
        let W_lO = (0..self.dim_nl)
            .map(|i| Vec::from(&self.W_l[i][self.dim_nm * 2..]))
            .collect::<Vec<Vec<Scalar>>>();
        let W_mO = (0..self.dim_nm)
            .map(|i| Vec::from(&self.W_m[i][self.dim_nm * 2..]))
            .collect::<Vec<Vec<Scalar>>>();

        let map_f = |isz: usize,
                     jsz: usize,
                     typ: PartitionType,
                     W_x: &Vec<Vec<Scalar>>|
         -> Vec<Vec<Scalar>> {
            (0..isz)
                .map(|i| {
                    (0..jsz)
                        .map(|j| {
                            if let Some(j_) = (self.partition)(typ, j) {
                                W_x[i][j_]
                            } else {
                                Scalar::ZERO
                            }
                        })
                        .collect::<Vec<Scalar>>()
                })
                .collect::<Vec<Vec<Scalar>>>()
        };

        let M_lnO = map_f(self.dim_nl, self.dim_nm, PartitionType::NO, &W_lO);
        let M_llL = map_f(self.dim_nl, self.dim_nv, PartitionType::LL, &W_lO);
        let M_llR = map_f(self.dim_nl, self.dim_nv, PartitionType::LR, &W_lO);
        let M_llO = map_f(self.dim_nl, self.dim_nv, PartitionType::LO, &W_lO);

        let M_mnO = map_f(self.dim_nm, self.dim_nm, PartitionType::NO, &W_mO);
        let M_mlL = map_f(self.dim_nm, self.dim_nv, PartitionType::LL, &W_mO);
        let M_mlR = map_f(self.dim_nm, self.dim_nv, PartitionType::LR, &W_mO);
        let M_mlO = map_f(self.dim_nm, self.dim_nv, PartitionType::LO, &W_mO);

        (M_lnO, M_mnO, M_llL, M_mlL, M_llR, M_mlR, M_llO, M_mlO)
    }
}
