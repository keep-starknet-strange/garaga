use core::array::array_slice;
use core::keccak;
use core::poseidon::hades_permutation;
use core::traits::Into;
use garaga::definitions::G1Point;
use garaga::utils::noir::{G1Point256, G1PointProof, HonkProof, HonkVk};

const POW2_136: u256 = 0x10000000000000000000000000000000000;
const POW2_136_NZ: NonZero<u256> = 0x10000000000000000000000000000000000;
const Fr: u256 = 21888242871839275222246405745257275088548364400416034343698204186575808495617;

const NUMBER_OF_SUBRELATIONS: usize = 26;
const NUMBER_OF_ALPHAS: usize = NUMBER_OF_SUBRELATIONS - 1;
const CONST_PROOF_SIZE_LOG_N: usize = 28;
const BATCHED_RELATION_PARTIAL_LENGTH: usize = 8;
const NUMBER_OF_ENTITIES: usize = 40;


impl ProofPointIntoPoint256 of Into<G1PointProof, G1Point256> {
    fn into(self: G1PointProof) -> G1Point256 {
        G1Point256 { x: self.x0 + self.x1 * POW2_136, y: self.y0 + self.y1 * POW2_136 }
    }
}

impl Point256IntoProofPoint of Into<G1Point256, G1PointProof> {
    fn into(self: G1Point256) -> G1PointProof {
        let (x1, x0) = DivRem::div_rem(self.x, POW2_136_NZ);
        let (y1, y0) = DivRem::div_rem(self.y, POW2_136_NZ);
        G1PointProof { x0: x0, x1: x1, y0: y0, y1: y1 }
    }
}

impl ProofPointIntoCircuitPoint of Into<G1PointProof, G1Point> {
    fn into(self: G1PointProof) -> G1Point {
        let pt_256: G1Point256 = self.into();
        let pt: G1Point = G1Point { x: pt_256.x.into(), y: pt_256.y.into() };
        pt
    }
}

pub impl Point256IntoCircuitPoint of Into<G1Point256, G1Point> {
    fn into(self: G1Point256) -> G1Point {
        G1Point { x: self.x.into(), y: self.y.into() }
    }
}

trait IHasher<T> {
    fn new() -> T;
    fn update_u64_as_u256(ref self: T, v: u64);
    fn update_0_256(ref self: T);
    fn update_gen_point(ref self: T);
    fn update(ref self: T, v: u256);
    fn digest(ref self: T) -> u256;
}

#[derive(Drop, Debug)]
struct KeccakHasherState {
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
struct StarknetHasherState {
    s0: felt252,
    s1: felt252,
    s2: felt252,
}

impl StarknetHasher of IHasher<StarknetHasherState> {
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
        // Constant Gen Point (1, 2) converted into G1PointProof and correctly reversed for keccak.
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
    ) -> (HonkTranscript, felt252) {
        let (etas, challenge) = get_eta_challenges::<
            T,
        >(
            circuit_size.into(),
            public_inputs_size.into(),
            public_inputs_offset.into(),
            honk_proof.public_inputs,
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

        let (base_rlc, _, _) = hades_permutation(shplonk_z.low.into(), shplonk_z.high.into(), 2);

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
            base_rlc,
        );
    }
}

