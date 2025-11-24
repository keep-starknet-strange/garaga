pub mod zk_honk_transcript;
// use garaga::core::circuit::U64IntoU384;
use garaga::definitions::{G1Point, G2Point, u384};

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
    pub circuit_size: usize,
    pub log_circuit_size: usize,
    pub public_inputs_size: usize,
    pub public_inputs_offset: usize,
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
    pub qAux: G1Point,
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
    pub vk_hash: u256,
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
        circuit_size: 4096,
        log_circuit_size: 12,
        public_inputs_size: 17,
        public_inputs_offset: 1,
        qm: G1Point {
            x: u384 {
                limb0: 0xd93b70bed2724e7b1c71dc9e,
                limb1: 0x53296549241f9377f8581269,
                limb2: 0x1208635a70289564,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xfd13d0c8f5887f0594c63669,
                limb1: 0x85adce48c9563a7423322a73,
                limb2: 0x116a3936704da2d4,
                limb3: 0x0,
            },
        },
        qc: G1Point {
            x: u384 {
                limb0: 0x9bc4b3edd4f99e6277a23bf9,
                limb1: 0xb730bdcaeb4a336cbf94dd77,
                limb2: 0x252bc7ab5dc59f39,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x5d12ef9b117d362ed1514229,
                limb1: 0x38a8bcb0511083d3b9f75461,
                limb2: 0x2fd92796d0c8f007,
                limb3: 0x0,
            },
        },
        ql: G1Point {
            x: u384 {
                limb0: 0xe806f2ebdf5b682a9548487a,
                limb1: 0x976feb73deb29579373ee038,
                limb2: 0x1b24a873eaec2d6d,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x1ed6f0c30eefc8481c204e44,
                limb1: 0x90cae77c932d2d61e4f5acb6,
                limb2: 0x131a08adef827f79,
                limb3: 0x0,
            },
        },
        qr: G1Point {
            x: u384 {
                limb0: 0x2fa50f15ee390b3751e2e93,
                limb1: 0x717d70221351eb7091a9eb44,
                limb2: 0x1ccef7fbb76e87a2,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x357265ae9de5f7485048373a,
                limb1: 0xa19963c342f93afe33e5c485,
                limb2: 0xca2851a7562bb9,
                limb3: 0x0,
            },
        },
        qo: G1Point {
            x: u384 {
                limb0: 0x35e1eb0144e574db9abc4dd8,
                limb1: 0x1d1fc420297a9a2e04d04053,
                limb2: 0xe2e489df6a14e3e,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x6185476309f49adc5ec4d1dd,
                limb1: 0x18665356dd825ff9fa5ea3ed,
                limb2: 0x7d6bbcf4d83cff3,
                limb3: 0x0,
            },
        },
        q4: G1Point {
            x: u384 {
                limb0: 0x693b3a159a0a882c32db15ff,
                limb1: 0xea8c9da340b077be6254f736,
                limb2: 0x961ae6f667d56da,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xd7f4aa77d7c17ce521bfc74b,
                limb1: 0xcf0ef17eb7738cc07a881aa2,
                limb2: 0x29b58b4d5e0a3574,
                limb3: 0x0,
            },
        },
        qLookup: G1Point {
            x: u384 {
                limb0: 0x53f9b24d923d8f404cb0bbc9,
                limb1: 0x75a8449d3d5ce8bc3661650d,
                limb2: 0xc4032c3079594eb,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xa0ca89441369b7c24301f851,
                limb1: 0xf0158fd6da81f54eb5fe796,
                limb2: 0x1084d709650356d4,
                limb3: 0x0,
            },
        },
        qArith: G1Point {
            x: u384 {
                limb0: 0xcf1fad129af51a92cd641749,
                limb1: 0xcb47ec8427fa2105de95d660,
                limb2: 0xe710c3e8fa66750,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xf65b0bdd6496e131ba203c55,
                limb1: 0xa8bef04783e03d6cee8a8c30,
                limb2: 0x24e8061804314ddc,
                limb3: 0x0,
            },
        },
        qDeltaRange: G1Point {
            x: u384 {
                limb0: 0x75582f4a5be8cb04f3e17c42,
                limb1: 0xee1263f7dd3353082fb32a2e,
                limb2: 0x90e7ca17bcf5837,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x318bb630111b7012e1a3070b,
                limb1: 0xfb8d55e633730d05b13e56c9,
                limb2: 0x15c7401082cb5751,
                limb3: 0x0,
            },
        },
        qElliptic: G1Point {
            x: u384 {
                limb0: 0x66da5cda519e3de92d102c02,
                limb1: 0x7f0b4daff7e128070df114a0,
                limb2: 0x1e3f13af78407451,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x6ab84104646771a6b85aa912,
                limb1: 0x95f9f6600f092451524d74e8,
                limb2: 0x70ec8a6f972659c,
                limb3: 0x0,
            },
        },
        qAux: G1Point {
            x: u384 {
                limb0: 0x7a42140c92f5eed93f6072a5,
                limb1: 0x91c69c499c7a78a069ee12e0,
                limb2: 0x1471f91513ef2e49,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x5a598cc16d91c97573d5e0c1,
                limb1: 0xc4820ff2751df0b4bc175d95,
                limb2: 0xcec55d4f5912cc7,
                limb3: 0x0,
            },
        },
        qPoseidon2External: G1Point {
            x: u384 {
                limb0: 0xd69738ba349a6d8bcb53fbf6,
                limb1: 0xd34ecbf237cd069e93eee795,
                limb2: 0x71988d570486620,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xac3867ec7d7eb743a5ec57be,
                limb1: 0xeeb5f681cf08383ea2410048,
                limb2: 0x1a01ceb5d64a3bc,
                limb3: 0x0,
            },
        },
        qPoseidon2Internal: G1Point {
            x: u384 {
                limb0: 0xa7af5265690cacda94ae7131,
                limb1: 0x17ccf6e4381cdea5d16200fd,
                limb2: 0x222a00990c265db9,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x44bedb68d26a4d64700443ea,
                limb1: 0x487a4423a79256ef4609b87d,
                limb2: 0x198a29bf1f6391c8,
                limb3: 0x0,
            },
        },
        s1: G1Point {
            x: u384 {
                limb0: 0x1d068bc22efbaa45b229d50e,
                limb1: 0xbb1f260d05037ffa2d5f9ff,
                limb2: 0x287d13fcda26c48b,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xfe7a9392704d3b8f447a3a42,
                limb1: 0x9e3b6b527db18f99fa635c24,
                limb2: 0x216d8dfcaa6d5fd,
                limb3: 0x0,
            },
        },
        s2: G1Point {
            x: u384 {
                limb0: 0xe36a1e03cb833f43a245a1ef,
                limb1: 0x75617e900af3632408f65424,
                limb2: 0x5094c5433394814,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x50b4864b8ef0dff1fdf20cdb,
                limb1: 0x4a6d479eb12718140f96d8b5,
                limb2: 0x2f7013922b53d3a2,
                limb3: 0x0,
            },
        },
        s3: G1Point {
            x: u384 {
                limb0: 0x5529ead61158296cfa47f25e,
                limb1: 0x45221299b8fd932ca1774f43,
                limb2: 0x1025d8b978868db8,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x50ade79fc7d6728607444ef6,
                limb1: 0x527ac455ef5d3191737d8915,
                limb2: 0x394e620db0b96d6,
                limb3: 0x0,
            },
        },
        s4: G1Point {
            x: u384 {
                limb0: 0xcd9f4da1adbb4eb263ea2065,
                limb1: 0x21687048a0ed449c0416efaf,
                limb2: 0x90a5e98f0f54d8,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x6ebea80bf06f93f7a660a8ee,
                limb1: 0x2c1261f990fb8c5ab72540ca,
                limb2: 0x1aa3ca60381e96ae,
                limb3: 0x0,
            },
        },
        id1: G1Point {
            x: u384 {
                limb0: 0x3efb1aefcfbe475d43d16bce,
                limb1: 0x12ad49876e65f9bfeb812d39,
                limb2: 0x23bd8229bd24116d,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x60efe1bbdb1c42e1f0807cfd,
                limb1: 0x66403aa2b566c907bc733c73,
                limb2: 0x2ddbdeee1f588dc5,
                limb3: 0x0,
            },
        },
        id2: G1Point {
            x: u384 {
                limb0: 0x607344a0b815b96b8f18ceae,
                limb1: 0x36c28cb48429ab0b44258ffe,
                limb2: 0x1941a2c0491d8027,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x745a72bcf90ab320d206cec4,
                limb1: 0x917c1bdafde59a745a1cb149,
                limb2: 0x1053ee3245f1c1dc,
                limb3: 0x0,
            },
        },
        id3: G1Point {
            x: u384 {
                limb0: 0x83d4af802c5e3aa54c77894c,
                limb1: 0xf5fc96d01584219044e6ec98,
                limb2: 0x23d39513e543a380,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x339ce78c1394519a37719864,
                limb1: 0xea67fd13e94ce243d8a3633,
                limb2: 0x1ceffe0e20bc00ac,
                limb3: 0x0,
            },
        },
        id4: G1Point {
            x: u384 {
                limb0: 0xdf751f6776b268e84f4f3768,
                limb1: 0xd816d1176c8ad3752b86188e,
                limb2: 0xa7bad3b189391c4,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x650b6352c0deb1f7affd1d6d,
                limb1: 0x56d960d236fa73800a531e52,
                limb2: 0x892a913f320741d,
                limb3: 0x0,
            },
        },
        t1: G1Point {
            x: u384 {
                limb0: 0xdb3f8fecd9d8bb38442cc468,
                limb1: 0x87300c3bc10a892b1c1c2637,
                limb2: 0x450f8716810dff9,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xa194086a4cca39916b578faf,
                limb1: 0x97098baa0d71c65db2bf83f8,
                limb2: 0x10005567f9eb3d3a,
                limb3: 0x0,
            },
        },
        t2: G1Point {
            x: u384 {
                limb0: 0xa444583203ea04c16ec69eb2,
                limb1: 0x71d57b5c0ab31231e12e1ce3,
                limb2: 0x103bcf2cf468d53c,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x16e0af5a9268b38a5d34910b,
                limb1: 0xed8f51217ae8af4207277f41,
                limb2: 0xc5d6e7a8b0b14d4,
                limb3: 0x0,
            },
        },
        t3: G1Point {
            x: u384 {
                limb0: 0xcbfabe968378fd68e9b280c0,
                limb1: 0xe414054241d418f5689db2f6,
                limb2: 0x187b9371870f579b,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x35f724f619bb0e7a4853dbdb,
                limb1: 0xc59d0f621604926cfebfcff5,
                limb2: 0x964ab30f99cb72c,
                limb3: 0x0,
            },
        },
        t4: G1Point {
            x: u384 {
                limb0: 0x1143e5a3c8bd587526486628,
                limb1: 0x595f3aaf837a72eb0ab51519,
                limb2: 0x132b76a71278e567,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x848c2887f98bfbaca776ca39,
                limb1: 0xfc4fb4f3b8381d2c37ccc495,
                limb2: 0x2c6b2a0de0a3fefd,
                limb3: 0x0,
            },
        },
        lagrange_first: G1Point {
            x: u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            y: u384 { limb0: 0x2, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        },
        lagrange_last: G1Point {
            x: u384 {
                limb0: 0xb82e0864add6d4d3ef15d891,
                limb1: 0xadc11aafdf37b7fa23724206,
                limb2: 0x1e05165b8e92a199,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xe46735398b7d7d3a6e8b6291,
                limb1: 0xb24c2506b31a5f1c19e519f9,
                limb2: 0x1490b97e14d7a87a,
                limb3: 0x0,
            },
        },
        vk_hash: 0x0,
    }
}


