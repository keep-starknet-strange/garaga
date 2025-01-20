use crate::algebra::g1g2pair::G1G2Pair;
use crate::algebra::g1point::G1Point;
use crate::algebra::g2point::G2Point;
use crate::calldata::mpc_calldata;
use crate::calldata::msm_calldata;
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
use lambdaworks_math::field::traits::IsPrimeField;
use lambdaworks_math::traits::ByteConversion;
use num_bigint::BigUint;
use sha3::{Digest, Sha3_256};

const BATCHED_RELATION_PARTIAL_LENGTH: usize = 8;
const CONST_PROOF_SIZE_LOG_N: usize = 28;
const NUMBER_OF_SUBRELATIONS: usize = 26;
const NUMBER_OF_ALPHAS: usize = NUMBER_OF_SUBRELATIONS - 1;
const NUMBER_OF_ENTITIES: usize = 44;
const NUMBER_UNSHIFTED: usize = 35;

pub enum HonkFlavor {
    KECCAK = 0,
    STARKNET = 1,
}

pub struct HonkVk {
    pub circuit_size: u64,
    pub log_circuit_size: u64,
    pub public_inputs_size: u64,
    pub public_inputs_offset: u64,
    pub qm: G1Point<BN254PrimeField>,
    pub qc: G1Point<BN254PrimeField>,
    pub ql: G1Point<BN254PrimeField>,
    pub qr: G1Point<BN254PrimeField>,
    pub qo: G1Point<BN254PrimeField>,
    pub q4: G1Point<BN254PrimeField>,
    pub q_arith: G1Point<BN254PrimeField>,
    pub q_delta_range: G1Point<BN254PrimeField>,
    pub q_elliptic: G1Point<BN254PrimeField>,
    pub q_aux: G1Point<BN254PrimeField>,
    pub q_lookup: G1Point<BN254PrimeField>,
    pub q_poseidon2_external: G1Point<BN254PrimeField>,
    pub q_poseidon2_internal: G1Point<BN254PrimeField>,
    pub s1: G1Point<BN254PrimeField>,
    pub s2: G1Point<BN254PrimeField>,
    pub s3: G1Point<BN254PrimeField>,
    pub s4: G1Point<BN254PrimeField>,
    pub id1: G1Point<BN254PrimeField>,
    pub id2: G1Point<BN254PrimeField>,
    pub id3: G1Point<BN254PrimeField>,
    pub id4: G1Point<BN254PrimeField>,
    pub t1: G1Point<BN254PrimeField>,
    pub t2: G1Point<BN254PrimeField>,
    pub t3: G1Point<BN254PrimeField>,
    pub t4: G1Point<BN254PrimeField>,
    pub lagrange_first: G1Point<BN254PrimeField>,
    pub lagrange_last: G1Point<BN254PrimeField>,
}

pub struct HonkProof {
    pub circuit_size: u64,
    pub public_inputs_size: u64,
    pub public_inputs_offset: u64,
    pub public_inputs: Vec<FieldElement<GrumpkinPrimeField>>,
    pub w1: G1Point<BN254PrimeField>,
    pub w2: G1Point<BN254PrimeField>,
    pub w3: G1Point<BN254PrimeField>,
    pub w4: G1Point<BN254PrimeField>,
    pub z_perm: G1Point<BN254PrimeField>,
    pub lookup_read_counts: G1Point<BN254PrimeField>,
    pub lookup_read_tags: G1Point<BN254PrimeField>,
    pub lookup_inverses: G1Point<BN254PrimeField>,
    pub sumcheck_univariates: [[FieldElement<GrumpkinPrimeField>; BATCHED_RELATION_PARTIAL_LENGTH];
        CONST_PROOF_SIZE_LOG_N],
    pub sumcheck_evaluations: [FieldElement<GrumpkinPrimeField>; NUMBER_OF_ENTITIES],
    pub gemini_fold_comms: [G1Point<BN254PrimeField>; CONST_PROOF_SIZE_LOG_N - 1],
    pub gemini_a_evaluations: [FieldElement<GrumpkinPrimeField>; CONST_PROOF_SIZE_LOG_N],
    pub shplonk_q: G1Point<BN254PrimeField>,
    pub kzg_quotient: G1Point<BN254PrimeField>,
}

pub struct HonkTranscript {
    pub eta: FieldElement<GrumpkinPrimeField>,
    pub eta_two: FieldElement<GrumpkinPrimeField>,
    pub eta_three: FieldElement<GrumpkinPrimeField>,
    pub beta: FieldElement<GrumpkinPrimeField>,
    pub gamma: FieldElement<GrumpkinPrimeField>,
    pub alphas: [FieldElement<GrumpkinPrimeField>; NUMBER_OF_ALPHAS],
    pub gate_challenges: [FieldElement<GrumpkinPrimeField>; CONST_PROOF_SIZE_LOG_N],
    pub sum_check_u_challenges: [FieldElement<GrumpkinPrimeField>; CONST_PROOF_SIZE_LOG_N],
    pub rho: FieldElement<GrumpkinPrimeField>,
    pub gemini_r: FieldElement<GrumpkinPrimeField>,
    pub shplonk_nu: FieldElement<GrumpkinPrimeField>,
    pub shplonk_z: FieldElement<GrumpkinPrimeField>,
}

