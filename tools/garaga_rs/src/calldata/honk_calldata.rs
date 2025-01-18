use crate::algebra::g1g2pair::G1G2Pair;
use crate::algebra::g1point::G1Point;
use crate::calldata::mpc_calldata;
use crate::calldata::msm_calldata;
use crate::definitions::BN254PrimeField;
use crate::definitions::CurveID;
use crate::definitions::FieldElement;
use crate::definitions::GrumpkinPrimeField;
use crate::definitions::Stark252PrimeField;
use num_bigint::BigUint;

const BATCHED_RELATION_PARTIAL_LENGTH: usize = 8;
const CONST_PROOF_SIZE_LOG_N: usize = 28;
const NUMBER_OF_SUBRELATIONS: usize = 26;
const NUMBER_OF_ALPHAS: usize = NUMBER_OF_SUBRELATIONS - 1;
const NUMBER_OF_ENTITIES: usize = 44;

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

    let proof_data = serialize_honk_proof_to_calldata(&proof);

    let scalars = circuit_compute_shplemini_msm_scalars(
        vk.log_circuit_size,
        &proof.sumcheck_evaluations,
        &proof.gemini_a_evaluations,
        &tp.gemini_r,
        &tp.rho,
        &tp.shplonk_z,
        &tp.shplonk_nu,
        &tp.sum_check_u_challenges,
    );

    let scalars_msm = extract_msm_scalars(&scalars, vk.log_circuit_size);

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
    //points.append(G1Point.get_nG(CurveID.BN254, 1))
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

    //G2_POINT_KZG_1 = G2Point.get_nG(CurveID.BN254, 1)
    //G2_POINT_KZG_2 = G2Point(
    //    x=(
    //        0x0118C4D5B837BCC2BC89B5B398B5974E9F5944073B32078B7E231FEC938883B0,
    //        0x260E01B251F6F1C7E7FF4E580791DEE8EA51D87A358E038B4EFE30FAC09383C1,
    //    ),
    //    y=(
    //        0x22FEBDA3C0C0632A56475B4214E5615E11E6DD3F96E6CEA2854A87D4DACC5E55,
    //        0x04FC6369F7110FE3D25156C1BB9A72859CF2A04641F99BA4EE413C80DA6A5FE4,
    //    ),
    //    curve_id=CurveID.BN254,
    //)

    //P_0 = G1Point.msm(points=points, scalars=scalars_msm).add(proof.shplonk_q)
    let _p_1 = proof.kzg_quotient.neg();

    use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree2ExtensionField;
    let pairs: Vec<G1G2Pair<BN254PrimeField, Degree2ExtensionField>> = vec![];
    //pairs = [G1G2Pair(P_0, G2_POINT_KZG_1), G1G2Pair(P_1, G2_POINT_KZG_2)]

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

fn serialize_honk_proof_to_calldata(_proof: &HonkProof) -> Vec<BigUint> {
    /*
        def serialize_G1Point256(g1_point: G1Point) -> list[int]:
            xl, xh = split_128(g1_point.x)
            yl, yh = split_128(g1_point.y)
            return [xl, xh, yl, yh]

        log_circuit_size = int(math.log2(proof.circuit_size))

        cd = []
        cd.append(proof.circuit_size)
        cd.append(proof.public_inputs_size)
        cd.append(proof.public_inputs_offset)
        cd.extend(
            bigint_split_array(
                x=[elem.value for elem in proof.public_inputs], n_limbs=2, base=2**128, prepend_length=True
            )
        )
        cd.extend(serialize_G1Point256(proof.w1))
        cd.extend(serialize_G1Point256(proof.w2))
        cd.extend(serialize_G1Point256(proof.w3))
        cd.extend(serialize_G1Point256(proof.w4))
        cd.extend(serialize_G1Point256(proof.z_perm))
        cd.extend(serialize_G1Point256(proof.lookup_read_counts))
        cd.extend(serialize_G1Point256(proof.lookup_read_tags))
        cd.extend(serialize_G1Point256(proof.lookup_inverses))
        cd.extend(
            bigint_split_array(
                x=[elem.value for elem in flatten(proof.sumcheck_univariates)][
                    : BATCHED_RELATION_PARTIAL_LENGTH * log_circuit_size
                ],  # The rest is 0.
                n_limbs=2,
                base=2**128,
                prepend_length=True,
            )
        )

        cd.extend(
            bigint_split_array(
                x=[elem.value for elem in proof.sumcheck_evaluations], n_limbs=2, base=2**128, prepend_length=True
            )
        )

        cd.append(log_circuit_size - 1)
        for pt in proof.gemini_fold_comms[: log_circuit_size - 1]:  # The rest is G(1, 2)
            cd.extend(serialize_G1Point256(pt))

        cd.extend(
            bigint_split_array(
                x=[elem.value for elem in proof.gemini_a_evaluations[:log_circuit_size]],
                n_limbs=2,
                base=2**128,
                prepend_length=True,
            )
        )
        cd.extend(serialize_G1Point256(proof.shplonk_q))
        cd.extend(serialize_G1Point256(proof.kzg_quotient))

        return cd
    */
    todo!()
}