pub fn get_zk_proof_keccak() -> ZKHonkProof {
    ZKHonkProof {
        public_inputs: array![0x2].span(),
        pairing_point_object: array![
            0x42ab5d6d1986846cf, 0xb75c020998797da78, 0x5a107acb64952eca, 0x31e97a575e9d,
            0xb5666547acf8bd5a4, 0xc410db10a01750aeb, 0xd722669117f9758a4, 0x178cbf4206471,
            0xe91b8a11e7842c38, 0x7fd51009034b3357f, 0x9889939f81e9c7402, 0xf94656a2ca48,
            0x6fb128b46c1ddb67f, 0x93fe27776f50224bd, 0x4a0c80c0da527a081, 0x1b52c2020d746,
        ]
            .span(),
        w1: G1Point256 {
            x: 0x2b89e705a1ef61693daa727e045728a70498ef2881bf6764a338750973e97621,
            y: 0x1476b8b18a69e35a96d3c285b25500f5ee476b20494d7e7bfa369e61694855f4,
        },
        w2: G1Point256 {
            x: 0x1429ea6501410fadb733d8b2f13b8dc8cd7d7b40b8a5c8fcbcfa868f80791d6b,
            y: 0x6c2eb0e9e50076d6d269552ecad6e262ffce7939eec3a17b50ec665f245ee51,
        },
        w3: G1Point256 {
            x: 0x4f152eeed742601192a292019aa8f58605c136c87c687219d3cb4daf9838f97,
            y: 0x25d11aa713ca31860adbad4fb9e7f774676e55a949c20ef09d756e2df2bd32c0,
        },
        w4: G1Point256 {
            x: 0x11ebe1141e03ff24e64b56aac508a03e99cf021ab01e6d9edf138f155e234ff4,
            y: 0xcc77617a0a398de68e5b9f23bfbfd31aaf30ffe614495c55df318bfb03eb8c6,
        },
        z_perm: G1Point256 {
            x: 0x1994a144e19df660fd3d3b8742e8b99bd028582b2d8429b6eeb1c20db8f96331,
            y: 0x1f2a0bbafd5d913d648a6ecc04531a3847ebe01147a88c1fd447963028049245,
        },
        lookup_read_counts: G1Point256 {
            x: 0x2f16bc66936d3775d64a5c2033ecc01e8a2de07ba455ea3ee87db368af3c6881,
            y: 0x2ead1195ee116182af303e0b96a998bed649aef8bd174e0fb3c9fe5d0fa1b08c,
        },
        lookup_read_tags: G1Point256 {
            x: 0x1ae2bf8d35ce65cbb5aed494ed6b78c548be57945ed54da5edb7036bbf9f35fd,
            y: 0x2e2c9a8904166e6171b479441282b141851e7a9c318ce061ee662bff9077be10,
        },
        lookup_inverses: G1Point256 {
            x: 0xd21be9aa3a2fc9864e63dc41c3020883da1d3421b0a4b453cb37b799082fa34,
            y: 0x194f403b8b65d52cd4c2d6cc88fb0c660faf9771d1e22b2f31abba85a1f8bedb,
        },
        libra_commitments: array![
            G1Point256 {
                x: 0x1bdd29b0262cbc29ca6fc41cbc2e650887756f6f8c7ba177da472a0c552b1969,
                y: 0x2f822de939ee5a42ab50a6a7825401d3813884ed054d320894174a50e45ff543,
            },
            G1Point256 {
                x: 0x29fc918de1986de5ab485f7006bb35770070aa133932a9434f58da2fd114c6a8,
                y: 0x136851376c5b1fd6e48b5b2067868163f75b42232cdfe19638f20d91c63aaeda,
            },
            G1Point256 {
                x: 0x2d616f64e2b9e4f87c8e08691f0b9e4764a9688cbfcbbed012e7d2bd95dc930d,
                y: 0x9c192d808c8b981777deeb11d705eeede073d3045d2aa391021bcb050c5eea2,
            },
        ]
            .span(),
        libra_sum: 0x1ea41d302b4c8c9a57b0911b1ad5629b245f8988093ce12ae36d552939152b69,
        sumcheck_univariates: array![
            0xa8cd39c3fa59923c156c21c94c86f870c6aa4ea44a99c4050779c0dda760c8f,
            0x25ce4c50f53695c2e63a32d473752acc2a560141e95d2d26641f34898e83a118,
            0x17470df55c33dd57280b015675f99c67ebb7a078e2a02f854d4cc0c32621aa76,
            0x2f1443738c01fa337735434639b5ee06a49e8f372d41d83a8bae4c488dc1082a,
            0x2b8a3759ffc3812b44876bf1bf2331ce6b60b77aec191adf177645722b7d0951,
            0x2f5e81e059b58d96f6a394e9c321521e1ac5d2d23380219d0b4140538114c7ab,
            0xb18ee21069003bfef04baaeb4d4f56c6712282583f453a7620cfce1e6e714f8,
            0x11eafad8195cd4be6717cd3163eac605b59f4259f129028c5973c68f2fee0237,
            0x21c6941869fc69909dbe80558714736159299e2b8017510a132a198c986c10dc,
            0x2616214aa99014271c6c8ff6bcaed08924f2e7ab4f85744233714b7a9a881b1e,
            0x5c700027e21508be57da890c9f27be9a418a71e447a7322eb61ea0d298aa827,
            0x873c9e21b7837dca91108910cab0b764f59c3ee17c80b9e6e92ff29462c906d,
            0x3367bad7e661dcfd7f63c8a20790bd934e2e80873d2685ebc553563fdfde5d5,
            0xaddc370f9593ee7e9eabcb91185c6e5ff25e0b5eaabd288700ac1c16a973325,
            0x24a50ccc289a4a4e88c191883f9af42c3ac8af23c6663c47928de67741b3333e,
            0x1ee990f79c859c75bf83287bce5b252918e6f89a1246530f51ed9f2a47de3552,
            0x2d024016477f737f16a1d86703dddfd857db53fbfeb439907626acef47dee300,
            0x26f91c65ff88dacce0f43328412f2649c4aca4fc6c6be24d306b2cf3af0fe1a6,
            0xe1c6e2d881a2aa5088301b6ddfb4a4eea72e8855e875e68dc980fb2c2baf47c,
            0x28d647a5606c9ff8710124644f5bc71735af9941946a6dd8e1117f8972833490,
            0x8b98843b68c2e4abdadb0b13e4927089c2717e7834ebc8612f64b5a4a02d5dd,
            0x21a8fd86e9a150c30861b66c66693c7bb1940ab77ee62ce0ab2b74cbd6dd4b7f,
            0x2bd4f9fe125b61e300b7476a4a0e6741d36ff9202eb7dd78053c5372965a91b6,
            0x22a79513b8f2ac13e6c86ff1f69f4e1b081e03875bd2d1b8f07459a43b4bd84f,
            0xee07c7c0610b6a0ea5d4752a1677b2b0526e7a25e3d23382c2a0a264b0758d5,
            0x10ab4ab05e98b33d6d07180d2b6d8ab5e06ccf98c5715edbe6314e4e433ada6b,
            0x34680c8e53a197c1ac4c638d2c21ffb0afe3aa040d8207e369dbd65f1a11451,
            0x13ecea95103e632d27c1e35e2624b6dd45c5276f689100b608cf138189349422,
            0xe76af8df1b6df2d3c2bad09b86a27985eed0fb07970c9a1830b14d8e755b103,
            0x171ed4174b654f4e48df189b255eda7cf55f765bbe8219865a013d606533028b,
            0xdeacaebab80a7cce8c57f5cab86f4af40a75bcdbc9236eb014c645140600ec9,
            0x2a8bd2cfbf4310cad938fa59c87068d6efc32a5c87b17db680c355f40da4d758,
            0xb84311160647cec7d718b8e15b1aed7d047e253c55b17c893c7a8af610de66b,
            0x5222ceacb9af8b7d0ecd07725d6b6b9fd83281b4ed0722cad85aa954782ce09,
            0x8227c162ba324ab559ecaa0fdb18b0d6bed94e4a6abedc1313a421e9333faea,
            0x1bb757b005081ecc455b1398bc20f13f06031f9dc103cf9ac810c9c5a1124a03,
            0x16ee82807e44b301cb54ef5cc62b5bd361c015748e7e6e40ab826072323d4772,
            0x57ef2a69ea3e4d7ade20ad69f11bd50b2590524ddb9098aef482eaaf7bf5bdb,
            0xc6a03e1313a0ef736c8c7bab768a01e23ed6532607eb65e2e1bc573bdd6b4c3,
            0x23b2c1f4914d88242287d306de71ccd2d5b3e2175167986dd37db32e3721a366,
            0x1345e0bf7dc2a82a8ef7f0a82320e122324ad43cec9518d1aedf9ef736b0a9f8,
            0x2260ae6dfdb7f28faa154c20eab7d6db1613b0512414926bdc64993d84dc520f,
            0xeb7a39667e7bd5c4960b91a1aea20a48502fb05bcf70cef20bbe00149ad5e3,
            0x243242dee1ae1797670f6fcc8449898ea44ad411ba28ca7e9009e4aaecaa3b5d,
            0x58bb42e8ca3efcba53a276e1320d9093085dae22283119339d6d03a88dee701,
            0x1c111072a49e1b6064d427e591e192ca7c660314d5acb158d2b9f226016f88d2,
            0x24bddb48d995e9ae4984458bd6a431fb1a1c50a5dd096b907a0391df9344161b,
            0xc67244473f59a5d623d28fa100292c4030fff0ff04cdae2b71a521b8053f159,
            0x277858d5879241f0e66aa33a37c3aa1770017d3717cd8ebee9115cd48e81feae,
            0x29e06411db232136b90b1dda48a04d3cd734cdfa7ec61d05594416bdd4f9d50,
            0x19508c6ad1bdb88eaa3788c1fa7b189b080af8e778a8e2d1e612c1840f65c6c5,
            0x7b6f4bbe04e1ae5a5030cf60fec3a62743bdbb6007cb044d9baef0255d08882,
            0x1371925219cbad3d6cdaf7816e13a2e775aa25e4c4b66ec494fa35f8ac9e1666,
            0x1de110f28000ca439429eeaeaa1082962197e0dcd2dea06cdc7332e337cf616,
            0x4737d5b2db073b2b28fc0b4d5c6891c8b664eb6771215d90060c7000853bea6,
            0x254f6094c7a4a190e578fb181d8334d81960e0993023c3ebbae5462720786ff4,
            0x1c11a5546117ed5f695b5b25b1e625df1c06bbb7a6bc42aeadb6d7c1b92fd249,
            0x2d43ad007217ec6ae1af1e0a6b0ac9909c7038e473f8d8dc3ba6d8bcc8e48791,
            0xb186e0ae35ae554ba00bec5b6f97d0a73c0ebcd25583fb738e03e8237d57e44,
            0x25b8ee6f6dfbde1fd87b2ffcac88e4b58e27fb743fff1e3843c2f47338af55c2,
            0x2360df489d5b77212ba68b36b3b5a03c516e1e9176d8c0bb65c5e75e1e32016a,
            0x4a787ee0e43f98b1cc112c99e235e29931b5ca79f76c7b9114ec953a0a2a963,
            0x2887847862ad92b54313b02fde8b2f69ba660a57559b5f5c3d8c6a1d197e31b4,
            0x249bdb5f086793483e42ce8c4a5b09a2066dbb4ccfe1dfbe1688d8327035aace,
            0xe0fbe2ff3febf0b45d01ed224a47ded40030551cbca4806eb7a8d4251076a9c,
            0x9a73d4edf06b07f43229f8d1e9736d11a6baadd997410204a4a4c1c8eb3389e,
            0x29d2d8179470f4bae4de200dce30fa8d5f8729f815d7cee3b9a9f13468016699,
            0xe5c66a6b5e1b0eb7977e86e9ee7e963cbdc4142e398ae0ab90ef4cc212f4c2e,
            0x1d529251c85d47b0b8bfafc595cc4022296f8b332ddf0eb0c6d1050de08b2f98,
            0x22fff573ea4633f0f7238a5c1e84c74d5824f09e66241832074e1484d8ff4b50,
            0x1cceb788fc3139880c2e7de951471a2e3f17e792b326a899a17dba3254d5d431,
            0x24567b86cee3be311e6c8702caece5301b4800d1a0275322b581ca28ae468b4e,
            0x16d3a956b0073450b1eeaa137ec619e7d958ca0b00a6f114aa960fc1a29d732b,
            0x1420a1937dcd6c46757b4136aed89828568f8a08df26f7c7e8cc6187085de591,
            0x748bbb83cc053ac6273a913661cd345025727381a41976101f7b1d4f5b6747b,
            0x19da9ade556c26cd5c2c4d65424b5926b24621c8471c8095d27bf3c315fcb0f2,
            0x1dd8875e65b6ec050f0a19c97a0e9284718625f2cd313718c6fa931c2a05a3b2,
            0x30336dde8f8be010cfb59441df24be25e6f5428a49677676481227b58834a230,
            0x216db52cefd09d37219386a76c0d46f2f5fd1a287fd7f8d0ae3bd1c1a100b8d4,
            0x4b3e6a767143db934b8c9a349663c6d87e82a2780cf6e25d10ece2a96c5423c,
            0x6c5698e9b03b2692648e42ddfc874a5d1c6a038b97c2fe87c23a12fad5346cc,
            0xe7a90de608e3ff7c18ae7cb8c7d5aef132422067a5767215d0431194656c8d2,
            0x7378d7d09d8796e76f65acfd4b907a77958655a7eeaf34a24ed08101d85a48e,
            0x1761dda3597403c698442ff0ff6a6ccfb7035ae876e687a9cb85a92809d5951d,
            0x21e02f549ab1a59656613919c0dfe0da55740c34d38134a465a9d7269949e92,
            0x14e4ec78930425b48d94c7d985b530259d561b8d5f794f6d4e12b208f39ee612,
            0x1ce70d3d321bcc1ac4a3dd3117f48c943a479b705885a15378c497a87d4c5b26,
            0x25df28c1e53478cd20d37e97cb539e16d1d909be976b7c706349c69137991904,
            0x15f56bca2cd33a6b5324d7b31e8ebe4212775197e06c877f041c9029cae1a04c,
            0x2222276f1fe5c62bd7c6ed8f1b6a8c894a8d43f3c7782d6f603d4c4f53f8be52,
            0x1ae2986cb5d4c83b86a4c789bc1e5e04586921632bf26ee34834711a32c779ff,
            0x23b7eb0388fa54409b2de75f05c731e694e2b0a5dcaac36bc4fbd8d34d392c4c,
            0xb6861585beb3bf10c385a17017ba2dc52e6bd7fff112e310ec0c47e800456a5,
            0x2c01b40119a3496bfaeba197b05095c8c5d50b5450566245aaa25fa58024287f,
            0x14c78ad4efd02b5dadf9dbf7407870d9ff851ec68ccbb86151c0d8a7bd1a837f,
            0x18cb03904512ff6fdacc2c365d23544ad05c9842a9f32c38ca91253f231f1ff7,
            0x91a08b6a461172dbc539a33ec952936104bab2cdc730affcf8b27fae6cb7eff,
            0x1917cc1dbc8c14a56f2fddc887ed1c6a05e874277e085891da76ab24e9721578,
            0x1abfb1ef80237d8cbf2ae738e80278ee141ff3dd05be6f550cff934cd19506ba,
            0x83dcd26dd0da2bfa81b489f9b967c02d51038657a78f88ba7060e1c62867e70,
            0x235624e73e96be9f595bfee3a9a485628a39c568174bbb513f5d87357bc428eb,
            0x2a4e94cb9e076acf007c3e25fbc0e1334fa5843866d4666935e88abc87b312e5,
            0x2e30b6b477eb629df94aced055554a1d60cbc782b8ab49e1e6ae437002ce79ed,
            0x2683671e26ff2747636de3b8146bd9f81851d1034e68f742f87abb89d0676420,
            0x811f5f34a484031e7a4f878e65b7805d4ba1945b54296de1fc6d62e5b5ae449,
            0x5d1633773d9ca2ecc710bc3791452e52ebbdbb493abe87662ce9d97bc21b4a0,
            0x7789c4d9dd8bf1c589d33ff94da686c20d796cecec831b570d0eb955af96baf,
            0x2684f653589f735023c6d70d2b0afcdd9e9f863d89bd38876abdaca9a1b6e546,
        ]
            .span(),
        sumcheck_evaluations: array![
            0x2427ea56a6d420d436a43f88e03048a105bf577323463d220956cdf50e878d29,
            0x19c0b4268718755afa9e8a70a5e17e2b80b0c3c6ad1cd58e38400a2a36d095ff,
            0x16f78796c12259ea64855dda575bcdd24a41584849cd2c442ddf2f42bcb9465d,
            0x2aec8ca3fb0aad0871bc3dbb154de50a1b3b2a33771513c98f0f94bf0ae23b6,
            0x101a84be2f77e180f7c6f2fdfd883fc50f427ac47efd673fa42c0ad412971603,
            0x12bebe367eedcf1c01e664c5df9767f379497eecf39b7358507e82fd3c346028,
            0x153f53ae0dfe4c43cb5df2195ba347dc36d88c07fe55d0bffc9d4cf1dad2c8b,
            0x173b91a90cccd23f62c5466ea4db22389f22b553e1c5845663de4d8da35a37a3,
            0x4a000d536edecb1cc35b58b5b6dc9ee27d6e0d438bb7853c43c6ad50b24f61e,
            0x1c71a99b1ea9453463a33391a34dba2861a2042b9182c8552637ed8a02f54650,
            0x2271f5d0109357c34194d7d481d9bc247690dee039f6983f7e986c7963153241,
            0x1dd2e7b32278063745d8dacd6a06c53eed0bd9e2ab2d9bd3391bbd8898c4ead4,
            0x1835c9c9be66c650fc3204fd460569c518791627690ca0766320bb9abefe8307,
            0xd6d88db77d48df07427281511c284cb5a4737e15c3c2350c784d61a3dc8e16e,
            0x1e4af097c791f9772f1a52703767ca5d86be9cef4cc1361884a37914638da836,
            0x2077bc7191856ab7a5c7072c9f9cd9bc4d035790d2cc79fce208c3eab3c08aa,
            0x2567d046551c9cc7a09bdcad1216b03c36794e198de3a282ee90519137c17203,
            0x1929d6ea2913ccad72b42a2d7d56be33d7de54ac5e2ed3d114956fd041f7deeb,
            0x1eceb97cc364bf9b71aa154253144e602a1afdfc7d27c6ff5a276455c24badb7,
            0x2943acbe07388417cb906f6527bda37808651cdca2855f34e501451fd199f572,
            0x297d267548d3a5b9c17691ddcfedf589556d512d74490fda2f6343a5bceb4b4c,
            0xf0a7994d47dee174e59bca76288d5cee89540fd5413c4bbdf9b9bb340702e93,
            0x1af687b863a4775990f9bc6bf1c0389a383629460b23d994e2bcef5a42108bdd,
            0x12532297e0a15b511bbe0d32ee976fa904c1ca2bbaeafb2a49ea016d0f1d1c3e,
            0x16c404dff61d96bdb3990f32399bd4a637aef7d7c40834a173f719a6bffae9ec,
            0x1c80b1193c903ce59255c16ca5fbe340fc305da7f598f00de955144561976e7d,
            0x13b7b86dc4f8ac0a2d23e8bc2872fe37a4c2fef681c83ce9617da83ee39d9e57,
            0x18b495d305bc8f78afb7b3375eb156b16ee7bce1ae048c85050e668acea120ea,
            0x4e2f177f7cc6d2ea2738860e69ffc837c9857d42c44ac4344dd9da4d7f626b5,
            0x107a40abefee6490aff7ff7844fedf3595dec225b4bb35f6fc0bd4d849ae409,
            0xe6a72afe273129b31fcb169fd822272b0d3ea1580cac74df5e760977b9e5e59,
            0x142be04041190a8ba1e1ba3d245b2e41e04f371e514b0b80c3636d209a122c8b,
            0x2c5eae40f99df4ba4c6c139d17f0b4de3de30247b4b338c47e7c2940d8e99b5d,
            0x134ef41b13b74ec3e2e934873603ba711ad1ea1a559777ed86c5a1d1ccdbc338,
            0xb2fd6d124012af95dc31beff1a995ee20c027efba7a9e9a23ce80795551ea79,
            0x269af6d59a9da2a8c650399f72437a1c09fb6bd806b9cf5ce30510779ae5f1f4,
            0xd6849a5b694c3bd9139523d10db18910be70ed971f5375964a534b069c79ebb,
            0xe30d3f310cb7e25df3993fde70099a4a1e3b36ad0bd4fda799a89e1e9337aca,
            0x6c678c69635916a1b8807223ae0ce829d864e741ebd9acea53ecc87dc3b3f74,
            0x2ab863fed45a9881827df74fbf615f69fa6eed0f61aa89d46bbd352cc3cd0c0c,
        ]
            .span(),
        libra_evaluation: 0x1bdbaf3e9eb3288ef15e9b8f671dc2202073ffa91fa5dfe6aa6d8c83b5ff8b37,
        gemini_masking_poly: G1Point256 {
            x: 0x1f057cb523eb19bf5dd930e60afc5b8b3ff725a5491ebee82876266f974f3a78,
            y: 0x8716cddde53560372506b290e225c000403e4e71d9f68c6e82b4cdde31f0252,
        },
        gemini_masking_eval: 0x15b37cded89876641f4f160b030ce56f7b1b26f93170d0eb93ee7b435a9a2e2e,
        gemini_fold_comms: array![
            G1Point256 {
                x: 0x1692e21981e3c814575c433635838e63e6ea76d0eeb39243c888badf23c2e3f6,
                y: 0xdcec584a93f1f16266a3b9f132fd2a84f74ca5ef805b2ba83062f78a82f1b34,
            },
            G1Point256 {
                x: 0x1d0653f71a873179bcb55980078c1f53252bc57dd15969a74382b0f0e89bf31a,
                y: 0x2795b53be493e3c3a8a91f11140be5fbc607b68b7ec3ad805af83c41bc1cd1ab,
            },
            G1Point256 {
                x: 0x2ea54827e103da34b894228970e93f8133a6f853c286d81c41bedf0226818b50,
                y: 0x1986d568424e77f52db86379b6be35c1ca14785003e2b7ccb1a4b2d46a1fae0,
            },
            G1Point256 {
                x: 0xfa6b5207006f62834ee97b4320d91eff3cae9a164ad5cba50a989603c210a0d,
                y: 0x1b2e3232f805aa62bc45432cbd30c82929d0b42900fdb2e3105ef2cc11849aca,
            },
            G1Point256 {
                x: 0x2af7ed17b1d7a77ddbf8c4aa076efe1dc902d0ddd09a1489bb3328c45ece6254,
                y: 0x8fef6cb61f06b83f138654ee6c190b83f33d56b6bcb8c81b778880714cf5187,
            },
            G1Point256 {
                x: 0x28b58933dfd476b50807489778e12f1e5bc78fbcef9f416169a583c77416f27f,
                y: 0x2aa50b92a26a8553cb2c4c8a2678823ca1e1a6209061e0d2c761bcc3437a0010,
            },
            G1Point256 {
                x: 0x65718e4c88697efaf879439bdba22bc9abb248d18707dfa9c54070ff295d8a3,
                y: 0xa68c81848acf5f6e5ee52a09d9efad02b8e4026221d2cd6ca82724a22e1889a,
            },
            G1Point256 {
                x: 0x5a13496e2b74957bb396ea7862840db6d11f86396d92a375d21b12e99adee38,
                y: 0x2dbba3c2cb22300cadd125fb2596969d5496f4be07937c602ca6eab85626bdc0,
            },
            G1Point256 {
                x: 0x2e1be8a68ad1eab7ece544956d57265e6e810729914d59a4c32cd5a128e45efe,
                y: 0x2b5276b298bf305a87e9bc97ed2905bb59f09f0038a41395283fb1160a1d82b8,
            },
            G1Point256 {
                x: 0x2ce653a8c557a7dd42202f48a626351690c4a22f0af5b07692dfac12f5ed7249,
                y: 0x209d3aa90e9d31932a19fca11d0c8d95342eeb0355f0e1a9248a2819a92cccc9,
            },
            G1Point256 {
                x: 0x5a3c307ad3d8f02a0712ad1726acd264600b90bd1d610df483c48270a5fb2,
                y: 0x1a80c58125e2996c4b84ff83be0926dd7bb3412748ae906bea42dd9abdb40a0d,
            },
        ]
            .span(),
        gemini_a_evaluations: array![
            0x194cf21f98026eb299aa05730e4c9adbef3d116315eff368356fc0dcb666ce5f,
            0x2972eface5061879863553911cd2dffa6d3b671fbe8932a8fcac765257975a6e,
            0x228ecfaab057221808da16b02d130e65dedec07403bb58e8b2a701f823ab34c2,
            0x20d1dd0abb293407f6e5e58105df47b3e661402a3c79f06ab223bdaf9bc856c4,
            0x25b46c13f1e8f16d80ca6925be2171246b3e49ba12aa3be88bec6344cb408605,
            0x1732fe50bf8fa7ca60c3fed6d7e7a25db7d3b866d511f9435bc94a115217b22f,
            0x13561c351ca9ea04c41f7a60c5a87b3ff2ad9e661c7ef68852ed06c20e7612e5,
            0x1ae3f9866937ca5b797042af2355f1899ea846658ac8a70394b30e65e5a02b09,
            0x187f9a19fb64812a2398b01736964b4e2ae5e6b7ffa4e6b5495b500239b190a0,
            0x15f7ccc427b5abb2ce1ebb3c8ed0a888e3627c79146ccd03feb5c03bac4a2650,
            0x1df1939cd63ad2a4441f142150a4b6091d6ee99904ca0cb5fb0753d32a9a3727,
            0x171dfc5162cff8ec477f445b3629c25cf4c434fb3387b970d62445b8242defcd,
        ]
            .span(),
        libra_poly_evals: array![
            0x791ac4f9729803c3e6ebdaa49b5fa0be6f4c99348241fc0ea91d442217a1ca0,
            0x7bea0c8297bbac94e076715d42707f73742e5fd407922811218c8a9c61b8f56,
            0x171c9dd4f7488ed9bc83b2b5c637829f8dc5e1a71322b877e7580029bc2ce343,
            0x732feb34393e94af48e68bf6b6daa10288a25ea0d5bceffd2eb353904d208ae,
        ]
            .span(),
        shplonk_q: G1Point256 {
            x: 0x13fa03d3e16f089afba9b8ca485ebd5816f859d3fa80b16687fed549b8e51777,
            y: 0x15225d297e363d2596358116d1a0fbecbe51984a7e1dc3050965530d474f24a9,
        },
        kzg_quotient: G1Point256 {
            x: 0x18085847d7424ffa55b5847b4a4302449fe51728e54e72c95c33f9a433963b5c,
            y: 0x1e3c04aec3bb3aaa95d484047dc550e99326875779065e25b207499baa0881a3,
        },
    }
}

