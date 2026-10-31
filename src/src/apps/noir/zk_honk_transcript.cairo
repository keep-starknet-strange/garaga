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

pub const NUMBER_OF_SUBRELATIONS: usize = 31;
pub const NUMBER_OF_ALPHAS: usize = NUMBER_OF_SUBRELATIONS - 1;
pub const CONST_PROOF_SIZE_LOG_N: usize = 25;
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
    pub arr: Array<u64>,
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
    pub eta: u256,
    pub rom_logup_gamma: u256,
    pub beta: u256,
    pub gamma: u256,
    pub alpha: u256,
    pub gate_challenge: u256,
    pub libra_challenge: u256,
    pub sum_check_u_challenges: Array<u256>,
    pub rho: u256,
    pub gemini_r: u256,
    pub shplonk_nu: u256,
    pub shplonk_z: u256,
}

#[generate_trait]
pub impl ZKHonkTranscriptImpl of ZKHonkTranscriptTrait {
    fn from_proof<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
        honk_proof: ZKHonkProof, vk_hash: u256, log_circuit_size: usize,
    ) -> (ZKHonkTranscript, felt252, felt252) {
        let (eta, rom_logup_gamma) = get_eta_challenges::<
            T,
        >(
            honk_proof.public_inputs,
            honk_proof.pairing_point_object,
            honk_proof.gemini_masking_poly,
            honk_proof.w1,
            honk_proof.w2,
            honk_proof.w3,
            vk_hash,
        );
        let (beta, gamma) = get_beta_gamma_challenges::<
            T,
        >(
            rom_logup_gamma,
            honk_proof.lookup_read_counts,
            honk_proof.lookup_read_tags,
            honk_proof.w4,
        );
        let alpha = generate_alpha_challenge::<
            T,
        >(gamma, honk_proof.lookup_inverses, honk_proof.z_perm);
        let gate_challenge = generate_gate_challenge::<T>(alpha);
        let libra_challenge = generate_libra_challenge::<
            T,
        >(gate_challenge, honk_proof.libra_commitments, honk_proof.libra_sum);
        let (sum_check_u_challenges, challenge) = generate_sumcheck_u_challenges::<
            T,
        >(libra_challenge, honk_proof.sumcheck_univariates, log_circuit_size);
        let rho = generate_rho_challenge::<
            T,
        >(
            challenge,
            honk_proof.sumcheck_evaluations,
            honk_proof.libra_evaluation,
            honk_proof.libra_commitments,
            honk_proof.gemini_masking_eval,
        );
        let gemini_r = generate_gemini_r_challenge::<
            T,
        >(rho, honk_proof.gemini_fold_comms, log_circuit_size);
        let shplonk_nu = generate_shplonk_nu_challenge::<
            T,
        >(gemini_r, honk_proof.gemini_a_evaluations, honk_proof.libra_poly_evals, log_circuit_size);
        let shplonk_z = generate_shplonk_z_challenge::<T>(shplonk_nu, honk_proof.shplonk_q);
        let (transcript_state, base_rlc, _) = hades_permutation(
            shplonk_z.low.into(), shplonk_z.high.into(), 2,
        );
        (
            ZKHonkTranscript {
                eta,
                rom_logup_gamma,
                beta,
                gamma,
                alpha,
                gate_challenge,
                libra_challenge,
                sum_check_u_challenges,
                rho,
                gemini_r,
                shplonk_nu,
                shplonk_z,
            },
            transcript_state,
            base_rlc,
        )
    }
}

// Return eta and last hasher output
#[inline]
pub fn get_eta_challenges<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
    pub_inputs: Span<u256>,
    pairing_point_object: Span<u256>,
    gemini_masking_poly: G1Point256,
    w1: G1Point256,
    w2: G1Point256,
    w3: G1Point256,
    vk_hash: u256,
) -> (u256, u256) {
    let mut hasher = Hasher::new();

    hasher.update(vk_hash);

    for pub_i in pub_inputs {
        hasher.update(*pub_i);
    }
    for pub_i in pairing_point_object {
        hasher.update(*pub_i);
    }
    append_proof_point(ref hasher, gemini_masking_poly);
    append_proof_point(ref hasher, w1);
    append_proof_point(ref hasher, w2);
    append_proof_point(ref hasher, w3);

    let ch_be: u256 = hasher.digest();

    let mut hasher_2 = Hasher::new();
    hasher_2.update(ch_be);

    let ch_2_be: u256 = hasher_2.digest();

    (ch_be, ch_2_be)
}

// Derive beta and gamma through two sequential field-reduced hashes.
#[inline]
pub fn get_beta_gamma_challenges<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
    prev_hasher_output: u256,
    lookup_read_counts: G1Point256,
    lookup_read_tags: G1Point256,
    w4: G1Point256,
) -> (u256, u256) {
    let mut hasher = Hasher::new();
    hasher.update(prev_hasher_output);
    append_proof_point(ref hasher, lookup_read_counts);
    append_proof_point(ref hasher, lookup_read_tags);
    append_proof_point(ref hasher, w4);

    let ch_be: u256 = hasher.digest();

    let mut next = Hasher::new();
    next.update(ch_be);
    (ch_be, next.digest())
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
) -> (Array<u256>, u256) {
    let mut sum_check_u_challenges: Array<u256> = array![];
    let mut challenge: u256 = prev_hasher_output;
    for i in 0..log_circuit_size {
        let mut hasher = Hasher::new();
        hasher.update(challenge);
        for univariate in sumcheck_univariates
            .slice(i * ZK_BATCHED_RELATION_PARTIAL_LENGTH, ZK_BATCHED_RELATION_PARTIAL_LENGTH) {
            hasher.update(*univariate);
        }

        challenge = hasher.digest();
        sum_check_u_challenges.append(challenge);
    }

    (sum_check_u_challenges, challenge)
}


#[inline]
pub fn generate_rho_challenge<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
    prev_hasher_output: u256,
    sumcheck_evaluations: Span<u256>,
    libra_evaluation: u256,
    libra_commitments: Span<G1Point256>,
    gemini_masking_eval: u256,
) -> u256 {
    let mut hasher = Hasher::new();
    hasher.update(prev_hasher_output);

    assert(sumcheck_evaluations.len() == NUMBER_OF_ENTITIES, 'Wrong # of sumcheck evaluations');
    hasher.update(gemini_masking_eval);
    for eval in sumcheck_evaluations {
        hasher.update(*eval);
    }

    hasher.update(libra_evaluation);
    append_proof_point(ref hasher, (*libra_commitments.at(1)));
    append_proof_point(ref hasher, (*libra_commitments.at(2)));

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
    use garaga::apps::noir::test_fixtures::{get_expected_transcript, get_vk, get_zk_proof_keccak};
    use super::{KeccakHasherState, ZKHonkTranscriptTrait};

    #[test]
    fn test_transcript_zk_keccak() {
        let vk = get_vk();
        let (transcript, _, _) = ZKHonkTranscriptTrait::from_proof::<
            KeccakHasherState,
        >(get_zk_proof_keccak(), vk.vk_hash, vk.log_circuit_size);
        assert_eq!(transcript, get_expected_transcript());
    }
}
