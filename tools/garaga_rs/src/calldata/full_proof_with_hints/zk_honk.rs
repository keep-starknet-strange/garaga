use crate::algebra::g1g2pair::G1G2Pair;
use crate::algebra::g1point::G1Point;
use crate::algebra::g2point::G2Point;
use crate::calldata::mpc_calldata;
use crate::calldata::msm_calldata;
use crate::calldata::G1PointBigUint;
use crate::definitions::BN254PrimeField;
use crate::definitions::CurveID;
use crate::definitions::FieldElement;
use crate::definitions::GrumpkinPrimeField;
use crate::definitions::Stark252PrimeField;
use crate::io::{element_from_biguint, element_to_biguint, field_element_to_u256_limbs};
use lambdaworks_crypto::hash::poseidon::starknet::PoseidonCairoStark252;
use lambdaworks_crypto::hash::poseidon::Poseidon;
use lambdaworks_math::field::errors::FieldError;
use lambdaworks_math::field::traits::IsPrimeField;
use lambdaworks_math::traits::ByteConversion;
use num_bigint::BigUint;
use sha3::{Digest, Keccak256};

pub const NUMBER_OF_SUBRELATIONS: usize = 28;
pub const NUMBER_OF_ALPHAS: usize = NUMBER_OF_SUBRELATIONS - 1;
pub const NUMBER_OF_ENTITIES: usize = 41;
pub const NUMBER_UNSHIFTED: usize = 36;
pub const NUMBER_TO_BE_SHIFTED: usize = 5;
pub const SHIFTED_COMMITMENTS_START: usize = 30;
pub const MAX_LOG_N: usize = 23;
pub const MAX_CIRCUIT_SIZE: usize = 1 << MAX_LOG_N;
pub const PAIRING_POINT_OBJECT_LENGTH: usize = 16;
pub const CONST_PROOF_SIZE_LOG_N: usize = 28;

pub const NUM_WITNESS_ENTITIES: usize = 8;
pub const NUM_ELEMENTS_COMM: usize = 2;
pub const NUM_ELEMENTS_FR: usize = 1;

/// Calculate expected proof size based on log_circuit_size
pub fn calculate_proof_size(log_circuit_size: usize) -> usize {
    let mut proof_size = NUM_WITNESS_ENTITIES * NUM_ELEMENTS_COMM; // 16
    proof_size += NUM_ELEMENTS_COMM * 4; // 8 (Libra concat, grand sum, quotient comms + Gemini masking)
    proof_size += log_circuit_size * ZK_BATCHED_RELATION_PARTIAL_LENGTH * NUM_ELEMENTS_FR; // sumcheck univariates
    proof_size += NUMBER_OF_ENTITIES * NUM_ELEMENTS_FR; // 41 (sumcheck evaluations)
    proof_size += NUM_ELEMENTS_FR * 3; // 3 (Libra sum, claimed eval, Gemini masking eval)
    proof_size += log_circuit_size * NUM_ELEMENTS_FR; // Gemini a evaluations
    proof_size += LIBRA_EVALUATIONS * NUM_ELEMENTS_FR; // 4 (libra evaluations)
    proof_size += (log_circuit_size - 1) * NUM_ELEMENTS_COMM; // Gemini Fold commitments
    proof_size += NUM_ELEMENTS_COMM * 2; // 4 (Shplonk Q and KZG W)
    proof_size += PAIRING_POINT_OBJECT_LENGTH; // 16 (pairing inputs)
    proof_size
}
pub const ZK_BATCHED_RELATION_PARTIAL_LENGTH: usize = 9;
pub const SUBGROUP_SIZE: usize = 256;
pub const LIBRA_COMMITMENTS: usize = 3;
pub const LIBRA_EVALUATIONS: usize = 4;
pub const LIBRA_UNIVARIATES_LENGTH: usize = 9;

// Number of G1 points in the VK
pub const VK_NUM_POINTS: usize = 28;

pub struct HonkVerificationKey {
    pub log_circuit_size: usize,
    pub public_inputs_size: usize,
    pub public_inputs_offset: usize,
    pub qm: G1PointBigUint,
    pub qc: G1PointBigUint,
    pub ql: G1PointBigUint,
    pub qr: G1PointBigUint,
    pub qo: G1PointBigUint,
    pub q4: G1PointBigUint,
    pub q_lookup: G1PointBigUint,
    pub q_arith: G1PointBigUint,
    pub q_delta_range: G1PointBigUint,
    pub q_elliptic: G1PointBigUint,
    pub q_memory: G1PointBigUint,
    pub q_nnf: G1PointBigUint,
    pub q_poseidon2_external: G1PointBigUint,
    pub q_poseidon2_internal: G1PointBigUint,
    pub s1: G1PointBigUint,
    pub s2: G1PointBigUint,
    pub s3: G1PointBigUint,
    pub s4: G1PointBigUint,
    pub id1: G1PointBigUint,
    pub id2: G1PointBigUint,
    pub id3: G1PointBigUint,
    pub id4: G1PointBigUint,
    pub t1: G1PointBigUint,
    pub t2: G1PointBigUint,
    pub t3: G1PointBigUint,
    pub t4: G1PointBigUint,
    pub lagrange_first: G1PointBigUint,
    pub lagrange_last: G1PointBigUint,
    pub vk_hash: BigUint,
}

