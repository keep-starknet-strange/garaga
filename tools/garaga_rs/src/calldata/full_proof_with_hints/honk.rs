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
use crate::io::{
    element_from_biguint, element_from_bytes_be, element_to_biguint, field_element_to_u256_limbs,
};
use lambdaworks_crypto::hash::poseidon::starknet::PoseidonCairoStark252;
use lambdaworks_crypto::hash::poseidon::Poseidon;
use lambdaworks_math::field::errors::FieldError;
use lambdaworks_math::field::traits::IsPrimeField;
use lambdaworks_math::traits::ByteConversion;
use num_bigint::BigUint;
use sha3::{Digest, Keccak256};

pub const PROOF_SIZE: usize = 440;
pub const BATCHED_RELATION_PARTIAL_LENGTH: usize = 8;
pub const CONST_PROOF_SIZE_LOG_N: usize = 28;
pub const NUMBER_OF_SUBRELATIONS: usize = 26;
pub const NUMBER_OF_ALPHAS: usize = NUMBER_OF_SUBRELATIONS - 1;
pub const NUMBER_OF_ENTITIES: usize = 40;
pub const NUMBER_UNSHIFTED: usize = 35;
pub const MAX_LOG_N: usize = 23;
pub const MAX_CIRCUIT_SIZE: usize = 1 << MAX_LOG_N; // 2^23 = 8388608

pub enum HonkFlavor {
    KECCAK = 0,
    STARKNET = 1,
}

impl TryFrom<usize> for HonkFlavor {
    type Error = String;

    fn try_from(value: usize) -> Result<Self, Self::Error> {
        match value {
            0 => Ok(HonkFlavor::KECCAK),
            1 => Ok(HonkFlavor::STARKNET),
            _ => Err(format!("Invalid honk flavor: {}", value)),
        }
    }
}

pub struct HonkVerificationKey {
    pub circuit_size: usize,
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
    pub q_aux: G1PointBigUint,
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
}

impl HonkVerificationKey {
    pub fn from_bytes(bytes: &[u8]) -> Result<Self, String> {
        if bytes.len() != 4 * 8 + 27 * 2 * 32 {
            return Err(format!("Invalid input length: {}", bytes.len()));
        }

        let mut values = vec![];

        for i in (0..).step_by(8).take(4) {
            values.push(BigUint::from_bytes_be(bytes[i..i + 8].try_into().unwrap()));
        }

        for i in (4 * 8..).step_by(32).take(27 * 2) {
            values.push(BigUint::from_bytes_be(&bytes[i..i + 32]));
        }

        Self::from(values)
    }
    pub fn from(values: Vec<BigUint>) -> Result<Self, String> {
        if values.len() != 4 + 27 * 2 {
            return Err(format!("Invalid input length: {}", values.len()));
        }

        let mut consts = vec![];

        for value in values.iter().take(4) {
            let err_fn = |e: num_bigint::TryFromBigIntError<BigUint>| e.to_string();
            consts.push(value.clone().try_into().map_err(err_fn)?);
        }

        let mut points = vec![];

        for i in (4..).step_by(2).take(27) {
            points.push(G1PointBigUint::from(values[i..i + 2].to_vec()));
        }

        let [circuit_size, log_circuit_size, public_inputs_size, public_inputs_offset] =
            consts.try_into().unwrap();

        let [qm, qc, ql, qr, qo, q4, q_lookup, q_arith, q_delta_range, q_elliptic, q_aux, q_poseidon2_external, q_poseidon2_internal, s1, s2, s3, s4, id1, id2, id3, id4, t1, t2, t3, t4, lagrange_first, lagrange_last] =
            points.try_into().unwrap();

        if circuit_size > MAX_CIRCUIT_SIZE {
            return Err(format!("Invalid circuit size: {}", circuit_size));
        }

        if log_circuit_size > CONST_PROOF_SIZE_LOG_N {
            return Err(format!("Invalid log circuit size: {}", log_circuit_size));
        }

        if public_inputs_offset != 1 {
            return Err(format!(
                "Invalid public inputs offset: {}",
                log_circuit_size
            ));
        }

        let vk = Self {
            circuit_size,
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
            q_aux,
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
        };

        Ok(vk)
    }
}

