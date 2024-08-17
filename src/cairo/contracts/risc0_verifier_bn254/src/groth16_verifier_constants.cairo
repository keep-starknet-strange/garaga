use garaga::definitions::{G1Point, G2Point, E12D, G2Line, u384};
use garaga::groth16::Groth16VerifyingKey;

pub const N_PUBLIC_INPUTS: usize = 2;
pub const T: G1Point =
    G1Point {
        x: u384 {
            limb0: 0x2f9955915ce65268ff1ed16d,
            limb1: 0x129983c656dcc34861e3ab92,
            limb2: 0xd35b484f86c4839,
            limb3: 0x0
        },
        y: u384 {
            limb0: 0xaa111e3fea801dbbe3f45a3c,
            limb1: 0x147518d2b327735df2c2edc9,
            limb2: 0x1c749272bbb3145a,
            limb3: 0x0
        }
    }; // IC[0] + IC[1] * CONTROL_ROOT_0 + IC[2] * CONTROL_ROOT_1 + IC[5] * BN254_CONTROL_ID

pub const vk: Groth16VerifyingKey =
    Groth16VerifyingKey {
        alpha_beta_miller_loop_result: E12D {
            w0: u384 {
                limb0: 0x9dffd2a164e43cf462c03751,
                limb1: 0xbd9233d460c1d39f138fdd9c,
                limb2: 0x2645aefce7c56d6c,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0x5d61928eb5474083e3c7e566,
                limb1: 0x617f5199f19f822e0a8f2a60,
                limb2: 0x141ea4fba55775fa,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0x69929f68c57ca27f6cc6953b,
                limb1: 0x3ae55aeae6b922c90b69be78,
                limb2: 0x1f6e3ceda0dc2227,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0x212f2951f7c89e21060b9d78,
                limb1: 0xc366975b1cd009ee339a1ed6,
                limb2: 0x1d08b09656a5a043,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0x5f36c94193600e8234a52524,
                limb1: 0x94a010da891ca875384e68da,
                limb2: 0x11c15465527a13b3,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0x560783bfb9390fe62dee6364,
                limb1: 0x9571e65337f3e2673fcd7a2b,
                limb2: 0x754f7d1ac18b75a,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0xe9e19680c39a8aca6fa15f4,
                limb1: 0xc94ba0290a964c58f1400e45,
                limb2: 0x104bb1b78f934618,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0xf476c89caa4f12d6fee34421,
                limb1: 0xf9d2ee16198f72711cf0feac,
                limb2: 0x2100844da9e24497,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0x27e2288f84726985dea9706e,
                limb1: 0xa5882e06c097fd68c05fdd1f,
                limb2: 0x1a814cb6d1fa262,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0xc2973310d15982efb400898c,
                limb1: 0x719c8032da500dc898a60363,
                limb2: 0x3a0882da04bba7a,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0x588c6302c244b428b2cf5aa6,
                limb1: 0xe6208878e9ca68fa49960e71,
                limb2: 0xe328b63e1f95c3,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0x5b5e5ec6f28f1cfae9c7d29d,
                limb1: 0x96a48dfde0872d5eb21ce919,
                limb2: 0x2e430a046c424c80,
                limb3: 0x0
            }
        },
        gamma_g2: G2Point {
            x0: u384 {
                limb0: 0xf75edadd46debd5cd992f6ed,
                limb1: 0x426a00665e5c4479674322d4,
                limb2: 0x1800deef121f1e76,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x35a9e71297e485b7aef312c2,
                limb1: 0x7260bfb731fb5d25f1aa4933,
                limb2: 0x198e9393920d483a,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xc43d37b4ce6cc0166fa7daa,
                limb1: 0x4aab71808dcb408fe3d1e769,
                limb2: 0x12c85ea5db8c6deb,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x70b38ef355acdadcd122975b,
                limb1: 0xec9e99ad690c3395bc4b3133,
                limb2: 0x90689d0585ff075,
                limb3: 0x0
            }
        },
        delta_g2: G2Point {
            x0: u384 {
                limb0: 0x69cfaa4e60401fea7f3e0333,
                limb1: 0xd922dba0547057ccaae94b9d,
                limb2: 0x1aa085ff28179a12,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x2ccf0b4c91f42bb629f83a1c,
                limb1: 0x9bee94f1f5ef907157bda481,
                limb2: 0x3b03cd5effa95ac,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0x9e2fea1c7142df187d3fc6d3,
                limb1: 0x37e867178318832d0b2d74d5,
                limb2: 0x1e60f31fcbf757e8,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xfb7228ca5c91d2940d030762,
                limb1: 0xf6490846d518c9aea868366e,
                limb2: 0x110c10134f200b19,
                limb3: 0x0
            }
        }
    };

pub const ic: [
    G1Point
    ; 6] = [
    G1Point {
        x: u384 {
            limb0: 0x4d553505739d0f5d65dc3be4,
            limb1: 0x32a9061a082c15dd1d61aa9c,
            limb2: 0x12ac9a25dcd5e1a8,
            limb3: 0x0
        },
        y: u384 {
            limb0: 0xd30f3eee2b23c60ee980acd4,
            limb1: 0xd91731911c898569106ff5a2,
            limb2: 0x25aa744581ebe7a,
            limb3: 0x0
        }
    },
    G1Point {
        x: u384 {
            limb0: 0x4ccc3c8769d883f688a1423f,
            limb1: 0xf292fae2036e057be5429411,
            limb2: 0x707b920bc978c02,
            limb3: 0x0
        },
        y: u384 {
            limb0: 0xc203383782a4650787ff6642,
            limb1: 0xf7bc357bf63481acd2d55555,
            limb2: 0x2e32a094b7589554,
            limb3: 0x0
        }
    },
    G1Point {
        x: u384 {
            limb0: 0x48e336f4fd974644850fc347,
            limb1: 0x3e249751853f961511011c71,
            limb2: 0xbca36e2cbe6394b,
            limb3: 0x0
        },
        y: u384 {
            limb0: 0x6db8f7f409c153b1fcdf9b8b,
            limb1: 0x3729fa3d68714e2a8435d4fa,
            limb2: 0x2ede7c9acf48cf3a,
            limb3: 0x0
        }
    },
    G1Point {
        x: u384 {
            limb0: 0xe2c6b6fb5a25f9112e04f2a7,
            limb1: 0x7c091cc2aaf201e488cbacc3,
            limb2: 0x1b8af999dbfbb392,
            limb3: 0x0
        },
        y: u384 {
            limb0: 0x1a60157f3e9cf04f679cccd6,
            limb1: 0x5722949f192a81c850d586d8,
            limb2: 0x2b91a26aa92e1b6f,
            limb3: 0x0
        }
    },
    G1Point {
        x: u384 {
            limb0: 0x1dcefeddd06eda5a076ccd0d,
            limb1: 0x8ac1750bdfd5a7615f002d4a,
            limb2: 0x2b5f494ed674235b,
            limb3: 0x0
        },
        y: u384 {
            limb0: 0x8f14f912c5e71665b2ad5e82,
            limb1: 0xcbba817fcbb9a863b8a76ff8,
            limb2: 0x2fe520ad2020aab9,
            limb3: 0x0
        }
    },
    G1Point {
        x: u384 {
            limb0: 0x2fce3c25d5940320b1c4d493,
            limb1: 0x3666843cde4e82e869ba525,
            limb2: 0xf1c3c0d5d9da0fa,
            limb3: 0x0
        },
        y: u384 {
            limb0: 0x3608f68287aa01bd0b69e809,
            limb1: 0xfe8c0d07b307482d8bc8bb2f,
            limb2: 0x214bfcff74f425f6,
            limb3: 0x0
        }
    },
];


