use crate::algebra::g1g2pair::G1G2Pair;
use crate::algebra::g1point::G1Point;
use crate::algebra::g2point::G2Point;
use crate::calldata::full_proof_with_hints::honk::{
    Hasher, HonkFlavor, HonkVerificationKey, KeccakHasher, StarknetHasher, CONST_PROOF_SIZE_LOG_N,
    NUMBER_OF_ALPHAS, NUMBER_OF_ENTITIES, NUMBER_UNSHIFTED,
};
use crate::calldata::mpc_calldata;
use crate::calldata::msm_calldata;
use crate::calldata::G1PointBigUint;
use crate::definitions::BN254PrimeField;
use crate::definitions::CurveID;
use crate::definitions::FieldElement;
use crate::definitions::GrumpkinPrimeField;
use crate::io::{element_from_biguint, element_to_biguint, field_element_to_u256_limbs};
use lambdaworks_math::field::errors::FieldError;
use lambdaworks_math::field::traits::IsPrimeField;
use lambdaworks_math::traits::ByteConversion;
use num_bigint::BigUint;

pub const ZK_PROOF_SIZE: usize = 491;
pub const ZK_BATCHED_RELATION_PARTIAL_LENGTH: usize = 9;
pub const SUBGROUP_SIZE: usize = 256;

pub struct ZKHonkProof {
    pub public_inputs: Vec<BigUint>,
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
        if values.len() < ZK_PROOF_SIZE {
            return Err(format!("Invalid input length: {}", values.len()));
        }

        let public_inputs_size = values.len() - ZK_PROOF_SIZE;

        let mut offset = 0;

        let count = public_inputs_size
            + 11 * 4
            + 1
            + ZK_BATCHED_RELATION_PARTIAL_LENGTH * CONST_PROOF_SIZE_LOG_N
            + NUMBER_OF_ENTITIES
            + 1
            + 4
            + 1
            + (CONST_PROOF_SIZE_LOG_N - 1) * 4
            + CONST_PROOF_SIZE_LOG_N
            + 4
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
        for i in (offset..).step_by(4).take(9) {
            points.push(parse_g1_proof_point(
                values[i..i + 4].to_vec().try_into().unwrap(),
            ));
        }
        offset += 9 * 4;
        let [w1, w2, w3, lookup_read_counts, lookup_read_tags, w4, lookup_inverses, z_perm, libra_commitment_0] =
            points.try_into().unwrap();

        let libra_sum = values[offset].clone();
        offset += 1;

        let mut sumcheck_univariates = vec![];
        for i in (offset..)
            .step_by(ZK_BATCHED_RELATION_PARTIAL_LENGTH)
            .take(CONST_PROOF_SIZE_LOG_N)
        {
            let mut sumcheck_univariate = vec![];
            for j in (i..).step_by(1).take(ZK_BATCHED_RELATION_PARTIAL_LENGTH) {
                sumcheck_univariate.push(values[j].clone());
            }
            let sumcheck_univariate = sumcheck_univariate.try_into().unwrap();
            sumcheck_univariates.push(sumcheck_univariate);
        }
        let sumcheck_univariates = sumcheck_univariates.try_into().unwrap();
        offset += CONST_PROOF_SIZE_LOG_N * ZK_BATCHED_RELATION_PARTIAL_LENGTH;

        let mut sumcheck_evaluations = vec![];
        for i in (offset..).step_by(1).take(NUMBER_OF_ENTITIES) {
            sumcheck_evaluations.push(values[i].clone());
        }
        let sumcheck_evaluations = sumcheck_evaluations.try_into().unwrap();
        offset += NUMBER_OF_ENTITIES;

        let libra_evaluation = values[offset].clone();
        offset += 1;

        let mut points = vec![];
        for i in (offset..).step_by(4).take(3) {
            points.push(parse_g1_proof_point(
                values[i..i + 4].to_vec().try_into().unwrap(),
            ));
        }
        offset += 3 * 4;
        let [libra_commitment_1, libra_commitment_2, gemini_masking_poly] =
            points.try_into().unwrap();