pub struct HonkProof {
    pub public_inputs: Vec<BigUint>,
    pub w1: G1PointBigUint,
    pub w2: G1PointBigUint,
    pub w3: G1PointBigUint,
    pub w4: G1PointBigUint,
    pub z_perm: G1PointBigUint,
    pub lookup_read_counts: G1PointBigUint,
    pub lookup_read_tags: G1PointBigUint,
    pub lookup_inverses: G1PointBigUint,
    pub sumcheck_univariates: [[BigUint; BATCHED_RELATION_PARTIAL_LENGTH]; CONST_PROOF_SIZE_LOG_N],
    pub sumcheck_evaluations: [BigUint; NUMBER_OF_ENTITIES],
    pub gemini_fold_comms: [G1PointBigUint; CONST_PROOF_SIZE_LOG_N - 1],
    pub gemini_a_evaluations: [BigUint; CONST_PROOF_SIZE_LOG_N],
    pub shplonk_q: G1PointBigUint,
    pub kzg_quotient: G1PointBigUint,
}

impl HonkProof {
    pub fn from_bytes(bytes: &[u8]) -> Result<Self, String> {
        if bytes.len() < 4 {
            return Err(format!("Invalid input length: {}", bytes.len()));
        }

        let count: usize = u32::from_be_bytes(bytes[0..4].try_into().unwrap())
            .try_into()
            .unwrap();

        if bytes.len() != 4 + 32 * count {
            return Err(format!("Invalid input length: {}", bytes.len()));
        }

        let mut values = vec![];

        for i in (4..).step_by(32).take(count) {
            values.push(BigUint::from_bytes_be(&bytes[i..i + 32]));
        }

        Self::from(values)
    }
    pub fn from(values: Vec<BigUint>) -> Result<Self, String> {
        if values.len() < PROOF_SIZE {
            return Err(format!("Invalid input length: {}", values.len()));
        }

        let public_inputs_size = values.len() - PROOF_SIZE;

        let mut offset = 0;

        let count = public_inputs_size
            + 8 * 4
            + BATCHED_RELATION_PARTIAL_LENGTH * CONST_PROOF_SIZE_LOG_N
            + NUMBER_OF_ENTITIES
            + (CONST_PROOF_SIZE_LOG_N - 1) * 4
            + CONST_PROOF_SIZE_LOG_N
            + 2 * 4;
        if values.len() != count {
            return Err(format!("Invalid input length: {}", values.len()));
        }

        let mut public_inputs = vec![];
        for i in (offset..).step_by(1).take(public_inputs_size) {
            public_inputs.push(values[i].clone());
        }
        offset += public_inputs_size;

        fn parse_g1_proof_point(values: [BigUint; 4]) -> G1PointBigUint {
            let [x0, x1, y0, y1] = values;
            let x = (x1 << 136) | x0;
            let y = (y1 << 136) | y0;
            G1PointBigUint::from(vec![x, y])
        }

        let mut points = vec![];
        for i in (offset..).step_by(4).take(8) {
            points.push(parse_g1_proof_point(
                values[i..i + 4].to_vec().try_into().unwrap(),
            ));
        }
        offset += 8 * 4;
        let [w1, w2, w3, lookup_read_counts, lookup_read_tags, w4, lookup_inverses, z_perm] =
            points.try_into().unwrap();

        let mut sumcheck_univariates = vec![];
        for i in (offset..)
            .step_by(BATCHED_RELATION_PARTIAL_LENGTH)
            .take(CONST_PROOF_SIZE_LOG_N)
        {
            let mut sumcheck_univariate = vec![];
            for j in (i..).step_by(1).take(BATCHED_RELATION_PARTIAL_LENGTH) {
                sumcheck_univariate.push(values[j].clone());
            }
            let sumcheck_univariate = sumcheck_univariate.try_into().unwrap();
            sumcheck_univariates.push(sumcheck_univariate);
        }
        let sumcheck_univariates = sumcheck_univariates.try_into().unwrap();
        offset += CONST_PROOF_SIZE_LOG_N * BATCHED_RELATION_PARTIAL_LENGTH;

        let mut sumcheck_evaluations = vec![];
        for i in (offset..).step_by(1).take(NUMBER_OF_ENTITIES) {
            sumcheck_evaluations.push(values[i].clone());
        }
        let sumcheck_evaluations = sumcheck_evaluations.try_into().unwrap();
        offset += NUMBER_OF_ENTITIES;

        let mut gemini_fold_comms = vec![];
        for i in (offset..).step_by(4).take(CONST_PROOF_SIZE_LOG_N - 1) {
            gemini_fold_comms.push(parse_g1_proof_point(
                values[i..i + 4].to_vec().try_into().unwrap(),
            ));
        }
        let gemini_fold_comms = gemini_fold_comms.try_into().unwrap();
        offset += (CONST_PROOF_SIZE_LOG_N - 1) * 4;

        let mut gemini_a_evaluations = vec![];
        for i in (offset..).step_by(1).take(CONST_PROOF_SIZE_LOG_N) {
            gemini_a_evaluations.push(values[i].clone());
        }
        let gemini_a_evaluations = gemini_a_evaluations.try_into().unwrap();
        offset += CONST_PROOF_SIZE_LOG_N;

        let mut points = vec![];
        for i in (offset..).step_by(4).take(2) {
            points.push(parse_g1_proof_point(
                values[i..i + 4].to_vec().try_into().unwrap(),
            ));
        }
        let [shplonk_q, kzg_quotient] = points.try_into().unwrap();
        offset += 4 * 2;

        assert_eq!(offset, count);

        let proof = Self {
            public_inputs,
            w1,
            w2,
            w3,
            w4,
            z_perm,
            lookup_read_counts,
            lookup_read_tags,
            lookup_inverses,
            sumcheck_univariates,
            sumcheck_evaluations,
            gemini_fold_comms,
            gemini_a_evaluations,
            shplonk_q,
            kzg_quotient,
        };

        Ok(proof)
    }
}

