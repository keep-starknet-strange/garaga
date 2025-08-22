use core::poseidon::hades_permutation;
use core::traits::Into;
use corelib_imports::array::array_slice;
use corelib_imports::keccak;
use garaga::definitions::G1Point;
use garaga::utils::noir::{G1Point256, G1PointProof, HonkProof};

pub const POW2_136: u256 = 0x10000000000000000000000000000000000;
pub const POW2_136_NZ: NonZero<u256> = 0x10000000000000000000000000000000000;
pub const POW2_8: NonZero<u128> = 0x100;
pub const Fr: u256 = 21888242871839275222246405745257275088548364400416034343698204186575808495617;

pub const NUMBER_OF_SUBRELATIONS: usize = 26;
pub const NUMBER_OF_ALPHAS: usize = NUMBER_OF_SUBRELATIONS - 1;
pub const CONST_PROOF_SIZE_LOG_N: usize = 28;
pub const BATCHED_RELATION_PARTIAL_LENGTH: usize = 8;
pub const NUMBER_OF_ENTITIES: usize = 40;


pub impl ProofPointIntoPoint256 of Into<G1PointProof, G1Point256> {
    fn into(self: G1PointProof) -> G1Point256 {
        G1Point256 { x: self.x0 + self.x1 * POW2_136, y: self.y0 + self.y1 * POW2_136 }
    }
}

pub impl Point256IntoProofPoint of Into<G1Point256, G1PointProof> {
    fn into(self: G1Point256) -> G1PointProof {
        // x and y splitted between low 136 bits and high 120 bits.
        let (x_high_120, x_mid_8) = DivRem::div_rem(self.x.high, POW2_8);
        let x_low = u256 { low: self.x.low, high: x_mid_8 };
        let x_high = u256 { low: x_high_120, high: 0 };

        let (y_high_120, y_mid_8) = DivRem::div_rem(self.y.high, POW2_8);
        let y_low = u256 { low: self.y.low, high: y_mid_8 };
        let y_high = u256 { low: y_high_120, high: 0 };
        G1PointProof { x0: x_low, x1: x_high, y0: y_low, y1: y_high }
    }
}

pub impl Point256IntoCircuitPoint of Into<G1Point256, G1Point> {
    fn into(self: G1Point256) -> G1Point {
        G1Point { x: self.x.into(), y: self.y.into() }
    }
}

pub trait IHasher<T> {
    fn new() -> T;
    fn update_u64_as_u256(ref self: T, v: u64);
    fn update_0_256(ref self: T);
    fn update_gen_point(ref self: T);
    fn update(ref self: T, v: u256);
    fn digest(ref self: T) -> u256;
}

#[derive(Drop, Debug)]
pub struct KeccakHasherState {
    arr: Array<u64>,
}

