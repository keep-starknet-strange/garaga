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


const vk: HonkVk =
    HonkVk {
        circuit_size: 32,
        log_circuit_size: 5,
        public_inputs_size: 1,
        public_inputs_offset: 1,
        qm: G1Point {
            x: u384 {
                limb0: 0x4b4a44a243c68df3f358c697,
                limb1: 0x2caf35af5543a21e67a579d0,
                limb2: 0x415666cb6079663,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x221768e740f92361b30c2d62,
                limb1: 0x5669052529424eb317e1aac8,
                limb2: 0x13cfcaddb617e8f2,
                limb3: 0x0
            }
        },
        qc: G1Point {
            x: u384 {
                limb0: 0x9d99fb66b26ccca2668ae6a8,
                limb1: 0x5809ac290a982776516b8c60,
                limb2: 0xc5f79c354ff1aed,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x205ce031ec8bb3ffa1999a4,
                limb1: 0x3ee886d57c3f18044dd8b757,
                limb2: 0xe50425d1b09a4fe,
                limb3: 0x0
            }
        },
        ql: G1Point {
            x: u384 {
                limb0: 0xf241677faff2882cb6d3e72d,
                limb1: 0x4011bf5c5de9f0d417ce67e6,
                limb2: 0x276ed9e001db810f,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x460254d4d7e89a4f280678c1,
                limb1: 0x35855693b62013016015f094,
                limb2: 0x8eb9210acaa3896,
                limb3: 0x0
            }
        },
        qr: G1Point {
            x: u384 {
                limb0: 0xa2adc9afbeafb70c39377af8,
                limb1: 0xd39a5ce2f98cad6e37c844dd,
                limb2: 0x9dfb00e38302724,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x8dfed3329b09c829ee03808b,
                limb1: 0x57f0acbc1742c0934413b1be,
                limb2: 0x219cf659f31a3eeb,
                limb3: 0x0
            }
        },
        qo: G1Point {
            x: u384 {
                limb0: 0xd38845a1c80f915e96c49ea3,
                limb1: 0x2efb019aa53af0331bb4077a,
                limb2: 0x1f63cfcf82c51724,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x430ae1157ef1b6e89bf926d,
                limb1: 0x712b705ee1281d7e8de7567e,
                limb2: 0x23351d7bd3ff9c2a,
                limb3: 0x0
            }
        },
        q4: G1Point {
            x: u384 {
                limb0: 0xe72d4776353451da817f2a2b,
                limb1: 0xdf1152784c16d22ad2cce4ca,
                limb2: 0xb2cdce018f3cad9,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0xfd811bb4492143712bb9a461,
                limb1: 0xe71c478b02e81ba39e6ea655,
                limb2: 0x219f88713efa809d,
                limb3: 0x0
            }
        },
        qArith: G1Point {
            x: u384 {
                limb0: 0xed036a09ff10a25e00430aee,
                limb1: 0x7bca1b209db74fcb6f331dd2,
                limb2: 0x1405e253bf25766c,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x7bf0e438229204f58dde9e02,
                limb1: 0xaf529acee678e4cdbb8d660b,
                limb2: 0x89d58e8fb2152de,
                limb3: 0x0
            }
        },
        qDeltaRange: G1Point {
            x: u384 {
                limb0: 0x8341b5afdc0c863a59ab7e70,
                limb1: 0x7267e50bb898148ef78d5de0,
                limb2: 0x1618ea679c4ee146,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x8a49046cce4062820e5c1116,
                limb1: 0xa97cc3e75da6cff9a3659c3b,
                limb2: 0x23268ad7678b97fb,
                limb3: 0x0
            }
        },
        qElliptic: G1Point {
            x: u384 {
                limb0: 0x5df3af7487468bdfa2fd8325,
                limb1: 0xb0ccdb27df1434557e054c6,
                limb2: 0x1a11684e6c135cbe,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x619e58d7db7f2b28cec21202,
                limb1: 0xd523e9572d7f4c60cadfef00,
                limb2: 0x2a8f4fba8e6893b6,
                limb3: 0x0
            }
        },
        qAux: G1Point {
            x: u384 {
                limb0: 0x7ed60a3cda0c7db10c955c8a,
                limb1: 0x9301dfeeed1b752548d2ebff,
                limb2: 0x1469006b8b61c8d7,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x4a91df6570722995d636f037,
                limb1: 0x68ab919e345670ab029bcbce,
                limb2: 0x19c2b11ddeff8ffe,
                limb3: 0x0
            }
        },
        qLookup: G1Point {
            x: u384 {
                limb0: 0x13618ac61a190b1313984c41,
                limb1: 0xaebfa87e81eb08f45b112ec3,
                limb2: 0x1dd04a8b68480307,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0xf076d517537a97baa29dc9b5,
                limb1: 0xbc23f807bbc3ae334494a7de,
                limb2: 0x246a2b5e4a48922a,
                limb3: 0x0
            }
        },
        qPoseidon2External: G1Point {
            x: u384 {
                limb0: 0x256adeca293661e04f1a3ddf,
                limb1: 0x5c3ed0f88d90604a4c8d6886,
                limb2: 0x1aebf53057be467f,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x60efa4921bc0e5c16da58b6f,
                limb1: 0x21c63599557c6473249908a1,
                limb2: 0x2bb5fcc21332b835,
                limb3: 0x0
            }
        },
        qPoseidon2Internal: G1Point {
            x: u384 {
                limb0: 0x27eddb28bb72f061415e49e,
                limb1: 0x7e5c717ce51db5b7b0f74ed8,
                limb2: 0x2d855b5b9eda3124,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0xc81078227f33651c341b7704,
                limb1: 0x6558b670690358ad63520266,
                limb2: 0x1e857d997cc8bd0b,
                limb3: 0x0
            }
        },
        s1: G1Point {
            x: u384 {
                limb0: 0xd19a392b193a4a55591f2f58,
                limb1: 0x213d543b19fb4b060ada6440,
                limb2: 0xf028430324245ce,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x1c2865f2c6b06d9e136c0c1f,
                limb1: 0xd6136addf0a86dee6079d093,
                limb2: 0x18d26b321ef43284,
                limb3: 0x0
            }
        },
        s2: G1Point {
            x: u384 {
                limb0: 0xe5e70930e406816ace62fb2b,
                limb1: 0x52b3c6c9dc6dd63618ac18f0,
                limb2: 0x2eef5de41b9a7b0e,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0xa7bcb6657a61fcb8fbaea4f,
                limb1: 0x8b7092f7c37881572a651d71,
                limb2: 0x144a24e7e4fa7e85,
                limb3: 0x0
            }
        },
        s3: G1Point {
            x: u384 {
                limb0: 0xdb1cadf52a0aca08d15ee810,
                limb1: 0xe34257a9297b836215ebec6e,
                limb2: 0x2e7e532e1656ed4c,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x6451db4646e706b8d5d551cb,
                limb1: 0x91bfff7e039b6fbc26883adb,
                limb2: 0x1a08f5a547b8cb59,
                limb3: 0x0
            }
        },
        s4: G1Point {
            x: u384 {
                limb0: 0x21271e8f84bacd5539310bda,
                limb1: 0x3fab8895250839249e9f72d5,
                limb2: 0x17fc90a343ca94a3,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x7aa75f26d60b9882f20d1d7c,
                limb1: 0x7e1be2a79612f14746f91ee4,
                limb2: 0x18bce7273e69eef0,
                limb3: 0x0
            }
        },
        id1: G1Point {
            x: u384 {
                limb0: 0x526d79e2bdcb2ee35eb436a7,
                limb1: 0xf98c0941608d13c8927366c,
                limb2: 0x23129a571c8e2e73,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0xecc457ca9600e1181fecf090,
                limb1: 0xb30728b02e23ac9b5d3a4416,
                limb2: 0x9b08681f6335d38,
                limb3: 0x0
            }
        },
        id2: G1Point {
            x: u384 {
                limb0: 0x9599c298120453636906284d,
                limb1: 0x3b1c218d26fa88cd2d946469,
                limb2: 0x2480a28e74a1f17b,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0xacf88637c1425fa4a583b6c7,
                limb1: 0xad395135d6c53a665319e307,
                limb2: 0x14ab9cdff943bf65,
                limb3: 0x0
            }
        },
        id3: G1Point {
            x: u384 {
                limb0: 0x80b9bef7b9a54c80a208a87,
                limb1: 0xfb6c651d048e34d640b94efa,
                limb2: 0x1e3912058c25e529,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x55da5a9446187d0ee9f6723d,
                limb1: 0x9ea1fffb0f430f5225a6bd8d,
                limb2: 0x2f17a75505c3035b,
                limb3: 0x0
            }
        },
        id4: G1Point {
            x: u384 {
                limb0: 0x456277b86c32a18982dcb185,
                limb1: 0xf8f2b8d28b57cea3ee22dd60,
                limb2: 0x2493c99a3d068b03,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x320082c20ec71bbdc92196c1,
                limb1: 0x843cd63f09ecacf6c3731486,
                limb2: 0x1ded39c4c8366469,
                limb3: 0x0
            }
        },
        t1: G1Point {
            x: u384 {
                limb0: 0xb161763e46601d95844837ef,
                limb1: 0x59cb3b41ebbcdd494997477a,
                limb2: 0x2e0cddbc5712d79b,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x31d350750df62dbbc41a1bd9,
                limb1: 0x505964d14315ec426db4c645,
                limb2: 0x303126892f664d8d,
                limb3: 0x0
            }
        },
        t2: G1Point {
            x: u384 {
                limb0: 0xc0c62bd59acfe3e3e125672,
                limb1: 0x6b565e0b08507476a6b2c604,
                limb2: 0x874a5ad262eecc,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x183c9c6841c2b8ef2ca1df04,
                limb1: 0x8c3edc18982b9bef082fb517,
                limb2: 0x127b2a745a1b7496,
                limb3: 0x0
            }
        },
        t3: G1Point {
            x: u384 {
                limb0: 0xd56e1eb23d789a8f710d5be6,
                limb1: 0xb1871081954e86c9efd4f8c3,
                limb2: 0x15a18748490ff4c2,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0xdc016ab110eacd554a1d8bbf,
                limb1: 0xa95df075833071a0011ef987,
                limb2: 0x2097c84955059442,
                limb3: 0x0
            }
        },
        t4: G1Point {
            x: u384 {
                limb0: 0x3085b68b00a93c17897c2877,
                limb1: 0x798eb952c66824d38e9426ad,
                limb2: 0x2aecd48089890ea0,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x5ce559f441f2e71477ff3ddb,
                limb1: 0x8a7a23331d215078d8a9ce40,
                limb2: 0x1216bdb2f0d961bb,
                limb3: 0x0
            }
        },
        lagrange_first: G1Point {
            x: u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            y: u384 { limb0: 0x2, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
        },
        lagrange_last: G1Point {
            x: u384 {
                limb0: 0x71fba7a412dd61fcf34e8ceb,
                limb1: 0x71155617b6af56ee40d90bea,
                limb2: 0x140b0936c323fd24,
                limb3: 0x0
            },
            y: u384 {
                limb0: 0x185c5ff8e440fd3d73b6fefc,
                limb1: 0xc87d652e059df42b90071823,
                limb2: 0x2b6c10790a5f6631,
                limb3: 0x0
            }
        },
    };
