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
    qArith: G1Point,
    qDeltaRange: G1Point,
    qElliptic: G1Point,
    qAux: G1Point,
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
            x: 0x2465e9ff1629df572d7ae9fd1b9bd98946560392b669c03f9a4a496ae7e4cace,
            y: 0x17bce8fc74ab3b9430b6485da928ea6951ebee411689e29dc324843ee1708142,
        },
        w2: G1Point256 {
            x: 0xeb93267e664634c1ae1a608b81785cfec11669ee95a1dbc6386717066310cb1,
            y: 0x23169272f91d323ced584549d31020c12f7cbf314c309c0ee105c3bbfef28399,
        },
        w3: G1Point256 {
            x: 0xd394ffb5eb2d33c6a2540db125d27fb60665db10ae3f80d91eb189b318d7d58,
            y: 0xa325d606966d0ecbf514d787c3440de179ff8427f66be54fcabe05420fc14d0,
        },
        w4: G1Point256 {
            x: 0xca7365a8a7d92bd713e8625cde47db105835a557cf68ce01414ede87a1ce97b,
            y: 0x26bf12dceab316d64651db4ea03663d3d9478d6ea9a1f20bbe215561e139c7f7,
        },
        z_perm: G1Point256 {
            x: 0x69b493db1ad1bcb140505bc5a806d425af4e78b20794bc813a7669eba382a02,
            y: 0x2d6c35a33c91dd52432099ee20f87ed823919ed60347a56b4678b3a485e58197,
        },
        lookup_read_counts: G1Point256 {
            x: 0xddfdbbdefc4ac1580ed38e12cfa490d9d719a8b9f020ad3642d60fe704e696f,
            y: 0xff3e0896bdea021253b3d360fa6788289fe9754ce48cd01b7be96a861b5e157,
        },
        lookup_read_tags: G1Point256 {
            x: 0xddfdbbdefc4ac1580ed38e12cfa490d9d719a8b9f020ad3642d60fe704e696f,
            y: 0xff3e0896bdea021253b3d360fa6788289fe9754ce48cd01b7be96a861b5e157,
        },
        lookup_inverses: G1Point256 {
            x: 0x1fad315eb3f489658734a3aff63bfb846255a077783e50444d60ac2b104b1ad4,
            y: 0x1067a4d8157c660c69e7022dd32ab0e30dd9987dae02f54e15edab896b9469a2,
        },
        sumcheck_univariates: array![
            0x285e5ff7d3c0d15f59c2761a965696bf749065fe4cac90b7c5310afb3df3b3b,
            0x2dde687363f59313c2b41e54d81beef130eae1e894eea785c78ee4e43c20c4c6,
            0x13c19d3e42c8b355492f1d756884dea3957b5bf6e2e8193ffb4e7fc3f158efc,
            0x1e4d71cffdc20a5a19dd68d4cfe2cdf067a2aa1f44b89cecab6caaf55dae3417,
            0x1907ec4e632967f4f16250f16fa97ec7c9e8d7b72fec50a60adf7f77e14fb1b5,
            0x125582c3c04f25ef9b7c841edc3a461f112e792fed4296f2bcc67372e41bfaa3,
            0x23f1075c04d207789c601197be8d38a22a11e5d035bce960f9dc69baa6af03c2,
            0x12895dcc211378d9eb6614866aa0bb1a8cf720ee34451efcd92dc82c43504c13,
            0x2280f8067080c8f83123f8d052b5a181c0a5f3baa905f42d4549057585e69821,
            0x78dc17e403e81e7abb5353b62a897955e9596f56744cd931e7063f7937418d9,
            0x1e2c998e66e78dbfb4bb9658d8637f618baf885995fbd76d7922cc4e26dba669,
            0x262cd1b8fdc741c2073c3c669b12e6deac6705f6214410306a8ecc6bdbec8d71,
            0x2228b8dca9925fee72e5587e58bafbd45947c386446f3bdb63c4e010d72a0e56,
            0x2bda190568fdecabb525a7745c2d7d5242f264daeef67f932268e72b5adcf6d1,
            0x4266918448a9ec8cac8f881c0bc1ba9c42959111b9f2991c93b169f38dca51a,
            0x1150a038bbadb896d080e0158f85e7b0df710c1910a6503774bdcf08ef39a393,
            0x92a9fd6fe59243760042ddcaf85dcf2c9268e52c5208d75cb9125b2daa42700,
            0x123d711e98a50c8eef600161bc486d62069e13ad4d12064603d30e8f2d6e5265,
            0x25b58d132934afdccc480a8c964e477b88cbafdf91370ee9b4b4a1cc2e4e1a8e,
            0x1537803983a0459d1e3ed61aa59cbf0856a2a510df7901046b79a4257a9fcb30,
            0x13c08cf9426d1e2f7e132e9c6e13e8b93b6905ccc539cb357e69e0f5d66ddfd7,
            0x1f1cc54b85b64db929daf476a572212d852ad2e7666921e603bb50a1097c870f,
            0x17cfeb6ab26a28116fe3d4b5156c1512223d86e3528cd667536f1c170a4cb755,
            0x1610c336fc031be68c629c990e755afcbb43e7630726af1dfb32ff7de2a1f903,
            0x78c2e9fcb11a9ff1dabdc022f77c29a52ff10e9bfc25a8e1c2f38eeb9a7b314,
            0x24df74453b540fc68c0a5bd1c618d3ccf49e7513983cd8fd4cf0899ad5cef4e2,
            0x252ed9cd7ef0d0e60aa1b3fed302a1314450edf6ebce5036cc81b5f21f166a35,
            0x27b4ef390baa1c9773a170ac64b0dea0dfd02fbe3a43d8061e77c487ef097245,
            0x25b39250035ebe1756ec1085919d0a90a973aafcdc1b4cc77844dc81c81f017e,
            0x28b32ee8f4dd8c62de8140dd3730fc52de4abc0cab9289bceeffb1469484b318,
            0x53b798117b11aee0c5bccfb2a8d926dd45c7b3f560f8d3133d42f4deab22d45,
            0x9eacab815d72783fdf291121be7af695260916f8f9bd74b980317f9c6ff4cea,
            0x22fd30a934d68c2b3d1763e038f5f41eaaefa2311abbe8e38f00a4edc500b322,
            0x62e1857e2ed5546ce6ec7b4e2210329eb169f5695e3a04d48acf52f5359e55d,
            0xba09b18683d296cf830d2da7515d381e431fe1ac792c3117007dd2e7ad8de35,
            0x16bf0a5f2abce1fdc44461687d611ef8b4a2b538249fec1d8d32f25c3325ae4f,
            0x90d1aabada01c6d1ef8e122169f88bc36d80462934ac786ed7f63568a815f72,
            0x263a15eb7a5d4da20cd74bda64acd6bfd515fd57e001f571ee7f25dbbc819935,
            0x1a6da135c8b1c95f0ebac3186421c4bf62c71f27fe9b2e34279afe65270e21a0,
            0x2d928d40bc62836da72eadced3c96f846cf0440b939d746db2a987e41f8b7356,
        ]
            .span(),
        sumcheck_evaluations: array![
            0x1a06a87012710fd1c416ee0a81de014dc12da6bd44c812868d4d8d91705294f3,
            0x2012afa46741d05cb85c40093907abdb7574bf246de6693c0bcb500c024bed49,
            0x16d2dcca0c4c5dd38a1cbdf00f94cc0f41954ae8a21b2ef2bafb8007f380ef1,
            0x1d767c5dbac46ebf8a7013691ea0891882b5007674b35bbfde9cd4bc2e527a32,
            0x2072966d339011498d1331276eee58f2716229236f13d7ac10775b81a2c70271,
            0x29615adfdc896c3c4bc11a471fddea935de1dbcc34695acb83bc52c1535a1fc7,
            0x1cbd3abddb824aab725a3e87f5202aecf7a87932dd8cd8aa01e86841f2025a5b,
            0x2197c5a29e67ebce890221a058378114009b563c25a66c334de5a6f8dcc53094,
            0x109d8838a44b820b35b284797baa972b32ecac1e785c28bf6fd46f538ef657cb,
            0xc5ce9a7dba32f117596969c584075ba0be089b3179250b54b4de0f8b82306c9,
            0x136b79129f5cbbee2ac685099e0182bbf1b19d1a71ce8e1c988b096f63e63c9b,
            0x9ebda9fbb822762ed663d8f2900916556fd179eaaa9ea934b7e8a7d20e3e63b,
            0x219f37dedd2feb7e2fc8732ff3a4f9744a0ade748cc5ded5871788b08161f1ba,
            0x1cbe60346abb4bb1e5a18f5a3ae1bebb0131281bc771e514646801bcaaaa7b19,
            0x25c6182d057785e9974b649d809ba61f02f1b57f0285524f7fcfd846dae74449,
            0xec9d62836acb4405a03d4b6de597612ab38a7d4d7db95c84b63ac9fed6e8e64,
            0xb7c8f939f6fa71843efcea2c04a8039a8f7b8fdd6626709c4aa17ab385349d9,
            0x1654259afe3affe4832121f56a178087dbccabb19b86c25505a81befe75c45fe,
            0x172c26ec9dc7ba6a44a801982a38df0d66e7f0fba528d13f8044e081bc42b50f,
            0x28119325d0559d33e0ebd0d8a0da55ff95092c22605a33b36cf68b61d065f7b0,
            0xf8af0669a895c3c83d38e2a2d8d91df30,
            0xa30795ccb3a688c8fa73e641b6b9378c6b16ee60e343b7956d76425403ac5e7,
            0x2b0bb083ab6d90ddd5e5a21825f3a617262bc47aa93f52a20d3264284b311bb4,
            0x1eb2d76140d9256752ba21ef4ed4ee8ef021591a723b15889a1e188e2333f3a9,
            0x370704ed29ed5ba64b5690f3bac66b1fd991f58b9df2d5485c44a2880717ab2,
            0x26f2ff7fc2b01cef7d34571cf0e6c1efabb0f52fa3abc4e240ac5b74ec777aeb,
            0x2d545b9152db90404ecfaa00e4afe0d028f91370f587e97944335cf752030eea,
            0x182530062026dca5e7f8fae24ac91eefbaa64cadd9fd5ce77edb9a993aad6024,
            0x2334e657023ebe2d46fd71af9ca0d42089ae8b1b3025926e1e090e6425232ed4,
            0x4880bbfa8d664f43a1987a81d17c5346eb08bf4e2471146e1f501b38a6ef8a8,
            0x23426d30a8d4e7874c7835e9d8b5365bfc06a64aeea18fcedb89271b35a1b490,
            0x177ab630e0a4fb877db50b2a8a06e7dbc4b5ee690ed3276e50cdeb10c53fa882,
            0x1d288d5d4bb236954164d2db3bb053a79a18bdf2e29d1a0d148feba5e6807a9e,
            0x6ba070d3082e755a2f0477735bcd07d421b38db6babb576cac465d1524cccaf,
            0x6ba070d3082e755a2f0477735bcd07d421b38db6babb576cac465d1524cccaf,
            0x27c81bc615a22abf1fac518dd5e5989568a6c1a9e01c232dce80fcaae6d2483d,
            0x161ffed97d6de369ad85a1f0ece8a2b78c2ad4c18e3ce0aa68970a210fc8cdac,
            0xf4ab79878c744dc417e449d77d865f631040751c61751f26a5c47cc6103394c,
            0x104a5d1f1fcddce2daa6e7f1ab0c26493e2a01e32dedf0fb4fe5e1330eb8298f,
            0x185aa4d67dfc4877aea3c4019cdc087b504d06bdb54709c5a9e535e0a1001f6,
            0x13f4dbcb20e54a15649d2a911e55e4148fdfceb790222f87f2870ea0f2faea7a,
            0x182c615f4962dd5e9e2bcaa2148668c2967b30cbde78cdd953d5efa1ee7305e7,
            0x10e60eadf16da6ae5691b91f92bef89ba9c5a60574f6b23f8ac6fc39b0d73141,
            0x12cebf3da6a166ed7f43f707c64cb377f4cf76063f8c5afe9fb5a52c612e4cae,
        ]
            .span(),
        gemini_fold_comms: array![
            G1Point256 {
                x: 0x30f6ead299b812a9d0e34913e4897baa11cec4f4364333bd02c3ddb15b2796,
                y: 0xe2c88de5ecff9e5e57f587f11a581f95e8311abc9cbc8b79f71f5043aa54178,
            },
            G1Point256 {
                x: 0x24c191be28e3c61bc03e45da0e82ef589a4e35476322229e437e049dbdf633a9,
                y: 0x190ea556eee073ab057011ff249806fce345419ce1c38dc47e6eac312132d8c0,
            },
            G1Point256 {
                x: 0xdca2271951c15f10fe1bd6b142ae96d710cbe11e7f67b885ba8cf553f9b7a89,
                y: 0x222d3b8adfc808eccc9b6be870295d686f2f78a47a20070faa67ac921a0d62ec,
            },
            G1Point256 {
                x: 0x3518fba7088a6f8103d8bc2f72a67a68cff759c9e8e70071a0c0d67a89bd684,
                y: 0x2796e48e3909df2b389f68123329adb1994e35d6faad76671de81ead27b3bef0,
            },
        ]
            .span(),
        gemini_a_evaluations: array![
            0x6d88005bac7d50eaf47b0321f0075d0892f453254935ef79c503047f177ac3c,
            0x1f22b729740dcd28043721670fa5c3f6ec7c6e8f7150848eb590a57bb2c774a1,
            0x27af7bd3cb339be63a51d2305fc2ddf2c887b0a59511ec160aacec44308c9ffd,
            0x16368d4a8fc2dee62530847567ad8d75ecd96aaa541c487628f56c47c5bb1771,
            0xe405cd6caac953006162d7c72468986e014792ee1e09e041c69bea39def7c6d,
        ]
            .span(),
        shplonk_q: G1Point256 {
            x: 0x1e3ce2491c516e0e06eaa5dcad936bce2677c1867be2aeb5720375ffc79b6e21,
            y: 0xd1133764157bc108c1e4e201a02968887c77e16afdbb635b2729af6424c9e9e,
        },
        kzg_quotient: G1Point256 {
            x: 0x1068dd1d211c8b30fdbfa561f69a4d062daa8998dd609fd7de22ed5babb86c4b,
            y: 0x216af708e0184bcac66514720a6bffaa7fee53f2f7ae34dc374df8ede0c3c09b,
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
            x: 0x2465e9ff1629df572d7ae9fd1b9bd98946560392b669c03f9a4a496ae7e4cace,
            y: 0x17bce8fc74ab3b9430b6485da928ea6951ebee411689e29dc324843ee1708142,
        },
        w2: G1Point256 {
            x: 0xeb93267e664634c1ae1a608b81785cfec11669ee95a1dbc6386717066310cb1,
            y: 0x23169272f91d323ced584549d31020c12f7cbf314c309c0ee105c3bbfef28399,
        },
        w3: G1Point256 {
            x: 0xd394ffb5eb2d33c6a2540db125d27fb60665db10ae3f80d91eb189b318d7d58,
            y: 0xa325d606966d0ecbf514d787c3440de179ff8427f66be54fcabe05420fc14d0,
        },
        w4: G1Point256 {
            x: 0xca7365a8a7d92bd713e8625cde47db105835a557cf68ce01414ede87a1ce97b,
            y: 0x26bf12dceab316d64651db4ea03663d3d9478d6ea9a1f20bbe215561e139c7f7,
        },
        z_perm: G1Point256 {
            x: 0x150fee8516b41d650326c31309a4990d8ffc1b3a749d231ce5bb32a2fe9a3aca,
            y: 0x253ecaac9258d26629480e0c790afed3ac3ba708f2f6ee2a6f42d24ad6a195f5,
        },
        lookup_read_counts: G1Point256 {
            x: 0xddfdbbdefc4ac1580ed38e12cfa490d9d719a8b9f020ad3642d60fe704e696f,
            y: 0xff3e0896bdea021253b3d360fa6788289fe9754ce48cd01b7be96a861b5e157,
        },
        lookup_read_tags: G1Point256 {
            x: 0xddfdbbdefc4ac1580ed38e12cfa490d9d719a8b9f020ad3642d60fe704e696f,
            y: 0xff3e0896bdea021253b3d360fa6788289fe9754ce48cd01b7be96a861b5e157,
        },
        lookup_inverses: G1Point256 {
            x: 0x2976428ed585fd630d88a802f53ac1ccf6241ee16f6552777382d8da75bd669c,
            y: 0x23170a48b029c15749f0d6be25e27afb568e2d8329391ae43cc06f08dd2bc7fb,
        },
        sumcheck_univariates: array![
            0x2ea568bb9b0fbad96bfab4cdd5ec5d4d6acf36b3721917c0d01e577fa3e9d811,
            0x1bee5b74621e5504c5590e8ab94fb0fbd64b19507a058d073c39e144c1627f0,
            0x789e70b4c730b2717596fa41f260996aa0e5c2370049dabe0049bc3524278da,
            0x2bce60300eb0b50ec0dcfdc42ff8e5cd613a0a83f23f5b0d10d5c0285f0d9643,
            0x547868237392ffd023f0636977c23a69686d6be9fbdbf0a5c1e40ed50ca8735,
            0x23aad9163424b04b4f2b05213691eebb3ad097747b128c6ce63e8ae1bae8feb5,
            0x204d718e855d811257b64622c3ac27e077d366c3f446cdd3512d5eab749ecaed,
            0xf1e57a9a89025764acf15b96e5554716c7ffb445f23c47cee102c4a06d2433e,
            0x3931c67a31ba186ea2599cf44721c3832a6589234338ea9e0580e3f3777d7a2,
            0x9a17d2fa6a68fe655427598b550d302e3ca747e0bb07dd23d85ad9f18d0491f,
            0x419f4204c5bcf66fce8e51a9910778c456bafe928c496513c48a6409d3f2382,
            0x1a9f4961894483f102b9e365d6a0660c42d9d7d95cf78809131e8be51cea3203,
            0x2e95d687a1343c3abd940508f004159ffca5c828d272b0ee7e1fd3c254ac0436,
            0x180dc3ebbc1a28c2ed66e0e2f019a180cf643c62471bdc4059ceae8d7ca1325e,
            0x8f96bf2cd3a1394ac56be2cf23645b7704ad3a4515fe951e71ec5d34a5c5147,
            0x782754b0a905921f9d8ccc31f4c5c90bbee5a54ed3d1bacc9b0bbe95679681,
            0x18da8c879daaf7552621847dbdbb5e781060bb3159423d4a75f87ae8788229f,
            0x1030e1d053a0b86604eab833039d606a12cdfaa27dc63983d521a3de0aee8aed,
            0x94f0198c3a49efbe2cdf434d3809fd69cf19468cdd20fd440eb38539f65ffd1,
            0xa5f1bde53992046cf1623c620f0aa3a77e92fce5d864bff1da94113f3693b3b,
            0xaae7029f0f1406a9bb0810c300659ab777e214e8ae711d1520d7884e0a13bf0,
            0x13c1f7492ee1804173ed20afc695733ec4464a889d9fc6c184b2b3d959ed1e37,
            0x1876cd36840a96b1071cbca6048f6c4dd4b40a102fd341712d1a8b1b9622756a,
            0xf612d2ce4c4fadecc5e2004aa5b25104c626e086ea8efc83cd37d8aebe7c559,
            0x1a37690745698bcf44987631804190883f6f1262131f3e8b87f26667b546209e,
            0x12f5f65d48a4933db1ba5e79f7014e4ddfc8769d55034a381902e54633355498,
            0x2b5752f2757a4d366d7fe6d2dc9650c256fd0498e766802e8ad7131648859b8f,
            0x1387b796fa652735bb25ff7f66dd1e9f8e85c2dad6738d2f57f49cf8b08c92d1,
            0x2c56640dfc030b0402c6ed933d3e22cbfd31a4668d5dabce34ab4f339b288b69,
            0x81269d5929689a821d57d046a7a80d9f86333bbfba9286f6b5ee5d84a582cd6,
            0x303714945505a0408b75b3acfd052fae091246e63739243540ae83d31c3ed0c0,
            0x2057bd6c5d31e93f6ee040b2d5c1548253eb1488494d1828f685603644993f29,
            0xff4660852e7509c8ea14921bb5c0a2571a6ebbe1cccb5454c260e02fd10fbf5,
            0x271069c06697ca2dd75496cf2a1c81f243cdf6696614795afdfb159788386578,
            0x2a6dba557b498548796543811b3628ab015f83e291fe0ca0735bd637d82082d5,
            0xa10e755d72fab73bd6caed9fea5a9cf426b1511e956c2231e2e71afa0a2a14b,
            0x1d96f788a09152d1b417b381c3d6f7d22d5e38ab5b681d8d5d204a37234ba305,
            0x12eaaf80bd409036fcbfc5a3390e9fa0d28af481fb037baa3ff91d7b6c6b5a83,
            0x9c2ed63977fd13f79c98a73dbbc5c9a6e36714f52ef80417d99b6c17f9422ab,
            0x1b6db7a1d82d27b12a01cc88607a942a8c84fdc2b886282cbccac57d2902cf32,
        ]
            .span(),
        sumcheck_evaluations: array![
            0x12129a295fef237ab0808cbbb57bc176e23f71ca8d849f3dbd0146652f034652,
            0x1cd9c3cdcdb5a1800412059c9f39404a27b750089d3ab92a79579a8e04dd1a66,
            0x85e3e5b7fb43aba55444b2cf33abfb0adace416a64f7cbcd99d4a528076c0ad,
            0x173ede5d6ef962eea65211b0fdbceef8d981d1b9a660afbe39bc1be3df829619,
            0x21b3e62454879b5556124f8290ed3a11b348104f56c78b976a9a7a29b867b7db,
            0x87801594922749f76bd560595a5eb5caa9554cff632e1bfb84ab85361fa9d8a,
            0xc051a8488b1b98546c820767d6b315c8745ecb3f274ac05290c58e3c72a446d,
            0xba60476729055f92c84dc48f95e6bba77a358ce4b4ad1bdac31f892ef6dc98a,
            0x293683138fd84355f1eaee4b6411bf0f4b710145d51dfab0776cfd670ddfc3b0,
            0x2a2d7c45e5c9c5d3109746bbdb4e489b6bc96caf88740971661a3158b2326e60,
            0x1b245f5fd57628881e8e285475929faa58ccd1bd8fd2e45745908d5ce30802f5,
            0x2e18a4e8749d68ba8f7c362e637229a32f16ebab05c9727722ea236b26ab2112,
            0x29f8bcc9b38742f8c4e631087aa2aae8fba1922fe56eb0b100263bf8d65ab8d6,
            0xb934ff8b92f12dcf518f2a053d018f118f62a9967ba94e854c0bebff912aa9c,
            0x2dcecce1882d21015fe8236121e038efd7b1802ae3ae0cf1ce8c5147340ed433,
            0x284f413418a2a672e10a255a6d094164ab11c50847371ff55a3b17eb49339643,
            0x84f60a4ef98ee298438f79ed14c167f6ed3cb0c72fd1ec47300e95e51fb6ed,
            0x82ed2696f8ce381d9709846159db076da70b0aa46ee0843f811cfb4ad8c103a,
            0x2244d2b184047bd1596186e5dedf216cd495458f123a0aec2cb1822fa1008c75,
            0x583c81b10cdc904fd8733b2a187924da47078e29b6e67ce855d21a85cd7d98b,
            0x1023d3232760e12eb74a3674746c00d90c,
            0x315decd89bffb2b2e2f7d5fe29b9367fa0d893f0b1f9a0f65591294bafb9151,
            0x20ff0aabf5552bbc25341af0a2dc265e12648452c2f0f96fecb387771a8e60f8,
            0x18776af43c3f4e51e18895b39f60406fa33de7341453a86a83c871f19e7d08fe,
            0x2041595bca5f22b5f4b27e6631e0537f3c83aec3bb251f25bcab1dcfab302381,
            0x13bf9a24f7eff979c9274c893f99e5d155c7d4bd0a919843e1dcc4b1a853e2d8,
            0x202fe32640b58f5e5fd35f22c80423cfdb19be03c27c5975026866c174aa1e28,
            0x22e5889930b36ae1600f3beef934d05c40cfe6d88311aade255d350ade0fb551,
            0x241a932d8be63f1bf780feef7b2891fd84837da1c2e3311911b353bb302afbaa,
            0x23cabd123d2bf57343cfbbed09bbe6d8291ffa56f4c02269ae223f7b497c78ad,
            0x303b3ddc56754fa60b35d44bb5e2b7340cf2ee7fb10224159a1fca7de6fb4eb,
            0x3358fbb92f150d19fa40bd30765b5e8244b45f8ea97846dccf74effc166fe12,
            0x7c2e49b96b30e8b1d20f778215e50152a2eb480436c273c700f43fda4351516,
            0x2311f5df84872648fa8231a6abc1d1064716fab12a9fc81c5960b380c83c8de4,
            0x2311f5df84872648fa8231a6abc1d1064716fab12a9fc81c5960b380c83c8de4,
            0xe554c2d57387a7f16af7ab9af757016a6780077f28a73d7e32d289e3510d682,
            0xd201d3a855b46b4175dcc8a281508b593a96fd26b3bcc03cdbe056593d6d94b,
            0x524c21fddeb53c0448476b94790cc4d821f90cd7f3be8109dc0dcdbb419b26e,
            0x2f388eecd7b2a422f8df1c74d99dce5cd672d6d60cc3458113b03cd8a187515,
            0x2ec53f36fa98be6bd0cfc45f79b1852e1df2b93859d3b668a4c10e0fcb2b19d2,
            0x919036e7fafe604f0282acf4794048395f117814324143a617641faf9aee057,
            0x180ce6d9947436c8a3f1fe3541aad6753526eb0e4239c1f6f9f5a3ea01bfa370,
            0xae11898960a2b8841acaa68a98ed275c3ae7859d934851c1f9b2e3df3c78409,
            0x1977202af229c164da00062ab84c02759e1d63de54b16fbac40c00dd65926013,
        ]
            .span(),
        gemini_fold_comms: array![
            G1Point256 {
                x: 0x131335e562ea07768c277feb4d6eb8f7b7af1b54750d2b5f4d9c2be232742aa9,
                y: 0x17725d9326a07035794db7873349c73191eabd07797d244b0df79fadac5f3e5,
            },
            G1Point256 {
                x: 0x2bef2a045cf4fe270b6959bd8cce00442932c719462f9e81043dd97ae046de5b,
                y: 0x2d38f5010e2dd307b58238f1778d899286d58585c3bdce030716dacf6d5048a8,
            },
            G1Point256 {
                x: 0x2785ea2bfb5beaf966d566c62156f5f83960e1f66d52ab4313bedb98ef2c0e14,
                y: 0x2f807b2004fde269f7471f066f7b0a52b79896af64e3534781a8d84ef42ebb20,
            },
            G1Point256 {
                x: 0x270b7f5c4098ca567bbe23c5841ba11c3f7e7dd8faea21b8f8d9ff1fe806517e,
                y: 0x24b9408f097208fce6efff2eed43eb9d2f4c0931af1315079cec49eebbd7ebb,
            },
        ]
            .span(),
        gemini_a_evaluations: array![
            0x2a889af0ef53999c33ba661285b50fbe2ab9f39b2b3ee8bc5da0d3c74e5bca2,
            0x1c8d55c763ef3ee2a5c1912abd33515a6f7b56045bc96e3a2882bf1aa7cf8869,
            0xf423ee8586299bd7b6c2a973e2d11fe49a77b1bbb5b442e1f7cf9e735dcc3a4,
            0x6b7a5fafdc77cd0ca3829a00daf0846423c5bbbd19db6f079c99e8166c50f4c,
            0x1fa8842ce6f4b8fa2cd726960dfe6c8410fb2f0dffc61c6a8e479bf299c61195,
        ]
            .span(),
        shplonk_q: G1Point256 {
            x: 0x261d94b543307b990c7012ee99d59389eedffd63316ee5566b61751222bbf179,
            y: 0x442d055b59de2f6e3bb48227e556ea5e74d482df194e927bd9a2208a9c72bfc,
        },
        kzg_quotient: G1Point256 {
            x: 0x2ff7c8a737b2f8053af6488a7c198a80a7d77acbed6bbcca3a067c1240b57408,
            y: 0xf7c09e0288411f190a74908673704ab786d553f2c91c9668e1942a5fa212d4f,
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


