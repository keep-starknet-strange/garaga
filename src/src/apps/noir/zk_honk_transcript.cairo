use core::poseidon::hades_permutation;
use core::traits::Into;
use corelib_imports::keccak;
use garaga::apps::noir::{G1Point256, ZKHonkProof};
use garaga::definitions::G1Point;

pub const POW2_136: u256 = 0x10000000000000000000000000000000000;
pub const POW2_136_NZ: NonZero<u256> = 0x10000000000000000000000000000000000;
pub const POW2_8: NonZero<u128> = 0x100;
pub const Fr: u256 = 21888242871839275222246405745257275088548364400416034343698204186575808495617;

pub const ZK_BATCHED_RELATION_PARTIAL_LENGTH: usize = 9;

pub const NUMBER_OF_SUBRELATIONS: usize = 26;
pub const NUMBER_OF_ALPHAS: usize = NUMBER_OF_SUBRELATIONS - 1;
pub const CONST_PROOF_SIZE_LOG_N: usize = 28;
pub const NUMBER_OF_ENTITIES: usize = 41;


pub impl Point256IntoCircuitPoint of Into<G1Point256, G1Point> {
    fn into(self: G1Point256) -> G1Point {
        G1Point { x: self.x.into(), y: self.y.into() }
    }
}

pub trait IHasher<T> {
    fn new() -> T;
    fn update_u64_as_u256(ref self: T, v: u64);
    fn update_0_256(ref self: T);
    fn update(ref self: T, v: u256);
    fn digest(ref self: T) -> u256;
}

#[derive(Drop, Debug)]
pub struct KeccakHasherState {
    arr: Array<u64>,
}

pub impl KeccakHasher of IHasher<KeccakHasherState> {
    #[inline]
    fn new() -> KeccakHasherState {
        KeccakHasherState { arr: array![] }
    }
    #[inline(never)]
    fn update_u64_as_u256(ref self: KeccakHasherState, v: u64) {
        self.arr.append(0);
        self.arr.append(0);
        self.arr.append(0);
        self.arr.append(u64_byte_reverse(v));
    }
    #[inline]
    fn update(ref self: KeccakHasherState, v: u256) {
        keccak::keccak_add_u256_be(ref self.arr, v);
    }
    #[inline]
    fn update_0_256(ref self: KeccakHasherState) {
        self.arr.append(0);
        self.arr.append(0);
        self.arr.append(0);
        self.arr.append(0);
    }
    #[inline]
    fn digest(ref self: KeccakHasherState) -> u256 {
        ke_le_out_to_ch_be(
            keccak::cairo_keccak(ref self.arr, last_input_word: 0, last_input_num_bytes: 0),
        )
    }
}

#[inline]
fn u64_byte_reverse(word: u64) -> u64 {
    (core::integer::u128_byte_reverse(word.into()) / 0x10000000000000000).try_into().unwrap()
}

#[inline]
fn u256_byte_reverse(word: u256) -> u256 {
    u256 {
        low: core::integer::u128_byte_reverse(word.high),
        high: core::integer::u128_byte_reverse(word.low),
    }
}

#[inline(never)]
pub fn append_proof_point<T, impl Hasher: IHasher<T>>(ref hasher: T, point: G1Point256) {
    hasher.update(point.x);
    hasher.update(point.y);
}

// Hasher little endian output to big endian challenge.
// Converts to big endian, then takes modulo Fr.
fn ke_le_out_to_ch_be(ke_le_out: u256) -> u256 {
    let ke_be: u256 = u256_byte_reverse(ke_le_out);
    let ch_be: u256 = ke_be % Fr;
    ch_be
}


#[derive(Drop, Debug, PartialEq)]
pub struct ZKHonkTranscript {
    pub eta: u128,
    pub eta_two: u128,
    pub eta_three: u128,
    pub beta: u128,
    pub gamma: u128,
    pub alpha: u128,
    pub gate_challenge: u128,
    pub libra_challenge: u128,
    pub sum_check_u_challenges: Array<u128>,
    pub rho: u128,
    pub gemini_r: u128,
    pub shplonk_nu: u128,
    pub shplonk_z: u128,
}