pub struct HonkTranscript {
    pub eta: BigUint,
    pub eta_two: BigUint,
    pub eta_three: BigUint,
    pub beta: BigUint,
    pub gamma: BigUint,
    pub alphas: [BigUint; NUMBER_OF_ALPHAS],
    pub gate_challenges: [BigUint; CONST_PROOF_SIZE_LOG_N],
    pub sumcheck_u_challenges: [BigUint; CONST_PROOF_SIZE_LOG_N],
    pub rho: BigUint,
    pub gemini_r: BigUint,
    pub shplonk_nu: BigUint,
    pub shplonk_z: BigUint,
}

impl HonkTranscript {
    pub fn from_proof(
        vk: &HonkVerificationKey,
        proof: &HonkProof,
        flavor: HonkFlavor,
    ) -> Result<Self, String> {
        if proof.public_inputs.len() != vk.public_inputs_size {
            return Err(format!(
                "Public inputs length mismatch: proof {}, vk {}",
                proof.public_inputs.len(),
                vk.public_inputs_size
            ));
        }
        match flavor {
            HonkFlavor::KECCAK => Ok(compute_transcript(vk, proof, KeccakHasher::new())),
            HonkFlavor::STARKNET => Ok(compute_transcript(vk, proof, StarknetHasher::new())),
        }
    }
}

