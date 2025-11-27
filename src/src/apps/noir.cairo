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

pub fn get_vk() -> HonkVk {
    HonkVk {
        vk_hash: 1655602901159187576028713697867454584902070339986579942408953720408510516376,
        log_circuit_size: 12,
        public_inputs_size: 17,
        qm: G1Point {
            x: u384 {
                limb0: 0x1a11b55dce82f38413640a64,
                limb1: 0x25c78e040da5a5cbe6f296ee,
                limb2: 0x142bd66bdb7a2bc1,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x3dc8a5d19d0bf85b0fa95ad4,
                limb1: 0xaa34836fe60428f70dee9285,
                limb2: 0xd1415082e63c88e,
                limb3: 0x0,
            },
        },
        qc: G1Point {
            x: u384 {
                limb0: 0xcd51216bd8c56683467cd704,
                limb1: 0x7c77ce4f20f0fd5a3a264861,
                limb2: 0x2deae537974aa569,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xa1179c7a8ed5c59a1015e784,
                limb1: 0x714496966bf5f4374fb6087b,
                limb2: 0x68627460599c3db,
                limb3: 0x0,
            },
        },
        ql: G1Point {
            x: u384 {
                limb0: 0x36d34df5c2aab80f85a218f2,
                limb1: 0x864a67847d46222c9aee090f,
                limb2: 0x6681df238df2a0f,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xbc5d11d2d55e4ac8adccae27,
                limb1: 0xb9c1b8da3c671ec025fe40ee,
                limb2: 0x18e37167fd19d013,
                limb3: 0x0,
            },
        },
        qr: G1Point {
            x: u384 {
                limb0: 0xfe3f9cf39c6f73896b06e821,
                limb1: 0x3dc4669f3d97f847e96e4bce,
                limb2: 0x177c7a07701c29d1,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x7c23cf6fe4a49a8e4f4c5aba,
                limb1: 0x38f1a638b192ffc9b995fd68,
                limb2: 0x2d31ea12ba12ee23,
                limb3: 0x0,
            },
        },
        qo: G1Point {
            x: u384 {
                limb0: 0xd8b0a3fb6597416a145754e3,
                limb1: 0xac68b01fa7f3faaa5a881854,
                limb2: 0x2d623ef9f6f62903,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x6059e6db24a7e1bfc51be2ac,
                limb1: 0x52b442fa3ce1643a24c7ac8e,
                limb2: 0x20b75671e0dd20da,
                limb3: 0x0,
            },
        },
        q4: G1Point {
            x: u384 {
                limb0: 0x528aeba6bdb01913c3236ff8,
                limb1: 0xe2edafe7a56dfd287d677b48,
                limb2: 0x7ea8dd8b4d3fd18,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x853ad38b76968342e932d84b,
                limb1: 0xe23f777f35827a35ea2716bc,
                limb2: 0x2826602478d64dc4,
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
                limb0: 0x1c518c7ea0b38257198a9523,
                limb1: 0xc2c72a3c00da41d4c7c7b6d0,
                limb2: 0x3057f9cfd5edb0e7,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xf647b842154c13fa145167b7,
                limb1: 0x6a98575cedc65ee5700a7148,
                limb2: 0x27eb0839ef4980d,
                limb3: 0x0,
            },
        },
        qDeltaRange: G1Point {
            x: u384 {
                limb0: 0xbefcd8cd631818993e143702,
                limb1: 0x3b9a8bc08ae2fdbd8e9dc005,
                limb2: 0x1775fbd3ba5e4316,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xbdde06678d3bce4455d2086f,
                limb1: 0x9e409fcb2e19a72238c07631,
                limb2: 0x1d8011ee756abfa1,
                limb3: 0x0,
            },
        },
        qElliptic: G1Point {
            x: u384 {
                limb0: 0x990b1eaa86226b3574e5c43f,
                limb1: 0x50fb0eae1d72783faba96bc3,
                limb2: 0x9c706e73a00d844,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x9b1f547ec36638d7b5a1ecd9,
                limb1: 0x68fcae74683a84de1084739f,
                limb2: 0x276d401f1c0f9a26,
                limb3: 0x0,
            },
        },
        qMemory: G1Point {
            x: u384 {
                limb0: 0xc20dedd7ff81c5677d3286ce,
                limb1: 0x276f3537c64334419e05b13f,
                limb2: 0x12b12523f7d04a83,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x4e602d1c13a77a2472f082da,
                limb1: 0x55a526829445f3fda95e243c,
                limb2: 0x2e741be4fe42cc11,
                limb3: 0x0,
            },
        },
        qNnf: G1Point {
            x: u384 {
                limb0: 0x5526834f93c6db848d56dcb0,
                limb1: 0xe4e8e364439d0abba02dc62a,
                limb2: 0x16a1350662e14b4c,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xb2e746ed0b6e85782c26040e,
                limb1: 0x9296d71489889503dda143f0,
                limb2: 0x563b1f480cad906,
                limb3: 0x0,
            },
        },
        qPoseidon2External: G1Point {
            x: u384 {
                limb0: 0xe4d88b5517e40b2a0133f401,
                limb1: 0x42f6c756379f231d5f472088,
                limb2: 0x20e1bb3056279dc3,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x2c8d1a5a6b3bd0ec93b42e77,
                limb1: 0x9eb4da763de77062d23ce01e,
                limb2: 0x23ee36ecb11b6278,
                limb3: 0x0,
            },
        },
        qPoseidon2Internal: G1Point {
            x: u384 {
                limb0: 0x19d18424d0e92f60a31671d9,
                limb1: 0xfdda50b3205d5aa4486b6325,
                limb2: 0xd1611c856951969,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x94aa3cadd7cd42e719521e0f,
                limb1: 0x30c0b534ea958de4c47e2f4c,
                limb2: 0xce97ee59d45d762,
                limb3: 0x0,
            },
        },
        s1: G1Point {
            x: u384 {
                limb0: 0x1b074244b7337b923c097eaf,
                limb1: 0xd2ae3eafb3800ee0eaf997cb,
                limb2: 0x154bdee4123a9946,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xf34e2352250dd3fb63d6d8c6,
                limb1: 0x3c0953803a3a34d916eefb5b,
                limb2: 0xd5f22b8ade2c19f,
                limb3: 0x0,
            },
        },
        s2: G1Point {
            x: u384 {
                limb0: 0x111168b4d7ab689558c334db,
                limb1: 0x7c62cc30718076db1836d9e1,
                limb2: 0x22d2dd0a34c3a1da,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x98a26842094b80c6e88321bf,
                limb1: 0x243059518c261a4137e7f6a6,
                limb2: 0x262c701396f0e3ae,
                limb3: 0x0,
            },
        },
        s3: G1Point {
            x: u384 {
                limb0: 0xe1213cb7ef934c944e4e8374,
                limb1: 0x84b08b441d010fc2976235c0,
                limb2: 0x172f8c6455a2bfe2,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x960773bd1e8b46a6a182239d,
                limb1: 0x640beab3f563e0a2402c116a,
                limb2: 0x178afa12bf161e7e,
                limb3: 0x0,
            },
        },
        s4: G1Point {
            x: u384 {
                limb0: 0xd14c60e677f8e1897f658057,
                limb1: 0x33204ad4109fa0fbb54c4fea,
                limb2: 0x21f45516c16fcb30,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x52efc7a0ee6a29e06296bb4d,
                limb1: 0xb82792c925627d7348f0bf11,
                limb2: 0xa7a5c9f897fd8da,
                limb3: 0x0,
            },
        },
        id1: G1Point {
            x: u384 {
                limb0: 0xaa69e812f125d20848fd1c50,
                limb1: 0x621962d025f0fbb42467ce5c,
                limb2: 0x1d1934c19b595461,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x8971dba72882ee742a0b57f4,
                limb1: 0xdf91438bfa5b19a7bad0f91d,
                limb2: 0x10e15c437db6ae7e,
                limb3: 0x0,
            },
        },
        id2: G1Point {
            x: u384 {
                limb0: 0x3a6957e0c9aa54ec21894a61,
                limb1: 0x320938baa053cd1f3dccb71,
                limb2: 0x146dc127b5450502,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xfd19216bf0829882cdabebe6,
                limb1: 0x828ba063530a81a329131fb4,
                limb2: 0x2d5cbdbf9edeff0d,
                limb3: 0x0,
            },
        },
        id3: G1Point {
            x: u384 {
                limb0: 0xbe73592b0b543997ac9ec27b,
                limb1: 0x600ed91fa96cd915db4ed7fd,
                limb2: 0x1e214a8b0ce35f8e,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x5eb2130b9c574c4e04e6e477,
                limb1: 0x7203e26ecee99e2307846f5a,
                limb2: 0x214375d66b2db2ba,
                limb3: 0x0,
            },
        },
        id4: G1Point {
            x: u384 {
                limb0: 0xc0ed29b2c26f8c8cbcbd82cf,
                limb1: 0x9b46a4cf0acba266c2a9b02,
                limb2: 0x2825f908ee9357e4,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xf0bd3cf808a6d1bcd0d63ba,
                limb1: 0x8100429b213b9140ed25274a,
                limb2: 0x264ef648e6714012,
                limb3: 0x0,
            },
        },
        t1: G1Point {
            x: u384 {
                limb0: 0xa63b05df652b0d10ef146d26,
                limb1: 0xfe18040105b9b395b5d8b7b4,
                limb2: 0x99e3bd5a0a00ab7,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x7f5a622a32440f860d1e2a7f,
                limb1: 0xccec99dcd194592129af3a63,
                limb2: 0x15b8d2515d76e2,
                limb3: 0x0,
            },
        },
        t2: G1Point {
            x: u384 {
                limb0: 0xdc25d1aa450e0b4bc212c37e,
                limb1: 0x8bc01c9595092a222b888108,
                limb2: 0x1b917517920bad3d,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xe42000a1d58ccb74381f6d19,
                limb1: 0x22e6e992077a84482141c7eb,
                limb2: 0x305e8992b148eedb,
                limb3: 0x0,
            },
        },
        t3: G1Point {
            x: u384 {
                limb0: 0x400b2bca37e2b1085e924a77,
                limb1: 0x3ada15236ba5cfa60111b440,
                limb2: 0x13567e3b915c8101,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x904b434e748f9713de8cc3d7,
                limb1: 0x8f4674af5744dedafd63caea,
                limb2: 0x148d22589b91f0d,
                limb3: 0x0,
            },
        },
        t4: G1Point {
            x: u384 {
                limb0: 0x6c840d9c943fdf45521c64ce,
                limb1: 0x7342af45d0155a28edd1a7e4,
                limb2: 0x43d063b130adfb3,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x4c573d1686d9cb4a00733854,
                limb1: 0x6aff96736194949330952ae7,
                limb2: 0x261522c408933064,
                limb3: 0x0,
            },
        },
        lagrange_first: G1Point {
            x: u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            y: u384 { limb0: 0x2, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        },
        lagrange_last: G1Point {
            x: u384 {
                limb0: 0xc894b742744cf102a554d06f,
                limb1: 0x9ed4d186a2debd4bfe72be9b,
                limb2: 0x6a032e44c27b0ce,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x26660c8385d13a63d2078399,
                limb1: 0xad76960162ff0d8c34d25b61,
                limb2: 0x53396ef4f905183,
                limb3: 0x0,
            },
        },
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
            x: 0x1e34c173234bc959a7180a6bcc4400e875f693f8ba7aa39f084be9ffe2a7030e,
            y: 0x2b746f5a836e791d389755abda9fb5c9d749337fb05852bff6277a689620de9f,
        },
        w2: G1Point256 {
            x: 0xfbd3eedde3a077f81b3f6e19e88da20865e0d96ac30dcea46367405b98e7ee8,
            y: 0x2d9de94695b5f22e2e76d7bbf3c9f2574f674330802f0ead9b527154f08708c8,
        },
        w3: G1Point256 {
            x: 0x14a120ab523b85cb55ffddc33d5004ad91474cde957a6fdbaf145d18d45ed987,
            y: 0x1343a5fd555b6456db3af84e21a912c297379b278609d25591063bd444ce1697,
        },
        w4: G1Point256 {
            x: 0xeba60f911766695f96f1cc1087203076722a4275781461c1cb8512937e9ca09,
            y: 0x2531eee848f996051e53e155e72d4e2e36d6a192cef36c46d92a9d9573f5c802,
        },
        z_perm: G1Point256 {
            x: 0x2f4d259d57533bb5b04a62e10b3312b1d57c31a72daf5114e65fa1bacf2db0b4,
            y: 0x122fe61c0c3e49d24cdc6dcfe202787fbf2c12d8de5ec018c5e82491f0a58d26,
        },
        lookup_read_counts: G1Point256 {
            x: 0x1c205828426756e2d6fe1a24e7d2a3f572b75a0b9ca18b0bf2098d68efdb4fd6,
            y: 0x13d3a102f9b15308b0233b512847b2ed03fe0b9f1eadb624596edda65af3ffae,
        },
        lookup_read_tags: G1Point256 {
            x: 0x1af83bd052017a1caef1cb49f7493688e4b1d2291a8c81ee828b6d8cd5a3929c,
            y: 0xeb612b6d43562a5a959a8b335e0e8e699ccedd4331ac12ad01091ebc990b296,
        },
        lookup_inverses: G1Point256 {
            x: 0x8dfe2b0529d66494e26f702f13284b1ec31bccde949e11bb9dcf2f9204b0f72,
            y: 0x1a17d9e42eeca241deb7880a1987676cbe1043c4b4e39cb8393753d2cbb3b752,
        },
        libra_commitments: array![
            G1Point256 {
                x: 0x170915817e4884ee05a88ce77c8a34875a1821758557e2a15e451c9b44e2bf77,
                y: 0x2687de64a3db7ce4da18126d442d00cc5a4ed4220812c29b54bd3e0a13dcb1bb,
            },
            G1Point256 {
                x: 0x2be452b393768e61cfdfeccade5cdf0d1766bbf5e528b5aa1a393e49fa3e5ca9,
                y: 0x2852b988ed0d271109741f930ea0924fcd94eb67b505d4c88d47ba12d6cfe4e5,
            },
            G1Point256 {
                x: 0xd22d803fc19a867752924eb0a1cabb3d416b43cadeace3a3ebc42b49ff1ad06,
                y: 0x27b8cd7a0a74924ed8c7d07ee75907cfade7005eb42492f8519c62020183be00,
            },
        ]
            .span(),
        libra_sum: 0x90144f9a53cfc333c47451b4adcfe1c23478b5fedc99ded280b54409de73c26,
        sumcheck_univariates: array![
            0x3149d68db6edb589893c337f6fa124a4e1e21c4d04fa5de31b29889da3634ec,
            0x16d5d9a40812efff9f08eb10fbdee1c124d1d7195922927816ce778691e08152,
            0xe8a05f197b383bbcd4cfa0972e429fc5e35c2d18079035e4979223b3fa5a7fa,
            0x24f6a24319cafae3b708e9148a9b28d1f26ae5091c97c3a7fbe95c6571aa270,
            0x151107311f5801d6792bc44aea560e400de6c372dfa64eec2962b1d179ba59b,
            0xab68b23d47720b06bf7f3a4fad1958f0b036c0cea11533eea85b6831d85a1fa,
            0x26f4315868b55f723f1c2d036316ea5125f90ecf027262126a7385f4e296e2c,
            0x1eeb97671be33f66bca8fb643ab214d82cd46ae5afbb60f8a786d164f1f80934,
            0x24faae84d5ee43de3815a5be73d77e2a8600526f7fc2a76fddc7238089f322e7,
            0x18a9cb845a1fb2d9625b2251b0953b02f156c09696c3602b5286f06a4205c89,
            0x7e42892aefeaa5209c01c9e098de4e7f0858dda32bc95da8ec08ab8220e48d8,
            0x1d3592e48b62d8743793a25cca0e51e716fc09d7fd8f7d1d537ecc204d167d1,
            0x2997d5b42e40cab8d9b0f7909a6b5c5fab84ba180a0c5a91a3e0b12ebfad76f5,
            0xa419cbd276cc548aea0f9c168bbfece44382fae6fcebe2659e285655129428a,
            0x632e4f72070d900a143fb798907979956955681b98feb27169b71caca0825e5,
            0x2b423792b6cc5bbbb86c7889ee1a9caaa505797f3c0cf0d083c3c732dad38289,
            0x104a3c02a4c581859887647e5ea591a4cc9ae3ca3f6ea459ca06624a74a6a0ee,
            0x231fdb9a35dd4a8c5a6d0fd65195ccef5291f4944c627677c24ad42f0150941e,
            0xb305bdc9fddd22f488eaac6187dae6a0e115b5209f0cbab2600d08767f73d7e,
            0x22c974bf215ae21071ec73d7b7edc30d12b37737a248881d48ba8aba75110760,
            0x9b0a436158fb0f2a4888e55b672aaf161884d29b1c92fc566a4769fad1f1662,
            0x28b84b03b50c5ab8dfd459531675fddac1e9fef6747b724d4aafadd7701ad0b3,
            0xe12eed7ece4b17ed9aefa90c4f858550d1227af01f5093ea2e1194d01dd5c1b,
            0x236fd96ffb804945c9705b3eeb39af98329b94ff1e7e1120f1461369e2c1f7a0,
            0x1945bc69ae6755998f65deff579a24fd45721ac071144d902329d2811c7c7fd9,
            0x6c58d2ee567254ab86864b4652423a1a938270c740ac0aaa48bc458ee290f15,
            0x9eab94ff32c8d5e6592803954e3cbfb66e7f2b429bbbbfaeb84480dc31ba603,
            0x25c025181fb1cb6ac8b54d80d73dd505abebb610e12c4086ce37ef02781d09a7,
            0x10f6a28fb969623c13a8d03de2d64a46305a1b57a4aeea72b7bb13cb20eecd36,
            0xfccac954245c3c67536ebafb134c6beaf8068d692d82edef7071f1eec1876f2,
            0x13bf9c5b2bb484a95f0a9805abb41a5690e353315635b39c21fbd7f580270fc4,
            0x1933fed4de4ca7ea196d299d5bb300ecf9edbd3d6dfbdb64a17658d20021a4d9,
            0x265815656b600b952d2e1f1c7819ca82fca81e49888abae58687e8a16440d5e8,
            0x2ea8b4c68b9f4319d41fadb8687f840a30ad87aaa8066e57e593004f3532e134,
            0x27f0e547478d3dc127439447953643959ae08665ccb625067efaff37414a7333,
            0x16091d3d50a304b2711e8ab203f5c75058ccc96ae7805786f284a8ae4dba022c,
            0x20b017ce49f243ab96013aca53b99ed0ef64836ed7b7111e75c051c042b70b1d,
            0x16c3c2093db68946aa8daf3b183dacc7cdc72ebf291eb8eff7eb90d30eb04edb,
            0x1ec3ca15c7f742c257cedc604dd201202ce3248cd37b4005f433688199d56196,
            0x17952c04233c59b0394e7f6cb5c613807fdb4c99f77c2a496faeefac3b0670c8,
            0x2cbc304b746d10106d5ca386ff1f4e3cfc7e569c04e46ecd9d69f791f8aab6eb,
            0x1c77bd01f0bd518100a1454b33bbbdf5e4e93d6cb428894cd6fcb3b022d1e8b4,
            0x132e106c58142b5679e7006fd3c9bf8ce55ae3e53312b62a1e7a3e3a983f8c24,
            0x24a0381969a5bb634111aa3e613bf0f7f57a2b1a08cd10855a6cd50539008d17,
            0x22cacd970c627c6cd704c36c516c89566870a0f05a105b877b0581088e69b35f,
            0x2afaf6bf152ebd048ee022eb3897a2e7820c4cb8f8466df4c40755a513e33d1d,
            0x264f26a5e116d1b8167c6d90eeefbb52e7b40ee168a81ef21d0c21a275f36043,
            0x294253bdea2bf3dcd61bd93732f536a5bc49b57f9bd225766fecbdbab43db963,
            0x12d8c95ede7c15ddb6ecf9fe0e42baa67e689c3200aad123b59d1cbebc0af2e0,
            0x104510383e6234abd06c3aeec9fb08854a82620a35e45247b6cd8de461b0259a,
            0x7d219662f75b601dc2d55fd7da3fcd5a9a18f3858b6ae8a6b043d06a4ea9b44,
            0xaa4013906a98a1341f5a816f03e9e163eaa64baa846718e56b55255ab82bbe,
            0x28f931b264c9a2b1e951bb4344c1136d53c6e49d5f44ae07a93b24f300077006,
            0x27b12d853426db59cc2dbcbcc4f4f65d97f36c42ce8d1b35618cc2406f6bcc2f,
            0x121d138ad4faf57b387a0c6ceabbcf40d267ba1a57274779d30e82eebf33f499,
            0x1f4e057d79b4f5067e639ac93daac5c15930ed56fc4668633eec1e0171fc1e1e,
            0x301e110c5f4bb410002752fadb973462699f99eff2c522bb29fcc3d268838969,
            0x179b4a790c726b98fdb4e8f3538205caea13c58b21fa5e4744b5f2b32117c6bb,
            0xfcb8cf6b078413f39e5d03c9a0764144cf69674cf3e8f947adac1867ef5dd25,
            0x2405407e10a6d25bfc82bd8296581caf938d28ebcbd24b0203b5d24a56a046ac,
            0x2b50b38db9a82cc14d258e8a3d7447e56ae8525ec296898c97ee2ff8d6c829d7,
            0x27d6d4a65a494950fd8ee286c4de6d1918e30901f81185d0280a83c925546597,
            0x66a2b7ccc890a7b28d360e935e3cc649b2ebd93c65e7971993e5d4f8419a88d,
            0x577eb50c286a240c191897c73621c9a7a5a7eb061fa395d790e38bb3bf0ffa0,
            0x843ed2873262d670315de6d882611c31934d04f25e7e275ec73cc0322da3204,
            0x2a9064d23951b7392a196dfb9c89e66c824275ccba1ebdd070f95d1729b06293,
            0x218eb8c4a137172fe1ced0281376d26148cc83b728964e04aec9d3c9bc2ca0e5,
            0xb28012720a35d1fde5fc838f56b97e14e831b280dc9d3c5d2cd90f662acb50a,
            0xa0c9e4e4ae3e002615dd5c69f2165acf31c64d5327df16d46d4f74eac718265,
            0xce7ff6c1981b21a195472b06ce7d22335b13bf12e76e3070ac90adb7fd95616,
            0x16a5335bdf6596ac1351dc015c1316098ce91c57d5b5ea50c949fd652bfc815f,
            0xfe114dc57f1a2f4bae55b57b366d0b499f956da79b1b6736df7fb9dcc4547ca,
            0x147892a2bba985b7a415c2c108bb60a413581331c4aa3df48abe41bec92bffb7,
            0x13ecd1b079e18b2a84cc1f92af470baf348518ec044dc4fe416336bcca53b38a,
            0x1569b0c81db8022270d0af9cafbe881173d952ddf37c07ec2a766b6c578f37d7,
            0x10db7d41f627623b905f28baed9ae528272d131e9c899885037f7fcd8083b177,
            0x24c3021fb55a11c5833d4141c529a2166afa1d94208dad69f9ac2a19516ed28f,
            0x2e7d5fc72956e9825f0f14fb3c0fd27ffbf6de4b248773759f39a30956270c1a,
            0x2c7a64b108fe865fb1ee22323c3cab2b2d949b80d24642d131b4ff4643a9b9c9,
            0x2b3c851da00e8c3b44422c1522fe5cf884a786626c34c6e4426a35ec221ce0b7,
            0x165853d1ecaad0c5aea08d3ddc6511d174697f594afeca57a1ce8f6fda021c14,
            0x10931a4f5f8e17c9233ae0b7f675ace7d056c244f376958041579b9bf897652d,
            0x684e5cd9e7d09d905e11e660b811d2afc1e8a248f822cceb80d085e15d37c1f,
            0x1cfbc7620177d24eab2b2c3184e70d04eb289f87a0d9c141d4d820f7a2eb87c0,
            0x2471650400ec3bb9ae965ea280132cdd6db6305b1e7503648a42badf4b831bda,
            0x106f62d6823cae740320e3efa8928f916bf79cebccfd9f6e8c19213d1403df05,
            0x8c796662cf9ee1ad01ff917be730cbfde624286c76c54a2edc6d202c2b407c8,
            0x146c0f4c6464f9fb5b15300f2e69c9b08624734c2f68cea603580fd08715822,
            0x1e519b10d4404fa71f34885ffe96929ba174696f1f683c21d1f97cb04bd4d22b,
            0x1db5c6b7ffa992613926b14dc9e2d38ccaf540b28989b454b9ba6e827921619c,
            0x221294410242d3af8f43fb85acaef03ef5f25f9d04334fd7e293355f85d512bd,
            0x1943b5ae1d9f077ab778c538e49a62e7d4d28b597446b560d16e72da8072bb3d,
            0x4a9f7d95827a54eee2c8242d174c95ddc3f9d8d69507de49ca41adea8261d19,
            0xa1810218a2aa24b3aced9a70886da5bf931e5482a7eebc805330e435a0285ad,
            0x21c33cbe7a21ba6b7abfe15937c1b295bc12afbf582512bdc8bbf5655164c494,
            0x2ca72a8a3499bfe2d0eb23e7bfe3244f9125ef19f3353bdecb99957b351bdf23,
            0x236c92d20e92a0670678bd93b9a8d2ce5cd777407337dba37afcde2c73b296e8,
            0x112ae8a0c5764d4c0de96f7001857726904dab3b66324a96b9272a18185a7761,
            0x294dc118f95f01a6a77d01341801a12ea3ca8135eea4c593d0e3ab020b17eb3f,
            0x2d9a0c73e31475e0b545e497b562a3c51340e0a9578ce78019a07f2ea8780d71,
            0x16538f95bff012672df3fa422dcebc32600ae0cf100b72bbf0e5f36ca55c079c,
            0x2c141dc8ef9c6ee31c17a04af6ba16b3489956dfd601437312be4571f909a5b,
            0x231ba01c0cea4e1634851d2195e5bdff65ca184b39812e03be83aa269ba4c094,
            0x2891195c085604acfdf93ef63e535eced06d41bc8058c31c6e7ab680de727540,
            0x2cb5ccf9dc7fba5b62f47e20f1dc78bbac5741016e67df2678dac62da61c9ce6,
            0xd9c684b8b528dea680d100518355c92c9707aae4bbcdcc221c9b947864cfdba,
            0x18957cdde94d31a2b9961d680b45158e0522d6eaa79daff030d123f0fe463b2e,
            0x24df9e3fbd718e06157a9de498e0d97becc7ed30174041a90de1cec78cc74fe9,
        ]
            .span(),
        sumcheck_evaluations: array![
            0xda1f5a72d1ec76cda05874ef901ba28ce501879ad38eaf3f9b6361df206a973,
            0x1ed85d53329e768dd416a57420e6d9cb5932c1882cf4a63394634de89452176a,
            0x1d04ffeaff81057edef1460352e01891da17828af736f9f25d7e6c0f1ff07596,
            0x2c9c0a7f812b743a24af92cb933ef6fe0e57872bafe7bcf09edb1ad91a80880b,
            0x24d368974add765b0465b03cd25e8fa707aa07ac132275bd8f152648626eff34,
            0x196bc2a2c56b57e59f6a5e9f8776e01d0576858ce4790b584e478242f29e2bff,
            0x159fb5b8f9d76812eeab102d5881cedaeeb0b57e98e6b4b8466916e3b268aa9c,
            0x17208caf6206925146bbaf5ba306efd47fa53dbc3d33696a9b33194db83e585e,
            0x61d45cf35212d7214c22ff7ff9e6ef520b6773d493640fb2988550f972c8802,
            0x7b91f492b587fade1b237adfeefe507fc76bcbf5a4faafc76ecf7b0346b88b5,
            0x1dbe57d9bbe4f32165b4e6264ae69058d3143fbb6d01bfa839de3cd003a246a6,
            0x1612ca4aa2cf172583d2cd1c3a67221abecb16d91d9c4fb067b784d4fdb4c112,
            0x2266a0bca10cd57eba99438f820e8a0a91f7095831a474510110ce030d68bfbf,
            0x28a2fb53bc4d65fbd7902353d352fc3ff9f10baf0f565221ba3ccf3a02596e40,
            0x1a7eb155f45e7585bd3f000ff98c57a44f23df666585dbd04d3f881a8d5c841c,
            0x1878c1e0ea64fa025d989d85081ddb3c0b3caf1b83f950bdb746cb052f7516a0,
            0x276dd76fb0ca6fe37e4aa87d9107abd1d499af57e6bb587dfff5fd61969f7b6e,
            0x1308a2d137e657fcacc9368b5c4dc672ee358f9878dece5aff25994b9797ae9a,
            0x1f030b8b61847b35361104ae7ed473b72f57126323d35ca00189b532c7a2976,
            0x2be3abfd1d75a1c0c1c121f602ee6c51c098474b2541c8758cb98bcc1350413c,
            0x1bb5b1028805b0c1a875939537de220777403b1ef8787b361872cf715cd2c3e9,
            0x1abafb4da41750fdfbea04d59ec64bb90fb4451b0b24e30035ec08fe832babb2,
            0x1e9682feb5c4594b7acfe9fa6c8bad335e3c91d215c68034e3b46f11f9f2c61f,
            0x2658a073798adbbce5691192977b2316626731acd49565ee30953275f96d0f8d,
            0x25c0a364baa8f10aea8f4295f44e30817662f6c2e446dd71941fcfe377a2500b,
            0x185ebc437928bcdbb426d9612d876c0b3aa89b5c8987014fdd040e0de6357039,
            0x832fd6a95e9d33d53d1867f40fe6f5eb2c742c89ffe534ab5fa4b9f28e45192,
            0x15bba137e6114ef194c6dd0c4a294047720a52ba05bfb3232113fb9c03a2740b,
            0x20c8d9a09290bf43a0346153491f693ca3af127d9842fe196310bf5e3863a41b,
            0x2996bbc4aac149f9e1176c8a10e731642acd43ee45b4f39eea30502e7c7b23cf,
            0x1678d7bdb6529a27bd8bcd78df9237ce30bc8b161c9a03220b27d777694ea3c5,
            0x26e6234272e92ff6eff8e8391567528de1e1c82f66628aa2679343319fedbdab,
            0x56d249e93995c56591338bec2af3b770ed0ab09cf9b15c30245268c7c08316d,
            0x5db0360469781fab0e6e0adc65adf68490b2b4d46bc43a584694e8eaf56f65c,
            0x2d98fef4d951abf9a4724f5f960a6813fcd1b5bb0e5bcd390a8d5b457fc89c14,
            0x291453c614c83070310f7eee9103d15858371cf28460788799ba673c94eeeae3,
            0x9051b6d85fea1b22e85cc849c153074c399f81a241abea2121972ccac321fda,
            0xc6a75a540dcb928e18bf7b90d1243a7ffe96db6cdf90cdb4698ff4ada76a6e3,
            0x2ad59d311c014d11a8b906f3696fc86193cc6d228f568b45b06a7ffff25675ce,
            0x158b238a3c1c894a9c7ab11bedfe7564af3d5fd8c15c8d208c1f347ff2a33ca0,
            0x703886f358e78a25a832d65cc8fbe5367da5082435cd734f0e796576637d2a1,
        ]
            .span(),
        libra_evaluation: 0x1132ace165bbb656b51a3e2cc2afd3233ec2bec2784a63214acb8615929266e3,
        gemini_masking_poly: G1Point256 {
            x: 0x26014e34fea9af7f7811011ecbde8ebfd88e0756b5a07ddaf6282295fe8b5d2b,
            y: 0x1f82c2e2c6d56563ffcaf90b0164fed63750d10f0f62e0d436090346b51281da,
        },
        gemini_masking_eval: 0x1c9d49995b00c7ac2b1bd1c5d3c4cc9e3f7e06e37b66a4ed37fcbc212c6b21a2,
        gemini_fold_comms: array![
            G1Point256 {
                x: 0x2918d3bea258d9e87d3c1864cc4b51e2a660f22b6835bea39099e8d28b644d49,
                y: 0x1c04a1962be87e2cca7683eeeb89df859b71be6e49bb9addbf6020e1b80af882,
            },
            G1Point256 {
                x: 0xad8457e1af0a0b9c009c589dc2aa7c6ca8184e5ab3b8547eb924c051969d87c,
                y: 0x1e8136880bc80710c9746ca9ab32e1355814e73bdf996fbb95161a43212c0476,
            },
            G1Point256 {
                x: 0x8dcff84c035e66e9fea2edd57edc0299678373ccfb62264b3f9fb0fa5d85b3b,
                y: 0x299f4b10d489ce2001d7f05a1a98f120d2088abdb1f1cf6f668aae0519362cce,
            },
            G1Point256 {
                x: 0x21a02af46e8a9449d16f1359f2c0e44484388d70e838c07b826182d4386bf875,
                y: 0x1489e07ff0ea2d7ed52a64476b9365ceac3268fa3cf4a008243d92c2fa1aa500,
            },
            G1Point256 {
                x: 0x2fe2ca7bc51f9426d7ac008e8d18f0779f132c5f7b14f8a7070cff82951bfffe,
                y: 0x21ebd772c6ce32090a524a1fe16b88e1b5acb76a9f553133c15ca0a529eb71d9,
            },
            G1Point256 {
                x: 0x483d5e7e02ffadc40e03af829fab2d1ec4c3ec2273865ced6f8c9bec0db89a9,
                y: 0x24cee8d6fd9d9cd11a136c01b160e8ebc63e78fdf2b6bafc0a11ceaf0c7a082a,
            },
            G1Point256 {
                x: 0x1a3ec43fbb203ca00bf3d5206c7399ed48027170e5b4704ac969ce730e5d974b,
                y: 0x21f38a577ade9fd8bbcf3510a97c358b0c660216e4a83c368406cca6b2fd2799,
            },
            G1Point256 {
                x: 0x1466ac7fe3cec7cfc27e88415660f632b6a5651f45818a033afc3dd4066f23f1,
                y: 0xecd64b04c089455277f46b3a946046f1445674cbcb2c537bba2498f34efd7f2,
            },
            G1Point256 {
                x: 0x1dccac0dff547f871103577bd87509dfa0103188faadeddca36dea513dcccd6f,
                y: 0x8f41998df00acf151dcea7d61f38dcb0f12ba94eba520755684230e1dc43e79,
            },
            G1Point256 {
                x: 0x2201ff1c5b0bc9d9304c8fcb5ceaab7389aaaa639fccc15c99757ae33d0a0bab,
                y: 0xe817c9e51dca78ff6d0d9390884deac07919706599688a3663e45761c185287,
            },
            G1Point256 {
                x: 0x1b44c9747e5e2e9a8084ff374bedc82ee9c02079cd7017a7f3de5fe6735d9a87,
                y: 0x23a08eadc1723f6c47ae0da29880b3122be4d80c1c161955be55a7de1ef634b4,
            },
        ]
            .span(),
        gemini_a_evaluations: array![
            0x26a6901a61216f8b4252c1d327711877a6078f277643443896f1f832c6da1f66,
            0x1bbacd086d6b20ace675bf297a3fcfc6865e986c78ae9171d774d22d1242cbb1,
            0x27a5d919bb1cecac67cc4bd6b260a04e33a91283e4b9cf071399e8249743876a,
            0x2bce80ffb28871803bb5cf5dbfa65b9256e0dea0dd9449104ba26ab8db5c7bbb,
            0x252d45f8db3a296d722dc7df3d9e640b1ee375d598bbf51cd5584ed52e67ae62,
            0x12e77f2aaf87ba208a822b98f2e02a7928236fcbdc413b9bad32d2bc7bee9c52,
            0x8c56bc9d6093c8a56d94d7987331aa6cb17008b9460f76785ed2d57ef600d70,
            0x2cad2a1c5329e115d078e74b264e937adaf4e0eb1ed682424789b6ee340387c1,
            0x522e03828a6195d3279fffb5b805666a69a582c5c90b17c2a719f790f443483,
            0x247d32c70f1aadddd49ed465539f1e544b1c9dd7478b4077adf8cae1bae7dad7,
            0x1e69b320445a0e22ccfbbdb54eee09bf9bd5b293b8d7d727fe8c8e7064b7768d,
            0x2b592160911cb387fd83294230672bc528a6c25d9b3fb99417c74f7de7f197c2,
        ]
            .span(),
        libra_poly_evals: array![
            0x41fd901c2fda436051e8923e20fcc27afb24a65d70eb00473f172e9f7f9776,
            0xd794e3a56c5c5fb5f5a48ef6f17f1956ef8197b7bfe838e685acae0efcb8d90,
            0x2f4b4a38d4ecc05f39865b2b05731bde72a9c7b36e3f9cb6486f3653806a56ef,
            0x131bcf56f4b07e163b777029ef66826bfcdad7f1fd2c881d8e06f2d9b98148fc,
        ]
            .span(),
        shplonk_q: G1Point256 {
            x: 0xc1728e9f86fb53fe3befee017177d6a30a27feb87dfa78846a7fd510618d3b5,
            y: 0x67583f1cd028a2b317f924ead8e3a00884dfc6966442521972479b22d7d82d5,
        },
        kzg_quotient: G1Point256 {
            x: 0x145edb11f0b06a0cccd6233a0f9659439b7c0cf388f18aad29cbe3eb5ae61eb7,
            y: 0x1912b95a1b1811be10bd6149227d5c11d47c78b76ded7a17e4c77bd1f9b9a841,
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