        let libra_commitments = [libra_commitment_0, libra_commitment_1, libra_commitment_2];

        let gemini_masking_eval = values[offset].clone();
        offset += 1;

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

        let libra_poly_evals = values[offset..offset + 4].to_vec().try_into().unwrap();
        offset += 4;

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
        };

        Ok(proof)
    }
}

pub struct ZKHonkTranscript {
    pub eta: BigUint,
    pub eta_two: BigUint,
    pub eta_three: BigUint,
    pub beta: BigUint,
    pub gamma: BigUint,
    pub alphas: [BigUint; NUMBER_OF_ALPHAS],
    pub gate_challenges: [BigUint; CONST_PROOF_SIZE_LOG_N],
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
            HonkFlavor::KECCAK => Ok(compute_zk_transcript(vk, proof, KeccakHasher::new())),
            HonkFlavor::STARKNET => Ok(compute_zk_transcript(vk, proof, StarknetHasher::new())),
        }
    }
}

pub fn get_zk_honk_calldata(
    proof: &ZKHonkProof,
    vk: &HonkVerificationKey,
    flavor: HonkFlavor,
) -> Result<Vec<BigUint>, String> {
    let transcript = ZKHonkTranscript::from_proof(vk, proof, flavor)?;

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
    let libra_commitments = proof
        .libra_commitments
        .iter()
        .map(g1_point_on_curve)
        .collect::<Result<Vec<_>, _>>()?;
    let libra_sum = element_on_curve(&proof.libra_sum);
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
    let libra_evaluation = element_on_curve(&proof.libra_evaluation);
    let gemini_masking_poly = g1_point_on_curve(&proof.gemini_masking_poly)?;
    let gemini_masking_eval = element_on_curve(&proof.gemini_masking_eval);
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
    let libra_poly_evals = proof
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

    let consistent = check_evals_consistency(
        &libra_evaluation,
        &libra_poly_evals,
        &gemini_r,
        &sumcheck_u_challenges,
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
        gemini_masking_poly,  // 1
        qm,                   // 2
        qc,                   // 3
        ql,                   // 4
        qr,                   // 5
        qo,                   // 6
        q4,                   // 7
        q_lookup,             // 8
        q_arith,              // 9
        q_delta_range,        // 10
        q_elliptic,           // 11
        q_aux,                // 12
        q_poseidon2_external, // 13
        q_poseidon2_internal, // 14
        s1,                   // 15
        s2,                   // 16
        s3,                   // 17
        s4,                   // 18
        id1,                  // 19
        id2,                  // 20
        id3,                  // 21
        id4,                  // 22
        t1,                   // 23
        t2,                   // 24
        t3,                   // 25
        t4,                   // 26
        lagrange_first,       // 27
        lagrange_last,        // 28
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

#[allow(clippy::needless_range_loop)]
fn compute_zk_transcript<T: Hasher>(
    vk: &HonkVerificationKey,
    proof: &ZKHonkProof,
    mut hasher: T,
) -> ZKHonkTranscript {
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

    // Round 3 and 1/2: Libra challenge
    hasher.update(&ch3);

    hasher.update_as_point(&proof.libra_commitments[0]);
    hasher.update(&proof.libra_sum);

    ch3 = hasher.digest_reset();
    let [libra_challenge, _] = split(&ch3);

    // Round 4: Sumcheck u challenges
    let mut sumcheck_u_challenges = [0u8; CONST_PROOF_SIZE_LOG_N].map(BigUint::from);

    let mut ch4 = ch3;
    for i in 0..CONST_PROOF_SIZE_LOG_N {
        hasher.update(&ch4);
        for j in 0..ZK_BATCHED_RELATION_PARTIAL_LENGTH {
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

    hasher.update(&proof.libra_evaluation);
    hasher.update_as_point(&proof.libra_commitments[1]);
    hasher.update_as_point(&proof.libra_commitments[2]);
    hasher.update_as_point(&proof.gemini_masking_poly);
    hasher.update(&proof.gemini_masking_eval);

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

    for i in 0..4 {
        hasher.update(&proof.libra_poly_evals[i]);
    }

    let c7 = hasher.digest_reset();
    let [shplonk_nu, _] = split(&c7);

    // Shplonk Z :
    hasher.update(&c7);
    hasher.update_as_point(&proof.shplonk_q);

    let c8 = hasher.digest_reset();
    let [shplonk_z, _] = split(&c8);

    ZKHonkTranscript {
        eta,
        eta_two,
        eta_three,
        beta,
        gamma,
        alphas,
        gate_challenges,
        libra_challenge,
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
    gemini_masking_eval: &FieldElement<GrumpkinPrimeField>,
    gemini_a_evaluations: &[FieldElement<GrumpkinPrimeField>; CONST_PROOF_SIZE_LOG_N],
    libra_poly_evals: &[FieldElement<GrumpkinPrimeField>; 4],
    gemini_r: &FieldElement<GrumpkinPrimeField>,
    rho: &FieldElement<GrumpkinPrimeField>,
    shplonk_z: &FieldElement<GrumpkinPrimeField>,
    shplonk_nu: &FieldElement<GrumpkinPrimeField>,
    sumcheck_u_challenges: &[FieldElement<GrumpkinPrimeField>; CONST_PROOF_SIZE_LOG_N],
) -> Result<[Option<BigUint>; NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 3 + 3], FieldError> {
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
        let mut values = [NONE; NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 3 + 3];
        for i in 0..values.len() {
            values[i] = Some(FieldElement::zero());
        }
        values
    };

    let unshifted_scalar = -(&pos_inverted_denominator + (shplonk_nu * &neg_inverted_denominator));

    let shifted_scalar =
        -(gemini_r.inv()? * (&pos_inverted_denominator - (shplonk_nu * &neg_inverted_denominator)));

    scalars[0] = Some(FieldElement::one());

    let mut batched_evaluation = gemini_masking_eval.clone();
    let mut batching_challenge = rho.clone();
    scalars[1] = Some(unshifted_scalar.clone());

    for i in 2..NUMBER_UNSHIFTED + 2 {
        scalars[i] = Some(&unshifted_scalar * &batching_challenge);
        batched_evaluation += &sumcheck_evaluations[i - 2] * &batching_challenge;
        batching_challenge *= rho;
    }
    for i in NUMBER_UNSHIFTED + 2..NUMBER_OF_ENTITIES + 2 {
        scalars[i] = Some(&shifted_scalar * &batching_challenge);
        batched_evaluation += &sumcheck_evaluations[i - 2] * &batching_challenge;
        // skip last round:
        if i < NUMBER_OF_ENTITIES + 1 {
            batching_challenge *= rho;
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

    let mut batching_challenge = shplonk_nu * shplonk_nu;

    for i in 0..CONST_PROOF_SIZE_LOG_N - 1 {
        let dummy_round = i >= (log_circuit_size - 1);
        if !dummy_round {
            pos_inverted_denominator =
                (shplonk_z - &powers_of_evaluations_challenge[i + 1]).inv()?;
            neg_inverted_denominator =
                (shplonk_z + &powers_of_evaluations_challenge[i + 1]).inv()?;

            let scaling_factor_pos = &batching_challenge * pos_inverted_denominator;
            let scaling_factor_neg = &batching_challenge * shplonk_nu * neg_inverted_denominator;
            scalars[NUMBER_OF_ENTITIES + i + 2] =
                Some(-(&scaling_factor_neg + &scaling_factor_pos));

            let mut accum_contribution = scaling_factor_neg * &gemini_a_evaluations[i + 1];
            accum_contribution += scaling_factor_pos * &fold_pos_evaluations[i + 1];
            constant_term_accumulator += accum_contribution;
        }
        batching_challenge *= shplonk_nu * shplonk_nu;
    }

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
    denominators.push(denominators[0].clone());
    denominators.push(denominators[0].clone());

    let mut batching_scalars = vec![];
    batching_challenge *= shplonk_nu * shplonk_nu;
    for i in 0..4 {
        let scaling_factor = &denominators[i] * &batching_challenge;
        batching_scalars.push(-&scaling_factor);
        batching_challenge *= shplonk_nu;
        constant_term_accumulator += &scaling_factor * &libra_poly_evals[i];
    }
    scalars[NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 1] = Some(batching_scalars[0].clone());
    scalars[NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 2] =
        Some(&batching_scalars[1] + &batching_scalars[2]);
    scalars[NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 3] = Some(batching_scalars[3].clone());

    scalars[NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 4] =
        Some(constant_term_accumulator.clone());
    scalars[NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 5] = Some(shplonk_z.clone());

    // proof.w1 : 29 + 37
    // proof.w2 : 30 + 38
    // proof.w3 : 31 + 39
    // proof.w4 : 32 + 40

    scalars[29] = Some(scalars[29].clone().unwrap() + scalars[37].clone().unwrap());
    scalars[30] = Some(scalars[30].clone().unwrap() + scalars[38].clone().unwrap());
    scalars[31] = Some(scalars[31].clone().unwrap() + scalars[39].clone().unwrap());
    scalars[32] = Some(scalars[32].clone().unwrap() + scalars[40].clone().unwrap());
    scalars[33] = Some(scalars[33].clone().unwrap() + scalars[41].clone().unwrap()); // z_perm

    scalars[37] = None;
    scalars[38] = None;
    scalars[39] = None;
    scalars[40] = None;
    scalars[41] = None;
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
) -> Result<bool, FieldError> {
    let vanishing_poly_eval =
        gemini_r.pow(SUBGROUP_SIZE) - FieldElement::<GrumpkinPrimeField>::from(1);
    if vanishing_poly_eval == FieldElement::<GrumpkinPrimeField>::from(0) {
        return Ok(false);
    }

    let mut challenge_poly_lagrange =
        vec![FieldElement::<GrumpkinPrimeField>::from(0); SUBGROUP_SIZE];
    challenge_poly_lagrange[0] = FieldElement::<GrumpkinPrimeField>::from(1);
    for round in 0..CONST_PROOF_SIZE_LOG_N {
        let curr_idx = 1 + 9 * round;
        challenge_poly_lagrange[curr_idx] = FieldElement::<GrumpkinPrimeField>::from(1);
        for idx in curr_idx + 1..curr_idx + 9 {
            challenge_poly_lagrange[idx] =
                &challenge_poly_lagrange[idx - 1] * &sumcheck_u_challenges[round];
        }
    }

    let subgroup_generator_inverse = FieldElement::<GrumpkinPrimeField>::from_hex_unchecked(
        "204bd3277422fad364751ad938e2b5e6a54cf8c68712848a692c553d0329f5d6",
    );

    let mut root_power = FieldElement::<GrumpkinPrimeField>::from(1);
    let mut challenge_poly_eval = FieldElement::<GrumpkinPrimeField>::from(0);
    let mut denominators = vec![FieldElement::<GrumpkinPrimeField>::from(0); SUBGROUP_SIZE];
    for idx in 0..SUBGROUP_SIZE {
        denominators[idx] = &root_power * gemini_r - FieldElement::<GrumpkinPrimeField>::from(1);
        denominators[idx] = denominators[idx].inv()?;
        challenge_poly_eval =
            &challenge_poly_eval + &challenge_poly_lagrange[idx] * &denominators[idx];
        root_power = &root_power * &subgroup_generator_inverse;
    }

    let numerator = &vanishing_poly_eval
        * FieldElement::<GrumpkinPrimeField>::from(SUBGROUP_SIZE as u64).inv()?;
    challenge_poly_eval = &challenge_poly_eval * &numerator;
    let lagrange_first = &denominators[0] * &numerator;
    let lagrange_last = &denominators[SUBGROUP_SIZE - 1] * &numerator;

    let mut diff = &lagrange_first * &libra_poly_evals[2];
    diff += (gemini_r - &subgroup_generator_inverse)
        * (&libra_poly_evals[1]
            - &libra_poly_evals[2]
            - &libra_poly_evals[0] * &challenge_poly_eval);
    diff = &diff + &lagrange_last * (&libra_poly_evals[2] - libra_evaluation)
        - &vanishing_poly_eval * &libra_poly_evals[3];
    if diff != FieldElement::<GrumpkinPrimeField>::from(0) {
        return Ok(false);
    }

    Ok(true)
}

fn extract_msm_scalars(
    log_circuit_size: usize,
    scalars: [Option<BigUint>; NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 3 + 3],
) -> Vec<BigUint> {
    let i = 1 + NUMBER_OF_ENTITIES + log_circuit_size;
    let j = 1 + NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N;
    [&scalars[1..i], &scalars[j..]]
        .concat()
        .into_iter()
        .flatten()
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;
    use sha3::{Digest, Keccak256};

    #[test]
    fn test_zk_honk_keccak_calldata() -> std::io::Result<()> {
        let vk = get_honk_vk()?;
        let proof = get_zk_honk_keccak_proof()?;
        let call_data = get_zk_honk_calldata(&proof, &vk, HonkFlavor::KECCAK).unwrap();
        let bytes = call_data
            .into_iter()
            .flat_map(|v| v.to_bytes_be())
            .collect::<Vec<_>>();
        let digest = Keccak256::digest(&bytes).to_vec();
        let expected_digest = [
            125, 85, 239, 129, 30, 251, 252, 169, 54, 43, 80, 131, 68, 74, 229, 44, 56, 244, 58,
            236, 166, 205, 209, 228, 52, 127, 78, 156, 52, 143, 243, 20,
        ];
        assert_eq!(digest, expected_digest);
        Ok(())
    }

    #[test]
    fn test_zk_honk_starknet_calldata() -> std::io::Result<()> {
        let vk = get_honk_vk()?;
        let proof = get_zk_honk_starknet_proof()?;
        let call_data = get_zk_honk_calldata(&proof, &vk, HonkFlavor::STARKNET).unwrap();
        let bytes = call_data
            .into_iter()
            .flat_map(|v| v.to_bytes_be())
            .collect::<Vec<_>>();
        let digest = Keccak256::digest(&bytes).to_vec();
        let expected_digest = [
            228, 82, 60, 144, 112, 204, 209, 43, 72, 227, 232, 132, 190, 76, 60, 70, 232, 6, 94,
            10, 205, 96, 33, 110, 153, 194, 135, 97, 114, 123, 126, 178,
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

    fn get_zk_honk_keccak_proof() -> std::io::Result<ZKHonkProof> {
        use std::fs::File;
        use std::io::Read;
        let mut file = File::open(
            "../../hydra/garaga/starknet/honk_contract_generator/examples/proof_ultra_keccak_zk.bin",
        )?;
        let mut bytes = vec![];
        file.read_to_end(&mut bytes)?;
        let proof = ZKHonkProof::from_bytes(&bytes).unwrap();
        Ok(proof)
    }

    fn get_zk_honk_starknet_proof() -> std::io::Result<ZKHonkProof> {
        use std::fs::File;
        use std::io::Read;
        let mut file = File::open(
            "../../hydra/garaga/starknet/honk_contract_generator/examples/proof_ultra_starknet_zk.bin",
        )?;
        let mut bytes = vec![];
        file.read_to_end(&mut bytes)?;
        let proof = ZKHonkProof::from_bytes(&bytes).unwrap();
        Ok(proof)
    }
}
