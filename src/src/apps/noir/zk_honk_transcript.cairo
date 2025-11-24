use core::poseidon::hades_permutation;
use core::traits::Into;
use corelib_imports::array::array_slice;
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
    pub gate_challenges: Array<u128>,
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
        let (gate_challenges, challenge) = generate_gate_challenges::<
            T,
        >(alpha_challenge, log_circuit_size);

        let libra_challenge = generate_libra_challenge::<
            T,
        >(challenge, honk_proof.libra_commitments, honk_proof.libra_sum);

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
                gate_challenges: gate_challenges,
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
pub fn generate_gate_challenges<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
    prev_hasher_output: u256, log_circuit_size: usize,
) -> (Array<u128>, u256) {
    let mut gate_challenges: Array<u128> = array![];

    let mut gate_challenge: u256 = prev_hasher_output;
    for _ in 0..log_circuit_size {
        let mut hasher = Hasher::new();
        hasher.update(gate_challenge);
        let _gate_challenge: u256 = hasher.digest();
        gate_challenges.append(_gate_challenge.low);
        gate_challenge = _gate_challenge;
    }

    (gate_challenges, gate_challenge)
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
// #[cfg(test)]
// mod tests {
//     use garaga::apps::noir::{get_proof_keccak, get_vk};
//     use super::{HonkTranscript, HonkTranscriptTrait, KeccakHasherState};
//     #[test]
//     fn test_transcript_keccak() {
//         let vk = get_vk();
//         let proof = get_proof_keccak();
//         let (transcript, _, _) = HonkTranscriptTrait::from_proof::<
//             KeccakHasherState,
//         >(vk.circuit_size, vk.public_inputs_size, vk.public_inputs_offset, proof);
//         let expected = HonkTranscript {
//             eta: 0x85cff885ac2961fd2caf69da4ab04a55,
//             eta_two: 0xba900c2ce087fada767d73013dfd3ce,
//             eta_three: 0xcb18a601c68a2bae386730f1ac8a01d,
//             beta: 0xcf2d1a0f78861f5dfc916c1550073a26,
//             gamma: 0xb9a9dc0b29d2edaa5de654ffd600900,
//             alphas: array![
//                 0x3422bf255f8c83b7e0fff72cc68b22b7, 0x4ae0bef84e0016ef705f127fd2b0129,
//                 0xa361c0ecbc1ef0e3a3b4bef776fadc11, 0x1ed7277a36d8c2ab5b90275aad974c75,
//                 0xa32f670684e59d8ebbe3d82a0701a789, 0x911e112b2425c0f8d186eea5c96fa6c,
//                 0x894d723e9d34ea878f6099fcd2b42ae2, 0x874a218266eeea9284da943a16d5600,
//                 0xc0b49a95400f012ce0dffe60b5fd7692, 0x1b0e7baf1b8fd32839846f008e44e13f,
//                 0x4c33c8c1c5e7e31ccdc3959559cd61e3, 0x279f9d73a4f1bc96da1ea5d088ae66a5,
//                 0x9e843478f8d4b0c85ed952c4c2e28685, 0x7b5b4869a40c01b7a44d32359ad6bad,
//                 0x93d7ceca4ff5135c0b6e40112d4fdb7, 0x2a1fabb8aa65953074124639a266d970,
//                 0x3fe16d524e1ef3a25faf29ba2cd6a5e6, 0xa5f42cb9f87277d5a464555e579b3c5,
//                 0x9320405ad5126cdc4cb0cff43f55a8a0, 0x271b43c84a93276056a0bf49ddaeefb2,
//                 0xf3659844e2f89b0b4d69c9c13a7aefa, 0x48b92d11c89b26e06bb4c066280c694,
//                 0x103c23813775f34b4a778a1528012b07, 0xf05401671b306b7001444c5eae0ee2d,
//                 0x46f57e033db8254d98224627eefdc8f,
//             ],
//             gate_challenges: array![
//                 0x36d1e4d36f73c48f01b5d501835d3af2, 0x18f77bc8606e0e8583a082e02be37ce8,
//                 0x514807433f146329cde64fa655c76c84, 0x51d0fa0a164603af3f53d60ef8b2b35e,
//                 0x4fc4a19f875f30595908e1fb4652cb7b, 0xed47147d439e2e1af9a8adc5ab390647,
//                 0x576e64ed207c16eae743c0f6bcb477b2, 0xf616eebae5870b71fb91228fee1369bd,
//                 0x154a41e7a1dea4bf3a03c05808b42d46, 0xbc963c1d6769029a776a2ac1676875eb,
//                 0x361dfc2985ad124680bd5b61ffea7150, 0xfffe2d8a4d1ac744e9a7b0f87331468d,
//                 0x8e8623577889881d62ccc923f7418daf, 0x471d54aa1aa2579b375d2fb6c7a227c5,
//                 0x871f3453b8389320b561b53490fc4fc2, 0x3eab3a93d739e3e5d4938ffd0662fcea,
//                 0x7eb859124baffedb530679037fe1577e, 0xcb7897d2745e478d76dac6964377f5bf,
//                 0x74b17b568765c2e652360cf708f2ee74, 0x923898c5710cb1eb7545bf67368aaa2b,
//                 0x2b999c51737165610db242c316af1103, 0xa7571977b3795e18d1741203a36aa83,
//                 0xf21a7c490fdef23ab21a2157b99d53ac, 0x9141039de2d0b77b596c8bda8a446b7a,
//                 0x7ea90bcc3572610e2d72575ad63dc715, 0xff4ee223b4d759c54e9a3102176bb5c2,
//                 0x3a3368f680068976c20441fc63c38cbe, 0x1768c5da49ceb768761734d472f9276d,
//             ],
//             sum_check_u_challenges: array![
//                 0x1d69fa8c0e4151e133f99f0f70ecbd6c, 0x5b7f50f9d1141cfcacec19b2c8645b67,
//                 0x4af3a472a1e184f7fac69faf18024617, 0x44da1bff7ccc03ce1a5c5720ac69202f,
//                 0x788e90d08039a57a4b662b5f84eccd12, 0x18fddd684c73b98661c5b60d8b31e954,
//                 0x76a20ef9c24c2c3f297389afb82e6e2a, 0x968375108917e2ba4f2a4da04415fcd3,
//                 0xd15d97f6098057c7a49078583608d58, 0x74a4935628d8e0444f2b591c4489f442,
//                 0x4261bcf7c5adf019df8def2549062b89, 0xad061017b6bdefefecf687015bda6f13,
//                 0xe596a1d45d541765b71164c11be77b4d, 0x1452c30d6ef49696ea29c2de8914861a,
//                 0x36606d95cad4392fdf2021174d25192c, 0x332f0c2a846ded159acb0948561538a5,
//                 0xe677499767966634f184fdbbdbfaa858, 0x8e87e426234f735eed5e8c05512ec358,
//                 0x7c7ced5681de349e87385b408570bb2a, 0x9d9c87641a5fc66693dfb72fdbbe9241,
//                 0xfdea141b28220eed58bb257822fd8504, 0x815298037a754c67884fcb13ec0c2959,
//                 0xb337e91df4b256c3707bee63dab7c23f, 0x4e5ec70586d97b710279fb1db58c7cc5,
//                 0x19e18e8739f37b7b2db87fa1e4447b30, 0xdc239dd3c330d74c4699ef5e1c55c11,
//                 0x2ba25fdc975f6771d47869c6dcb204e5, 0xd7f39ece57c21ce2ec232b21ba69a386,
//             ],
//             rho: 0xddc594911e07b3b91b1afc817c04d331,
//             gemini_r: 0x13d4b548ccd7ae5c493dd24a5302c094,
//             shplonk_nu: 0xbd55d4148a8968c31c54c7f9b04a74d0,
//             shplonk_z: 0x1c9e9d4cde5bde269eed51b980ab19fe,
//         };
//         assert_eq!(transcript.eta, expected.eta);
//         assert_eq!(transcript.eta_two, expected.eta_two);
//         assert_eq!(transcript.eta_three, expected.eta_three);
//         assert_eq!(transcript.beta, expected.beta);
//         assert_eq!(transcript.gamma, expected.gamma);
//         assert_eq!(transcript.alphas, expected.alphas);
//         assert_eq!(transcript.gate_challenges, expected.gate_challenges);
//         assert_eq!(transcript.sum_check_u_challenges, expected.sum_check_u_challenges);
//         assert_eq!(transcript.rho, expected.rho);
//         assert_eq!(transcript.gemini_r, expected.gemini_r);
//         assert_eq!(transcript.shplonk_nu, expected.shplonk_nu);
//         assert_eq!(transcript.shplonk_z, expected.shplonk_z);
//     }
// }