fn extract_msm_scalars(_scalars: &[Option<BigUint>], _log_n: u64) -> Vec<BigUint> {
    /*
        assert len(scalars) == NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 2

        start_dummy = NUMBER_OF_ENTITIES + log_n
        end_dummy = NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N

        scalars_no_dummy = scalars[:start_dummy] + scalars[end_dummy:]

        scalars_filtered = scalars_no_dummy[1:]
        scalars_filtered_no_nones = [
            scalar for scalar in scalars_filtered if scalar is not None
        ]
        return [s.value for s in scalars_filtered_no_nones]
    */
    todo!()
}

pub trait Hasher {
    fn reset(&mut self);
    fn update(&mut self, data: &[u8]);
    fn digest(&self) -> FieldElement<GrumpkinPrimeField>;
    fn digest_reset(&mut self) -> FieldElement<GrumpkinPrimeField> {
        let result = self.digest();
        self.reset();
        return result;
    }
    fn update_element(&mut self, _element: &FieldElement<GrumpkinPrimeField>) {
        todo!()
    }
    fn update_point(&mut self, _point: &G1Point<BN254PrimeField>) {
        todo!()
    }
}

pub struct KeccakHasher {}

impl KeccakHasher {
    fn new() -> Self {
        todo!()
    }
}

impl Hasher for KeccakHasher {
    fn reset(&mut self) {
        todo!()
    }
    fn update(&mut self, _data: &[u8]) {
        todo!()
    }
    fn digest(&self) -> FieldElement<GrumpkinPrimeField> {
        todo!()
    }
}

pub struct StarknetHasher {
    pub state: [FieldElement<Stark252PrimeField>; 3],
}

impl StarknetHasher {
    fn new() -> Self {
        todo!()
    }
}

