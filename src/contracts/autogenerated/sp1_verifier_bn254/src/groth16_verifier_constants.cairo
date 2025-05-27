use garaga::definitions::{E12D, G1Point, G2Line, G2Point, u288, u384};
use garaga::groth16::Groth16VerifyingKey;

pub const N_PUBLIC_INPUTS: usize = 2;

pub const vk: Groth16VerifyingKey = Groth16VerifyingKey {
    alpha_beta_miller_loop_result: E12D {
        w0: u288 {
            limb0: 0x38febe9f87f730fa3e5bd174,
            limb1: 0xf763950637a776ef9e248435,
            limb2: 0x29dc2d37c63acbda,
        },
        w1: u288 {
            limb0: 0xa31610a97aa4e4539be919ff,
            limb1: 0xfa4d4bfb72b6a3c002018e97,
            limb2: 0x1968ab971e610fce,
        },
        w2: u288 {
            limb0: 0xee6c1ce3a15313c6f9d57f7e,
            limb1: 0xd37e28396640fcfe5f122aae,
            limb2: 0x210d3763f7a27517,
        },
        w3: u288 {
            limb0: 0x7746ddac185562e756b1b92f,
            limb1: 0x44f8b75638ef5a373f319cd8,
            limb2: 0x51e9605db4edac6,
        },
        w4: u288 {
            limb0: 0xc29e0c2ac434301d671ffa56,
            limb1: 0xa06f1db2d4ca4dd88f979102,
            limb2: 0x1d0126fb7d721e02,
        },
        w5: u288 {
            limb0: 0xed2e022e10acbeb35084dc1,
            limb1: 0xf9de514baee870f114669060,
            limb2: 0x10889a0f300ce96c,
        },
        w6: u288 {
            limb0: 0xeec23aadde92d2dd00e4568e,
            limb1: 0x6d5b4b63667db8f10bd851ab,
            limb2: 0x18f1dd15d2e64c69,
        },
        w7: u288 {
            limb0: 0x2131bad24ea07a033d0bf397,
            limb1: 0xb6312a7f2622146be93b5950,
            limb2: 0x227e61ca055f0ac3,
        },
        w8: u288 {
            limb0: 0xb896f30b06350f012274ebcd,
            limb1: 0xd14298f13a76183170aafe08,
            limb2: 0x302bfd90358d23a0,
        },
        w9: u288 {
            limb0: 0x679d91263798da428fa5ea62,
            limb1: 0x806797d163f4df8b55ec774c,
            limb2: 0x29b72d4ec063face,
        },
        w10: u288 {
            limb0: 0x4dbef45fe0c5a14bef7c4a90,
            limb1: 0xd4ae215c443d0f0768198bc6,
            limb2: 0x2fcc02633e427272,
        },
        w11: u288 {
            limb0: 0x7308cad65773475443cfbd80,
            limb1: 0x972f90a77f1a8aeece6571ff,
            limb2: 0x2d3a570362a9fd7f,
        },
    },
    gamma_g2: G2Point {
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
    },
    delta_g2: G2Point {
        x0: u384 {
            limb0: 0x6eb1bd3a906bbc80830e8e54,
            limb1: 0x5540d3a64503c84fe5e1d9ec,
            limb2: 0x2b65c9ae2605f3ef,
            limb3: 0x0,
        },
        x1: u384 {
            limb0: 0x3fb0e4fb90cd0ff6e909213,
            limb1: 0x3034cbd75d42e708aa4ed803,
            limb2: 0x262eabe81511aa8e,
            limb3: 0x0,
        },
        y0: u384 {
            limb0: 0xa32f295372ae1f43c7cee800,
            limb1: 0xa543e3de42abfc4ab330719b,
            limb2: 0x10d11978bbdb3e8e,
            limb3: 0x0,
        },
        y1: u384 {
            limb0: 0xa7674b397d90e20b01b46b39,
            limb1: 0x13f981f0259304a043919da2,
            limb2: 0x1561b6218d8fe8b0,
            limb3: 0x0,
        },
    },
};

