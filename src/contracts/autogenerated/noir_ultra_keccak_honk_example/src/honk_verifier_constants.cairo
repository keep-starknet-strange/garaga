use garaga::definitions::{G1Point, G2Line, u288, u384};
use garaga::utils::noir::HonkVk;

// _vk_hash = keccak256(vk_bytes)
// vk_hash = hades_permutation(_vk_hash.low, _vk_hash.high, 2)
pub const VK_HASH: felt252 = 0x3672c916bc2861e4e85080546e8693744660d836a06859790c0d775c7e90a9b;
pub const vk: HonkVk = HonkVk {
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
};

pub const precomputed_lines: [G2Line; 176] = [
    G2Line {
        r0a0: u288 {
            limb0: 0x4d347301094edcbfa224d3d5,
            limb1: 0x98005e68cacde68a193b54e6,
            limb2: 0x237db2935c4432bc,
        },
        r0a1: u288 {
            limb0: 0x6b4ba735fba44e801d415637,
            limb1: 0x707c3ec1809ae9bafafa05dd,
            limb2: 0x124077e14a7d826a,
        },
        r1a0: u288 {
            limb0: 0x49a8dc1dd6e067932b6a7e0d,
            limb1: 0x7676d0000961488f8fbce033,
            limb2: 0x3b7178c857630da,
        },
        r1a1: u288 {
            limb0: 0x98c81278efe1e96b86397652,
            limb1: 0xe3520b9dfa601ead6f0bf9cd,
            limb2: 0x2b17c2b12c26fdd0,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x19f2be813f1a2cc51a251901,
            limb1: 0xa120afb4bcd07fdae4c4c91b,
            limb2: 0xcd8c8d94eedaaa5,
        },
        r0a1: u288 {
            limb0: 0xa3808ba2f25b910b50769d68,
            limb1: 0xda666e5fa50719fcd79ea2c7,
            limb2: 0x104262c7ecae13e5,
        },
        r1a0: u288 {
            limb0: 0xd00c9d5338bfc75cd1fe4002,
            limb1: 0x25f7441c17b6428fffe6266b,
            limb2: 0x25d0502e1109204d,
        },
        r1a1: u288 {
            limb0: 0x4ce60bf635ff0fe14cf89d2,
            limb1: 0x9ca0af889fc43d4423a03197,
            limb2: 0x1b323f9be536f345,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x1b3d578c32d1af5736582972,
            limb1: 0x204fe74db6b371d37e4615ab,
            limb2: 0xce69bdf84ed6d6d,
        },
        r0a1: u288 {
            limb0: 0xfd262357407c3d96bb3ba710,
            limb1: 0x47d406f500e66ea29c8764b3,
            limb2: 0x1e23d69196b41dbf,
        },
        r1a0: u288 {
            limb0: 0x1ec8ee6f65402483ad127f3a,
            limb1: 0x41d975b678200fce07c48a5e,
            limb2: 0x2cad36e65bbb6f4f,
        },
        r1a1: u288 {
            limb0: 0xcfa9b8144c3ea2ab524386f5,
            limb1: 0xd4fe3a18872139b0287570c3,
            limb2: 0x54c8bc1b50aa258,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xb5ee22ba52a7ed0c533b7173,
            limb1: 0xbfa13123614ecf9c4853249b,
            limb2: 0x6567a7f6972b7bb,
        },
        r0a1: u288 {
            limb0: 0xcf422f26ac76a450359f819e,
            limb1: 0xc42d7517ae6f59453eaf32c7,
            limb2: 0x899cb1e339f7582,
        },
        r1a0: u288 {
            limb0: 0x9f287f4842d688d7afd9cd67,
            limb1: 0x30af75417670de33dfa95eda,
            limb2: 0x1121d4ca1c2cab36,
        },
        r1a1: u288 {
            limb0: 0x7c4c55c27110f2c9a228f7d8,
            limb1: 0x8f14f6c3a2e2c9d74b347bfe,
            limb2: 0x83ef274ba7913a5,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x4e7f0c0bfd065f51be57e446,
            limb1: 0x172f9601c4b0d882b2bca176,
            limb2: 0x238b85999243f584,
        },
        r0a1: u288 {
            limb0: 0xc4f13eea49c4fb0b88065fdf,
            limb1: 0xdde9d756dc7a3e60bfe2c7c9,
            limb2: 0x2021ebaaf4838c43,
        },
        r1a0: u288 {
            limb0: 0x98652d3a0360c4ba067ebd45,
            limb1: 0x9259019a69cb15cd979b4425,
            limb2: 0xa93fe44d0287fdc,
        },
        r1a1: u288 {
            limb0: 0x63a369cdd8c09b18c3ad7375,
            limb1: 0x1baf962de1bd1b1973e138fa,
            limb2: 0x15320ed6fbfaace4,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x1a9ecb5a41abb65787e46934,
            limb1: 0x28fec59f9911882bd4d50306,
            limb2: 0x25996b3cd58cce92,
        },
        r0a1: u288 {
            limb0: 0x56f5cca0fddcae1bfbee4b4d,
            limb1: 0x4237b58cc71911abcefd1d92,
            limb2: 0x2d985c4da93484d4,
        },
        r1a0: u288 {
            limb0: 0x406454881e1f6cab8a9ab13c,
            limb1: 0x2cdf1a77980edf520cc8f23f,
            limb2: 0x20ce11ddb649cf18,
        },
        r1a1: u288 {
            limb0: 0xfe104a8fa2c57b6b94bf56d2,
            limb1: 0xe2debabd9212070fd38f818,
            limb2: 0x1c1a2364541a15be,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xfc23a674d089e9cfdefb1db8,
            limb1: 0x9ddfd61d289b65a9b4254476,
            limb2: 0x1e2f561324ef4447,
        },
        r0a1: u288 {
            limb0: 0xf67a6a9e31f6975b220642ea,
            limb1: 0xccd852893796296e4d1ed330,
            limb2: 0x94ff1987d19b62,
        },
        r1a0: u288 {
            limb0: 0x360c2a5aca59996d24cc1947,
            limb1: 0x66c2d7d0d176a3bc53f386e8,
            limb2: 0x2cfcc62a17fbeecb,
        },
        r1a1: u288 {
            limb0: 0x2ddc73389dd9a9e34168d8a9,
            limb1: 0xae9afc57944748b835cbda0f,
            limb2: 0x12f0a1f8cf564067,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xef09c2458cc3abc041e9fa2d,
            limb1: 0x787c6d7a93e94be14277d18d,
            limb2: 0xbb1d328b2d75a8a,
        },
        r0a1: u288 {
            limb0: 0x1911705c689a06b1dfab80c,
            limb1: 0x72781338c8dfb4eb593e44c,
            limb2: 0x1405249e47100437,
        },
        r1a0: u288 {
            limb0: 0x4dca335dcaeaf9d99ab7ad63,
            limb1: 0xd36f68812432efaedffce9a7,
            limb2: 0x1131840a72c4fa9,
        },
        r1a1: u288 {
            limb0: 0x5676dc996dc5b1ce91fd01c1,
            limb1: 0xbbf4fcfae2062f0031601f40,
            limb2: 0x2f8f5c5bff703235,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x9c963c4bdade6ce3d460b077,
            limb1: 0x1738311feefc76f565e34e8a,
            limb2: 0x1aae0d6c9e9888ad,
        },
        r0a1: u288 {
            limb0: 0x9272581fdf80b045c9c3f0a,
            limb1: 0x3946807b0756e87666798edb,
            limb2: 0x2bf6eeda2d8be192,
        },
        r1a0: u288 {
            limb0: 0x3e957661b35995552fb475de,
            limb1: 0xd8076fa48f93f09d8128a2a8,
            limb2: 0xb6f87c3f00a6fcf,
        },
        r1a1: u288 {
            limb0: 0xcf17d6cd2101301246a8f264,
            limb1: 0x514d04ad989b91e697aa5a0e,
            limb2: 0x175f17bbd0ad1219,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x894bc18cc70ca1987e3b8f9f,
            limb1: 0xd4bfa535181f0f8659b063e3,
            limb2: 0x19168d524164f463,
        },
        r0a1: u288 {
            limb0: 0x850ee8d0e9b58b82719a6e92,
            limb1: 0x9fc4eb75cbb027c137d48341,
            limb2: 0x2b2f8a383d944fa0,
        },
        r1a0: u288 {
            limb0: 0x5451c8974a709483c2b07fbd,
            limb1: 0xd7e09837b8a2a3b78e7fe525,
            limb2: 0x347d96be5e7fa31,
        },
        r1a1: u288 {
            limb0: 0x823f2ba2743ee254e4c18a1e,
            limb1: 0x6a61af5db035c443ed0f8172,
            limb2: 0x1e840eee275d1063,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xdd132544fc661724c31c8a08,
            limb1: 0x287b549c39c0ea0a391cbe18,
            limb2: 0x29c2742c0ca03d7b,
        },
        r0a1: u288 {
            limb0: 0xb3076d9218b75e044db009b0,
            limb1: 0xf0e2da346da73ed6e537273,
            limb2: 0x16cd48b0b23a5a69,
        },
        r1a0: u288 {
            limb0: 0x5eeab759aec37540ef3b3200,
            limb1: 0x90c30b490593b4f0a2750f65,
            limb2: 0x263476e7a8250501,
        },
        r1a1: u288 {
            limb0: 0x437a75606a5486770a5c4450,
            limb1: 0xbb6a0a3aa70be067ddcfdbfc,
            limb2: 0xc03b2e169fa0cd0,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x185a998303998a727a80004d,
            limb1: 0xb23554df68e88aa4bcb90b09,
            limb2: 0x293e05c0080aedc,
        },
        r0a1: u288 {
            limb0: 0xfcd79ce56915d6462fb8a51a,
            limb1: 0x8c7691de25e8c4b96117b24,
            limb2: 0xa849fd468442c55,
        },
        r1a0: u288 {
            limb0: 0xc8661606e6d6b1e5a00268eb,
            limb1: 0xbe2235d18dd52b903e1858e2,
            limb2: 0x222c8e6db445fbf7,
        },
        r1a1: u288 {
            limb0: 0x803355a17297b5f77e52231c,
            limb1: 0x7927c03bd5d3798208bf7a23,
            limb2: 0x111b3dbe82eb4f62,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x18d630598e58bb5d0102b30e,
            limb1: 0x9767e27b02a8da37411a2787,
            limb2: 0x100a541662b9cd7c,
        },
        r0a1: u288 {
            limb0: 0x4ca7313df2e168e7e5ea70,
            limb1: 0xd49cce6abd50b574f31c2d72,
            limb2: 0x78a2afbf72317e7,
        },
        r1a0: u288 {
            limb0: 0x6d99388b0a1a67d6b48d87e0,
            limb1: 0x1d8711d321a193be3333bc68,
            limb2: 0x27e76de53a010ce1,
        },
        r1a1: u288 {
            limb0: 0x77341bf4e1605e982fa50abd,
            limb1: 0xc5cf10db170b4feaaf5f8f1b,
            limb2: 0x762adef02274807,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x401adda3a335074256e01cf5,
            limb1: 0x247f8405ee3a5143b8fc7947,
            limb2: 0x2c37793269c12835,
        },
        r0a1: u288 {
            limb0: 0x9ecc215e40764ce6a6db3ce0,
            limb1: 0x14e8a7b5a57b166edcdfb52,
            limb2: 0x29e744551489dc3f,
        },
        r1a0: u288 {
            limb0: 0xee025e7cc0634b8b2fcd88dd,
            limb1: 0x94b3602ee4867d04d1e549ae,
            limb2: 0xcce5739cfedc699,
        },
        r1a1: u288 {
            limb0: 0x2c7318ae1f6db5d41f684334,
            limb1: 0xd1ba91922e100971bd11dbb5,
            limb2: 0x1d6c654d5c0913a4,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xa137b991ba9048aee9fa0bc7,
            limb1: 0xf5433785c186cd1100ab6b80,
            limb2: 0xab519fd7cf8e7f9,
        },
        r0a1: u288 {
            limb0: 0x90832f45d3398c60aa1a74e2,
            limb1: 0x17f7ac209532723f22a344b,
            limb2: 0x23db979f8481c5f,
        },
        r1a0: u288 {
            limb0: 0x723b0e23c2808a5d1ea6b11d,
            limb1: 0x3030030d26411f84235c3af5,
            limb2: 0x122e78da5509eddb,
        },
        r1a1: u288 {
            limb0: 0xf1718c1e21a9bc3ec822f319,
            limb1: 0xf5ee6dfa3bd3272b2f09f0c7,
            limb2: 0x5a29c1e27616b34,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x6cf0dc0a1a42af130a792bff,
            limb1: 0x6eeb4dd41cb8967cd7416c41,
            limb2: 0x832ca9524375cb4,
        },
        r0a1: u288 {
            limb0: 0x7e263bdeb1fedd385682b4fc,
            limb1: 0x3eee92fe8cdb332aeb31d573,
            limb2: 0x125dc8ce07406159,
        },
        r1a0: u288 {
            limb0: 0x5fce3aa533d50f8eff589829,
            limb1: 0x15cefc9330a131dfb10a5ae6,
            limb2: 0x2fa0a33e98e84220,
        },
        r1a1: u288 {
            limb0: 0xed6540b1d66bbf1f7bf86da8,
            limb1: 0x3a5266544635cad0d58d64d6,
            limb2: 0x149069d5ba2e34da,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xbc1ede480873fceb8739511e,
            limb1: 0xd5a60533bd0ce7869efbc15,
            limb2: 0x182c17d793eba74d,
        },
        r0a1: u288 {
            limb0: 0x83bf38d91876ad8999516bc2,
            limb1: 0x7756322ea3dc079289d51f2d,
            limb2: 0x1d0f6156a89a4244,
        },
        r1a0: u288 {
            limb0: 0x6aba652f197be8f99707b88c,
            limb1: 0xbf94286c245794ea0f562f32,
            limb2: 0x25a358967a2ca81d,
        },
        r1a1: u288 {
            limb0: 0xc028cbff48c01433e8b23568,
            limb1: 0xd2e791f5772ed43b056beba1,
            limb2: 0x83eb38dff4960e,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xf0ea4a2e24640eb0043fa781,
            limb1: 0x8a5ca14e0ac3b7d4409fcb40,
            limb2: 0x67b373e8abc5602,
        },
        r0a1: u288 {
            limb0: 0x7c391162763fc85bf5c94818,
            limb1: 0xb389e19eb97568e7e7e4617d,
            limb2: 0x1d3f1c590945ef5c,
        },
        r1a0: u288 {
            limb0: 0xce60f9534da6a36cda2ebe99,
            limb1: 0x4a48ecfd6beb4596b2736458,
            limb2: 0x2a3e1d1f2d7f13e0,
        },
        r1a1: u288 {
            limb0: 0x8546f7e328bc13d11bb19a65,
            limb1: 0xb68deedd4c4b131fa83bb2a5,
            limb2: 0x15f7b8d2c8e7626e,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xc2a2b787d8e718e81970db80,
            limb1: 0x5372abeaf56844dee60d6198,
            limb2: 0x131210153a2217d6,
        },
        r0a1: u288 {
            limb0: 0x70421980313e09a8a0e5a82d,
            limb1: 0xf75ca1f68f4b8deafb1d3b48,
            limb2: 0x102113c9b6feb035,
        },
        r1a0: u288 {
            limb0: 0x4654c11d73bda84873de9b86,
            limb1: 0xa67601bca2e595339833191a,
            limb2: 0x1c2b76e439adc8cc,
        },
        r1a1: u288 {
            limb0: 0x9c53a48cc66c1f4d644105f2,
            limb1: 0xa17a18867557d96fb7c2f849,
            limb2: 0x1deb99799bd8b63a,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xc32026c56341297fa080790c,
            limb1: 0xe23ad2ff283399133533b31f,
            limb2: 0xa6860f5c968f7ad,
        },
        r0a1: u288 {
            limb0: 0x2966cf259dc612c6a4d8957d,
            limb1: 0xfba87ea86054f3db5774a08f,
            limb2: 0xc73408b6a646780,
        },
        r1a0: u288 {
            limb0: 0x6272ce5976d8eeba08f66b48,
            limb1: 0x7dfbd78fa06509604c0cec8d,
            limb2: 0x181ec0eaa6660e45,
        },
        r1a1: u288 {
            limb0: 0x48af37c1a2343555fbf8a357,
            limb1: 0xa7b5e1e20e64d6a9a9ce8e61,
            limb2: 0x1147dcea39a47abd,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x24892e4246676601de7ff011,
            limb1: 0x538390fa26e7a81a0d183f27,
            limb2: 0x3410fd15a886c28,
        },
        r0a1: u288 {
            limb0: 0x26b21dedab7f4232acbd4ff0,
            limb1: 0xa3b070b5094882aba51e9b07,
            limb2: 0xd20955719266e4d,
        },
        r1a0: u288 {
            limb0: 0xe9495357ddc8fab97186f3fa,
            limb1: 0x39314e488ba5e56819f2526f,
            limb2: 0x2319d043c6fac62e,
        },
        r1a1: u288 {
            limb0: 0x43af9a4d62880cabbd0c0091,
            limb1: 0x85c4696da0e2107eebe8d213,
            limb2: 0x15e73634a9b93263,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x7225a042235a3e52ed4f3656,
            limb1: 0x29547006cc96d9af59e981e9,
            limb2: 0x2bb8d83d86b1948,
        },
        r0a1: u288 {
            limb0: 0x7aff77100255f01d01e06689,
            limb1: 0xeafc9593264cb70dd2c5c40a,
            limb2: 0x16feef8d11db8f6c,
        },
        r1a0: u288 {
            limb0: 0x38197214c4ec640e68ed7bd6,
            limb1: 0x6095d2ae38e508122aa0bacd,
            limb2: 0x15ee15a5c89d28c4,
        },
        r1a1: u288 {
            limb0: 0x59cc5927de581d2bba41fb39,
            limb1: 0x9368a6b2bf2630ccd9ee111a,
            limb2: 0x1d1cd760d41a3053,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x4033c51e6e469818521cd2ae,
            limb1: 0xb71a4629a4696b2759f8e19e,
            limb2: 0x4f5744e29c1eb30,
        },
        r0a1: u288 {
            limb0: 0xa4f47bbc60cb0649dca1c772,
            limb1: 0x835f427106f4a6b897c6cf23,
            limb2: 0x17ca6ea4855756bb,
        },
        r1a0: u288 {
            limb0: 0x7f844a35c7eeadf511e67e57,
            limb1: 0x8bb54fb0b3688cac8860f10,
            limb2: 0x1c7258499a6bbebf,
        },
        r1a1: u288 {
            limb0: 0x10d269c1779f96946e518246,
            limb1: 0xce6fcef6676d0dacd395dc1a,
            limb2: 0x2cf4c6ae1b55d87d,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xb8a97adf87c08c9754a126a3,
            limb1: 0x75a7ddf60605563f709106d2,
            limb2: 0x27851c7de29730da,
        },
        r0a1: u288 {
            limb0: 0x8c5ecd7d4bb18df0499e32c7,
            limb1: 0x2534a91e249a1d6c311618e6,
            limb2: 0xc0140c1c13a3493,
        },
        r1a0: u288 {
            limb0: 0x68d1a39239845ea787e22238,
            limb1: 0xb5a4c3ee8333093391b6d4cd,
            limb2: 0x1dc5f5b99d814946,
        },
        r1a1: u288 {
            limb0: 0x8ef9ff9b9895bbf279c0fa0d,
            limb1: 0x7d3d2f468c0ac9e19fb7c2d,
            limb2: 0xac27e05ceb646b5,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xab74a6bae36b17b1d2cc1081,
            limb1: 0x904cf03d9d30b1fe9dc71374,
            limb2: 0x14ffdd55685b7d82,
        },
        r0a1: u288 {
            limb0: 0x277f7180b7cf33feded1583c,
            limb1: 0xc029c3968a75b612303c4298,
            limb2: 0x20ef4ba03605cdc6,
        },
        r1a0: u288 {
            limb0: 0xd5a7a27c1baba3791ab18957,
            limb1: 0x973730213d5d70d3e62d6db,
            limb2: 0x24ca121c566eb857,
        },
        r1a1: u288 {
            limb0: 0x9f4c2dea0492f548ae7d9e93,
            limb1: 0xe584b6b251a5227c70c5188,
            limb2: 0x22bcecac2bd5e51b,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x340c82974f7221a53fc2f3ac,
            limb1: 0x7146f18cd591d423874996e7,
            limb2: 0xa6d154791056f46,
        },
        r0a1: u288 {
            limb0: 0x70894ea6418890d53b5ee12a,
            limb1: 0x882290cb53b795b0e7c8c208,
            limb2: 0x1b5777dc18b2899b,
        },
        r1a0: u288 {
            limb0: 0x99a0e528d582006a626206b6,
            limb1: 0xb1cf825d80e199c5c9c795b5,
            limb2: 0x2a97495b032f0542,
        },
        r1a1: u288 {
            limb0: 0xc7cf5b455d6f3ba73debeba5,
            limb1: 0xbb0a01235687223b7b71d0e5,
            limb2: 0x250024ac44c35e3f,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xcd61de038885e78d976e417f,
            limb1: 0x81fe397759fd09af54407334,
            limb2: 0x28d442dfdc1a2e12,
        },
        r0a1: u288 {
            limb0: 0x75958d6bff91ac1f4b906a6e,
            limb1: 0xa9ceae56d3016a7b9be4e8d1,
            limb2: 0x1eb27b86e4ca4913,
        },
        r1a0: u288 {
            limb0: 0x9e78d6b4bc7dbeb138bb7110,
            limb1: 0x8fa9343766858993e6f9769e,
            limb2: 0x25d95a1cdd51a5b7,
        },
        r1a1: u288 {
            limb0: 0xd0e3a9be366e1fc7643320e8,
            limb1: 0xc0ba2c1555ff8ac9ad6f5297,
            limb2: 0x1d994b7cec2490e8,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x1e9cf4d22158dc2de3993ad9,
            limb1: 0x71f64b04e8e9d545208968bb,
            limb2: 0x11d02ad0f13cfec0,
        },
        r0a1: u288 {
            limb0: 0xacbea6d3f08ecb77503f05de,
            limb1: 0x611d520b74ddcb9f2e5828f0,
            limb2: 0x26202c3e458eb353,
        },
        r1a0: u288 {
            limb0: 0xb61d83483ca541f57440987c,
            limb1: 0xa086532338a5827b1445f1c6,
            limb2: 0x1f5ebd76b5310b94,
        },
        r1a1: u288 {
            limb0: 0xcac91c4843a6bad2a7cc91cb,
            limb1: 0x4fbd17f04d76a1b165fed733,
            limb2: 0x1e860876cd8963af,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xccf841cf5c1cf8f4a0485e28,
            limb1: 0xb5077662d0ce9d755af1446b,
            limb2: 0x2b08658e9d5ba5cb,
        },
        r0a1: u288 {
            limb0: 0x6ce62184a15685babd77f27f,
            limb1: 0x5ff9bb7d74505b0542578299,
            limb2: 0x7244563488bab2,
        },
        r1a0: u288 {
            limb0: 0xec778048d344ac71275d961d,
            limb1: 0x1273984019753000ad890d33,
            limb2: 0x27c2855e60d361bd,
        },
        r1a1: u288 {
            limb0: 0xa7a0071e22af2f3a79a12da,
            limb1: 0xc84a6fd41c20759ff6ff169a,
            limb2: 0x23e7ef2a308e49d1,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x68a906f2806a6cc426b24994,
            limb1: 0x784dcf104c1dcf0e8f856da2,
            limb2: 0xc9654f8fbdf2892,
        },
        r0a1: u288 {
            limb0: 0x9bea5cd65447a96f85459dd6,
            limb1: 0x13d9bb083bdab401220475b7,
            limb2: 0x2bd224747d636b4e,
        },
        r1a0: u288 {
            limb0: 0xae8a73f18ff26f9d25fc0042,
            limb1: 0x947f72870798502183924783,
            limb2: 0xae687f4109514e,
        },
        r1a1: u288 {
            limb0: 0x3dd221c63901d92fbe7bec24,
            limb1: 0x803d8cd513a8fe56a98984c2,
            limb2: 0x11912c747e407b17,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x7105024c431a33683d9d0b9d,
            limb1: 0x12e23637b641ab0e5b322ad8,
            limb2: 0x2918e9e08c764c28,
        },
        r0a1: u288 {
            limb0: 0x26384979d1f5417e451aeabf,
            limb1: 0xacfb499e362291d0b053bbf6,
            limb2: 0x2a6ad1a1f7b04ef6,
        },
        r1a0: u288 {
            limb0: 0xba4db515be70c384080fc9f9,
            limb1: 0x5a983a6afa9cb830fa5b66e6,
            limb2: 0x8cc1fa494726a0c,
        },
        r1a1: u288 {
            limb0: 0x59c9af9399ed004284eb6105,
            limb1: 0xef37f66b058b4c971d9c96b0,
            limb2: 0x2c1839afde65bafa,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xd468740be11c72f0d61b3544,
            limb1: 0xee4537e6229611d1ee5d08f9,
            limb2: 0x25f95d481420c22b,
        },
        r0a1: u288 {
            limb0: 0x1057f10f48392fe4e6a8cbb,
            limb1: 0x71eaba2ec1ad3c43203ee8b9,
            limb2: 0x28ebfa58c1c65aa1,
        },
        r1a0: u288 {
            limb0: 0x7d03e13f07b1eecb5cd01d9d,
            limb1: 0x4e866746c563214e0043c745,
            limb2: 0x2cd7dc2b0c6cbb4b,
        },
        r1a1: u288 {
            limb0: 0x5eabc3fb0a14cc2cb63ecd7c,
            limb1: 0xcfa5e22677730b5197985457,
            limb2: 0x3db7ea133dcce6e,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x6bf13a27b0f4eb6657abc4b,
            limb1: 0xf78d57f089bffdf07c676bb3,
            limb2: 0x228e4aefbdd738df,
        },
        r0a1: u288 {
            limb0: 0x4f41a40b04ec964619823053,
            limb1: 0xfa3fb44f4a80641a9bb3bc09,
            limb2: 0x29bf29a3d071ec4b,
        },
        r1a0: u288 {
            limb0: 0x83823dcdff02bdc8a0e6aa03,
            limb1: 0x79ac92f113de29251cd73a98,
            limb2: 0x1ccdb791718d144,
        },
        r1a1: u288 {
            limb0: 0xa074add9d066db9a2a6046b6,
            limb1: 0xef3a70034497456c7d001a5,
            limb2: 0x27d09562d815b4a6,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xbf11dea21cd379f966caa6c2,
            limb1: 0x4e0f8e4b2b5917c45d535ef,
            limb2: 0xc735dd71c68e4ca,
        },
        r0a1: u288 {
            limb0: 0xa605ae0ab6554385d99f6e12,
            limb1: 0x87cd556340ce9c7cc8a6ac63,
            limb2: 0x210538d78dc01108,
        },
        r1a0: u288 {
            limb0: 0xc496c32da98d1ae345266146,
            limb1: 0x76a57df0969a21af8983781e,
            limb2: 0x269e9aa6f168324a,
        },
        r1a1: u288 {
            limb0: 0x820373298d73bb39e9d80644,
            limb1: 0x987291249714fb863a8353df,
            limb2: 0x120dfbe3b8b4c9c,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x87a44d343cc761056f4f2eae,
            limb1: 0x18016f16818253360d2c8adf,
            limb2: 0x1bcd5c6e597d735e,
        },
        r0a1: u288 {
            limb0: 0x593d7444c376f6d69289660b,
            limb1: 0x1d6d97020b59cf2e4b38be4f,
            limb2: 0x17133b62617f63a7,
        },
        r1a0: u288 {
            limb0: 0x88cac99869bb335ec9553a70,
            limb1: 0x95bcfa7f7c0b708b4d737afc,
            limb2: 0x1eec79b9db274c09,
        },
        r1a1: u288 {
            limb0: 0xe465a53e9fe085eb58a6be75,
            limb1: 0x868e45cc13e7fd9d34e11839,
            limb2: 0x2b401ce0f05ee6bb,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x83f48fbac5c1b94486c2d037,
            limb1: 0xf95d9333449543de78c69e75,
            limb2: 0x7bca8163e842be7,
        },
        r0a1: u288 {
            limb0: 0x60157b2ff6e4d737e2dac26b,
            limb1: 0x30ab91893fcf39d9dcf1b89,
            limb2: 0x29a58a02490d7f53,
        },
        r1a0: u288 {
            limb0: 0x520f9cb580066bcf2ce872db,
            limb1: 0x24a6e42c185fd36abb66c4ba,
            limb2: 0x309b07583317a13,
        },
        r1a1: u288 {
            limb0: 0x5a4c61efaa3d09a652c72471,
            limb1: 0xfcb2676d6aa28ca318519d2,
            limb2: 0x1405483699afa209,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x887e3388d815fefbe4de67c7,
            limb1: 0x39aabdf16d5e820c468f07b4,
            limb2: 0x1021ded60046ae5d,
        },
        r0a1: u288 {
            limb0: 0x1ffd3f4a7c51d9b9b426759a,
            limb1: 0xfdcac9390f248e3358903bef,
            limb2: 0xc85ed498a09eaa4,
        },
        r1a0: u288 {
            limb0: 0x2e3d9ddae0fe891656c2ebbd,
            limb1: 0xdbb3756450184a201ee6f6f4,
            limb2: 0x1f77f974e15e790c,
        },
        r1a1: u288 {
            limb0: 0xc94662f8a91d828962406a80,
            limb1: 0x35b6584b35acc901cd8c124d,
            limb2: 0x1b6cbe14b354c93c,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x4e0b59155b1586438f00d1d0,
            limb1: 0xe7fce333454bea5e5d19da67,
            limb2: 0x2286d1f263814635,
        },
        r0a1: u288 {
            limb0: 0xdb0108b13b264fa9efe313bd,
            limb1: 0x25a0231213b6afe0cc5ac9,
            limb2: 0x24a55b37cab9e96f,
        },
        r1a0: u288 {
            limb0: 0x10568376d2134a925d8224e2,
            limb1: 0x66ff6c53966243f66701ce36,
            limb2: 0xf0bab9bbaa38df8,
        },
        r1a1: u288 {
            limb0: 0x9faf33001f67c41b255de466,
            limb1: 0x30656441023848f72165541a,
            limb2: 0x1b964ad8ff7afd21,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xbfdfdae86101e29da3e869b8,
            limb1: 0xf969a9b961a28b872e56aac2,
            limb2: 0x1afdc719440d90f0,
        },
        r0a1: u288 {
            limb0: 0xee43c995686f13baa9b07266,
            limb1: 0xbfa387a694c641cceee4443a,
            limb2: 0x104d8c02eb7f60c8,
        },
        r1a0: u288 {
            limb0: 0x8d451602b3593e798aecd7fb,
            limb1: 0x69ffbefe7c5ac2cf68e8691e,
            limb2: 0x2ea064a1bc373d28,
        },
        r1a1: u288 {
            limb0: 0x6e7a663073bfe88a2b02326f,
            limb1: 0x5faadb36847ca0103793fa4a,
            limb2: 0x26c09a8ec9303836,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xa02ed8b8bea4e6398937e400,
            limb1: 0xba34c7a8c92f6fb9c7eb1009,
            limb2: 0x14021afa35038d6f,
        },
        r0a1: u288 {
            limb0: 0x5fed8893a16fc89c77ab6e69,
            limb1: 0x341d37d9e774298c8289039e,
            limb2: 0x14228ddafe44ce59,
        },
        r1a0: u288 {
            limb0: 0x578a1f7a73e6d177db8ef992,
            limb1: 0xe0414e8de48555d5e7715a16,
            limb2: 0x48dd64815f16a0a,
        },
        r1a1: u288 {
            limb0: 0xf23687d236711b4c0ca8ce76,
            limb1: 0x50664dd13060c77c5166e7fe,
            limb2: 0x10090c847a3c2764,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x3d038747ebac16adc1c50bdd,
            limb1: 0xe3706a783e99f73ac742aa1a,
            limb2: 0x17eac23b00b545ff,
        },
        r0a1: u288 {
            limb0: 0xdc25ff0bd02abcbe502c4e37,
            limb1: 0x39b92e6ebb65e5f2d8504f90,
            limb2: 0x2415b5f61301dff6,
        },
        r1a0: u288 {
            limb0: 0x9cdcb2146d15f37900db82ac,
            limb1: 0x96c3940e2f5c5f8198fadee3,
            limb2: 0x2f662ea79b473fc2,
        },
        r1a1: u288 {
            limb0: 0xc0fb95686de65e504ed4c57a,
            limb1: 0xec396c7c4275d4e493b00713,
            limb2: 0x106d2aab8d90d517,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xb836776ba636148782ccc53a,
            limb1: 0xc85e575c26103c32434b48b3,
            limb2: 0xbbd5f5df165aeca,
        },
        r0a1: u288 {
            limb0: 0x75eb6906bb101ea7f525fe68,
            limb1: 0xa69a82fea7ca9f41fb7f0712,
            limb2: 0x2d0f62c13f7d525b,
        },
        r1a0: u288 {
            limb0: 0x94475fc56769da417d920d02,
            limb1: 0x9bacf6721bad4841a1ead330,
            limb2: 0x264649c0901fd86,
        },
        r1a1: u288 {
            limb0: 0x45cddba5ab6cb8d80986a4b5,
            limb1: 0x8a2735ec64c123d9b1d94e43,
            limb2: 0x8b8c3087a3fc782,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x49bbb4d856921e3177c0b5bf,
            limb1: 0x76d84d273694e662bdd5d364,
            limb2: 0xea5dc611bdd369d,
        },
        r0a1: u288 {
            limb0: 0x9e9fc3adc530fa3c5c6fd7fe,
            limb1: 0x114bb0c0e8bd247da41b3883,
            limb2: 0x6044124f85d2ce,
        },
        r1a0: u288 {
            limb0: 0xa6e604cdb4e40982a97c084,
            limb1: 0xef485caa56c7820be2f6b11d,
            limb2: 0x280de6387dcbabe1,
        },
        r1a1: u288 {
            limb0: 0xcaceaf6df5ca9f8a18bf2e1e,
            limb1: 0xc5cce932cc6818b53136c142,
            limb2: 0x12f1cd688682030c,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x37497c23dcf629df58a5fa12,
            limb1: 0x4fcd5534ae47bded76245ac9,
            limb2: 0x1715ab081e32ac95,
        },
        r0a1: u288 {
            limb0: 0x856275471989e2c288e3c83,
            limb1: 0xb42d81a575b89b127a7821a,
            limb2: 0x5fa75a0e4ae3118,
        },
        r1a0: u288 {
            limb0: 0xeb22351e8cd345c23c0a3fef,
            limb1: 0x271feb16d4b47d2267ac9d57,
            limb2: 0x258f9950b9a2dee5,
        },
        r1a1: u288 {
            limb0: 0xb5f75468922dc025ba7916fa,
            limb1: 0x7e24515de90edf1bde4edd9,
            limb2: 0x289145b3512d4d81,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xce1ded2782ddd08e6865ab4,
            limb1: 0x4583c91a985a438fdac4f4c,
            limb2: 0x13d595d330502573,
        },
        r0a1: u288 {
            limb0: 0x595067b65592ac4d6c9b5b5c,
            limb1: 0x4ef806daef8c02f94ecaf97f,
            limb2: 0x7869c312062e0a8,
        },
        r1a0: u288 {
            limb0: 0x38cb6ea081fb30e87015f4c3,
            limb1: 0xc380b087269e9836e39be81,
            limb2: 0x7619e66982167dd,
        },
        r1a1: u288 {
            limb0: 0x84f696893f8cb0e616e335b6,
            limb1: 0xb7fd749a8812159ce96c3f43,
            limb2: 0x2b80806bd7eeb0cd,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xeed11dd701d662b9bd85fda4,
            limb1: 0x284c3b305b25ed852d47268e,
            limb2: 0x37e8aad03f1efa3,
        },
        r0a1: u288 {
            limb0: 0x1ba355db79739c5b954c99e,
            limb1: 0xd38db182b11b150b1ac2b6cd,
            limb2: 0x1b416cf91fe88aa,
        },
        r1a0: u288 {
            limb0: 0xd8f230276c30350267b5d2e6,
            limb1: 0x6057c8dd8abc942db7f6e156,
            limb2: 0x127d2dc576c754d8,
        },
        r1a1: u288 {
            limb0: 0x3a34d39084d5d8b2204f6632,
            limb1: 0xe18cb27f7b45639b6cb65d23,
            limb2: 0xb6cc7185cc1c602,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x95b7b32bcc3119c64a62a8de,
            limb1: 0xe07184496f17bbd59a4b7bbd,
            limb2: 0x1708c536fd78b531,
        },
        r0a1: u288 {
            limb0: 0xfa85b5778c77166c1523a75e,
            limb1: 0x89a00c53309a9e525bef171a,
            limb2: 0x2d2287dd024e421,
        },
        r1a0: u288 {
            limb0: 0x31fd0884eaf2208bf8831e72,
            limb1: 0x537e04ea344beb57ee645026,
            limb2: 0x23c7f99715257261,
        },
        r1a1: u288 {
            limb0: 0x8c38b3aeea525f3c2d2fdc22,
            limb1: 0xf838a99d9ec8ed6dcec6a2a8,
            limb2: 0x2973d5159ddc479a,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x3f058d8c63fd905d3ca29b42,
            limb1: 0x1f0a90982cc68e4ddcd83e57,
            limb2: 0x240aeaae0783fbfa,
        },
        r0a1: u288 {
            limb0: 0xedfee81d80da310fdf0d0d8,
            limb1: 0xc2208e6de8806cf491bd74d4,
            limb2: 0xb7318be62a476af,
        },
        r1a0: u288 {
            limb0: 0x3c6920c8a24454c634f388fe,
            limb1: 0x23328a006312a722ae09548b,
            limb2: 0x1d2f1c58b80432e2,
        },
        r1a1: u288 {
            limb0: 0xb72980574f7a877586de3a63,
            limb1: 0xcd773b87ef4a29c16784c5ae,
            limb2: 0x1f812c7e22f339c5,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x4ee6eef57f5c866acf77f595,
            limb1: 0x3aec7154a9f1f285829186a5,
            limb2: 0x283e9794a30457d,
        },
        r0a1: u288 {
            limb0: 0xd59a661484d8c376567086d3,
            limb1: 0x1f9c69bb6fb467cd93899dd2,
            limb2: 0x25dd4d1be0b765b,
        },
        r1a0: u288 {
            limb0: 0x5b9c47593dfbd508ab34c7b3,
            limb1: 0x5cc228830e12085b69b345df,
            limb2: 0x563a3f38bb17d2d,
        },
        r1a1: u288 {
            limb0: 0xd13362074a4f1c9ad9063afd,
            limb1: 0xae0b6ddad1bdbd332e510b50,
            limb2: 0x6fe176282e9d5fb,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x8909147ac871b1dfb1b93dea,
            limb1: 0x142dbce634570b3004e7fc,
            limb2: 0x6c20d9db5dd84da,
        },
        r0a1: u288 {
            limb0: 0x9860d4eddaa4bc238176c6fc,
            limb1: 0x2b0526a4c3964c89747e80c5,
            limb2: 0x8fd2f58f97118b6,
        },
        r1a0: u288 {
            limb0: 0x350f6ba8623173a2b59246f5,
            limb1: 0xc1b28fd98d68ff68c2905942,
            limb2: 0x8244875fe9df1c7,
        },
        r1a1: u288 {
            limb0: 0x57cc1c6a24b662006d9dbe1b,
            limb1: 0x5ad285ba45ea4be688bff724,
            limb2: 0x2b07fd32ff344b21,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xfeebe92941f95b6ea1d095bb,
            limb1: 0x9c7962eb8bbeb95a9ca7cf50,
            limb2: 0x290bdaf3b9a08dc3,
        },
        r0a1: u288 {
            limb0: 0x686cfa11c9d4b93675495599,
            limb1: 0xb1d69e17b4b5ebf64f0d51e1,
            limb2: 0x2c18bb4bdc2e9567,
        },
        r1a0: u288 {
            limb0: 0x17419b0f6a04bfc98d71527,
            limb1: 0x80eba6ff02787e3de964a4d1,
            limb2: 0x26087bb100e7ff9f,
        },
        r1a1: u288 {
            limb0: 0x17c4ee42c3f612c43a08f689,
            limb1: 0x7276bdda2df6d51a291dba69,
            limb2: 0x40a7220ddb393e1,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x37349ad9dc3023fc75053e02,
            limb1: 0x33a3d352f746ab24b3b58b0a,
            limb2: 0xec4c339b84b811d,
        },
        r0a1: u288 {
            limb0: 0x7dcfa2460a0ad9b521a47470,
            limb1: 0xba3ff4b52958f6b7341790da,
            limb2: 0x24709d3b126eb975,
        },
        r1a0: u288 {
            limb0: 0xe5167ab2a7c59462398695fe,
            limb1: 0x639d95ac9180109e9716c52d,
            limb2: 0x1ad3dd11a73c7763,
        },
        r1a1: u288 {
            limb0: 0xc4074c8a20ffec99be26ea0d,
            limb1: 0x33d88e5ff7a03f8fc7673634,
            limb2: 0x212a99002b140a7c,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x830d777c19040571a1d72fd0,
            limb1: 0x651b2c6b8c292020817a633f,
            limb2: 0x268af1e285bc59ff,
        },
        r0a1: u288 {
            limb0: 0xede78baa381c5bce077f443d,
            limb1: 0x540ff96bae21cd8b9ae5438b,
            limb2: 0x12a1fa7e3b369242,
        },
        r1a0: u288 {
            limb0: 0x797c0608e5a535d8736d4bc5,
            limb1: 0x375faf00f1147656b7c1075f,
            limb2: 0xda60fab2dc5a639,
        },
        r1a1: u288 {
            limb0: 0x610d26085cfbebdb30ce476e,
            limb1: 0x5bc55890ff076827a09e8444,
            limb2: 0x14272ee2d25f20b7,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x430bef5bf19edee76f43f86d,
            limb1: 0xd0d7e3e70da75944107b2d4a,
            limb2: 0x1a773d3afca56895,
        },
        r0a1: u288 {
            limb0: 0xac9908b990c2eba0c566a721,
            limb1: 0xb5b9dd164b61dc1a46f57bc0,
            limb2: 0x153897d14189a3e9,
        },
        r1a0: u288 {
            limb0: 0x873c42f94417c98a18ef8b21,
            limb1: 0x7fd90a68e925814a5c90c64e,
            limb2: 0xb43f89cdc102905,
        },
        r1a1: u288 {
            limb0: 0x6a2633ae3430261a8d930055,
            limb1: 0xccf2888e7fa1b1be32616fcc,
            limb2: 0x281f7352c8bd69b4,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xd6862e1a4ca3b2baf6f8d8aa,
            limb1: 0x96f9066dded3a3d899025af4,
            limb2: 0x1a98af9f0d48fd3,
        },
        r0a1: u288 {
            limb0: 0x276b417cc61ea259c114314e,
            limb1: 0x464399e5e0037b159866b246,
            limb2: 0x12cc97dcf32896b5,
        },
        r1a0: u288 {
            limb0: 0xef72647f4c2d08fc038c4377,
            limb1: 0x34883cea19be9a490a93cf2b,
            limb2: 0x10d01394daa61ed0,
        },
        r1a1: u288 {
            limb0: 0xdf345239ece3acaa62919643,
            limb1: 0x914780908ece64e763cca062,
            limb2: 0xee2a80dbd2012a3,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x1d5a31f4d08a0ebf7e071e00,
            limb1: 0xcd1244dd95dd30005f531f81,
            limb2: 0xb4cb469a2dcf4f1,
        },
        r0a1: u288 {
            limb0: 0x7c5938adaf38b355092de1f1,
            limb1: 0x292ab08995b293abfcba14b,
            limb2: 0x1fd126a2b9f37c67,
        },
        r1a0: u288 {
            limb0: 0x6e9d352b02a7cb771fcc33f9,
            limb1: 0x7754d8536eefda2025a07340,
            limb2: 0x1840289291c35a72,
        },
        r1a1: u288 {
            limb0: 0xe85f465417b7bd758c547b2e,
            limb1: 0xf7f703c3bc55ff8a01fa9365,
            limb2: 0xfa301227880a841,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xb871630bb14808308256993,
            limb1: 0x5aa6407e90ac7cd9d34c84b1,
            limb2: 0x1a45d81956be51f9,
        },
        r0a1: u288 {
            limb0: 0x4e35a5f1c75bc96bbe481d7c,
            limb1: 0xb461fa7d1b269bf49be0ed7f,
            limb2: 0x88efe970e8c4e4a,
        },
        r1a0: u288 {
            limb0: 0xff160df5ead7b7b25d8892e5,
            limb1: 0xbbbd6b9b216396e83fd6aa70,
            limb2: 0x2dcf636e87cde612,
        },
        r1a1: u288 {
            limb0: 0x44d33f7f0dbcaccf59607fcd,
            limb1: 0xae52f65a36ac4f17e0e213de,
            limb2: 0x12e6c11148485b9b,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xa89926f3c9ed74cf35d8982d,
            limb1: 0x8e9003f1a42b81a81fe0df1e,
            limb2: 0x2732162604574861,
        },
        r0a1: u288 {
            limb0: 0x4ac22d9feb0443ee015b81e1,
            limb1: 0xd442070c95acaa6a39e85ae9,
            limb2: 0x1a42773c0ac19a09,
        },
        r1a0: u288 {
            limb0: 0x7d32a4a55a853c2309cd6f0,
            limb1: 0x747d1e031aa2229e38cfca1f,
            limb2: 0x1b6358645f1162ad,
        },
        r1a1: u288 {
            limb0: 0xd511412ffa32391dda88c29b,
            limb1: 0x5f57b2aab83993734eb330b0,
            limb2: 0xc3766c22260b874,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xa4058149e82ea51362b79be4,
            limb1: 0x734eba2621918a820ae44684,
            limb2: 0x110a314a02272b1,
        },
        r0a1: u288 {
            limb0: 0xe2b43963ef5055df3c249613,
            limb1: 0x409c246f762c0126a1b3b7b7,
            limb2: 0x19aa27f34ab03585,
        },
        r1a0: u288 {
            limb0: 0x179aad5f620193f228031d62,
            limb1: 0x6ba32299b05f31b099a3ef0d,
            limb2: 0x157724be2a0a651f,
        },
        r1a1: u288 {
            limb0: 0xa33b28d9a50300e4bbc99137,
            limb1: 0x262a51847049d9b4d8cea297,
            limb2: 0x189acb4571d50692,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xbd50e560f6bb994a2922fa51,
            limb1: 0x99a1d1b01aa18c7f31e917fc,
            limb2: 0xd7ef26150626982,
        },
        r0a1: u288 {
            limb0: 0xf014da7a050c535a40cfc124,
            limb1: 0x3b1a2e82c4f0fc6379900c54,
            limb2: 0x1a5cfd9a14902546,
        },
        r1a0: u288 {
            limb0: 0x9aaa7b13fd8f24f65c93eec5,
            limb1: 0xab93d53f2815295691702b82,
            limb2: 0xde083d90578af6f,
        },
        r1a1: u288 {
            limb0: 0xfbd08ec0a79725a4b6e8b67c,
            limb1: 0x69946154b610ed695859295b,
            limb2: 0x277a133a0d6da917,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x29bd4381ae4afc677ee37ed6,
            limb1: 0x29ed43453f9a008d9176f004,
            limb2: 0x24134eb915104f43,
        },
        r0a1: u288 {
            limb0: 0x81597f82bb67e90a3e72bdd2,
            limb1: 0xab3bbde5f7bbb4df6a6b5c19,
            limb2: 0x19ac61eea40a367c,
        },
        r1a0: u288 {
            limb0: 0xe30a79342fb3199651aee2fa,
            limb1: 0xf500f028a73ab7b7db0104a3,
            limb2: 0x808b50e0ecb5e4d,
        },
        r1a1: u288 {
            limb0: 0x55f2818453c31d942444d9d6,
            limb1: 0xf6dd80c71ab6e893f2cf48db,
            limb2: 0x13c3ac4488abd138,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x32bc8a981429b931b50b70e1,
            limb1: 0x99cffcd897696a0e5c987090,
            limb2: 0x2663f59204065aeb,
        },
        r0a1: u288 {
            limb0: 0x6d0d07933c107a489c682134,
            limb1: 0xb81690a5db81aa6e8c0ef203,
            limb2: 0x27cb7b6ce66b5225,
        },
        r1a0: u288 {
            limb0: 0xf6fc5c5aa501cffb8ee75a4b,
            limb1: 0xf8d08f9383f191384ba8077b,
            limb2: 0x28b89e3f89c071c1,
        },
        r1a1: u288 {
            limb0: 0x1bd9021070481b0a40cb6d36,
            limb1: 0x86562734b4f3fcfb46e39713,
            limb2: 0x1ec7729185561f74,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xd1464269bbeafa546f559b8f,
            limb1: 0xab7f7dcd1ac32b86979471cf,
            limb2: 0x6a38256ee96f113,
        },
        r0a1: u288 {
            limb0: 0xf14d50984e65f9bc41df4e7e,
            limb1: 0x350aff9be6f9652ad441a3ad,
            limb2: 0x1b1e60534b0a6aba,
        },
        r1a0: u288 {
            limb0: 0x9e98507da6cc50a56f023849,
            limb1: 0xcf8925e03f2bb5c1ba0962dd,
            limb2: 0x2b18961810a62f87,
        },
        r1a1: u288 {
            limb0: 0x3a4c61b937d4573e3f2da299,
            limb1: 0x6f4c6c13fd90f4edc322796f,
            limb2: 0x13f4e99b6a2f025e,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xd7f1137b131005c05a263909,
            limb1: 0x377579bc2a44238703830641,
            limb2: 0x1edb40cec982e433,
        },
        r0a1: u288 {
            limb0: 0xb234350aafc13259037ff7b8,
            limb1: 0x8ce5fcfc41890347214723f3,
            limb2: 0x1d5cfe6e2536a23b,
        },
        r1a0: u288 {
            limb0: 0x8d74f12ae2cdd199736e4db9,
            limb1: 0xf5835da25b7c74dea8742767,
            limb2: 0xa4f9baaf2b585aa,
        },
        r1a1: u288 {
            limb0: 0x6c077e93c1a1bae84d31f2de,
            limb1: 0xeb24bf9c8e1a11a15952b35f,
            limb2: 0x182a33beae2d73ac,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xe0115a79120ae892a72f3dcb,
            limb1: 0xec67b5fc9ea414a4020135f,
            limb2: 0x1ee364e12321904a,
        },
        r0a1: u288 {
            limb0: 0xa74d09666f9429c1f2041cd9,
            limb1: 0x57ffe0951f863dd0c1c2e97a,
            limb2: 0x154877b2d1908995,
        },
        r1a0: u288 {
            limb0: 0xcbe5e4d2d2c91cdd4ccca0,
            limb1: 0xe6acea145563a04b2821d120,
            limb2: 0x18213221f2937afb,
        },
        r1a1: u288 {
            limb0: 0xfe20afa6f6ddeb2cb768a5ae,
            limb1: 0x1a3b509131945337c3568fcf,
            limb2: 0x127b5788263a927e,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x23a3796fea17793ca760d4b4,
            limb1: 0xb4abf7ebb030cb2f1630ed5f,
            limb2: 0x64ab24ff28d4416,
        },
        r0a1: u288 {
            limb0: 0x538a1fa509f26d8c8bdeb966,
            limb1: 0x73f3e2cd56d3c514e4a37c42,
            limb2: 0x60a236e3776ce68,
        },
        r1a0: u288 {
            limb0: 0xd80f5ba56c16fe54bda3fa80,
            limb1: 0xe5f8701be9499623ce8a673d,
            limb2: 0x18c79fac25052970,
        },
        r1a1: u288 {
            limb0: 0x8929aad47a81f1378a817ef5,
            limb1: 0xfadba04c7242b43b5cf39d33,
            limb2: 0xb3e5f5c3c9fb3b2,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xe7c658aecdab4db3c83f7927,
            limb1: 0xfbf162264ca04ee50c70bde8,
            limb2: 0x2a20f4565b7ff885,
        },
        r0a1: u288 {
            limb0: 0x45b1c2f0a1226361f42683c0,
            limb1: 0x9acdd892c48c08de047296bc,
            limb2: 0x27836373108925d4,
        },
        r1a0: u288 {
            limb0: 0xc0ea9294b345e6d4892676a7,
            limb1: 0xcba74eca77086af245d1606e,
            limb2: 0xf20edac89053e72,
        },
        r1a1: u288 {
            limb0: 0x4c92a28f2779a527a68a938c,
            limb1: 0x3a1c3c55ff9d20eac109fab3,
            limb2: 0x21c4a8c524b1ee7d,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x731f3a1b36de3023901591ff,
            limb1: 0xe34bb92f321ca5d3092bcbad,
            limb2: 0x2216559b45dd1c2f,
        },
        r0a1: u288 {
            limb0: 0x3bac805b2d142e0cc0edeb11,
            limb1: 0x5d11df064af70b6d83d6ce74,
            limb2: 0x14c2db65d318303,
        },
        r1a0: u288 {
            limb0: 0xc3ee59929ecba416af62e06e,
            limb1: 0xcbdffb49b2c9219cfda57258,
            limb2: 0x9e92730073f74d7,
        },
        r1a1: u288 {
            limb0: 0x137f2ce23b788e764203080c,
            limb1: 0x1340ccaf8101da98864c6b0c,
            limb2: 0x103ddd7382137938,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xa68021d593c46246af22559e,
            limb1: 0x5c2cfc5bc4cd1b48f4704134,
            limb2: 0x296066ede1298f8c,
        },
        r0a1: u288 {
            limb0: 0xfe17dd6765eb9b9625eb6a84,
            limb1: 0x4e35dd8e8f6088bb14299f8d,
            limb2: 0x1a380ab2689106e4,
        },
        r1a0: u288 {
            limb0: 0x82bacf337ca09853df42bc59,
            limb1: 0xa15de4ef34a30014c5a2e9ae,
            limb2: 0x243cc0cec53c778b,
        },
        r1a1: u288 {
            limb0: 0xcb2a1bf18e3ba9349b0a8bf2,
            limb1: 0x35134b2505cbb5a4c91f0ac4,
            limb2: 0x25e45206b13f43c4,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x8e97b007ffd9891bd0e77650,
            limb1: 0x77671278ac33f17df6b1db88,
            limb2: 0x243daddc47f5d5c2,
        },
        r0a1: u288 {
            limb0: 0x655fe4c8bbe5ee06aaa0054b,
            limb1: 0xf751450b02c93c7ddea95938,
            limb2: 0x21aa988e950d563f,
        },
        r1a0: u288 {
            limb0: 0xb51b3b6b8582de3eb0549518,
            limb1: 0x84a1031766b7e465f5bbf40c,
            limb2: 0xd46c2d5b95e5532,
        },
        r1a1: u288 {
            limb0: 0x50b6ddd8a5eef0067652191e,
            limb1: 0x298832a0bc46ebed8bff6190,
            limb2: 0xb568b4fe8311f93,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x6ad6cf94fc3bf4bfbd69ba1d,
            limb1: 0x806961a05ecbb229a267a99d,
            limb2: 0x1671d0fb2e942009,
        },
        r0a1: u288 {
            limb0: 0x2e9b86ac823b3213d26fe614,
            limb1: 0x48a66f0ee2f66e6be68a4eab,
            limb2: 0x9162eb41435b523,
        },
        r1a0: u288 {
            limb0: 0xeda3ea2df37c2c19a07e26a6,
            limb1: 0x96cb3f72bef333861a5f6793,
            limb2: 0x6e84ee455d519bf,
        },
        r1a1: u288 {
            limb0: 0x52f50c292b08883fa721dada,
            limb1: 0x2029cc6ef51b67f2f30e583a,
            limb2: 0xb289cfc0164b2ed,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x6c70c1e14706dbfd33efe75c,
            limb1: 0xbd47837fd6f0a808a8cac5c3,
            limb2: 0x1b60ad36bb1e656e,
        },
        r0a1: u288 {
            limb0: 0x833e70940a681aa43a083ad0,
            limb1: 0x3ffecc6d09b7a0ea1df06988,
            limb2: 0x216e7660abbec411,
        },
        r1a0: u288 {
            limb0: 0xdaddeff80a0eccefcd3726b4,
            limb1: 0xd7b4c983581d4e9b3f210f17,
            limb2: 0x26bf9b818756e2b,
        },
        r1a1: u288 {
            limb0: 0xb32fd7bd9890bbed35311a72,
            limb1: 0xa30e2587947d85bbece4c62f,
            limb2: 0x197a3b46e94f9f24,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xddb4db99db681d35f71a159c,
            limb1: 0xf71a330019414e6fdee75700,
            limb2: 0x14d9838e7d1918bb,
        },
        r0a1: u288 {
            limb0: 0x203c8bac71951a5f2c653710,
            limb1: 0x9fc93f8da38ecc2957313982,
            limb2: 0x7b6d981259cabd9,
        },
        r1a0: u288 {
            limb0: 0xa7297cdb5be0cc45d48ca6af,
            limb1: 0xa07b4b025ebe6c960eddfc56,
            limb2: 0xef2a5c30ef00652,
        },
        r1a1: u288 {
            limb0: 0xb7f05c76d860e9122b36ecd7,
            limb1: 0x407d6522e1f9ce2bcbf80eda,
            limb2: 0x197625a558f32c36,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xe6af6774cb7a4b647bc24bc6,
            limb1: 0x76bea1b00f9735d1977d2636,
            limb2: 0xc89d9397e87260c,
        },
        r0a1: u288 {
            limb0: 0x96bf96a3ec6330e2471bedb,
            limb1: 0xaefe1b80eabbd9aea0986912,
            limb2: 0x2060760fa91e6007,
        },
        r1a0: u288 {
            limb0: 0x7bcc695f496777a5639d8e67,
            limb1: 0x521bb49545544f2017835a37,
            limb2: 0x23bd13f6824a9c20,
        },
        r1a1: u288 {
            limb0: 0x2a7663f245635451e8e9395b,
            limb1: 0x2a618c0e730e827ea1b6c5b8,
            limb2: 0x4b769d1e5ea2d59,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xb0f04df9dec94801e48a6ff7,
            limb1: 0xdc59d087c627d38334e5b969,
            limb2: 0x3d36e11420be053,
        },
        r0a1: u288 {
            limb0: 0xc80f070001aa1586189e0215,
            limb1: 0xff849fcbbbe7c00c83ab5282,
            limb2: 0x2a2354b2882706a6,
        },
        r1a0: u288 {
            limb0: 0x48cf70c80f08b6c7dc78adb2,
            limb1: 0xc6632efa77b36a4a1551d003,
            limb2: 0xc2d3533ece75879,
        },
        r1a1: u288 {
            limb0: 0x63e82ba26617416a0b76ddaa,
            limb1: 0xdaceb24adda5a049bed29a50,
            limb2: 0x1a82061a3344043b,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x5870b524b1a3550dd400ccc5,
            limb1: 0x852bc0b37d0f914b8073f12f,
            limb2: 0x16509ed87eff5a4e,
        },
        r0a1: u288 {
            limb0: 0x88260fe925feb155aed3786a,
            limb1: 0x67d1bdd00f0234c2f4bfc1dc,
            limb2: 0x2d447aa64752d13,
        },
        r1a0: u288 {
            limb0: 0x61cd38a81ad2ff47aed15d31,
            limb1: 0xbca0f1fb3a56f9f221477273,
            limb2: 0x24049dab533565eb,
        },
        r1a1: u288 {
            limb0: 0x6c2add460f1dc00897d5b5da,
            limb1: 0x35bb326b6d5280eee3f8c765,
            limb2: 0x13a4b8025098500,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x9152fecf0f523415acc7c7be,
            limb1: 0xd9632cbfccc4ea5d7bf31177,
            limb2: 0x2d7288c5f8c83ab1,
        },
        r0a1: u288 {
            limb0: 0x53144bfe4030f3f9f5efda8,
            limb1: 0xfeec394fbf392b11c66bae27,
            limb2: 0x28840813ab8a200b,
        },
        r1a0: u288 {
            limb0: 0xdec3b11fbc28b305d9996ec7,
            limb1: 0x5b5f8d9d17199e149c9def6e,
            limb2: 0x10c1a149b6751bae,
        },
        r1a1: u288 {
            limb0: 0x665e8eb7e7d376a2d921c889,
            limb1: 0xfdd76d06e46ee1a943b8788d,
            limb2: 0x8bb21d9960e837b,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x3a67c28a175200e631aa506a,
            limb1: 0x7397303a34968ff17c06e801,
            limb2: 0x1b81e0c63123688b,
        },
        r0a1: u288 {
            limb0: 0x3490cfd4f076c621dac4a12c,
            limb1: 0xec183578c91b90b72e5887b7,
            limb2: 0x179fb354f608da00,
        },
        r1a0: u288 {
            limb0: 0x9322bde2044dde580a78ba33,
            limb1: 0xfc74821b668d3570cad38f8b,
            limb2: 0x8cec54a291f5e57,
        },
        r1a1: u288 {
            limb0: 0xc2818b6a9530ee85d4b2ae49,
            limb1: 0x8d7b651ad167f2a43d7a2d0a,
            limb2: 0x7c9ca9bab0ffc7f,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x5622114faf115105095ab77f,
            limb1: 0x54762377d7848bf1c52b1fce,
            limb2: 0x1f97b82262bcf5d6,
        },
        r0a1: u288 {
            limb0: 0x6085f868127e9f82a6324ea7,
            limb1: 0x88a39c58534935bde6a49ab,
            limb2: 0x7f8a3494505b851,
        },
        r1a0: u288 {
            limb0: 0xd3eabc17c5e2f4e09171b9dd,
            limb1: 0x1925fbd52a9cb6a997959648,
            limb2: 0x21518ac51afc3758,
        },
        r1a1: u288 {
            limb0: 0x6096ef3f52e60023239e48e4,
            limb1: 0x865e3876b961acac0b78e525,
            limb2: 0x860d5900ad68c37,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x2ad5fd7aad65b27d37fb015a,
            limb1: 0x481729d76f6a024e82fb745d,
            limb2: 0x109a944738eaca6a,
        },
        r0a1: u288 {
            limb0: 0x3297a180bf2677cff3ccb41f,
            limb1: 0xa65e1bdf4bb474832f0a5157,
            limb2: 0x1978ab7a84d8651b,
        },
        r1a0: u288 {
            limb0: 0x708be8948dd3360c8723e464,
            limb1: 0xbaed9d16b05c7d52f3e91f9f,
            limb2: 0x1975a6b856112bc2,
        },
        r1a1: u288 {
            limb0: 0xdff0a3ede7d8433f08340a93,
            limb1: 0xd6415eabeb4ddb811aa617b2,
            limb2: 0xdb9f4e71e973c6,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xa576408f8300de3a7714e6ae,
            limb1: 0xe1072c9a16f202ecf37fbc34,
            limb2: 0x1b0cb1e2b5871263,
        },
        r0a1: u288 {
            limb0: 0x2128e2314694b663286e231e,
            limb1: 0x54bea71957426f002508f715,
            limb2: 0x36ecc5dbe069dca,
        },
        r1a0: u288 {
            limb0: 0x17c77cd88f9d5870957850ce,
            limb1: 0xb7f4ec2bc270ce30538fe9b8,
            limb2: 0x766279e588592bf,
        },
        r1a1: u288 {
            limb0: 0x1b6caddf18de2f30fa650122,
            limb1: 0x40b77237a29cada253c126c6,
            limb2: 0x74ff1349b1866c8,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x1266deaa34cf31d6d118b057,
            limb1: 0x7eef7892b3efd91c5364259c,
            limb2: 0x1f4ac5e1bdc33dac,
        },
        r0a1: u288 {
            limb0: 0x1068831212b6fe1b5aa05f22,
            limb1: 0xc39adbfe99701ca7671003e3,
            limb2: 0x1ab8e56b642f5f82,
        },
        r1a0: u288 {
            limb0: 0xd53d59610ebf7f664c23c080,
            limb1: 0x3d162ffb5a16aafc8be99bd3,
            limb2: 0x281e77e14f6bb9c0,
        },
        r1a1: u288 {
            limb0: 0x4fe123e56c3c2c64a4260c7b,
            limb1: 0x90c367228a761d9c50be237c,
            limb2: 0xf07b0465615fe71,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x3603266e05560becab36faef,
            limb1: 0x8c3b88c9390278873dd4b048,
            limb2: 0x24a715a5d9880f38,
        },
        r0a1: u288 {
            limb0: 0xe9f595b111cfd00d1dd28891,
            limb1: 0x75c6a392ab4a627f642303e1,
            limb2: 0x17b34a30def82ab6,
        },
        r1a0: u288 {
            limb0: 0xe706de8f35ac8372669fc8d3,
            limb1: 0x16cc7f4032b3f3ebcecd997d,
            limb2: 0x166eba592eb1fc78,
        },
        r1a1: u288 {
            limb0: 0x7d584f102b8e64dcbbd1be9,
            limb1: 0x2ead4092f009a9c0577f7d3,
            limb2: 0x2fe2c31ee6b1d41e,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x72253d939632f8c28fb5763,
            limb1: 0x9b943ab13cad451aed1b08a2,
            limb2: 0xdb9b2068e450f10,
        },
        r0a1: u288 {
            limb0: 0x80f025dcbce32f6449fa7719,
            limb1: 0x8a0791d4d1ed60b86e4fe813,
            limb2: 0x1b1bd5dbce0ea966,
        },
        r1a0: u288 {
            limb0: 0xaa72a31de7d815ae717165d4,
            limb1: 0x501c29c7b6aebc4a1b44407f,
            limb2: 0x464aa89f8631b3a,
        },
        r1a1: u288 {
            limb0: 0x6b8d137e1ea43cd4b1f616b1,
            limb1: 0xdd526a510cc84f150cc4d55a,
            limb2: 0x1da2ed980ebd3f29,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x72dfbb2159ade3ca2db9a485,
            limb1: 0xaf353e749a0b0e126b462bd4,
            limb2: 0x11a356fc91502fd1,
        },
        r0a1: u288 {
            limb0: 0xa8da111fc2adcd5b3152926b,
            limb1: 0x9d2cd58a348021fb039ad1ce,
            limb2: 0x24a89d0c2aa1a4c,
        },
        r1a0: u288 {
            limb0: 0xb7eadf0666fe1d5d8e00ddd3,
            limb1: 0x9fa7fbf853bdf5b9620cae4c,
            limb2: 0x2b6df7a5b1f6cfa3,
        },
        r1a1: u288 {
            limb0: 0x30a81454c2cc541ca6ac5028,
            limb1: 0xd14ccb5778ca0679f43b0042,
            limb2: 0x2b15bb249061229,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xff2a45b22df6665c3f2b3433,
            limb1: 0x47f06d2821bccb7d4e1442dc,
            limb2: 0x1d6d005a3a962538,
        },
        r0a1: u288 {
            limb0: 0xbc3869f85e6c5199ae4d48ae,
            limb1: 0xf1b658ebf5d88598be4f771c,
            limb2: 0x10ce0fad17dffce6,
        },
        r1a0: u288 {
            limb0: 0x9057fbbd4dbd1f42e143f536,
            limb1: 0xb84a12963d2bdeff0cfb15cc,
            limb2: 0xf055cbcbcad6397,
        },
        r1a1: u288 {
            limb0: 0x2b6c8f90506d8c5f45a796c2,
            limb1: 0x15647362232ed3834e25f304,
            limb2: 0x10c73cc1383f51b5,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x867cced8a010850958f41ff5,
            limb1: 0x6a37fdb2b8993eed18bafe8e,
            limb2: 0x21b9f782109e5a7,
        },
        r0a1: u288 {
            limb0: 0x7307477d650618e66de38d0f,
            limb1: 0xacb622ce92a7e393dbe10ba1,
            limb2: 0x236e70838cee0ed5,
        },
        r1a0: u288 {
            limb0: 0xb564a308aaf5dda0f4af0f0d,
            limb1: 0x55fc71e2f13d8cb12bd51e74,
            limb2: 0x294cf115a234a9e9,
        },
        r1a1: u288 {
            limb0: 0xbd166057df55c135b87f35f3,
            limb1: 0xf9f29b6c50f1cce9b85ec9b,
            limb2: 0x2e8448d167f20f96,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xfcb1d8cfddd4980727750419,
            limb1: 0xe57b3100fcf5fcd46e1cff24,
            limb2: 0x1ea2a9f23e471d2f,
        },
        r0a1: u288 {
            limb0: 0x8278659319480914a8f915c3,
            limb1: 0xb9d01b3a1f3df0c8481b47c7,
            limb2: 0x1dce2891e1df8e91,
        },
        r1a0: u288 {
            limb0: 0x373890191ad2139b5ac37f5e,
            limb1: 0x7d00bf061594cf869f26bd35,
            limb2: 0x263941972f0c5bcc,
        },
        r1a1: u288 {
            limb0: 0x35d21a939f18acadda6398c4,
            limb1: 0x2f266751d30024c345fd2f64,
            limb2: 0x12415712f84fa7c6,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xdedaff3205bb953b2c390b8a,
            limb1: 0xe1a899da21c1dafb485c707e,
            limb2: 0x1ec897e7a041493e,
        },
        r0a1: u288 {
            limb0: 0xf52c3c30cd4d3202b34089e0,
            limb1: 0xc652aa1ff533e1aad7532305,
            limb2: 0x2a1df766e5e3aa2e,
        },
        r1a0: u288 {
            limb0: 0x7ac695d3e19d79b234daaf3d,
            limb1: 0x5ce2f92666aec92a650feee1,
            limb2: 0x21ab4fe20d978e77,
        },
        r1a1: u288 {
            limb0: 0xa64a913a29a1aed4e0798664,
            limb1: 0x66bc208b511503d127ff5ede,
            limb2: 0x2389ba056de56a8d,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x65ab6317a706e3cda223edf8,
            limb1: 0x9a22ac3ac5e4dd3e9f987fd9,
            limb2: 0x157637901a8b31a5,
        },
        r0a1: u288 {
            limb0: 0xc57d325b1af3a13019c15e11,
            limb1: 0x2812651fd79b5fbbb05cc3d7,
            limb2: 0x1f1602a02e76536f,
        },
        r1a0: u288 {
            limb0: 0xdf3ad97a0633d33f5a8cea32,
            limb1: 0xd15238b33edfeb16cffd44ea,
            limb2: 0x5a03a044b07b640,
        },
        r1a1: u288 {
            limb0: 0x58fec495c4c681cf797762a1,
            limb1: 0xd3ac0af0d5cb5bff7f4fa8e8,
            limb2: 0x286d6218242eddb4,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xd88b16e68600a12e6c1f6006,
            limb1: 0x333243b43d3b7ff18d0cc671,
            limb2: 0x2b84b2a9b0f03ed8,
        },
        r0a1: u288 {
            limb0: 0xf3e2b57ddaac822c4da09991,
            limb1: 0xd7c894b3fe515296bb054d2f,
            limb2: 0x10a75e4c6dddb441,
        },
        r1a0: u288 {
            limb0: 0x73c65fbbb06a7b21b865ac56,
            limb1: 0x21f4ecd1403bb78729c7e99b,
            limb2: 0xaf88a160a6b35d4,
        },
        r1a1: u288 {
            limb0: 0xade61ce10b8492d659ff68d0,
            limb1: 0x1476e76cf3a8e0df086ad9eb,
            limb2: 0x2e28cfc65d61e946,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xdf8b54b244108008e7f93350,
            limb1: 0x2ae9a68b9d6b96f392decd6b,
            limb2: 0x160b19eed152271c,
        },
        r0a1: u288 {
            limb0: 0xc18a8994cfbb2e8df446e449,
            limb1: 0x408d51e7e4adedd8f4f94d06,
            limb2: 0x27661b404fe90162,
        },
        r1a0: u288 {
            limb0: 0x1390b2a3b27f43f7ac73832c,
            limb1: 0x14d57301f6002fd328f2d64d,
            limb2: 0x17f3fa337367dddc,
        },
        r1a1: u288 {
            limb0: 0x79cab8ff5bf2f762c5372f80,
            limb1: 0xc979d6f385fae4b5e4785acf,
            limb2: 0x60c5307a735b00f,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x42e951ca7dac29d65a14ab82,
            limb1: 0x140be62e3d419b811acf5756,
            limb2: 0x11523c7fc2a37270,
        },
        r0a1: u288 {
            limb0: 0x593b29e6aad3cadd506d93bd,
            limb1: 0x59976c08d37982b9c28495c3,
            limb2: 0xc924925bb5976fe,
        },
        r1a0: u288 {
            limb0: 0xcb18016afc265e1a5fc80af0,
            limb1: 0xd830297a058f529ef5e3f97e,
            limb2: 0x253a39d5462f1882,
        },
        r1a1: u288 {
            limb0: 0x2b081ad5589d7f1cedb120a9,
            limb1: 0x956ae1847a5ce3f261e1e1e7,
            limb2: 0x1afd47a0e8c0dbeb,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xb70b988a54003f89b0376a63,
            limb1: 0xff28c025f2f710e53ac37b9e,
            limb2: 0x2e441c518d3fe68d,
        },
        r0a1: u288 {
            limb0: 0x660ddad555982e7994df37fb,
            limb1: 0x6c04f02c84dc80d8305f0357,
            limb2: 0x23b41d5762cf7f0f,
        },
        r1a0: u288 {
            limb0: 0xa2f0ccb1a552683ea3ac0798,
            limb1: 0xb33b544006bac5a1fd372830,
            limb2: 0x24afb0cbc42170a7,
        },
        r1a1: u288 {
            limb0: 0xf93faa0be992488deb617b04,
            limb1: 0x86fb2bb1f07dfeef85b2886,
            limb2: 0x189649259453ed83,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x386d7b23c6dccb87637018c9,
            limb1: 0xfed2ea478e9a2210289079e2,
            limb2: 0x100aa83cb843353e,
        },
        r0a1: u288 {
            limb0: 0x229c5c285f049d04c3dc5ce7,
            limb1: 0x28110670fe1d38c53ffcc6f7,
            limb2: 0x1778918279578f50,
        },
        r1a0: u288 {
            limb0: 0xe9ad2c7b8a17a1f1627ff09d,
            limb1: 0xedff5563c3c3e7d2dcc402ec,
            limb2: 0xa8bd6770b6d5aa8,
        },
        r1a1: u288 {
            limb0: 0x66c5c1aeed5c04470b4e8a3d,
            limb1: 0x846e73d11f2d18fe7e1e1aa2,
            limb2: 0x10a60eabe0ec3d78,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x9dafcca7f80fb028e1550b13,
            limb1: 0x510e07802d526954395ad6d6,
            limb2: 0x34f031507e71a70,
        },
        r0a1: u288 {
            limb0: 0xac7b6a137d96e956dd4f2773,
            limb1: 0x2692998b32154b368c857fee,
            limb2: 0x2ea30d00a23e6587,
        },
        r1a0: u288 {
            limb0: 0x69f3776dd7fd4db9bde03967,
            limb1: 0x16efb004aa3f44e6ac5fdd29,
            limb2: 0x361dd68590907c0,
        },
        r1a1: u288 {
            limb0: 0x445681532c126e7c428445b7,
            limb1: 0xfa2b7d974e59a61f57bcd949,
            limb2: 0x258ce35529e9f923,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x88ca191d85be1f6c205257ef,
            limb1: 0xd0cecf5c5f80926c77fd4870,
            limb2: 0x16ec42b5cae83200,
        },
        r0a1: u288 {
            limb0: 0x154cba82460752b94916186d,
            limb1: 0x564f6bebac05a4f3fb1353ac,
            limb2: 0x2d47a47da836d1a7,
        },
        r1a0: u288 {
            limb0: 0xb39c4d6150bd64b4674f42ba,
            limb1: 0x93c967a38fe86f0779bf4163,
            limb2: 0x1a51995a49d50f26,
        },
        r1a1: u288 {
            limb0: 0xeb7bdec4b7e304bbb0450608,
            limb1: 0x11fc9a124b8c74b3d5560ea4,
            limb2: 0xbfa9bd7f55ad8ac,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x2cb6407193c4b5c315a00755,
            limb1: 0x33dcf6b5051abc2c59b801ab,
            limb2: 0x16f1a436a0abadf6,
        },
        r0a1: u288 {
            limb0: 0x3398c4073878ea089b0c7b80,
            limb1: 0x49d08a1ce731c9b194b93e64,
            limb2: 0x2c1a19007bb6f21c,
        },
        r1a0: u288 {
            limb0: 0x6b305edfc565d8cb06fa559e,
            limb1: 0x43ee87287e1f2f15d6631f33,
            limb2: 0x1cd36451c5666f9c,
        },
        r1a1: u288 {
            limb0: 0x650c38aae0bd3882a6556860,
            limb1: 0x8e04c37290ae5a6bb3eb1f91,
            limb2: 0x12e57f5774525f20,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x2fdc574c85cf0c0ce5e07a51,
            limb1: 0xd2439bf7b00bddc4cfb01b0c,
            limb2: 0x125c3bbdeb0bd2da,
        },
        r0a1: u288 {
            limb0: 0x9d664714bae53cafcb5ef55d,
            limb1: 0x495c01724790853548f5e4de,
            limb2: 0x2ce5e2e263725941,
        },
        r1a0: u288 {
            limb0: 0x98071eb7fe88c9124aee3774,
            limb1: 0xc3f66947a52bd2f6d520579f,
            limb2: 0x2eaf775dbd52f7d3,
        },
        r1a1: u288 {
            limb0: 0x23e5594948e21db2061dca92,
            limb1: 0xd0ffa6f6c77290531c185431,
            limb2: 0x604c085de03afb1,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xf884b2ccf06f8da655d3142,
            limb1: 0xdece09e25a509a7dd0b73bde,
            limb2: 0xa6830f44f8a0e0d,
        },
        r0a1: u288 {
            limb0: 0x36cc33f5e41d078c07a952fe,
            limb1: 0xa3c7be8095228c58e49910b2,
            limb2: 0x2d863134dbfbae7f,
        },
        r1a0: u288 {
            limb0: 0x83786a541018cb79e6baccf6,
            limb1: 0x9c73f5fa4f111743dfb0b581,
            limb2: 0x22faefa4bfa9f387,
        },
        r1a1: u288 {
            limb0: 0x2f25834de3d2ec7bda75abc7,
            limb1: 0x4526dbfbc8f7d9e1c71c8375,
            limb2: 0x1f3bb15443413d60,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xeec2912e15f6bda39d4e005e,
            limb1: 0x2b8610c44d27bdbc6ba2aac5,
            limb2: 0x78ddc4573fc1fed,
        },
        r0a1: u288 {
            limb0: 0x48099a0da11ea21de015229d,
            limb1: 0x5fe937100967d5cc544f4af1,
            limb2: 0x2c9ffe6d7d7e9631,
        },
        r1a0: u288 {
            limb0: 0xa70d251296ef1ae37ceb7d03,
            limb1: 0x2adadcb7d219bb1580e6e9c,
            limb2: 0x180481a57f22fd03,
        },
        r1a1: u288 {
            limb0: 0xacf46db9631037dd933eb72a,
            limb1: 0x8a58491815c7656292a77d29,
            limb2: 0x261e3516c348ae12,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x62b45634f0eaf51f5bc4003c,
            limb1: 0x13ff6a6fc286b5b754548ac3,
            limb2: 0x1670dac54842d28b,
        },
        r0a1: u288 {
            limb0: 0x85fe43906582fc736d926df3,
            limb1: 0xf077151ea6da959af3c290f6,
            limb2: 0xc8cebcafaa4ae47,
        },
        r1a0: u288 {
            limb0: 0x7540aff585c27cb2fa15c662,
            limb1: 0x5cf456bcd4fa0e3bbae0f467,
            limb2: 0x24a1c8ecb9c907e9,
        },
        r1a1: u288 {
            limb0: 0x19ba1bf552affd897d561632,
            limb1: 0x1df4a4d8d77248957809f88e,
            limb2: 0x1d7484a0c0251cdc,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x2bfa32f0a09c3e2cfb8f6a38,
            limb1: 0x7a24df3ff3c7119a59d49318,
            limb2: 0x10e42281d64907ba,
        },
        r0a1: u288 {
            limb0: 0xce42177a66cdeb4207d11e0c,
            limb1: 0x3322aa425a9ca270152372ad,
            limb2: 0x2f7fa83db407600c,
        },
        r1a0: u288 {
            limb0: 0x62a8ff94fd1c7b9035af4446,
            limb1: 0x3ad500601bbb6e7ed1301377,
            limb2: 0x254d253ca06928f,
        },
        r1a1: u288 {
            limb0: 0xf8f1787cd8e730c904b4386d,
            limb1: 0x7fd3744349918d62c42d24cc,
            limb2: 0x28a05e105d652eb8,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x6ef31e059d602897fa8e80a8,
            limb1: 0x66a0710847b6609ceda5140,
            limb2: 0x228c0e568f1eb9c0,
        },
        r0a1: u288 {
            limb0: 0x7b47b1b133c1297b45cdd79b,
            limb1: 0x6b4f04ed71b58dafd06b527b,
            limb2: 0x13ae6db5254df01a,
        },
        r1a0: u288 {
            limb0: 0xbeca2fccf7d0754dcf23ddda,
            limb1: 0xe3d0bcd7d9496d1e5afb0a59,
            limb2: 0x305a0afb142cf442,
        },
        r1a1: u288 {
            limb0: 0x2d299847431477c899560ecf,
            limb1: 0xbcd9e6c30bedee116b043d8d,
            limb2: 0x79473a2a7438353,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xae3712a6ef6034d7fcbc318c,
            limb1: 0xedba25c96439aeb3954ccff7,
            limb2: 0x1a0d73e3d8d90330,
        },
        r0a1: u288 {
            limb0: 0xff6fb0e919bd80f29065244,
            limb1: 0xfdcac02f3dd2e9268271021f,
            limb2: 0x202e92badc53f790,
        },
        r1a0: u288 {
            limb0: 0xec674cc5d55fcd80ab9fc167,
            limb1: 0xb9f7f1fd7f1e4936802c19d1,
            limb2: 0x27ac3aca37743af5,
        },
        r1a1: u288 {
            limb0: 0xe49dfebb538630697c09c39d,
            limb1: 0x56732676796d1f91ecab12ad,
            limb2: 0xb010d1b0f285dbd,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xb431b974a13b9d75e11033b8,
            limb1: 0xa4b7192e2b5f3730bd216f73,
            limb2: 0x53cf4b349760f42,
        },
        r0a1: u288 {
            limb0: 0x3c87efcabaa8e22835e19e2,
            limb1: 0xfc9cf42672502f3fb7917c8f,
            limb2: 0x11123549a68499c8,
        },
        r1a0: u288 {
            limb0: 0xf91da96d0c078dea22787ecb,
            limb1: 0xd165ceed6f64338e6288e1d3,
            limb2: 0x23490db5de27b468,
        },
        r1a1: u288 {
            limb0: 0x419e0eafdcf6226512a9ec6a,
            limb1: 0x1c6fb8110315ae80c4bf92ec,
            limb2: 0x2ad5f86e5d3bc1c3,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x65b71fe695e7ccd4b460dace,
            limb1: 0xa6ceba62ef334e6fe91301d5,
            limb2: 0x299f578d0f3554e6,
        },
        r0a1: u288 {
            limb0: 0xaf781dd030a274e7ecf0cfa4,
            limb1: 0x2095020d373a14d7967797aa,
            limb2: 0x6a7f9df6f185bf8,
        },
        r1a0: u288 {
            limb0: 0x8e91e2dba67d130a0b274df3,
            limb1: 0xe192a19fce285c12c6770089,
            limb2: 0x6e9acf4205c2e22,
        },
        r1a1: u288 {
            limb0: 0xbcd5c206b5f9c77d667189bf,
            limb1: 0x656a7e2ebc78255d5242ca9,
            limb2: 0x25f43fec41d2b245,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xd6c95bb06c0e9a55a56a85c0,
            limb1: 0xf5d3c4d860aee402df7d0cd6,
            limb2: 0xa90fbb3a7bcfb07,
        },
        r0a1: u288 {
            limb0: 0xbfca0761240adb98fdf8e23d,
            limb1: 0xe6052ca38781d13cf53921cb,
            limb2: 0x780debeee0578b2,
        },
        r1a0: u288 {
            limb0: 0xbe285fa3e37b0222a1c65921,
            limb1: 0xb9fbb60c587b00d8ecf22359,
            limb2: 0x284f4ced8b0b28f5,
        },
        r1a1: u288 {
            limb0: 0x34e69be4d8eea470c08f07e8,
            limb1: 0x651617bebb0020b71bf6a8a7,
            limb2: 0xde62a1da13dfd78,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x4e56e6733cce20d9c5b16d96,
            limb1: 0xc7ef260535fb75b9d3e089f,
            limb2: 0x292dd4aa636e7729,
        },
        r0a1: u288 {
            limb0: 0x6e7e1038b336f36519c9faaf,
            limb1: 0x3c66bd609510309485e225c7,
            limb2: 0x10cacac137411eb,
        },
        r1a0: u288 {
            limb0: 0x4a3e8b96278ac092fe4f3b15,
            limb1: 0xba47e583e2750b42f93c9631,
            limb2: 0x125da6bd69495bb9,
        },
        r1a1: u288 {
            limb0: 0xae7a56ab4b959a5f6060d529,
            limb1: 0xc3c263bfd58c0030c063a48e,
            limb2: 0x2f4d15f13fae788c,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x301e0885c84d273b6d323124,
            limb1: 0x11fd5c75e269f7a30fa4154f,
            limb2: 0x19afdcfdcce2fc0d,
        },
        r0a1: u288 {
            limb0: 0x3d13519f934526be815c38b0,
            limb1: 0xd43735909547da73838874fc,
            limb2: 0x255d8aca30f4e0f6,
        },
        r1a0: u288 {
            limb0: 0x90a505b76f25a3396e2cea79,
            limb1: 0x3957a2d0848c54b9079fc114,
            limb2: 0x1ba0cd3a9fe6d4bb,
        },
        r1a1: u288 {
            limb0: 0xc47930fba77a46ebb1db30a9,
            limb1: 0x993a1cb166e9d40bebab02b2,
            limb2: 0x1deb16166d48118b,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xb8cf2af23a2795446a3a73f1,
            limb1: 0x13715e2237eeb02ee6666cee,
            limb2: 0xa85c6edf4e39ba5,
        },
        r0a1: u288 {
            limb0: 0x1f36efdd6931269960bdf4de,
            limb1: 0xfe9eff4c19216c4ae441fee1,
            limb2: 0x25db1c938c941000,
        },
        r1a0: u288 {
            limb0: 0xe13bf721634b56a80c6fb0a8,
            limb1: 0xda0b9ea6704efbd8451cfd41,
            limb2: 0x279768e0c2762893,
        },
        r1a1: u288 {
            limb0: 0x2dc5403124b8b2766caf51c7,
            limb1: 0xb9ed0b96060674c35d818388,
            limb2: 0x6f9a41b549839dd,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xbd4aa4e5ed3e0c30bf730048,
            limb1: 0x80e73a7e12b5104f4ec40460,
            limb2: 0x13db913428ce629c,
        },
        r0a1: u288 {
            limb0: 0xa90e04c07af34a3af7b9ae23,
            limb1: 0xf939d213913f9c4b23910d94,
            limb2: 0xff8ab1b303ea87a,
        },
        r1a0: u288 {
            limb0: 0x38c7e37660597198162fa157,
            limb1: 0xa81284a580d040713c0531af,
            limb2: 0x110351898a488800,
        },
        r1a1: u288 {
            limb0: 0x2c97092cce4fdaa715b6afde,
            limb1: 0x1a698f4e2982c281c0c42464,
            limb2: 0x1bd1c4a7975a22f5,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xb15bbaec50ff49d30e49f74a,
            limb1: 0xc90a8c79fb045c5468f14151,
            limb2: 0x25e47927e92df0e3,
        },
        r0a1: u288 {
            limb0: 0x57f66909d5d40dfb8c7b4d5c,
            limb1: 0xea5265282e2139c48c1953f2,
            limb2: 0x2d7f5e6aff2381f6,
        },
        r1a0: u288 {
            limb0: 0x2a2f573b189a3c8832231394,
            limb1: 0x738abc15844895ffd4733587,
            limb2: 0x20aa11739c4b9bb4,
        },
        r1a1: u288 {
            limb0: 0x51695ec614f1ff4cce2f65d1,
            limb1: 0x6765aae6cb895a2406a6dd7e,
            limb2: 0x1126ee431c522da0,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xe7f01d9086cd6bea2f41aa99,
            limb1: 0x704bab1c6c11f635823c0730,
            limb2: 0x1aa5e3110773f18e,
        },
        r0a1: u288 {
            limb0: 0x85c070793b8763c74570e65c,
            limb1: 0x2af5c8f295dafb150ffb4b8b,
            limb2: 0xda734f5191394b9,
        },
        r1a0: u288 {
            limb0: 0x4875f74e54ce34f890a6c795,
            limb1: 0x9ae6a24d7c63f7240996ac21,
            limb2: 0x2a7c9cc67d33db65,
        },
        r1a1: u288 {
            limb0: 0xb014ee4eda66723db93d7d9a,
            limb1: 0x7d3eb5638239c427a57ce71f,
            limb2: 0x1b0456063dc2a87c,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x9214fc3209f1518b05fd21c6,
            limb1: 0x9bc8ce4f56423009710770e8,
            limb2: 0x32445cc6972799c,
        },
        r0a1: u288 {
            limb0: 0x93ef401ecd9cfae3644d22e6,
            limb1: 0xce5a741a9847a144cfaf8c96,
            limb2: 0xf7a814d5726da4a,
        },
        r1a0: u288 {
            limb0: 0xd19264d986f163b133a91c0c,
            limb1: 0x529dc5ce4b193c0f672c6a32,
            limb2: 0x2e9a118959353374,
        },
        r1a1: u288 {
            limb0: 0x3d97d6e8f45072cc9e85e412,
            limb1: 0x4dafecb04c3bb23c374f0486,
            limb2: 0xa174dd4ac8ee628,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xfa6e20eaa5b8acce6161c367,
            limb1: 0x3d8d035c6953305cfb8065a4,
            limb2: 0x40bb50e482935b,
        },
        r0a1: u288 {
            limb0: 0x4c506a8e01c5144fa535163b,
            limb1: 0x61030d954c1196c840ee7931,
            limb2: 0x2f221fa9c7e3b5ae,
        },
        r1a0: u288 {
            limb0: 0x2613b98211a31e101b009375,
            limb1: 0xe4cfbf39bf10d39059fcec56,
            limb2: 0x196add035e14330e,
        },
        r1a1: u288 {
            limb0: 0xcc093368ee2558dabe10c7be,
            limb1: 0x206a20357ce007c45165fee6,
            limb2: 0xd4fb39f4b1fde10,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x98d8b0c4adcf27bceb305c2c,
            limb1: 0x859afa9c7668ed6152d8cba3,
            limb2: 0x29e7694f46e3a272,
        },
        r0a1: u288 {
            limb0: 0x1d970845365594307ba97556,
            limb1: 0xd002d93ad793e154afe5b49b,
            limb2: 0x12ca77d3fb8eee63,
        },
        r1a0: u288 {
            limb0: 0x9f2934faefb8268e20d0e337,
            limb1: 0xbc4b5e1ec056881319f08766,
            limb2: 0x2e103461759a9ee4,
        },
        r1a1: u288 {
            limb0: 0x7adc6cb87d6b43000e2466b6,
            limb1: 0x65e5cefa42b25a7ee8925fa6,
            limb2: 0x2560115898d7362a,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x823969b5ec0f79a94f88d36b,
            limb1: 0x3512d9e09a8b4a8e1084dc32,
            limb2: 0x1af1156b9c8d06e6,
        },
        r0a1: u288 {
            limb0: 0xafd7dd0f120256e11800dee8,
            limb1: 0x3a317cae149063c44cf7fa8c,
            limb2: 0x2bd8ea8b2474d1e5,
        },
        r1a0: u288 {
            limb0: 0xe1772b865b838d58dd129624,
            limb1: 0xbe9458968158c433742dbcd0,
            limb2: 0x22b6d697a5a3b888,
        },
        r1a1: u288 {
            limb0: 0xbff3b00a55f411bbc1dad2fe,
            limb1: 0x7ae09ac6313e3c00759461ae,
            limb2: 0x558601ecf31c85,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x64d864643668392c0e357cc4,
            limb1: 0x4c9bf66853f1b287015ab84c,
            limb2: 0x2f5f1b92ad7ee4d4,
        },
        r0a1: u288 {
            limb0: 0xdc33c8da5c575eef6987a0e1,
            limb1: 0x51cc07c7ef28e1b8d934bc32,
            limb2: 0x2358d94a17ec2a44,
        },
        r1a0: u288 {
            limb0: 0xf659845b829bbba363a2497b,
            limb1: 0x440f348e4e7bed1fb1eb47b2,
            limb2: 0x1ad0eaab0fb0bdab,
        },
        r1a1: u288 {
            limb0: 0x1944bb6901a1af6ea9afa6fc,
            limb1: 0x132319df135dedddf5baae67,
            limb2: 0x52598294643a4aa,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x76fd94c5e6f17fa6741bd7de,
            limb1: 0xc2e0831024f67d21013e0bdd,
            limb2: 0x21e2af6a43119665,
        },
        r0a1: u288 {
            limb0: 0xad290eab38c64c0d8b13879b,
            limb1: 0xdd67f881be32b09d9a6c76a0,
            limb2: 0x8000712ce0392f2,
        },
        r1a0: u288 {
            limb0: 0xd30a46f4ba2dee3c7ace0a37,
            limb1: 0x3914314f4ec56ff61e2c29e,
            limb2: 0x22ae1ba6cd84d822,
        },
        r1a1: u288 {
            limb0: 0x5d888a78f6dfce9e7544f142,
            limb1: 0x9439156de974d3fb6d6bda6e,
            limb2: 0x106c8f9a27d41a4f,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x6092d1d633b2160a27266d5b,
            limb1: 0x80d00c798b74744e2d6c9897,
            limb2: 0x6aca1e5b3d6e760,
        },
        r0a1: u288 {
            limb0: 0x3f695b0e7bf0e735a060a1fc,
            limb1: 0x21c516331ac46f6f1940a79c,
            limb2: 0x9fb99bd56e3cfd0,
        },
        r1a0: u288 {
            limb0: 0x125cd061734e6d82260bff31,
            limb1: 0x7b1fb56a17f3832fd3c026f3,
            limb2: 0xdafb0c1b7a07131,
        },
        r1a1: u288 {
            limb0: 0x449a0a17221fac459caf049a,
            limb1: 0x4bbd5645024fe09ba86f662d,
            limb2: 0x295e6b43830d7473,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x138792ff5a46d835c3927fde,
            limb1: 0x498899eff0ddfb1e2a6a2a63,
            limb2: 0xfaff0a267eddd92,
        },
        r0a1: u288 {
            limb0: 0xfffeb2ff28064301c583286,
            limb1: 0x223c9e6d3ae5d55a899db5e2,
            limb2: 0x1a88e4cac54f8190,
        },
        r1a0: u288 {
            limb0: 0xcfbe06117f1f6dea20f8379f,
            limb1: 0x6b831cd38c1741b394a2f18d,
            limb2: 0xd44868b638ab5cd,
        },
        r1a1: u288 {
            limb0: 0x21a8bd3280686ca4d3c4a764,
            limb1: 0x3b3576220bbc08abcec8478b,
            limb2: 0x29b73d7c0c8ff4ce,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x92c09e4796207b802168341b,
            limb1: 0xd2d9d6acffd7829066cc49ce,
            limb2: 0xc89c2d0a7b2c81e,
        },
        r0a1: u288 {
            limb0: 0x47e3c1cf6cdb6f3efe778c7f,
            limb1: 0x66b347099b6436794cf062eb,
            limb2: 0x18b4ccc64ae0a857,
        },
        r1a0: u288 {
            limb0: 0x7d5793606a73b2740c71484a,
            limb1: 0xa0070135ca2dc571b28e3c9c,
            limb2: 0x1bc03576e04b94cf,
        },
        r1a1: u288 {
            limb0: 0x1ba85b29875e638c10f16c99,
            limb1: 0x158f2f2acc3c2300bb9f9225,
            limb2: 0x42d8a8c36ea97c6,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x491a2a2eb92babf14d2c70ed,
            limb1: 0x88adfa10d27cbf95efc87ca9,
            limb2: 0x1ea367cb9628819e,
        },
        r0a1: u288 {
            limb0: 0xf832704f9fde600131526e2,
            limb1: 0x943da98740594bc8573bc424,
            limb2: 0x225058a1522f4c77,
        },
        r1a0: u288 {
            limb0: 0xf43027c8e85927d41ef51aa6,
            limb1: 0x6d6d7aa318f97e5043973413,
            limb2: 0x11a037a0589e5f86,
        },
        r1a1: u288 {
            limb0: 0x45f2d483ce8e645ed19421cb,
            limb1: 0x6363b56540ef0ea0331819ca,
            limb2: 0x2b5c9bfcfb64a95f,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x9440ad13408319cecb07087b,
            limb1: 0x537afc0c0cfe8ff761c24e08,
            limb2: 0x48e4ac10081048d,
        },
        r0a1: u288 {
            limb0: 0xa37fb82b03a2c0bb2aa50c4f,
            limb1: 0xd3797f05c8fb84f6b630dfb,
            limb2: 0x2dffde2d6c7e43ff,
        },
        r1a0: u288 {
            limb0: 0xc55d2eb1ea953275e780e65b,
            limb1: 0xe141cf680cab57483c02e4c7,
            limb2: 0x1b71395ce5ce20ae,
        },
        r1a1: u288 {
            limb0: 0xe4fab521f1212a1d301065de,
            limb1: 0x4f8d31c78df3dbe4ab721ef2,
            limb2: 0x2828f21554706a0e,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x8cefc2f2af2a3082b790784e,
            limb1: 0x97ac13b37c6fbfc736a3d456,
            limb2: 0x683b1cdffd60acd,
        },
        r0a1: u288 {
            limb0: 0xa266a8188a8c933dcffe2d02,
            limb1: 0x18d3934c1838d7bce81b2eeb,
            limb2: 0x206ac5cdda42377,
        },
        r1a0: u288 {
            limb0: 0x90332652437f6e177dc3b28c,
            limb1: 0x75bd8199433d607735414ee8,
            limb2: 0x29d6842d8298cf7e,
        },
        r1a1: u288 {
            limb0: 0xadedf46d8ea11932db0018e1,
            limb1: 0xbc7239ae9d1453258037befb,
            limb2: 0x22e7ebdd72c6f7a1,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x3a7dc5b45b0cd09dd75ff780,
            limb1: 0x2902bd9bd8ba8605b3662044,
            limb2: 0x1ec042f89cec2f4a,
        },
        r0a1: u288 {
            limb0: 0x3e484c01e1c71dad604b6e00,
            limb1: 0x63cd271538443abcbe242bee,
            limb2: 0x10c38586e25d160e,
        },
        r1a0: u288 {
            limb0: 0xc406f3abf9503a06bdeb2eef,
            limb1: 0x8653c7da6db9ab8b17639151,
            limb2: 0xad22e688ec88604,
        },
        r1a1: u288 {
            limb0: 0x50fc42dbc609f56f660d8b86,
            limb1: 0x56a81c62935f53a8194e5d90,
            limb2: 0x2b27bb15c58ff0c3,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xacc013a37118e98a394f1114,
            limb1: 0x97e3d97d841f62677ad653b1,
            limb2: 0xfa27c5f03ef3e74,
        },
        r0a1: u288 {
            limb0: 0x9599de7b6e6a8aeef6b63e52,
            limb1: 0x73e39f958d986d83148d8c8a,
            limb2: 0x208d43519f69f381,
        },
        r1a0: u288 {
            limb0: 0x898b0f8615e3cf94474d7196,
            limb1: 0x82213cada178b34ae97fdb67,
            limb2: 0x11a8f2b07229c348,
        },
        r1a1: u288 {
            limb0: 0x8a100eb3750e818962602ec3,
            limb1: 0xdca2571e9fc5588275e810fd,
            limb2: 0x290c599d240303ec,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x348e15357d9299e582033136,
            limb1: 0x53578c46b15abb39da35a56e,
            limb2: 0x1043b711f86bb33f,
        },
        r0a1: u288 {
            limb0: 0x9fa230a629b75217f0518e7c,
            limb1: 0x77012a4bb8751322a406024d,
            limb2: 0x121e2d845d972695,
        },
        r1a0: u288 {
            limb0: 0x5600f2d51f21d9dfac35eb10,
            limb1: 0x6fde61f876fb76611fb86c1a,
            limb2: 0x2bf4fbaf5bd0d0df,
        },
        r1a1: u288 {
            limb0: 0xd732aa0b6161aaffdae95324,
            limb1: 0xb3c4f8c3770402d245692464,
            limb2: 0x2a0f1740a293e6f0,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x481b93066804d8e4a43ea2f5,
            limb1: 0x29399b4d554a5731966efdf4,
            limb2: 0x100692df233dfccb,
        },
        r0a1: u288 {
            limb0: 0xa03028f9394d39e5aff150c2,
            limb1: 0x82b1b27285e7d875b1cc49e8,
            limb2: 0x1aa360e1848acc84,
        },
        r1a0: u288 {
            limb0: 0xc358787d7c823681590988f,
            limb1: 0xa3e33a227d61efc5734e48e4,
            limb2: 0x15e7e41317f696d9,
        },
        r1a1: u288 {
            limb0: 0x73141ff9e75e2761d8d99b93,
            limb1: 0x48b8fbe75ec09c4496c9652f,
            limb2: 0x1edc83253b7ac568,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xa9e2efa41aaa98ab59728940,
            limb1: 0x163c0425f66ce72daef2f53e,
            limb2: 0x2feaf1b1770aa7d8,
        },
        r0a1: u288 {
            limb0: 0x3bb7afd3c0a79b6ac2c4c063,
            limb1: 0xee5cb42e8b2bc999e312e032,
            limb2: 0x1af2071ae77151c3,
        },
        r1a0: u288 {
            limb0: 0x1cef1c0d8956d7ceb2b162e7,
            limb1: 0x202b4af9e51edfc81a943ded,
            limb2: 0xc9e943ffbdcfdcb,
        },
        r1a1: u288 {
            limb0: 0xe18b1b34798b0a18d5ad43dd,
            limb1: 0x55e8237731941007099af6b8,
            limb2: 0x1472c0290db54042,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xe6100d19eaef8d37a80e60df,
            limb1: 0x4ef3e1a2b34daa1c2be28701,
            limb2: 0x92500ae61c29ded,
        },
        r0a1: u288 {
            limb0: 0xcb5fe102a0a2aeb5f2b1d8b5,
            limb1: 0x48c7bc91c8b114893d8b23cd,
            limb2: 0x21268b5f3137e05e,
        },
        r1a0: u288 {
            limb0: 0x67b383adbc235c125e89ac73,
            limb1: 0xf140e37cce399681b4f96b6c,
            limb2: 0x29da1de8b7c2764b,
        },
        r1a1: u288 {
            limb0: 0x3a20a1e0817f5af4c383af92,
            limb1: 0xb6447b112ca3c55500553bae,
            limb2: 0xad54da1adb037ab,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xb4c7963e0d1dc082de0725e,
            limb1: 0x375a7a3d765918de24804223,
            limb2: 0xf177b77b031596d,
        },
        r0a1: u288 {
            limb0: 0x87a7b9c5f10500b0b40d7a1e,
            limb1: 0x6f234d1dc7f1394b55858810,
            limb2: 0x26288146660a3914,
        },
        r1a0: u288 {
            limb0: 0xa6308c89cebe40447abf4a9a,
            limb1: 0x657f0fdda13b1f8ee314c22,
            limb2: 0x1701aabc250a9cc7,
        },
        r1a1: u288 {
            limb0: 0x9db9bf660dc77cbe2788a755,
            limb1: 0xbdf9c1c15a4bd502a119fb98,
            limb2: 0x14b4de3d26bd66e1,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x53c49c62ca96007e14435295,
            limb1: 0x85aeb885e4123ca8d3232fdf,
            limb2: 0x750017ce108abf3,
        },
        r0a1: u288 {
            limb0: 0xba6bf3e25d370182e4821239,
            limb1: 0x39de83bf370bd2ba116e8405,
            limb2: 0x2b8417a72ba6d940,
        },
        r1a0: u288 {
            limb0: 0xa922f50550d349849b14307b,
            limb1: 0x569766b6feca6143a5ddde9d,
            limb2: 0x2c3c6765b25a01d,
        },
        r1a1: u288 {
            limb0: 0x6016011bdc3b506563b0f117,
            limb1: 0xbab4932beab93dde9b5b8a5c,
            limb2: 0x1bf3f698de0ace60,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x6cd6d068630c95ff7923dace,
            limb1: 0x327c95abb26719a3e4f307d4,
            limb2: 0x1622ee5d85fd5915,
        },
        r0a1: u288 {
            limb0: 0x3b0cab292557116e4a91297c,
            limb1: 0x73e3c8e25063487150b2b475,
            limb2: 0x10b9c1c61e8b6478,
        },
        r1a0: u288 {
            limb0: 0xd5edff0ce6e33bb98c43f4a5,
            limb1: 0xdefbbd27923dd717a2029ccd,
            limb2: 0x1dde221b1cae459,
        },
        r1a1: u288 {
            limb0: 0xf582a6716fc11b9594c7cda2,
            limb1: 0x4b375f530154fbdd63e5feb,
            limb2: 0xb49455f93935ab,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x54fcd4a24d259b46df23323f,
            limb1: 0x47e6fdfb9c428d378a40ff4e,
            limb2: 0x1df34ff52254dff6,
        },
        r0a1: u288 {
            limb0: 0xe0c10735495ed8f5cd2e4be0,
            limb1: 0xc86bc1fb1f401ef4df3b1cd0,
            limb2: 0x28c43896b60b6285,
        },
        r1a0: u288 {
            limb0: 0x1c96043ad27370916cb891b4,
            limb1: 0x87329ba866d1b2e138d8c107,
            limb2: 0x2969b2c3e19a125a,
        },
        r1a1: u288 {
            limb0: 0x439d38ff3bfb073cf2b5661f,
            limb1: 0x40fd99e28d8fb2f2ff6a20e7,
            limb2: 0x182bde6af8c937b7,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xb9f05ffda3ee208f990ff3a8,
            limb1: 0x6201d08440b28ea672b9ea93,
            limb2: 0x1ed60e5a5e778b42,
        },
        r0a1: u288 {
            limb0: 0x8e8468b937854c9c00582d36,
            limb1: 0x7888fa8b2850a0c555adb743,
            limb2: 0xd1342bd01402f29,
        },
        r1a0: u288 {
            limb0: 0xf5c4c66a974d45ec754b3873,
            limb1: 0x34322544ed59f01c835dd28b,
            limb2: 0x10fe4487a871a419,
        },
        r1a1: u288 {
            limb0: 0xedf4af2df7c13d6340069716,
            limb1: 0x8592eea593ece446e8b2c83b,
            limb2: 0x12f9280ce8248724,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x2ddf82dac5876ef85cbd9209,
            limb1: 0x589fcd0afc56475897b6712f,
            limb2: 0xbd4b3348385e23b,
        },
        r0a1: u288 {
            limb0: 0x1c3aa02855ddee9cd40d4eae,
            limb1: 0xf6ed3e19ac13cbd2012f796a,
            limb2: 0x1dc1b58676a8f698,
        },
        r1a0: u288 {
            limb0: 0xc4830930ba2848c2f39f43da,
            limb1: 0xa0fc7164985c553cef876d41,
            limb2: 0x18fce7cada9deef8,
        },
        r1a1: u288 {
            limb0: 0xedb28e73d7e312b0bfe1fa45,
            limb1: 0xed4ae4b37915b6888b40ee88,
            limb2: 0x5cf09de42e4f82a,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xe67f72c6d45f1bb04403139f,
            limb1: 0x9233e2a95d3f3c3ff2f7e5b8,
            limb2: 0x1f931e8e4343b028,
        },
        r0a1: u288 {
            limb0: 0x20ef53907af71803ce3ca5ca,
            limb1: 0xd99b6637ee9c73150b503ea4,
            limb2: 0x1c9759def8a98ea8,
        },
        r1a0: u288 {
            limb0: 0xa0a3b24c9089d224822fad53,
            limb1: 0xdfa2081342a7a895062f3e50,
            limb2: 0x185e8cf6b3e494e6,
        },
        r1a1: u288 {
            limb0: 0x8752a12394b29d0ba799e476,
            limb1: 0x1493421da067a42e7f3d0f8f,
            limb2: 0x67e7fa3e3035edf,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x125ce6d868f59b6805a98a6e,
            limb1: 0x9229c7ee5700f2429eadaecb,
            limb2: 0x292c838c4deb5f8d,
        },
        r0a1: u288 {
            limb0: 0x5325a1514f8ee43d2ed16153,
            limb1: 0x63c33b5123f4ecb9e010da3c,
            limb2: 0x1e0f5d09063cd187,
        },
        r1a0: u288 {
            limb0: 0x605cc50180814223b30419fe,
            limb1: 0xb08ee4b45c98923764c3c996,
            limb2: 0x2e496c94d4ce61d7,
        },
        r1a1: u288 {
            limb0: 0x7f916e4957b0d0a9c5aa8e89,
            limb1: 0x1b4099fb9348cb6604b6644d,
            limb2: 0x2fa7202e6e45ebd0,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x6d6138c95464e5e774ae7ba0,
            limb1: 0xe6ca73a5498e4ccd4bb68fc7,
            limb2: 0x15bf8aa8ed1beff6,
        },
        r0a1: u288 {
            limb0: 0xabd7c55a134ed405b4966d3c,
            limb1: 0xe69dd725ccc4f9dd537fe558,
            limb2: 0x2df4a03e2588a8f1,
        },
        r1a0: u288 {
            limb0: 0x7cf42890de0355ffc2480d46,
            limb1: 0xe33c2ad9627bcb4b028c2358,
            limb2: 0x2a18767b40de20bd,
        },
        r1a1: u288 {
            limb0: 0x79737d4a87fab560f3d811c6,
            limb1: 0xa88fee5629b91721f2ccdcf7,
            limb2: 0x2b51c831d3404d5e,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x16a889bc98dbba30d0e85f7c,
            limb1: 0xfcada96c42f00ced918d942e,
            limb2: 0x2cc9b3197de097a5,
        },
        r0a1: u288 {
            limb0: 0x66b312469ce97517a7e5f585,
            limb1: 0x320485962e1cd1ce5609b3ad,
            limb2: 0x2f5ed56d2b372567,
        },
        r1a0: u288 {
            limb0: 0x50a883556bfbb1f8d5f9d8a3,
            limb1: 0x4aa6753d1fea97e3b8aac1f1,
            limb2: 0x301980e220bb49ed,
        },
        r1a1: u288 {
            limb0: 0xe7614ace25bd3a3830b64ecf,
            limb1: 0x38dedb346af32c21784b968c,
            limb2: 0x101dfcee3c535929,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x9812f6145cf7e949fa207f20,
            limb1: 0x4061c36b08d5bcd408b14f19,
            limb2: 0x8332e08b2eb51ed,
        },
        r0a1: u288 {
            limb0: 0xa4a7ae8f65ba180c523cb33,
            limb1: 0xb71fabbdc78b1128712d32a5,
            limb2: 0x2acd1052fd0fefa7,
        },
        r1a0: u288 {
            limb0: 0x6ea5598e221f25bf27efc618,
            limb1: 0xa2c2521a6dd8f306f86d6db7,
            limb2: 0x13af144288655944,
        },
        r1a1: u288 {
            limb0: 0xea469c4b390716a6810fff5d,
            limb1: 0xf8052694d0fdd3f40b596c20,
            limb2: 0x24d0ea6c86e48c5c,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x2e39be614d904bafea58a8cd,
            limb1: 0xf53f0a6a20a1f1783b0ea2d0,
            limb2: 0x99c451b7bb726d7,
        },
        r0a1: u288 {
            limb0: 0x28ec54a4ca8da838800c573d,
            limb1: 0xb78365fa47b5e192307b7b87,
            limb2: 0x2df87aa88e012fec,
        },
        r1a0: u288 {
            limb0: 0xfb7022881c6a6fdfb18de4aa,
            limb1: 0xb9bd30f0e93c5b93ad333bab,
            limb2: 0x1dd20cbccdeb9924,
        },
        r1a1: u288 {
            limb0: 0x16d8dfdf790a6be16a0e55ba,
            limb1: 0x90ab884395509b9a264472d4,
            limb2: 0xeaec571657b6e9d,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xdf8d520c2fd45b16da910ca7,
            limb1: 0x2023ab59c06742c107d21389,
            limb2: 0x474f8d201c2003a,
        },
        r0a1: u288 {
            limb0: 0xc46ba70245e0d604d975ec09,
            limb1: 0x921be51a6779f8abc213a42b,
            limb2: 0x737865d13506920,
        },
        r1a0: u288 {
            limb0: 0xebde3248ae4a49e4ca67667c,
            limb1: 0x55021936a806c18771a5b497,
            limb2: 0xeddf62dee5cd01d,
        },
        r1a1: u288 {
            limb0: 0x840eb64075057d76ec783626,
            limb1: 0xd09ec083f029b05d8cf747e8,
            limb2: 0x29923f4182ebbd77,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x797d2ef5c1d08447d0723c47,
            limb1: 0x5e3d0a3367a49356be559196,
            limb2: 0x1ac7d70481f3e230,
        },
        r0a1: u288 {
            limb0: 0xec5fd0d82c9efcda61aec42a,
            limb1: 0xd18c0e943f37d7060aebd361,
            limb2: 0x11985d67f47debff,
        },
        r1a0: u288 {
            limb0: 0x71ec5d0ede447fc2d2b8d30a,
            limb1: 0x6d732f49bca172dde108d14e,
            limb2: 0xa187b54b3aa09fe,
        },
        r1a1: u288 {
            limb0: 0x366c39d4f024f7ffcc1f190d,
            limb1: 0xb25354b8c4a9a95e3c632091,
            limb2: 0x94ede742a6d279b,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xce78fc6505db036c10fac771,
            limb1: 0x61f8c0bc7f60ad6415d5e419,
            limb2: 0x59009c5cf9ea663,
        },
        r0a1: u288 {
            limb0: 0xb3b3f697fc34d64ba053b914,
            limb1: 0x317af5815ce5bfffc5a6bc97,
            limb2: 0x23f97fee4deda847,
        },
        r1a0: u288 {
            limb0: 0xf559e09cf7a02674ac2fa642,
            limb1: 0x4fa7548b79cdd054e203689c,
            limb2: 0x2173b379d546fb47,
        },
        r1a1: u288 {
            limb0: 0x758feb5b51caccff9da0f78f,
            limb1: 0xd7f37a1008233b74c4894f55,
            limb2: 0x917c640b4b9627e,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xdfce680eeda9dab9f624300d,
            limb1: 0x3332e1bcaad5d683961ea721,
            limb2: 0x428540bb4a391d0,
        },
        r0a1: u288 {
            limb0: 0x3f654faa3518ed9595db752b,
            limb1: 0xebecb7527a9c9bc0e35974f2,
            limb2: 0x14bcaa1d4c941ce0,
        },
        r1a0: u288 {
            limb0: 0x332ed31f8babcb1fb1902637,
            limb1: 0xa3d0543357fc3e835fe62d46,
            limb2: 0x1ba5e26829d040d8,
        },
        r1a1: u288 {
            limb0: 0x26ad9a6548dbeda3a0cb37ac,
            limb1: 0xe2ddec0f5eb83e84b3af4a3e,
            limb2: 0x2f95fb7eb636c829,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x72548e0d946b796842cfecd8,
            limb1: 0x78b54b355e3c26476b0fab82,
            limb2: 0x2dc9f32c90b6ba31,
        },
        r0a1: u288 {
            limb0: 0xa943be83a6fc90414320753b,
            limb1: 0xd708fde97241095833ce5a08,
            limb2: 0x142111e6a73d2e82,
        },
        r1a0: u288 {
            limb0: 0xc79e8d5465ec5f28781e30a2,
            limb1: 0x697fb9430b9ad050ced6cce,
            limb2: 0x1a9d647149842c53,
        },
        r1a1: u288 {
            limb0: 0x9bab496952559362586725cd,
            limb1: 0xbe78e5a416d9665be64806de,
            limb2: 0x147b550afb4b8b84,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xde3f0cc8eb9d8bc0524ffa31,
            limb1: 0xa29420171bca522f8e0d0ab4,
            limb2: 0x1c527b5683d4814d,
        },
        r0a1: u288 {
            limb0: 0xb831225213716dec94efc1de,
            limb1: 0x970dd107965ba3923ab9d17a,
            limb2: 0x2bfb03ab5ab6d7e9,
        },
        r1a0: u288 {
            limb0: 0x41fa2c98128b2070cbf6c33d,
            limb1: 0xde4def6e8343cd45841c0890,
            limb2: 0x12f1cede76e2b8d7,
        },
        r1a1: u288 {
            limb0: 0x2aadf4029e19b185f59187a,
            limb1: 0xb4e7dd0e3b5c1a62be0f0e48,
            limb2: 0x2029ea04d9e4c426,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x1422e11013fe6cdd7f843391,
            limb1: 0xfb96092ab69fc530e27d8d8e,
            limb2: 0xe39e04564fedd0,
        },
        r0a1: u288 {
            limb0: 0xbd4e81e3b4db192e11192788,
            limb1: 0x805257d3c2bdbc344a15ce0d,
            limb2: 0x10ddd4f47445106b,
        },
        r1a0: u288 {
            limb0: 0x87ab7f750b693ec75bce04e1,
            limb1: 0x128ba38ebed26d74d26e4d69,
            limb2: 0x2f1d22a64c983ab8,
        },
        r1a1: u288 {
            limb0: 0x74207c17f5c8335183649f77,
            limb1: 0x7144cd3520ac2e1be3204133,
            limb2: 0xb38d0645ab3499d,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x5daa65d81efa0ef1b3b5406,
            limb1: 0x759ff07b1035fc39169a31ee,
            limb2: 0x101ca4f03f0629e,
        },
        r0a1: u288 {
            limb0: 0x10cdf0ef882fb24b6a44bbd3,
            limb1: 0x580b99e84dc07e055656849b,
            limb2: 0x253201b38848e657,
        },
        r1a0: u288 {
            limb0: 0x8fbd353430e804cbac89ec28,
            limb1: 0xdaee431fd72f78e22a236faa,
            limb2: 0x48b73245c4dad79,
        },
        r1a1: u288 {
            limb0: 0xd98cc2ed22a85b0f8c63206e,
            limb1: 0xd2aec0400ab5850c7f0fa8cf,
            limb2: 0x649735015bf42af,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x49173a889c697b0ab07f35bc,
            limb1: 0xdcffb65f4b4c21ced6b623af,
            limb2: 0x1366d12ee6022f7b,
        },
        r0a1: u288 {
            limb0: 0x285fdce362f7a79b89c49b5c,
            limb1: 0xae9358c8eaf26e2fed7353f5,
            limb2: 0x21c91fefaf522b5f,
        },
        r1a0: u288 {
            limb0: 0x748798f96436e3b18c64964a,
            limb1: 0xfc3bb221103d3966d0510599,
            limb2: 0x167859ae2ebc5e27,
        },
        r1a1: u288 {
            limb0: 0xe3b55b05bb30e23fa7eba05b,
            limb1: 0xa5fc8b7f7bc6abe91c90ddd5,
            limb2: 0xe0da83c6cdebb5a,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x30a4abff5957209783681bfb,
            limb1: 0x82d868d5ca421e4f1a0daf79,
            limb2: 0x1ba96ef98093d510,
        },
        r0a1: u288 {
            limb0: 0xd9132c7f206a6c036a39e432,
            limb1: 0x8a2dfb94aba29a87046110b8,
            limb2: 0x1fad2fd5e5e37395,
        },
        r1a0: u288 {
            limb0: 0x76b136dc82b82e411b2c44f6,
            limb1: 0xe405f12052823a54abb9ea95,
            limb2: 0xf125ba508c26ddc,
        },
        r1a1: u288 {
            limb0: 0x1bae07f5f0cc48e5f7aac169,
            limb1: 0x47d1288d741496a960e1a979,
            limb2: 0xa0911f6cc5eb84e,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x9f79430d5ef315d742ba7cc2,
            limb1: 0x20aacc886043783d85b20292,
            limb2: 0x1323cd0f26d8101a,
        },
        r0a1: u288 {
            limb0: 0x10b2ac6faa0f2c6d21dd1a46,
            limb1: 0x692a71ed6ead0995c1dd5f06,
            limb2: 0x38e5099a87e0acb,
        },
        r1a0: u288 {
            limb0: 0x47ae74d8002447773c1ed5c6,
            limb1: 0xbeefb67ce6653bc31410cc77,
            limb2: 0x38bcbf510e04693,
        },
        r1a1: u288 {
            limb0: 0x87f7dfe2a9704d878a43c43a,
            limb1: 0x388417c8c9596caee4b8f3c8,
            limb2: 0x2231862dd6ea5377,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x8824ae4e52f07175b229f86c,
            limb1: 0xea266c73c6740dc7206d703e,
            limb2: 0xa0bcd21da42425d,
        },
        r0a1: u288 {
            limb0: 0x91c8d9f501c8c2411d65a5b2,
            limb1: 0x6f693a3cbab19d3ac5acf696,
            limb2: 0x2cb77ffe6050fd13,
        },
        r1a0: u288 {
            limb0: 0x127d86621c661371e92e5fd,
            limb1: 0x5a334ed75d208520e997f2e3,
            limb2: 0x3e78ee48b36d52b,
        },
        r1a1: u288 {
            limb0: 0x640d7cc8a8916f3987fcc33c,
            limb1: 0x82738853adee48da240f6b1c,
            limb2: 0x1a0013b7fe68edfa,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x2e7b3a5a35456f42e87968e6,
            limb1: 0xb4303f5093c3a460674a2fcd,
            limb2: 0x2b5331f03b8fa15f,
        },
        r0a1: u288 {
            limb0: 0x7cea371d64d8bd0fc5b9427e,
            limb1: 0x76208e15fc175e352c274fbe,
            limb2: 0x5ceb46647d41234,
        },
        r1a0: u288 {
            limb0: 0x6cdac06bfcf041a30435a560,
            limb1: 0x15a7ab7ed1df6d7ed12616a6,
            limb2: 0x2520b0f462ad4724,
        },
        r1a1: u288 {
            limb0: 0xe8b65c5fff04e6a19310802f,
            limb1: 0xc96324a563d5dab3cd304c64,
            limb2: 0x230de25606159b1e,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x65202a838e48a9d934e11db8,
            limb1: 0xeb46c664339ef677558bbb71,
            limb2: 0x132ac06128a0a57b,
        },
        r0a1: u288 {
            limb0: 0xbc21baf183836fa8dc9de81c,
            limb1: 0x806b66e601e4ff52a20e891a,
            limb2: 0x12e535eb6ae922c1,
        },
        r1a0: u288 {
            limb0: 0xc0b103b1723019de05b304a3,
            limb1: 0xff8f7760a660a16df500b596,
            limb2: 0x8db75dc6535f297,
        },
        r1a1: u288 {
            limb0: 0x3a686dcde09afac7da57832c,
            limb1: 0xa5947df796243b62fa4da442,
            limb2: 0x259924e4a773bef0,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xb2236e5462d1e11842039bb5,
            limb1: 0x8d746dd0bb8bb2a455d505c1,
            limb2: 0x2fd3f4a905e027ce,
        },
        r0a1: u288 {
            limb0: 0x3d6d9836d71ddf8e3b741b09,
            limb1: 0x443f16e368feb4cb20a5a1ab,
            limb2: 0xb5f19dda13bdfad,
        },
        r1a0: u288 {
            limb0: 0x4e5612c2b64a1045a590a938,
            limb1: 0xbca215d075ce5769db2a29d7,
            limb2: 0x161e651ebdfb5065,
        },
        r1a1: u288 {
            limb0: 0xc02a55b6685351f24e4bf9c7,
            limb1: 0x4134240119050f22bc4991c8,
            limb2: 0x300bd9f8d76bbc11,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xe9296a3a3aed4c4143d2e0ba,
            limb1: 0x7de973514b499b2da739b3e6,
            limb2: 0x1b4b807986fcdee0,
        },
        r0a1: u288 {
            limb0: 0xb9295fecce961afe0c5e6dad,
            limb1: 0xc4e30c322bcae6d526c4de95,
            limb2: 0x1fee592f513ed6b2,
        },
        r1a0: u288 {
            limb0: 0x7245f5e5e803d0d448fafe21,
            limb1: 0xcbdc032ecb3b7a63899c53d0,
            limb2: 0x1fde9ffc17accfc3,
        },
        r1a1: u288 {
            limb0: 0x8edcc1b2fdd35c87a7814a87,
            limb1: 0x99d54b5c2fe171c49aa9cb08,
            limb2: 0x130ef740e416a6fe,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x38f941f3820c4025d48597c4,
            limb1: 0x4270c36c42111e8a83bed2ed,
            limb2: 0x2d0d91a20b75cbb9,
        },
        r0a1: u288 {
            limb0: 0x5ac829defc8a29c4e18ec184,
            limb1: 0x3ad0a15a0dd4df948ef5ff02,
            limb2: 0xf618f631c37e868,
        },
        r1a0: u288 {
            limb0: 0xf96e4555f7a83c01c2b1d33f,
            limb1: 0x74ee4e7ee57979aed686387d,
            limb2: 0x1c3d7a9c3d45957f,
        },
        r1a1: u288 {
            limb0: 0x210a733628cff21f964acf38,
            limb1: 0x58addf725f511f5c0f3c4c48,
            limb2: 0x25c47d2540c2db11,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x40675e9847f925e0cd58ff84,
            limb1: 0x19a957ff534718c419e1b3a6,
            limb2: 0xbb2e95d559fbe61,
        },
        r0a1: u288 {
            limb0: 0x70bd9ffbe4ec1ca028fc7d77,
            limb1: 0x12b76b14785c6e62da580b73,
            limb2: 0x15b1b31fd06f755f,
        },
        r1a0: u288 {
            limb0: 0x92dd2c2444d613dfaa53a1e3,
            limb1: 0xec043691d9b8376ef4c32dbb,
            limb2: 0x1804f2db8a7b3a55,
        },
        r1a1: u288 {
            limb0: 0xe8ad6e24b323fdb6cc8189a9,
            limb1: 0x501fc22cd9d6c75bfcfe658e,
            limb2: 0x4669f457c82b8e1,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x537ecf0916b38aeea21d4e47,
            limb1: 0x181a00de27ba4be1b380d6c8,
            limb2: 0x8c2fe2799316543,
        },
        r0a1: u288 {
            limb0: 0xe68fff5ee73364fff3fe403b,
            limb1: 0x7b8685c8a725ae79cfac8f99,
            limb2: 0x7b4be349766aba4,
        },
        r1a0: u288 {
            limb0: 0xdf7c93c0095545ad5e5361ea,
            limb1: 0xce316c76191f1e7cd7d03f3,
            limb2: 0x22ea21f18ddec947,
        },
        r1a1: u288 {
            limb0: 0xa19620b4c32db68cc1c2ef0c,
            limb1: 0xffa1e4be3bed5faba2ccbbf4,
            limb2: 0x16fc78a64c45f518,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x2b6af476f520b4bf804415bc,
            limb1: 0xd949ee7f9e8874698b090fca,
            limb2: 0x34db5e5ec2180cf,
        },
        r0a1: u288 {
            limb0: 0x3e06a324f038ac8abcfb28d7,
            limb1: 0xc2e6375b7a83c0a0145f8942,
            limb2: 0x2247e79161483763,
        },
        r1a0: u288 {
            limb0: 0x708773d8ae3a13918382fb9d,
            limb1: 0xaf83f409556e32aa85ae92bf,
            limb2: 0x9af0a924ae43ba,
        },
        r1a1: u288 {
            limb0: 0xa6fded212ff5b2ce79755af7,
            limb1: 0x55a2adfb2699ef5de6581b21,
            limb2: 0x2476e83cfe8daa5c,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x9ab1f3d5a481c50cff61b4ab,
            limb1: 0x11f4705a4954e6a036be2ad2,
            limb2: 0x308f243a8a83264,
        },
        r0a1: u288 {
            limb0: 0x5f19b29c09416b2fd501f695,
            limb1: 0xd0a5c0a568ca5e38f82b2f7a,
            limb2: 0x8abaf41ba2b92f5,
        },
        r1a0: u288 {
            limb0: 0x6cc5a6aa31c75bfb717c7828,
            limb1: 0x96fe9ee8789208c41d57d3b8,
            limb2: 0x1ff348bb7825845a,
        },
        r1a1: u288 {
            limb0: 0x23e6063e1cca25fa4a6e992e,
            limb1: 0xe94e827315d1667557cbe7de,
            limb2: 0x2cc27fe4c068e1df,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x5de7a643e301caa63b685021,
            limb1: 0x933a277a93f708227c90f768,
            limb2: 0x426809a902d5047,
        },
        r0a1: u288 {
            limb0: 0xbb25fb66cb4bf4c7ec50bdbd,
            limb1: 0x52a75a0facd2b7bf0ea93bec,
            limb2: 0x1f265ce4dbe1a42b,
        },
        r1a0: u288 {
            limb0: 0xc5717cea7518c3550b4d5f4,
            limb1: 0xc95394cb07fdfc22e63d990a,
            limb2: 0x2b4bcc47347e8eb5,
        },
        r1a1: u288 {
            limb0: 0xc5a6f1284ee2bdd4922c2508,
            limb1: 0xcd55e1d8ff43e6dd59224505,
            limb2: 0x2c376da2c4c11de5,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x1c4759bcf7c607fe3f839d4d,
            limb1: 0xea91f311da73327e2ed40785,
            limb2: 0x2017052c72360f42,
        },
        r0a1: u288 {
            limb0: 0x38cf8a4368c0709980199fc3,
            limb1: 0xfc9047885996c19e84d7d4ea,
            limb2: 0x1795549eb0b97783,
        },
        r1a0: u288 {
            limb0: 0xb70f7ecfbec0eaf46845e8cc,
            limb1: 0x9ddf274c2a9f89ea3bc4d66f,
            limb2: 0xcc6f106abfcf377,
        },
        r1a1: u288 {
            limb0: 0xf6ff11ce29186237468c2698,
            limb1: 0x5c629ad27bb61e4826bb1313,
            limb2: 0x2014c6623f1fb55e,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xc403ea5ad65aadd602c8c76f,
            limb1: 0x7a8d2727cd7fa40d97615b39,
            limb2: 0x14bd9b9bc6c2c1c1,
        },
        r0a1: u288 {
            limb0: 0xcd28af7919b01761c69bd246,
            limb1: 0x8a1a211a81094740e2cc984e,
            limb2: 0x2766e09571dc194c,
        },
        r1a0: u288 {
            limb0: 0xa24dbe5f1fb539a5d9d39db7,
            limb1: 0xd7eef78019e82d7e1f77d2f5,
            limb2: 0x6d7b6e70105c87d,
        },
        r1a1: u288 {
            limb0: 0x30836b87e6e8553c665ffbe0,
            limb1: 0xb0474bb94febd802f9049ad0,
            limb2: 0x2774e72d0844eea4,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xc648054e4b6134bbfd68487f,
            limb1: 0xdf0506dad3f3d098c13a6386,
            limb2: 0x26bebeb6f46c2e8c,
        },
        r0a1: u288 {
            limb0: 0x9d0cdb28a94204776c6e6ba6,
            limb1: 0x303f02dfe619752b1607951d,
            limb2: 0x1127d8b17ef2c064,
        },
        r1a0: u288 {
            limb0: 0xe34ca1188b8db4e4694a696c,
            limb1: 0x243553602481d9b88ca1211,
            limb2: 0x1f8ef034831d0132,
        },
        r1a1: u288 {
            limb0: 0xe3a5dfb1785690dad89ad10c,
            limb1: 0xd690b583ace24ba033dd23e0,
            limb2: 0x405d0709e110c03,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x3b5aa24fe300f5bef5aefca,
            limb1: 0x5d5566dc41ca40c4af2bf978,
            limb2: 0x39a42540cb68ab8,
        },
        r0a1: u288 {
            limb0: 0xe21ea63fac2d99bf899d8353,
            limb1: 0xecdf87c89dafc1f9be69379b,
            limb2: 0x1c75e3d0966038ad,
        },
        r1a0: u288 {
            limb0: 0x7c9f991de50f505a8dc707e7,
            limb1: 0x259d423172d9927ffb0e98d1,
            limb2: 0x15fb83693066d1ff,
        },
        r1a1: u288 {
            limb0: 0x72c144b5e7d364d572576db6,
            limb1: 0x5d75c50c43614aea3e81a99b,
            limb2: 0x1ef4651860019554,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x72cc2cef2785ce4ff4e9b7af,
            limb1: 0x60ed5b9c207d7f31fb6234ab,
            limb2: 0x1bb17a4bc7b643ed,
        },
        r0a1: u288 {
            limb0: 0x9424eb15b502cde7927c7530,
            limb1: 0xa0e33edbbaa9de8e9c206059,
            limb2: 0x2b9a3a63bbf4af99,
        },
        r1a0: u288 {
            limb0: 0x423811cb6386e606cf274a3c,
            limb1: 0x8adcc0e471ecfe526f56dc39,
            limb2: 0x9169a8660d14368,
        },
        r1a1: u288 {
            limb0: 0xf616c863890c3c8e33127931,
            limb1: 0xcc9414078a6da6989dae6b91,
            limb2: 0x594d6a7e6b34ab2,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x4617750de3208c0a42bf7c07,
            limb1: 0x7e2d94e31538522d38df8b23,
            limb2: 0x23954455da7aef56,
        },
        r0a1: u288 {
            limb0: 0x6fef0ba4bbf6577133bdc9ae,
            limb1: 0xcab064e22aaf2ceec03f1b77,
            limb2: 0x274369683ff67155,
        },
        r1a0: u288 {
            limb0: 0x5dce7b13d41ff1b90727094f,
            limb1: 0x426ef23f29c4df03dc8edf8,
            limb2: 0x313b4cdbf3d9c5e,
        },
        r1a1: u288 {
            limb0: 0x62c5ac5fd0d7b3ef591e828,
            limb1: 0x650f8fc6b0fe55eb28d0fca8,
            limb2: 0xf5bb0abe931a208,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xf2d619ae78049bf9141c35cf,
            limb1: 0x717f8b10d469a1ee2d91f191,
            limb2: 0x2c72c82fa8afe345,
        },
        r0a1: u288 {
            limb0: 0xb89321223b82a2dc793c0185,
            limb1: 0x71506a0cf4adb8e51bb7b759,
            limb2: 0x2c13b92a98651492,
        },
        r1a0: u288 {
            limb0: 0x4947ef2c89276f77f9d20942,
            limb1: 0xb454d68685ab6b6976e71ec5,
            limb2: 0x19a938d0e78a3593,
        },
        r1a1: u288 {
            limb0: 0xbe883eb119609b489c01c905,
            limb1: 0xaa06779922047f52feac5ce6,
            limb2: 0x76977a3015dc164,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x43a96a588005043a46aadf2c,
            limb1: 0xa37b89d8a1784582f0c52126,
            limb2: 0x22e9ef3f5d4b2297,
        },
        r0a1: u288 {
            limb0: 0x8c6f6d8474cf6e5a58468a31,
            limb1: 0xeb1ce6ac75930ef1c79b07e5,
            limb2: 0xf49839a756c7230,
        },
        r1a0: u288 {
            limb0: 0x82b84693a656c8e8c1f962fd,
            limb1: 0x2c1c8918ae80282208b6b23d,
            limb2: 0x14d3504b5c8d428f,
        },
        r1a1: u288 {
            limb0: 0x60ef4f4324d5619b60a3bb84,
            limb1: 0x6d3090caefeedbc33638c77a,
            limb2: 0x159264c370c89fec,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xa3343aa671fa957f64383174,
            limb1: 0x5d0fbca92791fb10ca8bfba7,
            limb2: 0x114f2c6ae3a67df6,
        },
        r0a1: u288 {
            limb0: 0x50f6b86be16e52076b114eac,
            limb1: 0x780e63533112887af8e1b20a,
            limb2: 0x63e07909f8e5150,
        },
        r1a0: u288 {
            limb0: 0xf4d68bdb295f81fb688b56c9,
            limb1: 0xabc9867b1aae2bca05251e19,
            limb2: 0x1a4d8e8bbc5dc905,
        },
        r1a1: u288 {
            limb0: 0x1072bd332617ade1aa5f283e,
            limb1: 0x50dc088ed02b4ee5c8114042,
            limb2: 0x92f0fffce502d7c,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xf21ea2700d86757c9edc60fc,
            limb1: 0x4ed3a4f31b13fbb9fdabfe54,
            limb2: 0xefdc83e2cd29ae1,
        },
        r0a1: u288 {
            limb0: 0x36771d39b743a658ed812080,
            limb1: 0x506453f18d56ef30476706cd,
            limb2: 0x2658fa02d8abf7ce,
        },
        r1a0: u288 {
            limb0: 0x4aad4f76dd2af32ff8a6f388,
            limb1: 0x6aebd448524150ae6bb57548,
            limb2: 0x2702b8c1fb9a5bfb,
        },
        r1a1: u288 {
            limb0: 0xe1462da76f807e5e73062316,
            limb1: 0x244b002de9ef9e9d65b40718,
            limb2: 0x2672d0c637a3cc19,
        },
    },
];
