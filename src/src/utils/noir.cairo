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
            x: 0x256c003db7bf326445ee6a0572bfc6276b815f88191c08614ffe2423d13d16b9,
            y: 0xb130a304d82de840df3d59900cdd68666c7e16bf90e36a4a60cb3b44d229829,
        },
        kzg_quotient: G1Point256 {
            x: 0x151c725a7ad9a59b1ef0aa59250ae771751e171058241a229db37eead192a7dd,
            y: 0x16d4360d2c8dfedec9d11ad18cf3c8fc2732ac341eb4f0319476a6df04ea8202,
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
                x: 0x6ffbe7d4c32957058cf2165891a675ad713f16b9b6a17ce4b7072e10c04b3db,
                y: 0x5618adafcaea7d02d60507ae718f5b354daee3176ff643f3cc9cc24e5a01056,
            },
            G1Point256 {
                x: 0x295fa82bd87fd66f7ff56657e5f03a1242b7090cfc40de7dd7c7e5faa36636cc,
                y: 0x2ac56ec5d6a5ff4ef565fc8cb3894b1566425b356fecab778c9f69798b863844,
            },
            G1Point256 {
                x: 0x2a498249522840376e9f8aa958804d8d98f10723c44017505bc46bdf0e666a40,
                y: 0x17e489f50d4e5cd9480dccebe402e7e3504e6ca05ae2b0523b8a024f8831c587,
            },
        ]
            .span(),
        libra_sum: 0xcf42bbb898115eddc20759e48387b10fbe18bf7610b9662d9dd51d2ef7567ac,
        sumcheck_univariates: array![
            0x2e4c2884b68216d1688cbc8c56cc0fcd6bddfb3ad1f34abaa9eca298ef22da71,
            0x2a471a70a4e7f5bafb0e76e0879e82d3ddd3a9580710c18bd2e04bcd1addcdc8,
            0x8a0b6624407808c347b43125442d0ba6ae214b34e73348f5381a578bc283239,
            0x188f81ea5910423cf8ddd10e052a2bb29b6188d018239e11b8746f424cae5b34,
            0xe1ac800af7c300631c836088c33a6af62c07b463bc17e33d8eec198050a7eab,
            0x79ee4c42e096ba769dfc5e40e8ee4539baea47dac9ebdb40dc48e086a5fb3bc,
            0x1c07a7b4fc1937f02cacf6b88eee24f9d21a7e8d4b2e85b586b427f45609f042,
            0x120e2502f2f4ede80b570d6a5617e9356b4f8f0cc73acc4cdaede0f0cf3a72e8,
            0x108e3e8947f496a5e19284e865ac71ef17756ea5db1279d9694f7c4556faacce,
            0xa3a8e696358c9d1e02e7625b0cb09fd1456914cf91aba5472498e578656569f,
            0x1b2e967d7609747aa4be30aa73d74fbd15e49166ea160a73fd3154eea31663ba,
            0x302bd6bf2c010746d3fe835a364f6dfdf7bcf2a0803bc4385409d0be95d36159,
            0x2d5bff1d7c23a8300dc3f8dae436eb609964098b024dce79aceb0da0e705c632,
            0x11041a150a61781a8608b602f451b788842302c79e7d2e4ee0cfe0baa44d667c,
            0x963e98d84c643c64eec6ad84b34e9764845e5c2e020f63067b5da71488f2b20,
            0x13c77d1600a5eddc01a81fe08c597d9744f1874bf12d5ea0952d702524acef06,
            0x248239451400f0e1f3febf952a0e0e392565d323d393921454369312501e77a2,
            0x9840989f9ed8557d7713814ef3f1b64d437fc1ae545f7eca7a6481761cca8cb,
            0x3688b5cf9d6dcb6494f6275a9e33b9b83846a9700e679077b447f9123d661d1,
            0x2f3ac12fbeb58d528391951ac60475b55027408aa0c0904d3efe231a40c5a869,
            0xcfb642d857f3e26cfd9fd0c744df4cd0f4a1e8fc324d364f108fc8272a93b38,
            0x3aed437d8255743fb58e39fd0a4df551e6e51d2d942824deab32451e926b981,
            0x2dd3ba5a17582b96d88848a9fd74a0fff73327014615a313702db2e4881bc688,
            0x17aed6ba9bc83ee39664a6fd78af56ba351c0285651b00face51b31f294e5e14,
            0x2ce5ba98675719db307cabd1bf80fd305456b3904026b4ca9d54fdc1a9129ff3,
            0x12f8466b27bd1ffd36b26e58af3d0d3afb0c5926a266457e07373572369618de,
            0x561b73be6a4a44abb2ee879705031a9e3a115f0d34689785905db6d7c2fede0,
            0x17f9d5c0df6801d359f64c6b37860090002a5e2ad4295c9f5921b40337b31309,
            0x2d5298f716c4718862cfc4e5159ac837a9f4f17eb02615c8e01c1813ff338959,
            0x1f3fee2bcaf666b60d5f5c3b3829ae5189759ad091954f3a96e418bd8b8267b2,
            0x2a446b755792588c027c1579f9ee915785d8caba5367e88e6c06dee0c052088b,
            0x17b6759efb1e730cc7627bcc492d05ff38248a415b2b72c4269b0c6de0ed8838,
            0x22076ab0f16088422063e420491191e68e665045b8199a9f48ceb18a397b9d2,
            0x25c3fde5b4935a4f9bf8036124309e1c82ac77512b141a977f25fb2330642d94,
            0x302bdfcb15522c2f65de8a6e4c108a825102ee08f7ba713b250ebb07704a15f4,
            0x24e3d593aed20cad203d04d5cdd0d3d73c6a5adec29a8b4d52976cc83522a3e6,
            0x12ef0d2f00c5a8b4af3baa3293f42fcfb036de875ae0fbdab9d3eb9934cb670c,
            0x18c0ae2c63179e1f42aa3bc7cbfe88ccfdebb74ae2f6ca2174f0dc1f4448017,
            0x27522338fa9bb31c1f03549787ccbc88f06c8ff7402972122452296589d152ae,
            0x5b49a4138673247d13b30b6202a5327a0bed5e2eab3c2f4e01accf9729d8edb,
            0x2d1e33563e1adb953d832a347bd6b75c26e03fabd9490c69a568ce6e0b6b5163,
            0xb5bf16b35c3c3209ea560e9edb9e111068d9d4fdfbd22c2134d6d1d0e45a951,
            0xecfcb548cc232c62c7f15cf236bfa1dfa945ba12da1a03cf8088e3f53366df,
            0x286f8af511b00c3d9aa442a68b7fed561f83106d4605bc75afa372a4bcf29325,
            0x166bcbfd4c271bf27f8fdf318515378df3c3e2226578c33b9b132b370ecfad7,
        ]
            .span(),
        sumcheck_evaluations: array![
            0xd643789ca9ba171c5bd29d5bc96fd4ba1869e2a923485bc43cdbbab2aef39bb,
            0x1e200e5b93b5aa7fbdea280dd30f3404493561f5437ded31ce0e6c097087c027,
            0x1ca886bdb536c9e9e3c5504fd4d9f9d690ccce853a986778c8fd2ccca68e01f7,
            0x12043876aa0b1879a573c2fcb35d0d383d6f1e131acafcd07813642740486466,
            0x9f0542b217410e3f5fb7991ebe20dc2e82c3f3ea830f6b1a88e7eb52b061c88,
            0x2384387deeed6c1916ee6d37804a12687da565eb4f88b64f115ca503171c6b21,
            0x1d1af27b762f1163af398352555a3732278db0a1c22d24a5217a533db0a79e5d,
            0x1bc37ef92ecbb35f454f11f237bfd6957cf780ca43cb5a4f310e5b335afac377,
            0x17614cb2bab565f518c6ad1e6f4888267db4dfecebca79493cf48ce29630db1c,
            0x24a73d6b1e4de98b671d59407ee3a0d421ce3e0897d973a6a14d82175f674ff5,
            0x260cb978b2276baadf03317aa979eca7f13b75d081dd7a3c6c57db4dc46ce387,
            0x247c364258cd8efae8584d68ecee566b11777055599669f1088639338e9a829,
            0x2a001b8606ce0db762929bcb4a66ede1df68ba5e8e5096930984e78d010ff324,
            0x1a1cf4ef8e42a3eec675b9ca987ea42d53c6fc1d8078129f5c37b07e1d4191a4,
            0x15ee17dae28a32c638ff5ad993c7759720070dd5f48b9fc02005b3d33ae28407,
            0x1ff74edd7dea0a2e981b5d26133687776091751020cfd915e5247616e78e7f6d,
            0x2ec2282b8002bab5cb3fbeaa891c2a07c9116465836b9763a68a2baaa850103e,
            0x262f7b5267300e045a8c4517a291baf559c69386d4e4917adc3a29441e393102,
            0x30ae2487ad439d58b61a4168e3bcbad43103309baf435a132d5facc35096578,
            0x1bc46c7d7e2ca579d1c3bc982bc7ea28cf86c3590d77bd89efae3d3dea94c505,
            0x15d5b63de47f493e917e304be34a9b6c5bc09ff87d7c8e126527c82b5a92b650,
            0x1dbb1e856b2e9deba378d5a88a7d4cf54598ff09ff236be909cc335befde0056,
            0x30dc54e651c6b96560f6e239cb9592808fa573297b212fbc3546da018cab2d8,
            0x1b25dd478bd7a7dd4e004c322edd01b8418b0cf0e43fe2e761e40f66b0f927f0,
            0x16947f2c2d4a8496d82aee45bf93a1efdec18229450fa42f07356ec5a1b05712,
            0xce55f8a5d1b908997a21a97bbf7f0b9e319b0e92086d44f0996e50d5c175869,
            0x1ddae4f8c869aa91a9a8c2b84f90284718a970b909074f9c295ec1c909387ca5,
            0x197b5f61519407db678e6e6090a95116fc47e3f7b4b56e950474fe97216f29b,
            0x14508875be2329999ecb1950d9622f22460bc479aebcd14b43ffb3bd8461af69,
            0x6fa00a77f3b5878070b45aed5b1b94da19af1d63128f1f53dcb0eab2df6e376,
            0xb53a5fb1f929d3b968ae86e6141b16bd7e1a1d27afea2d39514bb6fff63004b,
            0x2b5929bd94f046c0033d89b7757e3c6af36cf700bc172e17b41eb9e340eb6fc0,
            0x9218a79744fb14b8cf10d9597b17e972a13224132f8c71dfcca98f07f72674e,
            0x2981bf9624d9fadc18643a483258a3c24902003c693a8cdb5ea7e47eddc49651,
            0x2981bf9624d9fadc18643a483258a3c24902003c693a8cdb5ea7e47eddc49651,
            0x2ea9835c82c991cf46593023b2c9c070aee1633d89c1569e8cf20a85759d69c7,
            0xb5829bddf9b89a180d4d43ba7008be3a8d17d0f7a5bbe021b19f1f478d2d5e7,
            0xc3a4ea4f5b0dcc829b8dd92c717d559a2d49eda57a45a2f1249a8a41f4051e9,
            0x11db339467f1cc434a34d4629850d7f0edcbfa9a63c2884c87af8bfa21d7feeb,
            0x10687631d408519b269994f048cad24f92502901bf7f419d3ab89a1b721e0369,
        ]
            .span(),
        libra_evaluation: 0x54b76ff7f8bdd5d71bf2865a4a4229107641c7db54adb9ac8e0a380beb68077,
        gemini_masking_poly: G1Point256 { x: 0x0, y: 0x0 },
        gemini_masking_eval: 0x0,
        gemini_fold_comms: array![
            G1Point256 {
                x: 0x1f0354a6f624e069a4d49e2a3172c0760ec57efbe1772c35ee954eeee764bfcb,
                y: 0x22a4302205fd347c79b3697f274cbbd6185fe1faa297a9a3717b16a9f4617f34,
            },
            G1Point256 {
                x: 0x20a45d31cea9804db346eb89bf4270a7957d32ca24e899bc3737845f4b0ca599,
                y: 0x1c84295023d2653aedb0d4c8377802e8829b07088ec310be83fc6ea375946ac7,
            },
            G1Point256 {
                x: 0xb263ae069a8ebc19452a70b0bf7a4897e21e10658d45baa8991636c42690743,
                y: 0x99a7bac0e0f75ea7554929206beb0c192e215a0e6ee1ac67b5f664d9958face,
            },
            G1Point256 {
                x: 0x19c77e266add6d864356cf9e6f05e228575ac7d5566cd7a2374b5940ab1256f,
                y: 0x2a4aeaf4d506472755bb1c6614421d42ca071ad78d3e50fa879054c2bfdd27ef,
            },
        ]
            .span(),
        gemini_a_evaluations: array![
            0x239e147a4959911f0fb4bd02e747c2d0cf6e8c2616ccaf9e41d8919c366e5a1f,
            0xdca1ba8049921b222d50adf26a47cbb200c9443ed5440b141502267594936d1,
            0x19036c4ca36d9a066111465fa442812990f97e3bb44889e1ec8de6cd9bee6d0f,
            0x1d39fdd55dbebdf10f34d797bfefbeb5ae0d8f898cb54071c1751861efc6a8b,
            0x5d2821fe16a5c55e7cd391aec88914259ffa3d0e2d23c50a8f17ae99f5ea5aa,
        ]
            .span(),
        libra_poly_evals: array![
            0x319382cf5799d307fc1d1a531378b1293d9ec3a43c402028057b36d2456c48d,
            0x2cdf58a50e55c5fa2805e298e503cbe48e8f716e4c2124f97ff7e70a180675d9,
            0x2da3a1f9aa3bf0d32e986e1fd51186cae61917a1471e6effaa9663a9d5d15661,
            0x2acb7dc5be83ef7cdaed36fcaa7bdb316c84354d1eda16fe8d5ad89c2daed3b9,
        ]
            .span(),
        shplonk_q: G1Point256 {
            x: 0x12d12e8f0fc052f2797d2046b7a89c3eedcb426d71eb2f5840d5b2a43e7e94c7,
            y: 0x302d237e0529d8b312cff54e496a5b0f28eed198b5a011b728fa8410b78bb948,
        },
        kzg_quotient: G1Point256 {
            x: 0x24dc5ad0ceb7d05d48f4edaad3d2cbc50ca82f129f1e719019475244e1ac1bed,
            y: 0xe8626900d62f1f7ea1697feb0be8f78bb484205e1435ccd277fde0d69a68c7d,
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
                x: 0x1ee642667ca517ae36b0b8433dd1feaa5f5ba6130088046d68cfab86cbc629be,
                y: 0x2509e23ba9409cfea21213b15c0240662c276821bcdfe1f33e3c36ad740ce566,
            },
            G1Point256 {
                x: 0x29fe94c332a015912fb239d99a878666da02fc0b2d2d59e3128c67bf77bd72b2,
                y: 0x1900f6ae615ec426f2595ab3f00c218cb0cb729d8615cd0dc0776c175b9ce1ea,
            },
            G1Point256 {
                x: 0x217b2ac6f7549c4e2412b86c740c8206876bba6ee4f6a8129e9e3717c615fb1b,
                y: 0x49f47787ef91242a734eb61dd121756d9312fb29f8473ae48939802082ad39e,
            },
        ]
            .span(),
        libra_sum: 0x279226372efd61255eaddceac031e3d5ea4377f280d76937e68a903287090678,
        sumcheck_univariates: array![
            0x4afc46fbe706f617e39500edec9c29f52e5c3ad22c19cfba719289a5dcde5b9,
            0x1de80ffbc04d6c0fb3ea61d8442f9e4d12d9324bc7648e1de9e4a4e87c7ebf30,
            0xd8b9eee69f7dbe1b875a7948736a661855558d66bca890a23d4ca67e0ca6ea0,
            0xe58ea3fdcf9749cb72eb98795606658891bed376207940c0f4a52e7457a6817,
            0x92458c7f6666ede7e435842d8ef971920788fe1d394aeb389ca85ab910291e8,
            0x895e09b7329a2dc1dd6bfa5a86ca56b636d482d7047f2ce1bc156d567272640,
            0xd769854680408da6349a3e9f7a186b0ba9b60d1c2a65abba6d8250579f219da,
            0x6912d44208fc257e20c836ab2f37748014bbb817d1ba65c5602a6c48de4c181,
            0x88acf482433259654f33fca15be287340ba29691d666c4d1237784672b7eb3c,
            0xd0644800ec100cf4e9d68b96faf18bdcb994f4d59c749b16a60e761d4fa589f,
            0x10a660cc04aa0a92efa9481b8240331127b3eaeea4f21cecb11ef93a152c697c,
            0x94a8720730fdf54e4270348ade4533755dd8aa92889f816135ed4d44aea472f,
            0x289561c3a799b4aaba7324973a16941ee0f484b501d1034e13578ec68b04639b,
            0x2bbc49e2c0fce6e9a08b4bba14fc290ea245a7dbcb381c56649038519c8ede3d,
            0xb66be0497094f34095c27723a888cbd7066977fc3ced9e322420adc9a359d28,
            0x1dd01b80f4da071aa2e03101ac607ce69b407a4cae4f472c4a8fc54c11e9042d,
            0x1a245bfe048acf4ef939264a8d6096a783d8dea52fcb42a65cdfadc8a96265b3,
            0x1d05f7f9657f1c8ff9aaee573ead4478d017e24822efc2fee611b45acd323b55,
            0x2e47b07852d3c1b20e4296112355b4b3732757d33e19d4166596d393a307eaf0,
            0xdb7480da264c21c5a49658c9f1b25cc669d1c5e950cfc64a9ab2b518521b939,
            0x2455e9f1efe5431a83bc7700417c4ed5ac63226400d86288006fb69e1f5faeb7,
            0x156cee8829a51f227b83dbf135cd21b86b8d5d3874b6aca07d9da3c5c1c1a15a,
            0x2479affad42c888bcc3194e685640583a1cf0736b9402b7f18d9b35b95438e88,
            0x1d45de4d7fa07f1607c27d4298a28ab0817af561bd33d0b0021caa86f6246dae,
            0xd8880a4f9f92ad7209abe263f126e8e469edc8eec769beed35116b4abf1acd4,
            0x2f382ae9efc45cbbf135858e9e9b00366151c38853fab252e8ab28828aa48a49,
            0x2351ef420a917c066aa6f9b17a21ab2b5871ffbf1d1cbb5237161b328c02a2de,
            0x73e15ced987aeb739051a53366a9c16595a1a5af36ad730a3c3fb1c6ba0318e,
            0x1ca73f0d05693514608108c2a5d632936ce604eccef6e480137e04f071aa3f89,
            0x257d0c3671ddf5adaa5d7de6601508d78a275951e25fe3f8da6f471e22798cb1,
            0x13f5622421f40f858c468c69dd6b6703c435d07003379075db8807bbb5f328f2,
            0x25c162e04eef3ad176bd6a3f98ec165efaea8fbd33490dcefc1b7de9c32c5928,
            0x496b38d6928a6af9e55bb0ff00522c5d26390f26285e70cf9ff1ee7e27ddee9,
            0x61b263ef990456a42d8361ccc59717812bc858f620f490187f2253da4989746,
            0x9d5cd8b3c16aa3108ff8286da6555b7e4e8cc690abf31f8596a81e95e035a90,
            0xbe6f60c597d9b07093c15065782319edf726217d70bb4379d4fc59f60147a26,
            0xcbcafbeaff1c7707b6b444650a8702fd1c8d2ecd0b9e8325c33a2880a986f4d,
            0x2216da476ffed16ca320eb91a68055e6ed98696b7f84670b78a450b03afcac58,
            0x2969cc51358b86e47ed917f2e20b27d549e99508dc862324062b75a24244da34,
            0x1add98a1b7237ec253efeea61142548a04a15784e5582d25c6e61d5ae19ab24e,
            0x4506b74ad1b51e0ea49b22912930923dafc3f2bda4659115ba39ae2307e705c,
            0x23a40cf6668b90472c67a176629848704a91cec04602042c314d75486dd8a29b,
            0x2db338a104ca3ce0084b36217dc963b9c5b2e70b7f5c9568b3adf38fef6b9df3,
            0x2c0b9d6f4f76553a24603a9f0a642dc9dcc0d1e5f93db293674ab8c91f6934f8,
            0xab4e7eca54f42bf01362bfb796bffee915b18779c2255c894de310f707527b2,
        ]
            .span(),
        sumcheck_evaluations: array![
            0x13bc9e1831563077767b8c45207f574f0aadddeecea9a9ff02ab0c7769e3b1a7,
            0x225217605c4b09e11d3a1ddfa384798906359bc39f2d47b1ecc14e3677a568d1,
            0x236dd65aa66855893ce4bc4272936ef3fa0ea45b44c6aae7ce65a815c57dd920,
            0x5e802593305d2f9c167149cdebfb894ee2671e40e020da532e124af01fb4d10,
            0x83d4516928f1308cf91e020fcf98553d57218f87caaed0130090b3abccc42b9,
            0x293107184d186b3e1d5776a360f58b92fbb0f8b5e42214cc2a36e3cc33b3279d,
            0x1871ae1792350df5ddb2dc7560cb9e3e53968ea3d0caa006abc6b8fe6e54bf93,
            0x6a24e1bc05bee0225ecbe428cc39479fe56bada856f5618949f60aa11c38cff,
            0x2e059085deb5510c75c50ff9ccc62d17596cdf65f28a93c83e505656e6aec629,
            0x1a037d58b8a9980cd77ccf675a855d5e2358483b76cb34ccb7a74ecaa06b3125,
            0x90fea8673b75649e95ef7ae0c66b3ef5a6e75b5c7e22723b9836c67c24e1628,
            0x178db5b98bf70235ec8e3a265a340ca119834da5a18fd8a4ebcaab062c28829,
            0xd2c520bf0aae846810c07267c69d4a9d1fdece2c9ba01bcd79e9cfc1701ec82,
            0x6f8400b2cca462c73b14defdf7bae3f2a6090ffd4564cc871e8050b5e7ee4df,
            0x1e56197eb4e5f4956985d561569f73c53d0ba6f7e31e0495b4f7ad2d62419c6,
            0x2dba2823ea76400edf95b31db84f77d3f052948f9f0c32a4fa068661f5c104e4,
            0xed400c788a706130e88aeeff0d5cf2d8426839719f299f7fe7d41943907a8d,
            0x268fe677bf2eec9caa4548d4ef31ca8d2a7fbc9863a3d9e0e1e8a661689133df,
            0x9d6fbdfe0b8a7ef6e83591814806dee73359f138f5e47453bd4237b5893c0f7,
            0x1d18c3312390f03bcb2490bccd9b010e363a02c3461d923f4330b151d8787dcd,
            0x18a6a6f4c29173abcb7d65b6cdfa0208a161440015d75d43225e4991b3627755,
            0x1f8d1bafab0e800ee56d40235508d98d3c46a0e813b40e052d1880e87a868da1,
            0xe700483461514e452c19c72ba8c5de0556ea0930f104cffa841596afcc8b077,
            0x6c5ee06655a042626e9357ce9786fdffdb7244c97c96f66b5549d4ab4f9194b,
            0x1294fc8c0b3684f836b4d8a023fb895af5e121cab69ab67f8df378a36224a0fb,
            0x2fc6885a9a5077998c625675db65ee4aee1a2745b779fa81b0a23af68c44f7fe,
            0x1bc62aebb18a5fdf87e5bbb694fa196a4c861ddd4ea8e80d68a0c4434018acaa,
            0x294efef5e6ec94885ed8d22cc75feaac78fc2d1606b22ad8c274e776778cc93a,
            0x14437aca185417668a68eef9407a0a8d3f6b79e2ef517fc584e1d900d4b91c8,
            0x2328feae1c4ae728e6b5e2ba066c512931b8b2391e61f20689b9298ea894d1fe,
            0x1891154be1f79a7017e12bdcff6358291af727bc0cafc6ea04d04c24a2c8c75,
            0x2eb7685e001d28e96ebeaa82cb8dddd15035fb1ab958af99a433842e868fb3ea,
            0xbe4eaf44648463f991d892ecacbe6be0a8a7dc67add4926737cabd606d51eef,
            0x632bf6cb38601db832fbc51bd92d88c7ffc879a92655ffe78384e303ffc6dbe,
            0x632bf6cb38601db832fbc51bd92d88c7ffc879a92655ffe78384e303ffc6dbe,
            0x132a1567802e5f9b9bfcf12c8d854e4b697d98c11e0b38e6597319f0cdaf08bd,
            0x176e2ddf3e8dbc6cb1ce3819f5779640393622cf7de10f85e9ca14074f25afcc,
            0xb5b960d5c65013f6c29f2aa0c858a2e3a6f4aa876b5d616b861d825b9399357,
            0x3062e5007e6cac4d75c0532b0b4f39b9587f461157e9d6d072daf1540bd0ec03,
            0x25f388abb35cf0e11d19004deaca0c87419228b4cdfb4e508a0b327f2150cfed,
        ]
            .span(),
        libra_evaluation: 0x8899f321883ee8fe209647a5f39e67653a263e2ef9e5828ee0f57fc2df2d8b3,
        gemini_masking_poly: G1Point256 { x: 0x0, y: 0x0 },
        gemini_masking_eval: 0x0,
        gemini_fold_comms: array![
            G1Point256 {
                x: 0x2f31349f086dfce479c510e4d329a4376e7f5e6509b39ec36daf41a5d39b17ed,
                y: 0xe1ff0c66a7cd8827e448497e61420ab4dba6e4774ca663ba5cdef73f2eaa23c,
            },
            G1Point256 {
                x: 0x2c216e7f20c0be385c1757cf3536d2db201c6eb20e6e06d6cfcf510c2fdad3eb,
                y: 0x2d567bcf7653a428231c6249f5502227c623c451eebd6ba6c47fc706dbff828d,
            },
            G1Point256 {
                x: 0x2b7000257e168e4fa3a9ee1ad1f4520f91c22c18b394d5012662f47dcd171244,
                y: 0xc8b9a6c021c48e0f5fdf51127ec40a1bae5feae046fe52898c1e964a7e5691,
            },
            G1Point256 {
                x: 0xe82c7e617e8abe6d0c1fd50e844116e7b83c22471db539ad9445834023d63eb,
                y: 0x24d1c1004b53b713f6a06d032d13e3582359eb70ba82ef8e6c8c9d8ffc111801,
            },
        ]
            .span(),
        gemini_a_evaluations: array![
            0x93bd17a8ae9c8e7609048403870ed3a8c1d5e862ded69f3aa4bc0b26fac12b3,
            0x5817ddba2d7e7de33eba4ed3a4ffcaa124f884b48e51ecc5b6acb9caf8ae2bd,
            0x5c47c0e1a952359669642217483712b27a28bec779a6f18bf757963acd6551c,
            0x7d88999c6ffb06bbaad2eb8532fca511dd7dd08b3ed3d576684a55f46a92b3d,
            0x902ab8bf02ed58aafa96243fa0b514aeb279d33e1b1d5f793f0a0966619ac0c,
        ]
            .span(),
        libra_poly_evals: array![
            0x294b5680df2fb88fa44f715b550c243a0c1c2b01593709836226982edf4d0d65,
            0xc47cfb22fa58a38c4f45840628f23521ca2e830d1e47caed51c69e224ea2635,
            0x6e792ebcf60a5f8a828c4eeaeddb67605eaa98e2a189490d2866e0d7f2552e6,
            0x65f87a581e3f713acb2bdd6ec87f7b61a2bd9b6ba56570417229360ea4d0292,
        ]
            .span(),
        shplonk_q: G1Point256 {
            x: 0xaac7e0156b9c7d395e9f65688e70124e083bd8acee40dbed0fa9f27c9f05f97,
            y: 0x218f559bdc2dcbc6326d514d8e1fc5e5652645f88bb934e542aa7ab643f7cd50,
        },
        kzg_quotient: G1Point256 {
            x: 0x313ed945172217dccf869791954ef51899b109d537a37010785a98dd35ba7c9,
            y: 0xfa92ccfd9b968dc690b7b01eeeaa327045ad6fb9ca0ebed3c9d99a837b4623b,
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