impl HonkVerificationKey {
    pub fn from_bytes(vk_bytes: &[u8]) -> Result<Self, String> {
        // VK format: 3 * 32 bytes for log_circuit_size, public_inputs_size, public_inputs_offset
        // then 28 * 64 bytes for G1 points
        let expected_len = 3 * 32 + VK_NUM_POINTS * 64;
        if vk_bytes.len() != expected_len {
            return Err(format!(
                "Invalid input length: {} (expected {})",
                vk_bytes.len(),
                expected_len
            ));
        }

        // Compute vk_hash using keccak256, then mod by BN254 curve order
        let vk_hash_bytes = Keccak256::digest(vk_bytes);
        let vk_hash_full = BigUint::from_bytes_be(&vk_hash_bytes);
        // BN254 curve order (n)
        let bn254_n = BigUint::parse_bytes(
            b"30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001",
            16,
        )
        .unwrap();
        let vk_hash = vk_hash_full % bn254_n;

        // Parse header fields (32 bytes each)
        let log_circuit_size = BigUint::from_bytes_be(&vk_bytes[0..32]);
        let public_inputs_size = BigUint::from_bytes_be(&vk_bytes[32..64]);
        let public_inputs_offset = BigUint::from_bytes_be(&vk_bytes[64..96]);

        let log_circuit_size: usize = log_circuit_size
            .try_into()
            .map_err(|e: num_bigint::TryFromBigIntError<BigUint>| e.to_string())?;
        let public_inputs_size: usize = public_inputs_size
            .try_into()
            .map_err(|e: num_bigint::TryFromBigIntError<BigUint>| e.to_string())?;
        let public_inputs_offset: usize = public_inputs_offset
            .try_into()
            .map_err(|e: num_bigint::TryFromBigIntError<BigUint>| e.to_string())?;

        if public_inputs_offset != 1 {
            return Err(format!(
                "Invalid public inputs offset: {}",
                public_inputs_offset
            ));
        }

        if log_circuit_size > CONST_PROOF_SIZE_LOG_N {
            return Err(format!("Invalid log circuit size: {}", log_circuit_size));
        }

        if public_inputs_size < PAIRING_POINT_OBJECT_LENGTH {
            return Err(format!(
                "Invalid public inputs size: {}",
                public_inputs_size
            ));
        }

        // Parse G1 points (64 bytes each: 32 for x, 32 for y)
        let mut cursor = 96;
        let mut points = vec![];
        for _ in 0..VK_NUM_POINTS {
            let x = BigUint::from_bytes_be(&vk_bytes[cursor..cursor + 32]);
            let y = BigUint::from_bytes_be(&vk_bytes[cursor + 32..cursor + 64]);
            points.push(G1PointBigUint { x, y });
            cursor += 64;
        }

        let [qm, qc, ql, qr, qo, q4, q_lookup, q_arith, q_delta_range, q_elliptic, q_memory, q_nnf, q_poseidon2_external, q_poseidon2_internal, s1, s2, s3, s4, id1, id2, id3, id4, t1, t2, t3, t4, lagrange_first, lagrange_last] =
            points.try_into().unwrap();

        Ok(Self {
            log_circuit_size,
            public_inputs_size,
            public_inputs_offset,
            qm,
            qc,
            ql,
            qr,
            qo,
            q4,
            q_lookup,
            q_arith,
            q_delta_range,
            q_elliptic,
            q_memory,
            q_nnf,
            q_poseidon2_external,
            q_poseidon2_internal,
            s1,
            s2,
            s3,
            s4,
            id1,
            id2,
            id3,
            id4,
            t1,
            t2,
            t3,
            t4,
            lagrange_first,
            lagrange_last,
            vk_hash,
        })
    }
}

pub trait Hasher {
    fn reset(&mut self);
    fn digest_as_bytes(&self) -> Vec<u8>;
    fn update_bytes(&mut self, data: &[u8]);

    fn digest(&self) -> BigUint {
        let bytes = self.digest_as_bytes();
        BigUint::from_bytes_be(&bytes)
    }

    fn digest_reset(&mut self) -> Vec<u8> {
        let result = self.digest_as_bytes();
        self.reset();
        result
    }

    fn update(&mut self, value: &BigUint) {
        // Pad to 32 bytes
        let mut bytes = value.to_bytes_be();
        while bytes.len() < 32 {
            bytes.insert(0, 0);
        }
        self.update_bytes(&bytes);
    }

    fn update_point(&mut self, point: &G1PointBigUint) {
        self.update(&point.x);
        self.update(&point.y);
    }
}

pub struct KeccakHasher {
    data: Vec<u8>,
}

impl Default for KeccakHasher {
    fn default() -> Self {
        Self::new()
    }
}

impl KeccakHasher {
    pub fn new() -> Self {
        KeccakHasher { data: vec![] }
    }
}

impl Hasher for KeccakHasher {
    fn reset(&mut self) {
        self.data = vec![];
    }

    fn update_bytes(&mut self, data: &[u8]) {
        self.data.extend_from_slice(data);
    }

    fn digest_as_bytes(&self) -> Vec<u8> {
        let hash = Keccak256::digest(&self.data);
        let hash_int = BigUint::from_bytes_be(&hash);
        // Reduce modulo Grumpkin field prime (same as BN254 curve order)
        let grumpkin_p = BigUint::parse_bytes(
            b"30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001",
            16,
        )
        .unwrap();
        let reduced = hash_int % grumpkin_p;
        // Convert back to 32 bytes
        let mut bytes = reduced.to_bytes_be();
        while bytes.len() < 32 {
            bytes.insert(0, 0);
        }
        bytes
    }
}

pub struct ZKHonkProof {
    pub public_inputs: Vec<BigUint>,
    pub pairing_point_object: [BigUint; PAIRING_POINT_OBJECT_LENGTH],
    pub w1: G1PointBigUint,
    pub w2: G1PointBigUint,
    pub w3: G1PointBigUint,
    pub w4: G1PointBigUint,
    pub z_perm: G1PointBigUint,
    pub lookup_read_counts: G1PointBigUint,
    pub lookup_read_tags: G1PointBigUint,
    pub lookup_inverses: G1PointBigUint,
    pub libra_commitments: [G1PointBigUint; 3],
    pub libra_sum: BigUint,
    pub sumcheck_univariates:
        [[BigUint; ZK_BATCHED_RELATION_PARTIAL_LENGTH]; CONST_PROOF_SIZE_LOG_N],
    pub sumcheck_evaluations: [BigUint; NUMBER_OF_ENTITIES],
    pub libra_evaluation: BigUint,
    pub gemini_masking_poly: G1PointBigUint,
    pub gemini_masking_eval: BigUint,
    pub gemini_fold_comms: [G1PointBigUint; CONST_PROOF_SIZE_LOG_N - 1],
    pub gemini_a_evaluations: [BigUint; CONST_PROOF_SIZE_LOG_N],
    pub libra_poly_evals: [BigUint; 4],
    pub shplonk_q: G1PointBigUint,
    pub kzg_quotient: G1PointBigUint,
}

