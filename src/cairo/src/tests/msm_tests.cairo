#[cfg(test)]
mod msm_tests {
    use garaga::ec_ops::{G1Point, FunctionFelt, u384, msm_g1, MSMHint, DerivePointFromXHint};


    #[test]
    fn test_msm_BN254_1P() {
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x7013fb2d550a65aa6752f9fc,
                    limb1: 0x9b2eafc593325d27dc6bce0a,
                    limb2: 0x34564476395830d,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x34cfc07f5406f875cf701a2a,
                    limb1: 0x4f97d33f245bf919f775994,
                    limb2: 0x62fc4a86c0afbc0,
                    limb3: 0x0
                }
            },
        ]
            .span();
        let scalars = array![
            u256 {
                low: 0xc294d66ef0a6c4cedf88316243a8fa08, high: 0x6dd4e7716b24ae353b6d68019e69cc4
            },
        ]
            .span();
        let scalars_digits_decompositions = Option::Some(
            array![
                (
                    array![
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                    ]
                        .span(),
                    array![
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
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
                    limb0: 0x7cf8938a13c8b6b8b4f71f65,
                    limb1: 0xd9ad0488db338e1500719a0e,
                    limb2: 0x2585fd439edab9a2,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x7b22d0f0d2ec095858c5537b,
                    limb1: 0x1d31a1cc975ba17d9b4c8a26,
                    limb2: 0x16a131e9b0aa352,
                    limb3: 0x0
                }
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0xcfeca9a63c76e5eecb1c913a,
                    limb1: 0x79c722be5925d2ff8dfed49f,
                    limb2: 0x22ce830158a6d912,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x2ad4bd860fdcf9e702d08233,
                    limb1: 0x6f47349b79c5f199d64a6efa,
                    limb2: 0x1ba21e22331dd9e2,
                    limb3: 0x0
                }
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x6220418737d6a9ebdc5d7fbb,
                    limb1: 0xc665d1b9912a29fa17f373a7,
                    limb2: 0x2550559748673011,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x4435953bb9cd1fc806804360,
                    limb1: 0x73921f6717ec2a82e3a0d3f2,
                    limb2: 0x2ffa6dee0337489b,
                    limb3: 0x0
                }
            },
            SumDlogDivLow: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x54152fdec21ef543207213eb,
                        limb1: 0xec8d9fec212cbd308bb57575,
                        limb2: 0x326c113d23b7302,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x249e95923ae00f5fdcbbab97,
                        limb1: 0xdc2822db40c0ac2e4ea539c5,
                        limb2: 0x183227397098d014,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x428389a7abd1273f762fcae4,
                        limb1: 0xbed42239ee39e6de61315b37,
                        limb2: 0x2e216472eb459509,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x7b653bd5d34d6fb3bc32e3e6,
                        limb1: 0x43749168131b6d20baa40278,
                        limb2: 0x798ece7dec16379,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xc7c15ed38d3cba5893d1ae1a,
                        limb1: 0xac1affbffe9982afb3d2decf,
                        limb2: 0x24219d1a5865d9a1,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x1a7f691706827b4f875acf69,
                        limb1: 0x81041785315756b750881322,
                        limb2: 0x1612f904c5ae89c9,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xb6554641931912809a30d021,
                        limb1: 0x5655eaf65375a62ec43930dc,
                        limb2: 0x1bc185b06aa41d3,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xf6a707dc8b325d90b195661e,
                        limb1: 0xcbdbdb40c7ab03dff4913c82,
                        limb2: 0x299b9072ff6d7ec9,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x722fb38179e84f1b3498abb2,
                        limb1: 0xca5db438395247622fec0769,
                        limb2: 0x16cac6b79c442a6b,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x3, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x428389a7abd1273f762fcae4,
                        limb1: 0xbed42239ee39e6de61315b37,
                        limb2: 0x2e216472eb459509,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x7b653bd5d34d6fb3bc32e3e6,
                        limb1: 0x43749168131b6d20baa40278,
                        limb2: 0x798ece7dec16379,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHigh: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x8091415e0a3d8743dd4d8e01,
                        limb1: 0x1a3fff8f1527d42e5ce1df8a,
                        limb2: 0x115a00a13b5ec25e,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xb473d8f4c6cbe79cf9a25bc5,
                        limb1: 0xdc2822db40c0ac2ed08eb2b5,
                        limb2: 0x183227397098d014,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x4eb5ebd0b15630333d2cb7f7,
                        limb1: 0xd9835f5bae7741e1433b3070,
                        limb2: 0x2419979b3fccbcc4,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x287125b9aa9f407da60d7211,
                        limb1: 0xa35a7332952928362d16c7e7,
                        limb2: 0xa50672a24f54409,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x43222cdf5b48f1696f65e494,
                        limb1: 0x30108ed1db02e70e176b689d,
                        limb2: 0x23586dbddf8d0469,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x3043c156f90ab8b5d17f0ba1,
                        limb1: 0xf47ce5c0ebc88e1c5d514798,
                        limb2: 0xaa7d842d6131914,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x6122642f11f977b155967860,
                        limb1: 0xbbfd600c04e5dbc472dc38f5,
                        limb2: 0x591f27dd51cd2e0,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x1b3e2e579bc1786c068c2d57,
                        limb1: 0x1be992a6086314e89aaebc2e,
                        limb2: 0xb8429ebfd02f5fb,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x7953712cffddc178f2285633,
                        limb1: 0xea0f5997bf7b78a2874457b5,
                        limb2: 0x1ef1357e6edfcc1c,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x3, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x4eb5ebd0b15630333d2cb7f7,
                        limb1: 0xd9835f5bae7741e1433b3070,
                        limb2: 0x2419979b3fccbcc4,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x287125b9aa9f407da60d7211,
                        limb1: 0xa35a7332952928362d16c7e7,
                        limb2: 0xa50672a24f54409,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHighShifted: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xfecfdcbb2b12ea78448fe96c,
                        limb1: 0x19f370f81cab7d81db73b087,
                        limb2: 0x2033830dcb578cee,
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
                        limb0: 0xed3fb7fe29b3a05ecbd839e2,
                        limb1: 0xbe082945a01ab560b350547,
                        limb2: 0x1087d4bce62af52,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x9ed6a9ed03f38853097fe999,
                        limb1: 0x307396f518b2b3c189108cdb,
                        limb2: 0x18a9c44d2155372f,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x5f65ac7d8f7b8ce8d6d8564,
                        limb1: 0xfbde69708c759f87f1ee0651,
                        limb2: 0x341e597c4f95727,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xb3920f8b747c333603430ebc,
                        limb1: 0x616f6aee9225f188509ef6b8,
                        limb2: 0x258994c4ce64c3df,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xe28e544b7cb2a6c74b5c25d0,
                        limb1: 0xd9b6a2674d62bbfc835b511,
                        limb2: 0x1468c0f96b93eb08,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xc7bf27fa7d1ae11c6388ada6,
                        limb1: 0x23a187bd0e050202219f0fd7,
                        limb2: 0x31977e36b280df6,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x74123339cfba0ce24402bf84,
                        limb1: 0xd90a7f28c896c2e703b03c01,
                        limb2: 0x1998fe7482ce0563,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x3, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0xed3fb7fe29b3a05ecbd839e2,
                        limb1: 0xbe082945a01ab560b350547,
                        limb2: 0x1087d4bce62af52,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x9ed6a9ed03f38853097fe999,
                        limb1: 0x307396f518b2b3c189108cdb,
                        limb2: 0x18a9c44d2155372f,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x8174bea9a32dc5465faf445c,
                limb1: 0xed00a63d3badaca5b606f07,
                limb2: 0x118c6eeb119e79b0,
                limb3: 0x0
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0x3ae37fe7608de4f3c3e4bdd6,
                    limb1: 0x60597c524bfc1642d74f80d4,
                    limb2: 0x4d10dbec52e33aa,
                    limb3: 0x0
                }
            ],
        };
        let res = msm_g1(
            points, scalars, scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, 0
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x6928a9369da968980074a9bb,
                    limb1: 0xef59b3da7d5b457ca4a883c5,
                    limb2: 0x1328f9451b74ed60,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x7a5815da74a2270194743292,
                    limb1: 0x8dcee4e41c379a23de41a490,
                    limb2: 0x246a1aba19cf9605,
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
                    limb0: 0x1c938c7af0ff33754a0c3c4b,
                    limb1: 0x486c623ceaf63cff243638f7,
                    limb2: 0x746db9193a1c2252c8f343e0,
                    limb3: 0xfdc230f00dfbd726a616621
                },
                y: u384 {
                    limb0: 0x75599e9f6e2fb0ac3035ed28,
                    limb1: 0xebf22265102d2c7af77b9a03,
                    limb2: 0x3106b223d4fa757196750a4f,
                    limb3: 0x15276d0bec71765580503b0e
                }
            },
        ]
            .span();
        let scalars = array![
            u256 {
                low: 0x7080c5da9a37a5258b2a9d4f442f5258, high: 0x419140ff5b140df6a60b41101b772a6a
            },
        ]
            .span();
        let scalars_digits_decompositions = Option::Some(
            array![
                (
                    array![
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                    ]
                        .span(),
                    array![
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
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
                    limb0: 0x3f4760fb4990dde6d9d86357,
                    limb1: 0x42f1457cd8c43c913cdd48c1,
                    limb2: 0x12e5a679c33a37f222036bee,
                    limb3: 0xa61f09211db6aded61498cd
                },
                y: u384 {
                    limb0: 0xb14b29d30eb6c56f5bcf7114,
                    limb1: 0xc7f0341a89f7a7517a2459e9,
                    limb2: 0x67b633c65358ac019491c742,
                    limb3: 0xa8f19ac82fb96ad49549cea
                }
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x128b9b30ebea82c304c72658,
                    limb1: 0x88ca22b42c727b5f8d7ce852,
                    limb2: 0x12f21910efec9f2fe2ee7721,
                    limb3: 0x792685056ff0e55e49d3a1f
                },
                y: u384 {
                    limb0: 0x6e8deb79e11edc2247e4d210,
                    limb1: 0xb0d8030010f4a8cc9bb0af7e,
                    limb2: 0xda7788e23f5a32a68a572f84,
                    limb3: 0x35515362acfe6a894cff4fe
                }
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0xe586274a3bb56276276cbbb5,
                    limb1: 0xf4f86a353c16e69c431493a7,
                    limb2: 0xca4818eb04b62df0b796fb9b,
                    limb3: 0xabba155d23d367593e0d4fa
                },
                y: u384 {
                    limb0: 0xadabca4b55ecf626876dfdc6,
                    limb1: 0xe33a624fef3596f7cac86f90,
                    limb2: 0x21f7f818ad0ad10bf9789291,
                    limb3: 0x19302d1809a2409b24bdf5b
                }
            },
            SumDlogDivLow: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xde3bbe356487094fbb2ace3a,
                        limb1: 0x17e1e0a2bc78fd63e7fb792b,
                        limb2: 0x31f514139997329ed7c488cf,
                        limb3: 0x1c9bd6b6165c3ef4e55aaba
                    },
                    u384 {
                        limb0: 0xffaeeba55d2b920270de6de0,
                        limb1: 0xb39869507b587b12479b0b98,
                        limb2: 0x21a5d66bb23ba5c279c2895f,
                        limb3: 0xd0088f51cbff34d258dd3db
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x6be47b57aaba1bf074749b4d,
                        limb1: 0x7ff7cb77c2ec23168ff8533f,
                        limb2: 0x9ae96f1069a550b356223d63,
                        limb3: 0x16cc9c4dc1349c4772d68fce
                    },
                    u384 {
                        limb0: 0x6cd1289396deea3dc1ab5b4,
                        limb1: 0x4303fd8829a772b7dc447e45,
                        limb2: 0xff43fa1bcb983cc4fc1375b0,
                        limb3: 0x19c410336044a4e355c1507d
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x676b639ae4cd5d6fa6bf6e16,
                        limb1: 0xc4041bbf06254531a3b34b1d,
                        limb2: 0xac43d7a681821d1322a31179,
                        limb3: 0x13052a1eaddde2aa048e989c
                    },
                    u384 {
                        limb0: 0xb12720b5163d1feffc519fb1,
                        limb1: 0x9553f30c3a350d7e0c8b52f9,
                        limb2: 0xfc7e74269bd81745908b62f,
                        limb3: 0x6f37f80b0f31c4d22512ebd
                    },
                    u384 {
                        limb0: 0xcbdb9b8a5e25c1e382edbb40,
                        limb1: 0x6e15bf5bdad1bb3f9b829fc4,
                        limb2: 0xbfc24ca9e91346669b4a4213,
                        limb3: 0xf36f1fc70288f568941c042
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x9b95ed5f7ceb6fc1d1d36d33,
                        limb1: 0xca4cb5fc279da9ede3dd4d01,
                        limb2: 0xa1c2b5bb792f603e7df9bd4f,
                        limb3: 0xd2f3b785852bd4eea074817
                    },
                    u384 {
                        limb0: 0x7384a25b7baba8f706bd6cf,
                        limb1: 0xd67d7e3dc28ae873150df918,
                        limb2: 0x332ce1e900fb108515be9e82,
                        limb3: 0x190d0b0ed492dfbe75b24ad5
                    },
                    u384 { limb0: 0x4, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x6be47b57aaba1bf074749b4d,
                        limb1: 0x7ff7cb77c2ec23168ff8533f,
                        limb2: 0x9ae96f1069a550b356223d63,
                        limb3: 0x16cc9c4dc1349c4772d68fce
                    },
                    u384 {
                        limb0: 0x6cd1289396deea3dc1ab5b4,
                        limb1: 0x4303fd8829a772b7dc447e45,
                        limb2: 0xff43fa1bcb983cc4fc1375b0,
                        limb3: 0x19c410336044a4e355c1507d
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHigh: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xf073d7034f2aa59ce8c12fd5,
                        limb1: 0x62123206f51aea29cc284e55,
                        limb2: 0x12bdfb925fe6222b0899fc89,
                        limb3: 0x1026ede19c0381640beb8a36
                    },
                    u384 {
                        limb0: 0xe64fbcea39be4b8c8a67957a,
                        limb1: 0xb39869507b587b12385fa0fc,
                        limb2: 0x21a5d66bb23ba5c279c2895f,
                        limb3: 0xd0088f51cbff34d258dd3db
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x198e510b2310a6d8800151ec,
                        limb1: 0xe7b81343b6db63ffdced6cd9,
                        limb2: 0x6626ab8a07fc2d832747ec0b,
                        limb3: 0x18e7af86cfae3bc5478861df
                    },
                    u384 {
                        limb0: 0x8234d853dd1549c7b12c4808,
                        limb1: 0x95fa4dafdf483dc56cf8deb5,
                        limb2: 0xbbebdaad3a6e8a0247a357bd,
                        limb3: 0x292868ae1a11ad1fc1d0775
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x93de77ee84620a00be4e5d1e,
                        limb1: 0x4d5eeb6aff01c0cb660d28e8,
                        limb2: 0xc45247d437af82575fad30c1,
                        limb3: 0x110f52b30db27b15b7823d95
                    },
                    u384 {
                        limb0: 0xaa2d1201f1a1c3f6146389d0,
                        limb1: 0xe94b490a55429bae2301f6de,
                        limb2: 0x307ec5e33015ad2342a5b49f,
                        limb3: 0xc587d788e001e2eb8cac32e
                    },
                    u384 {
                        limb0: 0xe4612b5206e10fc781422f07,
                        limb1: 0xcac8b9d3cccb4702aef239fe,
                        limb2: 0x70e0ef937d05e416d8608992,
                        limb3: 0xc646ac47fbad02e82601e3e
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x523d442d5e459b62000647af,
                        limb1: 0x694dd52bf75aad9317b1b368,
                        limb2: 0xceb7a7a1f28ad37dc29077f1,
                        limb3: 0x159b885c92393b463cce905a
                    },
                    u384 {
                        limb0: 0x8d3614f7455271ec4b12020,
                        limb1: 0x57e936bf7d20f715b3e37ad6,
                        limb2: 0xefaf6ab4e9ba28091e8d5ef6,
                        limb3: 0xa4a1a2b86846b47f0741dd6
                    },
                    u384 { limb0: 0x4, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x198e510b2310a6d8800151ec,
                        limb1: 0xe7b81343b6db63ffdced6cd9,
                        limb2: 0x6626ab8a07fc2d832747ec0b,
                        limb3: 0x18e7af86cfae3bc5478861df
                    },
                    u384 {
                        limb0: 0x8234d853dd1549c7b12c4808,
                        limb1: 0x95fa4dafdf483dc56cf8deb5,
                        limb2: 0xbbebdaad3a6e8a0247a357bd,
                        limb3: 0x292868ae1a11ad1fc1d0775
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHighShifted: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x15345bc8228c6953972e7fb5,
                        limb1: 0x90a56e3e75049c73c778013d,
                        limb2: 0x6ce023df48bb06e82431cc97,
                        limb3: 0x14befd64ce8cdf223f110dd1
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
                        limb0: 0xd259e77237b64c0912d2e959,
                        limb1: 0x3ddf883d9dfe3b0728247d50,
                        limb2: 0x3d6d0ac91d22e93e73a0a50d,
                        limb3: 0xb748078b3bd9b821e04d257
                    },
                    u384 {
                        limb0: 0xb9423d84925f1ac6d3cbc89e,
                        limb1: 0xe96e45b78e2794284e1a8404,
                        limb2: 0x66117adb6fd47e6458ffa001,
                        limb3: 0x7b308441043a1ced29d989c
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x8a26d881f722a1fd7babffc8,
                        limb1: 0x25e2e20ffaab986e89902ddf,
                        limb2: 0x44671412ee865b93cbaaab89,
                        limb3: 0x14db8e210cb3522bb414d443
                    },
                    u384 {
                        limb0: 0x2aa158105b7169b0ad674f5a,
                        limb1: 0x12ee7028c66db82d8c6c3bd3,
                        limb2: 0xdd4050f9188c8a74037758fd,
                        limb3: 0x10b726ac30d08d1a891e3279
                    },
                    u384 {
                        limb0: 0x9aa6063bfcbe9c862e9cd7d9,
                        limb1: 0x84850ae8c2e6a7a5fb38c6d2,
                        limb2: 0x59c9a812019a8abb43c02062,
                        limb3: 0x15d19d2aa1dc8697983a1aed
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x98139dc924da30244b4bfab9,
                        limb1: 0x904d4e558147f5f881e5f544,
                        limb2: 0xb2687e4d10145974dafd8175,
                        limb3: 0x13d0eff89576876e2cf7a1a6
                    },
                    u384 {
                        limb0: 0x33b4f6128f7d6b1b4f2f77cd,
                        limb1: 0x3e88443d41ed5a7d19be1014,
                        limb2: 0x54fa3e965adaae0c70796d48,
                        limb3: 0x4cb0f26078ea0a0ff5ababb
                    },
                    u384 { limb0: 0x4, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0xd259e77237b64c0912d2e959,
                        limb1: 0x3ddf883d9dfe3b0728247d50,
                        limb2: 0x3d6d0ac91d22e93e73a0a50d,
                        limb3: 0xb748078b3bd9b821e04d257
                    },
                    u384 {
                        limb0: 0xb9423d84925f1ac6d3cbc89e,
                        limb1: 0xe96e45b78e2794284e1a8404,
                        limb2: 0x66117adb6fd47e6458ffa001,
                        limb3: 0x7b308441043a1ced29d989c
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x8e05385453b866e34a1a79d1,
                limb1: 0x9ee7158d0fef825b6e3d6717,
                limb2: 0x7ffec29f03bbea8c5c2dbb1b,
                limb3: 0xbe4af3c905ff9cdae717efb
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0x3ddb8709e1170551509b5c55,
                    limb1: 0x9e1f9f362aeb0237c4bb364,
                    limb2: 0x941753ac67c9711d675d13b1,
                    limb3: 0x9728f3e5fb93d14b4798f58
                }
            ],
        };
        let res = msm_g1(
            points, scalars, scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, 1
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0xe90d6f1c5c0fc2b9d430b19a,
                    limb1: 0x69a3825b494fd757ae4286ef,
                    limb2: 0xf87e22ceb996ce6560031d77,
                    limb3: 0xe11e54c6f53444283205fe6
                },
                y: u384 {
                    limb0: 0x46626c2a0b43028227ac8300,
                    limb1: 0x7309955351a89c2bd2794f98,
                    limb2: 0x534426e3cea008d109b19299,
                    limb3: 0x168104077f22c64efc456ecf
                }
            }
        );
    }


    #[test]
    fn test_msm_SECP256R1_1P() {
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x88409c0c11d4c33ee3bfca1f,
                    limb1: 0xc942601a8bdd411b44ca4ab3,
                    limb2: 0xb9c1794cc3136bb,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xc6cb6cff3c362c726afae0ed,
                    limb1: 0xfcc3a1e29eb753066f257414,
                    limb2: 0x9c553cd9a2851f2b,
                    limb3: 0x0
                }
            },
        ]
            .span();
        let scalars = array![
            u256 {
                low: 0xb5a6c77772c59059763d0f962ecb0e17, high: 0xb134f1c74ed084869ce14c927f56d7c3
            },
        ]
            .span();
        let scalars_digits_decompositions = Option::Some(
            array![
                (
                    array![
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                    ]
                        .span(),
                    array![
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
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
                    limb0: 0x5e258f45f4c3a5020f1af4d,
                    limb1: 0xffae7a64a7a0f13d3d772f58,
                    limb2: 0x3d8979e902bfcc5c,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x1dc6a84b2c58cacea1432155,
                    limb1: 0x44464ab61aa3fd8c71b5e39f,
                    limb2: 0xabc2dde7ae603288,
                    limb3: 0x0
                }
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x52d95d286f74d89464c8925,
                    limb1: 0x419aa38e80f55430de122477,
                    limb2: 0x8bad2a4aef005934,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x1de5a6dbdf5d52d837b07d19,
                    limb1: 0x99c27546be140efb2f896579,
                    limb2: 0x1f76426517ec5450,
                    limb3: 0x0
                }
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x2ddc17bbb53b4d992621716a,
                    limb1: 0x751e7456b63ac0f269c72d99,
                    limb2: 0xa94f28756f0663b3,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x897d126c27bde545d77e84a5,
                    limb1: 0xde3f33228b6f848cb671d9a3,
                    limb2: 0x78dd1a12ba9b5ded,
                    limb3: 0x0
                }
            },
            SumDlogDivLow: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x4f6773c14f661fcd5afe5e36,
                        limb1: 0xb58cc9375ca040d4ff2f24f1,
                        limb2: 0x3b0cc5baf547bbbd,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x658ba3466742de0eaf58b799,
                        limb1: 0xffffffffffffffff7bfd2c26,
                        limb2: 0xffffffff00000000,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x3538602991f9a1c599233097,
                        limb1: 0x45912247749830abd0780008,
                        limb2: 0xadeb4ee8706f5c5b,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x71dd0aff8edf0270fb4e8693,
                        limb1: 0x370f2580cc81cda77dbe85f5,
                        limb2: 0xb6da6e81310efce8,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x4498c80f71b1c362e49a64ad,
                        limb1: 0xe49597234bf77aa6b012bd04,
                        limb2: 0xa939bfd5a67083e2,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x34c10328003bf08388c22aba,
                        limb1: 0x5b67695f649d9cc0e5de8bd5,
                        limb2: 0x3904f1b38839c994,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x6c08417207360aa35da277a1,
                        limb1: 0x1a6772356c6b96e3751a49d1,
                        limb2: 0x1ce011df77383e26,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x7f29a991dd4bd60a2c637b81,
                        limb1: 0x65e298da77dddf92dfbbd573,
                        limb2: 0x2fd89792e94feb3e,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xc85aab3e7bf054b84861dc4,
                        limb1: 0xb95a213d3ab9df1a07e92e57,
                        limb2: 0x1fd72ca8bfb11a76,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x76bc8ff78f3134eb35e6cc90,
                        limb1: 0xebe4cd311131dc5ebe174d2,
                        limb2: 0x3636ea53170d9d31,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x3538602991f9a1c599233094,
                        limb1: 0x45912247749830abd0780008,
                        limb2: 0xadeb4ee8706f5c5b,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x71dd0aff8edf0270fb4e8693,
                        limb1: 0x370f2580cc81cda77dbe85f5,
                        limb2: 0xb6da6e81310efce8,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHigh: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x976360a1094e57d185bf1ffb,
                        limb1: 0x81b0be3586d90c8475d0f661,
                        limb2: 0x328932a4f660c769,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xcea1c17e30a21c8590b4730a,
                        limb1: 0xffffffffffffffff82714c85,
                        limb2: 0xffffffff00000000,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xdce608722014286d982cc2b1,
                        limb1: 0xb695a7c433154019574008f4,
                        limb2: 0xee433a855023d36b,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x7291ce216733ef37d5f3acbb,
                        limb1: 0xf522fc56f32d6ab3dd2390d6,
                        limb2: 0x68b6be1f44ce7010,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x2e1b146eedfafd03a73d9b4e,
                        limb1: 0xa9b0bf65d6b94f898ce3c92,
                        limb2: 0x18c87f882edec632,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x75c9c3e1558430d6328ba78f,
                        limb1: 0xa06d78cd4881d781a818e53e,
                        limb2: 0xe7d8b622feaef6ad,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xbeae0bf232695c643f784a98,
                        limb1: 0x2ab582ed9d3baf55a7a34e9b,
                        limb2: 0x6f16e60897788c08,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x60bd0f275ac7be4413fda604,
                        limb1: 0x40d82c4b904969d8b28d7154,
                        limb2: 0xc7ea7097e94e852a,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xfc06985e8f529aba3706c7f6,
                        limb1: 0x68156f79b403e221a557cf04,
                        limb2: 0x2f2e9b08ee1559b6,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x749e469206326e96a5f75a19,
                        limb1: 0xd482c8509d1046a0cdb2542e,
                        limb2: 0x20a1fb79dbcf43b5,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xdce608722014286d982cc2ae,
                        limb1: 0xb695a7c433154019574008f4,
                        limb2: 0xee433a855023d36b,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x7291ce216733ef37d5f3acbb,
                        limb1: 0xf522fc56f32d6ab3dd2390d6,
                        limb2: 0x68b6be1f44ce7010,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHighShifted: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xd666a4cc5741800e1a1599f2,
                        limb1: 0xeb5345b9f338c13f89ea363a,
                        limb2: 0x753c60cdaa56a5ab,
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
                        limb0: 0x3c5ea1837bec77031a654275,
                        limb1: 0x7b409c88d3a27c62894d2976,
                        limb2: 0x521ac16f754fffde,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xccf65271c3cd64dd9392056f,
                        limb1: 0x4946e81ac8cfeadcb826adf1,
                        limb2: 0xcb03ad3da1f9431a,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x7448af6a4d703a346b2ae18,
                        limb1: 0x2bf0aa17d89579e52e6a6d1a,
                        limb2: 0x9b52a16f1e189040,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xd614be57bb74d67d106fb047,
                        limb1: 0xd20315fbd48256aba827e70e,
                        limb2: 0xce9f7471e39a7e5b,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xe3baab9cf69731a9b86a9d7c,
                        limb1: 0x412e08d5ecba98a2c1ca4746,
                        limb2: 0x38f739cec4cb1b3e,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x1df18ea97f755ffb0d399f7b,
                        limb1: 0xbcb2d4174a3fe9adc0a8863a,
                        limb2: 0x54c59ee8b1df23ca,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x9d22f8e542f2ad801c04ac2a,
                        limb1: 0x882cc1746160bd93f62c4b27,
                        limb2: 0xacf7241018daf107,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x6570b9a0f0660da56d1c4ffb,
                        limb1: 0xd81705051c28c6263ca8fcde,
                        limb2: 0xf9bb2e1cc44eca9b,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x3c5ea1837bec77031a654272,
                        limb1: 0x7b409c88d3a27c62894d2976,
                        limb2: 0x521ac16f754fffde,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xccf65271c3cd64dd9392056f,
                        limb1: 0x4946e81ac8cfeadcb826adf1,
                        limb2: 0xcb03ad3da1f9431a,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x81a69d8239570164d086c6e,
                limb1: 0x14a433acb695d7e785599a28,
                limb2: 0x6448f207a2e1b4d6,
                limb3: 0x0
            },
            g_rhs_sqrt: array![],
        };
        let res = msm_g1(
            points, scalars, scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, 3
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0xa80bbecb0f04a9656cd06302,
                    limb1: 0x9bd36cef8128413caf320650,
                    limb2: 0xb956680a66a41c91,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xe225b4a735d82f1aa1995a8f,
                    limb1: 0x9f2f17e93a0a7afbcd7c2dc1,
                    limb2: 0xa4651bb87cfd6283,
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
                    limb0: 0x827ccdeff3da17ba4ec484c1,
                    limb1: 0xeb8d0ac6e3aec2d5f6d40a50,
                    limb2: 0x919ac848d1db1c32,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xf8ed4fe780185476ea3cfee0,
                    limb1: 0x4b706f0ea28ef19e022f262d,
                    limb2: 0xc7bd150afabf6a85,
                    limb3: 0x0
                }
            },
        ]
            .span();
        let scalars = array![
            u256 {
                low: 0xfc508474fd2170c814d24a17f272c353, high: 0x73e8af31ab9c3afc1cb123216515c7d8
            },
        ]
            .span();
        let scalars_digits_decompositions = Option::Some(
            array![
                (
                    array![
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                    ]
                        .span(),
                    array![
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
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
                    limb0: 0xb3cd6401408ddb7e759ba87c,
                    limb1: 0xd6d445e51a316ec6bf64ac91,
                    limb2: 0x9380cffe104df76a,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xcf8d6467b4601a2616fc3f,
                    limb1: 0x6efc7eb2403722557eeb485b,
                    limb2: 0x48b7858a731fb19e,
                    limb3: 0x0
                }
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x7783780948c945889f20faca,
                    limb1: 0xe0e532ada1eaeba5d1e0c701,
                    limb2: 0xb9f3c6f445545638,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x8a80fa7bd8af8aea64dc5c7f,
                    limb1: 0x7a417265a14ccbebc38a835c,
                    limb2: 0xb3f9a2b40729e76,
                    limb3: 0x0
                }
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x451bb16f3d4f96f4694e28f4,
                    limb1: 0xc931abee8bc70c03586d4a50,
                    limb2: 0xed73936b41de9e58,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xdb812cf29186362daaae0b44,
                    limb1: 0xdb72f0052fdad8e2a71066c,
                    limb2: 0xb6ed450a6d313c83,
                    limb3: 0x0
                }
            },
            SumDlogDivLow: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xd71ac717a131dae13a3ef044,
                        limb1: 0x6bc19a01de8c223ab205c8fb,
                        limb2: 0x4c92fa6bcedc3c1c,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xa01ce1681c80f34ba55ef6d,
                        limb1: 0xffffffffffffffff82ede3b4,
                        limb2: 0xffffffffffffffff,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x77387d1e93c82852a4f2dace,
                        limb1: 0xf2e8ba997866c8307ee617ca,
                        limb2: 0x5d298b158e3c2155,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xc9b5ce0ecb980cc53b9fcb21,
                        limb1: 0x3d9eaf54021fce6349c7491d,
                        limb2: 0xdae467b91dd6ec62,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x4b7442e3c76f6610d6908cde,
                        limb1: 0xe151f9e84137c40d168f4525,
                        limb2: 0xc5773ed53e199e8d,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x38fea3541357ba53b3f960d6,
                        limb1: 0x39682cb02fe063b7eaf95430,
                        limb2: 0x93a83db59892ff58,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x7b190fa5c52cde612ce96282,
                        limb1: 0x91a4ff3dcf397acad5ac9734,
                        limb2: 0xd7b6337c8a333659,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x428b6bd60a791a4482a40344,
                        limb1: 0xa45d1a324acf7953784aa689,
                        limb2: 0x8c22cd96e3a4e959,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x83f8a26791285969a15ea0fc,
                        limb1: 0xaf56cb4c0edea4b70472ffd0,
                        limb2: 0xfc3ed60fd0e076af,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x7, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x77387d1e93c82852a4f2dace,
                        limb1: 0xf2e8ba997866c8307ee617ca,
                        limb2: 0x5d298b158e3c2155,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xc9b5ce0ecb980cc53b9fcb21,
                        limb1: 0x3d9eaf54021fce6349c7491d,
                        limb2: 0xdae467b91dd6ec62,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHigh: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xc3c3e72d1dd4431bef665573,
                        limb1: 0x4956d829d72a6a73615607dc,
                        limb2: 0x9752680048285b42,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x7cf791414e7e3c2bcab23c6c,
                        limb1: 0x3565b01a,
                        limb2: 0x8000000000000000,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x54dc6cd1c9ad8d35ee2d6906,
                        limb1: 0x52bff546878ce3c993e7c6ef,
                        limb2: 0x4b41e85060a3296b,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x5ffba06c35ca2bb121a78d3,
                        limb1: 0x338dc28b7a665184374b2eae,
                        limb2: 0xb47170c2e8d08d94,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x7e65df04b439ada3648ed138,
                        limb1: 0x1c66173d05278b2c253c3b95,
                        limb2: 0x656e987393972a77,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x3e97c0cadc3140ab3e9900c1,
                        limb1: 0x5102766e32f51165c19bdab3,
                        limb2: 0x3703bf9bb5aa0db3,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x523cbf10a3e7dadf8b5c4b75,
                        limb1: 0x6db6040a311bff13d3259c38,
                        limb2: 0x53beffe000d8321,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x5206f9bc83bedc7b833de6cc,
                        limb1: 0x433fb4edb4da3a830b56708b,
                        limb2: 0xecd5a32a47621ef,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x29fe162f578873217eb95d09,
                        limb1: 0x68e051d058cc3a9d830e46c2,
                        limb2: 0xef1a15545db3df0d,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x7, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x54dc6cd1c9ad8d35ee2d6906,
                        limb1: 0x52bff546878ce3c993e7c6ef,
                        limb2: 0x4b41e85060a3296b,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x5ffba06c35ca2bb121a78d3,
                        limb1: 0x338dc28b7a665184374b2eae,
                        limb2: 0xb47170c2e8d08d94,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHighShifted: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x9ecd85eb80834073179586bb,
                        limb1: 0x8af1c2f2384f86ac3434121f,
                        limb2: 0xa4f1b8c1e4842a23,
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
                        limb0: 0x5bea50d9800dd521949ab19d,
                        limb1: 0x9926e26307ab07955b6936c3,
                        limb2: 0x70c2fb71ba7c77db,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x4360d68779e72380f790d4a0,
                        limb1: 0x55e92163d24e0856d5b1eeae,
                        limb2: 0x5898a5a078cd0b6e,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xda1943bdd1a18ff3b83d700b,
                        limb1: 0xfc32e03aa35f2fd2a9235c8c,
                        limb2: 0xebb398ad1f2a57d,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x399b45459c8f2db759714c25,
                        limb1: 0x3e287571b265c2c5a4061d63,
                        limb2: 0xb08383ec3da206ae,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x447162b0748d7acb5d0e2b15,
                        limb1: 0xc34cf7f35142bd28355c0dd2,
                        limb2: 0x6f842a509780cae,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x836835f28060d3ee103ae6be,
                        limb1: 0x301030b535ad35157fe07f57,
                        limb2: 0x1554e01c19674701,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xd7a5ddb45551f888c4f5d802,
                        limb1: 0x595fe9bac0223a5fd7dd86c3,
                        limb2: 0x6c2c87634d9b5004,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x7, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x5bea50d9800dd521949ab19d,
                        limb1: 0x9926e26307ab07955b6936c3,
                        limb2: 0x70c2fb71ba7c77db,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x4360d68779e72380f790d4a0,
                        limb1: 0x55e92163d24e0856d5b1eeae,
                        limb2: 0x5898a5a078cd0b6e,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x81d4881f2be100187837894d,
                limb1: 0x858a62dafa9e8a50f3d6e6bd,
                limb2: 0x23387c46a2509c07,
                limb3: 0x0
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0x3facf9e4537df92d9df9f0b5,
                    limb1: 0x1d73db84a9ef5bcdaa446f56,
                    limb2: 0x33cfdd199aaa3e4d,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x8327328c81a9e28993972b2d,
                    limb1: 0xc5f137f1f22c55ac0c61d63c,
                    limb2: 0x7910a6322f83d31b,
                    limb3: 0x0
                }
            ],
        };
        let res = msm_g1(
            points, scalars, scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, 2
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x9c39a0c2e98f208ef4fc1a2c,
                    limb1: 0xda148cc548d9aef9297aea9e,
                    limb2: 0x5556c614134dda65,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xea667c2e6967c4d78930a365,
                    limb1: 0x32ed4b219e26a38c5c5b1ee8,
                    limb2: 0xd2adf1597c01cb35,
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
                    limb0: 0x34c600e98890cd0f7ad3c0f,
                    limb1: 0x5b87876dcca243161f30fd01,
                    limb2: 0x7c57482c9f3bcbe6,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xc35e0173e55ce3fd4fc7086a,
                    limb1: 0x4e0a972db645c6e3b13ed7c6,
                    limb2: 0x70a795030a3ba240,
                    limb3: 0x0
                }
            },
        ]
            .span();
        let scalars = array![
            u256 {
                low: 0x67a33ea06b5ce7d57e9329cb7e0f202a, high: 0xb4aa226183d24a4cdbfa1686784fa11
            },
        ]
            .span();
        let scalars_digits_decompositions = Option::Some(
            array![
                (
                    array![
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                    ]
                        .span(),
                    array![
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
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
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
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
                    limb0: 0xf90e12aa5e73432e5660be59,
                    limb1: 0x4c6899b54b2e80688e010774,
                    limb2: 0x5a5b1e57cfe73075,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xe34b36e79a0f450f52e8e7c8,
                    limb1: 0x33aaac7189136db3466862b8,
                    limb2: 0x5c8071aba9a4223c,
                    limb3: 0x0
                }
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x4515bde61ec937271b2b3549,
                    limb1: 0x3fc8bf4d1ad48e6534c1f555,
                    limb2: 0x306adc6b9c436994,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x2cea82a8c500520c0d60cae0,
                    limb1: 0xbaf5bc5a85da91290d1d54e4,
                    limb2: 0x2de0e677d96e72ed,
                    limb3: 0x0
                }
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0xe24ddbdd351a7de70a4aae21,
                    limb1: 0xbac2d91706f269d190005766,
                    limb2: 0x7b040039e90085a6,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x34de2b33a05c3d201a56c9df,
                    limb1: 0xb2328d65475761c89db2c03e,
                    limb2: 0x51b70b21fbfcc333,
                    limb3: 0x0
                }
            },
            SumDlogDivLow: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xdb2b78f85afb1339d6639db0,
                        limb1: 0xc23dfc6c3066e0fa4a5f6c2c,
                        limb2: 0x13de000295506109,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x8d61cfa8edec07f013ba4b61,
                        limb1: 0x3b8c9a37,
                        limb2: 0x4000000000000000,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xa1b773827d4a0f4a1bdba422,
                        limb1: 0x26820379aeb05a4cea4b5503,
                        limb2: 0x69ee772ae9b593d,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x3a58d470903b000b1f20572,
                        limb1: 0x580fdedce82f3c8152cdfb8a,
                        limb2: 0x294d997b90dd03a4,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xd58e919f428c9fd12f5cc999,
                        limb1: 0xe3a41980d286be140404b403,
                        limb2: 0x52557539c831393a,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xab137d3d07309c4a934e3f73,
                        limb1: 0xe79d6d2f92bf470e534c0fa7,
                        limb2: 0x7d0223be5b0fe5ea,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x6fc26e0623c15e2cd737a93e,
                        limb1: 0xb487858b060cefbe7aa40896,
                        limb2: 0x353f43eb33ec6644,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x90259af1cf39b3ef7031b549,
                        limb1: 0x6c1f14ee3a48d41b06785722,
                        limb2: 0x33a72f3912e2b35a,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xff745fb33039c0176f5bf0fa,
                        limb1: 0x8452cb8e31e4ed0ab95b58f9,
                        limb2: 0x14cbedf66c9bae4,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x69548fd44a5e4492e9f8487f,
                        limb1: 0x37bcf42698ad411750899c38,
                        limb2: 0xf0c199feca9c001,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xae5c9e7a29bbf0d91497bb4f,
                        limb1: 0x5819e487102b982356040b60,
                        limb2: 0x63ed944654551823,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x3a58d470903b000b1f20572,
                        limb1: 0x580fdedce82f3c8152cdfb8a,
                        limb2: 0x294d997b90dd03a4,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHigh: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xbca779a66dd20da910598c81,
                        limb1: 0x681992c02ad5799065914cfa,
                        limb2: 0x1f82a4ba9585100e,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x9d2f8f4e2613fc18d8f06b97, limb1: 0x6b5ad86, limb2: 0x0, limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x8d8f093aaa638e06e8c37237,
                        limb1: 0xf89f39c26c7a7cf254a07dbd,
                        limb2: 0x3806970241991a44,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xb79de20b48adbc07ed278e82,
                        limb1: 0x64afb94518892e84ac0d0da9,
                        limb2: 0x533ddb67c480ca85,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x6b39809bc301a801d8131c5b,
                        limb1: 0x3af418b32f8ace251fc5b79a,
                        limb2: 0x44bac0869de1cdbf,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x9bd1971c3b82cf08b00ab0bc,
                        limb1: 0x3df0754b2745d3b37f13190e,
                        limb2: 0x3c32d8b866f2004f,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xc0321f02ede93dbe4fe51937,
                        limb1: 0x607703d3ce21dac62f252d13,
                        limb2: 0x213ca224f431796f,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x83e0d550c19a9357d1270fd4,
                        limb1: 0x69da8e4d60f0be7b5878b92,
                        limb2: 0xf9fb2df8d9e03ff,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x3824494c76a1fdf62500e49b,
                        limb1: 0x1102f6e6276bf3b6988484ae,
                        limb2: 0x31240842f06d4a32,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x430f80e149f7c7f3829a0d07,
                        limb1: 0x67ec8688a8b4dfba15ac5411,
                        limb2: 0x6ea361f6864eebcf,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x9a34343256d56f95e17f8977,
                        limb1: 0x2a371acfcdf5bac8c059341a,
                        limb2: 0x155543d5e752d92b,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xb79de20b48adbc07ed278e82,
                        limb1: 0x64afb94518892e84ac0d0da9,
                        limb2: 0x533ddb67c480ca85,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHighShifted: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xa7d6352a28ca1816754c7348,
                        limb1: 0x839a420a25872b4673527bd9,
                        limb2: 0x8563f058d019260,
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
                        limb0: 0x4798ae9ce29ef27a888ab22b,
                        limb1: 0xc5852013c8bd1fc4da8678fa,
                        limb2: 0x2ba3e9fc630433e3,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xd89c663cac1c4af1da8a1c70,
                        limb1: 0x574679bde3907c93b3db343,
                        limb2: 0x5491235a7abc10c5,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x95e9936efe69d5b47e463325,
                        limb1: 0xf19bd33ec2fab1727f5590f4,
                        limb2: 0x7ca49d21c36c9f3b,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x42b2b4d8290674161cf7844c,
                        limb1: 0x446476a90c8511731cb3d42f,
                        limb2: 0x5ca33e3206ee1400,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x6b06ff583331121ed1fac49a,
                        limb1: 0x40b51f8c97f7490e9df6e9a6,
                        limb2: 0x7a9754821e5ea093,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x666308a3e8333322f3d021b1,
                        limb1: 0x17e5488b89e1db4afb35465a,
                        limb2: 0x714e877653e6cc50,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x400b3262c3e64035b219776a,
                        limb1: 0xeda4603566159b3ea0ec4002,
                        limb2: 0x26999baec88951d8,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x801753c70cb526807a5d5b32,
                        limb1: 0xfc66aa03a16bbfb20009bb21,
                        limb2: 0x29249be9eb09b0ae,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x543dd9948f10d4098146c96b,
                        limb1: 0xf71d01212a385d9b463f2f57,
                        limb2: 0x8f296d008bdf2c9,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xd89c663cac1c4af1da8a1c70,
                        limb1: 0x574679bde3907c93b3db343,
                        limb2: 0x5491235a7abc10c5,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xf718b526c30b8d3826ca0316,
                limb1: 0xa61689495727b640c81ced40,
                limb2: 0x325fb8c60f0059e4,
                limb3: 0x0
            },
            g_rhs_sqrt: array![],
        };
        let res = msm_g1(
            points, scalars, scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, 4
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x78ba7bbc4b4502891eedd274,
                    limb1: 0xdfb898a1b1439615686e53cf,
                    limb2: 0x2ab6865b984d660b,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xbc694c1a4626d37601113135,
                    limb1: 0x8b4fcad20e4981b920d97587,
                    limb2: 0x40965771db560412,
                    limb3: 0x0
                }
            }
        );
    }
}
