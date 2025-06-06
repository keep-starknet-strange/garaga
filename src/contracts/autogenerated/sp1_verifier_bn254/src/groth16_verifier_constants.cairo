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
            limb0: 0x777a63b327d736bffb0122ed,
            limb1: 0x2caf27354d28e4b8f83d3b76,
            limb2: 0x3ff41f4ba0c37fe,
            limb3: 0x0,
        },
        x1: u384 {
            limb0: 0xc020024521998269845f74e6,
            limb1: 0x21f01ecc9b46d236e0865e0c,
            limb2: 0x1cc7cb8de715675f,
            limb3: 0x0,
        },
        y0: u384 {
            limb0: 0x264a04499f7e2f6df690dd85,
            limb1: 0x909b4f1c3d80fcd6865afc4a,
            limb2: 0x17387b4b9cf03927,
            limb3: 0x0,
        },
        y1: u384 {
            limb0: 0xf614f4fd11b56b3c5e53c44c,
            limb1: 0xd19a3d72dcd590ac85a971de,
            limb2: 0x2ed3b19b5eb39db0,
            limb3: 0x0,
        },
    },
};

pub const ic: [G1Point; 3] = [
    G1Point {
        x: u384 {
            limb0: 0x33db734c451d28b58aa9758e,
            limb1: 0x4ea0a694cd3743ebf5247792,
            limb2: 0x26091e1cafb0ad8a,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0xefa65a3e782e7ba70b66690e,
            limb1: 0xca6fdb2690a124f8ce25489f,
            limb2: 0x9ff50a6b8b11c3,
            limb3: 0x0,
        },
    },
    G1Point {
        x: u384 {
            limb0: 0xec878755e537c1c48951fb4c,
            limb1: 0x2607c227d090cca750ed36c6,
            limb2: 0x61c3fd0fd3da25d,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x3e6119a212dd09eb51707219,
            limb1: 0xdf7b5c65eff0e107055e9a27,
            limb2: 0xfa17ae9c2033379,
            limb3: 0x0,
        },
    },
    G1Point {
        x: u384 {
            limb0: 0xa16028dee020634fd129e71c,
            limb1: 0x7fe0e0e2ead0b2ec4ffdec51,
            limb2: 0x4eab241388a7981,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0xca56b18d5544b0889a65c1f5,
            limb1: 0x2f0bdbf95cff83e03ea9e16f,
            limb2: 0x7236256d21c60d0,
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
            limb0: 0x7cbf2d97579849ed7f37f916,
            limb1: 0x7c7c7cabc0338914ae612207,
            limb2: 0x7f04129bafedc9a,
        },
        r0a1: u288 {
            limb0: 0x28db0f05530a21fac876cfe4,
            limb1: 0xb08060f001e32bf0f4beff7a,
            limb2: 0x1758a3c93ad8f055,
        },
        r1a0: u288 {
            limb0: 0x53ad64ec102823f3f1d3fd30,
            limb1: 0xe512e2de1e37f60219c44720,
            limb2: 0xb05a57aa94413c8,
        },
        r1a1: u288 {
            limb0: 0x3c6bb091ccdadd1f42045694,
            limb1: 0x5756eeec096f1de96f136d22,
            limb2: 0xe9421367ecf6d7f,
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
            limb0: 0xebb29cf5e488422959450431,
            limb1: 0x3bd3c90ac14dcf48e9204889,
            limb2: 0x28740d492632c38f,
        },
        r0a1: u288 {
            limb0: 0x3f96bb87e9166a1c10062d63,
            limb1: 0x7cfe4c67f9e2c6ca2c26b17,
            limb2: 0x190baaa9a658afd4,
        },
        r1a0: u288 {
            limb0: 0x14c465a12bf86822e6a90017,
            limb1: 0xd33d62d86349625b7dbd2371,
            limb2: 0x255ea8f837ed8c60,
        },
        r1a1: u288 {
            limb0: 0x2c0619fb6f45aef79678a6b3,
            limb1: 0x60f956ca78123a74286dfd6f,
            limb2: 0x21d02d3c626232aa,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xc6a50211bb4e98f1dbcc18c6,
            limb1: 0x9847d0e53a837fae823cd4ea,
            limb2: 0x2082a2a015765ee3,
        },
        r0a1: u288 {
            limb0: 0x24ae565e25a79ee1ea39d033,
            limb1: 0x2faeb8128c16d60a0efbf2a8,
            limb2: 0x2be4069bfaeb9e80,
        },
        r1a0: u288 {
            limb0: 0xed15a9b34ed7444c70f2da29,
            limb1: 0x9aad3ebe8a77d1b9f448c5e4,
            limb2: 0x2ccac3d2f5842673,
        },
        r1a1: u288 {
            limb0: 0xaeba508ff18253293d75a9fb,
            limb1: 0xefc547444d7e210113d1126f,
            limb2: 0x15d5770504f94de3,
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
            limb0: 0x938f40d6331d337cd5a78483,
            limb1: 0xfb9bf9696fc566e9277e3562,
            limb2: 0x178c9caed033670a,
        },
        r0a1: u288 {
            limb0: 0x1868c526c195826f2926a360,
            limb1: 0x7c87ae606c93c769e7dc805f,
            limb2: 0xbaf9f3e4b922406,
        },
        r1a0: u288 {
            limb0: 0xf0324176663d80d726a6a17,
            limb1: 0x2687269fb7f21bd83428ced1,
            limb2: 0x2c8b67dc6eaacc68,
        },
        r1a1: u288 {
            limb0: 0xecb58d4301481dcffc13975d,
            limb1: 0x12c9ac3eaf1828a708993570,
            limb2: 0x295e2d4bbfdf162b,
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
            limb0: 0x42b739265325a48fbafa90d8,
            limb1: 0xcaaca7c05543af71af550508,
            limb2: 0xaf2a71170a857a3,
        },
        r0a1: u288 {
            limb0: 0x83dba88a49375b3088ec56ed,
            limb1: 0xf0b67f36f46fc663eecd11f0,
            limb2: 0x61b8dea2acb984b,
        },
        r1a0: u288 {
            limb0: 0x55990d74b22baae47fb0fdaf,
            limb1: 0x9562f464f486bfae1e003333,
            limb2: 0x1508b9aaa2d992ed,
        },
        r1a1: u288 {
            limb0: 0xb0f384299f76ba205b8aaae0,
            limb1: 0x59c4180e94d72106043ddd38,
            limb2: 0x26fb9897974b52b5,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x4a713c06f87eec4f6c8f84d1,
            limb1: 0x57504d3d02142f561546fc52,
            limb2: 0x25dafbc904cc0af3,
        },
        r0a1: u288 {
            limb0: 0x86db774a383a67fe84821fe0,
            limb1: 0xeca958da5742fbbfd64eb68d,
            limb2: 0x13675c605dc3d55c,
        },
        r1a0: u288 {
            limb0: 0x679f0a0f3c17bd7394a8834d,
            limb1: 0xef1b109621da0a27bd87799d,
            limb2: 0xc7ce67ca683f6f8,
        },
        r1a1: u288 {
            limb0: 0x50ad632be82adc7cca6edc58,
            limb1: 0xf0470f4c78cd6f03c2bb1ed0,
            limb2: 0x26dff4d8c96ccdb0,
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
            limb0: 0xcac1344e8cb568214722a8c8,
            limb1: 0xc892d892267faeae62644b74,
            limb2: 0x2d89e403f6e30991,
        },
        r0a1: u288 {
            limb0: 0x48c9a2b7277986259bac47be,
            limb1: 0x6f8677a58151e08a08f490e5,
            limb2: 0x4edfbee8ff0719,
        },
        r1a0: u288 {
            limb0: 0x1d121ebf7a9fb2b1a77c2c48,
            limb1: 0x2a69c49d06a7830375bb91df,
            limb2: 0x10bd82bd6966042f,
        },
        r1a1: u288 {
            limb0: 0xacc263d42b87601b8d585974,
            limb1: 0xf45b7035591969a55d96f2e7,
            limb2: 0x27673d5868aed589,
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
            limb0: 0x68d34d439ae2c989972b1a0f,
            limb1: 0xf95d4027b5c73acfb60d525f,
            limb2: 0xeb6c23cd34d1aa6,
        },
        r0a1: u288 {
            limb0: 0xa4d59d3b671a81bf28b00065,
            limb1: 0x488f591820d610c9cee5ad2,
            limb2: 0xd3ad6058795bc4b,
        },
        r1a0: u288 {
            limb0: 0x1cda8ced3e8fcef708fd8d15,
            limb1: 0xc4eb263c073391531751a836,
            limb2: 0x1e277f8c09e04ee4,
        },
        r1a1: u288 {
            limb0: 0xa8ed44c840c2be958d1a4582,
            limb1: 0xc7752e9691f112d0ffa7b455,
            limb2: 0x1ac35e3d2a100323,
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
            limb0: 0x725e048159c543615bb84e6e,
            limb1: 0x45fbc1f38e142ccda443cd6,
            limb2: 0x2ab74aaac994b0dc,
        },
        r0a1: u288 {
            limb0: 0xab291908bb575acbab668ad1,
            limb1: 0xc942a48a949adf3f77abd94,
            limb2: 0xf5e7c6df6de7ffd,
        },
        r1a0: u288 {
            limb0: 0xaa885b0a29c1ec26fc8ecabc,
            limb1: 0xf497d575c19ed625b01fde30,
            limb2: 0x2e30b462f1cdccef,
        },
        r1a1: u288 {
            limb0: 0xaafdb72e153e37da9c9bedc8,
            limb1: 0xa7eb7720a5e8ac3b81d5cb86,
            limb2: 0x119a5d1009fc61c8,
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
            limb0: 0x9b8973e6a6608567ccd76366,
            limb1: 0x8a0b0ff16938e5e9d047a619,
            limb2: 0x2b77ff867bd8e680,
        },
        r0a1: u288 {
            limb0: 0xcb7418d320b301aabe4148da,
            limb1: 0x235198f24eec02e28695e10d,
            limb2: 0xa8301843558aa76,
        },
        r1a0: u288 {
            limb0: 0x5c829b7de1bd80457eabff96,
            limb1: 0x8a62cc6b40a204c85decd770,
            limb2: 0x242afd2ccfcfee9c,
        },
        r1a1: u288 {
            limb0: 0xcf929d2a26a49eba7aefc650,
            limb1: 0x9f0aecd693f8e14112325cbc,
            limb2: 0x2f80e551b8c656e5,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x811ea824acc13b51e0c97817,
            limb1: 0xde9eb6d50d2979e139a147e9,
            limb2: 0x3c30b8b0df3f74f,
        },
        r0a1: u288 {
            limb0: 0xd5d75a2f277774b60b1784d2,
            limb1: 0xfda6904cb620bf9443d8afd7,
            limb2: 0x217f45e35d37496d,
        },
        r1a0: u288 {
            limb0: 0x8fe90603c2f1b8e3a1d867d0,
            limb1: 0xa9a56b26cfe0b448eca62dec,
            limb2: 0x63b61231638b05a,
        },
        r1a1: u288 {
            limb0: 0xb13dd53df7a134f20fadc38,
            limb1: 0xdbca72fe038c93d61287c616,
            limb2: 0x2da092b4bd5d3c42,
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
            limb0: 0xfbe0193ec22b48fec5af2f7,
            limb1: 0x774b3f299076ff89c55c3d4a,
            limb2: 0x2205817196a5cce3,
        },
        r0a1: u288 {
            limb0: 0xcd9ec02cfbd2a3ee9a60e0bc,
            limb1: 0xdc96dde2fc513b87c71ff1b7,
            limb2: 0x1cd732208e302df2,
        },
        r1a0: u288 {
            limb0: 0x2c9d6c58dffd69e8847fddea,
            limb1: 0x7758ea015f811fa25d88afad,
            limb2: 0x15d123eaba763b4d,
        },
        r1a1: u288 {
            limb0: 0xe98b3872ba65f4177b7b71b2,
            limb1: 0xf707fe02014d268ff63c196d,
            limb2: 0xb09a8f9c30f805b,
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
            limb0: 0x5de94d9644e370b354056a2a,
            limb1: 0xffa4b4e6caa341c06532adf9,
            limb2: 0x19a1fdd66cb0bea4,
        },
        r0a1: u288 {
            limb0: 0x8c4cb8999e50edcc5d79d10f,
            limb1: 0x38fd66d18df30b9270c237b8,
            limb2: 0x1d2989db26ed77e8,
        },
        r1a0: u288 {
            limb0: 0xbd0c585ef9c4c363feaf733a,
            limb1: 0x4a9788e4b097b387a2e3d25d,
            limb2: 0x71d26c1ddac58a0,
        },
        r1a1: u288 {
            limb0: 0xde8ea360f082230cba2c3d58,
            limb1: 0xf5d295a2e8fc6776a2c38b60,
            limb2: 0x1d99e0b44328228a,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xa14926bd3ee473b50fe5aaee,
            limb1: 0x113fd7acdfcbf4b4dcd52ea1,
            limb2: 0x69a24cbf370e857,
        },
        r0a1: u288 {
            limb0: 0x3609ea680e1899336a162b3d,
            limb1: 0x66238105b2124b799337961e,
            limb2: 0x147fb45ccd95134e,
        },
        r1a0: u288 {
            limb0: 0xb2d55d56c185a82ac9281057,
            limb1: 0xc2faa7fcfd3a124169486c63,
            limb2: 0x19db77c344303fba,
        },
        r1a1: u288 {
            limb0: 0x2f0bb0d515012a5ead2ef5b9,
            limb1: 0xc016838fa0925fca09eaf0c2,
            limb2: 0x2dd347070a684eb0,
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
            limb0: 0xde26507b6464c2b2432946d3,
            limb1: 0xccdae412f5efda9224b487a6,
            limb2: 0x7397099c18bb017,
        },
        r0a1: u288 {
            limb0: 0x113302c7ec8ed33f4a2336c6,
            limb1: 0xb076f9a40642c67e9dcca121,
            limb2: 0x27758b6b6267b249,
        },
        r1a0: u288 {
            limb0: 0x1d108f0331b13db2d7cd219f,
            limb1: 0x167a01313f068dd4f63ff09c,
            limb2: 0x203d41b179e2ede8,
        },
        r1a1: u288 {
            limb0: 0xce04948c084e9702a349ed11,
            limb1: 0xe4644eb462d7ad1d68bfc0d9,
            limb2: 0x7c5ae799b65a74d,
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
            limb0: 0xce283994615e4036d5f9b3ce,
            limb1: 0xe0bdc04bf896427f10bfde51,
            limb2: 0xf5d867b4bca046f,
        },
        r0a1: u288 {
            limb0: 0xf0b527e39a718a6c10415ace,
            limb1: 0xe6369ae45b67558e1c4b4d3c,
            limb2: 0x26bc24d2eadac885,
        },
        r1a0: u288 {
            limb0: 0xc9ad80732ebb2fce8f00a80b,
            limb1: 0x5d4753fedb0e9bfd7c0b1f6,
            limb2: 0x14b268ac1c4382d7,
        },
        r1a1: u288 {
            limb0: 0xce27cc14afec384c81c7dcd0,
            limb1: 0x1f3a4716b45fd52cdeb157d3,
            limb2: 0x244aca1db91a1f0d,
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
            limb0: 0xbf8efa0f44277ab5e9811cb4,
            limb1: 0x4f4a912383fe29ef4fac6d85,
            limb2: 0xb13f577a181edf2,
        },
        r0a1: u288 {
            limb0: 0x7caea92119bc1aa87d1a4022,
            limb1: 0xc3c61eb32a1ae87fedc32db6,
            limb2: 0x1ebce60883c9ce51,
        },
        r1a0: u288 {
            limb0: 0x637e0775ea61e20fb0e8a12a,
            limb1: 0x6f35385f1e29a52311ff082e,
            limb2: 0xb29b15c3c57992,
        },
        r1a1: u288 {
            limb0: 0x82c37125ed664f16c787c2a8,
            limb1: 0xa65fedf5e8c9d952f8cff058,
            limb2: 0xcc492d0f6b348b6,
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
            limb0: 0xc47d4ada891776f3e6e116e1,
            limb1: 0x6c80dc5afdcfc02145df53f6,
            limb2: 0x4c8414aac1b0395,
        },
        r0a1: u288 {
            limb0: 0xd484d52c85030a07343929a1,
            limb1: 0x75a6f09394f911d4959f189f,
            limb2: 0x2ba0a456ad7d89ff,
        },
        r1a0: u288 {
            limb0: 0xa8f4cf37f64451a7fe1fef82,
            limb1: 0x6388ae9a93882e4ff2e54b34,
            limb2: 0x1629c6ff16173284,
        },
        r1a1: u288 {
            limb0: 0x320367a73ffab79d59ffe89a,
            limb1: 0x37f82ff751295fe21521991d,
            limb2: 0x789f87edf2e3df9,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xbca9043533f559077d2eba79,
            limb1: 0x13fef9825c761d5bddbcf07d,
            limb2: 0x1195674e328c72c9,
        },
        r0a1: u288 {
            limb0: 0xdcb16742336d127fd7d8f824,
            limb1: 0x2cdf6a68d632f5c1b44867cd,
            limb2: 0xac06da12d262554,
        },
        r1a0: u288 {
            limb0: 0xedb983ba4e8f497c45b6dbc2,
            limb1: 0x6aa30e035c6f5c55622b1e40,
            limb2: 0x11dd74de83ecbd9f,
        },
        r1a1: u288 {
            limb0: 0x407935653afae88cfc4fc70c,
            limb1: 0x15ecf74f65948447d9f436a3,
            limb2: 0x2b6ba90989e359ee,
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
            limb0: 0x3c6f6125152a1dfb641aff97,
            limb1: 0x91361d513d1da420fa8b4c53,
            limb2: 0x25fff9ec836eb501,
        },
        r0a1: u288 {
            limb0: 0xb9ca876c8f91a90bd03aa49a,
            limb1: 0x41e027306cc4eb305bdf98ee,
            limb2: 0x2dc58f6baf41e472,
        },
        r1a0: u288 {
            limb0: 0x6db773b8ac0547e309d8cc94,
            limb1: 0x95a943a2523fc74c7b3ce15e,
            limb2: 0x7f19fee8893e3ec,
        },
        r1a1: u288 {
            limb0: 0xec01c36f2fb8eaaef1f45122,
            limb1: 0x8408305b35600377713d0e1f,
            limb2: 0xb36c5a3f958f2a7,
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
            limb0: 0xd0676b34291facf89d33679e,
            limb1: 0x81b00356cfb982eec3ce4d10,
            limb2: 0x15f2b090fcb75ad5,
        },
        r0a1: u288 {
            limb0: 0x8e17b4ac5fc26b6b8c70d1d0,
            limb1: 0x61ddfc96918011fbbfb6bd96,
            limb2: 0x1e66b984c4cd0579,
        },
        r1a0: u288 {
            limb0: 0x3cfd9855bd21f16929977c4c,
            limb1: 0x61d8356887fe36bc306ba57c,
            limb2: 0x2d05307f879d4032,
        },
        r1a1: u288 {
            limb0: 0x1484c8392195ac794e9abca7,
            limb1: 0x7f1d5ac422740092bcd9e169,
            limb2: 0x293919abeef84688,
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
            limb0: 0x9dca870c1484810a661f59d4,
            limb1: 0xadff34db27fd944111f8a6b1,
            limb2: 0x2f04571e7b81b9c4,
        },
        r0a1: u288 {
            limb0: 0xd9a94da685de3ff292c308a1,
            limb1: 0x1b9b7392d48239e525d06701,
            limb2: 0x2ba482e60ec17938,
        },
        r1a0: u288 {
            limb0: 0xdb0def301197ce2ffb78a2d0,
            limb1: 0x3dc46153ace29b10df2e46f5,
            limb2: 0xc85daa61e3e1093,
        },
        r1a1: u288 {
            limb0: 0xc36a99960a6ef0154c914b17,
            limb1: 0x141f0194a483fc78645ba557,
            limb2: 0x34a9ad3ff55fdca,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x61f660445e3c332848ca8e,
            limb1: 0xc0f8425af6c6f01521dc84ce,
            limb2: 0xfd780cc97d031fd,
        },
        r0a1: u288 {
            limb0: 0xe4f5496cb0df45f8f814ead5,
            limb1: 0x2c15fb46d6f9109a2e6bff16,
            limb2: 0x1c51dd9b55467dec,
        },
        r1a0: u288 {
            limb0: 0xe9eb3a9743a5b7359666eba2,
            limb1: 0xef222d816cd87172c3011f61,
            limb2: 0x274bd1c75922a74,
        },
        r1a1: u288 {
            limb0: 0x10ac95e57548c36e16a880df,
            limb1: 0x18b4d558688aa4560774a76,
            limb2: 0x2a044b9949c906a5,
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
            limb0: 0xc06bfbec93c79c253ea70541,
            limb1: 0x5c5d3fe17a555e21f99e07ea,
            limb2: 0x17b4863826c54b28,
        },
        r0a1: u288 {
            limb0: 0x44dbf42a961eb2ec7d783e85,
            limb1: 0xa6a66651685162adcd51359c,
            limb2: 0x6cb177bd8315214,
        },
        r1a0: u288 {
            limb0: 0x80b82b2149a8d9b7ed9268fa,
            limb1: 0x62e408934939eda616b66100,
            limb2: 0xe958d23c6dae95b,
        },
        r1a1: u288 {
            limb0: 0xf1d9428436e2c6a8fd847202,
            limb1: 0x5e41926889922dfffc189c93,
            limb2: 0x13f574f2efbbee63,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x22008f8153092426a639c910,
            limb1: 0x7ec2db6c987ef1c20e5a8234,
            limb2: 0x1697f4ed7a5b552e,
        },
        r0a1: u288 {
            limb0: 0x704f56be0f50078b47ad9f6c,
            limb1: 0xdb08445bceca2122b9457041,
            limb2: 0x76a9dd645d1365b,
        },
        r1a0: u288 {
            limb0: 0x932e9e84d92176e5aedd41cc,
            limb1: 0x462304236b3c39af3a6c797b,
            limb2: 0x81a6316f1638b1c,
        },
        r1a1: u288 {
            limb0: 0xc15ec06106531c2b26a125f9,
            limb1: 0x8f5c088d3120f7dd67539762,
            limb2: 0x12424d7e9d4e628d,
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
            limb0: 0x6928ca64347d7c31671e2377,
            limb1: 0x2272be450aa84aa36df3365c,
            limb2: 0x2ca92615957b2fe0,
        },
        r0a1: u288 {
            limb0: 0x88c4ede7111d187969799eca,
            limb1: 0xcc81917803770e59700eb7f8,
            limb2: 0x5930cfc2846191,
        },
        r1a0: u288 {
            limb0: 0xafb165196b5d95e4fe136a4d,
            limb1: 0xc39d63ee112a9ccaa57134d4,
            limb2: 0x10dc932094831bbf,
        },
        r1a1: u288 {
            limb0: 0xf7de51ac5b8a92c5b4845450,
            limb1: 0x9f3d9c4f13a46001e07751f,
            limb2: 0x242facacc7e8f671,
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
            limb0: 0x7b4f91687570395170f4325a,
            limb1: 0x9296c0d69936b134492c0fbb,
            limb2: 0x7cb37912214e21d,
        },
        r0a1: u288 {
            limb0: 0x705f6482b8a7224e7254263e,
            limb1: 0x425d24e68239b8a49a2df34a,
            limb2: 0x2cb8ff7fc64712c3,
        },
        r1a0: u288 {
            limb0: 0xe77944a01d94bda00b92ca30,
            limb1: 0x9b4dac2f2032dd830f464e92,
            limb2: 0x1297033462697e3e,
        },
        r1a1: u288 {
            limb0: 0x7321500e3b68552ad9805a97,
            limb1: 0x3cac1d28317fe827c7707539,
            limb2: 0xe39933fb1acfd45,
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
            limb0: 0xfd7198d8b21c7b14a5a143d,
            limb1: 0x8cfa979dc7cb9fc44b348243,
            limb2: 0x63df00df9d13158,
        },
        r0a1: u288 {
            limb0: 0x6f0fce584dccf2bc6a2b7552,
            limb1: 0x1b140d497e17a65153b219a2,
            limb2: 0x10ce2826fd679062,
        },
        r1a0: u288 {
            limb0: 0x53e1e3344c706d1e560c5848,
            limb1: 0x2fa5fabbfc7c3a2615b2edbf,
            limb2: 0x16281a4a9dddf9a0,
        },
        r1a1: u288 {
            limb0: 0x66e7e5216001704b0e0cf4b5,
            limb1: 0xa7bf2855a1a1d4f010d62c,
            limb2: 0x2e81a3b58efb5b08,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x4e69b18988e940ef04764973,
            limb1: 0x1359ec39c9bfbf237b166375,
            limb2: 0x210592c1052c27c4,
        },
        r0a1: u288 {
            limb0: 0x96ff351bb35e280c44fdff2,
            limb1: 0x17cde5251799ae4c9022bf5d,
            limb2: 0x27db21da13d1b0f1,
        },
        r1a0: u288 {
            limb0: 0x4491b38fa37fdd7f6044b9e9,
            limb1: 0x75b95dbf3d52c45e79c49bd,
            limb2: 0x2f3d051a55a02089,
        },
        r1a1: u288 {
            limb0: 0xaacb5301c0579fc0d0fd11f6,
            limb1: 0xa5a84b967b1bc3836f19eb3e,
            limb2: 0x119eb30fec7d8cf2,
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
            limb0: 0x8d47b10c98dad29569e9ddea,
            limb1: 0xb64d4b555fe1f7efc7bfbb27,
            limb2: 0x5f15cd7b11de5c9,
        },
        r0a1: u288 {
            limb0: 0xc2de52b36d1b7805208b5e05,
            limb1: 0x8f26ade6ec9af59c5c53bce3,
            limb2: 0x10d8927ecd55e636,
        },
        r1a0: u288 {
            limb0: 0xb284f891bdbbe56c8cd8b1df,
            limb1: 0x561c9fd87f0c37ff58a351d8,
            limb2: 0xe724a52a68b9517,
        },
        r1a1: u288 {
            limb0: 0xc0dd13ed0ff288dc9d2a6b09,
            limb1: 0x134704230fe887e73929097d,
            limb2: 0x1357c0d4f1c13f2a,
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
            limb0: 0x2db454bb8a3ad67349a0fbf3,
            limb1: 0x602d5a16aa797251acc2cefa,
            limb2: 0x375d59376b3a7f9,
        },
        r0a1: u288 {
            limb0: 0x5878afce6b152e235c5f6903,
            limb1: 0x90ef180ae111c1f2c33f005a,
            limb2: 0x13ffb21961cc2f98,
        },
        r1a0: u288 {
            limb0: 0xefc6feb49cef1713c1b90d99,
            limb1: 0x9d88fa75495a84c8fc058292,
            limb2: 0xe600d88bc38add5,
        },
        r1a1: u288 {
            limb0: 0x21b0fbb2002056263f11d13a,
            limb1: 0x8818f85658929c2a3fc48ce8,
            limb2: 0xa5f20f85c67e36f,
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
            limb0: 0xc10f4c88a98b0d61d708002e,
            limb1: 0x4ac3d70224f191b0e0d2853a,
            limb2: 0x1fa4ccc4d95b80c6,
        },
        r0a1: u288 {
            limb0: 0x17236a7e35ee2ab3b4f06f07,
            limb1: 0xf35f3bd072613ded87027ae0,
            limb2: 0x2101c31ea458ce27,
        },
        r1a0: u288 {
            limb0: 0x5bc8589aa3dd32a141953938,
            limb1: 0x9d90f13527d79e8e5acebcb0,
            limb2: 0x178688523ab3c6c0,
        },
        r1a1: u288 {
            limb0: 0xe90a7e5cf5d0984ee96bdde3,
            limb1: 0x29d8991e5e746709556196f9,
            limb2: 0x17f632c106ca4945,
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
            limb0: 0x12001d91db931ce66e88e1b6,
            limb1: 0x74e3d114c62a197de1ca3725,
            limb2: 0x268f10b41d839cb9,
        },
        r0a1: u288 {
            limb0: 0x37fa067815b37c30a270d0eb,
            limb1: 0xde1184e5735eed8c75c61138,
            limb2: 0x2e915a3aef5d480c,
        },
        r1a0: u288 {
            limb0: 0xa52e8ba088de9dad4ad62373,
            limb1: 0x144382b24e1957b51ef45581,
            limb2: 0x18ca358adc06316f,
        },
        r1a1: u288 {
            limb0: 0xf3a419830f1d63011c7d18fc,
            limb1: 0x69a8c6e679dae84b49ef21eb,
            limb2: 0x3002b7eaffec547f,
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
            limb0: 0xe417e1af22c27b08f77c9a24,
            limb1: 0xe9f25ac1fc093df8757d4423,
            limb2: 0x10cb27cc61842200,
        },
        r0a1: u288 {
            limb0: 0x95b53ca4e1a1e1b25b252a11,
            limb1: 0x5dbfc89db58efed8c8889fad,
            limb2: 0x2c1f157b89793de1,
        },
        r1a0: u288 {
            limb0: 0x5c365567188422646a2ce946,
            limb1: 0xd06ee3bc533f8050606b64b2,
            limb2: 0x10f2edab2c241eee,
        },
        r1a1: u288 {
            limb0: 0x929065a65c64cf7eb2724de0,
            limb1: 0xc6c085722c084f8086b9bf0,
            limb2: 0x9d2ef06935d37d9,
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
            limb0: 0xbb5cbeceb2f246e13d86b7e,
            limb1: 0xb8a224bd5eb5bf0ac661280d,
            limb2: 0x1f31873419815e8c,
        },
        r0a1: u288 {
            limb0: 0xd539fdf65481b6a1d5363447,
            limb1: 0xd45b0e4c8fd5912ff6acc054,
            limb2: 0x1ad52c09bbb45a6a,
        },
        r1a0: u288 {
            limb0: 0x18c54bae51814ad31a7637dc,
            limb1: 0x7399f2997ab65363f4b07657,
            limb2: 0x14ca110b944d53ee,
        },
        r1a1: u288 {
            limb0: 0xdf5b710c160fda77b78d1963,
            limb1: 0x5610ab09a6b6f9785b0d5e31,
            limb2: 0x2bd8363dac7d0d6d,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xb9a036825faa86e558ac3b7c,
            limb1: 0xde8e05942227a45439a04aba,
            limb2: 0x15e0173a1220d16f,
        },
        r0a1: u288 {
            limb0: 0x76187085a6d0013ddc40c1b7,
            limb1: 0xdfb11818eaa5468e457b1a66,
            limb2: 0x2caa10f9c375fdad,
        },
        r1a0: u288 {
            limb0: 0x947c4c0963d9d0f7879bdd6,
            limb1: 0x833b3e8ccc4dae2807240bac,
            limb2: 0xbd0a0ccace988f5,
        },
        r1a1: u288 {
            limb0: 0x5d05c4f7170655b9e64a98c9,
            limb1: 0xa96f0f8887a475547c9fb49d,
            limb2: 0xf5c467cc50f5ca8,
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
            limb0: 0x2439cf9215808554cb12e63b,
            limb1: 0x3c7e2319b82d818d33777496,
            limb2: 0xfecef34cf6a529a,
        },
        r0a1: u288 {
            limb0: 0xb9ebc2e1b201650cfe389c58,
            limb1: 0xdd5693c4da9af85799b6f077,
            limb2: 0x52803678bcf37d4,
        },
        r1a0: u288 {
            limb0: 0xb7a5621c2bfa839aec6bcda6,
            limb1: 0xfda43823873c0833aeb28bd6,
            limb2: 0xfb92522965f5d4d,
        },
        r1a1: u288 {
            limb0: 0x4ba0ec0f60464b07f207b70d,
            limb1: 0x6926f82ebb1480439708f64e,
            limb2: 0x1577548c5fc31c26,
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
            limb0: 0x35d6a47eb6e3946877b8faa4,
            limb1: 0x3226b4af47aefd8d27f573ce,
            limb2: 0xfc0eff6a2b8b60,
        },
        r0a1: u288 {
            limb0: 0xdd6a357e6537b879eeb96e5c,
            limb1: 0x5c1adf10968f6e6f920f4ed,
            limb2: 0x398dff2b4ff6d14,
        },
        r1a0: u288 {
            limb0: 0xd686f20c60c2d5e4bc95779c,
            limb1: 0x19250d0528a15c4610e5879b,
            limb2: 0x2fd84429a7cd5ce,
        },
        r1a1: u288 {
            limb0: 0xb6467442d2b7537c06de1ee1,
            limb1: 0xc638febd171b2a5fe230ba46,
            limb2: 0x130f3130328340b3,
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
            limb0: 0xc274e231d1af08db19d9587b,
            limb1: 0x835ea4ada618598e54401f91,
            limb2: 0xea45e2ca1303f7c,
        },
        r0a1: u288 {
            limb0: 0xc3db7f0268aea6734f3a6c08,
            limb1: 0x5a4a35f6f081ec00f9f82eb6,
            limb2: 0x132df163db52471d,
        },
        r1a0: u288 {
            limb0: 0x61dbd840ad68b3b9fac00f32,
            limb1: 0x86a31d757749fc9418afc019,
            limb2: 0x2ee9f85e4c10ad58,
        },
        r1a1: u288 {
            limb0: 0xf307238e66d8d61123d0c511,
            limb1: 0x9701297c75163ffce50e8dbb,
            limb2: 0x779fa2df58f46e4,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x6ddfe3fe6e09660af859f4fb,
            limb1: 0x7ee4d91145f672775128aa1e,
            limb2: 0x30039ee28acdda42,
        },
        r0a1: u288 {
            limb0: 0x3e6a40be2e258f27abaeac43,
            limb1: 0x13f1e6c56b5854c7873d5147,
            limb2: 0x25294aeee7c6f83c,
        },
        r1a0: u288 {
            limb0: 0xe24ce9b2af200251507b7ddc,
            limb1: 0xaa6119bab54437145b0ffb72,
            limb2: 0x723436cc5e0ba3f,
        },
        r1a1: u288 {
            limb0: 0x7423e1cd29046ca866701a4a,
            limb1: 0xde637f730d8996e4a46cf668,
            limb2: 0x2462acb26100a370,
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
            limb0: 0xe460e0022fd982dd65e52c43,
            limb1: 0xc3133a12d43813345194194a,
            limb2: 0x122345e30b232d2c,
        },
        r0a1: u288 {
            limb0: 0xb99c2ae2112a808f231ccfd5,
            limb1: 0x33a214c9658724f45321f3cb,
            limb2: 0x4b19649cd727708,
        },
        r1a0: u288 {
            limb0: 0x7679f8b3e3b1cb4437b82b6a,
            limb1: 0x6d58389da15334f63e2ef997,
            limb2: 0x21cbedc6cce1d5d1,
        },
        r1a1: u288 {
            limb0: 0x87ee5132496c29a159d1c039,
            limb1: 0x254b650562ef412646742be3,
            limb2: 0x272e27a277a60f1b,
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
            limb0: 0x4cd2646eabd4d5cff32052a6,
            limb1: 0x83d7e83c6f09aeefde86fc60,
            limb2: 0x1fc1e7c446ee815a,
        },
        r0a1: u288 {
            limb0: 0x3a1a9e52b334c520eb55ff6b,
            limb1: 0x20d356b0b9123715a827c7b,
            limb2: 0xa8f15019ec6f24b,
        },
        r1a0: u288 {
            limb0: 0x3562c1467de42a724ad3840d,
            limb1: 0xea424d9d7016d3203fda5249,
            limb2: 0x20d6afd1fb5725cd,
        },
        r1a1: u288 {
            limb0: 0x72cdbd431057bcb0623d79,
            limb1: 0x2a173bad85c78751480984dc,
            limb2: 0xc3f6e7bbb16c7ac,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xcc9b9f22372562a0913012cc,
            limb1: 0x4653a2ba5e6adf2aa8c3bdfc,
            limb2: 0x172d0e92a7ba9f75,
        },
        r0a1: u288 {
            limb0: 0x2dddd736f3f3bace91f4b424,
            limb1: 0xfd210f553d0f4aa73b3ff14c,
            limb2: 0x85f5ae434eac7ab,
        },
        r1a0: u288 {
            limb0: 0x8fe12ea5bbfc97bf316e3937,
            limb1: 0xf172bba1b5323c01413ff4a3,
            limb2: 0xbeebca688f99c40,
        },
        r1a1: u288 {
            limb0: 0xf95c55ffa6c4b017804f8324,
            limb1: 0xe6e3bb6dfaa2bd6e1da7766c,
            limb2: 0x136c1ff2a96eccab,
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
            limb0: 0xcaa6d4115cc70a8bbc8baf78,
            limb1: 0xbda798d59aad11d74f87989d,
            limb2: 0xc366e4f74f33072,
        },
        r0a1: u288 {
            limb0: 0xd148a96ac857a95fa9c98b72,
            limb1: 0x61012b08f12dc78ec4bece91,
            limb2: 0x2b97ec9eb164657f,
        },
        r1a0: u288 {
            limb0: 0x2dbd7565ab717dab4038b4b5,
            limb1: 0xe36861232766618a7949cd7d,
            limb2: 0x2689d0706676707e,
        },
        r1a1: u288 {
            limb0: 0x70f62db7654a24ab3cc7aa17,
            limb1: 0x760f6520439ffd75cefc2022,
            limb2: 0x1f1579d08acb1da,
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
            limb0: 0x5b9d278de289476b42c772c1,
            limb1: 0x5fc336c4466561dae92c0a7a,
            limb2: 0x22e43f58103642de,
        },
        r0a1: u288 {
            limb0: 0x614e554ee2047bd39ee9e569,
            limb1: 0x89f6a3f450e6ad4c75bf3b7c,
            limb2: 0x17f3f358f3208e2,
        },
        r1a0: u288 {
            limb0: 0xd6914fc96e46bb5166f2a8c7,
            limb1: 0x7ab0a8d25eb1ce99339eb4f3,
            limb2: 0x26d50123983410a5,
        },
        r1a1: u288 {
            limb0: 0x66f5a6fa34156df9ed454e7e,
            limb1: 0x8dea13b19d2b448228c489fe,
            limb2: 0x221b0f1b3cf1b5b0,
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
            limb0: 0x905277068fc2a9eaf4022c94,
            limb1: 0x484667d98d38e5a129e1e41,
            limb2: 0x1e555bb230565f19,
        },
        r0a1: u288 {
            limb0: 0xf91934891dadaf69ceb2783,
            limb1: 0x8d865e297806a5e7b924b2b0,
            limb2: 0x15f3c40b57125de6,
        },
        r1a0: u288 {
            limb0: 0x8ece4f147f09da0dd81f7bd9,
            limb1: 0x362f0e81d6c7c4a91a7d9c05,
            limb2: 0x12cb92de7484a836,
        },
        r1a1: u288 {
            limb0: 0x1b36ed01861dad86c8fe7719,
            limb1: 0xa0d402159346e6f0b467ad73,
            limb2: 0x3cdab1b7cf2b2b1,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xb3356ac66981416a87728e37,
            limb1: 0xf763adf54bfe038e4f3120cd,
            limb2: 0x128c2fb7ac0f6fdc,
        },
        r0a1: u288 {
            limb0: 0x16fdbb3373e3a04996380f4d,
            limb1: 0xa69f830696258682eacddd88,
            limb2: 0xece01e036560157,
        },
        r1a0: u288 {
            limb0: 0x7a7f4318f4415556a1d9704a,
            limb1: 0x36ed351a6cbff887d265d32d,
            limb2: 0xb467b7eb44b98d9,
        },
        r1a1: u288 {
            limb0: 0xed0a5e62d5d68a37e829b892,
            limb1: 0x791ec430bf872c680fd3aee9,
            limb2: 0x2b6dfd84fd2335e,
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
            limb0: 0x7d050d3f6b11d66c1d7938d3,
            limb1: 0x7c56af94f183f725117d86dd,
            limb2: 0x1a7dc5625ba0d800,
        },
        r0a1: u288 {
            limb0: 0x85c3d95f9bdb74dc2df32d60,
            limb1: 0x2ce48e3c8dfbfb4d4598bd15,
            limb2: 0x15d12571292df44f,
        },
        r1a0: u288 {
            limb0: 0xed4859f84410cebb78050aa,
            limb1: 0x19cc122e96cb959c7d8c9f9f,
            limb2: 0xf8236b851f0c821,
        },
        r1a1: u288 {
            limb0: 0x4c517c69569fcf0586fb8351,
            limb1: 0x7fe39e8e6a6fb9b4e7461cca,
            limb2: 0x2aa8100976400cca,
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
            limb0: 0x19a47ae9837b17ed7766dc46,
            limb1: 0x287abc763db12ac0b6d544e4,
            limb2: 0x2d924e29dde311b8,
        },
        r0a1: u288 {
            limb0: 0x7fb0ee7335115e02db2bfd2d,
            limb1: 0x8aba5ed4254d66ebbc36b1a7,
            limb2: 0x12e289ec35af915b,
        },
        r1a0: u288 {
            limb0: 0x1d5bda2d04c26274095e86ba,
            limb1: 0xa0403a6836764d9347154ac1,
            limb2: 0x1e6c670b3e18fdcd,
        },
        r1a1: u288 {
            limb0: 0x749725dd346d879ecd2ec6e9,
            limb1: 0x823aa726897471f6e984295a,
            limb2: 0x143d734b04f6993b,
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
            limb0: 0x3352ea0d65d65ebdd17519aa,
            limb1: 0x8b9da99137040f85a8864a04,
            limb2: 0xa372112cdf0a7c2,
        },
        r0a1: u288 {
            limb0: 0x5b96ba3359a8de70a5695d09,
            limb1: 0x7a097725a4c6f484a2766b2,
            limb2: 0x2a71ba7f8ded5c34,
        },
        r1a0: u288 {
            limb0: 0x761550b61d41fb97ebadae02,
            limb1: 0xe6829d1e928b580c3abbefa0,
            limb2: 0x46f25685bfc35a8,
        },
        r1a1: u288 {
            limb0: 0x2c25f70377990a68d8759910,
            limb1: 0x471894defdadfedf22c0bafb,
            limb2: 0x2ab4916c3bc05768,
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
            limb0: 0x8d8f24f69ae85e21e752729f,
            limb1: 0x4a35e040036039c8b7ca8b20,
            limb2: 0x7fecda8f0555a5f,
        },
        r0a1: u288 {
            limb0: 0xba227b6219fbafd98a0685c6,
            limb1: 0x5767306795e9ffe9dab73eb0,
            limb2: 0xcb264c99750f1af,
        },
        r1a0: u288 {
            limb0: 0x47b66cce1b80c3fe69fa1b2b,
            limb1: 0x6108b3a8db500ebc0c3effe1,
            limb2: 0x1973e255653c37fd,
        },
        r1a1: u288 {
            limb0: 0x9837f3fa5fed8ec21af731a1,
            limb1: 0x3ad9b937919f2a9068fab4f,
            limb2: 0x13db07c0d16823df,
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
            limb0: 0x4c3d4c9736611ed8fb1d9271,
            limb1: 0x1ad8304567218f83e6629715,
            limb2: 0x1e2998ef42e3bd93,
        },
        r0a1: u288 {
            limb0: 0x6058da5c0e33f3bb91f1ccdc,
            limb1: 0x85fd873aae33fd9827f11b70,
            limb2: 0x988a3b4c890f6ed,
        },
        r1a0: u288 {
            limb0: 0xcd745c1fa813f0f824992107,
            limb1: 0x41350289a79b1428b321549f,
            limb2: 0x18e8b3780c7e35b0,
        },
        r1a1: u288 {
            limb0: 0xea70ff019228aeef72c9e3fc,
            limb1: 0x4b003c67445395584152ba28,
            limb2: 0x13f07e9a64bf528e,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x4fa8f98d7bd0604e5d5b49c0,
            limb1: 0xfe9fc0738cfdf0d23a42711f,
            limb2: 0x1568a39cad4154c,
        },
        r0a1: u288 {
            limb0: 0x8471afa248283ad06c4db529,
            limb1: 0x9447b93c68733a150e76e5d0,
            limb2: 0x13b3b7131a3847ad,
        },
        r1a0: u288 {
            limb0: 0x9c866d6940a2068b8d87af80,
            limb1: 0x1470ea8951d66e29138578ed,
            limb2: 0x15a3f7cc0cba7976,
        },
        r1a1: u288 {
            limb0: 0x20066a7aec98ccd59adcabc,
            limb1: 0x865be6476878d559602a0b65,
            limb2: 0x22c7d2f27c5da091,
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
            limb0: 0x872323fa18de52d2b738cd1,
            limb1: 0x6a848834793291e5f134b761,
            limb2: 0x1419be04db8c1168,
        },
        r0a1: u288 {
            limb0: 0x80407871d8b9dd1778465b6,
            limb1: 0x2df09786d9e41dd2770f8848,
            limb2: 0x17daa86ff58088b8,
        },
        r1a0: u288 {
            limb0: 0x7d8a012d087be15cc7485f00,
            limb1: 0xc377bd58ce9c87034730c675,
            limb2: 0x1f5cb7e6d6c127a3,
        },
        r1a1: u288 {
            limb0: 0x5f5cb76761c71c418877f0da,
            limb1: 0x860abc859349f556b5d7ba6b,
            limb2: 0x14ae2383286f589e,
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
            limb0: 0x5be18af9475ec81c90435ea3,
            limb1: 0x572d85787941ccf2a06e8a85,
            limb2: 0x1d266e4c2bbec23d,
        },
        r0a1: u288 {
            limb0: 0x9abb04ade2ec32d45ad1e12e,
            limb1: 0x49001b1fe108f35c59463a58,
            limb2: 0x8d9758e803867dc,
        },
        r1a0: u288 {
            limb0: 0x6a6fc3406f463fab5c090723,
            limb1: 0xa5448526ae4526bffd1b66f9,
            limb2: 0x1f2fd6943b4af50c,
        },
        r1a1: u288 {
            limb0: 0xdefebeb5f133576a36ff1ec7,
            limb1: 0x3ac5b194dc32605f842a4ee4,
            limb2: 0x14dac2b182561bf1,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xb3f4a06dec84c0542fc584f3,
            limb1: 0x17dd8ec2b5040175db54f522,
            limb2: 0x1798d49900134630,
        },
        r0a1: u288 {
            limb0: 0x5804e0e6f05b2d114f8fc628,
            limb1: 0xcd413fa41667528622a63385,
            limb2: 0x1b2f6ee6c09efee2,
        },
        r1a0: u288 {
            limb0: 0x411cc5e5d5a9650eb8ab4151,
            limb1: 0x2578d1120f3a7491374cca05,
            limb2: 0xc7339e3f4da0dfc,
        },
        r1a1: u288 {
            limb0: 0xc5be52b91b24f9781785f0b6,
            limb1: 0x5a37f2d250cba3528432a971,
            limb2: 0x1e671b7e0f46542a,
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
            limb0: 0x9606a8fd4c578ad51c41d233,
            limb1: 0x2690e48ffb5f365373a1f091,
            limb2: 0xdd50bed38cb96c5,
        },
        r0a1: u288 {
            limb0: 0x63b3ed215339675ba0f1bf0e,
            limb1: 0xb6b4e56bce1950607175b381,
            limb2: 0x1c995e2e67d6ea05,
        },
        r1a0: u288 {
            limb0: 0x4fc66decf75dc3b1b5d8f7f6,
            limb1: 0x87158d4f7fd6a4a06ccf675a,
            limb2: 0xcc9b78c3687df9b,
        },
        r1a1: u288 {
            limb0: 0xd0606aae6c5defaa7213f850,
            limb1: 0x389176022636fccde16f423d,
            limb2: 0x6e06f2476a14caa,
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
            limb0: 0xb6c5442fe553f87d4f922a6d,
            limb1: 0xecb5da9f4f147b627dcdd817,
            limb2: 0x265099b47c79df0,
        },
        r0a1: u288 {
            limb0: 0x44d6aa0608f80fd2926679d1,
            limb1: 0xb0985b03442413e8c592e084,
            limb2: 0x2a27582793f6ec08,
        },
        r1a0: u288 {
            limb0: 0x9cb8bba4d80765686c460fb9,
            limb1: 0xca96945fb24c35d97e414e79,
            limb2: 0x2d579095df0481ae,
        },
        r1a1: u288 {
            limb0: 0x3cbb12a18adf878065bef682,
            limb1: 0xa80055f23c8cf9db20621287,
            limb2: 0x23166dcd4d1d60b8,
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
            limb0: 0x3e32a97160ba590f8477262a,
            limb1: 0x58f608cc4f024f332af3dc84,
            limb2: 0x2ea79ee82a69dca1,
        },
        r0a1: u288 {
            limb0: 0x769cbde6b95b9539f653a482,
            limb1: 0x8a97f58029c72cd2e8bd157b,
            limb2: 0x231881d71d090c10,
        },
        r1a0: u288 {
            limb0: 0x96ee714152f58446623381bc,
            limb1: 0x3420b725a86b137722463ae9,
            limb2: 0x1a1196cb42508616,
        },
        r1a1: u288 {
            limb0: 0xaa1685e2b271783a5ca3032b,
            limb1: 0xaaaefd9edd79d87a225f1981,
            limb2: 0x1bdcf987a5b8df95,
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
            limb0: 0xccc51c0b8c2b880bedb67e69,
            limb1: 0xe9f784ec67907a367b707a68,
            limb2: 0x1e35ff4c250d3874,
        },
        r0a1: u288 {
            limb0: 0xacd642ea141735c86a2632fd,
            limb1: 0x96f30bd849416ec9c2ba51d3,
            limb2: 0x5f80ff0bb5c3d3a,
        },
        r1a0: u288 {
            limb0: 0xdae6620b2dea1022c6b469d,
            limb1: 0x2dc227e830c6a53a0a25de16,
            limb2: 0x26419eb1ffc2ecc,
        },
        r1a1: u288 {
            limb0: 0x2a5f072722aa48f17e4e62e8,
            limb1: 0x5e2d84dc0619f32bf61069ea,
            limb2: 0x2a9c754f2c69c22f,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x2f21e0778a693efad56332f1,
            limb1: 0x5e0c280a34256b55cee88c6f,
            limb2: 0x193d0a513d46a271,
        },
        r0a1: u288 {
            limb0: 0xbd7e454376dd0af2d423917b,
            limb1: 0x360968bd4949aebffdb38b61,
            limb2: 0x272c13f48382cde5,
        },
        r1a0: u288 {
            limb0: 0xef13637247749cd7ed5af935,
            limb1: 0xa75937c16210e74805454829,
            limb2: 0x20c95f5b97f7c964,
        },
        r1a1: u288 {
            limb0: 0xd45ec00ea7d9b50619a68b06,
            limb1: 0xeceac81ee86a4441c708de28,
            limb2: 0x1171c3953d8cc236,
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
            limb0: 0xa8acc4cfbba1bf079026d2eb,
            limb1: 0x857c16b222c18dee6e550f0d,
            limb2: 0x485868d6e02d3da,
        },
        r0a1: u288 {
            limb0: 0xf9277c3cd01668e151c989d1,
            limb1: 0x96acc5c1180c14277e7e37ff,
            limb2: 0x1cc26eeaa7bef1e8,
        },
        r1a0: u288 {
            limb0: 0x8df631d1435e16921239d61c,
            limb1: 0xb6a0bfe28ec3ad068221088e,
            limb2: 0x1006ca3de092710c,
        },
        r1a1: u288 {
            limb0: 0x72e0bfa73d019b269033979b,
            limb1: 0xfa12478f48ea99607baf21ca,
            limb2: 0x2813a5311545749,
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
            limb0: 0xfe5ce198530e6e5e428ed7b2,
            limb1: 0xf5ddb0194d7a5e2c8ae0e004,
            limb2: 0x1ff33fa41a2219b8,
        },
        r0a1: u288 {
            limb0: 0xd40273c44e451086853d5c0c,
            limb1: 0x8196328a49b3e57f1aa97f3a,
            limb2: 0xa65be2b86cb6cc2,
        },
        r1a0: u288 {
            limb0: 0xee7e8e5603eb2987c03aad20,
            limb1: 0x8d1836c2944f14d62304e3ce,
            limb2: 0x23aec3995836284f,
        },
        r1a1: u288 {
            limb0: 0x44f63dede0bab74447432434,
            limb1: 0xbc242707481e3421608e7484,
            limb2: 0x12cbfde9472f6129,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x66e6518a789e643f2fe0adf8,
            limb1: 0x9e041475138e52b7d6ba273f,
            limb2: 0x29738d09b3c3aa2d,
        },
        r0a1: u288 {
            limb0: 0xd1953d4aaaccbb14a05ce666,
            limb1: 0xb6d92c0103e2eb840c035099,
            limb2: 0x163fbc494cd5fbd7,
        },
        r1a0: u288 {
            limb0: 0x8326000670635a008221d45c,
            limb1: 0xc68e2c1fde55cf6dea31ebf2,
            limb2: 0x112136de2bcb8814,
        },
        r1a1: u288 {
            limb0: 0xd91f410c6e215358b08e3761,
            limb1: 0x562ad42a0ab380ced5be614e,
            limb2: 0x2e6307ece4da28b7,
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
            limb0: 0xc119366343bb90cfbb6b9f59,
            limb1: 0xf0f4051e5e2ec1d270a24519,
            limb2: 0x20641b4fd703bcc3,
        },
        r0a1: u288 {
            limb0: 0x62c9da6fce0da9722dbdd4d,
            limb1: 0x9a55da1b4d9e1720ef695988,
            limb2: 0x27e055d89e9b5c22,
        },
        r1a0: u288 {
            limb0: 0x60b613aa5ffe7a0b312af762,
            limb1: 0xb6e419e3349fcd626b912362,
            limb2: 0x1e94385fbd0dabc1,
        },
        r1a1: u288 {
            limb0: 0x285da06db745c401161f5dbd,
            limb1: 0x1bac165aff4fc8fb01e05c73,
            limb2: 0xaf6d157ef87e3e8,
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
            limb0: 0x5d89d98abb1e14ee40991eb8,
            limb1: 0xd25c670d7cc0d9e15998c064,
            limb2: 0x2b88eb10af0a7936,
        },
        r0a1: u288 {
            limb0: 0xb0dbbad1655c7012f1443855,
            limb1: 0xba3c8a0898f276368f7de179,
            limb2: 0x13f1970118681271,
        },
        r1a0: u288 {
            limb0: 0xd5229b51e340a01bdf1597bb,
            limb1: 0xd083b17bb74a2d66e3fb7703,
            limb2: 0x1fb6b2e9b110b510,
        },
        r1a1: u288 {
            limb0: 0x7d5334985a52a20b9c42dba2,
            limb1: 0x43ce2272331ede659a1ff0ce,
            limb2: 0xc641156a71d87fd,
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
            limb0: 0x7754330fba8d9edd1fd085f1,
            limb1: 0x540da38cbcf9967f1643fa83,
            limb2: 0x10041a58b44d7033,
        },
        r0a1: u288 {
            limb0: 0xe61863c0b32f056dd86bff8f,
            limb1: 0x6f0906f4c8ec2c0bb1f2f8ac,
            limb2: 0x12c8eb56d7345658,
        },
        r1a0: u288 {
            limb0: 0x83db9f45eed4202ecff4be38,
            limb1: 0x7d4fb28ab7beedbd993663a9,
            limb2: 0x140bcf4fc3e627d5,
        },
        r1a1: u288 {
            limb0: 0x24bf73a83ec1526eba35c3a1,
            limb1: 0x49f611dd3e7158df3d710450,
            limb2: 0x46bfbe767839086,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x3a005fa4b568804c37599fab,
            limb1: 0x1dbc187d120e8654c667d416,
            limb2: 0x26f1a3ff5dedd43c,
        },
        r0a1: u288 {
            limb0: 0x9e3bbd13c68b59154325f840,
            limb1: 0x127142f3a8f8d48ac0ba0e8,
            limb2: 0x22114246f18dc553,
        },
        r1a0: u288 {
            limb0: 0xb0c427f7dc2ad19fae159a8d,
            limb1: 0x43cdfbe4e4688353690b625d,
            limb2: 0x11de9941593cdedf,
        },
        r1a1: u288 {
            limb0: 0x2bc192a0466c146b0f1a63c5,
            limb1: 0xa06ae4a5aeb9c79ff9605a68,
            limb2: 0x1c72897ef64ed3be,
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
            limb0: 0x2bea0074bb7f17895214c7d5,
            limb1: 0xbe6933bf702502fb784d01af,
            limb2: 0x6ee13677c0ad1fb,
        },
        r0a1: u288 {
            limb0: 0x7ba822d78fbb7499ec4a0bd5,
            limb1: 0xfd0ef51891aaf641c59ddff6,
            limb2: 0x7ea3e5374ce185e,
        },
        r1a0: u288 {
            limb0: 0xfa9c6c209da4cec9ff566b61,
            limb1: 0xf81313708ccdb696e83d4f2f,
            limb2: 0x1a188c142bfa4eea,
        },
        r1a1: u288 {
            limb0: 0xa2753b4de51c3790b55b4081,
            limb1: 0x770a5d6993f8efcfbef79cfe,
            limb2: 0xe66a0c0eb7f55d,
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
            limb0: 0x800f37efa40c0fe115a48c7,
            limb1: 0x4ee2180ba804ad1127a1032c,
            limb2: 0x8d02f7a21511b4d,
        },
        r0a1: u288 {
            limb0: 0x7732462537e4c83fbdf9e250,
            limb1: 0xf043e87195d99c09dfd19257,
            limb2: 0x13a5f2a36b471d20,
        },
        r1a0: u288 {
            limb0: 0x90a69629898539061531a3d4,
            limb1: 0xfb1bfbd5aafaa2bca4a7d88a,
            limb2: 0x4c80e61af9357b9,
        },
        r1a1: u288 {
            limb0: 0xa6bd67fe9bcb18eef3d498f5,
            limb1: 0xc9d9f001d0a22a8561f2a8f6,
            limb2: 0x2fc5dbc2e7f7bae1,
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
            limb0: 0x997c6c49f6cfe7b57ed6a795,
            limb1: 0x83f751adb017f8fe16cb1332,
            limb2: 0x421893391c31a08,
        },
        r0a1: u288 {
            limb0: 0x8881c1e22322290da9e0adda,
            limb1: 0xd279d9d315f84c72d3d7ca8d,
            limb2: 0x161e57b3c2bd69ca,
        },
        r1a0: u288 {
            limb0: 0x2a00b9a30f468603c234683d,
            limb1: 0x3335abc142f64cb623384c71,
            limb2: 0x247f21d5ac0ad015,
        },
        r1a1: u288 {
            limb0: 0x791eb4f0258d141246133ad8,
            limb1: 0x2e227e5de8c27b9270bf3679,
            limb2: 0x252ff1bf56426314,
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
            limb0: 0xae592cfc7284eace4317b38f,
            limb1: 0x41aa2fd0f201ea2488aae4cd,
            limb2: 0x2d7c9fa788a19387,
        },
        r0a1: u288 {
            limb0: 0x30fade520b7c5ad891fcd5e4,
            limb1: 0x726c4b2c0ab14b4824d6eb51,
            limb2: 0x2cbeb397ae3adbaf,
        },
        r1a0: u288 {
            limb0: 0x7754c7f9eb971c83580a6802,
            limb1: 0xc0501999d5fbbfecb742e62a,
            limb2: 0x2886be745478c5eb,
        },
        r1a1: u288 {
            limb0: 0xbbd01f31b4c7270f1874d615,
            limb1: 0x2860e90555449cc5557a6eeb,
            limb2: 0xaa8bcd043216ae0,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x1475f22439f945fe4f1866a4,
            limb1: 0x6093e054af08253105508201,
            limb2: 0x238fbceae0a52193,
        },
        r0a1: u288 {
            limb0: 0x37b706045af36f96f3de74bf,
            limb1: 0x42d8a96440085e5a0602ffc8,
            limb2: 0x301cf8ab791f87ec,
        },
        r1a0: u288 {
            limb0: 0x7dafe229ff600244975059d9,
            limb1: 0xc77f2c778fbc1edacf71ea1b,
            limb2: 0xfa04355fa70376b,
        },
        r1a1: u288 {
            limb0: 0x4b111cf6a84eadb0ea9697a4,
            limb1: 0x485179b0613471ed941c408f,
            limb2: 0x1c04e5e709a3ee73,
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
            limb0: 0x71a5b7371acb1f8a8e863a0f,
            limb1: 0xe160f090c89db8037b7b3270,
            limb2: 0x5dc19d479a9e0a1,
        },
        r0a1: u288 {
            limb0: 0x268283362f9eaa2b1bfc7d37,
            limb1: 0x41dd0a500b275c341fadfdd1,
            limb2: 0x58dc210e5db63b,
        },
        r1a0: u288 {
            limb0: 0x8c69e7aaedcd6f6d9bbb6eca,
            limb1: 0x9d2c3abb7be1d3e18bbbeea,
            limb2: 0x17821916435fc513,
        },
        r1a1: u288 {
            limb0: 0x12e15214b9ff3b0a87d02275,
            limb1: 0xec528ff80882d2613d62f7af,
            limb2: 0x21d7cb7981a2c8ee,
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
            limb0: 0x5a5b43c79c51930d0132f9e5,
            limb1: 0x84940e72e7f85b7410ad5959,
            limb2: 0x29ea8276c9dd2922,
        },
        r0a1: u288 {
            limb0: 0x564fad8093496ec0264503f9,
            limb1: 0x8087865cbf262c46af83e11,
            limb2: 0xfb4782ff8819bc3,
        },
        r1a0: u288 {
            limb0: 0xa14e0c681a92583584de7966,
            limb1: 0x9ee7630f508ee0abdbbf52de,
            limb2: 0x23502d641c894fe4,
        },
        r1a1: u288 {
            limb0: 0x45697b4bda8746aaefc84de6,
            limb1: 0xbbbb95bac5f667348485280b,
            limb2: 0x14d11f2f3b102ea0,
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
            limb0: 0xfd4ccd25ca5305b5a0c8f08c,
            limb1: 0x5c9ab754a0f97eba493b22cf,
            limb2: 0x1ee3d126af282430,
        },
        r0a1: u288 {
            limb0: 0x1650604310ad29b1ebe37a1c,
            limb1: 0xb8d6890fa276c5c89d0b87f6,
            limb2: 0x16187f2f98969294,
        },
        r1a0: u288 {
            limb0: 0x9adb39a172e4b1392fe50508,
            limb1: 0x32a5696a6e93a3cc6a5ad2ef,
            limb2: 0x3010f0bed371d9ab,
        },
        r1a1: u288 {
            limb0: 0x2178f739b0201a2f690222fb,
            limb1: 0xb1962d2f42010bff9c0acd0d,
            limb2: 0x12c651f9cff8bd2,
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
            limb0: 0xde53fa0e516e8521f9fd2218,
            limb1: 0xa8695dc7f4d9dc5cb20c5569,
            limb2: 0x26ae4f9889fdc9e9,
        },
        r0a1: u288 {
            limb0: 0x8ec99c1251e3701a92712d94,
            limb1: 0xd7a4e59134a81563dde18e00,
            limb2: 0x12abf32b5f5fd295,
        },
        r1a0: u288 {
            limb0: 0x3f40f6f544941079f98bbca1,
            limb1: 0x784e4af205d7ce81736a86e,
            limb2: 0x262955c2400f2cd9,
        },
        r1a1: u288 {
            limb0: 0xad09121aa67be24e2a15e358,
            limb1: 0xf372de521bb4645145104e80,
            limb2: 0x204386f0cc534dc1,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xb1a701becfac8ab4911bd3d5,
            limb1: 0x31059867e401e3c097e71713,
            limb2: 0x11f83ad520dbe146,
        },
        r0a1: u288 {
            limb0: 0x89c187f73b3df55369b5bf87,
            limb1: 0x55cbff5d865ed9eee13a53e7,
            limb2: 0xdc789be8b591928,
        },
        r1a0: u288 {
            limb0: 0x8fa833ccae2dee5a104910ab,
            limb1: 0x4f6d27d1caf11f4efaba2d99,
            limb2: 0x19a3a2baf9e9c654,
        },
        r1a1: u288 {
            limb0: 0x2cba57223327aaa86463ab7b,
            limb1: 0x8c542ad2a8acedbae2dbcaef,
            limb2: 0xc6cc1c26b074f93,
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
            limb0: 0x7502eb9d6e34d48c8d6bd674,
            limb1: 0x75a76de3d24ae67c74c25ab9,
            limb2: 0x269c5fbce67ef3f7,
        },
        r0a1: u288 {
            limb0: 0x18b64b67a0130324a775a54e,
            limb1: 0x510f1940ffe32b65eb777dbb,
            limb2: 0x1c67e2246d3e8b0e,
        },
        r1a0: u288 {
            limb0: 0x751b9c3f410b7b8cc2554028,
            limb1: 0xaa415e864cedc338dd4f93c5,
            limb2: 0x15b0cb160799f8b5,
        },
        r1a1: u288 {
            limb0: 0x431baa5aff5efafb3deb786d,
            limb1: 0x818f7f0c0cf08373d8497c20,
            limb2: 0x150266ce897a149b,
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
            limb0: 0x37b1d9f507e01f86b93547ea,
            limb1: 0x41ac3502f8b693b2f9ed1a29,
            limb2: 0x12d36862936402d,
        },
        r0a1: u288 {
            limb0: 0xaade7b42e239d7be07481e78,
            limb1: 0x3f8243ee7eb4a9c3b7cbb956,
            limb2: 0xaf29236a909acbb,
        },
        r1a0: u288 {
            limb0: 0xbfa7efb7457cc99dd4b66e37,
            limb1: 0x1aff3d917e026429380e9dc6,
            limb2: 0x87399bf2ca178f4,
        },
        r1a1: u288 {
            limb0: 0x351e9fa186b018907f3dfd58,
            limb1: 0x7027b103c6f3030eb6f019b0,
            limb2: 0x288a941ff1ef82c8,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x280d19be00a1fbb9ccaafb46,
            limb1: 0x4d694832b9452e3da1f121cd,
            limb2: 0x2a866c481e54b43e,
        },
        r0a1: u288 {
            limb0: 0x94acc4d34d73a6813c99def3,
            limb1: 0x2e9a78d89158c8144f4a163d,
            limb2: 0x6a7ba87130777b1,
        },
        r1a0: u288 {
            limb0: 0xa171b01ed37b9874fc4b2fd1,
            limb1: 0x644415f2fadd9f5572937ff,
            limb2: 0x188c19a6dbd348f6,
        },
        r1a1: u288 {
            limb0: 0xa8b807a7d82b4ca8813e6c16,
            limb1: 0xd36395399fea43c401b55926,
            limb2: 0x1ebe1e6668036172,
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
            limb0: 0x732b1d0e86389fae1b305692,
            limb1: 0x5e1ed01fae18aa2d2e501b89,
            limb2: 0x198dc823ba823f13,
        },
        r0a1: u288 {
            limb0: 0x395ecb34fbf15f7b72c54317,
            limb1: 0x19fb1bd9a5cabbf5eb248610,
            limb2: 0xb73bf1e6f4b2b31,
        },
        r1a0: u288 {
            limb0: 0x69471a9ea2a3b85c26c836d9,
            limb1: 0xe814a8008320f1fe43f51f0a,
            limb2: 0x2d0070077956b257,
        },
        r1a1: u288 {
            limb0: 0xc2ed008982c3b3a2381a1d13,
            limb1: 0x3aa758745a68a1c386ea1919,
            limb2: 0x1f719f31da901ffd,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xa773ff432f3fcb587a0ba2dd,
            limb1: 0xa72f6d2ad27b55412047c8a2,
            limb2: 0x196c95f5075736cc,
        },
        r0a1: u288 {
            limb0: 0x8d46b81c8d7815fb84f68477,
            limb1: 0x759aa3f94e1cbaff6069a0e0,
            limb2: 0x25349de9eb818c1b,
        },
        r1a0: u288 {
            limb0: 0x7e987a2cbb6794ba7ad8226b,
            limb1: 0x37b8b1d26e87ac1cc75bc768,
            limb2: 0x1b6594b5683fb78c,
        },
        r1a1: u288 {
            limb0: 0x6db02d761232580559059396,
            limb1: 0x4608f90f5be37fcf1ca05d00,
            limb2: 0x8280f225a44efb3,
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
            limb0: 0xeba6e51ec8e06f1a878b476b,
            limb1: 0xc701590aac4f7059ebebecc7,
            limb2: 0x178ad12f64b4cce0,
        },
        r0a1: u288 {
            limb0: 0xd26c1a0c4cd1c5e42e3b29b1,
            limb1: 0x344935f56b019eefc0ae9366,
            limb2: 0x2ac2051a8e04afa1,
        },
        r1a0: u288 {
            limb0: 0x5d6f37a0a446777c90c36deb,
            limb1: 0x2fb002f2be492ec5d334587f,
            limb2: 0x2300ad73e7a9475e,
        },
        r1a1: u288 {
            limb0: 0x579a05a596e27b546604bf72,
            limb1: 0x9062b97873327607c1e5fce4,
            limb2: 0x2d3543a9b5a8d09,
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
            limb0: 0xe64904238461826f7b9b6bd1,
            limb1: 0x7eef335c29c10b073c3c8df,
            limb2: 0x11ab7f696cecd13b,
        },
        r0a1: u288 {
            limb0: 0xa4ee9a0489ebf368f8d5b7df,
            limb1: 0xfc2fb710377d3a9b68d87438,
            limb2: 0xbb582e949e0b05c,
        },
        r1a0: u288 {
            limb0: 0x4942e63133bef00be3e86722,
            limb1: 0x159a6773262b5a5ffe915583,
            limb2: 0x26cb6b36d9d079a0,
        },
        r1a1: u288 {
            limb0: 0x923f51c6ac50ef980fc5c63e,
            limb1: 0x7431352b389608ee374cc6f7,
            limb2: 0x205d7212a2bb155f,
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
            limb0: 0xd1ef4e012e4ddec967871f0c,
            limb1: 0x73a1f0eaa41d3b58b2410cc5,
            limb2: 0x678a431a3208d78,
        },
        r0a1: u288 {
            limb0: 0x1182bff7a17bbcb072bce5d2,
            limb1: 0xe8d0894231092859c53b6a86,
            limb2: 0x2a8df47f9e66fa63,
        },
        r1a0: u288 {
            limb0: 0xef6ef9aa3976f4dd18917f5a,
            limb1: 0x544992409f5d8c72277c40a5,
            limb2: 0x269adf40fda899e9,
        },
        r1a1: u288 {
            limb0: 0x1272a877af1721f324764564,
            limb1: 0x9cfb207d93eef259ff85dd53,
            limb2: 0x1738f274efa92229,
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
            limb0: 0x3a0493f840a637df757ffbd,
            limb1: 0x78784ce2127de5ab9fd43f98,
            limb2: 0x404e6e7d65575af,
        },
        r0a1: u288 {
            limb0: 0x40a91253ff86fe1a9f30b23,
            limb1: 0x9876650a81d21ccadf7b5a47,
            limb2: 0x23641d1989cf0d22,
        },
        r1a0: u288 {
            limb0: 0xd686edf528c50fe4b5fc743d,
            limb1: 0xaff67da08ae2568924ba172c,
            limb2: 0x147e9121533c6431,
        },
        r1a1: u288 {
            limb0: 0xad80f0aa65056d5483a4ab44,
            limb1: 0x6e8e1992f62ad66fac7881b4,
            limb2: 0x24a28d1d5d8e8f3b,
        },
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xea1771c5a15aef9e3079786d,
            limb1: 0x77a90b139183352b680523a0,
            limb2: 0x232c100c95eae30e,
        },
        r0a1: u288 {
            limb0: 0x6b283b2e00ceee9181913d03,
            limb1: 0x977d294255416755d5596a3d,
            limb2: 0x25678644f6a5053d,
        },
        r1a0: u288 {
            limb0: 0xa543b526974a72bd42654bfb,
            limb1: 0xdf95c5b8a9328fc318d7b435,
            limb2: 0x161ef71b5e24d302,
        },
        r1a1: u288 {
            limb0: 0x7412e2b94a4551851b42cd3,
            limb1: 0xac25f9bbd0d7eb7e7789a8af,
            limb2: 0x26d86a5064526fcb,
        },
    },
];

