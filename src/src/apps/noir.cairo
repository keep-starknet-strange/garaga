pub mod zk_honk_transcript;

use garaga::apps::noir::zk_honk_transcript::{
    Fr, IHasher, KeccakHasherState, Point256IntoCircuitPoint,
};
use garaga::core::circuit::{into_u256_unchecked, u256_to_u384};
// use garaga::core::circuit::U64IntoU384;
use garaga::definitions::{G1Point, G1PointZero, G2Point, u384};
use garaga::definitions::{
    get_BN254_modulus, get_GRUMPKIN_modulus, get_eigenvalue, get_min_one_order, get_nG_glv_fake_glv,
    get_third_root_of_unity,
};
use garaga::ec_ops::{G1PointTrait, GlvFakeGlvHint, _ec_safe_add, _scalar_mul_glv_and_fake_glv};

#[derive(Drop, Copy, Serde)]
pub struct G1Point256 {
    pub x: u256,
    pub y: u256,
}

// BN254 coordinates fit in u256; other proof systems retain the generic u384 hint.
#[derive(Drop, Serde)]
pub struct HonkScalarMulHint {
    pub Q: G1Point256,
    pub u1: felt252,
    pub u2: felt252,
    pub v1: felt252,
    pub v2: felt252,
}

#[derive(Drop, Serde, Copy)]
pub struct ZKHonkProof {
    pub public_inputs: Span<u256>,
    pub pairing_point_object: Span<u256>,
    pub w1: G1Point256,
    pub w2: G1Point256,
    pub w3: G1Point256,
    pub w4: G1Point256,
    pub z_perm: G1Point256,
    pub lookup_read_counts: G1Point256,
    pub lookup_read_tags: G1Point256,
    pub lookup_inverses: G1Point256,
    pub libra_commitments: Span<G1Point256>,
    pub libra_sum: u256,
    pub sumcheck_univariates: Span<u256>,
    pub sumcheck_evaluations: Span<u256>,
    pub libra_evaluation: u256,
    pub gemini_masking_poly: G1Point256,
    pub gemini_masking_eval: u256,
    pub gemini_fold_comms: Span<G1Point256>,
    pub gemini_a_evaluations: Span<u256>,
    pub libra_poly_evals: Span<u256>,
    pub shplonk_q: G1Point256,
    pub kzg_quotient: G1Point256,
}

pub fn validate_zk_honk_proof(proof: ZKHonkProof, log_n: usize, public_inputs_size: usize) -> bool {
    if public_inputs_size < 8 || log_n < 3 || log_n > 25 {
        return false;
    }
    if proof.public_inputs.len() != public_inputs_size
        - 8 || proof.pairing_point_object.len() != 8 || proof.sumcheck_univariates.len() != log_n
            * 9
                || proof.sumcheck_evaluations.len() != 41
                || proof.libra_commitments.len() != 3
                || proof.gemini_fold_comms.len() != log_n
        - 1 || proof.gemini_a_evaluations.len() != log_n || proof.libra_poly_evals.len() != 4 {
        return false;
    }
    for values in array![
        proof.public_inputs, proof.sumcheck_univariates, proof.sumcheck_evaluations,
        proof.gemini_a_evaluations, proof.libra_poly_evals
    ] {
        for value in values {
            if *value >= Fr {
                return false;
            }
        };
    }
    if proof.libra_sum >= Fr || proof.libra_evaluation >= Fr || proof.gemini_masking_eval >= Fr {
        return false;
    }
    for i in 0_usize..8_usize {
        let limb = *proof.pairing_point_object.at(i);
        if i % 2 == 0 {
            if limb.high >= 256 {
                return false;
            }
        } else {
            if limb.high != 0 || limb.low >= 0x1000000000000000000000000000000 {
                return false;
            }
        }
    }
    for point in array![
        proof.w1, proof.w2, proof.w3, proof.w4, proof.z_perm, proof.lookup_read_counts,
        proof.lookup_read_tags, proof.lookup_inverses, proof.gemini_masking_poly, proof.shplonk_q,
        proof.kzg_quotient
    ] {
        if !canonical_proof_point(point) {
            return false;
        }
    }
    for point in proof.libra_commitments {
        if !canonical_proof_point(*point) {
            return false;
        }
    }
    for point in proof.gemini_fold_comms {
        if !canonical_proof_point(*point) {
            return false;
        }
    }
    true
}

fn canonical_proof_point(point: G1Point256) -> bool {
    let modulus: u256 = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47;
    point.x < modulus && point.y < modulus
}

fn decode_accumulator_coordinate(low: u256, high: u256) -> u256 {
    assert(low.high < 256, 'Invalid accumulator low limb');
    assert(
        high.high == 0 && high.low < 0x1000000000000000000000000000000,
        'Invalid accumulator high limb',
    );
    u256 { low: low.low, high: low.high + high.low * 256 }
}

fn decode_accumulator_point(limbs: Span<u256>) -> G1Point {
    let point = G1Point256 {
        x: decode_accumulator_coordinate(*limbs.at(0), *limbs.at(1)),
        y: decode_accumulator_coordinate(*limbs.at(2), *limbs.at(3)),
    };
    assert(canonical_proof_point(point), 'Invalid accumulator coordinate');
    let point: G1Point = point.into();
    point.assert_on_curve_excluding_infinity(0);
    point
}

