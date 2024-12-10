use core::keccak;
use core::traits::Into;
use core::poseidon::hades_permutation;
use garaga::definitions::G1Point;
use garaga::utils::noir::{HonkProof, G1Point256, G1PointProof};

const POW2_136: u256 = 0x10000000000000000000000000000000000;
const POW2_136_NZ: NonZero<u256> = 0x10000000000000000000000000000000000;
const Fr: u256 = 21888242871839275222246405745257275088548364400416034343698204186575808495617;

const NUMBER_OF_SUBRELATIONS: usize = 26;
const NUMBER_OF_ALPHAS: usize = NUMBER_OF_SUBRELATIONS - 1;
const CONST_PROOF_SIZE_LOG_N: usize = 28;
const BATCHED_RELATION_PARTIAL_LENGTH: usize = 8;
const NUMBER_OF_ENTITIES: usize = 44;


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
    fn from_proof(honk_proof: HonkProof) -> (HonkTranscript, felt252) {
        let (etas, challenge) = get_eta_challenges(
            honk_proof.circuit_size,
            honk_proof.public_inputs_size,
            honk_proof.public_inputs_offset,
            honk_proof.public_inputs,
            honk_proof.w1.into(),
            honk_proof.w2.into(),
            honk_proof.w3.into(),
        );
        let beta_gamma = get_beta_gamma_challenges(
            challenge,
            honk_proof.lookup_read_counts.into(),
            honk_proof.lookup_read_tags.into(),
            honk_proof.w4.into(),
        );
        let (alphas, challenge) = generate_alpha_challenges(
            beta_gamma, honk_proof.lookup_inverses.into(), honk_proof.z_perm.into(),
        );
        let (gate_challenges, challenge) = generate_gate_challenges(challenge);

        let (sum_check_u_challenges, challenge) = generate_sumcheck_u_challenges(
            challenge, honk_proof.sumcheck_univariates,
        );

        let rho = generate_rho_challenge(challenge, honk_proof.sumcheck_evaluations);
        let gemini_r = generate_gemini_r_challenge(rho, honk_proof.gemini_fold_comms);

        let shplonk_nu = generate_shplonk_nu_challenge(gemini_r, honk_proof.gemini_a_evaluations);
        let shplonk_z = generate_shplonk_z_challenge(shplonk_nu, honk_proof.shplonk_q.into());

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

#[cfg(test)]
mod tests {
    use super::{HonkProof, G1Point256, HonkTranscript, HonkTranscriptTrait};
    use garaga::utils::noir::get_proof;
    #[test]
    fn test_transcript() {
        let proof = get_proof();
        let (transcript, _) = HonkTranscriptTrait::from_proof(proof);
        let expected = HonkTranscript {
            eta: 0xb39d3e94753aae04abee4a2d8bcf33c8,
            eta_two: 0x2879f27d8c79fcf349a1614e615eb930,
            eta_three: 0x6dd69c9f0d538e02614343ebbaec94c4,
            beta: 0x653c95e184f5305209746f10f3401ddc,
            gamma: 0x2a77ba7a2b7e471087e83275c002c987,
            alphas: array![
                0x4d024d88774eb414929f9236ddc0ff0b,
                0xc27607fec7910292d3db029784a3bd2,
                0x313ece568283901f1001c2f3e4f70ff0,
                0x29be68a73a72e703f50eb4e4a71b380c,
                0x9a145a2c018cffde9da5b9d666266ec2,
                0x1357a9f3a86780304111dee8c50c73b6,
                0x76a4d34da274f0dc6404b38d33bca0c0,
                0xf50c391d900c25cb780414d77c9af62,
                0xd3fb3e8d23f8ce6552637f50ae8f98eb,
                0x2f82e3b0482e17260316d930ecf69e0e,
                0x58b37d1b41bee394811b70cad2b6ca92,
                0x5773e20e5193913b7d7a70aa97788de,
                0xe93903034d181faa5fd2514edc34e273,
                0x1e513b7823c3abe1e85abd5716850beb,
                0x76ee74561367b62c0a6ca6ab7c4eacf1,
                0x14c0384d6e14bc51b17456006be8f882,
                0x2b1fcd8bd6155bcfc07d4089f8519861,
                0x798085a9507b0c108763e11b9a35071,
                0x43ba9d0e796c9b64267952be08d0af20,
                0x268cec13edbe6acc95ae4854d5158e42,
                0x15b120271dff8cc2b9e39e807e4b0ff4,
                0x14092616193e2bd6e5345403d64fcd59,
                0x267ac64d556df27a9cc39032e8c7d6c3,
                0xc14b848a58c80950545e4bf6dd284e1,
                0xb09e53a5fb8c5308768299c33b143bd8,
            ],
            gate_challenges: array![
                0xc172dd2450a5c43df9f45a102035f4aa,
                0xd9e8e31dd1bf34b1fd2c8dc378718bad,
                0x3b18273b302fc3f7e291bde9e8f657af,
                0x63851884d3d82ee17736f752da9bac35,
                0xf209bde7aca3c49f2cadbe4dca83dde9,
                0x69f14a768158343825c27a938fbf36b5,
                0xec589c20c082a8bbc2a5358dffcbb029,
                0xcbc709637c971ff0235b30e22631d7c4,
                0xb21375f2d73fe9a9b9a0bc6ec2572958,
                0x245b66aebdb626945436091e17da60ac,
                0x62d7e222920e40d2706978b2e032cef5,
                0xd7f22806ba3855643a24874eacad3416,
                0x471214514009909e9ab6cb05b004dcd2,
                0xc5ea117fcb3a2986a4a0a3b2524e8cda,
                0xc83493ac2556971a3705619eb92a536f,
                0xc5830917428e1bac8ddffd2455fd95a4,
                0xc285c631c4c8da6a4878d427ab0ee02e,
                0xbf75c5b1da0b6a57af698f776b4739ab,
                0x276eccfb8e82d126f2c292d9708dd761,
                0x9476a0a387149c8d1b78a58476b9efff,
                0x7ffa377781a42d05905df51f7fe83dff,
                0xbe0897e28f22aaf3c50014d76d49f4a0,
                0x62bcad183fec3655f642f8bd33895c5f,
                0x2cd23571aaa192e5525b3f440c21946d,
                0xabc55392a196f776e4e6c843c9076946,
                0x609cc20bb22f811a3c24e0c1f20deb03,
                0x15356ea3058bd02736fc6ee7fae12b0d,
                0xdee13f4571cd5267161d943456bc803b,
            ],
            sum_check_u_challenges: array![
                0xe61948888da551fcbd6481a7af8cf0c0,
                0x1bc9a638f9f0e48211e06f74fdc4ee30,
                0xb0494ceda348dd1ad61845b2820bb7a4,
                0xe1a0fcc92b7bfa7d75edec03b2500e70,
                0x49f16b7a01ed1d92bea9852b447cbbfa,
                0xb05ec1b687b95e039f37a9c102b6faa1,
                0x93f8c2d82054794f1d9bc5016a00093f,
                0x59690cf79013abb0d194ec0d621435cb,
                0xb092f424ff1f2dc7e55a9aec2bcd1b6a,
                0xb41ba16fc7d5b8771894145a6a4a3653,
                0xb7b0adaf7d801bae84bb10e77898104f,
                0xdcc650724f78f5544d9e4104c0c66049,
                0x9372338e1b74cefc0a9297fb6c9cdf2f,
                0xe7caf286270a5faab65e811c41b651ec,
                0xc3ecafac87e8f09ca2d644596fdf1843,
                0x680091c031e3e54068f30b1abbba4032,
                0xe923e5d1a9f802c0de0263b0847a98a7,
                0x1e082dbe7f823be4a12dc7fc18ff4ba,
                0xf97bd808c15fcecef5eafa333438370b,
                0xdfdcaff7ed6c257079dce44b5d1ad9d1,
                0x4cc20354eac16fac6ebafb10cd388f45,
                0xd0c31e08a9ca0944d44537b854c011da,
                0x65969933912dedee841ad8a92c062c7b,
                0x9ee2e4b83c5e0156a4902309cc087a9a,
                0x11e8bfbd21b91ca1bee77a21bbc35be8,
                0x10a6c496ccd27e38f0b8649a9470389f,
                0x48effcc28eda12ce3859196ddc398c76,
                0xc44b6fe342b5502bf9b7416f1f257b2e,
            ],
            rho: 0xa4bb7935b0320a044f9a06e7ce23f501,
            gemini_r: 0x7f80d41613ee8455f306ecb97366f6fb,
            shplonk_nu: 0x9f8c2321fe0106bf29aaadc94f24dea6,
            shplonk_z: 0xd704d217bac677a48ad056c8aa8f9e44,
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
    pub_inputs: Span<u256>,
    w1: G1PointProof,
    w2: G1PointProof,
    w3: G1PointProof,
) -> (Etas, u256) {
    let mut k_input: Array<u64> = array![];
    append_u64_as_u256(ref k_input, circuit_size);
    append_u64_as_u256(ref k_input, pub_inputs_size);
    append_u64_as_u256(ref k_input, pub_inputs_offset);
    for pub_i in pub_inputs {
        keccak::keccak_add_u256_be(ref k_input, *pub_i);
    };
    append_proof_point(ref k_input, w1);
    append_proof_point(ref k_input, w2);
    append_proof_point(ref k_input, w3);

    let ke_out: u256 = keccak::cairo_keccak(
        ref k_input, last_input_word: 0, last_input_num_bytes: 0,
    );
    let ch_be: u256 = ke_le_out_to_ch_be(ke_out);

    let mut k_input_2: Array<u64> = array![];
    keccak::keccak_add_u256_be(ref k_input_2, ch_be);

    let ke_out_2: u256 = keccak::cairo_keccak(
        ref k_input_2, last_input_word: 0, last_input_num_bytes: 0,
    );

    let ch_2_be: u256 = ke_le_out_to_ch_be(ke_out_2);

    (Etas { eta: ch_be.low, eta2: ch_be.high, eta3: ch_2_be.low }, ch_2_be)
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
        ref k_input, last_input_word: 0, last_input_num_bytes: 0,
    );
    let ch_be: u256 = ke_le_out_to_ch_be(ke_out);

    ch_be
}


pub fn generate_alpha_challenges(
    prev_keccak_output: u256, lookup_inverse: G1PointProof, z_perm: G1PointProof,
) -> (Array<u128>, u256) { // -> [u256; NUMBER_OF_ALPHAS]
    let mut k_input: Array<u64> = array![];
    keccak::keccak_add_u256_be(ref k_input, prev_keccak_output);
    append_proof_point(ref k_input, lookup_inverse);
    append_proof_point(ref k_input, z_perm);

    let mut alpha_XY: u256 = ke_le_out_to_ch_be(
        keccak::cairo_keccak(ref k_input, last_input_word: 0, last_input_num_bytes: 0),
    );

    let mut alphas: Array<u128> = array![];
    alphas.append(alpha_XY.low);
    alphas.append(alpha_XY.high);

    // Asumme N_alphas > 2 and N_alphas is odd.
    for _ in 1..NUMBER_OF_ALPHAS / 2 {
        let mut k_input_i: Array<u64> = array![];
        keccak::keccak_add_u256_be(ref k_input_i, alpha_XY);
        let _alpha_XY: u256 = ke_le_out_to_ch_be(
            keccak::cairo_keccak(ref k_input_i, last_input_word: 0, last_input_num_bytes: 0),
        );

        alphas.append(_alpha_XY.low);
        alphas.append(_alpha_XY.high);

        alpha_XY = _alpha_XY;
    };

    // Last alpha (odd number of alphas)

    let mut k_input_last: Array<u64> = array![];
    keccak::keccak_add_u256_be(ref k_input_last, alpha_XY);
    let alpha_last: u256 = ke_le_out_to_ch_be(
        keccak::cairo_keccak(ref k_input_last, last_input_word: 0, last_input_num_bytes: 0),
    );

    alphas.append(alpha_last.low);

    assert(alphas.len() == NUMBER_OF_ALPHAS, 'Wrong number of alphas');

    (alphas, alpha_last)
}


pub fn generate_gate_challenges(prev_keccak_output: u256) -> (Array<u128>, u256) {
    let mut gate_challenges: Array<u128> = array![];

    let mut gate_challenge: u256 = prev_keccak_output;
    for _ in 0..CONST_PROOF_SIZE_LOG_N {
        let mut k_input: Array<u64> = array![];
        keccak::keccak_add_u256_be(ref k_input, gate_challenge);
        let _gate_challenge: u256 = ke_le_out_to_ch_be(
            keccak::cairo_keccak(ref k_input, last_input_word: 0, last_input_num_bytes: 0),
        );
        gate_challenges.append(_gate_challenge.low);
        gate_challenge = _gate_challenge;
    };

    (gate_challenges, gate_challenge)
}


pub fn generate_sumcheck_u_challenges(
    prev_keccak_output: u256, sumcheck_univariates: Span<Span<u256>>,
) -> (Array<u128>, u256) {
    let mut sum_check_u_challenges: Array<u128> = array![];
    let mut challenge: u256 = prev_keccak_output;
    for i in 0..CONST_PROOF_SIZE_LOG_N {
        let mut k_input: Array<u64> = array![];
        keccak::keccak_add_u256_be(ref k_input, challenge);
        for j in 0..BATCHED_RELATION_PARTIAL_LENGTH {
            keccak::keccak_add_u256_be(ref k_input, *(*sumcheck_univariates.at(i)).at(j));
        };

        challenge =
            ke_le_out_to_ch_be(
                keccak::cairo_keccak(ref k_input, last_input_word: 0, last_input_num_bytes: 0),
            );
        sum_check_u_challenges.append(challenge.low);
    };

    (sum_check_u_challenges, challenge)
}


pub fn generate_rho_challenge(prev_keccak_output: u256, sumcheck_evaluations: Span<u256>) -> u256 {
    let mut k_input: Array<u64> = array![];
    keccak::keccak_add_u256_be(ref k_input, prev_keccak_output);
    for i in 0..NUMBER_OF_ENTITIES {
        keccak::keccak_add_u256_be(ref k_input, *sumcheck_evaluations.at(i));
    };

    ke_le_out_to_ch_be(
        keccak::cairo_keccak(ref k_input, last_input_word: 0, last_input_num_bytes: 0),
    )
}

pub fn generate_gemini_r_challenge(
    prev_keccak_output: u256, gemini_fold_comms: Span<G1Point256>,
) -> u256 {
    let mut k_input: Array<u64> = array![];
    keccak::keccak_add_u256_be(ref k_input, prev_keccak_output);
    for i in 0..CONST_PROOF_SIZE_LOG_N - 1 {
        append_proof_point(ref k_input, (*gemini_fold_comms.at(i)).into());
    };

    ke_le_out_to_ch_be(
        keccak::cairo_keccak(ref k_input, last_input_word: 0, last_input_num_bytes: 0),
    )
}

pub fn generate_shplonk_nu_challenge(
    prev_keccak_output: u256, gemini_a_evaluations: Span<u256>,
) -> u256 {
    let mut k_input: Array<u64> = array![];
    keccak::keccak_add_u256_be(ref k_input, prev_keccak_output);
    for i in 0..CONST_PROOF_SIZE_LOG_N {
        keccak::keccak_add_u256_be(ref k_input, *gemini_a_evaluations.at(i));
    };

    ke_le_out_to_ch_be(
        keccak::cairo_keccak(ref k_input, last_input_word: 0, last_input_num_bytes: 0),
    )
}

pub fn generate_shplonk_z_challenge(prev_keccak_output: u256, shplonk_q: G1PointProof) -> u256 {
    // # Shplonk Z :
    // hasher.update(c7)
    // x0, x1, y0, y1 = g1_to_g1_proof_point(proof.shplonk_q)
    // hasher.update(int.to_bytes(x0, 32, "big"))
    // hasher.update(int.to_bytes(x1, 32, "big"))
    // hasher.update(int.to_bytes(y0, 32, "big"))
    // hasher.update(int.to_bytes(y1, 32, "big"))

    // c8 = hasher.digest_reset()
    // shplonk_z, _ = split_challenge(c8)

    let mut k_input: Array<u64> = array![];
    keccak::keccak_add_u256_be(ref k_input, prev_keccak_output);
    append_proof_point(ref k_input, shplonk_q);

    ke_le_out_to_ch_be(
        keccak::cairo_keccak(ref k_input, last_input_word: 0, last_input_num_bytes: 0),
    )
}

