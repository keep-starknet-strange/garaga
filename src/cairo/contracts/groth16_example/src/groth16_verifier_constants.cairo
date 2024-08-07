use garaga::definitions::{G1Point, G2Point, E12D, G2Line, u384};
use garaga::groth16::Groth16VerifyingKey;

pub const N_PUBLIC_INPUTS: usize = 2;

pub const vk: Groth16VerifyingKey =
    Groth16VerifyingKey {
        alpha_beta_miller_loop_result: E12D {
            w0: u384 {
                limb0: 0x888d5cdaf1ae2c964708eec5,
                limb1: 0xd95730fe1ca3fde115a4fa7d,
                limb2: 0x219d83c9e1da646e,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0x5e87822c32b8bf3b24d48824,
                limb1: 0x19695551799e067a5f23ef03,
                limb2: 0x4f75c1f92ea2f26,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0x29e7484166c938556c723f14,
                limb1: 0x84c3466fa94b809bf3b4d30a,
                limb2: 0x2c6a412f963a73c9,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0xdfbdd88921a5e3629c2ded94,
                limb1: 0x428a05fd6d53ec18ce7c5149,
                limb2: 0x5716c23454ca889,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0xaa439b907b998360c7d1dc60,
                limb1: 0x372c105945e4b1e1ebba9c4f,
                limb2: 0x1a2903e2bdd47c51,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0x1e836ba7e7a24e916c3f269e,
                limb1: 0x2576c5ba27f1549e9001d24a,
                limb2: 0x30027e379e07305e,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0x3613ba2191b9adcac47a8367,
                limb1: 0xf186882fc859bb645aef77fc,
                limb2: 0x153c517983b1cf47,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0x19db76054f7886dffc176f58,
                limb1: 0x677cbd2d5bb03a636d845ecf,
                limb2: 0x29b45066d937b09b,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0xe1cbb3256faa0d4bd97a5ee3,
                limb1: 0x7d54022433942f5d6ed135d6,
                limb2: 0x8472aa1ead12e8,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0x5f6ef92961d7d9c9b5e05ab2,
                limb1: 0xc513d63e2cd6b48cb90c9d79,
                limb2: 0x25c617bb57ccb123,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0x9ed1439bb8ddd111bc7655d3,
                limb1: 0x2a0b5cdade8b1d4f3c72895f,
                limb2: 0x2aab11c638569721,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0x905b14aeb2ac5c6ce90dc9e5,
                limb1: 0xb2c6cfa727a80e0499595090,
                limb2: 0x23f49b9a40fa66a6,
                limb3: 0x0
            }
        },
        gamma_g2: G2Point {
            x0: u384 {
                limb0: 0x89e732f5f87195d15a4ce637,
                limb1: 0x884359c76cc9c6b81d289d33,
                limb2: 0x3541dacedd860ef,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xe313e222b376d9a9da02f080,
                limb1: 0x272d9cc4aa2e71146c83c13b,
                limb2: 0x2eb7d1fa8416da97,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xa7d48b949e86c8b00eef73f9,
                limb1: 0xefcb8bbb160b0f2ecb7cd98,
                limb2: 0x8dce093ad7f7fe2,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xd917839a146ea15cd7493f1d,
                limb1: 0x6eb4af5910b954a713c49174,
                limb2: 0x29a4b793edc63974,
                limb3: 0x0
            }
        },
        delta_g2: G2Point {
            x0: u384 {
                limb0: 0x63d786683ef471af4434acdc,
                limb1: 0x185580c9ee198f6cac8bc784,
                limb2: 0x34fc9ba8eba1e49,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x161153d19ebc7f594246b9b0,
                limb1: 0x61912be284ecae3a3f0899bb,
                limb2: 0x17f115a16975c6f2,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xb4dbc7294e1eacf59b3e2054,
                limb1: 0x31c92abab72ef0ed83a3c195,
                limb2: 0x17fd1ad43bbc8ef9,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x55b6e98c187b34ca3e7cd1b,
                limb1: 0x6ff9481052ddb780a4cc43da,
                limb2: 0x1bd7d75bf918b676,
                limb3: 0x0
            }
        }
    };

pub const ic: [
    G1Point
    ; 2] = [
    G1Point {
        x: u384 {
            limb0: 0x62587fa0f6c879156e7390bc,
            limb1: 0xc9da665a8bebfd01ce6489a4,
            limb2: 0x124e30bf4dff3ae9,
            limb3: 0x0
        },
        y: u384 {
            limb0: 0x50c0471724e1b022791c7532,
            limb1: 0x5e101dd2383fdc600dcb4a34,
            limb2: 0x1fdc3a96cea49b08,
            limb3: 0x0
        }
    },
    G1Point {
        x: u384 {
            limb0: 0xedaa0ed100691cceb974c6a1,
            limb1: 0x26a8465790ba44ddb5716750,
            limb2: 0x164668f89d9d6c61,
            limb3: 0x0
        },
        y: u384 {
            limb0: 0xf3d9d0426a702f368be936da,
            limb1: 0x153290e7b5c8497412386c61,
            limb2: 0x1d9c7309625ec7cf,
            limb3: 0x0
        }
    },
];


