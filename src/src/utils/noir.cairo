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
                x: 0x20de73a63868935744189eae536b58f316ac51dea8366ea661d01870e6a73de8,
                y: 0x1624ef76d5974c9db351fe089df0328a7d8390691ce6ef68f41caff254bf3fb9,
            },
            G1Point256 {
                x: 0xc5e061f5decfc7b445c9ee22d757dd6dbecff7537c36a92ae3ff5e225fbd6c7,
                y: 0x6fa4795dbb3cb74dc7d9376c97efaa1aaaf63484bfcf946d5c5d2d9dad04ab2,
            },
            G1Point256 {
                x: 0xaf88689a5aa7f84e7585fb89033f2c37a7ae3510b98c7ea492c0b0c9022e4e7,
                y: 0x21d6d45162ccdf3363c35ef717e6b30b00f5aaefe2f105d49c8b79dc8148f57e,
            },
        ]
            .span(),
        libra_sum: 0x3e3d97c77d9ccc1858fef092c1e2aed9a8e7a8cc0dbd23c1303bcf2c2de99e,
        sumcheck_univariates: array![
            0x2e70477c042592dbd5051f5df6ca81a708916376443b6108f2e553dcdab0ac1d,
            0x2f96377b57e616f904b9f90dce13643a54ffa153c31f62c484ea33a0758eb002,
            0x12d26eec00be7cb21f1cb24601afe86930e1dacd94024c6b83d2f85b9bc133e2,
            0x4120e697002e368fc403f4bc1e317806bb4681b66439c17a975f3fef2406eea,
            0x1e9336785c9918844ee94ebe7e6a2efc8d8707e0518a55e5b700b37f04d925b9,
            0x7cbeaf60b0b1006ff65d76bff544c00ad9e547a93ce42d98534eec660f19244,
            0x121bffdcf1b92d7a747502dfa4c25fbb5e609a81a1123721036fcf9e218363c1,
            0x15fceb81f557cc70b66af02bc455b1963f6877bcbc0d292ae7dc5bd2e79b90b,
            0xed35f951bbf0430f1233325139981eb9bef664fe3fcaf7575ebaacb871892cf,
            0x26fe6cc2dc4f5994bf131d5bfef167acc928fab4ac3bd8a7fef56bace5be0e24,
            0x2894eba3a063651895e32cd98a985d3622c083cbee7de2a1143a1187aba5531e,
            0x22994725747c41fa1457de0fcc7926a7cd27041beb5534b4d4f12925e04e7d92,
            0xb2bd698ec177ad0a3bf34ffd72bfe8bc471be2447937fa000e7761ff94166eb,
            0x27bb4ae76e602f8df8259c32617dd34a72ad345199190456234e425de2629336,
            0x23d63c3a94b8256386b37ddc767c45f41c31605a64813afc4030d16ed4bddfab,
            0x493bbeb8b1001c9cff3446f85ff78a13a6c42e0ecbea27fcf5a45b31c08e920,
            0x11312caa56f2a4ce21e29ec24b0ebb6b682a93dabc4a12990d1c0b5a894151de,
            0x2f027b2c3bc958a437d421ad4ea087c38700bb87981f622e113f9d630eb4cdb9,
            0x2a078d902a7f7414f0b14f77e2d95a5daf38318e4ab133154b45688f2c244544,
            0x99f356c9e33e44e5509f51608a40a95f2664685683f68b5d8a303a0583c302d,
            0x1b324b2e3364815bd8f8c83c088580ef9b90b88c6b647d21f1dc0733d279be6e,
            0x11485e0ada88d92f45cd01b1dc1814bba374edcbba0b788cc84071b114474ebf,
            0x2a5ee6a0cb7e045eaa8765d846c429b90544474ee7d9e92dad26c8804d4b56a7,
            0xb15de1ca91e69250b733daeefd020dfe055e33c1ee08d11e148b8c814fd03db,
            0x239bd7141601b0a32af7caa7b03f8dc91d44ee85eb667bfcef9bcceb415f7c51,
            0x78ad80a33e0a3330a69d5f1254bd8d1b2630335a50bdc20299a957b7dce8408,
            0x2aff4a138c3197fafa78c3361177e3de012df9163f9b991459c0d7923f5a36f6,
            0x28dfd8b9cf7c658cced8ae9c9391fd4aee63d1e10c6ba73d30f4c205e551cbdf,
            0x1d6d076032e58199680ecb5c3b47b1ae441d1dd13be2f14dc3f2251862e7f7e0,
            0x2d523772c46fc7840e8e8cd35d939f6dcb044b0a210f03e089d1897e1edb3f24,
            0x19eab9fd7bff28353806df31a21c944f6633039273df4b5178d672dc53ec4839,
            0x28cbc58ddd64d1ca621ae37386f1755871eb897dae50bdca6229694a73be37d6,
            0x14abde04e2b5a248fc37a310446e514da3a503d135ab0fe439870a21bfcd73eb,
            0x23bc666cd18eb441215d3e5b3ef16316262515b4ea453b978cf22ec48547b93c,
            0x1a2bc57d947777a8c33a3748e8f3c78dfeb63390d78fc2311fd985f9e2af66b1,
            0x6aa43454d0c0d09069c96dec9abcbdfe9f0e918005593c82cb196f9e18bcb2,
            0x7a818998c9c0f301aaeb0f46ebdbe5f0a76d80435f65b647d4bc757ae7e2e49,
            0x7c7dda1fc326ee1eefc1b7f844ed054320944488a8fcb93bbb7d75ab58cf8a2,
            0xa7ec6ffcffac8ff13afb0c4cc06881deb92f7542f11a957b797f9fa28a113c6,
            0x6a1e5017ae963a671c3f200d5497e811bdf73de8975ce89bb004d15b2032414,
            0xc84eebec548c6d8d28fdc2dda62e101a3f3579b216ef2c96389e64f27d84ef0,
            0xc8268aacbb3dbe41b23392a950a7ab9e02e971ecf62914b36513025f31bc978,
            0x110835c560d42e52aaefc9efdd2d40c0880631f6dcca9aa810165e8031559361,
            0x153413c2dc4d847c1c60b4570f4fd09a0ea9ef7ea374248e1a15df4e82aa3afa,
            0x1901e0f3a631633d1fdf6f054673ea04eb19579cd79db529ea66a1c30e0be4c8,
        ]
            .span(),
        sumcheck_evaluations: array![
            0x24a6fa2821f3edbda2381ac5bc9773f0f98229966547f26f95010a802573ad81,
            0x223d2a1282d3e46ebbcae8baf7428975a8d4dac90e0e9055349a70ffed781c57,
            0x281b70465387d278d401efa7c4f03ec77670f5579028b391a46b27ab47374b97,
            0x1310c652ac2900d2708fd634860cc32720dfd11e8176965ac13e25aaf07d36ab,
            0x2e77d3ead2db1d92a5ae89e2df68393f901c0077309ee9f2f7cab408a8745f6f,
            0x218a89569d372fb15e888df4dae7222d3d962c16bab7f805658982f5fc4282b,
            0x790b8d76fd8fc15cd56cf8abc8c7accdc58fccc117b648dd68fc6ae689077b4,
            0x19fe633216ee65d4cbafe8b762a35cf2958f97ab0c7960a7915d1e07b7e9baad,
            0x1f1d12ce63a154eda88641b30446ea520224c4e5a44d962f42c1dd3395cd31e3,
            0x2450ea46ba1f0e87a21845baff1fb87551193544857076773df8b3e0ca848769,
            0x29cb8adac52449d97b3fa382243d09f2741a138fe4516c69f865a8070e2d782,
            0x279d3bb67238e71dcb05068346f35c85aba19d4436406e2a42127afaaba68b2a,
            0x2550883cb8894dcded2117e4596e954d40b24d7948daa21b961929caf92451dd,
            0xb68d97dc264c708cca88fdbea2f4b98c6bd61d6f4afbd2cbced22ac9f94bed5,
            0x4fd7f82bece204681fac4456b537f71d297452222ed3f34ea68632d1da18a0f,
            0x1d9f21c7a6b67821d4aa043aa8a977e4997823bff49e110817b43f7c6b1754de,
            0xe56e76cc3c28f8421a8e894d0e821a1f7793bc6a79f291380cb77413c1cad24,
            0xd58d589d62521adde7fbb493f5a16cca4de614d4f0633484506cb2313b51ada,
            0x2833e5251cadfdd3f4f07ff8f87b23a8214953cfd0f235f88808f53a6b89678,
            0x161077e39e40fd52e612dfe6b3f272d77b3620f013fae5f96dfcc5c918c9f702,
            0xb1e66262ce2ccd110d524c47b776c08b376d923d78ab9a169c9918f7935d36e,
            0x2ff243df221403bbaf25fab53d3851bbe5949e16fdec7e472aabaa458827fe6e,
            0x10437a71f8df50a95051a7ff14585537f57e0edd67c047f5777f008498afab0f,
            0x20a0595789a1cb8fc3f0c94534f55de4ca180fa28068638ea74c3f5aac3affcc,
            0xe2d27eb0d9d94a3aad2ff7aa312ca9a4a7ba17f5a1a2f53bae98d9c34f6b486,
            0x2f0bdddbbbb42adb52d1c171a3141839b8aec925632c4c31079cdfd6b8a96179,
            0x22746c8281ff973ad675334662a4c92e65c857cdb799128ace9362536d062410,
            0x6de7d89ff7c56388a97a9cd2e2f18d53d106292540e1ae4c934f4f53632ae6b,
            0x2b45e8613e2cf6a1339d549e5523ecdff75c1c4f5a2a7f6dd747830feec3d1ad,
            0x18e7ddd76b10ca9111917d2fd55ba88a5f7e946231e809c01da42df348304b3d,
            0x244cc124f5df69b871b3e69d9b9d9264b95c08c8042753fac2758ab865c1ef4,
            0x45fa68075f44b4ffcb86f7f27a2f7f52c85f1dc53ca0b78c8117c72656da5f2,
            0x4790d86b0cd9b7402184c7ec30b99e30524928040f35f7dff503b3a94dd5574,
            0x122ff4fa0735d34062f363d2b67174558d95f6aeb0dace93c396420fe03b4ba1,
            0x122ff4fa0735d34062f363d2b67174558d95f6aeb0dace93c396420fe03b4ba1,
            0x2dc1277d403486ae3fcfaeb9040f6d215a46dc9e0bb6259fb6526dd6de58fe8c,
            0x19bd706296a93ee9f3ed13e93502e5815d50d45a1c04b243ca05cb647aa4ff8c,
            0x2fe5e3468c282b6a8436867cc56bb4a14bbd8c21944a0415621fc2f4e0d55356,
            0xe939516c5a195e9908da40139282f92a732a85a62744eda59f5f799aee69b7f,
            0x2ea7a7d561470bcfbe77f1fcc16d78a939120119f267317bfabde146a53f31f9,
        ]
            .span(),
        libra_evaluation: 0x90bafd66db803e80d5b0a5a18df311ed66254796d8940d73c3c77b193635eb1,
        gemini_masking_poly: G1Point256 { x: 0x0, y: 0x0 },
        gemini_masking_eval: 0x0,
        gemini_fold_comms: array![
            G1Point256 {
                x: 0x17b18b79261e69073953ff4eead2bfd1dfc1030b6575ea288fa55f9731a8a5d9,
                y: 0x2b07aabd65e72c31cd3aa75d6a1398a84448ee1e1546be527d3272894aa76d15,
            },
            G1Point256 {
                x: 0x22ebe12d0388f451dd02f0e217dce84fab23db0ffd70dece4abab49e2898b084,
                y: 0x350e9029ce17fe7e43dd08f3f4c42e41812e1033765b132e3d9240b6f3b22cf,
            },
            G1Point256 {
                x: 0x2741bba0c82d0a2ccd09634deb52f75767fc962ca5140257b5dff222e592ae2f,
                y: 0x2c28f42d0488d3f50ccdd049e8bdb0c5b6a0e2d120ec33f82ee0c11b42988501,
            },
            G1Point256 {
                x: 0x24c763c07d3fcab4e16e23a3c479940713b06f790c60aed14ebd73c2b13a2daf,
                y: 0x798bc388bfa1da6378f6bf08abbb066c32881b50c3c7535e0813815bc4dd6e6,
            },
        ]
            .span(),
        gemini_a_evaluations: array![
            0x1335a87bbc184f6791325593f23f0d69f78b0cbd34eac10bb95a1f018b26c65b,
            0x2624b8fe63303fbce20442ea9ec5dca927df915c1e3f81134ee2a9fed3192802,
            0x62eee1692c31a0569b2960572109f07c8f465f9e467b7d5547f2d67a05acb3e,
            0x5ca9453c516f494e84b320f55448d8d2a9b71e686ba1d3f09534dec5e985205,
            0x22bcb6c8021b9ffc98190d3f4d6b88ee0470635d262604e4b273f4c3dabb0cd2,
        ]
            .span(),
        libra_poly_evals: array![
            0x22e5a42198b88973ca865ea199e2cb018f523657030f58c31d9b9bfe93916b13,
            0x5a0741339ead2bc8b792fe4c84f802179a012fd6ae535471e2fd931d0d7f34,
            0x1d96b639a53f4644f3144dcf501b9280b73a7c271c5bdba4de13053f52936c92,
            0x27d9dbf3b9a67fb7928c0b547519d33487ab29b3a02b2a7b0e87dd3bbe1bea9f,
        ]
            .span(),
        shplonk_q: G1Point256 {
            x: 0xdb1bdba7c339d219cae3780346cc4c0581fd27b6ce02c99bed312ca6b2093eb,
            y: 0x798e0ee23e3809ad6122951c2612a3ee551717e1d12a1c7be0fb6a26f074b4a,
        },
        kzg_quotient: G1Point256 {
            x: 0x2690fdbd78953df1b3f07cf81d8b2e09b9914ec26cbcff4d7609287428d3365b,
            y: 0x19814a1fc5efed0c01442b9d5782433917bacedd11e152e13ed09dccae242299,
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
                x: 0x2b87efd6d895a0fe603021fb2774614d29ac91f5a3128506ca6cbdcbfa01b031,
                y: 0x872caee1958b17eb82ecab5dfa92369537ce309e9bce58bd15b27be619e3760,
            },
            G1Point256 {
                x: 0x1d2018cba0c3ef23bdc5fb48db9c94b971643ce7fa204dc352fc446076308b8a,
                y: 0x17b47d3389f64263264beeff418c5173e6ba265ff1d7a4ee42fe2c11f47d131b,
            },
            G1Point256 {
                x: 0x26b79059132b7576b9b5388442b7cafb97728b9c2f093e3a33958aacb953506c,
                y: 0x22444734d966a8a2df3f391b1e3337dbb3bec6d7d7797598e6868f1be8f2c03e,
            },
        ]
            .span(),
        libra_sum: 0x67ebec1f382788406e5174008896f6f44018c3f1951b9848d7a95bcea41e370,
        sumcheck_univariates: array![
            0x125c240bb6fa8dfc2070fa0b05f4f93d5dab6f8afb2e85a81a2abd6f8658aa2,
            0x2b0f2935992a1bc292c2978e9740e001ca0a6fc82e5d2973c23b8613cc62e8de,
            0x14037929491c09717e674b6923f4c93c05b5cac035165a3eb59e032c915f3a92,
            0x2e7ae8abf19104b478a0de3e8412df3836c09babae4daef1a836f645fb9d51f5,
            0x77367ae68a485e2bb9cfd288efea2e83b55c6db903e4b5c2edecda6b1a05477,
            0x1d8372f27082ec6c2bd8870d5970a8cffc297e3bb4a3650307d84aadfbed1b4d,
            0x28aa90b721aa0e81505debc130f229b67efec011ef2326d6bb9135624cab90c7,
            0x2ab69d20424e53ab580a9768cf8d46b096104b940dcda1efcc84f5e0521be3cc,
            0xe1a5db232ccee43f3d4a8817551cd6d927942043498cd55fbcab325cda24118,
            0x579666534930cff3e4f0c3c3b07dda10cc5812e4bbc202b28302863f87ba37f,
            0xb8181fb77fa7b6ed6baa029f5a3d5b5588295670ab7abc8bf503e9d1b97291e,
            0x1269db9c8505c2341de1cd0b1252aa2dbfe41e56dfd4cd428848715c30d8a588,
            0x2f00c533e42e6e0e8ab57567c553a0e3d99dc9b3f6f4f1f5a0aa628380a98928,
            0x95480601d87230cde0a99a509c3fe0f4bf0c24037be07d2baeb2d46b0532108,
            0x13c90be6a6a6a6c91edb892ac274edbbdd3c2b5ac3f0c99140c1f650faf0b5af,
            0x258e816076edfecc3102be9c864c24cb886198bc21a3373ca19cb3a0f2dd72fe,
            0xc758698d9137a989237586cf9d0ab502cefb585554403d2c2987d9d577a46dd,
            0x105952e8c3f1b8a3f2601f09ca540f91fb107e02796576ff80968b755582f08,
            0x128f2d7f678b2ee36fd9095f2976b2cdc42028a6908e118c8632bcecb3688662,
            0x130023bbd95d65871f7b61d2f401eca297dc85fb9325737cff2383bf8e2bb560,
            0x144e5006392a1af6b432dd80103cf3957865636ceb894c9f2ed2a4fda6f92e8,
            0x157cf62abe446d24bd5a48e30121145e3f77c1f7bf6ed2e1d6aae854f659d0f2,
            0x2781b936eabb978ab587cd633d6e6137498445e4677058dac0d234db6f1ca8ac,
            0x4a9764d87bf275de2c85d68137379c08b46c2f7973b6e981a46903e4e3a25eb,
            0x254865656f6a611e07aebcf6dba004825058e3dfa44559046ab377c61c78b35b,
            0x2c56b4b82fe977d2eac65a5aebccbf982c05ce5d120f0a5b76a08069886329da,
            0x1c6e7c2bd9eed59e619721e04ac0e79ee41625890208c7ac1010ad282d018ccb,
            0x94ebadf65ed3c4c95cb4176cdfde41be4ed8a14df406bf49926eb08a414eed4,
            0x261f156ea37b10c8af80e9b0f44ee1c44710b3d290d8edc93866ef9edd8652a9,
            0x28b84bb4b5886fc59c9ec5d8761bbcf2e428f7dd8a5794b2b1b0ed0578ad7141,
            0x841f99c245103f2477cc49f80a6a0dea5c09c355c556264725c46f57e7e895c,
            0x106b8a86dfe539e1b149111726b799d56e81fdf4195d57a4a7656c5d533bcf3,
            0x15cbcad9deceeed3b4d57793428c926e8d5bcbc7f4dfd2803e3a05748041e731,
            0x798c80d5b6b5ab17ebb1e4c70a197af1ecd95fab127ceaee86150e17860a1d3,
            0x1f8c049929645258f534d0025749040abfa0ad19574825e9dcbb2319a6cd7cc4,
            0x12bfe4b38a0d92569ec0c343a78d14d250a6b7179acef18f06ab5a6e6611e7a1,
            0x2010080ef9c1cc9b40051b0882c452289aeea6644ecbe0d092d7a64e9d86df3b,
            0x250f73a5f6dcfc78bdb707d7a39e8ff631a387aa99b714f5f1467619ae1af226,
            0xe0d1e4c338c0982ab128ae35a8d8c45bac39992932e4938017c42210cf4a2a8,
            0xf0a7dce3d7780c49bb93e06fbeee34a26f9c889e43d14430720110ae787bdee,
            0x55ff7a790e3009a365e949247d43ce9a55d1fd75da513e5580973dbb25f933c,
            0xea19a69011f287eee396c340852ca43d4945bcfef538ff8ca29824690a162d7,
            0x184cd4cbb184805b3da2958a27cb4f19da9b5aca454db35d5720328cedee9d41,
            0x15cc3137b01ddb51026cdbf698bd7dc23f21068bd3d8aac3aaaefc8bceb92567,
            0x18f046d926683ee5d7088baff4bec08815878e2a40f6d978b0123f8b4e44caa1,
        ]
            .span(),
        sumcheck_evaluations: array![
            0x254ce0ee458e74c735e8c1cf49c0bc44128914eba362bd43bf3fcf7887418d6e,
            0x5c8114dde828e01a800995bef4e450cc2941f96afdde9882c7b4291818236d,
            0x188fbf48134f0adbb92ed3209bb60c9dca76dd0f4cacf44f906c66c304f3c4cb,
            0x327168015e0df8475e5f598b157f2ce4b975f4305dd91c128380298d76923c3,
            0x7c30008590295d91112e08ed15c16eceab80f863fb7adb4f1f30e651085f6bf,
            0x15b8678df331f0b75db684e05e372ae0dccc017dc8ce3a8fcf60ea27aac2a0bb,
            0x3c7bc933863fac849c89bfc2d93642a68f68c705dfeb969c7279b8c961bd303,
            0x3bc12b0f86366d80591e3068c6b0bf704fe59f3335ca4c4f53b6e49420f73e2,
            0x18df6e06b3a8206dd26d479d5c353c8a37281bf55b13b2f943837d10f60f3905,
            0x1d930594dbc1c85c547b28fd8dad73fe7739921af66450e4cc7e8ac77be26f96,
            0x206605c5af5efcebd9825e8099d214647757b749637a0e52e61ce4418369c89,
            0x1967b1e3bce1a3b3715883eadfcd06fcf0d1a7b4d63e578bbe29aff393f912a6,
            0x1046c903b5c2e798246a7985097b1c06652e018d2da5ad1b7fea00296d18a4af,
            0x1adbd0f168391bd57b4f892dd2863e214ad94d243faa53053090d95295e18454,
            0x18a105a516d8fe5abd8790cb702a29f19468b222b189724a36f7221e50c2c460,
            0x2b89425176f13723ce69e793babe67d8814995d802db5243923e796bf7f2146e,
            0x2ea404099fa62964476dff4f4f0ac1ec090b68a28a19f3109d955f85b21bf232,
            0x10c9000525240226cf4be1d1b462d135180e923747d6406886c8a12a3325622c,
            0x2a8f24ab8e099da811a11ff5bd6700c80d89ed69ffa6d4198627e7e191622e29,
            0xcdb023962ac7ec7e828ba7f03914b0c3c318d2d62c073affa7aa92965051115,
            0xc597de1ca9435cbd6a19ca22c79511282e0181ca5ace1a66af356cea3021c66,
            0x1432ac595415da98758d09f72cf2af041e34f55766d792fcfd257c81db77c8ff,
            0x8355d83c525bc32e61faaf1f8d22c09f661ceb71776a3378c0b073c04751ea8,
            0x160819877129906166cc7a3313c15997a843f1952247d71f793738ec38e7016a,
            0x270f992d7b36576f567b5e81ae9c72517d5550c31855322b434a5de256f34831,
            0xc2aa19177aa87b7c3b34eb99e15e116aae15d37b37fd89f0803d7892dbe8f4f,
            0x2c6d6ea7ac0c6bb03db3773f18af657c6ca6416092c9bb7fe395596652cbd11d,
            0xa4edcb98002def7fd6372fc1e80a8705644a9936b6ce82040b7f15a5d0c2d33,
            0x99f4c5d0970d0ada4a778cd6c4b425d88ff73cf37abdb7268ccb6442c5b15b3,
            0x25a7c3fcc3ac6e76866f660c4037aebaa57d0172bb7d5ceb584fba50ac882bed,
            0x2a784eed9b27cdf592fcc77213f0e921470cd63cab45bcf6b51c0b3b2bbb0705,
            0x2ab43d82bbec7379a0e71c4454a8223a7e2904f8ebbed892e6e09f2a824abe7,
            0x23122def59516679cf067ae669c3fdf3f564c535ebb0879a2b2cb689c2aa5049,
            0x725d7b6c232659d50cca632776151d0ba9bf30d7bef5829a17f8d6f3ef27e9,
            0x725d7b6c232659d50cca632776151d0ba9bf30d7bef5829a17f8d6f3ef27e9,
            0x144cdf6ac45b2095ed9f1a3ed7e881c0a56c59be270831029c5d0e8748551398,
            0x4b70d9b44e892b9cff2112364dfbeb9ed60eb89e82df700de2e6b548470d5a4,
            0x1be26b8285e0df326724d9878e697cb5940f7a8f289646905fefb7ca999d5af1,
            0x125c8f8457da7f18e62438dd655f8f99566db82eda04f7b0c5bf86e09998d729,
            0x125ba245465951e9a3b7d99c140b6a6a04afafd77275a85187bd549c60677fe4,
        ]
            .span(),
        libra_evaluation: 0x125a3c72e8d689b9eb8c568611f1830bb532d593bb29f6095ea1dc428e62f323,
        gemini_masking_poly: G1Point256 { x: 0x0, y: 0x0 },
        gemini_masking_eval: 0x0,
        gemini_fold_comms: array![
            G1Point256 {
                x: 0x7978cec25acd59c2c898e9433ba07d5494ef19d189a9d38208a436911e3297b,
                y: 0x91d07108ee3f0bd7fdf5eda8715dd1ddeab33a28057b4349d80325594f45461,
            },
            G1Point256 {
                x: 0x243da6af6c3c4484d1fa74a8234ed565c7fa7a2f1d4c9f05243dad82ab48c3ad,
                y: 0x1e6a3494ae195aa498bc974b367c5961d44cb260c491ed981ac3a9c946245e49,
            },
            G1Point256 {
                x: 0x1f92941998400ded32f5d16fb071b29f744b26c6e03435e363beea97661d0c86,
                y: 0x25bbe1582b3e7732e7a0c8177aab3a28e6a0de1083030cb385f5ac6683c277c3,
            },
            G1Point256 {
                x: 0x1181c3f3a0665ba444058d832d8fb65d36ac8188ade56136be7e4c62d5654fee,
                y: 0x6f2dee3538509b5ec78aa4f3b8570609c96d45288b340a600a11ea37def15f,
            },
        ]
            .span(),
        gemini_a_evaluations: array![
            0x3354de2216eeb8222bd96dd4e142a0246e8492286d6ea573ae5d584e4f5298f,
            0x9e64bc63d1bfb62d8a12fef5ef0dec022d23b91ade8410824ea445e2502f53a,
            0x2765b93c7a74721d773c51d0cf4e0bf36953cfd803bac2f841d84679dffc60de,
            0x1024445fc10751504ffaa2fa9aca33f88108bc928404a5a0cb65dbb38bba5669,
            0x153c6b3af73430a528106055f2ff59fbee3f1f2f9156465293e2f6cd8afb5d4,
        ]
            .span(),
        libra_poly_evals: array![
            0x6b2feceeea89609aaa1fda7db5eedb1286ee137f38b50e48ec0f3f0c3b4d9ff,
            0x15427df3a64501e1b64d708ee18a65501525508f589b12e9814159c1021405b5,
            0x1275ee2cfa1c722acbadd17669ef43d318186f4a5db398f7ff0b324f34cec348,
            0xb04d2bab92098f23227e56935653783cdf9eea294906cdfeba5a7c2e393c96d,
        ]
            .span(),
        shplonk_q: G1Point256 {
            x: 0x2c74d9b436dc7749936d20ebca5a1a9d61ba2a1ebc7d9b545b6ab772892cca6,
            y: 0x2fda7b13c9fee1571e920004270be46f86ede04efca5a13ffe82889dd178e0bc,
        },
        kzg_quotient: G1Point256 {
            x: 0x2a1df3ab11157e095300ff453ab2b88af3d693b8a13d3f4561aa0a1fe4bddf6,
            y: 0x1358779f08cb801dcee73bcc3c216bb93b1697b65c64c17c0ea9d829be7d3201,
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