pub fn get_ultra_flavor_honk_calldata_from_vk_and_proof(
    flavor: HonkFlavor,
    vk: HonkVk,
    proof: HonkProof,
) -> Vec<BigUint> {
    let tp = honk_transcript_from_proof(flavor, &proof);

    let proof_data =
        serialize_honk_proof_to_calldata(&proof, vk.log_circuit_size.try_into().unwrap());

    let scalars = circuit_compute_shplemini_msm_scalars(
        vk.log_circuit_size.try_into().unwrap(),
        &proof.sumcheck_evaluations,
        &proof.gemini_a_evaluations,
        &tp.gemini_r,
        &tp.rho,
        &tp.shplonk_z,
        &tp.shplonk_nu,
        &tp.sum_check_u_challenges,
    );

    let scalars_msm = extract_msm_scalars(&scalars, vk.log_circuit_size.try_into().unwrap());

    let mut points = vec![
        vk.qm,                    // 1
        vk.qc,                    // 2
        vk.ql,                    // 3
        vk.qr,                    // 4
        vk.qo,                    // 5
        vk.q4,                    // 6
        vk.q_arith,               // 7
        vk.q_delta_range,         // 8
        vk.q_elliptic,            // 9
        vk.q_aux,                 // 10
        vk.q_lookup,              // 11
        vk.q_poseidon2_external,  // 12
        vk.q_poseidon2_internal,  // 13
        vk.s1,                    // 14
        vk.s2,                    // 15
        vk.s3,                    // 16
        vk.s4,                    // 17
        vk.id1,                   // 18
        vk.id2,                   // 19
        vk.id3,                   // 20
        vk.id4,                   // 21
        vk.t1,                    // 22
        vk.t2,                    // 23
        vk.t3,                    // 24
        vk.t4,                    // 25
        vk.lagrange_first,        // 26
        vk.lagrange_last,         // 27
        proof.w1,                 // 28
        proof.w2,                 // 29
        proof.w3,                 // 30
        proof.w4,                 // 31
        proof.z_perm.clone(),     // 32
        proof.lookup_inverses,    // 33
        proof.lookup_read_counts, // 34
        proof.lookup_read_tags,   // 35
        proof.z_perm,             // 44
    ];
    points.extend(proof.gemini_fold_comms[0..(vk.log_circuit_size - 1) as usize].to_vec());
    points.push(G1Point::generator());
    points.push(proof.kzg_quotient.clone());

    let msm_data = msm_calldata::calldata_builder(
        &points,
        &scalars_msm,
        CurveID::BN254 as usize,
        None,
        false,
        false,
        false,
    );

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
    )
    .unwrap();

    let p_0 = G1Point::msm(&points, &scalars_msm).add(&proof.shplonk_q);
    let p_1 = proof.kzg_quotient.neg();

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
        >(&pairs, 2, &None)
        .unwrap()
    };

    let size = proof_data.len() + msm_data.len() + mpc_data.len();
    let mut call_data: Vec<BigUint> = vec![size.into()];
    call_data.extend(proof_data);
    call_data.extend(msm_data);
    call_data.extend(mpc_data);
    call_data
}

fn serialize_honk_proof_to_calldata(proof: &HonkProof, log_circuit_size: usize) -> Vec<BigUint> {
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

    fn push_elements<F>(
        call_data_ref: &mut Vec<BigUint>,
        elements: &[FieldElement<F>],
        prepend_length: bool,
    ) where
        F: IsPrimeField,
        FieldElement<F>: ByteConversion,
    {
        if prepend_length {
            push(call_data_ref, elements.len());
        }
        for element in elements {
            push_element::<F>(call_data_ref, element);
        }
    }

    fn push_point<F>(call_data_ref: &mut Vec<BigUint>, point: &G1Point<F>)
    where
        F: IsPrimeField,
        FieldElement<F>: ByteConversion,
    {
        push_element(call_data_ref, &point.x);
        push_element(call_data_ref, &point.y);
    }

    push(call_data_ref, proof.circuit_size);
    push(call_data_ref, proof.public_inputs_size);
    push(call_data_ref, proof.public_inputs_offset);
    push_elements(call_data_ref, &proof.public_inputs, true);
    push_point(call_data_ref, &proof.w1);
    push_point(call_data_ref, &proof.w2);
    push_point(call_data_ref, &proof.w3);
    push_point(call_data_ref, &proof.w4);
    push_point(call_data_ref, &proof.z_perm);
    push_point(call_data_ref, &proof.lookup_read_counts);
    push_point(call_data_ref, &proof.lookup_read_tags);
    push_point(call_data_ref, &proof.lookup_inverses);
    push_elements(
        call_data_ref,
        &(0..log_circuit_size)
            .flat_map(|i| proof.sumcheck_univariates[i].clone())
            .collect::<Vec<_>>(),
        true,
    );
    push_elements(call_data_ref, &proof.sumcheck_evaluations, true);
    push(call_data_ref, log_circuit_size - 1);
    for point in &proof.gemini_fold_comms[..log_circuit_size - 1] {
        push_point(call_data_ref, point);
    }
    push_elements(
        call_data_ref,
        &proof.gemini_a_evaluations[..log_circuit_size],
        true,
    );
    push_point(call_data_ref, &proof.shplonk_q);
    push_point(call_data_ref, &proof.kzg_quotient);

    call_data
}