pub fn get_honk_calldata(
    proof: &HonkProof,
    vk: &HonkVerificationKey,
    flavor: HonkFlavor,
) -> Result<Vec<BigUint>, String> {
    let transcript = HonkTranscript::from_proof(vk, proof, flavor)?;

    fn element_on_curve(element: &BigUint) -> FieldElement<GrumpkinPrimeField> {
        element_from_biguint(element)
    }

    fn g1_point_on_curve(point: &G1PointBigUint) -> Result<G1Point<BN254PrimeField>, String> {
        G1Point::new(
            element_from_biguint(&point.x),
            element_from_biguint(&point.y),
        )
    }

    let public_inputs = proof
        .public_inputs
        .iter()
        .map(element_on_curve)
        .collect::<Vec<_>>();
    let w1 = g1_point_on_curve(&proof.w1)?;
    let w2 = g1_point_on_curve(&proof.w2)?;
    let w3 = g1_point_on_curve(&proof.w3)?;
    let w4 = g1_point_on_curve(&proof.w4)?;
    let z_perm = g1_point_on_curve(&proof.z_perm)?;
    let lookup_read_counts = g1_point_on_curve(&proof.lookup_read_counts)?;
    let lookup_read_tags = g1_point_on_curve(&proof.lookup_read_tags)?;
    let lookup_inverses = g1_point_on_curve(&proof.lookup_inverses)?;
    let sumcheck_univariates = proof
        .sumcheck_univariates
        .iter()
        .map(|v| v.iter().map(element_on_curve).collect::<Vec<_>>())
        .collect::<Vec<_>>();
    let sumcheck_evaluations = proof
        .sumcheck_evaluations
        .iter()
        .map(element_on_curve)
        .collect::<Vec<_>>()
        .try_into()
        .unwrap();
    let gemini_fold_comms = proof
        .gemini_fold_comms
        .iter()
        .map(g1_point_on_curve)
        .collect::<Result<Vec<_>, _>>()?;
    let gemini_a_evaluations = proof
        .gemini_a_evaluations
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
    let q_aux = g1_point_on_curve(&vk.q_aux)?;
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

    let sumcheck_u_challenges = transcript
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

    let scalars = extract_msm_scalars(
        vk.log_circuit_size,
        compute_shplemini_msm_scalars(
            vk.log_circuit_size,
            &sumcheck_evaluations,
            &gemini_a_evaluations,
            &gemini_r,
            &rho,
            &shplonk_z,
            &shplonk_nu,
            &sumcheck_u_challenges,
        )
        .map_err(|e| format!("Field error: {:?}", e))?,
    );

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
        push_point(call_data_ref, &w1);
        push_point(call_data_ref, &w2);
        push_point(call_data_ref, &w3);
        push_point(call_data_ref, &w4);
        push_point(call_data_ref, &z_perm);
        push_point(call_data_ref, &lookup_read_counts);
        push_point(call_data_ref, &lookup_read_tags);
        push_point(call_data_ref, &lookup_inverses);
        push_elements(
            call_data_ref,
            &(0..vk.log_circuit_size)
                .flat_map(|i| sumcheck_univariates[i].clone())
                .collect::<Vec<_>>(),
            true,
        );
        push_elements(call_data_ref, &sumcheck_evaluations, true);
        push(call_data_ref, vk.log_circuit_size - 1);
        for point in &gemini_fold_comms[..vk.log_circuit_size - 1] {
            push_point(call_data_ref, point);
        }
        push_elements(
            call_data_ref,
            &gemini_a_evaluations[..vk.log_circuit_size],
            true,
        );
        push_point(call_data_ref, &shplonk_q);
        push_point(call_data_ref, &kzg_quotient);

        call_data
    };

    let mut points = vec![
        qm,                   // 1
        qc,                   // 2
        ql,                   // 3
        qr,                   // 4
        qo,                   // 5
        q4,                   // 6
        q_lookup,             // 7
        q_arith,              // 8
        q_delta_range,        // 9
        q_elliptic,           // 10
        q_aux,                // 11
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
        w1,                   // 28
        w2,                   // 29
        w3,                   // 30
        w4,                   // 31
        z_perm,               // 32
        lookup_inverses,      // 33
        lookup_read_counts,   // 34
        lookup_read_tags,     // 35
    ];

    points.extend(gemini_fold_comms[0..vk.log_circuit_size - 1].to_vec());
    points.push(G1Point::generator());
    points.push(kzg_quotient.clone());

    let msm_data = msm_calldata::calldata_builder(
        &points,
        &scalars,
        CurveID::BN254 as usize,
        None,
        false,
        false,
        false,
    );

    let p_0 = G1Point::msm(&points, &scalars).add(&shplonk_q);
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

