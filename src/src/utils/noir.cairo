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
            x: 0x254db74cb3a28d4c2310148b02d16cbb43434d8f11b85cfb249e299d454bfa74,
            y: 0x4dfae6cd90eea581abb0c1e72873f97a4a0faa375d281f978768119e1ea1137,
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
            x: 0x1cc59ff05218c67a28aaeab3e23a98f3ae14176f185a5fd77500193e92ea750b,
            y: 0x2016a4e5f43f6096a08658882d7c279e53902857456c5a989321fbdd57b360e8,
        },
        sumcheck_univariates: array![
            0x7a0ce1894df0f9659c951521b82c7349496281e9b6f4f17826274a527890989,
            0x28c3805a4c5290935e86f46465fe9128939dc029de4a2179c17f80eec876f678,
            0x17aef74996586c5ef3529af6fbf27128d93f155fc3e0fbbbd43f163dc80db204,
            0x18eab0759843708122c252fa81f69de6122f76b7d69e8e5ba37165c7293846a,
            0x1ce93ac226f04ce306b5ab79f193d00cf5c1a167da1b6c9e5ebb9e687ce3ec86,
            0x141c666646fbdce4f02812ef0a9490ae3c1d65667f7b813b908b8bcc272aa8df,
            0x1b0ce879be155b0b1ed37e0e1b4431c55b9ff928866914182bde3ef596bb05b7,
            0x18985d9d92e277b59f366d394b6dff01464026a7741ca5686d0d61d19703700c,
            0x276b8d7992463ad7ecdd663008f3a14bf8152df5f57aa1014d81534d5586a2c1,
            0x1e7601ec0ecc7ae970a3b1c5b4b3fa4013b7f11be408136964cd935374d4ff73,
            0x25e6b2ff0e1831fb350ccd0ea80ab3e6b1dec30c5e7d0df50f603e0374dcd662,
            0x1493d5423a3145169b7766b39452fa3b25f0b9a4d6c7752174df8dded3c4a131,
            0x1a182743209e696c508a65ee2303dc3e7462088d92cb8bb7ec72cfe24c8dcdd3,
            0x122a75c8a98851e45e21c7245d2619d3b167ef01bd8087cfd64d7c5d5150e48a,
            0x55a671d65bd76dc793a217b70b20d4ffd0109f8fec6c932a870e2203f729c3d,
            0x23abcb5ec8d7d69d110861f746499577b27ee0265272bc06cbb2c1cdddd1dd1c,
            0x182736757b688190c02cd198328b1ec8f71802e95f0a86df9b3d048cc36bd919,
            0xc4725580aea314f81885ec94e0431878fe931dfde7494dcabc6f015049803c2,
            0x1838f239b068653fa1c0bfb4e4b7da84164c38b211bef68f835cd2de7b3492a3,
            0xa28c81ec57b75d3e0f72cd023f73ba763c38b3e2f3ac63a85937de0a1a230c2,
            0xa57b1485619175c4ea0549faf4c1ed3ea0243ec04e8e653b95fba9bbf7569a0,
            0x2842ff76a121e39ca63ffabe8a33795be17fb9dfe159c287bb23f35bbeb0990c,
            0x1e10f9fa515578d95ce203fa52401e8088f55d0b91bee1fabcdbc65af20d0a6a,
            0xbd40b5ff373af024092065ecfab026f1696793f5c140d0ca3ed5a148c534772,
            0xc14b68be2f41ed3dc35a92ee4ad1f23f6b9921b1293574d0f020353ca108381,
            0x2b00f7a150e922ee1b79ac35847a0cb2d21e625546a3a652871a78f3eda8fca1,
            0xbc09bf17c55dbdca4989561d9c8efd0f136c8e7cae8acc40bcd21be0a6fcb0a,
            0x29004a908835258d2a2cdd75a5aef3df36f7e4e7f2bb59f084c28055ba1ab29c,
            0x16ec5836b887e94f523525dd53258c143d0ad7f148260cdc80157ea3004c982e,
            0x2a8a8bbc46757e558d98fd26cb88f200b758929e293c409a16baab87b2d259b2,
            0x12fdda2cca47ad16e3303ee06e46f16a8abc21766c3ef00fc9292dba617eae47,
            0x10754be89f131a7547b53a4358e65c694cf0b2d24e48e23448c0331cdda50e57,
            0x502e47ee5f6eef6376f1f2f9732b0228e1037288f038d2dc8874aeb123b5d4,
            0x296fcc4256962cbd2366cd05e2ba842b0dab3a8121c9b26f69120c9aa3bf4036,
            0x29688e95bcf2a65527965e6df38e2b9675dceea4a86e766e4c36913b34f1ae2d,
            0x149a9863f9e7a1f6083f21c266780cec7c88efc3d2a89c5bfd5158b76cd4a494,
            0x5332e62eadda7b04c2878e57432f9be9073e803a155598dd19bd8e8133fb0d0,
            0x2b9fee6ab970f5a2993b83b7810f614850b16b889c3f35ff98ca7c9516b052e8,
            0x2583afb801e5900937bffc383f22e324fd4cc63af014e472fbe24dc4c11b51c2,
            0xe02c9fa8f2e371a9a7b0961496e81306e9615203d55aca901de3826267a6c1d,
        ]
            .span(),
        sumcheck_evaluations: array![
            0x1c0d2eefee2a1f2eab37450daf101aa0c4f83ea5773e26357112358455a07197,
            0x28b593919f02fb651581c59968211cbe17ee2dc90af6e66d16ac5a06d2039755,
            0x1f0524fb608de8c33e9cb16257139fc8bf96ced93516ccc9aaeb5c2ddac84316,
            0x22e620f18f239631113f06d34dd807661aa7504b4f1be0a90b905092652e1784,
            0x2c0555cfa9d8121b02184fd0487b7a5f68d5ccc9352fa92eb53170042168d647,
            0x2d5f97b5daac4629210f0b24a3629ecf290400101cb8367ab145fd73d9ed062e,
            0xc15ef3f115fc1ccdf41f9ae1a8e1d3416fe18291e11f7bd7f731b90d8276c77,
            0x2b1735af2893ec20a2932d419a9e9ed10a695864948e477686130e81a1eda01a,
            0x1066b468e6f7445b4631a49fd252b88558981e275dc237bd108f491e58f1d532,
            0x2c30961af112a1c54e9e162375168150a4d77d44513fcefd3d092c2b9002d085,
            0x2fdb942190c007a509cd3b5722679d7db31a5f107725c6cc557c543d6d19f515,
            0xb51e6a2df3e8466356170ebbc1f9bd98b80b851f5fc726990123fffa09668cd,
            0x146373802056ccfc88045114df35971b2bba3b9fe26b34be222f6cfbd8de5574,
            0x2b8d6fadccb8b7115d2cdbbfe9eb2c75c82e485f1b0bc6369388ed1117112730,
            0x5d22099001059478398d1054561417a039101cdee78a30c29c94e95af3e16a0,
            0x8dd6523def7db40164800ca5855155e9e1fc359948c7bfdd7eebcd035ca18c7,
            0x83534153de305c685683051934444f4bf860a543d0811487e40a225ba689459,
            0x119409e80efc17087c9834838d1bc364e685954b015a66cef66d42418478749,
            0x1bc5bfb0c8b04af18c1cf0f45f58ddf0f70f81d3d82f20417ea8514cb26a71a3,
            0x1a25139530f53bce833a62369457789589032ac5578d0528862331246deb60d7,
            0x6be431619cbcf9531d68eadb5bb5558ad3ea8375ca4771a0253f97ce28c71e2,
            0x1ec54d00901a031b4cb1cf733c87bbc3f079fab2140f23241135dbbd7dfcb893,
            0x1859db9199ff96b48c4acd9bba70f0edfa8d294e798e11313786525401f207df,
            0x20717294e61358da7896b1002e5c1192586b5f8b174af18e62f9683ff1042509,
            0x12fdebc1840017dd447da3949a199c4efc8ef0447ccba82a44226b5cf983e6a5,
            0x215376ee9eb7f1ecb6e72202bfd263a9b2e7b49c022bf877bb11f139d216ca3,
            0x65a8cc37ccf8b239bc809e641a51cba609aaea45a1977843bd9e5ce7adde098,
            0x1f2e49132dacb61f6438a058d8374371ac48b0862d7e8639e8ad313d05bf0d97,
            0x2c72bd56598dc7e7d541f7795120c9b2693caf5f2173374d648f7ebe9392798f,
            0x19800d02116250b5762887f1d6ec631d5061693dedc3a28ba3ffca03aef9b58f,
            0x229cea2f7d15bd40f5e62be867c136f1f41190d632d474d37eccd1d792fa7414,
            0x25511e27a3dd80948b2aa812ddb58ff2aebf052ef3cd929f97f94539025f693,
            0x2b0b30b07a5b00b5fca3b1c5ccdc9858172bfb1a37d77087336ca2aa36127131,
            0x1cb8d434d15924c34282c381f376ceebb9eb44cdbe17d893c636d7e3d0893199,
            0x1cb8d434d15924c34282c381f376ceebb9eb44cdbe17d893c636d7e3d0893199,
            0x24a24f23a714dda10835b33d3b5a6e5dc3e4597548a8de164f77940a27fee689,
            0x1f4f699f35da63eacfc585f1635e8d92e1737ed8261114643d9aa15f7a0d1a01,
            0x2e665fd19bbd40bc0e6c7b1e2d6103b33c1401a4dd3a8fedd5c92e2b65a80777,
            0x49dacb8cb6651fbe4fab1c42d3de5ad3675f9a8f3dfe7e9c5e2d97c5f1f2236,
            0xd77dd25e781470b8dd2a8ed16ad551540a0ef5c719531fafbda316810844987,
        ]
            .span(),
        gemini_fold_comms: array![
            G1Point256 {
                x: 0x19e3ffc67e37c992f75143e7d4e0febf1ec319c5662e19d1f79e9e1d00106622,
                y: 0x114fa01364edcd414c673c1a52f33aba69ab4a22e3d3224f0c9de2366753acb8,
            },
            G1Point256 {
                x: 0x189954b985fa1faf56d9876e0ca5a9e1d41b131672484fde29bac990fa28bbe7,
                y: 0x13123cb5fbec3efc531aec5ea4846a0207186119c34dec8ec8b57fba623ed7a5,
            },
            G1Point256 {
                x: 0x5f7d094f68f5057895118fcbc5ff78f2b3cf4febb0f8a75e798c0d9a3e0604b,
                y: 0x2c25a672074dba804e2f041e40dbfc1173fa34a5c8b1092b5eed56719b18f691,
            },
            G1Point256 {
                x: 0x8b3b93a50b0d94d26029ae5f81b55d1583e789a6f83cb71a665e760d6e61862,
                y: 0x244df039eb8db764d44d10ead949d4e90de602f2cc4a6e62c6a3e6232594733a,
            },
        ]
            .span(),
        gemini_a_evaluations: array![
            0x2e8d09be1f33c65acdbcb0892d4f7398d499be187439817959826fafc62485a6,
            0x172dcbcb886511029df61f1727497cbe066ae9b0f7e51c7fa8344f16f202a31c,
            0x3a691cd2a6323e72d86d37276df9c4e91299ceaa5caf8b048e9d174fdcbd8d,
            0x128bde507f0c1f5aeb0b0ebc6d3fa163d22173d55aa0b0fa029f47470716eb1b,
            0x2ddfc789c9d15eb2a36441a02b87f8828fec09081f9144128a978c7ab6602b63,
        ]
            .span(),
        shplonk_q: G1Point256 {
            x: 0x2f69ef96c61fc09a26d2081acc12bae873f73c06fb7992f297e6698c91122f51,
            y: 0x1514e27d18ef006a18854ca070addfeca49efd011cc66b2757526e1422974e34,
        },
        kzg_quotient: G1Point256 {
            x: 0x26a7d7c75a2463fc8585d992dbde668e4d45ba4b082b4a6614ab1af4f1e563e,
            y: 0x13af611b8065f17a3e653062d2159ad7d4830f8eccc178ae2d3289fc4d137206,
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
                x: 0x1ff309ea5a7d9cb3a9cffda48267c17e93b87cafefed34a50fa5bdae48ccc7ef,
                y: 0x2c7e37eb8eacbd63774a3e59ed0c2fb741b3231998347b9ea38a8eb59ba400f1,
            },
            G1Point256 {
                x: 0x2e08731fbab56c0d2db9629667d8dde24aaa5c369d0d56228724a2354ca77748,
                y: 0xbcca083e19a9b30dd698507994b99782f1daff4e43a933514207377266cefda,
            },
            G1Point256 {
                x: 0x39be9a9e1d0f2a43f3951f9708e66ca029b3635bf7d7686ed2d73eb338f1115,
                y: 0x2b2e21de0c8ed3ac69e568e3efe711d612fd02e1bfcbc25bef17d0c4fea14c01,
            },
        ]
            .span(),
        libra_sum: 0x116f90bb9300bb6161430de43b41ba25ae3e55a2ff84036abdef44477394d962,
        sumcheck_univariates: array![
            0x250da3a9ada01ba231769fbae090168d985133ecfb223b588547251b6934de5c,
            0x56144097d10d30f1572bc1b51922fe4770afe7c169369b8723a15e23471d1de,
            0x10115c4396e600471a5b1727a92152bf9b4c0161ab0190bd6759be8d02e7d3cb,
            0x101245ec6e62f4c8caa99805599220b6e51e7a2bccab5fe6caab74166fc29896,
            0x1c825b741fb98aff4bd0e987a5ae4e40704b2dd72c12ff5b553548605a64fe97,
            0x2d644764f8aaaf5cdfbf8269686151df895efa090d7520f80a670f96df83ada5,
            0x2984798337d2cc1edb5a398bf2a742b34c59fd83c86bb22301f8461a5ecb34ef,
            0xef9d2e17fb969ccc9b98481ffeac1f7f49c28ef97291ea7d7eeae70a7648b02,
            0x2f652a90d1d571f71b2b33925561cb2ba2dc32cdff4e8ffcd9ea22dbb9b7450c,
            0x1ba29ea76e189d644080368b4d17bf9bfda71470b12beaa8cb10a48d5743e4f4,
            0x8c6999ebaf1b76fc6f11b6a0d3e0095d1231826c4d614f6e4c30bfea75823c4,
            0x1c7e593d6f597aed120621864f4fddb1411e760764df0cc1734e8fa2883bfa32,
            0x9e0e62eeda3a539e808fa2ea8aeb6b02ca25b9ac6890f6b66dbc2279eed90f0,
            0xc3ba617d273a3d9e4138bd23aa264cbd9dded4545d6785cbe85eacbaba1e3e8,
            0x161305bce991bf3737a1f6ab9c20d021e023ffbc1e940703d1fe5811dc65f93f,
            0x27dac067682227270b021e0e93e3aaeb91eaf7add1d4af9d562abd962ac52f77,
            0x15957422afc186a20d1f1ff85932675c631bf2dd0bf3c7cdf95b0e03c0ac1f9e,
            0xa130dd87a4fd1db70bf8211c8687369656dfe391be3f0ba35d0325df2b5c574,
            0x2d5efcaec6c4d5b3fbde4367eb1938dff977e73c4e86d87d2707c356c94d7311,
            0x283632d50313962906b2802b4f6f34211c394bab2078600041b651f4b35c83f,
            0xec07eaa1be6b9b8bef1b9c61c80b11c27c6d4149bb51d60aee88c59ca0cabc,
            0x2e966983547f1f21d3abdbe1517dff1ef944f8231da8adad32f8244d40b2d0cb,
            0x2cdf3d6dcc4b7fcd03814bd03ffc6570e30186a224d6af3d03aa0b245b1088c0,
            0x2c7bfd370a6e8a584f378b4b450182081f534ca2a2f70b5fc155f361558f94d1,
            0x20f562975bcafc4cdf90ac5c9b4f8e5009c261e401a49d8cc6431cfda01bf07f,
            0xa97a070dc00cf1ae6c19d733c9f225b77eab9972e4455e9d1f1662e426d94c6,
            0x2ec3b23c0c633a7e88644dab4b4b3761c3cc5a86e8c9f442df55d5e6e3a285ae,
            0xbe6ae25ff74561aba57a53c9c7b7cc585b374eaac11b4ed72826268cad7eda5,
            0x80b6a9d0b9baf6b5f77340057f1e38843eaef12887a72bf5be6511de4fd14a1,
            0x9a0ebaa32c587b0b6b8e5ef82077d28a940999fec1e532cb8d005cbe62f979,
            0x13e93c23c3844efb5821ba1c09d5942d52ed56727b2855a5cc1c2ca900420421,
            0x1fd431c20da9f39832fda0535cfcbaf8963f091462114b1690cffb3901bbb4c8,
            0x29cbc52f2134d83b05ae34345a3b99902c43fb16d14e19d2a3b9ad9b53638e52,
            0x4c3c092ea6e2b3f22e43fcf7790d61836eb6182e09a4dc7d41da8730e762a02,
            0xa5a451904f2bc9869d4d8b4d351af702d6405e323b682e586fc963da104d843,
            0x111884bd92519673e18809aee4fc348c94de2aa1f3f55468cf510268dd248d88,
            0xffaf6f1b5a3505f186e3f998ad95e33c9761e6e954ab237b261e9244e4dc3e8,
            0x12eb1fbb72fd6d581100c310223dee0eb3d70daaaf0e19202129467c1a8f99e6,
            0x2dec7eca2678006114e86e646e18ffe5f778592c0bb3d4dc34800e0473627f3a,
            0x2179dddcd70880d4646ed17aa5e52d3ea42eb350a8be53d59de9a70136cc4e10,
            0x2552419e3fe579418ecb4b5d58f8e0237df2963a2de716d497a9daeb923f31c4,
            0x24252ff4cc58d2e90db9ebe292ebcee1ab3345228b97ef6e231ea44f1d9359cd,
            0x16a80dc729c7b9e9c36451a62420b22f0dc0891c45fcea1787f0b7ec8120d15,
            0x819478c1b57a687cb35a256e9825fa8e9bcb6193c5369dd74ed78da9e2f6dda,
            0x8adf62bbf3e2d13797c39bfb14489f25e5a72a0b0dc65c0bc42ea5a2bf94089,
        ]
            .span(),
        sumcheck_evaluations: array![
            0x1d075af2a3ba77a88eef63de181d5430527e86ed2f58e037347d1df69af5b4ea,
            0x2b9e0b095b5bab0104b1edfce83e07528f15910f22eff26839fd132c399af9aa,
            0x278787c6d8c2e50233edef1b53b71c2a28ab3b616fdcf0ab30e36f73fb9d4477,
            0x2495f8c17c8cd4914964a0c37b6d794c391b20a94f6dd7be6073779b02e865ea,
            0x27cdc4ab7fa2389f9fef1ef5abe48a377854db3be76e83cde8a51e97c13cec2c,
            0x26a69c2fa29d868aa4ff954a0d83acf4fcbc80d2909f68414d8c7ecd3a3abd9e,
            0x23300fc19509b3ebe9f4d700836d960a0b63cd87e844450fd42363d8ad19faf1,
            0x15f106ecfbd2ce031879e34aaab5c6c8c80165b02c783df9f9e6ca7f8f327147,
            0x243f25cf7d9650489ef15fca23325547a1ff0cd9b9b7b5c4f6f4897520e08247,
            0x2ea6bf2a01685112546eaea7ec0dfa3094f3643006eea84a2e4c76d4816873b4,
            0x212534c9c6720c500307a4ff732b2b8251cf25af5e2e5908854012873b2cee75,
            0x28c77f0b7d1d6c0b974fe7ccb4df979809a014529a74645a25bb0252800179e9,
            0x2dac103d7f589de258e79b1da4486b45907732c217ffecba632a6d7274585a90,
            0x1a6708e0b0046462484fa921f1756dfffe1903f01fecc4d744e46cd3130a412d,
            0x24de6be49636414194b6db00a1a320b80b2f164d29bb623c592a0f39ca697f16,
            0x33f880f6621e2e45c7a9978b9ebf6c14b3c27172fc3aa4d8c35204765e33310,
            0x6c72ab8dede55d4b52d8c1dfbc7f4d47db94c0ddb3aae02679de67bcfc8c496,
            0x6d776b5fdb52e096d067e633c148b3de7fc1fdd5b53ffb54b190318ef501629,
            0x2c0226972e8e17f1b5e840b4bde893af9d90c5b4546472123c01641afb688176,
            0x63b7ca4f1fac92f4bb0cade54897de3de4e324aa67a4c53aa94a356eaf841e8,
            0x2b48c8e067161ac85e5045a43c5c87cf9f3b7b52a0e15cea0abfdb8929282b74,
            0x1d05d5ec81c3c7c81dd37efaaef680882db9adeaedda35242fb968e94d27bd21,
            0x1f183e38147503bac649dfbdca45da41e2a488414526e04b00b15f03824e162,
            0x22b3271fb7ede86cbf1265e49a344ba3d384ec1cdeb8be8bc00c2fec8e39330e,
            0x2c09b5b510f409be223342860025fa7ef4b9c64c7b24a888cb0bb64d149d73a3,
            0x2bb6c9f704dac8b05b9902004a02aeb268e3a425844b93efce5ce606fb8e074f,
            0x15a6d7367532c4c4addca101a5ba7f6a972d1e5058558a594f7a57347cea77b6,
            0x1cc20b57a27cd6f73eee3ad82d968516152a921343966f15bfd255f2f9904e6e,
            0x2c083e5d3d8f3d7b5809d783a85763dc6b7cf935d5ddc06a153bbc9492fd5b4e,
            0x2bd958adf1ace3c961404f1a719777f802c21079f7a1cb930544d2dfe6a7b15b,
            0xed4117c24add112e04d2e708abd1fcfaf4c74cf2a6babcb07fbad2aad7a7e2c,
            0x231b83f279647dd2a8c6ad69b274b4eb21bbb565f1a6099e3fe4b2fff4d52a1a,
            0x2cce18de1a85feab02c8150c34fa61a8697cb1d10b6218bece07361f2bea64dd,
            0xa880daae2d6b7c5c4c5c4bcb2412bc9ce095590a69d5ac80b47ecec66e7f537,
            0xa880daae2d6b7c5c4c5c4bcb2412bc9ce095590a69d5ac80b47ecec66e7f537,
            0xfc40a0706a059fe04aced2d55141b5d1795ca63d874a03206e2741968085958,
            0xabb09e8feec992fb7490447d7f6fa5e01538f696f93fafb94c69f15d202ae6a,
            0x278209cafa00def36bb03560a8cd6de7551f8d1cf5a33dda04d561ec03843abf,
            0x1b7f84de503739d8f392be9d61e22da286d1b9ea6fbbfe0f6a1eac6978d9e44d,
            0xefed76889e5bbb84cb804de2efcdad3c7c7feb1fbeb23707d213e6ac3fb0c40,
        ]
            .span(),
        libra_evaluation: 0x3fc7cc1a93fa44b131e06e95b184e81a824921534ef0b1fbdda17e797b963e0,
        gemini_masking_poly: G1Point256 { x: 0x0, y: 0x0 },
        gemini_masking_eval: 0x0,
        gemini_fold_comms: array![
            G1Point256 {
                x: 0x2c980c3e37cad4bc3a0c92f9a2a0f1ba8393d0e01f2548c419b82f9c1c7b382b,
                y: 0x26191f3377eb0b1c1eff18df8cc7def9a8e68add577d00ac1bf816061b420f4d,
            },
            G1Point256 {
                x: 0x205f353379a60b94b91f5a2c589ceb1395ec42195fa333d44a55f4f8f561858,
                y: 0x17db85306479b99d3364f3492b1b8b8f430c0a9881f674245355d6b14d1cd21c,
            },
            G1Point256 {
                x: 0x3b0ddef4d8c919eceeccf7dfdcc67e72c5d5b0daa38e94393cc2b6b257e0787,
                y: 0xbdebe606717ed344168d48c2511af3a3eac66f77ce97060a4f8fce2defe6368,
            },
            G1Point256 {
                x: 0x76f0518d1a4248e89af737b3800a697eefda1cb0d03195604a53219e588093f,
                y: 0x6242f43a162a742c57afb0168d3dbbf1514c0017197d229103bb0ac80c340b8,
            },
        ]
            .span(),
        gemini_a_evaluations: array![
            0x967a810372f9a538f9d3d17f66d6aef79846421b99ed4bdf1a3c2bae2b7c0b0,
            0x21bd7c8f0ec228bc77c5a8aa2397c2a3822d295ac8e32898d12ac580e0932ba6,
            0x53179ab561420aef27cae2d96575deaf92e0939f59ba91b5a38f56751809b30,
            0x7bbf21329ef73c6e2b0a0685e3a054ad6089355ba5ab036deb56ad67e53eb91,
            0x24292f7c1068e8c5cf2e0761ce03f0ce6696d01ba4aa7516e793b93f0f5e2ae7,
        ]
            .span(),
        libra_poly_evals: array![
            0xb093b375610d19c576da0f041c0a5c52f9df74e8162097882f116a9c634fe15,
            0x2fab43542eb9ab2315896a765e8b0d87c9947dd1c0d2e805037b328d6d895b62,
            0xd8ecac621d103b96d7d48995b788bcdfadcac4494896d06564be256bd940d69,
            0x195a88e6c843fd3f91693ec3e4740c9037bf785187612796ec3b1fc4dd70dd9f,
        ]
            .span(),
        shplonk_q: G1Point256 {
            x: 0x300b4aeca358aaa67f82b79f4fcd5f3f5357f17d4d1aa6df9f02bb1460f5a936,
            y: 0x1dc5999c009c4a0c9af8ecbeaa9c290d42a2efaaf936e1dae563b5437905757b,
        },
        kzg_quotient: G1Point256 {
            x: 0x10214c4c1248062f77cb411ef1acb17d8c7e56b5032a203b725b5d65dbb587dd,
            y: 0x33b10d27ed7dab7406d1ead2ae8aca8f27dc65da20c3a98b91c54ad5334408e,
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
            x: 0x254db74cb3a28d4c2310148b02d16cbb43434d8f11b85cfb249e299d454bfa74,
            y: 0x4dfae6cd90eea581abb0c1e72873f97a4a0faa375d281f978768119e1ea1137,
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
            x: 0x1cc59ff05218c67a28aaeab3e23a98f3ae14176f185a5fd77500193e92ea750b,
            y: 0x2016a4e5f43f6096a08658882d7c279e53902857456c5a989321fbdd57b360e8,
        },
        libra_commitments: array![
            G1Point256 {
                x: 0x8f0a4a3a1cb9d3afa72d9e8732d90828b9254e38321112817e8befe32edc301,
                y: 0x284010beb1bdf67650ddaf48ddf6e7241849d2bdbdd89dc38a6f59c5fcfce642,
            },
            G1Point256 {
                x: 0x2debe0afacc6240f122861c497491b765e5bc4dc38958f7e79552de38ef51d0b,
                y: 0x2e4bbb92855bceb182dcb16785cdc34ef2fbece4b1ab0304d732f56d63a43be8,
            },
            G1Point256 {
                x: 0x153c649be3f3ad7fd8d1e044724a1a22cdf947b0f93a2fcdfb26080e92b855ec,
                y: 0x26457475a61e73a263e713c6505d8aff9bbd3d23c2d6ecc41cf0e1b6140635f6,
            },
        ]
            .span(),
        libra_sum: 0x171d473fac94c41dcd9a6c87a34b3ef128c5d7c44c8eaafd098eb5602dd3d3f8,
        sumcheck_univariates: array![
            0xe8e22efdededa2d0d009c49dd8710c26d10807be9776baf7dc436862c82f7d9,
            0x24ff6a3f02f7f9177b7be05fff5c7b144f0b0c98337ee10015a8d15cdd8d070,
            0xc5cb5f23d25a75f188b798941b1464dfed5ccf04f4ee405da5bdbdc55b2f516,
            0x2ec6c3e5e24c41abacc6bdeb6d7390b2ca103c839e72b6ea9b20d42d840f840b,
            0x2f9f750801abe7aa3a63a9bf234be79789e990a818ddd4757555a48286ea6bb6,
            0x1e3dd6816bba1f6299c4f517127627ca220f08c349ed02ff55ac9e8527505629,
            0x75d4b37bb974fab0a804ff9d66107cd009be927e9dc02fbfbb577d84778852d,
            0x26f8df2177183e4f1854ff18ee3a6c4abe22a81882594aff22d6eeeded54e44b,
            0x29500d0ec89944f68b1959734d6401f1050b529590bde33d7f4e913b99baea4a,
            0x4dd59cd4c976c1351a89c9090cf7dd1d8032c06314e038c4989b9aa278dd4bc,
            0x14b4077bc83e25cb8cc34da374524347a46b7275055d793f4ef3ca06a6a33ffa,
            0x12b659531454e5ad34ec5913d320df7c3521a3001c647941dc8a6194f2c05df7,
            0x7943fe9e3549a0b4ffc7d4ea4d7b50d03d12714482dbf7c1c611f6700e2765d,
            0x2be1e53a427edaf5ef6f689da283f5cd6135bc86f21ca31ede36f6915402dba,
            0x119be619f49cb3a39906da196b2d75210fdefc8a3044d32751c68586b4040c14,
            0xe355b2c91076db6e55361bbccd66fd2d556d41706a0ca88dda28ca62141916c,
            0x7ec0f6c438aa4ab21a716e66d365a3ee565e53f02f2a5140fd7587fb80856d7,
            0x2a8da328ee480bc5664f78e34bc0affe1530c5cd2def97401e009eb314ddf50c,
            0x28d6e33732ed7dc72e8e0ea89e55b1cb65a0179158a8b94a1a697068dc056188,
            0x1d0550290d598236b9b1922d6c0aade88e6c302d6edd21331cfa264d549ff30b,
            0x7f3788d02988c368ad9e5132263f72d860104629afe83fc757f37597019f54,
            0x2ceeccfb3353231df691b63507bf2adc588d549095cb29653acebf085cfe17b,
            0x105b149cb633cc666563fcd18d31a7fed81c7272ac1fe80fe52cbf63d67f5381,
            0x24487e49abb79d05f886611fcd394a488c1c6d326345b0351cc40bc1293d8fbc,
            0x29251ec46358c98e6543b760721f87423c1d8fdb44738eab1f94d7e3a89dbce0,
            0x1140a1fc8ed0ff2f25f27da15cd6951a52bd67cab56526237fd26f008051776d,
            0x132c345be2341e10e68d194ff52b2da34e740fe33c1de616760230ef61b8ae04,
            0x2eea648063c8aa670f0e830bc21ce5a87aaabd3c1773aebcf162250bcba33d39,
            0x25e0fabd20aaea96f89543e0e6b5f0a1c386c4003a455af4b6bad05081141c51,
            0x2b8e4ae58014443bd8e8c1809911807e9e149e64c4cacb5476ffe23bb369369b,
            0xf1c820dee7280c5a8f5068ddc2dd15c2acfe3c617efabcd3e7e00d35c69852,
            0x1e86f47cee10749c580603801304f0f1edbbd9c2dbe5acd5d48a28982bd30c0f,
            0x4d983872db532a21e7bfb8177213fcc8d655376c5616261b4c2251a7da25b00,
            0x26a1aa9916601b5f77ee7af2a5f8abcb3cf06318e7a47d570e32f531d2514cb0,
            0x19c94af9fbda3ee7b548d5161554d66f52ed158043f535dc74d624b2b0975a1e,
            0x1ca790bd90d9ef0ccda1c119a820915e100255ec90e09c39b46a61129fe6c46f,
            0x27f633a37a3e15dbb045692b17ac6fc8a543fcaa435b2a9e5fb99abf3b55c3e5,
            0x114a08f24f174254eef1eeefc4de4d2301bc402f96b0838669e7613045b8ef69,
            0x2827ddb4fe5f15d3f1ec8e43dabb8d1ae6055f44d508ba70bbc6a9a4dd524917,
            0xb9ca8faaa6fc854dbdc868a7017efd693d6a6b845e3efea3299c50e7575814b,
            0x2b06554139f424a37de1e8562e64088c6e99bccf6bd933d4de23fd51efe08d36,
            0x2f31896f71e7d384d9953fb4235320873db521700e772fcecbeb764f52238a3a,
            0x80368be11403566282d51b4fb5262991dde67a25335e93d6584e6a9da801aa2,
            0x30619e84545da0a57ef92a3aa60b386f14faffac7773b7b7e971dfa34444b96a,
            0x293b90c4c3bafb64aea46066f197019c80e1a0adec69ecdda4512f7f08481856,
        ]
            .span(),
        sumcheck_evaluations: array![
            0xa57db3e4fbf92bcae64f1daca3d36c43e3bedb4581fb6ddbf95e475c2e9df46,
            0x300964c78d43654e5ac0f34fc1547babbc775d45ddf55dbd9955196428962c0b,
            0x1ef02c919c33707450a947e478de11aa9835a26cf62c2a340daee9723fd1b2b1,
            0x1df65e41dbca6442639e00e0d1c63c909aa6b2151bdc004c6062b0c527fe5bd7,
            0x2230e506216c243860337567f2593db463d41672c2fd1b5e48288c6f4b73c935,
            0x10c51f19b421fbbcd266243a6cd9f22e789e54338a8dff33f583d06b1fd712d5,
            0x2101a6b74c021f2e815a808a5bd46033e96202e22c4174448fc8db47ddb17922,
            0x1be8e2c74444306ea67c0015be7eb9e8d73abaec8e7c2e3bb265eef186951028,
            0x12294bbf81a380e28fd42aa8bf74741aef7c8acee6b592594789bda2f0b5683a,
            0x21b8de72f3c5402a54bb8476ec33834bad35164900268fc8e38058b3557ccf05,
            0x24949a4c873ab8ffcf044238fb8b8e439bfc0157a5ac1ffcb11a3e7389699c40,
            0x1df0b3614148806a49ad753b7916d650b819338231c8ce0436136778349e2bde,
            0x28145a44e758da5b9bd287513c564e19b7bea43d57cc6781aee6be3ce3c41498,
            0x1f0abc6c6bbf3c3ddfc340eb11e48621788855816a80647f497595fd00814f8e,
            0x58af58a3d6456e26c8e6c3a99ad04d5c8e7296cb7ccc4415103da09a232ba27,
            0x2a3d4d463d99759da34815029b9729f51386e1ac96fc4cdb10c837d25667391a,
            0x1aeb18d6e2fe18584f598719a3b6c8dbfaeea40a08376cc87aba48b86bcd6aa5,
            0x3cf572dffe302d4dc1037a56e3f831174350f6c3b91ea62e61e69f1538b1f4c,
            0xde50dfc5ff3edf6dbd75194d0a9934c37bca40698d09709e0ce59b59f3dd83,
            0x139d0daccd5b55bdcdef372f1ce4eb3a83be01d0a319c5983f4a7d9b70e68d28,
            0x2aaedaa932e340bafaccbf0eef838287079d1d9ddbdda28daf34e2b2862ab9ce,
            0x1102aa6a9a118854d2618789755688137195fb71fc466d59868dad49cf98a687,
            0x290fcfadcf858213f44fe39dcb968aeabfa5cccc546c1cfc1545f7647ec1015b,
            0x1d7eff3e3e4bca957a978633106cb84cdebb56c0665473210c8558e890381b51,
            0x2f07b20e707b62d4d606dacfaf5bd866bb36aa811584d9b52f6ad5b71a74a60e,
            0x34475733cf4544751ff4c054740832050e9eff3d7087bbdb309ea9b598ace1f,
            0x2e20a37e71f23f7aad19d146996fc90bddd07412bdf0584e6defdb79ae767e1e,
            0x81e88139a3e700d853f04797e61593187b3e0c567a0fbcff05871aca8820bae,
            0x19bff3637ac03e0629cc055f1e8125c79ce625ebfa006c891aa96b4ca4a6d02f,
            0x23299bc5a10d8b00aced634d212dd82a5642a1ea3ace92a4d11b2d54e41ab61c,
            0x29f95c71b3a2f8dea0a8d11cfff683cf63edfeec5184a1c6ed4dbcd1990cd312,
            0x1a56558939318d86635f49df24bac4dc2865888272892409881b6cde9814b4f0,
            0xc59bd91fcb1d76928297d09677fa3628848ef15804eb1958dd2f975101c1fb8,
            0x6deeaa7ae195ddb941c6e35d93d4d365bd1b659916f019dcd1d6af5334d3826,
            0x6deeaa7ae195ddb941c6e35d93d4d365bd1b659916f019dcd1d6af5334d3826,
            0x2066f74af7420404efe35497bdb205d01c3729fd262f7b75f7fa55aae2132ef5,
            0x12bbaec264e7674ec53c3db23491dea296a6534f6413710c6ce08fa18d250c66,
            0x105a844e0c1e928a8dabfa891a9a1351ed5dc23bba0bebaefcad303c708f0def,
            0x11b80635c698ed194b55512edd6d1474a7f85047d6d0c2eeb4b7208bd028e6a6,
            0x252f7c74c279309287d91945591c22a6997fd3499603482e505ed5af75eeccc9,
        ]
            .span(),
        libra_evaluation: 0xb4c2704cd5b0bd0280c9bb6eaa8c23f6f488af13511004ebda566cc22e101b4,
        gemini_masking_poly: G1Point256 { x: 0x0, y: 0x0 },
        gemini_masking_eval: 0x0,
        gemini_fold_comms: array![
            G1Point256 {
                x: 0x1b80ace6d3a71994d54f127a1aed69282fdd562a01105306dbdfe994f7a32c12,
                y: 0x1cfd6fc1f2ae46294d45ab3289e121dbbdb63ae4a12f653b0cdabbebea74a417,
            },
            G1Point256 {
                x: 0x2c051cb00d1f8d8d7f967f20d0597b4d9200f579f81bbadb1ccdb58c369ef72e,
                y: 0x17bfa8eaa1d66f4ccf42f92b07949a1a59a04d73a598f0357230e8794f9809c3,
            },
            G1Point256 {
                x: 0x121057d509c711514daf98d22aeac18e176c739c355689ebd75589688d780c44,
                y: 0x108282a17268344cbd9705f4465944b3c1f47cdffe80b041df6f472cb3cc3b2d,
            },
            G1Point256 {
                x: 0x256a01a83c286dff583551c69d881c20100f1fa24af58c4cc22066f9beeaf7c5,
                y: 0x2f33bfb118494fbcc125f8187f598cfb912902323e0adc88bedd79f367050b5b,
            },
        ]
            .span(),
        gemini_a_evaluations: array![
            0x242b18cf5b50fd4208a289c0d137c83f6e52f30fbe42f71cf4cdd8239f7e3ec0,
            0x327d18c47508baf244b070af154ac67cd7eccf648b4bd57e683a6eec7c25aa2,
            0x175db499eed81fd94ec38e0e35031d66a486744262f1b4b726f894b9d7468eef,
            0x7470c305592337c85f2d4c158fc67f49f84479ac9323bc3137e4d0a99c15afd,
            0x22c7df8e797c5bb4a92c1fbe23dc7c72a6801aeb8b2b67dafe129680c25578e2,
        ]
            .span(),
        libra_poly_evals: array![
            0xa0d1960b40759894a0306185fea6485d22b76e457ec2ddd1fce8283d2e6c068,
            0x2201e10afeab4c49c600a618cc4363b095d957a678a7e60ff0399af8ac713c02,
            0x146875688042132e3eb279abc7cf0feb47cc7061b14ea6c7dd458b6e9c54f3c4,
            0xa14023b0aadb8ca9c8ce0498f3555b71bac0ed29b9ed52cdcd42b6cb99936b1,
        ]
            .span(),
        shplonk_q: G1Point256 {
            x: 0x1f2830b15fbacf4ec6683624d7b84e9e0cae323781142061d6eb3c2d121bc58c,
            y: 0x3ca8d173c93e307af7c2580d8cec4d2c7a0a7143ba83ae53e8a14f8c5cbfb65,
        },
        kzg_quotient: G1Point256 {
            x: 0x6ee397e3517dfd2cc825b9d9cf76068e1d01bd37188d86662bfff9b5cda0d3c,
            y: 0x6a31a3e147e776aa4bb5293b281d03e08777cad9dd01c732350548d92b66f49,
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


