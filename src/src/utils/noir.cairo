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
            x: 0x5eb7416bc57a1a174a50ce9316c961c5d35fe78d05ffb4e0e6e1c0fef3424b4,
            y: 0x17146af6a9eacee1dd78dd87790e5a4d452a1bacccc2b189fc774ee4c949e414,
        },
        kzg_quotient: G1Point256 {
            x: 0x95f88af88b171718d99036c7a7df46ba39de6ba3566227f9eb783e9a896513c,
            y: 0x12d409fa0d029ea8df6ec761e1570ad8d1bbb09b3b0d6d55bda07f79d92abda8,
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
                x: 0x7ce851ed703c5b1454e7cb056d4df654ab822fe042cf435b927febf42d81576,
                y: 0x2a53dc23a99d10fc79b79f2bd6dbbedf6bc373b62cfafd4ce2578a5e63f4160b,
            },
            G1Point256 {
                x: 0x1b6bab9217b01671a9bc78fbf734d742ffce61dde9d92615b737cdfb3e35d7b4,
                y: 0x1f7777775bbd5da575874e6db70c548b6e3b71f6968a6f64f58888f00dcdbaf,
            },
            G1Point256 {
                x: 0x18f724d8a75ba227218c57b61146096a15f9ca41a0a0549240fc345ac65e6306,
                y: 0x1b0475cfd50228bf284e34f8ef4384cf3e0be5cd940f716156fbfb92c6f35cdf,
            },
        ]
            .span(),
        libra_sum: 0x21c4483eb9b0dad174f70c9c38418eb2b40ea02d16995f146a81c12dcb1ec213,
        sumcheck_univariates: array![
            0x158f20a77930ea1ae1381f36db76055ff89594f024a88f057f1b2a49585a791f,
            0x9dc910a386fc009288b4b516971c0116dfb531cb819e09db038569079af3940,
            0x1f851e76bf21c6e9aa532a7ec6515ee0907e51afdbdfec0268dbe7b3e90358cf,
            0x28b5bb0950757456a9b69140e481cecaeb8497ef16b4afb2390feab2acb6e140,
            0x18cb8b725b011dd6cc10c5ce3359ca4355a0c2948a7e1620767b34fd6f3541b8,
            0x1c2b1937b0d392fc25830a16ee98fadf83393320d6e258e74b9c0672c7b49894,
            0x272b802e625c8c7bfff25ae177a323dea3172e86dc1d799a0ed5491605f29e57,
            0x2407f611f23f1389e8a1acf784c853e4cf47f9342f3e5adce3794666a106065,
            0x297f46f420ebb6521d3fdc37b14bbe827c682d4d01dc1ed51d0467397a9590af,
            0x22e711206c82f545fe7e6b20b61e4474a7550f31fb009f8960a7f2ae1c02874f,
            0x1fc3a13605ac668686dab53923e1cd2959a8d647a755fab5305a3f6956571d64,
            0x2b78d46b01072fccdd1cf0287740b266ca0d8a98db383cd08a87188144fd1cd2,
            0x8e84b69d547dbf1cba4775da147d78ef93fa0f13b3af02b90f72a37eee416f2,
            0x2bf4363821410bc735964402a152dd775f8d1c735000bc2cd89d33ed10cf5477,
            0x29ec1ea21e99f5dd8abcc79c0e48be3cc013443b2807809f6931e57213c1cc76,
            0x13ac0284d63925a1cdb7fcf6af6503fa1b8f1ec2f3e5bad0ec006fa9e75bef92,
            0x20eac490f2c0860e2b9183092c66846931780296625564a3b5a7ebf8114a3460,
            0x615fcb6d2478baa18624c7eca420eb31beb11f48b2a2da25bb6767204b18192,
            0x2d6c4b6048151da484a4e0b51f2e72c2dd9ea0896ae01c20b2cc0f10ffae587f,
            0x496b5337206c0a4f25e484c0154fa907a80084bf50945d4972fdcade72e0881,
            0x181c49520992befbcc0d50a085527a0d2a1bc6256c6b3b5d81a064a38afad221,
            0x265ec8f47e6ad6df0b8ca56948e9690a717c4108bb969b61b0ba27cf7d876833,
            0x685878844597dd76f85e9a67018a07d4fe363f7956018b3089242bcc01751ab,
            0x1e441ca70362f64fadaaaa188e3b0d1b7c88e995a577b18a7b6483b20029ded4,
            0x2c45130263e686e31f47cc147757e9b60ac9a5add7d387b06b82637b7284f766,
            0x252062e9ca803288e7a0aeb5baabbd5959c0b5e67c6bac6f85150b1bc111d2e9,
            0x2f7499cd91f22aa09e82063739361ee712db0c2c95ecc8a209234b24af30f86,
            0x2c20eef41c93a3c460d23fdf8ae32cac7dec7552e154397c88d8899ac94ce58c,
            0x1fdd16235ad1de2f85c6b516f8aed60992728702d956d4a73b5f9ac11147cc55,
            0x2fd3a48c1cd7e53607f602bb16ab59429362f23fdc7cf4421f3e85b6eb8d08bc,
            0x2e6a84879c5c32da805a5f3c00f6025d5847f5ace8c663764003d8467e09370b,
            0xbcd72440463b5653d69580e81500091967ab8c8db0c94652800f35dfbb2f6c2,
            0x2682a103e3c9a4a4d251b1545ef4fbf8cd17f4d092cae7054555d82c6c2bc310,
            0xc93a95ba14f206be884811d9e5225853a44b4f43aacb9122c9426694b3bab67,
            0x4d464b415d4e8678cec5a29cfbd97d897fb86b9b7bb8b0db5c665441050d664,
            0x10c046ebcd50cd6ffd786d0644f472c575fc82a2f093bbc6ea03a5853d08eff5,
            0x4de224efadb5be89436568c08757296e52d095fb40559d814a9bc4a60555e73,
            0x99e48b37fc6ecedb93c19e097236f3155e5419c292a96b1e1630fa14b94ca83,
            0x1f77df63cf00c6ed82fb01f23f7bd14edb068a3b1854547746fdc052c9f3972c,
            0x121088997c859f19ff13117bc7332ad3d34d9e5cf2064f08084c789490af885a,
            0x224f382a2eef7d52a441c9fb92a39ae2b54049512e10468f69c8eb134c9f6a8,
            0x2add6336c73b2ffcb6c87d1264fe1c59b6ffde8860f8ede146bd1938ab54fec1,
            0xa5edf63ebbd3554ef5b8d63ef063e3ac7b2dc3a61992f5d17adde16e54b005b,
            0x415f6170ca77e1fb3ac39920ead06c5dec19d83d02f44dc33d2e7defcdc63df,
            0x22176e7472a8d376ebd4a8a1e38be968c6172abb60343905a5a6cbed4d07a0bb,
        ]
            .span(),
        sumcheck_evaluations: array![
            0x24e76f761fa787538ef4d53fd3b6d41b66e86009497f875a59087c6ffb770199,
            0xdc1bdf9c3ace414447974866f504646efa05557dc4fba66e6a63bb976537bb8,
            0x83b047549215f54878259d0fcbe2d9bbe4b79e13bb6925c7a4281f44e81f5fe,
            0x1f69dcd11c336bb7d72663129448a4f3b0df9549ee10190c62285d898cfaabaa,
            0xd16f507a6fdd32e39b49324cf87b97e79deeae5f41bee455ca716c76e0af05e,
            0x213a6255c09ba30c3f985d38f1ba3ae233b50008e4121f61d0e938e65152e133,
            0x24fecca2d5c90fc949010a852e5cca41a2ec6c46a8451cc786b3bf107958103d,
            0x2283f4fa3214bc1e8b3d80cebf2b51e414c4f0a6fcbdea891a200bd68ea24596,
            0x1c34053cd279e19bbb4f1e629b69dada187961cede96d0fce1db35798ba4da1a,
            0x22ab7a2c7695fccbfcf351fda6bc4b7b4ea390a8b0ceb24c3ab5ce650c978eeb,
            0x1c33f86d41842e3bd6dbcfc7391d31dd52d071fe0bee5461081307f803074805,
            0x93e8c456ddfb186928f5c41be04273f053b573d323627dd3977571af46625a9,
            0x1ac7e875fe31cc6f51a5e9718cfde961d71bbfcdca837d99d963a649eb60c5ea,
            0x287ea9eaf121d9a8850a7982b9154e609413991672504a457b61a0f87acbfdb0,
            0xe9cc5a0d5bc080dc68741e7a3ecc9275962d03784aafef88623741be729449f,
            0x23ad5c430222233187fa2f1c8b3be50060805993318180d034bb96e6c6a9a576,
            0x2eeb405685cc467f36f084c20e04d2df50f4e7b22c627dcbfef24e49f64d6d4a,
            0x5bb9f368035c4ba3d10fd0361f437e19b2f153caedbde2c5b4913ddbc1b1154,
            0x2879a518f2faecece68b4d8b3eb413e95cbeee42cdb0bcfbf22de0d0caaa1af3,
            0x1ffc7f0a4ee270e2b533b1c8e01fb6d423e5afb0cc8b3882cd9c22a904f893ad,
            0x1f5ed8401c2dab3ba9056ec1de046cae4ad96bb79946caa44abdbb3813d7a621,
            0x2c9fc43dc5e853ef0a73052de6829f1f4a0f70e72e0f9b5a8314a11652d079ca,
            0x12a6773b8b2c83047f363264e8dabce52adc322909cbf1c3f3197d61bec488c3,
            0x2c3ce34f4062e89788ad591d034892afdcc26d22af3607580e1710444eb7a38e,
            0xaa077fd7a47ed4b9866cba3983c7ad3e0cb38b26f0584d65e9b30cbe0ef8fec,
            0x24292f14775e2d63e6fe0dd703dc17af630cc22933faf966a3aacb63593e9753,
            0x175a26237a1b5f53ec6a8868f709fa05c38dabb9f67bce8ebc4126f9a0200d9b,
            0x147a7b18f0a6259d4f31e0964dee1b8b6a82446314ad0df8b2c6378e6557d66c,
            0x2786248992fd9483a176c148ba8577ea2f76163c8438b7b05607830f9b9046e,
            0x1b51a3510bffe000e8e6f3040cf53d99651765dddf87779bf8598d1c581cc248,
            0x20f2c25b2817a55ebead4833d7d9fd05717c293dfb0320a4e9ab9ca8cf68229d,
            0xeb84b12bedcc6ad00838ad525afc947e7759b16e883eab53018524dd737d2a,
            0x2d1f746195558ba4cfaf66f683ddffa75bb32ccfc018b9cbf8de9d526a573b50,
            0x58f8233e42eafd645819f4019530366b0fd474315b0037e9672669a50b99865,
            0x58f8233e42eafd645819f4019530366b0fd474315b0037e9672669a50b99865,
            0x23a3883ab252cfc92dd8e3cfd9c761c7fb3e8f4e0d9f360fb36b2286870336e5,
            0x19f5c880aeea5952c48400e94ce6c02dfd71bc451e302249b4bca811c0c11f72,
            0x8664c173c6e35568432ed0edec6c0e2147ca1ec37a5b1ce77200403e0ba0166,
            0x1f83fdc98a891e68fed55e02510c019470ad6303e0d4440d2bb96ffba54028fb,
            0x1c697c78bd0a52ffce312e5e87419659a0775b5c5aa36242e5c26e88ecee0a53,
        ]
            .span(),
        libra_evaluation: 0x3cc277826cdde94252b56661b32230dc12ba94afa510ca74497151f194d0c82,
        gemini_masking_poly: G1Point256 { x: 0x0, y: 0x0 },
        gemini_masking_eval: 0x0,
        gemini_fold_comms: array![
            G1Point256 {
                x: 0x1afacbc8986182e02a2437a1de3f7f7fd57bd93644ca56d88cbb0a2f7329a9f6,
                y: 0x16b545b4c9d1718fea36df1480497f46a99bce83fe64eb147a13f8677b3e56a3,
            },
            G1Point256 {
                x: 0xc4ce03fbf78866c0ca75b2e6c382f5582c85b3322ab125c2b67cd63aaecb065,
                y: 0x9556bd287c494c65e767a65e3a90726f8d2eb5bd9603cbf12d2bd757dc277ba,
            },
            G1Point256 {
                x: 0x2e8f113a6d334078bf43196df4e02d9bb8c3fd78cf5dbbd3824fbe92701f568f,
                y: 0xb0a7f5b4b5fd96c8632e06efc5c9d2f8c2eb5c6b6a6abac16afbe122db4078c,
            },
            G1Point256 {
                x: 0x1abfce50944a6ac931cf90fa3673f9786b710dbccee8758f82ae7705f9d7511e,
                y: 0x1db1a02492428b52487768c940d7d557e09055aaa91cbce20e66f6368572e5b4,
            },
        ]
            .span(),
        gemini_a_evaluations: array![
            0x18fe2f568f8e5237f18362c37edbf0802c9c9d70ebf1081c3e540144454d6ba0,
            0x1c3cee746d4c77e3f4285cba2e2c20c162de102c78cb68234ef4b16c68081d55,
            0x558d6d03b8f54aa6aefc563c4fcb2c81ad14280ba58bd99aeb30f0eb6740ff6,
            0x90bc87426aa06974aef8d29ca6125878d88276d76c4a5c1c69fddffab520618,
            0x201e1189b1303e5e5293afa4bdd6df5b3f6aeeff77ef98ab0303e2d52a1b2251,
        ]
            .span(),
        libra_poly_evals: array![
            0x146f0c49f56a4a05407629f1ae6d514cd9f08299546abc8cfee67a7f7793e10e,
            0x14169642848c4804d20f4f3fd9de942f3dcd3d7361acf67a8df48764c956dcd,
            0x2ae4c52130f4b42d0a991d2b7e99ddbdace030bce4535f2c218554a4e265e5bd,
            0x1e852d22101f37ba87c75acf282c7bfdf21ffbdf2e54e976cd0c6ddc64c8e1b0,
        ]
            .span(),
        shplonk_q: G1Point256 {
            x: 0x18b6e569db19b833acbc755643f7403e0ffcc177333c71f669e443e5699c5944,
            y: 0x25add6d1eaf329749831d40c776bbba24d96a11900eb2e25172298b06736ba16,
        },
        kzg_quotient: G1Point256 {
            x: 0x691e5ed0bd963caafa3a57030f6ee86c33020870a8213b8dc97d0173a043100,
            y: 0xb5ef08d15dd00b0bc48ea4a87cd886415215eb1e369a08d599235cc58e71ddb,
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