impl ZKHonkProof {
    pub fn from_bytes(
        proof_bytes: &[u8],
        public_inputs_bytes: &[u8],
        log_circuit_size: usize,
    ) -> Result<Self, String> {
        let expected_proof_size = calculate_proof_size(log_circuit_size);
        if proof_bytes.len() != 32 * expected_proof_size {
            return Err(format!(
                "Invalid proof bytes length: {} (expected {})",
                proof_bytes.len(),
                32 * expected_proof_size
            ));
        }

        let mut values = vec![];
        for i in (0..).step_by(32).take(expected_proof_size) {
            values.push(BigUint::from_bytes_be(&proof_bytes[i..i + 32]));
        }

        if public_inputs_bytes.len() % 32 != 0 {
            return Err(format!(
                "Invalid public input bytes length: {}",
                public_inputs_bytes.len()
            ));
        }

        let public_inputs_size = public_inputs_bytes.len() / 32;
        let mut public_inputs = vec![];
        for i in (0..).step_by(32).take(public_inputs_size) {
            public_inputs.push(BigUint::from_bytes_be(&public_inputs_bytes[i..i + 32]));
        }

        Self::from(values, public_inputs, log_circuit_size)
    }

    pub fn from(
        values: Vec<BigUint>,
        public_inputs: Vec<BigUint>,
        log_circuit_size: usize,
    ) -> Result<Self, String> {
        let expected_proof_size = calculate_proof_size(log_circuit_size);
        if values.len() != expected_proof_size {
            return Err(format!(
                "Invalid proof length: {} (expected {})",
                values.len(),
                expected_proof_size
            ));
        }

        let mut offset = 0;

        // Parse pairing point object
        let mut pairing_point_object = vec![];
        for i in offset..offset + PAIRING_POINT_OBJECT_LENGTH {
            pairing_point_object.push(values[i].clone());
        }
        let pairing_point_object: [BigUint; PAIRING_POINT_OBJECT_LENGTH] =
            pairing_point_object.try_into().unwrap();
        offset += PAIRING_POINT_OBJECT_LENGTH;

        fn parse_g1_proof_point(values: [BigUint; 2]) -> G1PointBigUint {
            let [x, y] = values;
            G1PointBigUint { x, y }
        }

        // Parse 9 G1 points: w1, w2, w3, lookup_read_counts, lookup_read_tags, w4, lookup_inverses, z_perm, libra_commitment_0
        let mut points = vec![];
        for i in (offset..).step_by(2).take(9) {
            points.push(parse_g1_proof_point(
                values[i..i + 2].to_vec().try_into().unwrap(),
            ));
        }
        offset += 9 * 2;
        let [w1, w2, w3, lookup_read_counts, lookup_read_tags, w4, lookup_inverses, z_perm, libra_commitment_0] =
            points.try_into().unwrap();

        let libra_sum = values[offset].clone();
        offset += 1;

        // Parse sumcheck univariates
        let mut sumcheck_univariates = vec![];
        for i in (offset..)
            .step_by(ZK_BATCHED_RELATION_PARTIAL_LENGTH)
            .take(log_circuit_size)
        {
            let mut sumcheck_univariate = vec![];
            for j in i..i + ZK_BATCHED_RELATION_PARTIAL_LENGTH {
                sumcheck_univariate.push(values[j].clone());
            }
            sumcheck_univariates.push(sumcheck_univariate.try_into().unwrap());
        }
        // Fill rest with zeros
        while sumcheck_univariates.len() < CONST_PROOF_SIZE_LOG_N {
            sumcheck_univariates.push([0u8; ZK_BATCHED_RELATION_PARTIAL_LENGTH].map(BigUint::from));
        }
        let sumcheck_univariates: [[BigUint; ZK_BATCHED_RELATION_PARTIAL_LENGTH];
            CONST_PROOF_SIZE_LOG_N] = sumcheck_univariates.try_into().unwrap();
        offset += log_circuit_size * ZK_BATCHED_RELATION_PARTIAL_LENGTH;

        // Parse sumcheck evaluations
        let mut sumcheck_evaluations = vec![];
        for i in offset..offset + NUMBER_OF_ENTITIES {
            sumcheck_evaluations.push(values[i].clone());
        }
        let sumcheck_evaluations: [BigUint; NUMBER_OF_ENTITIES] =
            sumcheck_evaluations.try_into().unwrap();
        offset += NUMBER_OF_ENTITIES;

        let libra_evaluation = values[offset].clone();
        offset += 1;

        // Parse libra_commitment_1, libra_commitment_2, gemini_masking_poly
        let mut points = vec![];
        for i in (offset..).step_by(2).take(3) {
            points.push(parse_g1_proof_point(
                values[i..i + 2].to_vec().try_into().unwrap(),
            ));
        }
        offset += 3 * 2;
        let [libra_commitment_1, libra_commitment_2, gemini_masking_poly] =
            points.try_into().unwrap();

        let libra_commitments = [libra_commitment_0, libra_commitment_1, libra_commitment_2];

        let gemini_masking_eval = values[offset].clone();
        offset += 1;

        // Parse gemini fold comms
        let mut gemini_fold_comms = vec![];
        for i in (offset..).step_by(2).take(log_circuit_size - 1) {
            gemini_fold_comms.push(parse_g1_proof_point(
                values[i..i + 2].to_vec().try_into().unwrap(),
            ));
        }
        // Fill rest with dummy points
        while gemini_fold_comms.len() < CONST_PROOF_SIZE_LOG_N - 1 {
            gemini_fold_comms.push(G1PointBigUint {
                x: BigUint::from(0u8),
                y: BigUint::from(0u8),
            });
        }
        let gemini_fold_comms: [G1PointBigUint; CONST_PROOF_SIZE_LOG_N - 1] =
            gemini_fold_comms.try_into().unwrap();
        offset += (log_circuit_size - 1) * 2;

        // Parse gemini a evaluations
        let mut gemini_a_evaluations = vec![];
        for i in offset..offset + log_circuit_size {
            gemini_a_evaluations.push(values[i].clone());
        }
        // Fill rest with zeros
        while gemini_a_evaluations.len() < CONST_PROOF_SIZE_LOG_N {
            gemini_a_evaluations.push(BigUint::from(0u8));
        }
        let gemini_a_evaluations: [BigUint; CONST_PROOF_SIZE_LOG_N] =
            gemini_a_evaluations.try_into().unwrap();
        offset += log_circuit_size;

        let libra_poly_evals: [BigUint; 4] =
            values[offset..offset + 4].to_vec().try_into().unwrap();
        offset += 4;

        // Parse shplonk_q, kzg_quotient
        let mut points = vec![];
        for i in (offset..).step_by(2).take(2) {
            points.push(parse_g1_proof_point(
                values[i..i + 2].to_vec().try_into().unwrap(),
            ));
        }
        let [shplonk_q, kzg_quotient] = points.try_into().unwrap();
        offset += 2 * 2;

        assert_eq!(offset, expected_proof_size);

        Ok(Self {
            public_inputs,
            pairing_point_object,
            w1,
            w2,
            w3,
            w4,
            z_perm,
            lookup_read_counts,
            lookup_read_tags,
            lookup_inverses,
            libra_commitments,
            libra_sum,
            sumcheck_univariates,
            sumcheck_evaluations,
            libra_evaluation,
            gemini_masking_poly,
            gemini_masking_eval,
            gemini_fold_comms,
            gemini_a_evaluations,
            libra_poly_evals,
            shplonk_q,
            kzg_quotient,
        })
    }
}

