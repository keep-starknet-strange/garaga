pub mod keccak_transcript;

use garaga::definitions::G1Point;
use garaga::definitions::u288;

pub struct HonkProof {
    pub circuit_size: usize,
    pub public_inputs_size: usize,
    pub public_inputs_offset: usize,
    pub public_inputs: Array<u256>,
    pub w1: G1Point,
    pub w2: G1Point,
    pub w3: G1Point,
    pub w4: G1Point,
    pub z_perm: G1Point,
    pub lookup_read_counts: G1Point,
    pub lookup_read_tags: G1Point,
    pub lookup_inverses: G1Point,
    pub sumcheck_univariates: Array<Array<u288>>,
    pub sumcheck_evaluations: Array<u288>,
    pub gemini_fold_comms: Array<G1Point>,
    pub gemini_a_evaluations: Array<u288>,
    pub shplonk_q: G1Point,
    pub kzg_quotient: G1Point,
}


pub struct HonkVk {
    circuit_size: usize,
    log_circuit_size: usize,
    public_inputs_size: usize,
    qm: G1Point,
    qc: G1Point,
    ql: G1Point,
    qr: G1Point,
    qo: G1Point,
    q4: G1Point,
    qArith: G1Point,
    qDeltaRange: G1Point,
    qAux: G1Point,
    qElliptic: G1Point,
    qLookup: G1Point,
    qPoseidon2External: G1Point,
    qPoseidon2Internal: G1Point,
    s1: G1Point,
    s2: G1Point,
    s3: G1Point,
    s4: G1Point,
    id1: G1Point,
    id2: G1Point,
    id3: G1Point,
    id4: G1Point,
    t1: G1Point,
    t2: G1Point,
    t3: G1Point,
    t4: G1Point,
    lagrange_first: G1Point,
    lagrange_last: G1Point,
}

