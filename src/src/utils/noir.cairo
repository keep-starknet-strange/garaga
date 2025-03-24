pub mod honk_transcript;
pub mod zk_honk_transcript;

use garaga::definitions::{G1Point, G2Point};
use garaga::definitions::{u288, u384};
use garaga::core::circuit::{U64IntoU384};

#[derive(Drop, Copy, Serde)]
struct G1Point256 {
    x: u256,
    y: u256,
}

#[derive(Drop, Copy)]
struct G1PointProof {
    x0: u256,
    x1: u256,
    y0: u256,
    y1: u256,
}

#[derive(Drop, Serde, Copy)]
pub struct HonkProof {
    pub public_inputs: Span<u256>,
    pub w1: G1Point256,
    pub w2: G1Point256,
    pub w3: G1Point256,
    pub w4: G1Point256,
    pub z_perm: G1Point256,
    pub lookup_read_counts: G1Point256,
    pub lookup_read_tags: G1Point256,
    pub lookup_inverses: G1Point256,
    pub sumcheck_univariates: Span<u256>,
    pub sumcheck_evaluations: Span<u256>,
    pub gemini_fold_comms: Span<G1Point256>,
    pub gemini_a_evaluations: Span<u256>,
    pub shplonk_q: G1Point256,
    pub kzg_quotient: G1Point256,
}


#[derive(Drop, Serde, Copy)]
pub struct ZKHonkProof {
    pub public_inputs: Span<u256>,
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
    circuit_size: usize,
    log_circuit_size: usize,
    public_inputs_size: usize,
    public_inputs_offset: usize,
    qm: G1Point,
    qc: G1Point,
    ql: G1Point,
    qr: G1Point,
    qo: G1Point,
    q4: G1Point,
    qLookup: G1Point,
    qArith: G1Point,
    qDeltaRange: G1Point,
    qElliptic: G1Point,
    qAux: G1Point,
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
        circuit_size: 32,
        log_circuit_size: 5,
        public_inputs_size: 1,
        public_inputs_offset: 1,
        qm: G1Point {
            x: u384 {
                limb0: 0x2e3fa8c261ba5428d3182515,
                limb1: 0xe378de0d47922f9f5496a469,
                limb2: 0x13868a317444a5ef,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x4a5ff25006bf8f2d233ccdc1,
                limb1: 0x1ca51267b655e658e21e16b1,
                limb2: 0x7eef6a540b0a0c2,
                limb3: 0x0,
            },
        },
        qc: G1Point {
            x: u384 {
                limb0: 0x9b8459ee77954c5e5218f66e,
                limb1: 0x1863e37e5e1a8985e42a4e82,
                limb2: 0x201802934e67604b,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x7cd18f83e21cfb1987d203fe,
                limb1: 0x424f4a166307d849541fdf46,
                limb2: 0x7e813a7e75c707d,
                limb3: 0x0,
            },
        },
        ql: G1Point {
            x: u384 {
                limb0: 0x844f1f9def88b1ff01351661,
                limb1: 0xacce8109c398fa1f5e58d01a,
                limb2: 0x11ad6b3a3b872fc1,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x5033bed4ae42b1159226a51a,
                limb1: 0x7ee41fb4cfff9311926c0e3a,
                limb2: 0x129b7f90aa4a1939,
                limb3: 0x0,
            },
        },
        qr: G1Point {
            x: u384 {
                limb0: 0xaf0666ee5c56a24f44567365,
                limb1: 0x2834e9b4f5153d7c6f434740,
                limb2: 0xb0e20d82e14a591,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x4b340ea96150d094df88f8fe,
                limb1: 0x22279f5179a36b9413146cbd,
                limb2: 0x28663be34020c003,
                limb3: 0x0,
            },
        },
        qo: G1Point {
            x: u384 {
                limb0: 0x3d9ef999a83cc1cd66bbf03c,
                limb1: 0x96cbad52ea2027630b0d8ff4,
                limb2: 0x9de4c0ce293ba3b,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x8e7254d8848b80222ba7cf71,
                limb1: 0x23660581568ebe7f66fab0bd,
                limb2: 0x117dbcfeb68ed48d,
                limb3: 0x0,
            },
        },
        q4: G1Point {
            x: u384 {
                limb0: 0xa48f4a2c77047f577dbb1201,
                limb1: 0x38ab5ba135dad4650b9bbed5,
                limb2: 0xfd1274f8b384aa2,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x8312c27935b42e49dd9948fe,
                limb1: 0xdb0391c1bdad0b6a118d7b3a,
                limb2: 0xe8a8f5fb867080e,
                limb3: 0x0,
            },
        },
        qLookup: G1Point {
            x: u384 {
                limb0: 0xe9b57129ce995b19cec0c90f,
                limb1: 0x9164de8e3654ed72bd9f54e6,
                limb2: 0x2453e056dc179bdc,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xe1840d9a1a7bba0989618a5a,
                limb1: 0xd97a8cfaeabcda043139c10,
                limb2: 0x15bc4680db7eb810,
                limb3: 0x0,
            },
        },
        qArith: G1Point {
            x: u384 {
                limb0: 0xb63a367e21f41eb47fbc0c3e,
                limb1: 0xbfa534a9c112715fc3e6d6bf,
                limb2: 0x6a9540ee6a4d6f,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x4e8b9e83f4dba7135273b21c,
                limb1: 0x88fbc5cfc98f0ef64b9959da,
                limb2: 0xabf801f8ca9ad0b,
                limb3: 0x0,
            },
        },
        qDeltaRange: G1Point {
            x: u384 {
                limb0: 0x8341b5afdc0c863a59ab7e70,
                limb1: 0x7267e50bb898148ef78d5de0,
                limb2: 0x1618ea679c4ee146,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x8a49046cce4062820e5c1116,
                limb1: 0xa97cc3e75da6cff9a3659c3b,
                limb2: 0x23268ad7678b97fb,
                limb3: 0x0,
            },
        },
        qElliptic: G1Point {
            x: u384 {
                limb0: 0x5df3af7487468bdfa2fd8325,
                limb1: 0xb0ccdb27df1434557e054c6,
                limb2: 0x1a11684e6c135cbe,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x619e58d7db7f2b28cec21202,
                limb1: 0xd523e9572d7f4c60cadfef00,
                limb2: 0x2a8f4fba8e6893b6,
                limb3: 0x0,
            },
        },
        qAux: G1Point {
            x: u384 {
                limb0: 0x7ed60a3cda0c7db10c955c8a,
                limb1: 0x9301dfeeed1b752548d2ebff,
                limb2: 0x1469006b8b61c8d7,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x4a91df6570722995d636f037,
                limb1: 0x68ab919e345670ab029bcbce,
                limb2: 0x19c2b11ddeff8ffe,
                limb3: 0x0,
            },
        },
        qPoseidon2External: G1Point {
            x: u384 {
                limb0: 0x50c9a1b5a476834f5f518c05,
                limb1: 0x1c673b3139893fa365285bca,
                limb2: 0x524c8e7146a4155,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x438261bdb144c99daa9fe18b,
                limb1: 0xd3ae60d42e595d73cc5e8e83,
                limb2: 0xe3589731c046d57,
                limb3: 0x0,
            },
        },
        qPoseidon2Internal: G1Point {
            x: u384 {
                limb0: 0x256adeca293661e04f1a3ddf,
                limb1: 0x5c3ed0f88d90604a4c8d6886,
                limb2: 0x1aebf53057be467f,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x60efa4921bc0e5c16da58b6f,
                limb1: 0x21c63599557c6473249908a1,
                limb2: 0x2bb5fcc21332b835,
                limb3: 0x0,
            },
        },
        s1: G1Point {
            x: u384 {
                limb0: 0x2cea25534ba68b732cca8d99,
                limb1: 0xbc86cef9ca2f1b433e6db34f,
                limb2: 0x9f2420ca39f8c66,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xd4e2e056497e1551b37128f8,
                limb1: 0xf8a3ac1759839d2e7216fc6f,
                limb2: 0x1fc9ba0ca1f14657,
                limb3: 0x0,
            },
        },
        s2: G1Point {
            x: u384 {
                limb0: 0xba359a01a3d06e72bd5e96ff,
                limb1: 0x13577e0b9c5936e55aee220d,
                limb2: 0x154709fd07431038,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x7d14ce7ebb9f0c7057596627,
                limb1: 0x315bb512c54ad4befb8a4015,
                limb2: 0x21d04477bb3d674d,
                limb3: 0x0,
            },
        },
        s3: G1Point {
            x: u384 {
                limb0: 0x935724b6a5c95053777a0312,
                limb1: 0x2e2ff1945693daba560ade30,
                limb2: 0x15a8a335f2e2564d,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x89c9c75193368a53c2699aa5,
                limb1: 0x54648350adb880b5d79361c4,
                limb2: 0x1b7d24b00a517472,
                limb3: 0x0,
            },
        },
        s4: G1Point {
            x: u384 {
                limb0: 0x76b4c039c7efe1bc636a8ef7,
                limb1: 0xccd4425f1aa0ffa4fbfacc21,
                limb2: 0x13b5fe0957911479,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xcca3649a8fced32db68d29f9,
                limb1: 0x905cec75809bcf814c306db5,
                limb2: 0x27137b8082abcb07,
                limb3: 0x0,
            },
        },
        id1: G1Point {
            x: u384 {
                limb0: 0xde693a3ee792993c6ef77765,
                limb1: 0x481b2b7d28aef79f8c700e4f,
                limb2: 0x17f3c984982dcc1d,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xde05db283ea650de5452510e,
                limb1: 0x3646bd782284850616a4f088,
                limb2: 0x26c942b83f4fc94e,
                limb3: 0x0,
            },
        },
        id2: G1Point {
            x: u384 {
                limb0: 0xcb9163a1d1c378e84cb1e0be,
                limb1: 0xa680c807d199dca4b23892f2,
                limb2: 0x9e8c4400c501df3,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xd546f5a0f3f4e0037c6bc584,
                limb1: 0xbafb9962078862b97a655014,
                limb2: 0x1a4e20a630920734,
                limb3: 0x0,
            },
        },
        id3: G1Point {
            x: u384 {
                limb0: 0x46cc9fd4bed60251f55f5f24,
                limb1: 0x2601c7dad83f39ad9be9235d,
                limb2: 0x24f21e58367f93a5,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x7aaccf36f2a478c65f23cc0d,
                limb1: 0xdd5da1a108783205bf0e476d,
                limb2: 0x216267dc395e5d7e,
                limb3: 0x0,
            },
        },
        id4: G1Point {
            x: u384 {
                limb0: 0xb6b2ddaa5591e81bfb216779,
                limb1: 0x6290c61f0f618509482bec6a,
                limb2: 0x233e6668b534fa57,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xe6d3e8293ae433ef77f8719f,
                limb1: 0x327ff9adc990ab750bdb767,
                limb2: 0xa2eb194ae8dcd35,
                limb3: 0x0,
            },
        },
        t1: G1Point {
            x: u384 {
                limb0: 0x5953037a679ab272fa3105b9,
                limb1: 0xb1224ddc6b1bd3222e655303,
                limb2: 0x21ba3aba551d4f6e,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xfae29d6d2c39a34b1b77c86c,
                limb1: 0xc7c5360b19266d1256c709ea,
                limb2: 0x2021ee9bf4036008,
                limb3: 0x0,
            },
        },
        t2: G1Point {
            x: u384 {
                limb0: 0x4acb4ffd415b2d78e05072e6,
                limb1: 0xc8f63212e0116c906e48717,
                limb2: 0x292ec6f935caa1df,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xb5ee4323e4a3c8dd012d101,
                limb1: 0xdff46211993558a4755d42ee,
                limb2: 0x1d3047e5faf396ec,
                limb3: 0x0,
            },
        },
        t3: G1Point {
            x: u384 {
                limb0: 0x205ebc50dd3e6ade8082c459,
                limb1: 0x1a5bdac41900c5160e17aff3,
                limb2: 0xa0a057328da5833,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xde466cea777c910d9a5d4d6e,
                limb1: 0x3becb11cac21a42f71677010,
                limb2: 0x2f1f6579ac435ccd,
                limb3: 0x0,
            },
        },
        t4: G1Point {
            x: u384 {
                limb0: 0x6c763732122a3b923bc6797b,
                limb1: 0x6452657437518f7b73e854ce,
                limb2: 0x27456b3a666ff24c,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x5b2dd53c33662369bcdc4e0,
                limb1: 0xdb96eb72034b26275a33325b,
                limb2: 0x2ecbc0db4ae72d05,
                limb3: 0x0,
            },
        },
        lagrange_first: G1Point {
            x: u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            y: u384 { limb0: 0x2, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        },
        lagrange_last: G1Point {
            x: u384 {
                limb0: 0x948580f406bc9416113d620,
                limb1: 0xdd1d28c2ad910d9cf21a151,
                limb2: 0x9dfd2992ac1708f,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xe57eed899b1a1a880534dcb9,
                limb1: 0x5c98c775c4e4f3534b5dcc29,
                limb2: 0x205f76eebda12f56,
                limb3: 0x0,
            },
        },
    }
}