impl KeccakHasher of IHasher<KeccakHasherState> {
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
    fn update_gen_point(ref self: KeccakHasherState) {
        // Constant Gen Point (1, 2) converted into G1PointProof and correctly reversed for keccak.
        self.arr.append(0);
        self.arr.append(0);
        self.arr.append(0);
        self.arr.append(72057594037927936);

        self.arr.append(0);
        self.arr.append(0);
        self.arr.append(0);
        self.arr.append(0);

        self.arr.append(0);
        self.arr.append(0);
        self.arr.append(0);
        self.arr.append(144115188075855872);

        self.arr.append(0);
        self.arr.append(0);
        self.arr.append(0);
        self.arr.append(0);
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

#[derive(Drop, Debug)]
pub struct StarknetHasherState {
    s0: felt252,
    s1: felt252,
    s2: felt252,
}

pub impl StarknetHasher of IHasher<StarknetHasherState> {
    #[inline]
    fn new() -> StarknetHasherState {
        // "StarknetHonk", 0, 1
        // let (s0, s1, s2) = hades_permutation(0x537461726b6e6574486f6e6b, 0, 1);
        // StarknetHasherState { s0, s1, s2 }
        StarknetHasherState {
            s0: 2583770218478457022175556443398335703519197626205536693866888990886940410111,
            s1: 1058918495029539251166273500359216657108371230450049671154888943560936263793,
            s2: 2612238833264321791418659390799326049759227019974323472543752797390858749685,
        }
    }
    #[inline]
    fn update_u64_as_u256(ref self: StarknetHasherState, v: u64) {
        let low: felt252 = v.into();
        let (s0, s1, s2) = hades_permutation(self.s0 + low, self.s1, self.s2);
        self.s0 = s0;
        self.s1 = s1;
        self.s2 = s2;
    }
    #[inline]
    fn update_gen_point(ref self: StarknetHasherState) {
        // Constant Gen Point (1, 2) pre-converted into G1PointProof
        let (s0, s1, s2) = hades_permutation(self.s0 + 1, self.s1, self.s2);
        let (s0, s1, s2) = hades_permutation(s0, s1, s2);
        let (s0, s1, s2) = hades_permutation(s0 + 2, s1, s2);
        let (s0, s1, s2) = hades_permutation(s0, s1, s2);
        self.s0 = s0;
        self.s1 = s1;
        self.s2 = s2;
    }
    #[inline]
    fn update_0_256(ref self: StarknetHasherState) {
        let (s0, s1, s2) = hades_permutation(self.s0, self.s1, self.s2);
        self.s0 = s0;
        self.s1 = s1;
        self.s2 = s2;
    }
    #[inline]
    fn update(ref self: StarknetHasherState, v: u256) {
        let low: felt252 = v.low.into();
        let high: felt252 = v.high.into();
        let (s0, s1, s2) = hades_permutation(self.s0 + low, self.s1 + high, self.s2);
        self.s0 = s0;
        self.s1 = s1;
        self.s2 = s2;
    }
    #[inline]
    fn digest(ref self: StarknetHasherState) -> u256 {
        self.s0.into()
    }
}

#[derive(Drop, Debug, PartialEq)]
struct HonkTranscript {
    eta: u128,
    eta_two: u128,
    eta_three: u128,
    beta: u128,
    gamma: u128,
    alphas: Array<u128>,
    gate_challenges: Array<u128>,
    sum_check_u_challenges: Array<u128>,
    rho: u128,
    gemini_r: u128,
    shplonk_nu: u128,
    shplonk_z: u128,
}

#[generate_trait]
impl HonkTranscriptImpl of HonkTranscriptTrait {
    fn from_proof<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
        circuit_size: usize,
        public_inputs_size: usize,
        public_inputs_offset: usize,
        honk_proof: HonkProof,
    ) -> (HonkTranscript, felt252, felt252) {
        let (etas, challenge) = get_eta_challenges::<
            T,
        >(
            circuit_size.into(),
            public_inputs_size.into(),
            public_inputs_offset.into(),
            honk_proof.public_inputs,
            honk_proof.pairing_point_object,
            honk_proof.w1.into(),
            honk_proof.w2.into(),
            honk_proof.w3.into(),
        );
        let beta_gamma = get_beta_gamma_challenges::<
            T,
        >(
            challenge,
            honk_proof.lookup_read_counts.into(),
            honk_proof.lookup_read_tags.into(),
            honk_proof.w4.into(),
        );
        let (alphas, challenge) = generate_alpha_challenges::<
            T,
        >(beta_gamma, honk_proof.lookup_inverses.into(), honk_proof.z_perm.into());
        let (gate_challenges, challenge) = generate_gate_challenges::<T>(challenge);

        let (sum_check_u_challenges, challenge) = generate_sumcheck_u_challenges::<
            T,
        >(challenge, honk_proof.sumcheck_univariates);

        let rho = generate_rho_challenge::<T>(challenge, honk_proof.sumcheck_evaluations);
        let gemini_r = generate_gemini_r_challenge::<T>(rho, honk_proof.gemini_fold_comms);

        let shplonk_nu = generate_shplonk_nu_challenge::<
            T,
        >(gemini_r, honk_proof.gemini_a_evaluations);
        let shplonk_z = generate_shplonk_z_challenge::<T>(shplonk_nu, honk_proof.shplonk_q.into());

        let (transcript_state, base_rlc, _) = hades_permutation(
            shplonk_z.low.into(), shplonk_z.high.into(), 2,
        );

        return (
            HonkTranscript {
                eta: etas.eta,
                eta_two: etas.eta2,
                eta_three: etas.eta3,
                beta: beta_gamma.low,
                gamma: beta_gamma.high,
                alphas: alphas,
                gate_challenges: gate_challenges,
                sum_check_u_challenges: sum_check_u_challenges,
                rho: rho.low,
                gemini_r: gemini_r.low,
                shplonk_nu: shplonk_nu.low,
                shplonk_z: shplonk_z.low,
            },
            transcript_state,
            base_rlc,
        );
    }
}

#[derive(Drop)]
pub struct Etas {
    pub eta: u128,
    pub eta2: u128,
    pub eta3: u128,
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
pub fn append_proof_point<T, impl Hasher: IHasher<T>>(ref hasher: T, point: G1PointProof) {
    hasher.update(point.x0);
    hasher.update(point.x1);
    hasher.update(point.y0);
    hasher.update(point.y1);
}

// Hasher little endian output to big endian challenge.
// Converts to big endian, then takes modulo Fr.
fn ke_le_out_to_ch_be(ke_le_out: u256) -> u256 {
    let ke_be: u256 = u256_byte_reverse(ke_le_out);
    let ch_be: u256 = ke_be % Fr;
    ch_be
}

// Return eta and last hasher output
#[inline]
pub fn get_eta_challenges<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
    circuit_size: u64,
    pub_inputs_size: u64,
    pub_inputs_offset: u64,
    pub_inputs: Span<u256>,
    pairing_point_object: Span<u256>,
    w1: G1PointProof,
    w2: G1PointProof,
    w3: G1PointProof,
) -> (Etas, u256) {
    let mut hasher = Hasher::new();
    hasher.update_u64_as_u256(circuit_size);
    hasher.update_u64_as_u256(pub_inputs_size);
    hasher.update_u64_as_u256(pub_inputs_offset);
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
    lookup_read_counts: G1PointProof,
    lookup_read_tags: G1PointProof,
    w4: G1PointProof,
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
pub fn generate_alpha_challenges<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
    prev_hasher_output: u256, lookup_inverse: G1PointProof, z_perm: G1PointProof,
) -> (Array<u128>, u256) { // -> [u256; NUMBER_OF_ALPHAS]
    let mut hasher = Hasher::new();
    hasher.update(prev_hasher_output);
    append_proof_point(ref hasher, lookup_inverse);
    append_proof_point(ref hasher, z_perm);

    let mut alpha_XY: u256 = hasher.digest();

    let mut alphas: Array<u128> = array![];
    alphas.append(alpha_XY.low);
    alphas.append(alpha_XY.high);

    // Asumme N_alphas > 2 and N_alphas is odd.
    for _ in 1..NUMBER_OF_ALPHAS / 2 {
        let mut hasher_i = Hasher::new();
        hasher_i.update(alpha_XY);
        let _alpha_XY: u256 = hasher_i.digest();

        alphas.append(_alpha_XY.low);
        alphas.append(_alpha_XY.high);

        alpha_XY = _alpha_XY;
    }

    // Last alpha (odd number of alphas)

    let mut hasher_last = Hasher::new();
    hasher_last.update(alpha_XY);
    let alpha_last: u256 = hasher_last.digest();

    alphas.append(alpha_last.low);

    assert(alphas.len() == NUMBER_OF_ALPHAS, 'Wrong number of alphas');

    (alphas, alpha_last)
}

#[inline]
pub fn generate_gate_challenges<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
    prev_hasher_output: u256,
) -> (Array<u128>, u256) {
    let mut gate_challenges: Array<u128> = array![];

    let mut gate_challenge: u256 = prev_hasher_output;
    for _ in 0..CONST_PROOF_SIZE_LOG_N {
        let mut hasher = Hasher::new();
        hasher.update(gate_challenge);
        let _gate_challenge: u256 = hasher.digest();
        gate_challenges.append(_gate_challenge.low);
        gate_challenge = _gate_challenge;
    }

    (gate_challenges, gate_challenge)
}