pub struct ZKHonkTranscript {
    pub eta: BigUint,
    pub eta_two: BigUint,
    pub eta_three: BigUint,
    pub beta: BigUint,
    pub gamma: BigUint,
    pub alpha: BigUint,
    pub gate_challenge: BigUint,
    pub libra_challenge: BigUint,
    pub sumcheck_u_challenges: [BigUint; CONST_PROOF_SIZE_LOG_N],
    pub rho: BigUint,
    pub gemini_r: BigUint,
    pub shplonk_nu: BigUint,
    pub shplonk_z: BigUint,
}

impl ZKHonkTranscript {
    pub fn from_proof(
        vk: &HonkVerificationKey,
        proof: &ZKHonkProof,
    ) -> Result<
        (
            Self,
            FieldElement<Stark252PrimeField>,
            FieldElement<Stark252PrimeField>,
        ),
        String,
    > {
        if proof.public_inputs.len() != vk.public_inputs_size - PAIRING_POINT_OBJECT_LENGTH {
            return Err(format!(
                "Public inputs length mismatch: proof {}, vk {}",
                proof.public_inputs.len(),
                vk.public_inputs_size - PAIRING_POINT_OBJECT_LENGTH
            ));
        }
        Ok(compute_zk_transcript(vk, proof, KeccakHasher::new()))
    }
}