pub fn get_proof_keccak() -> HonkProof {
    HonkProof {
        public_inputs: array![0x2].span(),
        w1: G1Point256 {
            x: 0x25854ff3aad33d93681c7e08bafe5c25402a6c979d3f550985c01f93bca7fe44,
            y: 0x25b9b835ebc06babb7e686386073c269cc5daaab631ce5f7e09a760254cf748c,
        },
        w2: G1Point256 {
            x: 0x6baa667e9d5ded4dcce15084344598b8c161f804b2333d5bc696336719a549e,
            y: 0x16be1af204fe29ca6639ea31eaa199fc2bb05cbf98d7af96a0f0cebca03d365f,
        },
        w3: G1Point256 {
            x: 0x2fb05f8696948b2a452bca52221c7538c4ad2d24c2a007769c3e1a2236fdcc19,
            y: 0x1613385822bb674f8d47773cf00a7df54cf584fc1f6a3c63f91eac6bcebd177e,
        },
        w4: G1Point256 {
            x: 0x1115f9d68eaf8390e1da284ff3838ebecb9142a9e15b279f0d6eb5afe7854c70,
            y: 0x30fce2a81dbf3294c9da973303b54e297e376d0aff44b15c9f31f74a6ce941d,
        },
        z_perm: G1Point256 {
            x: 0x309f29222b2a314011e4fbacb4e337327d5e1897ca1022fd4f7fbf2a3c744b6,
            y: 0x1aa1865f1323a633621fd36d24bc712aa498d429acd774140791d1bfc1684d5d,
        },
        lookup_read_counts: G1Point256 {
            x: 0x2a253233fd0755077696cab47cf559b3aa1a067aead0d8c1c5cbd360576c27b7,
            y: 0x19170f1a1dfc12078e0c6d0e0be4d158225fb7491ad143923a6afd72945c9f3c,
        },
        lookup_read_tags: G1Point256 {
            x: 0x2a253233fd0755077696cab47cf559b3aa1a067aead0d8c1c5cbd360576c27b7,
            y: 0x19170f1a1dfc12078e0c6d0e0be4d158225fb7491ad143923a6afd72945c9f3c,
        },
        lookup_inverses: G1Point256 {
            x: 0x1ce949d89af31f99a1f0e33fc70a50cc994a8a89fe63bad0f3fd906f1edaa390,
            y: 0x8d2f0c707b85e32ef7155cb3a29222b4cfc17493ab965389b8d33ab1b537074,
        },
        sumcheck_univariates: array![
            0x25fa4914c650dd24366cfdd573eeefc92e084e9bac0517324d2ef0b014726002,
            0xa6a055e1ae0c30581e347e10d926893fa2b99accdb4595ef6b304e3db8d9fff,
            0x1a08dffea861aee6e70de05bc1826ad2da1e31877000ad290456512c380271d2,
            0x277d1b580d0d434b318023c9d4a0d4b93b2c6b5ebe8db1fdcfac35e481d1eb2d,
            0x263c09e1c42c0d5d668cfaabbb6c02cafabd0c64594b7cb78ac0404a7cf4d64b,
            0x814153a9e08fbb0cd756119cac65261be4a5fe63a4b3d2556c3ad71353e8c19,
            0x2f125f6471659cf20cefdb6278a76e19c07d4511bea1adfa611261c18a04c647,
            0x2f1050c7781ba494ba45931d1aa73fc830fb50f61da60854d7f7d219298c6935,
            0x30006990d474a5a491dac6c126c14f7fcade2a293dcca8eb0864e55a0e0cbf5,
            0x3059f6362cd5415bafd6b40dd074c0ed9987bfd027a28bca142199c2e24ef0fe,
            0x266ced0dff44ab98963a13de69ca75bade101d3e3ad62b90e5b71ad49697a1,
            0x17ea14c65331a5a4b87a64321fc2a0466eb7b91864426e91f4da796ef58b9d,
            0x16e9533075c0a8963c0467759a45d83a54fc81e73d521ea34cd32ae46b76d312,
            0x1b9165d97e4cb10bfcc50e63caead2d9a0a4efff8b7b685a06a24fab20abc3f7,
            0x17125f75ddb4dd03e2c5391b30774b5ffcc359f2c93d965081723422a58aa236,
            0x818c47c7d04ac66cdd08e6079bc999af2d780b3b99c1104dc50c2a4f72c66d,
            0x12086438b549388c6d76087e2d8b87f57bb1eccc272b5035ad4a3c56ffd144db,
            0x240fed5e68d4df344a20265b81c8027d756ba848a62a8d5f9f09706274a13ae2,
            0x2d0f3132940fb6b7c14522e3d37b44c61d85888053c9f2b3ddd2b35d493bb49d,
            0x23b20bd3566b0c91cf78681023eb7945ee6b3597406eb1cf92c7b5696c862627,
            0xd0945778d5fbf0708886ab39d7d2119346af54d4ada37c351679ea9956ef64e,
            0x8d2af09bab33cf7cb658204b94ffb5e5fc6cd17a70874412cbd5a2a6446767d,
            0x93bbe10a14e523c353cf282dce2a9951effac691ad8c08e3db9f01ab26cfffb,
            0x28143023fe9de15a6d5988c8f743cad20a5e28935120990dee24bb36c0563684,
            0x2678d009450daddc2f3a4ae752f4fc8b0604d567e0d2c94a5427d45232f815c,
            0x140a5cf332c6ea00fd5d06249356038ce31c8cda03bc62acdace1d3ccd2f6cf3,
            0x8b64dd9173bd5bbb209e32f41bea9985790267b179d4f75cf4c384ae6c227c8,
            0x100d966cdeaa99539f548d3601a09c3ca786048e1fb8a4800d3e12a941d05809,
            0x271086feccd305a97009c90531399a8fe4471c741a1cb7737439dab51789f79f,
            0x26da3f7a3a32277878cee2fa21bd8dfab2ca44e59b7dd75c91d673a26034d1b7,
            0x25b8719135eece6f5ee1e49a536cfe1d1fd04fbb4c129544faf9d47ba4342cb2,
            0x844585d149074275652494ececa20db3ab4f58108535caf0e3e39f6a649a076,
            0x2f8cc9ac163c3435ddf020399ccd18c3294763de7b12de1a6c3ae6f0836477b4,
            0x1c4688de8040427f4787b826c4b0bfcbfdcb0f376c91622371b58bb4b9dcc39b,
            0x70781359a186eebdb8bfc2272b418bae2f888408730fc71ca348833a7300943,
            0x2732b1e493a4c67991798bc1ce504e0e575bca8ab96a9cea39e92adbbfa7c302,
            0x206cc130112415ae9ee805d0b9d811161f66af4ca5929bc48ba5a17abbb9a15e,
            0xb766e82c49d8637ea416289dddfe34e6be814612fedb63ef8243f6e6d82cb52,
            0x290820e27246b1c02289d285d568f5eb8bd898e2d33d50d56aa9b657a7be2d89,
            0x1a1ba152b8daad986bac882aab8aa36c276cefd204fdf928196a37a889bb80f6,
        ]
            .span(),
        sumcheck_evaluations: array![
            0x576a87bbbd1ef8cf52c7bf2f63e8434d0c3e3718243dfc8e4932ee965554c4d,
            0x2ab8f7205e2e79c7f894c2d26ee7905e1e6a7d4cbbf11c3892bfa9461a9014ac,
            0x2518eb416d5e7c0e112a95eb1a722f2f5ddec03765894112036fa2deb5952fa7,
            0x76231d84c92cc6c0f6d4d667f07b6e22d167f05efc8dad78ebcf016a20fc821,
            0x28c1904269e34fa188eed1e9f7ce9ea9e145c1964706d79e6df6a68a81be677c,
            0x1a3f0f2025587d7fe14d229fb1f97f1e0bca3b3f12166655b0be042207584ef5,
            0x1d8371c02888db03d93eacd6af44d2631b4d3196e4a91c5f2d76e6dbec5f2d4e,
            0x86aaa46c18e1bcee4242280772a2251314fce9c448a91ec2c028b27df831874,
            0x25bba51cafa7ba8e2c563228b8ef17459c677363e007f5e8c292123fdca3a69f,
            0x17abcf3f8c7e8f35b1f53c44a4c49b3da05a535487b8f37bf87f52b532e73586,
            0xba58d1274eec2bcce2e09f87ae406d3a52e52112f819fd1c573891144f124a,
            0x1c8b938332206c1e00d2d40919b01cb4f11a13aa95c9559040f3de6cb49a8d85,
            0x1f6f1ba837fc1c175065873150bc6deb914f4b230732bb65eddcc383bebd1cab,
            0x20a6822f5e558faba0fcc81b62b83da8cf9aba5736e1fd0d7e53705d8cae2dc1,
            0xacad73846bbae5dc210b0e5e5164a9facb2a22907139d832bc63d7eb9e2c0e5,
            0x1cf1b6264c8d3657898e24651015cfbbb51b5c8f777fb6f5d77a5e8003cc914,
            0x129c39c90917da8d67f18392dc1aabf5d1d53d2986124e3c25be070ff6c46cc0,
            0x1f466b0d9cfb9689d7ffe6323b6ea3c1ccd4f83c2822182fe74f72ba5626725e,
            0x9026ca16c2f126a2a51f462ebbd7d96ad14fd730f57c86e54c8fc2682727e63,
            0x57c927bcc3ce7340695562f5bfd1b54c9ce02bb05213ce5556bd1d0bb65de4a,
            0x1b206aa1ad73aeb8ec0925e042fd91af3f2e1496456aa95c5a0526f481e1e277,
            0x14c74727f4006ddf1b5af0c58fbf06a3eea1c41089228102fdd589cdc5899f4d,
            0x2789f75526a75e41e31229847f2757c9d0e366683f92b3365a9f1cc01a61835d,
            0x7ed31441881f401e082df4574a7a879d826c70dde03fd5da0bb2d3674c43db5,
            0x1a57ca991500f56b0bb1d912ba767202ed624d56084a570d82000f7ca34f2e66,
            0xd1d57d708bc4cc9955f49b1c2eb1b80daa2e96967f3a3d90e5778bb5fd22c05,
            0xe5d07cdaf35ce4186e193bf195be932f9b37b68d7efb6c39ee80fe1977faf08,
            0x2683b73fe6be5752c03fcbd0816febc3fc2b64bd11a056fe2c1d8091c85cc143,
            0xdd85b4cee3903708e9e83d280242dce6c1e1319a99aa577010e490e0a1001a0,
            0x105322d689b3db45395ad1b5270230aacd44feb8d7242d027dfcd5ff3d26259d,
            0x1689d4c92a49570dfb9aaf58a7c2315cff6a8db9bf3101d80d2f2757b524a80a,
            0x294611ec5bb965d06355c7910f41c29559e43f969147e87ed3df5f3f6062133f,
            0x26ede041ff09a0a0f885c1c5e536a2d25afc2a8a07d86c1c59b5881cca1527b7,
            0x2f2cb5859df5aeca12739d5108da117d17d18d1a72454c29308a6bc988a31be2,
            0x2f2cb5859df5aeca12739d5108da117d17d18d1a72454c29308a6bc988a31be2,
            0x1b17074fe78ef72aca0f70c3121118e8fcc5fa0ebf39a4b427d52727a0014690,
            0x6451524f3480c5bcc45ae6f66d338600cc214acad705436ccd1b59885b2281f,
            0x2d9639ac07346d10245df65a5e57847acda0087363b86b013286455699c7d6b0,
            0x15ff86dbf3203d6386739747acbf330e0d9ae7136359ca6e78ed591e14203ce4,
            0x15a7578de5d0d519d3f93ee9fb420e7d412eaf265741391834e4e78675861264,
        ]
            .span(),
        gemini_fold_comms: array![
            G1Point256 {
                x: 0x16ed372362e0aa171e30b29de64342ac48c99ce5e15705b229b83d93e140d9dc,
                y: 0x2f25ccae7b2c0d3dec7fa6894cf8594927f900915ad7a30c21706f3bb7083f76,
            },
            G1Point256 {
                x: 0x14e19a0c8ab326cd89b5a7f5a02626ad8ad8c72e0ab346c49ec40ad48c8133bb,
                y: 0x27194ccb60a2fc52fa46c1af234085a90f6f7f21a9908dc1aaa0d0c2e05e662f,
            },
            G1Point256 {
                x: 0x2f2f954266d1efbc9f511d6438d8127d8da0ac3651f3b468913e4e65046de4,
                y: 0x26dd5b2a92eff54d0f8d8beeafcdb3ff78424e4ec22e084c85e1de7a09e63c5f,
            },
            G1Point256 {
                x: 0x2fe155bcb687af9ea456716cce5aff5ae93006f46a6a9366de937fd57e1613ac,
                y: 0x26cac589583110478eebb6caf49b6105f7a583892fa5169fc29de02e9d4f4e90,
            },
        ]
            .span(),
        gemini_a_evaluations: array![
            0x159b57f65f09f4d1dff28d0d08590f874e4fa1331c6807c4e76505a70b2fb388,
            0x1bf347ea143600718850742a83003f9efd6d50e02b5e3beec5db615cc1ba05da,
            0x2e70821baf700510256be594d069702cca9094d6d18a2149674b802f0d8b792,
            0x1c6160f761cda9dd038ee97d28c9e2c19ab3b88cd805c143e8cc76f77a5b5d3f,
            0x1a0b54e128a5f4822d6f667cf4d67e12b9936588dff1e8a5ae2eb2c19784c8b6,
        ]
            .span(),
        shplonk_q: G1Point256 {
            x: 0x16547035923f2103c69c354924cf8f12ab062966faca3d85a3760a7df236f75d,
            y: 0x126f896b2cfd0285656d2ecc0efa54ff0066914efd641033e44fe14c38e6212d,
        },
        kzg_quotient: G1Point256 {
            x: 0x23ddbca93b86a001368800a89e515fa9e79e1f4d3cda3e47aecfd7167044a98b,
            y: 0x19b70d7848c24903d13d76f806b87a9fdae1f1892ef476504b66cd638a862daf,
        },
    }
}