pub trait Hasher {
    fn reset(&mut self);
    fn digest_as_element(&self) -> FieldElement<GrumpkinPrimeField>;
    fn update_as_element(&mut self, element: &FieldElement<GrumpkinPrimeField>);
    fn digest(&self) -> BigUint {
        element_to_biguint(&self.digest_as_element())
    }
    fn digest_reset(&mut self) -> BigUint {
        let result = self.digest();
        self.reset();
        result
    }
    fn update(&mut self, value: &BigUint) {
        self.update_as_element(&element_from_biguint(value));
    }
    fn update_as_point(&mut self, point: &G1PointBigUint) {
        let mask: BigUint = (BigUint::from(1usize) << 136) - 1usize;
        let x0 = point.x.clone() & mask.clone();
        let x1 = point.x.clone() >> 136;
        let y0 = point.y.clone() & mask;
        let y1 = point.y.clone() >> 136;
        self.update(&x0);
        self.update(&x1);
        self.update(&y0);
        self.update(&y1);
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
    fn update_as_element(&mut self, element: &FieldElement<GrumpkinPrimeField>) {
        let bytes = element.to_bytes_be();
        let padding = 32 - bytes.len();
        if padding > 0 {
            self.data.extend(vec![0; padding]);
        }
        self.data.extend(bytes);
    }
    fn digest_as_element(&self) -> FieldElement<GrumpkinPrimeField> {
        element_from_bytes_be(&Keccak256::digest(&self.data))
    }
}

pub struct StarknetHasher {
    state: [FieldElement<Stark252PrimeField>; 3],
}

impl Default for StarknetHasher {
    fn default() -> Self {
        Self::new()
    }
}

impl StarknetHasher {
    pub fn new() -> Self {
        let mut hasher = StarknetHasher {
            state: [FieldElement::zero(); 3],
        };
        hasher.reset();
        hasher
    }
}

impl Hasher for StarknetHasher {
    fn reset(&mut self) {
        self.state = [
            FieldElement::from_hex_unchecked("537461726B6E6574486F6E6B"), // StarknetHonk
            FieldElement::zero(),
            FieldElement::one(),
        ];
        PoseidonCairoStark252::hades_permutation(&mut self.state);
    }
    fn update_as_element(&mut self, element: &FieldElement<GrumpkinPrimeField>) {
        let limbs = field_element_to_u256_limbs(element);
        let values = limbs.map(|v| element_from_biguint::<Stark252PrimeField>(&BigUint::from(v)));
        self.state[0] += values[0];
        self.state[1] += values[1];
        PoseidonCairoStark252::hades_permutation(&mut self.state);
    }
    fn digest_as_element(&self) -> FieldElement<GrumpkinPrimeField> {
        element_from_biguint(&element_to_biguint(&self.state[0]))
    }
}

#[allow(clippy::needless_range_loop)]
fn compute_transcript<T: Hasher>(
    vk: &HonkVerificationKey,
    proof: &HonkProof,
    mut hasher: T,
) -> HonkTranscript {
    fn split(value: &BigUint) -> [BigUint; 2] {
        let element: FieldElement<GrumpkinPrimeField> = element_from_biguint(value);
        let limbs = field_element_to_u256_limbs(&element);
        limbs.map(BigUint::from)
    }

    // Round 0 : circuit_size, public_inputs_size, public_input_offset, [public_inputs], w1, w2, w3
    hasher.update(&BigUint::from(vk.circuit_size));
    hasher.update(&BigUint::from(vk.public_inputs_size));
    hasher.update(&BigUint::from(vk.public_inputs_offset));
    for public_input in &proof.public_inputs {
        hasher.update(public_input);
    }
    hasher.update_as_point(&proof.w1);
    hasher.update_as_point(&proof.w2);
    hasher.update_as_point(&proof.w3);

    let ch0 = hasher.digest_reset();
    let [eta, eta_two] = split(&ch0);

    hasher.update(&ch0);

    let ch0 = hasher.digest_reset();
    let [eta_three, _] = split(&ch0);

    // Round 1 : ch0, lookup_read_counts, lookup_read_tags, w4
    hasher.update(&ch0);
    hasher.update_as_point(&proof.lookup_read_counts);
    hasher.update_as_point(&proof.lookup_read_tags);
    hasher.update_as_point(&proof.w4);

    let ch1 = hasher.digest_reset();
    let [beta, gamma] = split(&ch1);

    // Round 2: ch1, lookup_inverses, z_perm
    hasher.update(&ch1);
    hasher.update_as_point(&proof.lookup_inverses);
    hasher.update_as_point(&proof.z_perm);

    let mut alphas = [0u8; NUMBER_OF_ALPHAS].map(BigUint::from);

    let mut ch2 = hasher.digest_reset();
    [alphas[0], alphas[1]] = split(&ch2);

    for i in 1..NUMBER_OF_ALPHAS / 2 {
        hasher.update(&ch2);

        ch2 = hasher.digest_reset();
        [alphas[i * 2], alphas[i * 2 + 1]] = split(&ch2);
    }

    if NUMBER_OF_ALPHAS % 2 == 1 {
        hasher.update(&ch2);

        ch2 = hasher.digest_reset();
        [alphas[NUMBER_OF_ALPHAS - 1], _] = split(&ch2);
    }

    // Round 3: Gate Challenges :
    let mut gate_challenges = [0u8; CONST_PROOF_SIZE_LOG_N].map(BigUint::from);

    let mut ch3 = ch2;
    for i in 0..CONST_PROOF_SIZE_LOG_N {
        hasher.update(&ch3);

        ch3 = hasher.digest_reset();
        [gate_challenges[i], _] = split(&ch3);
    }

    // Round 4: Sumcheck u challenges
    let mut sumcheck_u_challenges = [0u8; CONST_PROOF_SIZE_LOG_N].map(BigUint::from);

    let mut ch4 = ch3;
    for i in 0..CONST_PROOF_SIZE_LOG_N {
        hasher.update(&ch4);
        for j in 0..BATCHED_RELATION_PARTIAL_LENGTH {
            hasher.update(&proof.sumcheck_univariates[i][j]);
        }

        ch4 = hasher.digest_reset();
        [sumcheck_u_challenges[i], _] = split(&ch4);
    }

    // Rho challenge :
    hasher.update(&ch4);
    for i in 0..NUMBER_OF_ENTITIES {
        hasher.update(&proof.sumcheck_evaluations[i]);
    }

    let c5 = hasher.digest_reset();
    let [rho, _] = split(&c5);

    // Gemini R :
    hasher.update(&c5);
    for i in 0..CONST_PROOF_SIZE_LOG_N - 1 {
        hasher.update_as_point(&proof.gemini_fold_comms[i]);
    }

    let c6 = hasher.digest_reset();
    let [gemini_r, _] = split(&c6);

    // Shplonk Nu :
    hasher.update(&c6);
    for i in 0..CONST_PROOF_SIZE_LOG_N {
        hasher.update(&proof.gemini_a_evaluations[i]);
    }

    let c7 = hasher.digest_reset();
    let [shplonk_nu, _] = split(&c7);

    // Shplonk Z :
    hasher.update(&c7);
    hasher.update_as_point(&proof.shplonk_q);

    let c8 = hasher.digest_reset();
    let [shplonk_z, _] = split(&c8);

    HonkTranscript {
        eta,
        eta_two,
        eta_three,
        beta,
        gamma,
        alphas,
        gate_challenges,
        sumcheck_u_challenges,
        rho,
        gemini_r,
        shplonk_nu,
        shplonk_z,
    }
}

#[allow(clippy::needless_range_loop, clippy::too_many_arguments)]
fn compute_shplemini_msm_scalars(
    log_circuit_size: usize,
    sumcheck_evaluations: &[FieldElement<GrumpkinPrimeField>; NUMBER_OF_ENTITIES],
    gemini_a_evaluations: &[FieldElement<GrumpkinPrimeField>; CONST_PROOF_SIZE_LOG_N],
    gemini_r: &FieldElement<GrumpkinPrimeField>,
    rho: &FieldElement<GrumpkinPrimeField>,
    shplonk_z: &FieldElement<GrumpkinPrimeField>,
    shplonk_nu: &FieldElement<GrumpkinPrimeField>,
    sumcheck_u_challenges: &[FieldElement<GrumpkinPrimeField>; CONST_PROOF_SIZE_LOG_N],
) -> Result<[Option<BigUint>; NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 2], FieldError> {
    let powers_of_evaluations_challenge = {
        let mut values = vec![];
        let mut value = gemini_r.clone();
        for _ in 0..log_circuit_size {
            values.push(value.clone());
            value = &value * &value;
        }
        values
    };

    let mut pos_inverted_denominator = (shplonk_z - &powers_of_evaluations_challenge[0]).inv()?;
    let mut neg_inverted_denominator = (shplonk_z + &powers_of_evaluations_challenge[0]).inv()?;

    let mut scalars = {
        const NONE: Option<FieldElement<GrumpkinPrimeField>> = None;
        let mut values = [NONE; NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 2];
        for i in 0..values.len() {
            values[i] = Some(FieldElement::zero());
        }
        values
    };

    scalars[0] = Some(FieldElement::one());

    let mut batched_evaluation = FieldElement::zero();

    {
        let mut batching_challenge = FieldElement::one();

        {
            let unshifted_scalar =
                -(&pos_inverted_denominator + (shplonk_nu * &neg_inverted_denominator));
            for i in 1..NUMBER_UNSHIFTED + 1 {
                scalars[i] = Some(&unshifted_scalar * &batching_challenge);
                batched_evaluation += &sumcheck_evaluations[i - 1] * &batching_challenge;
                batching_challenge *= rho;
            }
        }

        {
            let shifted_scalar = -(gemini_r.inv()?
                * (&pos_inverted_denominator - (shplonk_nu * &neg_inverted_denominator)));
            for i in NUMBER_UNSHIFTED + 1..NUMBER_OF_ENTITIES + 1 {
                scalars[i] = Some(&shifted_scalar * &batching_challenge);
                batched_evaluation += &sumcheck_evaluations[i - 1] * &batching_challenge;
                // skip last round:
                if i < NUMBER_OF_ENTITIES {
                    batching_challenge *= rho;
                }
            }
        }
    }

    let fold_pos_evaluations = {
        let mut values = vec![FieldElement::from(0); CONST_PROOF_SIZE_LOG_N];
        let mut batched_eval_accumulator = batched_evaluation.clone();
        for i in (0..log_circuit_size).rev() {
            let challenge_power = &powers_of_evaluations_challenge[i];
            let u = &sumcheck_u_challenges[i];
            let eval_neg = &gemini_a_evaluations[i];
            let term = challenge_power * (FieldElement::<GrumpkinPrimeField>::one() - u);
            let batched_eval_round_acc = (FieldElement::<GrumpkinPrimeField>::from(2)
                * challenge_power
                * &batched_eval_accumulator)
                - (eval_neg * (&term - u));
            let den = term + u;
            batched_eval_accumulator = batched_eval_round_acc * den.inv()?;
            values[i] = batched_eval_accumulator.clone();
        }
        values
    };

    let mut constant_term_accumulator = &fold_pos_evaluations[0] * pos_inverted_denominator;
    constant_term_accumulator += &gemini_a_evaluations[0] * shplonk_nu * &neg_inverted_denominator;

    {
        let mut batching_challenge = shplonk_nu * shplonk_nu;

        for i in 0..CONST_PROOF_SIZE_LOG_N - 1 {
            let dummy_round = i >= (log_circuit_size - 1);
            if !dummy_round {
                pos_inverted_denominator =
                    (shplonk_z - &powers_of_evaluations_challenge[i + 1]).inv()?;
                neg_inverted_denominator =
                    (shplonk_z + &powers_of_evaluations_challenge[i + 1]).inv()?;

                let scaling_factor_pos = &batching_challenge * pos_inverted_denominator;
                let scaling_factor_neg =
                    &batching_challenge * shplonk_nu * neg_inverted_denominator;
                scalars[NUMBER_OF_ENTITIES + i + 1] =
                    Some(-(&scaling_factor_neg + &scaling_factor_pos));

                let mut accum_contribution = scaling_factor_neg * &gemini_a_evaluations[i + 1];
                accum_contribution += scaling_factor_pos * &fold_pos_evaluations[i + 1];
                constant_term_accumulator += accum_contribution;
            }
            // skip last round:
            if i < log_circuit_size - 2 {
                batching_challenge *= shplonk_nu * shplonk_nu;
            }
        }
    }

    scalars[NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N] = Some(constant_term_accumulator.clone());
    scalars[NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 1] = Some(shplonk_z.clone());

    // proof.w1 : 28 + 36
    // proof.w2 : 29 + 37
    // proof.w3 : 30 + 38
    // proof.w4 : 31 + 39

    scalars[28] = Some(scalars[28].clone().unwrap() + scalars[36].clone().unwrap());
    scalars[29] = Some(scalars[29].clone().unwrap() + scalars[37].clone().unwrap());
    scalars[30] = Some(scalars[30].clone().unwrap() + scalars[38].clone().unwrap());
    scalars[31] = Some(scalars[31].clone().unwrap() + scalars[39].clone().unwrap());
    scalars[32] = Some(scalars[32].clone().unwrap() + scalars[40].clone().unwrap());

    scalars[36] = None;
    scalars[37] = None;
    scalars[38] = None;
    scalars[39] = None;
    scalars[40] = None;

    Ok(scalars
        .into_iter()
        .map(|v| v.map(|e| element_to_biguint(&e)))
        .collect::<Vec<_>>()
        .try_into()
        .unwrap())
}

fn extract_msm_scalars(
    log_circuit_size: usize,
    scalars: [Option<BigUint>; NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 2],
) -> Vec<BigUint> {
    let i = NUMBER_OF_ENTITIES + log_circuit_size;
    let j = NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N;
    [&scalars[1..i], &scalars[j..]]
        .concat()
        .into_iter()
        .flatten()
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_honk_keccak_calldata() -> std::io::Result<()> {
        let vk = get_honk_vk()?;
        let proof = get_honk_keccak_proof()?;
        let call_data = get_honk_calldata(&proof, &vk, HonkFlavor::KECCAK).unwrap();
        let bytes = call_data
            .into_iter()
            .flat_map(|v| v.to_bytes_be())
            .collect::<Vec<_>>();
        let digest = Keccak256::digest(&bytes).to_vec();
        let expected_digest = [
            0, 114, 105, 230, 232, 63, 110, 100, 74, 147, 156, 143, 183, 170, 25, 146, 248, 91,
            194, 189, 245, 199, 5, 48, 168, 123, 211, 116, 232, 76, 43, 127,
        ];
        assert_eq!(digest, expected_digest);
        Ok(())
    }

    #[test]
    fn test_honk_starknet_calldata() -> std::io::Result<()> {
        let vk = get_honk_vk()?;
        let proof = get_honk_starknet_proof()?;
        let call_data = get_honk_calldata(&proof, &vk, HonkFlavor::STARKNET).unwrap();
        let bytes = call_data
            .into_iter()
            .flat_map(|v| v.to_bytes_be())
            .collect::<Vec<_>>();
        let digest = Keccak256::digest(&bytes).to_vec();
        let expected_digest = [
            4, 228, 157, 181, 2, 45, 246, 172, 225, 118, 235, 3, 98, 59, 123, 33, 182, 250, 143,
            76, 59, 148, 7, 173, 4, 99, 70, 149, 164, 128, 0, 167,
        ];
        assert_eq!(digest, expected_digest);
        Ok(())
    }

    fn get_honk_vk() -> std::io::Result<HonkVerificationKey> {
        use std::fs::File;
        use std::io::Read;
        let mut file = File::open(
            "../../hydra/garaga/starknet/honk_contract_generator/examples/vk_ultra_keccak.bin",
        )?;
        let mut bytes = vec![];
        file.read_to_end(&mut bytes)?;
        let vk = HonkVerificationKey::from_bytes(&bytes).unwrap();
        Ok(vk)
    }

    fn get_honk_keccak_proof() -> std::io::Result<HonkProof> {
        use std::fs::File;
        use std::io::Read;
        let mut file = File::open(
            "../../hydra/garaga/starknet/honk_contract_generator/examples/proof_ultra_keccak.bin",
        )?;
        let mut bytes = vec![];
        file.read_to_end(&mut bytes)?;
        let proof = HonkProof::from_bytes(&bytes).unwrap();
        Ok(proof)
    }

    fn get_honk_starknet_proof() -> std::io::Result<HonkProof> {
        use std::fs::File;
        use std::io::Read;
        let mut file = File::open(
            "../../hydra/garaga/starknet/honk_contract_generator/examples/proof_ultra_starknet.bin",
        )?;
        let mut bytes = vec![];
        file.read_to_end(&mut bytes)?;
        let proof = HonkProof::from_bytes(&bytes).unwrap();
        Ok(proof)
    }
}