pub fn get_zk_honk_calldata(
    proof: &ZKHonkProof,
    vk: &HonkVerificationKey,
) -> Result<Vec<BigUint>, String> {
    let (transcript, transcript_state, _) = ZKHonkTranscript::from_proof(vk, proof)?;

    fn element_on_curve(element: &BigUint) -> FieldElement<GrumpkinPrimeField> {
        element_from_biguint(element)
    }

    fn g1_point_on_curve(point: &G1PointBigUint) -> Result<G1Point<BN254PrimeField>, String> {
        G1Point::new(
            element_from_biguint(&point.x),
            element_from_biguint(&point.y),
            false,
        )
    }

    let public_inputs: Vec<FieldElement<GrumpkinPrimeField>> =
        proof.public_inputs.iter().map(element_on_curve).collect();
    let pairing_point_object: Vec<FieldElement<GrumpkinPrimeField>> = proof
        .pairing_point_object
        .iter()
        .map(element_on_curve)
        .collect();
    let w1 = g1_point_on_curve(&proof.w1)?;
    let w2 = g1_point_on_curve(&proof.w2)?;
    let w3 = g1_point_on_curve(&proof.w3)?;
    let w4 = g1_point_on_curve(&proof.w4)?;
    let z_perm = g1_point_on_curve(&proof.z_perm)?;
    let lookup_read_counts = g1_point_on_curve(&proof.lookup_read_counts)?;
    let lookup_read_tags = g1_point_on_curve(&proof.lookup_read_tags)?;
    let lookup_inverses = g1_point_on_curve(&proof.lookup_inverses)?;
    let libra_commitments: Vec<G1Point<BN254PrimeField>> = proof
        .libra_commitments
        .iter()
        .map(g1_point_on_curve)
        .collect::<Result<Vec<_>, _>>()?;
    let libra_sum = element_on_curve(&proof.libra_sum);
    let sumcheck_univariates: Vec<Vec<FieldElement<GrumpkinPrimeField>>> = proof
        .sumcheck_univariates
        .iter()
        .map(|v| v.iter().map(element_on_curve).collect())
        .collect();
    let sumcheck_evaluations: [FieldElement<GrumpkinPrimeField>; NUMBER_OF_ENTITIES] = proof
        .sumcheck_evaluations
        .iter()
        .map(element_on_curve)
        .collect::<Vec<_>>()
        .try_into()
        .unwrap();
    let libra_evaluation = element_on_curve(&proof.libra_evaluation);
    let gemini_masking_poly = g1_point_on_curve(&proof.gemini_masking_poly)?;
    let gemini_masking_eval = element_on_curve(&proof.gemini_masking_eval);
    let gemini_fold_comms: Vec<G1Point<BN254PrimeField>> = proof
        .gemini_fold_comms
        .iter()
        .map(g1_point_on_curve)
        .collect::<Result<Vec<_>, _>>()?;
    let gemini_a_evaluations: [FieldElement<GrumpkinPrimeField>; CONST_PROOF_SIZE_LOG_N] = proof
        .gemini_a_evaluations
        .iter()
        .map(element_on_curve)
        .collect::<Vec<_>>()
        .try_into()
        .unwrap();
    let libra_poly_evals: [FieldElement<GrumpkinPrimeField>; 4] = proof
        .libra_poly_evals
        .iter()
        .map(element_on_curve)
        .collect::<Vec<_>>()
        .try_into()
        .unwrap();
    let shplonk_q = g1_point_on_curve(&proof.shplonk_q)?;
    let kzg_quotient = g1_point_on_curve(&proof.kzg_quotient)?;

    let qm = g1_point_on_curve(&vk.qm)?;
    let qc = g1_point_on_curve(&vk.qc)?;
    let ql = g1_point_on_curve(&vk.ql)?;
    let qr = g1_point_on_curve(&vk.qr)?;
    let qo = g1_point_on_curve(&vk.qo)?;
    let q4 = g1_point_on_curve(&vk.q4)?;
    let q_lookup = g1_point_on_curve(&vk.q_lookup)?;
    let q_arith = g1_point_on_curve(&vk.q_arith)?;
    let q_delta_range = g1_point_on_curve(&vk.q_delta_range)?;
    let q_elliptic = g1_point_on_curve(&vk.q_elliptic)?;
    let q_memory = g1_point_on_curve(&vk.q_memory)?;
    let q_nnf = g1_point_on_curve(&vk.q_nnf)?;
    let q_poseidon2_external = g1_point_on_curve(&vk.q_poseidon2_external)?;
    let q_poseidon2_internal = g1_point_on_curve(&vk.q_poseidon2_internal)?;
    let s1 = g1_point_on_curve(&vk.s1)?;
    let s2 = g1_point_on_curve(&vk.s2)?;
    let s3 = g1_point_on_curve(&vk.s3)?;
    let s4 = g1_point_on_curve(&vk.s4)?;
    let id1 = g1_point_on_curve(&vk.id1)?;
    let id2 = g1_point_on_curve(&vk.id2)?;
    let id3 = g1_point_on_curve(&vk.id3)?;
    let id4 = g1_point_on_curve(&vk.id4)?;
    let t1 = g1_point_on_curve(&vk.t1)?;
    let t2 = g1_point_on_curve(&vk.t2)?;
    let t3 = g1_point_on_curve(&vk.t3)?;
    let t4 = g1_point_on_curve(&vk.t4)?;
    let lagrange_first = g1_point_on_curve(&vk.lagrange_first)?;
    let lagrange_last = g1_point_on_curve(&vk.lagrange_last)?;

    let sumcheck_u_challenges: [FieldElement<GrumpkinPrimeField>; CONST_PROOF_SIZE_LOG_N] =
        transcript
            .sumcheck_u_challenges
            .iter()
            .map(element_on_curve)
            .collect::<Vec<_>>()
            .try_into()
            .unwrap();
    let rho = element_on_curve(&transcript.rho);
    let gemini_r = element_on_curve(&transcript.gemini_r);
    let shplonk_nu = element_on_curve(&transcript.shplonk_nu);
    let shplonk_z = element_on_curve(&transcript.shplonk_z);

    let consistent = check_evals_consistency(
        &libra_evaluation,
        &libra_poly_evals,
        &gemini_r,
        &sumcheck_u_challenges,
        vk.log_circuit_size,
    )
    .map_err(|e| format!("Field error: {:?}", e))?;
    if !consistent {
        return Err("Consistency check failed".to_string());
    }

    let scalars = extract_msm_scalars(
        vk.log_circuit_size,
        compute_shplemini_msm_scalars(
            vk.log_circuit_size,
            &sumcheck_evaluations,
            &gemini_masking_eval,
            &gemini_a_evaluations,
            &libra_poly_evals,
            &gemini_r,
            &rho,
            &shplonk_z,
            &shplonk_nu,
            &sumcheck_u_challenges,
        )
        .map_err(|e| format!("Field error: {:?}", e))?,
    );

    let mut scalars_msm = scalars;

    // Swap last two scalars
    let len = scalars_msm.len();
    if len >= 2 {
        scalars_msm.swap(len - 1, len - 2);
    }

    // Place first scalar just after the vk_lagrange_last point (index 28)
    if !scalars_msm.is_empty() {
        let first_scalar = scalars_msm.remove(0);
        scalars_msm.insert(28, first_scalar);
    }

    let proof_data = {
        let mut call_data = vec![];
        let call_data_ref = &mut call_data;

        fn push<T>(call_data_ref: &mut Vec<BigUint>, value: T)
        where
            BigUint: From<T>,
        {
            call_data_ref.push(value.into());
        }

        fn push_element<F>(call_data_ref: &mut Vec<BigUint>, element: &FieldElement<F>)
        where
            F: IsPrimeField,
            FieldElement<F>: ByteConversion,
        {
            let limbs = field_element_to_u256_limbs(element);
            for limb in limbs {
                push(call_data_ref, limb);
            }
        }

        fn push_elements(
            call_data_ref: &mut Vec<BigUint>,
            elements: &[FieldElement<GrumpkinPrimeField>],
            prepend_length: bool,
        ) {
            if prepend_length {
                push(call_data_ref, elements.len());
            }
            for element in elements {
                push_element(call_data_ref, element);
            }
        }

        fn push_point(call_data_ref: &mut Vec<BigUint>, point: &G1Point<BN254PrimeField>) {
            push_element(call_data_ref, &point.x);
            push_element(call_data_ref, &point.y);
        }

        push_elements(call_data_ref, &public_inputs, true);
        push_elements(call_data_ref, &pairing_point_object, true);
        push_point(call_data_ref, &w1);
        push_point(call_data_ref, &w2);
        push_point(call_data_ref, &w3);
        push_point(call_data_ref, &w4);
        push_point(call_data_ref, &z_perm);
        push_point(call_data_ref, &lookup_read_counts);
        push_point(call_data_ref, &lookup_read_tags);
        push_point(call_data_ref, &lookup_inverses);
        push(call_data_ref, libra_commitments.len());
        for point in &libra_commitments {
            push_point(call_data_ref, point);
        }
        push_element(call_data_ref, &libra_sum);
        push_elements(
            call_data_ref,
            &(0..vk.log_circuit_size)
                .flat_map(|i| sumcheck_univariates[i].clone())
                .collect::<Vec<_>>(),
            true,
        );
        push_elements(call_data_ref, &sumcheck_evaluations, true);
        push_element(call_data_ref, &libra_evaluation);
        push_point(call_data_ref, &gemini_masking_poly);
        push_element(call_data_ref, &gemini_masking_eval);
        push(call_data_ref, vk.log_circuit_size - 1);
        for point in &gemini_fold_comms[..vk.log_circuit_size - 1] {
            push_point(call_data_ref, point);
        }
        push_elements(
            call_data_ref,
            &gemini_a_evaluations[..vk.log_circuit_size],
            true,
        );
        push_elements(call_data_ref, &libra_poly_evals, true);
        push_point(call_data_ref, &shplonk_q);
        push_point(call_data_ref, &kzg_quotient);

        call_data
    };

    let mut points = vec![
        qm,                   // 0
        qc,                   // 1
        ql,                   // 2
        qr,                   // 3
        qo,                   // 4
        q4,                   // 5
        q_lookup,             // 6
        q_arith,              // 7
        q_delta_range,        // 8
        q_elliptic,           // 9
        q_memory,             // 10
        q_nnf,                // 11
        q_poseidon2_external, // 12
        q_poseidon2_internal, // 13
        s1,                   // 14
        s2,                   // 15
        s3,                   // 16
        s4,                   // 17
        id1,                  // 18
        id2,                  // 19
        id3,                  // 20
        id4,                  // 21
        t1,                   // 22
        t2,                   // 23
        t3,                   // 24
        t4,                   // 25
        lagrange_first,       // 26
        lagrange_last,        // 27
        gemini_masking_poly,  // 28
        w1,                   // 29
        w2,                   // 30
        w3,                   // 31
        w4,                   // 32
        z_perm,               // 33
        lookup_inverses,      // 34
        lookup_read_counts,   // 35
        lookup_read_tags,     // 36
    ];

    points.extend(gemini_fold_comms[0..vk.log_circuit_size - 1].to_vec());
    points.extend(libra_commitments);
    points.push(kzg_quotient.clone());
    points.push(G1Point::generator());

    let two = FieldElement::<Stark252PrimeField>::one().double();

    let vk_hash_element: FieldElement<Stark252PrimeField> = element_from_biguint(&vk.vk_hash);
    let mut state = [vk_hash_element, transcript_state, two];
    PoseidonCairoStark252::hades_permutation(&mut state);

    let msm_data =
        msm_calldata::calldata_builder(&points, &scalars_msm, CurveID::BN254 as usize, false, true);

    let p_0 = G1Point::msm(&points, &scalars_msm).add(&shplonk_q);
    let p_1 = kzg_quotient.neg();
    let g2_point_kzg_1 = G2Point::generator();
    let g2_point_kzg_2 = G2Point::new(
        [
            FieldElement::from_hex_unchecked(
                "0118C4D5B837BCC2BC89B5B398B5974E9F5944073B32078B7E231FEC938883B0",
            ),
            FieldElement::from_hex_unchecked(
                "260E01B251F6F1C7E7FF4E580791DEE8EA51D87A358E038B4EFE30FAC09383C1",
            ),
        ],
        [
            FieldElement::from_hex_unchecked(
                "22FEBDA3C0C0632A56475B4214E5615E11E6DD3F96E6CEA2854A87D4DACC5E55",
            ),
            FieldElement::from_hex_unchecked(
                "04FC6369F7110FE3D25156C1BB9A72859CF2A04641F99BA4EE413C80DA6A5FE4",
            ),
        ],
    )?;
    let pairs = [
        G1G2Pair::new(p_0, g2_point_kzg_1),
        G1G2Pair::new(p_1, g2_point_kzg_2),
    ];
    let mpc_data = {
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree12ExtensionField;
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree2ExtensionField;
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree6ExtensionField;
        mpc_calldata::calldata_builder::<
            true,
            BN254PrimeField,
            Degree2ExtensionField,
            Degree6ExtensionField,
            Degree12ExtensionField,
        >(&pairs, 2, &None)?
    };

    let size = proof_data.len() + msm_data.len() + mpc_data.len();
    let mut call_data = vec![size.into()];
    call_data.extend(proof_data);
    call_data.extend(msm_data);
    call_data.extend(mpc_data);
    Ok(call_data)
}

