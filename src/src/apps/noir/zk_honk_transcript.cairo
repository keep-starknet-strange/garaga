use core::poseidon::hades_permutation;
use core::traits::Into;
use corelib_imports::keccak;
use garaga::apps::noir::{G1Point256, ZKHonkProof};
use garaga::definitions::G1Point;

pub const POW2_136: u256 = 0x10000000000000000000000000000000000;
pub const POW2_136_NZ: NonZero<u256> = 0x10000000000000000000000000000000000;
pub const POW2_8: NonZero<u128> = 0x100;
pub const Fr: u256 = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
// BN254 base field modulus.
pub const Fq: u256 = 21888242871839275222246405745257275088696311157297823662689037894645226208583;

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

// Asserts the point coordinates are canonical (< Fq) so that each point has a unique encoding.
#[inline(never)]
pub fn assert_canonical_proof_point(point: G1Point256) {
    assert(point.x < Fq && point.y < Fq, 'proof point coord >= Fq');
}

#[inline(never)]
pub fn append_proof_point<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
    ref hasher: T, point: G1Point256,
) {
    assert_canonical_proof_point(point);
    hasher.update(point.x);
    hasher.update(point.y);
}

// Asserts the scalar is canonical (< Fr) before hashing it, so that it has a unique encoding.
#[inline]
pub fn append_scalar<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(ref hasher: T, scalar: u256) {
    assert(scalar < Fr, 'proof scalar >= Fr');
    hasher.update(scalar);
}

// Hasher little endian output to big endian challenge.
// Converts to big endian, then takes modulo Fr.
fn ke_le_out_to_ch_be(ke_le_out: u256) -> u256 {
    let ke_be: u256 = u256_byte_reverse(ke_le_out);
    let ch_be: u256 = ke_be % Fr;
    ch_be
}


// All challenges are full Fr elements (the hasher output reduced modulo Fr).
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
        let alpha_challenge = generate_alpha_challenge::<
            T,
        >(gamma, honk_proof.lookup_inverses, honk_proof.z_perm);
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
            honk_proof.gemini_masking_eval,
            honk_proof.sumcheck_evaluations,
            honk_proof.libra_evaluation,
            honk_proof.libra_commitments,
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

        // The KZG quotient is not part of the transcript but is part of the proof.
        assert_canonical_proof_point(honk_proof.kzg_quotient);

        let (transcript_state, base_rlc, _) = hades_permutation(
            shplonk_z_challenge.low.into(), shplonk_z_challenge.high.into(), 2,
        );

        return (
            ZKHonkTranscript {
                eta,
                rom_logup_gamma,
                beta,
                gamma,
                alpha: alpha_challenge,
                gate_challenge,
                libra_challenge,
                sum_check_u_challenges,
                rho: rho_challenge,
                gemini_r: gemini_r_challenge,
                shplonk_nu: shplonk_nu_challenge,
                shplonk_z: shplonk_z_challenge,
            },
            transcript_state,
            base_rlc,
        );
    }
}

// Return (eta, rom_logup_gamma). rom_logup_gamma is also the last hasher output.
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
        append_scalar(ref hasher, *pub_i);
    }
    for pub_i in pairing_point_object {
        hasher.update(*pub_i);
    }
    append_proof_point(ref hasher, gemini_masking_poly);
    append_proof_point(ref hasher, w1);
    append_proof_point(ref hasher, w2);
    append_proof_point(ref hasher, w3);

    let eta: u256 = hasher.digest();

    let mut hasher_2 = Hasher::new();
    hasher_2.update(eta);

    let rom_logup_gamma: u256 = hasher_2.digest();

    (eta, rom_logup_gamma)
}

// Return (beta, gamma). gamma is also the last hasher output.
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

    let beta: u256 = hasher.digest();

    let mut hasher_2 = Hasher::new();
    hasher_2.update(beta);

    let gamma: u256 = hasher_2.digest();

    (beta, gamma)
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

    append_scalar(ref hasher, libra_sum);

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
            append_scalar(ref hasher, *univariate);
        }

        challenge = hasher.digest();
        sum_check_u_challenges.append(challenge);
    }

    (sum_check_u_challenges, challenge)
}


