use core::keccak;
use core::traits::Into;

#[derive(Drop)]
struct G1Point256 {
    x: u256,
    y: u256,
}

#[derive(Drop)]
struct G1PointProof {
    x0: u256,
    x1: u256,
    y0: u256,
    y1: u256,
}

const POW2_136: u256 = 0x10000000000000000000000000000000000;
const Fr: u256 = 21888242871839275222246405745257275088548364400416034343698204186575808495617;

const NUMBER_OF_SUBRELATIONS: usize = 26;
const NUMBER_OF_ALPHAS: usize = NUMBER_OF_SUBRELATIONS - 1;
const CONST_PROOF_SIZE_LOG_N: usize = 28;

impl ProofPointIntoPoint of Into<G1PointProof, G1Point256> {
    fn into(self: G1PointProof) -> G1Point256 {
        G1Point256 { x: self.x0 + self.x1 * POW2_136, y: self.y0 + self.y1 * POW2_136, }
    }
}

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
        high: core::integer::u128_byte_reverse(word.low)
    }
}


// Add u64 as u256 to keccak input
// Expects u64 big endian.
#[inline]
fn append_u64_as_u256(ref arr: Array<u64>, val: u64) {
    arr.append(0);
    arr.append(0);
    arr.append(0);
    arr.append(u64_byte_reverse(val));
}

#[inline]
fn append_proof_point(ref arr: Array<u64>, point: G1PointProof) {
    keccak::keccak_add_u256_be(ref arr, point.x0);
    keccak::keccak_add_u256_be(ref arr, point.x1);
    keccak::keccak_add_u256_be(ref arr, point.y0);
    keccak::keccak_add_u256_be(ref arr, point.y1);
}

// Keccak little endian output to big endian challenge.
// Converts to big endian, then takes modulo Fr.
fn ke_le_out_to_ch_be(ke_le_out: u256) -> u256 {
    let ke_be: u256 = u256_byte_reverse(ke_le_out);
    let ch_be: u256 = ke_be % Fr;
    ch_be
}

// Return eta and last keccak output
pub fn get_eta_challenges(
    circuit_size: u64,
    pub_inputs_size: u64,
    pub_inputs_offset: u64,
    pub_inputs: Array<u256>,
    w1: G1PointProof,
    w2: G1PointProof,
    w3: G1PointProof
) -> (Etas, u256) {
    let mut k_input: Array<u64> = array![];
    append_u64_as_u256(ref k_input, circuit_size);
    append_u64_as_u256(ref k_input, pub_inputs_size);
    append_u64_as_u256(ref k_input, pub_inputs_offset);
    for pub_i in pub_inputs {
        keccak::keccak_add_u256_be(ref k_input, pub_i);
    };
    append_proof_point(ref k_input, w1);
    append_proof_point(ref k_input, w2);
    append_proof_point(ref k_input, w3);

    let ke_out: u256 = keccak::cairo_keccak(
        ref k_input, last_input_word: 0, last_input_num_bytes: 0
    );
    let ch_be: u256 = ke_le_out_to_ch_be(ke_out);

    let mut k_input_2: Array<u64> = array![];
    keccak::keccak_add_u256_be(ref k_input_2, ch_be);

    let ke_out_2: u256 = keccak::cairo_keccak(
        ref k_input_2, last_input_word: 0, last_input_num_bytes: 0
    );

    let ch_2_be: u256 = ke_le_out_to_ch_be(ke_out_2);

    (Etas { eta: ch_be.low, eta2: ch_be.high, eta3: ch_2_be.low, }, ch_2_be,)
}


// Return beta, gamma, and last keccak output.
// Outut :
// ch_be.
// beta = ch_be.low, gamma = ch_be.high, last_keccak_output = ch_be.
pub fn get_beta_gamma_challenges(
    prev_keccak_output: u256,
    lookup_read_counts: G1PointProof,
    lookup_read_tags: G1PointProof,
    w4: G1PointProof,
) -> u256 {
    let mut k_input: Array<u64> = array![];
    keccak::keccak_add_u256_be(ref k_input, prev_keccak_output);
    append_proof_point(ref k_input, lookup_read_counts);
    append_proof_point(ref k_input, lookup_read_tags);
    append_proof_point(ref k_input, w4);

    let ke_out: u256 = keccak::cairo_keccak(
        ref k_input, last_input_word: 0, last_input_num_bytes: 0
    );
    let ch_be: u256 = ke_le_out_to_ch_be(ke_out);

    ch_be
}


pub fn generate_alpha_challenges(
    prev_keccak_output: u256, lookup_inverse: G1PointProof, z_perm: G1PointProof,
) -> Array<u128> { // -> [u256; NUMBER_OF_ALPHAS]
    let mut k_input: Array<u64> = array![];
    keccak::keccak_add_u256_be(ref k_input, prev_keccak_output);
    append_proof_point(ref k_input, lookup_inverse);
    append_proof_point(ref k_input, z_perm);

    let mut alpha_XY: u256 = ke_le_out_to_ch_be(
        keccak::cairo_keccak(ref k_input, last_input_word: 0, last_input_num_bytes: 0)
    );

    let mut alphas: Array<u128> = array![];
    alphas.append(alpha_XY.low);
    alphas.append(alpha_XY.high);

    // Asumme N_alphas > 2 and N_alphas is odd.
    for _ in 1
        ..NUMBER_OF_ALPHAS
            / 2 {
                let mut k_input_i: Array<u64> = array![];
                keccak::keccak_add_u256_be(ref k_input_i, alpha_XY);
                let _alpha_XY: u256 = ke_le_out_to_ch_be(
                    keccak::cairo_keccak(ref k_input_i, last_input_word: 0, last_input_num_bytes: 0)
                );

                alphas.append(_alpha_XY.low);
                alphas.append(_alpha_XY.high);

                alpha_XY = _alpha_XY;
            };

    // Last alpha (odd number of alphas)

    let mut k_input_last: Array<u64> = array![];
    keccak::keccak_add_u256_be(ref k_input_last, alpha_XY);
    let alpha_last: u256 = ke_le_out_to_ch_be(
        keccak::cairo_keccak(ref k_input_last, last_input_word: 0, last_input_num_bytes: 0)
    );

    alphas.append(alpha_last.low);

    assert(alphas.len() == NUMBER_OF_ALPHAS, 'Wrong number of alphas');

    alphas
}


pub fn generate_gate_challenges(prev_keccak_output: u256,) -> Array<u128> {
    let mut gate_challenges: Array<u128> = array![];

    let mut gate_challenge: u256 = prev_keccak_output;
    for _ in 0
        ..CONST_PROOF_SIZE_LOG_N {
            let mut k_input: Array<u64> = array![];
            keccak::keccak_add_u256_be(ref k_input, gate_challenge);
            let _gate_challenge: u256 = ke_le_out_to_ch_be(
                keccak::cairo_keccak(ref k_input, last_input_word: 0, last_input_num_bytes: 0)
            );
            gate_challenges.append(_gate_challenge.low);
            gate_challenges.append(_gate_challenge.high);
            gate_challenge = _gate_challenge;
        };

    gate_challenges
}