#[allow(clippy::needless_range_loop)]
fn compute_zk_transcript<T: Hasher>(
    vk: &HonkVerificationKey,
    proof: &ZKHonkProof,
    mut hasher: T,
) -> (
    ZKHonkTranscript,
    FieldElement<Stark252PrimeField>,
    FieldElement<Stark252PrimeField>,
) {
    fn split(ch: &[u8]) -> [BigUint; 2] {
        let ch_int = BigUint::from_bytes_be(ch);
        let mask = (BigUint::from(1u8) << 128) - 1u8;
        let low_128 = &ch_int & &mask;
        let high_128 = &ch_int >> 128;
        [low_128, high_128]
    }

    // Round 0: vk_hash, public_inputs, pairing_point_object, w1, w2, w3
    hasher.update(&vk.vk_hash);

    for pub_input in &proof.public_inputs {
        hasher.update(pub_input);
    }
    for pub_input in &proof.pairing_point_object {
        hasher.update(pub_input);
    }

    hasher.update_point(&proof.w1);
    hasher.update_point(&proof.w2);
    hasher.update_point(&proof.w3);

    let ch0 = hasher.digest_reset();
    let [eta, eta_two] = split(&ch0);

    hasher.update_bytes(&ch0);
    let ch0 = hasher.digest_reset();
    let [eta_three, _] = split(&ch0);

    // Round 1: ch0, lookup_read_counts, lookup_read_tags, w4
    hasher.update_bytes(&ch0);
    hasher.update_point(&proof.lookup_read_counts);
    hasher.update_point(&proof.lookup_read_tags);
    hasher.update_point(&proof.w4);

    let ch1 = hasher.digest_reset();
    let [beta, gamma] = split(&ch1);

    // Round 2: ch1, lookup_inverses, z_perm -> alpha
    hasher.update_bytes(&ch1);
    hasher.update_point(&proof.lookup_inverses);
    hasher.update_point(&proof.z_perm);

    let ch2 = hasher.digest_reset();
    let [alpha, _] = split(&ch2);

    // Round 3: Gate challenge
    hasher.update_bytes(&ch2);
    let ch3 = hasher.digest_reset();
    let [gate_challenge, _] = split(&ch3);

    // Round 3.5: Libra challenge
    hasher.update_bytes(&ch3);
    hasher.update_point(&proof.libra_commitments[0]);
    hasher.update(&proof.libra_sum);

    let ch3 = hasher.digest_reset();
    let [libra_challenge, _] = split(&ch3);

    // Round 4: Sumcheck u challenges
    let mut sumcheck_u_challenges = [0u8; CONST_PROOF_SIZE_LOG_N].map(BigUint::from);
    let mut ch4 = ch3;

    for i in 0..vk.log_circuit_size {
        hasher.update_bytes(&ch4);
        for j in 0..ZK_BATCHED_RELATION_PARTIAL_LENGTH {
            hasher.update(&proof.sumcheck_univariates[i][j]);
        }

        ch4 = hasher.digest_reset();
        let [challenge, _] = split(&ch4);
        sumcheck_u_challenges[i] = challenge;
    }

    // Rho challenge
    hasher.update_bytes(&ch4);
    for i in 0..NUMBER_OF_ENTITIES {
        hasher.update(&proof.sumcheck_evaluations[i]);
    }

    hasher.update(&proof.libra_evaluation);
    hasher.update_point(&proof.libra_commitments[1]);
    hasher.update_point(&proof.libra_commitments[2]);
    hasher.update_point(&proof.gemini_masking_poly);
    hasher.update(&proof.gemini_masking_eval);

    let c5 = hasher.digest_reset();
    let [rho, _] = split(&c5);

    // Gemini R
    hasher.update_bytes(&c5);
    for i in 0..vk.log_circuit_size - 1 {
        hasher.update_point(&proof.gemini_fold_comms[i]);
    }

    let c6 = hasher.digest_reset();
    let [gemini_r, _] = split(&c6);

    // Shplonk Nu
    hasher.update_bytes(&c6);
    for i in 0..vk.log_circuit_size {
        hasher.update(&proof.gemini_a_evaluations[i]);
    }

    for i in 0..4 {
        hasher.update(&proof.libra_poly_evals[i]);
    }

    let c7 = hasher.digest_reset();
    let [shplonk_nu, _] = split(&c7);

    // Shplonk Z
    hasher.update_bytes(&c7);
    hasher.update_point(&proof.shplonk_q);

    let c8 = hasher.digest_reset();
    let [shplonk_z_low, shplonk_z_high] = split(&c8);

    let mut state: [FieldElement<Stark252PrimeField>; 3] = [
        element_from_biguint(&shplonk_z_low),
        element_from_biguint(&shplonk_z_high),
        FieldElement::one().double(),
    ];
    PoseidonCairoStark252::hades_permutation(&mut state);
    let [s0, s1, _] = state;

    (
        ZKHonkTranscript {
            eta,
            eta_two,
            eta_three,
            beta,
            gamma,
            alpha,
            gate_challenge,
            libra_challenge,
            sumcheck_u_challenges,
            rho,
            gemini_r,
            shplonk_nu,
            shplonk_z: shplonk_z_low,
        },
        s0,
        s1,
    )
}