#[derive(Drop)]
pub struct Etas {
    pub eta: u128,
    pub eta2: u128,
    pub eta3: u128,
}

#[generate_trait]
pub impl ZKHonkTranscriptImpl of ZKHonkTranscriptTrait {
    fn from_proof<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
        honk_proof: ZKHonkProof, vk_hash: u256, log_circuit_size: usize,
    ) -> (ZKHonkTranscript, felt252, felt252) {
        let (etas, challenge) = get_eta_challenges::<
            T,
        >(
            honk_proof.public_inputs,
            honk_proof.pairing_point_object,
            honk_proof.w1,
            honk_proof.w2,
            honk_proof.w3,
            vk_hash,
        );
        let beta_gamma = get_beta_gamma_challenges::<
            T,
        >(challenge, honk_proof.lookup_read_counts, honk_proof.lookup_read_tags, honk_proof.w4);
        let alpha_challenge = generate_alpha_challenge::<
            T,
        >(beta_gamma, honk_proof.lookup_inverses, honk_proof.z_perm);
        let gate_challenge = generate_gate_challenge::<T>(alpha_challenge);

        let libra_challenge = generate_libra_challenge::<
            T,
        >(gate_challenge, honk_proof.libra_commitments, honk_proof.libra_sum);

        let (sum_check_u_challenges, challenge) = generate_sumcheck_u_challenges::<
            T,
        >(libra_challenge, honk_proof.sumcheck_univariates, log_circuit_size);

        let rho_challenge = generate_rho_challenge::<
            T,
        >(
            challenge,
            honk_proof.sumcheck_evaluations,
            honk_proof.libra_evaluation,
            honk_proof.libra_commitments,
            honk_proof.gemini_masking_poly,
            honk_proof.gemini_masking_eval,
        );

        let gemini_r_challenge = generate_gemini_r_challenge::<
            T,
        >(rho_challenge, honk_proof.gemini_fold_comms, log_circuit_size);

        let shplonk_nu_challenge = generate_shplonk_nu_challenge::<
            T,
        >(
            gemini_r_challenge,
            honk_proof.gemini_a_evaluations,
            honk_proof.libra_poly_evals,
            log_circuit_size,
        );
        let shplonk_z_challenge = generate_shplonk_z_challenge::<
            T,
        >(shplonk_nu_challenge, honk_proof.shplonk_q);

        let (transcript_state, base_rlc, _) = hades_permutation(
            shplonk_z_challenge.low.into(), shplonk_z_challenge.high.into(), 2,
        );

        return (
            ZKHonkTranscript {
                eta: etas.eta,
                eta_two: etas.eta2,
                eta_three: etas.eta3,
                beta: beta_gamma.low,
                gamma: beta_gamma.high,
                alpha: alpha_challenge.low,
                gate_challenge: gate_challenge.low,
                libra_challenge: libra_challenge.low,
                sum_check_u_challenges: sum_check_u_challenges,
                rho: rho_challenge.low,
                gemini_r: gemini_r_challenge.low,
                shplonk_nu: shplonk_nu_challenge.low,
                shplonk_z: shplonk_z_challenge.low,
            },
            transcript_state,
            base_rlc,
        );
    }
}

// Return eta and last hasher output
#[inline]
pub fn get_eta_challenges<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
    pub_inputs: Span<u256>,
    pairing_point_object: Span<u256>,
    w1: G1Point256,
    w2: G1Point256,
    w3: G1Point256,
    vk_hash: u256,
) -> (Etas, u256) {
    let mut hasher = Hasher::new();

    hasher.update(vk_hash);

    for pub_i in pub_inputs {
        hasher.update(*pub_i);
    }
    for pub_i in pairing_point_object {
        hasher.update(*pub_i);
    }
    append_proof_point(ref hasher, w1);
    append_proof_point(ref hasher, w2);
    append_proof_point(ref hasher, w3);

    let ch_be: u256 = hasher.digest();

    let mut hasher_2 = Hasher::new();
    hasher_2.update(ch_be);

    let ch_2_be: u256 = hasher_2.digest();

    (Etas { eta: ch_be.low, eta2: ch_be.high, eta3: ch_2_be.low }, ch_2_be)
}