pub fn get_proof_starknet() -> HonkProof {
    HonkProof {
        public_inputs: array![0x2].span(),
        w1: G1Point256 {
            x: 0x25854ff3aad33d93681c7e08bafe5c25402a6c979d3f550985c01f93bca7fe44,
            y: 0x25b9b835ebc06babb7e686386073c269cc5daaab631ce5f7e09a760254cf748c,
        },
        w2: G1Point256 {
            x: 0x6baa667e9d5ded4dcce15084344598b8c161f804b2333d5bc696336719a549e,
            y: 0x16be1af204fe29ca6639ea31eaa199fc2bb05cbf98d7af96a0f0cebca03d365f,
        },
        w3: G1Point256 {
            x: 0x2fb05f8696948b2a452bca52221c7538c4ad2d24c2a007769c3e1a2236fdcc19,
            y: 0x1613385822bb674f8d47773cf00a7df54cf584fc1f6a3c63f91eac6bcebd177e,
        },
        w4: G1Point256 {
            x: 0x1115f9d68eaf8390e1da284ff3838ebecb9142a9e15b279f0d6eb5afe7854c70,
            y: 0x30fce2a81dbf3294c9da973303b54e297e376d0aff44b15c9f31f74a6ce941d,
        },
        z_perm: G1Point256 {
            x: 0xe571a05aa0d0eea278a7e4079172b20ea688b501e2df33ef14e8fbf8ec4091c,
            y: 0x1201de236b89d750857c762580fc94513dee4d240cfeb48c08135305fa07b71d,
        },
        lookup_read_counts: G1Point256 {
            x: 0x2a253233fd0755077696cab47cf559b3aa1a067aead0d8c1c5cbd360576c27b7,
            y: 0x19170f1a1dfc12078e0c6d0e0be4d158225fb7491ad143923a6afd72945c9f3c,
        },
        lookup_read_tags: G1Point256 {
            x: 0x2a253233fd0755077696cab47cf559b3aa1a067aead0d8c1c5cbd360576c27b7,
            y: 0x19170f1a1dfc12078e0c6d0e0be4d158225fb7491ad143923a6afd72945c9f3c,
        },
        lookup_inverses: G1Point256 {
            x: 0x286bcc1209503f2684e1eb4f00d4cfd504007b39e5a3289be57590adf8fc21d8,
            y: 0x2bc08adff6a6f3c6a48b8b03973484d19c037d9154fa6e9961b7607927efa790,
        },
        sumcheck_univariates: array![
            0x1d385a7f4039b022bd2fdc730ef2372059b5dcf2b9f363d47a59d2cc741b1212,
            0x132bf3f3a0f7f006fb206943728f213cce7e0b55bfc60cbcc98822c77be4edef,
            0x1bc869e2afb6f5981bc5b7ee9fe42d8eab94446803b0b7fbb16f0aa26d9d901f,
            0x13425f7e5a23a21e8358d622e83511bf6b75d367d169edece2690860228aa74,
            0x22f2709c21e89dd5786fce52db7155e32046182107c692047e75a74f40de4d50,
            0x21672fd66674e9a535cc485e966932b33e15bcc968da4b71860ae26111fa6dfd,
            0x15fa516fae0111b51d9de22cd724f7c234ecd5e3d11c1c226681435ba5921504,
            0x2f3c227a814074c96d2534de198eb7ff5c2c1eae6703489c99c607030f0e346d,
            0x1c6bfac1621a3fa87c579910ce93b0792947afd4e0627c4036ff5acf95154579,
            0x44955338b23813a40a3248c31fcd189a2c66e1908130a18973e17f65c865f98,
            0x2d8dcc691f76f2700f024ba5518a7e18ed276215f628a9389a897dbb6b49d6a1,
            0x1fc9ee4212232732e65ce53c3c2217cbec428bc57bfdd4390f5b773d55981492,
            0x2bade753d876aff7c053d675e0d1e4b4652b1e65a0e776bd8e36a4b14c0df491,
            0x2c5f5b15706486457a764a1c0be7740069e4dbafa0d22d6038a8d4a7ac9b4448,
            0x24093da70bb2b17a9a1c75410c1962056bfe0d4d72afc5bcdba73620b19276ec,
            0xe2964ed0f3c618ad684192beab1a68ec33768972e90d6a9bee8d55a1ed989e1,
            0x2299d5f195e542af7d4c276c0903d129c677e714379ac3588f43042825c4608c,
            0x2f54834f615905b3a83b26140a685d57f11ef76a2f8a01e03faf03e169f8fe08,
            0x1a62af8b96fe2920e34f8bc143e1363551cc5c040c0e8d9951daea2fef9df67e,
            0x19c960c55cf02c8e1a5fe3abe9a54ebaccbf9a310c45d1da0592461d8fcd6889,
            0x638ca6e0003e0fb288fda4241e6f8e868211a4369d6e02da13d865791484a1a,
            0x1faec7400aa3252e9746b128ef29059c472eba40b0cc906fd5cf62949133cd6d,
            0x2c48334374bc1ecebb314643d86533d6ac46a33f0b5bc650e0d1948b785d6498,
            0x27ea5b7fe10f92fb6ca44ee6489acd9aad42ce3f96e655e7ee922f4e6d0563c5,
            0x134a7e4536fb19c7c25a255776ee34ae3f73ed5566139c1bc108f6e3be949eee,
            0x1c734a177571fe26cf2c19ab7d8e3ed488f77f94db8e780c6936b21455f39910,
            0x1a80f0b88d92b97923f4ce9c76197de6966adc402d40a26193f3e1423053e048,
            0x554a6c9cf9bb3a10abe4e09222620b7ff1ae848a9303a90055a01b080715aee,
            0xdf824f752a193d5b652522c34c171ebe0611bc7fbd0ca0695aca8e35f46ef4a,
            0xcc4bb81801319437a76ecf8507ed67977f7d82dac69b36d4f21d7dc9431d499,
            0xc855340e4bb9e6eb52ec852521631062828c6fa1e44ee93effe3f94bb4ddc49,
            0xea84ba77b5405b835da4608d884367153ce2e325567ab632a31dee96a0ab362,
            0x2715892206af54c8fe356bd583ff35d14df7435031395fd44f13b4e2cf9520be,
            0x13256a9856e02a4385cdb5364355e538891b8095acd87efebdbccab565cf585,
            0x2087890798b233f1dfa4b468e3217920b98cfbd1d0528ac902ee61d3be5eaa10,
            0x2a627ceac4484b25474ba073d4f197a8e26237dbe55892de314a9d7cad24d7f7,
            0x25fc80e7142ce910544b0b45b00133fca44696b8d37a753adcce01dc33caf154,
            0x102027227f2cfc75e92af4416d2e9fca784ba43046f4b04f1d7ad22340c85369,
            0x11576f5a7f00ce29ac8f1a007873fe5376975ea3d0f1850e7cc4382aef604506,
            0x202e7e3b995e5eb08ec882216a5f22c28d21e5d253b918a264952b9152be9921,
        ]
            .span(),
        sumcheck_evaluations: array![
            0x22d8ef125e6993e1b3a6e8e05bd15f12bcd9a55e9dd20009a339dec2b50f7a4c,
            0x1f34fd8a90c6df5c0f2e692e443481883a61c377b3e8bbeea3afbe409c248780,
            0x260305e08a71d6681d6c9e2312eb6fd0cae87c5b1e227f8cd32785a8936aec54,
            0x2beeafe7c60beadb08471fed4f3dfb6d18e902a0cc75c20db949ddb819fd0516,
            0x19889d2298a3ff336c20b4f1cb03ba929ece8f51176d37790d4b1f4d67a7ca20,
            0xcbf86d3b58a2e56a4886258351e45b4157324a6cd035cb1f6a5358563c72003,
            0x1422c87cff8dc9ac134ab0302a2e19138e4848a9b767650ed5fa8eaf62642b42,
            0x2ed204f3588039dbed7b59fd83b8a48b7377773b64775cf8af847b87d6a7e619,
            0x1e4491681e900e8b14da24ecd1161d1db0ac94f2be8b24563f6cf9933bb185c1,
            0x12772f6f286617c35da909f376aa1fba880bd56ece1a35856764b52b130f2e58,
            0x825274d07ab53f6271ed247ea915b6b4d5453265a0e83cfa3c9137f74d1fe4b,
            0xa469b729fcd6e1b994bdaf7c4ff2b2ce0b2c1726fd9d4bfcfb86acbba618a4,
            0x1e69362ce57609baf7667615ae1eec84f4c47a3ac5f4d7dec29423e87cf324d4,
            0x2e17c06540deeeeb27a3f98a73bad80554270f22b2944116e0c0d660f8bf3ed5,
            0x399924fc5e302badfafe352fe6677248097357e58426b6daeefbec695281504,
            0x5ed6c2ed8c604beaa35ac1a964b1fce7f3cf699ca9f8e89ad9ad570d53c3096,
            0x27801187e70f854770cd75be5f1c3cd7641e109886ae5ddfc4ea8f136ae2f1d0,
            0x27dc8fedccd6fd3f073334fc4aa0922929f5fe9d8f3a58b0739e200165b1042d,
            0x163d44e768847e4f673362e9ac668015755209df2a884e2e4d9f0342af92864a,
            0x1d7dae290a739ddaa0a303eb66b9b9bca66df521738ab21adb27700daceb012,
            0xcb74c109233b07d47f71b2625bb8afee09add1471b7a52eef49b850955eaa13,
            0x218900fd7eebfeeff602fdeff1f28d19f99219283a7f4943c36f62430662c091,
            0x244fe015da704818a66c440b1df977c9fdcf9f14a1195487f6cc34ffbb29d704,
            0x2bba03327f40b0d916f337b0d128583ceb1362a33828c81451ee8cf98705f093,
            0x1735dee8183803c92eaba4cc333e949c44889cb0f04ce35e1dabd1dcb138914a,
            0x1ea1688373d20700ec5b39e729aceae52c6a143974662150289bec73a556b737,
            0x2e6bc519ec602e9a5dd9955825b084c47149668c2dd06cfe625e97778800b8a5,
            0x241803f55ffb5cc3db37b9af1703bdffb8526d463ce431adabe43982dfd77024,
            0x2f02d2ac3f61bee2d748daaaad2c8c6c50c7e3d8d5c8128e4dd54c5a5cc2cc0d,
            0x2690ee2765cbf063d4108f3fd1dde78869f6b17688f95b935a3ea44b195016a5,
            0x1638bb77b41aefc00da609fae6474a266216300ba0ec33ee40d467abd03bc1c1,
            0x236d8bf99c98cacf01b2e972caa8b61d228d6d7dde410bf028493c7886d07ff3,
            0x1e8e59e01294ab2672fe9916fcba3eb9acd2e53177e18e020c5b02a49fad0a24,
            0xac742f341cc48e53a4b8f1952f5bd375f010fc389ac1d0ee98115b253820ce4,
            0xac742f341cc48e53a4b8f1952f5bd375f010fc389ac1d0ee98115b253820ce4,
            0x1d38de36cbf4e9633ffc62013a2067a65605b6527c0ef8490730bc0324faf101,
            0x2cb31884ec73dc9ff93c31cbcc40b1b92ff2958b9278eb8a85ab42326e0db7d3,
            0x1bbaa4374a2785343360511fe4ea1f2745183537f88812b25163a525a22f9bec,
            0x23d5eac17f12d7828808627c5fa2e7411cec264aad2946cbd20399a5d6e356fa,
            0x1601ad263deb8a7926ea4e6aef8b4d64d20b0a3b71c110172678795691d9cfab,
        ]
            .span(),
        gemini_fold_comms: array![
            G1Point256 {
                x: 0x2ff690a06de079c2c329d086bfce4c44943aeba97e7d555af2f36badce1428b0,
                y: 0x765f8bb9d50f058fc728693e166355e205b930c7722a9ff2e10b23df5fa7f56,
            },
            G1Point256 {
                x: 0x636035877385ee65ade7c841734682e59354f88b542ef3ca6bfdede9f377c8b,
                y: 0x13e043f8f283d400b344d81216174fd56d5874f4b57aba682e5d9f5e544442e,
            },
            G1Point256 {
                x: 0x17b641e73e56402cb71b1be83b9d850d166b14545ed9fe305cc7016f69a5cea9,
                y: 0x2b608ca7fcba01b06080ceea1b6cfef6d9fdfdca89f5034993bc4a668b7b3cba,
            },
            G1Point256 {
                x: 0x15e7bf717883bf561ebdd30e72e8a693b0550939d854b3c0a7f6b09565a7c7c7,
                y: 0x1f68ebff6dc5789ece13a465150026c1dcf34d20b8e08c4ddd1d2eac4d8559e1,
            },
        ]
            .span(),
        gemini_a_evaluations: array![
            0x1e5d72ff45a3081e0e6e841a4fd76f0c0963879f690f7aa20e791034de52af64,
            0x18a4f9fc583e183951cd59b58023a274e1a5d8b4d02f5098343a03b55d8b1c35,
            0x2fa605275df0fd1caba7778617de9ed98556923eb825ed697dbfc688c13ffce0,
            0x372f90463d7d09519b31bb56b2e050db1fd485fac9363579bea351bb3266072,
            0xedf1602d1c24a3195bbf3d3ac993911a210d3086f6994d86013cf140238db2,
        ]
            .span(),
        shplonk_q: G1Point256 {
            x: 0xc87cd604d2f6b0fe776889a887d5d65939a59dfd0d09af54c20c24a71a6692b,
            y: 0x15cf9ad6ef770bb956f1b9fc8a5e8de65510868cf375a375c382f466986e3089,
        },
        kzg_quotient: G1Point256 {
            x: 0x68312703e8e9469151af77ebafc783e1dfa8190fd44a3e3f618e499c4dbaf6e,
            y: 0x1498be756bda345ca31e3555ef2662d5e6b2b0148b66d743aa2bd69dc582a608,
        },
    }
}