pub const ic: [G1Point; 3] = [
    G1Point {
        x: u384 {
            limb0: 0xaf5958564be7648356830ef7,
            limb1: 0xae2dbbe49ce6a0b67576d38a,
            limb2: 0xed6e0c13f353262,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x748772f553e1e9845f6c0949,
            limb1: 0xa196841d0a3cd7a5f67531f9,
            limb2: 0x28200d54013565dc,
            limb3: 0x0,
        },
    },
    G1Point {
        x: u384 {
            limb0: 0xd6c843c23691c3af532c9e3,
            limb1: 0xb6250c7ffac66efbd638d97f,
            limb2: 0x1b611b8f696f28ff,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0xc5c9190459e8cfe36c48e51a,
            limb1: 0x820d480a37b39ca6ef178543,
            limb2: 0x248c1033bd73c4ff,
            limb3: 0x0,
        },
    },
    G1Point {
        x: u384 {
            limb0: 0xda861e808503e7df4da87b8d,
            limb1: 0x7b201137cfe6ee8cd50ff0a3,
            limb2: 0x2974086bde6c9126,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x69797d4c2c7f195be0785471,
            limb1: 0xa6846f0d583126bab9e8f8ae,
            limb2: 0x40addd35913f11e,
            limb3: 0x0,
        },
    },
];


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
            limb0: 0xe890e29a985c44e756ad0cfc,
            limb1: 0x79cb02127cfc134ab0ca5a97,
            limb2: 0x20a214988866d396,
        },
        r0a1: u288 {
            limb0: 0x594dc3f97d14273c21282e69,
            limb1: 0x687256ba7cb5c9aadb4014f7,
            limb2: 0x21459297b0c84652,
        },
        r1a0: u288 {
            limb0: 0xb4f25f6f310f6081d03fd2e2,
            limb1: 0x60164b81a044060299e63a25,
            limb2: 0x181c1f4a76153ece,
        },
        r1a1: u288 {
            limb0: 0x34ebf00e32b3673726438f7a,
            limb1: 0x25a00bf0cd89a4c3c3bc514b,
            limb2: 0x1f92c600f9cb0d3,
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
            limb0: 0x7fe0e7f2a3c4472f81cff04b,
            limb1: 0x3e8543a404854512e6b70ff9,
            limb2: 0xfc239da58cacc93,
        },
        r0a1: u288 {
            limb0: 0xf240693bf0c64dab754cede,
            limb1: 0x4fddeefc04cb8eb2bc41559a,
            limb2: 0xf1ebbdb306959d7,
        },
        r1a0: u288 {
            limb0: 0xb37f6b1e0b112b95083d2a65,
            limb1: 0x5839fa34e13d525afd9b306b,
            limb2: 0x18482f286b1c615b,
        },
        r1a1: u288 {
            limb0: 0x3385da7f096d24dfb2396dcd,
            limb1: 0x92b039c5b3f7b399d3c51946,
            limb2: 0x2e6b2212d194ef56,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x6b7544e620cb1cfd0a912ff6,
            limb1: 0x50e04f121eb9164370d36c27,
            limb2: 0x103567d2fca1f1ce,
        },
        r0a1: u288 {
            limb0: 0xe86c4ef6315cef1fc619c0a1,
            limb1: 0x40c566b23f3ff1dd8c2f223c,
            limb2: 0xeaa15f50546993f,
        },
        r1a0: u288 {
            limb0: 0x7c2c49ecc2090bb04d3dfd97,
            limb1: 0x71975a27d19097c3367905ab,
            limb2: 0x18e5d6c3f62376ef,
        },
        r1a1: u288 {
            limb0: 0x813bc172e020680732c7896,
            limb1: 0xacb47aa76cc739e09df13177,
            limb2: 0x25ec1fa2eb588d41,
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
            limb0: 0xb28b783a2cd1093200d45b6,
            limb1: 0x3c80def380ac4691c5436190,
            limb2: 0x261c02e2417cb08c,
        },
        r0a1: u288 {
            limb0: 0xb1708979b6c7461d6d8cfaf6,
            limb1: 0x5ee04d9fc4d1c13ad541f132,
            limb2: 0x13d5c93030726928,
        },
        r1a0: u288 {
            limb0: 0x36a27f8cb8424d2a6d4900cc,
            limb1: 0x416f3393ba5c52b29845e180,
            limb2: 0x52c9568e036ad53,
        },
        r1a1: u288 {
            limb0: 0xea94e876e158dee7434d3bbf,
            limb1: 0xfe537bbb30be7f4c7a97a688,
            limb2: 0x2ec170d9d12c391c,
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
            limb0: 0x6735a324d96464889a867a70,
            limb1: 0x13db7ee9e0257a4840add866,
            limb2: 0x20b18384fcc6094a,
        },
        r0a1: u288 {
            limb0: 0x60c0ff3cbcb4a5b075c05c4d,
            limb1: 0x766b5899e7645356e9767f6d,
            limb2: 0xeed96ae04abf6b7,
        },
        r1a0: u288 {
            limb0: 0x78e462e44e04d8034a58c1a4,
            limb1: 0xcc21a70eda7024355ea20714,
            limb2: 0x106772f25d44ab6f,
        },
        r1a1: u288 {
            limb0: 0xae124fb019944e9a17c611a3,
            limb1: 0xe4727fbf98660f6f52ce1100,
            limb2: 0x9f798987087f1d8,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x21eab8e3c343da30ca870ceb,
            limb1: 0xe0456225fde52d8ee0fb93e6,
            limb2: 0x28a1a7ba4b8e4b8e,
        },
        r0a1: u288 {
            limb0: 0xbd809fa15693bffb51c1cd6c,
            limb1: 0x5643a71061e435cd15a0c0b0,
            limb2: 0x23ca8d5231a36028,
        },
        r1a0: u288 {
            limb0: 0x1cf391b1134613db0f72e4a0,
            limb1: 0x87395581343fd6116b162f5a,
            limb2: 0x232dad39cb9dc003,
        },
        r1a1: u288 {
            limb0: 0xbcd9e6389af60c31d5dbf727,
            limb1: 0x5391e1b4a181a893c919e3eb,
            limb2: 0x1ec5eda6bcf040c8,
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
            limb0: 0x39e5cbbfe951a1754cfc252,
            limb1: 0x5e4b98ea9b85a9c06d0886ad,
            limb2: 0x1f73fa627913a8dd,
        },
        r0a1: u288 {
            limb0: 0xd26a566076497fcb01555fd9,
            limb1: 0x2b89a0001ac7d68b474ee76a,
            limb2: 0x1df94f8cdfdb2f29,
        },
        r1a0: u288 {
            limb0: 0x3baf29cb381d96125b0aacd0,
            limb1: 0x83e5e92c8c36e1c1e73cbcb,
            limb2: 0x2c91c123f27bbe64,
        },
        r1a1: u288 {
            limb0: 0x97404ab81e7eaba034621e79,
            limb1: 0xaac520f8be124dc982333dcc,
            limb2: 0x24b98e1a59445d8b,
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
            limb0: 0xfc1123b32ae19553695e6e1d,
            limb1: 0x974d51ab7510c9711d75661d,
            limb2: 0x2c97611d057a1f95,
        },
        r0a1: u288 {
            limb0: 0x2fdfdb79aa9b06066b177dec,
            limb1: 0x29f250ac63826bff78f4be3,
            limb2: 0x28331e06ed00cd27,
        },
        r1a0: u288 {
            limb0: 0xd95fa8c0d28f8e65b5b6a667,
            limb1: 0x68fe7b00180ff8ee5f158343,
            limb2: 0x22bd1bb5ffe4586a,
        },
        r1a1: u288 {
            limb0: 0x552e30058e2e322a343439b0,
            limb1: 0x29f953bc9da0ab875ac44f52,
            limb2: 0xab43bba8a4b6b4c,
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
            limb0: 0x7bc4b4f255a9a0e28e5d1bc6,
            limb1: 0xd618ea81e344c9c643fa775,
            limb2: 0x1e0026efbbf8cd85,
        },
        r0a1: u288 {
            limb0: 0x3809bff0985b3c930ac8fa00,
            limb1: 0xc6b8d5c859081c1f75b95880,
            limb2: 0x1a13f5c0a4b5e36a,
        },
        r1a0: u288 {
            limb0: 0x5b0124ea1fd362ac378d1868,
            limb1: 0xbc9a140d15895f38e88924c5,
            limb2: 0x4e13b209b699252,
        },
        r1a1: u288 {
            limb0: 0xf6a38cccd4a2dddf312560b,
            limb1: 0x21e298defdaf732a7a8e59e6,
            limb2: 0x213f66550c8cd52a,
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
            limb0: 0x4a94ba6233ada0fb2e9db320,
            limb1: 0xda3fc98d778fe35117dece7c,
            limb2: 0x1b7a0d15b98fb04f,
        },
        r0a1: u288 {
            limb0: 0x65b410e6abb169030aecccde,
            limb1: 0x5cb762390ec0e7f6e11de9fa,
            limb2: 0x20dfa162021d315c,
        },
        r1a0: u288 {
            limb0: 0xf1e350ba65db89e2e9d5463d,
            limb1: 0xe1c486c82c307d4c74e50e3d,
            limb2: 0x2f3bd8d7934f4784,
        },
        r1a1: u288 {
            limb0: 0x31f9f9ef75486e620f5575f7,
            limb1: 0x6d6ab87ff94581d4e00ecf41,
            limb2: 0x2ac93b0a27018735,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xde68ff93a3c9ac8d6b7acb39,
            limb1: 0xadfcc2daecbb5e20d175ab6c,
            limb2: 0xa84deb90e494856,
        },
        r0a1: u288 {
            limb0: 0xa2d2713e49fc226d96872ee6,
            limb1: 0xc23bd4312bb7b8caf01c38cd,
            limb2: 0x57bbd4f5e3ddf86,
        },
        r1a0: u288 {
            limb0: 0xfd9fdfebf7931cc16664852a,
            limb1: 0x3b1c248bf5d7ed4ada071130,
            limb2: 0x1c6bc74d59d2b27f,
        },
        r1a1: u288 {
            limb0: 0x58cdfc11dd95dac41e046c5d,
            limb1: 0x46f1ceddae7be1243a900be,
            limb2: 0x262872a677112127,
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
            limb0: 0xb8a4d5d409ac6359c811b01b,
            limb1: 0x8c3efaca4e41f83152669797,
            limb2: 0x2cfcdec9eeb7001e,
        },
        r0a1: u288 {
            limb0: 0x4776538b7ce5c59605d069bd,
            limb1: 0x20737f8ad484cd50ce628936,
            limb2: 0x2269831c19764370,
        },
        r1a0: u288 {
            limb0: 0x16923e1cc821c37a56891042,
            limb1: 0xaf29af75bccab079a7f5d1ee,
            limb2: 0x159ad6a33051da16,
        },
        r1a1: u288 {
            limb0: 0x4564d1707c97f99b7324a3f8,
            limb1: 0x3480633cfb73985e4877dc05,
            limb2: 0x1910eec32887ebc3,
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
            limb0: 0x24ebda285fbeccb1d65aec10,
            limb1: 0x3dc23918979179943bc97fed,
            limb2: 0x12f9f50427037193,
        },
        r0a1: u288 {
            limb0: 0x9eb5d82f5ed86c409928b917,
            limb1: 0xff877f72ebaaa30d96fb78b4,
            limb2: 0x1c6238fc8ba4deb2,
        },
        r1a0: u288 {
            limb0: 0xb15237568e306ce5b694199,
            limb1: 0xeb2e026beffcac74c54b2c2b,
            limb2: 0x13909498b2149e86,
        },
        r1a1: u288 {
            limb0: 0xebb312759e724ef9292b6316,
            limb1: 0xd8f68813d04609742a1748fb,
            limb2: 0x4c200f113d05c5b,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x2964b881e99aa6bfe2274507,
            limb1: 0xc8850b03fd1c94335f082f59,
            limb2: 0x1c0da40783bf935c,
        },
        r0a1: u288 {
            limb0: 0xd99ee8b770df7011dd729c3b,
            limb1: 0x1cc138810dd0220410e5aaab,
            limb2: 0x295eda80e6e1f93c,
        },
        r1a0: u288 {
            limb0: 0x1457c0d2ba0e2c153c549990,
            limb1: 0x952a4fbe5dfe2f969e3cdecb,
            limb2: 0x2aa0eae01a5dd9ca,
        },
        r1a1: u288 {
            limb0: 0x568fbf1d7299925bda8c22da,
            limb1: 0x42e4e89d3323fecf7f0fd92b,
            limb2: 0x16b2197accf1045e,
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
            limb0: 0x20c8b7a82dace7e8ce9ac104,
            limb1: 0x653ae89ef314d488c3185c2,
            limb2: 0x20b127bf75362d2f,
        },
        r0a1: u288 {
            limb0: 0xa0e3b1437d15d772adea350,
            limb1: 0xda323951983ce8c4bf2407d6,
            limb2: 0x193d9c690b2a3b59,
        },
        r1a0: u288 {
            limb0: 0xf162cec984f13f043825d65a,
            limb1: 0xb7c8175b3650b5c5a253c696,
            limb2: 0x1d2ec928312f3fc7,
        },
        r1a1: u288 {
            limb0: 0x32301e3c46a2b25cd172b941,
            limb1: 0x4be1b4e87a90943bc898dcf3,
            limb2: 0xf55f16f0cb9b742,
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
            limb0: 0x1089e6a14c0aa13f5a32f310,
            limb1: 0xff15a8ca234f344895d2885e,
            limb2: 0x3391806901bcad,
        },
        r0a1: u288 {
            limb0: 0x1ac9a6c22a11ac879967ae7c,
            limb1: 0x587096de0414130cb9aee473,
            limb2: 0x145a851e6eca49d,
        },
        r1a0: u288 {
            limb0: 0xc9ed88e8bcce91e974714ffe,
            limb1: 0xe23560f786ff871640047916,
            limb2: 0x1904f332c00f74e9,
        },
        r1a1: u288 {
            limb0: 0xa549c5d6a1ecdf8f410792c0,
            limb1: 0x11da8ecf9c4c005fad03a673,
            limb2: 0x1818c1fd6a91b922,
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
            limb0: 0xc4cc9f136e63df58e70e53a9,
            limb1: 0xca91015ca906b000eed6fd6c,
            limb2: 0x3d34204be4f2490,
        },
        r0a1: u288 {
            limb0: 0xfea8815930cc3da62c97afa8,
            limb1: 0x4d2f895bb099b2cfadc69101,
            limb2: 0x2586b859e52c4806,
        },
        r1a0: u288 {
            limb0: 0xcfdbbdcabe4dd45547efbac5,
            limb1: 0x2340c94fcc9d4c13838a6a0c,
            limb2: 0x17aeaff6654dfd7a,
        },
        r1a1: u288 {
            limb0: 0x613d4f3899383c4d61fd7a6f,
            limb1: 0x9ce3f7df465f9f74bbb884c,
            limb2: 0x1ddafa7a0dff839e,
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
            limb0: 0xfb96fc26ee21666a15937da1,
            limb1: 0xbf1028a3663786154d6afbb8,
            limb2: 0x96e1acc9b59d7b9,
        },
        r0a1: u288 {
            limb0: 0xa921cdea5e6054449493e7bb,
            limb1: 0x487e72757c0b689fad527b68,
            limb2: 0x17ccc67f1d368fa9,
        },
        r1a0: u288 {
            limb0: 0x536b059098bf8b83c17d808e,
            limb1: 0xe619c268cd281eba151ffb4d,
            limb2: 0xfef56bafd602dcf,
        },
        r1a1: u288 {
            limb0: 0xd651cecd185719a6bbb3acf3,
            limb1: 0xcc7cbcfe4e99233e5d6cc2eb,
            limb2: 0x5706a91c226cf26,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x5f4a16b20e122418d4df3f7e,
            limb1: 0x93a6ed2db022cb5639317bbc,
            limb2: 0xf68c1c460a955ad,
        },
        r0a1: u288 {
            limb0: 0x3ef512611a9d451849733036,
            limb1: 0xefe99451e7a6068e6569ce27,
            limb2: 0x1ecfe819dc5a51d5,
        },
        r1a0: u288 {
            limb0: 0xde1fc8ecc3f22f52d3154121,
            limb1: 0x1e876a006f2882fa630f90c5,
            limb2: 0x22ef44307421f61c,
        },
        r1a1: u288 {
            limb0: 0xb1c89d526981b98940916295,
            limb1: 0x2d01ba046d2a9f3892ec87aa,
            limb2: 0x24c133428858ef1d,
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
            limb0: 0xc7b2b9cb18b40bcd073c73ee,
            limb1: 0x1498dac5e28907106588388a,
            limb2: 0x232e1fb392ff4b1f,
        },
        r0a1: u288 {
            limb0: 0x89c30e92e5388547e9301e35,
            limb1: 0xc66f9b358f602bfec15058ff,
            limb2: 0xffb355eeac52db6,
        },
        r1a0: u288 {
            limb0: 0x883b308c38b7bffc4e27230b,
            limb1: 0xc0573824a7bf1d0d793d2897,
            limb2: 0x2c01ee8a4ff975dc,
        },
        r1a1: u288 {
            limb0: 0x3a9aac4b40b4d647103bbc53,
            limb1: 0x9f5bd50cfee19ce1f45a307,
            limb2: 0x14604bc30a851bc,
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
            limb0: 0x4a375301d072bc0c753a7609,
            limb1: 0x9553d0665d788cda56ada674,
            limb2: 0x244e9ec3e6eb711d,
        },
        r0a1: u288 {
            limb0: 0xc0737c43e6182ddfa9452bfc,
            limb1: 0xf94f1a2c88b752c022185c5e,
            limb2: 0xd7a72c0469692b8,
        },
        r1a0: u288 {
            limb0: 0x387c17890734ad9ed8aa0ea2,
            limb1: 0x587fe3a8ad42ff771560edeb,
            limb2: 0x1273f08e431990e5,
        },
        r1a1: u288 {
            limb0: 0x59ae2d41eb4ad252fee8195e,
            limb1: 0x4a0cbab45656e893f0531994,
            limb2: 0x9e1e3b8dc6165b9,
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
            limb0: 0x89acdb76311794900566d739,
            limb1: 0x589fba2bffaf72fe492a0187,
            limb2: 0x17eb5d21698d6dac,
        },
        r0a1: u288 {
            limb0: 0xde83ac5f5fc5595a2f8e109,
            limb1: 0x505054445c0e19a4d41da850,
            limb2: 0xbe9f0aa2899e619,
        },
        r1a0: u288 {
            limb0: 0x81edd1351a7553d03a77a9d4,
            limb1: 0x70004cc507416abfe42ba949,
            limb2: 0x226155b41f9e629c,
        },
        r1a1: u288 {
            limb0: 0x41006d9a022a415dbc36d47a,
            limb1: 0xc0bd93d4121e00dab5e560a1,
            limb2: 0x26c124a98d283d72,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xa6e67c63c8f8befc55918d24,
            limb1: 0x133ab8c1cc8745e8f35b3d5b,
            limb2: 0x204973a23e0776c4,
        },
        r0a1: u288 {
            limb0: 0xb663455f0b706e75384f9c20,
            limb1: 0xfd457a15630c0b55121d48d9,
            limb2: 0xe7a8a2c6539928c,
        },
        r1a0: u288 {
            limb0: 0xd851fac2cbb61a1c5899fc9e,
            limb1: 0xe725feac10397c456d073dc,
            limb2: 0x2aba9024a547d1bb,
        },
        r1a1: u288 {
            limb0: 0xc485fadbc8286e8b4c29359,
            limb1: 0xf9e663864a4f8d80dfd5b429,
            limb2: 0xcc70089b9636bc3,
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
            limb0: 0x56c5ae45ff0afd0a9ddfa9d7,
            limb1: 0x696a02a6480ecd72a8bd506c,
            limb2: 0x285c16c3666037ed,
        },
        r0a1: u288 {
            limb0: 0x2707f80041935ba34ddee70c,
            limb1: 0xab82210d8c24d32dd44ca705,
            limb2: 0x196c3de4e681da2c,
        },
        r1a0: u288 {
            limb0: 0x6198d77029050f80867fb5ba,
            limb1: 0xcea9f75c2af483d83e7b31e4,
            limb2: 0x3af3a2c31b446f9,
        },
        r1a1: u288 {
            limb0: 0x519126741247ac387c9c13ca,
            limb1: 0x5347a6b4e156eb9aab88e42d,
            limb2: 0x6095d073652fef3,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x49297153b3cbccac117a4b49,
            limb1: 0xda52bb1ad44073f2ed528067,
            limb2: 0x2bbfa5ddf33c5322,
        },
        r0a1: u288 {
            limb0: 0x77c9e207550fcb024af1725,
            limb1: 0x937e7cbcb981a67009d13eac,
            limb2: 0x174dd30701eca2f7,
        },
        r1a0: u288 {
            limb0: 0xa88d6d3920f16de89cae9c9f,
            limb1: 0x844a31e0cbdeb2dfce2aa28b,
            limb2: 0xd988d6d9d40b0df,
        },
        r1a1: u288 {
            limb0: 0x5d9d349326ca360bf7004a9c,
            limb1: 0xe507decd96a328f5d05f204c,
            limb2: 0x1c3d45716ec94f40,
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
            limb0: 0xec2aa758f84d9291ce8a29f7,
            limb1: 0x73d0122be5c00ab28922910,
            limb2: 0x85f353b4a6c44a5,
        },
        r0a1: u288 {
            limb0: 0xaa1c5c88706da4314cf72b00,
            limb1: 0xe4e8a4dcceae639717298d23,
            limb2: 0x1327e2df58c4ff4f,
        },
        r1a0: u288 {
            limb0: 0x2052ba122d6a7033721b3555,
            limb1: 0x599b7a77754668faf3365a76,
            limb2: 0x24636bb8c7b22173,
        },
        r1a1: u288 {
            limb0: 0x8cffac3d08d18683e6c29986,
            limb1: 0xec730cc35a346e71b89e7669,
            limb2: 0x2a181b7119cce39,
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
            limb0: 0xdb2884876e1bd161011160ca,
            limb1: 0x50903bf5aea09ff305b39fc1,
            limb2: 0x2b4eb05776767387,
        },
        r0a1: u288 {
            limb0: 0xf3b7e860c94ce16c96b5b1b9,
            limb1: 0xc68e783b3c4f1ece28c5760b,
            limb2: 0xce0391966414946,
        },
        r1a0: u288 {
            limb0: 0xc1c89ff11298c8d03022ba5f,
            limb1: 0xefaa89a9885cdc19372c11ba,
            limb2: 0x185a0d7be9a93235,
        },
        r1a1: u288 {
            limb0: 0x7083c43507a0535309649f16,
            limb1: 0xfc492eb0c6eced9b05f3877a,
            limb2: 0x2941b301237143ac,
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
            limb0: 0xc9878612f9fc6ba1ae9bf3,
            limb1: 0x53f25adfbf05dcbaa5dd79cd,
            limb2: 0x1527ecbbb3279965,
        },
        r0a1: u288 {
            limb0: 0xbe499cf3cfe6ab253bb6c1de,
            limb1: 0xbd8f18c3592368f4dc05af2d,
            limb2: 0x1570b9b3b38cdfdf,
        },
        r1a0: u288 {
            limb0: 0x2a1029153b6b49b0d7022d28,
            limb1: 0x373df288b06606576f3e3e47,
            limb2: 0x1472b87d75c791c,
        },
        r1a1: u288 {
            limb0: 0xad0730967bdd5ac59e1c5197,
            limb1: 0xe0709435497e792808ed1ae2,
            limb2: 0x1fd7396b0da2529b,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x7edd463abcdfa2c0ac4f00,
            limb1: 0xfd02480a40191fb163b7ec17,
            limb2: 0x2eeb903d9158ecea,
        },
        r0a1: u288 {
            limb0: 0x6f83ca0bfa7d822df3a50f6d,
            limb1: 0xf34ceb441d819b406c361017,
            limb2: 0x36c2632c3f126e8,
        },
        r1a0: u288 {
            limb0: 0xd3883625fc4d718f6d2c08af,
            limb1: 0x6a6a5ad914883894bb755126,
            limb2: 0xdd7c196e49795e0,
        },
        r1a1: u288 {
            limb0: 0x194f91a6e9de1ce0c7c0756c,
            limb1: 0xea8321c793c60b3c26afc60c,
            limb2: 0xf935dacd4299c72,
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
            limb0: 0xae101ad5d21289885f51a726,
            limb1: 0x60cb2003c0c8b80bf98e9c99,
            limb2: 0x17c6c489a2a3ec58,
        },
        r0a1: u288 {
            limb0: 0x2c88be8099e6a7665787aa4e,
            limb1: 0x16e506e7fd02b8d63ba9ec79,
            limb2: 0xdcee455373cd3cc,
        },
        r1a0: u288 {
            limb0: 0xb9aaf80d00ed1163b54ce3ce,
            limb1: 0x3ae5544eaf8150bbcd8b7a44,
            limb2: 0x417d01db848ff29,
        },
        r1a1: u288 {
            limb0: 0x59ac973e21b8cb704bd66b08,
            limb1: 0x3bb3ee137f3ec7e9b01c8000,
            limb2: 0x2242adbf6cd6f9c1,
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
            limb0: 0xcb67768f1d2758fdc66b3e48,
            limb1: 0x7e7772c4131e4c8ba5002345,
            limb2: 0x5ba1a0ee8bd512e,
        },
        r0a1: u288 {
            limb0: 0xfbd69e9dc9455134a8cd444d,
            limb1: 0x5bd3f1c7299a64270b648de6,
            limb2: 0x11d52b249774345a,
        },
        r1a0: u288 {
            limb0: 0x4365387e23730398ad038168,
            limb1: 0x9e098417e8c6c648c23670db,
            limb2: 0x29b83a058cc5565b,
        },
        r1a1: u288 {
            limb0: 0x7d3bfa16225e8e08d22fc029,
            limb1: 0x32f9e07a0e64007df9567548,
            limb2: 0x1e240f3f4f1bea44,
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
            limb0: 0x33873d2fa1816a4750b33d87,
            limb1: 0xef1cb0a247cc0da2bc902a6,
            limb2: 0xd1ca1d6511cf569,
        },
        r0a1: u288 {
            limb0: 0x2f8b7eb8516d85ee811113da,
            limb1: 0x49a6f5929903d7b7d41bab5a,
            limb2: 0x27d92e747005bc00,
        },
        r1a0: u288 {
            limb0: 0xdd31b0ef3643a0327d8371a7,
            limb1: 0x87e0725789c37b3fbf912b99,
            limb2: 0x27423eff02f4f80d,
        },
        r1a1: u288 {
            limb0: 0xa80335a89ab8fe1014f7f922,
            limb1: 0x3044fdb0c37a362570610060,
            limb2: 0x756c2c79f9acf0,
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
            limb0: 0x441a51c0c7ade47f0f041511,
            limb1: 0x993237c1b222a66401ddb95d,
            limb2: 0x246ef2163b21ade3,
        },
        r0a1: u288 {
            limb0: 0xa231aed09f768234803801e0,
            limb1: 0x32e4de1513f6b5e10bf81847,
            limb2: 0x2be3c6ac897c5221,
        },
        r1a0: u288 {
            limb0: 0x97b0dbdfb00efe5b6ef65be7,
            limb1: 0x12133aed2351ef09615a6e3,
            limb2: 0x1cfb9aaf575d17ef,
        },
        r1a1: u288 {
            limb0: 0xd2f9bb4e24d082a5a2442d42,
            limb1: 0x4fcddfe5883b5db7b141e1ec,
            limb2: 0x14ce2c10a28c0d44,
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
            limb0: 0xd06f1e63bdf01c9403089153,
            limb1: 0x7fe1f283b393aa347a493f60,
            limb2: 0x5f36eac2f9a43f0,
        },
        r0a1: u288 {
            limb0: 0x4d8f1dc13de1d817e1a79d92,
            limb1: 0x67256fef076f3b4c9394b122,
            limb2: 0x2acbcdd7f59c8e05,
        },
        r1a0: u288 {
            limb0: 0xdb02818a1f914f36bed3350c,
            limb1: 0x533261e7ca4db12769718193,
            limb2: 0x1926fa2fd923551a,
        },
        r1a1: u288 {
            limb0: 0xf1e429b581b4ed171155d6c3,
            limb1: 0xd803e577ca8ab261bf59e665,
            limb2: 0x52252c0bfb4538b,
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
            limb0: 0xe57aa21c8e241a88bdfcbf23,
            limb1: 0xa653bed7d70cd51205797059,
            limb2: 0x2cbac7b29f9dce75,
        },
        r0a1: u288 {
            limb0: 0xa409dda85b4cfdabc361254a,
            limb1: 0xefaa70060a3d130339578532,
            limb2: 0x387703c6c89adcd,
        },
        r1a0: u288 {
            limb0: 0xc9cf4e6c2439a9effa2b859c,
            limb1: 0xa976ac64c186b2a1ff0ac784,
            limb2: 0x2b08571ff63417de,
        },
        r1a1: u288 {
            limb0: 0xe77942ee04c9240dc191fb9f,
            limb1: 0x9f952053b50ca4b0ca63d27d,
            limb2: 0x6a687f57dfdfa5f,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x2d787e5fd7ff861064cb1eac,
            limb1: 0x86fce236b5316d94f98a0441,
            limb2: 0x15b2af19811cea2c,
        },
        r0a1: u288 {
            limb0: 0x97289af80373051754f3282f,
            limb1: 0x43f805008a6be0957c45fe31,
            limb2: 0x1f3597b123a51bc4,
        },
        r1a0: u288 {
            limb0: 0x795c6712cabb719ac47bc380,
            limb1: 0x9d88f251665acbe6732dd0a9,
            limb2: 0x349360f3e4b7d24,
        },
        r1a1: u288 {
            limb0: 0xd1a08022c66d16747b0207f0,
            limb1: 0xdeacff4a53d55fbf385b3bf,
            limb2: 0x9458012a3551a07,
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
            limb0: 0x555ce3298682534b10b6dda9,
            limb1: 0x37b51f7a4bbff44c7cf9239f,
            limb2: 0x265ca0af7c10e6d5,
        },
        r0a1: u288 {
            limb0: 0x889e5dbe11efb798edd72584,
            limb1: 0x359e528cf156c4f9abbad94e,
            limb2: 0x1c3fce1ac3851f79,
        },
        r1a0: u288 {
            limb0: 0xfed3ba4203fe23ac171fe1df,
            limb1: 0xe7f965db1ab23e7f094ba9d,
            limb2: 0x415b191811c0c40,
        },
        r1a1: u288 {
            limb0: 0x482adb7de65be254414ec975,
            limb1: 0x5da5e9d16f54dcab638eba8c,
            limb2: 0x272e2270e0e1dc6e,
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
            limb0: 0xae3b7d65e514428c709babf4,
            limb1: 0xb4f51f558c8f508e077ecf10,
            limb2: 0x6e8515385ec65a2,
        },
        r0a1: u288 {
            limb0: 0x7a45f8d50360bf7da64abc60,
            limb1: 0x859ae1a03b564270503b7a97,
            limb2: 0x26b77635ec7eb00b,
        },
        r1a0: u288 {
            limb0: 0xa4307ac0c53062b5259efcb3,
            limb1: 0xa747f8da22266d6501312a74,
            limb2: 0x114819d8194e0d28,
        },
        r1a1: u288 {
            limb0: 0xe728d537cd8ad3afe42ad406,
            limb1: 0xe1bc8dcf56583751c51e3a40,
            limb2: 0x283ac39d04e9e0c,
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
            limb0: 0xed23687ef701d98e8a54782f,
            limb1: 0x3cec5555345f2df533446004,
            limb2: 0x8328196e01ea984,
        },
        r0a1: u288 {
            limb0: 0x59c236deee1e6f180b70e091,
            limb1: 0xc2cab86ff7de63dbb62dbf8e,
            limb2: 0x176fa2ae5f251d60,
        },
        r1a0: u288 {
            limb0: 0x95a1287bc112848b97e591ba,
            limb1: 0x6573b0cefe07133bdff8cbc2,
            limb2: 0x2a6e17eb7da2c357,
        },
        r1a1: u288 {
            limb0: 0xfa23753441362f0023e9725,
            limb1: 0xb6de696bc0d70e30b977ca3d,
            limb2: 0x177dbb8874c827a8,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x1590e73a2f8de9d8b75e010,
            limb1: 0x47803a317099ae0a8bda682e,
            limb2: 0x230d3176a134edbf,
        },
        r0a1: u288 {
            limb0: 0x78c820d5939d4a3a56792ad7,
            limb1: 0x4e8bb29c57e44685e37774e1,
            limb2: 0x251b0727943d88,
        },
        r1a0: u288 {
            limb0: 0x50c75ab43f485824319222f4,
            limb1: 0x70a3b91b596105d2aef9c559,
            limb2: 0x24f15a81569a88c4,
        },
        r1a1: u288 {
            limb0: 0xeab45bfe991b2df73d441bbe,
            limb1: 0x683818e760dc6b34e13ce19a,
            limb2: 0x271e46228bb9ca7a,
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
            limb0: 0xd6f52aeeab380a05574fed74,
            limb1: 0x78537a1b7f7c8f3ba42c96fd,
            limb2: 0xa5e6b599f1bc6ac,
        },
        r0a1: u288 {
            limb0: 0xeb4e3e40f4cb62f2cfa41d3d,
            limb1: 0xf2f0a4d7744f8ae743f0f5af,
            limb2: 0x1dee41b3448b19cc,
        },
        r1a0: u288 {
            limb0: 0x929b135a2002f5df954a7a40,
            limb1: 0xd04ca89136349fc9cc38bac8,
            limb2: 0x1dd6bf300c33b2fd,
        },
        r1a1: u288 {
            limb0: 0x1451feabaad3be2036e3b7f4,
            limb1: 0x79379ee5f717308faa8d25eb,
            limb2: 0xc38f4c024d45bc7,
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
            limb0: 0xea0a18e9b2e153a9673c4349,
            limb1: 0xfbb32d01d4ddf12973706039,
            limb2: 0x20e455594d4a892e,
        },
        r0a1: u288 {
            limb0: 0x408f7b9bd53cd1effe15d1c2,
            limb1: 0x4e000a8b70922c948d8f60b1,
            limb2: 0x10c214656abd708c,
        },
        r1a0: u288 {
            limb0: 0x91ebe31f8979b1015635f7cf,
            limb1: 0x87940567326e3493745eb74,
            limb2: 0xceb9e57af0fc559,
        },
        r1a1: u288 {
            limb0: 0xc034ad490b1157a94df6cbc0,
            limb1: 0x5307c3279b23550c1c1f40d5,
            limb2: 0x213e561f57e413d2,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xec5905727679b79be14a46b0,
            limb1: 0xb063ca0070292757bdf33442,
            limb2: 0x1512890c7c70e7ef,
        },
        r0a1: u288 {
            limb0: 0x421c203ab8bdbe7cd540fd46,
            limb1: 0x12566f39a003ca751a822bcb,
            limb2: 0x279cad30bcbee2a4,
        },
        r1a0: u288 {
            limb0: 0xff52831659a8037190d91836,
            limb1: 0x87bf87874449a1d713869f67,
            limb2: 0x1fae028e2d2c1a23,
        },
        r1a1: u288 {
            limb0: 0xe4457afb38e36d7c6f9c9afe,
            limb1: 0x16953c1757fdd0619d326f74,
            limb2: 0x2dd2aafb94a40068,
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
            limb0: 0x1679fe55f8cc429286e5e811,
            limb1: 0xae8ff41b98d9915a1d7af6cc,
            limb2: 0x191bf6da89e5613c,
        },
        r0a1: u288 {
            limb0: 0x1c10a53b1db2a297ffd83771,
            limb1: 0x4591c6117f5681f8bf194a5e,
            limb2: 0xff43c4d7087f2da,
        },
        r1a0: u288 {
            limb0: 0xf95454230182a5af16bd89a8,
            limb1: 0xfe5c0be5a48df5c3c31b4e21,
            limb2: 0x12ad9e30b2193b2d,
        },
        r1a1: u288 {
            limb0: 0x50af14c6633503fe864a4b09,
            limb1: 0xdc616fc427d97ecc4237fe9c,
            limb2: 0x1bff709f11245fb5,
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
            limb0: 0x9faa546b2a239869bfed6f79,
            limb1: 0x89ab6604ae319466475f53a1,
            limb2: 0x4096dd8e37c3d3c,
        },
        r0a1: u288 {
            limb0: 0xf1054113b19fad3f7d7cc26e,
            limb1: 0x70a6e1ba828f9a3c797d924c,
            limb2: 0x22dbaa5667b44387,
        },
        r1a0: u288 {
            limb0: 0x2478e5223ec4f24c172ef607,
            limb1: 0xf0a24ad523540cc0f5462942,
            limb2: 0xa8b348a7ab1439b,
        },
        r1a1: u288 {
            limb0: 0xcac07bec8f3f8332a160ab10,
            limb1: 0x1932c14a95e5d888ad2b1dc9,
            limb2: 0x2002396f2a473300,
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
            limb0: 0x233ee5518777cff794b4a2ac,
            limb1: 0x4f8f1ebb3d28f4f61705d304,
            limb2: 0x786e66fcf05361b,
        },
        r0a1: u288 {
            limb0: 0x6e0883c17dfd8dbc0e6ca11d,
            limb1: 0x1e214d869f69a74817b43d4c,
            limb2: 0x31540b0e8290eee,
        },
        r1a0: u288 {
            limb0: 0xe28b6adaf1f20a1eade34976,
            limb1: 0xa35dd89f17359c57d5df2e69,
            limb2: 0x8174b7044a73045,
        },
        r1a1: u288 {
            limb0: 0x337cd7bc7db87e089208293b,
            limb1: 0x6210eaa7d82107c3f606c94c,
            limb2: 0x160ecfa9d6e98fda,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x66f29cc3adf03d4cb9947683,
            limb1: 0x8c70a7f7f04e30aa42fa6fe1,
            limb2: 0x1851109847735c36,
        },
        r0a1: u288 {
            limb0: 0x2b35e1d19b3f1a8e96c5b360,
            limb1: 0x5bcd53a53547e98a29dd3930,
            limb2: 0x2310736474761d20,
        },
        r1a0: u288 {
            limb0: 0x5b0975ecff683d27bb1a0218,
            limb1: 0x1dee017e79c1e5368b0c2c52,
            limb2: 0x1019ebaabb323761,
        },
        r1a1: u288 {
            limb0: 0xce52b097a1819d9ee2080491,
            limb1: 0x75c009bceb1deef614d84bbb,
            limb2: 0x2e1104f44dd7830d,
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
            limb0: 0x133ee16596f75b60f45c4afa,
            limb1: 0x2d3a9473ea40b716a0f2fdf5,
            limb2: 0x2db2f5f7555e0ebd,
        },
        r0a1: u288 {
            limb0: 0xc011ad79333424daba018613,
            limb1: 0x5e362ac0186bb72bf09722e0,
            limb2: 0x1f83f91a818270f1,
        },
        r1a0: u288 {
            limb0: 0x264705f3178b143f8ffab4c0,
            limb1: 0xf569dae9e73b3a0b92547e8c,
            limb2: 0x15d0b62f5dfb9c3f,
        },
        r1a1: u288 {
            limb0: 0x8eb147a529f427c54a6334d4,
            limb1: 0xac38b37f57a1a71e0549fc0a,
            limb2: 0x17d36f281ec60e8d,
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
            limb0: 0xae1fe316c466d428cc381b6d,
            limb1: 0x69a45b6193c5fa975208007f,
            limb2: 0xfc554d921938e90,
        },
        r0a1: u288 {
            limb0: 0xcb2df4657a946959ced2f6ba,
            limb1: 0x5e935a7993954c7133ad5a5c,
            limb2: 0x2abb9c47d5d7b355,
        },
        r1a0: u288 {
            limb0: 0xb32bcf914aa86be3f0a1a219,
            limb1: 0xe92b0bd98444a5ff037de4fa,
            limb2: 0xf241af578e6c025,
        },
        r1a1: u288 {
            limb0: 0xe1d5d259c4312bfb92d37488,
            limb1: 0x45dbbf2f97be39c4955767cf,
            limb2: 0x1e3f4ad21535d6d6,
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
            limb0: 0x6266f88806ecfd9b7cbb445e,
            limb1: 0x69d24a22693394a1d21c2ec7,
            limb2: 0x2bbe2e0daa9432d4,
        },
        r0a1: u288 {
            limb0: 0xe04d834475eac1fa3d641824,
            limb1: 0xa4e167de5cb5db8b9e30b4fe,
            limb2: 0x9b0656b959fc7eb,
        },
        r1a0: u288 {
            limb0: 0x5f05851b40eb9d1e4b7e0934,
            limb1: 0xb9b30d23e74cd11bff94b96a,
            limb2: 0x18d14d55fe2d8e37,
        },
        r1a1: u288 {
            limb0: 0x78dea87b5bd65f1d6e1470d,
            limb1: 0xb5cbd7a4da1b445ef6794fd0,
            limb2: 0xf63a6352c61639f,
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
            limb0: 0x3bbe2a996e3f7a5a6bffd066,
            limb1: 0x767c0a589c26eac8324529e7,
            limb2: 0x1965cf2e56a8fb22,
        },
        r0a1: u288 {
            limb0: 0xb8ce6e434428ced526e70d04,
            limb1: 0x58cd3d41c7293d13f9977eb0,
            limb2: 0x2955f6201de36abe,
        },
        r1a0: u288 {
            limb0: 0x53553b23e32bd665255664be,
            limb1: 0xc5e9d0efeab56aad998c3674,
            limb2: 0x9eec3d81187043d,
        },
        r1a1: u288 {
            limb0: 0x34be092889e631e7ae2d0fbd,
            limb1: 0x4021da84ff0d19630634d0d7,
            limb2: 0x271afd1239c8e6ab,
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
            limb0: 0xf9e50e205efaebb0efbfc4d1,
            limb1: 0x2e00a12ed3d8a74e3bb6853b,
            limb2: 0x15c3ff2e5d07f934,
        },
        r0a1: u288 {
            limb0: 0x468cf24f7c21c25a4f2ff535,
            limb1: 0xcd205294ce3256f1bdd32844,
            limb2: 0x116170063ab20a29,
        },
        r1a0: u288 {
            limb0: 0x9e9827045fb370a9c795cf3c,
            limb1: 0xd6d5cbe1cb0223782d9ce888,
            limb2: 0x8b1e4efeb04133,
        },
        r1a1: u288 {
            limb0: 0x9e8ee120a79ac875288e6fdd,
            limb1: 0x3ee5a55f6a92853a665b90d,
            limb2: 0x920c97a7e4ecd44,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x295d13044699d7194c739975,
            limb1: 0xe511fdf2923dfac3903150b6,
            limb2: 0xf3e64448235cf30,
        },
        r0a1: u288 {
            limb0: 0xaa4ab2a7660c41732b445169,
            limb1: 0x96071e20e1c7a7d391be393a,
            limb2: 0x85b38fe98fcaf59,
        },
        r1a0: u288 {
            limb0: 0xd90de0d496d078c130110056,
            limb1: 0x12192b25de1063f5d0584e0d,
            limb2: 0xfadaa78740d3058,
        },
        r1a1: u288 {
            limb0: 0x1d5c3d9bba4eaf7bc2d82909,
            limb1: 0xa9c99fa30c3a9a73d451f681,
            limb2: 0x1dc9f539d3927681,
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
            limb0: 0x8684ad098d54447957e4ebfd,
            limb1: 0xe8438ac2844150bebf0ca333,
            limb2: 0x16a396f5bd1ea4b,
        },
        r0a1: u288 {
            limb0: 0x10be0a4968a141f544d24ab1,
            limb1: 0x50693b862a9d36daa9e225f9,
            limb2: 0x1f101053d10e7782,
        },
        r1a0: u288 {
            limb0: 0x94e3f032d4f361d2879eee3a,
            limb1: 0x8b577a79cea1ea2b671b34cc,
            limb2: 0x1f615c0d04a07842,
        },
        r1a1: u288 {
            limb0: 0x5398fa52d182331b0f8c0541,
            limb1: 0x5e6d9532aecadecfd00817d,
            limb2: 0x234bcaadb1b3b4d,
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
            limb0: 0xa57c2d2c133e2c1a9dc3088a,
            limb1: 0x27c846cf449dd153c93fe33,
            limb2: 0x2801f6c78a2db2e0,
        },
        r0a1: u288 {
            limb0: 0xa8aa7833d6f996bc1e5b917b,
            limb1: 0x1714a751b70d0dcd3ffbb6ec,
            limb2: 0x746dd4380838dcd,
        },
        r1a0: u288 {
            limb0: 0xa60c5934bd6fe02fb9ca972d,
            limb1: 0x8f279a09fbc24d8635e48599,
            limb2: 0x107228df3ff8360e,
        },
        r1a1: u288 {
            limb0: 0xae6a8521cd9ba2202ffa103d,
            limb1: 0xd7bd4db8cc09ad8f84c9d2a6,
            limb2: 0x3013bc9f8cc0f727,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x6ea67c5a897b45db2a1e56b0,
            limb1: 0xf66c3d6a404b8798067a8aa4,
            limb2: 0xecde4f7c54d2a01,
        },
        r0a1: u288 {
            limb0: 0xbba52b98d0e77963efaacd3b,
            limb1: 0xb39e8fd71447a073bd44595f,
            limb2: 0x4ac35bb381d0df,
        },
        r1a0: u288 {
            limb0: 0xff3ae6e15aa358cc9939f559,
            limb1: 0x901bb7f3e9060c2e10bba78b,
            limb2: 0x23de7f884e10ce77,
        },
        r1a1: u288 {
            limb0: 0xfd9d854d3e04386a685ef7c4,
            limb1: 0x97441315b225b25a75d4858c,
            limb2: 0x17ce0f967995ebdd,
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
            limb0: 0x35e845bd8a249aca72afea7e,
            limb1: 0xe3c90afd56f10c997602710,
            limb2: 0x108e1e8da95ff601,
        },
        r0a1: u288 {
            limb0: 0xcf48cc3dcdbbd9456f37dd11,
            limb1: 0x1da2b5ac864574dc318a543e,
            limb2: 0x23fc392a38e26b0d,
        },
        r1a0: u288 {
            limb0: 0x5b09d0de5c1480e5ae504b03,
            limb1: 0x6f4a05a9c2f058c2d06d53d8,
            limb2: 0x2095996cf7d9f273,
        },
        r1a1: u288 {
            limb0: 0x1860ce0e1c1f01ef8e7c9fe6,
            limb1: 0x31aef4a1aa3c6789cec7f541,
            limb2: 0x20f441f467ea044e,
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
            limb0: 0xa0be449f00f4e1d98233dd80,
            limb1: 0xa5e922f3afaad48371e4cf1,
            limb2: 0x121775b8f7b2da0b,
        },
        r0a1: u288 {
            limb0: 0x7f0d528b8a638631e3f32633,
            limb1: 0x145c4f4382668aa7da82f86a,
            limb2: 0x18dbf8311266d2e8,
        },
        r1a0: u288 {
            limb0: 0x93c9b0dc66c5eaf638cc3144,
            limb1: 0xf32a10b87a1fd9bba584cef9,
            limb2: 0xb444b1e0456c795,
        },
        r1a1: u288 {
            limb0: 0x40717c142e3d2d90b7e764e6,
            limb1: 0x416e9597d5492735ed01c501,
            limb2: 0xa0656164ef863f1,
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
            limb0: 0x13da48f400291dd9f9a41196,
            limb1: 0x9fb370cc59abfcaa58e0a692,
            limb2: 0x1fb9f9f5be3771e2,
        },
        r0a1: u288 {
            limb0: 0x21c14e52b3e6b8b5e3f31dfb,
            limb1: 0x524d71a31f52a183e8be3692,
            limb2: 0x2acac0bf86434ef8,
        },
        r1a0: u288 {
            limb0: 0x103d7510f16efe0936d9011f,
            limb1: 0x9d7a2d4936928116135b9cf6,
            limb2: 0x2be44e03f5d6e6aa,
        },
        r1a1: u288 {
            limb0: 0x54c7ea254effd645a666defc,
            limb1: 0xcd6b3a4a1bae3ea55b3a174,
            limb2: 0x180037443e0b95b1,
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
            limb0: 0x94a3c4168f6246bcc8c4d61f,
            limb1: 0x9c2b85b9c8c25190bd5a6b21,
            limb2: 0xdb8fbbd22668e21,
        },
        r0a1: u288 {
            limb0: 0x8fb760e585c2b07dee481641,
            limb1: 0x6c4480dacf4c8093ccfff7fd,
            limb2: 0x207c5188b8d8ef94,
        },
        r1a0: u288 {
            limb0: 0xeb7c0f35c3326ddee4b8f1f9,
            limb1: 0x5ba0719acb5e1b446984a627,
            limb2: 0x235c7b0a566f6111,
        },
        r1a1: u288 {
            limb0: 0x2bd0cd02555aa06713822251,
            limb1: 0x3f86860ef27bd77543189618,
            limb2: 0x1db8b0fb0ade3a69,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x78e96ee37c17ae1da9bc8517,
            limb1: 0x2616b30da427d96800f6743c,
            limb2: 0x20ca4df4faaf0e64,
        },
        r0a1: u288 {
            limb0: 0x56725e63d88934ad82812569,
            limb1: 0x91a5c458a9b8022c6c53f371,
            limb2: 0x80c76e7b3af316b,
        },
        r1a0: u288 {
            limb0: 0x516bf9262d767a02eeff1f8,
            limb1: 0x65687572c273dd673d48a708,
            limb2: 0x1b1af1396b016018,
        },
        r1a1: u288 {
            limb0: 0xd2055146099053be1990a34c,
            limb1: 0xfabbe2c2043e8589363449bf,
            limb2: 0x28ef571d81b12219,
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
            limb0: 0x6833c42728fbe05a6021f1d8,
            limb1: 0x99125506048a5caccf476f4,
            limb2: 0x2817535159dc33b3,
        },
        r0a1: u288 {
            limb0: 0x765d9a00fb84131df33242ab,
            limb1: 0x642b6ef4fdefbd8a733244a7,
            limb2: 0x20eaf477e0ba7a70,
        },
        r1a0: u288 {
            limb0: 0xa6f7d6835828c60fd7719177,
            limb1: 0xce2d38cfb99864dfd58e854a,
            limb2: 0x2d2d6bf7c63bf82e,
        },
        r1a1: u288 {
            limb0: 0xb3e666a88df1fd2e0eca6a26,
            limb1: 0xaaa7e8925e6fc950a4afba3b,
            limb2: 0xf43fb1add635eb3,
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
            limb0: 0x24585f86e9cb4cb275b5e923,
            limb1: 0xabae09d91a898a7b3c2bb37a,
            limb2: 0x233817f39d9894e9,
        },
        r0a1: u288 {
            limb0: 0x75f17cef7db405df677e56c6,
            limb1: 0xd398c9a420d3eeba4500de3d,
            limb2: 0x1437d0cb4929b842,
        },
        r1a0: u288 {
            limb0: 0xd036640fe300dfe776637777,
            limb1: 0x271b1682657abdd99e712fce,
            limb2: 0x1ca499e809143801,
        },
        r1a1: u288 {
            limb0: 0xd0d8345cb8adba565b3f6556,
            limb1: 0xef8bf65085696606c4b96414,
            limb2: 0x155715182724f9ea,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x2cbac94274feb12d34f245f6,
            limb1: 0xf030c8f40f1e450b5690d412,
            limb2: 0x153a274b946db1f2,
        },
        r0a1: u288 {
            limb0: 0x4100bddaeb85f243eac3aea4,
            limb1: 0xef99fdade16da6fbb67d3ee3,
            limb2: 0x1bc8d0d1e1c3e148,
        },
        r1a0: u288 {
            limb0: 0x741ebfd391058e145655bc8,
            limb1: 0x435719e35fb265d9b0fea2a9,
            limb2: 0x24724f7eaed0e8cd,
        },
        r1a1: u288 {
            limb0: 0x6a3ea17d0e81d317d8e8b990,
            limb1: 0x8db3a27c864c50402ac04ddd,
            limb2: 0x2dd06fdc81a3411d,
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
            limb0: 0x965a8c7c9002b4c2a9287ca2,
            limb1: 0x9937b6bdebd8ac55fb877b89,
            limb2: 0x2a29eb30c619b419,
        },
        r0a1: u288 {
            limb0: 0x175b5c8c4dbb5ecbd5a908a7,
            limb1: 0x16ebd3cda049a4ac80751d4d,
            limb2: 0x1f25b90baa36b94b,
        },
        r1a0: u288 {
            limb0: 0xba7f52bbb5dc9a1008a73f37,
            limb1: 0xa2d3db4fc251d43e2e02a7d9,
            limb2: 0x6684770531dc9d1,
        },
        r1a1: u288 {
            limb0: 0xef1a4658e8b5d6a47a68f607,
            limb1: 0x474042b7d8839d275b0225a8,
            limb2: 0xb12bb3931afaf13,
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
            limb0: 0x3eb404b3f621eea784398ab1,
            limb1: 0x85c9109ade744a7911773981,
            limb2: 0x1c0b489cd6494127,
        },
        r0a1: u288 {
            limb0: 0xf71531a2ddc10a1ba82b8a46,
            limb1: 0x33f26a1dc951c9efb7cb7069,
            limb2: 0xc4e53eece73160e,
        },
        r1a0: u288 {
            limb0: 0xf5d95ae5eb7d959e4a349d03,
            limb1: 0x929c349986046bd54e654bd5,
            limb2: 0x201b7d6ad892d7ae,
        },
        r1a1: u288 {
            limb0: 0x562b05f39ba139f7d4dcb396,
            limb1: 0x6b8f7a307129fc3f9ea85a54,
            limb2: 0x1e0fc214a1b685b1,
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
            limb0: 0xb76e0ea520b1f8eef724361c,
            limb1: 0xb504a1892237027765fe6e68,
            limb2: 0x144352578af06eb0,
        },
        r0a1: u288 {
            limb0: 0xd7caa3d48d3210d4f80ffa0b,
            limb1: 0xaf67505a262e055f99d2dafc,
            limb2: 0xcc8490b6503caf7,
        },
        r1a0: u288 {
            limb0: 0x9ce2d3a9357d46bd8cbe8e63,
            limb1: 0x9f8b48eeba4a3be20f4936fd,
            limb2: 0x6b351d3aaeb676d,
        },
        r1a1: u288 {
            limb0: 0xaba66f625c063b8ddbc840f2,
            limb1: 0xd1183d23c0d88cd3f9c02640,
            limb2: 0x2d4ee983582a8fdb,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x90acbd19f42559697ba8c633,
            limb1: 0x6b39d67c8b459f6446922102,
            limb2: 0xff01ff3e61e9e19,
        },
        r0a1: u288 {
            limb0: 0xbe1ef5a457a59c5dc03d6d8b,
            limb1: 0xb9b40099ed70d0264798b232,
            limb2: 0xdf2fa049e2d0e6f,
        },
        r1a0: u288 {
            limb0: 0xd28861c3d8168cda1336d8f4,
            limb1: 0x21722ec39686c0ae9ebff645,
            limb2: 0x23f2b78898a06c95,
        },
        r1a1: u288 {
            limb0: 0xdb789792769ff5ef541ee74,
            limb1: 0x4d62be3b4e6a11c4b3bc41c9,
            limb2: 0x1ada169aacb1cea4,
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
            limb0: 0x68cefa67cc62889bcc2350a7,
            limb1: 0x3a6d988604d6edeceb11711a,
            limb2: 0x14c7984bf7d80125,
        },
        r0a1: u288 {
            limb0: 0x74952b7b8f4cb80d78ce15f6,
            limb1: 0x84c693766a9cce8bef0df6c8,
            limb2: 0xa5117b5f8af5ea8,
        },
        r1a0: u288 {
            limb0: 0xe14d46dbfbe529b3107c61c4,
            limb1: 0x39f85131877ef9ca317f174f,
            limb2: 0x1a79ae8b088feff1,
        },
        r1a1: u288 {
            limb0: 0x7cf5e95d2f84941b3f7c367e,
            limb1: 0x9e85aed1fae387b4a6cb1d84,
            limb2: 0xe09ec2d33f9e8dc,
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
            limb0: 0x72297c5b4366aa384a64d144,
            limb1: 0x2d5faeb069982b176405a9f9,
            limb2: 0x1b46296d5f0cde2b,
        },
        r0a1: u288 {
            limb0: 0x93b417a1ad8297d8e24f7dbf,
            limb1: 0x61ea4fdc4b52e5dd48dd31db,
            limb2: 0x21388ab0bb981463,
        },
        r1a0: u288 {
            limb0: 0xae59a39ee27d3c234576084b,
            limb1: 0xfcd096cbafc09a821ee1b82e,
            limb2: 0x1e8b338219fde7f1,
        },
        r1a1: u288 {
            limb0: 0x2331e5c49fb6a607de54797a,
            limb1: 0x5fb25e6633411008825cae8b,
            limb2: 0x2662f8a343f38207,
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
            limb0: 0x1b84e1b2cf606b2b784eee17,
            limb1: 0x3d94dd1ac563434f3262f992,
            limb2: 0x2c0ce60151eee1,
        },
        r0a1: u288 {
            limb0: 0x2e5110ee12cfa0c8c0d1d986,
            limb1: 0x681316b06ba417151bab4f3d,
            limb2: 0x2395af8fb17317fe,
        },
        r1a0: u288 {
            limb0: 0xdc8274d9122d792b379afd0b,
            limb1: 0xfc8ed8c74f4580257c1f37a0,
            limb2: 0x226093249d4bd049,
        },
        r1a1: u288 {
            limb0: 0x48ab67418d67d031527bf09e,
            limb1: 0x3800f8d5c0fa0fcc5a977b12,
            limb2: 0x2f0540c024cad319,
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
            limb0: 0xbc15351d681fb693b17938b7,
            limb1: 0x5ca1023eacf1b2edbd17fa77,
            limb2: 0x2429d90ed88ca93a,
        },
        r0a1: u288 {
            limb0: 0x9c85577faf7120a5ca1121f4,
            limb1: 0xfb6eba58b82ecdb8df7caa55,
            limb2: 0x30563e808fc9627f,
        },
        r1a0: u288 {
            limb0: 0xec27f7e08cd8f7e77431014a,
            limb1: 0xfb61c9ceab8f11f20966e93a,
            limb2: 0xe8906e5a3fe15cd,
        },
        r1a1: u288 {
            limb0: 0x764d31ae2f3dbf8f81bc216b,
            limb1: 0x3bf97711965ee8a13473cd38,
            limb2: 0x8a1964fa91d3950,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x5eadfe1f40689ae5e7338eed,
            limb1: 0x9e3ce3a24788b06b5304c678,
            limb2: 0x9c2af79ae89a284,
        },
        r0a1: u288 {
            limb0: 0x35026a8f68cf58d682019d87,
            limb1: 0xa681aeb4a180a09123a1dfe6,
            limb2: 0x2324e9ff5de94851,
        },
        r1a0: u288 {
            limb0: 0x31b8f10db93275bcad11aba9,
            limb1: 0xa9d4705d946326f9e02a86a3,
            limb2: 0x28db25df0f9f70b8,
        },
        r1a1: u288 {
            limb0: 0xebd5c8e44b9c2959c28d28f2,
            limb1: 0x96af5eedb6b8f45b6d5a4b27,
            limb2: 0x2363d922b3513b98,
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
            limb0: 0x465538991d427cc4f9beec26,
            limb1: 0xdb74af067ce1a6606d536bb8,
            limb2: 0xcb0a1ba96151c07,
        },
        r0a1: u288 {
            limb0: 0x50f1e6d5b5208cc019d59161,
            limb1: 0x76286440e448ee5cae0fd3b4,
            limb2: 0x289bbdb0920b8822,
        },
        r1a0: u288 {
            limb0: 0x85af96281e548b46131734e7,
            limb1: 0x8f0e8d95f7e91bc95def871e,
            limb2: 0x17f1ac90ca64fe57,
        },
        r1a1: u288 {
            limb0: 0xe039236fba89b959320f5b6d,
            limb1: 0x840c2c96857476b73b869bd0,
            limb2: 0x19341bc9fe5bcaa0,
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
            limb0: 0x2c11141a4e1f5fa56052e552,
            limb1: 0xb5942d8b88a914fa738836a2,
            limb2: 0x29df46262ae2333f,
        },
        r0a1: u288 {
            limb0: 0x8cbf839c6554f1198d66a473,
            limb1: 0x7318495f7cf002b3a2b006a1,
            limb2: 0x25f4cd5b59a03e31,
        },
        r1a0: u288 {
            limb0: 0xc74594d0136963d31747ae0c,
            limb1: 0x5665ac40100d83dfea8457c9,
            limb2: 0xa0dad3015aa0231,
        },
        r1a1: u288 {
            limb0: 0xb94db8f1f7f0caece1617e73,
            limb1: 0x44e05463201c09aa7df2bf24,
            limb2: 0x141a10d5647ad32,
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
            limb0: 0xbf03933019d407d4509136a9,
            limb1: 0x1c9524d5f0ede9eab8dcd6bf,
            limb2: 0x20751114aab2364d,
        },
        r0a1: u288 {
            limb0: 0xb62b1a680c66d50128ca347c,
            limb1: 0x12476f01f03ac000ae40b916,
            limb2: 0x2f72f11353dda7e2,
        },
        r1a0: u288 {
            limb0: 0x30519116b66ed1b02659d6fa,
            limb1: 0x649cadf683a95b595a89f3cf,
            limb2: 0x3f84ff1dde43526,
        },
        r1a1: u288 {
            limb0: 0x9bd75fbe26dba380f025351f,
            limb1: 0x25b7f90282021b9044c8afab,
            limb2: 0x11e4494c2f344c67,
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
            limb0: 0xe294e0bfaf2f8d185673b23,
            limb1: 0x9513b48bd1372c0c7cd75b83,
            limb2: 0x2d397ab48e731962,
        },
        r0a1: u288 {
            limb0: 0x787015684cf63051c3e3a7c2,
            limb1: 0xa256d39d2969a64baf99a4ba,
            limb2: 0x2aca2557f05dfeb8,
        },
        r1a0: u288 {
            limb0: 0xfae0a0c54dfae58e773e2889,
            limb1: 0x1d197cd41d42b8d134556f61,
            limb2: 0x1c085780e4629b8b,
        },
        r1a1: u288 {
            limb0: 0x5259ad150d39a055f0d54bda,
            limb1: 0x361a02aba1b5ba159202288c,
            limb2: 0x2d49a0748742a5e7,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x8e139cd867920aa98e7e18d0,
            limb1: 0xd3e2712db1bd4f9b730f0475,
            limb2: 0x271c685c351e8923,
        },
        r0a1: u288 {
            limb0: 0x7c0345585c725d44743759fc,
            limb1: 0xb434235bfc3596ae91872f9,
            limb2: 0x126a745a1a66c1db,
        },
        r1a0: u288 {
            limb0: 0xd870ff6fe461500e0dd38edb,
            limb1: 0x3c1f9aa7bebf7544da03d724,
            limb2: 0x251ddcad26c8b622,
        },
        r1a1: u288 {
            limb0: 0x836b134e2558f0a885f3a097,
            limb1: 0x9d82e8a985b4f30983cac60e,
            limb2: 0x1e35f476b146ac53,
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
            limb0: 0x4b01ddba52ea35ca898768c6,
            limb1: 0xc6733c0cad9ae08354bef37d,
            limb2: 0xc33dff963ec136f,
        },
        r0a1: u288 {
            limb0: 0x4c3d1929109f583b63a6180f,
            limb1: 0x83a3587d2d00d22f81de3a1a,
            limb2: 0x2730aab5f91d0017,
        },
        r1a0: u288 {
            limb0: 0xd8729f4599c4c132af5cc17d,
            limb1: 0x99e009407055fd383c2fa11c,
            limb2: 0x12ed33a820b87d26,
        },
        r1a1: u288 {
            limb0: 0x100c09d6b9b72190b98f7946,
            limb1: 0xc55e7b36fd450552b8010292,
            limb2: 0x2235c30f76e81778,
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
            limb0: 0x3805c635de99ac02e31d9657,
            limb1: 0x9807255c95f45a48051e11f0,
            limb2: 0x2496bf9dc40dc8c5,
        },
        r0a1: u288 {
            limb0: 0x1218ef4aab4a31f4f740ceb5,
            limb1: 0x3a41883505d8aafe8d58c7dc,
            limb2: 0x4fcec50c6de7778,
        },
        r1a0: u288 {
            limb0: 0xa1b555661a4f7f9f4466e414,
            limb1: 0x300f8ca1ee2b56ab24ef3fb7,
            limb2: 0x10a3430d0ac54709,
        },
        r1a1: u288 {
            limb0: 0xafec94afa2fd9dc8f12906e4,
            limb1: 0xf64ed2218791c4b18208fc5,
            limb2: 0x15f77b68c27eae5e,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xa17ab4ad31d5838c211f844a,
            limb1: 0x2784ffdfc3ce596e858cb5a2,
            limb2: 0x8ae212398a0e179,
        },
        r0a1: u288 {
            limb0: 0xdf322478b7eb7bd5addfdd5d,
            limb1: 0x64bdfb8cc71bd337fbd5675,
            limb2: 0x2e3a1aec58ae6a22,
        },
        r1a0: u288 {
            limb0: 0xcf33c6ffc77d6ec09728d952,
            limb1: 0xe880ffceecd5413cb84ac73a,
            limb2: 0x1064f84ab6c03497,
        },
        r1a1: u288 {
            limb0: 0x3393e07710a13a62e27eb41d,
            limb1: 0x3fcf5a1df0d728bae0536452,
            limb2: 0x21673e57ebdc0b58,
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
            limb0: 0x53fdca0a98a36a56a681244,
            limb1: 0x7d5ed6b0beb10b7a83635144,
            limb2: 0x25bfd010d0aeba4,
        },
        r0a1: u288 {
            limb0: 0x27b43dd5e1ef9829b397c561,
            limb1: 0xd077db91c6db420e1bb3d7cf,
            limb2: 0x21ee741cb6855b8a,
        },
        r1a0: u288 {
            limb0: 0x54e346de1668454e4b6dcfe7,
            limb1: 0x9626074301068a915e56c0da,
            limb2: 0x2a73935b5e18e42,
        },
        r1a1: u288 {
            limb0: 0x35f52fce61aa4acc9705be14,
            limb1: 0x1dabc207a065df2dbd81cd83,
            limb2: 0xb51ac89b2603ca3,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x65efebeba61143905cddfa44,
            limb1: 0x5315437bfd21f490f8b7c3f8,
            limb2: 0xea7c1b6ff31098b,
        },
        r0a1: u288 {
            limb0: 0x4f14865d9075fa81aa8866de,
            limb1: 0x412e24f18f643e3c34456ddf,
            limb2: 0x92c69042151211f,
        },
        r1a0: u288 {
            limb0: 0x5d27509a55c66cebf584552,
            limb1: 0x3cc7d8906d72a00ebd8c4eea,
            limb2: 0x3bc31eba2a6fb63,
        },
        r1a1: u288 {
            limb0: 0x1b7f45e5dca78c4b0b0eaa33,
            limb1: 0xf9c4e8d346dcaa9a75049565,
            limb2: 0x152bd4ddeb3680f2,
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
            limb0: 0xb17dc3d87cf6f464616c1131,
            limb1: 0x611f05c767a5126c3817ff0b,
            limb2: 0xa87e8881545b0c1,
        },
        r0a1: u288 {
            limb0: 0xfa7258062da597c2378a8ce1,
            limb1: 0x496a2fb453956efb9901dda4,
            limb2: 0x2566f983f9dc9fcc,
        },
        r1a0: u288 {
            limb0: 0xeee773ec2d64cb933f81c552,
            limb1: 0x63a67b180e85cdbf39a39f64,
            limb2: 0x1cafba0785ed7056,
        },
        r1a1: u288 {
            limb0: 0x1c3d266a1b958d955bd41bde,
            limb1: 0xddfe7aabd9d878614b255a4e,
            limb2: 0xbba71aeb3a6042b,
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
            limb0: 0xb74553ccbc416a13bf7dc3e6,
            limb1: 0x4248870ddbfec32311428695,
            limb2: 0x142ba11d19592ff1,
        },
        r0a1: u288 {
            limb0: 0xae8e23fd520f17634e694426,
            limb1: 0x33f3b4ce7050ab9bb81064d1,
            limb2: 0x18dfa969769e3b4b,
        },
        r1a0: u288 {
            limb0: 0x4d655b4e470c9f21be542b5d,
            limb1: 0x7a41b88b8050bc4959c3db7b,
            limb2: 0x1e4b047617f6dea6,
        },
        r1a1: u288 {
            limb0: 0x2d6410f65c24be32d0425aed,
            limb1: 0xbc01696a7abe2aba37f3e04b,
            limb2: 0x1624e0ef5917d819,
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
            limb0: 0x39c71a7ed2c00170a69e8bb9,
            limb1: 0x27c720ff17a0a723d5d12cfe,
            limb2: 0x6c5157e1f1b04e0,
        },
        r0a1: u288 {
            limb0: 0xc996056ff24961e20526927,
            limb1: 0x123972cac437bc19d6e34e9c,
            limb2: 0x1dd20c4f54712de5,
        },
        r1a0: u288 {
            limb0: 0xa563680d7ff9c1d09e2ca1b9,
            limb1: 0x654b264baa984d20884aa52f,
            limb2: 0x2033807e1b6907e5,
        },
        r1a1: u288 {
            limb0: 0x5279943ec8953d58cb80175e,
            limb1: 0x806d1e49c6a09503898a70e,
            limb2: 0x1c5b208d7a14183c,
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
            limb0: 0xdd803053f476eddc2bcfe2c1,
            limb1: 0xf59b9054503a3e4f571e60ef,
            limb2: 0x2531ffb3f2e71a7d,
        },
        r0a1: u288 {
            limb0: 0x1e04e37fc5c57662f683cd31,
            limb1: 0xb671b25bff150e16a7fbb535,
            limb2: 0x176a30912a35c494,
        },
        r1a0: u288 {
            limb0: 0x44bd9e4b8d52b40b261cb2e8,
            limb1: 0xc4cf5613e925fba909d983e3,
            limb2: 0x1465991e91331081,
        },
        r1a1: u288 {
            limb0: 0xffef66b431eba01a3d075683,
            limb1: 0x591dc3001a38ec505a8108d5,
            limb2: 0x5d67251283416db,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x643871979cd6fea37a1a3572,
            limb1: 0xce99b43c8fef7c8aec532cd7,
            limb2: 0x2ad28a76bbcfeae5,
        },
        r0a1: u288 {
            limb0: 0xb1c7b1c1e58671d05a743f89,
            limb1: 0x9a3cc5d6eaefd92d0190caa7,
            limb2: 0x2667a3418bcbe003,
        },
        r1a0: u288 {
            limb0: 0x6b92b2f269844bbc0f00ae80,
            limb1: 0x63bd9f4636e382e27c027c29,
            limb2: 0x8ea46e4f2f437f5,
        },
        r1a1: u288 {
            limb0: 0xdb6a4166bb18559dfd644c2a,
            limb1: 0x3c3b3980518aa4e90bd9b688,
            limb2: 0x2dba4fee22a2cf48,
        },
    },
];