#[inline]
pub fn generate_rho_challenge<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
    prev_hasher_output: u256,
    gemini_masking_eval: u256,
    sumcheck_evaluations: Span<u256>,
    libra_evaluation: u256,
    libra_commitments: Span<G1Point256>,
) -> u256 {
    let mut hasher = Hasher::new();
    hasher.update(prev_hasher_output);

    // The gemini masking polynomial evaluation comes first, then the regular entities.
    append_scalar(ref hasher, gemini_masking_eval);
    assert(sumcheck_evaluations.len() == NUMBER_OF_ENTITIES, 'Wrong # of sumcheck evaluations');
    for eval in sumcheck_evaluations {
        append_scalar(ref hasher, *eval);
    }

    append_scalar(ref hasher, libra_evaluation);
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
        append_scalar(ref hasher, *eval);
    }
    assert(libra_poly_evals.len() == 4, 'Wrong # libra poly evals');
    for eval in libra_poly_evals {
        append_scalar(ref hasher, *eval);
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
            eta: 0x840241e775b3ee0e0f18abd6f831397ca3fc0ee332ce5ca861089f0b635074c,
            rom_logup_gamma: 0x21574c4505fcfafeb858101dad16a63cac6d5f5e7e6a33a26fc65080dddaad5a,
            beta: 0x1e44914886d42cac374702f70855a84a352efd741572ceca9d47bdd78acf9444,
            gamma: 0x2db95a8079405a1cfa1785f2fd51cba96b416a7f53a6ffc98823aa32b5874764,
            alpha: 0xe6e9f382434750fe6758a72992128e7a6f39e50c215dad836e4acff8f1a779d,
            gate_challenge: 0x20900f46261680b4b0eca1ef9d0294be397bc252d59c459e349e7bd17a828a14,
            libra_challenge: 0x2537de63e216ebc082a5d67484b0a8bc43ad9aa3c15febaf2b12404207fffaf7,
            sum_check_u_challenges: array![
                0xd3cdd2cf32cc7596cbaf25444b4bcea1c107047407efa5621cfe51dd445f970,
                0x52b6019a26d78299484f5eda1ab4ed211716e8024f83e8542c877db3ea3ac80,
                0x19e33459d711d0ba42563e914a4865644d1507ac153e1f6ccd31b70eba75fa3f,
                0x2b1590015ef08dc83f65a55e4c4b209884eb10b41b6de4f34c4b52125a325627,
                0x16be1c948f7b75b405b16ffddbe3f2e003c753cdcd6eae32b79c7fc7997c97c7,
                0x751421da61fff83dd72f257265cd47c53a215d78c30b19e0461336b31e9e285,
                0xa533026b768d5583dbd0b888eac8a87bd72a641adac2be83c291cfc31d0b5d6,
                0x145365af6c65ece9f3e124c85e3ae323c52ebefc180cc58f2217e3b10b2462d3,
                0x18bb99d210bd8a1e243e7450cf17ca8526a09c4d95000046b8e5f3941429695,
                0x696a694cee4a6919441512d8dfc96db59327178094c2d681038e16cc307f2c0,
                0x3288e5fd415324187800e490610cb5c452d5478e72b603518b356dc843c8710,
                0xcc679367511decd5fef2a5fc91cb995e50cc2e07f60cf2b1eb5c579b5dc3cc3,
            ],
            rho: 0x15d37b7a10d2a25097258234d8243a6f53e583edc63e0cbb3fc042742f5da31,
            gemini_r: 0xc04d3427e66b4d0755178faf35cd2d0b5e3fa6a3e5602f90b55a6eb7803d197,
            shplonk_nu: 0x243adb78f4033ff41ce199e69d272b7643da477cd4e065ae510841caa3669b07,
            shplonk_z: 0x11c1715b37aca55d5b23be390501a2107466c015b2d805453ba8af23eb86848d,
        };
        assert_eq!(transcript.eta, expected.eta);
        assert_eq!(transcript.rom_logup_gamma, expected.rom_logup_gamma);
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