fn extract_msm_scalars(scalars: &[Option<BigUint>], log_n: usize) -> Vec<BigUint> {
    assert_eq!(
        scalars.len(),
        NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 2
    );
    let start_dummy = NUMBER_OF_ENTITIES + log_n;
    let end_dummy = NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N;
    let scalars_no_dummy = [&scalars[..start_dummy], &scalars[end_dummy..]].concat();
    let scalars_filtered = scalars_no_dummy[1..].to_vec();
    let scalars_filtered_no_nones = scalars_filtered
        .iter()
        .filter_map(|y| y.as_ref())
        .cloned()
        .collect();
    return scalars_filtered_no_nones;
}

pub trait Hasher {
    fn reset(&mut self);
    fn digest(&self) -> FieldElement<GrumpkinPrimeField>;
    fn digest_reset(&mut self) -> FieldElement<GrumpkinPrimeField> {
        let result = self.digest();
        self.reset();
        return result;
    }
    fn update_element(&mut self, element: &FieldElement<GrumpkinPrimeField>);
    fn update_point(&mut self, point: &G1Point<BN254PrimeField>) {
        let [v0, v1] = field_element_to_u256_limbs(&point.x);
        let [v2, v3] = field_element_to_u256_limbs(&point.y);
        let v0 = element_from_biguint(&BigUint::from(v0));
        let v1 = element_from_biguint(&BigUint::from(v1));
        let v2 = element_from_biguint(&BigUint::from(v2));
        let v3 = element_from_biguint(&BigUint::from(v3));
        self.update_element(&v0);
        self.update_element(&v1);
        self.update_element(&v2);
        self.update_element(&v3);
    }
}

pub struct KeccakHasher {
    pub data: Vec<u8>,
}

impl KeccakHasher {
    fn new() -> Self {
        KeccakHasher { data: vec![] }
    }
}

impl Hasher for KeccakHasher {
    fn reset(&mut self) {
        self.data = vec![];
    }
    fn update_element(&mut self, element: &FieldElement<GrumpkinPrimeField>) {
        let b = element.to_bytes_be();
        let padding = 32 - b.len();
        if padding > 0 {
            self.data.extend(vec![0; padding]);
        }
        self.data.extend(b);
    }
    fn digest(&self) -> FieldElement<GrumpkinPrimeField> {
        element_from_bytes_be(&Sha3_256::digest(&self.data).to_vec())
    }
}

pub struct StarknetHasher {
    pub state: [FieldElement<Stark252PrimeField>; 3],
}

