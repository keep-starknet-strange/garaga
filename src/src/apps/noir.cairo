pub mod zk_honk_transcript;
use core::circuit::CircuitModulus;
use garaga::core::circuit::into_u256_unchecked;
use garaga::definitions::{
    G1Point, G2Point, get_eigenvalue, get_min_one_order, get_nG_glv_fake_glv,
    get_third_root_of_unity, u384,
};
use garaga::ec_ops::{G1PointTrait, GlvFakeGlvHint, _ec_safe_add, _scalar_mul_glv_and_fake_glv};
use zk_honk_transcript::{Fq, IHasher, KeccakHasher, POW2_136};

// Pairing points (P0, P1) carried in the public inputs, serialized as
// [P0.x_lo, P0.x_hi, P0.y_lo, P0.y_hi, P1.x_lo, P1.x_hi, P1.y_lo, P1.y_hi].
pub const PAIRING_POINT_OBJECT_LENGTH: usize = 8;
const POW2_120: u256 = 0x1000000000000000000000000000000;

#[derive(Drop, Copy, Serde)]
pub struct G1Point256 {
    pub x: u256,
    pub y: u256,
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


/// BN254 scalar multiplication with a GLV & fake GLV hint (see `_scalar_mul_glv_and_fake_glv`).
/// Not inlined, so that the Honk verifier MSM and the pairing points aggregation share a single
/// copy of the scalar multiplication code, keeping the contract bytecode small.
/// /!\ Assumes point is on curve (not infinity) and scalar is reduced mod n. /!\
#[inline(never)]
pub fn scalar_mul_glv_and_fake_glv_bn254(
    point: G1Point,
    scalar: u384,
    hint: GlvFakeGlvHint,
    mod_bn: CircuitModulus,
    mod_grumpkin: CircuitModulus,
) -> G1Point {
    _scalar_mul_glv_and_fake_glv(
        point,
        scalar,
        mod_grumpkin,
        mod_bn,
        hint,
        get_eigenvalue(0),
        get_third_root_of_unity(0),
        get_min_one_order(0),
        get_nG_glv_fake_glv(0),
        0,
    )
}

// Decodes a pairing point coordinate from its (lo, hi) limbs, with lo < 2^136, hi < 2^120
// and the coordinate < Fq, so that each point has a unique encoding.
fn pairing_point_coordinate(lo: u256, hi: u256) -> u256 {
    assert(lo < POW2_136 && hi < POW2_120, 'pairing point limb too large');
    let coordinate = lo + hi * POW2_136;
    assert(coordinate < Fq, 'pairing point coord >= Fq');
    coordinate
}

/// Accumulates the recursive pairing points carried in the public inputs into the KZG pairing
/// points (p_0, p_1) of a ZK Honk proof, where the final check is e(p_0, [1]_2).e(p_1, [x]_2) == 1.
///
/// If all the pairing point limbs are zero (default value, no recursive verification occurred
/// in the circuit), (p_0, p_1) are returned as is. Otherwise, the pairing points (P0, P1) are
/// decoded, required to be on the curve and not at infinity, and the function returns
/// (s * p_0 + P0, s * p_1 + P1) where s = keccak(P0, P1, p_0, p_1) mod Fr is the recursion
/// separator.
/// `aggregation_hint` holds the two GLV & fake GLV hints for s * p_0 and s * p_1, and must be
/// empty for default pairing points.
pub fn aggregate_pairing_points(
    pairing_point_object: Span<u256>,
    p_0: G1Point,
    p_1: G1Point,
    aggregation_hint: Span<felt252>,
    mod_bn: CircuitModulus,
    mod_grumpkin: CircuitModulus,
) -> (G1Point, G1Point) {
    assert(
        pairing_point_object.len() == PAIRING_POINT_OBJECT_LENGTH, 'wrong pairing point obj len',
    );
    let mut is_default = true;
    for limb in pairing_point_object {
        if *limb != 0 {
            is_default = false;
            break;
        }
    }
    if is_default {
        assert(aggregation_hint.len() == 0, 'unexpected aggregation hint');
        return (p_0, p_1);
    }

    let p0_x = pairing_point_coordinate(*pairing_point_object[0], *pairing_point_object[1]);
    let p0_y = pairing_point_coordinate(*pairing_point_object[2], *pairing_point_object[3]);
    let p1_x = pairing_point_coordinate(*pairing_point_object[4], *pairing_point_object[5]);
    let p1_y = pairing_point_coordinate(*pairing_point_object[6], *pairing_point_object[7]);
    let proof_p0 = G1Point { x: p0_x.into(), y: p0_y.into() };
    let proof_p1 = G1Point { x: p1_x.into(), y: p1_y.into() };
    // Rejects points at infinity on either side (GHSA-2hc8-mq24-76v2) and points not on the curve.
    proof_p0.assert_on_curve_excluding_infinity(0);
    proof_p1.assert_on_curve_excluding_infinity(0);

    // p_0 and p_1 are circuit outputs, reduced modulo Fq.
    let mut hasher = KeccakHasher::new();
    hasher.update(p0_x);
    hasher.update(p0_y);
    hasher.update(p1_x);
    hasher.update(p1_y);
    hasher.update(into_u256_unchecked(p_0.x));
    hasher.update(into_u256_unchecked(p_0.y));
    hasher.update(into_u256_unchecked(p_1.x));
    hasher.update(into_u256_unchecked(p_1.y));
    let separator: u384 = hasher.digest().into();

    let mut aggregation_hint = aggregation_hint;
    let hint_0: GlvFakeGlvHint = Serde::deserialize(ref aggregation_hint).unwrap();
    let hint_1: GlvFakeGlvHint = Serde::deserialize(ref aggregation_hint).unwrap();
    assert(aggregation_hint.len() == 0, 'wrong aggregation hint size');

    let p_0_sep = scalar_mul_glv_and_fake_glv_bn254(p_0, separator, hint_0, mod_bn, mod_grumpkin);
    let p_1_sep = scalar_mul_glv_and_fake_glv_bn254(p_1, separator, hint_1, mod_bn, mod_grumpkin);
    (_ec_safe_add(p_0_sep, proof_p0, mod_bn, 0), _ec_safe_add(p_1_sep, proof_p1, mod_bn, 0))
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

pub fn get_vk() -> HonkVk {
    HonkVk {
        vk_hash: 13030503510117565137644711897992967494644514363097683203590798326044017073673,
        log_circuit_size: 12,
        public_inputs_size: 9,
        s1: G1Point {
            x: u384 {
                limb0: 0x68d275041d7897cdb7ac0566,
                limb1: 0xe541b1713407a9ad6a44673d,
                limb2: 0x2b76e669cb63577d,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x7bb79b340b877934e4011b6,
                limb1: 0xe32104e3a9df02ab26e9a5ab,
                limb2: 0x17af3ea3e70a6a73,
                limb3: 0x0,
            },
        },
        s2: G1Point {
            x: u384 {
                limb0: 0x2639a6a255d27e09402a2d0b,
                limb1: 0xdb69eba5c7807dcb3495f1aa,
                limb2: 0x2ff071de8ea32964,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x456c57d284b57955aa74e2f7,
                limb1: 0xf0af19a7592736755b619cf8,
                limb2: 0x2a606c882c2eb84,
                limb3: 0x0,
            },
        },
        s3: G1Point {
            x: u384 {
                limb0: 0xbf8532926991ab67b6c7e011,
                limb1: 0xb1732e0033bc42dcbacdd265,
                limb2: 0x1097ef14f7286b02,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xf7985cc6319723faaede926c,
                limb1: 0x44cdb28f3e5c7b15f0610ef5,
                limb2: 0x270f45c886bc816d,
                limb3: 0x0,
            },
        },
        s4: G1Point {
            x: u384 {
                limb0: 0x6d44a6218401811f0bae826d,
                limb1: 0x9eb4f572a62c51998b00469a,
                limb2: 0x2e3de7ac6635983f,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x8ccda8bfcf4ac7ce7f18cc3f,
                limb1: 0x838cd18fac78aa92d42fde45,
                limb2: 0x1a2e275796993b43,
                limb3: 0x0,
            },
        },
        id1: G1Point {
            x: u384 {
                limb0: 0xad1d842420b9ba94b14ed0ba,
                limb1: 0xa23dbd10cde333a3b79a53ac,
                limb2: 0x1c6bece676ee1d83,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xa6dac107b821ba99ec1200fc,
                limb1: 0x40d65c03fe141cacb7a06e46,
                limb2: 0x299eaf7de90f7de8,
                limb3: 0x0,
            },
        },
        id2: G1Point {
            x: u384 {
                limb0: 0x23f09f33781dd7137740c7bd,
                limb1: 0x7b0a83dd927d6dfd3e08f872,
                limb2: 0xd27d843c5ab1c3f,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x6ffca7e9481e58572ba3dd96,
                limb1: 0x58df3092aa175ecfb72288fa,
                limb2: 0x17f7fca8dcfea36a,
                limb3: 0x0,
            },
        },
        id3: G1Point {
            x: u384 {
                limb0: 0xd36a993acf8aa1d320de37ab,
                limb1: 0xea1ac32214fe69d44db36191,
                limb2: 0x2aaf0ea05d276bda,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x30d3b1c3221ca465b59c1d56,
                limb1: 0xb8032cd3fccb1d2dc4ffea16,
                limb2: 0x321a5556753e249,
                limb3: 0x0,
            },
        },
        id4: G1Point {
            x: u384 {
                limb0: 0x73d8c92d1e8e8a842ca02142,
                limb1: 0x53f5e939ba3481bacd1c1d25,
                limb2: 0x1650c4615868d95d,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x2b9b7a176b96767da7467197,
                limb1: 0x6ee13023f9d74ac029e6d1a7,
                limb2: 0x1892b9f8df903fb4,
                limb3: 0x0,
            },
        },
        lagrange_first: G1Point {
            x: u384 {
                limb0: 0x887f299049b14c11e98460d6,
                limb1: 0xb9c26747621b821eee81b23a,
                limb2: 0x2a56ce41f6b0be13,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xc78656c0d12ca1aea6ef2c7c,
                limb1: 0x7d8f6de4e725ded5827d6338,
                limb2: 0x1aa98f2de3ddda54,
                limb3: 0x0,
            },
        },
        lagrange_last: G1Point {
            x: u384 {
                limb0: 0xa37edd842f2dbd07c6ade78e,
                limb1: 0x50051587e272edde3af542d1,
                limb2: 0x2a06b3387a444dcc,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x453d3d44bf54337b779f318c,
                limb1: 0x3c575589fee6f52d92a8102a,
                limb2: 0x22616c241d3fbf6c,
                limb3: 0x0,
            },
        },
        qLookup: G1Point {
            x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        },
        t1: G1Point {
            x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        },
        t2: G1Point {
            x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        },
        t3: G1Point {
            x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        },
        t4: G1Point {
            x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        },
        qm: G1Point {
            x: u384 {
                limb0: 0x2f6f77c10094f69a4779eee1,
                limb1: 0x195999b67322b28166950c3b,
                limb2: 0x253c21f9f3795b10,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x2706773fd96a2af8e4830f1e,
                limb1: 0x3db0371b0975619ade0665a8,
                limb2: 0x1466aeb3b499706d,
                limb3: 0x0,
            },
        },
        qr: G1Point {
            x: u384 {
                limb0: 0x4c6b24411c28feea328ff018,
                limb1: 0xdc6ae6c1a0dff4d032dcffac,
                limb2: 0x28883969fa595565,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xef207bca7c45fabf4108edc2,
                limb1: 0xbfc97ce972c629f0170090a3,
                limb2: 0x1338e5ebbc48db45,
                limb3: 0x0,
            },
        },
        qo: G1Point {
            x: u384 {
                limb0: 0x66e1b3cdd59f1fd264e0446a,
                limb1: 0xd80745e338a33bb4bd153fab,
                limb2: 0xcdbd6b43659bb55,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xf5c3dfbf55e09a99de72e59d,
                limb1: 0x7932c8ebebfa6032b6a95975,
                limb2: 0x1c5e60e769562807,
                limb3: 0x0,
            },
        },
        qc: G1Point {
            x: u384 {
                limb0: 0x856a997dcbb509a789786be,
                limb1: 0x325875ea7b7296dc0bad964c,
                limb2: 0x40c0f724ffae5d4,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x28ee4d228e4323cae5474d33,
                limb1: 0x6607b61bc607f76bc256fe0c,
                limb2: 0x305c566d2733d940,
                limb3: 0x0,
            },
        },
        ql: G1Point {
            x: u384 {
                limb0: 0xc3e2844f3f806dc378ba3aa,
                limb1: 0x7e23a15921d6ea690974d563,
                limb2: 0x1616cb30818fee11,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x5f9c99f54224d14fd43a3b33,
                limb1: 0x85c1f0089db59d8c5b0d25ee,
                limb2: 0x24e3bf6b5046a398,
                limb3: 0x0,
            },
        },
        q4: G1Point {
            x: u384 {
                limb0: 0xa233c42ed062aaf93a3cf686,
                limb1: 0x4b7bca51630a296ac05848d2,
                limb2: 0x2aad9088dc5d4e33,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x1693ac5ff94c90092553b10a,
                limb1: 0xcefa1351c0a2b49c05cc423,
                limb2: 0xb031957adfd0101,
                limb3: 0x0,
            },
        },
        qArith: G1Point {
            x: u384 {
                limb0: 0x267f32999e525a4faa2398aa,
                limb1: 0x1b235c6aab79df4120ac8a6,
                limb2: 0x21a025ff4ae84ba5,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x4908e3c61a2875b1bc6fed10,
                limb1: 0xa96db74b203029efa52aa86f,
                limb2: 0x1a8b5f11e6f51f2e,
                limb3: 0x0,
            },
        },
        qDeltaRange: G1Point {
            x: u384 {
                limb0: 0xd03abbe077caf4c5983240c8,
                limb1: 0x46aa097657c986e1ed5dd2f4,
                limb2: 0x31f24378f02832f,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xed51579234244c4da593d7ba,
                limb1: 0x357fb8db70f1b03ec80ce8d1,
                limb2: 0x212d3b79b08de95a,
                limb3: 0x0,
            },
        },
        qElliptic: G1Point {
            x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        },
        qMemory: G1Point {
            x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        },
        qNnf: G1Point {
            x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        },
        qPoseidon2External: G1Point {
            x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        },
        qPoseidon2Internal: G1Point {
            x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        },
    }
}

pub fn get_zk_proof_keccak() -> ZKHonkProof {
    ZKHonkProof {
        public_inputs: array![0x2].span(),
        pairing_point_object: array![0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0].span(),
        w1: G1Point256 {
            x: 0x1c59700c6ec0560724a5008370d81d17c8025e4e85063744fe2876fd473b7bbf,
            y: 0x3e913859168211d36aa710ded78836a3968ede1838e1afba0eb4175b3882534,
        },
        w2: G1Point256 {
            x: 0x13d644f7d365c0cea6a4a72bf58987021aa60b289fa470da2af3eaa20adf82c9,
            y: 0xcc5f7b7fd42c428607ce1d6a70c293bab2d90b6fe47aa5a72d9b122360330cc,
        },
        w3: G1Point256 {
            x: 0x2ebdb09faf343d90b20b96c12694a602b6930131854cb5aa9f46ae20e2527d09,
            y: 0xeed07482536470865b1a17018f21eeb5223ce8b3906d5206c46dc5a681a5ca2,
        },
        w4: G1Point256 {
            x: 0x9442c9e1eaaa55eebbc0a38bd5b8ced0a4193b1150bda0a0b1d8400ddc00fe,
            y: 0x203eb2148795242a30dd6cff4d511758733812fefc9e5d2ddc593bde776b0427,
        },
        z_perm: G1Point256 {
            x: 0x2e0b58da9559276d0607ade5b19595c937e610b93bb439319ccd9ac15114f695,
            y: 0x6950fe382f0310523607bac0ad8ef7c3a0fcb682eabd759fdb07f6a8daec451,
        },
        lookup_read_counts: G1Point256 {
            x: 0x140755b700f38a7f6461a969ce715560698eae3db3bf0154586242d5768f2cb9,
            y: 0x9528c9058c72d5a7fb0a30f0e9776386df37879fd193474fc73fbe172911973,
        },
        lookup_read_tags: G1Point256 {
            x: 0x8ff668c4f7f4524d3ab1d610bbb6266240779e4f12066b45cf7e56e65408f2a,
            y: 0x14e993c5f73ed1768c26493b82682ffb48c6b0cd567ad349fa7e501879b52930,
        },
        lookup_inverses: G1Point256 {
            x: 0xc7dc46ea0c795f99f9ca039a22a642c73ec40c6ca2ba31286a65e34a716237a,
            y: 0x1030ef4cee56dcf2877f360715d6208f6a430149884ac7a5ae05a06a226f7107,
        },
        libra_commitments: array![
            G1Point256 {
                x: 0x2aa0e12a56b783f67389a50f0efc488ab4d13785db72f98cd1d4eb7abb28111a,
                y: 0x2a6da18e860effedeb0c8e9d03f0fe86aa4143ef28048a60f4e925eeb06466b9,
            },
            G1Point256 {
                x: 0x1de6f45c8be9f226fe7bf8bb436b62b66bbccff2e1fc8e0e58d141e41b9ddd04,
                y: 0x6fae32feb6d69b0fdc042f219a289efd13fe2c6a7e85259370b9e44dcb187ad,
            },
            G1Point256 {
                x: 0x2e4d79c0bc61aac52aa40fd44ff684159b51378b71c39ce363b860150e114ef5,
                y: 0x2c34cdf6cdea673c2119172a5daf57fee26fedf855caf41364a8635860b72f88,
            },
        ]
            .span(),
        libra_sum: 0x157d96e133dcc6b2e06994fca16d4e2c17d56e519c9813865d799e6d91e4cea3,
        sumcheck_univariates: array![
            0x26bf22e6bfd0d4c15ef5c5becc57cfd1a7cf0fec6f6de2caf798d6f8642a4500,
            0x1b400b5da47586b9f91c0137b87ded786f8005068c98599c6f290d10926394d3,
            0x25bb3aabd31d3c4c6d63b08e5f936f6732e4e06e287d16e840281a4460c377dc,
            0x1cf407e541239986b29e90937cc12a3ba6ddcf6844bea9fac0db2de7372e55d6,
            0x1b0d4fa78b999bafa3bebc6f2f3cbd1ecfd8a8b990cb564039b8f10d73e3be5f,
            0xf1b14f4e431c2f9726724368a30e60ae4944e293bacee9df7c2dd1e9eee301,
            0x2e6b0962c7a62a2f07f22d8bddbf94afd679e773f1b7757ddb718a42594d7ec2,
            0x100e64e33a6c151000d4ae2e800bf01aa1bde2eac71703b3aba144a8823f6949,
            0x1e7dd2a52dce47b51f55bcaf4561632cb7de526760ca51b21ca336d6144ee97a,
            0x26cd1f18b9acdd64476342a2023e402666f72c50b44c3cbb5c8d62e41bfa402c,
            0x10a6ab7f653e3d7cee6544920f6d90e350e5a9199b8cf495f98f6ac331e39a6f,
            0x2fd38bf35fac07cb293303ef7c955147d74d2e91943244b88483c3d3538c4b2e,
            0x302d11b28efd97a6748193a34c4ad4800d580472ed46dc514033f3a4ff9735e0,
            0x302b64bca8d76fd8f95b31b83b2c86366ccf89b8eb8566341f64a0822938e780,
            0x2f184954b50c05fd8f54e8cc0a68f43f8ee51d457d11c65e14620c89c2c7ebb8,
            0xd211d68e133ffbf2122e4c06ae2f0be76737270da157e3546a3ade8f69a1c30,
            0xe675474970299e1b8ad7c231931034e4bb5ae33dcdbb9045d42311aaf091504,
            0x2fa20919db87175333a084b16b26d9f62945d1d19a66e8344be2d176edbc6ac2,
            0x279ea8c5053aa434833a77b709d05907652299b7e079b095fd32074448a82cd,
            0x1370bb9816de520d2480a9a84f6e0f1a72fea2a6b5ae7eb3cd95205145deb194,
            0x1fa7fb7caa5cad308ccc9408df5ea2448d1c55f4e8f520766b085d74acc4ecc1,
            0x10d9a4fe183297e12abdfe6f73b3344e2908eb0362a8fdafc14b6d2a3fa6c6ce,
            0x15ec7cdf746bd60f027a1bcf575ade78ec894a3509e6133f9f1ca32edd31d4ee,
            0x20a6d0c6a0842c0f4b399708a73e634f3014ca26369d077fa35785e5ee08ebc1,
            0x165298bafe81fcf350398609119b649ca4a0bc3742cb754b5eb2d3dff0a1493c,
            0x15afe5070be652d7f377199668a16ea69f1c5938e8ab402fa3af7aa1ca32a001,
            0xe8d700816b7060a7824eb2005c15f13654c0c52d71e1f0190fd29fc5ccf7a84,
            0x20445ee1c6c688f785f16d72e93313e669f6448e5059a96224e95d898e65ab85,
            0x20b5e685e88822dbfd124b14507eb15e48a468c64aa0d79d65b57d22483def55,
            0x444615baac01a420dac35189e9f291ce5f9420f05a366a2c4e299c9655c6db8,
            0x194fb019b2e17f4d05293e6e2942568f196855675de2bdecfd70cc4da8bec47a,
            0x23e32ef6643572717bcdc2f8107dbe6607e8c3e471a76afec1b10357c904978b,
            0x160237058b2b6aa03aa4d859ba2acbf8526ef38c66c6138a737d4a28a8b39fcb,
            0x16470fe8c41f9998de002b5659d0a5b9ec90cf32b7aac87067ffb53fc5a805b9,
            0x17fa5dfae584ce83571022d3f6cb44f3b35c499fbfa3b75563ce72eaaebd8894,
            0x27db9a45b18a6a9f9d99ebf8fed956c06811b83a7cfc7ba155d0ad887ad69db6,
            0x29e3ab5a408460f709e47bd570ec69863f0ac93024ec72b85fbf736659a3b220,
            0x16918d55704fbed6270b4a14bf2026769ffd9dfeccdfd2d868b284c5b27e6e2c,
            0x2f1a9a193f03c295a31eb22ee58bb818d79a33ee5583a2dffebc630806b14aa7,
            0x264d74067c29f4bc6c9cc7c61dc450222593d2d5b3e6842ec3825c4a6be6be81,
            0x43d81ef11cc04551577245ec68b21286704c0ed5739afd56b34329a6c772079,
            0x5ca4f7e55cd5cbd9b2a13109da108a23d0b65d120615e696dc5c651a11b9036,
            0x105cec41cbe007e3f64fdec961603284c8f66872e0689c30078ce9188e556560,
            0xf3014658af5f290a4aae91801758e82b28c99be85f8995a02c5e9e35f5b7fa1,
            0x3e3041a735732a565ccc4084050243c3e78352ff1805ddfda73daeaa96e7f37,
            0xa443933507f20f4c70f799eacf644ba1183dde24630bd152289c3d69e8d3579,
            0x15cccc72375ed01ac723844cab0249b4d225de33b7ccb376a8d8b4027e378e7f,
            0x253a3457d487601f671f62a2a6f4fd7a1cc6d04aedf43ed3f2824c26c6c13ddb,
            0x2d3fd9d6f0447e9fa6ff320d9030607c190a3baa61c3c75c00664dd094fb2a69,
            0xa95180fdef3c21848fab06c189af6cc093df5218abe81b35210da784dff331,
            0x11d0e0dfeed202e14132cc991e924e051e9ca3c3cb305a4ae6001719a90e8fce,
            0x1126e35304c15fdb2b37aa07c81d10bcad7a098594c032501140cd49d1388027,
            0x2c2501bf0a0c8e185b7a240876f28b4d5b4e79f90ac7be25c03b1d358e88041e,
            0x257f2fa6d275a26e21bdcc5ce618a4b8e33d2a161ed0ed23058f3140c7d7b0ee,
            0x2ea909c9080a219a06c495420d274ae1411313e2b2ce118ea9a6d11aab8ecc09,
            0x10d53fbe67af37e3130f813f4ef891dfc5658d59e2257583c50a1cba27377be4,
            0x2ecdd2f76e2e46609d4fc09a42f9e931871df353e872116e66607cc26458e7dd,
            0x1d0d0d594ac7f243570df3b3b589f596597516c10e9e962b5a543e865d84407a,
            0x1dac2a32af417e7b1ef2b369670820420e7a507527911dd9c3460774be2b1bb,
            0x21552b36419bb2449f9f6f90122c887923559645db5bfc52cfb5de479ba6e14,
            0x73745b1f422bf2bd82560454ddb01ebe7854c0967a4ca5fe0a9bd62eaf18ecf,
            0x2c6251259c814a4c83eb753eb2155117c87521fc0a6a798d579e0733acbd120b,
            0x11d98a6eefc601f3657e994cc00779bf2b8b728370701c2bb7a24af0347ad35f,
            0x21a55801335e16466dfdabd466a206cb2926896a9b375a2af494d9f75d80418a,
            0x20538a33f1b9d9d13a5b68fbfc67937866ba3c61011601f6c1eb6f89c779be86,
            0xbdc3430f0f07ff6a3c1b40dde497295ee43ad4e3a1a3bc6eb8461a4f14fa312,
            0x259458c073383eade8ba1b9b7985200c5098bd52f6d844873ea509b5c53e781c,
            0x130f8b023150fb3281ac6775d034cbc1f876f520ce8711ef94d3ffb23f9ec14c,
            0x15a85df88ce4639edbb03f673cf5c0bec412c43545e052a306ab9309beb94806,
            0x18561c76f353393c1632359643e479d951564f5e81c2ebc6e41301fedf2ba7f0,
            0x1e2fae2b825b3cf24a441531de91984b315939ea96b1347b19dd4fb48c8aa6f2,
            0x9d2bbc39b4c7d7b77cd98d9df2785bd22a27e92d4aa7d8710de77012ab27094,
            0x1ec761ffc5746a36ba8ffe66635a58a02cad30276bea11c193d4116678cc87f8,
            0x1c13627b54792bbe6181b8583a95c3d03f3bb3b9a813eeb5ea45dc29e3c1475e,
            0xbf438c94c680f7ac4ff4d395fb0d649ace5a4c8c79f47e82b06335ab991175a,
            0x19877144f75887e51b42e76fabcf326d41aa0ce2549551d69e7f64a171be8ce7,
            0x17acc6c52fed98d5c8436bf42ca8454a5d3b24b258104d908f72a4e5d5ca5d38,
            0x1e3bf45825940810b3a5cb26d43777db1bc9e9f5f7293103310252c4692e2a8b,
            0x11b979a1cb819a7155dabafa499c2592eaa77c2a1eae09561ea0a263c387ef2,
            0x1c7bb6c08b930a2b530b09963c685e6387c8f091c7939d1338eed8d4186f7cb5,
            0x62f26d84525b38c541ff618c771134eb8d17b54ddf29cfa18b98c8b68e2892f,
            0x2cfcb358a626320bc8601716c649bbda0465fbc85fd64472647f210ede563dde,
            0x5a7f460659d3e4ae25d2c7c95869e55c11566ec3dc31ef09373fc34104a6d7d,
            0x1da8a8ac6fc2b271d0311aaa8176148e571dcb7f44bd26f839703d40c2ef64c4,
            0x1520262d1ad543844ad36fd09dd816e222a98e26341e9121931b4c46c72cabee,
            0x1dc85accc6f3d1fbe157acc9dce6078f765eab422bafbe73e0bf4b1a1b56ad10,
            0x1dd20ce6686b981c19cd04db88acd946027a21f43da2cbfb2e67835722bd09b2,
            0x230317685ddd1923701748d0de7974ec733d31fc59ad48a815d2ef5af9824126,
            0x1ca9c96be0653c83541152583c5b057fb6dcb79b773d0deb170b251b602ab562,
            0x1a8f8eff13f12f5702fda0f1b7f00a665e1e7bd5a9f4cff28ebc2d228c59e1d5,
            0x2cebc90ff5a53b00da26401d37b8e5a12d464095c248dc2a52c0cd406d9527d,
            0x17bac0760db9cbac64e4e1c65398d686c9169938aebbd09dfb30a7d1b12a6860,
            0x15c44bb15ce6b91118afd2db5b42e4fec11d071b8618a91f18036d87c241b84e,
            0xa168e994aacf51f9fd5709a2047788ea75a5fb95877e74bb453b837728ef016,
            0x1eca57593f211c05b2276e8761987ab38454e6a31d8da8b3cb99dd1358848a07,
            0xbf0fe33ada0f7d513481ac47d89b551f427cd4142cec2021cb150459bdb43b6,
            0x2100041e48e89953dff96409582aa5728d0c52997bef2c82dd4e47313c7c63ff,
            0x37c960650215f3f813bde235bcfeff7021258b75fdca6d228cde81db59a6dd0,
            0x1d2d19a09284a61643cc05b643bd3aac05c2781288ef40b4be1680ab7cf60011,
            0x2d5c687d4dcadab38fc7f4f4c2180b70c57bdb0bc5796dc5e820308ef20649b5,
            0x11fb5538a34421d50890280928d45db97ba28ed43a89b5cbd7628a3904d99f14,
            0x158ae961b3ef39291eccdf1fbc5a0f56afc66bbc2508d6ec017d60c09bc9583,
            0x2842fe6c2e1890a8dd11918b5554a4f11f36dd23fc4ad5c146e8425f15ee0e0f,
            0xf94766b83acc066bcc700489a98f0166e12142334c113262ae5eb53a6ab15c0,
            0xbd16ac5fffb8e35ba6c418b4b96fcd7a0b48e16a209d4cc0a75abc03eb37cc2,
            0x1782b8c8ab1554eb5baa3ab17066cf25a1b2f0f78c804dd3d7970991e589c0a1,
            0x1b42804950a61cd376dddfad1143745d74ac4f258023ee7a26fbe3a2e55e156a,
            0x1d858b7d0e93e9bb346a5777805d5e520ae406010b5e65bfb8e080a75ba8c64e,
        ]
            .span(),
        sumcheck_evaluations: array![
            0x206b4651ad29398df7efb1fecc6dc43cf3d5a00fc021f5c30dcfab5bc5495faf,
            0x28e38d4f77bcea00b22197a55c4111d894fd8ae962035223ea11ab71d0c8cd12,
            0x436359427911e2e4196d46e7b4a5aee4b8a4b297fe3f23e087c410be047c61b,
            0x219a361fc9bc776d7722b9b9d339c1cc8ccaf48981adef89e86d7c4853e33afc,
            0x17bb4a6c616ccd04e4064a4d2f87dfa83a64616bbcc7ea9054a7d4447065b3d3,
            0xe8ab2971b9d3907fd8e1fdb483807bea1ce8a2958665136e95cf361276ef25d,
            0x2a5e1f8245b258a3563cff3e14a7d568dc91a02cf95f4f5d04373bfc9899d5f8,
            0x2f893891125fc7e56d4179fabf4e00182a143f8515eec1aa840b49f5407fbbc3,
            0xc8f7627a8c920e3586bd09980cd49a005798bfda07d8ce3c892f7d6feff9860,
            0x2952a4034a792997cc3283ff997fb0e1b5d5afed465bad11d128562fcf5c05a1, 0x0, 0x0, 0x0, 0x0,
            0x0, 0x135c848ff45a7132a7264f397116172b71dd3db49a616fb9610e6e2df8fdf877,
            0x27b60ecef33be96dc4d83c2fef0f6c7e30e296d103f7a176591549731cdec08b,
            0x300bf3d4c83c6242b77ef75ace7b10055fc1c2e579e209946bf81a2ff0228b7c,
            0x12bd16682c9bbc85ac925c87a006a1143f0c196a312d5d0740f4cf30aa9bb314,
            0xd692bb8ead9bf0f83eb52731a38b2c19be7384f23ed2320164d15fbf28e4564,
            0xcc230a39751a261a8488f49d0779bbdedebab876d647aae65a157d5438328ea,
            0x23019edf11589bfd93be03b164981fa2e43191a621607f54b30a498077a7916,
            0x9c25d46f4a40b349f2c7c7ac271fff90166bcb5473ae909ca474c3fbcde2d3f, 0x0, 0x0, 0x0, 0x0,
            0x0, 0xcf593d7decff338fe5e9cee4909434b341cb3d6ffa683f38c48acb560a88de5,
            0x25eafffaa9baf1a81b92b88221f4db506d1a7171164a833ea4b27db31aa00963,
            0x2d8edb9fe6c9e040f60140efe5f308af1b823b94dd898463bd13623298eeec66,
            0x2d77e38f3339c162866717cfea81304ae8a6ed8a483e81290024990eae7d999e,
            0x119849cf15f6103abd82a8077233e8e12edb15741f6b4008d62df1b6f52abd2e,
            0x23c5beb0e8c1228f32da942d948f550bd42c0582d4293af4e920cd39e8739b80,
            0x46a01e03e947ace725f5a46b8fa5a58bb4cf0b154c2178ea2154e7aaee7e523,
            0x2917402ced95092f797baa968a08ccd8f32aeb1a97aa52549e29e65204b3bd9a,
            0x113f8f42c85ff9df265c79f7a8d14e702a73a862a79222b27156fef001188ae5,
            0x2ce072dba50f7418db256db6b8a8e2e625515e553d30959396221a157ccce2e,
            0x11f22054795053be2abcc78bda8c4771c5d0329cbf14dd698e37aaca81710813,
            0x242b9f3780c4099e5e29fbe81a50e14d502f86bfcc41cdfcbcc03a5a3fc50b75,
            0x1f96253ce11f1cca287c399be6ca363284d7ce8dfd49f5dccbbefbe59be69247,
        ]
            .span(),
        libra_evaluation: 0x1ac7f083cb6a373d6f4962756967e15d4869bb51af8b17cdfd87348405b46e42,
        gemini_masking_poly: G1Point256 {
            x: 0x8146cbf3bd870dd498515961f344243c2c768502209d2f3307be8f1924fe69f,
            y: 0x91a8452ca47f5da81a6e695f8cc52f0911753dc70612f14eabcd4e9b5af8daa,
        },
        gemini_masking_eval: 0x123c1f5db793938bfb8f8fb6248463ff95389bbe7d5347e72c5ed862908ca7fc,
        gemini_fold_comms: array![
            G1Point256 {
                x: 0x2bd7715cf5a6b2fc73fbb86f0da820a31802823e5f33216ea7790b7a939ccd98,
                y: 0x2be30ba3a7402b921e51cd4594a1b16067f082a7c03ac1e27e4409d403e0be60,
            },
            G1Point256 {
                x: 0x4818e590d482aa006779ce4ca3c2338d24fc6eea5a47515b4522cf0137af15d,
                y: 0xf4e800565ed8fb16684ad2c976bd166bb684f7bc7a6e6f44d08a4ca1cf31da7,
            },
            G1Point256 {
                x: 0x221ee2abc7ca86f47c7cd9b3d41d23e86faa9043158904ca9bb130cf6ab3bc17,
                y: 0xa18abe9b89d37fe7836e36a45a3589a00654f4e78b66fe43d8dfd00ab94554a,
            },
            G1Point256 {
                x: 0xa5b54d7a6256b213574d75b7a0d7273c497ab0ec5d6c959226086fb05cdfed4,
                y: 0x1a865f28f40bbb5a925b71f4d545f789a5c0961dbec09d1760abdeaa8ab2136f,
            },
            G1Point256 {
                x: 0xb1d3ad60c3f00510f35ca08833e912a0d2668258830cb4336dd08d8273f00db,
                y: 0x2a1b087b7dd511dbf6012c633a8c1bc46b4a84206ceee42a8d5bcb9346807264,
            },
            G1Point256 {
                x: 0x27ac308051e49803b74151ea83e59cb72e0ed0ae583f4ccf720ef7f3600e981c,
                y: 0x297a87c4f16416b16c7ea59aee9fd8b85c62a1489276556f278a424421f90343,
            },
            G1Point256 {
                x: 0x18371b1fb31a51e03d4a3eaf9999f786312d90762d1b0ed3537ebf1abc7ddbc4,
                y: 0x15adeaf1ab46d7bab1af89422271499f35b4a6e43f0c330c2d481a2bd2b6568b,
            },
            G1Point256 {
                x: 0x28fb544b498200c346b648ad20609d609ac9d0a92d60e717cde5999dd1f0c498,
                y: 0x1b66a1d05bf22840ba4a22ac8c6a2421bd5f54cac9789f4d8737a7ebad467ebc,
            },
            G1Point256 {
                x: 0x2fe5bc6eb60278de9298ef20f78e68fb69438c434d5efdbbf34625b05f902c50,
                y: 0x1cbca92f7dd3a85cd87b8c9b9fd7e4125e704c4c48d6fb7a5981eb779ae1dad2,
            },
            G1Point256 {
                x: 0xdf462f142f33cda08821ebf430a3511b01a2e0690d50c073d20b7d8e424f2a8,
                y: 0x97a8220e2cf0024800343af64158179a3dccb391929d8299f0eed810e29ef32,
            },
            G1Point256 {
                x: 0x247ff130baa9d182ae1765bb44cbaaca3f0ceedbe65780e5fb4d7b793e01a852,
                y: 0x1bb6e25d15cf1843b65c05133474ae46b956facaf003ad312802e8f4633d034c,
            },
        ]
            .span(),
        gemini_a_evaluations: array![
            0x2995d45c93267e05ec4f81332ec64eef6424db3950697dd4d9b6dd37d9aff113,
            0x14471ae80a8a65a713bd735a777f00512447941c1152d7b2678c752b8d11d590,
            0x20e2db621821de880234c89f55ac6dd044b2c3bed1d90343352f794eea2564ef,
            0xced74a7e3014e8a1c10306399db0dbc38168d68e8bdd37ad1b9f2ce359888c8,
            0x24551158e407efc2c49e18669a5626000b7a7a0b99e9095340b0258e9b69b0c7,
            0x1b85610f266aa97f64f05b25cd20c5aae2f5166fdbeb8e2687ebec7dbe928d9b,
            0x10987880752c81a6305ebc43085b764b64fd9221e5d2d47805fea6f3ff652dc3,
            0x1f5433ce4971b2d2506bab6eeb54118c36fa93f7808e09cab6758fd2c599ad2b,
            0x501e1dbed8a90941b76e2bdfedf95a9226a52c5b391939590383a6e0f5f038e,
            0x3f0cb39b04c94801a0d44aa19f1cc9e4ca140cbee613c6c3ddfddb69d2de9f6,
            0xf6504be417f93177fbbc329ff8f0fc837dbaa9c33fd1a1d4e22163741813b95,
            0xf17babb342035a8dba8049ad31fd5ed483b6422282d80f8ee3ee010561bd075,
        ]
            .span(),
        libra_poly_evals: array![
            0x2da63e22515953651be0994e029bebedd9eeb0b0d1020200216f807ead705983,
            0x23c70c55707fc4ac98289b913bbe7b1981296dcc76905f92226e8d57e9d4be56,
            0x815ff6e3d56d47cf892776f56461bf9e8bafcd9f8c9136d35974b658524d143,
            0x1d8e53b252406fb272a50f84702aba2ae24e12a3dbb34fe1d77565c9499701ff,
        ]
            .span(),
        shplonk_q: G1Point256 {
            x: 0x8f022c4e383c41999ad6a9ec4c3f8ab4fd52e4f48b9e5eb0f8d9202729db0a6,
            y: 0x16fbdc45a9c9b0b35c51e4082a77bf499ccb314223b5efb45309edf0c2516918,
        },
        kzg_quotient: G1Point256 {
            x: 0x7b654df1c5d1580ea1108dcade248ca48b7d686b5a9a3bb9e64216e339eb341,
            y: 0x1e464011c2d682086219d9abdaf217628a5479eb2bf10601c4d110ae09d9d16c,
        },
    }
}
#[cfg(test)]
mod tests {
    use garaga::definitions::{G1Point, get_BN254_modulus, get_GRUMPKIN_modulus, u384};
    use super::aggregate_pairing_points;

    // Values from a recursive UltraKeccakZKHonk proof (outer circuit verifying an inner ZK
    // Honk proof with bb_proof_verification::verify_honk_proof), generated with bb 6.0.0.
    fn pairing_point_object() -> Span<u256> {
        array![
            0x6190a57e749c0124fdea4124ed5d9f517f, 0x12ab67b548045ff18539ff95ca6acd,
            0xb7f1ca98c695202b27831eca64e5fcca41, 0x2229df99f78d61eff4ca7ecd0ef302,
            0x2f8c9223b4ac4c8560a54acfd5029ba04, 0xe6a55b2b2648d56733a0009505fe7,
            0xec5e7423a9bf17d5fec090c25e15f3548c, 0x13b05156a1a611b5791717acef15c9
        ]
            .span()
    }

    fn kzg_pairing_points() -> (G1Point, G1Point) {
        (
            G1Point {
                x: u384 {
                    limb0: 0x1407539e96bd550956bef1b1,
                    limb1: 0x99cc34ec6bde0be0e712dd56,
                    limb2: 0x279b4147666f243d,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xc8aeca631474b525d562c210,
                    limb1: 0x211d7526783514b0e3b74c2a,
                    limb2: 0x9b52b616e9600b0,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xb9c8ecd68134c6f0da53199f,
                    limb1: 0x93b375775d0050d4b671631,
                    limb2: 0x1506c1fcd169b545,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x81905fa2b214b68d62c31d74,
                    limb1: 0x1c91f0bd9e39d74738675515,
                    limb2: 0x1a9a46a1c31edbe7,
                    limb3: 0x0,
                },
            },
        )
    }

    fn aggregation_hint() -> Span<felt252> {
        array![
            0x9386180a8b2ccfbb3eaacd1b, 0x60c9687a3ea723768ef612f8, 0x1296ba4bef483d92, 0x0,
            0x6df046fb2472eb955a5c215a, 0x267b5a7c4d264c1114e52e4e, 0x28aab675310332f, 0x0,
            0x1000000000000000043701fc8ce80c68b, 0x100000000000000002a30f44603eead3e,
            0x2a9ccede395accf1, 0x2ddf0b2c98f7ec9d, 0xbfa7e06cc20b279906e94316,
            0xe78155cefda983f61f373a9a, 0x1f1be014dc7237d2, 0x0, 0xd32b1a6977dc4b133f5126b6,
            0xe6720f6a2b30c4d9aec10a24, 0x801822c00d78451, 0x0, 0x1000000000000000043701fc8ce80c68b,
            0x100000000000000002a30f44603eead3e, 0x2a9ccede395accf1, 0x2ddf0b2c98f7ec9d
        ]
            .span()
    }

    #[test]
    fn test_aggregate_pairing_points() {
        let (p_0, p_1) = kzg_pairing_points();
        let (agg_0, agg_1) = aggregate_pairing_points(
            pairing_point_object(),
            p_0,
            p_1,
            aggregation_hint(),
            get_BN254_modulus(),
            get_GRUMPKIN_modulus(),
        );
        let expected_0: G1Point = G1Point {
            x: u384 {
                limb0: 0x625793ebc1b6a7f49b94b000,
                limb1: 0x6d3eef44c2a1212d66d4850c,
                limb2: 0x81861ae89474171,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x6ab278c7a5c288dab4e2540,
                limb1: 0xf52e44abf205f9fc9f8fdcb0,
                limb2: 0x2fa2f1c24eb586b0,
                limb3: 0x0,
            },
        };
        let expected_1: G1Point = G1Point {
            x: u384 {
                limb0: 0x96f0d08cbc01711086e9da18,
                limb1: 0xbf04086bf812cd9ab0aff232,
                limb2: 0x16566688b29a7dfb,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xdc96a105bf6dc1f5d9dff6ca,
                limb1: 0xac9d21c2dbaa026ba7f6672f,
                limb2: 0x10d68667f65de43f,
                limb3: 0x0,
            },
        };
        assert(agg_0 == expected_0, 'wrong aggregated p_0');
        assert(agg_1 == expected_1, 'wrong aggregated p_1');
    }

    #[test]
    fn test_aggregate_default_pairing_points() {
        let (p_0, p_1) = kzg_pairing_points();
        let (agg_0, agg_1) = aggregate_pairing_points(
            array![0, 0, 0, 0, 0, 0, 0, 0].span(),
            p_0,
            p_1,
            array![].span(),
            get_BN254_modulus(),
            get_GRUMPKIN_modulus(),
        );
        assert(agg_0 == p_0 && agg_1 == p_1, 'default points must be a no-op');
    }

    #[test]
    #[should_panic(expected: 'point not on curve')]
    fn test_aggregate_mixed_infinity_rejected() {
        let (p_0, p_1) = kzg_pairing_points();
        let ppo = pairing_point_object();
        // P1 at infinity, P0 unchanged.
        let ppo = array![*ppo[0], *ppo[1], *ppo[2], *ppo[3], 0, 0, 0, 0].span();
        aggregate_pairing_points(
            ppo, p_0, p_1, aggregation_hint(), get_BN254_modulus(), get_GRUMPKIN_modulus(),
        );
    }

    #[test]
    #[should_panic(expected: 'pairing point limb too large')]
    fn test_aggregate_non_canonical_limb_rejected() {
        let (p_0, p_1) = kzg_pairing_points();
        let ppo = pairing_point_object();
        // Same x coordinate as lo + hi * 2^136 with lo >= 2^136.
        let x_lo = *ppo[0] + 0x10000000000000000000000000000000000;
        let x_hi = *ppo[1] - 1;
        let ppo = array![x_lo, x_hi, *ppo[2], *ppo[3], *ppo[4], *ppo[5], *ppo[6], *ppo[7]].span();
        aggregate_pairing_points(
            ppo, p_0, p_1, aggregation_hint(), get_BN254_modulus(), get_GRUMPKIN_modulus(),
        );
    }

    #[test]
    #[should_panic(expected: 'Wrong Glv&FakeGLV result')]
    fn test_aggregate_wrong_hint_rejected() {
        let (p_0, p_1) = kzg_pairing_points();
        // Hints for (p_1, p_0) instead of (p_0, p_1).
        let hint = aggregation_hint();
        let mut swapped: Array<felt252> = array![];
        swapped.append_span(hint.slice(12, 12));
        swapped.append_span(hint.slice(0, 12));
        aggregate_pairing_points(
            pairing_point_object(),
            p_0,
            p_1,
            swapped.span(),
            get_BN254_modulus(),
            get_GRUMPKIN_modulus(),
        );
    }

    #[test]
    #[should_panic(expected: 'unexpected aggregation hint')]
    fn test_aggregate_default_with_hint_rejected() {
        let (p_0, p_1) = kzg_pairing_points();
        aggregate_pairing_points(
            array![0, 0, 0, 0, 0, 0, 0, 0].span(),
            p_0,
            p_1,
            aggregation_hint(),
            get_BN254_modulus(),
            get_GRUMPKIN_modulus(),
        );
    }
}
// #[cfg(test)]
// mod tests {
//     use super::{
//         HonkProof, HonkVk, G1Point256, G1PointProof, get_proof,
//         remove_unused_variables_sumcheck_evaluations, U64IntoU384
//     };
//     use core::num::traits::{Zero, One};

//     use core::circuit::u384;
//     use garaga::apps::noir::keccak_transcript::{HonkTranscriptTrait};
//     use garaga::circuits::honk_circuits::{
//         run_GRUMPKIN_HONK_SUMCHECK_SIZE_5_PUB_1_circuit,
//         run_GRUMPKIN_HONK_PREPARE_MSM_SCALARS_SIZE_5_circuit,
//     };

//     #[test]
//     fn test_sumcheck() {
//         let proof = get_proof();
//         let (transcript, base_rlc) = HonkTranscriptTrait::from_proof(proof);
//         let log_n = 5;
//         let (check_rlc, check) = run_GRUMPKIN_HONK_SUMCHECK_SIZE_5_PUB_1_circuit(
//             p_public_inputs: proof.public_inputs,
//             p_public_inputs_offset: proof.public_inputs_offset.into(),
//             sumcheck_univariate_0: (*proof.sumcheck_univariates.at(0)),
//             sumcheck_univariate_1: (*proof.sumcheck_univariates.at(1)),
//             sumcheck_univariate_2: (*proof.sumcheck_univariates.at(2)),
//             sumcheck_univariate_3: (*proof.sumcheck_univariates.at(3)),
//             sumcheck_univariate_4: (*proof.sumcheck_univariates.at(4)),
//             sumcheck_evaluations: remove_unused_variables_sumcheck_evaluations(
//                 proof.sumcheck_evaluations
//             ),
//             tp_sum_check_u_challenges: transcript.sum_check_u_challenges.span().slice(0, log_n),
//             tp_gate_challenges: transcript.gate_challenges.span().slice(0, log_n),
//             tp_eta_1: transcript.eta.into(),
//             tp_eta_2: transcript.eta_two.into(),
//             tp_eta_3: transcript.eta_three.into(),
//             tp_beta: transcript.beta.into(),
//             tp_gamma: transcript.gamma.into(),
//             tp_base_rlc: base_rlc.into(),
//             tp_alphas: transcript.alphas.span(),
//         );

//         assert(check_rlc.is_zero(), 'check_rlc should be zero');
//         assert(check.is_zero(), 'check should be zero');
//     }
// }
