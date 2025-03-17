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
    pub circuit_size: u64,
    pub public_inputs_size: u64,
    pub public_inputs_offset: u64,
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
    pub circuit_size: u64,
    pub public_inputs_size: u64,
    pub public_inputs_offset: u64,
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


pub fn get_proof_keccak() -> HonkProof {
    HonkProof {
        circuit_size: 32,
        public_inputs_size: 1,
        public_inputs_offset: 1,
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
        circuit_size: 32,
        public_inputs_size: 1,
        public_inputs_offset: 1,
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
        circuit_size: 32,
        public_inputs_size: 1,
        public_inputs_offset: 1,
        public_inputs: array![0x2].span(),
        w1: G1Point256 {
            x: 0x16357d61e97a3e80a89536ef999b30c86f21662c49c4994f91f0a8755a393a89,
            y: 0x154bf299ca24d6a4e8d13ec032fe5745f7c8eabd823bc15ec77a2cb16ac8e57d,
        },
        w2: G1Point256 {
            x: 0x2082d7ce2bd2f9181419b9ddcb2cda2acd9e1ec5c457ac37cd3fa6ddbe4785,
            y: 0x1b1deac757dc4689510584a508dcc33b707d2e30fc9be2fa48e1f7c5bfc205a6,
        },
        w3: G1Point256 {
            x: 0x25735f251efd62818f9a6cf5cabe3d2f0334bea037e8eaf9efa0b6ead8654e44,
            y: 0x2b8e3c9400f423d681b278c95fc50591b2626bc4e2930cec776e5802a368da42,
        },
        w4: G1Point256 {
            x: 0x2885be34252e6700cc955548dda4464ac9fc5b8b56a2cf6e3031420e95861e6e,
            y: 0x13aa5b7cfcdc95fbc92d895cc462da9bc06a6147e0c0ead5a8057224fc92c366,
        },
        z_perm: G1Point256 {
            x: 0x1dff4e95cd7d194f5ef8c643c73d23f67eed19545e443a1590f428bf6412be86,
            y: 0x2e46abaa9c193aa1818d50cc0ffd053e011e484eaa01ac2663a7dca531910183,
        },
        lookup_read_counts: G1Point256 {
            x: 0xd4ac153d47cfb9d1469b41f6fd0851fb005817b64f4a417bdb95c145e77719a,
            y: 0xb11662e7fb771be5c4e366e738d3938620d90b62702bb0dfed6b38c756c150d,
        },
        lookup_read_tags: G1Point256 {
            x: 0x202c514ba34a96b6dc8daaa069b65ae42d0a76f555f740a7c9e7d59fb9eafc78,
            y: 0x2ff29d6a6d964ae32e80dd8f9e03754de01f959b94b21bcaf3424f4911ce2d1e,
        },
        lookup_inverses: G1Point256 {
            x: 0x25883fa888d20f27df5d2b6afd4cb20468fdf4518f79666eae3150bca93a3ffb,
            y: 0x1f52c3efb5d89d9e186b743b0c51e81cbad8c115ce6394059749e4f7e72f6ebd,
        },
        libra_commitments: array![
            G1Point256 {
                x: 0x2327489fba613c31d9acbe292ca25da20d0a0207241b546b2c0cd24da4145ade,
                y: 0x2b3af64dc3310bde94f0a0f68584e3a7a7375b6543cc114fca7d2f8a3ff97b1a,
            },
            G1Point256 {
                x: 0x15531b09029563f76cf2266c08c34b513252ca753d62d6dc2e2c401afb716db9,
                y: 0x50c46d87d7ce79edcb8d0e4d891b635fc2c7389e47bc3c81ea8a29ebdcae498,
            },
            G1Point256 {
                x: 0xa08954b71dec829a93a1b8aff238567c1dae1e3e1638e7ec8b40603e98a49c2,
                y: 0x7ebb3c5f42f5ae07be4864e61c886d9f8ce0b487fc09c124183d2ef113a6f4,
            },
        ]
            .span(),
        libra_sum: 0x86e8dc737fff195ef19b3a29598ac173b0aae14e9cc837bf53e5ebb1242541,
        sumcheck_univariates: array![
            0x28ee74f9ffeac9bf057f95dec1e1aba6c6bf4017e9b2d26d3c565a1882878f99,
            0x29299f28aa37e75387b2a58dd65669dfaca4ed3ce92480e5ac12a4aa751a1f8,
            0x7626b3511770e8c2d0825cdcf872038f3ab08d83be17c7566d65e3432749ee7,
            0xf24f6fc0abf70bb04b71a3d1cc2a431981f3711c3843b92b1c33734b18cea4d,
            0x30252a73dc8b1e6130742b9af3a508bb8211f4930af3bcdeaffeda5c9b82a181,
            0x2b861d0df70d5e8d265a7397462e14bb364a823e90019370b4430445eb55d297,
            0x2da7f1c2b908a0b6540135f9a13f38930075b2aff9c3d2e84ab5dd9bfedfad3f,
            0x2cc6763d6079b55bd41517eb0dd130ef49fa6564804b881689a1edac63d0c4f9,
            0x2c85d8140b2ad89bd38ca908a0be16df3172cdbd3c50936a36b83d0627572209,
            0x2062c1a6bccac3cff4dbb9e19e8fb4dcfa21123c30eed1edee01b11c9a764417,
            0x25078b6971be4b6a711b5679835142923f4e8a64592b53e90d15eec3508af75e,
            0x2a974994dfba47d73799dacb4d48489e6c4eceb0e5656e78e5e1a8751366a746,
            0xfe59f657d8e68e4d5fbb0616452d9b2b8115c4114f030e4ff8a127214d98538,
            0x2dfde981dc705e4ded6df370a60ce6c437836ca16e8db756d7532f5e3f6c1005,
            0x21045e6320202bf52511f729f6b65e0d2c3e4eac903723c38ce1d43032796435,
            0x15baf725d1822874c6a571f27f5d57c0785b87a4a4cba95701ace84a4dee9659,
            0x2539cbb1059f74bcfc0a8e51623be273ce7fd2725fc88281102ce4dd1f2f30d8,
            0x2a1ba70406887b5538fa2e988bdbd56b48b541a9858c69ab2289fc0aae1e3ae3,
            0x2d938235202d9e51cdb77107328d29a446a24f244c574849449ce17f388bee11,
            0x111dee3d673cb602a6851e36b45222ef37ac61524d25a7c81b99c614618baf42,
            0x106ff2aafedfda6cd6804adf45dd1385a3ac8a06fd90d188f9c974e757a2f599,
            0x1fa5a11a881304a908c3589c8e50e8740acaf1f006f7c9072d422d846ae32c93,
            0xfe892c2654312d73fb1e63c2c08436de69474208fb4e00641ca0f93c54eb074,
            0x204aace39650c7dea201ef90e85b909acc3dc743cdde0a81373612fdb2b8d57,
            0x2cbbdf41cc98525702db107b1f2ee059c4d0a17a60111adf7cde50daf3f41a45,
            0x12c1fa38256ca5313522f341d000511f117ac74d26a01648b4435e23c70bd577,
            0x2f7f4f536e26a407b5ac4a6d8ddea47e4c23ddb8cd2930b5b0722e6799d0cd70,
            0x5a8ca8c72d6aa924b4ee6cb4abf33abdfce01d6bef396fdc787e27a9c683f42,
            0x1a73dc639cd677bc2e4e8521415b119ee91e22a7bfb0998ffedc61ded6d40b7f,
            0x2c0f2fdfed5f6bcaef477698c68e397f02ef88100a3392b01e578ca9146d0597,
            0xdb3bc898ec18ce3197d4c3b5c541acc199b7bce82983c92c89ed3da109c0345,
            0xcf7292cae76899e0b7835e740c34f1e5bbb790da805c11f1ea98eb583277e82,
            0x2843cdffbb9ebfbfeefdeb959e1cfddc82e186be686b8c9df4cee1d8be85180c,
            0xb1e37842a8ce7c9e021095514927c1819cef1008e5abd32e25c732885ce30c4,
            0x19d3ae552ff56c433d220a9bc555b00f9e8edb554bc8eaf3bb277e5f50d0c44c,
            0x2fb95d51fd4e869718188de5158150cb2891f429e32f7a28ec38e565cf60471,
            0x1d2fa5f0a9e664d70d576a19aaf8b93fd7345130267f6ebe75c61447ca951020,
            0x1bfcb12794b7befc50476dc7350840786fa7dc970acc77daab53e8158ba595d1,
            0x1209b69201329e252f8f2c32ca2ccbe3c764e877f43d6ca2e3ee97fd1978b707,
            0x2537f984eeb51761d40ac0feb1cba7350bf076e751569e286105f25759fb48cb,
            0x1ace616a3499ca554eb25844f2303a0b6ce14f4040cdca35c98bdb7473d7cdb8,
            0x2e25d4d486301f7970654d4f846534129124af6225454a12366fdfa3d93c5054,
            0x2aa4c51706c733b2d5576f06285a63160522342e84b17d41b673c4714efd3fb9,
            0x18d427b37a8b5b5e55f11bd70853913bf7625ec1e093857f74f8cefbdea699ad,
            0x1e116c063679448f16204d53caf2904d922e58ebe2bdc6be7d0acd299349b219,
        ]
            .span(),
        sumcheck_evaluations: array![
            0x3e004b2c93f74a72255ac09134fe920612cb693c16bc2c9280454cf73f4f464,
            0x23fd60276aaa9462a19ed8a6cd0b90a3c1d4172780f72e2ed0a59c766b44698c,
            0x27d4ae711c570e5d0fbd9f4691effc3061d1e57358097065d0114801f8b6515e,
            0x839380b76b10d8bc13d47c3a8fb3260185904bb7f7cc1b6e47f85083c62d39c,
            0x64e2b7dc9e3d32440780a40f3e8b021dd49dcaed6733ab7a24151dc6fbdc5c1,
            0x4963a9ad1087c54931306e6146e145f50059157e7ba169168b743a6630a9391,
            0x29be46d8ff510eec1b221eb8259e0a9aea55223456159f1abe75585c2076b3aa,
            0x28b4661be5bb8ecb0d96a24500523cbc953c0db9a237e445b0d105393eef6066,
            0x2c92aafaa6e72365e7d1bd53d3b22bc90d82dc38b7319f12f6fc5473d042c0c,
            0x189b8166654dad7ef7115fb2dbd93c9f7510cf466d56ceefeed04f36c3224d2b,
            0x1c59c9d528ddcb13b3db6b9ea21e9226eb937092331bc859902f1b1d8e264499,
            0x21021b0ffe0c043b77d043f8e23b7d2291de8c8634f6810c269936deff5d5d5a,
            0x13a6f3340d15782a294093a550756d46c414cab08c0afc9f2630ffd1b4a7e980,
            0x2c897c679895458dac1dc35dcbe89e798f447c121fa67c8923f4dc81b51c3620,
            0x709b826032a79cd5253567d9e2e3e818a07945eeddfe7524c98b90e979f24b2,
            0x2a6afc1646b7a782cb8b4c34aca469de3ca121fdcfe4f37a0e800c7a53169f3b,
            0x24ead0989a3c68109a911ca49446c5ca71f0fe8742cc56aed0da951cb6b58755,
            0x8cad5293b8d71fab96878bf1a6520c2582b22a763196412b6515f1a62b022c2,
            0x77a11585d6b63ce54ed9f3da068114a63642bd131825e5b4f267f012c749dcc,
            0x2b90f7118c1ed64b3cd586acf8340b43ffb25539120760529e4bb63fc1436e78,
            0x1d951d32d4ec95368f66a01fcdbee88db1ee10a8aaaee894d93a9ba1bea85ebe,
            0xae5236981d017181fc66a29bfab10f71778d53bf6fa6b067ff7486932cd216,
            0x213b4bda07b3219a6516320e761186c6331bada22c443838e8edcd153c5f970e,
            0x714c5a63e94ea15f78d38317b61095b63a0ed601c59be147a869f67547f8ea0,
            0x49ac591e49798ed4adc57618c54c93f949fef3df166ccde15bd3579dffdd8fb,
            0xf7f988881216706123c79b2db2b0374eb9d6db0f4c6ea813402a4bf6ee026ef,
            0x2790da3f5ec5196847d26558349c8819126a35d5f0facf21641e621af843aea6,
            0x2c27969cea1cf02e3918ac5f1f78d62b8b4f34ddfc844889715eedb52cab09b1,
            0x53ffbdd3b0b2c58121c81b9352ce1e4407414b79902337aed1233a95da60f87,
            0x23d38b5b3f14b18f59d29744f1dde60ef8231fa2b27435b7f20ff110fe0cb0ec,
            0x1435714b308cbe4c4c451a0ebb15acc0d32813ab6f100fb71c5cd4eac3b1b4e3,
            0x2644f122827c65934f3dc7bd8b4919f5d56eebd3ed8a933a43318a21ad636805,
            0xab991f9da07b1323c5028a8ddd0544fecb7c28440c25807ac3432d6ea963507,
            0x1dc4d8ede001013b7e56a53921fbb8ed8abae0b11f6598651398e02837c9d884,
            0x294878e9a7d9b110779b7f3aa3d579961db34714194268a313e316cf6dd87ed5,
            0x17cbe4a17a751836f0922c0dfb2db95db289e255f69a5ba61bc8fd0c3d315474,
            0x28344f079ebfcac7c3465ea14e9d6b6f989d55357b1f4cd914d94797f836e7e4,
            0x1091f60930631a66852d4bfa3e470f2194b870688b7ed166047282d6f2caf853,
            0x4eb08a6036f52a9ec3c7edc1ec508e4e21e3b2ab5228a9c950e5895f3433b86,
            0x2335c28a2bb03be65ea7dbf42c20cd19c467bc4b537ea3eae7d97bf7d24a2b0e,
        ]
            .span(),
        libra_evaluation: 0x5482dad96c3d41db24038b949ae7859df3c0f85e6700935b73684fae025555f,
        gemini_masking_poly: G1Point256 { x: 0x0, y: 0x0 },
        gemini_masking_eval: 0x0,
        gemini_fold_comms: array![
            G1Point256 {
                x: 0x7a77ef6a2e22b4d8dae723d8b2510f7829ae4f71773859232f056f4b5d44461,
                y: 0x28f28bf26f2fb40675567524504b2639e6d6f6d41be4b8870ee1048f2640a76c,
            },
            G1Point256 {
                x: 0xe403845bb061e43ae0efe4ded17113f6407aa50f10ef4f582c474f3cf143475,
                y: 0x227864dbf702ce0338d18e21af56fd5e0dce7925c44234aba1b4aa9e6e01e465,
            },
            G1Point256 {
                x: 0x13ec0e8f2ac817c7d1d5178d2de05fc60fb9b4062bc4a7edb94abb25155a8f38,
                y: 0x16146e8eb480c44358437230b6f097500ab1eebe6c0aacddac3580d5b1325034,
            },
            G1Point256 {
                x: 0x2c15e04b9988ef950aaf0f2c7ed82993edd7a386432934c6cd23fcd835337dbb,
                y: 0x54c80bd3149530565a83281955aeaf4bb988ca63f80f546ba4c02e5a221de14,
            },
        ]
            .span(),
        gemini_a_evaluations: array![
            0x2832db06d4b23616779756ead170ddd81c0b0625964e14b0208e4de49df6652f,
            0x5f307a32b262c32f3bd158454161ee55ed9868955c9f14c6a4dd90ddc4af78b,
            0xed04f6e9564b9b95ba52df3a46c9e3e354b4087628d91ff8c885699bd8018c7,
            0x2dff75d31c22084bca9de3bbed8b8930f2998840ae0d1ee5a04da6ed2f6f409a,
            0x447ab84016ab03c27ffd4075281da085ac0ddb4aacaf191ae53234a669ecaf6,
        ]
            .span(),
        libra_poly_evals: array![
            0x6f585ca595e832c223b04d078e30d7fb82a9e0bcf961206c6ce532ae0e53b30,
            0x8be5d09cc55eaaf3a2f13e915220f1730c93a702f4881df2563ef9a9906b92,
            0xd48ef69391efd064101fc8c97ff123a6b0db175eede1b2b095d15387cf43ae6,
            0x2fdca4d23b5ff79c3fd30663d1145d18ce4ab5a029a7c7899bbdd072e43ec77e,
        ]
            .span(),
        shplonk_q: G1Point256 {
            x: 0x52307e669114b12a322f771703957214e17fdf63d0f480ca7ebd88748384520,
            y: 0x2849652a50146a41365f85424cb1e32cd198b1e3beb39af1b961b28866ec2bca,
        },
        kzg_quotient: G1Point256 {
            x: 0x2300d509818957f8a2b266ccfe5c764843e91b1c2e90b94c2855bcd6a44d87f,
            y: 0x21e43687acca01e4d12d49c40bc9ed51d814158df7a055eef1a985a8b64bcd99,
        },
    }
}