pub fn get_zk_proof_keccak() -> ZKHonkProof {
    ZKHonkProof {
        public_inputs: array![0x2].span(),
        w1: G1Point256 {
            x: 0x25854ff3aad33d93681c7e08bafe5c25402a6c979d3f550985c01f93bca7fe44,
            y: 0x25b9b835ebc06babb7e686386073c269cc5daaab631ce5f7e09a760254cf748c,
        },
        w2: G1Point256 {
            x: 0x6baa667e9d5ded4dcce15084344598b8c161f804b2333d5bc696336719a549e,
            y: 0x16be1af204fe29ca6639ea31eaa199fc2bb05cbf98d7af96a0f0cebca03d365f,
        },
        w3: G1Point256 {
            x: 0x2fb05f8696948b2a452bca52221c7538c4ad2d24c2a007769c3e1a2236fdcc19,
            y: 0x1613385822bb674f8d47773cf00a7df54cf584fc1f6a3c63f91eac6bcebd177e,
        },
        w4: G1Point256 {
            x: 0x1115f9d68eaf8390e1da284ff3838ebecb9142a9e15b279f0d6eb5afe7854c70,
            y: 0x30fce2a81dbf3294c9da973303b54e297e376d0aff44b15c9f31f74a6ce941d,
        },
        z_perm: G1Point256 {
            x: 0x309f29222b2a314011e4fbacb4e337327d5e1897ca1022fd4f7fbf2a3c744b6,
            y: 0x1aa1865f1323a633621fd36d24bc712aa498d429acd774140791d1bfc1684d5d,
        },
        lookup_read_counts: G1Point256 {
            x: 0x2a253233fd0755077696cab47cf559b3aa1a067aead0d8c1c5cbd360576c27b7,
            y: 0x19170f1a1dfc12078e0c6d0e0be4d158225fb7491ad143923a6afd72945c9f3c,
        },
        lookup_read_tags: G1Point256 {
            x: 0x2a253233fd0755077696cab47cf559b3aa1a067aead0d8c1c5cbd360576c27b7,
            y: 0x19170f1a1dfc12078e0c6d0e0be4d158225fb7491ad143923a6afd72945c9f3c,
        },
        lookup_inverses: G1Point256 {
            x: 0x1ce949d89af31f99a1f0e33fc70a50cc994a8a89fe63bad0f3fd906f1edaa390,
            y: 0x8d2f0c707b85e32ef7155cb3a29222b4cfc17493ab965389b8d33ab1b537074,
        },
        libra_commitments: array![
            G1Point256 {
                x: 0x29dababd8db25ec8ff1cc67d94d8fcd24eacd2398b39c8784183b00a29af204,
                y: 0x2950240ca90a896b2063f3680a6aeabdc016d37c324e933cbb5bcbd6c45688ab,
            },
            G1Point256 {
                x: 0xa966ebddf2f248de5097c331e2943f432267dc1a5d114b7b3e00de69350aa9c,
                y: 0xfa03bb162da353f56241291f4136e81c5227ee89aa25e1ff2dde3fe134bb416,
            },
            G1Point256 {
                x: 0x27038e56386e6f7a92efe22b69272cb8c63e605ba8a7652d6e0e9d3d76fada54,
                y: 0x29229f929b71bb0dde334dffa1573363e88cb70a800a3e856d9b1b429a83e6c7,
            },
        ]
            .span(),
        libra_sum: 0x18913b40b9ee0e0d0208edf8a4edfcad37434a950f6e5c5fc7486793de75929e,
        sumcheck_univariates: array![
            0x77482f79a32487b19500e0e5b23d3a2d86d2defecee4992ab1efd77e7a56cf6,
            0x1d518251adf1aeeeae102238ee85b6d0befc7072ae0d9ed40294c33068dca4a9,
            0x1e7e8ce8f791175699d0d33538e7c98a70095cebc5b93ab1edc4d8d6788f8c,
            0x2dd6ad8e3caab315adbb7acf074ca6f9b7608b1fac539197fcd53a652754b71f,
            0x2a8cbaa5001a69014e34950f123c91883336a99b6b709eb744c0f7f2297cbb5e,
            0x19dbe330c18330123d80e78b32be0212d3eabd937f6a64e669253057855c13a0,
            0x6060fa051379a2b2652c0c60b1c5813d21300f210675a71895535b0b0fa4557,
            0x1dceb7c44bfd86221100e67667adeedc0de456428f1d3c3e1ef9f3b4966fda4a,
            0x2b705f50dd25e8760e5a188175c98cc76d15c11fc3f352cba2a3d8d002ecaf1,
            0x273a0b4abe9d6ed0454f18b9e01f342c6b96318b1c06f2a50b24bc0c2b8fd973,
            0x19da14f89146621523454f1fe9aa9e24050facbaf234633a31dfa0a3e0323037,
            0x11acfb44ed933f90a455e019345e77c36f84a3e186390ab4f4aa42f301e6f7f6,
            0xe1f1b04912b8424208aeb77f56a08ef4d4aa3aa6e41f7cfd46bf78da61038c3,
            0xb2c5b1f56d9e575e243a9b253b35225d707645d2d86c12fb6a2395ce5af2b65,
            0x22f37f28dc5869d70d2c843d62d98b569c043002e4b9109fd9f6d47ec50089e3,
            0x112c63e488999e4830c63418615115b8b1a916252b29417e34db69bdf2abbfd5,
            0x287a6502970ae16ac3ae5f9cc14076743dc834cbe51a6c52056860089ea44eb5,
            0x45574d6abb7d31c1ab2342e30bea44ac0b4a118eb9145ac24895a2054a1fea6,
            0x14b44c8f767bb86d90e340c9989209f3b895374fedbb00fad54c258cb0588ea3,
            0xb5c971462eeb2ce4283fbcb4d2a01df993ae02bdfbdb57b10d83dec33f362de,
            0x11be810f87197bef7589752a6259e6582a202a10120a2d283995890efec4fa21,
            0x1f60d15de93cda9658a8e3f629cba638c72423d7313ad61ada864e86cc6b4f9a,
            0x1d6f66ba481f8c55ad9809ac082fba187fb814d4f6a4a0c2280c3e0f1d6d08a7,
            0x1d313aa6fe249b5469a25b91e0be61eaac8856062a12bbc9c374629220cf61cf,
            0x14bb3d50bc887516c164a2e13a903718e4378b7bf57d04ddb872a9167feb135,
            0x2e868dece461c60c27e34989f68720bec91bb3f14898511f5ef53afd1bed20e4,
            0x18e2a7d06ccdbddce48b6e4a9861eeb1ff3dbe241e7aeb6a976a9f2634cb5880,
            0x2e5ae65f189daa612ad44360f5264e371fdcc48237dfab1f0ccfe14fdd1b3538,
            0x26eefd308be2bf55b352b6b5f5e4f9ba911531949f43c98d0d5b7289f2c54927,
            0x520914a30173eb6cac755e285ac705f39b73595291324feede9331f7eeb6d40,
            0x2e3129d09fbbae12d9bc5fc519dbc0bd52b87faaf39bba65fd34b04d07e93774,
            0x163d5ba8fdda01dbaf4beb1bbe8f20543ca9d1ac5a7ff361e22f4b922f0e0993,
            0x9e66fd39b6873df478fc03c13af1369843c1905c8b138c8de00c49c4029db72,
            0x22428511df200a7781c48ac23111d85c7ca5e3162f66e814eed358b8ead0e4b9,
            0xc1194d3d3e40152f29842d7d3d74b4019252924d37b62e7aff123bd91262a87,
            0x1a111532f44c7be1533d652c2e122e779ad2e607c81dac8865a1dfa117c9563d,
            0x26501a73fbd8bad5e7465cd6064af42d2392740942f253b3828ba586eb18ea62,
            0x1c611a10b8bed39c18c82b9fc70ed6664f8c4ca2c36fb691aaa9c09755085484,
            0x21279b2bc5f5400b4b06a0e25961fde451b32f746c91957f84361f14a476c15a,
            0x824962f9aa5efd76897f14882d82bf310a5cbd3b6be4a2f7c9c90236586fa8e,
            0x11ab4817513692944b04c0bd59752cc887cedd9ca72b2f4fc68890de0afcfaef,
            0x16a0e7f250e4a3e8a7d2eeeefac058bc6bedc59249ff5d6198bb401c5b4fcecf,
            0x2416ceb33fdcddddfd970b9e0d61eb2867efb895eb6cc93f9250da119b3a1534,
            0x1ed8b49bbf7399c302e9b88a90a42af50a7b1d89020d0b73a5a55386f8b68db8,
            0x507685fa02bcfff9144495dc3a33590094e1f9f5a7910ccdf9f478f66f3b305,
        ]
            .span(),
        sumcheck_evaluations: array![
            0xf754144029dcf199e02f8b42504405bf69c44b6c06ceff8840c680ec787fff,
            0x40621e65d1a8b1a4748a05cd487d9aa07e6749ce8ea4badd57367eeb6c8abd9,
            0x25593cbb70d14a82f43b743acabf678c29d06388472cea114f7068cfb0b41d41,
            0x1cfe98acb229d9e99529965df7e37b4bff8ac1fd66527c0611a19db8b23efc28,
            0x775a40c7b837210e555911824d0319939a74fcfaa7741da49884ee1648182f5,
            0xaf3b0d3c4106b58b272f04749fdd2389e56eff10238c7757fbee39e9741acc5,
            0x1833e2a1e4f602b340a830801fa3d9bf8976976894aa91eaeba53484f1236959,
            0x4bced6867a9e9ebf2e9c5730a503d2c74ad757e199b4394f3abf9f305c38b28,
            0x23ae03cf1eb06a46949096b4ac4829bbe72cbd815157554bd8e7fca0b71a027b,
            0x292e731027fe10aff7f187c6b1a9ab45621af53c06ef1678e6dba66723773d26,
            0x1c4de3272b8cd3a7ffbd8e782751b70463d0caa97cf6e9f2823f5fc6542f65da,
            0x2c5a444db196131bdab4d02252f3be9b8c97ee7180e255897f062c7e816682a2,
            0x12faca8cc51fef89b27111c63995a9e6e7ce279cd58646ee638d4f82beb39de0,
            0x26ee7db75365d936f6eeddd963f0401d415245da0da28f25d143a099faf13c62,
            0x166a15b1a79083523f3c261626f34a09ec8ecb21bdaacb9da5c393ab9a4d0586,
            0x23e8405dd71d25e50bfbc47c4ca9b2f7b2d9ec5baba9ec27e4bd51c7771061f,
            0xe5a0146fff79655365169030c3e96bb67f31308457a89c5ec5627e9fa1c15d4,
            0x17778a0f11fd7910bb59aa42c163d8b26a5640f9789393b1c89542d426da22c8,
            0xc11ffd69c2b48d1adf05b7cf27054b3141e2034fdceb38f77ecc1afe6bf0fc7,
            0x2f41ab3576287d447a95e35ef57d07a5af2d7ff031bf32347afabcafebb4dc3a,
            0x224ad3863587cbbfaeedaec9ebd5bfd7f8c5084f9b067b5df52a26ee59dc8682,
            0x289bb4e072232ae8604aa471fb902eb4155fcd6272802623f367169c825f7386,
            0x2d05a33fba29979b7636778e6b18dde2d675390b8e8442e81f677ed64aaa104c,
            0xe60ff2873cec943e19a1c4685499367927e9043293c48a61f74d448f9698c62,
            0xf919d32fd2bac67e8d6d8fbcb7d58848a183672de1087fc813a69dab07155a0,
            0x21828fef76a3cdde36368a7ecfe0351e522491965e3f05866aefdcef9c49d54a,
            0xc9983c37dfd8fc5c5af0821ce54733ae6dc58f825c36133fde961a8c4f0622,
            0x817222af0688e28f75f580347508ec9b78e117d79196dcc5154aff9ae57f5ca,
            0x1dee43b223af0e60554aab68af2c3be298be66524a28bedaf5466160ddf6066c,
            0xafd25d93946eeb6f4849dfb8053d30ec119cdcc18264224a38091db5c50c3b3,
            0x2a3b235036b16364f5b14f21ead6e3d85d8979cd99a230ea0451aa56b9ee0493,
            0x9b1bab7c3ee75cadb0b5e3226484aa71079577857e34e21022c5dcd92089fb,
            0xb6051469766a2f93df764f8b0a7bbf1b7a2d75758636706848380f69892ae70,
            0x258fff333ea6258a90e0e6764648ac499ccde93be40d010dd5df2ff4e6288d57,
            0x258fff333ea6258a90e0e6764648ac499ccde93be40d010dd5df2ff4e6288d57,
            0x2fc11ce9ef3916a490d4e69ef65a054ad744bf5216f9cf9f00e4634003da9af9,
            0x2f68d17f7a203a36975b1317beb761c141b637be3afd82ad2538c6e52af75fc1,
            0xf476355caf4ff8ccb83ee89e49a3c33e0fcd33756989c54b67b2ea010f48257,
            0x2e8481ac8179d407f83762482e40d7321e3c442eba1648e478244dce9aa44465,
            0x142742bd22399e5b2d24bee95405af561e2a1b72fe59e8b3ba6c3069b452935b,
        ]
            .span(),
        libra_evaluation: 0x28caee8c857d85090425eef0ea8bacb18a572a468b9fd8983c857de94693442d,
        gemini_masking_poly: G1Point256 { x: 0x0, y: 0x0 },
        gemini_masking_eval: 0x0,
        gemini_fold_comms: array![
            G1Point256 {
                x: 0xe47154d3d4c8f7e77cd3ed5dc5d4ec1db2ea674def49dd7076178b55ade63cc,
                y: 0xd00e421b030d024a4079bcfc0a06b14bbdcdcb101f4512012fde270b6e1a459,
            },
            G1Point256 {
                x: 0x2928dee14e8b7985844e0f10282da8297df255e5e681d0e925de7162200ec5fc,
                y: 0x1a6954bdbb231868ae13338d26f25a83f51477755505f91ff069888cdd82267f,
            },
            G1Point256 {
                x: 0x1d6da435364889214a1114221f20d3818aa0833d6dfdf620e763b1fd5d717ac9,
                y: 0x56630376d62badab87eb4c2425a121276ce3dcbb6540c41ee26bdf2fbcf6bbe,
            },
            G1Point256 {
                x: 0x29f262d8e747a037155524ad307687f1c84acbf05d66c48a1b1caa40be4da7b4,
                y: 0x10a276ee1225407685fc227975d995e2c786f3dd996e8617578d2665bc2d3271,
            },
        ]
            .span(),
        gemini_a_evaluations: array![
            0xd52dd8730efa4fd69058a471493131a66565be60d4986d7a2cdbe22e202eba7,
            0x1af848a3d58dea9cb91333c2a013bb31fd2548e8e43f7b881c808ef0448f1c1f,
            0x2de9dd3d3a0c0ab12980fd224952bf4806fc0eb95e7bce78f69b53c9d9002ac5,
            0x3c85bab505092770a5adedd211556a82d71ba2f7a8d1f4f237f80c4463b1da2,
            0x135552c7adf06bc51a5e10da1cb3565a747e1fde3ac34f6138c3b8d79c422594,
        ]
            .span(),
        libra_poly_evals: array![
            0x16b954e70880eca51a91fc8f4e4afd6809210f01194b419cd268699dc1b3e34a,
            0x28d50bb4b91676eda78153680d26c1b69bc5eb6a2a63e894bf76ee2de5aac162,
            0x2ab9246c18eacfded1d470215488bde06e5a31c2ac112d3919960a3450e2361d,
            0x2d8e15131e1d48d94711ba5e0499758ee2caae547efbba50e424bcf8ec2ae932,
        ]
            .span(),
        shplonk_q: G1Point256 {
            x: 0x2fa740fd0db26b8e68f2c7707e52817f590bb67b4f5b0efe2ea1e8ff925b2dc9,
            y: 0x29ee2242ab31e45dd6184a4952603f1a2e411f2d8fad71e67966cf215e46a2ac,
        },
        kzg_quotient: G1Point256 {
            x: 0x753f1d49d7a5238df7cb362553b8811c6c486beaf321bbd500359fb181f5c7d,
            y: 0x24d1483380ebdc6f6a259464c62bda4ba080f4388f0c9030b8d7b09211b6fe7c,
        },
    }
}