// Return beta, gamma, and last hasher output.
// Outut :
// ch_be.
// beta = ch_be.low, gamma = ch_be.high, last_hasher_output = ch_be.
#[inline]
pub fn get_beta_gamma_challenges<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
    prev_hasher_output: u256,
    lookup_read_counts: G1Point256,
    lookup_read_tags: G1Point256,
    w4: G1Point256,
) -> u256 {
    let mut hasher = Hasher::new();
    hasher.update(prev_hasher_output);
    append_proof_point(ref hasher, lookup_read_counts);
    append_proof_point(ref hasher, lookup_read_tags);
    append_proof_point(ref hasher, w4);

    let ch_be: u256 = hasher.digest();

    ch_be
}

#[inline]
pub fn generate_alpha_challenge<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
    prev_hasher_output: u256, lookup_inverse: G1Point256, z_perm: G1Point256,
) -> u256 {
    let mut hasher = Hasher::new();
    hasher.update(prev_hasher_output);
    append_proof_point(ref hasher, lookup_inverse);
    append_proof_point(ref hasher, z_perm);

    let challenge: u256 = hasher.digest();

    challenge
}

#[inline]
pub fn generate_gate_challenge<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
    prev_hasher_output: u256,
) -> u256 {
    let mut hasher = Hasher::new();
    hasher.update(prev_hasher_output);
    let gate_challenge: u256 = hasher.digest();
    gate_challenge
}

#[inline]
pub fn generate_libra_challenge<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
    prev_hasher_output: u256, libra_commitments: Span<G1Point256>, libra_sum: u256,
) -> u256 {
    let mut hasher = Hasher::new();
    hasher.update(prev_hasher_output);

    append_proof_point(ref hasher, (*libra_commitments.at(0)).into());

    hasher.update(libra_sum);

    hasher.digest()
}

#[inline]
pub fn generate_sumcheck_u_challenges<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
    prev_hasher_output: u256, sumcheck_univariates: Span<u256>, log_circuit_size: usize,
) -> (Array<u128>, u256) {
    let mut sum_check_u_challenges: Array<u128> = array![];
    let mut challenge: u256 = prev_hasher_output;
    for i in 0..log_circuit_size {
        let mut hasher = Hasher::new();
        hasher.update(challenge);
        for univariate in sumcheck_univariates
            .slice(i * ZK_BATCHED_RELATION_PARTIAL_LENGTH, ZK_BATCHED_RELATION_PARTIAL_LENGTH) {
            hasher.update(*univariate);
        }

        challenge = hasher.digest();
        sum_check_u_challenges.append(challenge.low);
    }

    (sum_check_u_challenges, challenge)
}


#[inline]
pub fn generate_rho_challenge<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
    prev_hasher_output: u256,
    sumcheck_evaluations: Span<u256>,
    libra_evaluation: u256,
    libra_commitments: Span<G1Point256>,
    gemini_masking_poly: G1Point256,
    gemini_masking_eval: u256,
) -> u256 {
    let mut hasher = Hasher::new();
    hasher.update(prev_hasher_output);

    assert(sumcheck_evaluations.len() == NUMBER_OF_ENTITIES, 'Wrong # of sumcheck evaluations');
    for eval in sumcheck_evaluations {
        hasher.update(*eval);
    }

    hasher.update(libra_evaluation);
    append_proof_point(ref hasher, (*libra_commitments.at(1)));
    append_proof_point(ref hasher, (*libra_commitments.at(2)));
    append_proof_point(ref hasher, gemini_masking_poly);
    hasher.update(gemini_masking_eval);

    hasher.digest()
}

#[inline]
pub fn generate_gemini_r_challenge<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
    prev_hasher_output: u256, gemini_fold_comms: Span<G1Point256>, log_circuit_size: usize,
) -> u256 {
    let mut hasher = Hasher::new();
    hasher.update(prev_hasher_output);
    // Log_n - 1 points
    assert(gemini_fold_comms.len() == log_circuit_size - 1, 'Wrong # gemini fold commitments');
    for pt in gemini_fold_comms {
        append_proof_point(ref hasher, (*pt));
    }
    hasher.digest()
}
#[inline]
pub fn generate_shplonk_nu_challenge<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
    prev_hasher_output: u256,
    gemini_a_evaluations: Span<u256>,
    libra_poly_evals: Span<u256>,
    log_circuit_size: usize,
) -> u256 {
    let mut hasher = Hasher::new();
    hasher.update(prev_hasher_output);
    assert(gemini_a_evaluations.len() == log_circuit_size, 'Wrong # gemini a evaluations');
    for eval in gemini_a_evaluations {
        hasher.update(*eval);
    }
    assert(libra_poly_evals.len() == 4, 'Wrong # libra poly evals');
    for eval in libra_poly_evals {
        hasher.update(*eval);
    }

    hasher.digest()
}