#[allow(clippy::needless_range_loop, clippy::too_many_arguments)]
fn compute_shplemini_msm_scalars(
    log_circuit_size: usize,
    sumcheck_evaluations: &[FieldElement<GrumpkinPrimeField>; NUMBER_OF_ENTITIES],
    gemini_masking_eval: &FieldElement<GrumpkinPrimeField>,
    gemini_a_evaluations: &[FieldElement<GrumpkinPrimeField>; CONST_PROOF_SIZE_LOG_N],
    libra_poly_evals: &[FieldElement<GrumpkinPrimeField>; 4],
    gemini_r: &FieldElement<GrumpkinPrimeField>,
    rho: &FieldElement<GrumpkinPrimeField>,
    shplonk_z: &FieldElement<GrumpkinPrimeField>,
    shplonk_nu: &FieldElement<GrumpkinPrimeField>,
    sumcheck_u_challenges: &[FieldElement<GrumpkinPrimeField>; CONST_PROOF_SIZE_LOG_N],
) -> Result<
    [Option<BigUint>; NUMBER_UNSHIFTED + CONST_PROOF_SIZE_LOG_N + LIBRA_COMMITMENTS + 3],
    FieldError,
> {
    let powers_of_evaluations_challenge = {
        let mut values = vec![];
        let mut value = *gemini_r;
        for _ in 0..log_circuit_size {
            values.push(value);
            value = value * value;
        }
        values
    };

    let mut pos_inverted_denominator = (shplonk_z - powers_of_evaluations_challenge[0]).inv()?;
    let mut neg_inverted_denominator = (shplonk_z + powers_of_evaluations_challenge[0]).inv()?;

    let mut scalars = {
        const NONE: Option<FieldElement<GrumpkinPrimeField>> = None;
        let mut values = [NONE; NUMBER_UNSHIFTED + CONST_PROOF_SIZE_LOG_N + LIBRA_COMMITMENTS + 3];
        for i in 0..values.len() {
            values[i] = Some(FieldElement::zero());
        }
        values
    };

    let unshifted_scalar = pos_inverted_denominator + (shplonk_nu * neg_inverted_denominator);
    let unshifted_scalar_neg = -unshifted_scalar;

    let shifted_scalar_neg =
        -(gemini_r.inv()? * (pos_inverted_denominator - (shplonk_nu * neg_inverted_denominator)));

    scalars[0] = Some(FieldElement::one());

    let mut batched_evaluation = *gemini_masking_eval;
    let mut batching_challenge = *rho;
    scalars[1] = Some(unshifted_scalar_neg);

    for i in 0..NUMBER_UNSHIFTED {
        scalars[i + 2] = Some(unshifted_scalar_neg * batching_challenge);
        batched_evaluation += sumcheck_evaluations[i] * batching_challenge;
        batching_challenge *= rho;
    }

    for i in 0..NUMBER_TO_BE_SHIFTED {
        let scalar_offset = i + SHIFTED_COMMITMENTS_START;
        let evaluation_offset = i + NUMBER_UNSHIFTED;
        scalars[scalar_offset] =
            Some(scalars[scalar_offset].unwrap() + (shifted_scalar_neg * batching_challenge));
        batched_evaluation += sumcheck_evaluations[evaluation_offset] * batching_challenge;
        // skip last round:
        if i < NUMBER_TO_BE_SHIFTED - 1 {
            batching_challenge *= rho;
        }
    }

    // computeFoldPosEvaluations
    let fold_pos_evaluations = {
        let mut values = vec![FieldElement::from(0); CONST_PROOF_SIZE_LOG_N];
        let mut batched_eval_accumulator = batched_evaluation;
        for i in (0..log_circuit_size).rev() {
            let challenge_power = &powers_of_evaluations_challenge[i];
            let u = &sumcheck_u_challenges[i];
            let eval_neg = &gemini_a_evaluations[i];
            let term = challenge_power * (FieldElement::<GrumpkinPrimeField>::one() - u);
            let batched_eval_round_acc = (FieldElement::<GrumpkinPrimeField>::from(2)
                * challenge_power
                * batched_eval_accumulator)
                - (eval_neg * (term - u));
            let den = term + u;
            batched_eval_accumulator = batched_eval_round_acc * den.inv()?;
            values[i] = batched_eval_accumulator;
        }
        values
    };

    let mut constant_term_accumulator = fold_pos_evaluations[0] * pos_inverted_denominator;
    constant_term_accumulator += gemini_a_evaluations[0] * shplonk_nu * neg_inverted_denominator;

    let mut batching_challenge = shplonk_nu * shplonk_nu;

    let boundary = NUMBER_UNSHIFTED + 2;

    for i in 0..log_circuit_size - 1 {
        pos_inverted_denominator = (shplonk_z - powers_of_evaluations_challenge[i + 1]).inv()?;
        neg_inverted_denominator = (shplonk_z + powers_of_evaluations_challenge[i + 1]).inv()?;

        let scaling_factor_pos = batching_challenge * pos_inverted_denominator;
        let scaling_factor_neg = batching_challenge * shplonk_nu * neg_inverted_denominator;
        scalars[boundary + i] = Some(-(scaling_factor_neg + scaling_factor_pos));

        let mut accum_contribution = scaling_factor_neg * gemini_a_evaluations[i + 1];
        accum_contribution += scaling_factor_pos * fold_pos_evaluations[i + 1];
        constant_term_accumulator += accum_contribution;

        batching_challenge *= shplonk_nu * shplonk_nu;
    }

    let boundary = boundary + log_circuit_size - 1;

    let subgroup_generator = FieldElement::<GrumpkinPrimeField>::from_hex_unchecked(
        "07B0C561A6148404F086204A9F36FFB0617942546750F230C893619174A57A76",
    );

    let mut denominators = vec![];
    denominators
        .push((FieldElement::<GrumpkinPrimeField>::from(1) / (shplonk_z - gemini_r)).unwrap());
    denominators.push(
        (FieldElement::<GrumpkinPrimeField>::from(1) / (shplonk_z - subgroup_generator * gemini_r))
            .unwrap(),
    );
    denominators.push(denominators[0]);
    denominators.push(denominators[0]);

    let mut batching_scalars = vec![];
    batching_challenge *= shplonk_nu * shplonk_nu;
    for i in 0..LIBRA_EVALUATIONS {
        let scaling_factor = denominators[i] * batching_challenge;
        batching_scalars.push(-scaling_factor);
        // skip last step:
        if i < LIBRA_EVALUATIONS - 1 {
            batching_challenge *= shplonk_nu;
        }
        constant_term_accumulator += scaling_factor * libra_poly_evals[i];
    }
    scalars[boundary] = Some(batching_scalars[0]);
    scalars[boundary + 1] = Some(batching_scalars[1] + batching_scalars[2]);
    scalars[boundary + 2] = Some(batching_scalars[3]);

    scalars[boundary + 3] = Some(constant_term_accumulator);
    scalars[boundary + 4] = Some(*shplonk_z);

    Ok(scalars
        .into_iter()
        .map(|v| v.map(|e| element_to_biguint(&e)))
        .collect::<Vec<_>>()
        .try_into()
        .unwrap())
}