#[inline]
pub fn generate_sumcheck_u_challenges<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
    prev_hasher_output: u256, sumcheck_univariates: Span<u256>,
) -> (Array<u128>, u256) {
    let mut sum_check_u_challenges: Array<u128> = array![];
    let mut challenge: u256 = prev_hasher_output;
    for i in 0..CONST_PROOF_SIZE_LOG_N {
        let mut hasher = Hasher::new();
        hasher.update(challenge);

        match array_slice(
            sumcheck_univariates.into(),
            i * BATCHED_RELATION_PARTIAL_LENGTH,
            BATCHED_RELATION_PARTIAL_LENGTH,
        ) {
            Option::Some(slice) => {
                for j in 0..BATCHED_RELATION_PARTIAL_LENGTH {
                    hasher.update(*slice.at(j));
                };
            },
            Option::None => {
                for _ in 0..BATCHED_RELATION_PARTIAL_LENGTH {
                    hasher.update_0_256();
                };
            },
        }
        challenge = hasher.digest();
        sum_check_u_challenges.append(challenge.low);
    }

    (sum_check_u_challenges, challenge)
}


#[inline]
pub fn generate_rho_challenge<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
    prev_hasher_output: u256, sumcheck_evaluations: Span<u256>,
) -> u256 {
    let mut hasher = Hasher::new();
    hasher.update(prev_hasher_output);
    for eval in sumcheck_evaluations {
        hasher.update(*eval);
    }

    hasher.digest()
}

