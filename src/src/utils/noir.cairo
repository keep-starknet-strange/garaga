pub mod honk_transcript;

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

pub fn remove_unused_variables_sumcheck_evaluations(evaluations: Span<u256>) -> Span<u256> {
    // Basically remove indexes 35 36 37 38.
    let mut new_evaluations: Array<u256> = array![];
    for i in 0..35_usize {
        new_evaluations.append(*evaluations.at(i));
    };
    for i in 39..evaluations.len() {
        new_evaluations.append(*evaluations.at(i));
    };
    new_evaluations.span()
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