pub const precomputed_lines: [
    G2Line
    ; 176] = [
    G2Line {
        r0a0: u384 {
            limb0: 0x6262802b3d1fc57f02eb7de7,
            limb1: 0x90ccab72e89abbdc16280011,
            limb2: 0x178e51f74b0542e7,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x12a071ce64f150102f094209,
            limb1: 0xaaad51a68888c9f4d366eb85,
            limb2: 0xb854c3062c6dca4,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x88c793e1f884996295be7f4b,
            limb1: 0x9801cbb1add70980a565d93,
            limb2: 0x7f1a23af3e93b10,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x16b6ccc140737723f6fbf23c,
            limb1: 0xfaa6476d81d4fb40a38fa84e,
            limb2: 0x1d370360026ceef,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x6768b1b65ac701242d58a4d5,
            limb1: 0x9a21b14a1117318e6e93346c,
            limb2: 0x28206643cf01adb6,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xc733c609365fab81f5bebf8c,
            limb1: 0xe7dba9325253668b9de809ab,
            limb2: 0x1e2aed8a72758ae3,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x95ec7d05aa1f4c5b117cc3df,
            limb1: 0xc9473775e0fd4d6797d4fe54,
            limb2: 0x28418cb32e9a4478,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x2a17416676088b3ed523bc76,
            limb1: 0xa7a7189cf0cb6f593da6398d,
            limb2: 0x1646a797175de826,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x60f4a61ff00c697d5917f60,
            limb1: 0x27839a4398e69c8181596a80,
            limb2: 0x18d5fc7b962c5d42,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x55d158bed72f3c06a973bb3e,
            limb1: 0xda2f40ff8f88e68c41a7f0c,
            limb2: 0x24df02427e6ac385,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xdfaa36ab439bf2b442be7dfc,
            limb1: 0xaed028fb66a3e7c58d2b0cfd,
            limb2: 0x2872ac37ed486519,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x51bafdcbfbad14f2e1810b0b,
            limb1: 0xbda9fe48ffac5d1cf3f1c243,
            limb2: 0x2e90de3ce10ad139,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x22f06d243ec31a24265558f6,
            limb1: 0x144f71a68e6e295284eaa624,
            limb2: 0xb114d08d4730af8,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xd3a0ee47077b6225045c67ee,
            limb1: 0xeec7cbf282c77e03df828f62,
            limb2: 0xbe64d352adee5f0,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xc7ec19dad21e785ffc755ad,
            limb1: 0xd24141743526f183d2654043,
            limb2: 0x1988f55b31c4faf3,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x994cab0255bb4272f95c3e23,
            limb1: 0xd922c9add52c749a87cf7c07,
            limb2: 0xaa4d57bef928d58,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x10918d6e1598af2ab245872,
            limb1: 0x1e2e946c706a26cf28ee3625,
            limb2: 0x843e82f122ff273,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xa13e048405c0e094e2be3dbb,
            limb1: 0xd0749c842f2df1d1f99960e5,
            limb2: 0x123960e86ebc1545,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xd2854d8792013fbbc7003968,
            limb1: 0xef090e40a0840af5ffac6c3c,
            limb2: 0x822c1bfb2975bb0,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x3e5a8926c61800d8035940d1,
            limb1: 0x10a92d1990b5e90459db3104,
            limb2: 0x1a1da6dbc9d3b803,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xf3c1aff57ebd4252b1ee0a92,
            limb1: 0x4dbf6eac239e2fd65d64b8f7,
            limb2: 0x26d1f994835b7b47,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x345e6aaef5a543714baced,
            limb1: 0xb490ac8096315947ee617410,
            limb2: 0x1a09bb8870da1b8a,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x5ebf58b2e5dd76b36593db9f,
            limb1: 0x8fa5c6ffbd16bb8a189499b2,
            limb2: 0xaf4be2ac3e90ead,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xd4b8cde758e0d235326f7919,
            limb1: 0xcd650faf49b3ee058023c216,
            limb2: 0x1c00cc9bd40f552b,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xfc81a9267fe02a0e01e5690e,
            limb1: 0x935b7be9ed04f236f8ccb6d3,
            limb2: 0xd21be991cebbac7,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x823e612788adf8af694cadf8,
            limb1: 0x28ffb411c649c749b8b2ab3f,
            limb2: 0x29f85195d5ae6cb3,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xa4e79c63454447ad586868ed,
            limb1: 0x1d25998e1dee245a7a740dfd,
            limb2: 0x312f28354b440eb,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x230c5675e4713e459ecf6ee7,
            limb1: 0xf23579a5477f2fded9e59a95,
            limb2: 0x23effe3fb162cfa9,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x6938a36b06b59bb433023aa9,
            limb1: 0x9f733207d38e4c21c5f938d4,
            limb2: 0xb694e7fb696f425,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x1fb7151f69662f3282addefa,
            limb1: 0x73b463adbed2a2c44be9521d,
            limb2: 0x1ce3d8bc49dd6f3f,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xcdefacedca9cea69a67218ef,
            limb1: 0x2a61c39d6c9e8df657e11fa2,
            limb2: 0x287b08ea40db8edf,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xf3493b34c974473567e0bfd,
            limb1: 0x62ec80dec81fe20e56185f3d,
            limb2: 0x2a9d8912a369f0fc,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xb7482cd3a64ad7c6972ce18,
            limb1: 0xc612ec6a27ef894c2448e7e,
            limb2: 0xb0a181c0bc5bb35,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x77fd6133c7186e2a51fdfe8b,
            limb1: 0xb6d8557c94e885365cd1284f,
            limb2: 0x2807238c4095ab2e,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xac2bf429c889f4e4fca7ad87,
            limb1: 0x4e2138d3a53fab48b9372da0,
            limb2: 0x661b199c593f990,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x17ad71412ec95d2e450e4a9a,
            limb1: 0x5a390094f598fbc1c73ffc6f,
            limb2: 0x1745ca0ad68deb3c,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x792e91102d6015db651264a5,
            limb1: 0xef1739e0f3140e7dae1b9f26,
            limb2: 0x2c68c775b43aa438,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x2d480c09009f63ff03bacd7e,
            limb1: 0xe49d79a774b60104278749bb,
            limb2: 0x28dd05053808f291,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xa4f235af16d6b1aa9cb935e0,
            limb1: 0x3356bbf421edd3b119a977a,
            limb2: 0x2c3a3e6fb5bf407a,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x475304a1c01b032aae98253d,
            limb1: 0xc07800c8acc177d31257f8a7,
            limb2: 0x2c17966ecef6d358,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xe9cd661691f7215396894f0f,
            limb1: 0x9e3c0f429f703e40f5baa9bc,
            limb2: 0x1b94de4f8b072262,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xb2328b5f060b47983ead044a,
            limb1: 0x5d6772c45ac19b49a05cbb0b,
            limb2: 0xf6f282c18f98d7c,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x10f6b52bee174dc609820448,
            limb1: 0xa4d84cb409d798e1dc4d0880,
            limb2: 0x1e5bc83da6436d50,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xce182a96f56ced121091e41b,
            limb1: 0x8800263a87f78d7ab82d3e71,
            limb2: 0x2640778c4c20679b,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xb78d8e331f9fde95d8762cbe,
            limb1: 0xe50fc6532130dcab69ccd2f3,
            limb2: 0x1c5ad86495e84014,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xfe7268e3ed4b6b97899984c4,
            limb1: 0xf2e63f6c60064bc7fb5fd561,
            limb2: 0x9717b3891610a6b,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xb6a3d0ad2be4cf8a6d7a4932,
            limb1: 0xf368ce713db6a7c85ce253e7,
            limb2: 0x11fb9d13419437db,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x6c0e91e32102a27c6bc0f117,
            limb1: 0x1580942374bdb287e34d50e8,
            limb2: 0x25451806c34da2eb,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xecf4b439dcb55cb7cd17c938,
            limb1: 0xaa30677da06e04007bc10783,
            limb2: 0x5acf050d824c550,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xfdadd2fba222755a97b93bd8,
            limb1: 0xc5f72c5874f13b63850c7e3,
            limb2: 0x8d6e33876937270,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x48b70ead9b67d481e7fbac7c,
            limb1: 0xeea576a4020c901099fb5796,
            limb2: 0xe89161f969f758d,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x8081483546fdaca3e803ae13,
            limb1: 0x7b29b6041c0844fb7bd3c828,
            limb2: 0x840a11945bdaf61,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x5257173c58d9ac477f4e7362,
            limb1: 0x4ac0a4b0a604dc11701ec7be,
            limb2: 0x2ced1a344a191870,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xced9cba631d33b433f4c02b7,
            limb1: 0xc83a4a272ab8c01b6631fd59,
            limb2: 0x201561c61f1309c6,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x6c107fe09b4144f1c2e218b4,
            limb1: 0x6bedd36ccbfb5eb21e3052b5,
            limb2: 0x1710d637ed85f3f4,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x2dbf59bd81c858f20f9a2c22,
            limb1: 0x538891d36da9558f005eaa18,
            limb2: 0x2e047a78332f57a7,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x87ebd70984bc04919fc9986,
            limb1: 0x49e5baa3bf84014bbfa4b343,
            limb2: 0x13c681e8a87b09d5,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xc7ba9d524130fff410f86354,
            limb1: 0xe56c32754857a3eadf92430e,
            limb2: 0x12b61a869a91562d,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xcf43a1c9be7903f6823856c3,
            limb1: 0x17aa81a20cb8b6533b7e05ad,
            limb2: 0x8edd93c88eac470,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x61527058e2d37f7267e2d55b,
            limb1: 0x4133bd157d450dc27f32d457,
            limb2: 0x582ee28eaa58570,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x8e35c54e5a8fc51ffe565808,
            limb1: 0x54a5c4c2ce68417d89a41927,
            limb2: 0x1bb192a0da69b4bc,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xb15a23caab89361c695304d,
            limb1: 0xa21ac5490dcc6ec31e532a00,
            limb2: 0x2c5d334f664f1db0,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x1513569aab675cc8a80d83b,
            limb1: 0x8823f86ca10c614200a888cd,
            limb2: 0x27e75cf5e6c5decb,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x7dfe801eafb39580b2591c53,
            limb1: 0x7ad779d2bc8b8960e97e8369,
            limb2: 0x2a2e897e4fcb8d03,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xba5ea5187f76b5704defef65,
            limb1: 0x8a7319f0591a44264e9857c7,
            limb2: 0x2d9dd5412302fd6b,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xaa7e8dec15610116b7d0b0cf,
            limb1: 0xe5e0a55405629a2fe14bf3d5,
            limb2: 0x2dae2582a7c55627,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x303fd13168b5089e4e0e3fa2,
            limb1: 0xd1d646954006479380c9f8ab,
            limb2: 0x1b643b47405a9dd,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x893d761d04a60dae26f4e064,
            limb1: 0xf185cfd787972d2bed98ddf7,
            limb2: 0x27e2db3d67b8caa3,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xb1fd301f8de9a4fdaa4a5688,
            limb1: 0x656432730487dbc9e9e29270,
            limb2: 0x17df9b19f2918abd,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x2d5832aab61dab3a5549a92,
            limb1: 0xe47839d4ca00888bb56afc4a,
            limb2: 0x3fe4c9d799a3bd1,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x2810fcc73bea01896cd75a0f,
            limb1: 0x2c92809424a97db06448759f,
            limb2: 0x123eff8f7259581a,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x601fdec3567703d1c3d34df0,
            limb1: 0x7f03a904345610b15ff1205a,
            limb2: 0x289705e3e298309a,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xc16237e16f04d4855851266c,
            limb1: 0x216a15737a6b54352caee4fb,
            limb2: 0x2cb963083fceacfc,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x1d5728a99fc8a6b1501def7d,
            limb1: 0xc82efa12901500963bbfdfc1,
            limb2: 0x29472ad7813d3e51,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x4bc73fff7a02804f65a8b807,
            limb1: 0x55d252b720478bafee38f7e0,
            limb2: 0xb89e5290fecd5c4,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xcecce3e7e700ddfe8b57d681,
            limb1: 0x6ffd2dd49f2ff2ecf872f76b,
            limb2: 0x1834d8633ed7aa5e,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x921d0a486c2af8e00aca15cf,
            limb1: 0xce5e704e01a8381a38da803c,
            limb2: 0x2a3b10f49d66db73,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x4d5fe5d5c9f584cffdde9b20,
            limb1: 0x694bbbada9b90b560fe95a28,
            limb2: 0x1f9131f7b839f971,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xb2a323906650185cccdc623c,
            limb1: 0x8643738b8d13209ced4a8401,
            limb2: 0x1afc7bd309bd2e6f,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x66a405a6925c6daf1121bfa8,
            limb1: 0xae0d46e02b0c767a8311def7,
            limb2: 0x1eac8613f1b73d0,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xc0dc2ee8c1634b43c7c67a36,
            limb1: 0x44b5cda8cf434ecc7f4c6c75,
            limb2: 0x17ff23c44b249965,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x6af3458d6fcb51bce863b3ee,
            limb1: 0xb4c9cf6033098a5367bc38a0,
            limb2: 0x16b5fff40c83591f,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x75584b946a79b88e5bec9dd0,
            limb1: 0x696fa9bfb38fbd7621f553d2,
            limb2: 0x1bf248055b1b2f90,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xd45ae28bb106c9cf5b04a1b5,
            limb1: 0xefc1e176eab50a80b4506c1b,
            limb2: 0x2d6a0ffa973804a5,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x639121398df650418531ec43,
            limb1: 0xc0dc106ff32d445f63f8a120,
            limb2: 0x2db69a72bd084b2f,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x2efbf5c7bf4d8eee620eb8e1,
            limb1: 0xbebd2c4b9f9ecc3d77d2c81c,
            limb2: 0x267a73e3f62a38b5,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x30674b4201c8f6262cad443b,
            limb1: 0xc6536f9ebec5d19d59f529c4,
            limb2: 0x226bae32ed07fa9b,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x3c71a9fed0157d9b2577984,
            limb1: 0xb147ab8ccbc129533b491b1,
            limb2: 0x482a238e334dfe6,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xf6c03dcc8bd1379820cb9967,
            limb1: 0xe8b667570844eddc673b54d8,
            limb2: 0x19130dc068e65472,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x90bbf7945a517e331f836592,
            limb1: 0x2051ba8f0200e210ad28fc3f,
            limb2: 0x177199e9bca93186,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xb960ca772d1e6bbaf9338163,
            limb1: 0xa7f34e9ae435bcd02d2faf69,
            limb2: 0x26dff0b0b6c2f756,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xd70ea39bddfa02454849f135,
            limb1: 0x9aaf0bb16c009e3b28d1bbd2,
            limb2: 0x581b8dda5c79e1e,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x463ce7476e959a1931385237,
            limb1: 0xf75919c87010d96ac7c94cbe,
            limb2: 0x24a412978f2c5ecc,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x4564f0aa378b3a5b8d09788f,
            limb1: 0xf875d0276495706bc0d09d6d,
            limb2: 0x1b9fed005e16d2cf,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x26445be3d3f49fbd01c70d1,
            limb1: 0xd5378dbee2feb0496e798ec,
            limb2: 0x1e8739b2b619c238,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x549556a03524dc61169783b9,
            limb1: 0xec53665fd27c4865c5367af8,
            limb2: 0x22dbab3609da89f9,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xba161cc9e9cebd75b98e13ed,
            limb1: 0x2632c1abd01681aa124fcbd9,
            limb2: 0x1bbdec597979fb4,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xfa0305a260ea7340c6afa662,
            limb1: 0x39110a94cdd1c5e8cc0a1d1f,
            limb2: 0x1e788e28c0103ea6,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x442b863a5c5f8a2c338a4463,
            limb1: 0xb9fdab2ef9d33c430dece624,
            limb2: 0x1d5d4de242b83d54,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xdfb11e4e76affcbb462154ba,
            limb1: 0x5704a29b1a8e2703af5c3c48,
            limb2: 0x2312d417321e92e7,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x4b8c4313130de071e5a25b39,
            limb1: 0xf1b3260f13cabcf328b26362,
            limb2: 0x116ceab520d16408,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x10523011df0f3a9767278aa3,
            limb1: 0x16f3307af4c560a400c90ae2,
            limb2: 0x2ede49ff73a3a3ae,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xd6465d87f836c70c2add7bdf,
            limb1: 0xc7c6c33787b9a4a9f0b6a19f,
            limb2: 0x3a10546e2951d1a,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xc4462f508080ee25b195846,
            limb1: 0xa9d1ee563b4765315d3b2423,
            limb2: 0x22d6d25e9e134bc5,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xa8fdb52a5866ede3c829660e,
            limb1: 0xa747cc99fe24bbc124e60f83,
            limb2: 0x77dc0694ce277af,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x873e405654f06e7e618a0869,
            limb1: 0x5ce484db4f007368cbf5ef3f,
            limb2: 0x406b87af902b368,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x42c090f0d49f3b172899d597,
            limb1: 0xe282930c7a6ae94172637791,
            limb2: 0x5ae9317bf562ef3,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x9d38292f11255137c4072d20,
            limb1: 0xcbd810babdf368eda51a016e,
            limb2: 0xe4a9c670bc40cd6,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x6402739bdeb3492bb057259f,
            limb1: 0x26c108432264fab03a9dc8eb,
            limb2: 0x18ef9553dbba8439,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xa00d189487a0340fd81cc584,
            limb1: 0xe346065e533d0311d3a49619,
            limb2: 0x20adf0a42e6d1031,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x2f40fa2fabe3889e62434f1c,
            limb1: 0xf5a60a0a1db35e01c23c4618,
            limb2: 0xccf2f37e5f9d7f0,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x8755dc93602da01a9bdbf2fc,
            limb1: 0x9fe1c22607998504f098c4d5,
            limb2: 0x18f0f45dc543c0ee,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xadf84437d9999eba295275a7,
            limb1: 0x52543bbddf3fc6be2f32a055,
            limb2: 0x419797ad7a39dcc,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xb14ccb344bc7ae03672b7ed3,
            limb1: 0x32b4f3937b94a54a112ec060,
            limb2: 0xd511afdf9250855,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x9b40fa04851da740d91800ad,
            limb1: 0x3b7477878090da8c8f43a115,
            limb2: 0xbd0be68b2e101c2,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x15760dce121076360bd9f792,
            limb1: 0xf1924f92230e898476d82bc9,
            limb2: 0x304f65ebb79d2bd0,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x5506e07a5fe97fdc5664791b,
            limb1: 0x7aee4b162d0660d41af388e4,
            limb2: 0x1bee62627e4c1064,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xdd3ab4c9ec1954b09595dc4d,
            limb1: 0xd02053bef44757a04f774eb9,
            limb2: 0x1f8a410c013ff7fc,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x8dc98f9b1c2f0319008950ca,
            limb1: 0x4fb659c41dc5601420cab99b,
            limb2: 0x15c515af959291b5,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xba1238b4b4da8ca1dc84dcec,
            limb1: 0x191a2667a2b4bdc6a8d02874,
            limb2: 0xbacbf0de8be4aa7,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x7818f560d037de6bdd24efde,
            limb1: 0xda994bd7113ddab6f25bf7f8,
            limb2: 0x2e7509590341ee,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xd14d410ebd15ad0e2dbeb005,
            limb1: 0xeeaef525eb5ca49303b32111,
            limb2: 0x9952bc1815a0105,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x40511cd89aa9c76b90afd1fe,
            limb1: 0xeeebf38560f5818c7794c609,
            limb2: 0x1e9835676b0e4cad,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xfc4540bcfa1be23824759eda,
            limb1: 0x761c0a6caea91ff18df75d87,
            limb2: 0xf4e6c24c41216b9,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x7c95bb4a3045f598ec02ad3e,
            limb1: 0x69527e98f5b823f054558e44,
            limb2: 0x21990ad9da9ab486,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xe76176f500a3b7bb7193cfc5,
            limb1: 0x85b90669c4270df3ba79b129,
            limb2: 0x780be9adcae4970,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x481876a8b44064c05d5246ef,
            limb1: 0x7dab43eb527bd93d1dc91b07,
            limb2: 0xd714afad4aeff67,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x81582d4c64462a522c03d882,
            limb1: 0x609cde5a3b8e8b404e3faf64,
            limb2: 0x2abe09a84d32cfe4,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x6c6df46abcfe69b84b5cbbe8,
            limb1: 0x43b46da7c7b2aeec2fa935bd,
            limb2: 0x2f14336fcc2bdbd,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x9ece765823cf827cccc87414,
            limb1: 0xbf5d9992534c6831dd441b95,
            limb2: 0x6f7e39a016feeaf,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x1759f088e6a22164845e28b3,
            limb1: 0x8fc900b0084e661b03277c03,
            limb2: 0x150fc5685af62748,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x3f0ff585c16da81d8922130b,
            limb1: 0x8b2bc20a9fc724a9e26c8a5f,
            limb2: 0xbbd2c609b0705af,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xfd726e0bbbdd73195a7edd4e,
            limb1: 0x80381316ac4cc1180fe6580b,
            limb2: 0x1679db00b998286b,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xf4df1c9e315352cc58418740,
            limb1: 0x609cfd341eddc85035abe0a,
            limb2: 0xb0bbbf58076e7c3,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x7f251d631ef9feedc710cc50,
            limb1: 0xf240804810ec72c3bd6ea838,
            limb2: 0x238235c3c9db8b71,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x1846a54b2774044cc6db6109,
            limb1: 0x588f586073d6e0294383f78,
            limb2: 0x1439b6a213dd4c9f,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x67e20f1add3f4ebf14209db,
            limb1: 0xf7f6c97230cb77e31230ed5c,
            limb2: 0x25e1f1a58ef3989f,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x70b88d1617d059ceb7d98043,
            limb1: 0x82f9d5ff0ae1136a457c094c,
            limb2: 0x1e57f0f235835b64,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x1b7e989c0aa4fed09c6fb03e,
            limb1: 0x301d42612ab66120ceb7f821,
            limb2: 0xa616f1fb22b8093,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x1309fa41e57e07658617981b,
            limb1: 0x3f8982bf9c1278956955f68e,
            limb2: 0x2d2c9739573fee78,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xcc24c41f4fa231c9b68ff129,
            limb1: 0x5440abe8953c426a1d9c839c,
            limb2: 0x2f827a205f84222c,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xb7ec4f27a8455ed2e02825c0,
            limb1: 0xf6214b20f2802f0322bf54de,
            limb2: 0x7b6c0211a56a7cd,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x3ddcd17909984999f1d9c0b7,
            limb1: 0xa88f74be516fa85ef09c0c37,
            limb2: 0x163a9e06932a7748,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x2430701222fa1d7df18182ed,
            limb1: 0x1842ef7d1e749169f69cd7d2,
            limb2: 0x1cfab3ad0f78b05,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x47c22ebfcc3068f8dcf02310,
            limb1: 0x3b3dd7a1f523872b1116c94d,
            limb2: 0x227ed969d3c4de16,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x74588d18e59d5afd7d6333e0,
            limb1: 0x9f0b0142842948df6eb78b67,
            limb2: 0x2e0977e3388507ff,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x9edeb901cfd05d4d62c57891,
            limb1: 0xf2f44c81706b6c574ef74f27,
            limb2: 0x21c87948f9829350,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x8dae1edadcbeb24d1690498e,
            limb1: 0x64a5a0aefccf74b01c6fa30e,
            limb2: 0x1bc752ac7ac4cde6,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x545af0ef26ace52605983817,
            limb1: 0xa79fd477f6e4bb7b9ff7ccfd,
            limb2: 0x1ee6d4735695766c,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x1f7a45146d34eb09a7598bd9,
            limb1: 0xefa78e89ed2b184fde732788,
            limb2: 0x25ec7ae4455d5b79,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x2b6b735fbce332afa29e90cd,
            limb1: 0x805bb9f2ebc1c6417b04e9f5,
            limb2: 0xec616e54a8979c3,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x709b98b05dd7794bab2d59b4,
            limb1: 0xf9f45610844c2c81a03a8a65,
            limb2: 0x148662451cb583aa,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x62117d56c64475e6fbdec3af,
            limb1: 0x583fbbd8939b1e224aa95b0e,
            limb2: 0x28191a7f22fb1b52,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x4a365c16e3d6d9018e9edc8e,
            limb1: 0x2349fc23c3d161ad59f146a4,
            limb2: 0xcff2c08ca6d70ff,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x9b0f3727f6c65ae514391775,
            limb1: 0x66f500fff93b94dc25cd2ef5,
            limb2: 0x1616cc41a4059848,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x20020f168e75bd67232897bd,
            limb1: 0x7538b1621f2aae4a1744a9d2,
            limb2: 0x6a303d9af7e26b0,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xe62cde136820c7533e265423,
            limb1: 0xf793e2f097203fb2839ec54,
            limb2: 0x2ecea3bada582558,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xe91c26cff33b3fca1fdca36b,
            limb1: 0xc0c7af270a2e684511271132,
            limb2: 0xe5db537a21ca3cb,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xc5e97fa982d1fafbbd294014,
            limb1: 0x9789fec81f07b1dd32691278,
            limb2: 0xd0841164115e268,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xefb69f6018971aeb3c7133a,
            limb1: 0x7edbee9a93563bce2898d463,
            limb2: 0x2d197bf653525879,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x2f1913981fc362cf0bf88aab,
            limb1: 0xef7c2a8ecf29bbeaf0e1e63f,
            limb2: 0x30050518f74fe97e,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xfffa14db6b6e81727f03e3f8,
            limb1: 0x54add6e3b556654a326238d2,
            limb2: 0x9fe269d90dc5d20,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x1351d4094c1839ee51f1f0e7,
            limb1: 0xb156be87d15441b91f9404d3,
            limb2: 0x6fb86a43de8f165,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x55bf536ac8465713af40b5ef,
            limb1: 0x9f50a9c326b601651b9b98f3,
            limb2: 0x26a72c028b8ad77,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x20a0516b2123cd1fbc8360dc,
            limb1: 0x812f625817ec43213b31d178,
            limb2: 0x1d2c35eea036b2e6,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xdef3c043f629ed0538632922,
            limb1: 0x53b3739f82a96c141c5afc0c,
            limb2: 0x1ed6aa9419243004,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xdc405000b24517a3974bc8b6,
            limb1: 0x29125a16824af49f27095f56,
            limb2: 0x125a418d4516e085,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x397f882f041bb7107378b787,
            limb1: 0x2e0bd72e4b4dd05a5a5d9616,
            limb2: 0x599f7ecdd540f25,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x2b9f057cdb767ea07938e0fd,
            limb1: 0xeaaab4f60971197514005bc3,
            limb2: 0x23dc6bfa5864213b,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x3b859f3518d9f5f4eb013ba,
            limb1: 0xb7e70646b18c45ab67abb8b5,
            limb2: 0xd66b054428ef778,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x7d6b414569f16dfb161cfb6a,
            limb1: 0x4c099963e194cec53966d3bb,
            limb2: 0x96842fa4f48a384,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x367d532f3b2c70df867ef802,
            limb1: 0x146fd49a4fe6e4ca2c66bf5c,
            limb2: 0x5f9c8e4722ae4db,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x5726ca3f12ecd9de3642a129,
            limb1: 0x4dc8358c22de7976a16582e0,
            limb2: 0x248bff6cc742d198,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xccabee0420c99faf8dfa62a9,
            limb1: 0x6021b300c6838037f6c0f5ec,
            limb2: 0x6d0e5f580a2c164,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xca6d433d252956dda0032873,
            limb1: 0xe2336220ac061164c7cb509d,
            limb2: 0x2a963303901fd15e,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x8f6452af7055e1da3f194ab0,
            limb1: 0xb7072823239eb1d6e7f4ca4f,
            limb2: 0x24cf8035828789ac,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xb902889b8e515f50a35459fd,
            limb1: 0xc217e165046838d9bed80420,
            limb2: 0xe1135316fd2082d,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xf6f97b0d51118e4b46419e4a,
            limb1: 0x7ba04b4570e0d8b9f4c9ad33,
            limb2: 0x2c2b178913fdea06,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xcef2e99a40ba393e757616b8,
            limb1: 0x21f2fb6a7149d497e0928720,
            limb2: 0x5459a376a926457,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xa04f3e37f32317f9761341ed,
            limb1: 0xcb141d96c38a93fa92a8957a,
            limb2: 0x1a1c8cd9558a1e52,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x808f6f0bb3e4b7e682a037b0,
            limb1: 0xbfdbd92be91f201ff3b55808,
            limb2: 0x19fc39294d2f84a1,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xff57c8948622b6a79e7e594,
            limb1: 0x9989a341118d02ca6c2d274b,
            limb2: 0xf07603e21265d90,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xce5f0da520e0353af53be8f1,
            limb1: 0x26c491474be759c5a53a4171,
            limb2: 0xaf0f71960aa4570,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xa5a4d064376cb64b1ae4c657,
            limb1: 0x40afa71ecc218fe098e39b3f,
            limb2: 0x1466234513ca8fcd,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xb6c2f683b30cdaa0cc7f0dce,
            limb1: 0xbd539c7ad34210c61ff72053,
            limb2: 0x300264d81829af73,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xb4a215d12b5f8ea785958928,
            limb1: 0x4eb93eabf65fcb7b97411eb8,
            limb2: 0x12102f441fc2b073,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x5bf192ca7b93210d96fd9453,
            limb1: 0xf1e91b9a46f08a2fde22dac7,
            limb2: 0xb537103fa26335,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x61ceb5725c67756dd953f703,
            limb1: 0xd3111f6c63de4bab2e47cd01,
            limb2: 0x21624231d3965ff0,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xd466ae8b808726024540df45,
            limb1: 0x106edc6b8bbe95e75c4c8ddb,
            limb2: 0x11468447a8135b98,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xd0881b80d847044084035ba3,
            limb1: 0x120d97c39e7d772df4ea1724,
            limb2: 0x276d399b6465c9e,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x7d57a86618737d3d2abaaa4a,
            limb1: 0xd7e9a1452de00c5e1014e4a7,
            limb2: 0x1d4294c5a1e71a79,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x22d506d59afa935528b3209d,
            limb1: 0x9b3ab29bf3cd5e1e10cc308d,
            limb2: 0x747bbb31310f22d,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x4ed50981cb80cf7ef86c47a5,
            limb1: 0xf8a104ae872fa6fc6e2ada09,
            limb2: 0x87eb3ddd4491d15,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x31d725ead61a129413581df,
            limb1: 0x1634f8d27d644aa449fea2c9,
            limb2: 0x128435a45959e284,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xa22fbc636dcc36a1cc7aad6d,
            limb1: 0xeec5fa5e4e5aa2ce9dcefc4c,
            limb2: 0xb5964951926a946,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xb592b730f474cc2a4d5425a5,
            limb1: 0x24d3793b3a7cbc2e6619a0de,
            limb2: 0x11b5fb1574d8c9ac,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x5d9402b6b38fd455bf6d41e7,
            limb1: 0x40762f68405f312ef02f8598,
            limb2: 0x1f8342cbdceb3506,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xc72348fb470ab8c04752b5a4,
            limb1: 0x334d25fa09cf31cca46d0916,
            limb2: 0x204a36e5e3992a52,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xd80af7fe0ef47fff92f37a68,
            limb1: 0x16c4943784e96ba42bf07819,
            limb2: 0x29504fb758b88d97,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x73229c759eb01fb63c20288b,
            limb1: 0x9ac158cfc3f612f54354fa46,
            limb2: 0x2b076be18044918b,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xfb23f67b0c7c277b0fb86dd1,
            limb1: 0x38ecd10f58fa1a2a35794a92,
            limb2: 0x37aa0d9abc10a23,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xa41ca972e4e66a3542219964,
            limb1: 0x1bd17624ed2ce1e682b4e8f7,
            limb2: 0x2989444f436f1dd6,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xd4c30c692a0cd4437bd20830,
            limb1: 0x3ff4fc96d1e014b335cb4ecb,
            limb2: 0x1c92a02e4ef43dfa,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xd920ac36097259643357948,
            limb1: 0x4a07824bac28e19dfecd3c9b,
            limb2: 0x2107b2b219b0fce7,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xa7506225f160822b273888e9,
            limb1: 0xd3d14903f7cac6d483c7f486,
            limb2: 0x1069a304f46fc73d,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xe09cdad30c6c95ec103b4899,
            limb1: 0x49e00af66e7a9ee491dae35,
            limb2: 0x1864d886a088da8a,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xc1b39342ab05cdf6860d1663,
            limb1: 0x2d93a67b66068131b4c4da45,
            limb2: 0x2cf24b680c6c956a,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x8c080385898b2b724819996,
            limb1: 0xcba25b471c4db069a8676475,
            limb2: 0x108fc71b9d6170bd,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x572b773de719e0286485c280,
            limb1: 0x11e06de6ae88abe2dc292d08,
            limb2: 0x186e96233737a01,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x847e89ed969849374f7db3c7,
            limb1: 0xc5b2fb949e49d53bcf33515b,
            limb2: 0x23b1283aae54fe3b,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xed5be001209472991a4e75a,
            limb1: 0x2f5a7a9479f81cff74bda20a,
            limb2: 0x103224cf323271db,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xece900cc17ebd9f42d6a706a,
            limb1: 0x4fcf1446fb08c2ce8fe1f6d9,
            limb2: 0x305cc1d699ea0794,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xf8bfb85cdc86039bb4018125,
            limb1: 0x7be955c10b0359a7973d8645,
            limb2: 0x26304c9784e41970,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x45e2dd0c8c9e99be2d486ab7,
            limb1: 0x4435e999a3d2eb84952cbfff,
            limb2: 0x1330c65943a597bf,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xc3ca87ec812cb9200943aa6c,
            limb1: 0x240ae8fdf376bf8512aad6bb,
            limb2: 0x2334035bf7082914,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x63ede79d89c52d83f35048d8,
            limb1: 0x73a18b855a63a05716992b7e,
            limb2: 0x217132215f0cc50f,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x76c2c3f4a1f1e9d8af542b7,
            limb1: 0x8441dca19b660c87b2c24022,
            limb2: 0xd4fb1ace706aab,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x6b98b456e4100fa122cd3adf,
            limb1: 0x9ae10c95907ea280c6754592,
            limb2: 0x1473f309a21a16eb,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xf530f6daa1f8c4701334c030,
            limb1: 0x6fa238391d516b8940b78ac3,
            limb2: 0x27085bb6119190ab,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xf6e1318ded506c0fa4a5ca59,
            limb1: 0xd627f19ca3008cc90d8bbd8e,
            limb2: 0xe4f8de695c15f15,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x3cd25258c14698ad321ce4c1,
            limb1: 0x5f3e41e0e9abc286750b55ea,
            limb2: 0x1e7acc78ae40f53c,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x7fb753e36893e039a913c94f,
            limb1: 0x71d2b9fcc8c9833d7de96163,
            limb2: 0x99a73fa44b04d5c,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xde6ab8423c206004fc0a2e0e,
            limb1: 0x78d2d32cf9a4d7886551910a,
            limb2: 0x153d30f1951850ab,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xe1104a60c9402d05c7369e2e,
            limb1: 0x692902d053754c3b56e08d58,
            limb2: 0x13eae4536ba169a3,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x1509c5b91b73a75eff1fd9fb,
            limb1: 0xf3dec59a348b17c7400b86bf,
            limb2: 0x13db20e7e664f0c0,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x36dd1839b3a22a5afbd7f7ed,
            limb1: 0x66b0df244064db38c2bb2556,
            limb2: 0x2abe1143e1e96ef0,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xe9a3cf2e38669d402746144e,
            limb1: 0xf5902b6e357b3171d55c611,
            limb2: 0x2664b92ca19b7611,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x9daa58ef595d3b525a479c15,
            limb1: 0xb8c4e03fb569df7a793ee10c,
            limb2: 0x5375f321384b046,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x8a787397b454b58176837e03,
            limb1: 0xc5cec0e7f665a2a76114ed3a,
            limb2: 0x2c78f7b8fba875fd,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x7928a23938145a58f5d57ab0,
            limb1: 0xede46e1acbb7d258988f4b3a,
            limb2: 0xe9e606331057a90,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x9e19b0f639d02c4e3468d6db,
            limb1: 0x9fec35cbec423d803671267c,
            limb2: 0x28477ed79b8d9f1c,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x9f3f001662c3ddb9542c5b1e,
            limb1: 0x66630f87ae05a36602688eee,
            limb2: 0x2e141bd01fbd3896,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xcc3035708103ff2f96090b76,
            limb1: 0xf0cb8a10216eccab8c3b0985,
            limb2: 0x163aab6dd7da60cc,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xd33d3548ed9d2cec0c8c3e97,
            limb1: 0xabc9469b7c56c8da2ce322b,
            limb2: 0x2e6f16f35be168fd,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xb89c671c85a0d99ee444f09c,
            limb1: 0xc3e70b59ad07c869ff35fce,
            limb2: 0x2d94791bb226fbf5,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xdd91f5db83ab791b396b15fc,
            limb1: 0x475f296aa5ec4dcb22e72eaf,
            limb2: 0x118eb40c1ba0d446,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x28ccff4098291ff99db7d015,
            limb1: 0xbbf223ce77f8bdf1e351f459,
            limb2: 0x1eb6506d0c7d4aea,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xe4c907dc1a275aa0cdbd6c2d,
            limb1: 0x357d8adc7866fcc383178ae9,
            limb2: 0x18c6082d4b4a59f5,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xf7ba73f45b1f2c9b8b13b1c1,
            limb1: 0x754b28de4706d4147a660bf3,
            limb2: 0x304b461ac8db9efd,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x7afa3c98b59c12047d082d00,
            limb1: 0x16b499cba52810fd94e60ac1,
            limb2: 0x107cc1c9d1ee0ae5,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x5473c94e995465f0785b4316,
            limb1: 0x86e38425ae2faae14a123db7,
            limb2: 0x236ccf43605631c3,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x3560440e3b7a50cba31817c4,
            limb1: 0x94e7415089d9c6a041b95a4e,
            limb2: 0x17b1e780a1f282b7,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x34f92afe1a802ef319d629ce,
            limb1: 0x9b7ae704b85f2ef01618f9ac,
            limb2: 0x127e7a97519bc45,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x87fef97f09987ebb7a9d93f3,
            limb1: 0x6e571f3688a614ddfc482b07,
            limb2: 0x26d1e21000c12da3,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xb292d5bbc1c5800beeca8d15,
            limb1: 0xb6e3c05aa128d07de2df66e8,
            limb2: 0x24424145a074ed6b,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x138b775d1ca3d771fd249d3,
            limb1: 0x8a2392db8be88b8fa3f04951,
            limb2: 0x17bc62334cefe39c,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x8e7371df60a9a5e4cbbc9be9,
            limb1: 0xb650615a2aa43a3aced9368c,
            limb2: 0x1a4dc1089e983ca5,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x18674fa925de769d104bd2a2,
            limb1: 0x777c884e96e41fdb34f4141a,
            limb2: 0x4d2dfcf532f463b,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xc780881f9c6d8bca3e37aea0,
            limb1: 0xe9895da94e554ff87a2dfd7,
            limb2: 0x2f2f37a08cd78298,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xc54128f3d98d66a205153035,
            limb1: 0xde9df82c3ef59e5ffeb06262,
            limb2: 0x12c11f147ed32b02,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xd779e2290c08b46957f9f81f,
            limb1: 0xcef48524479ef765998c179e,
            limb2: 0x62d4fd8696cda6c,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xf553ff2a36599491c12d51cf,
            limb1: 0x68f2b7726eab96d19be4f7ad,
            limb2: 0x1b2e70aad5ff1bde,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xf421435fe144055f20b6716a,
            limb1: 0x8d06d11b62031d272be85bb6,
            limb2: 0x378648f296513f4,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xaa516565bc7b4ae51c4a1d57,
            limb1: 0xd1a3c04fc68cda14c386fd17,
            limb2: 0x10a17e6b2b05ae5f,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x5a4fdbaf4101c2e7b0824483,
            limb1: 0x243d3d5fab841583935cbdbc,
            limb2: 0x2bdee3f29a271704,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x75a0bfe5357850025da7dc1e,
            limb1: 0x7efd8ea95e831ae7b7cb4204,
            limb2: 0x242d5ff5148e8a24,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x13404adaeaee7586ba22a2fd,
            limb1: 0x37d5f59c1d1a7ead09415ba0,
            limb2: 0x2d046fbec788a89f,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x304e12830e0da56473bfd493,
            limb1: 0xef4257261a4d1e86faddc8a6,
            limb2: 0x2e2a406604501f28,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x4df9be0616aa88b0d4cf02a2,
            limb1: 0xfe4ac5d159b42f097e07c99,
            limb2: 0x1bfaf8ddf8eadbe0,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x39cb7475288b5721bd85070f,
            limb1: 0xbcf9db00ab3740a004be0aa4,
            limb2: 0x67aa9f57b6254b0,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xc35e158b40bec28bc76a5275,
            limb1: 0xc7155f076ac63ee9c5bc4282,
            limb2: 0x29db032c04d42b9a,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xdd6363dfcc7e71cd13c51cf4,
            limb1: 0x10ffc527e277eaf97c79a492,
            limb2: 0x22a9e4c447737c96,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x9705df81acb2749faf48b2e4,
            limb1: 0x62e438807e2bfc92e2fdb9f6,
            limb2: 0x138bbb12a9dd92f4,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x9a675f19eeab63bd0216ce7c,
            limb1: 0x9a08c702e29a00db40bc334e,
            limb2: 0xc960c1d7c1c05fb,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x7a08cc34c6fcd1f9e74c35b2,
            limb1: 0x2cc8a7d624b15a0f9bfb2d3e,
            limb2: 0x22760e0e61e3e208,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xc27bb24b5b346b44cf7d548f,
            limb1: 0xf27ea7f3736c8b8168f8c2c1,
            limb2: 0x295d0b6d3ef18509,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xc7df1942c9b70ad4983814f,
            limb1: 0xf66a53554bde327b0ff9c637,
            limb2: 0x1fe98a3ad4e0774a,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xa33e765594cc92d0facb00ed,
            limb1: 0xe35f28bd8fb424b3721d3880,
            limb2: 0x1735f29046f597b1,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xe8cbc94bb8cdf72ff26f38fd,
            limb1: 0xe0a2179f1a66292497c7a553,
            limb2: 0x258204cb3308769e,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x31d262be0ea54e0eed69a03b,
            limb1: 0x830d5451d02580b33f770099,
            limb2: 0x1b7c1fa69407bced,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xeb6c0bbb02f4cf840a51ac39,
            limb1: 0x30ebd50843b10bfe90d970a0,
            limb2: 0x2ce27eb8c126350b,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x4c8c9c51af22d9bf461a9f49,
            limb1: 0xfb8b4c9ef7b7fc81c52ff1a2,
            limb2: 0xd39e1c14eea7101,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xb02550d130bf712df6d98a57,
            limb1: 0x8854a229566b7ff22b8ccff3,
            limb2: 0x12a0631c0924ec70,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xb59d2598e43244d544a1616e,
            limb1: 0xf28e9462628066c68e061fc6,
            limb2: 0x7baccf7063f2981,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xb1cbf3882570f3d23dbedbc4,
            limb1: 0x5e8742fe9dc865822e5cae92,
            limb2: 0x2654f08f566866ac,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x1287198f6ac726fd6aa6595e,
            limb1: 0x220b82cf3025285d6b7344af,
            limb2: 0x1419e0cd4fc9d705,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x16da4933b0462809081edbc4,
            limb1: 0xb2b5cf2a2286026e0bbc4c4,
            limb2: 0x14490aeefaf4002b,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x9631e388544a5571edb94366,
            limb1: 0x4647882204977448d836aae,
            limb2: 0x1df1cff53ae1660e,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xce99ac65e9d29dee6ab79293,
            limb1: 0xb5827a5ff68c42c93f003a3d,
            limb2: 0x2ff7f220d4e2b15e,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xfeead92cf9c75dc3dc26ddbe,
            limb1: 0x73f7035049129b05256f2625,
            limb2: 0x2f97ef7e0326ae1b,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x3557697309324ec7b28f655f,
            limb1: 0xf990f387e4585977f0c61411,
            limb2: 0x1f88afaff88f777f,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xfbd05da9a80d37ee13e654d,
            limb1: 0xa34586aaab313351d2211c3c,
            limb2: 0x16f110b250c8f4a7,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xe7379e88b19d61e01dbb464d,
            limb1: 0x6ef01d97f74e23a2a2e3954a,
            limb2: 0x2b1bc8c3cb77b3b4,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xaefdcb2fc007f2b030adf282,
            limb1: 0x407cd78e89ca611eeba48b00,
            limb2: 0x15caeeddb0b65f8e,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x25e2464064e839a435c901fd,
            limb1: 0xc8a250aab01f64653e7b143,
            limb2: 0x140159960e8bbee6,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x7cb8f3194d4856b2e37ad147,
            limb1: 0x79f1a0cbdbe629456ff7fd09,
            limb2: 0x2e8cc9955ec33b14,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x3a33e8aae92f696039285ae8,
            limb1: 0x50e70dff510555f94708ec0e,
            limb2: 0x107f090bc1746726,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xebc6d08d9ffc1f811537ae5c,
            limb1: 0x97116269a7fe2b46ecd07544,
            limb2: 0x2ed49e8306bb6b53,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xf8f6ac38dbd6563a32fe3ee9,
            limb1: 0xfacb340af38f5dd75813a198,
            limb2: 0x16bbfa264bbaa255,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x76a6b03f569b4e99a401edca,
            limb1: 0xba4469e4fb78a30370beb53,
            limb2: 0xde76a28c997a85a,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x9368f4915d1afe49ee098655,
            limb1: 0x4d6ca82a7c8d3612d1f5d552,
            limb2: 0xbf0b37fd18b8725,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xc503c77bc66cf62a998cabd4,
            limb1: 0x4fe691624059c05c90abec0e,
            limb2: 0x1b8daabf94ec10a9,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x338a05ed9e18ca0c8cbb9ba,
            limb1: 0xeaed8a5ad1bbfa8ffd7827d0,
            limb2: 0x229ab6a016d41b8d,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x6de2e082d93ad5ab82221604,
            limb1: 0xdbadbca9be15f3e1a6011bef,
            limb2: 0x17f46739d3798529,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x556cb2cd13bc608a395ef30a,
            limb1: 0x5ae57098c69bfdd5e4310a77,
            limb2: 0x234c308ff816d887,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xde9e9d4f811bdd153dca9448,
            limb1: 0x2a5c0dbac52000c678bf9037,
            limb2: 0x2f74a2c3d53bbf07,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x5d5094b09519f9fbc1bf26c7,
            limb1: 0x60b75c521b5d0d3a8c6c5a57,
            limb2: 0x1db1a7d363c021fa,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xda84f6ecfab32ddfc17bb30c,
            limb1: 0x31f21c63899699ef82e8956,
            limb2: 0x1bb6484e546389ba,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x6d03eff42e8a9c1517bf621f,
            limb1: 0x25e25c77b11cc5006cb39115,
            limb2: 0x2bab9460edd274f4,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x6636dd3c7ea7e49e82793062,
            limb1: 0x45e083ea0fb71779754a40e0,
            limb2: 0x1b148d5ad236afff,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x1bd0d3e64772dd8d6f4eb955,
            limb1: 0xd551e62b4dc950330f32055e,
            limb2: 0x2af99115e61ea584,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xbf68bac9801a05b7d4e5c230,
            limb1: 0xb2c2415c0237afafa8e24039,
            limb2: 0x9639d3152ec116d,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x5470718dfbca1295766112f2,
            limb1: 0xcdc95e016f5749cd20628ff7,
            limb2: 0xa073db3f3d4ee7f,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x59adba4782946b799f2b3f52,
            limb1: 0x60aac6f24d8307d05aaf156e,
            limb2: 0x29fa48831a9be4a,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xfb944c01e622920643567a03,
            limb1: 0xb5e410fcce49e44fa6b733e5,
            limb2: 0x67235bfc45af909,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x7415228da60f54ef44f0e9e5,
            limb1: 0x54a974a80cb733a9398a4237,
            limb2: 0x14742634cb3e88c6,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xe6117563be5a51a3e45835bb,
            limb1: 0x5cd22381f024901e8038e534,
            limb2: 0x9bccc5fd250a4e2,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xd7e83df65939cb9e0a65506f,
            limb1: 0x5c0226578531f39df6fbfc47,
            limb2: 0x24413aaad067b5a2,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x1104034e64d27e5ffc63566,
            limb1: 0x399bd49fa7407a8bdb5203c7,
            limb2: 0x1832f6474b41c0bf,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x55803008aa1d71cb5f9941c1,
            limb1: 0x404a98b2848b86b4af5b57e6,
            limb2: 0x163abe5942eb31d8,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x82f5febdbf1aef734e2827ca,
            limb1: 0x12d2b5ab6f8472e574b9210c,
            limb2: 0x28eb5172b9c24785,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xb2fbbca733e95d52f011bf6f,
            limb1: 0x632c5aacc01d53ce7abc8bae,
            limb2: 0x750b07eef4315e1,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x36e8e6c311534f247b2f522f,
            limb1: 0x30b52221767eb139a6621af5,
            limb2: 0xa9472da06a550f6,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xd54bec3ff6e5c1609841378f,
            limb1: 0x86779a5fb4e9c376a93fbad,
            limb2: 0xfe84f7906eda072,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x4f7564b178d5cb370ab75811,
            limb1: 0xd054e692a00381045a312b52,
            limb2: 0x1af83b2d13968385,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xc3f2584ed4cfcc7213a55c0e,
            limb1: 0xcf835b28a17db67f23c65108,
            limb2: 0x15f8038dbb750a89,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xb311fac4a46b12a29d9145c5,
            limb1: 0xf0216ee536a371f5bb9fb55c,
            limb2: 0x128c4da7ec19e940,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x40d5ac9c25788920a64397a9,
            limb1: 0xe61e75b3f5562e0f5bc0039d,
            limb2: 0xac9a936b0bfff57,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xf7091e9a7ea3a772b7f006b3,
            limb1: 0x4541ad07dea41c3ff23f1c1,
            limb2: 0x73ea3cc79b728c1,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xcd2b3dcd910e9d600708fe2e,
            limb1: 0x726ab436201b4de44b9efa4f,
            limb2: 0x2e6674c1fcf4372e,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x9501f9c373c02510420bd774,
            limb1: 0x34a01a7a11837b54b21d87ad,
            limb2: 0x13013fa1ad5a2602,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x4bf8308ce14b6895f625821,
            limb1: 0xde9402ce107e3b0bb8325032,
            limb2: 0x221a4b3042ac620f,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x2b54888ac068e44ac1b5e725,
            limb1: 0xe2595c1718cf92904f26b388,
            limb2: 0xc444735a378fc2b,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xdb79229471d5dfb86ac334e6,
            limb1: 0x5300c1298d97c7e56a443d9,
            limb2: 0x290a2ac4e4806224,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x68dc34c5837479b6fe1b15f4,
            limb1: 0x70ffaada5c0d2134dd4b01ff,
            limb2: 0x12600a475dc719f6,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xef8f37a1a7c1874aa696b864,
            limb1: 0xf03831086e97655126735dcc,
            limb2: 0x29a8f8b90b8db8bd,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xdaae6d464020690b41135866,
            limb1: 0xe1a461381c2daafc22ecc6b8,
            limb2: 0x1be8b437d95ece9a,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x6ec13263dbf5de6eebbeffc,
            limb1: 0x7309cff008feb3ebfb9b22e6,
            limb2: 0x112e6ec0db536bd2,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xf85ee56a7931c3a3d7e22b1,
            limb1: 0xc49e4026d30000ff5ad0ed87,
            limb2: 0x9a8d4f19347675e,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x34652599e03489dbca6a04bb,
            limb1: 0x98f8ba9e9b65abccfdce7169,
            limb2: 0x153fbd440ef725b5,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x35111b6f4eacb1fcf5f53f8f,
            limb1: 0x23545a2bb56c9b2fe222f39c,
            limb2: 0x1b7822ce0cdc1f2b,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xe68e164e8c7cdb83224d5ecf,
            limb1: 0x4900a3f7ed3d0b25d2716b2d,
            limb2: 0xf1e46e6adac9d5d,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x8b2c899639dc5cc9c044490d,
            limb1: 0x22f86bdfbacd20aeec5d8be9,
            limb2: 0x19b836ccbb17a7e4,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x89bae9959824cb3a475e5c49,
            limb1: 0xc53c6b56b477f0dd0853827b,
            limb2: 0x22783114b221de87,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x5c91c9c68702894ffcd0ea24,
            limb1: 0x5d691537f69a30e7050f98a4,
            limb2: 0x1bb9cbba6a513842,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xa9226abf9515bbd281fed4c8,
            limb1: 0x75b0a0c6355bd2dd020a5c6,
            limb2: 0x221468ff5248a1e8,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xf8820d4aceab306eb783e0a6,
            limb1: 0xc7d1a20e7942c4d389818908,
            limb2: 0x2e31d9c48e89b432,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x85bbebd854eccf7a6c56767,
            limb1: 0x2d07ae2c3946de9e92f58236,
            limb2: 0xeb5a4ae8acab71d,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x4512ff65bb8a0aed640ac4ab,
            limb1: 0xdd9f660ad3feed3e4510f4c5,
            limb2: 0x16ba9a8b70ccc71c,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x9d2c01267d4aeefcf1f78ccc,
            limb1: 0xdbeb1adcbf7df61b43429ba9,
            limb2: 0x2c895b99227c31d6,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x90e454055b75ead8e2ebac42,
            limb1: 0xfbabb00c2f3aa9dbd7522417,
            limb2: 0x5b3e7e4068f790,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xf85cebc1555abc4d89b337ef,
            limb1: 0xf4761f79f94babcc24806057,
            limb2: 0x1b996af0e24e9310,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xd7206c93b508f78061fe01cd,
            limb1: 0x742ef1d29a2c692312298778,
            limb2: 0x151fe23f3bae34a2,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x87f5668138132b557efd05d6,
            limb1: 0x94e793d236320a9e3e525285,
            limb2: 0x1988ca9052857a71,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x7c6a269fe06a16627f5ecf5b,
            limb1: 0x50317e79670fba9583cbc9af,
            limb2: 0xb20ea22d8b7ef38,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xcec9cccc31411674ea756b45,
            limb1: 0x7febf8b5905c4ad47e85f90a,
            limb2: 0x85dd991fef5f00a,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xd935f602bec4954512e2a83c,
            limb1: 0x3d448544bb1a52e6c21568e5,
            limb2: 0x30253372b426fa93,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x2321475e1ba3f3775a8df03d,
            limb1: 0x8ad60a1731370c5148fdd271,
            limb2: 0x5ac30ab6d4ac94f,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x387a543af80110750ef06290,
            limb1: 0xf82835b4768246d0aaa1d901,
            limb2: 0x2419af1838a4d116,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x47251c0c962be9ae66db3d05,
            limb1: 0x43f64d4ac11d82a21f131c2d,
            limb2: 0xf896f4ab3e39af0,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xc5775374fa4d6293b3c2c070,
            limb1: 0xc1aef05fdcb1bb03a298fe38,
            limb2: 0x298566e64b1aa9ea,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xc1973597201173697fe8c018,
            limb1: 0xc357b15cb9b588bae8abc963,
            limb2: 0xed371de6f4074ab,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x40d9f3f225ebab5380d4b72,
            limb1: 0x31a46955bff4173ff90907c5,
            limb2: 0xb56f0074b975741,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xba705bbb410ae6715e48508,
            limb1: 0x9baf711d475a978e9c6208e0,
            limb2: 0x2687a1dd57bbd608,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x4cdcbddd1555f6a28e4b4633,
            limb1: 0x5c368f07d906b3dedd347055,
            limb2: 0x4c585e6b42f1812,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x2aa6dcbf02a9bfd6a69b9713,
            limb1: 0xc377411908d06357c9dd7e0d,
            limb2: 0x1ea404aa6b11edc9,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x1ba2d91e528e15b1e971d7bc,
            limb1: 0xc3d5b13a1a0ed98868b53c49,
            limb2: 0x58c43b20c6ae43b,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xad13d1837679166bbc309e9c,
            limb1: 0xd40862384caeae8d2c50a472,
            limb2: 0x1333a454fe004635,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x67824db562428bd89655e374,
            limb1: 0xbb420615e88b3b3e751019b,
            limb2: 0x1c8baf2e8cf9c832,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x6ffe8674ea7d664329d21c4a,
            limb1: 0x30f2edace39818c4f5d4cd54,
            limb2: 0x22a7b32f48b0882a,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xedd1d0959325376134891630,
            limb1: 0x1128395a9b57a29073cb0850,
            limb2: 0xf3743d152d6505f,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xb982975f8f3754c447048e4d,
            limb1: 0xa1f5febfa531fb8eda900af5,
            limb2: 0x9d186ca8c21f49e,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xae55ad9465da2d347c06d679,
            limb1: 0xef03eabc82c065f5848ac316,
            limb2: 0x3048edc721645512,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xbf3fb43ad7c3bea794a1bd69,
            limb1: 0xb370c4cc79bacdb996aa7769,
            limb2: 0x152d882002404123,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xb8acde096bd6f573c8807c88,
            limb1: 0xf9370645c8a230645a4558bd,
            limb2: 0x11060ebe6c0900e0,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x6f8b7c4c8c4850fe1b091402,
            limb1: 0xba7f7d879ddcfc28350fb8e4,
            limb2: 0x251131fc4797a238,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xc067941904de6452a702cc36,
            limb1: 0x36010868f854adcaac243b23,
            limb2: 0x2be8d5d432d0e622,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x48bff01c3e0bb1049adc54d6,
            limb1: 0x5f6636dd538087bb8e95c05e,
            limb2: 0x1aa24bc4a8d0aca4,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xfed7cbe3be258eacb3805c43,
            limb1: 0x6a6b305ac8710cf771130d6a,
            limb2: 0x20c5bdfdf73feb71,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xd8ee10b63f015bcc45e694b3,
            limb1: 0xde212e60212fd33b5fb07f79,
            limb2: 0x10406d0c66676419,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xae6200bbf69b2d8222adc0c9,
            limb1: 0x5ed8395ab5798779de7855c7,
            limb2: 0x1306f0dfb9dd1f33,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x7d3e5564e11b0c0d87ce2fcf,
            limb1: 0xa011abe1dfaff9533b90024b,
            limb2: 0x4414840770b8d45,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x1abbfaf4636b146d437f0f32,
            limb1: 0x823aeee9a4d8bec2345f04eb,
            limb2: 0x474bc80c3969d26,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x4574559e190f5a9005079834,
            limb1: 0x1a14b1796aeaf3cac262c90,
            limb2: 0x2a206e06250d18c9,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x7c011e64290a2723d04fbb47,
            limb1: 0x9bf025c6164128c502666a3f,
            limb2: 0x22056cad12d485a3,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x2c4a99cfec75332ddeb73d3f,
            limb1: 0x664ed1b9b659c29a8c5e86db,
            limb2: 0x1c996a2f464fa6d5,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x68cb5b19d04919eb3904b718,
            limb1: 0x3c200fed008fce871c299fe0,
            limb2: 0xc82b868b865eaf2,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x8d319155c9ce9e7023bba44a,
            limb1: 0xdf6d46a6eafac55cd37588a7,
            limb2: 0x230891a91d84fb9,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x6c47fa46ada891b1ad0d4a2d,
            limb1: 0x896ef732068203aae4835c7f,
            limb2: 0x13305bfc59ed9f88,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xdef6d4b1bb52e3ed41f3149,
            limb1: 0x4d38ba467238b118bd600aaa,
            limb2: 0x23a7c08a0d34b716,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xe65bdf2f0e46c5d14bb2d437,
            limb1: 0x75d347475ec4f5e5da58702b,
            limb2: 0x1e813045e86534b1,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x19aa620481b7ed5be5d86a56,
            limb1: 0xfe7790488a68214c21b7e599,
            limb2: 0x60c00e0cb979bbe,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x681c25373d992243e7bc4316,
            limb1: 0xdaa79fd2125a52658e4edbdf,
            limb2: 0x8712013710d9b84,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x26dbe63cdb5675671894a27c,
            limb1: 0xe81e4b46a10e510982b660b3,
            limb2: 0x8c1356b21364b2d,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x180ea20e04ff0cfea452b5ef,
            limb1: 0x33a60d4aedd65598601bb804,
            limb2: 0xaffd14ad17ead4a,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x81a910653e6e700bcea6610e,
            limb1: 0x6d6da92fa688c271dbf2e929,
            limb2: 0x1c6e6b669bcc47a2,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x9af3035b52384ba68596606b,
            limb1: 0x3fa4f17d582ce91fe8ca38fe,
            limb2: 0x4fe17bae4b30f16,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x1ab98ebb109073ba1cbc0dbb,
            limb1: 0xe660bc83caf74b1c8bf3ffb9,
            limb2: 0xce501ef0be5371c,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x9ffe62d6c121725aa3dc36e9,
            limb1: 0x6737e5cd363c5c11c8bf9ce7,
            limb2: 0x17c47bea351ac796,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xf372cf537d3cbd62464f2996,
            limb1: 0xc2b9f39affb15c1c565820ca,
            limb2: 0x5574310dc643654,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xdc8bb75702c703f43630205,
            limb1: 0x95033f7e1161bb1c84e88163,
            limb2: 0x46d85f905c3f6b1,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xa9acb5a9647aa09d829135c8,
            limb1: 0x4bd37d411bc856d38f320e81,
            limb2: 0x7896f127bef56fc,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xb4ff705d518fd8d507edeaad,
            limb1: 0xb8d6290591e20c70907b4f50,
            limb2: 0x13cf6850ed83a8dd,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x9e8a05fa2a451c111ad1c113,
            limb1: 0x8db5108125c5cbd78b9da01,
            limb2: 0x27f247c7aa579dc6,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x9178a3dddec5c7aae0e06dca,
            limb1: 0x58c7e0146524cbde6f68e28f,
            limb2: 0x88e852062e630dd,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x69f9b02ecec442e37998de01,
            limb1: 0x5cec46a3b23ea712f31ade1c,
            limb2: 0x9fb06804e3f2902,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xbf97e7024cb4c784db5bb1d2,
            limb1: 0x885d190dc80200b104734467,
            limb2: 0x2f8c96b95a4cc609,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xdbefd57376bacff12dd5bf8d,
            limb1: 0x725a4a257518c7f89ddc7147,
            limb2: 0xc764f79ea6d7683,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xfa3fe08305546a6b3bf2e9cf,
            limb1: 0x710f3caf9d79a6696b4d972,
            limb2: 0x12139b7a210ceba1,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x508cd98936add0253c52a372,
            limb1: 0x802ab928a43250c71b30e58c,
            limb2: 0x5fc4912d57a3f0c,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xfec54ca77219e3f19676ab7b,
            limb1: 0x35c7f555865188a018a4da62,
            limb2: 0x21186a3acc624741,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x21ddf02f404de3a01207e58a,
            limb1: 0x23771e91b431f2af1f1ac780,
            limb2: 0x8e3f5e341b6527a,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xe4a4409417045e8a52de5c81,
            limb1: 0x7285bf1777e48aacf83eec1,
            limb2: 0x20fb9b67bbbd29e1,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xa48af9d53abedb33c38211a1,
            limb1: 0xcc79b186b059588232745396,
            limb2: 0x117cf4e8ab0d8c01,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xbf62a89fb0b5572d634e036e,
            limb1: 0x62a4d7777fbdb30e117e4c96,
            limb2: 0x1433cd8e6693800d,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xff6e40d2e595bd4b38b984b5,
            limb1: 0x10a254dcf6a53cd6a1a536a,
            limb2: 0x205a86246aa4e70a,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x6ad13bec3f64b16831ecf3fc,
            limb1: 0x77e9fac67ceed69e2884e6e2,
            limb2: 0xacc767288a196f5,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x212a64c8db6818125f5c9d93,
            limb1: 0x8572ee34b58bae6edf226f4e,
            limb2: 0x2948ef466aa9fd42,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x866d9dd94cf5c01da1af5b70,
            limb1: 0x89ec47fb1c069b4a36fa36fd,
            limb2: 0x2a0587e51228856d,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x771ffaa3db79c0011aee776f,
            limb1: 0x40625b6f2ee697202dfd503a,
            limb2: 0xa81c431cf771fa8,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x8711b2a55df6bf89af526172,
            limb1: 0x1eb553b6ff69efe960c7c10b,
            limb2: 0x1f669ce048bde363,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xf800397513b7b78bd8083e57,
            limb1: 0xc4528a9a59670bbb3033b697,
            limb2: 0x262a51ab0a32bc7,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x84c92b9b7085152c191113c9,
            limb1: 0xea86e4190741f5a1d63fe1a2,
            limb2: 0x1631d1377040b84d,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xfc0579707daf96862bc47877,
            limb1: 0xf0a566778792313273feb448,
            limb2: 0x5e725ab3a8f04c2,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x746e1d6337bd29553a1a49d2,
            limb1: 0xf5e43538015ea9d289aae3bd,
            limb2: 0x2b858fe696979a0d,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x5d0468a94a03c5e8fb9b7442,
            limb1: 0x4bcf854c79dfcd8f93f7b5a2,
            limb2: 0x235b6ce0b723a15b,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x47d3184d435caf4d8ac68218,
            limb1: 0x5fbeeeccc4f0d2b4b35ff5c1,
            limb2: 0xc44d4495a9252fb,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x1920a8fe49e6829c82f62ce8,
            limb1: 0xacd523669ac89fffaaebdae1,
            limb2: 0x235b4c0c2409068e,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x6126477661fb01a2eda1c7e6,
            limb1: 0x393b5af3da3463a0c92ffad,
            limb2: 0x302d5c3952fea360,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xca17079a6b293fc5c658989b,
            limb1: 0xbb41d630afba0696af3a3407,
            limb2: 0x1f7d9b481972987,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x2226ca676134b1f3a0926460,
            limb1: 0x826cd143e34fd3745d995e86,
            limb2: 0x1d54d2aa3c5f7ac7,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x3515a092edde84420d650907,
            limb1: 0xc0e550c22584c2319b0a82c,
            limb2: 0x1dae1ecd1ca07560,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x7c23169a2d1ed918ab673e29,
            limb1: 0x5484a8a7a79ea6c754af3cad,
            limb2: 0x2545e6dc3f9ce4c9,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xd125d5ce04b20018ad6f85d9,
            limb1: 0x1525475fb4f94e15acb82f7,
            limb2: 0x1f82f7bdc16f6382,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x51de6ee8db519dfb0aa693eb,
            limb1: 0x64c7ee0f928747a2f5f0f936,
            limb2: 0x1202023a3955cdcc,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xb6ba4af6f923a0d846ce153c,
            limb1: 0x60fe2184eafa93f4eb996772,
            limb2: 0x16d57296a4ee3e6c,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xa60c48290b411ba3f980fe24,
            limb1: 0xbe6ad7c874855edaa1b65a97,
            limb2: 0x46ed521f5594ec,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x45849bc30c4d8430b3c651ff,
            limb1: 0x2563e767d417bd382197c73,
            limb2: 0x16709b70a1667419,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x2bdced180a9910450908f1a6,
            limb1: 0x1f4ef7e2d77e9764f537f621,
            limb2: 0x209b61f43f3290b,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x3d1fab7bd5a20ee703a3a1ab,
            limb1: 0x6dd08c68afb95f625c81c7df,
            limb2: 0x2fceb99f81d59152,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x61998f00abc817c74677e69c,
            limb1: 0xd15359c21be66df2e9f763a1,
            limb2: 0x20acc9fcd918b204,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x58c54c374dc0b19648206559,
            limb1: 0xaae9d1fa0b4859284de90438,
            limb2: 0x18b9cb802e16400,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xa8af1d6e69891fd6151f69e5,
            limb1: 0xc9a0fc4d628c3a9cfb33e957,
            limb2: 0xc205db4af1bd115,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xe04de2e204ed323699cbf1d0,
            limb1: 0xcdad0d6d615cf2efe6486b8f,
            limb2: 0x24feaffdc4c0f6fb,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x9a74590fcd5dd32ce4084080,
            limb1: 0x26eaea5397bec2eddba3b007,
            limb2: 0x2e171e90cd48c68b,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xcab514b4d0f8c4de087167f,
            limb1: 0x4089650224f0df0b55cdbfa5,
            limb2: 0x20e3e700df023af1,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xa952db0b09a1e0a8afa85959,
            limb1: 0xd31513490bd63f93546b8b44,
            limb2: 0x2b62974e51c3e808,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x3082616da438e53047cf7b15,
            limb1: 0xad132a494322c88251aa940b,
            limb2: 0x1638631f0b09eb79,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xe2e5db1f9e9b7d34a466ca2f,
            limb1: 0x6edbd12f1ef34ed5334cdd54,
            limb2: 0xc499b73f6f41690,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xaacf3111e2b20853c931d1c1,
            limb1: 0xb35ae0c43b79be6e06117404,
            limb2: 0x2a23dec3816a3c7d,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xb6ed55030e8729397efcc145,
            limb1: 0xaa34addaea010361c02e0306,
            limb2: 0x2742bd085dc8c143,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x898d7670f9872d2107b383bb,
            limb1: 0xc214e84a71a23f180d9eb8d1,
            limb2: 0x168f2063fe0912a9,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x578ba288320514edb50b6e8f,
            limb1: 0x2d290fa04eb58f49066fbc74,
            limb2: 0x2aa6192fd793ef3f,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xf67d935533f75f98ccf08227,
            limb1: 0xeea0611976e71b0aeb4b1b6a,
            limb2: 0xb73b7adb8c016af,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xb3f4d09089d3ed8d435eb8c0,
            limb1: 0x86f51f3c75097e64c5ab5f62,
            limb2: 0x1c6317402ee2fe95,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xa00c59cd149cab75ac1e1263,
            limb1: 0xdf8f325f8fd713ebe123f6e0,
            limb2: 0x20135070c6c2f86b,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x692e693651922c9ed5b55f8b,
            limb1: 0xdfe74e43af132550435a9d1e,
            limb2: 0x2b72066a933709f1,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x5d49b84a4aa6058a6d6e703,
            limb1: 0xb1f91b7ebceab14216152085,
            limb2: 0x1967682ee3c18a7a,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x33629d96c671a40a62c2da4,
            limb1: 0xb414918620ae4edc267c0bc9,
            limb2: 0x1d3961343ac4df2,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x254d73fe94cdde8ed9890b6b,
            limb1: 0xb962da0dcb410c53789cc70e,
            limb2: 0x16e205ec74090889,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x578ac38bd46442e3921b93f,
            limb1: 0xca84b0403bce539c78c6e5c3,
            limb2: 0x204ff9c462bb7f72,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x87c93d98fcfc7555f15f52ad,
            limb1: 0xe3263a16c0c8a5a7efe968ff,
            limb2: 0xf07070bfdb0f99c,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x906d9cfd92ee9a42ed2259e4,
            limb1: 0xfa9a8f287d966d31195be1aa,
            limb2: 0x1d8e310fc8f947d8,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x56b93c74493683d4c708212,
            limb1: 0xb1e5c2fd8c2141c61b48f7e,
            limb2: 0x54d4690b93bed74,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xf44f49b074bdf24754dfad0d,
            limb1: 0x67a90c021637ee954c2a379e,
            limb2: 0x1b9888615ee2913e,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xaab23130c5df9453f58c1134,
            limb1: 0x33731a3fa835e82c50ce2efd,
            limb2: 0xe51950c67c429a,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x278c9c013ae096a555b3ec0f,
            limb1: 0x610d15043cff6872498a84b8,
            limb2: 0x2be6b3691c3b1cdd,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xab1801f4fb51698ffcf4a785,
            limb1: 0x2c5b0c65e18486f1db2e7b16,
            limb2: 0xee1c0a5598d8ee5,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xdccb4b414e4b51403b40c360,
            limb1: 0x950f6c1774b0a9274543e3f9,
            limb2: 0x3035735696163c43,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xb13ffd0306de54e54da63f29,
            limb1: 0xb0d7c02dd2152dfd24e837b8,
            limb2: 0x61f242c5aef937a,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xbff090424ff64b168abd7ed8,
            limb1: 0xfbf2b7ff152e680def29cf67,
            limb2: 0x11631c347b8d5722,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xa4ffe19971619f52dec586fb,
            limb1: 0xfadff2ba47b489d5054debee,
            limb2: 0x21a126d22cb30a3c,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x75ac1ea03e30d1ee2a7ad65,
            limb1: 0x37410414baa2eb7017bb5855,
            limb2: 0x1a51ee35991003f5,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x455c7935775dc77497e7c89,
            limb1: 0x2d6c275c5c4ba0a575a19c13,
            limb2: 0xc0dd9d3ea7a9ade,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x4af478bc839dde72d2e8cc92,
            limb1: 0x39a0acadeb78af4fb5dbe383,
            limb2: 0x1b446cbeaea59d46,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x48d371224068708ad6cfc116,
            limb1: 0xeb6f5c875523671fe6bb1f80,
            limb2: 0xdba3978f44c9853,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x4963a814014539613a3e815e,
            limb1: 0x6245603c8b693d1c28c16e49,
            limb2: 0xb2ea516ccda6f09,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xf5ed7ec964654532426b4888,
            limb1: 0x1a7c82c2b8af5cecbcdca52d,
            limb2: 0x27f711764b54cee8,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xc53cccfdb561e69a52782bb,
            limb1: 0xeeec6da4d5ebc08df5815014,
            limb2: 0x1d29e3cafeebc352,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xc6aa872125f3b220f96a9cd1,
            limb1: 0xc0e77f6ac66bfd97664139e0,
            limb2: 0x3741acbda901459,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x52f1a5f6845306c0defbedd9,
            limb1: 0x80a6b1b02f80301d3a0dc080,
            limb2: 0x181a86be5b8f64ec,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xa249185699b571387abcc094,
            limb1: 0x1c4b4890cc3addd178e2de3d,
            limb2: 0x27ac0852aee62087,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x35c2f42c8ac8c3e4454917fd,
            limb1: 0x3bf48982e71153a198e54963,
            limb2: 0x2a9f396d0d827ead,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xbea85053b686a4fb31267e68,
            limb1: 0xbec1d438473d13cefa4b0bd9,
            limb2: 0x25c2cbb7e7615d3a,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x4003c5a77762d598d26651ce,
            limb1: 0x2efe1dd975f92a292079355d,
            limb2: 0x17d7d17be5145528,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x7cfd8f75da47da500d6d8c7e,
            limb1: 0xf63a158f1246fa8382aef748,
            limb2: 0xce3a2406f7606cf,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x71c82502374ad055eee34a70,
            limb1: 0xbf607dbe6e74c9f06bf0f2f2,
            limb2: 0x17ad31e67a125bfa,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x75e0f096ad837bb65e18f5fe,
            limb1: 0xf57acb24db4e597ad6dfd0c5,
            limb2: 0x2baed364893718d3,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x650c59126052997ddebdbf06,
            limb1: 0xe5694f3d235ba12f4e80e1da,
            limb2: 0xc3d775c73973d78,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x86ecc04bb1dda6baba72f110,
            limb1: 0x26a56fe363233bcba7a6bbc7,
            limb2: 0xcccdf39db0efceb,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xd14af8581af5048d860b42d8,
            limb1: 0x5983b9a1ab460420aac0e5fa,
            limb2: 0x2cac8350464e5a46,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x9852dbbe33a5c81ef2ef28df,
            limb1: 0xe27bbdc0499c71d8751fa8fd,
            limb2: 0x2596598d10b8e209,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x5d640a56b866092cd2ddda67,
            limb1: 0xbc7c9df1a76876f2af28a37d,
            limb2: 0x198c4d4be5dfe657,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xf75e1f774ca4206fa9fcda52,
            limb1: 0xc094c286837192006d77bf19,
            limb2: 0xcf2a11e9eea72d4,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x3f7d6ff3e3048f3d3b217cb3,
            limb1: 0x17d29aee9dc30e589c3409ce,
            limb2: 0x13594ce650eafdb7,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x56007f7714afee54d813795e,
            limb1: 0xfbeadbe9e4d223705b6f52b9,
            limb2: 0x16c1493ccf93baf8,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xd61ca8fe2027f969c984a06c,
            limb1: 0xfd681777ceaa7b105f32c686,
            limb2: 0x89c32a2360185c2,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xc0be27a2efabaa040fc34bde,
            limb1: 0x4025016352e1fb49753dc175,
            limb2: 0xae0f4b4e22bbbdb,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xb714a66fd690196097466167,
            limb1: 0x470b3ea1df7db4f80c0f7c28,
            limb2: 0xa2b04b84a338d79,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x99e371187196a0e5e1cf157d,
            limb1: 0x1c37ecc4a15489ba4d1779c,
            limb2: 0x2241007f12297498,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xc2d4196793dc2c1a6195e84c,
            limb1: 0x84aca2b3cc656ac3aaca479c,
            limb2: 0x25be01f34c7b0108,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x6284320ce1e28774e12ac179,
            limb1: 0xe63f8969b7d4831c0df44b75,
            limb2: 0x11959f32e56582cd,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x12b126126d6a51f864d86b21,
            limb1: 0x1d0bdb4abac53547bcee2b4d,
            limb2: 0x2947d69adc1260a9,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xe7865d832dc76c6f81e52540,
            limb1: 0xa83bffdb570dac4070b74623,
            limb2: 0x2f7f591b620ebbf0,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x8c19ba55fbe3b83ab9a52ce4,
            limb1: 0xe422487d5d7a55084660e279,
            limb2: 0x451963810a77462,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x238470f53902b433c24b5095,
            limb1: 0x9f92f5a1a4c3dc5f5448ace1,
            limb2: 0x25b02dd2b4f13ea8,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xf8c9c8cec6607f52c0c9a1b4,
            limb1: 0xe4bf0bcc8b18ef930b8f8498,
            limb2: 0x2afb9cf3aeeb2bbf,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x2005f7afc42e1e0c95cb60d1,
            limb1: 0xc5767bdb11d976e34bda43e2,
            limb2: 0x29602013060d4ff4,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x11570e8a2564f4049b9db0ec,
            limb1: 0x49eb826e6b83eff0404680d5,
            limb2: 0xcecd3d8af842dcc,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x4b7116478737ccae251f21d0,
            limb1: 0x801cc3a4c2973adba6e4ddad,
            limb2: 0x2b2f6090ab698026,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x884df7b9c6266e14cc00d544,
            limb1: 0xb39ddb5ff70292b139767896,
            limb2: 0x2dec0cf17a7a9728,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xbf786f4a5a217fd2fb81a73b,
            limb1: 0xcfb52addb110bfc90b6aa315,
            limb2: 0x20acfe4cf1ffb3f4,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x58fdca71f63cd7f2da6998b9,
            limb1: 0x979bbe60391be8c8c020eb17,
            limb2: 0x1d271bcc5d463d8b,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xb4604fea4e6d2fa87b6546ca,
            limb1: 0x14ec3cc166da4fa93e7855e,
            limb2: 0x19eff643e695961,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xe3fff14dc344f49a147400af,
            limb1: 0x552fa30aaf36a28b944068dd,
            limb2: 0x22f12a7ad2b957a7,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xff8236c0d8500425ffffe979,
            limb1: 0xd995e8b2955425eef9effefa,
            limb2: 0x1008627aeb38039f,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x761abe6a1a610e88ddb82821,
            limb1: 0x7f484e89e288b114a86e3104,
            limb2: 0x571350412cfb043,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xdbe60b9ed4870dafe4f6b562,
            limb1: 0xe27c012c5483844720417b27,
            limb2: 0x287fcf364036279d,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x1edeb9e08e49a4cc6d595a6a,
            limb1: 0x4d749f26fcf5c2d70c0a0826,
            limb2: 0x537349d42ceec1f,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x71e75fa5345f7af0598be8fb,
            limb1: 0x94e35008e8882d98556d4f9,
            limb2: 0x1e5f86ec7f29e8c0,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xa59a00e6ef1857c7f37bba17,
            limb1: 0xaa80466f9ff308394641d17a,
            limb2: 0x22e8b793fed10566,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x85cc25707c980abee1603524,
            limb1: 0xf0a1429f6a9ce800109dd3c6,
            limb2: 0x439246edfedc6a0,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xc3464ca03c070344bc851998,
            limb1: 0x628900ddf59e8fcab9e544cb,
            limb2: 0xc46d4de05410eea,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xc3fcebdd079623bfdfe5b76,
            limb1: 0x7293b945aea37cb296e5fe79,
            limb2: 0x1dfc0017bebb3827,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x8330726aebe0e9005929fbf2,
            limb1: 0x4aaecb83bd354c28abc709fe,
            limb2: 0x1db100a3ae9d2796,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xb769d01c317efe1645b5977,
            limb1: 0xc531f97ebdd47779587f7f3d,
            limb2: 0xa69ded3c01e9477,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x58d096250a5f996582135298,
            limb1: 0x8b3a621d056b54ccbe85d4a4,
            limb2: 0x26de0b6ea20b2417,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xc0991b57a9e1506cab1180d6,
            limb1: 0xb77b1f14ad48be33a9a3d3ea,
            limb2: 0xddedb919473952,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x50b24127a621793d80986ea8,
            limb1: 0xd87c2df07cddcdb160e65f00,
            limb2: 0x1a376e99bcc12456,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x94e5f9f1ffeb27d8ced55bc4,
            limb1: 0xe0c8f2e76317d89edbac2b16,
            limb2: 0xd5c6a5a81f58007,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xd9e189bd465323e7ccc5c8d8,
            limb1: 0xf3854408ae8833a96c0a44a5,
            limb2: 0x2aa4976b776fe008,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x6e0592dc622bfba3f3604600,
            limb1: 0xfaf5659c5bbbef47b9ac96b3,
            limb2: 0x1f0dc42f72ebc953,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xbeed1c4160d214aab80de397,
            limb1: 0xc2db7a1fd04bf557fe496c1a,
            limb2: 0x2d95453d59d9f447,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x8034644d710c6dbba13e467b,
            limb1: 0xf87cf4201f6abf6533e972e,
            limb2: 0x2e24defab8e33de8,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x1694446b59660ec1fed6fb9d,
            limb1: 0xc0a4cbb8310e198ce8d997e,
            limb2: 0x2da8657ea7730f4,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xdd70e38f79be7c342e31044d,
            limb1: 0x5a8d74ec827b1414b7387287,
            limb2: 0x61248d0ea9090d5,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x725a8201bde6223b676c1523,
            limb1: 0x645238ecfc00a99aeeb4eeb8,
            limb2: 0x1d1fddea44ab94d0,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x83839eafce9360837b497639,
            limb1: 0xcbec9216940c09f042d3153c,
            limb2: 0x2180c12b34129e84,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x5bac5422643e869c95e8758,
            limb1: 0x75a87d464e85d848733732c6,
            limb2: 0x17dd4782ba72be36,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xaee3bfbad5100e0a925100a9,
            limb1: 0x71d534c3c0a75b458dfcffeb,
            limb2: 0x6ce2915078a5228,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x551047c5156391326b3100c8,
            limb1: 0x6342cb22397195c24b239d2b,
            limb2: 0x21c7584f2234b2f4,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xddf561e69f4a85c68a1fbb5f,
            limb1: 0xe60381a1141b501717848e3c,
            limb2: 0x18963467c96efe0e,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x43c0e893813e89326e6d7292,
            limb1: 0xa039460fc1ffe8b46a153b1,
            limb2: 0x27d053716ecb9cd9,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xf50b97a916e074212516e5b6,
            limb1: 0xd022b79f1419b1f40ecdf478,
            limb2: 0x1d1206da817808b7,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x25a6cedcf5d6ddb32b966856,
            limb1: 0x2a4e55aedf867fa395c11b66,
            limb2: 0x185e2c0ebb4ad386,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x19a943e29773716d15946034,
            limb1: 0xba20fb1af88682e70de60783,
            limb2: 0x17d681927b62d229,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xf7fa1e079660015140590591,
            limb1: 0xc30ed30ec9915ab4fc15f7ff,
            limb2: 0x243a6006b965f61a,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xf8da46207ede41bd56e50a43,
            limb1: 0xe04b09702796cd90c2425928,
            limb2: 0x2e7ae22af53376f2,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x5af2801c7d933321f9435b9b,
            limb1: 0xd2318d1258ba0c6c1daee6d2,
            limb2: 0x23afd2f1a99800e4,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xe39965536174be4d41378ab2,
            limb1: 0x86d346ec3ef6a2dfb8319fce,
            limb2: 0x1da387ce6ce0d298,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xe44b9574eb888dee9f4e20dc,
            limb1: 0xf31eb1efa49ca68cc34081f,
            limb2: 0xfad1981220113be,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x9ab7843efd617ddf119164fe,
            limb1: 0x76cafdac5a293b073ed57ad,
            limb2: 0xd0e754b42bb068a,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xe334e2852f757ecc004f2f1e,
            limb1: 0x402aa243f80d326c17d11b15,
            limb2: 0x1f6c545d5d39392c,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x5749b413972936886b183b9f,
            limb1: 0x7d2a1beec672867c931a8293,
            limb2: 0x1ccda8ec93a0273b,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x9f47ddea4c0b8b40dc986ddc,
            limb1: 0xa0be8511b87227fadcd76ee8,
            limb2: 0xfcdf0494a2bc732,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xdc00663637fde6d5b906e716,
            limb1: 0x9b2a202f83175ae5c305a611,
            limb2: 0x5d06f2336099060,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x1a585c16370b2e72ce762004,
            limb1: 0x456d73db558a873ad7cff6b2,
            limb2: 0x1fa965f8f98ca6f5,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x2d2a8f6911befce21db0812b,
            limb1: 0x8c0ea802fda5c7080ea50395,
            limb2: 0x7c5df2dee8313c3,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x982a9081f5f8fd9414004f29,
            limb1: 0x48745d3195d133f3f7eb9cf8,
            limb2: 0x23d50a6b096134a0,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x8dd690a16a679f3d3e41fcb1,
            limb1: 0x2bf5c469d6877f908feb3a87,
            limb2: 0x2e773e73fb695075,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xf2ed81b71eeab0cdfc710ae9,
            limb1: 0x57db9a4270f81dc9bfb64860,
            limb2: 0x334d7b08732b83e,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xa8882ec080970eca432a600b,
            limb1: 0x8d6928f84217558b4b8126f9,
            limb2: 0x1b67ba76495fa971,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x1c3dd7d156d67be9f4aeaa8,
            limb1: 0xbd90237976f8394378306671,
            limb2: 0x1d08036915e0dd71,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x231d2b731b96c51d226edaba,
            limb1: 0x54f6870a63eb1f65452f2dff,
            limb2: 0x19a442e5ccf62230,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x86b0048f2b838a694846ddf2,
            limb1: 0x8ebdbd6a17deeef0a9e89793,
            limb2: 0x2c3fd637cc908694,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x544fe7404b052b92ddd8749f,
            limb1: 0x856ebabdfc6c86b29d302e7e,
            limb2: 0x1451419a1600dfa3,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x2fe1ebd1e53ec5b0f4268e1f,
            limb1: 0xa1cc2188de0d3fc7fb34bf66,
            limb2: 0x182fc2a35b3ef175,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xfe3f3818077e92dcdf902b05,
            limb1: 0xa93c77db9fdbd5a79d361028,
            limb2: 0x26d3c6d6d5a4c130,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xabef3803fdcbd839e246be11,
            limb1: 0x72f95ceda7e53263113f8da9,
            limb2: 0x139aec1203d92ce8,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x807eb60ed447012f9ad15b4c,
            limb1: 0x3bd36cefe2ac948e16e9c0a8,
            limb2: 0x6bee881437b0e5a,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x56bcaed9684632a2bfce5bb4,
            limb1: 0x9e429f5aea1a66eeecfa2a38,
            limb2: 0x3d76a3ac3d4651e,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xf318a717ace4c189f90f3f81,
            limb1: 0xcb324779d5090afc09982055,
            limb2: 0x305aeff1c47da1d2,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xe74153062b51dea4abbaa7c2,
            limb1: 0xb0af9f816b16aa186af3e5df,
            limb2: 0x159bf9ee77d1b9e2,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x3e70ac7ef6cf83592cd954eb,
            limb1: 0xb0a5fbb32a160b0cee7f9034,
            limb2: 0x2c6199de44cc1f4c,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xf158629d155bd7e202c572ee,
            limb1: 0x6db77b2b4493bcb7586d1246,
            limb2: 0x2367d2c9cfaed9d3,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xea4f9b43d0967753e57cdbe0,
            limb1: 0xc3eacf790d335214d6223e55,
            limb2: 0x19dad509ae22484c,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xda40ef1b79f182c340cea093,
            limb1: 0x2763ae12c9f0cf8668079884,
            limb2: 0x2bb5813ff3e9ca2d,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x510f871618c4726ed002cd0e,
            limb1: 0xf17db1c8beafafa17311becb,
            limb2: 0x26885d10b141626f,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xbdca04cc049ead113f92fdf0,
            limb1: 0x34a187101f66d212fd60eeb6,
            limb2: 0x2b1014e453475cff,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xe444f3c70fad06b4b6fc0bb6,
            limb1: 0x9f1c3c9ebcbbea9fbb631c54,
            limb2: 0xb918e8ffbfe8a02,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x606807fa707dacb60e4f7b53,
            limb1: 0x4ef1a20b0bc39ff0b4e48514,
            limb2: 0xf218649f2e73b3c,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x81fa6d620e45c23cbbf1f622,
            limb1: 0x38da47f11b383ba1461436a3,
            limb2: 0x837612c329d697a,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xfbeac24075d6f0bd847f505f,
            limb1: 0x11f0f12ccc004707ce2fcec3,
            limb2: 0xc310bf45f22489b,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x184769ff32effb0080bd9282,
            limb1: 0x94861b6747fc96bbd348eeb5,
            limb2: 0x1c4daba8fedab142,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x83488ba56a75bac2444eb9bc,
            limb1: 0x8b62ed857cf1300abd22eb9c,
            limb2: 0x135d64f62ca31e90,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x54eb4787f8e28813b82ec15a,
            limb1: 0xd07f5859c765fdaabf1f0f80,
            limb2: 0x2aeeddeb65ef03ad,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xab04c28363de86ea6f72de4,
            limb1: 0x30b8ed32ef343187e688d103,
            limb2: 0x168605f7c0b37cb5,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xf62ab1cd395ae609d2f685ed,
            limb1: 0xada87a28a9d619b144c0b35f,
            limb2: 0x2eff0a0507e5218d,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x4ff357d0c6ebed186e1f9c40,
            limb1: 0x20dd88d263bc52219e2f859c,
            limb2: 0x24d6d1a731984ce8,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x1d5151d06ca52aece509cbb3,
            limb1: 0x46548add3b8e3d3faacd05b1,
            limb2: 0x199d296e93cf8cbd,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x8a033bf6880534fac8cfb54c,
            limb1: 0x13f208e848910d7bde1192ba,
            limb2: 0x1423c34f98fdcef6,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x598d27c08012f40c3d3e9e75,
            limb1: 0xdc4107a10a7d803199d93086,
            limb2: 0xc5257edbf918701,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x4a3400be453d6b3c34e1fb44,
            limb1: 0xf91d5ac5ae679c33fff36409,
            limb2: 0x1be98b7749edf072,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x6680d0e3d2b864d119b827ca,
            limb1: 0x5aac4bc1b57a2e22ccf58cee,
            limb2: 0x23b7fc2f9a6ae22f,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xf0775979754e902669f0e444,
            limb1: 0x2e61682c7e17b57130ccbfe0,
            limb2: 0xf21378dff131bc3,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x621b48168acdc19dc97ebbf0,
            limb1: 0x9909fd8847205eb91ae80e2b,
            limb2: 0x15534e1988bea372,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x836091f715c8ad2669df0e75,
            limb1: 0x5b706e57f70b2b69b33c9cdc,
            limb2: 0x12f7d428e0c8ff0d,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x306d15fba474fc201a777221,
            limb1: 0x55cafa050b672c2507126a6b,
            limb2: 0x1c150bb26372eb1d,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xa188e933ee7410d97afdb93c,
            limb1: 0xd390d4faa3f1ca403fc39b77,
            limb2: 0x22ba33b8d7641e95,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x95c3812c2afb2bd2e4b35d5f,
            limb1: 0x61243c01b924123431702193,
            limb2: 0x7afc7339fcd4ad3,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x5234604f03b5a78036f17dec,
            limb1: 0x3e865fa0fddae6157c361e83,
            limb2: 0x62802572defde82,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xb0715990fb0e9c5e3a72b720,
            limb1: 0xc499138bc22f7a1afee6dc88,
            limb2: 0x2ce146b6cbc671d,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xa51df13c764911013f1d01e4,
            limb1: 0x452c277faac5af624ed11334,
            limb2: 0x2f5f956a9879906f,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x37cd61b56ba0cc6cd3d394e2,
            limb1: 0xffa51ac2bdd7d1ef07a66bf9,
            limb2: 0x1778ef73778c3338,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x958d7ab0ef0acf4b8c860666,
            limb1: 0xe95e65d08595b6669b49d367,
            limb2: 0xdd821fce8671817,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x82613df8271eef94f8216685,
            limb1: 0xce4517a26e9d1ff8435f6bd3,
            limb2: 0x2d74a37dda03ec82,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x4705fc6add33f6134dda85e8,
            limb1: 0x87fc37a77f2400df656f807f,
            limb2: 0x1c160e5ff98f44d9,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x6a0e358cc09cd9f66a6e2657,
            limb1: 0xb1a9b2fea93601140e30d66c,
            limb2: 0x9b506be37020061,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xb8c0a424d99a217f15aa5ad1,
            limb1: 0x3ce08d5d3a9f26850abc92bb,
            limb2: 0xc584793703cab09,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x7476f45ea5fb77da8b829946,
            limb1: 0xf7626f5dd86a7edf8028f911,
            limb2: 0x29f8098dfca1aaac,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xc9fff87a05c33ce3eded2d21,
            limb1: 0xc9e8f17fe3e0b85d320e969c,
            limb2: 0x501383f6709bbd1,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xfdb656adc73d5399ef858411,
            limb1: 0xbfb3e3e8bf9d10f4b92300f2,
            limb2: 0x221ec94144cc9503,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x7f784fdb25988b9e739fa0a2,
            limb1: 0x41e335a2f3e4081bbb22dca5,
            limb2: 0x150bf21eb0fc456,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x5c75a06c4109d219f61b90d9,
            limb1: 0xc2e411989fb430e4b8077ddf,
            limb2: 0x1fc92e394e9a7443,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x9f12c5e36ff563172d7e076d,
            limb1: 0xce5ea2485b7067459fc3bfc0,
            limb2: 0x10c435e4489bc925,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xcb1fcc16c1db36ad1dd1f98b,
            limb1: 0x7a05665dce33fb30e8b7f845,
            limb2: 0x2f228d68408bdaa9,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x6c8d68a53a20e8db6a36922e,
            limb1: 0x6ef7ed8b4ade471e7b360e4f,
            limb2: 0x372335e7c99259c,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x7017d2904d0594233926fce2,
            limb1: 0xfa48379b4b132710a1dff7f6,
            limb2: 0x2385d38da0dbb114,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x3a9f2ff75551df2a17657beb,
            limb1: 0xe52550cd27c48c296f6b8a4b,
            limb2: 0x1f0673c62b054a55,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x1fd60650d9ebf08d26d5662f,
            limb1: 0x335ee497e287d588e142931b,
            limb2: 0x94061dcab108ed8,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x2117ac3d8b810af45414a65e,
            limb1: 0xf9d8e0c2d34dbc01ba6516c4,
            limb2: 0x2616a50f0df232cd,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xa8d88cc91421d44d5b3a1f70,
            limb1: 0x9f87a0e24410dd01887d4fef,
            limb2: 0x22623cf78f62ad49,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x7c641d6c281ca0f3e6ff740b,
            limb1: 0x60d90ef7bc44c8ef1be2ba0d,
            limb2: 0xc33930f583d67ee,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x1e254e69cd8040cb986940bb,
            limb1: 0xbef1fd0fc1278c137ff998ac,
            limb2: 0x195fed4ec04e54bf,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x72ef64cf88ca0e2310845769,
            limb1: 0x124010206072f648469e36a,
            limb2: 0x209cdabbbe4ed2da,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x66009989d6c5b3bbed1c7244,
            limb1: 0x9b923ab5efcf42e8b58b4890,
            limb2: 0x1d46827edef8ee9c,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xaf42b8ca1f0f3fde33fa6f1b,
            limb1: 0x8d6bfbeb54a940e54761acb1,
            limb2: 0x47034f1a405f742,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x20160ad17a86578af572b444,
            limb1: 0x6226100fcae292da1c98689b,
            limb2: 0xb42319551f5ca0,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x7ff6b09cf8412d84d025a739,
            limb1: 0xe272f7c063606b0795d93e23,
            limb2: 0x2fd11f4a472e5d9,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x4eccbc82c42f15c76c27076d,
            limb1: 0x5df844d0bddc6f03628ddbe5,
            limb2: 0x2db58bf86207cc2c,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x4da27ff9c0713d6f4e912679,
            limb1: 0x8e42a4b32aac47aa92b8bff8,
            limb2: 0x1ffcbaeef206c93f,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xd79f1d42c15d132012d0d9a3,
            limb1: 0x7f12dc67f440569ca54e33ec,
            limb2: 0x2c795a6c13e9fe77,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xb29dfba2e9f7ceaf12388945,
            limb1: 0xfd21f9e454f33c6b559c3ef4,
            limb2: 0x1f2b7b0f361baf15,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x9089253d0961260bf9b6e84f,
            limb1: 0xd3b2b02f1e5793437562845,
            limb2: 0x1bfffd2c1b8e46ac,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xa6dcb677d94e6b642e563740,
            limb1: 0xa916660bb3ba274ab51207a1,
            limb2: 0xef682db5be44dda,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xc51db806ee9271ba0444aaf8,
            limb1: 0x1e64ff3fc4ab072147b4ea98,
            limb2: 0x29fb948d30a6c447,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xbe9d4e5a5d6607354d8b84fa,
            limb1: 0x529f5360f37bc6889a1f5c49,
            limb2: 0x22292b22236f729a,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xa1390d1df8a61169fe2fad20,
            limb1: 0x2f43ce0d6646511bbccc305b,
            limb2: 0x84191db12d5cbd3,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x5c47cbee80510a66c6f217be,
            limb1: 0x761503822ad6a85248936e2e,
            limb2: 0x2e6ac0418f5a3a59,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x98983785cde331f56053955a,
            limb1: 0x2640cd5372a4888e980eccb2,
            limb2: 0x2a07384c87d4b67a,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x9b55858fe46cf14b981ef5dd,
            limb1: 0xd523917972b65974b467a0a4,
            limb2: 0x20680bcae3752f88,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x185a5ce5b039f4d138071370,
            limb1: 0xf84b71cd3455721f8e0c52d6,
            limb2: 0x27896b9e5427708a,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xe38e7406470398ea866e7666,
            limb1: 0x469c634a652850b9fc55ec7e,
            limb2: 0xbb5443fb75a6908,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x47dea0eb6e71052ec7f4cae0,
            limb1: 0xd698da14d95068c463b69c56,
            limb2: 0x1f65534c95c4b4e8,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xae3a4964228081bd0a5da267,
            limb1: 0x4dc50ea815b17dcf8fcfab93,
            limb2: 0x147baa63d0128f4a,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x9a52abc55166507d4e594e35,
            limb1: 0x8a9fbfa8db11823f26443989,
            limb2: 0x20c105405420ccaf,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xbc7feafe1caa00cb56f140c0,
            limb1: 0xc92b358e8274d7407a4ecfa6,
            limb2: 0xc4bf8a4c30379e8,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x686706e60c9265112ba690ee,
            limb1: 0xb6e22d2f35f0039aaa35bc58,
            limb2: 0x13a0b14c6bf494f4,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xd1b245cdd962d3875ea427ef,
            limb1: 0x37b1fefab521a34e29ff85a7,
            limb2: 0x1d6d519e6c5363fb,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xc368abe858485da373491f4,
            limb1: 0x2dbcfb1d05311ad207642485,
            limb2: 0xdc5bf3eee990eec,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xa8d9d9d5a17eb39c5ce89ab2,
            limb1: 0x230b493f7cf8e265273d9290,
            limb2: 0x23d29d9813056963,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x175ed6c1c11408d0b72652e,
            limb1: 0x78dfb1d81e453e0e305148a3,
            limb2: 0xddbdb30156d6274,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xab9f4e1866d729338c0ca5f9,
            limb1: 0x7697fa46608f192407e02e0b,
            limb2: 0x3fcfc3650bd0ef9,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xfd8fd7ef5413808305b80aad,
            limb1: 0xee8d6fb1422dd21f669c7201,
            limb2: 0x2e8e0c5b212dfa07,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xd96af23541bbca0f2291d341,
            limb1: 0x51233672ffb62e789ba2e0c7,
            limb2: 0x1fd25918ebb20e9d,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xca63ef7c3c2f63fb0e754f96,
            limb1: 0xaea562c43e10b6c74ee8a750,
            limb2: 0xad84a64b1cfc9,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x504c4caf557777cb5f948604,
            limb1: 0x8b0977966c318c5da916df5e,
            limb2: 0x128986b5ee28dc01,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x8f00ea031aa0ea95a2cb7563,
            limb1: 0x44846df98f70c4f7af550908,
            limb2: 0x27a9332866b48b17,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xee0c7084b08248c9430fd394,
            limb1: 0xdfb9be5eec4e32939b557545,
            limb2: 0xbd7d6992746ddc9,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x1666c5b0bbdae936afbe3619,
            limb1: 0xb51e44770c1ebb92e3a8e8a3,
            limb2: 0x2ddfb1ac2adb9ec,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x1cd1039656d42a4ee5d10028,
            limb1: 0x543136ce44ec72695acc26b1,
            limb2: 0x1f552fd149b53c3c,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x8809303ef6dbd5d67c7e34ab,
            limb1: 0x759fd29d52db29e35a3c04fc,
            limb2: 0x3038f08335ec0582,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xf33925f9b68c26fcdc41ebb5,
            limb1: 0x2b4e46523eacb7d3d7679ded,
            limb2: 0xae9b529afa96647,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xbbf762afa9b7ec494e9919cc,
            limb1: 0xde01f8208e22254629805591,
            limb2: 0x2908b2c6aa755795,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xe719a960b123c63298d4580b,
            limb1: 0x70fdc5502d31860bf5e24d91,
            limb2: 0xad07726f92325dd,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xd501a4cccd1b92251e18acb8,
            limb1: 0x48d6dbb94067b970de5e8d62,
            limb2: 0x6582f750a7528e2,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xf1c4085263e1faa683455f46,
            limb1: 0x14d6048000b6a259d4e27610,
            limb2: 0x20372822d0559d81,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x56724ab391e5852ca8ca596d,
            limb1: 0x2d028c95cc3c85710f6bb5bd,
            limb2: 0x222a2fa42d6cbe4c,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x3efbf85dac2eb3831e650e82,
            limb1: 0xf4309ee2e36588550c1d4c36,
            limb2: 0x1e57f815fcc3317d,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xaac7fc5925d4a44b0c98f81d,
            limb1: 0x608989b8b278f212776cba15,
            limb2: 0x2d96aebee4780cec,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xf56e86d1ca0cd0542cbc4674,
            limb1: 0x11018bbc0dc8cd4b8b7ae4f,
            limb2: 0x22c3cd45600ce3ab,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x33a111bcf69011ed5dfea95b,
            limb1: 0x2418d7b1ee6d6f32713cfe7e,
            limb2: 0xd5b5c6d8c1519ed,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x2382a6bc543a7027de67c43f,
            limb1: 0xa38eaf7d59bda8fb4cb3393c,
            limb2: 0x1a9625a471ac3f3d,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x31460658c417f30241adaa81,
            limb1: 0x2d7fbd15ffc0f167b09fb12,
            limb2: 0x58d2b9e0bd06b5b,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x82bfa35b631169ad2f83361f,
            limb1: 0x99f56b3227f7e254defe5,
            limb2: 0x1950c5a24028a2aa,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x1337a344b6ac1fa757c934a4,
            limb1: 0xe33df35dfde3e6063ab1eb7,
            limb2: 0x2a3cc47f276a0212,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x1245820f20882f9139470e7b,
            limb1: 0x7a1c9e876bf26adb41c64027,
            limb2: 0xd422a9827cbf457,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x5f59c344aabe02ee306a7a07,
            limb1: 0x6ababab105f405239586317d,
            limb2: 0x1fc81898cef32a96,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x437d9858e6b05bca1aa1347d,
            limb1: 0xf012e5839e7f52c7d1aa4f71,
            limb2: 0x74167847908a227,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xa5fc5b1e5d9e423cf693e9a2,
            limb1: 0xf6cf7b8f14cb8bac89b003ed,
            limb2: 0x2b2fbdb6f3d2c547,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x4d27497878a92fcf1bf112ae,
            limb1: 0x6ed3fab765fd2b78dafba22,
            limb2: 0x20b6a585415c0f8c,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xb6046abd25f56c82783877ef,
            limb1: 0xdeead7b25917e53f6274438a,
            limb2: 0x1ea62e9f6b9581ae,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x4b45c74101e263842de438e2,
            limb1: 0x1de5d13076e9167da76b5deb,
            limb2: 0x234a516a4d637634,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x1a71b588bd25e5c61d88a8f3,
            limb1: 0x5d278614526c6bfd165be50c,
            limb2: 0x1ea7a078ebbdfef0,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x2af591b3a6ce1a91ed970c72,
            limb1: 0xe2f4ee607563097d22eff760,
            limb2: 0x1e3db808fe7f4be9,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x4a65dbea8b249e4bb7d6f89,
            limb1: 0xb7dd9a218720ff0d1cee04bb,
            limb2: 0x2ab465a3f689ce40,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xfb9bd919cce844113eb51a5d,
            limb1: 0x2415ec83cd2875963f51ceb7,
            limb2: 0x262ce736e9819e0a,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xa007bdfcbfb07d488ef141a5,
            limb1: 0x7f00d5f63ca999d9a73bc5dc,
            limb2: 0x25302703fc347c2b,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x90fb618d2fc0f78331a80790,
            limb1: 0x37f314c2c3a4f6b372aee4ab,
            limb2: 0x2254e3aa6d2d018,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x22aee155084437d36b4673f9,
            limb1: 0x6e5b1f8b55a312a7fc0d5fce,
            limb2: 0x13ab6d95ccbcf9d7,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x7ecd5ec39e2e9b688d7aeaa4,
            limb1: 0x77729bf869c5a1dc11f80ae6,
            limb2: 0xa4ab4cbe035d638,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xbae7313da7df5088a5f2f220,
            limb1: 0x1df603e4fb6e3a1a93053fcc,
            limb2: 0xfc8d5cd9811a4f5,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xa9643b8b51ba9c1aee411165,
            limb1: 0xc5eda1d47ceff78eba53c6c5,
            limb2: 0x67cba27e3af918f,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xbbdc08c72d30e0bb8b267bef,
            limb1: 0x9da54c8245f33163fd4c6498,
            limb2: 0x1ca91c6b163400de,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x7767ffa2530e4910bbeb9d6a,
            limb1: 0x24280b12e75928168db8db17,
            limb2: 0xda8635b51827e28,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x9e32f2fa8a95f36f060e121c,
            limb1: 0xb33bbe64b4fcbc221db72502,
            limb2: 0x1b3906450d00a8bb,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x91ffdc9eafa80c31241d1c74,
            limb1: 0x2660f321f1a657b8945e98e2,
            limb2: 0x1d456a7c25ac8fe7,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x9bfea7b3fc76917867b20020,
            limb1: 0x810fa5065a6b41e77ceec935,
            limb2: 0x2c8a1c71efdbecbd,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x2f85f2108456ccaa53ef65dc,
            limb1: 0x878b6f9f7563f90c378bc4fc,
            limb2: 0x4c7d2e26d1b9920,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0x78296cde1a06f23d06745e73,
            limb1: 0x1395e39fc8ac50fcbf74feb0,
            limb2: 0x15887f14dfab28b3,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xf6c96ed03aec71287b573c47,
            limb1: 0xd82c1129917c88c39187c58,
            limb2: 0x62e44c99340563e,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x9f5f8f1fc79fe0c32e31008f,
            limb1: 0xbdbffb831b3eddb5e2f307c2,
            limb2: 0x1e47e50cc12f3f3d,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0x2b99ce250113516077e3138,
            limb1: 0xf47cd426557dc1a0a644b032,
            limb2: 0x17798a574bcffa86,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xf0cd9b8ab6c440e787a8885d,
            limb1: 0x7500cbb999f2375c0874398,
            limb2: 0x2507d26d47778d6a,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0xf309174a30444cc45ef9b3ec,
            limb1: 0xba1c35e5c4366c3e8d630b5d,
            limb2: 0x206335368b8b0d04,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0xcb7e874047c87f0289676720,
            limb1: 0x13b09c1bbe23cf641b870815,
            limb2: 0x2469f344ee173692,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xe68e77ebab10145070499de6,
            limb1: 0xc608aaedf011053bc51e1912,
            limb2: 0x168c3766afccee98,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xde0798cd03867a27405533c3,
            limb1: 0x50d4ef22cc77987c7026e9c3,
            limb2: 0x297e8506ca525c60,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x87e6c0226d9bf9796cec7983,
            limb1: 0x15024a4918324b3cad118318,
            limb2: 0x102f20badd209d78,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x7eeb6de8801808a185b01759,
            limb1: 0x2e8680c6484ec17243e0f2b0,
            limb2: 0x1d6ca6db6ee3e50d,
            limb3: 0x0
        }
    },
    G2Line {
        r0a0: u384 {
            limb0: 0xc4e37e3305c8e3f4639a8b98,
            limb1: 0xb9ec4ca4d7d49a9822008dbe,
            limb2: 0x615661361045cf2,
            limb3: 0x0
        },
        r0a1: u384 {
            limb0: 0xb42d676b3032557533fb7d13,
            limb1: 0xf3b06bc53cf3ef01a864ee38,
            limb2: 0x73c33be229ad89,
            limb3: 0x0
        },
        r1a0: u384 {
            limb0: 0x942092185dc6ed03bdf0ab37,
            limb1: 0x43e304cbc5e653a44f0890b2,
            limb2: 0xb11bbd65dcfe3bc,
            limb3: 0x0
        },
        r1a1: u384 {
            limb0: 0x9157802e363daff49f64ac5,
            limb1: 0x75e52d50100499365604decd,
            limb2: 0x2eb339b99d930ac0,
            limb3: 0x0
        }
    },
];