pub fn get_zk_proof_starknet() -> ZKHonkProof {
    ZKHonkProof {
        public_inputs: array![0x2].span(),
        pairing_point_object: array![
            0x42ab5d6d1986846cf, 0xb75c020998797da78, 0x5a107acb64952eca, 0x31e97a575e9d,
            0xb5666547acf8bd5a4, 0xc410db10a01750aeb, 0xd722669117f9758a4, 0x178cbf4206471,
            0xe91b8a11e7842c38, 0x7fd51009034b3357f, 0x9889939f81e9c7402, 0xf94656a2ca48,
            0x6fb128b46c1ddb67f, 0x93fe27776f50224bd, 0x4a0c80c0da527a081, 0x1b52c2020d746,
        ]
            .span(),
        w1: G1Point256 {
            x: 0x1374c3138b0519d5efd5fbd664e91fb486d9891f5147fc6343e8676ccddd3088,
            y: 0x2b8dafa1a6e5a6972e52e2926cfb7b83de99053a29e147c62412eaec80af21d0,
        },
        w2: G1Point256 {
            x: 0xaa7cb6d8383cb9642bb0b42e0b7c46bf83820628bf079d825188d147cc07378,
            y: 0x42e1d8ee932df09b271e9c4c233e6dd0ce8c5c0d46772f074d0cba72a361b70,
        },
        w3: G1Point256 {
            x: 0xefcc4fb0ef9994cd7bb36d32d4fcba972c5885dfa5bd3c6f31c2e331323ab1,
            y: 0x2c2cf6240d102808e344250e896966e6bace08f599448f5834e2219da91496a6,
        },
        w4: G1Point256 {
            x: 0x137f02b31eb2bacd7fff659465117bbf57b4edc75ffb815089cff47a94c83022,
            y: 0x4672f62ad2f6d58938e0d733bd2e0dafa1ff00a693d7e7d38c48c8382109ba6,
        },
        z_perm: G1Point256 {
            x: 0xaa25a8a593ee50a5bf9199f8cc66aa64a3478347cd6dfdf78d0cd4fa4406041,
            y: 0x36094b4dfd5ff224cb004cd14affde2e9dfcbac118ad00d5533f7e6ae44e114,
        },
        lookup_read_counts: G1Point256 {
            x: 0x1e2bbeb440ff07332bc3fd29a136ba36c6a64c1b11def60249217e33026d8229,
            y: 0x1f891677919d17741c0518dd120b3a6b78110f5ba00ea97b7b7f78794bcce152,
        },
        lookup_read_tags: G1Point256 {
            x: 0x8bd3581a1a13b3f6eff084e22aa83385bf25cfcb4d388d7dcead0cc9e53b46f,
            y: 0x227ab8925a49135301a18c72ae4faf4bb44d0a5cd7e3f59a352606c1db2b6fab,
        },
        lookup_inverses: G1Point256 {
            x: 0x28a1a506c1a1d435ccccdc85881b6e4d0b57fbb5b7671ac08164448ce1f7548a,
            y: 0xa08004c0668e0d28fa931fb4ac334df467da59b2171539fbb0f8b6e98c62e9a,
        },
        libra_commitments: array![
            G1Point256 {
                x: 0xe9e8adf8014f21309ea3789657484ba6c09313f59a71c2ec36ee3c087506518,
                y: 0x1b8d4c439c4382c3d3e5c19d35f82640bf1eb74c6fc1a28d0254b444a6c9ca4,
            },
            G1Point256 {
                x: 0x16add78ec634a585da2bf4908b388ada3397a04253c53b127c20cf91ca33565b,
                y: 0x2609a845e1d3af615ee7c509b0170d1d157aff23b330ceec5b20aca7d4b18edf,
            },
            G1Point256 {
                x: 0xe263cd76fa16da9add41956ad311d89281bf8e1e84d019000b104251a69a0ed,
                y: 0x2f70697466f9989b37eaa09705db9d80005a8b0efa8250f874f2b99ca32102c3,
            },
        ]
            .span(),
        libra_sum: 0xd91a14b5339dccb2d9789064e5fdf71eedd298b199f574f3c69bacf18c0ffca,
        sumcheck_univariates: array![
            0x2908d45ba0bd252c1c088984204955699e4f1480afe23826c25b5f8a8d56af9e,
            0x127be7af252bbd75d86da33635258cb8fd74cc0c7fb7b651917f8903e863970b,
            0x27c1b29c2ceaf24b62159635cae4e78619d6d5ff7520bd6e029e795bca0ce13,
            0x1a58296418b4e9f13f14e5314d06ed912826b8502c8527b0ace640b0a7ef243d,
            0x22993f050896b4e268bed00193ff19a7525cbb2fbff5cae61b17cd0279928381,
            0x37426113bcd08e063fe7cfca1311684e65f5cfe72e810d16bad02aa3e5703e9,
            0x1e20633a8a7e41e0eea90e1cc6ddb2c785ef8c0fd2e3032e6452f7487ca8a5b3,
            0x1cacc256a3e8ddc477a70612de76d124206631937085bff34467ebff8a0d5c98,
            0xf766190e80b4dfb988600b9ca7a6d6de02dd5ffe70afca0d19551136ecc25f9,
            0x19a4b35d9940fca6ab985351b7784335628034bd54b0c28371f0973a113fab94,
            0x3b8414b74b27de36aa987ae958e8f2758f2f53ef0d6c3d73ae3fa5c8548f765,
            0x2ce7ce7f1f8f2d6ff5e084388c8378d824a99619abafad427a62851db23426aa,
            0x145a6e7c07364f11c1bec5dd7af044267d93138583107c8bb01c4f971486cce8,
            0x17048f4260d383b06e2b4fee07e08cb64ea470848c98ab3ce8fb49279d84953e,
            0x2aa8633c6515d7a80ba691e61a554c4e608d37915588f0b472bd06fac3d3f520,
            0x2259534d95f05bd9a813ea508716950c768b7572208cb581a9b0bc94fd83c60b,
            0x24bdef6c7aaa82906c31d0ce91617df26a36b9eb1198ed1afc878059490e6f28,
            0x4d197cf5acdf45763ede9363767e2e2c60fd65d7dacd139eeac4dae4d74f54e,
            0x12e9a2a77afd0499798b478a676589bae6bbaba589bbf6a4e41886cdebdc25f2,
            0x2d93ebf63fff75964e32e9c97489cd4c79804e90a06cabf82ac91f350e23eaf6,
            0x931f1eff188950d5d96ded66a0ce41d92f00ba5bf2163c4d60f2dedc9058690,
            0x2968331545a4cdfd687169c33521566d7fd80272129c7935a5c4cc56ebc9cc40,
            0x2041123ddcce32280e15d70cf3aa797336623b47cfaba7f776127e5e6730affc,
            0x58a7f1ea87963b1ae0e7708af2042427b01985621564b07c07873164cdc4a6,
            0x28288680081ba1296a9ec56edfd8fa8a1e6f506176bade75c78e6a0ee7495e06,
            0xbe2cf22503627f7645349461037795fb4d72f6e41adaf44dca3c19fc435faf8,
            0xaa514c6c76b5f528f416d8b3a01683912eb6047274e793f5ab0873e6f60edde,
            0x302e41f0157a322416f131fffe8f9c493e3a6be80cd4226dda4687c4593d7e0c,
            0x1b0f5ff401d94916fc0f5192914ef1c9ec2e0e4b93ea8334ddd5c52b41ea4a9c,
            0x1bdef2bfc542bdf2f23f6277e676b4c7ff923f9294d8202267cd8323c81c5fed,
            0x1c0530bfc6a137b70f3f0da8e77600a13bba65c5897cbdca9b003848f4a91d19,
            0x29793aaff26f5f6cc31f0c54ea9ece4d47bd8888eac68ec32a3412f63a45443,
            0x504ecfdc88b5b0d5f209ddf88860a61810f13d0b21aaf8f5162a3a1bc7b648c,
            0x1a7013ee940b4677d26325f58d4a75cfdce9921ae549aa014846bfd4c69242e2,
            0xcfcf9b2c1b451d016adee2e81a38faa944f9973af71bcb842f90206df917915,
            0x1a3dc0a634728dab38a9d172768d936cb306006cfde7b697097ef1bbc7ceb33f,
            0x7bd2561cea9647ecb0d6d540070ca7ab9f4aa12b945f859142dec45b3538230,
            0x1cdfb9db3e82f643db1a7aeb6a09c9f27e20299ff93fe5fd97ce89d120b81cd6,
            0x261ed24e153aa197c518b06f6e1d709221735af80195bbb329825a9ae2d8f5af,
            0x1c1d04dd2ad82ac718144df3c3744104a902b7289f416173b3b68bab8f1cf85a,
            0x2d9f4b512dae4c886ee2de4cffee09a9eb3a0ac0e771afaec3754e10ffe5d57d,
            0x1976d3d072c2c02e00ad0f8be669beb42edc1ab6da1de0dc2848571c777301b0,
            0x28831540efbb601db51edd0624ad1af501be86886c5288414df6a01a600d5092,
            0x97a9977f5ae605d886891309ec31ff557ca4031ab424a1a889a6af5bb293be,
            0xd5795189ed9c53288831b728b3ace8dcab700077d2028ccc24ac4676b601cc7,
            0x122bfecfc2f1e434a140cd43fa83387438dbbcf18fac9d95eb408fd22c8c0b4,
            0x28867cffb89d873b349ca552dab48f3c566d1c92bd69387a4b1c79c38474744c,
            0x1b39e3edd82a0305f6e9bfdf3c98cb49c58ce0ebcd0ade4fbc2a5ef1bfbb072c,
            0x20eb52336e3abe5f64978727e13bdd3d6a73d4015d0bcd1a762eaf398e6525ce,
            0x2c9c1c892889600776995266782fbd4f85310f0cd42b337723df84a20902132e,
            0x280421ec36633b2b6ad9ff304adbb5db2443d5459c4a63603dd06fba61f23812,
            0x23a2301021f3d7f1c50eda3499b8e565415d6898d5ed095e693198f66080c208,
            0x20090bdf2fdb43095ff48d8da5c1ec49adc884c2edb6a91dde260716dbd2de71,
            0x13869bbaf9476540a5c8fb2a181a4b563a5c0ba0adb26fd515106bdcc323945c,
            0x256fb42c64fe2fab5931aa7091501a52d748c1b96fb87ded220cfae54d35b147,
            0x89d0b3e99484835a4f926cc4cb6519c57458e0f6598fe97b1291ee93b4ff82a,
            0x17e33cc2f986df0799e9c65321696bb8397793475bf3c68d348c36957482f2ad,
            0x1d14a32fc76407a70e61cc93a3187f003049fe44fb6b090b776185dedb84aeb1,
            0x2a127606241c2da89f93f51504d9b2c7c6f092b26869fd36b092500c3e48d7c8,
            0x277d075e18e567fd535a4125cc11b1cf2030a8a74c564f2d289615e26a883ea0,
            0xd7c2013d92dc66aa39eb09dda68c7e1a6ebdff289b377a3654f513b8cbb7b76,
            0xc44cee9fc44e0556135d545a4c84d4557dc5457fb4c59e597525ad80489143b,
            0x2e8553fce6470f6ec3397f11e9f9b5da888803e98879f1e5aa3b34658fb0f5ff,
            0x2c13abb798061df42f754783f7c27c5f7eef2f873e7c4cd725dbfd560812372b,
            0xf97a9e79f0749d865cc3404f85ee3567a0ddd0918e61a0febc93d4189dbff9b,
            0x1456008c9299d157a31b02245c27a3b99578bf35afb2972c87e99a4cd2d5777,
            0x22f124b1cc4faafc4c2a0badba5933e6e134225a31a42ea2e17a44e76f342301,
            0xa1e5b171716d080c52cd81bc654f88095699541a8a9cb0e1def036b5bb5c8f8,
            0x115ab2e20937bdbd9b74dd19129ff226b7eb94f0a5e52be3356f406d705e7cf6,
            0x7ccaf997407f4b7f1d146cb12a712739d2665641a2122d6e66d5dd3d758b93,
            0x2a304291122768773f6c244645d6afb5ecd0029cb4bdfa64c10a4948722c7faa,
            0x3832fb6a8c05f3fdff4f0e48b381214afbbf7b339f65773119e793454ff3b16,
            0x14a00ee11ccd472ec1e98a2c5cccdc7904bc8bad9bf0690a7d367453fd2629de,
            0x190a9e6bc39e3092430bc79934f3c8dc5f2cd5b6a3c3cdbfe20d7b14e251e5d5,
            0x111688ec34a45fc7f134bccf625ef4cb6311f821759397180d94bdc0d68b1bdf,
            0x11fb156ee82385cec727dac1204c01a567224473dc52c9f7cb7d66e361245f7c,
            0xdc7bd77fa47df99d25006c0993017656583c69a16d18db0ebfb5094af7ed78e,
            0x29a05abcc98164aa28480dac8991e2c001f84e6e3e40a1c187a2712282e47f39,
            0xad1d0c8644b87a26a78fa1a531f06ad6cfd097f0ae9ac249e1a2a4d14688ed6,
            0x2d79b71c0d8904ab328e2afcd455741ab7b5df6acb999c38f4d4de2998214f45,
            0x82ea6e31ab690e477c2650d37dce28655fc0ea24d74c10a064073a7baf8f5c6,
            0x120ee22bbe03da612572477fb1860cac3ccecd963449c5b65b8fab0e07a14c97,
            0x59cc56ebb51e18207000ce782248b07ccb3f70f7c62c9bdeb93dd5b615f94f1,
            0x470da4fa52fb2c868080527e2f8c186ccbb5237b56b8b307ff8c2e64f70009f,
            0x3056607edb1a5b2fa40def92aa7c3ed903ba985e64f905c3751b4db4227b32e4,
            0x96ac51861c308247a75852d747a6cc38615a3131d74f83773092420cb94228a,
            0x25425de7a34113815b8c132a4243138a52cb2f9cbc947b280ef9fc9702e1ddfa,
            0xb2debaf8af6081d092e0d862469fdfa2e118a08b4b8516741335f1436f66e24,
            0x1f36825988d018df42e52f95ad2df9840392a1a89e18e9c79a769426b7be85ff,
            0x2249b854a3623ab4e37be2cf83f8a133386ae525224e91e089ffb1e8d45dd368,
            0x7c00cccb05859c162e6f5a2c3f6cd4b6635a05dababa08e638bbd0c1791a770,
            0x19ee2b3549d8f09e9dab6a5f2062b8b2f92771b55be936b2a3f33705dcb1d8bf,
            0x10b22b1a00ce42147f114a6b25836ae4371bede040ac2896e9f8c8efc4e883c6,
            0x207047737e8737ff63e16ae24702a77a84139d5ce5b0fa650c29e691def49d8b,
            0x1924759507bc1f78bd4af03cb7a0a89ce011d1c978641d47ed119bd0d5aa01c8,
            0x275152706ad7638b55056f77b43e4ca4f46ac683948681ae89f02ff7fed5d589,
            0x2a43e10a609d3b518b5fa541b1e1406db120c46cbac563103483acd3711cd267,
            0x5a951b8ea394c31bdf1e5c9e9ed67331dd7bd290de21730a66352384ca094b7,
            0x282a37bcc99a0922c6a9854a9e56e0af0da0fb126d9e01532211925eb3cf97dc,
            0x1f1886c5a12676dcbf9e26e5abdaec50d2b914861fff4ad807b52105c33d8f4b,
            0x27e7c87a6197609d5d25bbfc254160d58a29e9951f4a4ddb9d49853890b5bf09,
            0x2851c1e3fa242715f7453d2087747f9651019c3de084d2bdc086e7ac6bca8ffb,
            0x2620f244362127eacb4898bec59e6161852c087871c33f5930e8c251cd398571,
            0x3b8cf7246df0dc0c60bc65ab11cf3d9e6f5025a76502e1f39ef6435080c743,
            0x1702c6bb27fc6c54bfc739ec6a945562829f73a9a222b50609ab065f9b56dcbc,
            0x2d08af4d70a3214cf00912777e5fb3d414b89613e48dfb0bb130b84f3b17053a,
            0x187ae111a3df0dcae2dce43795204977c314d86f9c0419c39322693d23861bd7,
            0xf422026b8b4be61aba346619023f3b74f3d0623fb17980e6c64389ff875a66,
        ]
            .span(),
        sumcheck_evaluations: array![
            0xf0e5095352fd0fb6b56198be07e5299de2f93958fca027dcc2187d1ddfa29dc,
            0xb51b3ae1e776c84b419f3b08fa4bb8ea67c3e28d6f0ec12a25659292b1d53f4,
            0x1f0755d0902a6af2c3f81bd46394ad7997b5fcfbdb605af941bf7293365b70da,
            0x10404314b7556f6dfab1b5d792e6c6f705edee6e9460e5a12b40035a0c07ab97,
            0x1363e538a1e743b788f40956d71c7b1f4a619008d4d79c047bd1fd35cf66a79a,
            0x1f9a940ab906b2450e793c3783ad33195afdd91cac42d67c53018a4cd9c61476,
            0x1b126c18ff9f11addaffc7e0dad313517bd411e8414b35898d980e5cf03e5c7d,
            0x206dcc864332c0627b1965786ed6f210c9224a0645629d72c9b50b830e20b30a,
            0x2b750010e1fb870aed4eb969994f2fa2b467d9caed563d101099aa1a6ef4c940,
            0x201d2f36a3906b581a034d55ae01b74d9e7c02e00182d645801bff51d6fc9e74,
            0x91b8a9fb5cd282da8565c8620509fa397582fac56ff59314b887867ee4a1514,
            0x28e203518e498328ec87c079ccb86951834bd8d53c8fee6eeb6a96fa786db769,
            0x1afc822d7a93f3ca3d8efdf28b840fd8dd170283c842c78e661898b5d1bf0be6,
            0x9e628a02455ef356fc95c5777efe3e7d6eeb719a0db14b2cd8d54a27cafb8e3,
            0xd6faa265370a6d71aa5308eda7c58718356b96efe1cccc31cd87c48b4f1626d,
            0x223efb87bcf32f9d28e8da877e2e1a11d5aa8af3f8e0dbb4a263f1874471a5be,
            0x16b5f52821fc2e79747b9f4727933119758c65350f713da66966638318b28ba9,
            0x1e272cd058da3f8204736927415994a9f2871263c71a4b4596ae4416e0f3d8ef,
            0x9c6d5ed0636d51d69eb486a53f7abaf6b0b2c925c2cb78a91911fd587a7b046,
            0x268df1ea83e450bc0560a252c51708a889325ae7b38870efd419843395a6005a,
            0x6a0cf4dd9564b4d971a22c1fc13a3338d399112f8fa1cd38635135f0907f2d5,
            0x183e6fa3ad5f6c39773236660b80ce713783cef64592c254d9309c50cbbfec4b,
            0x119b9a429d8a33d619f7617b4f950e3619becc6bff4ac874a4fb61f1beaf6e8a,
            0xd68afbde1aefaf760747ff50282fd077637124d6f6070059716838aa8cc522e,
            0x202f3624b081f82359cb0e06c6bedf6cc3a52d501f9a8fb52aa82173593ec298,
            0x4ee5e4ede834f1d39642fc65fef453f8fca8252243c19235fe679ff9a07d1ab,
            0x1f0e5380e4c00f9b8c3bab8142f9f7e9126b27323ece294f1872411fbe53301a,
            0x3ddd670094eaaded5019441afeff597834f75d34a60b952157c38d612c44a6c,
            0x304e1dd2adfed4141a77c6d65c32ec92f7d9de70f2c5d8dccd319cb061c90f7c,
            0xbda1f80cb16b0adc6055169dd7ff4571c6593c1edeb768e72b10ebbfae29aaa,
            0x161582cfc9662d3c4d2453098194e8979c9ab339fa0564080ac683204e49957,
            0xeeafb8ec178c10a82a6cbb252a6f2e428171f57d98dd1c770f34814810c04d3,
            0x2ade76c97975f32c864f25f67559312d324fb0b6091894fc640b977d63a8dc24,
            0x2521a95d3bdd70440a884185417844bb0fd8f45fca56b447da369407e576dbab,
            0x23a63fd5e7d49b7696b87ecb5025d2e4befb8e96061115018acc82c6afff733f,
            0x1c9652c8a10a4c108b0532e6ce00846b7c2058ca9a3dd82cc31437a5016ceaeb,
            0xb1dec3209cd3f0834e4a18ec8bcfcbadb60d4d08762ed61d1ed14638d5f4274,
            0x1542b7b94f8e09b0081606d7ce14e07c7c0a29f29b89a1c5497b8fce8ebf7bfc,
            0x2232dde5235f4212b9365ba7e4bd9fde309526b99e90a6365a6baf9c9d08b6a4,
            0x1d23f8d54bc288d4ed217ecd7f29097658a0b96b44a035d378b480b8a3a09ee1,
        ]
            .span(),
        libra_evaluation: 0x202c0fbb336c9d0c06b38db6126717cf2ae0f4c3c4059ae9741046ff928eff96,
        gemini_masking_poly: G1Point256 {
            x: 0x183e50f0e0b2386226ddf3fcddebdfdf2544a97e561042c0ce659b09986ae829,
            y: 0x7d0361e38de3c7df45203902fceda988aede7c65ae50d1227839aca80d0dbb,
        },
        gemini_masking_eval: 0x9e7b1cad45db45c9e9fa8829ba2a8399b18bb40fab9973879c1f3739e482d20,
        gemini_fold_comms: array![
            G1Point256 {
                x: 0x352abc2d47f01c3d742c0c3ca0c3aabf6bd3c49b77688a885ebee06a8b4510d,
                y: 0x1eeb196be85ef9960e97cca08bb61b1af3a3bae5a9eb5bc98f52a1599a158347,
            },
            G1Point256 {
                x: 0x1f33b963a53c15e0ba94e4ef171b69b765742360ab400feef169826a3dd4f79a,
                y: 0x11b2e7ff73300ac61ea211323d7497199be785fb8f3b096ed6b879f67be89bd5,
            },
            G1Point256 {
                x: 0x272a283a4613c652f259b32302771f5b77dd79384c43ac2aaf8c1a3124adc7a3,
                y: 0x420c0c7aa2dfd9d5ede0a9274db0746026219a7851365565bc8a8a7af75f7c3,
            },
            G1Point256 {
                x: 0x17e168186d5866a766281f1cfddee1143504cdb453d0bc74a17ab709998d05e1,
                y: 0x1316af21682e6bd8761a82be751ba2fad4cf94c69df61405b079bb2b20e57d5a,
            },
            G1Point256 {
                x: 0x23e044dbf1883a63f9910edf36eb76c72114b3f4942a5bf070adef5e79d30ddf,
                y: 0x17c14a3939fa7cd5cd30a377dc5e0a6273e36cc17684bca8a2f6e1f7f4772642,
            },
            G1Point256 {
                x: 0xd70c91626f8d8410d9cdff2171c838afb6cc418b26c6f8530217ce71763a7d1,
                y: 0xb60f30fd180dec10f82687935ef9709ddd65cc61e4fc6c26464ecb4813cff35,
            },
            G1Point256 {
                x: 0x73911d30d2766d2981429c11aebc52d7eeb4b4a6a2ba3fa96fbc29ebbadcb97,
                y: 0x29d0553dc6a7ed4ffd77ec2547f5830db144f3917984d2dae22bd3900f841ad5,
            },
            G1Point256 {
                x: 0x1f00b8a0933b34c1a11f03c35b04c134b852892f5036c9a0e536bafcd7dd4b3f,
                y: 0x24025b23dacad9a1a80fce108ea402e17336e6ea6ecf26b57841c2a51303536d,
            },
            G1Point256 {
                x: 0x1e258a1ef4426d86b68d32d17ad4d4dc8b2d94e18cad53dc1ab7e2da10cb2426,
                y: 0x1eca4af7bdab2bc86ba1c455d25a70323e736c53882f1793ddbd8a6d382c657d,
            },
            G1Point256 {
                x: 0xca7af01d52e4710cbfd0132e3d3d34dafde64be461eacf76e73c47ecf803af8,
                y: 0x2bc162d5cf0efd1f7038608562bde87883cf27a1403c0095e5c33982c6b2755d,
            },
            G1Point256 {
                x: 0x297ac44a3a09bc428c8ecd71072db00d8747c85ae781a034f51e40d4f05d42bf,
                y: 0xcc4eaab26adc8ef3b703db8c65057e03f1d25c338547fa35fb09d3f0f58e154,
            },
        ]
            .span(),
        gemini_a_evaluations: array![
            0x18a6d2754ffc77f4ed999d38695f0fcb41e4a4cfb586a8c7be781a222ff84371,
            0xcb71d4e90f738500c737daa763417e7f1846a98fd6f36941119c40377511f3e,
            0x21fc81d637e9e0292aa5b37981af4f6ff10b85a1c9631ad96960e8dfe80592dd,
            0x7d1acbaeb661c1643e09ecc44b33c39fc507cf6e2240858da9d6b088a437ad1,
            0x195e43509444a2b1b7b96e6971881f0b3ac7c8c534675cad557dc97b010b54bb,
            0x278bc1c5af6507b3518b244007faaa3d188893f4b0547a6322723d1c7ba24b43,
            0x9b6054442402051917aff594c0fe1e92553772aef60c3f52f4b619d700a8ca7,
            0xb8fdf31f038729a4effa1af84c2fa15315a677f5a676ebdadaa9392352bcd3c,
            0x1b7e4ff7eb9222731cdf3315886097ef700d74093d919573c001c4d8155f60ab,
            0x1ac4af393aa43cea1fda05495d06c21240a119cec8cf1c1b51e6dc44c9d1405c,
            0x2bb20bd1b8949b98ef68dce6b685e28670856b591b3c77f75217e8a840834e19,
            0x2b338f06734ec8f5b0f833400a45e0b476a56eaaa74fc9b38cd73dc3e46a468d,
        ]
            .span(),
        libra_poly_evals: array![
            0xe9602abb69ca307a7ee975ad34435806f5557ec2217e011b1bf8c9835a7ad32,
            0x2b67d7f76891c2902f81894093a264ab4068bf642e959d96efa915357b55e1b2,
            0x13b61c085fb9afeb18fcf874802abb63ffba7af5c9c470cc20fae386efdff53c,
            0x2cce35fa3459a2fb1b6018852a9ef81122a1cd381e07b6af4087f6ee742584ac,
        ]
            .span(),
        shplonk_q: G1Point256 {
            x: 0x26512e38637b2fe38747b4c9dc6cdf7aed41ccf27e967a066dd5b38e95bc2006,
            y: 0x22b05b2ae95360453513af0b28093699041b8cdccf181bef7f7add03e5eabb6a,
        },
        kzg_quotient: G1Point256 {
            x: 0x27acd49f4330e08eeb7bca86a33af8f4dc56782ffdcd585858144ff659d86f8c,
            y: 0x2be8daeafce917301e6c348c2a1675aad60a7614158a8fc9ab365f49d6aaa880,
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