pub fn aggregate_pairing_accumulator(
    limbs: Span<u256>, outer_lhs: G1Point, outer_rhs: G1Point, hints: Span<felt252>,
) -> (G1Point, G1Point) {
    assert(limbs.len() == 8, 'Invalid accumulator length');
    let mut is_default = true;
    for value in limbs {
        if *value != 0 {
            is_default = false;
        }
    }
    if is_default {
        assert(hints.is_empty(), 'Unexpected recursion hints');
        return (outer_lhs, outer_rhs);
    }
    assert(hints.len() == 16, 'Invalid recursion hint length');
    let inner_lhs = decode_accumulator_point(limbs.slice(0, 4));
    let inner_rhs = decode_accumulator_point(limbs.slice(4, 4));
    let mut hasher: KeccakHasherState = IHasher::new();
    for point in array![inner_lhs, inner_rhs, outer_lhs, outer_rhs] {
        hasher.update(into_u256_unchecked(point.x));
        hasher.update(into_u256_unchecked(point.y));
    }
    let separator = u256_to_u384(hasher.digest());
    let mut hints = hints;
    let lhs_hint: HonkScalarMulHint = Serde::deserialize(ref hints).unwrap();
    let rhs_hint: HonkScalarMulHint = Serde::deserialize(ref hints).unwrap();
    let lhs = honk_scalar_mul(outer_lhs, separator, lhs_hint);
    let rhs = honk_scalar_mul(outer_rhs, separator, rhs_hint);
    (
        _ec_safe_add(lhs, inner_lhs, get_BN254_modulus(), 0),
        _ec_safe_add(rhs, inner_rhs, get_BN254_modulus(), 0),
    )
}

// Share this implementation across the main MSM and both recursive accumulator components.
// Inlining separate call sites can exceed Starknet's contract bytecode limit.
#[inline(never)]
pub fn honk_scalar_mul(point: G1Point, scalar: u384, hint: HonkScalarMulHint) -> G1Point {
    if point.is_infinity() {
        return G1PointZero::zero();
    }
    _scalar_mul_glv_and_fake_glv(
        point,
        scalar,
        get_GRUMPKIN_modulus(),
        get_BN254_modulus(),
        GlvFakeGlvHint { Q: hint.Q.into(), u1: hint.u1, u2: hint.u2, v1: hint.v1, v2: hint.v2 },
        get_eigenvalue(0),
        get_third_root_of_unity(0),
        get_min_one_order(0),
        get_nG_glv_fake_glv(0),
        0,
    )
}


#[derive(Drop, Copy)]
pub struct HonkVk {
    pub vk_hash: u256, // keccak256(vk_bytes) % BN254_Fr
    pub log_circuit_size: usize,
    pub public_inputs_size: usize,
    pub qm: G1Point,
    pub qc: G1Point,
    pub ql: G1Point,
    pub qr: G1Point,
    pub qo: G1Point,
    pub q4: G1Point,
    pub qLookup: G1Point,
    pub qArith: G1Point,
    pub qDeltaRange: G1Point,
    pub qElliptic: G1Point,
    pub qMemory: G1Point,
    pub qNnf: G1Point,
    pub qPoseidon2External: G1Point,
    pub qPoseidon2Internal: G1Point,
    pub s1: G1Point,
    pub s2: G1Point,
    pub s3: G1Point,
    pub s4: G1Point,
    pub id1: G1Point,
    pub id2: G1Point,
    pub id3: G1Point,
    pub id4: G1Point,
    pub t1: G1Point,
    pub t2: G1Point,
    pub t3: G1Point,
    pub t4: G1Point,
    pub lagrange_first: G1Point,
    pub lagrange_last: G1Point,
}


pub const G2_POINT_KZG_1: G2Point = G2Point {
    x0: u384 {
        limb0: 0xf75edadd46debd5cd992f6ed,
        limb1: 0x426a00665e5c4479674322d4,
        limb2: 0x1800deef121f1e76,
        limb3: 0x0,
    },
    x1: u384 {
        limb0: 0x35a9e71297e485b7aef312c2,
        limb1: 0x7260bfb731fb5d25f1aa4933,
        limb2: 0x198e9393920d483a,
        limb3: 0x0,
    },
    y0: u384 {
        limb0: 0xc43d37b4ce6cc0166fa7daa,
        limb1: 0x4aab71808dcb408fe3d1e769,
        limb2: 0x12c85ea5db8c6deb,
        limb3: 0x0,
    },
    y1: u384 {
        limb0: 0x70b38ef355acdadcd122975b,
        limb1: 0xec9e99ad690c3395bc4b3133,
        limb2: 0x90689d0585ff075,
        limb3: 0x0,
    },
};


pub const G2_POINT_KZG_2: G2Point = G2Point {
    x0: u384 {
        limb0: 0x3b32078b7e231fec938883b0,
        limb1: 0xbc89b5b398b5974e9f594407,
        limb2: 0x118c4d5b837bcc2,
        limb3: 0x0,
    },
    x1: u384 {
        limb0: 0x358e038b4efe30fac09383c1,
        limb1: 0xe7ff4e580791dee8ea51d87a,
        limb2: 0x260e01b251f6f1c7,
        limb3: 0x0,
    },
    y0: u384 {
        limb0: 0x96e6cea2854a87d4dacc5e55,
        limb1: 0x56475b4214e5615e11e6dd3f,
        limb2: 0x22febda3c0c0632a,
        limb3: 0x0,
    },
    y1: u384 {
        limb0: 0x41f99ba4ee413c80da6a5fe4,
        limb1: 0xd25156c1bb9a72859cf2a046,
        limb2: 0x4fc6369f7110fe3,
        limb3: 0x0,
    },
};

#[cfg(test)]
pub mod test_fixtures;
#[cfg(test)]
pub use test_fixtures::{get_vk, get_zk_proof_keccak};

#[cfg(test)]
mod security_tests;