#[derive(Drop)]
struct Etas {
    eta: u128,
    eta2: u128,
    eta3: u128,
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
            sumcheck_univariates.snapshot,
            i * BATCHED_RELATION_PARTIAL_LENGTH,
            BATCHED_RELATION_PARTIAL_LENGTH,
        ) {
            Option::Some(slice) => {
                let sumcheck_univariates_i = Span { snapshot: slice };
                for j in 0..BATCHED_RELATION_PARTIAL_LENGTH {
                    hasher.update(*sumcheck_univariates_i.at(j));
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
    use super::{
        G1Point256, HonkProof, HonkTranscript, HonkTranscriptTrait, KeccakHasherState,
        StarknetHasherState,
    };
    #[test]
    fn test_transcript_keccak() {
        let vk = get_vk();
        let proof = get_proof_keccak();
        let (transcript, _) = HonkTranscriptTrait::from_proof::<
            KeccakHasherState,
        >(vk.circuit_size, vk.public_inputs_size, vk.public_inputs_offset, proof);
        let expected = HonkTranscript {
            eta: 0x8f552b09842921c3d8e179c45df06f60,
            eta_two: 0x12fbf1fd24f38c808ec773d904e06a74,
            eta_three: 0x31848febf1a2baa2787dce151b3af87f,
            beta: 0xd862459f6b68ff32eb00329415abbeb4,
            gamma: 0x490beb870562adcb4b5b369ecaad99a,
            alphas: array![
                0xeb60fa249708fce6448e9d3b01921b45,
                0x2dcc3670321250579136fa1f0cdcb82c,
                0x2fdd6fb0ec0576290d75a3787fab4943,
                0x23bfbbb4313d4d62912624d0c7af3778,
                0x2ea2f2d064271b5ba8ea40a93e5508a3,
                0x2e44916f8a2a4ae7397f4d70a32bee1b,
                0x53d85eacf5d74ec893c9642feab95374,
                0x1c68457e0064ae9ca5cdb7dc9a6a9877,
                0xf9967d7ff15b716e4732d03d770b4b7c,
                0x16ec6f6fe2cdeda6a992e17c5d84e9f5,
                0x2f3f85623409fdc6a2ff32dcdae23e47,
                0xb7ed594e3690a48788d067c3c6eab49,
                0x47083760a50211d763a0e28c85ca0ab2,
                0x17f16c9ed3ef1d10ea5adf32add4a5bd,
                0xd8ef1260fa77b69b5af8bd9e8839fbfa,
                0x457b064b31e9c7c3f8df87132c3be60,
                0xa0f795db922a9c0f842c25cd129bee7,
                0x2bd5e75480cfd6d8bdf15239c4ee2de1,
                0x6acf0ddbb7736b7c60ef36f3602d7644,
                0x184ca1e15327827bfb91b6ff00c63c35,
                0x599e7c7c1b77951ef0f9c29e4767b721,
                0x218203e486042d51b09588fcc37f3f6,
                0xd6467fb2e7bb03ce03b52206b69a2af7,
                0x1671504835ea499e8eca67268db3e28e,
                0xb60028b150a4357f47682e533f5f9992,
            ],
            gate_challenges: array![
                0x81f4f81b706ba682619d2f5ba0729be6,
                0x21c790fac296d7c844d88f1dd2f60035,
                0x1a6dee6be12c075b76ec039da01e8abb,
                0x3edb03832d3937d142722417c84b2b3,
                0xc0a2e585fb420359ea6117221d1454c5,
                0x23c1677ee0de9bad0de211e565ea8519,
                0x4dba9384b4bca6565b27d243ea5ee01d,
                0x6f0e395b8793e96026e680365360946f,
                0x871b3dc857c8c4b0298e140955651769,
                0xcc7bc68b460a5ab986da8cdbb19ceadd,
                0xbd5522614f0f52b01f111a68e78847be,
                0x82662ff38da8507e9fc1aa266d7cac19,
                0x365548359170099aaf47b8b28e2ec001,
                0xf2b5ef5d5820d73eae40593062af0a13,
                0x10e84f11b06b083aa8dfb3610dee6591,
                0xac8c27816a32284cc9894b8c17f0960a,
                0xfb17ebba25c7145f502f9bfaf3ed7bd3,
                0x91720e68e07f55ceaa0dc6aa64d0c119,
                0x23f4b1dff3848ed7d629279b639dd5b3,
                0x7865fd4964ea388a73d507a08c4c30e8,
                0xcb1c8bb2b147c5a65ca5cccfa22a2c64,
                0xbe176fab8c0c15b088af4cb51073a2b6,
                0x833f40aaaa002056498d064923f6fa2e,
                0x5591d25fdc27a8115a7df89b873bea0,
                0x535eca64b27d035c67e6ef51992fab71,
                0x9844b56d7dc0be5d3666264c83edb8c0,
                0x8c614118f36b73944f7650d110cf2023,
                0xd45a9a753c738faf5af35cd808904ae2,
            ],
            sum_check_u_challenges: array![
                0x5deab7fd7bf68b847a04d56063fb5d54,
                0x800dbc1afedb937488f8e86702ef756e,
                0xf6bb6a9ac1c2904b516dd0020a1f6bab,
                0xcc84ad1bfc96d5c6688c2e4176ec9427,
                0x4efcedd7ca1db5771a6ac6bf32bfa84e,
                0x3a118eec6a7140d8623848460005680b,
                0x131694194defa18110185afeddf2d1b2,
                0xe7b0d23ec9a136263e91f750fd36e161,
                0xe26c687e34c0724f7e523fde786be010,
                0xcd9cbb30d202796f1cbdc37a8fcd9f26,
                0x9005a9a774ae28e14dd115c972516b14,
                0xedae819a97523359ac10a1106c002e74,
                0x26caef78b45d503bbc9055b536e5f8b4,
                0xa8a6288913d1d3ecd0990f6c42bc13d3,
                0x3e7f45a0dccbd904d6a9148b5115dbbc,
                0x8cb0edfbdae121efacbddbcc7175107d,
                0x52dc4bfa0bec646f9d4fab911822d8ad,
                0xb2e49bb080ffee7fcdd55a62a528cb88,
                0x82bbbd3e6ecaed0bdea29ff03cc7e8ce,
                0x4ade5e83d94d31f90492f8d3a6e1e682,
                0xf614ae1527c8e69d49d500bf416dd26c,
                0xea8ff1d92d99d4b509c6264d5b94cc97,
                0x520a5a2a6c9ead1fd907da6aa797130e,
                0x3a906556ff880bd8db8c09c478318652,
                0x11ef1d24e255c77fee63d1b1a3556b66,
                0xf6540bb65059d956b407a30b886bc5be,
                0xac0acd7d0849846373d07f8decd56eee,
                0xa69e1a25cf5789dc59d0e83dc74e6b01,
            ],
            rho: 0xee4eb74b3e344e1e7198579a6d05c83f,
            gemini_r: 0xd8811fa4e82faef06a389ebfa77269a2,
            shplonk_nu: 0x39db5d248a75833cb7752419437b987e,
            shplonk_z: 0x14fe91a40f4b58a1a846076a2f3f0181,
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
        let (transcript, _) = HonkTranscriptTrait::from_proof::<
            StarknetHasherState,
        >(vk.circuit_size, vk.public_inputs_size, vk.public_inputs_offset, proof);
        let expected = HonkTranscript {
            eta: 0xacab94703ab6d0ac76a257baf5b3cc47,
            eta_two: 0x48aa9b84794b8501475d1acdde7c12,
            eta_three: 0x75e7a26159152b2e8ffe0d819208882a,
            beta: 0x964133a1e77ef97b1e8f861fc2c60723,
            gamma: 0x5f6f7c58fa879b7ce52e395dfdce364,
            alphas: array![
                0xe7911296f60df1760a5be7afee898a12,
                0x6fb11a8bcf4528a66e537cd7ec05e34,
                0x2f586b8a5e1b275bfdf60dbdb2608fd5,
                0x685bfbd08ddad1709c19634a02c9f77,
                0xbd0ba4fcee9fd962935586e8a7d5339e,
                0x6a6fb02b6aba4e2445383eaf0520be7,
                0x9022363a8d8b370b056fac4ff4fa7a,
                0x441c400cf1827b3466bed56e84e2cf9,
                0x18a3e1de86d1c66cba855a5fe580daea,
                0x742ce348dc252d7b70722f123cc2cba,
                0x221fd3dab521b999036b1a3b5208ee0b,
                0xa449dec06766699424ccf3db36acd3,
                0x76397a396545e559b9d760d10709b00e,
                0x69ee542904a0fb3acb14f9a31110346,
                0xced4926c55cad486c97940a7c7a50358,
                0x13cfa991749b10cb201df1d4694e567,
                0xa0eb8ec6324d4ae17efb7b6cfa659a1,
                0x42644dc16c5395ab1c06f98dd37e7b3,
                0x969d8263384583d371bcad8d4cf069ea,
                0x70cf93d413328ff7d168e0000751abf,
                0x126e690d2bc4a9082d9be37a26ca4306,
                0x5caf12ab713e66155c9f8235fabbfbf,
                0x6d6241b94e8cb208f1dd22dd76effc64,
                0x6deb65afd65fbb307c503d7106cdfd9,
                0x2f71118a04e7451931fd629d305f0164,
            ],
            gate_challenges: array![
                0x69c37c6c2ffba2f07e39d26432181f2e,
                0x23ac910b6f51fb3d81a9d968f6f00b44,
                0x7d16fc9dc0f496c5dfaad141b7ff2785,
                0xfda0c15eddaa9c5deb5f3ada049925b5,
                0x4e979fc84f06b5823fe74b430dd22d12,
                0x8d1b8e63324d96c697f7e7b0ef9ab032,
                0x1b2a8f9bad182647bb0808319ae8802b,
                0xf798302b1d90fa22890f106f73fd52c3,
                0xdf416794a76cf1a268eb3800bdbb7a27,
                0xc3070672a9d001a3e201f3567d3cf26,
                0x1173d7336be0ca588ddb468918c30d44,
                0x443fccd696e9694ccb17c5f41e718827,
                0x7d36241e3cbf818664a14e89d5db7e1b,
                0x8c382222a14ad2e385dcb00929dead66,
                0x39b3f265f401af6c81164c854f792c37,
                0x3739d9af74ff462191040a49b332e701,
                0x369acb748865636da7853ae51af388b,
                0xcb801712dd82470e1aafb760e5447c6c,
                0x9dccfa35df07b05ba983d4bd27606431,
                0xfb170e32c43c8934ba2b03c4b7efe738,
                0x75d7f7c00e6f9ca5f65e34581fac33f0,
                0xc5b490a4215093be8f547c1c521ce016,
                0x25cfd09a174499d84b961cc1c6434797,
                0x33371c22958a398e5e257d1e5aeb29fe,
                0xd8d4d07688225e278de2e7dd5f01f1f,
                0x60be980e8c25ee53c7f6cdbfa3d43b4,
                0xbcfe51021c0c9b872c999ca50c883273,
                0xdef59c8cc9e2e6d841a4559b7f559b18,
            ],
            sum_check_u_challenges: array![
                0xa6f62ac9a6d65343c89cd8b8bbce38a4,
                0x36e11608428ed71dbd27d2dc40647550,
                0xe250aec24cb8748159deb84786e8853f,
                0xa6a51b832a23b1eaebfcee0cb758aa93,
                0xca680cd52d831e80d2b61431027bed86,
                0x27b7dff2043dae2b3910268eb35cdd68,
                0xdbe5d1a716a1f9dc458893fc415aef70,
                0x1b76a47d6a8c32b957dd625cc6fcd5b7,
                0xc91d6e073a1669b17f6536da54f86139,
                0x50041fb3db843e4bfa45e286f2df7b10,
                0xee0e052cde436b85dd6a70b2116c34ba,
                0x60954981aa640aa8ae70deae98b47898,
                0xee180b4e36aa83a35bee4ae1ee6a5cf,
                0x9e54bea31704ef7dc466925c4c7deebc,
                0x755ba40e9e747929612c6165ac3dd9d6,
                0xaf5a11d38209107eeed8c4a01cefbfb2,
                0x95b6984e042fb16e1583b9bcf1699ee,
                0x91f09bf40ddc06a92ee187cd7f43b8f0,
                0x294d4583b2dca4d781e4967abd742e06,
                0x96f0382505ef58d0b464e1b247bd84ee,
                0x6c45fab85566fd700bbf270cb1417500,
                0xe6546fb2b8ca3f66ca59d4d5d9ee0adb,
                0x7685215e239f8afbee74cfea22ead170,
                0xa27092481e320c2bd02609605e924bd5,
                0x30e9f641f7090befc71de050ff339d6b,
                0x8cd39327f4927bfe90bec78131e0b76b,
                0x139dbfb9449b54cdd7bac7d1fffcbd78,
                0x666c0386e0657e4e2f09e44de17291c5,
            ],
            rho: 0xa94de3afcb56c451d2730542b106af2a,
            gemini_r: 0xe642b1a1b5ea29ec784add59062acad2,
            shplonk_nu: 0x2cb604ccd14cc249f3b4b25bb3f8c518,
            shplonk_z: 0x7d749235fb659af386c5ecaf5eebb736,
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