pub const precomputed_lines: [
    G2Line
    ; 176] = [
    G2Line {
        r0a0: u384 {
            limb0: 0x4d347301094edcbfa224d3d5,
            limb1: 0x98005e68cacde68a193b54e6,
            limb2: 0x237db2935c4432bc,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x6b4ba735fba44e801d415637,
            limb1: 0x707c3ec1809ae9bafafa05dd,
            limb2: 0x124077e14a7d826a,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x49a8dc1dd6e067932b6a7e0d,
            limb1: 0x7676d0000961488f8fbce033,
            limb2: 0x3b7178c857630da,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x98c81278efe1e96b86397652,
            limb1: 0xe3520b9dfa601ead6f0bf9cd,
            limb2: 0x2b17c2b12c26fdd0,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xc1a48e9e12ff1dbf61883912,
            limb1: 0xaee1724a5332ee74b8ed9451,
            limb2: 0xfbb1e993e3695f0,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x7acaee831d920baf2a1bfde0,
            limb1: 0x4cf9ef8c77ec7a0195bee19d,
            limb2: 0x25757a99d16aa21c,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xe5847602f3a9790bf049b947,
            limb1: 0x934e2813cdc5d033f879cf93,
            limb2: 0x21249e515f664d4c,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xf19496daaae3309c391d0383,
            limb1: 0x408eeae0c5d549305a377fd8,
            limb2: 0x21282298fede4ac4,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x1b3d578c32d1af5736582972,
            limb1: 0x204fe74db6b371d37e4615ab,
            limb2: 0xce69bdf84ed6d6d,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xfd262357407c3d96bb3ba710,
            limb1: 0x47d406f500e66ea29c8764b3,
            limb2: 0x1e23d69196b41dbf,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x1ec8ee6f65402483ad127f3a,
            limb1: 0x41d975b678200fce07c48a5e,
            limb2: 0x2cad36e65bbb6f4f,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xcfa9b8144c3ea2ab524386f5,
            limb1: 0xd4fe3a18872139b0287570c3,
            limb2: 0x54c8bc1b50aa258,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xb5ee22ba52a7ed0c533b7173,
            limb1: 0xbfa13123614ecf9c4853249b,
            limb2: 0x6567a7f6972b7bb,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xcf422f26ac76a450359f819e,
            limb1: 0xc42d7517ae6f59453eaf32c7,
            limb2: 0x899cb1e339f7582,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x9f287f4842d688d7afd9cd67,
            limb1: 0x30af75417670de33dfa95eda,
            limb2: 0x1121d4ca1c2cab36,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x7c4c55c27110f2c9a228f7d8,
            limb1: 0x8f14f6c3a2e2c9d74b347bfe,
            limb2: 0x83ef274ba7913a5,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xa6cd3bef29216e5776f4c435,
            limb1: 0x96ed36c2e4e69e8de93d63f,
            limb2: 0x20a92fd9a2fb0a39,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xeda6dc0a1e8e8067ae60ff67,
            limb1: 0x6b56562a0994de5c01c288f3,
            limb2: 0xaeed3d90fc6fe0d,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x82ed548a4877130ae8334400,
            limb1: 0x25021da2b3bb88299f079afd,
            limb2: 0xf3fb02181cb52dd,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x76dd33b2913d5b7a9f5ff9c4,
            limb1: 0x77c15ad5bbac0f2d3d49eab8,
            limb2: 0xf3c2bd9e2535565,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xf9c98b4467592a57fca1c44f,
            limb1: 0x22c8464befc62af74bd7e13e,
            limb2: 0xf6fe51a099cedd,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x424a207247f0e4c27f38a1ae,
            limb1: 0xc0d1158c6df8f6ffa8d6a76e,
            limb2: 0xe16f63bee6733e5,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x747d2a41af96d81fb2585f8f,
            limb1: 0x1bedd2f049ce086610aca319,
            limb2: 0x18e887f968ab29d1,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x6f6eae477c15633e163e3366,
            limb1: 0x3d0cca9a15ddc9f899d906bf,
            limb2: 0x1a5066113f22d767,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xfc23a674d089e9cfdefb1db8,
            limb1: 0x9ddfd61d289b65a9b4254476,
            limb2: 0x1e2f561324ef4447,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xf67a6a9e31f6975b220642ea,
            limb1: 0xccd852893796296e4d1ed330,
            limb2: 0x94ff1987d19b62,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x360c2a5aca59996d24cc1947,
            limb1: 0x66c2d7d0d176a3bc53f386e8,
            limb2: 0x2cfcc62a17fbeecb,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x2ddc73389dd9a9e34168d8a9,
            limb1: 0xae9afc57944748b835cbda0f,
            limb2: 0x12f0a1f8cf564067,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x963c90609635263045a730,
            limb1: 0x25987316828b8c528c8dc05b,
            limb2: 0x1a52af70953e2d93,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x5cb801def7d800e0a2dcdc65,
            limb1: 0x7f06086a5846b035d7144e65,
            limb2: 0x264229f1b248db7a,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x1c8fe795c6a55dfe7abf119e,
            limb1: 0x98b10fc53fdbfce11d7827a0,
            limb2: 0x13551fa74e7af913,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xdde6f69885b07fe44d932a52,
            limb1: 0x9819b585503c5540fa115b13,
            limb2: 0x1f4507e84f016add,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x9c963c4bdade6ce3d460b077,
            limb1: 0x1738311feefc76f565e34e8a,
            limb2: 0x1aae0d6c9e9888ad,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x9272581fdf80b045c9c3f0a,
            limb1: 0x3946807b0756e87666798edb,
            limb2: 0x2bf6eeda2d8be192,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x3e957661b35995552fb475de,
            limb1: 0xd8076fa48f93f09d8128a2a8,
            limb2: 0xb6f87c3f00a6fcf,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xcf17d6cd2101301246a8f264,
            limb1: 0x514d04ad989b91e697aa5a0e,
            limb2: 0x175f17bbd0ad1219,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x894bc18cc70ca1987e3b8f9f,
            limb1: 0xd4bfa535181f0f8659b063e3,
            limb2: 0x19168d524164f463,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x850ee8d0e9b58b82719a6e92,
            limb1: 0x9fc4eb75cbb027c137d48341,
            limb2: 0x2b2f8a383d944fa0,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x5451c8974a709483c2b07fbd,
            limb1: 0xd7e09837b8a2a3b78e7fe525,
            limb2: 0x347d96be5e7fa31,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x823f2ba2743ee254e4c18a1e,
            limb1: 0x6a61af5db035c443ed0f8172,
            limb2: 0x1e840eee275d1063,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x9cdb3f1da9cc795a6dd71925,
            limb1: 0xa6b72d99ea73e7ec479df7de,
            limb2: 0x2a0d16e5af0f972a,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x185981f7439b3abe06b2f010,
            limb1: 0x4afb801363c27041866471a0,
            limb2: 0x21a33b58bc0ebc30,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xd9c7c736ca2b67b6189ccfb9,
            limb1: 0x8dd913714e0c8c9468564883,
            limb2: 0x25e9300604680744,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xd2f83c58abf29fed21f8ac20,
            limb1: 0xf99df3b0aafc57db31256a85,
            limb2: 0x2ecdc1f4735da2e6,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x3890eaf1d657d63d18eac82d,
            limb1: 0x962ede9002cf9e7fead8ac71,
            limb2: 0xa41c746d7a471e2,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xdd8017fb853f2df76c7dad20,
            limb1: 0x8ee50f79d3a8abfd3ccd4c1a,
            limb2: 0x7f77df5036f64d2,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x251f40aedb747d8748c907aa,
            limb1: 0xaff11c216293b73b2d2a53aa,
            limb2: 0x2f94413282c71d76,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x255cffb680c8482747fe7934,
            limb1: 0xc9b47382882ce9a2171f615c,
            limb2: 0x1e12dbcbfacba1a9,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x18d630598e58bb5d0102b30e,
            limb1: 0x9767e27b02a8da37411a2787,
            limb2: 0x100a541662b9cd7c,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x4ca7313df2e168e7e5ea70,
            limb1: 0xd49cce6abd50b574f31c2d72,
            limb2: 0x78a2afbf72317e7,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x6d99388b0a1a67d6b48d87e0,
            limb1: 0x1d8711d321a193be3333bc68,
            limb2: 0x27e76de53a010ce1,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x77341bf4e1605e982fa50abd,
            limb1: 0xc5cf10db170b4feaaf5f8f1b,
            limb2: 0x762adef02274807,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x7645fffb343e10e1e8748cb8,
            limb1: 0xb7ee813d501408d841ec8e65,
            limb2: 0xe90c74a2dd6516e,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x1491337b6e2af58a979eff05,
            limb1: 0x41a56da5e78ec6d2aedcfb3c,
            limb2: 0x234444f637b1fd1a,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x7f6df98a0ef48fea6a90a86d,
            limb1: 0x67fe1fde059c8fcc5f4d2e06,
            limb2: 0x2ba05dbf310dbde7,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xa0c862d762e402c3454d02b2,
            limb1: 0x1b96d5c6695fe143c37a671e,
            limb2: 0x24af700c84c87b54,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xa137b991ba9048aee9fa0bc7,
            limb1: 0xf5433785c186cd1100ab6b80,
            limb2: 0xab519fd7cf8e7f9,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x90832f45d3398c60aa1a74e2,
            limb1: 0x17f7ac209532723f22a344b,
            limb2: 0x23db979f8481c5f,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x723b0e23c2808a5d1ea6b11d,
            limb1: 0x3030030d26411f84235c3af5,
            limb2: 0x122e78da5509eddb,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xf1718c1e21a9bc3ec822f319,
            limb1: 0xf5ee6dfa3bd3272b2f09f0c7,
            limb2: 0x5a29c1e27616b34,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x1af83b0d07aaec86d9134a28,
            limb1: 0x77bdb3e9aa87662797059a9c,
            limb2: 0x273c84364e3713d2,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xcaf5ba9785faf45cfc296a4a,
            limb1: 0x3163afd1009dbadd9c5a70bd,
            limb2: 0x1aaea45eb51c82ce,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x5aba52ae705ce1af25e673aa,
            limb1: 0x2dc8896c9ff279f6655024ef,
            limb2: 0x300f0500b7b0b0d3,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x67f1e1afa662ba8900d60c26,
            limb1: 0xf93114d70a2a3321729a7d2c,
            limb2: 0x1cc57b64b47a626d,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xbc1ede480873fceb8739511e,
            limb1: 0xd5a60533bd0ce7869efbc15,
            limb2: 0x182c17d793eba74d,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x83bf38d91876ad8999516bc2,
            limb1: 0x7756322ea3dc079289d51f2d,
            limb2: 0x1d0f6156a89a4244,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x6aba652f197be8f99707b88c,
            limb1: 0xbf94286c245794ea0f562f32,
            limb2: 0x25a358967a2ca81d,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xc028cbff48c01433e8b23568,
            limb1: 0xd2e791f5772ed43b056beba1,
            limb2: 0x83eb38dff4960e,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x5fa7b4cb5791e57c2cf9780e,
            limb1: 0xf5062eb2c532788091de2118,
            limb2: 0xc38262afe4f4eac,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x6560785dd69d5a9a4917aa3b,
            limb1: 0x6240334397d0134760854bb1,
            limb2: 0x2d7c0dd3e38d8926,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xf3c91f209577810e63cbdf2f,
            limb1: 0xa8acef680c1be04d12d702c8,
            limb2: 0xa312088d3b32c07,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x96aa4853754a05becdc1bf51,
            limb1: 0xa6cc53c2c1b1d383517e44b4,
            limb2: 0x1f03c17658e08a24,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xc2a2b787d8e718e81970db80,
            limb1: 0x5372abeaf56844dee60d6198,
            limb2: 0x131210153a2217d6,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x70421980313e09a8a0e5a82d,
            limb1: 0xf75ca1f68f4b8deafb1d3b48,
            limb2: 0x102113c9b6feb035,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x4654c11d73bda84873de9b86,
            limb1: 0xa67601bca2e595339833191a,
            limb2: 0x1c2b76e439adc8cc,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x9c53a48cc66c1f4d644105f2,
            limb1: 0xa17a18867557d96fb7c2f849,
            limb2: 0x1deb99799bd8b63a,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xc32026c56341297fa080790c,
            limb1: 0xe23ad2ff283399133533b31f,
            limb2: 0xa6860f5c968f7ad,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x2966cf259dc612c6a4d8957d,
            limb1: 0xfba87ea86054f3db5774a08f,
            limb2: 0xc73408b6a646780,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x6272ce5976d8eeba08f66b48,
            limb1: 0x7dfbd78fa06509604c0cec8d,
            limb2: 0x181ec0eaa6660e45,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x48af37c1a2343555fbf8a357,
            limb1: 0xa7b5e1e20e64d6a9a9ce8e61,
            limb2: 0x1147dcea39a47abd,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x489a41fc4c066a737acf2b80,
            limb1: 0x51199b4ef477e0976b9b663d,
            limb2: 0x104f756144a01a99,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xce50cee9668a849dfec24567,
            limb1: 0x932eabf096a077bd22814967,
            limb2: 0x16210f0edb8ae837,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xb1ea43eab76757bea3ee7e67,
            limb1: 0x859be02d0e28899de38a8bbb,
            limb2: 0x69978ccc2f4f110,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xdfe4fd2c66e7f65bd840d459,
            limb1: 0xf950d096dbee0e978b146cce,
            limb2: 0x2960c5fa3fb2a10,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xb58f6d75132f93ba48631e07,
            limb1: 0xe8ae893990c83c6e393d1303,
            limb2: 0x88809ba75ebe6c8,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xc3a2f92df3e3ae5fe1783de6,
            limb1: 0x2778c4ec8a8c11311a178bd,
            limb2: 0x24f1ee4b51cbf5fd,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xfbef4674342d73fb2363ab57,
            limb1: 0x840f6f7c0db4f93e82f3523,
            limb2: 0x1101e37593b6ed96,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xd263a20f18fd8a530227c627,
            limb1: 0x7bf28bc9f5fc2d0b2585cac4,
            limb2: 0x2e273774ae1e6e0c,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x4033c51e6e469818521cd2ae,
            limb1: 0xb71a4629a4696b2759f8e19e,
            limb2: 0x4f5744e29c1eb30,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xa4f47bbc60cb0649dca1c772,
            limb1: 0x835f427106f4a6b897c6cf23,
            limb2: 0x17ca6ea4855756bb,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x7f844a35c7eeadf511e67e57,
            limb1: 0x8bb54fb0b3688cac8860f10,
            limb2: 0x1c7258499a6bbebf,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x10d269c1779f96946e518246,
            limb1: 0xce6fcef6676d0dacd395dc1a,
            limb2: 0x2cf4c6ae1b55d87d,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x59726c9960acdae933f6c2e,
            limb1: 0xcb27824cfdc7f2a2953a7b46,
            limb2: 0xab09e310409c7dc,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xda7641d0a2b62e75f06e7a4b,
            limb1: 0xbdae979156600097567aeb5b,
            limb2: 0x2811e7f67e12b969,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x57d4f4acd0d896441365692d,
            limb1: 0x26d8fccbf118b66792fd5f15,
            limb2: 0x552fe6247735d8b,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x94b8e030cbd114193e677c50,
            limb1: 0x372b06a0c3c60fb7d11b850e,
            limb2: 0x16f002c5d6018b19,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xab74a6bae36b17b1d2cc1081,
            limb1: 0x904cf03d9d30b1fe9dc71374,
            limb2: 0x14ffdd55685b7d82,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x277f7180b7cf33feded1583c,
            limb1: 0xc029c3968a75b612303c4298,
            limb2: 0x20ef4ba03605cdc6,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xd5a7a27c1baba3791ab18957,
            limb1: 0x973730213d5d70d3e62d6db,
            limb2: 0x24ca121c566eb857,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x9f4c2dea0492f548ae7d9e93,
            limb1: 0xe584b6b251a5227c70c5188,
            limb2: 0x22bcecac2bd5e51b,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x340c82974f7221a53fc2f3ac,
            limb1: 0x7146f18cd591d423874996e7,
            limb2: 0xa6d154791056f46,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x70894ea6418890d53b5ee12a,
            limb1: 0x882290cb53b795b0e7c8c208,
            limb2: 0x1b5777dc18b2899b,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x99a0e528d582006a626206b6,
            limb1: 0xb1cf825d80e199c5c9c795b5,
            limb2: 0x2a97495b032f0542,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xc7cf5b455d6f3ba73debeba5,
            limb1: 0xbb0a01235687223b7b71d0e5,
            limb2: 0x250024ac44c35e3f,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x265d8d504786c9a9d2c2dd1d,
            limb1: 0xcddddab1a3af6fa901f267d3,
            limb2: 0x1d5b892bac643be1,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xd200f75804e773fd94a69bff,
            limb1: 0x5dcaa5c6bfcc08323700dd54,
            limb2: 0x3b045d584b9e34e,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x364fc9381fdcfc87f48025fd,
            limb1: 0x65d53f242d37bf7d6a422db4,
            limb2: 0x5fc799e0624fbc5,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x40494a8cfe5af05b211a65c8,
            limb1: 0x436bd2d7c12a4599cd65d28c,
            limb2: 0x14329c50f1378c82,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xa97c95148b4c5d08de3552aa,
            limb1: 0x74fd19a4764ed2db2b947c9b,
            limb2: 0x1f6645462132403f,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xcccb21d1679b6f037f5c6862,
            limb1: 0x3796ff849627eae6d1373566,
            limb2: 0xf569739c4b0bf20,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x3a69197d08132714a2d8cde9,
            limb1: 0xae3e914eb52fc9f866335adb,
            limb2: 0x22d97cabaecd8977,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x59a5a98b2a4b546d9fdf220d,
            limb1: 0x8158806a0c4d6fc1bfc00dac,
            limb2: 0x1e8455c351c421dc,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xccf841cf5c1cf8f4a0485e28,
            limb1: 0xb5077662d0ce9d755af1446b,
            limb2: 0x2b08658e9d5ba5cb,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x6ce62184a15685babd77f27f,
            limb1: 0x5ff9bb7d74505b0542578299,
            limb2: 0x7244563488bab2,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xec778048d344ac71275d961d,
            limb1: 0x1273984019753000ad890d33,
            limb2: 0x27c2855e60d361bd,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xa7a0071e22af2f3a79a12da,
            limb1: 0xc84a6fd41c20759ff6ff169a,
            limb2: 0x23e7ef2a308e49d1,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xd85b572f6e94368559bc9922,
            limb1: 0x806d660df4c09f298ca99a8c,
            limb2: 0xb5295ba1e28bea6,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x3309d566a80c2e9fe64a9417,
            limb1: 0x5cb56c0e22896cf7b425f4f3,
            limb2: 0x2194637a888395df,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x71882225419d48d5cdfd106f,
            limb1: 0x83e49ccde853b0d80d85954f,
            limb2: 0x95abeffbab1f6f1,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xa56f499db7c21d64a6f4cde4,
            limb1: 0xfa807931f439377fded2c667,
            limb2: 0x722a1ecfd5f676a,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x7105024c431a33683d9d0b9d,
            limb1: 0x12e23637b641ab0e5b322ad8,
            limb2: 0x2918e9e08c764c28,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x26384979d1f5417e451aeabf,
            limb1: 0xacfb499e362291d0b053bbf6,
            limb2: 0x2a6ad1a1f7b04ef6,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xba4db515be70c384080fc9f9,
            limb1: 0x5a983a6afa9cb830fa5b66e6,
            limb2: 0x8cc1fa494726a0c,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x59c9af9399ed004284eb6105,
            limb1: 0xef37f66b058b4c971d9c96b0,
            limb2: 0x2c1839afde65bafa,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x3b40bc013ebda1f6759eb1c5,
            limb1: 0x41b1c4994f7006c3bfc44225,
            limb2: 0x1104e881eeac0f26,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x1a0a3837d2925b22b29de16,
            limb1: 0x7f161412b67cb737308ee1e4,
            limb2: 0x2eca703d4f685eca,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x791ea927b5f79fedbd63a830,
            limb1: 0xa43daf5bad2feef86dc7c3e5,
            limb2: 0x11f25ca14404e535,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xf1b3aada072d4891b5de1aae,
            limb1: 0x2f78e8d48428027439b02564,
            limb2: 0x6a400f4c3b5b6fa,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x6bf13a27b0f4eb6657abc4b,
            limb1: 0xf78d57f089bffdf07c676bb3,
            limb2: 0x228e4aefbdd738df,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x4f41a40b04ec964619823053,
            limb1: 0xfa3fb44f4a80641a9bb3bc09,
            limb2: 0x29bf29a3d071ec4b,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x83823dcdff02bdc8a0e6aa03,
            limb1: 0x79ac92f113de29251cd73a98,
            limb2: 0x1ccdb791718d144,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xa074add9d066db9a2a6046b6,
            limb1: 0xef3a70034497456c7d001a5,
            limb2: 0x27d09562d815b4a6,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x3c8b4b05cbef623055ab9631,
            limb1: 0xa357807ba01b50955f01beb1,
            limb2: 0xd8e8272150b392,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xc69a03b91fd115f482bc7aa1,
            limb1: 0xa175d02bfd1daa28271cc421,
            limb2: 0x2c5e890fe1b00b05,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xe363626ab202f75cc610f018,
            limb1: 0x46e37dbd0719e9c1b4951c4a,
            limb2: 0x1873157667707b3f,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xd42f65f398d2c703199689b3,
            limb1: 0x39ec231de4b4bd3adf1feeee,
            limb2: 0x67fb3d358e060f0,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x87a44d343cc761056f4f2eae,
            limb1: 0x18016f16818253360d2c8adf,
            limb2: 0x1bcd5c6e597d735e,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x593d7444c376f6d69289660b,
            limb1: 0x1d6d97020b59cf2e4b38be4f,
            limb2: 0x17133b62617f63a7,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x88cac99869bb335ec9553a70,
            limb1: 0x95bcfa7f7c0b708b4d737afc,
            limb2: 0x1eec79b9db274c09,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xe465a53e9fe085eb58a6be75,
            limb1: 0x868e45cc13e7fd9d34e11839,
            limb2: 0x2b401ce0f05ee6bb,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x83f48fbac5c1b94486c2d037,
            limb1: 0xf95d9333449543de78c69e75,
            limb2: 0x7bca8163e842be7,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x60157b2ff6e4d737e2dac26b,
            limb1: 0x30ab91893fcf39d9dcf1b89,
            limb2: 0x29a58a02490d7f53,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x520f9cb580066bcf2ce872db,
            limb1: 0x24a6e42c185fd36abb66c4ba,
            limb2: 0x309b07583317a13,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x5a4c61efaa3d09a652c72471,
            limb1: 0xfcb2676d6aa28ca318519d2,
            limb2: 0x1405483699afa209,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xc208b17fbf164d6b7c4c87ef,
            limb1: 0xe5ef2141a5e0ed8d7880adc2,
            limb2: 0x1fbb587de0172d44,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x5ecc8bd2960195067936331e,
            limb1: 0x302d49c4538f5a4b41fffa,
            limb2: 0x2dd8166b425b4bdb,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x6dda8e93ab2dad36a7a26d98,
            limb1: 0x1a832cbd0bdfb31ca9670821,
            limb2: 0x5e16617c8f62852,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xf9cba326c8ccbf69a8c7f8fb,
            limb1: 0x6b295295947987bb33e9961b,
            limb2: 0x186db8004776c0ea,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x241ca305ac4ceab57c4bc375,
            limb1: 0xdada9084d8f73edb881a22fa,
            limb2: 0xd143f30c17c29c7,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x352a5664ad09ed22111ef209,
            limb1: 0xc2fe0792a993bfa1771d64ac,
            limb2: 0x26f89bc07398c259,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x2c78925418a3651b7b9f3260,
            limb1: 0xfe8414788b2aa8f5ac23d954,
            limb2: 0x72ae0678e079f6d,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x2ae6e01f9e31fe942d84d61e,
            limb1: 0x394dc28fbdae226870dad015,
            limb2: 0x26a4bf5e924cec01,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xbfdfdae86101e29da3e869b8,
            limb1: 0xf969a9b961a28b872e56aac2,
            limb2: 0x1afdc719440d90f0,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xee43c995686f13baa9b07266,
            limb1: 0xbfa387a694c641cceee4443a,
            limb2: 0x104d8c02eb7f60c8,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x8d451602b3593e798aecd7fb,
            limb1: 0x69ffbefe7c5ac2cf68e8691e,
            limb2: 0x2ea064a1bc373d28,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x6e7a663073bfe88a2b02326f,
            limb1: 0x5faadb36847ca0103793fa4a,
            limb2: 0x26c09a8ec9303836,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x824428c8f1355395a5d9ba68,
            limb1: 0x376f82056ab1a3d451926ebc,
            limb2: 0x1651053bdebca358,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xf5739b050710bb99609328bb,
            limb1: 0x101222612f31bc7d1c0bd8e5,
            limb2: 0x13b46682b3ffd5da,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xce3778bd830f3b8fcbc8fd80,
            limb1: 0x8b28ab5db321c956a216239f,
            limb2: 0x12e9fa0b5b37656,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x11d47326796ba49f7372575c,
            limb1: 0x5439890841ee14932fdab241,
            limb2: 0x20ae02265c066cc9,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x425d0d7397a9e275fc2db499,
            limb1: 0x7f6b8d71e11f548b4d52bf31,
            limb2: 0x2c9efbf479b13fa4,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xfb4f8033b39143145d5d575c,
            limb1: 0x1092cb281de96152526680ac,
            limb2: 0x7710ce4bed3d106,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xc5d8ab3cc6e583dfc896163c,
            limb1: 0xf5b82ff3e496bbb907405ad3,
            limb2: 0x20b2e6d8b0060f54,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x451966d9d1c038dba9ab8ae6,
            limb1: 0xe9cfd3cf72125953ee709296,
            limb2: 0xa1519085152fe37,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xacd3f939e6b4de8015d50a4a,
            limb1: 0x932d6fe41590e16fcf4728de,
            limb2: 0x2a55f11a8412dd22,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x7f764285e1ca73e64f3eced9,
            limb1: 0x3a7214078639a91e2a050767,
            limb2: 0x1d04ed23a3b3e1be,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x69ec8401f9ef69cfc5df09bb,
            limb1: 0x7fa343543c564e9e837a4644,
            limb2: 0x150616010d6fa36f,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x71626c8c34cb639ce5d93c58,
            limb1: 0x7a242708c1377b74cd303101,
            limb2: 0x2eaa87dfaabeb006,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x478b0f6dcf4c5d01008b55b4,
            limb1: 0x634f9f6faedcd7484dd0d460,
            limb2: 0x3007d69229052aec,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x37cf822fd69e44c681427390,
            limb1: 0xb515a4a291e1b1e78d3c9417,
            limb2: 0x2145827f3151a1c6,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x66ee310a53c020169970728c,
            limb1: 0x9ead15eed8f6356bb12f95bb,
            limb2: 0x194a23368a494dca,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x630d7a79fe6e24373616d9b1,
            limb1: 0x8ba297c54fe9aea124b66958,
            limb2: 0x1f0ba647346fe519,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xc61878259931f06d581227d,
            limb1: 0xb62f3438b1093f6f2ce5350b,
            limb2: 0x1cc3cd8da190adc5,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x5a3c6293f1ec2ed930dc5f08,
            limb1: 0xb547e578549ea22850798312,
            limb2: 0x4752f810a957d55,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x67816ab80d21a46acd7988c5,
            limb1: 0x426c40b013573a0d9c0a7e01,
            limb2: 0xc025bdb245edaea,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xc415641c264bed3a74e6cb93,
            limb1: 0xc4761c2480fa53b5c429dcc2,
            limb2: 0x1313a52881cf161d,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x83457a77529525742b47ed31,
            limb1: 0xb9668c56e6ca9360529a0322,
            limb2: 0x1f7893ddffce2b29,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x643c191e38deba5be1420be3,
            limb1: 0x839733ac9f390385df7b60b1,
            limb2: 0x86c5a0c654d426b,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x2fb20a2c38605dd786a0db4f,
            limb1: 0x339bb334f679fba41b51edfe,
            limb2: 0xd2c93e392145c57,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x42d4def0968502e908153d27,
            limb1: 0x7f1fd7be17969e2a8b5996d3,
            limb2: 0x9db0eccb2db1e73,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x6ae78200cd4ae3385f9e2bab,
            limb1: 0x32deb1967d3388bebfadaec2,
            limb2: 0x1dbe3807f67b8be8,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x7b2db492b16b4f27d58c0fd5,
            limb1: 0x3fe4de724d915aad55aa2a72,
            limb2: 0x2016e73f2f2a117f,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x4f07f98bf4fd4a6e203fe1f7,
            limb1: 0x71e32db40ab0416f759234a5,
            limb2: 0x2abbd1bafee9693f,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xff250de574af9d0237195fcf,
            limb1: 0x627825de34a8afa7cef55f7a,
            limb2: 0x2c83a5c354ff81b0,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xd2ba17616fef72508e1a5469,
            limb1: 0xd7dec16d12699c87fd35eed3,
            limb2: 0x195b893be3b8eaf7,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x6dec1515afa975aac35955e9,
            limb1: 0x2eb0396350e6ba0b3b925376,
            limb2: 0x2d9225f5110cbc08,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x3674c208512e6b8adff9ded5,
            limb1: 0x64d240cc4d356d05a91d1a6b,
            limb2: 0xc9c54dbcc0c2dc8,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xdc3916de51ce2cdaab4d2125,
            limb1: 0xc0179c18e2b86aefc8bac7e8,
            limb2: 0x6f0795d4355588e,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x3f058d8c63fd905d3ca29b42,
            limb1: 0x1f0a90982cc68e4ddcd83e57,
            limb2: 0x240aeaae0783fbfa,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xedfee81d80da310fdf0d0d8,
            limb1: 0xc2208e6de8806cf491bd74d4,
            limb2: 0xb7318be62a476af,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x3c6920c8a24454c634f388fe,
            limb1: 0x23328a006312a722ae09548b,
            limb2: 0x1d2f1c58b80432e2,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xb72980574f7a877586de3a63,
            limb1: 0xcd773b87ef4a29c16784c5ae,
            limb2: 0x1f812c7e22f339c5,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x136f12702628c4c28c7eeeec,
            limb1: 0x871300fcb5caa6825b5350b0,
            limb2: 0x2c85ca21f17e5383,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x1c21b388beb4e0379167a86d,
            limb1: 0x3c4c59090099f2747445a79,
            limb2: 0x1a00996b4da862c8,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x13fec18f8bdebac08fd7dcf9,
            limb1: 0xe544eaa9899a3d56b61da05a,
            limb2: 0x21516d5843889232,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xb1e88f1fd5443f509985809d,
            limb1: 0xd84332c770be1002aed19316,
            limb2: 0x1dc76aeced82b6f2,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x219a140154109ee7653b47d8,
            limb1: 0xd87fa178daffefe3dc339320,
            limb2: 0x1b64d217daf233d4,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xb3b2902c23a1e297afc723f1,
            limb1: 0xec8c0334a6a16fb184bdead,
            limb2: 0x194ee26f950ec5f,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xea0b18b28d70a0af43f81ec5,
            limb1: 0x1ec1efd748ba4d8687c22bb3,
            limb2: 0x1e98470402747e1,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x32ebb96106cdebef00b5f079,
            limb1: 0x29e0caf709d34430343bf4fe,
            limb2: 0x5d405f60a473bfc,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xfeebe92941f95b6ea1d095bb,
            limb1: 0x9c7962eb8bbeb95a9ca7cf50,
            limb2: 0x290bdaf3b9a08dc3,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x686cfa11c9d4b93675495599,
            limb1: 0xb1d69e17b4b5ebf64f0d51e1,
            limb2: 0x2c18bb4bdc2e9567,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x17419b0f6a04bfc98d71527,
            limb1: 0x80eba6ff02787e3de964a4d1,
            limb2: 0x26087bb100e7ff9f,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x17c4ee42c3f612c43a08f689,
            limb1: 0x7276bdda2df6d51a291dba69,
            limb2: 0x40a7220ddb393e1,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xfcbba4528085627c1a57561e,
            limb1: 0x1077be1789bfa914646ecc48,
            limb2: 0x1daf99b543be0c2,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x73889773fb3e9955a83f6371,
            limb1: 0x65e8a51749a2070ca7d04fe3,
            limb2: 0x193e02f206b649b5,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x4bcdb53209d1e271c3981a53,
            limb1: 0xcd0c66c9c62656f385896b9a,
            limb2: 0x4fae5ec45196d1f,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xff4b9fb7c654595edbc25c37,
            limb1: 0x9fb627a4ff2fd8e4aeb9855f,
            limb2: 0x14f93e3bc9bb22dd,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x830d777c19040571a1d72fd0,
            limb1: 0x651b2c6b8c292020817a633f,
            limb2: 0x268af1e285bc59ff,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xede78baa381c5bce077f443d,
            limb1: 0x540ff96bae21cd8b9ae5438b,
            limb2: 0x12a1fa7e3b369242,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x797c0608e5a535d8736d4bc5,
            limb1: 0x375faf00f1147656b7c1075f,
            limb2: 0xda60fab2dc5a639,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x610d26085cfbebdb30ce476e,
            limb1: 0x5bc55890ff076827a09e8444,
            limb2: 0x14272ee2d25f20b7,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x4df45d410833e4569501b62,
            limb1: 0x5699ff1c49fc63f8f017a20e,
            limb2: 0x1c2b4976da64f44e,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xa371e6c9dc1278d9b692f5c0,
            limb1: 0xe2818a89c204727bbb77e230,
            limb2: 0x2524c5673fb891de,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x8b35f28524701efaaa2f36e9,
            limb1: 0x7d0defb1afd7565b6ca0969,
            limb2: 0x3138ffe86fc3f3c,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xbf20ec1ddaebd714888b9623,
            limb1: 0x16edc17da676619889e1f93f,
            limb2: 0x2895535d6bfd83ad,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xd6862e1a4ca3b2baf6f8d8aa,
            limb1: 0x96f9066dded3a3d899025af4,
            limb2: 0x1a98af9f0d48fd3,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x276b417cc61ea259c114314e,
            limb1: 0x464399e5e0037b159866b246,
            limb2: 0x12cc97dcf32896b5,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xef72647f4c2d08fc038c4377,
            limb1: 0x34883cea19be9a490a93cf2b,
            limb2: 0x10d01394daa61ed0,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xdf345239ece3acaa62919643,
            limb1: 0x914780908ece64e763cca062,
            limb2: 0xee2a80dbd2012a3,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x1d5a31f4d08a0ebf7e071e00,
            limb1: 0xcd1244dd95dd30005f531f81,
            limb2: 0xb4cb469a2dcf4f1,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x7c5938adaf38b355092de1f1,
            limb1: 0x292ab08995b293abfcba14b,
            limb2: 0x1fd126a2b9f37c67,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x6e9d352b02a7cb771fcc33f9,
            limb1: 0x7754d8536eefda2025a07340,
            limb2: 0x1840289291c35a72,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xe85f465417b7bd758c547b2e,
            limb1: 0xf7f703c3bc55ff8a01fa9365,
            limb2: 0xfa301227880a841,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x2f943bcffafbec474e14056,
            limb1: 0xe36cbbcaa047d892ce518c06,
            limb2: 0x28e9edc7ec764cec,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xa4e5768f524886ccd57ef67f,
            limb1: 0x846c3c4a1b3d610c6598a6ca,
            limb2: 0x26c1dd1c6cef5230,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x646a7a17c9c2d11cf18ce24c,
            limb1: 0x9c3bc28ac69dc0fa40709bc3,
            limb2: 0x22355c8b8f9caf41,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x532978b7044846c302ea39dc,
            limb1: 0xb3b1a62ec6c95c12a8ee1c3c,
            limb2: 0x1b9cf068f2f7f74,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xae2e80376c9eb92d7fdf62f4,
            limb1: 0xc8987db182a167029720321d,
            limb2: 0x32dd5c4a5ead22e,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xed934df95403f36e080370c1,
            limb1: 0x82991943f3810cb571dd5476,
            limb2: 0x1c8835c07868aab0,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xe69df9d36c3ef19b14ac3256,
            limb1: 0xeffc663918d000a46b1308f3,
            limb2: 0x2d3d6a3aa18904ea,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x49fd82b2c5900a89f4e3e03,
            limb1: 0x4b4cedd7d8bab16a1290e7a7,
            limb2: 0x13c64649ca8e5620,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xa4058149e82ea51362b79be4,
            limb1: 0x734eba2621918a820ae44684,
            limb2: 0x110a314a02272b1,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xe2b43963ef5055df3c249613,
            limb1: 0x409c246f762c0126a1b3b7b7,
            limb2: 0x19aa27f34ab03585,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x179aad5f620193f228031d62,
            limb1: 0x6ba32299b05f31b099a3ef0d,
            limb2: 0x157724be2a0a651f,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xa33b28d9a50300e4bbc99137,
            limb1: 0x262a51847049d9b4d8cea297,
            limb2: 0x189acb4571d50692,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x958cb28384b32ba53919aad6,
            limb1: 0x7cb6afd288225969b3ed04a7,
            limb2: 0x1f6c88c19f868c64,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x1f9383d92c96e715fa8a0e4,
            limb1: 0x185e1f31310dcf1342282c7f,
            limb2: 0x9d2bbb84bf8c8a,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x2ebb25e92c5e5775f24e5f43,
            limb1: 0x5a0dd9406740da093e0e9df9,
            limb2: 0x20542767fe53e03a,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xfc3d9b88c92d661c9f2e49d4,
            limb1: 0xd5c675a3022548b290b637dc,
            limb2: 0x6fc49e7ff4bc3,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x29bd4381ae4afc677ee37ed6,
            limb1: 0x29ed43453f9a008d9176f004,
            limb2: 0x24134eb915104f43,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x81597f82bb67e90a3e72bdd2,
            limb1: 0xab3bbde5f7bbb4df6a6b5c19,
            limb2: 0x19ac61eea40a367c,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xe30a79342fb3199651aee2fa,
            limb1: 0xf500f028a73ab7b7db0104a3,
            limb2: 0x808b50e0ecb5e4d,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x55f2818453c31d942444d9d6,
            limb1: 0xf6dd80c71ab6e893f2cf48db,
            limb2: 0x13c3ac4488abd138,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x5c0c3c2206b28bed76db5fb9,
            limb1: 0xa81f45c675f24fab51c8325a,
            limb2: 0xd27686198826ba2,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x9ce02274becdc697b91bdc82,
            limb1: 0x193674102a7fa372f1e3864,
            limb2: 0x1ad17052d923f3ab,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x2ab1b4cab08b97770060cd95,
            limb1: 0x5b7cae55f9b2ef94b80bc0fc,
            limb2: 0x4319d424bab41a3,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xd80167cf68050f7988b0d7b,
            limb1: 0x4177064bd3572a973e0afd8,
            limb2: 0xa5c5ddbd56184d6,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xd1464269bbeafa546f559b8f,
            limb1: 0xab7f7dcd1ac32b86979471cf,
            limb2: 0x6a38256ee96f113,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xf14d50984e65f9bc41df4e7e,
            limb1: 0x350aff9be6f9652ad441a3ad,
            limb2: 0x1b1e60534b0a6aba,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x9e98507da6cc50a56f023849,
            limb1: 0xcf8925e03f2bb5c1ba0962dd,
            limb2: 0x2b18961810a62f87,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x3a4c61b937d4573e3f2da299,
            limb1: 0x6f4c6c13fd90f4edc322796f,
            limb2: 0x13f4e99b6a2f025e,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xf86c13c653367f48043babc5,
            limb1: 0x52798720b6abfea4f78e8755,
            limb2: 0x2a08b546b9a04e01,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x3a3897216778c8d89c902498,
            limb1: 0xe9e85640d8cfb88eac53d7a4,
            limb2: 0x22ed91f0b0f7b0a7,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xa1e20caf4a06b7069c5fcade,
            limb1: 0xce1ab9c14ede733440fe4d4f,
            limb2: 0x29511f7e24afbc7a,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x2cb71e6fb0c40ed481c482d2,
            limb1: 0xb4a3dfc3f1f8bf08f18b9963,
            limb2: 0x20cc0deb8bc5808a,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xe0115a79120ae892a72f3dcb,
            limb1: 0xec67b5fc9ea414a4020135f,
            limb2: 0x1ee364e12321904a,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xa74d09666f9429c1f2041cd9,
            limb1: 0x57ffe0951f863dd0c1c2e97a,
            limb2: 0x154877b2d1908995,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xcbe5e4d2d2c91cdd4ccca0,
            limb1: 0xe6acea145563a04b2821d120,
            limb2: 0x18213221f2937afb,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xfe20afa6f6ddeb2cb768a5ae,
            limb1: 0x1a3b509131945337c3568fcf,
            limb2: 0x127b5788263a927e,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x1682a38c2b0f08b940585776,
            limb1: 0x4bcfdd206314bf8fb7bbd3d9,
            limb2: 0x72478229fdf9b3e,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x7655cf8178fd96eab34ed64c,
            limb1: 0xa8a410386256daf6f497a426,
            limb2: 0x24a563cb3fd6a97c,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xcc3e2f74f61e4ad3dd0ec353,
            limb1: 0xd8d2eed02ef01ce6c895d54b,
            limb2: 0x2f0b5abbb25e5201,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x6ca200200f72fc879747d649,
            limb1: 0xfe2a8dfce46aa04cc6cac8bf,
            limb2: 0x2538761bcc075511,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xe7c658aecdab4db3c83f7927,
            limb1: 0xfbf162264ca04ee50c70bde8,
            limb2: 0x2a20f4565b7ff885,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x45b1c2f0a1226361f42683c0,
            limb1: 0x9acdd892c48c08de047296bc,
            limb2: 0x27836373108925d4,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xc0ea9294b345e6d4892676a7,
            limb1: 0xcba74eca77086af245d1606e,
            limb2: 0xf20edac89053e72,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x4c92a28f2779a527a68a938c,
            limb1: 0x3a1c3c55ff9d20eac109fab3,
            limb2: 0x21c4a8c524b1ee7d,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xb4a2a27e2287cfee7a9682c4,
            limb1: 0x1ce9a7e33aac888cfff41045,
            limb2: 0x15862361b72f510c,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xf2ad35e6e2883182aa6b4fd1,
            limb1: 0xe770aff5925910a31f0953c9,
            limb2: 0x2620607848308ab0,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xd96d83a873e922ac6356c949,
            limb1: 0xd55163234b216b61b10f5648,
            limb2: 0xde3b9a35927e127,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xab124d1d7268f0e796dbe62c,
            limb1: 0x2853f3ef7aa34d7a0e228ce2,
            limb2: 0x13beaa5c47f7b339,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xa68021d593c46246af22559e,
            limb1: 0x5c2cfc5bc4cd1b48f4704134,
            limb2: 0x296066ede1298f8c,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xfe17dd6765eb9b9625eb6a84,
            limb1: 0x4e35dd8e8f6088bb14299f8d,
            limb2: 0x1a380ab2689106e4,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x82bacf337ca09853df42bc59,
            limb1: 0xa15de4ef34a30014c5a2e9ae,
            limb2: 0x243cc0cec53c778b,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xcb2a1bf18e3ba9349b0a8bf2,
            limb1: 0x35134b2505cbb5a4c91f0ac4,
            limb2: 0x25e45206b13f43c4,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x8e97b007ffd9891bd0e77650,
            limb1: 0x77671278ac33f17df6b1db88,
            limb2: 0x243daddc47f5d5c2,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x655fe4c8bbe5ee06aaa0054b,
            limb1: 0xf751450b02c93c7ddea95938,
            limb2: 0x21aa988e950d563f,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xb51b3b6b8582de3eb0549518,
            limb1: 0x84a1031766b7e465f5bbf40c,
            limb2: 0xd46c2d5b95e5532,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x50b6ddd8a5eef0067652191e,
            limb1: 0x298832a0bc46ebed8bff6190,
            limb2: 0xb568b4fe8311f93,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x95142735dac6534042d2d05e,
            limb1: 0x7403f0a3b4d2a49a7009872f,
            limb2: 0x2b5ce066c5012949,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xfb9dd943bee0316b632fd1fc,
            limb1: 0xe28dc017ad7c82d573ca64d4,
            limb2: 0x1d814d88b3e026ce,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x1722d6e82c213b5f5bb54b06,
            limb1: 0xe97b4fa087e0ac0ade7e9fb3,
            limb2: 0x117a4f1562cdc338,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x16204b8c2a7d006220778fc4,
            limb1: 0x23ebf70a7d3687322b0a559b,
            limb2: 0x117d1eaacfcf39d0,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xac3a5cf29dd67034cce999d8,
            limb1: 0xabf7913b1ad3df78f63ec920,
            limb2: 0x10e5e9415124c78a,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xfe328b7478a7b96b0521d32d,
            limb1: 0x486efcf8db262be440c2f384,
            limb2: 0x118851b013a7a2f6,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xfcea8d918c9420959fc131c1,
            limb1: 0x2c76ec0524a5b61c91661734,
            limb2: 0xbfe2e9e02621600,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xc55d8e0d7ac126b8e0dfa148,
            limb1: 0x178dd414d941be3cb70299bb,
            limb2: 0x15b52c5f3e3c78fe,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xddb4db99db681d35f71a159c,
            limb1: 0xf71a330019414e6fdee75700,
            limb2: 0x14d9838e7d1918bb,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x203c8bac71951a5f2c653710,
            limb1: 0x9fc93f8da38ecc2957313982,
            limb2: 0x7b6d981259cabd9,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xa7297cdb5be0cc45d48ca6af,
            limb1: 0xa07b4b025ebe6c960eddfc56,
            limb2: 0xef2a5c30ef00652,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xb7f05c76d860e9122b36ecd7,
            limb1: 0x407d6522e1f9ce2bcbf80eda,
            limb2: 0x197625a558f32c36,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x4e67d839c8646de27691dae2,
            limb1: 0xa113e037559795425b1ca935,
            limb2: 0xe0f8316d3adace6,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xac5484d96d5e16708aa20635,
            limb1: 0x3cf76c0c779c04ac350707d7,
            limb2: 0x189022b6900c47,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x4c4cf7790d369d15fe931a4e,
            limb1: 0xeccffa7915f2d1fb735abf95,
            limb2: 0x18f28ca407bde4a,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x2b7dcc570e7213f9c18015d3,
            limb1: 0x8196ba5914d477135145617,
            limb2: 0x1d11ba6a93642a1d,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xb0f04df9dec94801e48a6ff7,
            limb1: 0xdc59d087c627d38334e5b969,
            limb2: 0x3d36e11420be053,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xc80f070001aa1586189e0215,
            limb1: 0xff849fcbbbe7c00c83ab5282,
            limb2: 0x2a2354b2882706a6,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x48cf70c80f08b6c7dc78adb2,
            limb1: 0xc6632efa77b36a4a1551d003,
            limb2: 0xc2d3533ece75879,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x63e82ba26617416a0b76ddaa,
            limb1: 0xdaceb24adda5a049bed29a50,
            limb2: 0x1a82061a3344043b,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xbd69421a5b200ff9b38f831f,
            limb1: 0x3fe4fe938fccbaeeea650793,
            limb2: 0x19df4f325f19d790,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x460ec10fdc20f258517b0ede,
            limb1: 0xed5f65a9e2470b25df5fef70,
            limb2: 0x1b61c823ebf0b10a,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x658cfa5631cd4889f4c5faf1,
            limb1: 0x7fc4136b63b1f54e46d634cb,
            limb2: 0xb2cdd6f5da71516,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xf29e04c6192dd039241e5573,
            limb1: 0xaed4fb46d1273a5895ee2308,
            limb2: 0x291ea193f947c5dc,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x9152fecf0f523415acc7c7be,
            limb1: 0xd9632cbfccc4ea5d7bf31177,
            limb2: 0x2d7288c5f8c83ab1,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x53144bfe4030f3f9f5efda8,
            limb1: 0xfeec394fbf392b11c66bae27,
            limb2: 0x28840813ab8a200b,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xdec3b11fbc28b305d9996ec7,
            limb1: 0x5b5f8d9d17199e149c9def6e,
            limb2: 0x10c1a149b6751bae,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x665e8eb7e7d376a2d921c889,
            limb1: 0xfdd76d06e46ee1a943b8788d,
            limb2: 0x8bb21d9960e837b,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x3a67c28a175200e631aa506a,
            limb1: 0x7397303a34968ff17c06e801,
            limb2: 0x1b81e0c63123688b,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x3490cfd4f076c621dac4a12c,
            limb1: 0xec183578c91b90b72e5887b7,
            limb2: 0x179fb354f608da00,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x9322bde2044dde580a78ba33,
            limb1: 0xfc74821b668d3570cad38f8b,
            limb2: 0x8cec54a291f5e57,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xc2818b6a9530ee85d4b2ae49,
            limb1: 0x8d7b651ad167f2a43d7a2d0a,
            limb2: 0x7c9ca9bab0ffc7f,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xb3b784e642887a8476f572e,
            limb1: 0xed02f127df5eed0cb36a3bf8,
            limb2: 0xba1df3a2dfa44,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x42c8ddcabfe9a7ad125d0ca9,
            limb1: 0x7893651eea284a367016e3f4,
            limb2: 0x169246616ba43650,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x1c64d4f3656e04d1a72b8d48,
            limb1: 0xab4d9597432f9192baa38fde,
            limb2: 0x166f0057c0435ce,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xff9760ba5717ba174df6f8f8,
            limb1: 0x426768d82386947c5babfd7f,
            limb2: 0x7ca1e1a5d1a0c5e,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xd5f536bc65864831172f42a0,
            limb1: 0x26dcfa4e457220eb911294ce,
            limb2: 0x105261c2c69ce433,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x6e00517fac26565662abb1ad,
            limb1: 0xa14626f27b8158a553767216,
            limb2: 0x22d2abd4602c1c6b,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x92f008ec8c7f2dc8a8571a28,
            limb1: 0x856f48547c31d1368fb8c686,
            limb2: 0x2ed469b49fa7d7ea,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xf50c1feb101e5ceb3b16ec4e,
            limb1: 0x3a230af636b80f192ec0e399,
            limb2: 0x1764922866d60a5e,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xa576408f8300de3a7714e6ae,
            limb1: 0xe1072c9a16f202ecf37fbc34,
            limb2: 0x1b0cb1e2b5871263,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x2128e2314694b663286e231e,
            limb1: 0x54bea71957426f002508f715,
            limb2: 0x36ecc5dbe069dca,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x17c77cd88f9d5870957850ce,
            limb1: 0xb7f4ec2bc270ce30538fe9b8,
            limb2: 0x766279e588592bf,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x1b6caddf18de2f30fa650122,
            limb1: 0x40b77237a29cada253c126c6,
            limb2: 0x74ff1349b1866c8,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xbb540898cf8935c1b1173cb4,
            limb1: 0xc1418f5298a4a4bf6f2e3bd3,
            limb2: 0xc988fb564cf08d8,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xf09b861d7134a245b7e364b4,
            limb1: 0xa92280b0deb7fe5180ed4b7a,
            limb2: 0x7aa813cc9c85d7b,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xed06ae875b1fc56f5d1c3f8e,
            limb1: 0xc41bdd2f5b4150a210b33d70,
            limb2: 0x2cea2b050d19c785,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x9790a2fc143b9afb8a56de04,
            limb1: 0xe74dd4109ce475db08d477a2,
            limb2: 0x19dba5858fcd648f,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x3603266e05560becab36faef,
            limb1: 0x8c3b88c9390278873dd4b048,
            limb2: 0x24a715a5d9880f38,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xe9f595b111cfd00d1dd28891,
            limb1: 0x75c6a392ab4a627f642303e1,
            limb2: 0x17b34a30def82ab6,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xe706de8f35ac8372669fc8d3,
            limb1: 0x16cc7f4032b3f3ebcecd997d,
            limb2: 0x166eba592eb1fc78,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x7d584f102b8e64dcbbd1be9,
            limb1: 0x2ead4092f009a9c0577f7d3,
            limb2: 0x2fe2c31ee6b1d41e,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x72253d939632f8c28fb5763,
            limb1: 0x9b943ab13cad451aed1b08a2,
            limb2: 0xdb9b2068e450f10,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x80f025dcbce32f6449fa7719,
            limb1: 0x8a0791d4d1ed60b86e4fe813,
            limb2: 0x1b1bd5dbce0ea966,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xaa72a31de7d815ae717165d4,
            limb1: 0x501c29c7b6aebc4a1b44407f,
            limb2: 0x464aa89f8631b3a,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x6b8d137e1ea43cd4b1f616b1,
            limb1: 0xdd526a510cc84f150cc4d55a,
            limb2: 0x1da2ed980ebd3f29,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x2990abd5a415b597653aecc7,
            limb1: 0xf6d59e5d9f2735e0b5196522,
            limb2: 0x12cfd626116f3e90,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x85ff23da49c13991049c2a30,
            limb1: 0x29ea9dc0564c06318ee970c6,
            limb2: 0x2f579deeac8b19a,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x458c505570a4bc6cd8751128,
            limb1: 0xcff5c9e1d1d4c1f64e37982c,
            limb2: 0x1bfc56f58e4e33f5,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x364b1be00e65d893a9fabb7,
            limb1: 0xfa38e20e90619e224b054d86,
            limb2: 0x1d3724ff58e69e9d,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x604234358fe8a608e232b055,
            limb1: 0x81bf97d1a0380fa64ffab70d,
            limb2: 0x2fe1c2c2521704f2,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x49746a3559cdc3031fd62abe,
            limb1: 0xc0676e4a367566526115e5d5,
            limb2: 0x793d580a7f8d698,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x434be9b6d4f5097159fe303b,
            limb1: 0x1eff6c60a4c52f744e8e2276,
            limb2: 0x210a1915eaab4b20,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x4e6f7e9d87f16fc7601cc783,
            limb1: 0xd4bec91933ea7c5f9518ea04,
            limb2: 0x1c45a57b0c8d62d7,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x867cced8a010850958f41ff5,
            limb1: 0x6a37fdb2b8993eed18bafe8e,
            limb2: 0x21b9f782109e5a7,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x7307477d650618e66de38d0f,
            limb1: 0xacb622ce92a7e393dbe10ba1,
            limb2: 0x236e70838cee0ed5,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xb564a308aaf5dda0f4af0f0d,
            limb1: 0x55fc71e2f13d8cb12bd51e74,
            limb2: 0x294cf115a234a9e9,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xbd166057df55c135b87f35f3,
            limb1: 0xf9f29b6c50f1cce9b85ec9b,
            limb2: 0x2e8448d167f20f96,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x8af780d4f3611de614224cf4,
            limb1: 0xb3411d6969eed4b8286c7185,
            limb2: 0x13f31915350d79e7,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xefebdf46e1c80e1bbfc388c4,
            limb1: 0xbab06fd5263cc18fb57d9e95,
            limb2: 0xe1c884a026d918e,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x845caa8c849832ee6cfe63b1,
            limb1: 0xaedd1db275061decc9cd7b3a,
            limb2: 0x23787e28f22f3546,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x28e41c19ff26092ec696db3f,
            limb1: 0x90f1244e5140a5df661d05f9,
            limb2: 0x2f61a80ac4d65725,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xdedaff3205bb953b2c390b8a,
            limb1: 0xe1a899da21c1dafb485c707e,
            limb2: 0x1ec897e7a041493e,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xf52c3c30cd4d3202b34089e0,
            limb1: 0xc652aa1ff533e1aad7532305,
            limb2: 0x2a1df766e5e3aa2e,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x7ac695d3e19d79b234daaf3d,
            limb1: 0x5ce2f92666aec92a650feee1,
            limb2: 0x21ab4fe20d978e77,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xa64a913a29a1aed4e0798664,
            limb1: 0x66bc208b511503d127ff5ede,
            limb2: 0x2389ba056de56a8d,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x5fa9f3d6ba2e33d9df261501,
            limb1: 0x14ce648819a9c46d64d2ad7a,
            limb2: 0x200d58896e8e5649,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xd961390ca5e5c1a18c8258f0,
            limb1: 0xe2e869b5cf4982ab8e3b203a,
            limb2: 0x269258fa79102f56,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x68cdab4015c2a73a65068b85,
            limb1: 0x89d0b1abc07351c7a379bd7c,
            limb2: 0x257b6794021bc2db,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xc75c452e6d369e6a87b6e1e,
            limb1: 0xdaabd301cafb7edba76274ef,
            limb2: 0x3bde99bf58a92c2,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xd88b16e68600a12e6c1f6006,
            limb1: 0x333243b43d3b7ff18d0cc671,
            limb2: 0x2b84b2a9b0f03ed8,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xf3e2b57ddaac822c4da09991,
            limb1: 0xd7c894b3fe515296bb054d2f,
            limb2: 0x10a75e4c6dddb441,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x73c65fbbb06a7b21b865ac56,
            limb1: 0x21f4ecd1403bb78729c7e99b,
            limb2: 0xaf88a160a6b35d4,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xade61ce10b8492d659ff68d0,
            limb1: 0x1476e76cf3a8e0df086ad9eb,
            limb2: 0x2e28cfc65d61e946,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xdf8b54b244108008e7f93350,
            limb1: 0x2ae9a68b9d6b96f392decd6b,
            limb2: 0x160b19eed152271c,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xc18a8994cfbb2e8df446e449,
            limb1: 0x408d51e7e4adedd8f4f94d06,
            limb2: 0x27661b404fe90162,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x1390b2a3b27f43f7ac73832c,
            limb1: 0x14d57301f6002fd328f2d64d,
            limb2: 0x17f3fa337367dddc,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x79cab8ff5bf2f762c5372f80,
            limb1: 0xc979d6f385fae4b5e4785acf,
            limb2: 0x60c5307a735b00f,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x94336f2c5c03b2ad5dfd59a2,
            limb1: 0x3ee02119f9d3e985e9859470,
            limb2: 0x11a897fc6f4ac878,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x8fbbe337bcd3b3926dfd5a7b,
            limb1: 0x6a45f1a06ee96d69024430db,
            limb2: 0x14e51a458ccb2d83,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xbb2657ff1a311ddd38278308,
            limb1: 0x776a992cfacbf2c03314a11,
            limb2: 0x58d65fdae6e48e1,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x12a32aecc832311454a1c546,
            limb1: 0x2fe303fbc237d54289547719,
            limb2: 0x3668aec6f11f21e,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xb0aa6695235ffd66d5f3c609,
            limb1: 0x318302a2be41d2dacdbc374d,
            limb2: 0x1eeaf97b389d7e8e,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x10bf93e11b2746d13bb58a38,
            limb1: 0xd1b4adad34ee3f10a1482bc0,
            limb2: 0x177de2cef1432bb6,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x83b01a1debda734692f242b9,
            limb1: 0xff64a01021e721460650bba4,
            limb2: 0x23fc5e8c9a462660,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xf56122ef42ec57584ae1e554,
            limb1: 0x1be67e0ec4b5b9cf2540e9a7,
            limb2: 0x15e2a1a3f49ec180,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x386d7b23c6dccb87637018c9,
            limb1: 0xfed2ea478e9a2210289079e2,
            limb2: 0x100aa83cb843353e,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x229c5c285f049d04c3dc5ce7,
            limb1: 0x28110670fe1d38c53ffcc6f7,
            limb2: 0x1778918279578f50,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xe9ad2c7b8a17a1f1627ff09d,
            limb1: 0xedff5563c3c3e7d2dcc402ec,
            limb2: 0xa8bd6770b6d5aa8,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x66c5c1aeed5c04470b4e8a3d,
            limb1: 0x846e73d11f2d18fe7e1e1aa2,
            limb2: 0x10a60eabe0ec3d78,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x1699deb0ead59ed63109c05b,
            limb1: 0xb325da3842cebabbec003fc1,
            limb2: 0xc0de846c16e6112,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x99309402eca08241dae4e273,
            limb1: 0xaa16e86224c3178f60d03bb7,
            limb2: 0x24cde0d47b2dcef1,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x7d47f9f43dd62a2f56442e26,
            limb1: 0x9d3fd5f2224d5f9a10b5bf3e,
            limb2: 0x1ea21619d0ac4ca7,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x945a4528b5a37c8fdf0cc9af,
            limb1: 0x7ad4fbe1529463b319293c35,
            limb2: 0xa55c48b621e6341,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x88ca191d85be1f6c205257ef,
            limb1: 0xd0cecf5c5f80926c77fd4870,
            limb2: 0x16ec42b5cae83200,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x154cba82460752b94916186d,
            limb1: 0x564f6bebac05a4f3fb1353ac,
            limb2: 0x2d47a47da836d1a7,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xb39c4d6150bd64b4674f42ba,
            limb1: 0x93c967a38fe86f0779bf4163,
            limb2: 0x1a51995a49d50f26,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xeb7bdec4b7e304bbb0450608,
            limb1: 0x11fc9a124b8c74b3d5560ea4,
            limb2: 0xbfa9bd7f55ad8ac,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x4f28d4247eb0e0a53f03f444,
            limb1: 0xe8f36708d074dd12e311c7aa,
            limb2: 0x1d92749e4fc01c06,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x250166cbdf943b8f355f3863,
            limb1: 0xc5fb4230bafe5e79ca84b40c,
            limb2: 0xd5d8ec40858dc7b,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xab518924ec9867879e25582a,
            limb1: 0x2d3857a7fcba7b3149f2102e,
            limb2: 0x524fec03876938c,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xf56af23dcb095ed80aa220e7,
            limb1: 0xb67dbb76fc439aae6b2dd36a,
            limb2: 0x2b6f640edeaa501d,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x2fdc574c85cf0c0ce5e07a51,
            limb1: 0xd2439bf7b00bddc4cfb01b0c,
            limb2: 0x125c3bbdeb0bd2da,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x9d664714bae53cafcb5ef55d,
            limb1: 0x495c01724790853548f5e4de,
            limb2: 0x2ce5e2e263725941,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x98071eb7fe88c9124aee3774,
            limb1: 0xc3f66947a52bd2f6d520579f,
            limb2: 0x2eaf775dbd52f7d3,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x23e5594948e21db2061dca92,
            limb1: 0xd0ffa6f6c77290531c185431,
            limb2: 0x604c085de03afb1,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xccbab5c7a0c5742ffa48733a,
            limb1: 0x23ef71f3d85c3bcf13168107,
            limb2: 0x2ddb1f0a6d652587,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xc28304e1eab794df6c6e2292,
            limb1: 0x7ec85b63501012b9d7b45342,
            limb2: 0x1b2d2e2c38abb2e,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xea706451e63a0b21024ffdf1,
            limb1: 0x138461dd2f2d3f164edfa0a3,
            limb2: 0x1ca4c45bdf45ca1f,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x52cb07c8413f40678dac95f1,
            limb1: 0xff127a91385511589a9f1879,
            limb2: 0x25e33c022d25bf1f,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xeec2912e15f6bda39d4e005e,
            limb1: 0x2b8610c44d27bdbc6ba2aac5,
            limb2: 0x78ddc4573fc1fed,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x48099a0da11ea21de015229d,
            limb1: 0x5fe937100967d5cc544f4af1,
            limb2: 0x2c9ffe6d7d7e9631,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xa70d251296ef1ae37ceb7d03,
            limb1: 0x2adadcb7d219bb1580e6e9c,
            limb2: 0x180481a57f22fd03,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xacf46db9631037dd933eb72a,
            limb1: 0x8a58491815c7656292a77d29,
            limb2: 0x261e3516c348ae12,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xccb3ff79c694e37dfd96245c,
            limb1: 0x22190f1ae73883eea23de9ef,
            limb2: 0x20a63d2ddd9170cb,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xc2d93202f4bc4125b32a040f,
            limb1: 0x878fad8024db67f55bb868ad,
            limb2: 0x19f19dfc985e42b4,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xeed43376f2c4880094eb048b,
            limb1: 0x8c113b83e273d1c9e467294,
            limb2: 0x14c7cf40ca1595d1,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x3a25b6562577b927dce53ee6,
            limb1: 0xd87119330d4005ed54acb4c5,
            limb2: 0x2eda2b2bb0c37f0e,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x2bfa32f0a09c3e2cfb8f6a38,
            limb1: 0x7a24df3ff3c7119a59d49318,
            limb2: 0x10e42281d64907ba,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xce42177a66cdeb4207d11e0c,
            limb1: 0x3322aa425a9ca270152372ad,
            limb2: 0x2f7fa83db407600c,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x62a8ff94fd1c7b9035af4446,
            limb1: 0x3ad500601bbb6e7ed1301377,
            limb2: 0x254d253ca06928f,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xf8f1787cd8e730c904b4386d,
            limb1: 0x7fd3744349918d62c42d24cc,
            limb2: 0x28a05e105d652eb8,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x6ef31e059d602897fa8e80a8,
            limb1: 0x66a0710847b6609ceda5140,
            limb2: 0x228c0e568f1eb9c0,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x7b47b1b133c1297b45cdd79b,
            limb1: 0x6b4f04ed71b58dafd06b527b,
            limb2: 0x13ae6db5254df01a,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xbeca2fccf7d0754dcf23ddda,
            limb1: 0xe3d0bcd7d9496d1e5afb0a59,
            limb2: 0x305a0afb142cf442,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x2d299847431477c899560ecf,
            limb1: 0xbcd9e6c30bedee116b043d8d,
            limb2: 0x79473a2a7438353,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x600b4b9519e953b3ee0e8c95,
            limb1: 0x5521bdd3beeb7377b82d285d,
            limb2: 0x18d5f5e49adfcbc7,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xd5da0bb68787af76cb5c5d9f,
            limb1: 0x75637ba2a835852f330b73c9,
            limb2: 0x547e04907fd564d,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x2ee91610a62eaa46e2df5e41,
            limb1: 0x4326c823b5fdae59ff826534,
            limb2: 0x2f7f8d90704505d2,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x603491072f5e6e9336e946e6,
            limb1: 0xf60cf3ac408aed3af2d2e97b,
            limb2: 0x2eb99a813ff2d8c2,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x350da7c3e0673cf3f43b36a2,
            limb1: 0x538deac84e666e5410d11977,
            limb2: 0x12cd3b832ded258,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x48f25dd2ac7a858423fb6067,
            limb1: 0xd065e44fc48bf19dd02adc4d,
            limb2: 0xb645848420703f3,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x195a790100143ea9110ceda1,
            limb1: 0x20b1e1e4a731d94efa584cc5,
            limb2: 0xf8b3a6618e4d7ce,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x614c9b88c1a7229f818fec48,
            limb1: 0x4c165313932d060fee7871d7,
            limb2: 0x2e152a41f78cb225,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x65b71fe695e7ccd4b460dace,
            limb1: 0xa6ceba62ef334e6fe91301d5,
            limb2: 0x299f578d0f3554e6,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xaf781dd030a274e7ecf0cfa4,
            limb1: 0x2095020d373a14d7967797aa,
            limb2: 0x6a7f9df6f185bf8,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x8e91e2dba67d130a0b274df3,
            limb1: 0xe192a19fce285c12c6770089,
            limb2: 0x6e9acf4205c2e22,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xbcd5c206b5f9c77d667189bf,
            limb1: 0x656a7e2ebc78255d5242ca9,
            limb2: 0x25f43fec41d2b245,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xb1640d670c5c42ea39c8645c,
            limb1: 0xa18224b68a1319ba86f825f4,
            limb2: 0x17d223ba44cd11d8,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x375310f6e347ed50ecfdb77f,
            limb1: 0x6e63ffec719272c6a7aee308,
            limb2: 0x12641a4735391a7d,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x5e6ca7022b2145d736b05d42,
            limb1: 0xf3e3c6f9b543e2e50981a13d,
            limb2: 0x1c6256a011a7141d,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xf19cf9a30aba1b73475bd2e1,
            limb1: 0xdad570fd4dfe617364253c2e,
            limb2: 0x1887c3b2804d9969,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x4e56e6733cce20d9c5b16d96,
            limb1: 0xc7ef260535fb75b9d3e089f,
            limb2: 0x292dd4aa636e7729,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x6e7e1038b336f36519c9faaf,
            limb1: 0x3c66bd609510309485e225c7,
            limb2: 0x10cacac137411eb,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x4a3e8b96278ac092fe4f3b15,
            limb1: 0xba47e583e2750b42f93c9631,
            limb2: 0x125da6bd69495bb9,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xae7a56ab4b959a5f6060d529,
            limb1: 0xc3c263bfd58c0030c063a48e,
            limb2: 0x2f4d15f13fae788c,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x301e0885c84d273b6d323124,
            limb1: 0x11fd5c75e269f7a30fa4154f,
            limb2: 0x19afdcfdcce2fc0d,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x3d13519f934526be815c38b0,
            limb1: 0xd43735909547da73838874fc,
            limb2: 0x255d8aca30f4e0f6,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x90a505b76f25a3396e2cea79,
            limb1: 0x3957a2d0848c54b9079fc114,
            limb2: 0x1ba0cd3a9fe6d4bb,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xc47930fba77a46ebb1db30a9,
            limb1: 0x993a1cb166e9d40bebab02b2,
            limb2: 0x1deb16166d48118b,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x4cd552da29fd9e651de0c8e2,
            limb1: 0xcc66e31a0c0f35da5393e234,
            limb2: 0x42aae7aba0de5d3,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x4ec69646eae3453b41574b3d,
            limb1: 0x3600bbee129f0eb4a09e5097,
            limb2: 0xd759ae3f0b2e8e,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xa098f16a71c8341329b1faad,
            limb1: 0xb3eab89ea27edf122016c983,
            limb2: 0x180cc8977130fe33,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xf8c7bee62fa29f3dcd7d52e,
            limb1: 0xe43d14e1cb4f03890d983fc9,
            limb2: 0x1bbf95afef389b1c,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x44e4b10ad926a88d371adac0,
            limb1: 0xb3b1d13d9118e162063df933,
            limb2: 0x21f73fdf31a07aab,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xd14093e583f58b3af5ae4db5,
            limb1: 0x827dd1bbff5a346179ad72b6,
            limb2: 0x2ebf5e6b9398b99,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x29134bd0139058c474b7afa2,
            limb1: 0xdca7021954756e1ac4eac6cc,
            limb2: 0x26f440512341e287,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x6c1e14e15abb23010dc1e33a,
            limb1: 0xe96c50d655a06866163356cd,
            limb2: 0x1f4a622ecad37469,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xb15bbaec50ff49d30e49f74a,
            limb1: 0xc90a8c79fb045c5468f14151,
            limb2: 0x25e47927e92df0e3,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x57f66909d5d40dfb8c7b4d5c,
            limb1: 0xea5265282e2139c48c1953f2,
            limb2: 0x2d7f5e6aff2381f6,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x2a2f573b189a3c8832231394,
            limb1: 0x738abc15844895ffd4733587,
            limb2: 0x20aa11739c4b9bb4,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x51695ec614f1ff4cce2f65d1,
            limb1: 0x6765aae6cb895a2406a6dd7e,
            limb2: 0x1126ee431c522da0,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x789cfeffdbc8dab4651b6a26,
            limb1: 0x9709af4c379fbf84608e067b,
            limb2: 0xdbc2e8191a825bf,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x86c0cc51d698fc12702f534f,
            limb1: 0x6888fbb5d2f53711495f5bd2,
            limb2: 0x2c192d6229821616,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x51c5533eb07345679f648982,
            limb1: 0xa08ae72cfd598899b1cfc8ac,
            limb2: 0x26557347bd8f0ef8,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x749300bfda23c67cefec814a,
            limb1: 0x8bfdcaf7b0e1774c2238299c,
            limb2: 0x5b310a47c2757be,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x9214fc3209f1518b05fd21c6,
            limb1: 0x9bc8ce4f56423009710770e8,
            limb2: 0x32445cc6972799c,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x93ef401ecd9cfae3644d22e6,
            limb1: 0xce5a741a9847a144cfaf8c96,
            limb2: 0xf7a814d5726da4a,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xd19264d986f163b133a91c0c,
            limb1: 0x529dc5ce4b193c0f672c6a32,
            limb2: 0x2e9a118959353374,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x3d97d6e8f45072cc9e85e412,
            limb1: 0x4dafecb04c3bb23c374f0486,
            limb2: 0xa174dd4ac8ee628,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xe0decaadc4a6f0ba8f9bef29,
            limb1: 0xedcb07e1177fa819f638157b,
            limb2: 0x250c15a64da6f7e5,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x95f4d7c766ce8f325a768fc6,
            limb1: 0x470a0797ad6c0afcfeb285a5,
            limb2: 0x283e4ee1041ce0ef,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x8b4de3ce49b6e957c99abaa3,
            limb1: 0xb3f53ce50c860f9232a19797,
            limb2: 0x178ba1cb5c741f25,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xd0665772d47dcae22fac6c39,
            limb1: 0x904d57afdd91e177f3f871fb,
            limb2: 0x15a3517d026d204a,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x98d8b0c4adcf27bceb305c2c,
            limb1: 0x859afa9c7668ed6152d8cba3,
            limb2: 0x29e7694f46e3a272,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x1d970845365594307ba97556,
            limb1: 0xd002d93ad793e154afe5b49b,
            limb2: 0x12ca77d3fb8eee63,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x9f2934faefb8268e20d0e337,
            limb1: 0xbc4b5e1ec056881319f08766,
            limb2: 0x2e103461759a9ee4,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x7adc6cb87d6b43000e2466b6,
            limb1: 0x65e5cefa42b25a7ee8925fa6,
            limb2: 0x2560115898d7362a,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xe27a38a6ce9cdfb13f9c8286,
            limb1: 0xeb63852dd134515d2d71cca4,
            limb2: 0xfc2f00d7f215816,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xfc16f37b3bc5798c84900f79,
            limb1: 0x83e431402739fa2dec80fe3a,
            limb2: 0x282a3a6c64efd070,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xa16f756a6c64bced06a5309,
            limb1: 0x363b474c08a16450efe71ff0,
            limb2: 0xa6d4ebe758d6f36,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x3982faffb05ae6b720c25980,
            limb1: 0xf3343c79e7656f32b7fcd2c2,
            limb2: 0x131f7ba1d69acc0,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x64d864643668392c0e357cc4,
            limb1: 0x4c9bf66853f1b287015ab84c,
            limb2: 0x2f5f1b92ad7ee4d4,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xdc33c8da5c575eef6987a0e1,
            limb1: 0x51cc07c7ef28e1b8d934bc32,
            limb2: 0x2358d94a17ec2a44,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xf659845b829bbba363a2497b,
            limb1: 0x440f348e4e7bed1fb1eb47b2,
            limb2: 0x1ad0eaab0fb0bdab,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x1944bb6901a1af6ea9afa6fc,
            limb1: 0x132319df135dedddf5baae67,
            limb2: 0x52598294643a4aa,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x76fd94c5e6f17fa6741bd7de,
            limb1: 0xc2e0831024f67d21013e0bdd,
            limb2: 0x21e2af6a43119665,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xad290eab38c64c0d8b13879b,
            limb1: 0xdd67f881be32b09d9a6c76a0,
            limb2: 0x8000712ce0392f2,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xd30a46f4ba2dee3c7ace0a37,
            limb1: 0x3914314f4ec56ff61e2c29e,
            limb2: 0x22ae1ba6cd84d822,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x5d888a78f6dfce9e7544f142,
            limb1: 0x9439156de974d3fb6d6bda6e,
            limb2: 0x106c8f9a27d41a4f,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xef94f7e14e43d05d5dc2a5db,
            limb1: 0x4e730ef91962d53d5c144d45,
            limb2: 0x20c9f09ee430fc34,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xa26d6c5d462131f93142d52e,
            limb1: 0xddc49643f51ee6cabe8581db,
            limb2: 0x13752caf1cbc8d5c,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xf8c77031a63d9e67f9cc1728,
            limb1: 0x40ecf28120f0408a120e9543,
            limb2: 0x53bc5d43cd08518,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x2ff127952b99119f98242817,
            limb1: 0xe63c504a65debdba3a64a2a3,
            limb2: 0xfbcb43f42a22fa6,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x630d73532bae9432978d34ff,
            limb1: 0xe4a093616a16f8e01725dacf,
            limb2: 0xd61e1e87abe2d12,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x3d565745a48f3955ef821005,
            limb1: 0x7cdb83651ff9aa4ef947961d,
            limb2: 0x7d5b56b1d0a908f,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xf25332dd3bf9a4dab863f549,
            limb1: 0xf99418f7ce25f482560b7701,
            limb2: 0x17bd8e06468f8145,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x4b0de83ffea0e589fc53d3a3,
            limb1: 0x96bde86047edd08f7d63568b,
            limb2: 0x30d5ab74cb92f3,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x92c09e4796207b802168341b,
            limb1: 0xd2d9d6acffd7829066cc49ce,
            limb2: 0xc89c2d0a7b2c81e,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x47e3c1cf6cdb6f3efe778c7f,
            limb1: 0x66b347099b6436794cf062eb,
            limb2: 0x18b4ccc64ae0a857,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x7d5793606a73b2740c71484a,
            limb1: 0xa0070135ca2dc571b28e3c9c,
            limb2: 0x1bc03576e04b94cf,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x1ba85b29875e638c10f16c99,
            limb1: 0x158f2f2acc3c2300bb9f9225,
            limb2: 0x42d8a8c36ea97c6,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xd97e0326411cc47c8ddf6cc0,
            limb1: 0xedd2060bcddeab614c518345,
            limb2: 0x239a5cadf3237a4c,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xcf2af0314a2d2a3bf1547087,
            limb1: 0x7b7e846df9427bc1372f694e,
            limb2: 0x8af0c75ccf976e1,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x6b595ad762f8b423178a5193,
            limb1: 0x878023a4a74f60fa4c38551d,
            limb2: 0xfe35f515dd9c4b0,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x42ef091d46c538aacf95bd37,
            limb1: 0xe51c322ac17cc06c2da7a4ef,
            limb2: 0x145b8ddb9dd19415,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x9440ad13408319cecb07087b,
            limb1: 0x537afc0c0cfe8ff761c24e08,
            limb2: 0x48e4ac10081048d,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xa37fb82b03a2c0bb2aa50c4f,
            limb1: 0xd3797f05c8fb84f6b630dfb,
            limb2: 0x2dffde2d6c7e43ff,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xc55d2eb1ea953275e780e65b,
            limb1: 0xe141cf680cab57483c02e4c7,
            limb2: 0x1b71395ce5ce20ae,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xe4fab521f1212a1d301065de,
            limb1: 0x4f8d31c78df3dbe4ab721ef2,
            limb2: 0x2828f21554706a0e,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x8cefc2f2af2a3082b790784e,
            limb1: 0x97ac13b37c6fbfc736a3d456,
            limb2: 0x683b1cdffd60acd,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xa266a8188a8c933dcffe2d02,
            limb1: 0x18d3934c1838d7bce81b2eeb,
            limb2: 0x206ac5cdda42377,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x90332652437f6e177dc3b28c,
            limb1: 0x75bd8199433d607735414ee8,
            limb2: 0x29d6842d8298cf7e,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xadedf46d8ea11932db0018e1,
            limb1: 0xbc7239ae9d1453258037befb,
            limb2: 0x22e7ebdd72c6f7a1,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x66c7ba638481b515f47a47c,
            limb1: 0x65816eb626f569ff9a70086,
            limb2: 0x1c76016adf110695,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x199bb5ce01eed8832bffe868,
            limb1: 0xebc07bcbec47e8dacaccaa61,
            limb2: 0x300f40e8fb08f35b,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x1117803a9b699abce47fc1a8,
            limb1: 0x9f777c5f5e1fc6e3669c18fb,
            limb2: 0x1daa971b94559380,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x5eaa67a030b5bca05aa5fb15,
            limb1: 0x5c3219862943bebd194b2f50,
            limb2: 0x2adfacb421dcf6a7,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x74939dcacb9e9e2b711e8447,
            limb1: 0xf9ad27eef11cbbc8b3ab249e,
            limb2: 0x11aab57aeb6656ce,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xa9f5cb1a26ce6c0257dd7da9,
            limb1: 0x8e135e3fac96755521af3f2c,
            limb2: 0x276dbb0ae508576b,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xc3cb26994a44bc35fe3619ba,
            limb1: 0xec35244c6c46a69c781e84ed,
            limb2: 0xc9c12355c7afba0,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x886847b97e3bc0b7dec24b8e,
            limb1: 0x3ef24e4c1bd0f2a40ec42a4f,
            limb2: 0x4f303d145c4a8e1,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x348e15357d9299e582033136,
            limb1: 0x53578c46b15abb39da35a56e,
            limb2: 0x1043b711f86bb33f,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x9fa230a629b75217f0518e7c,
            limb1: 0x77012a4bb8751322a406024d,
            limb2: 0x121e2d845d972695,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x5600f2d51f21d9dfac35eb10,
            limb1: 0x6fde61f876fb76611fb86c1a,
            limb2: 0x2bf4fbaf5bd0d0df,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xd732aa0b6161aaffdae95324,
            limb1: 0xb3c4f8c3770402d245692464,
            limb2: 0x2a0f1740a293e6f0,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x5ee47e2aec7d88c58896ef36,
            limb1: 0x894bd20abe674c0208e35a93,
            limb2: 0x1a42417dc0038755,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x8bba265a6ba9c5bd6c17788d,
            limb1: 0x43709c02f70bc99b6d6927cb,
            limb2: 0xb456dc8d4bbbd49,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x368d2f5f3940fe781a54de5c,
            limb1: 0x611afd760bcdd16d7e5098fd,
            limb2: 0x2602a5e773cb12a0,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x70b8eaf8db4b85dec76261af,
            limb1: 0xd8b6dbb7ad62764263175efc,
            limb2: 0x27797f327aa59ac1,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xa9e2efa41aaa98ab59728940,
            limb1: 0x163c0425f66ce72daef2f53e,
            limb2: 0x2feaf1b1770aa7d8,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x3bb7afd3c0a79b6ac2c4c063,
            limb1: 0xee5cb42e8b2bc999e312e032,
            limb2: 0x1af2071ae77151c3,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x1cef1c0d8956d7ceb2b162e7,
            limb1: 0x202b4af9e51edfc81a943ded,
            limb2: 0xc9e943ffbdcfdcb,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xe18b1b34798b0a18d5ad43dd,
            limb1: 0x55e8237731941007099af6b8,
            limb2: 0x1472c0290db54042,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x91080fd5aaedc517d9cd2fa,
            limb1: 0x3edc290fc4568f8f972c94a6,
            limb2: 0x2535859135a1ab3a,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x626ef15bd0158b028321fabc,
            limb1: 0x511811c5a645349dc6e8c96,
            limb2: 0x5ea2a954421df52,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x532b1df5972f804688da2382,
            limb1: 0x1eb61d485a40951340c80738,
            limb2: 0x2a8354857d28abef,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x9b597bfbeec11cc3e137309f,
            limb1: 0xe36ae879e4cd9dd54c6daee4,
            limb2: 0x1408ffb495b57485,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xb4c7963e0d1dc082de0725e,
            limb1: 0x375a7a3d765918de24804223,
            limb2: 0xf177b77b031596d,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x87a7b9c5f10500b0b40d7a1e,
            limb1: 0x6f234d1dc7f1394b55858810,
            limb2: 0x26288146660a3914,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xa6308c89cebe40447abf4a9a,
            limb1: 0x657f0fdda13b1f8ee314c22,
            limb2: 0x1701aabc250a9cc7,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x9db9bf660dc77cbe2788a755,
            limb1: 0xbdf9c1c15a4bd502a119fb98,
            limb2: 0x14b4de3d26bd66e1,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x53c49c62ca96007e14435295,
            limb1: 0x85aeb885e4123ca8d3232fdf,
            limb2: 0x750017ce108abf3,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xba6bf3e25d370182e4821239,
            limb1: 0x39de83bf370bd2ba116e8405,
            limb2: 0x2b8417a72ba6d940,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xa922f50550d349849b14307b,
            limb1: 0x569766b6feca6143a5ddde9d,
            limb2: 0x2c3c6765b25a01d,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x6016011bdc3b506563b0f117,
            limb1: 0xbab4932beab93dde9b5b8a5c,
            limb2: 0x1bf3f698de0ace60,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x11925aacbbb5a16eea984791,
            limb1: 0xbd44a32451e02b8dd9f93e3e,
            limb2: 0x283613cb34ee08bc,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x3bcfcf29d56dda88972d2e0d,
            limb1: 0x6378f8cff10778665c7e0431,
            limb2: 0x252094f8a37eb910,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x3953dbc38e645187bfc5ddab,
            limb1: 0xfe6c4a8af9eeb0cffcd42f62,
            limb2: 0x298a4e0b8e41a39e,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x50df906117b055421a37fee6,
            limb1: 0x1bcce56c872adfa5e9664632,
            limb2: 0x26a263c500419a69,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xe1aad2fb2c3aa84b9a6beede,
            limb1: 0x656ebc5334eace7fe81e6f1,
            limb2: 0xe5a68ce75fd9809,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x6e38dd74d56cc193ab28c18d,
            limb1: 0x489b415a49586e4213e4cab4,
            limb2: 0x4b5ae00bb5fb138,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x710bb610c2843aa686ba9adb,
            limb1: 0x4035dfa11017ac938fb7892d,
            limb2: 0x457e16957861fe5,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x61849b4cb86ead8d7c3d94f1,
            limb1: 0x518f095dd852d4beac73d260,
            limb2: 0x1d7fa08317c2a29,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xb9f05ffda3ee208f990ff3a8,
            limb1: 0x6201d08440b28ea672b9ea93,
            limb2: 0x1ed60e5a5e778b42,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x8e8468b937854c9c00582d36,
            limb1: 0x7888fa8b2850a0c555adb743,
            limb2: 0xd1342bd01402f29,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xf5c4c66a974d45ec754b3873,
            limb1: 0x34322544ed59f01c835dd28b,
            limb2: 0x10fe4487a871a419,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xedf4af2df7c13d6340069716,
            limb1: 0x8592eea593ece446e8b2c83b,
            limb2: 0x12f9280ce8248724,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x560d1b6e56d813240424b220,
            limb1: 0x78cb46b213324960bc655587,
            limb2: 0x179c996c56c57046,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x83a2ba9b9558fad3cde16856,
            limb1: 0x391e9dc2ffb59f519ae1d2b3,
            limb2: 0x121abd4bd4ae70f1,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x90bb5fac7393b89ce8774706,
            limb1: 0xe528a21777490d65bbb2a59,
            limb2: 0x17649453b4e6f63f,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xa19760f6b2fff23302d184b9,
            limb1: 0x4a5200e9c1f545101ae7368f,
            limb2: 0x8a9b7df65fb2553,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xe67f72c6d45f1bb04403139f,
            limb1: 0x9233e2a95d3f3c3ff2f7e5b8,
            limb2: 0x1f931e8e4343b028,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x20ef53907af71803ce3ca5ca,
            limb1: 0xd99b6637ee9c73150b503ea4,
            limb2: 0x1c9759def8a98ea8,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xa0a3b24c9089d224822fad53,
            limb1: 0xdfa2081342a7a895062f3e50,
            limb2: 0x185e8cf6b3e494e6,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x8752a12394b29d0ba799e476,
            limb1: 0x1493421da067a42e7f3d0f8f,
            limb2: 0x67e7fa3e3035edf,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x9d2e2392b2116806c3c64bea,
            limb1: 0xbc4c1ea53ab2140ee4675a09,
            limb2: 0x10ce261919b09742,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xf14f468e5ab675c5fc2db1de,
            limb1: 0x75de3f46adfc7aba3ce6f8f6,
            limb2: 0x2bfcacc6c8f0370a,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xa138d127e5eb4d3aa9e483f7,
            limb1: 0x44836fa24f3f8db5aa663f2f,
            limb2: 0x12a4a7236c8b0338,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xd6fdaced0679398f5aefc808,
            limb1: 0x41971bc9ddff0109a6d83fb3,
            limb2: 0x1a11d202adb75ba9,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x6d6138c95464e5e774ae7ba0,
            limb1: 0xe6ca73a5498e4ccd4bb68fc7,
            limb2: 0x15bf8aa8ed1beff6,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xabd7c55a134ed405b4966d3c,
            limb1: 0xe69dd725ccc4f9dd537fe558,
            limb2: 0x2df4a03e2588a8f1,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x7cf42890de0355ffc2480d46,
            limb1: 0xe33c2ad9627bcb4b028c2358,
            limb2: 0x2a18767b40de20bd,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x79737d4a87fab560f3d811c6,
            limb1: 0xa88fee5629b91721f2ccdcf7,
            limb2: 0x2b51c831d3404d5e,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x9c6a908d0b5cceccb463a4e5,
            limb1: 0xde65283103f2cb5e00e981d0,
            limb2: 0x2e94465a4f7f92d5,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x1ce77bed9f2198292f766f43,
            limb1: 0x8a65ff87da43dd4b4620ff1,
            limb2: 0xa93dc2061770b84,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xd4fee00640a18279b3b99d6d,
            limb1: 0xcbfac423ce971d800796de34,
            limb2: 0x69fab7bbec03f8d,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xdb42c8aa3f576a04e6740b62,
            limb1: 0xc6c8a94fd3bf4e501d88ab20,
            limb2: 0x1b918d10cac3a421,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x9812f6145cf7e949fa207f20,
            limb1: 0x4061c36b08d5bcd408b14f19,
            limb2: 0x8332e08b2eb51ed,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xa4a7ae8f65ba180c523cb33,
            limb1: 0xb71fabbdc78b1128712d32a5,
            limb2: 0x2acd1052fd0fefa7,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x6ea5598e221f25bf27efc618,
            limb1: 0xa2c2521a6dd8f306f86d6db7,
            limb2: 0x13af144288655944,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xea469c4b390716a6810fff5d,
            limb1: 0xf8052694d0fdd3f40b596c20,
            limb2: 0x24d0ea6c86e48c5c,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x2e39be614d904bafea58a8cd,
            limb1: 0xf53f0a6a20a1f1783b0ea2d0,
            limb2: 0x99c451b7bb726d7,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x28ec54a4ca8da838800c573d,
            limb1: 0xb78365fa47b5e192307b7b87,
            limb2: 0x2df87aa88e012fec,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xfb7022881c6a6fdfb18de4aa,
            limb1: 0xb9bd30f0e93c5b93ad333bab,
            limb2: 0x1dd20cbccdeb9924,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x16d8dfdf790a6be16a0e55ba,
            limb1: 0x90ab884395509b9a264472d4,
            limb2: 0xeaec571657b6e9d,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xaf4fdd1b70eabcd772d77aa1,
            limb1: 0xc88a9826c1e8212a26e0430d,
            limb2: 0x203f7c97e4a936aa,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xe2f0c2ac8588b3fa35eb69db,
            limb1: 0x9bdff7e3611ef6dbded516b4,
            limb2: 0x301305ee3abf1df8,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xdc0fa9fcb28f71f07f9f23ee,
            limb1: 0x1145e7453873b8c7d35aa6c2,
            limb2: 0x6031f980cdf1d85,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x3050ba620d13a3ad894b2ce8,
            limb1: 0xe82eaab452c4c0a973f4d11d,
            limb2: 0x66de04fb2119c6f,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x6c5b064e3183ed4bd22126b0,
            limb1: 0x207825012a83cbe1cf0ece60,
            limb2: 0x20721baaf24053f9,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x1142829a0afaf2b457220e6,
            limb1: 0x9bd5bf8bdeccec5ad7930329,
            limb2: 0x48227f6b84c3faa,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xba19284d0535c775b1bcc0bf,
            limb1: 0xcb888ba30fb7151496773d0d,
            limb2: 0x198d7753b2b23cab,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x5c4ec7550d765e8206535706,
            limb1: 0x56764841e2adda1dacf343c2,
            limb2: 0x190bf2077e521671,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xce78fc6505db036c10fac771,
            limb1: 0x61f8c0bc7f60ad6415d5e419,
            limb2: 0x59009c5cf9ea663,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xb3b3f697fc34d64ba053b914,
            limb1: 0x317af5815ce5bfffc5a6bc97,
            limb2: 0x23f97fee4deda847,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xf559e09cf7a02674ac2fa642,
            limb1: 0x4fa7548b79cdd054e203689c,
            limb2: 0x2173b379d546fb47,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x758feb5b51caccff9da0f78f,
            limb1: 0xd7f37a1008233b74c4894f55,
            limb2: 0x917c640b4b9627e,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x44238d6942472eaaaa3c0148,
            limb1: 0x423cad960738a7343451af0a,
            limb2: 0x6d7ac995669fbe6,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x21d741021875ef3da0560516,
            limb1: 0x3680532e586a90e40215d90e,
            limb2: 0x1b91e2d44c10969a,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x35753f4be838d08ac282e162,
            limb1: 0x9cc59d882fa9d2c39d2ac29d,
            limb2: 0x68249cbe65852ed,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x33f63b6378843d4aa5d24138,
            limb1: 0xc55953e8ba9dda553c73f3ba,
            limb2: 0x17f2ff3634a5ca7,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x72548e0d946b796842cfecd8,
            limb1: 0x78b54b355e3c26476b0fab82,
            limb2: 0x2dc9f32c90b6ba31,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xa943be83a6fc90414320753b,
            limb1: 0xd708fde97241095833ce5a08,
            limb2: 0x142111e6a73d2e82,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xc79e8d5465ec5f28781e30a2,
            limb1: 0x697fb9430b9ad050ced6cce,
            limb2: 0x1a9d647149842c53,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x9bab496952559362586725cd,
            limb1: 0xbe78e5a416d9665be64806de,
            limb2: 0x147b550afb4b8b84,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x9e86dd914a2f547b23018fed,
            limb1: 0xf7705b16ccf6e1f5eb2c0ab3,
            limb2: 0x393f6b3257d8b29,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x501fcdb81a813fe07121b423,
            limb1: 0x87f73c02d3918e27053880f5,
            limb2: 0x5250523c8eefc8e,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xb92c92400b5ff996ac4cb9d8,
            limb1: 0xa121f8c7742792c161dc87fa,
            limb2: 0x1ee9797cbb430d7f,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x4db126149d0e1ee2fe5cb1b6,
            limb1: 0x7e31c6486612929a0807aa58,
            limb2: 0x5fa8f994639085b,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x8f80372a5d30c11866367205,
            limb1: 0x92e9cc1f618c73b8762e0523,
            limb2: 0x1cb9bf76a0a6db6d,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x293cb56aaf55c4a418de7939,
            limb1: 0x9061b52d673fc6474d5d2ec6,
            limb2: 0xc24a88a27db4304,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xfae9691d64b96f838d1509a6,
            limb1: 0xe3ebd8cc8c12ee7c7438d287,
            limb2: 0x4f7d5aace5c9cbb,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xfe9bba812fb35a424ac01042,
            limb1: 0xd8227529f642afbffba310a2,
            limb2: 0x19e1ef4a9e6bc2c7,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x362baefb8f57b2e6a249f48f,
            limb1: 0xfdfc392121e0cba4da8716ab,
            limb2: 0x27f4fe2f7cdce208,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xbc71a95c687cfc2581ff49ab,
            limb1: 0x9e83fb6f4670641cea2bf33c,
            limb2: 0x26824c59fbbbf8c6,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xe5dc8dc98a6ed9dcbb47aed3,
            limb1: 0x8d0e252e3bc1e62ff6e363e5,
            limb2: 0x8f1e862285f484e,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xaf1066f6017908760cbad294,
            limb1: 0xac2ac7cc2e269b8157317617,
            limb2: 0x1c2d143080334a6e,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xa87fbe3225d1e36de9a39119,
            limb1: 0x7beafc3d9a2d3dc6a50feefd,
            limb2: 0x33ca7625fb1535f,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x8a757475b81526b6d59609f2,
            limb1: 0xb94ed9c6a470ab4d32e1ec7b,
            limb2: 0xf11d5a30e186e66,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x1d90d004a19272062b5b2268,
            limb1: 0xa9eb34c66393877c0aaf5b00,
            limb2: 0x2201a04ee70317ca,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x41776727dcde923640d5ff3f,
            limb1: 0x2ed13f7486d76eabfd079a1d,
            limb2: 0x2acc28819a743617,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xe8e701a6f585814ecf19e40a,
            limb1: 0x3c595a7fcf43dfefc48c88e6,
            limb2: 0x1d87541ec7506214,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x4b60107071411f061d94a658,
            limb1: 0x6bc55539da7866ef0547b439,
            limb2: 0x16c27eefc1710d61,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x301f8acc220048fe8d9476d3,
            limb1: 0x52cdfaa6441f9f824e35caa8,
            limb2: 0xd756297b794db35,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xfd31c5aa439e752feae3a8ee,
            limb1: 0xfeeb0a3e30edd324f4c65c02,
            limb2: 0x2b32bd3a5c22d1a6,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xe75a152a0ead18c25282c6d3,
            limb1: 0xb0d72c10d07a8d407754b5cf,
            limb2: 0x20edfb4c3eb32f52,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x9e44d92fd4662163c09e342a,
            limb1: 0xf8c146fa613ae972f2579778,
            limb2: 0x1d47df2cd9d145c0,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xa60a29a41f1ac24c4980ace8,
            limb1: 0x4dfe8eccc89b694d266a6df2,
            limb2: 0xd9fb0aa54d9a656,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x827e86042644b9065d8a67ad,
            limb1: 0xff36cdfc51e3cc6dcdd31e57,
            limb2: 0x167350a55193a421,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x8e371bfcb3aca04e4f9802e,
            limb1: 0x5e5d8f6b6322c09e2b75a152,
            limb2: 0x1d647f1fa203a822,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xa3c891fd675ce6db3c01b45b,
            limb1: 0x7445c019e9f589f202de8d85,
            limb2: 0x8c5600d97f464c7,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xaf2ab453ab52ff4a166c34ad,
            limb1: 0xe1b0bcced5af0518f26ca5a0,
            limb2: 0x20f8082714d5af5e,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x5e140ddd1583671016d9d125,
            limb1: 0x5d4a8bf73d93123766d48d6f,
            limb2: 0x17fa8ce34aec9aa5,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x68a526d9ea6118e158e31cb3,
            limb1: 0xad51cc1c2ffcc79d6384408b,
            limb2: 0x17b8f0f13d10166b,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x7ae040f9252d2f1af85411f3,
            limb1: 0x9b29a187e0f69b41bc178fdc,
            limb2: 0x11007f2c3df1a29e,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x3f42c58ad30ae3fc103bdeef,
            limb1: 0x4d17f4ced0da9077fae500f4,
            limb2: 0x2fa3ae90118579a5,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xa5f9e1c6313ff323dac59832,
            limb1: 0x26c44fec5db7e1c30f14a016,
            limb2: 0x24d6be303d2666bb,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x78603a6e0a37510ed26626c0,
            limb1: 0x7e55edd07c496de6f1a0a0f7,
            limb2: 0x12177aa4bc1c9f46,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x3538104d6123cbb8f9816f7a,
            limb1: 0x55894681460cae4208e48146,
            limb2: 0x222e4d7027019480,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xdcd7f1d9cdc09b89f51e4f28,
            limb1: 0x7466f9cbb0c39f493d55c4da,
            limb2: 0x1d3d4ba283ce55be,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x2c3464ae148a10576c5c8962,
            limb1: 0x9fa925f9a829284ce5df89d5,
            limb2: 0x7dd8ac73c0fd0b8,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x4281d1c79f5648fb9275a1b1,
            limb1: 0xb2912a7c188e49f61f6d38e4,
            limb2: 0x7c49fe0422525ed,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x659edfb3fc39059e60b51f46,
            limb1: 0xa410b74fec5b2f1ed4a2a1ee,
            limb2: 0x222fd6224e50e4fc,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x93e80b6e5dc76f5f16f0c8a,
            limb1: 0xd191be7023aa6a32ac1c9af8,
            limb2: 0x189d14afd7ba3e86,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x6a9321bde444669ee3d19a8b,
            limb1: 0xf6b57ade4542c8d8292b0b3c,
            limb2: 0x28ba84d3ee7348dd,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x4b4ba7d743ee155d38847e70,
            limb1: 0x8e23b29742558a0a6be79177,
            limb2: 0x1615e98424b868c5,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x3380774aad93229f8986f211,
            limb1: 0x57532a0a248d3402494af2cc,
            limb2: 0xb84268333d3da1b,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x5f4dc9baeb603e4a6b4c3b7f,
            limb1: 0x34e8e58fa64dab9b05288bfb,
            limb2: 0x142ae11fa20dc9d9,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x7c911d521ddd3cb12b7dd157,
            limb1: 0xd8b6312bdb0338aedc694c7b,
            limb2: 0x1ad2ca18dd39c5fb,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xf2f6957c2aef822e7c699093,
            limb1: 0xc0df4c1538f98cc89c66ef7e,
            limb2: 0x249ed86afb7fbc7e,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x624bc714deaba06fc4e892df,
            limb1: 0xfc2a7b1769f1e083d5cbcc84,
            limb2: 0x1c43fd864769a2a9,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x93c152a553f04b0a9a3dba10,
            limb1: 0x96c08b23df9a462ca759cfaf,
            limb2: 0x282a4570ed94c48b,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xcda093129daa9f1546cb984d,
            limb1: 0xce343f2f28e4f0bd20294e2b,
            limb2: 0x25e35f07bde41372,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x58cb4fce4064a24e5b4a3bf6,
            limb1: 0x9c3ad0ed935ad93b25e9aa0c,
            limb2: 0x141f71e79d9ca88,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x304e90b6f6478c09a46a218b,
            limb1: 0xcf5f482d3c533d1911f072fa,
            limb2: 0x204f160450866f72,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xa63138beb46ad3440438492a,
            limb1: 0x5dd26e5e992f79e9ca56f65b,
            limb2: 0x178995ad2306b735,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xf1c8dd24d24cb6d38b4e7ab9,
            limb1: 0xcb09b4f44824a2b2ceabaab8,
            limb2: 0x278a4cdd4bc10088,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x14f2fb84256d0128365faf00,
            limb1: 0xa03644d859c70c7be40093c9,
            limb2: 0x27a1504b48003ae6,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x81e1cb2e54ed2716e47ebd0c,
            limb1: 0x3cc9bfedda5ba9e3c7d4daf7,
            limb2: 0x28af903e49caf485,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x88f536cd32cb46697a299b5d,
            limb1: 0xab6d2eef1fef6675ca04669d,
            limb2: 0xd7a2c815352d6e2,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xc6dba9d878f2d58a16ba0e3b,
            limb1: 0xb8ae60f84593f8b1f4b4ae9c,
            limb2: 0x1967d5cc94ebab10,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x2b6af476f520b4bf804415bc,
            limb1: 0xd949ee7f9e8874698b090fca,
            limb2: 0x34db5e5ec2180cf,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x3e06a324f038ac8abcfb28d7,
            limb1: 0xc2e6375b7a83c0a0145f8942,
            limb2: 0x2247e79161483763,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x708773d8ae3a13918382fb9d,
            limb1: 0xaf83f409556e32aa85ae92bf,
            limb2: 0x9af0a924ae43ba,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xa6fded212ff5b2ce79755af7,
            limb1: 0x55a2adfb2699ef5de6581b21,
            limb2: 0x2476e83cfe8daa5c,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x13df26de246b82e1c4006684,
            limb1: 0xdcb1f59fd7c2207bc5f08c12,
            limb2: 0x1ed7fbbc76888533,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x3031d98d0b4681f8f5cb6348,
            limb1: 0x3109096cfe8dfa2d62f28db9,
            limb2: 0x28acca54b41ec1b7,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xc85124d27f451b5aa2e5d92,
            limb1: 0x7ef16c0d9b4980cd2602c387,
            limb2: 0x2d5cf10f6c68bde2,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x4f9c425e09f9557e6f81e13a,
            limb1: 0x2acca9d9b4e04d054baf9ad9,
            limb2: 0x13257ab485ce67e1,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x2c12ab2f338cca45640fedfb,
            limb1: 0x41502b84b9a66e10102be299,
            limb2: 0x19dbe91c50592fb,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x343be7cac3ad44182acb33fa,
            limb1: 0xf3aa251c1a310cd439e988c,
            limb2: 0x1138da1418252cd,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xe7a3c13336a3bd1ce8bb3bb7,
            limb1: 0x502e66f432b52caca3602ad5,
            limb2: 0x17e6f3b7bc285d9,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x2b93c79b052f469f471affd1,
            limb1: 0xeaf5be1f527545bbb7a3adb3,
            limb2: 0x8ce6d14105d6914,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x1c4759bcf7c607fe3f839d4d,
            limb1: 0xea91f311da73327e2ed40785,
            limb2: 0x2017052c72360f42,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x38cf8a4368c0709980199fc3,
            limb1: 0xfc9047885996c19e84d7d4ea,
            limb2: 0x1795549eb0b97783,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xb70f7ecfbec0eaf46845e8cc,
            limb1: 0x9ddf274c2a9f89ea3bc4d66f,
            limb2: 0xcc6f106abfcf377,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xf6ff11ce29186237468c2698,
            limb1: 0x5c629ad27bb61e4826bb1313,
            limb2: 0x2014c6623f1fb55e,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xd1656f114bf3af72715dce80,
            limb1: 0x3924b0610de00ad47aab618b,
            limb2: 0xdaf00e1541db71b,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xb3da842bd6ed2cea6a87db4,
            limb1: 0x58009f786c9b9e946837049b,
            limb2: 0x10ec13144c9e560e,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x9a584d0f409607603126ee10,
            limb1: 0x1fa1a9bc1885cf6833992a19,
            limb2: 0x2c1aa3312c27750f,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x5f0eefa5064d95ff567b056e,
            limb1: 0xc9e066a9811570706974d0e2,
            limb2: 0x51ad56ec3cb6b21,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xc648054e4b6134bbfd68487f,
            limb1: 0xdf0506dad3f3d098c13a6386,
            limb2: 0x26bebeb6f46c2e8c,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x9d0cdb28a94204776c6e6ba6,
            limb1: 0x303f02dfe619752b1607951d,
            limb2: 0x1127d8b17ef2c064,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xe34ca1188b8db4e4694a696c,
            limb1: 0x243553602481d9b88ca1211,
            limb2: 0x1f8ef034831d0132,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xe3a5dfb1785690dad89ad10c,
            limb1: 0xd690b583ace24ba033dd23e0,
            limb2: 0x405d0709e110c03,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x464e5f2bfc2c82c54b03961,
            limb1: 0x951289dda0d75515cf27d76f,
            limb2: 0x18624def97e8d755,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x5f34b49ccba30273ef5b21d3,
            limb1: 0x2a5284c7f0a2edbd91cffc38,
            limb2: 0x152ee08fed176eb9,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x754bde9c6963db1bd70f1b6c,
            limb1: 0xdcd8ae0734741dc7f4c0963d,
            limb2: 0x1bdcdd889e8b7986,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xc256707edf7a02779c5570dd,
            limb1: 0x4e462d0c425dc89184d0d1e,
            limb2: 0x10a877ec918e3670,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x72cc2cef2785ce4ff4e9b7af,
            limb1: 0x60ed5b9c207d7f31fb6234ab,
            limb2: 0x1bb17a4bc7b643ed,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x9424eb15b502cde7927c7530,
            limb1: 0xa0e33edbbaa9de8e9c206059,
            limb2: 0x2b9a3a63bbf4af99,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x423811cb6386e606cf274a3c,
            limb1: 0x8adcc0e471ecfe526f56dc39,
            limb2: 0x9169a8660d14368,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xf616c863890c3c8e33127931,
            limb1: 0xcc9414078a6da6989dae6b91,
            limb2: 0x594d6a7e6b34ab2,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x6a5715d35321ab7e2303801a,
            limb1: 0xb3a10a033b8af85876120d84,
            limb2: 0x12a279df5f1f2e80,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x280110399cdfd7e0a95aaf62,
            limb1: 0xeaa755ebaf7edec0629ff916,
            limb2: 0x50373a52da2ad5f,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x835e28ff4627911ddd0ba983,
            limb1: 0x975aef2b304e4200963bd7e3,
            limb2: 0x2cfb54689f69ce06,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xf3002234938e41787edf31bd,
            limb1: 0x596978afc835ba1b55a81785,
            limb2: 0x6bd7658f61e8020,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xf2d619ae78049bf9141c35cf,
            limb1: 0x717f8b10d469a1ee2d91f191,
            limb2: 0x2c72c82fa8afe345,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xb89321223b82a2dc793c0185,
            limb1: 0x71506a0cf4adb8e51bb7b759,
            limb2: 0x2c13b92a98651492,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x4947ef2c89276f77f9d20942,
            limb1: 0xb454d68685ab6b6976e71ec5,
            limb2: 0x19a938d0e78a3593,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xbe883eb119609b489c01c905,
            limb1: 0xaa06779922047f52feac5ce6,
            limb2: 0x76977a3015dc164,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x43a96a588005043a46aadf2c,
            limb1: 0xa37b89d8a1784582f0c52126,
            limb2: 0x22e9ef3f5d4b2297,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x8c6f6d8474cf6e5a58468a31,
            limb1: 0xeb1ce6ac75930ef1c79b07e5,
            limb2: 0xf49839a756c7230,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x82b84693a656c8e8c1f962fd,
            limb1: 0x2c1c8918ae80282208b6b23d,
            limb2: 0x14d3504b5c8d428f,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x60ef4f4324d5619b60a3bb84,
            limb1: 0x6d3090caefeedbc33638c77a,
            limb2: 0x159264c370c89fec,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x9b53ea01ae2d6587ef6469bf,
            limb1: 0x51d2d907815a064277b460d3,
            limb2: 0x130bfb2966bccfcf,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x628e9808d554d47dd88c80f5,
            limb1: 0xc7b44de52f919e749a8af471,
            limb2: 0xf6a26faf4aee11a,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x73ce5d8301bbc53ee6e8239f,
            limb1: 0x31b030a8af445bd7d8e95c79,
            limb2: 0x295f54e9eb9fba58,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x535dbb6d10b88b2fd30f0c23,
            limb1: 0xa016d54da5f9a46174614196,
            limb2: 0x10dfe73e58fcb4bd,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x652eaf09821887db0de1f147,
            limb1: 0x75229b9972e31ba2e226bbcf,
            limb2: 0x161e5e72bf925c6d,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x856aa774394ef561669d1eab,
            limb1: 0xdd46a5dd8e6c4d775d36356d,
            limb2: 0x2d287f12b2a6700d,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x67ffd864a18bb2d4488c5d6a,
            limb1: 0x8d0ea9ad86d841741fe1d284,
            limb2: 0x43189ddb2f1e1cd,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xf42602a91d620c7003644ce4,
            limb1: 0x7d9f27e32a63153af2c65415,
            limb2: 0x1ee85832249a6300,
            limb3: 0x0
        }
    },
];