impl StarknetHasher {
    fn new() -> Self {
        let mut hasher = StarknetHasher {
            state: [FieldElement::zero(); 3],
        };
        hasher.reset();
        return hasher;
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
    fn update_element(&mut self, element: &FieldElement<GrumpkinPrimeField>) {
        let [v0, v1] = field_element_to_u256_limbs(element);
        let v0 = element_from_biguint::<Stark252PrimeField>(&BigUint::from(v0));
        let v1 = element_from_biguint::<Stark252PrimeField>(&BigUint::from(v1));
        self.state[0] += v0;
        self.state[1] += v1;
        PoseidonCairoStark252::hades_permutation(&mut self.state);
    }
    fn digest(&self) -> FieldElement<GrumpkinPrimeField> {
        element_from_biguint(&element_to_biguint(&self.state[0]))
    }
}

fn honk_transcript_from_proof(flavor: HonkFlavor, proof: &HonkProof) -> HonkTranscript {
    match flavor {
        HonkFlavor::KECCAK => compute_honk_transcript_from_proof(KeccakHasher::new(), proof),
        HonkFlavor::STARKNET => compute_honk_transcript_from_proof(StarknetHasher::new(), proof),
    }
}

fn compute_honk_transcript_from_proof<T: Hasher>(
    mut hasher: T,
    proof: &HonkProof,
) -> HonkTranscript {
    // Round 0 : circuit_size, public_inputs_size, public_input_offset, [public_inputs], w1, w2, w3
    hasher.update_element(&FieldElement::from(proof.circuit_size));
    hasher.update_element(&FieldElement::from(proof.public_inputs_size));
    hasher.update_element(&FieldElement::from(proof.public_inputs_offset));

    for public_input in &proof.public_inputs {
        hasher.update_element(public_input);
    }
    hasher.update_point(&proof.w1);
    hasher.update_point(&proof.w2);
    hasher.update_point(&proof.w3);

    let ch0 = hasher.digest_reset();
    let [eta, eta_two] = field_element_to_u256_limbs(&ch0);
    hasher.update_element(&ch0);
    let ch0 = hasher.digest_reset();
    let [eta_three, _] = field_element_to_u256_limbs(&ch0);

    // Round 1 : ch0, lookup_read_counts, lookup_read_tags, w4
    hasher.update_element(&ch0);
    hasher.update_point(&proof.lookup_read_counts);
    hasher.update_point(&proof.lookup_read_tags);
    hasher.update_point(&proof.w4);
    let ch1 = hasher.digest_reset();
    let [beta, gamma] = field_element_to_u256_limbs(&ch1);

    // Round 2: ch1, lookup_inverses, z_perm
    hasher.update_element(&ch1);
    hasher.update_point(&proof.lookup_inverses);
    hasher.update_point(&proof.z_perm);
    let mut ch2 = hasher.digest_reset();
    let mut alphas = [0u128; NUMBER_OF_ALPHAS];
    [alphas[0], alphas[1]] = field_element_to_u256_limbs(&ch2);
    for i in 1..NUMBER_OF_ALPHAS / 2 {
        hasher.update_element(&ch2);
        ch2 = hasher.digest_reset();
        [alphas[i * 2], alphas[i * 2 + 1]] = field_element_to_u256_limbs(&ch2);
    }

    if NUMBER_OF_ALPHAS % 2 == 1 {
        hasher.update_element(&ch2);
        ch2 = hasher.digest_reset();
        [alphas[NUMBER_OF_ALPHAS - 1], _] = field_element_to_u256_limbs(&ch2);
    }

    // Round 3: Gate Challenges :
    let mut ch3 = ch2;
    let mut gate_challenges = [0u128; CONST_PROOF_SIZE_LOG_N];
    for i in 0..CONST_PROOF_SIZE_LOG_N {
        hasher.update_element(&ch3);
        ch3 = hasher.digest_reset();
        [gate_challenges[i], _] = field_element_to_u256_limbs(&ch3);
    }

    // Round 4: Sumcheck u challenges
    let mut ch4 = ch3;
    let mut sum_check_u_challenges = [0u128; CONST_PROOF_SIZE_LOG_N];

    for i in 0..CONST_PROOF_SIZE_LOG_N {
        // Create array of univariate challenges starting with previous challenge
        let mut univariate_chal = vec![ch4];

        // Add the sumcheck univariates for this round
        for j in 0..BATCHED_RELATION_PARTIAL_LENGTH {
            univariate_chal.push(proof.sumcheck_univariates[i][j].clone());
        }

        // Update hasher with all univariate challenges
        for chal in univariate_chal {
            hasher.update_element(&chal);
        }

        // Get next challenge
        ch4 = hasher.digest_reset();

        // Split challenge to get sumcheck challenge
        [sum_check_u_challenges[i], _] = field_element_to_u256_limbs(&ch4);
    }

    // Rho challenge :
    hasher.update_element(&ch4);
    for i in 0..NUMBER_OF_ENTITIES {
        hasher.update_element(&proof.sumcheck_evaluations[i]);
    }

    let c5 = hasher.digest_reset();
    let [rho, _] = field_element_to_u256_limbs(&c5);

    // Gemini R :
    hasher.update_element(&c5);
    for i in 0..CONST_PROOF_SIZE_LOG_N - 1 {
        hasher.update_point(&proof.gemini_fold_comms[i]);
    }

    let c6 = hasher.digest_reset();
    let [gemini_r, _] = field_element_to_u256_limbs(&c6);

    // Shplonk Nu :
    hasher.update_element(&c6);
    for i in 0..CONST_PROOF_SIZE_LOG_N {
        hasher.update_element(&proof.gemini_a_evaluations[i]);
    }

    let c7 = hasher.digest_reset();
    let [shplonk_nu, _] = field_element_to_u256_limbs(&c7);

    // Shplonk Z :
    hasher.update_element(&c7);
    hasher.update_point(&proof.shplonk_q);

    let c8 = hasher.digest_reset();
    let [shplonk_z, _] = field_element_to_u256_limbs(&c8);

    let eta = element_from_biguint(&BigUint::from(eta));
    let eta_two = element_from_biguint(&BigUint::from(eta_two));
    let eta_three = element_from_biguint(&BigUint::from(eta_three));
    let beta = element_from_biguint(&BigUint::from(beta));
    let gamma = element_from_biguint(&BigUint::from(gamma));
    let alphas = alphas
        .into_iter()
        .map(|v| element_from_biguint(&BigUint::from(v)))
        .collect::<Vec<_>>()
        .try_into()
        .unwrap();
    let gate_challenges = gate_challenges
        .into_iter()
        .map(|v| element_from_biguint(&BigUint::from(v)))
        .collect::<Vec<_>>()
        .try_into()
        .unwrap();
    let sum_check_u_challenges = sum_check_u_challenges
        .into_iter()
        .map(|v| element_from_biguint(&BigUint::from(v)))
        .collect::<Vec<_>>()
        .try_into()
        .unwrap();
    let rho = element_from_biguint(&BigUint::from(rho));
    let gemini_r = element_from_biguint(&BigUint::from(gemini_r));
    let shplonk_nu = element_from_biguint(&BigUint::from(shplonk_nu));
    let shplonk_z = element_from_biguint(&BigUint::from(shplonk_z));

    HonkTranscript {
        eta,
        eta_two,
        eta_three,
        beta,
        gamma,
        alphas,
        gate_challenges,
        sum_check_u_challenges,
        rho,
        gemini_r,
        shplonk_nu,
        shplonk_z,
    }
}

fn circuit_compute_shplemini_msm_scalars(
    log_n: usize,
    p_sumcheck_evaluations: &[FieldElement<GrumpkinPrimeField>; NUMBER_OF_ENTITIES],
    p_gemini_a_evaluations: &[FieldElement<GrumpkinPrimeField>; CONST_PROOF_SIZE_LOG_N],
    tp_gemini_r: &FieldElement<GrumpkinPrimeField>,
    tp_rho: &FieldElement<GrumpkinPrimeField>,
    tp_shplonk_z: &FieldElement<GrumpkinPrimeField>,
    tp_shplonk_nu: &FieldElement<GrumpkinPrimeField>,
    tp_sumcheck_u_challenges: &[FieldElement<GrumpkinPrimeField>; CONST_PROOF_SIZE_LOG_N],
) -> [Option<BigUint>; NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 2] {
    let mut powers_of_evaluations_challenge = vec![tp_gemini_r.clone()];
    for i in 1..log_n {
        let v = &powers_of_evaluations_challenge[i - 1];
        powers_of_evaluations_challenge.push(v * v);
    }

    // computeInvertedGeminiDenominators

    const NONE_F: Option<FieldElement<GrumpkinPrimeField>> = None;
    let mut inverse_vanishing_evals = [NONE_F; CONST_PROOF_SIZE_LOG_N + 1];
    inverse_vanishing_evals[0] = Some(
        (tp_shplonk_z - &powers_of_evaluations_challenge[0])
            .inv()
            .unwrap(),
    );
    for i in 0..log_n {
        inverse_vanishing_evals[i + 1] = Some(
            (tp_shplonk_z + &powers_of_evaluations_challenge[i])
                .inv()
                .unwrap(),
        );
    }

    let unshifted_scalar = -(inverse_vanishing_evals[0].clone().unwrap()
        + tp_shplonk_nu * inverse_vanishing_evals[1].clone().unwrap());

    let shifted_scalar = -(tp_gemini_r.inv().unwrap()
        * (inverse_vanishing_evals[0].clone().unwrap()
            - tp_shplonk_nu * inverse_vanishing_evals[1].clone().unwrap()));

    let mut scalars = [NONE_F; NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 2];

    scalars[0] = Some(FieldElement::<GrumpkinPrimeField>::one());

    let mut batching_challenge = FieldElement::<GrumpkinPrimeField>::one();
    let mut batched_evaluation = FieldElement::<GrumpkinPrimeField>::zero();

    for i in 1..NUMBER_UNSHIFTED + 1 {
        scalars[i] = Some(unshifted_scalar.clone() * batching_challenge.clone());
        batched_evaluation =
            batched_evaluation + p_sumcheck_evaluations[i - 1].clone() * batching_challenge.clone();
        batching_challenge = batching_challenge * tp_rho;
    }

    for i in NUMBER_UNSHIFTED + 1..NUMBER_OF_ENTITIES + 1 {
        scalars[i] = Some(shifted_scalar.clone() * batching_challenge.clone());
        batched_evaluation =
            batched_evaluation + p_sumcheck_evaluations[i - 1].clone() * batching_challenge.clone();
        // skip last round:
        if i < NUMBER_OF_ENTITIES {
            batching_challenge = batching_challenge * tp_rho;
        }
    }

    let mut constant_term_accumulator = FieldElement::<GrumpkinPrimeField>::one();
    let mut batching_challenge = tp_shplonk_nu * tp_shplonk_nu;

    for i in 0..CONST_PROOF_SIZE_LOG_N - 1 {
        let dummy_round = i >= (log_n - 1);
        if !dummy_round {
            let scaling_factor =
                batching_challenge.clone() * inverse_vanishing_evals[i + 2].clone().unwrap();
            scalars[NUMBER_OF_ENTITIES + i + 1] = Some(-scaling_factor.clone());
            constant_term_accumulator =
                constant_term_accumulator + scaling_factor * p_gemini_a_evaluations[i + 1].clone();
        }
        // skip last round:
        if i < log_n - 2 {
            batching_challenge = batching_challenge * tp_shplonk_nu;
        }
    }

    let a_0_pos = compute_gemini_batched_univariate_evaluation(
        tp_sumcheck_u_challenges,
        batched_evaluation,
        p_gemini_a_evaluations,
        &powers_of_evaluations_challenge,
        log_n,
    );

    constant_term_accumulator =
        constant_term_accumulator + a_0_pos * inverse_vanishing_evals[0].clone().unwrap();

    constant_term_accumulator = constant_term_accumulator
        + p_gemini_a_evaluations[0].clone()
            * tp_shplonk_nu
            * inverse_vanishing_evals[1].clone().unwrap();

    scalars[NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N] = Some(constant_term_accumulator.clone());
    scalars[NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 1] = Some(tp_shplonk_z.clone());

    // vk.t1 : 22 + 36
    // vk.t2 : 23 + 37
    // vk.t3 : 24 + 38
    // vk.t4 : 25 + 39

    // proof.w1 : 28 + 40
    // proof.w2 : 29 + 41
    // proof.w3 : 30 + 42
    // proof.w4 : 31 + 43

    scalars[22] = Some(scalars[22].clone().unwrap() + scalars[36].clone().unwrap());
    scalars[23] = Some(scalars[23].clone().unwrap() + scalars[37].clone().unwrap());
    scalars[24] = Some(scalars[24].clone().unwrap() + scalars[38].clone().unwrap());
    scalars[25] = Some(scalars[25].clone().unwrap() + scalars[39].clone().unwrap());

    scalars[28] = Some(scalars[28].clone().unwrap() + scalars[40].clone().unwrap());
    scalars[29] = Some(scalars[29].clone().unwrap() + scalars[41].clone().unwrap());
    scalars[30] = Some(scalars[30].clone().unwrap() + scalars[42].clone().unwrap());
    scalars[31] = Some(scalars[31].clone().unwrap() + scalars[43].clone().unwrap());

    scalars[36] = None;
    scalars[37] = None;
    scalars[38] = None;
    scalars[39] = None;
    scalars[40] = None;
    scalars[41] = None;
    scalars[42] = None;
    scalars[43] = None;

    scalars
        .iter()
        .map(|v| v.as_ref().map(|e| element_to_biguint(e)))
        .collect::<Vec<_>>()
        .try_into()
        .unwrap()
}

fn compute_gemini_batched_univariate_evaluation(
    tp_sumcheck_u_challenges: &[FieldElement<GrumpkinPrimeField>; CONST_PROOF_SIZE_LOG_N],
    batched_eval_accumulator: FieldElement<GrumpkinPrimeField>,
    gemini_evaluations: &[FieldElement<GrumpkinPrimeField>; CONST_PROOF_SIZE_LOG_N],
    gemini_eval_challenge_powers: &[FieldElement<GrumpkinPrimeField>],
    log_n: usize,
) -> FieldElement<GrumpkinPrimeField> {
    let mut batched_eval_accumulator = batched_eval_accumulator;
    for i in (0..log_n).rev() {
        let challenge_power = &gemini_eval_challenge_powers[i];
        let u = &tp_sumcheck_u_challenges[i];
        let eval_neg = &gemini_evaluations[i];
        let term = challenge_power * (FieldElement::<GrumpkinPrimeField>::one() - u);
        let batched_eval_round_acc = (FieldElement::<GrumpkinPrimeField>::from(2)
            * challenge_power
            * batched_eval_accumulator.clone())
            - (eval_neg * (term.clone() - u));
        let den = term + u;
        batched_eval_accumulator = batched_eval_round_acc * den.inv().unwrap();
    }
    batched_eval_accumulator
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_honk_keccak_calldata() {
        let vk = get_honk_vk();
        let proof = get_honk_keccak_proof();
        let call_data =
            get_ultra_flavor_honk_calldata_from_vk_and_proof(HonkFlavor::KECCAK, vk, proof);
        let expected_call_data = get_honk_keccak_expected_calldata();
        assert_eq!(call_data, expected_call_data);
    }

    #[test]
    fn test_honk_starknet_calldata() {
        let vk = get_honk_vk();
        let proof = get_honk_starknet_proof();
        let call_data =
            get_ultra_flavor_honk_calldata_from_vk_and_proof(HonkFlavor::STARKNET, vk, proof);
        let expected_call_data = get_honk_starknet_expected_calldata();
        assert_eq!(call_data, expected_call_data);
    }

    fn get_honk_vk() -> HonkVk {
        HonkVk {
            circuit_size: 32,
            log_circuit_size: 5,
            public_inputs_size: 1,
            public_inputs_offset: 1,
            qm: G1Point::<BN254PrimeField>::new(
                FieldElement::from_hex_unchecked(
                    "415666cb60796632caf35af5543a21e67a579d04b4a44a243c68df3f358c697",
                ),
                FieldElement::from_hex_unchecked(
                    "13cfcaddb617e8f25669052529424eb317e1aac8221768e740f92361b30c2d62",
                ),
            )
            .unwrap(),
            qc: G1Point::<BN254PrimeField>::new(
                FieldElement::from_hex_unchecked(
                    "c5f79c354ff1aed5809ac290a982776516b8c609d99fb66b26ccca2668ae6a8",
                ),
                FieldElement::from_hex_unchecked(
                    "e50425d1b09a4fe3ee886d57c3f18044dd8b7570205ce031ec8bb3ffa1999a4",
                ),
            )
            .unwrap(),
            ql: G1Point::<BN254PrimeField>::new(
                FieldElement::from_hex_unchecked(
                    "276ed9e001db810f4011bf5c5de9f0d417ce67e6f241677faff2882cb6d3e72d",
                ),
                FieldElement::from_hex_unchecked(
                    "8eb9210acaa389635855693b62013016015f094460254d4d7e89a4f280678c1",
                ),
            )
            .unwrap(),
            qr: G1Point::<BN254PrimeField>::new(
                FieldElement::from_hex_unchecked(
                    "9dfb00e38302724d39a5ce2f98cad6e37c844dda2adc9afbeafb70c39377af8",
                ),
                FieldElement::from_hex_unchecked(
                    "219cf659f31a3eeb57f0acbc1742c0934413b1be8dfed3329b09c829ee03808b",
                ),
            )
            .unwrap(),
            qo: G1Point::<BN254PrimeField>::new(
                FieldElement::from_hex_unchecked(
                    "1f63cfcf82c517242efb019aa53af0331bb4077ad38845a1c80f915e96c49ea3",
                ),
                FieldElement::from_hex_unchecked(
                    "23351d7bd3ff9c2a712b705ee1281d7e8de7567e0430ae1157ef1b6e89bf926d",
                ),
            )
            .unwrap(),
            q4: G1Point::<BN254PrimeField>::new(
                FieldElement::from_hex_unchecked(
                    "b2cdce018f3cad9df1152784c16d22ad2cce4cae72d4776353451da817f2a2b",
                ),
                FieldElement::from_hex_unchecked(
                    "219f88713efa809de71c478b02e81ba39e6ea655fd811bb4492143712bb9a461",
                ),
            )
            .unwrap(),
            q_arith: G1Point::<BN254PrimeField>::new(
                FieldElement::from_hex_unchecked(
                    "1405e253bf25766c7bca1b209db74fcb6f331dd2ed036a09ff10a25e00430aee",
                ),
                FieldElement::from_hex_unchecked(
                    "89d58e8fb2152deaf529acee678e4cdbb8d660b7bf0e438229204f58dde9e02",
                ),
            )
            .unwrap(),
            q_delta_range: G1Point::<BN254PrimeField>::new(
                FieldElement::from_hex_unchecked(
                    "1618ea679c4ee1467267e50bb898148ef78d5de08341b5afdc0c863a59ab7e70",
                ),
                FieldElement::from_hex_unchecked(
                    "23268ad7678b97fba97cc3e75da6cff9a3659c3b8a49046cce4062820e5c1116",
                ),
            )
            .unwrap(),
            q_elliptic: G1Point::<BN254PrimeField>::new(
                FieldElement::from_hex_unchecked(
                    "1a11684e6c135cbe0b0ccdb27df1434557e054c65df3af7487468bdfa2fd8325",
                ),
                FieldElement::from_hex_unchecked(
                    "2a8f4fba8e6893b6d523e9572d7f4c60cadfef00619e58d7db7f2b28cec21202",
                ),
            )
            .unwrap(),
            q_aux: G1Point::<BN254PrimeField>::new(
                FieldElement::from_hex_unchecked(
                    "1469006b8b61c8d79301dfeeed1b752548d2ebff7ed60a3cda0c7db10c955c8a",
                ),
                FieldElement::from_hex_unchecked(
                    "19c2b11ddeff8ffe68ab919e345670ab029bcbce4a91df6570722995d636f037",
                ),
            )
            .unwrap(),
            q_lookup: G1Point::<BN254PrimeField>::new(
                FieldElement::from_hex_unchecked(
                    "1dd04a8b68480307aebfa87e81eb08f45b112ec313618ac61a190b1313984c41",
                ),
                FieldElement::from_hex_unchecked(
                    "246a2b5e4a48922abc23f807bbc3ae334494a7def076d517537a97baa29dc9b5",
                ),
            )
            .unwrap(),
            q_poseidon2_external: G1Point::<BN254PrimeField>::new(
                FieldElement::from_hex_unchecked(
                    "1aebf53057be467f5c3ed0f88d90604a4c8d6886256adeca293661e04f1a3ddf",
                ),
                FieldElement::from_hex_unchecked(
                    "2bb5fcc21332b83521c63599557c6473249908a160efa4921bc0e5c16da58b6f",
                ),
            )
            .unwrap(),
            q_poseidon2_internal: G1Point::<BN254PrimeField>::new(
                FieldElement::from_hex_unchecked(
                    "2d855b5b9eda31247e5c717ce51db5b7b0f74ed8027eddb28bb72f061415e49e",
                ),
                FieldElement::from_hex_unchecked(
                    "1e857d997cc8bd0b6558b670690358ad63520266c81078227f33651c341b7704",
                ),
            )
            .unwrap(),
            s1: G1Point::<BN254PrimeField>::new(
                FieldElement::from_hex_unchecked(
                    "f028430324245ce213d543b19fb4b060ada6440d19a392b193a4a55591f2f58",
                ),
                FieldElement::from_hex_unchecked(
                    "18d26b321ef43284d6136addf0a86dee6079d0931c2865f2c6b06d9e136c0c1f",
                ),
            )
            .unwrap(),
            s2: G1Point::<BN254PrimeField>::new(
                FieldElement::from_hex_unchecked(
                    "2eef5de41b9a7b0e52b3c6c9dc6dd63618ac18f0e5e70930e406816ace62fb2b",
                ),
                FieldElement::from_hex_unchecked(
                    "144a24e7e4fa7e858b7092f7c37881572a651d710a7bcb6657a61fcb8fbaea4f",
                ),
            )
            .unwrap(),
            s3: G1Point::<BN254PrimeField>::new(
                FieldElement::from_hex_unchecked(
                    "2e7e532e1656ed4ce34257a9297b836215ebec6edb1cadf52a0aca08d15ee810",
                ),
                FieldElement::from_hex_unchecked(
                    "1a08f5a547b8cb5991bfff7e039b6fbc26883adb6451db4646e706b8d5d551cb",
                ),
            )
            .unwrap(),
            s4: G1Point::<BN254PrimeField>::new(
                FieldElement::from_hex_unchecked(
                    "17fc90a343ca94a33fab8895250839249e9f72d521271e8f84bacd5539310bda",
                ),
                FieldElement::from_hex_unchecked(
                    "18bce7273e69eef07e1be2a79612f14746f91ee47aa75f26d60b9882f20d1d7c",
                ),
            )
            .unwrap(),
            id1: G1Point::<BN254PrimeField>::new(
                FieldElement::from_hex_unchecked(
                    "23129a571c8e2e730f98c0941608d13c8927366c526d79e2bdcb2ee35eb436a7",
                ),
                FieldElement::from_hex_unchecked(
                    "9b08681f6335d38b30728b02e23ac9b5d3a4416ecc457ca9600e1181fecf090",
                ),
            )
            .unwrap(),
            id2: G1Point::<BN254PrimeField>::new(
                FieldElement::from_hex_unchecked(
                    "2480a28e74a1f17b3b1c218d26fa88cd2d9464699599c298120453636906284d",
                ),
                FieldElement::from_hex_unchecked(
                    "14ab9cdff943bf65ad395135d6c53a665319e307acf88637c1425fa4a583b6c7",
                ),
            )
            .unwrap(),
            id3: G1Point::<BN254PrimeField>::new(
                FieldElement::from_hex_unchecked(
                    "1e3912058c25e529fb6c651d048e34d640b94efa080b9bef7b9a54c80a208a87",
                ),
                FieldElement::from_hex_unchecked(
                    "2f17a75505c3035b9ea1fffb0f430f5225a6bd8d55da5a9446187d0ee9f6723d",
                ),
            )
            .unwrap(),
            id4: G1Point::<BN254PrimeField>::new(
                FieldElement::from_hex_unchecked(
                    "2493c99a3d068b03f8f2b8d28b57cea3ee22dd60456277b86c32a18982dcb185",
                ),
                FieldElement::from_hex_unchecked(
                    "1ded39c4c8366469843cd63f09ecacf6c3731486320082c20ec71bbdc92196c1",
                ),
            )
            .unwrap(),
            t1: G1Point::<BN254PrimeField>::new(
                FieldElement::from_hex_unchecked(
                    "2e0cddbc5712d79b59cb3b41ebbcdd494997477ab161763e46601d95844837ef",
                ),
                FieldElement::from_hex_unchecked(
                    "303126892f664d8d505964d14315ec426db4c64531d350750df62dbbc41a1bd9",
                ),
            )
            .unwrap(),
            t2: G1Point::<BN254PrimeField>::new(
                FieldElement::from_hex_unchecked(
                    "874a5ad262eecc6b565e0b08507476a6b2c6040c0c62bd59acfe3e3e125672",
                ),
                FieldElement::from_hex_unchecked(
                    "127b2a745a1b74968c3edc18982b9bef082fb517183c9c6841c2b8ef2ca1df04",
                ),
            )
            .unwrap(),
            t3: G1Point::<BN254PrimeField>::new(
                FieldElement::from_hex_unchecked(
                    "15a18748490ff4c2b1871081954e86c9efd4f8c3d56e1eb23d789a8f710d5be6",
                ),
                FieldElement::from_hex_unchecked(
                    "2097c84955059442a95df075833071a0011ef987dc016ab110eacd554a1d8bbf",
                ),
            )
            .unwrap(),
            t4: G1Point::<BN254PrimeField>::new(
                FieldElement::from_hex_unchecked(
                    "2aecd48089890ea0798eb952c66824d38e9426ad3085b68b00a93c17897c2877",
                ),
                FieldElement::from_hex_unchecked(
                    "1216bdb2f0d961bb8a7a23331d215078d8a9ce405ce559f441f2e71477ff3ddb",
                ),
            )
            .unwrap(),
            lagrange_first: G1Point::<BN254PrimeField>::new(
                FieldElement::from_hex_unchecked("1"),
                FieldElement::from_hex_unchecked("2"),
            )
            .unwrap(),
            lagrange_last: G1Point::<BN254PrimeField>::new(
                FieldElement::from_hex_unchecked(
                    "140b0936c323fd2471155617b6af56ee40d90bea71fba7a412dd61fcf34e8ceb",
                ),
                FieldElement::from_hex_unchecked(
                    "2b6c10790a5f6631c87d652e059df42b90071823185c5ff8e440fd3d73b6fefc",
                ),
            )
            .unwrap(),
        }
    }

    fn get_honk_keccak_proof() -> HonkProof {
        todo!() // TODO
    }

    fn get_honk_starknet_proof() -> HonkProof {
        todo!() // TODO
    }

    fn get_honk_keccak_expected_calldata() -> Vec<BigUint> {
        let values = ["0"]; // TODO
        values
            .into_iter()
            .map(|s| BigUint::parse_bytes(s.as_bytes(), 10).unwrap())
            .collect()
    }

    fn get_honk_starknet_expected_calldata() -> Vec<BigUint> {
        let values = ["0"]; // TODO
        values
            .into_iter()
            .map(|s| BigUint::parse_bytes(s.as_bytes(), 10).unwrap())
            .collect()
    }
}