#[inline]
pub fn generate_gemini_r_challenge<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
    prev_hasher_output: u256, gemini_fold_comms: Span<G1Point256>,
) -> u256 {
    let mut hasher = Hasher::new();
    hasher.update(prev_hasher_output);
    // Log_n - 1 points
    for pt in gemini_fold_comms {
        append_proof_point(ref hasher, (*pt).into());
    }
    for _ in 0..(CONST_PROOF_SIZE_LOG_N - gemini_fold_comms.len() - 1) {
        // Constant Gen Point (1, 2) converted into G1PointProof and correctly reversed for hasher.
        hasher.update_gen_point();
    }
    hasher.digest()
}

#[inline]
pub fn generate_shplonk_nu_challenge<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
    prev_hasher_output: u256, gemini_a_evaluations: Span<u256>,
) -> u256 {
    let mut hasher = Hasher::new();
    hasher.update(prev_hasher_output);
    for eval in gemini_a_evaluations {
        hasher.update(*eval);
    }
    let implied_log_n = gemini_a_evaluations.len();
    for _ in 0..(CONST_PROOF_SIZE_LOG_N - implied_log_n) {
        hasher.update_0_256();
    }

    hasher.digest()
}

#[inline]
pub fn generate_shplonk_z_challenge<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
    prev_hasher_output: u256, shplonk_q: G1PointProof,
) -> u256 {
    // # Shplonk Z :
    // hasher.update(c7)
    // x0, x1, y0, y1 = g1_to_g1_proof_point(proof.shplonk_q)
    // hasher.update(int.to_bytes(x0, 32, "big"))
    // hasher.update(int.to_bytes(x1, 32, "big"))
    // hasher.update(int.to_bytes(y0, 32, "big"))
    // hasher.update(int.to_bytes(y1, 32, "big"))

    // c8 = hasher.digest_reset()
    // shplonk_z, _ = split_challenge(c8)

    let mut hasher = Hasher::new();
    hasher.update(prev_hasher_output);
    append_proof_point(ref hasher, shplonk_q);

    hasher.digest()
}


