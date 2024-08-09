#[cfg(test)]
mod msm_tests {
    use garaga::ec_ops::{G1Point, FunctionFelt, u384, msm_g1, MSMHint, DerivePointFromXHint};


    #[test]
    fn test_msm_BN254_1P() {
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x5c724369afbc772d02aed58e,
                    limb1: 0x2cd3bc838c66439a3d6160b,
                    limb2: 0x72f26b55fb56be1,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x772ca79c580e121ca148fe75,
                    limb1: 0xce2f55e418ca01b3d6d1014b,
                    limb2: 0x2884b1dc4e84e30f,
                    limb3: 0x0
                }
            },
        ]
            .span();
        let scalars = array![
            u256 {
                low: 0xb4862b21fb97d43588561712e8e5216a, high: 0x967d0cae6f4590b9a164106cf6a659e
            },
        ]
            .span();
        let scalars_digits_decompositions = Option::Some(
            array![
                (
                    array![
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                    ]
                        .span(),
                    array![
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                    ]
                        .span()
                ),
            ]
                .span()
        );
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0xe2c91ebbffedea5cc96ab66c,
                    limb1: 0x23225d3db7b3eba1aa79078,
                    limb2: 0x1abab72cfddaa35b,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x5ae11a6dada866bbc23ad393,
                    limb1: 0x26bf86500055ba137a13df58,
                    limb2: 0x1952422195f9e68f,
                    limb3: 0x0
                }
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x8588b047629dc12cef448ea0,
                    limb1: 0xb9e0087734ce7a283626d4d,
                    limb2: 0x2e2526be1175da32,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x606e7e67ab335931dc6b69ed,
                    limb1: 0xfed6da65fe46b1d8c0cd69e7,
                    limb2: 0x271119715987cf8a,
                    limb3: 0x0
                }
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x3f7b089e59fade8d29358998,
                    limb1: 0x9bcb567c9510886ae0a3abba,
                    limb2: 0xfe00f31f2f77676,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x7ed9b12e41d1e2d4fb1ecde4,
                    limb1: 0xef5ef3c193d8c9972728aadf,
                    limb2: 0xb0ac47686963964,
                    limb3: 0x0
                }
            },
            SumDlogDivLow: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xa91a8e06192b6582b87b3d12,
                        limb1: 0xf271ee9b1de01ded574a395c,
                        limb2: 0x16c22426365b7931,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x1f29b924f67f1217fd978b14,
                        limb1: 0xdc2822db40c0ac2e4879bc43,
                        limb2: 0x183227397098d014,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x7ab7571e0aed64c6165aea4d,
                        limb1: 0x8e33e70fa4c6db9a228a76be,
                        limb2: 0x15bf70fc8b816805,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x293668678c762a8d0c63714d,
                        limb1: 0xb350e41a6d3fb569d903c40d,
                        limb2: 0xe7a709083a190ed,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xd57e5b0a28c7b94f76703abd,
                        limb1: 0xbd6a024d5aebf649151489c0,
                        limb2: 0x2eff05901f16ba54,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xe40a8c845e3686880fcab2a9,
                        limb1: 0xc6b49486e02cc632cb10edd6,
                        limb2: 0xcd51a896192cd3e,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xb5a9ff29e41563847fe7c83d,
                        limb1: 0xc6e0a72ad2da07b9cb5843a2,
                        limb2: 0x296c44d64f48ab4f,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x7b43acce4a7a23b6a93c1a0,
                        limb1: 0xf24b6f786cd33a70d01df9aa,
                        limb2: 0x10da0482c15297e6,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x7ba33936a5627fa7252a53e7,
                        limb1: 0x19f2ac4f47bf203d8b0b4c27,
                        limb2: 0x2b6f51b18ae4b2c9,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x3, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x7ab7571e0aed64c6165aea4d,
                        limb1: 0x8e33e70fa4c6db9a228a76be,
                        limb2: 0x15bf70fc8b816805,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x293668678c762a8d0c63714d,
                        limb1: 0xb350e41a6d3fb569d903c40d,
                        limb2: 0xe7a709083a190ed,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHigh: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x5fe21d464063894f41f87cf,
                        limb1: 0xfcd7c36fa8efe6e37d8d2ea0,
                        limb2: 0x21be74507abf39f0,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xdec258cd3406570ab94baee4,
                        limb1: 0xdc2822db40c0ac2ed09bb7ad,
                        limb2: 0x183227397098d014,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xe32f112d0bf6b4af8d93f2b6,
                        limb1: 0x56d0c25e402dfb501561f641,
                        limb2: 0x66ddc486e87559a,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xeee8a16965e6dfd3bf069660,
                        limb1: 0x62354f1d56ef64df07ca51c9,
                        limb2: 0x2b744f725137fa40,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x1ba19471940737773c8e2c6e,
                        limb1: 0x5e2bc361646889ba6f3666d5,
                        limb2: 0x4fc973b36432b6,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xe90750a3e016d311213d2605,
                        limb1: 0xd42d949f6fc6dcafdc52aa07,
                        limb2: 0x16608b9af0aaf867,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xc9e09ba1211245c1fdc6e5c6,
                        limb1: 0x1d6884c2bf6bd2f7b5acb573,
                        limb2: 0xd6db1638f0ce5ed,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xa98d338723e41e0ea8bbd822,
                        limb1: 0x472471ac089f1f04025e2c5,
                        limb2: 0x134994d94b9600cf,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xfbd64f21b973874d8c19c892,
                        limb1: 0xb5ff61eb01cb7de1e85c203a,
                        limb2: 0x219451713144ae6d,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x3, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0xe32f112d0bf6b4af8d93f2b6,
                        limb1: 0x56d0c25e402dfb501561f641,
                        limb2: 0x66ddc486e87559a,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xeee8a16965e6dfd3bf069660,
                        limb1: 0x62354f1d56ef64df07ca51c9,
                        limb2: 0x2b744f725137fa40,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHighShifted: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x1d62a6e9707d673917fe9818,
                        limb1: 0x764bc1a35537b49b7ff34d02,
                        limb2: 0x9261e2acd4568f8,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x8bbd8e60fc1a1859e888a509,
                        limb1: 0xdc2822db40c0ac2e47c7fadc,
                        limb2: 0x183227397098d014,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xda0186724a19c26d414bc299,
                        limb1: 0x9e7c5ff8d4bc2e22d3af9bc3,
                        limb2: 0xb63b8bd1cfe7ba0,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xbdfdc34bba87873987fe256,
                        limb1: 0xc9373468faa540adcafcbc1b,
                        limb2: 0x22c366f5bdf5efaa,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x3c3fd35f7a53d65c2dd62d64,
                        limb1: 0xf7a5c678dda0b5363bd7f6a9,
                        limb2: 0x1c7ed33f47ab73ac,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x326b62d353a26dbf1e291f85,
                        limb1: 0x4aaf2c11e9827d90472129be,
                        limb2: 0x9d8653aa2429e59,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xdccec34e80f3accd182b5aa6,
                        limb1: 0xc22fc1b1911efeea483898a7,
                        limb2: 0x991565a9d4b7b9a,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x8e049356de4d4747c3e347cb,
                        limb1: 0xdb751fea7e348a687b0ed34b,
                        limb2: 0x222b2a3756fb72e1,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x52bbff83bab8512d1885ac74,
                        limb1: 0xeb0511cdeced114e31f35f2e,
                        limb2: 0x78197fb777e8eac,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x3, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0xda0186724a19c26d414bc299,
                        limb1: 0x9e7c5ff8d4bc2e22d3af9bc3,
                        limb2: 0xb63b8bd1cfe7ba0,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xbdfdc34bba87873987fe256,
                        limb1: 0xc9373468faa540adcafcbc1b,
                        limb2: 0x22c366f5bdf5efaa,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xbe44f4d3a06d3088bd2537c1,
                limb1: 0xea4e92d90d9dc5e50e0ab3b6,
                limb2: 0x1171f808434ebf9e,
                limb3: 0x0
            },
            g_rhs_sqrt: array![],
        };
        let res = msm_g1(
            points, scalars, scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, 0
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0xa9f0001b3fc543c76e78dbe5,
                    limb1: 0x59d3efe5fc893f110337f203,
                    limb2: 0x2a3c4edaf4eb5933,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x47c7d40af526b19cd3c8e9d6,
                    limb1: 0x77e086d9ab1747415c8a345,
                    limb2: 0x2ecf62cd2d14d49c,
                    limb3: 0x0
                }
            }
        );
    }


    #[test]
    fn test_msm_BLS12_381_1P() {
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0xe4f817e54aede0613c17035c,
                    limb1: 0xdff1f15010392a6da1f95a6,
                    limb2: 0xbed78d3d341e911d49f15454,
                    limb3: 0x18154782ce0913b21588066d
                },
                y: u384 {
                    limb0: 0x3d77d61326ef5a9a5a681757,
                    limb1: 0xd3070afd4f0e121de7fcee60,
                    limb2: 0xdf9ef4088763fe611fb85858,
                    limb3: 0x11a612bdd0bc09562856a70
                }
            },
        ]
            .span();
        let scalars = array![
            u256 {
                low: 0xb4862b21fb97d43588561712e8e5216a, high: 0x12cfa194e6f4590b9a164106cf6a659e
            },
        ]
            .span();
        let scalars_digits_decompositions = Option::Some(
            array![
                (
                    array![
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                    ]
                        .span(),
                    array![
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                    ]
                        .span()
                ),
            ]
                .span()
        );
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0x29bab3bb3c5a3498ef52c10e,
                    limb1: 0x1a2cb9165f39a2b96e111e1d,
                    limb2: 0xa1e1aa80472b71ffe237f65c,
                    limb3: 0x8d6b69927c3363c5eccadbf
                },
                y: u384 {
                    limb0: 0x720d96acc81b6630196ccf5d,
                    limb1: 0xd84a5f28b95187d31a44eafa,
                    limb2: 0x78579d836e4f34e9573fa265,
                    limb3: 0x621f59b924be99226c509e5
                }
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x1f331a3fc12126eebdae3f59,
                    limb1: 0x2cb7dbc661cf888114515a2e,
                    limb2: 0xb20395314f340002f87089d1,
                    limb3: 0x17c6859d5428edf721de9025
                },
                y: u384 {
                    limb0: 0x66c8ca463bb31730c280588f,
                    limb1: 0xb724561772624d4a07bde932,
                    limb2: 0x619e8301e670ee3f7b307d70,
                    limb3: 0x9a6e9b54bb78587420cb983
                }
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x1256cabcc66af1452b941a8,
                    limb1: 0x8a3694cb214b8b9219d6b558,
                    limb2: 0x62da7a2bdad5e3fd7f424ab,
                    limb3: 0x75d1733043d8ba7f9ca3713
                },
                y: u384 {
                    limb0: 0x1c80747ef95f644c801874ee,
                    limb1: 0x33d485f1cc6e1729a06a74a5,
                    limb2: 0xefa381e03300893b110fae06,
                    limb3: 0x1435ec08d73e466ee22f00d1
                }
            },
            SumDlogDivLow: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x28c84bc715619cfe6affc131,
                        limb1: 0x465b7062d4104df4775dfbe9,
                        limb2: 0x824a1e91acc60f97fc19ab9b,
                        limb3: 0x317b4e47bdae42d8d3938a6
                    },
                    u384 {
                        limb0: 0xc39ad3de356e4c0c9158e1c6,
                        limb1: 0xb39869507b587b118c0f06f9,
                        limb2: 0x21a5d66bb23ba5c279c2895f,
                        limb3: 0xd0088f51cbff34d258dd3db
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x992c27e575737c25f0a07636,
                        limb1: 0xac1be3b60330a92e1b681520,
                        limb2: 0xb035ee7cbaaac5351dab1d66,
                        limb3: 0xf53a23912c09841903fdbd8
                    },
                    u384 {
                        limb0: 0x53f5345eecb5eb05d49590ec,
                        limb1: 0xa635cd168d24b6e7f5274c39,
                        limb2: 0x25de21f14da493ecbae0dace,
                        limb3: 0x131625b87d33834621e29b3f
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xc6126345957ccb20d7841cec,
                        limb1: 0x57f86db1839640f380799bfd,
                        limb2: 0xe42e050f5dff8b10b97e7115,
                        limb3: 0x127266a895ae43f6083724fb
                    },
                    u384 {
                        limb0: 0x8bd2845402e88f4c2f5320d6,
                        limb1: 0xee3d2466e0653501be96614d,
                        limb2: 0x47304badd9e5f0efd4aed94e,
                        limb3: 0x6b830a25a79f015d8c57650
                    },
                    u384 {
                        limb0: 0x40ba4d8991a977bf673f64a8,
                        limb1: 0xbf82f776835c7399648af968,
                        limb2: 0xdd9b0d43e62317284cdce6e4,
                        limb3: 0xb24ad48a722b90bd9d67ae6
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x2089f9661cff097c2828382,
                        limb1: 0xe20de9961f60b87030485485,
                        limb2: 0x3a40604421bc7dca8fa2501b,
                        limb3: 0x94c650fd80293d1aac81ff6
                    },
                    u384 {
                        limb0: 0xed2cd17c3ed9ac175256ee5a,
                        limb1: 0xca758f184730ef57974530e7,
                        limb2: 0x10e12e166da3b8a9047945bb,
                        limb3: 0x1856730d81ce3fe3f1531d90
                    },
                    u384 { limb0: 0x4, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x992c27e575737c25f0a07636,
                        limb1: 0xac1be3b60330a92e1b681520,
                        limb2: 0xb035ee7cbaaac5351dab1d66,
                        limb3: 0xf53a23912c09841903fdbd8
                    },
                    u384 {
                        limb0: 0x53f5345eecb5eb05d49590ec,
                        limb1: 0xa635cd168d24b6e7f5274c39,
                        limb2: 0x25de21f14da493ecbae0dace,
                        limb3: 0x131625b87d33834621e29b3f
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHigh: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x21945a6bd6a6d02bfb0079cf,
                        limb1: 0xb0a9e7c5a6de9c2ffcec6eb2,
                        limb2: 0x9764b62377eb496ecea938a7,
                        limb3: 0xf80efd9c5f20f01bbe4cc7d
                    },
                    u384 {
                        limb0: 0xcf5797400900cd24689acc67,
                        limb1: 0xb39869507b587b12015abdaf,
                        limb2: 0x21a5d66bb23ba5c279c2895f,
                        limb3: 0xd0088f51cbff34d258dd3db
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x55f58b8ac1d7535f62949d15,
                        limb1: 0xd636ffcd7ee3f6001d348df8,
                        limb2: 0x23dace4cd2a97e3bdc15e201,
                        limb3: 0x126eab5ba2ab278576071004
                    },
                    u384 {
                        limb0: 0x5e7ccdda67eef8b0063a12a1,
                        limb1: 0x93aaaa668a8ed1204ee71028,
                        limb2: 0x15bc3740459c05e9a4a84759,
                        limb3: 0x42656b450cdcb8b5ed0b8d9
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x87f62fff0a53a8bf03675087,
                        limb1: 0xa62186f083163f7889f06a2e,
                        limb2: 0xeb76966e7893f85d3fa3810d,
                        limb3: 0x10a92c7a2bfb413da648ae52
                    },
                    u384 {
                        limb0: 0x88390a2b30bad490d6971318,
                        limb1: 0xa4c69545b7aaed61cc05af3,
                        limb2: 0x7d046e4b86a167e2f4342dbc,
                        limb3: 0x137bbcca08124c412031ebcd
                    },
                    u384 {
                        limb0: 0xb6aea6d72f4cffae81fabf63,
                        limb1: 0xcb53d9aef8901f25c15e77a2,
                        limb2: 0x235c8a8bfbe63bf4136429c1,
                        limb3: 0x89317188debc0ec65b4b489
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xf52e2e2b935f4d7d8a531efe,
                        limb1: 0x8a7a59f40e2debb8377a37e3,
                        limb2: 0x8d3df8481b761e5894d6288,
                        limb3: 0x15b8899a17acd0e141e4f0a4
                    },
                    u384 {
                        limb0: 0x79f337699fbbe2c018e84a84,
                        limb1: 0x4eaaa99a2a3b44813b9c40a1,
                        limb2: 0x56f0dd01167017a692a11d66,
                        limb3: 0x10995ad143372e2d7b42e364
                    },
                    u384 { limb0: 0x4, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x55f58b8ac1d7535f62949d15,
                        limb1: 0xd636ffcd7ee3f6001d348df8,
                        limb2: 0x23dace4cd2a97e3bdc15e201,
                        limb3: 0x126eab5ba2ab278576071004
                    },
                    u384 {
                        limb0: 0x5e7ccdda67eef8b0063a12a1,
                        limb1: 0x93aaaa668a8ed1204ee71028,
                        limb2: 0x15bc3740459c05e9a4a84759,
                        limb3: 0x42656b450cdcb8b5ed0b8d9
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHighShifted: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x5681794e8173f7cd95d84d1f,
                        limb1: 0xcafac12def6e3786ba533fd6,
                        limb2: 0xf86995346ea08859bf513a17,
                        limb3: 0x5f29ea7c5083d3fce2f76a4
                    },
                    u384 {
                        limb0: 0x302ea91a3b09524e7c49fbbb,
                        limb1: 0xb39869507b587b118b5d4593,
                        limb2: 0x21a5d66bb23ba5c279c2895f,
                        limb3: 0xd0088f51cbff34d258dd3db
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xb8d5caef0dff395749764c58,
                        limb1: 0xa13c40a412c34ca3541676b6,
                        limb2: 0x2cd3a59034c9bd27a6b4cba1,
                        limb3: 0x9347cdc16bcef7a13591938
                    },
                    u384 {
                        limb0: 0x424f7913e67629fcef97d455,
                        limb1: 0x177334b06a46d8350f2ff077,
                        limb2: 0xce661cdabc0d38c716a57702,
                        limb3: 0x14de87041a9953957a8e8833
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x1dcc38ebbc7092881d2f8dfa,
                        limb1: 0xb0e656761dcdc05bf4d6e9a9,
                        limb2: 0x2cc367adcbb00a15873d95a3,
                        limb3: 0xe40a91e0a9be8418e755700
                    },
                    u384 {
                        limb0: 0xc4e2c0678ec4378806edc078,
                        limb1: 0xb0518182ade1d0a0fde986b1,
                        limb2: 0x4b426d2ce86cb3e4369f451c,
                        limb3: 0x10dcd4f6f2f747db76d94b4b
                    },
                    u384 {
                        limb0: 0x2de929bf4810146fe09d4955,
                        limb1: 0x6934c01931e21879906e32e2,
                        limb2: 0x54ab26b30763db9887ba4c9b,
                        limb3: 0x12f70b6ced3f32105ac1807
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x32032bbc7dfde55d25d986b5,
                        limb1: 0x1dc02fef545c3c6931addadc,
                        limb2: 0x7002e9696eafa919a74e1bc7,
                        limb3: 0xad0e1862173d74e0248bd2a
                    },
                    u384 {
                        limb0: 0xf541e4506bdba7f3be605153,
                        limb1: 0x283a5adec5087e67e0bbc1e0,
                        limb2: 0x6fb56ce4c2cf008d8006a3ca,
                        limb3: 0x576e651bde59a8708e729ac
                    },
                    u384 { limb0: 0x4, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0xb8d5caef0dff395749764c58,
                        limb1: 0xa13c40a412c34ca3541676b6,
                        limb2: 0x2cd3a59034c9bd27a6b4cba1,
                        limb3: 0x9347cdc16bcef7a13591938
                    },
                    u384 {
                        limb0: 0x424f7913e67629fcef97d455,
                        limb1: 0x177334b06a46d8350f2ff077,
                        limb2: 0xce661cdabc0d38c716a57702,
                        limb3: 0x14de87041a9953957a8e8833
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xe15515df9388f0d6b1ba8ea2,
                limb1: 0x750e1d16fcdd2fb021e78322,
                limb2: 0x84bd8f5d8a734f10549e3f3c,
                limb3: 0x743d0fa04bd023fc4e0b88
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0x3668e5dca62b89894364b168,
                    limb1: 0xf4e400503a3a2bfc9dde5a08,
                    limb2: 0xcdf9cdf6478192215118dc97,
                    limb3: 0x425ee01cd06554efeb9fd12
                }
            ],
        };
        let res = msm_g1(
            points, scalars, scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, 1
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0xb603ffc901ec7f3e42216ae4,
                    limb1: 0x269adaf11286bf338b9dacb1,
                    limb2: 0xab33b097e05378c0867894f,
                    limb3: 0xbfd8ef26d4610b8e77f5c28
                },
                y: u384 {
                    limb0: 0x9afe78c2bb0f305eccbffb90,
                    limb1: 0xc8b06f9aaf49eda1f9fd6cfd,
                    limb2: 0xc422cd476b9611aef3a1ee3,
                    limb3: 0x1201e1e9a2b0867eb9da1725
                }
            }
        );
    }


    #[test]
    fn test_msm_SECP256R1_1P() {
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x113c8d620e3745e45e4389b8,
                    limb1: 0x85b8ff52d905fd02fe191c3f,
                    limb2: 0xf5d132d685201517,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x60c0ba1b358f375b2362662e,
                    limb1: 0x6abfc829d93e09aa5174ec04,
                    limb2: 0x7bc4637aca93cb5a,
                    limb3: 0x0
                }
            },
        ]
            .span();
        let scalars = array![
            u256 {
                low: 0xeb1167b367a9c3787c65c1e582e2e662, high: 0xf7c1bd874da5e709d4713d60c8a70639
            },
        ]
            .span();
        let scalars_digits_decompositions = Option::Some(
            array![
                (
                    array![
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                    ]
                        .span(),
                    array![
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                    ]
                        .span()
                ),
            ]
                .span()
        );
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0x9436821257142dd72820672d,
                    limb1: 0xc620eb419f1fe7d73cb5fefe,
                    limb2: 0xc64a9c09ac1f5ea7,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xa7511b8bdff092bde43f2151,
                    limb1: 0x22e576fcf3094192fbda2872,
                    limb2: 0xdfa1f4b9bd91fa05,
                    limb3: 0x0
                }
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x51fafdb2da1ff7c9a8a14b2f,
                    limb1: 0x6cee75a31e68e31fe52c0800,
                    limb2: 0xe68f39600d63e2a7,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xc7545cbaf91748ede45e709,
                    limb1: 0xe1e9f105b92f17716f22ec86,
                    limb2: 0xa2c4c708bc48d9a0,
                    limb3: 0x0
                }
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x310c0bbb7ee3baa463a14b32,
                    limb1: 0xe4a2c10127642331129d8f9f,
                    limb2: 0xd48ddb30d3212023,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x1584ff8e95a6c0cf0026addf,
                    limb1: 0x8df5471b2fd1d86d30f5b117,
                    limb2: 0x1b5d5d6744ca8ef8,
                    limb3: 0x0
                }
            },
            SumDlogDivLow: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x6a5d3a2cf3448668662aca55,
                        limb1: 0x1076ef6b6759345d6ca429ca,
                        limb2: 0xa1aea959684732a4,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x3666e21a57418f0209b24b28,
                        limb1: 0x7fffffffffffffff96d52f19,
                        limb2: 0x7fffffff80000000,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x87bbdf169ced2d5e5098fe3b,
                        limb1: 0xac3459f601742c84cb1f7316,
                        limb2: 0x1b896bbecdb611c4,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x5a8cf08b9ab48c44799c0f19,
                        limb1: 0xb426156b87da1b25c530e4c4,
                        limb2: 0x43e4311dcec08c42,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xbde7221f2db1dfa47bd34895,
                        limb1: 0xc4788a9513c2136398765838,
                        limb2: 0x77ed71d38c9f2a0,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xf5247cfee80173a745321e36,
                        limb1: 0xd4145b48e93e56e3821a287b,
                        limb2: 0x99eef966d66a8d64,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x2156f8d21b7046b926bc3904,
                        limb1: 0x44cc88f546abf114315dfd96,
                        limb2: 0xfd838ea050e1fd2d,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x5d97116dcc6834cb3c949bb6,
                        limb1: 0xfa4004cb8af6fa03dfd7ba10,
                        limb2: 0x738aa51c820adda0,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xa2ce76f2586ec69dbabf6be0,
                        limb1: 0xd4004aba08489d6d77359c3,
                        limb2: 0xa6f6fb4232651317,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xbcacdf536bb09770bafe32ff,
                        limb1: 0x97797d12df0a354b158a5864,
                        limb2: 0x8f19a27e3df8ef20,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x87bbdf169ced2d5e5098fe38,
                        limb1: 0xac3459f601742c84cb1f7316,
                        limb2: 0x1b896bbecdb611c4,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x5a8cf08b9ab48c44799c0f19,
                        limb1: 0xb426156b87da1b25c530e4c4,
                        limb2: 0x43e4311dcec08c42,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHigh: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xa26ac5d381be0ce53826d15,
                        limb1: 0xac5f68b210cc4956b8b0f88a,
                        limb2: 0x7b78c46b6b8a8260,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x5974a92ec437e566b696d326,
                        limb1: 0xffffffffffffffff84462f63,
                        limb2: 0xffffffff00000000,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x7a1057f0d79e91f1cac3adc1,
                        limb1: 0x7878e922a824ba2603bb1db1,
                        limb2: 0x1eb47c44b521c394,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x9cc874eb17a8c251f91b2b17,
                        limb1: 0xd588b0a08911fdd1cbadbc2,
                        limb2: 0x239f93c76d7c0843,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xa6d09ee14f34b3aa584d0301,
                        limb1: 0x974cb9d8d8e36fd93c59206c,
                        limb2: 0x4a213ca23fc23c46,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x598e1551f89959303c22f4c,
                        limb1: 0xb5c8cc8e905f939bab9c5941,
                        limb2: 0x8b570351acc5b57d,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x15fc71aa5379e14441861e5c,
                        limb1: 0x14ebf8befc989733a29cd588,
                        limb2: 0xad746febd48f5762,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x33a43a035b506e14e9975317,
                        limb1: 0xfd686306785cffd2be853021,
                        limb2: 0x614799578c21b5e8,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x209486015c5ccc1b9575ba23,
                        limb1: 0xb53aef16646733c14fdb54da,
                        limb2: 0x28648cc45b05d9a4,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xf5fa5234f4d3f5483c80df05,
                        limb1: 0x8be21c375ce527250eec7369,
                        limb2: 0xefe77a8161c67b1f,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x7a1057f0d79e91f1cac3adbe,
                        limb1: 0x7878e922a824ba2603bb1db1,
                        limb2: 0x1eb47c44b521c394,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x9cc874eb17a8c251f91b2b17,
                        limb1: 0xd588b0a08911fdd1cbadbc2,
                        limb2: 0x239f93c76d7c0843,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHighShifted: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xdbd313658e9f3e9a68a37516,
                        limb1: 0x56d390768a6d62711e052a76,
                        limb2: 0x3d6c26b4dd8f841c,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x5784a91a5e09d24e7c4a2665,
                        limb1: 0x7fffffffffffffff7c074594,
                        limb2: 0x7fffffff80000000,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xd099228bc0607465ceb4a483,
                        limb1: 0x3867065e449b561ef7c5fad3,
                        limb2: 0x6edc0e6073e4d6ea,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x7cf8f691a6fc4d91f3bd699d,
                        limb1: 0xae6ec95bba32f9af08366862,
                        limb2: 0x44e2eb6d1f7afd36,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xccbd809e2895f03793da5470,
                        limb1: 0x2bcca86372eadb06b6bad35f,
                        limb2: 0xdafdeb08efc48e0d,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xbb4bb582c20ad35e198f199d,
                        limb1: 0x2c69f9ebbd0d68981b13a901,
                        limb2: 0xba2c47433bf59837,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x811a4d87c0b0af9c8039101d,
                        limb1: 0xe7211695805cbbf5ff41bd07,
                        limb2: 0x490ee661e97242d1,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xbb49727a47ff29a95b3e8134,
                        limb1: 0x726e35357625927d75352d64,
                        limb2: 0xaf58f21c6360947f,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x5c8910f9840ad1f64a4fb917,
                        limb1: 0xe7142a2c6576ef9f877ebc6,
                        limb2: 0x41b8554cc02ff1dd,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x5568cd4146d953884c9a2373,
                        limb1: 0xa89f614247ff99af4c79cd8a,
                        limb2: 0x8c1d73904bc99c44,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xd099228bc0607465ceb4a480,
                        limb1: 0x3867065e449b561ef7c5fad3,
                        limb2: 0x6edc0e6073e4d6ea,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x7cf8f691a6fc4d91f3bd699d,
                        limb1: 0xae6ec95bba32f9af08366862,
                        limb2: 0x44e2eb6d1f7afd36,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x5878abe4d0d05d01b83af01a,
                limb1: 0x6091e3b59ae08655a77fe53f,
                limb2: 0x776d8d9567f262c2,
                limb3: 0x0
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0x63ef2e1ae6eb2c756069efe8,
                    limb1: 0xeb0387c8a8c17fad8c0a9324,
                    limb2: 0x55fe2c479038a0bc,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x9f3045df98e4cd4099e13207,
                    limb1: 0x1dfa04fc68980e286fec6fb0,
                    limb2: 0x1813afbd9c05412a,
                    limb3: 0x0
                }
            ],
        };
        let res = msm_g1(
            points, scalars, scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, 3
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x5ecaccc77099015edd4567b8,
                    limb1: 0xa82e8c31fd89230e9e054b35,
                    limb2: 0x9b8f95662d8ac62b,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x197a10d65c49dfb9020a06d1,
                    limb1: 0x385d645da0e58782b062bea8,
                    limb2: 0xce16e956485f6821,
                    limb3: 0x0
                }
            }
        );
    }


    #[test]
    fn test_msm_SECP256K1_1P() {
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x393dead57bc85a6e9bb44a70,
                    limb1: 0x64d4b065b3ede27cf9fb9e5c,
                    limb2: 0xda670c8c69a8ce0a,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x789872895ad7121175bd78f8,
                    limb1: 0xc0deb0b56fb251e8fb5d0a8d,
                    limb2: 0x3f10d670dc3297c2,
                    limb3: 0x0
                }
            },
        ]
            .span();
        let scalars = array![
            u256 {
                low: 0xeb1167b367a9c3787c65c1e582e2e662, high: 0xf7c1bd874da5e709d4713d60c8a70639
            },
        ]
            .span();
        let scalars_digits_decompositions = Option::Some(
            array![
                (
                    array![
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                    ]
                        .span(),
                    array![
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                    ]
                        .span()
                ),
            ]
                .span()
        );
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0x2168cdd68c04b38b0d0ed9c9,
                    limb1: 0xcd052d9299a13087b5800a4a,
                    limb2: 0xa573b87cf8304f8f,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x5454918fa80a564339004e92,
                    limb1: 0x5655a19d0ec5d16fdf81f011,
                    limb2: 0x29b63cc0a6044502,
                    limb3: 0x0
                }
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0xd5359262839ab420badf7cd9,
                    limb1: 0x5a87f64c35e57e5df4e4fc77,
                    limb2: 0x289923177889088d,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x8d67744978428f50a1ac82a1,
                    limb1: 0xade19daa5e55192df1fe1999,
                    limb2: 0x79185c440324025,
                    limb3: 0x0
                }
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x8fcbf3f99fce5df95ce84d2b,
                    limb1: 0xb9b461dafa9f3a09816ff4db,
                    limb2: 0x110c2b06832eaa00,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x2b4ac042652d0760141dd90,
                    limb1: 0xb384b06a9e5cb660236efa3f,
                    limb2: 0x5e0b156fdadea8f3,
                    limb3: 0x0
                }
            },
            SumDlogDivLow: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xb4fcf8a5b0cad11304329c97,
                        limb1: 0xa80ec424aadb0c55a24c15c7,
                        limb2: 0x31deb0177d213676,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xb666e21a57418f0189b24940,
                        limb1: 0xffffffffffffffff96d52f18,
                        limb2: 0x7fffffffffffffff,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x7c08ccef0577c1e5e174df10,
                        limb1: 0xb5ee58ee34e93193f49ea180,
                        limb2: 0x4047fb70f7e77047,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xa5594753f832f204573cd425,
                        limb1: 0xce262207b270ecfb50845759,
                        limb2: 0x80253af69e26e265,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xfd83e5dcb8f442536dab5cd4,
                        limb1: 0xe01888c58f83437f6a5222b6,
                        limb2: 0x13cf21fd6255ff64,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xa248a903c30641607b6577ad,
                        limb1: 0x9c21a3a74fe303f3a82298c6,
                        limb2: 0x430c0ca30ff24689,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xd15958ee9d1ee6db09220631,
                        limb1: 0x4e46d3493fe72964f69067f9,
                        limb2: 0xec0a0c1aaad56f0e,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x643d9a8926464d4a2a321d41,
                        limb1: 0xf9846e8372605b0bb0566a83,
                        limb2: 0xc1f7e016c75411f5,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x8570f34bc9649e2162a9d876,
                        limb1: 0xa30aee35e1167adf339e6373,
                        limb2: 0x81049cbe531030c8,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x7, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x7c08ccef0577c1e5e174df10,
                        limb1: 0xb5ee58ee34e93193f49ea180,
                        limb2: 0x4047fb70f7e77047,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xa5594753f832f204573cd425,
                        limb1: 0xce262207b270ecfb50845759,
                        limb2: 0x80253af69e26e265,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHigh: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xe11598bc11cc303f55df6836,
                        limb1: 0x49305a3d49e3b23025d98839,
                        limb2: 0xe70c7570de51b2dc,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x5974a92ec437e565b696cf56,
                        limb1: 0xffffffffffffffff84462f62,
                        limb2: 0xffffffffffffffff,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x3129858457cf3014c235235,
                        limb1: 0xb0fe57b67b7c50547d7e41aa,
                        limb2: 0xac11d74ab9f96d2d,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xf18c82c8009cf16ea96c3115,
                        limb1: 0x40a3594e162c9f25111f652b,
                        limb2: 0xfcffd05c1dce2968,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xb4f1c6d1ca8490d5fa889fd7,
                        limb1: 0x922025384f7c4954e6b3bffd,
                        limb2: 0xeb0a51fc509f5105,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xd679a5804ddc1fe332c54b63,
                        limb1: 0x9d5877897a936bf52ccc039f,
                        limb2: 0xfd4d9dba47497699,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xc3a15c6f5c22f16b9976878b,
                        limb1: 0x8c010073f76b26401720fff9,
                        limb2: 0x5d01ff79dea1eebb,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x15822a69e66aa50d14f74eb7,
                        limb1: 0xd6f465fd6066324f6e73cba6,
                        limb2: 0xb47ce30b15d1fc3f,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x9ad79378044a9a0ca1f56e79,
                        limb1: 0xc47771229b385a0377dbc433,
                        limb2: 0xeafeb284d0a321d9,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x7, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x3129858457cf3014c235235,
                        limb1: 0xb0fe57b67b7c50547d7e41aa,
                        limb2: 0xac11d74ab9f96d2d,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xf18c82c8009cf16ea96c3115,
                        limb1: 0x40a3594e162c9f25111f652b,
                        limb2: 0xfcffd05c1dce2968,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHighShifted: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xec57a2b635380ad1cfc4170c,
                        limb1: 0x36129c4e760736a733db195d,
                        limb2: 0xfc4ba9103abc0ab8,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xd784a91a5e09d24dfc4a247d,
                        limb1: 0xffffffffffffffff7c074593,
                        limb2: 0x7fffffffffffffff,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x999bc36b8bb4fb9943bdb239,
                        limb1: 0xdee2969638a54ae7cbdb78da,
                        limb2: 0x634a8c80727a977c,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x9afe79a3dc96ede4e838322b,
                        limb1: 0xebc3a7d8cf7b479889ab0eac,
                        limb2: 0xc65ab1e204484d71,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x8005351180c0c3d98483c223,
                        limb1: 0x76450fc8267571115cb3c9d5,
                        limb2: 0x765647d09247c421,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x5450eb807777b0ad3646a97d,
                        limb1: 0xff02af12cea9dca83244abee,
                        limb2: 0x472da77e360e30e3,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xdf7c7de55484f3ca3454d813,
                        limb1: 0xbf915d2aaec2a33257c4a2fb,
                        limb2: 0x95c7f288ea2c25d4,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x334257f0d1f2e132da2fe731,
                        limb1: 0x18321e1b8c850c5693004dfa,
                        limb2: 0xb709d783215a246a,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x3cf5537b0820814759897242,
                        limb1: 0x725996edac5ef52bc3ad66b8,
                        limb2: 0x6c7add2e1dfa1e1d,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x7, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x999bc36b8bb4fb9943bdb239,
                        limb1: 0xdee2969638a54ae7cbdb78da,
                        limb2: 0x634a8c80727a977c,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x9afe79a3dc96ede4e838322b,
                        limb1: 0xebc3a7d8cf7b479889ab0eac,
                        limb2: 0xc65ab1e204484d71,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x648194b273c90f9db5984708,
                limb1: 0xb53ad2ceaccb8cb32af8ba80,
                limb2: 0x15e2a529b829cedf,
                limb3: 0x0
            },
            g_rhs_sqrt: array![],
        };
        let res = msm_g1(
            points, scalars, scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, 2
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0xc20f5aa13afc3a2097ce088b,
                    limb1: 0x50220928f8ca04bf313c1d7,
                    limb2: 0x70743ffac9bb07f9,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xfa42792834ae5445fcaca832,
                    limb1: 0x6796f84b7340adf44ed49d33,
                    limb2: 0x62fd8a76eedcb778,
                    limb3: 0x0
                }
            }
        );
    }


    #[test]
    fn test_msm_ED25519_1P() {
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x7238f02b9f20e09c2181a557,
                    limb1: 0x2cedcc5b0be371c337fd7e9e,
                    limb2: 0x41f3bbeb280fe8a2,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xf046f8cd6e5a75fca71dd19b,
                    limb1: 0x892b4613ef5c58df4ef692a4,
                    limb2: 0x7527fa36f5738847,
                    limb3: 0x0
                }
            },
        ]
            .span();
        let scalars = array![
            u256 {
                low: 0xb4862b21fb97d43588561712e8e5216a, high: 0x4b3e865e6f4590b9a164106cf6a659e
            },
        ]
            .span();
        let scalars_digits_decompositions = Option::Some(
            array![
                (
                    array![
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                    ]
                        .span(),
                    array![
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                    ]
                        .span()
                ),
            ]
                .span()
        );
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0xed54fd36c0f93ccf4d6a30b3,
                    limb1: 0x6eafafb1e71bee846a3b1813,
                    limb2: 0x29b44c4747a67a39,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x6589e76cd63ba451cc0e48dd,
                    limb1: 0x1149d78c68779402516e0e6,
                    limb2: 0x408a34b791a63729,
                    limb3: 0x0
                }
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x4bab4cd06d72ec2ae5779c53,
                    limb1: 0x6917274b2e403eaafa2dc973,
                    limb2: 0x1ae7bef91471b1cb,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x4b792b778619b6b114598727,
                    limb1: 0x96cc798870f6db14e00e8283,
                    limb2: 0x7db3f78a00beff4e,
                    limb3: 0x0
                }
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x823e8e165750ba17e480997f,
                    limb1: 0xbb32cc0e2bc05ae557dcd32a,
                    limb2: 0x2fd96b567f8ba250,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xe5a30d3059100da5bb4be48a,
                    limb1: 0xa71bb7e1fc820afa256f3948,
                    limb2: 0x5c0d0cfb29d4bb30,
                    limb3: 0x0
                }
            },
            SumDlogDivLow: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x9e6cd62f31342144ade83500,
                        limb1: 0x23da92a699fedb2895db73ab,
                        limb2: 0x25da37d0496146a5,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x6af0d3de586ecc0c91590c67,
                        limb1: 0xffffffffffffffff7cb906fa,
                        limb2: 0x3fffffffffffffff,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x622bcc23485551cfa66969a0,
                        limb1: 0x6915818f15976bcd7d087646,
                        limb2: 0x44f432370a2fe40c,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xa072129d9fe5e294911429e3,
                        limb1: 0x646283f30d009fb85dc7694d,
                        limb2: 0x1457f7cd90499d24,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x9b2451aa7915a694ede8521e,
                        limb1: 0xbb823c0f401b4ff70501d452,
                        limb2: 0x321f2579bc28e707,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x87c1c9dc91d2e1271e22080f,
                        limb1: 0x9dc4ec2fffd5a8e8d38f608b,
                        limb2: 0x37fc01b10ada924e,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x1b322843f1ef3102eea7b856,
                        limb1: 0x8693ec933c49a829f5ccde7a,
                        limb2: 0x7316859148338713,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x19d3bb8529e2cf036b28205d,
                        limb1: 0x1db7721c7cf483077e8670c7,
                        limb2: 0x2f2ca0236c443fa2,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x1b545d4ecadeb4906c695253,
                        limb1: 0x4d1c784e850551388a2df4ef,
                        limb2: 0x15c60bbb5b1faa5f,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xee7c91b53edbf7fb2b61a655,
                        limb1: 0x9a3a4833b8cbb3a0d82d8d68,
                        limb2: 0x7151639e767ec64e,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x6ed0f71af4c7335e9f2580e0,
                        limb1: 0x9aad629c7712a9a3e8c12ca3,
                        limb2: 0x2242df0aafe9a2f2,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xa072129d9fe5e294911429e3,
                        limb1: 0x646283f30d009fb85dc7694d,
                        limb2: 0x1457f7cd90499d24,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHigh: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x75b341f180ff92cfef05898c,
                        limb1: 0xcbcf65d0dafb8a4e49e786c3,
                        limb2: 0x39066e2d51cc2ac0,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xff7de0283482a56bd200b850,
                        limb1: 0xfffffffffffffffffdc4e761,
                        limb2: 0x3fffffffffffffff,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x609a08c81a6ad00032f88446,
                        limb1: 0x2ae9c751a9d28c6d6f740dd2,
                        limb2: 0x45fa3a0ebfc5c2e0,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x421bc303f36c3338f906be43,
                        limb1: 0x69fb0c59c5dc4f91cdd4b7ee,
                        limb2: 0x2324851bc37e6592,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xabaee1552945c65aba5bb6df,
                        limb1: 0x9128fddcb08b42c549d9a8e1,
                        limb2: 0x5f0d7e5009235fd1,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xb65742cc7a279d96601b0944,
                        limb1: 0xb37495bc6cc9b3f2d799d8a3,
                        limb2: 0x38077172272e260f,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x153b2463d9e29612e1fce321,
                        limb1: 0x5424291841e21ac2fb1a562f,
                        limb2: 0x6591a78874708955,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x4964dd477dd6834ee7b85472,
                        limb1: 0x90d458ac8b3316c323f4e8,
                        limb2: 0x7ab618c20ff63cd3,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x6070503a780d3103522f193c,
                        limb1: 0xbd0197e3d031f4b1817dffbd,
                        limb2: 0x56deb49d30381805,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x2e1f4fc388868f950f298366,
                        limb1: 0x26e5ee59f9b4e62326019f48,
                        limb2: 0x619a782f0f647e4c,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x6d3f33bfc6dcb18f2bb49b86,
                        limb1: 0x5c81a85f0b4dca43db2cc42f,
                        limb2: 0x2348e6e2657f81c6,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x421bc303f36c3338f906be43,
                        limb1: 0x69fb0c59c5dc4f91cdd4b7ee,
                        limb2: 0x2324851bc37e6592,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHighShifted: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x1db607a1ac5a7977ff218817,
                        limb1: 0x38666ae211779e5f22fcbf4c,
                        limb2: 0xf1c93991d80821,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xd784a91a5e09d24e7c4a265c,
                        limb1: 0xffffffffffffffff7c074593,
                        limb2: 0x3fffffffffffffff,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xc3aa3d7311cfc5d134aaaf3a,
                        limb1: 0x4b22d2c335b475bf70468d44,
                        limb2: 0x20d14c37535bf1e1,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x321625193b3c59bd3607ca1b,
                        limb1: 0xdbb60ca6a5ff666fadf56362,
                        limb2: 0x353ed5b06c02abe3,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x3519544b9c4a019112377196,
                        limb1: 0x7de5b60e3e3e46dc0e3357a2,
                        limb2: 0x7dbcf6d6c56e0674,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xb6eafbf2c0441d2064b8b51b,
                        limb1: 0xda155287d2394eae8805793e,
                        limb2: 0x155731c291a3abd2,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xf26d8ffdc5b2466d83cfecf6,
                        limb1: 0x7f894e21a6cf99b20cc9add2,
                        limb2: 0x72c52858c8eac8b9,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x1fe82767ae756b0c4c1bdadf,
                        limb1: 0x2f65f9a58a9d60cac50adde5,
                        limb2: 0x31228bab7076a2c,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xb502fdc866583c616069111f,
                        limb1: 0xdb62027f6f7a6ffaaf70bd9f,
                        limb2: 0x7b45cfe38ad7e5fe,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x652208d49d00909664bbf9b6,
                        limb1: 0xcae7bb6d7ab65709be0ce7af,
                        limb2: 0x18f83334fd5b2339,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xd04f686abe41a7602d66c667,
                        limb1: 0x7cbab3d0972fb395dbff43a1,
                        limb2: 0x7e1ff90af915b0c7,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x321625193b3c59bd3607ca1b,
                        limb1: 0xdbb60ca6a5ff666fadf56362,
                        limb2: 0x353ed5b06c02abe3,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xbc35c846ba2b1fe9092510ce,
                limb1: 0x6835b9c083ec9a5499008c68,
                limb2: 0x3130a1bb2c4fff0e,
                limb3: 0x0
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0xc127529471dfdd86e6abe59b,
                    limb1: 0xd86ff0f515a9f5be2b2abdcd,
                    limb2: 0x248c30b99ded43d2,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x1e8e591787ad382a30e9d02b,
                    limb1: 0xb361c3f40fcea04eb3822013,
                    limb2: 0x3679e35df0e6f5d7,
                    limb3: 0x0
                }
            ],
        };
        let res = msm_g1(
            points, scalars, scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, 4
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x62c2b89a3152e22243cf864d,
                    limb1: 0xaf83913cf31609fd7b4f9a32,
                    limb2: 0x6da9a48b077c3954,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xa54703c64365ab4373eae904,
                    limb1: 0x87e47f46101c003371e14338,
                    limb2: 0x462e50d88b5b5c17,
                    limb3: 0x0
                }
            }
        );
    }
}