fn check_evals_consistency(
    libra_evaluation: &FieldElement<GrumpkinPrimeField>,
    libra_poly_evals: &[FieldElement<GrumpkinPrimeField>; 4],
    gemini_r: &FieldElement<GrumpkinPrimeField>,
    sumcheck_u_challenges: &[FieldElement<GrumpkinPrimeField>; CONST_PROOF_SIZE_LOG_N],
    log_circuit_size: usize,
) -> Result<bool, FieldError> {
    let vanishing_poly_eval =
        gemini_r.pow(SUBGROUP_SIZE) - FieldElement::<GrumpkinPrimeField>::from(1);
    if vanishing_poly_eval == FieldElement::<GrumpkinPrimeField>::from(0) {
        return Ok(false);
    }

    let mut challenge_poly_lagrange =
        vec![FieldElement::<GrumpkinPrimeField>::from(0); SUBGROUP_SIZE];
    challenge_poly_lagrange[0] = FieldElement::<GrumpkinPrimeField>::from(1);
    for round in 0..log_circuit_size {
        let curr_idx = 1 + LIBRA_UNIVARIATES_LENGTH * round;
        challenge_poly_lagrange[curr_idx] = FieldElement::<GrumpkinPrimeField>::from(1);
        for idx in curr_idx + 1..curr_idx + LIBRA_UNIVARIATES_LENGTH {
            challenge_poly_lagrange[idx] =
                challenge_poly_lagrange[idx - 1] * sumcheck_u_challenges[round];
        }
    }

    let subgroup_generator_inverse = FieldElement::<GrumpkinPrimeField>::from_hex_unchecked(
        "204bd3277422fad364751ad938e2b5e6a54cf8c68712848a692c553d0329f5d6",
    );

    let mut root_power = FieldElement::<GrumpkinPrimeField>::from(1);
    let mut challenge_poly_eval = FieldElement::<GrumpkinPrimeField>::from(0);
    let mut denominators = vec![FieldElement::<GrumpkinPrimeField>::from(0); SUBGROUP_SIZE];
    for idx in 0..SUBGROUP_SIZE {
        denominators[idx] = root_power * gemini_r - FieldElement::<GrumpkinPrimeField>::from(1);
        denominators[idx] = denominators[idx].inv()?;
        challenge_poly_eval += challenge_poly_lagrange[idx] * denominators[idx];
        // skip last step:
        if idx < SUBGROUP_SIZE - 1 {
            root_power *= subgroup_generator_inverse;
        }
    }

    let numerator = vanishing_poly_eval
        * FieldElement::<GrumpkinPrimeField>::from(SUBGROUP_SIZE as u64).inv()?;
    challenge_poly_eval *= numerator;
    let lagrange_first = denominators[0] * numerator;
    let lagrange_last = denominators[SUBGROUP_SIZE - 1] * numerator;

    let mut diff = lagrange_first * libra_poly_evals[2];
    diff += (gemini_r - subgroup_generator_inverse)
        * (libra_poly_evals[1] - libra_poly_evals[2] - libra_poly_evals[0] * challenge_poly_eval);
    diff = diff + lagrange_last * (libra_poly_evals[2] - libra_evaluation)
        - vanishing_poly_eval * libra_poly_evals[3];
    if diff != FieldElement::<GrumpkinPrimeField>::from(0) {
        return Ok(false);
    }

    Ok(true)
}

fn extract_msm_scalars(
    log_circuit_size: usize,
    scalars: [Option<BigUint>; NUMBER_UNSHIFTED + CONST_PROOF_SIZE_LOG_N + LIBRA_COMMITMENTS + 3],
) -> Vec<BigUint> {
    // Remove first element (==1)
    // scalars[1..NUMBER_UNSHIFTED+2] are the unshifted/shifted scalars
    // scalars[NUMBER_UNSHIFTED+2..NUMBER_UNSHIFTED+2+log_n-1] are gemini fold comm scalars
    // scalars[NUMBER_UNSHIFTED+2+log_n-1..NUMBER_UNSHIFTED+2+log_n-1+5] are libra + final scalars
    let gemini_end = NUMBER_UNSHIFTED + 2 + log_circuit_size - 1;
    let libra_start = gemini_end;
    let libra_end = libra_start + 5; // 3 libra + constant_term + shplonk_z

    [&scalars[1..gemini_end], &scalars[libra_start..libra_end]]
        .concat()
        .into_iter()
        .flatten()
        .collect()
}