pub fn get_zk_proof_starknet() -> ZKHonkProof {
    ZKHonkProof {
        circuit_size: 32,
        public_inputs_size: 1,
        public_inputs_offset: 1,
        public_inputs: array![0x2].span(),
        w1: G1Point256 {
            x: 0xa5e99111c944d499d70b06f4adffb47f3cbfad9777a31129794acc2bb0d0020,
            y: 0x18ef0e79d77033a3675295c83dc3ca26a121ac385d04ea1b4f2d4be03730f575,
        },
        w2: G1Point256 {
            x: 0x1f9ecc11c1658bff55ef2b0155dabd7fb37c332782fea747c12b1751e8be6d2b,
            y: 0xa725b40b641b142bbf57e2a12a961aae5884993b8ebd527d3381f87e781016b,
        },
        w3: G1Point256 {
            x: 0x1c3c7408652e3479686cb28c0f8f4f738216bea666dc35a2737c5ea74df1d64b,
            y: 0x24168505a98bdc56b5db6de24b782b12f175bd7738e1e9330d795a3d14262696,
        },
        w4: G1Point256 {
            x: 0x6583144ade4768bad84373e7815953721bc8f9785fa133b3845c41dc57b74d4,
            y: 0x2ba017a4388f05e636fe3e4bd45aa236a080c555bab4e4ee960c3e0d4cadbe88,
        },
        z_perm: G1Point256 {
            x: 0x15c80effb2d98015c2d424db05de7b6654603128a159fa281bdcaad0b37eea9a,
            y: 0x149c549007a85ec6bf3b47c3ee23e87240f5902af2b22311e7752f03d2a9fc34,
        },
        lookup_read_counts: G1Point256 {
            x: 0x1f2aa815ff38bd59fa5995a524c06fe5dcbac279ddfeb06ae907dd707ffa8b51,
            y: 0x2c3ac5e6d2aa1f1966fd6b21be2171aa5e319669d2fa50bf5c85a4a3b4c3111b,
        },
        lookup_read_tags: G1Point256 {
            x: 0x1d6690277c1bd740dcfd2ea4cf410c32e350de00f9369e20ae08eea10dd444e9,
            y: 0x2514cd8dcca9a96e3cdb4d80d2193d1bf1a9b20faaf6af7d05aef3c5a443f648,
        },
        lookup_inverses: G1Point256 {
            x: 0xa95085da31bc72169c10b227fae5632f1bc7d7330b617b71f8078f25d6e2703,
            y: 0x177e5b7cd690ae4f0f14d8d39bf11f18ac04dec2d3afab253b1b6831a52e57ff,
        },
        libra_commitments: array![
            G1Point256 {
                x: 0x2a1eff034f32769afc40ff7b27c344115400ef0ed8e41535e97b0c205408d538,
                y: 0x1fe6ae181f2e6f42a8e197b6032fa9b7b012196756e7cb92cf82c350cb02229a,
            },
            G1Point256 {
                x: 0xafc18dd9be85910ea25676c0182371076305a58fc3b5f2b9cfc7e8ef8f7be24,
                y: 0x1a3aec31772670843956c23885c61cf15ba23cfbdd98b47b582b3eece734b396,
            },
            G1Point256 {
                x: 0x22fd9555a32aa5eff9d66c389620fa8b67eb5dae50ebc0174d0df7f5f22e3bc4,
                y: 0x1cfa37c5f55ad14c1592da686d4fffaf6d51db711ed42fcb9472b90458b442ab,
            },
        ]
            .span(),
        libra_sum: 0x173e4eae964fc51f733fb8cd6279d2b6d919f783fcffc18d5d67780b71cc3bc1,
        sumcheck_univariates: array![
            0x2826aa99ad5b56c6103aa9634d787703a7b142e98253b1749f97f07db1295152,
            0x2cb712c6fd64dccade6b6c080379d03631b33d8d09ab896c8bcf8073528448f7,
            0xce78f55265a3ec6aa14c90e63a9fc6cc96cd348cd5581fc0df8413bea449617,
            0x1951021e45688f1ae42d61e97cf2302e0a02430af98fde2e22f5ef97ab9b33e5,
            0x542508973dd74a3ee7f223fc4d94eadb1d8b05f699635f2c11e292ec3761af5,
            0x2688ee98eedbe326192553275f8c117bc862a31d67fce3127f74768803aba96b,
            0x125540bc3779af2ff868d5d9835fa6bb5e0a4528f002319e0858ce13c430a4fd,
            0x152af2df05b2dfb36469d1eb5c30c1fd233a9383dab9f98a68f14fea74bbb426,
            0x41268fba24b418f1ac380f427381b9b5027b1131aebf28d561f16c7544bf9fc,
            0x7269f2f3fb084e88842bd503eb7c46b29b7a620a10a649db9601547ab43b8d2,
            0x2b8ab801b3b4a1d321e530888424e11d64334425502fa60ce93e28ffda5e3867,
            0x14da11ba191cb964a89bd738ab3d32acff48658aa85cab5a24e9512427d911f2,
            0x232a94344c49939d79893794cd27ca97370d7b1fdcd3d1552c4bb59a4a4f4e0f,
            0x28a62cabdca6627ee6fdb41b63810cea01f9d3379b133089b8da046fde14a02,
            0x296244eb230e55b14cdbbae04b23b862e3bad441d1ff251a296f773d3d632283,
            0x2693a19d67b273bd104ca0464a146634259a3075f3b6ef2592773f28ec65fc2f,
            0x1cb72c1dc41ddf9dbc18301f55d4387ad02a82e33e5a9693d47ee3db85b3d87f,
            0x63c14709a72702e36455abd9542d89d805d16a0327c5e171b32b9b727ad3d82,
            0x251c063b71f3914639d7a4bea37a25fcfb298c250ef7ee283dcd4e4e7fd14672,
            0x1ca0d1a9b7d7cc5cdee922b52985b2ef6db4d5ad81cee4cbd70012484d7c0b88,
            0x1c75085dfd3861d3e15d36141587d9e3ca74605e33fe9acd44547f3eece5a5ad,
            0x217963869c31194eac27abef0ac0c895e49c337761f80ce4f73bb7b8f73587f9,
            0x25a36c5cabbe2296c7f309b486e89061cee854f7c8577c4dcfb3cc0ed1c0ad8b,
            0x174668e6b540ed012ae0d41b65ec0be3e36cef773f9f45a5edae04a158ea37ae,
            0x4ffcb7d208abd40e14c0ce11adb2f829858b391dd3e053ddc44b4535677bec3,
            0x21f6993ef03e5efe9465edc919a1bd914c719fea7e0c11b4dc63e781fb3b1a3,
            0x25d1693dd36cae48a5ce0907dce1b40a0ca0b4a6010943ef9d97855195924e94,
            0x22fa4fd9b00bc8c568a0ab9127a2b92a4434282b576a95b04c7e21b0c69d8b1e,
            0xef6789a10c52af36f4fad6386488d011c0d1045ec664dd8c1af44d46ce2954c,
            0x906c5e365a3b39206d81880cb901f1734724c20dc945c3b3d39d37060d43059,
            0x1bec2fbe10b57e792bf6320fee14620be572f2e8cdeff359cb0fde2f331747e8,
            0x1b37a2a58b2b46ac9b0fdda0f82649f536f9c1faf8d3f0ffad943ab6f9348c3c,
            0x9254708ec0649d37b82149679c4b4d19678e734d95c6f0dba28cb077661301,
            0xbc90fce19309a5ef8cd1842c827de6565db7e0919c84c1a8d24f3ac9080dadb,
            0x2e4450158546d995cec15b3daf1bc64bb6aedb4e78ba23ece5eba467a8206356,
            0x27cb176272f992ba09fb186ac7d7c0a6d2130be415406e4b021bf1b11c00d14b,
            0x26020903b88add8e3cded484c07dbd0775f6036ebf1ceba90696cd162a192f06,
            0x2c25e5c4c4079783c3fe1ded19b937d38765801cabc2a078d6f688cb1440d012,
            0xcdcf2d12572650727c6287dc3897fb5e3f8ad2f1cd7ed39991bfd402dcc99e2,
            0x46817e010c0d8224a6fb04fc87122f178c66db8da94d5731112e445e34e868e,
            0x1823ea26b6e6e23be75d94140512ec2112777807197dc29cd0be9aa91db40555,
            0x1ef2313562acc19f8e376aa66441ad45d370fd3bec4200e218d50ba6986c8dd5,
            0x2d1cb5af06b46856421e4ca399d2442e3024c0a5e96f2f81b4fcca82ddadfe98,
            0x26d545919cf13f59430d338fa6c00a23e5e2c07bea0d178973da18bed698f9d1,
            0x286be5ab8810a4c37535bbe76e378475d4ee6806e500a4250efcc7e16e338f41,
        ]
            .span(),
        sumcheck_evaluations: array![
            0x1c7bdbfaa6a78d3e40871432d8b40d8d3f5756e66512fc27a9230fc84779db86,
            0x279b4d5ee3bc6d6b1f8f21d472157e8653cfed13582f56a911a5ef3e021ce7e1,
            0x2f27a2a61c81e4e21ba6383432c656eb25154d028c4ce8520ad671a38e6cff1b,
            0xec82c3d546c3b02b7a082b93c311fe5b9e1a743ad87a4a6db4ab20fd6d55e7d,
            0x2eac486f94dad2d94345ac6e7a310f8eca359b7010ec24f12a791c0b16f4649e,
            0x289072d1c20a772db67d0ff47946c0fd10b2e5e24b5900494f5c51065289dd53,
            0x1507f3e03f6e107d70f838173c12922f124fa0d7aa847599f012922db26545be,
            0xe57917d5199f8de9439af9675d017e657bfae5a740464c3f3e26d08be705223,
            0x2463628a14836464dc2218e4a263b9969c5dddcd10543a94ff981c3c00491236,
            0x2b5b020a8d4e05222be8cc84fc31e735df30e9413b579ba3693c69148129a386,
            0x1151a3fd8137ffe7d11f2bda4859d234e48ddc42ce3570d8a3192143010a7985,
            0xcbd6317bd9d73a238c4c8f4b729ea755ad018a8309024f2640087f6c1d6949e,
            0x12c15d3855af89b31e814e82d0f2200a284951f3fe82ab42b82eecca87d0437e,
            0xe1fba7dbb2537fba9f4ec35e66e0256bbd5535a24c60070325427ad04feca54,
            0x22ecd71d9f17ae15bd79ef80f84769b6f49f18d89bf0a85461b73dd2453f58f5,
            0xb4ec2171f0920cd2d37d6afa886872554162870a3f9c27c726b8e86954fa6e0,
            0x24ea4b8c98be2150fda16d021dc1f0121441b6c90c4275e0fb70386e37f5088a,
            0x25a3356263d360d6e95e88eec12418d4b1375d21e06998b07230ac5b91cb7d31,
            0xe2b2a10fde5d58522c66e1ea2c9cc43fe16b23d235a091407050bb65f24c39e,
            0x37c04c7757c9d83d0b90105b85867aaa011baeefa9f2d7e58221c8eab20c2dc,
            0x83e5c899fa82851d5d57601f0f33fcad903dd0a528283a844a90d6c669a9bcf,
            0x26b97dd2b23eb0d7225c38c591a3693c24f396d6c36a24f0af7930f8556ab806,
            0x1a5a520a9fd348597ea5cd3e9798a45c57ca4ae8ed97ab0624bc4776e03afccb,
            0x1fb59f69e718a4866248752f7f8965f3d49af6dddf1dd43973e0268a354f357e,
            0x2690f3033ba40f0d409c9bb430557b190bb325688b63e48b1db031a83ca2014c,
            0x27dcf30c145d5d7713357cec324d892496ff7bf02109359fb2cc08934b77c049,
            0x1d2e400b58168ef421655449c3359c97c482315cf1a8f0f30df9e0fe8b76cb3a,
            0x2ae8b410162562f687c34f1c19f80b9217dab669b4c85b0d6944f0da9e60e2d6,
            0x150aabf0a6f5ffa64d45d67f77187226a0942ffef6edc90f7a74f56451e5a2e1,
            0x1928bc948097a7df17044cc36ca9f8c3213abf468f467cb9f4120b69ab42304e,
            0x17751cd68f821c9100b8d721c083cef22777fdc9c5cbcf00baaf54ad53594005,
            0x196b8789ae917dbe6a3529a5dab62e38e7fcfd94474ebb1053725ec93ff1981a,
            0x224466440c7de58d1cf2ed4a3e48f91c77fcb52557f2f8a685fcd8d67bd359fa,
            0x158c8f1dd6b7f158f21081665efc235c80c863f9278c8856da5e992f48ae23c2,
            0x25a441120587674288836d435c9c571894b1dde998abd3d2bcdc474c87ecddf7,
            0x557bfa03168fb115494826980641ec71e660c0a308745b2186d0a3ecd7282e9,
            0x27e5d07b9c5c9e318399328163782e0dfe62705fa19360f2c59f61069b9882f1,
            0x1060f3dda87adc0aa87aa50476010f630a90ccfc2421581bb62e981a4c49607b,
            0x22ee2056fa81b88289d5f8b094f861c78e69faa8c233acfd8a50c28de331cdf9,
            0x24f6edbc0b0ff97443ba6f83b81bafb1d6afed760184ab6030e236f5e45f445d,
        ]
            .span(),
        libra_evaluation: 0x1ef8b3c066bb248a06c9552e3b7d55b15f24a7b02dca36ed5bb6148f8db50afc,
        gemini_masking_poly: G1Point256 { x: 0x0, y: 0x0 },
        gemini_masking_eval: 0x0,
        gemini_fold_comms: array![
            G1Point256 {
                x: 0x12cc371038189537150be4a6885d022fe7d22071704294d84c47aceed2579a0a,
                y: 0x1f57412b2a0e565c715f20d2239075247faa8999cadd7fe3ab15961869ad7ca8,
            },
            G1Point256 {
                x: 0x7943c188fd9db3fdf2fe2fbd6535b9915fc80753b0b9822245a10cf8f69af62,
                y: 0x1c4191114b0db90f6e1e2949f186af866a806e3614d5b40bf93b343a809b39c8,
            },
            G1Point256 {
                x: 0x165987b109cbbb58db40027ae8c5017c26378f6193f02d2817778ca6581fc667,
                y: 0xc853847fd387f0169beca1a52c14af2f896e23520d178ef713e755dc36fac6e,
            },
            G1Point256 {
                x: 0x55b9113efca37758117af342415aace329545dc455d2ef5810884132e998647,
                y: 0x1c01177a4a9fe9edbd146bc279f6ffe959b62453f0a1b0bb8f9b81205eed3f31,
            },
        ]
            .span(),
        gemini_a_evaluations: array![
            0x2d1208dce650b83e83c23128cd042682a0356e1e7bdbed139c62a3c89011fe24,
            0x29fa1c1f37c88517b716272bec362f114735b882a24bdfeba7727cb952ba3523,
            0xbf8b7963f00c357dda83821b9a35b22864101ce65e76b6316e5bcc17388ea8c,
            0x5334729ba6004afd66edbdbaaa762a28d72d0b07fa1074f5ed94d0494ff9f42,
            0xff80f6534a5198e80e277f6b751bbbd88640d2b3376eb6a94338726623713a5,
        ]
            .span(),
        libra_poly_evals: array![
            0xdc88e1c41c08ece4a40625657e129d713c40a857889f0585b0f2e15e950a523,
            0xb97288654c1dc9941cbcfda9c9397bf28cf9c2e33fa91f65fec7e9053e5e4cd,
            0x1b814bf3f82aab9967ff94e1ac6af86eda232edded9cf5b44523cff112c66ed5,
            0x1e19d8925bcb21654bb88db09e6696a3416254152eb058e8fa877db60210556c,
        ]
            .span(),
        shplonk_q: G1Point256 {
            x: 0x3d8cce2563c01d7af792ac2f56fe4689a78185493227374399d77b9e44f2ec,
            y: 0x2188741a4bafb800221910d62a4680795b88c048c8a6a924e606076565841d69,
        },
        kzg_quotient: G1Point256 {
            x: 0x12c95b36eb6d175fec5d452b8ee539a2797e5dd56747c1ceaf7d27fa98852a14,
            y: 0x77c0ecaa63500ee368e24dd62eba2590759deca9fd4662bf6a6bcaed5ecd5e5,
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