#[cfg(test)]
mod tests {
    use garaga::utils::noir::{get_proof_keccak, get_proof_starknet, get_vk};
    use super::{HonkTranscript, HonkTranscriptTrait, KeccakHasherState, StarknetHasherState};
    #[test]
    fn test_transcript_keccak() {
        let vk = get_vk();
        let proof = get_proof_keccak();
        let (transcript, _, _) = HonkTranscriptTrait::from_proof::<
            KeccakHasherState,
        >(vk.circuit_size, vk.public_inputs_size, vk.public_inputs_offset, proof);
        let expected = HonkTranscript {
            eta: 0x85cff885ac2961fd2caf69da4ab04a55,
            eta_two: 0xba900c2ce087fada767d73013dfd3ce,
            eta_three: 0xcb18a601c68a2bae386730f1ac8a01d,
            beta: 0xcf2d1a0f78861f5dfc916c1550073a26,
            gamma: 0xb9a9dc0b29d2edaa5de654ffd600900,
            alphas: array![
                0x3422bf255f8c83b7e0fff72cc68b22b7, 0x4ae0bef84e0016ef705f127fd2b0129,
                0xa361c0ecbc1ef0e3a3b4bef776fadc11, 0x1ed7277a36d8c2ab5b90275aad974c75,
                0xa32f670684e59d8ebbe3d82a0701a789, 0x911e112b2425c0f8d186eea5c96fa6c,
                0x894d723e9d34ea878f6099fcd2b42ae2, 0x874a218266eeea9284da943a16d5600,
                0xc0b49a95400f012ce0dffe60b5fd7692, 0x1b0e7baf1b8fd32839846f008e44e13f,
                0x4c33c8c1c5e7e31ccdc3959559cd61e3, 0x279f9d73a4f1bc96da1ea5d088ae66a5,
                0x9e843478f8d4b0c85ed952c4c2e28685, 0x7b5b4869a40c01b7a44d32359ad6bad,
                0x93d7ceca4ff5135c0b6e40112d4fdb7, 0x2a1fabb8aa65953074124639a266d970,
                0x3fe16d524e1ef3a25faf29ba2cd6a5e6, 0xa5f42cb9f87277d5a464555e579b3c5,
                0x9320405ad5126cdc4cb0cff43f55a8a0, 0x271b43c84a93276056a0bf49ddaeefb2,
                0xf3659844e2f89b0b4d69c9c13a7aefa, 0x48b92d11c89b26e06bb4c066280c694,
                0x103c23813775f34b4a778a1528012b07, 0xf05401671b306b7001444c5eae0ee2d,
                0x46f57e033db8254d98224627eefdc8f,
            ],
            gate_challenges: array![
                0x36d1e4d36f73c48f01b5d501835d3af2, 0x18f77bc8606e0e8583a082e02be37ce8,
                0x514807433f146329cde64fa655c76c84, 0x51d0fa0a164603af3f53d60ef8b2b35e,
                0x4fc4a19f875f30595908e1fb4652cb7b, 0xed47147d439e2e1af9a8adc5ab390647,
                0x576e64ed207c16eae743c0f6bcb477b2, 0xf616eebae5870b71fb91228fee1369bd,
                0x154a41e7a1dea4bf3a03c05808b42d46, 0xbc963c1d6769029a776a2ac1676875eb,
                0x361dfc2985ad124680bd5b61ffea7150, 0xfffe2d8a4d1ac744e9a7b0f87331468d,
                0x8e8623577889881d62ccc923f7418daf, 0x471d54aa1aa2579b375d2fb6c7a227c5,
                0x871f3453b8389320b561b53490fc4fc2, 0x3eab3a93d739e3e5d4938ffd0662fcea,
                0x7eb859124baffedb530679037fe1577e, 0xcb7897d2745e478d76dac6964377f5bf,
                0x74b17b568765c2e652360cf708f2ee74, 0x923898c5710cb1eb7545bf67368aaa2b,
                0x2b999c51737165610db242c316af1103, 0xa7571977b3795e18d1741203a36aa83,
                0xf21a7c490fdef23ab21a2157b99d53ac, 0x9141039de2d0b77b596c8bda8a446b7a,
                0x7ea90bcc3572610e2d72575ad63dc715, 0xff4ee223b4d759c54e9a3102176bb5c2,
                0x3a3368f680068976c20441fc63c38cbe, 0x1768c5da49ceb768761734d472f9276d,
            ],
            sum_check_u_challenges: array![
                0x1d69fa8c0e4151e133f99f0f70ecbd6c, 0x5b7f50f9d1141cfcacec19b2c8645b67,
                0x4af3a472a1e184f7fac69faf18024617, 0x44da1bff7ccc03ce1a5c5720ac69202f,
                0x788e90d08039a57a4b662b5f84eccd12, 0x18fddd684c73b98661c5b60d8b31e954,
                0x76a20ef9c24c2c3f297389afb82e6e2a, 0x968375108917e2ba4f2a4da04415fcd3,
                0xd15d97f6098057c7a49078583608d58, 0x74a4935628d8e0444f2b591c4489f442,
                0x4261bcf7c5adf019df8def2549062b89, 0xad061017b6bdefefecf687015bda6f13,
                0xe596a1d45d541765b71164c11be77b4d, 0x1452c30d6ef49696ea29c2de8914861a,
                0x36606d95cad4392fdf2021174d25192c, 0x332f0c2a846ded159acb0948561538a5,
                0xe677499767966634f184fdbbdbfaa858, 0x8e87e426234f735eed5e8c05512ec358,
                0x7c7ced5681de349e87385b408570bb2a, 0x9d9c87641a5fc66693dfb72fdbbe9241,
                0xfdea141b28220eed58bb257822fd8504, 0x815298037a754c67884fcb13ec0c2959,
                0xb337e91df4b256c3707bee63dab7c23f, 0x4e5ec70586d97b710279fb1db58c7cc5,
                0x19e18e8739f37b7b2db87fa1e4447b30, 0xdc239dd3c330d74c4699ef5e1c55c11,
                0x2ba25fdc975f6771d47869c6dcb204e5, 0xd7f39ece57c21ce2ec232b21ba69a386,
            ],
            rho: 0xddc594911e07b3b91b1afc817c04d331,
            gemini_r: 0x13d4b548ccd7ae5c493dd24a5302c094,
            shplonk_nu: 0xbd55d4148a8968c31c54c7f9b04a74d0,
            shplonk_z: 0x1c9e9d4cde5bde269eed51b980ab19fe,
        };
        assert_eq!(transcript.eta, expected.eta);
        assert_eq!(transcript.eta_two, expected.eta_two);
        assert_eq!(transcript.eta_three, expected.eta_three);
        assert_eq!(transcript.beta, expected.beta);
        assert_eq!(transcript.gamma, expected.gamma);
        assert_eq!(transcript.alphas, expected.alphas);
        assert_eq!(transcript.gate_challenges, expected.gate_challenges);
        assert_eq!(transcript.sum_check_u_challenges, expected.sum_check_u_challenges);
        assert_eq!(transcript.rho, expected.rho);
        assert_eq!(transcript.gemini_r, expected.gemini_r);
        assert_eq!(transcript.shplonk_nu, expected.shplonk_nu);
        assert_eq!(transcript.shplonk_z, expected.shplonk_z);
    }
    #[test]
    fn test_transcript_starknet() {
        let vk = get_vk();
        let proof = get_proof_starknet();
        let (transcript, _, _) = HonkTranscriptTrait::from_proof::<
            StarknetHasherState,
        >(vk.circuit_size, vk.public_inputs_size, vk.public_inputs_offset, proof);
        let expected = HonkTranscript {
            eta: 0x779b5cad79ca797e5d2512702e4e8ecf,
            eta_two: 0x28ee0797e82d55f6c60cb22720d480e,
            eta_three: 0xdd198d0873f51d4bd6ae718e33b42ce4,
            beta: 0xa9042507fbd168b4766cc90f0d4f39d2,
            gamma: 0x598a4e79641c9700e131f5ff4cfe8a1,
            alphas: array![
                0x67f462602eb54dc376aec96933012ed3, 0x15fe2f4def2d56f0c2fa50c82d11e98,
                0x43c23a997dfacc880ee2d2ebca06558f, 0x4518f39799b65fb094ec860c9c4f321,
                0x4bb622796d526841c797424f4999a472, 0x58951a07bdbf702ef28c6b9c61f061a,
                0x681c1c803bf9ff56edbcfe75fefdc220, 0x2a12b1203e99b693c9eaa1221d54df2,
                0x8cbf40fb3ac9ed9493127d76807cbd34, 0x5c79da1586bab525f5fbeea32470fe4,
                0xaa42baf5eed4d409c23a21d97eccf7, 0x66e64b48c9c4f534d869a33987774b0,
                0x1901f8a59a07779085e1f1fce94d0b5, 0x1f0e0b0e3a62366fee6a2641765f16e,
                0x96fc5a403abdd19bc653b52d410a069c, 0x5e4ad4077a691c294ac88d36185e496,
                0x3c6a2416df815c85f2f1326919009802, 0x6441d88bee5b6eea1b66b3982874412,
                0x845916431b53e9d78311a910df026bcc, 0x2354ea78c1ca1951493f6826dbdd493,
                0x3b66ea328f9701b52c56d31ebb82256a, 0x12407d189fa0eb0feccf68057fc3bc6,
                0x51f765f0d267f6f57a972cc07e0f48e3, 0x5675a0ca2280282592e0047f83b2535,
                0xa8b9689fec156717c4a5120601c41fcd,
            ],
            gate_challenges: array![
                0xee2127fe786940bb685fd25ecb0a537c, 0x2f1028b4a59de0cac31f53b63db20d2e,
                0xfb5ae9603b76f7aed1e5a14157378978, 0x4a19e37d0878fd8f521828612cb250a9,
                0x14e20a0ed4238f833f97e3c7b74c77eb, 0xc87d18ee4c3b0fb1bebb4c295e04cac1,
                0x303ab4cec9496b4b65f3716ac2547cdf, 0xf58575dd6838e3795c034e737c98a431,
                0x242466fec5fe1e9b0f26215827919698, 0x9307e3e081615f1709de6f12850ceaa1,
                0x2014ea8c756bff8e6b918bcdf55000df, 0x5cc6b4ac34c3cf9319ba144601222fc1,
                0xc55d9a22ba904f6cd636143cb58a7b2a, 0xac06dab2471fb056431a2fc6f93eaed7,
                0x82d79ae0857ec91ddc13c5e618e79e17, 0x650903f28846523990153329ac5c8e9e,
                0x9c430bda2022cf0a6663249ec10f9af6, 0x11c476e611346ba156e77f4bd804c1f8,
                0x89f377a91439acfe971d6d061a9a2615, 0x72dcb566e8ab06dd97c82c5fb5186ff8,
                0x8e0af90e22d2636d00ba5e31d0237b3f, 0x9e5394fd040455d9bfd733662265367,
                0x19ac26f4677ef91e834cf14b1e16ce12, 0xe9936175e513269ae6b00e37bfb6bc93,
                0x8d4de09acf53151d9fb5fd74d9e10625, 0xd661b69649e661847a92e5e67a564c81,
                0x6b1e5eaf27e5f54d671f823ddc3bfa96, 0x89d7431e2a81ddf4057ad40274e472c8,
            ],
            sum_check_u_challenges: array![
                0xfc0710cf2a6a1f2480a43e2b3e9d3277, 0x683db0ad448506a7949cecb2842929bf,
                0x46bbc250e295d5ccba7aed39963b75c4, 0xa4b4fb8dc1810f0ec2d0613dc443a77f,
                0xca975284ddcaf368c4fc7d812ea256d0, 0xdb26354b1880a7327ffd1a8b0bbc91ee,
                0x71dde072d42e195853998f560618c1c7, 0x1d60498a54d9484f72f3cdcf873e7639,
                0x129ccb4d6ab1ef1280572f07968e281c, 0x5de155d58d75e84c0e8944cc8fedb99,
                0x17462f677ea380428090970ec90745ee, 0xdbc91db8aa997205388f8bbc589d717a,
                0xc38421f2beeb540ba8e6120b31ff4a9d, 0x74afa4f8871a91c1698365592fa6b002,
                0x3b661b3ae548219a2edd7cd660818f65, 0x609f01ac93d688ffd059feab368e1349,
                0x349f8aa70db5299bfa597126a3120270, 0xfd3380f249b1928526ef703fc0f74350,
                0xe4143f7d103df9dd103f19fdf8c01146, 0xa663bab371addd27c3426443789d3196,
                0x8fb5dc96695bcd94b880b6164dfb96a1, 0x188b23157ed7bbcbd30e060190eae4bb,
                0xec173f2b52aebf71fe6c7e14057d0f9e, 0xf59ddb21358c37aa28333cfa23f8f70f,
                0x80449250c18dfb612ab11a24b257a794, 0x49809681831668d4092870036df4b7a5,
                0xb1ca1d67393d866e905b3a2b3f954c5b, 0xfab8febad68fb56cb205d8ca63260a18,
            ],
            rho: 0xc1bd8126cab5af7664133f2d4e714559,
            gemini_r: 0x535da5cae3de76645a1fc327c9bf25c9,
            shplonk_nu: 0x7af938cbc6462f2380acc7808a472ca2,
            shplonk_z: 0xc11ce5584933de1940db598489574f2d,
        };
        assert_eq!(transcript.eta, expected.eta);
        assert_eq!(transcript.eta_two, expected.eta_two);
        assert_eq!(transcript.eta_three, expected.eta_three);
        assert_eq!(transcript.beta, expected.beta);
        assert_eq!(transcript.gamma, expected.gamma);
        assert_eq!(transcript.alphas, expected.alphas);
        assert_eq!(transcript.gate_challenges, expected.gate_challenges);
        assert_eq!(transcript.sum_check_u_challenges, expected.sum_check_u_challenges);
        assert_eq!(transcript.rho, expected.rho);
        assert_eq!(transcript.gemini_r, expected.gemini_r);
        assert_eq!(transcript.shplonk_nu, expected.shplonk_nu);
        assert_eq!(transcript.shplonk_z, expected.shplonk_z);
    }
}