#[inline]
pub fn generate_shplonk_z_challenge<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
    prev_hasher_output: u256, shplonk_q: G1Point256,
) -> u256 {
    let mut hasher = Hasher::new();
    hasher.update(prev_hasher_output);
    append_proof_point(ref hasher, shplonk_q);

    hasher.digest()
}
#[cfg(test)]
mod tests {
    use garaga::apps::noir::{get_vk, get_zk_proof_keccak};
    use super::{KeccakHasherState, ZKHonkTranscript, ZKHonkTranscriptTrait};
    #[test]
    fn test_transcript_zk_keccak() {
        let vk = get_vk();
        let proof = get_zk_proof_keccak();
        let (transcript, _, _) = ZKHonkTranscriptTrait::from_proof::<
            KeccakHasherState,
        >(proof, vk.vk_hash, vk.log_circuit_size);
        let expected = ZKHonkTranscript {
            eta: 0xe06b1fc6aaa49ae9fd402ada2b9134b9,
            eta_two: 0xe542c4b5332d3d478ddb457634915e1,
            eta_three: 0x8e6609b790521615a5280fb48742cad8,
            beta: 0x72d843c38074ab30feda0c1fec6c1b3a,
            gamma: 0x2a2d65e61cca6188a3a8923aa8e5f0fd,
            alpha: 0x9a4e2bc96d7e1dd703244eef656760ad,
            gate_challenge: 0x93408fac46045cb577fef77c8ae160e5,
            libra_challenge: 0x3d7684814dfcb8a69e8ed0d6811500ce,
            sum_check_u_challenges: array![
                0xdd54b9aefc090c30ea2968d1f2f2875b, 0x5b2c6faddf41ec1b5b0d30441320df35,
                0x31a05c60e4601a6e5dd0cbf00ba66d4d, 0x78fd67e59d93d13bd9f90fe775d88759,
                0x64d775cbd626fc667f7ef431d7a8a026, 0x5a389eb79d036095de26968eff05a52f,
                0xad7a51b6745cf979f995c463b7c84b33, 0x396d8c7eb553dc399585fcbb227d8819,
                0x9fbb8219244d68f56af6042a9aed2a6f, 0x8abf1fe8e59622f23abaefbbf040b77a,
                0x2d8091d0fa8dbe6da6e339538144f442, 0xfc2b3617ce73378503ccce368a9010d5,
            ],
            rho: 0x193ead6536b4ba765236aa95c50de7f6,
            gemini_r: 0x7defebd9a6f21decaac79819dc18596e,
            shplonk_nu: 0xf2a3267c336f0ee4ab6f5a2b60b47647,
            shplonk_z: 0x1369879dd6918cd679e6295a75569269,
        };
        assert_eq!(transcript.eta, expected.eta);
        assert_eq!(transcript.eta_two, expected.eta_two);
        assert_eq!(transcript.eta_three, expected.eta_three);
        assert_eq!(transcript.beta, expected.beta);
        assert_eq!(transcript.gamma, expected.gamma);
        assert_eq!(transcript.alpha, expected.alpha);
        assert_eq!(transcript.gate_challenge, expected.gate_challenge);
        assert_eq!(transcript.libra_challenge, expected.libra_challenge);
        assert_eq!(transcript.sum_check_u_challenges, expected.sum_check_u_challenges);
        assert_eq!(transcript.rho, expected.rho);
        assert_eq!(transcript.gemini_r, expected.gemini_r);
        assert_eq!(transcript.shplonk_nu, expected.shplonk_nu);
        assert_eq!(transcript.shplonk_z, expected.shplonk_z);
    }
}