pub fn get_zk_proof_starknet() -> ZKHonkProof {
    ZKHonkProof {
        public_inputs: array![0x2].span(),
        w1: G1Point256 {
            x: 0x25854ff3aad33d93681c7e08bafe5c25402a6c979d3f550985c01f93bca7fe44,
            y: 0x25b9b835ebc06babb7e686386073c269cc5daaab631ce5f7e09a760254cf748c,
        },
        w2: G1Point256 {
            x: 0x6baa667e9d5ded4dcce15084344598b8c161f804b2333d5bc696336719a549e,
            y: 0x16be1af204fe29ca6639ea31eaa199fc2bb05cbf98d7af96a0f0cebca03d365f,
        },
        w3: G1Point256 {
            x: 0x2fb05f8696948b2a452bca52221c7538c4ad2d24c2a007769c3e1a2236fdcc19,
            y: 0x1613385822bb674f8d47773cf00a7df54cf584fc1f6a3c63f91eac6bcebd177e,
        },
        w4: G1Point256 {
            x: 0x1115f9d68eaf8390e1da284ff3838ebecb9142a9e15b279f0d6eb5afe7854c70,
            y: 0x30fce2a81dbf3294c9da973303b54e297e376d0aff44b15c9f31f74a6ce941d,
        },
        z_perm: G1Point256 {
            x: 0xe571a05aa0d0eea278a7e4079172b20ea688b501e2df33ef14e8fbf8ec4091c,
            y: 0x1201de236b89d750857c762580fc94513dee4d240cfeb48c08135305fa07b71d,
        },
        lookup_read_counts: G1Point256 {
            x: 0x2a253233fd0755077696cab47cf559b3aa1a067aead0d8c1c5cbd360576c27b7,
            y: 0x19170f1a1dfc12078e0c6d0e0be4d158225fb7491ad143923a6afd72945c9f3c,
        },
        lookup_read_tags: G1Point256 {
            x: 0x2a253233fd0755077696cab47cf559b3aa1a067aead0d8c1c5cbd360576c27b7,
            y: 0x19170f1a1dfc12078e0c6d0e0be4d158225fb7491ad143923a6afd72945c9f3c,
        },
        lookup_inverses: G1Point256 {
            x: 0x286bcc1209503f2684e1eb4f00d4cfd504007b39e5a3289be57590adf8fc21d8,
            y: 0x2bc08adff6a6f3c6a48b8b03973484d19c037d9154fa6e9961b7607927efa790,
        },
        libra_commitments: array![
            G1Point256 {
                x: 0x2a15a55cec6b7f378a1cfc4b057c2d9e30344886e7e5b396aad536e0dc49bf2,
                y: 0x2ee60f7ffd99e48aebc2380122d99741968ff493865f6755c81e6a13cfc7ce03,
            },
            G1Point256 {
                x: 0x21e46d555d9bf6ef68984f9f26bc580e0e6395b52540b6066c518c720e9be2a8,
                y: 0x2555f85b319837d879ff3ec83e258fe7744c68284839a2be8f840a7dbb6ca584,
            },
            G1Point256 {
                x: 0x1f1895d18756297d4c51be848f3b0401c399caca45cde57fc87f2e1bd9799c4c,
                y: 0x14397d15cd93bdf9105507bda4b5196daa063bac024a6cb2e5c084d3cc3f162a,
            },
        ]
            .span(),
        libra_sum: 0xa444427fb943055bb0f42224491ef4eae53e4f7e0e670e00edb9c05f66c8782,
        sumcheck_univariates: array![
            0x1ead45aa365eac9aba380056e8b37844603635ea6c5dc07f8de6f2887f7887b8,
            0xf896ba879fbf701ac6dfb25d28fd42bcbd01ac9277b6aaeb33f9d5a2d0e6bd9,
            0x18f7366d0f42d7f4b404574eec862ba5a709b46cc4e7dad2ed9eb699e091c83d,
            0x23228d685be639c6ade6088732ea33d2f1e50b23f45e491c6a5b16dfaadd7a0f,
            0x1c7f606e52d90484a1e74ac406c6d8334bc2f40a2d69cdde4392083ff3f23419,
            0x2d8a6b371de91d83dab8c6cc2c889425ac6471907ee697ad818f156a5951546f,
            0x21723daea8ee944a0c63f000c4e03ad7409e6dec6fa070ebe5530587850f9cb5,
            0x24fe6d41fd8ecd77e23ba6e8ef4193e82e37ee2479e569109132bbc313cf76f2,
            0x3050f0898af90f10f54277876ca3764e3b774cffc296abed054c4a99432c45c5,
            0xad40d89720393db0afb113120bb9dd85bcd6860954338248dca81b8504e80d6,
            0x20be164df613767ebe346b8291283b16c9eed127ef8229b9e51a4fac748cfc46,
            0xd3e3855b6a8d26c1c97179b7107a168e3dcc2aacc0b660cec20c73ba50a8c8a,
            0x1639a7708625f0c0184ff07916d3d13bbecad6e3b4e6e5893759415b16a6d616,
            0x1603e1120c81078941681dd306226ce55b9bd162a63281021f15cfbb3ded655d,
            0x10c0e403744e8c1d01d5a77faa7b16e6d432d2e9bd739da98977716489fc55a0,
            0xec7491734df4a992da25fbace5411f333c0d41848e8d657dae0834ce27645ea,
            0x30105ce0f67ed170bfa67d7d9a3068c403e8c2c3478924ec521f8a9449516060,
            0x209593d9643be79789119ad6b1de0a6ea30fcccc1d637b1ce8fd642fea1bbd97,
            0xa9c418e0029a82c2604ca0e308b7072c284a6473b8e04709dafbff3b560e5c1,
            0x216d3079ac19050157e27008f8c225ae4eb5f844b7be94f9c61755d911b7fdf7,
            0x1d480673f2086ece30cadd6789a5aca271547a6b874ae9c57cf79520e9639cb4,
            0x291d0779a50de7b5fce41da5154ab3db4ace8a470d0fdd73f4597498a689b3c1,
            0x15ab4d7e975cb854ddec0c6fe385bbd286db83e72a748616e06ca98c34e8ab28,
            0x2ca42592750ed91f713904e18806d283e9cf9977883f26b9c3e8dc4f0f77a035,
            0x1e8794f6663dffa170e2a15165019958a25f17316def92b470ab3eca62dd1263,
            0x24b0b76b0449169f5c3ccfc37306116c55b755c1edca1659509e845a97c8a7cc,
            0x187f5bf7a955639144ff9c91f4582db40dc51f3c068012ef23853aae8107e48,
            0x1139339bd674691fd437a15df234d8b5b12af14b50e518d45ca31ac81bdcb951,
            0xb691fbcc458e1c5541c65f60ddbbd9b298912aa697b6fdad00bad08bf679576,
            0x1f92d5bc287c9391475f6bcf8369300be35317d7e2d92ff87fbe238a5b26e797,
            0x28bb46febe20c2083d6f8a7fd8cbc7706ca094182289879750dc4fc9eb9ba718,
            0x1bb0928fc29e2338e0e148d6ebb04b1fa55e36653b38d9e8d087da166ea3dea2,
            0x1cc5bb4f1def8c2aa20ac8d4604bd87814ec61bb90aab0aa0c27d2ff18af97fe,
            0x203a14380a5b283d0fb910ed18239ec2eaf16ffbc1dfbc6a99256294c520546,
            0x253e7f8b93bcabf0e2a80ba862896dac67086368ed93d454a0a5078261309d49,
            0x1d564cee99df93e830ba13385eeb76a070dd2695788d0be47db65f2c73273066,
            0x156e6b9b626a5048a9a8ed072152ae163356f6d7f665c442948e98ab43af7b69,
            0xa79b26fbfd418c09919da30435660898b311cdd99f72fdf9f4c46312293746c,
            0x1e5628d4741c61cd02cc1df0e7744f98b41f881e948957b26659adaea517267a,
            0x2576659a2b1337119d93dccdff98782eb8bbdfa9862daed77529097bc665b151,
            0x4839f5e50c6de85a404e4bb288d9396ad5dc44d527036af161fb0a217369554,
            0x715539c92201c283df5cd4c91f2751501eefc4ccf6a8d319fc5905e11592dc6,
            0x2ccf70bbec6bbff59c494b3c011be331235c237c67bfab148cbef8d6c3ee5a96,
            0x2d3800fbb69bb2713ba4e12f60ab8437957a87a3c3213c7e416252a174ab203c,
            0x2930ad10b2552933de3e9cf557ab13adca26d3cee16c9c05ca91b1e6380a2604,
        ]
            .span(),
        sumcheck_evaluations: array![
            0x1f5ffd5d908bf86e0ab0700adc1d8094e1dd202e6990c703c11e9f3d5e8ed006,
            0xb07623da3a73c8a26411e99b92387081a84ac41da81a18d3c6e9622965b6fa1,
            0xeecd3499d455ca2da11cac600fd996d4c9c6ff9b6ab12cc156d2e6cffa86750,
            0x5c6b1190e118fcb28e2d6be52df1a8273757a011d7c13bd7b9eff97bbb92c6a,
            0x90bc596c7e98ead92dc4970d11bd8c5534803749de83da2c53efe1508c3954,
            0x20375b4b49cb23a347ed9f154f8b2de4c231c4d68e8de6ca0fd62eb133a0ad1a,
            0x1f91aee8d560e2af727a92c9480cb5c30b4935d75511d1cfd4f4cd2424afe9f,
            0x1a751ed379b644eb9db48acf5335e88bd36c83f8b18af890b6a12680a930406d,
            0x1953a71c7b148efe7111d5a82719afc5026c8901627d52b99832ab71fb5d3bd9,
            0x2ab4410d63772d81c6bc2b97a2d695dd0cc827aa93dfd5836a2a0796e40edba3,
            0x1fdb6ef4b2e125c23699a1a32df3c1b22eda64ae445af2f909b4bc2991cca66c,
            0x19cf60a38e19669bb6d2401c48b35b418855f78983ee30d5e521eeb7d0015456,
            0x21952ad4fc7187ba8e43546f2ed64df5956bdea5b15a97e6a92f55f2fc4be909,
            0x13a58f9002e286128b64cf58167b249fb1563ae02a8f7ab3415e883384a5ae0b,
            0x2bbafe5162ff14b6e522e6f9a14f2c1fe997aa0482fa2deefa7b760d538f101f,
            0xb181f91666a320fb31fe4f9bb124ef52c0b59938f4142b40529679d080e96ac,
            0x82f2c930423e65b2180bf7268a826719f98f9014ba042bd329a72e5f50fee78,
            0x1ae6f189ba1b798740d4fd43994a1558d4fe53b282bb25b461ef9ab1275b4432,
            0x2edf3039eaaa1bad92e8417b2d5dee5215c1203bfd4c0b9266288e5da6bd7fa6,
            0x281236ec853c9e66b686e93e91f3494e5f4205bce0eaac369b4426babd9ca81a,
            0x54a6485057f7201bab7cce4ab2c4e1cb2062413edfcc6a28eaf5d0e2e97c49c,
            0x1531edbe0f8b0ccf6888776372dbe1e28779088db2e6870de997007f1573616b,
            0x2ea2b6fd70356ef5bb1e17019eb4283c8dcf60c64b72226a26c9fe0db7207c70,
            0xbccfa5eb9aec3b9ec035c1274a83bd2d84a16e3368e451586c89c35a1c8aa0a,
            0xbb260ac224835a44e0786e48a063739ee1f784a60f46b8dd7caaf69df639a0d,
            0x5b478a1bbe30115bb5551961f84b9a9edf54394a8386794c460490f8f7beac4,
            0x2547054f57ce31a826059e5191fc6ebf8601adfb1f12deec3dae11a0dcb56433,
            0x15846043831f7899f82beafd855725f483b31956506756ea124a023405a7d5e6,
            0xc14fc575b7f22b990c2a70b685c246a0c4e344010d8829a2c02536fba2b76b3,
            0x1ce79768298fa0270ec597b771241e980d436761abf0173e75e7340e111b17e,
            0x25bf1fb699ee8fa3ab420e355828d501f59bb8bda0036779a909621f1535ed03,
            0x1468d2232221175a2e4f469b31aa9f5aebe08ec2c1bb98ccaba61e69b99669b8,
            0x7e5ac5a4461eec6d6f8b61cc9693da958ade3c53859d6c0f2144fcefd550898,
            0x2e11faa403b6d60ae1f0526a91a26ab0389ae08f01939e8ffa760e2c6694431c,
            0x2e11faa403b6d60ae1f0526a91a26ab0389ae08f01939e8ffa760e2c6694431c,
            0x13a0c50ee1f33b0e3ef648dbd496742fbf6f2f3e3813b63eec02c5ea1d648f80,
            0x1331cdc937be49748107a798ce455915cf4281bea29f75326b389d8ac40dd8f3,
            0x83dd6a40bd2eae7f4a9ba32a23af4f2f7fdb5e20c147f763cb21afc8560adc7,
            0x14fc8b6e5b923fdd66b313dbc1992627ad8101abc9f69b51b15c714e68591062,
            0x691d453ac3cff9e212487329ad1e76ce7467ed8f5771c3939d799f8df9a1288,
        ]
            .span(),
        libra_evaluation: 0xa81a9d7b6392518d2591738f917869274fb97be563faefb3995ef71133cc081,
        gemini_masking_poly: G1Point256 { x: 0x0, y: 0x0 },
        gemini_masking_eval: 0x0,
        gemini_fold_comms: array![
            G1Point256 {
                x: 0x3148e77d1eeaa44583e01a62880f1ed2b1b28512a42c59dfb66278d43b48185,
                y: 0x1b5bc3a0ac4e7d47befc987005ac4c463d8c30734b05f588ee3a76ee1f4e26ca,
            },
            G1Point256 {
                x: 0x1f8a6f60c12eb3a78992123dacaa9da7c245a1fb67b65be4bb039bed7395dd10,
                y: 0xc6a8c3c05a787450907234d30bc5c4a9b4fddb27d07934d1bb93fe1ea6a8211,
            },
            G1Point256 {
                x: 0x2e1b18abc836169ade4758a28c7db84adc9e65c6931ef37e5891e5eb7c40b0d5,
                y: 0x374e9219c04c92544255870944f29e26c8f67adc6766160305fe8a9cec8e920,
            },
            G1Point256 {
                x: 0x1e62fe0fac1485638f072bb10c178de0e404dbe60023f17709f4864bc488795f,
                y: 0x1ace17b32a10dee5dfc4e5998722af978114bc8caa65352db4f72a856cb5a200,
            },
        ]
            .span(),
        gemini_a_evaluations: array![
            0x2e8b97291a0179be2b9757513910f4148a1bfe7c7a7fcf4b6d69cd5b7bd98308,
            0x2be3b6341ca011e0166ddc3cd7a517c58a7bf845b376f4cf7022404ce4cdd710,
            0x27aec07776dcada983eb05cbc932ebb67188655fbbb6e326a4e2b6d1bda99cb6,
            0x1b444c6348397b02336c6cbf5a7f0455b13047f25cfc7ef6962b0c587ed47bef,
            0x1b34be25748e75153b02343e45ce5b762003eb67e2e56664dd54ffeb74313921,
        ]
            .span(),
        libra_poly_evals: array![
            0x1c005431eed4458e144bbfea05e495cb547904e9d0ead09d9086170ad05ac730,
            0xd220a4ca80f5d3f0ea56ff8e26f860383a22627512785e10a1981bf47fc4395,
            0x153a07f27c7df64333dc5c8bb1fe62c56797adae5db68a13dc2a0e1abd138f06,
            0x235c800ed2ab59355f0e3a1b704f1cba323fe7aa6d05ea02f411871fb51a945d,
        ]
            .span(),
        shplonk_q: G1Point256 {
            x: 0x2c5d859ff746c220c59b2bf704158c1d8eccad07e6eb2a4c35895378160270af,
            y: 0x46cfe3cdb8272add8a07c9638b433cf313e93610950dc5eb2c4805d0b96675a,
        },
        kzg_quotient: G1Point256 {
            x: 0x1e77c6bbdfa7c0ad56e4afa70ed7ed62120fc2e1b34af215cf5a76999acb3a83,
            y: 0x1d89c1dc83491c6e8673d62732ea8cd57669b3d442f934005e87d36e4c38b1e6,
        },
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
//     use garaga::utils::noir::keccak_transcript::{HonkTranscriptTrait};
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