impl Hasher for StarknetHasher {
    fn reset(&mut self) {
        todo!()
    }
    fn update(&mut self, _data: &[u8]) {
        todo!()
    }
    fn digest(&self) -> FieldElement<GrumpkinPrimeField> {
        todo!()
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

    /*
        hasher.update(int.to_bytes(proof.circuit_size, 32, "big"))
        hasher.update(int.to_bytes(proof.public_inputs_size, 32, "big"))
        hasher.update(int.to_bytes(proof.public_inputs_offset, 32, "big"))
    */

    for public_input in &proof.public_inputs {
        hasher.update_element(public_input);
    }
    hasher.update_point(&proof.w1);
    hasher.update_point(&proof.w2);
    hasher.update_point(&proof.w3);

    let ch0 = hasher.digest_reset();
    /*
        eta, eta_two = split_challenge(ch0)
    */
    hasher.update_element(&ch0);
    let ch0 = hasher.digest_reset();
    /*
        eta_three, _ = split_challenge(ch0)
    */

    // Round 1 : ch0, lookup_read_counts, lookup_read_tags, w4
    hasher.update_element(&ch0);
    hasher.update_point(&proof.lookup_read_counts);
    hasher.update_point(&proof.lookup_read_tags);
    hasher.update_point(&proof.w4);
    let ch1 = hasher.digest_reset();
    /*
        beta, gamma = split_challenge(ch1)
    */

    // Round 2: ch1, lookup_inverses, z_perm
    hasher.update_element(&ch1);
    hasher.update_point(&proof.lookup_inverses);
    hasher.update_point(&proof.z_perm);
    let mut ch2 = hasher.digest_reset();
    /*
        alphas = [None] * NUMBER_OF_ALPHAS
        alphas[0], alphas[1] = split_challenge(ch2)
    */
    for _i in 1..NUMBER_OF_ALPHAS / 2 {
        hasher.update_element(&ch2);
        ch2 = hasher.digest_reset();
        /*
        alphas[i * 2], alphas[i * 2 + 1] = split_challenge(ch2)
        */
    }

    if NUMBER_OF_ALPHAS % 2 == 1 {
        hasher.update_element(&ch2);
        ch2 = hasher.digest_reset();
        /*
        alphas[-1], _ = split_challenge(ch2)
        */
    }

    // Round 3: Gate Challenges :
    let mut ch3 = ch2;
    /*
        gate_challenges = [None] * CONST_PROOF_SIZE_LOG_N
    */
    for _i in 0..CONST_PROOF_SIZE_LOG_N {
        hasher.update_element(&ch3);
        ch3 = hasher.digest_reset();
        /*
        gate_challenges[i], _ = split_challenge(ch3)
        */
    }

    /*
        # Round 4: Sumcheck u challenges
        ch4 = ch3
        sum_check_u_challenges = [None] * CONST_PROOF_SIZE_LOG_N

        for i in range(CONST_PROOF_SIZE_LOG_N):
            # Create array of univariate challenges starting with previous challenge
            univariate_chal = [ch4]

            # Add the sumcheck univariates for this round
            for j in range(BATCHED_RELATION_PARTIAL_LENGTH):
                univariate_chal.append(
                    int.to_bytes(proof.sumcheck_univariates[i][j].value, 32, "big")
                )

            # Update hasher with all univariate challenges
            for chal in univariate_chal:
                hasher.update(chal)

            # Get next challenge
            ch4 = hasher.digest_reset()

            # Split challenge to get sumcheck challenge
            sum_check_u_challenges[i], _ = split_challenge(ch4)

        # Rho challenge :
        hasher.update(ch4)
        for i in range(NUMBER_OF_ENTITIES):
            hasher.update(int.to_bytes(proof.sumcheck_evaluations[i].value, 32, "big"))

        c5 = hasher.digest_reset()
        rho, _ = split_challenge(c5)

        # Gemini R :
        hasher.update(c5)
        for i in range(CONST_PROOF_SIZE_LOG_N - 1):
            x0, x1, y0, y1 = g1_to_g1_proof_point(proof.gemini_fold_comms[i])
            hasher.update(int.to_bytes(x0, 32, "big"))
            hasher.update(int.to_bytes(x1, 32, "big"))
            hasher.update(int.to_bytes(y0, 32, "big"))
            hasher.update(int.to_bytes(y1, 32, "big"))

        c6 = hasher.digest_reset()
        gemini_r, _ = split_challenge(c6)

        # Shplonk Nu :
        hasher.update(c6)
        for i in range(CONST_PROOF_SIZE_LOG_N):
            hasher.update(int.to_bytes(proof.gemini_a_evaluations[i].value, 32, "big"))

        c7 = hasher.digest_reset()
        shplonk_nu, _ = split_challenge(c7)

        # Shplonk Z :
        hasher.update(c7)
        x0, x1, y0, y1 = g1_to_g1_proof_point(proof.shplonk_q)
        hasher.update(int.to_bytes(x0, 32, "big"))
        hasher.update(int.to_bytes(x1, 32, "big"))
        hasher.update(int.to_bytes(y0, 32, "big"))
        hasher.update(int.to_bytes(y1, 32, "big"))

        c8 = hasher.digest_reset()
        shplonk_z, _ = split_challenge(c8)

        field = get_base_field(CurveID.GRUMPKIN)
        return HonkTranscript(
            eta=field(eta),
            etaTwo=field(eta_two),
            etaThree=field(eta_three),
            beta=field(beta),
            gamma=field(gamma),
            alphas=[field(alpha) for alpha in alphas],
            gate_challenges=[field(gate_challenge) for gate_challenge in gate_challenges],
            sum_check_u_challenges=[
                field(sum_check_u_challenge)
                for sum_check_u_challenge in sum_check_u_challenges
            ],
            rho=field(rho),
            gemini_r=field(gemini_r),
            shplonk_nu=field(shplonk_nu),
            shplonk_z=field(shplonk_z),
        )
    */
    todo!()
}

fn circuit_compute_shplemini_msm_scalars(
    _log_n: u64,
    _p_sumcheck_evaluations: &[FieldElement<GrumpkinPrimeField>; NUMBER_OF_ENTITIES],
    _p_gemini_a_evaluations: &[FieldElement<GrumpkinPrimeField>; CONST_PROOF_SIZE_LOG_N],
    _tp_gemini_r: &FieldElement<GrumpkinPrimeField>,
    _tp_rho: &FieldElement<GrumpkinPrimeField>,
    _tp_shplonk_z: &FieldElement<GrumpkinPrimeField>,
    _tp_shplonk_nu: &FieldElement<GrumpkinPrimeField>,
    _tp_sum_check_u_challenges: &[FieldElement<GrumpkinPrimeField>; CONST_PROOF_SIZE_LOG_N],
) -> [Option<BigUint>; NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 2] {
    /*
    field = get_base_field(CurveID.GRUMPKIN)

    powers_of_evaluations_challenge = [tp_gemini_r]
    for i in range(1, log_n):
        powers_of_evaluations_challenge.append(
            powers_of_evaluations_challenge[i - 1]
            * powers_of_evaluations_challenge[i - 1]
        )

    scalars = [field(0)] * (NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 2)

    # computeInvertedGeminiDenominators

    inverse_vanishing_evals = [None] * (CONST_PROOF_SIZE_LOG_N + 1)
    inverse_vanishing_evals[0] = (
        tp_shplonk_z - powers_of_evaluations_challenge[0]
    ).__inv__()
    for i in range(log_n):
        inverse_vanishing_evals[i + 1] = (
            tp_shplonk_z + powers_of_evaluations_challenge[i]
        ).__inv__()
    assert len(inverse_vanishing_evals) == CONST_PROOF_SIZE_LOG_N + 1

    unshifted_scalar = -(
        inverse_vanishing_evals[0] + tp_shplonk_nu * inverse_vanishing_evals[1]
    )

    shifted_scalar = -(
        tp_gemini_r.__inv__()
        * (inverse_vanishing_evals[0] - tp_shplonk_nu * inverse_vanishing_evals[1])
    )

    scalars[0] = field(1)

    batching_challenge = field(1)
    batched_evaluation = field(0)

    for i in range(1, NUMBER_UNSHIFTED + 1):
        scalars[i] = unshifted_scalar * batching_challenge
        batched_evaluation = (
            batched_evaluation + p_sumcheck_evaluations[i - 1] * batching_challenge
        )
        batching_challenge = batching_challenge * tp_rho

    for i in range(NUMBER_UNSHIFTED + 1, NUMBER_OF_ENTITIES + 1):
        scalars[i] = shifted_scalar * batching_challenge
        batched_evaluation = (
            batched_evaluation + p_sumcheck_evaluations[i - 1] * batching_challenge
        )
        # skip last round:
        if i < NUMBER_OF_ENTITIES:
            batching_challenge = batching_challenge * tp_rho

    constant_term_accumulator = field(0)
    batching_challenge = tp_shplonk_nu * tp_shplonk_nu

    for i in range(CONST_PROOF_SIZE_LOG_N - 1):
        dummy_round = i >= (log_n - 1)

        scaling_factor = field(0)
        if not dummy_round:
            scaling_factor = batching_challenge * inverse_vanishing_evals[i + 2]
            scalars[NUMBER_OF_ENTITIES + i + 1] = -scaling_factor
            constant_term_accumulator = (
                constant_term_accumulator
                + scaling_factor * p_gemini_a_evaluations[i + 1]
            )

        # skip last round:
        if i < log_n - 2:
            batching_challenge = batching_challenge * tp_shplonk_nu

    # computeGeminiBatchedUnivariateEvaluation
    def compute_gemini_batched_univariate_evaluation(
        tp_sumcheck_u_challenges,
        batched_eval_accumulator,
        gemini_evaluations,
        gemini_eval_challenge_powers,
    ):
        for i in range(log_n, 0, -1):
            challenge_power = gemini_eval_challenge_powers[i - 1]
            u = tp_sumcheck_u_challenges[i - 1]
            eval_neg = gemini_evaluations[i - 1]

            term = challenge_power * (field(1) - u)

            batched_eval_round_acc = (
                field(2) * challenge_power * batched_eval_accumulator
            ) - (eval_neg * (term - u))

            den = term + u

            batched_eval_round_acc = batched_eval_round_acc * den.__inv__()
            batched_eval_accumulator = batched_eval_round_acc

        return batched_eval_accumulator

    a_0_pos = compute_gemini_batched_univariate_evaluation(
        tp_sumcheck_u_challenges,
        batched_evaluation,
        p_gemini_a_evaluations,
        powers_of_evaluations_challenge,
    )

    constant_term_accumulator = (
        constant_term_accumulator + a_0_pos * inverse_vanishing_evals[0]
    )

    constant_term_accumulator = (
        constant_term_accumulator
        + p_gemini_a_evaluations[0] * tp_shplonk_nu * inverse_vanishing_evals[1]
    )

    scalars[NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N] = constant_term_accumulator
    scalars[NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 1] = tp_shplonk_z

    # vk.t1 : 22 + 36
    # vk.t2 : 23 + 37
    # vk.t3 : 24 + 38
    # vk.t4 : 25 + 39

    # proof.w1 : 28 + 40
    # proof.w2 : 29 + 41
    # proof.w3 : 30 + 42
    # proof.w4 : 31 + 43

    scalars[22] = scalars[22] + scalars[36]
    scalars[23] = scalars[23] + scalars[37]
    scalars[24] = scalars[24] + scalars[38]
    scalars[25] = scalars[25] + scalars[39]

    scalars[28] = scalars[28] + scalars[40]
    scalars[29] = scalars[29] + scalars[41]
    scalars[30] = scalars[30] + scalars[42]
    scalars[31] = scalars[31] + scalars[43]

    scalars[36] = None
    scalars[37] = None
    scalars[38] = None
    scalars[39] = None
    scalars[40] = None
    scalars[41] = None
    scalars[42] = None
    scalars[43] = None

    return scalars*/
    todo!()
}
